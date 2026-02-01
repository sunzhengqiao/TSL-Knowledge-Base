#Version 8
#BeginDescription
This tsl creates hangers between T-connected beams and trusses
#Versions
Version 1.25 19.03.2025 HSB-23725 top mounted hangers bugfix
Version 1.24 13.03.2025 HSB-23403 new angle deviation toggle, angled hangers improved, web stiffeners improved, new command to disable stretching
Version 1.23 03.03.2025 HSB-23403 accepting hangers in range of angles
Version 1.22 19.02.2025 HSB-23507 Add/Edit Product: cancel will not prompt for entites
Version 1.21 11.12.2024 HSB-23101 invalid tagging configuration does not break insertion, issue reporting enhanced
Version 1.20 22.11.2024 HSB-23031 new property to specify group assignment
Version 1.19 19.11.2024 HSB-22462 new context commands to specify tag behaviour, validation of products specified in manufacturer definitions
Version 1.18 14.11.2024 HSB-22462 auto product detection improved, new command to filter manufacturers, new bulk insertion for beam connections

1.17 20.10.2023 20231020: Fix when finding valid products; on creation check backers again to consider neighbouring instances
1.16 06.10.2023 HSB-19651: add trigger to import manufacturer; fix when getting dX,dY of profile 
1.15 06.10.2023 HSB-20091: fix for width matching in auto selection 
1.14 06.10.2023 HSB-20088: Fix multiple male beam insert
1.13 28.09.2023 HSB-20089: Add property for the backer blocks and web stiffeners 
1.12 28.09.2023 HSB-20089: in auto selection check the hanger doesnt collide with the female beam
1.11 27.09.2023 HSB-20090: merge backer blocks if they intersect 
1.10 27.09.2023 HSB-20088: Improve distribution of male-female connections 
1.9 26.09.2023 HSB-20087: Add behaviour copy with beams 
Version 1.8 18.03.2022 HSB-14325 element based orientation enhanced , Author Thorsten Huck
Version 1.7 17.03.2022 HSB-14325 bugfixes on multi insert , Author Thorsten Huck
Version 1.6 16.03.2022 HSB-14325 web stiffener and backer blocks excluded as reference beams , Author Thorsten Huck
Version 1.5 16.03.2022 HSB-14325 skewed connevctions corrected
Version 1.4 15.03.2022 HSB-14929 custom fixtures added
Version 1.3 14.03.2022 HSB-14929 default fixtures added
Version 1.2 14.03.2022 HSB-14928 supports splitting of male or female beams
Version 1.1 11.03.2022 HSB-14924 backer block creation improved
Version 1.0 25.02.2022 HSB-14805 default suppliers improved, export command of current manufacturer added
Version 0.9 25.02.2022 HSB-14805 localisiation of manufacturers supported
Version 0.8 22.02.2022 HSB-14791 stiffeners and backer blocks added for EWP products
Version 0.7 21.02.2022 HSB-14325 supporting adjustable height straps, new helper command to print command string
Version 0.6 07.02.2022 HSB-14325 cloning and multiple insertion supported
Version 0.5 04.02.2022 HSB-14325 skewed hangers added
Version 0.4 04.02.2022 HSB-14325 skewed hangers added
Version 0.3 03.02.2022 HSB-14325 custom product definition added
Version 0.2 02.02.2022 HSB-14325 supports marking, predefinied joist ranges, top flush alignment
Version 0.1   26.01.2022   HSB-14325 initial beta version


































#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 25
#KeyWords hanger;Simpson;Strong;Tie;Wuerth;Screw;Hardware
#BeginContents
//region Part #1

//region <History>
// #Versions
// 1.25 19.03.2025 HSB-23725 top mounted hangers bugfix , Author Thorsten Huck
// 1.24 13.03.2025 HSB-23403 new angle deviation toggle, angled hangers improved, web stiffeners improved, new command to disable stretching , Author Thorsten Huck
// 1.23 03.03.2025 HSB-23403 accepting hangers in range of angles. , Author Thorsten Huck
// 1.22 19.02.2025 HSB-23507 Add/Edit Product: cancel will not prompt for entites , Author Thorsten Huck
// 1.21 11.12.2024 HSB-23101 invalid tagging configuration does not break insertion, issue reporting enhanced , Author Thorsten Huck
// 1.20 22.11.2024 HSB-23031 new property to specify group assignment , Author Thorsten Huck
// 1.19 19.11.2024 HSB-22462 new context commands to specify tag behaviour, validation of products specified in manufacturer definitions , Author Thorsten Huck
// 1.18 14.11.2024 HSB-22462 auto product detection improved, new command to filter manufacturers, new bulk insertion for beam connections. , Author Thorsten Huck
// 1.17 20.10.2023 20231020: Fix when finding valid products; on creation check backers again to consider neighbouring instances Author: Marsel Nakuci
// 1.16 06.10.2023 HSB-19651: add trigger to import manufacturer; fix when getting dX,dY of profile Author: Marsel Nakuci
// 1.15 06.10.2023 HSB-20091: fix for width matching in auto selection Author: Marsel Nakuci
// 1.14 06.10.2023 HSB-20088: Fix multiple male beam insert Author: Marsel Nakuci
// 1.13 28.09.2023 HSB-20089: Add property for the backer blocks and web stiffeners Author: Marsel Nakuci
// 1.12 28.09.2023 HSB-20089: in auto selection check the hanger doesnt collide with the female beam Author: Marsel Nakuci
// 1.11 27.09.2023 HSB-20090: merge backer blocks if they intersect Author: Marsel Nakuci
// 1.10 27.09.2023 HSB-20088: Improve distribution of male-female connections Author: Marsel Nakuci
// 1.9 26.09.2023 HSB-20087: Add behaviour copy with beams Author: Marsel Nakuci
// 1.8 18.03.2022 HSB-14325 element based orientation enhanced , Author Thorsten Huck
// 1.7 17.03.2022 HSB-14325 bugfixes on multi insert , Author Thorsten Huck
// 1.6 16.03.2022 HSB-14325 web stiffener and backer blocks excluded as reference beams , Author Thorsten Huck
// 1.5 16.03.2022 HSB-14325 skewed connevctions corrected , Author Thorsten Huck
// 1.4 15.03.2022 HSB-14929 custom fixtures added , Author Thorsten Huck
// 1.3 14.03.2022 HSB-14929 default fixtures added , Author Thorsten Huck
// 1.2 14.03.2022 HSB-14928 supports splitting of male or female beams , Author Thorsten Huck
// 1.1 11.03.2022 HSB-14924 backer block creation improved , Author Thorsten Huck
// 1.0 25.02.2022 HSB-14805 default suppliers improved, export command of current manufacturer added , Author Thorsten Huck
// 0.9 25.02.2022 HSB-14805 localisiation of manufacturers supported , Author Thorsten Huck
// 0.8 22.02.2022 HSB-14791 stiffeners and backer blocks added for EWP products , Author Thorsten Huck
// 0.7 21.02.2022 HSB-14325 supporting adjustable height straps, new helper command to print command string , Author Thorsten Huck
// 0.6 07.02.2022 HSB-14325 cloning and multiple insertion supported , Author Thorsten Huck
// 0.5 04.02.2022 HSB-14325 skewed hangers added , Author Thorsten Huck
// 0.4 04.02.2022 HSB-14325 skewed hangers added , Author Thorsten Huck
// 0.3 03.02.2022 HSB-14325 custom product definition added , Author Thorsten Huck
// 0.2 02.02.2022 HSB-14325 supports marking, predefinied joist ranges, top flush alignment , Author Thorsten Huck
// 0.1 26.01.2022 HSB-14325 initial beta version , Author Thorsten Huck

/// <insert Lang=en>
/// Select properties and desired entities to be connected
/// </insert>

// <summary Lang=en>
// This tsl creates hangers between T-connected beams, trusses and panels
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "GenericHanger")) TSLCONTENT
// to insert with a certain product family of a manufacturer append an additional argument with manufacturer and family name separated by a question mark
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "GenericHanger" "StrongTie?ITSE")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsbkauRecalcTslWithKey (_TM "|Flip Side|") (_TM "|Select hanger|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Report Issues|") (_TM "|Select hanger|"))) TSLCONTENT
//endregion



//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;

	String tDefault =T("|_Default|");
	String tLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String tNo = T("|No|"), tYes = T("|Yes|"), sNoYes[] = {tNo, tYes};

//region DialogService
	String sDialogLibrary = _kPathHsbInstall + "\\Utilities\\DialogService\\TslUtilities.dll";
	String sClass = "TslUtilities.TslDialogService";	
	String listSelectorMethod = "SelectFromList";
	String optionsMethod = "SelectOption";
	String simpleTextMethod = "GetText";
	String askYesNoMethod = "AskYesNo";
	String showNoticeMethod = "ShowNotice";
	String showMultilineNotice = "ShowMultilineNotice";
	String showDynamic = "ShowDynamicDialog";
	
	String kRowDefinitions = "mpRowDefinitions";
	String kControlTypeKey = "ControlType";
	String kHorizontalAlignment = "HorizontalAlignment";
	String kLabelType = "Label";
	String kHeader = "Header";
	String kIntegerBox = "IntegerBox";
	String kTextBox = "TextBox";
	String kDoubleBox = "DoubleBox";
	String kComboBox = "ComboBox";
	String kCheckBox = "CheckBox";
	String kLeft = "Left", kRight = "Right", kCenter = "Center", kStretch = "Stretch";		
//endregion 

//region Color and view	
	int bIsDark;{int n = getBackgroundTrueColor();bIsDark = ((rgbR(n) + rgbB(n) + rgbG(n)) / 3 < 127);}
	int grey = bIsDark?rgb(199,200,202):rgb(99,100,102);
	int white = bIsDark?rgb(255,255,255):rgb(0,0,0);	
	
	int lightblue = rgb(204,204,255);
	int blue = rgb(69,84,185);	
	int darkblue = rgb(26,50,137);	
	int yellow = rgb(241,235,31);
	int darkyellow = rgb(254, 204, 102);
	int orange = rgb(242,103,34);
	int red = rgb(205,32,39);
	int purple = rgb(147,39,143);
	int petrol = rgb(16,86,137);
	int green = rgb(19,155,72);	

	Vector3d vecXView = getViewDirection(0);
	Vector3d vecYView = getViewDirection(1);
	Vector3d vecZView = getViewDirection(2);
	double dViewHeight = getViewHeight();	
//endregion 	


	String kAuto =T("|<Automatic>|"),kDisabled =T("|<Disabled>|");

	String tFrontMarking = T("|Front Side|");
	String tBackMarking = T("|Back Side|");
	String tBottomMarking = T("|Bottom Side|");
	String tTopMarking = T("|Top Side|");
	
	String kFullNailing = T("|Full Nailing|"), kPartialNailing = T("|Partial Nailing|");
	String kFixture = "Fixture", kFixtures = "Fixture[]", kNumHeaderFull="Header", kNumJoistFull="Joist", kNumHeaderPartial="Header Partial", kNumJoistPartial="Joist Partial";
	String tFixture = T("|Fixture|"), tArticle=T("|Article|"), tArticleDescription=T("|Defines the articlenumber of the fixture|");
	String kFixtureModeDescription = T("|Defines the pattern of the fixture.|");
	String tEntryName = T("|Entry Name|");
	// hardware keys
	String kName = "Name", kScaleX = "ScaleX", kScaleY = "ScaleY", kScaleZ = "ScaleZ", kQuantity = "Quantity", kNotes = "Notes", kCategory = "Category",
		kMaterial = "Material", kGroup = "Group", kModel = "Model", kDescription = "Description", kHardWrComp = "HardWrComp",kHardWrComps = "HardWrComp[]";
	
	// map keys
	String kProduct = "Product", kProducts = "Product[]", kColor="Color", kLength = "Length", kGap = "Gap";
	String kFamily = "Family", kFamilies = "Family[]";
	String kMinWidthJoist = "Joist\\MinWidth", kMaxWidthJoist="Joist\\MaxWidth", kMinHeightJoist="Joist\\MinHeight", kMaxHeightJoist="Joist\\MaxHeight";
	String kAlphaMin = "MinAlpha", kAlphaMax="MaxAlpha";
	String kAdjustableHeight = "Adjustable Height Strap";
	String kGeneric = "GenericHanger_";
	String kTag = "Tag", kTagSeqColor = "Tag\\SequentialColor[]", tTMDisabled = T("<|Disabled|>"), tTMSetTag = T("|Set Tag|"), tTMCreateTag = T("|Set + Create Tag|"), sTagModes[] ={ tTMDisabled,tTMSetTag,tTMCreateTag };
	String tSTriangle=T("|Triangle|"), tMidCenter = T("|Mid-Center|"), tTopCenter = T("|Top-Center|");
	
	
	String kArticle = "ArticleNumber", kManufacturer = "Manufacturer", kAlpha= "Alpha";
	int nc = 252;
	
	String kMale = "Male", kFemale = "Female";
	String kPainterCollection = "GenericHanger\\";
	String kBySelection =T("|<bySelection>|");
	String kBeam = T("|Beam|");
	String kPanel = T("|Panel|");
	String kTruss = T("|Truss|");
	String sMaleDefaultSelections[] = { kBySelection, kBeam, kTruss};
	String sFemaleDefaultSelections[] = { kBySelection, kBeam, kPanel, kTruss};
	
	String kProductDescription = T("|Defines the product, <automatic> will select the best fit|");
	String kCreateStiffBacker = "CreateStiff", kStiffs="Stiffener[]", kBackers="Backers[]", kBacker = "Backer"; 
	String sManufacturerName = T("|Manufacturer|");
	String sFamilyName = T("|Family|");
	String sProductName = T("|Product|");

	String kParameter = "Parameters";
	int nMode = _Map.getInt("mode");


//end Constants//endregion


//region DialogMode
	int nDialogMode = _Map.getInt("DialogMode");
	if (nDialogMode>0)
	{ 
		if (nDialogMode == 1)
		{
			setOPMKey("AddProduct");
	
		category = sProductName;
			PropString sManufacturer(nStringIndex++, "", sManufacturerName);	
			sManufacturer.setDescription(T("|Defines the name of the manufacturer|"));
			sManufacturer.setCategory(category);
			
			PropString sFamily(nStringIndex++, "", sFamilyName);	
			sFamily.setDescription(T("|Defines the Family|"));
			sFamily.setCategory(category);			
			
			PropString sProduct(nStringIndex++, "", sProductName);	
			sProduct.setDescription(T("|Defines the product|"));
			sProduct.setCategory(category);
			
		category = T("|Hanger Geometry|");
			String sInnerWidthName=T("|Width|");	
			PropDouble dInnerWidth(nDoubleIndex++, U(0), sInnerWidthName,_kLength);	
			dInnerWidth.setDescription(T("|Defines the inner width of the hanger.|"));
			dInnerWidth.setCategory(category);
			
			String sThicknessName=T("|Thickness|");	
			PropDouble dThickness(nDoubleIndex++, U(0), sThicknessName,_kLength);	
			dThickness.setDescription(T("|Defines the Thickness|"));
			dThickness.setCategory(category);
			
		category = T("|Incoming Joist|");
			String sMinWidthName=T("|Min. Width|");	
			PropDouble dMinWidth(nDoubleIndex++, U(0), sMinWidthName,_kLength);	
			dMinWidth.setDescription(T("|Defines the minimal width of the incoming joists|") + T(", |0 = any width|"));
			dMinWidth.setCategory(category);
			
			String sMaxWidthName=T("|Max. Width|");	
			PropDouble dMaxWidth(nDoubleIndex++, U(0), sMaxWidthName,_kLength);	
			dMaxWidth.setDescription(T("|Defines the maximal width of the incoming joists|") + T(", |0 = no range|"));
			dMaxWidth.setCategory(category);
			
			String sMinHeightName=T("|Min. Height|");	
			PropDouble dMinHeight(nDoubleIndex++, U(0), sMinHeightName,_kLength);	
			dMinHeight.setDescription(T("|Defines the minimal height of the incoming joists|") + T(", |0 = any height|"));
			dMinHeight.setCategory(category);
			
			String sMaxHeightName=T("|Max. Height|");	
			PropDouble dMaxHeight(nDoubleIndex++, U(0), sMaxHeightName,_kLength);	
			dMaxHeight.setDescription(T("|Defines the maximal height of the incoming joists|") + T(", |0 = no range|"));
			dMaxHeight.setCategory(category);
		}
		else if (nDialogMode == 2)
		{
			setOPMKey("Stiffener");
			
			int bBackerPossible=_Map.getInt("BackerPossible");
			int bWebStiffenerPossible=_Map.getInt("WebStiffenerPossible");
			
			int nBackerFlag=bBackerPossible?false:_kHidden;
			int nWebFlag=bWebStiffenerPossible?false:_kHidden;
		category = T("|Stiffener|");
			String sStiffName=T("|Name|");	
			PropString sStiff(nStringIndex++, T("|Web Stiffener|"), sStiffName);	
			sStiff.setDescription(T("|Defines the name of a stiffener|"));
			sStiff.setCategory(category);
			sStiff.setReadOnly(nWebFlag);

			String sStiffMaterialName=T("|Material|");	
			PropString sStiffMaterial(nStringIndex++, T("|Spruce|"), sStiffMaterialName);	
			sStiffMaterial.setDescription(T("|Defines the material of a stiffener|"));
			sStiffMaterial.setCategory(category);
			sStiffMaterial.setReadOnly(nWebFlag);
			

			String sColorStiffName=T("|Color|");	
			PropInt nColorStiff(nIntIndex++, 31, sColorStiffName);	
			nColorStiff.setDescription(T("|Defines the color|"));
			nColorStiff.setCategory(category);
			nColorStiff.setReadOnly(nWebFlag);
			
	
			String sLengthStiffName=T("|Length|");	
			PropDouble dLengthStiff(nDoubleIndex++, U(0), sLengthStiffName);	
			dLengthStiff.setDescription(T("|Defines the length of the stiffener|") + T(", |0 = byHanger|"));
			dLengthStiff.setCategory(category);
			dLengthStiff.setReadOnly(nWebFlag);
			
			
			String sExtraLengthStiffName=T("|Extra Length|");	
			PropDouble dExtraLengthStiff(nDoubleIndex++, U(0), sExtraLengthStiffName,_kLength);	
			dExtraLengthStiff.setDescription(T("|Defines the additional length|"));
			dExtraLengthStiff.setCategory(category);
			dExtraLengthStiff.setReadOnly(nWebFlag);
			
			
			String sGapStiffName=T("|Gap|");	
			PropDouble dGapStiff(nDoubleIndex++, U(10), sGapStiffName,_kLength);	
			dGapStiff.setDescription(T("|Defines the horizontal gap of the stiffener on th ebottom and top side|"));
			dGapStiff.setCategory(category);
			dGapStiff.setReadOnly(nWebFlag);
			
		category = T("|Backer Block|");
			String sBackerName=T("|Name|");	
			PropString sBacker(nStringIndex++, T("|Backer Block|"), sBackerName);	
			sBacker.setDescription(T("|Defines the name of a backer block|"));
			sBacker.setCategory(category);
			sBacker.setReadOnly(nBackerFlag);

			String sBackerMaterialName=T("|Material|");	
			PropString sBackerMaterial(nStringIndex++, T("|Spruce|"), sBackerMaterialName);	
			sBackerMaterial.setDescription(T("|Defines the material of a stiffener|"));
			sBackerMaterial.setCategory(category);
			sBackerMaterial.setReadOnly(nBackerFlag);
			

			String sColorBackerName=T("|Color|");	
			PropInt nColorBacker(nIntIndex++, 31, sColorBackerName);	
			nColorBacker.setDescription(T("|Defines the color|"));
			nColorBacker.setCategory(category);
			nColorBacker.setReadOnly(nBackerFlag);
			
	
			String sLengthBackerName=T("|Length|");	
			PropDouble dLengthBacker(nDoubleIndex++, U(0), sLengthBackerName,_kLength);	
			dLengthBacker.setDescription(T("|Defines the length of the backer block|") + T(", |0 = byHanger|"));
			dLengthBacker.setCategory(category);
			dLengthBacker.setReadOnly(nBackerFlag);
			
			
			String sExtraLengthBackerName=T("|Extra Length|");	
			PropDouble dExtraLengthBacker(nDoubleIndex++, U(0), sExtraLengthBackerName,_kLength);	
			dExtraLengthBacker.setDescription(T("|Defines the additional length|"));
			dExtraLengthBacker.setCategory(category);
			dExtraLengthBacker.setReadOnly(nBackerFlag);
			

			String sGapBackerName=T("|Gap|");	
			PropDouble dGapBacker(nDoubleIndex++, U(10), sGapBackerName,_kLength);	
			dGapBacker.setDescription(T("|Defines the vertical gap of the stiffener|"));
			dGapBacker.setCategory(category);
			dGapBacker.setReadOnly(nBackerFlag);
			
		}			
		else if (nDialogMode == 3)
		{
			setOPMKey("AddManufacturer");
			
			String list[0];
			for (int i=0;i<_Map.length();i++) 
			{ 
				if (_Map.hasString(i))
					list.append(_Map.getString(i)); 	 
			}//next i
	
			list = list.sorted();
			list.insertAt(0, T("|<none>|"));

			String sManufacturerName=T("|Manufacturer|");	
			PropString sManufacturer(nStringIndex++, list, sManufacturerName);	
			sManufacturer.setDescription(T("|Defines the Manufacturer|"));
			sManufacturer.setCategory(category);
		}	
		else if (nDialogMode == 4)
		{
			setOPMKey("RemoveManufacturer");
			
			String list[0];
			for (int i=0;i<_Map.length();i++) 
			{ 
				if (_Map.hasString(i))
					list.append(_Map.getString(i)); 	 
			}//next i
	
			list = list.sorted();

			String sManufacturerName=T("|Manufacturer|");	
			PropString sManufacturer(nStringIndex++, list, sManufacturerName);	
			sManufacturer.setDescription(T("|Defines the Manufacturer|"));
			sManufacturer.setCategory(category);
		}
		else if (nDialogMode == 5)
		{
			setOPMKey(kFixture);
			String availabilities[] ={T("|All Families|")};
			if (_Map.hasString(kProduct))
				availabilities.append(_Map.getString(kProduct));			
			if (_Map.hasString(kFamily))
				availabilities.append(_Map.getString(kFamily)); 

		category = tFixture;
			String sEntryName=tEntryName;	
			PropString sEntry(nStringIndex++, "Custom", sEntryName);	
			sEntry.setDescription(T("|Defines the unique name of a fixture definition.|") + T("|An empty hardware definition will remove an existing entry.|") + T("|Hardware entries with quantity = 0 and the name 'Header' or 'Joist' will use the default quantities of the hanger, if no name is given the sum will be assigned.|"));
			sEntry.setCategory(category);

			String sAvailabilityName=T("|Availabilty|");	
			PropString sAvailability(nStringIndex++, availabilities, sAvailabilityName);	
			sAvailability.setDescription(T("|Specifies if this fixture will be available for all families or just for the selected one|"));
			sAvailability.setCategory(category);
			if (availabilities.length()>1)sAvailability.set(availabilities[1]);
		}
		else if (nDialogMode == 6)
		{ 
			setOPMKey(kTag);
			
			String sTagModeName=T("|Tag Mode|");	
			PropString sTagMode(nStringIndex++, sTagModes, sTagModeName);	
			sTagMode.setDescription(T("|Defines how the optional tagging is performed.|") + 
				T(" |If tagging is activated, each hanger in the drawing will be assigned a tag indicating its frequency of occurrence.|") +
				T(" |The tag will be written to the model description of the instance as alphanumeric value|") + 
				T(" |Additionally, if creation is chosen, a hsbEntityTag instance will be generated concurrently with the hanger.|"));
			sTagMode.setCategory(category);
			if (sTagModes.findNoCase(sTagMode) < 0)sTagMode.set(tTMDisabled);

			String sSequentialColorName=T("|Sequential Colors|");	
			PropString sSequentialColor(nStringIndex++, "", sSequentialColorName);	
			sSequentialColor.setDescription(T("|Defines a list of color indices which will be used as a sequential replacment of a given color.|") +
				T("|Separate entries by a semicolon| ';'"));
			sSequentialColor.setCategory(category);
			
		}
		return;		
	}
//End DialogMode//endregion


//End Part #1 //endregion 


//region Functions #FU

//region ArrayToMapFunctions

	//region Function GetDoubleArray
	// returns an array of doubles stored in map
	double[] GetDoubleArray(Map mapIn, int bSorted)
	{ 
		double values[0];
		for (int i=0;i<mapIn.length();i++) 
			if (mapIn.hasDouble(i))
				values.append(mapIn.getDouble(i));
				
		if (bSorted)
			values.sorted();		
				
		return values;
	}//endregion

	//region Function SetDoubleArray
	// sets an array of doubles in map
	Map SetDoubleArray(double values[], String key)
	{ 
		key = key.length() < 1 ? "value" : key;
		Map mapOut;
		for (int i=0;i<values.length();i++) 
			mapOut.appendDouble(key, values[i]);	
		return mapOut;
	}//endregion

	//region Function GetStringArray
	// returns an array of doubles stored in map
	String[] GetStringArray(Map mapIn, int bSorted)
	{ 
		String values[0];
		for (int i=0;i<mapIn.length();i++) 
			if (mapIn.hasString(i))
				values.append(mapIn.getString(i));
				
		if (bSorted)
			values.sorted();		
				
		return values;
	}//endregion

	//region Function SetStringArray
	// sets an array of strings in map
	Map SetStringArray(String values[], String key)
	{ 
		key = key.length() < 1 ? "value" : key;
		Map mapOut;
		for (int i=0;i<values.length();i++) 
			mapOut.appendString(key, values[i]);	
		return mapOut;
	}//endregion

	//region Function GetIntArray
	// returns an array of doubles stored in map
	int[] GetIntArray(Map mapIn, int bSorted)
	{ 
		int values[0];
		for (int i=0;i<mapIn.length();i++) 
			if (mapIn.hasInt(i))
				values.append(mapIn.getInt(i));
				
		if (bSorted)
			values.sorted();		
				
		return values;
	}//endregion

	//region Function SetIntArray
	// sets an array of ints in map
	Map SetIntArray(int values[], String key)
	{ 
		key = key.length() < 1 ? "value" : key;
		Map mapOut;
		for (int i=0;i<values.length();i++) 
			mapOut.appendInt(key, values[i]);	
		return mapOut;
	}//endregion
		
