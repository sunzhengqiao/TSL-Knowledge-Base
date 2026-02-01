#Version 8
#BeginDescription
Last modified by: David Rueda (david.rueda@hsbcad.com)
03.07.2018 - version 2.03
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 3
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

/// <version  value="2.02" date="20.07.2017"></version>

/// <history>
/// AS - 1.00 - 29.05.2012 -	First revision
/// AS - 1.01 - 01.06.2012 -	Add frame as reference
/// AS - 1.02 - 01.06.2012 -	Add prefix & suffix
/// AS - 2.00 - 26.06.2017 -	Add option for angled dimensions. Add catagories.
/// AS - 2.01 - 20.07.2017 -	Fix cleanup of outline.
/// AS - 2.02 - 20.07.2017 -	Correct counter issue.
/// DR - 2.03 - 03.07.2018 - 	Added use of HSB_G-FilterGenBeams.mcr
///

double dEps = Unit(0.01, "mm");

String categories[] = 
{
	T("|Filter|"),
	T("|Dimension object|"),
	T("|Positioning|"),
	T("|Style|"),
	T("|Reference|"),
	T("|Name and description|")
};


String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};

int arNZone[] = {1,2,3,4,5,6,7,8,9,10};

String arSPosition[] = 
{
	T("|Angled aligned|"),
	T("|Angled Perpendicular|"),
	T("|Straight|")
};

String arSReferenceSide[] = {T("|Inside|"), T("|Outside|")};



/// - Filter -
///
String category = categories[0];

String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = TslInst().getListOfCatalogNames(filterDefinitionTslName);
filterDefinitions.insertAt(0, "");
PropString genBeamFilterDefinition(15, filterDefinitions, T("|Filter definition for GenBeams|"));
genBeamFilterDefinition.setDescription(T("|Filter definition for GenBeams.|") + T(" (|Will be combined with custom filters|)") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));
genBeamFilterDefinition.setCategory(category);

PropString sFilterBC(0,"", T("|Filter beams with beamcode|"));
sFilterBC.setCategory(category);
PropString sFilterLabel(1,"", T("|Filter beams and sheets with label|"));
sFilterLabel.setCategory(category);
PropString sFilterMaterial(2,"", T("|Filter beams and sheets with material|"));
sFilterMaterial.setCategory(category);
PropString sFilterHsbID(3,"", T("|Filter beams and sheets with hsbID|"));
sFilterHsbID.setCategory(category);

/// - Dimension object -
/// 
category = categories[1];
PropInt nZone(0, arNZone,  T("|Zone|"));
nZone.setCategory(category);
PropString sDrawOutline(4, arSYesNo,  T("|Draw outline|"));
sDrawOutline.setCategory(category);

/// - Positioning -
///
category = categories[2];
PropString sPosition(5, arSPosition,  T("|Position|"));
sPosition.setCategory(category);
PropString sUsePSUnits(6, arSYesNo,  T("|Offset in paperspace units|"),1);
sUsePSUnits.setCategory(category);
PropDouble dDimOff(0, U(100),  T("|Offset dimension line|"));
dDimOff.setCategory(category);

/// - Style -
/// 
category = categories[3];
PropInt nColorDimension(1, -1,  T("|Color dimension|"));
nColorDimension.setCategory(category);
PropString sDimStyle(7, _DimStyles,  T("|Dimension style|"));
sDimStyle.setCategory(category);
PropInt nColorOutline(2, -1,  T("|Color outline|"));
nColorOutline.setCategory(category);
PropString sLineTypeOutline(8, _LineTypes,  T("|Linetype outline|"));
sLineTypeOutline.setCategory(category);
PropString sPrefix(9, "",  T("|Prefix|"));
sPrefix.setCategory(category);
PropString sSuffix(10, "",  T("|Suffix|"));
sSuffix.setCategory(category);


/// - Reference -
///
category = categories[4];
PropString sReferenceSide(11, arSReferenceSide,  T("|Reference side frame|"));
sReferenceSide.setCategory(category);


/// - Name and Description
///
category = categories[5];
PropInt nColorName(3, -1,  T("|Default name color|"));
PropInt nColorActiveFilter(4, 30,  T("|Filter other element color|"));
PropInt nColorActiveFilterThisElement(5, 1,  T("|Filter this element color|"));
PropString sDimStyleName(12, _DimStyles,  T("|Dimension style name|"));
PropString sInstanceDescription(13, "",  T("|Extra description|"));
PropString sDisableTsl(14, arSYesNo,  T("|Disable the tsl|"),1);


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

