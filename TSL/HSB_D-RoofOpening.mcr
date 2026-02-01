#Version 8
#BeginDescription
Last modified by: Robert Pol(support.nl@hsbcad.com)
04.03.2021  -  version 3.04

Displays roof opening(s) info
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 3
#MinorVersion 4
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

/// <version  value="3.03" date="04.10.2019"></version>

/// <history>
/// AS - 1.00 - 08.05.2013 -	Pilot version
/// AS - 1.01 - 10.09.2013 -	Add tolerance on opening detection
/// AS - 1.02 - 23.10.2013 -	Add settings for description
/// AS - 2.00 - 02.04.2014 -	Reorganize properties. Split object, orientation and side.
/// AS - 2.01 - 14.05.2014 -	Get points from realbody if extract contactface in plane does not return a valid profile.
/// AS - 2.02 - 09.09.2014 -	Add opening info if its not in the profnetto of the element.
/// AS - 2.03 - 09.11.2015 -	Correct read direction
/// AS - 2.04 - 19.10.2016 -	Correct closest rafter dimension for element-Y in horizontal in viewport.
/// AS - 2.05 - 19.10.2016 -	Add dimension side for closest rafter as property.
/// AS - 2.06 - 23.12.2016 -	Also check for intersection at the inside and outside of the frame.
/// DR - 2.07 - 26.04.2017 -	Added props ShowFrame (No/Yes), nFrameColor
///							Added separated displays for every vector view
/// DR - 2.71 - 12.05.2017 -	Versionning corrected
/// RP - 2.72 - 05.12.2017 -	Add support for custom tsl entities
/// RP - 2.73 - 15.12.2017 -	Do check for point in profile on front of the element plane. Because this created issues with a steep element.
/// RP - 2.74 - 12.01.2018 -	Check or openings should be on floor level.
/// AS - 2.75 - 06.04.2018 -	Extend opening filter with an include/exclude option. Work of full description of custom entities, if available.
/// RP - 2.76 - 01.08.2018 -	Make sure that custom entities have a pline
/// RP - 2.77 - 22.01.2019 -	Allow multiple Plines in custom entities
//RVW- 2.78 - 14.05.2019 -	Fill entity array arEntOpRf with entities on Group() level instead of entities from floorGroup, and get the Entities from _kMySpace instead of _kModelSpace.
/// RP - 2.79 - 26.06.2019 -	Use the previous entity array to delete openings in modelspace, then fill the array again with the openings in modelspace.
/// RP - 3.00 - 28.06.2019 -	Do not use dummy openings anymore
/// RP - 3.01 - 04.09.2019 -	Use bottom plane of element for getting ref point of opening
/// RP - 3.02 - 04.09.2019 -	Use bottom of element for element coordsys
/// RP - 3.03 - 04.10.2019 -	Only get openings from floorgroup
/// RP - 3.04 - 04.03.2021 -	Switch to reportmessage instead of reportnotice
/// </history>


//Script uses mm
double dEps = U(.001,"mm");
double vectorTolerance = U(0.001);

String arSSectionName[] = {" "};
Entity arEntTsl[] = Group().collectEntities(true, TslInst(), _kMySpace);
for( int i=0;i<arEntTsl.length();i++ ){
	TslInst tsl = (TslInst)arEntTsl[i];
	if( !tsl.bIsValid() )
		continue;
	Map mapTsl = tsl.map();
	String vpHandle = mapTsl.getString("VPHANDLE");
	if( vpHandle == "" )
		continue;
	if( arSSectionName.find(tsl.scriptName()) == -1 )
		arSSectionName.append(tsl.scriptName());
}

String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};

String arSDimensionType[] = {
	T("|Opening size|"),
	T("|Cross|")
//	T("|Rafter above opening|")
};
String arSOrientation[] = {
	T("|Horizontal|"),
	T("|Vertical|")
};
String arSSide[] = {
	T("|Left|"),
	T("|Right|"),
	T("|Center|")
};
String arSPositionReference[] = {
	T("|Opening|"),
	T("|Element|")
};

int sides[] = {-1, 0, 1};
String sidesClosestRafter[] = {
	T("|Inside|"),
	T("|Center|"),
	T("|Outside|")
};

String scriptNames[] =
{
	 "EM_R-Skylight",
	 "EM_R-Opening",
	 "EM_R-Tube",
	 "EM_R-OpeningCreator"
};

String arSDeltaOnTop[]={T("|Above|"),T("|Below|")};
int arNDeltaOnTop[]={true, false};

String sArDimLayout[] ={
	T("|Delta perpendicular|"),
	T("|Delta parallel|"),
	T("|Cummulative perpendicular|"),
	T("|Cummalative parallel|"),
	T("|Both perpendicular|"),
	T("|Both parallel|"),
	T("|Delta parallel|, ")+T("|Cummalative perpendicular|"),
	T("|Delta perpendicular|, ")+T("|Cummalative parallel|")
};
int nArDimLayoutDelta[] = {_kDimPerp, _kDimPar,_kDimNone,_kDimNone,_kDimPerp,_kDimPar,_kDimPar,_kDimPerp};
int nArDimLayoutCum[] = {_kDimNone,_kDimNone,_kDimPerp, _kDimPar,_kDimPerp,_kDimPar,_kDimPerp,_kDimPar};

String sArDimensionSide[]={T("|Left|"),T("|Center|"),T("|Right|"), T("|Left| & ") + T("|Right|")};
int nArDimensionSide[]={_kLeft, _kCenter, _kRight, _kLeftAndRight};

String arSReferenceType[] = {
	T("|No reference|"),
	T("|Beamcode|"),
	T("|Zone|"),
	T("|Rafters|"),
	T("|Closest rafters|")
};

int arNReferenceZone[] = {0,1,2,3,4,5,6,7,8,9,10};

String arSReferenceSide[] = {T("|Left|"),T("|Right|"), T("|Left| & ") + T("|Right|")};
int arNReferenceSide[]={_kLeft, _kRight, _kLeftAndRight};

/// - Filter -
///
PropString sSeperator01(0, "", T("|Filter|"));
sSeperator01.setReadOnly(true);
PropString sSectionName(1, arSSectionName, "     "+T("|Section tsl name|"));
PropString sFilterBC(2,"","     "+T("|Filter beams with beamcode|"));
PropString sFilterLabel(3,"","     "+T("|Filter beams and sheets with label|"));
PropString sFilterMaterial(4,"","     "+T("|Filter beams and sheets with material|"));
PropString sFilterHsbID(5,"","     "+T("|Filter beams and sheets with hsbID|"));
PropString sFilterZone(6, "", "     "+T("|Filter zones|"));


