#Version 8
#BeginDescription
#Versions
Version 2.9 04.07.2023 HSB-19431 depth slot corrected

Version 2.8 06.07.2022 HSB-15932: set hardware qty to 0 if dummy male beam
Version 2.7   21.12.2021   HSB-14106 display published for hsbMake and hsbShare
Version 2.6   30.06.2021   HSB-12460 instance will be assigned to I-Layer of female beam
version value="2.5" date="29apr2021" author="nils.gregor@hsbCAD.com"> HSB-11734 Bugfix peg length


This tsl creates a Simpson StrongTie connector of BT families






#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 9
#KeyWords Connector;Fixture;BMF;StrongTie;Simpson,Hanger
#BeginContents
/// <History>//region
/// #Versions:
// 2.9 04.07.2023 HSB-19431 depth slot corrected , Author Thorsten Huck
// 2.8 06.07.2022 HSB-15932: set hardware qty to 0 if dummy male beam Author: Marsel Nakuci
// 2.7 21.12.2021 HSB-14106 display published for hsbMake and hsbShare , Author Thorsten Huck
// 2.6 30.06.2021 HSB-12460 instance will be assigned to I-Layer of female beam , Author Thorsten Huck
/// <version value="2.5" date="29apr2021" author="nils.gregor@hsbCAD.com"> HSB-11734 Bugfix peg length</version>
/// <version value="2.4" date="04nov2020" author="geoffroy.cenni@hsbCAD.com"> HSB-9480 TU values were listed with comma decimal separators instead of point </version>
/// <version value="2.3" date="30sep2020" author="thorsten.huck@hsbCAD.com"> HSB-9036 peg length fixed when height and width swapped </version>
/// <version value="2.2" date="16sep2020" author="geoffroy.cenni@hsbCAD.com"> HSB-8198 Add Jane-TU </version>
/// <version value="2.1" date="28jul2020" author="thorsten.huck@hsbCAD.com"> HSB-8422 additionalNotes considered for posnum generation </version>
/// <version value="2.0" date="02Jul2020" author="thorsten.huck@hsbCAD.com"> HSB-8182 badge alignment corrected</version>
/// <version value="1.9" date="02Jul2020" author="thorsten.huck@hsbCAD.com"> HSB-8182 hardware properties reordered, notes supports tokenized entries of <Mounting>;<PosNum>;<TSL Notes> </version>
/// <version value="1.8" date="01Jul2020" author="thorsten.huck@hsbCAD.com"> HSB-8182 Hardware type set to TSL, HSB-8183 new custom commands to set mounting and to show/hide a badge in planview </version>
/// <version value="1.7" date=07jan2020" author="thorsten.huck@hsbcad.com"> HSB-6302 automatic model assignment fixed on joist connections </version>
/// <version value="1.6" date=22nov2019" author="david.rueda@hsbcad.com"> Added support for double metalparts when is post&beam, fixed marking not properly done for double metalpart  </version>
/// <version value="1.5" date=21nov2019" author="david.rueda@hsbcad.com"> Support for post/beam added. Removed duplicated instance present when TSL is inserted and no model could be found. Reset to latest valid family when TSL is already inserted and no model could be found</version>
/// <version value="1.4" date=20nov2019" author="david.rueda@hsbcad.com"> Property <Drill Alignment> + DoubleClick Cycle added (removed of all uses of _Map for storing state)>  </version>
/// <version value="1.3" date=18nov2019" author="david.rueda@hsbcad.com"> Slot vectors corrected for angled connections  </version>
/// <version value="1.2" date="05Jun2018" author="nils.gregor@hsbcad.com"> Corrected dimensions, corrected BT4-90 and BTN-90 added marking fastener on beam </version>
/// <version value="1.1" date="04May2018" author="nils.gregor@hsbcad.com"> Corrected boltholes of BTC, dimensions and the behavior if housing is in female beam </version>
/// <version value="1.0" date="04Oct2017" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select beams, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates a Simpson StrongTie connector of BT families

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "Simpson StrongTie BT")) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "Simpson StrongTie BT" "BT")) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "Simpson StrongTie BT" "BTC")) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "Simpson StrongTie BT" "BTALU")) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "Simpson StrongTie BT" "BTN")) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "Simpson StrongTie BT" "BT4")) TSLCONTENT

// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "..|Hide Badge|") (_TM "|Select connector|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "..|Show Badge|") (_TM "|Select connector|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "..|Drill not through|") (_TM "|Select connector|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "..|Flip Drill Face|") (_TM "|Select connector|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "..|Cycle Drill Face|") (_TM "|Select connector|"))) TSLCONTENT

// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "..|Partial Assembly Plant|") (_TM "|Select connector|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "..|Plant|") (_TM "|Select connector|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "..|Construction Site|") (_TM "|Select connector|"))) TSLCONTENT

/// </summary>//endregion

//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	// read a potential mapObject defined by hsbDebugController
	{ 
		MapObject mo("hsbTSLDev" ,"hsbTSLDebugController");
		if (mo.bIsValid()){Map m = mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug = true;	break;}}
		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());		
	}
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	
// mounting	
	String sMountings[] ={ T("|Partial Assembly Plant|"), T("|Plant|"), T("|Construction Site|")};
	String sMountingProduction = sMountings[1];
	String sMountingOnSite = sMountings[2];	
//end Constants//endregion

//region Lists
		
// families
	String sFamilies[] ={ "BT", "BT4", "BTALU", "BTC", "BTN", "TU" };
	String sURLs[] =
	{
		"http://www.strongtie.de/products/detail/balkentrager/809",
		"http://www.strongtie.de/products/detail/balkentrager/886",
		"http://www.strongtie.de/products/detail/balkentrager-alu/481",
		"http://www.strongtie.de/products/detail/balkentrager/497",
		"http://www.strongtie.de/products/detail/balkentrager/482",
		"https://www.strongtie.de/products/detail/balkentrager-tu/57"
	};
	double dXDrillAs[] ={U(30),U(30),U(30),U(30),U(30),U(30)};
	double dZDrillAs[] ={U(20),U(20),U(20),U(20),U(20),U(20)};
	double dZInterAs[] ={U(30),U(30),U(30),U(30),U(30),U(30)};
	double dSlotplateVerticalOffsets[] ={U(20),U(20),U(20),U(20),U(20),U(13.8)};	
	double dSlotplateHorizontalOffsets[] ={U(86),U(86),U(86),U(111),U(86),U(68)};
	double dSlotplateVerticalInterdistances[] ={U(40),U(40),U(40),U(40),U(40),U(40)}; // vertical interdistance slot plate
	int bCanBeAngleds[] ={0,0,0,0,0,1}; // vertical interdistance slot plate
	
// strongtie data
	// BT
	String sModels0[] ={"BT280","BT320","BT360","BT400","BT440","BT480","BT520","BT560","BT600"};
	double dMinH0[] ={U(320),U(360),U(400),U(440),U(480),U(520),U(560),U(600),U(640) };
	double dA0[] ={U(280),U(320),U(360),U(400),U(440),U(480),U(520),U(560),U(600) };
	double dB0[] ={ U(103),U(103),U(103),U(103),U(103),U(103),U(103),U(103),U(103)};
	double dC0[] ={U(62),U(62),U(62),U(62),U(62),U(62),U(62),U(62),U(62) };
	double dT0[] ={U(3),U(3),U(3),U(3),U(3),U(3),U(3),U(3),U(3)};
	double dDiamA0[] ={ U(5),U(5),U(5),U(5),U(5),U(5),U(5),U(5),U(5)};
	int nDiamA0[] ={52,60,68,76,84,92,100,108,116 };	
	double dDiamB0[] ={U(13),U(13),U(13),U(13),U(13),U(13),U(13),U(13),U(13) };
	int nDiamB0[] ={ 7,8,9,10,11,12,13,14,15};	

	// BT4
	String sModels1[] ={"BT4-90","BT4-120","BT4-160","BT4-200","BT4-240"};
	double dMinH1[] ={U(100),U(160),U(200),U(240),U(280)};
	double dA1[] ={U(90),U(120),U(160),U(200),U(240)};
	double dB1[] ={U(103),U(103),U(103),U(103),U(103)};
	double dC1[] ={U(61),U(61),U(61),U(61),U(61)};
	double dT1[] ={U(3),U(3),U(3),U(3),U(3),U(3)};
	double dDiamA1[] ={ U(5),U(5),U(5),U(5),U(5),U(5),U(5)};
	int nDiamA1[] ={16,20,28,36,44};	
	double dDiamB1[] ={U(8,5),U(13),U(13),U(13),U(13)};
	int nDiamB1[] ={4,3,4,5,6};	// amount is set to 2 instead of 4 because the bolts are in two rows with 2 pieces

	// BTALU
	String sModels2[] ={"BTALU90","BTALU120","BTALU160","BTALU200","BTALU240","BTALU1200","BTALU3000"};
	double dMinH2[] ={U(100),U(160),U(200),U(240),U(280),U(0),U(0)};
	double dA2[] ={U(86),U(116),U(156),U(196),U(236),U(1180),U(3000)};
	double dB2[] ={U(109),U(109),U(109),U(109),U(109),U(109),U(109)};
	double dC2[] ={U(62),U(62),U(62),U(62),U(62),U(62),U(62)};
	double dT2[] ={U(3),U(3),U(3),U(3),U(3),U(3),U(3)};
	double dDiamA2[] ={ U(5),U(5),U(5),U(5),U(5),U(5),U(5)};
	int nDiamA2[] ={16,20,28,36,44,0,0};	
	double dDiamB2[] ={U(8),U(12),U(12),U(12),U(12),U(0),U(0)};
	int nDiamB2[] ={4,3,4,5,6,0,0};	

	// BTC
	String sModels3[] ={"BTC120","BTC160","BTC200","BTC240","BTC280","BTC320","BTC360","BTC400","BTC440","BTC480","BTC520","BTC560","BTC600"};
	double dMinH3[] ={U(160),U(200),U(240),U(280),U(320),U(360),U(400),U(440),U(480),U(520),U(560),U(600),U(640)};
	double dA3[] ={U(120),U(160),U(200),U(240),U(280),U(320),U(360),U(400),U(440),U(480),U(520),U(560),U(600)};
	double dB3[] ={U(128),U(128),U(128),U(128),U(128),U(128),U(128),U(128),U(128),U(128),U(128),U(128),U(128)};
	double dC3[] ={U(96),U(96),U(96),U(96),U(96),U(96),U(96),U(96),U(96),U(96),U(96),U(96),U(96)};
	double dT3[] ={U(3),U(3),U(3),U(3),U(3),U(3),U(3),U(3),U(3),U(3),U(3),U(3),U(3)};
	double dDiamA3[] ={U(14),U(14),U(14),U(14),U(14),U(14),U(14),U(14),U(14),U(14),U(14),U(14),U(14) };
	int nDiamA3[] ={2,4,4,4,6,6,6,8,8,8,8,8,8};	
	double dDiamB3[] ={U(13),U(13),U(13),U(13),U(13),U(13),U(13),U(13),U(13),U(13),U(13),U(13),U(13)};
	int nDiamB3[] ={3,4,5,6,7,8,9,10,11,12,13,14,15};		

	// BTN
	String sModels4[] ={"BTN90","BTN120","BTN160","BTN200","BTN240"};
	double dMinH4[] ={U(100),U(160),U(200),U(240),U(280)};
	double dA4[] ={U(90),U(120),U(160),U(200),U(240)};
	double dB4[] ={U(103),U(103),U(103),U(103),U(103)};
	double dC4[] ={U(46),U(46),U(46),U(46),U(46)};
	double dT4[] ={U(3),U(3),U(3),U(3),U(3)};
	double dDiamA4[] ={U(5),U(5),U(5),U(5),U(5) };
	int nDiamA4[] ={8,10,14,18,22};	
	double dDiamB4[] ={U(8,5),U(13),U(13),U(13),U(13)};
	int nDiamB4[] ={4,3,4,5,6};	// amount is set to 2 instead of 4 because the bolts are in two rows with 2 pieces

	// TU
	String sModels5[] ={"TU12","TU16","TU20","TU24","TU28"};
	double dMinH5[] ={U(100),U(160),U(200),U(240),U(280)}; //TODO
	double dA5[] ={U(96),U(134),U(174),U(214),U(254)};
	double dB5[] ={U(97.5), U(104.5), U(104.5),U(104.5),U(104.5)};
	double dC5[] ={U(40), U(60), U(60),U(60),U(60)};
	double dT5[] ={U(3.5), U(3.5), U(3.5),U(3.5),U(3.5)};
	double dDiamA5[] ={U(5),U(5),U(5),U(5),U(5) };
	int nDiamA5[] ={6,18,22,26,30};	
	double dDiamB5[] ={U(8.5),U(12.5),U(12.5),U(12.5),U(12.5)};
	int nDiamB5[] ={4,3,4,5,6};	// amount is set to 2 instead of 4 because the bolts are in two rows with 2 pieces
	double sHorEdgeOffsets5[] ={U(15.3),U(18.3),U(18.3),U(18.3),U(18.3)};
	double sVerBottomOffsets5[] ={U(12),U(26),U(26),U(26),U(26)};
	double sVerInterDist5[] ={24,40,40,40,40};
	
	// current family
	String sModels[0];
	double dMinHs[0];
	double dAs[0];
	double dBs[0];
	double dCs[0];
	double dTs[0];
	double dDiamAs[0];
	int nDiamAs[0];
	double dDiamBs[0];
	int nDiamBs[0];
