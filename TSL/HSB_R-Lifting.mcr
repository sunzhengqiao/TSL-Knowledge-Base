#Version 8
#BeginDescription
2.30 31/01/2023 Add blockingsheet Author: Robert Pol
Version 2.32 24-5-2024 Create the blocking beam closer to the sides, because in some situations the second rafter is close to the side of the element, which caused the blocking not to stretch. Ronald van Wijngaarden

2.31 11/01/2024 Make sure blocking stays in center of the beams Author: Robert Pol


Version 2.33 24-5-2024 Fill the insulationObjects and topSheets array with the result of the FilterGenbeams. This to make sure that the opbjects drilled in zone 1 and -5 are filtered by beamcode if they don't need to be drilled. Ronald van Wijngaarden

2.34 07/07/2025 Add propertie for material of blocking Author: Robert Pol
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 34
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl adds lifting to the elements
/// </summary>

/// <insert>
/// Select a set of elements. The tsl is reinserted for each element.
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="2.29" date="04.03.2021"></version>

/// <history>
/// AS - 1.00 - 27.10.2011 -	Pilot version
/// AS - 1.01 - 09.11.2011 -	Add properties to assign to a specific zone
/// AS - 1.02 - 15.11.2011 -	Add option to position lifting based on length
/// AS - 1.03 - 16.11.2011 -	Remove existing lifting tsls on insert
/// AS - 1.04 - 02.12.2011 -	Add tool as option.
/// AS - 1.05 - 01.02.2012 -	Add option to position lifting from bottom of the element. Add filter. Add option to snap to tile lath.
/// AS - 1.06 - 03.02.2012 -	Add option to place lifting above centroid, add tool 'double drill with block'
/// AS - 1.06 - 03.02.2012 -	Erase tsl when element is deleted (de-constructed)
/// AS - 1.07 - 03.02.2012 -	Add option to allow lifting for angled/vertical beams
/// AS - 1.08 - 03.02.2012 -	Add option to allow lifting only on side beams
/// AS - 1.09 - 03.02.2012 -	Erase invalid tsls
/// AS - 1.10 - 03.02.2012 -	Return if no beams found
/// AS - 1.11 - 26.09.2012 -	Transform point of gravity to center of element-z. Use hsbCenterOfGravity for calculation ptCen
/// AS - 2.00 - 02.11.2012 -	Prepare it for Content-Dutch
/// AS - 2.01 - 11.01.2013 -	Add option to position drill in block.
/// AS - 2.02 - 24.08.2015 -	Add option for single drill.
/// AS - 2.03 - 14.12.2015 -	Always project lifting point to center of zone 0.
/// AS - 2.04 - 07.07.2016 -	Add option to offset lifting from reference line.
/// AS - 2.05 - 14.07.2016 -	Add option to place blocks for elements above a specified weight.
/// AS - 2.06 - 26.07.2016 -	Assign symbol at element origin to tooling layer of the element.
/// AS - 2.07 - 01.09.2016 -	Add drills to insulation.
/// AS - 2.08 - 07.10.2016 -	Suppress horizontal drills for Unilin
/// AS - 2.09 - 17.01.2017 -	Drills are perpendicular to beam axis and element z.
/// AS - 2.10 - 02.02.2017 -	Add option for different symbols.
/// AS - 2.11 - 07.02.2017 -	Re-enable horizontal drills for Unilin
/// AS - 2.12 - 01.06.2017 -	Use offsetted lifting position to find the side rafters.
/// DR - 2.13 - 04.07.2017-	Beams are now filtered by HSB_G-FilterGenBeams TSL
/// AS - 2.14 - 06.07.2017-	Bugfix fraction of length. Use frame vertices as reference vertices.
/// AS - 2.15 - 07.09.2017-	Add support for multiple instances.
/// AS - 2.16 - 03.11.2017-	Add option to offset from top. Context action to copy to another element.
/// AS - 2.17 - 03.11.2017-	Recalc on double click.
/// AS - 2.18 - 21.12.2017-	Move projected Y to the most aligned vector of the beam.
/// RP - 2.19 - 18.01.2018-	Add drill length property
/// RP - 2.20 - 06.02.2018-	Remove if for filterdefenition, no filter was applied on just beamcodes
/// AS - 2.21 - 24.04.2018- 	Replace warning with notice.
/// FA - 2.22 - 25.05.2018	- 	Fixed the bug of having only one lifting point, also added a filter for the indentifier.
/// RP - 2.23 - 30.08.2018-	Add option to use a custom block and block with symbol. Also change "block" into "blocking"
///RVW - 2.24 - 15.02.2019-	Add check that the tsl cant be executed twice with the same identifier in one element.
/// AS - 2.25 - 05.03.2019-	Export display to modelX.
///RVW - 2.26 - 19.08.2019-	Add option to place the lifting at the top and bottom of the element.
/// FA - 2.27 - 30.03.2020	- 	Added property to add tool to insulation instead of always true
/// RP - 2.28 - 20.07.2020 - Fix bug where code was not compiled
/// Rvw - 2.29 - 04.03.2021 -	Change reportnotice to reportmessage

// #Versions
//2.34 07/07/2025 Add propertie for material of blocking Author: Robert Pol
//2.33 24-5-2024 Fill the insulationObjects and topSheets array with the result of the FilterGenbeams. This to make sure that the opbjects drilled in zone 1 and -5 are filtered by beamcode if they don't need to be drilled. Ronald van Wijngaarden
//2.32 24-5-2024 Create the blocking beam closer to the sides, because in some situations the second rafter is close to the side of the element, which caused the blocking not to stretch. Ronald van Wijngaarden
//2.31 11/01/2024 Make sure blocking stays in center of the beams Author: Robert Pol
//2.30 31/01/2023 Add blockingsheet Author: Robert Pol

