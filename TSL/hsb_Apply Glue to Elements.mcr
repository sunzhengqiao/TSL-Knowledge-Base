#Version 8
#BeginDescription
HSB-7955: subtract the glue areas, support catalogues 

Modified by: Marsel Nakuci (marsel.nakuci@hsbcad.com)
Date: 05.10.2020 - version 2.4

Creates nail lines in 10 zones for walls and floors, and attaches information for export.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 06.11.2017 - version 2.3

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 4
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
*
*/

/// <History>//region
/// <version value="2.4" date="05okt2020" author="marsel.nakuci@hsbcad.com"> HSB-7955: subtract the glue areas, support catalogues </version>
/// </History>

/// <insert Lang=en>
/// Select entity, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates 
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "ScriptName")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|UserPrompt|"))) TSLCONTENT
//endregion


//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	// read a potential mapObject defined by hsbDebugController
	{ 
		MapObject mo("hsbTSLDev" ,"hsbTSLDebugController");
		if (mo.bIsValid()){Map m = mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug = true;	break;}}
		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());		
	}
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
//end Constants//endregion


//Units
Unit(1,"mm");

_ThisInst.setSequenceNumber(50);

int nValidZones[]={1,2,3,4,5,6,7,8,9,10};
int nRealZones[]={1,2,3,4,5,-1,-2,-3,-4,-5};
//Next int nInt available=50;
//Next int nString available=56;
//Next int nDouble=50;

//Zone1
PropInt nZones1 (0, nValidZones, T("Zone to be Glued"));

PropInt nRefZ1 (1, nValidZones, T("Glue Reference Zone"), 0);

PropInt nToolingIndexLine(2, 51, T("Tool index Line"));

PropInt nToolingIndexArea(3, 52, T("Tool index Area"));

PropDouble dSizeGlueArea(0, U(360), T("Size Glue Area"));

PropDouble dOriginXOffset(1, U(0), T("|Origin X offset|"));
PropDouble dOriginYOffset(2, U(0), T("|Origin Y offset|"));
PropDouble dMinimumWidthToCreateGlueArea(3, 200, T("|Minimum width to create glue area|"));
PropDouble dMinimumGlueLineLength(4, 200, T("|Minimum length of glue line|"));

	//double dMinValidArea=U(12);
	//double dDistCloseToEdge=U(25);
double dMinimumHeightGluableBoard = U(600);
double dShrinkProfileForOddSizes = U(45);


//if (_bOnDbCreated || _bOnInsert) setPropValuesFromCatalog(_kExecuteKey);

if( _bOnInsert )
{
//	if (insertCycleCount()>1) { eraseInstance(); return; }
//	if (_kExecuteKey=="")
//		showDialog();
	// support catalogues
	if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		if (_kExecuteKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());	
			if (sEntries.findNoCase(_kExecuteKey,-1)>-1)
				setPropValuesFromCatalog(_kExecuteKey);
			else
				setPropValuesFromCatalog(sLastInserted);					
		}
	// standard dialog	
		else	
			showDialog();

	PrEntity ssE(T("Select one or More Elements"), Element());
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	//Insert the TSL again for each Element
	TslInst tsl;
	String sScriptName = scriptName(); // name of the script
	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
	Entity lstEnts[0];
	Beam lstBeams[0];
	Point3d lstPoints[0];
	int lstPropInt[0];
	lstPropInt.append(nZones1);
	lstPropInt.append(nRefZ1);
	lstPropInt.append(nToolingIndexLine);
	lstPropInt.append(nToolingIndexArea);
	
	double lstPropDouble[0];
	lstPropDouble.append(dSizeGlueArea);
	lstPropDouble.append(dOriginXOffset);
	lstPropDouble.append(dOriginYOffset);
	lstPropDouble.append(dMinimumWidthToCreateGlueArea);
	lstPropDouble.append(dMinimumGlueLineLength);

	String lstPropString[0];
	
	Map mpToClone;
	mpToClone.setInt("ExecutionMode",0);

	for (int i=0; i<_Element.length(); i++)
	{
		lstEnts.setLength(0);
		lstEnts.append(_Element[i]);
		tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mpToClone);
	}

	//_Element.append(getElement(T("Select an element")));
	_Map.setInt("ExecutionMode",0);
	eraseInstance();
	return;
}

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

int nZoneIndex[0];
int nRefZone[0];
int nToolingIndex[0];
//double dSpacingEdge[0];

//reportNotice("zone1");
	nZoneIndex.append(nRealZones[nValidZones.find(nZones1, 0)]);
	nRefZone.append(nRealZones[nValidZones.find(nRefZ1, 0)]);
	//nToolingIndex.append(nToolingIndex1);
	
	//dSizeGlueArea.append(dSizeGlueArea);


