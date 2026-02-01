#Version 8
#BeginDescription
Automatically splits and generates walls based on maximum length, distance to openings, connections and wall edges
v1.9: 19.mar.2013: David Rueda (dr@hsb-cad.com)
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 9
#KeyWords 
#BeginContents
/*
  COPYRIGHT
  ---------------
  Copyright (C) 2011 by
  hsbSOFT 

  The program may be used and/or copied only with the written
  permission from hsbSOFT, or in accordance with
  the terms and conditions stipulated in the agreement/contract
  under which the program has been supplied.

  All rights reserved.

 REVISION HISTORY
 -------------------------

 v1.0: 19.mar.2013: David Rueda (dr@hsb-cad.com)
	- Copied from hsb_Split Walls, to keep US content folder naming standards
	- Thumbnail added
 v1.9: 19.mar.2013: David Rueda (dr@hsb-cad.com)
	- Version control from 1.0 to 1.9, to keep updated with hsb_Split Walls
*/

Unit(1,"mm"); // script uses mm

String sArNY[] = {T("No"), T("Yes")};

PropDouble dMaxWallLength (0, U(3600), T("Max. Wall Length"));
	dMaxWallLength.setDescription("The Length entered here will be the max length that any wall can be.");
	
PropDouble dDistanceToWindow(1, U(300), T("Min. Distance to Opening"));
	dDistanceToWindow.setDescription("This is the min distance that any wall will split to an opening.");
	
