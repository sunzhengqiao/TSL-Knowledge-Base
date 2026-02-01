#Version 8
#BeginDescription
GE_WALL_INFO_ELEMENT_ZONE_LOCATION
Displays thickness and location of the different zones as stored inside the stickframe description. Also displays where is the ptOrg of selected zone
v2.0: 19.mar.2013: David Rueda (dr@hsb-cad.com)
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 0
#KeyWords 
#BeginContents
/*
  COPYRIGHT
  ---------------
  Copyright (C) 2011 by
  hsbSOFT 

  The program may be used and/or copied only with the written
  permission from hsbSOFT, or in accordance with
  the terms and conditions stipulated in the agreement/contract
  under which the program has been supplied.

  All rights reserved.

 REVISION HISTORY
 -------------------------

 v1.0: no date, David Rueda (dr@hsb-cad.com)
 v2.0: 19.mar.2013: David Rueda (dr@hsb-cad.com)
	- Added display of ptOrg for selected zone)
*/

Unit(1,"mm");

int nArZoneIndex[] = {0,1,2,3,4,5,-1,-2,-3,-4,-5};
PropInt nZone(0,nArZoneIndex,T("Zone index"),5); 
PropDouble dOff(0,U(30),T("Offset"));

if (_bOnInsert) {

  _Element.append(getElement());
  _Pt0 = getPoint();

  return;
}

if (_Element.length()==0) { eraseInstance();  return; }
Element el = _Element[0];
CoordSys cs = el.coordSys(_Pt0);
_Pt0 = cs.ptOrg();
Vector3d vx=cs.vecX();
Vector3d vy=cs.vecY();
Vector3d vz=cs.vecZ();

//cs.vis(1);
setDependencyOnEntity(el);

Display dp(-1);

for (int z=-5; z<6; z++) {
  ElemZone zn = el.zone(z);
  double dPosZ = zn.dPosZ();
  Vector3d vecZ = zn.vecZ();
  Point3d pt0 = _Pt0 - abs(z)*U(50)*cs.vecX() + dPosZ*cs.vecZ();
  double dH = zn.dH();

  Point3d pt1 = pt0-U(100)*cs.vecX();
  Point3d pt2 = pt0;
  Point3d pt3 = pt0+dH*vecZ;
  Point3d pt4 = pt3-U(100)*cs.vecX();

  PLine pl(pt1,pt2,pt3,pt4);
  dp.draw(pl);

  PlaneProfile pr = el.profBrutto(0);
  pr.vis(1);
}


Point3d ptZoneOrg=el.zone(nZone).ptOrg()+vx*(vx.dotProduct(_Pt0-el.zone(nZone).ptOrg())+dOff);
PLine plOrg(vy);
plOrg.addVertex(ptZoneOrg+vx*U(7)+vz*U(4));
plOrg.addVertex(ptZoneOrg);
plOrg.addVertex(ptZoneOrg+vx*U(7)-vz*U(4));
plOrg.addVertex(ptZoneOrg);
plOrg.addVertex(ptZoneOrg+vx*U(50));

dp.draw(plOrg);
String st;
st="Zone ("+nZone+") ptOrg";
dp.draw(st,ptZoneOrg+vx*U(55),vx,-vz,1,0);
//ptZoneOrg.vis();




