#Version 8
#BeginDescription
#Versions
Version 2.3 08/09/2025 HSB-24486: Fix vx0,vy0,vz0 for the case with panels , Author Marsel Nakuci
Version 2.2 03.09.2025 HSB-24485: Add support for panels , Author: Marsel Nakuci
Version 2.1 18.12.2023 HSB-20935 bugfix article detection

Version 2.0 14.12.2021 HSB-14143 bugfix reference location
version value="1.9" date="20jun2020" author="nils.gregor@hsbcad.com"> HSB-8052 Added L100 and L120 
orientation improved for not horizontal and not vertical situations
option milling = "half and half" is now "both" and has a new property, to select the mill depth in male beam
bugfix, milling in male beam is a beamcut now --> BVN doesn't support a house, there

DACH:
Dieses TSL erzeugt einen Sherpa Verbinder

Befehlsaufruf mittels Werkzeugpalette:
Execute Key:    <GrößenTyp-Katalog Name> Die Trennung der beiden Teile (Größen Typ und Katalogname) muss durch genau ein beliebiges Zeichen ("-", "_", ";" o.ä.) erfolgen!  z.B. "XS-Vorgabe" 
Gesamter Befehlsstring:   ^C^C(hsb_scriptinsert "Sherpa" "XS-Vorgabe")


EN:
This TSL creates Sherpa connectors between two beams.

To call the command in the tool palette:
Execute Key:    <sizetype-catalog name> e.g. "XS-Vorgabe"
Complete command:   ^C^C(hsb_scriptinsert "Sherpa" "XS-Vorgabe")




#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 3
#KeyWords connector; sherpa; beam
#BeginContents
/// <summary Lang=en>
/// this TSL creates Sherpa connectors between two beams.
/// </summary>

/// <insert Lang=en>
/// At least two non parallel beams are required. Multiple selection of male and female beams is possible.
/// </insert>

/// <remark Lang=en>
/// TSL can be called in different ways:
/// If it's called without execute key <^C^C(hsb_scriptinsert "Sherpa")> a 2 step dialog appears. First you set the family (type) of the connector, then you can set all other properties.
///
/// If it's called with an execute key <^C^C(hsb_scriptinsert "Sherpa" "XS-Vorgabe")> no Dialog appears. The settings are taken from the called catalog entry.
/// The execute key consists of two parts, which MUST be separated by ONE character like "-", " ", "_" "?". The first Part specifies the family, the second part is the catalog entry.
/// If the given catalog entry doesn't exist, only the second dialog is shown, since the family is preset by the first part of the execute key.
/// 
/// There is a context command to create catalog entries directly from the inserted instance.
///
///
/// To avoid too much information, all warnings in the command line appear only once. If you activate debug mode you can disable this functionality.
/// </remark>
// #Versions
// 2.3 08/09/2025 HSB-24486: Fix vx0,vy0,vz0 for the case with panels , Author Marsel Nakuci
// 2.2 03.09.2025 HSB-24485: Add support for panels , Author: Marsel Nakuci
// 2.1 18.12.2023 HSB-20935 bugfix article detection , Author Thorsten Huck
// 2.0 14.12.2021 HSB-14143 bugfix reference location , Author Thorsten Huck
/// <version value="1.9" date="20jun2020" author="nils.gregor@hsbcad.com"> HSB-8052 Added L100 and L120 </version>
/// <version value="1.8" date="17apr2018" author="thorsten.huck@hsbcad.com"> translation issue fixed </version>
/// <version value="1.7" date="22feb17" author="florian.wuermseer@hsbcad.com"> orientation improved for not horizontal and not vertical situations</version>
/// <version value="1.6" date="15jun16" author="florian.wuermseer@hsbcad.com"> option milling = "half and half" is now "both" and has a new property, to select the mill depth in male beam</version>
/// <version value="1.5" date="31may16" author="florian.wuermseer@hsbcad.com"> bugfix, milling in male beam is a beamcut now --> BVN doesn't support a house, there</version>
/// <version value="1.4" date="12august15" author="florian.wuermseer@hsbcad.com"> bugfix, error messages appeared several times in certain situation</version>
/// <version value="1.3" date="12august15" author="florian.wuermseer@hsbcad.com"> bugfix, hardware comps weren't added</version>
/// <version value="1.2" date="11august15" author="florian.wuermseer@hsbcad.com"> connector size doesn't change if beams are moved</version>
/// <version value="1.1" date="31july15" author="florian.wuermseer@hsbcad.com"> catalog based insertion improved, shadow gap available as a property, some minor bugfixes</version>
/// <version value="1.0" date="21july15" author="florian.wuermseer@hsbcad.com"> initial version</version>


// basics and props
	U(1,"mm");
	double dEps=U(.1);
	int bDebug = _bOnDebug;		// Wenn Benutzer auf Kontrolle = An schaltet
	int nDoubleIndex, nStringIndex, nIntIndex;
		
	String sLastEntry = T("|_LastInserted|");
	String sDoubleClick= "TslDoubleClick";
	
	String sCatGeometry = T("|Geometry|");
	String sCatDisplay = T("|Display|");
	
// ----------------------------------------------------------------------------------------------	
// minimum distances around the connector
	double dMDH = U(15);		// MDH = MinDistHeight
	double dMDW = U(10);		// MDW = MinDistWidth

// minimum distances around the connector for angled connections	
	double dLimit1X = U(10);
	double dLimit1Y = U(15);
	double dLimit2 = U(10);

