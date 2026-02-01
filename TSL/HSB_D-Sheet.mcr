#Version 8
#BeginDescription
#Versions
1.22 21.07.2023 HSB-19566 dim read direction corrected






#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 22
#KeyWords 
#BeginContents
/// <history>
// #Versions
// 1.22 21.07.2023 HSB-19566 dim read direction corrected , Author Thorsten Huck
/// </history>
//region History
/// <summary Lang=en>
/// Place dimension lines per sheet
/// </summary>

/// <insert>
/// Select a position
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.20" date="07.06.2019"></version>

/// <history>
/// AS - 1.00 - 27.02.2013 -  Pilot version.
/// AS - 1.01 - 13.12.2013 -  Add filters
/// AS - 1.02 - 28.03.2014 -  Add option to show material and sheet size
/// AS - 1.03 - 08.04.2014 -  Correct position for rotated sheets
/// AS - 1.04 - 15.07.2014 -  Use transformed ps vectors for dim calculations
/// AS - 1.05 - 13.10.2014 -  Use slice of realbody io profshape.
/// AS - 1.06 - 27.11.2014 -  Return if no points found.
/// AS - 1.07 - 29.06.2015 -  Text is now aligned with sheet. Offset options added.
/// AS - 1.08 - 02.07.2015 -  Sheet edge dimension is now optional.
/// DR - 1.09 - 31.05.2017	- Dimensioning to center instead of extremes when opening is a circle
///							- Added angle notation when != than 90
///							- Added dimension (text) on angled sides
/// DR - 1.10 - 07.06.2017	- Dimension angles No/Yes prop. added
/// YB  - 1.11 - 21.06.2017  	- Added option to disable extension lines
/// DR - 1.12 - 20.07.2017	- Fixed wrong orientation of diagonal dimensioning
/// DR - 1.13 - 22.01.2018	- Added option to set precision for angled dimensioning
/// DR - 1.14 - 23.01.2018	- Fixed display vectors for material text displaying when sheet piece is rotated
/// RP - 1.15 - 06.02.2018	- Converttolineapprox when vertexpoints of opening is bigger then 6. Otherwise pline extremes are not correct
/// AS - 1.16 - 06.04.2018	- Correct offsets angled dimension text next to sheet edges. 
/// DR - 1.17 - 21.01.2019	- Issue with text orientation when dimensioning at sheet edges fixed
///						- Added offset for angle dimensioning
///						- Arc size for angle dimensioning now proporcional to dimstyle
/// DR - 1.18 - 22.01.2019	- Added functionality for single angled sheet
/// DR - 1.19 - 28.02.2019	- Description of sDimSheetExtremes improved
//RVW - 1.20 - 07-06-2019	- Add option to choose wheter the crossing in the opening has to be shown or not.
/// </history>
//endregion

//region OPM and general variables
double dEps = Unit(0.01,"mm");
int bOnDebug=true;
int arNZone[] = {1,2,3,4,5,6,7,8,9,10};

String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};

String arSInfo[] = {
	T("|No information|"),
	T("|Material|"),
	T("|Sheet size|"),
	T("|Material and sheet size|")
};

String arSDimSheetEdge[] = {
	T("|No dimension|"),
	T("|At sheet edges|"),
	T("|Dimension lines|")
};

String arSDimAnglesPrecision[] = 
{
	"0",
	"0.0",
	"0.00",
	"0.000",
	"0.0000"
};

String arSInExclude[] = {T("|Include|"), T("|Exclude|")};
/// - Selection -
///
PropString sSeperator01(0, "", T("|Selection|"));
sSeperator01.setReadOnly(true);
PropString sInExcludeFilters(14, arSInExclude, "     "+T("|Include|")+T("/|exclude|"),1);
PropString sFilterBC(15,"","     "+T("|Filter beamcode|"));
PropString sFilterMaterial(16,"","     "+T("|Filter material|"));
PropString sFilterLabel(17,"","     "+T("|Filter label|"));


/// - Dimension object -
/// 
PropString sSeperator02(1, "", T("|Dimension Object|"));
sSeperator02.setReadOnly(true);
PropInt nZoneProp(0,arNZone, "     "+T("|Zone|"));
PropString sDimPerimeter(2, arSYesNo, "     "+T("|Dimension perimeter|"));
PropString sDimSheetEdges(3, arSDimSheetEdge, "     "+T("|Dimension sheet edges|"),1);
PropString sDimSheetExtremes(13, arSYesNo, "     "+T("|Dimension extremes per sheet|"));
sDimSheetExtremes.setDescription(T("|Extremes are only dimensioned when 'Dimension sheet edges' property is set to| ") + T("'|At sheet edges|'"));
PropString sDimAngles(18, arSYesNo, "     "+T("|Dimension angles|"), 1);
PropString sDimAnglesPrecision(20, arSDimAnglesPrecision, "     "+"     "+T("|Precision|"), 0);
sDimAnglesPrecision.setDescription(T("|Precision for angled dimension only|"));
PropString sShowInfo(4, arSInfo, "     "+T("|Show material information|"));
PropString sLinesInOpening(21, arSYesNo, "     "+ T("|Show crossing in opening|"));
sLinesInOpening.setDescription(T("|Choose if a crossing has to be visible in the openings|"));
PropString sDimensionOpening(22, arSYesNo, "     "+ T("|Dimension openings|"));

reportMessage(T("|Extremes are only dimensioned when 'Dimension sheet edges' property is set to| ") + T("'|At sheet edges|'"));


/// - Positioning -
/// 
PropString sSeperator03(5, "", T("|Positioning|"));
sSeperator03.setReadOnly(true);
PropString sUsePSUnits(6, arSYesNo, "     "+T("|Offset in paperspace units|"));
PropDouble dOffsetPerimeter(2, U(6), "     "+T("|Offset perimeter|"));
PropDouble dOffsetShEdges(1,U(1), "     "+T("|Offset sheet edges|"));
PropDouble dOffsetShExtremes(0, U(6), "     "+T("|Offset extremes per sheet|"));
PropDouble dOffsetAngles (5, U(5), "     "+T("|Offset angles|"));
PropDouble dxOffsetInfo(3, U(0), "     "+T("X-|offset information|"));
PropDouble dyOffsetInfo(4, U(0), "     "+T("Y-|offset information|"));

