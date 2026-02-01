#Version 8
#BeginDescription
This tsl adds a tube to a roof element. The insertion point of the tube will be projected to the specified reference position.
A tube and a set of trimmers to fixate the tube are created at the insertion point. The tube can be placed vertical or perpendicular to the element.
The tube is added as a hardware component to the tsl.

4.20 03/03/2022 Add check if origin of elipse is still in profile of element (there where issues with mirror/copy) Author: Robert Pol

4.21 21/04/2022 Add point and widt/height to recontruct split rafters Author: Robert Pol

4.22 22/04/2022 Correct check for point3d Author: Robert Pol

4.23 31-5-2022 Fix check for labelTextHeight, when chanced by user. Ronald van Wijngaarden

Version 4.24 24-1-2023 Add tolerance to the drill in the tube beam, to prevent a invalid drill on the tube beam with the same diameter as the beam itself. Ronald van Wijngaarden

4.25 22-2-2023 Expose label display. Correct label for rectangular shapes. - Author: Anno Sportel

4.26 29/05/2024 Make sure check for trimmers does not delete tsl Author: Robert Pol
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 4
#MinorVersion 26
#KeyWords 
#BeginContents
//region History and versioning
/// <summary Lang=en>
/// This tsl adds a tube to a roof element.
/// The insertion point of the tube will be projected to the specified reference position.
/// A tube and a set of trimmers to fixate the tube are created at the insertion point. The tube can be placed vertical or perpendicular to the element.
/// </summary>

/// <insert>
/// Select an element and a position.
/// </insert>

/// <remark Lang=en>report
/// Tube is added as hardware
/// </remark>


/// <history>
/// AS - 0.00 - 13.10.2014	- Pilot version
/// AS - 1.00 - 21.10.2014	- Add descriptoin. Add tube as hardware.
/// AS - 1.01 - 27.10.2014	- Draw tube in specified zone and layer.
/// AS - 1.02 - 30.10.2014	- Add option to allow rafters to split. Add option to apply only a top trimmer.
/// AS - 1.03 - 13.11.2014	- Add option to create trimmers with different sizes
/// AS - 1.04 - 10.03.2015	- Add option for trimmers aligned with tube. Split trimmers on standard beam sizes. (FogBugzId 914)
/// AS - 1.05 - 10.03.2015	- Add dimension info (FogBugzId 914)
/// AS - 1.06 - 10.09.2015	- Add trimmer configuration (FogBugzId 1855)
/// AS - 1.07 - 08.12.2015	- Add option to apply no trimmers.
/// AS - 1.08 - 12.10.2016	- Add top sheet. Add properties to extend the tube.
/// AS - 1.09 - 01.11.2016	- MIll all exteral sheeting from zone 1-4
/// AS - 1.10 - 21.11.2016	- Add option to prefix the subtype (used as dim instruction). Add option to show the diameter.
/// AS - 1.11 - 02.02.2017	- Add options to give separate beamcodes, option to apply side trimmers, sheet in zone 10 with sectionional view, correct position of splitted rafter.
/// AS - 1.12 - 03.02.2017	- Remove debug info
/// AS - 1.13 - 11.04.2017	- Also add beamcodes to the additional trimmers.
/// AS - 1.14 - 12.04.2017	- Increase size beamcut for aligned trimmers.
/// AS - 1.15 - 20.04.2017	- Add option to specify beamcode for split rafter above tube.
/// DR - 1.16 - 11.05.2017	- Zone 1 will always be cut.
/// DR - 1.17 - 12.05.2017	- Versionning standarized.
/// YB - 1.18 - 17.05.2017 	- Cut the rafters.
/// YB - 1.19 - 19.05.2017 	- Cut the vertical trimmers.
/// AS - 1.20 - 19.05.2017 	- Correct cut-out zone 1 sheeting.
/// YB - 1.21 -  01.06.2017 	- Fixed a bug with the vertical trimmers.
/// YB - 1.22 -  01.06.2017 	- Added flipped horizontal trimmers as an option.
/// YB - 1.23 -  01.06.2017 	- Hardware only gets added when the tube is drawn. Fixed a bug with the horizontal flipped trimmers being placed when they shouldn't.
/// YB - 1.24 -  02.06.2017 	- Added validations to prevent crashes.
/// YB - 1.25 -  02.06.2017	 - Changed the orientation of the flipped beams.
/// AS - 1.26 -  12.06.2017 	- Only allow flipped trimmers to be inserted when there are vertical trimmers applied.
/// AS - 1.27 -  12.06.2017 	- Set excution loops to 2.
/// AS - 1.28 -  22.06.2017	- Add delete as custom action. Add rectangular openings as an option.
/// AS - 1.29 -  22.06.2017	- Use resolved beamwidth instead of the width specified in the properties
/// AS - 1.30 -  28.06.2017	- Convert  the list of line segments into a list of arcs for the freeprofile (Case 4601)
/// YB - 1.31 -  06.07.2017 	- If shape is rectangular, cut top sheet rectangular. Add properties for top sheet offset on all side if shape is rectangular
/// YB - 1.32 -  06.07.2017 	- Tube label can be split with ';'.
/// RP - 1.33 -  02.08.2017	- Convert  the list of line segments into a list of arcs for the freeprofile (Case 4601), also for internal sheeting
/// AS - 1.34 -  13.09.2017	- Add context option to copy tube to another element.
/// AS - 1.35 -  25.09.2017	- Only approximate with arcs if opening is oval.
/// AS - 1.36 -  03.10.2017	- Ignore supporting beams while finding beams to stretch vertical trimmers to. Remove flipped trimmers section.
/// RP - 1.37 -  09.10.2017	- Close pline for freeprofile and set set onlyonce on true for collection of vertexpoints
/// RP - 1.38 -  30.10.2017	- Check on halfileintgersect for rafters and not create sheet if a sheet has no body.
/// RP - 2.01 -  16.11.2017	- Add options for top and bottom trimmer.
/// RP - 2.02 -  17.11.2017	- Add check for line/plane intersect
/// RP - 2.03 -  30.11.2017	- Get dBmW after check, this was giving back the wrong value if it wasnt the same as the beamwidth of the element
/// RP - 2.04 -  07.05.2018	- Add the freeprofile tool to the external sheeting if there is no topsheet
/// FA - 2.05 -  18.05.2018	- Added a filter with "HSB_G-FilterGenBeams"
/// RP - 2.06 -  18.06.2018	- Added a Map in _Map with cnc data for toolpath tsl
/// RP - 2.07 -  26.06.2018	- Empty toolpath was added
/// RP - 2.08 -  12.07.2018	- External sheeting was not cutted
/// RP - 2.09 -  20.07.2018	- Add option for creation of tube as beam for listing
/// RP - 2.10 -  19.09.2018	- If the cut out is round add point/vector/double in map, also for internal sheeting use correct tooling
/// RP - 2.11 -  29.11.2018	- If the cut out is round use the createcircle function, this will result in a wrong solid: INBOX-782
/// RP - 3.00 -  11.12.2018	- Add option to integrate top sheet in the rafters (Vadeko)
/// RP - 3.01 -  12.12.2018	- Make sure cutout is at the correct place and dont cut counterbattens when top sheet is deepend
/// RP - 3.02 -  17.12.2018	- Invalid zone 5 profile causing an issue with intersection of sheet profile
/// AS - 3.03 -  12.04.2019	- Make tube display available in ModelX.
/// AS - 3.04 -  18.04.2019	- Add jjs elipse output as mapx on element
/// AS - 3.05 -  28.04.2019	- Correct typo. Ellipse io elipse.
/// RP - 3.06 -  05.06.2019	- Delete map with diminfo before creating new tube
/// RP - 3.07 -  13.06.2019	- Radius and depth change for ELPS command
/// RP - 3.08 -  03.07.2019	- Add element tool setting
/// RP - 4.00 -  10.07.2019	- Use map with body to store split beams and correct beam diameter
/// RP - 4.01 -  27.08.2019	-When multiple tubes cut a beam there where duplicate beams. Now store the cuttingbody and use that to create a new beam
/// RP - 4.02 -  29.08.2019	-Transform body before checking if intersection.
/// RP - 4.03 -  02.09.2019	-Delete submapx for elipse on element before deleting tsl.
/// RP - 4.04 -  04.09.2019	-Check for tsl handle to recreate split entities (copy caused original beam to be recreated)
/// RP - 4.05 -  05.09.2019	- Use mapx to store absolute body (body in _Map is transformed with tsl transformation)
/// RP - 4.06 -  06.09.2019	- Set beamtype
/// RP - 4.07 -  25.09.2019	- Remove sectionsheet and tube beam from _GenBeam, because it was causing issues with a addmetogenbeamintersect tool
/// RP - 4.08 -  29.10.2019	- Add option for integrated timbers and change cut tooling for vertical trimmers
/// RP - 4.09 -  22.01.2020	- Do not erase tsl when there are no counterbattens(otherwise tsl will erase when generating element)
/// RP - 4.10 -  30.01.2020	- Do not stretch to splitted beams and make sure splitted rafters are strechted to the correct horizontal trimmer
/// RP - 4.11 -  08.06.2020	- Top sheet not streched to rafter because of battenprofile
/// RP - 4.12 -  22.07.2020	- Top sheet not stretched when only 1 rafter next to it
/// RP - 4.13 -  28.07.2020	- Top sheet was stretched to zone 5 outline while it should be on zone 0
/// RP - 4.14 -  30.09.2020	- IntegratedTimbercatalog not set correct.
/// RP - 4.15 -  07.01.2021	- Do not consider tube section as external or internal sheeting
/// RP - 4.16 -  22.04.2021	- Use counterlath with and height of element to cretae extra counterbattens
/// RP - 4.17 -  22.04.2021	- Add vertical offset for tilelath cutout
/// RP - 4.18 -  22.04.2021	- Add support for purlin elements
//Rvw - 4.19 -	  09.07.2021	- Make topsheet stretch to the center of the rafters left and right when they have a divergent width.
/// </history>
//endregion

//#Versions
//4.26 29/05/2024 Make sure check for trimmers does not delete tsl Author: Robert Pol
// 4.25 22-2-2023 Expose label display. Correct label for rectangular shapes. - Author: Anno Sportel
//4.24 24-1-2023 Add tolerance to the drill in the tube beam, to prevent a invalid drill on the tube beam with the same diameter as the beam itself. Ronald van Wijngaarden
//4.23 31-5-2022 Fix check for labelTextHeight, when chanced by user. Ronald van Wijngaarden
//4.22 22/04/2022 Correct check for point3d Author: Robert Pol
//4.21 21/04/2022 Add point and widt/height to recontruct split rafters Author: Robert Pol
//4.20 03/03/2022 Add check if origin of elipse is still in profile of element (there where issues with mirror/copy) Author: Robert Pol




//region OPM
double tolerance = Unit(0.01, "mm");
double vectorTolerance = U(0.001);
double areaTolerance = U(1);
double volumeTolerance = U(1);

String categories[] = {
	T("|Tube|"), // 0
	T("|Position|"), // 1
	T("|Construction|"), // 2
	T("|Beam properties|"), // 3
	T("|Assignment|"), // 4
	T("|Sheeting|"), // 5
	T("|Markup and measurement|"), // 6
	T("|Flipped trimmers|"), //7
	T("|Filter|"), //8
	T("|Element tool|"), //9
	T("|Tilelath cutout|"), //10
	T("|Integrate timbers|") //11
};

//// TODO: Read articles from database.
String yesNo[] = {T("|Yes|"), T("|No|")};
String noYes[] = {T("|No|"), T("|Yes|")};
String alignement[] = {T("|Top|"), T("|Bottom|")};

//Properties
double arDDiam[] = {U(110),U(125),U(160),U(200),U(250),U(315),U(400),U(500)};

// Triggers the hardware to be added again.
String addHardwareEvents[0];

String openingShapes[] = 
{
	T("|Round|"),
	T("|Rectangular|")
};

// Filter
String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = TslInst().getListOfCatalogNames(filterDefinitionTslName);
filterDefinitions.insertAt(0,"");

PropString filterDefinition(31, filterDefinitions, T("|Filter definition beams|"));
filterDefinition.setDescription(T("|Filter definition for beams.|") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));
filterDefinition.setCategory(categories[8]);

String integratedTimberTslName = "HSB_T-IntegrateTimber";
String integratedTimberCatalogs[] = TslInst().getListOfCatalogNames(integratedTimberTslName);
integratedTimberCatalogs.insertAt(0,"");

PropString integratedTimberTslCatalog(38, integratedTimberCatalogs, T("|Integrate timber catalog|"));
integratedTimberTslCatalog.setDescription(T("|Specify the catalog to integrate timbers|."));
integratedTimberTslCatalog.setCategory(categories[11]);

PropString openingShapeProp(26, openingShapes, T("|Opening shape|"), 0);
openingShapeProp.setDescription(T("|Sets the opening shape.|"));
openingShapeProp.setCategory(categories[0]);
addHardwareEvents.append(T("|Opening shape|"));

PropDouble dDiamOriginal(0,arDDiam,T("|Diameter|"));
dDiamOriginal.setDescription(T("|Sets the diameter.|") + T(" |A default set of diamters is available.|"));
dDiamOriginal.setCategory(categories[0]);
addHardwareEvents.append(T("|Diameter|"));