// Sherpa connector's properties
	// Typ XS
	String sXS_Articles[] = {"XS 5", "XS 10", "XS 15", "XS 20"};
	double dXS_WidthMain = U(50);
	double dXS_WidthSec = U(50);
	double dXS_HeightMains[] = {U(80), U(100), U(120), U(140)};
	double dXS_HeightSecs[] = {U(80), U(100), U(120), U(140)};
	int nXS_NumScrewMains[] = {6, 8, 9, 11};
	int nXS_NumScrewSecs[] = {6, 10, 12, 14};
	int nXS_NumScrewSums[] = {12, 18, 21, 25};
	double dXS_ScrewLengths[] = {U(50)};
	double dXS_ScrewDiam = U(4.5);
	double dXS_ConHeights[] = {U(50), U(70), U(90), U(110)};
	double dXS_ConWidth = U(30);
	double dXS_ConThick = U(12);
	double dXS_ShadowGap = U(1);
	double dXS_ScrewCaseX = U(4.5);
	double dXS_ScrewCaseY = U(7.5);
	double dXS_GroundPlateThickness = U(4);

	// Typ S
	String sS_Articles[] = {"S 5", "S 10", "S 15", "S 20"};
	double dS_WidthMain = U(50);
	double dS_WidthSec = U(50);
	double dS_HeightMains[] = {U(80), U(100), U(120), U(140)};
	double dS_HeightSecs[] = {U(80), U(100), U(120), U(140)};
	int nS_NumScrewMains[] = {6, 8, 9, 11};
	int nS_NumScrewSecs[] = {6, 10, 12, 14};
	int nS_NumScrewSums[] = {12, 18, 21, 25};
	double dS_ScrewLengths[] = {U(50)};	
	double dS_ScrewDiam = U(4.5);
	double dS_ConHeights[] = {U(50), U(70), U(90), U(110)};
	double dS_ConWidth = U(40);
	double dS_ConThick = U(12);
	double dS_ShadowGap = U(1);
	double dS_ScrewCaseX = U(6.5);
	double dS_ScrewCaseY = U(7.5);
	double dS_GroundPlateThickness = U(4);

	// Typ M
	String sM_Articles[] = {"M 15", "M 20", "M 25", "M 30", "M 40"};
	double dM_WidthMain = U(65);
	double dM_WidthSec = U(80);
	double dM_HeightMains[] = {U(120), U(140), U(160), U(180), U(200)};
	double dM_HeightSecs[] = {U(120), U(140), U(160), U(180), U(200)};
	int nM_NumScrewMains[] = {7, 9, 10, 11, 13};
	int nM_NumScrewSecs[] = {9, 11, 13, 15, 17};
	int nM_NumScrewSums[] = {16, 20, 23, 26, 30};
	double dM_ScrewLengths[] = {U(65)};	
	double dM_ScrewDiam = U(6.5);
	double dM_ConHeights[] = {U(90), U(110), U(130), U(150), U(170)};
	double dM_ConWidth = U(60);
	double dM_ConThick = U(14);
	double dM_ShadowGap = U(1);
	double dM_ScrewCaseX = U(9.5);
	double dM_ScrewCaseY = U(10);
	double dM_GroundPlateThickness = U(4);
		
	// Typ L
	String sL_Articles[] = {"L 30", "L 40", "L 50", "L 60", "L 80", "L100", "L120"};
	double dL_WidthMain = U(100);
	double dL_WidthSec = U(100);
	double dL_HeightMains[] = {U(180), U(200), U(240), U(280), U(320),U(360), U(400)};
	double dL_HeightSecs[] = {U(180), U(200), U(240), U(280), U(320), U(360), U(400)};
	int nL_NumScrewMains[] = {6, 7, 8, 10, 12, 14, 16};
	int nL_NumScrewSecs[] = {9, 11, 13, 15, 17, 19, 21};
	int nL_NumScrewSums[] = {15, 18, 21, 25, 29, 33, 37};
	double dL_ScrewLengths[] = {U(100)};	
	double dL_ScrewDiam = U(8);
	double dL_ConHeights[] = {U(150), U(170), U(210), U(250), U(290), U(330), U(370)};
	double dL_ConWidth = U(80);
	double dL_ConThick = U(18);
	double dL_ShadowGap = U(3);
	double dL_ScrewCaseX = U(14);
	double dL_ScrewCaseY = U(15);
	double dL_GroundPlateThickness = U(4);

	// Typ XL (Screw lengths 120, 140, 160, 180 and WidthMain are corresponding)
	String sXL_Articles[] = {"XL 55", "XL 70", "XL 80", "XL 100", "XL 120", "XL 140", "XL 170", "XL 190", "XL 250"};
	double dXL_WidthMain = U(120);
	double dXL_WidthSec = U(140);
	double dXL_HeightMains[] = {U(280), U(320), U(360), U(400), U(440), U(480), U(520), U(560), U(640)};
	double dXL_HeightSecs[] = {U(280), U(320), U(360), U(400), U(440), U(480), U(520), U(560), U(640)};
	int nXL_NumScrewMains[] = {8, 9, 10, 11, 13, 14, 16, 18, 22};
	int nXL_NumScrewSecs[] = {10, 12, 14, 14, 16, 18, 20, 22, 26};
	int nXL_NumScrewSums[] = {18, 21, 24, 25, 29, 32, 36, 40, 48};
	double dXL_ScrewLengths[] = {U(120), U(140), U(160), U(180)};		
	double dXL_ScrewDiam = U(8);
	double dXL_ConHeights[] = {U(250), U(290), U(330), U(370), U(410), U(450), U(490), U(530), U(610)};
	double dXL_ConWidth = U(120);
	double dXL_ConThick = U(20);
	double dXL_ShadowGap = U(3);
	double dXL_ScrewCaseX = U(14);
	double dXL_ScrewCaseY = U(25);
	double dXL_GroundPlateThickness = U(4);
		
	// Typ XXL (Screw lengths 120, 140, 160, 180 and WidthMain are corresponding)
	String sXXL_Articles[] = {"XXL 170", "XXL 190", "XXL 220", "XXL 250", "XXL 280", "XXL 300"};
	double dXXL_WidthMain = U(120);
	double dXXL_WidthSec = U(160);
	double dXXL_HeightMains[] = {U(440), U(480), U(520), U(560), U(600), U(640)};
	double dXXL_HeightSecs[] = {U(440), U(480), U(520), U(560), U(600), U(640)};
	int nXXL_NumScrewMains[] = {16, 18, 20, 22, 24, 26};
	int nXXL_NumScrewSecs[] = {21, 24, 27, 30, 30, 33};
	int nXXL_NumScrewSums[] = {37, 42, 47, 52, 54, 59};
	double dXXL_ScrewLengths[] = {U(120), U(140), U(160), U(180)};		
	double dXXL_ScrewDiam = U(8);
	double dXXL_ConHeights[] = {U(410), U(450), U(490), U(530), U(570), U(610)};
	double dXXL_ConWidth = U(140);
	double dXXL_ConThick = U(20);
	double dXXL_ShadowGap = U(3);
	double dXXL_ScrewCaseX = U(14);
	double dXXL_ScrewCaseY = U(-5);
	double dXXL_GroundPlateThickness = U(4);
	
// ----------------------------------------------------------------------------------------------	

	String sArticles[0];
	double dWidthMain;
	double dWidthSec;
	double dHeightMains[0];
	double dHeightSecs[0];
	int nNumScrewMains[0];
	int nNumScrewSecs[0];
	int nNumScrewSums[0];
	double dScrewLengths[0];
	double dScrewDiam;
	double dConHeights[0];
	double dConWidth;
	double dConThick;
	double dShadowGapPreset;
	double dScrewCaseX;
	double dScrewCaseY;
	double dGroundPlateThickness;
	String sArticlesError[0];
	
// properties
// categories
	String sCategoryType = T("|Type|");
	String sCategoryTool = T("|Tooling|");
	String sCategoryPosition = T("|Position|");
	
// properties	
	String sInsertMode[] = {T("|beam to beam|"), T("|beam to concrete|")};
	String sInsertModeName = T("|Connection type|");
	String sFamilies[] = {"XS", "S", "M", "L", "XL", "XXL"};
	String sFamilyName = T("|Type|");
	String sMillModes[] = {T("|None|"), T("|Male beam|"), T("|Female beam|"), T("|Both|")};
	String sMillModeName = T("|Milling|");
	String sArticleName = T("|Article|");
	String sScrewLengthName = T("|Screw Length|");
	String sMillToleranceName = T("|Milling tolerance|");
	double dYOffValue = U(0);
	String sYOffName = T("|Offset Lateral|");
	double dZOffValue = U(0);
	String sZOffName = T("|Offset Vertical|");
 	String sToolShapes[] = {T("|not rounded|"), T("|round|"), T("|relief|"), T("|rounded with small diameter|"), T("|relief with small diameter|"), T("|rounded|")};
	String sToolShapeName = T("|Tool Shape|");
	int nRoundTypes[] = {_kNotRound,_kRound, _kRelief, _kRoundSmall, _kReliefSmall, _kRounded};
	String sShadowGapName = T("|Shadow Gap|");
	String sMaleMillDepthName = T("|Milling depth in male beam|");
	
	PropString sFamily (nStringIndex++, sFamilies, sFamilyName);
	sFamily.setCategory (sCategoryType);


