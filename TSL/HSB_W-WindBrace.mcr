#Version 8
#BeginDescription
#Versions
Version 1.8 12.08.2022 HSB-16219 Module name indexed





















#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 8
#KeyWords 
#BeginContents
/// <summary Lang=en>
///
/// </summary>

/// <insert>
///
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.07" date="12.06.2017"></version>

/// <history>
// #Versions
// 1.8 12.08.2022 HSB-16219 Module name indexed , Author Thorsten Huck
/// YB - 1.00 - 15.05.2017 -	Pilot version
/// YB - 1.01 - 18.05.2017 -	Replaced the flip property with a double click / custom action
/// YB - 1.02 - 18.05.2017 - 	Added a delete option in the tsl, added steel plates.
/// YB - 1.03 - 19.05.2017 - 	Beams are linked to the element, so the construction is visible in a viewport. Sheets are touching the external sheeting.
/// YB - 1.04 - 30.05.2017 - 	Completely reworked the TSL. Added a property for the steel plate offset. Added compatibility with sloped edges.
/// YB - 1.05 - 02.06.2017 - 	Added a check if the element is valid. Removed another check.
/// YB - 1.06 - 12.06.2017 - 	Add a name to beams and sheets. Add properties for the color of beams and sheets. Add visualisation. 
///							Add front / back / center for center beam. Fixed a bug with inserting the TSL.
/// YB - 1.07 - 12.06.2017 - 	Changed display location. Fixed a bug with the side offset. 
/// </history>

//Script uses mm
double dEps = U(0.01,"mm");

int executeMode = 0;
// 0 = default
// 1 = insert

int nLog = 0;

String arSYesNo[] = {T("|No|"), T("|Yes|")};
int arNYesNo[] = {_kYes, _kNo};

int arNZone[] = {1,2,3,4,5,6,7,8,9,10};

String categories[] = { T("|Frame beams|"), T("|Supporting beam|"), T("|Steel plates|"), T("|Positioning|"), T("|Sheeting|"), T("|Display|")};
String recalcProperties[0];

// Frame properties
PropDouble frameBeamWidth(0, U(25), T("|Frame beam width|"));					frameBeamWidth.setCategory(categories[0]);
PropDouble frameBeamHeight(1, U(25), T("|Frame beam height|"));				frameBeamHeight.setCategory(categories[0]);
PropInt frameBeamColor(2, 1, T("|Frame beam color|"));							frameBeamColor.setCategory(categories[0]);

// Center beam properties
PropDouble centerBeamWidth(2, U(25), T("|Center beam width|"));				centerBeamWidth.setCategory(categories[1]);
PropDouble centerBeamHeight(3, U(25), T("|Center beam height|"));				centerBeamHeight.setCategory(categories[1]);

// Steel plate properties
PropDouble steelPlateWidth(5, U(25), T("|Steel plate width|"));						steelPlateWidth.setCategory(categories[2]);			steelPlateWidth.setDescription(T("|Specifies the steel plate width.|"));
PropDouble steelPlateHeight(6, U(25), T("|Steel plate height|"));					steelPlateHeight.setCategory(categories[2]);			steelPlateHeight.setDescription(T("|Specifies the steel plate height.|"));
PropDouble steelPlateThickness(7, U(25), T("|Steel plate thickness|"));				steelPlateThickness.setCategory(categories[2]);		steelPlateThickness.setDescription(T("|Specifies the thickness for the steel plate.|"));
PropDouble steelPlateOffset(9, U(10), T("|Steel plate center offset|")); 				steelPlateOffset.setCategory(categories[2]);			steelPlateOffset.setDescription(T("|Specifies the center offset for the steel plate.|"));

// Positioning
String bracePositions[] = { T("|Front|"), T("|Center|"), T("|Back|")};				
	
PropString centerBeamPosition(2, bracePositions, T("|Center beam position|"));		centerBeamPosition.setCategory(categories[3]);
PropDouble frameSideOffset(4, U(5), T("|Frame side offset|"));						frameSideOffset.setCategory(categories[3]);
PropString bracePosition(0, bracePositions, T("|Brace position|"));					bracePosition.setCategory(categories[3]);

