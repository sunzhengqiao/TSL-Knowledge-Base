#Version 8
#BeginDescription
#Versions:
Version 2.9 20.12.2024 HSB-23217: Add property "Tooling zone" to controle zone of element tooling , Author Marsel Nakuci
2.8 15.09.2022 HSB-16454: Add property that controll to add element tooling or not Author: Marsel Nakuci
version value="2.7" date=27may2020" author="frank.alberts@hsbcad.com"
Darstellung Elementansicht/Modell differenziert
bugfix Elementabhängikeit, Eigenschaften kategorisiert (erfordert mindestens Version 19.1.31)

DACH
   erzeugt Elektroinstallationen
EN
   creates electrical installations



















#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 2
#MinorVersion 9
#KeyWords Elektro,Element
#BeginContents
/// History
///#Versions:
// 2.9 20.12.2024 HSB-23217: Add property "Tooling zone" to controle zone of element tooling , Author Marsel Nakuci
// 2.8 15.09.2022 HSB-16454: Add property that controll to add element tooling or not Author: Marsel Nakuci
///<version value="2.7" date="27may2020" author="frank.alberts@hsbcad.com"> Updated old properties for compatibility with hsbViewTag</version>
///<version value="2.6" date=07jan2018" author="thorsten.huck@hsbcad.com"> Darstellung Elementansicht/Modell differenziert</version>
///<version  value="2.5" date="26jan15" author="th@hsbCAD.de"> bugfix Elementabhängikeit, Eigenschaften kategorisiert (erfordert mindestens Version 19.1.31)</version>
///<version  value="2.4" date="18nov13" author="th@hsbCAD.de"> Installationsausgabe an Excel wird unterstützt</version>
///<version  value="2.3" date="15nov13" author="th@hsbCAD.de"> katalogbasierter Aufruf mit Dialogunterdrückung implementiert </version>
///<version  value="2.2" date="14jun13" author="th@hsbCAD.de"> Werkzeugindex veröffentlicht </version>
///<version  value="2.1" date="13jun13" author="th@hsbCAD.de"> bugfix </version>
///<version  value="2.0" date="25sep12" author="th@hsbCAD.de"> new options 'installation offset' and 'shape' to enable slotted and rectangular toolings as well as 'vimar' installations</version>

/// Version 1.9    30.04.2012   th@hsbCAD.de
/// bugfix Seitenzuordnung
/// Version 1.8    19.04.2012   th@hsbCAD.de
/// DE: Die Farbe der Instanz wird in Abhängigkeit der Elementseite gesteuert: Iconseite = 3, Gegenseite = 4.
/// Diese Farbeinstellungen können bei der Layoutbemassung als Filterkriterium verwendet werden um eine 
/// seitenabhängige Bemassung zu definieren
/// Version 1.7    13.11.2007   th@hsbCAD.de
/// DE   - bugFix keine Fräsung
/// EN   - bugFix Milling = none
/// Version 1.6    01.08.2007   th@hsbCAD.de
/// DE   Achsmaß der Installation zur Verwendung mit 'hsbCAD Layout-Bemassung' veröffentlicht
///      - neue Option 'keine CNC Bearbeitung' 
/// EN   axis of installtion published for dim tsl's in layout
///    - new option 'no cnc'
/// Version 1.5    19.01.2007   th@hsbcad.de
///    - bugFix
/// Version 1.4    10.08.2005   th@hsbcad.de
///    - Korrektur Bohrungsdurchmesser
/// Version 1.3    21.07.2005   hs@hsbcad.de
///    - neue Option 'W+P Bearbeitung' läßt die Auswahl der Maschinenbearbeitung zu
/// Version 1.2    18.07.2005   hs@hsbcad.de
///    - Sperrflächen bei Option 'Kabelführung versetzen' und 'Fräsung oben/beide'
///      ergänzt
/// Version 1.1    16.07.2005   hs@hsbcad.de
///    -Sperrflächen für den Bereich der Steckdosen und der Fräsung ergänzt
/// Version 1.0    13.07.2005   th@hsb-systems.de
///    - neue Eigenschaft 'Darstellung in Zone xx'
///    - W+P Fräsung der Dosen
///    - abgeleitet von "hsbElektro Typ 2"

// standards
	U(1,"mm");
	double dEps=U(.1);

// categories
	String sCategoryTooling= T("|Tooling|");	
	String sCategoryWirechase = T("|Wirechase|");
	String sCategoryInstallation = T("|Installation|");
	
// list of installtion types == blocknames
	/*String sInstList[]={"","Steckdose", "Ausschalter", "Wechselschalter", "Serienschalter", "Kreuzschalter", 
		"Ausschalter + Orientierungslicht", "Ausschalter + Kontrolllicht", "Taster", "Klingeltaster", "Rolloschalter",
		"Telefon", "Antenne", "CAT5", "Twin", "Lautsprecher", 
		"Herdanschluss", "Geschirrspüler", "Waschmaschine", "Raumthermostat","Rollo",
		"Haustüröffner", "Fensterkontakt",
		"Wandauslass", "Sprechanlage", "Gong", "Bewegungsmelder", "baus Lampe mit BW", "baus Lampe mit BW + Taster"};
	*/
	String sInstList[]={"", 
		"Antenne", "Ausschalter Kontroll", "Ausschalter Orientierungslicht", "Ausschalter", "baus Lampe mit BW + Taster", 
		"baus Lampe mit BW", "Bewegungsmelder", "CAT5", "Dimmer", "Fensterkontakt", 
		"Geschirrspüler", "Gong", "Haustüröffner", "Herdanschluss", "Jalousiemotorschalter", 
		"Klingeltaster", "Kreuzschalter", "Lautsprecher", "Leuchte allgemein","Leuchte DIN (1)",
		"Leuchte DIN (2)","Leuchte DIN (3)","Leuchte DIN (4)", "Motor", 	"Raumthermostat", 
		"Rollo", "Rolloschalter", "Serienschalter", "Sprechanlage", "Steckdose 2-fach",
	   "Steckdose", "Taster beleuchtet", "Taster", "Telefon", 	"Twin", 
		"Wandauslass", "Waschmaschine", "Wechselschalter"};


