#Version 8
#BeginDescription
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 02.02.2011
* version 1.10









#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
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
* date: 04.09.2008
* version 1.0: Release Version
*
* date: 10.09.2008
* version 1.1: Fix the display when the align is changed
*
* date: 03.03.2009
* version 1.3: Always show the display as center and above the element
*
* date: 24.08.2009
* version 1.4: Add the option to specify an extrusion profile for the PointLoad Beams
*
* date: 24.08.2009
* version 1.5: Increase the range of posible beams from 1 to 12
*
* date: 03.11.2009
* version 1.6: 	Fix the issue when the poinload is insert in a wall with 2 bottom plates like the SuperFrame
*				Fix the issue of duplicated child TSLs when the drawing is open.
*				Change the Display a bit.
*
* date: 21.07.2010
* version 1.7: Add the code to be able to run this from the pallette
*
* date: 22.09.2010
* version 1.8: Fix issue when the poinload is insert in the edge of the element and can not find intersection with the top and bottom plate
*
* date: 07.10.2010
* version 1.9: Assign the icon to the group of the lowest element
*
* date: 02.02.2010
* version 1.10: BeamCode "H" in Token Position 0 is ignored from the check for lintel body intersection with pointload beams.
*/

_ThisInst.setSequenceNumber(-100);

Unit (1,"mm");
double dEps = U(0.1);

//-------------------------------------------------------------------------------------------------------------------------------------------
//                                                                                  properties
//Alignment
String arSAlign[] = {
	"Left",
	"Center",
	"Right"
};
int arNAlign[] = {
	-1,
	0,
	1
};
PropString sAlign(0, arSAlign, "Align",1);


//Nr of beams
int arNNrOfBms[] = {1,	2,3,4,5,6,7,8,9,10,11,12};
PropInt nNrOfBms(0,arNNrOfBms,"Nr. of beams in pointload");
PropString sExtrusionProfile(2, ExtrProfile().getAllEntryNames(), T("|Extrusion profile name|"));
PropString sDimStyle(1, _DimStyles, "Text style");

// Load the values from the catalog
if (_bOnDbCreated || _bOnInsert) setPropValuesFromCatalog(_kExecuteKey);

int nAlign = arNAlign[arSAlign.find(sAlign,1)];
//-------------------------------------------------------------------------------------------------------------------------------------------
//                                                                                      insert
if(_bOnInsert){
	PrEntity ssE("\nSelect a set of elements",Element());
	if (ssE.go()) {
		Entity ents[0];
		ents = ssE.set(); 
		for (int i=0; i<ents.length(); i++) {
			Element el = (Element)ents[i];
			_Element.append(el);
		}
	}

	_Pt0 = getPoint("Select an insertion point");
	
	if (_kExecuteKey=="")
		showDialogOnce();
	return;
}

//-------------------------------------------------------------------------------------------------------------------------------------------
//                                                                      define some usefull variables
if(_Element.length() == 0){eraseInstance(); return;}

int nMap = 0;
while( _Map.hasMap("mapElement" + nMap) ){
	Map mapElement = _Map.getMap("mapElement" + nMap);
	
	
	if( mapElement.hasEntity("PointLoad") ){
		Entity ent= mapElement.getEntity("PointLoad");
		TslInst tsl = (TslInst)ent;
		Map mapTsl = tsl.map();
		if( mapTsl.hasMap("MapElement") ){
			Map mapElement = mapTsl.getMap("MapElement");
			int nBm = 0;
			while( mapElement.hasEntity("bmNew" + nBm) ){
				Entity ent= mapElement.getEntity("bmNew" + nBm);
				ent.dbErase();
				nBm++;
			}
		}
		ent.dbErase();
	}
	
	nMap++;
}
_Map = Map();

Map mapPointLoad;
int nNrOfPointLoads = 0;
int bTotalPointLoadIsValid = TRUE;
double dBmH;
double dBmW;

Element elLowest=_Element[0];