// Sheeting
PropDouble sheetThickness(8, U(10), T("|Sheet thickness|"));						sheetThickness.setCategory(categories[4]);
PropString sheetDescription(1, T("||"), T("|Sheet description|"));					sheetDescription.setCategory(categories[4]);
PropInt sheetColor(1, 1, T("|Sheet color|"));										sheetColor.setCategory(categories[4]);

// Display
PropInt nColor(0, 8, T("|Color|"));													nColor.setCategory(categories[5]);
PropDouble dSymbolSize(10, U(80), T("|Symbol size|"));							dSymbolSize.setCategory(categories[5]);

if( _bOnDbCreated && _kExecuteKey != "" )
	setPropValuesFromCatalog(_kExecuteKey);

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
	
	Element el = getElement(T("|Select wall element|"));
	_Element.append(el);
	_Pt0 = getPoint(T("|Select a position|"));
	
	if (_ZU.isParallelTo(_ZW))
		_Pt0 += el.vecY() * el.vecY().dotProduct(el.ptOrg() + el.vecY() * U(200) - _Pt0);
	
	_Map.setInt("ExecuteMode",1);
	
	return;
}

if( _Element.length() == 0  || !_Element[0].bIsValid()){
	eraseInstance();
	return;
}

if( _Map.hasInt("ExecuteMode") ){
	executeMode = _Map.getInt("ExecuteMode");
	_Map.removeAt("ExecuteMode", true);
}

if( _bOnElementConstructed )
	executeMode = 1;
	
// Trigger Recalculate
String sTriggerRecalculate = T("|Recalculate|");
addRecalcTrigger(_kContext, sTriggerRecalculate );
if (_bOnRecalc && (_kExecuteKey==sTriggerRecalculate) ||  _kExecuteKey=="TslDoubleClick" || _kExecuteKey ==T("|Delete|"))
{
	for (int i=0;i<_Map.length();i++) 
	{
		if (_Map.keyAt(i) != "Beam" && _Map.keyAt(i) != "Sheet")
			continue;
		if (!_Map.hasEntity(i))
		continue;
	  
		Entity ent = _Map.getEntity(i);
		ent.dbErase();
	  
		_Map.removeAt(i, true);
		i--;
	}	
}

// Trigger Delete
String sTriggerDelete = T("|Delete|");
addRecalcTrigger(_kContext, sTriggerDelete );
if (_bOnRecalc && (_kExecuteKey==sTriggerDelete))
{
	eraseInstance();
	return;
}	
//|| sheetThickness <= 0
if(centerBeamWidth <= 0 || centerBeamHeight <= 0 || frameBeamWidth <= 0 || frameBeamHeight <= 0 || steelPlateWidth <= 0 || steelPlateHeight <= 0 || steelPlateThickness <= 0 )
{
	reportNotice(T("|One of the properties was not set properly, TSL will be deleted.|"));
	for (int i=0;i<_Map.length();i++) 
	{
		if (_Map.keyAt(i) != "Beam" && _Map.keyAt(i) != "Sheet")
			continue;
		if (!_Map.hasEntity(i))
		continue;
	  
		Entity ent = _Map.getEntity(i);
		ent.dbErase();
	  
		_Map.removeAt(i, true);
		i--;
	}	
	eraseInstance();
	return;
}

Beam createdBeams[0];

// Retrieve properties
int positionIndex = bracePositions.find(bracePosition, 1);
int centerIndex = bracePositions.find(centerBeamPosition, 1);

Element el = _Element[0];
assignToElementGroup(el, true, 0, 'I');

CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

CoordSys csZnHatch = el.zone(2).coordSys();
Plane pnZnHatch(csZnHatch.ptOrg() + vzEl, vzEl);

Plane pnElMidZ(ptEl - vzEl * 0.5 * el.zone(0).dH(), vzEl);
_Pt0 = pnElMidZ.closestPointTo(_Pt0);


//region add incremental module name 
	
	TslInst tsls[]=el.tslInstAttached();
	String handles[0];
	for (int i=0;i<tsls.length();i++) 
	{ 
		TslInst& t= tsls[i]; 
		if (t.bIsValid() && t.scriptName()==scriptName())
			handles.append(t.handle());
		 
	}//next i
	int n = handles.findNoCase(_ThisInst.handle(), 0) + 1;
	String sModuleName = "WindBrace " + n;
