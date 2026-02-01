#Version 8
#BeginDescription
Create a reference line for the foundation with some offsets from the walls.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 14.09.2009 - version 1.0
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
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

* REVISION HISTORY
* -------------------------
*
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 14.09.2009
* version 1.0: Release Version
*
*/

Unit(1,"mm"); // script uses mm

PropString sDispRep(0, "", T("Show in Disp Rep"));
PropString sLineType(1, _LineTypes, T("Line Type"));
PropString sDimStyle(4, _DimStyles, T("Dim style"));
PropInt nColor(0, 3, T("Color Foundation Lines"));

//String sModes[]={T("Walls"), T("Beams"), T("Floors")};
//PropString sMode(2, sModes, T("Enter the required mode"));

PropString psExtType(2, "A;B;",  T("Code External Walls"));
psExtType.setDescription(T("Please type the codes of the external walls separate by ; "));

PropDouble dOffsetFrontExt(0, U(300),  T("Offset Front External Walls"));
PropDouble dOffsetBackExt(1, U(250),  T("Offset Back External Walls"));
//PropString sHatchExt(4, _HatchPatterns, T("Hatch for External Walls"));
//PropInt nColorExt(0, 1, T("Color External Walls"));

PropString psIntType(3, "D;E;",  T("Code Internal Walls"));
psIntType.setDescription(T("Please type the codes of the internal walls separate by ; "));

PropDouble dOffsetFrontInt(2, U(300),  T("Offset Front Internal Walls"));
PropDouble dOffsetBackInt(3, U(250),  T("Offset Back Internal Walls"));

//PropString sHatchInt(6, _HatchPatterns, T("Hatch for Internal Walls"));
//PropInt nColorInt(1, 2, T("Color Internal Walls"));

PropDouble dOffsetFrontParty(4, U(300),  T("Offset Front Party Walls"));
PropDouble dOffsetBackParty(5, U(250),  T("Offset Back Party Walls"));
//PropString sHatch(7, _HatchPatterns, T("Hatch for Other Walls"));
//PropInt nColor(2, 3, T("Color other walls"));



//PropString sGrpNm1(9, "Ground Floor", T("House Level group name"));
//sGrpNm1.setDescription("");

//PropString sGrpNm2(10, "Wall Layout", T("Floor Level group name"));
//sGrpNm2.setDescription("");


// Load the values from the catalog
if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

String sArrExtCode[0];
String sExtType=psExtType;
sExtType.trimLeft();
sExtType.trimRight();
sExtType=sExtType+";";
for (int i=0; i<sExtType.length(); i++)
{
	String str=sExtType.token(i);
	str.trimLeft();
	str.trimRight();
	if (str.length()>0)
		sArrExtCode.append(str);
}

String sArrIntCode[0];
String sIntType=psIntType;
sIntType.trimLeft();
sIntType.trimRight();
sIntType=sIntType+";";
for (int i=0; i<sIntType.length(); i++)
{
	String str=sIntType.token(i);
	str.trimLeft();
	str.trimRight();
	if (str.length()>0)
		sArrIntCode.append(str);
}



if(_bOnInsert)
{
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	if (_kExecuteKey=="")
		showDialogOnce();

	PrEntity ssE (T("Please select Walls"),ElementWall());
	if (ssE.go())
	{
 			Entity ents[0];
 			ents = ssE.set();
	
 			for (int i = 0; i < ents.length(); i++ )
		 {
 				Element el = (Element) ents[i];
			if (el.bIsValid()) {
 					_Element.append(el);
			}	
 			 }
	}
	
	return;
}

Display dp(nColor);
dp.lineType(sLineType);
dp.dimStyle(sDimStyle);