/// - Opening -
PropString sSeperatorOpenings(36, "", T("|Opening|"));
sSeperatorOpenings.setReadOnly(true);
String filterTypes[] = 
{
	T("|Include|"),
	T("|Exclude|")
};
PropString openingFilterType(35, filterTypes, "     " + T("|Filter type|"), 1);
PropString sFilterOpening(7, "", "     "+T("|Filter openings with description|"));
// ---------------------------------------------------------------------------------

/// - Dimension Object -
///
PropString sSeperator02(8, "", T("|Dimension object|"));
sSeperator02.setReadOnly(true);
PropString sDimensionType(9,arSDimensionType,"     "+T("|Dimension type|"));
PropString sShowDescription(10, arSYesNo, "     "+T("|Show description|"),1);
PropString sShowFrame(34, arSYesNo, "     "+T("|Show frame|"),1);
PropString sNewLineChar(11, ";", "     "+T("|New line character|"));
sNewLineChar.setDescription(T("|The description will be split on this character|.")+T("|Each part will be displayed on a new line|."));


/// - Positioning -
/// 
PropString sSeperator03(12, "", T("|Positioning|"));
sSeperator03.setReadOnly(true);
PropString sOrientation(13, arSOrientation, "     "+T("|Orientation dimension line|"));
PropString sSideDimensionLine(14, arSSide, "     "+T("|Side dimension line|"));
PropString sDimLinePerOpening(15, arSYesNo, "     "+T("|Dimension line per opening|"));
PropString sPositionReference(16, arSPositionReference, "     "+T("|Position reference|"));
PropString sUsePSUnits(17, arSYesNo, "     "+T("|Offset in paperspace units|"),1);
PropDouble dDimLineOffset(0, U(300), "     "+T("|Offset dimension line|"));
PropDouble dTextOffset(1, U(100), "     "+T("|Offset description|"));


/// - Style -
/// 
PropString sSeperator04(18, "", T("|Style|"));
sSeperator04.setReadOnly(true);
PropString sDeltaOnTop(19,arSDeltaOnTop,"     "+T("|Side of delta dimension|"),0);
PropString sDimLayout(20,sArDimLayout,"     "+T("|Dimension method|"));
PropString sDimensionSide(21,sArDimensionSide,"     "+T("|Dimension side|"));
PropString sDimStyle(22, _DimStyles, "     "+T("|Dimension style|"));
PropInt nDimColor(0,1,"     "+T("|Color|"));
PropString sDimStyleDescription(23, _DimStyles, "     "+T("|Dimension style description|"));
PropInt nDescriptionColor(1,1,"     "+T("|Color description|"));
PropDouble dTextSizeDescription(2, U(15), "     "+T("|Textsize description|"));
PropString sLineType(24, _LineTypes, "     "+T("|Line type cross|"));
PropInt nFrameColor(6,1,"     "+T("|Frame color|"));

/// - Reference -
///
PropString sSeperator05(25, "", T("|Reference|"));
sSeperator05.setReadOnly(true);
PropString sFilterBCReference(26,"","     "+T("|Filter beams with beamcode as reference|"));
PropString sReferenceType(27, arSReferenceType, "     "+T("|Reference object|"));
PropString sReferenceBeamCode(28, "", "     "+T("|Reference beamcode|"));
PropInt nReferenceZone(2, arNReferenceZone, "     "+T("|Reference zone|"),5);
PropString sReferenceSide(29, arSReferenceSide, "     "+T("|Reference side|"));
PropString sideClosetsRafterProp(33, sidesClosestRafter, "     " + T("|Dimension side closest rafter|"));

/// - Name and description -
/// 
PropString sSeperator14(30, "", T("|Name and description|"));
sSeperator14.setReadOnly(true);
PropInt nColorName(3, -1, "     "+T("|Default name color|"));
PropInt nColorActiveFilter(4, 30, "     "+T("|Filter other element color|"));
PropInt nColorActiveFilterThisElement(5, 1, "     "+T("|Filter this element color|"));
PropString sDimStyleName(31, _DimStyles, "     "+T("|Dimension style name|"));
PropString sInstanceDescription(32, "", "     "+T("|Extra description|"));


String arSTrigger[] = {
	T("|Filter this element|"),
	"     ----------",
	T("|Remove filter for this element|"),
	T("|Remove filter for all elements|")
};
for( int i=0;i<arSTrigger.length();i++ )
	addRecalcTrigger(_kContext, arSTrigger[i] );

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
	
	_Viewport.append(getViewport(T("|Select the viewport|")));
	_Pt0 = getPoint(T("|Select location|"));
	
	return;
}

//Is there a viewport selected
if( _Viewport.length()==0 ){
	eraseInstance();
	return;
}
Viewport vp = _Viewport[0];

// Draw name
String sInstanceNameAndDescription = _ThisInst.scriptName();
if( sInstanceDescription.length() > 0 )
	sInstanceNameAndDescription += (" - "+sInstanceDescription);

Display dpName(nColorName);
dpName.dimStyle(sDimStyleName);
dpName.draw(sInstanceNameAndDescription, _Pt0, _XW, _YW, 1, 2);

// check if the viewport has hsb data
Element el = vp.element();
if( !el.bIsValid() )
	return;

// Add filteer
if( _kExecuteKey == arSTrigger[0] ){
	Map mapFilterElements;
	if( _Map.hasMap("FilterElements") )
		mapFilterElements = _Map.getMap("FilterElements");
	
	mapFilterElements.setString(el.handle(), "Element Filter");
	_Map.setMap("FilterElements", mapFilterElements);
}

// Remove single filteer
if( _kExecuteKey == arSTrigger[2] ){
	Map mapFilterElements;
	if( _Map.hasMap("FilterElements") ){
		mapFilterElements = _Map.getMap("FilterElements");
		
		if( mapFilterElements.hasString(el.handle()) )
			mapFilterElements.removeAt(el.handle(), true);
		_Map.setMap("FilterElements", mapFilterElements);
	}
}

// Remove all filteer
if( _kExecuteKey == arSTrigger[3] ){
	if( _Map.hasMap("FilterElements") )
		_Map.removeAt("FilterElements", true);
}

Map mapFilterElements;
if( _Map.hasMap("FilterElements") )
	mapFilterElements = _Map.getMap("FilterElements");