// Draw name
String sInstanceNameAndDescription = _ThisInst.scriptName();
if( sInstanceDescription.length() > 0 )
	sInstanceNameAndDescription += (" - "+sInstanceDescription);

Display dpName(nColorName);
dpName.dimStyle(sDimStyleName);
dpName.draw(sInstanceNameAndDescription, _Pt0, _XW, _YW, 1, 2);

double dTextHeightName = dpName.textHeightForStyle("HSB", sDimStyleName);

Viewport vp = _Viewport[0];
Element el = vp.element();


CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps
double dVpScale = ps2ms.scale();

int bDisableTsl = arNYesNo[arSYesNo.find(sDisableTsl,1)];
if( bDisableTsl ){
	dpName.color(nColorActiveFilterThisElement);
	dpName.draw(_ThisInst.scriptName(), _Pt0, _XW, _YW, 1, 2);
	dpName.textHeight(0.5 * dTextHeightName);
	dpName.draw(T("|Disbled|"), _Pt0, _XW, _YW, 1, 1);
	return;
}

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

CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

Display dp(nColorDimension);
dp.dimStyle(sDimStyle, dVpScale);

Display dpOutline(nColorOutline);
dpOutline.lineType(sLineTypeOutline);


// Resolve properties
String sFBC = sFilterBC + ";";
sFBC.makeUpper();
String arSExcludeBC[0];
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
	arSExcludeBC.append(sTokenBC);
}
String sFLabel = sFilterLabel + ";";
sFLabel.makeUpper();
String arSExcludeLbl[0];
int nIndexLabel = 0; 
int sIndexLabel = 0;
while(sIndexLabel < sFLabel.length()-1){
	String sTokenLabel = sFLabel.token(nIndexLabel);
	nIndexLabel++;
	if(sTokenLabel.length()==0){
		sIndexLabel++;
		continue;
	}
	sIndexLabel = sFLabel.find(sTokenLabel,0);

	arSExcludeLbl.append(sTokenLabel);
}
String sFMaterial = sFilterMaterial + ";";
sFMaterial.makeUpper();
String arSExcludeMat[0];
int nIndexMaterial = 0; 
int sIndexMaterial = 0;
while(sIndexMaterial < sFMaterial.length()-1){
	String sTokenMaterial = sFMaterial.token(nIndexMaterial);
	nIndexMaterial++;
	if(sTokenMaterial.length()==0){
		sIndexMaterial++;
		continue;
	}
	sIndexMaterial = sFMaterial.find(sTokenMaterial,0);

	arSExcludeMat.append(sTokenMaterial);
}

String sFHsbId = sFilterHsbID + ";";
sFHsbId.makeUpper();
String arSExcludeHsbId[0];
int nIndexHsbId = 0; 
int sIndexHsbId = 0;
while(sIndexHsbId < sFHsbId.length()-1){
	String sTokenHsbId = sFHsbId.token(nIndexHsbId);
	nIndexHsbId++;
	if(sTokenHsbId.length()==0){
		sIndexHsbId++;
		continue;
	}
	sIndexHsbId = sFHsbId.find(sTokenHsbId,0);

	arSExcludeHsbId.append(sTokenHsbId);
}

int bDrawOutline = arNYesNo[arSYesNo.find(sDrawOutline, 0)];
int nZn = nZone;
if( nZn > 5 )
	nZn = 5 - nZone;

int nPosition = arSPosition.find(sPosition, 0); // 0 = angled aligned; 1=angled perpendicular; 2 = straight
int bUsePSUnits = arNYesNo[arSYesNo.find(sUsePSUnits,1)];
double dOffsetDim = dDimOff;
if( bUsePSUnits )
	dOffsetDim *= dVpScale;

int nReferenceSide = arSReferenceSide.find(sReferenceSide,0); // 0 = inside; 1 = outside


Beam arBm[0];
Sheet arSh[0];

Beam arBmFrame[0];
int arNBmTypeFrame[] = {
	_kDakLeftEdge,
	_kDakRightEdge,
	_kDakCenterJoist,
	_kRafter,
	_kExtraRafter,
	_kStud,
	_kSFStudLeft,
	_kSFStudRight
};

