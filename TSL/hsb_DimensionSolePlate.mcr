#Version 8
#BeginDescription
Last modified by: Chirag Sawjani (chirag.sawjani@hsbcad.com)
18.12.2018  -  version 2.3



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 3
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
* date: 28.03.2011
* version 1.0: Release Version
*
* date: 04.04.2011
* version 1.0: Remove the gap between the dim lines and the object (shrink)
*
* date: 17.02.2012
* version 1.3: Added internal openings and excluded walls which are sitting on their 
* own as they were messing up the dimension lines on the external face
*
* date: 11.02.2013
* version 1.4: Added check for ARX version to cater for multiple AutoCAD versions
*
* date: 12.03.2013
* version 1.5: Bugfix on dimensions coming out with a point in a different Z coordinates so looking scewed
*
* date: 15.03.2013
* version 2.0: Changed the way it works. External walls are now found by Wall Flag
*
* date: 24.08.2015
* version 2.1: Remove write to file for dxx and changed version of autocad to check to be greater than 2012 instead of specific to 2013
*
* date: 16.02.2016
* version 2.2: Added option to include/exclude external openings and splits
*/


//String arSCodeExternalWalls[]={"A", "B", "H", "I"}; //Add more External Walls codes as you request


Unit(1,"mm"); // script uses mm

String sDimStyleCategory = T("|Dimension styles|");
String sOffsetsCategory = T("|Offsets|");
String sGroupingCategory = T("|Grouping|");
String sFloorPlanOptionsCategory = T("|Floor plan options|");

String sArNY[] = {T("No"), T("Yes")};
String sArDimType[] = {T("SolePlate"), T("FloorPlan")};

PropString sDimOption(0, sArDimType, T("Dimension From"), 1);


PropString sDimStyleOutside(1, _DimStyles, T("Dimension style outside elements"));
PropString sDimStyleInside(2, _DimStyles, T("Dimension style inside elements"));
sDimStyleOutside.setCategory(sDimStyleCategory );
sDimStyleInside.setCategory(sDimStyleCategory );

PropDouble dOffsetFromElementsOnOutside(0, U(500), T("Distance to the outside elements"));
PropDouble dBetweenLines(1, U(350), T("Distance between dimension lines"));

PropDouble dOffsetInternal (2, U(250), T("Offset Dimline Internal Wall"));
dOffsetFromElementsOnOutside.setCategory(sOffsetsCategory);
dBetweenLines.setCategory(sOffsetsCategory);
dOffsetInternal .setCategory(sOffsetsCategory);

PropString sGrpNm1(7, "", T("House Level group name"));
sGrpNm1.setDescription("");
PropString sGrpNm2(8, "", T("Floor Level group name"));
sGrpNm2.setDescription("");

sGrpNm1.setCategory(sGroupingCategory );
sGrpNm2.setCategory(sGroupingCategory );

PropString sDimensionExternalOpenings(9, sArNY, T("|Dimension external openings|"), 1);
PropString sDimensionExternalSplits(10, sArNY, T("|Dimension external splits|"), 0);

sDimensionExternalOpenings.setCategory(sFloorPlanOptionsCategory );
sDimensionExternalSplits.setCategory(sFloorPlanOptionsCategory );

int nDimensionExternalOpenings = sArNY.find(sDimensionExternalOpenings, 1);
int nDimensionExternalSplits = sArNY.find(sDimensionExternalSplits, 0);

if (_bOnInsert) {
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	if (_kExecuteKey=="")
		showDialogOnce();
}

int bDimOption= sArDimType.find(sDimOption,0);


if (_bOnInsert)
{
	if (bDimOption)//FloorPlan
	{
		PrEntity ssE(T("Please select Elements"),Element());
	 	if (ssE.go())
		{
	 		Element ents[0];
	 		ents = ssE.elementSet();
	 		for (int i = 0; i < ents.length(); i++ )
			{
				ElementWall el = (ElementWall) ents[i];
				if (el.bIsValid())
				{
					_Element.append(el);
				}
	 		}
	 	}
	}
	else
	{
		PrEntity ssE(T("Please select Soleplates"),Beam());
	 	if (ssE.go())
		{
	 		Beam ents[0];
	 		ents = ssE.beamSet();
	 		for (int i = 0; i < ents.length(); i++ )
			{
	 			Beam bm = (Beam) ents[i];
				if (bm.bIsValid())
				{
	 				_Beam.append(bm);
				}
	 		}
	 	}
	}
	return;
}

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);
//-----------------------------------------------------------------------------------------------------------------------
//                                                 Add selected beams to local array arBm

if (_Beam.length()<1 && _Element.length()<1)
{
	eraseInstance();
	return;
}

Vector3d vx=_XW;
Vector3d vy=_YW;
Vector3d vz=_ZW;


