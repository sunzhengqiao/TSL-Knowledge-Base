#Version 8
#BeginDescription
Last modified by: David Rueda (david.rueda@hsbcad.com)
23.10.2019 - version 1.12





































#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 12
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

/// <version  value="1.10" date="04.06.2015"></version>

/// <history>
/// AS - 1.00 - 01.11.2011 - 	Pilot version
/// AS - 1.01 - 02.11.2011 - 	Sort with element y
/// AS - 1.02 - 17.11.2011 -	 Add option to specify beamcode as property
/// AS - 1.03 - 24.11.2011 - 	Add psonum for supporting beam
/// AS - 1.04 - 27.02.2012 -	Add option to offset in paperspace units
/// AS - 1.05 - 19.09.2012 -	Search for available section tsls
/// AS - 1.06 - 23.10.2012 -	Fix update issue
/// AS - 1.07 - 16.01.2013 -	Add option to dimension the brace from the inside of the frame
/// AS - 1.08 - 17.02.2014 -	Add beamcode support for sheets, Add extra offset for beam dims.
/// AS - 1.09 - 10.03.2015 -	Update to current naming convention. Add dimline perpendicular to element (FogBugzId 910)
/// AS - 1.10 - 04.06.2015 -	Add option to toggle dimension lines and numbering.
/// DR - 1.11 - 26.06.2018 - 	Added use of HSB_G-FilterGenBeams
/// DR - 1.12 - 23.10.2019 - 	Added option to dimension end rafter
/// </history>

//Script uses mm
double dEps = U(.001,"mm");
int bDebug = true;

String sArDimLayout[] ={
	T("Delta perpendicular"),
	T("Delta parallel"),
	T("Cummulative perpendicular"),
	T("Cummalative parallel"),
	T("Both perpendicular"),
	T("Both parallel"),
	T("Delta parallel, Cummalative perpendicular"),
	T("Delta perpendicular, Cummalative parallel")
};
int nArDimLayoutDelta[] = {_kDimPerp, _kDimPar,_kDimNone,_kDimNone,_kDimPerp,_kDimPar,_kDimPar,_kDimPerp};
int nArDimLayoutCum[] = {_kDimNone,_kDimNone,_kDimPerp, _kDimPar,_kDimPerp,_kDimPar,_kDimPerp,_kDimPar};

String arSDeltaOnTop[]={T("|Above|"),T("|Below|")};
int arNDeltaOnTop[]={true, false};

String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};

// ---------------------------------------------------------------------------------
PropString sSeperator01(0, "", T("|Selection|"));
sSeperator01.setReadOnly(true);

String arSSectionName[] = {" "};
Entity arEntTsl[] = Group().collectEntities(true, TslInst(), _kMySpace);
for( int i=0;i<arEntTsl.length();i++ ){
	TslInst tsl = (TslInst)arEntTsl[i];
	if( !tsl.bIsValid() )
		continue;
	Map mapTsl = tsl.map();
	String vpHandle = mapTsl.getString("VPHANDLE");
	if( vpHandle == "" )
		continue;
	if( arSSectionName.find(tsl.scriptName()) == -1 )
		arSSectionName.append(tsl.scriptName());
}
PropString sSectionName(1, arSSectionName, "     "+T("|Name section tsl|"));

String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = TslInst().getListOfCatalogNames(filterDefinitionTslName);
filterDefinitions.insertAt(0, "");

PropString genBeamFilterDefinition(38, filterDefinitions, "     "+T("|Filter definition for GenBeams|"));
genBeamFilterDefinition.setDescription(T("|Filter definition for GenBeams.|") +T(" (|Will be combined with custom filters|)") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));

PropString sFilterBC(2,"","     "+T("|Filter beams with beamcode|"));

PropString sFilterLabel(3,"","     "+T("|Filter beams or sheets with label or material|"));

PropString sFilterZone(4, "1;7", "     "+T("|Filter zones|"));

// ---------------------------------------------------------------------------------
PropString sSeperator02(5, "", T("|Start brace| (SB)"));
sSeperator02.setReadOnly(true);

PropString sDimStartBrace(34, arSYesNo, "     "+T("|Dimension start brace|"));
PropString sDimEndRafter(39, arSYesNo, "     "+T("|Dimension end rafter|"), 1);

