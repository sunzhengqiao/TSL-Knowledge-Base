#Version 8
#BeginDescription
Last modified by: David Rueda (david.rueda@hsbcad.com)
03.07.2018 - version 1.05
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 5
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

/// <version  value="1.04" date="07.05.2015"></version>

/// <history>
/// AS - 1.00 - 24.09.2012 -	First revision
/// AS - 1.01 - 27.09.2012 -	Add angle
/// AS - 1.02 - 09.10.2012 -	Add Notch dimension
/// AS - 1.03 - 24.10.2012 -	Support Notch dimensions if Notch tsl is v2.00 or higher.
/// AS - 1.04 - 07.05.2015 -	Add tools as dimension object. Drills, Aris & Doves are currently supported (FogBugzId 1266).
/// DR - 1.05 - 03.07.2018	- Added use of HSB_G-FilterGenBeams.mcr
/// </history>

double dEps = Unit(0.01, "mm");


String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};

String arSDimObject[0];								int arNDimObject[0];
arSDimObject.append(T("|Perimeter|"));				arNDimObject.append(0);
arSDimObject.append(T("|Notches|"));				arNDimObject.append(1);
arSDimObject.append(T("|Tools|"));					arNDimObject.append(2);

String arSScriptnameNotch[] = {
	"HSB_L-Notch"
};

String arSPosition[] = {
	T("|Horizontal bottom|"),
	T("|Horizontal top|"),
	T("|Vertical left|"),
	T("|Vertical right|"),
	T("|Angled top left|"),
	T("|Angled top right|"),
	T("|Angled bottom left|"),
	T("|Angled bottom right|")
};

/// - Filter -
///
PropString sSeperator01(0, "", T("|Filter|"));
sSeperator01.setReadOnly(true);

String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = TslInst().getListOfCatalogNames(filterDefinitionTslName);
filterDefinitions.insertAt(0, "");
PropString genBeamFilterDefinition(19, filterDefinitions, "     "+T("|Filter definition for GenBeams|"));
genBeamFilterDefinition.setDescription(T("|Filter definition for GenBeams.|") + T(" (|Will be combined with custom filters|)") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));

PropString sFilterBC(1,"","     "+T("|Filter beams with beamcode|"));
PropString sFilterLabel(2,"","     "+T("|Filter beams and sheets with label|"));
PropString sFilterMaterial(3,"","     "+T("|Filter beams and sheets with material|"));
PropString sFilterHsbID(4,"","     "+T("|Filter beams and sheets with hsbID|"));

/// - Dimension object -
/// 
PropString sSeperator02(5, "", T("|Dimension Object|"));
sSeperator02.setReadOnly(true);
PropString sDimObject(6, arSDimObject, "     "+T("|Dimension object| (DO)"));
PropString sDimObject00(15, "", "     "+T("DO-|Perimeter|"));
sDimObject00.setReadOnly(true);
PropString sWithAngle(7, arSYesNo, "          "+T("|Perimeter|") + T(" - |with angle|"));
PropDouble dSizeAngleSymbol(1, U(200), "          "+T("|Perimeter|") + T(" - |size angle symbol|"));
dSizeAngleSymbol.setDescription(T("|The size of the angle symbol.|"));
PropDouble dAngleOffset(2, U(200), "          "+T("|Perimeter|") + T(" - |offset angle symbol|"));
dAngleOffset.setDescription(T("|The offset of the angle symbol from the center of the line segment.|"));
PropString sDimObject01(16, "", "     "+T("DO-|Notches|"));
sDimObject01.setReadOnly(true);
PropString sScriptnameNotch(14, arSScriptnameNotch, "          "+T("|Notches|")+T(" - |tsl name|"));

/// - Style -
/// 
PropString sSeperator03(8, "", T("|Style|"));
sSeperator03.setReadOnly(true);
PropInt nColorDimension(1, -1, "     "+T("|Text color dimension|"));
PropString sDimStyle(9, _DimStyles, "     "+T("|Dimension style|"));
PropInt nTextColorAngle(2, -1, "     "+T("|Text color angle|"));
PropInt nLineColorAngle(3, -1, "     "+T("|Line color angle|"));
PropString sDimStyleAngle(13, _DimStyles, "     "+T("|Dimension style angle|"));