//End Lists//endregion 

//region Properties
	String sAuto =T("|Automatic|");	

	String sRequireMsgs[] = {T("|The width of the secondary beam needs to be >= 160mm|"),
		T("|The upper edge of the secondary beam may not exceed the upper edge of the primary beam.|"), 
		T("|The offset between double connectors needs to be >= 80mm|")};
		
	String sModelName=T("|Model|");
	String sModelDesc = T("|Defines the model|");
	
// Model and Family
	category = sModelName;
	String sFamilyName=T("|Family|");
	
	PropString sFamily(nStringIndex++, sFamilies, sFamilyName);	
	sFamily.setDescription(T("|Defines the Family|"));
	sFamily.setCategory(category);

// on insert
// get execute key to preset family or model
	String sKeys[] = _kExecuteKey.tokenize("?");
	String sEntry;
	if (_bOnInsert)
	{
		if (insertCycleCount() > 1) { eraseInstance(); return; }
		int nFamily =sKeys.length()>0?sFamilies.find(sKeys[0].makeUpper()):- 1;
		if (nFamily>-1)
			sFamily.set(sFamilies[nFamily]);
		else
		{
			showDialog();
		}
		sEntry = sKeys.length() > 1 ? sKeys[1] : (nFamily == -1 ? "" : sKeys[0]);
	}
	

// Alignment
	category = T("|Alignment|");
	String sOffsetBetweenName= T("|Axis Offset between double connector|");
	PropDouble dOffsetBetween(nDoubleIndex++, U(80),sOffsetBetweenName );
	dOffsetBetween.setDescription(T("|Describes the offset between double connectors, needs to be >= 80mm|"));
	dOffsetBetween.setCategory(category);	

	PropDouble dYOff(nDoubleIndex++, U(0),T("|Offset|") + " Y");
	dYOff.setDescription(T("|Describes the offset of the  location of the metalpart in|") + " " + T("|Y-direction|"));
	dYOff.setCategory(category); 
	
	PropDouble dZOff(nDoubleIndex++, U(0),T("|Offset|") + " Z");	
	dZOff.setDescription(T("|Describes the offset of the  location of the metalpart in|") + " " + T("|Z-direction|"));
	dZOff.setCategory(category);
		

// Connecting Tool
	category= T("|Connecting Tool|");
	String sHouseTypes[] = { T("|Female Beam|"), T("|Main Beam|"), T("|Saw Cut|")};
	PropString sHouseType(nStringIndex++,sHouseTypes,T("|Type|"));	
	sHouseType.setDescription(T("|Option to define the beam of the beamcut|"));
	sHouseType.setCategory(category);

	String sHouseAlignmentName = T("|Alignment|");
	String sHouseAlignments[] = { T("|Bottom|"), T("|Centered|"), T("|Top|")};
	PropString sHouseAlignment(nStringIndex++,sHouseAlignments,sHouseAlignmentName);
	sHouseAlignment.setDescription(T("|Option to define the location of the beamcut|"));
	sHouseAlignment.setCategory(category);

	PropDouble dXOff(nDoubleIndex++, U(20),T("|Offset|") +" " +T("|Screw Heads|"));
	dXOff.setDescription(T("|Defines the depth of the end beam lap or the offset of the sawcut.|")); 
	dXOff.setCategory(category);
	
	PropDouble dExtraHouseDepth(nDoubleIndex++,U(2),T("|Gap|") + " (X) ");
	dExtraHouseDepth.setDescription(T("|Describes the additional depth of the beamcut|"));
	dExtraHouseDepth.setCategory(category);	
	
	PropDouble dGapHouse(nDoubleIndex++,U(2),T("|Gap|")+ " (YZ)");	
	dGapHouse.setDescription(T("|Describes the gap around the metalpart of the beamcut|"));
	dGapHouse.setCategory(category);

// Slot
	category= T("|Slot|");
	String sSlotAlignments[] = { T("|Top|"), T("|Bottom|"), T("|Full height|")};
	String sSlotAlignmentName = T("|Alignment|")+" ";	
	PropString sSlotAlignment(nStringIndex++,sSlotAlignments,sSlotAlignmentName );
	sSlotAlignment.setDescription(T("|Describes the location of the slot|"));
	sSlotAlignment.setCategory(category);
	
	PropDouble dGapSlotX(nDoubleIndex++,U(20),T("|Gap|") + " (X)");
	dGapSlotX.setDescription(T("|Describes the additional length of the slot|"));
	dGapSlotX.setCategory(category);
	
	PropDouble dGapSlotY(nDoubleIndex++,U(2),T("|Gap|") + " (Y)");
	dGapSlotY.setDescription(T("|Describes the additional width of the slot|"));
	dGapSlotY.setCategory(category);
		
	PropDouble dGapSlotZ(nDoubleIndex++,U(20),T("|Gap|") + " (Z)");
	dGapSlotZ.setDescription(T("|Describes the additional height of the slot|"));
	dGapSlotZ.setCategory(category);	

// Drill
	category = T("|Drill|");		
	//PropDouble dDepthDr(10,U(0),T("|Drill depth|") + " " + T("|(0 = complete)|"));	
	PropDouble dOffsetX(nDoubleIndex++,U(1),T("|Drill offset X|"));
	dOffsetX.setDescription(T("|Moves the Drills in negative connection direction to create mounting tension|")); 
	dOffsetX.setCategory(category);	

	//v1.04: Notice, this was added after release therefore new index is fixed
	String sDrillAlignments[] = {T("|Right|"), T("|Left|"), T("|Complete Through|")};
	String sDrillAlignmentName=T("|Drill Alignment|");
	PropString sDrillAlignment(5, sDrillAlignments, sDrillAlignmentName);	
	sDrillAlignment.setDescription(T("|Defines the DrillAlignment|"));
	sDrillAlignment.setCategory(category);
	
// Marking
	category  = T("|Marking|");	
	String sMarkings[]={T("|Marking|"),T("|Marking and Description|"),T("|Marking and PosNum|"),T("|None|"),T("|Marking|") + T(" |Fastener|")};//sMark
	PropString sMarking(nStringIndex++,sMarkings,T("|Marking|"),3);
	sMarking.setCategory(category); 
	sMarking.setDescription(T("|Sets a marking at the center of the metalpart.|"));		
		
//End Properties//endregion

//region OnInsert
	if (_bOnInsert)
	{
	// family type
		int nFamily = sFamilies.find(sFamily);// 0=BT, 1=BT4, 2=BTALU , 3 = BTC, 4=BTN, 5=TU
		
	// set OPM name 
		setOPMKey(sFamily);	
	
	// flag if dialog needs to be shown
		int bShowDialog = TslInst().getListOfCatalogNames(scriptName()+"-"+sFamily).find(sEntry)<0;		
//
//	// assign family data
		// BT
		if (nFamily==0)
			sModels=sModels0;		
		// BT4
		else if (nFamily==1)
			sModels=sModels1;			
		// BTALU
		else if (nFamily==2)
			sModels=sModels2;					
		// BTC
		else if (nFamily==3)
			sModels=sModels3;	
		// BTN
		else if (nFamily==4)
			sModels=sModels4;			
		// TU
		else if (nFamily==5)
		{
			sModels=sModels5;				
		}

		sModels.insertAt(0, sAuto);

		category = sModelName;
		PropString sModel(6, sModels, sModelName);	
		sModel.setDescription(sModelDesc);
		sModel.setCategory(category);

		if (bShowDialog)
		{
			sFamily.setReadOnly(true);
			showDialog();
		}
		else
		{
			setPropValuesFromCatalog(sEntry);
		}
		
	// separate selection	
		Beam males[0], females[0];
		PrEntity ssB(T("|Select male beams|"), Beam());
		if (ssB.go())
			males=ssB.beamSet();			
		PrEntity ssFemale(T("|Select female beam(s)|"), Beam());
		if (ssFemale.go())
		{
		// avoid females to be added to males again
			females=ssFemale.beamSet();
			for (int i=females.length()-1; i>=0; i--) 
			{ 
				if (males.find(females[i])>-1)
					females.removeAt(i); 
				
			}
		}		

	// prepare tsl cloning
		TslInst tslNew;
		Vector3d vecXTsl= _XU;
		Vector3d vecYTsl= _YU;
		GenBeam gbsTsl[] = {};
		Entity entsTsl[] = {};
		Point3d ptsTsl[] = {};
		int nProps[]={};
		double dProps[]={dOffsetBetween, dYOff,dZOff,dXOff,dExtraHouseDepth,dGapHouse,dGapSlotX,dGapSlotY,dGapSlotZ,dOffsetX};
		String sProps[]={sFamily, sHouseType,sHouseAlignment, sSlotAlignment,sMarking ,sDrillAlignment,sModel};
		Map mapTsl;	
		String sScriptname = scriptName();


		//reportMessage("\n"+ scriptName() + " has found males " + males.length());
	
	// loop males
		for (int i=0; i<males.length(); i++)
		{
			gbsTsl.setLength(0);
			Beam bm = males[i];
			Vector3d vecX = bm.vecX();
			Point3d ptCen = bm.ptCenSolid();
			gbsTsl.append(bm);	
			Beam bmStretchTo[0];
			bmStretchTo = bm.filterBeamsCapsuleIntersect(females);
			//if(bDebug)
			reportMessage("\n"+ scriptName() + " has found stretchTo beams " + bmStretchTo.length());


		// group stretch beams by connection side: this way the female side could have multiple beams
			for(int v=0;v<2;v++)
			{
			// collect females on this side				
				for (int j=0; j<bmStretchTo.length(); j++)
				{
					Point3d pt = Line(ptCen , vecX).intersect(Plane(bmStretchTo[j].ptCen(),bmStretchTo[j].vecD(vecX)),0);
					double d = vecX.dotProduct(pt-ptCen);
					if (((d>0 && v==0) || (d<0 && v==1)) && gbsTsl.find(bmStretchTo[j])<0)
						gbsTsl.append(bmStretchTo[j]);
				}

			// insert with a set of females	
				//if(bDebug)reportMessage("\n"+ scriptName() + " has beamset " + gbsTsl.length() + " on dir " + v);
				if (gbsTsl.length()>1)
				{ 
					tslNew.dbCreate(sScriptname , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
						nProps, dProps, sProps,_kModelSpace, mapTsl);
				}
			}// next v
		}
		eraseInstance();
		return;
	}
