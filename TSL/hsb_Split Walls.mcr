#Version 8
#BeginDescription
Automatically splits and generates walls based on maximum length, distance to openings, connections and wall edges

Last modified by: Chirag Sawjani
Date: 10.09.2018  -  version 1.10



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 10
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2008 by
*  hsbSOFT 
*  IRELAND
*
*  The program may be used and/or copied only with the written
*  permission from hsbSOFT, or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*
* REVISION HISTORY
* -------------------------
*
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 10.10.2008
* version 1.0: Release Version
*
* date: 12.10.2008
* version 1.1: Complete Split base on Wall Lenght
* date: 29.10.2008
* version 1.2: changes to Working with openings
* date: 30.10.2008
* version 1.3: Descriotion Added to each property
*
* Modify by: Alberto Jena (aj@hsb-cad.com)
* date: 00.06.2009
* version 1.4: BugFix when the walls were to small and couldnt find a valid split Point
*
* date: 04.04.2011
* version 1.5: Add Generation of the selected and splited walls
*
* date: 26.05.2011
* version 1.6: Added restriction to length of string sent to stack and multiple commands sent to stack instead of one. Bugfix Command accepts only 160 odd characters.
*
* date: 24.01.2012
* version 1.7: Allow to split any wall, not only SF Elements
*
* date: 13.06.2012
* version 1.8: Add a property so it will will allow the user to frame or not after spliting
*
* date: 23.08.2012
* version 1.9: Fix issue with the minimum size from the wall edge
*
*/

Unit(1,"mm"); // script uses mm
double d1mm = U(1, 0.0393701);
double d70mm = U(7, 2.75591);
double d300mm = U(300, 11.811);
double d3600mm = U(3600, 141.7323);

String sArNY[] = {T("No"), T("Yes")};

PropDouble dMaxWallLength (0, d3600mm, T("Max. Wall Length"));
	dMaxWallLength.setDescription("The Length entered here will be the max length that any wall can be.");
	
PropDouble dDistanceToWindow(1, d300mm, T("Min. Distance to Opening"));
	dDistanceToWindow.setDescription("This is the min distance that any wall will split to an opening.");
	
PropDouble dMinDistanceToWallEdge(2, d300mm, T("Min. Distance to Wall Edge"));
	dMinDistanceToWallEdge.setDescription("This is the min distance that any wall will split to the end of a Wall.");
	
PropString sGenerate(0, sArNY, T("|Frame walls after split|"), 1);
int nGenerate= sArNY.find(sGenerate, 0);

// Load the values from the catalog
if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

if(_bOnInsert)
{
	if (insertCycleCount()>1) { eraseInstance(); return; }
	if (_kExecuteKey=="")
		showDialogOnce();
	
	PrEntity ssE(T("Please select the elements"),Element());
 	if (ssE.go())
	{
 		Entity ents[0];
 		ents = ssE.set();
 		for (int i = 0; i < ents.length(); i++ )
		 {
 			Element el = (Element) ents[i];
			if (el.bIsValid())
	 			_Element.append(el);
 		 }
 	}

	if (_Element.length()== 0)eraseInstance();
	
	return;
}//End On Insert

if (_Element.length()<1)
{
	eraseInstance();
	return;
}

Element elAll[0];
elAll.append(_Element);

Element elToFrame[0];

