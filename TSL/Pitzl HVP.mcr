#Version 8
#BeginDescription
#Versions
Version 2.3 30.11.2023 HSB-20786 article selection fixed


version value="2.2" date="24sep2020" author="thorsten.huck@hsbcad.com" HSB-8947 tolerance added on type checking

DACH:
Dieses TSL erzeugt einen Pitzl HVP Verbinder

Befehlsaufruf mittels Werkzeugpalette:
Execute Key:    <GrößenTyp-Katalog Name> Die Trennung der beiden Teile (Größen Typ und Katalogname) muss durch genau ein beliebiges Zeichen ("-", "_", ";" o.ä.) erfolgen!  z.B. "880-Vorgabe" 
Gesamter Befehlsstring:   ^C^C(hsb_scriptinsert "Pitzl HVP" "880-Vorgabe")


EN:
This TSL creates Pitzl HVP connectors between two beams.

To call the command in the tool palette:
Execute Key:    <sizetype-catalog name> e.g. "880-Vorgabe"
Complete command:   ^C^C(hsb_scriptinsert "Pitzl HVP" "880-Vorgabe")

#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 3
#KeyWords connector; pitzl; beam
#BeginContents
/// <summary Lang=en>
/// this TSL creates pitzl HVP connectors between two beams.
/// </summary>

/// <insert Lang=en>
/// At least two non parallel beams are required. Multiple selection of male and female beams is possible.
/// </insert>

/// <remark Lang=en>
/// TSL can be called in different ways:
/// If it's called without execute key <^C^C(hsb_scriptinsert "Pitzl HVP")> a 2 step dialog appears. First you set the family (type) of the connector, then you can set all other properties.
///
/// If it's called with an execute key <^C^C(hsb_scriptinsert "Pitzl HVP" "880-Vorgabe")> no Dialog appears. The settings are taken from the called catalog entry.
/// The execute key consists of two parts, which MUST be separated by ONE character like "-", " ", "_" "?". The first Part specifies the family, the second part is the catalog entry.
/// If the given catalog entry doesn't exist, only the second dialog is shown, since the family is preset by the first part of the execute key.
/// 
/// There is a context command to create catalog entries directly from the inserted instance.
///
///
/// To avoid too much information, all warnings in the command line appear only once. If you activate debug mode you can disable this functionality.
/// </remark>
//#Versions
// 2.3 30.11.2023 HSB-20786 article selection fixed , Author Thorsten Huck
///<version value="2.2" date="24sep2020" author="thorsten.huck@hsbcad.com"> HSB-8947 tolerance added on type checking </version>
///<version value="2.1" date=22.08.19" author="marsel.nakuci@hsbcad.com"> HSB-5210 fix dDouble883_MDHs and dDouble883_MDWs </version>
///<version value="2.0" date=22.08.19" author="marsel.nakuci@hsbcad.com"> HSB-5210 Extend to include Double HVP </version>
///<version value="1.2" date=17may18" author="thorsten.huck@hsbcad.com"> minor bugfix to show correct family on insert via ribbon </version>
///<version value="1.1" date=15may17" author="thorsten.huck@hsbcad.com"> Hyperlinks DE, FR and EN added </version>
/// <version value="1.0" date="14dec17" author="florian.wuermseer@hsbcad.com"> initial version (derived from "Sherpa" TSL)</version>


// constants
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));
	
// ----------------------------------------------------------------------------------------------	

//region HVP
// HVP connector's properties
	// Typ 880
	String sXS_Articles[] = {"88004", "88006", "88008", "88010"};
	double dXS_WidthMain = U(60);
	double dXS_WidthSec = U(45);
	double dXS_HeightMains[] = {U(50), U(70), U(90), U(110)};
	double dXS_HeightSecs[] = {U(50), U(70), U(90), U(110)};
	int nXS_NumScrewMains[] = {3, 4, 5, 6};
	int nXS_NumScrewSecs[] = {3, 4, 5, 6};
	int nXS_NumScrewSums[] = {6, 8, 10, 12};
	double dXS_ScrewLengths[] = {U(50), U(60), U(70), U(80)};
	double dXS_ScrewDiam = U(4.5);
	double dXS_MDHs[] = { U(5), U(10), U(15), U(20)};
	double dXS_MDWs[] = { U(10), U(10), U(10), U(10)};
	// h height
	double dXS_ConHeights[] = {U(40), U(60), U(80), U(100)};
	// w width
	double dXS_ConWidth = U(25);
	// d dicke thickness
	double dXS_ConThick = U(12);
	double dXS_ShadowGap = U(1);
	double dXS_ScrewCaseX = U(4.5);
	double dXS_ScrewCaseY = U(7.5);
	double dXS_GroundPlateThickness = U(3);
	
	// Typ 881
	String sS_Articles[] = {"88107", "88109", "88111", "88113", "88115"};
	double dS_WidthMain = U(60);
	double dS_WidthSec = U(50);
	double dS_HeightMains[] = {U(80), U(100), U(120), U(140), U(160)};
	double dS_HeightSecs[] = {U(80), U(100), U(120), U(140), U(160)};
	int nS_NumScrewMains[] = {5, 7, 8, 9, 11};
	int nS_NumScrewSecs[] = {5, 7, 8, 9, 11};
	int nS_NumScrewSums[] = {10, 14, 16, 18, 22};
	double dS_ScrewLengths[] = {U(50), U(60), U(70), U(80)};	
	double dS_ScrewDiam = U(4.5);
	double dS_MDHs[] = {U(5), U(10), U(15), U(20)};
	double dS_MDWs[] = {U(10), U(10), U(10), U(10)};
	double dS_ConHeights[] = {U(70), U(90), U(110), U(130), U(150)};
	double dS_ConWidth = U(40);
	double dS_ConThick = U(12);
	double dS_ShadowGap = U(1);
	double dS_ScrewCaseX = U(6.5);
	double dS_ScrewCaseY = U(7.5);
	double dS_GroundPlateThickness = U(3);
	
	// Typ 882
	String sM_Articles[] = {"88210", "88214"};
	double dM_WidthMain = U(70);
	double dM_WidthSec = U(80);
	double dM_HeightMains[] = {U(120), U(160)};
	double dM_HeightSecs[] = {U(120), U(160)};
	int nM_NumScrewMains[] = {9, 12};
	int nM_NumScrewSecs[] = {9, 12};
	int nM_NumScrewSums[] = {18, 24};
	double dM_ScrewLengths[] = {U(60), U(80), U(100)};	
	double dM_ScrewDiam = U(5);
	double dM_MDHs[] = {U(10), U(25), U(40)};
	double dM_MDWs[] = {U(10), U(10), U(10)};
	double dM_ConHeights[] = {U(100), U(140)};
	double dM_ConWidth = U(60);
	double dM_ConThick = U(12);
	double dM_ShadowGap = U(1);
	double dM_ScrewCaseX = U(9.5);
	double dM_ScrewCaseY = U(10);
	double dM_GroundPlateThickness = U(3);
	
	// Typ 883
	String sL_Articles[] = {"88318", "88322"};
	double dL_WidthMain = U(70);
	double dL_WidthSec = U(100);
	double dL_HeightMains[] = {U(200), U(240)};
	double dL_HeightSecs[] = {U(200), U(240)};
	int nL_NumScrewMains[] = {17, 22};
	int nL_NumScrewSecs[] = {17, 22};
	int nL_NumScrewSums[] = {34, 44};
	double dL_ScrewLengths[] = {U(60), U(80), U(100)};	
	double dL_ScrewDiam = U(5);
	double dL_MDHs[] = {U(10), U(25), U(40)};
	double dL_MDWs[] = {U(10), U(10), U(10)};
	double dL_ConHeights[] = {U(180), U(220)};
	double dL_ConWidth = U(80);
	double dL_ConThick = U(12);
	double dL_ShadowGap = U(3);
	double dL_ScrewCaseX = U(14);
	double dL_ScrewCaseY = U(15);
	double dL_GroundPlateThickness = U(3);
	
	// Typ 884
	String sXL_Articles[] = {"88420", "88425", "88430", "88435", "88440", "88445", "88450", "88455", "88460"};
	double dXL_WidthMain = U(170);
	double dXL_WidthSec = U(140);
	double dXL_HeightMains[] = {U(220), U(270), U(320), U(370), U(420), U(470), U(520), U(570), U(620)};
	double dXL_HeightSecs[] = {U(220), U(270), U(320), U(370), U(420), U(470), U(520), U(570), U(620)};
	int nXL_NumScrewMains[] = {8, 10, 12, 14, 16, 18, 20, 22, 24};
	int nXL_NumScrewSecs[] = {8, 10, 12, 14, 16, 18, 20, 22, 24};
	int nXL_NumScrewSums[] = {16, 20, 24, 28, 32, 36, 40, 44, 48};
	double dXL_ScrewLengths[] = {U(160), U(180), U(200)};		
	double dXL_ScrewDiam = U(8);
	double dXL_MDHs[] = {U(10), U(25), U(40)};
	double dXL_MDWs[] = {U(10), U(10), U(10)};
	double dXL_ConHeights[] = {U(200), U(250), U(300), U(350), U(400), U(450), U(500), U(550), U(600)};
	double dXL_ConWidth = U(120);
	double dXL_ConThick = U(20);
	double dXL_ShadowGap = U(3);
	double dXL_ScrewCaseX = U(14);
	double dXL_ScrewCaseY = U(25);
	double dXL_GroundPlateThickness = U(5);
	
	// Typ 885
	String sXXL_Articles[] = {"88540", "88545", "88550", "88555", "88560"};
	double dXXL_WidthMain = U(170);
	double dXXL_WidthSec = U(170);
	double dXXL_HeightMains[] = {U(420), U(470), U(520), U(570), U(620)};
	double dXXL_HeightSecs[] = {U(420), U(470), U(520), U(570), U(620)};
	int nXXL_NumScrewMains[] = {20, 24, 26, 28, 32};
	int nXXL_NumScrewSecs[] = {20, 24, 26, 28, 32};
	int nXXL_NumScrewSums[] = {40, 48, 52, 56, 64};
	double dXXL_ScrewLengths[] = {U(160), U(180), U(200)};		
	double dXXL_ScrewDiam = U(8);
	double dXXL_MDHs[] = {U(10), U(25), U(40)};
	double dXXL_MDWs[] = {U(15), U(15), U(15)};
	double dXXL_ConHeights[] = {U(400), U(450), U(500), U(550), U(600)};
	double dXXL_ConWidth = U(140);
	double dXXL_ConThick = U(20);
	double dXXL_ShadowGap = U(3);
	double dXXL_ScrewCaseX = U(14);
	double dXXL_ScrewCaseY = U(-5);
	double dXXL_GroundPlateThickness = U(5);
	
// ----------------------------------------------------------------------------------------------
//End HVP//endregion
	
//region Double HVP
	