Sheet arShZn[0];
PlaneProfile ppZoneOutline(el.zone(nZn).coordSys());

//region filter genBeams (new)
GenBeam genBeams[] = el.genBeam();
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
//endregion

GenBeam arGBmAll[0]; arGBmAll.append(filteredGenBeams);
for( int i=0;i<arGBmAll.length();i++ ){
	GenBeam gBm = arGBmAll[i];
	
	int bExcludeGenBeam = false;
	
	//Exclude dummies
	if( gBm.bIsDummy() )
		continue;
	
	//Exclude labels
	String sLabel = gBm.label().makeUpper();
	sLabel.trimLeft();
	sLabel.trimRight();
	if( arSExcludeLbl.find(sLabel)!= -1 ){
		bExcludeGenBeam = true;
	}
	else{
		for( int j=0;j<arSExcludeLbl.length();j++ ){
			String sExclLbl = arSExcludeLbl[j];
			String sExclLblTrimmed = sExclLbl;
			sExclLblTrimmed.trimLeft("*");
			sExclLblTrimmed.trimRight("*");
			if( sExclLblTrimmed == "" )
				continue;
			if( sExclLbl.left(1) == "*" && sExclLbl.right(1) == "*" && sLabel.find(sExclLblTrimmed, 0) != -1 )
				bExcludeGenBeam = true;
			else if( sExclLbl.left(1) == "*" && sLabel.right(sExclLbl.length() - 1) == sExclLblTrimmed )
				bExcludeGenBeam = true;
			else if( sExclLbl.right(1) == "*" && sLabel.left(sExclLbl.length() - 1) == sExclLblTrimmed )
				bExcludeGenBeam = true;
		}
	}
	if( bExcludeGenBeam )
		continue;
	
	//Exclude material
	String sMaterial = gBm.material().makeUpper();
	sMaterial.trimLeft();
	sMaterial.trimRight();
	if( arSExcludeMat.find(sMaterial)!= -1 ){
		bExcludeGenBeam = true;
	}
	else{
		for( int j=0;j<arSExcludeMat.length();j++ ){
			String sExclMat = arSExcludeMat[j];
			String sExclMatTrimmed = sExclMat;
			sExclMatTrimmed.trimLeft("*");
			sExclMatTrimmed.trimRight("*");
			if( sExclMatTrimmed == "" )
				continue;
			if( sExclMat.left(1) == "*" && sExclMat.right(1) == "*" && sMaterial.find(sExclMatTrimmed, 0) != -1 )
				bExcludeGenBeam = true;
			else if( sExclMat.left(1) == "*" && sMaterial.right(sExclMat.length() - 1) == sExclMatTrimmed )
				bExcludeGenBeam = true;
			else if( sExclMat.right(1) == "*" && sMaterial.left(sExclMat.length() - 1) == sExclMatTrimmed )
				bExcludeGenBeam = true;
		}
	}
	if( bExcludeGenBeam )
		continue;

	//Exclude hsbId
	String sHsbId = gBm.hsbId().makeUpper();
	sHsbId.trimLeft();
	sHsbId.trimRight();
	if( arSExcludeHsbId.find(sHsbId)!= -1 ){
		bExcludeGenBeam = true;
	}
	else{
		for( int j=0;j<arSExcludeHsbId.length();j++ ){
			String sExclHsbId = arSExcludeHsbId[j];
			String sExclHsbIdTrimmed = sExclHsbId;
			sExclHsbIdTrimmed.trimLeft("*");
			sExclHsbIdTrimmed.trimRight("*");
			if( sExclHsbIdTrimmed == "" )
				continue;
			if( sExclHsbId.left(1) == "*" && sExclHsbId.right(1) == "*" && sHsbId.find(sExclHsbIdTrimmed, 0) != -1 )
				bExcludeGenBeam = true;
			else if( sExclHsbId.left(1) == "*" && sHsbId.right(sExclHsbId.length() - 1) == sExclHsbIdTrimmed )
				bExcludeGenBeam = true;
			else if( sExclHsbId.right(1) == "*" && sHsbId.left(sExclHsbId.length() - 1) == sExclHsbIdTrimmed )
				bExcludeGenBeam = true;
		}
	}
	if( bExcludeGenBeam )
		continue;

	
	//Exclude beamcodes
	String sBmCode = gBm.beamCode().token(0).makeUpper();
	sBmCode.trimLeft();
	sBmCode.trimRight();
	
	if( arSExcludeBC.find(sBmCode)!= -1 ){
		bExcludeGenBeam = true;
	}
	else{
		for( int j=0;j<arSExcludeBC.length();j++ ){
			String sExclBC = arSExcludeBC[j];
			String sExclBCTrimmed = sExclBC;
			sExclBCTrimmed.trimLeft("*");
			sExclBCTrimmed.trimRight("*");
			if( sExclBCTrimmed == "" )
				continue;
			if( sExclBC.left(1) == "*" && sExclBC.right(1) == "*" && sBmCode.find(sExclBCTrimmed, 0) != -1 )
				bExcludeGenBeam = true;
			else if( sExclBC.left(1) == "*" && sBmCode.right(sExclBC.length() - 1) == sExclBCTrimmed )
				bExcludeGenBeam = true;
			else if( sExclBC.right(1) == "*" && sBmCode.left(sExclBC.length() - 1) == sExclBCTrimmed )
				bExcludeGenBeam = true;
		}
	}
	if( bExcludeGenBeam )
		continue;
	
	Beam bm = (Beam)gBm;
	Sheet sh = (Sheet)gBm;
	
	if( bm.bIsValid() ){
		int nType = bm.type();
		if( arNBmTypeFrame.find(nType) != -1 )
			arBmFrame.append(bm);
			
		arBm.append(bm);
	}
	else if( sh.bIsValid() ){
		arSh.append(sh);
		
		if( sh.myZoneIndex() == nZn ){
			arShZn.append(sh);
			
			PlaneProfile sheetProfile = sh.profShape();
			sheetProfile.shrink(-U(10));
			
			ppZoneOutline.unionWith(sheetProfile);
		}
	}
}
ppZoneOutline.shrink(U(10));