//on insert --------------------------------------------------------------------------------------------------------------------------------------------
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }	
		
	// get execute key to preset family or model
		//reportMessage("\n_kExecuteKey is " + _kExecuteKey);
		String sKey = _kExecuteKey;
		
		//int nPos = sKey.find("-",0);
	// split execute key into family name and catalog name	
		String sOpmKey;
		String sCat;
		
		if (sKey.left(1) == "S")
		{
			sOpmKey = "S";
			sCat = sKey.right(sKey.length()-sOpmKey.length()-1);
		}		
		if (sKey.left(1) == "M")
		{
			sOpmKey = "M";
			sCat = sKey.right(sKey.length()-sOpmKey.length()-1);
		}		
		if (sKey.left(1) == "L")
		{
			sOpmKey = "L";
			sCat = sKey.right(sKey.length()-sOpmKey.length()-1);
		}
		if (sKey.left(1) == "X")
		{
			if (sKey.left(2) == "XS")
			{
				sOpmKey = "XS";
				sCat = sKey.right(sKey.length()-sOpmKey.length()-1);
			}
			if (sKey.left(2) == "XL")
			{
				sOpmKey = "XL";
				sCat = sKey.right(sKey.length()-sOpmKey.length()-1);
			}		
			if (sKey.left(2) == "XX")
			{
				sOpmKey = "XXL";
				sCat = sKey.right(sKey.length()-sOpmKey.length()-1);
			}
		}
		
		int nKeyLength = sOpmKey.length();
		String sFamilyPreset;
		if (sOpmKey.length()>0) sFamilyPreset = sOpmKey.makeUpper();
		if (sFamilies.find(sFamilyPreset)>-1)
		{		
			sFamily.set(sFamilyPreset);		
		}
		else
		{
			showDialog();
			sOpmKey = sFamily;
		}
	
	// set opm key
		setOPMKey(sOpmKey);

	
	// flag if dialog needs to be shown
		String sCatalogNames[] = _ThisInst.getListOfCatalogNames(scriptName() + "-" + sOpmKey);
		
		int bShowDialog = 1;
		int nCatPos = sCatalogNames.find(sCat);
		
		if (nCatPos>-1)
		{
			if(sCat.length() == sCatalogNames[nCatPos].length())
			{
				bShowDialog = 0;	
			}
		}
	
		if (_bOnDebug)
		{
			reportMessage(nCatPos);
			reportMessage ("\n" + "Catalog Names = " + sCatalogNames);
			reportMessage ("\n" + "FamilyName = " + sOpmKey + " - CatalogName = " + sCat + " - Show Dialog: " + bShowDialog);	
		}
			
	// define some properties from family name
		int nFamily = sFamilies.find (sFamily,0);
		if (nFamily == 0)
		{
			dScrewLengths = dXS_ScrewLengths;
			sArticles = sXS_Articles;
			dShadowGapPreset = dXS_ShadowGap;
		}
		else if (nFamily == 1)
		{
			dScrewLengths = dS_ScrewLengths;
			sArticles = sS_Articles;
			dShadowGapPreset = dS_ShadowGap;
		}
		else if (nFamily == 2)
		{
			dScrewLengths = dM_ScrewLengths;
			sArticles = sM_Articles;
			dShadowGapPreset = dM_ShadowGap;
		}
		else if (nFamily == 3)
		{
			dScrewLengths = dL_ScrewLengths;
			sArticles = sL_Articles;
			dShadowGapPreset = dL_ShadowGap;
		}
		else if (nFamily == 4)
		{
			dScrewLengths = dXL_ScrewLengths;
			sArticles = sXL_Articles;
			dShadowGapPreset = dXL_ShadowGap;
		}
		else if (nFamily == 5)
		{
			dScrewLengths = dXXL_ScrewLengths;
			sArticles = sXXL_Articles;
			dShadowGapPreset = dXXL_ShadowGap;
		}
		
		PropDouble dScrewLength (nDoubleIndex++, dScrewLengths, sScrewLengthName);
		dScrewLength.setCategory (sCategoryType);
		dScrewLength.setDescription(T("|Screw length|"));	
			
		PropString sMillMode (nStringIndex++, sMillModes, sMillModeName);	
		sMillMode.setCategory (sCategoryTool);	
		sMillMode.setDescription(T("|Defines, which beam gets the housing|"));	
					
		PropDouble dMillTolerance (nDoubleIndex++, U(1), sMillToleranceName);
		dMillTolerance.setCategory (sCategoryTool);
		dMillTolerance.setDescription(T("|Extra width for housing (mm)|"));
				
		PropDouble dShadowGap (nDoubleIndex++, dShadowGapPreset, sShadowGapName);
		dShadowGap.setCategory (sCategoryTool);
		dShadowGap.setDescription(T("|Width of the shadow gap, if connector is milled into one beam (mm)|"));
		
		PropString sToolShape (nStringIndex++, sToolShapes, sToolShapeName);
		sToolShape.setCategory (sCategoryTool);
		sToolShape.setDescription(T("|Defines the rounding type of the tool.|") + " (" + T("|Due to machine restrictions, male beam milling is always <not rounded>|") + ")");
		
		PropDouble dYOff (nDoubleIndex++, dYOffValue, sYOffName);
		dYOff.setCategory (sCategoryPosition);
		dYOff.setDescription(T("|Defines the lateral offset of the connector. (mm)|"));	
		
		PropDouble dZOff (nDoubleIndex++, dYOffValue, sZOffName);
		dZOff.setCategory (sCategoryPosition);
		dZOff.setDescription(T("|Defines the vertical offset of the connector. (mm)|"));
		
		PropString sArticle	(nStringIndex++, sArticles, sArticleName);
		int nArticle = sArticles.find (sArticle,0);
		sArticle.setCategory (sCategoryType);
		
		PropDouble dMaleMillDepth (nDoubleIndex++, U(4), sMaleMillDepthName);
		dMaleMillDepth.setCategory (sCategoryTool);
		dMaleMillDepth.setDescription(T("|Defines the depth of the housing in the male beam|") + " - (4mm " + T("|is the thickness of the ground plate of the connector|") + ")");	
		
		if (bShowDialog)
		{
			sFamily.setReadOnly(true);
			if (dScrewLengths.length() == 1) 
			{
				dScrewLength.setReadOnly(true);
			}
			showDialog();
		}
		else
		{
			//reportMessage ("\nopmKey: "+ sOpmKey +" inst name:" +  _ThisInst.opmName() + " has entries:" + TslInst().getListOfCatalogNames(scriptName() + "-" + sOpmKey));
			setPropValuesFromCatalog(sCat);
			//reportMessage("\n Eigenschaften: " + "Screw Length " + dScrewLength
			 //+ "\nMill Tol: " + dMillTolerance
			 //+ "\nYoff: " + dYOff
			 //+ "\nZoff: " + dZOff
			 //+ "\nFamily: " + sFamily
			 //+ "\nMill Mode: " + sMillMode
			 //+ "\nTool Shape: " + sToolShape
			 //+ "\nArticle: " + sArticle);
		}


	//int nCat = setPropValuesFromCatalog(T("|_Default|"));
	//reportMessage ("Katalog? " + nCat);
		
	// separate selection
		Entity entMales[0], entFemales[0], ents[0];
		PrEntity ssMale(T("|Select male beam(s)|"), Beam());
		
		if (ssMale.go())
			entMales= ssMale.set();

		PrEntity ssFemale(T("|Select female beam(s) or SIP(s)|"), Beam());
		ssFemale.addAllowedClass(Sip());
		if (ssFemale.go())
		{
		// avoid females to be added to males again
			ents = ssFemale.set();
			for (int i=0;i<ents.length();i++)
				if(entMales.find(ents[i])<0 && entFemales.find(ents[i])<0)
				{
					entFemales.append(ents[i]);
				}		
		}		
		
	// declare the tsl props
		TslInst tslNew;
		Vector3d vUcsX = _XW;
		Vector3d vUcsY = _YW;
		GenBeam gbAr[2];
		Entity entAr[0];
		Point3d ptAr[0];
		int nArProps[0];
		double dArProps[] = {dScrewLength, dMillTolerance, dShadowGap, dYOff, dZOff, dMaleMillDepth};
		String sArProps[] = {sFamily, sMillMode, sToolShape, sArticle};
		Map mapTsl;	
	

	// loop males
		for (int i=0;i<entMales.length();i++)
		{
			Beam bmMale = (Beam)entMales[i];
			if (!bmMale.bIsValid())continue;
			gbAr[0] =bmMale;
			Vector3d vxMale = bmMale.vecX();	
		
			// loop females
				for (int j=0;j<entFemales.length();j++)
				{
					Beam bmFemale = (Beam) entFemales[j];
					// HSB-24485
					Sip sipFemale = (Sip) entFemales[j];
					if(bmFemale.bIsValid())
					{ 
						// beam
						Vector3d vxFemale = bmFemale.vecX();
						if (vxMale.isParallelTo(vxFemale))continue;
						
						LineBeamIntersect lbi(bmMale.ptCen(), vxMale, bmFemale);
						
						Point3d ptI = lbi.pt1();
						Point3d ptImin = bmFemale.ptCen();
						Point3d ptImax = bmFemale.ptCen();
						ptImin.transformBy(-vxFemale * bmFemale.solidLength() * .5);
						ptImax.transformBy(vxFemale * bmFemale.solidLength() * .5);
						double dInt = vxFemale.dotProduct(ptI-bmFemale.ptCen());
						double dIntMin = vxFemale.dotProduct(ptImin - bmFemale.ptCen());
						double dIntMax = vxFemale.dotProduct(ptImax - bmFemale.ptCen());
						
						//reportMessage ("\n" + "Intersection? " + lbi.bHasContact());
						//reportMessage ("\n" + "Minimum: " + dIntMin + " Wert: " + dInt + " Maximum: " + dIntMax);
						
						if (dInt <= dIntMin || dInt >= dIntMax)continue;
						if (!lbi.bHasContact())continue;
						
						
						gbAr[1] = bmFemale;
					}
					else if(sipFemale.bIsValid())
					{ 
						// HSB-24485 sip
						Vector3d vzFemale=sipFemale.vecZ();
						if(vzFemale.isPerpendicularTo(vxMale))continue;
						
						PlaneProfile ppSip(sipFemale.plEnvelope());
						Line lnMale(bmMale.ptCen(),vxMale);
						Plane pnSip(sipFemale.ptCen(),vzFemale);
						Point3d ptIntersect;
						int bIntersect=lnMale.hasIntersection(pnSip,ptIntersect);
						
						if(!bIntersect)continue;
						
						if(ppSip.pointInProfile(ptIntersect)!=_kPointInProfile)
						{ 
							continue;
						}
						
						gbAr[1] = sipFemale;
						// find _Pt0 for this tsl
					}
					// create new instance	
					tslNew.dbCreate(scriptName(), vUcsX, vUcsY, gbAr, entAr, 
						ptAr, nArProps, dArProps, sArProps, _kModelSpace, mapTsl); // create new instance	
				} // next j
		}	// next i
		
		eraseInstance();
		return;
	} 