// Double HVP connector's properties
	// Typ 882
	String sDouble882_Articles[] = {"88210.2", "88214.2"};
	// Minimal timber section width
	double dDouble882_WidthMain = U(70);
	// Minimal joist section width
	double dDouble882_WidthSec = U(140);
	// Minimal timber section height
	double dDouble882_HeightMains[] = {U(120), U(160)};
	// Minimal joist section height
	double dDouble882_HeightSecs[] = {U(120), U(160)};
	
	// nr screws at main part
	int nDouble882_NumScrewMains[] = {16, 22};
	// nr screws at second part
	int nDouble882_NumScrewSecs[] = {16, 22};
	// nr of screws at both parts
	int nDouble882_NumScrewSums[] = { 32, 44};
	// screw length
	double dDouble882_ScrewLengths[] = { U(60), U(80), U(100)};
	// screw diameter
	double dDouble882_ScrewDiam = U(5);
	double dDouble882_MDHs[] = { U(5), U(10), U(15)};
	double dDouble882_MDWs[] = { U(10), U(10), U(10)};
	// h height
	double dDouble882_ConHeights[] = { U(100), U(140)};
	// w width
	double dDouble882_ConWidth = U(120);
	// d dicke thickness
	double dDouble882_ConThick = U(12);
	
	double dDouble882_ShadowGap = U(1);
	double dDouble882_ScrewCaseX = U(4.5);
	double dDouble882_ScrewCaseY = U(7.5);
	double dDouble882_GroundPlateThickness = U(3);
	
// Double HVP connector's properties
	// Typ 883
	String sDouble883_Articles[] = {"88318.2", "88322.2"};
	// Minimal timber section width
	double dDouble883_WidthMain = U(70);
	// Minimal joist section width
	double dDouble883_WidthSec = U(180);
	// Minimal timber section height
	double dDouble883_HeightMains[] = {U(200), U(240)};
	// Minimal joist section height
	double dDouble883_HeightSecs[] = {U(200), U(240)};
	
	int nDouble883_NumScrewMains[] = {32, 42};
	int nDouble883_NumScrewSecs[] = {32, 42};
	// nr of screws
	int nDouble883_NumScrewSums[] = { 64, 84};
	// screw length
	double dDouble883_ScrewLengths[] = { U(60), U(80), U(100)};
	// screw diameter
	double dDouble883_ScrewDiam = U(5);
	double dDouble883_MDHs[] = { U(5), U(10), U(15)};
	double dDouble883_MDWs[] = { U(10), U(10), U(10)};
	// h height
	double dDouble883_ConHeights[] = { U(180), U(220)};
	// w width
	double dDouble883_ConWidth = U(160);
	// d dicke thickness
	double dDouble883_ConThick = U(12);
	
	double dDouble883_ShadowGap = U(1);
	double dDouble883_ScrewCaseX = U(4.5);
	double dDouble883_ScrewCaseY = U(7.5);
	double dDouble883_GroundPlateThickness = U(3);
	
// Double HVP connector's properties
	// Typ 884
	String sDouble884_Articles[] = { "88420.2", "88425.2", "88430.2", "88435.2", "88440.2", 
									"88445.2", "88450.2", "88455.2", "88460.2"};
	// Minimal timber section width
	double dDouble884_WidthMain = U(160);
	// Minimal joist section width
	double dDouble884_WidthSec = U(260);
	// Minimal timber section height
	double dDouble884_HeightMains[] = { U(220), U(270), U(320), U(370), U(420), 
										U(470), U(520), U(570), U(620)};
	// Minimal joist section height
	double dDouble884_HeightSecs[] = { U(220), U(270), U(320), U(370), U(420), 
										U(470), U(520), U(570), U(620)};
	
	int nDouble884_NumScrewMains[] = { 14, 18, 22, 26, 30, 
										34, 38, 42, 46};
	int nDouble884_NumScrewSecs[] = { 14, 18, 22, 26, 30,
										34, 38, 42, 46};
	// nr of screws
	int nDouble884_NumScrewSums[] = { 28, 36, 44, 52, 60, 
									68, 76, 84, 92};
	// screw length
	double dDouble884_ScrewLengths[] = {U(160), U(180), U(200)};
	// screw diameter
	double dDouble884_ScrewDiam = U(8);
	double dDouble884_MDHs[] = {U(10), U(25), U(40)};
	double dDouble884_MDWs[] = {U(15), U(15), U(15)};
	// h height
	double dDouble884_ConHeights[] = { U(200), U(250), U(300), U(350), U(400), 
									U(450), U(500), U(550), U(600)};
	// w width
	double dDouble884_ConWidth = U(240);
	// d dicke thickness
	double dDouble884_ConThick = U(20);
	
	double dDouble884_ShadowGap = U(1);
	double dDouble884_ScrewCaseX = U(4.5);
	double dDouble884_ScrewCaseY = U(7.5);
	double dDouble884_GroundPlateThickness = U(3);
	
// ----------------------------------------------------------------------------------------------
	
//End Double HVP//endregion
	
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
	double dMDHs[0];
	double dMDWs[0];
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
	String sFamilies[] = {"880", "881", "882", "883", "884", "885",
						"Double_882", "Double_883", "Double_884"};
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
		String sKey = _kExecuteKey;
		
		//int nPos = sKey.find("-",0);
	// split execute key into family name and catalog name	
		String sOpmKey;
		String sCat;
		
		if (sKey.left(3) == "880")
		{
			sOpmKey = "880";
			sCat = sKey.right(sKey.length()-sOpmKey.length()-1);
		}		
		if (sKey.left(3) == "881")
		{
			sOpmKey = "881";
			sCat = sKey.right(sKey.length()-sOpmKey.length()-1);			
		}
		if (sKey.left(3) == "882")
		{
			sOpmKey = "882";
			sCat = sKey.right(sKey.length()-sOpmKey.length()-1);			
		}
		if (sKey.left(3) == "883")
		{
			sOpmKey = "883";
			sCat = sKey.right(sKey.length()-sOpmKey.length()-1);			
		}
		if (sKey.left(3) == "884")
		{
			sOpmKey = "884";
			sCat = sKey.right(sKey.length()-sOpmKey.length()-1);			
		}
		if (sKey.left(3) == "885")
		{
			sOpmKey = "885";
			sCat = sKey.right(sKey.length()-sOpmKey.length()-1);			
		}
		// add Double HVP types
		if (sKey.left(3) == "Double_882")
		{
			sOpmKey = "Double_882";
			sCat = sKey.right(sKey.length() - sOpmKey.length() - 1);
		}
		if (sKey.left(3) == "Double_883")
		{
			sOpmKey = "Double_883";
			sCat = sKey.right(sKey.length() - sOpmKey.length() - 1);
		}
		if (sKey.left(3) == "Double_884")
		{
			sOpmKey = "Double_884";
			sCat = sKey.right(sKey.length() - sOpmKey.length() - 1);
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
		// Double HVP
		else if (nFamily == 6)
		{ 
//			dScrewLengths = dXXL_ScrewLengths;
			dScrewLengths = dDouble882_ScrewLengths;
//			sArticles = sXXL_Articles;
			sArticles = sDouble882_Articles;
//			dShadowGapPreset = dXXL_ShadowGap;
			dShadowGapPreset = dDouble882_ShadowGap;
		}
		else if (nFamily == 7)
		{ 
//			dScrewLengths = dXXL_ScrewLengths;
			dScrewLengths = dDouble883_ScrewLengths;
//			sArticles = sXXL_Articles;
			sArticles = sDouble883_Articles;
//			dShadowGapPreset = dXXL_ShadowGap;
			dShadowGapPreset = dDouble883_ShadowGap;
		}
		else if (nFamily == 8)
		{ 
//			dScrewLengths = dXXL_ScrewLengths;
			dScrewLengths = dDouble884_ScrewLengths;
//			sArticles = sXXL_Articles;
			sArticles = sDouble884_Articles;
//			dShadowGapPreset = dXXL_ShadowGap;
			dShadowGapPreset = dDouble884_ShadowGap;
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
			showDialog("---");
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

		PrEntity ssFemale(T("|Select female beam(s)|"), Beam());
		if (ssFemale.go())
		{
		// avoid females to be added to males again
			ents = ssFemale.set();
			for (int i=0;i<ents.length();i++)
				if(entMales.find(ents[i])<0)
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
					// create new instance	
					tslNew.dbCreate(scriptName(), vUcsX, vUcsY, gbAr, entAr, ptAr, nArProps, dArProps, sArProps, _kModelSpace, mapTsl); // create new instance	
				} // next j
		}	// next i
			
			
		eraseInstance();
		return;
	} 
// end on insert --------------------------------------------------------------------------------------------------------------------------------------------


		
// Find family Index
	int nFamily = sFamilies.find (sFamily,0);	
	
	if (nFamily == 0)
	{
		sArticles = sXS_Articles;
//		dWidthMain = dXS_WidthMain;
//		dHeightMains = dXS_HeightMains;
//		dWidthSec = dXS_WidthSec;
//		dHeightSecs = dXS_HeightSecs;
		nNumScrewMains = nXS_NumScrewMains;
		nNumScrewSecs = nXS_NumScrewSecs;
		nNumScrewSums = nXS_NumScrewSums;
		dScrewDiam = dXS_ScrewDiam;
		dScrewLengths = dXS_ScrewLengths;
		dMDHs = dXS_MDHs;
		dMDWs = dXS_MDWs;
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
//		dWidthMain = dS_WidthMain;
//		dHeightMains = dS_HeightMains;
//		dWidthSec = dS_WidthSec;
//		dHeightSecs = dS_HeightSecs;
		nNumScrewMains = nS_NumScrewMains;
		nNumScrewSecs = nS_NumScrewSecs;
		nNumScrewSums = nS_NumScrewSums;
		dScrewDiam = dS_ScrewDiam;
		dScrewLengths = dS_ScrewLengths;
		dMDHs = dS_MDHs;
		dMDWs = dS_MDWs;
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
//		dWidthMain = dM_WidthMain;
//		dHeightMains = dM_HeightMains;
//		dWidthSec = dM_WidthSec;
//		dHeightSecs = dM_HeightSecs;
		nNumScrewMains = nM_NumScrewMains;
		nNumScrewSecs = nM_NumScrewSecs;
		nNumScrewSums = nM_NumScrewSums;
		dScrewDiam = dM_ScrewDiam;
		dScrewLengths = dM_ScrewLengths;
		dMDHs = dM_MDHs;
		dMDWs = dM_MDWs;
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
//		dWidthMain = dL_WidthMain;
//		dHeightMains = dL_HeightMains;
//		dWidthSec = dL_WidthSec;
//		dHeightSecs = dL_HeightSecs;
		nNumScrewMains = nL_NumScrewMains;
		nNumScrewSecs = nL_NumScrewSecs;
		nNumScrewSums = nL_NumScrewSums;
		dScrewDiam = dL_ScrewDiam;
		dScrewLengths = dL_ScrewLengths;
		dMDHs = dL_MDHs;
		dMDWs = dL_MDWs;
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
//		dWidthMain = dXL_WidthMain;
//		dHeightMains = dXL_HeightMains;
//		dWidthSec = dXL_WidthSec;
//		dHeightSecs = dXL_HeightSecs;
		nNumScrewMains = nXL_NumScrewMains;
		nNumScrewSecs = nXL_NumScrewSecs;
		nNumScrewSums = nXL_NumScrewSums;
		dScrewLengths = dXL_ScrewLengths;
		dScrewDiam = dXL_ScrewDiam;
		dMDHs = dXL_MDHs;
		dMDWs = dXL_MDWs;
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
//		dWidthMain = dXXL_WidthMain;
//		dHeightMains = dXXL_HeightMains;
//		dWidthSec = dXXL_WidthSec;
//		dHeightSecs = dXXL_HeightSecs;
		nNumScrewMains = nXXL_NumScrewMains;
		nNumScrewSecs = nXXL_NumScrewSecs;
		nNumScrewSums = nXXL_NumScrewSums;
		dScrewDiam = dXXL_ScrewDiam;
		dScrewLengths = dXXL_ScrewLengths;
		dMDHs = dXXL_MDHs;
		dMDWs = dXXL_MDWs;
		dConHeights = dXXL_ConHeights;
		dConWidth = dXXL_ConWidth;
		dConThick = dXXL_ConThick;
		dShadowGapPreset = dXXL_ShadowGap;
		dScrewCaseX = dXXL_ScrewCaseX;
		dScrewCaseY = dXXL_ScrewCaseY;
		dGroundPlateThickness = dXXL_GroundPlateThickness;

	}
