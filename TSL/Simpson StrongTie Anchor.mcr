#Version 8
#BeginDescription
#Versions:
Version 2.13 11.11.2025 HSB-24881: Add property "CNC catalog" for the hsbCNC tsl; Implement ondberase , Author: Marsel Nakuci
2.12 15.03.2022 HSB-14511: tooling width/height defined as extra measures Author: Marsel Nakuci
2.11 04.03.2022 HSB-14511: add properties to add toolig for each sheeting zone Author: Marsel Nakuci
HSB-6082: show display from the blocks 
HSB-6081: fix gap dXTotal = dC + dInterdistance 
HSB-6081: Families are read from xml 
HSB-6081: Add family HD
bugfix Family AH avoid creating triangles
new family added: AH
bugfix placement on icon&/opposite side in plan view
supports special type overrides based on the projectSpecial settings
icon side is default side of mounting sheet with alignment left/right 

new property to specify the side of the mounting sheet
bugfix unit 
bugfix alignment beam 
sheet based on first zone defined
creates blocking if inbetween studs and with mounting sheet
requires hsbCNC 6.8 or higher 



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 13
#KeyWords Simpson,anchor,HTT
#BeginContents
/// <History>//region
/// #Versions:
// 2.13 11.11.2025 HSB-24881: Add property "CNC catalog" for the hsbCNC tsl; Implement ondberase , Author: Marsel Nakuci
// 2.12 15.03.2022 HSB-14511: tooling width/height defined as extra measures Author: Marsel Nakuci
// 2.11 04.03.2022 HSB-14511: add properties to add toolig for each sheeting zone Author: Marsel Nakuci
/// <version value="2.10" date="04.12.2019" author="marsel.nakuci@hsbcad.com"> HSB-6082: show display from the blocks </ version > 
/// <version value="2.9" date="04.12.2019" author="marsel.nakuci@hsbcad.com"> HSB-6109: fix gap dXTotal = dC + dInterdistance </ version > 
/// <version value="2.8" date="03.12.2019" author="marsel.nakuci@hsbcad.com"> HSB-6081: Families are read from xml </ version > 
/// <version value="2.7" date="03.12.2019" author="marsel.nakuci@hsbcad.com"> HSB-6081: Transfer the families and parameters into an xml </ version > 
/// <version value="2.6" date="03.12.2019" author="marsel.nakuci@hsbcad.com"> HSB-6081: Add family HD </version>
/// <version value="2.5" date=/2/2"16okt2019" author="nils.gregor@hsbcad.com"> bugfix Family AH avoid creating triangles  </version>
/// <version value="2.4" date="24sep2018" author="thorsten.huck@hsbcad.com"> new family added: AH </version>
/// <version value="2.3" date="14sep2018" author="thorsten.huck@hsbcad.com"> bugfix supports special type overrides </version>
/// <version value="2.2" date="13sep2018" author="thorsten.huck@hsbcad.com"> take II, bugfix placement on icon&/opposite side in plan view </version>
/// <version value="2.1" date="13sep2018" author="thorsten.huck@hsbcad.com"> bugfix placement on icon&/opposite side in plan view </version>
/// <version value="2.0" date="13sep2018" author="thorsten.huck@hsbcad.com"> supports special type overrides based on the projectSpecial settings </version>
/// <version value="1.9" date="10sep2018" author="thorsten.huck@hsbcad.com"> icon side is default side of mounting sheet with alignment left/right </version>
/// <version value="1.8" date="04jul2018" author="thorsten.huck@hsbcad.com"> new property to specify the side of the mounting sheet </version>
/// <version value="1.7" date="12jun2018" author="thorsten.huck@hsbcad.com"> bugfix unit </version>
/// <version value="1.6" date="11jun2018" author="thorsten.huck@hsbcad.com"> bugfix alignment beam </version>
/// <version value="1.5" date="06jun2018" author="thorsten.huck@hsbcad.com"> bugfix </version>
/// <version value="1.4" date="06jun2018" author="thorsten.huck@hsbcad.com"> sheet based on first zone defined </version>
/// <version value="1.3" date="06jun2018" author="thorsten.huck@hsbcad.com"> creates blocking if in between studs and with mounting sheet, requires hsbCNC 6.8 or higher </version>
/// <version value="1.2" date="17apr2018" author="thorsten.huck@hsbcad.com"> translation issue fixed </version>
/// <version value="1.1" date="14mar2018" author="thorsten.huck@hsbcad.com"> bugfixes </version>
/// <version value="1.0" date="14mar2018" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select beam(s) and specify reference side, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates hold downs for walls
/// </summary>//endregion

// Commands
// command to create tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "Simpson StrongTie Anchor" "HTT")) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "Simpson StrongTie Anchor" "AH")) TSLCONTENT

// command to set orientations
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Reset + Erase|") (_TM "|Select Anchor|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Icon Side|") (_TM "|Select Anchor|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Opposite Side|") (_TM "|Select Anchor|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Left Side|") (_TM "|Select Anchor|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Right Side|") (_TM "|Select Anchor|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Flip Mounting Side|") (_TM "|Select Anchor|"))) TSLCONTENT

// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey "-> HTT" (_TM "|Select Anchor|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey "-> AH" (_TM "|Select Anchor|"))) TSLCONTENT


// constants //region
	U(1, "mm");
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));	
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
//endregion

//region read the families from the map or xml or create a default
	Map mapSetting;
	String sOpmName = "Simpson StrongTie Anchor";
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany + "\\TSL";
	String sFolder = "Settings";
	String sFileName = sOpmName;
// find settings file
	String sFolders[] = getFoldersInFolder(sPath);
	String sFullPath = sPath + "\\" + sFolder + "\\" + sFileName + ".xml";
	String sFile = findFile(sFullPath);
	// if no settings file could be found in company, try to find in installation folder
	if (sFile.length() < 1)sFile = findFile(_kPathHsbInstall + "\\Content\\General\\Tsl\\" + sFolder + "\\" + sFileName + ".xml");

	// read a potential mapObject
	MapObject mo(sDictionary ,sFileName);
	if (mo.bIsValid() )
	{
		mapSetting = mo.map();
		setDependencyOnDictObject(mo);
	}
	else if (!mo.bIsValid() && sFile.length()>0)
	{
		// create a mapObject to make the settings persistent	
	// read from xml
		mapSetting.readFromXmlFile(sFile);
		mo.dbCreate(mapSetting);// write into the database
	}
	else if ( ! mo.bIsValid() )//default settings
	{
		// create by default the family "HTT" and their families
		
		// "Model[]"
		Map mapModels;
		Map mapModel;
		mapModel.setMapKey("Model");
		mapModel.setString("Name", "HTT5");
		mapModel.setDouble("A", 404);
		mapModel.setDouble("B", 62);
		mapModel.setDouble("C", 64);
		mapModel.setDouble("t", 3);
		mapModel.setDouble("tB", 11.4);
		mapModel.setDouble("diamA", 4.7);
		mapModel.setInt("nDiamA", 26);
		mapModel.setDouble("zOffsetBase", 33);
		mapModel.setDouble("diamBase", 17.5);
		mapModel.setDouble("diamPlate", 20);
		mapModel.setInt("nDiamB", 1);
		mapModel.setDouble("dATriang", 165);
		
		mapModels.appendMap("Model", mapModel);
		// "Family[]"
		Map mapFamily;
		mapFamily.setMapKey("Family");
		mapFamily.setString("Name", "HTT");
		mapFamily.setString("URL_E", "http://www.strongtie.co.uk/products/detail/hold-down/81");
		mapFamily.setString("URL_G", "http://www.strongtie.de/products/detail/zuganker/81");
		mapFamily.setString("URL_F", "http://www.simpson.fr/products/detail/ancrage-pour-montant-d-039-ossature/81");
		
		
//		mapFamily.appendMap("Nail[]", mapNails);
		mapFamily.appendMap("Model[]", mapModels);
		
		Map MapFamily;
		MapFamily.setMapKey("Family[]");
		MapFamily.appendMap("Family", mapFamily);
		
		// "GeneralMapObject"
		Map mapGeneral;
		mapGeneral.setMapKey("GeneralMapObject");
		mapGeneral.setString("Identifier", "Simpson StrongTie Anchor");
		mapGeneral.setString("CustomFileName", "Simpson StrongTie Anchor");
		
		mapSetting.setMapKey("root");
//		mapSetting.appendMap("Milling", mapMilling);
		mapSetting.appendMap("Family[]", MapFamily);
		mapSetting.appendMap("GeneralMapObject", mapGeneral);
		
		// write in map into the database
		mo.dbCreate(mapSetting);
	}
	
	if (sFile.length() == 0 && mo.bIsValid())
	{ 
		// map exists and xml not available
		// Trigger ExportXml//region
		String sTriggerExportXml = T("|Export Xml|");
		addRecalcTrigger(_kContext, sTriggerExportXml );
		if (_bOnRecalc && (_kExecuteKey == sTriggerExportXml))
		{
		// if no existing map object and no xml was read, the default map can be exported to xml
			mapSetting.writeToXmlFile(sFullPath);
			setExecutionLoops(2);
			return;
		}//endregion
	}
	
	// validate
	if (mapSetting.length() < 1)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|wrong definition of the xml file 1001|"));
		eraseInstance();
		return;
	}
//End read the families from the map or xml or create a default//endregion 


//region get sFamilies from the mapSetting
	String sFamilies[0];
	{ 
		// get the models of this family and populate the property list
		Map mapFamilies = mapSetting.getMap("Family[]");
		for (int i = 0; i < mapFamilies.length(); i++)
		{
			Map mapFamilyI = mapFamilies.getMap(i);
			if (mapFamilyI.hasString("Name") && mapFamilies.keyAt(i).makeLower() == "family")
			{
				String sFamilyName = mapFamilyI.getString("Name");
				if (sFamilies.find(sFamilyName) < 0)
				{
					sFamilies.append(sFamilyName);
				}
			}
		}
	}
//End get sFamilies from the mapSetting//endregion 


	String sSpecials[] = {"BAUFRITZ"}; // declare a list of supported specials. specials might change behaviour and available properties
	int nSpecial = sSpecials.find(projectSpecial().makeUpper());	
	String sSolidOperations[] = {T("|no Operation|"), T("|no Operation|")+T(" |with Nonail area|"), T("|Solid Operation|"), T("|Solid Operation|")+T(" |with Nonail area|")};
	
	String sKeyCreateSheet = "CreateSheet";
	
