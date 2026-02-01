#Version 8
#BeginDescription
GE_HDWR_ANCHOR_SCREW
v1.2: 15.jun.2014: David Rueda (dr@hsb-cad.com)

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords Wall;TieRod;Hardware;Anchor
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
*
v1.2: 15.jun.2014: David Rueda (dr@hsb-cad.com)
	- TSL can now be inserted by other hardware systems
v1.1: 27.nov.2012: David Rueda (dr@hsb-cad.com)
	- Version control (several enhancements, coordinated with Manish Patel and Marcelo Quevedo)
*v1.0: 14.nov.2012: David Rueda (dr@hsb-cad.com)
	- Release. Created as dummy only, insertion yet to be coded. Will be useful inserted from outside
*/

String sTypes[0], sSizes[0];
sTypes.append("1/2 Screw Anchor");									sSizes.append("1/2");
sTypes.append("5/8 Screw Anchor");									sSizes.append("5/8");
sTypes.append("7/8 Screw Anchor");									sSizes.append("7/8");

PropString sType(0, sTypes, T("|Anchor type|"),2);

if (_bOnInsert){
	reportMessage("\n"+T("|Message from|")+" GE_HDWR_ANCHOR_SCREW TSL: "+ T("|This TSL has not yet a manual insertion defined. It can be inserted only by other script. Instance will be erased|")+"\n");
	eraseInstance();	
}

Display dp(254);
Vector3d vx=-_ZW;
Vector3d vy=_XW;
Vector3d vz=vx.crossProduct(vy);

// Get info from map if present
if(_Map.hasString("ANCHORTYPE"))
{
	sType.set(sTypes[sSizes.find(_Map.getString("ANCHORTYPE"),0)]);
}
if(_Map.hasVector3d("vx"))
	vx=_Map.getVector3d("vx");
if(_Map.hasVector3d("vy"))
	vy=_Map.getVector3d("vy");
if(_Map.hasVector3d("vz"))
	vz=_Map.getVector3d("vz");
int bInsertedByDirective=_Map.getInt("InsertedByDirective");
if(bInsertedByDirective)
	sType.setReadOnly(true);
int bHideWasherAndNuts=_Map.getInt("HideWasherAndNuts");
	
int nType=sTypes.find(sType,0);

if(_Element.length()==1)
{
	Element el=_Element[0];
	setDependencyOnEntity(el);
	if(_bOnElementDeleted)
		eraseInstance();		
}

// Rod
double dLength=U(250,10);
double dExtension=U(50,2);
double dEmbedment=dLength-dExtension;
double dRadius=U(12,0.375/2);
Point3d ptStart=_Pt0-vx*dExtension;
Point3d ptEnd=_Pt0+vx*dEmbedment;
Body bdRod(ptStart,ptEnd,dRadius);bdRod.vis();

// Sharp end
double dCutLength=U(150,6);
double dSharpSide=U(20,4);
Point3d ptCut=ptEnd+vy*.09;
Body bdCutSharp(ptCut,vx,vy,vz,U(6),U(2),U(2),0,0,1);		//bdCutSharp.vis(3);	
CoordSys csRo;csRo.setToRotation(10,vy,ptEnd+vy*dRadius/2 );
bdCutSharp.transformBy(csRo);
double dRotate=0;
while(dRotate<360){
	bdRod-=bdCutSharp;
	csRo.setToRotation(20,vx,ptEnd);
	bdCutSharp.transformBy(csRo);		
	dRotate+=20;
}

dp.draw(bdRod);

if(bHideWasherAndNuts)
	return;

// Nuts
double dNutSideLength=U(25, 1.062);
double dNutSideHeight=U(15, 0.625);;
Point3d ptAllNutsBasePoints[0]; // Insertion point for all nuts, aligned center in diameter, BASE or top according to extrusion vector
Point3d ptAllNutsExtrusionPoints[0]; // define the vector to extrude body MAKE SURE ALWAYS HAS SAME LENGHT THAT ptAllRodsBasePoints
Point3d ptAllNutsDirectionPoints[0]; // define the vector to align body MAKE SURE ALWAYS HAS SAME LENGHT THAT ptAllRodsBasePoints

