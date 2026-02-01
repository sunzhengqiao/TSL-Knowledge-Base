#Version 7
#BeginDescription
EN
   creates BMF-Column shoe ISB or ISB maxi,on a post
DE
   erzeugt Pfostenschuhe vom Typ ISB oder ISB maxi 
Version 1.1   2006-01-30   rh@hsb-cad.com

#End
#Type E
#NumBeamsReq 1
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 0
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
/*Author: Roberto Hallo, rh@hsb-cad.com
Date: 2006/Jan/26
Version: 1.0 initial version
Modified by Roberto Hallo, TSL Team, Quito, Ecuador.
Version No. 1.1 (Modified), 
Date: 2006/Jan/30
*/
U(1,"mm");

_X0.vis(_Pt0,1);
_Y0.vis(_Pt0,1);
_Z0.vis(_Pt0,1);
_Pt0.vis();

PropDouble dBaseHeigh (0,U(0),T("Base Height"));
String Fixing[]={T("Dowels"),T("Bolts")};
PropString strFixing (0, Fixing, T("Type of Fixing"),1);

//create arrays
double arSa[] = { 100, 100, 120};
double arSb[] = { 70, 70, 90};
double arSc[] = { 110, 110, 105};
double arSd[] = { 80, 80, 120};
double arSf[] = { 160, 260, 200};
double arSg[] = { 100, 100, 200};
double arSh[] = { 158, 158, 135};
double arSt1[] = {8,8,8};
double arSt2[] = { 10, 10, 15};
double arStd [] = {42,42,70};

String srtType[]={T("ISB-"+arSf[0]),T("ISB-"+arSf[1]),T("ISB-Maxi")};
PropString prStrType (1,srtType,T("Type"),1);

//Choose the correct size of shoe
int iIndex = 0;
if (prStrType == T("ISB-"+arSf[0]))
	iIndex = 0;
if (prStrType == T("ISB-"+arSf[1]))
	iIndex = 1;
if (prStrType == T("ISB-Maxi"))
	iIndex = 2;

// shoe dimensions
double dSa = U(arSa[iIndex]);
double dSb = U(arSb[iIndex]);
double dSc = U(arSc[iIndex]);
double dSd =U(arSd[iIndex]);
double dSf = U(arSf[iIndex]);
double dSg = U(arSg[iIndex]);
double dSh = U(arSh[iIndex]);
double dSt1 = U(arSt1[iIndex]);
double dSt2 = U(arSt2[iIndex]);
double dStd = U(arStd [iIndex]);
String strSm [] = {"BMF - 31960","BMF - 31970","BMF - 3180"};

Point3d pt= _Pt0;
pt.vis(3);

//Streach beam
Cut ct(_Pt0-_X0*(dBaseHeigh+dSh+dSt2),_X0);
_Beam0.addTool(ct,TRUE);

//Tube steel
Body bCts(pt-_X0*dBaseHeigh, pt-_X0*(dSh+dBaseHeigh),dStd*.5);

Display disp (9);
disp.draw(bCts);

//create the bottom plate
PLine pl1(_X0);
pl1.addVertex(pt-_X0*dBaseHeigh-_Y0*dSf*.5+_Z0*dSg*.5);
pl1.addVertex(pt-_X0*dBaseHeigh-_Y0*dSf*.5-_Z0*dSg*.5);
pl1.addVertex(pt-_X0*dBaseHeigh+_Y0*dSf*.5-_Z0*dSg*.5);
pl1.addVertex(pt-_X0*dBaseHeigh+_Y0*dSf*.5+_Z0*dSg*.5);
Body bbp (pl1,_X0*dSt2,1);
disp.draw(bbp);

//create top plate
PLine pl2(_X0);
pl2.addVertex(pt-_X0*(dSh+dBaseHeigh+dSt2)+_Z0*dSa*.5-_Y0*dSd*.5);
pl2.addVertex(pt-_X0*(dSh+dBaseHeigh+dSt2)+_Z0*dSa*.5+_Y0*dSd*.5);
pl2.addVertex(pt-_X0*(dSh+dBaseHeigh+dSt2)-_Z0*dSa*.5+_Y0*dSd*.5);
pl2.addVertex(pt-_X0*(dSh+dBaseHeigh+dSt2)-_Z0*dSa*.5-_Y0*dSd*.5);
Body btp (pl2,+_X0*dSt2,1);
disp.draw(btp);

//create main leg
PLine pl3(_Y0);
pl3.addVertex(pt-_X0*(dSc+dSh+dBaseHeigh+dSt2)+_Z0*dSb*.5);
pl3.addVertex(pt-_X0*(dSc+dSh+dBaseHeigh+dSt2)-_Z0*dSb*.5);
pl3.addVertex(pt-_X0*(dSh+dBaseHeigh+dSt2)-_Z0*dSb*.5);
pl3.addVertex(pt-_X0*(dSh+dBaseHeigh+dSt2)+_Z0*dSb*.5);
Body bml (pl3,_Y0*dSt1,0);
disp.draw(bml);

Slot slt(_Pt0-_X0*(dSh+dBaseHeigh+dSt2),_Z0,_Y0,-_X0,dSb,dSt1,dSc,0,0,1);
_Beam0.addTool(slt);
slt.cuttingBody().vis(2);

//Hardware
strSm[iIndex] += "-" + strFixing;
srtType [iIndex] += "-" + strFixing;

//Material
setCompareKey(strSm[iIndex]); // shoe name
model (srtType); //Article number
dxaout(strSm [iIndex], srtType);  //Designation
material (T("BMF Material")); 
#End
#BeginThumbnail
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
>^@C_`.08_P#XF@`_X3?Q%_T$?_(,?_Q-`'/T`?_9
`
#End
