#Version 8
#BeginDescription
Use in PS Layouts on Hsb enabled Viewports. Horizontal and Vertical beams and sheets only. Properties per dimstring. Overal dimensions and moveable reference point not yet enabled
1.12 11/01/2022 Add check with vectortolerance Author: Robert Pol

V1.11_23July2019__Always ignore horizontal in horizontal dimensions, independent of type
V1.10__13May2019_Version update coordination. Removed Horizontal blocking from Horizontal dimensions
V0.25__18September2018__Revised to work from center of displayed Element instead of center of Viewport
V0.14__7November2017__Enabled Grips per Element, Rt-click commands to reset
V0.12__16October2017__Inception


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
/*
<>--<>--<>--<>--<>--<>--<>--<>____ Craig Colomb _____<>--<>--<>--<>--<>--<>--<>--<>

-------Use to do per-zone dimensions in Layout space

V0.10_12October2017__Inception. Converting existing Shopdraw dimensioning script

                                                       cc@hsb-cad.com
<>--<>--<>--<>--<>--<>--<>--<>_____  craigcad.us  _____<>--<>--<>--<>--<>--<>--<>--<>

//#Versions
//1.12 11/01/2022 Add check with vectortolerance Author: Robert Pol
//######################################################################################
//############################ Documentation #########################################
<insert>
Insert in Layout space on a single Hsb enabled viewport
</insert>

<property name="xx">
- What are the important properties.
</ property >

<command name="xx">
- What are the custom commands.
</command>

<version  value=0.10 date=12October2017>
</version>

<remark>
- What could make the tsl fail. 
- Is this an Element tsl that can be added to the list of auto attach tsls.
- What is the (internal) result of the tls: adds element/beam tools, changes properties of other entities,?
- Requirements and scope of applying this tsl (display configuration, styles, hatch, )
- Dependency on other entities (maps, properties, property sets, auto properties,?)
- Dependency on other software components (dlls, xml, catalogs, ?)
</remark>

<MapFormats>
//__this is used when ordering and sorting dimpoints to prevent overlap
mpDimClusters
    |_mpDimCluster
    |   |_mpDimPoint
    |   |   |_ptDim
    |   |   |_dDim
    |   |
    |   |_mpDimPoint
    |   |   |_ptDim
    |   |   |_dDim
    |   |
    |   |_mpDimPoint
    |   |...
    |   
    |_mpDimCluster
    |   |_mpDimPoint
    |   |   |_ptDim
    |   |   |_dDim
    |   |
    |   |_mpDimPoint
    |   |...
    |
    |...

mpShopdrawDimPoints
|_mpView
|	|_ptsVisible
|	|_ptsFace
|	|_ptsBack
|	|_dScale
|
|_mpView
|	|_ptsVisible
|	|_ptsFace
|	|_ptsBack
|	|_dScale
|...

</MapFormats>
//########################## End Documentation #########################################
//######################################################################################
*/

int bIsMetricDwg = U(1, "mm") == 1;
double pointTolerance = U(.1);
double vectorTolerance = U(.01);

int bInDebug;
if(_bOnDebug) bInDebug = true;
bInDebug = true;
Map mpGrips = _Map.getMap("mpGrips");


String stYN[] = { "Yes", "No"};
String stDimTypeOptions[] = { "Ordinate", "Delta", "Delta + Overall", "None"};
int iZones[] = { 0, 1, 2, 3, 4, 5, - 1, - 2, - 3, - 4, - 5};
String stDimFormat[] = { "Decimal mm", "Fractional Ft-In", "Inches Fractional"};
String stDimExtents[] = { "Near Points", "All Points"};
String stLR[] = { "Left", "Right"};
String stUD[] = { "Up", "Down"};
String stHorizontalDimTargetOptions[] = { "Left", "Right", "Center"};
String stVerticalDimTargetOptions[] = { "Down", "Up", "Center"};
String stOnCenterDimensionOptions[] = { "Yes", "No", "Start Symbol"};
double dContactTolerance = U(4, "mm");

//######################################################################################		
//########################## Properties & Insert #############################################	

PropInt piZone(0, 0, "Zone to Dimension");
PropString psDimstyle(0, _DimStyles, "Dimstyle");

PropString psDimFormat(1, stDimFormat, "Dimension Format");
int bDoDecimalmm = psDimFormat == stDimFormat[0];
int bDoFractionalFormat = psDimFormat == stDimFormat[1];
int bDoFractionalInches = psDimFormat == stDimFormat[2];
double dConversionFactor = 1;
if(bIsMetricDwg && bDoFractionalFormat) dConversionFactor = .039370078;
if(bIsMetricDwg && bDoFractionalInches) dConversionFactor = .039370078;
if ( ! bIsMetricDwg && bDoDecimalmm) dConversionFactor = 25.4;

PropDouble pdTextHeight(0, 0, "Text Height Override");
PropDouble pdTextPadding(1, U(1), "Text Height Padding");

PropInt piLineColor (1, 7, "Line Color");
PropInt piTextColor (2, 4, "Text Color");
PropInt piPrecision( 3, 1, "Dimension Value Precision" );
if (piPrecision < 0) piPrecision.set(0);
if (piPrecision > 5) piPrecision.set(5);
int iPrecisionFactor = pow(10, piPrecision);//__piPrecision is the number of decimal places, this int will be used when rounding

PropDouble pdDimensionResolution(2, U(1, "mm"), "Dimension Point Resolution");

PropString psLimitExtensionLines(2, stYN, "Limit Extention Lines");
int bLimitExtensionLines = psLimitExtensionLines == stYN[0];
PropDouble pdExtensionLineOffset(3, U(1), "Extension Line Offset");

String stGlobalDimensionTypeName = "Global Dimension Type";
PropString psGlobalDimType(3, stDimTypeOptions, stGlobalDimensionTypeName);
String stGlobalDimensionExtentName = "Global Dimension Extent";
PropString psGlobalDimExtent(4, stDimExtents, stGlobalDimensionExtentName);
PropString psOnCenterDimensionOption(5, stOnCenterDimensionOptions, "Dimension O.C. Beams?");
int bDimensionOnCenterBeams = psOnCenterDimensionOption == stYN[1];
PropString psUseAllZonesForExtents(22, stYN, "Consider all Zones for Extents?", 1);
int bUseAllZonesForExtents = psUseAllZonesForExtents == stYN[0];
PropString psAddDiagonalDimension(23, stYN, "Add Diagonal Dimension?");
int bAddDiagonalDimension = psAddDiagonalDimension == stYN[0];

//___End General Properties section--#################################################################

PropDouble pdUpDimlineOffset(4, U(3), "Dimension Offset Up");
PropDouble pdUpTextOffset(5, U(3), "Dim Text Offset Up");
PropString psUpDimType (6, stDimTypeOptions, "Dimension Type Up");
PropString psUpDimExtent(7, stDimExtents, "Dim Point Extent Up");
PropString psUpDimTarget(8, stHorizontalDimTargetOptions, "Dimension Up To");
PropString psUpDimReference(9, stLR, "Up Dimension Reference");

String stUpDimlineCategory = "Up Dimline Settings";
pdUpDimlineOffset.setCategory(stUpDimlineCategory);
pdUpTextOffset.setCategory(stUpDimlineCategory);
psUpDimType.setCategory(stUpDimlineCategory);
psUpDimExtent.setCategory(stUpDimlineCategory);
psUpDimTarget.setCategory(stUpDimlineCategory);
psUpDimTarget.setCategory(stUpDimlineCategory);
psUpDimReference.setCategory(stUpDimlineCategory);


