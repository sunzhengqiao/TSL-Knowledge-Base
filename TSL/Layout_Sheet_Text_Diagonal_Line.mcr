#Version 8
#BeginDescription

MK: 10-8-04: Places a single diagonal line on the sheets. Use the prop dialog to show the text by setting the height and setting a colour. If the colour is set to 0, then the text will not appear.



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
Unit(1,"mm"); // script uses mm

int nPrec = 0; // precision (only used for beam length, others depend on hsb_settings)

PropString strDimStyle(0,_DimStyles, "Dim Style");
PropDouble dbTH(1,1,"Text Heigth");
PropInt iColor(2,3,"Color");
PropInt iColorDia(3,1,"Color Diagonal");

if (_bOnInsert) {
  Viewport vp = getViewport("Select the viewport from which the element, and possibly active zone is taken"); // select viewport
  _Viewport.append(vp);

  return;

}

// set the diameter of the 3 circles, shown during dragging
setMarbleDiameter(U(4));

Display dp(1); // use color red
// dp.dimStyle("ISO-25"); // dimstyle was adjusted for display in paper space, sets textHeight


// do something for the last appended viewport only
if (_Viewport.length()==0) return; // _Viewport array has some elements
Viewport vp = _Viewport[_Viewport.length()-1]; // take last element of array
_Viewport[0] = vp; // make sure the connection to the first one is lost

// check if the viewport has hsb data
if (!vp.element().bIsValid()) return;

dp.dimStyle(strDimStyle); // dimstyle was adjusted for display in paper space, sets textHeight

dp.textHeight(dbTH);
dp.color(iColor);

CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps
Element el = vp.element();
int nZoneIndex = vp.activeZoneIndex();

// collect the items
Sheet arSheet[0];
  arSheet = el.sheet(nZoneIndex);


