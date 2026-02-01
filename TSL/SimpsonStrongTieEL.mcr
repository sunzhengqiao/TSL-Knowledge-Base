#Version 8
#BeginDescription
version value="2.9" date="08jan2020" author="marsel.nakuci@hsbcad.com" 

HSB-6164: change property name to "Model" and write model at hardware 
HSB-6164: include the part in the hardware and correct nr of screws
/// Content Standardisierung

DE
Diese TSL fügt einen BMF Topverbinder EL ein
EN
This tsl creates a connector of type BMF EL








#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 2
#MinorVersion 9
#KeyWords Simpson, strong, tie, top, verbinder, EL, connector, hirnholz
#BeginContents
/// <summary Lang=de>
/// Diese TSL fügt einen BMF Topverbinder EL ein
/// </summary>
/// <summary Lang=de>
/// This tsl creates a connector of type SimpsonStrongTieEL
/// https://www.strongtie.de/recherche/?q=EL
/// </summary>

/// History
/// <version value="2.9" date="08jan2020" author="marsel.nakuci@hsbcad.com"> HSB-6164: change property name to "Model" and write model at hardware </version>
/// <version value="2.8" date="07jan2020" author="marsel.nakuci@hsbcad.com"> HSB-6164: include the part in the hardware and correct nr of screws </version>
/// Version 2.7  18.11.2009   th@hsbCAD.de
/// Content Standardisierung
/// Version 2.6  14.10.2008   th@hsbCAD.de
///    - Excel-Export des Gruppennamens
/// Version 2.4  28.02.2007   th@hsbCAD.de
///    - Teilevergleich verbessert
/// Version 2.3  30.11.2006   th@hsbCAD.de
///    - der Wert 'zusätzliche Breite' kann nun seperat für HT und NT gesteuert werden
/// Version 2.2  29.11.2006   th@hsbCAD.de
///    - der Wert 'zusätzliche Breite' wirkt sich nun auch bei der Breite des Blattes
///      mit der Option 'im Nebenträger eingelassen' aus
/// Version 2.1  30.08.2006   th@hsbCAD.de
///    - schräge Verbindungen sind zulässig
/// Version 2.0  31.07.2006   th@hsbCAD.de
///    - Mehrfachauswahl zulässig
/// Version 1.9  03.07.2006   th@hsbCAD.de
///    - neue Option 'zusätzliche Länge' ersetzt vormalie option'zusätzliche Tiefe'
///    - Option 'zusätzliche Tiefe' bewirkt bei einer Nebenträgerverbindung ein
///      entsprechend vertieftes Blatt
/// Version 1.8  06.06.2006   th@hsbCAD.de
///    - der Wert 'zusätzliche Tiefe' wirkt sich nun auch bei der Höhe des Stirnblattes
///      mit der Option 'im Nebenträger eingelassen' aus
///    - erweiterte Excelausgabe inmplementiert
///    - hsbBOM wird unterstützt
/// Version 1.7  04.05.2006   th@hsbCAD.de
///    - es wird ein normaler Freistich und nicht mehr der Minifreistich ausgeführt
/// Version 1.6  20.04.2006   th@hsbCAD.de
///    - nicht koplanare Bauteile werden nun in allen Modi unterstützt
///    - neue Option 'obere Fräsung in Hauptträger' ermöglicht weitere Varianten
/// Version 1.5   20.04.2006   th@hsbCAD.de
///    - seitliches Blatt bei Modus 'in Hauptträger eingelassen'  ergänzt
/// Version 1.4   20.04.2006   th@hsbCAD.de
///    - der Modus 'in Hauptträger eingelassen' wird nun auch bei nicht koplanaren Bauteilen unterstützt
///    - neue Option 'Details zeigen'
/// Version 1.3   27.10.2005   hs@hsbcad.de
///    -Fräsungen am 'HT' in der Breite und in der Länge um ein Additionsmaß ergänzt
/// Version 1.2   20.06.2005   th@hsbCAD.de
///    - Fräsung bei Option 'im NT eingelassen' ergänzt
/// Version 1.1   20.06.2005   th@hsbCAD.de
///    - auch nicht lotrechte Verbindungen der Stabachsen sind zulässig
///    - neue Option 'horizontaler Abstand' verschiebt den Verbinder entlang
///      Stabachse des HT
/// Version 1.0   31.05.2005   th@hsbCAD.de
///    - erzeugt einen BMF EL Topverbinder zwischen zwei Stäben

//basics and props
	U(1,"mm");
	String sArNY[] = {T("No"), T("Yes")};
	//setExecutionLoops(2);
	
	String sArType0[] = { "30", "40", "60", "80", "100"};
//	String sArType1[] = {"348030","348040","348060", "348080","348100"};
//	String sArType[] = {sArType0[0] + "/" + T("BMF-Nr") + ":" + sArType1[0],
//		sArType0[1] + "  " + T("BMF-Nr") + ":" + sArType1[1],
//		sArType0[2] + "  " + T("BMF-Nr") + ":" + sArType1[2],
//		sArType0[3] + "  " + T("BMF-Nr") + ":" + sArType1[3],
//		sArType0[4] + " " + T("BMF-Nr") + ":" + sArType1[4]};
	
	String sEl = "EL";
	String sArType[] = { sEl + sArType0[0], sEl + sArType0[1], sEl + sArType0[2], sEl + sArType0[3], sEl + sArType0[4]};
//	PropString sType(0,sArType,T("BMF Topverbinder EL"));
	PropString sType(0, sArType, T("Model"));
	int nType = sArType.find(sType,0);
	
	String sArConType[] = {T("Milled in female beam"), T("Milled in male beam"), T("visible gap"), T("concrete"), T("Steel"), T("Element"), T("L-bearing")};
	PropString sConType(1,sArConType,T("Connection Type"));
	int nConType = sArConType.find(sConType,0);
	
	PropString sTopMilling(8,sArNY,T("Top Milling in Male Beam"));
	int nTopMilling= sArNY.find(sTopMilling,0);
	
	
	double dWidth[] = { U(30), U(40), U(60), U(80), U(100)};
	double dWidthOff[] = { U(15), U(20), U(10), U(10), U(10)};
	double dHeight = U(120);
	double dHeight2 = U(55);
	double dThick = U(10);
	
	double dBMin[] = { U(45), U(50), U(70), U(90), U(110)};
	double dHMin = U(160);
	// Screws at the hauptträger
	int nNumDr5[] = { 1, 1, 2, 3, 4};
	// Screws at the Nebenträger
	int nNumDr9[] = { 3, 6, 9, 12, 15};
	
	PropString sHWType(2, T("Screw"), T("HW") + " " + T("Type"));
	PropString sHWDesc(3, T("ABC Spax"), T("HW") + " " + T("Description"));
	PropString sHWModel(4, T(""), T("HW") + " " + T("Model"));
	PropString sHWMaterial(5, T("Aluminium"), T("HW") + " " + T("Material"));
	PropString sHWNotes(6, T(""), T("HW") + " " + T("Notes"));
	PropDouble dHWLength(5, U(70), T("HW") + " " + T("Length"));
	PropDouble dHWDiam(6, U(5), T("HW") + " " + T("Diameter"));

	PropDouble dOffsetV(0,U(0), T("Vertical Offset") + " " + T("(only L-Bearing)"));
	PropDouble dOffsetH(1,U(0), T("Horizontal Offset"));
	
	PropDouble dAddWidth(2,U(2), T("Additional Width"));
	PropDouble dAddWidth2(7,U(2), T("Additional Width") + " " + T("|female beam|"));
	PropDouble dAddLength(3,U(10), T("Additional Length"));
	PropDouble dAddDepth(4,U(10), T("Additional  Depth"));
			
	PropString sShowDetails(7, sArNY, T("Show Details"));
	int nShowDetails = sArNY.find(sShowDetails);
	
// on insert
	if (_bOnInsert){
	  	PrEntity ssE(T("Select male beam(s)"), Beam());
		Beam ssBeams[0];
  		if (ssE.go()) {
			ssBeams= ssE.beamSet();
  			reportMessage ("\nNumber of beams selected: " + ssBeams.length());
  		}
		Beam bmFemale = getBeam(T("Select female beam"));		

		Element el;
		el = bmFemale.element();
		if (el.bIsValid())
			sConType.set(sArConType[5]);
			
		showDialog();

		// set TSL Props
		TslInst tsl;
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		Beam lstBeams[2];
		Element lstElements[0];
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];

		lstPropString.append(sType);
		lstPropString.append(sConType);		
		lstPropString.append(sHWType);		
		lstPropString.append(sHWDesc);
		lstPropString.append(sHWModel);		
		lstPropString.append(sHWMaterial);
		lstPropString.append(sHWNotes);				
		lstPropString.append(sShowDetails);		
		lstPropString.append(sTopMilling);

		lstPropDouble.append(dOffsetV);
		lstPropDouble.append(dOffsetH);
		lstPropDouble.append(dAddWidth);
		lstPropDouble.append(dAddLength);
		lstPropDouble.append(dAddDepth);
		lstPropDouble.append(dHWLength);
		lstPropDouble.append(dHWDiam);

		lstBeams[1] = bmFemale;
		int nInvalid;
		for(int i = 0; i < ssBeams.length(); i++)
		{
			/*if (!ssBeams[i].vecX().isPerpendicularTo(bmFemale.vecX()))
			{
				nInvalid++;
				
				continue;	
			}*/
			lstBeams[0] = ssBeams[i];
			tsl.dbCreate(scriptName(), vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, 
				lstPropInt, lstPropDouble, lstPropString ); // create new instance			
		}

		/*if (nInvalid == 1)
			reportMessage("\n" + nInvalid + " " + T("connection is invalid. Selected beams are not perpendicular."));
		else if (nInvalid > 1)	
			reportMessage("\n" + nInvalid + " " + T("connections are invalid. Selected beams are not perpendicular."));
		*/
		
		eraseInstance();			
		return;
	}		
	
	if (_Beam.length() < 2)
		return;
	Beam bm0, bm1;
	bm0 = _Beam[0];
	bm1 = _Beam[1];
	

/* non perps
	if(!bm1.vecX().isPerpendicularTo(bm0.vecX()))	{
		reportNotice("\n" + T("X-Axes of Beams must be perpendicular"));
		eraseInstance();
		return;
	
	}*/
	
// reset top milling property on some construction types
	if (nConType == 3 || nConType == 4)
		sTopMilling.set(sArNY[0]);
			
// Vectors of connection
	Vector3d vx,vy,vz, vxN, vyN, vzN;
	Point3d pt0, pt1;
	pt0 = bm0.ptCen();
	// find projected intersection to allign vector
		LineBeamIntersect lbi(pt0, bm0.vecX(), bm1);
		if (lbi.nNumPoints() > 0)
			pt0 = lbi.pt1();

	/* parallel
	if (nType == 0){
		pt1 = Line(bm1.ptCen(), bm1.vecX()).closestPointTo(pt0); 
		vx = pt1 - pt0;
		vx = bm0.vecD(vx);
	}

	// as T-connection
	else{
	*/
		vx = pt0 - bm0.ptCen();
		vx.normalize();
	//}

	vy = bm1.vecX().crossProduct(vx);
	vz = vx.crossProduct(vy);
	vxN = bm1.vecD(vx);
	vzN = bm1.vecX().crossProduct(vxN);
	vzN.normalize();
	vyN = bm1.vecX();

	pt0 = pt0 + vy * dOffsetV + vyN * dOffsetH;
	pt0.vis(6);
	_Pt0 = pt0;
	if (_ZW.dotProduct(_Pt0 - (_Pt0 - vzN * U(1))) < 0)
		vzN = -vzN;
	
//Cut
	Cut ct;

	vxN.vis(_Pt0,1);
	vyN.vis(_Pt0,3);
	vzN.vis(_Pt0,150);	

// check allignment: if XY-Planes varie set L-Bearing
	if (!vzN.isParallelTo(bm0.vecD(vzN)) && sConType !=sArConType[6]){
		String sPosNums;
		sPosNums = scriptName() + " " + _ThisInst.posnum() + " " + T("on beam") + " " + bm0.posnum();
		reportMessage("\n" + T("NOTE") + ": \n" + sPosNums + "\n" + T("I-Beam is not in same plane with -Beam.") + " " + T("You might want to change the Connection Type to:") + sArConType[6]);
		//sConType.set(sArConType[6]);				
	}
	
// Error Display
	Display dpErr(1);
	
//MetalPart
	Body bd(_Pt0, vyN, vzN, vxN, dWidth[nType], dHeight, dThick, 0,0,-1);
	Body bd1(_Pt0 - vxN * dThick + 0.5 * vzN * dHeight, vyN, vxN, vzN, dWidth[nType], dHeight2, dThick, 0,1,-1);	
	bd.addPart(bd1);

//drill Body
	if (nShowDetails)
	{
		Point3d ptDr = _Pt0 - vyN * 0.5 * nType * U(15) - (vxN + vzN) * U(15); 
		for (int i = 0; i < nType+1; i++){
			//PLine plScrew(vyN);
			Drill dr(ptDr,ptDr + (vxN + vzN) * dHWLength, U(2.7));
			//plScrew.addVertex(ptDr);
			ptDr.vis(4);
			//plScrew.addVertex(ptDr + (vxN + vzN) * dHWLength);
			//plScrew.vis(3);		
			bd.addTool(dr);
			dr.transformBy(-vzN * U(20));		
			bd.addTool(dr);
			dr.transformBy(-vzN * U(20));
			bd.addTool(dr);
			ptDr.transformBy(vyN * U(15));
		}	
	}
	
