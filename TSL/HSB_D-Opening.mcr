#Version 8
#BeginDescription
TH - 3.25 - 19.02.2020 - bugfix invalid openings.








#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 3
#MinorVersion 25
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl dimensions openings in an element
/// </summary>

/// <insert>
/// Select a viewport
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="3.24" date="18.02.2019"></version>

/// <history>
/// AS - 1.00 - 02.03.2005 - Pilot version
/// AS - 1.01 - 21.04.2005 - Update dim: add door dimensioning
/// AS - 1.02 - 23.05.2005 - Update dim: find openings in a different way. (subtract el.profNetto() from el.profBrutto())
/// AS - 1.03 - 27.05.2005 - Filter points when wall has an angled connection with an other wall
/// AS - 1.04 - 20.06.2006 - Add a filter to filter beams based on label
/// AS - 1.05 - 20.09.2006 - Autoscale dimensions --> set to viewport scale
/// AS - 1.06 - 04.11.2009 - Add option to switch between opening outline and beams closest to opening outline. Use el::Opening to find the openings
/// AS - 1.07 - 26.11.2009 - Add option to overrule description
/// AS - 1.08 - 11.11.2010 - Resolve properties after the insert
/// AS - 1.09 - 16.11.2010 - Add special
/// AS - 2.00 - 25.10.2011 - Update filters
/// AS - 2.01 - 11.11.2011 - Project points to side of the element
/// AS - 2.02 - 27.02.2012 - Add option to offset in paperspace units
/// AS - 3.00 - 08.03.2012 - Prepare for localizer
/// AS - 3.01 - 14.03.2012 - Reset list of dimpoints when dimensioning per opening.
/// AS - 3.02 - 04.04.2012 - Add option to specify filters for reference points
/// AS - 3.03 - 18.09.2012 - Add new dim object and the option to dimension the header.
/// AS - 3.04 - 28.09.2012 - Let user pick an insertion point when the tsl is inserted.
/// AS - 3.05 - 10.10.2012 - Correct bug on header dimension
/// AS - 3.06 - 11.10.2012 - Add properties for position description
/// AS - 3.07 - 10.01.2013 - Add property to add the topplate to the dimline for vertical dimensions per opening.
/// AS - 3.08 - 01.02.2013 - Correct zone index bug.
/// AS - 3.09 - 11.02.2013 - Correct side of description for dim per opening.
/// AS - 3.10 - 11.02.2013 - Add option to dimension bottomplate
/// AS - 3.11 - 18.02.2013 - Use element ucs and not ms ucs for opening calculations
/// AS - 3.12 - 29.04.2013 - Take outline if timbers are not found.
/// AS - 3.13 - 05.06.2013 - Collect points from envelopeBody if bottom beam has an extr.profile.
/// AS - 3.14 - 29.09.2014 - Add option to dimension shadow profile. Add zone filters.
/// AS - 3.15 - 10.11.2014 - Add support for sections
/// AS - 3.16 - 21.09.2015 - Add support wildcards in filters.
/// AS - 3.17 - 15.12.2015 - Name and description exposed as settings.
/// RP - 3.18 - 15.01.2018 - Add option to consider sheeting in the opening for the closest beam
/// RP - 3.19 - 15.01.2018 - Skip sheets with vecz aligned with element z
/// AS - 3.20 - 14.02.2018 - Use elY instead of vxms for vertical dimensions.
/// DR - 3.21 - 03.07.2018 - Added use of HSB_G-FilterGenBeams.mcr
/// RP - 3.22 - 19.09.2018 - Remove old code for filtering and add filterdefenition for references
/// RP - 3.23 - 11.03.2019 - Add Center as option to dimension
/// AS - 3.24 - 18.02.2020 - Add option to filter on opening description.
/// TH - 3.25 - 19.02.2020 - bugfix invalid openings.
/// </hsitory>

Unit(1,"mm"); // script uses mm

double dEps = U(0.1);

String arSMode[] = {
	T("|Outline|"),
	T("|Closest beams|"),
	T("|Outside of closest beams|"),
	T("|Shadow profile|")
};

String arSPosition[] = {
	T("|Horizontal bottom|"),
	T("|Horizontal top|"),
	T("|Vertical left|"),
	T("|Vertical right|"),
	T("|Vertical per opening|")
};

