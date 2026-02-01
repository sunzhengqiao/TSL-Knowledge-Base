#Version 8
#BeginDescription
Adds lifting to a wall element. If element goes over a specified length, 2 extra lifting ropes are added
#Versions
1.49 19/12/2025 Correct lifting positions around centre of gravity. Make offset ratios available for users.
1.48 05.06.2025 HSB-24138 bugfix if no studs to drill are found
1.47 13/02/2025 Adjust drill direction to be done from the outside to the inside of the wall. Author: Alberto Jena
Version1.46 10-4-2024 Fixed issue with asymmetric Drills. where second drill had wrong offset in Element Z direction. Marc Bredewoud
1.45 09.02.2024 HSB-20733: Add properties for batten, beamcode,material,grade,name Author: Marsel Nakuci
1.32 04/06/2021 Remove check for body intersection Author: Robert Pol
1.31 04/06/2021 Add Plate offset and angle Author: Robert Pol
1.33 07/06/2021 Fix start position of reinforcement Author: Robert Pol
1.34 02/07/2021 Remove duplicate reinforcements and correct _PTG position when 2 beams next to each other Author: Robert Pol
1.36 09/12/2021 Restore version Author: Robert Pol
1.37 27/01/2022 HSB-9178: add property side with options {top plate, bottom plate, both, custom} Author: Marsel Nakuci
1.38 15/03/2022 Only add plates to top and make sure cutsouts are done on all top/bottomplates Author: Robert Pol
1.39 16/03/2022 Add executionloop, because bottom tool stayed in place Author: Robert Pol
1.40 25/08/2022 Add option to move reinforcementplates in element z direction. Author: Robert Pol
1.41 26/08/2022 Fix issue with alignement multiple studs with different height Author: Robert Pol
1.42 20/09/2022 Add grade to reinforcement plates Author: Robert Pol
1.43 17/01/2024 Add option to only add drill in topplate for 1 side Author: Robert Pol
1.44 17/01/2024 Add label filter Author: Robert Pol





#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 49
#KeyWords lifting
#BeginContents
/// <summary Lang=en>
/// Adds lifting to a wall element. If element goes over a specified length, 2 extra lifting ropes are added
/// </summary>

/// <insert>
/// Select a set of elements
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.28" date="06.11.2020"></version>

/// <history>
/// AS - 1.00 - 02.11.2012	- Pilot version
/// AS - 1.01 - 04.10.2013	- Drills in angled topplates are now perpendicular to the angled topplates.
/// AS - 1.02 - 03.04.2014	- Add option to apply side cuts
/// AS - 1.03 - 16.02.2016	- Add offset from frame center. Add beam filter.
/// AS - 1.04 - 21.04.2016	- Add option to exclude jacks.
/// AS - 1.05 - 03.06.2016	- Default _Pt0 to center of element.
/// AS - 1.06 - 17.06.2016	- Resolve properties after insert.
/// AS - 1.07 - 17.01.2017	- Add support for roof elements.
/// YB - 1.08 - 18.04.2016 	- Fixed an issue with the drill not properly working.
/// DR - 1.09 - 07.06.2017	- Fixed excesive length of vertical drills
/// AS - 1.10 - 08.06.2017	- Correct position when connected to multiple studs.
/// RP - 1.11 - 02.08.2017	- Comment out visualisation (.vis) of studs, because it could happen the index is not in range.
/// RP - 1.12 - 17.08.2017	- Reset position on elementcontructed.
/// AS - 1.13 - 13.03.2018	- Apply four ropes if heavier than specified value.
/// DR - 1.14 - 24.10.2018	- Element instance assigned to zone E0
/// RVW - 1.15 - 15.02.2019	- Add check that the tsl cant be executed twice with the same identifier in one element.
/// RVW - 1.16 - 28.02.2019	- Add option to make the drill offset from center for both drills symmetric, or asymmetric in the top plate.
/// AS - 1.17 - 12.04.2019	- Expose lifting display in modelX
/// RVW - 1.18 - 21.10.2019	- Add option to place the drills in toppplate from center of element or from center of topplate.
/// AS - 1.19 - 24.10.2019	- Use beam vector most aligned with element Y as drill direction.
/// RVW - 1.20 - 12.12.2019	- Add option to not place any drills and add option to place an additional side plate next to the studs for reinforcement.
/// Aj - 1.21 - 03.03.2020		- Set the porperty of offset from center point to 0 if the option Symmetric is choose, otherwise the TSL was not doing anything.
/// RP - 1.23 - 14.08.2020		- Offset from center and semetric propertie noit working
/// RP - 1.24 - 24.08.2020		- Remove reportmessage
/// RP - 1.25 - 24.08.2020		- Rename beam to beam by code to make sure beamcode prop will be filled by user
/// MN - 1.26 - 30.10.2020		- HSB-8824: add option "Drill stud and topplate one side" at sTooling
/// MN - 1.27 - 30.10.2020		- HSB-8824: improve the display of ropes 
/// MN - 1.28 - 06.11.2020		- HSB-8824: add propertes "batten symmetry" and "batten side". only relevant when Tooling option "Drill stud and topplate one side" is selected
/// MN - 1.29 - 08.11.2020		- HSB-8824: add property "batten length" 
/// NG - 1.30 - 30.11.2020		- HSB-8824: Bugfix visualisation causes range error" 
// #Versions
//1.49 19/12/2025 Correct lifting positions around centre of gravity. Make offset ratios available for users. Anno Sportel
// 1.48 05.06.2025 HSB-24138 bugfix if no studs to drill are found , Author Thorsten Huck
//1.47 13/02/2025 Adjust drill direction to be done from the outside to the inside of the wall. Author: Alberto Jena
//1.46 10-4-2024 Fixed issue with asymmetric Drills. where second drill had wrong offset in Element Z direction. Marc Bredewoud
// 1.45 09.02.2024 HSB-20733: Add properties for batten, beamcode,material,grade,name Author: Marsel Nakuci
//1.44 17/01/2024 Add label filter Author: Robert Pol
//1.43 17/01/2024 Add option to only add drill in topplate for 1 side Author: Robert Pol
//1.42 20/09/2022 Add grade to reinforcement plates Author: Robert Pol
//1.41 26/08/2022 Fix issue with alignement multiple studs with different height Author: Robert Pol
//1.40 25/08/2022 Add option to move reinforcementplates in element z direction. Author: Robert Pol
//1.39 16/03/2022 Add executionloop, because bottom tool stayed in place Author: Robert Pol
//1.38 15/03/2022 Only add plates to top and make sure cutsouts are done on all top/bottomplates Author: Robert Pol
// 1.37 27/01/2022 HSB-9178: add property side with options {top plate, bottom plate, both, custom} Author: Marsel Nakuci
// 1.36 09/12/2021 Restore version Author: Robert Pol
//1.34 02/07/2021 Remove duplicate reinforcements and correct _PTG position when 2 beams next to each other Author: Robert Pol
//1.33 07/06/2021 Fix start position of reinforcement Author: Robert Pol
//1.32 04/06/2021 Remove check for body intersection Author: Robert Pol
//1.31 04/06/2021 Add Plate offset and angle Author: Robert Pol
/// </history>
	
String arBmInvalidBeamCodes[] = {
	"REPLACE THIS WITH A BEAMCODE THAT CANNOT HAVE A STRAP",
	"EXTEND THE LIST"
};

Unit (1,"mm");
double dEps = U(0.1);

String arSYesNo[] = {T("|Yes|"), T("|No|")};
String arSSymmetricAsymmetric[] = { T("|Symmetric|"), T("|Asymmetric|")};
int arNYesNo[] = {_kYes, _kNo};

String arSLayer[] = {T("|I-Layer|"), T("|D-Layer|"), T("|T-Layer|"), T("|Z-Layer|")};
int arNZoneIndex[] = {0,1,2,3,4,5,6,7,8,9,10};

String arEntityForRefCenterPoint[] = { T("|Element|"), T("|Beam by code|")};

PropString tslIdentifier (10, "Pos 1", " " + T(" |General|"));
tslIdentifier.setDescription(T("|Only one tsl instance, per identifier, can be attached to an element.|"));
PropString sSeparator01(0, "", T("|Tooling|"));
sSeparator01.setReadOnly(true);
// HSB-8824: add new tooling for kingspan drill stud and topplate one side
String arSTooling[] = {
	T("|Drill stud and topplate|"),
	T("|Drill stud|"),
	T("|Side cuts in topplate|"),
	T("|No drills|"),
	T("|Drill stud and topplate one side|"),
	T("|Drill topplate one side|")
};
String sToolingSideName="     "+T("|Side|");	
String sToolingSides[] ={ T("|Top plate|"), T("|Bottom plate|"), T("|Both|"), T("|Custom|")};
PropString sToolingSide(23, sToolingSides, sToolingSideName);	
sToolingSide.setDescription(T("|Defines the Tooling Side. If Custom is selected then the lifing points can be positioned individually by dragging their grip point|"));
//sToolingSide.setCategory(category);


PropString sTooling(1, arSTooling, "     "+T("|Tooling|"));
PropString sFilterBC(8,"","     "+T("Filter beams with beamcode"));
PropString sFilterLabel(25,"","     "+T("Filter beams with label"));

PropString propExcludeJacks(9, arSYesNo, "     "+T("|Exclude jacks|"), 1);

PropString sSeparator01a(6, "", "     "+T("|Drill|"));
sSeparator01a.setReadOnly(true);
PropString sCenterRefEntity (12, arEntityForRefCenterPoint, "          "+T("|Centerpoint for drills|"), 1);
sCenterRefEntity.setDescription(T("|Choose from where the drills need to be placed. From element center or from a beam center point|."));
PropString sBeamcodeToCenterDrills (13, "", "          "+T("|Beamcode to center drills|"));
sBeamcodeToCenterDrills.setDescription(T("|Give the beamcode where the drills need to be centered in|"));
PropDouble dOffsetFromFrameCenter(8, U(0), "          "+T("|Offset from center point|"));
PropString sSymmetricAsymmetric (11, arSSymmetricAsymmetric, "          "+T("|Offset symmetric or asymmetric|"));
sSymmetricAsymmetric.setDescription(T("|Choose wheter the offset for the drills from frame center have to be symmetric or asymmetric|."));
PropDouble dOffsetHor(0, U(80), "          "+T("|Horizontal offset drill|"));
PropDouble dOffsetVert(7, U(80),"          "+ T("|Vertical offset drill|"));
PropDouble dDiam(1, U(16), "          "+T("Diameter drill"));

PropString sSeparator01b(7, "", "     "+T("|Side cuts|"));
sSeparator01b.setReadOnly(true);
PropDouble dWSideCut(5, U(100), "          "+T("|Width side cut|"));
PropDouble dTSideCut(6, U(6), "          "+T("|Depth side cut|"));

