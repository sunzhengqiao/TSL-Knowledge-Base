#Version 8
#BeginDescription
/// Version 1.6  18.11.2009   th@hsbCAD.de
/// Content Standardisierung

DE
Diese TSL fügt einen Sherpa Verbinder ein
EN
This tsl creates a connector of type Sherpa

#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 1
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 6
#KeyWords Sherpa
#BeginContents
/// <summary Lang=de>
/// Diese TSL fügt einen Sherpa Verbinder ein
/// </summary>
/// <summary Lang=de>
/// This tsl creates a connector of type Sherpa
/// </summary>

/// History
/// Version 1.6  18.11.2009   th@hsbCAD.de
/// Content Standardisierung
/// Version 1.5   24.04.2007   hs@hsbcad.de
///    -select all beams at once
///    -new hangers are included
/// Version 1.4   11.01.2006   hs@hsbcad.de
///    -Visualisierung mit Blöcken ausgeschaltet
/// Version 1.3   03.01.2006   hs@hsbcad.de
///    -alle Verbinder (bis auf 'Multi', 'W8') werden als Blöcke eingefügt
/// Version 1.2   12.12.2005   hs@hsbcad.de
///    -benutzt Blöcke zum darstellen der Verbinder 
///    -Blöcke müssen in der Zeichnung vorhanden sein
/// Version 1.1   09.08.2005   hs@hsbcad.de
///    -fügt den Verbinder an der Oberseite, Mitte oder an der Unterseite des Balken ein
///    -fügt auf Wunsch eine Fräsung in Balken ein
/// Version 1.0   02.05.2005   th@hsbCAD.de
///    - fügt Sherpa-Verbinder ein


// basics and props
	U(1,"mm");   
// die Einheit mit dem Wert 1 und der Einheit mm
	String sArType[] = {"A", "A1", "A2", "A3", "B", "C", "C1","D","D1","E","F","Multi-80x96","Multi-60x96",
	"W8", "WTS6 spezial","WTS5 spezial", "WTS3 spezial", "WTS1 spezial", "WTS1", "Serie-S1", "Serie-S2", 
	"Serie-S3", "Serie-S4", "Serie-S5", "mini 10", "mini 17", "KA", "KA1", "K WTS1 spezial", "K T"};
// legt die verschiedenen Typen an Verbindern fest, die verwendet werden können und deren Größe anschließend definiert wird
	double dHH[] = {U(60), U(35), U(50), U(40), U(65), U(80), U(80), U(80), U(51), U(80), U(180), U(80), U(60), U(80), 
	U(110), U(110), U(55), U(32), U(32), U(40), U(40), U(40), U(55), U(55), U(10), U(17), U(60), U(35), U(32), U(30)};
// definiert die Länge der einzelnen Verbinder in z-Richtung (in der Einheit mm)
	double dWW[] = {U(80), U(55), U(80), U(80), U(120), U(120), U(150), U(180), U(180), U(210), U(280), U(96), U(96), 
	U(50), U(35), U(35), U(35), U(35), U(30), U(60), U(110), U(150), U(110), U(150), U(40), U(40), U(80), U(55), U(35), U(45)};
// definiert die Länge der einzelnen Verbinder in y-Richtung (in der Einheit mm)
	double dDepth[] = {U(20), U(20), U(20), U(20), U(20), U(20), U(20), U(20), U(20), U(20), U(20), U(20), U(20), 
	U(20), U(20), U(20), U(20), U(20), U(17), U(12), U(12), U(12), U(12), U(12), U(10), U(10), U(20), 
	U(17), U(20), U(20)};

	String sHWDesc[] = {T("Screw"), T("Screw"), T("Screw"), T("Screw"), T("Screw"), T("Screw"), T("Screw"), T("Screw"), T("Screw")
	, T("Screw"), T("Screw"), T("Screw"), T("Screw"), T("Screw"), T("Screw"), T("Screw"), T("Screw"), T("Screw"), T("Screw"), T("Screw")
	, T("Screw"), T("Screw"), T("Screw"), T("Screw"), T("Screw"), T("Screw"), T("Screw"), T("Screw"), T("Screw"), T("Screw")};
// Vermutung: Beschreibung der Hardware für die Listenausgabe oder dem Hardwarekatalog
	int nNum0[] = {4,6,4,6,6,6,8,10,10,12,26,8,8,4,4,7,6,6,6,8,12,16,13,17,4,4,4,6,6,8};
// legt die Anzahl der Schrauben mit dem Index 0
	double dHWL0[] = {U(120), U(60), U(120), U(60), U(120), U(120), U(120), U(120), U(120), U(120),
	 U(120), U(80), U(80), U(80), U(80), U(80), U(80), U(80), U(80), U(60), U(60), U(60), U(60), U(60), 
	U(35), U(35), U(12), U(60), U(60), U(60)};
// gibt die Länge der Schrauben an (in der Einheit mm), die vorher mit dem Index 0 definiert worden sind
	double dHWDiam0[] = {U(8), U(5), U(8), U(5), U(8), U(8), U(8), U(8), U(8), U(8), U(8), U(8), U(8), U(4),
	 U(4), U(5), U(5), U(5), U(5), U(5), U(5), U(5), U(5), U(5), U(3,5), U(3,5), U(8), U(5), U(5), U(5)};
// gibt den Durchmesser der Schrauben an (in der Einheit mm), die vorher mit dem Index 0 definiert worden sind
	int nNum1[] = {2,0,0,0,3,3,4,5,5,8,15,8,0,0,0,0,0,0,0,7,11,13,11,13,0,0,2,0,0,0};
