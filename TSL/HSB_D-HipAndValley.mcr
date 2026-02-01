#Version 8
#BeginDescription
Last modified by: David Rueda (david.rueda@hsbcad.com)
18.09.2019 - version 1.31



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 31
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

/// <version  value="1.18" date="17.09.2015"></version>

/// <history>
/// AS - 1.00 - 01.02.2012 -	Pilot version
/// AS - 1.01 - 06.04.2012 -	Add angled connecting rafters to dimlines
/// AS - 1.02 - 31.05.2012 -	Change readdirection to top and order points from bottom to top
/// AS - 1.03 - 31.05.2012 -	Increase margin for touching rafters
/// AS - 1.04 - 08.04.2012 -	Draw name and description
/// AS - 1.05 - 02.10.2013 -	Add option to dimension shortest or longest side of beam.
/// AS - 1.06 - 17.10.2013 -	Set tolerance to 0.01
/// AS - 1.07 - 23.10.2013 -	Add option to specify side of angled beam
/// AS - 1.08 - 24.10.2013 -	Add option to specify start of cumulative dimension. Add option to set delta on top at element side.
/// AS - 1.09 - 24.10.2013 -	Add option to disable the tsl. Add option to view the viewport outline, used for debugging and the template setup.
/// AS - 1.10 - 05.11.2013 -	Correct text orientation
/// AS - 1.11 - 24.01.2014 -	Decrease offset for profile check (500 changed to 300)
/// AS - 1.12 - 02.04.2014 -	Add option to add the extremes of the angled beam to dimension line.
/// AS - 1.13 - 26.06.2014 -	Improve direction check. Its now based on lineseg plane profile intersection.
/// AS - 1.14 - 08.07.2014 -	Add support for purlin roofs.
/// AS - 1.15 - 12.02.2015 -	Add support for small angles
/// AS - 1.16 - 26.02.2015 -	Add option to use the inside of the element as a reference plane.
/// AS - 1.17 - 02.06.2015 -	Support angled beams which are in line with each other. (FogBugzId 1170)
/// AS - 1.18 - 17.09.2015 -	Correct counter if next beam is not aligned with current beam. (FogBugzId 1906)
/// DR - 1.19 - 11.06.2017	- Added custom beam codes to dimension custom beamsu
///							- Rafters that are not in contact with top plate won't be dimensioned
///							- Option to combine touching beams for a single dimension added
/// DR - 1.20 - 17.11.2017	- Changed way to get combined beams (bugfix))
///							- "Disabled" spelling fixed (text for turning off display)
///							- Bugfix when some elements did not display rafters
/// DR - 1.21 - 18.11.2017	- Dimensioning will take farest point of touching beams
/// DR - 1.22 - 20.11.2017	- Rafters and added by code beams dimensioned when in contact to angled beam, searching takes account of whole body of beam
/// DR - 1.23 - 14.05.2018	- Vector to filter and sort perpendicular rafters changed from el.vecX()/el.vecY() to
///							   anyRafter.vecD(vxEl)/anyRafter.vecD(vyEl) to avoid aproximation error when using filterBeamsPerpendicularSort()
/// RP - 1.24 - 25.05.2018	- Add pointtolerance inseatd of dEps for check if rafters are touching the hip/valley
/// DR - 1.25 - 07.06.2018	- Correct reading direction on X axis
/// DR - 1.26 - 28.06.2018	- Added use of HSB_G-FilterGenBeams.mcr
/// DR - 1.27 - 21.01.2019	- Search for non verticals based on vyEl now
/// DR - 1.28 - 13.02.2019	- Undo v1.27, reported problem needs a more complex solution
/// DR - 1.29 - 19.03.2019	- Now it takes all not perpendicular beams to vxEl. Only points closer to dimLine will be counted
/// DR - 1.30 - 11.09.2019	- Improved filtering of points on DimLine, now validate if PROJECTED points on plane are between start and end points of DimLine
///							- Improved filtering of Rafters and Beams by code in proper contact with angled beam
///							- Added work for beams paralel to element's vecX
/// DR - 1.31 - 18.09.2019	- Removing points that should not be in dimLine now adds tolerance to not exclude almost coincident points
/// </history>

//Script uses mm
double dEps = U(.01, "mm");
double pointTolerance = U(.1);
int bOnDebug = false;
double dProfileCheck = U(300);

String arSSectionName[] = { " "};
Entity arEntTsl[] = Group().collectEntities(true, TslInst(), _kMySpace);
for ( int i = 0; i < arEntTsl.length(); i++)
{
	TslInst tsl = (TslInst)arEntTsl[i];
	if ( ! tsl.bIsValid() )
		continue;
	Map mapTsl = tsl.map();
	String vpHandle = mapTsl.getString("VPHANDLE");
	if ( vpHandle == "" )
		continue;
	if ( arSSectionName.find(tsl.scriptName()) == -1 )
		arSSectionName.append(tsl.scriptName());
}

String arSRafterSide[] =
{
	T("|Shortest side|"),
	T("|Longest side|")
};
double arDAngleOffset[] =
{
	5,
	 - 5
};

String arSSideAngledBeam[] =
{
	T("|Inside|"),
	T("|Outside|"),
	T("|Extremes|")
};
int arNSideAngleBeam[] =
{
	 - 1,
	1,
	2
};

String arSYesNo[] =
{
	T("|Yes|"),
	T("|No|")
};
int arNYesNo[] =
{
	_kYes,
	_kNo
};
int arNStartCumulativeDimension[] =
{
	1,
	 - 1
};

String arSSideElement[] =
{
	T("|Outside|"),
	T("|Inside|")
};
int arNSideElement[] =
{
	1,
	 - 1
};


// ---------------------------------------------------------------------------------
PropString sSeperator01(0, "", T("|Selection|"));
sSeperator01.setReadOnly(true);

PropString sSectionName(1, arSSectionName, " " + T("  |Name element section|"));

String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = TslInst().getListOfCatalogNames(filterDefinitionTslName);
filterDefinitions.insertAt(0, "");
PropString genBeamFilterDefinition(22, filterDefinitions, " " + T("  |Filter definition for GenBeams|"));
genBeamFilterDefinition.setDescription(T("|Filter definition for GenBeams.|") + T(" (|Will be combined with custom filters|)") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));

