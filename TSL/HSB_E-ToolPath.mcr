#Version 8
#BeginDescription
This tsl adds a cnc tool to a specific zone.

#Versions
Version 2.15 05/09/2025 HSB-24528: Fix when considering door openings , Author Marsel Nakuci
Version 2.14 05/09/2025 HSB-24528: Improve when intersecting PLine with PlaneProfile , Author Marsel Nakuci
Version 2.13 04/09/2025 HSB-24528: Add properties for excluding regions at bottom,top,left,right , Author Marsel Nakuci
Version 2.12 04/09/2025 HSB-24528: Add properties to exclude opening or/and outter contours for tooling , Author Marsel Nakuci
Version 2.11 14-11-2023 Add zone 0 as tooling zone. Ronald van Wijngaarden
2.10 31/08/2023 Make sure start symbol is in same zone Author: Robert Pol
2.9 09/05/2023 Add option to clean up polyline for arced plines Author: Robert Pol
2.8 08/02/2023 Change dbcreate to use lastinserted Author: Robert Pol
Version 2.7 16.09.2022 HSB-16535 error messages will now shown in the hsb dialog instead of showing a warning










#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 15
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl adds a cnc tool to a specific zone.
/// </summary>

/// <insert>
/// Select an element and a set of tool paths
/// </insert>

/// <remark Lang=en>
///  HSB_G-CleanupPolyLine is required in the drawing.
/// </remark>

/// <history>
// #Versions
// 2.15 05/09/2025 HSB-24528: Fix when considering door openings , Author Marsel Nakuci
// 2.14 05/09/2025 HSB-24528: Improve when intersecting PLine with PlaneProfile , Author Marsel Nakuci
// 2.13 04/09/2025 HSB-24528: Add properties for excluding regions at bottom,top,left,right , Author Marsel Nakuci
// 2.12 04/09/2025 HSB-24528: Add properties to exclude opening or/and outter contours for tooling , Author Marsel Nakuci
// 2.11 14-11-2023 Add zone 0 as tooling zone. Ronald van Wijngaarden
//2.10 31/08/2023 Make sure start symbol is in same zone Author: Robert Pol
//2.9 09/05/2023 Add option to clean up polyline for arced plines Author: Robert Pol
//2.8 08/02/2023 Change dbcreate to use lastinserted Author: Robert Pol
// 2.7 16.09.2022 HSB-16535 error messages will now shown in the hsb dialog instead of showing a warning , Author Thorsten Huck
/// AS - 1.00 - 29.02.2016 -	First revision
/// AS - 1.01 - 08.03.2016 -	Add custom actions
/// AS - 1.02 - 07.04.2016 -	Angle can be send it through map.
/// AS - 1.03 - 02.05.2016 -	Add support for mill lines.
/// AS - 1.04 - 20.07.2017 -	Add option to set overshoot through _Map.
/// AS - 1.05 - 04.10.2017 -	Add option to specify no nail area.
/// AS - 1.06 - 04.10.2017 -	Add option to set tool side through _Map.
/// AS - 1.07 - 04.01.2018 -	Add guard for invalid tool paths.
/// AS - 1.08 - 04.01.2018 -	Correct direction of no nail area.
/// AS - 1.09 - 04.01.2018 -	Set the color of the tsl. Add text for Manual Erase.
/// AS - 1.10 - 20.04.2018 -	Add toolpath direction and auto side detection.
/// AS - 1.11 - 22.04.2018 -	Use extremes of toolpath instead of grips.
/// AS - 1.12 - 23.04.2018 -	Add option to split path into segments.
/// AS - 1.13 - 25.04.2018 -	Force opening overshoot to 'No'.
/// AS - 1.14 - 25.04.2018 -	Increase tolerance for sheets to merge. Call cleanup for the rings.
/// AS - 1.15 - 30.05.2018 -	Add delete option as execute key.
/// AS - 1.16 - 16.08.2018 -	Add dummy option as execute key.
/// AS - 1.17 - 14.09.2018 -	Ignore sheets which have the z vector not aligned with the element z vector.
/// RP - 1.18 - 19.09.2018 -	Use create circle to create new pline when map has point/ vector/double (otherwise it is not exported as MP in wup)
/// RP - 1.19 - 21.01.2019 -	Add insert props as read only
/// RP - 1.20 - 19.04.2019 -	Add filter defenition on insert for sheets
/// RP - 1.21 - 02.05.2019 -	Add filter defenition on insert for beams
/// RP - 1.22 - 02.05.2019 -	Set filter defenition for beams to be read only
/// RP - 2.00 - 02.05.2019 -	Add option to set tooltype through map. Only on insert.
/// AS - 2.01 - 13.05.2019 -	Correct splitting into segments (wrong index was used). And add toolpath also on Pline selection.
/// AS - 2.02 - 19.06.2019 -	Correct calculation of zone thickness.
/// RP - 2.03 - 05.12.2019 -	Do check for zoneprofile based on sheetfilter
/// RP - 2.04 - 15.01.2020 -	Make sure catalog is set from executekey
/// RP - 2.05 - 07.02.2020 -	Add option to select new startpoint and check if individual segements are in convexhull, then they cant have overshoot
/// RP - 2.06 - 24.02.2021 -	Add option to select circles
/// </history>

double vectorTolerance = U(0.01, "mm");

String deleteCommand = T("|Delete|");
if (_kExecuteKey == deleteCommand)
{
	eraseInstance();
	return;
}

String dummyCommand = T("|Dummy|");
if (_kExecuteKey == dummyCommand)
{
	return;
}

if (_bOnElementDeleted) {
	eraseInstance();
	return;
}




String categories[] = 
{
	T("|Tooling|"),
	T("|No nail area|")
};

String toolTypes[] = {T("|Saw|"), T("|Mill|")};

String yesNo[] = {T("|Yes|"), T("|No|")};
String sNoYes[] = { T("|No|"), T("|Yes|")};
double dEps =U(.1);

String toolSides[]= {T("|Left|"), T("|Right|"), T("|Auto|")};
int toolSideIndexes[]={_kLeft, _kRight, 2};

String turningDirections[]= {T("|Against course|"),T("|With course|"), T("|Auto|")};
int turningDirectionIndexes[]={_kTurnAgainstCourse, _kTurnWithCourse, _kTurnAgainstCourse};

String pathDirections[] = {T("|Manual|"),  T("|Clockwise|"), T("|Anticlockwise|")};

PropInt sequenceNumber(0, 0, T("|Sequence number|"));
sequenceNumber.setDescription(T("|The sequence number is used to sort the list of tsl's during generate construction|"));

//region Tooling properties
PropString toolType(3, toolTypes, T("|Tool type|"));
toolType.setCategory(categories[0]);

int zoneIndexes[] = {0,1,2,3,4,5,6,7,8,9,10};
PropInt propZoneIndex(1, zoneIndexes, T("|Zone index|")); //NOTE: Index used during insert!!
propZoneIndex.setCategory(categories[0]);

PropInt toolingIndex(3, 1,T("|Tool index|"));
toolingIndex.setCategory(categories[0]);

