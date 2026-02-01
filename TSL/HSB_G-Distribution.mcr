#Version 8
#BeginDescription
Last modified by: Robert Pol (support.nl@hsbcad.com)
07.12.2018  -  version 1.03
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
/// This tsl calculates a distribution between two points. The distribution positions can be retrieved through MapIO.
/// </summary>

/// <insert>
/// 
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.03" date="07.12.2018"></version>

/// <history>
/// AS - 1.00 - 03.08.2016 - First revision
/// AS - 1.01 - 01.09.2016 - Add distribution types
/// AS - 1.02 - 31.01.2018 - Ignore distribute evenly when spacing exceeds distribution length.
/// RP - 1.03 - 07.12.2018 - If spacingProp < 0 return, because of /0
/// </history>

double pointTolerance = Unit(0.1, "mm");

String categories[] = {
	T("|Distribution|"),
	T("|Start and end positions|"),
	T("|Dimension|")
};

String noYes[] = {T("|No|"), T("|Yes|")};

PropDouble startOffset(1, U(0), T("|Start offset|"));
startOffset.setCategory(categories[0]);
startOffset.setDescription(T("|Sets the offset from the start of the distribution|."));

PropDouble endOffset(2, U(0), T("|End offset|"));
endOffset.setCategory(categories[0]);
endOffset.setDescription(T("|Sets the offset from the end of the distribution|."));

PropDouble spacingProp(0, U(600), T("|Spacing|"));
spacingProp.setCategory(categories[0]);
spacingProp.setDescription(T("|Sets the spacing of the distribution|."));

String distributionTypes[] = {
	T("|From start to end|"),
	T("|From end to start|"),
	T("|From centre|"),
	T("|From centre, no position in centre|")
};
PropString distributionType(1, distributionTypes, T("|Distribution type|"), 0);
distributionType.setCategory(categories[0]);
distributionType.setDescription(T("|Sets the distribution type of the distribution|."));

PropString distributeEvenlyProp(0, noYes, T("|Distribute evenly|"), 0);
distributeEvenlyProp.setCategory(categories[0]);
distributeEvenlyProp.setDescription(T("|Specifies whether the spacing is changed to fit the whole distribution length|."));

PropString useStartAsPositionProp(3, noYes, T("|Use start as position|"), 0);
useStartAsPositionProp.setCategory(categories[1]);
useStartAsPositionProp.setDescription(T("|Specifies whether the start position is a distribution position or not|."));

PropString useEndAsPositionProp(4, noYes, T("|Use end as position|"), 0);
useEndAsPositionProp.setCategory(categories[1]);
useEndAsPositionProp.setDescription(T("|Specifies whether the start position is a distribution position or not|."));

PropDouble allowedDistanceBetweenPositions(3, U(10), T("|Allowed distance between positions|"));
allowedDistanceBetweenPositions.setCategory(categories[1]);
allowedDistanceBetweenPositions.setDescription(T("|Sets the allowed distance between the extreme distribution positions and the start and end position of the distribution|."));

PropString showDimensionLineProp(5, noYes, T("|Show dimension lines|"), 1);
showDimensionLineProp.setCategory(categories[2]);
showDimensionLineProp.setDescription(T("|Specifies whether the dimension line is visible|."));

PropString dimStyle(2, _DimStyles, T("|Dimension style|"));
dimStyle.setCategory(categories[2]);
dimStyle.setDescription(T("|Sets the dimension style|."));

if (_bOnInsert) {
	_Pt0 = getPoint(T("|Select start distribution|"));
	_PtG.append(getPoint(T("|Select end distribution|")));
	
	_Map.setInt("ManualInsert", true);
	
	return;
}

int manualInsert = false;
if (_Map.hasInt("ManualInsert")) {
	manualInsert = _Map.getInt("ManualInsert");
	_Map.removeAt("ManualInsert", true);
}

Display display(1);
display.dimStyle(dimStyle);