if( mapFilterElements.length() > 0 ){
	if( mapFilterElements.hasString(el.handle()) ){
		dpName.color(1);
		dpName.draw(_ThisInst.scriptName(), _Pt0, _XW, _YW, 1, 2);
		dpName.textHeight(U(2.5));
		dpName.draw(T("|Active filter|"), _Pt0, _XW, _YW, 1, 1);
		return;
	}
	else{
		dpName.color(30);
		dpName.draw(_ThisInst.scriptName(), _Pt0, _XW, _YW, 1, 2);
		dpName.textHeight(U(2.5));
		dpName.draw(T("|Active filter|"), _Pt0, _XW, _YW, 1, 1);
	}
}
	
//Element coordSys
CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

csEl = CoordSys(ptEl - vzEl * el.zone(0).dH(), vxEl, vyEl, vzEl);

PlaneProfile ppEl(csEl);
ppEl = el.profNetto(0);

Plane pnElZMid(ptEl - vzEl * .5 * el.zone(0).dH(), vzEl);
Plane pnElBack(ptEl - vzEl * el.zone(0).dH(), -vzEl);
Plane pnElFront(ptEl, vzEl);
pnElBack.vis(6);
Line lnXEl(ptEl, vxEl);
Line lnYEl(ptEl, vyEl);
Line lnZEl(ptEl, vzEl);

Group grpEl = el.elementGroup();
Group grpFloor(grpEl.namePart(0), grpEl.namePart(1), "" );
Entity arEntOpRf[] = grpFloor.collectEntities(true, OpeningRoof(), _kModelSpace);
Entity arEntCustomTsl[] = grpFloor.collectEntities(true, TslInst(), _kModelSpace);

PLine openingPlines[0];
String openingDescriptions[0];

for (int index=0;index<arEntOpRf.length();index++) 
{ 
	Entity entity = arEntOpRf[index];
	if (entity.subMapX("HSB_D-RoofOpening").getInt("DummyOpening"))
	{
		entity.dbErase();
		continue;
	}

	OpeningRoof opRf = (OpeningRoof)entity;
	if ( ! opRf.bIsValid() ) continue;
	
	openingPlines.append(opRf.plShape());
	openingDescriptions.append(opRf.description());

}

Entity arEntCustom[0];
for (int index=0;index<arEntCustomTsl.length();index++) 
{ 
	TslInst tsl = (TslInst)arEntCustomTsl[index]; 
	if (scriptNames.find(tsl.scriptName()) != -1) 
		arEntCustom.append(tsl);
}

for (int index=0;index<arEntCustom.length();index++) 
{ 
	TslInst openingTsl = (TslInst)arEntCustom[index]; 
	Map tslMap = openingTsl.map();
	if ( ! tslMap.hasPLine("OpeningOutLine"))
	{
		reportMessage(TN("|Custom opening|: " + openingTsl + " |does not have a pline|"));
		continue;
	}
	for (int index2 = 0; index2 < tslMap.length(); index2++)
	{
		String keyAt = tslMap.keyAt(index2);
		if (keyAt != "OpeningOutLine") continue;
		
		PLine tslPline = tslMap.getPLine(index2);
		tslPline.projectPointsToPlane(Plane(_PtW, _ZW), _ZW);
		Map openingMap = openingTsl.map();
		String description = openingMap.getString("Description");
		if (openingMap.hasString("FullDescription"))
		{
			description = openingMap.getString("FullDescription");
		}
		
		openingPlines.append(tslPline);
		openingDescriptions.append(description);
	}
}

PLine arPlEl[] = ppEl.allRings();
int arIsOpening[] = ppEl.ringIsOpening();

PLine arPlOp[0];
Point3d arPtOp[0];

PlaneProfile ppElConvexHull(csEl);
PLine convexHull;
convexHull.createConvexHull(Plane(ptEl, vzEl), ppEl.getGripVertexPoints());
ppElConvexHull.joinRing(convexHull, false);

PLine plinesThisElment[0];
String arSOpDescription[0];

for( int i=0;i<openingPlines.length();i++ )
{
	
	PLine plOpShape = openingPlines[i];
	String description = openingDescriptions[i];
	Point3d ptOpRf = Body(plOpShape, _ZW).ptCen();
	Line lnOpRfZ(ptOpRf, _ZW);
	ptOpRf = lnOpRfZ.intersect(pnElBack,U(0));
	

	if( ppElConvexHull.pointInProfile(ptOpRf) == _kPointInProfile ) 
	{
		plOpShape.vis(2);
		plOpShape.projectPointsToPlane(pnElBack, _ZW);
		plOpShape.vis(4);
		arPlEl.append(plOpShape);
		arIsOpening.append(true);
	}
	
	for( int j=0;j<arPlEl.length();j++ ){
		PLine plEl = arPlEl[j];
		plEl.vis(1);
		int isOpening = arIsOpening[j];
		
		if( !isOpening )
			continue;
		
		PlaneProfile ppOp(csEl);
		ppOp.joinRing(plEl, _kAdd);
		ppOp.shrink(-U(125));
		ppOp.vis(i);
		ptOpRf.vis(i);
	
		if( ppOp.pointInProfile(ptOpRf) == _kPointInProfile )
		{
			plinesThisElment.append(plOpShape);
			
			plEl.vis();
			
			arPlOp.append(plEl);
			arPtOp.append(ptOpRf);
			arSOpDescription.append(description);
			break;
		}
	}	
}

//Coordinate system
CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps
double dVpScale = ps2ms.scale();

int raftersAreHorizontal = false;
Vector3d vyps = vyEl;
vyps.transformBy(ms2ps);
vyps.normalize();
if (abs(abs(vyps.dotProduct(_XW)) - 1) < vectorTolerance)
	raftersAreHorizontal = true;

Display dpDim(nDimColor);
dpDim.dimStyle(sDimStyle, dVpScale); // dimstyle was adjusted for display in paper space, sets textHeight

Display dpDescription(nDescriptionColor);
dpDescription.dimStyle(sDimStyleDescription, dVpScale);
dpDescription.textHeight(dTextSizeDescription);

//Display dpCross(nDimColor);
//dpCross.dimStyle(sDimStyle, dVpScale); // dimstyle was adjusted for display in paper space, sets textHeight
//dpCross.lineType(sLineType);
//todo
Vector3d vView = vzEl;
vView.transformBy(ms2ps);
vView.normalize();
Display dpFront(-1);
dpFront.dimStyle(sDimStyle, dVpScale); // dimstyle was adjusted for display in paper space, sets textHeight
dpFront.lineType(sLineType);
dpFront.addViewDirection(vView);
dpFront.addViewDirection(-vView);

