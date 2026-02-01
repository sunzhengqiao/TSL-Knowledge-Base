#Version 8
#BeginDescription
Last modified by: Anno Sportel (support.nl@hsbcad.com)
16.10.2017  -  version 1.06















#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 6
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// Place dimension lines for the openings sheets.
/// </summary>

/// <insert>
/// Select a position
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.06" date="16.10.2017"></version>

/// <history>
/// AS - 1.00 - 10.09.2013 -  Pilot version.
/// AS - 1.01 - 11.09.2013 -  Add reference points.
/// AS - 1.02 - 11.09.2013 -  Filter zones
/// AS - 1.03 - 11.09.2013 -  Add extremes of element
/// AS - 1.04 - 24.02.2014 -  Correct outline index
/// AS - 1.05 - 03.05.2016 -  Use Body::extractContactFaceInPlane instead of Sheet::profShape to get to the openings added as tools.
/// AS - 1.06 - 16.10.2017 -  Add option to merge zone and treat the zone as a sheet.
/// </hsitory>

double dEps = Unit(0.01,"mm");
double pointTolerance = U(0.01);

int arNZone[] = {1,2,3,4,5,6,7,8,9,10};

String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};

String arSPosition[] = {
	T("|Horizontal top|"),
	T("|Horizontal bottom|"),
	T("|Vertical left|"),
	T("|Vertical right|")
};

String arSObject[] = {
	T("|Openings in sheet|")
};


/// - Selection -
///
PropString sSeperator01(0, "", T("|Selection|"));
sSeperator01.setReadOnly(true);
PropInt nZoneProp(0,arNZone, "     "+T("|Zone|"));
String noYes[] = { T("|No|"), T("|Yes|")};
PropString mergeSheetsProp(18, noYes, "     " + T("|Merge sheets|"), 0);
PropDouble mergeSheetsWithGap(1, U(10), "     " + T("|Merge sheets with gap|"));

/// - Filter -
///
PropString sSeperator06(15, "", T("|Filter|"));
sSeperator06.setReadOnly(true);
PropString sFilterBC(11,"","     "+T("|Filter beams with beamcode|"));
PropString sFilterLabel(12,"","     "+T("|Filter beams and sheets with label|"));
PropString sFilterMaterial(13,"","     "+T("|Filter beams and sheets with material|"));
PropString sFilterHsbID(14,"","     "+T("|Filter beams and sheets with hsbID|"));
PropString sFilterZone(17, "", "     "+"Filter zones");

/// - Dimension object -
/// 
PropString sSeperator02(1, "", T("|Dimension Object|"));
sSeperator02.setReadOnly(true);
PropString sObject(16, arSObject, "     "+T("|Object|"));

/// - Positioning -
/// 
PropString sSeperator03(2, "", T("|Positioning|"));
sSeperator03.setReadOnly(true);
PropString sPosition(3, arSPosition, "     "+T("|Position|"));
PropString sDimensionPerOpening(10, arSYesNo, "     "+T("|Dimension per opening|"));
PropString sUsePSUnits(4, arSYesNo, "     "+T("|Offset in paperspace units|"));
PropDouble dOffset(0, U(6), "     "+T("|Offset|"));


/// - Style -
/// 
PropString sSeperator04(5, "", T("|Style|"));
sSeperator04.setReadOnly(true);
PropString sDimStyle(6,_DimStyles, "     "+T("|Dimension style|"));
PropInt nDimColor(1,1,"     "+T("|Color|"));


/// - Name and description -
/// 
PropString sSeperator05(7, "", T("|Name and description|"));
sSeperator05.setReadOnly(true);
PropInt nColorName(2, -1, "     "+T("|Default name color|"));
PropInt nColorActiveFilter(3, 30, "     "+T("|Filter other element color|"));
PropInt nColorActiveFilterThisElement(4, 1, "     "+T("|Filter this element color|"));
PropString sDimStyleName(8, _DimStyles, "     "+T("|Dimension style name|"));
PropString sInstanceDescription(9, "", "     "+T("|Extra description|"));


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

// Draw name
String sInstanceNameAndDescription = _ThisInst.scriptName();
if( sInstanceDescription.length() > 0 )
	sInstanceNameAndDescription += (" - "+sInstanceDescription);

Display dpName(nColorName);
dpName.dimStyle(sDimStyleName);
dpName.draw(sInstanceNameAndDescription, _Pt0, _XW, _YW, 1, 2);

double dTextHeightName = dpName.textHeightForStyle("HSB", sDimStyleName);

int mergeSheets = noYes.find(mergeSheetsProp, 0);