// set hyperlink
	String sIsoCode = T("|IsoCode|");
	String sIsoCodes[] ={"BG","HR","CS","DA","NL",
		"EN", "ET", "FI", "FR", "DE",
		"EL", "HU", "IT", "JA", "KO",
		"LT", "NO", "PL", "PT", "RO",
		"RU", "SK", "SL", "ES", "SV", 
		"TR", "UK", "ZH-CHS"};
	int nIsoCode = sIsoCodes.find(sIsoCode);
	
// families
//	String sFamilies[] ={ "HTT", "AH", "HD"};
	
//region get sURLs
	String sURLs[0];
	{ 
		// get the models of this family and populate the property list
		Map mapFamilies = mapSetting.getMap("Family[]");
		for (int i = 0; i < mapFamilies.length(); i++)
		{
			Map mapFamilyI = mapFamilies.getMap(i);
			if (mapFamilyI.hasString("Name") && mapFamilies.keyAt(i).makeLower() == "family")
			{
				String sURLE = mapFamilyI.getString("URL_E");
				String sURLG = mapFamilyI.getString("URL_G");
				String sURLF = mapFamilyI.getString("URL_F");
				
				if (nIsoCode == 8)//french
				{
//					if (sURLs.find(sURLF) < 0)
					{
						sURLs.append(sURLF);
					}
				}
				else if (nIsoCode == 9)//german
				{
//					if (sURLs.find(sURLG) < 0)
					{
						sURLs.append(sURLG);
					}
				}
				else // english
				{
//					if (sURLs.find(sURLE) < 0)
					{
						sURLs.append(sURLE);
					}
				}
			}
		}
	}


//End get sURLs//endregion 	
	
	// HTT
//	if (nIsoCode==8)// french
//	{
//		sURLs.append("http://www.simpson.fr/products/detail/ancrage-pour-montant-d-039-ossature/81");// HTT
//		sURLs.append("http://www.simpson.fr/products/detail/ancrage-pour-montant-d-039-ossature/80");// AH
//		sURLs.append("https://www.strongtie.de/products/detail/zuganker/554");//HD
//	}
//	else if (nIsoCode==9)// german
//	{
//		sURLs.append("http://www.strongtie.de/products/detail/zuganker/81");
//		sURLs.append("http://www.strongtie.de/products/detail/zuganker/80");
//		// HD only available in german
//		sURLs.append("https://www.strongtie.de/products/detail/zuganker/554");
//	}
//	else	// english				
//	{
//		sURLs.append("http://www.strongtie.co.uk/products/detail/hold-down/81");
//		sURLs.append("http://www.strongtie.co.uk/products/detail/hold-down/80");
//		sURLs.append("https://www.strongtie.de/products/detail/zuganker/554");
//	}

// strongtie data


//region get parameters from the map and write into arrays
	


//End get parameters from the map and write into arrays//endregion 
	


	// HTT
//	String sModels0[] ={"HTT5", "HTT22"};
//	double dA0[] ={U(404), U(559)}; // height
//	double dB0[] ={U(62),U(62)}; // depth
//	double dC0[] ={U(64), U(64)};	// width
//	double dT0[] ={U(3),U(3)};
//	double dTB0[] ={U(11.4),U(11.4)};
//	double dDiamA0[] ={U(4.7),U(4.7)};
//	int nDiamA0[] ={ 26, 32};	
//	double dZOffsetBase0[] ={U(33),U(33)};
//	double dDiamBase0[] ={U(17.5),U(17.5)};
//	double dDiamPlate0[] ={U(20),U(20)};// plate drill diam
//	int nDiamB0[] ={1,1};	
//	double dATriang0[] = { U(165),U(165)};//triangle shape}
//	
//	// AH
//	String sModels1[] ={ "AH9035", "AH16050", "AH19050/2", "AH29050/2", "AH39050/2", 
//						"AH49050/2", "AH61050/2", "AH19050/4", "AH29050/4", "AH39050/4", 
//						"AH49050/4", "AH61050/4"};
//	double dA1[] ={U(90), U(160),U(192),U(292),U(390),	U(492),U(612),U(194),U(294),U(394)	,U(494),U(614)}; // height
//	double dB1[] ={U(52),U(52),U(52),U(52),U(52),	U(52),U(54),U(54),U(54),U(54)	,U(54),U(54)}; // depth
//	double dC1[] ={U(40),U(40),U(40),U(40),U(40),	U(40),U(40),U(40),U(40),U(40)	,U(40),U(40)};	// width
//	double dT1[] ={U(2.5),U(3),U(2),U(2),U(2),	U(2),U(2),U(4),U(4),U(4)	,U(4),U(4)};
//	double dTB1[0]; dTB1=dT1;
//	double dDiamA1[] ={U(5),U(5),U(5),U(5),U(5),	U(5),U(5),U(5),U(5),U(5)	,U(5),U(5)};
//	int nDiamA1[] ={ 6, 10,16,23,27,	36,45,12,18,27,  36,45};
//	double dZOffsetBase1[] ={U(33),U(33),U(33),U(33),U(33),	 U(33),U(0),U(0),U(0),U(0)	,U(0),U(0)};
//	double dDiamBase1[] ={U(0),U(0),U(0),U(0),U(0),	U(0),U(0),U(0),U(0),U(0)	,U(0),U(0)};
//	double dDiamPlate1[] ={U(5),U(5),U(13),U(13),U(13),	U(13),U(0),U(0),U(0),U(0)	,U(0),U(0)};// plate drill diam
//	int nDiamB1[] ={1,1,1,1,1,	1,1,1,1,1,	1,0};	
//	double dATriang1[] = { U(0),U(0),U(0),U(0),U(0),	U(0),U(0),U(0),U(0),U(0)	,U(0),U(0)};//triangle shape}
//	
//	// HD
//	String sModels2[] ={ "HD140M12G", "HD240M12G", "HD280M12G", "HD340M12G", 
//						"HD400M16G", "HD420M16G", "HD420M20G", "HD480M20G"};
//	double dA2[] ={ U(144), U(242), U(282), U(342),   U(403), U(422), U(422), U(483)};
//	double dB2[] ={ U(94), U(122), U(122), U(182),   U(123), U(222), U(102), U(123)};
//	double dC2[] ={ U(60), U(40), U(40), U(40),   U(40), U(60), U(60), U(60)};
//	// thickness leg A
//	double dT2[] ={ U(2), U(2), U(2), U(2),    U(2), U(2), U(2), U(2.5)};
//	// thickness leg B
//	double dTB2[0]; dTB2 = dT2;// thickness of other leg
//	// diameter leg A
//	double dDiamA2[] ={ U(5), U(5), U(5), U(5),   U(5), U(5), U(5), U(5)};
//	int nDiamA2[] ={ 17, 11, 11, 24,    29, 50, 50, 57};
//	double dZOffsetBase2[] ={ U(0), U(0), U(0), U(0),    U(0), U(0), U(0), U(0)};
//	double dDiamBase2[] ={ U(0), U(0), U(0), U(0),    U(0), U(0), U(0), U(0)};
//	double dDiamPlate2[] ={ U(14), U(14), U(14), U(14),   U(18), U(18), U(22), U(22)};
//	int nDiamB2[] ={ 1, 1, 1, 1,    1, 1, 1, 1};
//	double dATriang2[] = { U(0), U(0), U(0), U(0),    U(0), U(0), U(0), U(0)};
	
// special 1: clone models of HTT family and rename 
	if (nSpecial==0)
	{ 
	// duplictae entries
		for (int i=0;i<2;i++) 
		{ 
//			dA0.append(dA0[i]);
//			dB0.append(dB0[i]);
//			dC0.append(dC0[i]);
//			dT0.append(dT0[i]);
//			dTB0.append(dTB0[i]);
//			dDiamA0.append(dDiamA0[i]);
//			dATriang0.append(dATriang0[i]);
//			nDiamA0.append(nDiamA0[i]);
//			
//			dZOffsetBase0.append(dZOffsetBase0[i]);
//			dDiamBase0.append(dDiamBase0[i]);
//			dDiamPlate0.append(dDiamPlate0[i]);
//			nDiamB0.append(nDiamB0[i]);
//			dATriang0.append(dATriang0[i]);
		}//next i
		
		String sTmps[]={"HTT5 Holz (Gefach)", "HTT22 Holz (Gefach)","HTT5 Beton (Gefach)", "HTT22 Beton (Gefach)"};
//		sModels0 = sTmps;
	}


	// current family
	String sModels[0];
	double dAs[0];
	double dBs[0];
	double dCs[0];
	double dTs[0];
	double dTBs[0];
	double dDiamAs[0];
	int nDiamAs[0];
	double dZOffsetBases[0];
	double dDiamBases[0];
	double dDiamPlates[0];
	int nDiamBs[0];
	double dATriangs[0];
	
	//region Properties
				
// Model and Family
	category = T("|Model|");
	String sFamilyName=T("|Family|");
	PropString sFamily(nStringIndex++, sFamilies, sFamilyName);	
	sFamily.setDescription(T("|Defines the Family|"));
	sFamily.setCategory(category);
	sFamily.setReadOnly(true);// as long as there is only one model
	
	String sModelName=T("|Model|");
	String sModelDesc = T("|Defines the model|");
	PropString sModel(nStringIndex++, sModels, sModelName);	
	sModel.setDescription(sModelDesc);
	sModel.setCategory(category);

// alignment
	category = T("|Alignment|");
	
	String sZOffsetName=T("|Axis Offset|");	
	PropDouble dZOffset(nDoubleIndex++, U(0), sZOffsetName);	
	dZOffset.setDescription(T("|Defines the Z-Offset to the base location|"));
	dZOffset.setCategory(category);

	String sInterdistanceName = T("|Inter Distance|");
	PropDouble dInterdistance(nDoubleIndex++, 0, sInterdistanceName );
	dInterdistance.setDescription(T("|Creates two anchors if the value is greater than the anchor width.|"));
	dInterdistance.setCategory(category);
	
