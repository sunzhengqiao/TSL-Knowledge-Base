#Version 7
#BeginDescription
Version 1.1   12.12.2005   hs@hsbCAD.de
   - bugFix Listenausgabe
Version 1.0   12.08.2005   hs@hsbcad.de
   -fügt BMF-Sparrenpfettenanker an ausgewählten kreuzenden Stäben ein
#End
#Type X
#NumBeamsReq 2
#NumPointsGrip 1
#DxaOut 1
#ImplInsert 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
	U (1, "mm");

	String sArType1[10];
	for (int i = 0; i < 8; i++)
		sArType1[i] = (T("BMF-Sparrenpfettenanker"));
	for (int i = 8; i < 10; i++)
		sArType1[i] = (T("BMF-Pfettenanker"));
							
	String sArType2[] = {"170","210","250","290","330","370","170e","210e", "UNI 170", "UNI 210"};
							
	String sArType[sArType2.length()];
		for (int i = 0; i < sArType2.length(); i++)
			sArType[i] = (sArType2[i] + " " + sArType1[i]);
		
	PropString sType (0, sArType, T("Purlin anchor"));

	double dLength[] = {U(170),U(210),U(250),U(290),U(330),U(370),U(170),U(210), U(170), U(210)};
							
	double dWidth[] = {U(34.5),U(34.5),U(34.5),U(34.5),U(34.5),U(34.5),U(22.5),U(22.5), U(33), U(33)};
							
	double dThick[] = {U(2.0),U(2.0),U(2.0),U(2.0),U(2.0),U(2.0),U(2.5),U(2.5), U(2.0), U(2.0)};
	
	String sArNY[] = {T("No"), T("Yes")};
	
	PropString sArt1 (1, "", T("Article"));
	PropString sMat1 (2, "Stahl, feuerverzinkt", T("Material"));
	PropString sNotes1 (3, "", T("Metalpart Notes"));
	
	PropString sMod2 (4, "Kammnagel", T("Nail") + " " + T("Model"));
	PropString sArt2 (5, "", T("Article"));
	PropString sMat2 (6, "Stahl, verzinkt", T("Material"));
	PropDouble dDia (0, U(4), T("Nail") + " " + T("Diameter"));
	PropDouble dLen2 (1, U(40), T("Nail Length"));
	PropInt nNail (0, 0, T("Number of nails"));
	int nNail1 = nNail;
	PropString sNotes2 (7, "", T("Metalpart Notes"));
							
	PropDouble dOffsetF (2, U(0), T("Offset purlin anchor front"));
	PropDouble dOffsetB (3, U(0), T("Offset purlin anchor back"));
	
	String sArSide[] = {T("Front"), T("Back")};
	PropString sSide (8, sArSide, T("Side"));
	
	PropString sOneSide (9, sArNY, T("On One Side"), 0);
	
	PropString sSwitch (10, sArNY, T("Switch Purlin anchor"), 0);
	
	PropString sFour (11, sArNY, T("Four purlin anchor"), 0);
	
	PropString sDescription (12, sArNY, T("Show description"),1);	
	PropDouble dxFlag (4, U(200), T("X-flag"));
	PropDouble dyFlag (5, U(300), T("Y-flag"));
	
	PropString sDimStyle (13, _DimStyles, T("Dimstyle"));
	PropInt nColor (1,171,T("Color"));
	
	int nBd = 2;

// find type
	int f; 							 				
	for(int i = 0; i < sArType.length(); i++){				
		if (sType == sArType[i]) 			
			f = i;
	}
	
// get entity
	if (_bOnInsert){
		_Beam.append(getBeam(T("Select First Beam")));
		_Beam.append(getBeam(T("Select Second Beam")));
		
			if(_Beam.length() < 2)
				return;	
			
		showDialog();
		
		return;
	}

// declare standards	
	Beam bm1 = _Beam[0];
	Beam bm2 = _Beam[1];	

	Vector3d vx1, vy1, vz1, vx2, vy2, vz2;
	vx1 = _X0.normal();
	vx2 = _X1.normal();
	Plane pn (_Pt0, _Z0);
	Vector3d vR = vx2.projectVector(pn);
	vz1 = vx1.crossProduct(vR).normal();
	vz2 = vx1.crossProduct(vx2).normal();
	if(vz1.dotProduct(_ZW) < 0)
		vz1 = - vz1;
	vy1 = vx1.crossProduct(vz1).normal();
	vy2 = vx2.crossProduct(vz2).normal();
	
	vx1.vis(bm1.ptCen(), 1);
	vy1.vis(bm1.ptCen(), 150);
	vz1.vis(bm1.ptCen(), 3);
	vx2.vis(bm2.ptCen(), 1);
	vy2.vis(bm2.ptCen(), 150);
	vz2.vis(bm2.ptCen(), 3);
	
	CoordSys cs(_Pt0, vx1, vy1, vz1);
	
	double dH1, dW1, dH2, dW2;
	dH1 = bm1.dD(vz1);
	dW1 = bm1.dD(vy1);
	dH2 = bm2.dD(vz2);
	dW2 = bm2.dD(vy2);
	
