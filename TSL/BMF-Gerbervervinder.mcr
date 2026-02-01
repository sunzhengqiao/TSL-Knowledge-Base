#Version 7
#BeginDescription
Version 1.3   30.11.2005   hs@hsbcad.de
   -Verbinder und Schnitt  können nachträglich verschoben werden
Version 1.2   28.10.2005   hs@hsbcad.de
   -es können nur Typen ausgewählt werden, die zu den entsprechenden Querschnitt passen
Version 1.1   27.10.2005   hs@hsbcad.de
   -tsl ist auf einen Stab mit Einfügepunkt oder zwei Stäben ohne Einfügepunkt anwendbar
   -TSL ist entlang der x-Achse verschiebbar
   -Ausrichtung des Gerberverbinders ist in Z- bzw in Y-Richtung anwendbar
Version 1.0   06.10.2005   hs@hsbcad.de
   -fügt einen BMF-Gerberverbinder als Längsverbindung zweier Balken ein

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
// set Props	
	U (1, "mm");
	
	String sArType1[17];
	for (int i = 0; i < 8; i++)
		sArType1[i] = (T("BMF-Gerberverbinder Typ B"));
	for (int i = 8; i < 17; i++)
		sArType1[i] = (T("BMF-Gerberverbinder Typ W"));
							
	String sArType2[] = {"B 125","B 140","B 150","B 160","B 175","B 180","B 200","B 220",
								"W 90","W 120","W 140","W 160","W 180","W 200","W 220","W 240","W 260"};

	double dLength[] = {U(180),U(180),U(180),U(180),U(180),U(180),U(180),U(180),U(180),U(180),
							  U(180),U(180),U(180),U(180),U(180),U(180),U(180)};
							
	double dHeight[] = {U(128.5),U(140),U(154),U(160),U(179),U(180),U(200),U(220),U(90),U(120),
							  U(140),U(160),U(180),U(200),U(220),U(240),U(260)};
							
	double dThick[] = {U(2.0),U(2.0),U(2.0),U(2.0),U(2.0),U(2.0),U(2.0),U(2.0), U(2.0), U(2.0),
							 U(2.0),U(2.0),U(2.0),U(2.0),U(2.0),U(2.0),U(2.0)};
	
	double dWidth[] = {U(27),U(30),U(28),U(30),U(33),U(33),U(33),U(34),U(20),U(20),
						 U(20),U(20),U(20),U(20),U(20),U(20),U(20)};
	
	double dA[] = {U(28),U(35),U(42),U(45),U(54.5),U(55),U(67.5),U(75),U(0),U(0),
						U(0),U(0),U(0),U(0),U(0),U(0),U(0)}; 
	
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
	
	PropString sSwitch (8, sArNY, T("Switch Connector"), 0);
	
	PropString sDescription (9, sArNY, T("Show description"),1);	
	PropDouble dxFlag (2, U(200), T("X-flag"));
	PropDouble dyFlag (3, U(300), T("Y-flag"));
	
	PropString sDimStyle (10, _DimStyles, T("Dimstyle"));
	PropInt nColor (1,171,T("Color"));
	
	String sArOrient[] = {T("Y-Axis"), T("Z-Axis")};
	PropString sOrient( 11, sArOrient, T("Orientation"),1);
	
	int nBd = 2;
	