// tooling
	category = T("|Tooling|");	
	
	String sDepthName = T("|Depth|");
	PropDouble dDepth(nDoubleIndex++, 0, sDepthName );		
	dDepth.setDescription(T("|Specifies the milling depth|"));
	dDepth.setCategory(category);	
		
	String sGapName = T("|Gap|");
	PropDouble dGap(nDoubleIndex++, 0, sGapName );		
	dGap.setDescription(T("|Specifies the gap of the milling in length and width|"));
	dGap.setCategory(category);
	
	// HSB-14511 
	String sToolingIndexName=T("|Tooling Index|");	
	PropString sToolingIndex(4, "", sToolingIndexName);	
	sToolingIndex.setDescription(T("|Defines the ToolIndex for each zone.|")+
	T(" |Separate multiple entries by a semicolon.| (';')"));
	sToolingIndex.setCategory(category);
	
	String sToolingZoneName=T("|Tooling Type|");	
	PropString sToolingZone(5, "Saw", sToolingZoneName);	
	sToolingZone.setDescription(T("|Defines the Tooling for each zone|")+
	T(" |Separate multiple entries by a semicolon.| (';')")+
	T(" |Possible tools are Saw, Milling, SawNoNail, MillingNoNail.| (';')")+
	T(" |Tools can be defined by their respective index 1=Saw,2=Mill,3=SawNoNail,4=MillNoNail.| (';')"));
	sToolingZone.setCategory(category);
	
	String sToolingWidthName=T("|Tooling Width|");	
	PropString sToolingWidth(6, "", sToolingWidthName);	
	sToolingWidth.setDescription(T("|Defines the extra Tooling Width.|")+
	T(" |Separate multiple entries by a semicolon.| (';')"));
	sToolingWidth.setCategory(category);
	
	String sToolingHeightName=T("|Tooling Height|");	
	PropString sToolingHeight(7, "", sToolingHeightName);	
	sToolingHeight.setDescription(T("|Defines the extra Tooling Height.|")+
	T(" |Separate multiple entries by a semicolon.| (';')"));
	sToolingHeight.setCategory(category);
	
// mounting sheet
	category = T("|Mounting Sheet|");
	String sHeightSheetName=T("|Height|");	
	PropDouble dHeightSheet(nDoubleIndex++, U(625), sHeightSheetName);	
	dHeightSheet.setDescription(T("|Defines the height of optional mounting sheets.|"));
	dHeightSheet.setCategory(category);
	
	String sCoverageName=T("|Coverage|");	;	
	PropString sCoverage(nStringIndex++, "", sCoverageName);	
	sCoverage.setDescription(T("|Defines the coverage of optional mounting sheets.|") + T(" |Separate multiple entries by a semicolon.| (';')") + T("|The list is counted from inside to outside, skip zones by typing a zero.|"));
	sCoverage.setCategory(category);
	
	String sFaceName=T("|Face|");	
	String sFaces[] = { T("|Icon Side|"), T("|Opposite Side|")};
	PropString sFace(nStringIndex++, sFaces, sFaceName);	
	sFace.setDescription(T("|Defines the side of the mounting sheet if the fastener is attached to the inside of the element (option left/right).|"));
	sFace.setCategory(category);
	
	// HSB-24881: catalog for cnc
	String cncTslName = "hsbCNC";
	String sCncCatalogs[] = TslInst().getListOfCatalogNames(cncTslName);
	sCncCatalogs.insertAt(0,"");
	
	String sCncCatalogName="CNC "+T("|Catalog|");	
	PropString sCncCatalog(8, sCncCatalogs, sCncCatalogName);	
	sCncCatalog.setDescription(T("|Defines the catalog for the hsbCNC catalog. This catalog will be applied to every zone where the tsl will be created|"));
	sCncCatalog.setCategory(category);
	
	//End Properties//endregion
	
	//region OnInsert
// bOnInsert
	if(_bOnInsert)
	{
		int bDebugInsert;//= true;
		if (insertCycleCount()>1) { eraseInstance(); return; }
		
	// Specify dialogs //region
	// Get opm name by tokenized convention i.e. <FamilyName>?<CatalogEntry>
		String sTokens[] = _kExecuteKey.tokenize("?");
		String sOpmKey = sTokens.length() > 0 ? sTokens[0] : "";
		if (bDebugInsert)reportNotice("\n" + scriptName() + ": " +sOpmKey + " tokens:" + sTokens);
		
	// validate potential opmKey -> it should be one of the family names
		if (sOpmKey.length()>1)
		{ 
			String s1 = sOpmKey;
			s1.makeUpper();
			int bOk;
			for (int i = 0; i < sFamilies.length(); i++)
			{
				String s2 = sFamilies[i];
				s2.makeUpper();
				if (s1 == s2)
				{
					bOk = true;
					sFamily.set(T(sFamilies[i]));
					setOPMKey(sFamilies[i]);
					sFamily.setReadOnly(true);
					break;
				}	 
			}//next i
		// the opmKey does not match any family name -> reset
			if (!bOk)
			{
				reportNotice("\n" + scriptName() + ": " +T("|NOTE, the specified OPM key| '") +sOpmKey+T("' |cannot be found in the list of families.|"));
				sOpmKey = "";
			}
		}		
		
	// try to get entries of the family	
		int bShowModelDialog, bWriteDefaultCatalogs;
		if (sOpmKey.length()>1 && sTokens.length()>1)
		{
			String sOpmName = scriptName() + "-" + sOpmKey;

			String sEntry = sTokens[1];
			sEntry.makeUpper();
			String sEntries[] = TslInst().getListOfCatalogNames(sOpmName);
			if (bDebugInsert)reportNotice("\ntry to get entries of the family opmName = "+sOpmName+ "\nentries " + sEntries);
			for(int i=0;i<sEntries.length();i++)
				sEntries[i] = sEntries[i].makeUpper();	
		// silent: entry found	
			if (sEntries.find(sEntry)>-1)
			{
				setPropValuesFromCatalog(sTokens[1]);
				if (bDebugInsert)reportNotice("\n silent entry" + sTokens[1]);
			}
		// entry not found, show dialog with preset family
			else
				bShowModelDialog=true;
		}
	// family found as opmKey, but no catalog entry found, show dialog with preset family
		else if (sOpmKey.length()>1)
		{ 
			if (bDebugInsert)reportNotice("\n family found but no child" + sFamily + " " +sTokens);
			bShowModelDialog = true;
			bWriteDefaultCatalogs = true;
		}
	// no family and no catalog entry found, show 2 step dialogs
		else
		{
			sFamily.set(sFamilies[0]);
			sFamily.setReadOnly(false);
			
			reportMessage("\n" + scriptName() + ": " +T("|should be fired from ribbon or palette for more convenient insertion.|"));
			
			
			if (bDebugInsert)reportNotice("\n no family and no child" + sFamily + " " +sTokens);
			sModel.set("---");
			sModel.setReadOnly(true);
			// show dialog to choose family
			showDialog("---");	
			setOPMKey(sFamily);			
			bShowModelDialog = true;
			bWriteDefaultCatalogs = true;
		}		
		
	// get family
		int nFamily = sFamilies.find(sFamily, 0);

	// show model dialog	

		if (bShowModelDialog)
		{ 
		// get properties of selected Family	
			nFamily = sFamilies.find(sFamily,0);
			if (nFamily < 0)
			{
				reportMessage("\n" + scriptName() + ": " +T("|Invalid definition|"));
				eraseInstance();
			}
		// valid family	
			else 
			{
				// get all sModels of the choosen family
				Map mapFamilies = mapSetting.getMap("Family[]");
				for (int i = 0; i < mapFamilies.length(); i++)
				{
					Map mapFamilyI = mapFamilies.getMap(i);
					if (mapFamilyI.hasString("Name") && mapFamilies.keyAt(i).makeLower() == "family")
					{
						String sFamilyName = mapFamilyI.getString("Name");
						if (sFamilyName == sFamily)
						{ 
							// validation
							if (i != nFamily)
							{ 
								reportMessage("\n" + scriptName() + ": " +T("|unexpected error|"));
								eraseInstance();
								return;
							}
							
							
							// get all models for this family
							Map mapModels = mapFamilyI.getMap("Model[]");
							if (mapModels.length() < 1)
							{
								// wrong definition of the map
								reportMessage("\n" + scriptName() + ": " +T("|no model definition for this family|"));
								eraseInstance();
								return;
							}
							// choosen family found
							for (int j = 0; j < mapModels.length(); j++)
							{
								Map mapModelJ = mapModels.getMap(j);
								if (mapModelJ.hasString("Name") && mapModels.keyAt(j).makeLower() == "model")
								{
									String sName = mapModelJ.getString("Name");
									if (sModels.find(sName) < 0)
									{
										// populate sModels
										sModels.append(sName);
									}
								}
							}
							// models of choosen family found, break;
							break;
						}
					}
				}
				
//			// HTT
//				if (nFamily==0)
//				{ 
//					dAs = dA0;		dBs = dB0;		dCs = dC0;		dTs = dT0;		dTBs = dTB0;
//					dDiamAs = dDiamA0;					nDiamAs = nDiamA0;
//					dZOffsetBases = dZOffsetBase0;		dDiamBases = dDiamBase0;
//					dDiamPlates = dDiamPlate0;			nDiamBs = nDiamB0;
//					dATriangs = dATriang0;
//					sModels = sModels0;
//				}
//			// AH
//				if (nFamily==1)
//				{ 
//					dAs = dA1;		dBs = dB1;		dCs = dC1;		dTs = dT1;		dTBs = dTB1;
//					dDiamAs = dDiamA1;					nDiamAs = nDiamA1;
//					dZOffsetBases = dZOffsetBase1;		dDiamBases = dDiamBase1;
//					dDiamPlates = dDiamPlate1;			nDiamBs = nDiamB1;
//					dATriangs = dATriang1;
//					sModels = sModels1;
//				}
//			// HD
//				if (nFamily==2)
//				{ 
//					dAs = dA2;		dBs = dB2;		dCs = dC2;		dTs = dT2;		dTBs = dTB2;
//					dDiamAs = dDiamA2;					nDiamAs = nDiamA2;
//					dZOffsetBases = dZOffsetBase2;		dDiamBases = dDiamBase2;
//					dDiamPlates = dDiamPlate2;			nDiamBs = nDiamB2;
//					dATriangs = dATriang2;
//					sModels = sModels2;
//				}
				
				// property sModels
				sModel = PropString (1, sModels, sModelName, 0);
				
			// un-lock properties	
				sModel.setReadOnly(false);
				sFamily.setReadOnly(true);
				showDialog();
			}	
		}//endregion

	// write default catalogs
		if (bWriteDefaultCatalogs)
		{ 
		// buffer current values
			String sCurrentFamily = sFamily;
			String sCurrentModel = sModel;
			
		// writing default catalog entries
			String sNotices[0];
			
			for (int f=0;f<sFamilies.length();f++) 
			{ 
				sFamily.set(sFamilies[f]);
				setOPMKey(sFamily);
				String sOpmName = scriptName()+"-"+sFamily;
				String sEntries[] = TslInst().getListOfCatalogNames(sOpmName);
				
				String sEntriesNotice = T("	|Family| ") + sFamily + T(" |has the following entries|: " + sEntries);
				
			// create default entries of selected family
				for (int i=0;i<sModels.length();i++) 
				{ 
					String _sModel = sModels[i];
					
				// create new entry
					if (sEntries.find(_sModel)<0)
					{ 
						//sModelNotice =T("		") + _sModel +T(" |entry created|");
						sModel.set(_sModel);
						setCatalogFromPropValues(_sModel);								
					} 
				}
			}//next i
			
			sFamily.set(sCurrentFamily);
			setOPMKey(sFamily);
			sModel.set(sCurrentModel);
		}

		int nModel = sModels.find(sModel);
		if (nModel<0 && sModels.length()>0){nModel=0;sModel.set(sModels[nModel]);}
//
//		if (sKey.length()>0)
//		{
//			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
//			for(int i=0;i<sEntries.length();i++)
//				sEntries[i] = sEntries[i].makeUpper();	
//			if (sEntries.find(sKey)>-1)
//				setPropValuesFromCatalog(sKey);
//			else
//				setPropValuesFromCatalog(sLastInserted);					
//		}	
//		else	
//			showDialog();
		
	// prompt for beams
		Beam beams[0];
		PrEntity ssB(T("|Select beam(s)|"), Beam());
	  	if (ssB.go())
			beams.append(ssB.beamSet());
		
		int nSide=1; // 1 = icon, -2=left, -1=opposite, 2=right
		if (beams.length()>0)
		{ 
			Beam& bm = beams[0];
			Point3d ptCen = bm.ptCenSolid();
			Element el = bm.element();

			if (el.bIsValid())
			{ 
				Vector3d vecX = el.vecX();
				Vector3d vecY = el.vecY();
				Vector3d vecZ = el.vecZ();
				Point3d ptOrg = el.ptOrg();
				if(_ZU.isParallelTo(vecZ))
				{ 
					
					String s = getString(T("|Select side| [") +T("|Iconside|/")+T("|Left|/")+T("|Opposite Side|/")+T("|Right|")+"]").makeUpper();
					String sValues[] = {T("|Iconside|").left(1).makeUpper(), T("|Left|").left(1).makeUpper(),T("|Opposite Side|").left(1).makeUpper(),T("|Right|").left(1).makeUpper() };
					int n = sValues.find(s);
					if (n <= 0) nSide=1;
					else if (n == 1) nSide=-2;
					else if (n == 2) nSide=-1;
					else if (n == 3) nSide=2;
				}
				else
				{ 
					PlaneProfile pp = bm.envelopeBody().shadowProfile(Plane(ptCen, vecY));
					Point3d pt = pp.closestPointTo(getPoint(T("|Pick side|")));

					double dX = vecX.dotProduct(pt-ptCen);
					double dZ = vecZ.dotProduct(pt-ptCen);
			
					double dXBm = bm.dD(vecX);
					double dZBm = bm.dD(vecZ);

					if(abs(abs(dZ) - .5 * dZBm)<dEps)
						nSide = dZ < 0 ?- 1 : 1;
					else if(abs(abs(dX) - .5 * dXBm)<dEps)
						nSide = dX < 0 ?- 2 : 2;	
				}
			}
		}

		for (int i=0;i<beams.length();i++) 
		{ 
			Beam& bm= beams[i]; 
			if (!bm.bIsValid())continue;
			Point3d ptCen = bm.ptCenSolid();
			Point3d ptIns = ptCen;
			
		// prepare tsl cloning
			TslInst tslNew;
			Vector3d vecXTsl= _XE; Vector3d vecYTsl= _YE;
			GenBeam gbsTsl[] = {bm}; Entity entsTsl[] = {}; Point3d ptsTsl[] = {};
			int nProps[]={};				
			double dProps[]={dZOffset, dInterdistance, dDepth, dGap,dHeightSheet};	
			String sProps[]={sFamily, sModel,sCoverage,sFace, sToolingIndex,
				sToolingZone,sToolingWidth,sToolingHeight,sCncCatalog};
			Map mapTsl;	
			String sScriptname = scriptName();		
			
		// element
			Vector3d vecX, vecY, vecZ;
			Element el = bm.element();
			if (el.bIsValid())
			{ 
				vecX = el.vecX();
				vecY = el.vecY();
				vecZ = el.vecZ();
				if (abs(nSide)==1)
					ptIns = ptCen + vecZ * nSide * .5 * bm.dD(vecZ);
				else
					ptIns = ptCen + vecX * nSide/abs(nSide) * .5 * bm.dD(vecX);
				entsTsl.append(el);
			}
			
			ptsTsl.append(ptIns);
			
			tslNew.dbCreate(sScriptname , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
				nProps, dProps, sProps, _kModelSpace, mapTsl);
		}
		
		eraseInstance();
		return;
	}