Display dpOutside(-1);
dpOutside.dimStyle(sDimStyleOutside);
Display dpInside(-1);
dpInside.dimStyle(sDimStyleInside);


Point3d ptBase;
if (_Beam.length()>0)
{
	ptBase=_Beam[0].ptCen();
}
else if (_Element.length()>0)
{
	ptBase=_Element[0].ptOrg();

}
Plane pln (ptBase, _ZW);
PlaneProfile ppAllBeams(pln);
Body bdEl;
PlaneProfile ppPlanView(pln);
Point3d ptAllVertex[0];

Opening opAll[0];
Opening opInternal[0];
PlaneProfile ppExternalWalls[0];
Point3d ptExternalWallStarts[0];
Point3d ptExternalWallEnds[0];

int bElements=FALSE;

if (_Beam.length()>0)
{
	Beam arBm[0];
	arBm.append(_Beam);
	for(int i=0;i<arBm.length();i++){
		Beam bm = arBm[i];
		Body bdBm=bm.realBody();
		bdEl.addPart(bdBm);
	
		PlaneProfile ppBm = bdBm.shadowProfile(pln);
		//ppBm.shrink(-U(10));
		PLine arPlBm[] = ppBm.allRings();
		int arBIsOpening[] = ppBm.ringIsOpening();
		for(int j=0;j<arPlBm.length();j++){
			PLine pl = arPlBm[j];
			if( !arBIsOpening[j] ){
				ptAllVertex.append(pl.vertexPoints(TRUE));
				PlaneProfile pp(pl);
				pp.shrink(-U(100));				
				ppAllBeams.unionWith(pp);
			}
		}
	}

	ppAllBeams.shrink(U(100));
}
else if (_Element.length()>0)
{	
	Element elAr[0];
	elAr.append(_Element);
	bElements=TRUE;
	pln=Plane (_Element[0].ptOrg(), _ZW);
	
	for(int i=0;i<_Element.length();i++){
		ElementWall eWall=(ElementWall)_Element[i];
		if(!eWall.bIsValid()) continue;
		Wall wall = (Wall) _Element[i];
		if(!wall.bIsValid()) continue;
		
		int bIsExternal = eWall.exposed();
		if(bIsExternal)
		{
			opAll.append(_Element[i].opening());
		}
		else
		{
			opInternal.append(_Element[i].opening());
		}
		
		Element el = _Element[i];
		PLine plEl=el.plOutlineWall();
		Vector3d vxEl=el.vecX();
		Vector3d vyEl=el.vecY();
		Vector3d vzEl=el.vecZ();


		Body bdBm (plEl, _ZW*U(30), 1);
		Vector3d vx=el.vecX();
		Vector3d vy=el.vecY();
		Vector3d vz=el.vecZ();
		
		//Check if the wall in question is on its own and not connected to other wall
		ElementWall elWall=(ElementWall)el;
		Element elConnected[]=elWall.getConnectedElements();
		if(elConnected.length()>0)
		{				
			bdEl.addPart(bdBm);
		}
				
		PlaneProfile ppBm = bdBm.shadowProfile(pln);
		if(bIsExternal) 
		{ 
			ppExternalWalls.append(ppBm); 
			ptExternalWallStarts.append(wall.ptStart());
			ptExternalWallEnds.append(wall.ptEnd());
		}

		//ppBm.shrink(-U(10));
		//ppBm.vis(2);
		PLine arPlBm[] = ppBm.allRings();
		int arBIsOpening[] = ppBm.ringIsOpening();
		for(int j=0;j<arPlBm.length();j++){
			PLine pl = arPlBm[j];
			if( !arBIsOpening[j] ){
				ptAllVertex.append(pl.vertexPoints(TRUE));
				
				//Check if the wall in question is on its own and not connected to other wall
				if(elConnected.length()>0)
				{				
					PlaneProfile pp(pl);
					pp.shrink(-U(10));
					ppAllBeams.unionWith(pp);
				}
			}
		}
	}
	ppAllBeams.shrink(U(9.999));
}

//bdEl.vis();

//-----------------------------------------------------------------------------------------------------------------------
//      Create bodies of beams, project vertexpoints to plane and add those points to an array
//ppAllBeams.vis(3);
//ppAllBeams.shrink(U(10));


//ppAllBeams.transformBy(_ZW*10);
//ppAllBeams.vis(1);

PLine arPlAllRooms[] = ppAllBeams.allRings();
for(int i=0;i<arPlAllRooms.length();i++)
{
	
	PLine plTemp=arPlAllRooms[i];
	plTemp.transformBy(-(5000)*_ZW); //Distorts angle of some dim lines
	plTemp.vis();
	
	
}
int arBIsOpeningRoom[] = ppAllBeams.ringIsOpening();

