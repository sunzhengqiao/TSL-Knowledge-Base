#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
17.12.2014  -  version 1.00





























#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 10
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl cuts the beam at the top.
/// </summary>

/// <insert>
/// This tsl requires an element and a beam from another roofplane.
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.00" date="17.12.2014"></version>

/// <history>
/// AS - 1.00 - 17.12.2014 -	Pilot version
/// </history>

//Script uses mm
double dEps = U(.001,"mm");

PropString sSeparator01(0, "", T("|Center Rafter|"));
sSeparator01.setReadOnly(true);
PropString sBmCodeToCut(1, "HRL*", "     "+T("|Beamcode to stretch to center rafter|"));

// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_R-CenterRafter");
if( _bOnDbCreated && arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);
	
//Insert
if( _bOnInsert ){
	//Erase after 1 cycle
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();

	_Beam.append(getBeam(T("|Select the rafter to adjust.|")));
//	_Element.append(getElement("Selecteer een element"));		
	_Beam.append(getBeam(T("|Select a rafter as a reference in a connecting roof plane.|")));
	
	return;
}

// check if there is a valid element present
//if( _Element.length() == 0 || _Beam.length() == 0 ){
if( _Beam.length() < 2 ){
	eraseInstance();
	return;
}

Beam bmToModify = _Beam[0];
// get element
Element elBm = bmToModify.element();
ElementRoof el = (ElementRoof)elBm;
if( !el.bIsValid() ){
	reportMessage(T("|Invalid element found!|"));
	eraseInstance();
	return;
}

// coordinate system of this element
CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

_Pt0 = ptEl;

Beam bmRef = _Beam[1];
Vector3d vzBmRef = bmRef.vecD(_ZW);

if( vzBmRef.isParallelTo(vzEl) ){
	reportWarning(TN("|Select a rafter as reference from a connected roof plane.|"));
	eraseInstance();
	return;
}

Vector3d vxBmRef = bmRef.vecX();
if( vxBmRef.dotProduct(_ZW) < 0 )
	vxBmRef *= -1;
Vector3d vyBmRef = vzBmRef.crossProduct(vxBmRef);
Vector3d vxWorldBmRef = vyBmRef.crossProduct(_ZW);

Line lnXBmRef(bmRef.ptCen(), vxBmRef);
Line lnZBmRef(bmRef.ptCen(), vzBmRef);

Point3d arPtBmRef[] = bmRef.envelopeBody(false, true).allVertices();
Point3d arPtBmRefX[] = lnXBmRef.orderPoints(arPtBmRef);
Point3d arPtBmRefZ[] = lnZBmRef.orderPoints(arPtBmRef);

if( arPtBmRefX.length() == 0 || arPtBmRefZ.length() == 0 ){
	eraseInstance();
	return;
}

Line lnRef(arPtBmRefZ[0], vxBmRef);
Plane pnBmMax(arPtBmRefX[arPtBmRefX.length() - 1], vxWorldBmRef);
Point3d ptRef = lnRef.intersect(pnBmMax,0);
Plane pnRef(ptRef, _ZW);

// beams
Beam arBm[] = el.beam();
Beam arBmToCut[0];
String arSBmCodeToCut[0];
Beam arBmVertical[0];
for( int i=0;i<arBm.length();i++ ){
	Beam bm = arBm[i];
	String sBmCode = bm.beamCode().token(0);
	
	if( abs(abs(vyEl.dotProduct(bm.vecX())) - 1) < dEps )
		arBmVertical.append(bm);	
	
	if( sBmCodeToCut.right(1) == "*" )
		sBmCode = sBmCode.left(sBmCodeToCut.length() - 1) + "*";	
	if( sBmCodeToCut == sBmCode ){
		arBmToCut.append(bm);
		arSBmCodeToCut.append(sBmCode);
	}
}

Beam arBmIntersect[0];
for(int s1=1;s1<arBmToCut.length();s1++){
	int s11 = s1;
	for(int s2=s1-1;s2>=0;s2--){
		if( arSBmCodeToCut[s11] < arSBmCodeToCut[s2] ){
			arBmToCut.swap(s2, s11);
			arSBmCodeToCut.swap(s2, s11);
									
			s11=s2;
		}
	}
}
if( arBmToCut.length() == 0 ){
	reportMessage(T("|No beams to cut found|"));
//	eraseInstance();
//	return;
}