/// </history>

//Script uses mm
double dEps = U(.001,"mm");

if( _bOnElementDeleted ){
	eraseInstance();
	return;
}

int executeMode = 0;

String arSLayer[] = {T("|I-Layer|"), T("|D-Layer|"), T("|T-Layer|"), T("|Z-Layer|")};
int arNZoneIndex[] = {0,1,2,3,4,5,6,7,8,9,10};

String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};

PropString tslIdentifier(15, "Pos 1", " " + T("|Tsl identifier|"));
tslIdentifier.setDescription(T("|Only one tsl instance, per identifier, can be attached to an element.|")); 

PropString sSeperator01(0, "", T("|Lifting|"));
sSeperator01.setReadOnly(true);
String arSPositionType[] = {
	T("|Above center|"),
	T("|Fraction of length|"),
	T("|Position from bottom|"),
	T("|Above centroid|"),
	T("|Position from top|")
};
PropString sPositionType(1, arSPositionType, "     "+T("|Position|"),1);

String arLiftingPosition[] = 
{
	T("|Left, right|"),
	T("|Top, bottom|")
};

PropString sLiftingPosition (17, arLiftingPosition, "     "+T("|Lifting position|"), 0);
sLiftingPosition.setDescription(T("|Change the position of the lifting to the left and right of the element, or the top and bottom of the element|."));

PropDouble dMinDistanceAboveCenter(0, U(200), "     "+T("|Minimum distance above center|"));
dMinDistanceAboveCenter.setDescription(T("|Offset from position|")+TN("|Used in combination with| '")+T("|First tilelath above center|'"));
PropDouble dFraction(1, 0.375, "     "+T("|Fraction of element length|"));
PropDouble yOffsetFromReferencePoint(6, U(500), "     "+T("|Position from top or bottom|"));
PropString sScriptNameWeight(8, "HSB-Weight", "     "+T("|Name weight tsl|")); // UNILIN for drill in rafter &  topsheet to align topsheets
PropString sBmCodeBlock(9, "", "     "+T("|Beamcode extra block|"));
PropString sBmMaterialBlock(30, "", "     "+T("|Material extra block|"));
PropString sFindClosestTileLath(6, arSYesNo, "     "+T("|Snap to following tile lath|"),1);

String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = TslInst().getListOfCatalogNames(filterDefinitionTslName);
filterDefinitions.insertAt(0,"");
PropString filterDefinition(13, filterDefinitions, "     "+T("|Filter beams using FilterGenBeams|"));
filterDefinition.setDescription(T("|Filter definition for beams.|") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));

PropString sFilterBC(7,"","     "+T("|Filter genbeams by beamcode|"));
sFilterBC.setDescription(T("|Filter genbeams with these beam codes.|") + TN("|NOTE|: ") + T("|These beam codes are only filtered if the filter definition for beams is left blank!|"));

String arSTypeLiftingBeams[] = {
	T("|Vertical beams only|"),
	T("|Vertical beams at the edge only|"),
	T("|Vertical and angled beams|")
};
PropString sTypeLiftingBeams(10, arSTypeLiftingBeams, "     "+T("|Beams allowed for lifting|"));

PropString sSeperator02(4, "", T("|Lifting tool|"));
String arSTool[] = {T("|Symbol|"), T("|Double drill|"), T("|Double drill with blocking|"), T("|Single drill|"), T("|Custom block|"), T("|Block with symbol|")};
PropString sTool(5, arSTool, "     "+T("|Tool|"));
String symbols[] = {T("|Star|"), T("|Rope|")};
PropString symbol(14 ,symbols, "     "+T("|Symbol|"),0);
PropDouble dDrillDiameter(3, U(24), "     "+T("|Diameter tool|"));
PropDouble horizontalDistanceBetweenDrills(4, U(200), "     "+T("|Horizontal distance between drills|"));
PropDouble verticalDistanceBetweenDrills(5, U(20), "     "+T("|Vertical distance between drills|"));
PropDouble offsetDrills(15, U(0), "     "+T("|Offset drills|"));

PropDouble dToDrillInBlock(7, U(100), "     "+T("|Distance to drill in blocking|"));
PropDouble dDrillLength(10, U(-1), "     "+T("|Length drill|"));
PropDouble onlyPlaceBlockForWeightAbove(9, 0, "     "+T("|Only add blocking for weights above|"));
onlyPlaceBlockForWeightAbove.setFormat(_kNoUnit);
PropString blockName(16, _BlockNames, "     "+T("|Custom block name|"));
PropString sDrillInsulation(17, arSYesNo, "     "+T("|Add tool to insulation|"),0);

String referenceLines[] = {
	T("|Axis rafter|"),
	T("|Bottom line rafter|"),
	T("|Top line rafter|")
};
PropString propReferenceLine(11, referenceLines, "     "+T("|Reference line|"), 0);
PropDouble offsetFromReferenceLine(8, U(20), "     "+T("|Offset from reference line|"));