PropString propPathDirection(5, pathDirections, T("|Path direction|"), 0);
propPathDirection.setCategory(categories[0]);

PropString propToolSide(0,toolSides,T("|Tool side|"),1);
propToolSide.setCategory(categories[0]);

PropString propTurningDirection(1,turningDirections,T("|Turning direction tool|"),0);
propTurningDirection.setCategory(categories[0]);

PropString propOvershoot(2,yesNo,T("|Overshoot|"),0);
propOvershoot.setCategory(categories[0]);

PropDouble additionalSawDepth(1, U(1), T("|Extra depth|"));
additionalSawDepth.setCategory(categories[0]);

PropDouble sawAngle(2, 0, T("|Saw angle|"));
sawAngle.setCategory(categories[0]);
sawAngle.setFormat(_kAngle);

// HSB-24528: Exclude properties
String spropExcludeOpeningsName=T("|Exclude openings|");	
PropString spropExcludeOpenings(14, sNoYes, spropExcludeOpeningsName);
spropExcludeOpenings.setDescription(T("|Defines whether the openings should be excluded for tooling or not.|"));
spropExcludeOpenings.setCategory(categories[0]);
// HSB-24528
String spropExcludeOutterContoursName=T("|Exclude outter contours|");
PropString spropExcludeOutterContours(15, sNoYes, spropExcludeOutterContoursName);	
spropExcludeOutterContours.setDescription(T("|Defines whether the outter contours should be excluded for tooling or not.|"));
spropExcludeOutterContours.setCategory(categories[0]);

// HSB-24528
// Following regions will not permit tooling
// Left - vertical strip on left edge with a particular width will not permit tooling
// Right - vertical strip on right edge with a particular width will not permit tooling
// Bottom - horizontal strip on bottom edge with a particular width will not permit tooling
// Top - horizontal strip on top edge with a particular width will not permit tooling
String sRegionLeftName=T("|Left|");
PropDouble dRegionLeft(6, U(0), sRegionLeftName);	
dRegionLeft.setDescription(T("|Defines the width of the left region where tooling is excluded|"));
dRegionLeft.setCategory(categories[0]);

String sRegionRightName=T("|Right|");
PropDouble dRegionRight(7, U(0), sRegionRightName);	
dRegionRight.setDescription(T("|Defines the width of the right region where tooling is excluded|"));
dRegionRight.setCategory(categories[0]);

String sRegionBottomName=T("|Bottom|");
PropDouble dRegionBottom(8, U(0), sRegionBottomName);	
dRegionBottom.setDescription(T("|Defines the width of the bottom region where tooling is excluded|"));
dRegionBottom.setCategory(categories[0]);

String sRegionTopName=T("|Top|");
PropDouble dRegionTop(9, U(0), sRegionTopName);	
dRegionTop.setDescription(T("|Defines the width of the top region where tooling is excluded|"));
dRegionTop.setCategory(categories[0]);
//endregion

//region No nail area properties
PropString withNoNailAreaProp(4, yesNo, T("|With no nail area|"), 1);
withNoNailAreaProp.setCategory(categories[1]);
withNoNailAreaProp.setDescription(T("|Specifies whether there will be a no nail area applied.|"));

PropDouble offsetNoNailAreaLeft(0, U(5), T("|Offset left|"));
offsetNoNailAreaLeft.setCategory(categories[1]);
offsetNoNailAreaLeft.setDescription(T("|Sets the offset of the no nail area on the lefthand side of the tool path.|"));

PropDouble offsetNoNailAreaRight(3, U(5), T("|Offset right|"));
offsetNoNailAreaRight.setCategory(categories[1]);
offsetNoNailAreaRight.setDescription(T("|Sets the offset of the no nail area on the righthand side of the tool path.|"));

PropDouble offsetNoNailAreaStart(4, U(5), T("|Offset start|"));
offsetNoNailAreaStart.setCategory(categories[1]);
offsetNoNailAreaStart.setDescription(T("|Sets the offset of the no nail area on the start of the tool path.|"));

PropDouble offsetNoNailAreaEnd(5, U(5), T("|Offset end|"));
offsetNoNailAreaEnd.setCategory(categories[1]);
offsetNoNailAreaEnd.setDescription(T("|Sets the offset of the no nail area on the end of the tool path.|"));

PropString propSplitOutlinePathIntoSegments(6, yesNo, T("|Split outline into segments|"), 1);

PropString propSplitOpeningPathIntoSegments(7, yesNo, T("|Split opening into segments|"), 1);

PropString propSplitSelectedPLinesIntoSegments(8, yesNo, T("|Split selected polylines into segments|"), 1);

PropString openingToolType(11, toolTypes, T("|Opening tooltype on insert|"), 1);

PropString outlineToolType(12, toolTypes, T("|Outline tooltype on insert|"), 1);

PropString propCleanUpPolyline(13, yesNo, T("|Clean up polyline|"), 0);


String category = T("|Filters|");
String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = TslInst().getListOfCatalogNames(filterDefinitionTslName);
filterDefinitions.insertAt(0,"");

PropString filterDefinitionSheets(9, filterDefinitions, T("|Filter definition sheets|"));
filterDefinitionSheets.setDescription(T("|The filter definition used to filter the beams.|") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));
filterDefinitionSheets.setCategory(category);