String sArDimLayout[] ={
	T("|Delta perpendicular|"),
	T("|Delta parallel|"),
	T("|Cummulative perpendicular|"),
	T("|Cummalative parallel|"),
	T("|Both perpendicular|"),
	T("|Both parallel|"),
	T("|Delta parallel|, ")+T("|Cummalative perpendicular|"),
	T("|Delta perpendicular|, ")+T("|Cummalative parallel|")
};
int nArDimLayoutDelta[] = {_kDimPerp, _kDimPar,_kDimNone,_kDimNone,_kDimPerp,_kDimPar,_kDimPar,_kDimPerp};
int nArDimLayoutCum[] = {_kDimNone,_kDimNone,_kDimPerp, _kDimPar,_kDimPerp,_kDimPar,_kDimPerp,_kDimPar};

String arSDeltaOnTop[]={T("Above"),T("Below")};
int arNDeltaOnTop[]={true,false};

String arSLeftRight[] = {
	T("|Left|"), 
	T("|Right|")
};
int arNLeftRight[] = {
	_kLeft,
	_kRight
};

String arSDimSide[] = {
	T("|Left|"),
	T("|Right|"),
	T("|Left & right|"),
	T("|Center|")
};
String arSDimSideReference[] = {
	T("|Left|"),
	T("|Right|"),
	T("|Left & right|")
};
int arNDimSide[]={_kLeft, _kRight, _kLeftAndRight, _kCenter};
int arNDimSideReference[]={_kLeft, _kRight, _kLeftAndRight};

String arSReferenceType[] = {
	T("|No reference point|"),
	T("|Zone|")
};

int arNReferenceZone[] = {5,4,3,2,1,0,6,7,8,9,10};

String arSYesNo[] = {T("|Yes|"), T("|No|")};
String arSNoYes[] = {T("|No|"), T("|Yes|")};
int arNYesNo[] = {_kYes, _kNo};


String arSSectionName[0];
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


// Selection
PropString sSeperator01(0, "", T("|Selection|"));
sSeperator01.setReadOnly(true);
PropString sSectionName(25, arSSectionName, "     "+T("|Section tsl name|"));

String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = TslInst().getListOfCatalogNames(filterDefinitionTslName);
filterDefinitions.insertAt(0, "");

PropString genBeamFilterDefinition(34, filterDefinitions, "     "+T("|Filter definition for GenBeams|"));
genBeamFilterDefinition.setDescription(T("|Filter definition for GenBeams.|") + T(" (|Will be combined with custom filters|)") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));

PropString genBeamFilterDefinitionReference(35, filterDefinitions, "     "+T("|Filter definition for Reference GenBeams|"));
genBeamFilterDefinitionReference.setDescription(T("|Filter definition for Reference GenBeams.|") + T(" (|Will be combined with custom filters|)") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));

PropString sFilterBC(1,"","     "+T("Filter beams with beamcode"));
PropString sFilterLabel(2,"","     "+T("Filter beams and sheets with label"));
PropString sFilterMaterial(26,"","     "+T("Filter beams and sheets with material"));
PropString sFilterZn(23, "", "     "+T("|Filter zones|"));
PropString sFilterBCReference(15,"","     "+T("Filter beams with beamcode for reference"));
PropString sFilterLabelReference(16,"","     "+T("Filter beams and sheets with label for reference"));
PropString sFilterMaterialReference(27,"","     "+T("Filter beams and sheets with material for reference"));
PropString sFilterZnReference(24, "", "     "+T("|Filter zones for reference|"));
PropString filterOpeningDescriptionsProp(36, "", "     "+T("|Filter openings with description|"));

// Opening dimension
PropString sSeperator02(3, "", T("|Opening dimension|"));
sSeperator02.setReadOnly(true);
PropString sMode(4, arSMode, "     "+T("|Mode|"));
PropString sSheetInOpening(33, arSNoYes, "     "+T("|Sheet in opening|"));
PropString sDimHeader(17, arSYesNo, "     "+T("|Dimension header|"),1);
PropString sDimTopPlate(21, arSYesNo, "     "+T("|Dimension topplate|"),1);
PropString sDimBottomPlate(22, arSYesNo, "     "+T("|Dimension bottomplate|"),1);

// Positioning
PropString sSeperator03(18, "", T("|Positioning|"));
sSeperator03.setReadOnly(true);
PropString sPosition(5,arSPosition,"     "+T("|Position|"));
PropString sUsePSUnits(14, arSYesNo, "     "+T("|Offset in paperspace units|"),1);
PropDouble dDimLineOffset(0,U(300),"     "+T("|Offset dimension line|"));