// end on insert --------------------------------------------------------------------------------------------------------------------------------------------


	
//region Find family Index
	int nFamily = sFamilies.find (sFamily,0);	
	if (nFamily == 0)
	{
		sArticles = sXS_Articles;
		dWidthMain = dXS_WidthMain;
		dHeightMains = dXS_HeightMains;
		dWidthSec = dXS_WidthSec;
		dHeightSecs = dXS_HeightSecs;
		nNumScrewMains = nXS_NumScrewMains;
		nNumScrewSecs = nXS_NumScrewSecs;
		nNumScrewSums = nXS_NumScrewSums;
		dScrewDiam = dXS_ScrewDiam;
		dScrewLengths = dXS_ScrewLengths;
		dConHeights = dXS_ConHeights;
		dConWidth = dXS_ConWidth;
		dConThick = dXS_ConThick;
		dShadowGapPreset = dXS_ShadowGap;
		dScrewCaseX = dXS_ScrewCaseX;
		dScrewCaseY = dXS_ScrewCaseY;
		dGroundPlateThickness = dXS_GroundPlateThickness;
	}
	else if (nFamily == 1)
	{
		sArticles = sS_Articles;
		dWidthMain = dS_WidthMain;
		dHeightMains = dS_HeightMains;
		dWidthSec = dS_WidthSec;
		dHeightSecs = dS_HeightSecs;
		nNumScrewMains = nS_NumScrewMains;
		nNumScrewSecs = nS_NumScrewSecs;
		nNumScrewSums = nS_NumScrewSums;
		dScrewDiam = dS_ScrewDiam;
		dScrewLengths = dS_ScrewLengths;
		dConHeights = dS_ConHeights;
		dConWidth = dS_ConWidth;
		dConThick = dS_ConThick;
		dShadowGapPreset = dS_ShadowGap;
		dScrewCaseX = dS_ScrewCaseX;
		dScrewCaseY = dS_ScrewCaseY;
		dGroundPlateThickness = dS_GroundPlateThickness;
	}
	else if (nFamily == 2)
	{
		sArticles = sM_Articles;
		dWidthMain = dM_WidthMain;
		dHeightMains = dM_HeightMains;
		dWidthSec = dM_WidthSec;
		dHeightSecs = dM_HeightSecs;
		nNumScrewMains = nM_NumScrewMains;
		nNumScrewSecs = nM_NumScrewSecs;
		nNumScrewSums = nM_NumScrewSums;
		dScrewDiam = dM_ScrewDiam;
		dScrewLengths = dM_ScrewLengths;
		dConHeights = dM_ConHeights;
		dConWidth = dM_ConWidth;
		dConThick = dM_ConThick;
		dShadowGapPreset = dM_ShadowGap;
		dScrewCaseX = dM_ScrewCaseX;
		dScrewCaseY = dM_ScrewCaseY;
		dGroundPlateThickness = dM_GroundPlateThickness;
	}
	else if (nFamily == 3)
	{
		sArticles = sL_Articles;
		dWidthMain = dL_WidthMain;
		dHeightMains = dL_HeightMains;
		dWidthSec = dL_WidthSec;
		dHeightSecs = dL_HeightSecs;
		nNumScrewMains = nL_NumScrewMains;
		nNumScrewSecs = nL_NumScrewSecs;
		nNumScrewSums = nL_NumScrewSums;
		dScrewDiam = dL_ScrewDiam;
		dScrewLengths = dL_ScrewLengths;
		dConHeights = dL_ConHeights;
		dConWidth = dL_ConWidth;
		dConThick = dL_ConThick;
		dShadowGapPreset = dL_ShadowGap;
		dScrewCaseX = dL_ScrewCaseX;
		dScrewCaseY = dL_ScrewCaseY;
		dGroundPlateThickness = dL_GroundPlateThickness;

	}
	else if (nFamily == 4)
	{
		sArticles = sXL_Articles;
		dWidthMain = dXL_WidthMain;
		dHeightMains = dXL_HeightMains;
		dWidthSec = dXL_WidthSec;
		dHeightSecs = dXL_HeightSecs;
		nNumScrewMains = nXL_NumScrewMains;
		nNumScrewSecs = nXL_NumScrewSecs;
		nNumScrewSums = nXL_NumScrewSums;
		dScrewLengths = dXL_ScrewLengths;
		dScrewDiam = dXL_ScrewDiam;
		dConHeights = dXL_ConHeights;
		dConWidth = dXL_ConWidth;
		dConThick = dXL_ConThick;
		dShadowGapPreset = dXL_ShadowGap;
		dScrewCaseX = dXL_ScrewCaseX;
		dScrewCaseY = dXL_ScrewCaseY;
		dGroundPlateThickness = dXL_GroundPlateThickness;

	}
	else if (nFamily == 5)
	{
		sArticles = sXXL_Articles;
		dWidthMain = dXXL_WidthMain;
		dHeightMains = dXXL_HeightMains;
		dWidthSec = dXXL_WidthSec;
		dHeightSecs = dXXL_HeightSecs;
		nNumScrewMains = nXXL_NumScrewMains;
		nNumScrewSecs = nXXL_NumScrewSecs;
		nNumScrewSums = nXXL_NumScrewSums;
		dScrewDiam = dXXL_ScrewDiam;
		dScrewLengths = dXXL_ScrewLengths;
		dConHeights = dXXL_ConHeights;
		dConWidth = dXXL_ConWidth;
		dConThick = dXXL_ConThick;
		dShadowGapPreset = dXXL_ShadowGap;
		dScrewCaseX = dXXL_ScrewCaseX;
		dScrewCaseY = dXXL_ScrewCaseY;
		dGroundPlateThickness = dXXL_GroundPlateThickness;

	}
	else
	{
		reportMessage("\n" + scriptName() + ": " +T("|This shouldn't happen - please contact your local dealer|"));
		
	}
	
// set opm key
		setOPMKey(sFamily);		
//endregion 	


//region Define beams and points
	Beam bm0 = _Beam[0];
	Beam bm1;
	Sip sip1;
	if(_Beam.length()==2)
	{
		bm1= _Beam[1];
	}
	if(_Sip.length()==1)
	{ 
		sip1=_Sip[0];
	}
	if(!bm1.bIsValid() && !sip1.bIsValid())
	{ 
		// HSB-24485
		reportMessage("\n" + scriptName() + ": " +T("|One beam or SIP needed as female beam/sip|"));
		eraseInstance();
		return;
	}
	
	Vector3d vecX0 = _X0;
	Vector3d vecY0 = _Y0;
	Vector3d vecZ0 = _Z0;
	
	Vector3d vecPlane = vecX0.crossProduct(_Y1).crossProduct(-_Y1);
	vecPlane.vis(_Pt0, 30);
	
	Vector3d vecZ1 = _Z1;
	Vector3d vecX1 = vecY0.crossProduct(_Z1).crossProduct(-_Z1);
	
	if (vecZ0.dotProduct(vecX1.crossProduct(vecZ1)) < 0)
		vecX1 = -vecY0.crossProduct(_Z1).crossProduct(-_Z1);
	
	Vector3d vecY1 = vecX1.crossProduct(vecZ1);
	
	double dH0=_H0;
	double dW0=_W0;
	double dW1=_W1;
	double dH1=_H1;
	
	// HSB-24485
	Vector3d vxSip,vySip,vzSip;
	Quader qdSip;
	Plane pnSip0,pnSip1;
	Line lnBm0(bm0.ptCen(),bm0.vecX());
	Point3d ptSipIntersect;
	// plane of intersection between lnBm0 and plane of sip
	Plane pnSipIntersect;
	// 
	Plane pnContact=_Plf;
	if(sip1.bIsValid())
	{ 
		// HSB-24485
		vxSip=sip1.vecX();
		vySip=sip1.vecY();
		vzSip=sip1.vecZ();
		// calculate _X0,_Y0,_Z0
		// _X1,_Y1,_Z1
		qdSip=Quader(sip1.ptCen(),sip1.vecX(),sip1.vecY(),sip1.vecZ(),
			sip1.dL(),sip1.dW(),sip1.dH());
		
		pnSip0=Plane(sip1.ptCen()-.5*vzSip*sip1.dH(),vzSip);
		pnSip1=Plane(sip1.ptCen()+.5*vzSip*sip1.dH(),vzSip);
		
		Point3d ptIntersect0, ptIntersect1;
		int bIntersect0=lnBm0.hasIntersection(pnSip0,ptIntersect0);
		int bIntersect1=lnBm0.hasIntersection(pnSip1,ptIntersect1);
		
		if(!bIntersect0 || !bIntersect1)
		{ 
			reportMessage("\n" + scriptName() + ": " +T("|Unexpected|"));
			eraseInstance();
			return;
		}
		
		ptSipIntersect=ptIntersect0;
		pnSipIntersect=pnSip0;
		if((ptIntersect1-bm0.ptCen()).length()<(ptIntersect0-bm0.ptCen()).length())
		{ 
			ptSipIntersect=ptIntersect1;
			pnSipIntersect=pnSip1;
		}
		pnContact=pnSipIntersect;
		ptSipIntersect.vis(3);
		Vector3d vBmSip=ptSipIntersect-bm0.ptCen();vBmSip.normalize();
		_Pt0=ptSipIntersect;
		// HSB-24486
		vecX0=bm0.vecX();
		if(vecX0.dotProduct(vBmSip)<0)vecX0*=-1;
		vecZ0=bm0.vecD(_ZW);
		vecY0=vecZ0.crossProduct(vecX0);vecY0.normalize();

		vecZ1=qdSip.vecD(vecX0);
		vecY1=qdSip.vecD(vecZ0);
		vecX1=-vecY1.crossProduct(vecZ1);
		
		dH0=bm0.dD(vecZ0);
		dW0=bm0.dD(vecY0);
		dH1=qdSip.dD(vecZ1);
		dW1=qdSip.dD(vecY1);
		
//		vecX0.vis(_Pt0 + vecX0* U(-150), 30);
//		vecY0.vis(_Pt0 + vecX0* U(-150), 4);
//		vecZ0.vis(_Pt0 + vecX0* U(-150), 5);
		
//		vecX1.vis(_Pt0, 1);
//		vecY1.vis(_Pt0, 3);
//		vecZ1.vis(_Pt0, 150);
	}
	
	