/// - Style -
/// 
PropString sSeperator04(7, "", T("|Style|"));
sSeperator04.setReadOnly(true);
PropString sDimStyle(8,_DimStyles, "     "+T("|Dimension style|"));
PropInt nDimColor(1,1,"     "+T("|Color|"));
PropInt nColorOpening(2, 7, "     "+T("|Line color|"));
PropString sLineType(9, _LineTypes, "     "+T("|Line type|"));
PropString drawExtensionLines(19,  arSYesNo, "     " + T("|Draw extension lines|"));

/// - Name and description -
/// 
PropString sSeperator05(10, "", T("|Name and description|"));
sSeperator05.setReadOnly(true);
PropInt nColorName(3, -1, "     "+T("|Default name color|"));
PropInt nColorActiveFilter(4, 30, "     "+T("|Filter other element color|"));
PropInt nColorActiveFilterThisElement(5, 1, "     "+T("|Filter this element color|"));
PropString sDimStyleName(11, _DimStyles, "     "+T("|Dimension style name|"));
PropString sInstanceDescription(12, "", "     "+T("|Extra description|"));


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
//endregion

//region bOnInsert
if( _bOnInsert ){
	//Erase after 1 cycle
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	_Viewport.append(getViewport("\nSelecteer een viewport"));
	_Pt0 = getPoint("Selecteer een positie");

	//Showdialog
	if (_kExecuteKey=="")
		showDialog();
	
	return;
}
//endregion

// Draw name
String sInstanceNameAndDescription = _ThisInst.scriptName();
if( sInstanceDescription.length() > 0 )
	sInstanceNameAndDescription += (" - "+sInstanceDescription);

Display dpName(nColorName);
dpName.dimStyle(sDimStyleName);
dpName.draw(sInstanceNameAndDescription, _Pt0, _XW, _YW, 1, 2);

double dTextHeightName = dpName.textHeightForStyle("HSB", sDimStyleName);

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

Display dpMat(nDimColor);
dpMat.dimStyle(sDimStyle);

Display dpOpening(nColorOpening);
dpOpening.dimStyle(sDimStyle, dVpScale);
dpOpening.lineType(sLineType);


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
int bExclude = arSInExclude.find(sInExcludeFilters,1);

String sFBC = sFilterBC + ";";
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

	arSFBC.append(sTokenBC);
}
String sFMaterial = sFilterMaterial + ";";
String arSFMaterial[0];
int nIndexMaterial = 0; 
int sIndexMaterial = 0;
while(sIndexMaterial < sFMaterial.length()-1){
	String sTokenMaterial = sFMaterial.token(nIndexMaterial);
	nIndexMaterial++;
	if(sTokenMaterial.length()==0){
		sIndexMaterial++;
		continue;
	}
	sIndexMaterial = sFilterMaterial.find(sTokenMaterial,0);

	arSFMaterial.append(sTokenMaterial);
}
String sFLabel = sFilterLabel + ";";
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


//Dimension object
int nZone = nZoneProp;
if( nZone > 5 ){
	nZone = -(nZoneProp - 5);
}

int bDrawExtensionLines = arSYesNo.find(drawExtensionLines, 0) == 1;
int bDimPerimeter = arNYesNo[arSYesNo.find(sDimPerimeter,0)];
int nDimSheetEdges = arSDimSheetEdge.find(sDimSheetEdges,1);
int bDimSheetExtremes = arNYesNo[arSYesNo.find(sDimSheetExtremes,0)];
int bDimAngles= arNYesNo[arSYesNo.find(sDimAngles,0)];
int nDimAnglesPrecision = arSDimAnglesPrecision.find(sDimAnglesPrecision,0);
int nShowInfo = arSInfo.find(sShowInfo,0);
int bLinesInOpening = arNYesNo[arSYesNo.find(sLinesInOpening, 0)];
int bDimensionOpening = arNYesNo[arSYesNo.find(sDimensionOpening, 0)]; 
//Position
int bUsePSUnits = arNYesNo[arSYesNo.find(sUsePSUnits,1)];
double dOffsetDimShEdges = dOffsetShEdges;
double dOffsetDimPerimeter = dOffsetPerimeter;
double dOffsetDimShExtremes = dOffsetShExtremes;
double dOffsetDimAngles = dOffsetAngles / dVpScale;
if ( bUsePSUnits )
{
	dOffsetDimShEdges *= dVpScale;
	dOffsetDimPerimeter *= dVpScale;
	dOffsetDimShExtremes *= dVpScale;
	dOffsetDimAngles *= dVpScale;	
}

Line lnX(ptEl, vxEl);
Line lnY(ptEl, vyEl);

Vector3d vxMs = _XW;
vxMs.transformBy(ps2ms);
vxMs.normalize();
Vector3d vyMs = _YW;
vyMs.transformBy(ps2ms);
vyMs.normalize();

GenBeam arGBmAll[] = el.genBeam();
GenBeam arGBm[0];
Beam arBm[0];
Sheet arSh[0];
for(int i=0;i<arGBmAll.length();i++){
	GenBeam gBm = arGBmAll[i];
	Beam bm = (Beam)gBm;
	Sheet sh = (Sheet)gBm;
	
	// apply filters
	String sBmCode = gBm.beamCode().token(0);
	String sMaterial = gBm.material();
	String sLabel = gBm.label();
	
	int bFilterGenBeam = false;
	if( arSFBC.find(sBmCode) != -1 )
		bFilterGenBeam = true;
	if( arSFMaterial.find(sMaterial) != -1 )
		bFilterGenBeam = true;
	if( arSFLabel.find(sLabel) != -1 )
		bFilterGenBeam = true;
		
	if( (bFilterGenBeam && !bExclude) || (!bFilterGenBeam && bExclude) ){
		if( sh.bIsValid() )
			arSh.append(sh);
		else if( bm.bIsValid() )
			arBm.append(bm);
		
		arGBm.append(gBm);
	}
}

