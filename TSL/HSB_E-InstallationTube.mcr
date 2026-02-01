#Version 8
#BeginDescription
#Versions
1.34 07/05/2025 Make sure that side of mill has unique index Author: Robert Pol
Version 1.33 3-12-2024 Switch before and after option because it was wrong in the last change. Ronald van Wijngaarden
Version 1.32 25-11-2024 Add option to change the location of the segment description. Place it before or after the segment length. Ronald van Wijngaarden
Version 1.31 25.04.2024 HSB-21950 bugfix description indentation conflicting format resolving , Author Thorsten Huck
Version 1.30 18-3-2024 Add option to round the individual tube lengths in the description. Ronald van Wijngaarden
Version 1.29 13-3-2024 Set propertnumbering as it was in version 1.25. Ronald van Wijngaarden
Version 1.28 31-1-2024 Add option to show extra text with the lengths of the individual segments. Ronald van Wijngaarden
Version 1.27 30-1-2024 Add option to show the lengths of the individual segments. Ronald van Wijngaarden
1.26 15/11/2023 Start and end description added. Add grips for descriptions. - Author: Anno Sportel
1.25 25/10/2023 Add elemmill for sheeting Author: Robert Pol
1.24 10.11.2021 HSB-13556: fix side of installation tube Author: Marsel Nakuci
Version1.23 12-10-2021 Improve side of tube check. Don't default to backside when the user overrides. , Author Ronald van Wijngaarden
1.22 21/05/2021 Add mill offset propertie Author: Robert Pol














#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 34
#KeyWords tube,installation
#BeginContents
//region history revision
/// <summary Lang=en>
/// This tsl creates an electrical tube in a wall.
/// </summary>

/// <insert>
/// Select an element and points to describe the path
/// </insert>

/// <remark Lang=en>
/// Main info is collected from HSB_E-InstallationPoint tsl (if input type == 0)
/// </remark>


/// <history>
// #Versions
//1.34 07/05/2025 Make sure that side of mill has unique index Author: Robert Pol
//1.33 3-12-2024 Switch before and after option because it was wrong in the last change. Ronald van Wijngaarden
//1.32 25-11-2024 Add option to change the location of the segment description. Place it before or after the segment length. Ronald van Wijngaarden
// 1.31 25.04.2024 HSB-21950 bugfix description indentation conflicting format resolving , Author Thorsten Huck
//1.30 18-3-2024 Add option to round the individual tube lengths in the description. Ronald van Wijngaarden
//1.29 13-3-2024 Set propertnumbering as it was in version 1.25. Ronald van Wijngaarden
//1.28 31-1-2024 Add option to show extra text with the lengths of the individual segments. Ronald van Wijngaarden
//1.27 30-1-2024 Add option to show the lengths of the individual segments. Ronald van Wijngaarden
// 1.26 15/11/2023 Start and end description added. Add grips for descriptions. - Author: Anno Sportel
//1.25 25/10/2023 Add elemmill for sheeting Author: Robert Pol
// Version 1.24 10.11.2021 HSB-13556: fix side of installation tube Author: Marsel Nakuci
//1.23 12-10-2021 Improve side of tube check. Don't default to backside when the user overrides. , Author Ronald van Wijngaarden
//1.22 21/05/2021 Add mill offset propertie Author: Robert Pol




/// 1.00 - 14.03.2013 - 	Pilot version
/// 1.01 - 20.06.2013 - 	Add tooling
/// 1.02 - 20.06.2013 - 	Bugfix position drill
/// 1.03 - 20.12.2013 - 	Rename from HSB_E-ElectricityTube to HSB_E-InstallationTube.
/// 1.04 - 21.01.2014 - 	Add option to draw tube.
/// 1.05 - 10.03.2014 - 	??
/// 1.06 - 13.05.2015 - 	Only add element to _Element if it is not already added. (FogBugzId 1278)
/// 1.07 - 13.05.2015 - 	Add description to tube.
/// 1.08 - 27.05.2015 - 	Update thumbnail
/// 1.09 - 22.12.2016 - 	Assign description to same layer as tube.
/// 1.10 - 16.01.2017 - 	Add data for BOM
/// 1.11 - 12.04.2017 - 	Added "Depth offset" prop. (DR)
/// 1.12 - 18.04.2017 - 	Properties are now set through map if possible. Tube sets its properties to the map of the point tsl.
/// 1.13 - 12.06.2017	- 	Depth offset prop setReadOnly(true) removed. Installation point won't handle that anymore (DR)
///					-	TSL now relocates itself to front/center/back of element considering depth offset
/// DR - 1.14 - 30.06.2017	- Issue with offset solved
///						- Issue with duplicated tubes when changed props. solved
///						- Now the tube wil remember its own properties every time installation point is relocated/recalculated
/// 1.15 - 24.01.2018 - 	Add diameter and length also as Netto Width and Netto Length to the BOM data.
/// 1.16 - 13.11.2018 - 	Ignore case while searching for installation points.
/// 1.17 - 14.03.2019 - 	Make tube client friendly.
/// 1.18 - 31.05.2019 -	HSBCAD-521
/// 1.19 - 20.06.2019 -	Make no nail area optional, default to no.
/// 1.20 - 20.11.2019 -	Add 3d point array to _Map with the tubePoints for the tsl displayWallTubesOnFloors to use.
/// 1.21 - 08.07.2020 -	Set true color based on tube color
/// </history>
//endregion

