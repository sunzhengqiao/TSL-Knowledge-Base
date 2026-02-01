#Version 8
#BeginDescription
version  value="2.5" date="16apr14" author="th@hsbCAD.de"
CNC Tools can now be turned off
fastener guideline added, requires hsbCAD 17.2.0 or higher



















#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 1
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 2
#MinorVersion 5
#KeyWords 
#BeginContents
/// <summary Lang=de>
/// Dieses TSL erzeugt einen Wandverankerungswinkel
/// </summary>

/// History
///<version  value="2.5" date="16apr14" author="th@hsbCAD.de"> CNC Tools can now be turned off </version>
///<version  value="2.4" date="24jan12" author="th@hsbCAD.de">fastener guideline added, requires hsbCAD 17.2.0 or higher</version>
/// Version 2.3  30.11.2009   th@hsbCAD.de
/// Content Standardisierung
/// Version 2.2   06.05.2009   th@hsbcad.de
/// - 
/// Ausfräsung wird nun als Blatt längs geneigt an HH übergeben
/// Version 2.1   07.06.2006   th@hsbcad.de
///    - neue Optionen 'Freistich' je verwendeter Zone
/// Version 2.0   11.04.2006   th@hsbcad.de
///    - Bauteile mit unterschiedlicher Iconausrichtung erhalten unterschiedliche Positionsnummern um
///      die Listendarstellung durch hsbBOM zonenabhängig zu steuern
/// Version 1.9   10.04.2006   th@hsbcad.de
///    - neue Option 'Breite Zone 0' definiert die Fräsbreite in Zone 0. Wird kein Wert angegeben, so wird 
///      die Breite des Stahlteils verwendet
/// Version 1.8   13.12.2005   th@hsbcad.de
///    - Installationsseite wird für hsbBOM publiziert
/// Version 1.7  10.08.2005   hs@hsbcad.de
///    -untere Fräslinie als Eingabeoption hinzufügen
/// Version 1.6   10.08.2005   th@hsbcad.de
///    - Layersteuerung korrigiert
/// Version 1.5   05.08.2005   th@hsbcad.de
///    - hsbBOM wird unterstützt
///    - Hardwareausgabe korrigiert
/// Version 1.4   03.08.2005   hs@hsbcad.de
///    -alle BMF-Winkelverbinder und Zuganker hinzugefügt
///    -Beschriftung mehrzeilig, mit Führungslinie und verschiebbar
///    -Sichtbarkeit über I-, J-, T- und Z-Layer
/// Version 1.3   13.07.2005   hs@hsbcad.de
///    -Z-Abstand des TSL's zur ADT-Wand ergänzt
/// Version 1.2   13.07.2005   th@hsbcad.de
///    - Textfarbe und Bemassungsstil ergänzt
/// Version 1.1   13.07.2005   hs@hsbcad.de
///    -erzeugt Ausfräsungen an den Balken
///    -setzt die Zuganker um die 'Tiefe Milling' zurück
///    -enthält die Verbindungsmittel 'BMF-Winkel 90 R' und 'BMF-Zuganker 340-M12'
///    -übergibt TSL an dxa
/// Version 1.0    24.02.2005   th@hsb-systems.de
///    - erzeugt Plattenausschnitte an der Schwelle und
///      entsprechende Fräslinien

U(1,"mm");