PropString sSeparator05(14, "", T("|Reinforcement plate|"));
sSeparator05.setReadOnly(true);
PropString propPlaceReinforcementPlate(15, arSYesNo, "     "+T("|Stud drill reinforcement|"), 1);
PropDouble dWidthPlate (11, U(0), "          "+T("|Width of plate|"));
dWidthPlate.setDescription(T("|If value is zero, stud with is taken|"));
PropDouble dHeightPlate (12, U(200), "          "+T("|Height of plate|"));
dHeightPlate.setDescription(T("|If value is zero, plate will be equal to vertical drill offset|"));
PropDouble dThicknessPlate (13, U(12), "          "+T("|Thickness of plate|"));
PropDouble dPlateOffset (17, U(0), "          "+T("|Offset plate vertical|"));
PropDouble dPlateOffsetHorizontal (19, U(0), "          "+T("|Offset plate horizontal|"));
PropDouble dPlateAngle (18, U(0), "          "+T("|Angle plate|"));
dPlateAngle.setFormat(_kAngle);
PropString sMaterialPlate (16, "", "          "+T("|Material of plate|"));
PropString sGradePlate (24, "", "          "+T("|Grade of plate|"));
PropString sNamePlate (17, "", "          "+T("|Name of plate|"));
PropString sBeamCodePlate (18, "", "          "+T("|Beamcode of plate|"));
PropInt sColorPlate (2, 1, "          "+T("|Color of plate|"));
PropInt sZonePlate (3, 0, "          "+T("|Zone of plate|"));
// properties only valid for "Drill stud and topplate one side"
String sNoYes[] = { T("|No|"), T("|Yes|")};
PropString sSeparator06(20, "", T("|Reinforcement batten|"));
sSeparator06.setReadOnly(true);
String sBattenSymmetryName="     "+T("|Batten Symmetry|");	
PropString sBattenSymmetry(21, sNoYes, sBattenSymmetryName,1);	
sBattenSymmetry.setDescription(T("|Defines the Batten Symmetry|"));
//sBattenSymmetry.setCategory(category);
String sInOut[] = { T("|Outside|"), T("|Inside|")};
String sBattenInOutName="     "+T("|Batten Side|");	
PropString sBattenInOut(22, sInOut, sBattenInOutName);	
sBattenInOut.setDescription(T("|Defines the Batten Symmetry|"));
// batten length
String sBattenLengthName="     "+T("|Batten Length|");
PropDouble dBattenLength(14, U(300), sBattenLengthName);	
dBattenLength.setDescription(T("|Defines the Batten Length|"));

// HSB-20733
String sBattenBeamcodeName="     "+T("|Beamcode of Batten|");	
PropString sBattenBeamcode(26, "", sBattenBeamcodeName);	
sBattenBeamcode.setDescription(T("|Defines the Batten Beamcode|"));
//sBattenBeamcode.setCategory(category);

String sBattenMaterialName="     "+T("|Material of Batten|");
PropString sBattenMaterial(27, "", sBattenMaterialName);	
sBattenMaterial.setDescription(T("|Defines the Batten Material|"));
//sBattenMaterial.setCategory(category);

String sBattenGradeName="     "+T("|Grade of Batten|");	
PropString sBattenGrade(28, "", sBattenGradeName);	
sBattenGrade.setDescription(T("|Defines the Batten Grade|"));
//sBattenGrade.setCategory(category);

String sBattenNameName="     "+T("|Name of Batten|");	
PropString sBattenName(29, "", sBattenNameName);	
sBattenName.setDescription(T("|Defines the Batten Name|"));
//sBattenName.setCategory(category);

//----
PropString sSeparator02(2, "", T("|Ruleset|"));
sSeparator02.setReadOnly(true);
PropDouble dWallLengthToSwitchToFourRopes(2, U(7800), "     "+T("|Four ropes on walls longer than|"));
PropDouble dWallLengthToSwitchToOneRope(3, U(1200), "     "+T("|One rope on walls shorter than|"));
PropDouble weightToSwitchToFourRopes(9, U(999999), "     "+T("|Four ropes on walls heavier than|"));
weightToSwitchToFourRopes.setFormat(_kNoUnit);
PropString propDoubleLifting(19, arSYesNo, "     "+T("|Double lifting|"), 1);
PropDouble minimalStudLength(21, U(0), "     "+T("|Minimal Stud Length|"));
PropDouble ratio2Ropes(22, 0.525, "     "+T("|Offset ratio from center for 2 ropes|"));
ratio2Ropes.setDescription(T("|Specify the offset ratio (between 0 and 1) for the offset of the ropes from the center. \nIf there is 2400 mm from the center to the edge of the element and the ratio is set to 0.33 it will try to find a lifting point around 800 mm from the center.|"));
PropDouble ratio4Ropes1(23, 0.25, "     "+T("|Offset ratio (between 0 and 1) first rope from center for 4 ropes|"));
ratio4Ropes1.setDescription(T("|Specify the offset ratio for the offset of the first rope from the center. \nIf there is 2400 mm from the center to the edge of the element and the ratio is set to 0.33 it will try to find a lifting point around 800 mm from the center.|"));
PropDouble ratio4Ropes2(24, 0.75, "     "+T("|Offset ratio (between 0 and 1) second rope from center for 4 ropes|"));
ratio4Ropes2.setDescription(T("|Specify the offset ratio for the offset of the second rope from the center. \nIf there is 2400 mm from the center to the edge of the element and the ratio is set to 0.67 it will try to find a lifting point around 1600 mm from the center.|"));

PropString sSeparator03(3, "", T("|Style|"));
sSeparator03.setReadOnly(true);
PropString sLayer(4, arSLayer, "     "+T("|Layer|"));
PropInt nZoneIndex(0, arNZoneIndex, "     "+T("|Zone index|"));

PropString sSeparator04(5, "", T("|Visualisation|"));
sSeparator04.setReadOnly(true);
PropInt nColor(1, 3, "     "+T("|Color|"));
PropDouble dSymbolSize(4, U(30), "     "+T("|Symbol size|"));
int isSemetric = true;


String arSTrigger[] = {
	T("|Reset positions|"),
	T("|Delete|")
};
for( int i=0;i<arSTrigger.length();i++ )
	addRecalcTrigger(_kContext, arSTrigger[i] );
Element selectedElements[0];

//Insert
if( _bOnInsert ){
	//Erase after 1 cycle
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	//Showdialog
	if (_kExecuteKey=="")
		showDialog();
		
	PrEntity ssE(TN("|Select a set of elements|"),Element());
	if(ssE.go()){
		_Element.append(ssE.elementSet());
	}
			
	String strScriptName = scriptName();
	Vector3d vecUcsX(1,0,0);
	Vector3d vecUcsY(0,1,0);
	Beam lstBeams[0];
	Element lstElements[1];
	Entity lstEntities[1];
	
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	Map mapTsl;
	mapTsl.setInt("MasterToSatellite", TRUE);
	setCatalogFromPropValues("MasterToSatellite");
	
//	if( arSTooling.find(sTooling,0)==4)
	{ 
		mapTsl.setInt("iSymAsym", 1);
		if(sNoYes.find(sBattenSymmetry)==0) mapTsl.setInt("iSymAsym", 0);
		mapTsl.setInt("flip", 0);
		if(sInOut.find(sBattenInOut)==1) mapTsl.setInt("flip", 1);
	}
	
	for( int e=0;e<_Element.length();e++ ){
		
		Element selectedElement = _Element[e];
		if (!selectedElement.bIsValid()) continue;
				
		TslInst arTsl[] = selectedElement.tslInst();
		for ( int j = 0; j < arTsl.length(); j++)
		{
			TslInst tsl = arTsl[j];
			if ( ! tsl.bIsValid() || (tsl.scriptName() == strScriptName && tsl.propString(10) == tslIdentifier))
			{
				tsl.dbErase();
			}
		}
		lstEntities[0] = selectedElement;
		TslInst tsl;
		tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
	}
	
	eraseInstance();
	return;
}

if( _Map.hasInt("MasterToSatellite") ){
	int bMasterToSatellite = _Map.getInt("MasterToSatellite");
	if( bMasterToSatellite ){
		int bPropertiesSet = _ThisInst.setPropValuesFromCatalog("MasterToSatellite");
		_Map.removeAt("MasterToSatellite", TRUE);
	}
}

if( _Element.length() == 0 ){
	eraseInstance();
	return;
}

ElementWall elWall = (ElementWall)_Element[0];
Point3d ptStartOutline = elWall.ptStartOutline();
Point3d ptEndOutline = elWall.ptEndOutline();
if( _kExecuteKey == arSTrigger[0] || _bOnElementConstructed)
{
	_PtG.setLength(0);
}
// each time the Tsl runs the entities are deleted and created. totally controlled by the tsl
// for nToolType == 4 we always need the batten
Map entitiesToEraseMap = _Map.getMap("EntitiesToErase[]");
if (entitiesToEraseMap.length() > 0)
{
	for (int index=0;index<entitiesToEraseMap.length();index++) 
	{ 
		Entity ent = entitiesToEraseMap.getEntity(index);
		ent.dbErase(); 
	}
}

if (_kExecuteKey == T("|Delete|"))
{
	eraseInstance();
	return;
}

entitiesToEraseMap = Map();

String sFBC = sFilterBC + ";";
sFBC.makeUpper();
String arSFBC[0];
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

	arSFBC.append(sTokenBC);
}
String arSFilterLabel[] = sFilterLabel.tokenize(";");
int excludeJacks = arNYesNo[arSYesNo.find(propExcludeJacks, 1)];
int nToolType = arSTooling.find(sTooling,0);
int nAddReinforcementplate = propPlaceReinforcementPlate == arSYesNo[0] ? true : false;
int bDoubleLifting = propDoubleLifting == arSYesNo[0] ? true : false;
if (sSymmetricAsymmetric == "Asymmetric") isSemetric = false;

int nZnIndex = nZoneIndex;
if( nZnIndex > 5 )
	nZnIndex = 5 - nZnIndex;

Element el = _Element[0];

assignToElementGroup(el, TRUE, 0, 'E');

CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

int elementCenterPoint;
int beamCenterPoint;

arEntityForRefCenterPoint.find(sCenterRefEntity) == 0 ? (elementCenterPoint = true) : (beamCenterPoint = true);

Point3d frameCenter = ptEl - vzEl * 0.5 * el.zone(0).dH();
Point3d beamCenter;

Display dpLifting(3);
dpLifting.showInDxa(true);
if (sLayer == arSLayer[0])
	dpLifting.elemZone(el, nZnIndex, 'I'); 
else if (sLayer == arSLayer[1])
	dpLifting.elemZone(el, nZnIndex, 'D');
else if (sLayer == arSLayer[2])
	dpLifting.elemZone(el, nZnIndex, 'T');
else if (sLayer == arSLayer[3])
	dpLifting.elemZone(el, nZnIndex, 'Z');
dpLifting.textHeight(U(5));

GenBeam arGBm[] = el.genBeam();
LineSeg lnSeg = el.segmentMinMax();
_Pt0 = lnSeg.ptMid();

Map mapIO;
Map mapEntities;
for (int e=0;e<arGBm.length();e++)
{
	mapEntities.appendEntity("Entity", arGBm[e]);
}
Opening openings[] = el.opening();
for (int o=0;o<openings.length();o++)
{
	mapEntities.appendEntity("Entity", openings[o]);
}
mapIO.setMap("Entity[]",mapEntities);
TslInst().callMapIO("hsbCenterOfGravity", mapIO);
if (mapIO.hasPoint3d("ptCen"))
	_Pt0 = mapIO.getPoint3d("ptCen");