PropDouble thicknessBlockingSheet(12, U(0), "     "+T("|Thickness blocking sheet|"));
PropDouble offsetBlockingSheet(13, U(2), "     "+T("|Offset blocking sheet from drill|"));
PropDouble heightBlockingSheet(14, U(0), "     "+T("|Height blocking sheet|"));
PropString materialBlockingSheet(18, T("|Underlayment|"), "     "+T("|Material blocking sheet|"));
PropInt colorBlockingSheet(2, 1, "     "+T("|Color blocking sheet|"));

PropString sLayer(2, arSLayer, "     "+T("|Layer|"));
PropInt nZoneIndex(0, arNZoneIndex, "     "+T("|Zone index|"));

PropString sSeperator03(3, "", T("|Visualisation|"));
sSeperator03.setReadOnly(true);
PropInt nColor(1, 3, "     "+T("|Color|"));
PropDouble dSymbolSize(2, U(30), "     "+T("|Symbol size|"));
double gapFromRafter = U(5);

String doubleClickAction = "TslDoubleClick";
String separator = "--------------------------------";
String addLiftingPositionCommand = T("|Add lifting position|");
String recalculateLiftingCommand = T("|Recalculate lifting|");
String copyToAnotherElementCommand = T("|Copy to other element|");

String recalcTriggers[] = 
{
	addLiftingPositionCommand,
	separator,
	recalculateLiftingCommand,
	separator + " ",
	copyToAnotherElementCommand
};
for( int i=0;i<recalcTriggers.length();i++ )
{
	addRecalcTrigger(_kContext, recalcTriggers[i] );
}

String arSRecalcProps[] = 
{
	"     "+T("|Position|"),
	"     "+T("|Minimum distance above center|"),
	"     "+T("|Snap to following tile lath|"),
	"     "+T("|Fraction of element length|"),
	"     "+T("|Position from top or bottom|"),
	 "     "+T("|Lifting position|")
};


// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if( catalogNames.find(_kExecuteKey) != -1 ) 
{
	setPropValuesFromCatalog(_kExecuteKey);
}