//props

	setExecutionLoops(2);
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
		
	double dTypeW[] = {U(120), U(120), U(90), U(182), U(123), U(222), U(102), U(123), U(70), U(61), U(61),U(220), U(90), 
			U(88), U(105), U(103), U(60), U(60), U(60), U(60), U(70), U(70), U(93), U(91), U(92), U(91), U(92),
			U(67), U(35), U(50), U(52), U(52), U(50), U(65), U(62), U(48), U(48), U(48), U(80), U(80), U(80), U(42), 
			U(62), U(42), U(85), U(85), U(85), U(85), U(85), U(85)};
	double dTypeH[] = {U(250), U(280), U(90), U(340), U(400), U(420), U(420), U(480) , U(502), U(406), U(559),
			U(400), U(90), U(88), U(105), U(103), U(90), U(90), U(90), U(35), U(70), U(70), U(93), U(119), U(120), U(141), U(142), 
			U(67), U(90), U(160), U(192), U(292), U(50), U(65), U(83), U(90), U(90), U(90), U(160), U(160), U(160), U(42), U(62), U(62),
			U(95), U(95), U(135), U(135), U(285), U(285)};
	double dTypeD[] = {U(4), U(4), U(4), U(2), U(3), U(2), U(2), U(2), U(2.7), U(3), U(3), U(2), U(2.5), U(2.5), U(3), U(3),
		 	U(2.5), U(2.5), U(2.5), U(2.5), U(2), U(2), U(3), U(3), U(4), U(3), U(4), U(2), U(2.5), U(3), U(2), U(2), U(2.5),
			U(3), U(2), U(3), U(3), U(3), U(4), U(4), U(4), U(2), U(2), U(2), U(4), U(4), U(4), U(4), U(4), U(4)};
	double dTypeW1[] = {U(60), U(120),U(65),U(40), U(40), U(60), U(60), U(60), U(51), U(70), U(70), U(64), U(65), U(65), U(90), 
			U(90), U(60), U(60), U(60), U(60), U(55), U(55), U(40), U(40), U(40), U(40), U(40), U(90), U(40), U(40), U(40), 
			U(40), U(35), U(55), U(40), U(48), U(76), U(116), U(100), U(80), U(60), U(25), U(25), U(25),
			U(65), U(65), U(65), U(65), U(65), U(65)};
			
	PropString sType(1,sArType,T("Type"));
	String sArLayer [] = { T("I-Layer"), T("J-Layer"), T("T-Layer"), T("Z-Layer")};
	PropString sLayer (7, sArLayer, T("Layer"));
		
	PropDouble dDepth(17, U(4), T("Depth") + " " + T("Milling"));
	PropDouble dWidth(19, U(0), T("Width") + " " + T("Milling") + " " + T("Zone")+ " 0" + T("(0 = Auto)"));
	PropDouble dOffset(18, U(0), T("Z" + " " + T("Offset")));
	
	String sArNY [] = { T("No"), T("Yes") };
	PropString sMill (13, sArNY, T("Lower") + " " + T("Milling") + "-" + T("Line"), 0);

	String sArTool[] = {T("Saw"), T("Mill"), T("|None|")};

	PropDouble dWidth1(0, U(0), T("Width") + " " + T("Zone") + " 1/-1");
	PropDouble dHeight1(1, U(0), "   " + T("Height") + " " + T("Zone") + " 1/-1");
	PropDouble dDepth1(2, U(0), "   " + T("Depth") + " " + T("Zone") + " 1/-1");
	PropString sTool1(2,sArTool,"   " + T("Tool")  + " " + T("Zone") + " 1/-1");
	PropInt nToolindex1(0,1,"   " + T("Toolindex") + " " + T("Zone") + " 1/-1");
	PropString sOS1(15,sArNY,"   " + T("Overshoot")  + " " + T("Zone") + " 1/-1",1);


	PropDouble dWidth2(3, U(170), T("Width") + " " + T("Zone") + " 2/-2");
	PropDouble dHeight2(4, U(290), "   " + T("Height") + " " + T("Zone") + " 2/-2");
	PropDouble dDepth2(5, U(0), "   " + T("Depth") + " " + T("Zone") + " 2/-2");
	PropString sTool2(3,sArTool,"   " + T("Tool")  + " " + T("Zone") + " 2/-2");
	PropInt nToolindex2(1,1,"   " + T("Toolindex") + " " + T("Zone") + " 2/-2");
	PropString sOS2(16,sArNY,"   " + T("Overshoot")  + " " + T("Zone") + " 2/-2",1);

	PropDouble dWidth3(6, U(210), T("Width") + " " + T("Zone") + " 3/-3");
	PropDouble dHeight3(7, U(300), "   " + T("Height") + " " + T("Zone") + " 3/-3");
	PropDouble dDepth3(8, U(0), "   " + T("Depth") + " " + T("Zone") + " 3/-3");
	PropString sTool3(4,sArTool,"   " + T("Tool")  + " " + T("Zone") + " 3/-3");
	PropInt nToolindex3(2,1,"   " + T("Toolindex") + " " + T("Zone") + " 3/-3");
	PropString sOS3(17,sArNY,"   " + T("Overshoot")  + " " + T("Zone") + " 3/-3",1);

	PropDouble dWidth4(9, U(0), T("Width") + " " + T("Zone") + " 4/-4");
	PropDouble dHeight4(10, U(0),"   " +  T("Height") + " " + T("Zone") + " 4/-4");
	PropDouble dDepth4(11, U(0),"   " +  T("Depth") + " " + T("Zone") + " 4/-4");
	PropString sTool4(5,sArTool,"   " + T("Tool")  + " " + T("Zone") + " 4/-4");
	PropInt nToolindex4(3,1,"   " + T("Toolindex") + " " + T("Zone") + " 4/-4");
	PropString sOS4(18,sArNY,"   " + T("Overshoot")  + " " + T("Zone") + " 4/-4",1);
	
	PropDouble dWidth5(12, U(0), T("Width") + " " + T("Zone") + " 5/-5");
	PropDouble dHeight5(13, U(0),"   " +  T("Height") + " " + T("Zone") + " 5/-5");
	PropDouble dDepth5(14, U(0),"   " +  T("Depth") + " " + T("Zone") + " 5/-5");
	PropString sTool5(6,sArTool,"   " + T("Tool")  + " " + T("Zone") + " 5/-5");
	PropInt nToolindex5(4,1,"   " + T("Toolindex") + " " + T("Zone") + " 5/-5");
	PropString sOS5(19,sArNY,"   " + T("Overshoot")  + " " + T("Zone") + " 5/-5",1);

	double dAllWidth[] = {dWidth1, dWidth2, dWidth3, dWidth4, dWidth5};
	double dAllHeight[] = {dHeight1, dHeight2, dHeight3, dHeight4, dHeight5};
	double dAllDepth[] = {dDepth1, dDepth2, dDepth3, dDepth4, dDepth5};
	String sAllTool[] = {sTool1,sTool2,sTool3,sTool4,sTool5};
	int nAllToolindex[] = {nToolindex1, nToolindex2, nToolindex3, nToolindex4, nToolindex5};
	String sAllOS[] = {sOS1, sOS2, sOS3, sOS4, sOS5};
	int nOS[] = {_kNoOverShoot, _kOverShoot};
	
	
	PropString sArt1 (8, "", T("Article"));
	PropString sMat1 (9, "Stahl, feuerverzinkt", T("Material"));
	PropString sNotes1 (10, "", T("Metalpart Notes"));
	
	PropString sNY (11, sArNY, T("Show description"),1);	
	PropDouble dxFlag (15, U(200), T("X-flag"));
	PropDouble dyFlag (16, U(300), T("Y-flag"));
	
	PropString sDimStyle(12,_DimStyles,T("Dimstyle"));
	PropInt nColor (5,171,T("Color"));
	
			