//End OnInsert//endregion 

//region FamilyData

// family type
	int nFamily = sFamilies.find(sFamily);// 0=BT, 1=BT4, 2=BTALU , 3 = BTC, 4=BTN

// set OPM name 
	setOPMKey(sFamily);	
		
// assign family data
	double dXDrillA = dXDrillAs[nFamily];//dSlotplateVerticalInterdistance
	double dZDrillA = dZDrillAs[nFamily];
	double dSlotplateVerticalOffset = dSlotplateVerticalOffsets[nFamily];
	double dSlotplateHorizontalOffset = dSlotplateHorizontalOffsets[nFamily];
	double dSlotplateVerticalInterdistance = dSlotplateVerticalInterdistances[nFamily];
	int bCanBeAngled = bCanBeAngleds[nFamily];
	_ThisInst.setHyperlink(sURLs[nFamily]);
	
	// BT
	if (nFamily==0)
	{
		sModels=sModels0;
		dMinHs=dMinH0;
		dAs=dA0;	dBs=dB0;	dCs=dC0;
		dTs=dT0;
		dDiamAs=dDiamA0;	nDiamAs=nDiamA0;
		dDiamBs=dDiamB0;	nDiamBs=nDiamB0;
	}
	// BT4
	else if (nFamily==1)
	{
		sModels=sModels1;
		dMinHs=dMinH1;
		dAs=dA1;	dBs=dB1;	dCs=dC1;
		dTs=dT1;
		dDiamAs=dDiamA1;	nDiamAs=nDiamA1;
		dDiamBs=dDiamB1;	nDiamBs=nDiamB1;
	}			
	// BTALU
	else if (nFamily==2)
	{
		sModels=sModels2;
		dMinHs=dMinH2;
		dAs=dA2;	dBs=dB2;	dCs=dC2;
		dTs=dT2;
		dDiamAs=dDiamA2;	nDiamAs=nDiamA2;
		dDiamBs=dDiamB2;	nDiamBs=nDiamB2;
	}				
	// BTC
	else if (nFamily==3)
	{
		sModels=sModels3;
		dMinHs=dMinH3;
		dAs=dA3;	dBs=dB3;	dCs=dC3;
		dTs=dT3;
		dDiamAs=dDiamA3;	nDiamAs=nDiamA3;
		dDiamBs=dDiamB3;	nDiamBs=nDiamB3;
	}	
	// BTN
	else if (nFamily==4)
	{
		sModels=sModels4;
		dMinHs=dMinH4;
		dAs=dA4;	dBs=dB4;	dCs=dC4;
		dTs=dT4;
		dDiamAs=dDiamA4;	nDiamAs=nDiamA4;
		dDiamBs=dDiamB4;	nDiamBs=nDiamB4;
	}
	// TU
	else if (nFamily==5)
	{
		sModels=sModels5;
		dMinHs=dMinH5;
		dAs=dA5;	dBs=dB5;	dCs=dC5;
		dTs=dT5;
		dDiamAs=dDiamA5;	nDiamAs=nDiamA5;
		dDiamBs=dDiamB5;	nDiamBs=nDiamB5;
	}				

	sModels.insertAt(0, sAuto);

// redeclare model property
	category = sModelName;
	PropString sModel(6, sModels, sModelName);	
	sModel.setCategory(category);

// on the event of changing the family. Reset to automatic model	
	if (_kNameLastChangedProp==sFamilyName)
	{ 
		sModel.set(sAuto);
		reportMessage("\n" + sModelName + " " + T("|has been changed to|") + " " + sAuto);
		setExecutionLoops(2);
		return;
	}
//End FamilyData//endregion 

// Beams
	Beam bm0, bm1,bmFemales[0];
	bm0 = _Beam[0];
	bm1 = _Beam[1];	
	Point3d ptCen0 = bm0.ptCenSolid();
	Point3d ptCen1 = bm1.ptCenSolid();
	
// get coordSys
	Vector3d vecXC = _Z1.isPerpendicularTo(_ZW) ? _Z1 : _X1;
	Vector3d vecYC = vecXC.crossProduct(-_Z0);	
	Vector3d vecZC = vecXC.crossProduct(vecYC);
//vecXC.vis(_Pt0, 1);
//vecYC.vis(_Pt0, 3);
//vecZC.vis(_Pt0, 150);

	Point3d ptOffsetZMax = (_Pt1 + _Pt2) * .5;
	Point3d ptOffsetZMin = (_Pt3 + _Pt4) * .5;
	Vector3d vecZO = ptOffsetZMax - ptOffsetZMin;
	vecZO.normalize();
	Vector3d vecYO = vecXC.crossProduct(-vecZO);
	vecYO.normalize();
	Vector3d vecXO = vecYC.crossProduct(vecZO);
	vecXO.normalize();
//vecXO.vis(_Pt0 + _ZW *10, 1);
//vecYO.vis(_Pt0 + _ZW *10, 3);
//vecZO.vis(_Pt0 + _ZW *10, 150);
	
	Vector3d vecXT = vecZC.crossProduct(-_Y0).isPerpendicularTo(vecYC) ? (bCanBeAngled ? vecXC : _X0) : (bCanBeAngled ? _X0 : vecXC);
	vecXT.normalize();
	Vector3d vecYT = bCanBeAngled ? bm0.vecD(vecYC): vecYC;
	vecXT.normalize();
	Vector3d vecZT = vecXT.crossProduct(vecYT);
	vecZT.normalize();
//vecXT.vis(_Pt0 + _ZW *20, 1);
//vecYT.vis(_Pt0 + _ZW *20, 3);
//vecZT.vis(_Pt0 + _ZW *20, 140);

	Vector3d vecXTFlat = vecZO.crossProduct(vecXT).crossProduct(vecZO);
	vecXTFlat.normalize();
	Vector3d vecYTFlat = vecYT.crossProduct(vecZO).crossProduct(-vecZO);
	vecYTFlat.normalize();
	Vector3d vecZTFlat = vecXTFlat.crossProduct(vecYTFlat);
	vecZTFlat.normalize();
//vecXTFlat.vis(_Pt0 + _ZW *30, 1);
//vecYTFlat.vis(_Pt0 + _ZW *30, 3);
//vecZTFlat.vis(_Pt0 + _ZW *30, 150);
	
	double dAngBeamsTop = vecXTFlat.angleTo(vecXO); // vecZC.crossProduct(-_Y0).angleTo(vecXC);
	dAngBeamsTop *= vecYO.dotProduct((_Pt0 + vecXTFlat * 10) - (_Pt0 + vecXO * 10)) < 0 ? -1 : 1;
	double dTopViewAngle = abs(vecYC.dotProduct((_Pt0 + vecXTFlat * 10) - (_Pt0 + vecXC * 10)));
	if (dTopViewAngle > dEps) sFamily.setReadOnly(true);
	
	CoordSys csAngBeamsTop;
	csAngBeamsTop.setToRotation(dAngBeamsTop, vecZO, _Pt0);	
	
	int bFemaleIsAPost = false;
	if ( abs(1 - bm1.vecX().dotProduct(_ZW)) < dEps) //bm1 is a post
	{
		bFemaleIsAPost = true;
	}
			
	double dH0 = _H0;
	
// make sure a valid model is selected
	int nModel = sModels.find(sModel, 0);
	if (nModel<0 && sModels.length()>0)
	{
		nModel = 0;		
		sModel.set(sModels[nModel]);
	}

// select model if set to automatic
	int nThisModel = nModel;
	if (nThisModel==0)
	{ 
		double dMax = dH0;
		if(bFemaleIsAPost)
		{ 
			Point3d pts[] = { _Pt1, _Pt2, _Pt3, _Pt4};
			pts = Line(_Pt0, _X1).orderPoints(pts);
			dMax = abs(_X1.dotProduct(pts[0] - pts[pts.length() - 1])); // height of contact face
		}
		
		for (int i=dMinHs.length()-1; i>=0 ; i--) 
		{ 
			if (dMax >= dMinHs[i])
			{ 
				nThisModel = i+1;
				break;		
			}		
		} 
	}
	
// stop if invalid
	if (nThisModel<1 || nThisModel>sModels.length()-1)
	{ 
		reportMessage("\n" + scriptName() +T(" |could not find a valid model|. "));
		if(_bOnDbCreated || !_Map.hasString("Family")) // when first inserted
		{ 
			eraseInstance();
			return;
		}
		
		sFamily.set(_Map.getString("Family")); // when already inserted and user choosed a not valid family/model
		setExecutionLoops(4);
		return;
	}	
	
// store current family for restore to it in case not valid model is found when user changes it on OPM
	_Map.setString("Family", sFamily);
	int nHWAssignment = _Map.getInt("HardwareAssignment"); // 0 =PartialPlant, 1 = Plant, 2 = ConstructionSite

	String sThisModel = sModels[nThisModel];
	sModel.setDescription(sModelDesc + " " + sModels[nThisModel]);
	assignToGroups(bm1, 'I');
	
	