//	Vector3d vecY1 = vecZ0.crossProduct(_Z1).crossProduct(-_Z1);	
//	
//	vecY1 = vecX1.crossProduct(vecZ1);

	vecX1.normalize();
	vecY1.normalize();
	vecZ1.normalize();
		
//	int bIsStud = _XF1.isParallelTo(_ZW);

// standard case (female is no stud)
//	Vector3d vecX1 = _X1;
//	Vector3d vecY1 = _Y1;
//	Vector3d vecZ1 = _Z1;

//	if (bIsStud)
//		{
//		// case female is stud
//			vecX1 = _ZW.crossProduct(-_Z1);
//			vecY1 = _ZW;
//			vecZ1 = _Z1;
//		}


	vecX0.vis(_Pt0 + vecX0* U(-150), 30);
	vecY0.vis(_Pt0 + vecX0* U(-150), 4);
	vecZ0.vis(_Pt0 + vecX0* U(-150), 5);

	vecX1.vis(_Pt0, 1);
	vecY1.vis(_Pt0, 3);
	vecZ1.vis(_Pt0, 150);
	

// compare mapped beam sizes

	int bBeamSizeChange = 0;
	
	if (!_bOnDbCreated)
	{
		double dH0prev = _Map.getDouble("H0");
		double dW0prev = _Map.getDouble("W0");
		double dH1prev = _Map.getDouble("H1");
		double dW1prev = _Map.getDouble("W1");
		
		if (dH0prev != dH0 || dW0prev != dW0 || dH1prev != dH1 || dW1prev != dW1)
			bBeamSizeChange = 1;
	}
	//reportMessage ("Size change " + bBeamSizeChange);
	//reportMessage ("Beam 0" + dH0prev + dW0prev + "    Beam 1 " + dH1prev + dW1prev);		
//endregion 


//region Properties
// declare additional properties	
	PropDouble dScrewLength (nDoubleIndex++, dScrewLengths, sScrewLengthName);
	dScrewLength.setCategory (sCategoryType);	
	dScrewLength.setDescription(T("|Screw length|"));	
	
	PropString sMillMode (nStringIndex++, sMillModes, sMillModeName);	
	sMillMode.setCategory (sCategoryTool);
	sMillMode.setDescription(T("|Defines, which beam gets the housing|"));	

	PropDouble dMillTolerance (nDoubleIndex++, U(1), sMillToleranceName);
	dMillTolerance.setCategory (sCategoryTool);
	dMillTolerance.setDescription(T("|Extra width for housing (mm)|"));	
	
	PropDouble dShadowGap (nDoubleIndex++, dShadowGapPreset, sShadowGapName);
	dShadowGap.setCategory (sCategoryTool);
	dShadowGap.setDescription(T("|Width of the shadow gap, if connector is milled into one beam|"));
			
	PropString sToolShape (nStringIndex++, sToolShapes, sToolShapeName);
	sToolShape.setCategory (sCategoryTool);	
 	sToolShape.setDescription(T("|Defines the rounding type of the tool.|") + " (" + T("|Due to machine restrictions, male beam milling is always <not rounded>|") + ")");

	
	PropDouble dYOff (nDoubleIndex++, dYOffValue, sYOffName);
	dYOff.setCategory (sCategoryPosition);	
	dYOff.setDescription(T("|Defines the lateral offset of the connector.|"));
		
	PropDouble dZOff (nDoubleIndex++, dYOffValue, sZOffName);
	dZOff.setCategory (sCategoryPosition);
	dZOff.setDescription(T("|Defines the vertical offset of the connector.|"));
	
	PropDouble dMaleMillDepth (nDoubleIndex++, U(4), sMaleMillDepthName);
	dMaleMillDepth.setCategory (sCategoryTool);
	dMaleMillDepth.setDescription(T("|Defines the depth of the housing in the male beam|") + " - (4mm " + T("|is the thickness of the ground plate of the connector|") + ")");	

// define additional properties
	PropString sArticle	(3, sArticles, sArticleName);// HSB-20935 property was declared multiple times inside if statements
	sArticle.setCategory (sCategoryType);



	if (dScrewLengths.length() == 1) 
	{
		dScrewLength.setReadOnly(true);
	}		
//endregion 		

//region Display
	_ThisInst.setHyperlink("http://en.sherpa-connector.com/");
	int nColor = _ThisInst.color();// standard color is 252, but can be changed by the instance color after insertion 
	if (_bOnDbCreated)
	{
		_ThisInst.setColor(252);
	}
	
	Display dpErr(1);
	dpErr.textHeight(20);
	
	Display dpModel(nColor);
	dpModel.addHideDirection(_ZW);
	
	
	Display dpPlan(nColor);
	dpPlan.addViewDirection(_ZW);
	dpPlan.textHeight (U(10));		
//endregion 
	

// find chosen milling options	
	int nMillMode = sMillModes.find(sMillMode);
	int nToolShape = sToolShapes.find(sToolShape);
	int nRoundType = nRoundTypes[nToolShape];

	
// get required gap between the beams
// 0 = none, 1 = male beam, 2 = female, 3 = both

	if (dShadowGap > dConThick)
	{
		reportMessage("\n" + scriptName() + ": " +T("|Shadow Gap|") + " " + T("|out of range|") + " --> " + T("|corrected to|") + " " + dConThick);
		dShadowGap.set(dConThick);
	}	
	

	double dCutGap = dShadowGap;
	
	if (nMillMode == 0)
	{
		dCutGap = dConThick;
	}

// if milled in both beams, MaleMillDepth can't be bigger than the Connector Thickness - Shadow Gap
	if (dMaleMillDepth > dConThick - dShadowGap)
	{
		if (nMillMode == 3)
			reportMessage("\n" + scriptName() + ": " +T("|Mill depth in male beam|") + " " + T("|out of range|") + " --> " + T("|corrected to|") + " " + (dConThick - dShadowGap));
			
			
		dMaleMillDepth.set(dConThick - dShadowGap);
	}	

// cut to stretch male to female
	Point3d ptCut = _Pt0;
	ptCut.transformBy (-vecZ1 * dCutGap);
	
	Cut ct0 (ptCut, vecZ1);
	bm0.addTool (ct0, bDebug?0:_kStretchOnToolChange);


// trigger to set catalog entry from current properties
	String sTriggerSetCatalog = T("|Set catalog entry|");
	addRecalcTrigger(_kContext, sTriggerSetCatalog);

// --------------------------------------------------------------------------------------------------------------------------------
// until here execute twice to confirm the cut before determining the contact area
// ATTENTION this means from here the TSL is quasi always on second loop and _kNameLastChangedProp, kExecuteKey aren't available there

	if (_kExecutionLoopCount == 0 && _kExecuteKey != sTriggerSetCatalog)
		{
			setExecutionLoops(2);
			return;
		}
	
// define bodies for connection area
	Body bd0 = bm0.realBody();
	Body bd1 = bm1.realBody();
	if(sip1.bIsValid())
	{ 
		bd1=sip1.realBody();
	}
	
	
