#Version 7
#BeginDescription
Version 1.6   12.12.2005   hs@hsbCAD.de
   - bugFix Listenausgabe
Version 1.5   10.08.2005   hs@hsbcad.de
   -Zusammenfassen des String sArType aus sArType1 und sArType2
   -Layerzuordnung verbessert
Version 1.4   04.08.2005   hs@hsbcad.de
   -Zuganker mit in die Verbindungsmittel mit aufgenommen
   -Beschriftung eingefügt
Version 1.3   27.07.2005   hs@hsbcad.de
   -improvements
Version 1.2   26.07.2005   hs@hsbcad.de
   -Verbesserung
Version 1.1   21.07.2005   hs@hsbcad.de
   -beim Einfügen des TSL's einen Dialog anzeigen
Version 1.0   19.07.2005   hs@hsbcad.de
   -BMF-Winkelverbinder lassen sich bei einer T-Verbindung einfügen
   -es besteht die Auswahl zwischen dem Einfügen eines oder zweier Winkelverbinder
#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 1
#DxaOut 1
#ImplInsert 1
#MajorVersion 1
#MinorVersion 6
#KeyWords 
#BeginContents
// Version 1.3 improvements 27.07.2005: setCompareKey
// Version 1.2 Vereifachung des Switch-Vorgangs bei // switch dH und dL