// bOnInsert
	if(_bOnInsert){
		_Element.append(getElement());
		_Pt0 = getPoint(T("Select insertion point"));
		
		showDialog();
		
		return;
	}	

// restrict color index
	if (nColor > 255 || nColor < -1) nColor.set(171);
	
// declare standards
	Element el = _Element[0];
	if (!el.bIsValid()) return;

	CoordSys cs;
	Point3d pt0;
	Vector3d vx,vy,vz;

	cs = el.coordSys();
	pt0 = cs.ptOrg();
	vx=cs.vecX();
	vy=cs.vecY();
	vz=cs.vecZ();

// reposition to wall outline
	_Pt0 = el.plOutlineWall().closestPointTo(_Pt0) - dOffset * vy;

// check icon side
	int nSide = 1; // assuming iconside
	if (cs.vecZ().dotProduct(_Pt0 - cs.ptOrg()) < 0) 
		nSide = -1;
	Vector3d vzE = nSide * vz;
	vzE.vis(_Pt0,2);

// find type
	int nType = sArType.find(sType);

// declare point projected to zone 0
	Point3d ptZn0;
	ptZn0 = _Pt0 - vzE * vzE.dotProduct(_Pt0 - pt0 );
	if (nSide == -1)
		ptZn0 = ptZn0 + vzE * el.zone(0).dH();
	ptZn0.vis(6);
	