if( _Element.length() == 0 ){eraseInstance(); return;}

_Pt0=_Element[0].ptOrg();

String strChangeEntity = T("Reapply Glue");
addRecalcTrigger(_kContext, strChangeEntity );
if (_bOnRecalc && _kExecuteKey==strChangeEntity) {
	_Map.setInt("ExecutionMode",0);
}

if (_bOnElementConstructed)
{
	_Map.setInt("ExecutionMode",0);
}

int nExecutionMode = 1;
if (_Map.hasInt("ExecutionMode"))
{
	nExecutionMode = _Map.getInt("ExecutionMode");
}


Element el = (Element) _Element[0];
if (!el.bIsValid())
{
	eraseInstance();
	return;
}

_Pt0 = el.ptOrg();

String sElNumber=el.number();
Point3d elementOrigin = el.ptOrg();
CoordSys elementCoordSys = el.coordSys();
Vector3d elVecX = elementCoordSys.vecX();
Vector3d elVecY = elementCoordSys.vecY();
Vector3d elVecZ = elementCoordSys.vecZ();
		
String sMaterial[0];
double dQty[0];
int nZone[0];

double dQtyFrame=0;

//return;

if(nZones1 < nRefZ1 )
{
	reportNotice("Reference zone should be lower than glue zone.");
}
else if (nExecutionMode==0)
{	
	
	TslInst tslAll[]=el.tslInstAttached();
	for (int i=0; i<tslAll.length(); i++)
	{
		if ( tslAll[i].scriptName().makeUpper() == "HSB_GLUEAREA")
		{
			if (tslAll[i].propInt(0)==nZones1)
			{
				tslAll[i].dbErase();	
			}
		}
	}

	tslAll=el.tslInstAttached();
	for (int i=0; i<tslAll.length(); i++)
	{ 
		if ( tslAll[i].scriptName() == scriptName() && tslAll[i].handle() != _ThisInst.handle())
		{
			if (tslAll[i].propInt(0)==nZones1)
			{
				tslAll[i].dbErase();	
			}
		}

	}
	
	PLine noGlueAreas[0];
	for(int i=0 ; i<tslAll.length() ; i++)
	{
		TslInst& tsl = tslAll[i];
		
		if (!tsl.bIsValid()) continue;
		
		//Get shape of no glue area
		Map mpTsl = tsl.map();
		if(!mpTsl.hasPLine("NoToolShape") && !mpTsl.hasMap("NoToolArea[]")) continue;
		
		String sAllKeys=tsl.subMapXKeys();
		if (sAllKeys.find("Hsb_Tag", -1) == -1) continue;
		
		// The tags map could contain many tags with the same TAG key so we must go through until we find one or not.
		Map mpTags = tsl.subMapX("Hsb_Tag");
		if(!mpTags.hasString("Tag")) continue;
		int bHasNoGlue = 0;
		for(int x = 0; x < mpTags.length(); x++)
		{
			if (mpTags.keyAt(x).makeUpper()!="TAG") continue;
			
			if (mpTags.getString(x).makeUpper()=="NOGLUE") 
			{
				bHasNoGlue = 1;
				break;
			}
		}

		if (!bHasNoGlue) continue;
//		if( !mpTsl.hasMap("NoToolArea[]")) continue;
		
		if(mpTsl.hasMap("NoToolArea[]"))
		{
			Map mpNoToolAreaArray = mpTsl.getMap("NoToolArea[]");
			for(int x = 0 ; x < mpNoToolAreaArray.length() ; x++)
			{ 
				if(mpNoToolAreaArray.keyAt(x).makeUpper() != "NOTOOLAREA") continue;
				
				Map mpNoToolArea = mpNoToolAreaArray.getMap(x);
						
				int nNoToolZone = mpNoToolArea.getInt("NoToolZone");
				if(nZoneIndex.find(nNoToolZone, -1)==-1) continue;
		
				PLine plNoToolShape = mpNoToolArea.getPLine("NoToolShape");
				noGlueAreas.append(plNoToolShape);
			}
		}
		else
		{ 
			int nNoToolZone = mpTsl.getInt("NoToolZone");
			if(nZoneIndex.find(nNoToolZone, -1)==-1) continue;
				
			PLine plNoToolShape = mpTsl.getPLine("NoToolShape");
			plNoToolShape.vis();
			noGlueAreas.append(plNoToolShape);
		}
	}

	//loop Zones
	int nExpZone[0];
	double dExpCenter[0];
	double dExpEdge[0];
	
	for (int z=0; z<nZoneIndex.length(); z++)
	{
		//Insert the TSL again for each Element
		TslInst tsl;
		String sScriptName = "hsb_GlueArea"; // name of the script
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		Entity lstEnts[0];
		Beam lstBeams[0];
		Point3d lstPoints[0];
		int lstPropInt[0];
		//lstPropInt.append(nZones1);
		//lstPropInt.append(nToolingIndex1);
		
		double lstPropDouble[0];
		lstPropDouble.append(dSizeGlueArea);
	
		String lstPropString[0];
		Map mpToClone;
		mpToClone.setInt("ExecutionMode",0);
	
		lstEnts.setLength(0);
		lstEnts.append(el);

		int nRef=nRefZone[z];

		ElemZone elzone = el.zone(nZoneIndex[z]);
		
		CoordSys cs =elzone.coordSys();
		_Pt0=cs.ptOrg();
		Vector3d vx = cs.vecX();
		Vector3d vy = cs.vecY();
		Vector3d vz = cs.vecZ();
		
		Plane plnZ(elementOrigin, vz);
		plnZ.vis(1);
		
		String sMaterialZone=elzone.material();

		Sheet arSh[] = el.sheet(nZoneIndex[z]);
		
		GenBeam gbZ[]=el.genBeam(nRef);
		
		PlaneProfile ppNoGlueAreas(cs);
		for(int p=0 ; p<noGlueAreas.length() ; p++)
		{
			PLine& plNoGlueArea = noGlueAreas[p];
			ppNoGlueAreas.joinRing(plNoGlueArea, false);
		}
		
		if(nRef!=0)
		{
			if (gbZ.length()==0)
				continue;
		}
		
		if (arSh.length()<=0)
		{
			continue;
		}
		
		double dZone0W = el.zone(0).dH();
		
		Point3d ptFacePlane=el.ptOrg();
		if (nZoneIndex[z]<0)
		{
			ptFacePlane=ptFacePlane-vz*(dZone0W);
		}
		if(nRef!=0)
		{
			ptFacePlane=elzone.ptOrg();
		}
		
		Plane plnEl (ptFacePlane, vz);
		plnEl.vis();
		//calculate the reference zone
		double dNewZoneThickness=el.zone(nZoneIndex[z]).dH();
		
		PlaneProfile ppBm(plnEl);
		// loop all genbeams of element
		for(int j=0 ; j < gbZ.length() ; j++)
		{
			GenBeam gbm=gbZ[j];
		
			Body bdBm = gbm.realBody(); //bdBm .vis(j);
			ppBm.unionWith( bdBm.extractContactFaceInPlane(plnEl, dNewZoneThickness) );
			//ppBm.shrink(U(-5));
		}
		
		ppBm.shrink(U(-5));
		ppBm.shrink(U(5));
//		ppBm.vis(1);
		// all sheets of selected zone 
		for(int i = 0; i < arSh.length(); i++)
		{
			Sheet& sh=arSh[i];
			
			//Exclude any sheet that has the Tag "NoGluing"
			Map mpTags = sh.subMapX("Hsb_Tag");
	
			int nIgnoreSheet = FALSE;
			for (int i=0; i<mpTags.length(); i++)
			{
				if (mpTags.keyAt(i)=="TAG")
				{
					String sThisKey=mpTags.getString(i);
					
					if (sThisKey.makeUpper() == "NOGLUING")
					{
						nIgnoreSheet = TRUE;
						break;
					}
				}
			}
			
			if(nIgnoreSheet) continue;
			
			PlaneProfile ppSh (plnEl);
			ppSh.joinRing(sh.plEnvelope(), false);
//						ppSh.vis(i);
			
			PlaneProfile ppIntersection=ppSh;
			ppIntersection.intersectWith(ppBm);
			ppIntersection.subtractProfile(ppNoGlueAreas);
			ppIntersection.vis(i);
			
			//Strip off bottom and left areas of intersection if offsets specified
			//Create profile from new offset point and strip off from intersection profile
			PLine horizontalCuttingShape;
			int largeShapeSize = U(100000);
			horizontalCuttingShape.createRectangle(LineSeg(elementOrigin + dOriginYOffset * elVecY - largeShapeSize * elVecX, elementOrigin - (dOriginYOffset + largeShapeSize) * elVecY + largeShapeSize * elVecX), elVecX, elVecY);
			PlaneProfile horizontalCuttingProfile(elementCoordSys);
			horizontalCuttingProfile.joinRing(horizontalCuttingShape, FALSE);
			
			PLine verticalCuttingShape;
			verticalCuttingShape.createRectangle(LineSeg(elementOrigin + dOriginXOffset * elVecX - largeShapeSize * elVecY, elementOrigin - (dOriginXOffset + largeShapeSize) * elVecX + largeShapeSize * elVecY), elVecX, elVecY);
			PlaneProfile verticalCuttingProfile(elementCoordSys);
			verticalCuttingProfile.joinRing(verticalCuttingShape, FALSE);
			
			ppIntersection.subtractProfile(horizontalCuttingProfile);
			ppIntersection.subtractProfile(verticalCuttingProfile);
			
			//			reportMessage("\nZone: "+i);
			
			LineSeg lsGb=ppIntersection.extentInDir(vx);
						lsGb.vis(2);
			double dBmWidth=abs(vx.dotProduct(lsGb.ptStart()-lsGb.ptEnd()));
			double dBmHeight=abs(vy.dotProduct(lsGb.ptStart()-lsGb.ptEnd()));
			
			double dTimes=dBmWidth/dSizeGlueArea;
			int nFullAreas=dTimes;
			int nPartialAreas = 0;
			double partialAreaWidth = 0;
			if(nFullAreas == 0 & dBmWidth > 0)
			{
				nPartialAreas = 1;
				partialAreaWidth = dBmWidth;
			}
			else 
			{
				nPartialAreas = nFullAreas > 1 ? (nFullAreas - 1) : 1;
				partialAreaWidth = (dBmWidth - (nFullAreas * dSizeGlueArea)) / nPartialAreas ;
			}
			
			Point3d ptStartDistribution=lsGb.ptStart();
			PlaneProfile ppSmallAreas(cs);
//			ppIntersection.vis(1);
			PlaneProfile ppIntersectionAll(ppIntersection.coordSys());
			for (int k=0; k<nFullAreas; k++)
			{
				double gapBetweenFullAreas = partialAreaWidth * k;
				Point3d ptStartOfStrip =ptStartDistribution-vy*U(4000)+vx*(k*dSizeGlueArea + gapBetweenFullAreas);
				Point3d ptEndOfStrip = ptStartDistribution+vy*U(4000)+vx*((k+1)*dSizeGlueArea + gapBetweenFullAreas);
				
				Line lnAtStartOfStrip(ptStartOfStrip, vy);
				LineSeg lsThisStrip(ptStartOfStrip, ptEndOfStrip);
				PLine plStrip(vz);
				plStrip.createRectangle(lsThisStrip, vx, vy);
				PlaneProfile ppStripArea(cs);
				ppStripArea.joinRing(plStrip, false);
				
				PlaneProfile ppIntersectionResult(cs);
				ppIntersectionResult=ppIntersection;
				ppIntersectionResult.intersectWith(ppStripArea);
//								ppIntersectionResult.vis(3);
				ppIntersectionAll.unionWith(ppIntersectionResult);
				
				PLine plAllRings[]=ppIntersectionResult.allRings();
				Point3d ptAllRingVertices[0];
				
				for(int r=0 ; r<plAllRings.length() ; r++)
				{
					PLine ring = plAllRings[r];
					ring.convertToLineApprox(U(10));
					ptAllRingVertices.append(ring.vertexPoints(TRUE));
				}
				
				ptAllRingVertices = lnAtStartOfStrip.projectPoints(ptAllRingVertices);
				ptAllRingVertices = lnAtStartOfStrip.orderPoints(ptAllRingVertices);
				
				LineSeg lsIntersectionResult = ppIntersectionResult.extentInDir(vx);
				double dIntersectionWidth = abs(vx.dotProduct(lsIntersectionResult.ptStart() - lsIntersectionResult.ptEnd()));
				double dIntersectionHeight = abs(vy.dotProduct(lsIntersectionResult.ptStart() - lsIntersectionResult.ptEnd()));
				
				//Check if the piece is smaller than the minimum gluable size
				if(dIntersectionHeight < dMinimumHeightGluableBoard)
				{
					ppSmallAreas.unionWith(ppIntersectionResult);
					continue;
				}
				
				//Go in pairs of vertices
				for(int v=0 ; v<ptAllRingVertices.length() - 1 ; v++)
				{
					Point3d& ptVertexStart = ptAllRingVertices[v];
					Point3d& ptVertexEnd = ptAllRingVertices[v +1];
//					ptVertexStart.vis();
//					ptVertexEnd.vis();
					
					PLine plFullGluableArea;
					plFullGluableArea.createRectangle(LineSeg(ptVertexStart, ptVertexEnd + vx * dIntersectionWidth ), vx, vy );
					PlaneProfile ppGluableArea(plnEl);
					ppGluableArea.joinRing(plFullGluableArea, false);
					
					PlaneProfile ppRingIntersection(plnEl);
					ppRingIntersection=ppIntersectionResult;
					ppRingIntersection.intersectWith(ppGluableArea);
					
					double dRingInteresectionArea = ppRingIntersection.area();
					double dGluableArea =  plFullGluableArea.area();
					if(dRingInteresectionArea <  U(1)*U(1))
					{
						//Empty area
						continue;
					}
					
					LineSeg lsRingIntersectionResult = ppRingIntersection.extentInDir(vx);
					double dWidth = abs(vx.dotProduct(lsRingIntersectionResult.ptStart() - lsRingIntersectionResult.ptEnd()));
					double dHeight = abs(vy.dotProduct(lsRingIntersectionResult.ptStart() - lsRingIntersectionResult.ptEnd()));

					//Check if the piece is smaller than the minimum gluable size
					if(dHeight - dMinimumHeightGluableBoard < U(-0.01))
					{
						ppSmallAreas.unionWith(ppRingIntersection);
						continue;
					}

					if(dWidth - dSizeGlueArea < U(-0.01))
					{
						ppSmallAreas.unionWith(ppRingIntersection);
						continue;
					}
					
					//Full board
					ppRingIntersection.vis(2);
					
					lstPropString.setLength(0);
					lstPropString.append(_LineTypes[0]);
					lstPropString.append("Area");	
					
					lstPropInt.setLength(0);
					lstPropInt.append(nZones1);
					lstPropInt.append(nToolingIndexArea);
					
					lstPoints.setLength(0);
					lstPoints.append(ptVertexStart+vy*dShrinkProfileForOddSizes+vx*dSizeGlueArea*0.5);
					lstPoints.append(ptVertexEnd-vy*dShrinkProfileForOddSizes+vx*dSizeGlueArea*0.5);
					tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mpToClone);
				}
			}
			// HSB-7955 doesnt enter here 
//			ppIntersectionAll.transformBy(vy * U(2000));
//			ppIntersectionAll.vis(3);
//			ppIntersectionAll.transformBy(vy * U(-2000));
			
			for (int k=0; k<nPartialAreas; k++)
			{
				double gapBetweenPartialAreas = nFullAreas==0 ? 0 : dSizeGlueArea * (k + 1);
				Point3d ptStartOfStrip =ptStartDistribution-vy*U(4000)+vx*(k*partialAreaWidth + gapBetweenPartialAreas);
				Point3d ptEndOfStrip = ptStartDistribution+vy*U(4000)+vx*((k + 1)*partialAreaWidth + gapBetweenPartialAreas);
				
				Line lnAtStartOfStrip(ptStartOfStrip, vy);
				LineSeg lsThisStrip(ptStartOfStrip, ptEndOfStrip);
				PLine plStrip(vz);
				plStrip.createRectangle(lsThisStrip, vx, vy);
				PlaneProfile ppStripArea(cs);
				ppStripArea.joinRing(plStrip, false);
				
				PlaneProfile ppIntersectionResult(cs);
				ppIntersectionResult=ppIntersection;
				ppIntersectionResult.intersectWith(ppStripArea);
				// HSB-7955: remove the glued areas
				ppIntersectionResult.subtractProfile(ppIntersectionAll);
//								ppIntersectionResult.vis(3);
				
				PLine plAllRings[]=ppIntersectionResult.allRings();
				Point3d ptAllRingVertices[0];
				
				for(int r=0 ; r<plAllRings.length() ; r++)
				{
					PLine ring = plAllRings[r];
					ring.convertToLineApprox(U(10));
					ptAllRingVertices.append(ring.vertexPoints(TRUE));
				}
				
				ptAllRingVertices = lnAtStartOfStrip.projectPoints(ptAllRingVertices);
				ptAllRingVertices = lnAtStartOfStrip.orderPoints(ptAllRingVertices);
				
				LineSeg lsIntersectionResult = ppIntersectionResult.extentInDir(vx);
				double dIntersectionWidth = abs(vx.dotProduct(lsIntersectionResult.ptStart() - lsIntersectionResult.ptEnd()));
				double dIntersectionHeight = abs(vy.dotProduct(lsIntersectionResult.ptStart() - lsIntersectionResult.ptEnd()));
				
				//Check if the piece is smaller than the minimum gluable size
				if(dIntersectionHeight - dMinimumHeightGluableBoard < U(-0.01))
				{
					ppSmallAreas.unionWith(ppIntersectionResult);
					continue;
				}
				// 
				if(dIntersectionWidth - dMinimumWidthToCreateGlueArea< U(-0.01))
				{
					ppSmallAreas.unionWith(ppIntersectionResult);
					continue;
				}
				
				//Go in pairs of vertices
				for(int v=0 ; v<ptAllRingVertices.length() - 1 ; v++)
				{
					Point3d& ptVertexStart = ptAllRingVertices[v];
					Point3d& ptVertexEnd = ptAllRingVertices[v +1];
//					ptVertexStart.vis();
//					ptVertexEnd.vis();
					
					PLine plFullGluableArea;
					plFullGluableArea.createRectangle(LineSeg(ptVertexStart, ptVertexEnd + vx * dIntersectionWidth ), vx, vy );
					PlaneProfile ppGluableArea(plnEl);
					ppGluableArea.joinRing(plFullGluableArea, false);
					
					PlaneProfile ppRingIntersection(plnEl);
					ppRingIntersection=ppIntersectionResult;
					ppRingIntersection.intersectWith(ppGluableArea);
					
					double dRingInteresectionArea = ppRingIntersection.area();
					double dGluableArea =  plFullGluableArea.area();
					if(dRingInteresectionArea <  U(1)*U(1))
					{
						//Empty area
						continue;
					}
					
					LineSeg lsRingIntersectionResult = ppRingIntersection.extentInDir(vx);
					double dWidth = abs(vx.dotProduct(lsRingIntersectionResult.ptStart() - lsRingIntersectionResult.ptEnd()));
					double dHeight = abs(vy.dotProduct(lsRingIntersectionResult.ptStart() - lsRingIntersectionResult.ptEnd()));
					if(dHeight < dMinimumHeightGluableBoard)
					{
						ppSmallAreas.unionWith(ppRingIntersection);
						continue;
					}
					
					if(abs( dRingInteresectionArea-dGluableArea) > U(1)*U(1) || (dSizeGlueArea - dWidth > U(0.1)))
					{
						//Check if the width of the odd size has enough space to go around the profile
						double dMinimumWidthRequiredForGlue = dShrinkProfileForOddSizes * 4;
						if(dWidth <= dMinimumWidthRequiredForGlue)
						{
							if(dWidth < dShrinkProfileForOddSizes)
							{
								continue;
							}
							
							//Create only a single line of glue in the middle
							Point3d startVertex = lsRingIntersectionResult.ptStart() + vx * dWidth * 0.5 + vy * dShrinkProfileForOddSizes;
							Point3d endVertex = lsRingIntersectionResult.ptStart() + vx * dWidth * 0.5 + vy * dHeight - vy * dShrinkProfileForOddSizes;
							
							LineSeg ls(startVertex, endVertex);
							if(ls.length() < dMinimumGlueLineLength)
							{
								continue;
							}
							ls.vis(2);
							
							lstPropString.setLength(0);
							lstPropString.append(_LineTypes[0]);
							lstPropString.append("Line");
							
							lstPropInt.setLength(0);
							lstPropInt.append(nZones1);
							lstPropInt.append(nToolingIndexLine);
							
							lstPoints.setLength(0);
							lstPoints.append(startVertex);
							lstPoints.append(endVertex);
							tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mpToClone);
							
							continue;
						}
						else if(ppRingIntersection.shrink(dShrinkProfileForOddSizes))	//Odd shape, use single nozzles
						{
							{
								LineSeg lsShrunkRingIntersectionResult = ppRingIntersection.extentInDir(vx);
								double dWidth = abs(vx.dotProduct(lsShrunkRingIntersectionResult.ptStart() - lsShrunkRingIntersectionResult.ptEnd()));
								double dHeight = abs(vy.dotProduct(lsShrunkRingIntersectionResult.ptStart() - lsShrunkRingIntersectionResult.ptEnd()));
								if(dHeight < dMinimumHeightGluableBoard)
								{
									continue;
								}
							}
							
							PLine rings[] = ppRingIntersection.allRings();
							if(rings.length() > 0)
							{
								PLine& plFirstRing = rings[0];
								Point3d ptVertices[] = plFirstRing.vertexPoints(FALSE);
								for(int p=0 ; p<ptVertices.length() - 1; p++)
								{
									Point3d& startVertex = ptVertices[p];
									Point3d& endVertex = ptVertices[p+1];
									
									LineSeg ls(startVertex, endVertex);
									if(ls.length() < dMinimumGlueLineLength)
									{
										continue;
									}
									ls.vis(p);
									
									lstPropString.setLength(0);
									lstPropString.append(_LineTypes[0]);
									lstPropString.append("Line");
									
									lstPropInt.setLength(0);
									lstPropInt.append(nZones1);
									lstPropInt.append(nToolingIndexLine);
									
									lstPoints.setLength(0);
									lstPoints.append(startVertex);
									lstPoints.append(endVertex);
									tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mpToClone);
									
								}
							}
						}
						
						continue;
					}
				}
			}