// basics and props
	Unit (1, "mm");
	
	// cut long text for dp
	String sArType1[] = {T("Z1"), T("Z2"), T("BMF-Winkel"), T("BMF-Zuganker"), T("BMF-Zuganker"), T("BMF-Zuganker"),
				T("BMF-Zuganker"), T("BMF-Zuganker"), T("SIMPSON-Zuganker"), T("SIMPSON-Zuganker"), T("SIMPSON-Zuganker"),
				T("BMF-Zuganker"), T("BMF-Winkelverbinder"), T("BMF-Winkelverbinder"), T("BMF-Winkelverbinder"), 
				T("BMF-Winkelverbinder"), T("BMF-Winkelverbinder"), T("BMF-Winkelverbinder"), T("BMF-Winkelverbinder"),
				T("BMF-Winkelverbinder"), T("BMF-Winkelverbinder"), T("BMF-Winkelverbinder"), T("BMF-Winkelverbinder"), 
				T("BMF-Winkelverbinder"), T("BMF-Winkelverbinder"), T("BMF-Winkelverbinder"), T("BMF-Winkelverbinder"), 
				T("BMF-Winkelverbinder"), T("BMF-Winkelverbinder"), T("BMF-Winkelverbinder"),
				T("BMF-Winkelverbinder"), T("BMF-Winkelverbinder"), T("BMF-Winkelverbinder"), T("BMF-Winkelverbinder"), 
				T("BMF-Winkelverbinder"), T("BMF-Winkelverbinder"), T("BMF-Winkelverbinder"), T("BMF-Winkelverbinder"),
				T("BMF-Winkelverbinder"), T("BMF-Winkelverbinder"), T("BMF-Winkelverbinder"), T("BMF-Winkelverbinder"),
				T("BMF-Winkelverbinder"), T("BMF-Winkelverbinder"), T("BMF-Winkelverbinder"), T("BMF-Winkelverbinder"),
				T("BMF-Winkelverbinder"), T("BMF-Winkelverbinder"), T("BMF-Winkelverbinder"), T("BMF-Winkelverbinder")};
	
	String sArType2[] = {T(""), T(""), T("90 R"), T("340-M12"), T("400-M16"), T("420-M16"), T("420-M20"), T("480-M20"),
				T("LTT20Br"), T("HTT16"), T("HTT22"), T("2-teilig"), T("90 mit Rippe"), T("90 ohne Rippe"), T("105 mit Rippe"), 
				T("105 ohne Rippe"), T("6090"), T("6191"), T("6292"), T("6035"), T("70 mit Rippe"), T("70 ohne Rippe"), 
				T("40390"), T("40312"), T("40412"), T("40314"), T("40414"), T("90265"), T("90x35x2,5x40"), T("160x50x3,0x40"), 
				T("190x50x2,0x40"), T("290x50x2,0x40"), T("35350"), T("55365"), T("60280"), T("90x48x3,0x48"), T("90x48x3,0x76"), 
				T("90x48x3,0x116"), T("99416"), T("80416"), T("60416"), T("40x40x2,0x25"), T("60x60x2,0x25"), T("40x60x2,0x25"), 
				T("KR 95"), T("KR 95 L"), T("KR 135"), T("KR 135 L"), T("KR 285"), T("KR 285 L")};

	String sArType[sArType2.length()];
	for (int i = 0; i < sArType2.length(); i++)
		sArType[i] = (sArType2[i] + " " + sArType1[i]);
	double dH[] = {U(340), U(400), U(420), U(420), U(480) , U(502), U(406), U(559),
			U(400), U(90), U(88), U(105), U(103), U(90), U(90), U(90), U(35), U(70), U(70), U(93), U(119), U(120), U(141), U(142), 
			U(67), U(90), U(160), U(192), U(292), U(50), U(65), U(83), U(90), U(90), U(90), U(160), U(160), U(160), U(42), U(62), U(62),
			U(95), U(95), U(135), U(135), U(285), U(285)};
	double dL[] = {U(182), U(123), U(222), U(102), U(123), U(70), U(61), U(61),U(220), U(90), 
			U(88), U(105), U(103), U(60), U(60), U(60), U(60), U(70), U(70), U(93), U(91), U(92), U(91), U(92),
			U(67), U(35), U(50), U(52), U(52), U(50), U(65), U(62), U(48), U(48), U(48), U(80), U(80), U(80), U(42), 
			U(62), U(42), U(85), U(85), U(85), U(85), U(85), U(85)};
	double dW[] = {U(40), U(40), U(60), U(60), U(60), U(51), U(70), U(70), U(64), U(65), U(65), U(90), 
			U(90), U(60), U(60), U(60), U(60), U(55), U(55), U(40), U(40), U(40), U(40), U(40), U(90), U(40), U(40), U(40), 
			U(40), U(35), U(55), U(40), U(48), U(76), U(116), U(100), U(80), U(60), U(25), U(25), U(25),
			U(65), U(65), U(65), U(65), U(65), U(65)};
	double dT[] = {U(2), U(3), U(2), U(2), U(2), U(2.7), U(3), U(3), U(2), U(2.5), U(2.5), U(3), U(3),
		 	U(2.5), U(2.5), U(2.5), U(2.5), U(2), U(2), U(3), U(3), U(4), U(3), U(4), U(2), U(2.5), U(3), U(2), U(2), U(2.5),
			U(3), U(2), U(3), U(3), U(3), U(4), U(4), U(4), U(2), U(2), U(2), U(4), U(4), U(4), U(4), U(4), U(4)};
	
	PropString sType (0, sArType, T("Type"), 8);
	
	String sArNum[] = {T("One"), T("Two")};
	PropString sNum (1, sArNum, T("Number"), 1);
	
	String sArSide[] = {T("Left"), T("Right")};
	PropString sSide (2, sArSide, T("Side"));
	
	String sArSwitch[] = {T("Yes"), T("No")};
	PropString sSwitch (3, sArSwitch, T("Switch"), 1);
	PropString sArt1 (5, "", T("Article"));
	PropString sMat1 (6, "Stahl, feuerverzinkt", T("Material"));
	PropString sNotes1 (7, "", T("Metalpart Notes"));
	
	PropString sMod2 (8, "Kammnagel", T("Nail") + " " + T("Model"));
	PropString sArt2 (9, "", T("Article"));
	PropString sMat2 (10, "Stahl, verzinkt", T("Material"));
	PropDouble dDia (11, U(4), T("Nail") + " " + T("Diameter"));
	PropDouble dLen2 (12, U(40), T("Nail Length"));
	PropInt nNail1 (0, 0, T("Number of Nails per Hardware"));
	PropString sNotes2 (13, "", T("Metalpart Notes"));
	
	String sArLayer [] = { T("I-Layer"), T("J-Layer"), T("T-Layer"), T("Z-Layer")};
	PropString sLayer (14, sArLayer, T("Layer"));
	
	String sArNY [] = { T("No"), T("Yes") };
	PropString sNY (15, sArNY, T("Show description"),1);	
	PropDouble dxFlag (13, U(200), T("X-flag"));
	PropDouble dyFlag (14, U(300), T("Y-flag"));
	
	PropString sDimStyle (4, _DimStyles, T("Dimstyle"));
	PropInt nColor (1,171,T("Color"));
	
	int nNail = nNail1;;
	int nBd = 1;