// get connection area
	Plane pnBm0 (ptCut, vecZ1);

	PlaneProfile ppFront = bd0.extractContactFaceInPlane (pnBm0, dEps);
	ppFront.vis (6);
	_Plf.vis(2);
	PlaneProfile ppSide = bd1.shadowProfile (pnContact);
	ppSide.vis (5);

	PlaneProfile ppContact = ppFront;
	ppContact.intersectWith (ppSide);
	
	ppContact.vis (2);	
	
// get dimension of contact area
	LineSeg segContact = ppContact.extentInDir (vecX1); // HSB-14143 vecX1 instead of _X1
	
	double dX = abs((vecX1.dotProduct (segContact.ptStart() - segContact.ptEnd())));
	double dY = abs((vecY1.dotProduct (segContact.ptStart() - segContact.ptEnd())));
	
// center point of contact area

	Point3d ptRef = segContact.ptMid();
	
	//Point3d ptRef = _L0.intersect(pnBm0,0);
	ptRef.transformBy(-vecX1 * dYOff + vecY1 * dZOff);
	ptRef.vis(1);	
	

// ----------------------------------------------------------------------------------------------	
// check the connection and the sizes

	String sError = T("|out of range|");
	String sErrorLocation = ("\n" + _ThisInst.opmName() + " " + T("|between|") + " " + bm0.name() + " (" + bm0.posnum() + ") " + T("|and|") + " " + bm1.name("name") + " (" + bm1.posnum() + ")");
	if(sip1.bIsValid())
	{ 
		sErrorLocation = ("\n" + _ThisInst.opmName() + " " + T("|between|") + " " + bm0.name() + " (" + bm0.posnum() + ") " + T("|and|") + " " + sip1.name("name") + " (" + sip1.posnum() + ")");
	}
// check connector orientation

	if (_ZW.dotProduct(vecY1) < -dEps)
	{
		int nErrDisp8 = _Map.getInt("ErrDisp8");
		if ((!nErrDisp8 && _kExecutionLoopCount == 1) || _bOnDebug)
		{
			reportMessage (sErrorLocation);
			reportMessage("\n" + scriptName() + ": " +T("|Connector|") + " " + T("|is upside down oriented|") + " --> " + T("|Please change axis orientation|"));
			
			_Map.setInt("ErrDisp8", 1);		
		}
		
		String sErrorOrientation = T("|upside down|");
		dpErr.draw (sError + " (" + sErrorOrientation + ")", ptRef, vecX1, vecY1, 0, 0, _kDeviceX);
		
		sArticle=PropString(3, sArticlesError, sArticleName);
		sArticle.setCategory (sCategoryType);
		sArticle.set(sError);
		sArticle.setReadOnly(true);
		return;
	}
	else
		_Map.setInt("ErrDisp8", 0);
	
	
	if (_ZW.dotProduct(vecY1) > -dEps && (abs(_ZW.dotProduct(vecX1)) > abs(_ZW.dotProduct(vecY1))))
	{
		int nErrDisp9 = _Map.getInt("ErrDisp9");
		if ((!nErrDisp9 && _kExecutionLoopCount == 1) || _bOnDebug)
		{
			reportMessage (sErrorLocation);
			reportMessage("\n" + scriptName() + ": " +T("|Connector|") + " " + T("|is sideward orientated|") + " --> " + T("|Please change axis orientation|"));
			
			_Map.setInt("ErrDisp9", 1);		
		}
		String sErrorOrientation = T("|orientation sideward|");
		dpErr.draw (sError + " (" + sErrorOrientation + ")", ptRef, vecX1, vecY1, 0, 0, _kDeviceX);
		
		sArticle=PropString(3, sArticlesError, sArticleName);
		sArticle.setCategory (sCategoryType);
		sArticle.set(sError);
		sArticle.setReadOnly(true);
		return;
	}
	else
		_Map.setInt("ErrDisp9", 0);
	
// check if connector family is suitable for the width of subcarrier
	//if(dWidthSec > _W0)
	if(dWidthSec > dX)
	{	
		int nErrDisp1 = _Map.getInt("ErrDisp1");
		if ((!nErrDisp1 && _kExecutionLoopCount == 1) || _bOnDebug)
		{
			reportMessage (sErrorLocation);
			reportMessage("\n" + scriptName() + ": " +T("|Connector|") + " " + sFamily + " " + T("|is not possible for this beam width|") + " --> " + T("|Please select smaller type|"));
			
			_Map.setInt("ErrDisp1", 1);	
		}

		dpErr.draw (sError, ptRef, vecX1, vecY1, 0, 0, _kDeviceX);
		sArticle=PropString(3, sArticlesError, sArticleName);
		sArticle.setCategory (sCategoryType);
		sArticle.set(sError);
		sArticle.setReadOnly(true);
		
		//eraseInstance();		
		return;
	}
	else
	{
		_Map.setInt("ErrDisp1", 0);
	}			
						
		
	
// check if screw length is possible for the width of main carrier

	if(dH1 < dScrewLength)
	{
		int nErrDisp2 = _Map.getInt("ErrDisp2");
		if ((!nErrDisp2 && _kExecutionLoopCount == 1) || _bOnDebug)
		{
			reportMessage (sErrorLocation);
			reportMessage("\n" + scriptName() + ": " +T("|Connector|") + " " + sFamily + " " + T("|with screw length|") + " " + dScrewLength + " " + T("|is not possible for this beam width|") + " --> " + T("|Please select smaller type|"));
			
			_Map.setInt("ErrDisp2", 1);	
		}		
		dpErr.draw (sError, ptRef, vecX1, vecY1, 0, 0, _kDeviceX);
		sArticle=PropString(3, sArticlesError, sArticleName);
		sArticle.setCategory (sCategoryType);
		sArticle.set(sError);
		sArticle.setReadOnly(true);
		//eraseInstance();		
		return;
	}
	
	else
	{
		_Map.setInt("ErrDisp2", 0);
	}	
		
	
	if(dH1 >= dScrewLength)
	{
		if((nMillMode == 2 && (dH1 - dConThick + dShadowGap) < dScrewLength) || (nMillMode == 3 && (dH1 - (dConThick - dMaleMillDepth - dShadowGap)) < dScrewLength))
		{
			int nErrDisp3 = _Map.getInt("ErrDisp3");
			if ((!nErrDisp3 && _kExecutionLoopCount == 1) || _bOnDebug)
			{		
				reportMessage (sErrorLocation);
				reportMessage("\n" + scriptName() + ": " +T("|Connector|") + " " + sFamily + " " + T("|with screw length|") + " " + dScrewLength + " " + T("|can't be milled into the female beam|") + " --> " + T("|Please select other milling option|"));
				
				_Map.setInt("ErrDisp3", 1);	
			}		
			dpErr.draw (sError, ptRef, vecX1, vecY1, 0, 0, _kDeviceX);
			sArticle=PropString(3, sArticlesError, sArticleName);
			sArticle.setCategory (sCategoryType);
			sArticle.set(sError);
			sArticle.setReadOnly(true);
			//eraseInstance();		
			return;
		}

	}
	
	else
	{
		_Map.setInt("ErrDisp3", 0);
	}
	
			
// get the maximum size of the connector concerning the height of the subcarrier

	int nArticleMax = sArticles.length()-1;
	
	
	for (int i= sArticles.length()-1; i >= 0; i--)
	{
		if (dHeightMains[i] > dY)
		//if (dHeightMains[i] > _H0)-------------------------------------------------------------------------------------------------------
		{
			sArticles.removeAt (i);
			dHeightMains.removeAt (i);
			dHeightSecs.removeAt (i);
			nNumScrewMains.removeAt (i);
			nNumScrewSecs.removeAt (i);
			nNumScrewSums.removeAt (i);
			dConHeights.removeAt (i);
			
			nArticleMax = i-1;
		}
	}





// validate angled connections
// check1 = check at 75mm
// check2 = check theoretical case around the screws

double dCheckMov = 0;