//region basics and arrays
//Script uses mm
Unit (1,"mm");
double dEps = U(0.1);
// Flags.
String arSYesNo[] = { T("|Yes|"), T("|No|") };
String arSYesNo2[] = { T("|Yes|"), T("|Yes + description|"), T("|Yes rounded + description|"), T("|No|") };
int arNYesNo[] = {_kYes, _kNo};
String arSSideMill[] = {T("|Left|"), T("|Right|")};
int arNSideMill[] = {_kLeft, _kRight};
String arSTurningDirectionMill[] = {T("|Turn against course|"), T("|Turn with course|")};
int arNTurningDirectionMill[] = {_kTurnAgainstCourse, _kTurnWithCourse};

String arSInputMode[] = {
	T("|Based on installation point|"),
	T("|Based on element|")
};

String arSSideInstallationTube[] = {
	T("|Same as installation point|"),
	T("|Front|"), 
	T("|Back|"),
	T("|Center|")
};

int arNSideInstallationTube[] = {
	0,
	1,
	-1,
	0
};

//Frame- & soleplate tooling
String arSToolType[] = {
	T("|No tooling|"),
	T("|Drill|"),
	T("|Mill|")
};

String arSTubeVisualization[] = {
	T("|Tube|"),
	T("|Line|")
};
int arNTubeVisualization[] = {
	0,
	1
};

String arSZoneLayer[] = {
	"Tooling",
	"Information",
	"Zone",
	"Element"
};
char arChZoneCharacter[] = {
	'T',
	'I',
	'Z',
	'E'
};

String descriptionBeforeAfter[] = {
	T("|Before|"),
	T("|After|")
};
//endregion

//region OPM
// ---------------------------------------------------------------------------------------------------------------------------------------------
// Insertmode
String category;

category = T("|Insert|");
PropString sSeperator05(20, "", T("|Insert|"));
sSeperator05.setReadOnly(_kHidden);
sSeperator05.setCategory(category);
PropString sInsertMode(14, arSInputMode, T("|Input mode|"));
sInsertMode.setCategory(category);


// Type and position of the electrical tube
category = T("|Position|");
PropString sSeperator01(0, "", T("|Position|"));
sSeperator01.setReadOnly(_kHidden);
sSeperator01.setCategory(category);
PropString sSideInstallationPoint(1, "", T("|Side installation point|"));
sSideInstallationPoint.setReadOnly(true);
sSideInstallationPoint.setCategory(category);
PropString sSideInstallationTube(2, arSSideInstallationTube, T("|Side installation tube|"));
sSideInstallationTube.setCategory(category);
PropDouble dTubeDiameter(7, U(16), T("|Tube diameter|"));
dTubeDiameter.setCategory(category);
PropDouble dDepthOffset(9, 20, T("|Depth offset|"));
dDepthOffset.setCategory(category);

// Visualization
category = T("|Visualization|");
PropString sSeperator02(3, "", T("|Visualization|"));
sSeperator02.setReadOnly(_kHidden);
dDepthOffset.setCategory(category);
PropInt nTubeColor(0, 5, T("|Color of tube|"));
nTubeColor.setCategory(category);
PropString sTubeLineType(4, _LineTypes, T("|Line type of tube|"));
sTubeLineType.setCategory(category);
PropString sShowTube(16, arSTubeVisualization, T("|Tube visualization type|"));
sShowTube.setCategory(category);
PropString sZoneLayer(17, arSZoneLayer, T("|Assign to layer|"));
sZoneLayer.setCategory(category);
PropString sDescriptionStart(23, "", T("|Description Start|"));
sDescriptionStart.setCategory(category);
PropString sDescriptionEnd(24, "", T("|Description End|"));
sDescriptionEnd.setCategory(category);
PropString sDescription(18, "", T("|Segment Description|"));
sDescription.setCategory(category);
PropString descriptionSide(25, descriptionBeforeAfter, T("|Segment description before or after length|"));
descriptionSide.setCategory(category);
PropInt nColorDescriptionStartEnd(2, -1, T("|Color description start and end|"));
nColorDescriptionStartEnd.setCategory(category);
PropInt nColorDescription(1, -1, T("|Color description|"));
nColorDescription.setCategory(category);
PropDouble textSizeStartEnd(12, -U(1), T("|Text size start and end|"));
textSizeStartEnd.setCategory(category);
PropDouble dTextSize(8, -U(1), T("|Text size|"));
dTextSize.setCategory(category);
PropString sDimStyle(19, _DimStyles, T("|Dimension style|"));
sDimStyle.setCategory(category);
PropString sShowIndividualTubeLengths (56, arSYesNo2, T("Show individual tube lengths"), 0);
sShowIndividualTubeLengths.setCategory(category);

