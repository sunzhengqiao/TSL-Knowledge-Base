#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@itwindustry.nl)
10.10.2012  -  version 2.2

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 2
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl adds a number per logcourse
/// </summary>

/// <insert>
///
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="2.02" date="10.10.2012"></version>

/// <history>
/// 1.00 - 23.01.2008 - 	Pilot version
/// 1.01 - 11.02.2008 - 	Erase implemented / Made the Scriptnames variables
/// 1.02 - 20.02.2008 - 	Adjust layout of table
/// 2.00 - 09.10.2012 - 	Add to Content-Dutch
/// 2.01 - 10.10.2012 - 	Add insertpoint. Scriptname is shown at this point.
/// 2.02 - 10.10.2012 - 	Add offset
/// </hsitory>

double dEps = Unit(0.01, "mm");

String arSPosition[] = {
	T("|Vertical left|"),
	T("|Vertical right|")
};
String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};


PropString sSeperator02(2, "", T("|Positioning|"));
sSeperator02.setReadOnly(true);
PropString sPosition(3, arSPosition, "     "+T("|Position|"));
PropString sUsePSUnits(4, arSYesNo, "     "+T("|Offset in paperspace units|"),1);
PropDouble dOffsetText(0, U(2), "     "+T("|Offset text|"));


PropString sSeperator01(0, "", T("|Style|"));
sSeperator01.setReadOnly(true);
PropString sDimStyle (1, _DimStyles, "     "+T("Dimension Style"));
PropInt nColorText(0, -1, "     "+T("|Color text|"));



if (_bOnInsert) {
	showDialog();
	
	_Pt0 = getPoint(T("|Select a position|"));
	_Viewport.append(getViewport(T("|Select a viewport|"))); // select viewport
	
	return;
}

if( _Viewport.length()==0 ){
	eraseInstance();
	return;
}

Display dpName(-1);
dpName.textHeight(U(5));
dpName.draw(_ThisInst.scriptName(), _Pt0, _XW, _YW, 1, 2);

Viewport vp = _Viewport[0];
Element el = vp.element();

CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps
double dVpScale = ps2ms.scale();

// check if the viewport has hsb data
if( !el.bIsValid() )
	return;

int nPosition = arSPosition.find(sPosition,0);
int bUsePSUnits = arNYesNo[arSYesNo.find(sUsePSUnits,1)];
double dTextOffset = dOffsetText;
if( bUsePSUnits )
	dTextOffset *= dVpScale;

CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

Vector3d vx = _XW;
Vector3d vy = _YW;
Vector3d vz = _ZW;
vx.transformBy(ps2ms);
vx.normalize();
vy.transformBy(ps2ms);
vy.normalize();
vz.transformBy(ps2ms);
vz.normalize();

Line lnX(ptEl, vx);
Line lnY(ptEl, vy);

Display dp(nColorText);
dp.dimStyle(sDimStyle, dVpScale);

ElementLog elLog = (ElementLog)el;

Point3d arPtEl[] = el.plOutlineWall().vertexPoints(true);
Point3d arPtElX[] = lnX.orderPoints(arPtEl);

if( arPtElX.length() == 0 )
	return;

Point3d ptLeft = arPtElX[0];
Point3d ptRight = arPtElX[arPtElX.length() - 1];
Point3d ptSide = ptLeft - vx * dTextOffset;
double dxFlag = -1;
if( nPosition == 1 ){
	ptSide = ptRight + vx * dTextOffset;
	dxFlag *= -1;
}

Point3d ptLC = _PtW + vx * vx.dotProduct(ptSide - _PtW);

LogCourse lcEl[] = elLog.logCourses();

for (int i=0; i<lcEl.length(); i++){
	double dHeightLC=lcEl[i].dYMin();
	Point3d ptTopCourse = ptLC + _ZW*(dHeightLC);
	ptTopCourse.transformBy(ms2ps);
	
	String sText = (i+1);
	dp.draw(sText ,ptTopCourse, _XW,_YW,dxFlag, 1);
}


#End
#BeginThumbnail
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
4`!1110`4444`%%%%`!1110!__]E%
`

#End
