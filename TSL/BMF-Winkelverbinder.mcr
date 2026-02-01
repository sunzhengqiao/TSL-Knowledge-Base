#Version 8
#BeginDescription
version value="1.6" date=05may17" author="thorsten.huck@hsbcad.com"> 
Verbindungsmittel ergänzt


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 3
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 6
#KeyWords 
#BeginContents
///<version value="1.6" date=05may17" author="thorsten.huck@hsbcad.com"> Verbindungsmittel ergänzt   </version>



// improvements 27.07.2005: setCompareKey

// setExecutionLoops 
	setExecutionLoops(2);

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
	
	PropString sType (0, sArType, T("Type"), 7);
	
	String sArOrient [] = {"X-Achse", "Y-Achse", "Z-Achse", "-X-Achse", "-Y-Achse", "-Z-Achse"};
	PropString sOrientH (1, sArOrient, T("Orientation of Height"), 2);
	PropString sOrientL (2, sArOrient, T("Orientation of Length"), 1);
	String sArSwitch[] = {T("Yes"), T("No")};
	PropString sSwitch (3, sArSwitch, T("Switch"), 1);
	
	PropString sArt1 (4, "", T("Article"));
	PropString sMat1 (5, "Stahl, feuerverzinkt", T("Material"));
	PropString sNotes1 (6, "", T("Metalpart Notes"));
	
	PropString sMod2 (7, "Kammnagel", T("Nail") + " " + T("Model"));
	PropString sArt2 (8, "", T("Article"));
	PropString sMat2 (9, "Stahl, verzinkt", T("Material"));
	PropDouble dDia (1, U(4), T("Nail") + " " + T("Diameter"));
	PropDouble dLen2 (2, U(40), T("Nail Length"));
	PropInt nNail (0, 0, T("Qty Nails"));
	PropString sNotes2 (10, "", T("Metalpart Notes"));
	
	String sArLayer [] = { T("I-Layer"), T("J-Layer"), T("T-Layer"), T("Z-Layer")};
	PropString sLayer (11, sArLayer, T("Layer"));
	
	String sArNY [] = { T("No"), T("Yes") };
	PropString sNY (12, sArNY, T("Show description"),1);	
	PropDouble dxFlag (3, U(200), T("X-flag"));
	PropDouble dyFlag (4, U(300), T("Y-flag"));
	
	PropString sDimStyle (13, _DimStyles, T("Dimstyle"));
	PropInt nColor (1,171,T("Color"));
	
	int nBd = 1;
	
// get entity
	if(_bOnInsert){
		_Beam.append(getBeam(T("Select Beam")));
		
		if(_Beam.length() == 0)
			return;		
				
		showDialog();
		
		if(sOrientH == sOrientL){
			reportNotice("\n " + T("You need two different orientations") + "\n " + T("for the Height and the Length"));
			eraseInstance();
			return;
		}
				
		_Pt0 = getPoint();
				
		return;
	}

// restrict color index
	if (nColor > 255 || nColor < -1) nColor.set(171);

// declare standards	
	Beam bm = _Beam[0];
		
	Vector3d vx, vy, vz;
	vx = bm.vecX();
	vz = bm.vecZ();
	vy = vx.crossProduct(vz);
	CoordSys cs(_Pt0, vx, vy, vz);
	
	double dHbm, dWbm;
	dHbm = bm.dD(vz);
	dWbm = bm.dD(vy);
	
// find type
		int f; 							 				
		for(int i = 0; i < sArType.length(); i++)				
			if (sType == sArType[i]) 			
				f = i;

// switch dH and dW
	double dLenWid[] = {dH[f], dL[f]};
	if(sSwitch == sArSwitch[0])
		dLenWid.swap(0, 1);

// orientation of the hardware
	int j	= 1;
	if(sOrientH == "-X-Achse" || sOrientH == "-Y-Achse" || sOrientH == "-Z-Achse" || sOrientL == "-X-Achse" 
	|| sOrientL == "-Y-Achse" || sOrientL == "-Z-Achse")
		j = -1;  
	if(sOrientH == "X-Achse" || sOrientH == "-X-Achse"){
		if (_PtG.length() < 1)
			_PtG.append(_Pt0 + dLenWid[0] * j * _XU);
		_PtG[0].vis(0);
	}
	if(sOrientH == "Y-Achse" || sOrientH == "-Y-Achse"){
		if (_PtG.length() < 1)
			_PtG.append(_Pt0 + dLenWid[0] * j * _YU);
		_PtG[0].vis(0);
	}
	if(sOrientH == "Z-Achse" || sOrientH == "-Z-Achse"){
		if (_PtG.length() < 1)
			_PtG.append(_Pt0 + dLenWid[0] * j * _ZU);
		_PtG[0].vis(0);
	}
	
	if(sOrientL == "X-Achse" || sOrientL == "-X-Achse"){
		if (_PtG.length() < 2)
			_PtG.append(_Pt0 + dLenWid[1] * j * _XU);
		_PtG[1].vis(0);
	}
	if(sOrientL == "Y-Achse" || sOrientL == "-Y-Achse"){
		if (_PtG.length() < 2)
			_PtG.append(_Pt0 + dLenWid[1] * j * _YU);
		_PtG[1].vis(0);
	}
	if(sOrientL == "Z-Achse" || sOrientL == "-Z-Achse"){
		if (_PtG.length() < 2)
			_PtG.append(_Pt0 + dLenWid[1] * j * _ZU);
		_PtG[1].vis(0);
	}
	
	sOrientH.setReadOnly(TRUE);
	sOrientL.setReadOnly(TRUE);
	