//endregion 


Beam arBm[] = el.beam();
if( arBm.length() == 0 )
	return;

Beam arBmVertical[0];
Beam arBmHorizontal[0];
Beam arBmToCheck[0];
Beam arBmCreated[0];

for(int b = 0; b < arBm.length(); b++)
{
	Beam bm = arBm[b];
	if(bm.vecX().isPerpendicularTo(vyEl))
	{
		arBmHorizontal.append(bm);
		arBmToCheck.append(bm);
	}

	else if(bm.vecX().isPerpendicularTo(vxEl))
		arBmVertical.append(bm);
	else
		arBmToCheck.append(bm);
}

Beam arBmLeft[] = Beam().filterBeamsHalfLineIntersectSort(arBmVertical, _Pt0 - vxEl * U(5), -vxEl);
Beam arBmRight[] = Beam().filterBeamsHalfLineIntersectSort(arBmVertical, _Pt0 + vxEl * U(5), vxEl);

if( arBmLeft.length() * arBmRight.length() == 0 ){
	reportWarning(TN("|Invalid side studs|."));
	eraseInstance();
	return;
}

Beam bmLeft = arBmLeft[0];
bmLeft.setBeamCode("H-L01");
Beam bmRight = arBmRight[0];
bmLeft.setBeamCode("H-R01");

Beam arBmBottom[] = Beam().filterBeamsHalfLineIntersectSort(arBmToCheck, _Pt0 - vyEl * U(5), -vyEl);
Beam arBmTop[] = Beam().filterBeamsHalfLineIntersectSort(arBmToCheck, _Pt0 + vyEl * U(5), vyEl);

if( arBmBottom.length() * arBmTop.length() == 0 ){
	reportWarning(TN("|Invalid plates|."));
	eraseInstance();
	return;
}

Beam bmBottom = arBmBottom[0];
Beam bmTop = arBmTop[0];
// Calculate corner points
Point3d ptTopLeft = Line(bmLeft.ptCen() + bmLeft.vecD(vxEl) * 0.5 * bmLeft.dD(vxEl), vyEl).intersect(Plane(bmTop.ptCen() - bmTop.vecD(vyEl) * 0.5 * bmTop.dD(vyEl), bmTop.vecD(vyEl)), 0);
Point3d ptTopRight = Line(bmRight.ptCen() - bmRight.vecD(vxEl) * 0.5 * bmRight.dD(vxEl), vyEl).intersect(Plane(bmTop.ptCen() - bmTop.vecD(vyEl) * 0.5 * bmTop.dD(vyEl), bmTop.vecD(vyEl)), 0);
Point3d ptBottomLeft = Line(bmLeft.ptCen() + bmLeft.vecD(vxEl) * 0.5 * bmLeft.dD(vxEl), -vyEl).intersect(Plane(bmBottom.ptCen() + bmBottom.vecD(vyEl) * 0.5 * bmBottom.dD(vyEl), bmBottom.vecD(-vyEl)), 0);
Point3d ptBottomRight = Line(bmRight.ptCen() - bmRight.vecD(vxEl) * 0.5 * bmRight.dD(vxEl), -vyEl).intersect(Plane(bmBottom.ptCen() + bmBottom.vecD(vyEl) * 0.5 * bmBottom.dD(vyEl), bmBottom.vecD(-vyEl)), 0);

if(positionIndex == 0)
{
	ptTopLeft += vzEl * 0.5 * bmLeft.dD(vzEl) - vzEl * 0.5 * frameBeamHeight - vzEl * sheetThickness;
	ptTopRight += vzEl * 0.5 * bmLeft.dD(vzEl) - vzEl * 0.5 * frameBeamHeight - vzEl * sheetThickness; 		
	ptBottomLeft += vzEl * 0.5 * bmLeft.dD(vzEl) - vzEl * 0.5 * frameBeamHeight - vzEl * sheetThickness; 		
	ptBottomRight += vzEl * 0.5 * bmLeft.dD(vzEl) - vzEl * 0.5 * frameBeamHeight - vzEl * sheetThickness; 	
}
else if(positionIndex == 2)
{
	ptTopLeft -= vzEl * 0.5 * bmLeft.dD(vzEl) - vzEl * 0.5 * frameBeamHeight - vzEl * sheetThickness; 			
	ptTopRight -= vzEl * 0.5 * bmLeft.dD(vzEl) - vzEl * 0.5 * frameBeamHeight - vzEl * sheetThickness;		
	ptBottomLeft -= vzEl * 0.5 * bmLeft.dD(vzEl) - vzEl * 0.5 * frameBeamHeight - vzEl * sheetThickness; 		
	ptBottomRight -= vzEl * 0.5 * bmLeft.dD(vzEl) -vzEl * 0.5 * frameBeamHeight - vzEl * sheetThickness; 	
}