vView=vxEl;
vView.transformBy(ms2ps);
vView.normalize();
Display dpSide(-1);
dpSide.dimStyle(sDimStyle, dVpScale); // dimstyle was adjusted for display in paper space, sets textHeight
dpSide.lineType(sLineType);
dpSide.addViewDirection(vView);
dpSide.addViewDirection(-vView);

vView = vyEl;
vView.transformBy(ms2ps);
vView.normalize();
Display dpTop(-1);
dpTop.dimStyle(sDimStyle, dVpScale); // dimstyle was adjusted for display in paper space, sets textHeight
dpTop.lineType(sLineType);
dpTop.addViewDirection(vView);
dpTop.addViewDirection(-vView);

// resolve props
// selection
String arSExcludeBC[] = sFilterBC.makeUpper().tokenize(";");
String arSExcludeLbl[] = sFilterLabel.makeUpper().tokenize(";");
String arSExcludeMat[] = sFilterMaterial.makeUpper().tokenize(";");
String arSExcludeHsbId[] = sFilterHsbID.makeUpper().tokenize(";");

int arNFilterZone[0];
String zoneFilters[] = sFilterZone.tokenize(";");
for (int z=0;z<zoneFilters.length();z++)
{
	int zone = zoneFilters[z].atoi();
	if( zone > 5 )
		zone = 5 - zone;	
	arNFilterZone.append(zone);
}

String arSFOpening[] = sFilterOpening.makeUpper().tokenize(";");
int includeOpenings = filterTypes.find(openingFilterType, 1) == 0;

// Object
int nDimensionType = arSDimensionType.find(sDimensionType,0);
int bShowDescription = arNYesNo[arSYesNo.find(sShowDescription,1)];
int bShowFrame = arNYesNo[arSYesNo.find(sShowFrame,1)];

// Positioning
int nOrientation = arSOrientation.find(sOrientation,0);
int nSideDimensionLine = arSSide.find(sSideDimensionLine);
int bDimlinePerOpening = arNYesNo[arSYesNo.find(sDimLinePerOpening,0)];
int nPositionReference = arSPositionReference.find(sPositionReference,0);
int bUsePSUnits = arNYesNo[arSYesNo.find(sUsePSUnits,1)];
double dOffsetDim = dDimLineOffset;
if( bUsePSUnits )
	dOffsetDim *= dVpScale;
double dOffsetText = dTextOffset;
if( bUsePSUnits )
	dOffsetText *= dVpScale;

// Style
int nDimLayoutDelta = nArDimLayoutDelta[sArDimLayout.find(sDimLayout,0)];
int nDimLayoutCum = nArDimLayoutCum[sArDimLayout.find(sDimLayout,0)];
int nDeltaOnTop = arNDeltaOnTop[arSDeltaOnTop.find(sDeltaOnTop,0)];
int nDimensionSide = nArDimensionSide[sArDimensionSide.find(sDimensionSide,0)];

// reference
int nReferenceType = arSReferenceType.find(sReferenceType,0);
int sideClosestRafter = sides[sidesClosestRafter.find(sideClosetsRafterProp,1)];

String sFBCRef = sFilterBCReference+ ";";
sFBCRef.makeUpper();
String arSExcludeBCRef[0];
int nIndexBCRef = 0; 
int sIndexBCRef = 0;
while(sIndexBCRef < sFBCRef.length()-1){
	String sTokenBCRef = sFBCRef.token(nIndexBCRef);
	nIndexBCRef++;
	if(sTokenBCRef.length()==0){
		sIndexBCRef++;
		continue;
	}
	sIndexBCRef = sFBCRef.find(sTokenBCRef,0);
	sTokenBCRef.trimLeft();
	sTokenBCRef.trimRight();
	arSExcludeBCRef.append(sTokenBCRef);
}

int nReferenceSide = arNReferenceSide[arSReferenceSide.find(sReferenceSide,1)];


Vector3d vxms = _XW;
vxms.transformBy(ps2ms);
vxms.normalize();
Vector3d vyms = _YW;
vyms.transformBy(ps2ms);
vyms.normalize();
Vector3d vzms = _ZW;
vzms.transformBy(ps2ms);
vzms.normalize();

Line lnXms(ptEl, vxms);
Line lnYms(ptEl, vyms);

Entity arEntTslPS[] = Group().collectEntities(true, TslInst(), _kMySpace);
TslInst tslSection;
for( int i=0;i<arEntTslPS.length();i++ ){
	TslInst tsl = (TslInst)arEntTslPS[i];
	
	Map mapTsl = tsl.map();
	String vpHandle = mapTsl.getString("VPHANDLE");
	
	if( tsl.scriptName() == sSectionName && vpHandle == vp.viewData().viewHandle() ){
		tslSection = tsl;
		break;
	}
}

GenBeam arGBmAll[0];
if( !tslSection.bIsValid() )
	arGBmAll = el.genBeam(); // collect all
else{
	_Entity.append(tslSection);
	setDependencyOnEntity(tslSection);
	
	Map mapTsl = tslSection.map();
	for( int i=0;i<mapTsl.length();i++ ){
		if( mapTsl.keyAt(i) == "GENBEAM" ){
			Entity entGBm = mapTsl.getEntity(i);
			GenBeam gBm = (GenBeam)entGBm;
			arGBmAll.append(gBm);
		}
	}
}

if( arGBmAll.length() == 0 )
	return;

int arNTypeRafter[] = {
	_kRafter,
	_kDakCenterJoist,
	_kDakRightEdge,
	_kDakLeftEdge
};

GenBeam arGBm[0];
Beam arBm[0];
Beam arBmNotVertical[0];
GenBeam arGBmDim[0];

Sheet arSh[0];
Sheet arShZn08[0];
Point3d arPtGBm[0];

GenBeam arGBmRef[0];
Point3d arPtGBmRef[0];

Beam closestRafterLeft, closestRafterRight;

