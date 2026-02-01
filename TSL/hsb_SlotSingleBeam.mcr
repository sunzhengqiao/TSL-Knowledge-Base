#Version 8
#BeginDescription
Adds a slot tool to a beam

Last modified by: Alberto Jena (aj@hsb-cad.com)
Date: 01.01.2008  -  version 1.0



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
PropDouble dDepth1(0,100,"Depth");
PropDouble dThick1(1,20,"Thickness");
PropDouble dHeight1(2,50,"Height");

Slot sl1(_Pt0,_Z0,_Y0,-_X0, dHeight1,dThick1,dDepth1*2,0, 0,0) ;

_X0.vis(_Pt0, 1);
_Y0.vis(_Pt0, 2);
_Z0.vis(_Pt0, 3);

sl1.cuttingBody().vis();
_Beam0.addTool(sl1);

LineSeg ls (_Pt0, _Pt0-_X0*dDepth1);
Display dp(1);
dp.draw(ls);

#End
#BeginThumbnail


#End
