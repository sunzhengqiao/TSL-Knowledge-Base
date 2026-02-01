#Version 8
#BeginDescription
// #Versions

1.7 26/04/2021 Make sure tsl can be applied with catalog Author: Robert Pol


#End
#Type E
#NumBeamsReq 1
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 7
#KeyWords 
#BeginContents
/// <history>
// #Versions
//1.7 26/04/2021 Make sure tsl can be applied with catalog Author: Robert Pol
/// </history>

/// <summary Lang=en>
/// This tsl adds a beamcut to a beam
/// </summary>

/// <insert>
/// Select a set of beams. The tsl is reinserted for each beam.
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.06" date="14.09.2017"></version>

/// <history>
/// AS - 1.00 - 16.02.2012 -	Pilot version
/// AS - 1.01 - 04.12.2012 -	Option to rotate beamcut. Visualisation enhanced.
/// AS - 1.02 - 18.09.2015 -	Option to extend the beamcuts is added
/// AS - 1.03 - 18.09.2015 -	Set preview mode to 'No' is now done by custom action.
/// AS - 1.04 - 06.12.2016 -	Start adding grip points to control the size of the beamcut
/// AS - 1.05 - 25.04.2017 -	Add grippoints to beamcut. 
/// AS - 1.06 - 14.09.2017 -	Set origin based on beam vectors. Rotation is done over this origin.
/// </history>

double dEps = Unit(0.01, "mm");

String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};

PropString sSeperator01(0, "", T("|Position|"));
sSeperator01.setReadOnly(true);
PropDouble dxOffset(0, U(0), "     "+T("|Offset X|"));
PropDouble dyOffset(1, U(0), "     "+T("|Offset Y|"));

PropString sSeperator02(1, "", T("|Size|"));
sSeperator02.setReadOnly(true);
PropDouble dBCDepth(2, U(75), "     "+T("|Depth|"));
PropDouble dBCLength(3, U(290), "     "+T("|Length|"));
PropDouble dBCWidth(4, U(58), "     "+T("|Width|"));
PropDouble dExtend(8, U(10), "     "+T("|Extra depth|"));

PropString sSeperator04(4, "", T("|Rotation|"));
sSeperator04.setReadOnly(true);
PropDouble dxyRotation(5, 0, "     "+T("|Rotation XY|"));
dxyRotation.setFormat(_kAngle);
PropDouble dxzRotation(6, 0, "     "+T("|Rotation XZ|"));
dxzRotation.setFormat(_kAngle);
PropDouble dyzRotation(7, 0, "     "+T("|Rotation YZ|"));
dyzRotation.setFormat(_kAngle);


PropString sSeperator03(2, "", T("|Preview|"));
sSeperator03.setReadOnly(true);
PropString sPreviewMode(3, arSYesNo, "     "+T("|Preview mode|"));
PropDouble dRefPointSize(9, U(5), "     "+T("|Reference point size|"));
PropDouble dSymbolSize(10, U(10), "     "+T("|Symbol size|"));
PropDouble dTxtHeight(11, U(2), "     "+T("|Text size|"));

PropString sExtendBeamcuts(5, arSYesNo, "     "+T("|Extend Beamcuts|"));

String recalcTriggers[] = {
	T("|Apply beam cut|")
};
for( int i=0;i<recalcTriggers.length();i++ )
	addRecalcTrigger(_kContext, recalcTriggers[i] );


// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if( _bOnDbCreated && catalogNames.find(_kExecuteKey) != -1 ) 
{
	setPropValuesFromCatalog(_kExecuteKey);	
}


if( _bOnInsert ){
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || catalogNames.find(_kExecuteKey) == -1 )
	{
		showDialog();
	}
	else
	{
		setPropValuesFromCatalog(_kExecuteKey);
	}
	
	PrEntity ssBm(T("|Select a set of beams|"), Beam());
	if( ssBm.go() ){
		_Pt0 = getPoint(T("|Select a position|"));
		
		
		Beam arBm[] = ssBm.beamSet();
		
		String strScriptName = "HSB_T-BeamCut"; // name of the script
		Vector3d vecUcsX(1,0,0);
		Vector3d vecUcsY(0,1,0);
		Beam lstBeams[1];
		Entity lstEntities[0];
		
		Point3d lstPoints[] = {_Pt0};
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		Map mapTsl;
		mapTsl.setInt("MasterToSatellite", TRUE);
		setCatalogFromPropValues("MasterToSatellite");
		for( int i=0;i<arBm.length();i++ ){
			Beam bm = arBm[i];
			lstBeams[0] = bm;
			
			TslInst tsl;
			tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
		}
	}
	
	eraseInstance();
	return;
}
// set properties from master
if( _Map.hasInt("MasterToSatellite") ){
	int bMasterToSatellite = _Map.getInt("MasterToSatellite");
	if( bMasterToSatellite ){
		int bPropertiesSet = _ThisInst.setPropValuesFromCatalog("MasterToSatellite");
		_Map.removeAt("MasterToSatellite", true);
	}
}

sPreviewMode.setReadOnly(true);
int bPreviewMode = arNYesNo[arSYesNo.find(sPreviewMode,0)];
int bExtendBeamcuts = arNYesNo[arSYesNo.find(sExtendBeamcuts,0)];

// On recalculate all trigger
if (_kExecuteKey == recalcTriggers[0])
	bPreviewMode = false;

Vector3d vxBmCut = _X0;
Vector3d vyBmCut = _Y0;
Vector3d vzBmCut = _Z0;
vxBmCut = vxBmCut.rotateBy(dxyRotation, vzBmCut);
vyBmCut = vzBmCut.crossProduct(vxBmCut);
vxBmCut = vxBmCut.rotateBy(dxzRotation, vyBmCut);
vzBmCut = vxBmCut.crossProduct(vyBmCut);
vyBmCut = vyBmCut.rotateBy(dyzRotation, vxBmCut);
vzBmCut = vxBmCut.crossProduct(vyBmCut);

if (_kNameLastChangedProp == "_PtG0" || _kNameLastChangedProp == "_PtG1")
{
	double newLength = vxBmCut.dotProduct(_PtG[1] - _PtG[0]);
	double newWidth = vyBmCut.dotProduct(_PtG[1] - _PtG[0]);
	double newHeight = vzBmCut.dotProduct(_PtG[1] - _PtG[0]);
	
	if ((newLength * newWidth * newHeight) != 0)
	{
		dBCLength.set(newLength);
		dBCWidth.set(newWidth);
		dBCDepth.set(newHeight);
	}
}

Point3d ptBmCut = _Pt0 + _Z0 * (0.5 * _H0 - dBCDepth) + _X0 * dxOffset + _Y0 * dyOffset;//_Pt0 + vzBmCut * (0.5 * _H0 - dBCDepth) + vxBmCut * dxOffset + vyBmCut * dyOffset;

//if (_PtG.length() != 2 || _bOnDebug) 
//{
	_PtG.setLength(0);
	_PtG.append(ptBmCut - vyBmCut * 0.5 * dBCWidth);
	_PtG.append(ptBmCut + vxBmCut * dBCLength + vyBmCut * 0.5 * dBCWidth + vzBmCut * (dBCDepth + dExtend));
//}


vxBmCut.vis(ptBmCut, 1);
vyBmCut.vis(ptBmCut, 3);
vzBmCut.vis(ptBmCut, 150);

BeamCut bmCut(ptBmCut, vxBmCut, vyBmCut, vzBmCut, abs(dBCLength), abs(dBCWidth), abs(dBCDepth) + abs(dExtend), 1, 0, 1);
bmCut.setModifySectionForCnC(bExtendBeamcuts);

Display dp(-1);
dp.textHeight(dTxtHeight);

