#Version 8
#BeginDescription
V1.13 - 23.03.2018 - Ignore extra mill if dimensions are invalid.
V1.12 - 25.04.2017 - Apply extra mill between boxes at different heights if the are close to each other. (FogBugzId 844)
KC - 1.14	- 31.01.2019 - Add a tag property to OPM properties and display contents - Updated output text


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 14
#KeyWords 
#BeginContents
/// <summary>
/// This TSL creates a wirechase and an electral installation in a wall element.
/// </summary>

/// <insert>
/// Select an element and an insertion point
/// </insert>

/// <remark>
/// 
/// </remark>

/// <history>
/// AS - 1.00 - 16.06.2014	- Pilot version
/// AS - 1.01 - 17.06.2014	- Prepare the tsl to assign the installation types to the holes.
/// AS - 1.02 - 27.06.2014	- Add option for 3 or 4 drills
/// AS - 1.03 - 16.09.2014	- Extra mill is not added if one of the values is zero or negative.
/// AS - 1.04 - 17.09.2014	- Mill for the wirechase is not added if one of the values is zero or negative.
/// AS - 1.05 - 05.11.2014	- Correct beamcuts for an aligned wirechase. (FogBugzId 465)
/// AS - 1.06 - 05.11.2014	- Add support for different quantities per height. (FogBugzId 467)
/// AS - 1.07 - 05.11.2014	- Visualize the installation types in plan and elevation view. (FogBugzId 467)
/// AS - 1.08 - 13.11.2014	- Correct position of first extra mill
/// AS - 1.09 - 25.02.2015	- Extra mill depth is only used for the first extra mill at that height, 
///									the other extra mills respect the depth of the boxes. (FogBugzId 844)
///									Add option to specify a maximum height for the wire chase.
/// AS - 1.10 - 25.02.2015 - Add option to add a subtype as dimension information (FogBugzId 848).
/// AS - 1.11 - 08.06.2015 - Use depth of box for extra mill if boxes are touching each other. (FogBugzId 848)
/// AS - 1.12 - 25.04.2017 - Apply extra mill between boxes at different heights if the are close to each other. (FogBugzId 844)
/// AS - 1.13 - 23.03.2018 - Ignore extra mill if dimensions are invalid.
/// KC - 1.14	- 31.01.2019 - Add a tag property to OPM properties and display contents - Updated output text
/// </history>


// basics and props
double dEps = Unit(0.01,"mm");


// General properties
// The height of the finished floor.
PropDouble dHeightFinishedFloor(0, U(190), T("|Height finished floor|"));
dHeightFinishedFloor.setDescription(T("|Sets the height of the finished floor.|") + T(" |The height for the installation is measured from the finished floor.|"));
dHeightFinishedFloor.setCategory(T("|General settings|"));

// The height of the soleplate.
PropDouble dHeightSoleplate(1, U(38), T("|Height soleplate|"));
dHeightSoleplate.setDescription(T("|Sets the height of the soleplate.|") + T(" |The height of the soleplate.|"));
dHeightSoleplate.setCategory(T("|General settings|"));

// The subtype of this tsl. This is used for dimensioning in HSB_D-Element.
PropString sSubType(6, "", T("|Sub type|"));
sSubType.setDescription(T("|Sets the sub type of this tsl.|") + T(" |The sub type can be used to differentiate between the different installation points on dimension lines.|"));
sSubType.setCategory(T("|General settings|"));

// Installation properties
// The quantity.
PropString sQuantity(0, "1", T("|Quantity|"), 1);
sQuantity.setDescription(T("|Sets the amount of boxes.|") + 
								 TN("|Seperate the quantities with a semicolon if different quantities per height are required.|"));
sQuantity.setCategory(T("|Installation|"));

// The height from finished floor.
PropString sHeight(1, "1100", T("|Height from finished floor|"));
sHeight.setDescription(T("|Sets the height.|") + T(" |The height is measured from the finished floor.|") + 
							  TN("|Seperate the heights with a semicolon if the boxes are placed at different heights.|"));
sHeight.setCategory(T("|Installation|"));

// The height from finished floor.
PropString sTag(7, "Type1", T("|Tag|"));
sTag.setDescription(T("|Set the tag type of the fixture.|") );
sTag.setCategory(T("|Installation|"));

// The diameter of the installation.
PropDouble dDiameter(3, U(69), T("|Diameter|"));
dDiameter.setDescription(T("|Sets the diameter.|"));
dDiameter.setCategory(T("|Installation|"));