// get Grippoints
	if (_PtG.length() < 1)
		_PtG.append(_Pt0 + dxFlag * vx + dyFlag * vzE);
	
	dxFlag.setReadOnly(TRUE);
	dyFlag.setReadOnly(TRUE);

//Flag
	double dF;
	if(dxFlag == 0 && dyFlag == 0)
		dF = U(1);
	PLine pl1 (_Pt0, _PtG[0]);

// defining plines
	for (int i = 0; i < sAllTool.length(); i++)
	{
		int nZn = nSide * (i+1);
		int nTool = sArTool.find(sAllTool[i]);
		if (el.zone(nZn).dH() > 0 && dAllWidth[i] > 0 && dAllHeight[i] > 0)
		{
			Point3d ptPl[0];
			ptPl.append(_Pt0 - vx * 0.5 * dAllWidth[i]);
			ptPl.append(_Pt0 - vx * 0.5 * dAllWidth[i] + vy * dAllHeight[i]);
			ptPl.append(_Pt0 + vx * 0.5 * dAllWidth[i] + vy * dAllHeight[i]);
			ptPl.append(_Pt0 + vx * 0.5 * dAllWidth[i]);	

			PLine pl(vz);
			for (int j = 0; j < 4; j++)
			{
				ptPl[j].vis(j);
				pl.addVertex(ptPl[j]);
			}
			pl.close();
			pl.vis(i);

			// no nail areas
			if (nTool<2)
			{
				ElemNoNail elemNN(nZn,pl);
				el.addTool(elemNN);
			}

			// sheet modification
			Sheet sh[0];
			sh = el.sheet(nZn);

			// tool
			double dDistToOutline;
			BeamCut bc(_Pt0, vz, vx, vy, U(1000), dAllWidth[i], dAllHeight[i], 0,0,1);
			bc.addMeToGenBeamsIntersect(sh);
			
			// define mill
			PLine plMill(vz);
			plMill.addVertex(ptPl[0]);// + vy * dDistToOutline);
			plMill.addVertex(ptPl[1] );
			plMill.addVertex(ptPl[2] );
			plMill.addVertex(ptPl[3] );//+ vy * dDistToOutline);
			if(sMill == sArNY[1])
				plMill.close();


			// set depth of mill/saw
			double dCNCDepth = el.zone(nZn).dH();
			if (dAllDepth[i] > 0)
				dCNCDepth = dAllDepth[i];

			// cnc type
			if (nTool==0)
			{
				ElemSaw elemSaw0(nZn, plMill,dCNCDepth , nAllToolindex[i],_kRight, _kTurnWithCourse, nOS[sArNY.find(sAllOS[i])]);
				el.addTool(elemSaw0);
			}
			else if (nTool==1)
			{
				ElemMill elemMill0(nZn, plMill,dCNCDepth , nAllToolindex[i],_kRight, _kTurnWithCourse, nOS[sArNY.find(sAllOS[i])]);
				el.addTool(elemMill0);
			}
		}
	}//next i

