#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
17.12.2018  -  version 1.04

This tsl draws and dimensions sheets from a specific zone. It only takes sheets which are not the xy-plane of the element on a layout, when the alignment filter is active. 
Example: This tsl can be used to dimension the sheets of a kneewall attached to a roof.

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl draws and dimensions sheets from a specific zone. It only takes sheets which are not the xy-plane of the element on a layout, when the alignment filter is active. 
/// Example: This tsl can be used to dimension the sheets of a kneewall attached to a roof.
/// </summary>

/// <insert>
/// 
/// </insert>

/// <remark Lang=en>
/// .
/// </remark>

/// <version  value="1.04" date="17.12.2018"></version>

/// <history>
/// AS - 1.00 - 08.05.2012 -	Pilot version
/// AS - 1.01 - 04.01.2016 -	Udpate description
/// AP - 1.02 - 03.05.2016 - Add Property rotate sheet
/// RP - 1.03 - 29.07.2016 - Check if aligned with dotproduct instead of is Parallel
/// RP - 1.04 - 17.12.2018 - Quantity not correct if more then 2
/// </history>

//--------------------------------------------------------------------------------------------------------------------------------------------------------
//                                                                                   Properties
//
double dEps = Unit(0.01,"mm");
double vecTolerance = Unit(0.001,"mm");

String arSAlignment[] = {
	T("|No alignment filter|"),
	T("|Thickness not aligned with element thickness|")
};

int arNZone[] = {0,1,2,3,4,5,6,7,8,9,10};


String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};

String arSLeftToRight[] = {
	T("|Left to right|"),
	T("|Right to left|")
};
int arNLeftToRight[] = {
	1,
	-1
};


// Selection
PropString sSeperator01(0, "", T("|Selection|"));
sSeperator01.setReadOnly(true);
PropString sFilterAlignment(1,arSAlignment, "     "+T("|Show only sheets with|"));
PropInt nZn(2, arNZone, "     "+T("|Draw sheets in zone|"), 10);

// Grid
PropString sSeperator02(2, "", T("|Grid|"));
sSeperator02.setReadOnly(true);
PropDouble dBetweenSheetH(0, U(100), "     "+T("|Distance to next sheet|")+T(" (|horizontal|)"));
PropDouble dBetweenSheetV(1, U(100), "     "+T("|Distance to next sheet|")+T(" (|vertical|)")); 
PropDouble dBetweenVpH(2, U(10), "     "+T("|Distance to next viewport|")+T(" (|horizontal|)"));
PropDouble dBetweenVpV(3, U(10), "     "+T("|Distance to next viewport|")+T(" (|vertical|)")); 
PropInt nNrOfColumns(0, 3, "     "+T("|Number of columns|"));
PropInt nNrOfRows(1, 3, "     "+T("|Number of rows|"));


// Style
PropString sSeparator03(3, "", T("|Viewport style|"));
sSeparator03.setReadOnly(true);
PropDouble dScaleFctr(4, 1, "     "+T("|Scale factor|"));
dScaleFctr.setDescription(T("|The viewport scale will be used when the scale factor is set to zero.|"));
PropString sDimStyleVp(4, _DimStyles, "     "+T("|Dimension style viewport|"));
PropString sLayerNoPlot(5, "G-Anno-View", "     "+T("|No-plot layer name|"));
PropString sShowSheetNumber(6,arSYesNo, "     "+T("|Show sheet number|"));
PropString sLeftToRight(7, arSLeftToRight, "     "+T("|Columns|"));
PropString sSwapSheet(8, arSYesNo,"     "+T("|Swap sheet|"));


// Measurements
PropString sSeparator04(9, "", T("|Measurements|"));
sSeparator04.setReadOnly(true);
PropString sDimStyle(10, _DimStyles, "     "+T("|Dimension style|"));
PropDouble dOffset(5, U(100), "     "+T("|Offset edge dimension|"));
PropString sShowMaterial(11, arSYesNo, "     "+T("|Show material|"));

String arSTrigger[] = {
	T("|Recalculate|"),
	T("|Recalculate All|")
};

for( int i=0;i<arSTrigger.length();i++ )
	addRecalcTrigger(_kContext, arSTrigger[i] );


//--------------------------------------------------------------------------------------------------------------------------------------------------------
//                                                                                     Insert
if( _bOnInsert ){
	_Viewport.append(getViewport(T("|Select a viewport|")));
	_Pt0 = getPoint(T("|Select a point for first detail|"));
	
	showDialogOnce();
	return;
}

//Is there a viewport selected
if( _Viewport.length()==0 ){
	eraseInstance();
	return;
}
Viewport vp = _Viewport[0];

CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps; ps2ms.invert();
double dVpScale = ps2ms.scale();

Display dp(7);
dp.dimStyle(sDimStyle);
Display dpQty(7);
dpQty.dimStyle(sDimStyle);
double dTxtHQty = dpQty.textHeightForStyle("ABC", sDimStyle);
dpQty.textHeight(2 * dTxtHQty);

