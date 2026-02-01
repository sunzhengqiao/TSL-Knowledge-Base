#Version 8
#BeginDescription
Used to manually insert/create a dimensions on Elements. Transfers through to Client display in hsbMake
V0.53 2/10/2022 Updated to be tolerant of translated input strings cc

V0.52__11March2020__added Tagging ability
V0.42__28February2020  Rework of existing MP Shopdrawing script
V0.28__27June2018__Added unit options, set with format property
V0.26_4May2018__Initial public release for testing


V0.55 2/11/2022 Bugfix on revised insertion routine cc
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 0
#MinorVersion 55
#KeyWords 
#BeginContents
/*
<>--<>--<>--<>--<>--<>--<>--<>____ Craig Colomb _____<>--<>--<>--<>--<>--<>--<>--<>

-------DESCRIPTION!!!!!!!

V0.1 _ !!DATE!!__!!VERSION DESCRIPTION!!!!!

                                                       cc@hsb-cad.com
<>--<>--<>--<>--<>--<>--<>--<>_____  craigcad.us  _____<>--<>--<>--<>--<>--<>--<>--<>


//######################################################################################
//############################ Documentation #########################################
<insert>
Primarily intended to be inserted 
</insert>

<property name="xx">
- What are the important properties.
</ property >

<command name="xx">
- What are the custom commands.
</command>

<version  value=?0.85? date=?2july08?>
</version>

<remark>
_PtG[0] and _PtG[1] define the dimension orientation for custom scenarios
These two points are parked ! _PtW when doing Horizontal or Vertical orientations.

_PtG[2] defines main dimline location
_PtG[3] will locate overall dimension when it's requested, else it will also park @ _PtW;'
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
|	|_dViewScale
|
|_mpView
|	|_ptsVisible
|	|_ptsFace
|	|_ptsBack
|	|_dViewScale
|...

</MapFormats>
//########################## End Documentation #########################################
//######################################################################################
*/

String stCatalogName = "_Default";

int bIsMetricDwg = U(1, "mm") == 1;
int bIsMeterDwg = U(1, "mm") == .001;
int bIsInchDwg = U(1, "inch") == 1;


int bInDebug;
bInDebug = projectSpecial() == "db" ;

//set properties from map
if(_Map.hasMap("mpProps"))
{
	setPropValuesFromMap(_Map.getMap("mpProps"));
	_Map.removeAt("mpProps", 1);
}

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

String stYN[] = { "Yes", "No"};
String stDimTypeOptions[] = { "Ordinate", "Delta", "Delta + Overall"};
String stDimFormat[] = { "Decimal", "Fractional", "Inches Fractional"};
double dCompareTol = U(.1, "mm");
String stViewDirections[] = { T("|Outside|"), T("|Inside|")};
//######################################################################################		
//########################## Properties & Insert #############################################

int iDimstyleIndex = _DimStyles.find("Entekra Design", 0);
if (iDimstyleIndex < 0) iDimstyleIndex = 0;
String stDimensionTypeName = "Dimension Type";
PropString psDimType(0, stDimTypeOptions, stDimensionTypeName, 1);
PropString psDimstyle(1, _DimStyles, "Dimstyle", iDimstyleIndex);
PropString psDimFormat(2, stDimFormat, "Dimension Format", 2);

int bDoFractionalFormat = psDimFormat == stDimFormat[1];
int bDoFractionalInches = psDimFormat == stDimFormat[2];
int bDoDecimalFormat = psDimFormat == stDimFormat[0];

double dConversionFactor = 1;
if(bIsMetricDwg && bDoFractionalFormat) dConversionFactor = .039370078;
if(bIsMetricDwg && bDoFractionalInches) dConversionFactor = .039370078;
if (bIsInchDwg && bDoDecimalFormat) dConversionFactor = 25.4;
if (bIsMeterDwg && (bDoFractionalFormat || bDoFractionalInches)) dConversionFactor = 39.370078;