PropString filterDefinitionBeams(10, filterDefinitions, T("|Filter definition beams|"));
filterDefinitionBeams.setDescription(T("|The filter definition used to filter the beams.|") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|.") + TN("|These beams will be used to filter a Pline segment|, ") + T("(|only when Pline is split into segments|)"));
filterDefinitionBeams.setCategory(category);

//endregion

double mergeSheetsTolerance = U(7);

String restoreOriginalToolPathCommand = T("|Reset to original tool path|");

String recalcTriggers[] = {
	T("|Reverse tool path|"),
	T(" -----------------------------"),
	restoreOriginalToolPathCommand,
	T("|Set current tool path as original tool path|"),
	T(" -----------------------------  "),
	T("|Create polyline|"),
	T("|Set polyline as new tool path|"),
	T("|Select new start point|")
};
for( int i=0;i<recalcTriggers.length();i++ )
{
	addRecalcTrigger(_kContext, recalcTriggers[i] );
}

// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames("HSB_E-ToolPath");
if (_kExecuteKey != "" && catalogNames.find(_kExecuteKey) != -1) 
{
	setPropValuesFromCatalog(_kExecuteKey);
	setCatalogFromPropValues(T("|_LastInserted|"));
}
// Manual inserted might be 
int manualInserted = false;
if (_Map.hasInt("ManualInserted")) {
	manualInserted = _Map.getInt("ManualInserted");
	_Map.removeAt("ManualInserted", true);
}

// set properties from catalog
if (_bOnDbCreated && manualInserted)
{
	setPropValuesFromCatalog(T("|_LastInserted|"));
}

if (_bOnInsert || ((_bOnElementConstructed || manualInserted) && !_Map.hasPLine("ToolPath"))) 
{
	PLine selectedToolPaths[0];
	String overshoots[0];
	String tooltypes[0];
	int bRingInners[0]; // for each selectedToolPaths store if inner ring or outter
	Element el;
	if (_Element.length() > 0)
		el = _Element[0];
	
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
	
	if (_bOnInsert)
	{
		if (insertCycleCount() > 1) {
			eraseInstance();
			return;
		}
		
		if ( _kExecuteKey == "" || catalogNames.find(_kExecuteKey) == -1 )
		{
			showDialog();
		}
			
		setCatalogFromPropValues(T("|_LastInserted|"));
	}
	else if (_bOnElementConstructed)
	{
		setCatalogFromPropValues(T("|_LastInserted|"));
	}
	
	int splitOutlinePathIntoSegments = (yesNo.find(propSplitOutlinePathIntoSegments, 1) == 0);
	int splitOpeningPathIntoSegments = (yesNo.find(propSplitOpeningPathIntoSegments, 1) == 0);
	int splitSelectedPLinesIntoSegments = (yesNo.find(propSplitSelectedPLinesIntoSegments, 1) == 0);
	int cleanUpPolyline = (yesNo.find(propCleanUpPolyline, 1) == 0);
	//
	int bExcludeOpenings=sNoYes.find(spropExcludeOpenings);
	int bExcludeOutterContours=sNoYes.find(spropExcludeOutterContours);
	
	int zoneIndex = propZoneIndex;
	if (zoneIndex > 5)
		zoneIndex = 5 - zoneIndex;
	
	int pathDirection = pathDirections.find(propPathDirection, 0);
		
	if (_bOnInsert)
	{
		Element selectedElements[0];
		PrEntity ssE(T("|Select one or more elements|"), Element());
		if (ssE.go())
		{
			selectedElements.append(ssE.elementSet());
		}
		
		if (selectedElements.length() == 1) 
		{
			el = selectedElements[0];
		}
		else
		{
			for (int p=0;p<selectedElements.length();p++) 
			{
				Element el = selectedElements[p];
				lstEntities[0] = el;
					
				TslInst tslNew;
				tslNew.dbCreate(strScriptName, vecUcsX, vecUcsY, lstBeams, lstEntities, lstPoints, T("|_LastInserted|"), true, mapTsl, "", "");	
			}
						
			eraseInstance();
			return;
		}
		
		String promptForInputMode = getString(T("Press <P> to select polylines or press <C> to select circles"));
		if (promptForInputMode.makeUpper() == "P")
		{
			PrEntity ssPLines(T("|Select polylines|"), EntPLine());
			
			if (ssPLines.go())
			{
				Entity selectedPLines[] = ssPLines.set();
				for (int e = 0; e < selectedPLines.length(); e++)
				{
					EntPLine entToolPath = (EntPLine)selectedPLines[e];
					if ( ! entToolPath.bIsValid())
					{
						reportNotice("\n"+scriptName()+": " + T ("|Invalid entity selected for a tool path|"));
						continue;
					}
					
					PLine selectedPath = entToolPath.getPLine();
					if (splitSelectedPLinesIntoSegments)
					{
						Point3d vertices[] = selectedPath.vertexPoints(false);
						for (int v = 1; v < vertices.length(); v++)
						{
							PLine path(el.vecZ() * sign(zoneIndex));
							path.addVertex(vertices[v - 1]);
							path.addVertex(vertices[v]);
							tooltypes.append(toolType);
							selectedToolPaths.append(path);
							overshoots.append(propOvershoot);
						}
					}
					else
					{
						tooltypes.append(toolType);
						selectedToolPaths.append(selectedPath);
						overshoots.append(propOvershoot);
					}
					entToolPath.dbErase();
				}
			}
		}
		else if (promptForInputMode.makeUpper() == "C")
		{
			PrEntity ssPLines(T("|Select circles|"), Entity());
			
			if (ssPLines.go())
			{
				Entity selectedPLines[] = ssPLines.set();
				for (int e = 0; e < selectedPLines.length(); e++)
				{
					Entity entToolPath = selectedPLines[e];
					if ( ! entToolPath.bIsValid())
					{
						reportNotice("\n"+scriptName()+": " + T ("|Invalid entity selected for a tool path|"));
						continue;
					}
					if (entToolPath.typeName() != "AcDbCircle") continue;
					
					PLine selectedPath = entToolPath.getPLine();
					if (splitSelectedPLinesIntoSegments)
					{
						Point3d vertices[] = selectedPath.vertexPoints(false);
						for (int v = 1; v < vertices.length(); v++)
						{
							PLine path(el.vecZ() * sign(zoneIndex));
							path.addVertex(vertices[v - 1]);
							path.addVertex(vertices[v]);
							tooltypes.append(toolType);
							selectedToolPaths.append(path);
							overshoots.append(propOvershoot);
						}
					}
					else
					{
						tooltypes.append(toolType);
						selectedToolPaths.append(selectedPath);
						overshoots.append(propOvershoot);
					}
					entToolPath.dbErase();
				}
			}
		}
	}
	// HSB-24528
	int bRegionDefined=((dRegionBottom>dEps || dRegionTop>dEps || dRegionLeft>dEps || dRegionRight>dEps) 
		&& (selectedToolPaths.length() == 0));
	PlaneProfile ppIncluded;
	PlaneProfile ppOps;
	if (selectedToolPaths.length() == 0) 
	{
		
		// no selection of Pline or circle, get from element		
		if (!el.bIsValid()) 
		{
			reportNotice("\n"+scriptName() + TN("|No valid element found|!"));
			eraseInstance();
			return;
		}
		
		// Remove existing saw lines first
		TslInst attachedTsls[] = el.tslInst();
		for (int t=0;t<attachedTsls.length();t++) 
		{
			TslInst tsl = attachedTsls[t];
			if (tsl.handle() != _ThisInst.handle() && tsl.scriptName() == scriptName() && tsl.propInt(1) == propZoneIndex)
			{
				tsl.dbErase();
			}
		}
		
		CoordSys zoneCoordSys = el.zone(zoneIndex).coordSys();
		PlaneProfile zoneProfile(zoneCoordSys);// = el.profNetto(zoneIndex);
		Sheet sheets[] = el.sheet(zoneIndex);
		Entity sheetEntities[0];
		for (int b = 0; b < sheets.length(); b++)
		{
			sheetEntities.append(sheets[b]);
		}
		Map filterGenBeamsMap;
		filterGenBeamsMap.setEntityArray(sheetEntities, false, "GenBeams", "GenBeams", "GenBeam");
		int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, filterDefinitionSheets, filterGenBeamsMap);
		if (!successfullyFiltered) {
			reportNotice("\n"+scriptName() +T("|Beams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
			eraseInstance();
			return;
		} 
		// get all opening profile, including doors
		ppOps=PlaneProfile (zoneCoordSys);
		if(bExcludeOpenings || bExcludeOutterContours)
		{ 
			Opening ops[]=el.opening();
			for (int o=0;o<ops.length();o++) 
			{ 
				ppOps.joinRing(ops[o].plShape(),_kAdd); 
			}//next o
			ppOps.shrink(U(1));
			ppOps.shrink(-U(1));
			ppOps.shrink(-U(1));
			ppOps.shrink(U(1));
//			ppOps.vis(1);
		}
		
		sheetEntities = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");
		for (int s=0;s<sheetEntities.length();s++)
		{
			Sheet sh = (Sheet)sheetEntities[s];
			if (abs(abs(el.vecZ().dotProduct(sh.vecZ())) - 1) > vectorTolerance) continue;
			
			PlaneProfile sheetProfile = sh.profShape();
			sheetProfile.shrink(-0.5 * mergeSheetsTolerance);
			zoneProfile.unionWith(sheetProfile);
		}
		zoneProfile.shrink(0.5 * mergeSheetsTolerance);
		Beam beams[] = el.beam();
		Entity beamEntities[0];
		for (int b = 0; b < beams.length(); b++)
		{
			beamEntities.append(beams[b]);
		}

		filterGenBeamsMap.setEntityArray(beamEntities, false, "GenBeams", "GenBeams", "GenBeam");
		successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, filterDefinitionBeams, filterGenBeamsMap);
		if (!successfullyFiltered) {
			reportNotice("\n"+scriptName() +T("|Beams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
			eraseInstance();
			return;
		} 
		beamEntities = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");
		
		PLine rings[] = zoneProfile.allRings();
		PLine convexHull(el.vecZ());
		convexHull.createConvexHull(Plane(zoneCoordSys.ptOrg(), zoneCoordSys.vecZ()), zoneProfile.getGripVertexPoints());
		PlaneProfile convexHullProfile(convexHull);
		int ringsAreOpening[] = zoneProfile.ringIsOpening();
		
		
		ppIncluded=PlaneProfile (zoneProfile.coordSys());
		if(bRegionDefined)
		{ 
			// HSB-24528: calculate the area where tooling is allowed
			// exclude regions where not allowed
			// get extents of profile
			LineSeg seg = zoneProfile.extentInDir(el.vecX());
			LineSeg segY = zoneProfile.extentInDir(el.vecY());
			ppIncluded.createRectangle(seg,el.vecX(),el.vecY());
			ppIncluded.shrink(-U(100));
			
			if(dRegionBottom>dEps)
			{ 
				PlaneProfile ppExclude(zoneProfile.coordSys());
				ppExclude.createRectangle(LineSeg(segY.ptStart()-el.vecX()*U(10e4)-el.vecY()*U(10e4),
					segY.ptStart()+el.vecX()*U(10e4)+el.vecY()*dRegionBottom),el.vecX(),el.vecY());
				ppIncluded.subtractProfile(ppExclude);
			}
			if(dRegionTop>dEps)
			{ 
				PlaneProfile ppExclude(zoneProfile.coordSys());
				ppExclude.createRectangle(LineSeg(segY.ptEnd()-el.vecX()*U(10e4)+el.vecY()*U(10e4),
					segY.ptEnd()+el.vecX()*U(10e4)-el.vecY()*dRegionTop),el.vecX(),el.vecY());
				ppIncluded.subtractProfile(ppExclude);
			}
			if(dRegionLeft>dEps)
			{ 
				PlaneProfile ppExclude(zoneProfile.coordSys());
				ppExclude.createRectangle(LineSeg(seg.ptStart()-el.vecX()*U(10e4)-el.vecY()*U(10e4),
					seg.ptStart()+el.vecX()*dRegionLeft+el.vecY()*U(10e4)),el.vecX(),el.vecY());
				ppIncluded.subtractProfile(ppExclude);
			}
			if(dRegionRight>dEps)
			{ 
				PlaneProfile ppExclude(zoneProfile.coordSys());
				ppExclude.createRectangle(LineSeg(seg.ptEnd()-el.vecX()*dRegionRight-el.vecY()*U(10e4),
					seg.ptEnd()+el.vecX()*U(10e4)+el.vecY()*U(10e4)),el.vecX(),el.vecY());
				ppIncluded.subtractProfile(ppExclude);
			}
		}
		
		for (int r=0;r<rings.length();r++) 
		{
			PLine ring = rings[r];
			
			// Perform the cleanup on this ring.
			Map ioMap;
			ioMap.setPLine("PLine", ring);
			ioMap.setInt("CloseResult", true);
			if (cleanUpPolyline)
			{				
				TslInst().callMapIO("HSB_G-CleanupPolyLine", ioMap);
				ring = ioMap.getPLine("PLine");
			}
			
			int ringIsOpening = ringsAreOpening[r];
			
			if(bExcludeOpenings && ringIsOpening)
			{ 
				// HSB-24528:exclude window openings
				// doors will be excluded from outter contour
				continue;
			}

			// TODO:  reverse the ring if needed!
						
			Point3d vertices[] = ring.vertexPoints(false);
			if (vertices.length() < 2) continue;
			
			if (pathDirection > 0)
			{
				Point3d from = vertices[0];
				Point3d to = vertices[1];
				Point3d mid = (from + to) / 2;
				Vector3d direction(to - from);
				direction.normalize();
				Vector3d normal = zoneCoordSys.vecZ().crossProduct(direction);
				if (ringIsOpening)
				{
					normal *= -1;
				}
				
				Point3d pointOutsideProfile = mid + normal;
				if (pathDirection == 1)
				{
					mid - normal;
				}
				
				if (zoneProfile.pointInProfile(pointOutsideProfile) == _kPointInProfile)
				{
					ring.reverse();
					vertices = ring.vertexPoints(false);
				}
			}
			
			if ((!ringIsOpening && splitOutlinePathIntoSegments) || (ringIsOpening && splitOpeningPathIntoSegments))
			{
				for (int v = 0; v < (vertices.length() - 1); v++)
				{
					PLine path(el.vecZ() * sign(zoneIndex));
					path.addVertex(vertices[v]);
					path.addVertex(vertices[v + 1]);
					// TODO: Verify path!
					
					int doNotAddSegment;
					if (filterDefinitionBeams != "")
					{
						Point3d plineCenter = (vertices[v] + vertices[v + 1]) / 2;
						Vector3d plineVector(vertices[v + 1] - vertices[v]);
						plineVector.normalize();
						Vector3d plineNormal = plineVector.crossProduct(el.vecZ());
						
						for (int index=0;index<beamEntities.length();index++) 
						{ 
							Beam beam = (Beam)beamEntities[index]; 
							Vector3d beamVecX = beam.vecX();
							
							if (abs(beamVecX.dotProduct(plineVector)) < 1 - vectorTolerance) continue;
							
							Point3d ptCenter = beam.ptCen(); 
							
							if (abs(plineNormal.dotProduct(plineCenter - ptCenter)) > U(40)) continue;
							
							doNotAddSegment = true;
						}
						
					}
					
					if (doNotAddSegment) continue;
					
					selectedToolPaths.append(path);
					overshoots.append(ringIsOpening ? yesNo[1] : convexHullProfile.pointInProfile(path.ptMid()) == _kPointInProfile ? yesNo[1] :propOvershoot);
					tooltypes.append(ringIsOpening ? openingToolType : outlineToolType);
					// store if inner ring/opening or outter contour
					bRingInners.append(ringIsOpening);
				}
			}
			else
			{
				PLine path(el.vecZ() * sign(zoneIndex));
				path = ring;
				selectedToolPaths.append(path);
				overshoots.append(ringIsOpening ? yesNo[1] : propOvershoot);
				tooltypes.append(ringIsOpening ? openingToolType : outlineToolType);
				// store if inner ring/opening or outter contour
				bRingInners.append(ringIsOpening);
			}
		}
	}

	lstEntities[0] = el;
	int numberOfInsertedTsls = 0;
	for (int p=0;p<selectedToolPaths.length();p++) 
	{
		PLine toolPath = selectedToolPaths[p];
		String thisOvershoot = overshoots[p];
		String thisToolType = tooltypes[p];
		int bRingInner=bRingInners[p];
//		mapTsl.setPLine("ToolPath", toolPath);
//		mapTsl.setPLine("OriginalToolPath", toolPath);
		mapTsl.setString("Overshoot", thisOvershoot);
		mapTsl.setString("ToolType", thisToolType);
		if(!bRegionDefined)
		{ 
			if(!bRingInner && 
				((bExcludeOutterContours && !bExcludeOpenings) || (!bExcludeOutterContours && bExcludeOpenings)))
			{ 
				// exclude outter contours(include doors) or exclude doors
				// windows are already included/excluded
				int bClosed=toolPath.isClosed();
				PLine toolPathNotClosed;
				if(!bClosed)
				{ 
					toolPathNotClosed=toolPath;
				}
				else
				{ 
					// V2.14
					Point3d ptsVert[] = toolPath.vertexPoints(false);
					for (int p=0;p<ptsVert.length();p++) 
					{ 
						toolPathNotClosed.addVertex(ptsVert[p]);
					}//next p
				}
				toolPath=toolPathNotClosed;
				toolPath.projectPointsToPlane(Plane(ppOps.coordSys().ptOrg(),ppOps.coordSys().vecZ()),ppOps.coordSys().vecZ());
				
				PLine plsNew[0];
				Point3d ptsVert[] = toolPath.vertexPoints(false); 
				int bFirstSegmentAdded;// first segment is added
				for (int seg=0;seg<ptsVert.length()-1;seg++) 
				{ 
					LineSeg lSeg(ptsVert[seg],ptsVert[seg+1]);
					Point3d ptMidI=.5*(ptsVert[seg]+ptsVert[seg+1]);
					Point3d ptClosest=ppOps.closestPointTo(ptMidI);
					if((ptClosest-ptMidI).length()<U(50))
					{ 
						// it is in opening
						if(bExcludeOpenings)
						{ 
							continue;
						}
						else if(!bExcludeOpenings)
						{ 
							// include doors
							PLine plNew(toolPath.coordSys().vecZ());
							plNew.addVertex(ptsVert[seg]);
							plNew.addVertex(ptsVert[seg+1]);
							plsNew.append(plNew);
						}
					}
					else
					{ 
						// it is outter contour
						if(bExcludeOutterContours)
						{ 
							// 
							continue;
						}
						else
						{ 
							// add as outter contour
							PLine plNew(toolPath.coordSys().vecZ());
							plNew.addVertex(ptsVert[seg]);
							plNew.addVertex(ptsVert[seg+1]);
							plsNew.append(plNew);
						}
					}
				}//next seg
				
//				PLine plsInOps[]=ppOps.splitPLine(toolPath,true,true);
//				for (int pp=0;pp<plsInOps.length();pp++) 
				for (int pp=0;pp<plsNew.length();pp++) 
				{ 
					PLine plp=plsNew[pp]; 
					mapTsl.setPLine("ToolPath", plp);
					mapTsl.setPLine("OriginalToolPath", plp);
					numberOfInsertedTsls++;
					TslInst tslNew;
					tslNew.dbCreate(strScriptName, vecUcsX, vecUcsY, lstBeams, lstEntities, lstPoints, T("|_LastInserted|"), true, mapTsl, "", "");	
				}//next pp
			}
			else
			{ 
				// no need for door areas
				numberOfInsertedTsls++;
				mapTsl.setPLine("ToolPath", toolPath);
				mapTsl.setPLine("OriginalToolPath", toolPath);
				TslInst tslNew;
				tslNew.dbCreate(strScriptName, vecUcsX, vecUcsY, lstBeams, lstEntities, lstPoints, T("|_LastInserted|"), true, mapTsl, "", "");	
			}
			
			//
//			numberOfInsertedTsls++;
//			TslInst tslNew;
//			tslNew.dbCreate(strScriptName, vecUcsX, vecUcsY, lstBeams, lstEntities, lstPoints, T("|_LastInserted|"), true, mapTsl, "", "");	
		}
		else if(bRegionDefined)
		{ 
			// HSB-24528
			ppIncluded.shrink(U(1));
			ppIncluded.shrink(-U(1));
			ppIncluded.shrink(-U(1));
			ppIncluded.shrink(U(1));
			int bClosed=toolPath.isClosed();
			// create open pline
			PLine toolPathNotClosed;
			if(!bClosed)
			{ 
				toolPathNotClosed=toolPath;
			}
			else
			{ 
				// V2.14
				Point3d ptsVert[] = toolPath.vertexPoints(false);
				for (int p=0;p<ptsVert.length();p++) 
				{ 
					toolPathNotClosed.addVertex(ptsVert[p]);
				}//next p
			}
			toolPath=toolPathNotClosed;
			toolPath.projectPointsToPlane(Plane(ppIncluded.coordSys().ptOrg(),ppIncluded.coordSys().vecZ()),ppIncluded.coordSys().vecZ());
			
			Point3d ptsVert[]=toolPath.vertexPoints(true);
			
			PLine toolPaths[0];
			
			if(ptsVert.length()>2)
			{
				PLine pls[]=ppIncluded.splitPLine(toolPath,true,true);
				toolPaths.append(pls);
			}
			else if(ptsVert.length()==2)
			{
				LineSeg lSeg(ptsVert[0],ptsVert[1]);
				LineSeg lSegs[]=ppIncluded.splitSegments(lSeg,true);
				for (int s=0;s<lSegs.length();s++) 
				{ 
					PLine plNew(toolPath.coordSys().vecZ());
					plNew.addVertex(lSegs[s].ptStart());
					plNew.addVertex(lSegs[s].ptEnd());
					toolPaths.append(plNew);
				}//next s
				
			}
			for (int pp=0;pp<toolPaths.length();pp++) 
			{ 
				PLine plp=toolPaths[pp]; 
				if(!bRingInner && 
				((bExcludeOutterContours && !bExcludeOpenings) || (!bExcludeOutterContours && bExcludeOpenings)))
				{ 
					// exclude outter contours(include doors) or exclude doors
					// windows are already included/excluded
					
					int bClosed=plp.isClosed();
					PLine plpNotClosed;
					if(!bClosed)
					{ 
						plpNotClosed=plp;
					}
					else
					{ 
						// V2.14
						Point3d ptsVert[] = plp.vertexPoints(false);
						for (int p=0;p<ptsVert.length();p++) 
						{ 
							plpNotClosed.addVertex(ptsVert[p]);
						}//next p
					}
					plp=plpNotClosed;
					plp.projectPointsToPlane(Plane(ppOps.coordSys().ptOrg(),ppOps.coordSys().vecZ()),ppOps.coordSys().vecZ());
					
					PLine plsNew[0];
					Point3d ptsVert[] = plp.vertexPoints(false); 
					int bFirstSegmentAdded;// first segment is added
					for (int seg=0;seg<ptsVert.length()-1;seg++) 
					{ 
						LineSeg lSeg(ptsVert[seg],ptsVert[seg+1]);
						Point3d ptMidI=.5*(ptsVert[seg]+ptsVert[seg+1]);
						Point3d ptClosest=ppOps.closestPointTo(ptMidI);
						if((ptClosest-ptMidI).length()<U(50))
						{ 
							// it is in opening
							if(bExcludeOpenings)
							{ 
								continue;
							}
							else if(!bExcludeOpenings)
							{ 
								// include doors
								PLine plNew(plp.coordSys().vecZ());
								plNew.addVertex(ptsVert[seg]);
								plNew.addVertex(ptsVert[seg+1]);
								plsNew.append(plNew);
							}
						}
						else
						{ 
							// it is outter contour
							if(bExcludeOutterContours)
							{ 
								// 
								continue;
							}
							else
							{ 
								// add as outter contour
								PLine plNew(plp.coordSys().vecZ());
								plNew.addVertex(ptsVert[seg]);
								plNew.addVertex(ptsVert[seg+1]);
								plsNew.append(plNew);
							}
						}
					}//next seg
					
	//				PLine plsInOps[]=ppOps.splitPLine(toolPath,true,true);
	//				for (int pp=0;pp<plsInOps.length();pp++) 
					for (int pp=0;pp<plsNew.length();pp++) 
					{ 
						PLine plp=plsNew[pp]; 
						mapTsl.setPLine("ToolPath", plp);
						mapTsl.setPLine("OriginalToolPath", plp);
						numberOfInsertedTsls++;
						TslInst tslNew;
						tslNew.dbCreate(strScriptName, vecUcsX, vecUcsY, lstBeams, lstEntities, lstPoints, T("|_LastInserted|"), true, mapTsl, "", "");	
					}//next pp
					
				}
				else
				{ 
					// no need for door consideration
					mapTsl.setPLine("ToolPath", plp);
					mapTsl.setPLine("OriginalToolPath", plp);
					numberOfInsertedTsls++;
					TslInst tslNew;
					tslNew.dbCreate(strScriptName, vecUcsX, vecUcsY, lstBeams, lstEntities, lstPoints, T("|_LastInserted|"), true, mapTsl, "", "");	
				}
			}//next pp
		}
	}
		
	eraseInstance();
	return;
}
if (_Element.length() == 0) 
{
	reportNotice("\n"+scriptName() +TN("|invalid or no element selected.|"));
	eraseInstance();
	return;
}

if (_Map.hasInt("ManualInserted")) {
	manualInserted = _Map.getInt("ManualInserted");
	_Map.removeAt("ManualInserted", true);
}

// set properties from catalog
if (_bOnDbCreated && manualInserted)
	setPropValuesFromCatalog(T("|_LastInserted|"));

if (_Map.hasInt("ZoneIndex")) {
	int zoneIndex = _Map.getInt("ZoneIndex");
	if (zoneIndex < 0)
		zoneIndex = 5 - zoneIndex;
	propZoneIndex.set(zoneIndex);
	
	_Map.removeAt("ZoneIndex", true);
}

if (_Map.hasInt("PathDirection"))
{
	int pathDirection = _Map.getInt("PathDirection");
	int pathDirectionIndex = pathDirections.find(pathDirection);
	if (pathDirectionIndex != -1)
	{
		propPathDirection.set(pathDirections[pathDirectionIndex]);
	}
	
	_Map.removeAt("PathDirection", true);
}

if (_Map.hasInt("ToolSide"))
{
	int toolSide = _Map.getInt("ToolSide");
	int toolSideIndex = toolSideIndexes.find(toolSide);
	if (toolSideIndex != -1)
	{
		propToolSide.set(toolSides[toolSideIndex]);
	}
	
	_Map.removeAt("ToolSide", true);
}

if (_Map.hasString("Overshoot")) {
	propOvershoot.set(_Map.getString("Overshoot"));
	
	_Map.removeAt("Overshoot", true);
}

if (_Map.hasDouble("ExtraDepth")) {
	additionalSawDepth.set(_Map.getDouble("ExtraDepth"));
	
	_Map.removeAt("ExtraDepth", true);
}

if (_Map.hasDouble("Angle")) {
	sawAngle.set(_Map.getDouble("Angle"));
	
	_Map.removeAt("Angle", true);
}

if (_Map.hasString("ToolType"))
{
	String mappedToolType = _Map.getString("ToolType");
	int toolTypeIndex = toolTypes.find(mappedToolType);
	if (toolTypeIndex != -1)
	{
		toolType.set(toolTypes[toolTypeIndex]);
	}
	
	_Map.removeAt("ToolType", true);
}

// Set the sequence number
_ThisInst.setSequenceNumber(sequenceNumber);

int toolSide = toolSideIndexes[toolSides.find(propToolSide,0)];
int turningDirection = turningDirectionIndexes[turningDirections.find(propTurningDirection,0)];
int overshoot = (yesNo.find(propOvershoot) == 0);
int cleanUpPolyline = (yesNo.find(propCleanUpPolyline) == 0);
int withNoNailArea = (yesNo.find(withNoNailAreaProp) == 0);

propSplitOutlinePathIntoSegments.setReadOnly(true);
propSplitOpeningPathIntoSegments.setReadOnly(true);
propSplitSelectedPLinesIntoSegments.setReadOnly(true);
filterDefinitionSheets.setReadOnly(true);
filterDefinitionBeams.setReadOnly(true);
outlineToolType.setReadOnly(true);
openingToolType.setReadOnly(true);

// get element
Element el = _Element[0];
assignToElementGroup(el, TRUE, 0, 'E');

int zoneIndex = propZoneIndex;
if (zoneIndex > 5)
{
	zoneIndex = 5 - zoneIndex;
}

CoordSys csEl = el.coordSys();
Point3d elOrg = csEl.ptOrg();
Vector3d elX = csEl.vecX();
Vector3d elY = csEl.vecY();
Vector3d elZ = csEl.vecZ();

ElemZone zone = el.zone(zoneIndex);
int zoneColor = zone.color();
CoordSys zoneCoordSys = el.zone(zoneIndex).coordSys();

//GenBeam zoneGenBeams[] = el.genBeam(zoneIndex);
//if (zoneGenBeams.length() > 0)
//{
//	zoneColor = zoneGenBeams[0].color();
//}
_ThisInst.setColor(zoneColor);

_Pt0 = elOrg;
if (!_Map.hasPLine("ToolPath"))
{
	reportMessage(TN("|No toolpath found.|"));
	eraseInstance();
	return;
}

PLine toolPath(zoneCoordSys.vecZ());
if (_Map.hasPoint3d("CenterPoint") && _Map.hasVector3d("Normal") && _Map.hasDouble("Radius"))
{
	toolPath.createCircle(_Map.getPoint3d("CenterPoint"), _Map.getVector3d("Normal"), _Map.getDouble("Radius"));
}
else
{
	toolPath = _Map.getPLine("ToolPath");
}

toolPath.vis();

if (!_Map.hasPLine("OriginalToolPath"))
{
	_Map.setPLine("OriginalToolPath", toolPath);
}

_ThisInst.setAllowGripAtPt0(false);

Point3d zoneFront = el.zone(zoneIndex + 1).coordSys().ptOrg();
if (zoneIndex < 0)
{
	zoneFront = el.zone(zoneIndex - 1).coordSys().ptOrg();
}
Plane pnZoneFront(zoneFront, elZ);

if( _kExecuteKey == recalcTriggers[0] ){
	toolPath.reverse();
	_Map.setPLine("ToolPath", toolPath);
	propPathDirection.set(pathDirections[0]);
}

if( _kExecuteKey == restoreOriginalToolPathCommand ){
	PLine originalToolPath = _Map.getPLine("OriginalToolPath");
	toolPath = originalToolPath;
	_Map.setPLine("ToolPath", toolPath);
	_PtG.setLength(0);
}
if( _kExecuteKey == recalcTriggers[3] ){
	_Map.setPLine("OriginalToolPath", toolPath);
}

if( _kExecuteKey == recalcTriggers[5] ){
	EntPLine entToolPath;
	entToolPath.dbCreate(toolPath);
}
if( _kExecuteKey == recalcTriggers[6] ){
	EntPLine entToolPath = getEntPLine(T("|Select polyline for new definition|"));
	if (entToolPath.bIsValid()) {
		PLine newToolPath = entToolPath.getPLine();
		toolPath = newToolPath;
		_Map.setPLine("ToolPath", toolPath);
		
		entToolPath.dbErase();
	}
}
if (_kExecuteKey == recalcTriggers[7])
{
	Point3d newStartPoint = getPoint();
	newStartPoint.projectPoint(pnZoneFront, U(0));
	PLine circle(elZ);
	circle.createCircle(newStartPoint, elZ, U(5));
	PlaneProfile validArea(circle);
	Point3d vertexPoints[] = toolPath.vertexPoints(false);
	
	int startIndex = 0;
	
	for (int index=0;index<vertexPoints.length();index++) 
	{ 
		Point3d vertexPoint = vertexPoints[index]; 
		if (validArea.pointInProfile(vertexPoint) != _kPointInProfile) continue;
		startIndex = index;
		break;
	}
	
	PLine newToolPath(toolPath.coordSys().vecZ());
	for (int index=startIndex;index<vertexPoints.length();index++) 
	{ 
		Point3d vertexPoint = vertexPoints[index]; 
		newToolPath.addVertex(vertexPoint);
	}
	
	int endIndex = startIndex;
	if (vertexPoints[0] == vertexPoints[vertexPoints.length() -1])
	{
		endIndex = startIndex + 1;
	}
	
	for (int index=0;index<endIndex;index++) 
	{ 
		Point3d vertexPoint = vertexPoints[index]; 
		newToolPath.addVertex(vertexPoint);
	}
	
	toolPath = newToolPath;
	_Map.setPLine("ToolPath", toolPath);
	_PtG.setLength(0);
}

// Project the points of the path to the front of the zone.
toolPath.projectPointsToPlane(pnZoneFront, elZ);

if (_PtG.length() == 0) 
	_PtG.append(toolPath.vertexPoints(true));

// Update the tool path if one of the grippoints is moved.
if( _kNameLastChangedProp.left(4) == "_PtG" )
{
	int indexMovedGripPoint = _kNameLastChangedProp.right(_kNameLastChangedProp.length() - 4).atoi();
	//_PtG[indexMovedGripPoint ] = pnZoneFront.closestPointTo(_PtG[indexMovedGripPoint ]);
	_PtG = pnZoneFront.projectPoints(_PtG);
	
	toolPath = PLine(elZ);
	for (int g=0;g<_PtG.length();g++)
		toolPath.addVertex(_PtG[g]);
		
	_Map.setPLine("ToolPath", toolPath);
}

double minimumAllowedToolPathLength = U(1);
if (_PtG.length() < 2 || toolPath.length() < minimumAllowedToolPathLength)
{
	PLine originalToolPath = _Map.getPLine("OriginalToolPath");
	// Try to restore the original toolpath
	if (originalToolPath.length() < minimumAllowedToolPathLength)
	{
		reportMessage("\n"+ scriptName() + "- " + el.number() + "-" + T("|Invalid toolpath found.|"));
		eraseInstance();
		return;
	}
	
	reportNotice("\n" + scriptName() + TN("|Element|: ") + el.number() + TN("|Toolpath was invalid and is restored with original toolpath.|"));
	toolPath = originalToolPath;
	_Map.setPLine("ToolPath", toolPath);
	_PtG.setLength(0);
	_PtG.append(toolPath.vertexPoints(true));
}

double zoneThickness = el.zone(zoneIndex).dH();
if (zoneThickness == 0) {
	Sheet sheetsInZone[] = el.sheet(zoneIndex);
	if (sheetsInZone.length() > 0)
		zoneThickness = sheetsInZone[0].dD(elZ);
}

PlaneProfile zoneProfile(zoneCoordSys);// = el.profNetto(zoneIndex);
Sheet sheets[] = el.sheet(zoneIndex);
Entity sheetEntities[0];
for (int b = 0; b < sheets.length(); b++)
{
	sheetEntities.append(sheets[b]);
}
Map filterGenBeamsMap;
filterGenBeamsMap.setEntityArray(sheetEntities, false, "GenBeams", "GenBeams", "GenBeam");
int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, filterDefinitionSheets, filterGenBeamsMap);
if (!successfullyFiltered) {
	reportNotice("\n"+scriptName() +TN("|Beams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
	eraseInstance();
	return;
} 
sheetEntities = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");

for (int s=0;s<sheetEntities.length();s++)
{
	Sheet sh = (Sheet)sheetEntities[s];
	if (abs(abs(el.vecZ().dotProduct(sh.vecZ())) - 1) > vectorTolerance) continue;
	
	PlaneProfile sheetProfile = sh.profShape();
	sheetProfile.shrink(-0.5 * mergeSheetsTolerance);
	zoneProfile.unionWith(sheetProfile);
}
zoneProfile.shrink(0.5 * mergeSheetsTolerance);

// Is the path on an opening?
int pathIsOnOpeningRing = false;
Point3d pointOnPath = toolPath.ptMid();
PLine rings[] = zoneProfile.allRings();
int ringsAreOpening[] = zoneProfile.ringIsOpening();
for (int r = 0; r < rings.length(); r++)
{
	PLine ring = rings[r];
	
	// Perform the cleanup on this ring.
	Map ioMap;
	ioMap.setPLine("PLine", ring);
	ioMap.setInt("CloseResult", true);
	if (cleanUpPolyline)
	{
		TslInst().callMapIO("HSB_G-CleanupPolyLine", ioMap);
		ring = ioMap.getPLine("PLine");
	}
	else
	{
		ring.simplify();
	}
	
	PlaneProfile ringProfile(zoneCoordSys);
	ringProfile.joinRing(ring, _kAdd);

	int ringIsOpening = ringsAreOpening[r];
	
	if (ringProfile.pointInProfile(pointOnPath) == _kPointOnRing)
	{
		pathIsOnOpeningRing = ringIsOpening;
		break;
	}
}

// Set the normal to point away from the sheeting.
Point3d vertices[] = toolPath.vertexPoints(true);
if (vertices.length() < 2)
{
	reportNotice("\n"+scriptName() +TN("|Invalid toolpath found.|"));
	eraseInstance();
	return;
}

Point3d from = vertices[0]; //_PtG[0];
Point3d to = vertices[1]; //_PtG[1];
Point3d mid = (from + to) / 2;
Vector3d direction(to - from);
direction.normalize();
Vector3d normal = zoneCoordSys.vecZ().crossProduct(direction);
Point3d pointOutsideProfile = mid + normal;
pointOutsideProfile.vis(1);
if (zoneProfile.pointInProfile(pointOutsideProfile) == _kPointInProfile)
{
	normal *= -1;
}
int pathIsClockwise = normal.dotProduct(zoneCoordSys.vecZ().crossProduct(direction)) > 0;
//if (pathIsOnOpeningRing)
//{
//	pathIsClockwise = ! pathIsClockwise;
//}

// Check direction
int pathDirection = pathDirections.find(propPathDirection, 0);
if (pathDirection > 0)
{
	if ((pathDirection == 1 && !pathIsClockwise) || (pathDirection == 2 && pathIsClockwise))
	{
		toolPath.reverse();
		normal *= -1;
		pathIsClockwise = (pathDirection == 1);
	}
}

if (toolSide == 2)
{
	toolSide = pathIsClockwise ? _kLeft : _kRight;
//	
//	if (pathIsOnOpeningRing)
//	{
//		toolSide = (toolSide == _kLeft) ? _kRight : _kLeft;
//	}
}

int toolTypeIndex = toolTypes.find(toolType, 0);
if (toolTypeIndex == 0) {
	ElemSaw tool(zoneIndex, toolPath, zoneThickness + additionalSawDepth, toolingIndex, toolSide, turningDirection, overshoot);
	if (sawAngle != 0)
		tool.setAngle(sawAngle);
	
	el.addTool(tool);
}
else if (toolTypeIndex == 1) {
	ElemMill tool(zoneIndex, toolPath, zoneThickness + additionalSawDepth, toolingIndex, toolSide, turningDirection, overshoot);
	
	el.addTool(tool);
}

int doNotErase = false;
if (_Map.hasInt("DoNotErase"))
{
	doNotErase = _Map.getInt("DoNotErase");
}
if (doNotErase)
{
	Display dp(1);
	dp.elemZone(el, zoneIndex, 'T');
	dp.textHeight(U(20));
	
	Vector3d direction(toolPath.ptEnd() - toolPath.ptStart());
	direction.normalize();
	Vector3d normal = toolPath.coordSys().vecZ().crossProduct(direction);
	
	dp.draw(T("|Manual Erase|"), toolPath.ptStart(), direction, normal, 1.25, 1.25);
}

if (withNoNailArea)
{
	int toolPathIsClosed = (toolPath.area() > 0);
	Point3d vertices[] = toolPath.vertexPoints(!toolPathIsClosed);
	
	Vector3d toolPathNormal = toolPath.coordSys().vecZ();
	
	for (int v = 0; v < (vertices.length() - 1); v++)
	{
		Point3d from = vertices[v];
		Point3d to = vertices[v + 1];
		
		Vector3d direction(to - from);
		direction.normalize();
		Vector3d normal = toolPathNormal.crossProduct(direction);
		if (toolSide == _kRight)
		{
			normal *= -1;
		}
		
		PLine noNailArea(toolPathNormal);
		noNailArea.createRectangle(LineSeg(from - direction * offsetNoNailAreaStart + normal * offsetNoNailAreaLeft, to + direction * offsetNoNailAreaEnd - normal * offsetNoNailAreaRight), direction, normal);
		
		ElemNoNail elemNoNail(zoneIndex, noNailArea);
		el.addTool(elemNoNail);
	}
}


// visualisation start point
int visualisationColor = 3;

Display visualisationDisplay(visualisationColor);
visualisationDisplay.textHeight(U(4));
visualisationDisplay.elemZone(el, zoneIndex, 'T');

Point3d allVertices[] = toolPath.vertexPoints(true);
Point3d firstVertice = allVertices[0];
Vector3d vxTxt = elX + elY;
vxTxt.normalize();
Vector3d vyTxt = elZ.crossProduct(vxTxt);
visualisationDisplay.draw("S", firstVertice, vxTxt, vyTxt, -1.1, 1.75);


#End
#BeginThumbnail
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
3S3&3(V:L1CD53A/-7XQTH$?_V>[4
`


























#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="1197" />
        <int nm="BreakPoint" vl="762" />
        <int nm="BreakPoint" vl="471" />
        <int nm="BreakPoint" vl="754" />
        <int nm="BreakPoint" vl="712" />
        <int nm="BreakPoint" vl="707" />
        <int nm="BreakPoint" vl="258" />
        <int nm="BreakPoint" vl="557" />
        <int nm="BreakPoint" vl="670" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-24528: Fix when considering door openings" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="15" />
      <str nm="DATE" vl="9/5/2025 1:41:46 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-24528: Improve when intersecting PLine with PlaneProfile" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="14" />
      <str nm="DATE" vl="9/5/2025 10:23:42 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-24528: Add properties for excluding regions at bottom,top,left,right" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="13" />
      <str nm="DATE" vl="9/4/2025 4:21:11 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-24528: Add properties to exclude opening or/and outter contours for tooling" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="12" />
      <str nm="DATE" vl="9/4/2025 2:32:38 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Add zone 0 as tooling zone." />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="11" />
      <str nm="DATE" vl="11/14/2023 3:43:41 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Make sure start symbol is in same zone" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="10" />
      <str nm="DATE" vl="8/31/2023 10:14:53 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Add option to clean up polyline for arced plines" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="9" />
      <str nm="DATE" vl="5/9/2023 12:15:57 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Change dbcreate to use lastinserted" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="8" />
      <str nm="DATE" vl="2/8/2023 11:18:00 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-16535 error messages will now shown in the hsb dialog instead of showing a warning" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="7" />
      <str nm="DATE" vl="9/16/2022 9:05:15 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Add option to select circles" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="2/24/2021 10:28:17 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End