// Style
PropString sSeperator05(19, "", T("|Style|"));
sSeperator05.setReadOnly(true);
PropString sDimLayout(6,sArDimLayout,"     "+T("|Dimension layout|"));
PropString sDeltaOnTop(7,arSDeltaOnTop,"     "+T("|Position delta dimension|"),0);
PropString sDimensionSide(8,arSDimSide,"     "+T("|Dimension side|"));
PropDouble dTextOffset(1,U(100),"     "+T("|Offset text|"));
PropString sDimStyle(9,_DimStyles,"     "+T("|Dimension style|"));
PropInt nDimColor(1,1,"     "+T("|Color|"));
PropString sSideDescription(20, arSLeftRight, "     "+T("|Side of description|"));
PropString sDescription(10, "", "     "+T("|Description|"));

// Reference
PropString sSeperator04(11, "", T("|Reference position|"));
sSeperator04.setReadOnly(true);
PropString sReferenceType(12, arSReferenceType, "     "+T("|Reference type|"));
PropInt nReferenceZn(0, arNReferenceZone, "     "+T("|Reference zone|"));
PropString sReferenceSide(13, arSDimSideReference, "     "+T("|Reference side|"));

/// - Name and description -
/// 
PropString sSeperator14(28, "", T("|Name and description|"));
sSeperator14.setReadOnly(true);

PropInt nColorName(2, -1, "     "+T("|Default name color|"));
PropInt nColorActiveFilter(3, 30, "     "+T("|Filter other element color|"));
PropInt nColorActiveFilterThisElement(4, 1, "     "+T("|Filter this element color|"));
PropString sDimStyleName(29, _DimStyles, "     "+T("|Dimension style name|"));
PropString sInstanceDescription(30, "", "     "+T("|Extra description|"));
PropString sDisableTsl(31, arSYesNo, "     "+T("|Disable the tsl|"),1);
PropString sShowVpOutline(32, arSYesNo, "     "+T("|Show viewport outline|"),1);


int nNameColor = -1;

String arSTrigger[] = {
	T("|Filter this element|"),
	"     ----------",
	T("|Remove filter for this element|"),
	T("|Remove filter for all elements|")
};
for( int i=0;i<arSTrigger.length();i++ )
	addRecalcTrigger(_kContext, arSTrigger[i] );


if (_bOnInsert) {
	showDialog();
	
	_Pt0 = getPoint(T("|Select location|"));
	
	Viewport vp = getViewport(T("|Select a viewport|")); // select viewport
	_Viewport.append(vp);

	return;
}

// do something for the last appended viewport only
if( _Viewport.length()==0 ){
	eraseInstance();
	return;
}
Viewport vp = _Viewport[0];
Element el = vp.element();

// Draw name
String sInstanceNameAndDescription = _ThisInst.scriptName();
if( sInstanceDescription.length() > 0 )
	sInstanceNameAndDescription += (" - "+sInstanceDescription);

Display dpName(nColorName);
dpName.dimStyle(sDimStyleName);
dpName.draw(sInstanceNameAndDescription, _Pt0, _XW, _YW, 1, 2);

double dTextHeightName = dpName.textHeightForStyle("HSB", sDimStyleName);

// Add filteer
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

// check if the viewport has hsb data
if( !el.bIsValid() )
	return;

CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps
double dVpScale = ps2ms.scale();

String filterOpeningDescriptions[] = filterOpeningDescriptionsProp.makeUpper().tokenize(';');

int nMode = arSMode.find(sMode,0);
int bSheetInOpening = arSNoYes.find(sSheetInOpening,0);
int nPosition = arSPosition.find(sPosition,0);
int nSideDescription = arNLeftRight[arSLeftRight.find(sSideDescription,0)];
int nDimLayoutDelta = nArDimLayoutDelta[sArDimLayout.find(sDimLayout,0)];
int nDimLayoutCum = nArDimLayoutCum[sArDimLayout.find(sDimLayout,0)];
int nDeltaOnTop = arNDeltaOnTop[arSDeltaOnTop.find(sDeltaOnTop,0)];
int nDimSide = arNDimSide[arSDimSide.find(sDimensionSide,0)];
int bUsePSUnits = arNYesNo[arSYesNo.find(sUsePSUnits,1)];
double dOffsetDimLine = dDimLineOffset;
if( bUsePSUnits )
	dOffsetDimLine *= dVpScale;
double dOffsetText = dTextOffset;
if( bUsePSUnits )
	dOffsetText *= dVpScale;