//Is there a viewport selected
if( _Viewport.length()==0 ){
	eraseInstance();
	return;
}
Viewport vp = _Viewport[0];
Element el = vp.element();

// check if the viewport has hsb data
if( !el.bIsValid() )
	return;

CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps
double dVpScale = ps2ms.scale();

Display dp(nDimColor);
dp.dimStyle(sDimStyle,dVpScale);


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


//Resolve properties
//Selection
int nZone = nZoneProp;
if( nZone > 5 ){
	nZone = -(nZoneProp - 5);
}

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


int nPosition = arSPosition.find(sPosition,0);
int bDimensionPerOpening = arNYesNo[arSYesNo.find(sDimensionPerOpening,1)];
int bUsePSUnits = arNYesNo[arSYesNo.find(sUsePSUnits,1)];
double dOffsetDim = dOffset;
if( bUsePSUnits )
	dOffsetDim *= dVpScale;

int nSideOffset = 1;
if (nPosition == 1 || nPosition == 3)
	nSideOffset *= -1;

Vector3d vxMs = _XW;
vxMs.transformBy(ps2ms);
vxMs.normalize();
Vector3d vyMs = _YW;
vyMs.transformBy(ps2ms);
vyMs.normalize();

Vector3d vxDim = vxMs;
Vector3d vyDim = vyMs;

if( nPosition > 1 ){
	vxDim = vyMs;
	vyDim = -vxMs;
}

Line lnDimX(ptEl, vxDim);
Line lnDimY(ptEl, vyDim);

Line lnX(ptEl, vxMs);
Line lnY(ptEl, vyMs);

// The unfiltered set of genbeams
GenBeam arGBmAll[] = el.genBeam();
// These will be populated after the filters are applied.
Sheet arSh[0];
Beam arBm[0];
GenBeam arGBm[0];

Body arBdSh[0];
Body arBdBm[0];
Body arBdGBm[0];

Point3d arPtGBm[0];

for(int i=0;i<arGBmAll.length();i++){
	GenBeam gBm = arGBmAll[i];
	int bExcludeGenBeam = false;
	
	//Exclude dummies
	if( gBm.bIsDummy() )
		continue;
	
	//Exlude zones
	int nZnIndex = gBm.myZoneIndex();
	if( arNFilterZone.find(nZnIndex) != -1 )
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
	
	Body bdGBm = gBm.realBody();	
	
	if( sh.bIsValid() ) {
		arSh.append(sh);
		arBdSh.append(bdGBm);
	}
		
	arGBm.append(gBm);
	arBdGBm.append(bdGBm);
	arPtGBm.append(bdGBm.allVertices());
	
	if( !bm.bIsValid() )
		continue;

	if( bm.myZoneIndex() != 0 )
		continue;
	
	arBm.append(bm);
	arBdBm.append(bdGBm);
}

PlaneProfile profilesToDimension[0];
PlaneProfile ppZn(csEl);
for ( int i = 0; i < arSh.length(); i++) 
{
	Sheet sh = arSh[i];
	Body bdSh = arBdSh[i];
	
	if ( sh.myZoneIndex() != nZone )
		continue;
	if ( sh.bIsDummy() )
		continue;
	
	PlaneProfile ppSh = bdSh.extractContactFaceInPlane(Plane(sh.ptCen(), sh.vecZ()), U(100));//.profShape();
		
	if (!mergeSheets)
	{
		profilesToDimension.append(ppSh);
	}
	else
	{
		ppSh.shrink(-0.5 * mergeSheetsWithGap + pointTolerance);
		ppZn.unionWith(ppSh);
	}
	
	ppSh.vis();
}

ppZn.shrink(0.5 * mergeSheetsWithGap + pointTolerance);
if ( mergeSheets)
{
	profilesToDimension.append(ppZn);
}
PLine arPlPerimeter[0];
PLine arPlOpening[0];
int arNPerimeterIndex[0];

Point3d arPtAllSheets[0];
for (int p=0;p<profilesToDimension.length();p++)
{
	PlaneProfile pp = profilesToDimension[p];
	PLine arPl[] = pp.allRings();
	int arNPlIsRing[] = pp.ringIsOpening();
	
	arPtAllSheets.append(pp.getGripVertexPoints());

	for( int j=0;j<arPl.length();j++ ){
		PLine pl = arPl[j];
		
		if( arNPlIsRing[j] ){
			arPlOpening.append(pl);
			arNPerimeterIndex.append(p);
		}
		else{
			arPlPerimeter.append(pl);
		}
	}
}

Point3d arPtGBmX[] = lnX.orderPoints(arPtGBm);
Point3d arPtGBmY[] = lnY.orderPoints(arPtGBm);
if( arPtGBmX.length() * arPtGBmY.length() == 0 )
	return;