PropString sFilterBC(2, "KEG-01;HRL-01", " " + T("  |Filter beams with beamcode|"));

PropString sFilterLabel(3, "", " " + T("  |Filter beams and sheets with label or material|"));

PropString sFilterZone(4, "1;7", " " + T("  |Filter zones|"));

PropString sCombineTouchingBeams(20, arSYesNo, " " + T("  |Combine touching beams|"), 1);

// ---------------------------------------------------------------------------------
PropString sSeperator02(5, "", T("|Angled dimension|"));
sSeperator02.setReadOnly(true);

PropString sBmCodeAngledBeams(6, "KK-01", " " + T("  |Beamcode angled beams|"));
PropString sBmCodeBlocking(10, "KS-HKS", " " + T("  |Beamcode blocking|"));
PropString sIncludeBC(21, "", " " + T("  |Beamcode custom|"));
PropString sRafterSide(14, arSRafterSide, " " + T("  |Side of rafters|"), 1);
PropString sSideAngledBeam(15, arSSideAngledBeam, " " + T("  |Side of angled beam|"));

PropString sSideElement(19, arSSideElement, " " + T("  |Side element|"));

PropString sDimStyle(7, _DimStyles, " " + T("  |Dimension style|"));


String sArDimLayout[] ={
	T("|Delta perpendicular|"),
	T("|Delta parallel|"),
	T("|Cumulative perpendicular|"),
	T("|Cumulative parallel|"),
	T("|Both perpendicular|"),
	T("|Both parallel|"),
	T("|Delta parallel|, ") + T("|Cumulative perpendicular|"),
	T("|Delta perpendicular|, ") + T("|Cumulative parallel|")
};
int nArDimLayoutDelta[] = { _kDimPerp, _kDimPar, _kDimNone, _kDimNone, _kDimPerp, _kDimPar, _kDimPar, _kDimPerp};
int nArDimLayoutCum[] = { _kDimNone, _kDimNone, _kDimPerp, _kDimPar, _kDimPerp, _kDimPar, _kDimPerp, _kDimPar};
PropString sDimLayout(8, sArDimLayout, " " + T("  |Dimension layout|"));

//Used to set the side of the text.
PropString sDeltaAtElementSide(9, arSYesNo, " " + T("  |Delta dimensioning at element side|"), 0);
PropString sStartCumulativeDimensionAtEaveSide(16, arSYesNo, " " + T("  |Start cumulative dimension at eave side|"), 0);
PropDouble dOffsetDimLine(0, U(300), " " + T("  |Offset dimline from element|"));

/// - Name and description -
///
PropString sSeperator03(11, "", T("|Name and description|"));
sSeperator03.setReadOnly(true);

PropInt nColorName(0, - 1, " " + T("  |Default name color|"));
PropInt nColorActiveFilter(1, 30, " " + T("  |Filter other element color|"));
PropInt nColorActiveFilterThisElement(2, 1, " " + T("  |Filter this element color|"));
PropString sDimStyleName(12, _DimStyles, " " + T("  |Dimension style name|"));
PropString sInstanceDescription(13, "", " " + T("  |Extra description|"));
PropString sDisableTsl(17, arSYesNo, " " + T("  |Disable the tsl|"), 1);
PropString sShowVpOutline(18, arSYesNo, " " + T("  |Show viewport outline|"), 1);

int nDimColor = - 1;

String arSTrigger[] = {
	T("|Filter this element|"),
	" ----------",
	T("|Remove filter for this element|"),
	T("|Remove filter for all elements|")
};

for ( int i = 0; i < arSTrigger.length(); i++)
	addRecalcTrigger(_kContext, arSTrigger[i] );

if ( _bOnDbCreated && _kExecuteKey != "" )
	setPropValuesFromCatalog(_kExecuteKey);

//Insert
if ( _bOnInsert )
{
	//Erase after 1 cycle
	if ( insertCycleCount() > 1 )
	{
		eraseInstance();
		return;
	}
	
	_Viewport.append(getViewport(T("|Select a viewport|")));
	_Pt0 = getPoint(T("|Select a position|"));
	
	//Showdialog
	if (_kExecuteKey == "")
		showDialog();
	
	return;
}

//Is there a viewport selected
if ( _Viewport.length() == 0 )
{
	eraseInstance();
	return;
}
Viewport vp = _Viewport[0];

// Draw name
String sInstanceNameAndDescription = _ThisInst.scriptName();
if ( sInstanceDescription.length() > 0 )
	sInstanceNameAndDescription += (" - " + sInstanceDescription);

Display dpName(nColorName);
dpName.dimStyle(sDimStyleName);
dpName.draw(sInstanceNameAndDescription, _Pt0, _XW, _YW, 1, 2);

// check if the viewport has hsb data
Element el = vp.element();
if ( ! el.bIsValid() )
	return;

int bPurlin = false;
ElementRoof elRf = (ElementRoof)el;
if (elRf.bIsValid())
	bPurlin = elRf.bPurlin();

// Add filteer
if ( _kExecuteKey == arSTrigger[0] )
{
	Map mapFilterElements;
	if ( _Map.hasMap("FilterElements") )
		mapFilterElements = _Map.getMap("FilterElements");
	
	mapFilterElements.setString(el.handle(), "Element Filter");
	_Map.setMap("FilterElements", mapFilterElements);
}

// Remove single filteer
if ( _kExecuteKey == arSTrigger[2] )
{
	Map mapFilterElements;
	if ( _Map.hasMap("FilterElements") )
	{
		mapFilterElements = _Map.getMap("FilterElements");
		
		if ( mapFilterElements.hasString(el.handle()) )
			mapFilterElements.removeAt(el.handle(), true);
		_Map.setMap("FilterElements", mapFilterElements);
	}
}

// Remove all filteer
if ( _kExecuteKey == arSTrigger[3] ) {
	if ( _Map.hasMap("FilterElements") )
		_Map.removeAt("FilterElements", true);
}

double dTextHeightName = dpName.textHeightForStyle("HSB", sDimStyleName);

