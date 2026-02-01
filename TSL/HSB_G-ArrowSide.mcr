#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
01.06.2015  -  version 1.01




















#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl displays the arrow of a wall element
/// </summary>

/// <insert>
/// Select a viewport
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.01" date="01.06.2015"></version>

/// <history>
/// AS - 1.00 - 03.04.2014 -	Pilot version
/// AS - 1.01 - 01.06.2015 -	Arrow now also visible in side view (FogBugzId 1341).
///							Change thumbnail.
/// </history>

String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};

/// - Arrow -
///
PropString sSeparator01(0, "", T("|Arrow|"));
sSeparator01.setReadOnly(true);
PropDouble dArrowOffset(0, U(0), "     "+T("|Offset|"));
PropDouble dArrowSize(1, U(150), "     "+T("|Arrow size|"));
PropInt nArrowColor(0, 3, "     "+T("|Arrow color|"));


/// - Name and description -
/// 
PropString sSeparator02(1, "", T("|Name and description|"));
sSeparator02.setReadOnly(true);
PropInt nColorName(1, -1, "     "+T("|Default name color|"));
PropInt nColorActiveFilter(2, 30, "     "+T("|Filter other element color|"));
PropInt nColorActiveFilterThisElement(3, 1, "     "+T("|Filter this element color|"));
PropString sDimStyleName(2, _DimStyles, "     "+T("|Dimension style name|"));
PropString sInstanceDescription(3, "", "     "+T("|Extra description|"));
PropString sDisableTsl(4, arSYesNo, "     "+T("|Disable the tsl|"),1);
PropString sShowVpOutline(5, arSYesNo, "     "+T("|Show viewport outline|"),1);

if( _bOnInsert ){
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	showDialog();
	
	_Viewport.append(getViewport(T("Select a viewport")));
	_Pt0 = getPoint(T("Select a point"));
	
	return;
}

if( _Viewport.length() == 0 ){
	eraseInstance();
	return;
}
Viewport vp = _Viewport[0];

String arSTrigger[] = {
	T("|Filter this element|"),
	"     ----------",
	T("|Remove filter for this element|"),
	T("|Remove filter for all elements|")
};
for( int i=0;i<arSTrigger.length();i++ )
	addRecalcTrigger(_kContext, arSTrigger[i] );


// Draw name
String sInstanceNameAndDescription = _ThisInst.scriptName();
if( sInstanceDescription.length() > 0 )
	sInstanceNameAndDescription += (" - "+sInstanceDescription);

Display dpName(nColorName);
dpName.dimStyle(sDimStyleName);
dpName.draw(sInstanceNameAndDescription, _Pt0, _XW, _YW, 1, 2);

double dTextHeightName = dpName.textHeightForStyle("HSB", sDimStyleName);

// check if the viewport has hsb data
if (!vp.element().bIsValid())
	return;
CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps; ps2ms.invert();

Element el = vp.element();

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

int bShowVpOutline = arNYesNo[arSYesNo.find(sShowVpOutline,1)];
if( _Viewport.length() > 0 && (bShowVpOutline || _bOnDebug) ){
	Viewport vp = _Viewport[0];
	Display dpDebug(1);
	dpDebug.layer("DEFPOINTS");
	PLine plVp(_ZW);
	Point3d ptA = vp.ptCenPS() - _XW * 0.48 * vp.widthPS() - _YW * 0.48 * vp.heightPS();
	ptA.vis();
	Point3d ptB = vp.ptCenPS() + _XW * 0.48 * vp.widthPS() + _YW * 0.48 * vp.heightPS();
	plVp.createRectangle(LineSeg(ptA, ptB), _XW, _YW);
	dpDebug.draw(plVp);
}

int bDisableTsl = arNYesNo[arSYesNo.find(sDisableTsl,1)];
if( bDisableTsl ){
	dpName.color(nColorActiveFilterThisElement);
	dpName.draw(_ThisInst.scriptName(), _Pt0, _XW, _YW, 1, 2);
	dpName.textHeight(0.5 * dTextHeightName);
	dpName.draw(T("|Disbled|"), _Pt0, _XW, _YW, 1, 1);
	return;
}

Map mapFilterElements;
if( _Map.hasMap("FilterElements") )
	mapFilterElements = _Map.getMap("FilterElements");
if( mapFilterElements.length() > 0 ){
	if( mapFilterElements.hasString(el.handle()) ){
		dpName.color(nColorActiveFilterThisElement);
		dpName.draw(_ThisInst.scriptName(), _Pt0, _XW, _YW, 1, 2);
		dpName.textHeight(0.5 * dTextHeightName);
		dpName.draw(T("|Active filter|"), _Pt0, _XW, _YW, 1, 1);
		return;
	}
	else{
		dpName.color(nColorActiveFilter);
		dpName.draw(_ThisInst.scriptName(), _Pt0, _XW, _YW, 1, 2);
		dpName.textHeight(0.5 * dTextHeightName);
		dpName.draw(T("|Active filter|"), _Pt0, _XW, _YW, 1, 1);
	}
}

ElementWallSF elSFWall = (ElementWallSF)el;
if( !elSFWall.bIsValid() )
	return;

CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

Vector3d vxArrow = vzEl;
Vector3d vzArrow = _ZW;
vzArrow.transformBy(ps2ms);
vzArrow.normalize();
Vector3d vyArrow = vzArrow.crossProduct(vxArrow);

Vector3d vzElPs = vzEl;
vzElPs.transformBy(ms2ps);
vzElPs.normalize();
Display dp(nArrowColor);
dp.addHideDirection(vzElPs);
dp.addHideDirection(-vzElPs);

Point3d ptStartArrow = elSFWall.ptArrow() + vxArrow * dArrowOffset;
PLine plArrow(vyEl);
plArrow.addVertex(ptStartArrow);
plArrow.addVertex(ptStartArrow + vxArrow * 0.35 * dArrowSize - vyArrow * 0.25 * dArrowSize);
plArrow.addVertex(ptStartArrow + vxArrow * 0.35 * dArrowSize - vyArrow * 0.05 * dArrowSize);
plArrow.addVertex(ptStartArrow + vxArrow * dArrowSize - vyArrow * 0.05 * dArrowSize);
plArrow.addVertex(ptStartArrow + vxArrow * dArrowSize + vyArrow * 0.05 * dArrowSize);
plArrow.addVertex(ptStartArrow + vxArrow * 0.35 * dArrowSize + vyArrow * 0.05 * dArrowSize);
plArrow.addVertex(ptStartArrow + vxArrow * 0.35 * dArrowSize + vyArrow * 0.25 * dArrowSize);
plArrow.close();

plArrow.transformBy(ms2ps);
dp.draw(plArrow);





#End
#BeginThumbnail
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
"_]E@
`

#End