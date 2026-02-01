#Version 8
#BeginDescription
Last modified by: Ronald van Wijngaarden (support.nl@hsbcad.com)
25.11.2020 - version 2.06
This TSL splits a beam and places a blocking on the split location.

Version 2.7 7-12-2022 Align custom blocking height to the top or bottom of the element. Ronald van Wijngaarden

Version 2.8 18-1-2023 Add option to set the blockingHeight to be the height of the splitted beam, with a maximum of the raftersheight. Ronald van Wijngaarden

Version 2.9 8-2-2023 Fix issue with setting the height of the blockingbeam Ronald van Wijngaarden

Version 3.0 17-2-2023 Activate EraseInstance again. Ronald van Wijngaarden

Version 3.1 26-4-2023 Analyse the envelopeBody instead of the realBody, when setting the new height of the blocking beam. Ronald van Wijngaarden

Version 3.2 21-2-2024 Add option to assign the material of the splitted beam to the blocking or set new material. Marc Bredewoud
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 3
#MinorVersion 2
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This TSL splits a beam and places a blocking on the split location.
/// </summary>

/// <insert>
/// Select a set of elements.
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="2.07" date="21.02.2024"></version>

/// <history>
/// YB - 1.00 - 26.04.2017 -	Pilot version
/// YB - 1.01 - 26.04.2017 - 	Added a secondary filter
/// YB - 1.02 - 26.04.2017 - 	Added an include / exclude for the secondary filter.
/// FA - 2.00 - 16.05.2018 - 	Removed the usage of "HSB_G-RotateBlockingSide".
///							Added multiple options for the blocking, also added an option to stretch the blocking to the nearest beams.
/// FA - 2.01 - 13.08.2018	- 	Fixed a bug where the property height and width didn't take the beam that was split. This TSL can now be used with Element generation.
/// FA - 2.02 - 22.07.2020- 	Change around the vectors depending on the length of the beam in that direction.
/// Rvw-2.03 - 12.10.2020-	Add check for splitdirection. If element distribution direction is R flip the distribution.
/// Rvw-2.04 - 22.10.2020-	Add option to set the blocking beam to match with the elementheight regarding to the closest intersectionpoints of the blocking and the element top/ bottom plane.
/// Rvw-2.05 - 11.11.2020-	Add option to give in a secondsplitlength if the initial split length creates a blocking which is bigger than the splitted beam.
/// Rvw-2.06 - 25.11.2020-	Make vertical stretch of the blocking use a StretchStaticTo instead of a addToolStatic because the beam to stretch to can be rotated. And change the check for the intersecion using also the cuts on the envelopeBody.
/// </history>

//#Versions
// 3.2 21-2-2024 Add option to assign the material of the splitted beam to the blocking or set new material. Marc Bredewoud
// 3.1 26-4-2023 Analyse the envelopeBody instead of the realBody, when setting the new height of the blocking beam. Ronald van Wijngaarden
//3.0 17-2-2023 Activate EraseInstance again. Ronald van Wijngaarden
//2.9 8-2-2023 Fix issue with setting the height of the blockingbeam Ronald van Wijngaarden
//2.8 18-1-2023 Add option to set the blockingHeight to be the height of the splitted beam, with a maximum of the raftersheight. Ronald van Wijngaarden
//2.7 7-12-2022 Align custom blocking height to the top or bottom of the element. Ronald van Wijngaarden




//region Properties
Unit (1,"mm");
double dTolerance=U(0.001);
double dVectorTolerance=U(0.01);
int bOnDebug=true;
String executeKey = "ManualInserted";

// Properties
String categories[] = { T("|Filter|"), T("|Split|"), T("|Blocking|"), T("|Stretch|")};
String noYes[] = {T("|No|"),T("|Yes|")};
String incExcl[] = { T("|Include|"), T("|Exclude|")};
String alignment[] = { T("|Top|"), T("|Bottom|")};

// Filter
String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = {""}; filterDefinitions.append(TslInst().getListOfCatalogNames(filterDefinitionTslName));

