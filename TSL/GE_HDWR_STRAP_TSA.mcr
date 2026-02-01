#Version 8
#BeginDescription
v1.2: 02.JUN.2014: David Rueda (dr@hsb-cad.com)
Inserts TSA Strap (Simpson's MSTA equivalent) as dummy/floating metalpart
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2011 by
*  hsbSOFT 
*  UNITED STATES OF AMERICA
*
*  The program may be used and/or copied only with the written
*  permission from hsbSOFT, or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*
* REVISION HISTORY
* -------------------------
* v1.2: 02.JUN.2014: David Rueda (dr@hsb-cad.com)
	- Warning of manually insertion updated
* v1.1: 18.mar.2013: David Rueda (dr@hsb-cad.com)
	- Description updated
* v1.0: 14.nov.2012: David Rueda (dr@hsb-cad.com)
	- Release. Created as dummy only. Meant to be inserted bye other TSL's.
*/

String sTypes[0];
double dLengths[0];

sTypes.append("TSA18");			dLengths.append(18);
sTypes.append("TSA24");			dLengths.append(24);

PropString sType(0, sTypes, T("|Anchor type|"),2);

if (_bOnInsert){
	reportMessage("\n"+T("|Message from|")+" GE_HDWR_STRAP_TSA: "+ T("|This TSL has not yet a manual insertion defined. It can be inserted only by other script. Instance will be erased|")+"\n");
	eraseInstance();	
}

Vector3d vx=_ZW;
Vector3d vy=_XW;
Vector3d vz=_YW;

// Get info from map if present
if(_Map.hasString("Type"))
	sType.set(_Map.getString("Type"));
if(_Map.hasVector3d("vx"))
	vx=_Map.getVector3d("vx");
if(_Map.hasVector3d("vy"))
	vy=_Map.getVector3d("vy");
if(_Map.hasVector3d("vz"))
	vz=_Map.getVector3d("vz");
int bInsertedByDirective=_Map.getInt("InsertedByDirective");
if(bInsertedByDirective)
	sType.setReadOnly(true);

if(_Element.length()==1)
{
	Element el=_Element[0];
	setDependencyOnEntity(el);
	if(_bOnElementDeleted)
		eraseInstance();		
}
	
int nIndex=sTypes.find(sType,0);
double dLength=dLengths[nIndex];
double dDrill=U(.125);
double dStrapWidth=U(1.25);
double dStrapThick=U(.125);

Vector3d vCross=vy;
Vector3d vOff=vz;
//draw it
Point3d ptStrap=_Pt0+vx*dLength*.5;
LineSeg lnS(ptStrap-vCross*dStrapWidth/2-vx*dLength/2,ptStrap+vCross*dStrapWidth/2+vx*dLength/2);
vOff.vis(_Pt0);vCross.vis(_Pt0);vx.vis(_Pt0);
Point3d pt1=_Pt0+vy*15;
vx.vis(pt1);
vy.vis(pt1);
vz.vis(pt1);
PLine plRec;plRec.createRectangle(lnS,vCross,vx);
	
Body bdStrap(plRec,vOff*dStrapThick);
	
	
//Create holes
double dHalfL=(dLength-U(6))/2;
	
Point3d ptH1=ptStrap+vCross*U(0.28125)+vx*U(0.75),ptH2=ptStrap-vCross*U(0.28125)-vx*U(0.75);
Body bdH1(ptH1-vOff*2*dStrapThick,ptH1+vOff*2*dStrapThick,dDrill);
Body bdL1(ptH2-vOff*2*dStrapThick,ptH2+vOff*2*dStrapThick,dDrill);
	
bdStrap-=bdH1;
bdStrap-=bdL1;
	
Body bdH2=bdH1,bdL2=bdL1;

double dGo=U(0);
while(dGo<dHalfL){
	bdH1.transformBy(vx*U(3));
	bdH2.transformBy(-vx*U(3));
	bdL1.transformBy(vx*U(3));
	bdL2.transformBy(-vx*U(3));
		
	bdStrap-=bdH1;
	bdStrap-=bdL1;
	bdStrap-=bdH2;
	bdStrap-=bdL2;
		
	dGo+=U(3);
}

Display dp(256);
dp.draw(bdStrap);







#End
#BeginThumbnail
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
MU^]TBX3S+B>ZLQP\4SF1E_VE<Y;/L21]*]&M)XKJUCN('#Q2J'5AT(->2S'Y
MJ]$\&_\`(FZ1[VJ']*`-RBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`I",TM%`";14-Q9VUW$8[B".5",%9%##'XU/10!REQ\/=$WM-IANM'G.#YF
MG3&,<>L9RA_[YJNFF^+M)7]S=V&M1`=)T-M,?^!+E#_WR*[.D*@]J`.$N_$C
M6Q*ZMI%_I_.-[1^9&?<,F1C\JSCJ=CJ*;[*[AG!'\#@X^HZUZ85!&",@UAZI
MX.\/ZP=U[I<#2=I4'EN/HRX-`'ET5S>/?W$5S;*D2Y:.12<$9(`.>^,'CCG'
M:O4O!ISX,TC_`*]4_E61:?#K2K>[:2:ZU"[MR=RVMS.&C7\<;F'LQ(KL(HTB
MC$<:*B*,!5&`!0`^BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`,4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
$`'__V44`
`



#End
