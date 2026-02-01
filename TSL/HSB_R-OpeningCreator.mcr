#Version 8
#BeginDescription
Last modified by: Anno Sportel (support.nl@hsbcad.com)
18.12.2017  -  version 1.06
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 6
#KeyWords 
#BeginContents
//region History and versioning
/// <summary Lang=en>
///
/// </summary>

/// <insert>
/// 
/// </insert>

/// <remark Lang=en>report
/// 
/// </remark>

/// <version  value="1.06" date="18.12.2017"></version>

/// <history>
/// AS - 1.00 - 22.06.2017	- Pilot version
/// AS - 1.01 - 23.06.2017	- Always project opening to roof element.
/// AS - 1.02 - 18.07.2017	- Interpret results from opening calculator.
/// AS - 1.03 - 03.10.2017	- Manage zone profiles
/// AS - 1.04 - 02.11.2017	- Split rafters
/// AS - 1.05 - 03.11.2017	- Project selected points to same plane.
/// AS - 1.06 - 18.12.2017	- Create dummy element which represents a merged version of the interfering elements.
/// </history>
//endregion

String assembly = "C:\\Users\\annos\\Documents\\hsbcad\\Hg\\Default\\beamapp\\Hsb_NetApi\\hsbOpeningCreator\\hsbOpeningCreator\\bin\\Debug\\hsbOpeningCreator.dll";
String class = "hsbOpeningCreator.Calculate";
String function = "LoadFromTsl";

double vectorTolerance = Unit(0.001, "mm");

int openingIsInAFloor = false;

int openingColor = 62;

String openingRoofCatalogNames[] = OpeningRoof().getListOfCatalogNames(openingIsInAFloor);
PropString openingRoofCatalog(0, openingRoofCatalogNames, T("|Opening roof catalog|"));

String recalcTriggers[] = {
	T("|Create opening|")
};
for (int r=0;r<recalcTriggers.length();r++)
{
	addRecalcTrigger(_kContext, recalcTriggers[r]);
}

if (_bOnInsert)
{
	if (insertCycleCount() > 1)
	{
		eraseInstance();
		return;
	}
	
	showDialog();
	
	Element selectedElement = getElement(T("|Select an element|"));
	_Element.append(selectedElement);
	
	Point3d lowerLefthandCorner = getPoint("|Select lower lefthand corner|");
	Point3d upperRighthandCorner;
	while (true)
	{
		PrPoint ssPt(T("|Select upper righthand corner|"), lowerLefthandCorner);
		if (ssPt.go() == _kOk)
		{
			upperRighthandCorner = Plane(lowerLefthandCorner, _ZU).closestPointTo(ssPt.value());
			break;
		}
		else
		{
			reportWarning(T("|Opening is not valid|!"));
			eraseInstance();
			return;
		}
	}
		
	Vector3d openingX = selectedElement.vecX();
	Vector3d openingY = _ZU.crossProduct(openingX);
	
	PLine openingRoofOutline(_ZU);
	openingRoofOutline.createRectangle(LineSeg(lowerLefthandCorner, upperRighthandCorner), openingX, openingY);
	openingRoofOutline.projectPointsToPlane(Plane(selectedElement.zone(-1).coordSys().ptOrg(), selectedElement.vecZ()), _ZW);
	
	OpeningRoof openingRoof;
	openingRoof.dbCreate(selectedElement.elementGroup(), openingRoofOutline);
	openingRoof.setValuesFromCatalog(openingRoofCatalog, openingIsInAFloor);
	
	_Map.setString("OpeningRoofCatalog", openingRoofCatalog);
	_Map.setInt("Insert", true);
	
	_Entity.append(openingRoof);
	
	return;
}

if (_Element.length() == 0)
{
	eraseInstance();
	return;
}

ElementRoof referenceElement = (ElementRoof)_Element[0];
if (!referenceElement.bIsValid())
{
	reportWarning(T("|Selected element is not a roof element."));
	eraseInstance();
	return;
}
CoordSys csEl = referenceElement.coordSys();
Point3d elOrg = csEl.ptOrg();
Vector3d elX = csEl.vecX();
Vector3d elY = csEl.vecY();
Vector3d elZ = csEl.vecZ();