// beam	
	Beam bm[0];
	bm = el.beam();
	
			
// tool
	double dMyWidth = dTypeW1[nType];
	if (dWidth > 0)
		dMyWidth = dWidth;

	House hs1(ptZn0, vx, vy,-vzE, dMyWidth , dTypeH[nType],U(10000),0,1, -1);
	hs1.setRoundType(_kReliefSmall);
	hs1.transformBy(dDepth * -vzE);
	hs1.cuttingBody().vis(5);	
	hs1.addMeToGenBeamsIntersect(bm);
		
	/*BeamCut bc1(ptZn0, vzE, vx, vy, U(10000), dMyWidth , dTypeH[nType], 1,0,1);
	bc1.transformBy(dDepth * -vzE);
	bc1.cuttingBody().vis(3);
	bc1.addMeToGenBeamsIntersect(bm);*/

// show metalpart
	Body bd0(ptZn0 + dDepth * -vzE,vzE,vx,vy,dTypeW[nType],dTypeW1[nType],dTypeD[nType], 1,0,1);
	Body bd1(ptZn0 + dDepth * -vzE,vy,vx,vzE,dTypeH[nType],dTypeW1[nType],dTypeD[nType], 1,0,1);
	//MetalPart mp2(_Pt0 + vy * dTypeD[nType],vx,vzE,vy,U(120),U(60),U(20), 0,1,1);

// drill
	Drill dr0(_Pt0, _Pt0 + vy * (dTypeD[nType]+U(20)), U(8));
		dr0.transformBy(U(30)* vzE);
		
	Point3d pt1 = _Pt0 +U(30)* vzE;
	Point3d pt2 = _Pt0 + vy * (dTypeD[nType])+U(30)* vzE;	
	FastenerGuideline fg(pt2,pt1, U(8));	
	if (nType == 0){
		bd0.addTool(dr0);	
		_ThisInst.resetFastenerGuidelines(); 		
		_ThisInst.addFastenerGuideline(fg);
	}
	if (nType == 1){
		_ThisInst.resetFastenerGuidelines(); 
		dr0.transformBy(-vx * U(40));
		fg.transformBy(-vx * U(40));
		_ThisInst.addFastenerGuideline(fg);
		bd0.addTool(dr0);
		//mp2.addTool(dr0);
		dr0.transformBy(vx * U(80));
		fg.transformBy(vx * U(80));
		_ThisInst.addFastenerGuideline(fg);
		bd0.addTool(dr0);
		//mp2.addTool(dr0);
	}	
			
// show text
	Display dp(nColor);
	Display dpBd(nColor);
	dp.dimStyle(sDimStyle);
	if (sLayer == T("I-Layer")){
		dp.elemZone(el, 0, 'I'); 
		dpBd.elemZone(el, 0, 'I'); 
	}
	else if (sLayer == T("J-Layer")){
		dp.elemZone(el, 0, 'J');
		dpBd.elemZone(el, 0, 'J'); 
	}		
	else if (sLayer == T("T-Layer")){
		dp.elemZone(el, 0, 'T');
		dpBd.elemZone(el, 0, 'T'); 
	}			
	else if (sLayer == T("Z-Layer")){
		dp.elemZone(el, 0, 'Z');
		dpBd.elemZone(el, 0, 'Z'); 
	}	
		
	dp.addViewDirection(vy);
	int nChange = 1;
	//double dada = (_PtG[0] - _Pt0).dotProduct(vzE.crossProduct(vy));
	if (sNY == T("Yes")){
		_PtG[0].vis(1);
		if ((_PtG[0] - _Pt0).dotProduct(vzE.crossProduct(vy)) < 0)  //vzE.crossProduct(vy)
			nChange = -1;

		int dYFlag = 2;
		
		dp.draw (sArType1[nType], _PtG[0], vx, vz, nChange, dYFlag, _kDeviceX); 
		dYFlag = -2;
		
		if (nType != 0 || nType != 1)
			dp.draw (sArType2[nType], _PtG[0], vx, vz, nChange, dYFlag, _kDeviceX);
		
		if(dF != U(1))
			dp.draw(pl1);
	}