/// - Positioning -
///
PropString sSeperator04(10, "", T("|Positioning|"));
sSeperator04.setReadOnly(true);
PropString sPosition(11, arSPosition, "     "+T("|Position|"));
PropString sUsePSUnits(12, arSYesNo, "     "+T("|Offset in paperspace units|"),1);
PropDouble dDimOff(0, U(100), "     "+T("|Offset dimension line|"));

/// - Reference
///
PropString sSeperator05(17, "", T("|Reference|"));
sSeperator05.setReadOnly(true);
//Used as a reference
String sArReference[] = {
	T("|Element|")
};
PropString sReference(18, sArReference, "     "+T("|Reference object|"));


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

Display dpName(-1);
dpName.textHeight(U(5));
dpName.draw(_ThisInst.scriptName(), _Pt0, _XW, _YW, 1, 2);

Viewport vp = _Viewport[0];
Element el = vp.element();


CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps
double dVpScale = ps2ms.scale();

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

// check if the viewport has hsb data
if( !el.bIsValid() )
	return;

CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

Vector3d vx = _XW;
Vector3d vy = _YW;
Vector3d vz = _ZW;
vx.transformBy(ps2ms);
vx.normalize();
vy.transformBy(ps2ms);
vy.normalize();
vz.transformBy(ps2ms);
vz.normalize();

Line lnX(ptEl, vx);
Line lnY(ptEl, vy);

Display dp(nColorDimension);
dp.dimStyle(sDimStyle, dVpScale);
dp.color(nColorDimension);

Display dpLineAngle(nLineColorAngle);
Display dpAngle(nTextColorAngle);
dpAngle.dimStyle(sDimStyleAngle, dVpScale);

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

int nDimObject = arNDimObject[arSDimObject.find(sDimObject,0)];
int bWithAngle = arNYesNo[arSYesNo.find(sWithAngle,0)];

int nPosition = arSPosition.find(sPosition, 0); // 0 = angled; 1 = straight; 2 = both
int bUsePSUnits = arNYesNo[arSYesNo.find(sUsePSUnits,1)];
double dOffsetDim = dDimOff;
if( bUsePSUnits )
	dOffsetDim *= dVpScale;
double dSizeAngle = dSizeAngleSymbol;
if( bUsePSUnits )
	dSizeAngle *= dVpScale;
double dOffsetAngle = dAngleOffset;
if( bUsePSUnits )
	dOffsetAngle *= dVpScale;

int nReference = sArReference.find(sReference);

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

//internal filter (old)
Beam arBm[0];
Sheet arSh[0];
Point3d arPtGBm[0];
Point3d arPtTools[0];
GenBeam arGBmAll[0]; arGBmAll.append(filteredGenBeams);

for( int i=0;i<arGBmAll.length();i++ ){
	GenBeam gBm = arGBmAll[i];
	
	int bExcludeGenBeam = false;
	
	//Exclude dummies
	if( gBm.bIsDummy() || !gBm.bIsValid() )
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
	
	Body bdGBm = gBm.envelopeBody(true, true);
	
	if( bm.bIsValid() )
		arBm.append(bm);
	else if( sh.bIsValid() )
		arSh.append(sh);
	
	arPtGBm.append(bdGBm.allVertices());
	
	AnalysedTool tools[] = gBm.analysedTools();
//	for (int j=0;j<tools.length();j++) {
//		AnalysedTool tool = tools[j];
//		
//		String sToolType = tool.toolType();
//		String sToolSubType = tool.toolSubType();
//		reportNotice("\n"+sToolType + sToolSubType);
//	}
	// Add the drills
	AnalysedDrill drills[]  = AnalysedDrill().filterToolsOfToolType(tools);
	for (int j=0;j<drills.length();j++) {
		AnalysedDrill drill = drills[j];
		arPtTools.append(drill.ptStart());
	}
	
	// Add the doves
	AnalysedDove doves[]  = AnalysedDove().filterToolsOfToolType(tools);
	for (int j=0;j<doves.length();j++) {
		AnalysedDove dove = doves[j];
		arPtTools.append(dove.ptOrg());
	}
	
	// Add the aris
	AnalysedAri aris[]  = AnalysedAri().filterToolsOfToolType(tools);
	for (int j=0;j<aris.length();j++) {
		AnalysedAri ari = aris[j];
		arPtTools.append(ari.ptOrg());
	}
}