Point3d arPtShAll[0];
Sheet shValids[0];
PlaneProfile ppZn(csEl);
for( int i=0;i<arSh.length();i++ ){
	Sheet sh = arSh[i];
	
	if( sh.myZoneIndex() != nZone )continue;
	if( sh.bIsDummy() )continue;
	
	shValids.append(sh);

	PLine plSh= sh.plEnvelope();
	Vector3d vxSh = sh.vecX();
	
	int bIsAngledSheet = false; // special case
	if ( ! vxSh.isParallelTo(vxEl) && !vxSh.isParallelTo(vyEl))
	{
		bIsAngledSheet = true;
	}
	
	if ( nShowInfo > 0 ) {
		int bRotate = false;
		
		double dShW = sh.solidWidth();
		double dShH = sh.solidLength();
		if ( dShW > dShH ) {
			double dTmp = dShW;
			dShW = dShH;
			dShH = dTmp;
			
			bRotate = true;
		}
		
		String sMatInfo = sh.material();
		if ( nShowInfo == 2 || nShowInfo == 3) {
			String sShW;
			sShW.formatUnit(dShW, 2, 0);
			String sShH;
			sShH.formatUnit(dShH, 2, 0);
			
			if ( nShowInfo == 2 )
				sMatInfo = sShW + "x" + sShH;
			else
				sMatInfo += " / " + sShW + "x" + sShH;
		}
		
		Vector3d vxMat = sh.vecX();
		Vector3d vyMat = sh.vecY();
		if ( bRotate ) {
			vxMat = sh.vecY();
			vyMat = sh.vecX();
		}
		vxMat.transformBy(ms2ps);
		vxMat.normalize();
		vyMat.transformBy(ms2ps);
		vyMat.normalize();
		if (vxMat.dotProduct(_XW + _YW) < 0)
			vxMat *= -1;
		if (vyMat.dotProduct(-_XW + _YW) < 0)
			vyMat *= -1;
		
		Point3d ptMat = sh.envelopeBody().ptCen();
		ptMat.transformBy(ms2ps);
		ptMat = ptMat + vxMat * dxOffsetInfo + vyMat * dyOffsetInfo;
		
		double dxFlag = 0;
		double dyFlag = 0;
		
		//correct display vectors if sheet is rotated
		if (1 - abs(_ZW.dotProduct(vyMat)) < U(0.01))
		{
			vyMat = vyMat.rotateBy(90, vxMat);
			if (vyMat.dotProduct(_XW) > 0)
				vyMat = - vyMat;
		}
		if (1 - abs(_ZW.dotProduct(vxMat)) < U(0.01))
		{
			vxMat = vxMat.rotateBy(90, vyMat);
			if (vxMat.dotProduct(_XW) > 0)
				vxMat = - vxMat;
		}
		
		if (bIsAngledSheet) //special case
		{
			if (vxMat.dotProduct(_XW) < 0 )
				vxMat *= -1;
			if (vyMat.dotProduct(_YW) < 0 )
				vyMat *= -1;
		}
		
		dpMat.draw(sMatInfo, ptMat, vxMat, vyMat, dxFlag, dyFlag);
		
		 vxMat.vis(ptMat, 1);vyMat.vis(ptMat, 3);
	}
	
	PlaneProfile ppSh = sh.realBody().getSlice(Plane(sh.ptCen(), vzEl));//sh.profShape();
	ppZn.unionWith(ppSh);
	PLine arPl[] = ppSh.allRings();
	int arNPlIsRing[] = ppSh.ringIsOpening();

	Point3d ptReference = sh.envelopeBody().ptCen();

	PLine arPlPerimeter[0];
	PLine arPlOpening[0];
	
	Point3d arPtSh[0];	
	for( int j=0;j<arPl.length();j++ ){
		PLine pl = arPl[j];
		
		if( arNPlIsRing[j] && bDimensionOpening)
			arPlOpening.append(pl);
		else
			arPlPerimeter.append(pl);
		
		Point3d arPtPl[]= pl.vertexPoints(true);
		if(arNPlIsRing[j] && arPtPl.length()==2)//ring is an opening and is a circle
		{
			Point3d pt1= arPtPl[0];
			Point3d pt2= arPtPl[arPtPl.length()-1];
			Vector3d v1(pt2-pt1); v1.normalize();
			Point3d ptCenter= pt1+v1*(pt2-pt1).length()*.5;
			arPtSh.append(ptCenter);
		}
		else
			arPtSh.append(pl.vertexPoints(true));
	}
	
	arPtShAll.append(arPtSh);

	//region dimension angled segments
	Point3d ptShAllVertex[]= plSh.vertexPoints(false);
	Point3d ptShCen; ptShCen.setToAverage(ptShAllVertex);
	for (int p=0;p<ptShAllVertex.length()-1;p++)
	{
		Point3d pt1= ptShAllVertex[p];
		Point3d pt2= ptShAllVertex[p+1];
		int sideLength= (pt2-pt1).length();//Made int to get no decimals of mm
		Vector3d vSide(pt2-pt1); 
		vSide.normalize();
		Point3d ptMid= (pt1+pt2)/2;
		Vector3d vxDimAngled=vSide; vxDimAngled.normalize();
		if(abs(vxDimAngled.dotProduct(vxEl))<dEps || abs(vxDimAngled.dotProduct(vyEl))<dEps)//Is perpendicular to vxEl or vyEl
			continue;
		Vector3d vyDimAngled= vxDimAngled.crossProduct(vzEl); vyDimAngled.normalize();
		Vector3d vxDimAngledPS= vxDimAngled; vxDimAngledPS.transformBy(ms2ps);
		Vector3d vyDimAngledPS= vyDimAngled; vyDimAngledPS.transformBy(ms2ps);
		
		if(vxDimAngledPS.dotProduct(_XW)<0)
			vxDimAngledPS=-vxDimAngledPS;

		if(vyDimAngledPS.dotProduct(_YW)<0)
			vyDimAngledPS=-vyDimAngledPS;		
		
		if(nDimSheetEdges == 1)//Dimension sheet edges: "|At sheet edges|", this will draw the dimension of an angled edge with just a text over it
		{
			double yFlag = -1;
			Vector3d vy = vyDimAngledPS;
			vy.transformBy(ps2ms);
			vy.normalize();
			
			if (ppSh.pointInProfile(ptMid + vy * U(5)) == _kPointInProfile)
			{
				yFlag *= -1;
			}
			Point3d ptText= ptMid+vy * yFlag * dOffsetDimShEdges;
			ptText.transformBy(ms2ps);
			dp.draw(sideLength, ptText, vxDimAngledPS, vyDimAngledPS, 0, yFlag);
		}
	}
	
	//Dimension angles if != 90, this will draw the angle value and the arc
	if(bDimAngles)
	{
		plSh.transformBy(ms2ps);
		ptShAllVertex= plSh.vertexPoints(true);
		for (int p = 0; p < ptShAllVertex.length(); p++)
		{
			Point3d ptCen = ptShAllVertex[p];
			Point3d pt1, pt2;
			if (p == 0)
			{
				pt1 = ptShAllVertex[p + 1];
				pt2 = ptShAllVertex[ptShAllVertex.length() - 1];
			}
			else if (p == ptShAllVertex.length() - 1)
			{
				pt2 = ptShAllVertex[p - 1];
				pt1 = ptShAllVertex[0];
			}
			else
			{
				pt1 = ptShAllVertex[p + 1];
				pt2 = ptShAllVertex[p - 1];
			}
			Vector3d v1 = pt1 - ptCen;v1.normalize();
			Vector3d v2 = pt2 - ptCen;v2.normalize();
			
			if ( abs(v1.dotProduct(v2)) < dEps)//Vectors are perpendicular
			{
				continue;
			}
			
			// draw arc
			double dAngle = v1.angleTo(v2);
			double dRadius = dp.textHeightForStyle("X", sDimStyle) * 3;
			Point3d ptV1 = ptCen + v1 * dRadius;
			Point3d ptV2 = ptCen + v2 * dRadius;
			Vector3d vNormal = v1.crossProduct(v2);
			PLine plAngle(vNormal);
			plAngle.addVertex(ptV1);
			plAngle.addVertex(ptV2, dRadius, false, true);
			Vector3d vOffset(plAngle.ptMid() - ptCen);
			vOffset.normalize();
			dp.draw(plAngle);
			
			// draw text (angle value)
			Point3d ptText = plAngle.ptMid() + vOffset * dOffsetDimAngles;
			String sFormat = "%." + nDimAnglesPrecision + "f";
			String sAngle; sAngle.format(sFormat, dAngle);
			dp.draw(sAngle, ptText, _XW, _YW, 0, 0, _kDeviceX);
		}
	}
	//endregion

	if( nDimSheetEdges == 1)//Dimension sheet edges: "|At sheet edges|" (just text over edge)
	{	
		double arDDimSh[0];
		double dShElX = 0;
		double dShElY = 0;
		String arSDimSh[0];
		String sShElX;
		String sShElY;
		Point3d arPtDimHor[0];
		Point3d arPtDimVer[0];
		Point3d ptShM;
		for( int j=0;j<arPlPerimeter.length();j++ ){
			PLine pl = arPlPerimeter[j];
			
			PlaneProfile ppPl(CoordSys(sh.ptCen(), sh.vecX(), sh.vecY(), sh.vecZ()));
			ppPl.joinRing(pl, _kAdd);
			
			Point3d arPtPl[] = pl.vertexPoints(false);
			Point3d arPtPlX[] = lnX.orderPoints(arPtPl);
			Point3d arPtPlY[] = lnY.orderPoints(arPtPl);
			if( arPtPlX.length() == 0 || arPtPlY.length() == 0 )
				continue;
			
			Point3d ptShL = arPtPlX[0];
			Point3d ptShR = arPtPlX[arPtPlX.length() - 1];
			arPtDimHor.append(ptShL);
			arPtDimHor.append(ptShR);
			Point3d ptShB = arPtPlY[0];
			Point3d ptShT = arPtPlY[arPtPlY.length() - 1];
			arPtDimVer.append(ptShB);
			arPtDimVer.append(ptShT);
			
			ptShM = (ptShL + ptShR)/2;
			ptShM += vyEl * vyEl.dotProduct(((ptShB + ptShT)/2) - ptShM);
			
			dShElX = vxEl.dotProduct(ptShR - ptShL);
			sShElX.formatUnit(dShElX, 2, 0);
			dShElY = vyEl.dotProduct(ptShT - ptShB);
			sShElY.formatUnit(dShElY, 2, 0);
			
			int bPlIsReversed = false;
			for( int k=0;k<(arPtPl.length() - 1);k++ ){
				Point3d ptFrom = arPtPl[k];
				Point3d ptTo = arPtPl[k+1];
				
				Point3d ptMid = (ptTo + ptFrom)/2;
				ptMid.transformBy(ms2ps);
				
				Vector3d vLnSeg(ptTo - ptFrom);
				double dDim = vLnSeg.length();
				vLnSeg.normalize();
				Vector3d vPerp = sh.vecD(vzEl).crossProduct(vLnSeg);
				if( k==0 && !bPlIsReversed && ppPl.pointInProfile((ptTo + ptFrom)/2 + vPerp) != _kPointInProfile ){
					
					pl.reverse();
					arPtPl = pl.vertexPoints(false);
					k = -1;
					bPlIsReversed = true;
					continue;
				}
				
				double dxDim = vLnSeg.dotProduct(vxEl);
				double dyDim = vLnSeg.dotProduct(vyEl);
				
				if( abs(dxDim) > dEps && abs(dyDim) > dEps ) // Angled
					continue;
				
				Point3d ptDim = (ptFrom + ptTo)/2 + vPerp * dOffsetDimShEdges;
				
				// PS
				Point3d ptDimPS = ptDim;
				ptDimPS.transformBy(ms2ps);
				Vector3d vLnSegPS = vLnSeg;
				vLnSegPS.transformBy(ms2ps);
				Vector3d vPerpPS = vPerp;
				vPerpPS.transformBy(ms2ps);
				
				Vector3d vxDimPS = vLnSegPS;
				vxDimPS.normalize(); //v1.17
				
				if( _XW.dotProduct(vxDimPS) < -dEps )
					vxDimPS *= -1;
				else if( _XW.dotProduct(vxDimPS) < dEps )
					vxDimPS = _YW;
				Vector3d vyDimPS = _ZW.crossProduct(vxDimPS);
				
				double dFlagY = 1;
				if( _YW.dotProduct(vPerpPS) < -dEps )
					dFlagY *= -1;
				else if( _YW.dotProduct(vPerpPS) < dEps && _XW.dotProduct(vPerpPS) > dEps )
					dFlagY *= -1;
				
				arDDimSh.append(dDim);
				String sDim;
				sDim.formatUnit(dDim, 2, 0);
				arSDimSh.append(sDim);
				
				dp.draw(sDim, ptDimPS, vxDimPS, vyDimPS, 0, dFlagY);
			}
		}
		
		if( bDimSheetExtremes && arSDimSh.find(sShElX) == -1 ){
			Vector3d vOffset = vyMs;
			Vector3d vxDim = vxMs;
			Vector3d vyDim = vyMs;
			DimLine dimLineHor(ptShM + vOffset * dOffsetDimShExtremes, vxDim, vyDim);
			Dim dimHor(dimLineHor, arPtDimHor, "<>","<>", _kDimDelta, _kDimNone);
			dimHor.transformBy(ms2ps);
			dp.draw(dimHor);
		}
		if( bDimSheetExtremes && arSDimSh.find(sShElY) == -1 ){
			Vector3d vOffset = -vxMs;
			Vector3d vxDim = vyMs;
			Vector3d vyDim = -vxMs;
			DimLine dimLineVer(ptShM + vOffset * dOffsetDimShExtremes, vxDim, vyDim);
			Dim dimVer(dimLineVer, arPtDimVer, "<>","<>", _kDimDelta, _kDimNone);
			dimVer.transformBy(ms2ps);
			dp.draw(dimVer);
		}
	}
	else if (nDimSheetEdges == 2)//Dimension sheet edges: "|Dimension lines|"
	{
		if (bIsAngledSheet)
		{
			//dim every edge
			for (int p = 0; p < ptShAllVertex.length() - 1; p++)
			{
				Point3d pt1 = ptShAllVertex[p];
				Point3d pt2 = ptShAllVertex[p + 1];
				Point3d ptMid = (pt1 + pt2) / 2;
								
				Point3d pt1PS=pt1; pt1PS.transformBy(ms2ps);
				Point3d pt2PS=pt2; pt2PS.transformBy(ms2ps);

				Vector3d vxDimAngled = (pt2-pt1); vxDimAngled.normalize();
				Vector3d vyDimAngled = vxDimAngled.crossProduct(vzEl); vyDimAngled.normalize();
				if((ptMid - sh.ptCenSolid()).dotProduct(vyDimAngled) < 0)
					vyDimAngled *= -1;
				Vector3d vxDimAngledPS = vxDimAngled; vxDimAngledPS.transformBy(ms2ps); vxDimAngledPS.normalize();
				Vector3d vyDimAngledPS = vyDimAngled; vyDimAngledPS.transformBy(ms2ps); vyDimAngledPS.normalize();


				Point3d ptDim = ptMid + vyDimAngled * dOffsetDimShEdges;
				Point3d ptDimPS=ptDim; ptDimPS.transformBy(ms2ps);
				
				
			// HSB-19566 dim read direction corrected	
				if (vxDimAngledPS.dotProduct(_XW) < 0 || vxDimAngledPS.isCodirectionalTo(-_YW))
					vxDimAngledPS *= -1;
				vyDimAngledPS =	vxDimAngledPS.crossProduct(-_ZW);				
//				if (vxDimAngledPS.dotProduct(_XW) < 0)
//					vxDimAngledPS = - vxDimAngledPS;
//				if (vyDimAngledPS.dotProduct(_YW) < 0)
//					vyDimAngledPS = - vyDimAngledPS;

				DimLine dimLn (ptDimPS, vxDimAngledPS, vyDimAngledPS);
				Point3d pts[] = { pt1PS, pt2PS};
				Dim dim (dimLn, pts, "<>","<>", _kDimDelta, _kDimNone);
				dp.draw(dim);
				
			}

			continue;
		}
		
		Point3d arPtRight[0];
		Point3d arPtLeft[0];
		Point3d arPtTop[0];
		Point3d arPtBottom[0];
		
		for( int j=0;j<arPtSh.length();j++ ){
			Point3d pt = arPtSh[j];
			
			if( vxEl.dotProduct(pt - ptReference) > 0 ){
				arPtRight.append(pt);
			}
			else{
				arPtLeft.append(pt);
			}
			
			if( vyEl.dotProduct(pt - ptReference) > 0 ){
				arPtTop.append(pt);
			}
			else{
				arPtBottom.append(pt);
			}
		}
		
		int bDXSet = FALSE;
		double dMinX;
		double dMaxX;
		Point3d arPtMinX[0];
		Point3d arPtMaxX[0];
		
		int bDYSet = FALSE;
		double dMinY;
		double dMaxY;
		Point3d arPtMinY[0];
		Point3d arPtMaxY[0];
		for( int j=0;j<arPtSh.length();j++ ){
			Point3d pt = arPtSh[j];
			
			double dDX = vxMs.dotProduct(pt - ptEl);
			if( !bDXSet ){
				bDXSet = TRUE;
				dMinX = dDX;
				dMaxX = dDX;
				arPtMinX.append(pt);
				arPtMaxX.append(pt);
			}
			else{
				if( abs(dMinX - dDX) < dEps  ){
					arPtMinX.append(pt);
				}
				if( (dMinX - dDX) > dEps ){
					arPtMinX.setLength(0);
					arPtMinX.append(pt);
					dMinX = dDX;
				}
				if( abs(dDX - dMaxX) < dEps ){
					arPtMaxX.append(pt);
				}
				if( (dDX - dMaxX) > dEps ){
					arPtMaxX.setLength(0);
					arPtMaxX.append(pt);
					dMaxX = dDX;
				}
			}
			
			double dDY = vyMs.dotProduct(pt - ptEl);
			if( !bDYSet ){
				bDYSet = TRUE;
				dMinY = dDY;
				dMaxY = dDY;
				arPtMinY.append(pt);
				arPtMaxY.append(pt);
			}
			else{
				if( abs(dMinY - dDY) < dEps  ){
					arPtMinY.append(pt);
				}
				if( (dMinY - dDY) > dEps ){
					arPtMinY.setLength(0);
					arPtMinY.append(pt);
					dMinY = dDY;
				}
				if( abs(dDY - dMaxY) < dEps ){
					arPtMaxY.append(pt);
				}
				if( (dDY - dMaxY) > dEps ){
					arPtMaxY.setLength(0);
					arPtMaxY.append(pt);
					dMaxY = dDY;
				}
			}
		}
		
		Line lnSortY(ptEl,vyMs);
		//MinX
		arPtMinX = lnSortY.orderPoints(arPtMinX);
		if( arPtMinX.length() == 0 ) {
			reportWarning(T("\nLET OP: geen punten aan de linkerkant gevonden"));
			return;
		}
		
		Point3d ptMinXMinY = arPtMinX[0];
		Point3d ptMinXMaxY = arPtMinX[arPtMinX.length() -1];
		
		//MaxX
		arPtMaxX = lnSortY.orderPoints(arPtMaxX);
		if( arPtMaxX.length() == 0 ) {
			reportWarning(T("\nLET OP: geen punten aan de rechterkant gevonden"));
			return;
		}
		
		Point3d ptMaxXMinY = arPtMaxX[0];
		Point3d ptMaxXMaxY = arPtMaxX[arPtMaxX.length() -1];
		
		Line lnSortX(ptEl,vxMs);
		//MinY
		arPtMinY = lnSortX.orderPoints(arPtMinY);
		if( arPtMinY.length() == 0 ){
			reportWarning(T("\nLET OP: geen punten aan de onderkant gevonden"));
			return;
		}
		
		Point3d ptMinYMinX = arPtMinY[0];
		Point3d ptMinYMaxX = arPtMinY[arPtMinY.length() -1];
		
		//MaxY
		arPtMaxY = lnSortX.orderPoints(arPtMaxY);
		if( arPtMaxY.length() == 0 ) {
			reportWarning(T("\nLET OP: geen punten aan de bovenkant gevonden"));
			return;
		}
		
		Point3d ptMaxYMinX = arPtMaxY[0];
		Point3d ptMaxYMaxX = arPtMaxY[arPtMaxY.length() -1];
		
		
		//Dimension lines
		//Left
		Point3d arPtDimLeft[] = {
			ptMinYMinX,
			ptMinXMinY,
			ptMinXMaxY,
			ptMaxYMinX
		};
		arPtDimLeft.append(arPtLeft);
		
		Line lnDimLeft(ptMinXMinY - vxMs * dOffsetDimShEdges, vyMs);
		
		//arPtDimLeft = lnDimLeft.projectPoints(arPtDimLeft);
		arPtDimLeft = lnDimLeft.orderPoints(arPtDimLeft,U(.1));
		Point3d arPtDimTmp[0];
		for( int j=1;j<arPtDimLeft.length();j++ ){
			Point3d ptPrev = arPtDimLeft[j-1];
			Point3d ptThis = arPtDimLeft[j];
			if( j==1 ){
				arPtDimTmp.append(ptPrev);
			}
			if( abs(vyMs.dotProduct(ptThis - ptPrev)) > U(.1) ){
				arPtDimTmp.append(ptThis);
			}
		}
		arPtDimLeft = arPtDimTmp;
		arPtDimTmp.setLength(0);
		
		if(bDrawExtensionLines)
			arPtDimLeft = Line(arPtDimLeft[0] - vxMs * dOffsetDimShEdges, vyMs).projectPoints(arPtDimLeft);
		
		if( arPtDimLeft.length() > 2 ){
			DimLine dimLineLeft(ptMinXMinY - vxMs * dOffsetDimShEdges, vyMs, -vxMs);
			Dim dimLeft(dimLineLeft, arPtDimLeft, "<>","<>", _kDimDelta, _kDimNone);
			dimLeft.transformBy(ms2ps);
			dp.draw(dimLeft);
		}
		
		//Right
		Point3d arPtDimRight[] = {
			ptMinYMaxX,
			ptMaxXMinY,
			ptMaxXMaxY,
			ptMaxYMaxX
		};
		arPtDimRight.append(arPtRight);
		
		Line lnDimRight(ptMaxXMinY + vxMs * dOffsetDimShEdges, vyMs);
		//arPtDimRight = lnDimRight.projectPoints(arPtDimRight);
		arPtDimRight = lnDimRight.orderPoints(arPtDimRight,U(.1));
		for( int j=1;j<arPtDimRight.length();j++ ){
			Point3d ptPrev = arPtDimRight[j-1];
			Point3d ptThis = arPtDimRight[j];
			
			if( j==1 ){
				arPtDimTmp.append(ptPrev);
			}
			
			int bPtAllreadyDimmed = FALSE;
			if( j!=(arPtDimRight.length() - 1) ){
				for( int k=0;k<arPtLeft.length();k++ ){
					Point3d ptL = arPtLeft[k];
					if( abs(vxMs.dotProduct(ptThis - ptL)) < U(.1) ){
						//Point is dimmed at left side
						bPtAllreadyDimmed = TRUE;
						break;
					}
				}
				if( bPtAllreadyDimmed ) continue;
			}
			
			if( abs(vyMs.dotProduct(ptThis - ptPrev)) > U(.1) ){
				arPtDimTmp.append(ptThis);
			}
		}
		arPtDimRight = arPtDimTmp;
		arPtDimTmp.setLength(0);
		
		if(bDrawExtensionLines)
 			arPtDimRight = Line(arPtDimRight[0] + vxMs * dOffsetDimShEdges, vyMs).projectPoints(arPtDimRight);			
		
		if( arPtDimRight.length() > 2 ){
			DimLine dimLineRight(ptMaxXMinY + vxMs * dOffsetDimShEdges, vyMs, -vxMs);
			Dim dimRight(dimLineRight, arPtDimRight, "<>","<>", _kDimDelta, _kDimNone);
			dimRight.transformBy(ms2ps);
			dp.draw(dimRight);
		}
			
		//Bottom
		Point3d arPtDimBottom[] = {
			ptMinXMinY,
			ptMinYMinX,
			ptMinYMaxX,
			ptMaxXMinY
		};
		arPtDimBottom.append(arPtBottom);
		
		Line lnDimBottom(ptMinYMinX - vyMs * dOffsetDimShEdges, vxMs);
		//arPtDimBottom = lnDimBottom.projectPoints(arPtDimBottom);
		arPtDimBottom = lnDimBottom.orderPoints(arPtDimBottom,U(.1));
		for( int j=1;j<arPtDimBottom.length();j++ ){
			Point3d ptPrev = arPtDimBottom[j-1];
			Point3d ptThis = arPtDimBottom[j];
			if( j==1 ){
				arPtDimTmp.append(ptPrev);
			}
			if( abs(vxMs.dotProduct(ptThis - ptPrev)) > U(.1) ){
				arPtDimTmp.append(ptThis);
			}
		}
		arPtDimBottom = arPtDimTmp;
		arPtDimTmp.setLength(0);
		
		if(bDrawExtensionLines)
 			arPtDimBottom = Line(arPtDimBottom[0] - vyMs * dOffsetDimShEdges, vxMs).projectPoints(arPtDimBottom);			
	
		if( arPtDimBottom.length() > 2 ){
			DimLine dimLineBottom(ptMinYMinX - vyMs * dOffsetDimShEdges, vxMs, vyMs);
			Dim dimBottom(dimLineBottom, arPtDimBottom, "<>","<>", _kDimDelta, _kDimNone);
			dimBottom.transformBy(ms2ps);
			dp.draw(dimBottom);
		}
	
		//Top
		Point3d arPtDimTop[] = {
			ptMinXMaxY,
			ptMaxYMinX,
			ptMaxYMaxX,
			ptMaxXMaxY
		};
		arPtDimTop.append(arPtTop);
		
		Line lnDimTop(ptMaxYMinX + vyMs * dOffsetDimShEdges, vxMs);
		//arPtDimTop = lnDimTop.projectPoints(arPtDimTop);
		arPtDimTop = lnDimTop.orderPoints(arPtDimTop,U(.1));
		for( int j=1;j<arPtDimTop.length();j++ ){
			Point3d ptPrev = arPtDimTop[j-1];
			Point3d ptThis = arPtDimTop[j];
			
			if( j==1 ){
				arPtDimTmp.append(ptPrev);
			}		
			
			int bPtAllreadyDimmed = FALSE;
			if( j!=(arPtDimTop.length() - 1) ){
				for( int k=0;k<arPtBottom.length();k++ ){
					Point3d ptB = arPtBottom[k];
					if( abs(vxMs.dotProduct(ptThis - ptB)) < U(.1) ){
						//Point is dimmed at bottom side
						bPtAllreadyDimmed = TRUE;
						break;
					}
				}
				if( bPtAllreadyDimmed ) continue;
			}
			
			if( abs(vxMs.dotProduct(ptThis - ptPrev)) > U(.1) ){
				arPtDimTmp.append(ptThis);
			}
		}
		arPtDimTop = arPtDimTmp;
		arPtDimTmp.setLength(0);
		
		if(bDrawExtensionLines)
 			arPtDimTop = Line(arPtDimTop[0] + vyMs * dOffsetDimShEdges, vxMs).projectPoints(arPtDimTop);	
		
		if( arPtDimTop.length() > 2 ){
			DimLine dimLineTop(ptMaxYMinX + vyMs * dOffsetDimShEdges, vxMs, vyMs);
			Dim dimTop(dimLineTop, arPtDimTop, "<>","<>", _kDimDelta, _kDimNone);
			dimTop.transformBy(ms2ps);
			dp.color(5);
			dp.draw(dimTop);
		}
	}
}