PropString filterDefinition(0, filterDefinitions, T("|Filter definition beams|"));
filterDefinition.setDescription(T("|Filter definition for beams.|") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));
filterDefinition.setCategory(categories[0]);
PropString sSecondaryFilter(3, "", T("|Beamcode|"));
sSecondaryFilter.setCategory(categories[0]);
PropString sInclExcl(2, incExcl, T("|Filter type|"));
sInclExcl.setDescription(T("|Include: Only beams with the entered beamcode will be used.|") + TN("|Exclude: Beams with the entered beamcode won't be used.|"));
sInclExcl.setCategory(categories[0]);

// Split
PropDouble dSplitLength(0, U(1000), T("|Split length|"));
dSplitLength.setCategory(categories[1]);
PropDouble dSecondSplitLength(4, 0, T("|Alternative split length|"));
dSecondSplitLength.setCategory(categories[1]);
dSecondSplitLength.setDescription(T("|Give in a additional split length if the first splitlength creates a blocking which will be bigger than the splitbeam start or end point.|"));
PropString sSingleSplit(1, noYes, T("|Single split|"));
sSingleSplit.setCategory(categories[1]);
PropString sFlipDir(5, noYes, T("|Flip split direction|"));
sFlipDir.setCategory(categories[1]);


// Blocking
PropString sBlockingElementHeight(7, noYes, T("|Set to elementheight|"));
sBlockingElementHeight.setCategory(categories[2]);

PropDouble dBlockingLength(1, U(100), T("|Blocking length|"));
dBlockingLength.setCategory(categories[2]);
PropDouble dBlockingHeight(2, U(25), T("|Blocking height|"));
dBlockingHeight.setCategory(categories[2]);
dBlockingHeight.setDescription(T("|If set to -1, the blocking will take the height of the underlying beam. If set to -2 the blocking will take the height of the splitted beam but taking the rafter height as a maximumheight|"));
PropDouble dBlockingWidth(3, U(25), T("|Blocking width|"));
dBlockingWidth.setCategory(categories[2]);
dBlockingWidth.setDescription(T("|If set to -1, the blocking will take the width of the underlying beam.|"));
PropString dBlockingMaterial(10, "-1", T("|Blocking material|"));
dBlockingMaterial.setCategory(categories[2]);
dBlockingMaterial.setDescription(T("|If set to -1, the blocking will take the material of the underlying beam otherwise the set material is assigned.|"));
PropInt iBlockingColor(0, -1, T("|Blocking color|"));
iBlockingColor.setCategory(categories[2]);
iBlockingColor.setDescription(T("|If set to -1, the blocking will take the color of the underlying beam.|"));
PropString sBeamCode(6, "", T("|Beamcode Blocking|"));
sBeamCode.setCategory(categories[2]);

//  Stretching
PropString sBeamStretch(4, noYes, T("|Stretch to nearest beam|"));
sBeamStretch.setCategory(categories[3]);
sBeamStretch.setDescription(T("|If Yes is selected the blocking will extend to the closest beam.|"));

// Insert multi element
String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if (_kExecuteKey != "" && catalogNames.find(_kExecuteKey) != -1)
{
	setPropValuesFromCatalog(_kExecuteKey);
} 
//endregion