// end on insert	____________________________________________________________________________________________________________
	//endregion OnInsert

// get family
	int nFamily = sFamilies.find(sFamily, 0);


//region get sModels of the choosen family
	Map mapFamilies = mapSetting.getMap("Family[]");
	Map mapFamilyChoosen;
	sModels.setLength(0);
	for (int i = 0; i < mapFamilies.length(); i++)
	{
		Map mapFamilyI = mapFamilies.getMap(i);
		if (mapFamilyI.hasString("Name") && mapFamilies.keyAt(i).makeLower() == "family")
		{
			String sFamilyName = mapFamilyI.getString("Name");
			if (sFamilyName == sFamily)
			{ 
				// validation
				if (i != nFamily)
				{ 
					reportMessage("\n" + scriptName() + ": " +T("|unexpected error|"));
					eraseInstance();
					return;
				}
				
				// get all models for this family
				Map mapModels = mapFamilyI.getMap("Model[]");
				if (mapModels.length() < 1)
				{
					// wrong definition of the map
					reportMessage("\n" + scriptName() + ": " +T("|no model definition for this family|"));
					eraseInstance();
					return;
				}
				// choosen family found
				for (int j = 0; j < mapModels.length(); j++)
				{
					Map mapModelJ = mapModels.getMap(j);
					if (mapModelJ.hasString("Name") && mapModels.keyAt(j).makeLower() == "model")
					{
						String sName = mapModelJ.getString("Name");
						if (sModels.find(sName) < 0)
						{
							// populate sModels
							sModels.append(sName);
						}
					}
				}
				// models of choosen family found, break;
				mapFamilyChoosen = mapFamilyI;
				break;
			}
		}
	}
//End get sModels of the choosen family//endregion 

// assign model data and opm key
//// HTT
//	if (nFamily == 0)
//	{ 
//		dAs = dA0;	dBs = dB0;	dCs = dC0;	dTs = dT0;	dTBs = dTB0;
//		dDiamAs = dDiamA0;					nDiamAs = nDiamA0;
//		dZOffsetBases = dZOffsetBase0;		dDiamBases = dDiamBase0;
//		dDiamPlates = dDiamPlate0;			nDiamBs = nDiamB0;
//		dATriangs = dATriang0;
//		sModels = sModels0;
//	}
//// AH
//	else if (nFamily == 1)
//	{ 
//		dAs = dA1;	dBs = dB1;	dCs = dC1;	dTs = dT1;	dTBs = dTB1;
//		dDiamAs = dDiamA1;					nDiamAs = nDiamA1;
//		dZOffsetBases = dZOffsetBase1;		dDiamBases = dDiamBase1;
//		dDiamPlates = dDiamPlate1;			nDiamBs = nDiamB1;
//		dATriangs = dATriang1;
//		sModels = sModels1;
//	}
//// HD
//	else if (nFamily == 2)
//	{ 
//		dAs = dA2;	dBs = dB2;	dCs = dC2;	dTs = dT2;	dTBs = dTB2;
//		dDiamAs = dDiamA2;					nDiamAs = nDiamA2;
//		dZOffsetBases = dZOffsetBase2;		dDiamBases = dDiamBase2;
//		dDiamPlates = dDiamPlate2;			nDiamBs = nDiamB2;
//		dATriangs = dATriang2;
//		sModels = sModels2;
//	}
	setOPMKey(sFamily);
	
	sModel = PropString (1, sModels, sModelName, 0);
	
// validate beam reference
	if (_Beam.length()<1)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|requieres at least one beam|"));
		if (!bDebug)eraseInstance();
		return;
	}

// set instance color on creation
	if (_bOnDbCreated)
	{
		int c = 253;
		if(nSpecial==0) c=5;
		_ThisInst.setColor(c);
	}

// model data
	int nModel = sModels.find(sModel);
	if (nModel < 0 && sModels.length() > 0)
	{
		nModel = 0;
		sModel.set(sModels[nModel]);
	}
	
	// HSB-24881: add event on deleted
	addRecalcTrigger(_kErase, TRUE);
	
	if(_bOnDbErase)
	{ 
		// HSB-24881: cleanup tsls
		for (int z = 0; z < 5; z++)
		{
			//
			String sKey = "Cnc" + z;
			if (_Map.hasEntity(sKey))
			{
				Entity EntI = _Map.getEntity(sKey);
				EntI.dbErase();
			}
			sKey = "CncMain" + z;
			if (_Map.hasEntity(sKey))
			{
				Entity EntI = _Map.getEntity(sKey);
				EntI.dbErase();
			}
		}
		
		if(_Map.hasEntity("Blocking"))
		{ 
			Entity Ent = _Map.getEntity("Blocking");
			Ent.dbErase();
		}
	}