PropDouble dMinDistanceToWallEdge(2, U(300), T("Min. Distance to Wall Edge"));
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
	Line lnXCenter (ptElOrg-vz*U(70), vecDirection);
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
		plNoValidArea.addVertex(ptVertexOp[0]-vz*U(300)-vecDirection*(dDistanceToWindow-U(1)));
		plNoValidArea.addVertex(ptVertexOp[0]+vz*U(300)-vecDirection*(dDistanceToWindow-U(1)));
		plNoValidArea.addVertex(ptVertexOp[ptVertexOp.length()-1]+vz*U(300)+vecDirection*(dDistanceToWindow-U(1)));
		plNoValidArea.addVertex(ptVertexOp[ptVertexOp.length()-1]-vz*U(300)+vecDirection*(dDistanceToWindow-U(1)));
		plNoValidArea.close();
		PlaneProfile ppNoValidArea (plNoValidArea);
		ppNoValidArea.vis();
		ppAllNoValidAreas.append(ppNoValidArea);
		
	}
	
	//Set the start of the element as a no valid Area
	PLine plNoValidAreaStart(vy);
	plNoValidAreaStart.addVertex(ptStartEl-vz*U(300)-vecDirection*(dMinDistanceToWallEdge-U(1)));
	plNoValidAreaStart.addVertex(ptStartEl+vz*U(300)-vecDirection*(dMinDistanceToWallEdge-U(1)));
	plNoValidAreaStart.addVertex(ptStartEl+vz*U(300)+vecDirection*(dMinDistanceToWallEdge-U(1)));
	plNoValidAreaStart.addVertex(ptStartEl-vz*U(300)+vecDirection*(dMinDistanceToWallEdge-U(1)));
	plNoValidAreaStart.close();
	PlaneProfile ppNoValidAreaStart (plNoValidAreaStart);
	ppNoValidAreaStart.vis();

	ppAllNoValidAreas.append(ppNoValidAreaStart);
	
	//Set the end of the element as a no valid Area
	PLine plNoValidAreaEnd(vy);
	plNoValidAreaEnd.addVertex(ptEndEl-vz*U(300)-vecDirection*(dMinDistanceToWallEdge-U(1)));
	plNoValidAreaEnd.addVertex(ptEndEl+vz*U(300)-vecDirection*(dMinDistanceToWallEdge-U(1)));
	plNoValidAreaEnd.addVertex(ptEndEl+vz*U(300)+vecDirection*(dMinDistanceToWallEdge-U(1)));
	plNoValidAreaEnd.addVertex(ptEndEl-vz*U(300)+vecDirection*(dMinDistanceToWallEdge-U(1)));
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
		ptSplit=ptSplit+vecDirection*U(dMaxWallLength);
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
					ptSplit=ptVertex[0]-vecDirection*U(1);
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
						plNoValidAreaEnd.addVertex(ptSplit-vz*U(300)-vecDirection*(dMinDistanceToWallEdge-U(1)));
						plNoValidAreaEnd.addVertex(ptSplit+vz*U(300)-vecDirection*(dMinDistanceToWallEdge-U(1)));
						plNoValidAreaEnd.addVertex(ptSplit+vz*U(300)+vecDirection*(dMinDistanceToWallEdge-U(1)));
						plNoValidAreaEnd.addVertex(ptSplit-vz*U(300)+vecDirection*(dMinDistanceToWallEdge-U(1)));
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
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`$L`9`#`2(``A$!`Q$!_\0`
M'P```04!`0$!`0$```````````$"`P0%!@<("0H+_\0`M1```@$#`P($`P4%
M!`0```%]`0(#``01!1(A,4$&$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*
M%A<8&1HE)B<H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&EJ<W1U
M=G=X>7J#A(6&AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&
MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ>KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!
M`0$!`0````````$"`P0%!@<("0H+_\0`M1$``@$"!`0#!`<%!`0``0)W``$"
M`Q$$!2$Q!A)!40=A<1,B,H$(%$*1H;'!"2,S4O`58G+1"A8D-.$E\1<8&1HF
M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@H.$
MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#W^BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BO-]7\8ZQ:?
M$Z#1X98A8>?!`T1C!W!PN23UR-_&"!P.#SGTBHA-2;2Z'5B<'4P\82G;WU=!
M1115G*%%%%`!1110`4444`%%%%`!1110`4444`%%<)\2?$VJ>'XM-33)E@:X
M:0NYC#'"[<`;LC'S>F>![YZ[1[N34-$L+V4*LEQ;1RN$'`+*"<>W-0IIR<>Q
MU5,'4IX>&(=N65[=]"[1115G*%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`>,>(/\`DL\/_7]:
M?RCKV>O&/$'_`"6>'_K^M/Y1U[/7-0^*?J>[G'\'#?X%^2"BBBND\(****`"
MBBB@`HHHH`****`"BBB@`HHHH`\M^,?_`#!?^V__`+3KO?#/_(J:/_UXP_\`
MH`K@OC'_`,P7_MO_`.TZ[WPS_P`BIH__`%XP_P#H`KFA_'E\CW<7_P`BG#^L
MOS9JT445TGA!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`'C'B#_DL\/_7]:?RCKV>O&/$'_)9X
M?^OZT_E'7L]<U#XI^I[N<?P<-_@7Y(****Z3P@HHHH`****`"BBB@`HHHH`*
M***`"BBB@#RWXQ_\P7_MO_[3KO?#/_(J:/\`]>,/_H`K@OC'_P`P7_MO_P"T
MZ[WPS_R*FC_]>,/_`*`*YH?QY?(]W%_\BG#^LOS9JT445TGA!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`'C'B#_DL\/\`U_6G\HZ]GKQCQ!_R6>'_`*_K3^4=>SUS4/BGZGNY
MQ_!PW^!?D@HHHKI/""BBB@`HHHH`****`"BBB@`HHHH`****`/+?C'_S!?\`
MMO\`^TZ[WPS_`,BIH_\`UXP_^@"N"^,?_,%_[;_^TZ[WPS_R*FC_`/7C#_Z`
M*YH?QY?(]W%_\BG#^LOS9JT445TGA!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`'C'B#_DL\/_
M`%_6G\HZ]GKQCQ!_R6>'_K^M/Y1U[/7-0^*?J>[G'\'#?X%^2"BBBND\(***
M*`"BBB@`HHHH`****`"BBB@`HHHH`\M^,?\`S!?^V_\`[3KO?#/_`"*FC_\`
M7C#_`.@"N"^,?_,%_P"V_P#[3KO?#/\`R*FC_P#7C#_Z`*YH?QY?(]W%_P#(
MIP_K+\V:M%%%=)X04444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
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
C`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`_]FB
`

#End