for (int e=0; e<elAll.length(); e++)
{
	
	Element el= (Element) elAll[e];
	if (!el.bIsValid())
	{
		//eraseInstance();
		continue;
	}
	CoordSys cs=el.coordSys();
	Vector3d vx=cs.vecX();
	Vector3d vy=cs.vecY();
	Vector3d vz=cs.vecZ();
	
	Vector3d vecDirection=vx;

	Point3d ptElOrg=cs.ptOrg();
	vecDirection.vis(ptElOrg, 1);

	Line lnX (ptElOrg, vecDirection);
	Line lnY (ptElOrg, vy);
	Line lnXCenter (ptElOrg-vz*d70mm, vecDirection);
	Plane plnBottom (ptElOrg, vy);
	Plane plnFront (ptElOrg, vz);
	PLine plOutWall=el.plOutlineWall();
	
	Point3d ptStartEl;
	Point3d ptEndEl;
	
	LineSeg lsEl=el.segmentMinMax();
	
	ptStartEl=lsEl.ptStart();
	ptEndEl=lsEl.ptEnd();
	
	ptStartEl=plnBottom.closestPointTo(ptStartEl);
	ptEndEl=plnBottom.closestPointTo(ptEndEl);
	
	Point3d ptSplit=ptStartEl;
	
	if (vx.dotProduct(vecDirection)<0)
	{
		Point3d ptAux=ptStartEl;
		ptStartEl=ptEndEl;
		ptEndEl=ptAux;
	}
	ptStartEl.vis();
	ptEndEl.vis();

		
	PlaneProfile ppAllNoValidAreas[0];

	//Collect the no valid areas of other TSLs
	TslInst tsl[]=el.tslInstAttached();
	for (int i=0; i<tsl.length(); i++)
	{
		if (!tsl[i].bIsValid())
			continue;
		if (tsl[i].map().hasMap("mpPL"));
		{
			Map mp=tsl[i].map().getMap("mpPL");
			PLine plPointLoad=mp.getPLine("plPointLoad");
		}
	}
	
	Opening opAll[]=el.opening();
	
	for (int i=0; i<opAll.length(); i++)
	{
		PLine plOp=opAll[i].plShape();
		Point3d ptVertexOp[]=plOp.vertexPoints(TRUE);
		ptVertexOp=lnX.projectPoints(ptVertexOp);
		ptVertexOp=lnX.orderPoints(ptVertexOp);
		ptVertexOp=plnBottom.projectPoints(ptVertexOp);
		ptVertexOp=plnFront.projectPoints(ptVertexOp);
		PLine plNoValidArea(vy);
		plNoValidArea.addVertex(ptVertexOp[0]-vz*d300mm-vecDirection*(dDistanceToWindow-d1mm));
		plNoValidArea.addVertex(ptVertexOp[0]+vz*d300mm-vecDirection*(dDistanceToWindow-d1mm));
		plNoValidArea.addVertex(ptVertexOp[ptVertexOp.length()-1]+vz*d300mm+vecDirection*(dDistanceToWindow-d1mm));
		plNoValidArea.addVertex(ptVertexOp[ptVertexOp.length()-1]-vz*d300mm+vecDirection*(dDistanceToWindow-d1mm));
		plNoValidArea.close();
		PlaneProfile ppNoValidArea (plNoValidArea);
		ppNoValidArea.vis();
		ppAllNoValidAreas.append(ppNoValidArea);
		
	}
	
	//Set the start of the element as a no valid Area
	PLine plNoValidAreaStart(vy);
	plNoValidAreaStart.addVertex(ptStartEl-vz*d300mm-vecDirection*(dMinDistanceToWallEdge-d1mm));
	plNoValidAreaStart.addVertex(ptStartEl+vz*d300mm-vecDirection*(dMinDistanceToWallEdge-d1mm));
	plNoValidAreaStart.addVertex(ptStartEl+vz*d300mm+vecDirection*(dMinDistanceToWallEdge-d1mm));
	plNoValidAreaStart.addVertex(ptStartEl-vz*d300mm+vecDirection*(dMinDistanceToWallEdge-d1mm));
	plNoValidAreaStart.close();
	PlaneProfile ppNoValidAreaStart (plNoValidAreaStart);
	ppNoValidAreaStart.vis();

	ppAllNoValidAreas.append(ppNoValidAreaStart);
	
	//Set the end of the element as a no valid Area
	PLine plNoValidAreaEnd(vy);
	plNoValidAreaEnd.addVertex(ptEndEl-vz*d300mm-vecDirection*(dMinDistanceToWallEdge-d1mm));
	plNoValidAreaEnd.addVertex(ptEndEl+vz*d300mm-vecDirection*(dMinDistanceToWallEdge-d1mm));
	plNoValidAreaEnd.addVertex(ptEndEl+vz*d300mm+vecDirection*(dMinDistanceToWallEdge-d1mm));
	plNoValidAreaEnd.addVertex(ptEndEl-vz*d300mm+vecDirection*(dMinDistanceToWallEdge-d1mm));
	plNoValidAreaEnd.close();
	PlaneProfile ppNoValidAreaEnd (plNoValidAreaEnd);
	ppNoValidAreaEnd.vis();

	ppAllNoValidAreas.append(ppNoValidAreaEnd);

	
	ptSplit=ptStartEl;
	int bFinishWall=FALSE;
	
	Element elToSplit;
	elToSplit=el;
	
	int nTimes=0;
	while (bFinishWall==FALSE)
	{
		//reportNotice("- No Finish -");
		ptSplit=plnBottom.closestPointTo(ptSplit);
		ptSplit=ptSplit+vecDirection*dMaxWallLength;
		int bTryAgain=TRUE;
		
		if (vecDirection.dotProduct(ptEndEl-ptSplit)<=0)
		{
			bFinishWall=TRUE;
			bTryAgain=FALSE;
		}
		
		while (bTryAgain)
		{
			//reportNotice("- Try -");
			int bInterference=FALSE;
			nTimes++;
			for (int i=0; i<ppAllNoValidAreas.length(); i++)
			{
				ptSplit.vis(1);ppAllNoValidAreas[i].vis(2);
				if (ppAllNoValidAreas[i].pointInProfile(ptSplit)==_kPointInProfile  )
				{
					bInterference=TRUE;
					//reportNotice("- Interference -");
					PLine plNoValirArea1[]=ppAllNoValidAreas[i].allRings();
					PLine plNoValirArea=plNoValirArea1[0];
					Point3d ptVertex[]=plNoValirArea.vertexPoints(TRUE);
					ptVertex=lnX.projectPoints(ptVertex);
					ptVertex=lnX.orderPoints(ptVertex);
					ptVertex=plnBottom.projectPoints(ptVertex);
					ptSplit=ptVertex[0]-vecDirection*d1mm;
					//ptSplit.vis(2);
					break;
				}
			}
			if (bInterference==FALSE)
			{
				if (vecDirection.dotProduct(ptStartEl-ptSplit)>0)
				{
					//reportNotice (dDistanceFromPrevWall);
					bTryAgain=FALSE;
				}
				else
				{
					bTryAgain=FALSE;
					Point3d ptAux=lnXCenter.closestPointTo(ptSplit);
					Element elNew;
					Wall wll=(Wall) elToSplit;
					if (wll.bIsValid())
					{
						elToFrame.append(elToSplit);
						Wall wallNew=wll.dbSplit(ptSplit);
						elNew= (Element) wallNew;
						if (elNew.bIsValid())
						{
							elToFrame.append(elNew);
							if (vecDirection.dotProduct(elNew.ptOrg()-elToSplit.ptOrg())>0) // The new element is on the letf of the main element
							{
								elToSplit=elNew;elToFrame.append(elToSplit);
							}
						}
						
						//Set the SplitPoint of the new element as a no valid Area
						PLine plNoValidAreaEnd(vy);
						plNoValidAreaEnd.addVertex(ptSplit-vz*d300mm-vecDirection*(dMinDistanceToWallEdge-d1mm));
						plNoValidAreaEnd.addVertex(ptSplit+vz*d300mm-vecDirection*(dMinDistanceToWallEdge-d1mm));
						plNoValidAreaEnd.addVertex(ptSplit+vz*d300mm+vecDirection*(dMinDistanceToWallEdge-d1mm));
						plNoValidAreaEnd.addVertex(ptSplit-vz*d300mm+vecDirection*(dMinDistanceToWallEdge-d1mm));
						plNoValidAreaEnd.close();
						PlaneProfile ppNoValidAreaEnd (plNoValidAreaEnd);
						ppNoValidAreaEnd.vis();
				
						ppAllNoValidAreas.append(ppNoValidAreaEnd);
					}
				}
			}
			if (nTimes>30)
			{
				bTryAgain=FALSE;
				bFinishWall=TRUE;
				reportNotice("No Valid Split Location found on wall " +el.code()+el.number());
			}
		}
	}
}