for(int e=0;e<_Element.length();e++)
{
	Element el = _Element[e];
	CoordSys csEl = el.coordSys();
	Vector3d vx = csEl.vecX();
	Vector3d vy = csEl.vecY();
	Vector3d vz = csEl.vecZ();

	if (sExtrusionProfile != _kExtrProfRectangular)
	{
		ExtrProfile ep(sExtrusionProfile ); 
	
		PlaneProfile ppExtProf();
		ppExtProf=ep.planeProfile();
		LineSeg ls=ppExtProf.extentInDir(_XW);
		dBmW=abs(_XW.dotProduct(ls.ptStart()-ls.ptEnd()));
	}
	else
	{
		dBmW = el.dBeamHeight();
	}

	dBmH = el.dBeamWidth();
	

	//Project _Pt0 on front of zone 0
	_Pt0 = _Pt0.projectPoint(Plane(el.ptOrg(), vz),0);
	Point3d ptInsert = _Pt0 + vy * vy.dotProduct(el.ptOrg() - _Pt0);
	_Pt0 = ptInsert;

	//Debug
	_Pt0.vis();
	ptInsert.vis(5);
	vx.vis(_Pt0, 1);
	vy.vis(_Pt0, 3);
	vz.vis(_Pt0, 150);

	Beam arBm[] = el.beam();

	//-------------------------------------------------------------------------------------------------------------------------------------------
	//                                                                      Find top and bottom beam
	int arNBmTypeTop[] = {
		_kSFTopPlate,
		_kTopPlate,
		_kSFAngledTPLeft,
		_kSFAngledTPRight
	};
	int arNBmTypeBottom[] = {
		_kSFBottomPlate
	};
	int arNBmTypeOpening[] = {
		_kKingStud,
		_kHeader,
		_kSFTransom,
		_kSFSupportingBeam,
		_kSFPacker,
		_kSFJackOverOpening,
		_kSFJackUnderOpening,
		_kSill
	};

	Beam arBmTop[0];
	Beam arBmBottom[0];
	Beam arBmOpening[0];
	for(int i=0;i<arBm.length();i++){
		Beam bm = arBm[i];
		String sBeamCode=bm.beamCode();
		if( arNBmTypeTop.find(bm.type()) != -1 ){
			arBmTop.append(bm);
		}
		else if( arNBmTypeBottom.find(bm.type()) != -1 ){
			arBmBottom.append(bm);
		}
		//Ignore Beams with Code H in BeamCode Token Position 0
		else if( arNBmTypeOpening.find(bm.type()) != -1 &&  sBeamCode.token(0)!="H"){
			arBmOpening.append(bm);
		}
	}
	//Check if there are beams to stretch to.
	if(arBmTop.length() == 0 || arBmBottom.length() == 0)
	{
		Display dp(3);
		dp.dimStyle(sDimStyle);
		PLine plDisplay(vy);
		Point3d ptDraw=_Pt0;
		ptDraw = ptDraw.projectPoint(Plane(el.ptOrg(), vy),0);
		ptDraw = ptDraw - vz*(dBmH*0.5);
		if (nAlign==-1)
			ptDraw=ptDraw-vx*(dBmW*nNrOfBms);
		if (nAlign==0)
			ptDraw=ptDraw-vx*((dBmW*nNrOfBms)*0.5);
			
		Point3d ptDisplay=ptDraw-vz*(dBmH)+vx*((dBmW)*nNrOfBms)*0.5;
		plDisplay.addVertex(ptDraw-vz*(dBmH*0.5));
		plDisplay.addVertex(ptDraw-vz*(dBmH*0.5)+vx*(dBmW)*nNrOfBms);
		plDisplay.addVertex(ptDraw+vz*(dBmH*0.5)+vx*(dBmW)*nNrOfBms);
		plDisplay.addVertex(ptDraw+vz*(dBmH*0.5));
		plDisplay.close();
		
		PLine plDisplay2(vy);
		plDisplay2.addVertex(ptDraw-vz*(dBmH*0.5));
		plDisplay2.addVertex(ptDraw+vz*(dBmH*0.5)+vx*(dBmW)*nNrOfBms);
		
		PLine plDisplay3(vy);
		plDisplay3.addVertex(ptDraw+vz*(dBmH*0.5));
		plDisplay3.addVertex(ptDraw-vz*(dBmH*0.5)+vx*(dBmW)*nNrOfBms);
		//plDisplay.addVertex(_Pt0+vx*(dBmW)*nNrOfBms);
		dp.draw(plDisplay);
		dp.draw(plDisplay2);
		dp.draw(plDisplay3);
		Point3d ptText=_Pt0;
		double dHText=dp.textHeightForStyle("PL", sDimStyle);
		ptText=ptText+_Element[0].vecZ()*dHText*1.5;
		dp.draw("PL " + nNrOfBms, ptText, _Element[0].vecX(), _Element[0].vecZ(), 0, 0, _kDevice);
		return;
	}
	
	//Body to find intersection with the Top and bottom plate
	Body bdPL(ptInsert, vy, vx, vz, U(12000), nNrOfBms * dBmW, dBmH, 0, nAlign, 0);
	bdPL.vis(3);
	//Beam to stretch to on top.
	Beam bmTop;
	double dMin;
	int bMinSet = FALSE;
	for(int i=0;i<arBmTop.length();i++){
		Beam bm = arBmTop[i];
		Body dbBm=bm.realBody();
		//Point3d ptBmMin = bm.ptRef() + bm.vecX() * bm.dLMin();
		//Point3d ptBmMax = bm.ptRef() + bm.vecX() * bm.dLMax();
		//double dBmMin = vx.dotProduct(ptBmMin - ptInsert);
		//double dBmMax = vx.dotProduct(ptBmMax - ptInsert);
		
		if (!bdPL.hasIntersection(dbBm)) continue;
		//if( (dBmMin * dBmMax) > 0 ) continue;
		
		Line ln(bm.ptCen(), bm.vecX());
		Point3d ptIntersect = ln.intersect(Plane(ptInsert, vx),0);
		double dDist = vy.dotProduct(ptIntersect - ptInsert);
	
		if( !bMinSet ){
			dMin = dDist;
			bmTop = bm;
			bMinSet = TRUE;
		}
		else{
			if( (dMin - dDist) > dEps ){
				dMin = dDist;
				bmTop = bm;
			}
		}
	}

	//Beam to stretch to on bottom
	Beam bmBottom;
	double dMax;
	int bMaxSet = FALSE;
	for(int i=0;i<arBmBottom.length();i++){
		Beam bm = arBmBottom[i];
		Body dbBm=bm.realBody();
		//Point3d ptBmMin = bm.ptRef() + bm.vecX() * bm.dLMin();
		//Point3d ptBmMax = bm.ptRef() + bm.vecX() * bm.dLMax();
		//double dBmMin = vx.dotProduct(ptBmMin - ptInsert);
		//double dBmMax = vx.dotProduct(ptBmMax - ptInsert);
		
		if (!bdPL.hasIntersection(dbBm)) continue;		
		//if( (dBmMin * dBmMax) > 0 ) continue;
	
		Line ln(bm.ptCen(), bm.vecX());
		Point3d ptIntersect = ln.intersect(Plane(ptInsert, vx),0);
		double dDist = vy.dotProduct(ptIntersect - ptInsert);


	
		if( !bMaxSet ){
			dMax = dDist;
			bmBottom = bm;
			bMaxSet = TRUE;
		}
		else{
			if( (dDist - dMax) > dEps ){
				dMax = dDist;
				bmBottom = bm;
			}
		}
	}

	//Check if there is a valid top and bottom beam
	if( !bmTop.bIsValid() || !bmBottom.bIsValid() ) return;

	Body bdOpening;
	for(int i=0;i<arBmOpening.length();i++){
		Beam bm = arBmOpening[i];
		bdOpening.addPart(bm.realBody());
	}
	bdOpening.vis(1);

	Point3d ptCenter = (bmTop.ptCen() + bmBottom.ptCen())/2;
	ptCenter = ptCenter + vx * vx.dotProduct(ptInsert - ptCenter);
	ptCenter.vis(6);

	Body bdPointLoad(ptCenter, vy, vx, vz, U(3000), nNrOfBms * dBmW, dBmH, 0, nAlign, 0);
	bdPointLoad.vis(3);

	int bThisPointLoadIsValid = TRUE;
	Point3d ptInOpening;
	if( arBmOpening.length() > 0 ){
		bThisPointLoadIsValid = !bdPointLoad.hasIntersection(bdOpening);
		Body bdTmp = bdPointLoad;
		int n= bdTmp.intersectWith(bdOpening);bdTmp.vis(5);
		ptInOpening = bdTmp.ptCen();
	}

	if( bTotalPointLoadIsValid ){
		bTotalPointLoadIsValid = bThisPointLoadIsValid;
	}

	Point3d arPtOpening[0];
	PlaneProfile ppEl = el.profNetto(0);
	PLine arPlEl[] = ppEl.allRings();
	int arBIsOpening[] = ppEl.ringIsOpening();
	for(int i=0;i<arPlEl.length();i++){
		if( !arBIsOpening[i] )continue;
		Body bd(arPlEl[i], vz, 0);
		arPtOpening.append(bd.ptCen());
	}
	Point3d ptOpening;
	Beam bmKSLeft;
	Beam bmKSRight;
	PLine plOp1(vz);
	PLine plOp2(vz);
	Point3d ptText;
	if( !bThisPointLoadIsValid ){
		for(int i=0;i<arPtOpening.length();i++){
			double dDist = abs( vx.dotProduct(arPtOpening[i] - ptInOpening) );
			if( !bMinSet ){
				dMin = dDist;
				ptOpening = arPtOpening[i];
				bMinSet = TRUE;
			}
			else{
				if( (dMin - dDist) > dEps ){
					dMin = dDist;
					ptOpening = arPtOpening[i];
				}
			}
		}
	
		double dKSLeft;
		double dKSRight;
		int bLeftSet = FALSE;
		int bRightSet = FALSE;
		for(int i=0;i<arBmOpening.length();i++){
			Beam bm = arBmOpening[i];
			if( bm.type() != _kKingStud )continue;
			double dDist = vx.dotProduct(bm.ptCen() - ptOpening);
			if( dDist < 0 ){//Left
				if( !bLeftSet ){
					dKSLeft = dDist;
					bmKSLeft = bm;
					bLeftSet = TRUE;
				}
				else{
					if( (dDist - dKSLeft) > dEps ){
						dKSLeft = dDist;
						bmKSLeft = bm;
					}
				}
			}
			else if( dDist > 0 ){//Right
				if( !bRightSet ){
					dKSRight = dDist;
					bmKSRight = bm;
					bRightSet = TRUE;
				}
				else{
					if( (dKSRight - dDist) > dEps ){
						dKSRight = dDist;
						bmKSRight = bm;
					}
				}
			}
		}
		plOp1.addVertex(bmKSLeft.ptCen() + vy * 0.5 * bmKSLeft.dL() - vx * 0.5 * bmKSLeft.dW());
		plOp1.addVertex(bmKSRight.ptCen() -  vy * 0.5 * bmKSRight.dL() + vx * 0.5 * bmKSRight.dW());
		plOp2.addVertex(bmKSLeft.ptCen() - vy * 0.5 * bmKSLeft.dL() - vx * 0.5 * bmKSLeft.dW());
		plOp2.addVertex(bmKSRight.ptCen() +  vy * 0.5 * bmKSRight.dL() + vx * 0.5 * bmKSRight.dW());
	
		ptText = ptOpening - vy * 0.5 * bmKSLeft.dL();
	}


	Point3d arPtBm[0];
	Point3d ptLeft = ptCenter + vx * (nAlign - 1) * 0.5 * dBmW * nNrOfBms;ptLeft.vis(6);
	for(int i=0;i<nNrOfBms;i++){
		arPtBm.append(ptLeft + vx * i * dBmW);
	}

	Map mapThisPointLoad;
	mapThisPointLoad.setEntity("el"+e,el);
	mapThisPointLoad.setInt("bThisPointLoadIsValid", bThisPointLoadIsValid);
	mapThisPointLoad.setEntity("bmTop", bmTop);
	mapThisPointLoad.setEntity("bmBottom", bmBottom);
	for(int i=0;i<arPtBm.length();i++){
		Point3d pt = arPtBm[i];
		Plane pln (el.ptOrg(), vz);
		pt=pln.closestPointTo(pt);
		mapThisPointLoad.setPoint3d("ptBm"+i,pt);
	}
	mapThisPointLoad.setPLine("plOp1", plOp1);
	mapThisPointLoad.setPLine("plOp2", plOp2);
	mapThisPointLoad.setPoint3d("ptText", ptText);
	mapPointLoad.setMap("map"+nNrOfPointLoads, mapThisPointLoad);
	nNrOfPointLoads++;
	
	//Find the lowest element
	if (elLowest.ptOrg().Z() > el.ptOrg().Z())
		elLowest=el;


}