// after changing Grippoints
	Vector3d v0, v1;
	v0 = (_PtG[0] - _Pt0).normal();
	v1 = (_PtG[1] - _Pt0).normal();
	
	// CoordSys for hardware
	Vector3d vxbd, vybd, vzbd;
	vzbd = v0;
	vxbd = v1;
	vybd = vxbd.crossProduct(vzbd);
	CoordSys csbd (_Pt0, vxbd, vybd, vzbd);
	
	_Pt0.vis();
	_PtG[0].vis(1);
	_PtG[1].vis(1);
	//vxbd.vis(_Pt0, 1);
	//vzbd.vis(_Pt0, 150);
	//vybd.vis(_Pt0, 3);
	
	if (v0.isParallelTo(v1)){
		if (v0.isParallelTo(v1))
		v1 = v0.crossProduct(vx);
		v0 = vx.crossProduct(v1);
	}
	
	vzbd = v0;
	vxbd = v1;
	vybd = vzbd.crossProduct(vxbd);
	
	if (v0.dotProduct(v1) != 0)
		v1 = v0.crossProduct(vybd);
		
	vzbd = v0;
	vxbd = v1;
	vybd = vzbd.crossProduct(vxbd);
	
	vxbd.vis(_Pt0, 1);
	vzbd.vis(_Pt0, 150);
	vybd.vis(_Pt0, 3);
	
	_PtG[0] = _Pt0 + dH[f] * v0;
	_PtG[1] = _Pt0 + dL[f] * v1;
	_PtG[0].vis(0);
	_PtG[1].vis(0);
	
// get Grippoints
	if (_PtG.length() < 3)
		_PtG.append(_Pt0 + dxFlag * _XW + dyFlag * _YW);
	
	dxFlag.setReadOnly(TRUE);
	dyFlag.setReadOnly(TRUE);

//Flag
	double dF;
	if(dxFlag == 0 && dyFlag == 0)
		dF = U(1);
		
	PLine pl1 (_Pt0, _PtG[2]);
		
// body
	Body bd1 (_Pt0, vzbd, vybd, vxbd, dLenWid[0], dW[f], dT[f], 1, 0, 1); 
	Body bd2 (_Pt0, vxbd, vybd, vzbd, dLenWid[1], dW[f], dT[f], 1, 0, 1);
	Body bd = bd1 + bd2;
	
// model + hardware
	String sModel =sType + ": " + dLenWid[0] + " x " + dLenWid[1] + " x " + dW[f] + " x " + dT[f];
	model(sModel);
	material(sMat1);
	
	if (nNail > 0)
		Hardware( T("Nail"), sMod2, sArt2, dLen2, dDia, nNail, sMat2, sNotes2);	
	Hardware( T("|Connector|"), sType, sArt1, dLenWid[0], dW[f], 1, sMat1, sNotes1);	
	
// setCompareKey
	setCompareKey(String(dLenWid[0]) + String(dLenWid[1]) + String(dW[f]) + String(dT[f]) + sType + sArt1 + sMat1 + sNotes1
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
	//double dada = (_PtG[2] - _Pt0).dotProduct(_XW);
	if (sNY == T("Yes")){
		_PtG[0].vis(1);
		if ((_PtG[2] - _Pt0).dotProduct(_XW) < 0)  //vzE.crossProduct(vy)
			nChange = -1;

		int dYFlag = 3;
		
		dp.draw (sArType1[f], _PtG[2], _XW, _YW, nChange, dYFlag, _kDeviceX); 
		dYFlag = -3;
		
		dp.draw (sArType2[f], _PtG[2], _XW, _YW, nChange, dYFlag, _kDeviceX);
		
		if(dF != U(1))
			dp.draw(pl1);
	}	

// show body
	dpBd.draw(bd1);
	dpBd.draw(bd2);

//export to dxa if linked to element
	if (el.bIsValid()){
		exportWithElementDxa(el);
		Map mapSub;
		mapSub.setString("Name", sArType[f]);
		mapSub.setInt("Qty", 1);
		mapSub.setDouble("Width", dW[f]);
		mapSub.setDouble("Length", dL[f]);
		mapSub.setDouble("Height", dH[f]);	
		mapSub.setDouble("Thickness", dT[f]);			
		mapSub.setString("Mat", "");
		mapSub.setString("Grade", "");
		mapSub.setString("Info", "");
		mapSub.setString("Volume", "");						
		mapSub.setString("Profile", "");	
		mapSub.setString("Label", "");					
		mapSub.setString("Sublabel", "");	
		mapSub.setString("Type", sArType[f]);						
		_Map.setMap("TSLBOM", mapSub);		
	}	
	
	
		


#End
#BeginThumbnail



#End