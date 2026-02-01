#Version 7
#BeginDescription
EN
   creates BMF-U Shoe BMF-29045 - BMF 29120 on a post
DE
   erzeugt Postenschuhe vom Typ U, BMF Artikelnummern 29045 - 29120
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
//Author: Roberto Hallo, rh@hsb-cad.com/
//Date: 2006/Jan/26
//Version: 1.0. initial version
//Version No. 1.1 (Modified), 
//Date: 2006/Jan/30 
//Modified by: Roberto Hallo, TSL Team, Quito, Ecuador.




U(1,"mm");

_X0.vis(_Pt0,1);
_Y0.vis(_Pt0,1);
_Z0.vis(_Pt0,1);
_Pt0.vis();

PropDouble dBaseHeigh (0,U(0),T("Base Heigh"));
String Fixing[]={T("Nails"),T("Screws")};
PropString strFixing (0, Fixing, T("Type of Fixing"),1);

String strError = T("\nShoe cannot be used!");

// get male beam size
double dMw = _Beam0.dD(_Y0);
double dMh = _Beam0.dD(_Z0);

// create arrays
double arW[] = { 45,50,60,70,80,90,100,120 };//Male beam sizes

int iIndex = -1;
for (int i=0; i < arW.length(); i++)
{
	if (abs(dMw-U(arW[i])) < 0.0001)
	{
		iIndex = i;
		
		break;
	}
}

if (iIndex == -1)
{
	reportMessage(strError);
	eraseInstance();
	return;
}

// create arrays for shoe
double arSb[] = { 45,50,60,70,80,90,100,120};//Width of shoe
double arSh1[] = {127,125,120,115,110,115,110,110};
double arSh2[] = {27,25,20,25,20,25,20,20};
String strSm[] = {"BMF - 29045","BMF -29050","BMF -29060","BMF -29070",
					"BMF -29080","BMF -29090","BMF -29100","BMF -29120"};//Model of Shoe
String strSn = "" + arSb[iIndex] +"x" + arSh1[iIndex];//Type of shoe

// shoe dimensions
double dSb = U(arSb[iIndex]);
double dSh1 = U(arSh1[iIndex]);
double dSh2 = U(arSh2 [iIndex]);
double dSt= U(3); 
double dSl = U(70);

//Streach beam
Cut ct(_Pt0-_X0*(dBaseHeigh+dSh2),_X0);
_Beam0.addTool(ct,TRUE);

Point3d pt= _Pt0-_X0*(dSh2+dBaseHeigh);
pt.vis(3);

//Adjust of beam
Cut ct1(pt,_X0);
_Beam0.addTool(ct1,TRUE);

//create the bottom plate
PLine pl1(_X0);
pl1.addVertex(_Pt0-_X0*dBaseHeigh+_Y0*(dSb+dSt*2)*.5+_Z0*dSl*.5);
pl1.addVertex(_Pt0-_X0*dBaseHeigh-_Y0*(dSb+dSt*2)*.5+_Z0*dSl*.5);
pl1.addVertex(_Pt0-_X0*dBaseHeigh-_Y0*(dSb+dSt*2)*.5-_Z0*dSl*.5);
pl1.addVertex(_Pt0-_X0*dBaseHeigh+_Y0*(dSb+dSt*2)*.5-_Z0*dSl*.5);
Body bbp (pl1,_X0*dSt,1);
Display disp (9);
disp.draw(bbp);

//create lateral plates
Point3d ptt = _Pt0-_X0*(dBaseHeigh)- _Y0*dSb*.5;
ptt.vis();
PLine pl2(-_Y0);
pl2.addVertex(ptt+_Z0*dSl*.5);
pl2.addVertex(ptt-_Z0*dSl*.5);
pl2.addVertex(ptt-_Z0*dSl*.5-_X0*(dSh1-dSt));
pl2.addVertex(ptt+_Z0*dSl*.5-_X0*(dSh1-dSt));
Body blp (pl2,-_Y0*dSt,1);
disp.draw(blp);

CoordSys cs(_Pt0,_X0,_Y0,_Z0);
cs.setToRotation(180, _X0,_Pt0);
blp.transformBy (cs);
disp.draw(blp);