// legt die Anzahl der Schrauben mit dem Index 1 fest
	double dHWL1[] = {U(80),0,0,0, U(80), U(80), U(80), U(80), U(80), U(80), U(80),0,0,0,0,0,0,0,0, U(60), 
	U(60), U(60), U(60), U(60),0,0, U(80),0,0,0};
// gibt die Länge der Schrauben an (in der Einheit mm), die vorher mit dem Index 1 definiert worden sind
	double dHWDiam1[] = {U(8), 0,0,0, U(8), U(8), U(8), U(8), U(8), U(8), U(8),0,0,0,0,0,0,0,0, U(5), 
	U(5), U(5), U(5), U(5),0,0, U(8),0,0,0};
// gibt den Durchmesser der Schrauben an (in der Einheit mm), die vorher mit dem Index 1 definiert worden sind

	PropString sType(0, sArType, T("Type"));
// es wird ein Eintrag mit der Bezeichnung Type (wird übersetzt, 
// falls es in einer best. Liste in deutsch hinterlegt worden ist) in den Eigenschaften 
//des TSL's erstellt. Unter Type kann zwischen den einzelnen Typen, welche unter bei ArType definiert worden sind.
	
	String sArPos[] = {T("Top"), T("Middle"), T("Bottom")};
	PropString sPos (1, sArPos, T("Position"), 1);
	
	String sArMill[] = {T("Yes"), T("No")};
	PropString sMill (2, sArMill, T("Milling"), 1);
	
	String sArNY [] = { T("No"), T("Yes") };
	PropString sNY (3, sArNY, T("Show description"),1);	
	PropDouble dxFlag (0, U(200), T("X-flag"));
	PropDouble dyFlag (1, U(300), T("Y-flag"));
	
	PropDouble dSnap(2, U(2000),T("|IntelliSelect|"));
	dSnap.setDescription(T("|Describes the range where a valid T-Connection could be found|"));

	PropString sDimStyle(4,_DimStyles,T("Dimstyle"));
// es wird ein Eintrag mit der Bezeichnung Dimstyle (wird übersetzt, 
// falls es in einer best. Liste in deutsch hinterlegt worden ist) in den Eigenschaften 
//des TSL's erstellt. zur Auswahl stehen die Bemassungsstile welche unter _DimStyles zu finden sind.

	PropInt nColor (0,171,T("Color"));
// es wird ein Eintrag mit der Bezeichnung Color (wird übersetzt, 
//falls es in einer best. Liste in deutsch hinterlegt worden ist) in den Eigenschaften 
//des TSL's erstellt. es wird die Farbe 171 vorgeschlagen.

	Block blk[] = {"A", "A1", "A2", "A3", "B", "C", "C1", "D", "D1", "E", "F", "WTS5 spezial", "WTS5 spezial", "WTS3 spezial", "WTS1 spezial", "WTS1"}; 
	String sblk[] = {"A", "A1", "A2", "A3", "B", "C", "C1", "D", "D1", "E", "F","WTS5 spezial","WTS6 spezial", "WTS3 spezial", "WTS1 spezial", "WTS1"};
	int nblk = sblk.find(sType);
	
// on insert
	if (_bOnInsert)
	{
		showDialog();	
		PrEntity ssE(T("|Select beams|"), Beam());
		Beam bm[0];
		if (ssE.go()) {
			bm= ssE.beamSet();
			reportMessage (bm.length() + " " + T("|beams selected|"));
		}	
		
		// declare TSL Props
		TslInst tsl;
		Vector3d vUcsX = _XU;
		Vector3d vUcsY = _YU;
		Beam lstBeams[2];			// T-connection will be always made with 2 beams
		Element lstElements[0];
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		
		
		//lstPoints.append(ptYourPoint);
		lstPropInt.append(nColor);
		
		lstPropDouble.append(dxFlag);
		lstPropDouble.append(dyFlag);
		lstPropDouble.append(dSnap);

		lstPropString.append(sType);
		lstPropString.append(sPos);
		lstPropString.append(sMill);
		lstPropString.append(sNY);
		lstPropString.append(sDimStyle);
		
		for (int i = 0; i < bm.length(); i++)
		{
			Beam bmFemale[0];
			//T connection
			int bOverWriteExisting = TRUE;	//TRUE=>Overwrite,  FALSE=>Not Overwrite
			double dRange = dSnap;		//ExtendDistanceAllowed, use a property to allow user to control the intelliSelect behaviour
			
			// query all possible t-connections
			bmFemale = bm[i].filterBeamsTConnection(bm,dRange,bOverWriteExisting);


			//for each beam that makes contact, insert the local instance of this tsl
			lstBeams[0] = bm[i];
			for (int j = 0; j < bmFemale.length();j++)
			{
				// make sure it's not the same beam
				if (bmFemale[j] == bm[i])
					continue;
				lstBeams[1] = bmFemale[j];	
				
				if (lstBeams[1].vecX().isPerpendicularTo(lstBeams[0].vecX()))
					// create new instance	
					tsl.dbCreate(scriptName(), vUcsX,vUcsY,lstBeams, lstElements, lstPoints, 
						lstPropInt, lstPropDouble, lstPropString ); 		
			}// next j	
		}// next i
		
		eraseInstance();
		return;
	}	
//end on insert________________________________________________________________________________
		
// right angle
//	if(_X0.angleTo(_X1) != 90){
//		reportNotice("\n " + T("Beams are not perpendicular!"));
//		eraseInstance();
//		return;
//	}

// restrict color index
	if (nColor > 255 || nColor < -1) nColor.set(171);
	//int bShowPlan = sArNY.find(sShowPlan);	

