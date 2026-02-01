#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
31.03.2017  -  version 1.02

This tsl creates a frame for a bathroom floor in a floor element.
Recalculate bathroom floor is available as custom action in the context menu.

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl creates a frame for a bathroom floor in a floor element.
/// Recalculate bathroom floor is available as custom action in the context menu.
/// </summary>

/// <insert>
/// Select a floor element and a polyline that describes the area of the batchroom floor.
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.02" date="31.03.2017"></version>

/// <history>
/// AS - 1.00 - 24.09.2015 -	First revision
/// AS - 1.01 - 11.10.2015 -	Add recalc trigger.
/// AS - 1.02 - 31.03.2017 -	Correct _Map cleanup
/// </history>


String arSCategory[] = {
	T("|Bathroom floor|"),
	T("|Frame|")
};

PropDouble dFloorDepth(0, U(48), T("|Floor depth|"));
dFloorDepth.setCategory(arSCategory[0]);
PropDouble dtSheetBathRoomFloor(4, U(12), T("|Thickness sheet bath room floor|"));
dtSheetBathRoomFloor.setCategory(arSCategory[0]);
PropInt nColorBathRoom(1, 90, T("|Color bathroom|"));
nColorBathRoom.setCategory(arSCategory[0]);
PropString sDescriptionBathRoom(0, "Bath room", T("|Description|"));
sDescriptionBathRoom.setCategory(arSCategory[0]);
PropString sDimStyle(1, _DimStyles, T("|Dimension style|"));
sDimStyle.setCategory(arSCategory[0]);


PropDouble dwTrimmer(1, U(48), T("|Width trimmer|"));
dwTrimmer.setCategory(arSCategory[1]);
PropDouble dwSideTrimmer(2, U(23), T("|Width side trimmer|"));
dwSideTrimmer.setCategory(arSCategory[1]);
PropDouble dhSideTrimmer(3, U(48), T("|Height side trimmer|"));
dhSideTrimmer.setCategory(arSCategory[1]);
PropInt nColorFrame(0, 40, T("|Color frame|"));
nColorFrame.setCategory(arSCategory[1]);
PropDouble dSpacingJoist(5, U(300), T("|Spacing floor joists|"));
dSpacingJoist.setCategory(arSCategory[1]);
PropInt nColorJoist(2, 30, T("|Color joist|"));
nColorJoist.setCategory(arSCategory[1]);

String recalcTriggers[] = {
	T("|Recalculate bathroom floor|")
};
for( int i=0;i<recalcTriggers.length();i++ )
	addRecalcTrigger(_kContext, recalcTriggers[i] );


if (_bOnInsert) {
	if (insertCycleCount() > 1) {
		eraseInstance();
		return;
	}
	
	showDialog();
	
	_Element.append(getElement(T("|Select floor element|")));
	_Entity.append(getEntPLine(T("|Select the poly line that describes the floor area.|")));
	
	_Map.setInt("OnInsert", true);
	
	return;
}

if (_Element.length() == 0) {
	reportWarning(T("|No element selected.|"));
	eraseInstance();
	return;
}

if (_Entity.length() < 2) {
	reportWarning(T("|No opening poly line selected.|"));
	eraseInstance();
	return;
}

Element el = _Element[0];

CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

vxEl.vis(ptEl, 1);
vyEl.vis(ptEl, 3);
vzEl.vis(ptEl, 150);

Plane pnElZ(ptEl, vzEl);
Line lnElX(ptEl, vxEl);
Line lnElY(ptEl, vyEl);

Plane pnBathroomFloor(ptEl - vzEl * dFloorDepth, vzEl);

_Pt0 = ptEl;

EntPLine entPlOpening;
for (int i=0;i<_Entity.length();i++) {
	EntPLine entPl = (EntPLine)_Entity[i];
	if (!entPl.bIsValid())
		continue;
	
	entPlOpening = entPl;
	break;
}

if (!entPlOpening.bIsValid()) {
	reportWarning(T("|Invalid opening poly line selected.|"));
	eraseInstance();
	return;
}

setDependencyOnEntity(entPlOpening);

PLine plOpening = entPlOpening.getPLine();
plOpening.projectPointsToPlane(pnBathroomFloor, vzEl);
plOpening.vis(3);

Point3d arPtOpening[] = plOpening.vertexPoints(true);
Point3d arPtOpeningX[] = lnElX.orderPoints(arPtOpening);
Point3d arPtOpeningY[] = lnElY.orderPoints(arPtOpening);

if (arPtOpeningX.length() * arPtOpeningY.length() == 0) {
	reportWarning(T("|Opening extremes can not be calculated.|"));
	eraseInstance();
	return;
}