// get entity
	if (_bOnInsert){
		PrEntity ssE(T("select one beam"), Beam());
  		if (ssE.go() && _Beam.length()<2)
			_Beam.append(ssE.beamSet());
		_Element.setLength(2);
		Beam bmSplit;
		if (_Beam.length() > 0)
			bmSplit = _Beam[0];

  		PrEntity ssE1(T("select additional beam (optional)"), Beam());
  		if (ssE1.go() )
 			_Beam.append(ssE1.beamSet());	
		
		if (_Beam.length()<2){
			_Pt0 = getPoint(T("Select insertion point")); 
		}
		else{
			_Pt0 = _Beam[0].ptCen() + (_Beam[1].ptCen() - _Beam[0].ptCen()).normal() * _Beam[0].solidLength() * 0.5;
		}
			
		// Split
		if (_Beam.length()<2){
			Beam bmNew;
			bmNew = bmSplit.dbSplit(_Pt0,_Pt0);
			_Map.setEntity("Split", bmSplit);
			_Map.setEntity("New", bmNew);
			_Map.setInt("Two Beams", 1);
		}
		
		// declare standard	
		Beam bm1 = _Beam[0];
		Beam bm2;
	
		if (_Map.hasInt("Two Beams")){
			Entity ent;
			ent = _Map.getEntity("New");
			bm2 = ((Beam)ent);
		}
		else
			bm2 = _Beam[1];
			
		//get _Pt0	
		if (!_Map.hasInt("Two Beams")){
			_Pt0 = bm1.ptCen() + (bm2.ptCen() - bm1.ptCen()).normal() * bm1.solidLength() * 0.5; _Pt0.vis(150);
		}
	
		Line ln (bm1.ptCen(), bm1.vecX());
		_Pt0 = ln.closestPointTo(_Pt0);
	
		//stretch to _Pt0
		Cut ct1 (_Pt0, (bm2.ptCen() - bm1.ptCen()).normal());
		Cut ct2 (_Pt0, -(bm2.ptCen() - bm1.ptCen()).normal());
		bm1.addTool(ct1, 1);
		bm2.addTool(ct2, 1);
		 
		
		// show just relevant HW	
		//Beam bm1 = _Beam[0];
		Vector3d vx, vy, vz;
		vx = bm1.vecX();
		vy = bm1.vecY();
		vz = bm1.vecZ();
		if (vz.dotProduct(_ZW) < 0)
			vz = -vz;
		double dH, dW;
		dH = bm1.dD(vz);
		dW = bm1.dD(vy);
		double dLenWid[] = {dH, dW};
		Vector3d vOrient;
		if(sOrient == sArOrient[0]){
			dLenWid.swap(0, 1);
			vOrient = vz;
			vz = vy;
			vy = vOrient;
		}
		String sArType[0];
		if (dH == 110)
			sArType.append(sArType2[8] + " " + sArType1[8]);
		else if (dH == 125)
			sArType.append(sArType2[0] + " " + sArType1[0]);
		else if (dH == 140){
			sArType.append(sArType2[1] + " " + sArType1[1]);
			sArType.append(sArType2[9] + " " + sArType1[9]);
		}
		else if (dH == 150)
			sArType.append(sArType2[2] + " " + sArType1[2]);
		else if (dH == 160){
			sArType.append(sArType2[3] + " " + sArType1[3]);
			sArType.append(sArType2[10] + " " + sArType1[10]);
		}
		else if (dH == 175)
			sArType.append(sArType2[4] + " " + sArType1[4]);
		else if (dH == 180){
			sArType.append(sArType2[5] + " " + sArType1[5]);
			sArType.append(sArType2[11] + " " + sArType1[11]);
		}
		else if (dH == 200){
			sArType.append(sArType2[6] + " " + sArType1[6]);
			sArType.append(sArType2[12] + " " + sArType1[12]);
		}
		else if (dH == 220){
			sArType.append(sArType2[7] + " " + sArType1[7]);
			sArType.append(sArType2[13] + " " + sArType1[13]);
		}
		else if (dH == 240)
			sArType.append(sArType2[14] + " " + sArType1[14]);
		else if (dH == 260)
			sArType.append(sArType2[15] + " " + sArType1[15]);
		else if (dH == 280)
			sArType.append(sArType2[16] + " " + sArType1[16]);
		else{
			reportError(("\n") + T("The cross Section of the beam has not the right size"));
			return;
		}
		
		PropString sType (0, sArType, T("Connector"));				 
			
		showDialog();
		
		return;
	}

// declare standard	
	Beam bm1 = _Beam[0];
	Beam bm2;
	
	if (_Map.hasInt("Two Beams")){
		Entity ent;
		ent = _Map.getEntity("New");
		bm2 = ((Beam)ent);
	}
	else
		bm2 = _Beam[1];
	
	Vector3d vx, vy, vz;
	vx = bm1.vecX();
	vy = bm1.vecY();
	vz = bm1.vecZ();
	if (vz.dotProduct(_ZW) < 0)
		vz = -vz;
	vx.visualize(bm1.ptCen(),1);
	vy.visualize(bm1.ptCen(),3);
	vz.visualize(bm1.ptCen(),150);

// dirction from Centerpoint bm1 to Centerpoint bm2
	Vector3d vCen;
	
	Vector3d vx2, vy2, vz2;
	vx2 = bm2.vecX();
	vy2 = bm2.vecY();
	vz2 = bm2.vecZ();
	vx2.visualize(bm2.ptCen(),1);
	vy2.visualize(bm2.ptCen(),3);
	vz2.visualize(bm2.ptCen(),150);
		
	vCen = bm2.ptCen() - bm1.ptCen();
	vCen.normalize();
	
	double dH, dW;
	dH = bm1.dD(vz);
	dW = bm1.dD(vy);
	
	String sArType[0];
	
	PropString sType (0, sArType, T("Connector"));