Beam arBmRafter[0];
Beam arBmReference[0];
for( int i=0;i<arGBmAll.length();i++ ){
	GenBeam gBm = arGBmAll[i];
	
	int bExcludeGenBeam = false;
	
	//Exclude dummies
	if( gBm.bIsDummy() )
		continue;
	
	//Exlude zones
	int nZnIndex = gBm.myZoneIndex();
	if( arNFilterZone.find(nZnIndex) != -1 )
		continue;
	
	//Exclude labels
	String sLabel = gBm.label().makeUpper();
	sLabel.trimLeft();
	sLabel.trimRight();
	if( arSExcludeLbl.find(sLabel)!= -1 ){
		bExcludeGenBeam = true;
	}
	else{
		for( int j=0;j<arSExcludeLbl.length();j++ ){
			String sExclLbl = arSExcludeLbl[j];
			String sExclLblTrimmed = sExclLbl;
			sExclLblTrimmed.trimLeft("*");
			sExclLblTrimmed.trimRight("*");
			if( sExclLblTrimmed == "" )
				continue;
			if( sExclLbl.left(1) == "*" && sExclLbl.right(1) == "*" && sLabel.find(sExclLblTrimmed, 0) != -1 )
				bExcludeGenBeam = true;
			else if( sExclLbl.left(1) == "*" && sLabel.right(sExclLbl.length() - 1) == sExclLblTrimmed )
				bExcludeGenBeam = true;
			else if( sExclLbl.right(1) == "*" && sLabel.left(sExclLbl.length() - 1) == sExclLblTrimmed )
				bExcludeGenBeam = true;
		}
	}
	if( bExcludeGenBeam )
		continue;
	
	//Exclude material
	String sMaterial = gBm.material().makeUpper();
	sMaterial.trimLeft();
	sMaterial.trimRight();
	if( arSExcludeMat.find(sMaterial)!= -1 ){
		bExcludeGenBeam = true;
	}
	else{
		for( int j=0;j<arSExcludeMat.length();j++ ){
			String sExclMat = arSExcludeMat[j];
			String sExclMatTrimmed = sExclMat;
			sExclMatTrimmed.trimLeft("*");
			sExclMatTrimmed.trimRight("*");
			if( sExclMatTrimmed == "" )
				continue;
			if( sExclMat.left(1) == "*" && sExclMat.right(1) == "*" && sMaterial.find(sExclMatTrimmed, 0) != -1 )
				bExcludeGenBeam = true;
			else if( sExclMat.left(1) == "*" && sMaterial.right(sExclMat.length() - 1) == sExclMatTrimmed )
				bExcludeGenBeam = true;
			else if( sExclMat.right(1) == "*" && sMaterial.left(sExclMat.length() - 1) == sExclMatTrimmed )
				bExcludeGenBeam = true;
		}
	}
	if( bExcludeGenBeam )
		continue;

	//Exclude hsbId
	String sHsbId = gBm.hsbId().makeUpper();
	sHsbId.trimLeft();
	sHsbId.trimRight();
	if( arSExcludeHsbId.find(sHsbId)!= -1 ){
		bExcludeGenBeam = true;
	}
	else{
		for( int j=0;j<arSExcludeHsbId.length();j++ ){
			String sExclHsbId = arSExcludeHsbId[j];
			String sExclHsbIdTrimmed = sExclHsbId;
			sExclHsbIdTrimmed.trimLeft("*");
			sExclHsbIdTrimmed.trimRight("*");
			if( sExclHsbIdTrimmed == "" )
				continue;
			if( sExclHsbId.left(1) == "*" && sExclHsbId.right(1) == "*" && sHsbId.find(sExclHsbIdTrimmed, 0) != -1 )
				bExcludeGenBeam = true;
			else if( sExclHsbId.left(1) == "*" && sHsbId.right(sExclHsbId.length() - 1) == sExclHsbIdTrimmed )
				bExcludeGenBeam = true;
			else if( sExclHsbId.right(1) == "*" && sHsbId.left(sExclHsbId.length() - 1) == sExclHsbIdTrimmed )
				bExcludeGenBeam = true;
		}
	}
	if( bExcludeGenBeam )
		continue;

	
	//Exclude beamcodes
	String sBmCode = gBm.beamCode().token(0).makeUpper();
	sBmCode.trimLeft();
	sBmCode.trimRight();
	
	if( arSExcludeBC.find(sBmCode)!= -1 ){
		bExcludeGenBeam = true;
	}
	else{
		for( int j=0;j<arSExcludeBC.length();j++ ){
			String sExclBC = arSExcludeBC[j];
			String sExclBCTrimmed = sExclBC;
			sExclBCTrimmed.trimLeft("*");
			sExclBCTrimmed.trimRight("*");
			if( sExclBCTrimmed == "" )
				continue;
			if( sExclBC.left(1) == "*" && sExclBC.right(1) == "*" && sBmCode.find(sExclBCTrimmed, 0) != -1 )
				bExcludeGenBeam = true;
			else if( sExclBC.left(1) == "*" && sBmCode.right(sExclBC.length() - 1) == sExclBCTrimmed )
				bExcludeGenBeam = true;
			else if( sExclBC.right(1) == "*" && sBmCode.left(sExclBC.length() - 1) == sExclBCTrimmed )
				bExcludeGenBeam = true;
		}
	}
	if( bExcludeGenBeam )
		continue;

	Beam bm = (Beam)gBm;
	Sheet sh = (Sheet)gBm;
	
	arGBm.append(gBm);
	Body bdGBm = gBm.envelopeBody(false, true);
	Point3d arPtThisGBm[] = bdGBm.allVertices();
	arPtGBm.append(arPtThisGBm);
	
	int bExcludeGenBeamAsReference = false;
	if( arSExcludeBCRef.find(sBmCode)!= -1 ){
		bExcludeGenBeamAsReference = true;
	}
	else{
		for( int j=0;j<arSExcludeBCRef.length();j++ ){
			String sExclBC = arSExcludeBCRef[j];
			String sExclBCTrimmed = sExclBC;
			sExclBCTrimmed.trimLeft("*");
			sExclBCTrimmed.trimRight("*");
			if( sExclBCTrimmed == "" )
				continue;
			if( sExclBC.left(1) == "*" && sExclBC.right(1) == "*" && sBmCode.find(sExclBCTrimmed, 0) != -1 )
				bExcludeGenBeamAsReference = true;
			else if( sExclBC.left(1) == "*" && sBmCode.right(sExclBC.length() - 1) == sExclBCTrimmed )
				bExcludeGenBeamAsReference = true;
			else if( sExclBC.right(1) == "*" && sBmCode.left(sExclBC.length() - 1) == sExclBCTrimmed )
				bExcludeGenBeamAsReference = true;
		}
	}
	
	if( sh.bIsValid() ){
		arSh.append(sh);
		if( bExcludeGenBeamAsReference )
			continue;
	}
	else if( bm.bIsValid() ){
		int nType = bm.type();
		arBm.append(bm);
		
		if (abs(bm.vecX().dotProduct(vxEl)) > dEps)
			arBmNotVertical.append(bm);
		
		if( bExcludeGenBeamAsReference )
			continue;
				
		if( nReferenceType == 1 && sReferenceBeamCode == sBmCode ){
			arBmReference.append(bm);
			arPtGBmRef.append(arPtThisGBm);
		}
		else if( (nReferenceType == 3 || nReferenceType == 4) && arNTypeRafter.find(nType) != -1 ){
			arBmReference.append(bm);
			arPtGBmRef.append(arPtThisGBm);
		}
	}

	if( nReferenceType == 2 && nZnIndex == nReferenceZone ){
		arGBmRef.append(gBm);
		arPtGBmRef.append(arPtThisGBm);
	}
}