Point3d ptOpBL = arPtOpeningX[0];
ptOpBL += vyEl * vyEl.dotProduct(arPtOpeningY[0] - ptOpBL);
ptOpBL.vis(1);
Point3d ptOpTR = arPtOpeningX[arPtOpeningX.length()  - 1];
ptOpTR += vyEl * vyEl.dotProduct(arPtOpeningY[arPtOpeningY.length() - 1] - ptOpTR);
ptOpTR.vis(5);
Point3d ptOpMid = (ptOpBL + ptOpTR)/2;
double dwOp = vxEl.dotProduct(ptOpTR - ptOpBL);
double dhOp = vyEl.dotProduct(ptOpTR - ptOpBL);
Point3d ptOpL = ptOpMid - vxEl * 0.5 * dwOp;
Point3d ptOpR = ptOpMid + vxEl * 0.5 * dwOp;
Point3d ptOpB = ptOpMid - vyEl * 0.5 * dhOp;
Point3d ptOpT = ptOpMid + vyEl * 0.5 * dhOp;

Point3d ptOpBR = ptOpB + vxEl * vxEl.dotProduct(ptOpR - ptOpB);
Point3d ptOpTL = ptOpT + vxEl * vxEl.dotProduct(ptOpL - ptOpT);

int recalculateBathroomFloor = false;
if (_bOnElementConstructed)
	recalculateBathroomFloor = true;

if (_kExecuteKey == recalcTriggers[0])
	recalculateBathroomFloor = true;

if (_Map.hasInt("OnInsert")) {
	int onInsert = _Map.getInt("OnInsert");
	if (onInsert)
		recalculateBathroomFloor = true;
	_Map.removeAt("OnInsert", true);
}