//region Tag Display
	int bShowTag = _Map.getInt("ShowTag");
	int bIsBF = projectSpecial().find("Baufritz", 0, false) >- 1;
	if (!_Map.hasInt("ShowTag") && bIsBF)
	{ 
		bShowTag = true;
		 _Map.setInt("ShowTag", true);
	}
	if (bShowTag)
	{ 
		if (_PtG.length() < 1)_PtG.append(_Pt0 + vecXC * 1.5 * bm1.dD(_Z1));
		_PtG[0] += _ZW * _ZW.dotProduct(_Pt0 - _PtG[0]);
		
		Display dp(nHWAssignment==2?4:3); // green in production, cyan onsite
		dp.addViewDirection(_ZW);
		dp.showInDxa(true);
		
		String sDimStyle = _DimStyles.first();
		if(bIsBF)
		{ 
			int n = _DimStyles.findNoCase("BF 1.0" ,- 1);
			if (n>-1)sDimStyle = _DimStyles[n];
		}
		dp.dimStyle(sDimStyle);
		double textHeight = U(90);//dp.textHeightForStyle("O",sDimStyle);
		dp.textHeight(textHeight);
		double dX = dp.textLengthForStyle(sThisModel,sDimStyle, textHeight)+ textHeight;
		double dY = dp.textHeightForStyle(sThisModel,sDimStyle, textHeight) +.5*textHeight;
		LineSeg seg(_PtG[0]- _YW * .5 * dY, _PtG[0] + _XW*dX+ _YW*.5*dY);
		seg.transformBy(-_XW * .5 * dX);
		seg.vis(2);
		PLine pl;pl.createRectangle(seg, _XW, _YW);
		

		dp.draw(sThisModel, _PtG[0] - _XW * .5*(dX-textHeight), _XW, _YW, 1, 0);
		if (nHWAssignment==0)
		dp.color(4); // green in production, cyan onsite
		dp.draw(pl);
		dp.draw(PLine(_Pt0, pl.closestPointTo((_PtG[0]+_Pt0)/2)));
			
	}
	else if (_PtG.length()>0)
		_PtG.setLength(0);
	
// Trigger ShowTag
	String sTriggerShowTag =bShowTag?T("|Hide Badge|"):T("|Show Badge|");
	addRecalcTrigger(_kContextRoot, sTriggerShowTag);
	if (_bOnRecalc && _kExecuteKey==sTriggerShowTag)
	{
		bShowTag = bShowTag ? false : true;
		_Map.setInt("ShowTag", bShowTag);		
		setExecutionLoops(2);
		return;
	}
//End Tag Display//endregion 

// get parameters of current connector
// geometry
	double dA = dAs[nThisModel-1];
	double dB = dBs[nThisModel-1];
	double dC = dCs[nThisModel-1];
	double dT = dTs[nThisModel-1];
	double dDiamA = dDiamAs[nThisModel-1];
	double dDiamB= dDiamBs[nThisModel-1];
	int nDiamA= nDiamAs[nThisModel-1];
	int nDiamB= nDiamBs[nThisModel-1];
	if (nFamily==5)
	{
		dSlotplateHorizontalOffset = dB5[nThisModel-1] + dTs[nThisModel-1] - sHorEdgeOffsets5[nThisModel-1];
		dSlotplateVerticalOffset = sVerBottomOffsets5[nThisModel-1];
		dSlotplateVerticalInterdistance = sVerInterDist5[nThisModel-1];
	}

// collect female beams
	bmFemales.append(_Beam[1]);
	for (int i=0 ; i < _Beam.length() ; i++) 
	{ 
	    Beam bm = _Beam[i]; 
	    if (!bm.vecX().isParallelTo(vecXC) && bm.vecD(vecXC).isParallelTo(vecXC) && bmFemales.find(bm)<0)//
			bmFemales.append(bm);	    	
	}
	
// invalid alignment
	Vector3d vecPerp = bm1.vecX();
	if (bFemaleIsAPost) 
	{
		vecPerp = bm1.vecD(vecYC);
	}
	if (!bCanBeAngled  && abs(bm0.vecX().dotProduct(vecPerp))>dEps*.1)
	{
		reportMessage(
		"\n*****************************************************************\n" + 
		scriptName() + ": " + T("|Incorrect user input.|") + "\n" + 
		T("|Beams must be perpendicular|") + "\n" + 
		T("|Tool will be deleted|") + 
		"\n*****************************************************************");
		eraseInstance();
		return;
	}

// ints
	int nSlot= sSlotAlignments.find(sSlotAlignment);		
	int nHouseIn = sHouseTypes.find(sHouseType);
	int nHouse = sHouseAlignments.find(sHouseAlignment);
	int nMarking = sMarkings.find(sMarking);	
	int bDoubleConnector = dC <= dOffsetBetween;

// validate settings for double connectors
	if (bDoubleConnector)
	{
		if (_W0<2*dC)
		{
			reportMessage("\n" + T("|The geometry of beam|") + " " + bm0.posnum() + " " + T("|does not allow the usage of a double connector.|") + "\n" +
				sRequireMsgs[0] + " " + T("|The option has been disabled.|"));	
			bDoubleConnector=false;	
		}
		
		double dTopEdgeOffset = abs(vecZO.dotProduct((ptCen0 + vecZO * .5 * _H0) - (ptCen1 + vecZO * .5 * _H1)));
		if(bFemaleIsAPost)
		{ 
			dTopEdgeOffset = vecZTFlat.dotProduct((ptCen0 + vecZTFlat * .5 * _H0) - (ptCen1 + vecZTFlat * .5 * bm1.solidLength()));
		}
_X1.vis(_Pt0,6);
		if (dTopViewAngle > dEps && dTopEdgeOffset>dEps && (bCanBeAngled ? true : !vecYTFlat.isParallelTo(_X1)))
		{
			reportMessage("\n" + T("|The location of beam|") + " " + bm0.posnum() + " " + T("|does not allow the usage of a double connector.|") + "\n" +
				sRequireMsgs[1] + " " + T("|The option has been disabled.|"));
			bDoubleConnector=false;
		}
	}
	int nQty=bDoubleConnector?2:1;
	
// v1.04: add drill alignment from OPM
	int nDrillAlignment= sDrillAlignments.find(sDrillAlignment, 0);
	int nDrillDir = nDrillAlignment == 0 ? 1 :- 1;	//1=right, -1=left
	int bDrillThrough = nDrillAlignment == 2 ? true : false;
	
// add triggers
	// Trigger complete through
	String sTriggerDrillThrough=T("|Drill not through|");
	if (!bDrillThrough)
		sTriggerDrillThrough=T("|Drill complete through|");
	if (!bDoubleConnector)
		addRecalcTrigger(_kContextRoot,sTriggerDrillThrough);	

	if (_bOnRecalc && _kExecuteKey==sTriggerDrillThrough)
	{
		if(bDrillThrough)
		{
			bDrillThrough=false;
			sDrillAlignment.set(sDrillAlignments[0]);
		}
		else 
		{
			bDrillThrough=true;
			sDrillAlignment.set(sDrillAlignments[sDrillAlignments.length()-1]);
		}
		setExecutionLoops(2);
		return;
	}

	// Trigger flip drill face
	String sTriggerFlipDrill=T("|Flip Drill Face|");
	if (!bDrillThrough && !bDoubleConnector)
	{
		addRecalcTrigger(_kContextRoot,sTriggerFlipDrill);	
	}

	if (_bOnRecalc && _kExecuteKey==sTriggerFlipDrill)
	{
		nDrillDir *=-1;
		sDrillAlignment.set(sDrillAlignments[nDrillDir == 1 ? 0 : 1]);
		setExecutionLoops(2);
		return;
	}	
	
	// TriggerCycleAlignemnts
	String sTriggerCycleAlignemnts = T("|Cycle Drill Face| ") + T("(|DoubleClick|)");
	addRecalcTrigger(_kContextRoot, sTriggerCycleAlignemnts );
	if (_bOnRecalc && (_kExecuteKey == sTriggerCycleAlignemnts || _kExecuteKey == sDoubleClick))
	{
		if (sDrillAlignments.find(sDrillAlignment, - 1) < 2)
		{
			sDrillAlignment.set(sDrillAlignments[sDrillAlignments.find(sDrillAlignment, - 1) + 1]);
		}
		else
		{
			sDrillAlignment.set(sDrillAlignments[0]);
		}
		setExecutionLoops(2);
		return;
	}
	
// Display// multiply dT with 2 if family == 2 (BTALU)
	int nMultiple = 1;
	if(nFamily == 2)
		nMultiple = 2;


// ref points
	Point3d ptRef = _Pt0 + vecYO * dYOff + vecZO * dZOff;
//ptRef.vis(4);
	Point3d ptRefSlot;

	if (nHouseIn == 1)// female
		ptRef.transformBy(vecXO * (nMultiple*dT + dExtraHouseDepth));
	int nColor = 252;
	Display dp(nColor);	
	dp.showInDxa(true);
	dp.textHeight(U(30));

// Cut
	Cut ct;
	if (nHouseIn == 2) 
		ct = Cut(_Pt0 - vecXC * dXOff, _Z1);
	else 
		ct = Cut(_Pt0, _Z1);
	bm0.addTool(ct,bDebug?0:1);
		
// the body

	Body bd(ptRef, vecXO, vecYO, vecZO, nMultiple*dT, dC, dA, -1, 0,0);	
	Body bdInFemale(ptRef - vecXO * dT, vecXO, vecYO, vecZO, dB*2 , 2*dT, dA, 0, 0,0);	
	bdInFemale.transformBy(csAngBeamsTop);
	bdInFemale.addTool(Cut(ptRef - vecXO * dT, vecXO ));
	bd.addPart(bdInFemale);
bd.vis(4);
	PlaneProfile ppZ = bd.shadowProfile(Plane(ptRef, vecZC));

	// few reference points based on body
	Point3d ptInsideVecX = ppZ.extentInDir(-vecXC).ptEnd() - vecZC * dA *.5;
	PlaneProfile ppZ0 = bd.shadowProfile(Plane(ptRef, _Beam0.vecD(vecZC)));
	Point3d ptInsideVecX0 = ppZ0.extentInDir(_X0).ptStart();
	ptInsideVecX.vis(); ptInsideVecX0.vis();
	
// TOOLS
// Slot
	// bottom?
	int nSlotDir = nSlot== 1 ? -1 : 1;
	
	ptRefSlot = _Pt0 + nSlotDir * vecZO * 0.5 * _H0+ vecYTFlat * dYOff;
	ptRefSlot += vecXTFlat * (vecXTFlat.dotProduct(ptInsideVecX0-ptRefSlot) - dGapSlotX);	

	// full height?
	double dSlotDepth = nSlot== 2? _H0*1.1:nSlotDir * _Beam0.vecD(vecZTFlat).dotProduct(ptRefSlot-ptRef) + dGapSlotZ +.5*dA;//HSB-19431
	