if( bDrawOutline && arShZn.length() > 0 ){
	ppZoneOutline.shrink(-U(5));
	ppZoneOutline.shrink(U(5));
	
	PlaneProfile ppZoneOutlinePS = ppZoneOutline;
	ppZoneOutlinePS.transformBy(ms2ps);
	dpOutline.draw(ppZoneOutlinePS);
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
	Beam arBmMin[] = Beam().filterBeamsHalfLineIntersectSort(arBmNotThis, bmFrame.ptCen(), bmFrame.vecX());
//	if( _bOnDebug  && arBmMin.length() > 0 ){
//		Body bd = arBmMin[0].envelopeBody(true, true);
//		bd.transformBy(ms2ps);
//		bd.vis(5);
//	}
	if( arBmMin.length() > 0 && arBmMainFrame.find(arBmMin[0]) == -1 )
		arBmMainFrame.append(arBmMin[0]);
	
	Beam arBmMax[] = Beam().filterBeamsHalfLineIntersectSort(arBmNotThis, bmFrame.ptCen(), -bmFrame.vecX());
	if( arBmMax.length() > 0 && arBmMainFrame.find(arBmMax[0]) == -1 )
		arBmMainFrame.append(arBmMax[0]);
}

Point3d ptPlane = ptEl - vzEl * dEps;
if( nReferenceSide == 0 )// 0 = inside; 1 = outside )
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
	
	ppSlice.shrink(-U(300));//dEps);
	int bUnioned = ppFrame.unionWith(ppSlice);
	
	ppSlice.transformBy(ms2ps);
	ppSlice.vis(4);
	
//	if( _bOnDebug ){
//		Body bd = bm.envelopeBody(true, true);
//		bd.transformBy(ms2ps);
//		bd.vis(2);
//	}
}
ppFrame.shrink(U(300));//dEps);

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

if( _bOnDebug ){
	PlaneProfile ppFrameOutlinePS = ppFrameOutline;
	ppFrameOutlinePS.transformBy(ms2ps);
	ppFrameOutlinePS.vis(1);
}

