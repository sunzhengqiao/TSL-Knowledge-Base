#Version 8
#BeginDescription
Last modified by: David Rueda (david.rueda@hsbcad.com)
28.06.2018 - version 1.15
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 15
#KeyWords 
#BeginContents
/// <summary Lang=en>
///
/// </summary>

/// <insert>
///
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.12" date="16.03.2018"></version>

/// <history>
/// AS - 1.00 - 28.04.2011 	- Pilot version
/// AS - 1.01 - 26.02.2014 	- Make it a general one
/// AS - 1.02 - 08.04.2014 	- Add option for hatch on studs
/// AS - 1.03 - 27.11.2014 	- Subtract ring instead of cutting it.
/// AS - 1.04 - 29.03.2015 	- Add option to offset trimmer from floor. (FogBugzId 945)
/// AS - 1.05 - 27.05.2015 	- Update icon
/// AS - 1.06 - 24.12.2015 	- Change orientation of trimmer at the bottom for the 'On Studs' configuration.
/// AS - 1.07 - 03.05.2016 	- Add option to insert hatch in top view
/// AS - 1.08 - 01.06.2016 	- Add property to specify the sheet zones
/// AS - 1.09 - 23.06.2016 	- Correct direction of gap.
/// AS - 1.10 - 12.05.2017 	- Add gap directly to split of sheets. Not sure why it was done afterwards...
/// AS - 1.11 - 16.03.2018 	- Add name and grade as options.
/// AS - 1.12 - 16.03.2018 	- Also set material for hatch on studs.
/// DR - 1.13 - 07.06.2018	- At insertion, element construct or custom command: hatch's material and thickness taken from zone; name and grade taken from sheeting ()if present)
///							- values overwritten if user set any value at OPM
/// DR - 1.14 - 26.06.2018	- Automatic set of props. need only "Auto" key word on properties, non case sensitive
/// DR - 1.15 - 28.06.2018	- Automatic setting of properties done if values are empty, overwritten if there's any input
/// </history>

//Script uses mm
double dEps = U(.001,"mm");

int executeMode = 0;
// 0 = default
// 1 = insert

int nLog = 0;

String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};

int arNZone[] = {1,2,3,4,5,6,7,8,9,10};

PropString sSeparator01(0, "", T("|Hatch|"));
sSeparator01.setReadOnly(true);
String arSHatchType[] = {
	T("|Rotating|"),
	T("|On studs|")
};
PropString sHatchType(6, arSHatchType, "     "+T("|Type hatch|"));

PropString sSeparator04(8, "", T("|All hatches|"));
sSeparator04.setReadOnly(true);
PropDouble dGapShutter(0, U(2), "     "+T("|Gap hatch|"));
PropString sOffsetTrimmerFromFloor(11, arSYesNo, "     "+T("|Offset horizontal trimmer from floor|"),1);
PropDouble dFloorHeight(2, U(0), "     "+T("|Flooroffset from wall outline|"));
PropDouble dFloorOffset(3, U(0), "     "+T("|Offset from floor|"));
PropInt znIndexSheet(3, arNZone, "     "+T("|Zone index sheeting|"),0);

PropString sSeparator03(7, "", T("|Rotating hatch|"));
sSeparator03.setReadOnly(true);
String arSTurningDirection[] = {T("|Left|"), T("|Right|")};
PropString sTurningDirection(1, arSTurningDirection, "     "+T("|Turning direction|"));
PropString sMaterialShutter(2, "", "     "+T("|Material hatch|"));
PropString sNameShutter(12, "", "     "+T("|Name hatch|"));
PropString sGradeShutter(13, "", "     "+T("|Grade hatch|"));
PropDouble dThicknessShutter(1, -1, "     "+T("|Thickness hatch|"));
dThicknessShutter.setDescription(T("|Auto from sheeting zone if -1|"));
PropInt nColorShutter(0, 3, "     "+T("|Color hatch|"));

PropInt nZnIndexHatch(2, arNZone, "     "+T("|Zone index hatch|"));
int nColorLath = 32;
double dWLath = U(20);
double dHLath = U(48);

PropString sSeparator05(9, "", T("|Hatch on studs|"));
sSeparator05.setReadOnly(true);
PropString sRotateExtraBeam(10, arSYesNo, "     "+T("|Rotate horizontal trimmer|"), 1);

