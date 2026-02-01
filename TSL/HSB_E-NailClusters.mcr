#Version 8
#BeginDescription
This tsl creates nail clusters to nail one zone on anther zone. The nail clusters are centered, with the specified offsets, in the intersecting areas between the 2 zones.
1.25 12/12/2023 Add the numbers of Nails to MAP data : Robert Pol

1.24 20/09/2022 Replace reportwarning with notice Author: Robert Pol

1.23 07/03/2022 Add option to take the center of the boundingbox as position Author: Robert Pol


1.26 07/05/2024 Add excentric offsets Author: Robert Pol

1.27 26/06/2025 Add nailpositions in map Author: Robert Pol
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 27
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl creates nail clusters to nail one zone on anther zone. The nail clusters are centered, with the specified offsets, in the intersecting areas between the 2 zones. 
/// </summary>

/// <insert>
/// 
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.20" date="15.05.2019"></version>

/// <history>
/// AS - 1.00 - 15.06.2017 -	First revision
/// AS - 1.01 - 29.08.2017 - 	Add minimum required distance to edge.
/// AS - 1.02 - 29.08.2017 - 	Add context options to add and remove no nail areas.
/// AS - 1.03 - 29.08.2017 - 	Add label filter.
/// AS - 1.04 - 31.08.2017 - 	Blow up individual profiles before merging them.
/// AS - 1.05 - 25.09.2017 - 	Add option to place one or two nails.
/// AJ - 1.06 - 08.10.2017 - 	Add nails to the area extreme points.
/// AS - 1.07 - 10.10.2017 - 	Set shrink distance from 50 to 0.1 because that was causing the profile of laths to be joined
/// AS - 1.08 - 10.10.2017 - 	Reset profile before getting nail area's
/// AJ - 1.09 - 15.10.2017 - 	Improve the way the extreme points were calculated.
/// CS - 1.10 - 02.11.2017 - 	Added properties and implemented nailing distribution in the event that the longest segment of the intersection profile exceeds a certain length.
/// CS - 1.11 - 07.11.2017 - 	Added property for specifying a filter definition.  Also excluded all beams which are marked as "NONAIL" from being nailed.
/// CS - 1.12 - 08.11.2017 - 	Changed code to remove beams marked as "NONAIL" from the reference zone rather than the zone which is being nailed.
/// CS - 1.13 - 15.11.2017 - 	Bugfix on filtering implementation and corrected creation of a cluster when distribution length is too small.  Also bugfix on cloning extreme point cluster property.
/// CS - 1.14 - 16.11.2017 - 	Improved determination of nail cluster location when distribution is too small to process.
/// CS - 1.15 - 20.11.2017 - 	Checked longest length of splits in distribution along 3 slices of shrunken profile.
/// AS - 1.16 - 30.05.2018 - 	Correct counters. Do not break, but continue, if one of the area's is not valid.
/// AS - 1.17 - 30.05.2018 - 	Add delete as execute key.
/// RP - 1.18 - 30.10.2018 - 	Do not shrink back brander profile because its not necesarry and could mess up the planeprofile
/// RP - 1.19 - 25.04.2019 - 	Cleanup PolyLine before getting center point
/// RP - 1.20 - 15.05.2019 - 	Add genbeamfilter for zone to nail on.
/// FA - 1.21 - 30.03.2020 - 	Added identifier to apply multiple tsl instances on one element
/// RP - 1.22 - 24.02.2021 - 	Blow up brander profile before shrinking because of issues with branders not touching completly
/// RP - 1.23 - 07.03.2022 - 	Add option to take the center of the boundingbox as position
// #Versions
//1.27 26/06/2025 Add nailpositions in map Author: Robert Pol
//1.26 07/05/2024 Add excentric offsets Author: Robert Pol
//1.24 20/09/2022 Replace reportwarning with notice Author: Robert Pol
//1.25 12/12/2023 Add the numbers of Nails to MAP Author: Robert Pol
/// </history>