PropString sUsePSUnits(25, arSYesNo, "     "+T("|Offset in paperspace units|"),1);
PropString sDimTextStartBrace(40,"kr.stijl = <>", "     "+T("SB: |Text at dimline|"));
PropString sDimTextEndRafter(6,"<>", "     "+T("SB: |Text at end rafter|"));
PropString sDimLayoutStartBrace(7,sArDimLayout,"     "+T("SB: |Dimension layout|"));

PropString sDeltaOnTopStartBrace(8,arSDeltaOnTop,"     "+T("SB: |Side of delta dimensioning|"),0);

PropDouble dDimStartBraceOffset(0, U(100), "     "+T("SB: |Offset angled dimline|"));
PropDouble dDimBracePerpendicularOffset(4, U(400), "     "+T("SB: |Offset perpendicular dimline|"));

PropString sInsideFrame(26, arSYesNo, "     "+T("SB: |Use inside frame as reference|"));
PropString sBmCodeBrace(23, "KSTL-01", "     "+T("SB: |Beamcode brace|"));
PropString sBmCodeSupportingBeam(24, "KSTL-02", "     "+T("SB: |Beamcode supporting beam|"));

// ---------------------------------------------------------------------------------
PropString sSeperator03(9, "", T("|Beams| (Bms)"));
sSeperator03.setReadOnly(true);
PropString sDimBeams(35, arSYesNo, "     "+T("|Dimension beams|"));

PropString sDimTextBeams(11,"", "     "+T("Bms: |Text at dimline|"));
PropString sDimLayoutBeams(12,sArDimLayout,"     "+T("Bms: |Dimension layout|"));

PropString sDeltaOnTopBeams(13,arSDeltaOnTop,"     "+T("Bms: |Side of delta dimensioning|"),0);

PropDouble dDimBeamsOffset(1, U(100), "     "+T("Bms: |Offset dimline|"));

PropString sBmCodeBeams(10,"KSRL-01;KSRL-02","     "+T("Bms: |Beamcodes|"));

// ---------------------------------------------------------------------------------
PropString sSeperator04(14, "", T("|Sheets| (Shs)"));
sSeperator04.setReadOnly(true);

PropString sDimSheets(36, arSYesNo, "     "+T("|Dimension sheets|"));

PropString sDimTextSheets(16,"", "     "+T("Shs: |Text at dimline|"));
PropString sDimLayoutSheets(17,sArDimLayout,"     "+T("Shs: |Dimension layout|"));

PropString sDeltaOnTopSheets(18,arSDeltaOnTop,"     "+T("Shs: |Side of delta dimensioning|"),0);

PropDouble dDimSheetsOffset(2, U(100), "     "+T("Shs: |Offset dimline|"));

PropString sLabelSheets(15,"BRACE SHEET","     "+T("Shs: |Label|"));
PropString sBmCodeSheets(27,"","     "+T("Shs: |Beamcodes|"));

// ---------------------------------------------------------------------------------
PropString sSeperator05(19, "", T("|Angle| (Ang)"));
sSeperator04.setReadOnly(true);

PropString sShowArc(37, arSYesNo, "     "+T("|Show arc|"));

PropDouble dAngleOffset(3, U(100), "     "+T("Ang: |Offset angle|"));

// ---------------------------------------------------------------------------------
PropString sSeperator06(20, "", T("|General|"));
sSeperator06.setReadOnly(true);

PropString sDimStyle(21, _DimStyles, "     "+T("|Dimension style|"));
PropString sShowPosnum(33, arSYesNo, "     "+T("|Show position numbers|"));
PropString sDimStylePosnum(22, _DimStyles, "     "+T("|Dimension style posnum|"));
PropInt nColorPosnum(0, 90, "     "+T("|Color posnums|"));

/// - Name and description -
/// 
PropString sSeperator14(28, "", T("|Name and description|"));
sSeperator14.setReadOnly(true);

PropInt nColorName(1, -1, "     "+T("|Default name color|"));
PropInt nColorActiveFilter(2, 30, "     "+T("|Filter other element color|"));
PropInt nColorActiveFilterThisElement(3, 1, "     "+T("|Filter this element color|"));
PropString sDimStyleName(29, _DimStyles, "     "+T("|Dimension style name|"));
PropString sInstanceDescription(30, "", "     "+T("|Extra description|"));
PropString sDisableTsl(31, arSYesNo, "     "+T("|Disable the tsl|"),1);
PropString sShowVpOutline(32, arSYesNo, "     "+T("|Show viewport outline|"),1);



int nDimColor = -1;