//			ppSmallAreas.transformBy(vx * U(10));
//			ppSmallAreas.vis(1);
//			ppSmallAreas.transformBy(vx * U(-10));
			ppSmallAreas.subtractProfile(ppIntersectionAll);
			//Rebuild part profiles
			PlaneProfile ppRebuiltSmallAreas[0];
			int ringFlags[] = ppSmallAreas.ringIsOpening();
			PLine smallAreaRings [] = ppSmallAreas.allRings();
			
			//Build outer profile
			for (int k=0; k<smallAreaRings.length(); k++)
			{
				if(ringFlags[k] == TRUE) continue; //Ring is opening
				PlaneProfile ppOuterRing(cs);
				ppOuterRing.joinRing(smallAreaRings[k], FALSE);
				ppOuterRing.vis(5);
				
				ppRebuiltSmallAreas.append(ppOuterRing);
			}
			
			//Add openings
			for (int k=0; k<smallAreaRings.length(); k++)
			{
				if(ringFlags[k] == FALSE) continue; //Ring is opening
				PLine& plRing = smallAreaRings[k];
				Point3d ptVertices[] = plRing.vertexPoints(FALSE);
				if(ptVertices.length() == 0) continue;
				
				for(int x = 0 ; x < ppRebuiltSmallAreas.length() ; x++)
				{
					PlaneProfile& ppOuterProfile = ppRebuiltSmallAreas[x];
					if(ppOuterProfile.pointInProfile(ptVertices[0]) != _kPointInProfile) continue;
					
					ppOuterProfile.joinRing(plRing, TRUE);
				}
			}
			
			//Handle small areas horizontally
			for (int k=0; k<ppRebuiltSmallAreas.length(); k++)
			{ 
				PlaneProfile& ppSmallArea = ppRebuiltSmallAreas[k];

				LineSeg lsSmallArea = ppSmallArea.extentInDir(vx);
				Line lnVecX(lsSmallArea.ptStart(), vx);
				Line lnVecY(lsSmallArea.ptStart(), vy);
				
				PLine plAllRings[]=ppSmallArea.allRings();
				Point3d ptAllRingVertices[0];
				
				for(int r=0 ; r<plAllRings.length() ; r++)
				{
					PLine ring = plAllRings[r];
					ring.convertToLineApprox(U(10));
					ptAllRingVertices.append(ring.vertexPoints(TRUE));
				}
				
				Point3d ptVecXRingVertices[] = lnVecX.projectPoints(ptAllRingVertices);
				ptVecXRingVertices = lnVecX.orderPoints(ptVecXRingVertices);
				
				Point3d ptVecYRingVertices[] = lnVecY.projectPoints(ptAllRingVertices);
				ptVecYRingVertices = lnVecY.orderPoints(ptVecYRingVertices);
				
				LineSeg lsIntersectionResult = ppSmallArea.extentInDir(vx);
				double dIntersectionWidth = abs(vx.dotProduct(lsIntersectionResult.ptStart() - lsIntersectionResult.ptEnd()));
				double dIntersectionHeight = abs(vy.dotProduct(lsIntersectionResult.ptStart() - lsIntersectionResult.ptEnd()));
				
				for(int v=0 ; v<ptVecYRingVertices.length() - 1 ; v++)
				{
					Point3d& ptVertexStart = ptVecYRingVertices[v];
					Point3d& ptVertexEnd = ptVecYRingVertices[v +1];
//					ptVertexStart.vis(3);
//					ptVertexEnd.vis(3);
					LineSeg segment(ptVertexStart, ptVertexEnd);
					Point3d ptSegmentMid = segment.ptMid();
					
					LineSeg segAcrossProfile(ptSegmentMid, ptSegmentMid + dIntersectionWidth * vx);
					LineSeg splitSegs[] = ppSmallArea.splitSegments(segAcrossProfile, TRUE);
					for(int s = 0 ; s < splitSegs.length() ; s++)
					{
						LineSeg& splitSeg = splitSegs[s];
						
						Point3d ptVertexStart = splitSeg.ptStart() - segment.length() * 0.5 * vy;
						Point3d ptVertexEnd = splitSeg.ptEnd() + segment.length() * 0.5 * vy;
//						ptVertexStart.vis(1);
//						ptVertexEnd.vis(1);
						
						PLine plFullGluableArea;
						plFullGluableArea.createRectangle(LineSeg(ptVertexStart, ptVertexEnd), vx, vy );
						PlaneProfile ppGluableArea(plnEl);
						ppGluableArea.joinRing(plFullGluableArea, false);
						
						PlaneProfile ppRingIntersection(plnEl);
						ppRingIntersection=ppSmallArea;
						ppRingIntersection.intersectWith(ppGluableArea);
						ppRingIntersection.vis(1);
						double dRingInteresectionArea = ppRingIntersection.area();
						double dGluableArea =  plFullGluableArea.area();
						if(dRingInteresectionArea <  U(1)*U(1))
						{
							//Empty area
							continue;
						}
						LineSeg lsRingIntersectionResult = ppRingIntersection.extentInDir(vx);
//						lsRingIntersectionResult.vis(4);
						double dWidth = abs(vx.dotProduct(lsRingIntersectionResult.ptStart() - lsRingIntersectionResult.ptEnd()));
						double dHeight = abs(vy.dotProduct(lsRingIntersectionResult.ptStart() - lsRingIntersectionResult.ptEnd()));
						// in property is entered dMinimumWidthToCreateGlueArea=90
						if(dWidth -  dMinimumWidthToCreateGlueArea < U(-0.01))
						{
							continue;
						}
						
						//Check if the width of the odd size has enough space to go around the profile
						double dMinimumWidthRequiredForGlue = dShrinkProfileForOddSizes * 4;
						if(dHeight <= dMinimumWidthRequiredForGlue)
						{
							if(dHeight < dShrinkProfileForOddSizes)
							{
								continue;
							}
							
							//Create only a single line of glue in the middle
							Point3d startVertex = lsRingIntersectionResult.ptStart() + vx * dWidth * 0.5 + vy * dShrinkProfileForOddSizes;
							Point3d endVertex = lsRingIntersectionResult.ptStart() + vx * dWidth * 0.5 + vy * dHeight - vy * dShrinkProfileForOddSizes;
							
							LineSeg ls(startVertex, endVertex);
							if(ls.length() < dMinimumGlueLineLength)
							{
								continue;
							}
							ls.vis(2);
							
							lstPropString.setLength(0);
							lstPropString.append(_LineTypes[0]);
							lstPropString.append("Line");
							
							lstPropInt.setLength(0);
							lstPropInt.append(nZones1);
							lstPropInt.append(nToolingIndexLine);
							
							lstPoints.setLength(0);
							lstPoints.append(startVertex);
							lstPoints.append(endVertex);
							tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mpToClone);
							
							continue;
						}
						else if(ppRingIntersection.shrink(dShrinkProfileForOddSizes))	//Odd shape, use single nozzles
						{
							PLine rings[] = ppRingIntersection.allRings();
							if(rings.length() > 0)
							{
								PLine& plFirstRing = rings[0];
								Point3d ptVertices[] = plFirstRing.vertexPoints(FALSE);
								for(int p=0 ; p<ptVertices.length() - 1; p++)
								{
									Point3d& startVertex = ptVertices[p];
									Point3d& endVertex = ptVertices[p+1];
									
									LineSeg ls(startVertex, endVertex);
									if(ls.length() < dMinimumGlueLineLength)
									{
										continue;
									}
									ls.vis(p);
									
									lstPropString.setLength(0);
									lstPropString.append(_LineTypes[0]);
									lstPropString.append("Line");
									
									lstPropInt.setLength(0);
									lstPropInt.append(nZones1);
									lstPropInt.append(nToolingIndexLine);
									
									lstPoints.setLength(0);
									lstPoints.append(startVertex);
									lstPoints.append(endVertex);
									tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mpToClone);
									
								}
							}
						}
					}
				}
			}
		}
	}//End Loop for Nail Multiple Zones
}


Point3d ptDraw = _Pt0;
Display dspl (-1);
//dspl.dimStyle(sDimLayout);

PLine pl1(_XW);
PLine pl2(_YW);
pl1.createCircle(ptDraw, _ZW + _XW, U(0.5));
pl2.createCircle(ptDraw, _ZW - _XW, U(0.5));

dspl.draw(pl1);
dspl.draw(pl2);

_Map.setInt("ExecutionMode",1);


assignToElementGroup(_Element[0], TRUE, 0, 'E');
//eraseInstance();
//return;

#End
#BeginThumbnail



















#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="415" />
        <int nm="BreakPoint" vl="698" />
        <int nm="BreakPoint" vl="696" />
        <int nm="BreakPoint" vl="773" />
        <int nm="BreakPoint" vl="763" />
        <int nm="BreakPoint" vl="501" />
        <int nm="BreakPoint" vl="483" />
        <int nm="BreakPoint" vl="589" />
      </lst>
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End