//region Properties
	String sElevationName = T("|Elevation|");
	PropDouble dElevation(0, U(400), sElevationName);
	dElevation.setCategory(sCategoryInstallation);

	String sAlignments[] = {T("|Horizontal|"),T("|Vertical|")};
	String sAlignmentName =  T("|Alignment|");
	PropString sAlignment(6,sAlignments,sAlignmentName );
	sAlignment.setCategory(sCategoryInstallation);

	PropString s0(0,sInstList, sCategoryInstallation +" 1");	s0.setCategory(sCategoryInstallation);
	PropString s1(1,sInstList, sCategoryInstallation +" 2");	s1.setCategory(sCategoryInstallation);
	PropString s2(2,sInstList, sCategoryInstallation +" 3");	s2.setCategory(sCategoryInstallation);
	PropString s3(3,sInstList, sCategoryInstallation +" 4");	s3.setCategory(sCategoryInstallation);
	PropString s4(4,sInstList, sCategoryInstallation +" 5");	s4.setCategory(sCategoryInstallation);
	String sAllInsts[] = {s0,s1,s2,s3,s4};

	PropDouble dDiam(3,U(68), T("|Diameter|"));
	dDiam.setCategory(sCategoryInstallation);
	PropDouble dDepthInst(4,U(68), T("|Depth Installation|"));
	dDepthInst.setCategory(sCategoryInstallation);
	
	String sMillAlignments[] = {T("Bottom"),T("Both"),T("Top"),T("Kabelführung versetzen"), T("none")};
	PropString sMillAlignment(5,sMillAlignments,sAlignmentName +" ");
	sMillAlignment.setCategory(sCategoryWirechase);
	PropDouble dMillWidth(1,U(60), T("|Width|"));
	dMillWidth.setCategory(sCategoryWirechase);
	PropDouble dMillDepth(2,U(30), T("|Depth|"));
	dMillDepth.setCategory(sCategoryWirechase);
	
	String sShapes[] = {T("|Drill|"), T("|Slotted Hole|"), T("|Rectangular|")};
	String sShapeName=  T("|Shape|");
	PropString sShape(9,sShapes,sShapeName);	
	sShape.setCategory(sCategoryTooling);
	PropDouble dModelInstallationOffset(6,U(70), T("|Offset Installation|"));
	dModelInstallationOffset.setCategory(sCategoryInstallation);
	String sWPToolName =  T("|W+P Tool|");
	String sWPTools[] = {T("|Milling|"),T("|Drill|"), T("|None|")};
	PropString sWPTool(8,sWPTools,sWPToolName);
	sWPTool.setCategory(sCategoryTooling);
	PropInt nToolIndex(3,1,"   " +T("|Tool Index|"));
	nToolIndex.setCategory(sCategoryTooling);
	int nArZn[] = {-5,-4,-3,-2,-1,0,1,2,3,4,5};
	PropInt nShowInZone(2,nArZn, T("Show in Zone"),5);

	double dPlanInstallationOffset = U(72);

	PropDouble dScale(5,2,  T("|Scale|"));
	PropInt nDigits(0,2,  T("|Digits|"));
	PropInt nColor(1,140,  T("|Color|"));
	PropString sDimStyle(7, _DimStyles,  T("Dimstyle"));
// HSB-16454:
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	String sElementToolingName=T("|Element Tooling|");	
	PropString sElementTooling(10, sNoYes, sElementToolingName,1);	
	sElementTooling.setDescription(T("|Defines whether Element Tooling is done or not|"));
	sElementTooling.setCategory(sCategoryTooling);
	
// HSB-23217: 
	String sZoneToolingName=T("|Tooling zone|");
	int nZoneToolings[]={0,1,2,3,4,5};
	PropInt nZoneTooling(4, nZoneToolings, sZoneToolingName);	
	nZoneTooling.setDescription(T("|Defines the zone of the tooling. 0 means the most outer zone.|"));
	nZoneTooling.setCategory(sCategoryTooling);
//End Properties//endregion
	
	
// on insert
	if (_bOnInsert){
		if (insertCycleCount()>1) { eraseInstance(); return; }
		
	// get execute key to preset properties
		String sKey = _kExecuteKey;
		if (sKey.length()>0)
		{	
			setPropValuesFromCatalog(sKey);		
		}
		else
			showDialog();		

		_Element.append(getElement(T("Select element")));
		_Pt0 = getPoint(T("Select insertion point"));
		return;
	}

// declare standards
	if (_Element.length()<1)
	{
		eraseInstance();
		return;	
	}
// HSB-16454:
	int nElementTooling=sNoYes.find(sElementTooling);
	Element el = _Element[0];
	CoordSys cs;
	Point3d p0;
	Vector3d vx,vy,vz;

	cs = el.coordSys();
	p0 = cs.ptOrg();
	vx=cs.vecX();
	vy=cs.vecY();
	vz=cs.vecZ();


// adjust color if needed
	if (nColor < 0 || nColor > 255) nColor.set(140);


// relocate _Pt0
	_Pt0.setZ(p0.Z());
	PLine plOL = el.plOutlineWall();
	Point3d ptMid;
	ptMid.setToAverage(plOL.vertexPoints(true));
	_Pt0 = plOL.closestPointTo(_Pt0);
	_Pt0.vis(8);

// ints
	int nShape=sShapes.find(sShape);
	int nOrient=sAlignments.find(sAlignment);
	int nWPTool=sWPTools.find(sWPTool);
	int nMillAlignment=sMillAlignments.find(sMillAlignment);


// on creation and certain events
	/*
	if (sWPToolName==_kNameLastChangedProp || _bOnDbCreated)
	{
		if(nShape!=0 && nWPTool==1)nShape=0;
		else if(nShape!=0 && nWPTool==1)nShape=0; 
		sShape.set(sShapes[nShape]);	
	}
	if (sShapeName==_kNameLastChangedProp)
	{
		if(nShape>0 && nWPTool==1)nWPTool=0;
		else if(nShape==0 && nWPTool==1)nWPTool=0; 		
		sWPTool.set(sWPTools[nWPTool]);	
	}
	*/
		
// tool coord sys
	Vector3d vxE=vx, vyE, vzE=vz;

// define installation vector and offset to zone 0
	double dOffsetZone0;
	int nSide=1;
	if (vz.dotProduct(_Pt0 - ptMid) < 0){
		vzE *=-1;
		vxE *=-1;
		dOffsetZone0 = el.dPosZOutlineBack() + el.zone(0).dH();
		nSide = -1;
	}
	else
		dOffsetZone0 = el.dPosZOutlineFront();

	if (nOrient==1)
	{
		vxE= vxE.crossProduct(vzE);
	}

	vyE= vxE.crossProduct(-vzE);



// control entity color
	if (nSide ==1)
		_ThisInst.setColor(3);
	else if (nSide==-1)
		_ThisInst.setColor(4);				

// Display
	Display dpPlan(nColor);
	dpPlan.addViewDirection(vy);
	dpPlan.dimStyle(sDimStyle);
	dpPlan.elemZone(el,0, 'I');	

// polylines for graphics
	PLine plPoly[0];
	PLine plPoly0[0];
	PLine plPoly1[0];
	PLine plPoly2[0];
	PLine plPoly3[0];

	PlaneProfile ppPoly[0];

	PLine pl00(vy);
	PlaneProfile pp00;