// Tool
category =  T("|Frame tooling| (F)");
PropString sSeperator03(5, "", T("|Frame tooling| (F)"));
sSeperator03.setReadOnly(true);
sSeperator03.setCategory(category);
PropString sToolTypeFrame(6, arSToolType, ("(F) |Tooltype frame|"));
sToolTypeFrame.setCategory(category);
PropString sFilterBCFrameTool(7,"",T("(F) |Filter beams with beamcode|"));
sFilterBCFrameTool.setCategory(category);


// Drill
category =  T("(F) |Drill|");
PropString sSeperator03a(8, "", T("(F) |Drill|"));
sSeperator03a.setReadOnly(_kHidden);
PropDouble dFrameDrillDiameter(0, U(22), T("(F) |Diameter drill|"));
dFrameDrillDiameter.setCategory(category);
PropDouble dFrameDrillOffset(6, U(0), T("(F) |Offset drill|"));
dFrameDrillOffset.setDescription(T("|Offset from tool position|.")+T(" |A negative value only affects drills which are positioned in the center|."));
dFrameDrillOffset.setCategory(category);

// Mill
category =  T("(F) |Mill|");
PropString sSeperator03b(9, "", T("(F) |Mill|"));
sSeperator03b.setReadOnly(_kHidden);
sSeperator03b.setCategory(category);
PropDouble dFrameMillDepth(1, U(30), T("(F) |Mill depth|"));
dFrameMillDepth.setCategory(category);
PropDouble dFrameMillWidth(2, U(50), T("(F) |Mill width|"));
dFrameMillWidth.setCategory(category);
PropDouble dFrameMillOffset(10, U(20), T("(F) |Mill offset|"));
dFrameMillOffset.setCategory(category);

// Soleplate tooling
category =  T("|Soleplate tooling| (SP)");
PropString sSeperator04(10, "", T("|Soleplate tooling| (SP)"));
sSeperator04.setReadOnly(_kHidden);
sSeperator04.setCategory(category);
PropString sBmCodeSolePlate(11, "SP", T("(SP) |Beamcode soleplate|"));
sBmCodeSolePlate.setCategory(category);
PropString sToolTypeSolePlate(12, arSToolType, T("(SP) |Tooltype|"));
sToolTypeSolePlate.setCategory(category);

//Drill
category =  T("(SP) |Drill|");
PropString sSeperator04a(13, "", T("(SP) |Drill|"));
sSeperator04a.setReadOnly(_kHidden);
sSeperator04a.setCategory(category);
PropDouble dSolePlateDrillDiameter(3, U(22), T("(SP) |Diameter drill|"));
dSolePlateDrillDiameter.setCategory(category);

// Mill
category =  T("(SP) |Mill|");
PropString sSeperator04b(15, "", T("(SP) |Mill|"));
sSeperator04b.setReadOnly(_kHidden);
sSeperator04b.setCategory(category);
PropDouble dSolePlateMillDepth(4, U(11), T("(SP) |Mill depth|"));
dSolePlateMillDepth.setCategory(category);
PropDouble dSolePlateMillWidth(5, U(50), T("(SP) |Mill width|"));
dSolePlateMillWidth.setCategory(category);
PropDouble dSolePlateMillOffset(11, U(20), T("(SP) |Mill offset|"));
dSolePlateMillOffset.setCategory(category);
String millDirections[] = {	T("|Forward|"),	T("|Backward|")};
PropString sApplyMill(54,arSYesNo, T("Apply mill sheet"), 1);
sApplyMill.setCategory(category);
PropString millDirectionProp(50, millDirections, T("Mill direction"));
millDirectionProp.setCategory(category);
PropInt nToolIndexMill(50,0, T("Toolindex mill"));
nToolIndexMill.setCategory(category);
PropDouble dExtraDepthMill(50, U(0), T("|Extra depth mill|"));
dExtraDepthMill.setCategory(category);
PropString sApplyVacuumMill(51,arSYesNo, T("Apply vacuum for mill"));
sApplyVacuumMill.setCategory(category);
PropString sSideMill(55, arSSideMill, T("|Side for mill|"));
sSideMill.setCategory(category);
PropString sTurningDirectionMill(52, arSTurningDirectionMill, T("|Turning direction mill|"));
sTurningDirectionMill.setCategory(category);
PropString sOvershootMill(53, arSYesNo, T("|Overshoot mill|"));
sOvershootMill.setCategory(category);

