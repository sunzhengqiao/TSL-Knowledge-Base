#Version 8
#BeginDescription
#Versions
3.11 28/11/2025 Another check for tube diameter Author: Robert Pol
3.10 27/11/2025 Make sure tube diameter is picked up for offset Author: Robert Pol
Version 3.9 20-11-2024 Fix visibility issue for the new property to display the height of the installationpoint. Add hide direction in the topview. Ronald van Wijngaarden
Version 3.8 20-11-2024 Add property to display the height of the installationpoint. This makes it possible to show them in hsbMake or on the layouts to be checked by contractors. Ronald van Wijngaarden
3.7 30/10/2024 Make sure index for propdouble is correct Author: Robert Pol
Version3.6 8-9-2022 Fix issue where tooling for slotted hole was checked for .intersect() instead of .hasIntersection Ronald van Wijngaarden
Version 3.5 25-1-2022 If plEnvelope of element is not valid for some reason, check the profBrutto of zone 0, for intersection of the points to create the installationtube. Ronald van Wijngaarden
3.4 21/12/2021 Also add body intersectioncheck for oval shapes. Author: Robert Pol
3.3 15.11.2021 HSB-12951: FreeProfile: setMachinePathOnly to false  Author: Marsel Nakuci
3.2 01/10/2021 Only add drills when the drill body is touching the sheet Author: Robert Pol
Version3.1 30-8-2021 Add option for tool to use for the visualization of the cutout in the sheet. Drill creates a segmented hole, freeprofile creates a round hole. for DXF tooling, a perfect round pline is needed. , Author Ronald van Wijngaarden
Version 3.0 23.06.2021 HSB-12370 installation shape published as dimrequests to be consumed by tsls liek hsbViewDimension , Author Thorsten Huck

Version2.9 6-4-2021 Adding a check for the length of the array, before using the array of _PtG[]. , Author Ronald van Wijngaarden

Version2.9 6-4-2021  , Author Ronald van Wijngaarden












#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 3
#MinorVersion 11
#KeyWords 
#BeginContents
//region History
/// <summary Lang=en>
/// This tsl creates an electrical object in a wall.
/// </summary>

/// <insert>
/// Select an element and a point
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>


/// <history>
// #Versions
//3.11 28/11/2025 Another check for tube diameter Author: Robert Pol
//3.10 27/11/2025 Make sure tube diameter is picked up for offset Author: Robert Pol
//3.9 20-11-2024 Fix visibility issue for the new property to display the height of the installationpoint. Add hide direction in the topview. Ronald van Wijngaarden
//3.8 20-11-2024 Add property to display the height of the installationpoint. This makes it possible to show them in hsbMake or on the layouts to be checked by contractors. Ronald van Wijngaarden
//3.7 30/10/2024 Make sure index for propdouble is correct Author: Robert Pol
//3.6 8-9-2022 Fix issue where tooling for slotted hole was checked for .intersect() instead of .hasIntersection Ronald van Wijngaarden
//3.5 25-1-2022 If plEnvelope of element is not valid for some reason, check the profBrutto of zone 0, for intersection of the points to create the installationtube. Ronald van Wijngaarden
//3.4 21/12/2021 Also add body intersectioncheck for oval shapes. Author: Robert Pol
// Version 3.3 15.11.2021 HSB-12951: FreeProfile: setMachinePathOnly to false  Author: Marsel Nakuci
//3.2 01/10/2021 Only add drills when the drill body is touching the sheet Author: Robert Pol
// 3.1 30-8-2021 Add option for tool to use for the visualization of the cutout in the sheet. Drill creates a segmented hole, freeprofile creates a round hole. for DXF tooling, a perfect round pline is needed. , Author Ronald van Wijngaarden
// 3.0 23.06.2021 HSB-12370 installation shape published as dimrequests to be consumed by tsls liek hsbViewDimension , Author Thorsten Huck


/// 1.00 - 14.03.2013 - 	Pilot version
/// 1.01 - 13.09.2013 - 	Add orientation
/// 1.02 - 20.12.2013 - 	Rename from HSB_E-ElectricityPoint to HSB_E-InstallationPoint.
/// 1.03 - 10.03.2014 - 	Set _kDevice for description. Add hatch pattern as a property.
/// 1.04 - 18.09.2014 - 	Show notice if icon side and zone 1 are not at the same side.
/// 1.05 - 20.03.2015 - 	Instance color is dependent from selected side: 3=Icon Side, 4=Opposite Icon
/// 1.06 - 13.05.2015 - 	Add subtype as dimension information (FogBugzId 1278).
/// 1.07 - 13.05.2015 - 	Add option to auto-insert tube. (FogBugzId 1278)
/// 1.08 - 13.05.2015 - 	Add option to extend tubes. (FogBugzId 1278)
/// 1.09 - 27.05.2015 - 	Add thumbnail
/// 1.10 - 16.06.2015 - 	Execute twice if tubes are placed by this tsl, because tubes are dependant on map of this tsl. 
///							Correct visualization box side. Add option to draw box as body. Start tubes at the edge of the box to avoid collision with the box.
/// 1.11 - 17.06.2015 - 	Add depth as a property
/// 1.12 - 25.06.2015 - 	Add option to apply tooling to all zones at the specified side at once. (FogBugzId 1352)
/// 1.13 - 02.07.2015 - 	Option for different hatch at the back added.
/// 1.14 - 17.07.2015 - 	Correct check on arrow flip
/// 1.15 - 05.09.2016 - 	Add option for horizontal offset.
/// 1.16 - 26.09.2016 - 	Add option to place installation point at front and back. If applied to front and back, the selected tubes will only be apply to the installation point at the front.
/// 1.17 - 16.01.2017 - 	Add BOM information.
/// 1.18 - 13.04.2017 - 	Add depth offset for tubes (DR)
/// 1.19 - 18.04.2017 - 	Set tube properties from map if possible. Add reset tube properties to context menu.
/// 1.20 - 01.05.2017 - 	Set description always paralell to screen device and horizontal (DR)
/// 1.21 - 29.05.2017	- 	Option to not apply tooling on certaing sheeting zones enabled (DR)
///						- 	Optional nogging added (DR)
/// 1.22 - 12.06.2017	- 	Removed <Depth offset> prop. for tubes. Now tubes manage that themselfs (DR)
/// DR - 1.23 - 23.06.2017	- Noggin and beamContacts (from dynamic stretch) assigned to element's group
/// DR - 1.24 - 30.06.2017	- Noggin added to element's group
///							- Tube will now remember its properties when changed
/// AP - 1.25 - 02.08.2017 - Add sOverruleDescription to BOM export 
/// AS - 1.26 - 25.09.2017 - Add tool to sheet as drill or beamcut for circular and rectangular boxes.
/// AS - 1.27 - 22.12.2017 - Add delete as custom action. 
/// AS - 1.28 - 09.01.2018 - Add option to reverse the toolpath for the milling.
/// AS - 1.29 - 24.01.2018 - Write netto and width and height too for BOM data.
/// AS - 1.30 - 07.03.2018 - Store affected zones, when routing the sheeting, as diminfo.
/// AS - 1.31 - 12.04.2018 - Correct typo and property name.
/// AS - 1.32 - 12.09.2018 - Option for custom action that can add extra tooling for points with an interdistance
/// AS - 1.33 - 13.11.2018 - Ignore case while searching for tsls with a specific name.
/// AS - 1.34 - 14.03.2019 - Make installation point client friendly.
//RVW- 1.35 - 06.05.2019 - Make the exclude tooling for certain zones also work for the cutout in the sheeting.
//RVW- 1.36 - 13.06.2019 - Add lines to the object types to show in dxf output. Also add diagonal line if object is at the back of the wall.
//RVW- 1.37 - 13.06.2019 - Add description to the new dxf properties.
//RVW- 1.38 - 20.06.2019 - Add offset for the center point to be used when using dxf output lines
/// RP - 1.39 - 23.09.2019 - Add custom block option for custom pline defenition
/// RP - 1.40 - 23.09.2019 - Add option to add beamcut to beams behind the installationpoint (always throughout)
/// AS - 1.41 - 18.02.2020 -Correct orientation slotted hole.
/// AS - 1.42 - 18.02.2020 -Add the option to specify the number of symbols per box.
/// FA - 1.43 - 24.03.2020 -Add a free profile instead of a solid subtract.
/// FA - 1.44 - 26.03.2020 -Only add a free profile if in profile of sheet.
/// FA - 1.45 - 26.05.2020 -Changed how properties are displayed because of error in combination with hsbViewTag.
/// RP - 1.46 - 19.06.2020 - HSB-7837: Add option for 1 or 2 tubes
/// RP - 1.47 - 22.06.2020 - Move property for amount of tubes to tubes category
/// RP - 1.48 - 22.06.2020 - Fix bug because second point not added to tube
/// RP - 1.49 - 03.07.2020 - Fix bug where offset was not set on first run
/// RP - 1.50 - 08.07.2020 - Add true color propertie for front and back
/// RP - 2.00 - 28.08.2020 - Allow to move intstallationpoint with grippoint
/// RP - 2.01 - 11.09.2020 - Add description for width and height of the box
/// RP - 2.02 - 17.09.2020 - fix wrong position of_Pt0
/// CBK - 2.03 - 23.09.2020 - Add property for select point options. Create on selected point or on given property height.
/// RP - 2.05 - 11.01.2021 - Add category for insertion mode and change duplicate index
/// NG - 2.06 -13.01.2021 HSB 10301 Milling direction in beams now depends on alignment.
///RVW - 2.07-05.03.2021 - Apply different beamcut when the beam is alligned with the el.vecX
///RVW - 2.08-12.03.2021 - Project PtG[0] to correct plane when it is changed and set the correct height, get the width of the Block for the cutting body when using a custom block.
///RVW - 2.09-06.04.2021 HSB-11460 - Adding a check for the length of the array, before using the array of _PtG[].
/// </history>
//endregion

//region General variables and OPM
//Script uses mm
Unit (1,"mm");
double dEps = U(0.1);
int bOnDebug=true;


// dxfOutputKey
String dxfOutputKey = "hsb_DxfOutput";
// PLine display in dxf output.
String dxfPLineDisplayKey = "PLineDisplay";
String dxfPathKey = "Path";
String dxfLayerKey = "Layer";
String dxfColorKey = "Color";


// Electrical object with its number of required boxes and the description.
String arSObject[0];
int arNNrOfBoxes[0];
String arSDescription[0];
arSObject.append(T("|Outlet|"));						arNNrOfBoxes.append(1);		arSDescription.append("A");
arSObject.append(T("|Double outlet|"));				arNNrOfBoxes.append(2);		arSDescription.append("B");
arSObject.append(T("|Switch|"));						arNNrOfBoxes.append(1);		arSDescription.append("C");
arSObject.append(T("|Double switch|"));				arNNrOfBoxes.append(2);		arSDescription.append("D");
arSObject.append(T("|Double-pole switch|"));			arNNrOfBoxes.append(1);		arSDescription.append("E");
arSObject.append(T("|Pull switch|"));					arNNrOfBoxes.append(1);		arSDescription.append("F");
arSObject.append(T("|Double-pole pull switch|"));	arNNrOfBoxes.append(1);		arSDescription.append("G");
arSObject.append(T("|Light connection|"));			arNNrOfBoxes.append(1);		arSDescription.append("H");
arSObject.append(T("|Water|"));							arNNrOfBoxes.append(1);		arSDescription.append("I");
arSObject.append(T("|Ground|"));							arNNrOfBoxes.append(1);		arSDescription.append("J");
arSObject.append(T("|Additional open|"));				arNNrOfBoxes.append(1);		arSDescription.append("K");
arSObject.append(T("|Additional closed|"));			arNNrOfBoxes.append(1);		arSDescription.append("L");
arSObject.append(T("|Custom|"));							arNNrOfBoxes.append(1);		arSDescription.append("X");

String arSOrientation[] = {T("|Horizontal|"), T("|Vertical|")};
int arnAmountOfTubes[] = {1, 2};

double arDAngle[] = {0, 90};

// Box positions (front or back) and the corresponding values for the visualization and entity color.
String arSSide[] = {T("|Front|"), T("|Back|")};
if (_bOnInsert)
	arSSide.append(T("|Front and back|"));

int arNSide[] = { 1, -1 };
int arNSymbolDirection[] = {_kCWise, _kCCWise};

// Box shape
String arSBoxShape[] = {T("|Circle|"),T("|Rectangular|"), T("|Slotted|"), T("Custom")};

// Tube information
String arSCatalogTube[] = TslInst().getListOfCatalogNames("HSB_E-InstallationTube");

// Flags.
String arSYesNo[] = { T("|Yes|"), T("|No|") };
int arNYesNo[] = {_kYes, _kNo};

//CutOut Tools
String arScutTool[] = { T("|Drill|"), T("|Free profile|")};

// What information has to be shown in elevation view
String arSShowInElevationView[] = {T("|Symbol|"), T("|Description|"), T("|Symbol and description|"), T("|Show nothing|")};
int arNShowInElevationView[] = {0, 1, 2, -1};

//Tooltype and -settings.
String arSToolType[] = {T("|None|"), T("|Mill|"), T("|Drill|")};
String arSSideMill[] = {T("|Left|"), T("|Right|")};
int arNSideMill[] = {_kLeft, _kRight};
String arSTurningDirectionMill[] = {T("|Turn against course|"), T("|Turn with course|")};
int arNTurningDirectionMill[] = {_kTurnAgainstCourse, _kTurnWithCourse};

//Sheeting index equivalence
String arSPositiveIndexes[]= { 6,7,8,9,10};

//String arSIndexEquivalent
// ---------------------------------------------------------------------------------------------------------------------------------------------

// Type & position of the electrical object.
String category = T("|Type| & ") + T("Position");

String pointMode[] = {T("|Create on selected point.|"), T("|Create on selected height.|")};
PropString pointSelectMode(48, pointMode, T("|Point select mode|"));
pointSelectMode.setCategory(category);
PropString sObject(1, arSObject, T("|Type|"));
sObject.setCategory(category);
PropString sSubType(21, "",T("|Subtype|"));
sSubType.setCategory(category);
sSubType.setDescription(T("|Sets the subtype.|") + TN("|The subtype can be used for filtering in the dimension tsl.|"));
PropDouble dOffset(14, U(0), T("|Horizontal offset|"));
dOffset.setCategory(category);
PropDouble dHeight(0, U(200), T("|Height|"));
dHeight.setCategory(category);
PropString sSide(2, arSSide, T("|Side|"));
sSide.setCategory(category);
PropInt nNrOfCustomBoxes(4, 1, T("|Number of custom boxes|"));
nNrOfCustomBoxes.setCategory(category);
nNrOfCustomBoxes.setDescription(T("|Sets the number of custom boxes|.")+TN("|NOTE|: ")+T("|This property only affects boxes of type| '")+T("|Custom|'"));
PropString sOrientation(19, arSOrientation, T("|Orientation|"));
sOrientation.setCategory(category);

// Box shape and size.
category = T("|Boxshape| & ") + T("-|size|");
PropString sBoxShape(4, arSBoxShape, T("|Shape|"));
sBoxShape.setCategory(category);
String blockNames[0];
blockNames.append("");
blockNames.append(_BlockNames);
PropString customBlock(31, blockNames, T("|Custom block|"));
customBlock.setCategory(category);
customBlock.setDescription(T("|From the selected block the pline will be used as milling tool on the element|") + TN("|The insertionpoint of the installationpoint should be the insertionpoint of the block|"));
PropDouble dBoxSize(2, U(72), T("|Diameter, or width of box|"));
dBoxSize.setCategory(category);
dBoxSize.setDescription(T("|This value will be the distance aligned to the orientation|"));
PropDouble dBoxHeight(1, U(72), T("|Height of box|"));
dBoxHeight.setCategory(category);
dBoxHeight.setDescription(T("|Only used for rectangular and slotted boxes|.") + TN("|This value will be the distance perpendicalar to the orientation|"));
PropDouble dBoxOverlap(3, U(4), T("|Box overlap|"));
dBoxOverlap.setCategory(category);
PropDouble dDepthBox(12, U(50), T("|Depth box|"));
dDepthBox.setCategory(category);
PropString makeAreaBetweenBoxesSquaredProp(45, arSYesNo, T("  |Make area between boxes squared|"), 1);
makeAreaBetweenBoxesSquaredProp.setCategory(category);

// Tube
category =  T("|Tubes|");
//PropDouble dTubeDepthOffset(16, U(0), T("|Depth offset|")); //(Removed: Now tube will has this value on its own OPM)
PropString sAddTubeToTop(22, arSYesNo, T("|Add tube to top|"), 1);
sAddTubeToTop.setCategory(category);
PropString sCatalogTubeToTop(23, arSCatalogTube, T("|Catalog tube to top|"));
sCatalogTubeToTop.setCategory(category);
PropDouble dExtendTubeAtTop(10, U(0), T("|Extend tube at top|"));
dExtendTubeAtTop.setCategory(category);
PropString sAddTubeToBottom(24, arSYesNo, T("|Add tube to bottom|"), 1);
sAddTubeToBottom.setCategory(category);
PropString sCatalogTubeToBottom(25, arSCatalogTube, T("|Catalog tube to bottom|"));
sCatalogTubeToBottom.setCategory(category);
PropDouble dExtendTubeAtBottom(11, U(0), T("|Extend tube at bottom|"));
dExtendTubeAtBottom.setCategory(category);
PropInt nAmountOfTubes(7, arnAmountOfTubes, T("|Amount of tubes|"));
nAmountOfTubes.setCategory(category);