Display dp(3);
dp.dimStyle(sDimStyle);

Point3d ptText=_Pt0;
double dHText=dp.textHeightForStyle("PointLoad", sDimStyle);
ptText=ptText+elLowest.vecZ()*dHText;
ptText.vis();

dp.draw("PL " + nNrOfBms, ptText, elLowest.vecX(), -elLowest.vecZ(), 0, 0);

if( !bTotalPointLoadIsValid ){
	dp.color(1);
}
int nMapIndex = 0;
for(int i=0;i<nNrOfPointLoads;i++){
	if( mapPointLoad.hasMap("map" + i) ){
		Map mapThisPointLoad = mapPointLoad.getMap("map" + i);
		
		Element el;
		if( mapThisPointLoad.hasEntity("el" + i) ){
			Entity ent = mapThisPointLoad.getEntity("el" + i);
			el = (Element)ent;
		}
		Vector3d vx = el.vecX();
		Vector3d vy = el.vecY();
		Vector3d vz = el.vecZ();
		
		int bThisPointLoadIsValid;
		if( mapThisPointLoad.hasInt("bThisPointLoadIsValid") ){
			bThisPointLoadIsValid = mapThisPointLoad.getInt("bThisPointLoadIsValid");
		}
		
		if( bThisPointLoadIsValid ){
			Beam bmTop;
			Beam bmBottom;
			if( mapThisPointLoad.hasEntity("bmTop") ){
				Entity ent = mapThisPointLoad.getEntity("bmTop");
				bmTop = (Beam)ent;
			}
			if( mapThisPointLoad.hasEntity("bmBottom") ){
				Entity ent = mapThisPointLoad.getEntity("bmBottom");
				bmBottom = (Beam)ent;
			}

			TslInst tslThisPointLoad;
			
			String strScriptName = "hsbCAD_Point Load";
			
			Vector3d vecUcsX(1,0,0);
			Vector3d vecUcsY(0,1,0);
			
			Beam lstBeams[0];
			Element lstElements[0];
			Point3d lstPoints[0];
			
			int lstPropInt[0];
			double lstPropDouble[0];
			String lstPropString[0];
			
			lstElements.append(el);
			lstPoints.append(_Pt0);		
			lstPropInt.append(nNrOfBms);
			lstPropString.append(sDimStyle);
			lstPropString.append(sExtrusionProfile);
			tslThisPointLoad.dbCreate(	strScriptName,
										vecUcsX,vecUcsY,
										lstBeams, lstElements, lstPoints,
										lstPropInt, lstPropDouble, lstPropString
									);
									
			tslThisPointLoad.setMap(mapThisPointLoad);

			tslThisPointLoad.assignToElementGroup(el);
			Map mapElement;
			mapElement.setEntity("PointLoad", tslThisPointLoad);

			_Map.setMap("mapElement" + nMapIndex, mapElement);
			nMapIndex++;
			
		}
		else{//draw cross
			if( mapThisPointLoad.hasPLine("plOp1") ){
				dp.draw(mapThisPointLoad.getPLine("plOp1"));
			}
			if( mapThisPointLoad.hasPLine("plOp2") ){
				dp.draw(mapThisPointLoad.getPLine("plOp2"));
			}
			if( mapThisPointLoad.hasPoint3d("ptText") ){
				Point3d ptT = mapThisPointLoad.getPoint3d("ptText");
				dp.draw("Please change opening", ptT, vx, vy, 0, 1.25);
				dp.draw("to fit the point load!", ptT, vx, vy, 0, -1.25);
			}
		}
		
		
	}
	else{
		return;
	}	
}

assignToElementFloorGroup(elLowest, TRUE, 0, 'E');

















#End
#BeginThumbnail




















#End