String arSTrigger[] = {
	T("|Filter this element|"),
	"     ----------",
	T("|Remove filter for this element|"),
	T("|Remove filter for all elements|")
};
for( int i=0;i<arSTrigger.length();i++ )
	addRecalcTrigger(_kContext, arSTrigger[i] );

if( _bOnDbCreated && _kExecuteKey != "" )
	setPropValuesFromCatalog(_kExecuteKey);

//Insert
if( _bOnInsert ){
	//Erase after 1 cycle
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	_Viewport.append(getViewport(TN("|Select a viewport|")));
	_Pt0 = getPoint(T("|Select a position|"));
	
	//Showdialog
	if (_kExecuteKey=="")
		showDialog();
	
	return;
}

//Is there a viewport selected
if( _Viewport.length()==0 ){
	eraseInstance();
	return;
}
Viewport vp = _Viewport[0];

// Draw name
String sInstanceNameAndDescription = _ThisInst.scriptName();
if( sInstanceDescription.length() > 0 )
	sInstanceNameAndDescription += (" - "+sInstanceDescription);

Display dpName(nColorName);
dpName.dimStyle(sDimStyleName);
dpName.draw(sInstanceNameAndDescription, _Pt0, _XW, _YW, 1, 2);

double dTextHeightName = dpName.textHeightForStyle("HSB", sDimStyleName);

// check if the viewport has hsb data
Element el = vp.element();
if( !el.bIsValid() )
	return;

CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps
double dVpScale = ps2ms.scale();

int bShowPosnum = arNYesNo[arSYesNo.find(sShowPosnum,0)];
int bDimStartBrace = arNYesNo[arSYesNo.find(sDimStartBrace,0)];
int bDimEndRafter = arNYesNo[arSYesNo.find(sDimEndRafter,1)];
int bDimBeams = arNYesNo[arSYesNo.find(sDimBeams,0)];
int bDimSheets = arNYesNo[arSYesNo.find(sDimSheets,0)];
int bShowArc = arNYesNo[arSYesNo.find(sShowArc,0)];

// Add filter
if( _kExecuteKey == arSTrigger[0] ){
	Map mapFilterElements;
	if( _Map.hasMap("FilterElements") )
		mapFilterElements = _Map.getMap("FilterElements");
	
	mapFilterElements.setString(el.handle(), "Element Filter");
	_Map.setMap("FilterElements", mapFilterElements);
}

// Remove single filteer
if( _kExecuteKey == arSTrigger[2] ){
	Map mapFilterElements;
	if( _Map.hasMap("FilterElements") ){
		mapFilterElements = _Map.getMap("FilterElements");
		
		if( mapFilterElements.hasString(el.handle()) )
			mapFilterElements.removeAt(el.handle(), true);
		_Map.setMap("FilterElements", mapFilterElements);
	}
}

// Remove all filteer
if( _kExecuteKey == arSTrigger[3] ){
	if( _Map.hasMap("FilterElements") )
		_Map.removeAt("FilterElements", true);
}

int bShowVpOutline = arNYesNo[arSYesNo.find(sShowVpOutline,1)];
if( _Viewport.length() > 0 && (bShowVpOutline || _bOnDebug) ){
	Viewport vp = _Viewport[0];
	Display dpDebug(1);
	dpDebug.layer("DEFPOINTS");
	PLine plVp(_ZW);
	Point3d ptA = vp.ptCenPS() - _XW * 0.48 * vp.widthPS() - _YW * 0.48 * vp.heightPS();
	ptA.vis();
	Point3d ptB = vp.ptCenPS() + _XW * 0.48 * vp.widthPS() + _YW * 0.48 * vp.heightPS();
	plVp.createRectangle(LineSeg(ptA, ptB), _XW, _YW);
	dpDebug.draw(plVp);
}

int bDisableTsl = arNYesNo[arSYesNo.find(sDisableTsl,1)];
if( bDisableTsl ){
	dpName.color(nColorActiveFilterThisElement);
	dpName.draw(_ThisInst.scriptName(), _Pt0, _XW, _YW, 1, 2);
	dpName.textHeight(0.5 * dTextHeightName);
	dpName.draw(T("|Disbled|"), _Pt0, _XW, _YW, 1, 1);
	return;
}

Map mapFilterElements;
if( _Map.hasMap("FilterElements") )
	mapFilterElements = _Map.getMap("FilterElements");
