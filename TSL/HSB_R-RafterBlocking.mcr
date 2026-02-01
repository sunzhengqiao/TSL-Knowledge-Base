#Version 8
#BeginDescription
Last modified by: Anno Sportel (support.nl@hsbcad.com)
12.01.2018  -  version 1.07

This TSL creates blocking next to rafters.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 7
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This TSL creates blocking next to rafters.
/// </summary

/// <insert>
/// Select a set of elements.
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.07" date="12.01.2018"></version>

/// <history>
/// YB - 1.00 - 20.04.2017 -	Pilot version
/// YB - 1.01 - 20.04.2017 -	Added a beamcut
/// YB - 1.02 - 01.06.2017 - 	Changed the way how rafters are selected, now uses Beam Type instead of HsbID. Removed HsbId property. 
/// 							Rotated length and width of blocking. Set standard blocking length to rafter height.
/// 							Added bottom offset from reference point. Changed the beamcut positioning. Added a display option.
/// YB - 1.03 - 01.06.2017 - 	Added an option to offset from top instead of bottom. Changed the way the blockings are positioned in Y axis.
/// AS - 1.04 - 01.06.2017 - 	Assign tsl to the element. Position grippoint at the center of the milling.
/// YB - 1.05 - 06.07.2017 - 	Changed point where intersections get found
/// AS - 1.06 - 03.11.2017 - 	Correct beamcut positions. Replace filter definition with beam code filter. Add double click action. Add option to copy to another element.
/// AS - 1.07 - 12.01.2018 - 	Change origin blocking. Offset now based on drill position.
/// </history>

// Properties
double vectorTolerance = U(0.01, "mm");

String arCategories[] = { T("|Blocking information|"), T("|Positioning|"), T("|Filtering|"), T("|Beam properties|"), T("|Tooling|"), T("|Display|") };
String arNoYes[] = { T("|No|"), T("|Yes|") };
String arBlockingOptions[] = { T("|Left side only|"), T("|Left and right side|"), T("|Right side|") };
String arTools[] = { T("|No tool|"), T("|Beamcut|") };
String arReference[] = { T("|Top|"), T("|Bottom|")};

// Blocking information
PropDouble propBlockingLength(0, U(100), T("|Blocking length|"));			propBlockingLength.setCategory(arCategories[0]);	propBlockingLength.setDescription(T("|Specifies the blocking length.|") + TN("|If value is 0, default rafter height is used.|"));
PropDouble propBlockingHeight(1, U(20), T("|Blocking height|"));				propBlockingHeight.setCategory(arCategories[0]);	propBlockingHeight.setDescription(T("|Specifies the blocking height.|") + TN("|If value is 0, default rafter height is used.|"));
PropDouble propBlockingWidth(2, U(20), T("|Blocking width|"));				propBlockingWidth.setCategory(arCategories[0]);		propBlockingWidth.setDescription(T("|Specifies the blocking width.|") + TN("|If value is 0, default rafter width is used.|"));

// Positioning
PropString sBlockingReference(16, arReference, T("|Blocking reference|"));		sBlockingReference.setCategory(arCategories[1]);		sBlockingReference.setDescription(T("|Specifies the blocking reference|"));
PropDouble dVerticalOffset(3, U(500), T("|Blocking vertical offset|"));			dVerticalOffset.setCategory(arCategories[1]);			dVerticalOffset.setDescription(T("|Specifies the bottom offset for the blocking.|"));
PropString sBlockingOptions(2, arBlockingOptions, T("|Blocking position|"));	sBlockingOptions.setCategory(arCategories[1]);		sBlockingOptions.setDescription(T("|Specifies the positions of the blockings.|") + TN("|If blocking position is left side only, first rafter will be skipped automatically.|") + TN("|If blocking position is right side only, last rafter will be skipped automatically.|"));
PropString sAlternateBlocking(3, arNoYes, T("|Alternate blocking|"));			sAlternateBlocking.setCategory(arCategories[1]); 		sAlternateBlocking.setDescription(T("|Specifies if the blocking should alternate.|"));
PropString sSkipFirstBlocking(4, arNoYes, T("|Skip first rafter|"));				sSkipFirstBlocking.setCategory(arCategories[1]); 		sSkipFirstBlocking.setDescription(T("|Specifies if the first rafter should be skipped.|"));

// Filtering
PropString sBlockingFilter(0, "", T("|Blocking - HSB ID|"));						sBlockingFilter.setCategory(arCategories[2]); 			sBlockingFilter.setDescription(T("|Specify the HSB ID for removing blockings.|") + TN("|All beams with this ID will be removed!|"));