// No Nail Area
category =  T("|No Nail Area|");
String noYes[] = { T("|No|"), T("|Yes|")};
PropString noNailAreaSeperator(22, "", T("|No Nail Area|"));
noNailAreaSeperator.setReadOnly(_kHidden);
noNailAreaSeperator.setCategory(category);
PropString addNoNailAreaProp(21, noYes, ("|Apply no nail area|"), 0);
addNoNailAreaProp.setCategory(category);
//-------------------------------------------------------------------
// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_E-InstallationTube");
if( arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);
String catalogFromInstallationPoint="catalogFromInstallationPoint";
if( arSCatalogNames.find(catalogFromInstallationPoint) != -1 ) 
	setPropValuesFromCatalog(catalogFromInstallationPoint);
//endregion

//region _bOnInsert
if( _bOnInsert )
{
	if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	
	int nInputMode = arSInputMode.find(sInsertMode,0);
	
	if( nInputMode == 0 ){
		String sScriptNameInstallation = "HSB_E-InstallationPoint";
		TslInst tslElectra = getTslInst(T("|Select an installation point|"));
		if( tslElectra.bIsValid() && tslElectra.scriptName().makeUpper() == sScriptNameInstallation.makeUpper() )
			_Entity.append(tslElectra);
	}
	else{
		_Element.append(getElement(T("|Select an element|")));
	}
	
	_Pt0 = getPoint(T("|Select start position|"));
	Point3d ptLast = _Pt0;
	
	while( true ){
		PrPoint prPt(T("|Select next position|"), ptLast);
		if( prPt.go() == _kOk ){
			Point3d ptNext = prPt.value();
			_PtG.append(ptNext);
			ptLast = ptNext;
		}
		else{
			break;
		}
	}
	
	return;
}
//endregion

//region Resolve properties
// Insert
sInsertMode.setReadOnly(true);
int nInputMode = arSInputMode.find(sInsertMode,0);
// Tube
int nIndexSideInstallationTube = arSSideInstallationTube.find(sSideInstallationTube, 0);
int nSideInstallationTube = arNSideInstallationTube[nIndexSideInstallationTube];

// Visualization
int nTubeVisualization = arNTubeVisualization[arSTubeVisualization.find(sShowTube,0)];
// Tool
int nFrameToolType = arSToolType.find(sToolTypeFrame,0);
String sFBC = sFilterBCFrameTool + ";";
sFBC.makeUpper();
String arSExcludeBmCodeFrame[0];
int nIndexBC = 0; 
int sIndexBC = 0;
while(sIndexBC < sFBC.length()-1){
	String sTokenBC = sFBC.token(nIndexBC);
	nIndexBC++;
	if(sTokenBC.length()==0){
		sIndexBC++;
		continue;
	}
	sIndexBC = sFBC.find(sTokenBC,0);
	sTokenBC.trimLeft();
	sTokenBC.trimRight();
	arSExcludeBmCodeFrame.append(sTokenBC);
}
// Soleplate tooling
int nSolePlateToolType = arSToolType.find(sToolTypeSolePlate,0);
char chZoneCharacterTube = arChZoneCharacter[arSZoneLayer.find(sZoneLayer,0)];
int addNoNailArea = noYes.find(addNoNailAreaProp, 0);
//endregion

//Tooling - mill
int nApplyMill = arNYesNo[arSYesNo.find(sApplyMill, 1)];
int reverseMillDirection = millDirections.find(millDirectionProp, 0);
int bApplyVacuumMill = arNYesNo[arSYesNo.find(sApplyVacuumMill, 1)];
int nSideMill = arNSideMill[arSSideMill.find(sSideMill,0)];
int nTurningDirectionMill = arNTurningDirectionMill[arSTurningDirectionMill.find(sTurningDirectionMill,0)];
int bOvershootMill = arNYesNo[arSYesNo.find(sOvershootMill, 1)];


//Check if there is an installation tsl selected
if( nInputMode == 0 && _Entity.length() == 0 ){
	reportNotice(T("|No installation tsl selected|."));
	eraseInstance();
	return;
}
else if( nInputMode == 1 && _Element.length() == 0 ){
	reportNotice(T("|No element selected|."));
	eraseInstance();
	return;
}

TslInst tslInstallation;
Element el;
if( nInputMode == 0 ) // Based on installation point
{
	Entity ent = _Entity[0];
	if(!ent.bIsValid())
	{ 
		eraseInstance();
		return;
	}
	
	tslInstallation = (TslInst)ent; // WARNING: if you do a validation for tslInstallation it will fail (set to research later)

	el = tslInstallation.element();
	if(!el.bIsValid())
	{ 
		eraseInstance();
		return;
	}
	
	if (_Element.find(el) == -1)
		_Element.append(el);
		
}
else // Based on element
{
	el = _Element[0];
}

if( !el.bIsValid() ){
	reportNotice(T("|Invalid element selected|."));
	eraseInstance();
	return;
}

int nZoneIndex = 0;
char chZoneCharacter = 'E';
_ThisInst.assignToElementGroup(el, true, nZoneIndex, chZoneCharacter);

