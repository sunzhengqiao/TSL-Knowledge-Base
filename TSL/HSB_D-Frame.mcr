#Version 8
#BeginDescription
Last modified by: Anno Sportel (support.nl@hsbcad.com)
30.07.2018 - version 1.10
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

/// <summary Lang=en>
/// 
/// </summary>

/// <insert>
/// 
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.10" date="30.07.2018"></version>

/// <history>
/// AS - 1.00 - 29.10.2012 -	First revision
/// AS - 1.01 - 06.11.2012 -	Find intersecting beams on reference side
/// AS - 1.02 - 14.12.2012 -	Set readdirection to: -xw + 2 * _yw
/// AS - 1.03 - 10.01.2013 -	Add kingstud as frame beam. Dimstyle and linetype are now sorted in the opm pulldown
/// AS - 1.04 - 10.01.2013 -	Add support for angle
/// AS - 1.05 - 13.02.2013 -	Add ID's as frame beams
/// AS - 1.06 - 13.03.2015 -	Performance improvements. Do vector check instead of type check on angled plates. (FogBugzId 951)
/// AS - 1.07 - 24.07.2015 -	Add opening beams as frame beams
/// AS - 1.08 - 24.12.2015 - 	Name and description exposed as settings.
/// DR - 1.09 - 28.06.2018 -	Added use of HSB_G-FilterGenBeams.mcr
/// AS - 1.10 - 30.07.2018 -	Seperate filter properties used as an override on the definition. Add option to dimension only minimum frame.
/// </history>

double dEps = Unit(0.01, "mm");

String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};

String arSPosition[] = {
	T("|Vertical left|"),
	T("|Vertical right|"),
	T("|Horizontal bottom|"),
	T("|Horizontal top|"),
	T("|Angled|")
 };

String arSDimObject[] = {
	T("|Frame|"),
	T("|Angled segments|"),
	T("|Angles|")
};

String arSFrameSide[] = {T("|Inside|"), T("|Outside|")};

//Used as a reference
String arSReference[] = {
	T("|No reference|"), 
	T("|Frame|")
};
String arSDimSide[]={T("|Left|"),T("|Right|"), T("|Left| & ") + T("|Right|")};
int arNDimSide[]={_kLeft, _kRight, _kLeftAndRight};

/// - Filter -
///
PropString sSeperator01(0, "", T("|Filter|"));
sSeperator01.setReadOnly(true);

String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = TslInst().getListOfCatalogNames(filterDefinitionTslName);
filterDefinitions.insertAt(0, "");

PropString genBeamFilterDefinition(24, filterDefinitions, "     "+T("|Filter definition for GenBeams|"));
genBeamFilterDefinition.setDescription(T("|Filter definition for GenBeams.|") + T(" (|Will be combined with custom filters|)") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));

PropString sFilterBC(1,"","     "+T("|Filter beams with beamcode|"));
PropString sFilterLabel(2,"","     "+T("|Filter beams and sheets with label|"));
PropString sFilterMaterial(3,"","     "+T("|Filter beams and sheets with material|"));
PropString sFilterHsbID(4,"","     "+T("|Filter beams and sheets with hsbID|"));

/// - Frame -
/// 
PropString sSeperator02(5, "", T("|Frame|"));
sSeperator02.setReadOnly(true);
PropString sDimObject(6, arSDimObject, "     "+T("|Dimension object|"));
PropString sFrameSide(7, arSFrameSide, "     "+T("|Frame side|"));
PropString useMinimumFrameProp(25, arSYesNo, "     " + T("|Use minimum frame|"), 0);
useMinimumFrameProp.setDescription(T("|Specifies whether the minimum, or the entire, frame is dimensioned|") + 
								   TN("|The beams included in the minimum frame are the vertical beams and the beams connected to these vertical beams.|"));
PropString sDrawOutline(8, arSYesNo, "     "+T("|Draw outline|"));
PropDouble dRange(0, U(0), "     "+T("|Range|"));

/// - Angle -
/// 
PropString sSeperator06(18, "", T("|Angle|"));
sSeperator06.setReadOnly(true);
PropDouble dAngSize(2, U(15), "     "+T("|Angle size|"));
PropDouble dDotArcSize(3, U(0.4), "     "+T("|Dot size|"));

