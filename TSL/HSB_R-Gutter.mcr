#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
11.12.2014  -  version 1.01
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
/// <summary Lang=en>
/// This tsl creates a gutter
/// </summary>

/// <insert>
/// Select a position and a direction
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.01" date="11.12.2014"></version>

/// <history>
/// AS - 1.00 - 03.12.2014 - 	Pilot version
/// AS - 1.01 - 11.12.2014 - 	Assign entities to specified group
/// </history>



double dEps = Unit(0.01,"mm"); // script uses mm

String arSCategory[] = {
	T("|Gutter|"),
	T("|Gutter laths|"),
	T("|Drain|")
};

Group allGroups[] = Group().allExistingGroups();
Group arGrpFloor[0];
String arSFloorGroupNames[0];
for (int i=0;i<allGroups.length();i++) {
	Group grp = allGroups[i];
	if (grp.namePart(1) != "" && grp.namePart(2) == "") {
		arGrpFloor.append(grp);
		arSFloorGroupNames.append(grp.name());
	}
}
PropString sAssignEntitiesTo(2, arSFloorGroupNames, T("|Assign gutter to group|"));
sAssignEntitiesTo.setDescription(T("|Sets the group to assign the entities to.|"));
sAssignEntitiesTo.setCategory(arSCategory[0]);

PropDouble dSlopePercentage(0, 1, T("|Slope| [%]"));
dSlopePercentage.setDescription(T("|Sets the slope| [%]."));
dSlopePercentage.setCategory(arSCategory[0]);

PropDouble dReferenceHeight(5, U(0), T("|Reference height|"));
dReferenceHeight.setCategory(arSCategory[0]);


PropDouble dStartHGutterLath(1, U(20), T("|Start height|"));
dStartHGutterLath.setCategory(arSCategory[1]);

PropDouble dWGutterLath(4, U(48), T("|Width|"));
dWGutterLath.setCategory(arSCategory[1]);

PropDouble dOffsetGutterLathsFromDrain(2, U(150), T("|Offset from drain|"));
dOffsetGutterLathsFromDrain.setCategory(arSCategory[1]);

PropDouble dMiniumLengthGutterLaths(3, U(150), T("|Minimum length|"));
dMiniumLengthGutterLaths.setCategory(arSCategory[1]);

PropDouble dOffsetSelectedGutterArea(6, U(5), T("|Offset from selected area|"));
dOffsetSelectedGutterArea.setDescription(T("|Sets the offset from the selected area.|"));
dOffsetSelectedGutterArea.setCategory(arSCategory[1]);

PropInt nColorGutterLaths(1, 5, T("|Color gutter laths|"));
nColorGutterLaths.setCategory(arSCategory[1]);

PropInt nColorDrain(0, 5, T("|Color drain|"));
nColorDrain.setCategory(arSCategory[2]);
PropDouble dDiameterDrain(7, U(80), T("|Diameter drain|"));
dDiameterDrain.setCategory(arSCategory[2]);
PropString sDescriptionDrain(0, "RWP", T("|Description|"));
sDescriptionDrain.setCategory(arSCategory[2]);
PropString sDimStyle(1, _DimStyles, T("|Dimension style|"));
sDimStyle.setCategory(arSCategory[2]);
PropDouble dTxtSize(8, -U(1), T("|Text size|"));
dTxtSize.setCategory(arSCategory[2]);


// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_R-Gutter");
if( _bOnDbCreated && arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

if (_bOnInsert) {
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	
	_Entity.append(getEntPLine(T("|Select the gutter|")));
	_Pt0 = getPoint(T("|Select the position of the drain.|"));
	
	return;
}

if (_Entity.length() == 0) {
	eraseInstance();
	return;
}


Group grpFloor = arGrpFloor[arSFloorGroupNames.find(sAssignEntitiesTo,0)];
grpFloor.addEntity(_ThisInst, true, 0, 'I');

EntPLine entPLine = (EntPLine)_Entity[0];
grpFloor.addEntity(entPLine, true, 0, 'I');

PLine plGutter;
if (!entPLine.bIsValid()) {
	if (!_Map.hasPLine("Gutter")) {
		eraseInstance();
		return;
	}
	plGutter = _Map.getPLine("Gutter");
}
else{
	plGutter = entPLine.getPLine();
	
	// Store the gutter outline. The tsl will still do its work when the original entity becomes invalid.
	_Map.setPLine("Gutter", plGutter, _kAbsolute);
	setDependencyOnEntity(entPLine);
}

// Project point and pline to same plane
Plane pnReference(_PtW + _ZW * dReferenceHeight, _ZW);
_Pt0 = pnReference.closestPointTo(_Pt0);
plGutter.projectPointsToPlane(pnReference, _ZW);
	

// Draw gutter outline
Display dpDrain(nColorDrain);
dpDrain.dimStyle(sDimStyle);
if (dTxtSize > 0)
	dpDrain.textHeight(dTxtSize);

PLine plDrain(_ZW);
plDrain.createCircle(_Pt0, _ZW, 0.5 * dDiameterDrain);

dpDrain.draw(plDrain);
dpDrain.draw(sDescriptionDrain, _Pt0 + (_XW + _YW) * 0.5 * dDiameterDrain, _XW, _YW, 1, 1);

// Determine vectors for gutter. The longest line segment will be the x direction.
Point3d arPtGutter[] = plGutter.vertexPoints(false);

Vector3d vxGutter = _XW;
for (int i=0;i<(arPtGutter.length() - 1);i++) {
	Point3d ptThis = arPtGutter[i];
	Point3d ptNext = arPtGutter[i+1];
	
	Vector3d vSegment(ptNext - ptThis);
	if (vSegment.length() < vxGutter.length())
		continue;
	
	Vector3d vNext(ptNext - _Pt0);
	Vector3d vThis(ptThis - _Pt0);
	if (vThis.length() > vNext.length())
		vSegment *= -1;
	
	vxGutter = vSegment;
}

vxGutter.normalize();
Vector3d vzGutter = _ZW;
Vector3d vyGutter = vzGutter.crossProduct(vxGutter);
CoordSys csGutter(_Pt0, vxGutter, vyGutter, vzGutter);

vxGutter.vis(_Pt0, 1);
vyGutter.vis(_Pt0, 3);
vzGutter.vis(_Pt0, 150);

_Map.setPoint3d("GutterDirection", vxGutter, _kAbsolute);

PlaneProfile ppGutter(csGutter);
ppGutter.joinRing(plGutter, _kAdd);
ppGutter.shrink(dOffsetSelectedGutterArea);

arPtGutter = ppGutter.getGripVertexPoints();

Point3d arPtGutterX[] = Line(_Pt0, vxGutter).orderPoints(arPtGutter);
Point3d arPtGutterY[] = Line(_Pt0, vyGutter).orderPoints(arPtGutter);

if (arPtGutterX.length() * arPtGutterY.length() <= 0) {
	reportError(T("|Extremes cannot be calculated for this gutter!|"));
	eraseInstance();
	return;
}

Point3d ptStart = arPtGutterX[0];
ptStart += vyGutter * vyGutter.dotProduct(arPtGutterY[0] - ptStart);
Point3d ptEnd = arPtGutterX[arPtGutterX.length() - 1];
ptEnd += vyGutter * vyGutter.dotProduct(arPtGutterY[arPtGutterY.length() - 1] - ptEnd);

ptStart.vis(1);
ptEnd.vis(1);

double dWGutter = vyGutter.dotProduct(ptEnd - ptStart);

Point3d arPtGutterLath[0];
Vector3d arVXGutterLath[0];
double arDLGutterLath[0];

Point3d arPtArrow[0];
Vector3d arVArrow[0];

// Create gutter laths towards start point.
if (vxGutter.dotProduct(_Pt0 - ptStart) > (dOffsetGutterLathsFromDrain + dMiniumLengthGutterLaths)) {
	Point3d ptGutterLath = _Pt0 - vxGutter * dOffsetGutterLathsFromDrain;
	double dLGuterLath = -vxGutter.dotProduct(ptStart - ptGutterLath);
	
	arPtGutterLath.append(ptGutterLath + vyGutter * (vyGutter.dotProduct(ptStart - _Pt0) + 0.5 * dWGutterLath));
	arVXGutterLath.append(-vxGutter);
	arDLGutterLath.append(dLGuterLath);
	
	arPtGutterLath.append(ptGutterLath + vyGutter * (vyGutter.dotProduct(ptEnd - _Pt0) - 0.5 * dWGutterLath));
	arVXGutterLath.append(-vxGutter);
	arDLGutterLath.append(dLGuterLath);
	
	arPtArrow.append(ptGutterLath - vxGutter * (dOffsetGutterLathsFromDrain + 0.5 * dLGuterLath));
	arVArrow.append(vxGutter);
}

// Create gutter laths towards end point.
if (vxGutter.dotProduct(ptEnd - _Pt0) > (dOffsetGutterLathsFromDrain + dMiniumLengthGutterLaths)) {
	Point3d ptGutterLath = _Pt0 + vxGutter * dOffsetGutterLathsFromDrain;
	double dLGuterLath = vxGutter.dotProduct(ptEnd - ptGutterLath);
	
	arPtGutterLath.append(ptGutterLath + vyGutter * (vyGutter.dotProduct(ptStart - _Pt0) + 0.5 * dWGutterLath));
	arVXGutterLath.append(vxGutter);
	arDLGutterLath.append(dLGuterLath);
	
	arPtGutterLath.append(ptGutterLath + vyGutter * (vyGutter.dotProduct(ptEnd - _Pt0) - 0.5 * dWGutterLath));
	arVXGutterLath.append(vxGutter);
	arDLGutterLath.append(dLGuterLath);
	
	arPtArrow.append(ptGutterLath + vxGutter * (dOffsetGutterLathsFromDrain + 0.5 * dLGuterLath));
	arVArrow.append(-vxGutter);
}

for (int i=0;i<_Map.length();i++ ){
	if (_Map.hasEntity(i) && _Map.keyAt(i) == "GutterLath") {
		Entity ent = _Map.getEntity(i);
		ent.dbErase();
		_Map.removeAt(i, true);
		i--;
	}
}

double dSlope = dSlopePercentage/100;
double dAngle = atan(dSlopePercentage, 100.0);

double dMaxHeight = U(0);

for (int i=0;i<arPtGutterLath.length();i++) {
	Point3d ptGutterLath = arPtGutterLath[i];
	Vector3d vxGutterLath = arVXGutterLath[i];
	Vector3d vzGutterLath = vzGutter;
	Vector3d vyGutterLath = vzGutterLath.crossProduct(vxGutterLath);
	
	double dLGutterLath = arDLGutterLath[i];
	double dHGutterLath = dStartHGutterLath + dLGutterLath * dSlope;
	
	if (dHGutterLath > dMaxHeight);
		dMaxHeight = dHGutterLath;
	
	Beam bmGutterLath;
	bmGutterLath.dbCreate(ptGutterLath, vxGutterLath, vyGutterLath, vzGutterLath, dLGutterLath, dWGutterLath, dHGutterLath, 1, 0, 1);
	grpFloor.addEntity(bmGutterLath, true, 0, 'Z');
	_Map.appendEntity("GutterLath", bmGutterLath);
	bmGutterLath.setColor(nColorGutterLaths);
	
	Vector3d vCut = vzGutterLath.rotateBy(-dAngle, vyGutterLath);
	vCut.vis(ptGutterLath, 5);
	Cut cut(ptGutterLath + vzGutterLath * dStartHGutterLath, vCut);
	bmGutterLath.addTool(cut);
}

_Map.setPoint3d("GutterHeight", _Pt0 + vzGutter * dMaxHeight, _kAbsolute);

double dLArrow = U(200);
for (int i=0;i<arPtArrow.length();i++) {
	Point3d ptArrow = arPtArrow[i];
	Vector3d vArrow = arVArrow[i];
	
	PLine plArrow(vzGutter);
	plArrow.addVertex(ptArrow + vArrow * 0.25 * dLArrow);
	plArrow.addVertex(ptArrow + vyGutter * 0.25 * dLArrow);
	plArrow.addVertex(ptArrow + vyGutter * 0.05 * dLArrow);
	plArrow.addVertex(ptArrow - vArrow * 0.75 * dLArrow + vyGutter * 0.05 * dLArrow);
	plArrow.addVertex(ptArrow - vArrow * 0.75 * dLArrow - vyGutter * 0.05 * dLArrow);
	plArrow.addVertex(ptArrow - vyGutter * 0.05 * dLArrow);
	plArrow.addVertex(ptArrow - vyGutter * 0.25 * dLArrow);
	plArrow.close();
	
	PlaneProfile ppArrow(csGutter);
	ppArrow.joinRing(plArrow, _kAdd);
	
	dpDrain.draw(ppArrow, _kDrawFilled);
}

#End
#BeginThumbnail

#End