if( arPtGBm.length() == 0 )
	return;

Point3d arPtGBmX[] = lnXms.orderPoints(arPtGBm);
Point3d arPtGBmY[] = lnYms.orderPoints(arPtGBm);
Point3d ptL = arPtGBmX[0];
Point3d ptR = arPtGBmX[arPtGBmX.length() - 1];
Point3d ptB = arPtGBmY[0];
Point3d ptT = arPtGBmY[arPtGBmY.length() - 1];
ptL += vyms * vyms.dotProduct((ptB + ptT)/2 - ptL);
ptR += vyms * vyms.dotProduct(ptL - ptR);
ptB += vxms * vxms.dotProduct((ptL + ptR)/2 - ptB);
ptT += vxms * vxms.dotProduct(ptB - ptT);
Point3d ptM = ptL + vxms * vxms.dotProduct(ptT - ptL);
Point3d ptBL = ptB + vxms * vxms.dotProduct(ptL - ptB);
Point3d ptBR = ptB + vxms * vxms.dotProduct(ptR - ptB);
Point3d ptTR = ptT + vxms * vxms.dotProduct(ptR - ptT);
Point3d ptTL = ptT + vxms * vxms.dotProduct(ptL - ptT);

// Origin and vectors used for dimension line. The element is used as default. It can be overriden per element.
Point3d ptDimLine = ptM;
if( nSideDimensionLine == 0 )
	ptDimLine = ptBL;
else if( nSideDimensionLine == 1 )
	ptDimLine = ptTR;
Vector3d vxDimLine = vxms;
Vector3d vyDimLine = vyms;
if( nOrientation == 1 ){
	vxDimLine = vyms;
	vyDimLine = -vxms;
}
Vector3d vOffset = -vyDimLine;
if( (nOrientation == 0 && nSideDimensionLine > 0) || (nOrientation == 1 && nSideDimensionLine != 1) )
	vOffset *= -1;

// Find the reference points. 
// If the reference is set to rafters, the orientation is set to horizontal and a dimline per opening is required, 
// than the reference points are recalculated per opening.
Point3d arPtRef[0];

Point3d arPtReferenceX[] = lnXms.orderPoints(arPtGBmRef);
Point3d arPtReferenceY[] = lnYms.orderPoints(arPtGBmRef);
Point3d arPtReference[0];
if( nOrientation == 0 )
	arPtReference.append(arPtReferenceX);
else
	arPtReference.append(arPtReferenceY);