ptTopLeft += vxEl * frameSideOffset - vyEl * frameSideOffset;
ptTopRight -= vxEl * frameSideOffset + vyEl * frameSideOffset;
ptTopRight.vis();
ptBottomLeft += vxEl * frameSideOffset + vyEl * frameSideOffset;
ptBottomRight -= vxEl * frameSideOffset + vyEl * frameSideOffset;

ptTopLeft.vis();

// Create the frame around
Beam rightBeam;
Beam leftBeam;
Beam bottomBeam;
Beam topBeam;

rightBeam.dbCreate(ptTopRight - vyEl * abs(vyEl.dotProduct(ptTopRight - ptBottomRight)) / 2, bmRight.vecX(), vxEl, vzEl, vyEl.dotProduct(ptTopRight - ptBottomRight), frameBeamWidth, frameBeamHeight, 0, -1, 0);
leftBeam.dbCreate(ptTopLeft - vyEl * abs(vyEl.dotProduct(ptTopLeft - ptBottomLeft)) / 2 ,bmLeft.vecX(), vxEl, vzEl, vyEl.dotProduct(ptTopLeft - ptBottomLeft), frameBeamWidth, frameBeamHeight, 0, 1, 0);
bottomBeam.dbCreate(ptBottomLeft + vxEl * 2 * frameBeamWidth, bmBottom.vecX(), bmBottom.vecY(), bmBottom.vecZ(), U(1), frameBeamWidth, frameBeamHeight, 0, 1, 0);
topBeam.dbCreate(ptTopLeft + bmTop.vecX() * 2 * frameBeamWidth, bmTop.vecX(), bmTop.vecY(), bmTop.vecZ(), U(1), frameBeamWidth, frameBeamHeight, 1, -1, 0);

_Map.appendEntity("Beam", rightBeam);
_Map.appendEntity("Beam", leftBeam);
_Map.appendEntity("Beam", bottomBeam);
_Map.appendEntity("Beam", topBeam);
rightBeam.setModule(sModuleName);
leftBeam.setModule(sModuleName);
bottomBeam.setModule(sModuleName);
topBeam.setModule(sModuleName);
arBmCreated.append(rightBeam);
arBmCreated.append(leftBeam);
arBmCreated.append(bottomBeam);
arBmCreated.append(topBeam);

int bStretch = _kStretchOnInsert;
bottomBeam.stretchStaticTo(leftBeam, bStretch);
bottomBeam.stretchStaticTo(rightBeam, bStretch);
topBeam.stretchStaticTo(leftBeam, bStretch);
topBeam.stretchStaticTo(rightBeam, bStretch);

// Create the center beam

int bIsRotated = 1;
if(_Map.hasInt("Side")) bIsRotated = _Map.getInt("Side");

// Trigger Flip
String sTriggerFlip = T("|Flip|");
addRecalcTrigger(_kContext, sTriggerFlip );
if (_bOnRecalc && (_kExecuteKey==sTriggerFlip || _kExecuteKey=="TslDoubleClick"))
{
	_Map.setInt("Side", bIsRotated * -1);
}

// Calculate if the left or right side is the longest side.
double distanceToCenter = vyEl.dotProduct(ptTopLeft - ptBottomLeft);
if(vyEl.dotProduct(ptTopRight - ptBottomRight) < distanceToCenter)
	distanceToCenter = vyEl.dotProduct(ptTopRight - ptBottomRight);