if( bPreviewMode ){
	Body bdBmCut = bmCut.cuttingBody();
	Display dpBmCut(3);
	dpBmCut.draw(bdBmCut);
	
	Vector3d arVxSymbol[] = {vxBmCut, vyBmCut, vzBmCut};
	Vector3d arVySymbol[] = {vyBmCut, vzBmCut, vxBmCut};
	Vector3d arVzSymbol[] = {vzBmCut, vxBmCut, vyBmCut};
	int arNSymbolColor[] = {1, 3, 150};
	String arSSymbolTxt[] = {"X", "Y", "Z"};
	
	for( int i=0;i<arVxSymbol.length();i++ ){
		Vector3d vxSymbol = arVxSymbol[i];
		Vector3d vySymbol = arVySymbol[i];
		Vector3d vzSymbol = arVzSymbol[i];
		
		int nSymbolColor = arNSymbolColor[i];
		String sSymbolTxt = arSSymbolTxt[i];
		dp.color(nSymbolColor);
		
		PLine plRef(vxSymbol);
		plRef.createCircle(ptBmCut, vxSymbol, 0.5*dRefPointSize);
		dp.draw(plRef);
		
		if( dSymbolSize > 0 ){
			PLine plSymbol(ptBmCut, ptBmCut + vxSymbol * dSymbolSize);
			
			dp.draw(plSymbol);
			dp.draw(sSymbolTxt, ptBmCut + vxSymbol * dSymbolSize, vxBmCut, vyBmCut, 1.1, 1.1, _kDeviceX);
			
			PLine plHead(
				ptBmCut + vxSymbol * dSymbolSize - (vxSymbol - 0.25 * vySymbol) * 0.2 * dSymbolSize,
				ptBmCut + vxSymbol * dSymbolSize,
				ptBmCut + vxSymbol * dSymbolSize - (vxSymbol + 0.25 * vySymbol) * 0.2 * dSymbolSize
			);
			dp.draw(plHead);
			
			plHead = PLine(
				ptBmCut + vxSymbol * dSymbolSize - (vxSymbol - 0.25 * vzSymbol) * 0.2 * dSymbolSize,
				ptBmCut + vxSymbol * dSymbolSize,
				ptBmCut + vxSymbol * dSymbolSize - (vxSymbol + 0.25 * vzSymbol) * 0.2 * dSymbolSize
			);
			dp.draw(plHead);
		
			PLine plArrowHead(vxSymbol);
			plArrowHead.createCircle(ptBmCut + vxSymbol * 0.8 * dSymbolSize, vxSymbol, 0.05 * dSymbolSize);
			dp.draw(plArrowHead);
		}
	}
}
else{
	_Beam0.addToolStatic(bmCut);
	eraseInstance();
	return;
}



