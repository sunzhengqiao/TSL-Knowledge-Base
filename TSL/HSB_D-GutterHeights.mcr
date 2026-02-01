#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
22.12.2014  -  version 1.03

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl shows the gutter heights.
/// </summary>

/// <insert>
/// Select a viewport and a position
/// </insert>

/// <remark Lang=en>
/// Only shows the height of sheets with a SubMap: "Rotation".
/// </remark>

/// <version  value="1.03" date="22.12.2014"></version>

/// <history>
/// AS - 1.00 - 16.10.2014 	- Pilot version
/// AS - 1.01 - 29.10.2014 	- Add sublabel for manual rotated sheets
/// AS - 1.02 - 29.10.2014 	- Bugfix conditional check on sheets. Correct text position
/// AS - 1.03 - 22.12.2014 	- Correct text orientation
/// </history>


PropString sSeperator00(0, "", T("|Gutter dimension|"));
sSeperator00.setReadOnly(true);
PropString sPrefix(1, "Gooth = ", "     "+T("|Prefix|"));
PropDouble dOffset(0, U(10), "     "+T("|Offset|"));
PropString sManualRotation(4, "Helling", "     "+T("|Sublabel manual rotated sheets|"));

PropString sSeperator01(2, "", T("|Style|"));
sSeperator01.setReadOnly(true);
PropString sDimStyle(3,_DimStyles, "     "+T("Dimension style"));


if( _bOnInsert ){
	_Viewport.append(getViewport(T("Select a viewport")));
	_Pt0 = getPoint(T("Select a point"));
	showDialog();
	return;
}

Display dp(1);
dp.textHeight(U(10));
dp.draw(scriptName(), _Pt0, _XW, _YW, 1, 1);
dp.dimStyle(sDimStyle);

if( _Viewport.length() == 0 ){eraseInstance(); return; }

Viewport vp = _Viewport[0];

// check if the viewport has hsb data
if (!vp.element().bIsValid()) return;
CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps; ps2ms.invert();

Element el = vp.element();
CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

Line lnElZ(ptEl, vzEl);

Sheet arSh[] = el.sheet();
for (int i=0;i<arSh.length();i++) {
	Sheet sh = arSh[i];
	String s = sh.subLabel();
	if (sh.subMapKeys().find("Rotation") == -1 && (sManualRotation != "" && sh.subLabel() != sManualRotation))
		continue;
	
	// Start and end heights for this sheet.
	PlaneProfile ppSh = sh.profShape();
	ppSh.shrink(-U(2));
	
	Point3d arPtShProfile[] = ppSh.getGripVertexPoints();
	arPtShProfile = lnElZ.orderPoints(arPtShProfile);

	Vector3d vxSh = sh.vecX();	
	Vector3d vySh = sh.vecY();
	if (sh.solidLength() < sh.solidWidth()) {
		vxSh = sh.vecY();
		vySh = sh.vecX();
	}
	
	Vector3d vOffset = vxSh;
	vOffset.transformBy(ms2ps);
	vOffset.normalize();
	
	if (arPtShProfile.length() > 0) {
		Point3d ptStartHeight = arPtShProfile[arPtShProfile.length() - 1];
		ptStartHeight += vySh * vySh.dotProduct(sh.ptCen() - ptStartHeight);
		Point3d ptEndHeight = arPtShProfile[0];
		ptEndHeight += vySh * vySh.dotProduct(sh.ptCen() - ptEndHeight);
		double dStartHeight = vzEl.dotProduct(ptStartHeight  - ptEl);
		double dEndHeight = vzEl.dotProduct(ptEndHeight - ptEl);
		
		ptStartHeight.transformBy(ms2ps);
		double dFlagAwayFromCenter = 1;
		Point3d ptShPS = sh.ptCen(); 
		ptShPS.transformBy(ms2ps);
		if (vOffset.dotProduct(ptStartHeight - ptShPS) < 0)
			dFlagAwayFromCenter *= -1;
		ptStartHeight.vis();
		
		Vector3d vxTxt = vySh;
		vxTxt.transformBy(ms2ps);
		vxTxt.normalize();
		if (vxTxt.dotProduct(_XW + _YW) < 0)
			vxTxt *= -1;
		Vector3d vyTxt = _ZW.crossProduct(vxTxt);
		
		double dFlagY = 1;
		if (vyTxt.dotProduct(ptStartHeight - ptShPS) < 0)
			dFlagY *= -1;

		
		
		dp.draw(sPrefix + String().formatUnit(dStartHeight, 2, 0), ptStartHeight + vOffset * dOffset * dFlagAwayFromCenter, vxTxt, vyTxt, 0, dFlagY);
		ptEndHeight.transformBy(ms2ps);
		ptEndHeight.vis();
		dp.draw(sPrefix + String().formatUnit(dEndHeight, 2, 0), ptEndHeight - vOffset * dOffset * dFlagAwayFromCenter, vxTxt, vyTxt, 0, -dFlagY); 
	}
}

#End
#BeginThumbnail
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
(B@`HHHH`_]FB
`



#End