if (_bOnMapIO || manualInsert) {
	Point3d startDistribution, endDistribution;
	if (_bOnMapIO) {
		startDistribution = _Map.getPoint3d("StartPosition");
		endDistribution = _Map.getPoint3d("EndPosition");
		
		if (_Map.hasDouble("StartOffset"))
			startOffset.set(_Map.getDouble("StartOffset"));
		if (_Map.hasDouble("EndOffset"))
			endOffset.set(_Map.getDouble("EndOffset"));
		if (_Map.hasDouble("SpacingProp"))
			spacingProp.set(_Map.getDouble("SpacingProp"));
		if (_Map.hasInt("DistributionType"))
			distributionType.set(distributionTypes[_Map.getInt("DistributionType")]);
		if (_Map.hasInt("DistributeEvenlyProp"))
			distributeEvenlyProp.set(noYes[_Map.getInt("DistributeEvenlyProp")]);
		if (_Map.hasInt("UseStartAsPositionProp"))
			useStartAsPositionProp.set(noYes[_Map.getInt("UseStartAsPositionProp")]);
		if (_Map.hasInt("UseEndAsPositionProp"))
			useEndAsPositionProp.set(noYes[_Map.getInt("UseEndAsPositionProp")]);
		if (_Map.hasDouble("AllowedDistanceBetweenPositions"))
			allowedDistanceBetweenPositions.set(_Map.getDouble("AllowedDistanceBetweenPositions"));
	}
	else {
		startDistribution = _Pt0;
		endDistribution = _PtG[0];
	}

//reportNotice("\n\n\t***\nStartOffset:\t"+startOffset);
//reportNotice("\nEndOffset:\t"+endOffset);
//reportNotice("\nSpacingProp:\t"+spacingProp);
//reportNotice("\nDistributionType:\t"+distributionType);
//reportNotice("\nDistributeEvenlyProp:\t"+distributeEvenlyProp);
//reportNotice("\nUseStartAsPositionProp:\t"+useStartAsPositionProp);
//reportNotice("\nUseEndAsPositionProp:\t"+useEndAsPositionProp);
//reportNotice("\nAllowedDistanceBetweenPositions:\t"+allowedDistanceBetweenPositions);
//reportNotice(_Map);

	Point3d startReference = startDistribution;
	Point3d endReference = endDistribution;
	
	int distributeFromStart = distributionTypes.find(distributionType) == 0;
	int distributeFromEnd = distributionTypes.find(distributionType) == 1;
	int distributeFromCentre = distributionTypes.find(distributionType) > 1;
	int distributionPositionInCentre =  distributionTypes.find(distributionType) == 2;
	
	int distributeEvenly = noYes.find(distributeEvenlyProp);
	int useStartAsPosition = noYes.find(useStartAsPositionProp);
	int useEndAsPosition = noYes.find(useEndAsPositionProp);
	
	int showDimensionLine = noYes.find(showDimensionLineProp);
		
	if (distributeFromEnd) {
		Point3d pt = startDistribution;
		startDistribution = endDistribution;
		endDistribution = pt;
	}	
	
	Vector3d distributionX = endDistribution - startDistribution;
	double distributionLength = round(distributionX.length() - (startOffset + endOffset));
	distributionX.normalize();
	startDistribution += distributionX * startOffset;
	endDistribution -= distributionX * endOffset;
	
	// Start distribution might change, depending on the distribution type.
	Point3d originalStartPosition = startDistribution;
	Point3d originalEndPosition = endDistribution;
	
	double spacing = round(spacingProp);
	if (spacingProp < pointTolerance)
	{
		return;
	}
	if (distributeEvenly && spacing < distributionLength) 
	{
		int numberOfSpaces = ceil(distributionLength/round(spacingProp));
		int oddNumberOfSpaces = (numberOfSpaces/2.0 - int(numberOfSpaces/2)) > 0;
	
		if (distributeFromCentre)
			if ((distributionPositionInCentre && oddNumberOfSpaces) || (!distributionPositionInCentre && !oddNumberOfSpaces))
				numberOfSpaces++;				
		
		spacing = distributionLength/numberOfSpaces;
	}
	else if (distributeFromCentre) {
		Point3d centrePosition = (startDistribution + endDistribution)/2;
				
		if (distributionPositionInCentre) {
			double startToCentre = distributionX.dotProduct(centrePosition - startDistribution);
			startDistribution = centrePosition - distributionX * int(startToCentre/spacing) * spacing;
		}
		else {
			Point3d offsettedCentrePosition = centrePosition - distributionX * 0.5 * spacing;
			double startToOffsettedCentre = distributionX.dotProduct(offsettedCentrePosition - startDistribution);
			startDistribution = offsettedCentrePosition - distributionX * int(startToOffsettedCentre/spacing) * spacing;
		}
	}
	
	Point3d distributionPositions[0];
	Point3d currentPosition = startDistribution;
	int infiniteLoopProtector = 0;
	while (distributionX.dotProduct(endDistribution - currentPosition) > -pointTolerance) {
		infiniteLoopProtector++;
		if (infiniteLoopProtector > 1000)
			break;
		
		distributionPositions.append(currentPosition);
		
		currentPosition += distributionX * spacing;
	}
	
	int startPositionUsed = false;
	int endPositionUsed = false;
	int enoughSpaceAvailableToAddStartPosition = false;
	int enoughSpaceAvailableToAddEndPosition = false;
	if (distributionPositions.length() > 0) {
		Point3d firstDistributionPosition = distributionPositions[0];
		Point3d lastDistributionPosition = distributionPositions[distributionPositions.length() - 1];
		
		double availableSpaceForStartPosition = abs(distributionX.dotProduct(firstDistributionPosition - originalStartPosition));
		double availableSpaceForEndPosition = abs(distributionX.dotProduct(lastDistributionPosition - originalEndPosition));
		startPositionUsed = availableSpaceForStartPosition < pointTolerance;
		endPositionUsed = availableSpaceForEndPosition < pointTolerance;
		
		enoughSpaceAvailableToAddStartPosition = availableSpaceForStartPosition > allowedDistanceBetweenPositions;
		enoughSpaceAvailableToAddEndPosition = availableSpaceForEndPosition > allowedDistanceBetweenPositions;
	}
	
	if (useStartAsPosition && !startPositionUsed && enoughSpaceAvailableToAddStartPosition)
		distributionPositions.insertAt(0, originalStartPosition);
	else if (!useStartAsPosition && startPositionUsed)
		distributionPositions.removeAt(0);
	
	if (useEndAsPosition && !endPositionUsed && enoughSpaceAvailableToAddEndPosition)
		distributionPositions.append(originalEndPosition);
	else if (!useEndAsPosition && endPositionUsed)
		distributionPositions.removeAt(distributionPositions.length() - 1);

	for (int p=0;p<distributionPositions.length();p++) {
		Point3d distributionPosition = distributionPositions[p];
		
		PLine circle(_ZW);
		circle.createCircle(distributionPosition, _ZW, 0.1 * spacing);
		display.draw(circle);		
	}

	if (showDimensionLine) {
		Point3d dimensionPoints[] = {
			startReference, 
			originalStartPosition,
			originalEndPosition,
			endReference
		};
		dimensionPoints.append(distributionPositions);
		Vector3d dimY = _ZW.crossProduct(distributionX);
		
		DimLine dimLine(_Pt0 - dimY * U(1000), distributionX, dimY);
		Dim dim(dimLine, dimensionPoints, "<>", "<>", _kDimPar, _kDimPerp);
		display.draw(dim);
	}
	
	if (_bOnMapIO) {
		_Map.setPoint3dArray("DistributionPositions", distributionPositions);
		return;
	}
		
	_Map.setInt("ManualInsert", true);
}
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