#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`%%`:$#`2(``A$!`Q$!_\0`
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
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BN5
M\2>.].T&X_LZVC;5-996*Z?:R)NCPNX-*Q.(E.5&3R=PP&KB-4_M7Q1<>9XA
MGB-FO^KTJU9Q;_?W*TI)'G,-J#Y@%&"0O.:QJXBG27O,TITI3>ATVI?$>">[
M>Q\,0)JCJ0LNH"0?8X"5)^\#F5A\F57`^8`NIKF7LWO-6_M;4[J:^O\`YC&T
MC$1VX95#+#'G"`A1ZL1U9CDFS%%'!"D,**D4:A$15P`HX&!TZ`4ZO(KXR=72
M.B/0I8:,-7JPHHK!O?$T'E8TS;=R,2HG!S"A&.20?FX./DSD@@E<9KGIT9U7
M:*-G)1W-J6>*WC\R65(HP5`:0X&2=H!/J2>E<[=>)'N,IIT4D46"/M$R;6SC
M`V*W((]7&..C9R,ZZDEO+D3W,DDCH3L!.$3)/1>!D!MN<9QG)IM>OA\OC#6>
MK.>=5O88D02625CON)<&69@-\GID^GITP.`,``/HHKT$K;&04444""BBBF`4
M444`%%%%`!1110`4444`%%%%`!1110`5I>'O^1ETK_K\A_\`0Q6;6EX>_P"1
METK_`*_(?_0Q0)['OE%%%2<HM%%%(04444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!117GFI_%&*ZFELO"%B=8N%8QO?.?+LX6R5)+]9"#M.U/O*<
MAJF4HQ5Y.Q,I**NST.BO++2]\50PQM<>*[FXN%.X@V5NL3\Y`90@;&.N&!ZX
M(ZU-JGBSQ@=+:"S@TU;GD->Q*2Y!!P8X'8*&!*\M(1\IX).T<L<?AY.RD81Q
ME&3M<[C6_$FC^'(8Y-6OX[<S-MACP7DE.0,)&H+.<LN=H.,\UP5_XG\2ZY-L
M0)HFF[B#%&XDNYT^<?,X.V($;#\F6'.'%<]#=Z997T]_J*RVFI7!S<7FI+M,
MC'''F\QD84$(C``#A1MQ6W%+'/"DT+J\4BAT=6R"IY&#TZ$5SXC&SV@K>9ZF
M'ITI+FO<K:?IMEI5HMK86T=O"/X8UQNX`R3U)XZG.<5;H_#-5-1U.STJV%Q>
MS"-"XC7@DLQX`4#EB?\`9[<UYEIU'W9WNT46_P#/%9^HZS;:=F-@\UQL\SR(
M0"Y4G'4X4<YZD9`.,D&L*_UB]OSY<!>RM2`25<>;)D`%3U"8.1E23G!!7'-%
M(XXS(R(JF1S([`#YF/5CZDGOS7I4,N<M:AC.KV)KR^O-51UO"(H6(_T:&1MO
M<$,PP7!R<J>,8&."3'QVQQSCVZ<#THHKU(4XP5HHP;;W"BBBM-A!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%58M0AFNA;QK*20YWF-@AV,%
M8`D#/)'0XXYI-@6JTO#W_(RZ5_U^0_\`H8K-K2\/?\C+I7_7Y#_Z&*8GL>^4
M445)RBT444A!1110`4444`%%%%`!1110`4444`%%%%`!116)XG\6:-X1TQ[[
M5[Q(AM9HH`099R,#;&F<L<LOL,Y)`YH`VZY3Q/X]T[P],+"VAEU766R%T^S(
M9X^`0TQ_Y9(2R#<?[V0"`<<?J/B'Q/XO4Q*LWAS1V.X>3-_I\H!RN67B)3E<
MKRP*D9(--TK1=-T2W,&F6<5NA^\5R6?D_>;J>O&3QTXKS<3F5*C[L=6<%?'T
MZ;Y8ZLJZC:ZOXO9Y?$]]*MA(=R:):2[(8E[+(ZX,I!5&ST#`X&#6O%%'#$D4
M2*D:*%5$&U5`Z;0.`!T'I3J*\"OBJM9WF]#QZV(J57[S"BBFR21PQ/+*ZI&B
MEF=FP%`ZDGM7/%-[&"6MAW6L;4-,T2V)NYX$M9I9,&:V9HII&8DX+1;6;N2.
MF!N(^7-5KSQ"\\133D*ALJ9Y4*%.!RJ,O/\`$/FVX.#AAC.4Z^;<&XDR]P05
M\QSE@"=Q&22=N<\=![5[&#P%;XI-I?B==-3@[WL5I-;UJRU(1Q3B:SN%"0O>
MHC21R@;B-L:J""`PQN(&W.[^$QE-\HFF<SW&TIY\G+$;BQ`..!DD[1@#L,8P
MS5AMAMYUR6BN(RO&0=Y$9)_!S^-35[M*E".R/H\%6E4I>\PHHHK<[`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBHYYA"@.'>1SMBBCQYDK=D
M0=68G@`=2:`;MN25`]R_VM;:WM;BZN"`S+"@VJIS@EB0`"5.`6ZUN:E\//$#
M^#M8U;4KG^Q6L[2:XAMH)%ED<H=V)"O"#:A`V,?OY)^7:9=#6V.C6EQ:VJVZ
M7,23L@.X[F7)+-U9N@R>3U-<^(K.G&Z'3M-V11M/#SREI-4E:3<?EM8G/E*`
M`.2%4OT.0W!W8*\9I/$D(AT_3WMXHUAM;J/]V#M`1@8@%P.WF#CC@5OU1UFV
M>\T2]MX5WS-"PA'0[P#L/L0V,'M7G1KSE43DS=P5C#K2\/?\C+I7_7Y#_P"A
MBLJ&:.X@CGB):*1`Z$C&0>F1ZUHZ-/#:Z[I]Q<2I#!%<QO))(P544,"22>``
M.<U[%SF>Q]`45@?\)UX1_P"AJT3_`,&$7_Q5%(Y;'04444A!1110`4444`%%
M%%`!1110`4444`%5[V^M--M'N[^Z@M;:/&^:>0(BY.!ECP.2!^-<3K/Q/L#)
M+IWA51K6J8VB6+FTMR0"&EE'!&"3A,DE2O!KF7TV^UJ47/BJ_&J2[P\5J%VV
MEOPV`L6?FQO8!V!;`'(P:Y<1C*5!>\]>QSUL53I;O4TM0^)&I^(9I+7P7;I'
M8[`6UN]B<(<Y#"&(@%F4\Y;C*L",8)SK#0+>VO9-3O&-]K$QW7&H7`R[-@CY
M1T1<':`H`P%':M7\"/3_``XZ<45\_B<QJ5M%HCQJ^-G5T6B"BB@]/\*X-3CN
MPH-4;_5K73Y%BE<-<-@K!&07QD@MMSPHP3DX].3Q7-W>H7NHY%SY<5O@C[/$
M2P8$8(=CC>.O&`!G!!P,=F&P-2MKLC6-)O5FU?>((8))H;2(W,\9(.24C!S@
MJ7P>1\W`#`%<''2N?G::\;??3?:&#AU5E`1",XV+T7&>IR<'!.:1$6-%1%"H
MHP%4``8XZ"G5[^'P=*BM%J;12BK1"BBBNH>Y4U.![C2[F*)0TIB(B(/1P,J0
M>Q!QS3(9H[B".:(YCD4,A(QP1D<>N*O?7/X5DZ6"FGI"1@0/)`N1_"CLHS[X
M`_&K@SULKEO$N4445H>N%%%%`!1110`4444`%%%%`!1110`4444`%%%'6@84
MUW2.-G=U1%!+,QP`!W-7]&T75/$DTL>C6R3I$Y26XDEV0Q/C.UFP6SCLJL1D
M;@H(->H>'/ASI>CM'=:ALU34D?>L\L>V.(@@J8XB2JL,9W<MDGY@#@*YE*HE
ML>>:%X+\0>)/*N;98+#2Y`'6]NOWAF4AL&.)2"5R%.YF7(.1N')]5\-^"]"\
M*H6TVS!NW0)+>SL9+B484'<YYP=JG:,+D<`5T%%28N3>Y'<00W5O+;W$4<T$
MJ%)(Y%#*ZD8((/!!':OG_P`&B>#P\NGWC-]MTZ:6SN49MWENCD;,]"`-N",@
M=C7T)7AMW;C2_B;XKT](S!;320W\$;YS(TB?O9%)Y9=^0<94$8XQBN?%1YJ;
M-</*TR[1^7XUGZCK5EIK+%*[27+J3':PJ7EDX)X4<X^4\G`XY-(NEZGJ<N^_
MNVLK3<"EK:MB1AE3B64<@\,"J8Z_>->8HVUEHCO;Z(Y+39)=W]D:=%)>7-O.
MUO\`,,+%&KNJM*X7"_*OIDX'!S72V'A!9'CN=<FCO95&5MO+`MXV*@'@Y+$?
M-R<]>@[=';6T%G;I;VL,<$"?=CC4(J]\@#CKG\S4M%;'SDN6&B%"BEJQ<C_;
M_.BF;Q[_`)&BN+VLNYM:/8]8HHHKZ@\0****`"BBB@`HHHH`**H:QK>F>'[!
MK[5KZ"SMER-\K8W'!.U1U9L`X49)QP*\XU+Q9XB\6(8-,AN_#>EG.^XF"?;+
MA2-I4+SY&#N^;);[I'<5E5K0I1YINQG4JPIJ\F=CXG\=:-X4EBMKMKBYU&=-
M\-A91&6>10<$@=`.IRQ&=K8R1BN"U*?Q%XQRVLW,ND:8XP='LI@2XQ@^=,HR
MRL&8%``,%>X)J32M$LM&2;[,CF:X?S)[F9S)+._=G8\DDDGTR>G-:%>'B<UE
M+W:6B[GDU\P<M*>Q%;VMO9P);VT$<$*9"QQH$`Y)/`]\\>_-2T45Y#E*3NSS
M92;U844V21(8GED=4C0%F=B`%`ZDD\"L"\\1NX*:6D3+DC[1-DH<8^95'WE/
M(ZJ.`1D'G6AAJE9V@BH4W+8V;N]MM/A\Z[G2),[5+<[FQG`'\1P#P.M<[?:U
M>7J^7;K]EMV49)<F8@@9&1PA'(SECSP5-4"I>433.TL^TKYTG+D9)(SC@9Y"
M\`=J=7O8;+H4M9ZLWC!1&K&B%V50#(Y=F``W$]6/3GWYIU%%>BDBKL****!!
M1110`'IZUEQ#RM5U"(_>=DG![;2H0?CF-OP(_#4K-G'EZ[&1_P`M[9@P/\/E
ML-N/^_C9]P/QJ.YW9?*U:Q8HHHK4^@"BBB@`HHHH`****`"BBB@`HHHI`%%,
M>5(R@8DM(P2-%&7D8\!549+$]`!R:[#P]\-]7UB%+K5Y_P"RK5\E(H5W73J<
MX+;QMB/"G:0YPQ!V'-%R932.2@26[OEL;."6[O'&1;P(6;&<;B/X5S@;V(4'
M@D"O1M!^%I$L=SXCN8KC:=QL+;+0MUXD=AF0'Y3@!!U5MZFNYT;0]+\/Z>MC
MI%A!96RX.R%`-QP!N8]6;`&6.2<<FM"I,)3;(X((;6WBM[>*.&")`D<<:A51
M0,``#@`#M4E%%!`445P&I_$I;GS+?PG9?VG*-R_;YR8K-"-ZY#8W2X91P@VD
M'[XJ9245=C2;=D=GJFJV.B:9<:EJ5REM9VZ[Y)7Z`?S))P`!R20!R:\:\3&X
M\8^,[?6]+EU/2+.WMQ;R23JH^UA9'QMA;[HPSD-)S\RX08)-V/3YIKV/4=6U
M"YU34D4A;BX("Q;E56\J,#9&#M'(&3DY)SFKW^>/\_C7F5\>G>--'=2PK6LB
MAI>CVFDH_P!G$C32[3-/+(7DE*KM!9B<_0=!S@#-7_U]?;UH]?;@^U17%S!:
M0-/<S1P1)]YY6"JO..<X[D#\:\UN4WKJSKTB2U3U#5+338P;B0&1P?*A4@O*
M1CA1WZCGH!R2`":Q;SQ#-=1LFFYACX`GFC;<0>#M1L;2.,%@>0?EQ@G*5"&9
MW9I)7)>21L%G8]2>/Y`8``'``KT,/@)2UGHC*=9;(V?^$N'_`$!]1_.#_P".
M45D45W?4*78Q]HSZ/HHHKI.`****`"BBN+\0_$?3=,N7TS1XQK>MJ>;*VE"K
M&`2&,DN"J8P1@_-DJ,<YI-I*[$VDKL[">>&UMY+BXE2&")"\DDC!510,DDG@
M`#O7G.I_$ZYU&YN;+P980WOD2&*35+Q]MHK#!^0*=TO\0R,`':>5(-8=U8ZM
MXFGCN/%]W;WD<3"2#3K:,QVL+CC<=QW2$@?Q]-[#&#6K%%'!"D4**D4:A$55
MP`HX``Z=`*\G%9K&'NT]6>;B,PC'2GJ9-MX<@_M#^T]6N9]7U4_\O=Z=QC.=
MV(U^[&N[)`'3)`K9HHKP:M:=5\TV>14JSJ.\F%%'Y_A6?J6L6VFD1O\`O;E@
M&6VB(WL,D$X)X7@\G`[9SQ2A3G4=HJXHQ<M$:%9%WK]M#,T%OBYE0XDVL-J'
M<`0S<X8#/RXR,<XR"<2^O+K5/DN66.VP/]'A9AG@9#L/OKUXX!SR#P1$/H!W
MQ_\`6KV,-E:7O53>-.,5=B7#3ZA(LU_(LTBD%4`*Q(1T*ID@'_:R3G(!Q@!:
M**]B,(Q5HHMNX44450!1113$%%%%`[7"BHYYX;:$RS2QQ1J`2SMM49Z<UF27
M5Y?D+9^;9P9.Z66$>8_S#[BD\9`/++T(('7`D;4</.J[11>N-0M+5PDLRB4@
M,L2@L[9XX4?,PX/(]*I;;J]NHY[@"*"%]\,)4&3.TJ2[!B,?,W`]B3G-306R
MPEF#,\C??D=BQ?\`'H!R>!@9)P*FJTK'L8;`QI^\]PHHHJSO"BBB@`HHHH`*
M***!A11UXSBK6F:7J>MW)M]*L)KEP0))/N0PDX^]*>,@,I*KE\$$*:"6TMRF
M[K%&TCL%1069B<``=\]JV]`\)ZQXE96M8FL[%AG^T+F'*,,`CRTW*7#97##"
M8R0Q(VGT#P]\-=.TFXAO=1N'U*^A<21EE\N"-@3@K&"<G[IR[/@J"NVNVJ;F
M,JC>QSWAOP9I7A@O+:B:XO)%V27=R^Z1ESG```51TR%5<[5)R1FNAHHI&044
M5C>(_%.D^%K'[3J=RJNP/D6R$--<L"!MC3.6.64>@SDD#F@#9KF/$?C:RT)V
ML[2WDU75>1]BM67,1V;E,S$XB4\8)Y.?E#8-<CJOB'Q%XD/E9;0M+$@)B@F)
MO)@K-PTJ$"($;"53<W4;QDU4T_3;/2K1;:QMHK>%?X8U`SP!D^IX').3WR>:
MX:^-A3TCJSJI864M7H,U!=3\2RR2^([LR6QD+1:5;N1:QJ&4KOX4SL-@/S_+
MECA1T-N*-(8DAB18XHU"HB\*H'``_#&*=2$@#GCZUY-6O.K\3.Z%*,-A<\9S
MQZTN/4<>XXK-O]:M;$NN'GG7AH8,;@?ER#G"KPP."03VKFKVZN]3`%W*4C(.
MZWA.$;.>&.`S<'!!^4XSM&>-J&#J5?)"E52V->_\21@>5IBI<R8#&=P?*0,.
M"#C$G7H".A!*D#.-,\MU=-<74SS.<[`^,1J3DJHQ@#@<G).!DG`-)P3G^G^?
M_P!5%>Q1PM.DM%J<\IN6X>_?N>E%%%=)(4444K!<^CZ**IZIJECHNF7&I:E<
MI;6=NF^65^@'\R2<``<DD`<FI.(N5S_B3QIH7A5534KP?:Y`/)LH!YEQ,3G:
M%0<\E2`QPN>"17':CX^UGQ(IM_"MO-I=D3D:S>1*6<`Y_=0MU#`H0[8X+<`@
M&J&F:-;::SSAY[N]F_UM]>/YMQ(.``SGG``48'&!T!K@Q.84J.BU9QU\9"EH
MM6/U#6/%/BQW9KV7P]HSG,5O:_+>R)U!DDY\LY4':G9BK$]:ET_3;/2[1;6P
MMHK>%>=B#&>`,D_Q'CDGGIS5JBOG\1C*M=^\].QXU;$U*KU>@444V21(8WEE
MD6.-`69V.`H'4DURI7V.=;V'57O+VVL(/.NYTC0G:I)Y9L9``ZDX!X'/I6/=
M^)#+N32PCX'_`!\2JQCSGH%XW#'1@<<KC/.,8!VD::::2>9P`\LF,D#H`!P!
M[8XR3U))]3#9;.?O5-$;PI6^(T+S6[N^BV6Z-9Q,2'+X,I7`[J<(>HXW'H<J
M1QGQHJ)M7/4DDDEB2<DDGKDG/7J<TZBO<I4*=)6@C6]M$%%%%;""BBB@`HHH
MH`***ISZE!%*T*J]S<#[T,(!9?\`>R<+D<\D9[9Z4)%PA*;M%%S_`#UQ6>=2
M6X.RQS/GCSP/W2GUSD;NXPN>F"5ZU`+:YNXQ_:5P).!N@@#)$?\`>/WF],$X
M([5=X[8XYQ[=.!Z52C<]6AEW6J5TMB9A/<RO/,,E2W"IG^ZO0=2`>6P<9JQ1
M15I6/4A!05HA11104%%%%,`HHHH&%%'3ZTV218E!Q(^YU1$CC+LS,P55``))
M)/0"@3T'?E^-.AAGNKI+6SM;B[N).$AAC+,1D#)[*`2,LQ"C(R1FNHT#X>:O
MK3++J0DTG3V7(Y7[4_`*X1@50'/._P"88*E!D,/4=%\.:1X>A>/2[&.W,F/-
MDR7DEP21OD8EGQN.-Q.`<#BIN92JKH<%X?\`A?)=(+GQ-(\:G&RPM)RN01_R
MU=<$,"1\L;8&T_,X;`])L;"STRS2SL+2"TMH\[(8(Q&BY))PHX&22?QJQ12,
M6V]PHHHH$%5[V^M--M)+N^NH+6VCQOFGD"(N3@98\#D@?C7%ZS\2;=W-EX3C
M@UB\^8/=&1A9VYV`@M(H(D.67Y$)/WLE<5S,]I/JE_%J.NW"ZE?0,Q@=H]D=
MN"P8"./)"XP/G.7.!EN@'/7Q,**UW-:=&4]C:U7QYJFL)Y?A6.&WL9(PRZM>
M1L68,K<Q0'!X.WYI"`><*PY.%8Z1:V$SW*^;<7LH`FO;F0RSRX`'S2,2<?*O
M`X!'`J^>._3D?RH.1Q@Y],5Y%;&5*O6R/0IT(P#GZ^OMZXH/&<\8ZYIDDL<,
M32RR)'&@+-([`*HY.23QC@_E7/WWB&2:/9IJ%`X!^T2C:5!`(*H0<GDCYL8(
MSAAP<J.'J57[II*:B;EY>6]C&'NI`@9Q&!@DECVP.3T)^@)/`-<Q=:W?W[,(
MP]E;,"-A(,K$@@DLIPO7^'G(!W#E11,2M=/=/N>=\CS9&+,`3DJ"2<+G^$<#
M/&.E/KV*&!A3UEJSGE4;&QQK$FU,XR3EFW,22223W))R3U/.>M.HHKN2ML9A
M1110(****8!1110![%\0_%UWX.T&VNK#3TO;R\NULH(Y)=BK(ZN58^HRHXR,
MYZBO-+6.#4-2AU'Q+J=]?ZI!N='U&$P06[*/F\M`/*!VJ"=I;.S</6O1OBOI
MTVJ?"[7H(&172`7!+D@;8G65AP#SA#CWQTZUQUE=)?6%O=QAA'/$LB[OO889
M&??GFO,S"<HP274\3'U)0BK=32BD2:))8F5HG4.A4Y!4\@@].A%/K)N+&WN9
M1(X=90NWS8G:-]N2=NY"#CG.,XSSUJ-8+^'_`(]M3=@.%2ZC$JJ/;;M<XX&6
M8]\Y)KP'AU)7YCQ^12ZFU1G'/I6)<:Q?:=:RW-[8K+;Q(7>2TERY`&2Y1\!?
MH&8\@<]:R;Z_O=2RD\BPVK##6\0^]D#*LW5ER.@"]P=PK2CE]6H^E@5![O8V
MKSQ!:6\K06["ZN$;:ZQGY4P<-N;!`(_N]<D9`'-<_--=WDJS7MP)2IRB(NV-
M#TRHY.<=V8D9.,`D4#Z`=\?_`%J*]S#X.E1V6IK&T5:(4445UC84444""BBB
M@`HHZ\5#<75O:1B6YGBA0G`:5@HYY[]:!I-NR)OQQ[U7NKVWM-OGR;6?E4"[
MG8>@4<DCJ0.G>JCW5U>/BT#6\&#F6:([VZ8V@D$$?-RRXZ8!'-/@MEA+,&9Y
M&^_([%BWXYP!R>!@9)P*M1N>CA\OE+WIZ(:S75[RS/:0G_EF,&4^N6!(`//3
MYN`=PZ"6*)(8PB*0H]3R3W).3DDDG)ZDY[T^BK2L>O2HPI*T4%%%%,U"BBB@
M`HHHH`***.>W6@`H_+\:FTVQO]<U$Z?H]HUU.@#3,LBK';`D;3(V>,YS@!B0
MK8!P17I/A[X7:?:DW?B`0ZG=,%"VY#&VA&.5V,<2G)/SL/X5(52.5<B51(X3
MP_X:U?Q2JS:7%$E@QVG4)F'E<-@[%',C#)Z84D,-X((KU3PYX%TCP^8KHPK=
MZHH^:]E4DJ2"#Y2DD1+AB,+R0!N+'D]/14F#DV%%%%!(45G:UKNF^'K%;S5+
MH00M(L*85G:1V.%544%F8^@!.`3T!KSW5/$^O^)5VV,TVA:5+$IP$'VYPRL#
MELE8ARI&W+<9W*>!G4JQIJ\F7"G*;LCK]=\<Z)H-W]@>62]U/C_0+%1+,`2O
M+\A8QAP<N5!'3-<'JLFL>*3M\0742Z>)!(NE6:_N6VLQ7S78;I>J''RKE0=I
MJ2VM(+1'6"()YC;Y&R2TCGJ[L<EF.!ECR>YJ:O*K8^4]*>AW4L,HZRW&Q1I#
M$D42+'&@"HB#`4#@`#L,<?2G9XW=O6@<C@$Y]*S=2UNTTTA6)FN6`*VT#KYA
M'/S`$X"\'DX&>.I%<482F]-6=-U%&ET(SQ6-?^(8+9Y8+-$N[F/Y759-D:,#
M@J[#.&Z_*`<8&<9&<6\O[S4FQ<,D5N5/^C19PQ90&#MQO'4`8`YY!XQ`J)&B
MHBA44855Q@#TZ?Y%>G0R_K4,95;Z(+AY[]]^H2).P<.J!-L:%>A123@\DY.2
M<^P`7G.<_P#Z_P#)-%%>I&*BK1,&PHHHJA!1110`4444`%%%%`!1110!]%W$
M$-U;RV]Q%'-!*A22.10RNI&""#P01QBO!O!8G@\.1Z?=LWV[3YI;.Y1FW>6Z
M.PV9Z$`$8(R/0U[[7B)M?['^(/BK2L.L,URNI0&7AI/.7,A7IE`XV\#CH237
M!CH\U%^1X^.CS46^QI4445X!X(5QFG(8;"*W.-T`^SM@Y!:,E3CVRI(_ITKL
M^M<EL$.H:C`I)2.Z9@2.?G"R']7./8?GZ672]YQ-Z6L6B2BBBO5&%%%%`!11
M1DCD=:`"C_/%5+G48;:?[.L4TUQL#"*-/X<D#YC@#[IZD=.]5#;3W6\WTC%&
M/%K&WR```<G"L^><AN/FQ@XJE&YV4,'4J^2)7U7S&>.RMWN75F1G;,<:E201
MN(.X<'[H/3MUI$M6\X3W$SSS`G:6.$0]]JYP.I`)RV#C<:G1%C14C5511@*H
M``_`4M6HI'LT,)3I+3<****9TA1113`****`"BBBD,**CEFA@B,T\D<48P2S
MML`)XZUU'AWP%K>O_P"D78&DZ?OP&EB;[3(`1G$3*!&#\P!;/W<[""#1<AS2
M.9+@S1P(DDL\I/EP0QM)(^.3MC7DX')P.!S7=:!\+KZ\CBN/$EP+1"`S6%E)
MN<]"0\V!CJRD(,\`B2N_\.^%])\+V1M],M$C=\&>X*CS;ALD[I&`&XY9CZ#.
M``.*V*DQE4;*]C86>F6<=G86D%I;1YV0P1B-%R23A1P,DD_C5BBB@S"BBN0U
MWQ[;:?<FQTBS;6+X,5D\F54@MV5PK+++SM<9)V*&;CD`$&DY)*[&DWHCJYYX
M;6WEN+B5(8(D+R22,%5%`R22>``.]>>ZA\0[C689;?PM;310R1G;K-W#M120
MI4Q0MAI#\QY8*H(S\XX.%<6EYJM]'>Z[J4VH3Q2^;!%CR[:W8%]I2('&X!\;
MF+-P/FJ[^'_UJ\VMF"7NTSLI85OXBG;Z>L=]+?W%S<WFH2J4DN[I]\A0L6V+
MT5$!8D*H`X'H#5P].GX4`$G`!)]!39)8X8FEDD5(T4NSE@`%').?3WZ5YDIS
MJ.\G<[8Q4%H.R,9R,>N:KWE_::?!YUW<)#'G:"QY9L$[5'4MQ]T9/M6/>>)'
M%P(M.B#A&Q)/,&"@J>0@X+\#KD`9!!;D5B`2,[2SSR3SL`IFD(R0.@PH``'/
M`&.2>I)KMH9?.>LM$92K);&C>Z[>7@Q9DVD))`=XP9648P0&&$Z-P0W!_A.<
M9T:+&NU<]2222=Q/))).2<\Y/.2?6G45Z]*C"DK11@Y-ZL****UN(****`"B
MBB@04444`%%%%`#7=8T9V^ZHR:@LKZ&_@\V$G&<$'J*KZM(S1Q6<9Q)<OL^B
M]S^5)+:-92"XLDX`"R1#^,?XU:BK:[F,JDE+39;FE15+^U+?_;_[Y-%+DD5[
M:'<^G*\E^(<'V'XH:#?[]_\`:6G367E]/+\IO-W9[YWXQQC'4YQ7K5><_&2U
M\OPUI^NH$5M'U&&>60<2F%CY;HAQ_$63(R`0O/0"N:K'F@T<=6/-!HR:*/T]
M,C'K_2BOF;=#YGR#K7-ZNIB\0*[``7%J-H!Y'EN2<_\`?U<>P/X])_GBL/Q%
M'B2PN54@K,T;OV$;J>O89=8QGKG`XSBNK!SM51M1?O6*5%%%>[8L**9-,EO!
M)/*VV.-2[-C.`!DG%9S7LNH0K]@#Q0/AA<MC)7K\JD'.1Q\P'4$!@*$KFM+#
MSJNT47+N\ALD1IW?#MM3:A<D\GHH)Z`U3=KR];YC+908(,:LOF2'C@GG;C!^
MX23G.5Z4Z"TBBD,V3+.PPTTAW,<\G'HI/.!A?:K%6HGL8?`0IZSU(H+>&V39
M#&%!.YB#DLW]XGNWN3S4M%%6>@E;1!1110`4444`%%%%`!11_GIFG6$-QJ]V
M]KI%I+J%PAVO'!AA&>?OOD*AP&QN*YP0,F@&TMR-W2-&>1PB*"69C@`>IK0T
M30=6\4/&-)@Q;,X#ZA+'FW1<D,5.X&0_*PPA(#8#%0<UWGA_X5V\"13^([H:
MC<``M;0@QVP;@\C.Z3G</F(5@>4S7HM3<QE5['*>&/`&D^'9A?.JW^K8`^W3
MQ+NCX(*Q<?(IW/W+'=AF;`QU=%%(Q"BBB@`K"\0>+-,\/;8IC)=7S[3'86@#
MSLK-MW[20%08.78A1C&<X!X_XC^+=:T_7K7PW802V]K>V+S27L#A+B0[MICM
MV?"!U&&8G)"MD;2`3RUA>Z+I1E$D+:;-,QDGDO0=TCEB?FG)*R,2S'[['KT(
M(&%>M[-:*[-J5+G>NQM:IJ&M>+;?R]9_XEU@W/\`9UC<MF163:RSRC:7&2WR
MKM7UW\8DCCCAB2*)%2.-0J*HP`H&``!P``.@P*(Y$FB26-U>-P"CJ<A@1D$'
MN.GYBG5X=:O4J/W]$>C3IP@M`HJG?ZG;:<B^<=\CAO+B7EI-HR0.P[#)P`2`
M2,BN9N]4O]1,@DD>WMF&$AB8I)C(.6D!SNX_AP.2"6'-70PE2KMHARJ*)N:C
MK]O:JT=NC7<X.S:A`5?O#YF/`PR8(&6'ITKG;J:YU!U>\N'D`VGR4^2(,,<[
M?XN0&&\M@CC%,1%C141555&`JC``]A_^K]*=7LT<)3I=-3GE-R#L??G_`#_.
MBBBNDS"BBBF`4444`%%%%`!1110`45F:EK=MIQ,9S)-_<';ZFN>N-5U34#YD
M0=(UZ"(''YUK"C*2N<]3%0@[+5G:45RNC:]*+A;:\?<K?*KGJ#[UT\JNT+B/
M[Y'!]*F=-P=F73K1J1NC':[ACU=[F<EOE,=NJ@G(!^8_G_*M>*420/*R.@`R
M%8<FLZ2".VU;3@B@*8Y$]>@!J^+B,W36Q.'"!L'N*J=M+$4^;6[ZF3_PDMM_
MS[2_D**L?V1#13O`SM6/J.L#QMHO_"0^"=9TM;?[1-/:OY$6_;NF4;H^<@#Y
MPIY./7BM^BN8#Q.!?$>G6MA#KGAG5EN9$*R36T*W<>5[D0EBN<C'RCDGK@FG
M6&LZ;J846-_;SLR;]B2`N%]2O4<XSD9&:]JK/U+0M(UGRO[4TNQOO*SY?VJW
M279G&<;@<9P/R%<-3`4YZK0X:F`ISU6AYG]>E97B-6.@W#_\\"D[`M@E8W#L
M/KA>*[AOA5H,!MO[*N]6TI+??B*VO#)&V[U28.O'/0#J?;&%K'@+Q7#I$T%M
M=:7K6^UDC>.6-[1W;;@8(9E8MSD$H,XY';F6`G3DG%W.;ZA.$DXNYR&<<\^O
MT_\`KXJO%//>.4T^UDE*LR-)+F*)2"01N();E2/E!&0,XIECI&H)XIUC1O$$
MT4[Z:ML#%;L?)<O'N)/RJ6!XRI^7DC!&".HBBCAB2*)0D:*%10H`"CI@"NNM
M7Y'R]3T<+E:E[U0S++08(1%)>2/?7,>TK),`$5A@AE0?*"#G!(+<XW<8K!TY
M/)LDMNOV=FMMW3=Y;%-V.V=O3MGOC-=I_GKBN3E06^M:C#@*K2+/&H&!M9`"
MWH,NLF1USD]^5A*KE-J1ZLJ4:<4HH=1117>0%%%%,`HHHH`***CGFCMX))I6
MVQQJ78^@`R:`V)*:S,98H4BGDEE8HD<$3S,QP6("J"3P"?PKHM#\"Z[K[QO)
M#-I.GEP7GG0).RYY$<3*2/NE<R!<;@P#C@^I^'_".C>&UWV-KNNV39)>3'?,
MXXR-QZ*2`=BX4'HHJ;F<JB6QP'A_X9:AJ$RW/B!Y=.M0.+*"9&ED.[D2.H(1
M<`XV,20X.Y2N#ZCINFV>D:?#86$"P6T*X1%R>^223R22223DDDDY)JU12,&V
M]PHHHH$%%%%`!1110!Y=\8(/L]]X0UK>3Y&HM8B$+][[0F-V>VWR^F.<]167
MTZ`?0?\`ZJ[/XKZ?-J?PNU^"!D5T@%P2Y(&V)UD8<#J50@>^.G6N%LKI+ZPM
M[N)2L<\22J&`R`1QD#@<&N#&IZ21V85[HBDTJRE8/Y)BD&1YEN[0N0221N3!
MP22Q!)!/)&>:K:S>ZE8E+F&]'V:29$E5XU/E`\`I[,Q52#N^\2"N*U:S=?MW
MGT*[6)7>6-/-B15R6>,AU`'?)4#%<M-WFN;4Z9+W=##BACB9W4,TDF-\LCEG
M?'3<QRS8'J>/IQ4E(CK(@=&5E(W!E.0<XP0?2EKVTE8Y@HHHI@%%%%`!1110
M`444=.I`'O0`45E7?B&QM7V!S*W?9T%7[6Y2[MDG0$*XR`:IPDE=HB-6$G9,
MIZGK,&FX1@7E(R%%/TK4TU*W+@;9%X9?2L/Q6N+J!O536?:7$^BWZLP.U@-P
M_O*:Z%14J=UN<4L3*%:SV-'Q5:E9XKD#AAM;Z]JU]"G6XTJ+&,I\I%)K$27^
MC.T1#@#>I'?%9/A2YQ--;D_>&X4M94K=AZ0Q"?21#XEL3;WHND&$F))QV;O^
M==-ILRW&FV\JG.Y`#[$=:I>)4WZ.W&=KJP]NW]:A\+$G37'.`YQ2D^:DF^A5
M./)B'%;,O7N%U#3Y.01(RY'NIXJ5[8MJ<5R,86-E/K[5)/;^>8OFVE)%<'TP
M>?TJ8\'!.#Z'BLN;1'1R>\[A129'J/SHJ#4^D****@XPHHHH`****`/(/B'`
MUE\5='OY2IBU#2I;*$+RRO%)YC%O;:X`QGG.0!S4-;'QEMA#8^'=;2-A+8ZJ
MD4EQSMAMY05DW=@"0@W'H<8(S6.<?Y_//O7FXV/O)G?A9>ZT`ZUS6M^7!X@M
M&\P!KNV9<,<9\L@C'OB5\^P'OGI:Q?$J?Z#:W.<_9[J-MO\`>WYBZ]L>9GWQ
MC`ZUEA9<M0VJ*\3/HHHKV3F"BBB@844MM%=7^H1Z?IUI+?7S@OY$++N5`#EV
MW,JJN1C)/4@=37HOA_X5QK,MWXFEBNV482QMW?R%.[.7/R^<"`/E*A1N8$-P
M07,Y5$CA=%T?5O$EQ+%HUFLR0MMENI90EO$V"=C,,L6XY55.-RYP#FO3_#7P
MVTG1'2[O]NJ:FK^8L\J$1Q$8VF*(LRH1M!W<MDMR`<#L(((;6WBM[>*.&")`
MD<<:A510,``#@`#M4E282FV%%%%!(4444`%%%%`!1110`4444`5[^QM]3TZY
ML+N/S+:YB:&9-Q&Y&!##(Y'!/2O`_!DL[^%[6"[RMU:E[::)EVO$R,0%9>""
M%"CGGUKZ$KPB.`:9X[\8:5N\S;J(OO-(QG[0@DVX_P!GIG//H*YL5&],Z,-*
MTS2HHHZUY29WG%Z<AALDMB2WV8O;;O[WEL4W>V=HXYZ]35JDG3R-;U*+:(P\
MBSQH.FUT`+?BZR9]SGORM>]3E>*9RO>P44458@HHILDB1(7=@JCJ2:`;L.HJ
MI9:C;Z@)/(8_(V"#_.K=-IIV8HR4E=!7+^)=2?S?L,?"C!<^N>U=17`W[YUN
M9F[3?UK;#QO*_8Y<9)J"2ZFOI_AA9(5DO&=689"+Q@>]=%;P):VZ0QYV(,#-
M2*=R@^HI:SG4E)ZFM*C"FKHYKQ:OR6S\=2.E+=6!U+P_;3QY,T,?&>Z]ZG\4
MINTZ-L_=D]:Y^&ZOKBW2QM]VP=D[_6NFFFX)KH<-=J-62:W-'PYJ6UC83'*/
M]S/8^E4HB=,U\`\*LF#]#3+S2+K3H8YY,?,>2I^Z:DECEUEXGMXRTP7;+Z<=
M\UI:-VULS)RERJ+W6QJ^(M4@>U-G$^^1B-VWH!6CH5J;32XE;.]_F((QC/:J
MNG>&H;<I)<L9I@<[5^Z#Z>]=!:6=[J5P+33K"YO;@H"R0*,*#G!9V(1`0K8W
M,,X(&37+4G%1Y(G=2C+F]I4(U^;&TY'7(-7]'T+6?$#8TFQ,D0)#74[&*W4C
M.1OQE^5(P@;!X;;7=Z#\+H`%NO$LBW<^XG['#(?LR\\;B0K2$\Y#80AL%3C<
M?08(8K:"."")(H8E"1QQJ%5%`P``.``.U<[9K*KT1X__`,*4US_H?#_X*4_^
M.45[)12,N9A1110(****`"BBB@#D/BEIG]K?##Q!;^=Y6RU-SNV[L^41+MZC
MKLQGMG//2N`TZ[^WZ9:7FP)Y\*2[0<[=R@X_#->U3P0W5O+;W$2302H4DCD4
M,KJ1@@@\$$=J\:C\#>,_#.C0V=I8VFNK`[1QO'?^3*T>259ED3:H`VC:';!Q
MCBN;$TG4CH=%"HH/4DJCK-L]WHE[;PKOF:%A".AW@'8?8AL8/:FMK,$$UG!?
MV][IUQ>?+#'?6<L&Y@`2`74*3R!P>XQUK0KSN2<))M';S*2T.2AFCN((YXB6
MBD0.A(QD'ID>M/JK9A+6Q:)FVQ6CR0!VPN$C=E!.>`=JY/T/3I71^'O"&M^)
M_P!]:K%8Z;A2M[<QN3)E<_NX^/,3[OS[E'S<%L$5[::M<Y7)+<Q'D2,H&/SR
M,$C0#+2,>`JJ.6)/``Y-=AX=^&VIZRL-UKC?8+!F#_98V<7,R!B0'/R^3G"D
MK\S88CY&KT#PUX,T;PLKR6<'FWLN?-OYT0SR`X^4LJ@!<*OR@`?+G&22>AHN
M82J-[%'2=&TW0[(6FF6<5K!G<PC7EVP`68]68@#+$DG')-7J**1F%%%%`!11
M10`4444`%%%%`!1110`445EZ_P"(M)\+Z6=2UJ]2TM0X0.P+%F/0*J@ECU.`
M#P">@-`&I7C7CR2W7XOV4J7MI(\FDM:/!'.OFP.L@ERZYR`RN-O4G!.,#-3Z
MGXN\3^+25TLS>'-%<;2\L0%_-V8#DK$#D@$98%`P.#BH=,TJUTN)E@0F:0[I
M[B0[I9VY)>1SRQ)8G)]2!@5Q8G%TX1<=V=-&A-M,0\=:,@=>@ZU.EC;12&2*
M%8F<L[>7E=S-@EF`."QP/F.3^9S"EG+!9E$G>YE4-M:;"[CV!VK@#/'"_@37
MEJ<;:'H6?4YO6T,.N6\QW8N+<Q.6'&Y&W(![D/(<=]OL:@J]XD!CM=/:9XDN
MDG5U@20$N2"CA>F0HD+$XZ+T`.11KV\*[TT<D]PHHHKI)"J6K69O=/DB!(;J
M/>KM4[G5+.T;9-.H;&<`YJHWO=$5''EM)G(Z/>-IVIKOX1CL<>E=3J.M6NFX
M1]TDQY\M>,#U)KFM<MX_.6\MR&@GY!'K1HU@-5O'-S(Q5%!()Y:NR48R7/(\
MRG4G!NG'J:5OXL1Y`)[?8G=D;-96O0JFH^?&P>*X42HPZ'U_(BKNMZ%':0"X
MM`VQ?OJ3G'O6?:^9?VGV+)9X_GA'I_>%534/BB36E4^">YUNC7IOM-CD;&]/
MD;'MWJ_7!Z7J<FEW))!,9X=*Z"X\3VB0[H59Y#T4C&/K7/4HRYO=.RCBH\GO
M/5$WB-0^D2'^ZP/%5O"A5K&48&X28SCM@=ZIZ?9W>L>?+<7#10RGGT)]A706
MME::5;,(_D0`L\DC=<=SG@8HDU"')?4F"=2JJMM">:WBNHC%*F]&ZBFHL%E'
M%#$@C$C!(HT4EI&/15`Y9CT`')-='H/@O7/$<<=S`D-CI\GSQWER"_F#!PT<
M0(+#(ZL4X8,I<5ZKX?\`!^B^&EWV%H#=,FR2\F.^:0<9!8]%)4':N%!Z`5SN
M3M8Z)2C>Z6IP'A_X8ZAJ,JW'B%Y;"T`_X\H9D:64[AD2,H(08!`V,20P.Y"N
M*].TG1M.T.R%IIEG%:PYW,(UY=L`%F/5F(`RQ))QR35ZBH,FV]PHHHH$%%%%
M`!1110`4444`%%%%`!1110!'/;PW5O+;W$4<T$J%)(Y%#*ZD8((/!!':N4O?
MAGX7N+@W5E8#2;SR_*%QIN(<+G)S'@QMGU9">G<`CKZ*+7&FUL<'8_"7P];Z
MP=2OY;S5V)+>1J'E/#O*A-Y18U!(5<#.0,YQGFN\HHH!NX4444""BBB@`HHH
MH`****`"BBB@`HHHH`*CGGAM;>6XN)8X8(D+R22,%5%`R22>``.]<=XC^).F
M:3=/I>D1C7-<4\V-M*%$8!(<R2X*IMP1M/S9*C`!S7#7NFZAXGNDO?%UVEXR
M,ICTZV9ULHBO1@AY=N6R6S]XC&`*QJXB%)>\S6G2E-Z'1:U\2;K5)9]-\'VC
MR+N,3ZY,!]GB]7A4_P"O(PX[+N"GYE-<]::$J:E_:^I7MSJFKE2IO+I\E`>2
ML:_=1<EL`#C<0..*U8HHX84AB14CC4(B*N`H`X``[?X4[MGMZUY%;&SJ:+1'
M?2P\8:O<.G?CZ_Y^M%'KG(]?:L*\\2PF$KIFR[D<L%F0AH4/!))!!<8)^[G)
M!!*X)'/3I3JNT4;2DDMS:FFBMTWSR)$F0-SD`9)P!SZDC'KFN:O/$<MU$RZ8
M?)CP,3S1G<1T.U&QMQQ@L""0?E(P3F7*F\OQ>W;M/*A81;ND2L>0H&`/J<L>
M`2:'7S$9'.0>O/7\:]>A@(P=YZLYIU6]C%DURTL)Q;))+<L2/-N9)"[,>F6/
M4G&!Z8`XZ8VD=9$#J<J1D&N'UG2VTVX&T$PO]T^A]*U_#>I[T^QRMRHRA/IZ
M5[,J$5!.!YE+$R]HXU#HZ*Y74O$EP9FBL3Y:J2/,`R3]/2LZUUJ^MK@2-,\@
MZ,LASD4EAY-7*EC(*5D:GB'5Y8YS:6[E`H^=AW]JAL/#<EU$D]S+M#C<`O)_
M&J>M0$S+>H=T%R-RMZ'N#21:[J$4"PI*,`8!VC.*W46H+D.1U(NHW4U1TT^C
MQG2&LT).W)0MU!KE=-NFT[4E9L@`[7%-DOM1#"5[BX&3D$L0#_2H[F66\=KJ
M1!DX#%1@9Q54Z;2:D[W(JU8R:<5:QWTRI<VCKP5D0BN*T3>FMP!#_$0<>F#F
MI8-5U0V1@@!:,#9N"9('UK4\/:/+;R&ZN%*OC"(1S]:S2]E%ILW<O;SBTMC0
MO=$LKUB[H4<_Q(<57M_#-E"X:0R2D'HQX^E;<"S7=XEE90375XX#)!;IN?:3
M@,>RKD@;V(4$\D5Z)H/PL*RQW/B.YBGVG/V"V&86Z\2.PW2#[IQA!U5MX-<O
MM9)63.N5.DG>VIPNAZ%J7B!G@T.TCECA<QRSM*(X(6`)VLP!)/'W55B,C=@$
M5ZEX<^'.EZ.T=UJ`CU/4D?>L\D16.,@@J8XBS!6&,[^6R6PP!"CKK>"&UMXK
M>WBCA@B0)''&H544#```X``[5)6;=R7)L****1(4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%4]5U6QT33+
MC4M2N4MK.W3?+*_0#^9).``.22`.37FVJ?$+6?$:FV\)VTVF61.?[:O802X!
M)_=0-U5AMP[8X+#`;%3.<8*\F5&+EL=IXE\;:#X415U.]'VN4#R+&`>9<3$Y
MVA8QSR5*@G"YX)%>>:IK'B/QIYB74G]D>'9Q_P`@^-?]*N83CB=_X,X!VI_"
M[*2>M,T[1;;3II+CS)[N^ER);^[?S;B0<`!G/)`"J`.!\H]ZT>O'OQZ5Y=?,
M&_=I_>=U+"6UD5=/TVRTJT6UL+:.WA7'RHH&XXQDGJ3QU.3QR35JCMFJU[?V
MFGV_G7<\<4>=HW'EFP3M`ZLW'W1D^U>=K.7=G7I%%G(YY%9NH:[9:;=QVTK,
M]W(N]8(AE@N0"Q[*N#W(ST&36)=:]>:E`JVZ26%O(3NW\3E>.A!_=]_[QQC!
M4]**1QH79(U5I&,CE0`68]22/S_G7HX?+F_>J&,JW1$UW>7>IHR79\N`X`MH
M9#MP`00S``N#DY!&W&!MX),*(D<:QHH5%4*%`P`!T`'8>U.HKUH4XP5HHYVV
M]6%%%%4!5U"R2_M'@?OT/H:X*6.6TN7B;*NAP<5Z/7/^)-,\^'[7$/GC'S@=
MQ75AZEGRLX,91NN=#?#>G6YM3=OMDE8D`'^$5'XETP;1>0H!@8<`?K6=H6I?
M8;L(Y_<R<-['L:[22-)XF1@&1A@^].HY0J78J,(5:/*MSD_#]U$['3[I5>*3
ME`W8^E="MCIMJ=PAA0^__P!>N-U"TDTV_9`2-IW(W\JTSIUSKS+>QE4#*%8,
MQY8#DXJIQ3]Z]D9TIM+D<;R18\1ZE:S6HM8F$CALY7HM.T71EGTF47*NOG$%
M<=0!T-3V7AZTL$:>]99=HW$O\J*,=?\`Z_2NTT#PEJ_B9D:TA-G8$;A?W,&4
M(P"!&A*M(#D$,,(1G#';M.4JJC'E@:QI-RYZGW'/006FG110P(%\Q@D:@%GF
M<]%`'+,>@`Y/05W&@_#?5-8C2ZU.X;2[.0!EA1`;I@0<;@PVQ'A3@AR0<$(P
MKT'PYX/TGPTA>UB,]ZX*R7UPJF=U)!VEE4`+P/E``R,D$DD[]<[DV[LTYK*T
M="CI.C:=H=G]DTRSBM8<[F$:\NV`"S'JS$`98DDXY-7J**DD****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MN4\3^/\`1O#DK:>DHO\`7'!$&EV[9D9\`@.1D1##!MS8^4$C.,4-V!*YU=>>
M:Y\3T-S)I_A*Q&M70`#7PD`L821WD'^L9<H2B]03R""*YC4WU_QFK)XGGBMM
M)<[AHUD3@X.5,LOWG89Y"X4E%(J_;VT%I;I!;0100KTCB0*JY.3@#IR<_7TK
M@KXZ,-(:LZJ6&<OB,W^R)]3U2/6O$5X^HZFC>;$A8_9K-C_##&>`,!1DY)*A
MN&YK7`QP.@&.G8=/PHS@9/2C_/K7DU*TZCO)G?&$8;`!GIS3)9$AA>65U2-%
M+,['"@#J2>F!@\UF:EKT%D7AAC>ZND(4QJ0`F1D;F/3HN0,L`P..1GG)KB\U
M!(VU*56D!W>7#E8@>,#:?O`%01NR0<D8XQT4,%4J:O1$RJI;&O>^)I1>+#IU
MN)$#,9+F8,JJ0>54<%R1GY@0HR.6Z5C`2,[2SS23SL`IFD(R0.@P```.>`.Y
M/4DT[L??G_/\Z*]FEAJ=)>ZCF<FPHHHK<D****!A1110(*0@,"",@]:6B@&K
MJQPVN::=/O-R#]S(<H?3VK>\.:B;JV,$A)>(=?:M.\LH=0@\F<$J2#\IY_.G
MV$"27(TO2;5I[K@_9K5-\@S@!G_NCD?,Q"C(R16\ZRE"SW.*%"5*IS)Z$=Q8
M6MW)&]Q$)/+.0#_6M#1]/O?$,@AT.S-ZH.TS1D+;Q<@'=+T!&X$JN6QR%-=Q
MX>^%LD\,=SXENG!?+#3[1C&$!SA9)58LS`%3\A49!&7!KTR""&UMXK>WBCA@
MB0)''&H544#```X``[5SN3:L:N23O%'&^'OAKIVDW,-]J-P^IWT3B2,E/*@B
M8$X98@3D]#ER^"H*[:[:BBI,[W"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHJ.>>&UMY;BXECA@B0O))(P
M544#)))X``[T`25EZ_XBTGPOIAU'6;U+2U#A`[`L68]`JJ"6/4X`/`)Z`UP^
ML_$FZU26?3?!]H\B[C$VN3`?9XO5X5/^O(PX[+N"GYE-<]::$J:E_:^I7MSJ
MFKE2IO+I\E`>2L:_=1<EL`#C<0..*YJV*ITM]S:G1E,OZGXN\3^+"5TLR^'-
M%8;3)-$!?S=F`Y*Q`Y(!&6!0,#@XJ+3=)M-*B<6Z%II3NGN)"6FN&R27D?JS
M$DGGU.,"KO3OQ]?\_6BO(KXN=7R1Z%.A&""BF3316Z;YY$B3(&YR`,DX`Y]2
M1CUS7-WGB*6[C9-,_=1D`">:,[B.AVHV-N.,%@02#\I&"8HT*E5^Z7*:1MZC
MJEIID8:XD'F/GRH5(\R4CLH[GD9[#.3@<US5]JFI7UX"LQM+.,G;%"WS2\@J
MS/P1T^Z/?+$<53@A\A-OF2RL?ORS.6>0CH6;J3@`>F`./22O8H8*%/5ZLYI5
M'(9%#%;QB*&-(XQT1%``^F,?RI]%%=I`4444Q!1110`4444`%%%'_P!?_/\`
M+\Z!AVS3))%B`RKN2ZQA(T+LS,P4*%4$DDD#`]:UM#\+:YXIB273[:2SLY5R
M-0NU,8"G&&C1AOD.&##@(0"-P->K^'_`NA^'I4N887N[],A;R[(>1.H^3`"Q
M\':=BKD`9SUI-F4JB6QY[H/PZUG6WAGU%I](T_EC@K]IE^7Y<(RL$4[LG?\`
M/\NTJ.M>K:-H>F^'[#[%I=L((-Y=LNSL['NS,2S'``R2>`!T`%:-%28.3>X4
M444""BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`*^<1JVI>-)CJ/BZSO;D0S;/[-MFVVMFT?!\R`MYAE
M!WDY#$APO/`'T=7A$=O_`&;X[\8:3N\TKJ(OO,QC/VA!)MQ_L],YYZX%8XAM
M0;1M02<]30L=5TF4Q65K<P1RJNR.S8>5(H`Z>6<,!@9Z#@`].:T,BL^1$E4!
MU#*&#`$="""".O0@'Z@54ATV.T8M92S6F590D,G[I<CM&<HO.&X`Y'.02#XT
MJ49/1GI)M:6-S\<>XK"O/$L)A*Z9LNY'+!9D(:%#P22007&"?NYR002N"1BW
MT][/=7&FW]R\D48C**O[OS8B#@R;?O$G<I4_*=H.T9YC1$CC6-%"HJA0H&``
M.@`[#VKMP^`7Q3U,I57L@N5-Y?B\NW:>5"PBW=(E8\A0,`?4Y8\`FG<]SG]<
MT45Z<8J*M$QN%%%%,04444P"BBB@`HHH!'J/SH`/KQ]>*.?<4T&62YM[.W@E
MN;VY8)%;1$>9(>Y`)&`!R3D``$D@"N\T'X63W<D5UXEE$4`RPL+65E<DC@R2
MH1C&YLHF1D`[R.*39$II'&:;8:AK>HM8Z/9F[GC`,S[U6.VR1CS"3D9SG`!8
M@$@'!KTKP]\+M-LXDGUX_P!K7A&6AF.ZVBSGY53`\P`$#,@8Y4,`I.*[:QL+
M/3+..SL+2"TMH\[(8(Q&BY))PHX&22?QJQ2N8RFV%%%%(@****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"O'?'=N=.^+-K<F(0VVK:68PR`8N+B)\DL!U98RH#'MP#QBO8
MJ\Q^,5KY$?AOQ`JN38:AY$K$?NHH9UVN[^F"J`$D`%N<Y%145XM%TW:29D4<
M#KT[T4<CIUKQ'V/5OK<YO6D,.OV[9.ZXM75P>G[MQC'U\UOT]\PU?\2QXM;.
MXR`EO=(S#')#!HAC\9%)Z<`^@%4.V>U>QA97IHY9JTF%%%%=)(4444`%%%';
M/:D,*.^._IWH.,<].E:.@>'M6\53`:9'&MC@F34)]PASN`_=\8F/#'"D#*X+
M+D47)<DMS*FFB@B:6:5(HQU=V``S[GZBNIT/X>ZYX@@26_1]$LI%!Q(<W14@
M$A4!VQG!.&8EE88*'K7?^&/`&D^')A>NJWVJD#_39HE#1\$%8@!\B_,_<L0V
M&9L"NKI-F$JC>QEZ)X<TCP[`T6E6,=OOQYDG+228SC>[$LV,G&2<`X'%:E%%
M(S"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"N1^*.F_VK\,?$%OYOE;+0
MW.[;NSY1$NW\=F,]LYYQ775'/!#=6\MO<11S02H4DCD4,KJ1@@@\$$<8H`\4
MTV[_`+0TNTO=FP7$*2[`=VW<`Q&>]6JP/!JW$'AY=/O"YO=/GELKE&;?Y<D;
MM\A/((`(Q@D>E;]>)5CRU&CU8/F@F9OB"$S:!?!$9Y$B:6(+U\Q/F0CUY4<5
MB0RI/`DT;;D=0ZMC&0<<XKK02"",Y[8KC+!1#:FW4DI;2R6RG.251V1<^^%'
MXY[5W8&6CB9U=[EFBBBO0,@HH_3ZU&)D:Y2UC#S74@W);P(9)7'JJ*"QZ$\#
MH">U(&TB0YZ=ZDL;6]UC4!8Z1:_:KO>H<9(2`-SNE<`B,;02,\G&`">*[/0_
MA9>:A`DGB:9+:%U!DT^T?>S`@9624C@8+*0@[`AZ]0LK"STRT2TL+6"UMH\[
M(8(PB+DDG"C@<DG\:39C*KV.%T'X66,+Q77B)H-3F496S\D&UC)'HP)D89<;
MC@'(.P,,UZ%112,F[A1110(****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@#PEK=-,^(?C#3(<M"+V.]#2<MOGC\QQQQ@'IQQWSUK1HHKR,5_%
M9Z5#^&@/3H#[&N3F&S6M6YSBX0=,?\L8J**UP7QCJ[#J***]4QZ&CH&AR^(O
M%":.MXMK$+>2XFE6'>[!6B!5,G"DB4X)#8QT.<5[+X>\,:7X9MY(]/B<RS;3
M/<3.7EF(&`6)Z#J0J@*"QP!FBBI9RS>ILT444B`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@#_
!V:**
`








#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Make sure tsl can be applied with catalog" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="4/26/2021 1:40:23 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End