PropDouble pdTextHeight(0, 0, "Text Height Override");
PropDouble pdTextPadding(1, U(.0625, "inch"), "Text Height Padding");
PropDouble pdTextOffset(2, U(.3125), T("|Text Offset|"));
PropInt piLineColor (0, 1, "Line Color");
PropInt piTextColor (1, 5, "Text Color");
PropInt piPrecision( 2, 3, "Dimension Value Precision" );
if (piPrecision < 0) piPrecision.set(0);
if (piPrecision > 5) piPrecision.set(5);
int iPrecisionFactor = pow(10, piPrecision);//__piPrecision is the number of decimal places, this int will be used when rounding

PropString psLimitExtensionLines(3, stYN, "Limit Extention Lines");
int bLimitExtensionLines = psLimitExtensionLines == stYN[0];
PropDouble pdExtensionLineOffset(3, U(.0625), "Extension Line Offset");
PropString psViewDirection(4, stViewDirections, "View Direction");
PropString psTags(5, "", "Tags");
psTags.setDescription("List seperated by spaces or commas");
String stTags[] = psTags.tokenize(", ;");

int bDoOrdinateDimensions = psDimType == stDimTypeOptions[0];
int bDoDeltaDimensions = psDimType != stDimTypeOptions[0];
int bDoOverallDimension = psDimType == stDimTypeOptions[2];
int bViewFromInside = psViewDirection == stViewDirections[1];

if(_bOnInsert)
{
	if (insertCycleCount() > 1) eraseInstance();
	
	_Element.append(getElement());
	Element el = _Element0;
	
	Plane pnElFace(el.ptOrg(), el.vecZ());
	
	String stOrientationOptions = "Dimension Orientation: [" + "/" + "1: " + T("|Horizontal|") + "/" + "2:" + T("|Vertical|") + "/" + "3:" + T("|Custom|") + "]";
	String stOrientation;	
	
	if(_kExecuteKey == "")
	{
		showDialogOnce();
		bViewFromInside = psViewDirection == stViewDirections[1];
		stOrientation = getString(stOrientationOptions);
	}
	else
	{ 
		stOrientation = _kExecuteKey;
		_ThisInst.setPropValuesFromCatalog(stCatalogName);
	}
	

	
	Vector3d vDimDir = el.vecX();
	
	_PtG.append(_PtW);
	_PtG.append(_PtW);
	_PtG.append(_PtW);
	_PtG.append(_PtW);
	
	int iSafe;
	Point3d ptLast;
	PrPoint prp("Select points to dimension");
	Point3d ptsSelected[0];
	while(iSafe++ < 100)
	{
		if(prp.go() == _kOk)
		{ 
			ptLast = prp.value();
			_PtG.append(ptLast);
			ptsSelected.append(ptLast);
			
			prp = PrPoint("Select points to dimension", ptLast);				
		}
		else
		{ 
			break;
		}
	}
	
	Point3d ptMidSelection;
	ptMidSelection.setToAverage(ptsSelected);
	
	if(stOrientation == "3")
	{ 
		_PtG[0] = getPoint("Select Dimline Base Reference");
		PrPoint prp("Select Dimline Direction", _PtG[0]);
		if (prp.go() == _kOk) _PtG[1] = prp.value();
		vDimDir = _PtG[1] - _PtG[0];		
	}

	if (stOrientation == "1" && bViewFromInside) vDimDir = - el.vecX();
	if (stOrientation == "2") vDimDir = el.vecY();
	
	_Map.setString("stOrientationOption", stOrientation);
	_Map.setVector3d("vLastDimDir", vDimDir);
	
	Vector3d vZ = el.vecZ();
	Vector3d vToViewer = vZ;
	if (psViewDirection == stViewDirections[1]) 
	{
		vToViewer = - vZ;
	}
	
	Vector3d vDimPerp = vToViewer.crossProduct(vDimDir);
	PrPoint prpLocation("Select Dimline Location", ptMidSelection);
	if (prpLocation.go() == _kOk) 
	{
		_PtG[2] = prpLocation.value();
	}
	
	if(_PtG.length() < 3)//__something went wrong during insertion
	{ 
		eraseInstance();
		return;
	}
	

	
	return;
}