Point3d elOrgInsideFrame = referenceElement.zone(-1).coordSys().ptOrg();

OpeningRoof openingRoof;
for (int e=0;e<_Entity.length();e++)
{
	Entity openingRoofEntity = _Entity[e];
	if (openingRoofEntity.bIsKindOf(OpeningRoof()))
	{
		openingRoof = (OpeningRoof)openingRoofEntity;
		break;
	}
}

if (!openingRoof.bIsValid())
{
	reportWarning(scriptName() + TN("|Opening is not valid|"));
	eraseInstance();
	return;
}

if (abs(abs(elZ.dotProduct(openingRoof.coordSys().vecZ())) - 1) > vectorTolerance)
{
	PLine openingRoofShape = openingRoof.plShape();
	openingRoofShape.projectPointsToPlane(Plane(elOrg, elZ), _ZW);
	openingRoof.setPlShape(openingRoofShape);
}

setDependencyOnEntity(openingRoof);

// Set values from opening catalog if the property is not the same as the stored value.
String storedOpeningRoofCatalog;
if (_Map.hasString("OpeningRoofCatalog"))
{
	storedOpeningRoofCatalog = _Map.getString("OpeningRoofCatalog");
}

if (storedOpeningRoofCatalog != openingRoofCatalog)
{
	openingRoof.setValuesFromCatalog(openingRoofCatalog, openingIsInAFloor);
	_Map.setString("OpeningRoofCatalog", openingRoofCatalog);
}

PLine openingOutline = openingRoof.plShape();
openingOutline.projectPointsToPlane(Plane(referenceElement.zone(-1).coordSys().ptOrg(), elZ), _ZW);

Point3d openingVertices[] = openingOutline.vertexPoints(true);

Point3d openingVerticesX[] = Line(elOrg, elX).orderPoints(openingVertices);
Point3d openingVerticesY[] = Line(elOrg, elY).orderPoints(openingVertices);

if (openingVerticesX.length() == 0 || openingVerticesY.length() == 0)
{
	reportWarning(scriptName() + TN("|Opening outline is not valid|"));
	eraseInstance();
	return;
}

Point3d openingLowerLefthandCorner = openingVerticesX[0] + elY * elY.dotProduct(openingVerticesY[0] - openingVerticesX[0]);
Point3d openingLowerRighthandCorner = openingVerticesX[openingVerticesX.length() - 1] + elY * elY.dotProduct(openingVerticesY[0] - openingVerticesX[openingVerticesX.length() - 1]);
Point3d openingUpperRighthandCorner = openingVerticesX[openingVerticesX.length() - 1] + elY * elY.dotProduct(openingVerticesY[openingVerticesY.length() - 1] - openingVerticesX[openingVerticesX.length() - 1]);
Point3d openingUpperLefthandCorner = openingVerticesX[0] + elY * elY.dotProduct(openingVerticesY[openingVerticesY.length() - 1] - openingVerticesX[0]);

PLine diagonalLowerLeftToUpperRight(elZ);
diagonalLowerLeftToUpperRight.addVertex(openingLowerLefthandCorner);
diagonalLowerLeftToUpperRight.addVertex(openingUpperRighthandCorner);
PLine diagonalLowerRightToUpperLeft(elZ);
diagonalLowerRightToUpperLeft.addVertex(openingLowerRighthandCorner);
diagonalLowerRightToUpperLeft.addVertex(openingUpperLefthandCorner);

Display openingDisplay(openingColor);
openingDisplay.draw(diagonalLowerLeftToUpperRight);
openingDisplay.draw(diagonalLowerRightToUpperLeft);

int storeProfNettoInformation = false;
int createOpening = false;
if (_Map.hasInt("Insert")) 
{
	if (_Map.getInt("Insert"))
	{
		createOpening = true;
		storeProfNettoInformation = true;
	}
	
	_Map.removeAt("Insert", false);
}
if (_kExecuteKey == recalcTriggers[0])
{
	createOpening = true;
}