if (sDispRep!="")
	dp.showInDispRep(sDispRep);


	//Segregate Walls
	ElementWall eWalls[0];
	for (int i=0; i<_Element.length(); i++) {
		ElementWall ewTemp=(ElementWall) _Element[i];
		if (ewTemp.bIsValid()) {
			eWalls.append(ewTemp);
		} 
	}

	CoordSys wcs(_PtW, _XW, _YW, _ZW);
	PlaneProfile ppExternalTemp(wcs);
	PlaneProfile ppInternalTemp(wcs);
	PlaneProfile ppPartyTemp(wcs);
	ElementWall elExternal[0];
	ElementWall elInternal[0];
	ElementWall elParty[0];
	for (int i=0; i<eWalls.length(); i++)
	{
		ElementWall el=eWalls[i];
		PLine plOutWall=eWalls[i].plOutlineWall();
		PlaneProfile ppOutEl(plOutWall);
		//ppOutEl.joinRing(plOutWall, FALSE);
		ppOutEl.shrink(-U(15));
		
		String sCode = el.code();
		if( sArrExtCode.find(sCode) != -1 )
		{
			elExternal.append(el);
			ppExternalTemp.unionWith(ppOutEl);
			
			
		}else if( sArrIntCode.find(sCode) != -1 )
		{
			elInternal.append(el);
			ppInternalTemp.unionWith(ppOutEl);
		}else
		{
			elParty.append(el);
			ppPartyTemp.unionWith(ppOutEl);
		}
	}

	//ppExternalTemp.shrink(U(5));
	//ppExternalTemp.vis(1);
	ppInternalTemp.shrink(U(5));
	//ppInternalTemp.vis(2);
	ppPartyTemp.shrink(U(5));
	//ppPartyTemp.vis(3);
	PlaneProfile ppExternal(wcs);
	PlaneProfile ppInternal(wcs);
	PlaneProfile ppParty(wcs);
	
	PLine plAllRingsExternal[]=ppExternalTemp.allRings();
	int nIsOpeningExternal[]=ppExternalTemp.ringIsOpening();
	for (int n=0; n<plAllRingsExternal.length(); n++)
	{
		
			PLine plOutlineElement(_ZW);
			//plOutlineElement=plConvexHull;
		
			//Point3d ptAllVertex[]=plConvexHull.vertexPoints(FALSE);
			
			Point3d arPtAll[] = plAllRingsExternal[n].vertexPoints(FALSE);
			
			if( arPtAll.length() > 2 )
			{
				plOutlineElement.addVertex(arPtAll[0]);
				for (int i=1; i<arPtAll.length()-1; i++)
				{
					//Analyze initial point with last point and next point
					Vector3d v1(arPtAll[i-1] - arPtAll[i]);
					v1.normalize();
					Vector3d v2(arPtAll[i] - arPtAll[i+1]);
					v2.normalize();
				
					if( abs(v1.dotProduct(v2)) <0.99 ) 
					{
						plOutlineElement.addVertex(arPtAll[i]);
					}
				}
			}
			plOutlineElement.close();
		if (nIsOpeningExternal[n]==FALSE)
		{	//plOutlineElement.vis(1);
			int a=ppExternal.joinRing(plOutlineElement, FALSE);
		}
		else
		{
			int a=ppExternal.joinRing(plOutlineElement, TRUE);
		}
	}
	ppExternal.vis(1);
	PLine plAllRingsInternal[]=ppInternalTemp.allRings();
	int nIsOpeningInternal[]=ppInternalTemp.ringIsOpening();
	for (int n=0; n<plAllRingsInternal.length(); n++)
	{
		if (nIsOpeningInternal[n]==FALSE)
		{
			PLine plOutlineElement(_ZW);
			//plOutlineElement=plConvexHull;
		
			//Point3d ptAllVertex[]=plConvexHull.vertexPoints(FALSE);
			
			Point3d arPtAll[] = plAllRingsInternal[n].vertexPoints(FALSE);
			
			if( arPtAll.length() > 2 )
			{
				plOutlineElement.addVertex(arPtAll[0]);
				for (int i=1; i<arPtAll.length()-1; i++)
				{
					//Analyze initial point with last point and next point
					Vector3d v1(arPtAll[i-1] - arPtAll[i]);
					v1.normalize();
					Vector3d v2(arPtAll[i] - arPtAll[i+1]);
					v2.normalize();
				
					if( abs(v1.dotProduct(v2)) <0.99 ) 
					{
						plOutlineElement.addVertex(arPtAll[i]);
					}
				}
			}
			plOutlineElement.close();
			ppInternal.joinRing(plOutlineElement, FALSE);
		}
	}
	
	PLine plAllRings[]=ppPartyTemp.allRings();
	int nIsOpening[]=ppPartyTemp.ringIsOpening();
	for (int n=0; n<plAllRings.length(); n++)
	{
		if (nIsOpening[n]==FALSE)
		{
			PLine plOutlineElement(_ZW);
			//plOutlineElement=plConvexHull;
		
			//Point3d ptAllVertex[]=plConvexHull.vertexPoints(FALSE);
			
			Point3d arPtAll[] = plAllRings[n].vertexPoints(FALSE);
			
			if( arPtAll.length() > 2 )
			{
				plOutlineElement.addVertex(arPtAll[0]);
				for (int i=1; i<arPtAll.length()-1; i++)
				{
					//Analyze initial point with last point and next point
					Vector3d v1(arPtAll[i-1] - arPtAll[i]);
					v1.normalize();
					Vector3d v2(arPtAll[i] - arPtAll[i+1]);
					v2.normalize();
				
					if( abs(v1.dotProduct(v2)) <0.99 ) 
					{
						plOutlineElement.addVertex(arPtAll[i]);
					}
				}
			}
			plOutlineElement.close();
			ppParty.joinRing(plOutlineElement, FALSE);
		}
	}

			
	Point3d pntsExt[0];
	pntsExt = ppExternal.getGripEdgeMidPoints(); // get all the mid edge grip points
	
	for (int i=0; i<elExternal.length(); i++)
	{
		ElementWall el=elExternal[i];
		CoordSys cs=el.coordSys();
		Vector3d vx=cs.vecX();
		Vector3d vy=cs.vecY();
		Vector3d vz=cs.vecZ();
		_Pt0=el.ptOrg();
		Plane plnY(cs.ptOrg(), vy);
		PLine plOutWall=el.plOutlineWall();
		
		PlaneProfile ppEl(plOutWall);
		LineSeg ls=ppEl.extentInDir(vx);
		Point3d ptM=ls.ptMid();
		
		double dWidthEl=abs(vz.dotProduct(ls.ptStart()-ls.ptEnd()));
		
		Point3d ptFront=ptM+vz*(dWidthEl*0.5);
		Point3d ptBack=ptM-vz*(dWidthEl*0.5);

		// determine which point is closest to _PtG[0]
		int nInd = -1;
		double dDistMin = 0;
		for (int p=0; p<pntsExt.length(); p++)
		{
			Point3d pt = pntsExt[p];
			//pt.vis();
			double dDist = Vector3d(ptFront-pt).length();
			if (p==0 || dDist<dDistMin)
			{
				dDistMin = dDist;
				nInd = p;
			}
		}
		if (nInd>=0)
		{
			pntsExt[nInd].vis(2);
			Vector3d vMove((ptFront+vz*(dOffsetFrontExt))-pntsExt[nInd]);
			ppExternal.moveGripEdgeMidPointAt(nInd, vMove);
		}
		
		//pntsExt = ppExternal.getGripEdgeMidPoints(); // get all the mid edge grip points
		
		int nIndBack = -1;
		double dDistMinBack = 0;
		for (int p=0; p<pntsExt.length(); p++)
		{
			Point3d pt = pntsExt[p];
			pt.vis();
			double dDist = Vector3d(ptBack-pt).length();
			if (p==0 || dDist<dDistMinBack)
			{
				dDistMinBack = dDist;
				nIndBack  = p;
			}
		}


		if (nIndBack>=0)
		{
			pntsExt[nIndBack].vis(2);
			Vector3d vMove((ptBack-vz*(dOffsetBackExt))-pntsExt[nIndBack]);
			ppExternal.moveGripEdgeMidPointAt(nIndBack, vMove);
		}

	}
	
	dp.draw(ppExternal);

	Point3d pntsInt[0];
	pntsInt = ppInternal.getGripEdgeMidPoints(); // get all the mid edge grip points
	
	for (int i=0; i<elInternal.length(); i++)
	{
		ElementWall el=elInternal[i];
		CoordSys cs=el.coordSys();
		Vector3d vx=cs.vecX();
		Vector3d vy=cs.vecY();
		Vector3d vz=cs.vecZ();
		_Pt0=el.ptOrg();
		Plane plnY(cs.ptOrg(), vy);
		PLine plOutWall=el.plOutlineWall();
		
		PlaneProfile ppEl(plOutWall);
		LineSeg ls=ppEl.extentInDir(vx);
		Point3d ptM=ls.ptMid();
		
		double dWidthEl=abs(vz.dotProduct(ls.ptStart()-ls.ptEnd()));
		
		Point3d ptFront=ptM+vz*(dWidthEl*0.5);
		Point3d ptBack=ptM-vz*(dWidthEl*0.5);

		// determine which point is closest to _PtG[0]
		int nInd = -1;
		double dDistMin = 0;
		for (int p=0; p<pntsInt.length(); p++)
		{
			Point3d pt = pntsInt[p];
			//pt.vis();
			double dDist = Vector3d(ptFront-pt).length();
			if (p==0 || dDist<dDistMin)
			{
				dDistMin = dDist;
				nInd = p;
			}
		}
		if (nInd>=0)
		{
			pntsInt[nInd].vis(2);
			Vector3d vMove((ptFront+vz*(dOffsetFrontExt))-pntsInt[nInd]);
			ppInternal.moveGripEdgeMidPointAt(nInd, vMove);
		}
		
		//pntsInt = ppInternal.getGripEdgeMidPoints(); // get all the mid edge grip points
		
		int nIndBack = -1;
		double dDistMinBack = 0;
		for (int p=0; p<pntsInt.length(); p++)
		{
			Point3d pt = pntsInt[p];
			pt.vis();
			double dDist = Vector3d(ptBack-pt).length();
			if (p==0 || dDist<dDistMinBack)
			{
				dDistMinBack = dDist;
				nIndBack  = p;
			}
		}


		if (nIndBack>=0)
		{
			pntsInt[nIndBack].vis(2);
			Vector3d vMove((ptBack-vz*(dOffsetBackExt))-pntsInt[nIndBack]);
			ppInternal.moveGripEdgeMidPointAt(nIndBack, vMove);
		}

	}
	
	dp.draw(ppInternal);


#End
#BeginThumbnail


#End