//########################## End Properties & Insert ###############################################
//######################################################################################	



//region  Construct basic Geometry
//################################################################
//################################################################

   
if(_Element.length() == 0)
{
	eraseInstance();
	return;
}

Element el = _Element0;
if(! el.bIsValid())
{ 
	eraseInstance();
	return;
}

assignToElementGroup(el);

int bIsHorizontal, bIsVertical, bIsCustomOrientation;
String stOrientation = _Map.getString("stOrientationOption");
if (stOrientation == "1") bIsHorizontal = true;
if (stOrientation == "2") bIsVertical = true;
if (stOrientation == "3") bIsCustomOrientation = true;

Point3d ptElOrg = el.ptOrg();
Vector3d vZ = el.vecZ();
Vector3d vX = el.vecX();
Vector3d vY = el.vecY();
Vector3d vToViewer = vZ;
Vector3d vRight = vX;

PLine plElEnvelope = el.plEnvelope();
Point3d ptsEnvelope[] = plElEnvelope.vertexPoints(true);
Plane pnElFace(ptElOrg, vZ); 

if (bViewFromInside) 
{
	pnElFace.transformBy(-vZ * el.dBeamWidth());
	vRight = -vX;
	vToViewer = - vZ;
}



Point3d ptElCen;
ptElCen.setToAverage(ptsEnvelope);
ptElCen = pnElFace.closestPointTo(ptElCen);


//__enforce grip locations
_Pt0 = _PtW;
Point3d ptsAllProjected[0];
for (int i = 4; i < _PtG.length(); i++) 
{
	_PtG[i] = pnElFace.closestPointTo(_PtG[i]);
	ptsAllProjected.append(_PtG[i]);
}

Point3d& ptDimBaseReference = _PtG[0];
Point3d& ptDimDirReference 	= _PtG[1];
Point3d& ptDimline = _PtG[2];
Point3d& ptOverallDimLocation = _PtG[3];

Vector3d vDimlineDirection = vRight; //__default horizontal orientation

if(bIsVertical)
{ 
	vDimlineDirection = vY;
}

if(bIsCustomOrientation)
{ 
	vDimlineDirection = ptDimDirReference - ptDimBaseReference;
	if(vDimlineDirection.length() < _st_dTol)
	{ 
		Vector3d vLastDimDir = _Map.getVector3d("vLastDimDir");
	}
}
else
{
	ptDimBaseReference = _PtW;//__park these two groups @ world origina when they're not needed
	ptDimDirReference = _PtW;
}

vDimlineDirection.normalize();
Line lnDimline(ptDimline, vDimlineDirection);
Point3d ptDimBaseMid; 
ptDimBaseMid.setToAverage(ptsAllProjected);

Vector3d vDimPerp = vToViewer.crossProduct(vDimlineDirection);//__this is good in most cases, but fails for Vertical
if(bIsVertical)
{ 
	Vector3d vSideCheck = ptDimBaseMid - ptElCen;
	vDimPerp = vSideCheck.dotProduct(vRight) > 0 ? vRight : - vRight;
}
vDimPerp.normalize();


Line lnDimMidPerp(ptDimBaseMid, vDimPerp);
Line lnDimBaseline(ptDimBaseReference, vDimlineDirection);//__this is valid in Custom orientation
vDimlineDirection.vis(ptDimline, 4);

ptDimline = lnDimMidPerp.closestPointTo(ptDimline);
Vector3d vDirCheck = ptDimline - ptDimBaseMid;
if (vDirCheck.dotProduct(vDimPerp) < 0) vDimPerp = - vDimPerp;


if(! bIsCustomOrientation)
{ 	
	ptsAllProjected = lnDimMidPerp.orderPoints(ptsAllProjected);
	lnDimBaseline = Line(ptsAllProjected.last(), vDimlineDirection);
}


//################################################################
//################################################################
//   End Construct basic Geometry
//endregion 

//region Context Commands

// Worried about performance with this section enabled
//##########################################################################################	
//########################## Context Commands  #############################################


//########################## End Context Commands  ###############################################
//######################################################################################

//endregion