String filterDefinitionTslName = "HSB_G-FilterGenBeams";
PropString filterBeamCodes(15, "", T("|Rafters - Beam codes|"));
filterBeamCodes.setDescription(T("|A semi colon seperated list of beam codes|.") + T(" |Beams with a beam code from this list will be excluded.|"));
filterBeamCodes.setCategory(arCategories[2]);

// Beam properties
PropInt bmColor(0, 52, T("|Color blocking beam|"));
bmColor.setDescription(T("|Sets the color of the blocking beam.|"));
bmColor.setCategory(arCategories[3]);

PropString bmName(5, "", T("|Name blocking beam|"));
bmName.setDescription(T("|Sets the name of the blocking beam.|"));
bmName.setCategory(arCategories[3]);

PropString bmMaterial(6, "", T("|Material blocking beam|"));
bmMaterial.setDescription(T("|Sets the material of the blocking beam.|"));
bmMaterial.setCategory(arCategories[3]);

PropString bmGrade(7, "", T("|Grade blocking beam|"));
bmGrade.setDescription(T("|Sets the grade of the blocking beam.|"));
bmGrade.setCategory(arCategories[3]);

PropString bmInformation(8, "", T("|Information blocking beam|"));
bmInformation.setDescription(T("|Sets the information of the blocking beam.|"));
bmInformation.setCategory(arCategories[3]);

PropString bmLabel(9, "", T("|Label blocking beam|"));
bmLabel.setDescription(T("|Sets the label of the blocking beam.|"));
bmLabel.setCategory(arCategories[3]);

PropString bmSubLabel(10, "", T("|Sublabel blocking beam|"));
bmSubLabel.setDescription(T("|Sets the sublabel of the blocking beam.|"));
bmSubLabel.setCategory(arCategories[3]);

PropString bmSubLabel2(11, "", T("|Sublabel2 blocking beam|"));
bmSubLabel2.setDescription(T("|Sets the sublabel2 of the blocking beam.|"));
bmSubLabel2.setCategory(arCategories[3]);

PropString bmBeamcode(12, "", T("|Beamcode blocking beam|"));
bmBeamcode.setDescription(T("|Sets the beamcode of the blocking beam.|"));
bmBeamcode.setCategory(arCategories[3]);

PropString bmHSBID(14, "", T("|HSB ID blocking beam|"));
bmHSBID.setDescription(T("|Sets the HSB ID of the blocking beam.|"));
bmHSBID.setCategory(arCategories[3]);

// Tooling
PropString sToolType(13, arTools, T("|Tool type|"));
sToolType.setCategory(arCategories[4]);
sToolType.setDescription(T("|Sets the tool type.|"));
PropDouble sToolDepth(5, U(5), T("|Tooling depth|"));
sToolDepth.setCategory(arCategories[4]);
sToolDepth.setDescription(T("|Sets the tooling depth.|"));
PropDouble sToolHeight(6, U(5), T("|Tooling height|"));
sToolHeight.setCategory(arCategories[4]);
sToolHeight.setDescription(T("|Sets the tooling height.|"));
PropDouble dVerticalOffsetBeamcut(8, U(0), T("|Vertical offset|"));
dVerticalOffsetBeamcut.setCategory(arCategories[4]);
dVerticalOffsetBeamcut.setDescription(T("|Sets the vertical offset for the beamcut.|"));

// Display
PropInt nColor(0, 4, T("|Color|"));
nColor.setCategory(arCategories[5]);
nColor.setDescription(T("|Specifies the color of the visualisation symbol.|"));

PropDouble dSymbolSize(7, U(40), T("|Symbol size|"));
dSymbolSize.setCategory(arCategories[5]);
dSymbolSize.setDescription(T("|Specifies the size of the visualisation symbol.|"));

// Get catalog names
String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if (_kExecuteKey != "" && catalogNames.find(_kExecuteKey) != -1) 
 {
 	setPropValuesFromCatalog(_kExecuteKey);
 }


// Insert
if(_bOnInsert)
{
	if(insertCycleCount() > 1) { eraseInstance(); return; }
	
	 if( _kExecuteKey == "" || catalogNames.find(_kExecuteKey) == -1 )
 	 	showDialog();
	 setCatalogFromPropValues(T("_LastInserted"));
	
	// Prompt for elements
	PrEntity prElements(T("|Select a set of elements.|"), Element());
	if(prElements.go())
	{
		// Retrieve elements
		Element elements[] = prElements.elementSet();
		
		// Create basic properties for multi element.
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
		 for (int e=0; e<elements.length(); e++) 
		 {
  			Element selectedElement = elements[e];
 		 	if (!selectedElement.bIsValid())
  				continue;
  
 			lstEntities[0] = selectedElement;
  
  			TslInst tslNew;
			tslNew.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
 		}
 	}
	eraseInstance();
	return;
}