if (_bOnInsert) 
{
	if (insertCycleCount() > 1) 
	{
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || catalogNames.find(_kExecuteKey) == -1 )
	{
		showDialog();
	}
	setCatalogFromPropValues(T("_LastInserted"));
	
	Element  selectedElements[0];
	PrEntity ssE(T("|Select elements|"), Element());
	if (ssE.go())
	{
		selectedElements.append(ssE.elementSet());
	}
	
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
		if (!selectedElement.bIsValid()) continue;
		
		
		
		TslInst arTsl[] = selectedElement.tslInst();
		for ( int j = 0; j < arTsl.length(); j++)
		{
			TslInst tsl = arTsl[j];
			if ( ! tsl.bIsValid() || (tsl.scriptName() == strScriptName && tsl.propString(15) == tslIdentifier))
			{
				tsl.dbErase();
			}
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
	reportMessage("\n" + scriptName() + T(" - |No element selected!|"));
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
{
	setPropValuesFromCatalog(T("|_LastInserted|"));
}

tslIdentifier.setReadOnly(true);

Element el = _Element[0];
if (!el.bIsValid())
{
	reportMessage(TN("|The selected element is invalid|!"));
	eraseInstance();
	return;
}

assignToElementGroup(el, true, 0, 'E');

if (_kExecuteKey == copyToAnotherElementCommand) 
{
	Element newElement = getElement(T("|Select a new element|"));
	
	String strScriptName = scriptName();
	Vector3d vecUcsX(1,0,0);
	Vector3d vecUcsY(0,1,0);
	Beam lstBeams[0];
	Entity lstEntities[] = { newElement };
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	Map mapTsl;
	
	TslInst clonedTsl;
	clonedTsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
	clonedTsl.setPropValuesFromMap(_ThisInst.mapWithPropValues());
	clonedTsl.recalcNow(recalculateLiftingCommand);
}

TslInst arTsl[] = el.tslInst();
for( int t=0;t<arTsl.length();t++ ){
	TslInst tsl = arTsl[t];
	if (tsl.scriptName() != scriptName() || tsl.propString(15) != tslIdentifier || tsl.handle() == _ThisInst.handle()) continue;

	tsl.dbErase();
}

if( _kExecuteKey == addLiftingPositionCommand )
{
	_Map.appendEntity("BEAM_"+_PtG.length(), getBeam(T("|Select a beam|")));
	_PtG.append(getPoint(T("|Select a position|")));
}

if( _kExecuteKey == recalculateLiftingCommand)
{
	for( int i=0;i<_Map.length();i++ )
	{
		if( _Map.keyAt(i).token(0, "_") == "BEAM" )
		{
			_Map.removeAt(i, true);
			i--;
		}
	}
	_PtG.setLength(0);
}

if( 
	_bOnElementConstructed || 
	manualInserted || 
	_PtG.length() == 0 || 
	arSRecalcProps.find(_kNameLastChangedProp) != -1 || 
	_kExecuteKey == doubleClickAction)
{
	executeMode = 1;
}

String sFBC = sFilterBC;
sFBC.makeUpper();
String arSExcludeBC = sFBC.tokenize(";");

int nZnIndex = nZoneIndex;
if( nZnIndex > 5 )
	nZnIndex = 5 - nZnIndex;
int nPositionType = arSPositionType.find(sPositionType,1);
int bPlaceAtTileLath = arNYesNo[arSYesNo.find(sFindClosestTileLath,1)];
int nTypeLiftingBeams = arSTypeLiftingBeams.find(sTypeLiftingBeams,0);
int drillInsulation = arNYesNo[arSYesNo.find(sDrillInsulation,0)];

int referenceLine = referenceLines.find(propReferenceLine,0);

int nTool = arSTool.find(sTool, 0);
int bSymbol = (nTool == 0 || nTool == 5);
int bDoubleDrill = (nTool == 1 || nTool == 2);
int bWithBlocking = (nTool == 2);
int bSingleDrill = (nTool == 3);
int bBlock = (nTool == 4 || nTool == 5);
int nSide = arLiftingPosition.find(sLiftingPosition, 0);

CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();
_Pt0 = ptEl;

if (nSide == 1)
{
	Vector3d temp = vxEl;
	vxEl = vyEl;
	vyEl = temp;
}

Line lnX(ptEl, vxEl);
Line lnY(ptEl, vyEl);

// Get beams using filtering TSL and sheeting
GenBeam arGBmAll[] = el.genBeam();
if( arGBmAll.length() == 0 ) return;

// Get beams
GenBeam genBeams[] = el.genBeam();
Entity genBeamEntities[0];
for (int b=0;b<genBeams.length();b++)
{
	genBeamEntities.append(genBeams[b]);
}

Map filterGenBeamsMap;
filterGenBeamsMap.setEntityArray(genBeamEntities, false, "GenBeams", "GenBeams", "GenBeam");
filterGenBeamsMap.setString("BeamCode[]", sFilterBC);
filterGenBeamsMap.setInt("Exclude", true);
int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, filterDefinition, filterGenBeamsMap);
if ( ! successfullyFiltered) 
{
	reportWarning(T("|Beams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
	eraseInstance();
	return;
}
genBeamEntities = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");

Beam arBm[0];
Beam arBmNonHor[0];
Beam arBmVert[0];
Point3d frameVertices[0];
Sheet arSh[0];
Sheet arTileLath[0];
Sheet insulationObjects[0];
Sheet topSheets[0];

for (int e=0;e<genBeamEntities.length();e++) 
{
	Beam bm = (Beam)genBeamEntities[e];
	Sheet sh= (Sheet)genBeamEntities[e]; 
	
	if (bm.bIsValid())
	{
		if( abs(abs(bm.vecX().dotProduct(vxEl)) - 1) > dEps )
		{
			arBmNonHor.append(bm);
		}
		
		if( abs(abs(bm.vecX().dotProduct(vyEl)) - 1) < dEps )
		{
			arBmVert.append(bm);
			bm.envelopeBody().vis(3);
		}
		
		arBm.append(bm);
		frameVertices.append(bm.envelopeBody(false, true).allVertices()); // changed the envelopebody to use with cuts, otherwise it will result in the wrong vertices which causes errors when used on hip and valley rafters.
	}
	else if( sh.bIsValid() )
	{
		arSh.append(sh);
		
		if( sh.myZoneIndex() == 5 )
		{
			arTileLath.append(sh);
		}
		if( sh.myZoneIndex() == -5 ) //Use the filtered sheets to fill the zone -5 (insulationObjects) array
		{
			insulationObjects.append(sh);
		}
		if( sh.myZoneIndex() == 1 ) //Use the filtered sheets to fill the zone 1 (topsheets) array
		{
			topSheets.append(sh);
		}
	}	
}

Point3d elTop = el.zone(99).coordSys().ptOrg();

Point3d arPtElX[] = lnX.orderPoints(frameVertices);
Point3d arPtElY[] = lnY.orderPoints(frameVertices);

if( arPtElX.length() < 2 || arPtElY.length() < 2 )
{
	reportMessage(T("|Not enough points found for lifting positions|"));
	eraseInstance();
	return;
}

Point3d ptElLeft = arPtElX[0];
Point3d ptElRight = arPtElX[arPtElX.length() - 1];
Point3d ptElBottom = arPtElY[0];
Point3d ptElTop = arPtElY[arPtElY.length() - 1];
//ptElBottom.vis(1);
//ptElTop.vis(1);
Point3d ptElMid = (ptElTop + ptElBottom)/2;
ptElMid += vxEl * vxEl.dotProduct((ptElLeft + ptElRight)/2 - ptElMid);
ptElMid += vzEl * vzEl.dotProduct((ptEl - vzEl * 0.5 * el.dBeamWidth()) - ptElMid);
double dElLength = vyEl.dotProduct(ptElTop - ptElBottom);

Plane pnElMid(ptElMid, vzEl);

ptElLeft += vyEl * vyEl.dotProduct(ptElMid - ptElLeft);
ptElRight += vyEl * vyEl.dotProduct(ptElMid - ptElRight);
ptElBottom += vxEl * vxEl.dotProduct(ptElMid - ptElBottom);
ptElTop += vxEl * vxEl.dotProduct(ptElMid - ptElTop);
//ptElLeft.vis(1);
//ptElRight.vis(1);
Point3d referencePosition = ptElMid + vzEl * offsetFromReferenceLine;
if (referenceLine == 1)
{
	referencePosition -= vzEl * 0.5 * el.dBeamWidth();
}
if (referenceLine == 2)
{
	referencePosition += vzEl * (0.5 * el.dBeamWidth() - 2 * offsetFromReferenceLine);
}

Beam arBmLiftingAllowed[0];
if( nTypeLiftingBeams == 0 )
{
	arBmLiftingAllowed.append(arBmVert);
}
else if( nTypeLiftingBeams == 1 )
{
	arBmVert = vxEl.filterBeamsPerpendicularSort(arBmVert);
	if( arBmVert.length() == 0 )
	{
		eraseInstance();
		return;
	}
	
	Beam bmLeft = arBmVert[0];
	Beam bmRight = arBmVert[arBmVert.length() - 1];
	
	if( abs(vxEl.dotProduct(ptElLeft - bmLeft.ptCen())) < U(100) )
	{
		arBmLiftingAllowed.append(bmLeft);
	}
	if( abs(vxEl.dotProduct(ptElRight - bmRight.ptCen())) < U(100) )
	{
		arBmLiftingAllowed.append(bmRight);
	}
}
else
{
	arBmLiftingAllowed.append(arBmNonHor);
}

Point3d ptLiftingRef = ptElMid;

//ptLiftingRef.vis();
// Lifting position based on fraction
Point3d ptLifting = ptElBottom + vyEl * dFraction  * dElLength;
//ptLifting.vis(5);
double elementWeight = 0;

if( nPositionType == 0 )// Lifting based on tilelaths
{
	ptLifting = ptLiftingRef + vyEl * dMinDistanceAboveCenter;
}
else if( nPositionType == 2 )// Lifting at a position from the bottom
{
	ptLifting = ptElBottom + vyEl * yOffsetFromReferencePoint;
}
else if(nPositionType == 4)
{
	ptLifting = ptElTop - vyEl * yOffsetFromReferencePoint;
}


if( nPositionType == 3 || (nTool == 2 && onlyPlaceBlockForWeightAbove > 0))
{
	// Lifting above centroid
	Map mapIO;
	Map mapEntities;
	for (int e=0;e<arGBmAll.length();e++)
	    mapEntities.appendEntity("Entity", arGBmAll[e]);
	mapIO.setMap("Entity[]",mapEntities);
	TslInst().callMapIO("hsbCenterOfGravity", mapIO);
	ptLiftingRef = mapIO.getPoint3d("ptCen");
	ptLiftingRef = Line(ptLiftingRef, _ZW).intersect(Plane(ptEl - vzEl * .5 * el.zone(0).dH(), vzEl), U(0));
	
	ptLifting = ptLiftingRef + vyEl * dMinDistanceAboveCenter;
	
	elementWeight = mapIO.getDouble("Weight");
}

ptLifting += vzEl * vzEl.dotProduct(referencePosition - ptLifting);
//ptLiftingRef.vis(5);
ptLifting += vxEl * vxEl.dotProduct(ptLiftingRef - ptLifting);

double d = vyEl.dotProduct(ptLifting - ptLiftingRef);
if( bPlaceAtTileLath ){
	// Order tile lath
	for(int s1=1;s1<arTileLath.length();s1++){
		int s11 = s1;
		for(int s2=s1-1;s2>=0;s2--){
			if( vyEl.dotProduct(arTileLath[s11].ptCen() - arTileLath[s2].ptCen()) < 0 ){
				arTileLath.swap(s2, s11);
				s11=s2;
			}
		}
	}
	
	// Place lifting position at first tilelath above middle (+minium distance)
//	ptLifting.vis(1);
	for(int i=0;i<arTileLath.length();i++){
		Sheet tileLath = arTileLath[i];
		double dTileLathPosition = vyEl.dotProduct(tileLath.ptCen() - ptLifting);
		if( dTileLathPosition > 0 ){
			ptLifting += vyEl * dTileLathPosition;
			break;
		}
	}
}

//ptLifting.vis(3);
Plane pnLifting(ptLifting, vyEl);

Beam arBmLifting[0];
Point3d arPtLifting[0];

Beam bmLiftingLeft;
Point3d ptLiftingLeft;
Beam arBmLeft[] = Beam().filterBeamsHalfLineIntersectSort(arBmLiftingAllowed, ptLifting, -vxEl);
if( arBmLeft.length() > 0 )
{ 
	bmLiftingLeft = arBmLeft[arBmLeft.length() - 1];
}
else
{
	arBmLeft = Beam().filterBeamsHalfLineIntersectSort(arBmLiftingAllowed, ptLifting, vxEl);
	if( arBmLeft.length() > 0 )
	{
		bmLiftingLeft = arBmLeft[0];
	}
}
if( bmLiftingLeft.bIsValid() ){
	arBmLifting.append(bmLiftingLeft);
	ptLiftingLeft = Line(bmLiftingLeft.ptCen(), bmLiftingLeft.vecX()).intersect(pnLifting,0);
	arPtLifting.append(ptLiftingLeft);
//	ptLiftingLeft.vis(4);
}

Beam bmLiftingRight;
Point3d ptLiftingRight;
Beam arBmRight[] = Beam().filterBeamsHalfLineIntersectSort(arBmLiftingAllowed, ptLifting, vxEl);
if( arBmRight.length() > 0 )
{ 
	bmLiftingRight = arBmRight[arBmRight.length() - 1];
}
else
{
	arBmRight = Beam().filterBeamsHalfLineIntersectSort(arBmLiftingAllowed, ptLifting, -vxEl);
	if( arBmRight.length() > 0 )
	{
		bmLiftingRight = arBmRight[0];	
	}
}
if( bmLiftingRight.bIsValid() ){
	arBmLifting.append(bmLiftingRight);
	ptLiftingRight = Line(bmLiftingRight.ptCen(), bmLiftingRight.vecX()).intersect(pnLifting,0);
	arPtLifting.append(ptLiftingRight);
//	ptLiftingRight.vis(5);
}

if( executeMode == 1 ){
	for( int i=0;i<_Map.length();i++ ){
		if( _Map.keyAt(i).token(0, "_") == "BEAM" ){
			_Map.removeAt(i, true);
			i--;
		}
	}
	_PtG.setLength(0);
	
	for( int i=0;i<arBmLifting.length();i++ ){
		Beam bmLifting = arBmLifting[i];
		_Map.appendEntity("BEAM_"+i, bmLifting);
	}

	_PtG.append(arPtLifting);
}

_PtG = pnElMid.projectPoints(_PtG);

for( int i=0;i<_Map.length();i++ ){
	if( !_Map.hasEntity(i) || _Map.keyAt(i) != "Block" )
		continue;
	
	Entity ent = _Map.getEntity(i);
	ent.dbErase();
	
	_Map.removeAt(i, true);
	i--;
}

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

Vector3d arVxDraw[0];
arVxDraw.append(vxEl);
arVxDraw.append(vzEl);
arVxDraw.append(vxEl);
Vector3d arVyDraw[0];
arVyDraw.append(vyEl);
arVyDraw.append(vyEl);
arVyDraw.append(vzEl);

for ( int i = 0; i < _PtG.length(); i++) {
	Point3d pt = _PtG[i];
	pt += vzEl * vzEl.dotProduct(ptLifting - pt);
	Entity entBm = _Map.getEntity("BEAM_" + i);
	Beam bm = (Beam)entBm;
	
//	pt.vis(i);
//	bm.realBody().vis(i);
	
	Vector3d bmX = bm.vecX();
	Vector3d projectedBmY = vzEl.crossProduct(bmX);
	projectedBmY.normalize();
	
	
	if (nSide == 1)
	{
		Vector3d bmz = bm.vecZ() * bm.dD(bm.vecZ());
		Vector3d bmy = bm.vecY() * bm.dD(bm.vecY());
		
		double distanceZ = abs(projectedBmY.dotProduct(bmz));
		double distanceY = abs(projectedBmY.dotProduct(bmy));
		// RP always get the vector with the smallest dotproduct to projectedBmY
		projectedBmY = bm.vecY();
		
		if (distanceZ < distanceY && distanceZ > dEps)
		{
			projectedBmY = bm.vecZ();
		}
	}
	else
	{
		projectedBmY = bm.vecD(projectedBmY);
	}
	
//	projectedBmY.vis(pt, i);
	
	Point3d referencePositionBeam = bm.ptCen() + vzEl * vzEl.dotProduct(referencePosition - bm.ptCen());//offsetFromReferenceLine;
	
	Plane pnLift(pt, vyEl);
	Line lnBm(referencePositionBeam, bm.vecX());
	
	_PtG[i] = lnBm.intersect(pnLift,0);
	
	if( bSymbol)
	{
		if (symbol == symbols[0]) 
		{
			for(int j=0;j<arVxDraw.length();j++){
				//Define vectors
				Vector3d vxDraw = arVxDraw[j];
				Vector3d vyDraw = arVyDraw[j]; 
				Vector3d vSlash = vxDraw + vyDraw;
				vSlash.normalize();
				Vector3d vBackSlash = -vxDraw + vyDraw;
				vBackSlash.normalize();
				//Create polylines
				double dSize = U(60);
				PLine plHor(_PtG[i] - vxDraw * dSize, _PtG[i] + vxDraw * dSize);
				PLine plVer(_PtG[i] - vyDraw * dSize, _PtG[i] + vyDraw * dSize);
				PLine plSlash(_PtG[i] - vSlash * dSize, _PtG[i] + vSlash * dSize);
				PLine plBackSlash(_PtG[i] - vBackSlash * dSize, _PtG[i] + vBackSlash * dSize);
				//Draw polylines
				dpLifting.draw(plHor);
				dpLifting.draw(plVer);
				dpLifting.draw(plSlash);
				dpLifting.draw(plBackSlash);
			}
		}
		else
		{
			PLine plRope(el.vecZ());
			Point3d ptRope = _PtG[i] + bm.vecY() * 0.5 * bm.dW();
			plRope.addVertex(ptRope + el.vecY() * 0.5 * U(300));
			plRope.addVertex(ptRope - el.vecY() * 0.5 * U(300), U(200), _kCWise);
			plRope.addVertex(ptRope + el.vecY() * 0.5 * U(300), U(200), _kCWise);
			dpLifting.draw(plRope);
		}			
	}
	else if( bSingleDrill || bDoubleDrill )
	{
		Point3d arPtDrill[0];
		if (bSingleDrill) {
			arPtDrill.append(_PtG[i] + bmX * offsetDrills);
		}
		else {
			arPtDrill.append((_PtG[i] + bmX * offsetDrills) - vyEl * .5 * horizontalDistanceBetweenDrills + vzEl * .5 * verticalDistanceBetweenDrills);
			arPtDrill.append((_PtG[i] + bmX * offsetDrills) + vyEl * .5 * horizontalDistanceBetweenDrills - vzEl * .5 * verticalDistanceBetweenDrills);
		}
		
//		GenBeam insulationObjects[] = el.genBeam(-5);
//		GenBeam topSheets[] = el.genBeam(1);
		if (topSheets.length() > 0)
			insulationObjects.append(topSheets);

		for( int j=0;j<arPtDrill.length();j++ ){
			Point3d ptDrill = arPtDrill[j];
			ptDrill = Line(ptDrill, vxEl).intersect(Plane(bm.ptCen(), projectedBmY), U(0));
			
			double drillLength = 2 * bm.dD(vxEl);
			if (dDrillLength > 0)
			{
				drillLength = dDrillLength;
			}
						
			Point3d ptStartDrill = ptDrill - projectedBmY * drillLength;
			Point3d ptEndDrill = ptDrill + projectedBmY * drillLength;
			
			Drill drill(ptStartDrill, ptEndDrill, 0.5 * dDrillDiameter);
			int bmsDrills = drill.addMeToGenBeamsIntersect(arBm);

			if (drillInsulation) {
				double offsetDrillInInsulation = 0.5 * (bm.dD(vxEl) + dDrillDiameter) + gapFromRafter;
			
				Drill insulationDrills[0];
				Point3d startDrill, endDrill;
				if (i==0) {
					startDrill = ptDrill + vxEl * vxEl.dotProduct(ptElLeft - vxEl * U(10) - ptDrill);
					endDrill = ptDrill + vxEl * (offsetDrillInInsulation + 0.5 * dDrillDiameter);
				}
				else {
					startDrill = ptDrill + vxEl * vxEl.dotProduct(ptElRight +vxEl * U(10) - ptDrill);
					endDrill = ptDrill - vxEl * (offsetDrillInInsulation + 0.5 * dDrillDiameter);
				}
				insulationDrills.append(Drill(startDrill, endDrill, 0.5 * dDrillDiameter));
				
				int sides[] = {1, -1};
				for (int s=0;s<sides.length();s++) {
					int side = sides[s];
					
					Point3d drillPosition = ptDrill + vxEl * side * offsetDrillInInsulation;
					startDrill = drillPosition + vzEl * vzEl.dotProduct(elTop - drillPosition);
					endDrill = drillPosition - vzEl * 0.5 * dDrillDiameter;
					
					insulationDrills.append(Drill(startDrill, endDrill, 0.5 * dDrillDiameter));
				}

				for (int d=0;d<insulationDrills.length();d++)
					int bmsDrills = insulationDrills[d].addMeToGenBeamsIntersect(insulationObjects);
				
				if (sScriptNameWeight == "UNILIN" && topSheets.length() > 0) {
					Point3d drillPosition = ptDrill - vyEl * U(100);
					startDrill = drillPosition + vzEl * vzEl.dotProduct(el.zone(2).coordSys().ptOrg() - drillPosition);
					endDrill = startDrill - vzEl * U(38);
					
					Drill drill(startDrill, endDrill, U(4));
					drill.addMeToGenBeamsIntersect(arBm);
					drill.addMeToGenBeamsIntersect(topSheets);
				}
			}
			
			if (sScriptNameWeight != "UNILIN") {
				// draw symbols
				PLine plStartDrill(vxEl);
				plStartDrill.createCircle(ptStartDrill, projectedBmY, 0.5 * dDrillDiameter);
				PLine plDrill(ptStartDrill, ptEndDrill);
				PLine plEndDrill(vxEl);
				plEndDrill.createCircle(ptEndDrill, projectedBmY, 0.5 * dDrillDiameter);
				dpLifting.color(1);
				dpLifting.draw(plStartDrill);
				dpLifting.draw(plEndDrill);
				dpLifting.color(7);
				dpLifting.draw(plDrill);
			}
		}
		if( bWithBlocking && onlyPlaceBlockForWeightAbove <=  elementWeight){			
			Vector3d vxBlock = vxEl;
			if( vxBlock.dotProduct(ptLiftingRef - _PtG[i]) < 0 )
				vxBlock *= -1;
			Vector3d vzBlock = vzEl;
			Vector3d vyBlock = -vyEl;
			
			Point3d ptBlock = _PtG[i] + vxBlock * U(50);
			Body bdBlock(ptBlock, vxBlock, vyBlock, vzBlock, U(10), el.dBeamHeight(), el.dBeamWidth(), 0, 0, 0);
//			bdBlock.vis();
			
			Beam arBmLeft[] = Beam().filterBeamsHalfLineIntersectSort(arBmNonHor, ptBlock, -vxBlock);
			Beam arBmRight[] = Beam().filterBeamsHalfLineIntersectSort(arBmNonHor, ptBlock, vxBlock);
			
			if( arBmRight.length() * arBmLeft.length() == 0 )
				continue;
			
			Beam bmLeft = arBmLeft[0];
			Beam bmRight = arBmRight[0];
			
			Point3d blockingInsertionPoint = _PtG[i] + vzBlock * vzBlock.dotProduct(ptElMid - _PtG[i]);
			
			Beam bmBlock;
			bmBlock.dbCreate(blockingInsertionPoint + vxBlock * U(50), vxBlock, vyBlock, vzBlock, U(10), el.dBeamHeight(), el.dBeamWidth(), 0, 0, 0);
			bmBlock.assignToElementGroup(el, true, 0, 'Z');
			bmBlock.setBeamCode(sBmCodeBlock);
			bmBlock.setMaterial(sBmMaterialBlock);
			bmBlock.setColor(32);
			bmBlock.stretchStaticTo(bmLeft, _kStretchOnToolChange);
			bmBlock.stretchStaticTo(bmRight, _kStretchOnToolChange);
			_Map.appendEntity("Block", bmBlock);
			
			Point3d ptDrillExtraBlock = _PtG[i] + vxBlock * dToDrillInBlock;
			Drill drill(ptDrillExtraBlock - vyBlock * el.dBeamHeight(), ptDrillExtraBlock + vyBlock * el.dBeamHeight(), 0.5 * dDrillDiameter);
			
			bmBlock.addTool(drill);
			
			if (thicknessBlockingSheet > 0 && heightBlockingSheet > 0)
			{
				Sheet blockingSheet;
				Point3d blockingSheetInsertionPoint = _PtG[i];
				blockingSheetInsertionPoint += vzBlock * vzBlock.dotProduct((bm.ptCen() - vzBlock * bm.dD(vzBlock) * 0.5) - blockingSheetInsertionPoint);
				blockingSheetInsertionPoint += vxBlock * vxBlock.dotProduct((bm.ptCen() + vxBlock * bm.dD(vxBlock) * 0.5) - blockingSheetInsertionPoint);
				blockingSheetInsertionPoint += vyBlock * el.dBeamHeight() * 0.5;
				
				blockingSheetInsertionPoint.vis();
				double widthBlockingSheet = abs(vxBlock.dotProduct(blockingSheetInsertionPoint - ptDrillExtraBlock)) - offsetBlockingSheet - dDrillDiameter * 0.5;
				blockingSheet.dbCreate(blockingSheetInsertionPoint, vxBlock, vzBlock, vyBlock, widthBlockingSheet, heightBlockingSheet, thicknessBlockingSheet, 1, 1, 1);
				blockingSheet.setMaterial(materialBlockingSheet);
				blockingSheet.setColor(colorBlockingSheet);
				blockingSheet.assignToElementGroup(el, true, 0, 'Z');
				_Map.appendEntity("Block", blockingSheet);
			}

	
		}
	}
	if (bBlock)
	{
		Point3d insertPointBlock = _PtG[i];
		dpLifting.draw(Block(blockName), insertPointBlock, vxEl, vyEl, vzEl); 
	}
}

// visualisation
Display dpVisualisation(nColor);
dpVisualisation.textHeight(U(4));
dpVisualisation.addHideDirection(_ZW);
dpVisualisation.addHideDirection(-_ZW);
dpVisualisation.elemZone(el, 0, 'T');

Point3d ptSymbol01 = _Pt0 - vyEl * 2 * dSymbolSize;
Point3d ptSymbol02 = ptSymbol01 - (vxEl + vyEl) * dSymbolSize;
Point3d ptSymbol03 = ptSymbol01 + (vxEl - vyEl) * dSymbolSize;

PLine plSymbol01(vzEl);
plSymbol01.addVertex(_Pt0);
plSymbol01.addVertex(ptSymbol01);
PLine plSymbol02(vzEl);
plSymbol02.addVertex(ptSymbol02);
plSymbol02.addVertex(ptSymbol01);
plSymbol02.addVertex(ptSymbol03);

dpVisualisation.draw(plSymbol01);
dpVisualisation.draw(plSymbol02);

Vector3d vxTxt = vxEl + vyEl;
vxTxt.normalize();
Vector3d vyTxt = vzEl.crossProduct(vxTxt);
dpVisualisation.draw(scriptName(), ptSymbol01, vxTxt, vyTxt, -1.1, 1.75);
dpVisualisation.draw(tslIdentifier, ptSymbol01, vxTxt, vyTxt, -2.1, -1.75);

{
	Display dpVisualisationPlan(nColor);
	dpVisualisationPlan.textHeight(U(4));
	dpVisualisationPlan.addViewDirection(_ZW);
	dpVisualisationPlan.addViewDirection(-_ZW);
	dpVisualisationPlan.elemZone(el, 0, 'I');
	
	Point3d ptSymbol01 = _Pt0 + vzEl * 2 * dSymbolSize;
	Point3d ptSymbol02 = ptSymbol01 - (vxEl - vzEl) * dSymbolSize;
	Point3d ptSymbol03 = ptSymbol01 + (vxEl + vzEl) * dSymbolSize;
	
	PLine plSymbol01(vyEl);
	plSymbol01.addVertex(_Pt0);
	plSymbol01.addVertex(ptSymbol01);
	PLine plSymbol02(vyEl);
	plSymbol02.addVertex(ptSymbol02);
	plSymbol02.addVertex(ptSymbol01);
	plSymbol02.addVertex(ptSymbol03);
	
	dpVisualisationPlan.draw(plSymbol01);
	dpVisualisationPlan.draw(plSymbol02);
	
	Vector3d vxTxt = vxEl - vzEl;
	vxTxt.normalize();
	Vector3d vyTxt = vyEl.crossProduct(vxTxt);
	dpVisualisationPlan.draw(scriptName(), ptSymbol01, vxTxt, vyTxt, -1.1, 1.75);
	dpVisualisationPlan.draw(tslIdentifier, ptSymbol01, vxTxt, vyTxt, -2.1, -1.75);
}





#End
#BeginThumbnail
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
G`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`/_9
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
      <str nm="Comment" vl="Add propertie for material of blocking" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="34" />
      <str nm="Date" vl="7/7/2025 9:39:32 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Fill the insulationObjects and topSheets array with the result of the FilterGenbeams. This to make sure that the opbjects drilled in zone 1 and -5 are filtered by beamcode if they don't need to be drilled." />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="33" />
      <str nm="Date" vl="5/24/2024 9:02:15 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Create the blocking beam closer to the sides, because in some situations the second rafter is close to the side of the element, which caused the blocking not to stretch." />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="32" />
      <str nm="Date" vl="5/24/2024 8:28:44 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Make sure blocking stays in center of the beams" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="31" />
      <str nm="Date" vl="1/11/2024 1:02:49 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add blockingsheet" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="30" />
      <str nm="Date" vl="1/31/2023 10:37:13 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End