String deleteCommand = T("|Delete|");
if (_kExecuteKey == deleteCommand)
{
	eraseInstance();
	return;
}

String addNoNailAreaCommand = T("|Add no nail areas|");
String removeNoNailAreaCommand = T("|Remove no nail areas|");
addRecalcTrigger(_kContext, addNoNailAreaCommand);
addRecalcTrigger(_kContext, removeNoNailAreaCommand);


String categories[] = 
{
	T("|Objects to nail|"),
	T("|Nail settings|"),
	T("|Nail distribution|")
};

String sArNY[] = {T("No"), T("Yes")};


String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = TslInst().getListOfCatalogNames(filterDefinitionTslName);
filterDefinitions.insertAt(0,"");

PropString genBeamFilterDefinitionToNail(2, filterDefinitions, T("|Filter definition for genbeams to nail|"));
genBeamFilterDefinitionToNail.setDescription(T("|Filter definition for beams to nail.|") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));
genBeamFilterDefinitionToNail.setCategory(categories[0]);

PropString genBeamFilterDefinitionToNailOn(3, filterDefinitions, T("|Filter definition for genbeams to nail on|"));
genBeamFilterDefinitionToNailOn.setDescription(T("|Filter definition for beams to nail on.|") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));
genBeamFilterDefinitionToNailOn.setCategory(categories[0]);

PropString tslIdentifier(4, "Pos 1", " " + T("|Tsl identifier|"));
tslIdentifier.setDescription(T("|Only one tsl instance, per identifier, can be attached to an element.|")); 

PropString labelFilter(0, "", T("|Filter sheets with label|"));
labelFilter.setCategory(categories[0]);

int zoneIndexes[] = { 0,1,2,3,4,5,6,7,8,9,10};
PropInt zoneToNailProp(0, zoneIndexes, T("|Zone to nail|"));
zoneToNailProp.setCategory(categories[0]);

PropInt zoneToNailOnProp(1, zoneIndexes, T("|Zone to nail on|"));
zoneToNailOnProp.setCategory(categories[0]);

int oneOrTwo[] = { 1, 2 };
PropInt numberOfNails(3, oneOrTwo, T("|Number of nails|"), 1);
numberOfNails.setCategory(categories[1]);
numberOfNails.setDescription(T("|Sets the number of nails.|"));

PropInt toolIndex(2, 1, T("|Tool index|"));	
toolIndex.setCategory(categories[1]);
toolIndex.setDescription(T("|Sets the tool index.|"));

PropDouble verticalExcentricNailOffset(5, U(0), T("|Vertical excentric offset|"));
verticalExcentricNailOffset.setCategory(categories[1]);
verticalExcentricNailOffset.setDescription(T("|Set the vertical excentric offset from the center of the nail area.|"));

PropDouble horizontalExcentricNailOffset(6, U(0), T("|Horizontal excentric offset|"));
horizontalExcentricNailOffset.setCategory(categories[1]);
horizontalExcentricNailOffset.setDescription(T("|Set the horizontal excentric offset from the center of the nail area.|"));

PropDouble verticalNailOffset(0, U(12), T("|Vertical offset|"));
verticalNailOffset.setCategory(categories[1]);
verticalNailOffset.setDescription(T("|Set the vertical offset from the center of the nail area.|"));

PropDouble horizontalNailOffset(1, U(9), T("|Horizontal offset|"));
horizontalNailOffset.setCategory(categories[1]);
horizontalNailOffset.setDescription(T("|Set the horizontal offset from the center of the nail area.|"));

PropDouble minimumDistanceSheetEdge(2, U(5), T("|Minimum distance to sheet edge|"));
minimumDistanceSheetEdge.setCategory(categories[1]);
minimumDistanceSheetEdge.setDescription(T("|Set the minimum required distance to the edge of the sheets in the specified zones.|"));

PropString sAddNailingToExtremes (1, sArNY, T("Add nails to the area extreme points"));
sAddNailingToExtremes.setCategory(categories[1]);
sAddNailingToExtremes.setDescription(T("|It will add nails to the extreme points of the valid area, ignoring the vertical and horizontal offset only when they go out of the bounderies.|"));