//Usefull set of vectors.
CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();
double dElWidth= el.zone(0).dH();
Point3d ptElBack= ptEl - vzEl*dElWidth;

// Get the side of the electricity point.
Map mapInstallationTsl;
if( nInputMode == 0 )
	mapInstallationTsl = tslInstallation.map();
Map mapInstallationPoint;
if( mapInstallationTsl.hasMap("Electra") )
	mapInstallationPoint = mapInstallationTsl.getMap("Electra");
int nSideInstallationPoint = mapInstallationPoint.getInt("Side");
sSideInstallationPoint.set(arSSideInstallationTube[1]);
if( nSideInstallationPoint < 0 )
	sSideInstallationPoint.set(arSSideInstallationTube[2]);
// Set the side to the side of the installation point by default. Override can be specified in the properties.
int nSide = nSideInstallationPoint;
if( nIndexSideInstallationTube > 0 )
	 nSide = nSideInstallationTube;

// Project points of tube always to the center of the frametool
Point3d ptToolCenter;
Vector3d vOffset;
//if( nFrameToolType == 1 ){
//	if( nSide == 0 )
//		ptToolCenter -= vzEl * dFrameDrillOffset;
//	else
//		ptToolCenter += vzEl * nSide * (0.5 * el.zone(0).dH() - abs(dFrameDrillOffset));
//}
//else{
//	ptToolCenter += vzEl * nSide * 0.5 * (el.zone(0).dH() - dFrameMillDepth);
//}
if(nInputMode==0) // Location same as installation point
{
	int nSideInstallationPoint=arSSideInstallationTube.find(sSideInstallationPoint,-1);
	// HSB-13556
	if(nSideInstallationPoint==2 && nIndexSideInstallationTube != 1) // Back, but user overrides to front
	{
		// installation point back, installation tube not front
		ptToolCenter=ptElBack;
		vOffset=vzEl;
	}
	else if(nSideInstallationPoint==2 && nIndexSideInstallationTube == 1)
	{ 
		// installation point back, installation tube front
		ptToolCenter=ptEl;
		vOffset=-vzEl;
	}
	else if(nSideInstallationPoint==1 && nIndexSideInstallationTube != 2)
	{ 
		// installation point front, installation tube not back
		ptToolCenter=ptEl;
		vOffset=-vzEl;
	}
	else // Front or default
	{
		// installation point front, installation tube back
		ptToolCenter=ptElBack;
		vOffset=vzEl;
	}
}
else // Based on element
{
	int nSideInstallationTube=arSSideInstallationTube.find(sSideInstallationTube,-1);
	if(nSideInstallationTube==2)  // Back
	{
		ptToolCenter=ptElBack;
		vOffset=vzEl;
	}
	else if(arSSideInstallationTube.find(sSideInstallationTube,-1)==3) // Back
	{
		ptToolCenter= ptEl-vzEl*dElWidth*.5;
		vOffset=vzEl;
	}
	else // Front or default
	{
		ptToolCenter=ptEl;
		vOffset=-vzEl;
	}
}

// Setting depth offset (direction based on placement side)
double dOffset=0;
ptToolCenter+=vOffset*dDepthOffset;
Plane pnToolCenter(ptToolCenter, vzEl);
_Pt0 = pnToolCenter.closestPointTo(_Pt0);
for( int i=0;i<_PtG.length();i++ )
	_PtG[i] = pnToolCenter.closestPointTo(_PtG[i]);

//Display
Display dpTube(nTubeColor);
dpTube.showInDxa(true);
dpTube.lineType(sTubeLineType);
dpTube.elemZone(el, nSide, chZoneCharacterTube);

_ThisInst.setColor(nTubeColor);

//Create the tube and find the point to draw the description. This is the midpoint of the longest segment.
PLine plTube(vzEl);
plTube.addVertex(_Pt0);
Point3d ptPrev = _Pt0;
Point3d ptDescription = ptPrev;
Vector3d vxDescription = vxEl;
double dLongestSegment = U(0);

//Segment lengths
double segmentLengths[0];
Point3d segmentMidPoints[0];
Vector3d segmentXVectors[0];

for( int i=0;i<_PtG.length();i++ ) {
	Point3d pt = _PtG[i];
	plTube.addVertex(pt);
	
	double dSegment = (pt - ptPrev).length();
	Vector3d vecDirection (pt - ptPrev);
	LineSeg segTemp (pt, ptPrev);
	segmentXVectors.append(vecDirection);
	segmentLengths.append(dSegment);
	segmentMidPoints.append(segTemp.ptMid());
	
	if (dSegment > dLongestSegment) {
		ptDescription = (pt + ptPrev)/2;
		vxDescription = (pt - ptPrev);
		dLongestSegment = dSegment;
	}
	ptPrev = pt;
}
vxDescription.normalize();

Display dpDescription(nColorDescription);
dpDescription.showInDxa(true);
dpDescription.elemZone(el, nSide, chZoneCharacterTube);