// offset refs for double connectors
	Point3d ptThisRef = ptRef;	
	if (bDoubleConnector)
	{
		ptRefSlot.transformBy(-vecYO*(nQty-1)/2 * dOffsetBetween);	
		ptThisRef.transformBy(-vecYO*(nQty-1)/2 * dOffsetBetween);	
		bd.transformBy(-vecYO*(nQty-1)/2 * dOffsetBetween);	
	}
	
// declare main body
	Body bdMain;	
	Point3d ptsRefs[0];
	for (int i=0;i<nQty;i++)
	{	
		double dX= U(1000) , dY=2*dT + dGapSlotY, dZ = dSlotDepth; //v1.3 double dX=dSlotLength, dY=2*dT + dGapSlotY, dZ = dSlotDepth;
	// Slot	
		if (dX>dEps && dY>dEps && dZ>dEps)
		{
ptRefSlot.vis(6);


vecXTFlat.vis(ptRefSlot, 1);
vecYTFlat.vis(ptRefSlot, 3);
vecZTFlat.vis(ptRefSlot, 150);


			Slot sl(ptRefSlot, vecXTFlat, vecYTFlat, nSlotDir * -vecZTFlat, dX, dY, dZ  , 1,0,1); //v1.3, Slot sl(ptRefSlot, _X0, _Y0, nSlotDir * -_Z0, dX, dY, dZ  , -1,0,1);

			//sl.transformBy(csAngBeamsTop);
			
			sl.cuttingBody().vis(1);
			bm0.addTool(sl);
			ptRefSlot.transformBy(vecYC* dOffsetBetween);
		}
		
	// House toolings
		dX=dC + dGapHouse;
		dY=dA + dGapHouse;
		dZ = nMultiple*dT+dExtraHouseDepth;
		
		if (nHouseIn == 0)// male
		{
			dZ+=dXOff;
			Point3d ptHs = ptThisRef;
			if (nHouse != 1)
				dY = dA + _H0;
			if (nHouse == 0)
				ptHs = ptHs - vecZO * 0.5 * _H0;
			else if (nHouse == 2)
				ptHs = ptHs + vecZO * 0.5 * _H0;
			ptHs.vis(4);
			
		// male
			if (dX>dEps && dY>dEps && dZ>dEps)
			{
				House hs(ptHs , vecYO, vecZO, -vecXO, dX, dY , dZ,0,0,1);
				hs.setEndType(_kFemaleEnd);
				hs.setRoundType(_kReliefSmall);
				//hs.cuttingBody().vis(5);
				bm0.addTool(hs);
			}		
		}
		else if (nHouseIn == 1)// female	
		{
			Point3d ptHs = ptThisRef-vecXO * dZ;
			if (nHouse != 1)
				dY = dA + _H0;
			if (nHouse == 0)
				ptHs = ptHs - vecZO * 0.5 *_H0;
			else if (nHouse == 2)
				ptHs = ptHs + vecZO * 0.5 *_H0;
				
		// house in male beam
			dZ = dXOff;
			if (dX>dEps && dY>dEps && dZ>dEps)
			{
				House hs(ptHs , vecYO, vecZO, -vecXO, dX, dY , dZ,0,0,1);
				hs.setEndType(_kFemaleEnd);
				hs.setRoundType(_kReliefSmall);
				//hs.cuttingBody().vis(5);
				bm0.addTool(hs);
			}		
			
		// female house
			dY=dA + dGapHouse;
			dZ = nMultiple*dT+dExtraHouseDepth;
			ptHs = ptThisRef -vecXO * dZ;
			ptHs.vis(4);
			if (dX>dEps && dY>dEps && dZ>dEps)
			{
				House hs(ptHs , vecYO, vecZO, vecXO, dX, dY ,dZ,0,0,1);
				hs.setEndType(_kFemaleSide);
				hs.setRoundType(_kReliefSmall);
				hs.cuttingBody().vis(5);
				hs.addMeToGenBeamsIntersect(bmFemales);
			}			
		}	
		ptsRefs.append(ptThisRef);
		ptThisRef.transformBy(vecYC* dOffsetBetween);	

	// draw the body
		bd.vis(4);	
		bdMain.addPart(bd);
		bd.transformBy(vecYO* dOffsetBetween);			
	}

// the relevant beam width for pegs
	double dDrillDepth= bm0.dD(vecYTFlat) + dEps*2;
	if (!bDrillThrough)
	{
		if (bDoubleConnector)
			dDrillDepth*=.5;
		else
			dDrillDepth-=U(15.5);
	}
	double dPegThisLength = dDrillDepth;

// reactivating the nType check for the ...90 Models
	int nType;
	if(nFamily == 1 && dDiamB == U(8))
		nType = 1;
	if(nFamily == 4 && dDiamB == U(8))
		nType = 6;
	if(nType == 1 || nType == 6 )	
		dSlotplateVerticalOffset = U(25);

// set transformation for double connector
	CoordSys csMirr;
	csMirr.setToMirroring(Plane(_Pt0, vecYC));
	
// drills
	Point3d ptDr = ptRef - vecXC * (dSlotplateHorizontalOffset + dT) - vecZC * (0.5 * dA-dSlotplateVerticalOffset) - nDrillDir*.5*vecYC * bm0.dD(vecYC);
//ptDr.vis(3);
//ptRef.vis(6);
	
	double dDrill90 = 1;
	if (nType == 1 || nType ==6)
	{
		ptDr.transformBy(-vecXC * U(4));	
		dDrill90 = .5; // correcting the number of runs for drill creation
	}

// No pedrilling for BTALU
	
	if (nFamily != 2)
	{
		Plane plDrillFace(ptRef - vecYTFlat * nDrillDir * (bm0.dD(vecYTFlat)*.5+dEps), vecYTFlat);
//plDrillFace.vis(6);
	
		Point3d ptPrj = ptRef - vecZO * dA * .5 - vecXO * dSlotplateHorizontalOffset + vecZO * dSlotplateVerticalOffset;
		ptPrj.transformBy(csAngBeamsTop);
//ptPrj.vis(8);

		for (int i = 0; i < nDiamB*dDrill90; i++)
		{
			ptPrj = plDrillFace.closestPointTo(ptPrj);
			ptPrj.vis(2);
		
			// drill the body
			Drill dr(ptPrj, ptPrj + nDrillDir * vecYTFlat * dDrillDepth, dDiamB / 2);
//dr.cuttingBody().vis(6);

			if (i == nDiamB - 1)
			{
				double dZ = U(50);
				PLine pl(vecYC);
				Point3d pt = ptPrj + vecXTFlat * .5 * dDiamB;
				pl.addVertex(pt);
				pl.addVertex(pt + vecXTFlat * (tan(10) * dZ) + vecZTFlat * dZ);
				pl.addVertex(pt - vecXTFlat * (dDiamB + tan(10) * dZ) + vecZTFlat * dZ);
				pl.addVertex(pt - vecXTFlat * dDiamB);
				pl.addVertex(pt ,- 1);
//pl.vis(2);
				Body bdTopDrillEdge(pl, vecYTFlat * nDrillDir * (_W0 + dEps), 1);
//bdTopDrillEdge.vis(4);
				SolidSubtract sosu(bdTopDrillEdge, _kSubtract);
				bdMain.addTool(sosu);
			}
			else
			{ 
				bdMain.addTool(dr);
			}
			
			if (nType == 1 || nType == 6)
			{
				dr = Drill (ptPrj + vecXTFlat * U(40) * nDrillDir, ptPrj + vecXTFlat * U(40) + nDrillDir * vecYTFlat * dDrillDepth, dDiamA / 2);
				bdMain.addTool(dr);
			}
		
			// drill beam
			double dDiamDr = U(12);
			if (nType == 1 || nType == 6)
				dDiamDr = U(8);
			Drill drBm(ptPrj - nDrillDir * vecYTFlat * dEps, ptPrj + nDrillDir * vecYTFlat * (dDrillDepth  + dEps*2) , dDiamDr / 2);
			drBm.transformBy(-vecXC * dOffsetX);
			bm0.addTool(drBm);
		
			if (bDoubleConnector && !bDrillThrough)
			{
				Drill drBm2 = drBm;
				drBm2 .transformBy(csMirr);
				bm0.addTool(drBm2 );
				drBm2 .cuttingBody().vis(111);
			}
		
			if (nType == 1 || nType == 6)
			{
				drBm = Drill (ptPrj + vecXTFlat * U(40) - nDrillDir * vecYTFlat * bm0.dD(vecYTFlat), ptPrj + vecXTFlat * U(40) + nDrillDir * vecYTFlat * dDrillDepth , dDiamDr / 2);
				drBm.transformBy(csAngBeamsTop);
				bdMain.addTool(drBm);
				if (abs(dOffsetX) > dEps)
				{
					if (bDoubleConnector && !bDrillThrough)
					{
						Drill drBm2 = drBm;
						drBm2 .transformBy(csMirr);
						bm0.addTool(drBm2 );
					}
				}
				drBm.transformBy(-vecXC * dOffsetX);
				bm0.addTool(drBm);
			
				if (bDoubleConnector && !bDrillThrough)
				{
					Drill drBm2 = drBm;
					drBm2 .transformBy(csMirr);
					bm0.addTool(drBm2 );
					drBm2 .cuttingBody().vis(222);
				}
			}
			ptPrj.transformBy(vecZTFlat * dSlotplateVerticalInterdistance);
		}
	}
	dp.draw(bdMain);
	
// MARKER TOOLS
	int bAddMarking = nMarking >- 1 && nMarking < 3;
	int bAddMarkerLine = (!_Y1.isParallelTo(_Y0) && !_Y1.isParallelTo(_Z0));
	