//######################################################################################		
//########################## Draw dims #############################################	
Display dpLines(piLineColor);
Display dpText(piTextColor);
dpText.dimStyle(psDimstyle);
dpLines.showInDxa(true);
dpText.showInDxa(true);
dpText.addHideDirection(- vToViewer);
dpLines.addHideDirection(- vToViewer);

double dTextH = dpText.textHeightForStyle("YqY", psDimstyle);
if(pdTextHeight > 0)
{
	dpText.textHeight(pdTextHeight);
	dTextH = pdTextHeight;
}
Vector3d vText = vDimPerp;
int iTextFlag = 1;

if (vText.dotProduct(vRight) < 0) 
{
	vText *= -1;
	iTextFlag = - 1;
}
Vector3d vTextPerp = vToViewer.crossProduct(vText);

double dTextSpace = dTextH + pdTextPadding;

vText.vis(ptElCen, 3);
vTextPerp.vis(ptElCen, 4);



Point3d ptsToDim[0];
for (int i=4;i<_PtG.length();i++) 
{ 
	ptsToDim.append(_PtG[i]); 
	 
}

double dFilterTolerance = U(.1, "mm");

//__save a copy in original position
Point3d ptsToDimInPlace[0];
ptsToDimInPlace = ptsToDim;

if(bInDebug) reportMessage("\nptsToDim.length() = " + ptsToDim.length());

//__project points to one side and order, will also remove duplicates
ptsToDim = lnDimBaseline.projectPoints(ptsToDim);
ptsToDim = lnDimBaseline.orderPoints(ptsToDim);