//End ArrayToMapFunctions //endregion 	 	

//region Miscellaneous Functions
//region Function Equals
	// returns true if two strings are equal ignoring any case sensitivity
	int Equals(String str1, String str2)
	{ 
		str1 = str1.makeUpper();
		str2 = str2.makeUpper();		
		return str1==str2;
	}//endregion


//region Function TokenizeIntArray
	// returns the tokenized array of the given integers
	String TokenizeIntArray(int values[], String delimiter, int bSorted)
	{ 
		if (delimiter=="")
			delimiter = ";";
		if (bSorted)
			values = values.sorted();
		String out;
		for (int i=0;i<values.length();i++) 
			out+=(out.length()>0?delimiter:"")+values[i]; 
		return out;
	}//endregion

//region Function GetIntTokens
	// returns the array of ints specified in a string
	// delimter: delimter of tokens, ';' if not given
	int[] GetIntTokens(String input, String delimiter)
	{ 
		int out[0];
		if (delimiter=="")
			delimiter = ";";
		String tokens[] = input.tokenize(delimiter);
		
		for (int i=0;i<tokens.length();i++) 
		{ 
			String token= tokens[i]; 
			int n = token.atoi();
			if ((String)n==token)
				out.append(n);			 
		}//next i
		
		return out;
	}//endregion

//region Function ToAlphanumeric
	// returns the characters representing the given integer A, B, C...Z,AA, AB, AC...
	String ToAlphanumeric(int n)
	{ 		
		if (n<1)
			return "?";
	
        String out;
        while (n > 0)
        {
            n--; // adjust, 'A' starts at 1
            String sChar = char('A' + (n % 26));
            out = sChar + out;
            n /= 26;
        }

        return out;
	}//endregion
		
//endregion 

//region Get Properties Functions

//region Function GetDoubleProperties
	// returns an array of double properties specified in a mapWithPropValuesFromCatalog
	double[] GetDoubleProperties(Map mapWithPropValuesFromCatalog)
	{ 
		Map map = mapWithPropValuesFromCatalog.getMap("PropDouble[]");
		
		int indices[0];
		double values[0];
		for (int i=0;i<map.length();i++) 
		{ 
			Map m = map.getMap(i); 
			indices.append(m.getInt("nIndex"));
			values.append(m.getDouble("dValue"));
		}//next i
		
	// order ascending
		for (int i=0;i<indices.length();i++) 
			for (int j=0;j<indices.length()-1;j++) 
				if (indices[j]>indices[j+1])
				{
					indices.swap(j, j + 1);
					values.swap(j, j + 1);
				}

		return values;
	}//endregion
	
//region Function GetIntProperties
	// returns an array of int properties specified in a mapWithPropValuesFromCatalog
	int[] GetIntProperties(Map mapWithPropValuesFromCatalog)
	{ 
		Map map = mapWithPropValuesFromCatalog.getMap("PropInt[]");
		
		int indices[0];
		int values[0];
		for (int i=0;i<map.length();i++) 
		{ 
			Map m = map.getMap(i); 
			indices.append(m.getInt("nIndex"));
			values.append(m.getInt("lValue"));
		}//next i
		
	// order ascending
		for (int i=0;i<indices.length();i++) 
			for (int j=0;j<indices.length()-1;j++) 
				if (indices[j]>indices[j+1])
				{
					indices.swap(j, j + 1);
					values.swap(j, j + 1);
				}

		return values;
	}//endregion			

//region Function GetStringProperties
	// returns an array of string properties specified in a mapWithPropValuesFromCatalog
	String[] GetStringProperties(Map mapWithPropValuesFromCatalog)
	{ 
		Map map = mapWithPropValuesFromCatalog.getMap("PropString[]");
		
		int indices[0];
		String values[0];
		for (int i=0;i<map.length();i++) 
		{ 
			Map m = map.getMap(i); 
			indices.append(m.getInt("nIndex"));
			values.append(m.getString("strValue"));
		}//next i
		
	// order ascending
		for (int i=0;i<indices.length();i++) 
			for (int j=0;j<indices.length()-1;j++) 
				if (indices[j]>indices[j+1])
				{
					indices.swap(j, j + 1);
					values.swap(j, j + 1);
				}

		return values;
	}//endregion

//region Function GetEntityTagProperties
	// returns if entrie scould be read and modifies the given property arrays
	int GetEntityTagProperties(String scriptName, String& sProps[], double& dProps[], int& nProps[])
	{ 
		Map mapEntityTagProps;
		int bOk;
		
	// get catalog entries	
		String entries[] =TslInst().getListOfCatalogNames(scriptName);
		bOk = entries.length() > 0;
		int n = entries.findNoCase("GenericHanger" ,- 1);
		if (n>-1)
			mapEntityTagProps = TslInst().mapWithPropValuesFromCatalog(scriptName, entries[n]);
		else
			mapEntityTagProps = TslInst().mapWithPropValuesFromCatalog(scriptName, tLastInserted);
		

		nProps = GetIntProperties(mapEntityTagProps);
		dProps = GetDoubleProperties(mapEntityTagProps);
		sProps = GetStringProperties(mapEntityTagProps);
		
	// set defaults if no catalog found	
		if (n<0)
		{ 
			if (nProps.length()>0) 
			{
				nProps[0] = -2;	
				nProps[1] = 20;	
			}
			if (dProps.length()>0) 
				dProps[0] = U(40);
			if (sProps.length()>4) 
			{
				sProps[0] = "@(ModelDescription:D)";
				sProps[3] = tSTriangle;
				sProps[5] = tTopCenter;
			}		
		}

		return bOk;
	}//endregion		
//endregion 


//region Function FilterTslsByName
	// returns all tsl instances with a certain scriptname
	// ents: the array to search, if empty all tsls in modelspace are taken
	// names: the names of the tsls to be returned, all if empty
	TslInst[] FilterTslsByName(Entity ents[], String names[])
	{ 
		TslInst out[0];
		int bAll = names.length() < 1;
		
		if (ents.length()<1)
			ents = Group().collectEntities(true, TslInst(),  _kModelSpace);
		
		for (int i=0;i<ents.length();i++) 
		{ 
			TslInst t= (TslInst)ents[i]; 
			//reportNotice("\ngetTslsByName: " + t.scriptName() +" "+names);
			if (t.bIsValid())
			{
				if (!bAll && names.findNoCase(t.scriptName(),-1)>-1)
					out.append(t);	
				else if (bAll)
					out.append(t);									
			}
				
		}//next i

		return out;
	
	}//endregion

//region Function FindSiblings
	// returns all tsl instances with the sme scriptName
	// ents: the array to search, if empty all tsls in modelspace are taken
	// names: the names of the tsls to be returned, all if empty
	TslInst[] FindSiblings(String name)
	{ 
		TslInst out[0];
		//name = name.makeUpper();
		Entity ents[]= Group().collectEntities(true, TslInst(),  _kModelSpace);
		
		for (int i=0;i<ents.length();i++) 
		{ 
			TslInst t= (TslInst)ents[i]; 
			//reportNotice("\ngetTslsByName: " + t.scriptName() +" "+names);
			if (t.bIsValid() && name==t.scriptName())
				out.append(t);										
		}//next i


//	// order alphabetically
//		for (int i=0;i<out.length();i++) 
//			for (int j=0;j<out.length()-1;j++) 
//				if (out[j].handle()>out[j+1].handle())
//				{
//					out.swap(j, j + 1);
//				}

		return out;
	
	}//endregion


//region Function GetEntityArray
	// returns a validated set of entities
	// entities defined in map().getEntityArray() could be invalid
	Entity[] GetEntityArray(Map map, String key)
	{ 
		Entity ents[] = map.getEntityArray(key + "[]", "", key);
		
	// purge invalid
		for (int i=ents.length()-1; i>=0 ; i--) 
			if (!ents[i].bIsValid())
			{
				if (bDebug)reportMessage("\npurging " + key +" at " +i);
				ents.removeAt(i); 
			}
		return ents;
	}//endregion


//region Function IsValidProductDefinition
	// returns if the minmal required parameters are defined in the product map
	// product: name of the product
	int IsValidProductDefinition(Map mapProduct, String product)
	{ 
		int isValid = true;		
		Map m = mapProduct;
		
		if (!m.hasDouble("A") || m.getDouble("A")<dEps)
			isValid = false;
		else if (!m.hasDouble("t") || m.getDouble("t")<dEps)
			isValid = false;
		return isValid;
	}//endregion



//region Function GetManufacturerMap
	// returns the manufacturer map
	Map GetManufacturerMap(String manufacturer, Map maps)
	{ 
		Map mapManufacturer;
		for (int i=0;i<maps.length();i++) 
		{ 
			Map m = maps.getMap(i);
			String name = m.getMapName(); 
			if (Equals(name, manufacturer)) 
			{ 
				mapManufacturer = m;
				break;
			}
		}//next i		
		return mapManufacturer;
	}//endregion

//region Function GetFamilyMap
	// returns the submap of a family specified by the family name 
	Map GetFamilyMap(String family, Map mapFamilies)
	{ 
		Map map;
		for (int i = 0; i < mapFamilies.length(); i++)
		{
			Map m = mapFamilies.getMap(i);			
			String name = m.getMapName();
			if (Equals(name, family))
			{
				map = m;
				break;
			}
		}	
		if (map.length()<1)
			reportMessage("\n" + scriptName() + ":" +T("|Unexpected error reading family data.|"));

		return map;
	}//endregion

//region Function CollectManufacturersInUse
	// returns
	String[] CollectManufacturersInUse()
	{
		String sUsedManufacturers[0];
		String names[] = { (bDebug?"GenericHanger":scriptName())};
		Entity ents[0];
		TslInst hangers[] = FilterTslsByName(ents, names);
		for (int i=0;i<hangers.length();i++) 
		{ 
			String manufacturer= hangers[i].propString(0);
			if (sUsedManufacturers.findNoCase(manufacturer,-1)<0)
				sUsedManufacturers.append(manufacturer);
			 
		}//next i
		
		return sUsedManufacturers;
	}//endregion

//region Function GetActiveEntries
	// Manufacturer and Family selection helper function
	// returns the amount of active entries and modifies the two arrays containing the label (row description) and a boolean if the row is selected as active
	// map: a map containing rows with each row having a string and int
	int GetActiveEntries(Map map, String& entries[], int& actives[])
	{ 
		int numActive;
		
		entries.setLength(0);
		actives.setLength(0);
		
		for (int i=0;i<map.length();i++) 
		{ 
			Map row= map.getMap(i);
			String entry= row.getString(0);
			int active= row.getInt("Active")==true;				

			entries.append(entry);
			actives.append(active);
			numActive += active ? 1 : 0;
		}
			
		return numActive;
	}//endregion

//region Function GetFamilyList
	// returns the list of families or products of the parent map and stores the corresponding map list
	String[] GetMapList(Map mapParent, Map& mapChilds, String key)
	{ 
		mapChilds = Map();
		String entries[0];
	// get the models of this family	
		Map _mapChilds = mapParent.getMap(key+"[]");
		for (int i = 0; i < _mapChilds.length(); i++)
		{
			Map m = _mapChilds.getMap(i);			
			String name = m.getMapName();
			//reportNotice("\nkey: " +key+" name = " + name);
			if (entries.findNoCase(name,-1) < 0)
			{
				entries.append(name);
				mapChilds.appendMap(key, m);
			}
		}		
		
		return entries; 
	}//endregion



//region Function ValidateProducts
	// returns a validated list of products
	void ValidateProducts(Map& mapProducts, String& products)
	{ 
		Map _mapProducts = mapProducts;
		mapProducts = Map();
		for (int i = 0; i < _mapProducts.length(); i++)
		{
			Map m = _mapProducts.getMap(i);				
			String name = m.getMapName();
			int ok = IsValidProductDefinition(m, name);
			if(ok)
				mapProducts.appendMap("Product", m);
		}		
		return;
	}//endregion


//region Dialogs

//region Function ShowManufacturerDialog
	// shows the dialog to select amufacturers
	Map ShowManufacturerDialog(Map mapIn)
	{ 
		Map rowDefinitions = mapIn.getMap(kRowDefinitions);
		int numRows = rowDefinitions.length();
		double dHeight = numRows > 10 ? 1000 : numRows * 55;

	//region dialog config
		Map mapDialog ;
	    Map mapDialogConfig ;
	    mapDialogConfig.setString("Title", T("|Manufacturer Selection|"));
	    mapDialogConfig.setDouble("Height", dHeight);
	    mapDialogConfig.setDouble("Width", 400);
	    mapDialogConfig.setDouble("MaxHeight",1000);
	    mapDialogConfig.setDouble("MaxWidth", 1000);
	    mapDialogConfig.setDouble("MinHeight", 200);
	    mapDialogConfig.setDouble("MinWidth", 400);
	    mapDialogConfig.setString("Description", T("|Specifies the manufacturers to be displayed|"));
	    mapDialog.setMap("mpDialogConfig", mapDialogConfig);				
	//endregion 

	//region Columns
		Map columnDefinitions ;
	    Map column1;
	    column1.setString(kControlTypeKey, kLabelType);
	    column1.setString(kHorizontalAlignment, kLeft);
	    column1.setString(kHeader, T("|Manufacturer|"));
	    columnDefinitions.setMap("MANUFACTURER", column1);	
	    
	    Map column2 ;
	    column2.setString(kControlTypeKey, kCheckBox);
	    column2.setString(kHorizontalAlignment, kStretch);
	    column2.setString(kHeader, T("|Active|"));
	    columnDefinitions.setMap("ACTIVE", column2);		    
	    
		mapDialog.setMap("mpColumnDefinitions", columnDefinitions);			
	//endregion 

	//region Rows
	    mapDialog.setMap(kRowDefinitions, rowDefinitions);			
	//endregion 
	
		Map mapRet = callDotNetFunction2(sDialogLibrary, sClass, showDynamic, mapDialog);
		mapRet.writeToXmlFile("C:\\temp\\mapGenericHangeManufs.xml");
		return mapRet;
	}//endregion
		
		
		
//Dialogs //endregion 

//region Beam Filtering
	

//region Function FilterBeams
	// returns the beams found in an entity array
	Beam[] FilterBeams(Entity ents[], int bAllowDummy)
	{ 
		Beam out[0];
		for (int i=0;i<ents.length();i++) 
		{ 
			Beam bm = (Beam)ents[i];			
			if(bm.bIsValid() && (!bm.bIsDummy() || bAllowDummy) && out.find(bm)<0)
				out.append(bm); 
		}//next i
		
		return out;
	}//endregion

//region Function FilterBeamsNotParallel
	Beam[] FilterBeamsNotParallel(Beam beams[], Beam bm)
	{ 
		Beam out[0];
		
		Beam bmPars[] = (bm.vecX()).filterBeamsParallel(beams);
		for (int i=0;i<beams.length();i++) 
			if (bmPars.find(beams[i])<0 && beams[i]!=bm)
				out.append(beams[i]); 
		
		return out;
	}//endregion

//region Function GetTContactPlane
	// returns the contact plane of a T-Connection
	Plane GetTContactPlane(Beam bm0, Beam bm1)
	{ 

		Vector3d vecX0 = bm0.vecX();
		Point3d ptCen0 = bm0.ptCen();
		Line lnX(ptCen0, vecX0);
		
		Point3d ptCen1 = bm1.ptCen();
		Plane pn(ptCen1, bm1.vecD(vecX0)); // default
		
		Point3d pt0;
		if (lnX.hasIntersection(pn, pt0))
		{
			if (vecX0.dotProduct(pt0-ptCen0)<0)
				vecX0 *= -1;
			pn=Plane(pt0 - bm1.vecD(vecX0) * .5 * bm1.dD(vecX0), - bm1.vecD(vecX0));
		}
		
		return pn;
	}//endregion

//region Function FilterBeamsProject
	// Filters beams of which the male projection intersects the contact face
	Beam[] FilterBeamsProject(Beam beams[], Beam bm0)
	{ 
		Beam out[0];
		
		Vector3d vecX0 = bm0.vecX();
		Point3d ptCen0 = bm0.ptCen();
		bm0.envelopeBody(false, true).vis(252);
		PlaneProfile pp0 = bm0.envelopeBody(false, true).shadowProfile(Plane(ptCen0, vecX0));
		//pp0.vis(1);
		for (int i=0;i<beams.length();i++) 
		{
			Beam bm1 = beams[i];
			if (bm1 == bm0 || bm1.vecX().isParallelTo(vecX0)) 
			{
				continue;
			}
			else
			{ 			
				Plane pnF = GetTContactPlane(bm0, bm1);
				Point3d pt0 = bm1.ptCen();
				Line lnX(ptCen0, vecX0);
				if (lnX.hasIntersection(pnF, pt0))
				{
				
					PlaneProfile pp1 = bm1.envelopeBody(false, true).extractContactFaceInPlane(pnF, dEps);
					
					PlaneProfile ppX = pp0;
					ppX.project(pnF, vecX0, dEps);
					ppX.shrink(dEps);
					PlaneProfile ppX2 = ppX;
					
					//pp1.vis(2);
					
					if (ppX.intersectWith(pp1))
					{ 
						ppX2.vis(1);	

						//pt0.vis(3);
						out.append(bm1);
					}						
					
				}
			}	
		}
		return out;
	}//endregion

//region Function GetEntityCollections
	// returns beam pack entity collections
	EntityCollection[] GetEntityCollections(Beam beams[])
	{ 
		
	// Find packs	
		String sDiffers[0];
		for (int i=0;i<beams.length();i++) 
		{ 
			String differ =  beams[i].formatObject("@(ElementNumber:D) @(isParallelToWorldX) @(isParallelToWorldZ)") + beams[i].vecX(); 
			sDiffers.append(differ); 
		}//next i			
		EntityCollection entCollections[]=Beam().composeBeamPacks(beams,sDiffers);		
		
		return entCollections;
	}//endregion
	
	
	
	
//endregion 




//endregion 



//region Part #2

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";
	String sPathCompany = sPath+"\\"+sFolder+"\\";
	
	String sFileName ="GenericHanger";
	Map mapSetting;

// compose settings file location
	String sFolders[]=getFoldersInFolder(sPath); 
	int bPathFound = _bOnInsert ? sFolders.find(sFolder) >- 1 ? true : makeFolder(sPath + "\\" + sFolder) : false;
	String sFullPath = sPath+"\\"+sFolder+"\\"+sFileName+".xml";

// read a potential mapObject
	MapObject mo(sDictionary ,sFileName);
	if (mo.bIsValid())
	{
		mapSetting=mo.map();
		setDependencyOnDictObject(mo);
	}
	// create a mapObject to make the settings persistent	
	else if ((_bOnInsert || _bOnDebug) && !mo.bIsValid() )
	{
		String sFile=findFile(sFullPath); 
	// if no settings file could be found in company try to find it in the installation path
		if (sFile.length()<1) sFile=findFile(sPathGeneral+sFileName+".xml");	
		if (sFile.length()>0)
		{ 
			mapSetting.readFromXmlFile(sFile);
			mo.dbCreate(mapSetting);			
		}
	}
	// validate version when creating a new instance
	if(_bOnDbCreated)
	{ 
		int nVersion = mapSetting.getInt("GeneralMapObject\\Version");
		String sFile = findFile(sPathGeneral + sFileName + ".xml");		// set default xml path
		if (sFile.length()<1) sFile=findFile(sFullPath);				// set custom xml path if no default found
		Map mapSettingInstall; mapSettingInstall.readFromXmlFile(sFile);	// read the xml from installation directory
		int nVersionInstall = mapSettingInstall.getMap("GeneralMapObject").getInt("Version");		
		if(sFile.length()>0 && nVersion!=nVersionInstall)
			reportNotice(TN("|A different Version of the settings has been found for| ") + scriptName()+
			TN("|You might want to consider loading the new settings.|")+
			TN("|Current Version| ")+nVersion + "	" + _kPathDwg + TN("|Other Version| ") +nVersionInstall + "	" + sFile);
	}

//region Additional Paremeters
	double dAngleDeviation;
	Map mapParameters= mapSetting.getMap(kParameter);
	dAngleDeviation = mapParameters.getDouble("AllowedAngularDeviation");
	int bAllowAngleDeviation = dAngleDeviation > 0;
//endregion 


//region Get Manufacturer Configuration from Settings
	Map mapSetupManufacturer= mapSetting.getMap("Setup\\Manufacturer");	
	String sAllManufacturers[0];
	int bActiveManufacturers[0];
	int numActive = GetActiveEntries(mapSetupManufacturer.getMap(kRowDefinitions), sAllManufacturers, bActiveManufacturers);	 
//endregion 

//region get sManufacturers from the mapSetting
	Map mapPresets = mapSetting.getMap("Manufacturer[]");
	String sPresets[0];
	for (int i = 0; i < mapPresets.length(); i++)
	{
		Map m = mapPresets.getMap(i);
		String name =m.getMapName();
		if (name.length()>0 && sPresets.findNoCase(name,-1)<0)
			sPresets.append(name);
	}	
	
	
////region Function GetMapObjectManufacturerName
//	// returns the manufacturer name stored in map of mapObject
//	void GetMapObjectManufacturerName(MapObject mo)
//	{ 
//		Map map = mo.map().getMap(kManufacturer).getMapName();
//		Map mapManufacturer = map.getMap(kManufacturer);
//		String manufacturer = mapManufacturer.getMapName();		
//		return;
//	}//endregion	
	
// collect existing mapObjects with the kGeneric name tag
	MapObject mobs[0];
	String sMobEntries[0];
	{ 
		String entries[] = MapObject().getAllEntryNames(sDictionary);
		for (int i=0;i<entries.length();i++) 
		{ 
			String& entry = entries[i];
			
		// skip any entry not being tagged kGeneric	(GenericHanger_)
			if (entry.find(kGeneric,0,false)<0)
			{
				continue;
			}

		// skip if entry is not in list of presets	
			String name = entry.right(entry.length() - kGeneric.length());
			if (sPresets.length()>0 && sPresets.findNoCase(name,-1)<0){ continue;}

		// append existing mapObject
			MapObject mob(sDictionary ,entry);
			if (mob.bIsValid())
			{
			// skip if not selected as active manufacturer
				String manufacturer = mob.map().getMap(kManufacturer).getMapName();
				int n = sAllManufacturers.findNoCase(manufacturer ,- 1);
				if (n>-1 && !bActiveManufacturers[n])
				{
					continue;
				}				

				mobs.append(mob);
				sMobEntries.append(entry);
			}
		}//next i	
	}	

// collect requested file names from preset if not mapObject not already existant
	String sReadPresets[0],sSettingFiles[0], sSettingPaths[0];	
	for (int i = 0; i < sPresets.length(); i++)
	{
		String name =sPresets[i];
		String entry = kGeneric + name;
		if (sMobEntries.findNoCase(entry,-1)<0)
			sReadPresets.append(entry);	
	}
	
// Collect paths which should be read into a mapObject
	if (sReadPresets.length()>0 || mapPresets.length()<1)
	{ 
		for (int j=0;j<2;j++) 
		{ 
			String path = j==0?sPathCompany:sPathGeneral;
			String files[] = getFilesInFolder(path, kGeneric+"*.*");

		// read only presets
			if (sReadPresets.length()>0)
			{ 
				for (int i=0;i<sReadPresets.length();i++) 
				{ 
					int n = files.findNoCase(sReadPresets[i]+".xml",-1); 
					if (n>-1 && sSettingPaths.findNoCase(files[n],-1)<0)
					{
						sSettingFiles.append(files[n]);
						sSettingPaths.append(path + files[n]);
					}
				}//next i				
			}

		// read all
			else
			{ 
				for (int i=0;i<files.length();i++) 
					if (sSettingPaths.findNoCase(files[i],-1)<0)
					{
						sSettingFiles.append(files[i]);
						sSettingPaths.append(path + files[i]);				
					}
			} 
		}//next j		
	}
	
// Create missing mapObjects
	for (int i=0;i<sSettingPaths.length();i++) 
	{ 
		String entry = sSettingFiles[i];
		if (entry.find(".xml", 0, false) > 0)entry = entry.left(entry.length() - 4);
		String path = sSettingPaths[i];
		MapObject mob(sDictionary ,entry);
		Map map; map.readFromXmlFile(path);
		mob.dbCreate(map);
		setDependencyOnDictObject(mob);
		mobs.append(mob); 
	}//next i
	
// Append to manufacturers
	Map mapManufacturers;
	String sManufacturers[0];
	for (int i = 0; i < mobs.length(); i++)
	{
		MapObject& mob=mobs[i];
		setDependencyOnDictObject(mob);
		
		Map map = mob.map();
		Map mapManufacturer = map.getMap(kManufacturer);
		String manufacturer = mapManufacturer.getMapName();
		if (manufacturer.length() > 0 && sManufacturers.findNoCase(manufacturer ,- 1) < 0)
		{
			sManufacturers.append(manufacturer);
			mapManufacturers.appendMap(kManufacturer, mapManufacturer);
		}		
	}
	sManufacturers = sManufacturers.sorted();
	
	if (sManufacturers.length()<1)
	{ 
		reportNotice("\n\n" + scriptName() + TN("|Could not find any hanger data in the search paths.|") + T(" |Please contact your local support.|"));
		eraseInstance();
		return;
	}