// Visualization
category = T("|Visualization|");
PropString sDrawBoxAsBody(27, arSYesNo, T("|Draw box as body|"), 1);
sDrawBoxAsBody.setCategory(category);
PropInt nBoxColor(0, 5, T("|Color of box|"));
nBoxColor.setCategory(category);
PropInt nSymbolColor(1, 1, T("|Color of symbol|"));
nSymbolColor.setCategory(category);
PropDouble dSymbolSize(5, U(50), T("|Symbol size|"));
dSymbolSize.setCategory(category);
PropDouble textSize(4, U(50), T("|Text size|"));
textSize.setCategory(category);
PropString sShowInElevationView(6, arSShowInElevationView, T("|Elevation view|"));
sShowInElevationView.setCategory(category);
PropString sOverruleDescription(7, "", T("|Overrule description|"));
sOverruleDescription.setCategory(category);
PropString sHatchPatternFront(20, _HatchPatterns, T("|Hatch pattern front|"));
sHatchPatternFront.setCategory(category);
PropDouble dHatchScaleFront(9, 1, T("|Hatch scale front|"));
dHatchScaleFront.setCategory(category);
PropString sHatchPatternBack(29, _HatchPatterns, T("|Hatch pattern back|"));
sHatchPatternBack.setCategory(category);
PropDouble dHatchScaleBack(13, 1, T("|Hatch scale back|"));
dHatchScaleBack.setCategory(category);
PropInt numberOfSymbolsPerBox(6, 1, T("|Number of symbols per box|"));
numberOfSymbolsPerBox.setCategory(category);
PropInt trueColorFront(8, 3, T("|True color front|"));
trueColorFront.setCategory(category);
PropInt trueColorBack(9, 4, T("|True color back|"));
trueColorBack.setCategory(category);
PropString sShowHeightInFrontView(33, arSYesNo, T("|Show height of point|"), 1);
sShowHeightInFrontView.setCategory(category);


int arNColor[] = { trueColorFront, trueColorBack };

// DXF Visualisation
category =  T("|DXF visualization|");
PropInt installationDxfColor (5, 3,  T("|Dxf output Color|"));
installationDxfColor.setCategory(category);
PropString installationDxfLayer (47, "05_Electra",   T("|Dxf output Layer|"));
installationDxfLayer.setCategory(category);
PropDouble dOffsetDxfVisCenterPoint (26, U(0), T("|Offset dxf centerpoint|"));
dOffsetDxfVisCenterPoint.setCategory(category);
dOffsetDxfVisCenterPoint.setDescription(T("|Offset for the centerpoint only, not for the box itself. As to be visualised in the dxf output|"));

// Tooling
category =  T("|Tooling|");
PropString sToolType(9, arSToolType, T("|Tool type|"));
sToolType.setCategory(category);
PropString sApplyToolingPerZone(28, arSYesNo, T("|Apply tooling per zone|"), 0);
sApplyToolingPerZone.setCategory(category);
PropString sShCutOut(10, arSYesNo, T("|Show cut out in sheeting|"), 0);
sShCutOut.setCategory(category);

PropString sShCutOutTool(49, arScutTool, T("|Cut out tool|"), 0);
sShCutOutTool.setDescription(T("|Tool to use for the visualization of the cutout in the sheet. Drill creates a segmented hole, freeprofile creates a round hole|"));
sShCutOutTool.setCategory(category);

PropString sBmCutOut(32, arSYesNo, T("|Apply beamcut to beams|"), 0);
sBmCutOut.setCategory(category);
PropString sApplyNoNailArea(11, arSYesNo, T("|Apply no nail area|"), 1);
sApplyNoNailArea.setCategory(category);
PropDouble dOffsetNoNailArea(6, U(10), T("|Offset no nail area|"));
dOffsetNoNailArea.setCategory(category);
PropString sExcludedSheetingZones(30, "" ,T("|Excluded sheeting zones (index)|"));
sExcludedSheetingZones.setCategory(category);
sExcludedSheetingZones.setDescription(T("Sheeting zone indexes to not apply tooling (separated by ';')"));
// Milling

category =  "     "+ T("|Mill|");
String millDirections[] = 
{
	T("|Forward|"),
	T("|Backward|")
};
PropString millDirectionProp(46, millDirections,  T("Mill direction"));
millDirectionProp.setCategory(category);
PropInt nToolIndexMill(2,0,  T("Toolindex mill"));
nToolIndexMill.setCategory(category);
PropDouble dExtraDepthMill(7, U(0),  T("|Extra depth mill|"));
dExtraDepthMill.setCategory(category);
PropString sApplyVacuumMill(13,arSYesNo, T("Apply vacuum for mill"));
sApplyVacuumMill.setCategory(category);
PropString sSideMill(14, arSSideMill,  T("|Side for mill|"));
sSideMill.setCategory(category);
PropString sTurningDirectionMill(15, arSTurningDirectionMill,  T("|Turning direction mill|"));
sTurningDirectionMill.setCategory(category);
PropString sOvershootMill(16, arSYesNo,  T("|Overshoot mill|"));
sOvershootMill.setCategory(category);
// Drill
category = "     "+T("|Drill|");
PropInt nToolIndexDrill(3,0, T("Toolindex drill"));
nToolIndexDrill.setCategory(category);
PropDouble dExtraDepthDrill(8, U(0),  T("|Extra depth drill|"));
dExtraDepthDrill.setCategory(category);
PropString sApplyVacuumDrill(18,arSYesNo, T("Apply vacuum for drill"));
sApplyVacuumDrill.setCategory(category);

// Noggin
String sNoYes[] = {T("|No|"),T("|Yes|")};
String arSAlignments[] = {T("|Front|"), T("|Center|"), T("|Back|")};

category =  T("|Noggin|");

PropString sCreateNoggin(37, sNoYes, T("|Create| "), 0);
sCreateNoggin.setCategory(category);
PropDouble dElevation(21, U(1250), T("|Elevation|"));
dElevation.setCategory(category);
PropString sAlignment(34, arSAlignments, T("|Alignment|"), 1);
sAlignment.setCategory(category);
PropDouble dDepthOffset(22, 0, T("|Offset| "));
dDepthOffset.setCategory(category);
PropDouble dNogginW(23, 0, T("|Width|"));
dNogginW.setCategory(category);
dNogginW.setDescription(T("|Taken from element if value=0|"));
PropDouble dNogginH(24, 0, T("|Height| "));
dNogginH.setCategory(category);
dNogginH.setDescription(T("|Taken from element if value=0|"));
PropString sNogginName(40, "", T("|Name|"));
sNogginName.setCategory(category);
PropString sNogginMaterial(41, "", T("|Material|"));
sNogginMaterial.setCategory(category);
PropString sNogginGrade(42, "", T("|Grade|"));
sNogginGrade.setCategory(category);
PropString sNogginInformation(43, "", T("|Information|"));
sNogginInformation.setCategory(category);
PropString sNogginLabel(44, "", T("|Label|"));
sNogginLabel.setCategory(category);
PropString sNogginBeamCode(42, "", T("|Beam code|"));
sNogginBeamCode.setCategory(category);
PropDouble interDistance(25, 0, T("|Interdistance|"));
interDistance.setCategory(category);
interDistance.setDescription(T("|This value is used when multiple boxes are placed next to each other|"));


String recalcTriggers[] = {
	T("|Reset tube properties|"),
	T("|Delete installation point and tubes|"),
	T("|Add/remove extra mill negative|"),
	T("|Add/remove extra mill positive|"),
	T("|Automatically calculate extra millings|")
};

for( int i=0;i<recalcTriggers.length();i++ )
{
	addRecalcTrigger(_kContext, recalcTriggers[i] );
}

//-------------------------------------------------------------------
// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_E-InstallationPoint");
if( arSCatalogNames.find(_kExecuteKey) != -1 ) 
{
	setPropValuesFromCatalog(_kExecuteKey);
}
//endregion

//region bOnInsert
if( _bOnInsert ){
	if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	
	int nNrOfTslsInserted = 0;	
	//Select element
	Element elSelected = getElement(T("|Select an element|"));
	
	// Add electra tsl to one or more positions
	Point3d arPtElectra[0];
	
	while(true)
	{
		String sTxt = T("|Select position|");
		if(arPtElectra.length() > 0)
			sTxt = T("|Select position|" + (arPtElectra.length() + 1));
		PrPoint prPt(sTxt);
		if(prPt.go() == _kOk)
			arPtElectra.append(prPt.value());
		else
			break;
	}
	
	//insertion point
	String strScriptName = "HSB_E-InstallationPoint"; // name of the script
	Vector3d vecUcsX(1,0,0);
	Vector3d vecUcsY(0,1,0);
	Beam lstBeams[0];
	Entity lstEntities[] = {
		elSelected
	};
	
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	Map mapTsl;
	mapTsl.setInt("MasterToSatellite", true);
	setCatalogFromPropValues("MasterToSatellite");
	for( int i=0;i<arPtElectra.length();i++ ){
		Point3d ptElectra = arPtElectra[i];

		lstPoints.append(ptElectra);
		
		if (pointSelectMode == pointMode[0])
		{
			lstPoints.append(ptElectra);
		}

		if (sSide == arSSide[2])
			mapTsl.setString("Side", arSSide[0]);
		
		TslInst tsl;
		tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
		lstPoints.setLength(0);		
		nNrOfTslsInserted++;
		
		if (sSide == arSSide[2]) {
			mapTsl.setString("Side", arSSide[1]);
			mapTsl.setInt("Tubes", false);
			
			TslInst tsl;
			tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
				
			nNrOfTslsInserted++;
		}
	}

	reportMessage("\n"+nNrOfTslsInserted + " " +T(scriptName() + " |tsl(s) inserted|"));	
	eraseInstance();
	return;
}
//endregion

// set properties from master
if( _Map.hasInt("MasterToSatellite") ){
	int bMasterToSatellite = _Map.getInt("MasterToSatellite");
	if( bMasterToSatellite ){
		int bPropertiesSet = _ThisInst.setPropValuesFromCatalog("MasterToSatellite");
		_Map.removeAt("MasterToSatellite", true);
	}
}

if (_Map.hasString("Side")) {
	sSide.set(_Map.getString("Side"));
	_Map.removeAt("Side", true);
}

if (_Map.hasInt("Tubes")) {
	int tubes = _Map.getInt("Tubes");
	String applyTubes = tubes ? arSYesNo[0] : arSYesNo[1];
	
	sAddTubeToBottom.set(applyTubes);
	sAddTubeToTop.set(applyTubes);
}

//Check if there is an element selected
if( _Element.length() == 0 ){
	reportNotice(T("|No element selected|."));
	eraseInstance();
	return;
}

String catalogKeyTopTube = "TopTubeCatalog";
String catalogKeyBottomTube = "BottomTubeCatalog";

//Delete created entities
for (int m=0;m<_Map.length();m++)
{
	if (!_Map.hasEntity(m) || _Map.keyAt(m) != "EntityToDelete")
		continue;
	
	Entity ent = _Map.getEntity(m);
	ent.dbErase();
	
	_Map.removeAt(m, true);
	m--;
}

if( _kExecuteKey == recalcTriggers[0] )
{
	_Map.removeAt(catalogKeyTopTube, true);
	_Map.removeAt(catalogKeyBottomTube, true);
}

if( _kExecuteKey == recalcTriggers[1] )
{
	
	for (int i = 0; i < _Map.length(); i++)
	{
		if (_Map.keyAt(i) == "Tube" && _Map.hasEntity(i))
		{
			Entity entTube = _Map.getEntity(i);
			entTube.dbErase();
			_Map.removeAt(i, true);
			i--;
		}
	}
	reportMessage(T("|Point and linked tubes are removed.|"));
	eraseInstance();
	return;
}

if( _kExecuteKey == recalcTriggers[2] )
{
	if (_Map.getInt("Negative"))
	{
		_Map.setInt("Negative", false);	
	}
	else
	{
		_Map.setInt("Negative", true);
	}
}

if( _kExecuteKey == recalcTriggers[3] )
{
	if (_Map.getInt("Positive"))
	{
		_Map.setInt("Positive", false);	
	}
	else
	{
		_Map.setInt("Positive", true);
	}
}

//Resolve properties.
//Based on type
String sDescription = arSDescription[arSObject.find(sObject,0)];
int nNrOfBoxes = arNNrOfBoxes[arSObject.find(sObject,0)];
if( sObject == T("|Custom|") )
{
	nNrOfBoxes = nNrOfCustomBoxes;
}
double dAngle = arDAngle[arSOrientation.find(sOrientation, 0)];
int nCWise = arNSymbolDirection[arSSide.find(sSide,0)];
Hatch hatchFront( sHatchPatternFront, dHatchScaleFront);
Hatch hatchBack( sHatchPatternBack, dHatchScaleBack);
//Based on position
int nSide = arNSide[arSSide.find(sSide,0)];
Hatch hatch = hatchFront;
if (nSide < 0)
	hatch = hatchBack;
//Based on box shape and size
int nBoxShape = arSBoxShape.find(sBoxShape,0);
int makeAreaBetweenBoxesSquared = arNYesNo[arSYesNo.find(makeAreaBetweenBoxesSquaredProp, 1)];

// Tube
int bAddTubeToTop = arNYesNo[arSYesNo.find(sAddTubeToTop,1)];
int bAddTubeToBottom = arNYesNo[arSYesNo.find(sAddTubeToBottom,1)];
//Visualization
int bDrawBoxAsBody = arNYesNo[arSYesNo.find(sDrawBoxAsBody, 1)];
int nShowInElevationView= arNShowInElevationView[arSShowInElevationView.find(sShowInElevationView,0)];
int bShowSymbolInElevation = false;
if( nShowInElevationView == 0 || nShowInElevationView == 2)
	bShowSymbolInElevation = true;
int bShowDescriptionInElevation = false;
if( nShowInElevationView > 0 )
	bShowDescriptionInElevation = true;
int bShowHeightInFrontView = arNYesNo[arSYesNo.find(sShowHeightInFrontView, 1)];

//Tooling
int nToolType = arSToolType.find(sToolType,0);
int bApplyToolingPerZone = arNYesNo[ arSYesNo.find(sApplyToolingPerZone, 0) ];
int bShowShCutOutSheets = arNYesNo[ arSYesNo.find(sShCutOut, 0) ];
int bUseDrillForCutOutSheets =  sShCutOutTool == T("|Drill|");
int bApplyBeamCutToBeams = arNYesNo[ arSYesNo.find(sBmCutOut, 0) ];
int bApplyNoNailArea = arNYesNo[arSYesNo.find(sApplyNoNailArea, 1)];
int nExcludedSheetingZones[0];
for (int s=0;s<sExcludedSheetingZones.length();s++) 
{ 
	String token= sExcludedSheetingZones.token(s, ";");
	if(token=="")
		continue;
	int zone= token.atoi();
	nExcludedSheetingZones.append(zone);
}

//Tooling - mill
int reverseMillDirection = millDirections.find(millDirectionProp, 0);
int bApplyVacuumMill = arNYesNo[arSYesNo.find(sApplyVacuumMill, 1)];
int nSideMill = arNSideMill[arSSideMill.find(sSideMill,0)];
int nTurningDirectionMill = arNTurningDirectionMill[arSTurningDirectionMill.find(sTurningDirectionMill,0)];
int bOvershootMill = arNYesNo[arSYesNo.find(sOvershootMill, 1)];
//Tooling - drill
int bApplyVacuumDrill = arNYesNo[arSYesNo.find(sApplyVacuumDrill, 1)];

//Noggin
int bCreateNoggin= sNoYes.find(sCreateNoggin);
int nAlignment= arSAlignments.find(sAlignment, 1);

//Assign selected element to el.
Element el = _Element[0];
int nZoneIndex = 0;
char chZoneCharacter = 'E';
_ThisInst.assignToElementGroup(el, true, nZoneIndex, chZoneCharacter);

//Usefull set of vectors.
CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

Point3d ptBack = el.zone(-1).coordSys().ptOrg();
Point3d ptFront = ptEl;

double dElWidth=el.dBeamWidth();

Vector3d vxBox = vxEl.rotateBy(dAngle, vzEl);
Vector3d vyBox = vyEl.rotateBy(dAngle, vzEl);