//Define Maps
Map mapDimDefinition;

//String strLevelName=sGrpNm2+"_1";
String sGrpNm1Trim = sGrpNm1.trimLeft().trimRight();
String sGrpNm2Trim= sGrpNm2.trimLeft().trimRight(); 
Group grpSolePlate(sGrpNm1Trim + "\\" + sGrpNm2);
grpSolePlate.addEntity(_ThisInst, TRUE, 0, 'D');
Beam bm;
bm.dbCreate(_Pt0, vx, vy, vz, 10, 10, 10);
grpSolePlate.addEntity(bm, TRUE, 0, 'D');

String sLayer= sGrpNm1Trim=="" && sGrpNm2Trim=="" ? "0" :  bm.layerName();
bm.dbErase();

Opening opIgnore[0];
for(int j=0;j<arPlAllRooms.length();j++){
	PLine pl = arPlAllRooms[j];
//	pl.vis();
	if( arBIsOpeningRoom[j] )
	{
		PlaneProfile ppRoom (pl);
		Point3d ptVertexRoom[0];
	/*
		//Project all to the plane of the first vertex
		Point3d ptVertexRoomTemp[]=pl.vertexPoints(FALSE);
		//Check if there are vertices else something gone wrong
		Point3d ptFirstVertex;
		if(ptVertexRoomTemp.length()>0)
		{
			ptVertexRoomTemp[0];
		}
		
		Plane plUnderWall(ptFirstVertex,_ZW);
		for(int p=0;p<ptVertexRoomTemp.length();p++)
		{
			Point3d pt=ptVertexRoomTemp[p];
			pt=pt.projectPoint(plUnderWall,0);
			ptVertexRoom.append(pt);
		}
		*/
		ptVertexRoom.append(pl.vertexPoints(FALSE));
//		pl.vis(2);
		Point3d ptCenter;
		ptCenter.setToAverage(ptVertexRoom);
//		ptCenter.vis();
		

		
		for (int i=0; i<ptVertexRoom.length()-1; i++)
		{
							
			LineSeg ls(ptVertexRoom[i], ptVertexRoom[i+1]);

			Point3d ptCenterSeg=ls.ptMid();
			Vector3d vecDirection=ptVertexRoom[i+1]-ptVertexRoom[i];
			vecDirection.normalize();
//			vecDirection.vis(ptCenter, i);
			if (vecDirection.dotProduct(_XW)<0)
				vecDirection=-vecDirection;
			
			if (vecDirection.dotProduct(_YW)<-0.2)
				vecDirection=-vecDirection;

			Vector3d vecOffset=vecDirection.crossProduct(_ZW);

			Point3d ptToDim[0];
			ptToDim.append(ptVertexRoom[i]);
			ptToDim.append(ptVertexRoom[i+1]);
			
			Vector3d vecText=vecOffset;
			if (vecText.dotProduct(_YW)<0)
				vecText=-vecText;
			if (vecText.dotProduct(_XW)>0.5)
				vecText=-vecText;
			ptCenterSeg=ptCenterSeg+vecOffset*(U(20));
//			ptCenterSeg.vis();
			if ((ppRoom.pointInProfile(ptCenterSeg)==_kPointOutsideProfile))
				vecOffset=-vecOffset;

			//Check it there are any internal openings crossing the vertex
			PLine plVertex(_ZW);
			Vector3d vecVertexNormal=vecDirection.crossProduct(_ZW);
			LineSeg lsRectangle(ptVertexRoom[i]+U(10)*vecVertexNormal, ptVertexRoom[i+1]-U(10)*vecVertexNormal);
			plVertex.createRectangle(lsRectangle,vecDirection,vecVertexNormal);
		     PlaneProfile ppVertex(plVertex);

			//Create a plane along the line of the vertex
			Plane plVertexVertical(ptVertexRoom[i],vecVertexNormal);
			

			
			for(int o=0;o<opInternal.length();o++)
			{
				
	
				Opening op=opInternal[o];
				Element elOp=op.element();
				CoordSys csEl=elOp.coordSys();
				Vector3d vxOpEl=csEl.vecX();
				Vector3d vyOpEl=csEl.vecY();
				Vector3d vzOpEl=csEl.vecZ();								
				csEl.vis();
				
				PLine plOutWall=elOp.plOutlineWall();
				PlaneProfile ppEl(plOutWall);
//				ppEl.vis(2);
				Plane plnY(csEl.ptOrg(), vyOpEl);

				PLine plOpShape=op.plShape();
				PlaneProfile ppOp (csEl);
				ppOp.joinRing(plOpShape, FALSE);
				LineSeg ls=ppOp.extentInDir(vxOpEl);
				Point3d ptS=ls.ptStart();
				Point3d ptM=ls.ptMid();
				Point3d ptE=ls.ptEnd();
				ptS=ptS.projectPoint(plnY, 0);
				ptM=ptM.projectPoint(plnY, 0);
				ptE=ptE.projectPoint(plnY, 0);
//				ptS.vis();
//				ptE.vis();
				PLine plOp(vyOpEl);
				plOp.addVertex(ptS-vzOpEl*U(300));
				plOp.addVertex(ptE-vzOpEl*U(300));
				plOp.addVertex(ptE+vzOpEl*U(300));
				plOp.addVertex(ptS+vzOpEl*U(300));
				plOp.close();
//				plOp.vis(1);
				PlaneProfile ppOpWide(plnY);
				PlaneProfile ppOpTopView (plnY);
				ppOpTopView.joinRing(plOp, FALSE);
				
				ppOpTopView.intersectWith(ppEl);
				ppEl.subtractProfile(ppOpTopView);
//				ppOpTopView.vis(2);
				
				PlaneProfile ppVertexClone=ppVertex;
				if(ppVertexClone.intersectWith(ppOpTopView))
				{
					//Check if opening is in array of ignoring openings as it has already been dimensioned
					if(opIgnore.find(op)!=-1)
					{
						continue;
					}
					
					LineSeg lsOpening=ppOpTopView.extentInDir(vx);
					//Project points to plane of wall vertex
					Point3d ptOpStart=lsOpening.ptStart().projectPoint(plVertexVertical,0);
					Point3d ptOpEnd=lsOpening.ptEnd().projectPoint(plVertexVertical,0);
					ptToDim.append(ptOpStart);
					ptToDim.append(ptOpEnd);
					
					//Mark this opening as ignore from the array of openings so that it does not re-dimension the same opening elsewhere
					opIgnore.append(op);
				}
				
			}

			//Sort array in direction of the vertex
			Line lnVertex(ptVertexRoom[i],vecDirection);
			Point3d ptOrdered[]=lnVertex.orderPoints(ptToDim);
			
			//Send points in pairs to map
			double dCheckArrayLength=(ptOrdered.length()/2)-int(ptOrdered.length()/2);
			if(dCheckArrayLength==0)
			{
				//Only works if array length is even numbers
				for(int p=0;p<ptOrdered.length()-1;p++)
				{
					//Create Dimension Map
					Point3d ptDimMap[0];
					ptDimMap.append(ptOrdered[p]);
					ptDimMap.append(ptOrdered[p+1]);
					Point3d ptOffsetPoint=ptOrdered[p]+vecOffset*dOffsetInternal;
					ptOffsetPoint.vis(1);
					ptDimMap.append(ptOffsetPoint);
					Map mapOut;
					mapOut.setPoint3dArray("Points", ptDimMap);
					mapOut.setString("DimStyle",sDimStyleInside);
					mapOut.setString("LayerName", sLayer);
					mapDimDefinition.appendMap("Dimension", mapOut); //Internal dimensions
				}
			}
			else
			{
				//Create Dimension Map
				Point3d ptDimMap[0];
				ptDimMap.append(ptVertexRoom[i]);
				ptDimMap.append(ptVertexRoom[i+1]);
				Point3d ptOffsetPoint=ptVertexRoom[i]+vecOffset*dOffsetInternal;
				ptDimMap.append(ptOffsetPoint);
				Map mapOut;
				mapOut.setPoint3dArray("Points", ptDimMap);
				mapOut.setString("DimStyle",sDimStyleInside);
				mapOut.setString("LayerName", sLayer);
				//mapDimDefinition.appendMap("Dimension", mapOut);

			}

			
		}
		
	}
}