Point3d ptCenterStart = ptBottomLeft + vyEl * 0.5 * distanceToCenter + vxEl * (frameBeamWidth + 0.5 * bottomBeam.solidLength());

int zAlignCenterBeam = 0;
if(centerIndex == 0)
	zAlignCenterBeam = 1;
else if(centerIndex == 2)
	zAlignCenterBeam = -1;

Beam centerBeam;
centerBeam.dbCreate(ptCenterStart, vxEl, vyEl, vzEl, U(1), centerBeamHeight, centerBeamWidth, 1, 0, zAlignCenterBeam);
_Map.appendEntity("Beam", centerBeam);
centerBeam.setModule(sModuleName);
centerBeam.stretchStaticTo(leftBeam, bStretch);
centerBeam.stretchStaticTo(rightBeam, bStretch);
arBmCreated.append(centerBeam);

// Create the top and bottom angled rafters.
Point3d ptCenterTop = ptCenterStart + vyEl * 0.5 * centerBeamWidth + (vxEl * bIsRotated) * (0.5 * centerBeam.solidLength());
Point3d ptCenterBottom = ptCenterStart - vyEl * 0.5 * centerBeamWidth + (vxEl * bIsRotated) * (0.5 * centerBeam.solidLength());
Beam topAngledBeam;
Beam bottomAngledBeam;

if(bIsRotated == -1)
{
	// Top angled beam
	Point3d ptTopEnd = Line(topBeam.ptCen() - topBeam.vecD(vyEl) * 0.5 * topBeam.dD(vyEl), topBeam.vecX()).intersect(Plane(rightBeam.ptCen() - vxEl * 0.5 * rightBeam.dD(vxEl), vxEl), 0);
	Vector3d bmX = Vector3d(ptCenterTop - ptTopEnd);
	Vector3d bmY = vzEl.crossProduct(bmX);
	bmX.normalize();
	bmY.normalize();
	topAngledBeam.dbCreate(ptCenterTop, bmX, bmY, vzEl, U(1), frameBeamHeight, frameBeamWidth, 0, 0, 0);
	topAngledBeam.stretchStaticToMultiple(topBeam, rightBeam, bStretch);
	topAngledBeam.stretchStaticToMultiple(leftBeam, centerBeam, bStretch);
	
	// Bottom angled beam
	Point3d ptBottomEnd = Line(bottomBeam.ptCen() + bottomBeam.vecD(vyEl) * 0.5 * bottomBeam.dD(vyEl), -bottomBeam.vecX()).intersect(Plane(rightBeam.ptCen() - vxEl * 0.5 * rightBeam.dD(vxEl), vxEl), 0);
	Vector3d bmBottomX =(ptBottomEnd - ptCenterBottom);
	Vector3d bmBottomY = vzEl.crossProduct(bmBottomX);
	bmBottomY.normalize();
	bmBottomX.normalize();
	bottomAngledBeam.dbCreate(ptCenterBottom, bmBottomX, bmBottomY, vzEl, U(1), frameBeamHeight, frameBeamWidth, 0, 0, 0);
	bottomAngledBeam.stretchStaticToMultiple(bottomBeam, rightBeam, bStretch);
	bottomAngledBeam.stretchStaticToMultiple(centerBeam, leftBeam, bStretch);
}

else
{
	// Top angled beam
	Point3d ptTopEnd = Line(topBeam.ptCen() - topBeam.vecD(vyEl) * 0.5 * topBeam.dD(vyEl),- topBeam.vecX()).intersect(Plane(leftBeam.ptCen() + vxEl * 0.5 * rightBeam.dD(vxEl), -vxEl), 0);
	Vector3d bmY = vzEl.crossProduct(Vector3d(ptCenterTop - ptTopEnd));
	bmY.normalize();
	bmY.vis(ptCenterBottom, 3);
	vzEl.vis(ptCenterBottom, 150);
	topAngledBeam.dbCreate(ptCenterTop, Vector3d(ptCenterTop - ptTopEnd), bmY, vzEl, U(1), frameBeamHeight, frameBeamWidth, 0, 0, 0);
	topAngledBeam.stretchStaticToMultiple(topBeam, leftBeam, bStretch);
	topAngledBeam.stretchStaticToMultiple(rightBeam, centerBeam, bStretch);
	
	// Bottom angled beam
	Point3d ptBottomEnd = Line(bottomBeam.ptCen() + bottomBeam.vecD(vyEl) * 0.5 * bottomBeam.dD(vyEl), bottomBeam.vecX()).intersect(Plane(leftBeam.ptCen() + vxEl * 0.5 * rightBeam.dD(vxEl), vxEl), 0);
	Vector3d bmBottomX =(ptBottomEnd - ptCenterBottom);
	Vector3d bmBottomY = vzEl.crossProduct(bmBottomX);
	bmBottomY.normalize();
	bmBottomX.normalize();
	bottomAngledBeam.dbCreate(ptCenterBottom, bmBottomX, bmBottomY, vzEl, U(1), frameBeamHeight, frameBeamWidth, 0, 0, 0);
	bottomAngledBeam.stretchStaticToMultiple(bottomBeam, leftBeam, bStretch);
	bottomAngledBeam.stretchStaticToMultiple(centerBeam, rightBeam, bStretch);
}