// collect polylines for each inst
	PLine plAll0[0], plAll1[0], plAll2[0], plAll3[0], plAll4[0];
	for (int i = 0; i < sAllInsts.length(); i++){
		plPoly.append(pl00);
		plPoly0.append(pl00);
		plPoly1.append(pl00);
		plPoly2.append(pl00);
		plPoly3.append(pl00);

		ppPoly.append(pp00);

		if ( sAllInsts[i] == sInstList[1]) {
		// Antenne
			Point3d plPoly_PT = Point3d( U(20), U(25), 0);					plPoly[i].addVertex( plPoly_PT);
			Point3d plPoly_PT0 = plPoly_PT + Point3d( 0, U(-25), 0);		plPoly[i].addVertex( plPoly_PT0);
			Point3d plPoly_PT1 = plPoly_PT0 + Point3d( U(-40), 0, 0);	plPoly[i].addVertex( plPoly_PT1);
			Point3d plPoly_PT2 = plPoly_PT1 + Point3d( 0, U(25), 0);		plPoly[i].addVertex( plPoly_PT2);
		
			Point3d plPoly0_PT = Point3d( 0, U(-20), 0);					plPoly0[i].addVertex( plPoly0_PT);
			Point3d plPoly0_PT0 = plPoly0_PT + Point3d( 0, U(20), 0);	plPoly0[i].addVertex( plPoly0_PT0);

			Point3d plPoly1_PT = Point3d( U(15), U(25), 0);					plPoly1[i].addVertex( plPoly1_PT);
			Point3d plPoly1_PT0 = plPoly1_PT + Point3d( 0, U(-20), 0);		plPoly1[i].addVertex( plPoly1_PT0);
			Point3d plPoly1_PT1 = plPoly1_PT0 + Point3d( U(-30), 0, 0);		plPoly1[i].addVertex( plPoly1_PT1);
			Point3d plPoly1_PT2 = plPoly1_PT1 + Point3d( 0, U(20), 0);		plPoly1[i].addVertex( plPoly1_PT2);
		}
		else if ( sAllInsts[i] == sInstList[2]) {
		// Ausschalter Kontroll-Leuchte
			Point3d plPoly_PT = Point3d( U(-12.839861), U(-14.280429), 0);			plPoly[i].addVertex( plPoly_PT);
			Point3d plPoly_PT0 = plPoly_PT + Point3d( U(13.856406), U(8), 0);		plPoly[i].addVertex( plPoly_PT0, 1);
			Point3d plPoly_PT1 = plPoly_PT0 + Point3d( U(-13.856406), U(-8), 0);	plPoly[i].addVertex( plPoly_PT1, 1);

			Point3d plPoly0_PT = Point3d( U(-1.9116581), U(-3.352226), 0);					plPoly0[i].addVertex( plPoly0_PT);
			Point3d plPoly0_PT0 = plPoly0_PT + Point3d( U(12.489619), U(21.632655), 0);	plPoly0[i].addVertex( plPoly0_PT0);
			Point3d plPoly0_PT1 = plPoly0_PT0 + Point3d( U(4.330127), U(-2.5), 0);		plPoly0[i].addVertex( plPoly0_PT1);

			Point3d plPoly1_PT = Point3d( U(-11.568512), U(-4.623575), 0);				plPoly1[i].addVertex( plPoly1_PT);
			Point3d plPoly1_PT0 = plPoly1_PT + Point3d( U(11.313708), U(-11.313708), 0);		plPoly1[i].addVertex( plPoly1_PT0);

			Point3d plPoly2_PT = Point3d( U(-11.568512), U(-15.937284), 0);			plPoly2[i].addVertex( plPoly2_PT);
			Point3d plPoly2_PT0 = plPoly2_PT + Point3d( U(11.313708), U(11.313708), 0);		plPoly2[i].addVertex( plPoly2_PT0);

		}
		else if ( sAllInsts[i] == sInstList[3]) {
		// Ausschalter Kontroll-Orientierung
			Point3d plPoly_PT = Point3d( U(-12.839861), U(-14.280429), 0);			plPoly[i].addVertex( plPoly_PT);
			Point3d plPoly_PT0 = plPoly_PT + Point3d( U(13.856406), U(8), 0);		plPoly[i].addVertex( plPoly_PT0, 1);
			Point3d plPoly_PT1 = plPoly_PT0 + Point3d( U(-13.856406), U(-8), 0);	plPoly[i].addVertex( plPoly_PT1, 1);

			Point3d plPoly0_PT = Point3d( U(-1.9116581), U(-3.352226), 0);					plPoly0[i].addVertex( plPoly0_PT);
			Point3d plPoly0_PT0 = plPoly0_PT + Point3d( U(12.489619), U(21.632655), 0);	plPoly0[i].addVertex( plPoly0_PT0);
			Point3d plPoly0_PT1 = plPoly0_PT0 + Point3d( U(4.330127), U(-2.5), 0);		plPoly0[i].addVertex( plPoly0_PT1);

			Point3d plPoly1_PT = Point3d( U(-9.3915028), U(5.2639516), 0);					plPoly1[i].addVertex( plPoly1_PT);
			Point3d plPoly1_PT0 = plPoly1_PT + Point3d( U(1.6107334), 0, 0);				plPoly1[i].addVertex( plPoly1_PT0);
			Point3d plPoly1_PT1 = plPoly1_PT0 + Point3d( U(6.1946315), U(6.1946315), 0);	plPoly1[i].addVertex( plPoly1_PT1, 0.41421356);
			Point3d plPoly1_PT2 = plPoly1_PT1 + Point3d( 0, U(8.6107316), 0);				plPoly1[i].addVertex( plPoly1_PT2);
			Point3d plPoly1_PT3 = plPoly1_PT2 + Point3d( U(-6.1946315), U(6.1946315), 0);plPoly1[i].addVertex( plPoly1_PT3, 0.41421356);
			Point3d plPoly1_PT4 = plPoly1_PT3 + Point3d( U(-1.6107334), 0, 0);				plPoly1[i].addVertex( plPoly1_PT4);
			Point3d plPoly1_PT5 = plPoly1_PT4 + Point3d( U(-6.1946315), U(-6.1946315), 0);plPoly1[i].addVertex( plPoly1_PT5, 0.41421356);
			Point3d plPoly1_PT6 = plPoly1_PT5 + Point3d( 0, U(-8.6107316), 0);				plPoly1[i].addVertex( plPoly1_PT6);
			Point3d plPoly1_PT7 = plPoly1_PT6 + Point3d( U(6.1946315), U(-6.1946315), 0);plPoly1[i].addVertex( plPoly1_PT7, 0.41421356);

		}
		else if ( sAllInsts[i] == sInstList[4]) {
		// Ausschalter
			Point3d plPoly_PT = Point3d( U(-12.839861), U(-14.280429), 0);			plPoly[i].addVertex( plPoly_PT);
			Point3d plPoly_PT0 = plPoly_PT + Point3d( U(13.856406), U(8), 0);		plPoly[i].addVertex( plPoly_PT0, 1);
			Point3d plPoly_PT1 = plPoly_PT0 + Point3d( U(-13.856406), U(-8), 0);	plPoly[i].addVertex( plPoly_PT1, 1);

			Point3d plPoly0_PT = Point3d( U(-1.9116581), U(-3.352226), 0);					plPoly0[i].addVertex( plPoly0_PT);
			Point3d plPoly0_PT0 = plPoly0_PT + Point3d( U(12.489619), U(21.632655), 0);	plPoly0[i].addVertex( plPoly0_PT0);
			Point3d plPoly0_PT1 = plPoly0_PT0 + Point3d( U(4.330127), U(-2.5), 0);		plPoly0[i].addVertex( plPoly0_PT1);
		}

		else if ( sAllInsts[i] == sInstList[5]) {
//DUMMY
			Point3d plPoly_PT = Point3d( U(-12.839861), U(-14.280429), 0);			plPoly[i].addVertex( plPoly_PT);
			Point3d plPoly_PT0 = plPoly_PT + Point3d( U(13.856406), U(8), 0);		plPoly[i].addVertex( plPoly_PT0, 1);
			Point3d plPoly_PT1 = plPoly_PT0 + Point3d( U(-13.856406), U(-8), 0);	plPoly[i].addVertex( plPoly_PT1, 1);
		}
		else if ( sAllInsts[i] == sInstList[6]) {
//DUMMY
			Point3d plPoly_PT = Point3d( U(-12.839861), U(-14.280429), 0);			plPoly[i].addVertex( plPoly_PT);
			Point3d plPoly_PT0 = plPoly_PT + Point3d( U(13.856406), U(8), 0);		plPoly[i].addVertex( plPoly_PT0, 1);
			Point3d plPoly_PT1 = plPoly_PT0 + Point3d( U(-13.856406), U(-8), 0);	plPoly[i].addVertex( plPoly_PT1, 1);
		}
		else if ( sAllInsts[i] == sInstList[7]) {
//DUMMY
			Point3d plPoly_PT = Point3d( U(-12.839861), U(-14.280429), 0);			plPoly[i].addVertex( plPoly_PT);
			Point3d plPoly_PT0 = plPoly_PT + Point3d( U(13.856406), U(8), 0);		plPoly[i].addVertex( plPoly_PT0, 1);
			Point3d plPoly_PT1 = plPoly_PT0 + Point3d( U(-13.856406), U(-8), 0);	plPoly[i].addVertex( plPoly_PT1, 1);
		}
		else if ( sAllInsts[i] == sInstList[9]) {
		// Dimmer
			Point3d plPoly_PT = Point3d( U(-6.9282032), U(-4), 0);								plPoly[i].addVertex( plPoly_PT);
			Point3d plPoly_PT0 = plPoly_PT + Point3d( U(-21.632655), U(-12.489619), 0);		plPoly[i].addVertex( plPoly_PT0);
		
			Point3d plPoly0_PT =  Point3d( U(-6.9282032), U(-4), 0);								plPoly0[i].addVertex( plPoly0_PT);
			Point3d plPoly0_PT0 = plPoly0_PT + Point3d( U(13.856406), U(8), 0);				plPoly0[i].addVertex( plPoly0_PT0, 1);
			Point3d plPoly0_PT1 = plPoly0_PT0 + Point3d( U(-13.856406), U(-8), 0);			plPoly0[i].addVertex( plPoly0_PT1, 1);
		
			Point3d plPoly1_PT = Point3d( U(6.9282032), U(4), 0);								plPoly1[i].addVertex( plPoly1_PT);
			Point3d plPoly1_PT0 = plPoly1_PT + Point3d( U(21.632655), U(12.489619), 0);		plPoly1[i].addVertex( plPoly1_PT0);
		
			Point3d plPoly2_PT = Point3d( U(39.607156), U(22.867202), 0);						plPoly2[i].addVertex( plPoly2_PT);
			Point3d plPoly2_PT0 = plPoly2_PT + Point3d( U(-12.710494), U(-3.4951113), 0);	plPoly2[i].addVertex( plPoly2_PT0);
			Point3d plPoly2_PT1 = plPoly2_PT0 + Point3d( U(3.3283917), U(-5.7649434), 0);	plPoly2[i].addVertex( plPoly2_PT1);
			Point3d plPoly2_PT2 = plPoly2_PT1 + Point3d( U(9.3821019), U(9.2600547), 0);		plPoly2[i].addVertex( plPoly2_PT2);
		
			ppPoly[i] = PlaneProfile(plPoly2[i]);
		}
		else if ( sAllInsts[i] == sInstList[10]) {
//DUMMY
			Point3d plPoly_PT = Point3d( U(-12.839861), U(-14.280429), 0);			plPoly[i].addVertex( plPoly_PT);
			Point3d plPoly_PT0 = plPoly_PT + Point3d( U(13.856406), U(8), 0);		plPoly[i].addVertex( plPoly_PT0, 1);
			Point3d plPoly_PT1 = plPoly_PT0 + Point3d( U(-13.856406), U(-8), 0);	plPoly[i].addVertex( plPoly_PT1, 1);
		}
		else if ( sAllInsts[i] == sInstList[11]) {
//DUMMY
			Point3d plPoly_PT = Point3d( U(-12.839861), U(-14.280429), 0);			plPoly[i].addVertex( plPoly_PT);
			Point3d plPoly_PT0 = plPoly_PT + Point3d( U(13.856406), U(8), 0);		plPoly[i].addVertex( plPoly_PT0, 1);
			Point3d plPoly_PT1 = plPoly_PT0 + Point3d( U(-13.856406), U(-8), 0);	plPoly[i].addVertex( plPoly_PT1, 1);
		}
		else if ( sAllInsts[i] == sInstList[12]) {
//DUMMY
			Point3d plPoly_PT = Point3d( U(-12.839861), U(-14.280429), 0);			plPoly[i].addVertex( plPoly_PT);
			Point3d plPoly_PT0 = plPoly_PT + Point3d( U(13.856406), U(8), 0);		plPoly[i].addVertex( plPoly_PT0, 1);
			Point3d plPoly_PT1 = plPoly_PT0 + Point3d( U(-13.856406), U(-8), 0);	plPoly[i].addVertex( plPoly_PT1, 1);
		}
		else if ( sAllInsts[i] == sInstList[13]) {
//DUMMY
			Point3d plPoly_PT = Point3d( U(-12.839861), U(-14.280429), 0);			plPoly[i].addVertex( plPoly_PT);
			Point3d plPoly_PT0 = plPoly_PT + Point3d( U(13.856406), U(8), 0);		plPoly[i].addVertex( plPoly_PT0, 1);
			Point3d plPoly_PT1 = plPoly_PT0 + Point3d( U(-13.856406), U(-8), 0);	plPoly[i].addVertex( plPoly_PT1, 1);
		}
		else if ( sAllInsts[i] == sInstList[14]) {
//DUMMY
			Point3d plPoly_PT = Point3d( U(-12.839861), U(-14.280429), 0);			plPoly[i].addVertex( plPoly_PT);
			Point3d plPoly_PT0 = plPoly_PT + Point3d( U(13.856406), U(8), 0);		plPoly[i].addVertex( plPoly_PT0, 1);
			Point3d plPoly_PT1 = plPoly_PT0 + Point3d( U(-13.856406), U(-8), 0);	plPoly[i].addVertex( plPoly_PT1, 1);
		}
		else if ( sAllInsts[i] == sInstList[15]) {
//DUMMY
			Point3d plPoly_PT = Point3d( U(-12.839861), U(-14.280429), 0);			plPoly[i].addVertex( plPoly_PT);
			Point3d plPoly_PT0 = plPoly_PT + Point3d( U(13.856406), U(8), 0);		plPoly[i].addVertex( plPoly_PT0, 1);
			Point3d plPoly_PT1 = plPoly_PT0 + Point3d( U(-13.856406), U(-8), 0);	plPoly[i].addVertex( plPoly_PT1, 1);
		}
		else if ( sAllInsts[i] == sInstList[16]) {
//DUMMY
			Point3d plPoly_PT = Point3d( U(-12.839861), U(-14.280429), 0);			plPoly[i].addVertex( plPoly_PT);
			Point3d plPoly_PT0 = plPoly_PT + Point3d( U(13.856406), U(8), 0);		plPoly[i].addVertex( plPoly_PT0, 1);
			Point3d plPoly_PT1 = plPoly_PT0 + Point3d( U(-13.856406), U(-8), 0);	plPoly[i].addVertex( plPoly_PT1, 1);
		}
		else if ( sAllInsts[i] == sInstList[17]) {
		// Kreuzschalter
			Point3d plPoly_PT = Point3d( U(-6.9282032), U(-4), 0);						plPoly[i].addVertex( plPoly_PT);
			Point3d plPoly_PT0 = plPoly_PT + Point3d( U(13.856406), U(8), 0);			plPoly[i].addVertex( plPoly_PT0, 1);
			Point3d plPoly_PT1 = plPoly_PT0 + Point3d( U(-13.856406), U(-8), 0);		plPoly[i].addVertex( plPoly_PT1, 1);
		
			Point3d plPoly0_PT = Point3d( U(-4), U(-6.9282032), 0);								plPoly0[i].addVertex( plPoly0_PT);
			Point3d plPoly0_PT0 = plPoly0_PT + Point3d( U(-12.489619), U(-21.632655), 0);	plPoly0[i].addVertex( plPoly0_PT0);
			Point3d plPoly0_PT1 = plPoly0_PT0 + Point3d( U(-4.330127), U(2.5), 0);			plPoly0[i].addVertex( plPoly0_PT1);
		
			Point3d plPoly1_PT = Point3d( U(4), U(-6.9282032), 0);								plPoly1[i].addVertex( plPoly1_PT);
			Point3d plPoly1_PT0 = plPoly1_PT + Point3d( U(12.489619), U(-21.632655), 0);		plPoly1[i].addVertex( plPoly1_PT0);
			Point3d plPoly1_PT1 = plPoly1_PT0 + Point3d( U(4.330127), U(2.5), 0);				plPoly1[i].addVertex( plPoly1_PT1);
		
			Point3d plPoly2_PT = Point3d( U(-4), U(6.9282032), 0);								plPoly2[i].addVertex( plPoly2_PT);
			Point3d plPoly2_PT0 = plPoly2_PT + Point3d( U(-12.489619), U(21.632655), 0);		plPoly2[i].addVertex( plPoly2_PT0);
			Point3d plPoly2_PT1 = plPoly2_PT0 + Point3d( U(-4.330127), U(-2.5), 0);			plPoly2[i].addVertex( plPoly2_PT1);
		
			Point3d plPoly3_PT = Point3d( U(4), U(6.9282032), 0);								plPoly3[i].addVertex( plPoly3_PT);
			Point3d plPoly3_PT0 = plPoly3_PT + Point3d( U(12.489619), U(21.632655), 0);		plPoly3[i].addVertex( plPoly3_PT0);
			Point3d plPoly3_PT1 = plPoly3_PT0 + Point3d( U(4.330127), U(-2.5), 0);			plPoly3[i].addVertex( plPoly3_PT1);
		}// end kreuzschalter
		else if ( sAllInsts[i] == sInstList[18]) {
//DUMMY
			Point3d plPoly_PT = Point3d( U(-12.839861), U(-14.280429), 0);			plPoly[i].addVertex( plPoly_PT);
			Point3d plPoly_PT0 = plPoly_PT + Point3d( U(13.856406), U(8), 0);		plPoly[i].addVertex( plPoly_PT0, 1);
			Point3d plPoly_PT1 = plPoly_PT0 + Point3d( U(-13.856406), U(-8), 0);	plPoly[i].addVertex( plPoly_PT1, 1);
		}
		else if ( sAllInsts[i] == sInstList[19] || sAllInsts[i] == sInstList[20] || 
				   sAllInsts[i] == sInstList[21] || sAllInsts[i] == sInstList[22] || sAllInsts[i] == sInstList[23]) {
		// Leuchte allgemein
			Point3d plPoly_PT = Point3d( 0, U(-30), 0);											plPoly[i].addVertex( plPoly_PT);
			Point3d plPoly_PT0 = plPoly_PT + Point3d( 0, U(36.364137), 0);						plPoly[i].addVertex( plPoly_PT0);
			Point3d plPoly_PT1 = plPoly_PT0 + Point3d( U(17.67767), U(17.67767), 0);			plPoly[i].addVertex( plPoly_PT1);
			Point3d plPoly_PT2 = plPoly_PT1 + Point3d( U(-35.355339), U(-35.355339), 0);		plPoly[i].addVertex( plPoly_PT2);
			Point3d plPoly_PT3 = plPoly_PT2 + Point3d( U(17.67767), U(17.67767), 0);			plPoly[i].addVertex( plPoly_PT3);
			Point3d plPoly_PT4 = plPoly_PT3 + Point3d( U(17.67767), U(-17.67767), 0);		plPoly[i].addVertex( plPoly_PT4);
			Point3d plPoly_PT5 = plPoly_PT4 + Point3d( U(-35.355339), U(35.355339), 0);		plPoly[i].addVertex( plPoly_PT5);
		}

		else if ( sAllInsts[i] == sInstList[24]) {
//DUMMY
			Point3d plPoly_PT = Point3d( U(-12.839861), U(-14.280429), 0);			plPoly[i].addVertex( plPoly_PT);
			Point3d plPoly_PT0 = plPoly_PT + Point3d( U(13.856406), U(8), 0);		plPoly[i].addVertex( plPoly_PT0, 1);
			Point3d plPoly_PT1 = plPoly_PT0 + Point3d( U(-13.856406), U(-8), 0);	plPoly[i].addVertex( plPoly_PT1, 1);
		}


		else if ( sAllInsts[i] == sInstList[25]) {
//DUMMY
			Point3d plPoly_PT = Point3d( U(-12.839861), U(-14.280429), 0);			plPoly[i].addVertex( plPoly_PT);
			Point3d plPoly_PT0 = plPoly_PT + Point3d( U(13.856406), U(8), 0);		plPoly[i].addVertex( plPoly_PT0, 1);
			Point3d plPoly_PT1 = plPoly_PT0 + Point3d( U(-13.856406), U(-8), 0);	plPoly[i].addVertex( plPoly_PT1, 1);
		}


		else if ( sAllInsts[i] == sInstList[26]) {
//DUMMY
			Point3d plPoly_PT = Point3d( U(-12.839861), U(-14.280429), 0);			plPoly[i].addVertex( plPoly_PT);
			Point3d plPoly_PT0 = plPoly_PT + Point3d( U(13.856406), U(8), 0);		plPoly[i].addVertex( plPoly_PT0, 1);
			Point3d plPoly_PT1 = plPoly_PT0 + Point3d( U(-13.856406), U(-8), 0);	plPoly[i].addVertex( plPoly_PT1, 1);
		}


		else if ( sAllInsts[i] == sInstList[27]) {
//DUMMY
			Point3d plPoly_PT = Point3d( U(-12.839861), U(-14.280429), 0);			plPoly[i].addVertex( plPoly_PT);
			Point3d plPoly_PT0 = plPoly_PT + Point3d( U(13.856406), U(8), 0);		plPoly[i].addVertex( plPoly_PT0, 1);
			Point3d plPoly_PT1 = plPoly_PT0 + Point3d( U(-13.856406), U(-8), 0);	plPoly[i].addVertex( plPoly_PT1, 1);
		}

		else if ( sAllInsts[i] == sInstList[28]) {
		// Serienschalter
			Point3d plPoly_PT = Point3d( U(-6.9282032), U(-14.280429), 0);						plPoly[i].addVertex( plPoly_PT);
			Point3d plPoly_PT0 = plPoly_PT + Point3d( U(13.856406), U(8), 0);					plPoly[i].addVertex( plPoly_PT0, 1);
			Point3d plPoly_PT1 = plPoly_PT0 + Point3d( U(-13.856406), U(-8), 0);				plPoly[i].addVertex( plPoly_PT1, 1);
		
			Point3d plPoly0_PT = Point3d( U(4), U(-3.352226), 0);								plPoly0[i].addVertex( plPoly0_PT);
			Point3d plPoly0_PT0 = plPoly0_PT + Point3d( U(12.489619), U(21.632655), 0);		plPoly0[i].addVertex( plPoly0_PT0);
			Point3d plPoly0_PT1 = plPoly0_PT0 + Point3d( U(4.330127), U(-2.5), 0);			plPoly0[i].addVertex( plPoly0_PT1);
		
			Point3d plPoly1_PT = Point3d( U(-4), U(-3.352226), 0);								plPoly1[i].addVertex( plPoly1_PT);
			Point3d plPoly1_PT0 = plPoly1_PT + Point3d( U(-12.489619), U(21.632655), 0);		plPoly1[i].addVertex( plPoly1_PT0);
			Point3d plPoly1_PT1 = plPoly1_PT0 + Point3d( U(-4.330127), U(-2.5), 0);			plPoly1[i].addVertex( plPoly1_PT1);
		}

		else if ( sAllInsts[i] == sInstList[29]) {
//DUMMY
			Point3d plPoly_PT = Point3d( U(-12.839861), U(-14.280429), 0);			plPoly[i].addVertex( plPoly_PT);
			Point3d plPoly_PT0 = plPoly_PT + Point3d( U(13.856406), U(8), 0);		plPoly[i].addVertex( plPoly_PT0, 1);
			Point3d plPoly_PT1 = plPoly_PT0 + Point3d( U(-13.856406), U(-8), 0);	plPoly[i].addVertex( plPoly_PT1, 1);
		}


		else if ( sAllInsts[i] == sInstList[30]) {
//DUMMY
			Point3d plPoly_PT = Point3d( U(-12.839861), U(-14.280429), 0);			plPoly[i].addVertex( plPoly_PT);
			Point3d plPoly_PT0 = plPoly_PT + Point3d( U(13.856406), U(8), 0);		plPoly[i].addVertex( plPoly_PT0, 1);
			Point3d plPoly_PT1 = plPoly_PT0 + Point3d( U(-13.856406), U(-8), 0);	plPoly[i].addVertex( plPoly_PT1, 1);
		}

		else if ( sAllInsts[i] == sInstList[31]) {
		// Steckdose
			Point3d plPoly_PT = Point3d( 0, U(20), 0);										plPoly[i].addVertex( plPoly_PT);
			Point3d plPoly_PT0 = plPoly_PT + Point3d( 0, U(-13.5), 0);					plPoly[i].addVertex( plPoly_PT0);
			Point3d plPoly_PT1 = plPoly_PT0 + Point3d( U(-18), 0, 0);					plPoly[i].addVertex( plPoly_PT1);
			Point3d plPoly_PT2 = plPoly_PT1 + Point3d( U(36), 0, 0);						plPoly[i].addVertex( plPoly_PT2);
		
			Point3d plPoly0_PT = Point3d( U(-20.25), U(-13.75), 0);						plPoly0[i].addVertex( plPoly0_PT);
			Point3d plPoly0_PT0 = plPoly0_PT + Point3d( U(40.5), 0, 0);					plPoly0[i].addVertex( plPoly0_PT0, nSide);
		}

		else if ( sAllInsts[i] == sInstList[32]) {
//DUMMY
			Point3d plPoly_PT = Point3d( U(-12.839861), U(-14.280429), 0);			plPoly[i].addVertex( plPoly_PT);
			Point3d plPoly_PT0 = plPoly_PT + Point3d( U(13.856406), U(8), 0);		plPoly[i].addVertex( plPoly_PT0, 1);
			Point3d plPoly_PT1 = plPoly_PT0 + Point3d( U(-13.856406), U(-8), 0);	plPoly[i].addVertex( plPoly_PT1, 1);
		}

		else if ( sAllInsts[i] == sInstList[33]) {
//DUMMY
			Point3d plPoly_PT = Point3d( U(-12.839861), U(-14.280429), 0);			plPoly[i].addVertex( plPoly_PT);
			Point3d plPoly_PT0 = plPoly_PT + Point3d( U(13.856406), U(8), 0);		plPoly[i].addVertex( plPoly_PT0, 1);
			Point3d plPoly_PT1 = plPoly_PT0 + Point3d( U(-13.856406), U(-8), 0);	plPoly[i].addVertex( plPoly_PT1, 1);
		}


		else if ( sAllInsts[i] == sInstList[34]) {
//DUMMY
			Point3d plPoly_PT = Point3d( U(-12.839861), U(-14.280429), 0);			plPoly[i].addVertex( plPoly_PT);
			Point3d plPoly_PT0 = plPoly_PT + Point3d( U(13.856406), U(8), 0);		plPoly[i].addVertex( plPoly_PT0, 1);
			Point3d plPoly_PT1 = plPoly_PT0 + Point3d( U(-13.856406), U(-8), 0);	plPoly[i].addVertex( plPoly_PT1, 1);
		}


		else if ( sAllInsts[i] == sInstList[35]) {
//DUMMY
			Point3d plPoly_PT = Point3d( U(-12.839861), U(-14.280429), 0);			plPoly[i].addVertex( plPoly_PT);
			Point3d plPoly_PT0 = plPoly_PT + Point3d( U(13.856406), U(8), 0);		plPoly[i].addVertex( plPoly_PT0, 1);
			Point3d plPoly_PT1 = plPoly_PT0 + Point3d( U(-13.856406), U(-8), 0);	plPoly[i].addVertex( plPoly_PT1, 1);
		}


		else if ( sAllInsts[i] == sInstList[36]) {
//DUMMY
			Point3d plPoly_PT = Point3d( U(-12.839861), U(-14.280429), 0);			plPoly[i].addVertex( plPoly_PT);
			Point3d plPoly_PT0 = plPoly_PT + Point3d( U(13.856406), U(8), 0);		plPoly[i].addVertex( plPoly_PT0, 1);
			Point3d plPoly_PT1 = plPoly_PT0 + Point3d( U(-13.856406), U(-8), 0);	plPoly[i].addVertex( plPoly_PT1, 1);
		}


		else if ( sAllInsts[i] == sInstList[37]) {
//DUMMY
			Point3d plPoly_PT = Point3d( U(-12.839861), U(-14.280429), 0);			plPoly[i].addVertex( plPoly_PT);
			Point3d plPoly_PT0 = plPoly_PT + Point3d( U(13.856406), U(8), 0);		plPoly[i].addVertex( plPoly_PT0, 1);
			Point3d plPoly_PT1 = plPoly_PT0 + Point3d( U(-13.856406), U(-8), 0);	plPoly[i].addVertex( plPoly_PT1, 1);
		}


		else if ( sAllInsts[i] == sInstList[38]) {
//DUMMY
			Point3d plPoly_PT = Point3d( U(-12.839861), U(-14.280429), 0);			plPoly[i].addVertex( plPoly_PT);
			Point3d plPoly_PT0 = plPoly_PT + Point3d( U(13.856406), U(8), 0);		plPoly[i].addVertex( plPoly_PT0, 1);
			Point3d plPoly_PT1 = plPoly_PT0 + Point3d( U(-13.856406), U(-8), 0);	plPoly[i].addVertex( plPoly_PT1, 1);
		}



		// derivates from leuchte allgemein
		if ( sAllInsts[i] == sInstList[21]) {
		// leuchte 2
			Point3d plPoly_PT = Point3d( U(-17.67767), U(24.04195), 0);					plPoly1[i].addVertex( plPoly_PT);
			Point3d plPoly_PT0 = plPoly_PT + Point3d( U(4.278425), U(4.278425), 0);	plPoly1[i].addVertex( plPoly_PT0);
		}
		if ( sAllInsts[i] == sInstList[23]) {
		// leuchte 4
			Point3d plPoly_PT = Point3d(U(-2.5) , U(6.364137), 0);					plPoly1[i].addVertex( plPoly_PT);
			Point3d plPoly_PT0 = plPoly_PT + Point3d( U(5), 0, 0);					plPoly1[i].addVertex( plPoly_PT0, 1);
			Point3d plPoly_PT1 = plPoly_PT0 + Point3d( U(-5), 0, 0);					plPoly1[i].addVertex( plPoly_PT1, 1);

			ppPoly[i] = PlaneProfile(plPoly1[i]);
		}
	}//next i
	