//endregion


//End Settings//endregion

//region Read Settings
	// Defaults	
	// ReinforcementTypes RT
	String tRTStiffener = T("|Web Stiffener|"), tRTBacker = T("|Backer Block|"), tRTBoth = tRTBacker + T(" |and| ") + tRTStiffener,
		tMaterialStiff = T("|Spruce|"), tMaterialBacker = tMaterialStiff, kExtraLength = "extraLength";
	int nColorStiff = 31,nColorBacker = 31;
	double dLengthStiff = U(500), dExtraStiff,dLengthBacker = U(500), dExtraBacker, dGapStiff= U(10),dGapBacker= U(10);
	Map mapFixtures;//#sett
	
	int nSeqColors[] = {};
	Map mapSequentialColors;
	int nTagMode;
{
	String k;
	Map m;
	
	m= mapSetting.getMap(kStiffs);
	k=kLength;			if (m.hasDouble(k))	dLengthStiff = m.getDouble(k);
	k=kExtraLength;	if (m.hasDouble(k))	dExtraStiff = m.getDouble(k);
	k=kGap;			if (m.hasDouble(k))	dGapStiff = m.getDouble(k);
	k=kName;			if (m.hasString(k))	tRTStiffener = m.getString(k);
	k=kMaterial;		if (m.hasString(k))	tMaterialStiff = m.getString(k);
	k=kColor;			if (m.hasInt(k))	nColorStiff = m.getInt(k);

	m= mapSetting.getMap(kBackers);
	k=kLength;			if (m.hasDouble(k))	dLengthBacker = m.getDouble(k);
	k=kExtraLength;	if (m.hasDouble(k))	dExtraBacker = m.getDouble(k);
	k=kGap;			if (m.hasDouble(k))	dGapBacker = m.getDouble(k);
	k=kName;			if (m.hasString(k))	tRTBacker = m.getString(k);
	k=kMaterial;		if (m.hasString(k))	tMaterialBacker = m.getString(k);
	k=kColor;			if (m.hasInt(k))	nColorBacker = m.getInt(k);

	m= mapSetting.getMap(kTag);
	k="Mode";			if (m.hasInt(k))	nTagMode = m.getInt(k);

	mapFixtures=mapSetting.getMap(kFixtures);
	mapSequentialColors=mapSetting.getMap(kTagSeqColor);
	
}
//End Read Settings//endregion 

//region Properties //#PR




	
//region Product Properties
category = T("|Product|");		

	// manufacturer of the product
	PropString sManufacturer(0, sManufacturers, sManufacturerName);
	sManufacturer.setDescription(T("|Defines the name of the manufacturer|"));
	sManufacturer.setCategory(category);
	sManufacturer.setControlsOtherProperties(true);
	int nManufacturer = sManufacturers.find(sManufacturer);
	if (nManufacturer<0){ sManufacturer.set(sManufacturers.first()); nManufacturer=0;}
	
	// Family
	Map mapFamilies,mapManufacturer, mapLibFixtures;
	String sFamilies[0];
	PropString sFamily(1, sFamilies, sFamilyName);	
	sFamily.setDescription(T("|Defines the Family|"));
	sFamily.setCategory(category);
	sFamily.setControlsOtherProperties(true);
	int nFamily;
	Map mapFamily;

	// Product
	Map mapProducts;
	String sProducts[0];
	sProducts.insertAt(0, kAuto);
	PropString sProduct(2, sProducts, sProductName);	
	sProduct.setDescription(kProductDescription);
	sProduct.setCategory(category);
	sProduct.setControlsOtherProperties(true);
	int nProduct;
	//endregion 
	
category = T("|Tooling|");
	String sStretchMaleName=T("|Stretch Incoming Joist|");	
	PropString sStretchMale(10, sNoYes, sStretchMaleName,1);	
	sStretchMale.setDescription(T("|Defines if the incoming joist will be stretched to the main joist.|"));
	sStretchMale.setCategory(category);

	String sGapName=T("|Gap|");	
	PropDouble dGap(nDoubleIndex++, U(0), sGapName,_kLength);	
	dGap.setDescription(T("|Defines the Gap|"));
	dGap.setCategory(category);

	String sBaseDepthName=T("|Base Depth|");	
	PropDouble dBaseDepth(nDoubleIndex++, U(0), sBaseDepthName,_kLength);	
	dBaseDepth.setDescription(T("|Defines the depth of a beamcut at the base of the hanger to apply flush mounting|"));
	dBaseDepth.setCategory(category);

	String sMarkingName=T("|Marking|");	
	String sMarkings[] = { tFrontMarking, tBackMarking, tBottomMarking, tTopMarking};
	sMarkings = sMarkings.sorted();
	for (int i=0;i<4;i++) 
		sMarkings.append(sProductName+" + "+sMarkings[i]); 
	sMarkings.insertAt(0, kDisabled);
	PropString sMarking(5, sMarkings, sMarkingName);	
	sMarking.setDescription(T("|Defines the marking strategy|"));
	sMarking.setCategory(category);
	if (sMarkings.findNoCase(sMarking ,- 1) < 0)sMarking.set(kDisabled);

	String tGAMale = T("|Male Genbeam|"), tGAFemale= T("|Female Genbeam|"),
		tGAMaleJ = tGAMale+ T(", |Layer J|"), 
		tGAFemaleJ = tGAFemale+ T(", |Layer J|"), tGANone = T("|None|"), 
		sGroupAssignments[] = { tGAFemale,tGAMale,tGAFemaleJ, tGAFemaleJ, tGANone};
	String sGroupAssignmentName=T("|Group Assignment|");	
	PropString sGroupAssignment(9, sGroupAssignments, sGroupAssignmentName);	
	sGroupAssignment.setDescription(T("|Defines the group assignment of the hanger.|") + T("|The group of the hanger will be set if the corresponding genbeam is assigned to a group.|"));
	sGroupAssignment.setCategory(category);

category = T("|Fixture|");
	String sFixtureArticles[0];
	sFixtureArticles.insertAt(0, kDisabled);
	String sFixtureArticleName=tEntryName;	
	PropString sFixtureArticle(6, sFixtureArticles, sFixtureArticleName);	
	sFixtureArticle.setDescription(tArticleDescription);
	sFixtureArticle.setCategory(category);
	int nFixtureArticle = -1;

	String sFixtureModes[] = { kFullNailing, kPartialNailing};
	String sFixtureModeName=T("|Mode|");	
	PropString sFixtureMode(7, sFixtureModes, sFixtureModeName);	
	sFixtureMode.setDescription(kFixtureModeDescription);
	sFixtureMode.setCategory(category);
	int nFixtureMode = -1;


//region Selection Properties
category = T("|Selection|");
	String sSelectionDescription = T("|The selection supports certain types which can also be defined by painter definitions.|") + 
		T("|The painter definition may be stored in a collection named 'GenericHanger' in which case it will only collect definitions within this collection.|") +
		T("|If no such collection is found all painters matching the supported types will be collected.|");
	String sPainters[] = PainterDefinition().getAllEntryNames().sorted();
	// if a collection was found consider only those of the collection, else take all
	int bHasPainterCollection; 
	for (int i=0;i<sPainters.length();i++) 	{if (sPainters[i].find(kPainterCollection,0,false)>-1){bHasPainterCollection=true;break;}}//next i
	if (bHasPainterCollection)
		for (int i=sPainters.length()-1; i>=0 ; i--) 
			if (sPainters[i].find(kPainterCollection,0,false)<0)
				sPainters.removeAt(i);	
	sPainters = sPainters.sorted();
	
	String sMaleSelections[0];		sMaleSelections = sMaleDefaultSelections;
	String sFemaleSelections[0];	sFemaleSelections = sFemaleDefaultSelections;
	for (int i=0;i<sPainters.length();i++) 
	{ 
		PainterDefinition pd(sPainters[i]);
		String type = pd.type();
		
		int bValidMaleType = type == kBeam;
		int bValidFemaleType = type == kBeam|| type == kPanel;
		
		
		String painter = sPainters[i];
		int n = painter.find("\\", 0, false);
	// append collection painters without the collection name	
		if (painter.find(kPainterCollection,0,false)>-1) 
		{ 
			String s = painter.right(painter.length() - n - 1);
			if (sMaleSelections.findNoCase(s,-1)<0 && bValidMaleType)
				sMaleSelections.append(s);
			if (sFemaleSelections.findNoCase(s,-1)<0 && bValidFemaleType)
				sFemaleSelections.append(s);				
		}
	// ignore other collections	
		else if (!bHasPainterCollection && n <0) 
		{
			if (bValidMaleType)sMaleSelections.append(painter); 
			if (bValidFemaleType)sFemaleSelections.append(painter); 			
		}
	}//next i
	
	String sMaleSelectionName=T("|Male|");	
	PropString sMaleSelection(3,sMaleSelections,sMaleSelectionName);
	sMaleSelection.setDescription(T("|Defines the selection mode for the male entities.| ") + sSelectionDescription);
	sMaleSelection.setCategory(category);
	sMaleSelection.setReadOnly(_bOnInsert ||bDebug?false:_kHidden);
	
	String sFemaleSelectionName=T("|Female|");	
	PropString sFemaleSelection(4,sFemaleSelections,sFemaleSelectionName);
	sFemaleSelection.setDescription(T("|Defines the selection mode for the female entities.| ")+sSelectionDescription);
	sFemaleSelection.setCategory(category);	
	sFemaleSelection.setReadOnly(_bOnInsert ||bDebug?false:_kHidden);

category=T("|Stiffener|");
	String sStiffenerName=T("|Stiffener|");
	String sStiffeners[] ={ kDisabled, tRTBacker, tRTStiffener, tRTBoth};
	PropString sStiffener(8,sStiffeners,sStiffenerName,3);	
	sStiffener.setDescription(T("|Defines the selection mode for the web stiffener and the backer block|"));
	if (sStiffeners.findNoCase(sStiffener ,- 1) < 0)sStiffener.set(kDisabled);
	sStiffener.setCategory(category);
//endregion 


//region Function setReadOnlyFlagOfProperties
	// sets the readOnlyFlag
	void setReadOnlyFlagOfProperties()
	{ 	
		Map mapM = GetManufacturerMap(sManufacturer, mapManufacturers);
		mapManufacturer = mapM; // assign copy else debugging fails
		
		sFamilies = GetMapList(mapManufacturer, mapFamilies, kFamily);
		sFamily.setEnumValues(sFamilies);
		Map mapF = GetFamilyMap(sFamily , mapFamilies);
		mapFamily = mapF;// assign copy else debugging fails
		nFamily = sFamilies.find(sFamily );
		if (nFamily<0){ sFamily.set(sFamilies.first()); nFamily=0;}

		sProducts= GetMapList(mapFamily, mapProducts, kProduct);
		ValidateProducts(mapProducts, sProducts);
		sProducts.insertAt(0, kAuto);
		sProduct.setEnumValues(sProducts);
		nProduct = sProducts.find(sProduct);
		if (nProduct<0){ sProduct.set(sProducts.first()); nProduct=0;}
		
		sFixtureMode.setReadOnly(sFixtureArticle == kDisabled ? _kHidden : false);
		dGap.setReadOnly(sStretchMale == tNo? _kHidden : false);
		
		
//		Property.setReadOnly(HideCondition?_kHidden:false);
		return;
	}//endregion	



//End properties//endregion 


//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) {eraseInstance(); return;}
		
	//region Dialogs
		// silent/dialog
		if (_kExecuteKey.length()>0 && TslInst().getListOfCatalogNames(scriptName()).findNoCase(_kExecuteKey,-1)>-1)
			setPropValuesFromCatalog(_kExecuteKey);						
		// standard dialog	
		else	
		{
			setPropValuesFromCatalog(tLastInserted);
			setReadOnlyFlagOfProperties();
			while (showDialog("---") == _kUpdate) // _kUpdate means a controlling property changed.	
			{ 
				setReadOnlyFlagOfProperties(); // need to set hidden state
			}						
		}

		setReadOnlyFlagOfProperties();	
	//endregion 

	//region Male Selection
		PainterDefinition pdMale;
		if (bHasPainterCollection && sPainters.findNoCase(kPainterCollection +sMaleSelection,-1)>-1)
			pdMale = PainterDefinition(kPainterCollection + sMaleSelection);
		else if (sPainters.findNoCase(sMaleSelection,-1)>-1)
			pdMale = PainterDefinition(sMaleSelection);
			
		String prompt = T("|Select male entities|") + T(", |(optional all entities for automatic bulk creation)|");
		
	// prompt for entities
		Entity males[0];
		PrEntity ssMale;			
		if (sMaleSelection == kBeam || (pdMale.bIsValid() && pdMale.type() == kBeam))
		{
			prompt = T("|Select male beams|");
			ssMale=PrEntity (prompt, Beam());
		}
		else if (sMaleSelection == kTruss|| (pdMale.bIsValid() && pdMale.type() == kTruss))
		{
			prompt = T("|Select male trusses|");
			ssMale=PrEntity (prompt, TrussEntity());
		}
		else
		{ 
			ssMale=PrEntity (prompt, Beam());
			ssMale.addAllowedClass(TrussEntity());			
		}

		if (ssMale.go())
			males.append(ssMale.set());	
		
	//endregion 

	//region Female Selection
		PainterDefinition pdFemale;
		if (bHasPainterCollection && sPainters.findNoCase(kPainterCollection +sFemaleSelection,-1)>-1)
			pdFemale = PainterDefinition(kPainterCollection + sFemaleSelection);
		else if (sPainters.findNoCase(sFemaleSelection,-1)>-1)
			pdFemale = PainterDefinition(sFemaleSelection);
			
		prompt = T("|Select female entities|");
		String prompt2 = males.length() > 1 ? T(", |<Enter> to auto insert|") : "";
	// prompt for entities
		Entity females[0];
		PrEntity ssFemale;			
		if (sFemaleSelection == kBeam || (pdFemale.bIsValid() && pdFemale.type() == kBeam))
		{
			prompt = T("|Select female beams|");
			ssFemale=PrEntity (prompt+prompt2, Beam());
		}
		else if (sFemaleSelection == kTruss|| (pdFemale.bIsValid() && pdFemale.type() == kTruss))
		{
			prompt = T("|Select female trusses|");
			ssFemale=PrEntity (prompt+prompt2, TrussEntity());
		}
		else if (sFemaleSelection == kPanel|| (pdFemale.bIsValid() && pdFemale.type() == kPanel))
		{
			prompt = T("|Select female panels|");
			ssFemale=PrEntity (prompt+prompt2, Sip());
		}		
		else
		{ 
			ssFemale=PrEntity (prompt+prompt2, Beam());
			ssFemale.addAllowedClass(TrussEntity());
			ssFemale.addAllowedClass(Sip());
		}

		if (ssFemale.go())
			females.append(ssFemale.set());	


		if (pdMale.bIsValid() && females.length()>0) // use painter if not bulk insertion
			males = pdMale.filterAcceptedEntities(males);

		if (pdFemale.bIsValid())
			females = pdFemale.filterAcceptedEntities(females);
	//endregion 

	//region Purge stiffeners and backer blocks
		int numStiff, numBacker;
		for (int i=males.length()-1; i>=0 ; i--) 
		{ 
			Beam b=(Beam)males[i]; 
			if (b.bIsValid() && (b.type()==_kEWPBacker_Block || b.type()==_kEWPWeb_Stiffener))
			{
				numStiff = numStiff + (b.type() == _kEWPWeb_Stiffener ? 1 : 0);
				numBacker = numBacker + (b.type() == _kEWPBacker_Block ? 1 : 0);
				males.removeAt(i);	
			}
		}//next i
		for (int i=females.length()-1; i>=0 ; i--) 
		{ 
			if (males.find(females[i])>-1)
			{ 
				//reportNotice("\nfemale found in male selection " + i);
				females.removeAt(i);
				continue;
			}
			
			Beam b=(Beam)females[i];
			if (b.bIsValid() && ((b.type()==_kEWPBacker_Block || b.type()==_kEWPWeb_Stiffener) || males.find(b)>-1))
			{
				numStiff = numStiff + (b.type() == _kEWPWeb_Stiffener ? 1 : 0);
				numBacker = numBacker + (b.type() == _kEWPBacker_Block ? 1 : 0);				
				females.removeAt(i);	
			}
		}//next i	
		if (numStiff>0 ||numBacker>0)
		{ 
			reportMessage("\n"+(numStiff>0?numStiff + T(" |Web Stiffeners|"):"") + 
				(numBacker>0 && numStiff>0?" + ":"") +
				(numBacker>0?numBacker + T(" |Backer Blocks|"):"") +
				T(" |removed from selection set|")) ;
			
		}
	//endregion 

	//region Check conditions for bulk insertion of beams HSB-22462
		Beam bmMales[] = FilterBeams(males, false);
		Beam bmFemales[] = FilterBeams(females, false);
		if (bmMales.length()>1 && bmFemales.length()==0)
		{ 
			_Map.setInt("mode", 9);
		}
		else if (males.length()<1 || females.length()<1)
		{ 
			reportMessage("\n"+ scriptName() + T(" |Invalid selection set.| ")+T("|Tool will be deleted.|"));
			eraseInstance();
			return;
		}
		else if (nTagMode == 2)
			_Map.setInt("mode", 2);
		_Map.setEntityArray(males, false, kMale+"[]", "", kMale);
		_Map.setEntityArray(females, false, kFemale+"[]", "", kFemale);
		
		return;			
	//endregion 

	}	
	setReadOnlyFlagOfProperties();
	//if (_bOnDbCreated)_ThisInst.setDebug(true);
// end on insert	__________________//endregion	
	
//End Part #2 //endregion 


//region onDbErase

	//region Function PurgeStiffenerAndBackers
		// purges stiffeners or backer blocks associated with this hanger
		void PurgeReinforcements(Map map)
		{ 
			int num;
			for (int i=0;i<map.length();i++) 
			{ 
				Entity e = map.getEntity(i);
				if (e.bIsValid())
				{
					e.dbErase();	
					num++;
				}
			}//next i	
			if (num>0)
				reportMessage("\n" + scriptName() + ": " +num +T(" |additional reinforcement items purged| "));
			
			return;
		}//endregion

	addRecalcTrigger(_kErase, TRUE);	
	if (_bOnDbErase)
	{ 
		PurgeReinforcements(_Map.getMap(kStiffs));
		PurgeReinforcements(_Map.getMap(kBackers));
		return;
	}
//endregion 

//region Collect references from map
	int nProps[]={};			
	double dProps[]={dGap,dBaseDepth};				
	String sProps[]={sManufacturer,sFamily,sProduct,sMaleSelection, sFemaleSelection,sMarking,sFixtureArticle, sFixtureMode,sStiffener,sGroupAssignment,sStretchMale};
	Entity entMales[] = GetEntityArray(_Map, kMale);
	Entity entFemales[] = GetEntityArray(_Map, kFemale); 	
	
// Store ThisInst in _Map to enable debugging with subMapX until HSB-22564 is implemented
	TslInst this = _ThisInst;
	if (bDebug && _Map.hasEntity("thisInst"))
	{
		Entity ent = _Map.getEntity("thisInst");	
		this = (TslInst)ent;
	}
	else if (!bDebug && (_bOnDbCreated || !_Map.hasEntity("thisInst")))
		_Map.setEntity("thisInst", this);



	double A, B, C, D, E, F,G,H,I,J,K,AlphaMin, AlphaMax, Alphas[0], dThickness, dMinWidth, dMaxWidth, dMinHeight, dMaxHeight;
	int bHasAdjustableHeightStrap;
	String url, material, articleNumber;
	{ 
		material = mapFamily.getString(kMaterial);
		url = mapFamily.getString("url");
		if(url.length()>0)	
			_ThisInst.setHyperlink(url);
		//_ThisInst.setHyperlink("https://www.strongtie.co.uk/en-UK/products/joist-hanger-with-adjustable-height-strap-jha/");
	}

	if (sProducts.length()<2)
	{ 
		reportMessage("\n"+ scriptName() + ": "+ T("|Could not find product data of family| ") + sFamily+ T(". |Tool will be deleted.|"));
		eraseInstance();
		return;	
	}	
	
	
//endregion 