// find type
	int f; 			
		if (dH == 110){
			sArType.append(sArType2[8] + " " + sArType1[8]);
			f = 8;
		}
		else if (dH == 125){
			sArType.append(sArType2[0] + " " + sArType1[0]);
			f = 0;
		}
		else if (dH == 140){
			sArType.append(sArType2[1] + " " + sArType1[1]);
			sArType.append(sArType2[9] + " " + sArType1[9]);
			for(int i = 0; i < sArType.length(); i++){				
				if (sType == sArType[i]){
				f = i;
				if (f == 1) 
					f = 6;
				else 
					f = 9;
				}
			} 
		}
		else if (dH == 150){
			sArType.append(sArType2[2] + " " + sArType1[2]);
			f = 2;
		}
		else if (dH == 160){
			sArType.append(sArType2[3] + " " + sArType1[3]);
			sArType.append(sArType2[10] + " " + sArType1[10]);
			for(int i = 0; i < sArType.length(); i++){				
				if (sType == sArType[i]){
				f = i;
				if (f == 3) 
					f = 6;
				else 
					f = 10;
				}
			}
		}
		else if (dH == 175){
			sArType.append(sArType2[4] + " " + sArType1[4]);
			f = 4;
		}
		else if (dH == 180){
			sArType.append(sArType2[5] + " " + sArType1[5]);
			sArType.append(sArType2[11] + " " + sArType1[11]);
			for(int i = 0; i < sArType.length(); i++){				
				if (sType == sArType[i]){
					f = i;
					if (f == 5) 
						f = 6;
					else 
						f = 11;
					}
			}
		}
		else if (dH == 200){
			sArType.append(sArType2[6] + " " + sArType1[6]);
			sArType.append(sArType2[12] + " " + sArType1[12]);
			for(int i = 0; i < sArType.length(); i++){				
				if (sType == sArType[i]){
					f = i;
					if (f == 0) 
						f = 6;
					else 
						f = 12;
					}
			}
		}
		else if (dH == 220){
			sArType.append(sArType2[7] + " " + sArType1[7]);
			sArType.append(sArType2[13] + " " + sArType1[13]);
			for(int i = 0; i < sArType.length(); i++){				
				if (sType == sArType[i]){
					f = i;
					if (f == 7) 
						f = 6;
					else 
						f = 13;
					}
			}
		}
		else if (dH == 240){
			sArType.append(sArType2[14] + " " + sArType1[14]);
			f = 14;	
		}
		else if (dH == 260){
			sArType.append(sArType2[15] + " " + sArType1[15]);
			f = 15;	
		}
		else if (dH == 280){
			sArType.append(sArType2[16] + " " + sArType1[16]);
			f = 16;	
		}
		else{
			reportError(("\n") + T("The cross Section of the beam has not the right size"));
			return;
		} 

// Codirectional	
	if ((bm1.vecY().dotProduct(bm2.ptCen() - bm1.ptCen()) != 0)){
		reportMessage(("\n") + T("Beams are not codirectional"));
		eraseInstance();
		return; 
	} 
	
// switch dH and dW, vz und vy
	double dLenWid[] = {dH, dW};
	Vector3d vOrient;
	if(sOrient == sArOrient[0]){
		dLenWid.swap(0, 1);
		vOrient = vz;
		vz = vy;
		vy = vOrient;
	}

//get _Pt0	
	/*if (!_Map.hasInt("Two Beams")){
		_Pt0 = bm1.ptCen() + vCen * bm1.solidLength() * 0.5; _Pt0.vis(150);
	}*/
	
	Line ln (bm1.ptCen(), bm1.vecX());
	_Pt0 = ln.closestPointTo(_Pt0);

//stretch to _Pt0
	Cut ct1 (_Pt0, vCen);
	Cut ct2 (_Pt0, -vCen);
	bm1.addTool(ct1, 1);
	bm2.addTool(ct2, 1);
	
			
	CoordSys csMirror, csSwitch;
	Plane pn1(bm1.ptCen(), vy);
	Plane pn2(_Pt0, vx);
	csMirror.setToMirroring(pn1);
	csSwitch.setToMirroring(pn2);

// Display	
	Display dpbd(nColor);

// Insertion Point
	/*if (_PtG.length() < 1)
		_PtG.append(bm1.ptCen() + ((_Pt0 - bm1.ptCen()).dotProduct(vx) * vx));
	_PtG[0].vis(3);
	_PtG[0]=bm1.ptCen() + ((_PtG[0] - bm1.ptCen()).dotProduct(vx) * vx);			*/										