// some ints
	int nNumInst;
	for (int i = 0; i < sAllInsts.length(); i++)
		if ( sAllInsts[i] != "")
			nNumInst ++;
	
	// outmost zone
	int nZone;
	for (int i=1;i<6;i++)
		if (el.zone(nSide*i).dH()>0)
			nZone=nSide*i;
	// HSB-23217
	if(nZoneTooling>0)
	{ 
		// another zone is selected
		if(abs(nZoneTooling)>nZone)
		{ 
			nZoneTooling.set(abs(nZone));
		}
		else if(abs(nZoneTooling)<nZone)
		{ 
			nZone=nSide*nZoneTooling;
		}
	}
	
// append grip for guideline
	if (_PtG.length() <= 0)
		_PtG.append(_Pt0 + vzE * U(100));
	
// relocate grip if insertion moved
   double dxE;
	dxE=vx.dotProduct(_Pt0-_PtG[0]);
	if (_kNameLastChangedProp == "_Pt0")
		_PtG[0]=_Pt0+vzE*U(100)-vx*dxE;
	
// define point of installation
	Point3d ptInst=_Pt0-vz*dOffsetZone0+vy*dElevation;
	ptInst.vis(2);
	
// collect beams & sheets
	Beam bm[0];
	bm= el.beam();
	Sheet sh[0];
	sh= el.sheet();	
	