/// - Positioning -
///
PropString sSeperator03(9, "", T("|Positioning|"));
sSeperator03.setReadOnly(true);
PropString sPosition(10, arSPosition, "     "+T("|Position|"));
PropString sUsePSUnits(11, arSYesNo, "     "+T("|Offset in paperspace units|"),1);
PropDouble dDimOff(1, U(100), "     "+T("|Offset dimension line|"));
PropInt nNrOfDimPointsRequired(1, 2, "     "+T("|Minimum points required|"));
PropDouble dAngOffset(4, U(0), "     "+T("|Offset angle|"));

/// - Style -
/// 
PropString sSeperator04(12, "", T("|Style|"));
sSeperator04.setReadOnly(true);
PropInt nColorDimension(0, -1, "     "+T("|Color dimension|"));
PropString sDimStyle(13, _DimStyles, "     "+T("|Dimension style|"));
PropInt nColorOutline(2, -1, "     "+T("|Color outline|"));
PropString sLineTypeOutline(14, _LineTypes, "     "+T("|Linetype outline|"));
PropInt nColorArc(3, 1, "     "+T("|Color arc|"));


/// - Reference -
/// 
PropString sSeperator05(15, "", T("|Reference|"));
sSeperator05.setReadOnly(true);
PropString sReference(16,arSReference,"     "+T("|Reference object|"));
PropString sDimSideRef(17,arSDimSide,"     "+T("|Reference side|"));


/// - Name and description -
/// 
PropString sSeperator14(23, "", T("|Name and description|"));
sSeperator14.setReadOnly(true);

PropInt nColorName(3, -1, "     "+T("|Default name color|"));
PropInt nColorActiveFilter(4, 30, "     "+T("|Filter other element color|"));
PropInt nColorActiveFilterThisElement(5, 1, "     "+T("|Filter this element color|"));
PropString sDimStyleName(19, _DimStyles, "     "+T("|Dimension style name|"));
PropString sInstanceDescription(20, "", "     "+T("|Extra description|"));
PropString sDisableTsl(21, arSYesNo, "     "+T("|Disable the tsl|"),1);
PropString sShowVpOutline(22, arSYesNo, "     "+T("|Show viewport outline|"),1);


/// - Triggers -
///
String arSTrigger[] = {
	T("|Filter this element|"),
	"     ----------",
	T("|Remove filter for this element|"),
	T("|Remove filter for all elements|")
};
for( int i=0;i<arSTrigger.length();i++ )
	addRecalcTrigger(_kContext, arSTrigger[i] );


