#Version 8
#BeginDescription
Last modified by: David Rueda (david.rueda@hsbcad.com)
28.06.2018 - version 1.04
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
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

/// <version  value="1.03" date="28.03.2014"></version>

/// <history>
/// AS - 1.00 - 03.03.2014 -	Pilot version
/// AS - 1.01 - 28.03.2014 -	Simplify tsl. Only support rafter and trimmer dimension
/// AS - 1.02 - 28.03.2014 -	Support multiple beam codes for hip. Use faces of rafters.
/// AS - 1.03 - 28.03.2014 -	Add properties for display of name
/// DR - 1.04 - 28.06.2018	- Added use of HSB_G-FilterGenBeams.mcr
/// </history>

//Script uses mm
double dEps = U(.001,"mm");

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

String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};

// ---------------------------------------------------------------------------------
PropString sSeperator01(0, "", T("|Selection|"));
sSeperator01.setReadOnly(true);

String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = TslInst().getListOfCatalogNames(filterDefinitionTslName);
filterDefinitions.insertAt(0, "");
PropString beamFilterDefinition(21, filterDefinitions, "     "+T("|Filter definition for beams|"));
beamFilterDefinition.setDescription(T("|Filter definition for beams.|") + T(" (|Will be combined with custom filters|)") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));

PropString sFilterBC(1,"","     "+T("|Filter beams with beamcode|"));
PropString sFilterLabel(2,"","     "+T("|Filter beams and sheets with label|"));
PropString sFilterZone(3, "", "     "+T("|Filter zones|"));

// ---------------------------------------------------------------------------------
PropString sSeperator02(4, "", T("|Hip dimension|"));
sSeperator02.setReadOnly(true);

PropString sBmCodeRafter(6, "HK-R", "     "+T("|Beamcode rafter|"));
PropString sBmCodeTrimmer(5, "HK-T", "     "+T("|Beamcode trimmer|"));
PropString sBmCodeHip(15, "HK-01", "     "+T("|Beamcode hip|"));

String arSDimObject[] = {
	T("|Rafters|"),
	T("|Trimmer|"),
	T("|Hip|")
};
PropString sDimObject(7, arSDimObject, "     "+T("|Dimension object|"));

/// - Positioning -
/// 
PropString sSeperator05(8, "", T("|Positioning|"));
sSeperator05.setReadOnly(true);

PropString sUsePSUnits(9, arSYesNo, "     "+T("|Offset in paperspace units|"),0);
PropDouble dDimLineOffset(0, U(15), "     "+T("|Offset dimension line|"));

/// - Style -
/// 
PropString sSeperator04(10, "", T("|Style|"));
sSeperator04.setReadOnly(true);

//Used to set the side of the text.
String arSDeltaOnTop[]={T("|Above|"),T("|Below|")};
int arNDeltaOnTop[]={true, false};
PropString sDeltaOnTop(11,arSDeltaOnTop,"     "+T("|Side of delta dimension|"),0);

String sArDimLayout[] ={
	T("|Delta perpendicular|"),
	T("|Delta parallel|"),
	T("|Cumulative perpendicular|"),
	T("|Cumulative parallel|"),
	T("|Both perpendicular|"),
	T("|Both parallel|"),
	T("|Delta parallel|, ")+T("|Cumulative perpendicular|"),
	T("|Delta perpendicular|, ")+T("|Cumulative parallel|")
};
int nArDimLayoutDelta[] = {_kDimPerp, _kDimPar,_kDimNone,_kDimNone,_kDimPerp,_kDimPar,_kDimPar,_kDimPerp};
int nArDimLayoutCum[] = {_kDimNone,_kDimNone,_kDimPerp, _kDimPar,_kDimPerp,_kDimPar,_kDimPerp,_kDimPar};
PropString sDimLayout(12,sArDimLayout,"     "+T("|Dimension method|"));

String sArDimensionSide[]={T("|Left|"),T("|Center|"),T("|Right|"), T("|Left| & ") + T("|Right|")};
int nArDimensionSide[]={_kLeft, _kCenter, _kRight, _kLeftAndRight};
PropString sDimensionSide(13,sArDimensionSide,"     "+T("|Dimension side|"));

PropString sDimStyle(14, _DimStyles, "     "+T("|Dimension style|"));

/// - Name and description -
/// 
PropString sSeperator14(16, "", T("|Name and description|"));
sSeperator14.setReadOnly(true);