String resetDescriptionLocationsCommand = "Reset Description Locations";
addRecalcTrigger(_kContextRoot, resetDescriptionLocationsCommand);
if (_kExecuteKey == resetDescriptionLocationsCommand )
{
	_Grip.setLength(0);
}

double descriptionOffsetFromEnd = U(10);
Vector3d tubeDirectionStart = _PtG[0] - _Pt0;
tubeDirectionStart.normalize();
Point3d descriptionLocationStart = _Pt0 + tubeDirectionStart * descriptionOffsetFromEnd;

Vector3d tubeDirectionEnd = _PtG.last() - (_PtG.length() == 1 ? _Pt0 : _PtG[_PtG.length() - 2]);
tubeDirectionEnd.normalize();
Point3d descriptionLocationEnd = _PtG.last() - tubeDirectionEnd * descriptionOffsetFromEnd;

String descriptions[] = { sDescriptionStart, sDescription, sDescriptionEnd};
String descriptionGripNames[] = { "Start", "Mid", "End"};
Vector3d textDirections[] = { vxEl, vxDescription, vxEl};
Point3d defaultDescriptionLocations[] = { descriptionLocationStart, ptDescription, descriptionLocationEnd};
double textSizes[] = { textSizeStartEnd, dTextSize, textSizeStartEnd};
int descriptionColors[] = { nColorDescriptionStartEnd, nColorDescription, nColorDescriptionStartEnd};


if (sShowIndividualTubeLengths == "Yes"  || sShowIndividualTubeLengths == "Yes + description" || sShowIndividualTubeLengths == "Yes rounded + description")
{
	for (int g = 0; g < segmentMidPoints.length(); g++)
	{
		Point3d segmentMidPoint = segmentMidPoints[g];
		double segmentLength = segmentLengths[g];
		double roundedLength = round(segmentLength);
		if(sShowIndividualTubeLengths == "Yes rounded + description")
		{
			double newLength = (ceil(roundedLength / 10)*10);
			roundedLength = newLength;
		}
		Vector3d segmentVector = segmentXVectors[g];
		segmentVector.normalize();
		Vector3d segmentYVector = vzEl.crossProduct(segmentVector);
		segmentYVector.normalize();
		
		String descriptionToShow = (String)roundedLength;
		if(sShowIndividualTubeLengths == "Yes + description" || sShowIndividualTubeLengths == "Yes rounded + description")
		{
			if(descriptionSide == "After")
			{
				descriptionToShow += sDescription;
			}
			if(descriptionSide == "Before")
			{
				String newDescr = sDescription + descriptionToShow;
				descriptionToShow = newDescr;
			}
		}
		segmentMidPoint += segmentYVector * dTubeDiameter;
		dpDescription.textHeight(dTextSize);
		dpDescription.draw(descriptionToShow, segmentMidPoint, segmentVector, segmentYVector, 0, 2, _kDevice);	
	}
}

if(sShowIndividualTubeLengths == "No")
{
	for (int d = 0; d < descriptions.length(); d++)
	{
		String description = descriptions[d];
		String descriptionGripName = descriptionGripNames[d];
		Point3d defaultDescriptionLocation = defaultDescriptionLocations[d];
		Vector3d textDirection = textDirections[d];
		double textSize = textSizes[d];
		int descriptionColor = descriptionColors[d];
		
		dpDescription.color(descriptionColor);
		dpDescription.dimStyle(sDimStyle);
		if (textSize > 0)
		{
			dpDescription.textHeight(textSize);
		}
		
		Grip descriptionGrip(defaultDescriptionLocation);
		int descriptionGripFound = false;
		for (int g = 0; g < _Grip.length(); g++)
		{
			Grip grip = _Grip[g];
			if (grip.name() == descriptionGripName)
			{
				descriptionGrip = grip;
				descriptionGripFound = true;
				break;
			}
		}
		if ( ! descriptionGripFound)
		{
			descriptionGrip.setName(descriptionGripName);
			descriptionGrip.setShapeType(_kGSTCircle);
			descriptionGrip.setColor(3);
			
			_Grip.append(descriptionGrip);
		}
		
		dpDescription.draw(description, descriptionGrip.ptLoc(), textDirection, vzEl.crossProduct(textDirection), 0, 2, _kDevice);
	}
}

//Set point 3d array for the displayWallTubesOnFloors tsl to use.
Point3d points[0];
points.append(_PtG);
points.append(_Pt0);
_Map.setPoint3dArray("TubePoints", points);
_Map.setDouble("TubeDiameter", dTubeDiameter);
_Map.setPoint3d("ElementPtMid", ptEl);

//Draw the tube.
double tubeLength = U(0);
dpTube.draw(plTube);
if( nTubeVisualization == 0 ){
	Point3d ptPrev = _Pt0;
	for( int i=0;i<_PtG.length();i++ ){
		Point3d ptThis = _PtG[i];
		
		Body tube(ptPrev, ptThis, 0.5 * dTubeDiameter);
		dpTube.draw(tube);
		
		tubeLength += (ptThis - ptPrev).length();
		
		ptPrev = ptThis;
	}
}