Point3d arPtGBmX[] = lnX.orderPoints(arPtGBm);
Point3d arPtGBmY[] = lnY.orderPoints(arPtGBm);
if( arPtGBmX.length() == 0 || arPtGBmY.length() == 0 )
	return;

Point3d ptBL = arPtGBmX[0] + vy * vy.dotProduct(arPtGBmY[0] - arPtGBmX[0]);
Point3d ptTR = arPtGBmX[arPtGBmX.length() - 1] + vy * vy.dotProduct(arPtGBmY[arPtGBmY.length() - 1] - arPtGBmX[arPtGBmX.length() - 1]);

Point3d arPtReference[0];
if (nReference == 0) {//Element
	arPtReference.append(ptBL);
	arPtReference.append(ptTR);
}

// Default position is 'Horizontal bottom'.
Point3d ptDimLine = ptBL - vy * dOffsetDim;
Vector3d vxDim = vx;
Vector3d vyDim = vy;
if( nPosition == 1 ){//Horizontal top
	ptDimLine = ptTR + vy * dOffsetDim;
}
else if( nPosition == 2 ){//Vertical left
	ptDimLine = ptBL - vx * dOffsetDim;
	vxDim = vy;
	vyDim = -vx;
}
else if( nPosition == 3 ){//Vertical right
	ptDimLine = ptTR + vx * dOffsetDim;
	vxDim = vy;
	vyDim = -vx;
}
else{
	//The position and vectors for the dimline will be set in the part where the angled points are calculated.
}

PLine plEnvelopeLogWall = el.plEnvelope();