if (nPosition == 0)
{
	Point3d zoneVertices[] = ppZoneOutline.getGripVertexPoints();
	ppZoneOutline.vis(1);
	
	Point3d cleanedUpVertices[0];
	Point3d previousVertex = zoneVertices[zoneVertices.length() - 1];
	cleanedUpVertices.append(previousVertex);
	previousVertex.vis(0);
	for( int k=0;k<(zoneVertices.length() - 1);k++ ){
		Point3d thisVertex = zoneVertices[k];
		Point3d nextVertex = zoneVertices[k+1];
				
		Vector3d previousToThis(thisVertex - previousVertex);
	
		if( previousToThis.length() < U(0.5) )
		{
//			if (k==(zoneVertices.length() - 2))
//				cleanedUpVertices.append(nextVertex);
			continue;
		}
		previousToThis.normalize();
		
		Vector3d vFromThis(nextVertex - thisVertex);
				
		if( vFromThis.length() < U(0.5) )
		{
//			if (k==(zoneVertices.length() - 2))
//				cleanedUpVertices.append(nextVertex);
			continue;
		}
		vFromThis.normalize();
	
		if( abs(previousToThis.dotProduct(vFromThis) - 1) < dEps )
		{
//			if (k==(zoneVertices.length() - 2))
//				cleanedUpVertices.append(nextVertex);
			continue;
		}
		
		previousVertex = thisVertex;
		previousVertex.vis(k);
		cleanedUpVertices.append(thisVertex);	
	}
	
	if (cleanedUpVertices.length() == 0)
		return;
	cleanedUpVertices.append(cleanedUpVertices[0]);
	
	for (int i=0;i<(cleanedUpVertices.length() - 1);i++)
	{
		Point3d from = cleanedUpVertices[i];
		Point3d to = cleanedUpVertices[i+1];
		Point3d mid = (from + to)/2;
		
		Vector3d direction(to - from);
		direction.normalize();
		
		double xPart = vxEl.dotProduct(direction);
		double yPart = vyEl.dotProduct(direction);
		
		Point3d dimensionPoints[] = 
		{
			from,
			to
		};
		
		if (abs(xPart) > dEps && abs(yPart) > dEps)
		{
			Vector3d normal = vzEl.crossProduct(direction);
			if (ppZoneOutline.pointInProfile(mid + normal) == _kPointInProfile)
			{
				direction *= -1;
				normal *= -1;
			}
			Vector3d dimX = direction;
			Vector3d dimY = vzEl.crossProduct(dimX);
			
			Point3d dimOrigin = from + dimY * dOffsetDim;
			
			dimensionPoints = Line(dimOrigin, dimX).projectPoints(dimensionPoints);
			
			
			DimLine dimLine(dimOrigin, dimX, dimY);
			Dim dim(dimLine, dimensionPoints, "<>", "<>", _kDimPar, _kDimNone);
			dim.transformBy(ms2ps);
			dim.setReadDirection(-_XW + _YW);
			dp.draw(dim);
		}
	}
}
else if (nPosition == 1 || nPosition == 2)
{
	PLine arPlFrameOutline[] = ppFrameOutline.allRings();
	for( int i=0;i<arPlFrameOutline.length();i++ ){
		PLine plFrameOutline = arPlFrameOutline[i];
		Point3d arPtFrameOutline[] = plFrameOutline.vertexPoints(false);
		if( arPtFrameOutline.length() < 2 )
			continue;
		
		// Check direction of pline
		Point3d thisVertex = arPtFrameOutline[0];
		Point3d nextVertex = arPtFrameOutline[1];
		Point3d ptMidEdge = (thisVertex + nextVertex)/2;
		
		Vector3d vEdge(nextVertex - thisVertex);
		vEdge.normalize();
		Vector3d vPerp = vzEl.crossProduct(vEdge);
		
		if( ppFrameOutline.pointInProfile(ptMidEdge + vPerp) == _kPointInProfile )
			plFrameOutline.reverse();
		
		for( int j=0;j<(arPtFrameOutline.length() - 1);j++ ){
			Point3d thisVertex = arPtFrameOutline[j];
			Point3d nextVertex = arPtFrameOutline[j + 1];
			Point3d ptMidEdge = (thisVertex + nextVertex)/2;
			
			Vector3d vEdge(nextVertex - thisVertex);
			if( vEdge.length() < U(5) )
				continue;
			vEdge.normalize();
			Vector3d vPerp = vzEl.crossProduct(vEdge);
			
			int bEdgeIsAngled = true;
			if( abs(vEdge.dotProduct(vxEl)) < dEps || abs(vEdge.dotProduct(vyEl)) < dEps )
				bEdgeIsAngled = false;
			
			if( !bEdgeIsAngled && nPosition < 2 )
				continue;
			if( bEdgeIsAngled && nPosition == 2 )
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
		}
	}
}



#End
#BeginThumbnail





#End
#BeginMapX

#End