Display dpNoPlot(-1);
dpNoPlot.dimStyle(sDimStyleVp, dVpScale);
dpNoPlot.layer(sLayerNoPlot);

double dTextHeight = dp.textHeightForStyle("ABC", sDimStyle);
Point3d ptFirstDetail = _Pt0 - _YW * 3 * dTextHeight;
dpNoPlot.draw("Rotated sheets" , _Pt0 + _XW * 0.25 * dTextHeight - _YW * 2.75 * dTextHeight, _XW, _YW, 1, 1);

// check if the viewport has hsb data
Element el = vp.element();
if( !el.bIsValid() )
	return;

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

// recalculate
if( _kExecuteKey == arSTrigger[0] ){
	if( _Map.hasMap(el.handle()) )
		_Map.removeAt(el.handle(), true);
}
if( _kExecuteKey == arSTrigger[1] ){
	_Map = Map();
}

// resolve properties
int nFilterAlignment = arSAlignment.find(sFilterAlignment);
int nZone = nZn;
if( nZone > 5 )
	nZone = 5 - nZone;
int bShowSheetNumber = arNYesNo[arSYesNo.find(sShowSheetNumber,0)];
int nLeftToRight = arNLeftToRight[arSLeftToRight.find(sLeftToRight,0)];
double dScaleFactor = dScaleFctr;
if( dScaleFactor == 0 )
	dScaleFactor  = dVpScale;
int bShowMaterial = arNYesNo[arSYesNo.find(sShowMaterial,0)];
int bSwapSheet = arNYesNo[arSYesNo.find(sSwapSheet,0)];

Display dpSection(-1);
Display dpDim(90);
dpDim.dimStyle(sDimStyle, dVpScale);

Vector3d vSection;
Point3d ptSection;
double dSectionDepth = U(1);

String arSDrawnSheets[0];
Point3d arPtDrawnSheets[0];
int arNQtyDrawnSheets[0];

Sheet arSheetsToView[0];
String arSSheetHandle[0];
int arNSheetNumber[0];

Sheet arShAll[] = el.sheet();
Sheet arSh[0];
int sheetNumbers[0];
for( int i=0;i<arShAll.length();i++ ){
	Sheet sh = arShAll[i];
	int posNum = sh.posnum();

	if( !sh.bIsValid() )
		continue;
	
	if( sh.myZoneIndex() != nZone )
		continue;
	
	if( nFilterAlignment == 1 && abs(abs(sh.vecZ().dotProduct(vzEl)) - 1) < vecTolerance)
		continue;
	
	if (sheetNumbers.find(posNum) != -1 || posNum == -1)
	{
		reportNotice(TN("|Sheet not numbered|!"));
		continue;
	}
	
	int existingSheetIndex = arNSheetNumber.find(posNum);
	if (existingSheetIndex == -1)
	{
		arSheetsToView.append(sh);
		arSSheetHandle.append(sh.handle());
		arNSheetNumber.append(sh.posnum());	
		arNQtyDrawnSheets.append(1);
	}
	else
	{
		arNQtyDrawnSheets[existingSheetIndex] += 1;
	}
}


//Sort sheets in alphabetic order of their number
for(int s1=1;s1<arNSheetNumber.length();s1++){
	int s11 = s1;
	for(int s2=s1-1;s2>=0;s2--){
		if( arNSheetNumber[s11] < arNSheetNumber[s2] ){
			arSheetsToView.swap(s2, s11);
			arNSheetNumber.swap(s2, s11);
			arSSheetHandle.swap(s2, s11);
			arNQtyDrawnSheets.swap(s2, s11);
			
			s11=s2;
		}
	}
}

//reportNotice("\n***:\n"+arSDetailHandle+"\n");
if( _kNameLastChangedProp.left(4) == "_PtG" ){
	//Store the changes
	int nIndex = _kNameLastChangedProp.right(_kNameLastChangedProp.length() - 4).atoi();
	reportMessage(TN("|Grippoint moved|! [index = ")+nIndex+"]");
	Map mapElementSheets = _Map.getMap(el.handle());
//	reportNotice("\nPoints:\t"+mapElementSheets+"\n");
	int arNDetailIndex[0];
	for( int i=0;i<mapElementSheets.length();i++ ){
//		reportNotice("\nKey:\t"+mapElementSheets.keyAt(i));
		if( arSSheetHandle.find(mapElementSheets.keyAt(i)) == -1 || !mapElementSheets.hasPoint3d(i) )
			continue;
		arNDetailIndex.append(i);
	}
	
	if( nIndex < 0 || arNDetailIndex.length() <= nIndex ){
		reportWarning(TN("|Invalid point moved|"));
		return;
	}
	int nMapIndex = arNDetailIndex[nIndex];
	
	mapElementSheets.setPoint3d(mapElementSheets.keyAt(nMapIndex), _PtG[nIndex], _kAbsolute);
	_Map.setMap(el.handle(), mapElementSheets);
}


Map mapElementSheets;
if( _Map.hasMap(el.handle()) )
	mapElementSheets = _Map.getMap(el.handle());