String sAllWalls[0];
String sWallArray[0];
int nStringLength=130;
int nElementsCompleted=0;
int nCounter=0;

while(nElementsCompleted<elToFrame.length() && nCounter<500)
{

	String strName= "";
	int nCurrentLength=0;
	for (int i=nElementsCompleted; i<elToFrame.length(); i++)
	{
		if((nCurrentLength+strName.length())<nStringLength)
		{
			String sName=elToFrame[i].number();
			nElementsCompleted++;
			if (sAllWalls.find(sName, -1) == -1)
			{
				sAllWalls.append(sName);
				strName+=sName+";";
				nCurrentLength=sName.length();
				
			}
		}
		else
		{
			break;
		}
		
	}
	//reportNotice("\n"+"nElementsCompleted"+nElementsCompleted);
	//reportNotice("\n"+"strName"+strName);

	sWallArray.append(strName);
	nCounter++;
}

if(nGenerate)
{
	for(int i=0;i<sWallArray.length();i++)
	{
		String strName=sWallArray[i];
		String sCommand="-Hsb_GenerateConstruction "+strName;
		//reportNotice("\n"+sCommand.length());
		if (strName!="")
		{
				
				pushCommandOnCommandStack(sCommand);
		}
	}
}


eraseInstance();
return;












#End
#BeginThumbnail















#End
#BeginMapX

#End