String doubleClick= "TslDoubleClick";
if (_kExecuteKey==doubleClick)
{
	createOpening = true;
}

if (_bOnDebug)
{
	createOpening = true;
}

_Map.setPLine("OpeningOutline", openingOutline, _kAbsolute);

// Find interfering elements.
Group elementGroup = referenceElement.elementGroup();
Group floorGroup(elementGroup.namePart(0), elementGroup.namePart(1), "");
Entity floorGroupEntities[] = floorGroup.collectEntities(true, ElementRoof(), _kModelSpace);

Element alignedFloorGroupElements[0];
Element interferingElements[0];
PlaneProfile openingProfile(csEl);
openingProfile.joinRing(openingOutline, _kAdd);
for (int e=0;e<floorGroupEntities.length();e++)
{
	Entity ent = floorGroupEntities[e];
	if (!ent.bIsKindOf(ElementRoof())) continue;
	
	Element floorGroupElement = (Element)ent;
	
	if ( abs(elZ.dotProduct(floorGroupElement.coordSys().vecZ()) - 1) > vectorTolerance ) continue;
	
	alignedFloorGroupElements.append(floorGroupElement);
	
	PlaneProfile elementProfile(csEl);
	elementProfile.joinRing(floorGroupElement.plEnvelope(), _kAdd);
	
	if (elementProfile.intersectWith(openingProfile))
	{
		interferingElements.append(floorGroupElement);
		floorGroupElement.setLock(true);
	}
}

int rafterTypes[] = 
{
	_kDakCenterJoist, _kDakLeftEdge, _kDakRightEdge, _kRafter
};