// Tooling and transformation
	
	CoordSys cs, csToTop;
	cs.setToTranslation(vxN * dThick);
	Point3d ptTop = bm1.ptCen() + 0.5 * vzN * bm1.dD(vzN);
	if (nTopMilling)
		csToTop.setToTranslation(vzN * (vzN.dotProduct(ptTop - _Pt0) - 0.5 * dHeight));
	else
		csToTop.setToTranslation(vzN * (vzN.dotProduct(ptTop - _Pt0) - 0.5 * dHeight + dThick));	
		
		
		
	if (nConType == 0){	
		if (nTopMilling)
		{		
			House hs(_Pt0 + 0.5 * vzN * dHeight, vyN, vxN, -vzN, dWidth[nType]+dAddWidth, 2 * (dHeight2+dAddLength), dThick, 0,0,1);	
			hs.transformBy(-vxN * dThick);
			hs.transformBy(cs);
			hs.transformBy(csToTop);
			hs.setEndType(_kFemaleSide);
			hs.setRoundType(_kReliefSmall);
			bm1.addTool(hs);
		}	
		
		ct = Cut(_Pt0, vxN);
		bd.transformBy(cs);
		bd.transformBy(csToTop);

		House hs1(_Pt0 + 0.5 * vzN * dHeight,vzN , vyN, vxN, 2 * (dHeight2+dAddLength+ dThick) , dWidth[nType]+dAddWidth, dThick, 0,0,1);	
		hs1.setEndType(_kFemaleSide);
		hs1.setRoundType(_kRelief);
		hs1.transformBy(vzN * (vzN.dotProduct(ptTop - _Pt0) - dHeight + dThick));	
		bm1.addTool(hs1);		
	}
	else if (nConType == 1){
		if (nTopMilling)
		{		
			House hs(_Pt0 + 0.5 * vzN * dHeight, vyN, vxN, -vzN, dWidth[nType]+dAddWidth, 2 * (dHeight2+dAddLength), dThick+dAddDepth, 0,0,1);	
			hs.transformBy(-vxN * dThick);
			hs.transformBy(csToTop);
			hs.setEndType(_kFemaleSide);
			hs.setRoundType(_kRelief);
			bm1.addTool(hs);
		}			
		ct = Cut(_Pt0, vxN);
		bd.transformBy(csToTop);
		double dOnSameHeight, dHouseEnlarge;
		dOnSameHeight = (bm0.ptCen().Z() + 0.5 * bm0.dD(vzN)) - (bm1.ptCen().Z()+ 0.5 * bm1.dD(vzN));
		if (dOnSameHeight==0)
			dHouseEnlarge = U(20);
		House hs0(_Pt0, vyN, vzN, -vxN, dWidth[nType]+dAddWidth2, dHeight + dHouseEnlarge + dAddLength , dThick+dAddDepth, 0,0,1);
		hs0.transformBy(vzN * dHouseEnlarge *0.5);		
		hs0.transformBy(csToTop);
		hs0.setEndType(_kFemaleEnd);
		hs0.setRoundType(_kRelief);
		bm0.addTool(hs0);		

	}
	else if (nConType == 2 || nConType == 3 || nConType == 4){
		if (nTopMilling)
		{		
			House hs(_Pt0 + 0.5 * vzN * dHeight, vyN, vxN, -vzN, dWidth[nType]+dAddWidth, 2 * (dHeight2+dAddLength), dThick, 0,0,1);	
			hs.transformBy(-vxN * dThick);
			hs.transformBy(csToTop);
			hs.setEndType(_kFemaleSide);
			hs.setRoundType(_kRelief);
			bm1.addTool(hs);
		}			
		
		
		ct = Cut(_Pt0 - vxN * dThick, vxN);
		//bd.transformBy(vzN * dThick);
		bd.transformBy(csToTop);
		if (nConType == 4){
			Point3d  ptBd = _Pt0;
			ptBd.transformBy(vzN * dThick);
			ptBd.transformBy(csToTop);
			ptBd.vis(2);
			double dLowerDistance = vzN.dotProduct((ptBd - vzN * 0.5 * dHeight)- (bm0.ptCen() - vzN * 0.5 * bm0.dD(vzN)));
			if (dLowerDistance  < U(40)){
				PLine plErr(vxN);
				plErr.addVertex(ptBd - vyN * 0.5 * dWidth[nType] - vzN * 0.5 * dHeight);
				plErr.addVertex(ptBd - vyN * 0.5 * dWidth[nType] - vzN * (0.5 * dHeight + dLowerDistance));
				plErr.addVertex(ptBd + vyN * 0.5 * dWidth[nType] - vzN * (0.5 * dHeight + dLowerDistance));											
				plErr.addVertex(ptBd + vyN * 0.5 * dWidth[nType] - vzN * 0.5 * dHeight);
				plErr.close();
				dpErr.draw(plErr);
				reportMessage("\n" + T("Warning") + " " + scriptName() + ": " + T("Beam") + " " + bm0.posnum() +"/" + bm1.posnum() + "\n" + T("Distance to lower egdge invalid!"));			
			}	
		}
	}
	//Element
	else if (nConType == 5){
		bd.transformBy(csToTop);		
		House hs(_Pt0 + 0.5 * vzN * dHeight, vyN, vxN, -vzN, dWidth[nType]+dAddWidth,dHeight2+dAddLength, dThick, 0,1,1);
		hs.transformBy(csToTop);
		hs.setEndType(_kFemaleSide);
		hs.setRoundType(_kRelief);
	
		// element tools
		Element el;
		el = _Beam[1].element();
		if (el.bIsValid()){
			CoordSys csEl;
			Point3d ptOrg;
			Vector3d vxEl,vyEl,vzEl;

			csEl = el.coordSys();
			ptOrg = csEl.ptOrg();
			vxEl = csEl.vecX();
			vyEl = csEl.vecY();
			vzEl = csEl.vecZ();
			
			Point3d ptOnOL;
			ptOnOL = el.plOutlineWall().closestPointTo(_Pt0);
			int nIconSide = 1;
			double dOffsetZones = vzEl.dotProduct(ptOnOL - ptOrg);
			if (dOffsetZones  < 0){
				nIconSide = -1;
				dOffsetZones = abs(dOffsetZones) - el.zone(0).dH();
			}
			BeamCut bc(_Pt0 + 0.5 * vzN * dHeight, vyN, vxN, -vzN, dWidth[nType], 2 * dHeight2, dThick, 0,0,1);
			bc.transformBy(csToTop);
			bc.transformBy(-vxN * dOffsetZones);						
			hs.transformBy(-vxN * dOffsetZones);	
			bd.transformBy(-vxN * dOffsetZones);
			ct = Cut(_Pt0 - vxN * (dOffsetZones + dThick), vxN);
			for (int i = 1; i < 6; i++){
				Sheet sh[0];
				sh = el.sheet(nIconSide * i);	
				bc.addMeToGenBeamsIntersect(sh);
				
			}
		bm1.addTool(hs);	
		}
		else{
			String sPosNums;
			sPosNums = scriptName() + " " + _ThisInst.posnum() + " " + T("on beam") + " " + bm0.posnum();
			reportMessage("\n" + sPosNums + "\n" + T("I-Beam is not a beam of an element.") + " " + T("The Connection Type will be chnaged to:")  + "\n"+ sArConType[0]);
			sConType.set(sArConType[0]);				
		}
	}	
	//L-bearing
	else if (nConType == 6){
		ct = Cut(_Pt0 - vxN * dThick, vxN);
		bd.transformBy(cs);
		CoordSys csRot;
		csRot.setToRotation(180, vxN,_Pt0 );
		bd.transformBy(csRot);	
		csRot.setToRotation(180, vzN,_Pt0 );
		bd.transformBy(csRot);
		bd.transformBy(-vzN * 0.5 * (bm0.dD(vzN) - dHeight));
		BeamCut bc0(_Pt0 + vxN * dThick - vzN * (0.5 * bm0.dD(vzN) - dThick), vyN, vxN, vzN, U(1000), dHeight2 + dThick, U(1000), 0,-1,-1);
		bc0.transformBy(vzN * dOffsetV);
		bd.transformBy(vzN * dOffsetV);		
		bm0.addTool(bc0); 
	}
	
	//if (nConType != 1)
		bm0.addTool(ct,1);	
		
// Display
	Display dp(253), dpPlan(9);
	dpPlan.addViewDirection(_ZW);
	dpPlan.textHeight(U(1));
	/*if (bm0.dD(vzN) < dBMin[nType] || 
	    bm0.dD(vzN) < dHMin || 
	    (!bm0.vecD(vzN).isPerpendicularTo(bm1.vecD(vzN)) && nConType != 6))
		dp.color(1);*/
	dp.draw(bd);
	dpPlan.draw(T("BMF Topverbinder"), _Pt0, _YW, -_XW, 0,2,_kDevice);
	dpPlan.draw(sArType[nType], _Pt0, _YW, -_XW, 0,-2,_kDevice);
	
// group
	Group gr[] = _ThisInst.groups();
	String sGr;
	for (int i = 0; i < gr.length(); i++)
	{
		if (i > 1)
			sGr = sGr + "/";
		sGr = sGr + gr[i].name();		
	}
	
// Hardware
	String sCompare;
	sCompare= scriptName() + sHWType+ sHWDesc + sHWModel + sHWMaterial + sHWNotes + String(nType) + String(dWidth)+ String(dHeight);// 
	setCompareKey(sCompare);
	
	//region hardware export
	
// collect existing hardware
	HardWrComp hwcs[] = _ThisInst.hardWrComps();
	
// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
	for (int i=hwcs.length()-1; i>=0 ; i--) 
		if (hwcs[i].repType() == _kRTTsl)
			hwcs.removeAt(i); 
	
// declare the groupname of the hardware components
	String sHWGroupName;
	// set group name
	{ 
	// element
		// try to catch the element from the parent entity
		Element elHW =bm0.element(); 
		// check if the parent entity is an element
		if (!elHW.bIsValid())
			elHW = (Element)bm0;
		if (elHW.bIsValid()) 
			sHWGroupName=elHW.elementGroup().name();
	// loose
		else
		{
			Group groups[] = _ThisInst.groups();
			if (groups.length() > 0)
				sHWGroupName = groups[0].name();
		}
	}

// add main componnent
	{ 
		String sArticle = "Hirnholzverbinder";
		HardWrComp hwc(sArticle, 1); // the articleNumber and the quantity is mandatory
		
		String sManufacturer = "Simpson Strong-Tie";
		hwc.setManufacturer(sManufacturer);
		
		hwc.setModel(sType);
//		hwc.setName(sHWName);
//		hwc.setDescription(sHWDescription);
		String sMaterial = "Aluminium EN AW-6082 T2 gemäß EN755-2";
		hwc.setMaterial(sMaterial);
//		hwc.setNotes(sHWNotes);
		
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(bm0);	
		hwc.setCategory(T("|Connector|"));
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		
		hwc.setDScaleX(dHeight);
		hwc.setDScaleY(dHeight2);
		hwc.setDScaleZ(dWidth[nType]);
	// uncomment to specify area, volume or weight
		
	// apppend component to the list of components
		hwcs.append(hwc);
	}
// add screws of main trägger
	{ 
		HardWrComp hwc(sHWType, nNumDr5[nType]); // the articleNumber and the quantity is mandatory
		hwc.setDescription(sHWDesc);
		hwc.setModel(sHWModel);
		hwc.setDScaleX(U(40));
		// diameter
		hwc.setDScaleY(U(4));
		hwc.setQuantity(nNumDr5[nType]);
		hwc.setMaterial(sHWMaterial);
		hwc.setNotes(sHWNotes);
		hwc.setRepType(_kRTTsl);
		hwcs.append(hwc);
		
	}
// add screws of nebenträgger
	{ 
		HardWrComp hwc(sHWType, nNumDr9[nType]); // the articleNumber and the quantity is mandatory
		hwc.setDescription(sHWDesc);
		hwc.setModel(sHWModel);
		hwc.setDScaleX(U(70));
		// diameter
		hwc.setDScaleY(U(5));
		hwc.setQuantity(nNumDr9[nType]);
		hwc.setMaterial(sHWMaterial);
		hwc.setNotes(sHWNotes);
		hwc.setRepType(_kRTTsl);
		hwcs.append(hwc);
		
	}	

// make sure the hardware is updated
	if (_bOnDbCreated)
		setExecutionLoops(2);
	
	_ThisInst.setHardWrComps(hwcs);	
		
//End hardware export//endregion 

	// 
//	Hardware( sHWType , sHWDesc, sHWModel, dHWLength, dHWDiam, nNumDr5[nType], sHWMaterial, sHWNotes);
//	if (nNumDr9[nType] > 0)
//		Hardware( sHWType , sHWDesc, sHWModel, dHWLength, dHWDiam, nNumDr9[nType], sHWMaterial, sHWNotes);


// dxaoutput for hsbExcel
	dxaout("Name",sArType[nType]);// description
	dxaout("Width", dWidth[nType]/U(1,"mm"));// width
	dxaout("Length", dHeight2/U(1,"mm"));// length
	dxaout("Group", sGr);// group
	model(sArType[nType]);
	material(T("Steel, zincated"));
	
//export to dxa if linked to element
	Element el;
	el = _Beam1.element();
	if (el.bIsValid())
		exportWithElementDxa(el);
		
	Map mapSub;
	mapSub.setString("Name", scriptName());
	mapSub.setInt("Qty", 1);
	mapSub.setDouble("Width", dWidth[nType]);
	mapSub.setDouble("Length", dHeight2);
	mapSub.setDouble("Height", dHeight);				
	mapSub.setString("Mat", T("Steel, zincated"));
	mapSub.setString("Grade", "");
	mapSub.setString("Info", "");
	mapSub.setString("Volume", "");						
	mapSub.setString("Profile", "");	
	mapSub.setString("Label", "");					
	mapSub.setString("Sublabel", "");	
	mapSub.setString("Type",sArType[nType]);						
	_Map.setMap("TSLBOM", mapSub);