PropInt nColorName(0, -1, "     "+T("|Default name color|"));
PropInt nColorActiveFilter(1, 30, "     "+T("|Filter other element color|"));
PropInt nColorActiveFilterThisElement(2, 1, "     "+T("|Filter this element color|"));
PropString sDimStyleName(17, _DimStyles, "     "+T("|Dimension style name|"));
PropString sInstanceDescription(18, "", "     "+T("|Extra description|"));
PropString sDisableTsl(19, arSYesNo, "     "+T("|Disable the tsl|"),1);
PropString sShowVpOutline(20, arSYesNo, "     "+T("|Show viewport outline|"),1);

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
	
	_Viewport.append(getViewport(T("|Select the viewport|")));
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
		dpName.color(1);
		dpName.draw(_ThisInst.scriptName(), _Pt0, _XW, _YW, 1, 2);
		dpName.textHeight(U(2.5));
		dpName.draw(T("|Active filter|"), _Pt0, _XW, _YW, 1, 1);
		return;
	}
	else{
		dpName.color(30);
		dpName.draw(_ThisInst.scriptName(), _Pt0, _XW, _YW, 1, 2);
		dpName.textHeight(U(2.5));
		dpName.draw(T("|Active filter|"), _Pt0, _XW, _YW, 1, 1);
	}
}
	
//Element coordSys
CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

//Coordinate system
CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps
double dVpScale = ps2ms.scale();

Vector3d vxms = _XW;
vxms.transformBy(ps2ms);
vxms.normalize();
Vector3d vyms = _YW;
vyms.transformBy(ps2ms);
vyms.normalize();
Vector3d vzms = _ZW;
vzms.transformBy(ps2ms);
vzms.normalize();

Display dpDim(nDimColor);
dpDim.dimStyle(sDimStyle, dVpScale); // dimstyle was adjusted for display in paper space, sets textHeight

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
// dimension
int nDimObject = arSDimObject.find(sDimObject,0);

int nDimLayoutDelta = nArDimLayoutDelta[sArDimLayout.find(sDimLayout,0)];
int nDimLayoutCum = nArDimLayoutCum[sArDimLayout.find(sDimLayout,0)];
int nDeltaOnTop = arNDeltaOnTop[arSDeltaOnTop.find(sDeltaOnTop,0)];
int nDimensionSide = nArDimensionSide[sArDimensionSide.find(sDimensionSide,0)];
int bUsePSUnits = arNYesNo[arSYesNo.find(sUsePSUnits,1)];
double dOffsetDim = dDimLineOffset;
if( bUsePSUnits )
	dOffsetDim *= dVpScale;


String arSBmCodeRafter[] = {sBmCodeRafter};
String arSBmCodeTrimmer[] = {sBmCodeTrimmer};

String sHipBC = sBmCodeHip + ";";
sHipBC.makeUpper();
String arSBmCodeHip[0];
int nIndexHipBC = 0; 
int sIndexHipBC = 0;
while(sIndexHipBC < sHipBC.length()-1){
	String sTokenHipBC = sHipBC.token(nIndexHipBC);
	nIndexHipBC++;
	if(sTokenHipBC.length()==0){
		sIndexHipBC++;
		continue;
	}
	sIndexHipBC = sHipBC.find(sTokenHipBC,0);
	sTokenHipBC.trimLeft();
	sTokenHipBC.trimRight();
	arSBmCodeHip.append(sTokenHipBC);
}


Beam arBm[0];
Beam bmRafter;
Beam bmTrimmer;
Beam arBmHip[0];

Beam arBmRafter[0];

//region filter beams (new)
Beam beams[] = el.beam();;
Entity beamEntities[0];
for (int b = 0; b < beams.length(); b++)
{
	Beam bm = beams[b];
	if ( ! bm.bIsValid())
		continue;
	
	beamEntities.append(bm);
}

