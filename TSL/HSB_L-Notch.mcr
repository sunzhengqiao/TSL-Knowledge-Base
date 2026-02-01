#Version 8
#BeginDescription
Last modified by: Yarnick Boertje (support.nl@hsbcad.com)
12.06.2017  -  version 2.03

This tsl adds the required tooling for fitting a beam in a log wall.








#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 3
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl adds the required tooling for fitting a beam in a log wall.
/// </summary>

/// <insert>
/// Select an element and a set of beams
/// </insert>

/// <remark Lang=en>
/// The notch is exported to the element as elemItem.
/// </remark>

/// <version  value="2.03" date="12.06.2017"></version>

/// <history>
/// KR - 1.00 - 30.06.2005 - Pilot version
/// KR - 1.01 - 05.07.2005 - Added cutback of dovetail
/// AS - 1.02 - 10.07.2009 - split and beamcut applied as static tools
/// AS - 1.03 - 13.07.2009 - splitmargin added
/// AS - 1.04 - 13.07.2009 - add tools static
/// AS - 1.05 - 14.07.2009 - showDialog
/// AS - 1.06 - 15.07.2009 - tools are non-static again; tsl remains active in the drawing; Apply cut when split has been performed in a previous execution
/// AS - 1.07 - 17.08.2009 - Inserted by "JBL-Balklaag Plaatsen", use envelopeBody(TRUE, TRUE) instead of realBody
/// AS - 1.08 - 28.08.2009 - Allow multiple splitheights
/// AS - 1.09 - 01.09.2009 - Subtract cut-out at top and bottom while checking for intersection
/// AS - 1.10 - 17.10.2010 - Rewrite tsl. This tsl is now the master and the slave.
/// AS - 1.11 - 26.03.2012 - Generalize this tsl.
/// AS - 1.12 - 28.03.2012 - Solve issue when the side mill is changed for splitted beams
/// AS - 1.13 - 04.04.2012 - Add gap
/// AS - 1.14 - 10.04.2012 - Dont delete tsl when element is regenerated
/// AS - 1.15 - 13.04.2012 - Clear _Map when recalc is done
/// AS - 2.00 - 23.10.2012 - Combine different solutions into this tsl.
/// AS - 2.01 - 24.10.2012 - Assign to element.
/// AS - 2.02 - 06.03.2017 - Add offset properties for bottom beamcut.
/// YB - 2.03 - 12.06.2017 - Add front and back properties for beamcut.
/// </history>

double dEps = Unit(0.01,"mm");

PropString sSeperator01(0, "", T("|Notch|"));
sSeperator01.setReadOnly(true);
PropDouble dDepthLeft(0,U(7), "     "+T("|Depth left|"));
PropDouble dDepthRight(7,U(7), "     "+T("|Depth right|"));
PropDouble dDepthTop(1,U(7), "     "+T("|Depth top|"));
PropDouble dDepthBottom(2,U(7), "     "+T("|Depth bottom|"));
PropDouble dDepthFront(11, U(0), "     "+T("|Depth front|"));
PropDouble dDepthBack(12, U(0), "     "+T("|Depth back|"));
PropDouble offsetBeamCutBottomLeft(9,U(0), "     "+T("|Offset bottom left|"));
PropDouble offsetBeamCutBottomRight(10,U(0), "     "+T("|Offset bottom right|"));

PropString sSeperator02(1, "", T("|Gaps|"));
sSeperator02.setReadOnly(true);
PropDouble dGapLeft(4,U(1), "     "+T("|Gap left|"));
PropDouble dGapRight(8,U(1), "     "+T("|Gap right|"));
PropDouble dGapTop(5,U(1), "     "+T("|Gap top|"));
PropDouble dGapBottom(6,U(1), "     "+T("|Gap bottom|"));

PropString sSeperator03(2, "", T("|Split|"));
sSeperator03.setReadOnly(true);
PropDouble dSplitMargin(3, U(15), "     "+T("|Split margin|"));

// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_L-Notch");
if( _bOnDbCreated && arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

if( _bOnInsert ){
	if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	
	Element el = getElement(T("|Select an element|"));
	
	PrEntity ssE(T("|Select a set of beams|"), Beam());
	if( ssE.go() ){
		Beam arSelectedBeams[] = ssE.beamSet();
		
		String strScriptName = "HSB_L-Notch"; // name of the script
		Vector3d vecUcsX(1,0,0);
		Vector3d vecUcsY(0,1,0);
		Beam lstBeams[1];
		Element lstElements[] = {el};
		
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		Map mapTsl;
		mapTsl.setInt("MasterToSatellite", TRUE);
		setCatalogFromPropValues("MasterToSatellite");
		
		for( int i=0;i<arSelectedBeams.length();i++ ){
			Beam selectedBm = arSelectedBeams[i];
			
			lstBeams[0] = selectedBm;
			
			TslInst tsl;
			tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
		}
	}	
	
	eraseInstance();
	return;
}

if( _Map.hasInt("MasterToSatellite") ){
	int bMasterToSatellite = _Map.getInt("MasterToSatellite");
	if( bMasterToSatellite ){
		int bPropertiesSet = _ThisInst.setPropValuesFromCatalog("MasterToSatellite");
		_Map.removeAt("MasterToSatellite", TRUE);
	}
}

if (_Element.length()==0 ){
	reportWarning(T("|No element selected!|"));
	eraseInstance();
	return;
}

ElementLog elLog = (ElementLog) _Element[0];
if( !elLog.bIsValid() )
	return;

_ThisInst.assignToElementGroup(elLog, true, 0, 'T');

if( !_Beam0.bIsValid() ){
	reportWarning(T("|No valid beam selected|"));
	eraseInstance();
	return;	
}

// coordsys of the element, determination of side, and repositioning of point
CoordSys csEl= elLog.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

Point3d ptMidLog = ptEl - vzEl * .5 * elLog.dBeamWidth();

Point3d ptBm = _Beam0.ptCen();
Vector3d vxBm = _Beam0.vecX();
Vector3d vzBm = _Beam0.vecD(_ZW); 
Vector3d vyBm = vzBm.crossProduct(vxBm);

vxBm.vis(ptBm, 1);
vzBm.vis(ptBm, 3);
vyBm.vis(ptBm, 1);

Line lnBmX(ptBm, vxBm);
Plane pnElZ(ptMidLog, vzEl);
if( vxBm.isPerpendicularTo(vzEl) ){
	reportWarning(T("|Not possible to find intersection|"));
	return;
}
_Pt0 = lnBmX.intersect(pnElZ,0);

double dBmH = _Beam0.dD(vzBm);
double dBmW = _Beam0.dD(vyBm);
double dBmL = _Beam0.dD(vxBm);

Point3d ptLeft = _Pt0 - vyBm * .5 * dBmW + vxBm * (dDepthFront - dDepthBack) / 2;
ptLeft.vis();
Point3d ptRight = _Pt0 + vyBm * .5 * dBmW + vxBm * (dDepthFront - dDepthBack) / 2;
Point3d ptTop = _Pt0 + vzBm * .5 * dBmH + vxBm * (dDepthFront - dDepthBack) / 2;
Point3d ptBottom = _Pt0 - vzBm * .5 * dBmH + vxBm * (dDepthFront - dDepthBack) / 2;

//FreeProfile bcFront(plBeamcut, ptLeft);
//ptLeft.visualize(1);
//ptRight.visualize(1);
//ptTop.visualize(2);
//ptBottom.visualize(2);




BeamCut bcLeft(ptLeft, vzBm, vxBm, vyBm, dBmH * 2, elLog.dBeamWidth() + (dDepthFront + dDepthBack), dDepthLeft * 2);
BeamCut bcRight(ptRight, vzBm, vxBm, vyBm, dBmH * 2, elLog.dBeamWidth() + (dDepthFront + dDepthBack), dDepthRight * 2);
BeamCut bcTop(ptTop, vyBm, vxBm, vzBm, dBmW * 2, elLog.dBeamWidth() + (dDepthFront + dDepthBack), dDepthTop * 2);

double widthBottomBeamCut = dBmW - offsetBeamCutBottomLeft - offsetBeamCutBottomRight;
Point3d originBottomBeamCut = ptBottom + vyBm * 0.5 * (offsetBeamCutBottomRight - offsetBeamCutBottomLeft);

BeamCut bcBottom(originBottomBeamCut, vyBm, vxBm, vzBm, widthBottomBeamCut, elLog.dBeamWidth() + (dDepthFront + dDepthBack), dDepthBottom * 2);
_Beam0.addTool(bcLeft);
_Beam0.addTool(bcRight);
_Beam0.addTool(bcTop);
_Beam0.addTool(bcBottom);

Point3d ptBcCen = _Pt0  + vyBm * .5 * ((dDepthLeft - dGapLeft) - (dDepthRight - dGapRight)) + vzBm * .5 * ((dDepthBottom - dGapBottom) - (dDepthTop - dGapTop));
BeamCut bcBeam(ptBcCen, vxBm, vyBm, vzBm, U(1000), dBmW - dDepthLeft - dDepthRight + dGapLeft + dGapRight ,dBmH - dDepthBottom - dDepthTop + dGapBottom + dGapTop);
Body bdBcBeam = bcBeam.cuttingBody();
bdBcBeam.vis();

_Map = Map();

Beam arBmLog[] = elLog.beam();
for (int j =0; j<arBmLog.length() ; j=j+1) {
	Beam bmLog = arBmLog[j];
	
	Body bdLog = bmLog.envelopeBody(true, true);
//	bdLog.vis(j);
	if( !bdLog.hasIntersection(_Beam0.envelopeBody(true, true)) )
		continue;
	
	Body bdIntersection = bdLog;
	bdIntersection.intersectWith(bdBcBeam);
//	bdIntersection.vis();
	double dIntersection=bdIntersection.lengthInDirection(bmLog.vecD(_ZW));
	double dLog=bdLog.lengthInDirection(bmLog.vecD(_ZW));

	if( abs(dLog - dIntersection) < dSplitMargin  ){
		int bSplittedAtThisHeight = false;
		for( int k=0;k<_Map.length();k++ ){
			if( _Map.keyAt(k) == "Split" ){
				Map mapSplit = _Map.getMap(k);
				double dSplitHeight = mapSplit.getDouble("Height");
				if( abs(dSplitHeight - bmLog.ptCen().Z()) < U(2) )
					bSplittedAtThisHeight = true;		
			}
		}
		
		if( bSplittedAtThisHeight ){
			//Apply cut or stretch
			Vector3d vCut = vyBm;
			if( vCut.dotProduct(ptBcCen - bmLog.ptCen()) < 0 )
				vCut = -vyBm;
		}
		else{
			//Split beam
			Vector3d vSplit = vyBm;
			if( vSplit.dotProduct(bmLog.vecX()) < 0 )
				vSplit = -vyBm;
		
			Beam bmSplitted = bmLog.dbSplit(ptBcCen, ptBcCen);
			arBmLog.append(bmSplitted);
			
			Map mapThisSplit;
			mapThisSplit.setDouble("Height", bmLog.ptCen().Z());
			_Map.appendMap("Split", mapThisSplit);
		}
	}
	
	arBmLog[j].addToolStatic(bcBeam);
}

ElemItem elItemNotch(0, "NOTCH", _Pt0, _X0, Map());
elItemNotch.setShow(_kNo);
elLog.addTool(elItemNotch);














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
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#V.BL_3]<T
M[4U/V:Y&\'#12`I(I[`JV"/7ITK0ZU^63IS@[25F=U[A0>:,T5&P%#4=&L-7
M2-+^U27RF#Q.25>)@0<HXPRG('((Z576#7M+::33]1%[%M'EVE^/NX!P!(HS
MZ?>!/J:UZ*[<-F.(P[]R6G8EP3W*D'BZWBN(K;5K6?3IW4G?(-T/!''F#CN#
MSCO70V\\5S`DL$J2Q.,JZ,&!'L16.Z!U*L`0>H/0BLMO#UK'>O>V$L^GW;``
MRVK[0W^\A!1NX^93BOH<-Q'%V5:-O-&,J/8[#(]:45R,&K>(M*2WAO[2+6(@
M,2W=IB&48'4PL2#R.JOWX3BM?2?$NDZMO2UNP)HWV/!*ICD1LD8*,`1T/:O?
MH8JC75Z<DS-Q:-BBFEU'>ER*Z21:***`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HI,TN:`"BDSBC<*`%H
MI-P]:JWNJ6&FQ/+>WD%O&B[F:60+@>O-`%HGFDR,9S7(7OQ'T",NEB;G5)49
M5VV4!=26Q_RT.$X!R<L,8]>*YS4?B9J0D`@MM-TN`.5$FH3>?(_'_/.-@J\Y
M_C/TJ'4BMV4H2?0]2R/6J.I:YI6D(SZCJ-K:A4,A$LH4E1U('4].U>'7_C*[
MN/*%[KFK71V,NR';8H2<<X&QF'H,MC)]><M)9G51IVEQ6[E=DCM&<C!X^>0`
M_P#D-NO7N,W571&BHOJ>@O;PR2I*\2&1`0CE?F7/7!ZC\*DAO=5L(%2UNA<?
M,21>$MQQ@`C!&,?J:**^>G",U:2N";1I6WBZSW*FI02Z<QZR38,.?:3L/=@!
M6_%-%/$DL,BR1.H='0[E93T((ZBN.P"#D9S55;(6\S2V%S<6,CDLQMGPC$]6
M,9!1F/J5S[\"N"KEE*6L'RLM3:.^!S17,0^(+ZWDD^U6\<ULBY5X2?-;D9RN
M,'`R>#SC@<XK4T_7]-U+"P7`6;.##*-D@/IM/->75P5:GJU=&BFF:=%&:*Y!
MB$'/%5KW3K34$5;JVBFV9V,R_,F>ZGJIXZBK5%5"I*#O!V"R>YE16>L:=([:
M?JIFB(`6VOEWJF/1AAOP.:FC\8+9"8Z[I\VG1QM@7"_OX6&`<[E&5ZG[P`&W
MK5^D(!Z\BO:PV>XBEI/WD9RI)[&M;W4%W;QW%M-'/!(,I)$X96'J".#4N[G%
M<?)X=LA?2ZA9--IU_(`'N+-]A?KRZ8*.>3]]3UXP<&E@U/Q%I0MXKR"'5X0,
M275OB&7@=3&25/X'OPHKZ+#9WAJVC?*_,Q=-H[&BL6R\4Z3>W268N#!>."1;
M7*F*3&0.A^H_,5L;Q7K1DI*\69CJ*3-+FJ`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BC-)F@!:**3-`"T4W<,TR6>*&-I)76.-1EF<X`'N:`):3-<
MWJ'CSP]I\X@^V_:;C<%,5HAF89&<G;VQ_,5SUY\2KC,9M-%$,;,W[S4+E800
M.F`-S<^A`J'.*W92A)['HFX5!=WMK86KW-Y<16\"8WRS.$5><<D\#DBO%K_Q
M_K,\,;3:^L1*,IBTNV5,MQU>7>1CG!`7J37,SW?]IN'.G2:A(4"+-J4LEXR@
M<\;SM'?HP_I4.K?9&BHOJ>UW?Q$\.Q,Z6MQ-J,BN$*V41D7.,_?X3@'^]6!J
M/Q*O8XU>'3+:RA,Q43:A<CE<''R+_$<#C<>,UYXXUN[^:6^^S1CDQI\H_P#(
M95E_[^'^@SMVCVIN`^HSW,R@-(L,F)&Y`RWE@,_WOXBQZ^IJ7.;+5**.DU3Q
MO?W6Y;[6KP>9&R^3:QBU7DGCY_G;KC(!/XUC17)E;?%IAD?RQ&)[HF5P5S@E
MI,'&3_=QDG\$MY)@DB:/H!`.'5V58HY!Z@XZCT(J\-*URZ9O,OH;*/?O3R$W
MN%_N-NR,XQR/3O64I+[3-%#LBK-%JEU&\FH:BL<0!8@$@+CUP0..YJB9-%M9
M2OVF2YN&C\Q8X2<R#/5=N-W?C)Z5KOH6A64@FU"ZDN9XLA7NKC+!3G*D+C*G
M)X(/!QTXJQ%JFG6<9BTO3W,8.0((1'&?4@G`J?:+[*N5R]S,@:^<2?V5H@A6
M1%9)9P(U8]U9?O`\D=.H]#FK-OHFMW"1M?ZHD#JVX);(,'_9.>H_QJQ)J6JS
M@B-+>T!Z,Q,K?0J,`'IW/2JS6LDRC[9>W5P<8(,GEHWL53`(]B#P<55JC\@L
MCO****\8Y@HHHH`*AN+2WN\>?"DA'0D<CZ'M4U%%V!'#/JMAQ9WYFC)R8;S,
M@_!LAAV&,XZ\5KV7BD/.EOJ%A/:SR,%0PAIXV)_VE7*_\"4#WK,H[8[>E85<
M-1J_$M?(:DT=A#<0W$22P2I+&ZAE=#D$'D$'WJ3K7!BS2(NUF[64LC^8\MJ%
M1G;GEN"&ZGJ#UJ];Z_JUE@7D$=]`.#)#\DOUVG@X'H>:\NKE<H_PW<T4^YUU
M%9-AXDTW4)5@28Q7+=()U*/]!G@GZ$UJYKSJE&=-VFK%IIBTF*6BLP*E_I=C
MJ<*Q7MK%.BD%0Z_=(.<@]1R!TJA'I.HZ7'&FAZL\,2ODV]XOVB,CG@9(9>2,
M88#BMJBNO#X_$4'[DB7%,H)XP;3UF;Q#I<VG11M@74)-S`PP.254,G4Y+*`,
M=:Z*VO;:]MTGM)XIX7&Y7B<,K#U!%98&,^]94WAVQ:]EO[7S+&_D&&N;1MC-
MUY8?=<\GE@>M?0X;B-;5X_-&3H]CL%.:=7&6][XFT>)VG,&M1+&`H51!.Q`Y
M]5.?PK6LO%FEWEU%922-9W\@RMK=KY;GD#`SPQY'`)ZU]!0QM&NOW<KF4HM;
MF[13=U*#D5U$BT444`%%%%`!1129H`6BD)P*:7QVH`?2$XKG[_QSX:TZ6.*?
M6+4RR;@D<+^:QV]>$SC\:YVZ^*"30[]+T.]F1HF?SKK;`BD=`V><5+G%;L:B
MWLCT'=[4UG51EB`.Y/:O%]2^(^M7"L7U/3M/A>(`K9QF=ED)[2'Y`>W/]:Y[
M4-<.INPD_M#5S*49A<SL8QMP<-&N$(R!ZY/-9NLNBN:*DWN>S7_Q!\*Z?.MO
M+K5O+<-(8O(M<W$@<=05C#$=.XK"F^)DUQ&KZ;X>NE0JY:34I5M@N"`,*-[<
M\GD+P/>O,83K#0F*WA@TZ(G<(X`J#GZ`^QZ55N;*QC5GU74$D1"JLKG.TMV^
M8L5SU^7;T]N)=23VT+5%=3K;_P"(NJ7%NY?Q!;0Q^5L;^RK7<JL>.97W!3R,
M$E?7BN<NM8.JRLZ6M[?LRA/,O)&G!`YXPWED<_\`/3J#QQ4<4EMY^^TTNYNI
MXY`AF,9+!3_$'?DC&>AJW'9^(KK895L[/!(<9,A8'I@]B*SE)?:9HH=D0XUB
M52JR1649._"$+@X_NI@C\7;IWJC+::;9Q2/J>I&:1$'F_-C.>Y5>3D^U:TGA
MVTC2.36M5FN$&8_WDODQN"#PP!`)Y/Y4^UFT#2]JZ;8@LN5W0098#_>/4?B:
MCG7V5<OE9F02[F/]EZ!//MD&)'41HZ_WTD;AAP,#(SFKZ:?XAN'5I+BRM%5]
MP55,F]?1LD;3[@GK5F35]0EYAM(8O4S2;B?<8%5Y%O;GBZOY63^Y"/*!';..
M?R(JE[1^06B-D\.Z3:1I-JVHS3B-B-]W<;5P>Q`P*FM[[1K!%CTO3GEVDX^S
MV^!@]2KMA2.>Q.<U#%8VL,GFI"OF_P#/5AN<_5CDFK%/V-_B=QW[(5M5U.8Y
MCMK:W'7,C&4GZ@;<'UY-5W@FG_X^KVXF!X*[MBD9[A<`U/15QIQCL@NR&*TM
MX2#'"@(Z'&3^?6IOYT458!1110!V=%%%?/G*%%%%`!1110`4444`%%%%`$5Q
M;0741BN(DEC/\+C(J6WGO+%@;.[985C"I:.JF'(7:.VX#@<*P&><9)R44I14
ME:6J`OP>+EB&W5K*2T.?];"3/#CN2P`*@=RR@>YK?MKNWO(A+;31S(0""C`C
M!Y'3VKD:JG3X5E,ULSVDQ))DMFV$YZYQU_&N"KEM&?P:/\"U-H[T'-+7(VVL
MZK9QHK^7J&6(9G(A*CY<8P"#C#9SZBMBS\1Z;>7?V,3&*Y)(6*9"A?']TGAN
M!GY2<"O+JX"M3U2NO(M23-:BDYS2UQ/S*$Q5>]T^SU*'R;VUAN(\@[94##/7
MO]!5FBKA4E!WB[`]3(M]'N-)C5=$U.>TC3E;:<?:(/\`OECO`P>`CJ,@?C/'
MXMO;2;RM8T&XMD+D"YM)/M,(7`.3@!U[CE,<=:T*0#%>QA<\Q-'23YEYF<J2
M9>T_5[#58/.T^[@NHP<%HG#`'./Z'\JO#D5Q]]X?L+PF1$>UN=XD^T6K>5)N
MSD$D?>Y'?/?UI]O<>(=,B11<0ZNH4*1/B"3/KN4$$>N17T&%SS#5E:7NLQ=-
MHZZBL"T\7Z7<7T6GW$CV.H2CY+6[3RV;D#"M]USR#A23SSWJ76_$^FZ!&?MD
MS-/L+I:P(9)G'/(0<XR,9.!GN*]E5(R7,GH19[&N6KD=>^(-EI6HRZ1I]K+J
MFL1IO:U@8*L8(./,D/"]!QR>1Q7*:YXL\9:Q<K8Z78II%A,<M>O('GC4-Z#@
M$C&,9^M94DFC^"K`C>OVBZE+9GF`>=SR2SGT[GMGU-<M;%QC[M/63-Z=!O66
MB+FJ_$7Q1)',DAL/#X<!85\A[NXWCEMI.U&X]%;@GZURU]XC;4[B;[1=:OK&
MYU;RKB8K`I7CF*-<C\4Y//N:LVMV6LW8N'MYM3EW^6JP6[21PY[9.!^/>K,*
M>(+E(UBTZWL(_N,)Y-[#`P"H7C\,]J.:5KS9HH13]T@MQJD89;'3[33(V8OM
MC14;<>/O8<,/JB'@=.145U`L>)=8US.UAU.!GKG#EMI/^QMQ[5J_\([<7*`:
MCJ<C*8PDD<`\M3@YW`]0<C^E10)X7M69X4BO9G`!D1#<,V.@+`$`_7%3[2/1
M7+Y2E;RZ:9%>RLI[R3S#&\J1M(R_[3,W4=`#[<=*O);:]=(J+:VU@GS*_F2>
M8RY^ZR!05XX)!Z]..M6WUFZ<;;:P*#&-UPX&T_[JYR/H:KR3:C<C$MZL2G@I
M;J!^3')I_O'LK#TV%'A[]V5U75Y;@.OENH"Q1R#.>G)!]U(SC\UBN/#UG*SV
MD*3S,,.\,1F<_P"^V"?Q)Y_"H#8P.VZ=3<.>K3'?G\^*L@`#`JO9-_$PN/;6
M;R3Y;;3DB7INN)1E<]PJ9!`^J_A4#OJ-P#Y^HNH(P4MD$2D?4[FS]&'2I/K1
M5*E!=`NRM'86L<AD$*M(?O._S,WU)Y-60,8`X`["BBKL`4=L444P"BBB@`HH
MHH`****`"BBB@#LE=7171@RL,JP.00>AI:VKSX<Z8#YNC7$^CRA-N+?!B;`.
M,QMD<9[8/O7/3:5XHT00KJ%E'J5J"RR7MCN:0`?=)@"ELL2!A-V.2<"O-J8&
M<=8ZG&I7)Z*K6E_;7T6^"7=R5*LI1E8'!!4\@CT/-6:XG%QW104444@"BBB@
M`HHHH`****`"BBB@`J.>WANH6AN(DFB;[R2*&!_`U)10FT!!;K?:;@:9?211
M+TM)1YD(]AGYE'8!3M'85K6OBB5%<ZG9_9T1=S30R>8G)`X&`W`.2<=C5"BL
M:V'I5OCCJ-2:.LM+ZVOX!-:S+*C#((_P/-6!7#-:Q/<K<[")T4JDBDAER".#
M^-6+?6-:L>&>+4HC_P`]B(74^S*N"..A4'G[U>95RIO6FS13[G8T5AVGBO2K
MB1(9I7LKAR%$-XAC+,3C"M]UCT^ZS=16VI#*"""#R"#7FU:%2D[35BDTQ:#R
M1FBBLAF5XBTF77-$N--AO!:&8;6E,*RC;W&UN#D5Q5MX?_X0V"X6+1!]CC`/
MVNU_>O(`,Y<?>'?U`[5Z517?AL?4HQ]F]8]@6CYD<+#?6LZLT=Q&VT;FYP5'
MJ0>0/K7):U?Z#J&NQB9+:X>R7DB,2.[,,JH/.5`+'_>QZ&O3=8\*Z+KLBO?6
M4<D@(.]258@=F(Y(/H:@N_!>@7<"QKI\=N4C$:26X\MT49P`1Z9/YUZ>'S+#
M0:DTS2564E:QY\^MROE;33WP>CS$1KGW'7]*KO<ZI<9WW<=LI_AMX]S#_@3<
M'_OG_&NBO_`FKV13^SKJ*_@"G<ER?+F.!_"P&UB>>"%]S7.32O:RB+4+>>PG
M9BJQW4>PN0<?*>CCW4D=.:^@PU;#5E>#N1SOJR%K"&;_`(^FDNCG)%Q(77=_
M>"'Y5/T`JR`!TXH&#R,4M=JTV&&!Z49/J?SHHI@%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110!]!8H.*6BMCSS%U3PQHFLRK+?Z;!+,I!$X&R48Z
M?.N&QR>,UR=WX&U;3HMVB:G]KB4C;:W_`%VA0,"4<]1GD=Z]&HJ)TXS5I($V
MCQZ;49]-N)8-;T^?3=C*%F<;X9`3@$2*,#GCG%:(_7O7ILL:2)L=`RGJI&0:
MY*]^'NDMYDFD/+HL[K@FR5/+;&<;HV4KQGJ,$],UPU<!%ZPT+4CGZ*2]T7Q/
MI#.9+*/5[8*6$U@/+E&`O#1.QR?O8VL>@X%4;76;"\N!;13@7.UF,$@*2``X
M.5(SUKAGAJD-T5=%^B@]:*PU&%%%%`!1110`4444`%%%%`!1110`UXTEC:.1
M5='&UE89!!Z@CO67J6K)X4TM[FWO'MLL-D7,H=N@14)XZ\`8`Q2:SK\&E*88
MD:[U!ES#90G,DG7GV`QR?_K57T+0[I)#JFN3"YU.7)"=8K53_!&.WN>_OU.C
MA%0YJFW;N:4Z<IO0MZ3J7BK4[T:GJ=Q]@@"+Y6GP8()'):0D9YY&!6Q;>)=6
ML5C34;$7H+$&>SX('."4)^G0TVJE_J,&G0EY3ECPL:X+.?0#_(KBE3IUGR\B
MMY':Z,8QW.KTW7=-U=Y$L;M)9(C^\B.5=>!U4X/<<XQS6E7BWAIKW3?%]UJT
MOV6[N;I2($NI'!A!))C1\G`&>/D.0"/E[^DVOBNRDECAO8Y;&9B%Q,O[LMV`
M<?*?7&0?:N#'Y7*A+]TKHY.;6S.@HIL<B2H'C=70]&4Y!IU>0TUN4@J"[L[6
M^@,-W;17$1.2DJ!U)]<'BIZ*(R<7>+#<X_4/A]83,DFFW,VGN#EE!\R-^O&&
M/'4=#VZ5RE_H6N:.CRWEC]H@5L"6SR_'')7[P_6O6Z0UZV&SK$T=)/F0K=CQ
M6*>*8LJ2`NG#K_$I]".H/7@U)7I^I>&-&U:0S7EA$TY`7STS'*!DG&]2&`Y/
M?O7*:GX#U"V2272;M+M5!*6UU\CGC./,'!Z8`*CKRWK]!AL[P]6RD^5^8T['
M-T4VZ\_3KD6NHVL]I,1D>8N5/T8?*>OK2@A@"I!!Z$'->O"<9J\7<::%HHHJ
MAA1110`4444`%%%%`!1110`4444`%%%%`'T'1116QYX4444`%%%%`"5G:IH>
MFZRJK?V44Y7[K$88>V1SCVK2HI6`\^F\`WFF0HNB:@TD$1.+.\^;<#V$OW@<
M\Y.?3%8%_?WFAR(-<TBZL8GD*?;`5DMEYP"S@_*"6`!8+UKV"F,N37/4PM.>
MZ*4FCRRUN[:^A\VTN(KB+.W?$X<9';(J:N@UCX=:+J)GFLUFTJ\E;>9["0QA
MG&<%T'R-R><C)]:P;SP_XFTB2=_*CUBV`!C-JHBE7`YRK,022>,'M7#4P$H_
M`[E*0VBLV/7+(W4UK<E[*XA(#Q7B^4QSZ`]1GN/2M+K7%*$HZ2104445(!11
M1TH`.]<_J_B*2'4DT728!=ZK(FYE+82W7'#2$?AQ[_3-2_UVZUF\72O#<@)S
M_I%_MW)``>0,\%O:MK1M"L]#@E2VWR2SN9)YYCNDE;KECW^E:/EI*\]^B-J5
M%S?D5?#WAX:4)+N[D^TZI<\W%PW?_97T4>G>MT\45B:IK:QEK2QD5KCH\@^8
M1?\`V7M^=8)5,1,[_=IQT+.J:Q'IV(EC:>Y<96)?X1V9B>@R/<G!P#@XYHJ\
MTS7%PPDN&ZN1T'H/04B(5+.[M)(YW/)(06<^I_#CV'2GU[.'PT:*\SFG)R&R
M+OP1]Y&#H<XPPZ?RKI]-O4U;31*\8&[,<L9&0&!PPYZCM7-4^QNQI>J"=CBV
MN-L4WHK9`1_IR03Z8["GB:3J1NMT8SC?4ZB&V^PB1M.<VDKXYCY48[;3\M::
M>([VT95N;(W<(4;IX6`DSCGY#@'G)X(X/0XYJ45X=2A3J_&KF2;6QTFFZU8:
MJ'%I<AY$Y>)E9)$!Z$HP#`'UQS6A7!W5C:7@3[1!'(T9S&Q'S(?56ZJ>!R,&
MI8+K6+#`MM1^TQ#I#>KNX'0!Q@CZL&/%>=5RI/6D_DRU/N=O17.6WBZV#;-2
MMIK%CPK-\Z-[!ESSUX/I70HZ2+N1E9>1E3D<<&O+K8>I1=IHM-,=1116)1'-
M#'/$T4T:21N,,CKN!^HKD[_X>Z9+L.FR2Z:R'[L/S(W!X*G([_H*["BNBABZ
MU!WIRL*QY1>>&?$.F[VELDO(021)9G)"CN4//X*6)]*R8+N"Y,BQ29>-BDD;
M`JZ$'!#*>0<CO7MM9FK>']*UQ8QJ5E'.T9S')DJ\?^ZZD,/P->]AN(&M*\?F
M@U1Y7172ZCX`OK99IM)OA<@?-';7>`1QT$@]_4=^37-7D=UIMQY&HVDUJP&0
M[C,9^CCBO>P^/P]?X)`I!12*RN@=6!4C((Z$4M=>A5[A1113`****`"BCI4$
M][;6V?.GC0@9VEN?RZT6#0GH_P#U5E2:[;X(@BFG]PNU3^)XJM_:VIW;[;2U
M'(W#:K2G;^@_(U7(^I/.CZAHHHK0X0HHHH`****`"BBB@`HHHH`2BEHH`SM2
MT33=8MW@U&PM[J)P`5FC#9`.1U]ZY*Z^'=Q9@-H&KR0*L>W[+?[KB(X!QALA
MU[=R..E=]1VJ90C+=`>12/JND(B^(=-:T^\&O8F#VI((&0P.4W9&`X7T&34]
MO=V]W&LEO/'*C#(9&!!%>J%:XWQ+X6\(Q)_;6H>3I,D.2;V!A`QSDD'CYB>3
MC!)KBJ8&,M8Z%*3,&1TBC:21@J*,L6.,#^E<C+>:AXU5[;36-GHHDV37I8B2
MY7N(QC@9X+'MT[@U]-L=0\6"1[Z]NCX?'RVR.@BENU&/GDQT!QGWS7;001V\
M"00QK''&NU448``KS:DHT-%K+\CMHT'+66Q%86%MIME%9V<*Q01C"JH_G[U8
M)'<\8]>U,GN(K6!YIW"1(,LQ[5RVHZI+JK;8))(;('H,JTWKGN%]NIZ^U84:
M-3$2O^)URFJ:L6-1UR6Y9[:PPD(^5[H-R?4(,?ANSZX]1FQQI$H2-0BCL*4`
M*H50``.`.U+7NT:,:4;11S-MN["BBBM1!39(TEB:.1=R."K`]P1R*=10!M>'
M]1:X@>TN)"UU`>"WWI$[-_0_3GK6S7$--)93I?0@EX<[E`SO0]1]<=/>NTAE
M2>%)HV#(ZAE8'((/O7DXJER2NMCGDK,?1117*2%519B*X:YLYI;.X8Y:2$_>
M_P!Y3E6_$&K5%'D!-!XAU2SVK>VL=]"O!GMVV2X[9C/RL>Y(8=>%XYVM/\1:
M5J4GDV]X@GQGR)5,4@&>I1@&QR.U<_45Q;0W<82>-74'(SU4]BI['W%<=;`T
M*FMK/R*4FCN3QUHKB8KC4K%8UL+L")%V^3<`N#R?XL[AU]^U:-OXMB0XU2TE
MLB>%=098V]LJ,@]>HQ@=:\RMEM6'PZEJ:.EHJ*&Y@N(5F@E26%AN62,AE(]B
M*EZ5Y\HN+LU8L*9)$DJE)$5U/56&0:?10I.+N@.6U/P'I-]++<6WFV%W(O,M
MNV%)Y.2ARIZGM7*W_A/Q!I>W$":G;A27GM<)(N.N8F//?&TL3CIS7J=!Y!KU
M,-G.)H:7YEYBL>)174,Q9%8JZ,4:-U*LK`X(*G!!XZ4LUS!;1F2>9(T'5G8`
M#M7KVHZ-IVK)LO[.&?`(5G7YESZ-U'3L:X+4_A+")XY](OG1@PWI>9E)7G(5
M^J]1^M?087/,/5=JONL')HX^37K-<B)9KCGDQ1\8]0S84_G59M8U&=BMO9HK
M`;]H#3OMSCE5`Q]<FMB]L+;PTGF:MH%V`"8C,<3QL,CECG`&2.2!4B:K>R01
MBTM;6"':`N7W`CMMVX&*]>%>$]::OY@KO=F*ND>(;]2)E=(_[L\RQ!@>P$8;
M/N&Q_.K2>%+6R4R7VJ1QJG),2+&,>Y8D_B"*MN+R?_CXU"5N,,L8$:L/0]_R
M--CL+6-UD$(:1>DC_.P_$Y-5S59=;>@U&(02Z):.ALK">\E0$"18R<KSR'D(
M##GL3U]*L'4M390(;:SM4'0,6E)'I@;=OYM114^S3^+4K;8^@Z***ZCSPHHH
MH`****`"BBB@`HHHH`****`"DS1NQVKD_&/CNP\+6_D1;;W69L+:Z=$P,CL>
MA8#D+[^U)NPTK[%_Q5XLT[PGHS7]\Q9G.R"!.7G?LJCO_2O,I;?5/%>LP:UX
MF5(XH`&LM+C?<D![LY(PS_AQ2V.D7EY>Q:UXBNFOM6`8ID_NK<,<[8U]O7OS
MZ5N`=J\7%X^_N4OO/0H8;[4@`````&!C`XQ5>\O(+&U:>=P$7VR2>P`[G/2H
M=1U:VTU5$I+329$<2C)8C^0]S@5R\K2W5R;J[(:?'`&=L8]`/Z]>37-A\+*J
M[RV.F=115D27=Y<ZG*KW*"*)#F.`-N`]VXY;^7J>M,HHKVX04%RI',W?4***
M*L04444`%%%%`!5WPW<)93/I;!4A=C+:@```G)=!]""P]F('"U2J.96*K(A(
MEB821D#HPZ?6LZM/GA8B:NCMZ*IZ5J":IIL-THVLPPZD8*MW!';Z'G%7*\64
M>5V9@%%%%2`4444K`%':BBF!3_LV".=I[4R6=P3N,MJYC+'L6`X<#T8$>W6M
M.#7-4LX"+E%U$`A5\E%ADVX/+9;:QSC.-@ZX':H**BI3A45IJXTVCH;7Q!IM
MU<FU6Y1+H=87^5NH'X]1TZUI9%<1/;Q74?ES1JZYR,CI[CT/N*9;_P!H:<`-
M.OV6)>1!./,3\S\P'T->;5RN+UIOY,OVAW6:6N;L_%+@E=1T^2V`5F,T4@EB
M``SR>&SUXVGMS6Y9W]IJ,`GLKJ&YA)($D$@=21U&1Q7F5L+5I?$M"U),L44@
M-+7.,1E###`,/0]ZYK4_`FCW\D]Q`CV%[*/FN+4[=QY.60_(Q.3DD9]Q7345
MO1Q-6B[TY6%9'E^H>#]=TN!I8A%JD:#/^CCRY3QDGRSP>F.&R<]*Q#.J7!MY
M@T-P!DQ2J4<?@:]KQ5._TJPU./R[ZTAG7&WYUR0/8]1^%>YAL_G'2LKH>IY)
M175WWPZ\E8SHVHO"J]8;H&56&#T.0P[=\<=*YF\L-6TO>=2TN:&-<_OXOWT6
M!U8LHRH]2P`KW\-F.&Q'P2U[/0.8]^HHHKU#A"BBB@`HHHH`****`"BBB@`I
MN_G%([[`2>`!DDUYAXC\?76LZFNA^#+E"%PU[JRJ'CA4_P`$?9G/KT'USB9S
M4%S2V*C%R=D:GBWQ^VG7TV@Z!;+?ZX8BQRP$5L>QD/\`(?3UKE]#T/\`LP3W
M=Y.UYJMV=]W>2<LY]!Z*.@%3:/HEKHELT5OODDD8O-/*VZ25C_$Q[UI?0?C7
M@8O&RJODC\)Z5##J&LMP_G63J^K_`&,?9K<*]VXZ-]V,>K?X=ZK:IKC%WM-/
MR6!VO<\%$]0O/+?A@<\DC!QH88X%*QKC)R2>23ZD^M7A<"Y>]/8NI5Z(4"1I
M9)YI#+/)R[GC([`#L!V';ZY)=1VHKUTDE9&`4444P"BBB@`HHHH`**@GO;6U
M7,]Q%&"<99P.:H/KT1?9;6\T[$<'&Q<_CR1[@'CUIJ+?03DC6H[X-8*7NMZB
M<6=HRHP^5HHRWXB1]J?H:G'AC5[Q2]]>1Q1D;B)7:3Z`HNU1]02./QI2<8_$
M["4GT1J:=K%KI>NQ0R3IB^=864')63L3]>!^7O7;>GTKS6ZT'P_'8R65QJ!E
MNL;HRG+HV."J)R0"<XY^M=3X.U>?4]$ACODDCU"!`LPD4@L.0&YZYV\^_;&*
M\[%TU+]Y`RE%IW9T-%%%<!`4444`%%%%`!1110`4444`'\Z@GM5FD259IX9D
M&%EAE9".<C..&`/.&!'7CFIZ*`'P:UK-B<3+'J40X&`(I!V&3]UO<\?2M>T\
M5:5<G9)<?99L<Q7(\L@^F3P?P-8M,DBCF7;(BN.N&&:Y*N!HU=6K/R*4FCMB
M<4M<+;+<Z9&PTVY:+D;8YBTL2CT";A@<_P`)!K6B\5?9V2+4+.;:%7==VZ!H
MB<<G8"77YL]F&,$MUQYE7+:D=8:EJ:9TE%5;+4;/4H?.LKF&XCSC=$X8?I5J
MO/E"47::L6F@_&BBBI3:U`W****_5CA"BBB@`HHHH`***3O0`5%<W,5I;RW$
M\J10Q*7DD<X55`R23V%5=6U>RT2QEOM0NH[>WC4LS.V.GIZFO([V_P!4^(TD
MDFHM/9>&2RM;:>F$>YVG(>4XSM/]T<<`]0"<JM:%*/-(NG3<W9%C7?$^H?$&
M)K'21+8>'C(R3W9;;)=J.R#JJGG)J_9V=O86<5I:1+%;Q+M1%Z`5+&B11K'&
MJI&H"JJC``'0`>E,N;F*TMWGG<+&HR2:^>Q&*GB)67R1ZM*C&DA\DB11M)(Z
MHB`LS,<``<DD^E<SJ6L2WS-#92^7:<AIE^]+Z[3V'OW[5!?:A-JQ7?&T-JIR
ML+8S(W9GQV'4#\>H&(<8&!7=A,%R^_/<B=6^B$151`B*%4#``I:**]+H9!14
M<L\4'^ME1."?F8`\=:H2Z]9(#Y9>;C_EFI(SZ$]!^-"B]A<R-.BL'^VKZ[)6
MPT]C@<DJ9"OOA>"/QJ>/1/$-XV;F8PJ""5,XC`S_`'?+YZ=F/?OUH?+'XG87
M-?9&E/=6]J`;B>*(,<`R.%S],UG3^(+.)"R+-(`,EMA0#ZEL5*GA[1=-;=>:
M@N[)5T3";LYQNQE\CU#=:N0W.E6OEC3]*FF:,,%D9.0I/9Y#DC\:CVL?LIL+
M2]#&_M'5[TXLK([64,&1"_'J&.%.?:K">'M;OE8W=P(LX*J9.#[87&/S-:SZ
MAJLN`BVELH[$-*3_`.@XQ^/7\ZLUF;Q"E[=W-TO]V238IYR,J@4-SZ@T^>H]
MDD'*NI#'HN@Z9)B[OA)<HWSHF-[`@<%5RQ]<^]6X;FQM2G]G:.SM&3LED`7@
M]2&.6[]"!U-+%;PVZ!(8DC5>@10,5)UZU+@Y?$RDK;"/>ZK,.)+>V&<KM3>?
MH<\?E5=K,3$?:9Y[D#HLC_*!]!@'/H<U9HIQA%=`U&111P*$B1(UST0`"H9)
M[BPN[;4;;;MB.VX4]6B/W@#['G\*LT'GKS5.*:LQ.*:.LM+ZUOXO-L[B*XCS
MC=$P8=N#CH<']:G_`"K@9=.@>8SQ&6VN2I0SV\AC?''7'WN@X.1Q5R#6M>LI
MXA.8-1M1D.0@CF]CUVG'?@5YU3!23O!F+@T=E16/IGB2PU$0QLQM;N3(^RSD
M!P1]/4#/XUL5R3A*+LT0%%%%0`4444`%%%%`!1110`4444`%%%%`%:6PADG^
MT+OBN!C$T+%&R.A..N.V<BKMGJVL6DBK+/#>6X!XD7;(`!P`1P2>,DU'1D^I
MJ9TXU%::N-.QMV_B;3Y8T:Z8V#.Q15NV5-Q&.AR1_$,<Y.#QQ6P#7%.B2+M=
M0PQC##-0007.G?-I5Y):X&!"Y,L&/01D_*!U^0KSUR.*\ZKE<):P=BE-GK-%
M%%?<G,%%%%`!112&@`K!\4^+=+\(V,=SJ+R,\SB."W@7?+,Q[(N>?\^H%3>)
M/$VE^%]+DOM3NEB55)2//SRGCA5ZDY(_.O`/[9U?Q9XAOM4M[61M6E?RH&GR
M8],A(Z<C[YYZ>M9U)J$;LN$')FQK.K_;-;@UOQM(EOND*:?I882);IG[[XX8
M],MT'Z#J[6[M;V!9;.XAGA/W6A<,#CCC%<K>W%IX>0VMJ#JOB"\7RCYC;V?.
M6)8=$0;LX&!6;!_9W@Z:YOF:*[UVY`0V]I&$CA'=<+P`".<\\#UKR*L'B/>Z
M]#T(-4M$=Q?ZE;:;"'N9`&;B.,?>D;T4=S7+3SW&H3^?=.<YRD*G*)Z8]6P>
MO\NE81U^ZO[AIX[8S3R,(]^257_9P,[?QJ5++Q)?`$@6JER""`I7IZYR.?0=
M*Z</@X45S3:N*59RV-622.)&DD=41`69F(``'<UGRZ[8(/W<K7![>0I92?3=
M]T'ZFD7PM;P$2:SJ:`G)0%_NL"#E2^<'Z"K"CP^N#%827S[-N7B+#([D-@`G
MU`KI]I#IJ9V9F+K\]VQ6PLVE&<%E!E*?[RQY`SSCYO4U8&E>([W/F-]F7=R"
MP7CU7;N)'L2,UKMJFHR*%@MH;=,8_>-N*^X`XQ[5`Z7<^?M-_,P/WDBQ$I_+
MD?@:.>?16#E74I1^&-.T\F76-5A"NV%!*Q+T[%B3GJ>#5V&71[4AK/3;FY<K
MY;2>21D<8R9-H;/MG]:2"RMK9S)#`B2'AI-OSMSSENI.?6IZ.64OBD-)+9`V
MHZDZ!(HK6U0#!PQDP/4<*!CW!J"2&XN!_I5[<RC&TA3L4CT(4`'ZU/1@4*G!
M%79#%:V\!S%"BG&,@<_G4U%%6(****`"BBB@`HHHH`*RM<U&2RM%CM3_`*9.
MP2(``GW.*OW5S'9VTEQ,<(@R??VK&T6"6^O7UF\4AB-MLAZ*OK_GW]JVI12]
M^6R.>M)O]W'=EC1M1FF:6ROALO8.H/\`&/48X_\`UBM>J&IZ:+U5EA?RKN+F
M*4=CZ'VI]A>M<H8YT\JZCXEC]#ZCV-*:4O?B.FY0?)/Y,LRPQSKME4,.V144
M,=[8.K:=?2Q`'_42DR1MD@XP>1WY![U8HK!Q4MS9Q3+*>+Y[2)CJNF384X,]
MF/,3!)Y*D[EP.O!KH;/4++4(3-9W<-Q&#M+1.&`/7&1T."#CWKE:KR6<;N\B
M/-!*X&Z2WD:-FQTS@_-CMG-<M3"0EK'1F;I]CN^G7K17'IK.MVK<_9KV(`?*
M5,;CGGD9!./I6I9^*]-N76*X9[&9E#;+H;`>,D!NAQBN.>&J1Z7,VFC<HID<
MJ31K)$ZO&PRK(<@_0T^N=Z:""BBB@`HHHH`****`"BBB@`HHHH`]0HHHKZ8Q
M"@T4C8Q0`C&N`\6?$:/3;UM#\/Q)J.O[@IC(;R;<=2TC#T'8'-5O$7C+4-4O
MY='\,X2V`:*ZU;J(V&,K$/XFZC/0'Z5E:-HUKH=B+:V#,S'?+,YR\KGJS'N:
MX<5C8T59:LZ:.'<]7L16^AB341JNKW4VIZI@CSISE8P3DK&G1%ST[@$C)SQJ
M82,,^$7^)FZ`X[FE9@H+,0%&<DGTYKE-6U1M7MYK&#='92J4><'F12,$*.P]
M^]>1!5<3.[9Z%H4XV1C66@"V?4G&N7,=C<R%TD.P32C`RYD(R5R6XX!'/(-2
M+'X:B5E@MFOB<8V(TJ[@..<[5/KTZT]=/M%()@#X.1YA+D?0GI^%6:]I4GU9
MRH7^U+QMPM-.AME;^*>3)!_W$X/_`'V#4#_;KC/VG4I<-UCMU$2_@>7';^+]
M.*FHIJG!;#*\=C:0DLD";FZDC)/UJQ116@!1110`4448."<<#K18&[!14'VV
MT\TQ_:H-XX*B09J>FXM;B4D]F%%8_B+4I],LHWMRF]WV_,,X&"<BN;T_Q%>1
MZE')=3M)"QVLIX`!/7\*WIX:4X<R.:IBH4Y\C.\K%N_%.G6KM&#+-(I*D(F,
M$>YQ6RK!U#*<J1D$=Q7GGB&W^SZY<C'#MY@]\\G]<T\-3C.34A8NK.G!2@:5
MQXSN'!6VM8H\_P`3L7/]!_.G6?C&9956]@1HSP6BX(]\'K^E:6A:?IUQI$,I
MM(6<C#LRY.<^M9?B70X+.);NT38A;:\8Z#C@CT''ZUT+V#E[/E.5_6%!5>8Z
MZWN(KJ!)H7#QN,@BI*XSPEJ+179L'+&.8ED&>%8#G\P/TKL9$+Q.H?8Q4@-C
M.#7)6I>SGRG=0K>TI\W4Y[5[E;Y9G:-FL;$Y8`X\^3(&W/\`='MWS[5:L]5U
M"Z@1X](PC*"C&8*,>O3I[4_746#PW<Q1[558PH&.V1^O>K6D_P#('LQEN(4'
M/;CI]*T<H^SO8R49>UM?H6H=[0[IPJ2'HB,6`'N2!69'<0ZLSS69:.YM9"H9
MUP&]CW(./PX-7;.\AOHGEMVW(DC1$XQ\PP3_`#%9ND*MMK&K6QX9G25/]TYS
M_2LXK1O9HN;NXI.Z9L1L70%E*MW4]C3J<I49W+G([>M-K%^1T1OU"BBB@84R
M2*.9"LD:NIX(89]NE/HH`AMDN=/=&T^\DA6-2BP2EI(-IQ_!GC&.-I'Y<5H6
MWBB]@=4U33PR'C[19$N,YXS'C<!CTW55HK*=&$]T0X)G3Z?JUAJD(ELKJ.4'
MC`.&!P#@KU!QZU<K@KC3K:X<2,FR8'(FC.V0<8SD<^U6;;4-8TX.$G%^K.&V
MW+8=1W"L..G/(KCJ8)K6+,W!H[2BL*/Q=IAF\NZ\ZQ)(`-S'M4Y_VAE1T[D5
MN`@@$'((X.>M<<J<H?$B!:***@`HHHH`****`/4*#2;A6;K>OZ7X>TY[[5KV
M*U@&0#(V"[8)VJ.K-@'@<U]*8EJ\O+:RLI;JZGCAMXE+R2.<*H'<UY/K&OW7
MQ$M!;V37.G>'2Y\QR-LM^`W0?W8R`.>ISTP*JW%YJ?Q`+7.LQO:Z"7#VFFYV
MM(!T>4CKGKMZ5MQHL4:HBA54```8QBO+QF/4/<I[G;A\-?WI#+:VAM+>.WMX
M4BAC4*B(.%%)<W4%G`T]Q*L<:]6:F7]_#I]L9ILG)"HB_>D;LH]?Y`9)P`37
M*3W%S?S+-=LGR_<CC!VI^?4^_P"@KSZ&&G7ES2V.R4U!61)J%])J\F6+I9#A
M(=Q4R>[XZC'1#QSS[1`8&***]NG35.-D<[;;N%%%%:""BBB@`IJNCDA71BO#
M!6!(^OI6;XA-RFCRO:RO&Z$$E#@X[\USOA*\9-4EA=R?/3.2<Y8<_P`B:WA0
MYX.=]CFJ8CDJ*%MSMJ***P.DJZC?1:=8R7,I'RC"KW9CT`K@Y[O4=<NRG[R3
M=R(D^Z!]!_.M3QC<%KRWM\_*B%R/<G_ZU:'@Z%4TR:4`;Y)2">^!T'ZFN^FE
M2I>TMJSS*KE6K>S3T1AGPIJ84$QQD=P'!('TKNXHUAA2)?NHH4?A3Z*YJM:5
M3<[*.'C2V.9\9EOL=JOS;3(3TXR!_P#7KFI-/==*AOD!*.[(V/X<'C\ZZ#QH
M?ELQ[OW^G;_/>I]!LX[_`,+/;2JRK)(W(/<$$'\Q792G[.BF>?6I^TKR1)X5
MU,W5D;65OWL&`I)Y9>V/IC^59_C.WVW-K<`?>4H?P.1_,UB6\UQHVJ!V3;-"
MQ5U(_`C]:ZOQ(J7WAU;J+E5*2J>^#Q_6E*'LZRFMF5"?M*#@]T1>#I]UE/`3
M]Q]P^A__`%5OW5HM]:2VK8_>H4&>Q(X/YUQOA*?R]6:(GB6,C\1S7<?CBL,0
MN2M=&^%?/0Y6>9:7<_8]5M+@G`CE4M],\_IFO3F&&(SG!ZBO+2#+?%4VL7EP
M,=#D_P`J]1`P`!T%:8W[)GE_VD9GB$!M!NP1GY`1]015K3?^079X;</(3!/^
MZ.*=>P?:;&X@[R1LH^I%%DCQV%LD@PPA0'C'\(YKFYOW=O,Z^7]]?R,[1(&A
MN=4&-B&[8JF.`#S_`"(_*IC#L\2+,O\`RUMF#?\``67_`.*K2_\`UT@5#(KL
M"2@8+@^HQ_GZ4>TO)M]0]E:*2Z,6BBBLC<****`"BBJUSJ%I:8\^X16(RJ9R
MS?11R?PII,+HLT5C3^(8E!,-O*X&/WDN(DZ\YS\P_P"^>OM5NVTSQEK2,VFZ
M)<A-H=6,7E@@],23;58'_9!X-4J;(=1(O52GU:QMR5>="X!(1?F)]N*Z"T^#
MGB.^+'5M6M($X(1"\^2?O?W`N.V`>IKK=-^#WAZR(:Y>[O2&#8DD"*0,?*50
M`,#CG.:KDBNIE*OV/(Y]?1W-M!923,XP%=<!O7*CYB/PJQHWAKQO=S>=H&G7
M.FPRQ,^U4"0OPH!Q)\I/3HH.,\U]!Z9X>TG14VZ=IUO;<D@QQ@'GKSUK2`P:
M&HO2QDZC9Y2-+\6:3:6@U33$O=R*)9=/;>4?'\2$#\UR*9::E:7J(890'=01
M$_RR#CH5/(->LD9K)U7PSH^M#_3].MYFSD/MPXXQG<.<XXKCJ8*$]5H)29P]
M%7KOP%JFGJ&T/5?/C4D?8]1.5VDCA90-PP-V,ANU8<MY=Z;((==TZ;396E\M
M&PTL#Y/RD3!=@SSA20?:N"IA*D-5J6I7+U%(&5AD$$>U+7*TUN,ZCQCXPL_"
M6G"653/?3G9:6:<O,_L/3U->?)8:AKFNIK_B1XY+F,8L[./)BL\@$X]6]6]O
MIA=+T*6*Y75-9NY-3UIE(DNI6)"`G.R->BJ"3C`'X=*VL9]_:NK%X_G]RGL=
M=##<OO2"L[4]8@T[$0S+=.,QPJ.3[D]A]?2J^KZR]L_V6R\M[HC+M(I*1CU(
M!!)/ID5@JIR[R.9)7.YY'^\Q]_\`/`&!QQ6>%P;F^>>QO.I;1`P>>X:YN',D
MS#&23A0>RCH!Q^/>G=S117LQBHJR.<K7U]#IUL;B<ML!Q\HR2:RM+\2+J6I-
M;>2(T()C)/S-]>W2M:]M4O+.2"0<.,?2O.;:633]2CD(^>"3YA]#@BNVA2C4
M@^YP8FM.G4CV/3J*JW6HVEG;K//,$C;[IP3GZ`5ECQ=IID"[;@#NQ08_GFN>
M-*<E=(ZI5Z<79LWJ,@=2*S-6U9+#3/M,>)&D^6+!X)(ZUQD,.I:]<L@=YBHW
M-OD^51GL"?T%:4L.YKFD[(QK8I0:C%79WSM!>PR0++&X=64A6!X[UYU;R/IN
MJQNP.Z"7Y@/0'!'Y5N6OA2^M[N"9I("$D5F"L<\'/'%4?$]K]GUF1@/EF`D'
M\C^M=5!0C)P3O<X\2YS2G)6L37WBN_GE86C""(=-J@L?J2/Y4W3_`!3?6TB"
MY<W$`X(.`V/8_P"-;?A2&V;2O,6-3,7(=B,GV_"LOQ9IR6]REY$@5)OE<`8&
M['7\>:J+I.;I<HI*JH*MS$?BLI/<6E[%('AGA^4^A5CD?J/SK7\&RB32KB+'
MSPS`D_[+#C]5:N95WNM%>$MG[(PD1?16.&_7!JSX9U'[#JGEL<1W.(FR<`'(
MP3_GO55*=Z3@NAG2K6K*;ZG?44=:;)(D2;Y'5%R!EC@9->38]NYR/C0@W%HN
M>0C'&/<5CVVM7MG:"VMI%C3<6R!\Q)]ZU/&39U"W7YN(L]>.IZ5K>&K&U;1X
M+AH(6E8MEL9/WB.<_P"<8KTU*,*"<E<\B4)5,1)1=CC9DNY]]U,DK`_>D9>/
MSK<\/W?VJRNM'DQF5',1/7..GZ9_.NPF@CGMY(''[N12I'L:X:+P]K,5^?LU
MNZF)_DF9@JGW!)&>/2B-:-:+3TL$Z$Z$DUK<SM.NOL6H07!SB-\L!UQWK>U'
MQ:9H)(;.!DWC'FLW(_"IE\'O/<2375W%$'8MY=NA?&3G&3C'ZUI0>%])@`_<
M23,/XII,_H,#\P:56K1NF]6AT:->S4=$SG_"^E-=7JW<@(A@Y4XSN;L/PZ_E
M7<4U$6-`B*%51@`#@"G=ZXJU5U)7/1H452C8*5F9CECDXQ25#<7=O:J6GFCC
M`_O-BLE<U=NI-163-X@M4&88YIN>"J[01ZAFP#^=%K-XCUAB-)T623:X7<L3
MR@$]-Q^55/J=U6J;)=2*-:J]Q?6MI_KYT0D9"DY)'L.IK4LOA9XPU4AKZ\CL
M8]VUA--EPO&2$APK>F"P[_CU&E?!/2+0H]_J%S=,I):.!1;Q-Z=,N,>S\X].
M*I074S===#S.X\1VL,;.D4CJ/XVPBD?4_P"%36<'BK6'<:=HER%4*2_D'`!S
M@'=M!Z'IFO==+\$^'=&9'LM(M4F0%1,Z[Y"#V+MEC^)K="8QC'2G[J,W5DSQ
M"S^$WBC4&W:EJ$5JF\`J)BQV]RNS'Y$UT^E_!?0K(`W=Q/<MNRRH!"CCT(7G
MUY!%>E#.*6G=]"')F'I?A+0=&,;Z?I-K#-&24GV;I1G@_.V6Z$CK6R%/K3Z*
M1(4444`%%%%`!1110`5%-"DT;Q2(KQNI5E<9!!Z@CN*EHI`<C?\`P^TN;S7T
MIY='FDY;[$%$9;``)C(QT';&>]<]>:#XFTEY/]&BU6UR,26Q$4H4G!!0\'`.
M>#7I]-*DYK*="$]T--GF>?3FN;U'7#=;[2PWK'G:]R,8('9/?WZ#MG.:KZCJ
MTVJ%HH&\NQ;@G!WSCOSGA?U/\ZH```'0=J\O"X*WOU-SU9U;Z(;%$D,81!@?
M7)/U/>GT45ZBT,0HHHH`*X#Q/:?9M8=P,),`X^O0_P"?>N_KG?%]IYVG)<@?
M-"W/^Z>#_2NK"3Y:ENYQXVGS4[]CG["POM?G53+^[@0)YCGA!V4"I-;T$Z1'
M%*DQEC<E3E<%3_G/Y5;\'7?EWDUJQ^65=P'N/_K5T.O6GVS1YT`RRC>OU'/\
MLUT5*TH55'H<E/#QJ4'/J<C#F]\-3Q9S)92K*HSU1N"/P/-5M*U6?2IF>$*P
MD`#*PZ^G\ZL^&;O[+K<0)PLH,9_'D?J!^==5-X:TJ9]WV?9G.0C$`_A55*D:
M;<)+1DTZ4ZD5.#U1BCQI-N!-E'C(X$AZ=^U0:SJ%OK6GI<H!'/`^UHV/)4]P
M>XXK6U#PUIL6G321(\<L:%E?S#R1Z@\?RKD+&U:]NTMT;!?.#]`33HQI2]^"
MM85>5:/N3=[F_P"#KK;<3VI/WQO7ZBM;Q6@;0W)_A=2/8YQ_6N*M)KBVND>V
M+"<':NT9)]JM7^JZCJFR"X)8(>(UC`Y]^Y-$Z-ZJFF$*Z5%TVBYX30/JLJ,F
MY&@8-GZBHM9T"?3I7DA1Y+0G*L.2GL?\:Z/PWI$FG6[RW"@3RX^7.=BCM^/6
MMRL*F)<:K<=CHI813I)2T9P%GXGU"SMA#F.55&%,B\C\1U_&HY+K5/$$ZP\R
MD<JB@*%]\_XUW+Z;8RL6>SMV8G)8QC/Y_C5B.*.)`D:*BCLHP*3Q,%K&.I2P
ME1Z2EH<S-X4N[N2)KG4E(2,(S$%VX[`<<?4YK?L+)-.LH[6.1G5,_,P`)R<]
MJL_TILDB1+ND=44<%F.!7/.M.HK,Z:>'A3?,AU%9DNO6,0.UWEQU,:$A?K4%
MOJNI:I*L.EZ7+.SL4&T%_FQSC:,''N14*#9HYQ1M=JBGN(+:/S)YHXDSC=(X
M49^I^E3V'@'QSK/EO*@L(9-P)E<18`R!E5W."<=B.M=-IGP4A5Q-JFL2O*R$
M/]F0!P>./-?<67Z@?I5*'=F;K+HC@I_$-C"A=?-E4=65,*!Z[FP"/H33+*\U
MK6BHT?2Y+E2_E[X4:9-_'!<`*IQ@\GN*]PTKX<>%=(:.2+2TN)D"XEO&:=@P
M_B&\D*V><J!74[![8^E5:*,W5DSP:Q^&OC35BIO)4L(FRK>;*-P'NB9!S_O5
MTND_!*Q@"2:IJD]S)SO6!1&/;#'+8QCO7JH7!S2T^9]#-R;.9TSP#X9THJUO
MI4+RA=AEG'F,W(.3NXSD=<5T>WGK3Z*0A`,4M%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`?/E%%%8GH!1110`4444`%0W=NMU9S0/\`=D0J
M:FHIQ=G=$RCS1:9YE9S/IVIQ2-PT,F''T."*],!5U!&"K#\Q7(:KX;OKO69I
M+2)/)DPQ=Y`H![^_;L.]=18036MA!!.Z/)&H4LA)!QTZ@'I79BI1FHR6YPX.
M,H.4&M#SN_@;3M6FC3@Q290^V<@_RK5O;K69KMKRS2]2WE"L@4$C&,=!GWKK
M)=+L)[G[3/:12S8`W29(Q_NYP?Q%6E544*B*BC@*B@`?0"B6*C9:78HX.2;5
M[(X0P>(]67:Z7+QGCY_W:''UP#70:#H/]F?Z1.X>X9<;<<1_0]_K6Y2$A068
M@`<DDXQ64\2Y+EBK&U/"QA+FD[LJ6^DZ=:RF:&RB64DG><L0?;)./PQ5O:H;
M=@9]:HR:U81\+.)6QP(AOS[9'&?QJB/$#W4Q@T^SDGE(R%4%V&.N53)Q6;YY
M;FR5.&QNTC,%&6(`]ZCLO"OCC6T#PZ?)9QN@D4R[8N#TP3DY]B!706OP3N[H
M.=6UH9(!7RT,G)ZY#'&1V(%'L^[$ZR6QR;Z[IR_ZN?SSV\A2XSZ$@8'XD55C
MUJZU"?[/I>GO-.<@)S))D9SA(PV0/J.AZ5[/I_PJ\*V4ADDM9[Q\@J;J9FVX
M[`#`Q[$&NPM;*UL;=+>TMXK>!,[8XD"*N3DX`XZU2C%&;K-G@-GX)\>:T4(M
M/L5O(F[?<2+;KQC`VC?*I^H'2NDT_P"";.WF:MK;%R@)%M%\RMZ%Y-VX#IG:
MI^G2O8`H%&T9IIVV,W)LY+2_AKX7TN59DT\W$JE65[IS+M([@-P/PKJ(;:&V
MC\N")(DZ[44*/R%2XQ2TFVR1NT>M+M`I:*0!1113`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@#Y\HHHK$]`****`"BBCVI
M`%%5+C4[*T=DEN8Q(/\`EDIW/_WR/F_2LVZ\46MN<+$WJ#,PC#+Z@'+?ABJ4
M6R7)(W:/\\U2M-)\::R[+9Z)=P(K#+R0>4!G/>7!8#N56NAL?@]KM\0=7U2*
M$!^41FE.WN0?E`/M@]*OV?=F;JI'/3ZO8P$AKA6?&0B?,3^549/$(=F%I:/)
MZ,YVK^(Y8?E7K.E_"#P[88^TO=7Q#%B)'"H1Z%%P*[;3M$TO28D33]/MK8+&
M(P8H@IVCMGJ>@JE&*,W6?0\!M-`\;ZP3]FTJ>"+`<-Y:Q]>@#2G#?@H[5T5E
M\%]6NI2^LZW;JJL"JQJ]P3_>(+E50^F%(]NU>U8%&T#M3OV,W-LX33?A-X8L
M2#<1W6H.'W`W4WRXX^4H@5&''=3G-=C9:98Z=!'!96<%M%&-J)#&%"CT`%6L
M"EI79(W:,]*7`Q2T4`)@"EHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`^?**Y_Q#KEUI=Q
M:0VZQ$3@Y9U)*\@<<^]8FLZE>0V22M<22EGV%6;:I&#QA<`U,:=SME.QV4^H
M6=KD2W$:L#C;G)S]!S5";Q#;H56**21F.%SA0WN,]?\`Z]=7\//A]H^OZ#8:
MIJ$EV[W$+.T,<@C0'<0,%5#=N[&O5M,\+:#I);[!I%G!NP6V1#DCH?UJN2,3
M%UGT/!;2V\6ZPP&FZ+,%\P1EVB.T$XZEL8QG)/-=!8_"7Q/J)#:KJ,=M$6*E
M?-+MMQUVIM4Y]":]THIWML9NI)GFVE?!W0;.)%O;BYO`N=T2$01-G_93YA_W
MUS7:Z3X>T;0U*Z7I5G9DJ$9H(51G`Z;B!D_C6I11=LENXE%+12$&!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
@0`4444`%%%%`!1110`4444`%%%%`!1110`4444`?_]E1
`






#End