// show body
	dpBd.draw(bd0);
	dpBd.draw(bd1);

// hardware	
	setCompareKey(sType + String( nSide));
	Hardware (sArType1[nType], sType, sArt1, dTypeH[nType], 0, 1, sMat1, sNotes1);

// assigning
	assignToElementGroup(el,TRUE,0,'E');


/*on debug
	if (_bOnDebug){
		//Display dpDebug(-1);
		Display dpDebug(32);
		Beam bmDebug[0];
		bmDebug = el.beam();
		//dpDebug.draw(scriptName(), _Pt0, _XW, _YW,1,1,_kDeviceX);
		for (int i = 0; i < bmDebug.length(); i++)
			dpDebug.draw(bmDebug[i].realBody());

		Sheet shDebug[0];
		shDebug = el.sheet(1);
		dpDebug.color(40);
		for (int i = 0; i < shDebug.length(); i++)
			dpDebug.draw(shDebug[i].realBody());
	}*/
	
//export to dxa if linked to element
	if (el.bIsValid()){
		exportWithElementDxa(el);
		Map mapSub;
		mapSub.setString("Name", sType);
		mapSub.setInt("Qty", 1);
		mapSub.setDouble("Width", dTypeW[nType]);
		mapSub.setDouble("Length", dTypeH[nType]);
		mapSub.setDouble("Height", dTypeD[nType]);				
		mapSub.setString("Mat", "");
		mapSub.setString("Grade", "");
		mapSub.setString("Info", "");
		mapSub.setString("Volume", "");						
		mapSub.setString("Profile", "");	
		mapSub.setString("Label", "");					
		mapSub.setString("Sublabel", "");	
		mapSub.setString("Type", sArType[nType]);	
		mapSub.setInt("Iconside",nSide);	//publish iconside for hsbBOM				
		_Map.setMap("TSLBOM", mapSub);
	}


	



















