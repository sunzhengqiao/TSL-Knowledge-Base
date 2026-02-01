#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
16.06.2014  -  version 1.00

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
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
/// </history>


// basics and props
double dEps = Unit(0.01,"mm");


// General properties
PropString sSeparator01(0, "", T("|General settings|"));
sSeparator01.setReadOnly(true);
// The height of the finished floor.
PropDouble dHeightFinishedFloor(0, U(190), "     "+T("|Height finished floor|"));
dHeightFinishedFloor.setDescription(T("|Sets the height of the finished floor.|") + T(" |The height for the installation is measured from the finished floor.|"));
// The height of the soleplate.
PropDouble dHeightSoleplate(1, U(38), "     "+T("|Height soleplate|"));
dHeightSoleplate.setDescription(T("|Sets the height of the soleplate.|") + T(" |The height of the soleplate.|"));


// Installation properties
PropString sSeparator02(1, "", T("|Installation|"));
sSeparator02.setReadOnly(true);
// The quantity.
int arNQuantity[] = {1,2,3,4};
PropInt nQuantity(0, arNQuantity, "     "+T("|Quantity|"), 1);
nQuantity.setDescription(T("|Sets the amount of boxes.|"));
// The height from finished floor.
PropString sHeight(6, "1100", "     "+T("|Height from finished floor|"));
sHeight.setDescription(T("|Sets the height.|") + T(" |The height is measured from the finished floor.|"));
// The diameter of the installation.
PropDouble dDiameter(3, U(69), "     "+T("|Diameter|"));
dDiameter.setDescription(T("|Sets the diameter.|"));
// The depth of the installation.
PropDouble dDepth(4, U(50),"     "+T("|Depth|"));	
dDepth.setDescription(T("|Sets the depth.|"));
// The distance between two installation points.
PropDouble dBetweenInstallations(5,U(71), "     "+T("|Offset between installations|"));		
dBetweenInstallations.setDescription(T("|Sets the offset between the installations.|"));
// The type of installations
PropString sInstallationTypes(7, "", "     "+T("|Installation types|"));
sInstallationTypes.setDescription(T("|The installation types can be set through a custom action.|")+TN("|This action is available in the right mouse click menu.|"));
sInstallationTypes.setReadOnly(true);


// Properties for extra mill
PropString sSeparator03(2, "", T("|Extra mill|"));
sSeparator03.setReadOnly(true);
// The width.
PropDouble dWidthExtraMill(7, U(40), "     "+T("|Width extra mill|"));
dWidthExtraMill.setDescription(T("|Sets the width.|"));
// The height.
PropDouble dHeightExtraMill(8, U(40), "     "+T("|Height extra mill|"));
dHeightExtraMill.setDescription(T("|Sets the height.|"));
// The depth.
PropDouble dDepthExtraMill(6, U(50), "     "+T("|Depth extra mill|"));
dDepthExtraMill.setDescription(T("|Sets the depth.|"));


// Properties for wire chase
PropString sSeparator04(3, "", T("|Wire chase|"));
sSeparator04.setReadOnly(true);
// The side of the wire chase
String arSSide[] = {T("|Left|"), T("|Right|"), T("|Aligned|")};
int arNSide[] = {1, -1, 0};
PropString sSideWireChase(4, arSSide, "     "+T("|Side wire chase|"));
sSideWireChase.setDescription(T("|Sets the side of the wire chase.|") + T("|The side is taken while looking towards the installation.|"));
// The direction of the wire chase
String arSDirection[] = {T("|Up|"), T("|Down|"), T("|Up and down|")};
int arNDirection[] = {1, -1, 0};
PropString sDirectionWireChase(5, arSDirection, "     "+T("|Direction wire chase|"), 1);
sDirectionWireChase.setDescription(T("|Sets the direction of the wire chase.|"));
// The width.
PropDouble dWidthWireChase(10, U(30), "     "+T("|Width wire chase|"));
dWidthWireChase.setDescription(T("|Sets the width.|"));
// The depth.
PropDouble dDepthWireChase(9, U(30), "     "+T("|Depth wire chase|"));
dDepthWireChase.setDescription(T("|Sets the depth.|"));