int bShowVpOutline = arNYesNo[arSYesNo.find(sShowVpOutline, 1)];
if ( _Viewport.length() > 0 && (bShowVpOutline || _bOnDebug) ) {
	Viewport vp = _Viewport[0];
	Display dpDebug(1);
	dpDebug.layer("DEFPOINTS");
	PLine plVp(_ZW);
	Point3d ptA = vp.ptCenPS() - _XW * 0.48 * vp.widthPS() - _YW * 0.48 * vp.heightPS();
	//	ptA.vis();
	Point3d ptB = vp.ptCenPS() + _XW * 0.48 * vp.widthPS() + _YW * 0.48 * vp.heightPS();
	plVp.createRectangle(LineSeg(ptA, ptB), _XW, _YW);
	dpDebug.draw(plVp);
}

int bDisableTsl = arNYesNo[arSYesNo.find(sDisableTsl, 1)];
if ( bDisableTsl ) {
	dpName.color(nColorActiveFilterThisElement);
	dpName.draw(_ThisInst.scriptName(), _Pt0, _XW, _YW, 1, 2);
	dpName.textHeight(0.5 * dTextHeightName);
	dpName.draw(T("|Disabled|"), _Pt0, _XW, _YW, 1, 1);
	return;
}

Map mapFilterElements;
if ( _Map.hasMap("FilterElements") )
	mapFilterElements = _Map.getMap("FilterElements");
	if ( mapFilterElements.length() > 0 ) {
		if ( mapFilterElements.hasString(el.handle()) ) {
			dpName.color(1);
			dpName.draw(_ThisInst.scriptName(), _Pt0, _XW, _YW, 1, 2);
			dpName.textHeight(0.5 * dTextHeightName);
			dpName.draw(T("|Active filter|"), _Pt0, _XW, _YW, 1, 1);
			return;
		}
	else {
		dpName.color(30);
		dpName.draw(_ThisInst.scriptName(), _Pt0, _XW, _YW, 1, 2);
		dpName.textHeight(0.5 * dTextHeightName);
		dpName.draw(T("|Active filter|"), _Pt0, _XW, _YW, 1, 1);
	}
}
//Coordinate system
CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps; ps2ms.invert(); //take the inverse of ms2ps
double dVpScale = ps2ms.scale();

Display dpDim(nDimColor);
dpDim.dimStyle(sDimStyle, dVpScale); //dimstyle was adjusted for display in paper space, sets textHeight

// resolve props
// selection
String sFBC = sFilterBC + ";";
sFBC.makeUpper();
String arSFBC[0];
int nIndexBC = 0;
int sIndexBC = 0;
while (sIndexBC < sFBC.length() - 1) {
	String sTokenBC = sFBC.token(nIndexBC);
	nIndexBC++;
	if (sTokenBC.length() == 0) {
		sIndexBC++;
		continue;
	}
	sIndexBC = sFBC.find(sTokenBC, 0);
	sTokenBC.trimLeft();
	sTokenBC.trimRight();
	arSFBC.append(sTokenBC);
}
String sFLabel = sFilterLabel + ";";
sFLabel.makeUpper();
String arSFLabel[0];
int nIndexLabel = 0;
int sIndexLabel = 0;
while (sIndexLabel < sFLabel.length() - 1) {
	String sTokenLabel = sFLabel.token(nIndexLabel);
	nIndexLabel++;
	if (sTokenLabel.length() == 0) {
		sIndexLabel++;
		continue;
	}
	sIndexLabel = sFilterLabel.find(sTokenLabel, 0);
	
	arSFLabel.append(sTokenLabel);
}
int arNFilterZone[0];
int nIndex = 0;
String sZones = sFilterZone + ";";
int nToken = 0;
String sToken = sZones.token(nToken);
while ( sToken != "" ) {
	int nZn = sToken.atoi();
	if ( nZn == 0 && sToken != "0" ) {
		nToken++;
		sToken = sZones.token(nToken);
		continue;
	}
	if ( nZn > 5 )
		nZn = 5 - nZn;
	arNFilterZone.append(nZn);
	
	nToken++;
	sToken = sZones.token(nToken);
}
String sIBC = sIncludeBC + ";";
sIBC.makeUpper();
String arSIBC[0];
nIndexBC = 0;
sIndexBC = 0;
while (sIndexBC < sIBC.length() - 1) {
	String sTokenBC = sIBC.token(nIndexBC);
	nIndexBC++;
	if (sTokenBC.length() == 0) {
		sIndexBC++;
		continue;
	}
	sIndexBC = sIBC.find(sTokenBC, 0);
	sTokenBC.trimLeft();
	sTokenBC.trimRight();
	arSIBC.append(sTokenBC);
}
int bCombineTouchingBeams = arNYesNo[arSYesNo.find(sCombineTouchingBeams, 0)];

// dimension
String sBCAngledBms = sBmCodeAngledBeams + ";";
sBCAngledBms.makeUpper();
String arSBCAngled[0];
nIndexBC = 0;
sIndexBC = 0;
while (sIndexBC < sBCAngledBms.length() - 1) {
	String sTokenBC = sBCAngledBms.token(nIndexBC);
	nIndexBC++;
	if (sTokenBC.length() == 0) {
		sIndexBC++;
		continue;
	}
	sIndexBC = sBCAngledBms.find(sTokenBC, 0);
	sTokenBC.trimLeft();
	sTokenBC.trimRight();
	arSBCAngled.append(sTokenBC);
}
String sBCBlocking = sBmCodeBlocking + ";";
sBCBlocking.makeUpper();
String arSBCBlocking[0];
nIndexBC = 0;
sIndexBC = 0;
while (sIndexBC < sBCBlocking.length() - 1) {
	String sTokenBC = sBCBlocking.token(nIndexBC);
	nIndexBC++;
	if (sTokenBC.length() == 0) {
		sIndexBC++;
		continue;
	}
	sIndexBC = sBCBlocking.find(sTokenBC, 0);
	sTokenBC.trimLeft();
	sTokenBC.trimRight();
	arSBCBlocking.append(sTokenBC);
}
int nSideOfAngledBeam = arNSideAngleBeam[arSSideAngledBeam.find(sSideAngledBeam, 0)];
int nElementSide = arNSideElement[arSSideElement.find(sSideElement, 0)];
int nStartCumulativeDimension = arNStartCumulativeDimension[arSYesNo.find(sStartCumulativeDimensionAtEaveSide, 0)];