//region bOnInsert
if (_bOnInsert)
{
	if (insertCycleCount() > 1)
	{
		eraseInstance();
		return;
	}
	
	if ( _kExecuteKey == "" || catalogNames.find(_kExecuteKey) == -1 )
	{ 
		showDialog();
	}
		
	setCatalogFromPropValues(T("_LastInserted"));
	
	String strScriptName = scriptName();
	Vector3d vecUcsX(1, 0, 0);
	Vector3d vecUcsY(0, 1, 0);
	Beam lstBeams[0];
	Entity lstEntities[1];
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	Map mapTsl;
	mapTsl.setInt("ManualInserted", true);
	
	Element selectedElements[0];
	PrEntity ssE(T("|Select elements|"), Element());
	if (ssE.go())
	{ 
		selectedElements.append(ssE.elementSet());
	}
	
	for (int e = 0; e < selectedElements.length(); e++)
	{
		Element selectedElement = selectedElements[e];
		if ( ! selectedElement.bIsValid())
		{ 
			continue;
		}
		
		lstEntities[0] = selectedElement;

		if (bOnDebug)
		{ 
			reportMessage(TN("|strScriptName|: ")+strScriptName);
			reportMessage(TN("|vecUcsX|: ")+vecUcsX);
			reportMessage(TN("|vecUcsY|: ")+vecUcsY);
			reportMessage(TN("|lstBeams|: ")+lstBeams);
			reportMessage(TN("|lstEntities|: ")+lstEntities);
			reportMessage(TN("|lstPoints|: ")+lstPoints);
			reportMessage(TN("|lstPropInt|: ")+lstPropInt);
			reportMessage(TN("|lstPropDouble|: ")+lstPropDouble);
			reportMessage(TN("|lstPropString|: ")+lstPropString);
			reportMessage(TN("|mapTsl|: ")+mapTsl);	
			Map mapOut=mapTsl; mapOut.writeToDxxFile(_kPathDwg + "\\"+"mapTsl" + ".dxx");
		}

		TslInst tslNew;
		tslNew.dbCreate(strScriptName, vecUcsX, vecUcsY, lstBeams, lstEntities, lstPoints, "_LastInserted",_kModelSpace, mapTsl, executeKey, "");
	}
	
	eraseInstance();
	return;
}
//endregion

//region Checks and basic setup
if( _Element.length() != 1 )
{
 	reportWarning(TN("|No element selected!|"));
 	eraseInstance();
 	return;
}

// Set properties from catalog
if (_bOnDbCreated && _kExecuteKey == executeKey)
{
	setPropValuesFromCatalog(T("|_LastInserted|"));
}

int inclExclIndex = incExcl.find(sInclExcl);
int singleSplitIndex = noYes.find(sSingleSplit);
int stretchedIndex = noYes.find(sBeamStretch);
int flippedIndex = noYes.find(sFlipDir);
int setBeamHeight = noYes.find(sBlockingElementHeight);

if(dSplitLength <= dBlockingLength)
{
	reportNotice(T("|Split length can't be lower than blocking length!|") + TN("|TSL will be deleted!|"));
	eraseInstance();
	return;
}

if(dSecondSplitLength != 0 && dSecondSplitLength <= dBlockingLength)
{
	reportNotice(T("|SecondSplit length can't be lower than blocking length!|") + TN("|TSL will be deleted!|"));
	eraseInstance();
	return;
}
if(dSecondSplitLength > dSplitLength)
{
	reportNotice(T("|SecondSplit length can't be bigger than the initial split length|") + TN("|TSL will be deleted!|"));
	eraseInstance();
	return;
}

String filterDef = filterDefinition;
String sFilter = sSecondaryFilter;

double blockingLength = dBlockingLength;
double blockingHeight = dBlockingHeight;
double blockingWidth = dBlockingWidth;
String blockingMaterial = dBlockingMaterial;

int blockingColor = iBlockingColor;

if(dBlockingLength <= 0)
{
	reportNotice(T("|Blocking length can't be lower than 0!|") + TN("|Blocking length set to 100.|"));
	blockingLength = U(100);
}

Element el = _Element[0];
if(!el.bIsValid())
{ 
	eraseInstance();
	return;
}

Vector3d elX = el.vecX();
Vector3d elY = el.vecY();
Vector3d elZ= el.vecZ();
_Pt0 = el.ptOrg();
LineSeg line = el.segmentMinMax();
Point3d elMidPoint = line.ptMid();

if (bOnDebug)
{
	elX.vis(_Pt0, 1);
	elY.vis(_Pt0, 3);
}

if (!_bOnElementConstructed && _kExecuteKey != executeKey){ return;}

Beam beams[] = el.beam();
Beam filteredBeams[0];
Entity beamEntities[0];

for (int b = 0; b < beams.length(); b++)
{
	beamEntities.append(beams[b]);
}
//endregion

//region Filter