if ( bDimPerimeter)
{
	if (shValids.length() == 1 && ! shValids[0].vecX().isParallelTo(vxEl) && !shValids[0].vecX().isParallelTo(vyEl)) //only 1 sheet and angled
	{
		Sheet sh = shValids[0];
		Vector3d vecXSh = sh.vecX(), vecYSh = sh.vecY();
		PlaneProfile ppSh = sh.realBody().getSlice(Plane(sh.ptCen(), vzEl));//sh.profShape();
		LineSeg lsSh = ppSh.extentInDir(vecXSh);
		Point3d ptCenSh = sh.ptCenSolid(), ptStartX = lsSh.ptStart(), ptEndX = lsSh.ptEnd();
		Point3d ptDimX, ptDimY;
		Vector3d vecXShPS = vecXSh; vecXShPS.transformBy(ms2ps); vecXShPS.normalize();
		if(vecXShPS.dotProduct(_XW) < 0)
		{
			vecXShPS *= -1;
			ptDimY = ptCenSh - vecXSh * dOffsetDimPerimeter;
		}
		else
		{
			ptDimY = ptCenSh + vecXSh * dOffsetDimPerimeter;
		}
		Point3d ptDimYPS=ptDimY; ptDimYPS.transformBy(ms2ps);
		
		Vector3d vecYShPS = vecYSh; vecYShPS.transformBy(ms2ps); vecYShPS.normalize();
		if (vecYShPS.dotProduct(_YW) < 0)
		{
			vecYShPS *= -1;
			ptDimX = ptCenSh + vecYSh * (sh.dD(vecYSh) * .5 + dOffsetDimPerimeter);
		}
		else
		{
			ptDimX = ptCenSh - vecYSh * (sh.dD(vecYSh) * .5 + dOffsetDimPerimeter);
		}
				
		Point3d ptDimXPS = ptDimX; ptDimXPS.transformBy(ms2ps);
		Point3d ptEndXPS=ptEndX; ptEndXPS.transformBy(ms2ps);
		Point3d ptStartXPS=ptStartX; ptStartXPS.transformBy(ms2ps);
		Point3d pts[] = { ptStartXPS, ptEndXPS};
		DimLine dimLnX (ptDimXPS, vecXShPS, vecYShPS);
		Dim dimX (dimLnX, pts, "<>","<>", _kDimDelta, _kDimNone);
		dp.draw(dimX);
		
		Point3d ptCenShPS=ptCenSh; ptCenShPS.transformBy(ms2ps);
		DimLine dimLnY(ptDimYPS, vecYShPS, -vecXShPS);
		Dim dimY (dimLnY, pts, "<>","<>", _kDimDelta, _kDimNone);
		dp.draw(dimY);
	}
	else
	{
		Line lnX(ptEl, vxMs);
		Line lnY(ptEl, vyMs);
		
		Point3d arPtShX[] = lnX.orderPoints(arPtShAll);
		Point3d arPtShY[] = lnY.orderPoints(arPtShAll);
		
		//Left
		Point3d arPtLeft[0];
		for ( int i = 0; i < arPtShX.length(); i++) {
			Point3d pt = arPtShX[i];
			
			if ( arPtLeft.length() == 0 ) {
				arPtLeft.append(pt);
				continue;
			}
			
			if ( abs(vxMs.dotProduct(arPtLeft[arPtLeft.length() - 1] - pt)) > U(0.1) )
				break;
			
			arPtLeft.append(pt);
		}
		if ( arPtLeft.length() > 1 ) {
			Point3d arPtDim[0];
			arPtDim.append(arPtLeft);
			
			Vector3d vOffset = - vxMs;
			Vector3d vxDim = vyMs;
			Vector3d vyDim = - vxMs;
			
			Point3d ptDim = arPtDim[0];
			
			if (bDrawExtensionLines)
				arPtDim = Line(arPtDim[0] - vxMs * dOffsetDimPerimeter, vyMs).projectPoints(arPtDim);
			
			DimLine dimLine(ptDim + vOffset * dOffsetDimPerimeter, vxDim, vyDim);
			Dim dim(dimLine, arPtDim, "<>", "<>", _kDimDelta, _kDimNone);
			dim.transformBy(ms2ps);
			dp.draw(dim);
		}
		
		// Right
		Point3d arPtRight[0];
		for ( int i = (arPtShX.length() - 1); i >= 0; i--) {
			Point3d pt = arPtShX[i];
			
			if ( arPtRight.length() == 0 ) {
				arPtRight.append(pt);
				continue;
			}
			
			if ( abs(vxMs.dotProduct(arPtRight[arPtRight.length() - 1] - pt)) > U(0.1) )
				break;
			
			arPtRight.append(pt);
		}
		if ( arPtRight.length() > 1 ) {
			Point3d arPtDim[0];
			arPtDim.append(arPtRight);
			
			Vector3d vOffset = vxMs;
			Vector3d vxDim = vyMs;
			Vector3d vyDim = - vxMs;
			
			Point3d ptDim = arPtDim[0];
			
			if (bDrawExtensionLines)
				arPtDim = Line(arPtDim[0] + vxMs * dOffsetDimPerimeter, vyMs).projectPoints(arPtDim);
			
			DimLine dimLine(ptDim + vOffset * dOffsetDimPerimeter, vxDim, vyDim);
			Dim dim(dimLine, arPtDim, "<>", "<>", _kDimDelta, _kDimNone);
			dim.transformBy(ms2ps);
			dp.draw(dim);
		}
		
		// Bottom
		Point3d arPtBottom[0];
		for ( int i = 0; i < arPtShY.length(); i++) {
			Point3d pt = arPtShY[i];
			
			if ( arPtBottom.length() == 0 ) {
				arPtBottom.append(pt);
				continue;
			}
			
			if ( abs(vyMs.dotProduct(arPtBottom[arPtBottom.length() - 1] - pt)) > U(0.1) )
				break;
			
			arPtBottom.append(pt);
		}
		if ( arPtBottom.length() > 1 ) {
			Point3d arPtDim[0];
			arPtDim.append(arPtBottom);
			
			Vector3d vOffset = - vyMs;
			Vector3d vxDim = vxMs;
			Vector3d vyDim = vyMs;
			
			Point3d ptDim = arPtDim[0];
			
			if (bDrawExtensionLines)
				arPtDim = Line(arPtDim[0] - vyMs * dOffsetDimPerimeter, vxMs).projectPoints(arPtDim);
			
			DimLine dimLine(ptDim + vOffset * dOffsetDimPerimeter, vxDim, vyDim);
			Dim dim(dimLine, arPtDim, "<>", "<>", _kDimDelta, _kDimNone);
			dim.transformBy(ms2ps);
			dp.draw(dim);
		}
		
		// Top
		Point3d arPtTop[0];
		for ( int i = (arPtShY.length() - 1); i >= 0; i--) {
			Point3d pt = arPtShY[i];
			
			if ( arPtTop.length() == 0 ) {
				arPtTop.append(pt);
				continue;
			}
			
			if ( abs(vyMs.dotProduct(arPtTop[arPtTop.length() - 1] - pt)) > U(0.1) )
				break;
			
			arPtTop.append(pt);
		}
		if ( arPtTop.length() > 1 ) {
			Point3d arPtDim[0];
			arPtDim.append(arPtTop);
			
			Vector3d vOffset = vyMs;
			Vector3d vxDim = vxMs;
			Vector3d vyDim = vyMs;
			
			Point3d ptDim = arPtDim[0];
			
			if (bDrawExtensionLines)
				arPtDim = Line(arPtDim[0] + vyMs * dOffsetDimPerimeter, vxMs).projectPoints(arPtDim);
			
			DimLine dimLine(ptDim + vOffset * dOffsetDimPerimeter, vxDim, vyDim);
			Dim dim(dimLine, arPtDim, "<>", "<>", _kDimDelta, _kDimNone);
			dim.transformBy(ms2ps);
			dp.draw(dim);
		}
	}
}