#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`:P!K``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`-I!,D#`2(``A$!`Q$!_\0`
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
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BHY98X8S)*ZH@ZLQP!7
M&7WBJ[>4FW801`G;\H+$>^<_I^M1*:CN-1;.WHKA/^%@JICC:U5WS\S(QQCV
M'T]ZZBRURRO8D=)5^;I34D]@::W-.BFJP905.0>AIU4(****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHK.U/5K;3(2TK@R8^6('YF_P'O2;2U8)7-&BO/;CQ??"1B+E(_\`81%P
M/SR:QW\1:G<#9:W=TQ/<2MQ67MEV+Y&>H7=[;6:[[B9(A@D;FP3CT'>N5U7Q
MQ#$QCLEYZ"5_QZ#\CS^5<B;6]GD9KFYSN.2>I/KS4\-A!"%^7>P_B8Y-1*M?
M8I0$N=7U/4Y/,)>4#@;L`#Z#H.E0"SN)Q^_DV*>J@Y-:/2BL7(TL1PV\5NNV
M),#UZDU8BD\M51EW1`YV@D=\G&/_`-7/2HZ*2DT[H+(V=*\4+:7B6MYB&-CA
M#R0?J>U=K&ZR1AT8,C#*L#D$5Y5=6JW,>#PP^ZV.E:/A_P`3G1G^PZ@6,!(V
MM_<]2!W'_P!?\>F%6^C,I0ML>D452M]2L;LH(+J*1G&0H<;NF>G6KM;)W,PH
MHHI@%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%5
M+^^CTZRENI02D:EC@]A0!;HK@Y?B#'<6)-G`1=,#A1\X'OGC/Y&L_P#X2GQ!
M=0X"Q1`C&YEPWY=/TJ'4BMRE%L[^]U.SL%4W5PL>XX`.23^`KF-3\8JR(+!W
MA()+F1!D^@'4>OZ5RTUI/>2&6]NWE?H"!C`]*8FDVR#YC(YSGES6,JM]$6H6
MW+TGBW6KQO+M;DD?W@B@#]*HBTNI7\R>Z)D8Y8@<DYJXD:1J%10JCL!3JR<V
MRU%%1=-MPVYP9&]6JRD:1J%10H'8"G45-R@HHHI`%%%%`!1110`5'-!'.FR1
M<C^5244`9QLKB!\P2[D_NMUKJ?#/BJ3S_P"S]29PY/[MWZ_0GO[?_J%8]07-
MK'=(%?((.0PZBM(U&G<B4;H]75@R@J<@]Q3J\AMM4U31RD8N)A`ARI5ODZ^F
M?YUZ)H.O0:U:[@-DR8#IV^H]N*Z8U%(R<;&U1116A(4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!6%XNN8[7PU>F0$AXRG'OP/U(K=KB_B/
M&\FB0E$9MDP9L=A@C^M3+8:W/-%L)K:V6>W8JQ&6`[5<M->EC=8[M!MSC>O:
MKZ_='TK/FTO?G8XP3P".@KSG)W.JR.A1UD170@J1D$=Z6N/-O?:8QDA=E7(S
MM/!_"M'3O$!+B*]PN>!)C`S[T[B-^B@'(R**8!1110`4444`%%%%`!1110`4
M444`%%%%`",H92K`$'J#4,,+6-U]IM&9/E(:-?XO\.<5/134FG=":N=CH?B2
MTU(_9O.'GKV8;2?P-=#7D=S:%W\ZW<Q7"\A@<9-1MJUVC+%J$LSA.%9V)`^G
MZ5TJM=;&3AJ>P45P.D^(9[:</+-)<0-PRLQ)'N,_Y-=S!/%<PI-"P>-QD,*T
MA44B91:):***LD****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*YWQ%%%<F&
MV=L>8RJ1C.1NP>OUKHJY7QO`[:+-/"!YB+R3Q@9Y_P`^U)@<,!@8%+348.BL
M#D$9S3J\P[!DB"2)D/<8Z=*Y^6'DJPPP.*Z.J]Q:).,_=?\`O`5,D]T-&)!J
M%Y8+L1SY?IC./I6K9ZZPR)_W@]5P"/PJ"3391G:5<=NQK,DA>-\H,$'D47^3
M"QV=O<Q7,8>)@?4=Q]:EKDM-U/[)<9=3AN&'K[_6NJAE6:%)4.589%:1?<EC
MZ***8@HHHH`****`"BBB@`HHHH`****`"F2PQSH4D0,OH:?10!FO;SV@W0DN
M@[=Z[+PAK<364EK<,4=),@$\`'L/Q!X]ZY^HI;=9"&!9)!T=#AA^-:0GRN[(
ME&ZL>JJRL,J01[4ZO+[;Q-J^CSQ">07-OD*`5`&/P[UZ-8WD-_:1W,#91QD>
MH]C77&:EL8N+6Y:HHHJA!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%8GBJW>Z\
M-7L<9VL$W9SC`!R?T!K;K/UO_D!:A_U[2?\`H)I2V8UN>1:>V;;;_<..N>*M
MU2TW_5R?[W]!5VO-EN=4=@HHHI#"H)[6.<'(P_\`>%3T4-7&8-W8M&?F7*YX
M8=Z++5+G3!Y97S8,_=)Y'T-;K*K+M8`CT-9UUIPVEHAD?W/\*E-QV#1FW:7L
M%['O@?=CJ.X^M3UP^R2"42P,4<=P<5MZ;KV\K#>85R<>9T'MFM%)/4FUC=HH
M^E%,04444`%%%%`!1110`4444`%%%%`!1110`V2-9$*.H*GM4VBWMUHUPR([
M/;R<_P"ZW^>]1T549.+NA-7.R@\1KN"7,+0OW5AC'^>*TK?4[6Y(5)`&/8GG
M_P"M7`M=W+1B-KB4HHP%WG`'I6A#+974!!<VE_U60D^4Y[9&>/Y#'X5U1K)N
MST,7!H[RBN=M=3N+!OL^HI@J=H<#`/`Y%=!&ZR(&4Y!K4@=1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`50UD$Z%J`'7[-)_Z":OU1U?_`)`E_P#]>\G_`*":4MF"W/'-
M.VJ9HQU#9)J_5"QP+BXQC/&:OUYTMSKCL%%%%2,****`"BBB@"K-8Q2DMRK'
MN.]5)M&5T&V3+CU'%:M%*W4?D9FFW4]F6@)W!/X2>WM6Y!=PW`^1L-W4]165
M=PL&%S$=KH,FI+=;?4(\@!)UZK_6KC*^C(:ZHV**S;>XDM'$-TV5/1SV^M:5
M4U8284444AA1110`4444`%%%%`!1110`4444`%%%%`&WI^KP"T%E?J[1@_NY
M1@F,<<8]!S_+%6;#6$L)5AEE#VS';'+T!QVQV[<?TQ7-TC(K8R.1T/I6T*SC
MHS.4$]CT^*:.>,/&P93W%25Q5A+>6UFEY!*9K=<+(N#N0]_J.G/O72V>K6]T
MB@N%<C.*ZD[JYDU8T****8@HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"N;\8WB0:/]F(S)<,`!Z!2"
M3_(?C725P_CAY?M=HI"B((Q5NY;(R/RV_G659V@RH*\CA;7$=_+'CEAG/TK0
MK/YCU1``,,""?\_2M"N*7<Z8A1114C"BBB@`HHHH`****`$(!!!&0>U47TXB
M56A?:,YY/(^E7Z*35QE8LZQE+TAX^BR8R1]:D@NGLL1RAGAXV,.<9_I3I(UE
MC*-T-9,BSVF8RQ"MZ<@TU/ET>Q/+<ZA65U#*01ZBEK%M&E\GS+1QG^.,]`:T
M;6[$XVNI24=5-:6TNB?)EFBBBD,****`"BBB@`HHHH`****`"BBB@`HHHH`D
MAGFMV+0RO&Q&"48@X_"JKQ2+*TUO.\4S'<6!SD^I'<\FIJ*:;6PK(T=+\97E
MM=16FIPAE=@HD08Q_GBNZM[J&Y0-$X:O,W19%VNH9?0UK:/+=>9(MJ#N1-^!
MDYP0#U[_`/UZZ:=6^C,I0MJCO:*R],UF#4(\;U60'!7-:E;F84444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%8
MWB6T6\T*X'&^(>:I)(QMZ_ID?C6S12DKJPT[.YX=)_R%(AGIV_"K]49?EOXV
M(/)QT_SZU>KSGT.J(4445(PHHHH`****`"BBB@`HHHH`*8\:2+M=01[T^B@"
MNMMY+%K>1HC['(/U!ZTDY+,K\Q3(,EE^Z?Q[?C5FBG'W=@:N26E^L[>5(-DH
M[=C]*N5SE_:S*WGVS-D?PCG'N*DLM?96$-]&5<<;P/YBJ;3)LS?HH5@RAE((
M(R".]%`!1110`4444`%%%%`!1110`4444`%%%%`!3E9HW5T8JRG((."#3:*`
M!9;B"8SV[_O>3AR2"?\`/\S6Q:^.C`#%>V4BN.%(8$-^/;MZUCU#<VZW,)0G
M![$=JTC5DB'!,]-LK^VOX1+;R*PP"5SROU':K=>.V]_<Z1<("Y5D.491VKTG
M2-<M-4M5D255F4#S4/&T_P"'I_\`KKIA/FW,I1L;-%%%:$A1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%4M49DTB\=&*NL#
MD,."#M/-7:HZO_R!;[_KWD_]!-*6S!;GC]\NU!(#@J>OI5J-M\:MZ@&JU^P$
M&#WJQ"NR%%]%`KS7\*.KJ/HHHI%!1110`4444`%%%%`!1110`4444`%%%%`!
M5:ZLXKI"'4;NQ]*LT4P*-I//IF(9,R09^4@8(]JVH+B.XC#Q-D?RJBRJZE6`
M(-9LUO=6(:>TN'R.2&P015)I[DM'245E:=K<-T@2?$,PZ@G@^_M6J"&4,I!!
MY!'>@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`1D5U*LH(/8U%';FVE
M,MK*T+'J!R#SZ?X5-133:V%:YKZ;K&I!50RP;@#P[[5&,<\^N?>M73O$OF2"
M&\38S'"L!PW)'!_"N3I=S"-T#8#=?\]C[UO&N^IFZ?8]/1UD0,IR#3J\_P!-
M\6?V6?(OHY"">&4@@CVR:[FUNX+VW2>WD62)AD,*W4D]C-IK<GHHHJA!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!56^@:YT^Y@0@/+$R
M`GH"1BK5%)JX'AVIY\I,=<U>7[H^E-\36IM=2GLT3;LE^1,Y^4G*\_0BG#A0
M*\^2LK'6G<6BBBH&%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!24M%`&
M9>Z:K#S(!L<>E+I^HR67[J92T7MV/M6C56ZMB^'CX<<TU83->WGCN81)$<J?
MS!]#4E<W$S1S!HG6";D?[+5H+JSQ.B74&S/5E/'Y4<UMPM?8U****H04444`
M%%%%`!1110`45'/<16R;YI`B^YJG87USJKR+9VOR)UD9OE'N?2J46]A-I&A1
M5;R]5M;?S[FU$L.`=T74?44^VN4NH%ECZ'L>HHE!QW!23)J***D84444`,EB
M29-DBAA4FC:C<^'9Y#N,MH_)'H?_`-5)151FXNZ$U<]`TO6+75(5>"0-D9R.
MAK2KR94NK.X^TZ?.8GSDH?NG\/PK>L/',D/[K5+1E;(`,>#GUZG_`#FNN-6+
M,'!H[NBLNQUW3]1C!BG57)`V2':<GI]?PK4JTT]B6K!1113`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@#RWQ_`D/B6*8$CS$1R2>`<[?Y"LZNB
M^)+(_P!BB5OWD:LQ'L2`/Y&N:A?S(4?&,@&N&M\1TT]B2BBBL2PHHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@"O/:I,.@!]:H74-TJ8_P!8
M!R,UKTF,\55^C%;J,TG45DM5BE5T=#L&5.#Z<].WZ5J5F",*^]0,]"",AAZ$
M>E6(%0<17#0G#-LGPR>P#=1QZ_\`ZZBD]$R6VMRW147G&.X^S3H8I_[I[_0T
MZ2>*$9D<+[4--.P7'TC,$4LQ``ZDUC7FMG(2T0NQ;'')_P#K?C445E>W;;[N
M0L,_<9OEQ]!BM84)2(E5C'<O7.M6T`(C)F<'&$_QK)FUFXN&VJK#YL`)6I;Z
M/:0#F,.<Y^;FKR1)&NU$51Z`8KIAA4MS"6(;V.>72+J^,<ER[!5.0KGFMG2X
M'MEO26^SML.PJ=H;'4?C5J@C(Q6ZIQ2LC+VDKW9>M]=MKC0XK`2C[6CY91QP
M`?7^59$6@W]O;-J-KF1,_.BKU'KCO6?=Z(GV9Q;N0W4Y[UT_PYUDW$<^CW1W
M.JDHQ[CT_6LIPTLS6$^J,^VN%N(0X&#W!ZBI:Z2^TR'2+P7L5I')"[_OE,8;
M()Y/3K_GVIE_H*3P"]THAH2N3$"2<^WK]#_]:N25%K5&ZFMCGJ***Q-`HHHH
M`*9+"DT91U!!%/HH`RL7.GO\JF2'/7T%>C>%=;35--VM*&GB.TY;)([$_P`O
MPKCJ;8P-9ZFES:RB$E2K#L?\.0*VISM+4SG&Z/5**Y_3/$EM<E8)YX5FX&"X
M!R>G%=!77<Q"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`\Z^(`_
MXF49':V'_H35S&GL6LHR:](\8:4=1T@O$NZ>#+*!U*G[P_D?P]Z\VT]PUN5`
MQM.*XJT6FV;TW=%NBBBL#4****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBDH`6BBB@`HHHH`*IW&HV\#&,MF3^[BKE<G+,\VL230OMV,0I'/3C-;4*7M
M)6,ZM3D5S2F_M+4`K6ZO%$G"G)Z'K@?C5J#0FD5'NYGD;`SN/2JD.O36A`N(
MRR>J5T%I>V]['O@D#8Z@=1]17IQI1CT.&55R([?38;<+@9V].*N445H9A111
M0`4444`%5+BUR5DA)CD0Y4IP1],5;HH`EM/%VI1P_9K\I+@!1)(O3'?(Q[9S
MFN@TQ;K[.E]I3H8'SO@)R`?3V]>W:N5F@CF0JZ@Y&*32]4OO#=V[PJ)K23'F
M1$>_8]CUK.436,^YUES+IVJR%;M&L;[(&XC<#[>_&/\`]0K,O-(N+8"2+_2+
M?!(EB!(`'KZ5O6FI:'K\8=&"3$[2CC:X)Z?Y%)-H]W82-/IDFPXP5QP0/:N:
M=)2-XS:.2HI]\)[:Y<W%MY0)RVP?*F?Y"F*0RAE.0>0:Y)1<79FZ:>P4445(
MPHHHH`JWEH)EWIQ*O3'?ZUN>'?%Q@M_LNH&23;]UL@L/8YZBLVJL]C'-)Y@)
M23^\.]7&;B2XW/3M/U*VU*`R6['Y3AE;AE^M7J\GL;K5=(??:3*R]74CAL?_
M`*_6NST+Q7;:IB&<BWNLX\MCU].>]=4*B:U,91:.EHHHK0D****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`:ZAD*GH1BO&Y8XH=<U&.`CRA)D!2,#//&*]D90RE2
M.",&O.->\&3V-Q<:EI\_F><^YH"N,DGDY_7MWK*K%RCH7"5F8U%-1MR`X*GT
M(P13JX3I"BBBD`4444`%%%%`!1110`444E`"T4L<;RN$B1G<]%49)KH(=/TG
M2XO,UB?S)67B!&QM/7&0>3T]N>_!JX0<MB7)(YTD*"2<`=ZS7ENKN3,"N$'`
MQP/Q-:=[>V<UP5MK-%`R!&"7_F3DTU+*XF;?-,4']T<G\Z3IWW8^<R@UXIVK
M(<GL#O/X58%Q+9L$NR-N<;B.?_U>]3W*M8D1PXC1^#)W)KL](\+61L!>-<B[
M9DR)`<XXY`]._P#]:M844]#.4['(QRI*NY&R*?56TC$$ES"%`$<[*,>E6JQD
MK.QHM5<****0QK9VG:`6QP"<5Q]H"DCJP(89!!ZBNRK$U*Q*S?;(SD;ML@'4
M<<$^QZ?A79@IVGR]SEQ4+QYNQ390RE6&14-J\NF7R7$9S&#AO]WOFIZ*]5JY
MYR=CK+:[CN%RIY]*GHT_3[#5=#MKFSD5-1@0K/!#G<0,*&V_3:21QDGO3"QB
MPLN/3<IRI/UK%2ULS=K2Z'T4`@C(HJB0HHHH`****`"D(##!'%+10!5ELD(S
M%\CYR"*TK#QGJFF*EO>HMQ&I`#$$MCTS_7!JO1Y7FL$";F)P`!DDU+BF4I-'
M5VFOZ5X@VP-'LG8$#<05SV&??Z5S.JZ1?6^O26^EL)%506B.``<=OSS3-4\+
M7%C#]H!B5BN2%D`*>QZ?IFH-"\>HFIN^J1_OL8W1XYQQ^'K6$XQ:-X-D%O?R
MK=RV=[#Y-Q&Q4^A-7ZR+B>?7+VZ9;=8X7F,@=AR,]A6M&I2-59MQ`P3ZUQ3B
MD]#IBVUJ+1116904444`%4;^U9@)X1B5>2!_$*O44T[":(+;56N#&S3/YD8"
MJ=Q^7'0#TQ7H^C7W]H:;',3F1?DD_P!X?X\'\:\VN+*.?YE/ER`Y#+_6K_AS
M76T6^:WO5`AFP#(3TQG!'YUM2E9D36AZ915&TU>RO%5H9U(89'-700P!!R#7
M48BT444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!4<L2S1-&XRK#!J2B@#B-7T1K=F?R5E
MMVQ]T[63GL3GMGCWSU%<]/IT\4)N%1GM@<>8!T_WA_">>_X9KU9T61"K#(-8
M%WHSQK-]DPJRJ59,<,#U!_#(XK*I24_4N,VCSZBG:C!<:5*%N8F\ICA9%Y!/
MH:BCE25<QN&'L:XI1<=T="DGL/HHHJ1A113&D1`2S`8H`?25"9T:$LL@4=,X
MR<>H%58H99G*12R2G^\6(4?XU2BV)M%TR,1F.)WYVY`XS]:F2UD>S68,AE9A
M@$Y51UZ#J1[\<]\5/!;>7&%DD>4\?>8D#'H.U3]*M<L=B=7N1AK\6HMQ?%$Q
MC"(%'Z5"FG6ZG<P:1\Y+,Q)-6J*')L+)#$BCC)*(JD]<"GT45(QDL231F-QE
M3VHT_5+KP]N3/FV3GD#@J3QGWX_R*?00&4J1D'@BJC)Q=T)JY@VEV+F]O)&7
M9++(9"!TY]/SJTTT2':TB@CL32WNEB528OKLZ?EZ5@21RVS[)EP<X%1._P`2
M*C;8Z$$$`@Y!Z&EK%MKIK<\?,AZKFMA'61`RG*GH:S4KE-6'5CZC>&*>2U5`
M?.52S'L`2>/Q%;%<UJ2LNML6.0R@J/08_P`<UUX1)U5<Y\2VH"4445[)Y05)
M%.\2E,DQ$Y*9X)]?K[U'10U<:;6J-.#5UBF$6]CSQO'WOR-;5O=1W"`J1GTS
M7(,N<%20Z\J0<$&K<&HDW2%T6W8\%A]S/]/KS4.-MBU-/<ZJBL^.]DAD$5RN
M#5]6#*".E1<NPM%%1RSQ0KF1PH]Z8B2CI65-KD",5B_>$#/R\U3^UWMZF(P0
M6XP!T]ZB52,=RXTY2-TS(,\]"`3T`STYZ"H;76"MY&MBR/</PC;L!,\'.<=O
MZU1BT:>1=MS.2F=Q7/?O6K;6D-HFV)`/4]S7+/%=$=$*%MQE]9RWN4N;F1CP
M&PP(./3U^M1V^DV-LN$MT)[LPR35VBN6524C=12``#@#%%%%04%%%%`!1110
M`4444`%->*.0`.@;'(R*=10!4DT^)F#Q%H7!SE#BK%MKNM:,!FX,L&_)W_-^
M9/.*?01D8JU-HEQ3.ETCQC#>2B.[\N/<>)%R%'ID'^?_`.NNJ1UD0.C!E89!
M!R"*\CDTV/):$E&],G%;.C^+9]+C%KJ$4DD*\*XY*^V?3'^?3>G4OHS.4.J/
M1J*QXO$EA)@&0!CV!S6C!=0W*!H9`P/H:W,R>BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`K75E;WD31S1*ZMUR,UPOB+P;]DB>^TA61E!+0`9#_`/U^O]/?M[[4K73K
M=YKB541!D\]*Y74/'5L8'CTZ)[F4]#C"XQ[\GZ5$^5K4J-[Z'(6#-J,BQ0(3
M-W0=O<^W/6M74='.E1I)=WEMM8XQ&2S8[D`@9Q]:R9-.GO;Y[VZE"22')"C/
MX<_E4\6EP1MEF>3T#'@5R6@C:\F49'N)W*V:%TR<,WR_G5M-+C,0$I+/G).?
MIP/3G\:OJJHH50`!V%+4WML.Q66PME.?+R?<YJPJJBA5``'84M%%QA1112`*
M***`"BBB@`HHHH`*ANK6.[C*2#Z$=14U%`')WFGW%@Q;&^'!.X=JNZ;<QR6X
MCR`R]L]:WF4,I5@"#U!K%O\`08V5IK/,<@YV9^4_X4G%-W0[ENL75$+R1R>6
M`(V(,G<YZ#]#^M-@NI[>78Y;Y."I/%)JH0R0SJ<J3@8Z<UMA96JI,RQ"O3=B
MM1117M'DA1110`4F,C!I:*`'B>9;;[.DA6/.0,`X^GI19Z[<Z?(T5R#.A'R8
MP,4RG75E+:RP><F/-C$@..QY`SG'3!_X%421<&Q]WXDO)8G2*V5$92,D$D?C
M3-&TN^UTA%)D$9W,O(&.>X_+\15>Y+"!MHR>PKHO!VK7-@R3^7D1D@KG`93U
M''Y_7FN?$2Y+7.BA%R);.#3HMT'D"-T.PJ_//U[UJ@`#@#'M3]473-5G6ZM_
MW$TK`/"XP%;`^8-TQ]<>M9UQ::AHTICF1L#^%_RX]N.M>>U?8[4[;EZBJUO?
M07!"JVU_[K<&K-0U8H****0!1110`4444`%%%%`!1110`4444`%%%%`!00",
M$<444`7K34%A417%M%<P@8`889>,<-_GIQBKR7$-O-]HTNX?D9:UD^\2,`!>
MQ]<9K#HK6-642'!,[W3-9M[X;"ZB8=5'0>U:M>:6\QCD7Y@@P0&`Z>_'/\^*
MZ>PUB:(Q1W95XY!\LP/!_P`_YQ73":DM#)Q:.DHIJ.KJ&4Y!IU62%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%)N'J*K
MSWMO;QL[R#"]>>E`%FH9+B&)6+R*`O)YZ5RFKZ]<26L@M`8R<JC'HWZ=LUQP
MTOS'\RYN))9,Y)SC-9SJ*)<8-GH=YXPT:S7<;I9>0`(B&)_6N3U/QM>W@:.R
M4Q+Z1\L>G\7U],506PM47;Y*D9SSS4ZJJ*%4``=A6,JS>Q:IV*BP75T1)J%P
M\QSD(S$C\<U;5%0`*H``QP*6BL6V]RTK!1112&%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110!1NM/$C-+"0LC#!!Z&N;U2&:.1`8RB*<LN<\\<UV
M51S01SH5=>W![BM(5.629$X\RL<8"#TI&94&6(`]ZTM0T8PR;X957<>1W/X9
MZU1CL+5;@FYNGEV]4C3K_GZ5Z2Q4+7.%X:5[$2.KC*G-/JW>1VF\M'&Z`CAE
MY/'X?SK.@E,F[_9.,^M72KJIIU(JT7#4FHHHK8Q$K0O[T:AIVG2[-K0[K<D#
M`.U4`_3'XFLYSMC8].*A@^4)P/FX/U_SFI:NT4G9,O:?M;6+&)T#B295P3@9
M)P#^!(/X5T<XB%S-]G`$.]B@`P-N>/TKE8F:._MW0E7#@@@X(P:Z8=*\['/5
M([L&O=8M;NC:E%*ITW592]G(,1L_/E-T&#V&/P_#-85%<49.+NCK:N:FK^%Y
M;)RYBRBGY9E'!'OZ=1UK)M;M[>4V]T_0?*S5N:=XHO\`3XDA;;/`F`%<<J!V
M!_QSCBL^[2ROY"8HFASR%8YVGT![]NOZXS6G-%[$),FHK,@E:RN&BE9C$3\I
M/\-:2L&4,I!!Z$5+5AH6BBBD,****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"K5K="-6@F#-;.?F"G#*?[R^_\^E5:*:;3NA-7-ZS\1&TN!"<-"5R#M/Y>
MU=+;:O9W(7;*H+#@9KSME#*58`CT-;FDPV>J1_9)U,=R@'ERQN5+C.2/3M^.
M?J:Z:=7F=F92A;5':)(D@RC!A[&GUS<FF:CIDC364YFA`),1'S$^W;^57M/U
M<7+^3*GERCJ"?T^M;F9K4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M11T%`!4<LT<"%Y&"CWJG>:M9V2_O)5SVYX]JY&YUR+5+TB5Y1:K_`,\@,_F3
M^M)M+<:3>QNS^(&E8PV$32R=!L&>_KTJ,VVO7FPR&"!#]Y6Y(]QC\:R)M::*
M,6^F1"SMPNWY0-S=@2>W'I^=0)K6HQQ-$MW(5;.2QR?P)Y%9.O%%*FRQK23:
M="MM!J3O='EN/N`]^O7V_P`GG7LFG*F[N9K@KTWL:NLS.Y=V+,QR23DDTVL)
M5'(UC%(1$6-0JJ%`["EHHK,H****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BJ\]]:VW$LRJ?3/-9LVO!U86D1)_ON,#\N].PKFRS!
M%+,0%'))[5E7NO6T`*0,)9/;D#_&L:=9+ILS3222==OI]!4T6B[O]:VP>BGF
MBUMPW*,]TUW/O<DL>V<U?MRT,06.`L6/WMO^>*T;:TAM8PL:].I/4U/4WU*M
MT,J:SFGMI#*1'\IP!]*P;$D,R$8XZ>E==<@FVD"]=IKF2A6]9@N%901_GZ@U
MVX*=VT<>+C[J9+1117IG`-D_U;?2J<TAC@C*G!#9%6Y>(GQZ57%M+.(V2-G2
M/YG.,A1D#)]!G`^I%+J/[(ZX8JX(."!D'WKI-.FEGL8Y)E*N1UQC/O658:8=
M3OV1CMBBB:5S@\@<X_''\ZWU4(H50`H&`!VKSL=):+J=V%B]^@M%%%>>=H4A
M`(((R#VI:*`*?VA;>[,4ZY@.-O?;]/;V_*K$480M+9W&Y<9*`Y`_#M3;BW2X
M3#<$=#Z55BL)HY"5GV=LKG)I*<EZ!9,T$U5$;9.C*WJ!D5<BN(IQF)PV*ATV
MWEO6^S3>2TS'Y.=N\YZ>F?Y_7JR\TN2!SL1H9D[,,$?A6RLU<C8NT53L[MI/
MW4XVRC\FJY2:L,****0!1110`4444`%%%%`!1110`4444`%%%%`!3XI'AE26
M,X=&#*?0BF44`;UGXIO(G47(6:/=\Q"X8#VQQ6E=/;ZEY=W8W"_:MO$)<!F`
MYQCUZUQ]%:QK2COJ0X)G:Z=K:RL+>Z4Q3+P=_'/:MM6#`%2"*X:"\L[R,)JC
M2+.I&RZ0?,%'8XZ]/?K6HMMJFFKY\,_VRW/S97[V/4#OQBNJ,U):&+36YT]%
M9VEZI'J,61PX&2*T:H04444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`444A.*`%HJK-J%K`/GF49&1SUK#U'
MQC96D1,7[V7H(QU)_P`*3=M0-R[O;>RA,MQ*D:#NQZ^P]3[5CMXPTDLJ17`D
M=ONC!7=],]3[5Y_(^H:Q.9[V20#L6//7L.U68;."#&R,9'<\FL'6LS14SN9=
M=N%0O':LR`$EBI``'?-<UJ7BG4M1;RK*-K=/XI&'3Z`]:KO<W$D2Q23R/&N-
MJ,Q(&/05%4RKM[%*GW&[9'0B>9I2WWMW&>/:G=.!116+;>Y:5@HHHI#"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BH9[J*W4ESDC^$<F
MJAU4D92W8CW.#32;%<T:"<#)X%80\0LTH06V1Z@]?I5*6[U.]W(R,H_N@8!'
MI[_C3Y6%S5O-=MK9C'"//E'9>@_&L:YUJ^GRJR")#GA!SCZU-%ITXP0D:<\]
MS]:N0Z=#&2S*&8^V!2;2ZC,FUMC(Q=T\PD]^<GU)K2CTT,`9VS_LCI5]5"@!
M1@#M2U/-V'RD<<,<0Q&@7MQ4E%%(84444@&NH:-E(R",8K/U&."/2=-*JJW+
M^89!_%MR`N?;KC\:T6^Z?I5/7[41&TGC55B9&C50,8*MD\>GS?I7;@5[]SEQ
M6D#&HHHKU3S1K#*$>U6](,,5K=W4]NTR)&84Y7`E<$*3GT`8C'=1TJJQPI/H
M*@MV`8Q]\;JEJ[*3LCJ]/>2/PJ6C8C_2G#8Z8*Q@Y_.G#@`5E:9,H2ZML_O)
M55E'&"%.3^G/X&M4=!7EXQ?O#TL*[TQ:***XSH"BBB@`HHHH`*=?ZEJ4J0MY
MIF\K(^8!F()S@GJ1U[]Z;11J!0^W0S[3*OE2@YW*./\`&KD6H20+BY4LG42*
M.U0W%FDYW9VOZCO4EJ$M(O*N&W1EOE8C[N?7T'3\Z<9/:0FET-**:.9-T;AA
M[=J?69+:RVK^;;-CG.WL?K5RUN5N(\]''#+GI6C75$W)Z***D84444`%%%%`
M!1110`4444`%%%%`!1110`4444`%:NEZY<::GE;1-#G.QC@CZ'M65134FG="
M:N=`'4R_VOIRA1C%S`H^96]?I[^WUKI-/U.WOHQY<BE^X!SBN`M[F:UE$D$C
M1OZ@]?8^H]JMIJ$AF$X(CF4#@':K@=?H>_H?8XSTTZR>C,I0:V/0J*S-+U:'
M4(5P0)`.1G/-:=;F84444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`44QI$C&68*/4FLZ^UZSL<AWR:`-2HVEC0X9U!Z\FN6OM7U&
M2WDE2/R(1P'?C)[8'4Y_S[<Q<R7E]'LN+IUC_P">:'CKWSU[5$JBCN5&+9VU
M]XMTBS!4WB.V.D>6'YBN;O?%5YJ+F.TC*6_(,F[:3]/YUB1:;;1G)0NWJQS5
MOI6$J[Z&BIH=,[3/N9F/'.3G)QS48C0,6"C<<9/TIU%9.3ENRTDM@HHHJ1A1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44R2>*+[
M\BK]35&?5X(XBZDGD`<<MSV_QJE%O83=B^\BQC+'Z`=32Q:?J>HVYDAC2VAP
M=S3DJ0!U/3@=:S%UZ[D6'98*65MRD]/RXYX'/M45Q<:I??-/)R/N@G@>O`Z=
M*NT([ZDZLUIM#71V)U&:.(==SN&+<]@.2><U0N]0:]/DZ=`;6SQM=R?GE['/
MM[=/Z5(]/4/OF<R-^0JY4.HNA2CW(H+:*W7"*/KW-2TM%9EA1112`****`"B
MBB@`HHHH`3VJ'Q:RQ:FM@BE4@:0@=1\S=ORJ>FZS'%/X=M[P+EQ.(P2>@PP(
M_-*[<$_?L<V*7N'-T445ZIY@G;%486V7VSJ=I!_G5^LY`1JASZG^5+J/H77N
M'M'BN(W>.1&X9#@C\:Z>(@Q+CTKD[U2T2@==W05U<2A(450``!@#M7FX_='=
M@]F24445P':%%%%`!1110`4444`%(0""",@]J6B@!AOI+;B:,R0=`X/S#Z^M
M*]NLI%S9R\]RI_0_I2D`@@C(/:F10QP2&2)=K'T---IB:1/;7KM+Y-PFQ^Q'
M0_X5=JO;6`U::.U:>.*=N%:3*ACV''?_`#Z"I;S2-8T*(/<*)X,XR"3C/3G%
M:J/,KHB]M&/HJ&VNH[I"5RK#JIZBIJ@H****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@"HUH\-TMW9R&*=3GV]ZZFR\:Q1JL>H(89.`21\I/L?3_&L
M&D95888`CT-:0JN)+BF>D6=_!?)N@<,,`\'-6Z\JT[4I_#=_Y\8+6+G#Q#^$
M^HKT33]9L=1@$L$ZD=^V*ZH34D8RBT:-%%%62%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!129`K/U#6++38B]Q.JX[9H`T:AFN8;="TLBJ`,G)KEGUZ;4E;[#<P
M1+U5I9`GTJK>R00IMDNS=S'JD;$1IQ_>[_ACOTJ7))78U%O0U[OQ-&LK06D3
M32@'Y5Y/Y5CW_B'5%FDA$021#C.\<>QQGFLT74X!"R%`4",$^4,OH<=>IJ&L
M)5_Y314^Y))J.JW+%I+E8@>"J#.?KG\:2TEEL]I1E9U.0[QJQ'YBF45DZDGU
M+Y46+J]N;UP]Q,TA'0'@#Z#H.E5Z**EN^Y04444@"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBF&50^P99_[JC)%-*X#ZCEGBA&9)%7
MZFLJYUG$OEH-J8R75@3]/3^>/TJ!KAKB139P-$<!7D9MS$COGM^%4H]63?L=
M&NLZ+90;9[9[FYSAP7*A/I@9Z=<^E86H:@]]S8;D#G&U,A5`]SS^M1PZ>JX:
M9M[#L.@JZ%"@!1@"AU$E9(%!]69$>C/(V^[N&D;T'2KT&GV]N043D=S5JBLW
M)LOE0G2EHHJ1A1110`4444`%%%%`!1110`4444`%%%%`!5'4KB6+2+:R*`1M
M(TA..203C]'_`)5=)P,UK:EX?&I:)=W4.(OL1:1-^<E`.5_(#!YZ>^:[,'I.
M[.?$W<+(X2BBBO6/+"J$?S:ED#A<Y_S^-7ZI*!'J/3`<4GN-;,NIL$\9=`ZY
M/!.,'!P?P//X5T<?^K7Z51T6U>[M]72,J"EB9/F]%D1C^@JU:G,"YZBO,QWQ
M(]#"?`3T445PG6%%%%`!1110`4444`%%%%`!1110`5W>@ZA'KFF2V%V,RK'M
M8L<EUZ!N>X[^^#WKA*FM;NXLIA-;3-%(.ZGKWP?4<=*TA/D9,X\R(]0TZ6QO
M9&B(,D3%2!T.#S4]K=)<QY7AA]Y?2MXM#XC*RQ,D6HE3YD#$A9,#JI_I_ADX
M]_X;U:P<7<=J^,X*H0V?J!FKY6]B+VW%HJM;7T-P,!MK_P!TU9J&K%A1112`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****``@,I4C(/!%5TM?L\OF6LK0M
MG.!ROY58HIIM:H5KG265YJMO:K.!]IM6Y5@,8`.,'/.?7K70V&H17\`=&&[H
M1GH:X*&\NK>)HH9Y(T8[B%;'--M;N:SF\Q9"0#G'X=/\_P#ZNJ-9/1F3IM:H
M],HK(TW6X+M=CL$E!VG)ZG&:U00P!!R#WK8S'4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`445#-<0VZ,TLBH%
M&22>@H`FJ.6>.!=TCA1[UR-SX_L4D:*VAF<\A6P.3VP/2LI]8GU!Q)<1MY18
M-L)VDCTXZ?\`UZAU(KJ4HMG7W/B"TMU)&7((SS@8]<UB:AXLG0B."U<EAN4]
M,C.#U_'_`#TIG5_*7;:6EO``,*Q&]QZ\G@_E6?)+)-(7E=G<]68Y)K*5=?9*
MC3[FF^ISRVV][[#@9";26SGUZ#\_SK!DMGN91)>3O.PZ!C@#\*L45E*K*1HH
M)`!@8%%%%9E!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`444C.J+N9@H'<T`+3E5G=412S,<``9)-1PR)<2".%@['TY`XSS^1K36
M7^S;.9Y)!:J^!YN?G/L/;O\`A[5I&FY>A+DD8][>0:<[)=OY4B]48'=^76L2
M;Q7'EEAMV/HS'V]*2Y>359R50(@^7V`_J:GBTRUBP?*!8=S4RY8[#5V55O=4
MO\``Q1D=N/UI(],N-I5I\`_4YK7HI>T?0?*5(;"*,DM\Y]^E6NE+14-M[E)6
M"BBBD`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`$%VVVTE)./E-
M=%XEOY-)\*0Z?'N$MXQ4OG_EF,$C.>^X#Z%JYK4/^/&0?3^=7_%4YN?#WA^<
MYRR2@Y]1L!_4&NW!6YK,Y<4WRZ'*4445ZIYH51G+?VA$%[`?_7J]5-QNU`$?
MPJ*3'$TK>_N-.6<P2;!/&8),*#N1L9'/T%;5L/W(/K7,73^7#N'4$8_.NGMO
M^/=#[5YV/6J9WX-^ZT34445YYV!1110`4444`%%%%`!1110`4444`%%%%`!7
M1Z)XG:RC2SO5,EOG:LG4QKZ8[C^7OP*YRBJC)Q=T*44]SO;K0=&U^%KB(([M
M_P`M8C@J<=/8].#7(ZKI>H>'I1O#W%GGB3&2![_G52">6UG2:&0I(ARK#M7H
M6GW=KXDT@QW"1LQ&V:('[I['\>H_^M73&2JZ/<Q:<-3AXY%D0.A!4]Q3J'T2
M]T>^D@E*-`Q^1LX'7`Z]/SI2I5BK`A@<$$8(-92BX[FB:8E%%%0,****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@!6>3!*N=V,9//I^G`K8TO5=2C3
M:I29@P!3=\Q'<@=3^&<8K&IRLR,&1BK*<@@X(-:0JRB0X)G?Z=K%OJ$>58*_
MH36C7G-F_FZ@AEN!`6&SS<8QUP3CW/4^M;JZAJ&E;3=1FX@;D2Q8*X['.>.W
MYUU0FIJZ,I1:.IHJK:7L%[&&B=6]0#FK562%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`454FU&V@(#2`DC(`-9$WB>-\I9Q/-)R`%&:`.A
M)`ZG%4KO4[6SB9WE7"C)YZ"L:*PU?4B);BX^S1GH,$MV[9X[US.I0Q/>.@GF
MN(U^4EV^5R.IP.,=,=>E1.:@KL<8W-6;QF]X6%I!,L8.-Q`&1ZCFL:\EN+\,
M)IWPQ^8*<9'I[9[TG2BN9UI,V4$B.&WB@4+&@4"I***R+"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**.E-$L9)!E10!DE
MFP`*:3>PKV'4LZ26T8DEBD567<OR'YAZCUI#JEJJK;V\(=V4B2>4=.F`H/`^
MIYY[5`\I:[$EU())-Q#LHWX[9!)&>/3BM522UF[$\S>R(A'?7CDQLEM$@W98
M\L*SFM&\\I<3&8(1G;\WU`SP#6U)>6R0&&UMB#R/,D;)Q[#H._KU]@:H]*4I
MQ6D1J+>XD-Q>0(T<"V\"`_(54[A[D]S4$T,]Y,)KVY:9P,=,#%6:*S=23W92
M@D-1%C4*B@*.PIU%%9E!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`07:-):N%.&`R.*Q;K5)KL06DIQ%:*4B4$XY.XD^YS^
M0'I70$9!%<]:VZ7IG0KG8V58<>W]*Z,/55*5V8UJ;G&R(Z*BE,EI,4F5MG9\
M?I3U96&5((]J]B$U-71Y<HN+LQU4G.W4E`'WEJ[6?,Q34D9AP`,8IL41]\WS
M*#P`,YKKK?B!,>E<Q-%YACQR0PX_&NCL9/,ME->=CMT=V#V99HHHKSSM"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`I\4TL$HDAD:.1>C(<$?C3**`.B
MM?$L4UE]DU6!Y]H^69,%CZ9!Q[\Y_P`:HW+VJ`I:3)*BG(R-KMVP,XST_P`Y
MQ672$`C!&16JJNUGJ1[-7NBS#?6\R@B0`DXVMP<U8!!'!S7.RZ:WV@R0LH4G
M.ULXSWJS!;2`>;;NR.OWHSZ_U'I233'J;-%4(-1^;R[E=DF<9'W:O(ZR*&1@
MR^HH:L),6BBBD,****`"BBB@`HHHH`****`"BBB@`HHHH`****`"I8;F:WW"
M*5D#?>`/#?4=_P`:BHIIVV`D@O[W3[GS[8H4+%GC.5SZXQP/RKK]`\11:M!\
MX,<H.&5AC!KC*N:7!&T\OE2>5=N!Y?8.1GC/KTQ^5;4JKO9F<XJUT>C45CZ7
MJOV@M!-\LR'!R,?Y_P`_CL5U&(4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%0RW,,*D
MNX``R:R+SQ"D;^7:1F>7^ZO.?RH`W:0G`YKF6U+69`98[-HXNOSX4*.Y))^M
M9LFK74\C"6\CA1=VY0"Y8CIMQQ^.:3:6XTF]CKYK^VA7+2K[<UP^M>*;V[NG
MM--'EQH</*<$9XX_7_\`5BHVGM!YN()I2V=IDFX#=F*X_3-48XTB0)&H51T`
MK"=;I$N,.Y/'<SIAG97E&/G9<^O8\=_2IDU.\CD5XIS&5YQ&`H/U`X/XU4HK
M!SD^IKRHM'4;UHWC:[F9'7:P9R<C\:JT44KM[C"BBBD`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%7['3TGQ+<S""V!^\W!?KP
MOJ>*R=3O[.W:9+8ROAMJ%_E/?T!SV].]:*G)JY+DEH6!R0H&23@`=Z2\FL[.
M)0UXLER_2.)=X''<YK#B-W,<SY"@Y`XS^)QS70Z3J&F:20\>D>;,.LCS9.?^
M^>*J/LU\3$^9[(;9:)J6KH)$@-M'O(/G#<Q'IV_E4SZ;HFE,1>7$M]=1KL:)
M>!G'<]/8]<5;O/&$T]FT%K;?97;C>LFX@>W`P?>N;IRK):0$J;>LB2XF$\H<
M0QQ`#"I&N%6HZ**YFVW=FR5M$%%%%(`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`KWDABLY7'7&!SC&>*H:$
M`;=W_BW$'BM.:-9(71AP1BLW0AMMY5/4.10A&E)"D@PPK%O]),0\ZU`5E'W0
M/O>V*WJ2KA4E!W1,X*2LSE8IA(O0JPX*GM5&<'^T1CL1_*NHOM,2Y!=,++V-
M<Y=QR6UU!YX`;!/!!X_#I7JTL3&I'S//J4'!Z;%MSB(G':MK2<M9(Y.2P!-9
M$UC=2P+Y2*0R@D`\CZ_Y[_6MO3;=K6PBB88<#YOK7/C:D9)),WPL)1O=%NBB
MBO/.P****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*L6-T+.
M\29HDE5#\T;C(857HI^8&WJ-_H>H6N\:?);W8''DA2OTZCKZX_E7-Q3I:3EH
MI-T!/SK@Y4_3M5FJ=S8+.^]7*/ZBJ]H^I/(D;:L&4,IR#R"*6N5M]0NM*N/)
MES)`O!4=1[BN@M=1M;S`AE!;'W3P:/0"U1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`$DE[?*_FQ3!I,8/F<[O<GKFM70_&9#"TU?*S9^1\
M#YO;CO\`SK&ILD22+M=0P]#6L:K6Y#@F>FP7,5RFZ-P>U3UY+;MJ&DN)-.N&
M*@\Q.>",]/\`/-=MH'B6/5$V3#RYU^\IX(_#_/\`.NF-12,I1:.DHHHJR0HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBH
MFFBC.&=0<9QGF@"6FLP498@#WKFM7\8Z?IB%8CY\_&$4\?B?Z5S-YXDU;6#M
MC1;2`]2?F/X5#FEN4HMG?W&JV=N&W3+N49P3C-<UJ/BB7&RUBSN'!)P!SW_7
MUK(M9XH0OVBV6Y9/F0NQ&&Q@9'0CVJ.:4S3/*P`+'.!T'L/8=*SE65O=*5-W
MU-2TFT^Z`_M*YN4?J<9V_3(YYZUI6NM:+IH,5I:RJO3<JCYO?).:Y6BLO;2+
M]FC5UG66U1T1$,<$9)`)Y8^I[=/ZUE445FVY.[*2MH@HHHI#"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBG*K.ZHBEF8X``R2:`&T5:
MN+,V<>^^GAM,@;5E8[B#GG:H)'3N!6)-J\$>-K`YZ8YIM-"31HT$,$9PC,J]
M2!G%8\/BNZMGQ:V=N9<_+(ZEF'3&!G`Z=<9J*1M1U(A[NX95Q]WJ3]2>?2K4
M4E>3%=]$6+C6HHI!&O+D<#&?Y4BZF3!NE1W8XXC4C'YBDBM8HNB_G4U)5%%Z
M(?(WNPFOKN\<L49&#96>5MS8^G8U&D(0[F9G?NS'-2T5$JDI;C4$@HHHJ"@H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`0\`UCV$_V>>19<[6.0_;G_\`56P?ND5)X0B6
MYO)+":,2"967:>@*\@D=^A'XUI!)Z,F3MJ1CD4M6KC3!8I(J2<1MC8^<A>.A
M/7D_ECWJK4RBXNS'&2:N@JI-I\%Q.)I%W$#IVJW123:V&U<:JA1@#%.HHI`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`07%I%<@>8#D=QUK,N=&*`O;L3CMWK:HH`Q+;6KR%3#(X<]`S#)'^?>MC3
MM3-PXAF`\S'RL!UJO=6$-RC#:JN?X@.]8FZ:RF\N7(9>0P_G0[[H-#MJ*H6&
MIPW42*T@$N,$'^(^W^%7ZM.Y(4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!43Q-YJS0R-%,O1E[_6I:*:;6PFKFSHGBMH6^RZF%C.?E;.%/OGM^
M-=K%*DR!XV#*>X->6S01SH4E0,*6PUG4/#CH%<W%IT*OV'U[?R]JZ85KZ,RE
M#L>JT5G:9K-GJMNDMO)]X9VG@BM&MS,****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`*UZCO:N(F*N!P17CNI2W7]K-#J=P[)DA-O`7
MIT]/_P!5>U$9&*X77?#\5WK,<,K%89,A6`Y#D<'\_P"=3*-T-.S,""VME0-$
MBD=FZU8Z5DL+O0]1FL;E"41L#Z=B*U(Y%D0.ARIKCE%IZG0FFM!U%%%0,***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BK5A;QW%R
MHFD\J`<N_H/0>YQ4=_J&AVC-'$E]-*#]W*CCUZ?I5J#:N2Y).Q#5"?6+6!R@
M8R,OWM@SBJE]<W&J3C9;I:0?PHA+?F3_`/6H6*"V7+8S[U+LF,MVVN1)+YDF
MG-/&.B&79GZX!IJ:U?QM+)!'#;%LA6&690?0G_/-9_VEY7*VT8.._:G):SRY
M\^3:I[*>:I2L*URK*PFE9G=YY,Y);DG/7\:<EG-*%_=^6N>_7%:D<21+MC4*
M/:GU'/V*Y2""UBMQ\B\]V/4U/114E!1112`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`*N^`K9Y?$9E4?+`'9R??('X\_H:I5U'P_M5A6XG!!,^3[C#,,
M5M15Y&=1V1TFL:+#J2!^5F3E6%<W!IEC*7T^]A%O=D!8[A<@$@#'R]/\>>]=
MU5"_TNWOU'F+\R\@^]=KBI;F";6QYOJ&F76F3".Y3:&R48'*L/4'_)YJI78Z
MIHNH&S>"*4O'@85_F`(Z$9Z=_2N(\[R[I[69#',A(*GOCTKBJ4N3;8Z(3ON3
M4445B6%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!4<L,<R%'4$&I**`,*[TEK=?-MV8J.H[BDL-5N+<^6&QC
M^!N0?I6Z0""",@]JQ[G1Y&):)UXZ9ZT,#7M=8AEPLP\I_7^$_P"%:5<4QD@8
M).N#TW#I6WI.HG<MM(<J>$;/3VH3:=I!9/8VJ***LD****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@!UD?L#M);L\;9!"IC!QV_D?PZ<UOV?C>UB`C
MOM\;`XR5/^'-<]2.B2+M=0P]#6L:LHJQ#@F>B6>JV-]'OM[A'&`3@]/KZ&KX
M.:\IM(5L;@2P%E_O+N.#75V\6KVL$=Q$YN+<H'4#[V"`>03U_.NB%12,I1Y3
MJZ*R;'6HKAS#,/*F!P5/7/TK6K0D****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`KF]<42ZOIR$X!E&2#[]/Y5TE<[JZK'J]E*PR/-7C.,<CG\Z`*
M?C/P_+J=NEW:+NN+<',8ZNOM[^W?->>V=Q);GS$^:(_>3T^E>X5RVK>'HT\^
MZM+:)P^7>/R@6)[X]<UG*GS%1E8Y2*198U=#E2*=5FPM].-S]G<26I.02Q^Z
MWOGW_P#UTM_9/I]V\#G<!RK`8#`]#7-.FXFT9)E6BBBLR@HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHZ4`%%5VNQ@F&*6<`X)C4D?G5:_NI;>)5E5HI7&=
MAX*CGJ<=_;%4H-BNC10J\OEAANQD^P]:+NYLX85C3S3<E?FY'7TQCCMR3SZ=
MJQ?[6$5OY2!$.,.R+AGYSR>O_P"OTJ%;B3.$MR#V.,56B6BN+5FA]JFC5CN2
M%"N#M4$D>Y/.<=ZI->0(^!\S$Y)ZGZU&8;JY8"4;$SSSS5R.".+[J`'UJ'+N
M[C2[%5I;N0'9$1SWXI4L"Y#7#EC_`'1P*O45/-V*MW&HBQKM10!Z"G445(PH
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`KI?A]=,[W
MEL[?ZE@!^)8_XUS5;'@PF'7KALY#A!TX'7_`UO0=I&=5:'I5%%%=ISA6/K.@
M6FJV[+)"I?'6MBB@#RN;1;BTF,.\$``+O."3TQG&/Q.*IRQ/#(8Y%PP[5ZM=
MV$%Y$R2(#GO7%:UH,UJJ@,&BC7"87H/3Z?U)]>>:I06\36-1]3G**:KJ^=IZ
M=1Z4ZN0W"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`AGMHKA"KK^/<5@W%G<6;G:"8_7'%=)24!8JZ-
MJR2*MK-\CCA"3U]JVZP;S3XI4)1%5^N0.<TW3];>(_9[_.X8`;N/KZU2V$=!
M10I#*&4@@\@CO13$%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`5
MO:)KPLHQ;7()A!^1E'*Y/.?4=_6L&BJC)Q=T)I/<[G4=-MM3B6ZMW3STR8Y$
M.0Q]#CKTIFB:H)X?(G.V9.,'@CV/I7*V>IWE@C);3E%8Y(P",_C5V;4;>]D2
MX)-I>+GYPFY'..">X[COP:Z8UHO<Q<&CN:*Y6+5]0LD1KF/SX6)_?1D,F`>>
M1^E;%CK-G?(#'*H)]3^=;$&E11U%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!6!XEMQ);QNORNK`[^A&"".?J*WZSM9B272I@XR`N<8H`N0.LEO'(IRK*"
M#Z\5+63X<E>70[8N<L`5Z8Z&M:@#G/$7AS^TE%S9E8KQ>YZ/]?>N4_M2>]*Z
M?J"!-2M_E&[Y2Z^AS^8Y[FO3JP]<\/PZLHDY69>C#@U,HJ2LQIV=SB>02"""
M."",$456O8]2TFY*7T#.JX7S47[W/7Z^WH*E@GCN(A)&V5-<<X.+-U*Y)111
M4%!1110`4444`%%%%`!115.?4[6#(,FYA_"O--*X%R@D#J<54MM1BD8-+#-Y
M;?<"?>;W]A^=49I3=.=LL\"$\`$.PXSGL*OV;M=Z$\RV1?N=1MK7`=\L>BCF
MLYKZYDNPLL;+L8?NEY[?Q?X?I3DTRR2+),LLQ.<O\NS!XQ@\G^7OU%@`+T'?
M-+FC';4+-[CUO[Y9"T44$2,<D-EC],@BJ;V9GE,MS,TKDY.>`:M45,JDI;LI
M02(T@BC.4C4'UQ4E%%04%%%%(`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"M7P?"TWB*9U+`1J@([-US^0_G656[X&
MW?VS==0O&.."<<\_E6U#XS.K\)Z+1117<<X4444`%1RPQSH4D4,OO4E%`'%Z
M_P"#DG1[JQ;R[D<\#`8^_P#GTKB(KGYC%.IBF4X96&.:]KKGM=\+66L1,QB6
M.YQQ,HY/U]>G_P"JL:M+FU1<)VW//J*9>6UWHEP+:_0A,?)+V8?Y_I3@0P!4
MY'M7'*+B[,Z$[BT445(PHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`*IW6G07.25PY[BKE%,#$AN;O1IBF"\)
M/(/0^X]ZZ2UNX;N,/$V<C./2JC*KJ5901Z$51ELV@)EM01U)4''XBFGW$T=!
M16+:ZRZG9."Y''3#?E6O%+',NZ-@P]NU5;J(?1112`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@#2TC5Y-,FP07MW/SI_4>_P#.MJ2PT[5DFDTN
M7RKB,`[U4@9YQU^G:N3JWIU_+IMV)XP&XVLI_B'I[5K3J..G0B4+G1V>L3V4
MPL=20K(O`88PP]1[5OPSQSH&B<,#Z5DMJ6CZK$(IY$Z;MLN4*GZ^OT-91C_L
MR99=/U*VEBP=T;2J&/ZX/_UJZE)/J8V9V%%8>D>(;74@8Q(HE7J"<'\C^%;E
M4(****`"BBB@`HHHH`****`"BBB@`JEJV?[+N,==M7:ANHO-MG3&<CIZT`9W
MAM=FA0+G."1^M:]<]X8E81W5HY):&3(/;!]/RKH:`"BBB@"M>64-];O#,@*L
M,9[BO,+S19=(U&2&+B0$'+$A7![_`.>_K7K%8^NZ5_:-J&BR+F+)C^8@'/44
MFDU9C3L<.4=%0NNW<H8<YXIM:>F-'.7T;4#MVG,$I&"C>GT/I_\`KJE<V\EK
M<R6\HP\;8/O[_2N.I3Y6;1E<AHHHK,L**CDN(HE)9P`.O-8USXB4,4M8C*>F
M1TS]::BV)LW20HR3BJ-SJUM;G:7&_L*S;?S]0<&^EG@CSG;$`?YD5J36FC11
M*ME9.9N,W$S98>HQDC\?KQ56BE=L5V]D9J-?ZS.T:R):PH"6,C;1C'YD^PS6
M@=)T6R@C*237USM^?.4BYZ^C$C\OY4WTR2<`#GT`P**7M7M$?)W%#NI<JQ7>
M,,%.`1]!30`HP!BEHK-MO<M*P4444@"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBDZ4`+2=*DM(S>2;8PY3
M'WU7(SV'OS6Y!X2DO9R)%FC@.<?.,X^N*UC2E+4ES2.5DOHT;:@,C>U=AX`A
MNC]JN)HBL+,#$V.">0WZ8_+ZUJ6O@/2;9@Q\^4#JK,`#^0!_6NCMK:*TMT@@
M01Q(,*H[5O2I.+NS&4TU8FHHHKH,PHHHH`****`"BBB@"E?Z=::E;F"[A25#
M_>'3C&1Z'GK7F&N^&;O0;LRP2$V<A.PCH/8^_P#GUKURH;BVAN[=X)XQ)$XP
MRGO43AS(J,K,\;MKD2C:V!*.HJQ5WQ)X2N=*)O+9M]N'X<?>4=MW\L_RSBLF
MWN?,^1QME'4>OTKAE!IG1&5RS1114%!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`1R11R#YU!QT/<4V
M:5+,1201E"H"N-Q*O[\]#_GBIJ9+&)8V0G&>A]#ZTU*PFKE^"=+B,.A_`]14
ME<INO--G$HR1TY.0:W;+5K:\55#[)>Z-P<U5T]16L7J***`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`*\UMF59X7,5PARKCU]Q75V'B&
M:)85NBKJ54,Z]%8CIT]C^7>N<IRNR;MIQN!4]P16M.IR[[$2A<]+AF2>,.AX
M_E4M>=Z5XGDTJ=X;X$P'&V4Y(Q^IS7:66K6.H1;[:X1^G&>1GID=JZE)/8Q:
M:-"BBBJ$%%%%`!1110`4444`%(>AI:*`.:T5?LFN7L$F=\PWCKCCJ/UKI:YC
M7PUC>6M_$OSJX`Y]3R/I_C72J=R@XQD9H`=1110`4444`<SXDT`7H%]:KMNH
MCN.W^+`/Y]JX^XU"0W:1W0.\H!YA).XCCG\`/R]:]6KA?'NB0?V7)?1;DDQM
M*J<+W.?SQ^51.*DK,J+LS$BN[(7*)/,=F3N\L9/';ZGI4&I:Y#J*/;Z?:QP1
M)]QU&YSSW/\`^OM6%IMI'+!F1G8J>5)P,]<XK51$C7:BA1Z"N7G4%9+4VY6]
M691TN2X?=<2%L?PYX-7H;.*'[JBK-%9.;9:BD(!@8%+114C"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HI,@55DOHU.V,>8WMT_.G9O8&RUT&3Q4374*DC>"1V'-6]/\,ZSKP$@C$%N
M1D&0E0WZ9/UKI])^']I;`/?OYS=XXR0O?OU/;T_&M8T6R'42.%-^S@>3"<\C
M+<8KJ-$\&WE]Y=SJI,*#I;8_(G_`UW%EI-AIZC[+:QQ-C&X#+$9S@D\FM"MX
M45'5F4JC>Q0M-*M+0#9$N[GG'KUJ\!@8%+16YF%%%%`!1110`4444`%%%%`!
M1110`4444`1O&LB,CJ&1A@J1D$>E>6^*?#;Z;<-+$O\`H[,3$Z9^7_9/N/U_
M/'JU%1.',5&5CQ.TNA,FUQMD'!%6J[3Q)X/@U&W::QBBBO%)<%1C?ZCZ^_\`
M*O.S+=6,IBN8F.S@C'S`^]<DZ3BS>,[HT**9'(DJ[D8$>U/K$L****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@!",C!JA/IR9#PJ%8>@%:%%.X-7(K35&B98;Y-B%C^]`+$9Z9&>GTYY[\
M"M906@BF49BE&4<<AOH?Y^E9;QK(N&`-4C#-9,9;5L>J]C5IID:G045GV6JQ
MW!$<N(I>,`GAOI_A6A2&%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`444QYXX_O.!0`YE5U*L`0>H-4GA%E<"XMKHVTN"!W&.^!5>[U96D^SV^2
M3PS#M]*N6>E!WWR;KB08(C3DMQT_#N/8UK"$MT0Y(T]+\=W-O+Y5]`'B&,NF
M1L'KSU[>E>B02B:%9`,!AD5Y]9Z()]9@C:)4^SL'VJ<KO]_4KR/;FO0T4(BJ
M!@`8KK2=M3%VZ#Z***8@HHHH`****`"BBB@#`\48^R1<X.[CW/:MR/\`U29]
M!6!XMW?8H2@)8/P!6_'_`*I/H*`'T444`%%%%`!7/^,4#>&KIC_`,C\B/ZUT
M%9VMP?:-&N4]$W=.N.:&!XWI9R\Q^E:=9]C$(;NZC4DJK?+GKCMG\*T*\Z?Q
M,ZX[!1114#"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`***3I0`M%57OH4X4[SQG;VID+7]Y.(K>`ECP%52S52BQ<Q8
MFG2!"SGH,X'4U5,]S.2(E\M>Q[UU^C^`))4\W5YW4G.(D()'U/(_*NMM-!TN
MQ.ZWLHPV0P+98@CH1G./PK:-!F;J(\VL/"&HZGM/E.B8!\V7Y00>1]?PS7;Z
M+X-T[2#'*<SW"'(=Q@*>>0/\<].,5T]%=$::B9.;84445H2%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%8&L^&;36&,KDQ3XP75<AOJ._
M''6M^BE**DK,:;6QY+JWA'4]':2X@`FMTRQ:/T]UZ^_I[UF0WT<C;''EOTYZ
M&O;:\Y\2>#I1/)<V4)E@<[BB*-R$GH`.HYXQT_#-<U2DEJC2$^YA4M9\,[VT
MHAFR4/1CV^M7ZYFK&Z=Q:***0!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4A&1@TM%`%.YL4F&1P?7TJ.TO
MKNP9EN=T\7K_`!#Z5H4UT5U*L,BJ4NXFB]#/%<1AXG!!J2L.'[5IMSY]K,ZG
M_9."/Q[58M];A:189U:.0\9/W:?F(U**`0RAE((/(([T4`%%%%`!1110`444
M4`%%%%`!1110`4V218T+,<`54NM2AMB$4^9*>`B\G-3Z?X4U;Q`"]XS6D&>%
M'WB/>M(4W(ER2,N;4Y;J58;*-Y2W'R+GFM>P\$:E>LLEW*T:'YMJ'D@CID]Q
M7?Z5X?L-(MQ#;PC'<GO6J!@8%=,::1BYMF#I'A33-,M?*-K#(Q^\S+G/YUK+
M#;V4#F*..)%!8X``_&K-9>O3R0:/,8BH=L(-WO\`_6K0DH^'$=C<74O$DK%C
MQ@')R.OY5T59^CQ^7IT7!&1]T_P^U:%`!1110`4444`%%%%`!1110!@^)X3-
M8J.B@Y)'Z5L6[K);1.ARK("#C'&*AU&'SK&1<#..,C.*SO#5R6M9;.0GS+9L
M8/93TY_.@#=HHHH`****`"FNNY&7U&*=10!XQ<P1V>NW,*,202ISU)!_^O4M
M-\4YL/&<T>3M8[N>^[K_`)]J=7#77OG33>@4445B6%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%03744(.YLL/X1R:8$]-+!1DD
M#%42]Q=G$9,2?K6Y8^!M1N0&,0@3!P9SCVQCK^E4H-DN5C*DO88QPQ<^BC-7
M;'P_JNO2(@@:"U)!:1A@;3W&>OX5V>D>!].TUS).!=R9^7>N%4?[N3G\:ZE5
M5!A0`/05T0H=692J=$<Y:^"=$MH%1K9IG'5W<@G\B!6Y;V5K:!A;6\4.[&?+
M0+G'TJS170HI;&;;84444Q!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110!RVO>$+;5&DG@?R+EN2,?(YYZ^A/K
M^E<!?66HZ!<"WOH#Y?.QE.01[?X>]>T53OM/MM1MS!=PK*G7!XP?4$<BLI4D
M]BXS:/)8IDF3=&V14E:VK>!KZQ9KG2Y?/B7YO+/#GVQWX_\`U5@0W#&5H)XS
M%.IP5-<DJ;B;QFF6:***S*"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`2J=[8+<Q_+\KCH1VJ[13`R=
M/U6339OLMX#Y6>&'\/O]*Z2.1)4#QN&4]"#D5DW-G#=)MD7Z$=15%;2?3Y%:
M*5C%WQQM_"FFA69TU%9L&HM&ZQW6.<8D`X/'6M*J:L2%%%%(8444=*`"D+*O
M4@?6JEWJ,5JA.<D>G-3Z9X<U77"'N&-O;MV&,X]_3]>]:1IRD2Y)$%QJEM;G
M;N+R?W5&31I^@:UXB\R57^SP#(4YP#SV]:[;2O`VD:=AWA\Z4=W/`KI(HDAC
M6.)`B*,!0,`"NB-)1,G-LYC1/!-AI1\V7]_,<9+#@$?YZUU*J%`"C`'84ZBM
M2`HHHH`*R?$3;-&E8G`#*2?Q%:U8WB<9\/W/0X`."<9Y%`%W369M/A9L;B.<
M=*N5G:,Q;38L@#``Q^&?ZUHT`%%%%`!1110`4444`%%%%`"'[IK#T,*-0O2'
MR3C(].36O<MLMW(.#C@UB^&%5X+FY8$2O*5;(QT__7^M`'04444`%%%%`!11
M10!Y3\3OW?B*S9$&\P+R.OWFJD.E:WQ2MO*N=-OQN.08F]!@Y'X\G\JR(SNC
M4^HKBK[F]-Z#J***P-0HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M**:S*BY8@#U-5CJ$`!VEFQZ+UII-[`W8MT51_M`,"$A??V!XK5TCP]JVN@2'
M_1[3=]X<%A_LU482;L2YI&;-<EG$%L#),QV@+S@_XUTFF?#^[D0/?2QP[@3C
M&]LY[]OU_P#K==I7AG3-**O#:H)EZ.1DC\:VZZHT$MS%U&]C-T[1K+2HPMI`
M%;&#(>6/3O\`ATZ5I445LDEHC.]PHHHI@%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!7
M'^-M#2]TM[Z$.MQ;C(,?7!(S^&.:["BDU=6&G9W/$K6Z+_NIN)1^M6JZS7_`
ML-UNN-.Q'*26,).%Z?P^G/KQSVKC;S3M6T-C]JM9/+W`98$CIT##(_\`U5Q3
MI-'1&:9/14<,R3QAT.1_*I*R+"BBBD`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`$;INC"#[HX`-16V
MH/:MY4RYC4@$YR4S_,59JI>P/(JR0@>:O&/4>E5&5M&)HVP<C(HK`MM8DMH/
M)D@<RJ/E4YR1^5:MEX?\1ZT`SH;>)AE3D*!]>Y'^-:QIN6Q#DD-N]1AM?ESO
MD/`1>3^7X5)8Z+K^MLVU%M8`<AF_B%=;HO@BRT\+-<CS9^#CJJ^WO_\`6KJT
M18T"J,`5T0I);F3FWL<GI7@BSLO+DG_>RC&YFYS_`)-=5%$D,:QQJ%51@`5)
M16I`4444`%%%%`!1110`5C^(COTT6^P.9F`QG'`Y/\JV*YOQ'_R%--/3!//I
MR*`-K3XC#8Q(3G`JU2+PH`I:`"BBB@`HHHH`****`"BBB@"O=`&V?/0#/Y5E
M>&&1K*?81S.3CN.!_A6U*N^)ESC(K`T)EM=0O;'@9(=0?O'L<]O2@#HJ***`
M"BBB@`HHHH`XCXFP-+X:20#Y8)U=OY?S-<;:-OM8V]5S7H'CR`W/AF2`$#>X
MR3GC'(Z>X%>>:><V,7.<#%<N)Z&U(M4445RFP4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!15>>[C@P/O/Z#M]:@\V[ESM58QV/6G9BN7LX'/%5Y;V./Y4_>/Z+
M4(LY91^_<MSTK;L/!^H2;2EBR#=M+2X3'O@\XY["J4;^8FS"2VDNF\R=N.P[
M"M&STM[J80VMNTLA[*/?J?0>]=KIW@R&(A[^3SF_YYQDA>_4]3V]/QKJ(88H
M(A%#&L:+T5!@#\*VC1E+XM#-U$MCG=$\)6MA&7O(XKB=N.1N11[9[^_^3T:1
MK&BHBA448"J,`#TJ2BNF,5%61DVWN%%%%4(****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"FNBR(589%.HH`X+7/!ZP3M=Z=MAW'+)CY3^';\*YIE9
M#M=2K8R0>U>P.BR(589!KE=7\)+<_/`Y7!R,'!%85**EJMS2-1K<XFBGWMM<
MZ9<>3=QD+G"R`?*WM['VJ.N1Q:=F=":>PM%%%2`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%)2TR5MD3-Z"
M@#5\&VB7WB5Y6Z0)NP1D'I_7'Y5Z>````,`5Q?PYMBNCW-XP8&><A<]"H`Y'
MXY_*NUKT::M%(Y9N["BBBK)"BBB@`HHHH`****`"BBB@`KFM69;OQ!:VRC)B
M7)(_A)/?\A_DUTM<S;`+XVN\')*+Q^%`'2C@`4M%%`!1110`4444`%%%%`!1
M110`5S6LVYL;Z'4X(\LIP0!Z]<_@,5TM4=77=I<X"Y.W@4`6H95FB21""KC(
M(J2L;PQ@:'$@(RC,I&>AS6S0`4444`%%%%`&!XN@$VALS8V1.'?Z`'_&O+=+
MDW0O&?X#QCTKU?Q2`_A^Y0OL#84MZ9.*\ETW]W-(AX;N/0^E<^(V-:>YI444
M5QFX4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1124`+152:^5'V1CS'_05"#?3+M)"#U7O5<KZBYB[
M),D0R[`>U5&N9Y_EA38O]X]:U+;PSJ4TJJVGW!<]W0J/Q)XKIM/\$/M1KV?R
M_6.(9/3^\>,Y]CTZU<8-[(ER2W9Q-O9K'EFY)[FNDL_"^J72@^0($()!F.WO
MTQU_2NTTO0[32-Y@#,[\%Y""V/08'2M6MHX>^LF9NI;8P-&\-0:3(TK2>?/T
M5RF-@]AD\^__`-?._116\8J*LC-MO5A1115""BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`SM4T>VU2W:.:,$GO7"#PS
M+!?"Q2X5.<)YV?PY`_`#VZUZ963J^D_;T5XFV31G<I'<_P!*F4%)68U)K8\\
MN]-O+`D7-M)$,@;B,J3C.`1P:K5W?]KO!$UMJ]HLL(P#(%RIY[J?IFN2U2P%
MC<_N6,EK(-T,I_B'IQW'3_\`77'5I<FJV-X3OHRC1116)H%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%071`MV!.,
M\9J>JU\NZV(Z#O36X,]+\&Q"/PI8```%-W#9ZG)_6N@KGO!+A_"-@0<X#`_]
M]&NAKTH['(]PHHHIB"BBB@`HHHH`****`"BBB@`KGK54D\37,R$':=C'/M_^
MNM]FVH6]!FN=\-/]H>ZNR,%Y#D;L_3_"@#I****`"BBB@`HHHH`****`"BBB
M@`IDBAXV4]",4^FN0J$GH!0!S_AU'@O+^'@1[@RC;C'4=>_2NBKF]`<MJFH!
MP"8R%4YR0">G\ORKI*`"BBB@`HHHH`BGA2X@DA=05=2I!KQ:_@-CXF:VRH92
M0X3@9_\`U8KVZO&_%=O-:^.Y7>3?YI#@D`<$8`_#&/PK*K\)<-QU%%%<!TA1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!112$A023@"@!:BEN(H>'?!]!R:D@MKS4LQV$+-GCS",*!G!//7'M75Z%X
M#M[?$^J%;B7@B,9V@Y[^O_ZZUA2<MR)5$CCHI;BY4&VL;B3/.0A_I22Z5JTC
MK]HMIXT9]B@(<,<\`'N:]E6WB0@K&H([XYJ6NCV"6QE[1GFVC>"[FX9'N4-M
M!GG>,.1[#MT[^N>:[73-$L]*!-O&?,88:1SEB,]/;\/05J45<*48ZDN;8444
M5H2%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`0SV\5PA610<C&<5S%_P"&KAX'BAEQ$3D*
M/X?<9SS^'_U^MHI-7`\;O[74M'<F^MOW1.%=?Z^AID%Q'.N4/U'<5[!/!!<Q
M&.>%)8SU5U!'Y&O/?$O@LVA%]HZ.47&Z(<E?<=R/\].G-4H]4;1J=&8U%5K:
MZ\X['&V0#D>OTJS7,U8V3N%%%%(`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`*AN?^/=N.<<5-3H8?M%S#$4WJ6RRYQE1R?T!II7
M:$]CL_AZ\K>%D60$*LKB/(Q\O!_'DFNMK)\.!1H-KMQC:3@#&.3QCVZ5K5Z2
M5E8Y&%%%%,`HHHH`****`"BBB@`HHHH`KWDGDV<\NW=L1CC.,\5E^&D46'F(
M?DDP1^`Q6I="-K699B!&4(;)QQCGFLGPN7-@=^``?E`Z`4`;U%%%`!1110`4
M444`%%%%`!1110`5'*I:%U'4J14E(1D8H`Y_0&W:AJ)`&W<,'OWS70USEG_Q
M+O$;V^#LN%)X]1T_K71T`%%%%`!1110`5Y5X]C+^*H&(50H4!L8SW_QKU6O,
M_B?"T5UIETJ8CR0[8[Y&,G\ZF?PL<=S(I::IRH/J*=7FG6%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!12$A023@#O55KLN_E6R&
M60\+@=3_`%II-[`W8M=*B-S$&"AMS$X"J,DGZ"MO1_!-_J#>=JC-!;MGY`?G
M/IQV_'FNRL?#&F6$(CBA&WJ0><GUK>%!O5F3JKH<%;:?/.A+1R(W7;MR<=_Z
M?G6WIGA$SR[[SYDQP&Z#Z#H?QSC%=N+>%<8C7CH<5*!@8%=$:4([(R<VRI9Z
M=;V2`1H,^N*N445H2%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110!Q7BGPO#*QO[/$,^XNYP2'./T_#WKCH91+&&`P>A!Z@^E>R.BR(58
M9!KSOQ5X7N[>Z.HZ8A=6_P!9&BY/UQ_G_#GK4KJZ-(3MHS#HJG'?*"$F4HWK
MVJW7(TUN="8M%%%(`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`J6UN4M;N-WW8.5^49(R"/ZU%5.\BDN'AMX1F9W"HN<9).,54/B0I;'K
M6@6\EMHMLDH`<KN(!SUYK4IJ`JB@]0*=7I'(%%%%`!1110`4444`%%%%`!11
M10!E>(+AH-(E5,;Y?W8!'7/7],U+I$'D:?&",$\[?3VK+\2%WOM,ARWE>868
M#H>,#/YUT,:[(U7.<`#-`#Z***`"BBB@`HHHH`****`"BBB@`HHHH`R-9L#<
M6_FQY65#D.IP5^E.TC5A?J\$HV74/#KZ^XK5KFM4M);&_CU&T!R"-RC."O<'
M_/\`*@#I:*J65]#?0AXC@XY0\%?J*MT`%%%%`!7GGQ2?=9V$"E#\[.P)Y'&!
M_,_E7H=<MXYTK^T=`EFC'[ZU!D7W7^(?H#^'O4SO;0<=SSZRD,EG&QZXP?PJ
MQ67I$A"-$3[CU_STK4KSY*S.I;!1114C"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBD)P.:`%HJK+?11L%`9_\`='%)%)?7DICL[-Y&QG"@L2/H*I1;%S(M
M5!->10C&X,_916M;^#=?OL>=Y=L!P49L?CQFN@TOX?V-MLDO7:XEZLJG:G3I
MZG![\?2M8T9/<AU$C$\/>%[C6E6]O6V6A^Y$/XN>I_$=/;\_0++2;2Q0+%"H
MP`.GI5N.)(HUCC0(BC"JHP`/2I*ZX1459&#=V%%%%4(****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@#`UWPS9:Q;3
M'R(TNRIV2CY>>V<=>E>7)))8S&VN0RA3M^88*GT->X5S'B#PC::RTMR))(KI
M@/F&"IQZ@^W'45C4I\VQ<)6.#I:@>.?2[LZ??+LD7[K'HP]:GKC::=F=*=PH
MHHJ0"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`2H]-<-XHL69@L
M44R,Q;@``CG-256TZ$W/B&*VSL$Q$8;&=N2*N&Y,CVRBBBO1.4****`"BBB@
M`HHHH`****`"BBF.2(V(Z@&@#`1/MWB.20ME(`$``],]?UKHJYSPLFZWEF8Y
MD9FW'ZDFNCH`****`"BBB@`HHHH`****`"BBB@`HHHH`*:R*Z[64$>AIU%`'
M.W>D2V;R75@_EMUQU_G_`)^E7='U7[=$8ID\NZC'SKC`/N/:M6N:UNQ:VFBU
M&T^66)LX`X/M^5`'2T5!:7,=Y;1SQ'*N,_3VJ>@`J&X19+66-QE60@CU&*FH
MH`\`L6:.[C8G:"2#[_YXK=K(U"W?3[^YM&'S03,@(&"0#U_2M9?NCZ5Y]1:G
M5`6BBBLR@HHHH`****`"BBB@`HHHH`**2H9KJ*$'+98?PCDTP)ZC>:.+[[@5
M2+W5U]W]VGMU_.KMGX?GNV#Q6TL^6V[E4D!O<]!U[T^7N3<J->2S$K;+@=,L
M*6/399W569Y'8X"CDDGL!7<:=X&8(K7DWE@\F*(9/3^]T!S['ZUTVGZ+8Z8"
M;:+#E0K2,Q+'_#\,5O&E)^1FYHY/1_`IC*27^U%!R8%.2WL2.G;IGKVKLK33
M[2Q39:VT<((`.Q<$XZ9/?\:N45T1A&.QFY-A1115DA1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`8'B3P[%KU@8P52X0[HW(SSZ'V/\`AZ5YA*E]IEP\%TC'8<,I'(_QKVZN
M9\4:'-JL44MLB--%E2IP"X/O[>GN?QQJPNKHTA*VAY_%,LR!E_(]14E5+O3[
MO3;C<87B9AG;(I7(]<'\:?;W2SY7!5QU4UQN)NF6****D84444`%%%%`!111
M0`4444`%%%%`!1110`4444`%6?"(V^-[4EA@B3'_`'R:K5:T*0V_B&*=.6`'
M3T+*/ZUK2^)$3V/6****[SF"BBB@`HHHH`****`"BBB@`IK`%2#TQS3JAG94
MMY&9@J!222<`#%`&#X9*@S1H2T2LVQB><9[C_/6NDK`\+Q^79/T^8[A[UOT`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!4<T*3Q-&XRIJ2B@#EVCG\.
MW!DB!DM)&RZ#J/I[UT-K=17END\#AXV'!%/EA2>,QR*"I&*YB>WN/#^H+<P;
MWL78^9&OOW^OO[4`=714-M<Q7<"30.'C8<$&IJ`/*OB'9"+6XKA>//`R0.O.
M/QQQ5$#``K<\>RQBZB+@D#*KC'!QC_#\JP8_]6OTKCQ"LT;TGH/HHHKG-0HH
MHH`****`"BFLRHI9F"J.YJE)<R7&8[<84C&X_P!*:5P;+4MQ%#]]P#Z=354W
M4UP=L*%%Q]X]:DALD7YI/F<]2:NP6[RR+%!$SN>BHN2?PIZ(6IG"P=^9)6;G
M/)Z&IX=/0NB(A>0D``#))["MY/#&L.@<69`(R,NH/Y$\5TVA>&1IEP+JXE$E
MPH.U4SM3.1G/?C^M:1A.3L0Y10F@>&8;&..XNT5[H'<H_AC_`*$^_P"7J>GH
MHKLC%15D8-M[A1115""BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
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
M_P#K?A7!6=N+BZ"MMPBEL-W[<>^2/RKU.PC\FPMX]@3;&HVCMQTKLP\=+F%5
MZV+-%%%=!D%%%%`!1110`4444`%%%9=[K-O9N84!FG'\"]O3)H`U*YR^VR^)
MX4!Y6(*2/X3SU_.HW&MZDFY9?LT;<;$QG'KDCK_A5[3=$CM)/M$W[R<CEB>3
M[F@#8'`%+110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%9%WHZ
MR7)N8&,<I&"5X/O6O10!Y5KUK+IDBS2P!(V;8=BX^8Y.?0#'88Z501UD4,C`
MKZBO6KVPMM0MGM[F)9(V&"#7#ZCX#>T5Y=+FDSG(A;E<>GMV]>E<U2C=WB:Q
MJ:69S]%12F>RO#:7D)BD'1NS>X]JDKE::=F;IW%HHHI`%%%%`%W2X!/<%0S+
M)N1`5[!FY/Z#]:]35=J@>@Q7ENG;O)GV$A_,@V[>I.6Z>]>I+G:,]<<UWT/@
M1S5/B'4445J0%%%%`!1144\\=M"TLKA$49)-`$M5KB\M[4?OI53@D`GDX]!W
MK#DU"_U;,=@CPP$8+,-K=#W[?AZ58L_#\:%9;EVDFZEF.3GZ_2@"&?5I=0=K
M6P1Q&PP9N01QVST__75W3M&@LE#%`7Y)XXK1AMHH!B-`OTJ6@!`,#`I:**`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@#F_$
MGAB+7X5='6.XC!VN5R&]C^/?MSQ7FTT5]H]U]FOXW4?[8YZ]1ZBO;:R=:T2U
MUNT,%RF2N2C#@J?K_GH*RG24BXSL>9#I2T[4--N-`O?LTV6MF.(I".GL:97%
M*+B[,Z(NZN+1136.U2:D9M>';1IM2@!!VNX?(&>$/?'3G^7O7I5<=X'M?]&>
M[P-I143KD=S^IKL:]&$>6*1RR=V%%%1R2)$A>1PBCJ2<59))52ZU*SLE)N+A
M(\=03S^58]YK4EW+]ETS<><-+MR"/]GM5BRT"*--UR?-D)R2>_UH`BE\21OO
M2SMY)G7')&T8(Z]*9%87^IN7U%\1D#$2GY1[UN0VD$"A8XE4#I@=*GH`B@@C
MMXA'&H`%2T44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`&?JFEV^J6QAGC5QUP>A^M>=:QH-QH3;E)E
MM0/F`!R@'?W'^?IZK5>[M(KR$Q2C*GBIG!25F5&3B[H\D!#`%3D4Z.`W4J0#
M.'/.#@@`9)_(&M?Q'X7N--#WVG)NAY,L:\[1ZX_G_P#KK(T6]AEOHS)^[;YE
MP?4J0/U-<7LW&:3-^>Z/2O#B!=$@/&7RQP,<YZ?AT_"M>L?PT&70;<-]X9S]
M<U8O]5M-/&)I/WF,B->6/X>E=YS%\D*"3T%<Y-</K6I""%5:RB/+CD,>0:CN
M);W79%AB#06O7C^,<CD_TK<T^PAT^V6&)0,=3CK0!);V<-J/W:`$]3ZU8HHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`(WC62-D=0R,,%2,@CTKA=9\`H[M<:;
M<O$_5$(S@Y['/3H*[ZBDXI[C3:.3TO0=4CLHEN;N1&7C8&P`/PK2LO#MM:D,
M^9&`P,CI6U13$,1$C&$4*/84^BB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
@H`****`"BBB@`HHHH`****`"BBB@`HHHH`****`/_]DH
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
  <lst nm="TslInfo">
    <lst nm="TSLINFO" />
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End