int bDimHeader = arNYesNo[arSYesNo.find(sDimHeader, 1)];
int bDimTopPlate = arNYesNo[arSYesNo.find(sDimTopPlate, 1)];
int bDimBottomPlate = arNYesNo[arSYesNo.find(sDimBottomPlate, 1)];
// reference
int nReferenceType = arSReferenceType.find(sReferenceType,0);
int nReferenceSide = arNDimSideReference[arSDimSideReference.find(sReferenceSide,1)];
int nReferenceZone = nReferenceZn;
if( nReferenceZone > 5 )
	nReferenceZone = 5- nReferenceZone;

Display dpDim(nDimColor);
dpDim.dimStyle(sDimStyle, dVpScale);

CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

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

Plane pnElZ(ptEl, vzEl);
PlaneProfile ppGBm(csEl);
PlaneProfile ppGBmRef(csEl);

// Viewport handle, used to find the corresponding section tsl.
String sVpHandle = vp.viewData().viewHandle();

TslInst tslSection;
for( int i=0;i<arEntTsl.length();i++ ){
	TslInst tsl = (TslInst)arEntTsl[i];
	
	Map mapTsl = tsl.map();
	String vpHandle = mapTsl.getString("VPHANDLE");
	
	if( tsl.scriptName() == sSectionName  && vpHandle == sVpHandle ){
		tslSection = tsl;
		break;
	}
}

GenBeam arGBmAll[0]; 
arGBmAll.append(el.genBeam());
TslInst arTsl[0];
Opening arOp[0];
if( !tslSection.bIsValid() ){
	arOp.append(el.opening());
}
else{
	_Entity.append(tslSection);
	setDependencyOnEntity(tslSection);
	
	Map mapTsl = tslSection.map();
	for( int i=0;i<mapTsl.length();i++ ){
		if( mapTsl.keyAt(i) == "GENBEAM" ){
			Entity entGBm = mapTsl.getEntity(i);
			arGBmAll.append((GenBeam)entGBm);
		}
		if( mapTsl.keyAt(i) == "TslInst" ){
			Entity entTsl = mapTsl.getEntity(i);
			arTsl.append((TslInst)entTsl);
		}
		if (mapTsl.keyAt(i) == "Opening" ){
			Entity entOpening = mapTsl.getEntity(i);
			arOp.append((Opening)entOpening);
		}
	}
}

//region filter genBeams (new)
Entity genBeamEntities[0];
for (int b = 0; b < arGBmAll.length(); b++)
{
	GenBeam genBeam = arGBmAll[b];
	if ( ! genBeam.bIsValid())
		continue;
	
	genBeamEntities.append(genBeam);
}

Map filterGenBeamsMap;
filterGenBeamsMap.setEntityArray(genBeamEntities, false, "GenBeams", "GenBeams", "GenBeam");
filterGenBeamsMap.setString("BeamCode[]", sFilterBC);
filterGenBeamsMap.setString("Label[]", sFilterLabel);
filterGenBeamsMap.setString("Material[]", sFilterMaterial);
filterGenBeamsMap.setString("Zone[]", sFilterZn);
filterGenBeamsMap.setInt("Exclude", true);
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