//Check if the property is filled, if so it will use this beamcode
Map filterGenBeamsMap;
filterGenBeamsMap.setEntityArray(beamEntities, false, "GenBeams", "GenBeams", "GenBeam");
filterGenBeamsMap.setString("BeamCode[]", sSecondaryFilter);
filterGenBeamsMap.setInt("Exclude", inclExclIndex);
int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, filterDef, filterGenBeamsMap);
if ( ! successfullyFiltered)
{
	reportWarning(T("|Beams could not be filtered|!") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
	eraseInstance();
	return;
}

beamEntities = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");

for (int b = 0; b < beamEntities.length(); b++)
{
	filteredBeams.append((Beam)beamEntities[b]);
}
//endregion

//region Declaring/Filling variables/arrays
Entity blockingEntities[0];
Beam perpBeams[0];
Beam filteredPerpBeams[0];

Beam closeR;
Beam closeL;

Beam verticalBeams[0];
Beam horizontalBeams[0];
Beam sortedBm[0];
Beam sortedBm2[0];

//endregion

String sElBmDistribution;
ElementRoof elRoof = (ElementRoof)el;

if(elRoof.bIsValid())
{
	sElBmDistribution = elRoof.beamDistribution();
}


//region Main Part
for (int b = 0; b < filteredBeams.length(); b++)
{
	Point3d splitPoints[0];
	Point3d secondSplitPoints[0];
	Beam bm = (Beam)filteredBeams[b];
	double beamLength = bm.dL();
	
	if (beamLength < dSplitLength + U(1))
	{
		continue;
	}
	
	Vector3d bmX = bm.vecX();
	
	double test1 = elX.dotProduct(bmX);
	double test2 = elY.dotProduct(bmX);
	
	//Check with x and y of element
	if (elX.dotProduct(bmX) < 1 - dVectorTolerance && sElBmDistribution != "R" || elY.dotProduct(bmX) < 1 - dVectorTolerance && sElBmDistribution != "R")
	{
		bmX *= -1;
	}
	Vector3d bmZ = bm.vecD(elZ);
	Vector3d bmY = bmZ.crossProduct(bmX);
	if(bm.dD(bmZ) < bm.dD(bmY))
	{
		bmZ = bmY;
		bmY = bmZ.crossProduct(bmX);
	}
	if (bmY.dotProduct(elMidPoint - bm.ptCen()) > 0)
	{
		bmY *= -1;
	}
	
	Point3d bmCenter = bm.ptCenSolid();
	Point3d bmBottom = bm.realBody().ptCen() + bm.vecZ() * (bm.solidHeight() / 2);
	Point3d bmTop = bm.realBody().ptCen() - bm.vecZ() * (bm.solidHeight() / 2);	
	
	if (flippedIndex != 1)
	{
		bmX *= -1;
	}
	
	Point3d ptStart = bmCenter + bmX * 0.5 * beamLength;
	
	//Gathering all the splitpoints.
	for (double s = dSplitLength; s < beamLength; s += dSplitLength)
	{
		Point3d ptSplit = ptStart - bmX * s;
		splitPoints.append(ptSplit);
	}
	
	if (dSecondSplitLength > 0)
	{
		int useSecondSplitLength = true;
		
		//Check if splitpoint creates a blocking which is outside of the element
		for (int sp = 0; sp < splitPoints.length(); sp++)
		{
			Point3d pointToCheck = splitPoints[sp];
			Point3d blockPtStart = pointToCheck - bmX * (0.5 * blockingLength);
			Point3d blockPtEnd = pointToCheck + bmX * (0.5 * blockingLength);
			
			if (abs(bmX.dotProduct(blockPtStart - bmCenter)) < beamLength * 0.5 && abs(bmX.dotProduct(blockPtEnd - bmCenter)) < beamLength * 0.5)
			{
				useSecondSplitLength = false;
			}
		}//next sp
		
		//Gathering all the splitpoints using the second splitsize
		if (useSecondSplitLength)
		{
			for (double s = dSecondSplitLength; s < beamLength; s += dSecondSplitLength)
			{
				Point3d ptSplit = ptStart - bmX * s;
				secondSplitPoints.append(ptSplit);
			}
			splitPoints = secondSplitPoints;
		}
	}
	
	Beam splitBeams[0];
	splitBeams.append(bm);
		
	for (int i = 0; i < splitPoints.length(); i++)
	{
		Point3d ptSplit = splitPoints[i];
		for (int g = 0; g < splitBeams.length(); g++)
		{
			Beam sBm = splitBeams[i];
			if (abs(bmX.dotProduct(bmCenter - ptSplit)) < .5 * beamLength && sBm.dL() > dSplitLength + U(1))
			{
				Beam newBeam = sBm.dbSplit(ptSplit, ptSplit);
				splitBeams.append(newBeam);
				beams.append(newBeam);
				if (flippedIndex != 1)
				{
					splitBeams.insertAt(0, sBm);
					beams.append(sBm);
				}
				break;
			}
		}
		
		Point3d ptBlocking = ptSplit - bmY * 0.5 * bm.dD(bmY);
		ptBlocking.vis();
		
		//Property checks
		if (dBlockingWidth <= 0)
		{
			perpBeams = bmY.filterBeamsPerpendicular(beams);
			filteredPerpBeams = Beam().filterBeamsHalfLineIntersectSort(perpBeams, ptBlocking, bmY);
			Beam bm1 = filteredPerpBeams[0];
			blockingWidth = bm1.solidWidth();
		}
		if (dBlockingHeight == -1)
		{
			perpBeams = bmY.filterBeamsPerpendicular(beams);
			filteredPerpBeams = Beam().filterBeamsHalfLineIntersectSort(perpBeams, ptBlocking, bmY);
			Beam bm1 = filteredPerpBeams[0];
			blockingHeight = bm1.solidHeight();
		}
		if (dBlockingMaterial == "-1")
		{
			perpBeams = bmY.filterBeamsPerpendicular(beams);
			filteredPerpBeams = Beam().filterBeamsHalfLineIntersectSort(perpBeams, ptBlocking, bmY);
			Beam bm1 = filteredPerpBeams[0];
			blockingMaterial = bm1.material();
		}
		if (blockingColor == -1)
		{
			perpBeams = bmY.filterBeamsPerpendicular(beams);
			filteredPerpBeams = Beam().filterBeamsHalfLineIntersectSort(perpBeams, ptBlocking, bmY);
			Beam bm1 = filteredPerpBeams[0];
			blockingColor = bm1.color();
		}
		
		bmX.vis(ptBlocking, 1);
		bmY.vis(ptBlocking, 3);
		bmZ.vis(ptBlocking, 120);
		
		ptBlocking.vis();
				
		//Creating the blocking
		String layer = bm.layerName();
		Beam blockingBeam;
		blockingBeam.dbCreate(ptBlocking, bmX, bmY, bmZ, blockingLength, blockingWidth, blockingHeight, 0, - 1, 0);
		blockingBeam.setMaterial(blockingMaterial);
		blockingBeam.assignToLayer(layer);
		blockingBeam.setColor(blockingColor);
		blockingBeam.setType(_kBlocking);
		blockingBeam.setBeamCode(sBeamCode);
		
		
		if (setBeamHeight || dBlockingHeight > 0)
		{
			//Get top and bottom point of element and create planes
			Point3d zone0TopPoint = el.zone(0).coordSys().ptOrg() + elZ * el.zone(0).dH();
			Plane elTopPlane (zone0TopPoint, elZ);
			
			Point3d zone0BottomPoint = el.zone(0).coordSys().ptOrg();
			Plane elBottomPlane (zone0BottomPoint, elZ);
			
			//Create lines on the left and right side of the beam to find intersections with the planes at the top and bottom of the element
			Line intersectLineLeft (blockingBeam.ptCenSolid() + -blockingBeam.vecY() * (blockingBeam.dW() /2), blockingBeam.vecZ());
			Line intersectLineRight (blockingBeam.ptCenSolid() + blockingBeam.vecY() * (blockingBeam.dW() /2), blockingBeam.vecZ());
			
			//Check if there is an intersection and get the intersection points
			Point3d intersectionPointsTop[0];
			Point3d intersectionPointsBottom[0];
			Point3d centerPointBlockingBeam = blockingBeam.ptCenSolid();
			
			if (intersectLineLeft.hasIntersection(elTopPlane) && intersectLineLeft.hasIntersection(elBottomPlane))
			{
				intersectionPointsTop.append(intersectLineLeft.intersect(elTopPlane, dTolerance));
				intersectionPointsBottom.append(intersectLineLeft.intersect(elBottomPlane, dTolerance));
			}
			
			if (intersectLineRight.hasIntersection(elTopPlane) && intersectLineRight.hasIntersection(elBottomPlane))
			{
				intersectionPointsTop.append(intersectLineRight.intersect(elTopPlane, dTolerance));
				intersectionPointsBottom.append(intersectLineRight.intersect(elBottomPlane, dTolerance));
			}
			
			//Check which of the intersectionpoints at the top and bottom are closest to blockingbeam center point
			Point3d closestPointTop;
			Point3d closestPointBottom;
			
			closestPointTop = intersectionPointsTop[0];
			if (abs(blockingBeam.vecZ().dotProduct(centerPointBlockingBeam - intersectionPointsTop[0])) > abs(blockingBeam.vecZ().dotProduct(centerPointBlockingBeam - intersectionPointsTop[1])))
			{
				closestPointTop = intersectionPointsTop[1];				
			}
			
			closestPointBottom = intersectionPointsBottom[0];
			if (abs(blockingBeam.vecZ().dotProduct(centerPointBlockingBeam - intersectionPointsBottom[0])) > abs(blockingBeam.vecZ().dotProduct(centerPointBlockingBeam - intersectionPointsBottom[1])))
			{						
				closestPointBottom = intersectionPointsBottom[1];				
			}
			
			if(setBeamHeight)
			{
				//Get new height for the blockingbeam
				double newHeight = abs(blockingBeam.vecZ().dotProduct(closestPointTop - closestPointBottom));
								
				//Set new height for the blockingbeam
				blockingBeam.setD(blockingBeam.vecZ(), newHeight);
				blockingBeam.transformBy(blockingBeam.vecZ() * blockingBeam.vecZ().dotProduct((closestPointTop + closestPointBottom) / 2 - blockingBeam.ptCenSolid()));	
			}
			
			if(dBlockingHeight > 0 && !setBeamHeight) //Set custom height of blocking
			{
				blockingBeam.setD(blockingBeam.vecZ(), dBlockingHeight);							
			}
			
			if (dBlockingHeight == -2) //Set blockingBeam to be the height of the splittedbeam. Only take into account the top and bottom point of the splitted beam which are inside the zone 0 of the element.
			{
				Point3d pBmTop = bm.envelopeBody().ptCen() - bm.vecZ() * (bm.solidHeight() / 2);
				Point3d pBmBottom = bm.envelopeBody().ptCen() + bm.vecZ() * (bm.solidHeight() / 2);
				
				if((bm.vecZ().dotProduct(closestPointBottom - pBmBottom)) < 0)
				{
					pBmBottom = closestPointBottom;
				}
				
				double newHeight2 = abs(blockingBeam.vecZ().dotProduct(closestPointTop - pBmBottom));

				//Set new height for the blockingbeam
				blockingBeam.setD(blockingBeam.vecZ(), newHeight2);
				//Move blockingbeam
				blockingBeam.transformBy(blockingBeam.vecZ() * blockingBeam.vecZ().dotProduct((closestPointTop + pBmBottom) / 2 - blockingBeam.ptCenSolid()));					
			}
		}
		
			
		//region Stretch
		if (stretchedIndex == 1)
		{
			Point3d beamR = ptBlocking + bmX * blockingLength * .5;
			Point3d beamL = ptBlocking - bmX * blockingLength * .5;
			
			//region horizontal stretch
			if (abs(elX.dotProduct(bmX)) > dTolerance)
			{
				for (int i = 0; i < beams.length(); i++)
				{
					Beam bm2 = beams[i];
					CoordSys bmCoordSys = bm2.coordSys();
					Vector3d bmx = bmCoordSys.vecX();
					Vector3d bmy = bmCoordSys.vecY();
					
					if (abs(elX.dotProduct(bmx)) < dTolerance)
					{
						verticalBeams.append(bm2);
					}
				}
				
				sortedBm = Beam().filterBeamsHalfLineIntersectSort(verticalBeams, beamR, bmX);
				
				if (sortedBm.length() > 0)
				{
					closeR = sortedBm[0];
					Point3d ptRight = closeR.ptCen() - bmX * closeR.dD(-bmX) * .5;
					Cut R(ptRight, bmX);
					blockingBeam.addToolStatic(R, _kStretchOnInsert);
				}
				
				sortedBm2 = Beam().filterBeamsHalfLineIntersectSort(verticalBeams, beamL, - bmX);
				
				if (sortedBm2.length() > 0)
				{
					closeL = sortedBm2[0];
					Point3d ptLeft = closeL.ptCen() + bmX * closeL.dD(bmX) * .5;
					Cut L(ptLeft, - bmX);
					blockingBeam.addToolStatic(L, _kStretchOnInsert);
				}
			}//endregion
			//region vertical stretch
			
			else
			{
				for (int i = 0; i < beams.length(); i++)
				{
					Beam bm2 = beams[i];
					CoordSys bmCoordSys = bm2.coordSys();
					Vector3d bmx = bmCoordSys.vecX();
					Vector3d bmy = bmCoordSys.vecY();
					
					if (abs(elX.dotProduct(bmx)) > dTolerance)
					{
						horizontalBeams.append(bm2);
					}
				}
				sortedBm = Beam().filterBeamsHalfLineIntersectSort(horizontalBeams, beamR, bmX);
				
				if (sortedBm.length() > 0)
				{
					closeR = sortedBm[0];
					Point3d ptRight = closeR.ptCen() - bmX * closeR.dD(- bmX) * .5;
					ptRight.vis(1);
					//check if the Length of the to be stretched blocking is bigger then 3 times the original length
					PLine lenCheck(ptRight, ptBlocking);
					if (lenCheck.length() > (dSplitLength))
					{
						continue;
					}
					
					Cut R(ptRight, bmX);
//					blockingBeam.addToolStatic(R, _kStretchOnInsert);
					blockingBeam.stretchStaticTo(closeR, 1);
				}
				
				sortedBm2 = Beam().filterBeamsHalfLineIntersectSort(horizontalBeams, beamL, - bmX);
				
				if (sortedBm2.length() > 0)
				{
					closeL = sortedBm2[0];
					Point3d ptLeft = closeL.ptCen() + bmX * closeL.dD(bmX) * .5;
					
					//check if the Length of the to be stretched blocking is bigger then 3 times the original length
					PLine lenCheck(ptLeft, ptBlocking);
					if (lenCheck.length() > (dSplitLength))
					{
						continue;
					}
					
					Cut L(ptLeft, - bmX);
					blockingBeam.stretchStaticTo(closeL, 1);
//					blockingBeam.addToolStatic(L, _kStretchOnInsert);
				}
			
			}//endregion
			
		}
		blockingEntities.append(blockingBeam);
		//endregion
		if (singleSplitIndex)
		{
			break;
		}
	}
}
//endregion


//region Stretch beam to blocking
// Checks if the beams have an intersection, if so the beams will be corrected to not have an intersection.
for (int b = 0; b < blockingEntities.length(); b++)
{
	Beam blockingBeam = (Beam)blockingEntities[b];		
	Body bmBody(blockingBeam.envelopeBody(false, true));
	Beam intersectingBeams[] = bmBody.filterGenBeamsIntersect(beams);
	
	for (int c = 0; c < intersectingBeams.length(); c++)
	{
		intersectingBeams[c].stretchStaticTo(blockingBeam, true);
	}
}
//endregion

eraseInstance();
return;






#End
#BeginThumbnail
















#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="Resource[]">
    <lst nm="IMAGE[]" />
  </lst>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Add option to assign the material of the split beam to the blocking." />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="2/21/2024 10:05:12 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Analyse the envelopeBody instead of the realBody, when setting the new height of the blocking beam." />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="4/26/2023 1:27:48 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Activate EraseInstance again." />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="2/17/2023 12:03:00 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Fix issue with setting the height of the blockingbeam" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="9" />
      <str nm="DATE" vl="2/8/2023 2:16:11 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Add option to set the blockingHeight to be the height of the splitted beam, with a maximum of the raftersheight." />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="8" />
      <str nm="DATE" vl="1/18/2023 1:54:49 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Align custom blocking height to the top of the element." />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="7" />
      <str nm="DATE" vl="12/7/2022 1:58:10 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End