// Display for elementview
	Display dpElement(nColor), dpModel(nColor);
	dpElement.addViewDirection(vz);
	if (nShowInZone < 0)
		dpElement.addViewDirection(-vz);	
	dpElement.dimStyle(sDimStyle);
	dpElement.elemZone(el,nShowInZone, 'Z');
	
// diplay drills
	
	Point3d ptDrill=ptInst+nSide*vzE*dOffsetZone0-((double)nNumInst-1)/2*vxE*dModelInstallationOffset;
	
// drills
	if (nShape==0)
	{
		for ( int i = 1; i <= nNumInst; i++) {
	
			
			Body bdDose ( ptDrill, ptDrill - vzE * dDepthInst, dDiam/2);
			dpModel.draw(bdDose);
			Drill dr( ptDrill, ptDrill - vzE * dDepthInst, dDiam/2);
	
			dr.addMeToGenBeamsIntersect(bm);
			dr.addMeToGenBeamsIntersect(sh);
			
			if (sWPTool == sWPTools[0]){
				PLine plCirc(vzE);
				plCirc.createCircle(	ptDrill, vzE, 	dDiam/2);		
				ElemMill elMill(nZone,plCirc,dDepthInst,nToolIndex,_kLeft,_kTurnWithCourse,_kNoOverShoot);
				if(nElementTooling)
					el.addTool(elMill);
			}
			else if (sWPTool == sWPTools[1]){			
				ElemDrill elDrill(nZone,ptDrill,-vzE, dDepthInst,dDiam,nToolIndex);
				if(nElementTooling)
					el.addTool(elDrill);			
			}
			
			// no nail areas
			for(int i = 1; i < 6; i++){
				if(el.zone(i*nSide).dH() > 0 && i != 0){
					Point3d ptPl [0];
					ptPl.append (ptDrill + dDiam/2 * vx + dDiam/2 * vy);
					ptPl.append (ptDrill + dDiam/2 * vx + dDiam/2 * -vy);
					ptPl.append (ptDrill + dDiam/2 * -vx + dDiam/2 * -vy);
					ptPl.append (ptDrill + dDiam/2 * -vx + dDiam/2 * vy);
					PLine pl1 (vz);
					for (int j = 0; j < 4; j++)
						pl1.addVertex(ptPl[j]);
					pl1.close();
					PlaneProfile pp (pl1);
					pp.shrink (U(-0.1 * dMillWidth));
					PLine pl2[] = pp.allRings();
				
					if (pl2.length() > 0 &&  sWPTool!= sWPTools[2])// th 19.01.2007, 01.08.2007
					{
						ElemNoNail elemNN (i*nSide, pl2[0]);
						if(nElementTooling)
							el.addTool (elemNN);
					}
				}//end if
			}//end for	
		
			ptDrill.transformBy(vxE*dModelInstallationOffset);		
		}
	// publish dimpoints
		if (_Map.hasPoint3d("ptExtraDim1"))_Map.removeAt("ptExtraDim1",true);
		if (_Map.hasPoint3d("ptExtraDim2"))_Map.removeAt("ptExtraDim2",true);
		_Map.setPoint3d("ptExtraDim0",ptInst);	

	}