Map filterGenBeamsMap;
filterGenBeamsMap.setEntityArray(beamEntities, false, "GenBeams", "GenBeams", "GenBeam");
int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, beamFilterDefinition, filterGenBeamsMap);
if ( ! successfullyFiltered)
{
	reportWarning(T("|Beams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
	eraseInstance();
	return;
}
Entity filteredBeamEntities[] = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");
Beam filteredBeams[0];
for (int e = 0; e < filteredBeamEntities.length(); e++)
{
	Beam bm = (Beam)filteredBeamEntities[e];
	if ( ! bm.bIsValid()) continue;
	
	filteredBeams.append(bm);
	
}
//endregion

//internal filter (old)
Beam arBmAll[0]; arBmAll.append(filteredBeams);
for( int i=0;i<arBmAll.length();i++ ){
	Beam bm = arBmAll[i];
	
	// apply filters
	String sBmCode = bm.beamCode().token(0);
	String sMaterial = bm.material();
	String sLabel = bm.label();
	int nZnIndex = bm.myZoneIndex();
	if( arSFBC.find(sBmCode) != -1 )
		continue;
	if( arSFLabel.find(sMaterial) != -1 )
		continue;
	if( arSFLabel.find(sLabel) != -1 )
		continue;
	if( arNFilterZone.find(nZnIndex) != -1 )
		continue;
		
	
	arBm.append(bm);
	if( arSBmCodeRafter.find(sBmCode) != -1 )
		bmRafter = bm;
	else if( arSBmCodeTrimmer.find(sBmCode) != -1 )
		bmTrimmer = bm;
	else if( arSBmCodeHip.find(sBmCode) != -1 )
		arBmHip.append(bm);
	else if( abs(abs(bm.vecX().dotProduct(vyEl)) - 1) < dEps )
		arBmRafter.append(bm);
}

// Point and orientation of dimline
Point3d ptDimLine;
Vector3d vxDimLine;
Vector3d vyDimLine;

// Dimpoints
Point3d arPtDim[0];

Vector3d vyRafter = vzms.crossProduct(bmRafter.vecX());
if( vyRafter.dotProduct(vxms + vyms) < 0 )
	vyRafter *= -1;
Vector3d vxRafter = vyRafter.crossProduct(vzms);

Plane pnZInside(el.zone(-1).coordSys().ptOrg(), vzEl);

// find closest rafters
Beam bmRafterLeft;
Beam arBmLeft[] = Beam().filterBeamsHalfLineIntersectSort(arBmRafter, bmTrimmer.ptCen() + vyEl * U(50), -vxEl);
if( arBmLeft.length() > 0 )
	bmRafterLeft = arBmLeft[0];
Beam bmRafterRight;
Beam arBmRight[] = Beam().filterBeamsHalfLineIntersectSort(arBmRafter, bmTrimmer.ptCen() + vyEl * U(50), vxEl);
if( arBmRight.length() > 0 )
	bmRafterRight = arBmRight[0];

if( nDimObject == 0 ){ //Rafters
	ptDimLine = bmTrimmer.ptCen() - vxRafter * dOffsetDim;
	vxDimLine = vyRafter;
	vyDimLine = -vxRafter;
	
	Beam arBmToDim[0];
	arBmToDim.append(bmRafter);
	if( bmRafterLeft.bIsValid() )
		arBmToDim.append(bmRafterLeft);
	if( bmRafterRight.bIsValid() )
		arBmToDim.append(bmRafterRight);
	
	for( int i=0;i<arBmToDim.length();i++ ){
		Beam bmToDim = arBmToDim[i];
				
		Point3d ptLeft = bmToDim.ptCen() - vyRafter * 0.5 * bmToDim.dD(vyRafter);
		Point3d ptRight = bmToDim.ptCen() + vyRafter * 0.5 * bmToDim.dD(vyRafter);
		
		if( nDimensionSide == _kCenter )
			arPtDim.append(bmToDim.ptCen());
		if( nDimensionSide == _kLeft || nDimensionSide == _kLeftAndRight )
			arPtDim.append(ptLeft);
		if( nDimensionSide == _kRight || nDimensionSide == _kLeftAndRight )
			arPtDim.append(ptRight);
	}
	
	Line lnProject(bmTrimmer.ptCen(), vxDimLine);
	arPtDim = lnProject.projectPoints(arPtDim);
}
else if( nDimObject == 1 ){//Trimmer
	vxDimLine = vxRafter;
	vyDimLine = vyRafter;
	
	Point3d ptLeft = bmTrimmer.ptCen() - vxRafter * 0.5 * bmTrimmer.dD(vxRafter);
	Point3d ptRight = bmTrimmer.ptCen() + vxRafter * 0.5 * bmTrimmer.dD(vxRafter);
	
	if( nDimensionSide == _kCenter )
		arPtDim.append(bmTrimmer.ptCen());
	if( nDimensionSide == _kLeft || nDimensionSide == _kLeftAndRight )
		arPtDim.append(ptLeft);
	if( nDimensionSide == _kRight || nDimensionSide == _kLeftAndRight )
		arPtDim.append(ptRight);
	
	Point3d ptRafterLeft;
	Point3d ptRafterRight;
	if( bmRafterLeft.bIsValid() ){
		Point3d arPtRafterFace[] = bmRafterLeft.envelopeBody(false, true).extractContactFaceInPlane(pnZInside, U(100)).getGripVertexPoints();
		arPtRafterFace = Line(ptEl, vxRafter).orderPoints(arPtRafterFace);

		ptRafterLeft = arPtRafterFace[arPtRafterFace.length() - 1];//bmRafterLeft.ptCenSolid() + vxRafter * 0.5 * bmRafterLeft.solidLength();
	}
	if( bmRafterRight.bIsValid() ){
		Point3d arPtRafterFace[] = bmRafterRight.envelopeBody(false, true).extractContactFaceInPlane(pnZInside, U(100)).getGripVertexPoints();
		arPtRafterFace = Line(ptEl, vxRafter).orderPoints(arPtRafterFace);

		ptRafterRight = arPtRafterFace[arPtRafterFace.length() - 1];//bmRafterRight.ptCenSolid() + vxRafter * 0.5 * bmRafterRight.solidLength();
	}
	
	Point3d ptProject = bmRafter.ptCen();
	if( bmRafterLeft.bIsValid() && bmRafterRight.bIsValid() ){
		if( vxRafter.dotProduct(ptRafterRight - ptRafterLeft) > 0 ){
			arPtDim.append(ptRafterLeft);
			ptProject = ptRafterLeft;
			ptDimLine = ptRafterLeft - vyRafter * dOffsetDim;
		}
		else{
			arPtDim.append(ptRafterRight);
			ptProject = ptRafterRight;
			ptDimLine = ptRafterRight + vyRafter * dOffsetDim;
		}
	}
	else if( bmRafterLeft.bIsValid() ){
		arPtDim.append(ptRafterLeft);
		ptProject = ptRafterLeft;
		ptDimLine = ptRafterLeft - vyRafter * dOffsetDim;
	}
	else if( bmRafterRight.bIsValid() ){
		arPtDim.append(ptRafterRight);
		ptProject = ptRafterRight;
		ptDimLine = ptRafterRight + vyRafter * dOffsetDim;
	}
	
	Line lnProject(ptProject, vxDimLine);
	arPtDim = lnProject.projectPoints(arPtDim);
}
else if( nDimObject == 2 ){//Hip
	ptDimLine = bmRafter.ptCen() + vyRafter * dOffsetDim;
	vxDimLine = vxRafter;
	vyDimLine = vyRafter;
	
	Point3d arPtRafterFace[] = bmRafter.envelopeBody(false, true).extractContactFaceInPlane(pnZInside, U(100)).getGripVertexPoints();
	arPtRafterFace = Line(ptEl, vxRafter).orderPoints(arPtRafterFace);
	
	if( arPtRafterFace.length() == 0 )
		return;
	Point3d ptRafterFace = arPtRafterFace[arPtRafterFace.length() - 1];
	Point3d ptHipFace;
	int bPtHipFaceSet = false;
	for( int i=0;i<arBmHip.length();i++ ){
		Beam bmThisHip = arBmHip[i];
		Vector3d vxHip = bmThisHip.vecX();
		if( vxRafter.dotProduct(vxHip) < 0 )
			vxHip *= -1;
		Point3d arPtThisHipFace[] = bmThisHip.envelopeBody(false, true).extractContactFaceInPlane(pnZInside, U(100)).getGripVertexPoints();
		arPtThisHipFace = Line(ptEl, vxHip).orderPoints(arPtThisHipFace);
		if( arPtThisHipFace.length() == 0 )
			continue;
		Point3d ptThisHipFace = arPtThisHipFace[arPtThisHipFace.length() - 1];
		
		if( !bPtHipFaceSet || abs(vyRafter.dotProduct(ptRafterFace - ptThisHipFace)) < abs(vyRafter.dotProduct(ptRafterFace - ptHipFace)) ){
			ptHipFace = ptThisHipFace;
			bPtHipFaceSet = true;
		}
	}
	
	if( bPtHipFaceSet ){
		arPtDim.append(ptRafterFace);
		arPtDim.append(ptHipFace);
	}
	
	Line lnProject(bmRafter.ptCen(), vxDimLine);
	arPtDim = lnProject.projectPoints(arPtDim);
}

Line lnOrder(ptDimLine, vxDimLine);
arPtDim = lnOrder.orderPoints(arPtDim);

DimLine dimLine(ptDimLine, vxDimLine, vyDimLine);
Dim dim(dimLine, arPtDim, "<>", "<>", nDimLayoutDelta,nDimLayoutCum);
dim.transformBy(ms2ps);
dim.setReadDirection(-_XW + _YW);
dim.setDeltaOnTop(nDeltaOnTop);
dpDim.draw(dim);


#End
#BeginThumbnail
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
40`4444`%%%%`!1110`4444`?_]E1
`


#End
#BeginMapX

#End