// _bOnInsert
	if(_bOnInsert){
		_Beam.append(getBeam());
		_Beam.append(getBeam());
		showDialog();
		return;
	}
		
// right angle
	if(_X0.angleTo(_X1) != 90){
		reportNotice("\n " + T("No") + " " + T("Right") + " " + T("Angle"));
		eraseInstance();
		return;
	}

// restrict color index
	if (nColor > 255 || nColor < -1) nColor.set(171);

// _bOnInsert
	if(_bOnInsert){
		showDialog();
		return;
	}
		
// Beams
	Beam bm0, bm1; 			
	bm0 = _Beam[0]; 			
	bm1 = _Beam[1]; 
	
	double dWidth = bm0.dD(_X1);
	
// stretch beam to other
	Cut ct (_Pt0, _Z1);
	bm0.addTool(ct, 1);
	
// find type
		int f; 							 				
		for(int i = 0; i < sArType.length(); i++){				
			if (sType == sArType[i]) 			
				f = i;
		}

// coordSys
	Point3d pt0;
	Vector3d vx,vy,vz;
	CoordSys cs(_Pt0, vx, vy, vz); 

	vx = _X0;
	vy = _YW;
	vz = vx.crossProduct(vy);
		
// get Grippoints
	if (_PtG.length() < 1)
		_PtG.append(_Pt0 + dxFlag * vx + dyFlag * vy);
	
	dxFlag.setReadOnly(TRUE);
	dyFlag.setReadOnly(TRUE);

//Flag
	double dF;
	if(dxFlag == 0 && dyFlag == 0)
		dF = U(1);
	PLine pl1 (_Pt0, _PtG[0]);

// switch dH and dW
	double dLenWid[] = {dH[f], dL[f]};
	if(sSwitch == sArSwitch[1])
		dLenWid.swap(0, 1);
	
// one hardware
	if(sNum == sArNum[0]){	
		// body
		Point3d pt1 = _Pt0 + dWidth/2 * -_X1;
		Body bd1;
		if(sSide == sArSide[1]){
			pt1 = _Pt0 + dWidth/2 * _X1;
			Body bd11 (pt1, -_Z1, _Y1, _X1, dLenWid[1], dW[f], dT[f], 1, 0, 1); 
			Body bd12 (pt1, _X1, _Y1, -_X0, dLenWid[0], dW[f], dT[f], 1, 0, 1);
			bd1 = bd11 + bd12;
		}
		else{
			Body bd11 (_Pt0 + dWidth/2 * -_X1, -_Z1, _Y1, -_X1, dLenWid[1], dW[f], dT[f], 1, 0, 1); 
			Body bd12 (_Pt0 + dWidth/2 * -_X1, -_X1, _Y1, -_X0, dLenWid[0], dW[f], dT[f], 1, 0, 1);
			bd1 = bd11 + bd12;
		}
		
		// display
		Display dp(nColor);
		dp.dimStyle(sDimStyle);
		dp.draw(bd1);
	}
	