// Body
	if(f < 8){
		Body bd1 (_Pt0 + dLenWid[1]/2 * vy + ((dHeight[f] - 2 * dA[f])/2 + dA[f]/2) * vz,
					 -vx, vz, vy, dLength[f]/2, dA[f], dThick[f], 1, 0, 1);
		Body bd2 (_Pt0 + dLenWid[1]/2 * vy - ((dHeight[f] - 2 * dA[f])/2 + dA[f]/2) * vz,
					 -vx, vz, vy, dLength[f]/2, dA[f], dThick[f], -1, 0, 1);
	
		// bd3
		Point3d pt1, pt2;
		pt1 = _Pt0 + dLenWid[1]/2 * vy + (dHeight[f] - 2 * dA[f])/2 * vz - dLength[f] / 4 * vx;
		pt2 = _Pt0 + dLenWid[1]/2 * vy - (dHeight[f] - 2 * dA[f])/2 * vz + dLength[f] / 4 * vx;
		Vector3d v1;
		v1 = (pt1 - pt2).normal();
		double dAng  = vz.angleTo(v1);
		double dTan = tan(dAng);
		double dSin = sin(dAng);
		double dCos = sin(90 - dAng);
		double dDis = (dLength[f]/4) * dCos;	
		
		Body bd3 (_Pt0 + dLenWid[1]/2 * vy, v1, v1.crossProduct(vy), vy, (dLength[f]/4)/dSin * 4, dDis * 2, dThick[f], 0,0,1);
	
		Body bd11 (_Pt0 + dLenWid[1]/2 * vy + (((dHeight[f] - 2 * dA[f])/2 + dA[f]/2)+dA[f]*2) * vz,
					 -vx, vz, vy, dLength[f]*2, dA[f]*5, dThick[f], 0, 0, 1);
		Body bd21 (_Pt0 + dLenWid[1]/2 * vy - (((dHeight[f] - 2 * dA[f])/2 + dA[f]/2)+dA[f]*2) * vz,
					 -vx, vz, vy, dLength[f]*2, dA[f]*5, dThick[f], 0, 0, 1);
		bd3 = bd3 - bd11;
		bd3 = bd3 - bd21;
	
		Body bd4 (_Pt0 + (dLenWid[1]/2 + dThick[f]) * vy + dHeight[f]/2 * vz,
					 -vx, vy, vz, dLength[f]/2, dWidth[f], dThick[f], 1, -1, 1);
		Body bd5 (_Pt0 + (dLenWid[1]/2 + dThick[f]) * vy - (dHeight[f]/2 + dThick[f]) * vz,
					 vx, vy, vz, dLength[f]/2, dWidth[f], dThick[f], 1, -1, 1);
	
		Body bd, bd10;
		bd = bd1 + bd2 + bd3 + bd4 + bd5;
		bd10 = bd;
	
		bd10.transformBy(csMirror);
		bd = bd + bd10;
		
		// switch purlin anchor
		if (sSwitch == sArNY[1]){
			bd.transformBy(csSwitch);
		}
		
		// show body
		dpbd.draw(bd);
	}
	else if (f > 7){
		Body bd1 (_Pt0 + dLenWid[1]/2 * vy - dLenWid[0]/2 * vz, vx, vz, vy, dLength[f], dHeight[f], dThick[f], 0, 1, 1);
		Body bd2 (_Pt0 + (dLenWid[1]/2 + dThick[f]) * vy - (dLenWid[0]/2 + dThick[f]) * vz,
					 vx, vy, vz, dLength[f], dWidth[f], dThick[f], 0, -1, 1);
		
		Body bd, bd10;
		bd = bd1 + bd2;
		bd10 = bd;
		
		bd10.transformBy(csMirror);
		bd = bd + bd10;
		
		// switch purlin anchor
		if (sSwitch == sArNY[1]){
			bd.transformBy(csSwitch);
		}
		
		// show body
		dpbd.draw(bd);
	}

// get Grippoints
	if (_PtG.length() < 1){
		_PtG.setLength(1);
		_PtG[0] = (_Pt0 + dxFlag * _XW + dyFlag * _YW);
	}
	
	dxFlag.setReadOnly(TRUE);
	dyFlag.setReadOnly(TRUE);

//Flag
	double dF;
	if(dxFlag == 0 && dyFlag == 0)
		dF = U(1);
	PLine pl1 (_Pt0, _PtG[0]);
	
// display
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
	