Map mapBOM;
mapBOM.setString("Name", "Tube");
mapBOM.setString("Information", sDescription);
mapBOM.setDouble("Width", dTubeDiameter);
mapBOM.setDouble("Length", tubeLength);
mapBOM.setDouble("NettoWidth", dTubeDiameter);
mapBOM.setDouble("NettoLength", tubeLength);
_Map.setMap("BOM", mapBOM);

//Beams
Beam arBmAll[] = el.beam();
Beam arBmFrame[0];
Beam arBmSolePlate[0];

for( int j=0;j<arBmAll.length();j++ ){
	Beam bm = arBmAll[j];
	
	// Exclude beams for frametool.
	int bExcludeGenBeam = false;
	// Exclude based on beamcode.
	String sBmCode = bm.beamCode().token(0);
	sBmCode = sBmCode.trimLeft();
	sBmCode = sBmCode.trimRight();
	
	// Is it a soleplate?
	if( sBmCode == sBmCodeSolePlate ){
		arBmSolePlate.append(bm);
		continue;
	}
	
	// Exact match
	if( arSExcludeBmCodeFrame.find(sBmCode)!= -1 ){
		bExcludeGenBeam = true;
	}
	else{ // Wildcard match
		for( int j=0;j<arSExcludeBmCodeFrame.length();j++ ){
			String sExclBC = arSExcludeBmCodeFrame[j];
			String sExclBCTrimmed = sExclBC;
			sExclBCTrimmed.trimLeft("*");
			sExclBCTrimmed.trimRight("*");
			if( sExclBCTrimmed == "" )
				continue;
			if( sExclBC.left(1) == "*" && sExclBC.right(1) == "*" && sBmCode.find(sExclBCTrimmed, 0) != -1 )
				bExcludeGenBeam = true;
			else if( sExclBC.left(1) == "*" && sBmCode.right(sExclBC.length() - 1) == sExclBCTrimmed )
				bExcludeGenBeam = true;
			else if( sExclBC.right(1) == "*" && sBmCode.left(sExclBC.length() - 1) == sExclBCTrimmed )
				bExcludeGenBeam = true;
		}
	}
	if( bExcludeGenBeam )
		continue;
	
	arBmFrame.append(bm);
}

if (nSolePlateToolType != 0 || nFrameToolType != 0) {
	//Points of pline
	Point3d arPtTube[] = plTube.vertexPoints(true);
	
	if( arPtTube.length()==0 ){
		reportWarning("|No points found in polyline|");
		return;
	}
	Point3d ptPrev = arPtTube[0];
	for( int i=1;i<arPtTube.length();i++ ){
		Point3d ptThis = arPtTube[i];
		ptThis.vis(i);
		ptPrev.vis(i);
		
		Drill toolDummy(ptPrev, ptThis, U(0.1));
				
		Vector3d vTool(ptThis - ptPrev);
		vTool.normalize();
		Line lnTool(ptThis, vTool);
	
		if( nFrameToolType > 0 ){
			for( int j=0;j<arBmFrame.length();j++ ){
				Beam bm = arBmFrame[j];
						
				Body bdTool = toolDummy.cuttingBody();
				Body bdBm = bm.envelopeBody(true, true);
				
				if( bdBm.hasIntersection(bdTool) ){
					if( bm.vecD(vTool).isPerpendicularTo(vTool) )
						continue;
					
					Vector3d vTool = bm.vecD(vTool);
					Point3d ptTool = lnTool.intersect(Plane(bm.ptCen(), vTool),0);
					ptTool.vis();
					if( nFrameToolType == 1 ){
						// Create a tool in the beam
						Drill tool(ptTool - vTool * U(100), ptTool + vTool * U(100), 0.5 * dFrameDrillDiameter);
						tool.cuttingBody().vis(3);
						bm.addTool(tool);
					}
					else{
						if( nSide != 0 )
							ptTool -= vzEl * nSide * dFrameMillOffset;
						Vector3d vxTool = vTool.crossProduct(vzEl);
						vxTool.normalize();
						BeamCut bmCut(ptTool, vxTool, vTool, vzEl, dFrameMillWidth, U(200), 2 * dFrameMillDepth, 0, 0, nSide);
						bm.addTool(bmCut);
						
						PLine rectangleMill;
						rectangleMill.createRectangle(LineSeg(ptTool - vxEl * dSolePlateMillWidth * 0.5, ptTool + vxEl * dSolePlateMillWidth * 0.5 - vyEl * (bm.dD(vyEl) * 0.5 + U(1))), vxEl, vyEl);
						rectangleMill.vis();
						ElemMill extraElMillPos(nSide, rectangleMill, el.zone(nSide).dH() + dExtraDepthMill, nToolIndexMill, nSideMill, nTurningDirectionMill, bOvershootMill);
						if (nApplyMill)
						{
							el.addTool(extraElMillPos);
						}
					}
				}
			}
		}
		
		if( nSolePlateToolType > 0 ){
			for( int j=0;j<arBmSolePlate.length();j++ ){
				Beam bm = arBmSolePlate[j];
						
				Body bdTool = toolDummy.cuttingBody();
				Body bdBm = bm.envelopeBody(true, true);
				
				if( bdBm.hasIntersection(bdTool) ){
					if( bm.vecD(vTool).isPerpendicularTo(vTool) )
						continue;
					
					Vector3d vTool = bm.vecD(vTool);
					Point3d ptTool = lnTool.intersect(Plane(bm.ptCen(), vTool),0);
					
					if( nSolePlateToolType == 1 ){
						// Create a tool in the beam
						Drill tool(ptTool - vTool * U(100), ptTool + vTool * U(100), 0.5 * dSolePlateDrillDiameter);
						tool.cuttingBody().vis(3);
						bm.addTool(tool);
					}
					else{
						if( nSide != 0 )
							ptTool -= vzEl * nSide * 0.5 * dSolePlateMillOffset;
						BeamCut bmCut(ptTool, vxEl, vyEl, vzEl, dSolePlateMillWidth, U(200), 2 * dSolePlateMillDepth, 0, 0, nSide);
						bm.addTool(bmCut);
						
						PLine rectangleMill;
						rectangleMill.createRectangle(LineSeg(ptTool - vxEl * dSolePlateMillWidth * 0.5, ptTool + vxEl * dSolePlateMillWidth * 0.5 - vyEl * (bm.dD(vyEl) * 0.5 + U(1))), vxEl, vyEl);
						rectangleMill.vis();
						ElemMill extraElMillPos(nSide, rectangleMill, el.zone(nSide).dH() + dExtraDepthMill, nToolIndexMill, nSideMill, nTurningDirectionMill, bOvershootMill);
						if (nApplyMill)
						{
							el.addTool(extraElMillPos);
						}
					}
				}
			}		
		}
		
		//Move to next linesegment.
		ptPrev = ptThis;
	}
}