//create internal plate
PLine pl3(_Y0);
pl3.addVertex(pt+_Y0*dSb*.5+_X0*dSh2+_Z0*dSl*.5);
pl3.addVertex(pt+_Y0*dSb*.5+_X0*dSh2-_Z0*dSl*.5);
pl3.addVertex(pt+_Y0*dSb*.5-_Z0*dSl*.5);
pl3.addVertex(pt+_Y0*dSb*.5+_Z0*dSl*.5);
Body bip(pl3,-_Y0*dSt,1);
disp.draw(bip);

CoordSys cs1(_Pt0,_X0,_Y0,_Z0);
cs1.setToRotation(180, _X0,_Pt0);
bip.transformBy (cs1);
disp.draw(bip);

PLine pl4(_X0);
pl4.addVertex(pt+_Y0*dSb*.5-_Z0*dSl*.5);
pl4.addVertex(pt+_Y0*dSb*.5+_Z0*dSl*.5);
pl4.addVertex(pt-_Y0*dSb*.5+_Z0*dSl*.5);
pl4.addVertex(pt-_Y0*dSb*.5-_Z0*dSl*.5);
Body bip2 (pl4,_X0*dSt,1);
disp.draw(bip2);

//Hardware
strSm [iIndex] += "-" + strFixing;
strSn += "-" + strFixing;

//Material
setCompareKey(strSm[iIndex]); // shoe name
model (strSn); //Article number
dxaout(strSm[iIndex], strSn);  //Designation
material(T("Galvanized Steel"));



#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0```0`!``#__@`N26YT96PH4BD@2E!%1R!,:6)R87)Y
M+"!V97)S:6]N(%LQ+C4Q+C$R+C0T70#_VP!#`%`W/$8\,E!&049:55!?>,B"
M>&YN>/6ON9'(________________________________________________
M____VP!#`55:6GAI>.N"@NO_____________________________________
M____________________________________Q`&B```!!0$!`0$!`0``````
M`````0(#!`4&!P@)"@L0``(!`P,"!`,%!00$```!?0$"`P`$$042(3%!!A-1
M80<B<10R@9&A""-"L<$54M'P)#-B<H()"A87&!D:)28G*"DJ-#4V-S@Y.D-$
M149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@X2%AH>(B8J2DY25EI>8
MF9JBHZ2EIJ>HJ:JRL[2UMK>XN;K"P\3%QL?(R<K2T]35UM?8V=KAXN/DY>;G
MZ.GJ\?+S]/7V]_CY^@$``P$!`0$!`0$!`0````````$"`P0%!@<("0H+$0`"
M`0($!`,$!P4$!``!`G<``0(#$00%(3$&$D%1!V%Q$R(R@0@40I&AL<$)(S-2
M\!5B<M$*%B0TX27Q%Q@9&B8G*"DJ-38W.#DZ0T1%1D=(24I35%565UA96F-D
M969G:&EJ<W1U=G=X>7J"@X2%AH>(B8J2DY25EI>8F9JBHZ2EIJ>HJ:JRL[2U
MMK>XN;K"P\3%QL?(R<K2T]35UM?8V=KBX^3EYN?HZ>KR\_3U]O?X^?K_P``1
M"`&3`6@#`1$``A$!`Q$!_]H`#`,!``(1`Q$`/P"E0`4`%`!0`4`%`!0`4`%`
M!0`4`%`!0`4`7K;_`%"_C_.L9;EK8EJ2@H`*`"@`H`*`"@`H`*`"@`H`*`"@
M`H`9-_JC5+<3*M6(*`"@`H`*`"@`H`*`"@!#T-,1%5$A0`4`%`!0`4`%`!0`
M4`%`!0`4`%`!0`4`%`!0`4`%`%ZV_P!0OX_SK&6Y:V):DH*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`&3?ZHU2W$RK5B"@`H`*`"@`H`*`"@`H`0]#3$151(4`%
M`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0!>MO\`4+^/\ZQEN6MB6I*"
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
2H`*`"@`H`*`"@`H`*`"@`/_9
`

#End