// slotted hole or rectangular		
	else if (nShape==1 || nShape==2)
	{
		Point3d ptRef = ptInst + nSide * vzE * dOffsetZone0;
		PLine plTool(vzE);
		double dY = dDiam;
		double dX = (nNumInst-1)*dModelInstallationOffset+dDiam;
		LineSeg seg (ptRef-.5*(vxE*dX-vyE*dY),ptRef+.5*(vxE*dX-vyE*dY));
		int nToolSide =  _kLeft;
		if(nShape==1)
		{
			plTool.addVertex(ptRef-.5*(-vyE*dY));		
			plTool.addVertex(ptRef-.5*(vxE*(dX-dY)-vyE*dY));
			plTool.addVertex(ptRef-.5*(vxE*(dX-dY)+vyE*dY),1);
			plTool.addVertex(ptRef+.5*(vxE*(dX-dY)-vyE*dY));
			plTool.addVertex(ptRef+.5*(vxE*(dX-dY)+vyE*dY),1);
			plTool.close();
		}
		else
		{
			plTool.createRectangle(seg,vxE,vyE);
			nToolSide =  _kRight;
		}	
		plTool.vis(1);		

		if (nWPTool!=2)
		{
			ElemMill elMill(nZone,plTool,dDepthInst,  0,nToolSide ,_kTurnWithCourse,_kNoOverShoot);
			if(nElementTooling)
				el.addTool(elMill);
		}
		
		Body bd(plTool, vzE*dDepthInst*2,0);
		SolidSubtract sosu(bd,_kSubtract);
		sosu.addMeToGenBeamsIntersect(sh);
		
		PLine plNN;
		plNN.createRectangle(seg,vxE,vyE);
		if(plNN.area()>pow(dEps,2))
			for(int i = 1; i < 6; i++)
				if(el.zone(i*nZone).dH() > 0)	
					if(nElementTooling)
						el.addTool(ElemNoNail(i*nSide, plNN));	
					
	// publish dimpoints
		_Map.setPoint3d("ptExtraDim0",ptInst);				
		_Map.setPoint3d("ptExtraDim1",seg.ptStart());	
		_Map.setPoint3d("ptExtraDim2",seg.ptEnd());	
	}