// vecs
	_X0.vis(_Pt0,1);
	_Y0.vis(_Pt0,3);
	_Z0.vis(_Pt0,150);
	
// Beams
	Beam bm0, bm1; 			// es werden zwei Balken definiert: bm0 und bm1
	bm0 = _Beam[0]; 			// der Variablen bm0 wird ein vordefinierter Balken [0] zugordnet
	bm1 = _Beam[1]; 			// der Variablen bm1 wird ein vordefinierter Balken [1] zugordnet
	double dH = bm0.dD(_Z0);
	
// invalid alignment	
	if (!bm0.vecX().isPerpendicularTo(bm1.vecX()))
	{
		reportNotice("\n*****************************************************************\n" + 
		scriptName() + ": " + T("|Incorrect user input.|") + "\n" + 
		T("|Beams must be perpendicular|") + "\n" + 
		T("|Tool will be deleted|") + "\n" +
		"*****************************************************************");
		eraseInstance();
		return;
	}
	
// find type
	int f; 							 		// Festlegung der Variable f
	for(int i = 0; i < sArType.length(); i++){	// Variable i vordeklariert mit 0, i ist kleiner als die Länge,
															// die unter ArType definiert worden ist, Vorgang für i = i+1
		if (sType == sArType[i]){ 			// wenn der Typ, der in den Eigenschaften ausgewählt worden ist 
													//gleich dem ArType ist, dann
			f = i;							// f = i 
		}
	}

// get Grippoints
	if (_PtG.length() < 1)
		_PtG.append(_Pt0 + dxFlag * _X0 + dyFlag * _YW);
	
	dxFlag.setReadOnly(TRUE);
	dyFlag.setReadOnly(TRUE);

//Flag
	double dF;
	if(dxFlag == 0 && dyFlag == 0)
		dF = U(1);
	PLine pl1 (_Pt0, _PtG[0]);

// MetalPart
	Point3d ptIns = _Pt0;
	if (sPos == sArPos[0])
		ptIns = _Pt0 + bm0.dD(_Z0)/2 * _Z0 - dWW[f]/2 * _Z0;
	else if (sPos == sArPos[2])
		ptIns = _Pt0 - bm0.dD(_Z0)/2 * _Z0 + dWW[f]/2 * _Z0;
	 ptIns.vis(2);
	
// milling
	if (sMill == sArMill[0]){
		ptIns = ptIns + dDepth[f] * _Z1;
		BeamCut bc (ptIns + dWW[f]/2 * _Z0 - dDepth[f] * _Z1, _Z1, _X1, _Y1, dDepth[f], dHH[f], dWW[f] * 2, 1, 0, 0);
		bm1.addTool(bc);
	}
	
// Cut
	Cut ct(ptIns - _Z1 * dDepth[f], _Z1); 	// der Balken wird mit einer Fläche geschnitten. die Fläche 
													//wird aufgespannt mit zwei Vektoren: 1. Vektor: ???? Einfügepunkt des
													// TSL's- Einheitsvektor in Z-Richtung multipliziert mit dem Wert 20;  
													//2.Vektor: Einheitsvektor in Z-Richtung
	bm0.addTool(ct,1); 				// an dem Balken wird das Werkzeug (Schnitt) ct angebracht.
	
	//if(f != 11 && f != 12){
	//	blk[nblk].visualize(ptIns, _Z1, _Z1.crossProduct(_Y1), _Y1, nColor);
//	}
//	else{
		MetalPart mp(ptIns, _Z1, _X1, _Y1, dDepth[f], dHH[f], dWW[f],-1,0,0);
//	}	
			
// Einfügen eines Metallteiles mp mit dem Einfügepunkt _Pt0 und den Seitenlängen des Körpers _Z1, _X1, _Y1.
// Den Seitenlängen werden bestimmte Werte zugeordnet: _Z1 = 20, _X1 = die f-te Zahl, die unter dHH festgelegt worden ist,
// _Y1 = die f-te Zahl, die unter dWW festgelegt worden ist. 

// display
	Display dp(nColor);		// Anzeigen der Variable dp
	dp.dimStyle(sDimStyle);
	dp.addViewDirection(_ZW);
	int nChange = 1;
	if (sNY == sArNY[1]){
		if ((_PtG[0] - _Pt0).dotProduct(_XW) < 0)  //vzE.crossProduct(vy)
			nChange = -1;
		
		dp.draw(T("Sherpa") +  " " + sArType[f], _PtG[0], _Y1 , _X1, nChange, 1, _kDevice);	
			// definieren der anzuzeigenden Variablen: angezeigter Text: Sherpa und der Name des gewählten Verbinders (A oder A1...), 
			//sArType[f] ist der Typ des Verbinders der gewählt worden ist (an der f-ten Stelle), Einfügepunkt und Richtung, ????
		
		if(dF != U(1))
			dp.draw(pl1);
	}
	
	setCompareKey(sArType[f]);

model(T("Sherpa-Verbinder Typ ") + sArType[f]);//Artikelnummer
dxaout(T("HSBDESC2"),T("Sherpa-Verbinder Typ ") + sArType[f]);//Bezeichnung
material(T("Steel"));
			
// Hardware
	Hardware( T("Screw"), T("Screw"), T("Sherpa-Spezialschraube"), dHWL0[f], dHWDiam0[f],nNum0[f], " ", " ");


// exclude screws with amount 0
	if (nNum1[f] != 0)
		Hardware( T("Screw"), T("Screw"), T("Sherpa-Spezialschraube"), dHWL1[f], dHWDiam1[f], nNum1[f], " ", " ");

// add the number of the same kind of screws