PropDouble dDiamOverrule(1,0,T("|Overrule diameter|"));
dDiamOverrule.setDescription(T("|Overrules the selected diameter, if greater than zero.|"));
dDiamOverrule.setCategory(categories[0]);
addHardwareEvents.append(T("|Overrule diameter|"));

PropDouble openingWidthProp(17, U(100), T("|Opening width|"));
openingWidthProp.setDescription(T("|Specifies the opening width for rectangular openings.|"));
openingWidthProp.setCategory(categories[0]);

PropDouble openingHeightProp(20, U(100), T("|Opening height|"));
openingHeightProp.setDescription(T("|Specifies the opening height for rectangular openings.|"));
openingHeightProp.setCategory(categories[0]);

PropString articleNumber(15, "", T("|Article number|"));
articleNumber.setDescription(T("|Sets the article number.|"));
articleNumber.setCategory(categories[0]);
addHardwareEvents.append(T("|Article number|"));

PropString tubeDescription(21, "PVC Buis", T("|Description|"));
tubeDescription.setDescription(T("|Sets the tube description.|"));
tubeDescription.setCategory(categories[0]);
addHardwareEvents.append(T("|Description|"));

PropString tubeMaterial(16, "PVC", T("|Material|"));
tubeMaterial.setDescription(T("|Sets the tube material.|"));
tubeMaterial.setCategory(categories[0]);
addHardwareEvents.append(T("|Material|"));

PropInt tubeColor(3, -1, T("|Tube color|"));
tubeColor.setDescription(T("|Specifies the label color.|"));
tubeColor.setCategory(categories[0]);

String hwCategory = "";

PropDouble dOffsetTop(11, U(0), T("|Offset tube above battens|"));
dOffsetTop.setDescription(T("|Specifies how far the tube sticks out above the battens.|"));
dOffsetTop.setCategory(categories[0]);
addHardwareEvents.append(T("|Offset tube above battens|"));

PropDouble dOffsetBottom(12, U(0), T("|Offset tube below internal sheeting|"));
dOffsetBottom.setDescription(T("|Specifies how far the tube sticks out below the internal sheeting.|"));
dOffsetBottom.setCategory(categories[0]); 
addHardwareEvents.append(T("|Offset tube below internal sheeting|"));

PropString drawTubeProp(8, yesNo, T("|Draw tube|"));
drawTubeProp.setDescription(T("|Specifies whether the tube has to be drawn.|"));
drawTubeProp.setCategory(categories[0]);
addHardwareEvents.append(T("|Draw tube|"));

PropString createTubeSectionAsSheetProp(22, yesNo, T("|Create section of tube as sheet|"), 1);
createTubeSectionAsSheetProp.setDescription(T("|Specifies whether the section of the tube has to be created as a sheet in zone 10.|") + TN("|This can be used to display the tube on a sheeting report.|"));
createTubeSectionAsSheetProp.setCategory(categories[0]);

PropString createTubeAsBeamProp(32, noYes, T("|Create tube as beam|"), 1);
createTubeAsBeamProp.setDescription(T("|Specifies whether the the tube has to be created as a beam.|") + TN("|This can be used to display the tube on a beam report.|"));
createTubeAsBeamProp.setCategory(categories[0]);

String arSOrientation[] = {T("|Vertical|"), T("|Perpendicular to element|")};
PropString sOrientation(0, arSOrientation, T("|Orientation|"));
sOrientation.setDescription(T("|Set the initial orientation of the tube.|") + T(" |The angle can be used to rotate the tube.|"));
sOrientation.setCategory(categories[1]);
addHardwareEvents.append(T("|Perpendicular to element|"));

String arSReference[] = {T("|Inside frame|"), T("|Inside element|")};
PropString sReference(1, arSReference, T("|Reference|"),1);
sReference.setDescription(T("|Sets the reference position.|"));
sReference.setCategory(categories[1]);

PropDouble dAngle(2, 0, T("|Angle|"));
dAngle.setFormat(_kAngle);
dAngle.setDescription(T("|Sets the angle.|"));
dAngle.setCategory(categories[1]);

PropString sAllowRaftersToSplit(3, yesNo, T("|Allow rafters to split|"));
sAllowRaftersToSplit.setDescription(T("|Specifies whether the rafters are allowed to split.|"));
sAllowRaftersToSplit.setCategory(categories[2]);

PropString beamCodeSplitRaftersAboveTube(23, "", T("|Beamcode split rafters above tube|"));	
beamCodeSplitRaftersAboveTube.setDescription(T("|Defines the beamcode for the split rafters above the tube.|"));
beamCodeSplitRaftersAboveTube.setCategory(categories[2]);

String trimmerConfigurations[] = {
	T("|Only trimmer at top|"),
	T("|Horizontal and vertical trimmers|"),
	T("|Horizontal trimmers|"),
	T("|No trimmers|")
};
PropString trimmerConfiguration(4, trimmerConfigurations, T("|Trimmer configuration|"),1);
trimmerConfiguration.setDescription(T("|Specifies what trimmer configuration to use.|"));
trimmerConfiguration.setCategory(categories[2]);

PropString applyLeftTrimmerProp(19, yesNo, T("|Apply left trimmer|"), 0);
applyLeftTrimmerProp.setDescription(T("|Specifies whether the left trimmer should be applied.|") + TN("|Note|: ") + T("|The trimmer configuration has to be set to use vertical trimmers.|"));
applyLeftTrimmerProp.setCategory(categories[2]);


PropString applyRightTrimmerProp(20, yesNo, T("|Apply right trimmer|"), 0);
applyRightTrimmerProp.setDescription(T("|Specifies whether the right trimmer should be applied.|") + TN("|Note|: ") + T("|The trimmer configuration has to be set to use vertical trimmers.|"));
applyRightTrimmerProp.setCategory(categories[2]);

PropDouble dWTrimmers(3, -1, T("|Width trimmers|"));
dWTrimmers.setDescription(T("|Sets the width of the trimmers.|") + T(" |An invalid width, like zero, will set the height to the default beam height.|"));
dWTrimmers.setCategory(categories[2]);

PropDouble dHTrimmers(4, -1, T("|Height trimmers|"));
dHTrimmers.setDescription(T("|Sets the height of the trimmers.|") + T(" |An invalid height, like zero, will set the width to the default beam width.|"));
dHTrimmers.setCategory(categories[2]);

PropString placeLeftOverBeam(27, yesNo, T("|Place extra beam|"));
placeLeftOverBeam.setDescription(T("|Defines whether to place an extra beam with the left over height|"));
placeLeftOverBeam.setCategory(categories[2]);

PropString AlignmentTop(28, alignement, T("|Alignement top|"));
AlignmentTop.setDescription(T("|Defines the alignement of the first beam|"));
AlignmentTop.setCategory(categories[2]);

PropString AlignmentBottom(29, alignement, T("|Alignement bottom|"));
AlignmentBottom.setDescription(T("|Defines the alignement of the first beam|"));
AlignmentBottom.setCategory(categories[2]);

PropString squared(30, noYes, T("|Squared|"));
squared.setDescription(T("|Defines if the beams are squared or cut along the top and bottom of the element|"));
squared.setCategory(categories[2]);

PropDouble offsetVerticalTrimmersFromTube(5, U(2), T("|Offset vertical trimmers from tube|"));
offsetVerticalTrimmersFromTube.setDescription(T("|Sets the gap between the vertical trimmers and the tube.|"));
offsetVerticalTrimmersFromTube.setCategory(categories[2]);

PropDouble offsetHorizontalTrimmersFromTube(16, U(2), T("|Offset horizontal trimmers from tube|"));
offsetHorizontalTrimmersFromTube.setDescription(T("|Sets the gap between the horizontal trimmers and the tube.|"));
offsetHorizontalTrimmersFromTube.setCategory(categories[2]);

PropString sAlignTrimmersWithTube(5, yesNo, T("|Align trimmers with tube|"),1);
sAlignTrimmersWithTube.setDescription(T("|Specifies whether the trimmers should be aligned with the tube.|"));
sAlignTrimmersWithTube.setCategory(categories[2]);

PropString bmCodeTopTrimmer(6, "", T("|Beam code top trimmer|"));
bmCodeTopTrimmer.setDescription(T("|Sets the beam code for the top trimmer|"));
bmCodeTopTrimmer.setCategory(categories[3]);

PropString bmCodeBottomTrimmer(18, "", T("|Beam code bottom trimmer|"));
bmCodeBottomTrimmer.setDescription(T("|Sets the beam code for the bottom trimmer|"));
bmCodeBottomTrimmer.setCategory(categories[3]);

PropString bmCodeLeftTrimmer(7, "", T("|Beam code left trimmer|"));
bmCodeLeftTrimmer.setDescription(T("|Sets the beam code for the left trimmer|"));
bmCodeLeftTrimmer.setCategory(categories[3]);

PropString bmCodeRightTrimmer(17, "", T("|Beam code right trimmer|"));
bmCodeRightTrimmer.setDescription(T("|Sets the beam code for the right trimmer|"));
bmCodeRightTrimmer.setCategory(categories[3]);

PropString createTopSheetProp(9, yesNo, T("|Create top sheet|"));
createTopSheetProp.setDescription(T("|Specifies whether the top sheet should be created or not.|"));
createTopSheetProp.setCategory(categories[5]);

PropString topSheetDeepend(33, noYes, T("|Top sheet deepend|"));
topSheetDeepend.setDescription(T("|Specifies whether the top sheet should be deepend.|"));
topSheetDeepend.setCategory(categories[5]);

PropDouble sheetBelowTube(7, U(100), T("|Size sheet below tube|"));
sheetBelowTube.setDescription(T("|Sets the size of the top sheet below the tube.|"));
sheetBelowTube.setCategory(categories[5]);

PropDouble sheetAboveTube(8, U(100), T("|Size sheet above tube|"));
sheetAboveTube.setDescription(T("|Sets the size of the top sheet above the tube.|"));
sheetAboveTube.setCategory(categories[5]);

PropDouble thicknessTopSheet(9, U(18), T("|Thickness top sheet|"));
thicknessTopSheet.setDescription(T("|Sets the thickness of the top sheet.|"));
thicknessTopSheet.setCategory(categories[5]);

PropDouble gapAroundTopSheet(10, U(2), T("|Gap around top sheet|"));
gapAroundTopSheet.setDescription(T("|Sets the gap around the top sheet.|"));
gapAroundTopSheet.setCategory(categories[5]);

PropInt colorTopSheet(1, 1, T("|Color top sheet|"));
colorTopSheet.setDescription(T("|Sets the color of the top sheet.|"));
colorTopSheet.setCategory(categories[5]);

PropString materialTopSheet(10, "", T("|Material top sheet|"));
materialTopSheet.setDescription(T("|Sets the material of the top sheet.|"));
materialTopSheet.setCategory(categories[5]);

PropString labelTopSheet(11, "", T("|Label top sheet|"));
labelTopSheet.setDescription(T("|Sets the label of the top sheet.|"));
labelTopSheet.setCategory(categories[5]);

//region - 1.31
PropDouble gapAroundTubeForSheetCutOut(6, U(2), T("|Gap around tube for sheet cut out|"));
gapAroundTubeForSheetCutOut.setDescription(T("|Sets gap around the sheet tube for the sheet cut out|"));
gapAroundTubeForSheetCutOut.setCategory(categories[5]); 
PropDouble bottomGapForSheetCutOut(25, U(2), T("|Bottom gap for sheet cut out|"));
bottomGapForSheetCutOut.setCategory(categories[5]);
bottomGapForSheetCutOut.setDescription(T("|Sets the bottom gap for the sheet cut out.|"));
PropDouble topGapForSheetCutOut(22, U(2), T("|Top gap for sheet cut out|"));
topGapForSheetCutOut.setCategory(categories[5]);
topGapForSheetCutOut.setDescription(T("|Sets the top gap for the sheet cut out.|"));
PropDouble leftGapForSheetCutOut(23, U(2), T("|Left gap for sheet cut out|"));
leftGapForSheetCutOut.setCategory(categories[5]);
leftGapForSheetCutOut.setDescription(T("|Sets the left gap for the sheet cut out.|"));
PropDouble rightGapForSheetCutOut(24, U(2), T("|Right gap for sheet cut out|"));
rightGapForSheetCutOut.setCategory(categories[5]);
rightGapForSheetCutOut.setDescription(T("|Sets the right gap for the sheet cut out.|"));

PropDouble gapDepthBeamCut(25, U(2), T("|Depth beamcut gap|"));
gapDepthBeamCut.setCategory(categories[5]);
gapDepthBeamCut.setDescription(T("|Depth beamcut gap|"));
PropDouble gapHeightBeamCut(26, U(2), T("|Height beamcut gap|"));
gapHeightBeamCut.setCategory(categories[5]);
gapHeightBeamCut.setDescription(T("|Height beamcut gap|"));
PropDouble gapWidthBeamCut(27, U(2), T("|Width beamcut gap|"));
gapWidthBeamCut.setCategory(categories[5]);
gapWidthBeamCut.setDescription(T("|Width beamcut gap|"));
//endregion

// region - element tool
PropString sAddElementToolVertical(34, noYes, T("|Add element tool vertical|"));
sAddElementToolVertical.setCategory(categories[9]);

PropString sAddElementToolPerpendicular(37, noYes, T("|Add element tool perpendicular|"));
sAddElementToolPerpendicular.setCategory(categories[9]);