PropString sSeparator02(3, "", T("|Style|"));
sSeparator02.setReadOnly(true);
PropString sDimStyle(4, _DimStyles, "     "+T("Dimension style|"));
PropString sLineType(5, _LineTypes, "     "+T("|Line type|"));
PropInt nColor(1, -1, "     "+T("|Color|"));

String sCustomCommandSetPropertiesFromZone = T("|Set Properties From Zone|");
addRecalcTrigger(_kContext, sCustomCommandSetPropertiesFromZone );

if( _bOnDbCreated && _kExecuteKey != "" )
	setPropValuesFromCatalog(_kExecuteKey);

//Insert
if( _bOnInsert ){
	//Erase after 1 cycle
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	//Showdialog
	if (_kExecuteKey=="")
		showDialog();
	
	Element el = getElement(T("|Select a knee wall|"));
	_Element.append(el);
	_Pt0 = getPoint(T("|Select a position|"));
	
	if (_ZU.isParallelTo(_ZW))
		_Pt0 += el.vecY() * el.vecY().dotProduct(el.ptOrg() + el.vecY() * U(200) - _Pt0);
	
	_Map.setInt("ExecuteMode",1);
	
	return;
}

if( _Element.length() == 0 ){
	eraseInstance();
	return;
}

if( _Map.hasInt("ExecuteMode") ){
	executeMode = _Map.getInt("ExecuteMode");
	_Map.removeAt("ExecuteMode", true);
}

if( _bOnElementConstructed )
	executeMode = 1;

int zoneIndexSheet = znIndexSheet;
if (zoneIndexSheet > 5)
	zoneIndexSheet = 5 - zoneIndexSheet;
	
int nHatchType = arSHatchType.find(sHatchType, 0);
int nTurningDirection = arSTurningDirection.find(sTurningDirection, 0);
int nZoneIndexHatch = nZnIndexHatch;
if( nZoneIndexHatch > 5 )
	nZoneIndexHatch = 5 - nZoneIndexHatch;
int rotateTrimmer = arNYesNo[arSYesNo.find(sRotateExtraBeam, 1)];
int nOffsetTrimmerFromFloor = arNYesNo[arSYesNo.find(sOffsetTrimmerFromFloor, 1)];

Display dpTurningDirection(nColor);
dpTurningDirection.dimStyle(sDimStyle);
dpTurningDirection.lineType(sLineType);

Element el = _Element[0];
_ThisInst.assignToElementGroup(el, true, 0, 'I');

CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

CoordSys csZnHatch = el.zone(2).coordSys();
Plane pnZnHatch(csZnHatch.ptOrg() + vzEl, vzEl);

Plane pnElMidZ(ptEl - vzEl * 0.5 * el.zone(0).dH(), vzEl);
_Pt0 = pnElMidZ.closestPointTo(_Pt0);

//set auto props
if (executeMode == 1 //insertion or element constructed
	|| (_bOnRecalc && _kExecuteKey == sCustomCommandSetPropertiesFromZone)) //custom command
{
	//values found on zone
	String sNewMaterialShutter;
	ElemZone elZone = el.zone(znIndexSheet);
	sNewMaterialShutter = elZone.material();
	
	//values found on any sheet of zone
	String sNewNameShutter, sNewGradeShutter;
	Sheet arShZn[] = el.sheet(zoneIndexSheet);
	int bNotValidInfo = false;
	if (arShZn.length() == 0)
		bNotValidInfo = true;
	
	Sheet sheet = arShZn[0];
	if ( ! sheet.bIsValid())
		bNotValidInfo = true;
	
	if (bNotValidInfo)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|Unable to define new Name and Grade|"));
	}
	else
	{
		sNewNameShutter = sheet.name();
		sNewGradeShutter = sheet.grade();
	}
	
	if (executeMode == 1)
	{
		double dNewThicknessShutter;//thickness can only be set at insertion or element constructed, there's no code implemented to remove and create a new piece of sheeting;
		dNewThicknessShutter = elZone.dH();
		if (dNewThicknessShutter <= 0)
			dNewThicknessShutter = U(18);
		
		//don't change if user had set a value
		if (dThicknessShutter > 0)
			dNewThicknessShutter = dThicknessShutter;
		dThicknessShutter.set(dNewThicknessShutter);

		if (sMaterialShutter != "")
			sNewMaterialShutter = sMaterialShutter;
		
		if (sNameShutter != "")
			sNewNameShutter = sNameShutter;

		if (sGradeShutter != "")
			sNewGradeShutter = sGradeShutter;			
	}
	
	sMaterialShutter.set(sNewMaterialShutter);
	sNameShutter.set(sNewNameShutter);
	sGradeShutter.set(sNewGradeShutter);
}