// checks are dependat from milling option (back face of connector is milled into the male beam)
// 0 = none, 1 = male beam, 2 = female, 3 = half and half
	if (nMillMode == 1)
	{
		dCheckMov = (dConThick - dShadowGap);
	}

	else if (nMillMode == 3)
	{
		dCheckMov = dConThick - dMaleMillDepth - dShadowGap;
	}


	Point3d ptCheck1;
	Point3d ptCheck2;
		
	double dCheck1 = U(0);
	double dCheck2 = U(0);
	

	if (!vecX0.isParallelTo(vecZ1))
	{

	Line lnCheck1(bm0.ptCen(), vecX0);
	Line lnCheck2(bm0.ptCen(), vecX0);
	
				
	// bring vector vecX0 in X1-Z1 (X0n) and Y1-Z1 plane (X0m)
		Vector3d vecX0n = vecX0.crossProduct(vecY1).crossProduct(-vecY1);
		
		Vector3d vecX0m = vecX0.crossProduct(vecX1).crossProduct(-vecX1);
				
		Vector3d vecOutside = bm0.vecD (-vecZ1);
				
		Vector3d vecOutsiden = vecOutside.crossProduct(vecZ1).crossProduct(-vecZ1);
		vecOutsiden.normalize();
		

		vecX0n.vis(_Pt0, 6);
		vecX0m.vis(_Pt0, 230);
		//vecOutside.vis(_Pt0, 5);
		//vecOutsiden.vis(_Pt0, 150);	
		
		
	// if male beam is tilted in hight check top or bottom distances 			
		if (vecX0n.isParallelTo(vecZ1) && !vecX0m.isParallelTo(vecZ1))
		{
			lnCheck1.transformBy(vecOutside * dH0 * .5);
			lnCheck2.transformBy(vecOutside * (dH0 * .5 - dLimit2));	
			
			ptCheck1 = lnCheck1.intersect(pnBm0, U(-75) - dCheckMov); //check at 75mm --> referring to the sherpa manual
			ptCheck1.vis(1);
			ptCheck2 = lnCheck2.intersect(pnBm0, -dScrewLength - dCheckMov);	
			ptCheck2.vis(1);
			
			dCheck1 = vecOutsiden.dotProduct(ptCheck1 - ptRef);		
			dCheck2 = vecOutsiden.dotProduct(ptCheck2 - ptRef);
			
			//check 1 only for XL and XXL and screw length =160
			if ((nFamily == 5 || nFamily == 4) && dScrewLength == U(160)) //values for check at 75mm --> referring to the sherpa manual
			{
				for (int i = sArticles.length()-1; i >= 0; i--)
				{
					if (dConHeights[i] / 2 > dCheck1)
					{
						sArticles.removeAt (i);
						dHeightMains.removeAt (i);
						dHeightSecs.removeAt (i);
						nNumScrewMains.removeAt (i);
						nNumScrewSecs.removeAt (i);
						nNumScrewSums.removeAt (i);
						dConHeights.removeAt (i);
						
						nArticleMax = i-1;
					}
				}
			
			// validate article
				if (sArticles.length() < 1)
				{
					int nErrDisp4 = _Map.getInt("ErrDisp4");
					if ((!nErrDisp4 && _kExecutionLoopCount == 1) || _bOnDebug)
					{
						reportMessage (sErrorLocation);	
						reportMessage("\n" + scriptName() + ": " +T("|Invalid connection|" + " --> " + T("|distance at 75mm is too small|")));
						
						_Map.setInt("ErrDisp4", 1);
					}
					dpErr.draw (sError, ptRef, vecX1, vecY1, 0, 0, _kDeviceX);
					sArticle=PropString(3, sArticlesError, sArticleName);
					sArticle.setCategory (sCategoryType);
					sArticle.set(sError);
					sArticle.setReadOnly(true);
					//eraseInstance();
					//return;
				}
				else
				{
					_Map.setInt("ErrDisp4", 0);
				}		
							
			}
			
			for (int i = sArticles.length()-1; i >= 0; i--)
			{	
				if ((dConHeights[i] / 2 - dScrewCaseY) > dCheck2)
				{
					sArticles.removeAt (i);
					dHeightMains.removeAt (i);
					dHeightSecs.removeAt (i);
					nNumScrewMains.removeAt (i);
					nNumScrewSecs.removeAt (i);
					nNumScrewSums.removeAt (i);
					dConHeights.removeAt (i);
					
					nArticleMax = i-1;
				}
			}
			// validate article
				if (sArticles.length() < 1)
				{
					int nErrDisp5 = _Map.getInt("ErrDisp5");
					if ((!nErrDisp5 && _kExecutionLoopCount == 1) || _bOnDebug)
					{
						reportMessage (sErrorLocation);
						reportMessage("\n" + scriptName() + ": " +T("|Invalid connection|") + " --> " + T("|Distance between screw tips and beam edge is too small|"));
						
						_Map.setInt("ErrDisp5", 1);
					}
					dpErr.draw (sError, ptRef, vecX1, vecY1, 0, 0, _kDeviceX);
					sArticle=PropString(3, sArticlesError, sArticleName);
					sArticle.setCategory (sCategoryType);
					sArticle.set(sError);
					sArticle.setReadOnly(true);
					//eraseInstance();
					return;
				}	
				
				else
				{
					_Map.setInt("ErrDisp5", 0);
				}							
		}

	// if male beam is rotated to the side, check side distances
		else if (!vecX0n.isParallelTo(vecZ1) && vecX0m.isParallelTo(vecZ1))
		{
			lnCheck1.transformBy(vecOutside * dW0 * .5);
			lnCheck2.transformBy(vecOutside * (dW0 * .5 - dLimit2));
			
			ptCheck1 = lnCheck1.intersect(pnBm0, U(-75));
			ptCheck1.vis(1);
			ptCheck2 = lnCheck2.intersect(pnBm0, -dScrewLength);	
			ptCheck2.vis(1);
						
			dCheck1 = (vecOutsiden.dotProduct(ptCheck1 - ptRef));		
			dCheck2 = (vecOutsiden.dotProduct(ptCheck2 - ptRef));
		
					
			if ((dConWidth / 2 - dScrewCaseX) > dCheck2)
			{
				int nErrDisp6 = _Map.getInt("ErrDisp6");
				if ((!nErrDisp6 && _kExecutionLoopCount == 1) || _bOnDebug)
				{
					reportMessage (sErrorLocation);
					reportMessage("\n" + scriptName() + ": " +T(" |can't be used for the selected beam sizes and connection angle.|" + " --> " + T("|Distance between screw tips and beam edge is too small|")));
					_Map.setInt("ErrDisp6", 1);
				}
				dpErr.draw (sError, ptRef, vecX1, vecY1, 0, 0, _kDeviceX);
				sArticle=PropString(3, sArticlesError, sArticleName);
				sArticle.setCategory (sCategoryType);
				sArticle.set(sError);
				sArticle.setReadOnly(true);
				setExecutionLoops (2);
				return;
			}
			else
			{
				_Map.setInt("ErrDisp6", 0);
			}		
			
		}
		
		if (!vecX0n.isParallelTo(vecZ1) && !vecX0m.isParallelTo(vecZ1))
		{
			int nErrDisp7 = _Map.getInt("ErrDisp7");
			if ((!nErrDisp7 && _kExecutionLoopCount == 1) || _bOnDebug)
			{
				reportMessage (sErrorLocation);
				reportMessage("\n" + scriptName() + ": " +T("|Limit values are not tested on double tilted connections|"));
				_Map.setInt("ErrDisp7", 1);
			}

		}
		else
		{
			_Map.setInt("ErrDisp7", 0);
		}
	
		//lnCheck1.vis(6);
		//lnCheck2.vis(3);
		
	}


	


// get properties by index	
	int nArticle = sArticles.find (sArticle);	
	
// if artcle index is bigger than available, correct the value	
	if (nArticle > sArticles.length()-1)
	{
		nArticle = nArticleMax;
		sArticle.set(sArticles[nArticleMax]);
		
			reportMessage (sErrorLocation);
			reportMessage("\n" + scriptName() + ": " +T("|Connector size was corrected to|") + " " + sArticle);
			
		//setExecutionLoops (2);
		//return;
	}


// when changing family types we need to ensure that the selected article is valid
	if (nArticle<0)
	{
		if (sArticles.length()>0)
		{
			nArticle = nArticleMax;
			sArticle.set(sArticles[nArticleMax]);	

				reportMessage (sErrorLocation);
				reportMessage("\n" + scriptName() + ": " +T("|Connector size was corrected to|") + " " + sArticle);
				
			//setExecutionLoops(2);
			//return;
		}
		else
		{
			if (_kExecutionLoopCount == 1 || (_bOnDebug && _kExecutionLoopCount == 1))
			{
				reportMessage("\n" + scriptName() + ": " +T("|No articles found for this situation|"));
			}
			dpErr.draw (sError, ptRef, vecX1, vecY1, 0, 0, _kDeviceX);
			sArticle.set(sError);
			sArticle.setReadOnly(true);
			//eraseInstance();
			return;	
		}		
	}	