PropString sTakeCenterOfBoundingBox(5, sArNY, T("Take the center of the bounding box as position"));
sTakeCenterOfBoundingBox.setCategory(categories[1]);
sTakeCenterOfBoundingBox.setDescription(T("|It will add nails from the center of the boundingbox.|"));

PropDouble minimumDistanceForNailDistribution(3, U(0), T("|Minimum length for nail distribution|"));
minimumDistanceForNailDistribution.setCategory(categories[2]);
minimumDistanceForNailDistribution.setDescription(T("|Sets the minimum required length after which the nailing will be distributed, otherwise it will be based on a point.|"));

PropDouble distributedNailSpacing(4, U(50), T("|Nail Spacing|"));
distributedNailSpacing.setCategory(categories[2]);
distributedNailSpacing.setDescription(T("|Sets the spacing for distributed nailing.|"));

double shrinkOffsetObjectsToNail = U(0.1);
double shrinkOffsetBrander = U(0.1);

// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if( catalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

if (_bOnInsert) {
	if (insertCycleCount() > 1) 
	{
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || catalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	setCatalogFromPropValues(T("_LastInserted"));
	
	Element  selectedElements[0];
	PrEntity ssE(T("|Select elements|"), Element());
	if (ssE.go())
		selectedElements.append(ssE.elementSet());
	
	String strScriptName = scriptName();
	Vector3d vecUcsX(1,0,0);
	Vector3d vecUcsY(0,1,0);
	Beam lstBeams[0];
	Entity lstEntities[1];
	
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	Map mapTsl;
	mapTsl.setInt("ManualInserted", true);

	for (int e=0;e<selectedElements.length();e++) 
	{
		Element selectedElement = selectedElements[e];
		if (!selectedElement.bIsValid())
			continue;
		
		// check for existing tsls
		TslInst elTsls[] = selectedElement.tslInst();
		
		for (int index=0;index<elTsls.length();index++) 
		{ 
			TslInst tsl = elTsls[index]; 
			if (tsl.scriptName() == scriptName() && tsl.handle() != _ThisInst.handle() && tsl.propString(4) == tslIdentifier)
				tsl.dbErase();
		}
		
		lstEntities[0] = selectedElement;
		
		TslInst tslNew;
		tslNew.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
	}
	
	eraseInstance();
	return;
}


if( _Element.length() != 1 )
{
	reportNotice(TN("|No element selected!|"));
	eraseInstance();
	return;
}

int manualInserted = false;
if (_Map.hasInt("ManualInserted")) 
{
	manualInserted = _Map.getInt("ManualInserted");
	_Map.removeAt("ManualInserted", true);
}

// set properties from catalog
if (_bOnDbCreated && manualInserted)
	setPropValuesFromCatalog(T("|_LastInserted|"));

Element el = _Element[0];
if (!el.bIsValid())
{
	reportNotice(TN("|The selected element is invalid|!"));
	eraseInstance();
	return;
}

tslIdentifier.setReadOnly(true);
// Resolve properties

String labels[0];
String list = (labelFilter + ";");
int caseSensitive = false;
if (!caseSensitive)
	list.makeUpper();
int tokenIndex = 0; 
int characterIndex = 0;
while(characterIndex < list.length()-1){
	String listItem = list.token(tokenIndex,";");
	tokenIndex++;
	if(listItem.length()==0){
		characterIndex++;
		continue;
	}
	characterIndex = list.find(listItem,0);
	listItem.trimLeft();
	listItem.trimRight();
	labels.append(listItem);
}

int zoneToNail = zoneToNailProp;
if (zoneToNail > 5)
	zoneToNail = 5 - zoneToNail;

int nailSide = zoneToNail < 0 ? -1 : 1;
int zoneToNailOn = zoneToNailOnProp; //Brander zone
if (zoneToNailOn > 5)
	zoneToNailOn = 5 - zoneToNailOn;

double shrinkSheetToNail = minimumDistanceSheetEdge;
double shrinkSheetToNailOn = minimumDistanceSheetEdge;
int nAddNailingToExtremesOfNailAreaIfNoValidCluster = sArNY.find(sAddNailingToExtremes, 0);
int nTakeCenterOfBoundingBox = sArNY.find(sTakeCenterOfBoundingBox, 0);


CoordSys csEl = el.coordSys();
Point3d elOrg = csEl.ptOrg();
Vector3d elX = csEl.vecX();
Vector3d elY = csEl.vecY();
Vector3d elZ = csEl.vecZ();

_Pt0 = elOrg;

assignToElementGroup(el, true, zoneToNail, 'T');

Plane pnZ(elOrg, elZ);

Point3d nailPlaneOrigin = el.zone(zoneToNail).coordSys().ptOrg();
nailPlaneOrigin.vis(zoneToNail);
Plane pnNail(nailPlaneOrigin, elZ);

GenBeam genBeams[] = el.genBeam();

PlaneProfile nailProfile(csEl);
PlaneProfile branderProfile(csEl);

PlaneProfile allGBmProfiles[0];

Entity genBeamEntities[0];{ }
for (int b=0;b<genBeams.length();b++)
{
	genBeamEntities.append(genBeams[b]);
}

Map filterGenBeamsMap;
filterGenBeamsMap.setEntityArray(genBeamEntities, false, "GenBeams", "GenBeams", "GenBeam");
int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, genBeamFilterDefinitionToNail, filterGenBeamsMap);
if (!successfullyFiltered) {
	reportNotice(T("|Beams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
	eraseInstance();
	return;
} 

Entity filteredGenBeamEntities[] = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");
GenBeam gbNailalble[0];
for (int e=0;e<filteredGenBeamEntities.length();e++) 
{
	GenBeam bm = (GenBeam)filteredGenBeamEntities[e];
	if (!bm.bIsValid()) continue;

	gbNailalble.append(bm);
}

filterGenBeamsMap;
filterGenBeamsMap.setEntityArray(genBeamEntities, false, "GenBeams", "GenBeams", "GenBeam");
successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, genBeamFilterDefinitionToNailOn, filterGenBeamsMap);
if (!successfullyFiltered) {
	reportNotice(T("|Beams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
	eraseInstance();
	return;
} 

filteredGenBeamEntities = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");
GenBeam gbToNailOn[0];
for (int e=0;e<filteredGenBeamEntities.length();e++) 
{
	GenBeam bm = (GenBeam)filteredGenBeamEntities[e];
	if (!bm.bIsValid()) continue;

	gbToNailOn.append(bm);
}

//Force exclude all genbeams in the reference zone set to no nail
GenBeam gbToNailOnto[] = NailLine().removeGenBeamsWithNoNailingBeamCode(gbToNailOn);

for(int g=0;g<genBeams.length();g++)
{
	GenBeam gBm = genBeams[g];
	
	
	String label = gBm.label().token(0);
	if (!caseSensitive)
		label.makeUpper();
	label.trimLeft();
	label.trimRight();
	int matchingLabel = false;
	if (label.length() == 0 || labels.length() == 0) {
		matchingLabel = false;
	}
	else if (labels.find(label) != -1){
		matchingLabel = true;
	}
	else{
		String property = label;
		int matchingProperty = matchingLabel;

		for( int f=0;f<labels.length();f++ ){
			String filter = labels[f];
			String filterTrimmed = filter;
			filterTrimmed.trimLeft("*");
			filterTrimmed.trimRight("*");
			if( filterTrimmed == "" ){
				if( filter == "*" && property != "" )
					matchingProperty = true;
				else
					continue;
			}
			else{
				if( filter.left(1) == "*" && filter.right(1) == "*" && property.find(filterTrimmed, 0) != -1 )
					matchingProperty = true;
				else if( filter.left(1) == "*" && property.right(filter.length() - 1) == filterTrimmed )
					matchingProperty = true;
				else if( filter.right(1) == "*" && property.left(filter.length() - 1) == filterTrimmed )
					matchingProperty = true;
			}
		}
		
		matchingLabel = matchingProperty;
	}
	if (matchingLabel)
		continue;
	
	if (gBm.myZoneIndex() == zoneToNail && gbNailalble.find(gBm) > -1)
	{
		PlaneProfile gBmProfile(csEl);
		gBmProfile = gBm.envelopeBody(true, true).shadowProfile(pnZ);
		gBmProfile.shrink(-shrinkOffsetObjectsToNail);
		//gBmProfile.vis(2);

		
		allGBmProfiles.append(gBmProfile);
		
	}
	else if (gBm.myZoneIndex() == zoneToNailOn && gbToNailOnto.find(gBm) > -1)
	{
		PlaneProfile gBmProfile(csEl);
		gBmProfile.unionWith(gBm.envelopeBody(true, true).shadowProfile(pnZ));
		gBmProfile.shrink(-shrinkOffsetBrander);
		//gBmProfile.vis(1);
		branderProfile.unionWith(gBmProfile);//.getSlice(pnNail));
	}
}

//branderProfile.shrink(shrinkOffsetBrander); // do not use because it can mess up a planeprofile and its not necessary

PlaneProfile shrunkenBranderProfile = branderProfile;
shrunkenBranderProfile.shrink(-shrinkSheetToNailOn);

shrunkenBranderProfile.vis(2);

shrunkenBranderProfile.shrink(2 * shrinkSheetToNailOn);

//branderProfile.vis(zoneToNailOn);

PlaneProfile noNailProfile(csEl);
Point3d noNailPositions[0];
Point3d mappedNailPositions[0];
int nAmountOfNails = 0;

for (int i=0; i<allGBmProfiles.length(); i++)
{
	PlaneProfile nailProfileThisGBm(csEl);
	nailProfileThisGBm.unionWith(allGBmProfiles[i]);
	nailProfileThisGBm.shrink(shrinkOffsetObjectsToNail);
	//nailProfileThisGBm.vis(zoneToNail);
	nailProfileThisGBm.intersectWith(branderProfile);
	
	nailProfile.unionWith(nailProfileThisGBm);
	
	PlaneProfile shrunkenNailProfile = nailProfileThisGBm;
	shrunkenNailProfile.shrink(shrinkSheetToNail);
	shrunkenNailProfile.vis(5);
	shrunkenNailProfile.intersectWith(shrunkenBranderProfile);
	
	//nailProfileThisGBm.vis(2);
	
	PLine nailAreas[] = nailProfileThisGBm.allRings();
	int areaIsOpening[] = nailProfileThisGBm.ringIsOpening();

	if (_Map.hasPoint3dArray("NoNailPositions"))
	{
		noNailPositions.append(_Map.getPoint3dArray("NoNailPositions"));
	}
	
	for (int j=0;j<nailAreas.length();j++)
	{		
		if (areaIsOpening[j])
			continue;
			
		PLine& nailArea = nailAreas[j];
		//nailArea.vis(1);
		// Perform the cleanup on this ring.
		Map ioMap;
		ioMap.setPLine("PLine", nailArea);
		ioMap.setInt("CloseResult", true);
		TslInst().callMapIO("HSB_G-CleanupPolyLine", ioMap);
		nailArea = ioMap.getPLine("PLine");
		PlaneProfile singleNailArea(csEl);
		singleNailArea.joinRing(nailArea, _kAdd);

		int isNoNailArea = false;
		for (int p=0;p<noNailPositions.length();p++)
		{
			Point3d& noNailPosition = noNailPositions[p];
			if (singleNailArea.pointInProfile(noNailPosition) == _kPointInProfile)
			{
				isNoNailArea = true;
				noNailProfile.joinRing(nailArea, _kAdd);
				
				break;
			}
		}
		if (isNoNailArea)
			continue;
		
		Point3d ptIntersectionVertices[]=nailArea.vertexPoints(FALSE);
		//Find the longest segment and check if it is to be used for distribution or not
		LineSeg longestSegment;
		double dLongestSegmentLength;
		for(int x = 1 ; x < ptIntersectionVertices.length() ; x++)
		{
			Point3d& ptStartVertex = ptIntersectionVertices[x - 1];
			Point3d& ptEndVertex = ptIntersectionVertices[x];
			
			LineSeg seg(ptStartVertex, ptEndVertex);
			if(seg.length() > dLongestSegmentLength)
			{
				dLongestSegmentLength = seg.length();
				longestSegment = seg;
			}
		}
		
		//Remove duplicate start point as we do not want it for the average
		ptIntersectionVertices.removeAt(ptIntersectionVertices.length() -1);
		
		Point3d nailReference;
		nailReference.setToAverage(ptIntersectionVertices);
		//nailReference.vis(j);
		if (nTakeCenterOfBoundingBox)
		{
			nailReference = singleNailArea.extentInDir(elX).ptMid();
		}
		
		nailReference += elY * verticalExcentricNailOffset;
		nailReference += elX * horizontalExcentricNailOffset;
		
		Point3d nailPositions[0];
		
		if(minimumDistanceForNailDistribution > 0 && dLongestSegmentLength >= minimumDistanceForNailDistribution && distributedNailSpacing > 0)
		{
			//Distribute nails
			Point3d ptStartLongestSegment = longestSegment.ptStart();
			Point3d ptEndLongestSegment = longestSegment.ptEnd();
			Vector3d vecLongestSegment = ptEndLongestSegment - ptStartLongestSegment;
			vecLongestSegment.normalize();
			
			LineSeg nailAreaExtent = shrunkenNailProfile.extentInDir(vecLongestSegment);

			//Check 3 locations to find best position for distribution
			Point3d ptMidExtent = nailAreaExtent.ptMid();
			Vector3d upVector = vecLongestSegment.crossProduct(elZ);
			double widthOfExtent = abs((nailAreaExtent.ptEnd() - nailAreaExtent.ptStart()).dotProduct(upVector));
			Point3d ptLocationsForDistribution[] ={ ptMidExtent, ptMidExtent + upVector * widthOfExtent * 0.25, ptMidExtent - upVector * widthOfExtent * 0.25 };
			
			LineSeg splits[0]; //=shrunkenNailProfile.splitSegments(longestSegAtNailReference, TRUE);
			double longestLengthOfSplits = 0;
			for(int x=0;x<ptLocationsForDistribution.length();x++)
			{
				Point3d& ptLocation = ptLocationsForDistribution[x];
				ptLocation.vis();
				Line lnNailReference(ptLocation, vecLongestSegment);
				LineSeg longestSegAtNailReference(lnNailReference.closestPointTo(ptStartLongestSegment), lnNailReference.closestPointTo(ptEndLongestSegment));
				
				LineSeg possibleSplits[]=shrunkenNailProfile.splitSegments(longestSegAtNailReference, TRUE);
				double lengthOfSplits = 0;
				for(int p = 0 ; p < possibleSplits.length() ; p++)
				{ 
					lengthOfSplits += possibleSplits[p].length();
				}
				
				if (longestLengthOfSplits - lengthOfSplits >= 0) continue;
				longestLengthOfSplits = lengthOfSplits;
				splits = possibleSplits;
			}
			
			for(int x = 0 ; x < splits.length() ; x++)
			{
				LineSeg& split = splits[x];
				//split.vis(x);
				Point3d start = split.ptStart() ;
				Point3d end = split.ptEnd();

				Vector3d vecSplit = end - start;
				vecSplit.normalize();
				
				start = start + vecSplit * minimumDistanceSheetEdge;
				end = end - vecSplit *minimumDistanceSheetEdge;
				//start.vis();
				//end.vis();
				
				if((end - start).dotProduct(vecSplit) < distributedNailSpacing)
				{
					//Maybe the two points have inverted which means with the edge offsets there will be no distribution
					nailPositions.append(split.ptMid() - elX * horizontalNailOffset - elY * verticalNailOffset);
					if (numberOfNails == 2)
						nailPositions.append(split.ptMid() + elX * horizontalNailOffset + elY * verticalNailOffset);
					continue;
				}
								
				double nailLineLength = (end - start).length();
				int distributedNailCount = ceil( nailLineLength/distributedNailSpacing);
				double updatedSpacing = nailLineLength / distributedNailCount;
				nailPositions.append(start);
				for(int y = 1 ; y < distributedNailCount ; y++)
				{
					Point3d nailPosition = start + vecSplit * updatedSpacing * y;
					nailPosition.vis(y);
					nailPositions.append(nailPosition);
				}
				nailPositions.append(end);
			}
		}
		else
		{ 
			nailPositions.append(nailReference - elX * horizontalNailOffset - elY * verticalNailOffset);
			if (numberOfNails == 2)
				nailPositions.append(nailReference + elX * horizontalNailOffset + elY * verticalNailOffset);
		}
		
		int validNailCluster = true;
		shrunkenNailProfile.vis();
		for (int p=0;p<nailPositions.length();p++)
		{
			Point3d& nailPosition = nailPositions[p];
			nailPosition.vis(p);
			validNailCluster = (shrunkenNailProfile.pointInProfile(nailPosition) != _kPointOutsideProfile);
			
			if (!validNailCluster)
			{
				break;
			}
		}
		
		if (nAddNailingToExtremesOfNailAreaIfNoValidCluster && !validNailCluster)
		{
			//Find the extreme point of the valid area
			Point3d nailPosition = nailReference;
			validNailCluster = (shrunkenNailProfile.pointInProfile(nailPosition) == _kPointInProfile);
			
			if (!validNailCluster)
				continue;
			
			PlaneProfile singleShrunkenNailProfile = singleNailArea;
			singleShrunkenNailProfile.intersectWith(shrunkenNailProfile);
			//singleShrunkenNailProfile.vis(3);
			
			//Collect all the vertices from the plane Profile.
			PLine plAllRings[]=singleShrunkenNailProfile.allRings();
			if (plAllRings.length()<1)
				continue;
			
			PLine plThisRing=plAllRings[0];
			Point3d ptAllVertices[]=plThisRing.vertexPoints(true);
			double dMinLength=0;
			
			for (int v=0; v<ptAllVertices.length()-1; v++)
			{
				for (int w=v+1; w<ptAllVertices.length(); w++)
				{
					if ((ptAllVertices[v]-ptAllVertices[w]).length()> dMinLength)
					{
						dMinLength=(ptAllVertices[v]-ptAllVertices[w]).length();
						nailPositions.setLength(0);
						nailPositions.append(ptAllVertices[v]);
						nailPositions.append(ptAllVertices[w]);
					}
				}
			}
			
			//Check if they are valid again
			for (int p=0;p<nailPositions.length();p++)
			{
				Point3d nailPosition = nailPositions[p];
				//nailPosition.vis(p);
				if (shrunkenNailProfile.pointInProfile(nailPosition) == _kPointOutsideProfile)
				{
					validNailCluster = false;
				}
				
				if (!validNailCluster)
					break;
			}
		}
		
		if (!validNailCluster)
			continue;
		
		ElemNailCluster nailCluster(zoneToNail, nailPositions, toolIndex);
		el.addTool(nailCluster);
		mappedNailPositions.append((nailPositions[0] + nailPositions[1]) /2);
		nAmountOfNails++;
	}
}

if (nAmountOfNails>0)
{ 
	_Map.setDouble("Qty", nAmountOfNails *numberOfNails);
	_Map.setPoint3dArray("NailPositions", mappedNailPositions);
}

Hatch noNailHatch("NET", U(10));
noNailHatch.setAngle(30);
Display noNailDisplay(5);
noNailDisplay.draw(noNailProfile);
noNailDisplay.draw(noNailProfile, noNailHatch);

if (_kExecuteKey == addNoNailAreaCommand)
{
	Point3d selectedPoint = getPoint(T("|Select point in nail area to mark the area as no nail area|"));
	if (nailProfile.pointInProfile(selectedPoint) == _kPointInProfile)
		noNailPositions.append(selectedPoint);
	while (true)
	{
		PrPoint pointSelector(T("|Select next point in nail area to mark the area as no nail area|"));
		if (pointSelector.go() == _kOk)
		{
			selectedPoint = pointSelector.value();
			if (nailProfile.pointInProfile(selectedPoint) == _kPointInProfile)
				noNailPositions.append(selectedPoint);
		}
		else
		{
			break;
		}		
	}
	
	_ThisInst.recalc();
}

if (_kExecuteKey == removeNoNailAreaCommand)
{
	Point3d pointsInValidAreas[0];
	Point3d selectedPoint = getPoint(T("|Select point in no nail area to mark the area as valid area|"));
	if (noNailProfile.pointInProfile(selectedPoint) == _kPointInProfile)
		pointsInValidAreas.append(selectedPoint);
	while (true)
	{
		PrPoint pointSelector(T("|Select next point in no nail area to mark the area as valid area|"));
		if (pointSelector.go() == _kOk)
		{
			selectedPoint = pointSelector.value();
			if (noNailProfile.pointInProfile(selectedPoint) == _kPointInProfile)
				pointsInValidAreas.append(selectedPoint);
		}
		else
		{
			break;
		}		
	}
	if (pointsInValidAreas.length() > 0)
	{
		PLine noNailAreaRings[] = noNailProfile.allRings(); 
		for (int r=0;r<noNailAreaRings.length();r++)
		{
			PLine ring = noNailAreaRings[r];
			PlaneProfile singleValidProfile(csEl);
			singleValidProfile.joinRing(ring, _kAdd);
			
			// Remove this no nail position if it is marked as valid.
			int isValid = false;
			for (int p=0;p<pointsInValidAreas.length();p++)
			{
				Point3d pointInValidAreas = pointsInValidAreas[p];
				if (singleValidProfile.pointInProfile(pointInValidAreas) == _kPointInProfile) 
				{
					isValid = true;
					break;
				}
			}
			if (!isValid)
				continue;
			
			for (int p=0;p<noNailPositions.length();p++)
			{
				Point3d noNailPosition = noNailPositions[p];
				if (singleValidProfile.pointInProfile(noNailPosition) == _kPointInProfile)
				{
					// Remove this point from the list of no nail profile positions.
					noNailPositions.removeAt(p);
					p--;
				}
			}
			
			// Store no nail positions.
			_Map.setPoint3dArray("NoNailPositions", noNailPositions);
		}
	
		_ThisInst.recalc();
	}
}

// Validate no nail positions.
Point3d validNoNailPositions[0];
for (int p=0;p<noNailPositions.length();p++)
{
	Point3d noNailPosition = noNailPositions[p];
	if (nailProfile.pointInProfile(noNailPosition) == _kPointInProfile)
		validNoNailPositions.append(noNailPosition);
}

// Store no nail positions.
_Map.setPoint3dArray("NoNailPositions", validNoNailPositions);



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
      <str nm="Comment" vl="Add nailpositions in map" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="27" />
      <str nm="Date" vl="6/26/2025 3:43:44 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add excentric offsets" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="26" />
      <str nm="Date" vl="5/7/2024 9:31:31 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add the numbers of Nails to MAP" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="25" />
      <str nm="Date" vl="12/12/2023 3:32:58 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Replace reportwarning with notice" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="24" />
      <str nm="Date" vl="9/20/2022 9:49:36 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add option to take the center of the boundingbox as position" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="23" />
      <str nm="Date" vl="3/7/2022 2:05:34 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Blow up brander profile before shrinking because of issues with branders not touching completly" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="22" />
      <str nm="Date" vl="2/25/2021 1:47:52 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End