// Square washers
Point3d ptAllSquareWashersBasePoints[0]; // Insertion point for all square washers, aligned center in diameter, BASE in vertical
Point3d ptAllSquareWashersExtrusionPoints[0]; // define the vector to extrude body MAKE SURE ALWAYS HAS SAME LENGHT THAT ptAllSquareBlocksBasePoints
Point3d ptAllSquareWashersDirectionPoints[0]; // define the vector to align body MAKE SURE ALWAYS HAS SAME LENGHT THAT ptAllSquareBlocksBasePoints
double dSquareWasherSideLength=U(75, 3);
double dSquareWasherSideHeight=U(15, 0.625);

// Set insertion points for nuts
Point3d ptNut=_Pt0-vx*dSquareWasherSideHeight;
ptAllNutsBasePoints.append(ptNut);
ptAllNutsExtrusionPoints.append(ptNut-vx);
ptAllNutsDirectionPoints.append(ptNut+vy);

// Set insertion points for square washers
ptAllSquareWashersBasePoints.append(_Pt0);
ptAllSquareWashersExtrusionPoints.append(_Pt0-vx);
ptAllSquareWashersDirectionPoints.append(_Pt0+vy);

// Draw nuts
for(int n=0;n<ptAllNutsBasePoints.length();n++)
{
	double dRadius= dNutSideLength*.5;
	double dAngle=60;
	Point3d ptBase=ptAllNutsBasePoints[n];
	Point3d ptExtrude=ptAllNutsExtrusionPoints[n];
	Point3d ptDirection= ptAllNutsDirectionPoints[n];
	Vector3d vExtrude(ptExtrude-ptBase);vExtrude.normalize();
	Vector3d vDirection(ptDirection-ptBase);vDirection.normalize();
	Vector3d vVertex= vExtrude.crossProduct(vDirection);

	PLine plEx;
	for(int s=0;s<6;s++)
	{
		Point3d pt=ptBase+vVertex*dRadius;
		plEx.addVertex(pt);
			vVertex=vVertex.rotateBy(60, _ZW);
		
	}
	plEx.close();
	Body bdNut ( plEx, vExtrude*dNutSideHeight, 1);
	dp.draw(bdNut);
}

//Draw square washers
for(int n=0;n<ptAllSquareWashersBasePoints.length();n++)
{
	Point3d ptBase=ptAllSquareWashersBasePoints[n];
	Point3d ptExtrude=ptAllSquareWashersExtrusionPoints[n];
	Point3d ptDirection= ptAllSquareWashersDirectionPoints[n];
	Vector3d vExtrude(ptExtrude-ptBase);vExtrude.normalize();
	Vector3d vDirection(ptDirection-ptBase);vDirection.normalize();
	Vector3d vVertex= vExtrude.crossProduct(vDirection);

	PLine plEx;
	Point3d pt=ptBase+vVertex*dSquareWasherSideLength*.5+vDirection*dSquareWasherSideLength*.5; pt.vis();
	plEx.addVertex(pt);
	pt-=vDirection*dSquareWasherSideLength; pt.vis();
	plEx.addVertex(pt);
	pt-=vVertex*dSquareWasherSideLength; pt.vis();
	plEx.addVertex(pt);
	pt+=vDirection*dSquareWasherSideLength; pt.vis();
	plEx.addVertex(pt);

	plEx.close();
	Body bdSquareWasher( plEx, vExtrude*dSquareWasherSideHeight, 1);
	dp.draw(bdSquareWasher);
}

return