// The depth of the installation.
PropDouble dDepth(4, U(50),T("|Depth|"));	
dDepth.setDescription(T("|Sets the depth.|"));
dDepth.setCategory(T("|Installation|"));

// The distance between two installation points.
PropDouble dBetweenInstallations(5,U(71), T("|Offset between installations|"));		
dBetweenInstallations.setDescription(T("|Sets the offset between the installations.|"));
dBetweenInstallations.setCategory(T("|Installation|"));

// The type of installations
PropString sInstallationTypes(2, "", T("|Installation types|"));
sInstallationTypes.setDescription(T("|The installation types can be set through a custom action.|")+TN("|This action is available in the right mouse click menu.|"));
sInstallationTypes.setReadOnly(true);
sInstallationTypes.setCategory(T("|Installation|"));


// Properties for extra mill
// The width.
PropDouble dWidthExtraMill(7, U(40), T("|Width extra mill|"));
dWidthExtraMill.setDescription(T("|Sets the width.|"));
dWidthExtraMill.setCategory(T("|Extra mill|"));

// The height.
PropDouble dHeightExtraMill(8, U(40), T("|Height extra mill|"));
dHeightExtraMill.setDescription(T("|Sets the height.|"));
dHeightExtraMill.setCategory(T("|Extra mill|"));

// The depth.
PropDouble dDepthExtraMill(6, U(50), T("|Depth extra mill|"));
dDepthExtraMill.setDescription(T("|Sets the depth.|"));
dDepthExtraMill.setCategory(T("|Extra mill|"));


// Properties for wire chase
// The side of the wire chase
String arSSide[] = {T("|Left|"), T("|Right|"), T("|Aligned|")};
int arNSide[] = {1, -1, 0};
PropString sSideWireChase(3, arSSide, T("|Side wire chase|"));
sSideWireChase.setDescription(T("|Sets the side of the wire chase.|") + T("|The side is taken while looking towards the installation.|"));
sSideWireChase.setCategory(T("|Wire chase|"));

// The direction of the wire chase
String arSDirection[] = {T("|Up|"), T("|Down|"), T("|Up and down|")};
int arNDirection[] = {1, -1, 0};
PropString sDirectionWireChase(4, arSDirection, T("|Direction wire chase|"), 1);
sDirectionWireChase.setDescription(T("|Sets the direction of the wire chase.|"));
sDirectionWireChase.setCategory(T("|Wire chase|"));


PropDouble dMaxHeightWireChase(14, U(0), T("|Maximum height wire chase|"));
dMaxHeightWireChase.setDescription(T("|Sets the maximum height of the wire chase.|") + T("|Zero allows the wire chase to go all the way up.|"));
dMaxHeightWireChase.setCategory(T("|Wire chase|"));

// The width.
PropDouble dWidthWireChase(10, U(30), T("|Width wire chase|"));
dWidthWireChase.setDescription(T("|Sets the width.|"));
dWidthWireChase.setCategory(T("|Wire chase|"));

// The depth.
PropDouble dDepthWireChase(9, U(30), T("|Depth wire chase|"));
dDepthWireChase.setDescription(T("|Sets the depth.|"));
dDepthWireChase.setCategory(T("|Wire chase|"));


// Properties for the style
PropString sDimStyle(5, _DimStyles, T("|Dimension style|"));
sDimStyle.setDescription(T("|Sets the dimension style.|") + T(" |Its used to visualize the assigned installation types.|"));
sDimStyle.setCategory(T("|Style|"));

// Text size elevation
PropDouble dBoxIndexTextSizeElevation(11, U(5), T("|Text size box index|"));
dBoxIndexTextSizeElevation.setDescription(T("|Sets the text size for the box index.|") + TN("|The box index is visible in elevation view|"));
dBoxIndexTextSizeElevation.setCategory(T("|Style|"));

// Text size elevation
PropDouble dTextSizeElevation(12, U(30), T("|Text size elevation view|"));
dTextSizeElevation.setDescription(T("|Sets the text size for the text in elevation view.|"));
dTextSizeElevation.setCategory(T("|Style|"));

// Text size elevation
PropDouble dTextSizePlan(13, U(15), T("|Text size plan view|"));
dTextSizePlan.setDescription(T("|Sets the text size for the text in plan view.|"));
dTextSizePlan.setCategory(T("|Style|"));