// loop single/double connector
	for (int j=0;j<ptsRefs.length();j++) 
	{ 
		Point3d ptMarking= Line(ptsRefs[j],vecXTFlat).intersect(_Plf,0);
		Mark mrk; // default constructor	
	
	// add markerlines if connection is not colinear
		if  (bAddMarkerLine && bAddMarking)
		{ 
			double dY = dC;
			double dZ = dB;//dMpHeight[nType];
			
			Point3d pt1 = ptMarking+vecZTFlat*.5*dZ;
			Point3d pt2 = ptMarking-vecZTFlat*.5*dZ;
			
			MarkerLine ml(pt1, pt2 ,- vecXTFlat);
			ml.transformBy(vecYTFlat * .5 * dY);
	
			for(int i=0;i<bmFemales.length();i++)
			{
				bmFemales[i].addTool(ml);
			}// next i	
	
			ml.transformBy(-vecYTFlat * dY);
			for(int i=0;i<bmFemales.length();i++)
			{
				bmFemales[i].addTool(ml);
			}// next i	
			
			pt1.vis(1);
			pt2.vis(2);
		}
	
		if (bAddMarking)
		{ 
		//Marking
			if (nMarking==0)
			    mrk = Mark(ptMarking,ptMarking,-vecXTFlat);		
			else if (nMarking==1)
			{
				mrk = Mark(ptMarking,ptMarking,-vecXTFlat, sThisModel);
				mrk.setTextHeight(0);
			}
			else if (nMarking==2)
			{
				mrk = Mark(ptMarking,ptMarking,-vecXTFlat,0); // 0 is index of _Beam0
				mrk.setTextHeight(0);
			}
			
		// marking including text
			if (nMarking>0 && nMarking<3)
				mrk.setTextPosition(0,0,1);
			
		// if marker lines were added use the mark only for text / posnum	
			if (bAddMarkerLine)
				mrk.suppressLine();
		
		// add marks
			if((nMarking==0 && !bAddMarkerLine) || nMarking==1 || nMarking==2)
			{
				for(int i=0;i<bmFemales.length();i++)
				{
					bmFemales[i].addTool(mrk);
				}// next i	
			}
					
		}
		
	// added in version 1.2. The fastener itselfs get marked on the beam		
		if(nMarking ==4)
		{	
			Point3d ptRefMk = ptsRefs[j]; // v1.6: changed reference from ptRef to ptRefMK
			for(int i=0; i< bmFemales.length();i++)
			{
				MarkerLine mkL1(ptRefMk - 0.5 * dC * vecYTFlat - 0.5 * dA * vecZTFlat, ptRefMk - 0.5 * dC * vecYTFlat - 0.5 * (dA-U(10)) * vecZTFlat ,- vecXC);
				bmFemales[i].addTool(mkL1);
				MarkerLine mkL2(ptRefMk - 0.5 * dC * vecYTFlat - 0.5 * dA * vecZTFlat, ptRefMk - 0.5 * (dC-U(10)) * vecYTFlat - 0.5 * dA * vecZTFlat ,- vecXC);
				bmFemales[i].addTool(mkL2);
				MarkerLine mkL3(ptRefMk - 0.5 * dC * vecYTFlat + 0.5 * dA * vecZTFlat, ptRefMk - 0.5 * dC * vecYTFlat + 0.5 * (dA-U(10)) * vecZTFlat ,- vecXC);
				bmFemales[i].addTool(mkL3);
				MarkerLine mkL4(ptRefMk - 0.5 * dC * vecYTFlat + 0.5 * dA * vecZTFlat, ptRefMk - 0.5 * (dC-U(10)) * vecYTFlat + 0.5 * dA * vecZTFlat ,- vecXC);
				bmFemales[i].addTool(mkL4);
				MarkerLine mkL5(ptRefMk + 0.5 * dC * vecYTFlat - 0.5 * dA * vecZTFlat, ptRefMk + 0.5 * dC * vecYTFlat - 0.5 * (dA-U(10)) * vecZTFlat ,- vecXC);
				bmFemales[i].addTool(mkL5);
				MarkerLine mkL6(ptRefMk + 0.5 * dC * vecYTFlat - 0.5 * dA * vecZTFlat, ptRefMk + 0.5 * (dC-U(10)) * vecYTFlat - 0.5 * dA * vecZTFlat ,- vecXC);
				bmFemales[i].addTool(mkL6);
				MarkerLine mkL7(ptRefMk + 0.5 * dC * vecYTFlat + 0.5 * dA * vecZTFlat, ptRefMk + 0.5 * dC * vecYTFlat + 0.5 * (dA-U(10)) * vecZTFlat ,- vecXC);
				bmFemales[i].addTool(mkL7);
				MarkerLine mkL8(ptRefMk + 0.5 * dC * vecYTFlat + 0.5 * dA * vecZTFlat, ptRefMk + 0.5 * (dC-U(10)) * vecYTFlat + 0.5 * dA * vecZTFlat ,- vecXC);
				bmFemales[i].addTool(mkL8);
			}						
		}
	}
	
//region Hardware
	String additionalNotes = _ThisInst.additionalNotes();
// Trigger Hardware Production//region
	for (int i=0;i<sMountings.length();i++) 
	{ 
		String trigger =sMountings[i]+(i == nHWAssignment ? "   √" : "");
		addRecalcTrigger(_kContextRoot,trigger);
		if (_bOnRecalc && _kExecuteKey==trigger)
		{
			_Map.setInt("HardwareAssignment",i);		
			setExecutionLoops(2);
			return;
		}		 
	}//next i
	//endregion

// collect existing hardware
	HardWrComp hwcs[] = _ThisInst.hardWrComps();
	
// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
	int bRTFound;
	for (int i=hwcs.length()-1; i>=0 ; i--) 
		if (hwcs[i].repType() == _kRTTsl)
		{
			bRTFound = true; // flag if this instance has RT reps attached, legacy version will not have this
			hwcs.removeAt(i); 
		}
		
// legacy, remove any entry
	if(!bRTFound)
		for (int i=hwcs.length()-1; i>=0 ; i--) 
			hwcs.removeAt(i); 

// declare the groupname of the hardware components
	String sHWGroupName, sHWManufacturer="Simpson StrongTie";
	// set group name
	{ 
	// element
		// try to catch the element from the parent entity
		Element elHW =_ThisInst.element(); 
		// check if the parent entity is an element
		if (!elHW.bIsValid())	elHW = (Element)_ThisInst;
		if (elHW.bIsValid()) 	sHWGroupName=elHW.elementGroup().name();
	// loose
		else
		{
			Group groups[] = _ThisInst.groups();
			if (groups.length()>0)	sHWGroupName=groups[0].name();
		}		
	}
	
// add main componnent
// HSB-15932
	if (bm0.bIsDummy())nQty = 0;
	{ 
		HardWrComp hwc(sThisModel, nQty); // the articleNumber and the quantity is mandatory		
		hwc.setManufacturer(sHWManufacturer);		
		hwc.setModel(sThisModel);
		hwc.setName(sFamily);
		hwc.setDescription(T("|Concealed Hanger|"));
		hwc.setMaterial("S 250 GD +Z 275");
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(_ThisInst);	
		hwc.setCategory(T("|Connector|"));
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		hwc.setCountType(_kCTAmount);
		hwc.setDScaleX(dA);
		hwc.setDScaleY(dB);
		hwc.setDScaleZ(dC);
		hwc.setNotes((nHWAssignment != 2 ? sMountingProduction : sMountingOnSite) +";" + _ThisInst.posnum()+";" + additionalNotes );	
	
		hwcs.append(hwc);// apppend component to the list of components
	}

// add sub componnent
	{ 
		String articleNumber = "STD12x";
		double dL = (bDoubleConnector ? .5 : 1) * bm0.dD(vecYTFlat);// HSB-9036
		double lengths[] = { U(60), U(80), U(100), U(115), U(120), U(140), U(160), U(180), U(200)};
		for (int i=lengths.length()-1; i>=0 ; i--) // HSB-9036
			if(lengths[i]<=dL)
			{
				dL = lengths[i];
				break; 
			}
		articleNumber+=dL+"-B";	
		int nQtySub = (bDoubleConnector ? 2 : 1) * nDiamB;
		if (bm0.bIsDummy())nQtySub = 0;
		HardWrComp hwc(articleNumber, nQtySub); // the articleNumber and the quantity is mandatory		
		hwc.setManufacturer(sHWManufacturer);
		hwc.setModel(hwc.articleNumber());
		hwc.setName(T("|Peg|"));
		hwc.setDescription(T("|Peg|") + "12x" +dL );
		hwc.setMaterial("S 235 JR");
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(_ThisInst);	
		hwc.setCategory(T("|Fixtures|"));
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		hwc.setCountType(_kCTAmount);
		hwc.setDScaleX(dL);
		hwc.setDScaleY((U(12)));
		hwc.setNotes((nHWAssignment ==1 ? sMountingProduction : sMountingOnSite) +";" + _ThisInst.posnum()+";" + additionalNotes);

		hwcs.append(hwc);// apppend component to the list of components
	}
// add sub componnent
	{ 
		HardWrComp hwc("CNA4.0x50", nDiamA*nQty); // the articleNumber and the quantity is mandatory		
		hwc.setManufacturer(sHWManufacturer);
		hwc.setModel(hwc.articleNumber());
		hwc.setName(T("|Nail|"));
		hwc.setDescription(T("|Nail|"));
		hwc.setMaterial("C9D");
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(_ThisInst);	
		hwc.setCategory(T("|Fixtures|"));
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		hwc.setCountType(_kCTAmount);
		hwc.setDScaleX(U(50));
		hwc.setDScaleY((U(7.4)));
		hwc.setNotes((nHWAssignment !=2 ? sMountingProduction : sMountingOnSite) +";" + _ThisInst.posnum()+";" + additionalNotes);

		hwcs.append(hwc);// apppend component to the list of components
	}

// make sure the hardware is updated
	if (_bOnDbCreated)	setExecutionLoops(2);
	String compareKey = scriptName() + "_"+additionalNotes + "_"+sFamily + "_"+sThisModel + "_"+hwcs.length();
	setCompareKey(compareKey);
	_ThisInst.setHardWrComps(hwcs);	
	//endregion