Beam arBm[] = el.beam();
if( arBm.length() == 0 )
	return;

Beam arBmVertical[] = vxEl.filterBeamsPerpendicular(arBm);
Beam arBmHorizontal[] = vyEl.filterBeamsPerpendicular(arBm);

Beam arBmLeft[] = Beam().filterBeamsHalfLineIntersectSort(arBmVertical, _Pt0, -vxEl);
Beam arBmRight[] = Beam().filterBeamsHalfLineIntersectSort(arBmVertical, _Pt0, vxEl);

if( arBmLeft.length() * arBmRight.length() == 0 ){
	reportWarning(TN("|Invalid side studs|."));
	eraseInstance();
	return;
}

Beam bmLeft = arBmLeft[0];
bmLeft.envelopeBody(true, true).vis(2);
bmLeft.setBeamCode("H-L01");
Beam bmRight = arBmRight[0];
bmRight.envelopeBody(true, true).vis(3);
bmLeft.setBeamCode("H-R01");

Beam arBmBottom[] = Beam().filterBeamsHalfLineIntersectSort(arBmHorizontal, _Pt0, -vyEl);
Beam arBmTop[] = Beam().filterBeamsHalfLineIntersectSort(arBmHorizontal, _Pt0, vyEl);

if( arBmBottom.length() * arBmTop.length() == 0 ){
	reportWarning(TN("|Invalid plates|."));
	eraseInstance();
	return;
}

Beam bmBottom = arBmBottom[0];
bmBottom.envelopeBody(true, true).vis(1);
Beam bmTop = arBmTop[0];
bmTop.envelopeBody(true, true).vis(4);

if( executeMode == 1 ){
	double dFlagY = 1;
	Point3d ptExtraBeamBottom = bmBottom.ptCen() + vxEl * vxEl.dotProduct(_Pt0 - bmBottom.ptCen()) + vyEl * 0.5 * bmBottom.dD(vyEl) + vzEl * vzEl.dotProduct(ptEl - bmBottom.ptCen());
	if (nOffsetTrimmerFromFloor) {
		ptExtraBeamBottom += vyEl * (vyEl.dotProduct(ptEl - ptExtraBeamBottom) + dFloorHeight + dFloorOffset);
		dFlagY = 0;
	}
	Beam bmBottomExtra;
	double beamWidth = bmBottom.dD(vyEl);
	double beamHeight = bmBottom.dD(vzEl);
	if (beamWidth > beamHeight) { 
		double tmp = beamWidth;
		beamWidth = beamHeight;
		beamHeight = tmp;
	}
//Display dp(-1);
//dp.draw("X", ptExtraBeamBottom, vxEl, vyEl, 0,0);
//return;
	if (rotateTrimmer)
		bmBottomExtra.dbCreate(ptExtraBeamBottom, vxEl, -vzEl, vyEl, U(10), beamWidth, beamHeight, 0, 1, dFlagY);
	else
		bmBottomExtra.dbCreate(ptExtraBeamBottom, vxEl, vyEl, vzEl, U(10), beamWidth, beamHeight, 0, dFlagY, -1);
	bmBottomExtra.setColor(bmBottom.color());
	bmBottomExtra.setBeamCode("H-B01");
	bmBottomExtra.assignToElementGroup(el, true, 0, 'Z');
	bmBottomExtra.stretchStaticTo(bmLeft, _kStretchOnInsert);
	bmBottomExtra.stretchStaticTo(bmRight, _kStretchOnInsert);
	
	bmBottom = bmBottomExtra;	
}