Point3d arPtDim[0];
LineSeg arLnSegDim[0];
if( nDimObject == 0 ){//Perimeter
	LineSeg arLnSegLeft[0];
	LineSeg arLnSegRight[0];
	LineSeg arLnSegTop[0];
	LineSeg arLnSegBottom[0];
	LineSeg arLnSegTopLeft[0];
	LineSeg arLnSegTopRight[0];
	LineSeg arLnSegBottomLeft[0];
	LineSeg arLnSegBottomRight[0];

	Point3d arPtLogWall[] = plEnvelopeLogWall.vertexPoints(false);
	int bPLineCorrected = false;
	for( int i=0;i<(arPtLogWall.length() - 1);i++ ){
		Point3d ptFrom = arPtLogWall[i];
		Point3d ptTo = arPtLogWall[i + 1];
		
		Point3d F = ptFrom;
		Point3d T = ptTo;
		
		F.transformBy(ms2ps);
		T.transformBy(ms2ps);
		
		F.vis();
		T.vis();
		
		

		
		LineSeg lnSeg(ptFrom, ptTo);
		
		Vector3d vLnSeg(ptTo - ptFrom);
		vLnSeg.normalize();
		
		//Use vz instead of vzEl. Element might be shown from the inside.
		Vector3d vOut = vLnSeg.crossProduct(vz);
		Point3d M = (ptFrom + ptTo)/2 + 200* vOut;
		M.transformBy(ms2ps);
		M.vis(bPLineCorrected);
		if( i==0 && !bPLineCorrected ){
			PlaneProfile ppLogWall(csEl);
			ppLogWall.joinRing(plEnvelopeLogWall, _kAdd);
			
			if( ppLogWall.pointInProfile((ptFrom + ptTo)/2 + vOut) == _kPointInProfile ){
				plEnvelopeLogWall.reverse();
				arPtLogWall = plEnvelopeLogWall.vertexPoints(false);
				
				i = -1;
				bPLineCorrected = true;
				continue;
			}
		}
		
		double dx = vx.dotProduct(vOut);
		double dy = vy.dotProduct(vOut);
		
		if( dx > dEps ){//right
			if( dy > dEps )//top-right
				arLnSegTopRight.append(lnSeg);
			else if( abs(dy) > dEps )//bottom-right
				arLnSegBottomRight.append(lnSeg);
			else//right
				arLnSegRight.append(lnSeg);
		}
		else if( abs(dx) > dEps ){//left
			if( dy > dEps )//top-left
				arLnSegTopLeft.append(lnSeg);
			else if( abs(dy) > dEps )//bottom-left
				arLnSegBottomLeft.append(lnSeg);
			else//left
				arLnSegLeft.append(lnSeg);
		}
		else{//top or bottom
			if( dy > dEps )//top
				arLnSegBottom.append(lnSeg);
			else//bottom
				arLnSegBottom.append(lnSeg);
		}
	}
	
	
	if( nPosition == 0 ){//horizontal bottom
		arLnSegDim.append(arLnSegBottom);
	}
	else if( nPosition == 1 ){//horizontal top
		arLnSegDim.append(arLnSegTop);
	}
	else if( nPosition == 2 ){//vertical left
		arLnSegDim.append(arLnSegLeft);
	}
	else if( nPosition == 3 ){//vertical right
		arLnSegDim.append(arLnSegRight);
	}
	else if( nPosition == 4 ){//angled top left
		arLnSegDim.append(arLnSegTopLeft);
	}
	else if( nPosition == 5 ){//angled top right
		arLnSegDim.append(arLnSegTopRight);
	}
	else if( nPosition == 6 ){//angled bottom left
		arLnSegDim.append(arLnSegBottomLeft);
	}
	else if( nPosition == 7 ){//angled bottom right
		arLnSegDim.append(arLnSegBottomRight);
	}
}
else if( nDimObject == 1 ){//Notch
	TslInst arTsl[] = el.tslInst();
	for( int i=0;i<arTsl.length();i++ ){
		TslInst tsl = arTsl[i];
		if( tsl.scriptName() != sScriptnameNotch )
			continue;

		if( tsl.version() < 20000 ){
			reportMessage(scriptName() + T(" |supports| HSB_L-Notch ")+T("v2.00 |and higher|."));
			return;
		}
	
		Point3d ptTsl = tsl.ptOrg();
		Beam arBmNotch[] = tsl.beam();
		if( arBmNotch.length() == 0 )
			continue;
		Beam bmNotch = arBmNotch[0];
		Point3d ptDimA = ptTsl + 
			bmNotch.vecD(vx) * (0.5 * bmNotch.dD(vx) - tsl.propDouble(7) + tsl.propDouble(8)) + 
			bmNotch.vecD(vy) * (0.5 * bmNotch.dD(vy) - tsl.propDouble(1) + tsl.propDouble(5));
		Point3d ptDimB = ptTsl - 
			bmNotch.vecD(vx) * (0.5 * bmNotch.dD(vx) - tsl.propDouble(0) + tsl.propDouble(4)) - 
			bmNotch.vecD(vy) * (0.5 * bmNotch.dD(vy) - tsl.propDouble(2) + tsl.propDouble(6));
		Point3d arPtDimNotch[] = {
			ptDimA,
			ptDimB
		};
		
		DimLine dimLineVert(ptDimB - bmNotch.vecD(vx) * dOffsetDim, bmNotch.vecD(vy), -bmNotch.vecD(vx));
		Dim dimVert(dimLineVert, arPtDimNotch, "<>", "<>", _kDimPar, _kDimNone);
		dimVert.transformBy(ms2ps);
		dp.draw(dimVert);
		
		DimLine dimLineHor(ptDimA + bmNotch.vecD(vy) * dOffsetDim, bmNotch.vecD(vx), bmNotch.vecD(vy));
		Dim dimHor(dimLineHor, arPtDimNotch, "<>", "<>", _kDimPar, _kDimNone);
		dimHor.transformBy(ms2ps);
		dp.draw(dimHor);
	}
}
if (nDimObject == 2) { //Tools
	arPtDim.append(arPtTools);
}