if( mapFilterElements.length() > 0 ){
	if( mapFilterElements.hasString(el.handle()) ){
		dpName.color(nColorActiveFilterThisElement);
		dpName.draw(_ThisInst.scriptName(), _Pt0, _XW, _YW, 1, 2);
		dpName.textHeight(0.5 * dTextHeightName);
		dpName.draw(T("|Active filter|"), _Pt0, _XW, _YW, 1, 1);
		return;
	}
	else{
		dpName.color(nColorActiveFilter);
		dpName.draw(_ThisInst.scriptName(), _Pt0, _XW, _YW, 1, 2);
		dpName.textHeight(0.5 * dTextHeightName);
		dpName.draw(T("|Active filter|"), _Pt0, _XW, _YW, 1, 1);
	}
}

Display dpDim(nDimColor);
dpDim.dimStyle(sDimStyle, dVpScale); // dimstyle was adjusted for display in paper space, sets textHeight

//Arc for angle to main element
Display dpArc(20);
dpArc.dimStyle(sDimStyle, dVpScale); // dimstyle was adjusted for display in paper space, sets textHeight

Display dpPosnum(nColorPosnum);
dpPosnum.dimStyle(sDimStylePosnum, dVpScale);

// resolve props
// selection
String sFBC = sFilterBC + ";";
sFBC.makeUpper();
String arSFBC[0];
int nIndexBC = 0; 
int sIndexBC = 0;
while(sIndexBC < sFBC.length()-1){
	String sTokenBC = sFBC.token(nIndexBC);
	nIndexBC++;
	if(sTokenBC.length()==0){
		sIndexBC++;
		continue;
	}
	sIndexBC = sFBC.find(sTokenBC,0);
	sTokenBC.trimLeft();
	sTokenBC.trimRight();
	arSFBC.append(sTokenBC);
}
String sFLabel = sFilterLabel + ";";
sFLabel.makeUpper();
String arSFLabel[0];
int nIndexLabel = 0; 
int sIndexLabel = 0;
while(sIndexLabel < sFLabel.length()-1){
	String sTokenLabel = sFLabel.token(nIndexLabel);
	nIndexLabel++;
	if(sTokenLabel.length()==0){
		sIndexLabel++;
		continue;
	}
	sIndexLabel = sFilterLabel.find(sTokenLabel,0);

	arSFLabel.append(sTokenLabel);
}
int arNFilterZone[0];
int nIndex = 0;
String sZones = sFilterZone + ";";
int nToken = 0;
String sToken = sZones.token(nToken);
while( sToken != "" ){
	int nZn = sToken.atoi();
	if( nZn == 0 && sToken != "0" ){
		nToken++;
		sToken = sZones.token(nToken);
		continue;
	}
	if( nZn > 5 )
		nZn = 5 - nZn;	
	arNFilterZone.append(nZn);
	
	nToken++;
	sToken = sZones.token(nToken);
}
int bUsePSUnits = arNYesNo[arSYesNo.find(sUsePSUnits,1)];
double dOffsetDimStartBrace = dDimStartBraceOffset;
if( bUsePSUnits )
	dOffsetDimStartBrace *= dVpScale;
double dOffsetDimBeams = dDimBeamsOffset;
if( bUsePSUnits )
	dOffsetDimBeams *= dVpScale;
double dOffsetDimSheets = dDimSheetsOffset;
if( bUsePSUnits )
	dOffsetDimSheets *= dVpScale;
double dOffsetAngle = dAngleOffset;
if( bUsePSUnits )
	dOffsetAngle *= dVpScale;

// Start brace
int nDimLayoutDeltaSB = nArDimLayoutDelta[sArDimLayout.find(sDimLayoutStartBrace,0)];
int nDimLayoutCumSB = nArDimLayoutCum[sArDimLayout.find(sDimLayoutStartBrace,0)];
int nDeltaOnTopSB = arNDeltaOnTop[arSDeltaOnTop.find(sDeltaOnTopStartBrace,0)];
int bInsideFrame = arNYesNo[arSYesNo.find(sInsideFrame,0)];

// Beams
String sBCBeams = sBmCodeBeams + ";";
sBCBeams.makeUpper();
String arSBmCodeBeams[0];
nIndexBC = 0; 
sIndexBC = 0;
while(sIndexBC < sBCBeams.length()-1){
	String sTokenBC = sBCBeams.token(nIndexBC);
	nIndexBC++;
	if(sTokenBC.length()==0){
		sIndexBC++;
		continue;
	}
	sIndexBC = sBCBeams.find(sTokenBC,0);
	sTokenBC.trimLeft();
	sTokenBC.trimRight();
	arSBmCodeBeams.append(sTokenBC);
}