double dElH = abs(vyEl.dotProduct(lnSeg.ptEnd() - lnSeg.ptStart()));
double weight = mapIO.getDouble("Weight");

PLine plWall(vyEl);
plWall.createRectangle(lnSeg, vxEl, vzEl);

Plane pnEl(ptEl - vzEl * 0.5 * el.dBeamWidth(), vzEl);
Point3d arPtEl[] = plWall.intersectPoints(pnEl);

Line lnElX(el.ptOrg(), vxEl);
arPtEl = lnElX.orderPoints(arPtEl);

if( arPtEl.length() == 0 )return;
Point3d ptMax = arPtEl[arPtEl.length() - 1];
Point3d ptMin = arPtEl[0];

double dWallLength = vxEl.dotProduct(ptMax - ptMin);
int bUseFourRopes = (dWallLength >= dWallLengthToSwitchToFourRopes) || (weight > weightToSwitchToFourRopes);
int bUseOneRope = dWallLength < dWallLengthToSwitchToOneRope;

// Force default values if the ratio is invalid
if (ratio2Ropes < 0 || ratio2Ropes > 1) ratio2Ropes.set(0.525);
if (ratio4Ropes1 < 0 || ratio4Ropes1 > 1) ratio4Ropes1.set(0.25);
if (ratio4Ropes2 < 0 || ratio4Ropes2 > 1) ratio4Ropes2.set(0.75);

double dStudSpacing = 0;
ElementWallSF elSF = (ElementWallSF) el;
if (elSF.bIsValid())
	dStudSpacing = elSF.spacingBeam();
PlaneProfile studProfile(el.coordSys());

Beam arBmAll[] = el.beam();
Beam arBm[0];
Beam arBmVertical[0];
Beam arBmNotVertical[0];
Beam arBmExcluded[0];
for( int i=0;i<arBmAll.length();i++ ){
	Beam bm = arBmAll[i];
	if (bm.myZoneIndex() != 0) continue;
	if (excludeJacks && (bm.type() == _kSFJackOverOpening || bm.type() == _kSFJackUnderOpening))
		continue;
	
	// apply filters
	String sBmCode = bm.beamCode().token(0).makeUpper();
	sBmCode.trimLeft();
	sBmCode.trimRight();
	
	String label = bm.label();
	label.trimLeft();
	label.trimRight();
	
	int bExclude = false;
	if (arSFilterLabel.find(label) != -1)
	{
		bExclude = true;
	}
	if( arSFBC.find(sBmCode) != -1 ) {
		bExclude = true;
	}
	else{
		for( int j=0;j<arSFBC.length();j++ ){
			String sFilter = arSFBC[j];
			String sFilterTrimmed = sFilter;
			sFilterTrimmed.trimLeft("*");
			sFilterTrimmed.trimRight("*");
			if( sFilterTrimmed == "" )
				continue;
			if( sFilter.left(1) == "*" && sFilter.right(1) == "*" && sBmCode.find(sFilterTrimmed, 0) != -1 )
				bExclude = true;
			else if( sFilter.left(1) == "*" && sBmCode.right(sFilter.length() - 1) == sFilterTrimmed )
				bExclude = true;
			else if( sFilter.right(1) == "*" && sBmCode.left(sFilter.length() - 1) == sFilterTrimmed )
				bExclude = true;
		}
	}
	
	if (bExclude) {
		arBmExcluded.append(bm);
		continue;
	}
	
	arBm.append(bm);
	
	if ( abs(abs(bm.vecX().dotProduct(vyEl)) - 1) < dEps )
	{
		if (bm.solidLength() > minimalStudLength)
		{
			arBmVertical.append(bm);
			PlaneProfile studPlaneProfile = bm.envelopeBody(false, true).shadowProfile(Plane(el.ptOrg(), vzEl));
			studPlaneProfile.shrink(-U(2));
			studProfile.unionWith(studPlaneProfile);
		}
		else
		{
			arBm.removeAt(arBm.find(bm));
		}
	}
	else
		arBmNotVertical.append(bm);
}
// HSB-20733: events to update properties
String sBattenPropertyEvents[]={sBattenBeamcodeName,sBattenMaterialName,
 sBattenGradeName,sBattenNameName};