_PtG.setLength(0);
for( int i=0;i<arSheetsToView.length();i++ ){
	Sheet sh = arSheetsToView[i];
		
	String sSheetNumber = arNSheetNumber[i];
		
	int nSheetIndex = arSDrawnSheets.find(sSheetNumber);

	int nNrOfSheetsDrawn = arSDrawnSheets.length();
	int nIndexRow = int(nNrOfSheetsDrawn/nNrOfColumns);
	if( nIndexRow >= nNrOfRows ){
		reportWarning(TN("|Not all sheets are placed!|")+TN("|Increase the amount of rows and/or columns!|"));
		return;
	}
	int nIndexColumn = nNrOfSheetsDrawn;
	if( nNrOfSheetsDrawn >= nNrOfColumns ){
		double dIndex = ((1.0*nNrOfSheetsDrawn)/(1.0*nNrOfColumns) - int(nNrOfSheetsDrawn/nNrOfColumns));
		nIndexColumn = dIndex*nNrOfColumns + U(0.0001);
	}
	
	Point3d ptThisSheet;
	if( mapElementSheets.hasPoint3d(sh.handle()) ){
		ptThisSheet = mapElementSheets.getPoint3d(sh.handle());
	}
	else{
		ptThisSheet = ptFirstDetail + _XW * nLeftToRight * nIndexColumn * (dBetweenSheetH + dBetweenVpH) - _YW * nIndexRow * (dBetweenSheetV + dBetweenVpV);
		mapElementSheets.setPoint3d(sh.handle(), ptThisSheet, _kAbsolute);
	}
	_PtG.append(ptThisSheet);
	
	Point3d ptCenter = ptThisSheet + .5 * (_XW * dBetweenSheetH - _YW * dBetweenSheetV);
	if( bShowMaterial )
		dp.draw(sh.material(), ptCenter, _XW, _YW, 0, 3.5);
	
	if( bShowSheetNumber )
		dpNoPlot.draw( sSheetNumber, ptThisSheet + (_XW - _YW) * .25 * dTextHeight, _XW, _YW, 1, -1);

	PLine plRect(_ZW);
	plRect.addVertex(ptThisSheet);
	plRect.addVertex(ptThisSheet - _YW * dBetweenSheetV);
	plRect.addVertex(ptThisSheet - _YW * dBetweenSheetV + _XW * dBetweenSheetH);
	plRect.addVertex(ptThisSheet + _XW * dBetweenSheetH);
	plRect.close();
	dpNoPlot.draw(plRect);
	
	CoordSys csSh2Vp;
	Vector3d vxFrom;
	if (bSwapSheet) {
		vxFrom = sh.vecY();
	}
	else {
		vxFrom = -sh.vecY();
	}
	Vector3d vyFrom = sh.vecX();
	Vector3d vzFrom = sh.vecZ();		
	csSh2Vp.setToAlignCoordSys(sh.ptCen(), vxFrom, vyFrom, vzFrom, ptCenter, _XW/dScaleFactor, _YW/dScaleFactor, _ZW/dScaleFactor);
	
	PLine plSh = sh.plEnvelope();	
	Point3d arPtSh[] = plSh.vertexPoints(false);
	for( int j=0;j<(arPtSh.length() - 1);j++ ){
		Point3d ptFrom = arPtSh[j];
		Point3d ptTo = arPtSh[j+1];
		Vector3d vLnSeg(ptTo - ptFrom);
		double dDim = vLnSeg.length();
		vLnSeg.normalize();
		Vector3d vPerp = sh.vecZ().crossProduct(vLnSeg);
		
		double dxDim = vLnSeg.dotProduct(vxEl);
		double dyDim = vLnSeg.dotProduct(vyEl);
		
		if( abs(dxDim) > dEps && abs(dyDim) > dEps ) // Angled
			continue;
		
		Point3d ptDim = (ptFrom + ptTo)/2 + vPerp * dOffset;
		
		// PS
		Point3d ptDimPS = ptDim;
		ptDimPS.transformBy(csSh2Vp);
		Vector3d vLnSegPS = vLnSeg;
		vLnSegPS.transformBy(csSh2Vp);
		Vector3d vPerpPS = vPerp;
		vPerpPS.transformBy(csSh2Vp);
		vLnSegPS.vis(ptDimPS,1);
		vPerpPS.vis(ptDimPS,3);
		
		Vector3d vxDimPS = vLnSegPS;
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
		
		String sDim;
		sDim.formatUnit(dDim, 2, 0);
		
		dpDim.draw(sDim, ptDimPS, vxDimPS, vyDimPS, 0, dFlagY);
	}		
	
	plSh.transformBy(csSh2Vp);
//		dpSection.color(sh.color());
	dpSection.draw(plSh);
	if (arNQtyDrawnSheets[i] < 2) continue;
	dpQty.draw(arNQtyDrawnSheets[i] + "x", ptCenter, _XW, _YW, 0, -5);
}

_Map.setMap(el.handle(), mapElementSheets);

















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
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End