PropInt nToolIndex(4, 1, T("|Toolindex|"));
nToolIndex.setCategory(categories[9]);

PropDouble dExtraDepth(28, U(1), T("|Extra depth|"));
dExtraDepth.setCategory(categories[9]);
// endregion

// region - Tilelath cutout
PropString sAddExtraCounterBattens(35, noYes, T("|Add extra counterbattens|"));
sAddExtraCounterBattens.setCategory(categories[10]);

PropString sAddTilelathCutout(36, noYes, T("|Add tilelath cutout|"));
sAddTilelathCutout.setCategory(categories[10]);

PropDouble dOffsetFromTubeHorizontal(29, U(1), T("|Offset from tube horizontal|"));
dOffsetFromTubeHorizontal.setCategory(categories[10]);

PropDouble dOffsetFromTubeVertical(31, U(1), T("|Offset from tube vertical|"));
dOffsetFromTubeVertical.setCategory(categories[10]);

PropDouble dMinimumDistanceToAddCounterBattens(30, U(1), T("|Minimum distance to add counterbattens|"));
dMinimumDistanceToAddCounterBattens.setCategory(categories[10]);
// endregion
int arNZoneIndex[] = {0,1,2,3,4,5,6,7,8,9,10};
String arSZoneChar[] = {
	"Zone",
	"Info",
	"Dimension",
	"Tooling"
};
char arChZoneChar[] = {
	'Z',
	'I',
	'D',
	'T'
};
PropInt nZnIndexTube(0, arNZoneIndex, T("|Visualisation zone|"));
nZnIndexTube.setDescription(T("|Sets the zone index.|")
	+ TN("|The tube is assigned to this zone.|"));
nZnIndexTube.setCategory(categories[6]);

PropString sZoneCharTube(2, arSZoneChar, T("|Visualisation layer|"));
sZoneCharTube.setDescription(T("|Sets the element layer.|")
	+ TN("|The tube is assigned to the selected element layer.|"));
sZoneCharTube.setCategory(categories[6]);

PropInt labelColor(2, -1, T("|Label color|"));
labelColor.setDescription(T("|Specifies the label color.|"));
labelColor.setCategory(categories[6]);

PropString exportLabelDisplayProp(39, yesNo, T("|Export label|"), 1);
exportLabelDisplayProp.setDescription(T("|Specifies whether the label will be exported or not.|"));
exportLabelDisplayProp.setCategory(categories[6]);

PropString tubeLabelFormat(12, "ø@(Diameter)", T("|Tube label format|"));
tubeLabelFormat.setDescription(T("|Specifies the label to display next to the tube.|") + TN("|E.g.| 'd = @(Diameter) mm' ") + T("|will result in| 'd = 150 mm'") + TN("|E.g.| '@(Width) x @(Height) mm' ") + T("|will result in| '200 x 300 mm'"));
tubeLabelFormat.setCategory(categories[6]);

PropString dimensionStyleLabel(14, _DimStyles, T("|Dimension style label|"));
dimensionStyleLabel.setDescription(T("|Sets the dimension style to draw the label|"));
dimensionStyleLabel.setCategory(categories[6]);

PropDouble textHeightLabel(15, U(0), T("|Text height label|"));
textHeightLabel.setDescription(T("|Sets the text height for the label shown next to the tube.|") + TN("|The size specified in the dimension style will be used if the text height is zero or less.|"));
textHeightLabel.setCategory(categories[6]);

PropDouble xOffsetTubeLabel(13, U(0), T("X-|Offset tube label|"));
xOffsetTubeLabel.setDescription(T("|Sets the x offset for the label shown next to the tube.|"));
xOffsetTubeLabel.setCategory(categories[6]);

PropDouble yOffsetTubeLabel(14, U(0), T("Y-|Offset tube label|"));
yOffsetTubeLabel.setDescription(T("|Sets the x offset for the label shown next to the tube.|"));
yOffsetTubeLabel.setCategory(categories[6]);

PropString subTypePrefix(13, "",  T("|Subtype prefix|"));
subTypePrefix.setDescription(T("|Adds a prefix to the dimension subtypes.|"));
subTypePrefix.setCategory(categories[6]);
//endregion

String recalcTriggers[] = {
	T("|Delete tube|"),
	T("|Copy to other element|")
};
for (int r=0;r<recalcTriggers.length();r++)
	addRecalcTrigger(_kContext, recalcTriggers[r]);