// Trigger set catalog is defined above
// action if trigger "setCatalog" is fired	

	if (_bOnRecalc && _kExecuteKey==sTriggerSetCatalog) // && _kExecutionLoopCount == 1)
 	{

	// get the name from the user	
		String sCatName = getString (T("|Enter the catalog name|"));
		
		// if no name is entered, create a name automatically and make shure it doesn't exist so far
		if (sCatName.length()<1)
		{
			String sCatNames[] = _ThisInst.getListOfCatalogNames();

			String sDefaultName = sArticles[nArticle] + " " + sMillMode + " " + T("|milled|");
			sCatName = sDefaultName;
			int nCt = 1;
			while (sCatNames.find(sCatName)>0)
			{
				sCatName = sDefaultName + " (" + nCt + ")";
				nCt++;
			}
			
			setCatalogFromPropValues(sCatName);
			reportMessage("\n" + scriptName() + ": " +T("|No catalog name entered|") + "\n" + T("|catalog entry created automatically with name|") + ": " + sCatName);
			
		}
		
		else
		{
			setCatalogFromPropValues(sCatName);
			reportMessage("\n" + scriptName() + ": " +T("|catalog entry created with name|") + ": " + sCatName);
			
 		}
	}





	
//----------------------------------------------------------------------------------------------------------------------------------------	
// create body representing the connector
	ptRef.vis(6);
	Body bdConnector(ptRef, vecX1, vecY1, vecZ1, dConWidth, dConHeights[nArticle], dConThick); 
	
	House hsMale(ptRef, vecX1, vecY1, -vecZ1, dConWidth + dMillTolerance, dConHeights[nArticle]*2 + dMillTolerance, dConThick, 0, nRoundType);
	House hsFemale(ptRef, vecX1, vecY1, vecZ1, dConWidth + dMillTolerance, dConHeights[nArticle]*2 + dMillTolerance, dConThick, 0, nRoundType);
	BeamCut bcMale(ptRef, vecX1, vecY1, -vecZ1, dConWidth + dMillTolerance, dConHeights[nArticle]*2 + dMillTolerance, dConThick);
	BeamCut bcMaleNotExtended(ptRef, vecX1, vecY1, -vecZ1, dConWidth + dMillTolerance, dConHeights[nArticle] + dMillTolerance, dConThick);
	//BeamCut bcFemale(ptRef, vecX1, vecY1, vecZ1, dConWidth + dMillTolerance, dConHeights[nArticle]*2 + dMillTolerance, dConThick);

// position of the body and tooling dependant from the milling option
// 0 = none, 1 = male beam, 2 = female, 3 = half and half
	if (nMillMode == 0)
	{
		bdConnector.transformBy (vecZ1 * dConThick *.5);
	}
	else if (nMillMode == 1)
	{
		bdConnector.transformBy (-vecZ1 * (dConThick *.5 - dShadowGap));
		bcMale.transformBy (-vecZ1 * (dConThick *.5 - dShadowGap) - vecY1 * dConHeights[nArticle]*.5);
		bm0.addTool(bcMale);
		//hsMale.transformBy (-vecZ1 * (dConThick *.5 - dShadowGap) - vecY1 * dConHeights[nArticle]*.5);
		//bm0.addTool(hsMale); //BVN format doesn't support this tool on the beam's front
	}
	else if (nMillMode == 2)
	{
		bdConnector.transformBy (vecZ1 * dConThick *.5);
		hsFemale.transformBy (vecZ1 * dConThick *.5 + vecY1 * dConHeights[nArticle]*.5);
		if(bm1.bIsValid())
		{
			bm1.addTool(hsFemale);
		}
		else
		{ 
			sip1.addTool(hsFemale);
		}
	}
	else if (nMillMode == 3)
	{
		bdConnector.transformBy (vecZ1 * (.5*dConThick - dMaleMillDepth));
		bcMale.transformBy (vecZ1 * (.5*dConThick - dMaleMillDepth) - vecY1 * dConHeights[nArticle]*.5);
		bcMaleNotExtended.transformBy (vecZ1 * (.5*dConThick - dMaleMillDepth));
		hsFemale.transformBy (vecZ1 * (.5*dConThick - dMaleMillDepth) + vecY1 * dConHeights[nArticle]*.5);
		
		if (dMaleMillDepth > dGroundPlateThickness)
			bm0.addTool(bcMale);
		else
			bm0.addTool(bcMaleNotExtended);	
		if(bm1.bIsValid())
		{
			bm1.addTool(hsFemale);
		}
		else
		{ 
			sip1.addTool(hsFemale);
		}
	}
	
	//bdConnector.vis(6);
	



//----------------------------------------------------------------------------------------------------------------------------------------
// hardware

//// set flag to create hardware
	//int bAddHardware = _bOnDbCreated;
	//String sEvents[]={sFamilyName, sArticleName, sScrewLengthName};
	//if(sEvents.find(_kNameLastChangedProp)>-1 || _bOnRecalc)
		//bAddHardware=true;


// declare hardware comps for data export
	HardWrComp hwComps[0];	
	
	String s1 = sArticles[nArticle];
	HardWrComp hw(s1 , 1);	
	hw.setCategory(T("|Connectors|"));
	hw.setManufacturer("Sherpa");
	hw.setModel(s1);
	hw.setMaterial(T("|Aluminium|"));
	hw.setDescription(s1);
	hw.setDScaleX(dConHeights[nArticle]);
	hw.setDScaleY(dConWidth);
	hw.setDScaleZ(dConThick);	
	hwComps.append(hw);

	String sScrew = T("|Screw|") + " " + dScrewDiam + " x " + dScrewLength;
	HardWrComp hwNail(sScrew, nNumScrewSums[nArticle] );	
	hwNail.setCategory(T("|Connectors|"));
	hwNail.setManufacturer("Sherpa");
	hwNail.setModel(dScrewDiam + " x " + dScrewLength);
	hwNail.setMaterial(T("|Steel|"));		
	hwNail.setDescription(T("|Screw|"));
	hwNail.setDScaleX(dScrewLength);
	hwNail.setDScaleY(dScrewDiam);
	hwNail.setDScaleZ(0);	
	hwComps.append(hwNail);		

	_ThisInst.setHardWrComps(hwComps);

	
// map beam cross sections

	_Map.setDouble("H0", dH0);
	_Map.setDouble("W0", dW0);
	_Map.setDouble("H1", dH1);
	_Map.setDouble("W1", dW1);
	//reportMessage ("Ende - Beam 0" + _H0 + _W0 + "    Beam 1 " + _H1 + _W1);
	
//----------------------------------------------------------------------------------------------------------------------------------------
// display

	dpModel.draw(bdConnector);

	dpPlan.draw(bdConnector);
	dpPlan.draw (sArticles[nArticle], bdConnector.ptCen(), vecX1, vecZ1, 0, 0, _kDevice);
	
	
	if(_bOnDebug)
	{
		//dpModel.draw (dX,	 ptRef + vecZ0 * .5 * dY, vecX1, vecY1, 0, 2);
		//dpModel.draw (dY, ptRef + vecX1 * .5 * dX, -vecY1, vecX1, 0, 2);
		//dpModel.draw ("Check1 = " + dCheck1, ptRef + vecZ0 * .5 * dY, vecX1, vecY1, 0, 0);
		dpModel.draw ("Check1 = " + dCheck1, ptRef + vecZ0 * .5 * dH0, vecX1, vecY1, 0, 0);
		dpModel.draw ("Check2 = " + dCheck2, ptCheck2, vecX1, vecY1, 0, 2);	
 
	}




#End
#BeginThumbnail
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
,6Q74@8`'I2T4`?_9
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
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="1154" />
        <int nm="BreakPoint" vl="1126" />
        <int nm="BreakPoint" vl="861" />
        <int nm="BreakPoint" vl="1045" />
        <int nm="BreakPoint" vl="774" />
        <int nm="BreakPoint" vl="997" />
        <int nm="BreakPoint" vl="858" />
        <int nm="BreakPoint" vl="1372" />
        <int nm="BreakPoint" vl="1369" />
        <int nm="BreakPoint" vl="1021" />
        <int nm="BreakPoint" vl="989" />
        <int nm="BreakPoint" vl="990" />
        <int nm="BreakPoint" vl="974" />
        <int nm="BreakPoint" vl="972" />
        <int nm="BreakPoint" vl="969" />
        <int nm="BreakPoint" vl="962" />
        <int nm="BreakPoint" vl="961" />
        <int nm="BreakPoint" vl="964" />
        <int nm="BreakPoint" vl="659" />
        <int nm="BreakPoint" vl="759" />
        <int nm="BreakPoint" vl="744" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24486: Fix vx0,vy0,vz0 for the case with panels" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="9/8/2025 11:46:37 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24485: Add support for panels" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="9/3/2025 4:57:37 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20935 bugfix article detection" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="12/18/2023 8:49:47 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14143 bugfix reference location" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="12/14/2021 9:01:26 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End