String sBCSheets = sBmCodeSheets + ";";
sBCSheets.makeUpper();
String arSBmCodeSheets[0];
nIndexBC = 0; 
sIndexBC = 0;
while(sIndexBC < sBCSheets.length()-1){
	String sTokenBC = sBCSheets.token(nIndexBC);
	nIndexBC++;
	if(sTokenBC.length()==0){
		sIndexBC++;
		continue;
	}
	sIndexBC = sBCBeams.find(sTokenBC,0);
	sTokenBC.trimLeft();
	sTokenBC.trimRight();
	arSBmCodeSheets.append(sTokenBC);
}
int nDimLayoutDeltaBms = nArDimLayoutDelta[sArDimLayout.find(sDimLayoutBeams,0)];
int nDimLayoutCumBms = nArDimLayoutCum[sArDimLayout.find(sDimLayoutBeams,0)];
int nDeltaOnTopBms = arNDeltaOnTop[arSDeltaOnTop.find(sDeltaOnTopBeams,0)];

// Sheets
int nDimLayoutDeltaShs = nArDimLayoutDelta[sArDimLayout.find(sDimLayoutSheets,0)];
int nDimLayoutCumShs = nArDimLayoutCum[sArDimLayout.find(sDimLayoutSheets,0)];
int nDeltaOnTopShs = arNDeltaOnTop[arSDeltaOnTop.find(sDeltaOnTopSheets,0)];

//Element coordSys
CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

//Vectors of paper mapped to modelspace
Vector3d vxms = _XW;
vxms.transformBy(ps2ms);
vxms.normalize();
Vector3d vyms = _YW;
vyms.transformBy(ps2ms);
vyms.normalize();
Vector3d vzms = _ZW;
vzms.transformBy(ps2ms);
vzms.normalize();

Vector3d vxDim = vxms;
Vector3d vyDim = vyms;

Line lnXms(ptEl, vxms);
Line lnYms(ptEl, vyms);

Line lnYel(ptEl, vyEl);
Line lnZel(ptEl, vzEl);

Line lnZWorld(ptEl, _ZW);

Entity arEntTslPS[] = Group().collectEntities(true, TslInst(), _kMySpace);
TslInst tslSection;
for( int i=0;i<arEntTslPS.length();i++ ){
	TslInst tsl = (TslInst)arEntTslPS[i];
	
	Map mapTsl = tsl.map();
	String vpHandle = mapTsl.getString("VPHANDLE");
	
	if( tsl.scriptName() == sSectionName && vpHandle == vp.viewData().viewHandle() ){
		tslSection = tsl;
		break;
	}
}

GenBeam arGBmAll[0];
if( !tslSection.bIsValid() )
	arGBmAll = el.genBeam(); // collect all
else{
	Map mapTsl = tslSection.map();
	for( int i=0;i<mapTsl.length();i++ ){
		if( mapTsl.keyAt(i) == "GENBEAM" ){
			Entity entGBm = mapTsl.getEntity(i);
			GenBeam gBm = (GenBeam)entGBm;
			arGBmAll.append(gBm);
		}
	}
}

if( arGBmAll.length() == 0 )
	return;

GenBeam arGBm[0];
Beam arBm[0];
Point3d arPtBm[0];
Sheet arSh[0];

Beam arBmRafter[0];
Point3d arPtRafter[0];

Vector3d vxBrace;
Sheet arShBraceSheet[0];
Beam arBmBrace[0];
Point3d arPtBrace[0];

Beam arBmSupportingBeam[0];

Beam arBmBeams[0];

String sLabelBraceSheet = sLabelSheets;
int arNTypeRafter[] = {
	_kDakCenterJoist,
	_kDakLeftEdge,
	_kDakRightEdge
};

//region external filter (filterGenBeams)
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
arGBmAll.setLength(0);
arGBmAll = filteredGenBeams;
//endregion