_X1.vis(_Pt0);
_Y1.vis(_Pt0);
_Z1.vis(_Pt0);	

	







#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`:P!K``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`-_!,@#`2(``A$!`Q$!_\0`
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
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BL37?$5MH:QB0+)(^3L
MW@$`=ZYV7Q]<S$I9Z:!CC>[Y_3`]JESBG9C46SO:JRZC9PL5DNH58'!!<9%>
M=76KZU?1M'+<E(V_N\<55%NQ=9'FD,BG((8C'TK-UHHI4VST6YU[2[6V-Q)>
MP^5D#*MNS]`.M8]WXYT\(!8![ER,@^60!^>/:N5DB\T`2N[A>@8YQ1'!%%]Q
M`*AU^Q7L^YV>F^*[.]4>;&\!SC)Y7.?T]>:WXY8Y4#1NKJ1D%3D5Y@J[&+)\
MK$$9%/74=3LGW6#1Q9_A`.W\LU<:R>XG3?0]0HKA].\8W2LL%];!WX`9>,@=
M>O>NIT_5K748@T3['Q\T;\,OX5JFGL0U8OT444Q!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!6?=:QIMGN-Q?
M0(5X*[P6_(<U==!)&R'H1BO"]55[;Q%>0EGF1)-I,AR00<']:F4K(<5<[O4/
M'.]B+21(4!Z\.QZ_@/\`/-9P\::P\C);E9`1C=)&,#W&,?Y[5@VTEF%R5(QQ
MBM&&:WP%C('M7,Y23N:J*L1FTDN;A[F[D:2:3[Q)SG_.*M)&D8PJ@"G45DVW
MN6E8****0PHHHH`****``J",$9%7)[R*YB`EMLR8PS))MW'U/%4Z*J,G'83B
MGN:$'BZZTO/FQ27,79"0-O/7=U/'M3AXOOKS#PS)$,8**@Z^^<UF,H88(R*H
M3V#K()+9MC>U7[1O1LGD2.WT_P`5<JE]'[>:@^G4?F>/RKJ$=9$#HP96&00<
M@BO'5O;FVXN8MX'\2\5V&@>,-.CM5M;NX*-'G:[*<$<8'UY_(5K3F]I$2BNA
MVM%8_P#PD^D';LNMP)QD(W'Z5JHZR('1@RL,@@Y!%;)I[&=FMQ]%%%,`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
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
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`445!<SK;6LMPX)2
M)"Y`ZX`S0!XK,%74(7)(YQU]JOU1G8RZLA;;\Q+$!0!G'8#@5>KS9=#K0444
M5(PHHHH`****`"BBB@`HHHH`****`"M+3+C3$A>WU.R::(CY&C8@CVQD#'^?
MIFT4T[.Z!JYO3>#A/F[T"_CD@9N(I/X`1R,_EP1G^N9<6NK::P^VV3*A.`PP
M0?\`.*@@N)[5R]O-)$Y&"R,5./3BN@L/&-W%(%OT6XB)^\`%9>G3'![\>_6M
MU.$OB5C)QDMC#2]A<##CGI[U.&#="#5O5+30]7"SV&VUN#]^)ML0`SUR?ES[
M`GK]:JCPIK<<?F6J^=&<%?WJ\CV(/-)PN_='S=PHJK)//8W1M+^%H9U`)##K
M[@]"/\*L)(L@RI!J&FMQIW'4444AA1110`4444`%%%%`!37C61<,,TZB@#.D
ML)(27M9"C'WS5RR\4ZCI>V,A_+!&1C*]?0].O.*EI"BMU`-4I-$M&W'\0HTB
M!GM1N[D,0/RP?YUU.F:K:ZM;?:+5PR;BISU!'_ZQ^=>;-:Q,<E>?6FP2WFC2
MFXT^4J<C<AY5@.Q'Y_G6T*NNI#AV/6J*X_2?'-M=*([V(PS=RG(ZGG'7\LUN
M)KVF2N(UNU!/]Y2H_,C%;*<7U,^5FI16:FM:=)*T2WD89<Y+'`_`G@U>CECF
MC$D3JZ'HRG(-4I)["L24444P"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
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
M.,&0\LW3O^'3I6].BWJ92J):'/\`A[P5;V""XO3YMTXR5SD)[>Y]?\YZZ&WB
MMT"1(%4=`*EHKK225D8MW"BBBF(****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHJO<W,=K;
MR3RG"(N3[^WUH`BNM,M+V%XKB!71Q@C'Z_6O)=:TFZ\-7S(S[XOO!L_*RGV[
M'_/-=5>^-KF$/M2&/.=ORDE?UP3^%<U>2W^M7/FW!^20`L_`R.!C`]A7-4E&
M1K&+1#8Q6^J('G>X5!]Y8P!R.V3Z\<U>AL+2UD9H(=O/!;E@/K]*FBB2&-8X
MU"J.@%.K!M;(T2L%%%%(84444`%%%%`!1110`4444`%%%%`!1110`44Y59W5
M$4LS'``&234T]E<VL*2S1^6'.%5F`8G./NYS32;V%<KTV.57O$MU1Y7/)2/J
M!_3_`.O6;?7TT:LF!!P",D%B..PZ?C56UN[P6LD,$6U96RTIX9AZ9]/\:I12
M^(3=]C8U>ZLH\C9#-D#:!G8G?KG)/X]^O&*YZ.T-[(7==L7J>I]OI5E;%I'#
M7#AAUV`<9J[C'2E*I?8:@,BACA0+&@4"I***S+"BBBD`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%137$<`&\]>@%17%V(R4C&^3T':M_PQX0;4
M534=0D/DEOEC'5\9!Y[#(_GTX-:0@Y,F4K&%9Q:AK%TMK9PX+<Y_NCN2>PKN
M="\#6FG;)[YOM=QC[K#*`]_KW_PKI[.QMK&$0VT21(.RC&?<^I]ZM5UPI*)A
M*;8F,=*6BBM2`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
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
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4QW2,9=@H]Z9<.T=O(
MZ`;E&1FO+]:\1ZI+=-%.CV\2L<%>25`]>E)NPTKGH%YK]C9@[I02.N3@#Z^E
M<I=^,KR]1DTV+"G@3-P![@'GUK!M!:7!,R$R2<9:0Y;-70,<#BN>59[)&BI]
MS/\`[.DE=FN+EGW<D=\^N:N0P1V\>R)0HJ2BL')LTL%%%%(84444`%%%%`!1
M110`4444`%%%%`!1110`444C.L8RS!1ZDT`+5>ZO8[48)S(1\JCO5>;4"[>5
M:C<>A?L/\:VM(L?[./VF=#+J,HS''MRRC'/^?3ZFM(4^9ZD2E9&3!::IJ*F1
M/W,/0L>`O([_`(]*SKO3[F'#KB7)VB16R"1UZ_A^==GJ<AM0);ZY$ER1A;1#
MG;G'WSZ8[=^,'N.=GN);AP\K9(&````!Z`#@54W&&BW"-Y;E>T66VM3"9#AS
MEP#P>GY]!4E%%<[;>YJE8****0!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%,+_O%B4%I7X5!U--*^B`<2%4DG`%.TZQO]=F*6"^7"#@
MSN.,^@]>*U-.\)7>I['NR4AR#L3O]2?Y8[UZ%I]A;Z;:);6\81$&`!713H=9
M&,ZG1&)H?A2TTK][(/-GSD2/RP_PZXXKI%14&%4`#TIU%=226QDW<****8@H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`*U\XBLY&/`Q@_2L+1])AO=-+7B*S>8^PJ>0,]ZV
M-5YTR<9Q\IYJMX;0)H5N<DELL<^I)H`Y75_!(ME:XTX;U!!*YPP'J".O>L\3
MQK;1Q30>7.,XD4G#].H)X..<C\0*]1K'U+P]8ZBKDQ".5APZ\8/J1WJ904MQ
MJ31P<<L<@S&ZL/8TZH=4\.76GWV(GQ,W0C@.,\'/3)[U3@OV@8PWI*L#]XKC
M\_\`/>N2=-Q-U),TJ*175QE6!'J#2UF4%%%%`!1110`4444`%%%%`!1110`4
MC,$4LQ``ZDU&US&K^6NZ23&=J`L1^55;B.ZN76)U6!,]';[WY9]#5Q@Y;$N2
M0Q[R>Y++:+@`CYB.M=19^#(H56YU6[<M]YH]V`.F1_\`7%9FGVK02K(+<RP1
M'<VQ/E..>6/&*FO]=:\64J[[FP%XPOUYYS[8_EBM8J,%>1#O+1&I?ZMI.B6_
MV.Q"*['&5&3TZ\=>._YUA3:G(DC?9965B,/..&?G/!Z@?KZ^@S%15)(R6/4D
MY)_&GUG.LY:+0N--+5A1116!H%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%1M*!*D2`O*YPJ+U-;FG>$=0O)/,NI42#(_=(#R/<G
M&.W2M(4Y3V)<TMS'BAFNY!%;;=V0"Q/`S_,UW6B^%+>P'FRC=*Q#$D\D_P">
MU:.EZ#9Z9&BQ1@;/N]\?C6O793I*"\SGE-R&JJJ,*`![4ZBBM"0HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`JW\0FL9D)(RIY'6LOPS,YLY;:4`/;R%0H!X4
M],GN>M;I'&*YW3W$?B>Z@CX4QY88')[4`='1110!6NK."\A\JXB61.O(SCZ>
ME<IJO@P2J[Q.TQ'W5)"L!QWQS7:44FK@>.W&E36$\@M3,KH`'1E.>>X&.E.M
M-228B.0;)>F,8!KU6\TZUOTVW,*OCH>A'XUR.JZ)';3!I[59;;@+*.&!)/!Q
M]?IFLY4D]BU.QC`@C(HJE>:9-I]P5M[@B(\QY;((_P`>>E017\\#A+A-ZD_?
M'&*YG!K0U3ZFI138I4EC#QME33J@H****`"BHKBYCMDW2$\]`.IJLTU]<PEK
M:W*+_>?`X]>35*+>PFTBXTB*RJ3\S'``&2?PKIX&N;F&"VM'>UL57`.<LV3G
MD^OL/?Z5S6BZ/<R&6Y"CSAGS)9LA(P!ZXQ_];TJW<WB0WD2-J+RQ_P#+P;9!
MMX[#/7/KT^M=$%&FKR,I-RT1KW$=CI<8AA'FW)PH4'DD_P">M02SVFBQM+<K
M'/JK898=N5BSR,_3\^G;FLXZXENC"QMRDV[BYF8.V,GHN,#K[_UK&=VD=G=B
MSL<EB<DGUJ:E?I$J-+N6+O4+R\)^TW#NN<[<X4'&,A1P*K445RMM[FR5@HHH
MI`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444E`!52:[)
M<PP#+=V[`T^-+G5+H6EC$TA)P=H_S@>]=EH/@=8@LNI#U'D`_D2P/Z#VYZBM
M8TV^A$II#O!WAN.*V&I7J;IYN4SD87UQ[XS],>]=JJA0`HP!VIU%=L8\JL<[
M=V%%%%4(****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@!KL$0L>@%<]HJ&
MYU>\OBQPO[L8Z$]S^0%;UP";>0#TK%\*$_8[I2<[;@C]!0!OT444`%%%%`!3
M'1)$9'4,K#!![T^B@#G=2\)V.H`%9)8&`.TQD<'\?Y5S5WX$U*VC5K:[CN\G
M#JR["/IUS^E>CT5+@GN-2:/%+U+G1KW8R-&Q`8@@X8?_`*P:T+*]CO(MR_*X
M^\N>E>C:SHMOK-NJ385D/RL5SC/48K@-6\'7OA\M>6#?:(`"S87:5]L9.16,
MZ5]D:1F*S!%+,0`.YK*NM8P2EN,\?>(K/6]EU*0B0N-I^4(G'XY-:7V6U2,Q
MK"L@X_>2+\WN.I`_^M65E'XB[M[$.EW+3:@)WE4E"`2ZDJ/R!Z=:Z"YU&""9
MC8@R.3\TLJ\=>-JGC&/7]*QU547:JA1Z`8IU2ZLK66@_9J]V2S75Q<[1//)+
MMSC>Y;'YU%116984444@"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BJ<U\L<GEQ+YC]P#TIA^V2L,-L7'(`JN5]17+DDL<2[G8**
ML:9HU[X@D40J8[+=AGZ%AWQ^7ZU>T#P1)>RQW5_N2VP&`)YD_J![_3'K7H]K
M:06<0B@C5$`P`!BNBE17Q,RG.VB(--TR#3+9(844!1CBK]%%=1B%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`$-SQ;28_NFL7PN&C@NXI
M#^\$V6'ID5OD9&*YE"=)\0C?N\BY^3IGGMVSW^G/M0!T]%%%`!1110`4444`
M%%%%`!6;KLBQZ'>,V,>41STYXK2K,UZ(S:%>(%+'RB0`,Y-`'D\$:PWEY&AR
MGF;AQC&>?RJS5&QE,]S=RGH7P/8#./TQ5ZO.J?$SJAL%%%%04%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%,DE2%-SL`*`'52NK
MO_EC`<N3@D=J6**XU2Y6",$"0A54'&2>!DUZ1HG@_3],@7[1#'<7)'SLZ[E'
ML`?Y]?IG%;4Z3DS.4['$:/H5U=F-;:W9@QVF0@[%/?)KN[#PEI]H`TX-U*"#
MEN%&#_=']<UT=%=$:,5J]3)S;V"BBBMB`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"LS6[>.2PD=^-BDY'6M.JU]$)K*5"<`KU
MH`@T:YDN]+AFF(+MG)`QW-:%87AIV6UGM'P#!*0!G.%/3GZYK=H`****`"BB
MB@`HHHH`*JWYQ92@'&1C\ZM5#=)YEM(O/3M0!XK8JD<UPB@`B0@XSVX[U>K-
MA#6VM7T$A^;SWY/?FM*O/J_$SJAL%%%%9E!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%)TIDLT<*;I&"CWJ_IWAC4M=PSXM;;/1L[CZ''_
M`-?^57&#EL2Y)&-<73N1':D$]VZXJ:TT:[O79TBFG(QN"*6Q^5>G:5X8TS2D
M4I`LLP.?.E&YLCICT_"MRNB-!VM<R=0Y?POX>&EH9[F%5NB2%&X'8O\`B?Y?
MC74445O&*BK(S;N[A1115""BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"F2,$C9FX`&:?4%TP6UDSZ8H`Q/#@<WFI29S&7
M`#>O4_UKHJY_PH"MC<Y(_P!>>G;@5T%`!1110`4444`%%%%`!4%S.MM:RW#@
ME(D+D#K@#-3U3U&)Y],NX8QF22%U49QDD$"D]@/%=5E63Q&UTB;#*S.5!S@$
MFM.LK6%):%E.&&>U:4#F2"-SP2H-<$M4F=4='8DHHHK,H****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`***FMK?[0[+O"X&1W)/H!_GBFDV[(&[$-36L"SS
M(KR"*(G#2$$XZ=`.IYZ5MV7@^:Y:*62=@G4IMP#Z?UKIK+P[:VL:*XWA/N@]
MO;Z5T1P_\QE*KV.9TS18+G4$_P!&=XH\$23C.X\<@#@<]N3UYKO8HDA0)&H5
M1V`I8XDB4*B@"GUU**BK(Q;;W"BBBF(****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`J*X`^SR9Z8J6D(R,4`
M87ADJMK<QX4.LQ+`>_?'^>E;U<[I\36WB.=$<>5+&6*_0\9_,UT5`!1110`4
M444`%%%%`!1110!Y3X]L/L_B%;A%Q%,F6`'`;O\`GC\3FLNR7;9Q@^E=)XY0
MA[Z1PQV!&CSG@\#C\S^M<];X%O'CIM%<==69O3=R6BBBN<U"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`*FM;2XO9A#;0M+(>RCIVR?0>]:WAS1!JMPTD^1;0D;
M@,C>?0'^??D>N:ZBXEM-!@-MIUM&+EQE4&>>>K'J>M;4Z+GJ]C.52VAQ%QH]
M_:7$<$\&QW[!E;`]<`UUWAW0Q;VL<MQ&=PY4,<GUS^=6=)TIB?MEX2\\GS,"
M<X-;W3I75"G&&QC*;EN-`"C```'84ZBBM"0HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`,*V/_%3%3U\EB/^^JW:Y^U9_P#A*9E8941DJ?Q&1704`%%%%`!1110`4444
M`%%%%`'GGC_,R3JG'EE`XSV]?S(KF[;BVC'^R*Z;XA)(JL^T!#&I#;@,X;D8
M_$5S%K_QZQ?[HKDQ"U3-J1-1117,;!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!113))$B3<[
M!1[T`/KH-,\-"2/S]4F-G%G"QMA7;KZ]/RYY^M0>'XYC$UQ#9K++(<0R.`?+
MP?O`>N>F?3WKI;;P_)-*+F_N)))LYY/&/;T]:ZJ5&_O2,9U.B&?VD_V=;70[
M=1&F`K,IZ=>`>_/4]3FKVGZ08SYUV=\Q.3SGM6E;VD%LNV*,+^%3UU&(=.E%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`'-:D?L?B*QGX(9MH!;&,\'^==
M+7.^*I/L]I%,`=P<=#S^'O70*<J"#G(H`=1110`4444`%%%%`!1110!R7C:+
MS8;,9&`S,P)[#%<-$BQQB-#E4)4'Z'%>@>,5"V,,^6#(64;?<=_R%><Z?C[%
M&`,8KFQ.R-:6Y:HHHKD-PHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BD4J94C+JI<@#/;WK<M?#37S
M;4WF(?>8\!OICI],GI6D*<I[$RFH[F`IGN9O(LH6GF[A>B_4UTFD^`I)F2?5
M[@MC_EF@([^M=;I>B6NFQ*L<:@CGITK5KJA1C$P=1L@@M8+:-8X8E15&``.@
M]*GHHK8@****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@#GO$F)%A@R
MJDL!EN!@\'GM6^JA5"CH!BL+Q.A6R690?DR6(_S[UM6\JS6\<BG*LH(.,4`2
MT444`%%%%`!1110`4444`8OB>#[1H5QA`QCPX!'H>:\ITO*P/&3G8Y%>OZY(
M(M%NV)Q^[('U/`_4UY5%:O;1#<FT-T8=&/U_$5AB%>%S2D]22BBBN(Z`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHI*JS7@4F.$;Y!QQVII7!NQ-+/%",R.%]*J/=33`K"A3GAB*T_#_`(<EUJZ=
M9'V*HW/(5)QZ#'K_`('TKTK3M#T[3$06UJJNO21AE\XQU[?AQ6U.ES:F4IV.
M?\-^#8K:W6ZU`L]S*HRA_A'!P0>_K791QI$NU%`%/HKL2LK&+=PHHHIB"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`,S7H%GTF96^[CD>M
M&A3&;1[<D8*@ICZ'%7+I0UM(",C&:Q?";LUE=*3\J7!"CT&`?ZT`=#1110`4
M444`%%%%`!1110!C^)49]`N@,X`!;`R<9YQ7)I8G4-%NID5M]FP*YS@KSN[X
MSC!_`>M=CX@.W0;WC.8B.N*Y'2;DV7@2YE)4-<R&-`PY.>#G'0X!-14MRNY4
M=]#GJ***\XZ@HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`***3I0`=*K3WT4/`^=^FT5#/.UP_D0@[?XFQUK4TK0IM0FV6T.YEQO<
MG"KVR3_D\5:CW);,L-=7(P0$0]1CM70:5X0O[B!)4A2-'7<KRMC/X#)_2NPT
M[PI866UIA]IE'>0?*.O1?\<].U=%71&C?XC)U.QG:3I<.DV2VT9+<[G8_P`3
M>N.W2M&BBNA))61DW?5A1113`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`(;G_CUE_W36'X1&VRNUSTN6Z#V%;LZEK>15&25(%87
MAB1(_MEGN)EBEW-^/_ZOY4`=%1110`4444`%%%%`!1110!GZW&)='N8VZ,A!
MKR^.\9]-AM&9@RN[L`>#S@?C][\Z]9NX1/:O&1D$>N*\K:U:(WT+N3):3Y_V
M=K'MQUSC]:SK)N#L7#XB"BBBO/.D****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`***K7%VL/RH-\G]T&FE<&[$[NL:EF8`#UJAB2]D!R5B[
M#UJ:UL+W49.(Y)6`W>7&A.!]!_GFNV\-^%I(9H[N]C,7ED/%%T)/4$^F/3UZ
M^^D(-NR(<DMRA8>";YX8I':*!7P2KD[U'TQU]LUVFDZ5;Z1:"*(;G/,DA'+G
M_#T%:5%=<*<8ZHP<V]`HHHK0D****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`*Y^PA\GQ)/L9@C1D%>W!'-=!7.3LMOX
MEMRR@+G`8MCD@^WO0!T=%%%`!1110`4444`%%%%`!7G7B^U^Q:H;ED+QS1E0
M!V/8_0'%>BUQOQ`5O[-MVC(#[RHSW)&,?Y]*35U8:=CCATI:C@)-O&6&"5&1
MFI*\TZPHHHI`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!2,P522<`=3
M4,]U'`0K'+'HHJSIN@ZKK\BR1PF.V!^\YVK_`(GICBJC%R$Y)&>9IKUUAM%8
M[SM!`Y)]!77^'/!(_P"/C58F"8RL1;YF)[G'(Z].OK[]/H_AVQT:%?)B5Y@.
M9F')//3TZ]OUK:KKA1MN82G?8C2-8T5$4*BC"JHP`/2I***W,PHHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"L#Q'$$ACO,`M;D.,]L5OUD>(EW:2X[$C/TH`TX95GA25#E74,*DJEI/
M_()M/^N2_P`JNT`%%%%`!1110`4444`%<'XTN]NLVD7E>8L*>85)P&&>1^E=
MY7GNJ&.]\0W,LZM)#'(L17I\HZXY]O;K0P1SP&``.*6I+B-(;F6*.02HCE5<
M=&`/6HZ\P[`HHHI`%%%%`!1110`4444`%%%%`!1110`444!2QPH)/H!F@`JY
M%I4UR`D<@#M_<`<`<\YSCTZ9'-7]'T&:\N0)$PHZG/3_`#_GW[VUL8+1`J(,
MCOBNJG0TO(QG4Z(YO1?!-C9$7%VAN9LY_>'(Z>G0_C76A0H``P!2T5TI);&3
M=PHHHIB"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"L+Q.S+IC`'@@Y'Y5NUC>)ANT:50<-C(H
M`OV!C;3[<P@K$8UV@]0,5:JEI'_((M.,?NEX_"KM`!1110`4444`%%%%`!7!
MZS`]A<W\:D[)3N0G@\X.,_7-=Y7$^/5%M;1WBMB0H4`S@]L$>XS2;L!Q\)4P
MH5SMQQNZXJ2JU@2;.,DYZ_SJS7FO<ZT%%%%(84444`%%%%`!1110`4444`%*
MB-(ZHBEG8X"@9)/I5O3=.DU"X*!UBB3F25ONH/\`'T%=)8O!IV(=)MFGN&3#
MW+C[W/89X'M[#K6M.DYZ]")343!.CSP+&UT-DCD;8`1YC`D?]\\$]><CI70:
M3X;8`-+N1<[@,]?KZ]_S-:>F:,5G:\O#YD\G))/^<=!Q6YTX%=<*48;&#FV1
MP6\=NFU!BI:**T)"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*P?%`?^S6V'&%;
M(QG(K>JGJ5I]LLWC&-V.*`)X65X$96#*5&"#G-2US5CK,MABUU"!HT08611D
M>P/Z?G711R)(@=&#*1D$4`/HHHH`****`"BBB@`KD/'D?F:='N'R!7YQWX(Y
M[=*Z^N:\;6Z3>'7+*6\MPP&<9[8_6DP/-M.<-:`#/RDBKE5-.5DM`KXR&;I]
M:MUYTMV=<=@HHHJ1A1110`4444`%%%-^>29((5W32'"CL/<TTFW9`W;5B]*A
M,Y>98+=#-,Q`"K70V_@.^O4#7-Z(QC.T1Y&?SYKK=(\-6&C1@0Q[Y.<R.`6(
M]/ITX]JWA0;?O&4JJZ&1HWAZX%NB7,K"/)<H"0I8@=OI756UG!:1".)``*L4
M5UI)*R,&[A1113`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`*US9
MP72XD0'T..E8!M[W0KII;=3-:/\`>CSW]1[\_P"<9KJ*:RA@0PR#VH`H:=K%
MKJ0(B+)(H^:-QAA6C6-?Z%'<.LL#&.16W<<<U3CU#4-)F2/4<2V['&\#YD]R
M>]`'2T5%!/%<1++"ZNAZ,IR*EH`****`"N7\<2-'HR`?<,PW?0`G^==16+XH
MA$WAVZ4G'W3G\10!YE!Q'C(.&(X&.A-2U1TMF^RE'SYB,0V3GG-7J\V?Q,ZX
M[!1114C"BBB@`IK,J+EB`/4U'-.L0(X+XX7-:&@>%KW7I4N[H^59@XST)'<*
M/Z_SQBKC!RV)E)(S[<W6HS^1IUL\[XY;'`KO=`\*KIV);E_,FR"2>Y'_`.OI
M6_9:;9Z="D5M`D:J,#`JY793IJ!SRFY!1116I(4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%0SVT5S'LE0,/<5-10!S$FDW^
MERO-IL_[L_,T;=#[8_+\JOZ7KD=[*;:<"*Z7JO8_2MBLG4]&6\Q)$YCE4[@5
M]:`-:BN;@U#4[$B&[@\Y%.-X)W;?KW_K6A::]I]V0BS".0XPDGRDYZ4`:E9^
MMHKZ)>*P&#$>M:'TJM>QF6SE09R5XQUH`\5TF4S022-PS.2:T:SK:,Z=J-S8
M2)L:-S@>W:M&O.J*TF=4'H%%%5I[R.#Y?OO_`'14I7*+!(522<`=31:VFH:L
MRKIUN3&3S,W`'T]?PSTJWHGAV]\0.LTR^78*WT+_`.?\^WIUG90V5ND42*H4
M8&!C%=%.C?61E.I;1'*^&O!?]FR_:]0D2>?^%"-P0YZY/4\#TKL@`HP!@>E.
MHKJ44M$8MW"BBBF(****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`&LBN,,H(]Q6;>Z+:W:-E2&(/`.,UJ44
M`<O:7\NBS"SO`[VXX1POW!Z?3_/I72QNDL:O&P9&&01W%1W5K%=0F.100?45
MS<+SZ!J$<$A9[*1M@`Z(3WR>WM0!PFO`KX[OE'"'`&>^%'_UZDJ'56$GBV8H
M58*6)8'W/Y]1^=68=.O=2<0VJ%%;@RGIVZ?G7%4BY3LCHA)*.I65I;JX%I9*
M)+AN/9?<UV^B>";&TA6:^4W,YPW[S@`_3^><U=\.>%;;0D+[C+<.H!8C&`.P
M'Y=^PKI*WITE%:F4IM[$<<211K'&JHB@!548``[5)116Q`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%5;ZQAOH=DJYQR*M44`<'%X'\[4))[J0E/NK'GC&?4?U]
M.]=;8:9#8I\HRW<DYJ_118`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
@B@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`_]FB
`

#End