// Check if element is selected.
if( _Element.length() != 1 ){
 	reportWarning(TN("|No element selected!|"));
	eraseInstance();
 	return;
}

// Check if manual inserted.
int manualInserted = false;
if (_Map.hasInt("ManualInserted")) {
	manualInserted = _Map.getInt("ManualInserted");
}

// Set properties from catalog when manual inserted.
if (_bOnDbCreated && manualInserted)
	setPropValuesFromCatalog(T("|_LastInserted|"));
	
// Check for beams that were created before
for (int i=0;i<_Map.length();i++) 
{
  	if (_Map.keyAt(i) != "Beam")
  		continue;
 	if (!_Map.hasEntity(i))
 		continue;
  
 	Entity ent = _Map.getEntity(i);
 	ent.dbErase();
  
	_Map.removeAt(i, true);
	i--;
 }
 
String separator = "--------------------------------";
String deleteCommand = T("|Delete|");
String copyToAnotherElementCommand = T("|Copy to other element|");

String recalcTriggers[] = 
{
	deleteCommand,
	separator,
	copyToAnotherElementCommand
};
for (int r=0;r<recalcTriggers.length();r++)
{
	addRecalcTrigger(_kContext, recalcTriggers[r]);
}


String doubleClickAction = "TslDoubleClick";
 if (_bOnRecalc && (_kExecuteKey==deleteCommand || _kExecuteKey==doubleClickAction))
 {
 	eraseInstance();
 	return;
 }	
 
 int referenceSide = arReference.find(sBlockingReference);
	
// Configure the filter for deleting
String hsbIdFilter = sBlockingFilter;
hsbIdFilter.makeUpper();
String HSBIDs[] = hsbIdFilter.tokenize(";");

// Resolving properties
int iBlockingOptions = arBlockingOptions.find(sBlockingOptions, 0);
int iSkipFirst = arNoYes.find(sSkipFirstBlocking, 0);
int iAlternateBlocking = arNoYes.find(sAlternateBlocking, 0);
int iTooling = arTools.find(sToolType, 0);

// Retrieve element
Element el = _Element[0];
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
	clonedTsl.recalcNow();
}

double dBlockingHeight = propBlockingHeight;
double dBlockingLength = propBlockingLength;
double dBlockingWidth = propBlockingWidth;

// Logical statements
if(dBlockingHeight <= 0)
	dBlockingHeight = el.dBeamWidth();
if(dBlockingWidth <= 0)
	dBlockingWidth = el.dBeamHeight();
 
// Create basic properties for element
CoordSys csEl = el.coordSys();
Vector3d elX = csEl.vecX();
Vector3d elY = csEl.vecY();
Vector3d elZ = csEl.vecZ();
Point3d elOrg = el.ptOrg();

// Set TSL position to element origin.
_Pt0 = elOrg;

// Visualize the vectors
elX.vis(_Pt0, 1);
elY.vis(_Pt0, 3);
elZ.vis(_Pt0, 150);

// Allowed beam types
double arBeamTypes[] = { _kDakCenterJoist};

// Retrieve all beams of the element.
Beam beams[] = el.beam();

// Create arrays for all the beams  you want.
Beam verticalBeams[0];
Beam horizontalBeams[0];
Beam angledBeams[0];
Beam rafterBeams[0];

for(int b = 0; b < beams.length(); b++)
{
	// Get the current beam
	Beam bm = beams[b];
	
	// Check if the beam is a blocking..
	for(int h = 0; h < HSBIDs.length(); h++)
	{
		if(bm.hsbId() != HSBIDs[h])
			continue;
			
		bm.dbErase();
		beams.removeAt(b);
		b--;
		break;
	}
}

Entity genBeams[0];
Entity filteredGenBeams[0];

for (int b = 0; b < beams.length(); b++)
{
	genBeams.append((Entity)beams[b]);
}