// hardware
	Hardware( "Gerberverbinder", sArType1[f] + " - " + sArType2[f], sArt1, dLength[f], 0, nBd, sMat1, sNotes1);
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
M`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`UF5>I`H`89A_
M"I-*X[##(Y[X^E*X[#*0PS0!;JR`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@!K.J]31<+##-_=4_C2N58C:1CU;'TI7'9#
M.*0"YH`2@`H`.:`+E60%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4
M`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!
M0`4`%`!0`4`-,BCJU*X[$9F_NK^=*X[#&=CU:@=AN12`3)-`!CUH`.*`#DT`
M&/6@`XH`7DT`6ZL@*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`89%'?/TI7'889O[H_.E<=B-F+=6-(8F:`$YH`,4`'%`!S0`8]:`#([4`+R:
M`#`[T`&:`$S0!<JR`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@!AD4=\
M_2E<=AC3'L,4KCL1LQ/4YI#$S0`G-`!B@`^@H`7F@!.![T`&?04`+S0`8%`!
MF@!,T`%`!0`8H`N59`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`
M4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`"=*`&F51[_`$I7
M'8C,S'I@4KCL,+$]3FD,3-`"<T`'XT`'TH`7!H`3CZT`&?2@`P3UH`7`%`!F
M@!.30`4`'TH`,4`+P.M`"9]*`#DT`7*L@*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`0L%ZD"BP$9
MG4=`35<K`C:9CTXJE%"!)64\\CWH<4P'&9CTP*R=T6DB,L3U)/UJ1B9H`*`#
M\:`#Z"@`QZF@!>*`#F@`Q[T`&`*`#/I0`G-`!0`?2@`Q0`O`H`3/H*`#DT`&
M`*`%SZ"@!.:`+E60%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`
M!0`4`%`!0`4`%`!0`4`%`!0`4`-9E7J0*=K@,:=1T!-/E`C:5SWQ]*KE0AE4
M`E`!0`4`+2:N`5E*-BTP^@J!ACU-`"\4`'-`!B@`X%`!F@!.:`#B@`^@H`,4
M`+@4`&:`$Y-`!@#K0`N?04`)]:`#B@`S0`8H`N59`4`%`!0`4`%`!0`4`%`!
M0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`TNJ]2*=F!&TX_A&:
M:B!&TKMWQ]*KE0AE4`4`%`!0`4`%`!0`$XZT@$W>@S1<!R[CUXK&5NA:%Q4C
M#(%`!F@!.:`#B@`^@H`7%`!@"@`S0`9-`!CU-`"9%`!S0`<?6@`H`,4`)N`]
MZ8"%_04!<0DGK0(OU1(4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0
M`4`%`!0`4`%`!0`UG5>I%.S8$;3_`-T?G5<H$;2,W4U220AE,`H`*`"@`H`*
M`"@`)`ZT@$W>@S2N`;6/4XJ7,JPH0#KS4<S'8=D#I2&)DT@#%`!Q0`9H`,$T
M`+C%`!D4`&2:`#ZF@!,^@H`.:`#CZT`%`!]?UH`0L!3`0N>W%`AI)/6@!*`#
M-`!0!HU1(4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`QI
M%7J::38$;3_W1^=5R@1L[-U)JK)"&TP"@`H`*`"@`H`*``D#O2`3<3T%)NP[
M"[6/4XJ',?**$4>]3S,=A<@4AB9STI`&*`#B@`S32;%<*M0[BYA*M12%=B@T
MG"^PTQ<D]*R:L4)CU-(`R!T%`!R:`"@`H`/K0`FX#WI@-+GM0(3)/6@!*`"@
M`H`*`"@`Q0!HU1(4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`UF"
MJ6/04+4")IR?NC%6HB(R[-U)JK(!M,`H`*`"@`H`*`"@`)`[T@$R3]T4G)(=
MA=C'J<5#F/E%"*/>I<F.R%S4C$R:`#%`!P*`#-4HMBN%4H=Q<PE6HI"N%4(*
M`"@`H`6DTF%PK*46BTPJ!A]:`$+`>],!I<]N*!#<YH`*`"@`H`*`"@`Q0`M`
M!0`F:`-&J)"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`89$'?/TI7'
M8BDEW*5QP?6CF'8BQCIR*M3[B:`'-62%,`H`*`"@`+`4@$R3T%)R2'8783U:
MH<Q\HH51VS]:ER8["YJ1B9-`!B@`X%`!FJ46Q705:AW%S"5220KA5""@`H`*
M`"@`H`*`$+"E<!"_I1<!-QQ64MRD)4C"@`H`*`"@`H`6@`H`2@`H`*`"@`H`
MT:HD*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`$Z4`-:51WS]*5QV(VF)^Z,4KCL
M1LQ;J<TKCL)0`N*`#@4`-.#TZU2DT)H,^M:IW)L(6`IW$'S'H*ER0["["?O'
M\JES'RBA5':H;;'87-(8F30`4`%`!FJ46Q705:AW%S"5:20KA3$%`!0`4`%`
M!0`4`(6`I7`0N>U*X#2<]:`"@`H`*SEN4@J1A0`M`!0`E`!0`4`%`!0`4`%`
M"XH`,4`:%42%`!0`4`%`!0`4`%`!0`4`%`"$@=:`&&51ZGZ4KCL,,S'H,4KC
ML1EBQY.:0PQ0`4`&:`$R:`#GUH`2@!<'Z4`&!]:=[```'047;"PNZD`G-`!0
M`4P#-4HMBN@JE!=1<PE6DD2%,`H`*`"@`H`*`"@!"PI7`:6-*X"4`%`!0`4`
M%`!0`"HD4@J!A0`4`%`!0`4`%`"XH`,4`%`!0`9H`,T`:%42%`!0`4`%`!0`
M4`%`"$@=3B@!AE4=.:5QV&-,>W%*X[$9)/O2&&*`#B@!,T`&30`4`'T%`!CW
MH`./K0`<]J`#\:`#B@`YH`/QH`,BJ4;B;L%:*")N)56L(*8!0`4`%`!0`4`%
M`"%A2N`TL:5P$H`*`"@`H`*`"@`H`*`"@`J)%(*@84`%`"XH`,4`&*`"@`H`
M,T`)F@`H`*`"@#1JB0H`*`"@`H`0D#J<4`,,P'09I7'8C,K'V^E*X[#,DTAA
MB@`R!0`F:`#F@`H`.:`#CN:`#/H*`#D^U`!B@`S0`<F@`P/6@`^E`!0`8S0`
M8%-.P"=/I6L97(:"K$%`!0`4`!..M(!"X[47`:6)I7`2@`H`*`"@`H`*`"@`
MH`*`"@`H`*`"IEL-"XK,H,4`+0`F:`#-`!F@!*`"@`H`*`#-`!0`4`:-42%`
M"%@O4T`1M,!T&:5QV(S*Y]OI2N.PWD]:0PQ0`9`H`3)H`3\:`#Z"@!<>M`!Q
MZT`&?04`)SW-`!@4`+0`8H`,"@`S0`4`&*`#B@`SZ"@`^M`!0`<T`(5[YYJU
M*PF@SZ\5JG<@:7]*+@(6-*X"4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`#
MK4O8:%S6909H`3-`!0`4`%`!0`4`%`!B@!:`"@`H`M-./X1^=.X6&&1SWQ]*
M5QV&X]:0!P*`$S0`9H`2@`^E`"X]30`<?6@`YH`/QH`.*`#F@`Q0`<"@`S0`
M=:`#%`!Q]:`#)[4`&/6@`XH`.:`#CO0`9Q0`TN/K3`0N>W%`A,YSFK@)B59(
M4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%)[#"LB@H`*`"@`H`,4`+B@
M`H`*`"@`H`*`"@"7(%(8F:`$H`*`%Q0`8'K0`9'84`'-`!Q0`?2@`P:`#`H`
M,B@`S0`<T`&*`#B@`S0`8]:`"@`YH`..YH`,@4`-+TP&ESVH$)F@!*`%P:`%
M`JH[B8E:$A0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4AA6108H`,4`+
M0`4`%`!0`4`%`!0`4`%`!0!)BD,,4`'%`!GT%`!]:`#B@`Y[4`&/6@`XH`6@
M!*`#K0`8]:`#B@`S0`?6@!,B@!1GZ4`'%``6Q0`TO3`:6/TH$)F@`H`,4`&*
M`%H`,T``JH[B8E:$A0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`N*S;N4
MD%2,*`"@`H`*`"@`H`*`"@`H`*`$H`*`)<GM2&'U-`!Q0`<T`&*`#B@!<T`)
M0`4`+B@!.*`#-`!0`F:`%Y-`"8'<YH`4D"@!I?\`&F`TL:!"4`%`!B@!<4`%
M`!0`E`!0`4`%-;@!ZUJ0%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4``J)/H
M4D+4#"@`H`*`"@`H`*`"@`H`2@`H`*`"@`H`EYI##`H`,^E`"\T`)Q0`4`+C
MUH`3(H`,F@`H`*`#!H`./K0`A8#T%`#2_P"-,+B%B:!#:`%H`,4`+0`4`%`"
M4`%`!0`4`%`!0`9H`#UK8@*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`J6[#2
M%K,H*`"@`H`*`"@`H`*`$H`*`"@`H`*`"@`H`F^M(8G'UH`7F@!,>M`!D4`'
M-`!0`?04`&#0`<?6@!"X%`#2_H/SIA<:6)[T"$H`6@`Q0`N*`"@`H`2@`H`*
M`"@`Q0`4`&:`"@`H`*``UJ2%,04`%`!0`4`%`!0`4`%`!0`4`%`!0`4F[#%K
M,H*0!0`E`!0`4`%`!0`4`%`!0`E`"T`%`!0`4`2X%(89H`.:`#B@`^E`!CU-
M`!P*`$+BF`TM0(:23U-`!0`4`&*`%P*`"@`S0`E`!0`4`%`!B@`H`,T`%`!0
M`4`+B@`H`*`$-:K8EA3$%`!0`4`%`!0`4`%`!0`4`%`!0`4AA6;=R@I`%`!0
M`4`%`!0`4`)0`4`+0`4`%`!0`4`%`!0!+Q2&'T%`!CU-`!P*`$+BF`TM0`TG
M/>@0E`"XH`,4`+0`4`)0`4`%`!0`8H`,4`+0`E`!0`4`%`"XH`*`"@`S0`4`
M"@L::5P!R,\=!6I`E`!0`4`%`!0`4`%`!0`4`%`!0`4`%9MW*2"I&%`"4`%`
M!0`4`%`!0`4`+0`4`%`!0`4`%`!0`4`2\"D,0N*`&ES]*87&DYZT"$H`7%`!
MB@!:`"@!*`"@`H`*`#%`!B@!:`$H`*`"@`Q0`N*`"@`H`,T`)0`4`%`!UH`<
MQ"C:/Q-:I6)&TQ!0`4`%`!0`4`%`!0`4`%`!0`4`%1)]"DA*@84`%`!0`4`%
M`!0`M`!0`4`%`!0`4`%`!0`4`%`!0`9H`2@!<4`+B@`H`*`$H`*`#-`!0`8H
M`,4`%`!0`4`%`!B@!<4`%`!0`4`)0`4`+0`F:`"@`Q0`_P"X/<UJE8EL93$%
M`!0`4`%`!0`4`%`!0`4`%`!0`E3)C2"LR@H`*`"@`H`*`%H`*`"@`H`*`"@`
MH`*`"@`H`*`"@!:`#%`!0`4`)0`9H`,T`%`!B@!:`"@!*`"@`H`,4`+B@`H`
M*`"@!*`"@`H`,T`'-`!B@!<4`+0`HPHR?PK2*ZL38PG)R:HD*`"@`H`*`"@`
MH`*`"@`H`*`"@`J6[#0E9E!0`4`%`!0`M`!0`4`%`!0`4`%`!0`4`%`!0`4`
M%`!0`4`%`!0`4`%`!B@`H`*`#-`!0`4`&*`%H`*`"@`H`2@`H`*`"@`H`7%`
M!B@!:`"@`H`4#N>@JHJ^HFQK,6-:$B4`%`!0`4`%`!0`4`%`!0`4`%`!2;L,
M2LV[E!2`*`%H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`%H`2@`Q0`4
M`%`!0`4`%`!B@!<4`%`!0`4`%`"4`%`!0`8H`7%`!B@!:`"@`H`2@`H`4#)]
MJ:5P8C'/`Z"M21*!!0`4`%`!0`4`%`!0`4`%`!0`4AB5FW<:%I#"@`H`*`"@
M`H`*`"@`H`*`"@`H`*`"@`H`*`"@!:`"@`H`2@`H`*`"@`H`7%`!B@`H`*`"
M@`H`3-`!0`4`&*`%Q0`8H`6@`H`2@`H`*`"@`H``,G%-*X"L<#:/QK1*VA(V
MF(*`"@`H`*`"@`H`*`"@`H`*`"@`K.3*2"I&%`!0`4`%`!0`M`"4`%`!0`4`
M%`!0`4`%`"T`%`!0`E`!0`9H`*`"@`Q0`N*`"@`H`*`"@`H`2@`H`*`%Q0`8
MH`6@`H`2@`H`*`"@`H`2@`H`*`'?=&/XOY5HE8EL;5""@`H`*`"@`H`*`"@`
MH`*`"@`H`*B3Z%)!4#"@`H`*`"@!:`$H`*`"@`H`*`"@`H`*`%H`2@`H`,T`
M&:`$H`*`%H`,4`+0`4`%`!F@`H`2@`H`*`%Q0`8H`6@`H`2@`H`*`"@`H`2@
M`H`*`"@`H`</E&X]>U:17438WK5$A0`4`%`!0`4`%`!0`4`%`!0`4`%2W8:"
MLR@H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`#-`!F@!*`%Q0`8H`*`%H`*`$H
M`6@`H`2@`H`*`%Q0`8H`6@`H`2@`H`*`"@`H`*`$S0`4`%`!0`4`%`"J.YZ5
M45?438A))R:T)"@`H`*`"@`H`*`"@`H`*`"@`H`*3=AA6904@"@`H`*`"@`H
M`*`"@`H`6@!*`"@`S0`E`!0`4`+0`8H`6@`H`2@`H`*`"@`H`6@`Q0`4`+0`
M4`)0`4`%`!0`4`%`"4`%`!0`4`%`!0`4`%`"J-Q]N]-*X,&.>G`%:DB4""@`
MH`*`"@`H`*`"@`H`*`"@`I#"LV[E!2`*`"@`H`*`"@!:`"@!*`"@`S0`4`)0
M`M`!B@`H`6@`H`*`$S0`4`%`!0`4`%`#J`"@`H`2@`H`*`"@`H`*`"@!*`"@
M`H`*`"@`H`*`$H`*`%`S0`K'`VCI6J5M"1*8@H`*`"@`H`*`"@`H`*`"@`H`
M*`"LV[E)!4C"@`H`*`%H`*`$H`,T`%`!0`E`"T`&*`"@!:`"@`H`2@`H`*`#
M%`!0`4`%`!F@`H`6@`H`*`"@`H`*`"@!*`"@`H`*`"@`H`*`$H`*`%Q0`4`+
M0`I^48[]ZT2L2V-JA!0`4`%`!0`4`%`!0`4`%`!0`4`%1)]"D@J!A0`4`%`!
M0`4`%`!0`E`"T`&*`%H`*`"@!*`"@`H`*`"@`H`*`"@`S0`4`.6-W^ZI-`$J
MVIS\S#\*=A7)EAC7^'/UIBN4ZDH*`"@!*`"@`H`*`"@`H`*`#-`"4`%`"XH`
M*`"@`H`*`'#Y1GOVK2*ZB;&U1(4`%`!0`4`%`!0`4`%`!0`4`%`!4MC2"H*"
M@`I`%`!0`4`%`!0`4`+0`4`%`"4`%`!0`4`%`!0`4`&:`#-`!0`]8G89"G^5
M`$JVI_B;\J=A7)5B1.B\^IIB)*`"@`H`SJDH*`"@`H`*`"@`H`3-`!S0`4`+
M0`4`%`!0`4`%`!0`H&/F/2KBNHFQ"<G)JR0H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`K(L,T@"@`H`*`"@`H`6@`H`*`$H`*`"@`H`*`"@`H`,T`%`!0`]89&/"D
M?6@"5;7^^WX"G85R98T3[J@4Q#Z`"@`H`*`"@`H`SJDH*`"@`H`,T`)F@`H`
M6@`H`*`"@`H`*`"@`H`*`%`S["FE<`)S].U:DB4""@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"LGN6%(`H`*`%H`*`$H`*`"@`H`*`"@`H`*`#-`!0`4`2+!(W\./
MK3L%R5;8#[QS["BPKDRHJ?=4"F(=0`4`%`!0`4`%`!0`4`%`&=4E"9H`*`"@
M`Q0`N*`"@`H`*`"@`H`*`"@`H`*``#)P*:5P%)XP.@K1*Q(E,04`%`!0`4`%
M`!0`4`%`!0`4`%`!0`4`%9RW*0M2,*`$H`*`"@`H`*`"@`H`,T`&:`$H`4#)
MXH`D6!V[8^M,5R9;91]XD_I18+DJJJCY0!3$.H`*`"@`H`*`"@`H`*`"@`H`
M*`"@#-J2@Q0`M`!0`4`%`!0`4`%`!0`4`%`!0`4`%`"GCCOWK5*Q+8E,04`%
M`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!6<MRD%2,*`"@`H`*`"@`H`,T`%``%)
M.`,F@"5;=VZ\#WIV%<F6W0=<M18+DBJJCY0!3$.H`*`"@`H`*`"@`H`*`"@`
MH`*`"@`H`*`"@#.J2@H`*`"@`H`*`"@`H`*`"@`S0`F:`"@`H`</E&>YK2*M
MJ2Q*H04`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`5$BD%0,*`"@`S0`4`&*
M`%"DG`!/TH`E6V<]<+3L*Y*MN@ZY-%@N2@!1@`#Z4Q"T`%`!0`4`%`!0`4`%
M`!0`4`%`!0`4`%`!0`4`%`!0!G5)04`%`!0`4`%`!0`F:`#-`!0`E`!0`4`.
M4=S^55%=1-@3DY-:$A0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`5,MAH
M,UF4%`!0`JHS'Y030!*MLQ^\0/UIV%<F6W1>N6/O18+D@``P!@4Q"T`%`!0`
M4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0!G5)04`&:`$S0`9H`*`
M"@`H`*`$H`6@`H`*`%JXB859(4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`
M4`%3+8:'+&S_`'5)K,HE6V8_>(%.PKDJP1KVS]:+!<D'`P*8A:`"@`H`*`"@
M`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`S<U)0E`!0`4`+0`
M4`%`!0`4`%`!0`4`%`"U<1,*LD*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`'Q`F08&1GGC-)C+U0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`
M!0`4`%`!0`4`%`!0`4`%`!0!FU)04`&*`"@`H`*`"@`H`*`%H`*`"@!*`%JH
M[B85H2%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`#E1G^ZI-("5;8G[QQ["E<9*L
M$:]L_6E<"0<#`I`+0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`
M4`%`!0`4`%`!0`4`%`!0!FU)04`%`!0`4`%`"T`%`!0`E`!0`4`+B@`JEN)A
M6A(4`%`!0`4`%`!0`4`%`!0`4`.6-W^ZI-*XR9;4_P`3?E2Y@)5@C7^'/UI7
M`DI`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`
M%`!0`4`%`!0`4`%`&;4E"T`%`!0`4`%`"4`%`"XH`*`"@`H`*`%IK<!*U("@
M`H`*`"@`H`*`"@!ZQ._1>/4TKC)5M?[[?E2N!*L2)T7GU-*X$E(`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`SJDH*`"@`H`*`"@`H`*`"@!:`"@`H`2@`H`*U)"F(*`"@`H`>
ML,C?PX^O%*Z&2K:_WV_*E<"98T3[J@4K@/I`%`!0`4`%`!0`4`%`!0`4`%`!
M0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`
M%`&=4E!0`4`%`!0`4`%`!0`M`"4`&:`"@`H`,4P`UHO,D!R<"F(D6"1OX<?6
ME<9*ML!]XY]A2N!,J*GW5`J0'4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`
M4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`
M&=4E!0`4`%`!0`4`&:`#-`!0`8H`549C\H)^E`$JVSGKA:=A7)5MT7KEC[T6
M"Y*``,`#'I3$1_9X]V>?IFG=@/554?*`*0#J`"@`H`*`"@`H`*`"@`H`*`"@
M`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@#.J2@H`*`#-`!0`4`%`#EC9_NJ30!*MLQ^\0OZT["N2
MK!&O;/UIV"Y(.!@4"%H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`SLU)04`%`!0`]8W;[JDT`2+;'^(@>PIV%<F6%%[9^M,5R2@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`SL5)0]8G;D*?QH"Y*MM_>;\J=A7)EB1>B\^IIB'T`%`!0`4`%`!0`4`%`!0
M`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%
M`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`#%C1?NJ!0`
M^@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@
M`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@
M`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`#_
!V0*`
`


#End