//region get parameters of the choosen model
	double dA;
	double dB;
	double dC;
	double dT;
	double dTB;
	double dDiamA;
	double dZOffsetBase;
	double dDiamBase;
	int nDiamA;
	int nDiamB;
	double dDiamPlate;
	double dATriang;
	String sURL;
	
	sURL = sURLs[nFamily];
	
	Map mapModels = mapFamilyChoosen.getMap("Model[]");
	if (mapModels.length() < 1)
	{
		// wrong definition of the map
		reportMessage("\n" + scriptName() + ": " +T("|no model defined for this family|"));
		eraseInstance();
		return;
	}
	for (int i = 0; i < mapModels.length(); i++)
	{
		Map mapModelI = mapModels.getMap(i);
		if (mapModelI.hasString("Name") && mapModels.keyAt(i).makeLower() == "model")
		{
			String sName = mapModelI.getString("Name");
			if (sName == sModel)
			{
				// take the properties from this model
				String k;
				Map m = mapModelI;
				
				k = "A"; if (m.hasDouble(k)) dA = m.getDouble(k);
				k = "B"; if (m.hasDouble(k)) dB = m.getDouble(k);
				k = "C"; if (m.hasDouble(k)) dC = m.getDouble(k);
				k = "t"; if (m.hasDouble(k)) dT = m.getDouble(k);
				k = "tB"; if (m.hasDouble(k)) dTB = m.getDouble(k);
				k = "diamA"; if (m.hasDouble(k)) dDiamA = m.getDouble(k);
				k = "nDiamA"; if (m.hasInt(k)) nDiamA = m.getInt(k);
				k = "zOffsetBase"; if (m.hasDouble(k)) dZOffsetBase = m.getDouble(k);
				k = "diamBase"; if (m.hasDouble(k)) dDiamBase = m.getDouble(k);
				k = "diamPlate"; if (m.hasDouble(k)) dDiamPlate = m.getDouble(k);
				k = "nDiamB"; if (m.hasInt(k)) nDiamB = m.getInt(k);
				k = "dATriang"; if (m.hasDouble(k)) dATriang = m.getDouble(k);
			}
		}
	}


//End get parameters of the choosen model//endregion 
	
	
//	double dA=dAs[nModel];
//	double dB=dBs[nModel];
//	double dC=dCs[nModel];
//	double dT=dTs[nModel];
//	double dTB=dTBs[nModel];
//	double dDiamA=dDiamAs[nModel];
//	double dZOffsetBase = dZOffsetBases[nModel];
//	double dDiamBase=dDiamBases[nModel];
//	int nDiamA=nDiamAs[nModel];
//	int nDiamB=nDiamAs[nModel];
//	double dDiamPlate=dDiamPlates[nModel];
//	double dATriang = dATriangs[nModel];
//	String sURL = sURLs[nFamily];
	
	
	if (sURL.find(".",0)>0)_ThisInst.setHyperlink(sURL);
	setOPMKey(sFamily);
	
	
// validate interdistance
	if (dInterdistance>0 && dInterdistance<dB)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|the interdistance must be greater than the anchor width.|"));
		dInterdistance.set(0);
		setExecutionLoops(2);
		return;
	}

	int nColor = _ThisInst.color();	


// the beam
	Beam bmDef = _Beam[0];
	Body bdEnv = bmDef.envelopeBody();
	Point3d ptCen = bmDef.ptCenSolid();
	Beam beams[0];
	
// potential element ref
	Element el;
	CoordSys cs;
	Vector3d vecX, vecY, vecZ;
	Point3d ptOrg;
	LineSeg segMinMax;
	if (_Element.length()>0)
	{
		el=_Element[0];
		cs = el.coordSys();
		vecX = cs.vecX();
		vecY = cs.vecY();
		vecZ = cs.vecZ();
		ptOrg = cs.ptOrg();
		beams = el.beam();
		segMinMax = el.segmentMinMax();
		assignToElementGroup(el, true,0,'E');
	}
	else
	{
		el = bmDef.element();
		if (el.bIsValid())
		{
			_Element.append(el);
			setExecutionLoops(2);
			return;
		}
	}
	
// set coordSys dependent from beam ref
	if (!el.bIsValid())
	{ 
		assignToGroups(bmDef, 'I');
		vecX =bmDef.vecY();
		vecY =bmDef.vecX();
		vecZ =-bmDef.vecZ();
		if (vecY.isParallelTo(_ZW) && !vecY.isCodirectionalTo(_ZW))
		{
			vecY *= -1;
			vecX *= -1;
		}
		ptOrg = bmDef.ptCenSolid() - vecY * .5 * bmDef.solidLength();
		cs = CoordSys(ptOrg, vecX, vecY, vecZ);	
	}

	
	vecX.vis(ptOrg, 1);
	vecY.vis(ptOrg, 3);
	vecZ.vis(ptOrg, 150);

// get alignment based on insertion point
	Vector3d vecDir = vecZ;
	{ 
		PlaneProfile pp = bdEnv.shadowProfile(Plane(ptCen, vecY));
		Point3d pt = pp.closestPointTo(_Pt0);
		double dX = vecX.dotProduct(pt-ptCen)*2;
		double dZ = vecZ.dotProduct(pt-ptCen)*2;

	// left or right, only for vertical beams	
		if(abs(abs(dZ)-bmDef.dD(vecZ))<dEps)
			vecDir = (dZ<0?-1 : 1)*vecZ;
		else
			vecDir = (dX<0?-1 : 1)*vecX;	
		_Pt0.transformBy(vecDir*vecDir.dotProduct(pt-_Pt0));	
	}
	vecDir.vis(_Pt0, 2);
	
	Vector3d vecYC = vecY;
	Vector3d vecZC = vecDir;
	Vector3d vecXC = vecDir.crossProduct(-vecY);

// validate interdistance in relation to the vecXC beam dimension
	double dXCBm = bdEnv.lengthInDirection(vecXC);
	if (dInterdistance>0 && dXCBm<dInterdistance+2*dB)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|cannot place 2 anchors on this face|"));
		dInterdistance.set(0);
		setExecutionLoops(2);	
	}

// limit location in relation to total width of installation
	double dXTotal = dC + dInterdistance;
	if (dXCBm<=dXTotal)
		_Pt0.transformBy(vecXC * vecXC.dotProduct(ptCen - _Pt0));
	else
	{ 
		double d1 = vecXC.dotProduct(_Pt0 - ptCen);
		double d2= (abs(d1) + .5 * dXTotal)-.5*dXCBm;
		if (d2>dEps)
		{ 
			_Pt0.transformBy(-d1/abs(d1)*vecXC * d2);
		}
	}


// flags
	int nFace = sFaces.find(sFace, 0);
	if (nFace<0)
	{ 
		sFace.set(sFaces[0]);
		setExecutionLoops(2);
		return;
	}
	int bLeftRight = vecDir.isParallelTo(vecX);// flag if left or right
	int bCreateSheet = _Map.getInt(sKeyCreateSheet) || _bOnDbCreated;// flag to erase and create mounting sheets
	int bCreateBlocking = bLeftRight && (_Map.getInt("CreateBlocking") || _bOnDbCreated);// flag to erase and create mounting sheets
	int bResetErase;

// trigger to reset and erase
	if (_Sheet.length()>1)
	{ 
		String sTriggerFlipSide = T("|Reset + Erase|");
		addRecalcTrigger(_kContext, sTriggerFlipSide );
		if (_bOnRecalc && _kExecuteKey==sTriggerFlipSide)
			bResetErase=true;		
	}

// fire creation if 
	// - the cooverage settings have changed
	// - the height of the mounting sheet has changed
	// - the dragging of _Pt0 has lead to a direction change
	if(_kNameLastChangedProp==sCoverageName ||_kNameLastChangedProp==sHeightSheetName ||
		(_kNameLastChangedProp=="_Pt0" && _Map.hasVector3d("vecDir") && !_Map.getVector3d("vecDir").isCodirectionalTo(vecDir)))
	{
		bCreateSheet = true;
		bCreateBlocking = bLeftRight;
		
		_Map.setInt(sKeyCreateSheet,bCreateSheet);
		_Map.setInt("CreateBlocking",bCreateBlocking);
	}
	
// toggle face by property
	int bFlipMounting, bSetLocation;
	if (_kNameLastChangedProp==sFaceName)
	{ 
		bFlipMounting = nFace == 0;
		_Map.setInt("flipMounting", bFlipMounting);
		_Map.setInt(sKeyCreateSheet,true);
		_Map.setInt("CreateBlocking",true);
		setExecutionLoops(2);
		return;		
	}
	
	
// TriggerFlipSide in leftRight Mode	
	if (bLeftRight)
	{
		bFlipMounting = _Map.getInt("flipMounting");
		String sTriggerFlipSide = T("|Flip Mounting Side|");
		addRecalcTrigger(_kContext, sTriggerFlipSide );
		if (_bOnRecalc && _kExecuteKey==sTriggerFlipSide)
		{
			if (bFlipMounting)bFlipMounting=false;
			else bFlipMounting=true;
			 _Map.setInt(sKeyCreateSheet,true);
			 _Map.setInt("CreateBlocking",true);
			 _Map.setInt("flipMounting",bFlipMounting);
			 
			sFace.set(bFlipMounting ? sFaces[0] : sFaces[1]);
			setExecutionLoops(2);
			return;
		}
		

		String sTriggerOtherSide = vecDir.isCodirectionalTo(vecX)?T("|Left Side|"):T("|Right Side|");
		addRecalcTrigger(_kContext, sTriggerOtherSide );
		if (_bOnRecalc && (_kExecuteKey==sTriggerOtherSide|| _kExecuteKey==sDoubleClick))
		{
			_Pt0 = ptCen - vecDir * .5 * bmDef.dD(vecX);
			bSetLocation = true;
		}
		String sTriggerIconSide = T("|Icon Side|");
		addRecalcTrigger(_kContext, sTriggerIconSide );
		if (_bOnRecalc && _kExecuteKey==sTriggerIconSide)
		{
			_Pt0 = ptCen + vecZ * .5 * bmDef.dD(vecZ);
			bSetLocation = true;
		}
		String sTriggerOppSide = T("|Opposite Side|");
		addRecalcTrigger(_kContext, sTriggerOppSide );			
		if (_bOnRecalc && _kExecuteKey==sTriggerOppSide)
		{
			_Pt0 = ptCen - vecZ* .5 * bmDef.dD(vecZ);
			bSetLocation = true;
		}

		if(bSetLocation)
		{ 
			_Map.setInt(sKeyCreateSheet,true);
			_Map.setInt("CreateBlocking",true);
			_Map.setInt("setLocation", true);	
			setExecutionLoops(2);
			return;
		}		
	}