if(sBattenPropertyEvents.find(_kNameLastChangedProp)>-1)
{ 
	Beam bmBattenRight, bmBattenLeft;
	Entity entLeft=_Map.getEntity("beamReinforcementLeft");
	Entity entRight=_Map.getEntity("beamReinforcementRight");
	bmBattenRight=(Beam)entRight;
	bmBattenLeft=(Beam)entLeft;
	if(bmBattenRight.bIsValid())
	{ 
		bmBattenRight.setBeamCode(sBattenBeamcode);
		bmBattenRight.setMaterial(sBattenMaterial);
		bmBattenRight.setGrade(sBattenGrade);
		bmBattenRight.setName(sBattenName);
	}
	if(bmBattenLeft.bIsValid())
	{ 
		bmBattenLeft.setBeamCode(sBattenBeamcode);
		bmBattenLeft.setMaterial(sBattenMaterial);
		bmBattenLeft.setGrade(sBattenGrade);
		bmBattenLeft.setName(sBattenName);
	}
}
studProfile.shrink(U(2));
studProfile.vis(3);
int nToolSide = sToolingSides.find(sToolingSide);
if( nToolType == 2 ) // side cuts
{
	double distToMin = vxEl.dotProduct(_Pt0 - ptMin);
	double distToMax = vxEl.dotProduct(ptMax - _Pt0);
	double offsetFromCentre = (distToMax < distToMin) ? distToMax : distToMin;
	
	Point3d centre = ptMin + vxEl * vxEl.dotProduct(_Pt0 - ptMin);
	if( bUseOneRope ){
		Point3d ptRope = centre; //ptMin + vxEl * vxEl.dotProduct(_Pt0 - ptMin);
		if( _PtG.length() != 1 ){
			_PtG.setLength(0);
			_PtG.append(ptRope);
		}
	}
	else if( !bUseFourRopes ){
		Point3d ptLeft = centre - vxEl * ratio2Ropes * offsetFromCentre; //ptMin + vxEl * 0.475 * vxEl.dotProduct(_Pt0 - ptMin);
		Point3d ptRight = centre + vxEl * ratio2Ropes * offsetFromCentre; //ptMax + vxEl * 0.475 * vxEl.dotProduct(_Pt0 - ptMax);
		if( _PtG.length() != 2 ){
			_PtG.setLength(0);
			_PtG.append(ptLeft);
			_PtG.append(ptRight);
		}
		//Reset positions when points are at the same location.
		if( (Vector3d(_PtG[1] - _PtG[0])).length() < dEps ){
			_PtG.setLength(0);
			_PtG.append(ptLeft);
			_PtG.append(ptRight);
		}
	}
	else
	{
		Point3d ptLeft01 = centre - vxEl * ratio4Ropes1 * offsetFromCentre; //ptMin + vxEl * 0.25 * vxEl.dotProduct(_Pt0 - ptMin);
		Point3d ptLeft02 = centre - vxEl * ratio4Ropes2 * offsetFromCentre; //ptMin + vxEl * 0.75 * vxEl.dotProduct(_Pt0 - ptMin);
		Point3d ptRight02 = centre + vxEl * ratio4Ropes1 * offsetFromCentre; //ptMax + vxEl * 0.75 * vxEl.dotProduct(_Pt0 - ptMax);
		Point3d ptRight01 = centre + vxEl * ratio4Ropes2 * offsetFromCentre; //ptMax + vxEl * 0.25 * vxEl.dotProduct(_Pt0 - ptMax);
		
		if( _PtG.length() != 4 ){
			_PtG.setLength(0);
			_PtG.append(ptLeft01);
			_PtG.append(ptLeft02);
			_PtG.append(ptRight02);
			_PtG.append(ptRight01);
		}
		
		if( vxEl.dotProduct(_Pt0 - _PtG[0]) <= 0 || vxEl.dotProduct(_Pt0 - _PtG[1]) <= 0 ){
			_PtG[0] = ptLeft01;
			_PtG[1] = ptLeft02;
		}
		if( vxEl.dotProduct(_Pt0 - _PtG[2]) >= 0 || vxEl.dotProduct(_Pt0 - _PtG[3]) >= 0 ){
			_PtG[2] = ptRight02;
			_PtG[3] = ptRight01;
		}
		if( abs(vxEl.dotProduct(_PtG[0] - _PtG[1])) < dEps ){
			_PtG[0] = ptLeft01;
			_PtG[1] = ptLeft02;
		}
		if( abs(vxEl.dotProduct(_PtG[2] - _PtG[3])) < dEps ){
			_PtG[2] = ptRight02;
			_PtG[3] = ptRight01;
		}
	}
	
	_PtG = pnEl.projectPoints(_PtG);
	for (int iside=0;iside<2;iside++) 
	{ 
		int nFacSide = 1;
		if ( ! ((iside == nToolSide || nToolSide == 2) || (iside==0 && nToolSide==3)))continue;
		if (iside == 1)nFacSide = -1;
		
		// when custom is selected each gp can be top or bottom
		
		for( int i=0;i<_PtG.length();i++ )
		{
			if(nToolSide==3)
			{ 
				String sFac = "Fac" + i;
				if(!_Map.hasInt(sFac))
				{ 
					_Map.setInt(sFac, 1);
				}
				else 
				{ 
					nFacSide = _Map.getInt(sFac);
				}
				String sPtg = "_PtG" + i;
				if(_kNameLastChangedProp==sPtg)
				{ 
					if(vyEl.dotProduct(_PtG[i]-_Pt0)>=0)
					{ 
						_Map.setInt(sFac, 1);
						nFacSide = 1;
					}
					else
					{ 
						_Map.setInt(sFac, -1);
						nFacSide = -1;
					}
				}
			}
			if(vyEl.dotProduct(nFacSide*(_PtG[i]-_Pt0))>0)
				_PtG[i]+=vyEl*vyEl.dotProduct(_Pt0-_PtG[i]); 
			
			// top or both
			// Find the topplate at this location
			Beam arBmTop[] = Beam().filterBeamsHalfLineIntersectSort(arBmNotVertical, _PtG[i], nFacSide*vyEl);
			if( arBmTop.length() == 0 ){
				reportMessage(TN("|Topplate cannot be found|!"));
				return;
			}
			
			for (int tp = 0; tp < arBmTop.length(); tp++)
			{
				
				
				Beam bmTP = arBmTop[tp];
				
				Vector3d vyBmTP = vzEl.crossProduct(bmTP.vecX());
				vyBmTP.normalize();
				// Make sure the beam is not rotated over the x-axis.
				if ( abs(abs(vyBmTP.dotProduct(bmTP.vecD(vyBmTP))) - 1) > dEps ) {
					reportMessage(TN("|Topplate is rotated over its own x axis|!"));
					return;
				}
				
				_PtG[i] = Line(_PtG[i], nFacSide * vyEl).intersect(Plane(bmTP.ptCen(), vyBmTP), U(0));
				// Create side cuts
				Point3d ptRope = bmTP.ptCen() + bmTP.vecX() * bmTP.vecX().dotProduct(_PtG[i] - bmTP.ptCen());
				
				//Front
				Point3d ptFront = ptRope + vzEl * (0.5 * bmTP.dD(vzEl) - dTSideCut);
				BeamCut bcFront(ptFront, vzEl, bmTP.vecX(), vyBmTP, 2 * dTSideCut, dWSideCut, 2 * bmTP.dD(vyBmTP), 1, 0, 0);
				bmTP.addTool(bcFront);
				bcFront.cuttingBody().vis(7);
				//Back
				Point3d ptBack = ptRope - vzEl * (0.5 * bmTP.dD(vzEl) - dTSideCut);
				BeamCut bcBack(ptBack, - vzEl, bmTP.vecX(), vyBmTP, 2 * dTSideCut, dWSideCut, 2 * bmTP.dD(vyBmTP), 1, 0, 0);
				bmTP.addTool(bcBack);
				bcBack.cuttingBody().vis(8);
			}
			PLine pl(-vxEl);
			Point3d pt01 = _PtG[i] + nFacSide*vyEl * dOffsetVert - nFacSide*vzEl * dOffsetHor;
			Point3d pt02 = _PtG[i] - nFacSide*vyEl * (dOffsetVert - dOffsetHor) - nFacSide*vzEl * dOffsetHor;
			Point3d pt03 = _PtG[i] - nFacSide*vyEl * (dOffsetVert - dOffsetHor) + nFacSide*vzEl * dOffsetHor;
			Point3d pt04 = _PtG[i] + nFacSide*vyEl * dOffsetVert + nFacSide*vzEl * dOffsetHor;
	
			pl.addVertex(pt01);
			pl.addVertex(pt02);
			pl.addVertex(pt03, 1);
			pl.addVertex(pt04);
			pl.close(1);
			dpLifting.draw(pl);
			setExecutionLoops(2); // need recalc or bottom tooling stays in place
		}
	}//next iside
}
else
{
	// nToolType!=2
	for (int iside=0;iside<2;iside++) 
	{ 
		int nFacSide = 1;
		if ( ! ((iside == nToolSide || nToolSide == 2) || (iside==0 && nToolSide==3)))continue;
		if (iside == 1)nFacSide = -1;
		
		for ( int i = 0; i < _PtG.length(); i++)
		{
			if (nToolSide == 3)
			{
				String sFac = "Fac" + i;
				if ( ! _Map.hasInt(sFac))
				{
					_Map.setInt(sFac, 1);
				}
				String sPtg = "_PtG" + i;
				if (_kNameLastChangedProp == sPtg)
				{
					if (vyEl.dotProduct(_PtG[i] - _Pt0) >= 0)
					{
						_Map.setInt(sFac, 1);
					}
					else
					{
						_Map.setInt(sFac, - 1);
					}
				}
			}
		}
		Beam arBmStud[0];
		Beam arBmStudBottom[0];// studs connected with bottom pate
		int arBInHeader[0];
		int arBInHeaderBottom[0];// studs connected with bottom plate
		
		//Body wall
		Body bdWall(plWall, vyEl * dElH, 1);
		//Openings
		Opening arOp[] = el.opening();
		//Cut out opening in bottom plates
		for( int i=0;i<arOp.length();i++ )
		{
			OpeningSF op = (OpeningSF)arOp[i];
			
			//Collect points
			Point3d arPtOp[] = op.plShape().vertexPoints(TRUE);
			//Order points
			//X
			Point3d arPtOpX[] = lnElX.orderPoints(arPtOp);
			arPtOpX = lnElX.projectPoints(arPtOpX);
			
			//Size
			double dOpW = op.width();
		
			//>=2700 ?
			if( dOpW >= U(2700) )
				continue;
		
			//>=1800 ?
			if( dOpW >= U(1800) )
				continue;
			
			//Pick points left and right of opening
			Point3d ptFrom = arPtOpX[0];
			Point3d ptTo = arPtOpX[arPtOpX.length() -1];
			
			//Extract this opening from the wall
			Body bdOp(ptFrom, vxEl,vyEl,vzEl, dOpW, 3 * dElH, U(500), 1,0,0);
			bdWall.subPart(bdOp);
		}
		
		int arNTypeTopPlate[] = 
		{
			_kSFTopPlate,
			_kTopPlate,
			_kSFAngledTPLeft,
			_kSFAngledTPRight,
			_kDakFrontEdge
		};
		
//		int arNTypeBottomPlate[] = {
//			_kSFBottomPlate
//		};
		if(iside==1)
		{ 
			arNTypeTopPlate.setLength(0);
			arNTypeTopPlate.append(_kSFBottomPlate);
		}
		if(nToolSide==3)
		{ 
			arNTypeTopPlate.append(_kSFBottomPlate);
		}
		if (bDoubleLifting)
		{ 
			bUseFourRopes = true;
		}
		
		double distToMin = vxEl.dotProduct(_Pt0 - ptMin);
		double distToMax = vxEl.dotProduct(ptMax - _Pt0);
		double offsetFromCentre = (distToMax < distToMin) ? distToMax : distToMin;
	
		Point3d centre = ptMin + vxEl * vxEl.dotProduct(_Pt0 - ptMin);
		
		if( bUseOneRope )
		{
			Point3d ptRope =  centre; //ptMin + vxEl * vxEl.dotProduct(_Pt0 - ptMin);
			
			if( _PtG.length() != 1 ){
				_PtG.setLength(0);
				_PtG.append(ptRope);
			}
			
			double dMinRope;
			int bMinSet = FALSE;
			Beam bmMinRope;
			
			int bInHeaderRope = FALSE;
			for( int i=0;i<arBm.length();i++ ){
				Beam bm = arBm[i];
				int bmIsHeader = FALSE;
				if( bm.name() == "BigHeader" )
					bmIsHeader = TRUE;
				
				if( arBmInvalidBeamCodes.find(bm.name("beamcode").token(0)) != -1 )
					continue;
				bm.ptCen().vis(2);
				if( !bmIsHeader ){
					if( !bm.vecX().isParallelTo(vyEl) || (!bm.envelopeBody().hasIntersection(bdWall) && ! bdWall.volume() > dEps ))
						continue;
					
					Beam arBmTConnection[] = bm.filterBeamsCapsuleIntersect(arBm);//, U(10), TRUE);
					int bHasTConnectionWithTopPlate = FALSE;
					
					Beam bmTP;
					for( int j=0;j<arBmTConnection.length();j++ ){
						Beam bmTP = arBmTConnection[j];
						Body bdTP = bmTP.realBody();
						//bdTP.vis();
						
						if( arNTypeTopPlate.find(bmTP.type()) != -1 ){
							bHasTConnectionWithTopPlate = TRUE;
							break;
						}
					}
					
					if( !bHasTConnectionWithTopPlate )
						continue;
				}
				
				double dDistRope = abs( vxEl.dotProduct(bm.ptCen() - _PtG[0]) );
				
				if( !bMinSet ){
					bMinSet = TRUE;
					
					dMinRope = dDistRope;
					bmMinRope = bm;
					bInHeaderRope = bmIsHeader;
				}
				else{
					if( (dMinRope - dDistRope) > dEps ){
						dMinRope = dDistRope;
						bmMinRope = bm;
						bInHeaderRope = bmIsHeader;
					}
				}
			}
			
			arBmStud.append(bmMinRope);
			arBInHeader.append(bInHeaderRope);
			
			_PtG[0] = bmMinRope.ptCen();
			if( !bInHeaderRope ){
				_PtG[0] = bmMinRope.ptRef() + bmMinRope.vecX() * bmMinRope.dLMax();
				if( vyEl.dotProduct(bmMinRope.vecX()) < 0 ){
					_PtG[0] = bmMinRope.ptRef() + bmMinRope.vecX() * bmMinRope.dLMin();
				}
			}
		}
		else if( !bUseFourRopes )
		{
			Point3d ptLeft = centre - vxEl * ratio2Ropes * offsetFromCentre;// ptMin + vxEl * 0.475 * vxEl.dotProduct(_Pt0 - ptMin);
			Point3d ptRight = centre + vxEl * ratio2Ropes * offsetFromCentre;// ptMax + vxEl * 0.475 * vxEl.dotProduct(_Pt0 - ptMax);
	
			if( _PtG.length() != 2){
				_PtG.setLength(0);
				_PtG.append(ptLeft);
				_PtG.append(ptRight);
			}
			//Reset positions when points are at the same location.
			if( (Vector3d(_PtG[1] - _PtG[0])).length() < dEps ){
				_PtG.setLength(0);
				_PtG.append(ptLeft);
				_PtG.append(ptRight);
			}
			
			//ptLeft.vis(2);
			//ptRight.vis(3);
		
			double dMinLeft;
			double dMinRight;
			int bMinSet = FALSE;
			Beam bmMinLeft;
			Beam bmMinRight;
			
			int bInHeaderLeft = FALSE;
			int bInHeaderRight = FALSE;
			for ( int i = 0; i < arBm.length(); i++) {
				Beam bm = arBm[i];
				if (bm.myZoneIndex() != 0) continue;
				//bm.envelopeBody().vis(i);
				int bmIsHeader = FALSE;
				if ( bm.name() == "BigHeader" )
					bmIsHeader = TRUE;
				
				if ( ! bmIsHeader )
				{
					if ( ! bm.vecX().isParallelTo(vyEl))continue;
					
					Beam arBmTConnection[] = bm.filterBeamsCapsuleIntersect(arBm);//, U(10), TRUE);
					int bHasTConnectionWithTopPlate = FALSE;
					
					Beam bmTP;
					for ( int j = 0; j < arBmTConnection.length(); j++) {
						Beam bmTP = arBmTConnection[j];
						Body bdTP = bmTP.realBody();
						//bdTP.vis();
						
						if ( arNTypeTopPlate.find(bmTP.type()) != -1 ) {
							bHasTConnectionWithTopPlate = TRUE;
							break;
						}
					}
					
					if ( ! bHasTConnectionWithTopPlate )continue;
	
				}
			
				bm.ptCen().vis();
				
				double dDistLeft = abs(vxEl.dotProduct(bm.ptCen() - _PtG[0]));
				double dDistRight = abs(vxEl.dotProduct(bm.ptCen() - _PtG[1])) ;
				
				if( !bMinSet ){
					bMinSet = TRUE;
					
					dMinLeft = dDistLeft;
					dMinRight = dDistRight;
					bmMinLeft = bm;
					bmMinRight = bm;
					bInHeaderLeft = bmIsHeader;
					bInHeaderRight = bmIsHeader;
				}
				else{
					if (dMinLeft - dDistLeft > dEps )
					{
						dMinLeft = dDistLeft;
						bmMinLeft = bm;
						bInHeaderLeft = bmIsHeader;
					}
					
					if (dMinRight - dDistRight > dEps )
					{
						dMinRight = dDistRight;
						bmMinRight = bm;
						bInHeaderRight = bmIsHeader;
					}
				}
			}
			
			arBmStud.append(bmMinLeft);
			arBmStud.append(bmMinRight);
			arBInHeader.append(bInHeaderLeft);
			arBInHeader.append(bInHeaderRight);
			
			_PtG[0] = bmMinLeft.ptCen();
	//		bmMinLeft.ptCen().vis(3);
			if( !bInHeaderLeft ){
				_PtG[0] = bmMinLeft.ptRef() + bmMinLeft.vecX() * bmMinLeft.dLMax();
				if( vyEl.dotProduct(bmMinLeft.vecX()) < 0 ){
					_PtG[0] = bmMinLeft.ptRef() + bmMinLeft.vecX() * bmMinLeft.dLMin();
				}
			}
	//		bmMinRight.ptCen().vis(3);
			_PtG[1] = bmMinRight.ptCen();
			if( !bInHeaderRight ){
				_PtG[1] = bmMinRight.ptRef() + bmMinRight.vecX() * bmMinRight.dLMax();
				if( vyEl.dotProduct(bmMinRight.vecX()) < 0 ){
					_PtG[1] = bmMinRight.ptRef() + bmMinRight.vecX() * bmMinRight.dLMin();
				}
			}
		}
		else
		{
			Point3d ptLeft01 = centre - vxEl * ratio4Ropes1 * offsetFromCentre;// ptMin + vxEl * 0.25 * vxEl.dotProduct(_Pt0 - ptMin);
			Point3d ptLeft02 = centre - vxEl * ratio4Ropes2 * offsetFromCentre;// ptMin + vxEl * 0.75 * vxEl.dotProduct(_Pt0 - ptMin);
			Point3d ptRight02 = centre + vxEl * ratio4Ropes1 * offsetFromCentre;// ptMax + vxEl * 0.75 * vxEl.dotProduct(_Pt0 - ptMax);
			Point3d ptRight01 = centre + vxEl * ratio4Ropes2 * offsetFromCentre;// ptMax + vxEl * 0.25 * vxEl.dotProduct(_Pt0 - ptMax);
			if (bDoubleLifting){ 
				ptLeft01 = centre - vxEl * ratio2Ropes * offsetFromCentre;// ptMin + vxEl * 0.475 * vxEl.dotProduct(_Pt0 - ptMin);
				ptLeft02 = ptLeft01 + vxEl * dStudSpacing;
				ptRight01 = centre + vxEl * ratio2Ropes * offsetFromCentre;// ptMax + vxEl * 0.475 * vxEl.dotProduct(_Pt0 - ptMax);
				ptRight02 = ptRight01 - vxEl * dStudSpacing;
			}
			if( _PtG.length() != 4 ){
				_PtG.setLength(0);
				_PtG.append(ptLeft01);
				_PtG.append(ptLeft02);
				_PtG.append(ptRight02);
				_PtG.append(ptRight01);
			}
			
			if( vxEl.dotProduct(_Pt0 - _PtG[0]) <= 0 || vxEl.dotProduct(_Pt0 - _PtG[1]) <= 0 ){
				_PtG[0] = ptLeft01;
				_PtG[1] = ptLeft02;
			}
			if( vxEl.dotProduct(_Pt0 - _PtG[2]) >= 0 || vxEl.dotProduct(_Pt0 - _PtG[3]) >= 0 ){
				_PtG[2] = ptRight02;
				_PtG[3] = ptRight01;
			}
			if( abs(vxEl.dotProduct(_PtG[0] - _PtG[1])) < dEps ){
				_PtG[0] = ptLeft01;
				_PtG[1] = ptLeft02;
			}
			if( abs(vxEl.dotProduct(_PtG[2] - _PtG[3])) < dEps ){
				_PtG[2] = ptRight02;
				_PtG[3] = ptRight01;
			}
			
			int arNSide[] = {-1, 1};
			for( int i=0;i<arNSide.length();i++ ){
				int nSide = arNSide[i];
				int nIndex0 = 1 + nSide;
				int nIndex1 = 2 + nSide;
						
				double dMinLeft;
				double dMinRight;
				int bMinSet = FALSE;
				Beam bmMinLeft;
				Beam bmMinRight;
				
				int bInHeaderLeft = FALSE;
				int bInHeaderRight = FALSE;
				for( int j=0;j<arBm.length();j++ ){
					Beam bm = arBm[j];
					if( nSide * vxEl.dotProduct(_Pt0 - bm.ptCen()) >= 0 )
						continue;
									
					int bmIsHeader = FALSE;
					if( bm.name() == "BigHeader" )
						bmIsHeader = TRUE;
					
					if( arBmInvalidBeamCodes.find(bm.name("beamcode").token(0)) != -1 )
						continue;
					
					if( !bmIsHeader ){
						if( !bm.vecX().isParallelTo(vyEl) || (!bm.envelopeBody().hasIntersection(bdWall) && ! bdWall.volume() > dEps ))
							continue;
						
						Beam arBmTConnection[] = bm.filterBeamsCapsuleIntersect(arBm);//, U(10), TRUE);
						int bHasTConnectionWithTopPlate = FALSE;
						
						Beam bmTP;
						for( int k=0;k<arBmTConnection.length();k++ ){
							Beam bmTP = arBmTConnection[k];
							
							Body bdTP = bmTP.realBody();
							//bdTP.vis();
							
							if( arNTypeTopPlate.find(bmTP.type()) != -1 ){
								bHasTConnectionWithTopPlate = TRUE;
								break;
							}
						}
						
						if( !bHasTConnectionWithTopPlate )
							continue;
					}
					
					double dDistLeft = abs( vxEl.dotProduct(bm.ptCen() - _PtG[nIndex0]) );
					double dDistRight = abs( vxEl.dotProduct(bm.ptCen() - _PtG[nIndex1]) );
					
					if( !bMinSet ){
						bMinSet = TRUE;
						
						dMinLeft = dDistLeft;
						dMinRight = dDistRight;
						bmMinLeft = bm;
						bmMinRight = bm;
						bInHeaderLeft = bmIsHeader;
						bInHeaderRight = bmIsHeader;
					}
					else{
						if( (dMinLeft - dDistLeft) > dEps ){
							dMinLeft = dDistLeft;
							bmMinLeft = bm;
							bInHeaderLeft = bmIsHeader;
						}
						
						if( (dMinRight - dDistRight) > dEps ){
							dMinRight = dDistRight;
							bmMinRight = bm;
							bInHeaderRight = bmIsHeader;
						}
					}
				}
				arBmStud.append(bmMinLeft);
				arBmStud.append(bmMinRight);
				arBInHeader.append(bInHeaderLeft);
				arBInHeader.append(bInHeaderRight);
				_PtG[nIndex0] = bmMinLeft.ptCen();
				if( !bInHeaderLeft ){
					_PtG[nIndex0] = bmMinLeft.ptRef() + bmMinLeft.vecX() * bmMinLeft.dLMax();
					if( vyEl.dotProduct(bmMinLeft.vecX()) < 0 ){
						_PtG[nIndex0] = bmMinLeft.ptRef() + bmMinLeft.vecX() * bmMinLeft.dLMin();
					}
				}
				//_PtG[nIndex0].vis(nIndex0);
				
				_PtG[nIndex1] = bmMinRight.ptCen();
				if( !bInHeaderRight ){
					_PtG[nIndex1] = bmMinRight.ptRef() + bmMinRight.vecX() * bmMinRight.dLMax();
					if( vyEl.dotProduct(bmMinRight.vecX()) < 0 ){
						_PtG[nIndex1] = bmMinRight.ptRef() + bmMinRight.vecX() * bmMinRight.dLMin();
					}
				}
				_PtG[nIndex1].vis(nIndex1);
			}
		}
		
		double dStrapHeight = U(200);
		double dStrapWidth = U(50);
		double dStrapThickness = U(8);
		
		int bmCode = true;	
		if (sBeamcodeToCenterDrills == "" && beamCenterPoint)
		{
			reportMessage(T("|Give beamcode to place the lifing holes|"));
			bmCode = false;
		}
		
		int arNLiftingIndex[0];
		
	//	arBmStud[0].envelopeBody().vis(2);
	//	arBmStud[1].envelopeBody().vis(2);
		// HSB-8824 add trigger to flip side if nToolType==4 is selected
		if(nToolType==4)
		{ 
		// TriggerFlipSide
			int bFlip = _Map.getInt("flip");
			String sTriggerFlipSide = T("|Flip Side (inside)|");
			if(bFlip) sTriggerFlipSide = T("|Flip Side (outside)|");
			addRecalcTrigger(_kContextRoot, sTriggerFlipSide );
			if (_bOnRecalc && (_kExecuteKey==sTriggerFlipSide || _kExecuteKey=="TslDoubleClick"))
			{
				bFlip =! bFlip;
				 _Map.setInt("flip",bFlip);
				 if ( ! bFlip) sBattenInOut.set(sInOut[0]);
				 else sBattenInOut.set(sInOut[1]);
				setExecutionLoops(2);
				return;
			}
		// trigger to decide symmetric batten or asymetric batten
			//1 is symmetric side; 0 is asymmetric side
			// initialize with symmetric
			if(!_Map.hasInt("iSymAsym"))_Map.setInt("iSymAsym",1);
			String sTriggerSymAsymSide = T("|Set Symmetric Batten|");
			int iSymAsym = _Map.getInt("iSymAsym");
			if(iSymAsym)sTriggerSymAsymSide = T("|Set Asymmetric Batten|");
			
			addRecalcTrigger(_kContextRoot, sTriggerSymAsymSide );
			if (_bOnRecalc && (_kExecuteKey==sTriggerSymAsymSide))
			{
				iSymAsym =! iSymAsym;
				 _Map.setInt("iSymAsym",iSymAsym);
				 
				if (iSymAsym) sBattenSymmetry.set(sNoYes[1]);
				else sBattenSymmetry.set(sNoYes[0]);
				setExecutionLoops(2);
				return;
			}
			// 
			if(_kNameLastChangedProp==sBattenSymmetryName)
			{ 
				if(sNoYes.find(sBattenSymmetry)==0)
					_Map.setInt("iSymAsym",0);
				else
					_Map.setInt("iSymAsym",1);
				setExecutionLoops(2);
				return;	
			}
			if(_kNameLastChangedProp==sBattenInOutName)
			{ 
				if(sInOut.find(sBattenInOut)==0)
					_Map.setInt("flip",0);
				else
					_Map.setInt("flip",1);
				setExecutionLoops(2);
				return;	
			}
		}
		
		for( int i=0;i<_PtG.length();i++ )
		{
		//	Body bd(_PtG[i], vyEl, vxEl, vzEl, dStrapHeight, dStrapWidth, dStrapThickness, 0.75, 0, 0);
		//	Drill drill(_PtG[i] + vyEl * 0.75 * dStrapHeight + vzEl * 0.5 * dStrapThickness,_PtG[i] + vyEl * 0.75 * dStrapHeight - vzEl * 0.5 * dStrapThickness,0.25 * dStrapWidth);
		//	bd.addTool(drill);
		//	dp.draw(bd);
//			_PtG[i].vis(6);
	//		Point3d ptt = _PtG[i];
	//		ptt.vis(6);
			if (nToolSide == 3)
			{
				String sFac = "Fac" + i;
				if ( _Map.hasInt(sFac))
				{
					nFacSide = _Map.getInt(sFac);
				}
				if(nFacSide==1)
				{
					if(vyEl.dotProduct(_PtG[i]-_Pt0)<0)
						_PtG[i]+=vyEl*vyEl.dotProduct(_Pt0-_PtG[i]); 
//					_PtG[i] = studProfile.closestPointTo(_PtG[i]);
				}
				else if(nFacSide==-1)
				{
					if(vyEl.dotProduct(_PtG[i]-_Pt0)>0)
						_PtG[i]+=vyEl*vyEl.dotProduct(_Pt0-_PtG[i]); 
//					_PtG[i] = studProfile.closestPointTo(_PtG[i]);
					_PtG[i].vis(2);
				}
			}
			
			if (beamCenterPoint && bmCode)
			{
				for (int index1 = 0; index1 < arBmAll.length(); index1++)
				{
					Beam beamToCheck = arBmAll[index1];
					String beamCodeToCheck = beamToCheck.beamCode();
					int beamCodeFound;
					if (beamCodeToCheck == sBeamcodeToCenterDrills) 
					{
						beamCodeFound = true;
					}
					if (beamCodeToCheck != sBeamcodeToCenterDrills)
					{
						if (index1 == arBmAll.length() -1 && beamCodeFound==false)
						{
							reportMessage(TN("|No beam found in element with beamcode: |" + sBeamcodeToCenterDrills + T("| to place liftingholes|")));
						}
						continue;
					}
					beamCenter = beamToCheck.ptCenSolid();						
					_PtG[i] += vzEl * vzEl.dotProduct(beamCenter - _PtG[i]);
					break;
				}//next index1		
			}
			
	//		if (isSemetric)
	//			dOffsetFromFrameCenter.set(U(0));
			if (dOffsetFromFrameCenter != U(0) && (isSemetric == true) && elementCenterPoint)
				_PtG[i] += vzEl * vzEl.dotProduct((frameCenter + vzEl * dOffsetFromFrameCenter) - _PtG[i]);
	
			if (dOffsetFromFrameCenter != U(0) && (isSemetric == true) && beamCenterPoint)
				_PtG[i] += vzEl * vzEl.dotProduct((beamCenter + vzEl * dOffsetFromFrameCenter) - _PtG[i]);
			if ( nToolType == 0 || nToolType == 1 || nToolType == 3 || nToolType == 4 || nToolType == 5)
			{// Drill stud (and topplate, if tooltype == 0) or none if tooltype ==3 or one drill at topplate if nToolType==4
				Beam bm = arBmStud[i];
				
				int bmIsHeader = arBInHeader[i];
				if( !bmIsHeader )
				{
					// not a header
					String sCutNPAngleStud = bm.strCutP()+">";
					if( bm.vecX().dotProduct(vyEl) < 0 ){
						sCutNPAngleStud = bm.strCutN()+">";
					}
					String sAngleStud = sCutNPAngleStud.token(1,">");
					double dAngleStud = sAngleStud.atof();
					
					if( abs(dAngleStud) > dEps ){
						_PtG[i] -= vyEl * bm.dD(vxEl) * tan(abs(dAngleStud));
					}
					Point3d pts[] = bm.envelopeBody(false, true).intersectPoints(Line(_PtG[i], vyEl));
					if (pts.length() > 0)
						_PtG[i] = pts[pts.length() - 1];
					double dBmW = bm.dD(vxEl);
				
					LineSeg intersectionSegment(_PtG[i] - vyEl * U(10000), _PtG[i] + vyEl * U(10000));
					LineSeg linesegmentsInBeam[] = studProfile.splitSegments(intersectionSegment, true);
					if (linesegmentsInBeam.length() > 0)
					{
						linesegmentsInBeam[0].vis(1);
						Point3d topPoint = linesegmentsInBeam[0].ptEnd();
						for (int iseg=0;iseg<linesegmentsInBeam.length();iseg++) 
						{ 
							LineSeg segI = linesegmentsInBeam[iseg]; 
							Point3d ptTopI = nFacSide*vyEl.dotProduct(segI.ptEnd()-segI.ptStart())>0?segI.ptEnd():segI.ptStart();
							if (nFacSide*vyEl.dotProduct(ptTopI - topPoint) > 0)topPoint = ptTopI;
						}//next iseg
						
	//					LineSeg segmentInBeam = linesegmentsInBeam[0];
	//					segmentInBeam.vis(2);
	//					Point3d topPoint = segmentInBeam.ptEnd();
	//					topPoint.vis();
						_PtG[i] += vyEl * vyEl.dotProduct(topPoint - _PtG[i]);
					}
				
				//	Drill drillStud( _PtG[i] - vyEl * dOffSet - vxEl * 0.51 * dBmW, _PtG[i] - vyEl * dOffSet + vxEl * 0.51 * dBmW, 0.5 * dDiam);
					Drill drillStud( _PtG[i] - nFacSide*vyEl * dOffsetVert - vxEl * dOffsetHor, _PtG[i] - nFacSide*vyEl * dOffsetVert + vxEl * dOffsetHor, 0.5 * dDiam);
					Body bdDrillStud = drillStud.cuttingBody();
					bdDrillStud.vis(4);
					Point3d arPtStudCen[0];
					Point3d ptStudCen;
					Beam arBmVertical[0];
					Beam arBmNotVertical[0];
					for( int j=0;j<arBm.length();j++ ){
						Beam bm=arBm[j];
						//beam must be vertical
						if( !bm.vecX().isParallelTo(vyEl) ){
							arBmNotVertical.append(bm);
							continue;
						}
						else{
							arBmVertical.append(bm);
						}
						
						//Multiple studs next to each other... move lifting to center of connected studs
						if( bdDrillStud.hasIntersection(bm.envelopeBody()) )
						{
							if( arPtStudCen.length() == 0 )
								ptStudCen = bm.ptCen();
							else
								ptStudCen += bm.ptCen();
							arPtStudCen.append(bm.ptCen());
						}
					}
					
					//..move lifting to center of connected studs, resize drill
					if( arPtStudCen.length() > 1 ){
						Point3d p = ptStudCen/arPtStudCen.length();
						_PtG[i] += vxEl * vxEl.dotProduct(ptStudCen/arPtStudCen.length() - _PtG[i]);
						drillStud = Drill( _PtG[i] - nFacSide*vyEl * dOffsetVert - vxEl * dOffsetHor, _PtG[i] - nFacSide*vyEl * dOffsetVert + vxEl * dOffsetHor, 0.5 * dDiam);
					}
					drillStud.excludeMachineForCNC(_kRandek);
					Beam studsToDrill[0];
					Body bdDrill = drillStud.cuttingBody();
					bdDrill.vis(3);
					for ( int j = 0; j < arBmVertical.length(); j++) 
					{
						if ( arNLiftingIndex.find(j) != -1 )continue;
						Beam bmVertical = arBmVertical[j];
						Map mapBeam = bmVertical.subMap("Lifting");
						mapBeam.setInt("LiftingBeam", FALSE);
						if ( bmVertical.envelopeBody().hasIntersection(bdDrill) ) 
						{
							studsToDrill.append(bmVertical);
	
							if (nToolType == 1 || nToolType == 0 || nToolType == 4)
							{
								//add tool
								if ( ! bmVertical.bIsValid())continue;
								bmVertical.addTool(drillStud);
								if ( ! bmVertical.bIsValid())continue;
								
								mapBeam.setInt("LiftingBeam", TRUE);
								arNLiftingIndex.append(j);
							}
						}
						bmVertical.setSubMap("Lifting", mapBeam);
					}
					//Sort the beams in the elX dir
					for(int s1=1;s1<studsToDrill.length();s1++){
						int s11 = s1;
						for(int s2=s1-1;s2>=0;s2--){
							if( vxEl.dotProduct(studsToDrill[s11].ptCen() - studsToDrill[s2].ptCen()) < 0 ){
								studsToDrill.swap(s2, s11);
								s11=s2;
							}
						}
					}
					
					if (nAddReinforcementplate && nToolType != 4 && studsToDrill.length() > 0 && iside < 1)
					{
						//Create reinforcementplate
						double plateHeight = dHeightPlate > U(0) ? dHeightPlate : dOffsetHor * 2;
						double leftPlateWidth = dWidthPlate > U(0) ? dWidthPlate : studsToDrill[0].dD(vzEl);
						PlaneProfile studsToDrillProfile(el.coordSys());
						for (int index = 0; index < studsToDrill.length(); index++)
						{
							Beam studToDrill = studsToDrill[index];
							PlaneProfile beamProfile = studToDrill.envelopeBody(false, true).shadowProfile(Plane(el.ptOrg(), vzEl));
							beamProfile.shrink(-U(2));
							studsToDrillProfile.unionWith(beamProfile);
						}
						studsToDrillProfile.shrink(U(2));
						LineSeg minMaxProfile = studsToDrillProfile.extentInDir(vxEl);
						Point3d center = _PtG[i] + dPlateOffsetHorizontal * vzEl - nFacSide*vyEl * dPlateOffset;
						ptStudCen = minMaxProfile.ptMid();
						double profileWidth = abs(vxEl.dotProduct(minMaxProfile.ptStart() - minMaxProfile.ptEnd()));
						PLine allRingsProfile[] = studsToDrillProfile.allRings();
						if (allRingsProfile.length() < 1) continue;
						PLine outLineStuds = allRingsProfile[0];
						Point3d profilePoints[] = outLineStuds.vertexPoints(false);
						outLineStuds.vis(3);
						for (int index2 = 0; index2 < profilePoints.length() - 1; index2++)
						{
							Point3d vertexPoint = profilePoints[index2];
							Point3d nextVertexPoint = profilePoints[index2 + 1];
							Vector3d edgeVector(nextVertexPoint - vertexPoint);
							edgeVector.normalize();
							Vector3d edgeNormal = vzEl.crossProduct(edgeVector);
							if (edgeNormal.dotProduct(vertexPoint - ptStudCen) < 0)
							{
								edgeNormal *= -1;
							}
							
							if (edgeNormal.dotProduct(vyEl) < dEps) continue;
							
							Plane cutPlane(vertexPoint, edgeNormal);
							Point3d referenceLeft = center - vxEl * (profileWidth * 0.5) - vxEl * dThicknessPlate;
							referenceLeft = Line(referenceLeft, vyEl).intersect(cutPlane, U(0));
							Point3d referenceRight = center + vxEl * (profileWidth * 0.5) + vxEl * dThicknessPlate;
							referenceRight = Line(referenceRight, vyEl).intersect(cutPlane, U(0));
							Point3d reference = vyEl.dotProduct(referenceLeft - referenceRight) < 0 ? referenceLeft : referenceRight;
							reference.vis();
							
							reference -= vyEl * dPlateOffset;
							
							// left
							int signLeftRight[] = {- 1, 1 };
							for (int index = 0; index < signLeftRight.length(); index++)
							{
								int sign = signLeftRight[index];
								Point3d pointLeft = center + vxEl * (profileWidth * 0.5) * sign;
								Sheet reinforcementLeft;
								reinforcementLeft.dbCreate(pointLeft, vyEl, vzEl, vxEl, plateHeight, leftPlateWidth, dThicknessPlate , - 1, 0, 1 * sign);
								entitiesToEraseMap.appendEntity("Entity", reinforcementLeft);
								reinforcementLeft.assignToElementGroup(el, true, sZonePlate, 'Z');
								reinforcementLeft.setMaterial(sMaterialPlate);
								reinforcementLeft.setGrade(sGradePlate);
								reinforcementLeft.setName(sNamePlate);
								reinforcementLeft.setBeamCode(sBeamCodePlate);
								reinforcementLeft.setColor(sColorPlate);
								
								Point3d cutPointLeft = pointLeft - vyEl * plateHeight;
								Vector3d cutVectorLeft = - vyEl.rotateBy(dPlateAngle * sign, vzEl);
								Cut leftCut(cutPointLeft, cutVectorLeft);
								reinforcementLeft.addTool(leftCut);
								cutVectorLeft.vis(cutPointLeft);
							}
							
							break;
						}
					}
					
					if(nToolType==4)
					{ 
						// HSB-8824
						// drill stud and top plate one side is choosen
						int bFlip = _Map.getInt("flip");
						// no flip is the left side by default
						int  iSymAsym = _Map.getInt("iSymAsym");
						
						int iLeft;
						if (abs(vxEl.dotProduct(_PtG[i] - ptStartOutline)) < abs(vxEl.dotProduct(_PtG[i] - ptEndOutline)))
						{ 
							// we are on left side regardless sym or asym
							iLeft = true;
							if(bFlip)
							{ 
								// flipping is triggered
								iLeft = false;
							}
						}
						else
						{ 
							// we are on right side
							iLeft = false;
							if(!iSymAsym)
							{ 
								// asymmetric
								iLeft = true;
							}
							if(bFlip)
							{ 
								iLeft = !iLeft;
							}
						}
						// reinforcing batten is opposite of drilling
						iLeft =! iLeft;
						
						if(iLeft)
						{ 
							// add reinforcing beams
							//Create left reinforcement batten
							Beam firstBeam = studsToDrill[0];
							Point3d ptStudMidFirstStud = firstBeam.ptCen();
							Point3d pointLeft = ptStudMidFirstStud - vxEl * (firstBeam.dD(vxEl) * 0.5);
							
	//						double dBeamLength = U(354);
							if (dBattenLength < U(50))dBattenLength.set(U(50));
							double dBeamLength = dBattenLength;
							double dBeamWidth = U(72);
							double dBeamThickness = U(35);
							Beam beamReinforcementLeft;
							beamReinforcementLeft.dbCreate(pointLeft + vyEl * vyEl.dotProduct(_PtG[i] -pointLeft), vyEl, vzEl, vxEl, 
							dBeamLength, dBeamWidth,dBeamThickness , -nFacSide*1, 0, -1);
							entitiesToEraseMap.appendEntity("Entity", beamReinforcementLeft);
							beamReinforcementLeft.assignToElementGroup(el, true, 0, 'Z');
							beamReinforcementLeft.setBeamCode(";;;;;;;;;;;;");
							beamReinforcementLeft.setMaterial(arBmStud[i].name("material"));
							// HSB-20733
							beamReinforcementLeft.setColor(arBmStud[i].color());
							if(sBattenBeamcode!="")beamReinforcementLeft.setBeamCode(sBattenBeamcode);
							if(sBattenMaterial!="")beamReinforcementLeft.setMaterial(sBattenMaterial);
							if(sBattenGrade!="")beamReinforcementLeft.setGrade(sBattenGrade);
							if(sBattenName!="")beamReinforcementLeft.setName(sBattenName);
							_Map.setEntity("beamReinforcementLeft",beamReinforcementLeft);
						}
						else if (studsToDrill.length()>0)//HSB-24138
						{ 
							//Create left reinforcementplate
							Beam lastBeam = studsToDrill[studsToDrill.length() - 1];
							Point3d ptStudMidLastStud = lastBeam.ptCen();
							Point3d pointRight = ptStudMidLastStud + vxEl * (lastBeam.dD(vxEl) * 0.5);
	//						double dBeamLength = U(354);
							if (dBattenLength < U(50))dBattenLength.set(U(50));
							double dBeamLength = dBattenLength;
							double dBeamWidth = U(72);
							double dBeamThickness = U(35);
							Beam beamReinforcementRight;
							beamReinforcementRight.dbCreate(pointRight + vyEl * vyEl.dotProduct(_PtG[i] -pointRight), vyEl, vzEl, vxEl, 
							dBeamLength, dBeamWidth,dBeamThickness , -nFacSide*1, 0, 1);
							entitiesToEraseMap.appendEntity("Entity", beamReinforcementRight);
							beamReinforcementRight.assignToElementGroup(el, true, 0, 'Z');
							beamReinforcementRight.setBeamCode(";;;;;;;;;;;;");
							beamReinforcementRight.setMaterial(arBmStud[i].name("material"));
							beamReinforcementRight.setColor(arBmStud[i].color());
							// HSB-20733
							if(sBattenBeamcode!="")beamReinforcementRight.setBeamCode(sBattenBeamcode);
							if(sBattenMaterial!="")beamReinforcementRight.setMaterial(sBattenMaterial);
							if(sBattenGrade!="")beamReinforcementRight.setGrade(sBattenGrade);
							if(sBattenName!="")beamReinforcementRight.setName(sBattenName);
							_Map.setEntity("beamReinforcementRight",beamReinforcementRight);
						}
					}
					if( nToolType == 0 )
					{ // Drill topplate
	//					Drill drillLeft( _PtG[i] - vxEl * dOffsetHor - vyEl * dOffsetVert, _PtG[i] - vxEl * dOffsetHor + vyEl * dOffsetVert, 0.5 * dDiam);
	//					if (!isSemetric)
	//					{
	//						drillLeft.transformBy(- vzEl * U(dOffsetFromFrameCenter));
	//					}
	//					Drill drillRight( _PtG[i] + vxEl * dOffsetHor- vyEl * dOffsetVert, _PtG[i] + vxEl * dOffsetHor + vyEl * dOffsetVert, 0.5 * dDiam);
	//					if (!isSemetric)
	//					{
	//						drillRight.transformBy(+vzEl * U(dOffsetFromFrameCenter));
	//					}
						
						for( int j=0;j<arBmNotVertical.length();j++ ){
							Beam bmNotVertical = arBmNotVertical[j];
							Vector3d bmX = bmNotVertical.vecX();
							Vector3d vxDrill = bmNotVertical.vecD(-vyEl);
							Point3d ptDrillLeft;
							Line lineLeft(_PtG[i], - bmX);
							Plane planeLeft(_PtG[i] - vxEl * dOffsetHor, bmX);
							if (lineLeft.hasIntersection(planeLeft, ptDrillLeft))
							{
								if ( ! isSemetric)
								{
									ptDrillLeft.transformBy(vzEl * U(dOffsetFromFrameCenter));
								}
								Drill drillAdjustedLeft(ptDrillLeft - vxDrill * dOffsetVert, ptDrillLeft + vxDrill * dOffsetVert, 0.5 * dDiam);
								Body bdDrillLeft(ptDrillLeft - vxDrill * dOffsetVert, ptDrillLeft + vxDrill * dOffsetVert, 0.5 * dDiam);
								bdDrillLeft.vis(4);
								if ( bdDrillLeft.hasIntersection(bmNotVertical.envelopeBody(false, true)) )
								{								
									bmNotVertical.addTool(drillAdjustedLeft);
	//								bmNotVertical.envelopeBody(false, true).vis(1);
								}
							}
							Point3d ptDrillRight;
							_PtG[i].vis(2);
							Line lineRight(_PtG[i],  bmX);
							Plane planeRight(_PtG[i] + vxEl * dOffsetHor, bmX);
							if (lineRight.hasIntersection(planeRight, ptDrillRight))
							{
								if ( ! isSemetric)
								{
									ptDrillRight.transformBy(-vzEl * U(dOffsetFromFrameCenter));
								}
								Drill drillAdjustedRight(ptDrillRight - vxDrill * dOffsetVert, ptDrillRight + vxDrill * dOffsetVert, 0.5 * dDiam);
								Body bdDrillRight(ptDrillRight - vxDrill * dOffsetVert, ptDrillRight + vxDrill * dOffsetVert, 0.5 * dDiam);
								bdDrillRight.vis(4);
								if ( bdDrillRight.hasIntersection(bmNotVertical.envelopeBody(false, true)) )
								{
									bmNotVertical.addTool(drillAdjustedRight);
	//								bdDrillRight.vis(2);
	//								bmNotVertical.envelopeBody(false, true).vis(2);
									vxDrill.vis(bmNotVertical.ptCen());
								}
							}
						
						}
					}
					if (nToolType == 4 || nToolType == 5)
					{ 
						// drill stud and top plate one side is choosen
						int bFlip = _Map.getInt("flip");
						// no flip is the left side by default
						int  iSymAsym = _Map.getInt("iSymAsym");
						
						int iLeft;
						if (abs(vxEl.dotProduct(_PtG[i] - ptStartOutline)) < abs(vxEl.dotProduct(_PtG[i] - ptEndOutline)))
						{ 
							// we are on left side regardless sym or asym
							iLeft = true;
							if(bFlip)
							{ 
								// flipping is triggered
								iLeft = false;
							}
						}
						else
						{ 
							// we are on right side
							iLeft = false;
							if(!iSymAsym)
							{ 
								// asymmetric
								iLeft = true;
							}
							if(bFlip)
							{ 
								iLeft = !iLeft;
							}
						}
						// 
						
						if(iLeft)
						{ 
							// left side
							Drill drillLeft( _PtG[i] - vxEl * dOffsetHor - vyEl * dOffsetVert, _PtG[i] - vxEl * dOffsetHor + vyEl * dOffsetVert, 0.5 * dDiam);
							if (!isSemetric)
							{
								drillLeft.transformBy(- vzEl * U(dOffsetFromFrameCenter));
							}
							Body bdDrillLeft = drillLeft.cuttingBody();
							for( int j=0;j<arBmNotVertical.length();j++ )
							{
								Beam bmNotVertical = arBmNotVertical[j];
								Vector3d bmX = bmNotVertical.vecX();
								Vector3d vxDrill = bmNotVertical.vecD(-vyEl);
								
								Point3d ptDrillLeft = Line(_PtG[i], bmX).intersect(Plane(_PtG[i] - vxEl * dOffsetHor, bmX), U(0));
								if (!isSemetric)
								{
									ptDrillLeft.transformBy(vzEl * U(dOffsetFromFrameCenter));
								}
								Drill drillAdjustedLeft(ptDrillLeft - vxDrill * dOffsetVert, ptDrillLeft + vxDrill * 2*dOffsetVert, 0.5 * dDiam);
	//							drillAdjustedLeft.cuttingBody().vis();
								bdDrillLeft = drillAdjustedLeft.cuttingBody();
									
								if( bdDrillLeft.hasIntersection(bmNotVertical.envelopeBody()) )
									bmNotVertical.addTool(drillAdjustedLeft);
							}
						}
						else
						{ 
							// right side
							Drill drillRight( _PtG[i] + vxEl * dOffsetHor- vyEl * dOffsetVert, _PtG[i] + vxEl * dOffsetHor + vyEl * dOffsetVert, 0.5 * dDiam);
							if (!isSemetric)
							{
								drillRight.transformBy(+vzEl * U(dOffsetFromFrameCenter));
							}
							
							Body bdDrillRight = drillRight.cuttingBody();
							for( int j=0;j<arBmNotVertical.length();j++ )
							{
								Beam bmNotVertical = arBmNotVertical[j];
								Vector3d bmX = bmNotVertical.vecX();
								Vector3d vxDrill = bmNotVertical.vecD(-vyEl);
								
								Point3d ptDrillRight = Line(_PtG[i], bmX).intersect(Plane(_PtG[i] + vxEl * dOffsetHor, bmX), U(0));
								if (!isSemetric)
								{
									ptDrillRight.transformBy(-vzEl * U(dOffsetFromFrameCenter));
								}
								Drill drillAdjustedRight(ptDrillRight - vxDrill * dOffsetVert, ptDrillRight + vxDrill * 2*dOffsetVert, 0.5 * dDiam);
	//							drillAdjustedRight.cuttingBody().vis();
								bdDrillRight = drillAdjustedRight.cuttingBody();
								if( bdDrillRight.hasIntersection(bmNotVertical.envelopeBody()) )
									bmNotVertical.addTool(drillAdjustedRight);
							}
						}
					}
					// TODO make line/ lus straight
					if (nToolType != 4 && nToolType != 5)
					{ 
						PLine pl(vzEl);
						Point3d pt01 = _PtG[i] + nFacSide*vyEl * dOffsetVert - nFacSide*vxEl * dOffsetHor;
						if (!isSemetric)
						{
							pt01.transformBy(vzEl * U(dOffsetFromFrameCenter));
						}
						Point3d pt02 = _PtG[i] - nFacSide*vyEl * (dOffsetVert - dOffsetHor) - nFacSide*vxEl * dOffsetHor;
						if (!isSemetric)
						{
							pt02.transformBy(vzEl * U(dOffsetFromFrameCenter));
						}
						Point3d pt03 = _PtG[i] - nFacSide*vyEl * (dOffsetVert - dOffsetHor) + nFacSide*vxEl * dOffsetHor;
						if (!isSemetric)
						{
							pt03.transformBy(-vzEl * U(dOffsetFromFrameCenter));
						}
						Point3d pt04 = _PtG[i] + nFacSide*vyEl * dOffsetVert + nFacSide*vxEl * dOffsetHor;
						if (!isSemetric)
						{
							pt04.transformBy(-vzEl * U(dOffsetFromFrameCenter));
						}

						pl.addVertex(pt01);
						pl.addVertex(pt02);
						pl.addVertex(pt03, 1);
						pl.addVertex(pt04);
						pl.close(1);
						dpLifting.draw(pl);
					}
					// display for 
					if (nToolType == 4 || nToolType == 5)
					{ 
						int bFlip = _Map.getInt("flip");
						int  iSymAsym = _Map.getInt("iSymAsym");
						// 
						int iLeft;
						if (abs(vxEl.dotProduct(_PtG[i] - ptStartOutline)) < abs(vxEl.dotProduct(_PtG[i] - ptEndOutline)))
						{ 
							// we are on left side regardless sym or asym
							iLeft = true;
							if(bFlip)
							{ 
								// flipping is triggered
								iLeft = false;
							}
						}
						else
						{ 
							// we are on right side
							iLeft = false;
							if(!iSymAsym)
							{ 
								// asymmetric
								iLeft = true;
							}
							if(bFlip)
							{ 
								iLeft = !iLeft;
							}
						}
						//
						PLine pl(vzEl);
						Point3d pt01;
						if(iLeft)
							pt01= _PtG[i] + nFacSide*vyEl * dOffsetVert - vxEl * dOffsetHor;
						else
							pt01= _PtG[i] + nFacSide*vyEl * dOffsetVert + vxEl * dOffsetHor;
						pt01 += nFacSide*vyEl * U(100);
						Point3d pt02;
						if(iLeft)
							pt02= _PtG[i] - nFacSide*vyEl * ( 0) - vxEl * dOffsetHor;
						else
							pt02= _PtG[i] - nFacSide*vyEl * (0) + vxEl * dOffsetHor;
						if (!isSemetric)
						{
							pt02.transformBy(vzEl * U(dOffsetFromFrameCenter));
						}
						Point3d pt03 = pt02 - nFacSide*vyEl * (dOffsetVert );
						if (iLeft)pt03 += vxEl * (dOffsetHor - .5 * arBmStud[i].dD(vxEl));
						else pt03 -= vxEl * (dOffsetHor - .5 * arBmStud[i].dD(vxEl));
						Point3d pt04;
						if (iLeft) pt04 = pt03 + vxEl * (U(35 + arBmStud[i].dD(vxEl)));
						else pt04 = pt03 - vxEl * (U(35 + arBmStud[i].dD(vxEl)));
						
						pl.addVertex(pt01);
						pl.addVertex(pt02);
						pl.addVertex(pt03);
						pl.addVertex(pt04);
						dpLifting.draw(pl);
					}
				}
				else
				{
					// its a header
					Drill drill(_PtG[i] + vzEl * U(200), _PtG[i] - vzEl * U(200), 0.5 * dDiam);
			
					bm.addTool(drill);
					
					PLine pl(vzEl);
					Point3d pt01 = _PtG[i] + vyEl * 3 * dOffsetVert - vxEl * dOffsetHor;
					if (!isSemetric)
					{
						pt01.transformBy(vzEl * U(dOffsetFromFrameCenter));
					}
					Point3d pt02 = _PtG[i];
					if (!isSemetric)
					{
						pt02.transformBy(vzEl * U(dOffsetFromFrameCenter));
					}
					Point3d pt03 = _PtG[i] + vyEl * 3 * dOffsetVert + vxEl * dOffsetHor;
					if (!isSemetric)
					{
						pt03.transformBy(-vzEl * U(dOffsetFromFrameCenter));
					}
					pl.addVertex(pt01);
					pl.addVertex(pt02);
					pl.addVertex(pt03);
					pl.close(1);
					dpLifting.draw(pl);
				}
			}
		}
	}//next iside
}
_Map.setMap("EntitiesToErase[]", entitiesToEraseMap);
// visualisation
Display dpVisualisation(nColor);
dpVisualisation.addHideDirection(_ZW);
dpVisualisation.addHideDirection(-_ZW);
//dpVisualisation.addHideDirection(vzEl);
//dpVisualisation.addHideDirection(-vzEl);

