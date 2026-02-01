#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
11.12.2014  -  version 1.02
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
/// This tsl creates sloped battens on a flat roof
/// </summary>

/// <insert>
/// Select a position and a direction
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.02" date="11.12.2014"></version>

/// <history>
/// AS - 1.00 - 03.12.2014 - 	Pilot version
/// AS - 1.01 - 04.12.2014 - 	Add sheeting layers
/// AS - 1.02 - 11.12.2014 - 	Assign entities to specified group
/// </history>



double dEps = Unit(0.01,"mm"); // script uses mm

String arSCategory[] = {
	T("|Gutter|"),
	T("|Sloped battens|"),
	T("|Zones|")
};

PropDouble dSlopePercentage(0, 1, T("|Slope| [%]"));
dSlopePercentage.setDescription(T("|Sets the slope| [%]."));
dSlopePercentage.setCategory(arSCategory[0]);

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
PropString sAssignEntitiesTo(3, arSFloorGroupNames, T("|Assign battens to group|"));
sAssignEntitiesTo.setDescription(T("|Sets the group to assign the entities to.|"));
sAssignEntitiesTo.setCategory(arSCategory[1]);

PropDouble dWSlopedBattens(1, U(50), T("|Width sloped battens|"));
dWSlopedBattens.setDescription(T("|Sets the width of the battens.|"));
dWSlopedBattens.setCategory(arSCategory[1]);

PropDouble dSpacingSlopedBattens(2, U(600), T("|Spacing sloped battens|"));
dSpacingSlopedBattens.setDescription(T("|Sets the spacing of the battens.|"));
dSpacingSlopedBattens.setCategory(arSCategory[1]);

PropDouble dOffsetSelectedArea(3, U(5), T("|Offset from selected area|"));
dOffsetSelectedArea.setDescription(T("|Sets the offset from the selected area.|"));
dOffsetSelectedArea.setCategory(arSCategory[1]);

PropInt nColorBattens(0, 5, T("|Color battens|"));
nColorBattens.setCategory(arSCategory[1]);
PropString sDimStyle(2, _DimStyles, T("|Dimension style|"));
sDimStyle.setCategory(arSCategory[1]);
PropDouble dTxtSize(8, -U(1), T("|Text size|"));
dTxtSize.setCategory(arSCategory[1]);

PropDouble dTLayer1(9, U(0), T("|Thickness first sheeting layer|"));
dTLayer1.setCategory(arSCategory[2]);
PropInt nColorLayer1(1, 2, T("|Color first sheeting layer|"));
nColorLayer1.setCategory(arSCategory[2]);
PropString sMaterialLayer1(0, "OSB", T("|Material first sheeting layer|"));
sMaterialLayer1.setCategory(arSCategory[2]);

PropDouble dTLayer2(10, U(0), T("|Thickness second sheeting layer|"));
dTLayer2.setCategory(arSCategory[2]);
PropInt nColorLayer2(2, 35, T("|Color second sheeting layer|"));
nColorLayer2.setCategory(arSCategory[2]);
PropString sMaterialLayer2(1, "Insulation", T("|Material second sheeting layer|"));
sMaterialLayer2.setCategory(arSCategory[2]);

// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_R-SlopedBattens");
if( _bOnDbCreated && arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

if (_bOnInsert) {
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	
	_Entity.append(getTslInst(T("|Select the gutter|")));
	_Entity.append(getEntPLine(T("|Select the distribution area|")));
	
	return;
}

if (_Entity.length() == 0) {
	eraseInstance();
	return;
}

TslInst tslGutter = (TslInst)_Entity[0];
if (!tslGutter.bIsValid()) {
	reportError(T("|Invalid gutter!|"));
	eraseInstance();
	return;
}
setDependencyOnEntity(tslGutter);


Group grpFloor = arGrpFloor[arSFloorGroupNames.find(sAssignEntitiesTo,0)];
grpFloor.addEntity(_ThisInst, true, 0, 'I');

EntPLine entPLine = (EntPLine)_Entity[1];
grpFloor.addEntity(entPLine, true, 0, 'I');

PLine plDistributionArea;
if (!entPLine.bIsValid()) {
	if (!_Map.hasPLine("DistributionArea")) {
		eraseInstance();
		return;
	}
	plDistributionArea = _Map.getPLine("DistributionArea");
}
else{
	plDistributionArea = entPLine.getPLine();
	
	// Store the gutter outline. The tsl will still do its work when the original entity becomes invalid.
	_Map.setPLine("DistributionArea", plDistributionArea, _kAbsolute);
	setDependencyOnEntity(entPLine);
}

Display dpSlopedBattens(nColorBattens);
dpSlopedBattens.dimStyle(sDimStyle);
if (dTxtSize > 0)
	dpSlopedBattens.textHeight(dTxtSize);


_Pt0 = tslGutter.ptOrg();
Map mapGutterData = tslGutter.map();

Vector3d vxGutter = mapGutterData.getPoint3d("GutterDirection");
vxGutter.vis(_Pt0,1);
double dStartHBattens = _ZW.dotProduct(mapGutterData.getPoint3d("GutterHeight") - _Pt0);

Vector3d vzDistribution = _ZW;
Vector3d vyDistribution = vxGutter;
Vector3d vxDistribution = vyDistribution.crossProduct(vzDistribution);

CoordSys csDistribution(_Pt0, vxDistribution, vyDistribution, vzDistribution);

PlaneProfile ppDistributionArea(csDistribution);
ppDistributionArea.joinRing(plDistributionArea, _kAdd);
ppDistributionArea.shrink(dOffsetSelectedArea);

Point3d ptStartDistribution = ppDistributionArea.closestPointTo(_Pt0);
if (vxDistribution.dotProduct(ptStartDistribution - _Pt0) < 0) {
	vyDistribution = -vxGutter;
	vxDistribution = vyDistribution.crossProduct(vzDistribution);
	
	csDistribution = CoordSys(_Pt0, vxDistribution, vyDistribution, vzDistribution);
	
	ppDistributionArea = PlaneProfile(csDistribution);
	ppDistributionArea.joinRing(plDistributionArea, _kAdd);
	
	ptStartDistribution = ppDistributionArea.closestPointTo(_Pt0);
}
csDistribution.vis();

LineSeg lnSegDistributionArea = ppDistributionArea.extentInDir(vxDistribution);
lnSegDistributionArea.vis();
Point3d ptStartDistributionArea = lnSegDistributionArea.ptStart();
ptStartDistributionArea.vis(3);
Point3d ptEndDistributionArea = lnSegDistributionArea.ptEnd();
ptEndDistributionArea.vis(3);

ptStartDistribution += vyDistribution * vyDistribution.dotProduct(ptStartDistributionArea - ptStartDistribution);
ptStartDistribution.vis(1);

double dLSlopedBattens = vyDistribution.dotProduct(ptEndDistributionArea - ptStartDistributionArea);

double dSlope = dSlopePercentage/100;
double dAngle = atan(dSlopePercentage, 100.0);

for (int i=0;i<_Map.length();i++ ){
	if (_Map.hasEntity(i) && _Map.keyAt(i) == "SlopedBatten") {
		Entity ent = _Map.getEntity(i);
		ent.dbErase();
		_Map.removeAt(i, true);
		i--;
	}
	
	if (_Map.hasEntity(i) && _Map.keyAt(i) == "Sheet") {
		Entity ent = _Map.getEntity(i);
		ent.dbErase();
		_Map.removeAt(i, true);
		i--;
	}

}

Point3d ptDistribution = ptStartDistribution;
int nNrOfLoops = 0;
while (vxDistribution.dotProduct(ptEndDistributionArea - ptDistribution) > 0) {
	nNrOfLoops++;
	if (nNrOfLoops > 1000)
		break;
	
	PLine plBatten(vzDistribution);
	plBatten.createRectangle(LineSeg(ptDistribution, ptDistribution + vxDistribution * dWSlopedBattens + vyDistribution * dLSlopedBattens), vyDistribution, -vxDistribution);
	
	PlaneProfile ppBatten(csDistribution);
	ppBatten.joinRing(plBatten, _kAdd);
	ppBatten.intersectWith(ppDistributionArea);
	ppBatten.vis(nNrOfLoops);
	
	double dHBatten = dStartHBattens + vxDistribution.dotProduct(ptDistribution - ptStartDistribution) * dSlope;
	
	PLine arPlBatten[] = ppBatten.allRings();
	int arBRingIsOpening[] = ppBatten.ringIsOpening();
	
	for (int j=0;j<arPlBatten.length();j++) {
		if (arBRingIsOpening[j])
			continue;
		
		PLine plBatten = arPlBatten[j];
		Beam bm;
		bm.dbCreate(Body(plBatten, vzDistribution * dHBatten), vyDistribution, -vxDistribution, vzDistribution);
		bm.setColor(nColorBattens);
		bm.setName("Sloped Batten");
		grpFloor.addEntity(bm, true, 0, 'Z');
		_Map.appendEntity("SlopedBatten", bm);
	}
	
	ptDistribution += vxDistribution * dSpacingSlopedBattens;
}

// Draw first layer on top of sloped battens.
if (dTLayer1 > 0) {
	CoordSys csToFirstLayer;
	csToFirstLayer.setToTranslation(vzDistribution * vzDistribution.dotProduct(ptStartDistribution + vzDistribution * dStartHBattens - ppDistributionArea.coordSys().ptOrg()));
	CoordSys csRotate;
	csRotate.setToRotation(-dAngle, vyDistribution, ptStartDistribution + vzDistribution * dStartHBattens);
	
	PlaneProfile ppFirstLayer = ppDistributionArea;
	ppFirstLayer.transformBy(csToFirstLayer);
	ppFirstLayer.transformBy(csRotate);
	
	dpSlopedBattens.draw(ppFirstLayer);
	
	Sheet shFirstLayer;
	shFirstLayer.dbCreate(ppFirstLayer, dTLayer1, 1);
	shFirstLayer.setColor(nColorLayer1);
	shFirstLayer.setMaterial(sMaterialLayer1);
	grpFloor.addEntity(shFirstLayer, true, 1, 'Z');
	_Map.appendEntity("Sheet", shFirstLayer);
}
// Draw first layer on top of sloped battens.
if (dTLayer2 > 0) {
	CoordSys csToSecondLayer;
	csToSecondLayer.setToTranslation(vzDistribution * vzDistribution.dotProduct(ptStartDistribution + vzDistribution * (dStartHBattens + dTLayer1) - ppDistributionArea.coordSys().ptOrg()));
	CoordSys csRotate;
	csRotate.setToRotation(-dAngle, vyDistribution, ptStartDistribution + vzDistribution * (dStartHBattens + dTLayer1));
	
	PlaneProfile ppSecondLayer = ppDistributionArea;
	ppSecondLayer.transformBy(csToSecondLayer);
	ppSecondLayer.transformBy(csRotate);
	
	dpSlopedBattens.draw(ppSecondLayer);
	
	Sheet shSecondLayer;
	shSecondLayer.dbCreate(ppSecondLayer, dTLayer2, 1);
	shSecondLayer.setColor(nColorLayer2);
	shSecondLayer.setMaterial(sMaterialLayer2);
	grpFloor.addEntity(shSecondLayer, true, 2, 'Z');
	_Map.appendEntity("Sheet", shSecondLayer);
}

Point3d arPtArrow[] = {lnSegDistributionArea.ptMid()};
Vector3d arVArrow[] = {-vxDistribution};

double dLArrow = U(750);
for (int i=0;i<arPtArrow.length();i++) {
	Point3d ptArrow = arPtArrow[i];
	Vector3d vArrow = arVArrow[i];
	
	PLine plArrow(vzDistribution);
	plArrow.addVertex(ptArrow + vArrow * 0.25 * dLArrow);
	plArrow.addVertex(ptArrow + vyDistribution * 0.25 * dLArrow);
	plArrow.addVertex(ptArrow + vyDistribution * 0.05 * dLArrow);
	plArrow.addVertex(ptArrow - vArrow * 0.75 * dLArrow + vyDistribution * 0.05 * dLArrow);
	plArrow.addVertex(ptArrow - vArrow * 0.75 * dLArrow - vyDistribution * 0.05 * dLArrow);
	plArrow.addVertex(ptArrow - vyDistribution * 0.05 * dLArrow);
	plArrow.addVertex(ptArrow - vyDistribution * 0.25 * dLArrow);
	plArrow.close();
	
	PlaneProfile ppArrow(csDistribution);
	ppArrow.joinRing(plArrow, _kAdd);
	
	dpSlopedBattens.draw(ppArrow, _kDrawFilled);
}
#End
#BeginThumbnail

#End