// icon/opposite icon side
	else
	{ 
//		dZOffset.setReadOnly(true);
//		dInterdistance.setReadOnly(true);
		
	// set mounting sheet face to read only
		sFace.setReadOnly(true);
		sFace.set(vecDir.isCodirectionalTo(vecZ)?sFaces[0]:sFaces[1]);
		
		
		String sTriggerOtherSide = vecDir.isCodirectionalTo(vecZ)?sFaces[1]:sFaces[0];
		addRecalcTrigger(_kContext, sTriggerOtherSide );
		if (_bOnRecalc && (_kExecuteKey==sTriggerOtherSide|| _kExecuteKey==sDoubleClick))
		{
			_Pt0 = ptCen - vecDir * .5 * bmDef.dD(vecZ);
			bSetLocation = true;
//			bCreateBlocking = false;
		}		
		String sTriggerLeftSide = T("|Left Side|");
		addRecalcTrigger(_kContext, sTriggerLeftSide );
		if (_bOnRecalc && _kExecuteKey==sTriggerLeftSide)
		{
			_Pt0 = ptCen - vecX * .5 * bmDef.dD(vecX);
			bSetLocation = true;
			_Map.setInt("CreateBlocking",true);
		}
		String sTriggerRightSide = T("|Right Side|");
		addRecalcTrigger(_kContext, sTriggerRightSide );
		if (_bOnRecalc && _kExecuteKey==sTriggerRightSide)
		{
			_Pt0 = ptCen + vecX * .5 * bmDef.dD(vecX);
			bSetLocation = true;
			_Map.setInt("CreateBlocking",true);
		}
		if(bSetLocation)
		{ 
			_Map.setInt(sKeyCreateSheet,true);		
			_Map.setInt("setLocation", true);
			setExecutionLoops(2);
			return;
		}
	}
	bSetLocation = _Map.getInt("setLocation");

// Trigger ChangeFamily//region
	for (int i=0;i<sFamilies.length();i++) 
	{ 
		String _sFamily = sFamilies[i];
		if (_sFamily == sFamily)continue;
		
		String sTriggerChangeFamily = "-> " + _sFamily;
		addRecalcTrigger(_kContext, sTriggerChangeFamily );
		if (_bOnRecalc && _kExecuteKey==sTriggerChangeFamily)
		{
			sFamily.set(_sFamily);
			setExecutionLoops(2);
			return;
		}//endregion		 
	}//next i


// validate zOffset
	if(abs(dZOffset))
	{
		double dMaxZOffset = .5 * (el.dBeamWidth() - dC);
		if (dInterdistance > 0)dMaxZOffset -= .5*dInterdistance;
		if (dMaxZOffset < 0)dMaxZOffset = 0;
		if (bLeftRight && abs(dZOffset)>dMaxZOffset)
		{
			int nSgn =dZOffset / abs(dZOffset);
			dZOffset.set(nSgn*dMaxZOffset);
			reportMessage("\n" + scriptName() + ": " +sZOffsetName + T(" |has been corrected to| ") + dZOffset);
			
		}		
	}



// set reference point	
	Point3d ptRef = _Pt0-vecZC*dDepth+(bLeftRight?vecZ:vecX)*dZOffset;	

	
// collect plates if in LR mode
	Beam bmPlates[0];
	if (bLeftRight)
	{ 
		PLine pl;
		pl.createRectangle(LineSeg(ptRef - vecXC * .5 * dB, ptRef + vecXC * .5 * dB + vecZC * dC), vecXC, vecZC);
		Body bdTest(pl, vecY * U(10e4), 0);//bdTest.vis(6);
		Beam bmHorizontals[] = vecY.filterBeamsPerpendicularSort(bdTest.filterGenBeamsIntersect(beams));
		
		if (bmHorizontals.length()>0)
		{ 
			Point3d ptRefBot = bmHorizontals[0].ptCenSolid() - vecY * .5 * bmHorizontals[0].dD(vecY);
			for (int f=0;f<bmHorizontals.length();f++) 
			{ 
				Beam& bmH = bmHorizontals[f];
				double dD = bmH.dD(vecY);
				Point3d ptBot = bmH.ptCenSolid() - vecY * .5 * dD;				
				double d1 = abs(vecY.dotProduct(ptBot - ptRefBot));			
				if (d1<dEps)
					bmPlates.append(bmH);
			}
		}
	}

// on creation set _Pt0 to ptOrg elevation
	if (_bOnDbCreated || _bOnRecalc || _kNameLastChangedProp=="_Pt0" || bSetLocation)
	{
		if (bmPlates.length()>0)
			_Pt0.transformBy(vecY * (vecY.dotProduct(bmPlates[0].ptCenSolid() - _Pt0) + .5 * bmPlates[0].dD(vecY)));
		else
		{
			_Pt0.transformBy(vecY * vecY.dotProduct(ptOrg - _Pt0));
		}
		ptRef = _Pt0-vecZC*dDepth+(bLeftRight?vecZ:vecX)*dZOffset;		
	}
	
	vecXC.vis(_Pt0, 1);
	vecYC.vis(_Pt0, 3);
	vecZC.vis(_Pt0, 150);			

// compose the solid
	ptRef.vis(6);
	Body bd(ptRef, vecXC,vecYC, vecZC, dC,dA, dT,0,1,1);
	bd.addPart(Body(ptRef, vecXC,vecYC, vecZC, dC,dTB, dB,0,1,1));
	
// Add triangles to the HTT brakets
	if(nFamily == 0)
	{
		Point3d ptTriang = ptRef+vecYC*dTB;
		PLine plTriang(ptTriang , ptTriang+vecZC*dB, ptTriang +vecY*dATriang);
		plTriang.close();
		plTriang.transformBy(-vecXC*.5*dC);
		bd.addPart(Body(plTriang, vecXC*dT,1));
		plTriang.transformBy(vecXC*dC);
		bd.addPart(Body(plTriang, vecXC*dT,-1));		
	}

// TOOLING
// beamcut
	double dXBc=dXTotal+2*dGap, dYBc=dA+dGap, dZBc=dDepth;
	if (dXBc>dEps && dYBc>dEps && dZBc>dEps)
	{ 
		Point3d ptBc = ptRef;
		double dYFlag = 1;
		if (!bLeftRight)
		{ 
			dYBc*=2;
			dYFlag = 0;
		}
		BeamCut bc(ptBc, vecXC, vecYC, vecZC, dXBc, dYBc,2*dZBc,0,dYFlag,1);
		bc.cuttingBody().vis(4);
		bc.addMeToGenBeams(beams);
	}

// drill
	Drill drill;
	{ 
		Point3d ptDr = ptRef + vecZC * dZOffsetBase;
	// LR bottom plate
		if (bLeftRight)
			drill=Drill (ptDr, ptDr + vecYC *vecYC.dotProduct(ptOrg-ptDr), dDiamPlate * .5);
		
	// solid
		bd.addTool(Drill(ptDr, ptDr+vecYC*dTB, dDiamBase*.5));
	}
	
	
	//bd.vis(2);	
	
// Displays
	Display dpModel(nColor), dpElement(nColor), dpSpecial(nColor);
	double dTxtH = U(75);
	dpModel.elemZone(el, 0, 'I');
	
	dpElement.addViewDirection(vecZ);
	dpElement.addViewDirection(-vecZ);
	if(nSpecial==0) 
	{
		
		dpElement.dimStyle("BF 0.2");
		dpElement.textHeight(dTxtH);
	// make it visible on layer J5
		dpSpecial.elemZone(el, 5, 'J');
	}

//region get the block
	String sBlockName = sModel;
	if (sModel.find('/',0) >- 1)
	{ 
		String ss = sModel;
		String sss[] = ss.tokenize("/");
		if (sss.length() != 2)
		{ 
			reportMessage("\n" + scriptName() + ": " +T("|unexpected model name|"));
		}
		for (int i = 0; i < sss.length() - 1; i++)
		{ 
			sBlockName = sss[i] + "-" + sss[i + 1];
		}//next i
	}

	// get the block from existing drawing
	int iIndexBlock = _BlockNames.find(sBlockName);
	int iModelFound = false;
	if (iIndexBlock >- 1)
	{ 
		Block block(_BlockNames[iIndexBlock]);
		dpModel.draw(block, _Pt0, vecXC, vecYC, vecZC);
		iModelFound = true;
	}
	else
	{ 
		// try to find it from the hsbCompany\Block directory
		String sPath = _kPathHsbCompany;
		String sFolder = "Block";
		String sFileName = sBlockName;
		String sFolders[] = getFoldersInFolder(sPath);
		String sFullPath = sPath + "\\" + sFolder + "\\" + sFileName + ".dwg";
		String sFile = findFile(sFullPath);
		if (sFile.length() > 0)
		{
			Block block(sFile);
			dpModel.draw(block, _Pt0, vecXC, vecYC, vecZC);
			iModelFound = true;
		}
	}
	if ( ! iModelFound)
	{ 
		// block not found for the model name
		// look for family
		sBlockName = sFamily;
		int iIndexBlock = _BlockNames.find(sBlockName);
		if (iIndexBlock >- 1)
		{ 
			Block block(_BlockNames[iIndexBlock]);
			dpModel.draw(block, _Pt0, vecXC, vecYC, vecZC);
		}
		else
		{ 
			// try to find it from the hsbCompany\Block directory
			String sPath = _kPathHsbCompany;
			String sFolder = "Block";
			String sFileName = sBlockName;
			String sFolders[] = getFoldersInFolder(sPath);
			String sFullPath = sPath + "\\" + sFolder + "\\" + sFileName + ".dwg";
			String sFile = findFile(sFullPath);
			if (sFile.length() > 0)
			{
				Block block(sFile);
				dpModel.draw(block, _Pt0, vecXC, vecYC, vecZC);
			}
		}
	}
//End get the block//endregion 
	
// distribute and draw
	int nHWQty = dInterdistance > 0 ? 2 : 1;
	{ 
		Vector3d vecLoc = - vecXC * (nHWQty - 1) * .5 * dInterdistance;
		bd.transformBy(vecLoc);
		drill.transformBy(vecLoc);
		for (int i=0;i<nHWQty;i++) 
		{ 
			// draw the 3d
			dpModel.draw(bd);
			// draw the block
			
			if(nSpecial==0)dpSpecial.draw(bd);	
			if (bmPlates.length()>0) 
				drill.addMeToGenBeamsIntersect(bmPlates);
			vecLoc = vecXC * dInterdistance;
			bd.transformBy(vecLoc);
			drill.transformBy(vecLoc);
			
		}		
	}
	
// draw model in element view
	if(el.bIsValid())
	{
		dpElement.draw(sModel, _Pt0,el.vecY().crossProduct(vecZ), el.vecY(), 0, -2, _kDevice);
	}	


// get mounting sheet coverages
	String sCoverages[] = sCoverage.tokenize(";");
	double dCoverages[0];
	for (int i=0;i<sCoverages.length();i++) 
	{ 
		String s = sCoverages[i].trimLeft().trimRight();
		double d = s.atof();
		if (String(d)==s)
			dCoverages.append(d);
		else
			dCoverages.append(0); 
	}