//bdEl.vis();
_Pt0 = bdEl.ptCen();

PlaneProfile ppEl = bdEl.shadowProfile(pln);
Point3d arPtPl[0];
PLine arPlEl[] = ppEl.allRings();
int arBIsOpening[] = ppEl.ringIsOpening();

for(int j=0;j<arPlEl.length();j++){
	PLine pl = arPlEl[j];
	if( !arBIsOpening[j] ){
		arPtPl.append(pl.vertexPoints(TRUE));
		PlaneProfile pp(pl);
		
		pp.shrink(-U(10));
		ppPlanView.unionWith(pp);
	}
}


ppPlanView.shrink(U(10));
//ppPlanView.vis(3);

//VISUAL OF OUTER PLANEPROFILE
PlaneProfile ppTemp=ppPlanView;
ppTemp.transformBy(-10000*_ZW);
ppTemp.vis(2);
//====NEW CODE

//Gather all the planeprofiles of the openings for analysis with the linesegments
PlaneProfile ppOpening[0];
Point3d ptOpeningStart[0];
Point3d ptOpeningEnd[0];

for (int i=0 ; i<opAll.length(); i++)
{
	Opening op=opAll[i];
	CoordSys csOp=op.coordSys();
	csOp.vis();
	Vector3d vxOp=csOp.vecX();
	Vector3d vyOp=csOp.vecY();
	Vector3d vzOp=csOp.vecZ();
	Plane plHorizontal(csOp.ptOrg(),vyOp);
	Plane plVertical(csOp.ptOrg(),vzOp);
				
	PLine plOpShape=op.plShape();
	PlaneProfile ppOp (plVertical);
	ppOp.joinRing(plOpShape, FALSE);
	LineSeg ls=ppOp.extentInDir(vxOp);
	Point3d ptS=ls.ptStart();
	Point3d ptM=ls.ptMid();
	Point3d ptE=ls.ptEnd();
	ptS=ptS.projectPoint(plHorizontal, 0);
	ptM=ptM.projectPoint(plHorizontal, 0);
	ptE=ptE.projectPoint(plHorizontal, 0);
//	ptS.vis();
//	ptE.vis();
	PLine plOp(vyOp);
	plOp.addVertex(ptS-vzOp*U(300));
	plOp.addVertex(ptE-vzOp*U(300));
	plOp.addVertex(ptE+vzOp*U(300));
	plOp.addVertex(ptS+vzOp*U(300));
	plOp.close();
	plOp.vis(1);
	ptOpeningStart.append(ptS);
	ptOpeningEnd.append(ptE);
	ppOpening.append(PlaneProfile(plOp));
}