arBmIntersect.append(arBmToCut);

Sheet arShZn07[] = el.sheet(-2);


Beam bmVertical = bmToModify;

Point3d ptCutLeft = bmVertical.ptCen() - vxEl * .5 * bmVertical.dD(vxEl);
Point3d ptCutRight = bmVertical.ptCen() + vxEl * .5 * bmVertical.dD(vxEl);
Cut cutLeft(ptCutLeft, vxEl);
Cut cutRight(ptCutRight, -vxEl);

for( int i=0;i<arBmToCut.length();i++ ){
	Beam bmToCut = arBmToCut[i];
	int bRighthandSide = true;
	if( vxEl.dotProduct(ptCutLeft - bmToCut.ptCen()) > 0 )
		bRighthandSide = false;
	
	if( bRighthandSide )
		bmToCut.addToolStatic(cutRight, _kStretchOnInsert);
	else
		bmToCut.addToolStatic(cutLeft, _kStretchOnInsert);
}

Line lnY(bmVertical.ptCen() - vzEl * 0.5 * bmVertical.dD(vzEl), vyEl);
Point3d ptCutVertical = lnY.intersect(pnRef,0);

Vector3d vyW = _ZW.crossProduct(vxEl);
Cut cutVertical(ptCutVertical, vyW);
bmVertical.addToolStatic(cutVertical, _kStretchOnInsert);
bmVertical.setName("Center Rafter");

Point3d ptSplitSheet = ptCutVertical - _ZW * el.zone(-2).dH()/cos(_ZW.angleTo(vzEl));

for( int i=0;i<arShZn07.length();i++ ){
	Sheet sh = arShZn07[i];
	Sheet arShSplitted[] = sh.dbSplit(Plane(ptSplitSheet, vyEl), 0);
	
	for( int j=0;j<arShSplitted.length();j++ ){
		Sheet shSplitted = arShSplitted[j];
		
		if( vyEl.dotProduct(shSplitted.ptCen() - ptSplitSheet) > 0 )
			shSplitted.dbErase();
	}
}