Point3d ptSymbol01 = ptEl - vyEl * 2 * dSymbolSize;
Point3d ptSymbol02 = ptSymbol01 - (vxEl + vyEl) * dSymbolSize;
Point3d ptSymbol03 = ptSymbol01 + (vxEl - vyEl) * dSymbolSize;

PLine plSymbol01(vzEl);
plSymbol01.addVertex(ptEl);
plSymbol01.addVertex(ptSymbol01);
PLine plSymbol02(vzEl);
plSymbol02.addVertex(ptSymbol02);
plSymbol02.addVertex(ptSymbol01);
plSymbol02.addVertex(ptSymbol03);

dpVisualisation.draw(plSymbol01);
dpVisualisation.draw(plSymbol02);

{
	Display dpVisualisationPlan(nColor);
	dpVisualisationPlan.addViewDirection(_ZW);
	dpVisualisationPlan.addViewDirection(-_ZW);
	
	Point3d ptSymbol01 = ptEl + vzEl * 2 * dSymbolSize;
	Point3d ptSymbol02 = ptSymbol01 - (vxEl - vzEl) * dSymbolSize;
	Point3d ptSymbol03 = ptSymbol01 + (vxEl + vzEl) * dSymbolSize;
	
	PLine plSymbol01(vyEl);
	plSymbol01.addVertex(ptEl);
	plSymbol01.addVertex(ptSymbol01);
	PLine plSymbol02(vyEl);
	plSymbol02.addVertex(ptSymbol02);
	plSymbol02.addVertex(ptSymbol01);
	plSymbol02.addVertex(ptSymbol03);
	
	dpVisualisationPlan.draw(plSymbol01);
	dpVisualisationPlan.draw(plSymbol02);
}