Map filterGenBeamsMapReference;
filterGenBeamsMapReference.setEntityArray(genBeamEntities, false, "GenBeams", "GenBeams", "GenBeam");
filterGenBeamsMapReference.setString("BeamCode[]", sFilterBCReference);
filterGenBeamsMapReference.setString("Label[]", sFilterLabelReference);
filterGenBeamsMapReference.setString("Material[]", sFilterMaterialReference);
filterGenBeamsMapReference.setString("Zone[]", sFilterZnReference);
filterGenBeamsMapReference.setInt("Exclude", true);
int successfullyFilteredReference = TslInst().callMapIO(filterDefinitionTslName, genBeamFilterDefinitionReference, filterGenBeamsMapReference);
if ( ! successfullyFiltered)
{
	reportWarning(T("|GenBeams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
	eraseInstance();
	return;
}

Entity filteredGenBeamEntitiesReference[] = filterGenBeamsMapReference.getEntityArray("GenBeams", "GenBeams", "GenBeam");
GenBeam filteredGenBeamsReference[0];
for (int e = 0; e < filteredGenBeamEntitiesReference.length(); e++)
{
	GenBeam genBeam = (GenBeam)filteredGenBeamEntitiesReference[e];
	if ( ! genBeam.bIsValid()) continue;
	
	filteredGenBeamsReference.append(genBeam);
}

//endregion

GenBeam arGBm[0];
Beam arBm[0];
Sheet arSh[0];

Point3d arPtGBm[0];

GenBeam arGBmRef[0];
Point3d arPtGBmRef[0];

Beam arBmReference[0];

Beam arBmHeader[0];
Beam arBmTopPlate[0];
Beam arBmBottomPlate[0];

for( int i=0;i<filteredGenBeams.length();i++ ){
	GenBeam gBm = filteredGenBeams[i];
	Beam bm = (Beam)gBm;
	Sheet sh = (Sheet)gBm;
	
	Body bdGBm = gBm.realBody();
	Point3d arPtThisGBm[] = bdGBm.allVertices();
	
	arGBm.append(gBm);
	arPtGBm.append(arPtThisGBm);

	PlaneProfile ppThisGBm(bdGBm.shadowProfile(pnElZ));
	ppThisGBm.shrink(-U(15));
	ppGBm.unionWith(ppThisGBm);
	if(sh.bIsValid() )
	{
		arSh.append(sh);
	}
	else if(bm.bIsValid() ){
		arBm.append(bm);
		if( bm.type() == _kHeader )
			arBmHeader.append(bm);
		if( bm.type() == _kSFTopPlate )
			arBmTopPlate.append(bm);
		if( bm.type() == _kSFBottomPlate )
			arBmBottomPlate.append(bm);
	}
}
if ( nReferenceType == 1)
{
	for( int i=0;i<filteredGenBeamsReference.length();i++ )
	{
		GenBeam gBm = filteredGenBeamsReference[i];
		int nZnIndex = gBm.myZoneIndex();
		if (nZnIndex != nReferenceZone) continue;
		Beam bm = (Beam)gBm;
		Sheet sh = (Sheet)gBm;
		
		Body bdGBm = gBm.realBody();
		Point3d arPtThisGBm[] = bdGBm.allVertices();
		
		arGBmRef.append(gBm);
		arPtGBmRef.append(arPtThisGBm);
		
		PlaneProfile ppThisGBm(bdGBm.shadowProfile(pnElZ));
		ppThisGBm.shrink(-U(15));
		ppGBmRef.unionWith(ppThisGBm);
	}
}


ppGBm.shrink(U(15));
ppGBmRef.shrink(U(15));

ppGBm.vis(3);
//ppGBmRef.vis(1);


if( arPtGBm.length() == 0 )
	return;

Point3d arPtGBmX[] = lnXms.orderPoints(arPtGBm);
Point3d arPtGBmY[] = lnYms.orderPoints(arPtGBm);
Point3d ptL = arPtGBmX[0];
Point3d ptR = arPtGBmX[arPtGBmX.length() - 1];
Point3d ptB = arPtGBmY[0];
Point3d ptT = arPtGBmY[arPtGBmY.length() - 1];
ptL += vyms * vyms.dotProduct((ptB + ptT)/2 - ptL);
ptR += vyms * vyms.dotProduct(ptL - ptR);
ptB += vxms * vxms.dotProduct((ptL + ptR)/2 - ptB);
ptT += vxms * vxms.dotProduct(ptB - ptT);
Point3d ptM = ptL + vxms * vxms.dotProduct(ptT - ptL);
Point3d ptBL = ptB + vxms * vxms.dotProduct(ptL - ptB);
Point3d ptBR = ptB + vxms * vxms.dotProduct(ptR - ptB);
Point3d ptTR = ptT + vxms * vxms.dotProduct(ptR - ptT);
Point3d ptTL = ptT + vxms * vxms.dotProduct(ptL - ptT);

Point3d arPtReference[0];
if( nReferenceType == 1 )
{ // zone
	if( nPosition < 2 )
		arPtGBmRef = lnXms.orderPoints(arPtGBmRef);
	if( nPosition > 1 )
		arPtGBmRef = lnYms.orderPoints(arPtGBmRef);
	
	if( arPtGBmRef.length() > 0 ){
		if( nReferenceSide == _kLeft || nReferenceSide == _kLeftAndRight )
		{
			arPtReference.append(arPtGBmRef[0]);
		}
		if( nReferenceSide == _kRight || nReferenceSide == _kLeftAndRight )	
		{
			arPtReference.append(arPtGBmRef[arPtGBmRef.length() - 1]);
		}
	}
}

Point3d arPtDimObject[0];
for( int i=0;i<arOp.length();i++ ){
	Opening op = arOp[i];
	String openingDescription = op.openingDescr().makeUpper();
	if (filterOpeningDescriptions.find(openingDescription) != -1) continue;
	
	PLine plOp = op.plShape();
	if (plOp.length() < dEps)continue;//bugfix invalid openings.
	plOp.transformBy(vzEl * vzEl.dotProduct((ptEl - vzEl * 0.5 * el.zone(0).dH()) - plOp.ptStart()));
		
	Point3d arPtOp[] = plOp.vertexPoints(true);
	Point3d arPtOpX[] = Line(ptEl, vxEl).orderPoints(arPtOp);
	Point3d arPtOpY[] = Line(ptEl, vyEl).orderPoints(arPtOp);
	Point3d ptOpL = arPtOpX[0];
	Point3d ptOpR = arPtOpX[arPtOpX.length() - 1];
	Point3d ptOpB = arPtOpY[0];
	Point3d ptOpT = arPtOpY[arPtOpY.length() - 1];
	ptOpL += vyEl * vyEl.dotProduct((ptOpB + ptOpT)/2 - ptOpL);
	ptOpR += vyEl * vyEl.dotProduct(ptOpL - ptOpR);
	ptOpB += vxEl * vxEl.dotProduct((ptOpL + ptOpR)/2 - ptOpB);
	ptOpT += vxEl * vxEl.dotProduct(ptOpB - ptOpT);
	Point3d ptOpM = ptOpL + vxEl * vxEl.dotProduct(ptOpT - ptOpL);
	Point3d ptOpBL = ptOpB + vxEl * vxEl.dotProduct(ptOpL - ptOpB);
	Point3d ptOpBR = ptOpB + vxEl * vxEl.dotProduct(ptOpR - ptOpB);
	Point3d ptOpTR = ptOpT + vxEl * vxEl.dotProduct(ptOpR - ptOpT);
	Point3d ptOpTL = ptOpT + vxEl * vxEl.dotProduct(ptOpL - ptOpT);
	
	Point3d ptOpMidPS = ptOpM;
	ptOpMidPS.transformBy(ms2ps);
	ptOpMidPS.vis();
	
	ptOpM.vis(3);
	
	Point3d arPtThisOpening[0];
	if (nMode == 0){
		arPtThisOpening.append(arPtOp);
	}
	else if (nMode == 1 || nMode == 2) {
		// inside or outside of beam.
		int nBmSide = 1;
		if( nMode == 2 )
			nBmSide *= -1;
		
		Beam beamsToDelete[0];
		if (sSheetInOpening == T("|Yes|"))
		{
			Sheet sheets[] = el.sheet();
			for (int index=0;index<sheets.length();index++) 
			{ 
				Sheet sheet = sheets[index]; 
				if (abs(vzEl.dotProduct(sheet.vecZ())) > 1 - dEps) continue;
				Beam beam;
				sheet.realBody().vis(index);
				beam.dbCreate(sheet.realBody());
				arBm.append(beam);
				beamsToDelete.append(beam);
			}
		}
		
		if( nPosition < 2 ){
			Beam arBmLeft[] = Beam().filterBeamsHalfLineIntersectSort(arBm, ptOpM, -vxEl);
			if( arBmLeft.length() == 0 )
				continue;
			Beam bmLeft = arBmLeft[0];
			arPtThisOpening.append(bmLeft.ptCen() + bmLeft.vecD(vxEl) * 0.5 * nBmSide * bmLeft.dD(vxEl));

			Beam arBmRight[] = Beam().filterBeamsHalfLineIntersectSort(arBm, ptOpM, vxEl);
			if( arBmRight.length() == 0 )
				continue;
			Beam bmRight = arBmRight[0];
			arPtThisOpening.append(bmRight.ptCen() - bmRight.vecD(vxEl) * 0.5 * nBmSide * bmRight.dD(vxEl));
		}
		else{
			Beam arBmBottom[] = Beam().filterBeamsHalfLineIntersectSort(arBm, ptOpM, -vyEl);
			if( arBmBottom.length() > 0 ){
				Beam bmBottom = arBmBottom[0];
				if( bmBottom.extrProfile() != _kExtrProfRectangular && bmBottom.extrProfile() != _kExtrProfRound ){
					Point3d arPtBm[] = bmBottom.envelopeBody(true, true).allVertices();
					arPtBm = Line(bmBottom.ptCen(), vyEl).orderPoints(arPtBm);
					if( arPtBm.length() > 0 )
						arPtThisOpening.append(arPtBm[arPtBm.length() - 1]);
				}
				else{
					arPtThisOpening.append(bmBottom.ptCen() + bmBottom.vecD(vyEl) * 0.5 * nBmSide * bmBottom.dD(vyEl));
				}
			}

			Beam arBmTop[] = Beam().filterBeamsHalfLineIntersectSort(arBm, ptOpM, vyEl);
			if( arBmTop.length() > 0 ){
				Beam bmTop = arBmTop[0];
				arPtThisOpening.append(bmTop.ptCen() - bmTop.vecD(vyEl) * 0.5 * nBmSide * bmTop.dD(vyEl));
			}
		}
		for (int index=0;index<beamsToDelete.length();index++) 
		{ 
			Beam beam = beamsToDelete[index]; 
			beam.dbErase(); 
		}
		
	}
	else if (nMode == 3) {
		PLine arPlGBm[] = ppGBm.allRings();
		int arBRingIsOpening[] = ppGBm.ringIsOpening();
		
		for (int j=0;j<arPlGBm.length();j++) {
			if (!arBRingIsOpening[j])
				continue;
			
			PLine pl = arPlGBm[j];
			PLine p = pl;
			p.transformBy(ms2ps);
			p.vis(j);
			PlaneProfile pp(csEl);
			pp.joinRing(pl, _kAdd);
			
			if (pp.pointInProfile(ptOpM) == _kPointInProfile) {
				arPtThisOpening.append(pl.vertexPoints(true));
				break;
			}
		}
	}
	
	if( nPosition < 2 )
		arPtThisOpening = lnXms.orderPoints(arPtThisOpening);
	else
		arPtThisOpening = lnYms.orderPoints(arPtThisOpening);
	
	if( (nMode == 1 || nMode == 2) && arPtThisOpening.length() == 0 ){
		reportMessage(scriptName() + T(" - |No beams found around opening. Outline is taken.|"));
		arPtThisOpening.append(arPtOp);
	}
	if( arPtThisOpening.length() == 0 )
		continue;		
		
	Point3d arPtDimThisOpening[0];
	if( nDimSide == _kLeft || nDimSide == _kLeftAndRight )
	{
		arPtDimThisOpening.append(arPtThisOpening[0]);
	}
	if( nDimSide == _kRight || nDimSide == _kLeftAndRight )	
	{
		arPtDimThisOpening.append(arPtThisOpening[arPtThisOpening.length() - 1]);
	}
	if (nDimSide == _kCenter)
	{
		arPtDimThisOpening.append((arPtThisOpening[0] + arPtThisOpening[arPtThisOpening.length() - 1]) / 2);
	}
	
	Beam arBmHeaderThisOp[] = Beam().filterBeamsHalfLineIntersectSort(arBmHeader, ptOpM, vyEl);
	if( nPosition >= 2 && bDimHeader && arBmHeaderThisOp.length() > 0 ){
		Beam bmHeader = arBmHeaderThisOp[0];
		arPtDimThisOpening.append(bmHeader.ptCen() - bmHeader.vecD(vyEl) * 0.5 * bmHeader.dD(vyEl));
	}
	Beam arBmTopPlateThisOp[] = Beam().filterBeamsHalfLineIntersectSort(arBmTopPlate, ptOpM, vyEl);
	if( nPosition >= 2 && bDimTopPlate && arBmTopPlateThisOp.length() > 0 ){
		Beam bmTopPlate = arBmTopPlateThisOp[0];
		arPtDimThisOpening.append(bmTopPlate.ptCen() + bmTopPlate.vecD(vyEl) * 0.5 * bmTopPlate.dD(vyEl));
	}
	Beam arBmBottomPlateThisOp[] = Beam().filterBeamsHalfLineIntersectSort(arBmBottomPlate, ptOpM, -vyEl);
	if( nPosition >= 2 && bDimBottomPlate && arBmBottomPlateThisOp.length() > 0 ){
		Beam bmBottomPlate = arBmBottomPlateThisOp[0];
		if( bmBottomPlate.extrProfile() != _kExtrProfRectangular && bmBottomPlate.extrProfile() != _kExtrProfRound ){
			Point3d arPtBm[] = bmBottomPlate.envelopeBody(true, true).allVertices();
			arPtBm = Line(bmBottomPlate.ptCen(), vyEl).orderPoints(arPtBm);
			if( arPtBm.length() > 0 )
				arPtDimThisOpening.append(arPtBm[arPtBm.length() - 1]);
		}
		else{
			arPtDimThisOpening.append(bmBottomPlate.ptCen() + bmBottomPlate.vecD(-vyEl) * 0.5 * bmBottomPlate.dD(vyEl));
		}
	}

	arPtDimObject.append(arPtDimThisOpening);
	if( nPosition == 4 ){ // Vertical per opening
		Point3d ptDimLine = ptOpBL + (vxms + vyms) * dOffsetDimLine;
		Vector3d vxDimLine = vyms;
		Vector3d vyDimLine = -vxms;
		
		Point3d arPtDim[0];
		arPtDim.append(arPtReference);
		arPtDim.append(arPtDimThisOpening);
		
		arPtDim = Line(ptOpM, vyms).projectPoints(arPtDim);
		arPtDim = Line(ptOpM, vyms).orderPoints(arPtDim);

		
		DimLine dimLine(ptDimLine, vxDimLine, vyDimLine);
		Dim dimTotal(dimLine, arPtDim, "<>", "<>", nDimLayoutDelta,nDimLayoutCum);
		dimTotal.transformBy(ms2ps);
		dimTotal.setReadDirection(-_XW + _YW);
		dimTotal.setDeltaOnTop(nDeltaOnTop);
		dpDim.draw(dimTotal);
		
		Point3d ptDimName = arPtDim[arPtDim.length() - 1];
		if( nSideDescription == _kLeft )
			ptDimName = arPtDim[0];
		ptDimName += nSideDescription * vxDimLine * dOffsetText;
		ptDimName += vyDimLine * vyDimLine.dotProduct(ptDimLine - ptDimName);
		ptDimName.transformBy(ms2ps);
		Vector3d vxDimLinePS = vxDimLine;
		vxDimLinePS.transformBy(ms2ps);
		vxDimLinePS.normalize();
		Vector3d vyDimLinePS = vyDimLine;
		vyDimLinePS.transformBy(ms2ps);
		vyDimLinePS.normalize();
		dpDim.draw(sDescription, ptDimName, vxDimLinePS, vyDimLinePS, nSideDescription, 1);
	}
	else{
		
	}
}

if( nPosition != 4 ){
	// order points of dim-object
	if( nPosition == 0 || nPosition == 2 )
		arPtDimObject = lnYms.orderPoints(arPtDimObject);
	if( nPosition == 1 || nPosition == 3 )
		arPtDimObject = lnXms.orderPoints(arPtDimObject);
	
	Point3d arPtDim[0];
	arPtDim.append(arPtReference);
	arPtDim.append(arPtDimObject);
	
	Point3d ptDimLine = ptBL - (vxms + vyms) * dOffsetDimLine;
	Vector3d vxDimLine = vxms;
	Vector3d vyDimLine = vyms;
	
	Line lnProject(ptBL, vxDimLine);
	if( nPosition == 0 ){ // bottom
		
	}
	else if( nPosition == 1 ){ // top
		ptDimLine = ptTR + (vxms + vyms) * dOffsetDimLine;
		lnProject = Line(ptTR, vxDimLine);
	}
	else if( nPosition == 2 ){ // left
		vxDimLine = vyms;
		vyDimLine = -vxms;
		lnProject = Line(ptBL, vxDimLine);
	}
	else if( nPosition == 3 ){ // right
		ptDimLine = ptTR + (vxms + vyms) * dOffsetDimLine;
	
		vxDimLine = vyms;
		vyDimLine = -vxms;
		
		lnProject = Line(ptTR, vxDimLine);
	}
	
	arPtDim = lnProject.projectPoints(arPtDim);
	arPtDim = lnProject.orderPoints(arPtDim);

	if( arPtDim.length() < 3 )
		return;
	
	DimLine dimLine(ptDimLine, vxDimLine, vyDimLine);
	Dim dimTotal(dimLine, arPtDim, "<>", "<>", nDimLayoutDelta,nDimLayoutCum);
	dimTotal.transformBy(ms2ps);
	dimTotal.setReadDirection(-_XW + _YW);
	dimTotal.setDeltaOnTop(nDeltaOnTop);
	dpDim.draw(dimTotal);
	
	Point3d ptDimName = arPtDim[arPtDim.length() - 1];
	if( nSideDescription == _kLeft )
		ptDimName = arPtDim[0];
	ptDimName += nSideDescription * vxDimLine * dOffsetText;
	ptDimName += vyDimLine * vyDimLine.dotProduct(ptDimLine - ptDimName);
	ptDimName.transformBy(ms2ps);
	
	Vector3d vxDimLinePS = vxDimLine;
	vxDimLinePS.transformBy(ms2ps);
	vxDimLinePS.normalize();
	
	Vector3d vyDimLinePS = vyDimLine;
	vyDimLinePS.transformBy(ms2ps);
	vyDimLinePS.normalize();
	
	dpDim.draw(sDescription, ptDimName, vxDimLinePS, vyDimLinePS, nSideDescription, 1);
}






















#End
#BeginThumbnail
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
&****`/_9
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
  <lst nm="TslInfo">
    <lst nm="TSLINFO">
      <lst nm="TSLINFO" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End