// erase existing sheets
	if (bCreateSheet || bResetErase)
		for (int i=_Sheet.length()-1; i>=0 ; i--) 
			_Sheet[i].dbErase(); 

// get potential blocking beam
	Entity entBlocking = _Map.getEntity("Blocking");
	Beam bmBlocking = (Beam)entBlocking;
	if (bmBlocking.bIsValid()&& (bCreateBlocking || bResetErase || !bLeftRight))
	{ 
		bmBlocking.dbErase();
		_Map.removeAt("Blocking", true);
	}

// kill me
	if (bResetErase)
	{ 
		eraseInstance();
		return;
	}

	int nCncCatalog=sCncCatalogs.find(sCncCatalog);
//region zone work
	if (el.bIsValid() && dHeightSheet > 0)
	{
	// get and order verticals
		Beam bmVerticals[] = (bLeftRight?vecDir:vecX).filterBeamsPerpendicularSort(beams);
	
	// remove any vertical of the opposite side if in LeftRight mode
		double dXSheet;
		Point3d ptMidSheet = _Pt0;
		if (bLeftRight)
		{ 
			for (int i=bmVerticals.length()-1; i>=0 ; i--) 
			{ 
				Beam& bmV=bmVerticals[i]; 	
				//bmV.ptCenSolid().vis(i);
				if(vecDir.dotProduct(bmV.ptCenSolid()-_Pt0)<-bmV.dD(vecX))
					bmVerticals.removeAt(i);
			}
			if (bmVerticals.length()>1)
			{
				Point3d ptL = bmVerticals[0].ptCenSolid();ptL.vis(2);
				Point3d ptR = bmVerticals[1].ptCenSolid();ptR.vis(4);
				dXSheet = vecDir.dotProduct(ptR -ptL);
				ptMidSheet = (ptL + ptR) / 2;
			}
		}
		else
		{ 
		// get right stud
			Point3d ptR = _Pt0;
			for (int i=0;i<bmVerticals.length();i++) 
			{ 
				Beam& bmV=bmVerticals[i]; 
				Point3d pt = bmV.ptCenSolid();
				if(vecX.dotProduct(pt-_Pt0)>bmV.dD(vecX))
				{
					ptR = pt;
					break;
				}
			}
			Point3d ptL = _Pt0;
			for (int i=bmVerticals.length()-1; i>=0 ; i--)  
			{ 
				Beam& bmV=bmVerticals[i]; 
				Point3d pt = bmV.ptCenSolid();
				if(vecX.dotProduct(pt-_Pt0)<-bmV.dD(vecX))
				{
					ptL = pt;
					break;
				}
			}	
			dXSheet = vecX.dotProduct(ptR-ptL);
			ptMidSheet = (ptL + ptR) / 2;
			//ptL.vis(2);ptR.vis(2);
		}

	// get relevant side, for leftRight default is iconside
		int nSide = (vecZ.dotProduct(segMinMax.ptMid() - _Pt0) < 0) ?1 : -1;
		if (bLeftRight)nSide = 1;
		if (bFlipMounting)nSide *= -1;
		
	// get outmost zone
		int nRefZone;
		PlaneProfile ppRef(cs);
		for (int z=5; z>0 ; z--) 
		{ 
			int nZone = nSide * z;
			if (el.zone(nZone).dH()>dEps)
			{ 
				nRefZone = nZone;
				Sheet sheets[] = el.sheet(nZone);
				if (sheets.length() < 1)continue;
				
			// get extents of zone
				PlaneProfile ppSheet(cs);
				for (int i=0;i<sheets.length();i++)
				{
					//sheets[i].plEnvelope().vis(i);
					ppRef.joinRing(sheets[i].plEnvelope(),_kAdd);
				}			
				ppRef.shrink(-dEps);
				ppRef.shrink(dEps);
				if (ppRef.area()>pow(dEps,2))
					break;
			}
		}

	// get extents of profile
		LineSeg segRef = ppRef.extentInDir(vecX);segRef.vis(6);
		double dXRef = abs(vecX.dotProduct(segRef.ptStart()-segRef.ptEnd()));
		double dYRef = abs(vecY.dotProduct(segRef.ptStart()-segRef.ptEnd()));

	// set sheet ref location
		Point3d ptSheetRef = ptRef;
		ptSheetRef.transformBy(vecZ*vecZ.dotProduct(el.zone(nRefZone).ptOrg()-ptSheetRef));
		double dYSheetRef = vecY.dotProduct((segRef.ptMid() - vecY * .5 * dYRef) - ptSheetRef);
		ptSheetRef.transformBy(vecY * dYSheetRef);
		//ptSheetRef.vis(nZone);

		ptMidSheet = ptSheetRef +vecX* vecX.dotProduct(ptMidSheet - ptSheetRef);
		ptMidSheet.vis(nRefZone);

	// 
		
	// loop zones	
		Point3d ptBottomRef = ptOrg;// the first zone sets the bottom ref
		int bBottomRefSet;
		double dYSheet = dHeightSheet;
		for (int z=0;z<5;z++)
		{
		// zone
			int nZone = (z+1) * nSide;
			ElemZone zone = el.zone(nZone);
		
		// add coverage to the height
			int bAddCoverage = z < dCoverages.length();
			if (bAddCoverage)
			{
				dYSheet+=2*dCoverages[z];
				dXSheet+=2*dCoverages[z];
			}
			
		// skip invalid or lath zones	
			if (zone.dH() < dEps || zone.code()=="HSB-PL09")continue;

			Sheet sheets[] = el.sheet(nZone);
			if (sheets.length() < 1)continue;
			
		// get extents of zone
			PlaneProfile ppZone(cs);
			for (int i=0;i<sheets.length();i++)
			{
				//sheets[i].plEnvelope().vis(i);
				ppZone.joinRing(sheets[i].plEnvelope(),_kAdd);
			}
			
		// get extents of profile
			LineSeg segZone = ppZone.extentInDir(vecX);segZone.vis(6);
			double dYZone = abs(vecY.dotProduct(segZone.ptStart()-segZone.ptEnd()));			
			
		// make sure the new sheet starts at bottom of zone	
			if (!bBottomRefSet)
			{
				ptBottomRef = segZone.ptMid() - vecY * .5 * dYZone;
				bBottomRefSet = true;
			}
			
			double dYBottom = vecY.dotProduct(ptBottomRef - ptMidSheet);
			Point3d ptMid = ptMidSheet + vecZ * vecZ.dotProduct(zone.ptOrg() - ptMidSheet)+vecY*(dYBottom+.5*dHeightSheet);
			
			
		// set raw sheet envelope
			PLine plSheet(vecZ * nSide);
			plSheet.createRectangle(LineSeg(ptMid - vecX * .5 * dXSheet-vecY* .5*dYSheet, ptMid + vecX * .5 * dXSheet + vecY * .5*dYSheet), vecX, vecY);
//			{
//				PLine pl = plSheet;
//				pl.transformBy(vecZ * U(100));
//				pl.vis(z);
//			}

		// create mounting sheet
		// the profile of the new sheet
			PlaneProfile ppSheet(CoordSys(zone.ptOrg(), vecX, vecY, vecZ));
			ppSheet.joinRing(plSheet,_kAdd);
			ppSheet.intersectWith(ppZone);	//ppSheet.vis(6);
		
		
		// create the blocking based on the first zone
			if (bDebug || bCreateBlocking)
			{
				double dXBm = dXSheet-(bAddCoverage?-2 *dCoverages[z]:0);
				double dYBm = el.dBeamHeight();
				double dZBm = el.dBeamWidth();

				Point3d pt = ptMid+vecY*(.5*dYSheet)+vecZ*(vecZ.dotProduct(ptOrg-ptMid)-.5*dZBm);
				pt.vis(2);
				
				if (bDebug)
				{ 
					Body bd(pt, vecX, vecY, vecZ, dXBm, dYBm, dZBm, 0, 0, 0);
					bd.vis(7);
					bCreateBlocking = false;
				}
				else if (dXBm>dEps & dYBm>dEps && dZBm>dEps)
				{ 
				
					Beam bmNew;
					bmNew.dbCreate(pt, vecX, vecY, vecZ, dXBm, dYBm, dZBm, 0, 0, 0);
					bmNew.setMaterial(el.zone(0).material());
					bmNew.setColor(32);
					
					bmNew.setType(_kBlocking);
					bmNew.assignToElementGroup(el, true, 0, 'Z');
					if (bmVerticals.length()>1)
					{ 
						bmNew.stretchDynamicTo(bmVerticals[0]);
						bmNew.stretchDynamicTo(bmVerticals[1]);
					}
					_Map.setEntity("Blocking", bmNew);
					_Map.removeAt("CreateBlocking",true);
					bCreateBlocking = false;
				}
			}
			String sKey="CncMain" + z;
		// create the new sheet
			if (!bDebug && bCreateSheet && ppSheet.area()>pow(dEps,2))
			{
				Sheet sheet;
				sheet.dbCreate(ppSheet, zone.dH(), nSide);
				sheet.setMaterial(zone.material());
				sheet.setColor(zone.color());
				sheet.assignToElementGroup(el, true, nZone , 'Z');
				_Sheet.append(sheet);
				
				if ( ! sheet.bIsValid())continue;
				
			// attach special tsls to the new sheet
				if (nSpecial == 0)
				{ 
					TslInst tslText;
					GenBeam gbs[]={sheet};		Entity ents[]={el};	Map mapTsl;
					Point3d pts[]={sheet.ptCenSolid() + vecY*.5*dYSheet};
					int nProps[] = {};		double dProps[]={};		String sProps[]={"Platte schrauben"};//text
					
					tslText.dbCreate("BF-ZoneText" , vecX,vecY,gbs, ents, pts, 
						nProps, dProps, sProps, _kModelSpace, mapTsl);
					//if (tslText.bIsValid())reportMessage("\n"+tslText.scriptName() + " created for zone " + nZone);
				}

			// create CNC tool on dependency of this sheet
				TslInst tslCNC;	Map mapTslCNC;
				GenBeam gbsCNC[]={};
				Entity entsCNC[]={el, sheet};//,tslNew};
				Point3d ptsCNC[]={sheet.ptCenSolid()};
				// HSB-24881
				if(nCncCatalog==0)
				{ 
					int nPropsCNC[] = {nZone ,1};// zone, toolindex
					double dPropsCNC[]={0,0, U(75)};//depth, angle, text height
					String sPropsCNC[]={(nSide==-1?T("|Right|"):T("|Automatic|")),
						T("|Against course|"),T("|No|"),T("|Saw|"),T("|Standard|"),sSolidOperations[3],""};// Version 1.6: tool side left -> automatic
						//tool side, turning direction, overshoot, tool type, tool relation, operation, text
					tslCNC.dbCreate("hsbCNC" , vecX,vecY,gbsCNC, entsCNC, ptsCNC, 
						nPropsCNC, dPropsCNC, sPropsCNC, _kModelSpace,mapTslCNC);
				}
				else if(nCncCatalog>0)
				{ 
				// HSB-24881: create TSL with catalog
					int bForceModelSpace = true;	
					String sExecuteKey,sCatalogName = sCncCatalog;
					String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
				
					tslCNC.dbCreate("hsbCNC" , _XW ,_YW,gbsCNC, entsCNC, ptsCNC, 
						sCatalogName, bForceModelSpace, mapTslCNC, sExecuteKey, sEvent); 
				}
					
				//if (tslCNC.bIsValid())reportMessage("\n"+tslCNC.scriptName() + " created for zone " + nZone);	
				_Map.setEntity(sKey,tslCNC);// HSB-24881
			}			
		}
		
		if (bCreateSheet)
			_Map.removeAt(sKeyCreateSheet,true);
	}//endregion

