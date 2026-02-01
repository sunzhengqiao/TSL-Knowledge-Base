#Version 8
#BeginDescription

#End
#Type E
#NumBeamsReq 1
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 0
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
U(1,"mm"); // use mm
_X0.vis(_Pt0);
_Y0.vis(_Pt0);
_Z0.vis(_Pt0);
_Pt0.vis();
int nArIndex[] = {0, 1}; // currently only index 0 is supported
PropInt nIndex(0,nArIndex,T("Mill index"));
// define special mill tool

RevolutionMill sm(_Pt0,_Y0,_Z0,_X0);
sm.setToolIndex(nIndex);

_Beam0.addTool(sm);
// define additional cut

double dDistCut = 0;
Cut ct(_Pt0+_X0*dDistCut,_X0);
_Beam0.addTool(ct,1);

Display dp(-1);
Point3d ptDraw = _Pt0;

PLine pl1(_X0);
PLine pl2(_Y0);
PLine pl3(_Z0);
pl1.addVertex(ptDraw+_Y0*U(3));
pl1.addVertex(ptDraw-_Y0*U(3));
pl2.addVertex(ptDraw-_Z0*U(3));
pl2.addVertex(ptDraw+_Z0*U(3));
pl3.addVertex(ptDraw-_X0*U(3));
pl3.addVertex(ptDraw+_X0*U(3));

dp.draw(pl1);
dp.draw(pl2);
dp.draw(pl3);

#End
#BeginThumbnail

#End