PLine plAllRings[]=ppPlanView.allRings();

//Let us gather all the line segments, normals etc from each ring so it is processed onced
int nRingArrayRelation[0];
LineSeg lsAllSegments[0];
Vector3d vecAllNormals[0];


for(int p=0;p<plAllRings.length();p++)
{
	PLine plRing=plAllRings[p];
	Vector3d vNormal=_ZW;
	PLine plNewOutline(vNormal);
	Point3d arPtAll[] = plRing.vertexPoints(false);
	
	Point3d ptArNoClose[0];
	Plane plnNormal;
	if(arPtAll.length()>0)
	{
		plnNormal=Plane(arPtAll[0],_ZW);
	}
	
	if( arPtAll.length() > 2 )
	{
		ptArNoClose.append(arPtAll[0]);
		for (int i=1; i<arPtAll.length(); i++)
		{
			//Analyze initial point with last point and next point
			Point3d pt=arPtAll[i];
			Vector3d v1(arPtAll[i-1] - arPtAll[i]);
			if(v1.length() >U(2)) 
			{
				ptArNoClose.append(arPtAll[i]);
			}
		}
		ptArNoClose.append(ptArNoClose[0]);
	}
		
	if( ptArNoClose.length() > 2 )
	{
		plNewOutline.addVertex(ptArNoClose[0]);
		for (int i=1; i<ptArNoClose.length()-1; i++)
		{
			//Analyze initial point with last point and next point
			Point3d pt=ptArNoClose[i];
			Vector3d v1(ptArNoClose[i-1] - ptArNoClose[i]);
			v1.normalize();
			Vector3d v2(ptArNoClose[i] - ptArNoClose[i+1]);
			v2.normalize();
			if( abs(v1.dotProduct(v2)) <0.99 ) 
			{
				plNewOutline.addVertex(ptArNoClose[i]);
			}
		}
	}
	
	plNewOutline.close();
	plNewOutline.vis(1);
	

	Point3d ptAllVertex[]=plNewOutline.vertexPoints(false);
	
	PlaneProfile ppElOutline(plnNormal);
	ppElOutline.joinRing(plNewOutline, false);
		
	for (int i=0; i<ptAllVertex.length()-1; i++)
	{
		Point3d ptA=ptAllVertex[i];
		//ptA.vis(4);
		Point3d ptB=ptAllVertex[i+1];
		//ptB.vis(3);
		LineSeg ls (ptA, ptB);
		
		Vector3d vSegDir=ptA-ptB;
		vSegDir.normalize();
		Vector3d vSegNormal=vNormal.crossProduct(vSegDir);
		vSegNormal.normalize();
		
		//This point are point on the linesegment but a bit to the inside of them
		Point3d ptA1=ptA-vSegDir*U(2);
		Point3d ptB1=ptB+vSegDir*U(2);
		//ptA1.vis();
		//ptB1.vis();
		
		Line lnA1 (ptA1, vSegNormal);
		Line lnB1 (ptB1, vSegNormal);
		
		LineSeg lsAToFront(ptA+vSegNormal*U(4000), ptA1+vSegNormal*U(0.1));
		LineSeg lsAToBack(ptA-vSegNormal*U(4000), ptA1-vSegNormal*U(0.1));
	
		LineSeg lsBToFront(ptB+vSegNormal*U(4000), ptB1+vSegNormal*U(0.1));
		LineSeg lsBToBack(ptB-vSegNormal*U(4000), ptB1-vSegNormal*U(0.1));
		
		PLine plAToFront(vNormal);
		plAToFront.createRectangle(lsAToFront, vSegNormal, vSegDir);
		
		PLine plAToBack(vNormal);
		plAToBack.createRectangle(lsAToBack, vSegNormal, vSegDir);
		
		PLine plBToFront(vNormal);
		plBToFront.createRectangle(lsBToFront, vSegNormal, vSegDir);
		
		PLine plBToBack(vNormal);
		plBToBack.createRectangle(lsBToBack, vSegNormal, vSegDir);
		
		PlaneProfile ppAToFront(plAToFront);
		PlaneProfile ppAToBack(plAToBack);
		PlaneProfile ppBToFront(plBToFront);
		PlaneProfile ppBToBack(plBToBack);
	
		ppAToFront.intersectWith(ppElOutline);
		ppAToBack.intersectWith(ppElOutline);
		ppBToFront.intersectWith(ppElOutline);
		ppBToBack.intersectWith(ppElOutline);
		
		int nIntFront=0;
		int nIntBack=0;
		int nA=0;
		int nB=0;
		if (ppAToFront.area()/U(1)*U(1)>U(0.1)*U(0.1))//Intersect
		{
			nIntFront++;
			nA++;
		}
		if (ppAToBack.area()/U(1)*U(1)>U(0.1)*U(0.1))//Intersect
		{
			nIntBack++;
			nA++;
		}
		if (ppBToFront.area()/U(1)*U(1)>U(0.1)*U(0.1))//Intersect
		{
			nIntFront++;
			nB++;
		}
		if (ppBToBack.area()/U(1)*U(1)>U(0.1)*U(0.1))//Intersect
		{
			nIntBack++;
			nB++;
		}
		if (nIntFront>nIntBack)
		{
			vSegNormal=-vSegNormal;
		}
	
		if ((ptA-ptB).length()>U(2))
		{
			lsAllSegments.append(ls);
			vecAllNormals.append(vSegNormal);
			nRingArrayRelation.append(p);
		}
	}
}