if (filterBeamCodes != "")
{
	Map filterGenBeamsMap;
	filterGenBeamsMap.setEntityArray(genBeams, false, "GenBeams", "GenBeams", "GenBeam");
	filterGenBeamsMap.setString("BeamCode[]", filterBeamCodes);
	filterGenBeamsMap.setInt("Exclude", true);
	int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, "", filterGenBeamsMap);
	if ( ! successfullyFiltered) {
		reportWarning(T("|Beams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
		eraseInstance();
		return;
	}
	genBeams = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");
}

for(int b = 0; b < genBeams.length(); b++)
{
	Beam bm = (Beam)genBeams[b];
	// Check if the beam is still valid.
	if(!bm.bIsValid()) continue;
	// Check if the beam is a rafter.
	for (int h = 0; h < arBeamTypes.length(); h++)
	{
		if (bm.type() == arBeamTypes[h])
		{
			rafterBeams.append(bm);
		}
	}

	// Append the beam to horizontal, vertical or angled beam array.
	if(abs(elY.dotProduct(bm.vecX())) < vectorTolerance)
	{
		horizontalBeams.append(bm);
	}
	else if(round(abs(elY.dotProduct(bm.vecX()))) == 1)
	{
		verticalBeams.append(bm);
	}
	else
	{
		angledBeams.append(bm);
	}
}

PlaneProfile totalProfile(csEl);
double standardRafterLength = U(1);

for(int i = 0; i < rafterBeams.length(); i++)
{
	if(i == 0)
	{
		standardRafterLength = rafterBeams[i].dD(elZ);
	}
	PlaneProfile rafterPr = rafterBeams[i].envelopeBody().getSlice(Plane(rafterBeams[i].ptCen(), elZ));
	rafterPr.shrink(-2);
	totalProfile.unionWith(rafterPr);
}

if(dBlockingLength <= 0)
{
	dBlockingLength = standardRafterLength;
}
	
double verticalOffset = dVerticalOffset;
	
if(referenceSide == 0)
{
	verticalOffset = -verticalOffset;
}

totalProfile.shrink(2);

Point3d ptGrip[] = PlaneProfile(el.plEnvelope()).getGripVertexPoints();
Point3d ptGripY[] = Line(elOrg, elY).orderPoints(ptGrip);

double totalHeight = abs(elY.dotProduct(ptGripY[0] - ptGripY[ptGripY.length() - 1]));

Point3d ptLook = elOrg;
if(referenceSide == 0)
{
	ptLook += elY * totalHeight;
}

_Pt0 = ptLook + elY * verticalOffset;
//if (iTooling == 1)
//{
//	_Pt0 += elY * dVerticalOffsetBeamcut;
//}
ptLook.vis();
LineSeg lineSeg(_Pt0 - elX * U(1000), _Pt0 + elX * U(10000));
//if (iTooling == 1)
//{
//	lineSeg.transformBy(-elY * dVerticalOffsetBeamcut);
//}
lineSeg.vis();
LineSeg lineSegs[] = totalProfile.splitSegments(lineSeg, true);

for(int i = 0; i < lineSegs.length(); i++)
{
	LineSeg sg = lineSegs[i];
	sg.vis(1);
}

int step = 1;

// Loop through all rafter beams.
for(int b = 0; b < lineSegs.length(); b+= step)
{	
	if(b == 0 && iAlternateBlocking && !iSkipFirst)
		step = 2;
	if(b != 0 || b != lineSegs.length() - 1)
	{
		if(b == 1 && iSkipFirst && !iAlternateBlocking)
			continue;
		if(b == 2 && iSkipFirst && iAlternateBlocking)
			continue;
		if(b == 3 && step != 2 && iAlternateBlocking)
			step = 2;
		if(b == lineSegs.length() - 2)
			step = 1;
	}

	Point3d ptLeft = lineSegs[b].ptStart();// + elY * verticalOffset;
	Point3d ptRight = lineSegs[b].ptEnd();// + elY * verticalOffset;

	Beam blockingBeam;

	Point3d blockingPositions[0];
	int xFlags[0];
	if(iBlockingOptions == 0)
	{
		if(b == 0)
		{
			blockingPositions.append(ptRight);
			xFlags.append(1);
		}
		else
		{
			blockingPositions.append(ptLeft);
			xFlags.append(-1);			
		}
	}
	else if(iBlockingOptions == 1)
	{
		if(b == 0)
		{
			blockingPositions.append(ptRight);
			xFlags.append(1);
		}
		else if(b != 0 && b != lineSegs.length() - 1)
		{
			blockingPositions.append(ptLeft);
			blockingPositions.append(ptRight);
			xFlags.append(-1);
			xFlags.append(1);
		}
		else
		{
			blockingPositions.append(ptLeft);
			xFlags.append(-1);		
		}
	}
	
	else if(iBlockingOptions == 2)
	{
		if(b == lineSegs.length() - 1)
		{
			blockingPositions.append(ptLeft);
			xFlags.append(-1);
		}
		else
		{
			blockingPositions.append(ptRight);
			xFlags.append(1);			
		}
	}
	
	int yFlag = (referenceSide == 0) ? 1 : - 1;
	for(int i = 0; i < blockingPositions.length(); i++)
	{
		Point3d blockOrg = blockingPositions[i] - elY * yFlag * dVerticalOffsetBeamcut;
		blockingBeam.dbCreate(blockOrg, elZ, elX, elY, dBlockingLength, dBlockingWidth, dBlockingHeight, -1, xFlags[i], yFlag);
		_Map.appendEntity("Beam", blockingBeam);
		blockingBeam.assignToElementGroup(el, true, 0, 'Z');
		blockingBeam.setColor(bmColor);
		blockingBeam.setName(bmName);
		blockingBeam.setMaterial(bmMaterial);
		blockingBeam.setGrade(bmGrade);
		blockingBeam.setInformation(bmInformation);
		blockingBeam.setLabel(bmLabel);
		blockingBeam.setSubLabel(bmSubLabel);
		blockingBeam.setSubLabel2(bmSubLabel2);
		blockingBeam.setBeamCode(bmBeamcode);
		blockingBeam.setHsbId(bmHSBID);
		
		if(iTooling == 1)
		{
			Point3d drillPosition = blockingBeam.ptCen() - elX * xFlags[i] * 0.5 * dBlockingWidth;
			drillPosition += elY * elY.dotProduct(_Pt0 - drillPosition);
			BeamCut bc(drillPosition, elZ, elX, elY, dBlockingLength, sToolDepth, sToolHeight, 0, xFlags[i], 0);
			blockingBeam.addTool(bc);		
		}
	}
}

String textSymbol = "B";
if(referenceSide == 0)
	textSymbol = "T";

// visualisation
Point3d symbolOrigin = el.ptOrg();

Display dpVisualisation(nColor);
dpVisualisation.textHeight(U(4));
dpVisualisation.addHideDirection(_ZW);
dpVisualisation.addHideDirection(-_ZW);
dpVisualisation.elemZone(el, 0, 'T');

Point3d ptSymbol01 = symbolOrigin - elY * 2 * dSymbolSize;
Point3d ptSymbol02 = ptSymbol01 - (elX + elY) * dSymbolSize;
Point3d ptSymbol03 = ptSymbol01 + (elX - elY) * dSymbolSize;

PLine plSymbol01(elZ);
plSymbol01.addVertex(symbolOrigin);
plSymbol01.addVertex(ptSymbol01);
PLine plSymbol02(elZ);
plSymbol02.addVertex(ptSymbol02);
plSymbol02.addVertex(ptSymbol01);
plSymbol02.addVertex(ptSymbol03);

dpVisualisation.draw(plSymbol01);
dpVisualisation.draw(plSymbol02);

Vector3d vxTxt = elX + elY;
vxTxt.normalize();
Vector3d vyTxt = elZ.crossProduct(vxTxt);
dpVisualisation.draw(scriptName(), ptSymbol01, vxTxt, vyTxt, -1.1, 1.75);
dpVisualisation.draw(textSymbol + dVerticalOffset, ptSymbol01, vxTxt, vyTxt, -2.1, -1.75);
{
	Display dpVisualisationPlan(nColor);
	dpVisualisationPlan.textHeight(U(4));
	dpVisualisationPlan.addViewDirection(_ZW);
	dpVisualisationPlan.addViewDirection(-_ZW);
	dpVisualisationPlan.elemZone(el, 0, 'T');
	
	Point3d ptSymbol01 = symbolOrigin + elZ * 2 * dSymbolSize;
	Point3d ptSymbol02 = ptSymbol01 - (elX - elZ) * dSymbolSize;
	Point3d ptSymbol03 = ptSymbol01 + (elX + elZ) * dSymbolSize;
	
	PLine plSymbol01(elY);
	plSymbol01.addVertex(symbolOrigin);
	plSymbol01.addVertex(ptSymbol01);
	PLine plSymbol02(elY);
	plSymbol02.addVertex(ptSymbol02);
	plSymbol02.addVertex(ptSymbol01);
	plSymbol02.addVertex(ptSymbol03);
	
	dpVisualisationPlan.draw(plSymbol01);
	dpVisualisationPlan.draw(plSymbol02);
	
	Vector3d vxTxt = elX - elZ;
	vxTxt.normalize();
	Vector3d vyTxt = elY.crossProduct(vxTxt);
	dpVisualisationPlan.draw(scriptName(), ptSymbol01, vxTxt, vyTxt, -1.1, 1.75);
	dpVisualisation.draw(textSymbol + dVerticalOffset, ptSymbol01, vxTxt, vyTxt, -2.1, -1.75);
}
#End
#BeginThumbnail





#End