//region Distributor Mode
	if (nMode == 9)
	{ 

		PainterDefinition pdMale;
		if (bHasPainterCollection && sPainters.findNoCase(kPainterCollection +sMaleSelection,-1)>-1)
			pdMale = PainterDefinition(kPainterCollection + sMaleSelection);
		else if (sPainters.findNoCase(sMaleSelection,-1)>-1)
			pdMale = PainterDefinition(sMaleSelection);

		PainterDefinition pdFemale;
		if (bHasPainterCollection && sPainters.findNoCase(kPainterCollection +sFemaleSelection,-1)>-1)
			pdFemale = PainterDefinition(kPainterCollection + sFemaleSelection);
		else if (sPainters.findNoCase(sFemaleSelection,-1)>-1)
			pdFemale = PainterDefinition(sFemaleSelection);	

		//bDebug = true;
		
		
	//region Automatic male/female detection
		if (entMales.length()>1 && entFemales.length()<1)
		{ 
			Beam beams[] = FilterBeams(entMales, false); // get all non dummies
			if (pdMale.bIsValid() && pdMale.type()=="Beam")
				beams = pdMale.filterAcceptedEntities(beams);

			reportMessage("\n" + T("|Starting bulk creation of hangers for beams| (")+ beams.length() +"), ");

		//Prerequisites for creation of tag instance: hsbEntityTag
			String sTagProps[0];
			double dTagProps[0];
			int nTagProps[0];
			int bTagDataOk;
			if (nTagMode==2)
				bTagDataOk = GetEntityTagProperties("hsbEntityTag", sTagProps, dTagProps, nTagProps);

		// find males
			Beam males[0];
			for (int i=0;i<beams.length();i++) 
			{ 
				Beam bm0= beams[i];
				Beam bmOthers[]= FilterBeamsNotParallel(beams, bm0);
				
				Vector3d vecX2 = bm0.vecX() * .5 * bm0.solidLength();
				//LineSeg seg(bm0.ptCen() - vecX2, bm0.ptCenSolid() + vecX2);//seg.vis(3);
				bmOthers=  bm0.filterBeamsCapsuleIntersect(bmOthers);//, seg, (bm0.dH()<bm0.dW()?bm0.dH():bm0.dW())*.45); 				
				bmOthers = FilterBeamsProject(bmOthers, bm0);
				
				if (bmOthers.length()>0)
				{
					males.append(bm0);
					//bm0.realBody().vis(211);
				}		
//				if (bDebug)
//					for (int j=0;j<bmOthers.length();j++) 
//						bmOthers[j].realBody().vis(i+2); 
			}//next i
			
		// Find Male packs
			EntityCollection entMaleCollections[] = GetEntityCollections(males);
			reportMessage(entMaleCollections.length() + T(" |male collections found|\n"));
			TslInst hangers[0];

		// Find females	for each pack
			for (int i=0;i<entMaleCollections.length();i++) 
			{ 
				Beam males[] = entMaleCollections[i].beam(); 
				if (males.length()<1){ continue;}
				Beam bm0 = males.first();
				Point3d ptCen0 = bm0.ptCen();
				//bm0.realBody().vis(253);
				Beam bmOthers[]= FilterBeamsNotParallel(beams, bm0);
				bmOthers=  bm0.filterBeamsCapsuleIntersect(bmOthers);
				bmOthers = FilterBeamsProject(bmOthers, bm0);
				
				if (pdFemale.bIsValid() && pdFemale.type()=="Beam")
					bmOthers = pdFemale.filterAcceptedEntities(bmOthers);
				
				//EntityCollection entFemaleCollections[] = GetEntityCollections(bmOthers);
				
			// Build couples
				for (int j=0;j<bmOthers.length();j++) 
				{ 
					Beam bm1 = bmOthers[j]; 
					//bm1.realBody().vis(252);
					//PLine (bm0.ptCen(), bm1.ptCen()).vis(i);
					Beam females[] ={bm1};// TODO packs not supported yet

					Plane pnF = GetTContactPlane(bm0, bm1);
					Point3d pt0;
					Line(bm0.ptCen(), bm0.vecX()).hasIntersection(pnF, pt0);

					Vector3d vecYC = bm0.vecX();
					if (vecYC.dotProduct(pt0 - ptCen0) < 0)vecYC *= -1;
					Vector3d vecXC = bm0.vecD(bm1.vecX());
					
					

				// create TSL
					TslInst tslNew;
					GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {pt0};
					
					Map mapTsl;	
					
					mapTsl.setEntityArray(males, false, kMale+"[]", "", kMale);
					mapTsl.setEntityArray(females, false, kFemale+"[]", "", kFemale);								
					
					if (!bDebug)
					{
						tslNew.dbCreate(scriptName() , vecXC ,vecYC,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
						
						if (tslNew.bIsValid())
						{
							hangers.append(tslNew);
							
						//region Create tag instance: hsbEntityTag
							if (nTagMode==2)
							{ 
								Point3d ptTag = tslNew.ptOrg() - tslNew.coordSys().vecZ()  * (dTagProps.length()>0?.25*dTagProps[0]:0);
			
							// create TSL
								TslInst tslTag;
								GenBeam gbsTsl[] = {};		Entity entsTsl[] = {tslNew};			Point3d ptsTsl[] = {ptTag};
								Map mapTsl;	
											
								if (!bDebug)
									tslTag.dbCreate("hsbEntityTag" , tslNew.coordSys().vecX() ,-tslNew.coordSys().vecZ(),gbsTsl, entsTsl, ptsTsl, nTagProps, dTagProps, sTagProps,_kModelSpace, mapTsl);								
								
							}
						//endregion 							
						}
						reportMessage(".");
	
					}
					else
						PLine (bm0.ptCen(), bm1.ptCen()).vis(i);
				}//next j
			}//next i
	
		// trigger the last hanger to assign tags
			int num = hangers.length();
			if (num>0 && nTagMode>0)
			{
				TslInst& t = hangers.last();
				
				Map m = t.map();
				m.setInt("AddTags", true);
				t.setMap(m);

			}
			reportMessage("\n" + num + T(" |hangers created.|"));
		}
	//endregion 

		if (bDebug)
		{ 
			Display dp(4);
			dp.textHeight(U(200));
			dp.draw(scriptName(), _Pt0, _XW, _YW, 0, 0);			
		}
		
		if (!bDebug)eraseInstance();
		return;
	}
//endregion 

//region Part #3 Get Connection

//region Collect references and cast to supported classes
	Element el0, el1;
	Beam bmMales[0], bmFemales[0], bm0, bm1;
	TrussEntity teMales[0], teFemales[0], te0, te1;
	Sip sipMales[0], sipFemales[0], sip0, sip1;
	Body bodies[0], bd0, bd1;// bodies: same length as pps and entAlls
	PlaneProfile pps[0]; // same length as bodies and entAlls
	
	Entity entsAll[0];	// same length as bodies and pps

	if (entMales.length()<1 || entFemales.length()<1)
	{ 
		reportMessage("\n"+scriptName()+" "+T("|No male or female found|"));
		eraseInstance();
		return;
	}
	
	for (int mf=0;mf<2;mf++) 
	{ 
		Entity ents[0];	Beam beams[0]; TrussEntity trusses[0];Sip sips[0] ;
		if (mf==0)ents =entMales;
		else if (mf==1)ents =entFemales;

		for (int i=0;i<ents.length();i++) 
		{ 
			Entity& ent= ents[i]; 
			Beam bm = (Beam)ent;
			TrussEntity te = (TrussEntity)ent;
			Sip sip = (Sip)ent;
			Body bd;
			CoordSys cs;

			if (bm.bIsValid())
			{ 
				if (bm.type() == _kEWPBacker_Block || bm.type() == _kEWPWeb_Stiffener){continue;}
				bd = bm.envelopeBody(true, true);
				beams.append(bm);
				cs = CoordSys(bm.ptCenSolid(), bm.vecY(), bm.vecZ(), bm.vecX());
			}
			else if (sip.bIsValid())
			{ 
				bd = sip.envelopeBody(false, true);
				sips.append(sip);
				cs = CoordSys(sip.ptCenSolid(), sip.vecY(), sip.vecZ(), bm.vecX());
			}			
			else if (te.bIsValid())
			{ 
				CoordSys cst = te.coordSys();cst.vis(2);				
				TrussDefinition td(te.definition());
				Beam _beams[] = td.beam();
				for (int i=0;i<_beams.length();i++) 
					bd.addPart(_beams[i].envelopeBody(false, true));
				bd.transformBy(cst);
				//bd.vis(mf);
				trusses.append(te);
				cs = CoordSys(bd.ptCen(), -cst.vecZ(), cst.vecY(), cst.vecX());
			}
			
			//if (mf==0)bd.vis(251);
			PlaneProfile pp(cs);
			pp.unionWith(bd.shadowProfile(Plane(cs.ptOrg(), cs.vecZ())));	//pp.vis(i);
			if (entsAll.find(ent)<0)
			{ 
				pps.append(pp); // pp of sip could fail if X-Axis does not match vecX1, to be adjusted later on
				bodies.append(bd);
				entsAll.append(ent);
				
				_Entity.append(ent);
				
			}
			
		}//next i
		
		if (mf==0)
		{ 
			bmMales = beams;
			teMales = trusses;	
			sipMales = sips;
		}
		else if (mf==1)
		{ 
			bmFemales = beams;
			teFemales = trusses;
			sipFemales = sips;
		}		
		 
	}//next mf		
	
	//reportNotice("\nStarting " + _ThisInst.handle() + " males " + bmMales.length() + " females " + bmFemales.length()); 	
	for (int i=0;i<_Entity.length();i++) 
		setDependencyOnEntity(_Entity[i]); 

	_ThisInst.setAllowGripAtPt0(false);
	
// HSB-20087: Add behaviour copy with beams for E,S,T,X,G
//	setEraseAndCopyWithBeams(_kAllBeams);
	if(_Beam.length()==2)
		setEraseAndCopyWithBeams(_kBeam0);
//endregion 

//region Tool and ref CoordSys
	Vector3d vecX0,vecY0,vecZ0,vecX1,vecY1,vecZ1;
	Point3d ptCen0,ptCen1;
	int nInd0,nInd1;
	
	//region MALE
	if (bmMales.length()>0)
	{ 
		bm0 = bmMales.first();
		nInd0 = entsAll.find(bm0);
		if (nInd0>-1)bd0 = bodies[nInd0];
		vecX0 = bm0.vecX();		vecY0 = bm0.vecY();		vecZ0 = bm0.vecZ();
		ptCen0 = bm0.ptCenSolid();
		
		el0 = bm0.element();
	}
	else if (teMales.length()>0)
	{ 
		te0 = teMales.first();
		nInd0 = entsAll.find(te0);
		if (nInd0>-1)bd0 = bodies[nInd0];
		CoordSys cs = te0.coordSys();
		vecX0 = cs.vecX();		vecY0 = cs.vecY();		vecZ0 = cs.vecZ();

		Point3d pt = bd0.ptCen();
		pt = bd0.shadowProfile(Plane(pt, vecY0)).extentInDir(vecX0).ptMid();
		pt += vecY0*vecY0.dotProduct(pt-bd0.shadowProfile(Plane(pt, vecZ0)).extentInDir(vecX0).ptMid());
		ptCen0 = pt;
		
		el0 = te0.element();
	}
	Line lnX0(ptCen0, vecX0);
	CoordSys csMale(ptCen0, vecY0, vecZ0, vecX0);
	PlaneProfile pp0(csMale);
	pp0.unionWith(bd0.shadowProfile(Plane(ptCen0, vecX0)));
	//bd0.vis(4);
	//endregion 

	//region FEMALE
	if (bmFemales.length()>0)
	{ 
		Beam& b = bmFemales.first();
		bm1 = b;
		nInd1 = entsAll.find(b);
		if (nInd1>-1)bd1 = bodies[nInd1];
		
		vecX1 = b.vecX();
		vecY1 = b.vecY();
		vecZ1 = b.vecZ();
		ptCen1 = b.ptCenSolid();
		
		el1 = bm1.element();
	}
	else if (sipFemales.length()>0)
	{ 
		sip1= sipFemales.first();
		nInd1 = entsAll.find(sip1);
		if (nInd1>-1)bd1 = bodies[nInd1];
		//bd1.vis(4);
		vecX1 = sip1.vecX();
		vecY1 = sip1.vecY();
		vecZ1 = sip1.vecZ();
		ptCen1 = sip1.ptCenSolid();

		el1 = sip1.element();
	// validate location on female panel	
		Point3d pt;
		int bOk = lnX0.hasIntersection(Plane(ptCen1, vecZ1), pt);
		if (bOk) // only connections to main faces supported
		{ 
			PlaneProfile pp(sip1.plEnvelope());
			bOk = pp.pointInProfile(pt) != _kPointOutsideProfile;
		}
		if (!bOk)
		{ 
			reportMessage("\n" + scriptName() + ": " +T("|invalid location on female panel.|"));
			eraseInstance();
			return;				
		}	
		
	// adjust potential pps mismatches
		for (int i=0;i<sipFemales.length();i++) 
		{ 
			Sip sip = sipFemales[i];
			int n= entsAll.find(sip);
			if (n>-1)
			{ 
				Body& bd = bodies[n];
				PlaneProfile pp = bd.shadowProfile(Plane(bd.ptCen(), vecX1));
				pps[n] = pp; //pp.vis(6);
			}
			
		}//next i
	}	
	else if (teFemales.length()>0)
	{ 
		te1 = teFemales.first();
		nInd1 = entsAll.find(te1);
		if (nInd1>-1)bd1=bodies[nInd1];

		CoordSys cs = te1.coordSys();
		vecX1 = cs.vecX();
		vecY1 = cs.vecY();
		vecZ1 = cs.vecZ();
		
		Point3d pt = bd1.ptCen();
		pt = bd1.shadowProfile(Plane(pt, vecY1)).extentInDir(vecX1).ptMid();
		pt += vecY1*vecY1.dotProduct(pt-bd1.shadowProfile(Plane(pt, vecZ1)).extentInDir(vecX1).ptMid());
		ptCen1 = pt;
		el1 = te1.element();
	}	
		
	CoordSys csFemale(ptCen1, vecY1, vecZ1, vecX1);
	PlaneProfile pp1(csFemale);
	pp1.unionWith(bd1.shadowProfile(Plane(ptCen1, vecX1)));
	//endregion 	


// validate vectors
	if (vecX0.isParallelTo(vecX1))
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|does not support parallel connections.|") + vecX0 + " " + vecX1);
		eraseInstance();
		return;
	}
// validate female
	if (nInd1<0)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|could not find female solid.|"));
		eraseInstance();
		return;
	}	
	vecX0.vis(ptCen0, 1);
	vecY0.vis(ptCen0, 3);
	vecZ0.vis(ptCen0, 150);
	vecX1.vis(ptCen1, 1);
	vecY1.vis(ptCen1, 3);
	vecZ1.vis(ptCen1, 150);
		
// Get contact plane
	Plane pnF(_Pt0,_ZE);
	Vector3d vecX,vecY,vecZ;
	// vecZ	
	Vector3d vecXC=vecX0;
	vecZ=vecZ1;
	if (bm1.bIsValid())
	{
		LineBeamIntersect lbi(ptCen0,vecX0,bm1);
		if (lbi.nNumPoints()>0)
		{
			vecZ=lbi.vecNrm1();
			// vecZ.vis(lbi.pt1(),2);
		}
		else
			vecZ=bm1.vecD(vecX0);
	}
	else if (te1.bIsValid())
	{ 
		vecZ=vecZ1;
	}
	
	lnX0.hasIntersection(Plane(ptCen1,vecZ),_Pt0);
	if (vecXC.dotProduct(_Pt0-ptCen0)<0)
		vecXC*=-1;
	if (vecZ.dotProduct(_Pt0-ptCen0)<0)
		vecZ*=-1;

	lnX0.hasIntersection(Plane(ptCen1-vecZ*.5*bd1.lengthInDirection(vecZ),vecZ),_Pt0);
	
	// vecX to be aligned with smallest section dim of male
	vecX=vecY0;
	if (bm0.bIsValid() && bm0.dH()<bm0.dW())
		vecX=vecZ0;
	else if (te0.bIsValid())
		vecX=vecZ0;		
	vecX= vecX.crossProduct(vecZ).crossProduct(-vecZ); vecX.normalize();
	vecY=vecZ.crossProduct(vecX);
	
	// default orientations
	// element dependent
	if (el0.bIsValid())
	{ 
		Vector3d vecZE=el0.vecZ();
		if (vecY.isParallelTo(vecZE) && vecY.dotProduct(vecZE)<0)
		{ 
			vecX*=-1;
			vecY*=-1;
		}		
	}
	//is upright to world
	else if (vecY.dotProduct(_ZW)<0)
	{ 
		vecX*=-1;
		vecY*=-1;
	}
	
	int bFlipSide=_Map.getInt("flipSide");
	if (bFlipSide)
	{ 
		vecX*=-1;
		vecY*=-1;		
	}
	
	_XE = vecX;
	_YE = vecY;
	_ZE = vecZ;
	
//
//	vecX.vis(_Pt0, 1);
//	vecY.vis(_Pt0, 3);
//	vecZ.vis(_Pt0, 150);
	
	int bIsPerp = vecX0.isParallelTo(vecZ);
	int bIsSkew = !bIsPerp && vecX0.crossProduct(vecX).isParallelTo(vecY);
	
	
	
//	bodies[nInd0].vis(1);
//	bodies[nInd1].vis(2);
//endregion 

//region Clone connections in opposite direction during dbCreate and remove females from sset
// use same set of males
	//int ncthis = _ThisInst.color();//||ncthis==1
	Entity entCloneFemales[0];
	if ((_bOnDbCreated || bDebug ) && entFemales.length()>0)
	{ 
//		Entity entCloneFemales[0];
		for (int i=entFemales.length()-1; i>=0 ; i--) 
		{ 	
			int n= entsAll.find(entFemales[i]);
			if (n<0){ continue;}
			
			Vector3d vecZ2;
			Beam b = (Beam)entFemales[i];
			TrussEntity te = (TrussEntity)entFemales[i];
			Sip sip  = (Sip)entFemales[i];
			
			Plane pn;
			if (b.bIsValid())
			{
				LineBeamIntersect lbi(ptCen0, vecX0, b);
				if (lbi.nNumPoints() > 0)
					pn=Plane(lbi.pt1(),lbi.vecNrm1());
			}
			else if (sip.bIsValid())
			{ 
				pn=Plane(sip.ptCen(),sip.vecZ());
			}
			else if (te.bIsValid())
			{ 
				CoordSys cst = te.coordSys();
				pn=Plane(cst.ptOrg(),cst.vecZ());
			}
			
			int bRemove;
			
			Point3d pt = pps[n].coordSys().ptOrg();
			if (lnX0.hasIntersection(pn, pt))
			{
				if (vecZ.dotProduct(pt-ptCen0)<0)
				{
					entCloneFemales.append(entFemales[i]);
					if (bDebug)entFemales[i].realBody().vis(4);
					bRemove = true;	
				}
				else
				{ 
					// HSB-20088 check the female with the extention of male beam
					//lnX0.vis(6);
					Body bdMaleLang;
					PLine pls0[]=pp0.allRings(true,false);
					
					bdMaleLang=Body(pls0[0],vecX0*U(10e5),0);
					if(!bdMaleLang.hasIntersection(bodies[n]))
					{ 
						// this female is als not valid
						entCloneFemales.append(entFemales[i]);
						bRemove = true;	
					}
				}
			}
			else // invalid alignment remove
			{ 
				if (bDebug)entFemales[i].realBody().vis(6);
				bRemove = true;	
			}
			
			if (bRemove)
			{ 
				entFemales.removeAt(i);
			}
		}//next i

	}
//endregion 

//region Collect female packs if any
	PlaneProfile ppFemAll(csFemale);
	if (entFemales.length()>0)
	{ 
		for (int i=entFemales.length()-1; i>=0 ; i--) 
		{ 
			int n= entsAll.find(entFemales[i]);
			if (n>-1)
			{ 
				Body bd = bodies[n]; 
				Vector3d vecN = vecX.crossProduct(vecX0).crossProduct(-vecX0); vecN.normalize();
				PlaneProfile ppSect = bd.getSlice(Plane(ptCen0, vecN));
				// ppSect.vis(6);				
				//vecN.vis(ptCen0);
				if (ppSect.area() < pow(dEps, 2))  // remove females which are out of connection range
				{
					entFemales.removeAt(i);
					continue;
				}
				
				PlaneProfile ppi = pps[n];
				ppi.shrink(-dEps);
				ppFemAll.unionWith(ppi);
			} 		
		}//next i

		ppFemAll.shrink(dEps);	//ppFemAll.vis(3);
		
		Entity entFemalePacks[0];
		{ 
			PLine rings[] = ppFemAll.allRings(true, false);
			PlaneProfile _ppFemAll(csFemale);
			for (int r=0;r<rings.length();r++) 
			{ 
				PlaneProfile ppr(rings[r]);		
				if (ppr.intersectWith(pp1))
				{				
					for (int i=0;i<entFemales.length();i++) 
					{ 
						int n= entsAll.find(entFemales[i]);
						if (n>-1)
						{ 
							ppr=PlaneProfile (rings[r]);
							PlaneProfile ppi = pps[n];
							ppi.shrink(-dEps);
							if (ppr.intersectWith(ppi))
							{
								entFemalePacks.append(entFemales[i]);
								_ppFemAll.unionWith(ppi);
							}
						} 
					}//next i			
				}
			}//next r	
			_ppFemAll.shrink(dEps);	
			
			if (entFemalePacks.length()>0)
			{ 
				entFemales = entFemalePacks;
				ppFemAll = _ppFemAll;
			}
		}
		//ppFemAll.vis(2);
		LineSeg segFem = ppFemAll.extentInDir(vecY1);segFem.vis(2);
		int bOk = lnX0.hasIntersection(Plane(ppFemAll.ptMid()-vecZ*.5*abs(vecZ.dotProduct(segFem.ptStart()-segFem.ptEnd())), vecZ), _Pt0);
		pnF = Plane(_Pt0, - vecZ);
	}
//endregion 

//region Collect male packs if any and clone instances for left overs
	Entity entCloneMales[0];
	PlaneProfile ppMale(csMale), ppMaleProjected;
	{ 
		for (int i=0;i<entMales.length();i++) 
		{ 
			int n=entsAll.find(entMales[i]);
			if (n < 0) { continue; }

			PlaneProfile ppi=pps[n];
			CoordSys csi=ppi.coordSys();
			int bIsXParallel=csi.vecZ().isParallelTo(vecX0);
			int bIsYParallel=(csi.vecY().isParallelTo(vecY0) ||csi.vecY().isParallelTo(vecZ0));			
//			bodies[n].transformBy(csi.vecZ()*U(100));
//			bodies[n].vis(4);
//			bodies[n].transformBy(-csi.vecZ()*U(100));
			if (!bIsXParallel || !bIsYParallel) { continue;}
			
			ppi.shrink(-dEps);
			ppMale.unionWith(ppi);
		}//next i
		ppMale.shrink(dEps);	//ppMale.vis(3);
		Entity entMalePacks[0];
		pp0.vis(3);// male pp
		if (entMales.length()>1)
		{ 
			PLine rings[] = ppMale.allRings(true, false);
			PlaneProfile _ppMale(csMale);
			for (int r=0;r<rings.length();r++) 
			{ 
				PlaneProfile ppr(rings[r]);		
				if (ppr.intersectWith(pp0))
				{
					for (int i=0;i<entMales.length();i++) 
					{ 
						int n= entsAll.find(entMales[i]);
						if (n<0){ continue;}
				 
						PlaneProfile ppi = pps[n]; 
						CoordSys csi = ppi.coordSys();
						ppi.shrink(-dEps); 
						ppr=PlaneProfile (rings[r]);
			
						int bIsXParallel = csi.vecZ().isParallelTo(vecX0);
						int bIsYParallel = (csi.vecY().isParallelTo(vecY0) ||csi.vecY().isParallelTo(vecZ0));
					// check intersection and x-direction
						if (bIsXParallel && bIsYParallel && ppr.intersectWith(ppi) && vecZ.dotProduct(_Pt0-csi.ptOrg())>0)
						{
							entMalePacks.append(entMales[i]);
							_ppMale.unionWith(ppi);
						}
						else
							ppi.vis(221);	
 
					}//next i			
				}
			}//next r	
			_ppMale.shrink(dEps);	
			
			if (entMalePacks.length()>0)
			{ 
				for (int i=0;i<entMales.length();i++) 
					if (entMalePacks.find(entMales[i])<0)
						entCloneMales.append(entMales[i]);
				entMales = entMalePacks;
				ppMale = _ppMale;
			}
			// HSB-20088: move this below
		//region Clone connections for males which are not part of the reference pack
//			if ((_bOnDebug || _bOnDbCreated) && entCloneMales.length()>0)	
//			{ 
//			// create TSL
//				TslInst tslNew;				Map mapTsl;
//				int bForceModelSpace = true;	
//				String sExecuteKey,sCatalogName = tLastInserted;
//				String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
//				GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {};
//	
//				mapTsl.setEntityArray(entCloneMales, false, kMale+"[]", "", kMale);
//				mapTsl.setEntityArray(entFemales, false, kFemale+"[]", "", kFemale);
//				
//				_Map.setEntityArray(entMales, false, kMale+"[]", "", kMale);					
//				setCatalogFromPropValues(tLastInserted);
//				
//				//if (bDebug)reportNotice("\ncloning male in same direction with " + entCloneMales.length() + "/"+entFemales.length() + ", source set reduced to " +entMales.length());				
//				tslNew.dbCreate(scriptName() , vecX ,vecY,gbsTsl, entsTsl, ptsTsl, tLastInserted, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 			
//				//if (bDebug)reportNotice(tslNew.bIsValid()?" "+tslNew.handle()+" ok": " failed");					
//
//			}
//		//endregion 		
		}
		ppMaleProjected = ppMale;
		ppMaleProjected.project(pnF, vecXC, dEps);
		
		LineSeg segMale = ppMaleProjected.extentInDir(vecY);//segMale.vis(6);
		_Pt0 = segMale.ptMid() - vecY * .5*abs(vecY.dotProduct(segMale.ptStart() - segMale.ptEnd()));
		_Pt0.vis(bIsPerp ? 0 : (bIsSkew ? 6 : 2));	
	}
	
	Entity entFemalesAll[0];
	for (int i=0;i<entFemales.length();i++) 
	{ 
		if(entFemalesAll.find(entFemales[i])<0)
			entFemalesAll.append(entFemales[i]);
	}//next i
	for (int i=0;i<entCloneFemales.length();i++) 
	{ 
		if(entFemalesAll.find(entCloneFemales[i])<0)
			entFemalesAll.append(entCloneFemales[i]);
	}//next i
	
	
	// // HSB-20088: move this below remaining entCloneMales and entCloneFemales are created here