#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`*_`Z\#`2(``A$!`Q$!_\0`
M'P```04!`0$!`0$```````````$"`P0%!@<("0H+_\0`M1```@$#`P($`P4%
M!`0```%]`0(#``01!1(A,4$&$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*
M%A<8&1HE)B<H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&EJ<W1U
M=G=X>7J#A(6&AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&
MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ>KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!
M`0$!`0````````$"`P0%!@<("0H+_\0`M1$``@$"!`0#!`<%!`0``0)W``$"
M`Q$$!2$Q!A)!40=A<1,B,H$(%$*1H;'!"2,S4O`58G+1"A8D-.$E\1<8&1HF
M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@H.$
MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#W^BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`X[5K<W_C&[@EN[](8=/MG2.WO
M9H%#-).&.(V&20B\GTIO]A6__/YK'_@WNO\`XY5BY_Y'G4/^P;:?^C;FK=`C
M,_L*W_Y_-8_\&]U_\<ILFAVXC8B]UC(!_P"8O=?_`!RM6FR_ZI_]TT#L<_\`
MV6G_`#_ZQ_X-KK_XY1_9:?\`/_K'_@VNO_CE7J*`L4?[+3_G_P!8_P#!M=?_
M`!RMGP69!'K,#W%S,D&H!(S<3O,RJ;>%B-SDG&68XSWJI5SP;_K-?_["0_\`
M2:"F!U%%%%(`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@#
ME+G_`)'G4/\`L&VG_HVYJW52Y_Y'G4/^P;:?^C;FK=`!39?]4_\`NFG4V7_5
M/_NF@#-HHHH`*N>#?]9K_P#V$A_Z3053JYX-_P!9K_\`V$A_Z304`=11110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%<+J7B77D\0:G9V4NFQ6]I,D2B:TDD=LQ1N22)5
M'5SV[5W5>:WW_(U^(?\`K\C_`/2:&@"S_P`))XH_Y^]'_P#!?+_\?H_X23Q1
M_P`_>C_^"^7_`./U4HH`M_\`"2>*/^?O1_\`P7R__'Z/^$D\4?\`/WH__@OE
M_P#C]5**`+?_``DGBC_G[T?_`,%\O_Q^C_A)/%'_`#]Z/_X+Y?\`X_52B@"W
M_P`))XH_Y^]'_P#!?+_\?H_X23Q1_P`_>C_^"^7_`./U4HH`FM-0O_[5NM1U
M%[:>::"*!5MX6A551I&YW,^2?-/ITK0_MO\`Z=__`!__`.M6310!K?VW_P!.
M_P#X_P#_`%J1M9W(5\CJ,??_`/K5E44`7/M__3/_`,>H^W_],_\`QZJ=%`%S
M[?\`],__`!ZJEK?ZSIMS?/IUS8)#=SB=DN+1Y&5O+2,C<)%X^0'IWI**`+?_
M``DGBC_G[T?_`,%\O_Q^C_A)/%'_`#]Z/_X+Y?\`X_52B@"W_P`))XH_Y^]'
M_P#!?+_\?H_X23Q1_P`_>C_^"^7_`./U4HH`M_\`"2>*/^?O1_\`P7R__'Z/
M^$D\4?\`/WH__@OE_P#C]5**`+?_``DGBC_G[T?_`,%\O_Q^C_A)/%'_`#]Z
M/_X+Y?\`X_52B@#HO"FN:IJ>I:C9ZDUF_P!GA@EC>V@:+[YE!!#.V?\`5C\Z
MZJN(\%_\C+K7_7G9_P#H=Q7;T`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%<+J7AK7G\0:G>646FRV]W,DJF:[DC=<11
MH00(F'5#W[UW5%`'GW_"-^*/^?31_P#P82__`!BC_A&_%'_/IH__`(,)?_C%
M>@T4`>??\(WXH_Y]-'_\&$O_`,8H_P"$;\4?\^FC_P#@PE_^,5Z#10!Y]_PC
M?BC_`)]-'_\`!A+_`/&*/^$;\4?\^FC_`/@PE_\`C%>@T4`>??\`"-^*/^?3
M1_\`P82__&*/^$;\4?\`/IH__@PE_P#C%>@T4`>??\(WXH_Y]-'_`/!A+_\`
M&*/^$;\4?\^FC_\`@PE_^,5Z#10!Y3;74LC>5/"D<RRRQ2!)"ZAHY7C."0,C
MY,]!UK9N-.\BV67SMVX9QMQ_6L.+_D)7'_7]>?\`I7-74ZA_R#H_]V@#%9<1
MEL].U9\5Y=7E_#8V5M"UQ-.(4\Z<HG^KD<DD*Q'$1[=ZTG_U!K,\._\`(YZ=
M_P!?W_MK=4`;7_"-^*/^?31__!A+_P#&*/\`A&_%'_/IH_\`X,)?_C%>@T4`
M>??\(WXH_P"?31__``82_P#QBC_A&_%'_/IH_P#X,)?_`(Q7H-%`'GW_``C?
MBC_GTT?_`,&$O_QBC_A&_%'_`#Z:/_X,)?\`XQ7H-%`'GW_"-^*/^?31_P#P
M82__`!BC_A&_%'_/IH__`(,)?_C%>@T4`>??\(WXH_Y]-'_\&$O_`,8H_P"$
M;\4?\^FC_P#@PE_^,5Z#10!ROA30]4TS4M1O-26S3[1#!%&EM.TOW#*2261<
M?ZP?E75444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`>2Q?\A*X_Z_KS_P!*
MYJZV_4?V7&W?;7)1?\A.X_Z_KS_TKFKKK\$:3&".=M`=##D_U!K,\._\CGIW
M_7[_`.VMS6G)_P`>YK,\._\`(YZ=_P!?O_MK<T`>MT444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110!Y-#_P`A2?\`Z_KS
M_P!*YJZ_5/\`D&Q_[M<A#_R%)_\`K^O/_2N:NNU/_D&Q_P"[0'0P9O\`CV-9
MOA[_`)'/3?\`K]_]M;FM*;_CV-9OA[_D<]-_Z_?_`&VNJ`/6Z***`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`\FA'_$SN
M#_T_7G_I7-77:G_R#8_]RN1A_P"0E<_]?UY_Z5S5UNI_\@V/_=H#H84O-N:S
M/#;$^--/SVOL#_P%N:TY/]0:R_#7_(Z6'_7_`/\`MK<T`>NT444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110!Y/#_R$KG_
M`*_KS_TKFKK-2_Y!T7^Y7)0_\A*X_P"OZ\_]*YJZS4O^0=%_N4!T,.3_`%!_
M"LKPU_R.EA_U_P#_`+:W-:LG^H/X5E^&O^1TL/\`K_\`_;6YH`]=HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@#R:'_
M`)"5Q_U_7G_I7-76:E_R#HO]RN3A_P"0E<?]?UY_Z5S5U>I?\@Z+_<H#H8C_
M`.I-9?AK_D=+#_K_`/\`VUN:U'_U)K+\-_\`(Z6'_7__`.VMS0!Z[1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`'DT/
M_(2N/^OZ\_\`2N:NJU'_`)!T7^Y7*P_\A*X_Z_KS_P!*YJZK4?\`D'1?[E`=
M#%?_`%)K+\-_\CI8?]?_`/[:W-:C_P"I-9?AO_D=+#_K_P#_`&UN:`/7:***
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M\FB_Y"5Q_P!?UY_Z5S5UFH+G3(FS_#7)Q?\`(2N/^OZ\_P#2N:NMO_\`D$Q_
M[M`=#"?_`%1K+\-_\CI8?]?_`/[:W-:K_P"J/X5E>&_^1TL/^O\`_P#;6YH`
M]=HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@#R6+_D)7'_7]>?^E<U=;?\`_()C_P!VN2B_Y"5Q_P!?UY_Z5S5UM_\`
M\@J+_=H#H8C?ZH_A65X<_P"1TT__`*_O_;6YK5;_`%9_"LOPW_R.EA_U_?\`
MMK<T`>N4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110!Y+%_R$KC_`*_KS_TKFKK+_P#Y!47^[_6N4A_Y"D__`%_7G_I7
M-77:G_R#D_W:`Z&$W^K/X5E>'/\`D=-/_P"O[_VUN:U'_P!7^59GAS_D=-/_
M`.O[_P!M;F@#URBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`/)H?^0I/_U_7G_I7-76ZG_R#H_]W^M<E#_R%)_^OZ\_
M]*YJZS4_^0?'_NT!T,-O]7^59GAS_D=-/_Z_O_;6YK3;_5_B*S/#G_(Z:?\`
M]?W_`+:W-`'KE%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`>2P_\A2?_K^O/_2N:NMU,_\`$OC_`-VN2A_Y"D__`%_7
MG_I7-76ZE_R#X_\`=-`=##/W#]169X<_Y'33_P#K^_\`;6YK3/W#]169X<_Y
M'33_`/K^'_I+<T`>N4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110!Y-#_P`A.?\`Z_[S_P!*YJZO4O\`D'Q?[IKDXO\`
MD)S_`/7]>?\`I7-76:E_R#XO]TT!T,0_=_*LSP[_`,CII_\`U_#_`-);FM,_
M=/X5F>'/^1TT_P#Z_O\`VUN:`/7****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`\AM9?,U>^7;CRM1NTSGK_`*3*?ZUV
M.I(?[-B.1PE<58?\AG5/^PI=_P#H]Z[C4O\`D&1_]<Q0'0P#]TGTQ67X;8-X
MST_':^Q_Y*W-:A_U;_Y[5D^%_P#D<['_`+"!_P#2:ZH`]?HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@#QVP_Y#.J?]
MA2[_`/1[UV^I?\@R/_KF*XBP_P"0SJO_`&%+O_T>]=OJ/_(,B_ZYB@.AA'_5
MO_GM61X8_P"1SL?^P@?_`$FNJUO^6;_Y[5D^&/\`D<['_L('_P!)KJ@#U^BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`/';'_D,ZK_V%+O_`-'O7;:E_P`@R+_<%<18_P#(9U7_`+"EW_Z/>NWU+_D&
M1?\`7,4!T,+_`)9R?Y[5D^&/^1SL?^P@?_2:ZK6_@?\`SVK)\,?\CG8_]A`_
M^DUU0!Z_1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`'CEC_`,AG5?\`L*7?_H]Z[;4?^09#_P!<Q7$V/_(9U7_L*7?_
M`*/>NVU'_D&0_P#7,4!T,,?ZN3_/:LGPQ_R.=C_V$#_Z375:P^X_^>U9/AC_
M`)'.Q_["!_\`2:ZH`]?HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@#QW3_^0YJ?_85N_P#T>]=MJO&GQ@=-M<3IW_(<
MU/\`["MW_P"CWKMM5_X\(_\`=H#H80^Z_P#GM63X8_Y'.Q_["!_])KJM8?=?
M_/:LGPQ_R.=A_P!A`_\`I-=4`>OT444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110!X[I__`"'-4_["MW_Z/>NUU7_CPB_W
M:XG3_P#D.ZI_V%;O_P!'O7;:K_QX1?[M`=##7[K_`.>U9/AC_D<[#_L('_TF
MNJUE^Z_^>U9/AC_D<[#_`+"!_P#2:ZH`]?HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@#QS3_\`D.:I_P!A6[_]'O7;
MZHI-A$0.`G-<1I__`"'-4_["MW_Z/>NYU+_D&I_N4!T,!/NO_GM63X8_Y'.P
M_P"P@?\`TFNJUD^[)]3_`"K)\,_\CG8?]?Y_])KJ@#U^BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`/'-/_`.0YJG_8
M5N__`$>]=SJ7_(-3_<KA;#_D.:I_V%;O_P!'O7<ZE_R#8_\`<H#H8,?23_/:
MLKPS_P`CG8?]?Y_])KJM6/I)_GM65X9_Y'.P_P"O\_\`I-=4`>O4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110!XW8?\
MAS5?^PK=_P#H]Z[G4O\`D&Q_[E<-8?\`(<U3_L*W?_H]Z[C4O^0;'_N4!T,*
M+I)]3_*LKPS_`,CG8?\`7^?_`$FNJU8NDGU_I65X9_Y'.P_Z_P`_^DUU0!Z]
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`'C=C_`,AS5?\`L*W?_HYZ[C4O^0;%_N5PUC_R&]5_["EW_P"CWKN=2_Y!
ML7^Y0'0PHNDO^>U97AG_`)'.P_Z__P#VVN:U8>DOX_RK*\,_\CG8?]?_`/[;
M75`'KU%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`>-6/_(;U7_L*7?_`*/>NXU/_D&Q?[E<18_\AG5O^PK=_P#HYZ[?
M4_\`D&P_[E`=##AZ2_4_RK*\,_\`(YZ?_P!?Y_\`2:ZK5B_U$WX_SK&\(_\`
M(V:9_P!?W_MK<T`>Q4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110!XW9?\AG5O\`L*W?_HYZ[;4_^0;#_N"N*TY0VN:J
M#T.JW?\`Z.>NUU08TZ(?[-`=#$B_U$WXUC>$?^1LTS_K^_\`;6YK9A_U,WX_
MSK&\)?\`(V:;_P!?W_MM<T`>Q4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110!X[IG_(>U3_L*W?_`*.>NUU0'^SXL#^&
MN*TW_D/:K_V%;O\`]'/7;ZC_`,@U/]R@.A@P_P"IF_'^=8WA+_D;--_Z_O\`
MVVN:V+?_`(]Y?H:Q_"7_`"-FF_\`7]_[;7-`'L5%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`>.:;_R'=5_["MW_P"C
MGKN-1_Y!L?\`N5P^G?\`(>U7_L*W?_HYZ[C43_Q+8_\`<H#H8%O_`,>\OT-8
M_A/_`)&S3?\`K^_]MKFMBW_X]YOH?YUC^$O^1LTS_K^_]M;F@#V*BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`/&]._
MY#VJ_P#85N__`$<]=QJ7_(-C_P!RN'T__D.ZK_V%;O\`]'/7<:B?^);'_N4!
MT,&V_P"/>;Z'^=8_A+_D;--_Z_O_`&UN:V+;_CWF^A_G6/X2_P"1LTW_`*_O
M_;6YH`]BHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@#QRP5EUS4V*D!M5NRI(ZCSW'],5VVI?\`(-C_`-VN#OHI;+Q5
MK=D\QE2.^>1#C&!,!-MQGL9"/?':KTT\K6_,KD/MW9;[V.F?6@$:-K_Q[3?0
MUD>$_P#D;-,_Z_O_`&VNJWH9$M].$S#Y4BWMMZGC-8_PYTX7_BRYO9I25TV!
M'BB!.#++YB[S@X.%5P`0?]83Q0!ZW1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`'D_CB%;;Q^95M_+%UI\3F18\"5T=
MPWS8Y8*T8^A6J[?\>J?6M[XGVQ$V@Z@)``D\MH8RN<B1-^<YXP80.A^]VQ7/
MAMULI]Z`-:[E6'P[([`D&W"\>XQ_6K7PIM$&FZOJ)BD$EQ>>2LC[@'CC10`H
M/&`[2C([YZXK,UF98O#2JP/[P1J,=CUY_(UU_P`/[1K/P'HX>02-/#]J)"[0
M#,QEQC)Z;\9[XS0!TU%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`<C\28$D\$74[6_G-:S07`(CWF,+*A=QP2,)OR1V
MSVS7%0D&S/L:]5UG3_[7T/4--\WROMEM);^9MW;-ZE<XR,XSTKQ_1[AKK189
MW`WR1([8Z9(S0!<\<2E-!6V@24W$I*P+$I)+8VJ%`YSEP!BO6K.S@T^QM[*U
M3R[>WB6*),D[448`R>3P!7F5_%_:'C'PUIZR>6?M8G9BN[B/,H`Y[F''MFO5
M:`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"O%;>)+.\UBQCM_LZV]_<*(?+V!%,I9`!_=V,I&.,$8KVJN?O_``7H
M6I:C<7]S;7'VFX*F5H[V:,,0H4<*X'10.G:@#E=$ABO_`(H1L897_LW3W??A
M@B2.P53D<$E&E`!]&..,UZ563I'AW3-#FN9K"*99;D()GEN9)BP7.WEV.,;C
MT]:UJ`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
<*`"BBB@`HHHH`****`"BBB@`HHHH`****`/_V8HH
`


#End