String arSTrigger[] = {
	T("|Set installation types|")
};
for( int i=0;i<arSTrigger.length();i++ )
	addRecalcTrigger(_kContext, arSTrigger[i] );



// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_P-InstallationPoint");
if (arSCatalogNames.find(_kExecuteKey) != -1) 
	setPropValuesFromCatalog(_kExecuteKey);

if (_bOnInsert) {
	if (insertCycleCount() > 1) {
		eraseInstance();
		return;
	}
	
	if (_kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1)
		showDialog();
	
	Element elSelected = getElement(T("|Select a wall|"));
	if (elSelected.bIsKindOf(ElementWall())) {
		_Element.append(elSelected);
	}
	else {
		reportWarning(T("|Invalid element selected.|") + T(" |A wall is required.|"));
		_Element.append(getElement(T("|Select a wall|")));
	}
	
	_Pt0 = getPoint();

	return;
}

// Is there an element selected?
if (_Element.length() == 0) {
	reportWarning(T("|No element selected|"));
	eraseInstance();
	return;
}


// The selected element.
Element el = _Element[0];
if (!el.bIsKindOf(ElementWall())) {
	reportWarning(T("|Invalid element selected.|") + T(" |A wall is required.|"));
	eraseInstance();
	return;
}

//Store the sub type. This is used for dimensioning with HSB_D-Element
Map mapDimInfo;
mapDimInfo.setString("SubType", sSubType);
_Map.setMap("DimInfo", mapDimInfo);

// Assign the tsl to the element layer.
_ThisInst.assignToElementGroup(el, true, 0, 'E');


// Coordinate system of the element.
CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

// Genbeams from the element.
GenBeam arGBm[] = el.genBeam();

// project selected point to contour
PLine plOutlineWall= el.plOutlineWall();
Point3d pt = plOutlineWall.closestPointTo(_Pt0) + vyEl * (dHeightFinishedFloor - dHeightSoleplate);
Point3d ptOutlineWall[] = plOutlineWall.vertexPoints(true);
if (Vector3d(_Pt0-pt).length()>dEps)
	_Pt0 = pt;


// the installation side
int nSide = 1;
Point3d ptMid;
ptMid.setToAverage(ptOutlineWall);
ptMid.vis(5);
if (vzEl.dotProduct(_Pt0 - ptMid) < 0)
	nSide *= -1;
Vector3d vzE = nSide * vzEl;
Vector3d vxE = vyEl.crossProduct(vzE);
vxE.vis(_Pt0,1);
vzE.vis(_Pt0,150);


// Get the installation locations and make them available as readonly grips.
int nAlignment = arNSide[arSSide.find(sSideWireChase,0)];
int nDirectionWireChase = arNDirection[arSDirection.find(sDirectionWireChase,1)];
int bWireChaseIsAligned = nAlignment == 0;
if (bWireChaseIsAligned)
	nAlignment = 1;
_PtG.setLength(0);


String sList = sHeight + ";";
sList.makeUpper();
double arDHeight[0];
int nTokenIndex = 0; 
int nListIndex = 0;
while (nListIndex < (sList.length() - 1)) {
	String sListItem = sList.token(nTokenIndex);
	nTokenIndex++;
	if (sListItem.length() == 0) {
		nListIndex++;
		continue;
	}
	nListIndex = sList.find(sListItem,0);
	sListItem.trimLeft();
	sListItem.trimRight();
	double dHeight = sListItem.atof();
	if (dHeight > 0.0)
		arDHeight.append(dHeight);
}

sList = sQuantity + ";";
sList.makeUpper();
int arNQuantity[0];
nTokenIndex = 0; 
nListIndex = 0;
while (nListIndex < (sList.length() - 1)) {
	String sListItem = sList.token(nTokenIndex);
	nTokenIndex++;
	if (sListItem.length() == 0) {
		nListIndex++;
		continue;
	}
	nListIndex = sList.find(sListItem,0);
	sListItem.trimLeft();
	sListItem.trimRight();
	int nQuantity = sListItem.atoi();
	if (nQuantity <= 0) {
		reportNotice(TN("|Invalid quantity!|") + T("|Quantity is set to one|."));
		nQuantity = 1;
	}
	arNQuantity.append(nQuantity);
}