if( arPtReference.length() > 0 ){
	if( nReferenceSide == _kLeft || nReferenceSide == _kLeftAndRight )
		arPtRef.append(arPtReference[0]);
	if( nReferenceSide == _kRight || nReferenceSide == _kLeftAndRight )
		arPtRef.append(arPtReference[arPtReference.length() - 1]);
}
Point3d arPtDim[0];
for( int i=0;i<arSOpDescription.length();i++ )
{
	String sOpDescription = arSOpDescription[i];
	sOpDescription.makeUpper();
	
	if (arSFOpening.length() > 0)
	{
		int openingIsMatch = false;
		for ( int j = 0; j < arSFOpening.length(); j++) 
		{
			String sFOpening = arSFOpening[j];
			sFOpening.makeUpper();
			if ( sFOpening.left(1) == "*" ) 
			{
				sFOpening.trimLeft("*");
				if ( sFOpening.right(1) == "*" ) 
				{
					sFOpening.trimRight("*");
					if ( sOpDescription.find(sFOpening, 0) != -1 ) 
					{
						openingIsMatch = true;
						break;
					}
				}
				else 
				{
					if ( sOpDescription.right(sFOpening.length()) == sFOpening ) 
					{
						openingIsMatch = true;
						break;
					}
				}
			}
			else if ( sFOpening.right(1) == "*" ) 
			{
				sFOpening.trimRight("*");
				if ( sOpDescription.find(sFOpening, 0) == 0 ) 
				{
					openingIsMatch = true;
					break;
				}
			}
			else 
			{
				if ( sOpDescription == sFOpening ) 
				{
					openingIsMatch = true;
					break;
				}
			}
		}
				
		if ( (openingIsMatch && !includeOpenings) || (!openingIsMatch && includeOpenings)) continue;
	}
	PLine plOpRf = arPlOp[i];
	Point3d ptOpRf = arPtOp[i];
	
	double frameHeight = el.zone(0).dH();
	ptOpRf += vzEl * vzEl.dotProduct(ptEl - vzEl * .5 * frameHeight - ptOpRf);
	Plane pnX(ptOpRf, vxEl);
	Beam arBmBottom[] = Beam().filterBeamsHalfLineIntersectSort(arBmNotVertical, ptOpRf, -vyEl);
	arBmBottom.append(Beam().filterBeamsHalfLineIntersectSort(arBmNotVertical, ptOpRf + vzEl * 0.4 * frameHeight, -vyEl));
	arBmBottom.append(Beam().filterBeamsHalfLineIntersectSort(arBmNotVertical, ptOpRf - vzEl * 0.4 * frameHeight, -vyEl));
	for(int s1=1;s1<arBmBottom.length();s1++){
		int s11 = s1;
		for(int s2=s1-1;s2>=0;s2--)
		{
			Beam bm11 = arBmBottom[s11];
			Point3d p11 = Line(bm11.ptCen(), bm11.vecX()).intersect(pnX, U(0));
			double d11 = abs(vyEl.dotProduct(p11 - ptOpRf));
			
			Beam bm2 = arBmBottom[s2];
			Point3d p2 = Line(bm2.ptCen(), bm2.vecX()).intersect(pnX, U(0));
			double d2 = abs(vyEl.dotProduct(p2 - ptOpRf));
			
			if( d11 < d2 ){
				arBmBottom.swap(s2, s11);					
				s11=s2;
			}
		}
	}
	
	Beam arBmTop[] = Beam().filterBeamsHalfLineIntersectSort(arBmNotVertical, ptOpRf, vyEl);
	arBmTop.append(Beam().filterBeamsHalfLineIntersectSort(arBmNotVertical, ptOpRf + vzEl * 0.4 * frameHeight, vyEl));
	arBmTop.append(Beam().filterBeamsHalfLineIntersectSort(arBmNotVertical, ptOpRf - vzEl * 0.4 * frameHeight, vyEl));	
	for(int s1=1;s1<arBmTop.length();s1++){
		int s11 = s1;
		for(int s2=s1-1;s2>=0;s2--)
		{
			Beam bm11 = arBmTop[s11];
			Point3d p11 = Line(bm11.ptCen(), bm11.vecX()).intersect(pnX, U(0));
			double d11 = abs(vyEl.dotProduct(p11 - ptOpRf));
			
			Beam bm2 = arBmTop[s2];
			Point3d p2 = Line(bm2.ptCen(), bm2.vecX()).intersect(pnX, U(0));
			double d2 = abs(vyEl.dotProduct(p2 - ptOpRf));
			
			if( d11 < d2 ){
				arBmTop.swap(s2, s11);					
				s11=s2;
			}
		}
	}
	
	Beam arBmLeft[] = Beam().filterBeamsHalfLineIntersectSort(arBm, ptOpRf, -vxEl);
	Beam arBmRight[] = Beam().filterBeamsHalfLineIntersectSort(arBm, ptOpRf, vxEl);
	
	Beam bmBottom;
	Point3d ptBottom = ptB;
	if (arBmBottom.length() > 0) {
		bmBottom = arBmBottom[0];
		
		Body b = bmBottom.realBody();
		b.transformBy(ms2ps);
		b.vis();
		Point3d p = el.zone(-1).ptOrg();
		p.transformBy(ms2ps);
		p.vis();
		
		Point3d arPtBm[] = bmBottom.realBody().extractContactFaceInPlane(Plane(el.zone(-1).ptOrg(), vzEl), U(100)).getGripVertexPoints();
		if( arPtBm.length() == 0 ){
			arPtBm = bmBottom.realBody().allVertices();//.getSlice(Plane(el.zone(-1).ptOrg() + vzEl * U(50), vzEl)).getGripVertexPoints();
			arPtBm = lnZEl.orderPoints(arPtBm);
		}
		arPtBm = lnYEl.orderPoints(arPtBm);
		if( arPtBm.length() > 0 )
			ptBottom = arPtBm[arPtBm.length() - 1];
	}
	
	Beam bmTop;
	Point3d ptTop = ptT;
	if (arBmTop.length() > 0) {
		bmTop = arBmTop[0];
			
		Point3d arPtBm[] = bmTop.realBody().extractContactFaceInPlane(Plane(el.zone(-1).ptOrg(), vzEl), U(100)).getGripVertexPoints();
		if( arPtBm.length() == 0 ){
			arPtBm = bmTop.realBody().allVertices();
			arPtBm = lnZEl.orderPoints(arPtBm);
		}
		arPtBm = lnYEl.orderPoints(arPtBm);
		if( arPtBm.length() > 0 )
			ptTop = arPtBm[0];
	}
		
	Beam bmLeft;
	Point3d ptLeft = ptL;
	if (arBmLeft.length() > 0) {
		bmLeft = arBmLeft[0];
			
		Point3d arPtBm[] = bmLeft.realBody().extractContactFaceInPlane(Plane(el.zone(-1).ptOrg(), vzEl), U(100)).getGripVertexPoints();
		if( arPtBm.length() == 0 ){
			arPtBm = bmLeft.realBody().allVertices();
			arPtBm = lnZEl.orderPoints(arPtBm);
		}
		arPtBm = lnXEl.orderPoints(arPtBm);
		if( arPtBm.length() > 0 )
			ptLeft = arPtBm[arPtBm.length() - 1];
	}
	
	Beam bmRight;
	Point3d ptRight = ptR;
	if (arBmRight.length() > 0) {
		bmRight = arBmRight[0];
			
		Point3d arPtBm[] = bmRight.realBody().extractContactFaceInPlane(Plane(el.zone(-1).ptOrg(), vzEl), U(100)).getGripVertexPoints();
		if( arPtBm.length() == 0 ){
			arPtBm = bmRight.realBody().allVertices();
			arPtBm = lnZEl.orderPoints(arPtBm);
		}
		arPtBm = lnXEl.orderPoints(arPtBm);
		if( arPtBm.length() > 0 )
			ptRight = arPtBm[0];
	}
	
	Point3d ptRefps = ptOpRf;
	ptRefps.transformBy(ms2ps);
	Point3d ptBps = ptBottom;
	ptBps.transformBy(ms2ps);
	Point3d ptTps = ptTop;
	ptTps.transformBy(ms2ps);
	Point3d ptLps = ptLeft;
	ptLps.transformBy(ms2ps);
	Point3d ptRps = ptRight;
	ptRps.transformBy(ms2ps);

	ptRefps.vis();
	ptBps.vis();
	ptTps.vis();
	ptLps.vis();
	ptRps.vis();

	Point3d ptOpTL = ptLeft + vyEl * vyEl.dotProduct(ptTop - ptLeft);
	Point3d ptOpBL = ptLeft + vyEl * vyEl.dotProduct(ptBottom - ptLeft);
	Point3d ptOpBR = ptRight + vyEl * vyEl.dotProduct(ptBottom - ptRight);
	Point3d ptOpTR = ptRight + vyEl * vyEl.dotProduct(ptTop - ptRight);
	Point3d ptOpMid = (ptOpTL + ptOpBL + ptOpBR + ptOpTR)/4;
	Point3d ptOpTLF= ptOpTL+vzEl*vzEl.dotProduct(ptEl-ptOpTL);
	Point3d ptOpBRF= ptOpBR+vzEl*vzEl.dotProduct(ptEl-ptOpBR);
	
	Point3d arPtDimThisOpening[0];
	if( nDimensionType == 0 ){ // Opening size.
		if( nDimensionSide == _kLeft || nDimensionSide == _kLeftAndRight )
			arPtDimThisOpening.append(ptOpBL);
		if( nDimensionSide == _kRight || nDimensionSide == _kLeftAndRight )
			arPtDimThisOpening.append(ptOpTR);
		if( nDimensionSide == _kCenter )
			arPtDimThisOpening.append(ptOpMid);
		
		if( bDimlinePerOpening ){
			// The rafters are set as reference, only recalculate them if the orientation is horizontal. 
			// In that case, the closest rafetrs for this opening are used as reference.
			if( nReferenceType == 4 && ((nOrientation == 0 && !raftersAreHorizontal) || (nOrientation == 1 && raftersAreHorizontal))){
				arPtRef.setLength(0);
				if( nReferenceSide == _kLeft || nReferenceSide == _kLeftAndRight ){
					Beam arBmReferenceLeft[] = Beam().filterBeamsHalfLineIntersectSort(arBmReference, ptOpRf, -vxEl);
					if( arBmReferenceLeft.length() > 0 ) 
						arPtRef.append(arBmReferenceLeft[0].ptCen() - vxEl * sideClosestRafter * 0.5 * arBmReferenceLeft[0].dD(vxEl));
				}
				if( nReferenceSide == _kRight || nReferenceSide == _kLeftAndRight ){
					Beam arBmReferenceRight[] = Beam().filterBeamsHalfLineIntersectSort(arBmReference, ptOpRf, vxEl);
					if( arBmReferenceRight.length() > 0 )
						arPtRef.append(arBmReferenceRight[0].ptCen() + vxEl * sideClosestRafter * 0.5 * arBmReferenceRight[0].dD(vxEl));
				}
			}
			Point3d arPtToDim[0];
			arPtToDim.append(arPtRef);
			arPtToDim.append(arPtDimThisOpening);
			
			if( nPositionReference == 0 ){ // Use opening as reference
				ptDimLine = ptOpMid;
				if( nSideDimensionLine == 0 )
					ptDimLine = ptOpBL;
				else if( nSideDimensionLine == 1 )
					ptDimLine = ptOpTR;
			}
			
			if( arPtToDim.length() > 1 ){
				DimLine dimLine(ptDimLine + vOffset * dOffsetDim, vxDimLine, vyDimLine);
				Dim dim(dimLine, arPtToDim, "<>", "<>", nDimLayoutDelta,nDimLayoutCum);
				dim.setDeltaOnTop(nDeltaOnTop);
				dim.transformBy(ms2ps);
				dim.setReadDirection(-_XW + _YW);
				dpDim.draw(dim);
			}
		}
		else{
			arPtDim.append(arPtDimThisOpening);
		}
	}
	else if( nDimensionType == 2 ){ // Rafters above opening.
		reportMessage(TN("|Dimension of rafter above opening is not implemented yet.|"));
	}
	else if( nDimensionType == 1 ){ // Cross.

		dpFront.color(nDimColor);
		dpSide.color(nDimColor);
		dpTop.color(nDimColor);
		
		PLine pl;
		pl=PLine(ptOpTL, ptOpBR);
		pl.transformBy(ms2ps);
		dpFront.draw(pl);
		pl=PLine(ptOpTR, ptOpBL);
		pl.transformBy(ms2ps);
		dpFront.draw(pl);

		pl=PLine(ptOpTLF, ptOpBL);
		pl.transformBy(ms2ps);
		dpSide.draw(pl);
		pl=PLine(ptOpTL, ptOpBRF);
		pl.transformBy(ms2ps);
		dpSide.draw(pl);

		pl=PLine(ptOpTLF, ptOpBR);
		pl.transformBy(ms2ps);
		dpTop.draw(pl);
		pl=PLine(ptOpTL, ptOpBRF);
		pl.transformBy(ms2ps);
		dpTop.draw(pl);
	}

	if( bShowDescription ){
		Point3d ptOpDescription = ptOpMid - vyms * dOffsetDim;
		ptOpDescription.transformBy(ms2ps);
		
		String sOpDescriptionA = sOpDescription.token(0, sNewLineChar);
		String sOpDescriptionB = sOpDescription.token(1, sNewLineChar);
		String sOpDescriptionC = sOpDescription.token(2, sNewLineChar);
		if( sOpDescriptionB.length() > 0 || sOpDescriptionC.length() > 0 ){
			dpDescription.draw(sOpDescriptionA, ptOpDescription, _XW, _YW, 0, 2);
			dpDescription.draw(sOpDescriptionB, ptOpDescription, _XW, _YW, 0, -1);
			dpDescription.draw(sOpDescriptionC, ptOpDescription, _XW, _YW, 0, -4);
		}
		else{
			dpDescription.draw(sOpDescription, ptOpDescription, _XW, _YW, 0, 0);
		}
	}
	
	if(bShowFrame)
	{
		dpFront.color(nFrameColor);
		dpSide.color(nFrameColor);
		dpTop.color(nFrameColor);
		
		PLine pl;
		pl=PLine(ptOpTR, ptOpTLF);
		pl.transformBy(ms2ps);
		dpFront.draw(pl);
		pl=PLine(ptOpTLF, ptOpBL);
		pl.transformBy(ms2ps);
		dpFront.draw(pl);
		pl=PLine(ptOpBL, ptOpBRF);
		pl.transformBy(ms2ps);
		dpFront.draw(pl);
		pl=PLine(ptOpBRF,ptOpTR);
		pl.transformBy(ms2ps);
		dpFront.draw(pl);

		pl=PLine(ptOpTR, ptOpTLF);
		pl.transformBy(ms2ps);
		dpSide.draw(pl);
		pl=PLine(ptOpTLF,ptOpBRF);
		pl.transformBy(ms2ps);
		dpSide.draw(pl);
		pl=PLine(ptOpBRF, ptOpBL);
		pl.transformBy(ms2ps);
		dpSide.draw(pl);
		pl=PLine(ptOpBL, ptOpTR);
		pl.transformBy(ms2ps);
		dpSide.draw(pl);

		pl=PLine(ptOpTR, ptOpTL);
		pl.transformBy(ms2ps);
		dpTop.draw(pl);
		pl=PLine(ptOpTL, ptOpTLF);
		pl.transformBy(ms2ps);
		dpTop.draw(pl);
		pl=PLine(ptOpTLF, ptOpBRF);
		pl.transformBy(ms2ps);
		dpTop.draw(pl);
		pl=PLine(ptOpBRF, ptOpTR);
		pl.transformBy(ms2ps);
		dpTop.draw(pl);
	}
}

// Do we have to create one dimline for all openings?
if( !bDimlinePerOpening ){
	Point3d arPtToDim[0];
	arPtToDim.append(arPtRef);
	arPtToDim.append(arPtDim);
	
	if( arPtToDim.length() < 2 )
		return;
	
	if( arPtDim.length() > 1 ){
		DimLine dimLine(ptDimLine + vOffset * dOffsetDim, vxDimLine, vyDimLine);
		Dim dim(dimLine, arPtToDim, "<>", "<>", nDimLayoutDelta,nDimLayoutCum);
		dim.setDeltaOnTop(nDeltaOnTop);
		dim.transformBy(ms2ps);
		dim.setReadDirection(-_XW + _YW);
		dpDim.draw(dim);
	}
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
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Switch to reportmessage instead of reportnotice" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="3/4/2021 1:58:04 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End