#Version 8
#BeginDescription
Last modified by: 
Alberto Jena (aj@hsb-cad.com)
25.02.2011  -  version 1.5

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 5
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2008 by
*  hsbSOFT 
*  IRELAND
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
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 29.05.2008
* version 1.0: Release Version
*
* date: 12.06.2008
* version 1.1: Pull Down for the Models
*
* date: 10.05.2010
* version 1.2:	Change the Table and some small fixes on export
*
* date: 03.09.2010
* version 1.3:	Add Properties for other anchor type so the customer can define it
*
* date: 11.02.2011
* version 1.4:	Add group for the new data base
*
*/

Unit (1, "mm");

PropDouble dTh (0, U(2), T("Thickness"));
PropDouble dWi (1, U(36), T("Width"));
PropDouble dLe (2, U(100), T("Length"));
PropInt nQty (0, 1, T("Quantity"));

PropString sDispRep(0, "", T("Show in Disp Rep"));

String strAnchorModels[]={"Other Model Type", "SP90", "SP240", "SPU90", "SPU96", "SPU240", "SPA38", "SPA50"};
PropString sModel(1, strAnchorModels,T("Model Type"), 1);

PropString strCustomAnchorModel (2, "**Other Type**", T("Other Anchor Type"));
strCustomAnchorModel.setDescription( T("Please fill this value if you choose 'Other Model Type' above") );

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

String sAnchorModel;

if (strAnchorModels.find(sModel, 0)==0)
	sAnchorModel=strCustomAnchorModel;
else
	sAnchorModel=sModel;

if (_bOnInsert)
{
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	showDialogOnce();
	_Pt0=getPoint(T("Pick a Point"));
	_Beam.append(getBeam(T("Select a Beam")));
	return;
}

Vector3d vx;
Vector3d vy;
Vector3d vz;

String sGroup="";
if (_Map.hasString("Group"))
{
	sGroup=_Map.getString("Group");
}

if (_Beam.length()<1)
{
	eraseInstance();
	return;
}

if (_Map.hasVector3d("vx"))
{
	vx=_Map.getVector3d("vx");
}
else
{
	vx=_Beam[0].vecX();
}
if (_Map.hasVector3d("vy"))
{
	vy=_Map.getVector3d("vy");
}
else
{
	vy=_Beam[0].vecZ();
}
if (_Map.hasVector3d("vz"))
{
	vz=_Map.getVector3d("vz");
}
else
{
	vz=_Beam[0].vecY();
}

setDependencyOnEntity(_Beam[0]);

assignToGroups(_Beam[0]);

PLine plMP(vz);
plMP.addVertex(_Pt0+vx*(dWi*0.5));
plMP.addVertex(_Pt0-vy*(dLe)+vx*(dWi*0.5));
plMP.addVertex(_Pt0-vy*(dLe)-vx*(dWi*0.5));
plMP.addVertex(_Pt0-vx*(dWi*0.5));
plMP.close();
Body bdMP(plMP, vz*dTh, 1);

PLine plMP2(-vy);
plMP2.addVertex(_Pt0+vx*(dWi*0.5));
plMP2.addVertex(_Pt0+vz*(dLe*0.5)+vx*(dWi*0.5));
plMP2.addVertex(_Pt0+vz*(dLe*0.5)-vx*(dWi*0.5));
plMP2.addVertex(_Pt0-vx*(dWi*0.5));
Body bdMP2(plMP2, -vy*dTh, 1);

Display dp(-1);
if (sDispRep!="")
	dp.showInDispRep(sDispRep);

dp.draw(bdMP);
dp.draw(bdMP2);

String sCompareKey = (String) sAnchorModel;
setCompareKey(sCompareKey);

String sQty=(String) nQty;
exportToDxi(TRUE);
dxaout(sGroup, "");
dxaout("U_MODEL",sAnchorModel);
dxaout("U_QUANTITY",sQty);
		
Map mp;
mp.setString("Name", sAnchorModel);
mp.setInt("Qty", nQty);

_Map.setMap("TSLBOM", mp);