//	if ((_bOnDebug || _bOnDbCreated) && entCloneMales.length()>0 && entCloneFemales.length()>0)	
	if ((_bOnDebug || _bOnDbCreated) && entCloneMales.length()>0 && entFemalesAll.length()>0)	
	{ 
	// create TSL
		TslInst tslNew;				Map mapTsl;
		int bForceModelSpace = true;	
		String sExecuteKey,sCatalogName = tLastInserted;
		String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
		GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {};

		mapTsl.setEntityArray(entCloneMales, false, kMale+"[]", "", kMale);
//		mapTsl.setEntityArray(entFemales, false, kFemale+"[]", "", kFemale);
//		mapTsl.setEntityArray(entCloneFemales, false, kFemale+"[]", "", kFemale);
		mapTsl.setEntityArray(entFemalesAll, false, kFemale+"[]", "", kFemale);
		
//		_Map.setEntityArray(entMales, false, kMale+"[]", "", kMale);					
		setCatalogFromPropValues(tLastInserted);
		
		//if (bDebug)reportNotice("\ncloning male in same direction with " + entCloneMales.length() + "/"+entFemales.length() + ", source set reduced to " +entMales.length());				
		tslNew.dbCreate(scriptName(),vecX ,vecY,gbsTsl, entsTsl, ptsTsl, tLastInserted, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 			
		//if (bDebug)reportNotice(tslNew.bIsValid()?"\n1864 "+tslNew.handle()+" ok": " failed");					


	//Prerequisites for creation of tag instance: hsbEntityTag
		String sTagProps[0];
		double dTagProps[0];
		int nTagProps[0];
		if (tslNew.bIsValid() && nTagMode==2 && GetEntityTagProperties("hsbEntityTag", sTagProps, dTagProps, nTagProps))
		{
			Point3d ptTag= tslNew.ptOrg() - tslNew.coordSys().vecZ()  * .25*dTagProps[0];

		// create TSL
			TslInst tslTag;
			GenBeam gbsTsl[] = {};		Entity entsTsl[] = {tslNew};			Point3d ptsTsl[] = {ptTag};
			Map mapTsl;	
						
			if (!bDebug)
				tslTag.dbCreate("hsbEntityTag" , tslNew.coordSys().vecX() ,-tslNew.coordSys().vecZ(),gbsTsl, entsTsl, ptsTsl, nTagProps, dTagProps, sTagProps,_kModelSpace, mapTsl);								
			
		}

	}
	
// create tag on insert for main instance	
	if (_bOnDbCreated && nMode==2)
	{ 
		String sTagProps[0];
		double dTagProps[0];
		int nTagProps[0];	
		if(GetEntityTagProperties("hsbEntityTag", sTagProps, dTagProps, nTagProps))
		{ 
			Point3d ptTag = _Pt0- _ZE  * .25*dTagProps[0];
	
		// create TSL
			TslInst tslTag;
			GenBeam gbsTsl[] = {};		Entity entsTsl[] = {this};			Point3d ptsTsl[] = {ptTag};
			Map mapTsl;	
						
			if (!bDebug)
			{
				tslTag.dbCreate("hsbEntityTag" , _XE ,-_ZE,gbsTsl, entsTsl, ptsTsl, nTagProps, dTagProps, sTagProps,_kModelSpace, mapTsl);	
				tslTag.transformBy(Vector3d(0, 0, 0));
			}
			_Map.setInt("AddTags", true);	// trigger tagging			
		}
		
	}
	
	vecX.vis(_Pt0, 1);
	vecY.vis(_Pt0, 3);
	vecZ.vis(_Pt0, 150);
	
// purge invalid male beams
	bmMales = vecX0.filterBeamsParallel(bmMales);
	for (int i=bmMales.length()-1; i>=0 ; i--) 
		if (entMales.find(bmMales[i])<0)
			bmMales.removeAt(i);
//endregion 

	if(entFemales.length()==0)
	{ 
		reportMessage("\n"+scriptName()+" "+T("|No valid female part|"));
		eraseInstance();
		return;
	}

// END Part #3 //endregion 		

//region Connection Profiles
	CoordSys cs(_Pt0, vecX, vecY, vecZ);
	// make sure it has propere coordSys
	{ 
		PlaneProfile pp(cs);
		pp.unionWith(ppMaleProjected);
		ppMaleProjected = pp;
	}
	Vector3d vecX0N=vecX0;
	if (vecX0N.dotProduct(vecZ)<0) vecX0N*=-1;
	vecX0N=vecX0N.crossProduct(-vecY).crossProduct(vecY); vecX0N.normalize();		
	vecX0N.vis(_Pt0, 40);
		
		
	//{Display dpx(1); dpx.draw(ppMale, _kDrawFilled,20);}
	// HSB-19651: 
	double dWidthMale = ppMale.dX();
	double dHeightMale = ppMale.dY();
	double dWidthProjectedMale = ppMaleProjected.dX();
	Point3d pt1 = _Pt0 - vecX * .5 * dWidthProjectedMale;
	Point3d pt2 = _Pt0 + vecX * .5 * dWidthProjectedMale;			//pt1.vis(40);pt2.vis(40);
	Point3d ptTopMale = _Pt0 + vecY * ppMale.dY();					//ptTopMale.vis(40);	
	
	PlaneProfile ppFemale(cs),ppFemaleIntersect(cs);
	for (int i=0;i<entFemales.length();i++) 
	{ 
		int n =entsAll.find(entFemales[i]);
		if (n<0){ continue;}	
		PlaneProfile pp = bodies[n].extractContactFaceInPlane(pnF, dEps);
		pp.shrink(-dEps);	
		ppFemale.unionWith(pp);
	}//next i
	ppFemale.shrink(dEps);
	
	{ 
		PlaneProfile pp(cs);
		pp.createRectangle(LineSeg(pt1 - vecY * U(10e3), pt2 + vecY * U(10e3)), vecX, vecY);
		ppFemale.intersectWith(pp);
	}
	ppFemaleIntersect = ppFemale;
	ppFemaleIntersect.extentInDir(vecY).vis(1);
	Point3d ptTopFemale = ptCen1; // init with err location
	Point3d ptBotFemale = ptCen1;
	if (ppFemaleIntersect.area()>pow(dEps,2))
	{
		ptBotFemale=ppFemale.ptMid() - vecY * .5*ppFemale.dY();
		ptTopFemale=ppFemale.ptMid() + vecY * .5*ppFemale.dY();
	}
	//ptTopFemale.vis(2);
	
	PlaneProfile ppCommon = ppMale;
	ppCommon.intersectWith(ppFemaleIntersect);
	//ppCommon.extentInDir(-vecX).vis(6);
	
	int bIsTopFlush = abs(vecY.dotProduct(ptTopFemale - ptTopMale)) < U(2); // accept slight tolerances
	int bIsBotFlush = abs(vecY.dotProduct(ptBotFemale - _Pt0)) < U(2); // accept slight tolerances

// get connecting angle
	double dAlpha;
	if (!bIsPerp)
	{ 
		dAlpha=vecZ.angleTo(vecX0N);
		if (abs(dAlpha)>dEps && vecX.dotProduct(vecX0N) < 0)dAlpha *= -1;
	}
	int bAcceptAngleDeviation = bAllowAngleDeviation && abs(dAlpha)<=2;
	
//endregion 

//region Product Data	
	int bAutoProduct = sProduct==kAuto;
	String selectedProduct = !bAutoProduct?sProduct:"";
	String sIssues[0];
	Map mapProduct;
	if (!bAutoProduct)
	{ 
		for (int i=0;i<mapProducts.length();i++) 
		{ 
			Map m= mapProducts.getMap(i);
			String name = m.getMapName();
			String products[0];
			int bIsValid = IsValidProductDefinition(m, name);

			if(bIsValid && name.find(sProduct,0,false)>-1 && name.length()==sProduct.length())
			{ 
				mapProduct = m;
				selectedProduct = name;
				break;
			}
		}//next i		
	}

		
	//region Search matching Product
	String sMatchingProducts[0]; int indices[0]; //a list of products which match the geometrical requirements, to be shown in the property list when in automatic mode
	{
		int bIsSkewProduct; // flag if a product allows a skew angle
//		String sMatchingProducts[0]; int indices[0]; //a list of products which match the geometrical requirements, to be shown in the property list when in automatic mode
		Map products;
		if (bAutoProduct)
			products = mapProducts;
		else 
			products.appendMap("Product", mapProduct);
		
		for (int p=0;p<products.length();p++) 
		{ 
			Map m = products.getMap(p); 
			String k;
			
			String name=m.getMapName();
			
			int bIsSingleFemalePlate;
			double dA; 	k = "A"; 		if (m.hasDouble(k))	dA = m.getDouble(k);	// the inner width of the hanger
			double dB; 	k = "B"; 		if (m.hasDouble(k))	dB = m.getDouble(k);	// the height of the hanger
			double dE; 	k = "E"; 		if (m.hasDouble(k))	dE = m.getDouble(k);	// the (optional) length of each wing on the top face of the female beam
			double dG; 	k = "G"; 		if (m.hasDouble(k))	{ bIsSingleFemalePlate=true;dG = m.getDouble(k);}	//the (optional) complete length on the top face of the female beam
			
			double dT; 	k = "t"; 		if (m.hasDouble(k))	dT = m.getDouble(k);	// the main thickness of the product
			
			int bTopFlush; 	k = "TopFlush"; 	bTopFlush = m.getInt(k)==true;	// true if top flush alignment is required
			String alpha;	if (m.hasString(kAlpha))	alpha=m.getString(kAlpha);
	
		//region Check Joist Section if specified
			double minWidth;	k = kMinWidthJoist;		if (m.hasDouble(k))	minWidth=m.getDouble(k);
			double maxWidth;	k = kMaxWidthJoist;		if (m.hasDouble(k))	maxWidth=m.getDouble(k);
			double minHeight;	k = kMinHeightJoist;	if (m.hasDouble(k))	minHeight=m.getDouble(k);
			double maxHeight;	k = kMaxHeightJoist;	if (m.hasDouble(k))	maxHeight=m.getDouble(k);
			
		// refuse if 
			int bRefuse;
			// height does not match required values
			if (minHeight > dEps && dHeightMale<minHeight)	{sIssues.append(name + ": " +T("|height| ") + dHeightMale + T(" |is smaller than the minimal height| ") + minHeight);bRefuse=true;}			
			if (maxHeight > dEps && dHeightMale>maxHeight)	{sIssues.append(name + ": " +T("|height| ") + dHeightMale + T(" |is greater than the maximal height| ") + maxHeight);bRefuse=true;}			
			// width does not match required values
			if (minWidth > dEps && dWidthMale<minWidth)		{sIssues.append(name + ": " +T("|width| ") + dWidthMale + T(" |is smaller than the minimal width| ") + minWidth);bRefuse=true;}			
			if (maxWidth > dEps && dWidthMale>maxWidth)		{sIssues.append(name + ": " +T("|width| ") + dWidthMale + T(" |is greater than the maximal width| ") + maxWidth);bRefuse=true;}			
			// inner width does not match
			if (dA > dEps && dWidthMale>dA && minWidth<dEps) {sIssues.append(name + ": " +T("|joist width| ") + dWidthMale + T(" |is bigger then the inner width| ") + dA);bRefuse=true;}								
		//endregion 
	
		//region Get allowed angles or angle ranges			
			double dAlphas[0];
			double dMinAlphas[0], dMaxAlphas[0];
			if (alpha.length()>0)
			{ 
				String tokens[] = alpha.tokenize(";");
				for (int i=0;i<tokens.length();i++) 
				{ 
					String token= tokens[i]; 
					if (token.find("_",0)>-1)
					{ 
						String minmax[] = token.tokenize("_");
						if (minmax.length()==2)
						{ 
							double min = minmax[0].atof();
							double max = minmax[1].atof();
							if (min>max)
							{ 
								min = max;
								max = minmax[0].atof();
							}
							dMinAlphas.append(min);
							dMaxAlphas.append(max);
							bIsSkewProduct = true;
						}
					}
					else
					{ 
						double d = token.atof();
						if (dAlphas.find(d)<0)
						{
							dAlphas.append(d);
							bIsSkewProduct = true;
						}
					} 
				}//next i	
			}	
			
		// check if in one of the ranges
			int bInSkewRange;
			for (int i=0;i<dMinAlphas.length();i++) 
			{ 
				if (dAlpha+dEps>dMinAlphas[i] && dAlpha-dEps<=dMaxAlphas[i])
				{
					bInSkewRange=true;
					break;
				}				 
			}//next i
			if (!bInSkewRange)
			{ 
				for (int i=0;i<dAlphas.length();i++) 
				{ 
					double d = abs(dAlphas[i] - dAlpha);
					if (abs(dAlphas[i]-dAlpha)<dEps)
					{
						bInSkewRange=true;
						break;
					}				 
				}//next i
			}
		
			int bAcceptSkew = bInSkewRange || bAcceptAngleDeviation;
		//endregion 

		// refuse if angled connection but no angles allowed
			if (abs(dAlpha)>dEps && !bAcceptSkew)
				{sIssues.append(name + ": " + T("|Connection angle| ") +  dAlpha + "°" + T(" |could not be found in list of specified angles| ") + dAlphas);	bRefuse=true;}
		// refuse if not angled but definition is skewed
			if (abs(dAlpha)<dEps && !bAcceptSkew && (dAlphas.length()>0 || dMinAlphas.length()>0))	
				{sIssues.append(name + ": " + T("|Hanger requires angles which could not be found| ") +  dAlpha + "°" + T(" |vs| ") + dAlphas + " " + dMinAlphas);	bRefuse=true;}		
		// refuse if top flush is required and does not match	
			if (bTopFlush && (!bIsTopFlush || dB<dHeightMale))//abs(dHeightMale-dB)>dT))	//HSB-23725 top mounted hangers bugfix
				{sIssues.append(name + ": " + T("|Top flush alignment not possible| "));	bRefuse=true;}	

//		// refuse if has top face plate, not topflush 
//			else if (dE>dEps && bTopFlush && (!bIsTopFlush || abs(dHeightMale-dB)>dT) && !bIsSingleFemalePlate) //TODO
//			{
//				if (!bIsTopFlush)
//					sIssues.append(name + ": " +T("|Header and Jost are not on same top plane|"));
//				else
//					sIssues.append(name + ": " +T("|Hanger height and male height do not match|"));
//				continue;
//			}


			//if (bDebug)reportMessage("\nindex " + p + " accepting " + name);

			if (!bRefuse)
			{ 
				sMatchingProducts.append(name);
				indices.append(p);				
			}
			else
			{ 
				sIssues.append(" ");
			}

//			mapProduct = m;
//			selectedProduct = name;
//			break;
			
		}//next p	
		
		
		if(_Map.hasString("indicesCollide"))
		{ 
			String sIndicesCollide=_Map.getString("indicesCollide");
			String sIndicesCollides[]=sIndicesCollide.tokenize(";");
			for (int ii=0;ii<sIndicesCollides.length();ii++) 
			{ 
				int nIndI=sIndicesCollides[ii].atoi();
				if(indices.find(nIndI)>-1)
				{ 
				// HSB-20089: remove index that collides
				//20231020
					int nIndex=indices.find(nIndI);
					indices.removeAt(nIndex);
					sMatchingProducts.removeAt(nIndex);
				}
			}//next ii
		}

		if (sMatchingProducts.length()>0)
		{ 
			mapProduct = products.getMap(indices.first());
			selectedProduct = sMatchingProducts.first();
		}
		else if (selectedProduct.length()<1)
		{ 
			reportMessage("\n" + scriptName() + ": " +T("|could not find valid product|"));	
			for (int i=0;i<sIssues.length();i++) 
				reportMessage("\n   "+sIssues[i]);	
		
			if (!_bOnDbCreated && sStretchMale==tYes)
			{ 
				Cut cut(_Pt0, vecZ);
				for (int i = 0; i < bmMales.length(); i++)
					bmMales[i].addToolStatic(cut,bDebug?_kStretchNot: _kStretchOnToolChange);
			}
			if(!bDebug)
			{
				PurgeReinforcements(_Map.getMap(kStiffs));
				PurgeReinforcements(_Map.getMap(kBackers));				
				eraseInstance();
			}
			return;			
		}

		if (bIsSkew && !bIsSkewProduct && !bAcceptAngleDeviation)//
		{ 
			reportMessage("\n" + scriptName() + ": " +T("|Hanger not applicable for angle| ")  +dAlpha + "°" );	
			if (!_bOnDbCreated && sStretchMale==tYes)
			{ 
				Cut cut(_Pt0, vecZ);
				for (int i = 0; i < bmMales.length(); i++)
					bmMales[i].addToolStatic(cut,bDebug?_kStretchNot: _kStretchOnToolChange);
			}

			if(!bDebug)
			{
				PurgeReinforcements(_Map.getMap(kStiffs));
				PurgeReinforcements(_Map.getMap(kBackers));
				eraseInstance();
			}
			return;				
		}

//		else if (bIsSkewProduct && !bInSkewRange)// abs(dAlpha)<dEps && 
//		{ 
//			reportMessage("\n" + scriptName() + ": " +T("|Skewed connection not allowed| ")  +dAlpha + "°" );	
//			if (!_bOnDbCreated)
//			{ 
//				Cut cut(_Pt0, vecZ);
//				for (int i = 0; i < bmMales.length(); i++)
//					bmMales[i].addToolStatic(cut,bDebug?_kStretchNot: _kStretchOnToolChange);
//			}
//			if(!bDebug)eraseInstance();
//			return;				
//		}
	
	//region redefine product property to show only matching products when in auto mode
		if (bAutoProduct && sMatchingProducts.length()>0)
		{ 
			sMatchingProducts.insertAt(0, kAuto);
			sProduct = PropString(2, sMatchingProducts, sProductName);	
			sProduct.setControlsOtherProperties(true);
		}
	//endregion 
	}
	//endregion 		

	//region Get Product data
	double a0s[0];//Block overrides and their offsets (for multiple blocks like splitted hangers)
	String sBlockOverrides[0];	
	int bHasBlockOverride;
	Map mapBlocks;	
	int bIsSingleFemalePlate; // a flag to indicate that the female plates are not mirrored
	{ 
		Map m=mapProduct;
		String k;
		k = "A"; 		if (m.hasDouble(k))	A = m.getDouble(k);
		k = "B"; 		if (m.hasDouble(k))	B = m.getDouble(k);
		k = "C"; 		if (m.hasDouble(k))	C = m.getDouble(k);
		k = "D"; 		if (m.hasDouble(k))	D = m.getDouble(k);
		k = "E"; 		if (m.hasDouble(k))	E = m.getDouble(k);
		k = "F"; 		if (m.hasDouble(k))	F = m.getDouble(k);
		k = "G"; 		if (m.hasDouble(k))	{G = m.getDouble(k); bIsSingleFemalePlate=true;}
		k = "H"; 		if (m.hasDouble(k))	H = m.getDouble(k);
		k = "I"; 		if (m.hasDouble(k))	I = m.getDouble(k);
		k = "J"; 		if (m.hasDouble(k))	J = m.getDouble(k);
		k = "K"; 		if (m.hasDouble(k))	K = m.getDouble(k);
		
		k = "t"; 		if (m.hasDouble(k))	dThickness = m.getDouble(k);

		k = kMinWidthJoist;		if (m.hasDouble(k))	dMinWidth = m.getDouble(k);
		k = kMaxWidthJoist;		if (m.hasDouble(k))	dMaxWidth = m.getDouble(k);
		k = kMinHeightJoist;	if (m.hasDouble(k))	dMinHeight = m.getDouble(k);
		k = kMaxHeightJoist;	if (m.hasDouble(k))	dMaxHeight = m.getDouble(k);

		k = kAdjustableHeight;	bHasAdjustableHeightStrap = m.getInt(k)==1;	// i.e. StrongTie JHA
		

		k = "Alpha"; 	
		if (m.hasString(k))	
		{
			String sAlpha = m.getString(k);
		// as list
			int semicolon = sAlpha.find(";", 0 , false);
			int underscore = sAlpha.find("_", 0 , false);
			int bAsRange = underscore >-1;
			int bAsList = semicolon < 0 && underscore < 0;

			if (bAsList)
			{ 
				String tokens[] = m.getString(k).tokenize(";");
				double alphas[0];
				for (int j=0;j<tokens.length();j++) 
				{ 
					double d = tokens[j].atof();
					if (alphas.find(d)<0)
						alphas.append(d);
					 
				}//next j
				Alphas = alphas.sorted();
				if (Alphas.length()>0)
				{ 
					AlphaMin = Alphas.first();
					AlphaMax = Alphas.last();					
				}
								
			}
			else if (bAsRange)
			{ 
				String tokens[] = m.getString(k).tokenize("_");
				if (tokens.length()>0)
					AlphaMin = tokens[0].atof();
				if (tokens.length()>1)
					AlphaMax = tokens[1].atof();				
			}

		}

		k = "Block[]"; 	
		if (m.hasMap(k))	
		{
			mapBlocks = m.getMap(k); // a list of block overrides		
			for (int i=0;i<mapBlocks.length();i++) 
			{ 
				m = mapBlocks.getMap(i);
				
				double dX;		k = "dX"; 		if (m.hasDouble(k))	dX = m.getDouble(k);
				String name;	k = kName; 	if (m.hasString(k))	name = m.getString(k); 
				
				if (sBlockOverrides.findNoCase(name,-1)<0)
				{ 
					sBlockOverrides.append(name);
					a0s.append(dX);
					bHasBlockOverride = true;
				}
			}//next i	
		}
	}
	
	Point3d ptBlock=_Pt0;
	if (dBaseDepth>0 && C>dEps && bmMales.length()>0)
		ptBlock += vecY * dBaseDepth;
	//endregion 
//endregion

//region Redefine fixture properties
	Map mapProductFixture = mapProduct.getMap(kFixture);
	HardWrComp hwcFixtures[0];
	int numHeaderFull,numJoistFull,numHeaderPartial,numJoistPartial; // the quantity of fixture predefined by the product 
	if (mapProductFixture.length() > 0)
	{
		// get custom fixtures
		for (int i=0;i<mapFixtures.length();i++) 
		{ 
			Map m = mapFixtures.getMap(i);
			String name = m.getMapName();
			
			String product = m.getString(kProduct);
			if (product.length()>0 && selectedProduct!=product){ continue;}
			String family = m.getString(kFamily);
			if (family.length()>0 && sFamily!=family){ continue;}
			
			if (sFixtureArticles.findNoCase(name,-1)<0)
				sFixtureArticles.append(name);
		}//next i		

		// append predefined articles if not overwritten by Customer	
		Map m = mapProductFixture.getMap(kArticle + "[]");
		for (int i = 0; i < m.length(); i++)
		{
			String article = m.getString(i);
			if (article.length() > 0 && sFixtureArticles.findNoCase(article ,- 1) < 0)
				sFixtureArticles.append(article);
		}//next i
		
		// get nail patterns
		numHeaderFull =	mapProductFixture.getInt(kNumHeaderFull);
		numJoistFull = mapProductFixture.getInt(kNumJoistPartial);
		numHeaderPartial = mapProductFixture.getInt(kNumHeaderPartial);
		numJoistPartial = mapProductFixture.getInt(kNumJoistPartial);
		
		// show only defined patterns	
		int n = sFixtureModes.find(kFullNailing);
		if (numHeaderFull < 1 && numJoistFull < 1 && n >- 1)
			sFixtureModes.removeAt(n);
		n = sFixtureModes.find(kPartialNailing);
		if (numHeaderPartial < 1 && numJoistPartial < 1 && n >- 1)
			sFixtureModes.removeAt(n);
		
		sFixtureArticle = PropString(6, sFixtureArticles, sFixtureArticleName);
		
		sFixtureMode = PropString(7, sFixtureModes, sFixtureModeName);
		nFixtureMode = sFixtureModes.findNoCase(sFixtureMode);
		String desc2;
		if (nFixtureMode >- 1 && sFixtureMode == kFullNailing)
			desc2 = T(" |Header|=") + numHeaderFull + T(", |Joist|=") + numJoistFull;
		else if (nFixtureMode >- 1 && sFixtureMode == kPartialNailing)
			desc2 = T(" |Header|=") + numHeaderPartial + T(", |Joist|=") + numJoistPartial;
		sFixtureMode.setDescription(kFixtureModeDescription + desc2);
	}
		
	//region Collect Fixture Hardware
	int numHeader = sFixtureMode == kPartialNailing ? numHeaderPartial : numHeaderFull;
	int numJoist = sFixtureMode == kPartialNailing ? numJoistPartial : numJoistFull;
	if (nFixtureMode>-1 && sFixtureArticle!=kDisabled)
	{
	// find fixture definition in product fixtures
		Map mapHwcs;
		for (int i = 0; i < mapLibFixtures.length(); i++)
		{
			Map m = mapLibFixtures.getMap(i);
			String name = m.getMapName();
			if (name == sFixtureArticle)
			{ 
				mapHwcs.appendMap(kHardWrComp,m);
				break;
			}
		}
	// find (overwrite) fixture definition in custom fixtures
		for (int i = 0; i < mapFixtures.length(); i++)
		{
			Map m = mapFixtures.getMap(i);
			String name = m.getMapName();
			if (name == sFixtureArticle)
			{ 
				mapHwcs = m.getMap(kHardWrComps);
				break;
			}
		}
		
	// collect hardwares
		
		for (int i=0;i<mapHwcs.length();i++) 
		{ 
			Map m = mapHwcs.getMap(i); 
			
			String article = m.getString(kArticle);
			int quantity = m.getInt(kQuantity);
			String cat = m.getString(kCategory);
			
			int bIsJoist = m.getString(kName).find("Joist",0,false)>-1;
			int bIsHeader = m.getString(kName).find("Header",0,false)>-1;
			if (quantity < 1 && bIsJoist)quantity = numJoist;
			else if (quantity < 1 && bIsHeader)quantity = numHeader;
			else if (quantity < 1)quantity = numHeader+numJoist;
			
			// do not append if quantity <1
			if (quantity<1){ continue;}
	
			HardWrComp hwc(article, quantity);
			hwc.setManufacturer(m.getString(kManufacturer));
			hwc.setModel(m.getString(kFamily));
			hwc.setMaterial(m.getString(kMaterial));
			hwc.setCategory(cat==""?tFixture:cat);
			hwc.setGroup(m.getString(kGroup));
			hwc.setNotes(m.getString(kNotes));
			hwc.setDescription(m.getString(kDescription));
			hwc.setRepType(_kRTTsl);
			hwc.setDScaleX(m.getDouble(kScaleX));
			hwc.setDScaleY(m.getDouble(kScaleY));
			hwc.setDScaleZ(m.getDouble(kScaleZ));
			
			hwcFixtures.append(hwc); 
		}//next i
	}
	//endregion 		

//endregion 

//region Hardware
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
		if (el1.bIsValid()) 	sHWGroupName=el1.elementGroup().name();
	// loose
		else
		{
			Group groups[] = _ThisInst.groups();
			if (groups.length()>0)	sHWGroupName=groups[0].name();
		}		
	}

// add main componnent
	if (selectedProduct!="")
	{ 
		HardWrComp hwc(selectedProduct, 1); // the articleNumber and the quantity is mandatory
		
		hwc.setManufacturer(sManufacturer);
		
		hwc.setModel(sFamily);
		//hwc.setName(sHWName);
		hwc.setDescription(mapProduct.getString(kDescription));
		hwc.setMaterial(material);
		//hwc.setNotes(sHWNotes);
		
		hwc.setGroup(sHWGroupName);	
		hwc.setCategory(T("|Connector|"));
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		
		hwc.setDScaleX(A);
		hwc.setDScaleY(B);
		hwc.setDScaleZ(D);
		
	// apppend component to the list of components
		hwcs.append(hwc);
		
		hwcs.append(hwcFixtures);
	}


// make sure the hardware is updated
	if (_bOnDbCreated) setExecutionLoops(2);
	_ThisInst.setHardWrComps(hwcs);	
	//endregion

//region CompareKey
	String sCompareKey = sManufacturer +"_"+ sFamily;
	// append hardware
	{
		String keys[0];
		for (int i=0;i<hwcs.length();i++) 
		{ 
			HardWrComp hwc = hwcs[i];
			Map m;
			m.setString("articleNumber", hwc.articleNumber());
			m.setString("quantity", hwc.quantity());
			
			String key = this.formatObject("@(articleNumber)_@(Quantity:PL3;0)", m);
			keys.append(key);	 
		}//next i
		keys = keys.sorted();
		for (int i=0;i<keys.length();i++) 
			sCompareKey += "_" + keys[i];
	}
	//reportNotice("\nCompare: " + sCompareKey);
	setCompareKey(sCompareKey);
	this.releasePosnum();
	this.assignPosnum(1, true);

//endregion 

//region Trigger Tag Assignment	
	int bAddTag = _Map.getInt("AddTags") || _kNameLastChangedProp == sFamilyName || _kNameLastChangedProp == sProductName || _kNameLastChangedProp == sManufacturerName;
	if (bAddTag && nTagMode>0)
	{ 
		//reportNotice("\n" + this.handle() + " start tagging");
		
		TslInst hangers[] = FindSiblings(scriptName());	
		if (hangers.length() > 0)
		{ 
			int nPosGroups[0], nPosQty[0];
			for (int i=0;i<hangers.length();i++) 
			{ 
				int pos= hangers[i].posnum();
				int n = nPosGroups.find(pos);
				if (n<0)
				{ 
					nPosGroups.append(pos);
					nPosQty.append(1);
				}
				else
				{ 
					nPosQty[n]+=1;
				} 
			}//next i

		// order descending by quantity
			for (int i=0;i<nPosGroups.length();i++) 
				for (int j=0;j<nPosGroups.length()-1;j++) 
					if (nPosQty[j]<nPosQty[j+1])
					{
						nPosGroups.swap(j, j + 1);
						nPosQty.swap(j, j + 1);
					}



			for (int i=0;i<hangers.length();i++) 
			{ 
				TslInst& t = hangers[i]; 
				int index = nPosGroups.find(t.posnum());
				if (index>-1)
				{ 
					String tag = ToAlphanumeric(index+1);
					if (tag!=t.modelDescription())
					{
						t.setModelDescription(tag);
					}
				}				 
			}//next i
			_Map.removeAt("AddTags", true);// avoid to be called multiple times


		}
	}
	
