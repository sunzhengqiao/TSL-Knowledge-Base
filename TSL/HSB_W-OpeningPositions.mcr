#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
10.03.2016  -  version 1.00
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
/// <summary Lang=en>
/// Dimensions the window positions
/// </summary>

/// <insert>
/// Select an element and 2 positions
/// </insert>

/// <remark Lang=en>
/// .
/// </remark>

/// <version  value="1.00" date="10.03.2016"></version>

/// <history>
/// AS	- 1.00 - 10.03.2016 	- Pilot version
/// </history>

PropInt precision(0, 0, T("|Precision|"));

if (_bOnInsert) {
	_Element.append(getElement(T("|Select an element|")));
	return;
}

Element el = _Element[0];
assignToElementGroup(el, true, 0, 'T');
setDependencyOnEntity(el);

TslInst attachedTsls[] = el.tslInst();
for (int t=0;t<attachedTsls.length();t++) {
	TslInst tsl = attachedTsls[t];
	if (tsl.scriptName() == scriptName() && tsl.handle() != _ThisInst.handle())
		tsl.dbErase();
}

Display dp(-1);
dp.textHeight(U(100));

Vector3d elX = el.vecX();
Vector3d elY = el.vecY();
Vector3d elZ = el.vecZ();

Line lnX(el.ptOrg(), elX);
Line lnZ(el.ptOrg(), -elZ);

PLine elementOutline = el.plOutlineWall();
Point3d elementVertices[] = elementOutline.vertexPoints(true);
Point3d elementVerticesX[] = lnX.orderPoints(elementVertices);
Point3d elementVerticesZ[] = lnZ.orderPoints(elementVertices);

Point3d ptTR = elementVerticesX[elementVerticesX.length() - 1];
ptTR -= elZ * elZ.dotProduct(elementVerticesZ[elementVerticesZ.length() - 1] - ptTR);
Point3d ptBL = elementVerticesX[0];
ptBL += elZ * elZ.dotProduct(elementVerticesZ[0] - ptBL);

PlaneProfile elementPlanProfile(CoordSys(el.ptOrg(), elX, -elZ, elY));
elementPlanProfile.joinRing(elementOutline, _kAdd);

Opening openings[] = el.opening();
for (int o=0;o<openings.length();o++) {
	Opening op = openings[o];
	
	if (_Entity.find(op) == -1)
		_Entity.append(op);
	setDependencyOnEntity(op);
	
	PLine openingPlanOutline(elY);
	Point3d openingCenter = Body(op.plShape(), elZ).ptCen();
	openingCenter += elZ * elZ.dotProduct(ptBL - openingCenter);
	
	Point3d opBL = openingCenter - elX * 0.5 * op.width();
	Point3d opTR = opBL + elX * op.width();
	opTR += elZ * elZ.dotProduct(ptTR - opTR);
	
	openingPlanOutline.createRectangle(LineSeg(opBL, opTR), elX, -elZ);
	
	elementPlanProfile.joinRing(openingPlanOutline, _kSubtract);
}

PLine elementRings[] = elementPlanProfile.allRings();
int elementRingsAreOpening[] = elementPlanProfile.ringIsOpening();


for (int r=0;r<elementRings.length();r++) {
	if (elementRingsAreOpening[r])
		continue;
	
	PLine elementRing = elementRings[r];
	
	Point3d ringVertices[] = elementRing.vertexPoints(true);
	Point3d ringVerticesX[] = lnX.orderPoints(ringVertices);
	Point3d ringVerticesZ[] = lnZ.orderPoints(ringVertices);
	
	Point3d ptTR = ringVerticesX[ringVerticesX.length() - 1];
	ptTR += elZ * elZ.dotProduct(ringVerticesZ[ringVerticesZ.length() - 1] - ptTR);
	Point3d ptBL = ringVerticesX[0];
	ptBL += elZ * elZ.dotProduct(ringVerticesZ[0] - ptBL);

	double ringLength = elX.dotProduct(ptTR - ptBL);
	
	dp.draw(String().formatUnit(ringLength, 2, precision), (ptBL + ptTR)/2, elX, -elZ, 0, 0);
}
#End
#BeginThumbnail

#End