if (recalculateBathroomFloor) {
	// Create the frame
	Point3d arPtFrame[] = {
		ptOpT,
		ptOpB,
		ptOpL,
		ptOpR
	};
	Point3d arVxFrame[] = {
		vxEl,
		vxEl,
		vyEl,
		vyEl
	};
	Point3d arVyFrame[] = {
		vyEl,
		vyEl,
		-vxEl,
		-vxEl
	};
	Point3d arVzFrame[] = {
		vzEl,
		vzEl,
		vzEl,
		vzEl
	};
	double arDlFrame[] = {
		dwOp,
		dwOp,
		dhOp + 2 * dwTrimmer,
		dhOp + 2 * dwTrimmer
	};
	double arDwFrame[] = {
		dwTrimmer,
		dwTrimmer,
		dwSideTrimmer,
		dwSideTrimmer
	};
	double arDhFrame[] = {
		dFloorDepth,
		dFloorDepth,
		dhSideTrimmer,
		dhSideTrimmer
	};
	double arDxFlag[] = {
		0,
		0,
		0,
		0
	};
	double arDyFlag[] = {
		1,
		-1,
		-1,
		1	
	};
	double arDzFlag[] = {
		1,
		1,
		-1,
		-1
	};
	
	for (int i=0;i<_Map.length();i++) {
		if (_Map.keyAt(i) != "Frame" && _Map.keyAt(i) != "Sheet" && _Map.keyAt(i) != "Joist")
			continue;
		if (!_Map.hasEntity(i))
			continue;
		
		Entity ent = _Map.getEntity(i);
		ent.dbErase();
		
		_Map.removeAt(i, true);
		i--;
	}
	
	Body bdFrame(ptOpMid, vxEl, vyEl, vzEl, 1.05 * dwOp, 0.95 * dhOp, dFloorDepth, 0, 0, 1);
	Beam arBm[] = el.beam();
	Beam arBmNoJoist[0];
	for (int i=0;i<arBm.length();i++) {
		Beam bm = arBm[i];
		Body bdBm = bm.envelopeBody();
		
		if (bdBm.hasIntersection(bdFrame))
			bm.dbErase();
		else
			arBmNoJoist.append(bm);
	}
	
	for (int i=0;i<arPtFrame.length();i++) {
		Point3d ptFrame = arPtFrame[i];
		Vector3d vxFrame = arVxFrame[i];
		Vector3d vyFrame = arVyFrame[i];
		Vector3d vzFrame = arVzFrame[i];
		double dlFrame = arDlFrame[i];
		double dwFrame = arDwFrame[i];
		double dhFrame = arDhFrame[i];
		double dxFlag = arDxFlag[i];
		double dyFlag = arDyFlag[i];
		double dzFlag = arDzFlag[i];
	
		Beam bmFrame;
		bmFrame.dbCreate(ptFrame, vxFrame, vyFrame, vzFrame, dlFrame, dwFrame, dhFrame, dxFlag, dyFlag, dzFlag);
		bmFrame.setColor(nColorFrame);
		bmFrame.assignToElementGroup(el, true, 0, 'Z');
		_Map.appendEntity("Frame", bmFrame);
	}
	
	// Rereate joists
	double dwJoist = el.dBeamHeight();
	double dhJoist = el.dBeamWidth();
	Point3d ptStartDistribution = ptOpL - vxEl * 0.5 * dwJoist + vzEl * (vzEl.dotProduct(ptEl - ptOpL) - 0.5 * dhJoist);
	Point3d ptEndDistribution = ptStartDistribution + vxEl * (dwOp + dwJoist);
	Beam arBmJoist[0];
	int nNrOfJoistsCreated = 0;
	Point3d ptJoist  = ptStartDistribution;
	while (vxEl.dotProduct(ptEndDistribution - ptJoist) > 0.5 * dwJoist) {
		Beam bmJoist;
		bmJoist.dbCreate(ptJoist, vyEl, -vxEl, vzEl, U(100), dwJoist, dhJoist, 0, 0, 0);
		bmJoist.setColor(nColorJoist);
		bmJoist.assignToElementGroup(el, true, 0, 'Z');	
		arBmJoist.append(bmJoist);
		_Map.appendEntity("Joist", bmJoist);
		
		nNrOfJoistsCreated++;
		if (nNrOfJoistsCreated > 25)
			break;
		
		ptJoist += vxEl * dSpacingJoist;
	}
	
	Beam bmJoist;
	bmJoist.dbCreate(ptEndDistribution, vyEl, -vxEl, vzEl, U(100), dwJoist, dhJoist, 0, 0, 0);
	bmJoist.setColor(nColorJoist);
	bmJoist.assignToElementGroup(el, true, 0, 'Z');
	arBmJoist.append(bmJoist);
	_Map.appendEntity("Joist", bmJoist);
	
	for (int i=0;i<arBmJoist.length();i++) {
		Beam bm  =arBmJoist[i];
		
		Beam arBmLeft[] = Beam().filterBeamsHalfLineIntersectSort(arBmNoJoist, bm.ptCen(), vyEl);
		Beam arBmRight[] = Beam().filterBeamsHalfLineIntersectSort(arBmNoJoist, bm.ptCen(), -vyEl);
		
		if (arBmLeft.length() > 0)
			bm.stretchStaticTo(arBmLeft[0], _kStretchOnToolChange);
		if (arBmRight.length() > 0)
			bm.stretchStaticTo(arBmRight[0], _kStretchOnToolChange);
	}
	
	BeamCut bmCutFrame(ptOpMid, vxEl, vyEl, vzEl, dwOp, dhOp + 2 * dwTrimmer, 2 * dFloorDepth, 0, 0, 1);
	for (int j=0;j<arBmJoist.length();j++) {
		Beam joist = arBmJoist[j];
		if (bmCutFrame.cuttingBody().hasIntersection(joist.envelopeBody()))
			joist.addToolStatic(bmCutFrame);
	}
	
	Sheet arShZn1[] = el.sheet(1);
	BeamCut bmCutSheet(ptOpMid, vxEl, vyEl, vzEl, dwOp, dhOp, 2 * dFloorDepth, 0, 0, 1);
	for (int s=0;s<arShZn1.length();s++) {
		Sheet shZn1 = arShZn1[s];
		if (bmCutSheet.cuttingBody().hasIntersection(shZn1.envelopeBody()))
			shZn1.addToolStatic(bmCutSheet);
	}
	//int nShsAffected = bmCutSheet.addMeToGenBeamsIntersect(arShZn1);
	
	Sheet shBathRoom;
	shBathRoom.dbCreate(ptOpMid, vxEl, vyEl, vzEl, dwOp, dhOp, dtSheetBathRoomFloor, 0, 0, 1);
	shBathRoom.setColor(nColorBathRoom);
	shBathRoom.assignToElementGroup(el, true, 1, 'Z');
	_Map.appendEntity("Sheet", shBathRoom);
}

Display dpBathRoom(nColorBathRoom);
dpBathRoom.dimStyle(sDimStyle);
dpBathRoom.draw(PLine(ptOpBL, ptOpTR));
dpBathRoom.draw(PLine(ptOpBR, ptOpTL));
dpBathRoom.draw(sDescriptionBathRoom, ptOpMid, vxEl, vyEl, 0, 0);

#End
#BeginThumbnail
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
3F4^%0T\:DD`L!P<'\Z:W$]C_V95R
`

#End