Point3d ptGBmBottomLeft = arPtGBmX[0];
ptGBmBottomLeft += vyMs * vyMs.dotProduct(arPtGBmY[0] - ptGBmBottomLeft);
Point3d ptGBmTopRight = arPtGBmX[arPtGBmX.length() - 1];
ptGBmTopRight += vyMs * vyMs.dotProduct(arPtGBmY[arPtGBmY.length() - 1] - ptGBmTopRight);


Point3d arPtAllSheetsDimX[] = lnDimX.orderPoints(arPtAllSheets);
if( arPtAllSheetsDimX.length() == 0 )
	return;

Point3d arPtTotalDim[0];
arPtTotalDim.append(ptGBmBottomLeft);
arPtTotalDim.append(arPtAllSheetsDimX[0]);

for (int i=0;i<arPlOpening.length();i++) {
	PLine plOpening = arPlOpening[i];
	int nPerimeterIndex = arNPerimeterIndex[i];
	if( nPerimeterIndex > arPlPerimeter.length() || nPerimeterIndex == -1 ){
		reportMessage(
			"\n" + scriptName() + 
			TN("|Element|: ") + el.number() + 
			TN("|Invalid sheet outline found in zone| ") + nZoneProp + "!");
		
		continue;
	}
	PLine plPerimeter = arPlPerimeter[nPerimeterIndex];
	
	Point3d arPtPerimeter[] = plPerimeter.vertexPoints(true);
	Point3d arPtPerimeterDimX[] = lnDimX.orderPoints(arPtPerimeter);
	if( arPtPerimeterDimX.length() == 0 )
		continue;
		
	if (bDimensionPerOpening) {
		// Used to calculate the start point for the dimension line of this opening.
		Point3d arPtOpening[] = plOpening.vertexPoints(true);
		Point3d arPtOpeningX[] = lnX.orderPoints(arPtOpening);
		Point3d arPtOpeningY[] = lnY.orderPoints(arPtOpening);
		if( arPtOpeningX.length() * arPtOpeningY.length() == 0 )
			continue;
		// The extremes for this opening.
		Point3d ptOpeningBottomLeft = arPtOpeningX[0];
		ptOpeningBottomLeft += vyMs * vyMs.dotProduct(arPtOpeningY[0] - ptOpeningBottomLeft);
		Point3d ptOpeningTopRight = arPtOpeningX[arPtOpeningX.length() - 1];
		ptOpeningTopRight += vyMs * vyMs.dotProduct(arPtOpeningY[arPtOpeningY.length() - 1] - ptOpeningTopRight);
		
		// Reference points for this dim
		Point3d arPtDim[0];
		arPtDim.append(ptGBmBottomLeft);
		arPtDim.append(arPtPerimeterDimX[0]);
		arPtDim.append(plOpening.vertexPoints(true));
		arPtDim.append(arPtPerimeterDimX[arPtPerimeterDimX.length() - 1]);
		arPtDim.append(ptGBmTopRight);
		
		// Start point for this dimension line.
		Point3d ptDim = ptOpeningBottomLeft;
		if (nPosition == 0 || nPosition == 3)
			ptDim = ptOpeningTopRight;
		ptDim += vyDim * nSideOffset * dOffsetDim;
		// Create and draw the dimline for this opening.
		DimLine dimLine(ptDim, vxDim, vyDim);
		Dim dim(dimLine, arPtDim, "<>", "<>", _kDimPar, _kDimNone);
		dim.transformBy(ms2ps);
		dp.draw(dim);
	}
	else{
		arPtTotalDim.append(plOpening.vertexPoints(true));
		arPtTotalDim.append(arPtPerimeterDimX[0]);
		arPtTotalDim.append(arPtPerimeterDimX[arPtPerimeterDimX.length() - 1]);
	}
}
arPtTotalDim.append(arPtAllSheetsDimX[arPtAllSheetsDimX.length() - 1]);
arPtTotalDim.append(ptGBmTopRight);

if (!bDimensionPerOpening) {
	Point3d ptDim = ptGBmBottomLeft;
	if( nPosition == 0 || nPosition == 3 )
		ptDim = ptGBmTopRight;	
	ptDim += vyDim * nSideOffset * dOffsetDim;

	DimLine dimLine(ptDim, vxDim, vyDim);
	Dim dim(dimLine, arPtTotalDim, "<>", "<>", _kDimPar, _kDimNone);
	dim.transformBy(ms2ps);
	dp.draw(dim);
}








#End
#BeginThumbnail




#End