if (arNQuantity.length() < arDHeight.length()) {
	int nQty;
	if (arNQuantity.length() == 0)
		nQty = 1;
	else
		nQty = arNQuantity[arNQuantity.length()  - 1];
		
	for (int i=arNQuantity.length();i<arDHeight.length();i++)
		arNQuantity.append(nQty);
}

// Sort the installation heights from bottom to top.
for(int s1=1;s1<arDHeight.length();s1++){
	int s11 = s1;
	for(int s2=s1-1;s2>=0;s2--){
		if( arDHeight[s11] < arDHeight[s2] ){
			arDHeight.swap(s2, s11);
			arNQuantity.swap(s2, s11);
			s11=s2;
		}
	}
}


int bMinMaxHeightSet = false;
double dMinHeight, dMaxHeight;
for (int h=0;h<arDHeight.length();h++) {
	double dHeight = arDHeight[h];
	int nQuantity = arNQuantity[h];
	
	if (!bMinMaxHeightSet) {
		dMinHeight = dHeight;
		dMaxHeight = dHeight;
		bMinMaxHeightSet = true;
	}
	else{
		if (dHeight > dMaxHeight)
			dMaxHeight = dHeight;
		if (dHeight < dMinHeight)
			dMinHeight = dHeight;
	}
	int startGripIndexAtThisHeight = _PtG.length();
	_PtG.append(_Pt0 + vyEl * dHeight);
	for (int p=1;p<nQuantity;p++)
		_PtG.append(_PtG[_PtG.length() - 1] + vxE * nAlignment * dBetweenInstallations);
	
	
	// Apply the drills
	for (int i=startGripIndexAtThisHeight;i<_PtG.length();i++) {
		Point3d ptDrill = _PtG[i];
		Drill drill(ptDrill, -vzE, dDepth, 0.5 * dDiameter);
		int bIsDrillApplied = drill.addMeToGenBeamsIntersect(arGBm);
		
		Point3d ptBmCut = _PtG[i] - vxE * nAlignment * 0.5 * dDiameter;
		int bFirstDrillAtThisHeight = i==startGripIndexAtThisHeight;//(i/2.0 - i/2) == 0.0;
		double dDepthMill = dDepth;
		if (bFirstDrillAtThisHeight) 
		{
			// Only use the extra mill depth for the first extra mill. Follow the depth of the boxes for the other extra mills.
			dDepthMill = dDepthExtraMill;
			
//			// Also use the depth of the boxes if the previous height was close to this height
//			if (h>0) 
//			{
//				if ((dHeight - arDHeight[h-1]) < (dDiameter + .5 * dHeightExtraMill))
//					dDepthMill = dDepth;
//			}
			
			if (bWireChaseIsAligned) {
				ptBmCut = _PtG[i] - vyEl * 0.5 * dDiameter;
				if (
					nDirectionWireChase == 0 && 
					(dWidthExtraMill * dHeightExtraMill * dDepthMill) > 0
				) { // Wire chase goes up and down.
					BeamCut bmCut(ptBmCut - vzE * dDepthMill, vxE, vyEl, vzE, dWidthExtraMill, dHeightExtraMill, 1.1 * dDepthMill, 0, 0, 1);
					int bIsExtraMillApplied = bmCut.addMeToGenBeamsIntersect(arGBm);
					ptBmCut += vyEl * dDiameter;
				}
				else if (nDirectionWireChase == 1) { // Wire chase goes up.
					ptBmCut += vyEl * dDiameter;
				}
			}
			else {
				//ptBmCut -= vxE * nAlignment * (dWidthWireChase - 0.5 * dWidthExtraMill);
				ptBmCut.vis(2);
			}
		}
		if ((dWidthExtraMill * dHeightExtraMill * dDepthMill * dDepth) > 0) {
			double dWExtraMill = dWidthExtraMill;
			if (bFirstDrillAtThisHeight && !bWireChaseIsAligned) {
				dWExtraMill += dWidthWireChase - 0.5 * dWidthExtraMill;
				
				ptBmCut -= vxE * nAlignment * 0.5 * (dWidthWireChase - 0.5 * dWidthExtraMill);
			}
			BeamCut bmCut(ptBmCut - vzE * dDepthMill, vxE, vyEl, vzE, dWExtraMill, dHeightExtraMill, 1.1 * dDepthMill, 0, 0, 1);
			int bIsExtraMillApplied = bmCut.addMeToGenBeamsIntersect(arGBm);
			Body bd = bmCut.cuttingBody();
			bd.vis(3);
		}

		// Apply extra milling between boxes
		if (h>0 && (dWidthExtraMill * dHeightExtraMill * dDepthExtraMill) > 0) 
		{
			if ((dHeight - arDHeight[h-1]) < (dDiameter + .5 * dHeightExtraMill))
			{
				int side = 1;
				if (dHeight < arDHeight[h-1])
					side *= -1;
				
				Point3d ptBmCutBetweenHeights = _PtG[i] - vyEl * side * 0.5 * dDiameter;
				BeamCut bmCut(ptBmCutBetweenHeights - vzE * dDepthExtraMill, vxE, vyEl, vzE, dWidthExtraMill, dHeightExtraMill, 1.1 * dDepthExtraMill, 0, 0, 1);
				int bIsExtraMillApplied = bmCut.addMeToGenBeamsIntersect(arGBm);
			}
		}
	}
}
// Create the wire chase
double dLengthWireChase = dMaxHeight + dHeightFinishedFloor - dHeightSoleplate + U(40);
Point3d ptWireChase = _Pt0 + vyEl * dMaxHeight - vxE * nAlignment * 0.5 * dDiameter - vzE * dDepthWireChase;
if (bWireChaseIsAligned)
	ptWireChase = _Pt0 + vyEl * (dMaxHeight - 0.5 * dDiameter) - vzE * dDepthWireChase + vxE * nAlignment * 0.5 * dWidthWireChase;