//endregion 

//region Female Section
	CoordSys csFemaleSection(_Pt0, vecZ, vecY ,- vecX);
	PlaneProfile ppFemaleSection(csFemaleSection);
	PlaneProfile ppBacker(csFemaleSection);
	for (int i=0;i<entFemales.length();i++) 
	{ 
		int n = entsAll.find(entFemales[i]);
		if (n<0){ continue;}
		
		Body bd = bodies[n];
		
		PlaneProfile pp = bd.getSlice(Plane(_Pt0, vecX));
		pp.shrink(-dEps);
		ppFemaleSection.unionWith(pp);	
	}//next i			
	ppFemaleSection.shrink(dEps);
	

	//ppFemaleSection.vis(2);
//endregion 

//region Backer Block and Stiffeners


int bBackerPossible;
int bWebStiffenerPossible;

//region BackerBlock (for female beams only)
	// get potential backer shape
	Entity entBacker = _Map.getEntity(kBacker);
	if(entBacker.bIsValid())
	{ 
		if(_Entity.find(entBacker)<0)
			_Entity.append(entBacker);
		setDependencyOnEntity(entBacker);
	}
	
	if (!te1.bIsValid() && !sip1.bIsValid())
	{ 	
		double dX = dLengthBacker+2*dExtraBacker;
		if (dLengthBacker<=dEps && D > dEps && dExtraBacker>dEps)dX = A + 2 * D + 2*dExtraBacker;		
		int bCreateBacker=dX>dEps && (_bOnDbCreated || _kNameLastChangedProp == sProductName || _Map.getInt(kCreateStiffBacker));
		
		if ((bCreateBacker || dX<dEps) && entBacker.bIsValid())entBacker.dbErase();


		PlaneProfile pp;
		pp.createRectangle(ppFemaleSection.extentInDir(vecZ), vecZ, vecY);
		if (dX > dEps && abs(pp.area()-ppFemaleSection.area())>pow(dEps,2))
		{ 
			bBackerPossible=true;
			pp.subtractProfile(ppFemaleSection);
			if (dGapBacker>dEps)
			{ 
				PlaneProfile ppSub;
				ppSub.createRectangle(pp.extentInDir(vecZ), vecZ, vecY);
				ppSub.transformBy(vecY * (pp.dY() - dGapBacker));
				pp.subtractProfile(ppSub);
			}
			//pp.vis(2);
			PLine rings[] = pp.allRings(true, false);
			
		// order in vecZ
			for (int i=0;i<rings.length();i++) 
				for (int j=0;j<rings.length()-1;j++) 
				{
					Point3d pti, ptj;
					pti.setToAverage(rings[j].vertexPoints(true));
					ptj.setToAverage(rings[j+1].vertexPoints(true));				
					if (vecZ.dotProduct(pti-ptj)>0)	rings.swap(j, j + 1);
				}

		// first ring is backer shape
			if(sStiffener==tRTBacker || sStiffener==tRTBoth)
			if (rings.length()>0)
			{
				PLine ring(vecX);
				
			// simplify to facetted shape i.e. at an HEB shape
				Point3d pts[] = rings.first().vertexPoints(false);
				int bAdd1=true;
				for (int i=0;i<pts.length()-1;i++) 
				{ 
					Point3d pt1 = pts[i];
					Point3d pt2 = pts[i+1];
					Vector3d vec = pt2 - pt1; vec.normalize();
					if (vec.isParallelTo(vecZ) || vec.isParallelTo(vecY))
					{
						if (bAdd1)ring.addVertex(pt1);
						ring.addVertex(pt2);
						bAdd1 = false;
					}
					else
						bAdd1 = true;
				}//next i
				ring.close();
				ppBacker.joinRing(ring, _kAdd);
				
				
				Point3d pt=ppBacker.ptMid();
			
			// make sure the backer block touches the contact face // HSB-14924
				if (abs(vecZ.dotProduct(pt-_Pt0))-.5*ppBacker.dX()>dEps)
					bCreateBacker=false;

				Body bd;
				if (dX>dEps && ring.area()>pow(dEps,2))
					bd=Body(ring,vecX*dX,0);
				
				bd.vis(6);
				Body bdAll;
				TslInst tslHangersModify[0];
				if(bCreateBacker || bDebug)
				{ 
				// HSB-20090: consider existing hangers at this female beam and 
				// if needed correct them
					TslInst tslHangers[]=bm1.tslInstAttached();
					for (int it=tslHangers.length()-1; it>=0 ; it--) 
					{ 
						if(_ThisInst==tslHangers[it])
						{ 
							tslHangers.removeAt(it);
							continue;
						}
						if(tslHangers[it].scriptName()!="GenericHanger")
						{
							tslHangers.removeAt(it);
							continue;
						}
						TslInst tslI=tslHangers[it];
						Beam beamsTsl[]=tslI.beam();
						if(beamsTsl.length()!=_Beam.length())
						{
							tslHangers.removeAt(it);
							continue;
						}
						if(beamsTsl[1]!=bm1)
						{ 
							tslHangers.removeAt(it);
							continue;
						}
					}//next it
					
					bdAll=bd;
					for (int it=0;it<tslHangers.length();it++) 
					{ 
						if(_ThisInst==tslHangers[it])continue;
						if(tslHangers[it].map().hasEntity(kBacker))
						{ 
							Entity entBackerI=tslHangers[it].map().getEntity(kBacker);
							Beam bmBackerI=(Beam)entBackerI;
							if(bmBackerI.bIsValid())
							{
								if(bdAll.hasIntersection(bmBackerI.envelopeBody()))
								{
									bdAll.addPart(bmBackerI.envelopeBody());
									tslHangersModify.append(tslHangers[it]);
	//								bmBackerI.dbErase();
									bCreateBacker=true;
								}
							}
						}
					}//next it
				}
			// trim with the female beam
				bd1.vis(3);
				{
					Point3d ptsExtreme[]=bd1.extremeVertices(vecX1);
					Body bdL(ptsExtreme.first(),ptsExtreme.first()-vecX1*U(10e3),U(10e4));
					Body bdR(ptsExtreme.last(),ptsExtreme.last()+vecX1*U(10e3),U(10e4));
					bdAll.subPart(bdL);
					bdAll.subPart(bdR);
				}
				bdAll.vis(2);
				Beam bmBackerNew;
				if (bCreateBacker && !bDebug)
				{ 
					Beam b;
					b.dbCreate(bdAll, vecX, vecY, vecZ);
					b.setName(tRTBacker);
					b.setMaterial(tMaterialBacker);
					b.setType(_kEWPBacker_Block);
					b.setColor(nColorBacker);
					if (el1.bIsValid())
						b.assignToElementGroup(el1, true,0,'Z');						
					else
						b.assignToGroups(entFemales.first(),'Z');
					_Entity.append(b);
					setDependencyOnEntity(b);
					_Map.setEntity(kBacker, b);
					entBacker = b;
					bmBackerNew=b;
				}
//				else if (entBacker.bIsValid())
//				{ 
//					Beam b = (Beam)entBacker;
//					Vector3d vec = pt - b.ptCen();
//					if (vec.length()>dEps) b.transformBy(vec);
//					//bd.vis(2);
//				}
				else if (bDebug)
				{ 
					bd.vis(3);					
				}
				//ppFemale.vis(2);
				
			// HSB-20090 modify other hangers
				if(bmBackerNew.bIsValid())
				{ 
					for (int it=0;it<tslHangersModify.length();it++) 
					{ 
						Map mapTslI=tslHangersModify[it].map();
						if(mapTslI.hasEntity(kBacker))
						{ 
							Entity entBackerI=mapTslI.getEntity(kBacker);
							entBackerI.dbErase();
						}
						mapTslI.setEntity(kBacker,bmBackerNew);
						tslHangersModify[it].setMap(mapTslI);
					}//next it
				}
			}
		}
		//ppBacker.vis(6);
	}
//endregion 

//region WebStiffener
	Entity entStiffeners[0];
	if(sStiffener==tRTStiffener || sStiffener==tRTBoth)
	{ 	
		Map mapStiffeners = _Map.getMap("Stiffener[]");
		for (int i=0;i<mapStiffeners.length();i++) 
		{ 
			Entity ent = mapStiffeners.getEntity(i); 
			if (ent.bIsValid())entStiffeners.append(ent);
		}//next i
	
		double dX = dLengthStiff+dExtraStiff;
		if (dLengthStiff<=dEps && (C > dEps) && dExtraStiff>dEps) dX = C + dExtraStiff;
		int bCreateStiffener= dX>dEps && (_bOnDbCreated || _kNameLastChangedProp == sProductName ||_Map.getInt(kCreateStiffBacker));
	
	// erase existing stiffeneres	
		if (bCreateStiffener || dX<dEps)
		{ 
			PurgeReinforcements(mapStiffeners);
			mapStiffeners = Map();
		}
	
		PlaneProfile pp;
		pp.createRectangle(ppMale.extentInDir(vecY0), vecY0, vecZ0);		
		if (dX>dEps && abs(pp.area() - ppMale.area()) > pow(dEps, 2))
		{
			bWebStiffenerPossible=true;
				
		//region Get Contour
			pp.subtractProfile(ppMale);
			if (dGapStiff>dEps)
			{ 
				PlaneProfile ppSub;
				ppSub.createRectangle(pp.extentInDir(vecY0), vecY0, vecZ0);
				ppSub.transformBy(vecZ0 * (pp.dY() - dGapStiff));
				pp.subtractProfile(ppSub);
			}	
			//pp.vis(5);

		// order in vecX
			PLine rings[] = pp.allRings(true, false);
			for (int i=0;i<rings.length();i++) 
				for (int j=0;j<rings.length()-1;j++) 
				{
					Point3d pti, ptj;
					pti.setToAverage(rings[j].vertexPoints(true));
					ptj.setToAverage(rings[j+1].vertexPoints(true));				
					if (vecX.dotProduct(pti-ptj)>0)	rings.swap(j, j + 1);
				}					
		//endregion 

		//region Create by Ring
			for (int r=0;r<rings.length();r++) 
			{ 
				PLine ring(vecX0);
				// only use left and right ring
				if (rings.length()>2 && (r!=0 && r!=rings.length()-1)){ continue;}
				
			//region Simplify to facetted shape i.e. at an HEB shape
				Point3d pts[] = rings[r].vertexPoints(false);
				int bAdd1=true;
				for (int i=0;i<pts.length()-1;i++) 
				{ 
					Point3d pt1 = pts[i];
					Point3d pt2 = pts[i+1];
					Vector3d vec = pt2 - pt1; vec.normalize();
					if (vec.isParallelTo(vecZ0) || vec.isParallelTo(vecY0))
					{
						if (bAdd1)ring.addVertex(pt1);
						ring.addVertex(pt2);
						bAdd1 = false;
					}
					else
						bAdd1 = true;
				}//next i
				ring.close();					
			//endregion 
			

				if (ring.area()<pow(dEps,2)){ continue;}
				Body bd (ring, vecX0 * U(10e4), 0);
				if (sStretchMale==tYes || abs(dAlpha)<dEps)
				{
					bd.addTool(Cut(ptBlock, vecZ), 0);
					bd.addTool(Cut(ptBlock-vecXC*dX, -vecXC), 0);
				}
				else
				{
					double b = (.5*dWidthMale) / abs(tan(90-dAlpha))+dGap;
					Point3d pt = _Pt0 - vecX0N * b;			pt.vis(40);	
					bd.addTool(Cut(pt, vecX0N), 0);
					bd.addTool(Cut(pt-vecX0N*dX, -vecX0N), 0);
				}
				
	
				if (bCreateStiffener && !bDebug)
				{ 
					Beam b;
					b.dbCreate(bd, vecX0, vecY0, vecZ0);
					b.setName(tRTStiffener);
					b.setMaterial(tMaterialStiff);
					b.setType(_kEWPWeb_Stiffener);
					b.setColor(nColorStiff);
					if (el0.bIsValid())
						b.assignToElementGroup(el0, true,0,'Z');						
					else
						b.assignToGroups(entMales.first(),'Z');
					_Entity.append(b);
					setDependencyOnEntity(b);
					mapStiffeners.appendEntity("Stiffener", b);
					entStiffeners.append(b);
				}			
				else
				{
					bd.vis(6);
				}
				//ring.vis(4); 
			}//next r				
		//endregion 
			
		//{Display dpx(1); dpx.draw(ppMaleProjected, _kDrawFilled,20);}
		// transform stiffeners with male
			for (int i=0;i<entStiffeners.length();i++) 
			{ 
				Vector3d vecSide = (i == 0 ?- 1 : 1) * vecX;
				Beam b= (Beam)entStiffeners[i]; 
				if (b.bIsValid())
				{ 
					Vector3d vecSide = ppMale.coordSys().vecX();
					if (vecSide.dotProduct(vecX) < 0)vecSide *= -1;
					vecSide *= (i == 0 ?- 1 : 1);
					Point3d pt = ppMaleProjected.ptMid() + .5 * vecSide * ppMale.dX();
					Line(pt, vecX0).hasIntersection(pnF, pt);
					//pt.vis(i);
					
					Point3d ptb;
					Line(b.ptCen()+vecSide*.5*b.dD(vecSide), b.vecX()).hasIntersection(pnF, ptb);
					//b.vecX().vis(ptb,i+2);
					
					Vector3d vec = pt - ptb;
					if (!vec.bIsZeroLength())
						b.transformBy(vec);				
				}
		
			}//next i
			_Map.setMap(kStiffs,mapStiffeners);
		// create stiffener	
		}	
	}
	_Map.removeAt(kCreateStiffBacker, true);
	// 20231020
	if (_bOnDbCreated)
	{
		// on dbCreated check Backer another time
		setExecutionLoops(2);
		_Map.setInt(kCreateStiffBacker, true);
	}
//endregion 
	
//endregion 

//region Validate TopFlush Mounting
	int bHasFemaleCollision;
	if (E>dEps && !bHasAdjustableHeightStrap)// && _kNameLastChangedProp!=sFamilyName)
	{ 
		Point3d ptTop = ptBlock + vecY * B; 
		//ptTop.vis(2);
		double dX = bIsSingleFemalePlate ?D: A + 2 * D;
		Body bdX(ptTop, vecX, vecY, vecZ, dX, U(200), E, 0, 1, 1);
		//bdX.vis(6);
		
		for (int i=0;i<entFemales.length();i++) 
		{ 
			int n = entsAll.find(entFemales[i]);
			if (n>-1 && bodies[n].hasIntersection(bdX))
			{ 
				bHasFemaleCollision = true;
				break;
			}
		}//next i
	}
	// HSB-20089: 
	if(bAutoProduct && bHasFemaleCollision && sMatchingProducts.length()>0)// && _kNameLastChangedProp!=sFamilyName)
	{ 
		reportMessage(" 2 bHasFemaleCollision:" + bHasFemaleCollision);//XX
		String sIndicesCollide=_Map.getString("indicesCollide");
		sIndicesCollide+=indices.first()+";";
	// save colliding index in _Map 
		_Map.setString("indicesCollide",sIndicesCollide);
//		setExecutionLoops(indices.length()+1);HSB-22462: introduced with HSB-20089 causing trouble to use defined cuts
//		return;
	}
//endregion 

//region Display
	Display dpModel(bHasFemaleCollision?1:nc);	
	
// Default Block display if no overrides defined
	if (sBlockOverrides.length()<1)
	{ 
		sBlockOverrides.append(selectedProduct);
		a0s.append(0);
	}	
//endregion 

//region Simplified Solid
	Body bdHanger;
{ 
	double dX = .5*A;

	CoordSys csMirrX; csMirrX.setToMirroring(Plane(_Pt0, vecX));
	double dFC = F > C ? F - C : 0;
	
	
	if (a0s.length() == 2)dX = abs(a0s.first()) * dWidthMale;
	Point3d ptBase = ptBlock + vecX * (dX-.5*A);

	if (dThickness>0)
	{ 
		double dZMale = F > 0 ? F : C;
		int bComplete;
		
	// Special Design StrongTie ET
	// left, right male wing and bottom plate if symmetrical angled // HSB-23403
		if (sManufacturer.find("StrongTie",0,false)>-1 && sFamily.find("ET",0, false)==0 &&
			A>dEps && dThickness>dEps && C>dEps && B>dEps && abs(AlphaMin)>0 && abs(AlphaMin)==AlphaMax)
		{ 
			// goniometrics: b=C
			double alpha = dAlpha;
			if (abs(dAlpha) < 0.1)  alpha = 0;
			else if (dAlpha<90)alpha=dAlpha-90;
			else if (dAlpha>90)alpha=90-dAlpha;
		
			// a0, c0: current angle
			double c0 = C / cos(alpha);	
			double a0= c0 * sin(alpha);			
			
			// a1, c1 the hanger model 
			double c1 = C / cos(AlphaMax);
			double a1 = c1 * sin(AlphaMax);
			
			// get offsets based on current angle	
			Point3d pt = ptBase-vecY*dThickness + vecX*.5*A;
			//vecX.vis(pt,6);
			
			
		// Wings	
			PLine pl(vecX);
			pl.createRectangle(LineSeg(pt+vecZ*2*dThickness, pt +vecY*B- vecZ * c1), vecZ, vecY);
			CoordSys rot; rot.setToRotation(-AlphaMax, vecY, pt);
			pl.transformBy(rot);
			//pl.transformBy(vecX * .5*A);
			Body bd1(pl, pl.coordSys().vecZ() * dThickness, -1);		
			bd1.addTool(Cut(pt, vecZ), 0); 
			bd1.addTool(Cut(pt-vecZ*C, -vecZ), 0); 		//bd1.vis(6);
			Body bd2 = bd1;
			bd2.transformBy(csMirrX);					//bd2.vis(6);
			bdHanger.addPart(bd1);			
			bdHanger.addPart(bd2);	
			
		// Base
			PlaneProfile pp(CoordSys(pt,vecZ, vecX, vecY ));
			pp.unionWith(bd1.shadowProfile(Plane(pt, vecY)));
			pp.unionWith(bd2.shadowProfile(Plane(pt, vecY)));
			PLine plBase; plBase.createConvexHull(Plane(pt, vecY), pp.getGripVertexPoints());		//plBase.vis(150);
			Body bdBase(plBase, vecY * dThickness, -1);
			bdHanger.addPart(bdBase);
			
			
		// Female Wings
			double d1 = D - 2 * a1 - .5 * A;
			d1 = d1 > 0 ? d1 : D;// the data from simpson seems to be wrong for ET
			if (d1>dEps)
			{ 
				Body bdf(pt, vecX, vecY, vecZ, d1, B, dThickness, 1, 1,-1);	//bdf.vis(4);
				bdf.addTool(Cut(pt, pl.coordSys().vecZ()), 0);
				bdHanger.addPart(bdf);
				bdf.transformBy(csMirrX); //bdf.vis(4);
				bdHanger.addPart(bdf);				
			}

			bComplete = true;
		}		
		

	// bottom plate	
		if (!bComplete && A>dEps && dThickness>dEps && dZMale>dEps)
			bdHanger.addPart(Body(ptBase, vecX, vecY, vecZ, A, dThickness,dZMale, 0 ,- 1 ,- 1 ));//-vecZ*dThickness

	// left and right male wing (bIsSingleFemalePlate)
		if (!bComplete && bIsSingleFemalePlate && H>dEps && H>B-I)
		{ 
			double dY = (bIsSingleFemalePlate && H>dEps && H>B-I)?H:B;
			PLine pl(vecX);
			Point3d pt = ptBase-vecY*dThickness;//-vecZ*dThickness
			pl.createRectangle(LineSeg(pt, ptBase - vecZ * dZMale + vecY * dY), vecY, vecZ);
			pl.transformBy(vecX * .5*A);
			Body bd(pl, vecX * dThickness, 1);	bd.vis(6);
			bdHanger.addPart(bd);
			bd.transformBy(csMirrX);
			bdHanger.addPart(bd);	
		}


	// left and right male wing	
		else if (!bComplete && A>dEps && dThickness>dEps && dZMale>dEps && (H>dEps || B>dEps))
		{ 
			double dY = bHasAdjustableHeightStrap && E>0 ?E:B;

			PLine pl(vecX);
			Point3d pt = ptBase-vecY*dThickness;
			
			double dB1 = .2 * dY;
			double dC1 = .4 * dZMale;
						
			pl.addVertex(pt);	pt.vis(4);
			pt -= vecZ * dZMale;	pl.addVertex(pt);
			pt += vecY * dB1;		pl.addVertex(pt);
			pt += vecY * dB1+vecZ * (dZMale-dC1);		pl.addVertex(pt);
			pt += vecY * (dY-2*dB1);		pl.addVertex(pt);
			pt += vecZ * dC1;		pl.addVertex(pt);
			pl.close();pl.vis(2);



			if (pl.area() > pow(dEps, 2))
			{
				pl.transformBy(vecX * .5*A);
				Body bd(pl, vecX * dThickness, 1);		//bd.vis(6);
				bdHanger.addPart(bd);
				bd.transformBy(csMirrX);				//bd.vis(6);
				bdHanger.addPart(bd);				
			}

		}		
	// left and right adjustable female wing
		if (!bComplete && bHasAdjustableHeightStrap && abs(D)>dEps &&  B>dEps && E>dEps)
		{ 
			double dRemainingHeight = B+E; // HSB-23725 top mounted hangers bugfix


			int nFlipD = abs(D)/D;
			PLine pl(vecZ);
			Point3d pt = ptBase + vecY * .5 * abs(D);								//pt.vis(1);
			pl.addVertex(pt);	pt += vecX*(D+nFlipD*dThickness)+vecY*.5*abs(D);	//pt.vis(2);
			
			double d2 = vecY.dotProduct(ptTopFemale - ptBase);
			if (dRemainingHeight>d2)
				dRemainingHeight -= d2;
			else
			{
				d2 = dRemainingHeight;
				dRemainingHeight = 0;
			}
				
			pl.addVertex(pt);	pt +=vecY*(d2-abs(D));								//pt.vis(3);															
			pl.addVertex(pt);	pt -= vecX*D;										//pt.vis(4);
			pl.addVertex(pt);
			pl.close();			
			
			//pl.vis(6);
			pl.transformBy(vecX * .5*A);
			Body bd(pl, vecZ * dThickness, - 1);	//bd.vis(4);
			bdHanger.addPart(bd);
			
			bd.transformBy(csMirrX);
			bdHanger.addPart(bd);
			
		// add top part if height remains
			if (dRemainingHeight>dEps)
			{ 
				pt = ptTopFemale +vecX*(.5*A+dThickness)- vecZ * dThickness;
				double dWidthFemale = ppFemAll.dX();
			
				double dD = dRemainingHeight;
				if (dRemainingHeight>dWidthFemale)
				{ 
					dD = dWidthFemale;
					dRemainingHeight -= dD;
				}
				else
					dRemainingHeight = 0;
				
				bd=Body(pt,vecZ, vecX, vecY, dD+dThickness, D, dThickness, 1, 1,1);
				bdHanger.addPart(bd);
				bd.transformBy(csMirrX);
				bdHanger.addPart(bd);		//bd.vis(2);			
				
				pt += vecZ * (dD + dThickness);
			}
		// add vertical backside  part if height remains
			if (dRemainingHeight>dEps)
			{ 	
				pt += vecY * dThickness;
				bd=Body(pt,vecY, -vecX, vecZ,dRemainingHeight+dThickness, D, dThickness, -1, -1,1);
				bdHanger.addPart(bd);
				bd.transformBy(csMirrX);
				bdHanger.addPart(bd);		//bd.vis(2);	
				
			}			
		}
	// left and right female wing	
		else if (!bComplete && abs(D)>dEps && B > dEps && !bIsSingleFemalePlate)
		{ 
			int nFlipD = abs(D)/D;
			PLine pl(vecZ);
			Point3d pt = ptBase +vecY*.5*abs(D);	
			pl.addVertex(pt);	pt += vecX*(D+nFlipD*dThickness)+vecY*.5*abs(D);
			pl.addVertex(pt);	pt +=vecY*(B-abs(D));
			pl.addVertex(pt);	pt -= vecX*D;
			pl.addVertex(pt);
			pl.close();			
			//pl.vis(6);
	
			pl.transformBy(vecX * .5*A);
			Body bd(pl, vecZ * dThickness, - 1);
			bdHanger.addPart(bd);
			
			bd.transformBy(csMirrX);
			bdHanger.addPart(bd);						
		}	
	
	// left and right female top wing
		if (!bComplete && abs(D)>dEps && E > dEps && !bIsSingleFemalePlate && !bHasAdjustableHeightStrap)
		{ 
			Point3d pt = ptBase -vecZ*dThickness+ vecX * .5 * A + vecY*B;
			Body bd(pt, vecX, vecY, vecZ, abs(D),dThickness, dThickness+E,D/abs(D),1,1);
			bdHanger.addPart(bd);
			bd.transformBy(csMirrX);
			bdHanger.addPart(bd);
		}
		// single female top wing
		if (!bComplete && D>dEps && bIsSingleFemalePlate && !bHasAdjustableHeightStrap)
		{ 
			Point3d pt = ptBase  + vecY*B;
			double dXFlag;
			if (abs(G)==1) // left (-1) or right (+1) aligned
			{ 
				dXFlag = G;
				pt += vecX *dXFlag* (.5 *  A + dThickness);
			}
			
			if (E>dEps)
			{ 
				Body bd(pt, vecX, vecY, vecZ, D,dThickness, dThickness+E,-dXFlag,1,1);
				bdHanger.addPart(bd);				
			}

			
			if (I>dEps)
			{ 
				if (B > 0)pt += vecY * dThickness;
				Body bd(pt, vecX, vecY, vecZ, D,I+dThickness, dThickness,-dXFlag,B>0?-1:1,-1);
				bdHanger.addPart(bd);				
			}
			
		}			
	}
}	
//endregion 