PropDouble pdRightDimlineOffset(6, U(3), "Dimension Offset Right");
PropDouble pdRightTextOffset(7, U(3), "Dim Text Offset Right");
PropString psRightDimType (10, stDimTypeOptions, "Dimension Type Right");
PropString psRightDimExtent(11, stDimExtents, "Dim Point Extent Right");
PropString psRightDimTarget(12, stVerticalDimTargetOptions, "Dimension Right To");
PropString psRighDimReference(13, stUD, "Right Dimension Reference");

String stRightDimlineCategory = "Right Dimline Settings";
pdRightDimlineOffset.setCategory(stRightDimlineCategory);
pdRightTextOffset.setCategory(stRightDimlineCategory);
psRightDimType.setCategory(stRightDimlineCategory);
psRightDimExtent.setCategory(stRightDimlineCategory);
psRightDimTarget.setCategory(stRightDimlineCategory);
psRighDimReference.setCategory(stRightDimlineCategory);

PropDouble pdDownDimlineOffset(8, U(3), "Dimension Offset Down");
PropDouble pdDownTextOffset(9, U(3), "Dim Text Offset Down");
PropString psDownDimType (14, stDimTypeOptions, "Dimension Type Down");
PropString psDownDimExtent(15, stDimExtents, "Dim Point Extent Down");
PropString psDownDimTarget(16, stHorizontalDimTargetOptions, "Dimension Down To");
PropString psDownDimReference(17, stLR, "Down Dimension Reference");

String stDownDimlineCategory = "Down Dimline Settings";
pdDownDimlineOffset.setCategory(stDownDimlineCategory);
pdDownTextOffset.setCategory(stDownDimlineCategory);
psDownDimType.setCategory(stDownDimlineCategory);
psDownDimExtent.setCategory(stDownDimlineCategory);
psDownDimTarget.setCategory(stDownDimlineCategory);
psDownDimReference.setCategory(stDownDimlineCategory);

PropDouble pdLeftDimlineOffset(10, U(3), "Dimension Offset Left");
PropDouble pdLeftTextOffset(11, U(3), "Dim Text Offset Left");
PropString psLeftDimType (18, stDimTypeOptions, "Dimension Type Left");
PropString psLeftDimExtent(19, stDimExtents, "Dim Point Extent Left");
PropString psLeftDimTarget(20, stVerticalDimTargetOptions, "Dimension Left To");
PropString psLeftDimReference(21, stLR, "Left Dimension Reference");

String stLeftDimlineCategory = "Left Dimline Settings";
pdLeftDimlineOffset.setCategory(stLeftDimlineCategory);
pdLeftTextOffset.setCategory(stLeftDimlineCategory);
psLeftDimType.setCategory(stLeftDimlineCategory);
psLeftDimExtent.setCategory(stLeftDimlineCategory);
psLeftDimTarget.setCategory(stLeftDimlineCategory); 
psLeftDimReference.setCategory(stLeftDimlineCategory);


//__update individual Properties when Global entries change
if(_kNameLastChangedProp == stGlobalDimensionTypeName)
{
	psUpDimType.set(psGlobalDimType);
	psRightDimType.set(psGlobalDimType);
	psDownDimType.set(psGlobalDimType);
	psLeftDimType.set(psGlobalDimType);
}

if(_kNameLastChangedProp == stGlobalDimensionExtentName)
{
	psUpDimExtent.set(psGlobalDimExtent);
	psRightDimExtent.set(psGlobalDimExtent);
	psDownDimExtent.set(psGlobalDimExtent);
	psLeftDimExtent.set(psGlobalDimExtent);
}

if(_bOnInsert)
{
	if(insertCycleCount() > 1)
	{ 
		eraseInstance();
		return;
	}
	
	showDialogOnce();
	
	_Viewport.append(getViewport());
	
	return;
}


//########################## End Properties & Insert ###############################################
//######################################################################################	

if(bInDebug)
{
	Display dp(3);
	PLine plHandle ;
	plHandle.createCircle( _Pt0, _ZW, U(3) ) ;
	dp.draw( plHandle ) ;
	dp.color( 3 ) ;
	plHandle.createCircle( _Pt0, _ZW, U(4) ) ;
	dp.draw( plHandle ) ;
}

///region  Property Catalog Automation & Boolean Conversion
//###############################################################################################################
//###############################################################################################################

Display dpLines(piLineColor);
Display dpText(piTextColor);
dpText.dimStyle(psDimstyle);

double dTextH = dpText.textHeightForStyle("9", psDimstyle);
if(pdTextHeight > 0)
{
	dpText.textHeight(pdTextHeight);
	dTextH = pdTextHeight;
}
double dTextSpace = dTextH + pdTextPadding;

int bDoUpOrdinateDimensions = psUpDimType == stDimTypeOptions[0];
int bDoUpDeltaDimensions = psUpDimType == stDimTypeOptions[1] || psUpDimType == stDimTypeOptions[2];
int bDoUpOverallDimensions = psUpDimType == stDimTypeOptions[2];
int bDoUpDimline = psUpDimType !=  stDimTypeOptions[3];
int bDoUpPointsThisSideOnly = psUpDimExtent == stDimExtents[0];
int bDoUpPointsAllSides = ! bDoUpPointsThisSideOnly;

int bDoRightOrdinateDimensions = psRightDimType == stDimTypeOptions[0];
int bDoRightDeltaDimensions = psRightDimType == stDimTypeOptions[1] || psRightDimType == stDimTypeOptions[2];
int bDoRightOverallDimensions = psRightDimType == stDimTypeOptions[2];
int bDoRightDimline = psRightDimType !=  stDimTypeOptions[3];
int bDoRightPointsThisSideOnly = psRightDimExtent == stDimExtents[0];
int bDoRightPointsAllSides = ! bDoRightPointsThisSideOnly;

int bDoDownOrdinateDimensions = psDownDimType == stDimTypeOptions[0];
int bDoDownDeltaDimensions = psDownDimType == stDimTypeOptions[1] || psDownDimType == stDimTypeOptions[2];
int bDoDownOverallDimensions = psDownDimType == stDimTypeOptions[2];
int bDoDownDimline = psDownDimType !=  stDimTypeOptions[3];
int bDoDownPointsThisSideOnly = psDownDimExtent == stDimExtents[0];
int bDoDownPointsAllSides = ! bDoDownPointsThisSideOnly;

int bDoLeftOrdinateDimensions = psLeftDimType == stDimTypeOptions[0];
int bDoLeftDeltaDimensions = psLeftDimType == stDimTypeOptions[1] || psLeftDimType == stDimTypeOptions[2];
int bDoLeftOverallDimensions = psLeftDimType == stDimTypeOptions[2];
int bDoLeftDimline = psLeftDimType !=  stDimTypeOptions[3];
int bDoLeftPointsThisSideOnly = psLeftDimExtent == stDimExtents[0];
int bDoLeftPointsAllSides = ! bDoLeftPointsThisSideOnly;

//########################################################################################
//########################################################################################	
///endregion	End Property Catalog Automation & Boolean Conversion 


//######################################################################################		
//########################## Get Points and Sort #############################################	

if(_Viewport.length() == 0 )
{
	eraseInstance();
	return;
}

Viewport vp = _Viewport[0];
double dVpScale = vp.dScale();
CoordSys csMsToPs = vp.coordSys();
CoordSys csPsToMs = csMsToPs;
csPsToMs.invert();

Element el = vp.element();
Point3d ptElCenPS;
PLine plElEnvelope = el.plEnvelope();
Point3d ptsEnvelope[] = plElEnvelope.vertexPoints(true);
ptElCenPS.setToAverage(ptsEnvelope);
ptElCenPS.transformBy(csMsToPs);

