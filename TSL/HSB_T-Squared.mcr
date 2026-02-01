#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
04.03.2015  -  version 1.00


















#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 0
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl integrates the beams in the connecting beams.
/// </summary>

/// <insert>
/// 
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="2.09" date="10.07.2014"></version>

/// <history>
/// AS - 1.00 - 04.03.2015 -	Pilot version.
/// </history>

PropDouble dMaxDepth(0, U(10), T("|Maximum depth|"));

Vector3d vxF = _X1;
if (vxF.dotProduct(_X0) < 0)
	vxF *= -1;

Vector3d vyM = _Beam0.vecD(vxF);

double dAngle = _X0.angleTo(_Z1);

Point3d ptStretch = _Pt0 + _X0 * 0.5 * _Beam0.dD(vyM) * tan(dAngle) - vyM * 0.5 * _Beam0.dD(vyM);
ptStretch.vis(1);

if (_Z1.dotProduct(ptStretch - (_Pt0 + _Z1 * dMaxDepth)) > 0) {
	ptStretch = Line(ptStretch, _X0).intersect(Plane(_Pt0 + _Z1 * dMaxDepth, _Z1), 0);
}
ptStretch.vis(3);

Cut cut(ptStretch, _X0);
_Beam0.addTool(cut, _kStretchOnToolChange);

BeamCut bmCut(ptStretch, _X0, vyM, _X0.crossProduct(vyM), U(500), U(500), U(500), -1, 1, 0);
_Beam1.addTool(bmCut);

Element el = _Beam0.element();
Beam arBm[0];
if( el.bIsValid() )
	assignToElementGroup(el, true, 0, 'T');

//Visualization
PLine plCross(_X0);
plCross.addVertex(_Pt0 + _Y0 * U(50));
plCross.addVertex(_Pt0 - _Y0 * U(50));
plCross.addVertex(_Pt0);
plCross.addVertex(_Pt0 + _Z0 * U(80));
plCross.addVertex(_Pt0 - _Z0 * U(80));

PLine plCircle(_X0);
plCircle.createCircle(_Pt0, _X0, U(20));

Display dpSymbol(3);
dpSymbol.draw(plCross);
dpSymbol.draw(plCircle);














#End
#BeginThumbnail

#End