//region Display opening representation
ppZn.shrink(-U(20));
ppZn.shrink(U(20));

PLine arPlZn[] = ppZn.allRings();
int arBRingIsOpening[] = ppZn.ringIsOpening();

for( int i=0;i<arPlZn.length();i++ ){
	PLine pl = arPlZn[i];
	int bRingIsOpening = arBRingIsOpening[i];
	
	if( !bRingIsOpening )
		continue;
	
	pl.close();
	
	if (pl.vertexPoints(true).length() > 6)	pl.convertToLineApprox(U(0.01));

	Point3d arPtPl[] = pl.vertexPoints(true);

	Point3d arPtPlX[] = lnX.orderPoints(arPtPl);
	Point3d arPtPlY[] = lnY.orderPoints(arPtPl);
	
	if( arPtPlX.length() * arPtPlY.length() < 1 )
		continue;
	
	Point3d ptT = arPtPlY[arPtPlY.length() - 1];
	Point3d ptB = arPtPlY[0];
	Point3d ptR = arPtPlX[arPtPlX.length() - 1];
	Point3d ptL = arPtPlX[0];
	
	Point3d ptTL = ptL + vyEl * vyEl.dotProduct(ptT - ptL);
	Point3d ptBL = ptL + vyEl * vyEl.dotProduct(ptB - ptL);
	Point3d ptBR = ptR + vyEl * vyEl.dotProduct(ptB - ptR);
	Point3d ptTR = ptR + vyEl * vyEl.dotProduct(ptT - ptR);
	
	PLine plTR2BL(ptTR, ptBL);
	PLine plTL2BR(ptTL, ptBR);
	
	plTR2BL.transformBy(ms2ps);
	plTL2BR.transformBy(ms2ps);
	
	if (bLinesInOpening)
	{
		dpOpening.draw(plTR2BL);
		dpOpening.draw(plTL2BR);
	}

}
//endregion


#End
#BeginThumbnail
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
K?^@"M"L_0?\`D7=,_P"O2+_T`5H5Z:V("BBBF`4444`%%%%`!1110!__V5Z1
`





















#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS">
        <int nm="BREAKPOINT" vl="1275" />
        <int nm="BREAKPOINT" vl="732" />
        <int nm="BREAKPOINT" vl="1088" />
        <int nm="BREAKPOINT" vl="811" />
        <int nm="BREAKPOINT" vl="777" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-19566 dim read direction corrected" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="22" />
      <str nm="DATE" vl="7/21/2023 8:21:24 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Add option to not dimension openings" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="21" />
      <str nm="DATE" vl="4/26/2021 4:30:23 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End