//region NoNails
	if (el1.bIsValid())
	{ 
		Vector3d vecZE = el1.vecZ();		
		Plane pnEl(el1.ptOrg(), vecZE);
		
		Body bdTest = bdHanger;
		bdTest.transformBy(vecY * dThickness);
		Beam beams[] = bdTest.filterGenBeamsIntersect(el1.beam());
		
		PlaneProfile pp1(el1.coordSys());
		for (int i=0;i<beams.length();i++) 
		{ 
			pp1.unionWith(beams[i].envelopeBody().shadowProfile(pnEl)); 
			 
		}//next i
		
		PlaneProfile pp2 = bdHanger.extractContactFaceInPlane(Plane(_Pt0, vecZE), dBaseDepth+dEps);
		
		pp2.intersectWith(pp1);
		pp2.shrink(-2*dThickness);
		pp2.vis(3);
		
		int zone = vecY.isCodirectionalTo(vecZE) ? -1 :1; // dirty and quick
		
		PLine rings[] = pp2.allRings(true, false);
		for (int r=0;r<rings.length();r++) 
		{ 
			
			ElemNoNail nn (zone,rings[r]); 
			el1.addTool(nn);
			 
		}//next r
		
		
		
		//pp1.vis(6);

	}
//endregion 

//region Draw

	int bDrawBlock;
	if (sBlockOverrides.length()>0)
	{ 
		String sBlockName;
		for (int i=0;i<sBlockOverrides.length();i++) 
		{ 
			sBlockName = sBlockOverrides[i]; 
			double dX = a0s.length()>i?a0s[i]:0;

			if (_BlockNames.findNoCase(sBlockName,-1)<0)
			{ 
				String sBlockPath = _kPathHsbCompany + "\\Block";
				String sBlockFolders[] = getFoldersInFolder(sBlockPath);
				String fileName = sBlockName;
			// make sure file name of block/product does not contain any slashes
				int x = fileName.find("/", 0);
				while (x>-1)
				{ 
					String left = fileName.left(x);
					String right= fileName.right(fileName.length()-x-1);
					fileName = left + "-" + right;
					x = fileName.find("/", 0);
				}	
				
				sBlockName = "";
			// Try to get block from identical named folder	
				if (sBlockFolders.findNoCase(sManufacturer,-1)>-1)
				{ 					
					String files[] = getFilesInFolder(sBlockPath + "\\" + sManufacturer);
					if (files.findNoCase(fileName+".dwg",-1)>-1)
						sBlockName = sBlockPath + "\\" + sManufacturer + "\\" + fileName + ".dwg";
				}	
			// Try to get block from similar folder name (i.e. from StrongTie if manufacturer is named StrongTie DACH)	
				else
				{ 	
					for (int j=0;j<sBlockFolders.length();j++) 
					{ 
						if (sBlockFolders[j].find(sManufacturer.left(4),0,false)>-1)
						{
							String files[] = getFilesInFolder(sBlockPath + "\\"+ sBlockFolders[j] ,"*.dwg");
							if (files.findNoCase(fileName+".dwg",-1)>-1)
								sBlockName = sBlockPath + "\\" + sBlockFolders[j] + "\\" + fileName + ".dwg";
						}
						if (sBlockName.length()>0){	break;}
					}//next j	
				}				
			}

			if (sBlockName.length()>0)
			{ 
				Block block(sBlockName);
				dpModel.draw(block,ptBlock+vecX*dX*dWidthMale, -vecX, vecZ, vecY);
				bDrawBlock = true;
			}	
		}//next i
				
	}	
	else if (bDebug)
		dpModel.draw(selectedProduct,_Pt0, vecX, vecY, 1,0);


	if (!bDrawBlock)
	{ 
		dpModel.textHeight(U(20));
		if (bDebug)
			dpModel.draw(_Beam.length() + " beams\n" + entMales.length() + " males " + entFemales.length() + " females", _Pt0, _XW, _YW, 0, 0, _kDevice);		
		
		
		if (selectedProduct=="")
		{ 			
//			PlaneProfile pp1 = ppMaleProjected;
//			pp1.shrink(U(10));
//			if (pp1.area()>pow(dEps,2))
//			{ 
				ppMaleProjected.subtractProfile(pp1);
				dpModel.draw(pp1, _kDrawFilled, 30);
				dpModel.color(1);
				dpModel.draw(ppMaleProjected, _kDrawFilled,20);
				dpModel.draw(T("|No matching\nhanger found|"), _Pt0, -vecZ, -vecX, 1, 0, _kDevice);
				this.setModelDescription("-");
				
//			}
//			else
//				dpModel.draw(ppMaleProjected, _kDrawFilled, 30);
			
		}
		else if (bdHanger.volume() < pow(dEps, 3) && ppMale.area() > pow(dEps, 2))
		{
			dpModel.draw(ppMaleProjected, _kDrawFilled, 30);
			dpModel.draw(T("|Missing parameters to display solid|"), _Pt0, _XW, _YW, 0, 0, _kDevice);
		}
		else
			dpModel.draw(bdHanger);
	}

		
//endregion 

//region Append and Collect Beams to support splitting HSB-14928
//	for (int i=0;i<_Beam.length();i++)
//		reportMessage(" _Beam " + i +" " + _Beam[i].handle());
	if (!bDebug)
	{ 
		for (int i=0;i<bmMales.length();i++) 
			if (_Beam.find(bmMales[i])<0)
				_Beam.append(bmMales[i]); 
		for (int i=0;i<bmFemales.length();i++) 
			if (_Beam.find(bmFemales[i])<0)
				_Beam.append(bmFemales[i]);
	
		setCloneDuringBeamSplit(_kAuto);
		
		int bSplitMale,bSplitFemale;
		
		if (_kExecutionLoopCount==0)
		{ 
			for (int i=0;i<_Beam.length();i++) 
			{ 
				Beam b = _Beam[i];
				if (b.type() == _kEWPBacker_Block || b.type() == _kEWPWeb_Stiffener){continue;}
				if(entMales.find(b)<0 && b.vecX().isParallelTo(vecX0))
				{ 
					//reportNotice("\n" + _ThisInst.handle() + " male _Beam appended " + b.handle());
					entMales.append(b);
					bmMales.append(b);
					bSplitMale = true;
				}
				else if (entFemales.find(b)<0 && b.vecX().isParallelTo(vecX1))
				{ 
					//reportNotice("\n" + _ThisInst.handle() + " female _Beam appended " + b.handle());
					entFemales.append(b);					
					bmFemales.append(b);
					bSplitFemale = true;
				}					
			}//next i	
			
		// in case of male beams being split consider only unique
			if(bSplitMale)
			{ 
				Beam uniques[] = vecX0.filterBeamsParallelUnique(bmMales);
				for (int i=bmMales.length()-1; i>=0 ; i--) 
				{ 
					Beam b = bmMales[i];
					if (uniques.find(b)<0) // remove any reference and dependency
					{
						int n;
						n= entMales.find(b); if (n >- 1)entMales.removeAt(n);
						n= _Entity.find(b); if (n >- 1)_Entity.removeAt(n);
						n= _Beam.find(b); if (n >- 1)_Beam.removeAt(n);
						bmMales.removeAt(i);
					}					
				}//next i	
			}
					
			if (!bDebug && bSplitMale)
				_Map.setEntityArray(entMales, false, kMale+"[]", "", kMale);
			if (!bDebug && bSplitFemale)
				_Map.setEntityArray(entFemales, false, kFemale+"[]", "", kFemale);	
//			if (bSplitMale || bSplitFemale)
//			{ 
//				reportMessage("\n" + _kExecutionLoopCount + " Update Males " +bSplitMale  +" (" + entMales.length() +
//					") Females " +bSplitFemale + " (" + entFemales.length() + ")");
//			}			
		}
	}


//endregion 

//region Add GenBeam Tools	
	if (bmMales.length()>0)
	{ 
		Point3d pt = _Pt0 - vecZ * dGap;
		Cut cut(pt, vecZ);
		if (abs(dAlpha)>0 && (sStretchMale==tNo || bDebug))
		{ 
			double b = (.5*dWidthMale) / tan(dAlpha)+dGap;
			pt = _Pt0 - vecX0N * b;
			pt.vis(3);
			cut=Cut (pt, vecX0N);
		}

		//vecZ.vis(pt, 162);
		for (int i = 0; i < bmMales.length(); i++)
		{
			Beam& b = bmMales[i];
			if (b.type() == _kEWPBacker_Block || b.type() == _kEWPWeb_Stiffener){continue;}
			
			//bmMales[i].realBody().vis(1);
			int n = entsAll.find(bmMales[i]);
			if (n >- 1)bodies[n].addTool(cut,0);

		// Stretch Male	
			if(sStretchMale==tYes)
				bmMales[i].addTool(cut,bDebug?_kStretchNot: _kStretchOnToolChange);
			else if(sStretchMale==tNo && (_kNameLastChangedProp==sStretchMaleName || _kNameLastChangedProp==sGapName))
				bmMales[i].addToolStatic(cut,bDebug?_kStretchNot: _kStretchOnToolChange);				
			
		//Flush mounting / base depth
			if (dBaseDepth>0 && C>dEps)
			{ 	
				BeamCut bc(_Pt0, vecX, vecY, vecZ, U(10e3), dBaseDepth * 2, (F>0?F:C), 0, 0 ,- 1);
				b.addTool(bc);
				//bc.addMeToGenBeamsIntersect(bmMales);		
			}			
		}
	}
	


//region Marking
	if (sMarking!=kDisabled)
	{ 
		Vector3d vecMark = -vecZ; // front
		if (sMarking.find(tBackMarking,0,false)>-1)
			vecMark = vecZ;
		else if (sMarking.find(tBottomMarking,0,false)>-1)
			vecMark = -vecY;
		else if (sMarking.find(tTopMarking,0,false)>-1)
			vecMark = vecY;
			
		int bAddText = sMarking.find(sProductName, 0, false) >- 1;
		
		Mark mrk;
		if (bAddText)
		{ 
			mrk=Mark (_Pt0, vecMark, selectedProduct);
			mrk.suppressLine();
		}
		else
		{
			mrk=Mark (_Pt0-vecX*(.5*A+dThickness),_Pt0+vecX*(.5*A+dThickness),vecMark);
		}

		for (int i=0;i<bmFemales.length();i++) 
		{
			Beam& b = bmFemales[i];
			if (b.type()==_kEWPBacker_Block || b.type()==_kEWPWeb_Stiffener){ continue;}
			b.addTool(mrk); 
		}
	
	}
//endregion 


// assigning
	if (sGroupAssignment == tGAFemale && entFemales.length()>0)
		assignToGroups(entFemales.first(), 'I');
	else if (sGroupAssignment == tGAMale && entMales.length()>0)
		assignToGroups(entMales.first(), 'I');
	else if (sGroupAssignment == tGAFemaleJ && entFemales.length()>0)
		assignToGroups(entFemales.first(), 'J');
	else if (sGroupAssignment == tGAMaleJ && entMales.length()>0)
		assignToGroups(entMales.first(), 'J');

//endregion 

//region TRIGGER
{
	// TSL cloning prerequisites
	TslInst tslDialog;			Map mapTsl;
	GenBeam gbsTsl[] = { };		Entity entsTsl[] = { };			Point3d ptsTsl[] = { _Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };
	
//region Trigger FlipSide
	String sTriggerFlipSide = T("|Flip Side|");
	addRecalcTrigger(_kContextRoot, sTriggerFlipSide );
	if (_bOnRecalc && _kExecuteKey == sTriggerFlipSide)
	{
		bFlipSide =! bFlipSide;
		_Map.setInt("flipSide", bFlipSide);
		setExecutionLoops(2);
		
		if (sStiffener!=kDisabled)
		{ 
			PurgeReinforcements(_Map.getMap(kStiffs));
			_Map.setInt(kCreateStiffBacker, true);
		}

		return;
	}//endregion
	
//region Trigger AddEntity
	String sTriggerAddEntity = T("|Add Entities|");
	addRecalcTrigger(_kContextRoot, sTriggerAddEntity );
	if (_bOnRecalc && _kExecuteKey == sTriggerAddEntity)
	{
		// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select entities|"), Beam());
		ssE.addAllowedClass(Sip());
		ssE.addAllowedClass(TrussEntity());
		if (ssE.go())
			ents.append(ssE.set());
		
		// collect additional males and females
		for (int i = 0; i < ents.length(); i++)
		{
			Entity& ent = ents[i];
			Beam bm = (Beam)ent;
			TrussEntity te = (TrussEntity)ent;
			Sip sip = (Sip)ent;
			Vector3d vecXi, vecYi, vecZi;
			if (bm.bIsValid())
			{
				if (bm.type()==_kEWPBacker_Block || bm.type()==_kEWPWeb_Stiffener){ continue;}
				vecXi = bm.vecX();
				vecYi = bm.vecY();
			}
			else if (sip.bIsValid())
			{
				vecZi = sip.vecZ();
			}
			if (vecXi.isParallelTo(vecX0) && (vecYi.isParallelTo(vecY0) || vecYi.isPerpendicularTo(vecY0) ) && entMales.find(ent) < 0)
				entMales.append(ent);
			else if (vecXi.isParallelTo(vecX1) && (vecYi.isParallelTo(vecY1) || vecYi.isPerpendicularTo(vecY1) ) && entFemales.find(ent) < 0)
				entFemales.append(ent);
			else if (vecZi.isParallelTo(vecZ) && entFemales.find(ent) < 0)
				entFemales.append(ent);
			
			//			if (bDebug)
			//				entMales.append(ent);
			
			
		}
		
		_Map.setEntityArray(entMales, false, kMale+"[]", "", kMale);
		_Map.setEntityArray(entFemales, false, kFemale+"[]", "", kFemale);
		
		setExecutionLoops(2);
		return;
	}//endregion
		
//region Trigger AddProduct
	String sTriggerAddProduct = T("|Add/Edit Product|");
	addRecalcTrigger(_kContext, sTriggerAddProduct );
	if (_bOnRecalc && _kExecuteKey == sTriggerAddProduct)
	{
		mapTsl.setInt("DialogMode", 1);
		
		String manufacturer = sManufacturer;
		String family = sFamily;
		String product = sProduct;
		
		sProps.append(manufacturer);
		sProps.append(family);
		sProps.append(selectedProduct);
		
		double minWidth = dWidthMale, maxWidth = dMaxWidth, innerWidth = A > 0 ? A : dWidthMale, minHeight = dMinHeight, maxHeight = dMaxHeight;
		dProps.append(innerWidth);
		dProps.append(dThickness);
		dProps.append(minWidth);
		dProps.append(maxWidth);
		dProps.append(minHeight);
		dProps.append(maxHeight);
		
		tslDialog.dbCreate(scriptName(),_XW,_YW,gbsTsl,entsTsl,ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);
		
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{
				manufacturer = tslDialog.propString(0);
				family = tslDialog.propString(1);
				product = tslDialog.propString(2);
				
				innerWidth = tslDialog.propDouble(0);
				dThickness = tslDialog.propDouble(1);
				minWidth = tslDialog.propDouble(2);
				maxWidth = tslDialog.propDouble(3);
				minHeight = tslDialog.propDouble(4);
				maxHeight = tslDialog.propDouble(5);
				
				//region Validate input
				String err;
				if (manufacturer.length() < 1) err += TN(" -|The name of the manufacturer is mandatory.|");
				if (family.length() < 1) err += TN(" -|The name of the family is mandatory.|");
				if (product.length() < 1) err += TN(" -|The name of the product is mandatory.|");
				if (err.length() > 0)
				{
					reportNotice(TN("|Adding a new product was not successful.|") + err);
					tslDialog.dbErase();
					setExecutionLoops(2);
					return;
				}
				//endregion
				
				//region Purge existing manufacturers/families/product
				// Manufacturer: get a copy of a potential existing manufacturer
				Map mapManufacturer;
				for (int i = 0; i < mapManufacturers.length(); i++)
				{
					Map m = mapManufacturers.getMap(i);
					String _manufacturerName = m.getMapName();
					if (manufacturer.find(_manufacturerName, 0, false) >- 1 && manufacturer.length() == _manufacturerName.length())
					{
						mapManufacturer = m;
						mapManufacturers.removeAt(i, true);
						break;
					}
				}//next i
				
				// family: get a copy of a potential existing family
				Map mapFamily, mapFamilies = mapManufacturer.getMap("Family[]");
				for (int i = 0; i < mapFamilies.length(); i++)
				{
					Map m = mapFamilies.getMap(i);
					String _familyName = m.getMapName();
					if (family.find(_familyName, 0, false) >- 1 && family.length() == _familyName.length())
					{
						mapFamily = m;
						mapFamilies.removeAt(i, true);
						break;
					}
				}//next i
				
				// Product: do NOT get a copy of a potential existing product, but remove from products
				Map mapProduct, mapProducts = mapFamily.getMap("Product[]");
				for (int i = 0; i < mapProducts.length(); i++)
				{
					Map m = mapProducts.getMap(i);
					String _productName = m.getMapName();
					if (product.find(_productName, 0, false) >- 1 && product.length() == _productName.length())
					{
						//mapProduct = m;
						mapProducts.removeAt(i, true);
						break;
					}
				}//next i
				//endregion
				
				//region Write new product
				mapProduct.setMapName(product);
				if (innerWidth > dEps) mapProduct.setDouble("A", innerWidth);
				if (dThickness > dEps) mapProduct.setDouble("t", dThickness);
				if (minWidth > dEps)
				{
					mapProduct.setDouble(kMinWidthJoist, minWidth);
					if (maxWidth > dEps)
						mapProduct.setDouble(kMaxWidthJoist, maxWidth);
				}
				if (minHeight > dEps)mapProduct.setDouble(kMinHeightJoist, minHeight);
				if (maxHeight > dEps)mapProduct.setDouble(kMaxHeightJoist, maxHeight);
				
				mapProducts.appendMap("Product", mapProduct);
				
				mapFamily.setMapName(family);
				mapFamily.setMap("Product[]", mapProducts);
				mapFamilies.appendMap(kFamily, mapFamily);
				
				mapManufacturer.setMap(kFamilies, mapFamilies);
				mapManufacturer.setMapName(manufacturer);
				
				Map mapOut;
				mapOut.setMap(kManufacturer, mapManufacturer);
				
				String entryName = kGeneric + manufacturer;
				
			// write mob	
				MapObject mob(sDictionary, entryName);
				if (mob.bIsValid())
					mob.setMap(mapOut);
				else
					mob.dbCreate(mapOut);
				
				
			// update defaults
				if (sManufacturers.findNoCase(manufacturer,-1)<0)
				{ 
					Map m;
					m.setMapName(manufacturer);
					m.setString("URL", "");
					reportNotice("\n" +manufacturer + T("| has been appended to default manufacturers|"));
					mapManufacturers.appendMap(kManufacturer, m);
					
					mapSetting.setMap("Manufacturer[]", mapManufacturers);
					if (mo.bIsValid())mo.setMap(mapSetting);
					else mo.dbCreate(mapSetting);
					
				}
					
//				mapManufacturers.appendMap(kManufacturer, mapManufacturer);
//				
//				mapSetting.setMap("Manufacturer[]", mapManufacturers);
//				if (mo.bIsValid())mo.setMap(mapSetting);
//				else mo.dbCreate(mapSetting);
//				
//				
				//endregion
				
				// set to current
				sManufacturer.set(manufacturer);
				sFamily.set(family);
				sProduct.set(product);
				
			}
			tslDialog.dbErase();
			
			if (!bOk) // HSB-23507 exit on cancel
			{ 
				setExecutionLoops(2);
				return;			
			}
			
		}
		
		// prompt for block entities
		Entity ents[0];
		PrEntity ssE(T("|Select entities representing the new hanger|"), Entity());
		if (ssE.go())
			ents.append(ssE.set());
		
		// remove any parent entity
		for (int i = ents.length() - 1; i >= 0; i--)
		{
			if (entMales.find(ents[i]) >- 1 || entFemales.find(ents[i]) >- 1 || ents[i] == _ThisInst)
			{
				ents.removeAt(i);
				continue;
			}
			
			BlockRef bref = (BlockRef)ents[i];
			if (bref.bIsValid())
			{
				String p = product;
				if (bref.definition().makeLower() == p.makeLower())
				{
					reportNotice("\n" + "***** " + T("|Warning| ") + scriptName() + " *****" +
					TN("|The selection set contains a block reference with the name of the product.|") +
					TN("|This would create a circular reference and thus it is not supported.|") +
					TN("|Please explode the block, choose a different product name or export as WBLOCK to|\n") +
					_kPathHsbCompany + "\\Block\\" + manufacturer);
					ents.setLength(0);
					break;
				}
			}
		}
		
		
		// write block
		if (ents.length() > 0)
		{
			CoordSys csRef(_Pt0, - vecX , vecZ, vecY);
			Block block(product, false);
			block.dbCreate();
			if (block.bIsValid())
				for (int i = 0; i < ents.length(); i++)
				{
					Entity clone = block.addEntity(ents[i], csRef);
					if (clone.bIsValid())
						clone.setColor(0); //set color byBlock
				}//next i
			
			if (block.bIsValid() && block.entity().length() > 0)
			{
				String path = _kPathHsbCompany;
				String folders[] = getFoldersInFolder(path);
				if (folders.findNoCase("Block", - 1) < 0)
					makeFolder(path + "\\Block");
				path += "\\Block";
				
				folders = getFoldersInFolder(path);
				if (folders.findNoCase(manufacturer, - 1) < 0)
					makeFolder(path + "\\" + manufacturer);
				path += "\\" + manufacturer;
				
				int bOk = getFoldersInFolder(_kPathHsbCompany + "\\Block").findNoCase(manufacturer ,- 1) >- 1;
				
				String file = path + "\\" + product + ".dwg";
				if (bOk && block.writeToDwg(file))
					reportNotice(TN("|The block definition for the product| ") + product + T("|has been successfully created |\n") + file);
			}
		}
		setExecutionLoops(2);
		return;
	}//endregion

//region Trigger AddFixture
	String sTriggerAddFixture = T("|Add/Edit Fixtures|");
	addRecalcTrigger(_kContext, sTriggerAddFixture );
	if (_bOnRecalc && _kExecuteKey == sTriggerAddFixture)
	{
		mapTsl.setInt("DialogMode", 5);

		hwcFixtures = HardWrComp().showDialog(hwcFixtures);

		String entry = T("|Custom|");
		if (hwcFixtures.length()>0 && hwcFixtures.first().articleNumber()!="")
			entry = hwcFixtures.first().articleNumber();
	
		mapTsl.setString(kFamily, sFamily);
		mapTsl.setString(kProduct, selectedProduct);
		sProps.append(entry);
		sProps.append(selectedProduct);
	
		tslDialog.dbCreate(scriptName() , _XW, _YW, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
	
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)	
			{
				entry = tslDialog.propString(0);				
				int bProductOnly = tslDialog.propString(1) == selectedProduct;
				int bFamilyOnly = tslDialog.propString(1) == sFamily;
				
				Map mapEntry, mapHwcs;
				if (bProductOnly)
					mapEntry.setString(kProduct, selectedProduct );
				else if (bFamilyOnly)
					mapEntry.setString(kFamily, sFamily );
				
				for (int i=0;i<hwcFixtures.length();i++) 
				{ 
					HardWrComp hwc= hwcFixtures[i]; 
					
					Map m;
					m.setString(kName, hwc.name());
					m.setString(kManufacturer, hwc.manufacturer());
					m.setString(kArticle, hwc.articleNumber());
					m.setString(kDescription, hwc.description());
					m.setString(kModel, hwc.model());
					m.setString(kGroup, hwc.group());
					m.setString(kMaterial, hwc.material());
					m.setString(kCategory, hwc.category());
					m.setString(kNotes, hwc.notes());

					m.setDouble(kScaleX, hwc.dScaleX());
					m.setDouble(kScaleY, hwc.dScaleY());
					m.setDouble(kScaleZ, hwc.dScaleZ());
					
					m.setInt(kQuantity, hwc.quantity());
					
					mapHwcs.appendMap(kHardWrComp, m);	 
				}//next i
				mapEntry.setMap(kHardWrComps, mapHwcs);	
				mapEntry.setMapName(entry);
			
			// write entries
				for (int i=0;i<mapFixtures.length();i++) 
				{ 
					String name= mapFixtures.getMap(i).getMapName();
					if (entry.find(name,0,false)==0 && entry.length()==name.length())
					{
						mapFixtures.removeAt(i, true);
						break;
					}	 
				}//next i
				
				if (hwcFixtures.length()>0) // empty list of hardware will remove the entry
					mapFixtures.appendMap(kFixture, mapEntry);
				
				mapSetting.setMap(kFixtures, mapFixtures);
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);	
			}
			tslDialog.dbErase();
		}
		setExecutionLoops(2);
		return;
	}//endregion