// Change the insertion point and the length of the wire chase depending on the direction.
// Panel height
Point3d arPtPanel[] = el.plEnvelope().vertexPoints(true);
arPtPanel = Line(ptEl, vyEl).orderPoints(arPtPanel);
if (arPtPanel.length() == 0) {
	reportWarning(T("|Element| ") + el.number() + T(" |has an invalid panel outline!|"));
	return;
}
double dHPanel = vyEl.dotProduct(arPtPanel[arPtPanel.length() - 1] - arPtPanel[0]);
Point3d ptCenPanel = ptEl + vyEl * 0.5 * dHPanel;
// Wire chase direction: up and down.
if (nDirectionWireChase == 0){
	ptWireChase += vyEl * vyEl.dotProduct(ptCenPanel - ptWireChase);
	dLengthWireChase = dHPanel + U(40);
}
else if (nDirectionWireChase == 1 ) { // Wire chase up
	dLengthWireChase = dHPanel - (dMinHeight + dHeightFinishedFloor - dHeightSoleplate) + U(40);
	if (bWireChaseIsAligned)
		ptWireChase += vyEl * dDiameter;
	ptWireChase += vyEl * (dMinHeight - dMaxHeight);
}

// Adjust the position and length of the wire chase if it exceeds the maximum allowed height of the wire chase.
if (dMaxHeightWireChase > 0 && nDirectionWireChase > -1) {
	Point3d ptMaxHeightWireChase = ptWireChase + vyEl * 
					vyEl.dotProduct((ptEl + vyEl * (dHeightFinishedFloor - dHeightSoleplate + dMaxHeightWireChase)) - ptWireChase);
	ptMaxHeightWireChase.vis(1);
	if (nDirectionWireChase == 0) {
		if (vyEl.dotProduct((ptWireChase + vyEl * 0.5 * dHPanel) - ptMaxHeightWireChase) > 0) {
			ptWireChase += vyEl * vyEl.dotProduct((ptMaxHeightWireChase + ptEl)/2 - ptWireChase);
			dLengthWireChase = dHeightFinishedFloor - dHeightSoleplate + dMaxHeightWireChase;
		}
	}
	if (nDirectionWireChase == 1) {
		if (vyEl.dotProduct((ptWireChase + vyEl * 0.5 * dHPanel) - ptMaxHeightWireChase) > 0) {
			dLengthWireChase = vyEl.dotProduct(ptMaxHeightWireChase - ptWireChase);
		}
	}

}


if (dWidthWireChase * dLengthWireChase * dDepthWireChase > 0) {
	BeamCut bmCutWireChase(ptWireChase, vxE, vyEl, vzE, dWidthWireChase, dLengthWireChase, dDepthWireChase, -nAlignment, nDirectionWireChase, 1);
	int bIsWireChaseApplied = bmCutWireChase.addMeToGenBeamsIntersect(arGBm); 
}