for (int i=0; i<arSheet.length(); i++) {
  // loop over list items
  	Sheet sh = arSheet[i];

	if (_bOnDebug) {
		Body bd = sh.envelopeBody();
   		bd.transformBy(ms2ps);
		bd.vis();
 	}


    PLine plEnv = sh.plEnvelope();
    Point3d ptEnv[] = plEnv.vertexPoints(1);

    for (int j=0;j<ptEnv.length();j++){
    	ptEnv[j].transformBy(ms2ps);
    }

    double XMin = ptEnv[0].X();
    double YMin = ptEnv[0].Y();
    double XMax = ptEnv[0].X();
    double YMax = ptEnv[0].Y();

    Point3d ptMin;
	Point3d ptMax;

    for (int j=0;j<ptEnv.length();j++){
	if(ptEnv[j].X()<XMin){
		XMin = ptEnv[j].X();
	}    	

	if(ptEnv[j].Y()<YMin){
		YMin = ptEnv[j].Y();
	}    	

	if(ptEnv[j].X()>XMax){
		XMax = ptEnv[j].X();
	}    	

	if(ptEnv[j].Y()>YMax){
		YMax = ptEnv[j].Y();
	}    	

    }
	

    ptMin.setX(XMin);
    ptMin.setY(YMin);

    ptMax.setX(XMax);
    ptMax.setY(YMax);

	if(iColorDia>0){
		dp.color(iColorDia);
		PLine plDia(ptMin,ptMax);
		dp.draw(plDia);
	}

	if(iColor>0){

    		Point3d ptCenter=sh.ptCen();
    		ptCenter.transformBy(ms2ps);

		ptCenter.setX((XMin+XMax)/2);
		ptCenter.setY((YMin+YMax)/2);

		
		double  dbBr=U(sh.solidWidth());
		double  dbH=U(sh.solidLength());
		
		String strLength;
		strLength.formatUnit(sh.dL(), strDimStyle);
		String strWidth;
		strWidth.formatUnit(sh.dW(), strDimStyle);
		String strText;
		strText = strWidth+"x"+strLength;
		
		dp.color(iColor);

		if(dbBr>dbH){
			dp.draw(strText,ptCenter,_XW,_YW,0,0);
		}
		else{
			dp.draw(strText,ptCenter,_YW,-_XW,0,0);

		}
	}
}
 







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
M!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4
M`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!
M0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`
M%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0
M`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%
M`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`
M4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`
M!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4
M`%`!0`4`%`!0`4`%`!0`4`%`!0`4`2,54@>6IX!R2?3ZU*N^OY`)O7_GFGYG
M_&G9]_R_R`-Z_P#/-/S/^-%GW_+_`"`-Z_\`/-/S/^-%GW_+_(`WK_SS3\S_
M`(T6??\`+_(`WK_SS3\S_C19]_R_R`-Z_P#/-/S/^-%GW_+_`"`-Z_\`/-/S
M/^-%GW_+_(`WK_SS3\S_`(T6??\`+_(`WK_SS3\S_C19]_R_R`-Z_P#/-/S/
M^-%GW_+_`"`-Z_\`/-/S/^-%GW_+_(`WK_SS3\S_`(T6??\`+_(`WK_SS3\S
M_C19]_R_R`<A5B<QKP">I]/K4NZZ_E_D-(;O7_GFGYG_`!JK/O\`E_D(-Z_\
M\T_,_P"-%GW_`"_R`-Z_\\T_,_XT6??\O\@#>O\`SS3\S_C19]_R_P`@#>O_
M`#S3\S_C19]_R_R`-Z_\\T_,_P"-%GW_`"_R`-Z_\\T_,_XT6??\O\@#>O\`
MSS3\S_C19]_R_P`@#>#_`,LE_7_&E;S_`"_R'N+N4=8T_`G_`!HL^[_#_(=D
MMQ6*@*1&O(SU/J?>A)]_R_R$-WK_`,\T_,_XT[/O^7^0@WK_`,\T_,_XT6??
M\O\`(`WK_P`\T_,_XT6??\O\@#>O_/-/S/\`C19]_P`O\@#>O_/-/S/^-%GW
M_+_(`WK_`,\T_,_XT6??\O\`(`WK_P`\T_,_XT6??\O\@#>O_/-/S/\`C19]
M_P`O\@#>O_/-/S/^-%GW_+_(`WK_`,\T_,_XT6??\O\`(`WK_P`\T_,_XT6?
M?\O\@#>O_/-/S/\`C19]_P`O\@#>O_/-/S/^-%GW_+_(`WK_`,\T_,_XT6??
M\O\`(`WK_P`\T_,_XT6??\O\@#>O_/-/S/\`C19]_P`O\@%<#RU8*%))SC/M
M26XVK$=4(*`'R_>'^ZO\A2CM]_Y@,I@%`!0`4`%`!0`4`%`!0`4`%`!0`4`2
M1\''^RQ_0U+_`,OS*V5OZ_K_`#(ZHD*`"@`H`*`"@!0":!I7#@>](>B\PR:8
MKB4"'O\`=C_W?ZFDMW_71`,I@%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`H&
M30-*[',<Q*?]H_TJ5O\`)?J#=]1E4(*`'R_>'^ZO\A2CM]_Y@,I@%`!0`4`%
M`!0`4`%`!0`4`%`$QBSA1@$$`D'_`#T-.QFI=1H0,01D`YX)].:"M;V]/QT)
M(E#'CC<.,]N&']*EK3YK\P<G?T3_`$(F`VD@$8."":H$W<2/&3D9X/\`*A#E
M_D/(&-H/.,]/;/6@F[W_`*[;$:C)_`TBF*B[F4'@$XH&[I7'@*V"N,`]QT_4
MYZ=S3(O9:[^O_`T$W;G`7'X@?R[4#Z:_F(22^Y5ZG`XH#I9BEANZ#`X)"@__
M`%O_`*U`K:?\'^F/X#[-F,GK@'T]1^...M`NE[_U]_\`F-=1Y2-Z+T[]3^G_
M`.JI77^NB+OK8#C(3;N.0,`8Q[9ZGTJB==_^"+\IY&#PPSC';TH%K^7YD-(T
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`%Z+]:16R]?Z_KT''_4K_`+Q_I1U^[]21
ME,`H`?+]X?[J_P`A2CM]_P"8#*8!0`4`%`!0`4`%`!0`4`%`!0`N3G.>OZT"
ML/,C'YCVZ<FBX**2?]?UU%5RSDD_PD?H:4O\OS!)(C+$@`DG'2F%D`8J<@D?
M2@&D]Q<L%VEB!Z47*Y5N_P#@B9QT_.D.]MOZ_K^F)UID[CM[$@[CD=.:!60A
M9B<DDGZT!9!DC'/2@8!BIR"1]*!-)[@&(!`)&>M`60]R=L?/\/\`4TEN_P"N
MB&-+L1@L2/<TQ62#>V<[CGUS0%D(3DY-`Q*`"@`H`*`"@`H`*`"@`H`*`"@`
MZT!N*>M`V./^I7_>/]*77[OU$,I@%`#Y?O#_`'5_D*4=OO\`S`93`*`"@`H`
M*`"@`H`*`"@`H`*`"@!3T`I%/:PZ$$O@<G:?Y&E+;[OS)%\EQU1_P%',NY5K
M;AY<O:-Q^!HNNX7?03RI/^>;_E3YEW)#RI/^>;_E1S+N`>5)_P`\W_*CF7<`
M\J3_`)YO^5',NX!Y4G_/-_RHYEW`/*D_YYO^5',NX!Y4G_/-_P`J.9=P#RI/
M^>;_`)4<R[@+*"HC!!!V]#]32CK?^NB`CJ@"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@!1T)I%+O_6HE,D>?]2O^\?Z4NOW?J`RF`4`/E^\/]U?Y"E';[_S`93`
M*`"@`H`*`"@`H`*`"@`H`*`%`R:!I78$Y.:`;N[CHOO'_=;^1I2V^[\Q#*8!
M0`4`%`!0`4`%`!0`4`%`#W^['_N_U-);O^NB`93`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`%/I2*?82F2//\`J5_WC_2EU^[]0&4P"@!\OWA_NK_(4H[??^8#
M*8!0`4`%`!0`4`%`!0`4`%`!0`HX!/X4BEHK_P!?U_F)3)'Q?>/^ZW\C2EM]
MWY@,I@%`!0`4`%`!0`4`%`!0`4`/?[L?^[_4TEN_ZZ(!E,`H`*`"@`H`*`"@
M`H`*`"@`H`*`"@!1USZ4#6XE`@H`>?\`4K_O'^E+K]WZ@,I@%`#Y?O#_`'5_
MD*4=OO\`S`93`*`"@`H`*`"@`H`*`"@`H`*`%/8>E(I]A*9(^+[Q_P!UOY&E
M+;[OS`93`*`"@`H`*`"@`H`*`"@`H`>_W8_]W^II+=_UT0#*8!0`4`%`!0`4
M`%`!0`4`%`!0`4`%`"]%^M(K9"4R0H`>?]2O^\?Z4NOW?J`RF`4`/E^\/]U?
MY"E';[_S`93`*`"@`H`*`"@`H`*`"@`H`4=:!H3K0+<*`'Q?>/\`NM_(TI;?
M=^8#*8!0`4`%`!0`4`%`!0`4`%`#W^['_N_U-);O^NB`93`*`"@`H`*`"@`H
M`*`"@`H`*`"@!0,F@:5V!.30#=Q*!!0`\_ZE?]X_TI=?N_4!E,`H`?+]X?[J
M_P`A2CM]_P"8#*8!0`4`%`!0`4`%`!0`4`%`"_P_6D5T_K^NPE,D*`'Q?>/^
MZW\C2EM]WY@,I@%`!0`4`%`!0`4`%`!0`4`/?[L?^[_4TEN_ZZ(!E,`H`*`"
M@`H`*`"@`H`*`"@`H`*`%'`)_"D4M%?^OZ_S$IDA0`4`//\`J5_WC_2EU^[]
M0&4P"@!\OWA_NK_(4H[??^8#*8!0`4`%`!0`4`%`!0`4`%`"MUQZ4D5+>PE,
MD*`'Q?>/^ZW\C2EM]WY@,I@%`!0`4`%`!0`4`%`!0`4`/?[L?^[_`%-);O\`
MKH@&4P"@`H`*`"@`H`*`"@`H`*`"@`H`4^GI0-]A*!!0`4`//^I7_>/]*77[
MOU`93`*`'R_>'^ZO\A2CM]_Y@,I@%`!0`4`%`!0`4`%`!0`J]<^E)E1WN)3)
M"@`H`?%]X_[K?R-*6WW?F`RF`4`%`!0`4`%`!0`4`%`!0`]_NQ_[O]326[_K
MH@&4P"@`H`*`"@`H`*`"@`H`*`"@!1Z^E(I=Q*9(4`%`!0`\_P"I7_>/]*77
M[OU`93`*`'R_>'^ZO\A2CM]_Y@,I@%`!0`4`%`!0`\1G.#@'.`/4T[$\R&4B
M@H`7^'ZTBNG]?UW$IDA0`4`/B^\?]UOY&E+;[OS`93`*`"@`H`*`"@`H`*`"
M@`H`>_W8_P#=_J:2W?\`71`,I@%`!0`4`%`!0`4`/5-PSGIG/Y9_6F2W81@!
M@CH1GFD-,;0,*`%/``I%/16$IDA0`4`%`#S_`*E?]X_TI=?N_4!E,`H`?+]X
M?[J_R%*.WW_F`RF`4`%`!0`4`%`$PW<*6[X7C/IW_+!IF>F_WD-(T#K0&XIZ
MT#8E`@H`*`'Q?>/^ZW\C2EM]WY@,I@%`!0`4`%`!0`4`%`!0`4`/?[L?^[_4
MTEN_ZZ(!E,`H`*`"@`H`*`"@"2+KD-@\]\9]/UIHF0DG+9[XYYS0PCL,I%"@
M9-`TK@3DYH!N[N)0(*`"@`H`>?\`4K_O'^E+K]WZ@,I@%`#Y?O#_`'5_D*4=
MOO\`S`93`*`"@`H`*`"@"8%?+;!;`'3=_P#6IF;3OT^XAI&@H[GTI%+N)3)"
M@`H`*`'Q?>/^ZW\C2EM]WY@,I@%`!0`4`%`!0`4`%`!0`4`/?[L?^[_4TEN_
MZZ(!E,`H`*`"@`H`*`"@!Z;<'<F??TIDN_1B28+DJ,#MCO0QQVU&TAB]%^M(
MK9>O]?UZ"4R0H`*`"@`H`>?]2O\`O'^E+K]WZ@,I@%`#Y?O#_=7^0I1V^_\`
M,!E,`H`*`"@`H`*`)<QEQT`!].WI]?\`.:>A&MOZW(J18IX`'XTBGHK?U_7^
M8E,D*`"@`H`?%]X_[K?R-*6WW?F`RF`4`%`!0`4`%`!0`4`%`!0`]_NQ_P"[
M_4TEN_ZZ(!E,`H`*`"@`H`*`"@"1&XQC.,_J,4R6OT$?'R@9X'?ZF@%U&=:1
M6XIZ^U`WN)0(*`"@`H`*`'G_`%*_[Q_I2Z_=^H#*8!0`^7[P_P!U?Y"E';[_
M`,P&4P"@`H`*`"@`H`E`*J,CIGG(R/I].O\`AUID73?]:_U_5]B,#)Q2-$KN
MP$Y-`-W8E`@H`*`"@!\7WC_NM_(TI;?=^8#*8!0`4`%`!0`4`%`!0`4`%`#W
M^['_`+O]326[_KH@&4P"@`H`*`"@`H`*`'HK$%EQQW)Z4R6ULPD!#D'!/J.]
M#".J&C@$U)HM-1*9(4`%`!0`4`%`#S_J5_WC_2EU^[]0&4P"@!\OWA_NK_(4
MH[??^8#*8!0`4`%`!0`4`3-NWJ!@'=U_VN,TS-6L_3\"(=":DV6UQ*9(4`%`
M!0`4`/B^\?\`=;^1I2V^[\P&4P"@`H`*`"@`H`*`"@`H`*`'O]V/_=_J:2W?
M]=$`RF`4`%`!0`4`%`!0!)&N>1G//3Z?U_SFFB)/^OZ[#7Y(;^]SS0REV["'
MTJ2WV$IDA0`4`%`!0`4`//\`J5_WC_2EU^[]0&4P"@!\OWA_NK_(4H[??^8#
M*8!0`4`%`!0`4`2KY@;)Y]LCK_C^M/4A\K_I_P!6_`C/0"I-7M82F2%`!0`4
M`%`#XOO'_=;^1I2V^[\P&4P"@`H`*`"@`H`*`"@`H`*`'O\`=C_W?ZFDMW_7
M1`,I@%`!0`4`%`!0`4`/12P(#`>W/-,ENW05QB0Y(..IY_K28Z>U_F1T#"@`
MH`*`"@`H`*`'G_4K_O'^E+K]WZ@,I@%`#Y?O#_=7^0I1V^_\P&4P"@`H`*`"
M@`H`G"_O!EN=V.G?OW_SZ4R%JO*WX?U_PY"3DYI&C=W<2@04`%`!0`4`/B^\
M?]UOY&E+;[OS`93`*`"@`H`*`"@`H`*`"@`H`>_W8_\`=_J:2W?]=$`RF`4`
M%`!0`4`%`!0`]0NW+9Z]O\]Z9+;OI_7_``P/CC&?FY.?\_C2*3TMYC*`"@`H
M`*`"@`H`*`'G_4K_`+Q_I2Z_=^H#*8!0`^7[P_W5_D*4=OO_`#`93`*`"@`H
M`*`"@"Q@CN>N,_\`LW_U_P!:9GTO_G]W_`\]BO2-`H`*`"@`H`*`'Q?>/^ZW
M\C2EM]WY@,I@%`!0`4`%`!0`4`%`!0`4`/?[L?\`N_U-);O^NB`93`*`"@`H
M`*`"@`H`D3&,94'OD9_H:8K7?^7_``Z$DP2"/3L.#2!#*!A0`4`%`!0`4`%`
M#S_J5_WC_2EU^[]0&4P"@!\OWA_NK_(4H[??^8#*8!0`4`%`!0`4`*>P]*13
M["4R0H`*`"@`H`*`'Q?>/^ZW\C2EM]WY@,I@%`!0`4`%`!0`4`%`!0`4`/?[
ML?\`N_U-);O^NB`93`*`"@`H`*`"@`H`>KLJ$!B,GM1<.56NQK,6QN.<>M`D
MDMA*!A0`4`%`!0`4`%`#S_J5_P!X_P!*77[OU`93`*`'R_>'^ZO\A2CM]_Y@
M,I@%`!0`4`%`"CK[4#6XNYO[Q_.@35W<;0`4`%`!0`4`%`#XOO'_`'6_D:4M
MON_,!E,`H`*`"@`H`*`"@`H`*`"@![_=C_W?ZFDMW_71`,I@%`!0`4`%`!0`
M4`.)`/0'C%"'(0G)Z8]A0(2@`H`*`"@`H`*`"@!Y_P!2O^\?Z4NOW?J`RF`4
M`/E^\/\`=7^0I1V^_P#,!E,`H`*`"@`H`7^'ZTBNG]?UV)0%X(V[2><D9`X_
M'UZ51CK_`%W(:1H%`!0`4`%`!0`^+[Q_W6_D:4MON_,!E,`H`*`"@`H`*`"@
M`H`*`"@![_=C_P!W^II+=_UT0#*8!0`4`%`!0`4`*..?2D4NXY$W].>N0/\`
M/>J,V[".NTCJ..AZBD-.XV@84`%`!0`4`%`!0`\_ZE?]X_TI=?N_4!E,`H`?
M+]X?[J_R%*.WW_F`RF`4`%`!0`4`*W7'I214NW8<)2""`O'^R*JYGRKS^\92
M*"@`H`*`"@`H`?%]X_[K?R-*6WW?F`RF`4`%`!0`4`%`!0`4`%`!0`]_NQ_[
MO]326[_KH@&4P"@`H`*`"@`H`4\`"D4]%84;<?,"3[&F0[]`8J<;1C`[T`K]
M1M`PH`*`"@`H`*`"@!Y_U*_[Q_I2Z_=^H#*8!0`^7[P_W5_D*4=OO_,!E,`H
M`*`"@!5ZY]*3*CO<2F22*@('!.>I'0?7^=.Q#E;^MR.D6%`!0`4`%`!0`^+[
MQ_W6_D:4MON_,!E,`H`*`"@`H`*`"@`H`*`"@![_`'8_]W^II+=_UT0#*8!0
M`4`%`!0`HZ^U`UN)UH%N*JYSS@#J30)NP,N,<Y!Z$4`G<2@84`%`!0`4`%`!
M0`\_ZE?]X_TI=?N_4!E,`H`?+]X?[J_R%*.WW_F`RF`4`%`!0`O1?K2*V0E,
MDE54)7C!/0,>OZ4R&W_7_#D;#:<4BD[B4#"@`H`*`"@!\7WC_NM_(TI;?=^8
M#*8!0`4`%`!0`4`%`!0`4`%`#W^['_N_U-);O^NB`93`*`"@`H`*`%Z#ZTBM
MEZ_U_7H)3)'Q@$]2#]`1^IIHF0L@/!ZCUX_ITH81?]?\.1TB@H`*`"@`H`*`
M"@!Y_P!2O^\?Z4NOW?J`RF`4`/E^\/\`=7^0I1V^_P#,!E,`H`*`"@!3U^E"
M'+<2@1-&0-BG.6/!&..?I31G+J_Z_,C?[WU`-)EQV&T#"@`H`*`"@!\7WC_N
MM_(TI;?=^8#*8!0`4`%`!0`4`%`!0`4`%`#W^['_`+O]326[_KH@&4P"@`H`
M*`#K0&XIZ^U`WN)0(?'WSTQS31,ATG$8Q@K]?K[#W_SU&*._]>7_``"*D6%`
M!0`4`%`!0`4`//\`J5_WC_2EU^[]0&4P"@!\OWA_NK_(4H[??^8#*8!0`4`*
M.Y]*12[B4R0H`G3[C!,MQTR?Y#_Z],S>^NG]=R$G)R:1H)0`4`%`!0`4`/B^
M\?\`=;^1I2V^[\P&4P"@`H`*`"@`H`*`"@`H`*`'O]V/_=_J:2W?]=$`RF`4
M`%`!0`HX!-(I:*XE,D*`'Q@\GC&.1U_3_(]Z:)D+*<$H.@/I_P#7-#"*ZD=(
MH*`"@`H`*`"@`H`>?]2O^\?Z4NOW?J`RF`4`/E^\/]U?Y"E';[_S`93`*`"@
M!3P,4BGHA*9(4`%`!0`4`%`!0`4`%`#XOO'_`'6_D:4MON_,!E,`H`*`"@`H
M`*`"@`H`*`"@![_=C_W?ZFDMW_71`,I@%`!0`4`*>./2D4^PE,D*`%!P<B@`
M+%CDDGZT"22V$H&%`!0`4`%`!0`4`//^I7_>/]*77[OU`93`*`'R_>'^ZO\`
M(4H[??\`F`RF`4`*!DXH&E=V`G)H!N[$H$%`!0`4`%`!0`4`%`!0`^+[Q_W6
M_D:4MON_,!E,`H`*`"@`H`*`"@`H`*`"@![_`'8_]W^II+=_UT0#*8!0`4`*
M.OTH&A*!!0`4`%`!0`4`%`!0`4`%`!0`4`//^I7_`'C_`$I=?N_4!E,`H`?+
M]X?[J_R%*.WW_F`RF`4`*.A-(I=_ZU$IDA0`4`%`!0`4`%`!0`4`%`#X<;^>
MFT_R-3+;[OS`,1_WW_[Y_P#KT]?Z?_``,1_WW_[Y_P#KT:_T_P#@`&(_[[_]
M\_\`UZ-?Z?\`P`#$?]]_^^?_`*]&O]/_`(`!B/\`OO\`]\__`%Z-?Z?_```#
M$?\`??\`[Y_^O1K_`$_^``8C_OO_`-\__7HU_I_\``Q'_??_`+Y_^O1K_3_X
M`!B/^^__`'S_`/7HU_I_\``Q'_>?_OG_`.O2U\OO_P"``LH`"8.1M_J:(]?Z
MZ(;(ZH04`%`"G@8I%/1"4R0H`*`"@`H`*`"@`H`*`"@`H`*`'G_4K_O'^E+K
M]WZ@,I@%`#Y?O#_=7^0I1V^_\P&4P"@!3T`I%/:PE,D*`"@`H`*`"@`H`*`"
M@`H`?%]X_P"ZW\C2EM]WY@,I@%`!0`4`%`!0`4`%`!UH`7..GYT#O;8<_P!V
M/_=_J:2W?]=$(93`*`%`R:!I7`G)H!N[$H$%`!0`4`%`!0`4`%`!0`4`%`!0
M`\_ZE?\`>/\`2EU^[]0&4P"@!\OWA_NK_(4H[??^8#*8"@9-`TKL"<F@&[B4
M""@`H`*`"@`H`*`"@`H`*`'Q?>/^ZW\C2EM]WY@,I@%`!0`4`%`!0`4`*!F@
M:5P]A0'DA*!#W^['_N_U-);O^NB`93`*`%Z#/K2*V0E,D*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`>?]2O\`O'^E+K]WZ@,I@%`#Y?O#_=7^0I1V^_\`,!E,!1T)
M_"D4MK_U_7^8E,D*`"@`H`*`"@`H`*`"@`H`*`'Q?>/^ZW\C2EM]WY@,I@%`
M!0`4`%`!0`H&:!I7`GL.E`-B4""@![_=C_W?ZFDMW_71`,I@%`"GK]*!L2@0
M4`%`!0`4`%`!0`4`%`!0`4`%`!0`\_ZE?]X_TI=?N_4!E,`H`?+]X?[J_P`A
M2CM]_P"8#*8"GL/2D4^PE,D*`"@`H`*`"@`H`*`"@!<8ZT`)0`^(?,3_`++?
MR-*6WS7Y@,I@+B@`P0`<<'I0`E`!0`[8V<%2#]*`33UZ!M8Y"J3CKQ18')`$
M8D@*3CKQ0*Z#8W/RGCKQTH"Z#8Q&0IQZXH"ZV%<96,#^[_4TEN_7]$,0HP(!
M4C/3BF*Z%5&R?E.1VQ18:DEK<:00<$8/O0&XE`!0`4`%`!0`4`%`!0`4`%`!
M0`4`%`#S_J5_WC_2EU^[]0&4P"@!\OWA_NK_`"%*.WW_`)@-'7VIC6XG6@6X
M4`%`!0`4`%`!0`4`%`"J`6`)P">:!/8E.U\'.2.Q&/?UZ#^M,C5!L&,[1G'3
M/'?O_P#7H"_]=?Z^0J@!@!CH3C/JO\J4MOFOT''O_6ER-P`!P`?0'/\`C3&@
M3[C].G?ZT`]T.D"G)!QZ<YR/Z?C0Q1O_`%_7Y$8QAL]<<4BF.BP'!/0?Y%`-
M70[`SP<<=-P_G_G]:=B7)O\`X9_E_7X"?QDG'RCIG.?3_P"O^-`^F@T#+`L>
MO)Y_SS2'TT'HV6W$@`'.,XQ_B/:F2UI;^OZ\Q!@H,[<`'G//^?PH'UT'MA1&
M1C('KP.3^?\`GKUJ5N_7]$#NU_7]?UT&C`93P#ST/Y>O/\NM4+6PI/`0!3@=
M"?KWX'>@/ZV].G]?B1O@-Q2*6PV@84`%`!0`4`%`!0`4`%`!0`4`%`!0`\_Z
ME?\`>/\`2EU^[]0&4P"@!\OWA_NK_(4H[??^8#?X?K05T_K^NPE,D*`"@`H`
M*`"@`H`*`"@`H`4'!R*`#<V[=DY]<T"LMAT9RY)_NM_(TI;?-?F-#*8!0`4`
M*!W/2@:0$YH!NXE`@H`*`"@`H`>_W8_]W^II+=_UT0#1U]J8UN)UH%N%`!0`
M4`%`!0`4`%`!0`4`%`!0`4`%`!0`\_ZE?]X_TI=?N_4!E,`H`?+]X?[J_P`A
M2CM]_P"8#6ZX]*$5+MV$IDA0`4`%`!0`4`%`!0`4`%`!0`4`/B^\?]UOY&E+
M;[OS`93`*`%QW/2@=NK`G-`-W$H$%`!0`4`%`!0`]_NQ_P"[_4TEN_ZZ(!O1
M?K05LO7^OZ]!*9(4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`#S_J5_P!X_P!*
M77[OU`93`*`)'^^#Z*/Y"I6WS?YE+>Y'5$A0`4`%`!0`4`%`!0`4`%`!0`4`
M%`#XOO'_`'6_D:4MON_,!E,!?<T#\V)UH$%`!0`4`%`!0`4`%`#W&5C'^S_4
MU*Z_UT0TKZ#2<FJ!NXE`@H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`'G_`%*_
M[Q_I2Z_=^H#*8!0!)+P1[J/Y"IC_`)_F5LB.J)"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`'Q?>/^ZW\C2EM]WY@-Z=:8]MQ.M`@H`*`"@`H`*`"@`H`*`)&X1#_L
M_P!34K=^OZ(I:*Y'5$A0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`#S_`*E?
M]X_TI=?N_4!E,`H`D,@.,HI(&,\_XU/+Y_D`F]?^>:?F?\:=GW_+_(`WK_SS
M3\S_`(T6??\`+_(`WK_SS3\S_C19]_R_R`-Z_P#/-/S/^-%GW_+_`"`-Z_\`
M/-/S/^-%GW_+_(`WK_SS3\S_`(T6??\`+_(`WK_SS3\S_C19]_R_R`-Z_P#/
M-/S/^-%GW_+_`"`-Z_\`/-/S/^-%GW_+_(`WK_SS3\S_`(T6??\`+_(`WK_S
MS3\S_C19]_R_R`-Z_P#/-/S/^-%GW_+_`"`-Z_\`/-/S/^-%GW_+_(!1(%.1
M&GZ_XTN6_5_A_D`F]?\`GFOYG_&BS[_E_D`;U_YYI^9_QIV??\O\@#>O_/-/
MS/\`C19]_P`O\@#>O_/-/S/^-%GW_+_(`WK_`,\T_,_XT6??\O\`(`WK_P`\
MT_,_XT6??\O\@#>O_/-/S/\`C19]_P`O\@#>O_/-/S/^-%GW_+_(`WK_`,\T
M_,_XT6??\O\`(`WK_P`\T_,_XT6??\O\@%,@(`,:X'3K_C2Y?/\`+_(!-Z_\
M\T_,_P"-.S[_`)?Y`&]?^>:?F?\`&BS[_E_D`;U_YYI^9_QHL^_Y?Y`&]?\`
MGFGYG_&BS[_E_D`;U_YYI^9_QHL^_P"7^0!O7_GFGYG_`!HL^_Y?Y`&]?^>:
M?F?\:+/O^7^0!O7_`)YI^9_QHL^_Y?Y`&]?^>:?F?\:+/O\`E_D`;U_YYI^9
M_P`:+/O^7^0!O7_GFGYG_&BS[_E_D`;U_P">:?F?\:+/O^7^0!O7_GFGYG_&
MBS[_`)?Y`&]?^>:?F?\`&BS[_E_D`;U_YYI^9_QHL^_Y?Y`&]?\`GFGYG_&B
MS[_E_D`C/N``4*!SQG^M"5@&TP"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@
4`H`*`"@`H`*`"@`H`*`"@`H`_]D`
`





#End