_Pt0 = _PtW;
Plane pnPS (_Pt0, _ZW);
Vector3d vY = _YW;
Vector3d vX = _XW;
Line lnRight(_Pt0, vX);
Line lnUp(_Pt0, vY);

Vector3d vYMS = vY;
vYMS.transformBy(csPsToMs);
Vector3d vXMS = vX;
vXMS.transformBy(csPsToMs);
Line lnUpMS = lnUp;
lnUpMS.transformBy(csPsToMs);
Line lnRightMS = lnRight;
lnRightMS.transformBy(csPsToMs);



Point3d ptsAll[0], ptsUpDim[0], ptsRightDim[0], ptsDownDim[0], ptsLeftDim[0];


if(! el.bIsValid())
{ 
	Display dpTitle(1);
	dpTitle.textHeight(U(.125, "inch"));
	dpTitle.draw(scriptName(), _Pt0, vX, vY, 1, 1);
	return;
}

String stElHandle = el.handle();
GenBeam gbsDimZoneAll[] = el.genBeam(piZone);

//__filter out on-center beams if working on Zone 0 & set to do so
if(piZone == 0 && ! bDimensionOnCenterBeams)
{ 
	//TODO: filter out on center joists and add start symbol
}

GenBeam gbsVertical[0], gbsHorizontal[0];
Beam bmsVertical[0], bmsHorizontal[0];
for (int i = 0; i < gbsDimZoneAll.length(); i++)
{
	GenBeam gb = gbsDimZoneAll[i];
	Beam bm = (Beam)gb;
	
	Vector3d vGenBeamAxis = gb.vecX();
	if (abs(vGenBeamAxis.dotProduct(vYMS)) > 1 - vectorTolerance) 
	{
		gbsVertical.append(gb);
		bmsVertical.append(bm);
	}
	if (abs(vGenBeamAxis.dotProduct(vXMS)) > 1 - vectorTolerance) 
	{
		gbsHorizontal.append(gb);
		bmsHorizontal.append(bm);
	}
}

//__populate dimension point array from requested zone
for (int i = 0; i < gbsVertical.length(); i++)
{
	GenBeam gb = gbsVertical[i];
	Vector3d vGenBeamAxis = gb.vecX();
	Point3d ptGenBeamCenPS = gb.ptCen();
	ptGenBeamCenPS.transformBy(csMsToPs);
	
	//__get possible dimension points from AnalysedCut
	AnalysedTool atAll[] = gb.analysedTools();
	AnalysedCut acAll[] = AnalysedCut().filterToolsOfToolType(atAll);
	
	Line lnBmAxisPS(ptGenBeamCenPS, vY);
	
	//__get left, right, or center for horizontal dims
	for (int k = 0; k < acAll.length(); k++)
	{
		//__skip any rip cuts
		if (acAll[k].normal().isPerpendicularTo(vGenBeamAxis)) continue;
		AnalysedCut ac = acAll[k];
		
		Point3d ptsCut[] = ac.bodyPointsInPlane();
		if(ptsCut.length() < 2) continue;//__this function is occasionally failing, likley due to extra cuts in empty space
		ptsCut = csMsToPs.transformPoints(ptsCut);
		ptsCut = pnPS.projectPoints(ptsCut);
		ptsCut = lnRight.orderPoints(ptsCut);
		Point3d ptLeft = ptsCut[0];
		Point3d ptRight = ptsCut[ptsCut.length() - 1];
		Plane pnCut(ac.ptOrg(), ac.normal());
		pnCut.transformBy(csMsToPs);
		Point3d ptCutCenter = lnBmAxisPS.intersect(pnCut, 0);
		
		Vector3d vToCutEnd = ptsCut[0] - ptGenBeamCenPS;
		int bIsBeamTopEnd = vToCutEnd.dotProduct(vY) > 0;
		int bIsTopEndFloor = (ptsCut[0] - ptElCenPS).dotProduct(vY) > 0;
		int bIsRightSideFloor = (ptGenBeamCenPS - ptElCenPS).dotProduct(vX) > 0;
		
		ptsAll.append(ptsCut);
		
		if (bIsBeamTopEnd)
		{
			if (bIsTopEndFloor)
			{
				if (psUpDimTarget == stHorizontalDimTargetOptions[0]) ptsUpDim.append(ptLeft);
				if (psUpDimTarget == stHorizontalDimTargetOptions[1]) ptsUpDim.append(ptRight);
				if (psUpDimTarget == stHorizontalDimTargetOptions[2]) ptsUpDim.append(ptCutCenter);
			}
		}
		else//__bottom end of beam
		{
			if ( ! bIsTopEndFloor)
			{
				if (psDownDimTarget == stHorizontalDimTargetOptions[0]) ptsDownDim.append(ptLeft);
				if (psDownDimTarget == stHorizontalDimTargetOptions[1]) ptsDownDim.append(ptRight);
				if (psDownDimTarget == stHorizontalDimTargetOptions[2]) ptsDownDim.append(ptCutCenter);
			}
		}
		
		//_check for end being capped in case of beams
		int bSkipVerticalDims;
		if(gb.bIsKindOf(Beam()))
		{ 
			Beam bm = (Beam)gb;
			String stDB = bm.name("type");
			Beam bmsThisEnd[] = Beam().filterBeamsHalfLineIntersectSort(bmsHorizontal, bm.ptCen(), vToCutEnd);
			if(bmsThisEnd.length() > 0)
			{ 
				Vector3d vBmAxis = vGenBeamAxis.dotProduct(vToCutEnd) > 0 ? vGenBeamAxis : - vGenBeamAxis;
				Vector3d vCenToCen = bmsThisEnd[0].ptCen() - bm.ptCen();
				double dSeparationDist = vCenToCen.dotProduct(vBmAxis);
				double dMaxDistance = (bm.solidLength() + bmsThisEnd[0].dD(vBmAxis)) / 2 + dContactTolerance;
				if (dSeparationDist <= dMaxDistance) bSkipVerticalDims = true;
			}
		}
		
		if (bSkipVerticalDims) continue;
		
		if (bIsRightSideFloor)
		{
			ptsRightDim.append(ptRight);//__good for top or bottom side of floor, both ends of beam
		}
		else//__Left side floor
		{
			ptsLeftDim.append(ptLeft);
		}
	}
	
}
	vX.vis(ptElCenPS, 5);
	