Map arMapInstallation[0];
if (_Map.hasMap("Installations")) {
	Map mapInstallations = _Map.getMap("Installations");
	
	for (int i=0;i<mapInstallations.length();i++) {
		if (!mapInstallations.hasMap(i) && mapInstallations.keyAt(i) != "Installation")
			continue;
		
		arMapInstallation.append(mapInstallations.getMap(i));
	}
}

if (arMapInstallation.length() != _PtG.length() || _kExecuteKey == arSTrigger[0]) {
	// Open the tsl dialog to set the installation types. Send in the existing installation types.
	Map mapIO;
	mapIO.setInt("NrOfInstallationPoints", _PtG.length());
	mapIO.setMap("Installations", _Map.getMap("Installations"));
	int bOk = TslInst().callMapIO("HSB_P-AssignInstallationType", "ShowDialog", mapIO);
	
	if (bOk) {
		Map mapInstallations = mapIO.getMap("Installations");
		int n = mapInstallations.length();
		_Map.setMap("Installations", mapInstallations);
	}
}

// Set the readonly string
String arSInstallationId[_PtG.length()];
if (_Map.hasMap("Installations")) {
	Map mapInstallations = _Map.getMap("Installations");
	
	String sStringRepInstallationTypes;
	for (int i=0;i<mapInstallations.length();i++) {
		if (!mapInstallations.hasMap(i) && mapInstallations.keyAt(i) != "Installation")
			continue;
		arSInstallationId[i] = mapInstallations.getMap(i).getString("InstallationType").token(0,"/");
		sStringRepInstallationTypes += ((i + 1) + "-" + mapInstallations.getMap(i).getString("InstallationType") + ";");
	}
	sInstallationTypes.set(sStringRepInstallationTypes);
}


Display dpElevationNoPlot(1);
dpElevationNoPlot.elemZone(el, 0, 'T');
dpElevationNoPlot.dimStyle(sDimStyle);
dpElevationNoPlot.textHeight(dBoxIndexTextSizeElevation);
dpElevationNoPlot.addHideDirection(vyEl);
dpElevationNoPlot.addHideDirection(-vyEl);

Display dpElevation(1);
dpElevation.elemZone(el, 0, 'I');
dpElevation.dimStyle(sDimStyle);
dpElevation.textHeight(dTextSizeElevation);
dpElevation.addHideDirection(vyEl);
dpElevation.addHideDirection(-vyEl);

Display dpPlan(1);
dpPlan.elemZone(el, 0, 'I');
dpPlan.dimStyle(sDimStyle);
dpPlan.textHeight(dTextSizePlan);
dpPlan.addHideDirection(vxEl);
dpPlan.addHideDirection(-vxEl);
dpPlan.addHideDirection(vzEl);
dpPlan.addHideDirection(-vzEl);

String arSHeight[0];
String arSInstallationsAtThisHeight[0];
for (int i=0;i<_PtG.length();i++) {
	Point3d ptInstallation = _PtG[i];
	String sInstallationId = arSInstallationId[i];
	
	Vector3d vDiagonal = (vxE + vyEl);
	vDiagonal.normalize();
	dpElevationNoPlot.draw(i+1, ptInstallation - vDiagonal * 0.4 * dDiameter, vxE, vyEl, 0, 0, _kDevice);
	
	dpElevation.draw(sInstallationId, ptInstallation, vxE, vyEl, 0, 0, _kDevice);
	
	String sHeight = String().formatUnit(vyEl.dotProduct(ptInstallation - _Pt0), 2, 0);
	int nHeightIndex = arSHeight.find(sHeight);
	if (nHeightIndex == -1) {
		arSHeight.append(sHeight);
		arSInstallationsAtThisHeight.append(sInstallationId);
	}
	else{
		arSInstallationsAtThisHeight[nHeightIndex] += ("," + sInstallationId);
	}
}

for (int i=0; i<arSHeight.length(); i++) {
	String sHeight = arSHeight[i];
	String sInstallationsAtThisHeight = arSInstallationsAtThisHeight[i];
	
	//dpPlan.draw(sTag + " " + sHeight + ": " + sInstallationsAtThisHeight, _Pt0 + vxE * i * 1.2 * dTextSizePlan, vzE, vxE, 1, 0);
	dpPlan.draw(sTag + " H:" + sHeight, _Pt0 + vxE * i * 1.2 * dTextSizePlan, vzE, vxE, 1, 0);
}



#End
#BeginThumbnail










#End