#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
24.09.2015  -  version 1.01
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl specifies a distribution point.
/// </summary>

/// <insert>
/// Select a set elements.
/// </insert>

/// <remark Lang=en>
/// The distribution point can be used as a starting point for distributing sheets.
/// </remark>

/// <version  value="1.01" date="24.09.2015"></version>

/// <history>
/// AS - 1.00 - 23.09.2015 -	Pilot version
/// AS - 1.01 - 24.09.2015 -	Add option to set the height during insert
/// </history>

String distributionPoint = "HSB_G-DistributionPoint";

PropInt distributionNumber(0, 0, T("|Distribution number|"));

PropDouble symbolSize(0, U(100), T("|Symbol size|"));

if (_bOnInsert) {
	if (insertCycleCount() > 1) {
		eraseInstance();
		return;
	}
	
	_Pt0 = getPoint(T("|Select position|"));
	_Pt0 += _ZW * _ZW.dotProduct(_PtW - _Pt0);
	
	String numberByUser = getString(T("|Specify distribution number| <1>"));
	int number = 1;
	if (numberByUser != "")
		number = numberByUser.atoi();
	distributionNumber.set(number);
	
	String heightByUser = getString(T("|Specify height| <0.0>"));
	double height = 0.0;
	if (heightByUser != "")
		height = heightByUser.atof();
	_Pt0 += _ZW * height;
	
	return;
}

Display distributionDisplay(-1);
distributionDisplay.textHeight(0.5 * symbolSize);
distributionDisplay.draw(distributionNumber, _Pt0, _XW, _YW, 0, 0);

Display distributionDisplayElevation(-1);
distributionDisplayElevation.addHideDirection(_ZW);
distributionDisplayElevation.addHideDirection(-_ZW);
distributionDisplayElevation.textHeight(0.15 * symbolSize);
distributionDisplayElevation.draw(distributionNumber, _Pt0 + _ZW * 0.375 * symbolSize, _XW, _ZW, 1, -1, _kDeviceX);
distributionDisplayElevation.draw(distributionNumber, _Pt0 - _ZW * 0.375 * symbolSize, _XW, _ZW, 1, 1, _kDeviceX);

PLine horizontalCircle(_ZW);
horizontalCircle.createCircle(_Pt0, _ZW, 0.5 * symbolSize);
distributionDisplay.draw(horizontalCircle);

PLine arrow(_Pt0, _Pt0 + _ZW * 0.5 * symbolSize);
PLine arrowHead(_ZW);
arrowHead.createCircle(_Pt0 + _ZW * 0.4 * symbolSize, _ZW, 0.15 * symbolSize);
PLine arrowHeadX(_XW);
arrowHeadX.addVertex(_Pt0 + _ZW * 0.4 * symbolSize - _YW * 0.15 * symbolSize);
arrowHeadX.addVertex(_Pt0 + _ZW * 0.5 * symbolSize);
arrowHeadX.addVertex(_Pt0 + _ZW * 0.4 * symbolSize + _YW * 0.15 * symbolSize);
PLine arrowHeadY(_YW);
arrowHeadY.addVertex(_Pt0 + _ZW * 0.4 * symbolSize - _XW * 0.15 * symbolSize);
arrowHeadY.addVertex(_Pt0 + _ZW * 0.5 * symbolSize);
arrowHeadY.addVertex(_Pt0 + _ZW * 0.4 * symbolSize + _XW * 0.15 * symbolSize);

Display arrowDisplay(-1);
arrowDisplay.addHideDirection(_ZW);
arrowDisplay.addHideDirection(-_ZW);
arrowDisplay.addHideDirection(_ZW);

arrowDisplay.draw(arrow);
arrowDisplay.draw(arrowHead);
arrowDisplay.draw(arrowHeadX);
arrowDisplay.draw(arrowHeadY);

CoordSys mirror;
mirror.setToMirroring(Plane(_Pt0, _ZW));

arrow.transformBy(mirror);
arrowHead.transformBy(mirror);
arrowHeadX.transformBy(mirror);
arrowHeadY.transformBy(mirror);

arrowDisplay.draw(arrow);
arrowDisplay.draw(arrowHead);
arrowDisplay.draw(arrowHeadX);
arrowDisplay.draw(arrowHeadY);

#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`&3`6@#`2(``A$!`Q$!_\0`
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
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBH
M;JZALK.>[N'V001M)(V"=JJ,DX'/04#2;=D%S=0V=NT\[[8UQDX))).``!R2
M20`!R20!S6)>ZG>?NQ<S?V1'+GRXD47%[-C&=J*&48ZG`D^4Y.PBH;:PU[4[
MA;W4)O[/QDQPKLE>`D8.S@HIQQN;S"P9L"+<5K<LM,L].\PVT.)),>9*[%Y)
M,9QN=B6;&<#).!P.*RO*>VB_K^NAV\M'#Z2:E+RU7W[?A+MI:[X3Q-;:E'I7
MVB:YO+4R,0S7,YFDD5$:1P\*,MNHV1.`N'#Y&[:235FV\)>'=&N%GUK1;567
M.=0:3-J[$8R\9(6(MR=NW8I*@-G`KH=4MH=5URUTZY3SK1;2XDFC!(VLVV)"
M2.1E'G`YYPQZKD1>"?$/_"2^%[:]D;-TG[FYX_Y:*!D]`.00W'`W8[5E[./M
M+/?I\O\`AST'C*ZPBE"ZC]JS:^*]O.WNO1W2NK(M_P#"+Z&O,.E6MM)VEM8Q
M!(OT=,,/3@\@D=#1]BOM-^>QN9;JW7EK.Y?>Y'_3.5CG/)/[PL#P`4'(/[(;
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
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
#`__9
`


#End