//Query all genbeams (custom filters, old method)
for(int i=0;i<arGBmAll.length();i++ ){
	GenBeam gBm = arGBmAll[i];
	Beam bm = (Beam)gBm;
	Sheet sh = (Sheet)gBm;
	
	String sBmCode = gBm.beamCode().token(0).makeUpper();
	String sMaterial = gBm.material().makeUpper();
	String sLabel = gBm.label().makeUpper();
	int nZnIndex = gBm.myZoneIndex();
	
	int nBmType = gBm.type();
	
	if( arSFBC.find(sBmCode) != -1 )
		continue;
	if( arSFLabel.find(sMaterial) != -1 )
		continue;
	if( arSFLabel.find(sLabel) != -1 )
		continue;
	if( arNFilterZone.find(nZnIndex) != -1 )
		continue;
	
	if( bm.bIsValid() ){
		Point3d arPtThisBm[] = bm.envelopeBody(true, true).allVertices();
		if( sBmCode == sBmCodeBrace ){
			arBmBrace.append(bm);
			if( vxBrace.length() == 0 )
				vxBrace = bm.vecX();
			arPtBrace.append(arPtThisBm);
		}
		else if( sBmCode == sBmCodeSupportingBeam ) {
			arBmSupportingBeam.append(bm);
		}
		else if( arNTypeRafter.find(nBmType) != -1 ){
			arBmRafter.append(bm);
			if(bDebug)
			{ 
				Body bdbmPS = bm.realBody(); bdbmPS.transformBy(ms2ps); bdbmPS.vis(3);				
			}
			if( bInsideFrame ){
				arPtRafter.append(bm.realBody().extractContactFaceInPlane(Plane(el.zone(-1).coordSys().ptOrg(), vzEl), U(100)).getGripVertexPoints());// envelopeBody(true, true).allVertices());
			}
			else{
				arPtRafter.append(arPtThisBm);
			}
		}
		else if( arSBmCodeBeams.find(sBmCode) != -1 ){
			arBmBeams.append(bm);
		}
		else{
			Body b = bm.envelopeBody();
			b.transformBy(ms2ps);
			b.vis();
			arPtBm.append(arPtThisBm);
		}
		arBm.append(bm);
	}
	
	if( sh.bIsValid() ){
		if( (sLabelBraceSheet != "" && sLabel == sLabelBraceSheet) || arSBmCodeSheets.find(sBmCode) != -1)
			arShBraceSheet.append(sh);
		
		arSh.append(sh);
	}
	
	arGBm.append(gBm);
}

// Start Brace (SB)
Point3d arPtStartBrace[0];

//Point3d arPtRafterY[] = lnYel.orderPoints(arPtRafter);
//if( arPtRafterY.length() == 0 )
//	return;
//arPtStartBrace.append(arPtRafterY[0]);

Point3d arPtBmY[] = lnYel.orderPoints(arPtBm);
if( arPtBmY.length() == 0 )
	return;
arPtStartBrace.append(arPtBmY[0]);

Point3d arPtBraceZ[] = lnZWorld.orderPoints(arPtBrace);
if( arPtBraceZ.length() == 0 )
	return;
	
Point3d ptBrace = arPtBraceZ[arPtBraceZ.length() - 1];
arPtStartBrace.append(ptBrace);

if (bDimStartBrace) {
	DimLine dimLineStartBrace(ptEl - vzEl * (el.zone(0).dH() - dOffsetDimStartBrace), vxDim, vyDim);
	Dim dimStartBrace(dimLineStartBrace, arPtStartBrace, sDimTextStartBrace, sDimTextStartBrace, nDimLayoutDeltaSB, nDimLayoutCumSB);
	dimStartBrace.transformBy(ms2ps);
	dimStartBrace.setReadDirection(-_XW + _YW);
	dimStartBrace.setDeltaOnTop(nDeltaOnTopSB);
	dpDim.draw(dimStartBrace);
	
	// added v1.12
	if (bDimEndRafter)
	{
		Point3d arPtRaftersX[] = lnXms.orderPoints(arPtRafter);
		if ( arPtRaftersX.length() == 0 )
			return;
		
		Point3d arPtEndRafter[0];
		arPtEndRafter.append(ptBrace);
		arPtEndRafter.append(arPtRaftersX[0]);
		
		DimLine dimLineEndRafter(ptEl - vzEl * (el.zone(0).dH() - dOffsetDimStartBrace * 2), vxDim, vyDim);
		Dim dimEndRafter(dimLineEndRafter, arPtEndRafter, sDimTextEndRafter, sDimTextEndRafter, nDimLayoutDeltaSB, nDimLayoutCumSB);
		dimEndRafter.transformBy(ms2ps);
		dimEndRafter.setReadDirection(-_XW + _YW);
		dimEndRafter.setDeltaOnTop(nDeltaOnTopSB);
		dpDim.draw(dimEndRafter);
		
		if (bDebug)
		{
			Point3d ptBracePS = ptBrace; ptBracePS.transformBy(ms2ps);ptBracePS.vis(3);
			Point3d ptEndRafter = arPtRaftersX[0];
			Point3d ptEndRafterPS = ptEndRafter; ptEndRafterPS.transformBy(ms2ps);ptEndRafterPS.vis(3);
		}
	}
	
	Point3d arPtBraceElZ[] = lnZel.orderPoints(arPtBrace);
	if (arPtBraceElZ.length() > 0) {
		Point3d ptBraceEnd = arPtBraceElZ[0];
		Point3d arPtBracePerpendicularToElement[] = {
			ptEl + vyEl * vyEl.dotProduct(ptBraceEnd - ptEl), ptBraceEnd
		};
		vxDim = vzEl;
		vyDim = - vyEl;
		DimLine dimLineBracePerpendicularToElement(ptBraceEnd - vyEl * dDimBracePerpendicularOffset, vxDim, vyDim);
		Dim dimBracePerpendicularToElement(dimLineBracePerpendicularToElement, arPtBracePerpendicularToElement, "<>", "<>", nDimLayoutDeltaSB, nDimLayoutCumSB);
		dimBracePerpendicularToElement.transformBy(ms2ps);
		dimBracePerpendicularToElement.setReadDirection(-_XW + _YW);
		dimBracePerpendicularToElement.setDeltaOnTop(nDeltaOnTopSB);
		dpDim.draw(dimBracePerpendicularToElement);
	}
}