// Insertion Points
			 
	Point3d ptInsert1, ptInsert2;
	ptInsert1 = _Pt0 - vx1 * dW2/2 - vy1 * dW1/2 + dOffsetF * vz1;
	ptInsert2 = _Pt0 + vx1 * dW2/2 + vy1 * dW1/2 + dOffsetB * vz1;
	ptInsert1.vis(2);
	ptInsert2.vis(3);
	
// Body
	Body bd11 (ptInsert1 + ((dLength[f] - U(70)) - dLength[f]/2) * vz1, -vz1, -vx1, -vy1,
				 dLength[f] - U(70), dWidth[f], dThick[f], 1, 1, 1);
	//bd1.vis(3);
	Body bd21 (ptInsert1 - ((dLength[f] - U(70)) - dLength[f]/2) * vz1, vz1, -vy1, -vx1,
				 dLength[f] - U(70), dWidth[f], dThick[f], 1, 1, 1);
	//bd2.vis(3);
	Body bd1;
	bd1 = bd11 + bd21;
	bd1.vis(3);
	
	Body bd12 (ptInsert2 + ((dLength[f] - U(70)) - dLength[f]/2) * vz1, -vz1, vx1, vy1,
				 dLength[f] - U(70), dWidth[f], dThick[f], 1, 1, 1);
	//bd1.vis(3);
	Body bd22 (ptInsert2 - ((dLength[f] - U(70)) - dLength[f]/2) * vz1, vz1, vy1, vx1,
				 dLength[f] - U(70), dWidth[f], dThick[f], 1, 1, 1);
	//bd2.vis(3);
	Body bd2;
	bd2 = bd12 + bd22;
	bd2.vis(3);
	
	CoordSys csMirrY1;
	Plane pnY1 (_Pt0, vy1);
	CoordSys csMirrX1;
	Plane pnX1 (_Pt0, vx1);
	csMirrY1.setToMirroring(pnY1);
	csMirrX1.setToMirroring(pnX1);
	
	String sArSideType[] = {T("Right"), T("Left")};
	String sSideType1, sSideType2;
	sSideType1 = sArSideType[0];
	sSideType2 = sArSideType[0];
	
	// switch purlin anchor
	if (sSwitch == sArNY[1]){
		bd1.transformBy(csMirrX1);
		bd2.transformBy(csMirrX1);
		sSideType1 = sArSideType[1];
		sSideType2 = sArSideType[1];
		int i = 1;
	}
		
	// on one side
	else if (sOneSide == sArNY[1]){
		if (sSide == sArSide[0]){
			bd2.transformBy(csMirrY1);
		}
		else if (sSide == sArSide[1]){
			bd1.transformBy(csMirrY1);
		}
		sSideType1 = sArSideType[0];
		sSideType2 = sArSideType[1];
	}
	
	// on four sides
	else if (sFour == sArNY[1]){
		Body bd3, bd4;
		bd3 = bd1;
		bd4 = bd2;
		bd1.transformBy(csMirrX1);
		bd2.transformBy(csMirrX1);
		bd1 = bd1 + bd3;
		bd2 = bd2 + bd4;
		sSideType1 = sArSideType[0];
		sSideType2 = sArSideType[1];
		nBd = 4;
	}
	
	if(sSideType1 == sArSideType[0] && sSideType2 == sArSideType[1])
		sSideType1 = (T("Right") + "+" + T("Left")); 
	
// get Grippoints
	if (_PtG.length() < 1)
		_PtG.append(_Pt0 + dxFlag * _XW + dyFlag * _YW);
	
	dxFlag.setReadOnly(TRUE);
	dyFlag.setReadOnly(TRUE);

//Flag
	double dF;
	if(dxFlag == 0 && dyFlag == 0)
		dF = U(1);
	PLine pl1 (_Pt0, _PtG[0]);
	
// display
	Display dpbd(nColor);
	Display dp(nColor);
	dp.dimStyle(sDimStyle);
	
// show text
	dp.addViewDirection(_ZW);
	int nChange = 1;
	if (sDescription == sArNY[1]){
		_PtG[0].vis(1);
		if ((_PtG[0] - _Pt0).dotProduct(_XW) < 0)  //vzE.crossProduct(vy)
			nChange = -1;

		int dYFlag = 3;
		
		dp.draw (sArType1[f], _PtG[0], _XW, _YW, nChange, dYFlag, _kDeviceX); 
		dYFlag = -3;
		
		dp.draw (sArType2[f], _PtG[0], _XW, _YW, nChange, dYFlag, _kDeviceX);
		
		if(dF != U(1))
			dp.draw(pl1);
	}
	