// define milling
	BeamCut bc0(ptInst, vy , vx, vzE, U(20000), dMillWidth, dMillDepth * 2, nMillAlignment-1, 0, 0);
	BeamCut bc1;
	if(nMillAlignment == 3){
		// add another grip
		if (_PtG.length() <= 1)
			_PtG.append(_Pt0 + vx * U(400));
		bc0.transformBy(-vy * U(20000) + vx * vx.dotProduct(_PtG[1] - _Pt0));

		bc1 = BeamCut(ptInst, vy , vx, vzE, U(20000), dMillWidth, dMillDepth * 2, -1, 0, 0);
	}

	
// add tools to beams
	if (nMillAlignment != 4) // none
		for (int i = 0; i < bm.length(); i++)
		{
			bm[i].addTool(bc0);
			if(nMillAlignment == 2)
				bm[i].addTool(bc1);
		}
	
// collect points on ptIns
	Point3d ptEnvelope[0];
	PLine plEnvelope= el.plEnvelope();
	plEnvelope.vis(5);

	Body bdCombine;
	for (int i=0; i<bm.length();i++)
	{
		if (bm[i].bIsDummy()) continue;
		Body bd = bm[i].realBody();
		//bd.vis(40);
		bdCombine.combine(bd); 	
	}
	PlaneProfile ppShadow=bdCombine.shadowProfile(Plane(p0,vz));
	if (ppShadow.area()>pow(dEps,2))
	{
		LineSeg segs[] = ppShadow.splitSegments(LineSeg(ptInst-vy*U(10000),ptInst+vy*U(10000)), true);
		for (int i=0;i<segs.length();i++)
		{
			ptEnvelope.append(segs[i].ptStart());
			ptEnvelope.append(segs[i].ptStart());
		}
	}
	else
		ptEnvelope = plEnvelope.intersectPoints(ptInst, vy);
	Line(ptInst, vy).orderPoints(ptEnvelope);