if( _kNameLastChangedProp == "_PtG0" )
{
	dHeight.set(el.vecY().dotProduct(_PtG[0] - _Pt0));
}
else if (_kNameLastChangedProp == T("|Height|"))
{
	_PtG[0].transformBy(el.vecY() * el.vecY().dotProduct(_Pt0 + el.vecY() * dHeight - _PtG[0]));
}

if( _kExecuteKey == recalcTriggers[4])
{
	TslInst elTsls[] = el.tslInst();
	Point3d ptOrgs[0];
	TslInst tsls[0];
	for (int t=0;t<elTsls.length();t++) 
	{ 
		TslInst tsl = elTsls[t]; 
		String scriptName = tsl.scriptName();
		if (tsl.scriptName().makeUpper() != "HSB_E-InstallationPoint".makeUpper()) continue;
		
		Point3d ptOrg = tsl.ptOrg();
		ptOrgs.append(ptOrg);
		tsls.append(tsl);
	}
	
	Point3d sortedOrgs[0];
	sortedOrgs.append(ptOrgs);
	vxBox.vis(el.ptOrg());
	for (int index=0;index<sortedOrgs.length();index++) 
	{ 
		Point3d point = sortedOrgs[index]; 
		//point.vis(index);
		for (int index2=0;index2<ptOrgs.length();index2++) 
		{ 
			if (index == index2 || index2 < index) continue;
			Point3d point2 = sortedOrgs[index2]; 
			//point2.vis(index);
			if (vxBox.dotProduct(point2 - point) < 0)
			{
				sortedOrgs.swap(index, index2);
				tsls.swap(index, index2);
				if (index2 > index)
				{
					index --;
					break;
				}
			} 
		} 
	}
	
	int stop;
	
	for (int o=0;o<sortedOrgs.length() -1;o++) 
	{ 
		Point3d pt = sortedOrgs[o]; 
		pt.vis(o);
		TslInst thisInst = tsls[o];
		TslInst NextInst = tsls[o + 1];
		Point3d ptNext = sortedOrgs[o + 1];
		double distanceBetweenPoints = abs(vxBox.dotProduct(ptNext - pt));
		if (distanceBetweenPoints > U(100))
		{
			stop = true;
		}
		else
		{
			stop = false;
		}
	
		if (stop)
		{
			if (thisInst.map().getInt("Negative")) 
			{
				thisInst.recalcNow(T("|Add/remove extra mill negative|"));					
			}
		}
		else if (! thisInst.map().getInt("Negative"))
		{
			thisInst.recalcNow(T("|Add/remove extra mill negative|"));
		}
	}
	
}

// Verify icon side with zones
int nArrowFlipped = 1; // 1 = no, -1 = yes
Sheet arShZn01[] = el.sheet(1);
Sheet arShZn06[] = el.sheet(-1);
Sheet shFront;
Sheet shBack;
if (arShZn01.length() > 0)
	shFront = arShZn01[0];
if (arShZn06.length() > 0)
	shBack = arShZn06[0];

if (shFront.bIsValid()) {
	if (vzEl.dotProduct(shFront.ptCen() - ptBack) < 0) {
		reportMessage(TN("|WARNING|: ") + T("|Icon is not on same side as zone 1 for element| ") + el.number() + TN("|Icon side is maintained as front side.|"));
		nSide *= -1;
		nArrowFlipped *= -1;
	}
}
else if (shBack.bIsValid()) {
	if (vzEl.dotProduct(shBack.ptCen() - ptFront) > 0) {
		reportMessage(TN("|WARNING|: ") + T("|Icon is not on same side as zone 6 for element| ") + el.number() + TN("|Icon side is maintained as front side.|"));
		nSide *= -1;
		nArrowFlipped *= -1;
	}
}

Map mapDimInfo;
mapDimInfo.setInt("ZoneIndex", nSide);
if (sSubType != "")
	mapDimInfo.setString("SubType", sSubType);
// Map is added at the end of the script.


Map mapBOM;
mapBOM.setString("Name", sObject);
mapBOM.setString("Label", sSubType);
mapBOM.setString("SubLabel", sBoxShape);
mapBOM.setString("Type",sOverruleDescription);
mapBOM.setDouble("Width", dBoxSize);
mapBOM.setDouble("Height", dBoxHeight);
mapBOM.setDouble("NettoWidth", dBoxSize);
mapBOM.setDouble("NettoHeight", dBoxHeight);
_Map.setMap("BOM", mapBOM);

//Displays
Display dpBox(nBoxColor);
dpBox.elemZone(el, nSide, 'I');
dpBox.showInDxa(true);
Display dpBoxNoPlot(-1);
dpBoxNoPlot.elemZone(el, nSide, 'T');
Display dpSymbol(nSymbolColor);
//dpSymbol.showInDxa(true);
dpSymbol.textHeight(textSize);
dpSymbol.elemZone(el, nSide, 'I');
dpSymbol.addHideDirection(vzEl);
dpSymbol.addHideDirection(-vzEl);

Display dpSymbolElevation(nSymbolColor);
dpSymbolElevation.showInDxa(true);
dpSymbolElevation.textHeight(textSize);
dpSymbolElevation.elemZone(el, nSide, 'I');
dpSymbolElevation.addHideDirection(vyEl);
dpSymbolElevation.addHideDirection(-vyEl);

//Project insertion point to front of wall outline.
_Pt0 = Line(ptEl, vxEl).closestPointTo(_Pt0);

if (_PtG.length() > 0)
{
	if ( nSide * nArrowFlipped == -1 ) //Back and arrow side is not flipped or front and arrow is flipped
	{
		_Pt0 = _Pt0 - vzEl * el.zone(0).dH();
		_PtG[0] = _PtG[0] - vzEl * el.zone(0).dH();
	}
	_PtG[0] = Line(_Pt0 + vyEl * dHeight, vxEl).closestPointTo(_PtG[0]);
}

//Installation point
Point3d ptInsert;
if( _PtG.length() == 0 ){
	ptInsert = _Pt0 + vyEl * dHeight;
	_PtG.append(ptInsert);
}
else{
	ptInsert = _PtG[0];
}

_Pt0 += vxEl * vxEl.dotProduct(ptInsert - _Pt0);

//Insertion point
Point3d ptInsertBottom = _Pt0 + vxEl * dOffset;
//Array of beams
Beam arBm[] = el.beam();
if( arBm.length() == 0 )return;

//Array of sheets
Sheet arSh[] = el.sheet();

//Draw box(es)
Map mapElectra;
//Store the side
mapElectra.setInt("Side", nSide);

// map based dimrequests HSB-123333-2.
Map mapRequests;

//dxf output
PLine installationPLines[0];
Display installationDisplay(installationDxfColor);
String sBackside = "AK";


Point3d ptFirstBox = ptInsert - vxBox * (nNrOfBoxes - 1) * 0.5 * (dBoxSize - dBoxOverlap);
int n=nNrOfBoxes;
int breakLoop;
for( int i=0;i<nNrOfBoxes;i++ ){
	Point3d ptBox = ptFirstBox + vxBox * (dBoxSize - dBoxOverlap) * i;
	Point3d ptOffsetBox = ptBox + vyBox * dOffsetDxfVisCenterPoint;
	PLine plBox(vzEl);
	PLine extraMillPline(vzEl);
	extraMillPline.createRectangle(LineSeg(ptBox - vxBox * 0.5 * interDistance - vyBox * 0.5 * dBoxHeight, ptBox + vxBox * 0.5 * interDistance + vyBox * 0.5 * dBoxHeight), vxBox, vyBox);
	if( nBoxShape == 0 )
	{
		plBox.createCircle(ptBox, vzEl, 0.5 * dBoxSize);
		
		// Draw installation point as a + sign
		PLine linePointHorizontal(vzEl);
		linePointHorizontal.addVertex(ptOffsetBox - vxEl * 0.5 * dSymbolSize);
		linePointHorizontal.addVertex(ptOffsetBox + vxEl * 0.5 * dSymbolSize);
				
		PLine linePointVertical(vzEl);
		linePointVertical.addVertex(ptOffsetBox - vyEl * 0.5 * dSymbolSize);
		linePointVertical.addVertex(ptOffsetBox + vyEl * 0.5 * dSymbolSize);
				
		installationPLines.append(linePointHorizontal);
		installationPLines.append(linePointVertical);	
		
		//Make diagonall line if the box is at the back of the element.
		if (nSide < 0)
		{
			Point3d ptBackTopLeft = (ptBox + vyBox * 0.5 * dBoxHeight) - (vxBox * 0.5 * dBoxSize);
			Point3d ptBackBottomRight = (ptBox - vyBox * 0.5 * dBoxHeight) + (vxBox * 0.5 * dBoxSize);
			
			PLine lineBoxBackside(vzEl);
			lineBoxBackside.addVertex(ptBackTopLeft);
			lineBoxBackside.addVertex(ptBackBottomRight);
			installationPLines.append(lineBoxBackside);
		}			
	}
	else if( nBoxShape == 1 )
	{
		plBox.createRectangle(LineSeg(ptBox - vxBox * 0.5 * dBoxSize - vyBox * 0.5 * dBoxHeight, ptBox + vxBox * 0.5 * dBoxSize + vyBox * 0.5 * dBoxHeight), vxBox, vyBox);
		
		///Create lines to visualise the top of the box
		Point3d topCenterPoint = ptBox + vyBox * 0.5 * dBoxHeight;
		Point3d topLeftPoint = topCenterPoint - vxBox * 0.5 * dBoxSize;
		Point3d topRightPoint = topCenterPoint +vxBox * 0.5 * dBoxSize;
		
		PLine linePointUpperLeftCorner(vzEl);
		linePointUpperLeftCorner.addVertex(topLeftPoint - vyBox * 0.25 * dBoxHeight);
		linePointUpperLeftCorner.addVertex(topLeftPoint);
		linePointUpperLeftCorner.addVertex(topLeftPoint + vxBox * 0.25 * dBoxSize);
		installationPLines.append(linePointUpperLeftCorner);
		
		PLine linePointUpperRightCorner(vzEl);
		linePointUpperRightCorner.addVertex(topRightPoint - vyBox * 0.25 * dBoxHeight);
		linePointUpperRightCorner.addVertex(topRightPoint);
		linePointUpperRightCorner.addVertex(topRightPoint - vxBox * 0.25 * dBoxSize);
		installationPLines.append(linePointUpperRightCorner);
		
		///Create lines to visualise the bottom of the box
		Point3d bottomCenterPoint = ptBox - vyBox * 0.5 * dBoxHeight;
		Point3d bottomLeftPoint = bottomCenterPoint - vxBox * 0.5 * dBoxSize;
		Point3d bottomRightPoint = bottomCenterPoint +vxBox * 0.5 * dBoxSize;
		
		PLine linePointBottomLeftCorner(vzEl);
		linePointBottomLeftCorner.addVertex(bottomLeftPoint + vyBox * 0.25 * dBoxHeight);
		linePointBottomLeftCorner.addVertex(bottomLeftPoint);
		linePointBottomLeftCorner.addVertex(bottomLeftPoint + vxBox * 0.25 * dBoxSize);
		installationPLines.append(linePointBottomLeftCorner);
		
		PLine linePointBottomRightCorner(vzEl);
		linePointBottomRightCorner.addVertex(bottomRightPoint + vyBox * 0.25 * dBoxHeight);
		linePointBottomRightCorner.addVertex(bottomRightPoint);
		linePointBottomRightCorner.addVertex(bottomRightPoint - vxBox * 0.25 * dBoxSize);
		installationPLines.append(linePointBottomRightCorner);
		
		//Make diagonall line if the box is at the back of the element.
		if (nSide < 0)
		{
			Point3d ptBackTopLeft = (ptBox + vyBox * 0.5 * dBoxHeight) - (vxBox * 0.5 * dBoxSize);
			Point3d ptBackBottomRight = (ptBox - vyBox * 0.5 * dBoxHeight) + (vxBox * 0.5 * dBoxSize);
			
			PLine lineBoxBackside(vzEl);
			lineBoxBackside.addVertex(ptBackTopLeft);
			lineBoxBackside.addVertex(ptBackBottomRight);
			installationPLines.append(lineBoxBackside);			
		}
	}
	else if (nBoxShape == 2)
	{
		Point3d ptA = ptBox - vxBox * (dBoxSize- dBoxHeight) / 2 + vyBox * dBoxHeight / 2;
		Point3d ptB = ptBox - vxBox * (dBoxSize- dBoxHeight) / 2 - vyBox * dBoxHeight / 2;
		Point3d ptC = ptBox + vxBox * (dBoxSize - dBoxHeight) / 2 - vyBox * dBoxHeight / 2;
		Point3d ptD = ptBox + vxBox * (dBoxSize - dBoxHeight) / 2 + vyBox * dBoxHeight / 2;
		
		plBox.addVertex(ptA);
		plBox.addVertex(ptB, 1);
		plBox.addVertex(ptC);
		plBox.addVertex(ptD, 1);
		plBox.close();
		
		PLine slotLineHorizontalCenter(vzEl);
		slotLineHorizontalCenter.addVertex(ptOffsetBox - vxBox * 0.5 * dBoxSize);
		slotLineHorizontalCenter.addVertex(ptOffsetBox + vxBox * 0.5 * dBoxSize);
				
		Point3d ptBoxUpper = ptBox + vyBox * 0.25 * dBoxHeight;
		PLine slotLineHorizontalUpper(vzEl);
		slotLineHorizontalUpper.addVertex(ptBoxUpper - vxBox * 0.25 * dBoxSize);
		slotLineHorizontalUpper.addVertex(ptBoxUpper + vxBox * 0.25 * dBoxSize);
		
		Point3d ptBoxLower = ptBox - vyBox * 0.25 * dBoxHeight;
		PLine slotLineHorizontalLower(vzEl);
		slotLineHorizontalLower.addVertex(ptBoxLower - vxBox * 0.25 * dBoxSize);
		slotLineHorizontalLower.addVertex(ptBoxLower + vxBox * 0.25 * dBoxSize);		
		
		PLine slotLineVertical(vzEl);
		slotLineVertical.addVertex(ptBox + vyBox * 0.5 * dBoxHeight);
		slotLineVertical.addVertex(ptBox - vyBox * 0.5 * dBoxHeight);
		
		installationPLines.append(slotLineHorizontalCenter);
		installationPLines.append(slotLineHorizontalUpper);
		installationPLines.append(slotLineHorizontalLower);
		installationPLines.append(slotLineVertical);
		
		//Make diagonall line if the box is at the back of the element.
		if (nSide < 0)
		{
			Point3d ptBackTopLeft = (ptBox + vyBox * 0.5 * dBoxHeight) - (vxBox * 0.5 * dBoxSize);
			Point3d ptBackBottomRight = (ptBox - vyBox * 0.5 * dBoxHeight) + (vxBox * 0.5 * dBoxSize);
			
			PLine lineBoxBackside(vzEl);
			lineBoxBackside.addVertex(ptBackTopLeft);
			lineBoxBackside.addVertex(ptBackBottomRight);
			installationPLines.append(lineBoxBackside);			
		}
	}
	else if (nBoxShape == 3)	
	{
		if (customBlock == "")
		{
			reportMessage(TN("|No custom block specified|"));
			Display dpWarning(1);
			dpWarning.draw(T("|No custom block specified|"), _Pt0, vzEl, vxEl, 1,0 , _kDeviceX);
			return;
		}
		
		Block block(customBlock);
		Entity blockEntities[] = block.entity();
		
		for (int index=0;index<blockEntities.length();index++) 
		{ 
			EntPLine entPline = (EntPLine)blockEntities[index]; 
			if ( ! entPline.bIsValid()) continue;
			
			PLine pline = entPline.getPLine();
			
			plBox = pline;
		}
		
		CoordSys tslCoordsys( _PtG[0], vxEl, vyEl, vzEl);
		plBox.transformBy(tslCoordsys);
		
		plBox.vis(5);
		
		if (abs(plBox.coordSys().vecZ().dotProduct(vzEl)) < 1 -dEps)
		{
			reportMessage(TN("|No custom block specified|"));
			Display dpWarning(1);
			dpWarning.draw(T("|Pline of block not aligned with element|"), _Pt0, vzEl, vxEl, 1,0 , _kDeviceX);
			return;
		}
		breakLoop = true;
	}
	
	if (reverseMillDirection)
	{
		plBox.reverse();
		extraMillPline.reverse();
	}
	
	dpBox.draw(plBox);
	PlaneProfile ppBox(plBox);
	dpBox.draw(ppBox, hatch);
	
	if (bDrawBoxAsBody) {
		Body bdBox(plBox, vzEl * dDepthBox, -nSide);
		dpBox.draw(bdBox);
	}
		
	Map mapObject;
	mapObject.setPoint3d("ptCen", ptBox);
	mapObject.setPLine("plBox", plBox);
	mapElectra.appendMap("Object", mapObject);

	if( bShowShCutOutSheets ){
		if (nBoxShape == 0)
		{
			Drill drill(ptBox + vzEl * nSide * U(500), ptBox - vzEl * nSide * U(10), 0.5 * dBoxSize);
			
			PLine circle;
			circle.createCircle(ptBox, vzEl, 0.5 * dBoxSize);
			circle.transformBy(vzEl * U(500));
			FreeProfile roundedDrill (circle, ptBox);
			// HSB-12951
			roundedDrill.setMachinePathOnly(false);
			for ( int j = 0; j < arSh.length(); j++)
			{
				Sheet sh = arSh[j];
				int zoneNr = sh.myZoneIndex();
				int nZoneIndex = sh.myZoneIndex() * nSide;
				if (nExcludedSheetingZones.find(zoneNr ,- 1) < 0 )
				{
					if ( ! drill.cuttingBody().intersectWith(sh.envelopeBody())) continue;
					{
						if (bUseDrillForCutOutSheets)
						{
							sh.addTool(drill);
						}
						if ( ! bUseDrillForCutOutSheets)
						{
							sh.addTool(roundedDrill);
						}
						if (_Map.getInt("Positive"))
						{
							BeamCut extraCutNeg(ptBox - vxBox * (interDistance * 0.5), vxBox, vyBox, vzEl, interDistance, dBoxHeight, U(1000), 0, 0, 0);
							sh.addTool(extraCutNeg);
						}
						if (_Map.getInt("Negative"))
						{
							BeamCut extraCutPos(ptBox + vxBox * (interDistance * 0.5), vxBox, vyBox, vzEl, interDistance, dBoxHeight, U(1000), 0, 0, 0);
							sh.addTool(extraCutPos);
						}
					}
					
				}
			}
		}
		else if (nBoxShape == 1){
			BeamCut beamCut(ptBox, vxBox, vyBox, vzEl, dBoxSize, dBoxHeight, U(1000), 0, 0, 0);
			for( int j=0;j<arSh.length();j++ ){
				Sheet sh = arSh[j];
				int zoneNr = sh.myZoneIndex();
				int nZoneIndex= sh.myZoneIndex() * nSide;
				if( nZoneIndex > 0 && nExcludedSheetingZones.find(zoneNr,-1) <0 ){
					sh.addTool(beamCut);
					if (_Map.getInt("Positive"))
					{
						BeamCut extraCutNeg(ptBox - vxBox * (interDistance * 0.5), vxBox, vyBox, vzEl, interDistance, dBoxHeight, U(1000), 0, 0, 0);
						sh.addTool(extraCutNeg);
					}
					if (_Map.getInt("Negative"))
					{
						BeamCut extraCutPos(ptBox + vxBox * (interDistance * 0.5), vxBox, vyBox, vzEl, interDistance, dBoxHeight, U(1000), 0, 0, 0);
						sh.addTool(extraCutPos);
					}
				}
			}
		}
		else
		{
			Body profileBody(plBox,vzEl * nSide * U(500));
			profileBody.vis(6);
			Point3d midPt;
			midPt.setToAverage(plBox.vertexPoints(true));
			plBox.transformBy(vzEl * U(500));
//			plBox.vis(1);
			FreeProfile ssSh(plBox, midPt);
			// HSB-12951
			ssSh.setMachinePathOnly(false);
			for( int j=0;j<arSh.length();j++ ){
				Sheet sh = arSh[j];
				int nZoneIndex= sh.myZoneIndex() * nSide;
				int zoneNr = sh.myZoneIndex();				
				if(nExcludedSheetingZones.find(zoneNr,-1) <0 )
				{
					if ( ! profileBody.hasIntersection(sh.envelopeBody())) continue;
					PlaneProfile profSheet = sh.profShape();
					if(profSheet.pointInProfile(midPt) != 1)
					{
						sh.addTool(ssSh);
					}
				}
			}
		}
	}

	Map affectedZones;

	//Mill the sheeting
	if( nToolType > 0){
		double dToolDepth = U(0);
		int nToolZone = nSide;
		for( int j=nSide;abs(j)<6;j=j+nSide )
		{
			int nZoneIndex = j;
			double dDepth = el.zone(nZoneIndex).dH();
		
			if( dDepth == 0 || nExcludedSheetingZones.find(nZoneIndex,-1) >= 0 )
				continue;
			
			affectedZones.appendInt("ZoneIndex", nZoneIndex);
			dToolDepth += dDepth;
			nToolZone = nZoneIndex;
			
			if (bApplyToolingPerZone) { // Each zone has its own tools applied.
				if( nBoxShape == 0 && nToolType == 2 ){
					ElemDrill elDrill(nZoneIndex, ptBox, -vzEl * nSide, dDepth, dBoxSize, nToolIndexDrill);
					elDrill.setVacuum(bApplyVacuumDrill);
					el.addTool(elDrill);
				}
				else
				{
					ElemMill elMill(nZoneIndex, plBox, dDepth, nToolIndexMill, nSideMill, nTurningDirectionMill, bOvershootMill);
					elMill.setVacuum(bApplyVacuumMill);
					el.addTool(elMill);
				}
				
				if (_Map.getInt("Positive"))
				{
					PLine newPlBox = extraMillPline;
					newPlBox.transformBy(- vxBox * (dBoxSize * 0.5));
					ElemMill extraElMillNeg(nZoneIndex, newPlBox, dDepth, nToolIndexMill, nSideMill, nTurningDirectionMill, bOvershootMill);
					el.addTool(extraElMillNeg);
				}
				if (_Map.getInt("Negative"))
				{
					PLine newPlBox = extraMillPline;
					newPlBox.transformBy(vxBox * (dBoxSize * 0.5));
					ElemMill extraElMillPos(nZoneIndex, newPlBox, dDepth, nToolIndexMill, nSideMill, nTurningDirectionMill, bOvershootMill);
					el.addTool(extraElMillPos);
				}
			}
		}
		// Apply the tooling for all the zones at this side at once.
		if (!bApplyToolingPerZone && dToolDepth > 0) {
			if( nBoxShape == 0 && nToolType == 2 ){
				ElemDrill elDrill(nToolZone, ptBox, -vzEl * nSide, dToolDepth, dBoxSize, nToolIndexDrill);
				elDrill.setVacuum(bApplyVacuumDrill);
				el.addTool(elDrill);
			}
			else
			{
				ElemMill elMill(nToolZone, plBox, dToolDepth, nToolIndexMill, nSideMill, nTurningDirectionMill, bOvershootMill);
				elMill.setVacuum(bApplyVacuumMill);
				el.addTool(elMill);
			}
		
			if (_Map.getInt("Positive"))
			{
				PLine newPlBox = extraMillPline;
				newPlBox.transformBy(- vxBox * (dBoxSize * 0.5));
				ElemMill extraElMillNeg(nToolZone, newPlBox, dToolDepth, nToolIndexMill, nSideMill, nTurningDirectionMill, bOvershootMill);
				el.addTool(extraElMillNeg);
			}
			if (_Map.getInt("Negative"))
			{
				PLine newPlBox = extraMillPline;
				newPlBox.transformBy(vxBox * (dBoxSize * 0.5));
				ElemMill extraElMillPos(nToolZone, newPlBox, dToolDepth, nToolIndexMill, nSideMill, nTurningDirectionMill, bOvershootMill);
				el.addTool(extraElMillPos);
			}
		}
	}
	
	if (bApplyBeamCutToBeams)
	{
		double dBoxBodyWidth = dBoxSize;
		if(nBoxShape==3)
		{
			PlaneProfile ppBlock (plBox);
			LineSeg ls = ppBlock.extentInDir(vxEl);
			double widthBlock = abs(vxEl.dotProduct(ls.ptStart() - ls.ptEnd()));
			if(widthBlock > dBoxSize)
			{
				dBoxBodyWidth = widthBlock;
			}
		}
		Body bodyToCheck(ptBox, vxEl, vyEl, vzEl, dBoxBodyWidth, dBoxHeight, dDepthBox, 0, 0, -1 * nSide);
			
		BeamCut beamCut(ptBox, vxEl, vyEl, vzEl, U(1000), dBoxHeight, dDepthBox, 0, 0, -1 * nSide);
		BeamCut beamCutHorizontal(ptBox, vxEl, vyEl, vzEl, dBoxSize, dBoxHeight, dDepthBox, 0, 0, - 1 * nSide);
//		Body bodyToCheck(ptBox, vxBox, vyBox, vzEl, dBoxSize, dBoxHeight, dDepthBox, 0, 0, -1 * nSide);
//		BeamCut beamCut(ptBox, vxBox, vyBox, vzEl, U(1000), dBoxHeight, dDepthBox, 0, 0, -1 * nSide);
		for (int index=0;index<arBm.length();index++) 
		{ 
			Beam beam = arBm[index]; 
			if ( ! beam.envelopeBody().hasIntersection(bodyToCheck)) continue;
			
			if(abs(abs(beam.vecX().dotProduct(el.vecX())) - 1 ) < dEps)
			{
				beam.addTool(beamCutHorizontal);				
			}
			else
			{
				beam.addTool(beamCut);				
			}
		}		
	}
	
	
// HSB-12333
	{ 
	ptBox.vis(4);	
		PlaneProfile pp(CoordSys(ptBox, vxEl, vyEl, vzEl));
		pp.joinRing(plBox, _kAdd);
		LineSeg seg = pp.extentInDir(vxEl);
		Point3d pts[] ={ seg.ptStart(), seg.ptMid(), seg.ptEnd()};
	seg.vis(3);	
		Map m;
		m.setVector3d("vecDimLineDir", vxEl);
		m.setVector3d("vecPerpDimLineDir", vyEl);//t.coordSys().vecY());
		m.setVector3d("AllowedView", vzEl);
		m.setPoint3dArray("Node[]",pts);
		m.setString("Stereotype", _ThisInst.scriptName());
		m.setEntity("ParentEnt", _ThisInst);
		m.setInt("AlsoReverseDirection", true);
		mapRequests.appendMap("DimRequest", m);	
		
		m.setVector3d("vecDimLineDir", vyEl);
		m.setVector3d("vecPerpDimLineDir", - vxEl);
		mapRequests.appendMap("DimRequest", m);	
		
		
	}
	
	
	
	mapDimInfo.setMap("AffectedZoneIndex[]", affectedZones);
	
	if (breakLoop)
	{
		break;
	}
}