for(int i=0;i<gbsHorizontal.length();i++)
{
	GenBeam gb = gbsHorizontal[i];
	int iType = gb.type();
	
	//__set to work independently of type, cc 23July2019
	int bAddToHorizontalDims = false;//iType != 10;//__do not dimension horizontal blocking on horizontal dims
	
	Vector3d vGenBeamAxis = gb.vecX();
	Point3d ptGenBeamCenPS = gb.ptCen();
	ptGenBeamCenPS.transformBy(csMsToPs);
	
	//__get possible dimension points from AnalysedCut
	AnalysedTool atAll[] = gb.analysedTools();
	AnalysedCut acAll[] = AnalysedCut().filterToolsOfToolType(atAll);	

	Line lnBmAxisPS(ptGenBeamCenPS, vX);
	
	//__get left, right, or center for horizontal dims
	for(int k=0;k<acAll.length();k++)
	{
		//__skip any rip cuts
		if (acAll[k].normal().isPerpendicularTo(vGenBeamAxis)) continue;
		AnalysedCut ac = acAll[k];
		
		Point3d ptsCut[] = ac.bodyPointsInPlane();
		if (ptsCut.length() < 2) continue;
		
		ptsCut = csMsToPs.transformPoints(ptsCut);
		ptsCut = pnPS.projectPoints(ptsCut);
		ptsCut = lnUp.orderPoints(ptsCut);
		Point3d ptDown = ptsCut[0];
		Point3d ptUp = ptsCut[ptsCut.length() - 1];
		Plane pnCut(ac.ptOrg(), ac.normal());
		pnCut.transformBy(csMsToPs);
		Point3d ptCutCenter = lnBmAxisPS.intersect(pnCut, 0);
		
		Vector3d vToCutEnd = ptsCut[0] - ptGenBeamCenPS;
		int bIsBeamRightEnd = vToCutEnd.dotProduct(vX) > 0;
		Vector3d vPoint = ptsCut[0] - ptElCenPS;
		vPoint.vis(ptElCenPS, 7);
		
		int bIsTopEndFloor = vPoint.dotProduct(vY) > 0;
		int bIsRightSideFloor = vPoint.dotProduct(vX) > 0;
		
		ptsAll.append(ptsCut);
		
		if(bIsBeamRightEnd)
		{ 					
			if(bIsRightSideFloor)
			{ 						
				if (psRightDimTarget == stVerticalDimTargetOptions[0]) ptsRightDim.append(ptDown);
				if (psRightDimTarget == stVerticalDimTargetOptions[1]) ptsRightDim.append(ptUp);
				if (psRightDimTarget == stVerticalDimTargetOptions[2]) ptsRightDim.append(ptCutCenter);
			}
		}
		else//__Left end of beam
		{ 
			if(! bIsRightSideFloor)
			{ 
				if (psLeftDimTarget == stVerticalDimTargetOptions[0]) ptsLeftDim.append(ptDown);
				if (psLeftDimTarget == stVerticalDimTargetOptions[1]) ptsLeftDim.append(ptUp);
				if (psLeftDimTarget == stVerticalDimTargetOptions[2]) ptsLeftDim.append(ptCutCenter);
			}
		}
		
		//_check for end being capped in case of beams
		int bSkipHorizontalDims;
		if(gb.bIsKindOf(Beam()))
		{ 
			Beam bm = (Beam)gb;
			Beam bmsThisEnd[] = Beam().filterBeamsHalfLineIntersectSort(bmsVertical, bm.ptCen(), vToCutEnd);
			if(bmsThisEnd.length() > 0)
			{ 
				Vector3d vBmAxis = vGenBeamAxis.dotProduct(vToCutEnd) > 0 ? vGenBeamAxis : - vGenBeamAxis;
				Vector3d vCenToCen = bmsThisEnd[0].ptCen() - bm.ptCen();
				double dSeparationDist = vCenToCen.dotProduct(vBmAxis);
				double dMaxDistance = (bm.solidLength() + bmsThisEnd[0].dD(vBmAxis)) / 2 + dContactTolerance;
				if (dSeparationDist <= dMaxDistance) bSkipHorizontalDims = true;
			}
		}
		
		if (bSkipHorizontalDims) continue;
		
		
		if(bAddToHorizontalDims)
		{ 
			if(bIsTopEndFloor)
			{
				ptsUpDim.append(ptUp);
			}
			else//__Down side floor
			{ 
				ptsDownDim.append(ptDown);
			}
	
		}
		
	}
	
	//__initially no support for angled beams, will need to change
}

Point3d ptsExtents[0];
ptsExtents.append(ptsAll);
if(bUseAllZonesForExtents) 
{
	GenBeam gbAll[] = el.genBeam();
	//__gather points to set extents
}
else
{ 

}


Point3d ptsLR[] = lnRight.orderPoints(ptsAll);
Point3d ptLeft = ptsLR[0];
Point3d ptRight = ptsLR[ptsLR.length()-1];
Point3d ptsUD[] = lnUp.orderPoints(ptsAll);
Point3d ptUp = ptsUD[ptsUD.length()-1];
Point3d ptDown = ptsUD[0];

Line lnBase(ptDown, vX);
Line lnTop (ptUp, vX);
Line lnRightSide(ptRight, vY);
Line lnLeftSide(ptLeft, vY);

Point3d ptLeftBase = lnBase.closestPointTo(lnLeftSide);
Point3d ptRightTop = lnTop.closestPointTo(lnRightSide);
Point3d ptRightBase = lnBase.closestPointTo(lnRightSide);
Point3d ptLeftTop = lnLeftSide.closestPointTo(lnTop);

///region  Grip Management
//#########################################################################################		
//#########################################################################################	

Point3d ptTopMid = ptLeftTop + (ptRightTop - ptLeftTop)/2;
Point3d ptRightMid = ptRightBase + (ptRightTop - ptRightBase)/2;
Point3d ptDownMid = ptLeftBase + (ptRightBase - ptLeftBase)/2;
Point3d ptLeftMid = ptLeftBase + (ptLeftTop - ptLeftBase)/2;

Line lnVerticalMid(ptTopMid, vY);
Line lnHorizontalMid(ptRightMid, vX);

//__on first run
if( _PtG.length() < 4 )
{
	_PtG.append(ptTopMid + vY * pdUpDimlineOffset);
	_PtG.append(ptRightMid + vX * pdRightDimlineOffset);
	_PtG.append(ptDownMid - vY * pdDownDimlineOffset);
	_PtG.append(ptLeftMid - vX * pdLeftDimlineOffset);
}

int bNeedGripDefaults;
String stResetGripsForThisElementCommand = "Reset Grips for this Element";
addRecalcTrigger (_kContext, stResetGripsForThisElementCommand);
if(_kExecuteKey == stResetGripsForThisElementCommand)
{ 
	bNeedGripDefaults = true;
}

String stResetGripsForAllElementCommand = "Reset Grips for All Elements";
addRecalcTrigger (_kContext, stResetGripsForAllElementCommand);
if(_kExecuteKey == stResetGripsForAllElementCommand)
{ 
	_Map.setMap("mpGrips", Map());
}


String stLastElementHandle = mpGrips.getString("stLastElementHandle");

if (! mpGrips.hasPoint3dArray(stElHandle) || bNeedGripDefaults) //__use default values and reset grip locations
{ 
		_PtG[0] = (ptTopMid + vY * pdUpDimlineOffset);
	_PtG[1] = (ptRightMid + vX * pdRightDimlineOffset);
	_PtG[2] = (ptDownMid - vY * pdDownDimlineOffset);
	_PtG[3] = (ptLeftMid - vX * pdLeftDimlineOffset);
	
	mpGrips.setPoint3dArray(stElHandle, _PtG);	
}

if (stLastElementHandle != stElHandle && mpGrips.hasPoint3dArray(stElHandle))	//__found stored grip array and Element has changed, reset points
{ 
	_PtG = mpGrips.getPoint3dArray(stElHandle);
}


_PtG[0] = lnVerticalMid.closestPointTo(_PtG[0]);
_PtG[1] = lnHorizontalMid.closestPointTo(_PtG[1]);
_PtG[2] = lnVerticalMid.closestPointTo(_PtG[2]);
_PtG[3] = lnHorizontalMid.closestPointTo(_PtG[3]);