#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`-N!.X#`2(``A$!`Q$!_\0`
M'P```04!`0$!`0$```````````$"`P0%!@<("0H+_\0`M1```@$#`P($`P4%
M!`0```%]`0(#``01!1(A,4$&$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*
M%A<8&1HE)B<H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&EJ<W1U
M=G=X>7J#A(6&AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&
MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ>KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!
M`0$!`0````````$"`P0%!@<("0H+_\0`M1$``@$"!`0#!`<%!`0``0)W``$"
M`Q$$!2$Q!A)!40=A<1,B,H$(%$*1H;'!"2,S4O`58G+1"A8D-.$E\1<8&1HF
M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@H.$
MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#Y_HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"K^E:9>ZQJ=OI^GV[7%W<-LCB3JQ_D`!DDG@`$GBJ%>E_
M!.Y6W\;W"F81O+82)&-V"YWHV!ZG"DX]`?2@#W;P+X-LO!?A^*SAB0WLJJ][
M<`[C++CG!(!V`DA1@8'N237U?X8>#M9M_+ET*UMG565);)?(92P^]\F`Q&`1
MN!`].3G8CU&=3\Q#CW&/Y5:CU*)N'4I[]163A-:CNCQW7?V>XBA?P_K+JX4`
M0:@H(9L\GS$`P,=MAY'7GCS_`%WX3^,=#8[M)>^@#A%FL/WP8D9^Z!O`'(R5
M`S]1GZKCGBE^XX;V[_E4E+GDMPL?"]%?:VL:!I&OV_DZOIMK>(%9%,T8+1AA
MAMC=5)P.00>!Z5Y_KOP(\,ZA'NTJ6ZTJ8*%4*YFBSG)8JYW$D<<,!T..N:51
M=0L?--%>IZQ\"_%EB&:P-EJ4?F%46*7RY-G.&8/A1T&0&/)[]:\^U+0]6T;R
M_P"U-,O;'S<^7]J@>+?C&<;@,XR/S%6FGL(S:***8!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`5V7PJ_P"2D:3_`-MO_1+UQM=7\.;Z.P\?Z/-*'96F,("8)W2*
M8U_#+#/M36X'TW1115B"IH[J>,860X]#S_.H:*&D]P-!-4;_`):1@\]5..*M
M1WL$G\>T^C<5BT5FZ46.YT(((!!R#T(ID\$5S;R6]Q$DL,JE)(Y%#*ZD8((/
M!!':L-)'CSL=ESUP<5:34IU^]M<9[C!K-T7T'<P-=^$W@[74.[24L9MH19M/
M_<E0#G[H&PD\C)4G'T&/.]7_`&>KI-SZ+KD,H,IVPWL1CV1\XRZ[MS#@?=`/
M)XZ5[9'J438#JR'OW`JTDT<GW'5CC.`>:GWX@?(NK_#KQ=H5O]HU#0KI8=C.
MTD.V98U49)<QE@HQW;'?T-<I7W16-KOA+P_XE0C6-)M;IRH3S63$JJ#N`$@P
MP&<\`]SZFFJG<+'QA17T9JW[/^A76Y]*U.\L9&E+;956>-4.?E4?*W'&"6/`
MYSG->=ZQ\%/&.DV_G16]MJ"A&=Q9399`HS]UPI8GG`4$\?3-J:8CS>BK5[8W
M6FW;VE[;36UQ'C?#/&4=<C(RIY'!!_&JM4`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%;/A'_D=-!_[
M"-O_`.C%K&JYIM[+IFJ6M_"J&2UF29`X)4LK`C..V10!]=4445H(****`"BB
MB@`HHHH`****`)X[R>,Y$A/LW-68]4/26/\`%?\`"L^BI<(OH.YMI>V\G20`
MXSAN*GKG:?'+)$<HY7Z'K6;H]F%S8O+*TU&T>TOK6&ZMI,;X9XPZ-@Y&5/!Y
M`/X5PVK_``8\&:H6:.QFT^5Y3(TEG,5SG.5"MN15YZ!1C`Q@<5U4>I3+]\!Q
M^1JU'J4+??!0_F*CDG'8=T>$:O\`L_ZQ:P&32M7M=0=59FBFC,#$@?*J<L"3
MR.2H''/IYUK/@OQ)H`G;5-$O((H`OF3^46A7=C'[Q<IW`Z]>.M?8L<L<HRCA
MOH>E/HYVMPL?"]%?8NK^`/">N;C?Z#9-(\IF>6)/)D=SG)9TPQSDDY/)YKSO
M6/V?-/>WSHNLW4,RJQV7JK(LC8^4;E"E!G.3ANO3CFE406/GZBN]UGX0^,]'
M\]QI7VZ"+;^]LI!+OSC[J<2'!.#\O8GIS7%3P2VMQ);W$3Q31,4>.12K(P."
M"#R"#VJTT]A%>BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`^QJ*QO"/_`")>A?\`8/M__1:ULUH(****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"K$=[/'_'N'HW-5Z*&D]P-*/5!TEC_%?\*LQWD$
M@R)`/9N*Q**S=*+'<Z*JFH:7I^K6ZV^I6%K>PJV]8[F%9%#8(R`P(S@GGWK+
M2:2/[CLHSG`/%6H]2E7`=5<=^Q-9NC);#N<3J_P-\(:A;XL([K3)E5@KPS-(
MK,1P760DD`CHI7.3STQYWK/P$\26?G2:7=V6HQ)M\M-QAFDSC/RM\@QD_P`?
M0>O%?0::E`WWMR''<9%6E=7&48,/4'-3><=P/C/5O#&N:#O.J:3>6D:R&'S9
M86$;/SPK_=;H2,$Y`R*Q:^Z*XW5_A7X,UC<TNAPV\IB,:R69,&SKA@JX0L,]
M2IZ#.0,4U4[A8^2:*]VUG]GKF>30]=Q]WR;>]B^F[=*GXD83T'O7`:O\*O&6
MD;FDT6:YB$AC62SQ/OZX8*N7"G'4J.HS@G%6I)B.(HHHJ@"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@#ZH\%74-WX'T26!MZK9QQ$X(^9%",.?1E
M(_"MZN.^%7_)-M)_[;?^CGKL:T0@HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHI@%*"000<$="*2BD!9COKB/'S[@.S#/\`]>K*:HO_
M`"TC(XZJ<\UFT5+IQ?0=S<CNH)#A9!GT/'\ZFKG:DCGEB^XY7V[?E6;H]F%R
MQJ_AG0]>#?VKI-E=R-$8?-EA4R*G/"O]Y>I(P1@G(K@-8^`GAJ\\^32[J\TV
M5]OEIN$T,>,9^5OG.<'^/J?3BO0(]2E7AU#^_0U:BU"!\!B4/'7I^=1R3B/0
M^==8^!?BRQ#-8&RU*/S"J+%+Y<FSG#,'PHZ#(#'D]^M>=ZAI6H:1.MOJ5A<V
M4S+O6.XA:-BN2,@,`<9!Y]J^UU=7&48,/4'--G@BN;>2WN(DEAE4I)'(H974
MC!!!X(([4E4:W"Q\-T5]7ZS\(?!>L>>_]E?8IY=O[VQD,6S&/NIS&,@8/R]R
M>O->=ZQ^SY?I<9T36;6:)F8[+U6C:-<_*-RA@YQG)PO3ISQ:FF%CQ2BNHU;X
M?^+-$#&^T*]5$B,SRQ1^=&B#.2SIE1C!)R>!S7+U=Q!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110!]$_!^_\`MG@**`1;/L=Q+!NW9WY/F9]O]9C'/3WKO:\U^"'_`")=
MY_V$7_\`1<=>E5HMA!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`*K,C;E)!'<&K$=_/'QNWCT;FJU%)
MI/<#3CU1<?O(R#_L\YJTES!)]V1<YQ@\&L*BH=*+V'<Z*N;\2^&/"^I0SRZO
MHME<3W&W=*(PDSE<8_>+AQC`'7IQ[5-'<2Q8V2,`.@SQ^59]U-)/<,\K%FSC
MZ"E"A[VKT"Y\M^(;>"T\2:I:VT8B@ANY8XT!)VJ'(`R22<`=S6376?$B*.'Q
M[JBQ1HBEHV(48&3&I)^I))/N:Y.J:L[`%%%%(`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`/:/@9-*T
M&N0EV,2-`ZH6.U6(<$@>I"KGZ#TKUZO&O@7-$LVN0F1!*ZP.J%AN907!('H"
MRY^H]:]EJUL(****8!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!5&<8F:KU4K@?OF_"KAN!\^
M?%*UF@\>7<DJ;4N(XI(CD'<H0)GV^96'/I7$UZ)\9/\`D;K3_KP3_P!&25YW
M64_B8PHHHJ0"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`]+^"/_`".=Y_V#W_\`1D=>]U\^?!N^BM?'
M8AD#%KNUDBC*XP&&).?;"'\<5]!U<=A!1113`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*J7
M7^M'TJW56Z'SJ?48JX;@>+_&BSCCU+2;X%O-FADA8'[H"$$8]_WA_2O*^U>M
M_&W_`)@7_;Q_[3KR3M6=3XF-!1114`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110!V7PK_Y*3I/_`&V_
M]$O7TI7RUX(NI[/QQHLMN^QVO(XB<`_*[!&'/JK$?C7U+5Q$%%%%,`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`JM=_P?C5FH+H#RU/?-5'<#S'XR?\BA:?\`7^G_`*+DKPZO
M>OBU9R7/@EID90MM<1S.&/)!RG'OEQ^&:\%J:GQ`@HHHK,84444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`&SX1_Y'30?^PC;_`/HQ:^K:^.:^QJJ(!1115""BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"H
M+K_5#_>J>H[C_4-^'\ZI;@<)\3?^2>ZI_P!LO_1J5\\5],^,+:*Z\&:RDR[D
M6TDD`R1\R#>IX]&4'\*^9J57<$%%%%9#"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*^O=.OHM3TRTO
MX5=8KJ%)D#@!@K*",X[X-?(5?5OA'_D2]"_[!]O_`.BUJH@;-%%%4(****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`*CG!,+8J2FR?ZI_H::W`YOQ'%)/X7U:&&-Y)9+*941!EF)
M0@``=37R_7UI7R714Z`@HHHK(84444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!7T_\.[V6_\`A_HTTJHK
M+"80$!`VQL8U_'"C/O7S!7TK\*O^2;:3_P!MO_1SU4=P.QHHHJA!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!2,-RD'N,4M%,#-KY9U6R_LW6+VP\SS!:W$D._&-VUB,X[9Q7
MU-7S'XJ_Y&[6O^O^?_T8U.KT!&/1116(PHHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"OH#X+32R^"9T
MD=W6*]D2,,Q(1=B'`]!DD_4FOG^O=_@A=0OX9U&S#9GBO/,=,'A710ISTY*-
M^7TIQW`]/HHHJQ!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1113`SY!B1@/4U\Z_$B*.'Q]J
MBQ1HBEHV(48&3&I)^I))/N:^BY1B5_J:^?OBE:S0>/+N25-J7$<4D1R#N4($
MS[?,K#GTJJGP@CB:***P&%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`5['\!_\`F8/^W?\`]JUXY7K/
MP.O_`"]:U;3_`"L^?;I/YF[[OEMMQCOGS.OM[TUN![;1115B"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@"E<?Z]OP_E7A7QD_P"1NM/^O!/_`$9)7NUR,39]1FO&?C19
MQQZEI-\"WFS0R0L#]T!"",>_[P_I5S^`#RNBBBL!A1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%>E?!
M#_D<[S_L'O\`^C(Z\UKNOA+=SV_Q#LHHGVI<QRQ2C`.Y0A?'M\R*>/2FMP/H
MRBBBK$%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`%2Z_UH^E>/_&W_F!?]O'_`+3KV&[`
MRI[\UYI\9/\`D4+3_K_3_P!%R5H_@`\.HHHKG&%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`5V/PQEB
M@^(ND/+(D:EI$!<@`LT3A1]22`/4FN.K9\(_\CIH/_81M_\`T8M-`?5M%%%6
M(****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`*UV.$/UKSSXM6<ESX):9&4+;7$<SACR0<I
MQ[Y<?AFO1;K_`%0_WJX?XF_\D]U3_ME_Z-2M/L`?/%%%%<XPHHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"M+0KZ+3?$&FW\P9HK:ZBF<*`6*JX)QGO@5FUM>'/#FI>*]9ATO2X3),_S
M,S<)$@ZNY[*,_J`,D@$`^K**NR:;*N2C*X[=B:JR121'#H5^HZU:DGL(9111
M3`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`AN1F+/H<US'C"VBNO!FLI,NY%M))`,D?,@WJ>/
M1E!_"NIN/]0WX?SKG?$<4D_A?5X88WDEDLIE1$&68E"``!U-:1^$#Y?HHHKG
M&%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!116UX<\.:EXKUF'2]+A,DS_,S,<)$@ZNY[*,_J`,D@$`/#GAS
M4O%>M0Z7I<)DF?YF9CA(D'5W/91G]0!DD`_5?@OP7IO@G118V(\R>3#75TRX
M>=QW/HHR<+VSW)))X+\%Z;X)T86-B/,GDPUU=,N'G<=SZ*,G"]L]R23T=8RE
M<84445F,@>RMY.L8!QC*\56DTL=8I/P;_&M"BK4Y+J*QBR64\?\`!N'JO-0$
M$$@C!'4&NAIDD4<HPZ!OJ.E:*L^H6,"BM6338FR49D/;N!59]-G7[NUQGL<&
MM%4BQ6*=%.>-X\;T9<],C%-JQ!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`#)1F)A[9JA6A)_JG^AK/K6&P'R715[5
M;+^S=8O;#S/,%K<20[\8W;6(SCMG%4:YAA1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!116UX<\.:EXKUF'2]+A,DS
M_,S,<)$@ZNY[*,_J`,D@$`/#GAS4O%>M0Z7I<)DF?YF9CA(D'5W/91G]0!DD
M`_5?@OP7IO@G118V(\R>3#75TRX>=QW/HHR<+VSW)))X+\%Z;X)T86-B/,GD
MPUU=,N'G<=SZ*,G"]L]R23T=8RE<84445F,****`"BBB@`HHHH`****`$(!!
M!&0>H-0264$G\&T^J\58HIIM;`9LFEGK%)^#?XU5EM)XL[D)'/(Y%;E%:*K)
M;BL<[16])!%+]]`WOW_.JTFFQ-RC%/;J*T59/<5C*HJX^FSK]W:XSV.#55XW
MCQO1ESTR,5HI)["&T444P"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`*S:TJSB""0>HK2`'S%XJ_P"1OUK_`*_Y_P#T8U8]=9\2(HX?'VJK%&B*
M6C8A1@9,:DGZDDD^YKDZP>XPHHHI`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!116UX<\.:EXKUF'2]+A,DS_,S,<)$@ZNY[*,_
MJ`,D@$`/#GAS4O%>M0Z7I<)DF?YF9CA(D'5W/91G]0!DD`_5?@OP7IO@G118
MV(\R>3#75TRX>=QW/HHR<+VSW)))X+\%Z;X)T86-B/,GDPUU=,N'G<=SZ*,G
M"]L]R23T=8RE<84445F,****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`I"`001D'J#2T4`5Y+&WDS\FTGNIQ_]:JKZ6W_`"SD!YZ,,<5I45:J2745
MC#EM)XL[D)'/(Y%0UT51R6\4N=\:DGJ<<_G6BK=T*Q@T5JR:;$W*,4]NHJK+
MI\Z9*@..>G7\JT52+"Q4HIS(R'#J5/H1BFU8@HHHH`****`"BBB@`HHHH`**
M**`"L^3_`%K_`.\:T*H3#;,P]\U<-P/G[XI6LT'CR[DE3:EQ'%)$<@[E"!,^
MWS*PY]*XFO1/C)_R-UI_UX)_Z,DKSNLI_$QA1114@%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%;7ASPYJ7BO6H=+TN$R3/\S,QPD2#
MJ[GLHS^H`R2`0`\.>'-2\5ZU#I>EPF29_F9F.$B0=7<]E&?U`&20#]5^"_!>
MF^"=%%C8CS)Y,-=73+AYW'<^BC)PO;/<DDG@OP7IO@G1A8V(\R>3#75TRX>=
MQW/HHR<+VSW))/1UC*5QA11168PHHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`1E5UVL`0>Q%5Y+""3G;L/JO%
M6:*:;6P&9)IC`$QON]`1C]:JR6\T7+QD#UZBMVBM%5DMQ6.=HK>DMXI<[XU)
M/4XY_.JKZ9&?N.RG/?D5HJT7N*QET5:>PN$Z*&&,Y4U6961MK`@CL16BDGL(
M2BBBF`4444`%4KC_`%[?A_*KM4[H?O1]*N&X'C/QHLXX]2TF^!;S9H9(6!^Z
M`A!&/?\`>']*\K[5ZW\;?^8%_P!O'_M.O).U9U/B8T%%%%0`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1173^"O!FI>-M96RL5\N"/#75TRY2
M!#W/JQP<+WQV`)!L!2\.>'-2\5ZS#I>EPF29_F9F.$B0=7<]E&?U`&20#]5^
M"_!>F^"=%%C8CS)Y,-=73+AYW'<^BC)PO;/<DDWO#OAW3?"VC0Z5I<'EP1\L
MS<O*YZNY[L<?H`,``#5K"4[C"BBBH&%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4C*KKM8`@]B*6B@"M)802<[=A]5XJH^F2#[CJPQWX-:E%6JDD*QA26\T7+Q
MD#UZBHJZ*HY+>*7.^-23U..?SK15NZ%8P:J70_>`^U;TFEKC]W(0?]KG-9&I
M0-;O&KE22">#6].<6]!-'EWQD_Y%"T_Z_P!/_1<E>'5[[\6+'[7X'EF\S;]D
MN(YL;<[\GR\>WW\_A7@5%3X@04445F,****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBNG\%>#-2\;:RME8KY<$>&NKIERD"'N?5C@X7OCL`2#8`\%>#-
M2\;:RME8KY<$>&NKIERD"'N?5C@X7OCL`2/JSP[X=TWPMHT.E:7!Y<$?+,W+
MRN>KN>[''Z`#```/#OAW3?"VC0Z5I<'EP1\LS<O*YZNY[L<?H`,``#5K"4KC
M"BBBH&%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4453O[]
M+*/`PTK#Y5_J?:G&+D[(`O[]+*/`PTK#Y5_J?:N9DD>:1I)&+.QR2:))'FD:
M21BSL<DFN$\>^/HO#D+:=I[K)JTB\GJMN#_$P[MZ+^)XP&[X05-79#=RA\5O
M%-C!HTWAY#YU[<;&D"GB!0P<;O<X&!Z')[9\3J::62XF>::1I)78L[N<LQ/)
M))ZFH:SE+F=QA1114@%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%=/X*\&:
MEXVUE;*Q7RX(\-=73+E($/<^K'!PO?'8`D&P!X*\&:EXVUE;*Q7RX(\-=73+
ME($/<^K'!PO?'8`D?5GAWP[IOA;1H=*TN#RX(^69N7E<]7<]V./T`&```>'?
M#NF^%M&ATK2X/+@CY9FY>5SU=SW8X_0`8``&K6$I7&%%%%0,****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHJG?WZ64>!AI6'RK_4^U.,7)
MV0!?WZ64>!AI6'RK_4^U<S)(\TC22,6=CDDT22/-(TDC%G8Y)-<)X]\?1>'(
M6T[3W635I%Y/5;<'^)AW;T7\3Q@-WP@J:NR&[B>/?'T7AN%M.T]UDU:1>3U6
MW!_B8=V]%_$\8#>%S2R7$SS32-)*[%G=SEF)Y))/4T2S27$SS32-)*[%G=SE
MF)Y))/4U#6<I.3&%%%%2`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`445T_@K
MP9J7C;65LK%?+@CPUU=,N4@0]SZL<'"]\=@"0;`'@KP9J7C;65LK%?+@CPUU
M=,N4@0]SZL<'"]\=@"1]6>'?#NF^%M&ATK2X/+@CY9FY>5SU=SW8X_0`8``!
MX=\.Z;X6T:'2M+@\N"/EF;EY7/5W/=CC]`!@``:M82E<84445`PHHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBJ=_?I91X&&E8?*O]3[4X
MQ<G9`%_?I91X&&E8?*O]3[5S,DCS2-)(Q9V.231)(\TC22,6=CDDUPGCWQ]%
MX<A;3M/=9-6D7D]5MP?XF'=O1?Q/&`W?""IJ[(;N)X]\?1>&X6T[3W635I%Y
M/5;<'^)AW;T7\3Q@-X7-+)<3/--(TDKL6=W.68GDDD]31+-)<3/--(TDKL6=
MW.68GDDD]34-9RDY,84445(!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1173
M^"O!FI>-M96RL5\N"/#75TRY2!#W/JQP<+WQV`)!L`>"O!FI>-M96RL5\N"/
M#75TRY2!#W/JQP<+WQV`)'U9X=\.Z;X6T:'2M+@\N"/EF;EY7/5W/=CC]`!@
M``'AWP[IOA;1H=*TN#RX(^69N7E<]7<]V./T`&``!JUA*5QA1114#"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***IW]^EE'@8:5A\J_U/
MM3C%R=D`7]^EE'@8:5A\J_U/M7,R2/-(TDC%G8Y)-$DCS2-)(Q9V.237">/?
M'T7AR%M.T]UDU:1>3U6W!_B8=V]%_$\8#=\(*FKLANXGCWQ]%X;A;3M/=9-6
MD7D]5MP?XF'=O1?Q/&`WA<TLEQ,\TTC22NQ9W<Y9B>223U-$LTEQ,\TTC22N
MQ9W<Y9B>223U-0UG*3DQA1114@%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%=/X*\&:EXVUE;*Q7RX(\-=73+E($/<^K'!PO?'8`D&P!X*\&:EXVUE;*Q7R
MX(\-=73+E($/<^K'!PO?'8`D?5GAWP[IOA;1H=*TN#RX(^69N7E<]7<]V./T
M`&```>'?#NF^%M&ATK2X/+@CY9FY>5SU=SW8X_0`8``&K6$I7&%%%%0,****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHK.U+4A:J8HB#,1_
MWS_]>JC%R=D(EO[]+*/`PTK#Y5_J?:N9DD>:1I)&+.QR2:))'FD:21BSL<DF
MN$\>^/HO#D+:=I[K)JTB\GJMN#_$P[MZ+^)XP&[H05-79+=Q/'OCZ+PW"VG:
M>ZR:M(O)ZK;@_P`3#NWHOXGC`;PN:62XF>::1I)78L[N<LQ/)))ZFB6:2XF>
M::1I)78L[N<LQ/)))ZFH:SE)R8PHHHJ0"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBNG\%>#-2\;:RME8KY<$>&NKIERD"'N?5C@X7OCL`2#8`\%>#-2\;:
MRME8KY<$>&NKIERD"'N?5C@X7OCL`2/JSP[X=TWPMHT.E:7!Y<$?+,W+RN>K
MN>[''Z`#```/#OAW3?"VC0Z5I<'EP1\LS<O*YZNY[L<?H`,``#5K"4KC"BBB
MH&%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`445G:EJ0M5,
M41!F(_[Y_P#KU48N3LA!J6I"U4Q1$&8C_OG_`.O7.LQ9BS$DDY)/>AF+,68D
MDG))[UYC\1/B%]@$NBZ+-_I?*7-RA_U/JBG^_P"I_AZ?>^[WQC&E$G<T_'OC
MZ+PW"VG:>ZR:M(O)ZK;@_P`3#NWHOXGC`;PN:62XF>::1I)78L[N<LQ/)))Z
MFH:*RE)R8PHHHJ0"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBNG\%>#-2\;
M:RME8KY<$>&NKIERD"'N?5C@X7OCL`2#8`\%>#-2\;:RME8KY<$>&NKIERD"
M'N?5C@X7OCL`2/JSP[X=TWPMHT.E:7!Y<$?+,W+RN>KN>[''Z`#```/#OAW3
M?"VC0Z5I<'EP1\LS<O*YZNY[L<?H`,``#5K"4KC"BBBH&%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`445G:EJ0M5,41!F(_P"^?_KU48N3
MLA!J6I"U4Q1$&8C_`+Y_^O7.LQ9BS$DDY)/>AF+,68DDG))[UYC\1/B%]@$N
MBZ+-_I?*7-RA_P!3ZHI_O^I_AZ?>^[WQC&E$G</B)\0OL`ET719O]+Y2YN4/
M^I]44_W_`%/\/3[WW?&***RE)R8PHHHJ0"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBNG\%>#-2\;:RME8KY<$>&NKIERD"'N?5C@X7OCL`2#8`\%>#-2\;
M:RME8KY<$>&NKIERD"'N?5C@X7OCL`2/JSP[X=TWPMHT.E:7!Y<$?+,W+RN>
MKN>[''Z`#```/#OAW3?"VC0Z5I<'EP1\LS<O*YZNY[L<?H`,``#5K"4KC"BB
MBH&%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`445G:EJ0M5
M,41!F(_[Y_\`KU48N3LA!J6I"U4Q1$&8C_OG_P"O7.LQ9BS$DDY)/>AF+,68
MDDG))[UYC\1/B%]@$NBZ+-_I?*7-RA_U/JBG^_ZG^'I][[O?&,:42=P^(GQ"
M^P"71=%F_P!+Y2YN4/\`J?5%/]_U/\/3[WW?&***RE)R8PHHHJ0"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBNG\%>#-2\;:RME8KY<$>&NKIERD"'N?5C@
MX7OCL`2#8`\%>#-2\;:RME8KY<$>&NKIERD"'N?5C@X7OCL`2/JSP[X=TWPM
MHT.E:7!Y<$?+,W+RN>KN>[''Z`#```/#OAW3?"VC0Z5I<'EP1\LS<O*YZNY[
ML<?H`,``#5K"4KC"BBBH&%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`445G:EJ0M5,41!F(_P"^?_KU48N3LA!J6I"U4Q1$&8C_`+Y_^O7.
MLQ9BS$DDY)/>AF+,68DDG))[UYC\1/B%]@$NBZ+-_I?*7-RA_P!3ZHI_O^I_
MAZ?>^[WQC&E$G</B)\0OL`ET719O]+Y2YN4/^I]44_W_`%/\/3[WW?&***RE
M)R8PHHHJ0"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBNG\%>#-2\;:RME8K
MY<$>&NKIERD"'N?5C@X7OCL`2#8`\%>#-2\;:RME8KY<$>&NKIERD"'N?5C@
MX7OCL`2/JSP[X=TWPMHT.E:7!Y<$?+,W+RN>KN>[''Z`#```/#OAW3?"VC0Z
M5I<'EP1\LS<O*YZNY[L<?H`,``#5K"4KC"BBBH&%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`445G:EJ0M5,41!F(_[Y_\`KU48N3LA!J6I
M"U4Q1$&8C_OG_P"O7.LQ9BS$DDY)/>AF+,68DDG))[UYC\1/B%]@$NBZ+-_I
M?*7-RA_U/JBG^_ZG^'I][[O?&,:42=P^(GQ"^P"71=%F_P!+Y2YN4/\`J?5%
M/]_U/\/3[WW?&***RE)R8PHHHJ0"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBNY^'?P[O/'.H%W+V^D6[`7-T!R3U\M,\%R/P4')[!ANP!\._AW>>.=1+N7
MM](MV`N;H#DGKY:9X+D?@H.3V#?3NA:!I7AK31IVCV:6MJ&+[%))9CU)8DDG
MH,D]`!T`J?3--LM'TVWT[3[9+>TMUV1Q)T`_F23DDGDDDGFK=82E<84445`P
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBL[4M2%JIBB(
M,Q'_`'S_`/7JHQ<G9"#4M2%JIBB(,Q'_`'S_`/7KG68LQ9B22<DGO0S%F+,2
M23DD]Z\Q^(GQ"^P"71=%F_TOE+FY0_ZGU13_`'_4_P`/3[WW>^,8THD[A\1/
MB%]@$NBZ+-_I?*7-RA_U/JBG^_ZG^'I][[OC%%%92DY,84445(!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!117<_#OX=WGCG4"[E[?2+=@+FZ`Y)Z^6F>"Y'
MX*#D]@PW8`^'?P[O/'.HEW+V^D6[`7-T!R3U\M,\%R/P4')[!OJ33--LM'TV
MWT[3[9+>TMUV1Q)T`_F23DDGDDDGFC3--LM'TVWT[3[9+>TMUV1Q)T`_F23D
MDGDDDGFK=82E<84445`PHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBL[4M2%JIBB(,Q'_`'S_`/7JHQ<G9"#4M2%JIBB(,Q'_`'S_`/7K
MG68LQ9B22<DGO0S%F+,223DD]Z\Q^(GQ"^P"71=%F_TOE+FY0_ZGU13_`'_4
M_P`/3[WW>^,8THD[A\1/B%]@$NBZ+-_I?*7-RA_U/JBG^_ZG^'I][[OC%%%9
M2DY,84445(!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!117<_#OX=WGCG4"[E
M[?2+=@+FZ`Y)Z^6F>"Y'X*#D]@PW8`^'?P[O/'.HEW+V^D6[`7-T!R3U\M,\
M%R/P4')[!OJ33--LM'TVWT[3[9+>TMUV1Q)T`_F23DDGDDDGFC3--LM'TVWT
M[3[9+>TMUV1Q)T`_F23DDGDDDGFK=82E<84445`PHHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBL[4M2%JIBB(,Q'_`'S_`/7JHQ<G9"#4
MM2%JIBB(,Q'_`'S_`/7KG68LQ9B22<DGO0S%F+,223DD]Z\Q^(GQ"^P"71=%
MF_TOE+FY0_ZGU13_`'_4_P`/3[WW>^,8THD[A\1/B%]@$NBZ+-_I?*7-RA_U
M/JBG^_ZG^'I][[OC%%%92DY,84445(!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!117<_#OX=WGCG4"[E[?2+=@+FZ`Y)Z^6F>"Y'X*#D]@PW8`^'?P[O/'.H
MEW+V^D6[`7-T!R3U\M,\%R/P4')[!OJ33--LM'TVWT[3[9+>TMUV1Q)T`_F2
M3DDGDDDGFC3--LM'TVWT[3[9+>TMUV1Q)T`_F23DDGDDDGFK=82E<84445`P
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBL[4M2%JIBB(
M,Q'_`'S_`/7JHQ<G9"#4M2%JIBB(,Q'_`'S_`/7KG68LQ9B22<DGO0S%F+,2
M23DD]Z\Q^(GQ"^P"71=%F_TOE+FY0_ZGU13_`'_4_P`/3[WW>^,8THD[A\1/
MB%]@$NBZ+-_I?*7-RA_U/JBG^_ZG^'I][[OC%%%92DY,84445(!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!117<_#OX=WGCG4"[E[?2+=@+FZ`Y)Z^6F>"Y'
MX*#D]@PW8`^'?P[O/'.HEW+V^D6[`7-T!R3U\M,\%R/P4')[!OJ33--LM'TV
MWT[3[9+>TMUV1Q)T`_F23DDGDDDGFC3--LM'TVWT[3[9+>TMUV1Q)T`_F23D
MDGDDDGFK=82E<84445`PHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBL[4M2%JIBB(,Q'_`'S_`/7JHQ<G9"#4M2%JIBB(,Q'_`'S_`/7K
MG68LQ9B22<DGO0S%F+,223DD]Z\Q^(GQ"^P"71=%F_TOE+FY0_ZGU13_`'_4
M_P`/3[WW>^,8THD[A\1/B%]@$NBZ+-_I?*7-RA_U/JBG^_ZG^'I][[OC%%%9
M2DY,84445(!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110!VOP\\#2^.=::
M%[@6VGVVUKJ4,-^&SA$!ZLV#SC`P2<\`_5&F:;9:/IMOIVGVR6]I;KLCB3H!
M_,DG))/)))/-?/WP,O8H]2UBQ*OYL\,<RD`;0J,0<^^9%Q]#7MT<\L7W'*^W
M;\J4J;EU"YO45E1ZE*O#J']^AJU'J,##YB4/N,_RK)TY(=RW135=7&48,/4'
M-.K,84444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%9&J:IY>ZWMV
M^?H[C^'V'O\`Y^EP@YNR$/U#5A`S0P`-(!@MV4_U-8#,68LQ)).23WI*\R^(
M?Q"^P"71=%F_TOE+FY0_ZGU13_?]3_#T^]]WNC&--$[A\1/B%]@$NBZ+-_I?
M*7-RA_U/JBG^_P"I_AZ?>^[XQ1164I.3&%%%%2`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
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
M$G</B%\0_M_FZ+HDP^R#*7-TA_UWJBG^YZG^+IT^]Y=116+;;NQA1112`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`+ECJ5[IDK36%W<6DK+L9X)6C8KD'&0>F0/RKN-*^,/B:SFS>O;
MZC$S*662(1L%!Y"E`,$CN0V,#CKGSNBBX'O6C_&G1;QUCU.SN-.9F(WJ?.C"
MXR"2`&R3D8"GMSZ=MI'B71-?0'2]3M[EBI?RE;$@4'!)0X8#..H[CUKY/HJN
M8#[&HKYBT3Q]XET$(EMJDLD";!Y%Q^]3:O10&Y48X^4CCZ"NYTCXX2!E36M)
M1@6),UFQ!5<<#8Q.3GON'!Z<<OF0CV9)'CSL=ESUP<5:34IU^]M<9[C!KAM'
M^)?A768P5U-+.7:6:*]_=%0#C[Q^0D\'`8G'T..JAFBN(8YH9$DBD4.CHP*L
MI&001U!%#BGN!L1ZE$V`ZLA[]P*M)-')]QU8XS@'FL"BLW170=RWJFJ>7NM[
M=OGZ.X_A]A[_`.?IA4$8.#7CGQ"^(?V[S=%T28?9.4N;I#_KO5%/]SU/\73I
M][HBHTXBW#XA?$/[?YNBZ),/L@RES=(?]=ZHI_N>I_BZ=/O>7445BVV[L844
M44@"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*OV&L:EI7F?V=J%U9^81O^
MSS-'NQG&=I&<9/YU0HH`]'TOXQ^)K0*+Q;34(_,#.TD?EOMXRH*84=#@E3R>
M_2NVTOXT:!=>2FHVMW82-G>^T2Q)C..5^8YX_AZGTYKP*BG=@>H?$#XD+JRR
M:5H4SBQD'[^YVE&F!_@4'!"^N>3TZ?>\OHHH;;W`****0!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
<`!1110`4444`%%%%`!1110`4444`%%%%`'__V44`
`







#End