if( _bOnInsert ){
	  showDialogOnce();
	
	Viewport vp = getViewport(T("|Select a viewport|")); // select viewport
	_Viewport.append(vp);
	_Pt0 = getPoint(T("|Select a position|"));
	
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

// Add filter
if( _kExecuteKey == arSTrigger[0] ){
	Map mapFilterElements;
	if( _Map.hasMap("FilterElements") )
		mapFilterElements = _Map.getMap("FilterElements");
	
	mapFilterElements.setString(el.handle(), "Element Filter");
	_Map.setMap("FilterElements", mapFilterElements);
}

// Remove single filter
if( _kExecuteKey == arSTrigger[2] ){
	Map mapFilterElements;
	if( _Map.hasMap("FilterElements") ){
		mapFilterElements = _Map.getMap("FilterElements");
		
		if( mapFilterElements.hasString(el.handle()) )
			mapFilterElements.removeAt(el.handle(), true);
		_Map.setMap("FilterElements", mapFilterElements);
	}
}

// Remove all filter
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

CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

Vector3d vxps = _XW;
Vector3d vyps = _YW;
Vector3d vzps = _ZW;
Vector3d vx = vxps;
vx.transformBy(ps2ms);
vx.normalize();
Vector3d vy = vyps;
vy.transformBy(ps2ms);
vy.normalize();
Vector3d vz = vzps;
vz.transformBy(ps2ms);
vz.normalize();

Line lnX(ptEl, vx);
Line lnY(ptEl, vy);

Display dp(nColorDimension);
dp.dimStyle(sDimStyle, dVpScale);

Display dpOutline(nColorOutline);
dpOutline.lineType(sLineTypeOutline);

Display dpArc(nColorArc);

 
int nDimObject = arSDimObject.find(sDimObject,0);
int bDrawOutline = arNYesNo[arSYesNo.find(sDrawOutline, 0)];

int nPosition = arSPosition.find(sPosition, 0); // 0 = angled; 1 = straight; 2 = both
int bUsePSUnits = arNYesNo[arSYesNo.find(sUsePSUnits,1)];
int useMinimumFrame = arNYesNo[arSYesNo.find(useMinimumFrameProp, 0)];

double dOffsetDim = dDimOff;
double dOffsetAngle = dAngOffset;
double dAngleSize = dAngSize;
double dDotSize = dDotArcSize;
if( bUsePSUnits )
{
	dOffsetDim *= dVpScale;
	dOffsetAngle *= dVpScale;
}
else
{
	dAngleSize /= dVpScale;
	dDotSize /= dVpScale;
}

int nFrameSide = arSFrameSide.find(sFrameSide,0); // 0 = inside; 1 = outside

int nReference = arSReference.find(sReference, 0);
int nDimSideRef = arNDimSide[arSDimSide.find(sDimSideRef,0)];

if( nDimObject == 0 && nPosition == 4 )
{
	reportMessage(T("|Invalid combination of| ")+T("'|Dimension object|'")+T(" |and| ")+T("'|Position|'"));
	return;
}

Beam arBm[0];
Sheet arSh[0];

Beam arBmFrame[0];
int arNBmTypeFrame[] = 
{
	_kDakLeftEdge,
	_kDakRightEdge,
	_kDakCenterJoist,
	_kRafter,
	_kExtraRafter,
	_kStud,
	_kSFStudLeft,
	_kSFStudRight,
	_kKingStud,
	_kSFJackOverOpening,
	_kSFJackUnderOpening,
	_kSFTransom,
	_kSill
};
String arSHsbIdFrame[] = 
{
	"41141",
	"41146"
};
	
//region filter genBeams (new)
GenBeam genBeams[] = el.genBeam();
Entity genBeamEntities[0];
for (int b = 0; b < genBeams.length(); b++)
{
	GenBeam genBeam = genBeams[b];
	if ( ! genBeam.bIsValid()) continue;
	
	genBeamEntities.append(genBeam);
}

Map filterGenBeamsMap;
filterGenBeamsMap.setEntityArray(genBeamEntities, false, "GenBeams", "GenBeams", "GenBeam");
int overrideFilterDefinition = false;
if (sFilterBC.length() > 0)
{
	filterGenBeamsMap.setString("BeamCode[]", sFilterBC);
	overrideFilterDefinition = true;
}
if (sFilterHsbID.length() > 0)
{
	filterGenBeamsMap.setString("HsbId[]", sFilterHsbID);
	overrideFilterDefinition = true;
}
if (sFilterLabel.length() > 0)
{
	filterGenBeamsMap.setString("Label[]", sFilterLabel);
	overrideFilterDefinition = true;
}
if (sFilterMaterial.length() > 0)
{
	filterGenBeamsMap.setString("Material[]", sFilterMaterial);
	overrideFilterDefinition = true;
}
if (overrideFilterDefinition)
{
	filterGenBeamsMap.setInt("Exclude", true);
}

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
//endregion

//internal filter (old)
Beam arBmAngledTP[0];

GenBeam arGBmAll[0]; arGBmAll.append(filteredGenBeams);
for( int i=0;i<arGBmAll.length();i++ ){
	GenBeam gBm = arGBmAll[i];
	
	//Exclude dummies
	if( gBm.bIsDummy() )
		continue;
	
	Beam bm = (Beam)gBm;
	Sheet sh = (Sheet)gBm;
	
	if( bm.bIsValid() ){
		int nType = bm.type();
		if( arNBmTypeFrame.find(nType) != -1 || arSHsbIdFrame.find(bm.hsbId()) != -1 )
		{
			arBmFrame.append(bm);
		}
		if( nType == _kSFAngledTPLeft || nType == _kSFAngledTPRight )
		{
			arBmAngledTP.append(bm);
		}
			
		arBm.append(bm);
	}
}

// Draw angle
if( nDimObject == 2 ){
	for( int i=0;i<arBmAngledTP.length();i++ ){
		Beam bm = arBmAngledTP[i];
		
		int nIsAngledLeft = 1;
		int bCWise = true;
		Vector3d vxBm = bm.vecX();
		if (vyEl.dotProduct(vxBm) < 0)
			vxBm *= -1;
		
		// This check does not work for mirrored elements. Replace with a vector check (FogBugzId 951)
		// if( bm.type() == _kSFAngledTPRight ){		
		if (vxEl.dotProduct(vxBm) < 0) {
			nIsAngledLeft *= -1;
			bCWise = false;
		}
		
		Vector3d vyBm = vzEl.crossProduct(vxBm);
		double dAngle = (nIsAngledLeft * vxEl).angleTo(vxBm);
		
		String sAngle;
		sAngle.formatUnit(dAngle, 2, 2);
		sAngle += "°";
		
		Point3d ptAngle = bm.ptCen() - vyBm * nIsAngledLeft * 0.5 * bm.dD(vyBm) + vxBm * dOffsetAngle;
		ptAngle.transformBy(ms2ps);
		Vector3d vxBmPS = vxBm;
		vxBmPS.transformBy(ms2ps);
		vxBmPS.normalize();
		
		//Angle
		Vector3d vAngleMid = (nIsAngledLeft * _XW).rotateBy(nIsAngledLeft * 0.5 * dAngle, _ZW);
		Point3d ptTxt = ptAngle + vAngleMid * 0.85 * dAngleSize;
		Vector3d vyTxt = vAngleMid;
		Vector3d vxTxt = vyTxt.crossProduct(_ZW);		
		dp.draw(sAngle, ptTxt, vxTxt, vyTxt, 0, 0);
		
		// Horizontal line
		PLine plHor(ptAngle, ptAngle + _XW * nIsAngledLeft * dAngleSize);
		dpOutline.draw(plHor);
		
		// Arc with dots
		Point3d ptArcStart = ptAngle + vxBmPS * 0.75 * dAngleSize;
		Point3d ptArcEnd = ptAngle + _XW * nIsAngledLeft * 0.75 * dAngleSize;
		PLine plArc(_ZW);
		plArc.addVertex(ptArcStart);
		plArc.addVertex(ptArcEnd, 0.75 * dAngleSize, bCWise, true);
		dpArc.draw(plArc);		
		PLine plArcStart(_ZW);
		plArcStart.createCircle(ptArcStart, _ZW, dDotSize);
		PlaneProfile ppArcStart(plArcStart);
		dpArc.draw(ppArcStart, _kDrawFilled);
		PLine plArcEnd(_ZW);
		plArcEnd.createCircle(ptArcEnd, _ZW, dDotSize);
		PlaneProfile ppArcEnd(plArcEnd);
		dpArc.draw(ppArcEnd, _kDrawFilled);
	}
	
	return;
}

/// - Analyze frame -
///
Beam arBmMainFrame[0];
arBmMainFrame.append(arBmFrame);
for( int i=0;i<arBmFrame.length();i++ ){
	Beam bmFrame = arBmFrame[i];
	
	Beam arBmNotThis[0];
	for( int j=0;j<arBm.length();j++ ){
		if( j==i )
			continue;
		Beam bm = arBm[j];
		
		if( abs(abs(bm.vecX().dotProduct(bmFrame.vecX())) - 1) < dEps )
			continue;
		
//		if( _bOnDebug ){
//			Body bd = bm.envelopeBody(true, true);
//			bd.transformBy(ms2ps);
//			bd.vis(5);
//		}
		
		arBmNotThis.append(bm);
	}
	Point3d ptBmFrame = bmFrame.ptCen() - vzEl * 0.95 * (0.5 - nFrameSide) * bmFrame.dD(vzEl);
	Point3d pbf = ptBmFrame;
	pbf.transformBy(ms2ps);
	pbf.vis(5);
	Beam arBmMin[] = Beam().filterBeamsHalfLineIntersectSort(arBmNotThis, ptBmFrame, bmFrame.vecX());
	if( _bOnDebug  && arBmMin.length() > 0 ){
		Body bd = arBmMin[0].envelopeBody(true, true);
		bd.transformBy(ms2ps);
		bd.vis(5);
	}
	if( arBmMin.length() > 0 && arBmMainFrame.find(arBmMin[0]) == -1 )
	{
		if (useMinimumFrame)
		{
			arBmMainFrame.append(arBmMin[0]);
		}
		else
		{
			arBmMainFrame.append(arBmMin);
		}
	}
	
	Beam arBmMax[] = Beam().filterBeamsHalfLineIntersectSort(arBmNotThis, ptBmFrame, -bmFrame.vecX());
	if( arBmMax.length() > 0 && arBmMainFrame.find(arBmMax[0]) == -1 )
	{
		if (useMinimumFrame)
		{
			arBmMainFrame.append(arBmMax[0]);
		}
		else
		{
			arBmMainFrame.append(arBmMax);
		}
	}
}

Point3d ptPlane = ptEl - vzEl * dEps;
if( nFrameSide == 0 )// 0 = inside; 1 = outside )
	ptPlane = ptEl - vzEl * (el.zone(0).dH() - dEps);

CoordSys csPlane(ptPlane, vxEl, vyEl, vzEl);
PlaneProfile ppFrame(csPlane);
for( int i=0;i<arBmMainFrame.length();i++ ){
	Beam bm = arBmMainFrame[i];

	PlaneProfile ppSlice(csPlane);
	ppSlice.unionWith(bm.envelopeBody(true, true).getSlice(Plane(ptPlane, vzEl)));
//	PLine arPlSlice[] = ppSlice.allRings();
//	for( int j=0;j<arPlSlice.length();j++ )
//		ppFrame.joinRing(arPlSlice[j], _kAdd);
	
	ppSlice.shrink(-dEps);
	int bUnioned = ppFrame.unionWith(ppSlice);
	
	ppSlice.transformBy(ms2ps);
	ppSlice.vis(4);
	
//	if( _bOnDebug ){
//		Body bd = bm.envelopeBody(true, true);
//		bd.transformBy(ms2ps);
//		bd.vis(2);
//	}
}
ppFrame.shrink(dEps);

Point3d arPtFrame[] = ppFrame.getGripVertexPoints();
Vector3d arVSort[] = {
	vxEl,
	vyEl
};
for( int i=0;i<arVSort.length();i++ ){
	Vector3d vSort = arVSort[i];
	Line lnSort(ptEl, vSort);
	
	Point3d arPtSorted[] = lnSort.orderPoints(arPtFrame);
	
	Point3d arPtMin[0];	
	for( int j=0;j<arPtSorted.length();j++ ){
		Point3d pt = arPtSorted[j];
		if( arPtMin.length() == 0 ){
			arPtMin.append(pt);
			continue;
		}
		if( abs(vSort.dotProduct(pt - arPtMin[arPtMin.length() - 1])) > dEps )
			break;
		
		arPtMin.append(pt);
	}
	arPtMin = Line(ptEl, vzEl.crossProduct(vSort)).orderPoints(arPtMin);
	if( arPtMin.length() > 1 ){
		PLine plMin(arPtMin[0], arPtMin[arPtMin.length() - 1], arPtMin[arPtMin.length() - 1] + vSort * dEps, arPtMin[0] + vSort * dEps);
		plMin.close();
		ppFrame.joinRing(plMin, _kAdd);
	}
	
	Point3d arPtMax[0];
	for( int j=(arPtSorted.length() - 1);j>0;j-- ){
		Point3d pt = arPtSorted[j];
		if( arPtMax.length() == 0 ){
			arPtMax.append(pt);
			continue;
		}
		if( abs(vSort.dotProduct(pt - arPtMax[arPtMax.length() - 1])) > dEps )
			break;
		
		arPtMax.append(pt);
	}
	arPtMax = Line(ptEl, vzEl.crossProduct(vSort)).orderPoints(arPtMax);
	if( arPtMax.length() > 1 ){
		PLine plMax(arPtMax[0], arPtMax[0] - vSort * dEps, arPtMax[arPtMax.length() - 1] - vSort * dEps, arPtMax[arPtMax.length() - 1]);
		plMax.close();
		ppFrame.joinRing(plMax, _kAdd);
	}
}

PlaneProfile ppFrameOutline(csPlane);
PLine arPlFrame[] = ppFrame.allRings();
int arBRingIsOpening[] = ppFrame.ringIsOpening();
for( int i=0;i<arPlFrame.length();i++ ){
	int bRingIsOpening = arBRingIsOpening[i];
	if( bRingIsOpening )
		continue;
	
	PLine plFrame = arPlFrame[i];
	ppFrameOutline.joinRing(plFrame, _kAdd);
}

if( bDrawOutline ){
	ppFrameOutline.shrink(-U(5));
	ppFrameOutline.shrink(U(5));
	
	PlaneProfile ppFrameOutlinePS = ppFrameOutline;
	ppFrameOutlinePS.transformBy(ms2ps);
	dpOutline.draw(ppFrameOutlinePS);
}

if( _bOnDebug ){
	PlaneProfile ppFrameOutlinePS = ppFrameOutline;
	ppFrameOutlinePS.transformBy(ms2ps);
	ppFrameOutlinePS.vis(1);
}

/// - Reference points -
Point3d arPtFrameReference[] = ppFrameOutline.getGripVertexPoints();
Point3d arPtFrameReferenceX[] = lnX.orderPoints(arPtFrameReference);
Point3d arPtFrameReferenceY[] = lnY.orderPoints(arPtFrameReference);
if( arPtFrameReferenceX.length() * arPtFrameReferenceY.length() == 0 )
	return;
Point3d ptLeft = arPtFrameReferenceX[0];
Point3d ptRight = arPtFrameReferenceX[arPtFrameReferenceX.length() - 1];
Point3d ptBottom = arPtFrameReferenceY[0];
Point3d ptTop = arPtFrameReferenceY[arPtFrameReferenceY.length() - 1];
Point3d ptBL = ptLeft + vy * vy.dotProduct(ptBottom - ptLeft);
Point3d ptBR = ptRight + vy * vy.dotProduct(ptBottom - ptRight);
Point3d ptTR = ptRight + vy * vy.dotProduct(ptTop - ptRight);
Point3d ptTL = ptLeft + vy * vy.dotProduct(ptTop - ptLeft);

Point3d arPtRefToDim[0];
if( nReference == 1 && nPosition < 4 ){
	if( nDimSideRef == _kLeft || nDimSideRef == _kLeftAndRight )
		arPtRefToDim.append(ptBL);
	if( nDimSideRef == _kRight || nDimSideRef == _kLeftAndRight )
		arPtRefToDim.append(ptTR);
}


/// - Dimension the frame outline
///

int arNIndexLeftSegment[] = {0,1,7};
Point3d arPtDimLeft[0];
int arNIndexBottomSegment[] = {1,2,3};
Point3d arPtDimBottom[0];
int arNIndexRightSegment[] = {3,4,5};
Point3d arPtDimRight[0];
int arNIndexTopSegment[] = {5,6,7};
Point3d arPtDimTop[0];

int arNIndexAngledSegment[] = {1,3,5,7};
PLine arPlFrameOutline[] = ppFrameOutline.allRings();
for( int i=0;i<arPlFrameOutline.length();i++ ){
	PLine plFrameOutline = arPlFrameOutline[i];		
	Point3d arPtFrameOutline[] = plFrameOutline.vertexPoints(false);	
	if( arPtFrameOutline.length() < 2 )
		continue;
	
	// Check direction of pline
	for( int j=0;j<(arPtFrameOutline.length() - 1);j++ ){
		Point3d ptThis = arPtFrameOutline[j];
		Point3d ptNext = arPtFrameOutline[j+1];
		Point3d ptMidEdge = (ptThis + ptNext)/2;
		
		Vector3d vEdge(ptNext - ptThis);
		if( vEdge.length() < U(5) )
			continue;
		vEdge.normalize();
		Vector3d vPerp = vz.crossProduct(vEdge);
		
		ppFrameOutline.vis(1);
		ptMidEdge.vis(5);		
		if( ppFrameOutline.pointInProfile(ptMidEdge + vPerp) == _kPointInProfile ){
			plFrameOutline.reverse();
			arPtFrameOutline = plFrameOutline.vertexPoints(false);	
			if( arPtFrameOutline.length() < 2 )
				continue;
		}
		break;
	}
	
	for( int j=0;j<(arPtFrameOutline.length() - 1);j++ ){
		Point3d ptThis = arPtFrameOutline[j];
		Point3d ptNext = arPtFrameOutline[j + 1];
		Point3d ptMidEdge = (ptThis + ptNext)/2;
		
		Vector3d vEdge(ptNext - ptThis);
		if( vEdge.length() < U(5) )
			continue;
		vEdge.normalize();
		Vector3d vPerp = vz.crossProduct(vEdge);
		
		if( _bOnDebug ){
			Vector3d v = vPerp;
			v.transformBy(ms2ps);
			Point3d p = ptMidEdge;
			p.transformBy(ms2ps);
			
			v.vis(p,150);
		}
		
		double dxPerp = vx.dotProduct(vPerp);
		double dyPerp = vy.dotProduct(vPerp);
		int bEdgeIsAngled = true;
		if( abs(dxPerp) < dEps || abs(dyPerp) < dEps )
			bEdgeIsAngled = false;
		
		int nSegmentIndex = -1;
		if( dxPerp > dEps ){ //right
			if( dyPerp > dEps ) //top-right
				nSegmentIndex = 5;
			else if( abs(dyPerp) < dEps ) //right
				nSegmentIndex = 4;
			else // bottom right
				nSegmentIndex = 3;
		}
		else if( abs(dxPerp) < dEps ){
			if( dyPerp > dEps ) //top
				nSegmentIndex = 6;
			else //bottom
				nSegmentIndex = 2;
		}
		else{
			if( dyPerp > dEps ) //top-left
				nSegmentIndex = 7;
			else if( abs(dyPerp) < dEps ) //left
				nSegmentIndex = 0;
			else // bottom left
				nSegmentIndex = 1;
		}
		
		if( nDimObject == 0 ){
			if( arNIndexLeftSegment.find(nSegmentIndex) != -1 ){
				arPtDimLeft.append(ptThis);
				arPtDimLeft.append(ptNext);
			}
			if( arNIndexBottomSegment.find(nSegmentIndex) != -1 ){
				arPtDimBottom.append(ptThis);
				arPtDimBottom.append(ptNext);
			}
			if( arNIndexRightSegment.find(nSegmentIndex) != -1 ){
				arPtDimRight.append(ptThis);
				arPtDimRight.append(ptNext);
			}
			if( arNIndexTopSegment.find(nSegmentIndex) != -1 ){
				arPtDimTop.append(ptThis);
				arPtDimTop.append(ptNext);
			}
		}
		else if( nDimObject == 1 ){
			if( arNIndexAngledSegment.find(nSegmentIndex) != -1 ){
				Vector3d vxDim = vEdge;
				Vector3d vyDim = vz.crossProduct(vxDim);
									
				Point3d ptDim = ptThis + vPerp * dOffsetDim;
			
				Point3d arPtDim[0];
				if( nPosition == 4 ){
					arPtDim.append(ptThis);
					arPtDim.append(ptNext);
				}
				if( nPosition == 0 && arNIndexLeftSegment.find(nSegmentIndex) != -1 ){
					arPtDim.append(ptThis);
					arPtDim.append(ptNext);

					vxDim = vy;
					vyDim = -vx;
					ptDim = ptBL + vyDim * dOffsetDim;
				}
				else if( nPosition == 1 && arNIndexRightSegment.find(nSegmentIndex) != -1 ){
					arPtDim.append(ptThis);
					arPtDim.append(ptNext);

					vxDim = vy;
					vyDim = -vx;
					ptDim = ptTR - vyDim * dOffsetDim;
				}
				else if( nPosition == 2 && arNIndexBottomSegment.find(nSegmentIndex) != -1 ){
					arPtDim.append(ptThis);
					arPtDim.append(ptNext);

					vxDim = vx;
					vyDim = vy;
					ptDim = ptBL - vyDim * dOffsetDim;
				}
				else if( nPosition == 3 && arNIndexTopSegment.find(nSegmentIndex) != -1 ){
					arPtDim.append(ptThis);
					arPtDim.append(ptNext);

					vxDim = vx;
					vyDim = vy;
					ptDim = ptTR + vyDim * dOffsetDim;
				}
									
				if( arPtDim.length() < nNrOfDimPointsRequired )
					return;

				if( nPosition != 4 )
					arPtDim.append(arPtRefToDim);
				
				DimLine dimLine(ptDim, vxDim, vyDim);
				Dim dim(dimLine, arPtDim, "<>", "<>", _kDimPar);
				dim.transformBy(ms2ps);
				dim.setReadDirection(-_XW + 2 * _YW);
				dp.draw(dim);
			}
		}
/*		
		if( !bEdgeIsAngled && nPosition == 0 )
			continue;
		if( bEdgeIsAngled && nPosition == 1 )
			continue;
		
		Point3d ptOnZoneOutline = ppZoneOutline.closestPointTo(ptMidEdge);
		
		if( abs(vPerp.dotProduct(ptOnZoneOutline - ptMidEdge)) < U(0.1) )
			continue;
		
		if( abs(vEdge.dotProduct(ptOnZoneOutline - ptMidEdge)) > dEps )
			continue;
		
		Point3d arPtDim[] = {
			ptMidEdge,
			ptOnZoneOutline
		};
				
		// Check orientation of dimline
		Vector3d vxDim = vPerp;
		Vector3d vxDimPS = vxDim;
		vxDimPS.transformBy(ms2ps);
		if( vxDimPS.dotProduct(_XW) < 0 )
			vxDimPS *= -1;
		Vector3d vyDimPS = _ZW.crossProduct(vxDimPS);
		vxDim = vxDimPS;
		vxDim.transformBy(ps2ms);
		vxDim.normalize();
		Vector3d vyDim = vyDimPS;
		vyDim.transformBy(ps2ms);
		vyDim.normalize();
		
		Point3d ptDim = ptOnZoneOutline + vyDim * dOffsetDim;
		
		DimLine dimLine(ptDim, vxDim, vyDim);
		Dim dim(dimLine, arPtDim, sPrefix + "<>" + sSuffix, "<>", _kDimPar);
		dim.transformBy(ms2ps);
		dim.setReadDirection(-_XW + _YW);
		dp.draw(dim);
*/
	}
}

if( nDimObject == 0 ){
	Vector3d vxDim = vy;
	Vector3d vyDim = -vx;
	Point3d ptReference = ptLeft;
	Point3d ptDim = ptLeft + vyDim * dOffsetDim;

	Point3d arPtDim[0];
	if( nPosition == 0 ){
		arPtDim.append(arPtDimLeft);
	}
	else if( nPosition == 1 ){
		ptReference = ptRight;
		ptDim = ptRight - vyDim * dOffsetDim;

		arPtDim.append(arPtDimRight);
	}
	else if( nPosition == 2 ){
		ptReference = ptBottom;
		vxDim = vx;
		vyDim = vy;	
		ptDim = ptBottom - vyDim * dOffsetDim;

		arPtDim.append(arPtDimBottom);
	}
	else if( nPosition == 3 ){
		ptReference = ptTop;
		vxDim = vx;
		vyDim = vy;	
		ptDim = ptTop + vyDim * dOffsetDim;

		arPtDim.append(arPtDimTop);
	}
	
	if( dRange > 0 ){
		Point3d arPtTmp[0];
		for( int i=0;i<arPtDim.length();i++ ){
			Point3d pt = arPtDim[i];
			if( abs(vyDim.dotProduct(pt - ptReference)) > dRange )
				continue;
			
			arPtTmp.append(pt);
		}
		arPtDim.setLength(0);
		arPtDim.append(arPtTmp);
	}
	if( arPtDim.length() < nNrOfDimPointsRequired )
		return;
	
	arPtDim.append(arPtRefToDim);
	
	DimLine dimLine(ptDim, vxDim, vyDim);
	Dim dim(dimLine, arPtDim, "<>", "<>", _kDimPar);
	dim.transformBy(ms2ps);
	dim.setReadDirection(-_XW + 2 * _YW);
	dp.draw(dim);
}








#End
#BeginThumbnail









#End
#BeginMapX

#End