double topDistance = abs(vxEl.dotProduct(ptTopLeft - ptTopRight));
double bottomDistance = abs(vxEl.dotProduct(ptBottomLeft - ptBottomRight));
Point3d ptTopOrg = ptTopLeft + vxEl * 0.5 * topDistance;
ptTopOrg += vxEl * -bIsRotated * 0.5 * topDistance;
ptTopOrg += vzEl * vzEl.dotProduct(ptTopOrg - (ptTopRight - vzEl * 0.5 * frameBeamWidth + vzEl * 0.5 * steelPlateThickness));
Point3d ptBottomOrg = ptBottomLeft + vxEl * 0.5 * bottomDistance;
ptBottomOrg += vxEl * -bIsRotated * 0.5 * topDistance;
ptBottomOrg += vzEl * vzEl.dotProduct(ptBottomOrg - (ptTopRight - vzEl * 0.5 * frameBeamHeight + vzEl * 0.5 * steelPlateThickness));
Point3d ptCenterTopOrg = ptCenterTop + vxEl * -bIsRotated * 0.5 * centerBeam.solidLength();
ptCenterTopOrg += vxEl * bIsRotated * 0.5 * (2 * frameBeamWidth + centerBeam.solidLength()) - vyEl * steelPlateOffset;
ptCenterTopOrg += vzEl * vzEl.dotProduct(ptCenterTopOrg - (ptTopRight - vzEl * 0.5 * frameBeamHeight + vzEl * 0.5 * steelPlateThickness));
Point3d ptCenterBottomOrg = ptCenterBottom + vxEl * -bIsRotated * 0.5 * centerBeam.solidLength();
ptCenterBottomOrg += vxEl * bIsRotated * 0.5 * (2 * frameBeamWidth + centerBeam.solidLength()) + vyEl * steelPlateOffset;
ptCenterBottomOrg += vzEl * vzEl.dotProduct(ptCenterBottomOrg - (ptTopRight - vzEl * 0.5 * frameBeamHeight + vzEl * 0.5 * steelPlateThickness));

if(positionIndex == 2)
{
	ptTopOrg -= vzEl * (frameBeamWidth -  0.5 * sheetThickness);
	ptBottomOrg -= vzEl * (frameBeamWidth - 0.5 * sheetThickness);
	ptCenterTopOrg -= vzEl * (frameBeamWidth - 0.5 * sheetThickness);
	ptCenterBottomOrg -= vzEl * (frameBeamWidth - 0.5 * sheetThickness);
}

MetalPart mpTop(ptTopOrg, vxEl, vyEl, vzEl, steelPlateHeight, steelPlateWidth, steelPlateThickness, bIsRotated, -1, 0);
MetalPart mpCenterBottom(ptCenterBottomOrg, vxEl, vyEl, vzEl, steelPlateHeight, steelPlateWidth, steelPlateThickness, -bIsRotated, -1, 0);
MetalPart mpCenterTop(ptCenterTopOrg, vxEl, vyEl, vzEl, steelPlateHeight, steelPlateWidth, steelPlateThickness, -bIsRotated, 1, 0);
MetalPart mpBottom(ptBottomOrg, vxEl, vyEl, vzEl, steelPlateHeight, steelPlateWidth, steelPlateThickness, bIsRotated, 1, 0);