//String stGripEditTrigger = "_PtG";
////reportMessage("\n_kNameLastChangedProp =>" + _kNameLastChangedProp);
//if(_kNameLastChangedProp.left(4) == stGripEditTrigger)
//{
//	//__user has moved grips, store the new set
//	mpGrips.setPoint3dArray(stElHandle, _PtG);
//	
////	int iGripIndex = _kNameLastChangedProp.right(1).atoi();
////	if(iGripIndex == 0) pdUpDimlineOffset.set((_PtG[0] - ptTopMid).length());
////	if(iGripIndex == 1) pdRightDimlineOffset.set((_PtG[1] - ptRightMid).length());
////	if(iGripIndex == 2) pdDownDimlineOffset.set((_PtG[2] - ptDownMid).length());
////	if(iGripIndex == 3) pdLeftDimlineOffset.set((_PtG[3] - ptLeftMid).length());	
//}
//
//if(_kNameLastChangedProp == "Dimension Offset Up") _PtG[0] = ptTopMid + vY * pdUpDimlineOffset;
//if(_kNameLastChangedProp == "Dimension Offset Right") _PtG[1] = ptRightMid + vX * pdRightDimlineOffset;
//if(_kNameLastChangedProp == "Dimension Offset Down") _PtG[2] = ptDownMid - vY * pdDownDimlineOffset;
//if(_kNameLastChangedProp == "Dimension Offset Left") _PtG[3] = ptLeftMid - vX * pdLeftDimlineOffset;
//
//__grip might have been created or adjusted, store current set
mpGrips.setPoint3dArray(stElHandle, _PtG);
mpGrips.setString("stLastElementHandle", stElHandle);
_Map.setMap("mpGrips", mpGrips);

 
//########################################################################################
//########################################################################################	
///endregion	End Grip Management 



//########################## End Get Points and Format ##############################################################
//################################################################################################################





//region Context Commands

// Worried about performance with this section enabled
//############################################################################################################		
//########################## Context Commands  #############################################	##################
String stElementHandle = el.handle();
String stLeftPointsToAddKey = "ptsLeftPointsToAdd" + stElementHandle;
String stRightPointsToAddKey = "ptsRightPointsToAdd" + stElementHandle;
String stDownPointsToAddKey = "ptsDownPointsToAdd" + stElementHandle;
String stTopPointsToAddKey = "ptsTopPointsToAdd" + stElementHandle;

Point3d ptsLeftPointsToAdd[] = _Map.getPoint3dArray(stLeftPointsToAddKey);
Point3d ptsRightPointsToAdd[] = _Map.getPoint3dArray(stRightPointsToAddKey);
Point3d ptsDownPointsToAdd[] = _Map.getPoint3dArray(stDownPointsToAddKey);
Point3d ptsTopPointsToAdd[] = _Map.getPoint3dArray(stTopPointsToAddKey);

String stAddTopPointsCommand = "Add Dimpoints Top";
String stAddRightPointsCommand = "Add Dimpoints Right";
String stAddDownPointsCommand = "Add Dimpoints Down";
String stAddLeftPointsCommand = "Add Dimpoints Left";

addRecalcTrigger(_kContext, stAddTopPointsCommand);
addRecalcTrigger(_kContext, stAddRightPointsCommand);
addRecalcTrigger(_kContext, stAddDownPointsCommand);
addRecalcTrigger(_kContext, stAddLeftPointsCommand);

if (_kExecuteKey == stAddTopPointsCommand)
{
	Point3d ptsTemp[0] ;
	PrPoint prp("Select Points to Add");
	while (true)
	{
		if(prp.go() == _kOk)
		{
			ptsTemp.append(prp.value());
		}
		else
		{
			break;
		}
	}	
	
	//__store new points
	if(ptsTemp.length() > 0)
	{ 
		ptsTopPointsToAdd.append(ptsTemp);
	_Map.setPoint3dArray(stTopPointsToAddKey, ptsTopPointsToAdd);
	}
	
}

if (_kExecuteKey == stAddRightPointsCommand)
{
	Point3d ptsTemp[0];
	PrPoint prp("Select Points to Add");
	while (true)
	{
		if(prp.go() == _kOk)
		{
			ptsTemp.append(prp.value());
		}
		else
		{
			break;
		}
	}	
	
	//__store new points
	if(ptsTemp.length() > 0)
	{ 
		ptsRightPointsToAdd.append(ptsTemp);
		_Map.setPoint3dArray(stRightPointsToAddKey, ptsRightPointsToAdd);
	}
	
}

if (_kExecuteKey == stAddDownPointsCommand)
{
	Point3d ptsTemp[0];
	PrPoint prp("Select Points to Add");
	while (true)
	{
		if(prp.go() == _kOk)
		{
			ptsTemp.append(prp.value());
		}
		else
		{
			break;
		}
	}	
	
	//__store new points
	if(ptsTemp.length() > 0)
	{ 
		ptsDownPointsToAdd.append(ptsTemp);
		_Map.setPoint3dArray(stDownPointsToAddKey, ptsDownPointsToAdd);
	}
	
}

if (_kExecuteKey == stAddLeftPointsCommand)
{
	Point3d ptsTemp[] = _Map.getPoint3dArray("ptsLeftPointsToAdd");
	PrPoint prp("Select Points to Add");
	while (true)
	{
		if(prp.go() == _kOk)
		{
			ptsTemp.append(prp.value());
		}
		else
		{
			break;
		}
	}	
	
	//__store new points
	_Map.setPoint3dArray("ptsLeftPointsToAdd", ptsTemp);
}

String stLeftPointsToRemoveKey = "ptsLeftPointsToRemove" + stElHandle;
String stRightPointsToRemoveKey = "ptsRightPointsToRemove" + stElHandle;
String stDownPointsToRemoveKey = "ptsDownPointsToRemove" + stElHandle;
String stTopPointsToRemoveKey = "ptsTopPointsToRemove" + stElHandle;

Point3d ptsLeftPointsToRemove[] = _Map.getPoint3dArray(stLeftPointsToRemoveKey);
Point3d ptsRightPointsToRemove[] = _Map.getPoint3dArray(stRightPointsToRemoveKey);
Point3d ptsDownPointsToRemove[] = _Map.getPoint3dArray(stDownPointsToRemoveKey);
Point3d ptsTopPointsToRemove[] = _Map.getPoint3dArray(stTopPointsToRemoveKey);

String stRemoveTopPointsCommand = "Remove Dimpoints Top";
String stRemoveRightPointsCommand = "Remove Dimpoints Right";
String stRemoveDownPointsCommand = "Remove Dimpoints Down";
String stRemoveLeftPointsCommand = "Remove Dimpoints Left";

addRecalcTrigger(_kContext, stRemoveTopPointsCommand);
addRecalcTrigger(_kContext, stRemoveRightPointsCommand);
addRecalcTrigger(_kContext, stRemoveDownPointsCommand);
addRecalcTrigger(_kContext, stRemoveLeftPointsCommand);

if (_kExecuteKey == stRemoveTopPointsCommand)
{
	Point3d ptsTemp[0];
	PrPoint prp("Select Points to Remove");
	while (true)
	{
		if(prp.go() == _kOk)
		{
			ptsTemp.append(prp.value());
		}
		else
		{
			break;
		}
	}	
	
	//__store new points
	if(ptsTemp.length() > 0)
	{
		ptsTopPointsToRemove.append(ptsTemp);
		_Map.setPoint3dArray(stTopPointsToRemoveKey, ptsTopPointsToRemove);
	}
	
}

if (_kExecuteKey == stRemoveRightPointsCommand)
{
	Point3d ptsTemp[0];
	PrPoint prp("Select Points to Remove");
	while (true)
	{
		if(prp.go() == _kOk)
		{
			ptsTemp.append(prp.value());
		}
		else
		{
			break;
		}
	}	
	
	//__store new points
	if(ptsTemp.length() > 0)
	{
		ptsRightPointsToRemove.append(ptsTemp);
		_Map.setPoint3dArray(stRightPointsToRemoveKey, ptsRightPointsToRemove);
	}
	
}

if (_kExecuteKey == stRemoveDownPointsCommand)
{
	Point3d ptsTemp[0];
	PrPoint prp("Select Points to Remove");
	while (true)
	{
		if(prp.go() == _kOk)
		{
			ptsTemp.append(prp.value());
		}
		else
		{
			break;
		}
	}	
	
	//__store new points
	if(ptsTemp.length() > 0)
	{
		ptsDownPointsToRemove.append(ptsTemp);
		_Map.setPoint3dArray(stDownPointsToRemoveKey, ptsDownPointsToRemove);
	}
	
}