//region Trigger StiffenerBackerProperties
	String sTriggerStiffProperties = T("|Edit Stiffener / Backer Block Properties|");

	// not relevant
	if(!bBackerPossible && !bWebStiffenerPossible)
	{ 
		sStiffener.setReadOnly(bDebug?false:_kHidden);
	}
	else if(bBackerPossible && !bWebStiffenerPossible)
	{ 
		String enums[]={kDisabled,tRTBacker};
		sStiffener.setEnumValues(enums);
		if (sStiffener == tRTBoth)sStiffener.set(tRTBacker);
		sTriggerStiffProperties = T("|Edit Backer Block Properties|");
	}
	else if(!bBackerPossible && bWebStiffenerPossible)
	{ 
		String enums[]={kDisabled,tRTStiffener};
		sStiffener.setEnumValues(enums);
		if (sStiffener == tRTBoth)sStiffener.set(tRTStiffener);
		sTriggerStiffProperties = T("|Edit Web Stiffener Properties|");
	}

	if(bBackerPossible || bWebStiffenerPossible)
		addRecalcTrigger(_kContext, sTriggerStiffProperties );
	if (_bOnRecalc && (_kExecuteKey == sTriggerStiffProperties && (bBackerPossible || bWebStiffenerPossible)))
	{
		mapTsl.setInt("DialogMode", 2);
		mapTsl.setInt("BackerPossible",bBackerPossible);
		mapTsl.setInt("WebStiffenerPossible",bWebStiffenerPossible);
		
		// web stiffener
		sProps.append(tRTStiffener);
		sProps.append(tMaterialStiff);
		nProps.append(nColorStiff);
		dProps.append(dLengthStiff);
		dProps.append(dExtraStiff);
		dProps.append(dGapStiff);
		// backer block
		sProps.append(tRTBacker);
		sProps.append(tMaterialBacker);
		nProps.append(nColorBacker);
		dProps.append(dLengthBacker);
		dProps.append(dExtraBacker);
		dProps.append(dGapBacker);
		
		tslDialog.dbCreate(scriptName(),_XW,_YW,gbsTsl,entsTsl,
			ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);
		
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{
				tRTStiffener = tslDialog.propString(0);
				tMaterialStiff = tslDialog.propString(1);
				nColorStiff = tslDialog.propInt(0);
				dLengthStiff = tslDialog.propDouble(0);
				dExtraStiff = tslDialog.propDouble(1);
				dGapStiff = tslDialog.propDouble(2);
				
				tRTBacker = tslDialog.propString(2);
				tMaterialBacker = tslDialog.propString(3);
				nColorBacker = tslDialog.propInt(1);
				dLengthBacker = tslDialog.propDouble(3);
				dExtraBacker = tslDialog.propDouble(4);
				dGapBacker = tslDialog.propDouble(5);

				Map m;
				m.setString(kName, tRTStiffener);
				m.setString(kMaterial, tMaterialStiff);
				m.setDouble(kLength, dLengthStiff);
				m.setDouble(kExtraLength, dExtraStiff);
				m.setDouble(kGap, dGapStiff);
				m.setInt(kColor, nColorStiff);
				mapSetting.setMap(kStiffs,m);

				m.setString(kName, tRTBacker);
				m.setString(kMaterial, tMaterialBacker);
				m.setDouble(kLength, dLengthBacker);
				m.setDouble(kExtraLength, dExtraBacker);
				m.setDouble(kGap, dGapBacker);
				m.setInt(kColor, nColorBacker);
				mapSetting.setMap(kBackers,m);

				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);
				
				_Map.setInt(kCreateStiffBacker, true);

			}
			tslDialog.dbErase();
		}
		setExecutionLoops(2);
		return;
	}
	
	if(_kNameLastChangedProp==sStiffenerName)
	{ 
		// erase
		if(sStiffener!=tRTStiffener && sStiffener!=tRTBoth)
		{ 
		// delete web stiffener
			Map mapStiffeners = _Map.getMap("Stiffener[]");
			for (int i=0;i<mapStiffeners.length();i++) 
			{ 
				Entity ent = mapStiffeners.getEntity(i); 
				if (ent.bIsValid())entStiffeners.append(ent);
			}//next i
			for (int i=entStiffeners.length()-1; i>=0 ; i--) 
			{ 
				entStiffeners[i].dbErase();
			}//next i
			_Map.removeAt("Stiffener[]",true);
		}
		if(sStiffener!=tRTBacker && sStiffener!=tRTBoth)
		{ 
		// delete web stiffener
			Entity _entBacker = _Map.getEntity(kBacker);
			_entBacker.dbErase();
			_Map.removeAt(kBacker,true);
		}
		// create
		if(sStiffener==tRTStiffener || sStiffener==tRTBacker || sStiffener==tRTBoth)
		{ 
			_Map.setInt(kCreateStiffBacker, true);
			setExecutionLoops(2);
			return;
		}
	}
	
	
	//endregion

//region Trigger SelectManufacturersc #SM
	String sTriggerSelectManufacturers = T("|Select Manufacturers|");
	addRecalcTrigger(_kContext, sTriggerSelectManufacturers );
	if (_bOnRecalc && _kExecuteKey==sTriggerSelectManufacturers)
	{
		Map mapIn = mapSetupManufacturer;
		Map rowDefinitions= mapIn.getMap(kRowDefinitions);
		
		// add default
		if (rowDefinitions.length()<1)
		{
			for (int i=0;i<sManufacturers.length();i++) 
			{ 
		        Map row ;
		        row.setString("Manufacturer", sManufacturers[i]);
		        row.setInt("ACTIVE", true);
//		        row.setInt("COLOR", 3);
//		        row.setInt("TRANSPARENCY", 80);
		        rowDefinitions.setMap("row"+(i+1),row);			
			}
			mapIn.setMap(kRowDefinitions, rowDefinitions);
		}

		Map mapOut = ShowManufacturerDialog(mapIn);
		
	// Check Selection	
		if (mapOut.length()>0)
		{ 
			String entries[0];
			int actives[0];
			int numActive = GetActiveEntries(mapOut, entries, actives);				

		// enable manufacturers which are currently in use	
			String sErrMsg, sManufacturersInUse[] = CollectManufacturersInUse();
			for (int i=0;i<entries.length();i++) 
			{ 
				int& bActive = actives[i];
				if (sManufacturersInUse.findNoCase(entries[i],-1)>-1 && !bActive)
				{
					bActive = true;
					sErrMsg += (sErrMsg.length() > 0 ? ", " : "") + entries[i];
				}				 
			}//next i

		// not enoughh active manufacturers
			if (numActive<1)
			{ 
				Map mapNoticeIn;
				mapNoticeIn.setString("Notice", T("|The configuration of the manufacturers is invalid.|")+TN("|At least one manufacturer needs to be selected, selection is not saved.|"));
				Map mpNoticeOut = callDotNetFunction2(sDialogLibrary, sClass, "ShowNotice", mapNoticeIn);	
				setExecutionLoops(2);
				return;				
			}
		// attempt to disable a manufacturer which is in use	
			else if (sErrMsg.length()>0)
			{ 
				Map mapNoticeIn;
				mapNoticeIn.setString("Notice", T("|The configuration of the manufacturers is invalid.|\n")+sErrMsg + T(" |cannot be disabled because there are instances in the drawing.|"));
				Map mpNoticeOut = callDotNetFunction2(sDialogLibrary, sClass, "ShowNotice", mapNoticeIn);
				
			// rewrite with corrected/updated values	
				mapOut = Map();
				for (int i=0;i<entries.length();i++) 
				{ 
			        Map row ;
			        row.setString("Manufacturer", entries[i]);
			        row.setInt("ACTIVE", actives[i]);
	//		        row.setInt("COLOR", 3);
	//		        row.setInt("TRANSPARENCY", 80);
			        mapOut.setMap("row"+(i+1),row);			
				}
				mapSetupManufacturer.setMap(kRowDefinitions, mapOut);
				
			}
		// valid config	
			else
				mapSetupManufacturer.setMap(kRowDefinitions, mapOut);
			
			Map mapSetup = mapSetting.getMap("Setup");
			mapSetup.setMap("Manufacturer", mapSetupManufacturer);
			mapSetting.setMap("Setup", mapSetup);

			if (mo.bIsValid())mo.setMap(mapSetting);
			else mo.dbCreate(mapSetting);			
			
		}

		
		setExecutionLoops(2);
		return;
	}//endregion	

//
////region Trigger Add Manufacturer
//	String sTriggerAddManufacturer = T("|Add Manufacturer to Defaults|");
//	//addRecalcTrigger(_kContext, sTriggerAddManufacturer );
//	if (_bOnRecalc && _kExecuteKey==sTriggerAddManufacturer)
//	{		
//		String newManufacturers[0];	
//		for (int j=0;j<2;j++) 
//		{ 
//			String path = j==0?sPathCompany:sPathGeneral;
//			String files[] = getFilesInFolder(path, kGeneric+"*.*");
//
//			for (int i=0;i<files.length();i++) 
//			{ 
//				String entry = files[i].left(files[i].length() - 4);
//				entry = entry.right(entry.length() - kGeneric.length());
//				if (newManufacturers.find(entry)<0 && sManufacturers.find(entry)<0)
//					newManufacturers.append(entry);
//			}		
//		}//next j
//
//		if (newManufacturers.length()<1)
//		{ 
//			reportNotice("\n\n"+ scriptName() + TN("|Could not find any additional manufacturer in one of the following folders:|") + 
//				"\n	"+sPathCompany+ "\n	"+sPathGeneral);
//		}
//		else
//		{ 
//			mapTsl.setInt("DialogMode", 3);
//			for (int i=0;i<newManufacturers.length();i++) 
//				mapTsl.appendString("manuf", newManufacturers[i]); 
//
//			tslDialog.dbCreate(scriptName() , _XW, _YW, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
//			
//			if (tslDialog.bIsValid())
//			{
//				int bOk = tslDialog.showDialog();
//				if (bOk)
//				{
//					String manufacturer = tslDialog.propString(0);
//					if (sManufacturers.findNoCase(manufacturer,-1)<0)
//					{ 
//						Map m;
//						m.setMapName(manufacturer);
//						m.setString("URL", "");
//						reportNotice("\n" +manufacturer + T("| has been appended to default manufacturers|"));
//						mapManufacturers.appendMap(kManufacturer, m);
//					}
//					mapSetting.setMap("Manufacturer[]", mapManufacturers);
//					if (mo.bIsValid())mo.setMap(mapSetting);
//					else mo.dbCreate(mapSetting);
//				}
//				tslDialog.dbErase();
//			}
//			setExecutionLoops(2);
//			return;			
//		}
//
//
//		setExecutionLoops(2);
//		return;
//	}//endregion	
//
//
////region Trigger Remove Manufacturer
//	String sTriggerRemoveManufacturer = T("|Remove Manufacturer from Defaults|");
//	//addRecalcTrigger(_kContext, sTriggerRemoveManufacturer );
//	if (_bOnRecalc && _kExecuteKey==sTriggerRemoveManufacturer)
//	{
//
//		mapTsl.setInt("DialogMode", 4);
//		for (int i=0;i<sManufacturers.length();i++) 
//		{ 
//			mapTsl.appendString("manuf", sManufacturers[i]); 
//			 
//		}//next i
//		tslDialog.dbCreate(scriptName() , _XW, _YW, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
//		
//		if (tslDialog.bIsValid())
//		{
//			int bOk = tslDialog.showDialog();
//			if (bOk)
//			{
//				String manufacturer = tslDialog.propString(0);
//
//				reportMessage("\n" + scriptName() + ": " +T("|TODO|"));
//				
//				for (int i=0;i<mapManufacturers.length();i++) 
//				{ 
//					String name =mapManufacturers.getMap(i).getMapName();
//					if (name == manufacturer)
//					{
//						mapManufacturers.removeAt(i, true);
//						break;
//					}
//				}//next i
//				
//				mapSetting.setMap(kManufacturer + "[]", mapManufacturers);
//				if (mo.bIsValid())mo.setMap(mapSetting);
//				else mo.dbCreate(mapSetting);
//
//			}
//			tslDialog.dbErase();
//		}
//
//
//		setExecutionLoops(2);
//		return;
//	}//endregion
//	
	
//region Trigger Export Hanger Definition
	String sTriggerExportHangerDefinition = T("|Export Hanger Definitions| ") + sManufacturer;
	addRecalcTrigger(_kContext, sTriggerExportHangerDefinition );
	if (_bOnRecalc && _kExecuteKey==sTriggerExportHangerDefinition)
	{
		String entry = kGeneric + sManufacturer;
		String fullPath = sPathCompany + "\\" + entry + ".xml";
		MapObject mob(sDictionary, entry);
		Map map = mob.map();
		if (map.length()>0)
		{
			map.writeToXmlFile(fullPath);
			
			if (findFile(fullPath).length()>0)
				reportMessage("\n"+sManufacturer + T(" |hanger definitions successfully exported to| ") + fullPath);
			else
				reportMessage("\n"+sManufacturer + T(" |hanger definitions not exported|"));
		}

		setExecutionLoops(2);
		return;
	}//endregion
		
//region Trigger ImportHangerDefinition
// HSB-19651: add trigger to import manufacturer
	String sTriggerImportHangerDefinition = T("|Import Hanger Definitions|")+" "+sManufacturer;
	String sHangerImportPath = sPathCompany + "\\" + kGeneric + sManufacturer + ".xml";
	
	if (findFile(sHangerImportPath).length()>0)
		addRecalcTrigger(_kContext, sTriggerImportHangerDefinition );
	if (_bOnRecalc && _kExecuteKey==sTriggerImportHangerDefinition)
	{
		String entry = kGeneric + sManufacturer;
		String fullPath = sHangerImportPath;
		
		Map mapGeneral = mapSetting.getMap("GeneralMapObject");
		// import the manufacturer
		Map map;
		int bSuccess=map.readFromXmlFile(fullPath);
		
		if(!bSuccess)
		{ 
			reportMessage("\n"+scriptName()+" "+fullPath+" "+T("|not found|"));
			setExecutionLoops(2);
			return;
		}
		
		MapObject mob(sDictionary, entry);
		mob.setMap(map);

		setExecutionLoops(2);
		return;
	}//endregion	
	


	
//region Trigger Tagging Settings	
	String sTriggerTagSetting = T("|Tag Settings|");
	addRecalcTrigger(_kContext, sTriggerTagSetting );
	if (_bOnRecalc && _kExecuteKey==sTriggerTagSetting)	
	{ 
		mapTsl.setInt("DialogMode",6);
		
		String sSeqColor = TokenizeIntArray(GetIntArray(mapSequentialColors, false),";",  true);

		String sTagMode = nTagMode >- 1 && nTagMode < sTagModes.length() ? sTagModes[nTagMode] : tTMDisabled;
		sProps.append(sTagMode);
		sProps.append(sSeqColor);
			
		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{ 
				Map m;
				
			// tag mode	
				sTagMode = tslDialog.propString(0);
				int nTagMode = sTagModes.findNoCase(sTagMode, 0);
				m = mapSetting.getMap(kTag);
				m.setInt("Mode", nTagMode);
				mapSetting.setMap(kTag, m);	
				if (nTagMode>0)
					_Map.setInt("AddTags", true);

			// seq color	
				sSeqColor = tslDialog.propString(1);
				nSeqColors = GetIntTokens(sSeqColor, ";");
				m = SetIntArray(nSeqColors,"Color");
				mapSetting.setMap(kTagSeqColor, m);

				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);				
			}
			tslDialog.dbErase();
		}
		setExecutionLoops(2);
		return;	
	}//endregion

// Trigger AllowAngleDeviation // HSB-23403
	String sTriggerAllowAngleDeviation =bAllowAngleDeviation?T("|Angle Deviation off|"):T("|Allow Angle Deviation|");
	addRecalcTrigger(_kContext, sTriggerAllowAngleDeviation);
	if (_bOnRecalc && _kExecuteKey==sTriggerAllowAngleDeviation)
	{
		bAllowAngleDeviation = !bAllowAngleDeviation;
		
		Map m = mapSetting.getMap(kParameter);
		
		Map mpNoticeIn;
		mpNoticeIn.setString("Title", T("|Angle Deviation|"));
		if (bAllowAngleDeviation)
		{
			mpNoticeIn.setString("Notice",T("|Hangers designed for perpendicular connections\nwill tolerate a ±2° angular deviation.|"));
			m.setDouble("AllowedAngularDeviation", 5,_kAngle);
		}
		else
		{
			mpNoticeIn.setString("Notice",T("|Hangers designed for perpendicular connections\nwill not tolerate any angular deviation.|"));
			m.removeAt("AllowedAngularDeviation", true);
		}			
		Map mpNoticeOut = callDotNetFunction2(sDialogLibrary, sClass, showNoticeMethod, mpNoticeIn);
		
	
		mapSetting.setMap(kParameter, m);
		if (mo.bIsValid())mo.setMap(mapSetting);
		else mo.dbCreate(mapSetting);		
		setExecutionLoops(2);
		return;
	}


//region Trigger Import/Export Settings
	if (findFile(sFullPath).length()>0)
	{ 
		String sTriggerImportSettings = T("|Import Settings|");
		addRecalcTrigger(_kContext, sTriggerImportSettings );
		if (_bOnRecalc && _kExecuteKey==sTriggerImportSettings)
		{
			mapSetting.readFromXmlFile(sFullPath);	
			if (mapSetting.length()>0)
			{ 
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);	
				reportMessage(TN("|Settings successfully imported from| ") + sFullPath);	
			}
			setExecutionLoops(2);
			return;
		}			
	}

// Trigger ExportSettings
	if (mapSetting.length() > 0)
	{
		String sTriggerExportSettings = T("|Export Settings|");
		addRecalcTrigger(_kContext, sTriggerExportSettings );
		if (_bOnRecalc && _kExecuteKey == sTriggerExportSettings)
		{
			int bWrite;
			if (findFile(sFullPath).length()>0)
			{ 
				String sInput = getString(T("|Are you sure to overwrite existing settings?|") + " [" + T("|No|") +"/"+T("|Yes|")+"]").left(1);
				bWrite = sInput.makeUpper() == T("|Yes|").makeUpper().left(1);
			}
			else bWrite = true;
				
			if (bWrite && mapSetting.length() > 0)
			{ 
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);
				
			// make sure the path exists	//HSB-10750
				int bPathFound= sFolders.find(sFolder)>-1?true:makeFolder(sPath+"\\"+sFolder);	
				
			// write file	
				mapSetting.writeToXmlFile(sFullPath);
				
			// report rsult of writing	
				if (findFile(sFullPath).length()>0)		reportMessage(TN("|Settings successfully exported to| ") + sFullPath);
				else									reportMessage(TN("|Failed to write to| ") + sFullPath);		
			}
			
			setExecutionLoops(2);
			return;
		}
	}
	//endregion 


//region Trigger PrintCommand
	String sTriggerPrintCommand = T("|Show Command for UI Creation|");
	addRecalcTrigger(_kContext, sTriggerPrintCommand );
	if (_bOnRecalc && _kExecuteKey==sTriggerPrintCommand)
	{
		String text = TN("|You can create a toolbutton, a palette- or a ribbon command using the following command.|")+
			TN("|Copy the line below into the command property of the button definition|");	
		
		String command;
		
		if (sProduct==kAuto)
			command= "^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert " + "\"GenericHanger\" \"" + sManufacturer + "?" + sFamily + "\")) TSLCONTENT";
		else
		{ 
			String entry = sManufacturer + "_" + sFamily + "_" + sProduct;
			text += TN("|The catalog entry| ") + entry + T(" |has been created for you.|");
			setCatalogFromPropValues(entry);
			command= "^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert " + "\"GenericHanger\" \"" + entry+ "\")) TSLCONTENT";
		}
		// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "GenericHanger" "StrongTie?ITSE")) TSLCONTENT
		
		reportNotice(text +"\n\n"+ command);		
		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger ReportIssues
	String sTriggerReportIssues = T("|Show Selection Log|");
	if (sIssues.length() > 0)
	{
		addRecalcTrigger(_kContext, sTriggerReportIssues );
		if ((_bOnRecalc && _kExecuteKey == sTriggerReportIssues) )//||_kNameLastChangedProp==sFamilyName)
		{
			reportNotice("\n" + scriptName() + T("|has detected the follwing issues|\n"));
			for (int i = 0; i < sIssues.length(); i++)
			{
				reportNotice("\n	" + sIssues[i]);
				
			}//next i
			
			setExecutionLoops(2);
			return;
		}
	}
	//endregion	
	
//region Trigger ShowSettings // for debug view the map file
	String sTriggerShowSettings = T("|Show Settings|");
	if (bDebug)addRecalcTrigger(_kContextRoot, sTriggerShowSettings );
	if (_bOnRecalc && _kExecuteKey == sTriggerShowSettings)
	{
		String sTempFile = _kPathPersonalTemp + "\\" + scriptName() + "_Settings.dxx";
		mapSetting.writeToDxxFile(sTempFile);
		spawn_detach("", _kPathHsbInstall + "\\Utilities\\hsbMapExplorer\\hsbMapExplorer.exe", sTempFile, "");
		setExecutionLoops(2);
		return;
	}//endregion
	
}
// end trigger
//endregion 
































#End
#BeginThumbnail
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
-#0````!)14Y$KD)@@@``























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
        <int nm="BreakPoint" vl="4772" />
        <int nm="BreakPoint" vl="4757" />
        <int nm="BreakPoint" vl="5086" />
        <int nm="BreakPoint" vl="5087" />
        <int nm="BreakPoint" vl="3831" />
        <int nm="BreakPoint" vl="3823" />
        <int nm="BreakPoint" vl="3851" />
        <int nm="BreakPoint" vl="4122" />
        <int nm="BreakPoint" vl="1832" />
        <int nm="BreakPoint" vl="3744" />
        <int nm="BreakPoint" vl="3751" />
        <int nm="BreakPoint" vl="3651" />
        <int nm="BreakPoint" vl="4700" />
        <int nm="BreakPoint" vl="1509" />
        <int nm="BreakPoint" vl="4207" />
        <int nm="BreakPoint" vl="3607" />
        <int nm="BreakPoint" vl="1696" />
        <int nm="BreakPoint" vl="3617" />
        <int nm="BreakPoint" vl="2678" />
        <int nm="BreakPoint" vl="2737" />
        <int nm="BreakPoint" vl="3691" />
        <int nm="BreakPoint" vl="3972" />
        <int nm="BreakPoint" vl="3960" />
        <int nm="BreakPoint" vl="3864" />
        <int nm="BreakPoint" vl="3897" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23725 top mounted hangers bugfix" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="25" />
      <str nm="Date" vl="3/19/2025 4:38:32 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23403 new angle deviation toggle, angled hangers improved, web stiffeners improved, new command to disable stretching" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="24" />
      <str nm="Date" vl="3/13/2025 2:22:16 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23403 accepting hangers in range of angles." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="23" />
      <str nm="Date" vl="3/3/2025 11:48:18 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23507 Add/Edit Product: cancel will not prompt for entites" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="22" />
      <str nm="Date" vl="2/19/2025 11:30:53 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23101 invalid tagging configuration does not break insertion, issue reporting enhanced" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="21" />
      <str nm="Date" vl="12/11/2024 10:58:07 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23031 new property to specify group assignment" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="20" />
      <str nm="Date" vl="11/22/2024 5:31:01 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22462 new context commands to specify tag behaviour, validation of products specified in manufacturer definitions" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="19" />
      <str nm="Date" vl="11/19/2024 5:27:37 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22462 auto product detection improved, new command to filter manufacturers, new bulk insertion for beam connections." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="18" />
      <str nm="Date" vl="11/14/2024 5:57:58 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="20231020: Fix when finding valid products; on creation check backers again to consider neighbouring instances" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="17" />
      <str nm="Date" vl="10/20/2023 11:20:11 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19651: add trigger to import manufacturer; fix when getting dX,dY of profile" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="16" />
      <str nm="Date" vl="10/6/2023 3:07:43 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20091: fix for width matching in auto selection" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="15" />
      <str nm="Date" vl="10/6/2023 11:16:55 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20088: Fix multiple male beam insert" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="14" />
      <str nm="Date" vl="10/6/2023 10:53:20 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20089: Add property for the backer blocks and web stiffeners" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="13" />
      <str nm="Date" vl="9/28/2023 1:33:26 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20089: in auto selection check the hanger doesnt collide with the female beam" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="12" />
      <str nm="Date" vl="9/28/2023 8:30:58 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20090: merge backer blocks if they intersect" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="11" />
      <str nm="Date" vl="9/27/2023 3:55:20 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20088: Improve distribution of male-female connections" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="10" />
      <str nm="Date" vl="9/27/2023 9:44:49 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20087: Add behaviour copy with beams" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="9/26/2023 1:16:45 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14325 element based orientation enhanced" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="3/18/2022 11:15:32 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14325 bugfixes on multi insert" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="3/17/2022 5:38:34 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14325 web stiffener and backer blocks excluded as reference beams" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="3/16/2022 3:16:54 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14325 skewed connevctions corrected" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="3/16/2022 12:17:24 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14929 custom fixtures added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="3/15/2022 4:59:45 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14929 default fixtures added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="3/14/2022 5:12:15 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14928 supports splitting of male or female beams" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="3/14/2022 11:12:28 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14924 backer block creation improved" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="3/11/2022 12:18:52 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14805 default suppliers improved, export command of current manufacturer added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="2/25/2022 4:38:53 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14805 localisiation of manufacturers supported" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="2/25/2022 12:17:05 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14791 stiffeners and backer blocks added for EWP products" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="2/22/2022 4:36:35 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14325 supporting adjustable height straps, new helper command to print command string" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="2/21/2022 5:36:33 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14325 cloning and multiple insertion supported" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="2/7/2022 4:58:20 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14325 skewed hangers added" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="2/4/2022 3:37:30 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14325 skewed hangers added" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="2/4/2022 12:50:37 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14325 custom product definition added" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="2/3/2022 2:06:23 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14325 supports marking, predefinied joist ranges, top flush alignment" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="2/2/2022 3:17:41 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14325 initial beta version" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="1/26/2022 4:22:40 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End