for(int p=0;p<plAllRings.length();p++)
{
	//Get all line segments for this ring
	LineSeg lsAllEdges[0];
	Vector3d vNormalEdges[0];
	int nCurrentRing=p;
	for(int l=0;l<lsAllSegments.length();l++)
	{
		if(nRingArrayRelation[l]==nCurrentRing)
		{
			lsAllEdges.append(lsAllSegments[l]);
			vNormalEdges.append(vecAllNormals[l]);
		}
	}
	//Need to check each line segment in case it is close to another ring as it could suggest a party wall condition which we do not want to dimension
 	LineSeg lsNewSegments[0];
	Vector3d vecNewNormals[0];
	int nSegmentsToRemove[0];
	for (int s=0; s<lsAllEdges.length(); s++)
	{
		LineSeg ls=lsAllEdges[s];
		Vector3d vNorm=vNormalEdges[s];
		Vector3d vSeg=vNorm.crossProduct(_ZW);
		Plane pnVertical(ls.ptStart(),vNorm);
		
		//Create a plane profile which will check if it intersects with another segment close by 
		PLine plSeg(_ZW);
		plSeg.createRectangle(LineSeg(ls.ptStart()+U(2)*vNorm, ls.ptEnd()),vSeg,vNorm);
		PlaneProfile ppSegment(plSeg);
		int nProfileChanged=false;
		
		for(int r=0;r<lsAllSegments.length();r++)
		{
			//If it is a line segment within this ring then ignore it
			if(nRingArrayRelation[r]==nCurrentRing) continue;
	
			//Create a slender plane profile along the line segment
			LineSeg lsCheck=lsAllSegments[r];
			Vector3d vNormCheck=vecAllNormals[r];
			Vector3d vSegCheck=vNormCheck.crossProduct(_ZW);
			vNormCheck.vis(ls.ptStart(),3);
			vNorm.vis(ls.ptStart(),3);			
			
			PLine plSegCheck(_ZW);
			plSegCheck.createRectangle(LineSeg(lsCheck.ptStart()+U(200)*vNormCheck,lsCheck.ptEnd()),vSegCheck,vNormCheck);
			
			PlaneProfile ppSegCheck(plSegCheck);
			
			//Check that the segments are parallel to each other, otherwise we are not interested in it
			if(vNormCheck.dotProduct(vNorm)>U(-0.99)) continue;

			//Check for intersection
			PlaneProfile ppSegmentTemp=ppSegment;
			int nSuccess=ppSegmentTemp.intersectWith(ppSegCheck);
			if(nSuccess)
			{
				//reportNotice("\n"+s+"-"+r);
				ppSegment.subtractProfile(ppSegCheck);				
				PlaneProfile ppTemp=ppSegment;
				ppTemp.transformBy(-10000*_ZW);
				ppTemp.vis(3);
				
				nProfileChanged=true;
			}

		}
		
		if(nProfileChanged)
		{
			//It is possible the profile has more than one segment now
			PLine plNewRings[]=ppSegment.allRings();
			for(int n=0;n<plNewRings.length();n++)
			{
				PLine plNew=plNewRings[n];

				PlaneProfile ppNew(plNew);
				LineSeg lsNew=ppNew.extentInDir(vSeg);
				
				//Project vertices of line segment to segment vector
				Point3d ptNewStart=lsNew.ptStart().projectPoint(pnVertical,0);
				Point3d ptNewEnd=lsNew.ptEnd().projectPoint(pnVertical,0);
				
				lsNewSegments.append(LineSeg(ptNewStart,ptNewEnd));
				vecNewNormals.append(vNorm);
				
			}
			nSegmentsToRemove.append(s);
			
		}		
	}
	
	//Make the necessary changes, viz add new segments and remove segments
	for(int s=0;s<nSegmentsToRemove.length();s++)
	{
		lsAllEdges[nSegmentsToRemove[s]].transformBy(-9000*_ZW);
		lsAllEdges[nSegmentsToRemove[s]].vis(5);
	}
	for(int s=nSegmentsToRemove.length()-1;s>=0;s--)
	{
		lsAllEdges.removeAt(nSegmentsToRemove[s]);
		vNormalEdges.removeAt(nSegmentsToRemove[s]);
	}
	for(int s=0;s<lsNewSegments.length();s++)
	{
		lsAllEdges.append(lsNewSegments[s]);
		vNormalEdges.append(vecNewNormals[s]);
	}

	for (int s=0; s<lsAllEdges.length(); s++)
	{
		//Init First line array
		Point3d ptFirstLine[0];
		
		LineSeg ls=lsAllEdges[s];
		Vector3d vecSegment=ls.ptStart()-ls.ptEnd();
		vecSegment.normalize();
		Vector3d vecNorm=vNormalEdges[s];
		Plane plSegment(ls.ptStart(),_ZW);
		Plane plSegmentVertical(ls.ptStart(),vecNorm);
		vecNorm.vis(ls.ptMid(),3);
		double dOffsetLines=dOffsetFromElementsOnOutside;
		
		
		//First Line dimensions with openings
		Point3d ptRecStart=ls.ptStart()+U(5)*vecNorm;
		Point3d ptRecEnd=ls.ptEnd()-U(5)*vecNorm;
		PLine plRecSegment(_ZW);
		plRecSegment.createRectangle(LineSeg(ptRecStart,ptRecEnd),vecSegment,vecNorm);
		plRecSegment.vis();
		PlaneProfile ppRecSegment(plRecSegment);
		Line lnSegment(ls.ptStart(),vecSegment);

		if(nDimensionExternalSplits)
		{
			Point3d ptDims[0];
			for(int s=0;s<ppExternalWalls.length();s++)
			{
				PlaneProfile ppExternalWall = ppExternalWalls[s];
				int nIntersection=ppExternalWall.intersectWith(ppRecSegment);
				
				//Check if the points are in line with the current segment as it is possible that a wall running out would intersect
				//with the current line segment and you will end up with points at the edges of the segment coming from the wall which is running out
				Vector3d vecWallLength = ptExternalWallStarts[s] - ptExternalWallEnds[s];
				if(abs(vecSegment.dotProduct(vecWallLength)) > U(0.99))
				{
					if(nIntersection)
					{
						Point3d ptS=ptExternalWallStarts[s].projectPoint(plSegmentVertical,0);
						Point3d ptE=ptExternalWallEnds[s].projectPoint(plSegmentVertical,0);
						ptDims.append(ptS);
						ptDims.append(ptE);
					}				
				}
			}
			
			ptDims=lnSegment.orderPoints(ptDims);
			//Check if there are any points coincident with the start and end of the segment, if neither match then ignore either start of end of the ptDims
			int bRemoveStartPoint = true;
			for(int p=0; p<ptDims.length();p++)
			{
				Point3d ptCurr=ptDims[p];
				if(abs(ptCurr.dotProduct(ls.ptStart())) < U(0.01))
				{
					//Coincident point found
					bRemoveStartPoint = false;
					break;
				}
			}

			int bRemoveEndPoint = true;
			for(int p=0; p<ptDims.length();p++)
			{
				Point3d ptCurr=ptDims[p];
				if(abs(ptCurr.dotProduct(ls.ptEnd())) < U(0.01))
				{
					//Coincident point found
					bRemoveEndPoint = false;
					break;
				}
			}		
			
			if(bRemoveStartPoint && ptDims.length() > 0) { ptDims.removeAt(0); }
			if(bRemoveEndPoint && ptDims.length() > 0) { ptDims.removeAt(ptDims.length() -1); }
			
			for(int p=0; p<ptDims.length();p++)
			{
				ptFirstLine.append(ptDims[p]);
			}
		}
		
		//Check whether an opening lies on a segment
		if(nDimensionExternalOpenings)
		{
			for(int o=0;o<ppOpening.length();o++)
			{
				PlaneProfile ppOpeningCurr=ppOpening[o];
				
				int nIntersection=ppOpeningCurr.intersectWith(ppRecSegment);
				if(nIntersection)
				{
					//Project point to the vertical plane and also the horizontal plane as the opening's coordinate system could be anywhere
					Point3d ptS=ptOpeningStart[o].projectPoint(plSegmentVertical,0).projectPoint(plSegment,0);
					Point3d ptE=ptOpeningEnd[o].projectPoint(plSegmentVertical,0).projectPoint(plSegment,0);
					ptFirstLine.append(ptS);
					ptFirstLine.append(ptE);
				}
				
			}
		}
		
		//Add initial points of the segment.  But check there's any opening dimensions as there is no point puttting a line if there's no openings
		if(ptFirstLine.length()>0)
		{
			ptFirstLine.append(ls.ptStart());
			ptFirstLine.append(ls.ptEnd());
		}
		
		//Order the points on the line
		ptFirstLine=lnSegment.orderPoints(ptFirstLine);


		for (int i=0; i<ptFirstLine.length()-1; i++)
		{
			//Create Dimension Map
			Point3d ptDimMap[0];
			ptDimMap.append(ptFirstLine[i]);
			ptDimMap.append(ptFirstLine[i+1]);
			Point3d ptOffsetPoint=ptFirstLine[i]+vecNorm*dOffsetLines;
			ptDimMap.append(ptOffsetPoint);
			Map mapOut;
			mapOut.setPoint3dArray("Points", ptDimMap);
			mapOut.setString("DimStyle",sDimStyleOutside);
			mapOut.setString("LayerName", sLayer);
			//Second Line from Inside
			mapDimDefinition.appendMap("Dimension", mapOut); //External dimline with openings
		}
		
		//Again no point offsetting if there was no dimline
		if(ptFirstLine.length()>0)
		{
			dOffsetLines+=dOffsetFromElementsOnOutside;
		}
		
		//Second line dimensions
		Point3d ptSecondLine[0];	
	
		ptSecondLine.append(ls.ptStart());
		ptSecondLine.append(ls.ptEnd());
		
		for (int i=0; i<ptSecondLine.length()-1; i++)
		{
			//Create Dimension Map
			Point3d ptDimMap[0];
			ptDimMap.append(ptSecondLine[i]);
			ptDimMap.append(ptSecondLine[i+1]);
			Point3d ptOffsetPoint=ptSecondLine[i]+vecNorm*dOffsetLines;
			ptDimMap.append(ptOffsetPoint);
			Map mapOut;
			mapOut.setPoint3dArray("Points", ptDimMap);
			mapOut.setString("DimStyle",sDimStyleOutside);
			mapOut.setString("LayerName", sLayer);
			//Second Line from Inside
			mapDimDefinition.appendMap("Dimension", mapOut); //External dimline overall
		}
		
	
	}	
	
}