Line lnDimText = lnDimline;
lnDimText.transformBy(vDimPerp * pdTextOffset);
Line lnDimExtensionEnds = lnDimBaseline;
lnDimExtensionEnds.transformBy(vDimPerp * pdExtensionLineOffset);
lnDimText.vis(7);
vDimPerp.vis(ptDimline, 4);

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
		double dDimension = (ptDim - ptDimRef).length() * dConversionFactor;
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
	Point3d ptLeaderEndPoint = lnDimExtensionEnds.closestPointTo(ptPreviousDimPoint);
	
	//__might as well draw delta graphics in this loop
	if(! bLimitExtensionLines)
	{ 
		Line lnExtension (ptOnDimline, - vDimPerp);
		Point3d ptsLine[] = lnExtension.filterClosePoints(ptsToDim, dFilterTolerance);
		ptsLine = lnExtension.orderPoints(ptsLine);
		if (ptsLine.length() > 0) 
		{
			ptLeaderEndPoint = ptsLine[0] + vDimPerp*pdExtensionLineOffset ;
			ptLeaderEndPoint.vis(7);
		}
	}
	PLine lsExtension(ptLeaderEndPoint,  ptOnDimline + vDimPerp * dTextSpace/2);
	dpLines.draw(lsExtension);
	
	Vector3d vTickDir = vDimlineDirection - vDimPerp; vTickDir.normalize();
	vTickDir *= dTextH/4;
	PLine lsTick(ptOnDimline + vTickDir, ptOnDimline - vTickDir);
	dpLines.draw(lsTick);
			
	
	for(int n=1;n<ptsToDim.length();n++)
	{ 
		Point3d ptDim = ptsToDim[n];
		ptOnDimline = lnDimline.closestPointTo(ptDim);
		Point3d ptLeaderEnd = ptDim + vDimPerp * pdExtensionLineOffset;
		
		if(! bLimitExtensionLines)
		{ 
			Line lnExtension (ptOnDimline, - vDimPerp);
			Point3d ptsLine[] = lnExtension.filterClosePoints(ptsToDim, dFilterTolerance);
			ptsLine = lnExtension.orderPoints(ptsLine);				
			if (ptsLine.length() > 0) 
			{
				ptLeaderEnd = ptsLine[0] + vDimPerp * pdExtensionLineOffset;
			}
			//ptLeaderEnd.vis(7);
		}
		
		
		double dDimension = (ptDim - ptPreviousDimPoint).length() * dConversionFactor;
		//dDimension = round(dDimension*iPrecisionFactor)/iPrecisionFactor;
		if(dDimension == 0) continue;//__can happen with some geometry and precision factors
		Point3d ptDimText = lnDimText.closestPointTo((ptPreviousDimPoint + ptDim)/2);//lnDimline.closestPointTo(ptPreviousDimPoint) + (ptOnDimline - ptPreviousDimPoint)/2;
		Map mpDimCluster, mpDimPoint;
		
		mpDimPoint.setPoint3d("ptDim", ptDimText);
		mpDimPoint.setDouble("dDim", dDimension);
		mpDimCluster.appendMap("mpDimPoint", mpDimPoint);
		mpDimClusters.appendMap("mpDimCluster", mpDimCluster);
		
		//__draw dimlines and extensions
		PLine lsDimline (ptOnDimline, lnDimline.closestPointTo(ptPreviousDimPoint));
		dpLines.draw(lsDimline);
		PLine lsExtension(ptLeaderEnd, ptOnDimline + vDimPerp * dTextH/2);
		dpLines.draw(lsExtension);
		PLine lsTick(ptOnDimline + vTickDir, ptOnDimline - vTickDir);
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
		Point3d ptCheckTextStart = ptCheckMid - vDimlineDirection * (dTextSpace * iPointCount)/2;
		
		int iLastPointCount = mpLastDimCluster.length();
		Point3d ptLastEnd = mpLastDimCluster.getMap(iLastPointCount-1).getPoint3d("ptDim");					
		Point3d ptLastStart = mpLastDimCluster.getMap(0).getPoint3d("ptDim");
		Point3d ptLastMid = ptLastStart + (ptLastEnd - ptLastStart)/2;
		
		//__Stored points are actual dimpoint positions, text locations have to be calculated from these sources
		Point3d ptLastTextEnd = ptLastMid + vDimlineDirection * (dTextSpace * iLastPointCount)/2;

		double dDistCheck = (ptCheckTextStart - ptLastTextEnd).dotProduct(vDimlineDirection); 

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
				
lnDimExtensionEnds.vis(8);

//__ loop through clusters and draw dimensions
for(int n=0; n<mpDimClusters.length(); n++)
{
	Map mpDimCluster = mpDimClusters.getMap(n);
	int iPointCount = mpDimCluster.length();					
	double dClusterSpace = iPointCount * dTextSpace;
	
	Point3d ptClusterStart = mpDimCluster.getMap(0).getPoint3d("ptDim");					
	Point3d ptClusterEnd = mpDimCluster.getMap(iPointCount-1).getPoint3d("ptDim");

	Point3d ptClusterMid = ptClusterStart + (ptClusterEnd - ptClusterStart)/2;
	Point3d ptTextStart = lnDimText.closestPointTo(ptClusterMid) -vDimlineDirection * (dClusterSpace - dTextSpace)/2;

	for (int s=0; s<iPointCount; s++)
	{
		Map mpDimPoint = mpDimCluster.getMap(s);
		Point3d ptDim = mpDimPoint.getPoint3d("ptDim");
		Point3d ptOnDimline = lnDimline.closestPointTo(ptDim);
		Point3d ptLeaderEnd = lnDimExtensionEnds.closestPointTo(ptDim);
		double dDimension = mpDimPoint.getDouble("dDim");			
		double dDimensionRounded =  round(dDimension*iPrecisionFactor)/iPrecisionFactor;
		
		if (! bLimitExtensionLines && bDoOrdinateDimensions)
		{
			Line ln( ptDim, -vDimPerp ) ;
			Point3d ptsLine[] = ln.filterClosePoints( ptsToDimInPlace, dFilterTolerance) ;
			//Point3d ptsLine[] = ln.filterClosePoints( ptsToDim, dFilterTolerance) ;
			ptsLine = ln.orderPoints( ptsLine) ;
			if ( ptsLine.length() > 0 ) ptLeaderEnd = ptsLine[0] + vDimPerp * pdExtensionLineOffset;		 	
		}			
		
		Point3d ptLeaderAngle = ptOnDimline;
		Point3d ptText = ptTextStart + vDimlineDirection * s * dTextSpace;

		String stDimension = dDimensionRounded ;
		if (bDoFractionalFormat) stDimension = String().formatUnit(dDimension, 4, piPrecision);					
		if (bDoFractionalInches) 
		{
			stDimension = String().formatUnit(dDimension, 5, piPrecision);	
			stDimension += "\"";
		}
		
								
		if(bDoOrdinateDimensions)
		{			
			PLine plLeader(vToViewer);
			plLeader.addVertex(ptLeaderEnd);	
			plLeader.addVertex(ptLeaderAngle);				
			plLeader.addVertex(ptText);
			dpLines.draw(plLeader);				
		}
		
		dpText.draw(stDimension, ptText, vText, vTextPerp, iTextFlag, 0);
	}
	
}
Point3d ptStartRef = ptsToDim[0];
Point3d ptEndRef = ptsToDim[ptsToDim.length() - 1];
if(bDoOverallDimension)
{ 
	
	double dOverallDim = (ptEndRef - ptStartRef).length() * dConversionFactor;
	double dOverallOffset = (ptOverallDimLocation - ptDimline).length();
	double dExtend = pdTextOffset / 4;
	
	Point3d ptDimlineStartInt = ptStartRef + vDimPerp * dOverallOffset;
	PLine lsStart(ptStartRef,  ptDimlineStartInt + vDimPerp * dExtend);
	Point3d ptDimlineEndInt = ptEndRef + vDimPerp * dOverallOffset;
	PLine lsEnd(ptEndRef, ptDimlineEndInt +vDimPerp * dExtend);
	PLine lsDimline (ptDimlineStartInt - vDimlineDirection * dExtend, ptDimlineEndInt + vDimlineDirection * dExtend);
	
	dpLines.draw(lsStart);
	dpLines.draw(lsEnd);
	dpLines.draw(lsDimline);
	
	Vector3d vTickDir = vDimlineDirection - vDimPerp; vTickDir.normalize();
	vTickDir *= dTextH/4;
	PLine lsTick(ptDimlineEndInt + vTickDir, ptDimlineEndInt - vTickDir);
	dpLines.draw(lsTick);
	lsTick = PLine(ptDimlineStartInt + vTickDir, ptDimlineStartInt - vTickDir);
	dpLines.draw(lsTick);
	
	//double dDimension = abs((ptStartRef - ptEndRef).dotProduct(vDimlineDirection));
	double dDimensionRounded =  round(dOverallDim*iPrecisionFactor)/iPrecisionFactor;
	String stDimension = dDimensionRounded ;
	if (bDoFractionalFormat) stDimension = String().formatUnit(dOverallDim, 4, piPrecision);					
	if (bDoFractionalInches) 
	{
		stDimension = String().formatUnit(dOverallDim, 5, piPrecision);	
		stDimension += "\"";
	}
	

	Point3d ptText = ptOverallDimLocation + vDimPerp * dTextH * .6;
	dpText.draw(stDimension,ptText, vText, vTextPerp, iTextFlag, 0);
}

_Map.setVector3d("vLastDimDir", vDimlineDirection);


if(bInDebug)
{ 
	Display dp(1);
	for (int i=0;i<_PtG.length();i++) 
	{ 
		Point3d pt = _PtG[i]; 
		dp.draw(i, pt, vDimlineDirection, vDimPerp, 1.2, 1.2);
	}
	
}

//########################## End Draw dims ###############################################
//######################################################################################	
			

//region  Record Tags
//################################################################
//################################################################

Map mpTags;
mpTags.setMapName("Hsb_Tag");
for (int i=0;i<stTags.length();i++) 
{ 
	mpTags.appendString("Tag", stTags[i]); 
}
_ThisInst.setSubMapX("Hsb_Tag", mpTags);

//################################################################
//################################################################
//   End Record Tags
//endregion    


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
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Bugfix on revised insertion routine" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="55" />
      <str nm="Date" vl="2/11/2022 6:28:03 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Updated to be tolerant of translated input strings" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="53" />
      <str nm="Date" vl="2/10/2022 7:24:08 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End