double dAngleOffset = arDAngleOffset[arSRafterSide.find(sRafterSide, 1)];
int nDimLayoutDelta = nArDimLayoutDelta[sArDimLayout.find(sDimLayout, 0)];
int nDimLayoutCum = nArDimLayoutCum[sArDimLayout.find(sDimLayout, 0)];
int bDeltaAtElementSide = arNYesNo[arSYesNo.find(sDeltaAtElementSide, 0)];

//Element coordSys
CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

if (bOnDebug)
{
	double dLVec = U(200);
	Point3d ptElPS = ptEl; ptElPS.transformBy(ms2ps);ptElPS.vis(3);
	Vector3d vxElPS = vxEl * dLVec; vxElPS.transformBy(ms2ps);vxElPS.vis(ptElPS, 1);
	Vector3d vyElPS = vyEl * dLVec; vyElPS.transformBy(ms2ps);vyElPS.vis(ptElPS, 3);
	Vector3d vzElPS = vzEl * dLVec; vzElPS.transformBy(ms2ps);vzElPS.vis(ptElPS, 150);
	PLine plElPS = el.plEnvelope(); plElPS.transformBy(ms2ps); plElPS.vis(5);
}

CoordSys csSide = el.zone(nElementSide).coordSys();
Point3d ptElementSide = csSide.ptOrg();

Vector3d vxms = _XW;
vxms.transformBy(ps2ms);
vxms.normalize();
Vector3d vyms = _YW;
vyms.transformBy(ps2ms);
vyms.normalize();
Vector3d vzms = _ZW;
vzms.transformBy(ps2ms);
vzms.normalize();

Line lnXms(ptEl, vxms);
Line lnYms(ptEl, vyms);

Line lnYEl(ptEl, vyEl);

Plane pnElZ(ptElementSide, vzEl);

Entity arEntTslPS[] = Group().collectEntities(true, TslInst(), _kMySpace);
TslInst tslSection;
for ( int i = 0; i < arEntTslPS.length(); i++) {
	TslInst tsl = (TslInst)arEntTslPS[i];
	
	Map mapTsl = tsl.map();
	String vpHandle = mapTsl.getString("VPHANDLE");
	
	if ( tsl.scriptName() == sSectionName && vpHandle == vp.viewData().viewHandle() ) {
		tslSection = tsl;
		break;
	}
}

GenBeam arGBmAll[0];
if ( ! tslSection.bIsValid() )
	arGBmAll = el.genBeam(); //collect all
else {
	_Entity.append(tslSection);
	setDependencyOnEntity(tslSection);
	
	Map mapTsl = tslSection.map();
	for ( int i = 0; i < mapTsl.length(); i++) {
		if ( mapTsl.keyAt(i) == "GENBEAM" ) {
			Entity entGBm = mapTsl.getEntity(i);
			GenBeam gBm = (GenBeam)entGBm;
			arGBmAll.append(gBm);
		}
	}
}

if ( arGBmAll.length() == 0 )
	return;

GenBeam arGBm[0];
Beam arBm[0];
Beam arBmDim[0];
String arSCodeDim[0];

Beam arBmRafter[0];
Beam arBmBlocking[0];
Beam arBmIncludedByCode[0];
Beam arBmAlignedToElementVecX[0];
Sheet arSh[0];
Point3d arPtGBm[0];

GenBeam arGBmRef[0];
Point3d arPtGBmRef[0];

PlaneProfile ppEl(csSide);

//region filter genBeams
GenBeam genBeams[0]; genBeams.append(arGBmAll);
Entity genBeamEntities[0];
for (int b = 0; b < genBeams.length(); b++)
{
	GenBeam genBeam = genBeams[b];
	if ( ! genBeam.bIsValid())
		continue;
	
	genBeamEntities.append(genBeam);
}