//region bOnInsert
// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_R-Tube");
if( _bOnDbCreated && arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

//Insert
if( _bOnInsert ){
	if (insertCycleCount() > 1) {
		eraseInstance();
		return;
	}
	// show the dialog if no catalog in use
	if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	else
		setPropValuesFromCatalog(_kExecuteKey);
	
	_Element.append(getElement(T("|Select an element|")));
	_Pt0 = getPoint(T("|Select an insertion point|"));
	
	return;
}
//endregion

//region Resolve properties

int openingIsRectangular = (openingShapes.find(openingShapeProp, 0) == 1);
int openingIsRound = !openingIsRectangular;
int addElementToolVertical = noYes.find(sAddElementToolVertical);
int addElementToolPerpendicular = noYes.find(sAddElementToolPerpendicular);
int addTilelathCutout = noYes.find(sAddTilelathCutout);
int addExtraCounterBattens = noYes.find(sAddExtraCounterBattens);

double tubeDiameter = dDiamOriginal;
if (dDiamOverrule > 0)
	tubeDiameter = dDiamOverrule;
double openingWidth = tubeDiameter;
double openingHeight = tubeDiameter;

if (openingIsRectangular)
{
	openingWidth = openingWidthProp;
	openingHeight = openingHeightProp;
}


int bTubeIsVertical = (arSOrientation.find(sOrientation,0) == 0);
int bTubeIsPerpendicularToElement = (arSOrientation.find(sOrientation,0) == 1);
int nReference = arSReference.find(sReference,1);

int drawTube = yesNo.find(drawTubeProp,0) == 0;
String tubeLabel = tubeLabelFormat;
int formatIndex = tubeLabel.find("@(Diameter)", 0);

if (formatIndex != -1)
	tubeLabel = tubeLabel.left(formatIndex) + tubeDiameter + tubeLabel.right(tubeLabel.length() - (formatIndex + "@(Diameter)".length()));
formatIndex = tubeLabel.find("@(Width)", 0);
if (formatIndex != -1) 
	tubeLabel = tubeLabel.left(formatIndex) + openingWidth + tubeLabel.right(tubeLabel.length() - (formatIndex + "@(Width)".length()));
formatIndex = tubeLabel.find("@(Height)", 0);
if (formatIndex != -1) 
	tubeLabel = tubeLabel.left(formatIndex) + openingHeight + tubeLabel.right(tubeLabel.length() - (formatIndex + "@(Height)".length()));

int exportLabelDisplay = (yesNo.find(exportLabelDisplayProp, 1) == 0);

int createTubeSectionAsSheet = (yesNo.find(createTubeSectionAsSheetProp,1) == 0);
int createTubeAsBeam = (yesNo.find(createTubeAsBeamProp,1) == 0);

int applyLeftTrimmer = (yesNo.find(applyLeftTrimmerProp,0) == 0);
int applyRightTrimmer = (yesNo.find(applyRightTrimmerProp,0) == 0);

int bOnlyTopTrimmer = trimmerConfigurations.find(trimmerConfiguration,1) == 0;
int bOnlyHorizontalTrimmers = trimmerConfigurations.find(trimmerConfiguration,1) == 2;
int bNoTrimmers = trimmerConfigurations.find(trimmerConfiguration,1) == 3;

int applyVerticalTrimmers = !bNoTrimmers && !bOnlyTopTrimmer && !bOnlyHorizontalTrimmers && (applyLeftTrimmer || applyRightTrimmer);

int bAllowRaftersToSplit = yesNo.find(sAllowRaftersToSplit,0) == 0;
int bAlignTrimmersWithTube = yesNo.find(sAlignTrimmersWithTube ,0) == 0;

int createTopSheet = (yesNo.find(createTopSheetProp, 1) == 0);

char chZoneCharTube = arChZoneChar[arSZoneChar.find(sZoneCharTube,0)];
int nZoneIndexTube = nZnIndexTube;
if (nZoneIndexTube > 5)
	nZoneIndexTube = 5 - nZoneIndexTube;
	
String filterDef = filterDefinition;
//endregion

//region Element validation and assignment of TSL to its group
if( _Element.length() == 0 ){
	eraseInstance();
	return;
}

Element el = _Element[0];
ElementRoof elRf = (ElementRoof)el;
assignToElementGroup(el, true, 0, 'E');
//endregion

if (_kExecuteKey == recalcTriggers[1]) // Copy to another element.
{
	Element newElement = getElement(T("|Select a new element|"));
	Point3d newPosition = getPoint(T("|Select a position|"));
	
	String strScriptName = scriptName();
	Vector3d vecUcsX(1,0,0);
	Vector3d vecUcsY(0,1,0);
	Beam lstBeams[0];
	Entity lstEntities[] = { newElement };
	
	Point3d lstPoints[] = { newPosition };
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	Map mapTsl;
	
	TslInst newTube;
	newTube.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
	newTube.setPropValuesFromMap(_ThisInst.mapWithPropValues());
	newTube.recalc();
}

for (int index=0;index<_Map.length();index++) 
{ 
	if (_Map.keyAt(index) != "DimInfo") continue;
	_Map.removeAt(index, true);
	index--;
}

//region set display
Display dpTube(tubeColor);
dpTube.elemZone(el, nZoneIndexTube, chZoneCharTube);
dpTube.showInDxa(true);

Display labelDisplay(labelColor);
labelDisplay.elemZone(el, nZoneIndexTube, chZoneCharTube);
labelDisplay.dimStyle(dimensionStyleLabel);
if (textHeightLabel != 0)
	labelDisplay.textHeight(textHeightLabel);

if (exportLabelDisplay)
{
	labelDisplay.showInDxa(true);
}
//endregion

//Useful set of vectors.
CoordSys csEl = el.coordSys();
Point3d elOrg = csEl.ptOrg();
Vector3d vx = el.vecX();
Vector3d vy = el.vecY();
Vector3d vz = el.vecZ();

if (elRf.bIsValid() && elRf.bPurlin())
{
	vx = el.vecY();
	vy = el.vecX();
}

PlaneProfile battenProfile = el.profBrutto(5);

int rafterTypes[] = 
{
	_kDakCenterJoist, 
	_kRafter,
	_kDakLeftEdge,
	_kDakRightEdge
};

String rafterBeamCodes[] = 
{
	"SP"
};

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

Map mapSplit = _Map.getMap("SplitGenBeams");
Map mapSplitX = _ThisInst.subMapX("SplitGenBeams");

// Recreate split entities
for (int m = 0; m < mapSplit.length(); m++)
{
	if (mapSplit.keyAt(m) != "EntityToRecreate" || !mapSplit.hasMap(m) || !mapSplitX.hasMap(m)) continue;
	
	Map entityToRecreateMap = mapSplit.getMap(m);
	Map entityToRecreateMapX = mapSplitX.getMap(m);
	
	Body body = entityToRecreateMap.getBody("Body");
	int entityType = entityToRecreateMap.getInt("EntityType"); //0 = beam 1 = sheet
	Vector3d genBeamX = entityToRecreateMap.getVector3d("GenBeamX");
	Vector3d genBeamY = entityToRecreateMap.getVector3d("GenBeamY");
	Vector3d genBeamZ = entityToRecreateMap.getVector3d("GenBeamZ");
	double length = entityToRecreateMap.getDouble("Length");
	double width = entityToRecreateMap.getDouble("Width");
	double height = entityToRecreateMap.getDouble("Height");
	Point3d center = entityToRecreateMap.getPoint3d("PtOrg");
	int color = entityToRecreateMap.getInt("Color");
	String label = entityToRecreateMap.getString("Label");
	String subLabel = entityToRecreateMap.getString("SubLabel");
	String subLabel2 = entityToRecreateMap.getString("SubLabel2");
	String grade = entityToRecreateMap.getString("Grade");
	String information = entityToRecreateMap.getString("Information");
	String module = entityToRecreateMap.getString("Module");
	String name = entityToRecreateMap.getString("Name");
	String material = entityToRecreateMap.getString("Material");
	String beamCode = entityToRecreateMap.getString("BeamCode");
	int isotropic = entityToRecreateMap.getInt("Isotropic");
	int zone = entityToRecreateMap.getInt("Zone");
	int beamType = entityToRecreateMap.getInt("BeamType");
	String extrusionProfile = entityToRecreateMap.getString("ExtrusionProfile");
	String tslHandle = entityToRecreateMap.getString("TslHandle");
	String elementHandle = entityToRecreateMap.getString("ElementHandle");
	Point3d elementOrg = entityToRecreateMap.getPoint3d("ElementOrg");
	Point3d tslOrg = entityToRecreateMap.getPoint3d("TslOrg");
	
	if (elementHandle == el.handle() && tslHandle == _ThisInst.handle() && elementOrg == el.ptOrg()) //move in same element
	{
		body = entityToRecreateMapX.getBody("Body");	
		center = entityToRecreateMapX.getPoint3d("PtOrg");
	}
	else if (tslHandle != _ThisInst.handle() && elementHandle == el.handle()) //copy in same element
	{
		continue;
	} 
	// else is mirror/copy/rotate of tsl + element
	
	if (entityType == 0) //beam
	{
		Beam zoneBeams[] = el.beam();
		Beam newBeam;
		newBeam.dbCreate(body, center, genBeamX, genBeamY, genBeamZ, width, height);
		
		newBeam.setColor(color);
		newBeam.setLabel(label);
		newBeam.setSubLabel(subLabel);
		newBeam.setSubLabel2(subLabel2);
		newBeam.setGrade(grade);
		newBeam.setInformation(information);
		newBeam.setModule(module);
		newBeam.setName(name);
		newBeam.setMaterial(material);
		newBeam.setBeamCode(beamCode);
		newBeam.setIsotropic(isotropic);
		newBeam.setType(beamType);
		if (extrusionProfile != _kExtrProfRectangular)
		{
			Point3d originalCenterPoint = newBeam.ptCenSolid();
			
			newBeam.setExtrProfile(extrusionProfile);
			
			Point3d newCenterPoint = newBeam.ptCenSolid();
			
			newBeam.transformBy(genBeamX * genBeamX.dotProduct(originalCenterPoint - newCenterPoint));
			newBeam.transformBy(genBeamY * genBeamY.dotProduct(originalCenterPoint - newCenterPoint));
			newBeam.transformBy(genBeamZ * genBeamZ.dotProduct(originalCenterPoint - newCenterPoint));
		}
		newBeam.assignToElementGroup(el, true, zone, 'Z');
		
		int amountOfJoins = 0;
		for (int index = 0; index < zoneBeams.length(); index++)
		{
			Beam beam = zoneBeams[index];
			if ( ! beam.bIsValid()) continue;
			Body extendedBeamBody(beam.ptCen(), beam.vecX(), beam.vecY(), beam.vecZ(), beam.solidLength() + U(1), beam.solidWidth() + U(1), beam.solidHeight(), 0, 0, 0);
			if ( ! extendedBeamBody.hasIntersection(body)) continue;
			newBeam.dbJoin(beam);
			amountOfJoins ++;
		}
		
		if (amountOfJoins < 1)
		{
			newBeam.dbErase();
		}
	}
	else if (entityType == 1) //sheet
	{
		Sheet zoneSheets[] = el.sheet(zone);
		
		Sheet newSheet;
		newSheet.dbCreate(body, genBeamX, genBeamY, genBeamZ, false, U(100));
		
		newSheet.setColor(color);
		newSheet.setLabel(label);
		newSheet.setSubLabel(subLabel);
		newSheet.setSubLabel2(subLabel2);
		newSheet.setGrade(grade);
		newSheet.setInformation(information);
		newSheet.setModule(module);
		newSheet.setName(name);
		newSheet.setMaterial(material);
		newSheet.setBeamCode(beamCode);
		newSheet.setIsotropic(isotropic);
		newSheet.setType(beamType);
		newSheet.assignToElementGroup(el, true, zone, 'Z');
		
		int amountOfJoins = 0;
		for (int index = 0; index < zoneSheets.length(); index++)
		{
			Sheet sheet = zoneSheets[index];
			if ( ! sheet.bIsValid()) continue;
			Body extendedSheetBody(sheet.ptCen(), sheet.vecX(), sheet.vecY(), sheet.vecZ(), sheet.solidLength() + U(1), sheet.solidWidth() + U(1), sheet.solidHeight(), 0, 0, 0);
			if ( ! extendedSheetBody.hasIntersection(body)) continue;
			newSheet.dbJoin(sheet);
			amountOfJoins ++;
		}
		
		if (amountOfJoins < 1)
		{
			newSheet.dbErase();
		}
		
	}
}

mapSplit = Map();
mapSplitX = Map();

_Map = Map();
Line lnX(elOrg, vx);
PlaneProfile elProfile(el.plEnvelope());
//map for creating toolpath tsls
Map cncData = _Map.getMap("Hsb_CNCData");
Map ToolPaths;
Map mapJJS = el.subMapX("Hsb_jjs");
for (int index=0;index<mapJJS.length();index++) 
{ 
	if (!mapJJS.hasMap(index)) continue;
	Map elipse = mapJJS.getMap(index);
	String handle = elipse.getString("Handle"); 
	Point3d origin = elipse.getPoint3d("Origin");
	origin.vis(1);
	if (handle == _ThisInst.handle() || elProfile.pointInProfile(origin) != _kPointInProfile)
	{
		mapJJS.removeAt(index, true);
		index--;
	}
}

if (_kExecuteKey == recalcTriggers[0])
{
	if (mapJJS.length() > 0)
	{
		el.setSubMapX("Hsb_jjs", mapJJS);
	}
	else 
	{
		el.removeSubMapX("Hsb_jjs");
	}
	eraseEntity();
	return;
}

Beam allBeams[] = el.beam();
Beam filteredBeams[0];
Entity beamEntities[0];

//region filter
for (int i = 0; i<allBeams.length();i++)
{
	beamEntities.append(allBeams[i]);
}

Map filterGenBeamsMap;
filterGenBeamsMap.setEntityArray(beamEntities, false, "GenBeams", "GenBeams", "GenBeam");
int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, filterDef, filterGenBeamsMap);
if (!successfullyFiltered)
{
	reportWarning(T("|Beams could not be filtered!|") + TN("|Make sure the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
	eraseInstance();
	return;
}

beamEntities = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");

for (int i = 0; i < beamEntities.length(); i++)
{
	filteredBeams.append((Beam)beamEntities[i]);
}
//endregion

Beam rafters[0];
Beam interesectingBeams[0];
Beam beamsRight[] = Beam().filterBeamsHalfLineIntersectSort(filteredBeams, _Pt0 + vz * el.dBeamHeight() * 0.5 ,vx );
Beam beamsLeft[] = Beam().filterBeamsHalfLineIntersectSort(filteredBeams, _Pt0 + vz * el.dBeamHeight() * 0.5 ,-vx );
//Beam beamsRight[] = Beam().filterBeamsHalfLineIntersectSort(filteredBeams, _Pt0, vx);
//Beam beamsLeftt[] = Beam().filterBeamsHalfLineIntersectSort(filteredBeams, _Pt0, -vx);
interesectingBeams.append(beamsRight);
interesectingBeams.append(beamsLeft);
Point3d rafterPositions[0];
for (int b=0;b<interesectingBeams.length();b++) {
	Beam bm = interesectingBeams[b];
	
	if ((rafterTypes.find(bm.type()) != -1 || rafterBeamCodes.find(bm.beamCode()) != -1) && abs(abs(bm.vecX().dotProduct(vy)) - 1) < vectorTolerance) 
	{
		rafters.append(bm);
		rafterPositions.append(bm.ptCen());
	}
}

Sheet arSh[] = el.sheet();
Sheet internalSheeting[0];
Sheet externalSheeting[0];
Sheet zone01Sheeting[0];
Sheet tileLaths[0];
int externalZones[0];
int internalZones[0];
for (int s=0;s<arSh.length();s++) {
	Sheet sh = arSh[s];
	if (sh.name() == tubeDescription || sh.material() == tubeMaterial) continue;
	if (sh.myZoneIndex() == 1)
	{
		zone01Sheeting.append(sh);
	}	
	
	if (sh.myZoneIndex() < 0)
	{
		internalSheeting.append(sh);
		if (internalZones.find(sh.myZoneIndex()) == -1 && el.zone(sh.myZoneIndex()).dH() > vectorTolerance)
		{
			internalZones.append(sh.myZoneIndex());
		}
	}
	else if (sh.myZoneIndex() > 0 && sh.myZoneIndex() < 5)
	{
		externalSheeting.append(sh);
		if (externalZones.find(sh.myZoneIndex()) == -1 && el.zone(sh.myZoneIndex()).dH() > vectorTolerance && sh.myZoneIndex() != 4)
		{
			externalZones.append(sh.myZoneIndex());
		}
		
	}
	else if (sh.myZoneIndex() == 5)
	{
		tileLaths.append(sh);
	}
}

//Project insertion point to bottom zone 0
Point3d ptBottom = el.ptOrg() - vz * el.zone(0).dH();
//Project insertion point to bottom of inside zones
if (nReference == 1) {
	for( int i=-1;i>-5;i-- )
		ptBottom = ptBottom - vz * el.zone(i).dH();
}

Plane pnPt0( ptBottom, vz );
Line lnPt0( _Pt0, _ZU );
_Pt0 = lnPt0.intersect(pnPt0,0);

//Vector for direction of tube
Vector3d vTube = _ZW; // Vertical is the default.
if (bTubeIsPerpendicularToElement)
	vTube = vz;
vTube = vTube.rotateBy(dAngle, vx);

if( vTube.isParallelTo(vy) ){
	reportWarning(TN("|Tube is parallel with element, adjust angle|"));
	return;
}
Line lnTube( _Pt0, vTube);

//Find top of tube.
Point3d ptTop = el.ptOrg();
for( int i=1;i<5;i++ ){
	double dZone = el.zone(i).dH();
	ptTop += vz * dZone;
}

Plane pnTop( ptTop + vz * dOffsetTop, vz );
Point3d ptTubeTop = lnTube.intersect(pnTop, 0);
//ptTubeTop.vis(1);

//Find bottom of tube
Plane pnBottom( ptBottom - vz * dOffsetBottom, vz );
Point3d ptTubeBottom = lnTube.intersect(pnBottom, 0);
//ptTubeBottom.vis(3);

PlaneProfile tubeSlice(CoordSys(ptTubeTop, vTube.crossProduct(vx), vTube, vx));

Body tubeBody(ptTubeBottom - vTube * U(1000), ptTubeTop + vTube * U(1000), 0.5 * tubeDiameter);
tubeBody.subPart(Body(ptTubeBottom, vx, vy, vz, U(5000), U(5000), U(5000), 0, 0, -1));
tubeBody.subPart(Body(ptTubeTop, vx, vy, vz, U(5000), U(5000), U(5000), 0, 0, 1));
tubeSlice.unionWith(tubeBody.getSlice(Plane(ptTubeTop, vx)));
tubeBody.subPart(Body(ptTubeBottom - vTube * U(1000), ptTubeTop + vTube * U(1000), 0.5 * tubeDiameter - U(2)));
//tubeBody.vis();

//Draw tube
if (drawTube) {
	dpTube.draw(tubeBody);
}

if (tubeLabel != "")
{
//TODO
	String tubeLabels[0];
	String tempLabel = tubeLabel;

	while(tempLabel.find(';', 0) != -1)
	{
		tubeLabels.append(tempLabel.left(tempLabel.find(';', 0)));
		tempLabel.delete(0, tempLabel.find(';', 0) + 1);
	}
	
	tubeLabels.append(tempLabel);
	
	for(int t = 0; t < tubeLabels.length(); t++)
		labelDisplay.draw(tubeLabels[t], ptTubeBottom + vx * xOffsetTubeLabel + vy * (yOffsetTubeLabel - t * U(200)), vx, vy, 0, 0, _kDevice);
}

double dAngleTo = vz.angleTo(vTube);//,vx);
if( cos(dAngleTo) == 0 )return;

//Find position of trimming
Point3d ptTubeTopZn0 = lnTube.intersect(Plane(el.ptOrg(),vz), 0);
//ptTubeTopZn0.vis(220);
Point3d ptTubeBottomZn0 = lnTube.intersect(Plane(el.ptOrg() - vz * el.zone(0).dH(),vz), 0);//pnPt0,0);
//ptTubeBottomZn0.vis(120);

double dBmW = el.dBeamHeight();
double dBmH = el.dBeamWidth();

if (dWTrimmers > 0)
	dBmW = dWTrimmers;
	
double dAlignedHeight = el.dBeamWidth()/abs(cos(dAngleTo)) + dBmW * abs(tan(dAngleTo));	

if (bAlignTrimmersWithTube)
	dBmH = dAlignedHeight;
if (dHTrimmers > 0)
	dBmH = dHTrimmers;

double dDist = (0.5 * openingHeight + dBmW + offsetHorizontalTrimmersFromTube)/abs(cos(dAngleTo));
Point3d ptTrimmingTop = ptTubeTopZn0 + vy * dDist;
Point3d ptTrimmingBottom = ptTubeTopZn0 - vy * (dDist - dBmW/abs(cos(dAngleTo)));
if (!bAlignTrimmersWithTube) {
	if( vy.dotProduct(ptTubeTopZn0 - ptTubeBottomZn0) < 0 )
		ptTrimmingTop += vy * el.dBeamWidth() * abs(tan(dAngleTo));
	else
		ptTrimmingBottom -= vy * el.dBeamWidth() * abs(tan(dAngleTo));
}

dDist = 0.5 * (openingWidth + dBmW) + offsetVerticalTrimmersFromTube;
Point3d ptTrimmingLeft = ptTubeTopZn0 - vx *  dDist;
Point3d ptTrimmingRight = ptTubeTopZn0 + vx *  dDist;
//ptTrimmingTop.vis(40);
//ptTrimmingBottom.vis(70);
//ptTrimmingLeft.vis(130);
//ptTrimmingRight.vis(170);

// Create cut-out in internal sheeting.  
// The tube outline will be projected to the inside of the frame and the inside of the element.
// The two projected polylines are combined and used as tool.
//vTube.vis(ptTubeBottom, 1);
Plane pnInsideFrame(el.zone(-1).coordSys().ptOrg(), vz);
Plane pnInsideElement(el.zone(-99).coordSys().ptOrg(), vz);
Vector3d vTubePerp = vTube.crossProduct(vx);
// The tube outline.
PLine tubeOutline(vTube);
if (openingIsRound)
{
	tubeOutline.createCircle(ptTubeBottomZn0, vTube, 0.5 * tubeDiameter);
	tubeOutline.convertToLineApprox(U(0.05));
}
else if (openingIsRectangular)
{
	tubeOutline.createRectangle(LineSeg(ptTubeBottomZn0 - vTubePerp * ((0.5 * openingHeight) + bottomGapForSheetCutOut) - vx * ((0.5 * openingWidth) + leftGapForSheetCutOut), ptTubeBottomZn0 + vTubePerp * ((0.5 * openingHeight) +topGapForSheetCutOut) + vx * ((0.5 * openingWidth) + rightGapForSheetCutOut)), vx, vTubePerp);
}
tubeOutline.vis(1);

// The shape of the cut out in the internal sheeting.
PlaneProfile internalCutProfile(el.zone(-1).coordSys());
// Inside frame
PLine internalCutOutline = tubeOutline;
internalCutOutline.projectPointsToPlane(pnInsideFrame, vTube);
//internalCutOutline.vis(3);
internalCutProfile.joinRing(internalCutOutline, _kAdd);
// Inside element
internalCutOutline = tubeOutline;
internalCutOutline.projectPointsToPlane(pnInsideElement, vTube);
//internalCutOutline.vis(3);
internalCutProfile.joinRing(internalCutOutline, _kAdd);
// Apply gap around tube for cut out.

// 1.31
if(openingIsRound)
	internalCutProfile.shrink(-gapAroundTubeForSheetCutOut);

//internalCutProfile.vis(2);
LineSeg internalCutOutExtremes = internalCutProfile.extentInDir(vx);

//reportNotice("\ninternalCutProfile: " + internalCutProfile.numRings());
if (internalCutProfile.numRings() > 0) {
	PLine cutOutRings[] = internalCutProfile.allRings();
	internalCutOutline = cutOutRings[0];
	
	//	CoordSys cs = internalCutOutline.coordSys();
	//	Plane plane(cs.ptOrg(), cs.vecZ());
	//	double dMaxDeviation = U(1); // 1 mm
	//	PLine plFreeProf;
	//	plFreeProf.createSmoothArcsApproximation(plane, internalCutOutline.vertexPoints(true), dMaxDeviation);
	//	plFreeProf.close();
	//	for (int index=0;index<internalZones.length();index++)
	//	{
	//		int zone = internalZones[index];
	//		Map toolPath;
	//		toolPath.appendInt("Zone", zone);
	//		toolPath.setPLine("Path", plFreeProf);
	//		ToolPaths.appendMap("ToolPath", toolPath);
	//	}
	//	//plFreeProf.vis(3);
	//	FreeProfile cutOut(plFreeProf, ptTubeBottomZn0);
	FreeProfile cutOut;
	if (openingIsRound && bTubeIsVertical)
	{
		CoordSys cs = internalCutOutline.coordSys();
		Plane plane(cs.ptOrg(), cs.vecZ());
		double dMaxDeviation = U(1); //1 mm
		PLine plFreeProf;
		plFreeProf.createSmoothArcsApproximation(plane, internalCutOutline.vertexPoints(true), dMaxDeviation);
		plFreeProf.close();
		PlaneProfile ppBottom(plFreeProf);
		for (int index = 0; index < internalZones.length(); index++)
		{
			int zone = internalZones[index];
			Map toolPath;
			toolPath.appendInt("Zone", zone);
			toolPath.setPLine("Path", plFreeProf);
			ToolPaths.appendMap("ToolPath", toolPath);
			
			Map ellipseMap;
			ellipseMap.setPoint3d("Origin", ptTubeBottomZn0);
			ellipseMap.setDouble("RadiusX", abs(vx.dotProduct(ppBottom.extentInDir(vx).ptStart() - ppBottom.extentInDir(vx).ptEnd())) / 2);
			ellipseMap.setDouble("RadiusY", abs(vy.dotProduct(ppBottom.extentInDir(vy).ptStart() - ppBottom.extentInDir(vy).ptEnd())) / 2);
			ellipseMap.setDouble("Angle", vTube.angleTo(vx)); //(between tube X and element X)
			ellipseMap.setInt("ZoneIndex", zone);
			ellipseMap.setInt("Type", 1); //(0 => Clockwise / 1 => Anti Clockwise)
			ellipseMap.setDouble("MillingDepth", el.zone(zone).dH() + U(1));
			ellipseMap.setInt("ToolIndex", 1);
			ellipseMap.setString("Handle", _ThisInst.handle());
			mapJJS.appendMap("Ellipse", ellipseMap);
			
			if (addElementToolVertical)
			{
				ElemMill elemMill(zone, plFreeProf, el.zone(zone).dH() + dExtraDepth, nToolIndex, _kLeft, _kTurnAgainstCourse, _kOverShoot);
				el.addTool(elemMill);
			}
		}
		cutOut = FreeProfile(plFreeProf, ptTubeBottomZn0);
	}
	else if (openingIsRound && bTubeIsPerpendicularToElement)
	{
		PLine plFreeProf;
		plFreeProf.createCircle(ptTubeBottomZn0, vTube, tubeDiameter * 0.5 + gapAroundTubeForSheetCutOut * 0.5);
		//plFreeProf.close();
		for (int index = 0; index < internalZones.length(); index++)
		{
			int zone = internalZones[index];
			Map toolPath;
			toolPath.appendInt("Zone", zone);
			toolPath.appendPoint3d("CenterPoint", ptTubeBottomZn0);
			toolPath.appendVector3d("Normal", vTube);
			toolPath.appendDouble("Radius", tubeDiameter * 0.5 + gapAroundTubeForSheetCutOut * 0.5);
			ToolPaths.appendMap("ToolPath", toolPath);
			
			if (addElementToolPerpendicular)
			{
				ElemMill elemMill(zone, plFreeProf, el.zone(zone).dH() + dExtraDepth, nToolIndex, _kLeft, _kTurnAgainstCourse, _kOverShoot);
				el.addTool(elemMill);				
			}
		}
		cutOut = FreeProfile(plFreeProf, ptTubeBottomZn0);
	}
	else if (openingIsRectangular)
	{
		for (int index = 0; index < internalZones.length(); index++)
		{
			int zone = internalZones[index];
			Map toolPath;
			toolPath.appendInt("Zone", zone);
			toolPath.setPLine("Path", internalCutOutline);
			ToolPaths.appendMap("ToolPath", toolPath);
			
			if ((addElementToolVertical && bTubeIsVertical) || (addElementToolPerpendicular && !bTubeIsVertical))
			{
				ElemMill elemMill(zone, internalCutOutline, el.zone(zone).dH() + dExtraDepth, nToolIndex, _kLeft, _kTurnAgainstCourse, _kOverShoot);
				el.addTool(elemMill);
			}
		}
		cutOut = FreeProfile(internalCutOutline, ptTubeBottomZn0);
	}
	//cutOut.cuttingBody().vis(6);
	int numberOfSheetsCut = cutOut.addMeToGenBeamsIntersect(internalSheeting);
	//reportNotice("\nnumberOfSheetsCut: " + numberOfSheetsCut);
}

Map mapDimInfo;

// Create sheet on top of tube
Sheet topSheet;
if (createTopSheet || externalSheeting.length() > 0)
{
	double planeOffset = thicknessTopSheet;
	if ( ! createTopSheet)
	{
		planeOffset = abs(vz.dotProduct(el.zone(4).ptOrg() - ptTubeTopZn0));
	}
	Plane pnTopFrame(ptTubeTopZn0, vz);
	Plane pnInsideElement(el.zone(-99).coordSys().ptOrg(), vz);
	Plane pnTopTopSheet(ptTubeTopZn0 + vz * planeOffset, vz);
	
	// The shape of the cut out in the external sheeting.
	PlaneProfile topSheetCutProfile(csEl);
	// Inside frame
	PLine topSheetCutOutline = tubeOutline;
	topSheetCutOutline.projectPointsToPlane(pnTopFrame, vTube);
	topSheetCutProfile.joinRing(topSheetCutOutline, _kAdd);
	// Inside element
	topSheetCutOutline = tubeOutline;
	topSheetCutOutline.projectPointsToPlane(pnTopTopSheet, vTube);
	topSheetCutProfile.joinRing(topSheetCutOutline, _kAdd);
	// Apply gap around tube for cut out.
	
	// 1.31
	if (openingIsRound)
		topSheetCutProfile.shrink(-gapAroundTubeForSheetCutOut);
	
	//	topSheetCutProfile.vis(2);
	
	// Take the extremes of the cut out in the top sheet. Reposition these extremes to the rafters on the left and right.
	LineSeg cutOutExtremes = topSheetCutProfile.extentInDir(vx);
	//	cutOutExtremes.vis(2);
	Point3d topSheetStart = cutOutExtremes.ptStart() - vy * sheetBelowTube;
	Point3d topSheetEnd = cutOutExtremes.ptEnd() + vy * sheetAboveTube;
	// The start position of the top sheet is on the rafter left from the tube.
	rafterPositions = lnX.orderPoints(rafterPositions);
	
	int startPositionSet;
	for (int r = 0; r < rafterPositions.length(); r++) {
		Point3d rafterPosition = rafterPositions[r];
		rafterPosition.vis(r);
		double distanceToRafter = vx.dotProduct(topSheetStart - rafterPosition);
		if (distanceToRafter < 0) {
			topSheetStart += vx * vx.dotProduct(rafterPositions[r] - topSheetStart);
			startPositionSet = true;
			break;
		}
	}
	
	if (! startPositionSet && battenProfile.area() > vectorTolerance)
	{
		LineSeg startSegMent(topSheetStart, topSheetStart + vx * U(10000));
		LineSeg splittedSegments[] = battenProfile.splitSegments(startSegMent, true);
		if (splittedSegments.length() == 1)
		{
			topSheetStart += vx * vx.dotProduct(splittedSegments[0].ptEnd() - topSheetStart);	
		}
	}
	
	int endPositionSet;
	// The start position of the top sheet is on the rafter right from the tube.
	for (int r = (rafterPositions.length() - 1); r >= 0; r--) {
		Point3d rafterPosition = rafterPositions[r];
		double distanceToRafter = vx.dotProduct(topSheetEnd - rafterPosition);
		
		if (distanceToRafter > 0) 
		{
			topSheetEnd += vx * vx.dotProduct(rafterPositions[r] - topSheetEnd);
			endPositionSet = true;
			break;
		}
	}
	
	if (! endPositionSet && battenProfile.area() > vectorTolerance)
	{
		LineSeg endSegMent(topSheetEnd, topSheetEnd - vx * U(10000));
		LineSeg splittedSegments[] = battenProfile.splitSegments(endSegMent, true);
		if (splittedSegments.length() == 1)
		{
			topSheetEnd += vx * vx.dotProduct(splittedSegments[0].ptEnd() - topSheetEnd);	
		}
	}
	
	//Add check if beams left or right have a different width than the width set in the element settings.
	double dbmWLeft;
	double dbmWRight;
	
	if(beamsLeft.length() > 0)
	{
		dbmWLeft = beamsLeft[0].solidWidth();
		Point3d leftptCen = beamsLeft[0].ptCen();
		leftptCen.vis();		
	}
	else
	{
		dbmWLeft = dBmW;
	}
	if(beamsRight.length() > 0)
	{
		dbmWRight = beamsRight[0].solidWidth();
	}
	else
	{
		dbmWRight = dBmW;
	}
		
	startPositionSet ? topSheetStart += vx * 0.5 * dbmWRight : topSheetStart;
 	endPositionSet ? topSheetEnd -= vx * 0.5 * dbmWLeft : topSheetEnd;
	topSheetStart.vis(1);
	topSheetEnd.vis(2);
	// The extremes of the top sheet.
	LineSeg topSheetExtremes(topSheetStart, topSheetEnd);
	//	topSheetExtremes.vis(1);
	PLine topSheetOutline(vz);
	topSheetOutline.createRectangle(topSheetExtremes, vx, vy);
	PlaneProfile topSheetProfile(el.coordSys());
	topSheetProfile.joinRing(topSheetOutline, _kAdd);
	PlaneProfile intersectingProfile = topSheetProfile;
	intersectingProfile.intersectWith(battenProfile);
	int isNotRectangular = false;
	PLine allRings[] = intersectingProfile.allRings();
	if (allRings.length() > 0)
	{
		PLine outLine = allRings[0];
		Point3d profileVerteces[] = outLine.vertexPoints(false);
		for (int index = 0; index < profileVerteces.length() -1; index++)
		{
			Point3d thisPoint = profileVerteces[index];
			Point3d nextPoint = profileVerteces[index + 1];
			
			Vector3d edgeVector(nextPoint - thisPoint);
			edgeVector.normalize();
			
			if (abs(edgeVector.dotProduct(vx)) > vectorTolerance &&  abs(edgeVector.dotProduct(vy)) > vectorTolerance)
			{
				isNotRectangular = true;
			}
			
		}
	}

	if (battenProfile.area() > vectorTolerance && isNotRectangular)
	{
		int hasIntersection = topSheetProfile.intersectWith(battenProfile);
	}
	
	if (createTopSheet)
	{
		topSheet.dbCreate(topSheetProfile, thicknessTopSheet, 1);
		topSheet.setColor(colorTopSheet);
		topSheet.assignToElementGroup(el, true, 1, 'Z');
		topSheet.setMaterial(materialTopSheet);
		topSheet.setSubLabel(labelTopSheet);
		_Map.appendEntity("EntityToDelete", topSheet);
		arSh.append(topSheet);
		
	}
	
	FreeProfile cutOut;
	if (topSheetCutProfile.numRings() > 0)
	{
		PLine cutOutRings[] = topSheetCutProfile.allRings();
		topSheetCutOutline = cutOutRings[0];
		
		if (openingIsRound && bTubeIsVertical)
		{
			CoordSys cs = topSheetCutOutline.coordSys();
			Plane plane(cs.ptOrg(), cs.vecZ());
			double dMaxDeviation = U(1); //1 mm
			PLine plFreeProf;
			plFreeProf.createSmoothArcsApproximation(plane, topSheetCutOutline.vertexPoints(true), dMaxDeviation);
			plFreeProf.close();
			PlaneProfile ppTop(plFreeProf);
			for (int index = 0; index < externalZones.length(); index++)
			{
				int zone = externalZones[index];
				Map toolPath;
				toolPath.appendInt("Zone", zone);
				toolPath.setPLine("Path", plFreeProf);
				ToolPaths.appendMap("ToolPath", toolPath);
				
				Map ellipseMap;
				ellipseMap.setPoint3d("Origin", ptTubeTopZn0);
				ellipseMap.setDouble("RadiusX", abs(vx.dotProduct(ppTop.extentInDir(vx).ptStart() - ppTop.extentInDir(vx).ptEnd())) / 2);
				ellipseMap.setDouble("RadiusY", abs(vy.dotProduct(ppTop.extentInDir(vy).ptStart() - ppTop.extentInDir(vy).ptEnd())) / 2);
				ellipseMap.setDouble("Angle", vTube.angleTo(vx)); //(between tube X and element X)
				ellipseMap.setInt("ZoneIndex", zone);
				ellipseMap.setInt("Type", 1); //(0 => Clockwise / 1 => Anti Clockwise)
				ellipseMap.setDouble("MillingDepth", el.zone(zone).dH() + U(1));
				ellipseMap.setInt("ToolIndex", 1);
				ellipseMap.setString("Handle", _ThisInst.handle());
				mapJJS.appendMap("Ellipse", ellipseMap);
				
				if (addElementToolVertical)
				{
					ElemMill elemMill(zone, plFreeProf, el.zone(zone).dH() + dExtraDepth, nToolIndex, _kLeft, _kTurnAgainstCourse, _kOverShoot);
					el.addTool(elemMill);
				}
			}
			cutOut = FreeProfile(plFreeProf, ptTubeTopZn0);
		}
		else if (openingIsRound && bTubeIsPerpendicularToElement)
		{
			PLine plFreeProf;
			plFreeProf.createCircle(ptTubeTopZn0, vTube, tubeDiameter * 0.5 + gapAroundTubeForSheetCutOut * 0.5);
			//plFreeProf.close();
			for (int index = 0; index < externalZones.length(); index++)
			{
				int zone = externalZones[index];
				Map toolPath;
				toolPath.appendInt("Zone", zone);
				toolPath.appendPoint3d("CenterPoint", ptTubeTopZn0);
				toolPath.appendVector3d("Normal", vTube);
				toolPath.appendDouble("Radius", tubeDiameter * 0.5 + gapAroundTubeForSheetCutOut * 0.5);
				ToolPaths.appendMap("ToolPath", toolPath);
				
				if (addElementToolPerpendicular)
				{
					ElemMill elemMill(zone, plFreeProf, el.zone(zone).dH() + dExtraDepth, nToolIndex, _kLeft, _kTurnAgainstCourse, _kOverShoot);
					el.addTool(elemMill);
				}
				
			}
			cutOut = FreeProfile(plFreeProf, ptTubeTopZn0);
		}
		else if (openingIsRectangular)
		{
			for (int index = 0; index < externalZones.length(); index++)
			{
				int zone = externalZones[index];
				Map toolPath;
				toolPath.appendInt("Zone", zone);
				toolPath.setPLine("Path", tubeOutline);
				ToolPaths.appendMap("ToolPath", toolPath);
				
				if ((addElementToolVertical && bTubeIsVertical) || (addElementToolPerpendicular && !bTubeIsVertical))
				{
					ElemMill elemMill(zone, tubeOutline, el.zone(zone).dH() + dExtraDepth, nToolIndex, _kLeft, _kTurnAgainstCourse, _kOverShoot);
					el.addTool(elemMill);
				}
			}
			cutOut = FreeProfile(tubeOutline, ptTubeTopZn0);
		}
		
		cutOut.addMeToGenBeamsIntersect(externalSheeting);
	}
	
	if (topSheetDeepend == T("Yes"))
	{
		Point3d originalPoint = topSheet.ptCen();
		
		if (bTubeIsVertical)
		{
			topSheet.transformBy(- vTube * (thicknessTopSheet + gapDepthBeamCut) / cos(dAngleTo));
			cutOut.transformBy(- vTube * (thicknessTopSheet + gapDepthBeamCut) / cos(dAngleTo));
			topSheetExtremes.transformBy(- vTube * (thicknessTopSheet + gapDepthBeamCut) / cos(dAngleTo));
		}
		else
		{
			topSheet.transformBy(- vTube * (thicknessTopSheet + gapDepthBeamCut));
		}
		
		Body topSheetBody = topSheet.realBody();
		BeamCut beamCut(topSheet.ptCen() - vz * thicknessTopSheet * 0.5, vx, vy, vz, topSheetBody.lengthInDirection(vx) + (gapWidthBeamCut * 2), topSheetBody.lengthInDirection(vy) + (gapHeightBeamCut * 2), thicknessTopSheet + gapDepthBeamCut + tolerance, 0, 0, 1);
		
		beamCut.addMeToGenBeamsIntersect(filteredBeams);
		
	}
	
	// create tilelath cutout
	if (addTilelathCutout)
	{
		Point3d tileLathCutOutLeft = _Pt0 - vx * (tubeDiameter * 0.5 + dOffsetFromTubeHorizontal);
		Point3d tileLathCutOutRight = _Pt0 + vx * (tubeDiameter * 0.5 + dOffsetFromTubeHorizontal);
		
		Point3d topLeftCutout = tileLathCutOutLeft + vTubePerp * (tubeDiameter * 0.5 + dOffsetFromTubeVertical);
		Point3d bottomRightCutout = tileLathCutOutRight - vTubePerp * (tubeDiameter * 0.5 + dOffsetFromTubeVertical);
		
		PlaneProfile rectangleCutout(CoordSys(_Pt0, vx, vTubePerp, vTube));
		rectangleCutout.createRectangle(LineSeg(topLeftCutout, bottomRightCutout), vx, vTubePerp);
		rectangleCutout.vis(5);
		PlaneProfile intersectionBodyPlaneProfile(CoordSys(_Pt0, vx, vTubePerp, vTube));
		intersectionBodyPlaneProfile.createRectangle(LineSeg(topLeftCutout, bottomRightCutout), vx, vTubePerp);
		PLine rectanglePlinesBody[] = intersectionBodyPlaneProfile.allRings();
		PLine rectanglePlineBody = rectanglePlinesBody[0];
		Body cutOutBodyIntersection(rectanglePlineBody, vTube * U(2000), 0);
		
		topLeftCutout += vTubePerp * U(1000);
		bottomRightCutout -= vTubePerp * U(1000);
		PlaneProfile rectangleCutoutBody(CoordSys(_Pt0, vx, vTubePerp, vTube));
		rectangleCutoutBody.createRectangle(LineSeg(topLeftCutout, bottomRightCutout), vx, vTubePerp);
		PLine rectanglePlines[] = rectangleCutoutBody.allRings();
		PLine rectanglePline = rectanglePlines[0];
		Body cutOutBody(rectanglePline, vTube * U(2000), 0);
		
		Sheet tilelaths[] = el.sheet(5);
		
		for (int index = 0; index < tilelaths.length(); index++)
		{
			Sheet tilelath = tilelaths[index];
			PlaneProfile tilelathProfile = tilelath.profShape();
			Body resultingBody = tilelath.realBody();
			
			if ( ! resultingBody.hasIntersection(cutOutBodyIntersection)) continue;
			
			// add the tileLath to the map to be recreated
			Map entityToRecreateMap;
			resultingBody.intersectWith(cutOutBody);
			entityToRecreateMap.setBody("Body", resultingBody);
			entityToRecreateMap.setPoint3d("ElementOrg", el.ptOrg(), _kAbsolute);
			entityToRecreateMap.setPoint3d("TslOrg", _Pt0, _kAbsolute);
			entityToRecreateMap.setVector3d("GenBeamX", tilelath.vecX());
			entityToRecreateMap.setVector3d("GenBeamY", tilelath.vecY());
			entityToRecreateMap.setVector3d("GenBeamZ", tilelath.vecZ());
			entityToRecreateMap.setDouble("Length", tilelath.dL());
			entityToRecreateMap.setDouble("Width", tilelath.dW());
			entityToRecreateMap.setDouble("Height", tilelath.dH());
			entityToRecreateMap.setPoint3d("PtOrg", tilelath.ptCen());
			entityToRecreateMap.setInt("EntityType", 1);
			entityToRecreateMap.setInt("Color", tilelath.color());
			entityToRecreateMap.setString("Label", tilelath.label());
			entityToRecreateMap.setString("SubLabel", tilelath.subLabel());
			entityToRecreateMap.setString("SubLabel2", tilelath.subLabel2());
			entityToRecreateMap.setString("Grade", tilelath.grade());
			entityToRecreateMap.setString("Information", tilelath.information());
			entityToRecreateMap.setString("Module", tilelath.module());
			entityToRecreateMap.setString("Name", tilelath.name());
			entityToRecreateMap.setString("Material", tilelath.material());
			entityToRecreateMap.setString("BeamCode", tilelath.beamCode());
			entityToRecreateMap.setInt("Isotropic", tilelath.isotropic());
			entityToRecreateMap.setInt("Zone", tilelath.myZoneIndex());
			entityToRecreateMap.setInt("BeamType", tilelath.type());
			entityToRecreateMap.setString("TslHandle", _ThisInst.handle());
			entityToRecreateMap.setString("ElementHandle", el.handle());
			
			mapSplit.appendMap("EntityToRecreate", entityToRecreateMap);
			mapSplitX.appendMap("EntityToRecreate", entityToRecreateMap);
			
			Sheet newTilelaths[] = tilelath.dbSplit(Plane(_Pt0, vx), tubeDiameter + 2 * dOffsetFromTubeHorizontal);
		}
	}
	
	Sheet counterBattens[] = el.sheet(4);
	if (addExtraCounterBattens && counterBattens.length() > 0)
	{
		
		PlaneProfile counterBattenProfile(el.coordSys());
		
		for (int index = 0; index < counterBattens.length(); index++)
		{
			Sheet counterBatten = counterBattens[index];
			PLine counterBattenOutLine = counterBatten.plEnvelope();
			
			counterBattenProfile.joinRing(counterBattenOutLine, _kAdd);
		}
		counterBattenProfile.shrink(- dMinimumDistanceToAddCounterBattens);
		Point3d tileLathCutOutLeft = ptTubeTop - vx * (tubeDiameter * 0.5 + dOffsetFromTubeHorizontal);
		Point3d tileLathCutOutRight = ptTubeTop + vx * (tubeDiameter * 0.5 + dOffsetFromTubeHorizontal);
		
		Point3d topLeftCutout = tileLathCutOutLeft + vy * (tubeDiameter * 0.5 + dOffsetFromTubeHorizontal + U(48));
		Point3d bottomRightCutout = tileLathCutOutRight - vy * (tubeDiameter * 0.5 + dOffsetFromTubeHorizontal + U(48));
		// extra cb left
		tileLathCutOutLeft += vz * vz.dotProduct(el.zone(4).coordSys().ptOrg() - tileLathCutOutLeft);
		tileLathCutOutLeft += vy * vy.dotProduct((topSheetExtremes.ptMid() - tileLathCutOutLeft));
		if (counterBattenProfile.pointInProfile(tileLathCutOutLeft) != _kPointInProfile)
		{
			Sheet extraCounterbatten;
			extraCounterbatten.dbCreate(tileLathCutOutLeft, vy, vx, vz, abs(vy.dotProduct(topSheetExtremes.ptStart() - topSheetExtremes.ptEnd())), elRf.dCounterLathWidth(), elRf.dCounterLathHeight(), 0, - 1, 1);
			extraCounterbatten.setColor(6);
			extraCounterbatten.assignToElementGroup(el, true, 4, 'Z');
			extraCounterbatten.setMaterial("TENGEL");
			_Map.appendEntity("EntityToDelete", extraCounterbatten);
		}
		
		// extra cb right
		tileLathCutOutRight += vz * vz.dotProduct(el.zone(4).coordSys().ptOrg() - tileLathCutOutRight);
		tileLathCutOutRight += vy * vy.dotProduct((topSheetExtremes.ptMid() - tileLathCutOutRight));
		if (counterBattenProfile.pointInProfile(tileLathCutOutRight) != _kPointInProfile)
		{
			Sheet extraCounterbatten;
			extraCounterbatten.dbCreate(tileLathCutOutRight, vy, vx, vz, abs(vy.dotProduct(topSheetExtremes.ptStart() - topSheetExtremes.ptEnd())), elRf.dCounterLathWidth(), elRf.dCounterLathHeight(), 0, 1, 1);
			extraCounterbatten.setColor(6);
			extraCounterbatten.assignToElementGroup(el, true, 4, 'Z');
			extraCounterbatten.setMaterial("TENGEL");
			_Map.appendEntity("EntityToDelete", extraCounterbatten);
		}
	}
	
	if (createTopSheet && topSheetDeepend != T("Yes"))
	{
		topSheetProfile.shrink(-gapAroundTopSheet);
		if (topSheetProfile.numRings() > 0) {
			PLine cutOutExternalSheetingRings[] = topSheetProfile.allRings();
			SolidSubtract cutOutExternalSheeting(Body(cutOutExternalSheetingRings[0], vz * 2 * thicknessTopSheet));
			int numberOfExternalSheetingsAffected = cutOutExternalSheeting.addMeToGenBeamsIntersect(externalSheeting);
		}
	}
	
	topSheet.addTool(cutOut);
	
	// Add dimension information.
	mapDimInfo = Map();
	mapDimInfo.setInt("ZoneIndex", 1);
	Point3d dimPoints[] = { cutOutExtremes.ptStart(), cutOutExtremes.ptEnd()};
	mapDimInfo.setPoint3dArray("Points", dimPoints);
	mapDimInfo.setString("SubType", subTypePrefix + "Sheet");
	_Map.appendMap("DimInfo", mapDimInfo);
}

double dWidth = openingWidth + 2 * (offsetVerticalTrimmersFromTube + dBmW);
double dHeight = (Vector3d(ptTrimmingTop - ptTrimmingBottom).length()) + dBmW;

mapDimInfo = Map();
mapDimInfo.setInt("ZoneIndex", 1);
Point3d arPtDimTop[] = {
	ptTrimmingTop + vx * (0.5 * openingWidth + offsetHorizontalTrimmersFromTube) - vy * dBmW/abs(cos(dAngleTo)),
	ptTrimmingBottom - vx * (0.5 * openingWidth + offsetHorizontalTrimmersFromTube)
};
mapDimInfo.setPoint3dArray("Points", arPtDimTop);
_Map.appendMap("DimInfo", mapDimInfo);

mapDimInfo = Map();
mapDimInfo.setInt("ZoneIndex", -1);
if (bAlignTrimmersWithTube)
{
	Point3d arPtDimBottom[] = 
	{
		ptTrimmingTop + vx * (0.5 * openingWidth + offsetHorizontalTrimmersFromTube) - vTube * (dAlignedHeight - dBmW * abs(tan(dAngleTo)))  - vy * dBmW/abs(cos(dAngleTo)),
		ptTrimmingBottom - vx * (0.5 * openingWidth + offsetHorizontalTrimmersFromTube) - vTube * (dAlignedHeight - dBmW * abs(tan(dAngleTo)))
	};
	mapDimInfo.setPoint3dArray("Points", arPtDimBottom);
}
_Map.appendMap("DimInfo", mapDimInfo);

mapDimInfo = Map();
mapDimInfo.setInt("ZoneIndex", -1);
Point3d dimPoints[] = {internalCutOutExtremes.ptStart(), internalCutOutExtremes.ptEnd()};
mapDimInfo.setPoint3dArray("Points", dimPoints);
mapDimInfo.setString("SubType", subTypePrefix + "Sheet");
_Map.appendMap("DimInfo", mapDimInfo);

cncData.setMap("ToolPath[]", ToolPaths);
_Map.setMap("Hsb_CNCData", cncData);

if (mapJJS.length() > 0)
{
	el.setSubMapX("Hsb_jjs", mapJJS);
}

PLine plOp(vTube);
plOp.createRectangle(LineSeg(ptTrimmingTop + vx * 0.5 * dWidth, ptTrimmingTop - vx * 0.5 * dWidth - vy * dHeight), vx, vy);

Body bdOp(plOp, vTube*U(1000), 0);
//dpTube.draw(bdOp);

//region Find beams to stretch to, left & right.
int arBExtraBmCreated[] = {false, false};
Point3d arPtHor[] = {ptTrimmingTop};
String beamCodesHorizontalTrimmers[] = { bmCodeTopTrimmer};
if (!bOnlyTopTrimmer)
{
	arPtHor.append(ptTrimmingBottom);
	beamCodesHorizontalTrimmers.append(bmCodeBottomTrimmer);
}

double height;
Beam filteredBeamsNotSplit[0];
Beam arBmSplit[0];
for ( int i = 0; i < arPtHor.length(); i++)
{
	Point3d pt = arPtHor[i];
	Line ln(pt, vx);
	
	for ( int j = 0; j < filteredBeams.length(); j++) {
		Beam bm = filteredBeams[j];
		
		if ( ! bm.bIsValid() || bm.bIsDummy() || bm.vecX().isParallelTo(vx) || ! bAllowRaftersToSplit || arBmSplit.find(bm) != -1) continue;
		
		Body bd(bm.realBody());
		if ( bd.hasIntersection(bdOp))
		{
			Point3d ptTo = ptTrimmingTop;
			Point3d ptFrom = ptTrimmingBottom - vy * dBmW;
			Point3d ptTmp;
			if ( bm.vecX().dotProduct(ptTo - ptFrom) > 0 ) {
				ptTmp = ptTo;
				ptTo = ptFrom;
				ptFrom = ptTmp;
			}
			
			// add the beam to the map to be recreated
			Map entityToRecreateMap;
			CoordSys invertedElCs = el.coordSys();
			invertedElCs.invert();
			
			Body resultingBody = bd;
			resultingBody.intersectWith(bdOp);
			entityToRecreateMap.setBody("Body", resultingBody);
			entityToRecreateMap.setPoint3d("ElementOrg", el.ptOrg(), _kAbsolute);
			entityToRecreateMap.setPoint3d("TslOrg", _Pt0, _kAbsolute);
			entityToRecreateMap.setVector3d("GenBeamX", bm.vecX());
			entityToRecreateMap.setVector3d("GenBeamY", bm.vecY());
			entityToRecreateMap.setVector3d("GenBeamZ", bm.vecZ());
			entityToRecreateMap.setDouble("Length", bm.dL());
			entityToRecreateMap.setDouble("Width", bm.dW());
			entityToRecreateMap.setDouble("Height", bm.dH());
			entityToRecreateMap.setPoint3d("PtOrg", bm.ptCen());
			entityToRecreateMap.setInt("EntityType", 0);
			entityToRecreateMap.setInt("Color", bm.color());
			entityToRecreateMap.setString("Label", bm.label());
			entityToRecreateMap.setString("SubLabel", bm.subLabel());
			entityToRecreateMap.setString("SubLabel2", bm.subLabel2());
			entityToRecreateMap.setString("Grade", bm.grade());
			entityToRecreateMap.setString("Information", bm.information());
			entityToRecreateMap.setString("Module", bm.module());
			entityToRecreateMap.setString("Name", bm.name());
			entityToRecreateMap.setString("Material", bm.material());
			entityToRecreateMap.setString("BeamCode", bm.beamCode());
			entityToRecreateMap.setInt("Isotropic", bm.isotropic());
			entityToRecreateMap.setInt("Zone", bm.myZoneIndex());
			entityToRecreateMap.setInt("BeamType", bm.type());
			entityToRecreateMap.setString("ExtrusionProfile", bm.extrProfile());
			entityToRecreateMap.setString("TslHandle", _ThisInst.handle());
			entityToRecreateMap.setString("ElementHandle", el.handle());
			
			Beam bmRest = bm.dbSplit(ptFrom, ptTo);
			
			mapSplit.appendMap("EntityToRecreate", entityToRecreateMap);
			mapSplitX.appendMap("EntityToRecreate", entityToRecreateMap);
			
			if (beamCodeSplitRaftersAboveTube != "")
			{
				if (vy.dotProduct(bm.ptCen() - bmRest.ptCen()) > 0)
				{
					bm.setBeamCode(beamCodeSplitRaftersAboveTube);
				}
				else
				{
					bmRest.setBeamCode(beamCodeSplitRaftersAboveTube);
				}
			}
			
			arBmSplit.append(bm);
			arBmSplit.append(bmRest);
			continue;
		}
		
	}
}
//endregion

_Map.setMap("SplitGenBeams", mapSplit);

if (mapSplitX.length() > 0)
{
	_ThisInst.setSubMapX("SplitGenBeams", mapSplitX);
}

filteredBeams.append(arBmSplit);
Beam notVerticalBeams[0];

for(int b= 0; b < filteredBeams.length(); b++)
{
	Beam bm = filteredBeams[b];

	if( !bm.bIsValid() || bm.bIsDummy())continue;
	
	if (!bm.vecX().isParallelTo(vy))
	{
		notVerticalBeams.append(bm);
	}
	
	if (arBmSplit.find(bm) == -1)
	{
		filteredBeamsNotSplit.append(bm);
	}
}

Beam maleBeamsForIntegration[0];
Beam femaleBeamsForIntegration[0];

//region Create horizontal trimming
Beam arBmHorTrimmer[0];
//reportNotice("Points:" + arPtHor + "Length:" +arPtHor.length());
if ( ! bNoTrimmers)
{
	for ( int i = 0; i < arPtHor.length(); i++)
	{
		Point3d pt = arPtHor[i];
		String bmCodeHorizontalTrimmer = beamCodesHorizontalTrimmers[i];
		int bExtraBmCreated = arBExtraBmCreated[i];
		
		Vector3d vxT = vx;
		Vector3d vyT = vy;
		Vector3d vzT = vz;
		
		double dh = dBmH;
		height = dAlignedHeight;
		if ( ! bAlignTrimmersWithTube)
		{
			height = el.dBeamWidth();
		}
		
		double extraHeightForSquare;
		if (bAlignTrimmersWithTube && squared == T("|Yes|"))
			extraHeightForSquare = abs(tan(dAngleTo) * dBmW);
		
		if (bAlignTrimmersWithTube)
		{
			vyT = vTube.crossProduct(vx);
			vzT = vTube;
		}
		
		if ((AlignmentTop == T("|Bottom|") && i == 0) || (AlignmentBottom == T("|Bottom|") && i == 1))
		{
			pt -= vzT * (height - extraHeightForSquare);
		}
		else
		{
			pt -= vzT * extraHeightForSquare;
		}
		
		Beam bm;
		if ((AlignmentTop == T("|Bottom|") && i == 0) || (AlignmentBottom == T("|Bottom|") && i == 1))
		{
			bm.dbCreate(pt, vxT, vyT, vzT, U(100), dBmW, dh, 0, - 1, 1);
		}
		else
		{
			bm.dbCreate(pt, vxT, vyT, vzT, U(100), dBmW, dh, 0, - 1, - 1);
		}
		
		bm.setColor(32);
		bm.assignToElementGroup(el, true, 0, 'Z');
		bm.setBeamCode(bmCodeHorizontalTrimmer);
		
		Beam arBmLeft[] = Beam().filterBeamsHalfLineIntersectSort(filteredBeamsNotSplit, bm.ptCen(), vxT);
		Beam arBmRight[] = Beam().filterBeamsHalfLineIntersectSort(filteredBeamsNotSplit, bm.ptCen(), - vxT);
		if (arBmLeft.length() > 0)
		{
			bm.stretchStaticTo(arBmLeft[0], true);
			
			if (integratedTimberTslCatalog != "")
			{
				maleBeamsForIntegration.append(bm);
				femaleBeamsForIntegration.append(arBmLeft[0]);
			}
		}
		
		if (arBmRight.length() > 0)
		{
			bm.stretchStaticTo(arBmRight[0], true);
			
			if (integratedTimberTslCatalog != "")
			{
				maleBeamsForIntegration.append(bm);
				femaleBeamsForIntegration.append(arBmRight[0]);
			}
			arBmHorTrimmer.append(bm);
		}
		
		Beam extraBeam;
		if (placeLeftOverBeam == (T("|Yes|")) && dHTrimmers > 0)
		{
			if ((AlignmentTop == T("|Bottom|") && i == 0) || (AlignmentBottom == T("|Bottom|") && i == 1))
			{
				pt += vzT * dh;
				double beamHeight = height - dh - extraHeightForSquare * 2;
				extraBeam.dbCreate(pt, vxT, vyT, vzT, U(100), dBmW, beamHeight, 0, - 1, 1);
				extraBeam.setColor(32);
				extraBeam.assignToElementGroup(el, true, 0, 'Z');
				extraBeam.setBeamCode(bmCodeHorizontalTrimmer);
				
				Beam arBmLeft[] = Beam().filterBeamsHalfLineIntersectSort(filteredBeamsNotSplit, extraBeam.ptCen(), vxT);
				Beam arBmRight[] = Beam().filterBeamsHalfLineIntersectSort(filteredBeamsNotSplit, extraBeam.ptCen(), - vxT);
				if (arBmLeft.length() > 0)
				{
					extraBeam.stretchStaticTo(arBmLeft[0], true);
					
					if (integratedTimberTslCatalog != "")
					{
						maleBeamsForIntegration.append(extraBeam);
						femaleBeamsForIntegration.append(arBmLeft[0]);
					}
				}
				
				if (arBmRight.length() > 0)
				{
					extraBeam.stretchStaticTo(arBmRight[0], true);
					
					if (integratedTimberTslCatalog != "")
					{
						maleBeamsForIntegration.append(extraBeam);
						femaleBeamsForIntegration.append(arBmRight[0]);
					}
				}
				arBmHorTrimmer.append(extraBeam);
			}
			else if (dHTrimmers > 0)
			{
				pt -= vzT * dh;
				double beamHeight = height - dh - extraHeightForSquare * 2;
				extraBeam.dbCreate(pt, vxT, vyT, vzT, U(100), dBmW, beamHeight, 0, - 1, - 1);
				extraBeam.setColor(32);
				extraBeam.assignToElementGroup(el, true, 0, 'Z');
				extraBeam.setBeamCode(bmCodeHorizontalTrimmer);
				
				Beam arBmLeft[] = Beam().filterBeamsHalfLineIntersectSort(filteredBeamsNotSplit, extraBeam.ptCen(), vxT);
				Beam arBmRight[] = Beam().filterBeamsHalfLineIntersectSort(filteredBeamsNotSplit, extraBeam.ptCen(), - vxT);
				if (arBmLeft.length() > 0)
				{
					extraBeam.stretchStaticTo(arBmLeft[0], true);
					
					if (integratedTimberTslCatalog != "")
					{
						maleBeamsForIntegration.append(extraBeam);
						femaleBeamsForIntegration.append(arBmLeft[0]);
					}
				}
				if (arBmRight.length() > 0)
				{
					extraBeam.stretchStaticTo(arBmRight[0], true);
					
					if (integratedTimberTslCatalog != "")
					{
						maleBeamsForIntegration.append(extraBeam);
						femaleBeamsForIntegration.append(arBmRight[0]);
					}
				}
				arBmHorTrimmer.append(extraBeam);
			}
			
		}
		
		if (squared == T("|No|"))
		{
			Point3d cutPointTop = arPtHor[i];
			Cut cutTop(cutPointTop, vz);
			Point3d cutPointBottom = cutPointTop;
			cutPointBottom -= vz * el.dBeamWidth();
			Cut cutBottom(cutPointBottom, - vz);
			if ((AlignmentTop == T("|Bottom|") && i == 0) || (AlignmentBottom == T("|Bottom|") && i == 1))
			{
				bm.addTool(cutBottom);
				extraBeam.addTool(cutTop);
				if (placeLeftOverBeam == T("No") || dHTrimmers < 0)
					bm.addTool(cutTop);
			}
			else
			{
				bm.addTool(cutTop);
				extraBeam.addTool(cutBottom);
				if (placeLeftOverBeam == T("No") || dHTrimmers < 0)
					bm.addTool(cutBottom);
			}
			
		}
		
		_Map.appendEntity("EntityToDelete", bm);
		_Map.appendEntity("EntityToDelete", extraBeam);
		
		
		for (int b = 0; b < arBmHorTrimmer.length(); b++)
		{
			Beam bmHor = arBmHorTrimmer[b];
			Point3d centerPoint = bmHor.ptCen();
			//	centerPoint.vis(0);
			for (int c = b + 1; c < arBmHorTrimmer.length(); c++)
			{
				Beam bmHorTwo = arBmHorTrimmer[c];
				if (bmHor == bmHorTwo)
					arBmHorTrimmer.removeAt(b);
				if (vy.dotProduct(bmHorTwo.ptCen() - bmHor.ptCen()) < vectorTolerance)
				{
					arBmHorTrimmer.swap(b, c);
				}
			}
		}
		
		if (arBmHorTrimmer.length() > 0)
		{
			for (int b = 0; b < arBmSplit.length(); b++)
			{
				Beam bmSplit = arBmSplit[b];
				Beam arBmTop[] = Beam().filterBeamsHalfLineIntersectSort(arBmHorTrimmer, bmSplit.ptCen(), vy);
				if (arBmTop.length() > 0)
				{
					bmSplit.stretchStaticTo(arBmTop[0], true);
				}
				Beam arBmBottom[] = Beam().filterBeamsHalfLineIntersectSort(arBmHorTrimmer, bmSplit.ptCen(), - vy);
				if (arBmBottom.length() > 0)
				{
					bmSplit.stretchStaticTo(arBmBottom[0], true);
				}
			}
		}
	}
	if (applyVerticalTrimmers && arBmHorTrimmer.length() > 0)
	{
//		if (arBmHorTrimmer.length() < 1)
//		{
//			reportNotice(T("|No top or bottom beam found!!|"));
//			eraseInstance();
//			return;
//		}
		//Find beams to stretch to, top & bottom.
		Point3d arPtVer[0];
		String bmCodeVerticalTrimmers[0];
		if (applyLeftTrimmer)
		{
			arPtVer.append(ptTrimmingLeft);
			bmCodeVerticalTrimmers.append(bmCodeLeftTrimmer);
		}
		if (applyRightTrimmer)
		{
			arPtVer.append(ptTrimmingRight);
			bmCodeVerticalTrimmers.append(bmCodeRightTrimmer);
		}
		
		//Create vertical trimming
		for ( int i = 0; i < arPtVer.length(); i++) {
			Point3d pt = arPtVer[i];
			
			String bmCodeVerticalTrimmer = bmCodeVerticalTrimmers[i];
			
			Beam bm;
			bm.dbCreate(pt + vy * vy.dotProduct((_Pt0 + vTube * 0.5 * el.dBeamWidth()) - pt), vy, vx, vz, U(1), dBmW, dHTrimmers > 0 ? dHTrimmers : el.dBeamWidth(), 0, 0, - 1);
			bm.setColor(32);
			bm.assignToElementGroup(el, true, 0, 'Z');
			bm.setBeamCode(bmCodeVerticalTrimmer);
			
			
			Beam arBmTop[] = Beam().filterBeamsHalfLineIntersectSort(arBmHorTrimmer, arPtVer[i] - vTube * U(10), bm.vecX());
			Beam arBmBottom[] = Beam().filterBeamsHalfLineIntersectSort(arBmHorTrimmer, arPtVer[i] - vTube * U(10), - bm.vecX());
			
			Vector3d vecCut = bTubeIsVertical && bAlignTrimmersWithTube ? _ZW.crossProduct(vx) : bm.vecX();
			if (vecCut.dotProduct(bm.vecX()) < 0)
			{
				vecCut *= -1;
			}
			
			if (arBmBottom.length() > 0)
			{
				Cut bottomCut(Plane(arBmBottom[0].ptCen() + vecCut * arBmBottom[0].dD(vecCut) * 0.5, vecCut), bm.ptCen(), 0);
				bm.addToolStatic(bottomCut, _kStretchOnInsert);
				
				if (integratedTimberTslCatalog != "")
				{
					maleBeamsForIntegration.append(bm);
					femaleBeamsForIntegration.append(arBmBottom[0]);
				}
			}
			
			if (arBmTop.length() > 0)
			{
				Cut topCut(Plane(arBmTop[0].ptCen() - vecCut * arBmTop[0].dD(vecCut) * 0.5, vecCut), bm.ptCen(), 0);
				bm.addToolStatic(topCut, _kStretchOnInsert);
				
				if (integratedTimberTslCatalog != "")
				{
					maleBeamsForIntegration.append(bm);
					femaleBeamsForIntegration.append(arBmTop[0]);
				}
				
			}	
			
			_Map.appendEntity("EntityToDelete", bm);
		}
	}
	
}
//endregion

double tubeLength = (Vector3d(ptTubeTop - ptTubeBottom)).length() + openingHeight * abs(tan(dAngleTo));

// Set flag to create hardware.
int bAddHardware = _bOnDbCreated;
if (addHardwareEvents.find(_kNameLastChangedProp) != -1)
	bAddHardware = true;

// add hardware if model has changed or on creation
if (bAddHardware) {
	// declare hardware comps for data export
	HardWrComp hwComps[0];
	if (drawTube)
	{
		HardWrComp hw(articleNumber, 1);
		
		hw.setCategory(hwCategory);
		hw.setManufacturer("");
		hw.setModel(articleNumber);
		hw.setMaterial(tubeMaterial);
		hw.setDescription(tubeDescription);
		hw.setDScaleX(tubeLength);
		hw.setDScaleY(openingWidth);
		hw.setDScaleZ(openingHeight); 
		hwComps.append(hw);
	}
	_ThisInst.setHardWrComps(hwComps);
}	

Sheet tubeSectionSheet;
if (createTubeSectionAsSheet && tubeSlice.area() > areaTolerance) 
{
	tubeSectionSheet.dbCreate(tubeSlice, U(0.01), 0);
	_Map.appendEntity("EntityToDelete", tubeSectionSheet);
	tubeSectionSheet.setMaterial(tubeMaterial);
	tubeSectionSheet.setLabel(tubeLabel);
	tubeSectionSheet.setName(tubeDescription);
	tubeSectionSheet.setBeamCode(tubeMaterial);
	tubeSectionSheet.setInformation(articleNumber);
	tubeSectionSheet.setColor(tubeColor);
	tubeSectionSheet.assignToElementGroup(el, true, -5, 'Z');
}

Beam tubeBeam;
if (createTubeAsBeam && tubeBody.volume() > volumeTolerance) 
{
	tubeBeam.dbCreate(_Pt0, vTube, vx, vy, U(10000), tubeDiameter, tubeDiameter);
	_Map.appendEntity("EntityToDelete", tubeBeam);
	tubeBeam.setMaterial(tubeMaterial);
	tubeBeam.setLabel(tubeLabel);
	tubeBeam.setName(tubeDescription);
	tubeBeam.setBeamCode(tubeMaterial);
	tubeBeam.setInformation(articleNumber);
	tubeBeam.setColor(tubeColor);
	tubeBeam.setExtrProfile(_kExtrProfRound); 
	tubeBeam.assignToElementGroup(el, true, 0, 'Z');
	Cut cutBottom(ptTubeBottom, -vz);
	Cut cutTop(ptTubeTop, vz);
	Drill tubeDrill(ptTubeBottom - vTube * U(1000), ptTubeTop + vTube * U(1000), 0.5 * tubeDiameter - tolerance);
	tubeBeam.addTool(cutBottom, _kStretchOnInsert);
	tubeBeam.addTool(cutTop, _kStretchOnInsert);
	tubeBeam.addTool(tubeDrill);
}

if (_ThisInst.numHardWrComps() > 0)
{
	HardWrComp hwComps[] = _ThisInst.hardWrComps();
	HardWrComp hardWare = hwComps[0];
	if (tubeSectionSheet.bIsValid())
		hardWare.setLinkedEntity(tubeSectionSheet);
	//reportNotice("\nLinked to entity :" +hardWare.linkedEntity());
	hwComps[0] = hardWare;
	_ThisInst.setHardWrComps(hwComps);
}

// create integrate tooling
for (int index = 0; index < maleBeamsForIntegration.length(); index++)
{
	// prepare tsl cloning
	TslInst tslNew;
	Vector3d vecXTsl = maleBeamsForIntegration[index].vecX();
	Vector3d vecYTsl = maleBeamsForIntegration[index].vecY();
	GenBeam gbsTsl[] = { maleBeamsForIntegration[index], femaleBeamsForIntegration[index]};
	Entity entsTsl[] = { };
	Point3d ptsTsl[] = { };
	int nProps[] ={ };
	double dProps[] ={ };
	String sProps[] ={ };
	Map mapTsl;
	tslNew.dbCreate(integratedTimberTslName, vecXTsl, vecYTsl, gbsTsl, entsTsl, ptsTsl, integratedTimberTslCatalog, true, mapTsl, "", "");
}


String compareKey = openingWidth + "-" + openingHeight + "-" + tubeLength + "-" + tubeMaterial + "-" + tubeDescription + "-" + articleNumber + "-" + tubeColor;
setCompareKey(compareKey);





#End
#BeginThumbnail
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
,4`%%%%`!1110!__9
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
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Make sure check for trimmers does not delete tsl" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="26" />
      <str nm="Date" vl="5/29/2024 9:10:20 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Expose label display. Correct label for rectangular shapes." />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="25" />
      <str nm="Date" vl="2/22/2023 8:05:14 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add tolerance to the drill in the tube beam, to prevent a invalid drill on the tube beam with the same diameter as the beam itself." />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="24" />
      <str nm="Date" vl="1/24/2023 2:06:53 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Fix check for labelTextHeight, when chanced by user." />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="23" />
      <str nm="Date" vl="5/31/2022 9:42:06 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Correct check for point3d" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="22" />
      <str nm="Date" vl="4/22/2022 10:17:32 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add point and widt/height to recontruct split rafters" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="21" />
      <str nm="Date" vl="4/21/2022 1:44:25 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add check if origin of elipse is still in profile of element (there where issues with mirror/copy)" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="20" />
      <str nm="Date" vl="3/3/2022 4:11:24 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Make topsheet stretch to the center of the rafters left and right when they have a divergent width." />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="19" />
      <str nm="Date" vl="7/9/2021 10:39:12 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add support for purlin elements" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="18" />
      <str nm="Date" vl="4/22/2021 3:25:51 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add vertical offset for tilelath cutout" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="17" />
      <str nm="Date" vl="4/22/2021 12:26:08 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Use counterlath with and height of element to cretae extra counterbattens" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="16" />
      <str nm="Date" vl="4/22/2021 12:01:49 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End