// Saving properties to be read by instalation point to create a new tube replacing this one
Map mapProperties= mapWithPropValues();
_Map.setMap("Properties", mapProperties);

//__declare noNailZone. For initial try, both sides and default tools
//__make no assumptions on conduit orientation. Not sure if PLine needs to be projected to side cc 31May2019
Vector3d vTube = _PtG[0] - _Pt0;
double dTubeL = vTube.length();
vTube.normalize();

if (addNoNailArea)
{
	Vector3d vTubePerp = vzEl.crossProduct(vTube);
	vTubePerp = vTubePerp * dTubeDiameter / 1.5;
	PLine plNoNail(vzEl);
	plNoNail.addVertex(_Pt0 + vTubePerp);
	plNoNail.addVertex(_Pt0 - vTubePerp);
	plNoNail.addVertex(_PtG[0] - vTubePerp);
	plNoNail.addVertex(_PtG[0] + vTubePerp);
	plNoNail.addVertex(_Pt0 + vTubePerp);
	
	ElemNoNail ennPos(1, plNoNail);
	el.addTool(ennPos);
	ElemNoNail ennNeg(-1, plNoNail);
	el.addTool(ennNeg);
	plNoNail.vis(4);
}













#End
#BeginThumbnail
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
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
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Make sure that side of mill has unique index" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="34" />
      <str nm="Date" vl="5/7/2025 1:34:00 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Switch before and after option because it was wrong in the last change." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="33" />
      <str nm="Date" vl="12/3/2024 9:37:54 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add option to change the location of the segment description. Place it before or after the segment length." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="32" />
      <str nm="Date" vl="11/25/2024 5:33:03 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21950 bugfix description indentation conflicting format resolving" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="31" />
      <str nm="Date" vl="4/25/2024 8:32:32 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add option to round the individual tube lengths in the description." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="30" />
      <str nm="Date" vl="3/18/2024 4:17:35 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Set propertnumbering as it was in version 1.25." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="29" />
      <str nm="Date" vl="3/13/2024 1:16:08 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add option to show extra text with the lengths of the individual segments." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="28" />
      <str nm="Date" vl="1/31/2024 4:15:32 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add option to show the lengths of the individual segments." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="27" />
      <str nm="Date" vl="1/30/2024 2:30:32 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Start and end description added. Add grips for descriptions." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="26" />
      <str nm="Date" vl="11/15/2023 2:34:27 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add elemmill for sheeting" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="25" />
      <str nm="Date" vl="10/25/2023 4:56:46 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13556: fix side of installation tube" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="24" />
      <str nm="Date" vl="11/10/2021 10:37:09 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Improve side of tube check. Don't default to backside when the user overrides." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="23" />
      <str nm="Date" vl="10/12/2021 12:36:07 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add mill offset propertie" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="22" />
      <str nm="Date" vl="5/21/2021 3:58:47 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End