#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`$L`9`#`2(``A$!`Q$!_\0`
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
M"BBB@`HHHH`****`.$_X6/\`]0K_`,F/_L:/^%C_`/4*_P#)C_[&LOP+:V]W
MK<T=S!%,@MF8+(@8`[EYP:]`_L32?^@79?\`@.G^%<E-U9QNI'=55"G+E<?Q
M.3_X6/\`]0K_`,F/_L:/^%C_`/4*_P#)C_[&NL_L32?^@79?^`Z?X4?V)I/_
M`$"[+_P'3_"KY*W\QEST/Y/Q.3_X6/\`]0K_`,F/_L:/^%C_`/4*_P#)C_[&
MM+Q9I>GVWAF\E@L+6*1=F'2%5(^=1U`JGX%TZQN]$FDN;.WF<7+*&DB5B!M7
MC)%0W5Y^3F-4J#I\_+^)#_PL?_J%?^3'_P!C1_PL?_J%?^3'_P!C76?V)I/_
M`$"[+_P'3_"C^Q-)_P"@79?^`Z?X5?)6_F,N>A_)^)R?_"Q_^H5_Y,?_`&-'
M_"Q_^H5_Y,?_`&-=9_8FD_\`0+LO_`=/\*\_\=6MO::W#';010H;96*QH%!.
MYN<"HJ.K"-W(UI*A4ERJ/XFI_P`+'_ZA7_DQ_P#8T?\`"Q_^H5_Y,?\`V-=9
M_8FD_P#0+LO_``'3_"C^Q-)_Z!=E_P"`Z?X5?)6_F,N>A_)^)R?_``L?_J%?
M^3'_`-C1_P`+'_ZA7_DQ_P#8UUG]B:3_`-`NR_\``=/\*/[$TG_H%V7_`(#I
M_A1R5OY@YZ'\GXG)_P#"Q_\`J%?^3'_V-'_"Q_\`J%?^3'_V-9>EVMO)\09+
M9X(FMQ<SKY3("N`'P,=.,"O0/[$TG_H%V7_@.G^%13=6:;YC6HJ%-I./XG)_
M\+'_`.H5_P"3'_V-'_"Q_P#J%?\`DQ_]C76?V)I/_0+LO_`=/\*/[$TG_H%V
M7_@.G^%7R5OYC+GH?R?B<G_PL?\`ZA7_`),?_8T?\+'_`.H5_P"3'_V-:7BS
M2]/MO#-Y+!86L4B[,.D*J1\ZCJ!5/P+IUC=Z)-)<V=O,XN64-)$K$#:O&2*A
MNKS\G,:I4'3Y^7\2'_A8_P#U"O\`R8_^QH_X6/\`]0K_`,F/_L:ZS^Q-)_Z!
M=E_X#I_A1_8FD_\`0+LO_`=/\*ODK?S&7/0_D_$Y/_A8_P#U"O\`R8_^QH_X
M6/\`]0K_`,F/_L:ZS^Q-)_Z!=E_X#I_A6+XLTO3[;PS>2P6%K%(NS#I"JD?.
MHZ@4I1K13?,5&5"4DN7?S,W_`(6/_P!0K_R8_P#L:/\`A8__`%"O_)C_`.QJ
M;P+IUC=Z)-)<V=O,XN64-)$K$#:O&2*Z;^Q-)_Z!=E_X#I_A2@JTHI\PYNA"
M3CR_B<G_`,+'_P"H5_Y,?_8T?\+'_P"H5_Y,?_8UUG]B:3_T"[+_`,!T_P`*
M/[$TG_H%V7_@.G^%5R5OYB.>A_)^)R?_``L?_J%?^3'_`-C1_P`+'_ZA7_DQ
M_P#8UE^.K6WM-;ACMH(H4-LK%8T"@G<W.!7H']B:3_T"[+_P'3_"HBZLI-<V
MQK-4(Q4N7?S.3_X6/_U"O_)C_P"QH_X6/_U"O_)C_P"QKK/[$TG_`*!=E_X#
MI_A1_8FD_P#0+LO_``'3_"KY*W\QEST/Y/Q.3_X6/_U"O_)C_P"QH_X6/_U"
MO_)C_P"QKK/[$TG_`*!=E_X#I_A7G^J6MO'\08[9((EMS<P+Y2H`N"$R,=.<
MFHJ.K!)\QK35"HVE'\34_P"%C_\`4*_\F/\`[&C_`(6/_P!0K_R8_P#L:ZS^
MQ-)_Z!=E_P"`Z?X4?V)I/_0+LO\`P'3_``J^2M_,9<]#^3\3D_\`A8__`%"O
M_)C_`.QH_P"%C_\`4*_\F/\`[&NL_L32?^@79?\`@.G^%4M8T?3(M$OY(].M
M$=;:1E98%!!"G!!Q0XUDK\PU.@W;E_$P/^%C_P#4*_\`)C_[&C_A8_\`U"O_
M`"8_^QJ#P#8VEY_:'VJU@GV>7M\V,-C.[.,_2NS_`+$TG_H%V7_@.G^%3#VL
MX\W,74]A"3BX_B<G_P`+'_ZA7_DQ_P#8U/8^/OME_;6O]F;/.E6/=Y^<9(&<
M;?>NE_L32?\`H%V7_@.G^%<#J,$5M\188H(DBC6ZM\(BA0.$/04INK"S<@IJ
MC4NE'H>FT445UG$%%%%`!1110`4444`>:_#W_D/S_P#7JW_H25Z57FOP]_Y#
M\_\`UZM_Z$E>E5SX;^&=.+_BA11170<QA>,O^13O?^V?_H:U0^'O_(`G_P"O
MIO\`T%*O^,O^13O?^V?_`*&M4/A[_P`@"?\`Z^F_]!2N=_QUZ'2O]W?J=911
M170<P5YK\0O^0_!_UZK_`.A/7I5>:_$+_D/P?]>J_P#H3USXG^&=.$_BGI5%
M%%=!S!1110!YKI'_`"4J3_KZN/Y/7I5>:Z1_R4J3_KZN/Y/7I5<^'^%^ITXK
MXH^@4445T',87C+_`)%.]_[9_P#H:U0^'O\`R`)_^OIO_04J_P",O^13O?\`
MMG_Z&M4/A[_R`)_^OIO_`$%*YW_'7H=*_P!W?J=911170<P5A>,O^13O?^V?
M_H:UNUA>,O\`D4[W_MG_`.AK45/@?H:4OXD?5%#X>_\`(`G_`.OIO_04KK*Y
M/X>_\@"?_KZ;_P!!2NLJ:/\`#15?^*PHHHK4Q/-?B%_R'X/^O5?_`$)Z]*KS
M7XA?\A^#_KU7_P!">O2JYZ7\29TUOX4/F%%%%=!S!7FNK_\`)2H_^OJW_DE>
ME5YKJ_\`R4J/_KZM_P"25SXCX5ZG3A?BEZ'I5%%%=!S!5#6_^0!J/_7K+_Z"
M:OU0UO\`Y`&H_P#7K+_Z":F7PLJ'Q(Y/X<?\Q/\`[9?^SUW=<)\./^8G_P!L
MO_9Z[NL\/_#1MBOXK_KH%>:ZO_R4J/\`Z^K?^25Z57FNK_\`)2H_^OJW_DE3
MB/A7J/"_%+T/2J***Z#F"BBB@`HHHH`****`/-?A[_R'Y_\`KU;_`-"2O2J\
MU^'O_(?G_P"O5O\`T)*]*KGPW\,Z<7_%"BBBN@YC"\9?\BG>_P#;/_T-:H?#
MW_D`3_\`7TW_`*"E7_&7_(IWO_;/_P!#6J'P]_Y`$_\`U]-_Z"E<[_CKT.E?
M[N_4ZRBBBN@Y@KS7XA?\A^#_`*]5_P#0GKTJO-?B%_R'X/\`KU7_`-">N?$_
MPSIPG\4]*HHHKH.8****`/-=(_Y*5)_U]7'\GKTJO-=(_P"2E2?]?5Q_)Z]*
MKGP_POU.G%?%'T"BBBN@YC"\9?\`(IWO_;/_`-#6J'P]_P"0!/\`]?3?^@I5
M_P`9?\BG>_\`;/\`]#6J'P]_Y`$__7TW_H*5SO\`CKT.E?[N_4ZRBBBN@Y@K
M"\9?\BG>_P#;/_T-:W:PO&7_`"*=[_VS_P#0UJ*GP/T-*7\2/JBA\/?^0!/_
M`-?3?^@I765R?P]_Y`$__7TW_H*5UE31_AHJO_%84445J8GFOQ"_Y#\'_7JO
M_H3UZ57FOQ"_Y#\'_7JO_H3UZ57/2_B3.FM_"A\PHHHKH.8*\UU?_DI4?_7U
M;_R2O2J\UU?_`)*5'_U]6_\`)*Y\1\*]3IPOQ2]#TJBBBN@Y@JAK?_(`U'_K
MUE_]!-7ZH:W_`,@#4?\`KUE_]!-3+X65#XD<G\./^8G_`-LO_9Z[NN$^''_,
M3_[9?^SUW=9X?^&C;%?Q7_70*\UU?_DI4?\`U]6_\DKTJO-=7_Y*5'_U]6_\
MDJ<1\*]1X7XI>AZ511170<P4444`%%%%`!1110!YK\/?^0_/_P!>K?\`H25Z
M57FOP]_Y#\__`%ZM_P"A)7I5<^&_AG3B_P"*%%%%=!S&%XR_Y%.]_P"V?_H:
MU0^'O_(`G_Z^F_\`04J_XR_Y%.]_[9_^AK5#X>_\@"?_`*^F_P#04KG?\=>A
MTK_=WZG64445T',%>:_$+_D/P?\`7JO_`*$]>E5YK\0O^0_!_P!>J_\`H3US
MXG^&=.$_BGI5%%%=!S!1110!YKI'_)2I/^OJX_D]>E5YKI'_`"4J3_KZN/Y/
M7I5<^'^%^ITXKXH^@4445T',87C+_D4[W_MG_P"AK5#X>_\`(`G_`.OIO_04
MJ_XR_P"13O?^V?\`Z&M4/A[_`,@"?_KZ;_T%*YW_`!UZ'2O]W?J=911170<P
M5A>,O^13O?\`MG_Z&M;M87C+_D4[W_MG_P"AK45/@?H:4OXD?5%#X>_\@"?_
M`*^F_P#04KK*Y/X>_P#(`G_Z^F_]!2NLJ:/\-%5_XK"BBBM3$\U^(7_(?@_Z
M]5_]">O2J\U^(7_(?@_Z]5_]">O2JYZ7\29TUOX4/F%%%%=!S!7FNK_\E*C_
M`.OJW_DE>E5YKJ__`"4J/_KZM_Y)7/B/A7J=.%^*7H>E4445T',%4-;_`.0!
MJ/\`UZR_^@FK]4-;_P"0!J/_`%ZR_P#H)J9?"RH?$CD_AQ_S$_\`ME_[/7=U
MPGPX_P"8G_VR_P#9Z[NL\/\`PT;8K^*_ZZ!7FNK_`/)2H_\`KZM_Y)7I5>:Z
MO_R4J/\`Z^K?^25.(^%>H\+\4O0]*HHHKH.8****`"BBB@`HHHH`\U^'O_(?
MG_Z]6_\`0DKTJO-?A[_R'Y_^O5O_`$)*]*KGPW\,Z<7_`!0HHHKH.8PO&7_(
MIWO_`&S_`/0UJA\/?^0!/_U]-_Z"E7_&7_(IWO\`VS_]#6J'P]_Y`$__`%]-
M_P"@I7._XZ]#I7^[OU.LHHHKH.8*\U^(7_(?@_Z]5_\`0GKTJO-?B%_R'X/^
MO5?_`$)ZY\3_``SIPG\4]*HHHKH.8****`/-=(_Y*5)_U]7'\GKTJO-=(_Y*
M5)_U]7'\GKTJN?#_``OU.G%?%'T"BBBN@YC"\9?\BG>_]L__`$-:H?#W_D`3
M_P#7TW_H*5?\9?\`(IWO_;/_`-#6O/\`3O'EOX:T&6UMX1<W[W#D*20D8V*`
M2>_/\(]#R.,\M2:A63?8]'"X:KB:7LZ2N[GKM%>":C\0_$NH^:OV_P"RQ28_
M=VJ!-N,=&^^.G][N>W%9?_"3:_\`]!S4O_`N3_&D\9'HCU8<,8AJ\YI/YL^C
MZPO&7_(IWO\`VS_]#6O(=.^(?B73O*7[?]JBCS^[ND#[LYZM]\]?[W8=N*ZJ
M7XA6?B#PO=65W&+346,81!EDE^922#CY>AX/M@FF\1"<6MM#FK9%B\-)3MS1
M3Z?Y'2_#W_D`3_\`7TW_`*"E=97)_#W_`)`$_P#U]-_Z"E=96M'^&CR*_P#%
M84445J8GFOQ"_P"0_!_UZK_Z$]>E5YK\0O\`D/P?]>J_^A/7I5<]+^),Z:W\
M*'S"BBBN@Y@KS75_^2E1_P#7U;_R2O2J\UU?_DI4?_7U;_R2N?$?"O4Z<+\4
MO0]*HHHKH.8*H:W_`,@#4?\`KUE_]!-7ZH:W_P`@#4?^O67_`-!-3+X65#XD
M<G\./^8G_P!LO_9Z[NN$^''_`#$_^V7_`+/7=UGA_P"&C;%?Q7_70*\UU?\`
MY*5'_P!?5O\`R2O2J\UU?_DI4?\`U]6_\DJ<1\*]1X7XI>AZ511170<P4444
M`%%%%`!1110!YK\/?^0_/_UZM_Z$E>E5YK\/?^0_/_UZM_Z$E>E5SX;^&=.+
M_BA11170<QA>,O\`D4[W_MG_`.AK5#X>_P#(`G_Z^F_]!2K_`(R_Y%.]_P"V
M?_H:U0^'O_(`G_Z^F_\`04KG?\=>ATK_`'=^IUE%%%=!S!7FOQ"_Y#\'_7JO
M_H3UZ57FOQ"_Y#\'_7JO_H3USXG^&=.$_BGI5%%%=!S!1110!YKI'_)2I/\`
MKZN/Y/7I5>:Z1_R4J3_KZN/Y/7I5<^'^%^ITXKXH^@4445T',<3\3]933O#/
MV)2?M%\X5,$C:JD,S=/]T8X^]GM7B->R_$CPQ)JD/]KG46CCM(EC6V,>X$E\
M%@=W!.1V_A%<1I'P\U76[62YM+FR6-)#'^]=@20`>@4^HKSL1&<JEK'VN28O
M!8;").=I-Z[[_P##$'A3P3?^*6,J2+;V*,R/<'#$,`#M"Y!)^8>@QGG/%=[%
M\(]$$2"6^U!I`HWLC(H)[D#:<#VR:[;3=/M]*TVWL+5=L,"!%X`)QU)P`,D\
MD]R35JNFGAH16JNSQL9GV*JU&Z4N6/2WZGB/BWX=W/AZUEU&UN5N=/1ANW_+
M)&"V!D=&'W1D8.3T`KB:^G+Z.VET^YCO2HM'B99B[;1L(.[)[#&>:^8ZY,32
MC!KEZGT>0YA5Q=*2JZN-M>]_UT/9_A3J*7>@75N6S<03[G'/W64!3GWVM^7O
M7>UXW\(Y9!XEO(@["-K,LR`\$ATP2/49/YFO9*[,-*]-'RV=T(T,;*,=GK]X
M4445N>2>:_$+_D/P?]>J_P#H3UZ57FOQ"_Y#\'_7JO\`Z$]>E5STOXDSIK?P
MH?,****Z#F"O-=7_`.2E1_\`7U;_`,DKTJO-=7_Y*5'_`-?5O_)*Y\1\*]3I
MPOQ2]#TJBBBN@Y@JAK?_`"`-1_Z]9?\`T$U?JAK?_(`U'_KUE_\`034R^%E0
M^)')_#C_`)B?_;+_`-GKNZX3X<?\Q/\`[9?^SUW=9X?^&C;%?Q7_`%T"O-=7
M_P"2E1_]?5O_`"2O2J\UU?\`Y*5'_P!?5O\`R2IQ'PKU'A?BEZ'I5%%%=!S!
M1110`4444`%%%%`'FOP]_P"0_/\`]>K?^A)7I5>:_#W_`)#\_P#UZM_Z$E>E
M5SX;^&=.+_BA11170<QA>,O^13O?^V?_`*&M4/A[_P`@"?\`Z^F_]!2K_C+_
M`)%.]_[9_P#H:U0^'O\`R`)_^OIO_04KG?\`'7H=*_W=^IUE%%%=!S!7FOQ"
M_P"0_!_UZK_Z$]>E5YK\0O\`D/P?]>J_^A/7/B?X9TX3^*>E4445T',%%%%`
M'FND?\E*D_Z^KC^3UZ57FND?\E*D_P"OJX_D]>E5SX?X7ZG3BOBCZ!11170<
MQA>,O^13O?\`MG_Z&M4/A[_R`)_^OIO_`$%*O^,O^13O?^V?_H:U0^'O_(`G
M_P"OIO\`T%*YW_'7H=*_W=^IUE,EECAB>65UCC12SNYP%`ZDGL*)98X8GEE=
M8XT4L[N<!0.I)["O%/'/CF3Q!*UA8,T>EHW)Z&X([GT7T'XGG`%U:JIJ[-\N
MRZKCJO+'1+=]O^":7C[Q]]N\W1]'F_T7E;BY0_ZWU53_`'?4_P`7T^]YO179
M:?X&NHM`NM:U6*2W$1406TB[68[P"S`]!R<#J>O3KYLG.K)L^YBL+E6'4=E^
M+?\`7W'5_"325ATZ]U1]IDG<0H"GS(JC)Y]&W#C_`&1^'H]<G\/?^0!/_P!?
M3?\`H*5UE>E05J:/@LPKRKXF=274****U.,\U^(7_(?@_P"O5?\`T)Z]*KS7
MXA?\A^#_`*]5_P#0GKTJN>E_$F=-;^%#YA11170<P5YKJ_\`R4J/_KZM_P"2
M5Z57FNK_`/)2H_\`KZM_Y)7/B/A7J=.%^*7H>E4445T',%4-;_Y`&H_]>LO_
M`*":OU0UO_D`:C_UZR_^@FIE\+*A\2.3^''_`#$_^V7_`+/7=UPGPX_YB?\`
MVR_]GKNZSP_\-&V*_BO^N@5YKJ__`"4J/_KZM_Y)7I5>:ZO_`,E*C_Z^K?\`
MDE3B/A7J/"_%+T/2J***Z#F"BBB@`HHHH`****`/-?A[_P`A^?\`Z]6_]"2O
M2J\U^'O_`"'Y_P#KU;_T)*]*KGPW\,Z<7_%"BBBN@YC"\9?\BG>_]L__`$-:
MH?#W_D`3_P#7TW_H*5?\9?\`(IWO_;/_`-#6J'P]_P"0!/\`]?3?^@I7._XZ
M]#I7^[OU.LHHHKH.8*\U^(7_`"'X/^O5?_0GKTJO-?B%_P`A^#_KU7_T)ZY\
M3_#.G"?Q3TJBBBN@Y@HHHH`\UTC_`)*5)_U]7'\GKTJO-=(_Y*5)_P!?5Q_)
MZ]*KGP_POU.G%?%'T"BBBN@YC"\9?\BG>_\`;/\`]#6J'P]_Y`$__7TW_H*5
M?\9?\BG>_P#;/_T-:H?#W_D`3_\`7TW_`*"E<[_CKT.E?[N_4B^)NHR6'@V6
M./<&NY5MRROM*@Y8_4$*5(]&_"O#*]^\<^';SQ-HD-E9201R)<K*3,Q`P%8=
M@>?F%>??\*DU_P#Y^]-_[^2?_$5AB:<Y3ND?4Y%C<)A\+RU)I2;9I?"_PK;7
M$1U^]C9WCE*6J.F$!&/W@_O'.0.P*GOC'<>,O^13O?\`MG_Z&M/\)Z1<:%X9
ML]-NGB>:'?N:(DJ<NS#&0#T/I3/&7_(IWO\`VS_]#6MU!0HM>1X&.Q4L3C7-
MNZO9>E]"A\/?^0!/_P!?3?\`H*5UE<G\/?\`D`3_`/7TW_H*5UE71_AHXJ_\
M5A1116IB>:_$+_D/P?\`7JO_`*$]>E5YK\0O^0_!_P!>J_\`H3UZ57/2_B3.
MFM_"A\PHHHKH.8*\UU?_`)*5'_U]6_\`)*]*KS75_P#DI4?_`%]6_P#)*Y\1
M\*]3IPOQ2]#TJBBBN@Y@JAK?_(`U'_KUE_\`035^J&M_\@#4?^O67_T$U,OA
M94/B1R?PX_YB?_;+_P!GKNZX3X<?\Q/_`+9?^SUW=9X?^&C;%?Q7_70*\UU?
M_DI4?_7U;_R2O2J\UU?_`)*5'_U]6_\`)*G$?"O4>%^*7H>E4445T',%%%%`
M!1110`4444`>:_#W_D/S_P#7JW_H25Z57FOP]_Y#\_\`UZM_Z$E>E5SX;^&=
M.+_BA11170<QA>,O^13O?^V?_H:U0^'O_(`G_P"OIO\`T%*O^,O^13O?^V?_
M`*&M4/A[_P`@"?\`Z^F_]!2N=_QUZ'2O]W?J=911170<P5YK\0O^0_!_UZK_
M`.A/7I5>:_$+_D/P?]>J_P#H3USXG^&=.$_BGI5%%%=!S!1110!YKI'_`"4J
M3_KZN/Y/7I5>:Z1_R4J3_KZN/Y/7I5<^'^%^ITXKXH^@4445T',87C+_`)%.
M]_[9_P#H:U0^'O\`R`)_^OIO_04J_P",O^13O?\`MG_Z&M4/A[_R`)_^OIO_
M`$%*YW_'7H=*_P!W?J-^(NM:AH7A^WNM-N/(F>Z6-FV*V5*.<88$=0*\R_X6
M-XK_`.@K_P"2\7_Q->B_%"QO-0\-6T5E:SW,@O%8I#&7(&Q^<#MR/SKR;_A&
M=?\`^@'J7_@))_A6&(E44_=N?5Y'2P<L(G6C%N[W2O\`B>X>"]1N]6\)6-]?
M2^;<R^9O?:%SB1@.``.@%.\9?\BG>_\`;/\`]#6H/`5M<6?@K3[>Z@E@F3S-
MT<J%6&9&(R#STJ?QE_R*=[_VS_\`0UKIU]CKV_0^8Q"BL;)0VYG:WJ4/A[_R
M`)_^OIO_`$%*ZRN3^'O_`"`)_P#KZ;_T%*ZRG1_AHPK_`,5A1116IB>:_$+_
M`)#\'_7JO_H3UZ57FOQ"_P"0_!_UZK_Z$]>E5STOXDSIK?PH?,****Z#F"O-
M=7_Y*5'_`-?5O_)*]*KS75_^2E1_]?5O_)*Y\1\*]3IPOQ2]#TJBBBN@Y@JA
MK?\`R`-1_P"O67_T$U?JAK?_`"`-1_Z]9?\`T$U,OA94/B1R?PX_YB?_`&R_
M]GKNZX3X<?\`,3_[9?\`L]=W6>'_`(:-L5_%?]=`KS75_P#DI4?_`%]6_P#)
M*]*KS75_^2E1_P#7U;_R2IQ'PKU'A?BEZ'I5%%%=!S!1110`4444`%%%%`'F
MOP]_Y#\__7JW_H25Z57FOP]_Y#\__7JW_H25Z57/AOX9TXO^*%%%%=!S&%XR
M_P"13O?^V?\`Z&M4/A[_`,@"?_KZ;_T%*O\`C+_D4[W_`+9_^AK5#X>_\@"?
M_KZ;_P!!2N=_QUZ'2O\`=WZG64445T',%>:_$+_D/P?]>J_^A/7I5>:_$+_D
M/P?]>J_^A/7/B?X9TX3^*>E4445T',%%%%`'FND?\E*D_P"OJX_D]>E5YKI'
M_)2I/^OJX_D]>E5SX?X7ZG3BOBCZ!11170<QA>,O^13O?^V?_H:U0^'O_(`G
M_P"OIO\`T%*O^,O^13O?^V?_`*&M4/A[_P`@"?\`Z^F_]!2N=_QUZ'2O]W?J
M=911170<P5A>,O\`D4[W_MG_`.AK6[6%XR_Y%.]_[9_^AK45/@?H:4OXD?5%
M#X>_\@"?_KZ;_P!!2NLKD_A[_P`@"?\`Z^F_]!2NLJ:/\-%5_P"*PHHHK4Q/
M-?B%_P`A^#_KU7_T)Z]*KS7XA?\`(?@_Z]5_]">O2JYZ7\29TUOX4/F%%%%=
M!S!7FNK_`/)2H_\`KZM_Y)7I5>:ZO_R4J/\`Z^K?^25SXCX5ZG3A?BEZ'I5%
M%%=!S!5#6_\`D`:C_P!>LO\`Z":OU0UO_D`:C_UZR_\`H)J9?"RH?$CD_AQ_
MS$_^V7_L]=W7"?#C_F)_]LO_`&>N[K/#_P`-&V*_BO\`KH%>:ZO_`,E*C_Z^
MK?\`DE>E5YKJ_P#R4J/_`*^K?^25.(^%>H\+\4O0]*HHHKH.8****`"BBB@`
MHHHH`\U^'O\`R'Y_^O5O_0DKTJO-?A[_`,A^?_KU;_T)*]*KGPW\,Z<7_%"B
MBBN@YC"\9?\`(IWO_;/_`-#6J'P]_P"0!/\`]?3?^@I5_P`9?\BG>_\`;/\`
M]#6J'P]_Y`$__7TW_H*5SO\`CKT.E?[N_4ZRBBBN@Y@KS7XA?\A^#_KU7_T)
MZ]*KS7XA?\A^#_KU7_T)ZY\3_#.G"?Q3TJBBBN@Y@HHHH`\UTC_DI4G_`%]7
M'\GKTJO-=(_Y*5)_U]7'\GKTJN?#_"_4Z<5\4?0****Z#F,+QE_R*=[_`-L_
M_0UJA\/?^0!/_P!?3?\`H*5?\9?\BG>_]L__`$-:H?#W_D`3_P#7TW_H*5SO
M^.O0Z5_N[]3K****Z#F"L+QE_P`BG>_]L_\`T-:W:PO&7_(IWO\`VS_]#6HJ
M?`_0TI?Q(^J*'P]_Y`$__7TW_H*5UE<G\/?^0!/_`-?3?^@I765-'^&BJ_\`
M%84445J8GFOQ"_Y#\'_7JO\`Z$]>E5YK\0O^0_!_UZK_`.A/7I5<]+^),Z:W
M\*'S"BBBN@Y@KS75_P#DI4?_`%]6_P#)*]*KS75_^2E1_P#7U;_R2N?$?"O4
MZ<+\4O0]*HHHKH.8*H:W_P`@#4?^O67_`-!-7ZH:W_R`-1_Z]9?_`$$U,OA9
M4/B1R?PX_P"8G_VR_P#9Z[NN$^''_,3_`.V7_L]=W6>'_AHVQ7\5_P!=`KS7
M5_\`DI4?_7U;_P`DKTJO-=7_`.2E1_\`7U;_`,DJ<1\*]1X7XI>AZ511170<
MP4444`%%%%`!1110!YK\/?\`D/S_`/7JW_H25Z57FOP]_P"0_/\`]>K?^A)7
MI5<^&_AG3B_XH4445T',87C+_D4[W_MG_P"AK5#X>_\`(`G_`.OIO_04J_XR
M_P"13O?^V?\`Z&M4/A[_`,@"?_KZ;_T%*YW_`!UZ'2O]W?J=911170<P5YK\
M0O\`D/P?]>J_^A/7I5>:_$+_`)#\'_7JO_H3USXG^&=.$_BGI5%%%=!S!111
M0!YKI'_)2I/^OJX_D]>E5YKI'_)2I/\`KZN/Y/7I5<^'^%^ITXKXH^@4445T
M',87C+_D4[W_`+9_^AK5#X>_\@"?_KZ;_P!!2K_C+_D4[W_MG_Z&M4/A[_R`
M)_\`KZ;_`-!2N=_QUZ'2O]W?J=911170<P5A>,O^13O?^V?_`*&M;M87C+_D
M4[W_`+9_^AK45/@?H:4OXD?5%#X>_P#(`G_Z^F_]!2NLKD_A[_R`)_\`KZ;_
M`-!2NLJ:/\-%5_XK"BBBM3$\U^(7_(?@_P"O5?\`T)Z]*KS7XA?\A^#_`*]5
M_P#0GKTJN>E_$F=-;^%#YA11170<P5YKJ_\`R4J/_KZM_P"25Z57FNK_`/)2
MH_\`KZM_Y)7/B/A7J=.%^*7H>E4445T',%4-;_Y`&H_]>LO_`*":OU0UO_D`
M:C_UZR_^@FIE\+*A\2.3^''_`#$_^V7_`+/7=UPGPX_YB?\`VR_]GKNZSP_\
M-&V*_BO^N@5YKJ__`"4J/_KZM_Y)7I5>:ZO_`,E*C_Z^K?\`DE3B/A7J/"_%
M+T/2J***Z#F"BBB@`HHHH`****`/-?A[_P`A^?\`Z]6_]"2O2J\U^'O_`"'Y
M_P#KU;_T)*]*KGPW\,Z<7_%"BBBN@YC"\9?\BG>_]L__`$-:H?#W_D`3_P#7
MTW_H*5?\9?\`(IWO_;/_`-#6J'P]_P"0!/\`]?3?^@I7._XZ]#I7^[OU.LHH
MHKH.8*\U^(7_`"'X/^O5?_0GKTJO-?B%_P`A^#_KU7_T)ZY\3_#.G"?Q3TJB
MBBN@Y@HHHH`\UTC_`)*5)_U]7'\GKTJO-=(_Y*5)_P!?5Q_)Z]*KGP_POU.G
M%?%'T"BBBN@YC"\9?\BG>_\`;/\`]#6J'P]_Y`$__7TW_H*5?\9?\BG>_P#;
M/_T-:H?#W_D`3_\`7TW_`*"E<[_CKT.E?[N_4ZRBBBN@Y@K"\9?\BG>_]L__
M`$-:W:PO&7_(IWO_`&S_`/0UJ*GP/T-*7\2/JBA\/?\`D`3_`/7TW_H*5UE<
MG\/?^0!/_P!?3?\`H*5UE31_AHJO_%84445J8GFOQ"_Y#\'_`%ZK_P"A/7I5
M>:_$+_D/P?\`7JO_`*$]>E5STOXDSIK?PH?,****Z#F"O-=7_P"2E1_]?5O_
M`"2O2J\UU?\`Y*5'_P!?5O\`R2N?$?"O4Z<+\4O0]*HHHKH.8*H:W_R`-1_Z
M]9?_`$$U?JAK?_(`U'_KUE_]!-3+X65#XD<G\./^8G_VR_\`9Z[NN$^''_,3
M_P"V7_L]=W6>'_AHVQ7\5_UT"O-=7_Y*5'_U]6_\DKTJO-=7_P"2E1_]?5O_
M`"2IQ'PKU'A?BEZ'I5%%%=!S!1110`4444`%%%%`'EEOX7\3VDADMK>6%R-I
M:.Y121Z9#59_LCQK_P`];W_P.'_Q=>E45SK#16S9U/%R>Z1YK_9'C7_GK>_^
M!P_^+H_LCQK_`,];W_P.'_Q=>E44?5X]V+ZU+^5'F4V@^,+F)HI_M4L;=4>\
M5@>_0M3;?P]XMM(S';)<0H3N*QW:J"?7`:O3Z*/JT=[L?UN5K61YK_9'C7_G
MK>_^!P_^+H_LCQK_`,];W_P.'_Q=>E44?5X]V+ZU+^5'FO\`9'C7_GK>_P#@
M</\`XNJUQX7\3W<@DN;>69P-H:2Y1B!Z9+5ZG10\-%[MC6+DMDCS7^R/&O\`
MSUO?_`X?_%T?V1XU_P">M[_X'#_XNO2J*/J\>[%]:E_*CS7^R/&O_/6]_P#`
MX?\`Q=']D>-?^>M[_P"!P_\`BZ]*HH^KQ[L/K4OY4>6)X7\3QW/VE+>5;@DM
MYJW*!LGJ<[L\Y-6?[(\:_P#/6]_\#A_\77I5%"PT5U8WBY/=(\U_LCQK_P`]
M;W_P.'_Q=']D>-?^>M[_`.!P_P#BZ]*HH^KQ[L7UJ7\J/,IM!\87,313_:I8
MVZH]XK`]^A:FV_A[Q;:1F.V2XA0G<5CNU4$^N`U>GT4?5H[W8_K<K6LCS7^R
M/&O_`#UO?_`X?_%T?V1XU_YZWO\`X'#_`.+KTJBCZO'NQ?6I?RH\U_LCQK_S
MUO?_``.'_P`73)M!\87,313_`&J6-NJ/>*P/?H6KTVBCZM'NQ_6I=D>86_A[
MQ;:1F.V2XA0G<5CNU4$^N`U2_P!D>-?^>M[_`.!P_P#BZ]*HH^K1[L/K<GT1
MYK_9'C7_`)ZWO_@</_BZ/[(\:_\`/6]_\#A_\77I5%'U>/=B^M2_E1Y9<>%_
M$]W()+FWEF<#:&DN48@>F2U6?[(\:_\`/6]_\#A_\77I5%'U:/=C^MR[(\U_
MLCQK_P`];W_P.'_Q=']D>-?^>M[_`.!P_P#BZ]*HH^KQ[L7UJ7\J/-?[(\:_
M\];W_P`#A_\`%U6?POXGDN?M+V\K7`(;S6N4+9'0YW9XP*]3HH>&B^K&L7);
M)'FO]D>-?^>M[_X'#_XNC^R/&O\`SUO?_`X?_%UZ511]7CW8OK4OY4>:_P!D
M>-?^>M[_`.!P_P#BZ:^B^,I8VCD:[=&!5E:]!!!Z@C=7IE%'U>/=C^M2[(\N
MMO#7BJSW?98IX-^-WE72KG'3.&]ZG_LCQK_SUO?_``.'_P`77I5%'U:*ZL'B
MY/=(\U_LCQK_`,];W_P.'_Q=%CX:\0_V[:7EY;N^R>-Y)'G1C@$?[63P*]*H
MH^KQ[L7UJ5MD%%%%=!S!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`'/ZEXW\.Z1J$MC?:AY5S%C>GDR-C(!'(4CH153_A9/A+_`*"W_DM+
M_P#$U8U?P;X9U"ZN-4U2R5I2NZ:9[AT`"J!DX8```?I7G5GX6TSQCXA*Z#8-
M8:#:-MFO"[L\Y]%#DX/IQP#ENH6O3H4<)4A>7,K+5Z6_KL9R<DSV"*^M9M.3
M4%F46CQ"82O\HV$;MQST&.>:Y^7XB^%(9GB;5U+(Q4E(9&&1Z$+@CW'%<E\1
MIK@WVB>#--/V>UDCB4`R':V6V1JW!.%VYZG.<XR!711_"[PNED;=K:>24J1]
MI:=O,!.<'`PN1V^7''.:A4,/""G6;][9*VWF'-)NR.NMKJWO;=;BUGBGA?.V
M2)PRM@X."..HK,M/%.B7VLRZ1;WZM?Q,ZM"R,IRIPP!(`)'/0G@$]!7GG@IK
M[PI\0KCPK)<?:+:;=]TX4-L\Q7P1P=HP0#WZG:*Y34;>^;QGK][IYQ-IUW->
M9"[B`LX&0,$'!8$YXP#6T,NA*<HN6EDT_7:XG4=CW;6-;T[0;1+K4[CR(7D$
M:ML9LL03C"@GH#45]XDTC3=)MM4N[OR[*YV^3+Y;G=N4LO`&1P">17`_$#6[
M7Q!\.M-U"U92)+U!)&K9,3^6^Y#P.1].1@]"*;XX_P"23>&_^W;_`-$-6=+!
M1:ASW3;:?R&Y[V.J_P"%D^$O^@M_Y+2__$UK:+XDTCQ#Y_\`9=W]H\C;YG[M
MTV[LX^\!Z&O--+_X5A_9-E_:'_'[Y"?:/^/G_6;1NZ<=<].*[OP;;>&%M+FZ
M\,)B&201S-F7EE&0,2<\!^WK2Q.'HTX-QC-/S2L$9-OH=!=7,-E:375P^R&&
M-I)&P3M4#).!ST%9]CXDTC4M)N=4M+OS+*VW>=+Y;C;M4,W!&3P0>!1XG_Y%
M+6?^O&?_`-%M7G_@?_DDWB3_`+>?_1"UE1P\9T7-[W2^\IR:=CT+1O$&E>((
M99=+O%N%B8*X"LI4GID,`<'UZ<'T--OO$FD:;JUMI=W=^7>W.WR8O+<[MS%5
MY`P.01R:\4\&WUQX:U"RU]_^0;/.]C<,`3M&$8Y^4^H8`<G8PKJ/&<L<_P`5
M/#$T,BR1R+:LCH<A@9V((/<5USRZ,:_)=\MF_FNA"J-JYWNL>+M#T&[2UU.^
M\B9XQ(J^4[94DC.54CJ#6?\`\+)\)?\`06_\EI?_`(FN*^)GV3_A8>D?VA_Q
MY>1#]HZ_ZOS7W=.>F>G-6_\`BTO^?M5*&#H^RC.49MM?9LP<W=K0]-BOK6;3
MDU!9E%H\0F$K_*-A&[<<]!CGFN?E^(OA2&9XFU=2R,5)2&1AD>A"X(]QQ7)?
M$::X-]HG@S33]GM9(XE`,AVMEMD:MP3A=N>ISG.,@5T4?PN\+I9&W:VGDE*D
M?:6G;S`3G!P,+D=OEQQSFL50P\(*=9OWMDK;>8^:3=D==;75O>VZW%K/%/"^
M=LD3AE;!P<$<=14M>2>"FOO"GQ"N/"LEQ]HMIMWW3A0VSS%?!'!VC!`/?J=H
MKUNL,50]C.R=TU=/R949704445S%!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`>3^//&$&K:BWAB&Z6
MSL%EV7UY)$S\J<E54#.`1^)`Y"Y)W=%\7^!-`TR.PL-1V1)R6-O*6=N[,=G)
M/_UA@`"M:Z^'_A>]NYKJXTS?--(TDC?:)1N8G).`V.IJ'_A6WA+_`*!/_DS+
M_P#%5ZCKX.5)4WS)+M;5]S.T[W.5^(T-P+[1/&>FC[1:QQQ,"8SM7#;XV;D'
M#;L=!C&,Y(KH+;XI>&Y=,6YGGEAN?++/:>4S,&'\(8#:<]CD=1G';K8K&UAT
MY-/6%3:)$(1$_P`PV`;=ISU&..:Y^7X=>%)IGE;2%#.Q8A)I%&3Z`-@#V'%1
M'$8><%"LG[NS5MO,.62=T<9X*6^\5_$*X\526_V>VAW?=&5+;/+5,D\G:<D@
M=N@W"G^#(HY_BIXGAFC62.1;I71QD,#.H(([BO4[:UM[*W6WM8(H(4SMCB0*
MJY.3@#CJ:S['PWI&FZM<ZI:6GEWMSN\Z7S'.[<P9N"<#D`\"G+'1ESZ6322\
MK!R;'BGC*QN/#6H7N@)_R#9YTOK=22=HPZC'S'U*DGD[%-=7XX_Y)-X;_P"W
M;_T0U>@:UX;TCQ#Y']J6GVCR-WE_O'3;NQG[I'H*+[PWI&I:3;:7=VGF65MM
M\F+S'&W:I5>0<G@D<FM?[1A+V;DG>+N_/H+V;UL>::7_`,*P_LFR_M#_`(_?
M(3[1_P`?/^LVC=TXZYZ<5W?@VY\,-:7-KX8?,,<@DF7$O#,,`YDYY"=O2H?^
M%;>$O^@3_P"3,O\`\56MHOAO2/#WG_V7:?9_/V^9^\=]VW./O$^IK'$XBC4@
MU&4V_-JPXQ:?0/$__(I:S_UXS_\`HMJ\_P#`_P#R2;Q)_P!O/_HA:]0NK:&]
MM)K6X3?#-&T<BY(W*1@C(YZ&L^Q\-Z1INDW.EVEIY=E<[O.B\QSNW*%;DG(X
M`'!K*CB(PHN#WNG]Q3BV[G`_#_1+7Q!\.M2T^Z52)+US'(RY,3^6FUQR.1]>
M1D=":XS3KB^;QGH%EJ`Q-IUW#9X+;B`LY."<D'!8@8XP!7NVCZ)IV@VCVNF6
M_D0O(9&7>S98@#.6)/0"JEQX1T.[UM=9GL=^H+(D@F\UQ\R8VG`;'&T=JZX9
MC!5*C:?++;R>Q#INR//_`(A6T-[\3M"M;A-\,T=O'(N2-RF9P1D<]#78?\*V
M\)?]`G_R9E_^*K6OO#>D:EJUMJEW:>9>VVWR9?,<;=K%EX!P>23R*U:YJF,E
M[.$*<FK+7H4H*[;/+_BA87UCK6E^*+6/S8[38K@KE8V1]R%L'.&+8[=.O(K;
MMOBEX;ETQ;F>>6&Y\LL]IY3,P8?PA@-ISV.1U&<=NREBCGA>&:-9(Y%*NCC(
M8'@@CN*YJ7X=>%)IGE;2%#.Q8A)I%&3Z`-@#V'%5#$4)TXPKI^[LUV\[@XR3
MO$XSP4M]XK^(5QXJDM_L]M#N^Z,J6V>6J9)Y.TY)`[=!N%>MU%;6MO96ZV]K
M!%!"F=L<2!57)R<`<=34M88JO[:=TK)*R7DAQC9!1117,4%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
D4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110!__9
`

#End