//Check which arx version is running
int nArxVersion=arxVersion();
String strAssemblyPath;

if(nArxVersion==2012)
{
	strAssemblyPath=_kPathHsbInstall+"\\Content\\UK\\TSL\\DLLs\\Dimension\\hsb_TSLDimensions2012.dll";
}
else if(nArxVersion >= 2013)
{
	strAssemblyPath=_kPathHsbInstall+"\\Content\\UK\\TSL\\DLLs\\Dimension\\hsb_TSLDimensions2013.dll";
}

String strType = "hsb_TSLDimensions.TSLDimension";
String strFunction = "CreateDimensions";
//reportMessage (T("\n|Number of entities selected:| ") + ents.length());
//mapDimDefinition.writeToDxxFile("c:\\test.dxx");
Map mapOut= callDotNetFunction2(strAssemblyPath, strType, strFunction, mapDimDefinition);

if (!mapOut.hasString("Result"))
{
	reportNotice("No Valid dll or path not found");
}
else if (mapOut.hasString("Result"))
{
	String sMes=mapOut.getString("Result");
	if (sMes!="")
	{
		reportNotice("\n"+sMes);
	}
}


//dpOutside.draw("TSL",_Pt0,_XU,_YU,1,1); // draw a string with default text style with lower left corner at pnt1 
eraseInstance();

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
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End