#End
#BeginThumbnail
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
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`*I:J#_9L^#@[#5VJ>I@MITX`W?+TH`H2H)O"AC;JUN!P?:O%)
MBIN)%7MP>>X&*]HBF+^%0^=A6-D&"1C:2/Z5XQ<6QMKV9"RN&<N"&W'!.1GW
MK6E\1C6^$910.E%=)RA1110`4E+2'A30!<T.QFEOGOS&P@A!42_P[L8`S]":
MVK!"LER3P-^`*R=!U)+6SO+(JK/<E71BQ^4J&SQWR&]>WY;6GIMLP<?,Q)Y^
MM8ZW-UL6J***8D%%%%`!2.BR*5==RGL:6B@`TRZN=%F)@)EM2V7A;M[C\ZU/
M[:T:[ECWM)I]TWRJW*E>2!SZ5ETUT61=KC(]#4."9:FT=O8:M)&NR[^="<QS
MIR"#DC/^-:;+;7]J5PLT+<=?3C\Z\L6*[M/^/*Y94SDQ$D`_T[>E:6E:_=V+
M!"@63=\\)XCD'<CT/^?:LW%HT4TSJTM=3TA'^S_Z5;!@50??Q5JTUR*5UBGC
M:&7'W6&/\BG6.M6E\JKO,<A'*,#P<XX/UJY=64%['LGB#?[0X(_&I+)?/A_Y
MZ+^8J4,#R.:Q?^$;LMHV-/&X((82'.1]:JR66JZ6?-M;C[7"IRT3##X]O4T`
M=)FEK,L-8M[PE,E90<%".<UI4`+1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`5%<#_1Y!G&5/-2U#<L%M92W0*?Y4`<P]R++P5.[=VD`_%CC^8KRF[96N
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
M04AA1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`5@3DIXM
MMR2=KK@?7:?\/UK?K"U^(QR6]\H.;=MV>WXT`5_%CB/3P[$8+`#/&.QKQB$8
MB&/YYKV/Q:B7WA5KB(O@JKQX.#@X->47UDVG7CVS_P`(#*?56&1_A]0:VH[F
M%;9%>BBBN@Y@HHHH`****`(7E\N[@!.%SAN<#![GZ5W/3C^=<$QQ?1GR_,PR
MD(>^#T^E=[TK)[FRT04444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!534680*BCEF`Y-6ZH:@W[RU3C&_
M)-#&MSJM`GAN;C3;,*0]J&=Q^9'ZD5W!Z<5PGA"U==9:YD.`\3+']`1_A7=_
M>'3\ZYWN="V,31+<)>7LV[+-*V?S-;HZ5C:)]Z\`3&)V7]36SVI#"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`JEJB;]/F`7)VX%7:AN
M2!;2_P"X:`.4U>X=/"D4"NFYE*88\]<"O.-;O([[5)98@FQ0L:L%`W;1@G(Z
M\YYZXQ]*[",RWVF:F78?Z!!-(F>03ABOZ_RKSJW.8A6U'<QK;$M%%%=!RA11
M10`4444`2VEH9&GN^JVZKP.N2<#\.M=</N@BN8MBJZ;=-O*NSQKM]1ECG\P/
MSKH;-_,LXGSG*C^59/XC=?#<FHHHH$%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!56\B5Q"Q.`LJY..QX/Z?
MRJU5/4GVVFW=M9G`'\Z3V&MST*U55U^/:,*+7"X_AZ5N]!T_`5RGAJ07=_)<
MEV=O(08QQGC/ZJ:ZOM7/U.DR-#)+WA(*YF8[3U'-;`Z5SVAR,=6U)2PVK*W`
M/3FNA'2@!:***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"J
M&KW`MM.F<MLRN-V.E7ZQO$JEM%F4#KC-`')S6T]MI-];6USM:\L'<D1YW'&X
MC\06&?<'M7G$(Q$*]8OWCMX]/E=MJR6OEYZ8)3;7E$7$8K>B<]?H/HHHK<YP
MHHHH`****`+%H1_I`(Z0$C/U%;VE.'T^(@?+CC%<L9A#,I);:P9#@^HX_6NJ
MTN,)I\0&0",X/:LGN:P^$N4444#"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****!A1110(*HZH#]GC(/20<5>JEJ66@C0
M'`:09I,:W.D\$R2K?SP#/EF/<<GZ8_+G\S7>CI7!^#H$&IM(6;=Y1XSP`./\
M:[WM6#W.A;&%ID837]5VJ%#,I./I6[6':N(O$M[$<Y?:V?\`@-;8Z4ABT444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%5-13S+&9,XRN,X
MJW5#56*Z=/@X...:`.6U5#<>&;7(#2+-L!/4JKD"O-+J-(;RXBC&$25E4>P-
M>CZ]+-9>$X)B$9%4MR,Y).1T]\5YA'_JQ6]$PK[(?1116YS!1110`4444`1-
M")YXT]%9B/?C%=L@"1JH&,#I7&(`MVL@/(0X'J>*[*-Q)$KCH5S63W-H_"/H
MHZ44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M_GI2"&:XECB@'+,%+?W23@5I'PWK$BGRX\,#@&3:!_.I<DBE%O8SL$44R\2;
M2=0%A><R$95@.O3T^M/ZTT[B:MN%%%%,052U4`V6XG&Q@0:NU3U3_CP?IU'!
M^HI,:W.U\$VQ_LM;L@A94"J#WYR3^9-=7VKG_!LRR^%K+:!\BE"!V.:Z#M6#
MW.DQ+^-X]>LYH<YD5E<>N,$?SK;[5A:B['Q)81C@*A8\]<G']*W>U(!:***`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"LK7XVDTN0+VP<XZ
M5JU2U7/]F7&#CY*`.9\2JO\`PB=J&52"@7D<#C^5>7W5F^GW+VLN-R$8(Z%3
MT/Y=J]+UI99/`ZL.71'(+=!R<?A7EWF/,6E<_.Q+-GU/M6U$PKBT445T',%%
M%%`!1110`PL$EB8CHV/\:ZO3GWVNP_P$K7&7;@%0>GK74:`'^Q;SP&5>/7'^
M16;6MS6+TL:U%%%(84444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`444=J`-3PO"+O69"PW1PX?[N1N`('Y9S7?[>A(&?I7%^$9H[6YD@X`F
M&,D_Q@L1^8/Z5VO:N>6YT1V.%\0Z--?Z[-&\J@2QJ]L73(5EQWXQS]?O5SL;
MR1NUO<@I.G4&O1->MC+8^<G^LMV\Q3@=,_,/\^E<_P"*[:*;3[354.R8':QQ
M]\'CFJC*S%.-U<P^E%(IR,CI2UL8(*JZBNZQDX]/YU:ILB;XV3^\,4,%N=1\
M/"!X<"9!*R'(KK^U>??#VY*S2VN#M,61Z<,?\:]`'2N9[G2MCG[S>_BVU`0[
M4AR3C_:KH:Q5!'B>0ECCRQ@$]L?XUL]J!BT444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%9NMS"#2IF*[@1C%:58WB0_\`$GFX/'H<4`9N
MKVKCP1Y`!60Q9PQ^Z3S7D)D:261VQEG).![U[3XFDV>&IGQG:F[&?;K7B4#;
MH\GJ3DFMJ.YC6V):***Z#E"BBB@`HHHH`?::?)>O<2[3Y,)56.?XB"0/R!_*
MNFT]2EA&",9!/UK$TW4&AANM.;[DQ$B<#A@,$?B/RQ[UO6;%K.,D8."/RK+6
MYLEH3T444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`%FS81GS5<"6.164%L\#/./J<?C^7I8/`[<5Y'>27,<.;8^S#U'''^175:
M8]QK42)-?S1DJN82-H((SQC`/?\`*L9K4W@]#5UK6+:&SN(8R9IMK*53D+]3
MT'2N<O[B36/!BA+?;);NK-&&R&7=@%?6NQLM)M[&,")03ZMS6-XHMGM;22_M
MV"28*,!QNSP/R)S4+<M['(0L&B4@Y!'6GU5T^0RVN_:5RQ^4C&*M5T+8YK68
M4AX!/M2TC?<?Z?TIL74V?`:;KF60R`E854(!^==X.E>>_#_>)"Q!PZ-@D>FW
M_P"O7H0Z5S/<Z5L8=Z@C\1VD@=@TD9##'!VGC^9K<'`K!U[<M_IQ4D-N8<''
M'%;PZ4#%HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*RM
M>B,NER(O4G/-:M9>NS-#IDCH>1Q0!SGB^>Z'@`/!$7,B1K(1_`I[_P!/QKR>
MV8-%P>*]NU)4B\(20W8RK6P5Q_P'G_"O$;4?N0>YK>B85B>BBBMSF"BBB@`H
MHHH`9$0-2B+':N",^^#786H_T6,?[-<E;6\5QJ($LK1[4+*0H.649`]NAKK;
M7BTB]E'\JR>YJMB:BBB@84444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%7[*\BAC0RMY;V[;H&"D9SG<"1SUJA28!!!Z$8-)JY2=F>
MA6VL6<ENK//&C="I;N*Q?$VH6MW$+5)HVC"LSD<X.,+^M<K&AC!`D?:3TW<4
MR.UBB;<J\DY)/K6?L[,MU"8+L&T=NV****U,@J&[_P"/24CJ%.*FIDR>9"Z9
MZJ0*!HZ7PC"D'V18S\IM<\GN3DC\_P"5=D#D`^M>=>$93OL?F+,9G0Y/`&WL
M/SKT7MS7.]SHCL8NOJ,V3=&$V`?J*V(V#QJP'49K'U]DS9(Q^8S@@>O;^M;"
M*%C51T`P*0Q]%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!6)XD9OL"Q#&)&`8$=JVZQ?$V!I#G(#`C!]*`,OQ[<RVOA6X\A=S,NW`'/7G
M\AFO((!B'`S^->P^*?*ET2#S/GBE`!SWR`/ZUY9?:;-I5S]FE_NAU?!`93T/
M/Y?4$5M1,:R*U%%%=)RA1112`****`(8]W]J1*!US@?48KN$4(BJ.BC%<%-,
M]M=PS)C<C;@#WKNX7,D$;LFQF4$KZ>U9O<UCL/HHHI#"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HZ44<]1
MVH`?X0<IJ\`VG_6\#L/E;/\`2O4>U>:>$9%&KQI*3L%Q)C(X!V\5Z6.G-<\M
MSHCL8FHC.O6*-]W:Q&1QG(_S^%;8Z5S_`(@++>Z<5)'SL#CW(KH.@I%"T444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%8WB;_D"S<D>Z]:
MV:J:A%YUA,@[KW%`'%^(996T[0X1(-LGED[NF`*Y'Q7JJ:MK321!1#`@@C(_
MB`SD]?4G!],5U&NS-_PC,-V21]F62-2!_$"0HQSWQ^=><Q_ZL<Y]ZVHK6YC6
M=D/HHHKH.4****`"BBB@`AM3/?6[L/W:..O<D]/I79GK7(Z;('U:.!F^4-NQ
MGV_^L*Z[I65]39+0****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`H^E%'09H`FT!@I+L%`:^QR1GJH_PK
MT[M7G/A(Q7=S:QN-SQRL^"OL3_A^5>C#I7.]SI6QB:ZP,]BBJ3+YNX`>@Z_S
M%;8Z"L"_9I/%%F@7B./)Q_M'_P"Q%=!2&%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!5:]D6*RF=B0H4]*LU1U;_`)!D_/\`#0!YAXUF
MG@\.Z?:QKB&XF>1V`Y)#';S].?P'I7(Q\1C^@KU+Q-90S^';,S$%0BC;CAAU
M->92Q"":6$/O$;E0P'WL'&:Z*+.:LGN-HHHK8P"BBB@`II8(I/I3J9*NZ-E%
M,"M!<>5J<,V,?.`:[^O-I\C:,<AJ]!L-W]GV^_._REW9ZYP*R>YK'8L4444A
MA1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4=**.>GOQ0!J>!8HWN"63#QJ2H_$C/^?6O0!T%>>^!,G5[HD8(
M5N/0;A@_SKT(=*YWN=*V,*_62'Q)9RHV%E0JV1QQ_P#KK>K#U=?.U33X-^WE
MFSCKTK<I#"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`K
M+U^?R-)F8C*D8.!DUJ55OXO.LID&`2IP30!RVN_-X4M(^,%%QG_/I7E.4W2>
M6<Q[SM/MGBO5-1G$_AFW*CYD9HP!ST.!_3\Z\QN[-K&X>$JP4_.F>Z]OQ[?4
M&M:.YC6V(J***ZCE"BBBD`4=Z*2@"A*@>Z7@D$XPHY///XUZ$@*H`>PKA+0J
M-;M5Q]V5>A[Y_P#KBN\Z=*S9L@HHHI`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!39'\N&1_P"ZI/Z4ZH[A
M3);R(.ZD"AAU-/X<NZW5VC)\LL8;>>I(/(_7->BCI7`>`\K(G!^>-FY^H'%=
M^.E<SW.E;&#=(\WBRW`?`B@SM/3DFMX=*P=206^O65UN*AU,;#/7'2M_M0,*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"HI@6A=0,D@@
M5+36Z4`<)+#]FT>5&/W+HDYY&<#/^-<)KDTDFINK,3'$BK&,8PN-W\R:[C6;
MI;/0[VXD'W+AMH(^\>`/S/%>;>>]P\DLA^=F)/M[5K1^(QK/07IQ11172<H4
M444`%)2T4`9[2&+4Q(AVE6#?B,5Z$K!U5E.Y2,@^M>>7G%VI`_A_K7=Z?_R#
M;7_KBG\A69JBS1112&%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444#"BBB@04<8.>F**CG<QP2./X5R*&'4U?`RFVO@D
MA.Z2)@@(XQG<,5Z&.E<'X9F-P^ES%=L@9HW&?1*[P<#%<SW.E;&'KJE[[3U`
MRVYB!^*UNCI7/R;;GQ6JDL#;Q\#MDX/'X8KH!TH&%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!33SD"G4WIG%`'#W<'G27%A-'MBDG3<
M`<L0V03[<8KSC4]/.E:[?6.3MAE(4DY.WJN?P(KT#4]2,-Y=7+QAFBD5E0G@
MXR:\\U#4)]4UB>]N-OFS'<0.@&``OT`%;4C&M8CZ<44`8&**Z#E"BBB@`HHH
MH`S[D&2]0!=W(``_SZUZ#$BQQ)&@PJJ%`]A7GUVACF1U)^]D'T.:[VUE,]G!
M*P`9XU8X]QFLV:Q)J***0PHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`.@SFC(]OSJ2VM?MM[%!N(RP&`"2<YYXQZ>M;[^"#)\LE\
M43.?W2MD^W)-9N=C10NKG.9HI-9M1H>L_98F::`KN8$YV9QC/O@$TH((RIW#
MU%6G<AJP4444Q!4=PADMI$!P2I`J2C_]5`=32\&JD4EA(SD^<SY![,`1_2O0
MAT%>8^#'>6^MXPG^KF9LYZ`J?\*].'2N=[G2MC!D9;?Q6HVG=-&#GWX7^0K?
MKG-73[)KEGJ+L/*_U1R0,'M71*=R@CO2&+1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4T\9-.IK?=-`'G6NQ[#J$L87:(2&'J65AG^?X
MUYO$?,D,G;M7J&KRO::3?W<!Q/'*S*6&0"%R#C_/2O,8!B*MJ)A7W):***Z#
MF"BBB@`HHHH`J7<32O"B#<Q;`'U-=Y%&L421H/E10JCV%<=:S&#5[64!&VN!
MAQQR<?\`UZ[627SI6EVJN]BVU>@SS@5D[W-DM!M%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1T&:*/K0!K>#86FU:XNO+S'&NT-G
MHW/^)KOATK@_#5XEE=K$QPLK;"HZ9)RI_/BN][5SRW.B.QQ^N:'9RZPT]TA,
M5TNTMN(V,``"/?I^5<O<6L^D7@L[D,V?]5(3]ZO1-:@\_2YL`;TQ(N?8Y_D*
MYSQ4%D\-6=XZ?O4=0&`Y`IQD[A*-T8/3I12*VY0V.M+6Y@%1S.4@D88R%XS4
ME5[Y-]E(`<$#/2D+J:'@S=%J<"84/(P8X]-K5Z;VKS+PBJR:S9D8#1\9]?E8
MG^E>FUC+<Z([&;K,$=QI5P)!G8OF*<9P1R*=H\_VC3(GW;CC!..]/U0XTJ\.
M#_J6X'T-5/#(*Z+&#U!(-24;%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!32.#3J2@#SO7\V]MJ=NQ+D(TBKCC@$G^8%>;6_^J'->@^,
M;N:._O"0&18_+`S@C=Q_*O/K;_5YZ5O1,*Y-1116YS!1110`4444`4KF39<1
MG'0@X^AKOP`J@`8P.E<%<H'N8<G`+#=7>@@J"#D'H:R>YM'86BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`N6,R1AT^[(2KJ
MQZ#;G_$?K7H$EW!`!YLJ+VY/4^U>5W=L;F(`,RD=,'_/^?K72Z)':2?9OML'
M[YON3#(!QP<Y/7(Q6,UJ;4WI8T-0U.\U&"XM=)M]P*%1*_&2?3/UK&N(+^X\
M-RZ??\7UN1+$,XW@'E?3.,_I7=0PQP1[(D55`Z#M7/\`C&)%T=Y@668<(5&3
M[G\JA;FC.-A??",@@C@CT-257LQ*+?,PPY8DX.<U8KH6QS/<*CG7?;RJ.ZD#
M/TJ2CZ]/2F(C\&2?\5%98/RD/N'OM)_I^M>L#I7C.F+-;>*$BMU;S'(:+V/7
M\A7LPZ5A+<WA>QEZS<B&U6'!+7#A`!Z9Y_S[U<L;<6UG'$#G`K)U,*VOZ<K#
M=PQY[<@_X5OCI4EA1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4QV"J6)Q@4^J&K7*6FG32.2!MQG&<4`>0^-KB6?5V//EG=\PSM)`QCZ
M@?\`H7TKG[?B(5Z3X@T5+S0+-5(`;,BLV0/,;/7VZ9]J\V@!5`K?>!P?K712
M=SFJIK4EHHHK8P"BBB@`HHHH`GT[RO[7M_-B\R/:^5QU^4X_6NK%L]H/LSE2
M\1V$J>,CBN7TF'S=<L\G"B09./4@8_6NSU(@ZI=D=//?&/\`>-8OXC=+W45:
M***8@HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*G
MANV@AD0C(.&4YP48'[P_SZ5!1Q2:N--HZJQ\86IMHTG#-,JX<AEY]^M9>K>)
M;74W\BW$N%5U=2,`D\9R.O>L<(HY"@'U%`15Z**A0UN6ZCL.QBBBBM#,***!
M0`_1(B/&%K(0`-N0<@]C^7XUZB.E>5Z)>'_A*K>.)?NN`Q!Z[@!UKU0=*PGN
M=$=C"\0Q!I=/E!(99]O!QP1_B!6ZIRH/M6'K9,U]8VZ\_,9"/H1_]>MP<#FI
M*%HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*QO$Q*Z-,
M0"V!RHK9K&\2MMT>0DX`(.:`.>U]GBT[2T4LP=45ESUS7`:TT3:Q<B)-BJ0A
M&`/F488\9SD@FO1O&";OL(WLHW`!E..O'3\:\H7A>I^IK:CNS"OLAU%%%=!S
M!1110`4444`7]&AE?48I(G"LKJH]02W\N*ZB>WDLYG@E^_&=I/.#[@^E8/@[
M$GBZT@="58[LX/\`"":Z34_^0O>'C_7O^/S&L?M,Z/L(JT444R0HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M*:[;(V;!.!V^E.I""58#TH`?X+@6YU>+<FYE(E)],`D?KBO4NU>8_#\./$,R
MG^"W*D?\"%>G"L);G3'8PMOVCQ6SE"5ACVAL\`XS_6M[M6):'R?$E]$=W[T!
MUXXZ#/\`*MNI&%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!65KXB_LF;S6VJ<<XS6K6+XF!.BSCGD=`,T`<CXWFF&BZ;(#^\$8)(XZJ<
MG^OUQ7GJ\*/I7I_C=DGT&Q<*PBD(#`#D*1S7F`Z#'I6]$YZXZBBBMSG"BBB@
M`HHHI@7-!OSI_B"*2-<2,I`;CC((Z?K^%=/7'V4`?589"=JIC)![YZ5V%8_:
M-T_="BBB@04444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%'0<T5!=OY=I*V0/E('UH&C5\"2;;]I6B(\]G5&_#
M/]*]&'2O/O!V?-LXL\QR2$C&."E>@CI7.]SHCL8-QO\`^$I4*K$&%02#TYK>
MK"GE$7BF,<9>(+GVS6Z.E(8M%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!5+5`/[.FR,_+5VLCQ'(\6DR,C%3[4`<WXJQ)X1T^(.%9F0X
M;C(P?TSBO-KEO,NIG\KR<R,?+_N<]/PKO_$]VMMI5C+(^=EFKA2/E8M@8_'@
M5YX7>1C)*<R.=S'W/6MZ)SUN@4445N<X4444`%%%%`&KHL2AI+B93]G21%D.
M>BMN!(]QVK=4[E!K.V65EX)25)@;J\N/G"CE0C=#]`2?7YQ5ZW):!21CVK'[
M1T6]U$E%%%,D****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"J>H@FUQQ@NN<^G2KE07BAK.4$<;>E)C6YM^%`P
MU2V)/#;L>^%/^?PKT#M7'Z4J+J&FF-`D0B(3![;<YKL!R!6#W.A;&(S)-XG9
M,?-%&,D_G6Y6!.ZQ^*UP!N>)01Z\G_"MX=!2&+1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`50U9=VFS?+NPO0U?JCJI*Z;.P."%ZT`><
M_$`B3PGI,Z1NH5]A/&%P.AYSU7(^AKBE^X#C''2O2-=LH[_P5;12'EG)#8R0
MVX\UYOY;Q$Q2##H=K#/<5O1.:L+1116Y@%%%%`!1110#'1SR*XMT(Q(Z,01W
M!X_GTZ'N.F.OB79&J@8P.E<?:+NU.,8&>.OU%=D*R:U-H[!1110,****!!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!4-X-UG*O3Y3TJ:H;PA;23/<8H`U-`U,AM.MV4GR9?EP<?*W&/P+?CTKT;M
M7FNE0O;Z+'?;`,R`(3UPN<G_`#Z5Z5VKG>YT1V.?U&-!XEL95`\PQMGGG@\?
MUKH:Y\^7-XK??'\T$8`)/MGC\S70=J104444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!124M`!1110`444F:`%HHI*`%HI*6@
M`HHHH`****`"BBB@`HHHH`**2EH`****`"BBB@`HHHH`**2EH`**3-+0`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
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
;Z*<$4=!3J*`$Q12T4`)B@4M%`"8HI:*`/__9
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
        <int nm="BreakPoint" vl="908" />
        <int nm="BreakPoint" vl="865" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19431 depth slot corrected" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="7/4/2023 9:02:16 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15932: set hardware qty to 0 if dummy male beam" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="7/6/2022 10:51:27 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14106 display published for hsbMake and hsbShare" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="12/21/2021 8:26:16 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12460 instance will be assigned to I-Layer of female beam" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="6/30/2021 12:49:45 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End