//region Sheet tooling
	// 	
	String sToolingZones[0],sToolingIndexes[0], sToolingWidths[0],sToolingHeights[0];
	String sToolingI;
	for (int ic=0;ic<sToolingZone.length();ic++) 
	{ 
		char chI = sToolingZone.getAt(ic);
		if(chI!=';')
			sToolingI += chI;
		else
		{ 
			sToolingI.trimLeft();
			sToolingI.trimRight();
			sToolingZones.append(sToolingI);
			sToolingI = "";
		}
	}//next ic
	if(sToolingI!="")sToolingZones.append(sToolingI);
	sToolingI = "";
	for (int ic=0;ic<sToolingIndex.length();ic++) 
	{ 
		char chI = sToolingIndex.getAt(ic);
		if(chI!=';')
			sToolingI += chI;
		else
		{ 
			sToolingI.trimLeft();
			sToolingI.trimRight();
			sToolingIndexes.append(sToolingI);
			sToolingI = "";
		}
	}//next ic
	if(sToolingI!="")sToolingIndexes.append(sToolingI);
	sToolingI = "";
	for (int ic=0;ic<sToolingWidth.length();ic++) 
	{ 
		char chI = sToolingWidth.getAt(ic);
		if(chI!=';')
			sToolingI += chI;
		else
		{ 
			sToolingI.trimLeft();
			sToolingI.trimRight();
			sToolingWidths.append(sToolingI);
			sToolingI = "";
		}
	}//next ic
	if(sToolingI!="")sToolingWidths.append(sToolingI);
	sToolingI = "";
	for (int ic=0;ic<sToolingHeight.length();ic++) 
	{ 
		char chI = sToolingHeight.getAt(ic);
		if(chI!=';')
			sToolingI += chI;
		else
		{ 
			sToolingI.trimLeft();
			sToolingI.trimRight();
			sToolingHeights.append(sToolingI);
			sToolingI = "";
		}
	}//next ic
	if(sToolingI!="")sToolingHeights.append(sToolingI);
	
	if(el.bIsValid())
	{ 
		int nSide=(vecZ.dotProduct(segMinMax.ptMid()-_Pt0)<0)?1:-1;
		if (bLeftRight)nSide = 1;
		if (bFlipMounting)nSide *= -1;
		
		for (int z=0;z<5;z++)
		{ 
			//
			String sKey = "Cnc" + z;
			int iClean;
			if (sToolingIndexes.length() < z+1)iClean=true;
			if (sToolingZones.length() < z+1)iClean=true;
			if (sToolingWidths.length() < z+1)iClean=true;
			if (sToolingHeights.length() < z+1)iClean=true;
			if(!iClean)
				if(sToolingZones[z]==""|| sToolingIndexes[z]==""
					|| sToolingWidths[z]==""|| sToolingHeights[z]=="")iClean=true;
			if(iClean)
			{ 
				if(_Map.hasEntity(sKey))
				{ 
					Entity EntI=_Map.getEntity(sKey);
					EntI.dbErase();
					_Map.removeAt(sKey, true);
				}
				continue;
			}
			int nIndexZ = sToolingIndexes[z].atoi();
			double dWidthI = sToolingWidths[z].atof();
			double dHeightI = sToolingHeights[z].atof();
			int nZone=(z+1)*nSide;
			ElemZone zone=el.zone(nZone);
		// skip invalid or lath zones	
			if (zone.dH()<dEps || zone.code()=="HSB-PL09")continue;
			Sheet sheets[]=el.sheet(nZone);
			if (sheets.length()<1)continue;
			
			PLine plTool;
			plTool.createRectangle(LineSeg(_Pt0-(.5*dC+dWidthI)*vecXC,
				_Pt0 + (.5*dC+dWidthI) * vecXC + (dA+ dHeightI) * vecYC), vecXC, vecYC);
			plTool.vis(3);
			String sToolCnc = T("|Saw|");
			String sOperationCnc = T("|Solid Operation|");
			if(sToolingZones[z]=="Milling" || sToolingZones[z]=="2")
			{
				sToolCnc = T("|Milling|");
			}
			else if(sToolingZones[z]=="SawNoNail" || sToolingZones[z]=="3")
			{
				sToolCnc=T("|Saw|");
				sOperationCnc=T("|Solid Operation|") + T(" |with Nonail area|");
			}
			else if(sToolingZones[z]=="MillingNoNail" || sToolingZones[z]=="4")
			{
				sToolCnc=T("|Milling|");
				sOperationCnc=T("|Solid Operation|") + T(" |with Nonail area|");
			}
			
			int iCncExists;
			if(_Map.hasEntity(sKey))
			{ 
				Entity entCnc = _Map.getEntity(sKey);
				TslInst tslCnc = (TslInst)entCnc;
				if(tslCnc.bIsValid())
				{ 
					iCncExists = true;
					//update
					Map map = tslCnc.map();
					map.setPLine("plCNC", plTool);
//					map.setPLine("pline", plTool);
					tslCnc.setMap(map);
					tslCnc.setPropString(3,sToolCnc);
					tslCnc.setPropString(5,sOperationCnc);
					tslCnc.setPropInt(1,nIndexZ);
					tslCnc.recalcNow();
				}
			}
			
			if(!iCncExists)
			{ 
			// create CNC tool on dependency of this sheet
				TslInst tslCNC;	Map mapTslCNC;
				mapTslCNC.setPLine("plCNC", plTool);
				GenBeam gbsCNC[]={};
				Entity entsCNC[]={el};//,tslNew};
				Point3d ptsCNC[]={_Pt0};
				int nPropsCNC[] = {nZone ,nIndexZ};// zone, toolindex
				double dPropsCNC[]={0,0, U(75)};//depth, angle, text height
				String sToolCnc = T("|Saw|");
				String sOperationCnc = T("|Solid Operation|");
				if(sToolingZones[z]=="Milling" || sToolingZones[z]=="2")
				{
					sToolCnc = T("|Milling|");
				}
				else if(sToolingZones[z]=="SawNoNail" || sToolingZones[z]=="3")
				{
					sToolCnc=T("|Saw|");
					sOperationCnc=T("|Solid Operation|") + T(" |with Nonail area|");
				}
				else if(sToolingZones[z]=="MillingNoNail" || sToolingZones[z]=="4")
				{
					sToolCnc=T("|Milling|");
					sOperationCnc=T("|Solid Operation|") + T(" |with Nonail area|");
				}
				String sPropsCNC[]={(nSide==-1?T("|Right|"):T("|Automatic|")),
					T("|Against course|"),T("|No|"),sToolCnc,T("|Standard|"),sOperationCnc,""};// Version 1.6: tool side left -> automatic
					//tool side, turning direction, overshoot, tool type, tool relation, operation, text
				tslCNC.dbCreate("hsbCNC" , vecX,vecY,gbsCNC, entsCNC, ptsCNC, 
					nPropsCNC, dPropsCNC, sPropsCNC, _kModelSpace,mapTslCNC);
				_Map.setEntity(sKey,tslCNC);
			}
		}
	}
//End Sheet tooling//endregion 

// Hardware//region
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
		Element elHW =bmDef.element(); 
		// check if the parent entity is an element
		if (!elHW.bIsValid())
			elHW = (Element)bmDef;
		if (elHW.bIsValid()) 
			sHWGroupName=elHW.elementGroup().name();
	// loose
		else
		{
			Group groups[] = _ThisInst.groups();
			if (groups.length()>0)
				sHWGroupName=groups[0].name();
		}		
	}
	
// add main componnent
	{ 
		HardWrComp hwc(sModel, nHWQty); // the articleNumber and the quantity is mandatory
		
		hwc.setManufacturer("Simpson StrongTie");
		
		hwc.setModel(sModel);
//		hwc.setName(sHWName);
//		hwc.setDescription(sHWDescription);
		hwc.setMaterial("SS Grade 33");
//		hwc.setNotes(sHWNotes);
		
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(bmDef);	
		hwc.setCategory(T("|Connector|"));
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		
		hwc.setDScaleX(dA);
		hwc.setDScaleY(dC);
		hwc.setDScaleZ(dB);
		
	// apppend component to the list of components
		hwcs.append(hwc);
	}

// make sure the hardware is updated
	if (_bOnDbCreated)
		setExecutionLoops(2);
				
	_ThisInst.setHardWrComps(hwcs);	
	//endregion
	
// store the direction vector to evaluate sheet creation when _Pt0 i sdragged
	_Map.setVector3d("vecDir", vecDir);	
	if(bSetLocation)
	{ 
		_Map.removeAt("setLocation", true);	
		_ThisInst.transformBy(Vector3d(0, 0, 0));
	}	
	



#End
#BeginThumbnail
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
G`Y.XL==U3:MRJ*BG(!*@#\N:Z6RA:VL8('(+1QA21TX%3T4`?__9
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
        <int nm="BreakPoint" vl="1905" />
        <int nm="BreakPoint" vl="937" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24881: Add property &quot;CNC catalog&quot; for the hsbCNC tsl; Implement ondberase" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="13" />
      <str nm="Date" vl="11/11/2025 1:20:49 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14511: tooling width/height defined as extra measures" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="12" />
      <str nm="Date" vl="3/15/2022 11:46:57 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14511: add properties to add toolig for each sheeting zone" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="11" />
      <str nm="Date" vl="3/4/2022 5:29:17 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End