// Double HVP
	else if (nFamily == 6)
	{ 
		sArticles = sDouble882_Articles;
//		dWidthMain = dXXL_WidthMain;
//		dHeightMains = dXXL_HeightMains;
//		dWidthSec = dXXL_WidthSec;
//		dHeightSecs = dXXL_HeightSecs;
		nNumScrewMains = nDouble882_NumScrewMains;
		nNumScrewSecs = nDouble882_NumScrewSecs;
		nNumScrewSums = nDouble882_NumScrewSums;
		dScrewDiam = dDouble882_ScrewDiam;
		dScrewLengths = dDouble882_ScrewLengths;
		dMDHs = dDouble882_MDHs;
		dMDWs = dDouble882_MDWs;
		dConHeights = dDouble882_ConHeights;
		dConWidth = dDouble882_ConWidth;
		dConThick = dDouble882_ConThick;
		dShadowGapPreset = dDouble882_ShadowGap;
		dScrewCaseX = dDouble882_ScrewCaseX;
		dScrewCaseY = dDouble882_ScrewCaseY;
		dGroundPlateThickness = dDouble882_GroundPlateThickness;
	}
	else if (nFamily == 7)
	{ 
		sArticles = sDouble883_Articles;
//		dWidthMain = dXXL_WidthMain;
//		dHeightMains = dXXL_HeightMains;
//		dWidthSec = dXXL_WidthSec;
//		dHeightSecs = dXXL_HeightSecs;
		nNumScrewMains = nDouble883_NumScrewMains;
		nNumScrewSecs = nDouble883_NumScrewSecs;
		nNumScrewSums = nDouble883_NumScrewSums;
		dScrewDiam = dDouble883_ScrewDiam;
		dScrewLengths = dDouble883_ScrewLengths;
		dMDHs = dDouble883_MDHs;
		dMDWs = dDouble883_MDWs;
		dConHeights = dDouble883_ConHeights;
		dConWidth = dDouble883_ConWidth;
		dConThick = dDouble883_ConThick;
		dShadowGapPreset = dDouble883_ShadowGap;
		dScrewCaseX = dDouble883_ScrewCaseX;
		dScrewCaseY = dDouble883_ScrewCaseY;
		dGroundPlateThickness = dDouble883_GroundPlateThickness;
	}
	else if (nFamily == 8)
	{ 
		sArticles = sDouble884_Articles;
//		dWidthMain = dXXL_WidthMain;
//		dHeightMains = dXXL_HeightMains;
//		dWidthSec = dXXL_WidthSec;
//		dHeightSecs = dXXL_HeightSecs;
		nNumScrewMains = nDouble884_NumScrewMains;
		nNumScrewSecs = nDouble884_NumScrewSecs;
		nNumScrewSums = nDouble884_NumScrewSums;
		dScrewDiam = dDouble884_ScrewDiam;
		dScrewLengths = dDouble884_ScrewLengths;
		dMDHs = dDouble884_MDHs;
		dMDWs = dDouble884_MDWs;
		dConHeights = dDouble884_ConHeights;
		dConWidth = dDouble884_ConWidth;
		dConThick = dDouble884_ConThick;
		dShadowGapPreset = dDouble884_ShadowGap;
		dScrewCaseX = dDouble884_ScrewCaseX;
		dScrewCaseY = dDouble884_ScrewCaseY;
		dGroundPlateThickness = dDouble884_GroundPlateThickness;
	}
		
	else
	{
		reportMessage ("|This shouldn't happen - please contact your local dealer|");
	}
	
// set opm key
		setOPMKey(sFamily);



// define beams and points

	Beam bm0 = _Beam[0];
	Beam bm1 = _Beam[1];
	
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
		
		if (dH0prev != _H0 || dW0prev != _W0 || dH1prev != _H1 || dW1prev != _W1)
			bBeamSizeChange = 1;
	}
	//reportMessage ("Size change " + bBeamSizeChange);
	//reportMessage ("Beam 0" + dH0prev + dW0prev + "    Beam 1 " + dH1prev + dW1prev);
		

// declare additional properties	
	PropDouble dScrewLength (nDoubleIndex++, dScrewLengths, sScrewLengthName);
	dScrewLength.setCategory (sCategoryType);	
	dScrewLength.setDescription(T("|Screw length|"));
	int nScrewLength = dScrewLengths.find(dScrewLength);
	
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
	
	if (dScrewLengths.length() == 1) 
	{
		dScrewLength.setReadOnly(true);
	}

// display ----------------------------------------------------------------------------------------------------------------------------------
	
// set hyperlink
	String sIsoCode = T("|IsoCode|");
	String sIsoCodes[] ={"BG","HR","CS","DA","NL",
		"EN", "ET", "FI", "FR", "DE",
		"EL", "HU", "IT", "JA", "KO",
		"LT", "NO", "PL", "PT", "RO",
		"RU", "SK", "SL", "ES", "SV", 
		"TR", "UK", "ZH-CHS"};
	int nIsoCode = sIsoCodes.find(sIsoCode);
	String sUrl = "https://www.pitzl-connectors.com/en/products/verbinder/cat/hvp/";
	if (nIsoCode==8)// french
		sUrl = "https://www.pitzl-connectors.com/fr/produits/verbinder/cat/hvp/";
	else if (nIsoCode==9)// german
		sUrl = "https://www.pitzl-connectors.com/produkte/verbinder/cat/hvp/";	
	if (sUrl.find(".",0)>0)
		_ThisInst.setHyperlink(sUrl);


// standard color is 252, but can be changed by the instance color after insertion 
	int nColor = _ThisInst.color();
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
	

// find chosen milling options	
	int nMillMode = sMillModes.find(sMillMode);
	
	int nToolShape = sToolShapes.find(sToolShape);
	int nRoundType = nRoundTypes[nToolShape];
	
// find the corresponding minimum distances around the connector for the chosen screw lengths
	if (nScrewLength == -1) //screw length not found - can happen, when user changes model at an inserted instance
	{ 
		if (dScrewLength > dScrewLengths[dScrewLengths.length() -1])
			dScrewLength.set(dScrewLengths[dScrewLengths.length() -1]);
		else
			dScrewLength.set(dScrewLengths[0]);
		reportMessage("\n" + T("|Screw length not found|") + "   -->   " + T("|Value corrected to|") + " " + dScrewLength);
		
		nScrewLength = dScrewLengths.find(dScrewLength);
//		setExecutionLoops(2);
//		return;
	}
	
	double dMDH = dMDHs[nScrewLength];
	double dMDW = dMDWs[nScrewLength];
	
	
	for (int i=0 ; i < sArticles.length() ; i++)
	{
	    dHeightMains.append(dConHeights[i] + 2*dMDH);
	    dHeightSecs.append(dConHeights[i] + 2*dMDH);
	    dWidthMain = dConWidth + 2*dMDW;
	    dWidthSec = dConWidth + 2*dMDW;
	}

//	reportMessage("\n" + T("|ScrewLength|") + dScrewLength + "   -->   " + "Offset Top" + dMDH + " Offset Side" + dMDW);
//	reportMessage("\n" + T("|minimum Main|") + "   -->   " + dHeightMains + " / " + dWidthMain);
//	reportMessage("\n" + T("|minimum Sec|") + "   -->   " + dHeightSecs + " / " + dWidthSec);

	
// get required gap between the beams
// 0 = none, 1 = male beam, 2 = female, 3 = both

	if (dShadowGap > dConThick)
	{
		reportMessage (T("|Shadow Gap|") + " " + T("|out of range|") + " --> " + T("|corrected to|") + " " + dConThick);
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
			reportMessage (T("|Mill depth in male beam|") + " " + T("|out of range|") + " --> " + T("|corrected to|") + " " + (dConThick - dShadowGap));
			
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

	
// define bodies for connection area
	Body bd0 = bm0.realBody();
	Body bd1 = bm1.realBody();
	
	
// get connection area
	Plane pnBm0 (ptCut, vecZ1);

	PlaneProfile ppFront = bd0.extractContactFaceInPlane (pnBm0, dEps);
	//ppFront.vis (6);
	
	PlaneProfile ppSide = bd1.shadowProfile (_Plf);
	//ppSide.vis (5);

	PlaneProfile ppContact = ppFront;
	ppContact.intersectWith (ppSide);
	
	ppContact.vis (2);	
	
// get dimension of contact area
	LineSeg segContact = ppContact.extentInDir (_X1);
	
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

// check connector orientation
	PropString sArticle	(nStringIndex++, sArticlesError, sArticleName); // HSB-20786
	sArticle.setCategory (sCategoryType);
	
	if (_ZW.dotProduct(vecY1) < -dEps)
	{
		int nErrDisp8 = _Map.getInt("ErrDisp8");
		if ((!nErrDisp8 && _kExecutionLoopCount == 1) || _bOnDebug)
		{
			reportMessage (sErrorLocation);
			reportMessage ("\n" + T("|Connector|") + " " + T("|is upside down oriented|") + " --> " + T("|Please change axis orientation|"));
			_Map.setInt("ErrDisp8", 1);		
		}
		
		String sErrorOrientation = T("|upside down|");
		dpErr.draw (sError + " (" + sErrorOrientation + ")", ptRef, vecX1, vecY1, 0, 0, _kDeviceX);
		
//		PropString sArticle	(nStringIndex++, sArticlesError, sArticleName);
//		sArticle.setCategory (sCategoryType);
		sArticle.set(sError);
		sArticle.setReadOnly(true);
		
		//reportNotice("\nXX1");
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
			reportMessage ("\n" + T("|Connector|") + " " + T("|is sideward orientated|") + " --> " + T("|Please change axis orientation|"));
			_Map.setInt("ErrDisp9", 1);		
		}
		String sErrorOrientation = T("|orientation sideward|");
		dpErr.draw (sError + " (" + sErrorOrientation + ")", ptRef, vecX1, vecY1, 0, 0, _kDeviceX);
		
//		PropString sArticle	(nStringIndex++, sArticlesError, sArticleName);	// HSB-20786
//		sArticle.setCategory (sCategoryType);
		sArticle.set(sError);
		sArticle.setReadOnly(true);
		//reportNotice("\nXX2");
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
			reportMessage ("\n" + T("|Connector|") + " " + sFamily + " " + T("|is not possible for this beam width|") + " --> " + T("|Please select smaller type|"));
			_Map.setInt("ErrDisp1", 1);		
		}

// HSB-20786
		//dpErr.draw (sError, ptRef, vecX1, vecY1, 0, 0, _kDeviceX); 
//		PropString sArticle	(nStringIndex++, sArticlesError, sArticleName);
//		sArticle.setCategory (sCategoryType);
//		sArticle.set(sError);
//		sArticle.setReadOnly(true);

		// HSB-20786
		pushCommandOnCommandStack("_HSB_Recalc");
 		pushCommandOnCommandStack("(handent \""+_ThisInst.handle()+"\")");
 		pushCommandOnCommandStack("(Command \"\")");
		return;
	}

	else
	{
		_Map.setInt("ErrDisp1", 0);
	}			
						
		
	