// Beams
if( vxBrace.length() == 0 )
	return;
Vector3d vyBrace = vzms.crossProduct(vxBrace);
vyBrace.normalize();

Point3d arPtBeam[0];
DimLine dimLineBeams(ptBrace - vyBrace * dOffsetDimBeams, vxBrace, vyBrace);
for( int i=0;i<arBmBeams.length();i++ ){
	Beam bmBeams = arBmBeams[i];
	
	if( (i/2.0) - (i/2) > 0 )
		dimLineBeams = DimLine(ptBrace - vyBrace * 2 * dOffsetDimBeams, vxBrace, vyBrace);
	else
		dimLineBeams = DimLine(ptBrace - vyBrace * dOffsetDimBeams, vxBrace, vyBrace);
		
	arPtBeam.setLength(0);
	arPtBeam.append(bmBeams.ptCen() - bmBeams.vecD(vxBrace) * 0.5 * bmBeams.dD(vxBrace));
	arPtBeam.append(bmBeams.ptCen() + bmBeams.vecD(vxBrace) * 0.5 * bmBeams.dD(vxBrace));

	if (bDimBeams) {
		Dim dimBeams(dimLineBeams, arPtBeam, sDimTextBeams, sDimTextBeams,nDimLayoutDeltaBms,nDimLayoutCumBms);
		dimBeams.transformBy(ms2ps);
		dimBeams.setReadDirection(-_XW + _YW);
		dimBeams.setDeltaOnTop(nDeltaOnTopBms);
		dpDim.draw(dimBeams);
	}
	
	if (bShowPosnum) {
		Vector3d vxPosnum = vyEl;
		Vector3d vyPosnum = vzEl;
		Point3d ptPosnum = bmBeams.ptCen() - vxPosnum * bmBeams.dD(vxPosnum);
		PLine plLeader(vzms);
		plLeader.addVertex(ptPosnum);
		plLeader.addVertex(bmBeams.ptCen());
		plLeader.transformBy(ms2ps);
		dpArc.draw(plLeader);
		vxPosnum.transformBy(ms2ps);
		vyPosnum.transformBy(ms2ps);
		ptPosnum.transformBy(ms2ps);
		dpPosnum.draw(bmBeams.posnum(), ptPosnum, vxPosnum, vyPosnum, -1.5, 0);
	}
}

if (bDimStartBrace) {
	dimLineBeams = DimLine(ptBrace - vyBrace * dOffsetDimBeams, vxBrace, vyBrace);
	arPtBeam.setLength(0);
	arPtBeam.append(arPtBraceZ[0]);
	arPtBeam.append(ptBrace);
	Dim dimBeams(dimLineBeams, arPtBeam, sDimTextBeams, sDimTextBeams,nDimLayoutDeltaBms,nDimLayoutCumBms);
	dimBeams.transformBy(ms2ps);
	dimBeams.setReadDirection(-_XW + _YW);
	dimBeams.setDeltaOnTop(nDeltaOnTopBms);
	dpDim.draw(dimBeams);
}