if (_kExecuteKey == stRemoveLeftPointsCommand)
{
	Point3d ptsTemp[0];
	PrPoint prp("Select Points to Remove");
	while (true)
	{
		if(prp.go() == _kOk)
		{
			ptsTemp.append(prp.value());
		}
		else
		{
			break;
		}
	}	
	
	//__store new points
	if(ptsTemp.length() > 0)
	{
		ptsLeftPointsToRemove.append(ptsTemp);
		_Map.setPoint3dArray(stLeftPointsToRemoveKey, ptsLeftPointsToRemove);
	}
	
}

String stTopDimlineDisableCommand = "Turn off Top Dimline";
addRecalcTrigger(_kContext, stTopDimlineDisableCommand);
if(_kExecuteKey == stTopDimlineDisableCommand)
{
	psUpDimType.set(stDimTypeOptions[3]);
	bDoUpDeltaDimensions = false;
	bDoUpOrdinateDimensions = false;
	bDoUpOverallDimensions = false;
}

String stRightDimlineDisableCommand = "Turn off Right Dimline";
addRecalcTrigger(_kContext, stRightDimlineDisableCommand);
if(_kExecuteKey == stRightDimlineDisableCommand)
{
	psRightDimType.set(stDimTypeOptions[3]);
	bDoRightDeltaDimensions = false;
	bDoRightOrdinateDimensions = false;
	bDoRightOverallDimensions = false;
}

String stDownDimlineDisableCommand = "Turn off Bottom Dimline";
addRecalcTrigger(_kContext, stDownDimlineDisableCommand);
if(_kExecuteKey == stDownDimlineDisableCommand)
{
	psDownDimType.set(stDimTypeOptions[3]);
	bDoDownDeltaDimensions = false;
	bDoDownOrdinateDimensions = false;
	bDoDownOverallDimensions = false;
}

String stLeftDimlineDisableCommand = "Turn off Left Dimline";
addRecalcTrigger(_kContext, stLeftDimlineDisableCommand);
if(_kExecuteKey == stLeftDimlineDisableCommand)
{
	psLeftDimType.set(stDimTypeOptions[3]);
	bDoLeftDeltaDimensions = false;
	bDoLeftOrdinateDimensions = false;
	bDoLeftOverallDimensions = false;
}

String stAddDimpointsGlobalCommand = "Add Dimpoints to All";
addRecalcTrigger(_kContext, stAddDimpointsGlobalCommand);

Point3d ptsToAddGlobal[] = _Map.getPoint3dArray("ptsToAddGlobal");
if(_kExecuteKey == stAddDimpointsGlobalCommand)
{ 
	PrPoint prp("Select Points to Add");
	while (true)
	{		
		if (prp.go() == _kOk)
		{
			ptsToAddGlobal.append(prp.value());
		}
		else
		{
			break;
		}
	}
	_Map.setPoint3dArray("ptsToAddGlobal", ptsToAddGlobal);
}


String stRemoveDimpointsGlobalCommand = "Remove Dimpoints from All";
addRecalcTrigger(_kContext, stRemoveDimpointsGlobalCommand);
Point3d ptsToRemoveGlobal[] = _Map.getPoint3dArray("ptsToRemoveGlobal");
if(_kExecuteKey == stRemoveDimpointsGlobalCommand)
{ 
	PrPoint prp("Select Points to Remove");
	while (true)
	{	
		if (prp.go() == _kOk)
		{
			ptsToRemoveGlobal.append(prp.value());
		}
		else
		{
			break;
		}
	}
	_Map.setPoint3dArray("ptsToRemoveGlobal", ptsToRemoveGlobal);
	reportMessage("\nptsToRemoveGlobal.length()  =>" + ptsToRemoveGlobal.length() );
}

//########################## End Context Commands  ###############################################
//######################################################################################

//endregion

//######################################################################################		
//########################## Loop through View Directions, draw dims #############################################	

int bDoOrdinateDimensionsArray[] = { bDoUpOrdinateDimensions, bDoRightOrdinateDimensions, bDoDownOrdinateDimensions, bDoLeftOrdinateDimensions};
int bDoDeltaDimensionsArray[] = { bDoUpDeltaDimensions, bDoRightDeltaDimensions, bDoDownDeltaDimensions, bDoLeftDeltaDimensions};
int bDoOveralDimensionArray[] = { bDoUpOverallDimensions, bDoRightOverallDimensions, bDoDownOverallDimensions, bDoLeftOverallDimensions};
int bDoDimlineArray[] = { bDoUpDimline, bDoRightDimline, bDoDownDimline, bDoLeftDimline};
//int bDoPointsThisSideOnlyArray[] = { bDoUpPointsThisSideOnly, bDoRightPointsThisSideOnly, bDoDownPointsThisSideOnly, bDoLeftPointsThisSideOnly};
int bDoPointsAllSidesArray[] = { bDoUpPointsAllSides, bDoRightPointsAllSides, bDoDownPointsAllSides, bDoLeftPointsAllSides};

Vector3d vDimlines[] = { vX, vY, vX, vY};
Vector3d vDimPerps[] = { vY, vX, -vY, -vX};
Vector3d vTexts[] = 	{_YW, _XW, _YW, _XW};
Vector3d vTextPerps[] = { -_XW, _YW, -_XW, _YW};
int iTextFlags[] = { 1, 1, -1, -1};

double dDimlineOffsets[] = { pdUpDimlineOffset, pdRightDimlineOffset, pdDownDimlineOffset, pdLeftDimlineOffset};
double dTextOffsets[] = { pdUpTextOffset, pdRightTextOffset, pdDownTextOffset, pdLeftTextOffset};

Map mpPointsToAdd;
Map mpPoints;
mpPoints.setPoint3dArray("pts", _Map.getPoint3dArray("ptsTopPointsToAdd"));
mpPointsToAdd.appendMap("mpPoints", mpPoints);
mpPoints.setPoint3dArray("pts", _Map.getPoint3dArray("ptsRightPointsToAdd"));
mpPointsToAdd.appendMap("mpPoints", mpPoints);
mpPoints.setPoint3dArray("pts", _Map.getPoint3dArray("ptsDownPointsToAdd"));
mpPointsToAdd.appendMap("mpPoints", mpPoints);
mpPoints.setPoint3dArray("pts", _Map.getPoint3dArray("ptsLeftPointsToAdd"));
mpPointsToAdd.appendMap("mpPoints", mpPoints);

Map mpPointsToRemove;
mpPoints.setPoint3dArray("pts", _Map.getPoint3dArray("ptsTopPointsToRemove"));
mpPointsToRemove.appendMap("mpPoints", mpPoints);
mpPoints.setPoint3dArray("pts", _Map.getPoint3dArray("ptsRightPointsToRemove"));
mpPointsToRemove.appendMap("mpPoints", mpPoints);
mpPoints.setPoint3dArray("pts", _Map.getPoint3dArray("ptsDownPointsToRemove"));
mpPointsToRemove.appendMap("mpPoints", mpPoints);
mpPoints.setPoint3dArray("pts", _Map.getPoint3dArray("ptsLeftPointsToRemove"));
mpPointsToRemove.appendMap("mpPoints", mpPoints);


//Map mpDimPointsEachDirection;//__use this as bucket to store sorted points

Point3d ptArrayMid = ptLeftBase + (ptRightTop - ptLeftBase)/2;