// check if screw length is possible for the width of main carrier

	if(_H1 < dScrewLength)
	{
		int nErrDisp2 = _Map.getInt("ErrDisp2");
		if ((!nErrDisp2 && _kExecutionLoopCount == 1) || _bOnDebug)
		{
			reportMessage (sErrorLocation);
			reportMessage ("\n" + T("|Connector|") + " " + sFamily + " " + T("|with screw length|") + " " + dScrewLength + " " + T("|is not possible for this beam width|") + " --> " + T("|Please select smaller type|"));
			_Map.setInt("ErrDisp2", 1);	
		}		
		dpErr.draw (sError, ptRef, vecX1, vecY1, 0, 0, _kDeviceX);
//		PropString sArticle	(nStringIndex++, sArticlesError, sArticleName);
//		sArticle.setCategory (sCategoryType);
		sArticle.set(sError);
		sArticle.setReadOnly(true);
		//reportNotice("\nXX4");
		//eraseInstance();		
		return;
	}
	
	else
	{
		_Map.setInt("ErrDisp2", 0);
	}	
		
	
	if(_H1 >= dScrewLength)
	{
		if((nMillMode == 2 && (_H1 - dConThick + dShadowGap) < dScrewLength) || (nMillMode == 3 && (_H1 - (dConThick - dMaleMillDepth - dShadowGap)) < dScrewLength))
		{
			int nErrDisp3 = _Map.getInt("ErrDisp3");
			if ((!nErrDisp3 && _kExecutionLoopCount == 1) || _bOnDebug)
			{		
				reportMessage (sErrorLocation);
				reportMessage ("\n" + T("|Connector|") + " " + sFamily + " " + T("|with screw length|") + " " + dScrewLength + " " + T("|can't be milled into the female beam|") + " --> " + T("|Please select other milling option|"));
				_Map.setInt("ErrDisp3", 1);	
			}		
			dpErr.draw (sError, ptRef, vecX1, vecY1, 0, 0, _kDeviceX);
//			PropString sArticle	(nStringIndex++, sArticlesError, sArticleName);
//			sArticle.setCategory (sCategoryType);
			sArticle.set(sError);
			sArticle.setReadOnly(true);
			//reportNotice("\nXX5");
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
		
		if (dHeightSecs[i] > dY+dEps) // HSB-8947 +dEps
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




//// validation of angled connections not possible  --> no check values found in manufacturer manual...
//// check1 = check at 75mm
//// check2 = check theoretical case around the screws
//
//double dCheckMov = 0;
//
//// checks are dependent from milling option (back face of connector is milled into the male beam)
//// 0 = none, 1 = male beam, 2 = female, 3 = half and half
//	if (nMillMode == 1)
//	{
//		dCheckMov = (dConThick - dShadowGap);
//	}
//
//	else if (nMillMode == 3)
//	{
//		dCheckMov = dConThick - dMaleMillDepth - dShadowGap;
//	}
//
//
//	Point3d ptCheck1;
//	Point3d ptCheck2;
//		
//	double dCheck1 = U(0);
//	double dCheck2 = U(0);
//	
//
//	if (!vecX0.isParallelTo(vecZ1))
//	{
//
//	Line lnCheck1(bm0.ptCen(), vecX0);
//	Line lnCheck2(bm0.ptCen(), vecX0);
//	
//				
//	// bring vector vecX0 in X1-Z1 (X0n) and Y1-Z1 plane (X0m)
//		Vector3d vecX0n = vecX0.crossProduct(vecY1).crossProduct(-vecY1);
//		
//		Vector3d vecX0m = vecX0.crossProduct(vecX1).crossProduct(-vecX1);
//				
//		Vector3d vecOutside = bm0.vecD (-vecZ1);
//				
//		Vector3d vecOutsiden = vecOutside.crossProduct(vecZ1).crossProduct(-vecZ1);
//		vecOutsiden.normalize();
//		
//
//		vecX0n.vis(_Pt0, 6);
//		vecX0m.vis(_Pt0, 230);
//		//vecOutside.vis(_Pt0, 5);
//		//vecOutsiden.vis(_Pt0, 150);	
//		
//		
//	// if male beam is tilted in hight check top or bottom distances 			
//		if (vecX0n.isParallelTo(vecZ1) && !vecX0m.isParallelTo(vecZ1))
//		{
//			lnCheck1.transformBy(vecOutside * _H0 * .5);
//			lnCheck2.transformBy(vecOutside * (_H0 * .5 - dLimit2));	
//			
//			ptCheck1 = lnCheck1.intersect(pnBm0, U(-75) - dCheckMov); //check at 75mm --> referring to the sherpa manual
//			ptCheck1.vis(1);
//			ptCheck2 = lnCheck2.intersect(pnBm0, -dScrewLength - dCheckMov);	
//			ptCheck2.vis(1);
//			
//			dCheck1 = vecOutsiden.dotProduct(ptCheck1 - ptRef);		
//			dCheck2 = vecOutsiden.dotProduct(ptCheck2 - ptRef);
//			
//			//check 1 only for XL and XXL and screw length =160
//			if ((nFamily == 5 || nFamily == 4) && dScrewLength == U(160)) //values for check at 75mm --> referring to the sherpa manual
//			{
//				for (int i = sArticles.length()-1; i >= 0; i--)
//				{
//					if (dConHeights[i] / 2 > dCheck1)
//					{
//						sArticles.removeAt (i);
//						dHeightMains.removeAt (i);
//						dHeightSecs.removeAt (i);
//						nNumScrewMains.removeAt (i);
//						nNumScrewSecs.removeAt (i);
//						nNumScrewSums.removeAt (i);
//						dConHeights.removeAt (i);
//						
//						nArticleMax = i-1;
//					}
//				}
//			
//			// validate article
//				if (sArticles.length() < 1)
//				{
//					int nErrDisp4 = _Map.getInt("ErrDisp4");
//					if ((!nErrDisp4 && _kExecutionLoopCount == 1) || _bOnDebug)
//					{
//						reportMessage (sErrorLocation);	
//						reportMessage ("\n" + T("|Invalid connection|" + " --> " + T("|distance at 75mm is too small|")));
//						_Map.setInt("ErrDisp4", 1);
//					}
//					dpErr.draw (sError, ptRef, vecX1, vecY1, 0, 0, _kDeviceX);
//					PropString sArticle	(nStringIndex++, sArticlesError, sArticleName);
//					sArticle.setCategory (sCategoryType);
//					sArticle.set(sError);
//					sArticle.setReadOnly(true);
//					//eraseInstance();
//					//return;
//				}
//				
//				else
//				{
//					_Map.setInt("ErrDisp4", 0);
//				}		
//							
//			}
//			
//			
//			
//			for (int i = sArticles.length()-1; i >= 0; i--)
//			{	
//				if ((dConHeights[i] / 2 - dScrewCaseY) > dCheck2)
//				{
//					sArticles.removeAt (i);
//					dHeightMains.removeAt (i);
//					dHeightSecs.removeAt (i);
//					nNumScrewMains.removeAt (i);
//					nNumScrewSecs.removeAt (i);
//					nNumScrewSums.removeAt (i);
//					dConHeights.removeAt (i);
//					
//					nArticleMax = i-1;
//				}
//			}
//			// validate article
//				if (sArticles.length() < 1)
//				{
//					int nErrDisp5 = _Map.getInt("ErrDisp5");
//					if ((!nErrDisp5 && _kExecutionLoopCount == 1) || _bOnDebug)
//					{
//						reportMessage (sErrorLocation);
//						reportMessage ("\n" + T("|Invalid connection|") + " --> " + T("|Distance between screw tips and beam edge is too small|"));
//						_Map.setInt("ErrDisp5", 1);
//					}
//					dpErr.draw (sError, ptRef, vecX1, vecY1, 0, 0, _kDeviceX);
//					PropString sArticle	(nStringIndex++, sArticlesError, sArticleName);
//					sArticle.setCategory (sCategoryType);
//					sArticle.set(sError);
//					sArticle.setReadOnly(true);
//					//eraseInstance();
//					return;
//				}	
//				
//				else
//				{
//					_Map.setInt("ErrDisp5", 0);
//				}			
//							
//						
//	
//						
//		}
//
//	// if male beam is rotated to the side, check side distances
//		else if (!vecX0n.isParallelTo(vecZ1) && vecX0m.isParallelTo(vecZ1))
//		{
//			lnCheck1.transformBy(vecOutside * _W0 * .5);
//			lnCheck2.transformBy(vecOutside * (_W0 * .5 - dLimit2));
//			
//			ptCheck1 = lnCheck1.intersect(pnBm0, U(-75));
//			ptCheck1.vis(1);
//			ptCheck2 = lnCheck2.intersect(pnBm0, -dScrewLength);	
//			ptCheck2.vis(1);
//						
//			dCheck1 = (vecOutsiden.dotProduct(ptCheck1 - ptRef));		
//			dCheck2 = (vecOutsiden.dotProduct(ptCheck2 - ptRef));
//		
//					
//			if ((dConWidth / 2 - dScrewCaseX) > dCheck2)
//			{
//				int nErrDisp6 = _Map.getInt("ErrDisp6");
//				if ((!nErrDisp6 && _kExecutionLoopCount == 1) || _bOnDebug)
//				{
//					reportMessage (sErrorLocation);
//					reportMessage("\n" + sFamily + T(" |can't be used for the selected beam sizes and connection angle.|" + " --> " + T("|Distance between screw tips and beam edge is too small|")));
//					_Map.setInt("ErrDisp6", 1);
//				}
//				dpErr.draw (sError, ptRef, vecX1, vecY1, 0, 0, _kDeviceX);
//				PropString sArticle	(nStringIndex++, sArticlesError, sArticleName);
//				sArticle.setCategory (sCategoryType);
//				sArticle.set(sError);
//				sArticle.setReadOnly(true);
//				setExecutionLoops (2);
//				return;
//			}	
//			
//			else
//			{
//				_Map.setInt("ErrDisp6", 0);
//			}		
//			
//		}
//		
//		if (!vecX0n.isParallelTo(vecZ1) && !vecX0m.isParallelTo(vecZ1))
//		{
//			int nErrDisp7 = _Map.getInt("ErrDisp7");
//			if ((!nErrDisp7 && _kExecutionLoopCount == 1) || _bOnDebug)
//			{
//				reportMessage (sErrorLocation);
//				reportMessage ("\n" + T("|Limit values are not tested on double tilted connections|"));
//				_Map.setInt("ErrDisp7", 1);
//			}
//
//		}
//		else
//		{
//			_Map.setInt("ErrDisp7", 0);
//		}
//	
//		//lnCheck1.vis(6);
//		//lnCheck2.vis(3);
//		
//	}


	
// define additional properties
	sArticle=PropString (3, sArticles, sArticleName);
	//sArticle.setCategory (sCategoryType);

// get properties by index	
	int nArticle = sArticles.find (sArticle);	

// HSB-20786
//// if artcle index is bigger than available, correct the value	
//	if (nArticle > sArticles.length()-1)
//	{
//		nArticle = nArticleMax;
//		reportNotice("\nXX corected nArticleMax to  " +nArticleMax);
//		sArticle.set(sArticles[nArticleMax]);
//		
//			reportMessage (sErrorLocation);
//			reportMessage("\nXX1" + T("|Connector size was corrected to|") + " " + sArticle);
//		//setExecutionLoops (2);
//		//return;
//	}


// when changing family types we need to ensure that the selected article is valid
	if (nArticle<0)
	{
		if (sArticles.length()>0)
		{
			nArticle = nArticleMax;
			sArticle.set(sArticles[nArticleMax]);	

			reportMessage (sErrorLocation);
			//reportMessage("\nXX2" + T("|Connector size was corrected to|") + " " + sArticle);	
			//setExecutionLoops(2);
			//return;
		}
		else
		{
			if (_kExecutionLoopCount == 1 || (_bOnDebug && _kExecutionLoopCount == 1))
			{
				reportMessage(T("|No articles found for this situation|"));
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
			reportMessage("\n" + T("|No catalog name entered|") + "\n" + T("|catalog entry created automatically with name|") + ": " + sCatName);
		}
		
		else
		{
			setCatalogFromPropValues(sCatName);
			reportMessage("\n" + T("|catalog entry created with name|") + ": " + sCatName);
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
		bm1.addTool(hsFemale);
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
		bm1.addTool(hsFemale);
	}
	
	//bdConnector.vis(6);
	



//----------------------------------------------------------------------------------------------------------------------------------------
// hardware

// declare hardware comps for data export
	HardWrComp hwComps[0];	
	
	String s1 = "HVP " + sArticles[nArticle];
	HardWrComp hw(s1 , 1);	
	hw.setCategory(T("|Connectors|"));
	hw.setManufacturer("Pitzl");
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
	hwNail.setManufacturer("Pitzl");
	hwNail.setModel(dScrewDiam + " x " + dScrewLength);
	hwNail.setMaterial(T("|Steel|"));		
	hwNail.setDescription(T("|Screw|"));
	hwNail.setDScaleX(dScrewLength);
	hwNail.setDScaleY(dScrewDiam);
	hwNail.setDScaleZ(0);	
	hwComps.append(hwNail);		

	_ThisInst.setHardWrComps(hwComps);

	
// map beam cross sections

	_Map.setDouble("H0", _H0);
	_Map.setDouble("W0", _W0);
	_Map.setDouble("H1", _H1);
	_Map.setDouble("W1", _W1);
	//reportMessage ("Ende - Beam 0" + _H0 + _W0 + "    Beam 1 " + _H1 + _W1);
	
//----------------------------------------------------------------------------------------------------------------------------------------
// display

	dpModel.draw(bdConnector);

	dpPlan.draw(bdConnector);
	dpPlan.draw (sArticles[nArticle], bdConnector.ptCen(), vecX1, vecZ1, 0, 0, _kDevice);
	
	
//	if(_bOnDebug)
//	{
//		//dpModel.draw (dX,	 ptRef + vecZ0 * .5 * dY, vecX1, vecY1, 0, 2);
//		//dpModel.draw (dY, ptRef + vecX1 * .5 * dX, -vecY1, vecX1, 0, 2);
//		//dpModel.draw ("Check1 = " + dCheck1, ptRef + vecZ0 * .5 * dY, vecX1, vecY1, 0, 0);
//		dpModel.draw ("Check1 = " + dCheck1, ptRef + vecZ0 * .5 * _H0, vecX1, vecY1, 0, 0);
//		dpModel.draw ("Check2 = " + dCheck2, ptCheck2, vecX1, vecY1, 0, 2);	
// 
//	}

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
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#W^BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**QM:\1VVC3P0/&\LTPR%
M4@8'K4T^KJNARZC%&3L!^1O7.,57)*R?<7,C3HKG]"\0S:M<^5)!'&-A8%2>
MQ'^-=!1*+B[,$[A117)#Q;<MJ]Y9+:Q;;>5DW%CE@#BB,7+8')+<ZVBL?4];
M:QO4MDA#DJK$D]B2./R[UJQ2"6))`"`ZAAGWI.+2N":;L/HHHI#"BBB@`HHK
MAOB+IJ0>'+_5[>]U6WO%";6M]4N(D'S`<(KA!Q[4=0.YHKDKRXMO!)TZ5([Z
MXM=0NH[2XFNM3GG^SELA&"R%^"V%.".HZXXN7'B@Q>)KS1X;,3+9:?\`;;B?
MSL;"2=D>,'DA2<YX'8T-K^OO!)O^OD=#17!6_P`0[V3PS9>)[CP]]GT281F:
M1KS,T0;@N(]F&C!(YW`D9.WU[P$,H92"",@CO3::`6BN0^(%W?6.FV-S&UXN
MDQW0.JM8EA.MO@\J5^8`-M+%?F"Y([UF>#-1?4]8UB?PW?7E[X=6W5(9;^XD
MF'VP=1&TA+[-I7.3C/3O2_K^OZW`]"HKQ:#7)YH['3H-0UQ?B$+I5N;.:XF$
M.0<R%HR?)\G9D@J.F".:[01S^)_&VLV=U?:A!IVE)#%'!9W,EMYDDBEF=GC*
MLV!@!<X'I3L!VM%>9:'XWN=$GN-,U??<Z=9ZO)IKZK/.-T(VJT7F9'S9)*ER
M1T!.<ULR>/F_X1^3Q##I+R:*EZ(OM!FVL;;[K7(7;RH;H,\J-V1TI>G]7M_F
M#33L_P"OZL=I16%H7B:'Q%?Z@-/B\S3;1EB6^#Y2>7G>J#'*K\OS9Y)(QQD[
MM`!117#>.]0DTW5-*GU2XOK?PL1(M[/8R21M',<>69&C(=8_O#(.,D9H`[FB
MO./#UYKE_P"%?$EUX=N;FYLY"QT"6_D,DC';AOF<EBF\';O.?PQ69H>N6VI:
M_H=OX9U#7)=41]VM6VHW$[+%"!B02)*2J/OQMV`<^U-+6W]?TNH/:_\`7]/H
M>M45YO?S6EOXJ\0S>(YO$L%C&T36LMJ^H);)&(AO.Z#Y``<Y)Z<UN7WC33=`
MOK""[>--$N;-I;;5FN_,1W09*$G.24^8-N.[D4NEPMK8ZRBN.;QS);6&BZGJ
M.DM8Z7J4S1O<33X-J#_J6D4KQO'7GY20.:V/#>OCQ)9SW\%JT5AYS):3,W-R
M@X,@&.%+9QR<@`\9Q18#9HHHH`****`"BBB@`HHHH`****`"BBB@`KE_'^M7
MF@^%WOK!U6<3(H+#(P>M=17#_%G_`)$>3_KXC_F:VPZ3JQ3[F=5M4VUV.<LO
M&>NW"J7NASUP@KJ-,\0ZC*^'DCD`&<%<?K6'X!N[+3]$OKJ\C#()U4?)N.2*
MZ"?4;'49XFLX#&5R6;9MR/3%=%914G%1^9$;VNV:%]H]IXB:&Y<M#<0?*2.<
M#T^E4_$MW::-H!TU7WSS\*O?KDL:YWQ#-*NO6OE2R)&8\'8Y`8Y/I^%:5QH5
MA-X>N=1D1VNE+!7,A.,-@=:A0Y>5R>@^:][$/AN:6VN!-&J-\NPAB>Y_^M7<
M6%R]U:^;(JJVYE(4\<$BN*\+0)<W@CD9@HC+8!QR",5D:W#K.GZU>M`UZFGJ
M^5?<=@SU_4TYTU4FU<.9QU/5:\QA_P"1HU?_`*^)?YFM+P_-=7-U`@GE9]X8
MDN3A0>?SZ?C6;#_R-&K_`/7Q+_,U,(<JD@F[V/19[&VNF5YX5=E&`3Z=:LT@
MZ"EKFN;6"BBBD`4444`%<]XXTR\UCPC>V-A#YUS)MV)N"YPP)Y)`KH:*`,/Q
M7HR:[X0U#3)91"9;<[92<"-P,JV?8@&N5\"+>7W@/5O$FIH%O]:62=P,8$:Q
M^7&`>XPN?^!9[Y/?WMG!J%C/9W*EH)XVCD57*DJ1@X(((^H.:9!IMG:Z5'ID
M$"QV4<(@2)2<!`,8SUZ4FM'Y_P!?Y#3U7D>5:%;>(/$/PBT?PXNBA8;NUA1M
M1^T)Y"V_#9*Y$F_`QM"XSSNQT]=1!'&J+]U0`*KZ;IUII&F6VG6,7E6EM&(H
MH]Q;:HZ#)))_$U:JF[LE7LD<EXRT:]U&_P!%OHK(:G96$[27&F[U4S$@!7&\
MA&*'G#$#N#D"LN'PYJNH>)]8UJSL6\.+=Z:UH5=HS+<3DDK,XB9E&W)&=VX_
M@*]!HJ;?UZE7?]>1Y5=>%M1O?!=GX8B\)?8]0MY$*ZLTT!BAE5@6N$8.92S;
M<\H"<X;'-=$ECJ_ASQ;JFIVVFW&L6FJ10EQ;/$DL4L:[>1(Z`JP.>#D'/%=G
M1578NECS1_!FJZC9OIE[:B&WUR_;4-9DCG4^6G&VW4]2QPH+``<-@],RV^C^
M*H/!;^$%LPJK-]ABU-9HP!9=?,VY+!POR8QUP>G->C44M+6Z?U^F@[N]SC_!
M.A7WA.74-`6USH44GGZ;<^:"0K\M$PSNRIR=QZ@^U;-]X4\.:G=O=ZAX?TJ[
MN7QNFN+..1VQP,DC-:]%&^XC-TWP]HFBR22:5H^GV#R#:[6MLD18>A*@9K`U
M[2K]?&NGZ^-,?6+*WMVA2TBDC62VF)SYRB1E0Y'RYW!AVR,X[&BCK<.ECS)/
M!>LW6G^+&T^"/08]8,?V?3_,4;2O#NYB+*AD`P=A/J>3BIKK0;S69_#D=EX3
M;P_)I4\<OVV5[?\`<Q+G=%'Y3L6#9(P0H[GGBO1Z*%I;R_0'K_7<Y_4-6UN-
MKJUMO#%U/)RMO<K<P"!LCY6?<XD49Z@(Q&.-U<?-\.K[5-!TGPA?DIH^GVC2
M2W4<@Q/<L#M5%'S!$))YQGY1SS7J%%*P[ZW//;C2?$OB?PWI7AW7--^RPLVW
M5KE+A")8XS@!`I+`R8![;1D9SBMOP/8ZMHVBMHNIVX$>G2&"SN5=2+B`?<;`
M.5('RD'TSWKIZ*=]_,7D%%%%`!1110`4444`%%%%`!1110`4444`%<+\6O\`
MD2F_Z[I7=5R7Q%TF\UGPQ]DL83+,9E;`]!6V':56+?<SK)NG)+L<1X7MOMNE
M7-N93&/.5P1SSCTKI;:Q^S\^<S8XZ;<UG>&M!U>PBF6:SD7<P(4C@\5OQZ=J
M!/S0,/<@?XUTUIWD[/0QC?L<]KKYU6Q4#"JAQ^=:EY,/^$;NX]Q^\>,_[=5]
M6T34YM5M9$M)'14PS`=#DU8N=*U&72[B-+20LS$@,,<;L_RI75HZE+T*V@2^
M5>QMG'[MOYBHO%NM--+'IL;$8P\HS^0_K^57=,TK489T9K25<(021[BL&Y\*
MZX=8N9C:/(LLF\."#QUJH\CJ<S>PI7MH=1X81+>R\]R%DF`(R?X>W^-8%NV=
M=U=@<_O92#^)K8TO2[J!<7%E*/\`@&:HP:+J*7^HR?89ECE:3R_E]<XJ$U>3
MN%G='<>>`!SDGH!4J%G.%S4%E8R[`9SM_P!D=?SK3551<*`!7(S9)C4C">I/
MJ:?114EA1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!7.^,K'4=0T7R=,#F
MX\P'Y'VG'UKHJ*:=G<B<%.+B^IXY_P`(OXS_`+MU_P"!0_\`BJ/^$7\9_P!V
MZ_\``H?_`!5>QT5I[5]CA_LVG_,_O/'/^$7\9_W;K_P*'_Q5'_"+^,_[MU_X
M%#_XJO8Z*/:OL']FT_YG]YXY_P`(OXS_`+MU_P"!0_\`BJ/^$7\9_P!VZ_\`
M`H?_`!5>QT4>U?8/[-I_S/[SQS_A%_&?]VZ_\"A_\55BQ\*^+&O[<7)N4@,B
M^8QN<X7//0^E>MT4>U?8:RZFG>[^\.U%%%9'H!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`5S5UXFE2XD2&%-BL0"V<G%=*>E>=S
M_P#'Q+_OG^=)C1OP>*N-L]OEB>-AP,58'B:(_P#+LW_?5<E_RT'TJ0_:"-MK
M;F>9CA8PV,_C4<S*44=0WB:-1_Q[-_WW_P#6JL_B:6=B+>(1[?O;N<UA9<HR
MRQF.5#M="<[3Z4RU/SS?44VW8+(ZG3=9GN+Q(9@I5^`0,$5?U+4A8!`$W,W/
M)Z"N=TG_`)"=O_O?TK0\1?ZZ'_=-%W8+:E:3Q+--/Y$2K&P!8GKG_.:IS>+)
M8;^*R:<^=+]T!!68F!K'_;)OYBL>'4-/UO4W@ELXE+,I@N2/WHQV![9'\S23
M;8]+'<'5[Q4+-/@`9/RCI65IOC.74;IH`[(?X"<?-3[FXM8(Q%<3)&)!M`9L
M9K*T_P`.I9:FETDI,<:G8N<DDC&3^M1S%6.T36IOE#1(1W-;2.)(U<=&&17*
M+T%=1:_\>D/^X/Y5<)-[D22):***T("BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BJE[J,%D,/DOC(45S=YKEQ<VL
MTL(^Z#B/W]Z3E8:5SI)M1MX<@ON([+S56'6!).%,85"<9SR*Y/3GU:!TCUA8
MA),GF1^4<@#T..AK1^ZW!^E9RE)%QBF=A1533KG[3:*2?F7Y6JW6B=T0U8**
M**8@HHHH`0]#7GDW,\A_VC_.O0ST->=R_P"M?_>-)C1#_P`M1]*M0NT;AD8J
MPZ$'D55/^M7Z5,L%W=,D-FT2S.<!I>@K+J6A\G1B22S'+$G))]:ALSEIC_M"
MI2)%5HY2IEC8HY3[I(]*CL^DO^__`$JF!K:3_P`A.W_WOZ5H^(_];;_0_P!*
MSM)_Y"<'^]_2M'Q'_K+?Z-_2C[(?:.67_D,)[HP_E5:U\+VMIJ<-S#E8X>57
M<3N;!'.:L]-8@^C?RK,M?%PGUUK-HD6V+^6C\[BV<#\#4-7*O8UM4T>VU)3)
M.KF:-<PNLK((W[,<?>^AJOHWB&VU"=K12Y=!Q(W_`"T]3[5LNH=&0]&!!KF=
M,\+'3];BN4D800@XW-DN2N/PZFES:6"VMSK4Z5U%I_QZ1?[HKETZ?C73V1S9
MQ'_9JZ>Y,R>BBBM3,****`"BBHYYX[>(R2'"C]:`$GGCMHC)*V%'ZUG)KL32
M[6B94_O9K*O+R2\FWMPH^ZOI5-I`HSV%0Y=BU$[9'5T#*05/0BEKE-#UZ-9G
MMI'!0'UY3_ZU=4""`0<@]#5)W):L+1113$%%%%`!1110`4444`%%%%`!115>
MZOK>T&99`#V4<DT`6*AN+N"U7=-(%]!W/X5@WOB9EPEO%MS_`!O_`(5S8U?[
M7J#))<K*QXX8'!J7)="E'N=O:ZQ;W5QY2AE)^Z3WK1KA$D:*174X*G(KM+2X
M6ZM4E7^(<_6B+N$E8Q]?MR)4G'W6&T^QKF(G^S7^PG]W+Q^-=_>6XNK62$]6
M'!]#VK@=0A8HPP1(A_(BD]&-:HYO7KS6K;76E@N([6RBPBE@26.,]/2NOLKA
MKK3H+AUPSH&(^M5X+V,6PO6"AHD.Y]HROKCTK,T;Q?9:O<F".&6+)PA=>&K.
M2?4M61V6D77DW85C\DG'X]JZ.N*4[6(S]*ZRPN?M5HDA^]T;ZU5*7051=2S1
M116ID%%%%`"'H:\[D_UC?4UZ(>AKS=IXFU.*Q$BFZG#-'%GE@HR?TI,I#6/[
MY/H:L1GFJS$>=&>Q4XJQ&>:RZECW`5,`8`[5!9GY)3_M_P!!4\OW":IPW$-M
M`SS2+&KS!`6.`6;``_,TPZFYI/\`R$X/]ZM+Q)]^W^C?TK+TEE_M=(PRLT<N
MQ]K`X..GZUI^)>&MOHW]*?V1;R.5?_D+VWU;_P!!-51X8MO[5ANU$:11/YH5
M5.YGSGDYZ9[5:E_Y"EL?]H_R-4F\5V\>NG3S$?+5BC3%NC9QT]*AJ]BD['1U
M0LM;L+^\EMK:;?)%UXX/T]:NN-\;+G&1C-<3HOAZ[L?$D)5G,5ODRR.F`V5(
M`7UY/\ZD=F=ZG6NFL/\`CQB^E<NI[UT^G?\`'A%]#_,U=/<FIL6J***V,@HH
MJ*XN8K6$RRMA1^M`!<7$=M"9)&PH_6N9O+Y[R7<YPH^ZO85C^*]3OKBQDGM\
MJJ<X!Z#_`!-8OAB\>:WN)03]FD?S!YH;S(VP`5.>".,\>OXUG)FD4=*[@#).
M`.]5HY2\ZR$?NU/`]:A:1KENXC'0>M3+@#'05)5M"2\=;S4X[I+9+<1QF/Y<
M9?GO6MI6LBW=;>=B8S]T_P!W_P"M6!?6DD(M[FVU`2R.VV:U./E'J,=*F@C\
ML;F^9SU]JNS6K)T:T.^1UD0.A!4]"*=6!H-R_GM;DY0KD>U;]4G<AJP4444Q
M!1110`4444`%%%%`!7*:W$\>HNS$E7&5-=76;K5I]HLBZC+Q?,/IWI25T-.S
M.-NXS+;L%)#8X(K-EL;"+2+);2T6*\@;=)<`\OU_^M6P36?*OES,A^ZW(K+8
MT+,$XG@60?Q#D>AKH?#M[MD:U=OO<K]:XVRE,-R]L3@-\R9]>]9_VS4+75;&
M59T>>%]@BA@*YR1DR,>O`.,8'-.]@M?0]FKEO$5GY5T)U'R3#G_>KI+:=;FV
MCF0\.,U#J5H+RQDBQ\V-R?45HU=&:=F><1[4N9;209AG!&/>EBT>QMI!=//*
MLB2;E4,%C``P`1ZT:C$VW>O#H<CV-9VN6+:[IT!62144EF2(\LV,`?G6;5U<
MUV9TY<.@=2"!W%:^A78CN?)9ODEZ?6N1T;3[K25DM+H84;=H$F_''//UK41V
MCDRIPRG(-9[.Y=KJQWU%065R+NTCF'\0Y'H>]3UTG,%%%%`"'H:\5\2:9?3W
M$EU:0V]PQ555)USM.3R.XZU[4WW3]*\[?^M3*W4J)1A1H8;6*0@ND05B.F0*
MO1]:K2_\?$?T-6(NM9=2R67_`%3?2L6]L9K_`$X+`4WI/OPZY4C&,$?C6S*?
MW9^E067^H/\`O&JZ"ZD/@#3KVPG_`--:/?)/E4C3:J@#'2NN\3?>MOHW]*SM
M(_Y"<'^]6CXFZVO_``+^E'V6/>1RLW&HVO\`O_TK,O?"<5UJRS+$JQ-)YLLG
MF-N)W;L`=,?CWK1N#_IUJ?\`IH*M2ZK907T=G)<(MQ(/E2I>R'U+M(LJ,[(K
MJ67[R@\CZTC$[&V_>QQ7GGAY;^U\4Q(\BR22L1.$DW%1M)._T.<5)1Z0G?-=
M1IIS81?C_,URJ'BNHTG_`)!T?U/\ZJEN34V+M%%17%Q':V[S2G"(,FMS$2YN
M8K2!IIFVJ/S/L*\V\1^*KB2],<4:[MI\I7/RY[#CN:T]2O-1UF=/LJIN9BL,
M3-@#C//O6!=V2:S%$+R,Q/$2K*GJ#@\U+U3+2LS1M+J._P!.CDDC(WK^\1UQ
MANX_.H\B4[(U"0KV`QFI8XU$(BCSA5P!33A/E'`%0[V+25R4<#`Z5'),<B./
MESZ5#)*Q<1Q\L?TJ%K^VLWV$EVWJDL@QA-QQS[4)6W!FE;PB(%CR[=35E`SN
M%498\`"H(QYCA8B)"W0H<@_0UUFD:2MF@EE&9C_X[5;DNR)-)TW[%&9)/]:X
MY]AZ5I457NKV&T`\QOF/11UJMB-66**J6NHP73;%)5NP;O5NG>X@HHHH`***
M*`"BBB@`I"`001D'K2T4`><^))+K2]7$$%F]Q%)&SC;($(]#D]AGGZUG65T^
MI:;YC[?/B8JY7H2.N*[KQ/I$&IV`>6(.T)R,CM7*P6\5M"(H8U2,=%%9M&D7
M=&3=$[4N$^^AS6G'*LL2RIC##(JG/&(Y6CQ\K]*AT^79));-_#\RU**.W\,7
MV6DLW/\`M)_45TM><6URUK=1SH>4.:]#@F2XMXYD.5=0PK2+,Y;G'^)+'R+X
MR`?NIQN'L>_^?>N:LY#;W4EN?NM\R_6O2-:LOMVFR*HS(GSI]1VKS2^0@K*G
MWXSFE:SL4G=&=>ZYJD&KLB01K9HVW=(<%R`"<5T\,PFMXIAP&4'\ZJV]Q`B-
M>M'$P,1!,JA@H[U5TK7=,U3=%9SJVWY<8QT]*S:-$SM?#M[LF:U8_*_S)]?_
M`-7\JZ6O.X)WAE5U.)$.17?VMPMU;1SI]UUS]*NF]+&=1:W):***T,Q'^XWT
MKQ+Q#?W5AJT=XCWD:VZ`QFW0.&+9#!E;@_TKVQ_]6WT->=S0QRIMD0,IQD$5
M,BHF=!*\T%E+(I5Y(59E;J"1R#5^(\U7GXN8OH:FC/S5CU-":<XB/TK!U62X
M33(3`9U_TC<S0??&,D8SP>0.*W)_]0?I4-IC[(O`^\?YU?074C\`ZC=:G*+B
MY^TEC<D!K@`,W`SP.`,YXKK_`!1TM?JW]*R-%54U"V5%"C?T%:WBKA+7ZM_2
MC[+#[2.2NCB[MO\`KHO\ZYGQ!HET^KRW$#RO/,X\H"%F5>,#+#@=#^7O71WA
M_P!(MC_TT7^=:RMSS4/9%=1RY"`$Y..331%$LIE6-!(1@L!R:&<*I)Z"N,T#
MQJVJZTUO(8O)E.(@O53@G!]>!2M<=[';J<5U6CG.FQ_4_P`ZY-3G-=3HG_(-
M7_>-.E\0JGPFC5'5[1KW3)H4^^1E?J*O45T&!YBSRPMY9WHRMG&<$&HGN4B7
M?(P4$]^YKMM>T)=0C,\`"W"C_OJO/-8T]WM`T<A6]BD^5#_#BIUM9&B<=R_;
MW,=Q"L\+;D;[K?CBG."YR&Q67I=JUK:D.BI([%V5"2`3U_/K^-:(5KC=!'($
M<J<'/-)793TU'1>7&Q56!?J><FLZ]T.2\U=);*9H58;77&[>.X(/%4M)@O7U
M;:(Y(W4>49(\8E7.0&R.>>:]4T31%L8Q-.-UP1_WS0M;IH3=M0T/0X].@1G4
M>:%`4?W!6U15#4=3CL8\##3$?*O^-5HD9ZMC[_4([*/LTI'RK_4^U<I?*UY;
M7-RVI&"Z5<Q)Q\Q]#FF7%T69IIFRQY)-5(86OY!+*,0C[J_WJFZ>KV+Y6EIN
M/M;B0HEW<RB"-`#NS@$_X5UFCZQ!J$.$F23'&Y3G-<+XFM#<6L<>Q^YB:,D[
M6'JOH15OPCI<VG6#O,ACFF8.4SRO_P!>IY@<3T6BJ=E=^:H1_OC]:N5HG<AJ
MP4444Q!1110`4444`(P#*5(R",&N'U*U-G>21GIG*_2NYK#\2V@>R^U*/FA&
M6Q_=J9+0J+LSC;V+?#N7[R<BL:XD,<D=R@Y4_-5F'Q!!<W$<26]U&A4!Y)HM
MB[ST5<_>^HIES"(Y7C/W6Y6LS4MR7DD1B:"TBNO,4X66?REZ<'.#71^`-:>]
MM)K"XD22:W/WT&%;/4#Z&N/L&26%[290_EG@-Z5K:;.--O(IH4"A&Y51C([B
MJ6]R&M#TVN!\1Z<+34'VC$4OS+^/45W<<BS1)(ARC@,#ZBLOQ%8_;-,9E&9(
MOG7Z=_\`/M525T3%V9YG`BN)]/FY20'`]NXJQ;:+;6IAN(YV$P=BT00!%'08
M/7TJ&]5D=9T^\AS5;6[>\U2VMUL[B6)6/(A^\[9&!]*B6NIHM#?9OXL]>#72
M^%K[[]FY_P!N/^HKBM.BO+>.:SO1)YD3;09"">F1R.M7[2[:UN8YD^]&V?K4
M)V=RVN96/3**C@F2XMXYHSE74$5)70<PV3_5M]#7DFKZY)8:I;VT44,B8#3"
M67RSM.0-IY&0>3QT_.O6Y/\`5/\`[IKR_5M!M-55_.3]XR!`V.@S_P#KJ)EQ
M(OM*W7V.="-LL>X;6R.<=^]6T^]56:WCLWL;>%0L<:;%'H`!5E/OBL7N:=":
MYXMS]*QKS56TS3[4QQ1RO(Y^223RP5!RWS8.#CI6Q=_\>Q^E9XLK:^L(%N8]
MZKDXJ^@C3\+:BFHW<,JA`5G*,$DW@$=MPZ\$5T7BWB*U/^TW]*YKPMIL&DW%
MG:VRA4\W<<>IKH_%_P#Q[VI_VS_2C[+%]I'&WS?O;<_]-!_.L7Q#XIN]-UN.
MVMPHAB`:8M&2&!&>O0=JUM1.TP'_`&ZLW^F0ZC&RR2RQD@8,9`^N<CG(XJ>B
M*M=E^WG2ZM(YU^[*BN`?0C-9L>A0IJL5ZTSR>4#LC95PAY&1@`]#CG-:$:+%
M$L:#:B*%4#L!445];3W$D$4Z/+']]5/(I%%R-NM=7H)SIO\`P,_TKD`<_G76
M^'CG33_UT/\`(447[PJGPFK11172<X5A:]H":@AG@&VY4?@U;M%`T['E7^HN
M-DR$%6PRGK5B[2TO!;BVM]MW'(?WB=9%/8BNUU7P]:ZH_FY,4P_C4=?K2Z5X
M>M=+?S%+2R]G?M22L4Y)D6A:$MA&)YQNN&'?^'_Z];E%9.K:PEDABB(:<C_O
MFC9$ZMC]4U5+%-B$-,>@]/K7(W%V=S2S/DGDDU'/<%B\LC$L>235&W3^T'\^
M7BW4\+_>_P#K5%[FB5BS!&]\XED!$(^ZO]ZLCQ7]HW*(Y98Q&`?)Q@,IXW*>
MYR.G^3%J&OZG:ZDD,440B;!C`^8./KZU=\1ZK<6?E2V\$+;<*TC`,R'KC'85
M+=]AI$K'4+3PO!`MPT5U("0[@DXZ[0>QI_@F>^N$N9;B=Y(`<#><X;OS6CI;
MMK.B0/J$*L6;=M[9&0#6K'!''"((8U2-1]U1@5+>MAVT)(;N.27$,RED/.T\
MBNBMI?.@5R,$]:Y6.QGU#Q#%=QVRVL<41C;:?OY]:ZR*,0Q*B]!6D$TR)M6'
MT445H9A1110`4444`%-DC66)HW&588(IU%`'EM_X>CM-542S3R+;MF%'D)51
MVX_K3-0CWP;Q]Y.?PKM/$]EO@6[0?,G#8]*Y(].>16;[&L6<^TA@N([@=.C?
M2MK<"N5[\BLBZB$<DD1'RG[M6-,N"]N8F/SQ''U':DBF>@^%-0\ZT:T<_/$<
MK[J:Z+J,&O)-/\0OI^IVUPMC<Q6REA/--A5;YL`)S\V>M>LHZR(KJ<JPR"*N
M+N926IYUXAT[['?RQ`?NW^9/I6'8RF.1K=CR#E:]&\4Z?]KTWSD'[R'GZCO7
MG)TB^U6Y86$8+0+YDCE]NT?UZ4GIH4G?4O9.<]R<YID<=Y<W$B6=H]P47>Y!
M`"C_`!JD!>HQCGD7CJ0.:T["_DL=YBR-R[20<<5FUK9FE]+HZOPG?L8FL9LJ
MZ?,@/H>HKIZ\]T&"[EU6&6WB*HK98X.`.]>A5LO(QEN,E_U,G^Z:\YO]7L--
MDMX[VX6%IVVINS@GW]/QKT:;_42?[I_E7D/B31+R^G:]M+@QRQQ*$^4-R&)Z
M'ZU,[]"H;&AJ+JUS9LA!4@D$=^E+"Q,F*H-!-:6NDP7$OF31Q;7<]S@5<A;]
MZ*Q9JD6K[BT;Z5GF_M-/TV&6[G6&-CM#,#C)/%7]2;%DQ]JPKW2IM5L[1()_
M*94;TQS]>/\`]=6M42]SIM"N(KG4K*6%P\;/PP[]:W?&'_'I;GT<UR/@>TO+
M2>V2^F,MPTQ=F(QU[8[5UWC(XL(#_MG^5&O([B=N=6.%U4_+%[-6MO5`-S`9
M.!DXS6+JCYC0^C"L+Q?:7EU?12I>1V]M`H<!L\MDY)]A\OYU/V45U.Y?)1L'
M!QP:X+0]"O-(\2VQ669_-!:9Y82H90I&5/3&[C\O;/7:1/--I5K)<#$K1`MS
MG\:N,V['/3]*FX]R6,YW?6NL\-G.GR#TE/\`(5QT;XSSU-=;X7;.G2_]=3_(
M44OB%4^$W****ZCG"BBB@`HHHH`RM;U7^SX5CC_UTG0_W1ZURFIV<T-O#>K=
M+,TDFV2+'(![YK=\46$DJQW<8+!!AP.P]:Y<$MU.2?6HDUU-(I]"&]5VM7"Y
MR1Q5C1V"Z=;%1T4=?7O^M."ADP138(S;.VP9C8Y*^E97L:V)%TBU>_-XZEG+
MM(J=%0DY)`J>]TBVU*=9)\X"!&5<`.`21GUZU-'*F.IS]*F!)^E*X6)HHTBB
M6.-0J*,`#M5JUMWN)=JC@=6]*;9VLERP51@#[S>E=!#"D$81!@#]:<(-N[)E
M*RL$,*01[4'U/K4E%%=!@%%%%`!1110`4444`%%%%`#)HEG@>)QE7&"*\PUB
M>UT:YEBO[N*V$>XAI3C<!Z>I]AS7J5<7XYTB280ZC;^4)$'ER>9&&&#T-3)%
M1=F<?,\=]91W,.2,`C((.#STJG`S0WJ.!\LGRM5G3X_L8DBDNA/.[EV)QGGV
MJV74\;%&.X%2EW-+WV*5W;VORRS":7:P\N(,6&[V6O1_"6H27&GFUN(Y(IH.
M-DB[6V]N*X2)U29)'!.TY!!Y![$5K:1J,J:_#*DL\QF<+(9",MGCH../:JBT
M3)'HS*'4JPRI&"*\YU*.;1=4GBCR$?H02,J:]'J"XLK6[*FX@CE*_=++G%-J
MY"=CS2QTB^U.3_1X"5SRYX4?C77:;X0MK;#W;^>_]T<**Z-55%"JH51T`&`*
M6DHHIS;&QQI$@2-%11T"C`IU%%401W'_`![2_P"X?Y5P9<YKNKLXLYCZ(?Y5
MXKXLEOFEC6W^TK!"HE8V\A1B<^H]A^M1,T@[&SK)_P!*L_J?Z4V-OG!S6:UW
M)=V.ESRHR.^058Y/7N?7`JTK8:L7N:K:YH:G)_H+<U7M)#LB'HHJ/49<V9`/
M>N?UB2],$$=I]H`">8S02%&R,8Y';KWK2VAG?4[O1G)UZ`?[8K<\:G&FP_\`
M73'Z5Q7@:[EN[FRDF1T;S=H$C;F(!P"3W.*[+QT=NDP?]=?Z&BWN,/M(X'43
MF)?J*U(9<I*G59%*.#_$IZ@UBWS_`+D?45?ADJ;>Z.^I>\P*>.F.U+ORE5"]
M.#<5-B[D\;#YAGO78>$FS8S@?\],_H*X>,Y+_6NS\&-FSNAZ2#^5%->\*I\)
MTU%%%=)SA1110`4444`!`(P1D&N2UO0S;%KJU7,)Y=!_!_\`6KK:0@$8(R#2
M:N-.QYTG2ITP!DUJ:QHQM6:XMUS"3EE'\/\`]:J-H\$<H>>/S47G9ZUERZV-
M^96N$>&Y&,>U:-C9274@`&%'WF-5M,TK[1?W$L"F*TD<.$/1/4#ZUUT,201B
M.,844U3UU(<]-!(84@C$<8P!^M2445J9!1110`4444`%%%%`!1110`4444`%
M0W=LEW:2V\@^612#4U%`'E3V@TN&:QV6I<3EWD9#YOT!]/Z&J@!9@J@ECT`%
M>AZMX8M]5NQ<&5HG(`;:,[JN:?HECIJCR809.\C<FIMI8M22U..TWPI>WN'G
M_<1'^]U/X5U^FZ%8Z6`T,>9/^>C<FM.BFE8ER;"BBBF(****`"BBB@""]XL+
M@_\`3-OY5YLS!@Z$`JXVL,=J]'U$XTVZ/_3)OY5XSKNNG2E18HTDF<%@';:H
M4$9)/XU,M-2EKH6M6`$EH$&%5L`#M3,,#DMS4D5U#J%I'.A5XW[HV0"#@X/?
MD4YXHR<ACCWK/E;=T6I65F5+J4M!MS4UK.8<$8Y0*?Q%1SPAAA7^O%96JZI_
M9J($1'8D</)L"CIG.*TO9$[LZSPT1_;UJ%P%\T8%=/\`$`XT:W/_`$WQ_P".
MFN,\(74=UK%A-$P9'D&"#GOS79?$(XT.W/\`T\C_`-!:EN@VD>=WCXM@3T!R
M:MV[\]>U4IT\VV*YZBH+*]^SA8KD%=HP'`R".U*V@^IME^13U))K/^WVV?\`
M6_\`CIJ5;U&!\K+$]#C`%9M%(G5SO;TW8KMO!#9@O`.S+_(UPL8(7DY)/-=M
MX%;*7P]T_P#9J*:M(<W>)U]%%%=!@%%%%`!1110`4444`(0&4@C(/45E-X?M
M&FW@NJDYV@\5K44FDQIM;#(HHX(Q'&H51V%/HHIB"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`*FI_\@J\_P"N+_R-
M>1WD=B8IIKX958F4'&<'M7L-Y"UQ93PJ<-)&R@_45YN=!OTE*S:>TJ#@J1D&
MDP1A6]J-.LXK5;>2$*N0CKM//.:>9?E]*ORZ'JVQ8Q;WDJ1_+'YK%RJ]ER><
M"H_["U0#!L9_^^:+#N9V[)S4*VEI?"Z-U;2RQ)&59TC+*A/3)[5I?V)JF?\`
MCQG_`.^#4ZV.J0VXCALKV)MWSA-P24=MR]Z.H7*WA"&*UUK3X(5"QK*,`#U-
M=K\1?^0#!_U\C_T%JP/#.AZ@-;MI9+62-(G#NSK@<5VGBC1I-;TG[/"RK*CB
M1-W0D`C!_.AK0$]3RZS2!Y8ENB?(+@R`'&5SR,T:PFF-?/\`V7`T4.?N,<CH
M.1Z=ZW6\$ZPT14)"#CN__P!:HAX#US_IW_[^'_"I295T<VL2]2!6CI<=I]MA
M^V*&MPV70]&'H:UE\":WW-M_W\/^%2KX%UD?QVW_`'V?\*3BRN9&;=_8DO)A
M80^3`7)5`V0/IZ?_`%ZZSP+C-\!_L?\`LU9:>!]6&,O;?]]G_"NI\-Z')HT,
MQFD5I92,A>@`S_C32;E<FZ2L;E%%%60%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%-D<1QLYZ*,UA7/B3[,R%H05
M=MHP>E`&_16$WB-0F[R./K5W3]2%X2C*%?J`*`-"BLZ_U6.SN8;?&9)3Q[5B
M:MX^TG1+I;>]G596YVCG`]Z`.LHK,M]8BN(XID*M%(,JRGJ*T^HR*`L%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`5[XXL9SZ(:\_U
MASY,!)QB0&N]U-MFFW#>B&O*;G7H+B62(6\[00D!YE3*J:0S9>?,:+[]ZW]"
MD#ZDF/0_RKB[O4%L_+!5YI'/R1QC)8UT'@V_6]U0X5D=%8/&ZX93[T(&2^*)
M_+\16GL1^M<GKWA^[OKZZNHHK:5&PQ#_`'GXQM%;OCHRC5%DB^_&`P'K5"UU
MN"9%+.4<=4;M2TN-7L:^AP2:?I%G:.?G0<\].^*[U/\`5K]!7GUM>>=(I&0H
M/7UKT&/_`%:_04T)CJ***8@HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`*.L\:/=?]<S7D]Y+/IFFWD%O(/L]U@/'CDGV->NZA;M=V$T"G#.
MA`S7F^H>&=3N(W@:TE/HR\\^U%QF%:ZHWVRQEBAF@O(EW'SH_E!QT'K76^#3
M+/XCN;N=@T\X+N5&!TQ7.1^%M<2Y$D\%U,4&(\KG`KM/!^C7EI<27=W$8OEV
MJK=30);&=XEM3J/BR.R:[^RQ.F6E[_05RWE?9+J\M_,2Y\A\1S`??XKMO%7A
MV[O[_P"TP1"9&7!4'D$5A)X:U./A;%POTJ6BT1-;3Z7-IDHU%+I;L@/%@#9]
M*]4C_P!4GT%>?Z?X:OOMD326OEA3]XCH*]!`PH'H*?H2Q:***8@HHHH`****
M`"BBB@`HHHH`****`"H+N]MK"`SW<Z0Q`X+.<"I)I4@A>61@J(,L2>@KQ7Q?
MXF?Q!J&(B5LX21&O][_:-<F+Q4</"_4[<%@Y8J=MDMV>E3^.?#T'6^#\X_=J
M6_E6MI>JVFLV*WEE)YD+$@'&#D>U?-^K326L:Q%'1I%W`D8X]J]'^#.K^9:W
MFE.WS)^^09R?0_\`LH_`UAA,74JRM45KGH8S*H4<.ZM-MM?D=UXM\36WA+09
M=4NHWD56"*B=2QX%8OPU\67OC#2;W4;Q4CQ<%(XT'"KC]36=\;O^2>R?]?$?
M\ZY'X3>-=`\,>$[F+5;]89GN2RQ@$L1@<X%>NHWA?J?.2G:I9['NM%<1I?Q9
M\(:M=);1:@T4CG">?&4!/U-=A=7EM96DEU=3I%;QKN:1VPH'UK-Q:=F:J2>J
M)Z*\]O/C1X0M9C&ES//CJT<1*_G6EH/Q.\,>(;R*SL[QUN93A(Y8RI8^U-PD
MNA*G%NR9SOQ`^*,F@ZPF@Z7#_IA9!+.X^5`2.`.YQ7J"$E%)[BOF;XI,%^*T
MS,<`/$2?RKU^X^+W@ZRF6W;4'D8<%HHBRC\15N%TK&<:GO/F9WE%96A^(])\
M1VIN-*O([A%^\%/*_45H3W$-K'YDTBHOJ365K&R:>J):*QV\2Z>&P&<^^VKM
MGJ-O?1/)"Q*I][(QB@9;HK&?Q+8*V%,C8]%J>UUVQNI!&LA5ST#C%`&E12,R
MHI9B`HZDUF2>(=.C;;YQ;'=5R*`&ZQJ<ME+;PQ*-TIY8]AFM:N2UB^M[Z\LG
MMWW`'GU'(KK:`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`\H^)/C`)=/HL<A1(\&;`Y<]A]*R_`&AP
M>)=0>>8$V=MAG!&-Y/0?3@_E4?Q1\/7"^*7U%8Y6MYHU)8+P&Z8S7)V>I7FF
MH5L[N6W7OY;E:\*ORK$<U2[L?886@IX%1H.S:W\^IZ-\7_#T;6%GJENBJT)$
M#`=U/3VKBOAY<76F^+[21$8H[!'4=P>#T]`2?PJ.?QAK&O:9_9U],9E60.I[
M_3WKU3X?^#UT>U74KR,_;)5^0-P8U/MZG]/SK=7JU_W:LC&<G@\"Z5=W;ND4
MOC=_R3V3_KXC_G7`_"CX=:3XITZ?4]4:5UCE\M85.`>AR37??&[_`))[)_U\
M1_SJC\!O^1/O/^OH_P`A7N1;5/0^-DDZR3['`_%WP7I?A*\L)-)62..Y5MT9
M;.T@]CU[_I6_X\U"_NO@IX>F,CL)75+A@3RJ[@,_B!4G[0771?\`MI_2NMT,
M:(WP>TU/$&S^SGBVR%^@)<X_6JO[J;(M[\HK0\Z\"Q_#1O#L;:^R?VEN(E$S
M$`<\8QVKN?#/AOX>7VNV^H>'+Q/MEI('\J.7.<>QY[UDI\-/AQ=`RP:X3&3D
M8N5KS>U6+P_\3H8?#]XUS#%=HL,BG[XXX]^I%.RE>UP3<&KI%_XK1B;XI7$3
M=',2G\<5ZLOP4\)FP\OR[KS63`E,O(..O3%>5?%1UB^*D\CL%1&B9B>P&*]X
ME\>>&+;3&NSK-JZ(F<(^23Z`>M3)R458J"BY2YCPOP'/<^%/BS'I:SDQ-<M:
M2*/NN"<`_P!:]PNU.K>)!:NQ\F+C`_6O#?!"3>*?B[%J,<!\O[6UTW^RH.1G
M]/SKW*5QIOBDS2\12?Q>Q&*57<JALSH8["TB0*MO%@>J@T^.WAA5Q'&B*WWL
M#&:D5E=0RL"#W%9VN2LFD3F,_-C!P>@K$W(GO]&M3Y?[GCJ%3-8VN7&G7$<<
MMF5$P;G:,<5?T&PL9=.662-))23NW=JK>(X;&"&-;=8UF+<A3SBF`_6KF62R
ML;8-CSE!8^M;%MI%G;PJGD(QQRS#)-8>L(R6NFW0&510#_.NFM[B.YA66)@R
ML,\=J`.:UVU@MM0L_)B5-Y^;:.O-=57->)"/[0L1[_U%=+0`4444@"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@!DL4<\;1RQJZ,,%6&0:XC7OA?I6JEGLY&L9&^]L7<OY=J[JBLZE*%16DC:
MCB*M"7-3E8\^\-?"RST+4Q>SWC7>S!1&CV@$=SSS7H-%%.G3C35HA7Q%2O+F
MJ.[.?\8^%HO&&@MI4UR]NC2*^]%!/!]ZA\$>#H?!6E2V$%W)<K)+YFYU"D<=
M.*Z:BM.9VL<_*K\W4XSQW\/K?QR;,SW\MJ+;=C8@;=G'K]*M2^![*Y\#0^%K
MFXF>VC4#S5PK'#;JZFBGS.U@Y(WN>-3?L_6)?,.N3JOHT(/]:Z;PG\)=$\+W
MZ7YEDO;N/_5M*``A]0/6N_HINI)Z7)5*"=TCS_Q5\)M(\5:M+J<UW<P7,@`.
MS!7CVKG1^S_IGF`G6[HKGE?)7_&O8J*%4DE9,'2@W=HY[PMX+T;PA;/'IEOB
M23'F3/R[_CZ5KWMA;W\6R=<XZ,.HJU14MMZLM))61@?\(T5.([^95]*T++2T
MM;:6%Y7G67[V^K]%(9A-X9B#DPW4T2G^$4X^&;0P,A>0R'_EH3R/PK;HH`K&
MRBDL5M91OC"A>?:LK_A&@C'R+V:-2>@K>HH`PXO#4*S+)+<RRE3D9K<HHH`_
"_]DL
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
        <int nm="BreakPoint" vl="817" />
        <int nm="BreakPoint" vl="448" />
        <int nm="BreakPoint" vl="1145" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20786 article selection fixed" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="11/30/2023 9:50:13 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End