if( nHatchType == 0 ){
	Plane pnBottom(bmBottom.ptCen() + vyEl * 0.5 * bmBottom.dD(vyEl), vyEl);
	Plane pnTop(bmTop.ptCen() - vyEl * 0.5 * bmTop.dD(vyEl), vyEl);
	
	Line lnLeft(bmLeft.ptCen() + vxEl * 0.5 * bmLeft.dD(vxEl), vyEl);
	Line lnRight(bmRight.ptCen() - vxEl * 0.5 * bmRight.dD(vxEl), vyEl);
	
	Point3d ptTL = lnLeft.intersect(pnTop, 0);
	Point3d ptBL = lnLeft.intersect(pnBottom, 0);
	Point3d ptBR = lnRight.intersect(pnBottom, 0);
	Point3d ptTR = lnRight.intersect(pnTop, 0);
	
	PLine plShutter(ptTL, ptBL, ptBR, ptTR);
	plShutter.close();
	
	if( executeMode == 1 ){
		Body bdShutter(plShutter, vzEl * U(500));
		
		Sheet arShZn[] = el.sheet(zoneIndexSheet);
		for( int i=0;i<arShZn.length();i++ ){
			Sheet sh = arShZn[i];
			Body bdSh = sh.envelopeBody();
			if( bdSh.hasIntersection(bdShutter) )
				sh.joinRing(plShutter, _kSubtract);
		}
	}
	
	Point3d ptLath;
	PLine plTurningDirection(vzEl);
	if( nTurningDirection == 0 ){
		ptTL += vxEl * dWLath;
		ptBL += vxEl * dWLath;
		
		ptLath = (ptTL + ptBL)/2 - vxEl * 0.5 * dWLath;
		
		plTurningDirection.addVertex(ptBL);
		plTurningDirection.addVertex((ptBR + ptTR)/2);
		plTurningDirection.addVertex(ptTL);
	}
	if( nTurningDirection == 1 ){
		ptTR -= vxEl * dWLath;
		ptBR -= vxEl * dWLath;
		
		ptLath = (ptTR + ptBR)/2 + vxEl * 0.5 * dWLath;
		
		plTurningDirection.addVertex(ptBR);
		plTurningDirection.addVertex((ptBL + ptTL)/2);
		plTurningDirection.addVertex(ptTR);
	}
	
	ptLath += vzEl * vzEl.dotProduct(csZnHatch.ptOrg() - ptLath);
	Point3d ptShutter = (ptTL + ptBL + ptBR + ptTR)/4;
	ptShutter = pnZnHatch.closestPointTo(ptShutter);
	plTurningDirection.projectPointsToPlane(pnZnHatch, vzEl);
	String sTxtLine1 = dThicknessShutter + "mm "+ sMaterialShutter;
	String sTxtLine2 = abs(vyEl.dotProduct(ptTL - ptBR)) + "x" + abs(vxEl.dotProduct(ptTL - ptBR));
	
	dpTurningDirection.draw(plTurningDirection);
	dpTurningDirection.draw(sTxtLine1, ptShutter, vxEl, vyEl, 0, 1.5);
	dpTurningDirection.draw(sTxtLine2, ptShutter, vxEl, vyEl, 0, -1.5);
	
	plShutter = PLine(ptTL, ptBL, ptBR, ptTR);
	plShutter.close();
	PlaneProfile ppShutter(csZnHatch);
	ppShutter.joinRing(plShutter, _kAdd);
	ppShutter.shrink(dGapShutter);
	
	if( executeMode == 1 ){
		Beam bmLath;
		bmLath.dbCreate(ptLath, vyEl, vxEl, vzEl, U(10), dWLath, dHLath, 0, 0, -1);
		bmLath.setColor(nColorLath);
		bmLath.setBeamCode("H-R02");
		if( nTurningDirection == 0 )
			bmLath.setBeamCode("H-L02");
		bmLath.stretchStaticTo(bmTop, _kStretchOnInsert);
		bmLath.stretchStaticTo(bmBottom, _kStretchOnInsert);
		bmLath.assignToElementGroup(el, true, 0, 'Z');
		
		Sheet shShutter;
		shShutter.dbCreate(ppShutter, dThicknessShutter, -1);
		shShutter.setColor(nColorShutter);
		shShutter.setMaterial(sMaterialShutter);
		shShutter.setName(sNameShutter);
		shShutter.setGrade(sGradeShutter);
		shShutter.assignToElementGroup(el, true, nZoneIndexHatch, 'Z');
	}
}
else{
	
	Plane pnBottom(bmBottom.ptCen(), vyEl);
	Plane pnTop(bmTop.ptCen(), vyEl);
	
	Line lnLeft(bmLeft.ptCen() + vxEl * dGapShutter, vyEl);
	Line lnRight(bmRight.ptCen() - vxEl * dGapShutter, vyEl);
	
	Point3d ptTL = lnLeft.intersect(pnTop, 0);
	Point3d ptBL = lnLeft.intersect(pnBottom, 0);
	Point3d ptBR = lnRight.intersect(pnBottom, 0);
	Point3d ptTR = lnRight.intersect(pnTop, 0);
	
	_Pt0 = (ptTL + ptBL + ptBR + ptTR)/4;
	
	PLine plTL2BR(ptTL + vzEl * 0.5 * el.dBeamWidth(), ptBR - vzEl * 0.5 * el.dBeamWidth());
	PLine plBL2TR(ptBL - vzEl * 0.5 * el.dBeamWidth(), ptTR + vzEl * 0.5 * el.dBeamWidth());
	dpTurningDirection.draw(plTL2BR);
	dpTurningDirection.draw(plBL2TR);
	
	Point3d ptBottom = bmBottom.ptCen();	
	Point3d ptLeft = bmLeft.ptCen();// - vxEl * dGapShutter;
	Point3d ptRight = bmRight.ptCen();// + vxEl * dGapShutter;

	if( executeMode == 1 ){
		Sheet arShZn[] = el.sheet(zoneIndexSheet);
		
		// Split at lefthand side
		for( int i=0;i<arShZn.length();i++ ){
			Sheet sh = arShZn[i];
			PlaneProfile ppSh = sh.profShape();
			
			if( ppSh.pointInProfile(ptLeft) == _kPointInProfile ){
				Sheet arShSplit[] = sh.dbSplit(Plane(ptLeft, vxEl), dGapShutter);
				for( int j=0;j<arShSplit.length();j++ ){
					Sheet shSplit = arShSplit[j];
					if( arShZn.find(shSplit) == -1 )
						arShZn.append(shSplit);
				}
			}
		}
		
		// Split at righthand side
		for( int i=0;i<arShZn.length();i++ ){
			Sheet sh = arShZn[i];
			PlaneProfile ppSh = sh.profShape();
			
			if( ppSh.pointInProfile(ptRight) == _kPointInProfile ){
				Sheet arShSplit[] = sh.dbSplit(Plane(ptRight, vxEl), dGapShutter);
				for( int j=0;j<arShSplit.length();j++ ){
					Sheet shSplit = arShSplit[j];
					if( arShZn.find(shSplit) == -1 )
						arShZn.append(shSplit);
				}
			}
		}
		
		// Split at bottom
		for( int i=0;i<arShZn.length();i++ ){
			Sheet sh = arShZn[i];
			PlaneProfile ppSh = sh.profShape();
			
			if( ppSh.pointInProfile(ptBottom) == _kPointInProfile ){
				Sheet arShSplit[] = sh.dbSplit(Plane(ptBottom, vyEl), dGapShutter);
				for( int j=0;j<arShSplit.length();j++ ){
					Sheet shSplit = arShSplit[j];
					if( arShZn.find(shSplit) == -1 )
						arShZn.append(shSplit);
				}
			}
		}
		
		// Set material properties
		for ( int i = 0; i < arShZn.length(); i++) 
		{
			Sheet sh = arShZn[i];
			PlaneProfile ppSh = sh.profShape();
			
			if ( ppSh.pointInProfile(ptBottom + vyEl * U(100)) == _kPointInProfile )
			{
				sh.setColor(nColorShutter);
				sh.setMaterial(sMaterialShutter);
				sh.setName(sNameShutter);
				sh.setGrade(sGradeShutter);
			}
		}
	}
}

// go to default mode
executeMode = 0;
#End
#BeginThumbnail
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
-LDDXSC)/%:E%%`S_V=X]
`










#End
#BeginMapX

#End