if( arLnSegDim.length() > 0 ){
	for( int i=0;i<arLnSegDim.length();i++ ){
		LineSeg lnSeg = arLnSegDim[i];
		Point3d ptFrom = lnSeg.ptStart();
		Point3d ptTo = lnSeg.ptEnd();
		
		Point3d ptF = ptFrom;
		Point3d ptT = ptTo;
		ptF.transformBy(ms2ps);
		ptT.transformBy(ms2ps);
		ptF.vis();
		ptT.vis();
		
		Vector3d vLnSeg(ptTo - ptFrom);
		vLnSeg.normalize();
		Vector3d vOut = vLnSeg.crossProduct(vz);
		
		Point3d ptDimLine = ptFrom + vOut * dOffsetDim;
		if( nPosition == 4 || nPosition == 5 ){
			vxDim = -vLnSeg;
			vyDim = vOut;
		}
		else if( nPosition == 6 || nPosition == 7 ){
			vxDim = vLnSeg;
			vyDim = -vOut;
		}
		
		Point3d arPtLnSeg[] = {ptFrom, ptTo};
		DimLine dimLine(ptDimLine, vxDim, vyDim);
		Dim dim(dimLine, arPtLnSeg, "<>", "<>", _kDimPar, _kDimNone);
		dim.transformBy(ms2ps);
		dp.draw(dim);
		
		if( bWithAngle && nPosition > 3 ){
			double dAngle = vLnSeg.angleTo(vx);
			if( dAngle > 90 )
				dAngle = 180 - dAngle;
			String sAngle;
			sAngle.formatUnit(dAngle, 2, 0);
			
			Vector3d vAngle = vLnSeg;
			if( nPosition < 6 && vAngle.dotProduct(vy) < 0 )
				vAngle *= -1;
			if( nPosition > 5 && vAngle.dotProduct(vy) > 0 )
				vAngle *= -1;
			Vector3d vAngleHor = vx;
			if( nPosition == 5 || nPosition == 7 )
				vAngleHor *= -1;
			
			Point3d ptLnSegMid = (ptTo + ptFrom)/2;
			
			Point3d ptAngle = ptLnSegMid - vAngle * dOffsetAngle;
			Point3d ptAngleHorizontal = ptAngle + vAngleHor * dSizeAngle;
			Point3d ptAngleAngled = ptAngle + vAngle * dSizeAngle;
			PLine plAngle(vz);
			plAngle.addVertex(ptAngleAngled);
			plAngle.addVertex(ptAngle);
			plAngle.addVertex(ptAngleHorizontal);
			
			int nDirection = _kCWise;
			if( nPosition == 5 || nPosition == 6 )
				nDirection = _kCCWise;
			Point3d ptArcAngled = ptAngle + vAngle * 2.0/3.0 * dSizeAngle;
			Point3d ptArcHorizontal = ptAngle + vAngleHor * 2.0/3.0 * dSizeAngle;
			double dRadiusArc = 2.0/3.0 * dSizeAngle;
			PLine plArc(vz);
			plArc.addVertex(ptArcAngled);
			plArc.addVertex(ptArcHorizontal, dRadiusArc, nDirection, true);
			
			plAngle.transformBy(ms2ps);
			dpLineAngle.draw(plAngle);
			
			plArc.transformBy(ms2ps);
			dpLineAngle.draw(plArc);
			
			Vector3d vAngleToText = vAngle + vAngleHor;
			vAngleToText.normalize();
			Point3d ptAngleText = ptAngle + vAngleToText * dSizeAngle;
			ptAngleText.transformBy(ms2ps);
			
			double dFlagX = 1;
			if( nPosition == 5 || nPosition == 7 )
				dFlagX *= -1;
			dpAngle.draw(sAngle + "°", ptAngleText, _XW, _YW, dFlagX, 0);
		}
	}
}
else{
	Point3d arPtToDim[0];
	if (arPtReference.length() > 0) {
		arPtToDim.append(arPtReference);
		arPtToDim.append(arPtDim);
	}
	arPtToDim = Line(ptDimLine, vxDim).orderPoints(arPtToDim, U(0.5));
	
	DimLine dimLine(ptDimLine, vxDim, vyDim);
	Dim dim(dimLine, arPtToDim, "<>", "<>", _kDimPar, _kDimNone);
	dim.transformBy(ms2ps);
	dp.draw(dim);
}





#End
#BeginThumbnail
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
263]JE<FNE[-GHM%%%>R>:?_9
`






#End
#BeginMapX

#End