if (createOpening)
{
	reportNotice("\n********* RECALCULATE *********\n" + _Map);
	
	if (_Map.hasMap("Entity[]"))
	{
		reportNotice("\n********* REMOVE ENTITIES *********");
		Map createdEntities = _Map.getMap("Entity[]");
		for (int e=0;e<createdEntities.length();e++)
		{
			Entity ent  = createdEntities.getEntity(e);
			reportNotice("\nEnt: " + ent.handle());
			ent.dbErase();
		}
		_Map.removeAt("Entity[]", true);
	}
	
	// Restore original situation before creating the opening.
	//region Restore zone profiles
	Map mapOpeningCreator = openingRoof.subMapX("OpeningCreator");
	Map storedOpeningOutlines = mapOpeningCreator.getMap("OpeningOutline[]");
	if (storedOpeningOutlines.length() > 0)
	{
		for (int a = 0; a < alignedFloorGroupElements.length(); a++)
		{
			Element el = alignedFloorGroupElements[a];
			String subMapXKeys[] = el.subMapXKeys();
			Map constructionInformation;
			Map zoneOutlines;
			PLine storedBruttoOutlines[0];
			int storedBruttoOutlineZoneIndexes[0];
			if (subMapXKeys.find("ConstructionInformation") != -1)
			{
				constructionInformation = el.subMapX("ConstructionInformation");
				zoneOutlines = constructionInformation.getMap("ZoneOutline[]");
				for (int i=0;i<zoneOutlines.length();i++)
				{
					if ( ! zoneOutlines.hasMap(i) || zoneOutlines.keyAt(i) != "ZONEOUTLINE") continue;
					
					Map zoneOutline = zoneOutlines.getMap(i);
					storedBruttoOutlines.append(zoneOutline.getPLine("Outline"));
					storedBruttoOutlineZoneIndexes.append(zoneOutline.getInt("ZoneIndex"));					
				}
			}
			else 
			{
				
			}
			
			for (int i = 0; i < storedOpeningOutlines.length(); i++)
			{
				if ( ! storedOpeningOutlines.hasMap(i) || storedOpeningOutlines.keyAt(i) != "OPENINGOUTLINE") continue;
				Map openingOutline = storedOpeningOutlines.getMap(i);
				int zoneIndex = openingOutline.getInt("ZoneIndex");
				PLine outline = openingOutline.getPLine("Outline");
				
				PlaneProfile storedOpeningProfile(csEl);
				storedOpeningProfile.joinRing(outline, _kAdd);
				
				PlaneProfile intersectingOpeningProfile(csEl);
				int indexStoredOutline = storedBruttoOutlineZoneIndexes.find(zoneIndex);
				if (indexStoredOutline != -1)
				{
					intersectingOpeningProfile.joinRing(storedBruttoOutlines[indexStoredOutline], _kAdd);
				}
				else
				{
					intersectingOpeningProfile = el.profBrutto(zoneIndex);
					PLine rings[] = intersectingOpeningProfile.allRings();
					if (rings.length() > 0)
					{
						Map zoneOutline;
						zoneOutline.setPLine("Outline", rings[0]);
						zoneOutline.setInt("ZoneIndex", zoneIndex);
						zoneOutlines.appendMap("ZoneOutline", zoneOutline);
					}
				}
				int isIntersectedWith = intersectingOpeningProfile.intersectWith(storedOpeningProfile);
				
				if (intersectingOpeningProfile.area() > 0)
				{
					PlaneProfile profNetto = el.profNetto(zoneIndex);
					PLine intersectingOpeningRings[] = intersectingOpeningProfile.allRings();
					for (int r = 0; r < intersectingOpeningRings.length(); r++)
					{
						profNetto.joinRing(intersectingOpeningRings[r], _kAdd);
					}
					
					el.setProfNetto(zoneIndex, profNetto);
				}
			}
			
			if (subMapXKeys.find("ConstructionInformation") == -1)
			{
				constructionInformation.setMap("ZoneOutline[]", zoneOutlines);
				el.setSubMapX("ConstructionInformation", constructionInformation);
			}
		}
	}
	//endregion
	//region Restore split rafters
	int splitIndex = 0;
	while ( _Map.hasEntity("SplitRafter_" + splitIndex) )
	{
		Entity splitRafterEntity = _Map.getEntity("SplitRafter_" + splitIndex);
		Beam splitRafter = (Beam)splitRafterEntity;
		Entity splitResultEntity = _Map.getEntity("SplitResult_" + splitIndex);
		Beam splitResult = (Beam)splitResultEntity;
		
		_Map.removeAt("SplitRafter_" + splitIndex, true);
		_Map.removeAt("SplitResult_" + splitIndex, true);
		
		if ( ! splitRafter.bIsValid() || !splitResult.bIsValid() )
		{
			reportWarning(TN("|One of the split rafters is no longer valid!|"));
		}
		else
		{
			splitRafter.dbJoin(splitResult);
			splitRafter.setBeamCode("");
		}
		
		splitIndex++;
	}
	//endregion
	
//	Map zoneProfiles = _Map.getMap("ZoneProfile[]");
//	for (int z = 0; z < zoneProfiles.length(); z++)
//	{
//		if ( ! zoneProfiles.hasMap(z) || zoneProfiles.keyAt(z) != "ZoneProfile") continue;
//		
//		Map zoneProfile = zoneProfiles.getMap(z);
//		int zoneIndex = zoneProfile.getInt("ZoneIndex");
//		PlaneProfile profNetto = zoneProfile.getPlaneProfile("ProfNetto");
//		reportNotice("\n\nProfNetto Set!");
//		referenceElement.setProfNetto(zoneIndex, profNetto);
//	}
	
	// Create a dummy element to send to the opening creator. This dummy element is a merged version of the interferingElements.
	ElementRoof dummyElement;
	
	// Calculate the zone outlines.
	double shrinkOffset = U(25);
	int zoneIndexes[0];
	PlaneProfile zoneProfiles[0];
	for (int i=0;i<interferingElements.length();i++)
	{
		Element interferingElement = interferingElements[i];
		int indexer = -1;
		while (++indexer < 100)
		{
			int zones[0];
			if (indexer == 0)
			{
				zones.append(indexer);
			}
			else
			{
				zones.append(indexer);
				zones.append(-indexer);
			}
			
			double currentArea;
			for(int z=0;z<zones.length();z++) 
			{
				int zone = zones[z];
				PlaneProfile zoneProfile = interferingElement.profNetto(zone);
				zoneProfile.shrink(-shrinkOffset);
				currentArea += zoneProfile.area();
				if (zone ==0 && currentArea == 0)
				{
					reportWarning(T("|Invalid outline found for element| ") + interferingElement.number());
					break;
				}
				
				int index = zoneIndexes.find(zone);
				if (index == -1)
				{
					zoneIndexes.append(zone);
					zoneProfiles.append(zoneProfile);
				}
				else
				{
					PlaneProfile existingZoneProfile = zoneProfiles[index];
					existingZoneProfile.unionWith(zoneProfile);
					zoneProfiles[index] = existingZoneProfile;
				}
			}
			
			if (currentArea == 0) break;
		}	
	}
	
	reportNotice("\nZones:  " + zoneIndexes);
	
	Group referenceElementGroup = referenceElement.elementGroup();
	Group dummyElementGroup(referenceElementGroup.namePart(0), referenceElementGroup.namePart(0), "DUMMY");
	
	PLine dummyElementOutline(elZ);
	int frameIndex = zoneIndexes.find(0);
	if (frameIndex < 0)
	{
		reportWarning(T("|No outline found for dummy element.|"));
		return;
	}
	PlaneProfile frameProfile = zoneProfiles[frameIndex];
	frameProfile.shrink(shrinkOffset);
	PLine profileRings[] = frameProfile.allRings();
	if (profileRings.length() == 0)
	{
		reportWarning(T("|Profile of dummy element is invalid.|"));
		return;
	}
	dummyElementOutline = profileRings[0];
	dummyElementOutline.projectPointsToPlane(Plane(elOrgInsideFrame, elZ), elZ);
	dummyElement.dbCreate(dummyElementGroup, dummyElementOutline);
	
	for (int i=0;i<zoneIndexes.length();i++)
	{
		int zoneIndex = zoneIndexes[i];
		PlaneProfile zoneProfile = zoneProfiles[i];
		zoneProfile.shrink(shrinkOffset);
		dummyElement.setProfNetto(zoneIndex, zoneProfile);
	}
	
	// Set properties
	dummyElement.setBeamDistribution(referenceElement.beamDistribution());
	dummyElement.setDBeamSpacing(referenceElement.dBeamSpacing());
	dummyElement.setVecZ(elZ);
	dummyElement.setVecY(elY);
	dummyElement.setDReferenceHeight(referenceElement.dReferenceHeight());
	dummyElement.setBPurlin(referenceElement.bPurlin());
	dummyElement.setInsulation(referenceElement.insulation());
	
	dummyElement.setConstrDetailRidge(referenceElement.constrDetailRidge());
	dummyElement.setConstrDetailHip(referenceElement.constrDetailHip());
	dummyElement.setConstrDetailLeft(referenceElement.constrDetailLeft());
	dummyElement.setConstrDetailRight(referenceElement.constrDetailRight());
	dummyElement.setConstrDetailValley(referenceElement.constrDetailValley());
	dummyElement.setConstrDetailOverhang(referenceElement.constrDetailOverhang());
	
	dummyElement.setDKneeWallHeight(referenceElement.dKneeWallHeight());
	dummyElement.setConstrDetailKneeWall(referenceElement.constrDetailKneeWall());
	dummyElement.setDKneeWallHeight2(referenceElement.dKneeWallHeight2());
	dummyElement.setConstrDetailKneeWall2(referenceElement.constrDetailKneeWall2());
	
	dummyElement.setDStrutHeight(referenceElement.dStrutHeight());
	dummyElement.setConstrDetailStrut(referenceElement.constrDetailStrut());
	dummyElement.setDStrutHeight2(referenceElement.dStrutHeight2());
	dummyElement.setConstrDetailStrut2(referenceElement.constrDetailStrut2());	
	
	dummyElement.setTileLathDistribution(referenceElement.tileLathDistribution());
	dummyElement.setCounterLathDistribution(referenceElement.counterLathDistribution());
	dummyElement.setDCounterLathSpacing(referenceElement.dCounterLathSpacing());
	dummyElement.setDCounterLathHeight(referenceElement.dCounterLathHeight());
	dummyElement.setDCounterLathWidth(referenceElement.dCounterLathWidth());
	
	// Set some export flags...or not. 
	ModelMapComposeSettings mmFlags;
	
	// Compose the ModelMap.
	Entity openingCreatorEntities[] =
	{
		referenceElement,
		openingRoof
	};
	
	reportNotice("\n\n**** DETAILS USED ****");
	reportNotice("\nOpening detail left: " + openingRoof.constrDetailLeft());
	reportNotice("\nOpening detail right: " + openingRoof.constrDetailRight());
	reportNotice("\nOpening detail bottom: " + openingRoof.constrDetailBottom());
	reportNotice("\nOpening detail top: " + openingRoof.constrDetailTop());
	
	ModelMap mm;
	mm.setEntities(openingCreatorEntities);
	mm.dbComposeMap(mmFlags);
	// Create a map from it.
	Map mapIn();
	mapIn.setMap("ModelMap", mm.map());
	
	// Write the map to the personal temp folder. It will be picked up by the exe.
	String extension = ".dxx";
	if( hsbOEVersion().mid(6,2).atoi() > 17 )
		extension = ".hmm";
	String mapName = _kPathPersonalTemp + "\\" + projectNumber() + "_" + referenceElement.number() + "_" + openingRoof.description() + "_in" + extension;
	mapIn.writeToDxxFile(mapName);
	
	Map mapOut = callDotNetFunction2(assembly, class, function, mapIn);
	mapName = _kPathPersonalTemp + "\\" + projectNumber() + "_" + referenceElement.number() + "_" + openingRoof.description() + "_out" + extension;
	mapOut.writeToDxxFile(mapName);
	
	mm = ModelMap();
	mm.setMap(mapOut);
	// set some import flags
	ModelMapInterpretSettings mmInterpretFlags;
	mmInterpretFlags.resolveEntitiesByHandle(true); // default FALSE
	// interpret ModelMap
	mm.dbInterpretMap(mmInterpretFlags);
	// report the entities imported/updated/modified
	Entity newEntities[] = mm.entity();
	Map mapWithCreatedEntities;
	for (int e = 0; e < newEntities.length(); e++)
	{
		Entity newEntity = newEntities[e];
		
		if (newEntity.bIsKindOf(Beam()) || newEntity.bIsKindOf(Sheet()))
		{
			mapWithCreatedEntities.appendEntity("Entity", newEntity);
		}
	}
	if (mapWithCreatedEntities.length() > 0)
	{
		_Map.setMap("Entity[]", mapWithCreatedEntities);
	}
	
	dummyElement.dbErase();
	
	Point3d rafterStretchVertices[] = 
	{
		openingLowerLefthandCorner,
		openingUpperRighthandCorner
	};
	for (int n=0;n<newEntities.length();n++)
	{
		GenBeam newGenBeam = (GenBeam)newEntities[n];
		// Skip the vertical entities.
		if (abs(elX.dotProduct(newGenBeam.vecX())) < vectorTolerance) continue;
		
		if ((elZ.dotProduct(newGenBeam.ptCen() - elOrg) * elZ.dotProduct(newGenBeam.ptCen() - referenceElement.zone(-1).coordSys().ptOrg())) < 0)
		{
			rafterStretchVertices.append(newGenBeam.envelopeBody().allVertices());
		}
	}
	
	Point3d rafterStretchVerticesX[] = Line(elOrg, elX).orderPoints(rafterStretchVertices);
	Point3d rafterStretchVerticesY[] = Line(elOrg, elY).orderPoints(rafterStretchVertices);
	
	Point3d rafterStretchLowerLefthandCorner = rafterStretchVerticesX[0] + elY * elY.dotProduct(rafterStretchVerticesY[0] - rafterStretchVerticesX[0]);
	Point3d rafterStretchLowerRighthandCorner = rafterStretchVerticesX[rafterStretchVerticesX.length() - 1] + elY * elY.dotProduct(rafterStretchVerticesY[0] - rafterStretchVerticesX[rafterStretchVerticesX.length() - 1]);
	Point3d rafterStretchUpperRighthandCorner = rafterStretchVerticesX[rafterStretchVerticesX.length() - 1] + elY * elY.dotProduct(rafterStretchVerticesY[rafterStretchVerticesY.length() - 1] - rafterStretchVerticesX[rafterStretchVerticesX.length() - 1]);
	Point3d rafterStretchUpperLefthandCorner = rafterStretchVerticesX[0] + elY * elY.dotProduct(rafterStretchVerticesY[rafterStretchVerticesY.length() - 1] - rafterStretchVerticesX[0]);
	
	reportMessage (T("\n|Number of entities imported:| ") + newEntities.length());
	
	// Split rafters if they intersect with the opening.
	reportNotice("\n\n**** SPLIT RAFTERS ****");
	Beam rafters[0];
	for (int i=0;i<interferingElements.length();i++)
	{
		Element interferingElement = interferingElements[i];
		Beam beams[] = interferingElement.beam();
		for (int b = 0; b < beams.length(); b++)
		{
			Beam beam = beams[b];
			
			if (newEntities.find(beam) != -1) continue;
			
			if (beam.beamCode() == "SP1") continue;
			
			if (abs(abs(elY.dotProduct(beam.vecX())) - 1) > vectorTolerance) continue;
						
			if (rafterTypes.find(beam.type()) != -1)
			{
				rafters.append(beam);
			}
		}
	}
	
	Point3d splitOutlineBottomLeft = rafterStretchLowerLefthandCorner;
	Point3d splitOutlineTopRight = rafterStretchUpperRighthandCorner;
		
	PlaneProfile splitProfile(csEl);
	PLine splitOutline;
	splitOutline.createRectangle(LineSeg(splitOutlineBottomLeft, splitOutlineTopRight), elX, elY);
	splitProfile.joinRing(splitOutline, _kAdd);
	
	splitIndex = 0;
	for (int r=0;r<rafters.length();r++) 
	{
		Beam rafter = rafters[r];
		LineSeg splitSegments[] = splitProfile.splitSegments(LineSeg(rafter.ptCenSolid() - rafter.vecX() * 0.5 * rafter.solidLength(), rafter.ptCenSolid() + rafter.vecX() * 0.5 * rafter.solidLength()), true);
		
		if (splitSegments.length() > 0) 
		{
			LineSeg splitSegment = splitSegments[0];
			Point3d splitFrom = splitSegment.ptStart();
			Point3d splitTo = splitSegment.ptEnd();
			
			if (rafter.vecX().dotProduct(splitFrom - splitTo) < 0)
			{
				Point3d temp = splitTo;
				splitTo = splitFrom;
				splitFrom = temp;
			}
			
			Beam splitResult = rafter.dbSplit(splitFrom, splitTo);
			reportNotice("\nSplit rafter " + rafter.posnum() + " with beamcode " + rafter.beamCode());
			
			_Map.setEntity("SplitRafter_" + splitIndex, rafter);
			_Map.setEntity("SplitResult_" + splitIndex, splitResult);
			
			splitIndex++;
		}
	}
}

// Cut out opening in sheeting zones.
Map mapOpeningCreator = openingRoof.subMapX("OpeningCreator");
Map openingOutlines = mapOpeningCreator.getMap("OpeningOutline[]");
if (openingOutlines.length() > 0)
{
	for (int e = 0; e < interferingElements.length(); e++)
	{
		Element el = interferingElements[e];
		for (int i = 0; i < openingOutlines.length(); i++)
		{
			if ( ! openingOutlines.hasMap(i) || openingOutlines.keyAt(i) != "OPENINGOUTLINE") continue;
			
			Map openingOutline = openingOutlines.getMap(i);
			int zoneIndex = openingOutline.getInt("ZoneIndex");
			PLine outline = openingOutline.getPLine("Outline");
			
			SolidSubtract zoneSubtract(Body(outline, elZ * U(1000), 0));
			int nrOfAffectedSheetsInThisZone = zoneSubtract.addMeToGenBeamsIntersect(el.sheet(zoneIndex));
		}
	}
}




#End
#BeginThumbnail





#End