_Map.appendEntity("Beam", topAngledBeam);
_Map.appendEntity("Beam", bottomAngledBeam);
topAngledBeam.setModule(sModuleName);
bottomAngledBeam.setModule(sModuleName);
arBmCreated.append(topAngledBeam);
arBmCreated.append(bottomAngledBeam);

PLine plFrontSheet(ptTopLeft + vzEl * 0.5 * frameBeamHeight + vzEl * 0.5 * sheetThickness, ptTopRight + vzEl * 0.5 * frameBeamHeight + vzEl * 0.5 * sheetThickness, ptBottomRight + vzEl * 0.5 * frameBeamHeight + vzEl * 0.5 * sheetThickness, ptBottomLeft + vzEl * 0.5 * frameBeamHeight + vzEl * 0.5 * sheetThickness);
plFrontSheet.close();
Sheet frontSheet;
frontSheet.dbCreate(PlaneProfile(plFrontSheet), sheetThickness, 0);
_Map.appendEntity("Sheet", frontSheet);
frontSheet.setModule(sModuleName);
frontSheet.assignToElementGroup(el, true, 5, 'Z');
frontSheet.setColor(sheetColor);
frontSheet.setName("WIndBrace_Sheet");

PLine plBackSheet(ptTopLeft - vzEl * 0.5 * frameBeamHeight - vzEl * 0.5 * sheetThickness, ptTopRight - vzEl * 0.5 * frameBeamHeight - vzEl * 0.5 * sheetThickness, ptBottomRight - vzEl * 0.5 * frameBeamHeight - vzEl * 0.5 * sheetThickness, ptBottomLeft - vzEl * 0.5 * frameBeamHeight - vzEl * 0.5 * sheetThickness);
plFrontSheet.close();
Sheet backSheet;
backSheet.dbCreate(PlaneProfile(plBackSheet), sheetThickness, 0);
_Map.appendEntity("Sheet", backSheet);
backSheet.setModule(sModuleName);
backSheet.assignToElementGroup(el, true, 5, 'Z');
backSheet.setColor(sheetColor);
backSheet.setName("WindBrace_Sheet");

for(int b = 0; b < arBmCreated.length(); b++)
{
	Beam bm = arBmCreated[b];
	bm.assignToElementGroup(el, true, 0, 'Z');	
	bm.setType(_kElementModule);
	bm.setColor(frameBeamColor);
	bm.setName("WindBrace_Beam");
}

// visualisation
Display dpVisualisation(nColor);
dpVisualisation.textHeight(U(4));
dpVisualisation.addHideDirection(_ZW);
dpVisualisation.addHideDirection(-_ZW);
dpVisualisation.elemZone(el, 0, 'I');

Point3d symbolOrg = el.ptOrg() - vxEl * vxEl.dotProduct(el.ptOrg() - _Pt0);

Point3d ptSymbol01 = symbolOrg - vyEl * 2 * dSymbolSize;
Point3d ptSymbol02 = ptSymbol01 - (vxEl + vyEl) * dSymbolSize;
Point3d ptSymbol03 = ptSymbol01 + (vxEl - vyEl) * dSymbolSize;

PLine plSymbol01(vzEl);
plSymbol01.addVertex(symbolOrg);
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

{
	Display dpVisualisationPlan(nColor);
	dpVisualisationPlan.textHeight(U(4));
	dpVisualisationPlan.addViewDirection(_ZW);
	dpVisualisationPlan.addViewDirection(-_ZW);
	dpVisualisationPlan.elemZone(el, 0, 'I');
	
	Point3d ptSymbol01 = symbolOrg + vzEl * 2 * dSymbolSize;
	Point3d ptSymbol02 = ptSymbol01 - (vxEl - vzEl) * dSymbolSize;
	Point3d ptSymbol03 = ptSymbol01 + (vxEl + vzEl) * dSymbolSize;
	
	PLine plSymbol01(vyEl);
	plSymbol01.addVertex(symbolOrg);
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
}

#End
#BeginThumbnail




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
        <int nm="BreakPoint" vl="204" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16219 Module name indexed" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="8/12/2022 5:57:55 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End