Map mapX; 
mapX.setMap("DimRequest[]", mapRequests);
_ThisInst.setSubMapX("Hsb_DimensionInfo", mapX);
reportMessage("\nrequests " + mapRequests.length() + "_" +mapX.length());
_Map.setMap("Electra", mapElectra);
if ((bAddTubeToTop || bAddTubeToBottom) && !_bOnDebug) {
	setExecutionLoops(2);
	if (!bLastExecutionLoop())
		return;
}

// Tubes
String top=T("|Top|"), bottom=T("|Bottom|"), positionKeyName=T("|Position|");
int overideTopTubeProperties=false, overideBottomTubeProperties=false;
Map topTubePropertiesMap, bottomTubePropertiesMap;
// Load latest properties for new tubes and delete previous instances (replace)
for (int i=0;i<_Map.length();i++) 
{
	if (_Map.keyAt(i) == "Tube" && _Map.hasEntity(i)) 
	{
		Entity entTube = _Map.getEntity(i);
		if(entTube.bIsValid())
		{
			TslInst tslTube= (TslInst)entTube;
			Map properties=tslTube.map().getMap("properties");
			Map installationPointSettings=tslTube.map().getMap("installationPointSettings");
			String currentPosition=installationPointSettings.getString(positionKeyName);
			if(currentPosition==top)
			{ 
				_Map.setMap(catalogKeyTopTube,properties);
			}
			else if(currentPosition==bottom)
			{ 
				_Map.setMap(catalogKeyBottomTube,properties);
			}
		}
		
		entTube.dbErase();
		_Map.removeAt(i, true);
		i--;
	}
}

if( _kExecuteKey == recalcTriggers[1] )
{
	reportMessage(T("|Point and linked tubes are removed.|"));
	eraseInstance();
	return;
}

int  arNSideTube[0];
String arSCatTube[0];
String arSPosTube[0];
int arBSetPropsFromMap[0];
Map arMapCatTube[0];
double arDExtendTube[0];
if (bAddTubeToTop) {
	arNSideTube.append(1);
	arSCatTube.append(sCatalogTubeToTop);
	arDExtendTube.append(dExtendTubeAtTop);
	arSPosTube.append(top);
	if (_Map.hasMap(catalogKeyTopTube))
	{
		arBSetPropsFromMap.append(true);
		arMapCatTube.append(_Map.getMap(catalogKeyTopTube));
	}
	else
	{
		arBSetPropsFromMap.append(false);
		arMapCatTube.append(Map());
	}
}
if (bAddTubeToBottom) {
	arNSideTube.append(-1);
	arSCatTube.append(sCatalogTubeToBottom);
	arDExtendTube.append(dExtendTubeAtBottom);
	arSPosTube.append(bottom);
	if (_Map.hasMap(catalogKeyBottomTube))
	{
		arBSetPropsFromMap.append(true);
		arMapCatTube.append(_Map.getMap(catalogKeyBottomTube));
	}
	else
	{
		arBSetPropsFromMap.append(false);
		arMapCatTube.append(Map());
	}
}