String arSTrigger[] = {
	T("|Set installation types|")
};
for( int i=0;i<arSTrigger.length();i++ )
	addRecalcTrigger(_kContext, arSTrigger[i] );



// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_P-Electrical");
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


// Sort the installation heights from bottom to top.
for(int s1=1;s1<arDHeight.length();s1++){
	int s11 = s1;
	for(int s2=s1-1;s2>=0;s2--){
		if( arDHeight[s11] < arDHeight[s2] ){
			arDHeight.swap(s2, s11);
			s11=s2;
		}
	}
}


int bMinMaxHeightSet = false;
double dMinHeight, dMaxHeight;
for (int h=0;h<arDHeight.length();h++) {
	double dHeight = arDHeight[h];
	
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
	_PtG.append(_Pt0 + vyEl * dHeight);
	if (nQuantity > 1)
		_PtG.append(_PtG[_PtG.length() - 1] + vxE * nAlignment * dBetweenInstallations);
	
	
	// Apply the drills
	for (int i=0;i<_PtG.length();i++) {
		Point3d ptDrill = _PtG[i];
		Drill drill(ptDrill, -vzE, dDepth, 0.5 * dDiameter);
		int bIsDrillApplied = drill.addMeToGenBeamsIntersect(arGBm);
		
		Point3d ptBmCut = _PtG[i] - vxE * nAlignment * 0.5 * dDiameter - vzE * dDepthExtraMill;
		int bFirstDrillAtThisHeight = (i/2.0 - i/2) == 0.0;
		if (bFirstDrillAtThisHeight) {
			if (bWireChaseIsAligned) {
				ptBmCut = _PtG[i] - vyEl * 0.5 * dDiameter - vzE * dDepthExtraMill;
				if (nDirectionWireChase == 0) { // Wire chase goes up and down.
					BeamCut bmCut(ptBmCut, vxE, vyEl, vzE, dWidthExtraMill, dHeightExtraMill, 1.1 * dDepthExtraMill, 0, 0, 1);
					int bIsExtraMillApplied = bmCut.addMeToGenBeamsIntersect(arGBm);
					ptBmCut += vyEl * dDiameter;
				}
				else if (nDirectionWireChase == 1) { // Wire chase goes up.
					ptBmCut += vyEl * dDiameter;
				}
			}
			else {
				ptBmCut -= vxE * nAlignment * (dWidthWireChase - 0.5 * dWidthExtraMill);
			}
		}
		BeamCut bmCut(ptBmCut, vxE, vyEl, vzE, dWidthExtraMill, dHeightExtraMill, 1.1 * dDepthExtraMill, 0, 0, 1);
		int bIsExtraMillApplied = bmCut.addMeToGenBeamsIntersect(arGBm);
	}
}
// Create the wire chase
double dLengthWireChase = dMaxHeight + dHeightFinishedFloor + U(40);
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
	dLengthWireChase = dHPanel - (dMinHeight + dHeightFinishedFloor) + U(40);
	if (bWireChaseIsAligned)
		ptWireChase += vyEl * dDiameter;
	ptWireChase += vyEl * (dMinHeight - dMaxHeight);
}

BeamCut bmCutWireChase(ptWireChase, vxE, vyEl, vzE, dWidthWireChase, dLengthWireChase, dDepthWireChase, -nAlignment, nDirectionWireChase, 1);
int bIsWireChaseApplied = bmCutWireChase.addMeToGenBeamsIntersect(arGBm); 

double dTextHeightInstallationNumber = U(30);
Display dpElevationNoPlot(1);
dpElevationNoPlot.elemZone(el, 0, 'T');
dpElevationNoPlot.textHeight(dTextHeightInstallationNumber);
for (int i=0;i<_PtG.length();i++) {
	Point3d ptInstallation = _PtG[i];
	dpElevationNoPlot.draw(i+1, ptInstallation, vxE, vyEl, 0, 0);
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
	
	
	Map mapInstallations;
	for (int i=0;i<arMapInstallation.length();i++)
		mapInstallations.appendMap("Installation", arMapInstallation[i]);
	_Map.setMap("Installations", mapInstallations);
}
#End
#BeginThumbnail

#End