// define pline for tubes
	Point3d ptNN[0];// extremes for NoNails
	PLine pl(vz);
	// T("Bottom"),T("Both"),T("Top"),T("Kabelführung versetzen"), T("none")};
	if (nMillAlignment == 0 || nMillAlignment == 2){
		ptNN.append(ptInst);
		pl.addVertex(ptInst);
	}
	if (nMillAlignment == 1 || nMillAlignment == 2 )//|| nMillAlignment == 3)
		if (ptEnvelope.length() > 0){
			ptNN.append(ptEnvelope[ptEnvelope.length() -1]);
			pl.addVertex(ptEnvelope[ptEnvelope.length() -1]);
		}
	if (nMillAlignment !=2 && nMillAlignment != 4)
		if (ptEnvelope.length() > 0){
			ptNN.append(ptEnvelope[0]);			
		  	pl.addVertex(ptEnvelope[0]);
		}

	if (nMillAlignment == 3){													//offset tube duction
		for(int i = 0; i < ptNN.length(); i++)
			ptNN[i].transformBy(vx * vx.dotProduct(_PtG[1] - _Pt0));
		pl.transformBy(vx * vx.dotProduct(_PtG[1] - _Pt0));
		pl.addVertex(_Pt0 - vz * dOffsetZone0);
		pl.addVertex(ptInst);
		PLine plNN(vz);
		plNN.addVertex(_Pt0 - vz * dOffsetZone0 - vx * dMillWidth/2);
		plNN.addVertex(_Pt0 - vz * dOffsetZone0 + vx * dMillWidth/2);
		plNN.addVertex(ptInst - vz * dOffsetZone0 + vx * dMillWidth/2);
		plNN.addVertex(ptInst - vz * dOffsetZone0 - vx * dMillWidth/2);
		plNN.close();
		for(int i = 1; i < 6; i++)
			if(el.zone(i*nZone).dH() > 0)
				if(nElementTooling)
					el.addTool(ElemNoNail(i*nSide, plNN));			
	}
	
	dpElement.draw(pl);
	
	// text instheight
	  String sVText ;
	  sVText.formatUnit(dElevation,2,nDigits);
	  if (_PtG.length() <= 2)
		_PtG.append(ptInst + (vx + vy) * dDiam);
	  if (_PtG.length()>2){
		_PtG[2] = _PtG[2] - vz * vz.dotProduct(_PtG[2] - _Pt0);
		dpElement.draw(T("h=") + sVText,_PtG[2] ,vx,vy,1,1,_kDevice );
	  }


// Display planview

	// guideline
	  PLine plHilf(_Pt0, _PtG[0]);
	  dpPlan.draw(plHilf);

	// text instheight
	  String sHText ;
	  sHText.formatUnit(dElevation,2,nDigits);
	  Point3d ptTxt;
	  ptTxt = _PtG[0] + vxE * dPlanInstallationOffset;
	  dpPlan.draw(sHText,ptTxt ,nSide * vx,-vzE,-nSide,0);

	// draw blocks
	  Vector3d vxBlock = vx;
		double dScaleFactor = 1.6;
	  //Point3d ptBlock = _PtG[0];
	  if (sAlignment ==	 sAlignments[1])
		vxBlock = vzE;
	  //else
	  //	ptBlock.transformBy(- vxBlock * (nNumInst -1)/2 * dPlanInstallationOffset * dScaleFactor);

	// scale graphics
	  CoordSys csScale(_Pt0, vx * dScale, vzE * dScale, vy * dScale);
	  

	  for (int i = 0; i < sAllInsts.length(); i++){
		if ( sAllInsts[i] != ""){
			plPoly[i].transformBy(csScale);	
			plPoly0[i].transformBy(csScale);	
			plPoly1[i].transformBy(csScale);	
			plPoly2[i].transformBy(csScale);	
			plPoly3[i].transformBy(csScale);	

			ppPoly[i].transformBy(csScale);	

			Vector3d vXY = _PtG[0] - _Pt0;
			if (sAlignment == sAlignments[1])
				vXY = vXY + vxBlock * i * dPlanInstallationOffset + vzE * dPlanInstallationOffset/2 * dScale;
			else
				vXY = vXY + vxBlock * (((double)nNumInst -1)/2 - i)* dPlanInstallationOffset + vzE * dPlanInstallationOffset/2 * dScale;				
			plPoly[i].transformBy(vXY);
			plPoly0[i].transformBy(vXY);
			plPoly1[i].transformBy(vXY);
			plPoly2[i].transformBy(vXY);
			plPoly3[i].transformBy(vXY);

			ppPoly[i].transformBy(vXY);	

			//Block bl0(sAllInsts[i]);
			//dpPlan.draw(bl0,ptBlock, vxE,-vzE,vy);
			dpPlan.draw(plPoly[i]);
			dpPlan.draw(plPoly0[i]);
			dpPlan.draw(plPoly1[i]);
			dpPlan.draw(plPoly2[i]);
			dpPlan.draw(plPoly3[i]);


			dpPlan.draw(ppPoly[i],_kDrawFilled);
			//ptBlock.transformBy(vxBlock * dPlanInstallationOffset * dScaleFactor);
		}
	  }

// assigning
	assignToElementGroup(el,TRUE,0,'E');
	
// no nail areas
	if (nMillAlignment <3)
	{
		Point3d ptPl [0];
		ptPl.append (ptNN[0] + dMillWidth/2 * vx);
		ptPl.append (ptNN[1] + dMillWidth/2 * vx);// + (ptInst.Z() - _Pt0.Z()) * -vy);
		ptPl.append (ptNN[1]  + dMillWidth/2 * -vx);// + (ptInst.Z() - _Pt0.Z()) * -vy);
		ptPl.append (ptNN[0] + dMillWidth/2 * -vx);
		PLine pl1 (vz);
		for (int j = 0; j < 4; j++)
			pl1.addVertex(ptPl[j]);
		pl1.close();
	
		for(int i = 1; i < 6; i++)
		{
			if(el.zone(i * nSide).dH() > dEps && sWPTool!= sWPTools[2]){
				ElemNoNail elemNN (i*nSide, pl1);
				if(nElementTooling)
					el.addTool (elemNN);
					
				ptPl[0].vis(3);
				ptPl[1].vis(2);
				ptPl[2].vis(3);
				ptPl[3].vis(4);
			}//end if
		}//end for
	}
	ptInst.vis(3);



	vxE.vis(_PtG[0],1);
	vyE.vis(_PtG[0],3);
	vzE.vis(_PtG[0],150);



// export
	HardWrComp hwComps[0];
	String sCompKey;
	for (int i=0;i<sAllInsts.length();i++)
	{
		String sArticle = sAllInsts[i];
		if (sArticle.length()<1)continue;
		sCompKey+=sArticle+"_"+_ThisInst.modelDescription();
		int nQty = 1;
		HardWrComp hw(sArticle ,nQty );	
		hw.setCategory(T("|Electrical|"));
		//hw.setManufacturer(sManufacturer);
		hw.setModel(sArticle);
		hw.setMaterial(_ThisInst.materialDescription());		
		hw.setDescription(sArticle);
		//hwNail.setDScaleX(dLength);
		//hwNail.setDScaleY(dRadius*2);
		hw.setDScaleZ(0);	
		hwComps.append(hw);			
	}
	_ThisInst.setHardWrComps(hwComps);
	setCompareKey(sCompKey);









#End
#BeginThumbnail
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
.6C10`4444`%%%%`'_]D`



#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="191" />
        <int nm="BreakPoint" vl="654" />
        <int nm="BreakPoint" vl="215" />
        <int nm="BreakPoint" vl="651" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23217: Add property &quot;Tooling zone&quot; to controle zone of element tooling" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="12/20/2024 1:55:06 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16454: Add property that controll to add element tooling or not" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="9/15/2022 4:36:59 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End