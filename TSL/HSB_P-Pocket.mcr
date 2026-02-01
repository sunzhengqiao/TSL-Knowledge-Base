#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
23.03.2015  -  version 1.01




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
/// <summary>
/// This TSL creates a pocket in a panel.
/// </summary>

/// <insert>
/// Select a genbeam and a panel.
/// </insert>

/// <remark>
/// 
/// </remark>

/// <history>
/// AS - 1.00 - 25.02.2015	- Pilot version (FogBugzId 850).
/// AS - 1.01 - 23.03.2015	- Add thumb
/// </history>


// basics and props
double dEps = Unit(0.01,"mm");


// General properties
// The height of the finished floor.
PropDouble dGapSide(0, U(1), T("|Gap at the side|"));
dGapSide.setDescription(T("|Sets the gap which will be applied on each side.|"));
dGapSide.setCategory(T("|General settings|"));
PropDouble dGapBottom(1, U(1), T("|Gap at the bottom|"));
dGapBottom.setDescription(T("|Sets the gap which will be applied on bottom.|"));
dGapBottom.setCategory(T("|General settings|"));

// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_P-Pocket");
if (arSCatalogNames.find(_kExecuteKey) != -1) 
	setPropValuesFromCatalog(_kExecuteKey);

if (_bOnInsert) {
	if (insertCycleCount() > 1) {
		eraseInstance();
		return;
	}
	
	if (_kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1)
		showDialog();
	
	_GenBeam.append(getGenBeam(T("|Select the beam or panel to create a pocket for.|")));
	
	Element elSelected = getElement(T("|Select a wall|"));
	if (elSelected.bIsKindOf(ElementWall())) {
		_Element.append(elSelected);
	}
	else {
		reportWarning(T("|Invalid element selected.|") + T(" |A wall is required.|"));
		_Element.append(getElement(T("|Select a wall|")));
	}
	
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

Plane pnElZ(ptEl, vzEl);

_Pt0 = ptEl;

if (_GenBeam.length() > 0) {
	GenBeam gBm = _GenBeam[0];
	Vector3d vxGBm = gBm.vecX();
	Vector3d vyGBm = gBm.vecY();
	Vector3d vzGBm = gBm.vecZ();
	
	double dlGBm = gBm.solidLength();
	double dwGBm = gBm.solidWidth();
	double dhGBm = gBm.solidHeight();
	
	Vector3d vLine = vxGBm;
	if (abs(vzEl.dotProduct(vLine)) < dEps)
		vLine = gBm.vecD(vzEl);
	
	_Pt0 = Line(gBm.ptCen(), vLine).intersect(pnElZ,U(0));
	
	Point3d ptBmCut = _Pt0;
	Vector3d vxBmCut, vyBmCut, vzBmCut;
	double dlBmCut, dwBmCut, dhBmCut;
	
	vxBmCut = vLine;
	dlBmCut = U(500);
	
	if (vLine.dotProduct(vxGBm)) {
		vyBmCut = vyGBm;
		vzBmCut = vzGBm;
		
		dwBmCut = dwGBm;
		dhBmCut = dhGBm;
	}
	else if (vLine.dotProduct(vyGBm)) {
		vyBmCut = vzGBm;
		vzBmCut = vxGBm;
		
		dwBmCut = dhGBm;
		dhBmCut = dlGBm;
	}
	else {
		vyBmCut = vxGBm;
		vzBmCut = vyGBm;
		
		dwBmCut = dlGBm;
		dhBmCut = dwGBm;
	}
	
	ptBmCut -= vzBmCut * (0.5 * dhBmCut + dGapBottom);
	ptBmCut.vis(3);
	
	PLine plPocket(vzEl);
	Point3d ptA = ptBmCut + vyEl * 0.25 * dhBmCut;
	plPocket.addVertex(ptA + vxEl * .25 * dwBmCut + vyEl * .25 * dhBmCut);
	plPocket.addVertex(ptA + vxEl * .25 * dwBmCut);
	plPocket.addVertex(ptA - vxEl * .25 * dwBmCut);
	plPocket.addVertex(ptA - vxEl * .25 * dwBmCut + vyEl * .25 * dhBmCut);
	
	Display dpPocket(1);
	dpPocket.elemZone(el, 0, 'T');
	dpPocket.draw(plPocket);
	
	dhBmCut = U(1000);
	
	BeamCut bmCut(ptBmCut, vxBmCut, vyBmCut, vzBmCut, dlBmCut, dwBmCut + 2 * dGapSide, dhBmCut + dGapBottom, 0, 0, 1);
	int nBmCutApplied = bmCut.addMeToGenBeamsIntersect(el.genBeam());
}


#End
#BeginThumbnail
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
@`****`"I[/\`X_K?_KHO\Z@J>S_X_K?_`*Z+_.@#_]DH
`

#End