Point3d ptsSides[] = { ptRightTop, ptRightTop, ptLeftBase, ptLeftBase};
Point3d ptsStartRef[] = {ptLeftTop, ptRightBase, ptLeftBase, ptLeftBase };
Point3d ptsEndRef[] = { ptRightTop, ptRightTop, ptRightBase, ptLeftTop};
String stDimPointKeys[] = { "ptsUpDim", "ptsRightDim", "ptsDownDim", "ptsLeftDim"};
Map mpPointsToDim;
mpPointsToDim.setPoint3dArray(stDimPointKeys[0], ptsUpDim);
mpPointsToDim.setPoint3dArray(stDimPointKeys[1], ptsRightDim);
mpPointsToDim.setPoint3dArray(stDimPointKeys[2], ptsDownDim);
mpPointsToDim.setPoint3dArray(stDimPointKeys[3], ptsLeftDim);


double dFilterTolerance = U(.01, "mm");
for(int i=0;i<4;i++)//__first sort into relevant dimpoints for each dimension direction
{		
	int bDoDimline = bDoDimlineArray[i];
	if(! bDoDimline) continue;
	
	int bDoOrdinateDimensions = bDoOrdinateDimensionsArray[i];
	int bDoDeltaDimensions = bDoDeltaDimensionsArray[i];
	int bDoOveralDimension = bDoOveralDimensionArray[i];
	Vector3d vDimline = vDimlines[i];
	Vector3d vDimPerp = vDimPerps[i];
	Point3d ptSide = ptsSides[i];		
	double dDimlineOffset = dDimlineOffsets[i];
	double dTextOffset = dTextOffsets[i];
	Vector3d vText = vTexts[i];
	Vector3d vTextPerp = vTextPerps[i];
	int iTextFlag = iTextFlags[i];
	Point3d ptStartRef = ptsStartRef[i];
	Point3d ptEndRef = ptsEndRef[i];
	Point3d ptsToDim[] = mpPointsToDim.getPoint3dArray(stDimPointKeys[i]);

	//__save a copy in original position
	Point3d ptsToDimInPlace[0];
	ptsToDimInPlace = ptsToDim;
	
	//__project points to one side and order, will also remove duplicates
	Line lnThisSide(ptSide, vDimline);
	ptsToDim = lnThisSide.projectPoints(ptsToDim);
	ptsToDim = lnThisSide.orderPoints(ptsToDim, pdDimensionResolution);
	
	Line lnDimline (_PtG[i], vDimline);
	Line lnDimText = lnDimline;
	lnDimText.transformBy(vDimPerp * dTextOffset);
	Line lnDimMidTextDim = lnDimline;
	lnDimMidTextDim.transformBy(vDimPerp * dTextOffset/2);
	
	//__look for points to remove
	mpPoints = mpPointsToRemove.getMap(i);
	Point3d ptsToRemoveThisSide[] = mpPoints.getPoint3dArray("pts");
//	ptsToRemoveThisSide.append(ptsToRemoveGlobalThisSide);
//	ptsToRemoveThisSide = lnThisSide.projectPoints(ptsToRemoveThisSide);
//	ptsToRemoveThisSide = lnThisSide.orderPoints(ptsToRemoveThisSide);
	
	for(int n=0;n<ptsToRemoveThisSide.length();n++)
	{
		Point3d ptToRemove = ptsToRemoveThisSide[n];
		int iIndexToRemove = -1;
		double dMinDist = U(10000, "mm");
		for(int m=0;m<ptsToDim.length();m++)
		{
			double dCheck = (ptsToDim[m] - ptToRemove).length();
			if(dCheck < U(2, "mm"))//__close enough
			{
				iIndexToRemove = m;
				break;
			}
			
			if(dCheck < dMinDist)
			{
				iIndexToRemove = m;
				dMinDist = dCheck;
			}
		}
		ptsToDim.removeAt(iIndexToRemove);
	}
	
	//__add in requested points
	mpPoints = mpPointsToAdd.getMap(i);
	Point3d ptToAdd[] = mpPoints.getPoint3dArray("pts");
	ptsToDim.append(ptToAdd);
	
	//__add extremes back in as they are still needed
	ptsToDim.append(ptEndRef);
	ptsToDim.append(ptStartRef);
	
	//__also make sure set of original points has extremes, order of this array is not important
	ptsToDimInPlace.append(ptEndRef);
	ptsToDimInPlace.append(ptStartRef);
	
	//now re-order
	ptsToDim = lnThisSide.projectPoints(ptsToDim);
	ptsToDim = lnThisSide.orderPoints(ptsToDim, pdDimensionResolution);		
	
	
	//__Map structure is identical, but content is different depending on Delta or Ordinate dimensions
	Map mpDimClusters;
	//__For Ordinate dimensions, ptDim is on dimline, perpendicular to dimension point source
	if(bDoOrdinateDimensions)
	{
		Point3d ptDimRef = ptsToDim[0];
				
		//__Start with base cluster of one point each
		for(int n=0;n<ptsToDim.length();n++)
		{
			Point3d ptDim = ptsToDim[n];
			double dDimension = (ptDim - ptDimRef).length()/dVpScale;
			dDimension = round(dDimension*iPrecisionFactor)/iPrecisionFactor;
			Map mpDimCluster, mpDimPoint;
			
			mpDimPoint.setPoint3d("ptDim", ptDim);
			mpDimPoint.setDouble("dDim", dDimension);
			mpDimCluster.appendMap("mpDimPoint", mpDimPoint);
			mpDimClusters.appendMap("mpDimCluster", mpDimCluster);
		}
	}
	
	//__For Delta dimensions, ptDim is on dimline, 1/2 between each pair of source points
	if(bDoDeltaDimensions)
	{
		Point3d ptPreviousDimPoint = ptsToDim[0];
		Point3d ptDB = ptPreviousDimPoint;
		ptDB.vis(1);
		vDimPerp.vis(ptDB, 3);
		Point3d ptOnDimline = lnDimline.closestPointTo(ptPreviousDimPoint);
		Point3d ptLeaderEndPoint = ptPreviousDimPoint;
		
		//__might as well draw delta graphics in this loop
		if(! bLimitExtensionLines)
		{ 
			Line lnExtension (ptOnDimline, - vDimPerp);
			Point3d ptsLine[] = lnExtension.filterClosePoints(ptsAll, dFilterTolerance);
			ptsLine = lnExtension.orderPoints(ptsLine);
			if (ptsLine.length() > 0) 
			{
				ptLeaderEndPoint = ptsLine[0] + vDimPerp*pdExtensionLineOffset ;
				ptLeaderEndPoint.vis(7);
			}
		}
		LineSeg lsExtension(ptLeaderEndPoint,  ptOnDimline + vDimPerp * dTextSpace/2);
		dpLines.draw(lsExtension);
		
		Vector3d vTickDir = _YW - _XW; vTickDir.normalize();
		vTickDir *= dTextH/4;
		LineSeg lsTick(ptOnDimline + vTickDir, ptOnDimline - vTickDir);
		dpLines.draw(lsTick);
				
		
		for(int n=1;n<ptsToDim.length();n++)
		{ 
			Point3d ptDim = ptsToDim[n];
			ptOnDimline = lnDimline.closestPointTo(ptDim);
			Point3d ptLeaderEnd = ptDim + vDimPerp * pdExtensionLineOffset;
			
			if(! bLimitExtensionLines)
			{ 
				Line lnExtension (ptOnDimline, - vDimPerp);
				Point3d ptsLine[] = lnExtension.filterClosePoints(ptsAll, dFilterTolerance);
				ptsLine = lnExtension.orderPoints(ptsLine);				
				if (ptsLine.length() > 0) 
				{
					ptLeaderEnd = ptsLine[0] + vDimPerp * pdExtensionLineOffset;
				}
				//ptLeaderEnd.vis(7);
			}
			
			
			double dDimension = (ptDim - ptPreviousDimPoint).length()/dVpScale;
			//dDimension = round(dDimension*iPrecisionFactor)/iPrecisionFactor;
			if(dDimension == 0) continue;//__can happen with some geometry and precision factors
			Point3d ptDimText = lnDimline.closestPointTo((ptPreviousDimPoint + ptDim)/2);//lnDimline.closestPointTo(ptPreviousDimPoint) + (ptOnDimline - ptPreviousDimPoint)/2;
			Map mpDimCluster, mpDimPoint;
			
			mpDimPoint.setPoint3d("ptDim", ptDimText);
			mpDimPoint.setDouble("dDim", dDimension);
			mpDimCluster.appendMap("mpDimPoint", mpDimPoint);
			mpDimClusters.appendMap("mpDimCluster", mpDimCluster);
			
			//__draw dimlines and extensions
			LineSeg lsDimline (ptOnDimline, lnDimline.closestPointTo(ptPreviousDimPoint));
			dpLines.draw(lsDimline);
			LineSeg lsExtension(ptLeaderEnd, ptOnDimline + vDimPerp * dTextH/2);
			dpLines.draw(lsExtension);
			LineSeg lsTick(ptOnDimline + vTickDir, ptOnDimline - vTickDir);
			dpLines.draw(lsTick);
			
			//__reset dimension reference for next loop
			ptPreviousDimPoint = ptDim;
		}
	}		
	
	//__moving to clusters moves text points, keep checking until no interference Found
	int iHaveClashes = true;
	int iSafe;
	while(iHaveClashes)
	{
		if(iSafe++ > 1000) 
		{
			reportMessage("\niSafe exceeded 1,000");
			break;
		}
		
		Map mpCheckedDimClusters;
		iHaveClashes = false; //__reset this after every run of clustering
		
		Map mpLastDimCluster = mpDimClusters.getMap(0);//__this is the initial or previous group we're checking against
					
		for(int n=1; n<mpDimClusters.length(); n++)
		{
			Map mpDimCluster = mpDimClusters.getMap(n);
			//Point3d ptsCheck[] = mpDimClusters.getPoint3dArray(n);
			int iPointCount = mpDimCluster.length();
			Point3d ptCheckStart = mpDimCluster.getMap(0).getPoint3d("ptDim");
			Point3d ptCheckEnd = mpDimCluster.getMap(iPointCount-1).getPoint3d("ptDim");
			Point3d ptCheckMid = ptCheckStart + (ptCheckEnd - ptCheckStart)/2;
			
			//__Stored points are actual dimpoint positions, text locations have to be calculated from these sources
			Point3d ptCheckTextStart = ptCheckMid - vDimline * (dTextSpace * iPointCount)/2;
			
			int iLastPointCount = mpLastDimCluster.length();
			Point3d ptLastEnd = mpLastDimCluster.getMap(iLastPointCount-1).getPoint3d("ptDim");					
			Point3d ptLastStart = mpLastDimCluster.getMap(0).getPoint3d("ptDim");
			Point3d ptLastMid = ptLastStart + (ptLastEnd - ptLastStart)/2;
			
			//__Stored points are actual dimpoint positions, text locations have to be calculated from these sources
			Point3d ptLastTextEnd = ptLastMid + vDimline * (dTextSpace * iLastPointCount)/2;

			double dDistCheck = (ptCheckTextStart - ptLastTextEnd).dotProduct(vDimline); 

			if (dDistCheck >= 0)//__mpDimCluster is a separate group
			{
				//__Last Dim Cluster has been determined to not overlap, record it
				mpCheckedDimClusters.appendMap("mpDimCluster", mpLastDimCluster);
				
				//__reset cluster to test on next loop, if there is one 
				mpLastDimCluster = mpDimCluster;
				
				//__Will also need to save last cluster if no more looping to do
				if(n == mpDimClusters.length()-1) mpCheckedDimClusters.appendMap("mpDimCluster", mpDimCluster);
				
				//__done dealing with case of current cluster does not overlap
				continue;
			}
			
			//__there is interference/overlap, so we aren't done
			iHaveClashes = true;
			
			//__current check group is too close, assimilate it ;-]
			for(int s=0; s<mpDimCluster.length(); s++)
			{
				mpLastDimCluster.appendMap("mpDimPoint", mpDimCluster.getMap(s));
			}

			//__save any data on last run
			if(n == mpDimClusters.length() -1 )
			{
				mpCheckedDimClusters.appendMap("mpDimCluster", mpLastDimCluster);
			}
		}
		//__set newly grouped clusters to be active set, but not on last run when mpCheckedDimClusters is empty
		if(mpCheckedDimClusters.length() > 0) mpDimClusters = mpCheckedDimClusters;				
	}
					

	
	//__ loop through clusters and draw dimensions
	for(int n=0; n<mpDimClusters.length(); n++)
	{
		Map mpDimCluster = mpDimClusters.getMap(n);
		int iPointCount = mpDimCluster.length();					
		double dClusterSpace = iPointCount * dTextSpace;
		
		Point3d ptClusterStart = mpDimCluster.getMap(0).getPoint3d("ptDim");					
		Point3d ptClusterEnd = mpDimCluster.getMap(iPointCount-1).getPoint3d("ptDim");
	
		Point3d ptClusterMid = ptClusterStart + (ptClusterEnd - ptClusterStart)/2;
		Point3d ptTextStart = lnDimText.closestPointTo(ptClusterMid) -vDimline * (dClusterSpace - dTextSpace)/2;

		for (int s=0; s<iPointCount; s++)
		{
			Map mpDimPoint = mpDimCluster.getMap(s);
			Point3d ptDim = mpDimPoint.getPoint3d("ptDim");
			Point3d ptOnDimline = lnDimMidTextDim.closestPointTo(ptDim);
			Point3d ptLeaderEnd = ptDim + vDimPerp * pdExtensionLineOffset;
			double dDimension = mpDimPoint.getDouble("dDim") * dConversionFactor;			
			double dDimensionRounded =  round(dDimension*iPrecisionFactor)/iPrecisionFactor;
			
			if (! bLimitExtensionLines && bDoOrdinateDimensions)
			{
				Line ln( ptDim, -vDimPerp ) ;
				//Point3d ptsLine[] = ln.filterClosePoints( ptsToDimInPlace, U(2, "mm")) ;
				Point3d ptsLine[] = ln.filterClosePoints( ptsAll, dFilterTolerance) ;
				ptsLine = ln.orderPoints( ptsLine) ;
				if ( ptsLine.length() > 0 ) ptLeaderEnd = ptsLine[0] + vDimPerp * pdExtensionLineOffset;		 	
			}			
			
			Point3d ptLeaderAngle = ptOnDimline;
			Point3d ptText = ptTextStart + vDimline * s * dTextSpace;

			String stDimension = dDimensionRounded ;
			if (bDoFractionalFormat) stDimension = String().formatUnit(dDimension, 4, piPrecision);					
			if (bDoFractionalInches) 
			{
				stDimension = String().formatUnit(dDimension, 5, piPrecision);	
				stDimension += "\"";
			}
			
									
			if(bDoOrdinateDimensions)
			{			
				PLine plLeader(_ZW);
				plLeader.addVertex(ptLeaderEnd);	
				plLeader.addVertex(ptLeaderAngle);				
				plLeader.addVertex(ptText);
				dpLines.draw(plLeader);				
			}
			
			dpText.draw(stDimension, ptText, vText, vTextPerp, iTextFlag, 0);
		}
		
	}
}



//########################## End Loop through View Directions, draw dims ###############################################
//######################################################################################	
			

#End
#BeginThumbnail






#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="0.03937008" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Add check with vectortolerance" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="12" />
      <str nm="DATE" vl="1/11/2022 1:34:53 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End