// two hardwares
	Body bd1;
	Body bd2;
	if(sNum == sArNum[1]){
		// body
		Body bd11 (_Pt0 + dWidth/2 * _X1, -_Z1, _Y1, _X1, dLenWid[1], dW[f], dT[f], 1, 0, 1); 
		Body bd12 (_Pt0 + dWidth/2 * _X1, _X1, _Y1, -_X0, dLenWid[0], dW[f], dT[f], 1, 0, 1);
		bd1 = bd11 + bd12;
		Body bd21 (_Pt0 + dWidth/2 * -_X1, -_Z1, _Y1, -_X1, dLenWid[1], dW[f], dT[f], 1, 0, 1); 
		Body bd22 (_Pt0 + dWidth/2 * -_X1, -_X1, _Y1, -_X0, dLenWid[0], dW[f], dT[f], 1, 0, 1);
		bd2 = bd21 + bd22;
		
		// lock sSide
		int i = 1;
		sSide.setReadOnly(i);
		
		// numbers
		nNail = nNail1 * 2;
		nBd = nBd * 2;
	}

// visualize CoordSys
	//_X0.vis(_Pt0, 1);
	//_Y0.vis(_Pt0, 150);
	//_Z0.vis(_Pt0, 3);
	_X1.vis(_Pt0, 1);
	_Y1.vis(_Pt0, 150);
	_Z1.vis(_Pt0, 3);

// model + hardware
	String sModel =sType + ": " + dLenWid[0] + " x " + dLenWid[1] + " x " + dW[f] + " x " + dT[f];
	model(sModel);
	material(sMat1);
	
	if (nNail > 0)
		Hardware( T("Nail"), sMod2, sArt2, dLen2, dDia, nNail, sMat2, sNotes2);	

// setCompareKey
	setCompareKey(String(dH[f]) + String(dL[f]) + String(dW[f]) + String(dT[f]) + sType + sArt1 + sMat1 + sNotes1
					+ sMod2 + sArt2 + sMat2 + String(dDia) + String(dLen2) + nNail + sNotes2);

// assign to layer
	Display dp(nColor);
	Display dpBd(nColor);
	dp.dimStyle(sDimStyle);
	
	// get el of bm
	Element el;
	el = _Beam0.element();
	
	if (el.bIsValid()){
		if (sLayer == sArLayer[0]){
			dp.elemZone(el, 0, 'I'); 
			dpBd.elemZone(el, 0, 'I'); 
		}
		else if (sLayer == sArLayer[1]){
			dp.elemZone(el, 0, 'J');
			dpBd.elemZone(el, 0, 'J'); 
		}		
		else if (sLayer == sArLayer[2]){
			dp.elemZone(el, 0, 'T');
			dpBd.elemZone(el, 0, 'T'); 
		}			
		else if (sLayer == sArLayer[3]){
			dp.elemZone(el, 0, 'Z');
			dpBd.elemZone(el, 0, 'Z'); 
		}
		// assigning
		assignToElementGroup(el, TRUE, 0, 'E');
	}

// show text
	dp.addViewDirection(_ZW);
	int nChange = 1;
	if (sNY == sArNY[1]){
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
	_XW.vis(_PtG[0], 1);

// show body
	dpBd.draw(bd1);
	dpBd.draw(bd2);	

		
		
		
	
	
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
M!0`A`((/0T`4"""0>HJ2@H`*`%[4`)VH`;3`!0`4@"@!>]`"4`%`!0`HH`3O
M0`&F`4@"@`%`"F@`[4``."".HI@:`((!'0TR1:`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`*4PQ*P_&DRD,I`':@!10`E`"=Z8"=Z`%I`(*`%[T`!H`*`$H`44`!ZT`%
M,!!2`*``4`+0`"@!*`+T)S"I/IBJ))*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
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
E`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`#_V04`
`

#End