eraseInstance();












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
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHI"0!S0`M)6!J7BW3=/)1)/M,PXV1'('U/2N0U'Q9J=_E4D^S
M1'^"+K^+=?RQ64ZT8;FD*4I;'=ZCKVGZ6"+FX'F?\\T^9S^';\:Y*_\`'=Y)
M(HLH4ACSUD&YC_05RA))))R3R3ZTG5OI7++$R>VATQP\5N>@:;XWM9]J7\9M
MY/[Z_,G^(KJ89H[B)9(I%D1AD,AR#7B];/AG5FTS6(P[D6TOR2+GCGHWX5=+
M$-NTB*E!)7B>IT4`Y%%=ARA1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M15.]U*TTZ/?=W"1+VR>3]!U-)NP)7+=1S3Q6\32S2I&B]6=L`?C7&:EX[8DQ
MZ;!@?\]9A_)?\?RKD[R_N[^3S+NXDF;_`&CP/H.@K">(C';4WA0E+<[C4O&]
MG;YCL8C<R#C>?E0?U/\`GFN1U'7M1U3*W-P?+/\`RR3Y4_+O^-9M%<DZ\Y'3
M"C&(4445B:A2#J32DX&:0#"BF@%I%YSQU-!.`30!@`4(&>G^%=5_M+2$5VS/
M!^[?W]#^7\C6[7EOAG5/[+UB,NV()OW<GH/0_@?ZUZG7I49\\3SJT.604445
ML9A1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1368*"20`.YK`U+Q?IM@62)C=3#C;%]T?5NGY
M9J7)1U8U%O1'0&LK4O$&G:6")[@-*/\`EE'\S?EV_&N$U+Q5J>HY02_9X3_!
M#P3]6Z_RK$Z5S3Q27PG1##M_$=/J7C6^N<I9HMK'_>^\Y_H/\\US4LLDTADE
M=Y'/5W8L3^)IM%<LZLI;LZ8TXQV"BBBLRPHHHH`****`$;ICUI:3^(>U+3$(
MW8>]+2?Q?04M`PKU#POJ@U+1X][`S0_NY/PZ'\1_6O+ZV_"VJ'3=70.V(9_W
M;^@]#^?\S6U"IRRMW,:\.:-SU&BD!S2UZ1P!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`452OM5LM-CWW=S'
M'QD*3RWT'4UR6I>.G;='IT&T?\]9NOX+_C^51.I&.[*C"4MCM+BYAM8C+<2I
M%&.K.V!7,:GXYM8"8["(W#C^-OE3_$UP]W>W-]+YMU/),_8N>GT':H*Y)XIO
MX3JAAE]HOZAK6H:H3]JN&*?\\T^5/R[_`(U0HHKFE)RU9T**6B"BBBI&%%%%
M`!1110`4444`%%%!.!F@!!R2:6D484>M!.%)Q3`!W/J:6D`P,4M#`****0'J
M/AC5#J>D(7;,\7[N3W]#^(_K6U7F7A/4_P"S]75';$-QA&]C_"?S_G7IN<UZ
M=&?/&YYU6'+*PM%%%;&84444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`444UF5%+,0`.I)H`=29KG-2\9:=9ADMR;N4=HS\O_?7^&:Y#4O%&
MIZCN4S>1$?\`EG#\OYGJ:QG7A$TA2E([S4O$>FZ6&668/,/^647S-_\`6_&N
M0U+QI?W6Y+,"UC]1\SD?7M^'YUS(&**Y9XF3VT.J&'BM]1SR/*Y>1V=VZLQR
M3^--HHKF;;W-TDM@HHHH`****`"BBB@`HHHH`****`"BD)`ZG%)EC]T8]S3L
M%QU,+;L`<@]^U+L'5B6/O2_Q#VIZ"%I&[#U-+32?W@^E)#8ZBBBD`4444`'X
MUZGX;U3^U-(C=CF:/Y)/J._XUY96]X3U3^SM76-VQ#<81O0'L?\`/K71AZG+
M*W<QKPYHW/3J*!17HG`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!115
M#4-7L=,7-W<)&2,JO5F^@ZTF[`E<OU!<W<%I$9+B:.)!_$[8%<3J/CJ:4%-.
M@\H?\])>6_[YZ?SKEKJ[N;V;S;J=YG]7;./IZ5SSQ$8[:F\*$GOH=MJ/CJWB
M#)I\)F?_`)Z2?*OY=3^E<CJ&L7^J-FZN&9<Y$8^5!^%4:*Y9UIR.J%&,0HHH
MK$T"BBB@`HHHH`****`"BBB@`HHHH`**:7'0?,?:C#'J<#T%.P7%+`<=_04G
MSG_9'ZTH4+T&*6@0@4`Y[^II:0L%')Q298]!CW-&K#1#LXI%.XDCFDVCJW/U
MI5^Z*`%IH^8-[FE)PI/I0G"#Z4!U`'(R:6DZ-]:6@84444@"C..E%%`;GJOA
MW4_[5TB*9B/-3Y)?]X?X]?QK6KS3PAJGV#5A#(V(;G"'V;^$_P!/QKTNO4HS
MYXW/.JPY96%HHHK4S"BBB@`HHHH`****`"BBB@`HHHH`3M6-J7B?3--W))-Y
MLPS^ZB^9L^_8?C7":EXEU/4LJ\YAA/\`RSA^4?B>IK(KDGBE]DZ889_:.CU+
MQGJ-YN2VQ:Q'^YR__?7^%<Z[-([.[%G8Y9B<DTE%<DJDI;LZHTXQV"BBBH*"
MBBB@`HHHH`****`"BBB@`HHI"0.2:`%HZ4W+-T&/<T;!U)R?>G8+ANS]T9]^
MU&W/WCGV[4ZBB_85@`QTXHIN\?PY;Z488_>./846[CN*6`X[^@I/F/\`L_SI
M0`HP`!2T7`0*!]?4TM,EECA0O*ZHH[L<5BWGB6"/*VT9E/\`>;@5M2P]6J_=
M1,IQCN;C=,>O%+5+3XKHP)=7CDRRC<L?0(O;CWJ[6<X\CY4[C3OJ-?G`]32C
M@X_&DZR8]!2D9''44K]``C(H!R*4'-)T;ZT@%HHHI#"BBB@`!P?2O5O#NI_V
MIH\4S']ZOR2_[P_QX/XUY371^#M4^Q:K]FD;$-SA?HW;_"NC#SY96[F%>'-&
MZ/2:***]$X0HHHH`****`"BBB@`HHHH`****`/$Z***\8]4****`"BBB@`HH
MHH`****`"BBFEQ_#\WTI@.I"P''?T%)ACU.!Z"E``'`Q1H(3YS_LC]:4*!]?
M6EI"P7J:`%H)P,GBFY8]!@>IH"`')Y/J:+`&XG[HS[FC;G[QS[=J=11?L%@Q
MBBJ-YJ]G99#R;G_N)R:P+SQ'<SY6`"%/4<M770P-:MJE9>9$JL8G37-[;6:[
MIY53T'<_A6#>>)F8%;2/;_MOU_*N?9V=BSL68]2325[%#*Z4-9ZLYY5Y/8EG
MN9KE]\TK.?<UL>&='_M&\\Z5?]&A.6ST9NRUDV5I+?7D=M",NYQ]/>O3K&SA
MTZR2WBX1!R?4]S6.:8R.&I^RI[O\$50I\[N]BM=-NN&']WY:AI2=Q+'J>:0]
M*\"*LCJ)Q!FS\P#Y@2?PJ"M6--D2IZ#%9TT?E2E.W;Z5E3J<S:*:LB(<-C\:
M",C%#=..HI>HZUN2(#D9I:3HWUI:0!1110`4H)4@J<,.01244)VU`]7T'4QJ
MNDPSDYD'RR#T8?YS^-:M>;>#M4^Q:K]F<GRKGY?H_;_#\J](%>I2GSQN>=5A
MRRL+1116IF%%%%`!1110`4444`%%%%`'B=%%%>,>J%%%%`!1110`44A('4XI
M,L>@Q[FG8!Q.*;N)^Z,^YZ4;!G)Y/O3J-!:C=N?O'/MVIW2BF[O[HW?2C5CV
M'4A8`XZGT%)M)^\?P%*``.!BC0!/F/\`LC]:4*%Z=?6EJ.6:*!-\LBHOJQQ3
M2;T0M$24A(4$L<`=S6%>>)8DRMJAD/\`?;@5@76H75ZW[Z4E>RC@#\*]"AEE
M6IK+1&4JT5L=/>>(+2VRL1\]_P#9Z?G6!>:W>7>1O\N/^XG'ZUG45[%#`4:6
MJ5WYG/*K*04445VF8445T'A?1_M]U]JF7-O">A_B;TK'$5XT*;J2V14(N4K(
MWO"^C_8+3[3,N+B8=#_"OI6U=-MMW]_EJ:J=\_W$_P"!5\-4K2Q%?GGU/345
M"%D4Z?"N^=%]\TRK5BN9&;T&*VG*T6R5JR]5:\CW1;QU7^56:",UP0ERNYLU
M=&/2#@XJ26,Q2LGY?2HR._I7HIW1@!&10#D4O6DZ-]:8"T444@"BBB@!59D<
M.A*LIR".QKUG1-2&JZ5#<\;\;9!Z,.O^/XUY+73>"]4^QZF;.1L0W/`]G[?G
MT_*NC#U.65NYA7AS1OV/1J***]$X0HHHH`****`"BBB@`HHHH`\3HHHKQCU0
MHIN[^[\WTHP6^\<>PIV"XI8`XZGT%)\S?[(_6E``Z#%+0(0*%^OK2TA8+U-)
MECTX'O1N`XG'7BF[B>%'XF@(`<GD^IIU&@QNW/WCGV[4ZBL^\UBSL\AI-\@_
M@3DU<*<ZCM%7$W&.YH57NK^VLUS/*JGL.I/X5S-YXANKC*PX@3V^]^=9#,SL
M68DL>I->I0RF3UJNQA*O_*;]YXF=LK:1[!_??K^58<UQ-</OFD9V]2:CHKV*
M.&I4E[B.>4Y2W"BBBMR0HHHH`***/:@"S864NH7D=M"/F8\G^Z.YKTZSM(K&
MTCMH1A$&/<^]97AK1_[-L_.E7_29AEO]E>PK<KX[-L=[>I[./PK\6>CAZ7+&
M[W"LVZ;=<-[?+6B3@$GH*R"2Q+'J>:\_#K5LUFPK0LEVP9_O'-9]:T:[(U3^
MZ,5==VC84%J.HHHKC-"M>1;H]XZK_*J%;!&:RI4\J5D[#I]*ZZ$[KE,YKJ1C
M@XH89%!]>XI:Z2`!R,T4@X;ZTM`!1112`*569&5T)5E.01V-)10M'</(]:T3
M4EU32H;GHY&V0>C#K6E7G?@K5/LNH-8R-B.XY7/9Q_B/Z5Z&*]2E/GC<\VI#
MEE86BBBM2`HHHH`****`"BBB@#Q'<3]T9]STHV9^\<^W:G45X]^QZE@[44W?
MG[HW?RHVD_>/X"BW<=^PI8`XZGT%)\Q_V1[=:4``8`Q2T7["$"A>@I:CFGAM
MTWS2*B^K&L2\\31KE+2/>?[[\#\JWHX:K6?NH4IQCN;S,J*68@*.YK)O/$-I
M;Y6',[^W3\ZYFZOKF\;,TK,.R]A^%5J]>AE,5K5=SGE7;V+]YK-Y>9#2;$_N
M)P*H445ZM.G"FK15C!MO<****L04444`%%%%`!116AI6B:EK<_DZ=9RSMW*K
M\J_5N@I2DHZL#/KH_"FC_:[K[9,G[B(_)G^)O_K5V>C?"1((OM>OWGRH"S06
M_0`>K?X#\:=:0QV]K'%#'Y<:CA!_#7BYKF"A2Y*>[-\/!3EKT)J***^1/2(;
MIMMN_O\`+6;5R^;[B?C5.NR@K1,I[DD"[YT'OFM2J%BN9F;^ZN/S_P#U5?K&
MN[RL7#8****P*"JM[%N02#JO7Z5:I"`001D&JA+E=P:N9%(.#BI)8S'(4].G
MTJ,],^E>BG?4P:`C(]Z4'(S12#@X]>:8"T444@"BBB@!T;O%(LB,5=2&4CL:
M]:T;45U32X;I<!F&'4=F'45Y'74^"M3-MJ#6,C?NKCE?9Q_B/Y"NG#5.65NY
MAB(75^QZ'1117H'"%%%%`!1110`4444`>([B?NC\31MSRQS_`"IU%>/?L>K8
M**SKS6K*SRID\R0?P)S6!>>(+NYRL7[E/]GK^==E#`5JVMK+S,Y58Q.GNM0M
M;-?WTRAO[HY)_"L"\\2ROE+2/RQ_?;DUA,Q9BS$DGJ325[%#+*5/66K.>5:3
MV))IY;B0O+(SL>Y-1T45Z*26B,7J%%%%,`HHHH`****`"BE5&=@J*68]`!DF
MNRT+X9:]K!62XC^P6Y_CG'SD>R]?SQ43J1AK)@<970:%X+USQ`P:TLV2`]9Y
MOD3_`.O^&:]BT'X<:#HFR5H/MMRO_+6X&0/HO05UP4*,`8%<=3&=((FYYYH/
MPFTJQV2ZI*U]..=GW8A^'4_G^%=];6L%G`L-M#'#$O"I&H4#\!4]%<4IRD[R
M8C&\3W'D:#.H/S38B`]=QY_\=S7"5TWC*?=+:6H/3=*W_H(_FU<S7A9C.]11
M['I82-H7"BB@G`R:\\ZC-NFW7#?[/RU#2D[F+'JQS2'I7H15DD8LOV2[8"W]
MYL_TJS3(DV1*GH,4^N&<KR;-8Z(****@84444`5;V/<@D'5>OTJC6N0&4@\@
MUE2(8I"A[5V4)W5C.:ZC!QQ01D>]!]?2EKH\R`!R**3HV/7FEH`****0!3HI
M7AE26-BKHP92.Q%-HH3L[@U=6/7=)U!-3TV&[7C>/F7/W6[BKU>?^"=4^SWS
MV$C8CG^9/9Q_B/Y5Z!7JTI\\;GFU(<LK"T445H0%%%%`!1110!\]7GB*U@RL
M'[Y_;@?G6!>:O>7N0\FU#_`G`JC17I4,#1HZI7?F;2JREN%%%%=A`4444`%%
M%%`!1110`45IZ1X>U779?+TVRDG]7`PB_5CQ7I6@_!^--LVNW1D(Y^SVYPOT
M+=?R_.L:E>$-V(\IL[&ZU"X6WL[>6XF;HD2%C^E>@Z#\(]1N]LVL3K9Q_P#/
M),/(1_(?K7K>F:1I^CVX@T^TBMX_1%Y/U/4_C5^N*IBY2^'05S"T3PCHOA]%
M-C9(LH&#,_S2'_@7^%;M%%<C;>K$%%%%`!113)'6.-G<@*H+$^@%`'`^(;C[
M3KUP0<K$%B7\!D_JQK,H,K3LTSC#RL9&'NQS_6BOF<1/GJ.1[-*/+!(*ANFV
MV[^_%353OGX1/^!5--7DBI:(IT^%=\Z+[TRK-DN96;^Z*[9NT6S);E^BBBO.
M-@HHHH`****`"JM['E1(.J\'Z5:I"`P(/(-7"7+*X-71D4@XXI[H8W9#U%,;
MCGTKT$[F`,,CCJ*4'/-%(.#C\:8"T444@"BBB@!T4CPRI+&Q5T8,I'8BO7=)
MOEU+3(+M1CS%^8>C=Q^=>05UW@?5/)NWTZ1ODF^>//\`>'4?B/Y5TX:=I6[G
M/B(7C<[ZBBBO0.(****`"BBB@#Y-HHHKWBPHHHH`***='&\LBQQHSNQPJJ,D
MT-VU8#:*[?0?A?KFK;);M1I]NW.9AES_`,`_QQ7IV@_#S0="*R"V^U7(Y\ZX
M^;!]AT%<U3%0CMJ*YX[H7@;7=?VO;6ABMV_Y;S_(GX=S^%>G:%\*-(TXI+J+
MMJ$XYVL-L8_X#W_&O0``!@#`%+7%4Q,Y^0KD4%O#:PK#!$D42C"HB[0/PJ6B
MBN<04444`%%%%`!1110`E9'B:X\C0K@`_-*!$/\`@1P?TS6O7)^,KC+6=J#W
M:4_A\H_FWY5C7GR4W(NE'FFD<Q1117S1[(5G7;;KAA_=`'^?SK1)`K(9M[%O
M[QS6^'6K9$Q*OV2XA)[EJH8)X'6NVU_1Q8V-G<1CB.-8)??T/YY'XBNN=)SI
MR:Z&/M%&23ZF#1117F'2%%%%`!1110`4444`5+V+*B4#IP?I5*M=E#*5/(/%
M93H8Y&0]J[*$[JQG-:C!QQZ4$<>XH;CGTI:Z"!`<C(I:0<$C\:6D`4444`%/
MAFDMYTFB;;(C!E/H13**:=G<&KJQZ_IE\FI:=#=Q\"1<D?W3W'YYJ[7`^!M3
M\JZDT^1ODE^>/_>'4?E_*N]%>I3GSQN>;4CRRL+1116A`4444`?)M%%:NC^&
M]7UZ4)IUC)*N<&0C:B_5CQ7NRDHJ[+,JK-CI]YJ=RMO96TMQ,W1(UR:]7T'X
M06T6R;6KHSOU\B#Y4'U;J?PQ7HNGZ78Z3;B"PM8K>+KMC7&?KZUR5,9%:1U%
M<\FT'X0WMSLFUJY%K&>?)A^:3\3T'ZUZ9HOA71O#Z8T^RCCDQS*WS.?^!&MJ
MBN&=:<]V3<,4445F`4444`%%%%`!1110`4444`%%%%`"&O/_`!#<?:->N2#D
M1!8E_`9/ZL:[V5UBB>1CA5&XGT`KR\R-,S3-PTC%V^K'/]:\_,9VIJ/<ZL)&
M\[]@HHHKPSTB&Y;;;O[C%9M7;YN$3WS5*NV@K1,I[FCH-K]LUVSA(R/,#-]%
M^;^E>I7EK'>V<EM+]R12I_Q%<1X$M?,U*XNB.(H]HSZL?_K?K7H%>MAXVAKU
M//KR]\\NEADMYY()AB2)BKX]?7^M,KI?%MALECU",<-B.7_V4_T_*N:KQ<51
M]E4:Z'H4:G/"X4445S&H4444`%%%%`!52]BR%E';@U;I&4.I5NAXJX2Y97$U
M=&12+Q\OI3W0QN4/44P\<^E>@G<Q`C]*4'-%(.#C\:8"T444@"BBB@"6WGDM
M;B.>)MLD;!E/N*]<TZ]CU'3X;N/[LBYQZ'N/SKQZNP\#ZIY<\FFRM\LG[R+_
M`'NX_+G\#75AIVER]SGQ$+KF.\HHHKO.(****`."T+X5Z+IA66^W:A..OF#$
M8/LO^.:[F&&*")8X8UC11@*@P!^%2454IRD[R8!1114@%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`&/XEN/L^@W`!P90(A_P(X/Z9K@ZZGQE/_QYVP[L
MTI]L#:/_`$(_E7+5XF8SO44>QZ.$C:%PHHHZ5Y^YUF;=MNN#S]T8J&E9BS%O
M[QS2`9.!R:]&"LDC%L]'\$VOD:'YQ'S3R,WX#Y?Z&NEJIIMK]BTZVMO^>484
M^YQS5NO8@K12/*D[R;*UY:QWMI+;2C*2+M/M[UYM+$\$TD$O^LC8HWU'>O4:
MX_Q9I_EW$=^@^63]W+_O?PG^GX"N+'T>>GS+='1A:G+.SZG.4445X1Z84444
M`%%%%`!1110!4O8^!*.W!JE6NZAT93T(Q62RE'*-U%=E"=XV,YK4:../2@CO
MW%!XYI:Z/,@.W6BD'!Q2T@"BBB@`J2WGDM;B.>)MLD;!E/O4=%-.SN#5T>Q6
M%Y'?V,-S&<K(H;Z>HJUWKA?`^J;))--D/#?/%GU[C^OYUW5>K3GSQ3/,G'EE
M8****LD****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHICNL:,[D
M!5&23VH`X+Q'<?:->GP<K$JQ#\!D_JQ_*LNE>5KB1YV^]*S2$>FXY_K25\UB
M)\]5R/8I1Y8)!45TVVV?W&/SJ6JE\WRHGJ<U%-7DBY;%*M'0;7[9KEG#C(\P
M,WT7YC_*LZNL\!VOF:C<7)'$4>T?5C_]8UZE&/--(Y:LK0;/0!THHHKU#S@J
MK?VD=]936TOW9%QGT/8_@:M44FKZ`M#RV2-X)7AE&)(V*N/<4VNC\6V/E745
M]&/EE_=R?[P^Z?RR/P%<Y7SF)H^RJ-'KT9\\$PHHHKG-0HHHH`****`"J=[%
MTE'T-7*1U#H5/0U<)<LKB:NC(I!Z>E.92CE#U4XIIXYKT$[F(-TSZ4HY'%%(
M../RI@+1112`****`)K6YDL[J*YA.)(V#+7KEC=QWUE#=1?<D7<!Z>U>.UV?
M@74L--ITC<']Y%G_`,>'\C^==6&J6?*<^(A=<QW-%%%=YQ!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%9'B2X^SZ#<D'#2`1#_`($=O\B:UZY?
MQD["WLH\_*92Q^H4_P"-95I<M-LNG'FDD<G1117S)[(5G7;;K@C^Z,5HUDN=
MTKD_WC_.M\.O>9$QM>C>"+;R="\[',\C-GV'R_T-><UZWH<:QZ#8*HP/(0_B
M1DUZN%7O-G%B7[J1HT445WG&%%%%`%34;--0L)K9S@.N`?[I['\#7F[H\4CQ
M2C;(C%6'H1UKU*N'\50I%K89!@RQ!G]R"1G\@/RKS\QIJ5/G['5A)M2Y>YB4
M445X9Z04444`%%%%`!1110!2O8L$2#Z-53BM:10T;`]"M9-=M"5XV,I+40>G
MI0WKZ4'AA[TM;DA135[CT.*=2`****`"I[.ZDLKR*YA.'C8,/?VJ"BFG;4&K
MZ'LEG=1WMG%<Q'*2*&%6*Y'P'<2/I]Q`S92.0%!Z9Z_RKK:]6#YHIGF25I-'
"_]DE
`










#End