Map filterGenBeamsMap;
filterGenBeamsMap.setEntityArray(genBeamEntities, false, "GenBeams", "GenBeams", "GenBeam");
int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, genBeamFilterDefinition, filterGenBeamsMap);
if ( ! successfullyFiltered)
{
	reportWarning(T("|GenBeams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
	eraseInstance();
	return;
}

Entity filteredGenBeamEntities[] = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");
GenBeam filteredGenBeams[0];
for (int e = 0; e < filteredGenBeamEntities.length(); e++)
{
	GenBeam genBeam = (GenBeam)filteredGenBeamEntities[e];
	if ( ! genBeam.bIsValid()) continue;
	
	filteredGenBeams.append(genBeam);
}

arGBmAll = filteredGenBeams;
//endregion

//internal filter (old)
for ( int i = 0; i < arGBmAll.length(); i++)
{
	GenBeam gBm = arGBmAll[i];
	Beam bm = (Beam)gBm;
	Sheet sh = (Sheet)gBm;
	
	// apply filters
	String sBmCode = gBm.beamCode().token(0);
	String sMaterial = gBm.material();
	String sLabel = gBm.label();
	int nZnIndex = gBm.myZoneIndex();
	if ( arSFBC.find(sBmCode) != -1 )
		continue;
	if ( arSFLabel.find(sMaterial) != -1 )
		continue;
	if ( arSFLabel.find(sLabel) != -1 )
		continue;
	if ( arNFilterZone.find(nZnIndex) != -1 )
		continue;
	
	if ( sh.bIsValid() )
	{
		arSh.append(sh);
		PlaneProfile ppSh = sh.profShape();
		ppSh.shrink(-U(1));
		
		ppEl.unionWith(ppSh);
	}
	else if ( bm.bIsValid() )
	{
		arBm.append(bm);
		PlaneProfile ppBm = bm.envelopeBody(true, true).extractContactFaceInPlane(Plane(ptElementSide, bm.vecD(vzEl)), U(100));
//		if (bOnDebug) { Body bdBmPS = bm.envelopeBody(); bdBmPS.transformBy(ms2ps); bdBmPS.vis(); }
		
		ppBm.shrink(-U(1));
		ppEl.unionWith(ppBm);
		double dAngle = bm.vecX().angleTo(vxEl);
		int bBmIsAngled = (abs(abs(bm.vecX().angleTo(vxEl)) - 90) > dEps);//false; v1.29, now it takes all not perpendicular beams to vxEl (Notice : don't use !IsPerpendicular(), it does not take proper tolerance in some cases)
		if (bBmIsAngled)
		{
			int bClassified = false;
			for ( int j = 0; j < arSBCAngled.length(); j++) {
				String sCode = arSBCAngled[j];
				if ( sCode.token(1, "-") == ">" ) {
					if ( sBmCode.left(sCode.token(0, "-").length()) == sCode.token(0, "-") ) {
						arSCodeDim.append(sBmCode);
						arBmDim.append(bm);
						bClassified = true;
					}
				}
				else if ( sCode == sBmCode.makeUpper() ) {
					arSCodeDim.append(sBmCode);
					arBmDim.append(bm);
					bClassified = true;
				}
			}
			
			if ( arSBCBlocking.find(sBmCode) != -1 )
			{
				arBmBlocking.append(bm);
				bClassified = true;
			}
			
			if(!bClassified)
			{
				arBmAlignedToElementVecX.append(bm);
			}
		}
		else
		{
//			if (bOnDebug) { Body bdBmPS = bm.envelopeBody(); bdBmPS.transformBy(ms2ps); bdBmPS.vis(4); }
			
			if ( ( ! bPurlin && abs(abs(bm.vecX().dotProduct(vyEl)) - 1) < dEps) || ( ! bPurlin && abs(abs(bm.vecX().dotProduct(vxEl)) - 1) < dEps) )//Add rafters
			{
				arBmRafter.append(bm);
				
			}
			else if ( arSIBC.find(sBmCode) > - 1 )//add other beams specified by code
			{
				arBmIncludedByCode.append(bm);
			}
		}
	}
	Point3d arPtThisGBm[] = gBm.envelopeBody(false, true).allVertices();
	
	arGBm.append(gBm);
	arPtGBm.append(arPtThisGBm);
}

ppEl.shrink(U(1));

if ( arPtGBm.length() == 0 )
	return;

Point3d arPtGBmX[] = lnXms.orderPoints(arPtGBm);
Point3d arPtGBmY[] = lnYms.orderPoints(arPtGBm);
Point3d ptL = arPtGBmX[0];
Point3d ptR = arPtGBmX[arPtGBmX.length() - 1];
Point3d ptB = arPtGBmY[0];
Point3d ptT = arPtGBmY[arPtGBmY.length() - 1];
ptL += vyms * vyms.dotProduct((ptB + ptT) / 2 - ptL);
ptR += vyms * vyms.dotProduct(ptL - ptR);
ptB += vxms * vxms.dotProduct((ptL + ptR) / 2 - ptB);
ptT += vxms * vxms.dotProduct(ptB - ptT);
Point3d ptM = ptL + vxms * vxms.dotProduct(ptT - ptL);
Point3d ptBL = ptB + vxms * vxms.dotProduct(ptL - ptB);
Point3d ptBR = ptB + vxms * vxms.dotProduct(ptR - ptB);
Point3d ptTR = ptT + vxms * vxms.dotProduct(ptR - ptT);
Point3d ptTL = ptT + vxms * vxms.dotProduct(ptL - ptT);

if (_bOnDebug)
{
	Point3d ptLPS = ptL; ptLPS.transformBy(ms2ps);ptLPS.vis(3);
	Point3d ptRPS = ptR; ptRPS.transformBy(ms2ps);ptRPS.vis(3);
	Point3d ptBPS = ptB; ptBPS.transformBy(ms2ps);ptBPS.vis(3);
	Point3d ptTPS = ptT; ptTPS.transformBy(ms2ps);ptTPS.vis(3);
	Point3d ptMPS = ptM; ptMPS.transformBy(ms2ps);ptMPS.vis(3);
	Point3d ptBLPS = ptBL; ptBLPS.transformBy(ms2ps);ptBLPS.vis(3);
	Point3d ptBRPS = ptBR; ptBRPS.transformBy(ms2ps);ptBRPS.vis(3);
	Point3d ptTRPS = ptTR; ptTRPS.transformBy(ms2ps);ptTRPS.vis(3);
	Point3d ptTLPS = ptTL; ptTLPS.transformBy(ms2ps);ptTLPS.vis(3);
}

// order beams
for (int s1 = 1; s1 < arSCodeDim.length(); s1++)
{
	int s11 = s1;
	for (int s2 = s1 - 1; s2 >= 0; s2--) {
		if ( arSCodeDim[s11] > arSCodeDim[s2] )
		{
			arSCodeDim.swap(s2, s11);
			arBmDim.swap(s2, s11);
			s11 = s2;
		}
	}
}
for (int s1 = 1; s1 < arSCodeDim.length(); s1++)
{
	int s11 = s1;
	for (int s2 = s1 - 1; s2 >= 0; s2--) {
		if ( abs(vxms.dotProduct(vzms.crossProduct(arBmDim[s11].vecX())) - vxms.dotProduct(vzms.crossProduct(arBmDim[s2].vecX()))) > dEps ) {
			arSCodeDim.swap(s2, s11);
			arBmDim.swap(s2, s11);
			s11 = s2;
		}
	}
}

if (bOnDebug && true)
{
	for (int g = 0; g < arGBm.length(); g++)
	{
		GenBeam gBm = arGBm[g];
		Body bdgBmPS = gBm.envelopeBody(); bdgBmPS.transformBy(ms2ps); bdgBmPS.vis(51);
	}//next g
}

Vector3d vyPrev;
Point3d ptPrev;
int bDimThisSet = false;
Beam arBmThisDimLine[0];
int nNrOfLoops = 0;

for ( int i = 0; i < arBmDim.length(); i++)
{
	nNrOfLoops++;
	if (nNrOfLoops > 50)
	{
		reportWarning(T("|Infinite loop detected.|") + T(" |Break out of it.|"));
		break;
	}
	
	Beam bmToDim = arBmDim[i];
	
	Vector3d vxBm = bmToDim.vecX();
	Vector3d vyBm = vzms.crossProduct(vxBm); vyBm.normalize();
	
	if ( i == 0)
	{
		vyPrev = vyBm;
		ptPrev = bmToDim.ptCen();
		
		arBmThisDimLine.setLength(0);
		arBmThisDimLine.append(bmToDim);
		
		if (arBmDim.length() == 1)
			bDimThisSet = true;
		else
		{
			if (bOnDebug) { Body bdBmPS = bmToDim.envelopeBody(); bdBmPS.transformBy(ms2ps); bdBmPS.vis(51); }
			continue;
		}
	}
	
	if ( ! bDimThisSet)
	{
		if ( abs(abs(vyPrev.dotProduct(vyBm)) - 1) > dEps )
		{
			vyPrev = vyBm;
			ptPrev = bmToDim.ptCen();
			
			bDimThisSet = true;
			i--;
		}
		else if ( abs(vyPrev.dotProduct(bmToDim.ptCen() - ptPrev)) > U(200) )
		{
			vyPrev = vyBm;
			ptPrev = bmToDim.ptCen();
			
			bDimThisSet = true;
			i--;
		}
		else
		{
			arBmThisDimLine.append(bmToDim);
		}
	}
	
	if (i < (arBmDim.length() - 1) && !bDimThisSet)
		continue;
	
	if (arBmThisDimLine.length() == 0)
	{
		arBmThisDimLine.append(bmToDim);
		continue;
	}
	
	Point3d ptDim = arBmThisDimLine[0].ptCen();
	vxBm = arBmThisDimLine[0].vecX();
	vyBm = vzms.crossProduct(vxBm);
	vyBm.normalize();
	Point3d ptBmCen = ptDim;
	
	if (bOnDebug) { Body bdBmPS = arBmThisDimLine[0].envelopeBody(); bdBmPS.transformBy(ms2ps); bdBmPS.vis(i + 3); }
	
	// vyBm must point out of the element.
	Point3d ptEdge = ptDim;
	LineSeg lnSeg(ptEdge + vyBm * U(10000), ptEdge - vyBm * U(10000));
	LineSeg arLnSeg[] = ppEl.splitSegments(lnSeg, true);
	Point3d arPtLnSeg[0];
	for ( int j = 0; j < arLnSeg.length(); j++)
	{
		LineSeg lnSg = arLnSeg[j];
		arPtLnSeg.append(lnSg.ptStart());
		arPtLnSeg.append(lnSg.ptEnd());
	}
	
	arPtLnSeg = Line(ptEdge, vyBm).orderPoints(arPtLnSeg);
	
	if ( arPtLnSeg.length() > 1 )
	{
		if ( abs(vyBm.dotProduct(arPtLnSeg[arPtLnSeg.length() - 1] - ptEdge)) > abs(vyBm.dotProduct(arPtLnSeg[0] - ptEdge)) )
		{
			vyBm *= -1;
		}
	}
	
	if ( vxBm.dotProduct(vxms) < 0 )
	{
		vxBm *= -1;
	}
	
	if (bOnDebug)
	{
		Point3d ptBmCenPS = ptBmCen; ptBmCenPS.transformBy(ms2ps); ptBmCenPS.vis(3);
		Vector3d vyBmVis = vyBm * 100; Vector3d vyBmPS = vyBmVis; vyBmPS.transformBy(ms2ps);vyBmPS.vis(ptBmCenPS, i + 3);
	}
	
	Body bdBm;
	for (int j = 0; j < arBmThisDimLine.length(); j++)
	{
		bdBm.addPart(arBmThisDimLine[j].realBody());
	}
	
	Point3d arPtBm[] = bdBm.allVertices();
	Point3d arPtBmEdgeMax[0];
	
	Line lnBmX(ptDim, vxBm);
	
	if ( nSideOfAngledBeam == 2 )
	{
		Point3d arPtBmX[] = lnBmX.orderPoints(arPtBm);
		if ( arPtBmX.length() < 2 )
			continue;
		
		arPtBmEdgeMax.append(arPtBmX[0]);
		arPtBmEdgeMax.append(arPtBmX[arPtBmX.length() - 1]);
	}
	else
	{
		Line lnBmYZ(ptDim, nSideOfAngledBeam * vyBm + nElementSide * vzms);
		Point3d arPtBmYZ[] = lnBmYZ.orderPoints(arPtBm);
		
		for (int j = (arPtBmYZ.length() - 1); j > 0; j--)
		{
			Point3d pt = arPtBmYZ[j];
			if (j == (arPtBmYZ.length() - 1))
			{
				arPtBmEdgeMax.append(pt);
				continue;
			}
			if (abs((-vyBm + vzms).dotProduct(pt - arPtBmEdgeMax[0])) > dEps )
				break;
			
			arPtBmEdgeMax.append(pt);
		}
	}
	
	Point3d arPtBmX[] = lnBmX.orderPoints(arPtBmEdgeMax);
	
	if ( arPtBmX.length() < 2 )
		continue;
	
	Point3d ptDimStart = arPtBmX[0];
	Point3d ptDimEnd = arPtBmX[arPtBmX.length() - 1];
	
	if (bOnDebug)
	{
		Point3d ptDimPS = ptDim; ptDimPS.transformBy(ms2ps);ptDimPS.vis();
		Point3d ptDimStartPS = ptDimStart; ptDimStartPS.transformBy(ms2ps);ptDimStartPS.vis(1);
		Point3d ptDimEndPS = ptDimEnd; ptDimEndPS.transformBy(ms2ps);ptDimEndPS.vis(5);
	}
	
	int nDimShortestPoint = 1;
	
	Vector3d vOffsettedBmY = vyBm.rotateBy(nDimShortestPoint * dAngleOffset, vzms);
	if ( vyBm.dotProduct(vxEl) > 0 ) //right
	{
		if ( vyBm.dotProduct(vyEl) > 0 ) //top - right
			vOffsettedBmY = vyBm.rotateBy(nDimShortestPoint * - dAngleOffset, vzms);
	}
	else //left
	{
		if ( vyBm.dotProduct(vyEl) < 0 ) //bottom - left
			vOffsettedBmY = vyBm.rotateBy(nDimShortestPoint * - dAngleOffset, vzms);
	}
	
	Line lnDimYOffsetted(ptDimStart, vOffsettedBmY);
	
	Point3d arPtDim[] = { ptDimStart, ptDimEnd};
	
	// find blocking pieces and touching rafters.
	Beam arBmBlockingToDim[0];
	for (int j = 0; j < arBmThisDimLine.length(); j++)
		arBmBlockingToDim.append(arBmThisDimLine[j].filterBeamsCapsuleIntersect(arBmBlocking));
	
	for ( int j = 0; j < arBmBlockingToDim.length(); j++)
	{
		Beam bmBlocking = arBmBlockingToDim[j];
		
		Point3d ptBlMin = bmBlocking.ptCen() - bmBlocking.vecX() * 0.5 * bmBlocking.solidLength();
		Point3d ptBlMax = bmBlocking.ptCen() + bmBlocking.vecX() * 0.5 * bmBlocking.solidLength();
		
		Beam arBmRafterMin[] = Beam().filterBeamsHalfLineIntersectSort(arBmRafter, bmBlocking.ptCen(), - bmBlocking.vecX());
		Beam arBmRafterMax[] = Beam().filterBeamsHalfLineIntersectSort(arBmRafter, bmBlocking.ptCen(), bmBlocking.vecX());
		
		Point3d ptBlDim = ptBlMin;
		if ( arBmRafterMax.length() > 0 )
		{
			Beam bmRafterMax = arBmRafterMax[0];
			Point3d ptMax = Line(bmRafterMax.ptCen(), bmRafterMax.vecX()).intersect(Plane(bmBlocking.ptCen(), bmBlocking.vecD(vyEl)), 0);
			
			if ( arBmRafterMin.length() > 0 )
			{
				Beam bmRafterMin = arBmRafterMin[0];
				Point3d ptMin = Line(bmRafterMin.ptCen(), bmRafterMin.vecX()).intersect(Plane(bmBlocking.ptCen(), bmBlocking.vecD(vyEl)), 0);
				
				if ( (bmBlocking.ptCen() - ptMax).length() < (bmBlocking.ptCen() - ptMin).length() )
				{
					ptBlDim = ptBlMax;
				}
			}
		}
		arPtDim.append(ptBlDim);
	}
	
	// Get most internal and external points from angled beam even when it has special profile
	Point3d ptExtremes[] = bdBm.extremeVertices(vyBm);
	Point3d ptInt = ptExtremes[0] - vyBm * pointTolerance, ptExt = ptExtremes[ ptExtremes.length() - 1] + vyBm * pointTolerance;
	
	//create a plane for later validations
	Plane plnDim(ptDim, vyBm);
	
	if (bOnDebug)
	{
		Vector3d vxBmCurrent = arBmThisDimLine[0].vecX();
		ptInt += vxBmCurrent * vxBmCurrent.dotProduct(ptBmCen - ptInt);
		ptExt += vxBmCurrent * vxBmCurrent.dotProduct(ptBmCen - ptExt);
		Point3d ptIntPS = ptInt; ptIntPS.transformBy(ms2ps);ptIntPS.vis(1);
		Point3d ptExtPS = ptExt; ptExtPS.transformBy(ms2ps);ptExtPS.vis(5);
	}
	
	// Rafters and beams parallel to element's vecX
	if (arBmRafter.length() > 0)
	{
		Vector3d vFilter;
		Beam bmAnyRafter = arBmRafter[0];
		
		if ( abs(bmAnyRafter.vecX().dotProduct(vxEl)) < dEps)
		{
			vFilter = bmAnyRafter.vecD(vxEl);
		}
		else if ( abs(bmAnyRafter.vecX().dotProduct(vyEl)) < dEps)
		{
			vFilter = bmAnyRafter.vecD(vyEl);
		}
		else
		{
			arBmRafter.setLength(0);
			reportMessage("\n" + scriptName() + ": " + T("|Error sorting rafters on element|") + el.number() + el.code());
		}
		
		Vector3d vDimLineDir = ptDimEnd - ptDimStart;
		if (vFilter.dotProduct(vDimLineDir) < 0)
			vFilter = - vFilter;
		
		arBmRafter = vFilter.filterBeamsPerpendicularSort(arBmRafter);
		
		//add perpendicular to element's vecX
		for (int b = 0; b < arBmAlignedToElementVecX.length(); b++)
		{
			Beam bmAligned = arBmAlignedToElementVecX[b];
			if (bmAligned.type() == 62) //62 = Dak Back Edge
				continue;
			
			//			if (bOnDebug) { Body bdbmAlignedPS = bmAligned.envelopeBody(); bdbmAlignedPS.transformBy(ms2ps); bdbmAlignedPS.vis(5); }
			arBmRafter.append(bmAligned);
		}//next b
		
		Beam bmLastDimentioned;
		for ( int j = 0; j < arBmRafter.length(); j++)
		{
			Beam bmRafter = arBmRafter[j];
			
			// get vertices of rafter, extrems will be used
			Point3d arPtRafter[] = bmRafter.envelopeBody(false, true).extractContactFaceInPlane(Plane(ptElementSide, bmRafter.vecD(vzEl)), U(100)).getGripVertexPoints();//.allVertices();
			Point3d arPtRafterDimY[] = lnDimYOffsetted.orderPoints(arPtRafter);
			if ( arPtRafterDimY.length() == 0 )
				continue;
			
			Point3d ptRafter = arPtRafterDimY[arPtRafterDimY.length() - 1];
			
			if (bOnDebug)
			{
				Body bdbmRafterPS = bmRafter.envelopeBody(false, true); bdbmRafterPS.transformBy(ms2ps); bdbmRafterPS.vis(1);
				Point3d ptRafterPS = ptRafter; ptRafterPS.transformBy(ms2ps); ptRafterPS.vis(1);
			}
			
			Line line (bmRafter.ptCen(), bmRafter.vecX());
			if ( ! line.hasIntersection(plnDim))
				continue;
			
			Point3d ptProjected = line.intersect(plnDim, 0);
			if ( (vxBm.dotProduct(ptProjected - ptDimStart) * vxBm.dotProduct(ptProjected - ptDimEnd)) > 0 ) //is not between extremes points along angled beam vecX
				continue;
			
			if (vyBm.dotProduct(ptRafter - ptInt) < 0) //is not in proper contact with angled beam
				continue;
			
			Point3d ptProjectedPS = ptProjected; ptProjectedPS.transformBy(ms2ps);ptProjectedPS.vis(3);
			if (bOnDebug) { Body bdbmRafterPS = bmRafter.envelopeBody(); bdbmRafterPS.transformBy(ms2ps); bdbmRafterPS.vis(3); }
			
			if (bCombineTouchingBeams)
			{
				if (bmLastDimentioned.bIsValid())
				{
					Point3d ptBmCenLast = bmLastDimentioned.ptCen();
					Point3d ptBmCenCurrent = bmRafter.ptCen();
					Vector3d vRef = ptBmCenCurrent - ptBmCenLast;
					vRef = bmLastDimentioned.vecD(vRef);
					double combinedSemiWidts = bmLastDimentioned.dD(vRef) * .5 + bmRafter.dD(vRef) * .5;
					double currentDistance = abs(vRef.dotProduct(ptBmCenCurrent - ptBmCenLast));
					if (abs(currentDistance - combinedSemiWidts) < dEps)
					{
						arPtDim.removeAt(arPtDim.length() - 1);
					}
				}
			}
			
			arPtDim.append(ptRafter);
			bmLastDimentioned = bmRafter;
		}
	}
	
	//included by code
	for ( int j = 0; j < arBmIncludedByCode.length(); j++)
	{
		Beam bmExtra = arBmIncludedByCode[j];
		Body bdBmPS = bmExtra.envelopeBody(); bdBmPS.transformBy(ms2ps);
		
		// get vertices of rafter, extremes will be used
		Point3d arPtExtra[] = bmExtra.envelopeBody(false, true).extractContactFaceInPlane(Plane(ptElementSide, bmExtra.vecD(vzEl)), U(100)).getGripVertexPoints();//.allVertices();
		Point3d arPtExtraDimY[] = lnDimYOffsetted.orderPoints(arPtExtra);
		if ( arPtExtraDimY.length() == 0 )
			continue;
		
		Point3d ptExtra = arPtExtraDimY[arPtExtraDimY.length() - 1];
		Point3d ptExtraPS = ptExtra; ptExtraPS.transformBy(ms2ps);
		
		Point3d ptProjected = Line(bmExtra.ptCen(), bmExtra.vecX()).intersect(plnDim, 0);
		if ( (vxBm.dotProduct(ptProjected - ptDimStart) * vxBm.dotProduct(ptProjected - ptDimEnd)) > 0 ) //is not between extremes points along angled beam vecX
			continue;
		
		if (vyBm.dotProduct(ptExtra - ptInt) < 0) //is not in proper contact with angled beam
			continue;
		
		arPtDim.append(ptExtra);
	}
	
	// Some dimline settings
	Point3d ptDimLine = ptDim + vyBm * dOffsetDimLine;
	Vector3d vxDimLine = vxBm;
	Vector3d vyDimLine = vyms;
	if ( vyBm.dotProduct(vxms) > 0 )
	 { //right
		if ( vyBm.dotProduct(vyms) > 0 ) //top - right
			vyDimLine = vyBm;
		else //bottom - right
			vyDimLine = - vyBm;
	}
	else
	 { //left
		if ( vyBm.dotProduct(vyms) > 0 ) //top - left
			vyDimLine = vyBm;
		else //bottom - left
			vyDimLine = - vyBm;
	}
	
	if ( vxDimLine.dotProduct(vyEl) < 0 )
		nStartCumulativeDimension *= -1;
	
	arPtDim = Line(ptDimLine, vxDimLine * nStartCumulativeDimension).orderPoints(arPtDim);
	
	// remove points that should not be in this dimLine
	for (int t = 0; t < arPtDim.length(); t++)
	{
		Point3d pt = arPtDim[t];
		if (bOnDebug)
		{
			double dOffsetPS = U(1500);
			Point3d ptDimStartPS = ptDimStart + vyBm * dOffsetPS; ptDimStartPS.transformBy(ms2ps);ptDimStartPS.vis(6);//doesn't matter if repeats everytime, just for debug (Notice : turn off bOnDebug)
			Point3d ptDimEndPS = ptDimEnd + vyBm * dOffsetPS; ptDimEndPS.transformBy(ms2ps);ptDimEndPS.vis(6);
			Point3d ptPS = pt + vyBm * dOffsetPS * 1.05; ptPS.transformBy(ms2ps);ptPS.vis(3);
		}
		
		Vector3d vDir = (ptDimEnd - ptDimStart); vDir.normalize();
		if (vDir.dotProduct(arPtDim[t] - (ptDimStart - vDir * pointTolerance)) * vDir.dotProduct(arPtDim[t] - (ptDimEnd + vDir * pointTolerance)) > 0 ) //arPtDim[t] is not between ptDimStart and ptDimEnd when projected between the 2
		{
			arPtDim.removeAt(t);
			t--;
		}
	}//next index
	
	//correct reading direction
	Vector3d vxDimLinePS = vxDimLine; vxDimLinePS.transformBy(ms2ps);
	if (vxDimLinePS.dotProduct(_XW) < 0)
	{
		vxDimLine *= -1;
	}
	
	DimLine dimLine(ptDimLine, vxDimLine, vyDimLine);
	Dim dimTotal(dimLine, arPtDim, "<>", "<>", nDimLayoutDelta, nDimLayoutCum);
	dimTotal.transformBy(ms2ps);
	
	if (	(bDeltaAtElementSide && ppEl.pointInProfile(ptDim + vyDimLine * U(500)) == _kPointInProfile) ||
		( ! bDeltaAtElementSide && ppEl.pointInProfile(ptDim + vyDimLine * U(500)) == _kPointOutsideProfile))
	dimTotal.setDeltaOnTop(true);
	else
		dimTotal.setDeltaOnTop(false);
	
	dimTotal.setReadDirection(_YW);
	
	dpDim.draw(dimTotal);
	
	bDimThisSet = false;
	arBmThisDimLine.setLength(0);
	arBmThisDimLine.append(bmToDim);
}

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
  <lst nm="TslInfo">
    <lst nm="TSLINFO" />
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End