#End
#BeginThumbnail
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
%44`?_]G7
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
        <int nm="BreakPoint" vl="1356" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Correct lifting positions around centre of gravity. Make offset ratios available for users." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="49" />
      <str nm="Date" vl="12/19/2025 11:52:44 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24138 bugfix if no studs to drill are found" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="48" />
      <str nm="Date" vl="6/5/2025 1:57:47 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Adjust drill direction to be done from the outside to the inside of the wall." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="47" />
      <str nm="Date" vl="2/13/2025 11:36:55 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Fixed issue with asymmetric Drills. where second drill had wrong offset in Element Z direction." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="46" />
      <str nm="Date" vl="4/10/2024 10:24:45 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20733: Add properties for batten, beamcode,material,grade,name" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="45" />
      <str nm="Date" vl="2/9/2024 4:54:42 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add label filter" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="44" />
      <str nm="Date" vl="1/17/2024 10:46:31 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add option to only add drill in topplate for 1 side" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="43" />
      <str nm="Date" vl="1/17/2024 10:00:46 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add grade to reinforcement plates" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="42" />
      <str nm="Date" vl="9/20/2022 3:54:50 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Fix issue with alignement multiple studs with different height" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="41" />
      <str nm="Date" vl="8/26/2022 11:05:30 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add option to move reinforcementplates in element z direction." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="40" />
      <str nm="Date" vl="8/25/2022 9:17:43 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add executionloop, because bottom tool stayed in place" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="39" />
      <str nm="Date" vl="3/16/2022 10:55:35 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Only add plates to top and make sure cutsouts are done on all top/bottomplates" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="38" />
      <str nm="Date" vl="3/15/2022 1:17:36 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Restore version" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="36" />
      <str nm="Date" vl="12/9/2021 1:21:20 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Check for intersection of wallbody: make sure wall body is valid" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="35" />
      <str nm="Date" vl="12/9/2021 1:19:45 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Remove duplicate reinforcements and correct _PTG position when 2 beams next to each other" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="34" />
      <str nm="Date" vl="7/2/2021 2:12:54 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Fix start position of reinforcement" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="33" />
      <str nm="Date" vl="6/7/2021 12:49:17 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Remove check for body intersection" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="32" />
      <str nm="Date" vl="6/4/2021 3:41:28 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add Plate offset and angle" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="31" />
      <str nm="Date" vl="6/4/2021 10:55:06 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End