#End
#BeginThumbnail
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
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`\MHHHKSCJ"BBB@`HH
MHH`****`"BH)+RWBR&E7([#DU:TV6UN@)+@3K$3@!`,GWR>G:J4)2V$VEN,H
MZ5+<Z?>W,[)IJ%(CP#+RR_D/Z?G4]KX$OKA5:^ON^2H7/^'/7M5JC(GG1GM<
MPHP5I5!/0$U6?5(0<(KR>N!TKL;/P)IULQ9P92<??P<8KH8=*M83E8QGUK14
M.[)=0\UBM=5O\"V@$*G(S)G=^6*UK+P#+,%;4+PD'[R*/RP3_A7>I!%']Q`,
M5)6BIQ1#FV<@/A]I:H0LDX...F`??CFJK>!98Y,0RP,@Z%LJ?RP?YUW-%-TX
ML%)HR-)T&UTN([5$DK?>D*XX]`.U:@C0#`0#\*?15))*R);N'3I1113`****
M`"BBB@`HHI.@]*`%HJA>:M96,;--,!MZJHR?RK);Q9&S*(+.1AWWG'Y8!H`Z
M6BN8;Q'>2)NM].^;.,&3/'KG'Z5"O]M:HR,TSV\>/NQ_+D^IXS0!N7NL6%@#
MY\X##^%06/Z?6LX^*4D7%M9RNX(!#L%'3/7FI;/P[#&H,X#/USCO6I%86T2A
M4A4`>U`&%+X@O6!6&SV/D8+9('^/X57ECUW4B%ED\J%N&1!C/^>M=4(8U.0@
MS]*>`!P!B@##LO#MO;J#(`6Z^N?K6G'I]M$`%B%6J*`(3:0'K$OY4+;0(VY8
ME!]<5-10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110!Y;15234;>/&&W_[HS41U:(,%\J;G_9KS^5G
M3<T**EL##/`\L\%V"!\JA0H(R.=QS[\`5:@@G,X-MIH=<@@W#DC'7H`/UK14
M9,ES2*%7K".W$S?:HG<KP(N5Y_VCV[\>WYWFT34+KAECB7/(6)`2/KCBN@T[
M1H;2-2ZAG`&>.X[UK"BD[LAU.QS"Z1<W1`^R)$H)&49CG\R:L/X0DG78[;5Y
MZ'!'XUV@4*,`8%+6O+'L1S,XFR^'EI!*&N+AI4'10N"?J:ZJ+3;2%`D<*JHZ
M`#%7**:26P-W(XX(XON(!4E%%,04444`%%%%`!1110`4444`%%,DD2*-GD8*
MBC)).`*Q[CQ/I\,RQ*7E+'&47C\Z`-NF.ZQH7=@J@9))Z5S$VN:M<,4M+-8A
MTRWS'ZBF1:+J-YD:A<-(I8-ACP,`T`;$OB#3(3AKD'D#*@D<U"?$EJLHC\F8
MYZ$+P:DM_#UE`JC8&([D5<73;50!Y8..F:`,-?$=W<JHM[$HQZECD#].?TJ+
M[#J^I@FYN70'.%7A2#V/M73I;PQXV1J,>@J6@#$M/#=K!$$<;L'-:<5E;PKA
M(P/PJQ10`P0QKT0"G``=!BEHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`.'3P"((CY5VC-V5HL`_CDU8M/!H\T->NC1J1^[CS\WMGC'^>E=A16?LHW
MN5SLJI86L84)`@"C`&.!4ZQ(GW5`I]%:$A1110`4444`%%%%`!1110`45!-=
MV]N,S3)&,X^9L<UG77B/3[8?+(9CC($8SGZ'I0!L5'++'#&9)7"(!DDG&*YJ
M?Q!>W;>3I]J4SQYDAR0/7'_U^U)!X=GN$S>7#R,<`ESGH?\`/YT`;CZMI\:%
MVNXL`9X;-4KGQ+8VZ$J))2,<*N./QHC\-VL8P.!^=6H]&LH]N(A\O(%`&;_P
MD<LB_N]/=B<E06YQ[CZ5`VNZM-M,%BL8R=P;))'MZ5TJVT*#"Q@"G"-%&`H'
MX4`<NNEZCJ95[R5BF<F-AQ_A6Q::):6J8V!CG//:M/ITHH`8L2(`%4#%/HHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBLV\U>TLVV%_,E_YYIR?_K=:`-*BN5;6M7NGQ;VBPQL,!FY(
M/K_GTIS0Z[=0HKW+)GA@`,D?4=*`.@GO;6U95GN(XBW0.P&:H#Q'IK;PDK$I
MU'EM_A5"#PO$Y5[H[W'4MR23WK6BT>TB`"IC`QQQ0!CW'B2ZN'5=-LSC.&><
M$>G0?C^E-2PUB\?S)[N5<'@*=N?RQ7216L,(PD8%34`<S'X1@W1M,P<H,#(S
M6C!H-C"/]4#['I6K10!#%;0P@!(U&/:IJ**`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`*MS?
MVMFK-/.B;1G!//Y547Q#I;'`N3^,;#^E4HO#,;R&:X/[Q@-WO5PZ#9''R$8&
M."10`Q_$^FKO"R.[)U"H35*7Q7O`%E8R3'.#N.![5JKH]FI.8U((P1@<U8BL
M+:$`)$`!T]J`.=%[K=_&(2BQ*QPSQCMWQG^=7-+\.PVB[I`"Q`SP,UNJJJ,*
M`![4Z@!B1)&`%4#%/HHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
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
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
0*`"BBB@`HHHH`****`/_V8HH
`



#End
