#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
16.10.2014  -  version 1.01

This tsl intgrates a steelbeam in the topplate of an element.






#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl intgrates a steelbeam in the topplate of an element.
/// </summary>

/// <insert>
/// Select a set of steelbeams and a set of elements.
/// </insert>

/// <remark Lang=en>
/// Only the steelbeams that are not belong to an element are taken into account.
/// </remark>

/// <version  value="1.01" date="16.10.2014"></version>

/// <history>
/// AS - 1.00 - 07.05.2014 	- Pilot version
/// AS - 1.01 - 16.10.2014 	- Draw in zones where steel intersects. Add gap under steelbeam. Cut sheeting
/// </history>

double dEps = Unit(0.01, "mm");

int arBExclude[] = {_kNo, _kYes};
String arSFilterType[] = {T("|Include|"), T("|Exclude|")};


PropString sSeperator01(0, "", T("|Selection|"));
sSeperator01.setReadOnly(true);
PropString sFilterType(1, arSFilterType, "     "+T("|Filter type|"));
PropString sFilterBC(2, "", "     "+T("|Filter beams with beamcode|"));

PropString sSeperator02(3, "", T("|Cut out|"));
sSeperator02.setReadOnly(true);
PropDouble dGap(0, U(5), "     "+T("|Gap|"));
PropDouble dGapUnderSteelBm(1, U(0), "     "+T("|Gap under steel beam|"));

PropString sSeperator03(4, "", T("|Visualization|"));
sSeperator03.setReadOnly(true);



// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_E-IntegrateSteelbeam");
if( arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

if( _bOnInsert ){
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	
	// Select the steelbeams
	PrEntity ssBm(T("Select a set of steelbeams"), Beam());	
	Beam arBmSteel[0];
	if( ssBm.go() ){
		Beam arSelectedBeam[] = ssBm.beamSet();
		
		for( int i=0;i<arSelectedBeam.length();i++ ){
			Beam bm = arSelectedBeam[i];
			if( !bm.element().bIsValid() && bm.extrProfile() != _kExtrProfRectangular )
				arBmSteel.append(bm);
		}
	}
	
	// Select the elements
	PrEntity ssE(T("Select a set of elements"), Element());
	
	if( ssE.go() ){
		Element arSelectedElement[] = ssE.elementSet();
		
		String strScriptName = "HSB_E-IntegrateSteelbeam"; // name of the script
		Vector3d vecUcsX(1,0,0);
		Vector3d vecUcsY(0,1,0);
		Beam lstBeams[1];
		Element lstElements[1];
		
		Point3d lstPoints[1];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		Map mapTsl;
		mapTsl.setInt("MasterToSatellite", TRUE);
		setCatalogFromPropValues("MasterToSatellite");
		mapTsl.setInt("ExecuteMode", 1);// 1 == recalc	
		for( int e=0;e<arSelectedElement.length();e++ ){
			Element el = arSelectedElement[e];
			lstElements[0] = el;
			PlaneProfile ppElVert = el.profBrutto(0);
			PlaneProfile ppElHor(el.plOutlineWall());

			for( int b=0;b<arBmSteel.length();b++ ){
				Beam bmSteel = arBmSteel[b];
				
				// Does the steelbeam intersect with this element?
				Body bdBmSteel = bmSteel.envelopeBody(true, false);
				PlaneProfile ppBmVert = bdBmSteel.getSlice(Plane(bmSteel.ptCen(), bmSteel.vecX()));//;extrusionProfile.planeProfile();
				if( !ppBmVert.intersectWith(ppElVert) )
					continue;
				
				PlaneProfile ppBmHor = bdBmSteel.getSlice(Plane(bmSteel.ptCen(), el.vecY()));//;extrusionProfile.planeProfile();
				if( !ppBmHor.intersectWith(ppElHor) )
					continue;
				
				Point3d arPtBm[] = ppBmVert.getGripVertexPoints();
				Point3d arPtBmX[] = Line(el.ptOrg(), el.vecX()).orderPoints(arPtBm);
				Point3d arPtBmY[] = Line(el.ptOrg(), el.vecY()).orderPoints(arPtBm);
				if( arPtBmX.length() * arPtBmY.length() == 0 )
					continue;
				
				Point3d ptBL = arPtBmX[0];
				ptBL += el.vecY() * el.vecY().dotProduct(arPtBmY[0] - ptBL);
				Point3d ptTR = arPtBmX[arPtBmX.length() - 1];
				ptTR += el.vecY() * el.vecY().dotProduct(arPtBmY[arPtBmY.length() - 1] - ptTR);
				
				Point3d ptIntersect = (ptBL + ptTR)/2;
				Plane pnElZ(el.ptOrg(), el.vecZ());
				Line lnBmX(ptIntersect, bmSteel.vecX());
				
				ptIntersect = lnBmX.intersect(pnElZ, 0);
				
				TslInst arTsl[] = el.tslInst();
				for( int i=0;i<arTsl.length();i++ ){
					TslInst tsl = arTsl[i];
					if( tsl.scriptName() == strScriptName ){
						Beam arBmTsl[] = tsl.beam();
						if( arBmTsl.find(bmSteel) != -1 )
							tsl.dbErase();
					}
				}
				
				lstBeams[0] = bmSteel;
				lstPoints[0] = ptIntersect;
				
				TslInst tsl;
				tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
			}
		}
	}
	
	eraseInstance();
	return;
}

if( _Map.hasInt("MasterToSatellite") ){
	int bMasterToSatellite = _Map.getInt("MasterToSatellite");
	if( bMasterToSatellite ){
		int bPropertiesSet = _ThisInst.setPropValuesFromCatalog("MasterToSatellite");
		_Map.removeAt("MasterToSatellite", TRUE);
	}
}

if( _Element.length() == 0 || _Beam.length() == 0 ){
	eraseInstance();
	return;
}

Element el = _Element[0];
CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

Beam bmSteel = _Beam[0];
Point3d ptBmSteel = bmSteel.ptCen();
Vector3d vxBmSteel = bmSteel.vecX();
Vector3d vyBmSteel = bmSteel.vecD(vxEl);
Vector3d vzBmSteel = bmSteel.vecD(vyEl);

double dwBmSteel = bmSteel.dD(vyBmSteel);
double dhBmSteel = bmSteel.dD(vzBmSteel);

// Assign tsl to the default element layer.
assignToLayer("0");
assignToElementGroup(el, true, 0, 'E');

//selection
int bAllFiltersEmpty = true;
int bExclude = arBExclude[arSFilterType.find(sFilterType,1)];

String arSFilterBmCode[0];
String sList = sFilterBC + ";";
int nTokenIndex = 0; 
int nCharacterIndex = 0;
while(nCharacterIndex < sList.length()-1){
	String sListItem = sList.token(nTokenIndex,";");
	nTokenIndex++;
	if(sListItem.length()==0){
		nCharacterIndex++;
		continue;
	}
	nCharacterIndex = sList.find(sListItem,0);
	sListItem.trimLeft();
	sListItem.trimRight();
	arSFilterBmCode.append(sListItem);
}
if( arSFilterBmCode.length() > 0 )
	bAllFiltersEmpty = false;

Beam arBm[0];
GenBeam arGBmAll[] = el.genBeam();
for(int i=0;i<arGBmAll.length();i++){
	GenBeam gBm = arGBmAll[i];
	int bFilterGenBeam = false;
	
	//Filter dummies
	if( gBm.bIsDummy() )
		continue;
	
	//Filter beamcodes
	if( !bFilterGenBeam ){
		String sBmCode = gBm.beamCode().token(0).makeUpper();
		sBmCode.trimLeft();
		sBmCode.trimRight();
		
		if( arSFilterBmCode.find(sBmCode)!= -1 ){
			bFilterGenBeam = true;
		}
		else{
			for( int j=0;j<arSFilterBmCode.length();j++ ){
				String sFltrBC = arSFilterBmCode[j];
				String sFltrBCTrimmed = sFltrBC;
				sFltrBCTrimmed.trimLeft("*");
				sFltrBCTrimmed.trimRight("*");
				if( sFltrBCTrimmed == "" ){
					if( sFltrBC == "*" && sBmCode != "" )
						bFilterGenBeam = true;
					else
						continue;
				}
				else{
					if( sFltrBC.left(1) == "*" && sFltrBC.right(1) == "*" && sBmCode.find(sFltrBCTrimmed, 0) != -1 )
						bFilterGenBeam = true;
					else if( sFltrBC.left(1) == "*" && sBmCode.right(sFltrBC.length() - 1) == sFltrBCTrimmed )
						bFilterGenBeam = true;
					else if( sFltrBC.right(1) == "*" && sBmCode.left(sFltrBC.length() - 1) == sFltrBCTrimmed )
						bFilterGenBeam = true;
				}
			}
		}
	}
	
	if( !bAllFiltersEmpty && ((bFilterGenBeam && bExclude) || (!bFilterGenBeam && !bExclude)) )
		continue;
	
	Beam bm = (Beam)gBm;
	if( bm.bIsValid() )
		arBm.append(bm);
}




PlaneProfile ppElVert = el.profBrutto(0);
PlaneProfile ppElHor(el.plOutlineWall());

// Does the steelbeam intersect with this element?
Body bdBmSteel = bmSteel.envelopeBody(true, false);
PlaneProfile ppBmVert = bdBmSteel.getSlice(Plane(ptBmSteel, vxBmSteel));//;extrusionProfile.planeProfile();
if( !ppBmVert.intersectWith(ppElVert) ){
	reportWarning(T("|Invalid connection|"));
	return;
}
PlaneProfile ppBmHor = bdBmSteel.getSlice(Plane(ptBmSteel, vyEl));//;extrusionProfile.planeProfile();
if( !ppBmHor.intersectWith(ppElHor) ){
	reportWarning(T("|Invalid connection|"));
	return;
}

Point3d arPtBm[] = ppBmVert.getGripVertexPoints();
Point3d arPtBmX[] = Line(ptEl, vxEl).orderPoints(arPtBm);
Point3d arPtBmY[] = Line(ptEl, vyEl).orderPoints(arPtBm);
if( arPtBmX.length() * arPtBmY.length() == 0 ){
	reportWarning(T("|Invalid connection|"));
	return;
}
Point3d ptBL = arPtBmX[0];
ptBL += vyEl * vyEl.dotProduct(arPtBmY[0] - ptBL);
Point3d ptTR = arPtBmX[arPtBmX.length() - 1];
ptTR += vyEl * vyEl.dotProduct(arPtBmY[arPtBmY.length() - 1] - ptTR);

Point3d ptIntersect = (ptBL + ptTR)/2;
Plane pnElZ(ptEl, vzEl);
Line lnBmX(ptIntersect, vxBmSteel);

ptIntersect = lnBmX.intersect(pnElZ, 0);

_Pt0 = ptIntersect;

Point3d ptBmCut = ptBmSteel - vzBmSteel * 0.5 * dhBmSteel;
ptBmCut += vxBmSteel * vxBmSteel.dotProduct(_Pt0 - ptBmCut);

BeamCut bmCutSteel(ptBmCut - vzBmSteel * dGapUnderSteelBm, vxBmSteel, vyBmSteel, vzBmSteel, U(500), dwBmSteel + 2 * dGap, U(500), 0, 0, 1);

int nNrOfBeamsCut = bmCutSteel.addMeToGenBeamsIntersect(arBm);

// Draw the shape of the profile.
Display dpZn1(-1);
dpZn1.textHeight(U(100));
dpZn1.elemZone(el, 1, 'I');
Display dpZn6(-1);
dpZn6.textHeight(U(100));
dpZn6.elemZone(el, -1, 'I');

PlaneProfile ppBm = bdBmSteel.getSlice(Plane(ptBmSteel, vxBmSteel));
Vector3d vTransform = vxBmSteel * vxBmSteel.dotProduct(_Pt0 - ptBmSteel);
ppBm.transformBy(vTransform);

Point3d ptTxt = ptBmSteel;
ptTxt.transformBy(vTransform);

// Steel beam extremes
Point3d ptSteelStart = bmSteel.ptCenSolid() - vxBmSteel * 0.5 * bmSteel.solidLength();
Point3d ptSteelEnd = bmSteel.ptCenSolid() + vxBmSteel * 0.5 * bmSteel.solidLength();
// Origin of zone 1 projected to steel axis.
Point3d ptZn1OnSteel = el.zone(1).coordSys().ptOrg();
ptZn1OnSteel = Line(ptBmSteel, vxBmSteel).closestPointTo(ptZn1OnSteel);
// Is the steelbeam intersecting with zone 1?
if ((vxBmSteel.dotProduct(ptZn1OnSteel - ptSteelStart) * vxBmSteel.dotProduct(ptZn1OnSteel - ptSteelEnd)) < 0) {
	int nNrOfSheetsCut = bmCutSteel.addMeToGenBeamsIntersect(el.sheet(1));
	if (nNrOfSheetsCut > 0) {
		dpZn1.draw(ppBm);
		dpZn1.draw(bmSteel.extrProfile(), ptTxt, vxEl, vyEl, 1, 0);
	}
}
// Origin of zone 6 projected to steel axis.
Point3d ptZn6OnSteel = el.zone(-1).coordSys().ptOrg();
ptZn6OnSteel = Line(ptBmSteel, vxBmSteel).closestPointTo(ptZn6OnSteel);
// Is the steelbeam intersecting with zone 6?
if ((vxBmSteel.dotProduct(ptZn6OnSteel - ptSteelStart) * vxBmSteel.dotProduct(ptZn6OnSteel - ptSteelEnd)) < 0) {
	int nNrOfSheetsCut = bmCutSteel.addMeToGenBeamsIntersect(el.sheet(-1));
	if (nNrOfSheetsCut > 0) {
		dpZn6.draw(ppBm);
		dpZn6.draw(bmSteel.extrProfile(), ptTxt, vxEl, vyEl, 1, 0);
	}
}





#End
#BeginThumbnail


#End