// show body
	dpbd.draw(bd1);
	dpbd.draw(bd2);

// model + hardware
	String sModel = sArType1[f] + " " + sArType2[f] + "-" + sSideType1;
	model(sModel);
	material(sMat1);
	
	if (nNail1 > 0)
		Hardware( T("Nail"), sMod2, sArt2, dLen2, dDia, nNail1, sMat2, sNotes2);

// setCompareKey
	setCompareKey(String(dLength[f]) + String(dWidth[f]) + String(dThick[f]) + sType + sArt1 + sMat1 + sNotes1
					+ sMod2 + sArt2 + sMat2 + String(dDia) + String(dLen2) + nNail1 + sNotes2);
	
	
	
	
	
	
	
	
	
	
	
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
M"`'P`>`#`1$``A$!`Q$!_]H`#`,!``(1`Q$`/P"[0`4`%`!0`4`%`!0`4`%`
M!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4
M`%`!0`4`%`#'D"#GKZ4`5GD+GV]*FY5A`/6@8M`"4"$)H`3K2&+BF`N:`$-`
M"4@"@!0*8"T`%`!0`4`%`"4""@`H&7JH@*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`(
M99@N0O7^5*XTB`DL23WI#`#%`Q:!"4`)2&&*8"]*`$S0`E(`H`7%`"TP"@`H
M`*`"@!*`"@`H`6@`H`NU1`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%
M`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`"$A1DG`H`KR3%^%X%
M3<I(C`H&+0`E`"4`%`"XH`,T`)0`E(`H`4"F`M`!0`4`%`!0(2@`H&%`"T`%
M`"4`7JH@*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`&22*@YZ]A0%BLS-(<M^524'2@8E`@H`2@
M88H`6@!,T`)2`*`%`I@+0`4`%`!0`4`)0`4`%`A:!A0`4`(30`A-("_5D!0`
M4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`
M!0`4`%`!0`4`%`$,DV.$Y/K2N-(AZG).3[TAA0,2@!*`"@!:`$S0`4`)2`7%
M,!<4`%`!0`4`%`"4`%`!0`4"%H&%`"4`!-(!*8!0(OU1(4`%`!0`4`%`!0`4
M`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`(2`
M,G@4`5Y)2_`X7^=*Y20RD,2@`H$)2&%,!:`$S2`2@`I@+B@!:`"@04#"@!*`
M"@`H`*`%H`*`"@!*`$)I`%,`H$&,T`7ZHD*`"@`H`*`"@`H`*`"@`H`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`8[A!SU]*`*[L7.34
ME#:`"@!*!A0`M`"9H`2D`4`+BF`M`!0(*!A0`4`)0`4`%`!0`M`!0`4`)2`3
M.:`$I@%`#@*`#-`%ZJ("@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`*`"@`H`B>8#A>3ZTKCL0$Y.2<TAB9H`2@84`%`!0
M`4@$H`7%,!:`"@`H$%`PH`2@`H`*`"@!:`"@`H`*`$)I`-I@%`"@9H`7I0`9
MS2``*8%ZJ("@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`$)"C).*`*\DI;@<"E<JQ'2`3-`PH`,4`%`!2`2@`H`7%,!:
M`"@`H$%`"4#"@`H$%`PH`6@`H`*`"@!I-(!*8!0`H%`"]*`$ZT`+0`C,%'-`
MB_5$A0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`
M!0`4`,>0)UZ^E`6*[.6.2:DH;F@!*!A0`4`%`!2`2@!<4P%H`*`"@`H$%`"4
M#"@`H$%`Q:`"@`H`*`$)I`)3`2@!<4@%I@&?2D`8I@%`#7D"\#DT"(223DFF
M(UJ8@H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@
M`H`ADFQPG/O2N.Q`3W-(8F:`"@88H`,T`%`!2`,4P%H`*`"@`H`*!"4#"@`H
M`*!!0,6@`H`*`"@!":0"4P$H`4"@!>E`"4`+B@`)`ZT"(GESPO`]:=A7(Z`"
M@#7IB"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`0
MD*,DXH`KR2EN!P*5RK$>:0Q*`#%`"T"$S0,*`"D``4P%H`*!!0`4#"@0E`PH
M`2@!:`"@!:`"@04`%`QI-(!*8"T`&*`%H`*`"@0C,%'-`$+.6Z]/2F(;0``$
MG`Y-`%V"T`^:7!/8?Y__`%4Q%J@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`8\BI[GTH'8KNY8Y8U(QF:!A0`4`&:`"D`4P#%`"T`
M%`!0`4`%`"4`%`"4`%`"T`+0`4`%`!0`A-`"9H`*`"D`O2F`G6@!<4`%`ACR
M`<#DT`1$Y.33$)0`^.)Y3A!GU/I0!?A@6$<<D]2:8B6@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`ADFQPGYTKCL0$TAC:!BX]:`"
M@`H`*0!0`N*8!0(*`"@84`)0`4`)0`4"%Q0,*`%H`*`"@`H`0FD`G6F`4`&*
M0"YI@)0`M``3CK0(B>3/`X%.P7(Z!!0!8@M3)\SY5>WJ:8B\JA5"J,`4`+0`
M4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`C,%&2<"@"O)
M*6XZ"IN58B)H&)C-`"]*`"@!*0"T`+BF`4`%`!0`4`)F@!*`"@`H`*`%H`*`
M%H`*`"@`H`:30`4`%`"]*`$H`7%`!0(:SA?K0!$S%CS3$-H`4`L<`$GT%`%R
M"U"_-)@GT["F(M4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`
M!0`4`%`#))`GN?2@96=RQR34C&=:!BXQ0`9H`*`"@!<4`%`!0(*!A0`4`(30
M`E`!0`4"`4#%H`*`%H`*`"@!":`$ZT`%`"XI`%,!*`%H`*!$;R8X'6BP7(B<
MG-,04`/BB:5L+^)-`%^&%(AQRW<TQ$M`!0`4`%`!0`4`%`!0`4`%`!0`4`%`
M!0`4`%`!0`4`%`!0`4`%`!0!!)-CA/SI7'8@)S2*#'K0`=*`"@`I`&*8"T`%
M`!0`4`%`"4`)F@`H`*`"@0N*!BT`%`!0`4`%`#2?2@`H`,4@%I@)0`N*`%H$
M-)P*`(G?/`Z4["N,H`*`+,%L7PS\+Z=S3$754*H51@"@!:`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`&LP49-`%>24OP.!4W*2(NM`Q
M>E`!FD`E`"TP%Q0`4`%`!0`4`)0`9H`2@`H`*!!0,6@!:`"@`H`*`$)Q0`G6
M@`H`6@`S0`G6@!:`%H$,9PM`$+,6//Y4Q"4`*JEF"J,DT`78+8)AGY;T["F(
MLT`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`$<DH3C
MJWI2N.Q69B[9/6D,3'K0,,T`%(!*`%`H`6F`4`%`!0`9H`3-`"4`%`!0`4"%
MH&%`"T`%`!0`4`(30`E`!0`M`"9H``*`%H$!-`$;R8X'-%@N1$YIB"@"2*%I
M6P!@=S3`OQ0K$N`,GN:!$E`!0`4`%`!0`4`%`!0`A('4XH`6@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@!.G6@"&6;JJ?G2N-(@Y/-(H.E`!2`2@!0*8"XH`*!!0
M,*`"@!,T`)F@`H`*`$H$+0,6@`H`6@`H`*`$S0`A-(`I@&*`%H`3K0`N*`%H
M$-)XST%`R)GSP.!3L3<90`4`68+5F(:087T[FF(NJH50JC`%`"T`%`!0`4`%
M`!0`A(`R>*`&-,HZ<TKCL1M,S=.*5QV&'DY)I#+=60%`!0`4`%`!0`4`%`!0
M`4`%`!0`UF"+DT`5I)2YP.%]*FY20S'K0,,T`)2`*`'`4P%H`2@04`%`Q,T`
M)0`4`%`!0`4`%`"T`%`"T`%`!0`F:`$H`*`%H`3-`"@4`%`@S0`UF"]>OI0!
M"S%CS3$)0`JJ68*HR30!>@MA'\SX9NWH*8BQ0`4`%`!0`4`%`#&E1>^?I2N.
MQ$T['[HQ2N.PPDM]XTAB<4`+R:`#'K0!;JR`H`*`"@`H`*`"@`H`*`"@`H`C
MDE"<=6]*38TBLS%VR:0Q.E`Q*0!0`X"F`4`+0`TG!K2.J(>X9I./8=Q:@H:3
M0`4`)0`4`%`"T`%`"T`+0`4`%`!0`TF@`H`*`%Z4`)UH`7%`!0(,T#(VD[+1
M85R+K3$%`$D,+RGC@=S3`OQ1+$N%[]2>]`B2@`H`*`"@!C2*O4T7'8C:<G[H
M_.E<=B,EF^\:0Q.!2`7)["@`QZT`'2@!,T`')H`N59`4`%`!0`4`%`!0`4`%
M`"=*`())\\)^=*XTB'W/)I%!F@!*0"XI@+0`M`"4`%`AIZUI#83"J)$'2LGN
M6A:0Q*`"@!:`"@`Q0`M`"T`%`!0`AH`3-`!0`M`"9H``*`%H$&:`$)QR:!D3
M.6Z<"F3<90`4`68+4M\TF0/3N:8BZ`%&``!Z"@!:`"@!K.J]2*`L1M/_`'1^
M=*Y5B,N[=2:0QN!WI`&?04`+@]S0`<"@`)H`2@`H`*`#ZT`7*L@*`"@`H`*`
M"@`H`*`&LX09)H`K22,_L/2IN589F@84@#%,!<4`%`!0`4`%`"9H`0U<"9!5
MDB5E+<M;!2&%`"T`&*`%H`*`%H`*`"@!":`$I`%,!:`$I`+3`*!!F@!K,%ZT
M`0LQ8\TQ"4`.56<X4$GVH`O06RQ\MAF_E_GUIB)Z`$9@HY.*`(FG`^Z,TKCL
M1M([>PI7'8;CWI##/H*`%P30`8`H`,T`)F@`^M`"?2@!:`"@`YH`,4`7*L@*
M`"@`H`*`"@`H`CDE"<#EJ5QV*S,6.6.32&)F@8E(!P%,`H`6@!*!!0,2@`H`
M2@`JH;DL*T)$[FLY;E(*D8M`!0,6@!:`"@`H$%`#2:!A0`8H`*`%H`*`"@0E
M`QC28X7GWHL*Y%3$%`$L,#3'C@#J33`O)&D*X7CU)[T"$:91TYI7'8C,KM[?
M2E<=AG7J:0PZ4`+@F@`P*`#.*`$S0`4`)0`O-`"?K0`O-`!B@!<4`&10`9-`
M%NK("@`H`*`"@!.E`$,DW9/SI7'8@S2&)0,7%`"T`+0`E`@H`2@84`)2`*8"
M4`%5'<3V%K0@3O43*0M04%`"@4`+0`4`%`A":!B4`%`"T`)0`M`!0(*!B$@#
M)H$1.Y;CH*8AE`!0!-%$O63/L!1<+%@RMC"X4>U*X[#3DG)-(8G`H`7F@`QZ
MT`'`H`3-`!0`4`%`"4`+S0`8H`7%`!D4`&3VH`0\=30`A8#H,TQ#2Q]:`+]4
M2%`!0`4`-9@HR30!7DE+^P]*FY5B+-`P`H`<!0`4`+0(2@!*!A0`4`)FD`E,
M`H`2@!0*:W$Q:U($[U,]BD+BLRA:`%H`*`"@0A-`Q*`#%`!F@`H`6@`H$'6@
M8UG"_7TH$0EBQR:8A*`%`+'`&30!.D6WD\FD.P_`I#%SZ"@`QZT`'`H`3-`!
MS0`?K0`4`%`!0`8H`7%`!D4`&2:`$.!U-`"%QV&:8#2Y/M0(3-`"9H`*`-&J
M)"@`H`CDE"\#DTKCL5F<L<DY-(8VD,4"F`N*`%H$)0`F:`"@84`)0`E`!0`4
M`)0`M`A:%N`5L0)W%3+8:W'UF6%`!0(*`&YH&%`"T`)F@!<4`%`@S0`4#(WD
MQPO7UHL*Y%3$%`"@9II7$6(P`@P*3W*0_!J1A@4`&:`$R30`4`'Z4`''UH`.
M:`#%`"XQ0`9%`!DF@!,>IH`0NHZ<TP&EV/M0(3ZT`)F@`H`*`#%`"XH`T*HD
M3I0!!)/GA.!ZTKC2(,TBA0*0"@4P%H$)0`$T#$H`*`"@!,T`)0`M`"4`%`!0
M(6@8F0*?*Q7$+>E:W(`$[A4O8:)*S*"@!,T#$S0`4`%`!UH`6@`H$)UH&!(4
M9/2@1$[EN!P*8AE`!0!(L?=ORJU'N(6F!+&?EK.6Y2%S4C"@`H`*`#GM0`8H
M`7%`!D4`&2:`$QZF@!"ZCWI@-+L?:@0GU-`"4`&:`"@`Q0`8H`6@`H`*`+SN
MJ#+&J)*LDA?KP/2IN4D,ZTAC@*8"T""@!*`$H&%`!0`A-(!*8"T@"@!*8!0`
M4`+0`H%`$9ZFM2!*`%'!H`EK(H0FD,2F`4`%`"XH`*!!F@!*!B,X7W-%A$+$
ML<FF(2@!54L<`9-`$PC"8[FJB#%JR1AZT@'Q]#42*0_-04'-`"XH`,4`&10`
M<T`)]:`$+@4`-+D]*8#>3U-`@X%`!F@`H`2@!<4`+B@`H`*`"@!,T`%`#V8L
M<DY-`P`H`6@!:!"4#$S0`4`%`!TH`3.:0!3`*`"@!*`#%`!0`M`A<4#%H`C;
M[QK1;$,;3`*`),YK(L,4`'2@`H`6@`H$%`Q/Y4`,>3LOYT["N14""@!Z1EOI
M1<+$ZKM&!P*10,.*J!,AM:$C&ZT@'Q=2*B12)*@H,T`')H`3ZT`!8"@!AD]*
M8"$DT"$Q0`M`"9H`2@`H`7%`"T`%`!0`4`)0`4`%`"4`2XH&+0(2@`)H`2@8
M4`%(!,^E,!,4`+0`4`%`"4`%`"T"%Q0`4#%H`*!$;_>K1;$L;3`*`)!T%9O<
MI!2&*!0`4""@`H&(2%&30(B=RW':F(90`H4MT&:`)4BQR_Y4KCL2\#I2&'-`
M",.,U<=Q/8;6A`UNM#`6/[WX5$MBD2<=ZS*`L!0`TO3`;N)H$)B@!:`$S0`4
M`)0`N*`%Q0`4`%`!0`F:`"@`H`*`$H`6@`H`EH`3-`"9H&%`!0`F:`$ZT`*!
M0`M`"4@"@!*8!0`N*!"@4#%H`*`"@04`1O5QV$Q`I/2FW85AX0#KS4N78JP[
M:.PJ;C#&*0"4Q!F@88H`:[A>!UH$0\L?4TQ#Q"QZX%%PL2")!UY-*X[#_I2&
M&*`%X%`!GTH`1LD54=Q/896I`UJ&`BG!S4RV&AQ8FLRA.:`#%`"T`)F@!*`"
M@!<4`+0`4`%`!0`E`!0`4`%`!0`4`%`!0`4`/S0`4#$H`,T`)0`H%`"XH`*`
M$S0`E`!0`4"%`H`7%`Q:`"@04`&#0,,#N:0!@'L*=P%QZFD`9`Z4`')H`4#U
MH`0XH`;BF`AW-TX'J:!"")1UR:+A8>!CH,4ABXH`7@4`&?2@!.:`#`H`,XH`
M:7%-;B8E;$#6Z4,!*E[#'5F4)F@`S0`E`"XH`7%`!0`4`%`"9H`*`"@`H`*`
M"@`H`*`"@`H`3-`!0`^@84`%`!B@!<4`%`@H&)F@!*`"@``H`<!0`M`!0`8H
M$&*!B_04@#![T`'`H`,DT`&/4T`+P*`$S0`?6@`XH`.30`8H`7B@`S0`G)H`
M./K0`9]!0`TL!WI@(7]*!#22:`#%`"UL0!Z4`,I#'5D4%`!B@!:`"@`H`*`$
MH`*`"@`H`*`"@`H`*`"@`S0`F:`"@`H`*`'TAA0`N*8!0`M`A*!B4`)0`4"%
M%`Q<4`+B@!<4`%(`P:`#`H`,^E`!@T`'`H`,T`%`!0`<T``%`"\"@`S0`<F@
M!.*`#/H*`$)]30`TOZ"F(:230`4`&*`%H`3-`"ULMB0/2@0RD,<!6;*%I`%`
M!0`E`!0`4`%`"4`+0`4`%`!0`4`&:`$H`*`"@`H`*`"@!^*!BT`%`!0`&@!*
M`$H`,4`*!0`[%(!:`#F@`P*`#/I0`8-`"X`H`,T`)F@`H`*`#%`"\"@!,^@H
M`7F@!.*`#/H*`$)'<T`(7'8?G3$,+$T`%`!B@`H`,T`%`!0`4`**UCL2PIB&
M4ACATK-[C0M(8E`!0`4`)0`4`+B@`H`*`"@`S0`F:`"@`H`*`"@`H`*`"@!*
M`):!BT`)0`E`!0`G6@!P7UH`7`%(!?I0`8H`/I0`8)H`7`H`,T`)F@`H`*`#
M%`"\4`)GT%`!@GK0`<"@`R>U`"$XZF@!"X[#\Z8AI8GO0`E`!0`8H`6@!*`"
M@`H`*`%Q0`4`&<5I'8EA5"&TABCI42W&@J1A0`E`!B@!:`"@`H`*`$S0`9H`
M*`"@`H`*`"@`H`2@`H`*8"T@)*!A0`4`&TFD`H4?6@!?I0`8]:`#@4`+R:`#
M'K0`9H`3-`"4`&*`%Q0`O`H`3/I0`8]30`<4`&?04`!]S0`W>.PS3`0L3WH$
M-S0`4`&*`"@`H`*`"@`H`,4`+B@`H`*`"@!#5Q$Q*H04``J)#05(Q<4`%`!0
M`4`&:`$S0`4`)0`M`!0`4`)0`4`%`!0`4`+B@`H`*`)<&@88'>D`OT%`!@T`
M'`]Z`%YH`3'J:`%X%`"9H`2@`Q0`N*`%X%`"9]*`#![T`'`H`,F@`^IH`;O`
MZ<T`(7)]J8AM`!0`4`&*`%H`2@`H`*`"@`Q0`M`!0`4`%`"9H`*`$/2JB)B5
M8@H`45,AH6H&%`!F@!,T`%`!0`4`%`!0`E`!0`4`%`!0`N*8!2`*`%Q0`4`%
M`$N#2&&!]:`#/I0`8-`"\"@!,T`%`!0`8H`7@4`&?2@!.>]`!Q0`9H`/J:`&
MEU'O0`A<GIQ3$-^M`!0`4`&*`#%`!0`4`%`!0`8H`7%`!0`4`%`"9H`,T`%`
M"4`%`!51W$Q*L04`**F6P(7-04)0`4`%`!0`4`)0`4`%`!0`4`+BF`4@"@!:
M`"@`H`*`"@`H`EP>](8N!0`F:`$R:8"\T@#%`!P*`%SZ"@!,>IH`.*`#/I0`
M8H`0LHH`:9">@I@-.3U-`@H`*`"@`Q0`M`"9H`*`"@`H`,4`+0`4`%`"4`&:
M`"@!*`"@`H`6@`H`*I;B8VK$%`"TGL""LR@H`*`$H`*`"@`H`*8"XI`%`!0`
MM`!0`4`%`!0`4`%`!0`F:`)LT#$P:`%`I`+P*`$S[4`&#W-`!Q]:`#)-`!0`
MA('6@!ID]*8#22>]`@Q0`4`%`!B@`Q0`M`"4`%`!0`8H`7%`!0`4`%`"9H`*
M`$H`*`"@`H`6@`H`*`"@`[TUN`VM"0H`*EM`D%04%`!0`4P"@!<4`%`!2`6@
M`H`*`"@`H`*`"@`H`3-`!F@`H`*`)^!2&)D]J`#'J:`#([<T`&30`4`(2!0`
MTOZ4P&EB:!!B@`H`*`"@`Q0`M`"9H`*`"@`H`,4`+0`4`%`"4`%`!0`4`)0`
M4`%`"T`%`!0`4`)F@`H`*``U3D*PE(84@"F`4`+B@`H`*0!0`M`!0`4`%`!0
M`4`%`!F@!,T`%`!0`8H`6@`H`ER/K2&&2:`"@`)Q0`TO^-,!I8F@0V@!<4`%
M`!0`8H`*`"@`H`*`"@`Q0`N*`"@`H`*`$H`*`"@`S0`E`!0`M`!0`4`%`!F@
M!,T`%`"4`%`!0`4P"@!<4`&*0!0`4`+0`4`%`!0`4`%`!0`9H`3-`!0`4`%`
M"XH`*`"@`S0`F:`)J0QI8?6F`TN?I0(3.:`"@`H`*`"@`Q0`M`"4`%`!0`4`
M&*`%H`*`"@!*`"@`H`*`#-`"4`%`"T`%`!0`4`)F@`H`*`"@!*`"F`4`+0`8
MH`6@`I`%`!0`4`%`!0`4`%`!0`F:`#F@`Q0`4`+B@`H`*`"@!,T`%`!B@!:`
M`G-`!0`4`%`"4`+B@`Q0`M`"4`&:`"@`Q0`N*`"@`H`*`$H`*`"@`H`2@`H`
M*`%Q0`4`%`!F@!*`"@`H`2@`H`6F`4`&*`"@!:0!0`4`%`!0`4`%`!0`4`)F
M@`YH`,4`%`"T`%`!0`4`&:`$H`,4`+B@`S0`F:`'+&[_`'5)]Z`$H`*`"@`Q
M0`M`!0`E`!0`4`&*`%H`*`"@!*`"@`H`*`"@!*`"@`Q0`N*`"@`S0`F:`"@!
M*`"@`H`*8"T`%`!0`M(`H`*`"@`H`*`"@`H`*`#-`"9H`*`"@!:`"@`H`*`#
M-`!F@`H`,4`%`!F@`56<_*":`)TM2?OMCV%.PKDRP1K_``Y^M,5R2@#.Q4E!
MB@!:`$H`*`"@`Q0`N*`"@`H`2@`H`*`"@`H`2@`H`*`%Q0`4`%`!0`E`!0`4
M`)0`4`%,!:`"@`H`6D`4`%`!0`4`%`!0`4`&:`$S0`4`%`!0`M`!0`4`%`!F
M@`H`,4`%`!F@``9C@`GZ4`2K;.?O87]:=A7)TMT7J-Q]Z+!<D'`P*8A:`"@`
MH`SZDH2@`H`*`%Q0`4`%`!0`E`!0`4`%`!0`E`!0`8H`7%`!0`4`%`"4`%`!
M0`E`!3`7%`!0`4`+2`*`"@`H`*`"@`H`*`"@!,T`%`!0`4`+0`4`%`!0`9H`
M*`#%`!0`9H`.2<"@"1+=VY/RCWIV%<F6V0?>RU%@N3``#`&![4Q"T`%`!0`4
M`%`!0!G5)04`+B@`H`*`"@!*`"@`H`*`$H`*`"@`Q0`M`!0`4`)0`9H`2@`H
M`*`%Q0`4P"@!:0!0`4`%`!0`4`%`!0`4`)F@`H`*`#%`"T`%`!0`4`&:`"@`
MH`*`"@!,T`2+!(W\./K3$3I;*/OG)].U%@N2JJJ/E`%,0Z@`H`*`"@`H`*`"
M@`H`*`,^I*"@`H`*`$H`*`"@!*`"@`H`*`%Q0`4`%`!0`E`!0`E`!0`M,`Q0
M`4@%H`*`"@`H`*`"@`H`*`"@!,T`&:`"@`Q0`N*`"@`H`*`#-`"4`+0`4`%`
M!F@!R1._0<>M,"9;7^^WX"BPKDZHJ?=4"F(=0`4`%`!0`4`%`!0`4`%`!0`4
M`%`&?4E"4`%`!0`4`)0`4`%`!B@!:`"@`H`*`$H`,T`)0`M`!BF`4`+2`*`"
M@`H`*`"@`H`*`"@!*`#-`!0`8H`7%`!0`4`%`!F@`S0`E`"XH`*`#-`"JCO]
MU2:`)DM3U<X]A3L*Y,D*)T7GU-,1)0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4
M`%`&=4E!0`4`)0`4`%`"XH`*`"@`H`*`$S0`4`%`!3`*`%H`*0!0`4`%`!0`
M4`%`!0`E`!F@`H`,4`%`"T`%`!0`4`&:`$H`7%`!0`4`*JLYPH)H`E6V8_>(
M'ZT["N3)!&O;/UIBN2T`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0!
MG5)04`)0`8H`7%`!0`4`%`"9H`,T`%`!0`4P"@!:0!0`4`%`!0`4`%`!0`E`
M!0`4`%`!B@!:`"@`H`*`#-`!0`8H`,4`%``,DX`R:`)4MW;[WRBG85R9+=%Z
M_,?>BP7)0`!@#`]J8A:`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
M*`"@#-J2@Q0`M`!0`4`%`"9H`*`#%`!3`*`%I`%`!0`4`%`!0`4`%`"9H`*`
M"@`H`*`%H`*`"@`H`*`#-`"4`+B@`H`.IP.30!(L$C=L#WIV%<F2V0?>.[]*
M+!<F`"C``'TIB%H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`,ZI*"@`H`3-`!F@`H`,4`%,!:0!0`4`%`!0`4`%`"4`&:`"@!*`%H
M`,4`+0`4`%`!0`4`&:`$H`7%`!0`9H`>D4C]!@>II@3):@<NQ/L*+"N3*BI]
MU0*8AU`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4
M`%`!0!FU)04`%`!0`4P%H`*0!0`4`%`!0`4`)F@`H`*`$H`*`%Q0`8H`6@`H
M`*`"@`H`2@`Q0`N*`"@!RQN_W5)'K3`F6U/\;?@*+"N3+&B?=4#WIB'T`%`!
M0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`
M%`&;4E!0`M`!0`4`%`!0`4`)0`9H`*`"@!*`"@!:`#%`"T`%`!0`4`%`!F@!
M*`%Q0`4`*JLYPH)I@3+;,?OL!["BPKDR0HG(&3ZFF*Y)0`4`%`!0`4`%`!0`
M4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`9U
M24)0`4`%`!0`4`%`!0`4`)0`4`+B@`H`,4`+0`4`%`!0`9H`2@!<4`%`"@$G
M"@D^U`$JVSG[V%'YT["N3+;QKVW'WIV"Y(!@8%`A:`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`,
MVI*"@`H`*`"@`H`*`$H`6@`H`,4`+0`4`%`!0`9H`2@`Q0`N*`#O@=:`)5MW
M;K\H]Z=A7)DMD7ELL?THL%R4``8`P/:F(6@`H`*`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@#
M-J2@H`*`"@`H`*`"@`H`7%`!0`4`%`!F@!*`#%`"XH`*`)%AD;^''UXIBN3+
M;*/O$M^E%@N2JJJ/E`%,0Z@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
K`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@#_V0`H
`

#End