if (bShowPosnum) {
	Vector3d vxPosnum = vxBrace;
	Vector3d vyPosnum = vyBrace;
	Point3d ptPosnum = arBmBrace[0].ptCen() + vxPosnum * 0.25 * arBmBrace[0].solidLength();
	vxPosnum.transformBy(ms2ps);
	vyPosnum.transformBy(ms2ps);
	ptPosnum.transformBy(ms2ps);
	dpPosnum.draw(arBmBrace[0].posnum(), ptPosnum, vxPosnum, vyPosnum, 0, 0);

	Beam bmSupportingBeam;
	if( arBmSupportingBeam.length() > 0 )
		bmSupportingBeam = arBmSupportingBeam[0];
	if( bmSupportingBeam.bIsValid() ){
		vxPosnum = bmSupportingBeam.vecX();
		if( vxPosnum.dotProduct(vzEl) < 0 )
			vxPosnum *= -1;
		vyPosnum = vzms.crossProduct(vxPosnum);
		ptPosnum = bmSupportingBeam.ptCen() + vxPosnum * 0.25 * bmSupportingBeam.solidLength();
		vxPosnum.transformBy(ms2ps);
		vyPosnum.transformBy(ms2ps);
		ptPosnum.transformBy(ms2ps);
		dpPosnum.draw(bmSupportingBeam.posnum(), ptPosnum, vxPosnum, vyPosnum, 0, 0);
	}
}

// Sheets
if (bDimSheets) {
	Point3d arPtSheet[0];
	for( int i=0;i<arShBraceSheet.length();i++ ){
		Sheet shBraceSheet = arShBraceSheet[i];
		arPtSheet.append(shBraceSheet.profShape().getGripVertexPoints());
	}
	
	if( arPtSheet.length() > 1 ){
		DimLine dimLineSheets(ptBrace - vyBrace * dOffsetDimSheets, vxBrace, vyBrace);
		Dim dimSheet(dimLineSheets, arPtSheet, sDimTextSheets, sDimTextSheets,nDimLayoutDeltaShs,nDimLayoutCumShs);
		dimSheet.transformBy(ms2ps);
		dimSheet.setReadDirection(-_XW + _YW);
		dimSheet.setDeltaOnTop(nDeltaOnTopShs);
		dpDim.draw(dimSheet);
	}
}

// Angle
if (bShowArc) {
	Point3d arPtArc[] = {
		ptBrace - vxBrace * dOffsetAngle,
		ptBrace + vyEl * dOffsetAngle
	};
	Vector3d arVxArc[] = {
		vxBrace,
		vyEl
	};
	
	double dExtend = U(2.0) * dVpScale;
	double dRadCircle = U(0.5) * dVpScale;
	
	PLine plArc(vzms);
	for( int i=0;i<arPtArc.length();i++ ){
		Point3d ptArc = arPtArc[i];
		Vector3d vxArc = arVxArc[i];
		
		if( i==0 )
			plArc.addVertex(ptArc);
		else
			plArc.addVertex(ptArc, dOffsetAngle, _kCCWise, true);
		
		PLine plLeader(vzms);
		plLeader.addVertex(ptArc - vxArc * 0.5 * dExtend);
		plLeader.addVertex(ptArc + vxArc * 0.5 * dExtend);
		plLeader.transformBy(ms2ps);
		dpArc.draw(plLeader);
		
		PLine plCircle(vzms);
		plCircle.createCircle(ptArc, vzms, dRadCircle);
		PlaneProfile ppCircle(CoordSys(ptArc, vxms, vyms, vzms));
		ppCircle.joinRing(plCircle, _kAdd);
		ppCircle.transformBy(ms2ps);
		dpArc.draw(ppCircle, _kDrawFilled);	
	}
	plArc.transformBy(ms2ps);
	dpArc.draw(plArc);
	
	double dAng = vyEl.angleTo(-vxBrace);//, vzms);
	String sAng;
	sAng.formatUnit(dAng, 2,0);
	sAng += "°";
	Vector3d vyTxtAng = vxBrace - vyEl;
	vyTxtAng.normalize();
	Vector3d vxTxtAng = vyTxtAng.crossProduct(vzms);
	Point3d ptTxtAng = ptBrace - vyTxtAng * dOffsetAngle;
	ptTxtAng.transformBy(ms2ps);
	vxTxtAng.transformBy(ms2ps);
	vyTxtAng.transformBy(ms2ps);
	dpDim.draw(sAng, ptTxtAng, vxTxtAng, vyTxtAng, 0, 1.25); 
}
#End
#BeginThumbnail
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
C`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@#_]F*
`












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