if (arNSideTube.length() > 0) {
	String strScriptName = "HSB_E-InstallationTube";
	Vector3d vecUcsX(1, 0, 0);
	Vector3d vecUcsY(0, 1, 0);
	Beam lstBeams[0];
	Entity lstEntities[] = { _ThisInst};
	Point3d lstPoints[2];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	Map mapTsl;
	mapTsl.setInt("OnInsertThroughPoint", true);
	
	Map mapInstallationPointSettings;
	mapInstallationPointSettings.setEntity("InstallationPoint", _ThisInst);
	
	PlaneProfile ppBrutto = el.profBrutto(0);	
	PLine ppRings[] = ppBrutto.allRings();
	PLine outterRing = ppRings[0];
	Point3d arPtOutline[] = el.plEnvelope().intersectPoints(Plane(ptInsertBottom, vxEl));
	if(arPtOutline.length() == 0) //If plEnvelope of element is not valid for some reason, check the profBrutto of zone 0.
	{
		arPtOutline.append(outterRing.intersectPoints(Plane(ptInsertBottom, vxEl)));
	}
	arPtOutline = Line(ptInsertBottom, vyEl).orderPoints(arPtOutline, dEps);
		
	if (arPtOutline.length() > 0) {
		for (int i = 0; i < arNSideTube.length(); i++) {
			int nSideTube = arNSideTube[i];
			String sCatalogTube = arSCatTube[i];
			int setPropsFromMap = arBSetPropsFromMap[i];
			Map mapCatalogTube = arMapCatTube[i];
			double dExtendTube = arDExtendTube[i];
			String sPositionTube = arSPosTube[i];
			
			
			double offset = 0;
			
			if (setPropsFromMap && nAmountOfTubes > 1)
			{
				Map doubleMaps = mapCatalogTube.getMap("PropDouble[]");
				for (int index=0;index<doubleMaps.length();index++) 
				{ 
					Map doubleMap = doubleMaps.getMap(index);
					String test = doubleMap.getString("strName");
					if (doubleMap.getString("strName") != T("|Tube diameter|")) continue;
					offset = doubleMap.getDouble("dValue");
					break;
				}
				
			}
		 	else if (nAmountOfTubes > 1)
			{
				Map doubleMaps = TslInst().mapWithPropValuesFromCatalog(strScriptName, sCatalogTube).getMap("PropDouble[]");
				for (int index=0;index<doubleMaps.length();index++) 
				{ 
					Map doubleMap = doubleMaps.getMap(index);
					String test = doubleMap.getString("strName");
					if (doubleMap.getString("strName") != T("|Tube diameter|")) continue;
					offset = doubleMap.getDouble("dValue");
					break;
				}
			}
			
			for (int index = 0; index < nAmountOfTubes; index++)
			{
				if (index == 1)
				{
					offset *= -1;
				}
				lstPoints[0] = _PtG[0] + vyEl * nSideTube * 0.5 * dBoxSize + vxEl * offset * 0.5;
				if (nSideTube == 1)
				{
					lstPoints[1] = arPtOutline[arPtOutline.length() - 1] + vyEl * dExtendTube + vxEl * offset * 0.5;
					mapInstallationPointSettings.setString("CatalogName", catalogKeyTopTube);
				}
				if (nSideTube == -1)
				{
					lstPoints[1] = arPtOutline[0] - vyEl * dExtendTube + vxEl * offset * 0.5;
					mapInstallationPointSettings.setString("CatalogName", catalogKeyBottomTube);
				}
				mapInstallationPointSettings.setString(positionKeyName, sPositionTube);
				mapTsl.setMap("InstallationPointSettings", mapInstallationPointSettings);
				
				TslInst tsl;
				tsl.dbCreate(strScriptName, vecUcsX, vecUcsY, lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
				if (setPropsFromMap)
				{
					int bCatalogSet = tsl.setPropValuesFromMap(mapCatalogTube);
				}
				else
				{
					int bCatalogSet = tsl.setPropValuesFromCatalog(sCatalogTube);
				}
				tsl.setPropString(14, T("|Based on installation point|"));
				tsl.recalcNow();
				
				_Map.appendEntity("Tube", tsl);
			}
			
			
		}
	}
	else {
		reportWarning(T("\n|Points for tube cannot be found!|"));
	}
}

//Apply no nail area to the zones on the specified side
if( bApplyNoNailArea ){
	double dNoNailW = dBoxSize;
	double dNoNailH = dBoxHeight;
	if( nBoxShape == 0 )
		dNoNailW = dNoNailH;
	dNoNailW += (2 - (nNrOfBoxes - 1)) * dOffsetNoNailArea;
	dNoNailH += 2 * dOffsetNoNailArea;

	PLine plNoNail(vzEl);
	Point3d ptBox = _PtG[0];
	plNoNail.addVertex(ptBox + 0.5 * (vxBox * nNrOfBoxes * dNoNailW + vyBox * dNoNailH));
	plNoNail.addVertex(ptBox + 0.5 * (-vxBox * nNrOfBoxes * dNoNailW + vyBox * dNoNailH));
	plNoNail.addVertex(ptBox + 0.5 * (-vxBox * nNrOfBoxes * dNoNailW - vyBox * dNoNailH));
	plNoNail.addVertex(ptBox + 0.5 * (vxBox * nNrOfBoxes * dNoNailW - vyBox * dNoNailH));
	plNoNail.close();
	
	//Apply no nail zones
	for( int k=nSide;abs(k)<6;k=k+nSide ){
		int nZoneIndex = k;
		double dDepth = el.zone(nZoneIndex).dH();
		
		if( dDepth == 0 )
			continue;

		ElemNoNail elNoNail(nZoneIndex,plNoNail);
		el.addTool(elNoNail);
	}				
}

CoordSys csPlan( ptInsertBottom, -vxEl, vzEl, vyEl );
CoordSys csElevation = csPlan;
csElevation.setToAlignCoordSys( ptInsertBottom, -vxEl, vzEl, vyEl, ptInsert + (vxEl * (nNrOfBoxes/2+1)+vyEl)*dSymbolSize, vxEl, vyEl, vzEl);

// Nogging
if(bCreateNoggin)
{ 
	double nogginW= dNogginW;
	if(dNogginW<=0)
		nogginW = el.dBeamHeight();
	double nogginH= dNogginH;
	if(dNogginH<=0)
		nogginH= el.dBeamWidth();
	
	Point3d ptNogginCenter;
	Vector3d vzAlign;
	int bAtSides=1;
	if(nAlignment==0)//Front
		{
			ptNogginCenter= ptEl;
			vzAlign= -vzEl;
		}
	else if(nAlignment==2)//Back
		{		
			ptNogginCenter= ptBack;
			vzAlign= vzEl;
		}
	else//Center (default)
		{
			ptNogginCenter= ptEl-vzEl*dElWidth*.5;
			vzAlign= vzEl;
			bAtSides=0;
		}

	ptNogginCenter+= vxEl*vxEl.dotProduct(_Pt0-ptNogginCenter)+vyEl*dElevation+vzAlign*((nogginW*.5)*bAtSides+dDepthOffset);

	// Search studs to stretch noggin
	Beam bmAtLeft, bmAtRight, bmTmp[0];
	bmTmp= Beam().filterBeamsHalfLineIntersectSort(arBm, ptNogginCenter, -vxEl);
	if(bmTmp.length()>0)
		bmAtLeft= bmTmp[0];
	bmTmp= Beam().filterBeamsHalfLineIntersectSort(arBm, ptNogginCenter, vxEl);
	if(bmTmp.length()>0)
		bmAtRight= bmTmp[0];
	if(!bmAtLeft.bIsValid() || !bmAtRight.bIsValid())
	{
		reportMessage("\n" + scriptName() + ": " +T("|ERROR: Could not find studs for noggin stretching|"));
	}
	else
	{
		Beam bmNoggin; bmNoggin.dbCreate(ptNogginCenter, vxEl, vzEl, vxEl.crossProduct(vzEl), U(50), nogginW, nogginH, 0,0,0);		
		bmNoggin.setColor(32);
		bmNoggin.setType(_kBlocking);
		bmNoggin.setName(sNogginName);
		bmNoggin.setMaterial(sNogginMaterial);
		bmNoggin.setGrade(sNogginGrade);
		bmNoggin.setInformation(sNogginInformation);
		bmNoggin.setLabel(sNogginLabel);
		bmNoggin.setBeamCode(sNogginBeamCode);
		bmNoggin.assignToElementGroup(el, true, 0, 'Z');
		
		Entity entStretch1= bmNoggin.stretchDynamicTo(bmAtLeft);
		if(entStretch1.bIsValid())
			entStretch1.assignToElementGroup(el, true, 0, 'Z');
		Entity entStretch2= bmNoggin.stretchDynamicTo(bmAtRight);
		if(entStretch2.bIsValid())
			entStretch2.assignToElementGroup(el, true, 0, 'Z');

		_Map.appendEntity("EntityToDelete", bmNoggin);
	}
}

//Draw symbol
String arSDefaultObject[] = {
	T("Water"),
	T("Ground"),
	T("Additional open"),
	T("Additional closed")	
};
double dOutlineWall = el.dPosZOutlineFront();
if( nSide == -1 ){
	dOutlineWall = abs(el.dPosZOutlineBack()) - el.zone(0).dH();
}

////dxf output
//PLine installationPLines[0];

Point3d symbolLocations[] = 
{
	ptInsertBottom
};

if (numberOfSymbolsPerBox > 1)
{
	double symbolSpacing = dBoxSize / numberOfSymbolsPerBox;
	
	int nrOfSymbols = numberOfSymbolsPerBox;
	if (( nrOfSymbols % 2) == 0)
	{
		symbolLocations.setLength(0);
		for (int i=0;i<int(numberOfSymbolsPerBox/2.0);i++)
		{
			symbolLocations.append(ptInsertBottom + vxBox * (i + .5) * symbolSpacing);
			symbolLocations.append(ptInsertBottom - vxBox * (i + .5) * symbolSpacing);
		}
	}
	else
	{
		for (int i=1;i<ceil(numberOfSymbolsPerBox/2.0);i++)
		{
			symbolLocations.append(ptInsertBottom + vxBox * i * symbolSpacing);
			symbolLocations.append(ptInsertBottom - vxBox * i * symbolSpacing);
		}
	}
}
for (int s = 0; s < symbolLocations.length(); s++)
{
	Point3d symbolLocation = symbolLocations[s];
	
	if ( sObject == T("Outlet") )
	{
		Point3d ptSymbol = symbolLocation + vzEl * dOutlineWall * nSide * nArrowFlipped;
		Point3d ptA = ptSymbol + vzEl * 2.5 * dSymbolSize * nSide * nArrowFlipped;
		Point3d ptB = ptA - vxEl * dSymbolSize;
		Point3d ptC = ptA + vxEl * dSymbolSize;
		Point3d ptD = ptB + vzEl * dSymbolSize * nSide * nArrowFlipped;
		Point3d ptE = ptC + vzEl * dSymbolSize * nSide * nArrowFlipped;
		
		
		PLine plA(ptSymbol, ptA);
		PLine plB(ptB, ptC);
		PLine plC(vyEl);
		plC.addVertex(ptD);
		plC.addVertex(ptE, dSymbolSize, nCWise);
		
		dpSymbol.draw(plA);
		dpSymbol.draw(plB);
		dpSymbol.draw(plC);
		
		if ( bShowSymbolInElevation )
		{
			plA.transformBy(csElevation);
			plB.transformBy(csElevation);
			plC.transformBy(csElevation);
			dpSymbolElevation.draw(plA);
			dpSymbolElevation.draw(plB);
			dpSymbolElevation.draw(plC);
		}
	}
	else if ( sObject == T("Double outlet") )
	{
		Point3d ptSymbol = symbolLocation + vzEl * dOutlineWall * nSide * nArrowFlipped;
		Point3d ptA = ptSymbol + vzEl * 2.5 * dSymbolSize * nSide * nArrowFlipped;
		Point3d ptB = ptA - vxEl * dSymbolSize;
		Point3d ptC = ptA + vxEl * dSymbolSize;
		Point3d ptD = ptB + vzEl * dSymbolSize * nSide * nArrowFlipped;
		Point3d ptE = ptC + vzEl * dSymbolSize * nSide * nArrowFlipped;
		Point3d ptF = ptD + vzEl * dSymbolSize * nSide * nArrowFlipped;
		Point3d ptG = ptE + vzEl * dSymbolSize * nSide * nArrowFlipped;
		
		PLine plA(ptSymbol, ptA);
		PLine plB(ptB, ptC);
		PLine plC(vyEl);
		plC.addVertex(ptD);
		plC.addVertex(ptE, dSymbolSize, nCWise);
		PLine plD(vyEl);
		plD.addVertex(ptF);
		plD.addVertex(ptG, dSymbolSize, nCWise);
		
		dpSymbol.draw(plA);
		dpSymbol.draw(plB);
		dpSymbol.draw(plC);
		dpSymbol.draw(plD);
		
		if ( bShowSymbolInElevation )
		{
			plA.transformBy(csElevation);
			plB.transformBy(csElevation);
			plC.transformBy(csElevation);
			plD.transformBy(csElevation);
			dpSymbolElevation.draw(plA);
			dpSymbolElevation.draw(plB);
			dpSymbolElevation.draw(plC);
			dpSymbolElevation.draw(plD);
		}
	}
	else if ( sObject == T("Switch") )
	{
		Point3d ptSymbol = symbolLocation + vzEl * (dOutlineWall + dSymbolSize) * nSide * nArrowFlipped;
		Point3d ptA = ptSymbol + vzEl * dSymbolSize * nSide * nArrowFlipped;
		Point3d ptB = ptA + (vzEl * 2 + vxEl * 0.5) * dSymbolSize * nSide * nArrowFlipped;
		Point3d ptC = ptB - (vzEl * 0.25 - vxEl) * dSymbolSize * nSide * nArrowFlipped;
		
		PLine plA(vyEl);
		plA.createCircle(ptSymbol, vyEl, dSymbolSize);
		PLine plB(ptA, ptB);
		plB.addVertex(ptC);
		
		dpSymbol.draw(plA);
		dpSymbol.draw(plB);
		
		if ( bShowSymbolInElevation )
		{
			plA.transformBy(csElevation);
			plB.transformBy(csElevation);
			dpSymbolElevation.draw(plA);
			dpSymbolElevation.draw(plB);
		}
	}
	else if ( sObject == T("Double switch") )
	{
		Point3d ptSymbol = symbolLocation + vzEl * (dOutlineWall + dSymbolSize) * nSide * nArrowFlipped;
		Point3d ptA = ptSymbol + vzEl * dSymbolSize * nSide * nArrowFlipped;
		Point3d ptB = ptA + (vzEl * 2 + vxEl * 0.5) * dSymbolSize * nSide * nArrowFlipped;
		Point3d ptC = ptB - (vzEl * 0.25 - vxEl) * dSymbolSize * nSide * nArrowFlipped;
		Point3d ptD = ptA + (vzEl * 2 - vxEl * 0.5) * dSymbolSize * nSide * nArrowFlipped;
		Point3d ptE = ptD - (vzEl * 0.25 + vxEl) * dSymbolSize * nSide * nArrowFlipped;
		
		PLine plA(vyEl);
		plA.createCircle(ptSymbol, vyEl, dSymbolSize);
		PLine plB(ptC, ptB, ptA, ptD);
		plB.addVertex(ptE);
		
		dpSymbol.draw(plA);
		dpSymbol.draw(plB);
		
		if ( bShowSymbolInElevation )
		{
			plA.transformBy(csElevation);
			plB.transformBy(csElevation);
			dpSymbolElevation.draw(plA);
			dpSymbolElevation.draw(plB);
		}
		
	}
	else if ( sObject == T("Double-pole switch") )
	{
		Point3d ptSymbol = symbolLocation + vzEl * (dOutlineWall + dSymbolSize) * nSide * nArrowFlipped;
		Point3d ptA = ptSymbol + vzEl * dSymbolSize * nSide * nArrowFlipped;
		Point3d ptB = ptA + (vzEl * 2 + vxEl * 0.5) * dSymbolSize * nSide * nArrowFlipped;
		Point3d ptC = ptB - (vzEl * 0.25 - vxEl) * dSymbolSize * nSide * nArrowFlipped;
		Point3d ptD = ptSymbol - vzEl * dSymbolSize * nSide * nArrowFlipped;
		Point3d ptE = ptD - (vzEl * 2 + vxEl * 0.5) * dSymbolSize * nSide * nArrowFlipped;
		Point3d ptF = ptE + (vzEl * 0.25 - vxEl) * dSymbolSize * nSide * nArrowFlipped;
		
		PLine plA(vyEl);
		plA.createCircle(ptSymbol, vyEl, dSymbolSize);
		PLine plB(ptA, ptB);
		plB.addVertex(ptC);
		PLine plC(ptD, ptE);
		plC.addVertex(ptF);
		
		dpSymbol.draw(plA);
		dpSymbol.draw(plB);
		dpSymbol.draw(plC);
		
		if ( bShowSymbolInElevation )
		{
			plA.transformBy(csElevation);
			plB.transformBy(csElevation);
			plC.transformBy(csElevation);
			dpSymbolElevation.draw(plA);
			dpSymbolElevation.draw(plB);
			dpSymbolElevation.draw(plC);
		}
		
	}
	else if ( sObject == T("Pull switch") )
	{
		Point3d ptSymbol = symbolLocation + vzEl * (dOutlineWall + dSymbolSize) * nSide * nArrowFlipped;
		Point3d ptA = ptSymbol + vzEl * dSymbolSize * nSide * nArrowFlipped;
		Point3d ptB = ptA + (vzEl * 2 + vxEl * 0.5) * dSymbolSize * nSide * nArrowFlipped;
		Point3d ptC = ptB - (vzEl * 0.25 - vxEl) * dSymbolSize * nSide * nArrowFlipped;
		Point3d ptD = ptA + (vxEl + vzEl * 0.5) * dSymbolSize * nSide * nArrowFlipped;
		Point3d ptE = ptA + (vxEl * 1.25 + vzEl * 0.25) * dSymbolSize * nSide * nArrowFlipped;
		Point3d ptF = ptA + (vxEl * 0.75 + vzEl * 0.25) * dSymbolSize * nSide * nArrowFlipped;
		
		PLine plA(vyEl);
		plA.createCircle(ptSymbol, vyEl, dSymbolSize);
		PLine plB(ptA, ptB);
		plB.addVertex(ptC);
		PLine plC(ptB, ptD);
		PLine plD(ptE, ptD);
		plD.addVertex(ptF);
		
		dpSymbol.draw(plA);
		dpSymbol.draw(plB);
		dpSymbol.draw(plC);
		dpSymbol.draw(plD);
		
		if ( bShowSymbolInElevation )
		{
			plA.transformBy(csElevation);
			plB.transformBy(csElevation);
			plC.transformBy(csElevation);
			plD.transformBy(csElevation);
			dpSymbolElevation.draw(plA);
			dpSymbolElevation.draw(plB);
			dpSymbolElevation.draw(plC);
			dpSymbolElevation.draw(plD);
		}
	}
	else if ( sObject == T("Double-pole pull switch") )
	{
		Point3d ptSymbol = symbolLocation + vzEl * (dOutlineWall + dSymbolSize) * nSide * nArrowFlipped;
		Point3d ptA = ptSymbol + vzEl * dSymbolSize * nSide * nArrowFlipped;
		Point3d ptB = ptA + (vzEl * 2 + vxEl * 0.5) * dSymbolSize * nSide * nArrowFlipped;
		Point3d ptC = ptB - (vzEl * 0.25 - vxEl) * dSymbolSize * nSide * nArrowFlipped;
		Point3d ptD = ptSymbol - vzEl * dSymbolSize * nSide * nArrowFlipped;
		Point3d ptE = ptD - (vzEl * 2 + vxEl * 0.5) * dSymbolSize * nSide * nArrowFlipped;
		Point3d ptF = ptE + (vzEl * 0.25 - vxEl) * dSymbolSize * nSide * nArrowFlipped;
		Point3d ptG = ptA + (vxEl + vzEl * 0.5) * dSymbolSize * nSide * nArrowFlipped;
		Point3d ptH = ptA + (vxEl * 1.25 + vzEl * 0.25) * dSymbolSize * nSide * nArrowFlipped;
		Point3d ptI = ptA + (vxEl * 0.75 + vzEl * 0.25) * dSymbolSize * nSide * nArrowFlipped;
		
		PLine plA(vyEl);
		plA.createCircle(ptSymbol, vyEl, dSymbolSize);
		PLine plB(ptA, ptB);
		plB.addVertex(ptC);
		PLine plC(ptD, ptE);
		plC.addVertex(ptF);
		PLine plD(ptB, ptG);
		PLine plE(ptH, ptG);
		plE.addVertex(ptI);
		
		dpSymbol.draw(plA);
		dpSymbol.draw(plB);
		dpSymbol.draw(plC);
		dpSymbol.draw(plD);
		dpSymbol.draw(plE);
		
		if ( bShowSymbolInElevation )
		{
			plA.transformBy(csElevation);
			plB.transformBy(csElevation);
			plC.transformBy(csElevation);
			plD.transformBy(csElevation);
			plE.transformBy(csElevation);
			dpSymbolElevation.draw(plA);
			dpSymbolElevation.draw(plB);
			dpSymbolElevation.draw(plC);
			dpSymbolElevation.draw(plD);
			dpSymbolElevation.draw(plE);
		}
		
	}
	else if ( sObject == T("Light connection") )
	{
		Point3d ptSymbol = symbolLocation + vzEl * dOutlineWall * nSide * nArrowFlipped;
		Point3d ptA = ptSymbol + vzEl * 3.5 * dSymbolSize * nSide * nArrowFlipped;
		Point3d ptB = ptA - (vxEl - vzEl) * dSymbolSize * nSide * nArrowFlipped;
		Point3d ptC = ptA + (vxEl - vzEl) * dSymbolSize * nSide * nArrowFlipped;
		Point3d ptD = ptA + (vxEl + vzEl) * dSymbolSize * nSide * nArrowFlipped;
		Point3d ptE = ptA - (vxEl + vzEl) * dSymbolSize * nSide * nArrowFlipped;
		
		PLine plA(ptSymbol, ptA);
		PLine plB(ptB, ptC);
		PLine plC(ptD, ptE);
		
		dpSymbol.draw(plA);
		dpSymbol.draw(plB);
		dpSymbol.draw(plC);
		
		if ( bShowSymbolInElevation )
		{
			plA.transformBy(csElevation);
			plB.transformBy(csElevation);
			plC.transformBy(csElevation);
			dpSymbolElevation.draw(plA);
			dpSymbolElevation.draw(plB);
			dpSymbolElevation.draw(plC);
		}
	}
	else if ( arSDefaultObject.find(sObject) != -1 )
	{
		Point3d ptSymbol = symbolLocation + vzEl * dOutlineWall * nSide * nArrowFlipped;
		Point3d ptA = ptSymbol + vzEl * 2.5 * dSymbolSize * nSide * nArrowFlipped;
		Point3d ptB = ptA + vzEl * dSymbolSize * nSide * nArrowFlipped;
		
		PLine plA(ptSymbol, ptA);
		PLine plB(vyEl);
		plB.createCircle(ptB, vyEl, dSymbolSize);
		
		dpSymbol.draw(plA);
		dpSymbol.draw(plB);
		String sCharacter;
		if ( sObject == T("Water") ) {
			sCharacter = "W";
		}
		else if ( sObject == T("Ground") ) {
			sCharacter = "A";
		}
		else {
			sCharacter = "";
		}
		dpSymbol.draw(sCharacter, ptB, vzEl * nSide * nArrowFlipped, vxEl * nSide * nArrowFlipped, 0, 0);
		
		if ( bShowSymbolInElevation ) {
			plA.transformBy(csElevation);
			plB.transformBy(csElevation);
			dpSymbolElevation.draw(plA);
			dpSymbolElevation.draw(plB);
			
			Point3d ptBTransformed = ptB;
			ptBTransformed.transformBy(csElevation);
			dpSymbolElevation.draw(sCharacter, ptBTransformed, vxEl, vyEl, 0, 0);
		}
	}
}


if( sOverruleDescription != "" ){
	sDescription = sOverruleDescription;
}
Point3d ptText = ptInsertBottom + vzEl * (dOutlineWall + 5 * dSymbolSize) * nSide * nArrowFlipped;
String sHeight;
sHeight.formatUnit(dHeight, 2, 0);
String sText = sDescription + " " + sHeight;
dpSymbol.draw(sText, ptText, vzEl * nSide * nArrowFlipped, vxEl * nSide * nArrowFlipped, 1,0 , _kDeviceX);

if(bShowHeightInFrontView)
{
	Point3d outletCenter = _Pt0 + vyEl * dHeight;
	Point3d textPoint = outletCenter + vyEl * dBoxSize + vxEl * (dBoxSize * 0.5);
	
	PLine referenceLine (outletCenter, textPoint);
	
	Display dpHeightFrontView(nSymbolColor);
	dpHeightFrontView.showInDxa(true);
	dpHeightFrontView.textHeight(textSize);
	dpHeightFrontView.elemZone(el, nSide, 'I');
	//dpHeightFrontView.addHideDirection(vzEl);
	dpHeightFrontView.addHideDirection(vyEl);
	
	dpHeightFrontView.draw(sHeight, textPoint, vzEl * nSide * nArrowFlipped, vxEl * nSide * nArrowFlipped, 1,0 , _kDeviceX);
	dpHeightFrontView.draw(referenceLine);
}



int nYOffset = 2;
if( bShowSymbolInElevation && nSide == 1 )
	nYOffset = 5;

if( bShowDescriptionInElevation ){
	ptText = ptInsert + vzEl * dOutlineWall * nSide * nArrowFlipped + (vxEl * (nNrOfBoxes/2+1)+nYOffset*vyEl)*dSymbolSize;
	dpSymbolElevation.draw(sDescription, ptText, vyEl, -nSide * vxEl, 1, 0, _kDevice);
}

// change color of _ThisInst to support color based filtering of potential dimension tsl's
int nInstColor = arNColor[0];
if (nSide!=1)nInstColor = arNColor[1];
if (_ThisInst.color()!=nInstColor)	_ThisInst.setColor(nInstColor);



Map dxfOutput;
for (int p=0;p<installationPLines.length();p++)
{
	PLine pline = installationPLines[p];
	
	Map dxfPLineDisplay;
	dxfPLineDisplay.setPLine(dxfPathKey, pline);
	dxfPLineDisplay.setString(dxfLayerKey, installationDxfLayer);
	dxfPLineDisplay.setInt(dxfColorKey, installationDxfColor);
	
	dxfOutput.appendMap(dxfPLineDisplayKey, dxfPLineDisplay);
}
_Map.setMap(dxfOutputKey, dxfOutput);



_Map.setMap("DimInfo", mapDimInfo);













#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`$L`9`#`2(``A$!`Q$!_\0`
M'P```04!`0$!`0$```````````$"`P0%!@<("0H+_\0`M1```@$#`P($`P4%
M!`0```%]`0(#``01!1(A,4$&$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*
M%A<8&1HE)B<H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&EJ<W1U
M=G=X>7J#A(6&AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&
MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ>KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!
M`0$!`0````````$"`P0%!@<("0H+_\0`M1$``@$"!`0#!`<%!`0``0)W``$"
M`Q$$!2$Q!A)!40=A<1,B,H$(%$*1H;'!"2,S4O`58G+1"A8D-.$E\1<8&1HF
M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@H.$
MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#+KO\`X??\
M@>]_Z_#_`.BXZX"N_P#A]_R![W_K\/\`Z+CK/&?PCIGL=;1117CF04444`%%
M%%`!1110`4444`%<0_\`R,6O?]?B?^DT-=O7$/\`\C%KW_7XG_I-#2G\#-\/
M\90\1?\`(%E_ZZ1?^C%KF:Z;Q%_R!9?^ND7_`*,6N9KTLL_A/U-JWQ!1117H
MF05U'@/_`)#LW_7LW_H2UR]=1X#_`.0[-_U[-_Z$M88G^$R9['HE%%%>(8A1
M110`4444`%%%%`!1110!YIX]_P"1G7_KRC_]#DK8^&W_`"!]1_Z_S_Z*BK'\
M>_\`(SK_`->4?_H<E;'PV_Y`^H_]?Y_]%15[&)_W*!RQ_CL[.BBBO'.H****
M8S@=*_Y!D/X_S-4/$?\`J;;_`*Z'^57]*_Y!D/X_S-4/$?\`J;;_`*Z'^5+#
M_P"\KU/0?\,P****^B.8****`.[^'_\`QYWW_71?Y5V-<=\/_P#CSOO^NB_R
MKL:\3$_Q68/<****P$%%%%`!3D_UB_6FTY/]8OU%-;@>(UW_`,/O^0/>_P#7
MX?\`T7'7`5W_`,/O^0/>_P#7X?\`T7'7KXS^$:SV.MHHHKQS(****`"BBB@`
MHHHH`****`"N(?\`Y&+7O^OQ/_2:&NWKB'_Y&+7O^OQ/_2:&E/X&;X?XRAXB
M_P"0++_UTB_]&+7,UTWB+_D"R_\`72+_`-&+7,UZ66?PGZFU;X@HHHKT3(*Z
MCP'_`,AV;_KV;_T):Y>NH\!_\AV;_KV;_P!"6L,3_"9,]CT2BBBO$,0HHHH`
M****`"BBB@`HHHH`\T\>_P#(SK_UY1_^AR5L?#;_`)`^H_\`7^?_`$5%6/X]
M_P"1G7_KRC_]#DK8^&W_`"!]1_Z_S_Z*BKV,3_N4#EC_`!V=G1117CG4%%%%
M,9P.E?\`(,A_'^9JAXC_`-3;?]=#_*K^E?\`(,A_'^9JAXC_`-3;?]=#_*EA
M_P#>5ZGH/^&8%%%%?1',%%%%`'=_#_\`X\[[_KHO\J[&N.^'_P#QYWW_`%T7
M^5=C7B8G^*S![A1116`@HHHH`*<G^L7ZTVG)_K%^M-;@>(UW_P`/O^0/>_\`
M7X?_`$7'7`5W_P`/O^0/>_\`7X?_`$7'7KXS^$:SV.MHHHKQS(****`"BBB@
M`HHHH`****`"N(?_`)&+7O\`K\3_`-)H:[>N(?\`Y&+7O^OQ/_2:&E/X&;X?
MXRAXB_Y`LO\`UTB_]&+7,UTWB+_D"R_]=(O_`$8M<S7I99_"?J;5OB"BBBO1
M,@KJ/`?_`"'9O^O9O_0EKEZZCP'_`,AV;_KV;_T):PQ/\)DSV/1****\0Q"B
MBB@`HHHH`****`"BBB@#S3Q[_P`C.O\`UY1_^AR5L?#;_D#ZC_U_G_T5%6/X
M]_Y&=?\`KRC_`/0Y*V/AM_R!]1_Z_P`_^BHJ]C$_[E`Y8_QV=G1117CG4%%%
M%,#@=*_Y!D/X_P`S5#Q'_J;;_KH?Y5?TK_D&0_C_`#-4/$?^IMO^NA_E2P_^
M\KU/1?\`#,"BBBOHCF"BBB@#N_A__P`>=]_UT7^5=C7'?#__`(\[[_KHO\J[
M&O$Q/\5F#W"BBBL!!1110`4Y/]8OUIM.3_6+]136X'B-=_\`#[_D#WO_`%^'
M_P!%QUP%=_\`#[_D#WO_`%^'_P!%QUZ^,_A&L]CK:***\<R"BBB@`HHHH`**
M**`"BBB@`KB'_P"1BU[_`*_$_P#2:&NWKB'_`.1BU[_K\3_TFAI3^!F^'^,H
M>(O^0++_`-=(O_1BUS-=-XB_Y`LO_72+_P!&+7,UZ66?PGZFU;X@HHHKT3(*
MZCP'_P`AV;_KV;_T):Y>NH\!_P#(=F_Z]F_]"6L,3_"9,]CT2BBBO$,0HHHH
M`****`"BBB@`HHHH`\T\>_\`(SK_`->4?_H<E;'PV_Y`^H_]?Y_]%15C^/?^
M1G7_`*\H_P#T.2MCX;?\@?4?^O\`/_HJ*O8Q/^Y0.6/\=G9T445XYU!1113&
M<#I7_(,A_'^9JAXC_P!3;?\`70_RJ_I7_(,A_'^9JAXC_P!3;?\`70_RI8?_
M`'E>IZ#_`(9@4445]$<P4444`=W\/_\`CSOO^NB_RKL:X[X?_P#'G??]=%_E
M78UXF)_BLP>X4445@(****`"G)_K%^HIM.3_`%B_6FMP/$:[_P"'W_('O?\`
MK\/_`*+CK@*[_P"'W_('O?\`K\/_`*+CKU\9_"-9['6T445XYD%%%%`!1110
M`4444`%%%%`!7$/_`,C%KW_7XG_I-#7;UQ#_`/(Q:]_U^)_Z30TI_`S?#_&4
M/$7_`"!9?^ND7_HQ:YFNF\1?\@67_KI%_P"C%KF:]++/X3]3:M\04445Z)D%
M=1X#_P"0[-_U[-_Z$M<O74>`_P#D.S?]>S?^A+6&)_A,F>QZ)1117B&(4444
M`%%%%`!1110`4444`>:>/?\`D9U_Z\H__0Y*V/AM_P`@?4?^O\_^BHJQ_'O_
M`",Z_P#7E'_Z')6Q\-O^0/J/_7^?_145>QB?]R@<L?X[.SHHHKQSJ"BBB@#@
M=*_Y!D/X_P`S5#Q'_J;;_KH?Y5?TK_D&0_C_`#-4/$?^IMO^NA_E1A_]Y7J>
MB_X9@4445]$<P4444`=W\/\`_CSOO^NB_P`J[&N.^'__`!YWW_71?Y5V->)B
M?XK,'N%%%%8""BBB@`IR?ZQ?K3:<G^L7ZTUN!XC7?_#[_D#WO_7X?_1<=<!7
M?_#[_D#WO_7X?_1<=>OC/X1K/8ZVBBBO',@HHHH`****`"BBB@`HHHH`*XA_
M^1BU[_K\3_TFAKMZXA_^1BU[_K\3_P!)H:4_@9OA_C*'B+_D"R_]=(O_`$8M
M<S73>(O^0++_`-=(O_1BUS->EEG\)^IM6^(****]$R"NH\!_\AV;_KV;_P!"
M6N7KJ/`?_(=F_P"O9O\`T):PQ/\`"9,]CT2BBBO$,0HHHH`****`"BBB@`HH
MHH`\T\>_\C.O_7E'_P"AR5L?#;_D#ZC_`-?Y_P#1458_CW_D9U_Z\H__`$.2
MMCX;?\@?4?\`K_/_`**BKV,3_N4#EC_'9V=%%%>.=04444QG`Z5_R#(?Q_F:
MH>(_]3;?]=#_`"J_I7_(,A_'^9JAXC_U-M_UT/\`*EA_]Y7J>@_X9@4445]$
M<P4444`=W\/_`/CSOO\`KHO\J[&N.^'_`/QYWW_71?Y5V->)B?XK,'N%%%%8
M""BBB@`IR?ZQ?J*;3D_UB_44UN!XC7?_``^_Y`][_P!?A_\`1<=<!7?_``^_
MY`][_P!?A_\`1<=>OC/X1K/8ZVBBBO',@HHHH`****`"BBB@`HHHH`*XA_\`
MD8M>_P"OQ/\`TFAKMZXA_P#D8M>_Z_$_])H:4_@9OA_C*'B+_D"R_P#72+_T
M8M<S73>(O^0++_UTB_\`1BUS->EEG\)^IM6^(****]$R"NH\!_\`(=F_Z]F_
M]"6N7KJ/`?\`R'9O^O9O_0EK#$_PF3/8]$HHHKQ#$****`"BBB@`HHHH`***
M*`/-/'O_`",Z_P#7E'_Z')6Q\-O^0/J/_7^?_1458_CS_D9U_P"O*/\`]#DK
M8^&W_(&U'_K_`#_Z*BKV,3_N4#EC_'9V=%%%>.=04444P.!TK_D&0_C_`#-4
M/$?^IMO^NA_E5_2O^09#^/\`,U0\1_ZFV_ZZ'^5+#_[RO4]%_P`,P****^B.
M8****`.[^'__`!YWW_71?Y5V-<=\/_\`CSOO^NB_RKL:\3$_Q68/<****P$%
M%%%`!3D_UB_44VG)_K%^M-;@>(UW_P`/O^0/>_\`7X?_`$7'7`5W_P`/O^0/
M>_\`7X?_`$7'7KXS^$:SV.MHHHKQS(****`"BBB@`HHHH`****`"N(?_`)&+
M7O\`K\3_`-)H:[>N(?\`Y&+7O^OQ/_2:&E/X&;X?XRAXB_Y`LO\`UTB_]&+7
M,UTWB+_D"R_]=(O_`$8M<S7I99_"?J;5OB"BBBO1,@KJ/`?_`"'9O^O9O_0E
MKEZZCP'_`,AV;_KV;_T):PQ/\)DSV/1****\0Q"BBB@`HHHH`****`"BBB@#
MS3QY_P`C.O\`UY1_^AR5L?#;_D#:C_U_G_T5%6/X\_Y&=?\`KRC_`/0Y*V/A
MM_R!M1_Z_P`_^BHJ]C$_[E`Y8_QV=G1117CG4%%%%,#@=*_Y!D/X_P`S5#Q'
M_J;;_KH?Y5?TK_D&0_C_`#-4/$?^IMO^NA_E2P_^\KU/1?\`#,"BBBOHCF"B
MBB@#N_A__P`>=]_UT7^5=C7'?#__`(\[[_KHO\J[&O$Q/\5F#W"BBBL!!111
M0`4Y/]8OUIM.3_6+]136X'B-=_\`#[_D#WO_`%^'_P!%QUP%=_\`#[_D#WO_
M`%^'_P!%QUZ^,_A&L]CK:***\<R"BBB@`HHHH`****`"BBB@`KB'_P"1BU[_
M`*_$_P#2:&NWKB'_`.1BU[_K\3_TFAI3^!F^'^,H>(O^0++_`-=(O_1BUS-=
M-XB_Y`LO_72+_P!&+7,UZ66?PGZFU;X@HHHKT3(*ZCP'_P`AV;_KV;_T):Y>
MNH\!_P#(=F_Z]F_]"6L,3_"9,]CT2BBBO$,0HJ&ZN[>QMVN+J9(85ZNYP!7(
M77Q*TJ-V6U@GGPV-Q&Q3SU!/45O2PU6M_#BV)R2W.UHKS.[\<ZO<@B`06RYX
M*KO)'XUBRZKJDTOF2:G=EO\`KI@?2NV&4UY?%H8O$01[-17F>A>-+K3[B.'5
MKGS;`C:9G'SQGL2>X]:[*]\6:+8[@]XLC@9V1#<QXSQ7+5PE6G/D:N:1J1DK
MHVJ*Y2'X@Z-).J2+<P(QP))(L*/KZ5T\,T5Q"DT,BR1.,JZG(-8SI3I_$K%*
M2>QYQX\_Y&=?^O*/_P!#DK8^&W_(&U'_`*_S_P"BHJQ_'G_(SK_UY1_^AR5L
M?#;_`)`VH_\`7^?_`$5%7J8G_<H'-'^.SLZ***\<Z@HHHIC.!TK_`)!D/X_S
M-4/$?^IMO^NA_E5_2O\`D&0_C_,U0\1_ZFV_ZZ'^5+#_`.\KU/0?\,P****^
MB.8****`.[^'_P#QYWW_`%T7^5=C7'?#_P#X\[[_`*Z+_*NQKQ,3_%9@]PHH
MHK`04444`%.3_6+]13:<G^L7ZTUN!XB3@9-=WX`GA32KM&E16:[)4%@"1Y:5
MCPZ59PD$1;V'\3G)JT(8E^[&HQTP,5UU\9&I'E2.QT&UN=_17"1O-!_J;B:/
MG)VN>:NQ:UJ,7_+5)0!PKK_,BN.Z,WAY+8ZZBN=B\2R#`GM`3W:-N!^!JY%X
MCT^3[[O#V_>(1FG8R=.2W1K45#%=VTQQ'/&Q/8,,U-02%%%%(04444`%<0__
M`",6O?\`7XG_`*30UV]<0_\`R,6O?]?B?^DT-*?P,WP_QE#Q%_R!9?\`KI%_
MZ,6N9KIO$7_(%E_ZZ1?^C%KF:]++/X3]3:M\04445Z)D%=1X#_Y#LW_7LW_H
M2UR]=1X#_P"0[-_U[-_Z$M88G^$R9['HE%%%>(8GDOC;56U/Q'/;9/V:Q'E(
MN>"Y`+-_(?@:Y[@L@(R-O3\ZMZQ&\7B'6$<DN+N5CGT9MP_1A54<F/Z'^M?H
M.`IQAAX*/8\^HVY,;$X@X9_W;$XR>AZ_E48>XO-I23R(FY7`RS#U]JKZD1_9
MG0']XO![_,M7@,%0.FT_UK9T8N7,9V6Y71%A`DF4S<X9V'('TZ5H#:%&W&.V
M*K?\LT`ZY/\`2E@8K)+%G.UMP]@2>/S!K&O245S10I/0LYKI/!.MOI^JQ:4Y
M_P!"NBPC!_Y9R]>/8X/XX]:Y/[3#G'F`8]>*22[6#;.C`M"ZR+@]2I!`_2O(
MQ2C5IN+"E4E&:.O\>?\`(SK_`->4?_H<E;'PV_Y`VH_]?Y_]%15C^/?^1G7_
M`*\H_P#T.2MCX;?\@;4?^O\`/_HJ*O-Q/^Y0.N'\=G9T445XYU!1113`X'2O
M^09#^/\`,U0\1_ZFV_ZZ'^57]*_Y!D/X_P`S5#Q'_J;;_KH?Y4L/_O*]3T7_
M``S`HHHKZ(Y@HHHH`[OX?_\`'G??]=%_E78UQWP__P"/.^_ZZ+_*NQKQ,3_%
M9@]PHHHK`04444`%.3_6+]:;3D_UB_44UN!YZL\3_=D7GL>#4E3M%&YRT:D^
MI'-0&PA``CWQ_P"XQYK#GB>K9A133;3KDI.&]%=>/S%)MN5(!B5_5E;'\Z=T
M]F`^BH?M*@?O$DC]-Z]:>LL;'"NI/IGFJL(#$AS\H!/4C@_G4T5Q<0%?)N9D
M4?PA^#3**.9H3C%[HOQ:[J40^9XIO]Y=O\JNQ^)@&Q-:.%'\2,#G\*PZ*KG9
MFZ$&=1'X@TY]H:8QLW19%(-:$<\,W^JE1_\`=8&N'IGE(%V@;1_LG'\J.9&;
MPW9G?UQ#_P#(Q:]_U^)_Z30TL5[>P$F.[E`[*QW*/PJEILTMQJ&LRS.'D:\7
M<0,9_<1=J)M<CL%*E*$[L9XB_P"0++_UTB_]&+7,UTWB+_D"R_\`72+_`-&+
M7,UZ66?PGZE5OB"BBBO1,@KJ/`?_`"'9O^O9O_0EKEZZCP'_`,AV;_KV;_T)
M:PQ/\)DSV/1****\0Q/-/'^C-::D=8B0_9[E`MP>RR#`4GZC`_X#[UQXX:,^
MU>[7-M!>6TEM<Q++#(NUT89#"N,N/AK9M*#:7\\$8'"%0^/Q-?29;F\*5/V5
M;IU.:K1<G='F.HC=8[0I8F3.T=2`03^@JW&ZOY;@Y4KD'UKT>R^&VEP%FN;F
MYN6)/5MH`],"N>\3>$9](NO/TZW>33"I.U!DP'TQ_=]/RKT*.<4:M;DV1DZ,
MTCF!]Q&_VO\`"F!BEZ[C)"J2P`Z\\?UI0_R(JH[MN/RHA8]AT%:NF^&M:U#=
M+%I\BB0[MTOR#'IDUTXW%TZ5-ZZLQE&=O=1GM=VK8$R@'L'3_/I2+9V+AA&`
MN[KL;K_G%=I:?#F[EP;V^CB4CE8EW'Z<\5TUEX*T*RL3:_8DF#'<[R<LQ^OX
MUX<LVAM)7-J=&H_BT/,;V^N+FZ\^_N_,;REC1Y&`.`6/X_>_6NZ^&IW:'?N.
M5:^8J>Q'E1CC\0:GNOAUH5TX8K.F#PJR<#Z9KIK.S@L+.*TM8EB@B4(B*.`!
M7%C,;3K4U""LC>G2<9<S)Z***\LW"BBBF,X'2O\`D&0_C_,U0\1_ZFV_ZZ'^
M57]*_P"09#^/\S5#Q'_J;;_KH?Y4L/\`[RO4]!_PS`HHHKZ(Y@HHHH`[OX?_
M`/'G??\`71?Y5V-<=\/_`/CSOO\`KHO\J[&O$Q/\5F#W"BBBL!!1110`4Y/]
M8OUIM.3_`%B_44UN!YY%K%C(VTS>6_=9%*X_.KJ21RC,;JX]5.:)(HY5VR(K
MKZ,,BJ<FCV+OO$.Q_P"]&2N/RKE]UGJZEZBL\Z?<1C_1]1G7G_EH!)_.C=JL
M6=R6TZCIM)5C^?%'*NC"YH5$]M#(#NB4YZG'/YU3_M.2/`N+"YC/<H-ZC\14
ML>JV,O2Y0?[_`,O\Z.62V"Z'&QCR-CR(!V5N*:;>Y4?+,CG_`&UQ_*K:L&`*
MD$'H0:6CGD@LBB3<(3O@)4=T.<_A33<QJ0'#(3V936A1UJO:=T%BFKH_W64_
M0TZI'M+>08:)>N>./Y5&;(#/ERR)Z`G('X4^>(6855TC_C\UC_K\7_T1%5CR
M+E",2)(.^X8-4+:6?3KJ_:XLYBEQ<"16B&\`>6B<^G*FJT<6D2]T3^(O^0++
M_P!=(O\`T8M<S6WK>I6EQH\J1R_/OC.TJ0>)%S61!;SW0!@A9U/1NB_G7IY?
M)0I/FTU,:NLM".BM&+1+ER/-E2-3UQR1_2KL>B6JX,F^4]PQX/X5T3QM*.VI
M*IR9@;ATZGT'-='X1G_L_5'N+F&58GA*!MO<LI_H:LQ6\,(`BB1<#`P*EKCJ
MXUS7*EH7[&ZU.N@U?3[@D1W4>1U#'&/SJXK*XRK!AZ@UPA56^\`<>HH4%'WQ
MNZ-C`*L1BN/F1F\,^C.]HKC8]5U&'`6Z+`'GS%#$_C5V+Q)<H/WULDGIY;8/
MZT]#-T9HZ6BL:+Q)9LP65)8CC))7*C\:O0ZG93C,=U$<],MC^=.S,W%K<F2V
M@C<ND$:N>K*@!J6BBAMO<D****0!1110`4444`%%%%`S@=*_Y!D/X_S-4/$?
M^IMO^NA_E5_2O^09#^/\S5#Q'_J;;_KH?Y48?_>5ZGH/^&8%%%%?1',%%%%`
M'=_#_P#X\[[_`*Z+_*NQKCOA_P#\>=]_UT7^5=C7B8G^*S![A1116`@HHHH`
M*<G^L7ZTVG)_K%^M-;@<1<?:[)2UYIUY`@."YB)7/U%1I>6TF`LR9/8G!_(U
M[!5&ZT;3;S=]HLH)"PP28QG\^M=<LO@_A9O'%RZH\THKL9O`6BNVZW%Q:\YQ
M!*0/R.:R[GP+J$;9L=520=DN8N/S7FN:67U%L[FT<7![F%4<MO#-Q+%')_OJ
M#6A<>'O$-H,FPCN5&,M!*,_@IYK-DFDM\?:[.[MB>@EA.?TS6$L/5AT-55IR
MZE5M'L]VZ)7A?^]$Y%)]AO(O]1J+D#^&9`^?QJW%=6\S%8YHV8=5##(_"IJR
MYI+<NR>QG&758?O6T%Q_USDVG]:7^U5C)%Q:W$..K%,K^8K0HHYEU06?<JPZ
ME93@>7<QG/0$X)_`U:SD9%0RVEM.<RP1N?4J,_G54Z-;+DP/-;D]3%(1_.BT
M6&IH45GFUU"+F&^60#HDT?\`4<T?:-2B_P!;91R@#EH9,?H>:.7LPYB\\:2?
M?16_WAFH6L[=CN\H`]MO%5QK$"G%Q%/;GI^]C.#^56(KZUG($=Q&S'^$,,_E
M1::"Z8PV1'^KN)%Y_B^:FF*Z3)'EN`.G0FKM%'/)!9%`O(N`]O(#_L_,!0MS
M"V?G`QUW<?SJ_36C1_OHK8]1FJ]HNJ"Q7!!&0<T4K6,#,6"E'/\`$IP::;-Q
MCR[A@!U##=FJYHAJ+13"EVHR4CD/HK8_G33*R,1)#(N.K8R/SI^@$M-**Q!9
M0<=,BF+<0MC$@YZ9XS4M/5"T81M+",0SS1^ZN?ZU=BUC483_`*\2*.BR+S^=
M4J*?,R73B^ALQ>)9E`$UHK$]3&^`/SJY'XCT]LES)$!WD0@5S5%/G,WAXO8[
M2*]M9P#'<1MGH`PS^56*X'8N[=M`8]P.:DAEGMP!!<S1J/X0_!_.GS(R>&?1
MG=45R,>N:E$22\4P[!UQC\15Z+Q*<@36A]V1N/RIZ&;HS70Z"BLN+Q#IT@!:
M5HB>@D4@U?BN8)_]5,C^RMDT6(::W.&TK_D&0_C_`#-4/$?^IMO^NA_E5_2O
M^09#^/\`,U0\1_ZFV_ZZ'^5+#_[RO4[W_#,"BBBOHCF"BBB@#N_A_P#\>=]_
MUT7^5=C7'?#_`/X\[[_KHO\`*NQKQ,3_`!68/<****P$%%%%`!3D_P!8OU%-
MIR?ZQ?K36X'2T445[9F%%%%`!2%0>HI:*`,N[\.:-?9^T:;;L3U(3:3^(YK'
MN/`&FNY>UGNK4]ECER@_`UUE%3*$9;HI2:V9P4_@?58A_HNIP3GOY\6W_P!!
MK+FT;7K;)ETHR*.]O(')_"O4:*YY8.C+H:K$5%U/'GNUAD\NYAGMY.?EEB(Q
M_2I(YX9O]7*CX_NL#7K;QI(NUT5E/4,,BL>\\)Z'?',^FP9[%%V$?EBN>671
M^RS6.+?5'`45U<_@"S*-]DO[RW8_=R^]5_`UES>#-;A8^1>6ER@Z>8A1C^7%
M<\L!46VIM'%0>YD56ET^TGSYEM&2>K!<'\QS5V?3=;M/^/G1IR,_>MR)1CU.
M.E4FOH(GV3%X6'!$J%<?B>*YY4:L-T:JI"74@_LB-,?9[BX@QT"2''Y&CR-4
MB!\N[AFYX$L>W`_"KR2)*NZ-U=?53D4ZHYFMRK+H9WVR_B/[_3RR@<O"X;].
MM+_;%JK!9O-@8]!+&16A2$`C!`(/8T<T7N@LR.*Z@G`,4T;Y_NL#4M4Y=+L9
MAA[6/_@(V_RJ,:68L_9[RYBST4MN4?@:+1?4-30HK.\O5H>%GM[@=S(A4_IQ
M0=0NHAF?39@/^F+"3]*.1]`YB\\4<GWT5OJ*A-A#CY-T9]48U$FKV3':TIC;
MNLBE<5;BFBF7=%(CKZJP(H]Z(:,K_99E/R7&1V5E_K3-MTA`:)']2C8Q^=7J
M*/:/J%C/-P$_UB21C.,LO!IZS1MC#KST&>:NU&]O"^=T:G/4XYJO:(+,AHH^
MP1#_`%;21@=E;BFFVN%^Y,K\]'7&!^%5S18:CJ*C/VA/O0[@!R4;^E-^T(N-
MZO&3T#*:8KDU-\M<Y`P<YRO!_2A9$?[KJWT-.IJZ#1D.A_\`($M/]S^M5/$?
M^IMO^NA_E5O0_P#D"6G^Y_6JGB/_`%-M_P!=#_*JP_\`O*]29?PS`HHHKZ,Y
M0HI%(8X7+'_9&:M1:?>R]+<H,\ESBLYU81W8TF]CLOA__P`>=]_UT7^5=C7`
M^'I[K0XYD*Q2K*P8X)!&!711^)H,#SK:9"?[HW5X]:2G4;B9RIR3V-RBJ,.L
MZ?,<+=1ANX;C'YU<1UD7<C!E/<'-96,[,=1112$%.3_6+]:;3D_UB_6FMP.E
MHHHKVS,****`"BBB@`HHHH`****`"BBB@`HHHH`*BGM8+E-D\,<J?W74,/UJ
M6B@#"NO!V@W99FT](W(P'B)0CZ8XK)F\`1KDV6J747.<2XE'TYZ=J[.BHE2A
M+=%*<ELSSJ?PAK]N"T3V=VHZ*"8V/Y\5FSVFJV?_`!]:3=*`,EX@)%'XBO5Z
M,5SRP5*72QM'$U$>.C4+4YW2^60<$2`IS^-6%8,,J01Z@UZG<6-I=KBXMH9A
M_P!-$#?SK#N/`^A3LSI:FWD/\<#E3_A7-++E]EFL<7W1Q-%='/X!=26LM7F0
M=1'.@<?GUK,G\+>(K?&R&TNQ_P!,Y#&?;[W^>*YY8&JMM3:.)ILS6177:ZAE
M/8C-5&TBQ8Y%NJ'_`&"5_E5N=+ZTR;O3+R%1C+F+<OYBH5OK5R!YZ*QZ*YVG
M\C6+IU(;IFBG"6S*W]FSQG-OJ-PGM)B0?D:5CJT0)46TX';E6/\`2M"BHYWU
M*LNAG_VE-'_Q\:?<(?\`8PX'XBGQ:M8RL5%PJL.H?Y<?G5VHY(8IN)8D?_>4
M&B\>P:H<CI(NY&5@>X.:=6>^C632>8B-#(.CQ.5(_I0UC=QC_1]1D&.TJA\_
MC1:+V879H45G^9JL0^>"WG]/+<J?UI!JNPD7-G<PXZMLW*/Q%'(^@<RZEM[6
M!QS$OX#%1FQ4',<LB>@SD#\*2+4[*8@+<Q@GH&.T_K5L$$9!R#1>40T9E6]M
MJ.GP1P0/!/"@P`X*O_A5/5AJ%[%"!ISJR,2<2!N,5T-%7"LXRY[:B<+JQR<6
MF$MMGN!$W]T(<CZYK1@TFQ`R!YONS9Q6T0&&"`1Z&H7L[:0C=$O'3''\JVEC
M)SW9*II$,<4<0Q&BK_NC%/I#9D`^7<2*WJWS4WR;I3PT;J/7@G^E9\R?4K8?
M141DE3'F6T@)_N?-0+B+)!<#'KQ3"Y(RJPPR@@]B*%&QMR,R$=-K$4!@PRI!
M'J*6B[0-)[EF+4]1@`"7C,._F@,35V/Q)=)DRVT<@'0(V"?SXK)HI\S,W1@^
MAT<7B2U8@2QRQD_[.0/QJ];:MI\Y#1W<14$9);'\ZXZG0QH]S"'16&\<$9[U
M2DKF<L.K:,]AHHJ.XGBM;=YYG"1HI9F/0"O<;L<"3;LA^1ZTUYHXQEY%4>I.
M*\B\0>)KK5]09XI98;9?ECC5B,CU/N:Y'5-0*9B1R96^\V>G_P!>O/>/3ERP
M5SVJ>2R<%*<K>5CZ-5E=0RD,I&00>#574]4L=&L);[4;F.WMHAEI'/'T]S["
MN;^&VJ_VEX/MT9LRVA-NWT'W?_'2/RK+^-/_`"3R7_KYB_F:[X/F29XU:#I2
M<7T-GP;XVM_&<FI26=L\5K:2+'&\A^:3())([=.E=57CWP"_Y!6M?]=X_P#T
M$U[#525F9Q=U<***0D`9)``]:10M07EY;:?9RW=Y/'!;Q+NDDD;"J/K4J2))
M]QU;'H<UR/Q3_P"2:ZS_`+D?_HQ::W$W9"^%/'UEXPUK4K73H7%I9HA6=^#*
M22.%[#COS]*Z^O#/@%_R$=<_ZY1?S:O<Z<E9B@[J["BBBI*"BDW*#C(SZ9I:
M`"BFM(B??=5^IQ2JZN,JP8>H.:`%HHHH`9-*D$$DTAPD:EF..PYJEI.J+JL,
MTR1E$20HN3R1@')_.I=5_P"01>_]<'_]!-8_@S_D%3?]=S_Z"M`'1U2N=)T^
M\.;FR@E)[O&"?S_`5=HH`YBX\!Z)*/W$4]H3U-O,5S_.LV;P)>1Y-IJV_P#N
MI/$,#\1S7<T5E*C3ENBU4G'9GF<_AOQ%:@YL[>Z`'+02[?R#<UFS236G_'Y8
MWEL.QDA.#^6:]>I-H]*YY8&D]M#6.*FCR&.[MI3A)XRW]W=S^535Z1=Z#I5\
MK+<:?;ONZGRP"?Q'-8LO@#2<DVKW-IQ@+%*=H_`USRRY_99M'%KJCD:*W)_`
MVIPAFM-5BG]%N(MOZK69/HFOVF2^F><@_BMY`Q/T7K7/+!5H]#:.(IOJ49;6
M"?\`UT,;GL64$BJAT>U'^I\V!C_%%(0:LR7)MR%NK>YMF/\`#-$1_P#6]:=%
M<P3?ZJ:-R.H5@<5BXU(;FB<9;%-;._A&(M0,@`X69`?S(YH$^J1'$MI%,,_>
MADQQ]#6C14\W=#Y>QG'6(8CBY@N+?_:>,X_,59CO[27`2XC)/0;L'\JL57EL
MK6;/F6\;$]3M&?SHO%AJ6**SUT>"+`MY;B!1_#'(<?K2?9]3AR8KV*;T6:/&
M/Q%'*GLPNS1IK(KC#J&'H1FJ)NM0B/[VP$B]VAD'\CS1_;-LHS.LUO[2QD4<
MDN@<R+#6<#$D)M;U4XIGV-U_U=Q)C_;^;-2Q7=O/Q%/&Y]%8$U-1S20:,I&.
M[3)VQR#/`!P?UIIE=#B2"1<#)(&0/QJ_1353N%B@MS"XXD'X\?SJ>&14FCD8
MX16#$^U3-&C_`'T5OJ,TR"Q@^UQLBE&,@)*GKS5QFKB:=CUTG`S7F'C3Q-_:
M5P=/M'_T2)OG8'_6,/Z#_/:N[\3)-)X8U-;=V2;[,Y0J><A2:^<0]S<MCS';
MURQP*]3&N7+RIV3'E%&$INI+5K8](\*^&7URY\Z<%;*,_,?[Y_NC^M<CXUT0
MZ#XHNK901!(?.A/^RW;\#D?A7;>'/'^F:!H5KI\MA.J0+AGC(;<Q.2<''4DU
M1\?ZUI'B,:9/I\J3[%D#_*0RYVX!!Y]:PC"E"C>+NSN57$RQ=IJT60_"35?L
MVNW&FNV$NX]R`_WT_P#K$_E72?&G_DGDO_7S%_,UD?#KPF9[^/6Y4:.&!CY.
M"09&Z'\!^OYUK_&G_DGDO_7S%_,UW85MP5SQLUY/;/E?J>+>$-$\5>(#<6/A
M^6YBMB0;EEG,40/;=CJ?;DU;\2^"?$_@(0:E/=J%DDV+<V4[Y5^H!)`(/!_*
MO0/@%_R"M:_Z[Q_^@FMCXW_\B$G_`%^Q_P`FKKYO>L>4HKDN2>"?'=QJ'PUO
MM8U#]]>:6D@D/3S=J;E)]SD#Z@FO)=-LO%/Q5URX5]0#F-?,<SR%8H@3P%49
MQ^`^M=S\&=/BU;P1XBTZ8D174AA8CJ`T>,C\ZY$>!?B!X1U:1])M[K=R@N;)
MP5D7W&<_@10K)L'=I&I)\#O$UK^^L]3L&E7D;9'1OP.VNNUFRU;3O@)=VFN-
M(VHQ)B4R2^8Q'VCY?FR<_+BO/;[Q3\3/#317&I76H6Z.V$-S$K(Q].1BNZU+
MQ8WC'X&ZMJ$T:QW496"=4^[O#H<CV((-)WT&N76QY9X-T7Q-KTEY9>'9GB1E
M4W3"?REVY.W<>I'7@9K0UWP)XM\#6RZN]P%C5P&N+*X;,9/3/`/7O75?`'_D
M(ZW_`-<HOYM7I'Q+:)/ASK1FQM,``S_>+`+^N*;E:5A1@G&YD_"CQI<^*]$N
M+?47#ZA8LJO)C'F(V=K'WX(/X>M7Y[V_\1:H]I93&&U3.2#C(]3ZY]*\U^!:
MRG5-<*9V_9%'_`MQQ_6O3O!)7-Z/XOD_+FLYJS-:;O$G'@NWV_->2ENY"@5K
M:7I9TRSDMQ<-*&8LK$8V\`8_2M&JFI7JZ?I\UTR[M@X'J3P*11B)X-@;YKB]
MFD<]2`!_/-4M4T!]&MS?6-W*/+(W`G!&3CJ*=:#7]<1KE;WR(2<+@E1^`']:
M9JNF:S:Z;-)<:B)K<8WH78D\C'4>N*0S;M-:SX;_`+1G&712&`XW,#@?GQ6-
M9V&I>(PUU=7C16Y)"J.A^@Z8]ZBY_P"$%XZ>=S^==+X?V_V%:;>FS]<G-`C#
MO/#,ME93S6^HR;4C8NA!`88Y'!JWX,_Y!4W_`%W/_H*UL:K_`,@B]_ZX/_Z"
M:Q_!G_(*F_Z[G_T%:`.CHHHI@%%%%`!1110`4444`%%%%`#719%*NH92,$$9
M!K*NO"^B7O,^FVY/7*KM/Z8K7HI-)A<Y&Y\`6!):RO+RU;LH?>@_X":SI_!6
ML0\VU];7"CG$R%6/L,<5W]%92P].6Z-(U9QV9Y;/I.N6@)GTF5P#@&W<29]\
M50:\CCD\N=98)`,E98RN/QZ5[!@&F2P0S)LEB213V=017/+`4WMH;1Q4UN>3
MQS1RC,<B./56!I]=[>^$-"OR&ETZ)7!R&C^0C\JRI_`$&W_0]3O(&]7(E'Y&
MN:6727PLUCBX]4<O01D8-:L_@[7;<,8I[2Z4'Y0<HQ^O:LV:QUBU8+<Z/<C/
M\4.)%'XBN>6$K1Z&RKTWU*4FFV4OW[:/GJ5&T_I4']DB,YMKNYAQT4/E?R-6
M/M]L"0\GED?\]%*?SJPK*Z[E8,/4'-9/GCN6N5[%`QZK%C9<03^OF)M_+%'V
MZ\B4F?3I,#O"X?/X5H44N;NAV[%!-8LRVQW:)_[LB$$5;BN8W^>"5'9>1L.[
M'X"GLJNNUU##T(JL-(L)[F(M;JK;A@I\I'/M3CRMB=['L+JKHR,,JPP1ZUYA
MK7PQEMU:719/,C'/V>0X8?1NA_''UKU&BOH*E*-16D>?A\54P\N:#/FG5X+B
MRD^S7,,D,H.61UP16WX$\,R^(;U@P9;.)@9I!_Z"/<_I7O6U3U`/X4``=`!]
M*YXX.*W>AZ%3.)RBTHV?<9!!%:V\<$**D4:A551P`*X#XT_\D\E_Z^8OYFO0
MZIZEJ5EI5L)[Z811,X0':6RQZ```FNQ:'C2U6IY7\`O^05K7_7>/_P!!-:_Q
MO_Y$%/\`K]C_`)-7H%C>VVH6PN+5BT1)&2A0Y'L0#5@@'J,U5];DJ/NV/(_@
M/G_A'-7QU^TC'_?`KFHOC)XQT=OLVK:?;R2+P?M%NT4GXX('Z5]`@`=`!2.B
M2+M=593V(R*.97U#E=K)GS-XJ\?ZY\0(+;2QIT:HDHE6&U1G=WP0/7L3P!WK
MN;?PAJ6A?`W5K&:VD?4+QQ<-;QJ79?FC`7`[X7)],GTKU^.&*$8BC1`>H50*
M?3YNPE#JV?*?ACQ5KG@.[N9;2TC#7"A9$NX6QQG'0@CJ:TM<\:>+?B)'%I:6
M8:'>&-O8P-\[=BQ))X_`5]*6US%>6ZSQ!]C$@>9&R'@D'A@#VJ7`'3BCGZV%
M[-VM<X?X8>"Y?!^@2?;=O]HWC!YU4Y"`#Y4SWQDD^YJ>YLK[P_JKWME$9;9\
MY`&<`]CZ>QKLJ*AZFB5E8YE?&EMM^>TF#=P""*L/,?$N@70AA,3;L(&/WB,'
M_P"M6X40G)12?7%,CN8);B:W256FAV^8@/*YY&?K0,X_3->ET6V^Q7=G)\A)
M7^$C/UJ2_P!4U'6[*6&UT]DM\;G<\D@<\'@=NG-=C12`YK1+-;_PFUJQQYA8
M`^ASD'\ZH:?JMUX=W65_:N8@Q*D=OIV(KM*SVU>S^U3VK>8SPRQ1.!$S#=)R
MO0'CGDG@=Z=@,2^\66UU936\%M,6EC9`6P,9&.V:M^$898=+E$L;H6F)&Y2,
MC`YK?557[J@?04M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110!!<6EM=ILN((IE])$#?SK&N/!>A7!9OL0BD/\<3%2/Z5T%%)Q3W
M&FUL<5+\/Q&/]#U>Y1?291(?S-9DWA3Q%;L2J6EVG;RW,;?CGBO2**PEAJ4M
MT:1K374\FN8-1L03=Z5=QJOWG5-ZC\14=M?VIN(<S*OSCA_E[^]>N8!JM/IU
ME=<W%I#*?5XP36$L!"]XLU6*EU+5%%%=YRA1110`5SGC.UN;K3;+[-'<LT5]
M#*YM0#(J@G)7/&171T4`SBKO2Y-:DTU)[;4)[:&WNP[7H"OYAV;"=N!G[P!]
MJQ;O2[O2?#DCO;7$:3:79_:U#$F2X\T;\\_?()!]:]/IDD4<R%)45T.,JPR.
M.:=R>4\_.FW9BF:WTV^30?M\4C:><B1XA&P?:F<A?,*';WVMQSRPZ+K?V*(V
M<-U##=RW%D(7D^>UM)64JYR>"NUL#J`X';CT:BBX<IYK-I'B*?1O.NHI3*MU
M!!<0A?,\VWAC9=VP,NX-(Q?;GD8Z]*T]*\/R/>:*MW'/<V4$%W(//B,8B=I8
MC&NTL2,#>%R3@"NWHHN'*>=)X=OKRUC2^LYW:+3KORRS'*3&;*$'/#;>AJIK
M:W,,_F:C;S3WLKV"VDXF7_1SNC$B%=P(8MO/`.0WMQZA5=K"S>[6[:T@:Y48
M68Q@N/\`@76BX<IRWC3[7#<V<FG2?Z5>QOIIC#X($O*R@=]A4GZ$^E4;G2+V
M+5IHXK*\>^%[;FPO@Q\J&U41AE)SQPL@*X^8MWSQW1MK=KE;DP1FX5=BRE!N
M`]`>N*EHN%CBM.BU)-8TVREL[Q1:ZC>S2SD?NFBD\TQD-GG[ZC';'M2:IIEV
M=?UR6ULIA?W=D%T^]4?)&XB=3EL_*<XZ^HKMJ*+CL<EX7LW@U:XEM-/N]/TT
MVL:-#<DY><$Y8`D\XP"W\7'7%9=WH%^/#]S+#:N+R;5I9+L;2[S6WGN5&-PW
M#:4.W(R!CVKT&BBX6/,]0TK41X=MK*.TFN('%S(DCV+F2W<D;(U3S,H.6(;)
MQ@#BM%;#5OM;E[:X\R2XTV9Y.S!-HDR<]1@Y%=W11<7*>:-I>KK8:O:Z?9W#
M1O)%*]S-"8YYE\[,D9^<>9\F>05R/E[YKK/"-D]EI4RLTVR2X:2.*2W,`B!`
M&U4+,0N03U[FM^BBXTK!1112&%%%%`!1110`4444`%%%%`!1110`4444`%%%
8%`!1110`4444`%%%%`!1110`4444`?_9
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
        <int nm="BreakPoint" vl="1415" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Another check for tube diameter" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="11" />
      <str nm="Date" vl="11/28/2025 11:32:47 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Make sure tube diameter is picked up for offset" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="10" />
      <str nm="Date" vl="11/27/2025 9:27:46 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Fix visibility issue for the new property to display the height of the installationpoint. Add hide direction in the topview." />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="11/20/2024 4:06:15 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add property to display the height of the installationpoint. This makes it possible to show them in hsbMake or on the layouts to be checked by contractors." />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="11/20/2024 3:53:01 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Make sure index for propdouble is correct" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="10/30/2024 2:35:31 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Fix issue where tooling for slotted hole was checked for .intersect() instead of .hasIntersection" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="9/8/2022 10:42:05 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="If plEnvelope of element is not valid for some reason, check the profBrutto of zone 0, for intersection of the points to create the installationtube." />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="1/25/2022 3:20:37 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Also add body intersectioncheck for oval shapes." />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="12/21/2021 9:42:43 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12951: FreeProfile: setMachinePathOnly to false " />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="11/15/2021 6:00:07 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Only add drills when the drill body is touching the sheet" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="10/1/2021 9:58:37 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add option for tool to use for the visualization of the cutout in the sheet. Drill creates a segmented hole, freeprofile creates a round hole. for DXF tooling, a perfect round pline is needed." />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="8/30/2021 1:30:39 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12370 installation shape published as dimrequests to be consumed by tsls liek hsbViewDimension" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="6/23/2021 12:13:21 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Adding a check for the length of the array, before using the array of _PtG[]." />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="4/6/2021 4:00:05 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End