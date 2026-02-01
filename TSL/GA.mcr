#Version 8
#BeginDescription
#Versions:
2.16 13.09.2024 HSB-20921: Add check when getting available families of choosen manufacturer Author: Marsel Nakuci
2.15 07.10.2022 HSB-15990: if company XML found dont load Content\General XMLs Author: Marsel Nakuci
2.14 07.10.2022 HSB-15990: Family written in "Model" of hardware; FamilyDescription is written in "Description" of hardware Author: Marsel Nakuci
2.13 09.09.2022 HSB-15990: tool now uses new xml structure similar with GenericHanger Author: Marsel Nakuci
2.12 07.09.2022 HSB-15990: change XML name to AngleBracketCatalog Author: Marsel Nakuci
version value="2.11" date="07feb20" author="marsel.nakuci@hsbcad.com" 
HSB-5433: dont move the part with ptg, ptg only to controll the face where part is attached to
HSB-5433: fix milling when rotated
HSB-5433: add right mouse click command to swap legs or to rotate 180 degree. this option is available in insert
HSB-5170: fix bug at boundaries ptMin, ptMax
HSB-5170, translatable milling types
HSB-5170, setKeepReferenceToGenBeamDuringCopy(__kAllBeams); 
HSB-5170, if the part is displaced, project pt0 and ptg0 to the found edge 
HSB-5170, HSB-5627: write in hardware the manufacturer and the material 
HSB-5170, HSB-5627: read the xml from "\\Content\\General\\Tsl\\" if the file not found in hsbCompany\TSL\Settings 
HSB-5170, HSB-5614: add property manufacturer 
HSB-5170, HSB-5614: Change name + fix flip beams
HSB-5170, HSB-5614: if TSL is created from another TSL, there is no insert so the ptg must be initialized with _Pt0; vec0 always from genBeam0 and vec1 from genBeam1
HSB-5170: add property "milling type" and "tolerance". On insert (mode 0) this property is initialized by the xml, then it takes over and overwrites the xml 
HSB-5170: set the map for milling in Family[] map. if found it overwrites the default 
HSB-5170: changes from the teams meeting with RS and TH, comment in YT 12.09.2019 </version> 
HSB-5170: Bug in HSB-5388 was fixed so now don't need the map to save genBeams
HSB-5170: insert instances by clicking point after point+support genBeams(beam,sheet,panel)
HSB-5170: save beam in _Map instead of _Beam as a workaround regarding the issue in HSB-5388 </version>
HSB-5170: add default map if no xml found
HSB-5170: add property for nails, screw+hardware
HSB-5170: add other families
HSB-5170: add trigger to remove beam and add beam+onInsert Pt0 is initiallised with PtG[0]
When the pt0 is change the grip point will not changed, Pt0 always follows the line at the edge defined by the grip point
stable version, for 2 and 1 beam, switching between families and models is stable
support only one beam
create connection between two beams
initial





#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 16
#KeyWords simpson, strong, tie, angle, bracket, winkel
#BeginContents
/// <History>//region
/// #Versions:
// 2.16 13.09.2024 HSB-20921: Add check when getting available families of choosen manufacturer Author: Marsel Nakuci
// 2.15 07.10.2022 HSB-15990: if company XML found dont load Content\General XMLs Author: Marsel Nakuci
// 2.14 07.10.2022 HSB-15990: Family written in "Model" of hardware; FamilyDescription is written in "Description" of hardware Author: Marsel Nakuci
// 2.13 09.09.2022 HSB-15990: tool now uses new xml structure similar with GenericHanger Author: Marsel Nakuci
// 2.12 07.09.2022 HSB-15990: change XML name to AngleBracketCatalog Author: Marsel Nakuci
/// <version value="2.11" date="07feb20" author="marsel.nakuci@hsbcad.com"> HSB-5433: dont move the part with ptg, ptg only to controll the face where part is attached to </version>
/// <version value="2.10" date="04feb20" author="marsel.nakuci@hsbcad.com"> HSB-5433: fix milling when rotated </version>
/// <version value="2.9" date="03feb20" author="marsel.nakuci@hsbcad.com"> HSB-5433: add right mouse click command to swap legs or to rotate 180 degree. this option is available in insert </version>
/// <version value="2.8" date="18.11.2019" author="marsel.nakuci@hsbcad.com"> HSB-5170: fix bug at boundaries ptMin, ptMax </version>
/// <version value="2.7" date="31.10.2019" author="marsel.nakuci@hsbcad.com"> HSB-5170: comment out bc0.cuttingBody().vis(4), error when not possible to render e.g. negative width </version>
/// <version value="2.6" date="31.10.2019" author="marsel.nakuci@hsbcad.com"> HSB-5170: translatable milling types </version>
/// <version value="2.5" date="24.10.2019" author="marsel.nakuci@hsbcad.com"> HSB-5170: setKeepReferenceToGenBeamDuringCopy(_kAllBeams); </version>
/// <version value="2.4" date="30.09.2019" author="marsel.nakuci@hsbcad.com"> HSB-5170: if the part is displaced, project pt0 and ptg0 to the found edge </version>
/// <version value="2.3" date="27.09.2019" author="marsel.nakuci@hsbcad.com"> HSB-5170: HSB-5627: write in hardware the manufacturer and the material </version>
/// <version value="2.2" date="23.09.2019" author="marsel.nakuci@hsbcad.com"> HSB-5170: HSB-5627: read the xml from "\\Content\\General\\Tsl\\" if the file not found in hsbCompany\TSL\Settings </version>
/// <version value="2.1" date="20.09.2019" author="marsel.nakuci@hsbcad.com"> HSB-5170: HSB-5614: add property manufacturer </version>
/// <version value="2.0" date="20.09.2019" author="marsel.nakuci@hsbcad.com"> HSB-5170: HSB-5614: Change name + fix flip beams </version>
/// <version value="1.14" date="13.09.2019" author="marsel.nakuci@hsbcad.com"> HSB-5170: HSB-5614: if TSL is created from another TSL, there is no insert so the ptg must be initialized with _Pt0; vec0 always from genBeam0 and vec1 from genBeam1 </version>		
/// <version value="1.13" date="13.09.2019" author="marsel.nakuci@hsbcad.com"> HSB-5170: add property "milling type" and "tolerance". On insert (mode 0) this property is initialized by the xml, then it takes over and overwrites the xml </version>
/// <version value="1.12" date="12.09.2019" author="marsel.nakuci@hsbcad.com"> HSB-5170: set the map for milling in Family[] map. if found it overwrites the default </version>
/// <version value="1.11" date="12.09.2019" author="marsel.nakuci@hsbcad.com"> HSB-5170: changes from the teams meeting with RS and TH, comment in YT 12.09.2019 </version>
/// <version value="1.10" date="08.09.2019" author="marsel.nakuci@hsbcad.com"> HSB-5170: Bug in HSB-5388 was fixed so now don't need the map to save genBeams </version>
/// <version value="1.9" date="08.09.2019" author="marsel.nakuci@hsbcad.com"> HSB-5170: continuously prompt to select the beam and click point for inerting a new instance </version>
/// <version value="1.8" date="08.09.2019" author="marsel.nakuci@hsbcad.com"> HSB-5170: insert instances by clicking point after point+support genBeams(beam,sheet,panel) </version>
/// <version value="1.7" date="19.08.2019" author="marsel.nakuci@hsbcad.com"> HSB-5170: save beam in _Map instead of _Beam as a workaround regarding the issue in HSB-5388 </version>
/// <version value="1.6" date="19.07.2019" author="marsel.nakuci@hsbcad.com"> HSB-5170: add default map if no xml found </version>
/// <version value="1.5" date="17.07.2019" author="marsel.nakuci@hsbcad.com"> HSB-5170: add property for nails, screw+hardware </version>
/// <version value="1.4" date="17.07.2019" author="marsel.nakuci@hsbcad.com"> HSB-5170: add other families </version>
/// <version value="1.3" date="16.07.2019" author="marsel.nakuci@hsbcad.com"> HSB-5170: add trigger to remove beam and add beam+onInsert Pt0 is initiallised with PtG[0] </version>
/// <version value="1.2" date="17.06.2019" author="marsel.nakuci@hsbcad.com"> When the pt0 is change the grip point will not changed, Pt0 always follows the line at the edge defined by the grip point </version>
/// <version value="1.1" date="12.06.2019" author="marsel.nakuci@hsbcad.com"> stable version, for 2 and 1 beam, switching between families and products is stable </version>
/// <version value="1.0" date="12.06.2019" author="marsel.nakuci@hsbcad.com"> create connection between two beams </version>
/// <version value="0.0" date="11.06.2019" author="marsel.nakuci@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// one or two beams, pick point and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates Angle brackets at beams
/// if 2 beams are selected, the connection will be generated at the line of intersection between 2 planes of 2 beams
/// if 1 beam is selected, connection will be generated at the closest edge with the selected point
/// a grip point is defined which can be freely moved. By moving the grip point one can also change the edges where the connection is generated
/// if the connection contains 2 beams, they can be flipped by double clicking
/// if the connection has only one beam, the plane closer to the grip point will be the first plane
/// if the planes need to be switched, then the grip point must be put closer to the required plane and 
/// far from the second plane
/// </summary>

/// commands
// command to insert a GenericAngle connection
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "GA" "AA60280")) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "GA" "AB")) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "GA" "AB?AB70")) TSLCONTENT

// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|UserPrompt|"))) TSLCONTENT
//endregion
	
	
//region constants 
	U(1,"mm");
	double dEps = U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick = "TslDoubleClick";
	int bDebug = _bOnDebug;
	// read a potential mapObject defined by hsbDebugController
	{ 
		MapObject mo("hsbTSLDev" , "hsbTSLDebugController");
		if (mo.bIsValid()) { Map m = mo.map(); for (int i = 0; i < m.length(); i++) if (m.getString(i) == scriptName()) { bDebug = true; 	break; }};
		if (bDebug)reportMessage("\n" + scriptName() + " starting " + _ThisInst.handle());
	}
	String sDefault = T("|_Default|");
	String sLastInserted = T("|_LastInserted|");
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	String kGeneric = "GenericAngle_";
	String kArticle = "ArticleNumber", kManufacturer = "Manufacturer";
//end constants//endregion
	
//	return;
//region read the families from the map or xml or create a default
	
	String sOpmName = "GenericAngle";// + "-" + sFamily;
	String sOpmNameOld = "GA";
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathCompany = sPath+"\\"+sFolder+"\\";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";
	String sFileNameOld =sOpmNameOld;
	String sFileName =sOpmName;
	Map mapSetting;
	
// compose settings file location
	String sFolders[]=getFoldersInFolder(sPath); 
	int bPathFound = _bOnInsert ? sFolders.find(sFolder) >- 1 ? true : makeFolder(sPath + "\\" + sFolder) : false;
	String sFullPathOld = sPath+"\\"+sFolder+"\\"+sFileNameOld+".xml";
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
		if (sFile.length()<1)
		{
			sFile=findFile(sPathGeneral+sFileName+".xml");
		}
		if (sFile.length()>0)
		{ 
			mapSetting.readFromXmlFile(sFile);
			mo.dbCreate(mapSetting);
		}
	}
	if(_bOnDbCreated || bDebug)
	{ 
		int nVersion = mapSetting.getInt("GeneralMapObject\\Version");
		String sFile = findFile(sPathGeneral + sFileName + ".xml");
	// read the xml from installation directory
		Map mapSettingInstall; mapSettingInstall.readFromXmlFile(sFile);
		int nVersionInstall = mapSettingInstall.getMap("GeneralMapObject").getInt("Version");
		
		if(sFile.length()>0 && nVersion!=nVersionInstall)
		{
			// HSB-12683
//			reportNotice("\n"+scriptName()+": "+T("|Newer version of xml settings is available from the installation directory|"));
//			reportNotice("\n"+scriptName()+": "+sPathGeneral);
			reportNotice(TN("|A different Version of the settings has been found for|") + scriptName()+
			TN("|Current Version| ")+nVersion + "	" + _kPathDwg + TN("|Other Version| ") +nVersionInstall + "	" + sFile);
		}
	}
//End read the families from the map or xml or create a default//endregion
	
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
	
// collect existing mapObjects with the kGeneric name tag
	MapObject mobs[0];
	String sMobEntries[0];
	{ 
		String entries[] = MapObject().getAllEntryNames(sDictionary);
		for (int i=0;i<entries.length();i++) 
		{ 
			String& entry = entries[i];
		// skip any entry not being tagged kGeneric	
			if (entry.find(kGeneric,0,false)<0){ continue;}
			if (entry.find(".xlsx", 0, false) > 0)continue;
		// skip if entry is not in list of presets	
			String name = entry.right(entry.length() - kGeneric.length());
		// dont allow extra xmls if the are of a different manufacturer
			if (sPresets.length()>0 && sPresets.findNoCase(name,-1)<0){ continue;}
		// append existing mapObject
			MapObject mob(sDictionary ,entry);
			if (mob.bIsValid())
			{
				mobs.append(mob);
				sMobEntries.append(entry);
			}
		}//next i	
	}

// collect requested file names from preset if not mapObject not already existantal
	String sReadPresets[0],sSettingFiles[0], sSettingPaths[0];	
	for (int i = 0; i < sPresets.length(); i++)
	{
		String name =sPresets[i];
		String entry = kGeneric + name;
		if (sMobEntries.findNoCase(entry,-1)<0)
			sReadPresets.append(entry);	
	}

	sReadPresets.setLength(0);
	mapPresets = Map();
// Collect paths which should be read into a mapObject
	if (sReadPresets.length()>0 || mapPresets.length()<1)
	{ 
		int nCompanyXmlFound;
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
					// if company XML found dont load Content\General XMLs
						if (j == 0)nCompanyXmlFound = true;
						else if(j==1)
						{ 
							if(nCompanyXmlFound)continue;
						}
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
					// if company XML found dont load Content\General XMLs
						if (j == 0)nCompanyXmlFound = true;
						else if(j==1)
						{ 
							if(nCompanyXmlFound)continue;
						}
						sSettingFiles.append(files[i]);
						sSettingPaths.append(path + files[i]);
					}
			}
		}//next j
	}
	
// Create missing mapObjects
	String sEntries[0];
	for (int i=0;i<sSettingPaths.length();i++)
	{ 
		String entry = sSettingFiles[i];
		if (entry.find(".xml", 0, false) > 0)entry = entry.left(entry.length()-4);
		if (entry.find(".xlsx", 0, false) > 0)
		{
			entry = entry.left(entry.length()-5);
			continue;
		}
		if (sEntries.find(entry) > -1)continue;
		sEntries.append(entry);
		String path = sSettingPaths[i];
		MapObject mob(sDictionary ,entry);
		Map map; map.readFromXmlFile(path);
		
		mob.dbCreate(map);
		setDependencyOnDictObject(mob);
		mobs.append(mob);
	}//next i
//endregion	
	
//region get sManufacturers from the mapSetting
//	String sManufacturers[0];
//	{ 
//		// get the products of this family and populate the property list
//		Map mapManufacturers = mapSetting.getMap("Manufacturer[]");
//		for (int i = 0; i < mapManufacturers.length(); i++)
//		{
//			Map mapManufacturerI = mapManufacturers.getMap(i);
//			if (mapManufacturerI.hasString("Name") && mapManufacturers.keyAt(i).makeLower() == "manufacturer")
//			{
//				String sManufacturerName = mapManufacturerI.getString("Name");
//				if (sManufacturers.find(sManufacturerName) < 0)
//				{
//					sManufacturers.append(sManufacturerName);
//				}
//			}
//		}
//	}	
//End get sManufacturers from the mapSetting//endregion 
	
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
		reportNotice("\n\n" + scriptName() + TN("|Could not find any angle data in the search paths.|") + T(" |Please contact your local support.|"));
		eraseInstance();
		return;
	}
	mapSetting.setMap("Manufacturer[]",mapManufacturers);	
	
//region properties
	
	// manufacturers of the angle bracket
	String sManufacturerName = T("|Manufacturer|");
	PropString sManufacturer(0, sManufacturers, sManufacturerName);
	sManufacturer.setDescription(T("|Defines the Manufacturer|"));
	sManufacturer.setCategory(category);
	
	// families of the angle bracket
	String sFamilies[0];
	String sFamilyName = T("|Family|");
	PropString sFamily(1, sFamilies, sFamilyName);
	sFamily.setDescription(T("|Defines the Family|"));
	sFamily.setCategory(category);
	
	// product from the choosen family
	// initially it is empty, after the selection of the family
	// the product will be selected sepending on the family choosen
	String sProducts[0];
	String sProductName = T("|Product|");
	PropString sProduct(2, sProducts, sProductName);	
	sProduct.setDescription(T("|Defines the Product|"));
	sProduct.setCategory(category);
	
	// connector type, nail, screw etc
	String sNails[0];
	String sNailName=T("|Nail|");	
	PropString sNail(3, sNails, sNailName);	
	sNail.setDescription(T("|Defines the connector type, nail, screw etc.| "));
	sNail.setCategory(category);
	
	// properties for milling
	category = T("|Milling|");
	String sMillingTypes[] ={ T("|none|"), T("|male|"), T("|female|"), T("|both|")};
	String sMillingTypeName = T("|Milling Type|");
	PropString sMillingType(4, sMillingTypes, sMillingTypeName);	
	sMillingType.setDescription(T("|Defines the MillingType|"));
	sMillingType.setCategory(category);
	
	String sToleranceName=T("|Tolerance|");	
	PropDouble dTolerance(nDoubleIndex++, U(0), sToleranceName);	
	dTolerance.setDescription(T("|Defines the Tolerance|"));
	dTolerance.setCategory(category);
	
	// properties when angle only attached to 1 beam
//	category=T("|additional properties when bracket attached to one genBeam|");
//	String sSwapLegsName=T("|Swap Legs|");	
//	PropString sSwapLegs(5, sNoYes, sSwapLegsName);
//	sSwapLegs.setDescription(T("|Defines whether the legs are swapped|"));
//	sSwapLegs.setCategory(category);
//	// rotate bracket
//	String sRotate180DegreeName=T("|Rotate 180 Degrees|");	
//	PropString sRotate180Degree(6, sNoYes, sRotate180DegreeName);	
//	sRotate180Degree.setDescription(T("|Defines the Rotate180Degree|"));
//	sRotate180Degree.setCategory(category);
	
//End properties//endregion 
	
	
// bOnInsert//region
	if(_bOnInsert)
	{
		category=T("|additional properties when bracket attached to one genBeam|");
		String sSwapLegsName=T("|Swap Legs|");	
		PropString sSwapLegs(5, sNoYes, sSwapLegsName);
		sSwapLegs.setCategory(category);
		String sRotate180DegreeName=T("|Rotate 180 Degrees|");	
		PropString sRotate180Degree(6, sNoYes, sRotate180DegreeName);
		sRotate180Degree.setCategory(category);
		if (insertCycleCount()>1) { eraseInstance(); return; }
		
	// get opm key from the _kExecuteKey
		String sTokens[] = _kExecuteKey.tokenize("?");
		String sOpmKey;
		if(sTokens.length()>0)
		{ 
			sOpmKey = sTokens[0];
		}
		else
		{ 
			sOpmKey = "";
		}
		
	// get the family from the _kExecuteKey or from the dialog box
	// validate the opmkeys, should be one of the families supported
		if (sOpmKey.length() > 0)
		{ 
			String s1 = sOpmKey;
			s1.makeUpper();
			int bOk;
			
			for (int i = 0; i < sManufacturers.length(); i++)
			{
				String s2 = sManufacturers[i];
				s2.makeUpper();
				if (s1 == s2)
				{
					bOk = true;
					sManufacturer.set(T(sManufacturers[i]));
					setOPMKey(sManufacturers[i]);
					sManufacturer.setReadOnly(true);
					break;
				} 
			}//next i
		// the opmKey does not match any family name -> reset
			if (!bOk)
			{
				reportNotice("\n" + scriptName() + ": " + T("|NOTE, the specified OPM key| '") +sOpmKey+T("' |cannot be found in the list of Manufacturers.|"));
				sOpmKey = "";
			}
		}
		else
		{
		// sOpmKey not specified, show the dialog
			sManufacturer.setReadOnly(false);
			sFamily.set("---");
			sFamily.setReadOnly(true);
			sProduct.set("---");
			sProduct.setReadOnly(true);
			sNail.set("---");
			sNail.setReadOnly(true);
			sMillingType.setReadOnly(false);
			dTolerance.setReadOnly(false);
			// 
			sSwapLegs.setReadOnly(false);
			sRotate180Degree.setReadOnly(false);
			showDialog("---");
			setOPMKey(sManufacturer);
			sOpmKey = sManufacturer;
		}
		
	// sOpmKey is set, enter Product
	// read the xml for this family
		if(bDebug)reportMessage("\n"+ scriptName() + " mapSetting.length() "+ mapSetting.length());
		
		// from the mapSetting get all the defined families
		if (mapSetting.length() > 0)
		{
			Map mapManufacturers = mapSetting.getMap("Manufacturer[]");
			if (mapManufacturers.length() < 1)
			{
				// wrong definition of the map
				reportMessage("\n"+scriptName()+" "+T("|wrong definition of the map|"));
				eraseInstance();
				return;
			}
			for (int i = 0; i < mapManufacturers.length(); i++)
			{
				Map mapManufacturerI = mapManufacturers.getMap(i);
//				if (mapManufacturerI.hasString("Name") && mapManufacturers.keyAt(i).makeLower() == "manufacturer")
				if (mapManufacturers.keyAt(i).makeLower() == "manufacturer")
				{
//					String sManufacturerName = mapManufacturerI.getString("Name");
					String sManufacturerName = mapManufacturerI.getMapName();
					if (sManufacturerName.makeUpper() != sManufacturer.makeUpper())
					{
						// not this family, keep looking
						continue;
					}
				}
				else
				{
					// not a manufacturer map
					continue;
				}
				
				// map of the selected manufacturer is found
				// get its families
				Map mapFamilies = mapManufacturerI.getMap("Family[]");
				if (mapFamilies.length() < 1)
				{
					// wrong definition of the map
					reportMessage("\n"+scriptName()+" "+T("|no family definition for this manufacturer|"));
					eraseInstance();
					return;
				}
				for (int j = 0; j < mapFamilies.length(); j++)
				{
					Map mapFamilyJ = mapFamilies.getMap(j);
//					if (mapFamilyJ.hasString("Name") && mapFamilies.keyAt(j).makeLower() == "family")
					if (mapFamilies.keyAt(j).makeLower() == "family")
					{
//						String sName = mapFamilyJ.getString("Name");
						String sName = mapFamilyJ.getMapName();
						if (sFamilies.find(sName) < 0)
						{
							// populate sFamilies
							sFamilies.append(sName);
							if (bDebug)reportMessage("\n" + scriptName() + " sName: " + sName);
						}
					}
				}
			
			// set the family
				if (sTokens.length() < 2)// family not defined in opmkey, showdialog
				{ 
					// set array of sproducts and get the first by default
					// manufacturer is set, set as readOnly
					sManufacturer.setReadOnly(true);
					sFamily.setReadOnly(false);
					sFamily = PropString(1, sFamilies, sFamilyName, 0);
					sProduct = PropString(2, sProducts, sProductName, 0);
					sProduct.set("---");
					sProduct.setReadOnly(true);
					sNail = PropString(3, sNails, sNailName, 0);
					sNail.set("---");
					sNail.setReadOnly(true);
					sMillingType.setReadOnly(false);
					dTolerance.setReadOnly(false);
					//
					sSwapLegs.setReadOnly(false);
					sRotate180Degree.setReadOnly(false);
					showDialog();

					if(bDebug)reportMessage("\n"+ scriptName() + " from dialog ");
					if(bDebug)reportMessage("\n"+ scriptName() + " sProduct "+sProduct);
				}
				else
				{ 
					// see if sTokens[1] is a valid product name as in sProducts from mapSetting
					int indexSTokens = sFamilies.find(sTokens[1]);
					if (indexSTokens >- 1)
					{ 
						// find
		//				sProduct = PropString(1, sProducts, sProductName, indexSTokens);
						sFamily.set(sTokens[1]);
						if(bDebug)reportMessage("\n"+ scriptName() + " from tokens ");
					}
					else
					{ 
						// wrong definition in the opmKey, accept the first product from the xml
						reportMessage("\n"+scriptName()+" "+T("|wrong definition of the OPM key|"));
						sFamily.set(sFamilies[0]);
					}
				}
				
				// for the chosen family get products and nails. first find the map of selected family
				for (int j = 0; j < mapFamilies.length(); j++)
				{ 
					Map mapFamilyJ = mapFamilies.getMap(j);
//					if (mapFamilyJ.hasString("Name") && mapFamilies.keyAt(j).makeLower() == "family")
					if (mapFamilies.keyAt(j).makeLower() == "family")
					{
//						String sFamilyName = mapFamilyJ.getString("Name");
						String sFamilyName = mapFamilyJ.getMapName();
						if (sFamilyName.makeUpper() != sFamily.makeUpper())
						{
							// not this family, keep looking
							continue;
						}
					}
					else
					{
						// not a manufacturer map
						continue;
					}
					
					// mapFamilyJ is found, populate products and nails
					// map of the selected family is found
					// get its products
					Map mapProducts = mapFamilyJ.getMap("Product[]");
					if (mapProducts.length() < 1)
					{
						// wrong definition of the map
						reportMessage("\n"+scriptName()+" "+T("|no product definition for this family|"));
						eraseInstance();
						return;
					}
					
					for (int k = 0; k < mapProducts.length(); k++)
					{
						Map mapProductK = mapProducts.getMap(k);
//						if (mapProductK.hasString("Name") && mapProducts.keyAt(k).makeLower() == "product")
						if (mapProducts.keyAt(k).makeLower() == "product")
						{
//							String sName = mapProductK.getString("Name");
							String sName = mapProductK.getMapName();
							if (sProducts.find(sName) < 0)
							{
								// populate sProducts
								sProducts.append(sName);
								if (bDebug)reportMessage("\n" + scriptName() + " sName: " + sName);
							}
						}
					}
					
					// get its nails
					Map mapNails = mapFamilyJ.getMap("Nail[]");
					if (mapNails.length() < 1)
					{
						// wrong definition of the map
						reportMessage("\n"+scriptName()+" "+T("|no nail definition for this family|"));
						eraseInstance();
						return;
					}
					for (int k = 0; k < mapNails.length(); k++)
					{
						Map mapNailK = mapNails.getMap(k);
						if (mapNailK.hasString("Name") && mapNails.keyAt(k).makeLower() == "nail")
						{
							String sName = mapNailK.getString("Name");
							if (sNails.find(sName) < 0)
							{
								// populate sNails
								sNails.append(sName);
								if (bDebug)reportMessage("\n" + scriptName() + " sName: " + sName);
							}
						}
					}
					
					// set the product
					if (sTokens.length() < 3)
					{ 
						// product not set in opm key, show the dialog to get the opm key
						// set array of sproducts and get the first by default
						// family is set, set as readOnly
						sManufacturer.setReadOnly(true);
						sFamily.setReadOnly(true);
						sProduct.setReadOnly(false);
						sProduct = PropString(2, sProducts, sProductName, 0);
						sNail.setReadOnly(false);
						sNail = PropString(3, sNails, sNailName, 0);
						sMillingType.setReadOnly(false);
						sMillingType = PropString(4, sMillingTypes, sMillingTypeName, 0);
						dTolerance.setReadOnly(false);
						showDialog();
						if(bDebug)reportMessage("\n"+ scriptName() + " from dialog ");
						if(bDebug)reportMessage("\n"+ scriptName() + " sProduct "+sProduct);
					}
					else
					{ 
						// see if sTokens[1] is a valid product name as in sProducts from mapSetting
						int indexSTokens = sProducts.find(sTokens[1]);
						if (indexSTokens >- 1)
						{ 
							// find
			//				sProduct = PropString(1, sProducts, sProductName, indexSTokens);
							sProduct.set(sTokens[1]);
							if(bDebug)reportMessage("\n"+ scriptName() + " from tokens ");
						}
						else
						{ 
							// wrong definition in the opmKey, accept the first product from the xml
							reportMessage("\n"+scriptName()+" "+T("|wrong definition of the OPM key|"));
							sProduct.set(sProducts[0]);
						}
						// set the nail
						sNail.set(sNails[0]);
					}
					// products and nails are set
					break;
				}
				// family is set
				break;
			}
		}
		
		int iCount = 0;
		while (iCount < 20)
		{ 
		// prompt for the genBeam selection max 20 times
			Entity ents[0];
			GenBeam gBeams[0];
			PrEntity ssE(T("|Select genBeam(s)|"), GenBeam());
			if (ssE.go())
				ents.append(ssE.set());
				
			if (ents.length() < 1)
			{ 
				reportMessage("\n"+scriptName()+" "+T("|Select at least one genBeam (beam, sheet or panel)|"));
				eraseInstance();
				return;
			}
		
			//get Point	(grip point needed to define the position of the connection)
			Point3d pt = getPoint(TN("|Select the Point|"));
			
			// initialize _Pt0 with pt
			_Pt0 = pt;
			iCount ++;
			
			// create TSL
			TslInst tslNew;			Vector3d vecXTsl = _XW;	Vector3d vecYTsl = _YW;
			GenBeam gbsTsl[] = { };	Entity entsTsl[] = { };	Point3d ptsTsl[] = { _Pt0, pt};
			int nProps[]={};		double dProps[]={dTolerance};	String sProps[]={sManufacturer, sFamily, sProduct, sNail};
			Map mapTsl;	
			// write the additional properties when attached to 1 beam sSwapLegs, sRotate180Degree
			// swap dA with dC
			if(sNoYes.find(sSwapLegs)==1)
			{ 
				// yes is choosen, swap is activated
				mapTsl.setInt("iSwapLegs", 1);
			}
			
			//  sRotate180Degree
			if (sNoYes.find(sRotate180Degree) == 1)
			{ 
				// yes is choosen, rotate 180 degrees
				mapTsl.setInt("iRotate180Degrees", 1);
			}
			// add first beam at genbeams gbsTsl
			// add genBeams to gbsTsl
			
			for (int i = 0; i < ents.length(); i++)
			{ 
				GenBeam gb = (GenBeam) ents[i];
				if (gb.bIsValid())
				{ 
					gbsTsl.append(gb);
				}
				if (gbsTsl.length() == 2)
				{ 
					// 2 genBeams found, dont append any more
					break;
				}
			}//next i
			
			tslNew.dbCreate(scriptName(), vecXTsl, vecYTsl, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
		}
		
//	// silent/dialog
//		String sKey = _kExecuteKey;
//		sKey.makeUpper();
		
//		if (sKey.length()>0)
//		{
//			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
//			for (int i = 0; i < sEntries.length(); i++)
//				sEntries[i] = sEntries[i].makeUpper();
//			if (sEntries.find(sKey) >- 1)
//				setPropValuesFromCatalog(sKey);
//			else
//				setPropValuesFromCatalog(sLastInserted);
//		}
//		else
//			showDialog();
		
		eraseInstance();
		return;
	}
// end on insert	__________________//endregion
	
	
//region validate
	
	if (_GenBeam.length() < 1)
	{ 
		// no beam in selection
		reportMessage("\n"+scriptName()+" "+T("|no beam found|"));
		eraseInstance();
		return;
	}
//End validate//endregion 

//region flip beams
	
	if (_GenBeam.length() == 2)
	{ 
		// 2 genBeams, have the command flipGenBeams
		// Trigger flipGenBeams//region
		String sTriggerflipGenBeams = T("|flip genBeams|");
		addRecalcTrigger(_kContext, sTriggerflipGenBeams );
		if (_bOnRecalc && (_kExecuteKey == sTriggerflipGenBeams || _kExecuteKey == sDoubleClick))
		{
			// swap 0 with 1
			_GenBeam.swap(0, 1);
			// trigger recalculation
			setExecutionLoops(2);
			return;
		}//endregion		
	}
	
//End flip beams//endregion
	
	setKeepReferenceToGenBeamDuringCopy(_kAllBeams);
//region add or remove genBeams
	
	// initialize the swap legs
	int iRotate180 = 0;
	// initialize the swap legs
	int iSwapLegs = 0;
	if (_GenBeam.length() < 2)
	{ 
		// Trigger addGenBeam//region
		String sTriggeraddGenBeam = T("|Add genBeam|");
		addRecalcTrigger(_kContext, sTriggeraddGenBeam );
		if (_bOnRecalc && (_kExecuteKey == sTriggeraddGenBeam))
		{
			GenBeam genBeamSelected = getGenBeam(TN("|Select the genBeam|"));
			
			if (_GenBeam[0] != genBeamSelected)
			{
				// selected genBeam new, append in _GenBeam
				_GenBeam.append(genBeamSelected);
			}
			setExecutionLoops(2);
			return;
		}//endregion
		
		if ( ! _Map.hasInt("iRotate180Degrees"))
		{ 
			// if not found initiate with 0
			_Map.setInt("iRotate180Degrees", 0);
		}
		iRotate180 = _Map.getInt("iRotate180Degrees");
		
		// Trigger rotate180Degrees//region
		String sTriggerrotate180Degrees = T("|Rotate 180 degrees|");
		addRecalcTrigger(_kContext, sTriggerrotate180Degrees );
		if (_bOnRecalc && (_kExecuteKey == sTriggerrotate180Degrees || _kExecuteKey == sDoubleClick))
		{
			int ii = _Map.getInt("iRotate180Degrees");
			ii =! ii;
			_Map.setInt("iRotate180Degrees", ii);
			setExecutionLoops(2);
			return;
		}//endregion
		
		if ( ! _Map.hasInt("iSwapLegs"))
		{ 
			// if not found initiate with 0
			_Map.setInt("iSwapLegs", 0);
		}
		iSwapLegs = _Map.getInt("iSwapLegs");
		
		// Trigger swapLegs//region
		String sTriggerSwapLegs = T("|swap legs|");
		addRecalcTrigger(_kContext, sTriggerSwapLegs );
		if (_bOnRecalc && (_kExecuteKey == sTriggerSwapLegs ))
		{
			// swap leg dA with dC
			int ii = _Map.getInt("iSwapLegs");
			ii =! ii;
			_Map.setInt("iSwapLegs", ii);
			
			setExecutionLoops(2);
			return;
		}//endregion
	}
	
	if (_GenBeam.length() == 2)
	{ 
		// Trigger removeGenBeam//region
		String sTriggerremoveGenBeam = T("|Remove genBeam|");
		addRecalcTrigger(_kContext, sTriggerremoveGenBeam );
		if (_bOnRecalc && (_kExecuteKey==sTriggerremoveGenBeam))
		{
			// get genBeam	
			GenBeam gb = getGenBeam(TN("|Select the genBeam|"));
			int iFound = (_GenBeam.find(gb));
			
			if (iFound >- 1)
			{ 
				// remove from array
				_GenBeam.removeAt(iFound);
			}
			setExecutionLoops(2);
			return;
		}//endregion	
	}
	
//End add or remove beam//endregion 
//	return;
//region some data
	
	GenBeam gb = _GenBeam[0];
	Vector3d vecX = gb.vecX();
	Vector3d vecY = gb.vecY();
	Vector3d vecZ = gb.vecZ();
	Point3d ptCen = gb.ptCen();
	Point3d ptCenSolid = gb.ptCenSolid();
	double dLength = gb.solidLength();
	double dWidth = gb.solidWidth();
	double dHeight = gb.solidHeight();
	
	vecX.vis(ptCen, 1);
	vecY.vis(ptCen, 3);
	vecZ.vis(ptCen, 150);
	ptCen.vis(10);
	setOPMKey(sManufacturer);
//End some data//endregion 
	
//region geometric variables
	
	double dA;
	double dB;
	double dC;
	double dt;
	// milling data
	int iMillingType = 0;
	String sMillingTypeXml = "none";
	double dToleranceXml = 0;
	
//End geometric variables//endregion
	
//	return;;
//region get map of manufacturer
	// manufacturer should not be allowed to change
	
	sManufacturer.setReadOnly(true);
	Map mapManufacturer;
//	Map mapManufacturers = mapSetting.getMap("Manufacturer[]");
	for (int i = 0; i < mapManufacturers.length(); i++)
	{ 
		Map mapManufacturerI = mapManufacturers.getMap(i);
//		if (mapManufacturerI.hasString("Name") && mapManufacturers.keyAt(i).makeLower() == "manufacturer")
		if (mapManufacturers.keyAt(i).makeLower() == "manufacturer")
		{
//			String sManufacturerName = mapManufacturerI.getString("Name");
			String sManufacturerName = mapManufacturerI.getMapName();
			
			if (sManufacturerName.makeUpper() != sManufacturer.makeUpper())
			{
				continue;
			}
		}
		else
		{ 
			// not a manufacturer map
			continue;
		}
		
		mapManufacturer = mapManufacturers.getMap(i);
		break;
	}
	
//End get map of manufacturer//endregion
	
	
//region if the family property changes, the Product property must be corrected
// in sProducts are kept all available products of the selected family
	Map mapFamily;
	// initialize array of all Products
	sProducts.setLength(0);
	sNails.setLength(0);
	if(mapSetting.length()<1)
	{ 
		// wrong definition of the map
		reportMessage("\n"+scriptName()+" "+T("|wrong definition of the map|"));
		eraseInstance();
		return;
	}
	
	// get the products of this family and populate the property list
	Map mapFamilies = mapManufacturer.getMap("Family[]");
	sFamilies.setLength(0);
	for (int i = 0; i < mapFamilies.length(); i++)
	{
		Map mapFamilyI = mapFamilies.getMap(i);
//		if (mapFamilyI.hasString("Name") && mapFamilies.keyAt(i).makeLower() == "family")
		if (mapFamilies.keyAt(i).makeLower() == "family")
		{
//			String sName = mapFamilyI.getString("Name");
			String sName = mapFamilyI.getMapName();
			if (sFamilies.find(sName) < 0)
			{
				// populate sFamilies with all the families of the selected manufacturer
				sFamilies.append(sName);
			}
		}
	}
	// HSB-20921
	if(sFamilies.length()==0)
	{ 
		reportMessage("\n"+scriptName()+" "+T("|No Family found for manufacturer|")+" "+sManufacturer);
		eraseInstance();
		return;
	}
	int indexFamily = sFamilies.find(sFamily);
	if (indexFamily >- 1)
	{
		// selected sProductis contained in sProducts
		sFamily = PropString(1, sFamilies, sFamilyName, indexFamily);
	}
	else
	{
		// existing sProduct is not found, family has been changed so set 
		// to sProduct the first Product from sProducts
		sFamily = PropString(2, sFamilies, sFamilyName, 0);
		sFamily.set(sFamilies[0]);
	}
	
	if (mapFamilies.length() < 1)
	{ 
		// wrong definition of the map
		reportMessage("\n"+scriptName()+" "+T("|wrong definition of the map|"));
		eraseInstance();
		return;
	}
	for (int i = 0; i < mapFamilies.length(); i++)
	{
		Map mapFamilyI = mapFamilies.getMap(i);
//		if (mapFamilyI.hasString("Name") && mapFamilies.keyAt(i).makeLower() == "family")
		if (mapFamilies.keyAt(i).makeLower() == "family")
		{
//			String sFamilyName = mapFamilyI.getString("Name");
			String sFamilyName = mapFamilyI.getMapName();
			if (sFamilyName.makeUpper() != sFamily.makeUpper())
			{ 
				// not this family, keep looking
				continue;
			}
		}
		else
		{ 
			// not a family map
			continue;
		}
		
		// map is found
		mapFamily = mapFamilyI;
		// get all products and write in sProducts
		Map mapProducts = mapFamilyI.getMap("Product[]");
		if (mapProducts.length() < 1)
		{
			// wrong definition of the map
			reportMessage("\n"+scriptName()+" "+T("|no product defined for this family|"));
			eraseInstance();
			return;
		}
		
		for (int j = 0; j < mapProducts.length(); j++)
		{
			Map mapProductJ = mapProducts.getMap(j);
//			if (mapProductJ.hasString("Name") && mapProducts.keyAt(j).makeLower() == "product")
			if (mapProducts.keyAt(j).makeLower() == "product")
			{
//				String sName = mapProductJ.getString("Name");
				String sName = mapProductJ.getMapName();
				if (sProducts.find(sName) < 0)
				{
					// populate sProducts with all the products of the selected family
					sProducts.append(sName);
					if (bDebug)reportMessage("\n" + scriptName() + " sName: " + sName);
				}
			}
		}
		// get all nails and write in sNails
		Map mapNails = mapFamilyI.getMap("Nail[]");
		if (mapNails.length() < 1)
		{
			// wrong definition of the map
			reportMessage("\n"+scriptName()+" "+T("|no nail defined for this family|"));
			eraseInstance();
			return;
		}
		
		for (int j = 0; j < mapNails.length(); j++)
		{
			Map mapNailJ = mapNails.getMap(j);
			if (mapNailJ.hasString("Name") && mapNails.keyAt(j).makeLower() == "nail")
			{
				String sName = mapNailJ.getString("Name");
				if (sNails.find(sName) < 0)
				{
					// populate sProducts with all the products of the selected family
					sNails.append(sName);
					if (bDebug)reportMessage("\n" + scriptName() + " sName: " + sName);
				}
			}
		}
	}
	if (sProducts.length() < 1)
	{ 
		reportMessage("\n"+scriptName()+" "+T("|Error|")+" 1001");
		eraseInstance();
		return;
	}
	if(bDebug)reportMessage("\n"+ scriptName() + " enters prop ...");
	
	int indexProduct = sProducts.find(sProduct);
	if (indexProduct >- 1)
	{
		// selected sProductis contained in sProducts
		if (bDebug)reportMessage("\n" + scriptName() + " found product ");
		sProduct = PropString(2, sProducts, sProductName, indexProduct);
	}
	else
	{
		// existing sProduct is not found, family has been changed so set 
		// to sProduct the first Product from sProducts
		if (bDebug)reportMessage("\n" + scriptName() + " not found product ");
		sProduct = PropString(2, sProducts, sProductName, 0);
		sProduct.set(sProducts[0]);
	}
	int indexNail = sNails.find(sNail);
	if (indexNail >- 1)
	{
		// selected sNail is contained in sNails
		if (bDebug)reportMessage("\n" + scriptName() + " found product ");
		sNail = PropString(3, sNails, sNailName, indexNail);
	}
	else
	{
		// existing sNail is not found, family has been changed so set 
		// to sProduct the first Product from sNails
		if (bDebug)reportMessage("\n" + scriptName() + " not found product ");
		sNail = PropString(3, sNails, sNailName, 0);
		sNail.set(sNails[0]);
	}
	
//		setExecutionLoops(2);
	if (bDebug)reportMessage("\n" + scriptName() + " sProducts.length()" + sProducts.length());
	
//End if the family property changes, the Product property must be corrected//endregion 

//region get the map from the selected product
// family and product are consistent, get the map for this family and product
// read settings
	Map mapDiameters;
	if (mapSetting.length() < 1)
	{ 
		// 
		reportMessage("\n"+scriptName()+" "+T("|invalid xml|"));
		eraseInstance();
		return;
	}
	else
	{
		Map mapMilling = mapSetting.getMap("Milling");
		if (mapMilling.hasString("Milling"))
		{ 
			String k;
			Map m = mapMilling;//.getMap("SubNode[]");
			k = "Milling"; if (m.hasString(k)) sMillingTypeXml = m.getString(k);
			k = "Tolerance"; if (m.hasDouble(k)) dToleranceXml = m.getDouble(k);
		}
		Map mapFamilies = mapManufacturer.getMap("Family[]");
		if (mapFamilies.length() < 1)
		{ 
			// wrong definition of the map
			reportMessage("\n"+scriptName()+" "+T("|wrong definition of the map|"));
			eraseInstance();
			return;
		}
		for (int i = 0; i < mapFamilies.length(); i++)
		{
			Map mapFamilyI = mapFamilies.getMap(i);
//			if (mapFamilyI.hasString("Name") && mapFamilies.keyAt(i).makeLower() == "family")
			if (mapFamilies.keyAt(i).makeLower() == "family")
			{
//				String sFamilyName = mapFamilyI.getString("Name");
				String sFamilyName = mapFamilyI.getMapName();
				if(sFamilyName.makeUpper()!=sFamily.makeUpper())
				{ 
					// not this family, keep looking
					continue;
				}
			}
			else
			{ 
				// not a family map
				continue;
			}
			// family is found, see if there is a milling definition
			Map mapMilling = mapFamilyI.getMap("Milling");
			if (mapMilling.hasString("Milling"))
			{ 
				String k;
				Map m = mapMilling;//.getMap("SubNode[]");
				k = "Milling"; if (m.hasString(k)) sMillingTypeXml = m.getString(k);
				k = "Tolerance"; if (m.hasDouble(k)) dToleranceXml = m.getDouble(k);
			}
			
			// map is found
			// get the product
			Map mapProducts = mapFamilyI.getMap("Product[]");
			if (mapProducts.length() < 1)
			{
				// wrong definition of the map
				reportMessage("\n"+scriptName()+" "+T("|no product defined for this family|"));
				eraseInstance();
				return;
			}
			
			for (int j = 0; j < mapProducts.length(); j++)
			{
				Map mapProductJ = mapProducts.getMap(j);
//				if (mapProductJ.hasString("Name") && mapProducts.keyAt(j).makeLower() == "product")
				if (mapProducts.keyAt(j).makeLower() == "product")
				{
//					String sName = mapProductJ.getString("Name");
					String sName = mapProductJ.getMapName();
					if (sName == sProduct)
					{
						// take the properties from this product
						String k;
						Map m = mapProductJ;//.getMap("SubNode[]");
						
						k = "A"; if (m.hasDouble(k)) dA = m.getDouble(k);
						k = "B"; if (m.hasDouble(k)) dB = m.getDouble(k);
						k = "C"; if (m.hasDouble(k)) dC = m.getDouble(k);
						k = "t"; if (m.hasDouble(k)) dt = m.getDouble(k);
						// get the information of nails for this product
						mapDiameters = mapProductJ.getMap("DiamType[]");
						if (mapDiameters.length() < 1)
						{
							// wrong definition of the map
							reportMessage("\n"+scriptName()+" "+T("|no diameter for nails defined for this product|"));
							eraseInstance();
							return;
						}
						break;
					}
				}
			}
		}
	}
	
//End get the map from the selected product//endregion 


//_Pt0 = ptCen;

// connection will be generated between 2 planes
// user selects 2 beams and a point
// planes closer to the point are the 2 planes between which the connection will be generated

// if only 1 beeam is selected and a point, connection will be generated to the plane closer to the point
// and the other direction is random, 90 degree

// angles other then 90 degrees are also supported

//region set for the first time the milling properties from the xml
	
	int iMode = _Map.getInt("Mode");
	if (iMode == 0)
	{ 
		_Map.setInt("Mode", 1);
		int iMillingTypeXml = sMillingTypes.find(sMillingTypeXml);
		if (iMillingTypeXml >- 1)
		{ 
			sMillingType.set(sMillingTypes[iMillingTypeXml]);
			dTolerance.set(dToleranceXml);
		}
	}
	
//End set for the first time the milling properties from the xml//endregion 

//region evaluate
	
	if(_PtG.length()<1)
	{ 
		// if TSL is created from another TSL, there is no insert so the ptg
		// must be initialized with _Pt0
		_PtG.append(_Pt0);
//		// no point was defined
//		eraseInstance();
//		return;
	}
	_Pt0.vis(4);
	
//End evaluate//endregion 


//region if _Pt0 is changed, _PtG[0] should not change and it must keep its position
	
	if(_bOnDbCreated)
	{ 
		_Map.setPoint3d("_PtG0", _PtG[0], _kAbsolute);
	}
	
	if (_kNameLastChangedProp != "_PtG0")
	{ 
		// get the saved ptg0
		if(_Map.hasPoint3d("_PtG0"))
		{ 
			_PtG[0] = _Map.getPoint3d("_PtG0");
		}
	}
	_Map.setPoint3d("_PtG0", _PtG[0], _kAbsolute);
	_PtG[0].vis(3);
//End if _Pt0 is changed, _PtG[0] should not change and it must keep its position//endregion 
	
	
//region 6 bounding planes for the first beam
	
	double dDimExtrems[] ={ .5 * dLength, .5 * dLength,
							.5 * dWidth, .5 * dWidth,
							.5 * dHeight, .5 * dHeight};
	Vector3d vecExtrems[] ={ vecX, - vecX, vecY ,- vecY, vecZ ,- vecZ};
	Plane planes[0];
	for (int i = 0; i < 6; i++)
	{ 
		planes.append(Plane(ptCenSolid + dDimExtrems[i] * vecExtrems[i], vecExtrems[i]));
//		planes[i].vis(5);
	}//next i
	
	Quader qd(ptCenSolid, vecX, vecY, vecZ, dLength, dWidth, dHeight);
	qd.vis(4);
	
//End bounding planes of 2 genBeams//endregion 
	
//region 2 planes where connection will be generated
	
	Plane plane0;
	Vector3d vec0;
	Plane plane1;
	Vector3d vec1;
	// extreme bounding points of the edge where the connection lies
	Point3d ptMax;
	Point3d ptMin;
	
//End 2 planes where connection will be generated//endregion 
	

if (_GenBeam.length() == 1)
{ 
	// see if legs are swaped
	if (iSwapLegs)
	{ 
		// chabge dA with dC
		double daa = dA;
		dA = dB;
		dB = daa;
	}

//	
	
	// index of first plane
	// index of second plane
	int iPlaneClosest = - 1;
	int iPlaneClosest1 = - 1;
	// only one beam
	double dDistMin = 10e12;
	for (int i = 0; i < planes.length(); i++)
	{ 
		for (int j = 0; j < planes.length(); j++)
		{ 
			// dont consider parallel planes
			if (abs(abs(vecExtrems[i].dotProduct(vecExtrems[j])) - 1) < dEps)
			{ 
				// parallel planes
				continue;
			}
			// line between two planes
			int iHasIntersection = planes[i].hasIntersection(planes[j]);
			if ( ! iHasIntersection)
			{ 
				// no intersection
				continue;
			}
			Line ln = planes[i].intersect(planes[j]);
			double dDist = (ln.closestPointTo(_PtG[0]) - _PtG[0]).length();
			
			if (dDist < dDistMin)
			{ 
				dDistMin = dDist;
				iPlaneClosest = i;
				iPlaneClosest1 = j;
			}
		}
	}
	
	// closest plane between i and j
	plane0 = planes[iPlaneClosest];
	vec0 = vecExtrems[iPlaneClosest];
	plane1 = planes[iPlaneClosest1];
	vec1 = -vecExtrems[iPlaneClosest1];
	if ((plane1.closestPointTo(_PtG[0]) - _PtG[0]).length() < 
		(plane0.closestPointTo(_PtG[0]) - _PtG[0]).length())
	{ 
		plane0 = planes[iPlaneClosest1];
		vec0 = vecExtrems[iPlaneClosest1];
		plane1 = planes[iPlaneClosest];
		vec1 = -vecExtrems[iPlaneClosest];
	}
	
	// ptMax and ptMin
	{ 
		Line ln = plane0.intersect(plane1);
		Vector3d vecIntersect = ln.vecX();
		double dDim0 = qd.dD(vecIntersect);
		//
		ptMax = ln.closestPointTo(gb.ptCen()) + .5 * dDim0 * vecIntersect;
		ptMin = ln.closestPointTo(gb.ptCen()) - .5 * dDim0 * vecIntersect;
	}
}
else
{ 
	// when two genbeams, this values are 0
	iSwapLegs = 0;
	iRotate180 = 0;
	// has second genBeam
	// beam in map
	GenBeam gb1 = _GenBeam[1];
	
	Vector3d vecX1 = gb1.vecX();
	Vector3d vecY1 = gb1.vecY();
	Vector3d vecZ1 = gb1.vecZ();
	Point3d ptCen1 = gb1.ptCen();
	Point3d ptCenSolid1 = gb1.ptCenSolid();
	
	// genBeam2
	double dLength1 = gb1.solidLength();
	double dWidth1 = gb1.solidWidth();
	double dHeight1 = gb1.solidHeight();
	double dDimExtrems1[] ={ .5 * dLength1, .5 * dLength1,
							.5 * dWidth1, .5 * dWidth1,
							.5 * dHeight1, .5 * dHeight1};
	Vector3d vecExtrems1[] ={ vecX1, - vecX1, vecY1 ,- vecY1, vecZ1 ,- vecZ1};
	Plane planes1[0];
	for (int i = 0; i < 6; i++)
	{
		planes1.append(Plane(ptCenSolid1 + dDimExtrems1[i] * vecExtrems1[i], vecExtrems1[i]));
	}
	Quader qd1(ptCenSolid1, vecX1, vecY1, vecZ1, dLength1, dWidth1, dHeight1);
	qd1.vis(7);
	
	//region get the closest edge with the grip point
	
	// index of first plane at genBeam0
	// index of second plane  at genBeam1
	int iPlaneClosest = - 1;
	int iPlaneClosest1 = - 1;
	double dDistMin = 10e12;
	for (int i = 0; i < planes.length(); i++)
	{ 
		for (int j = 0; j < planes1.length(); j++)
		{ 
			// dont consider parallel planes
			if (abs(abs(vecExtrems[i].dotProduct(vecExtrems1[j])) - 1) < dEps)
			{ 
				// parallel planes
				continue;
			}
			
			// line between two planes
			int iHasIntersection = planes[i].hasIntersection(planes1[j]);
			if ( ! iHasIntersection)
			{ 
				// no intersection
				continue;
			}
			Line ln = planes[i].intersect(planes1[j]);
			double dDist = (ln.closestPointTo(_PtG[0]) - _PtG[0]).length();
			
			if ( ! vecExtrems[i].isPerpendicularTo(vecExtrems1[j]))
			{ 
				// only normal planes must be allowed
				continue;
			}
			
			if (dDist < dDistMin)
			{ 
				dDistMin = dDist;
				iPlaneClosest = i;
				iPlaneClosest1 = j;
			}
		}//next j
	}//next i
	
	// closest plane between i and j
	plane0 = planes[iPlaneClosest];
	vec0 = vecExtrems[iPlaneClosest];
	plane1 = planes1[iPlaneClosest1];
	vec1 = vecExtrems1[iPlaneClosest1];
//	if ((plane1.closestPointTo(_PtG[0]) - _PtG[0]).length() < 
//		(plane0.closestPointTo(_PtG[0]) - _PtG[0]).length())
//	{ 
//		plane0 = planes1[iPlaneClosest1];
//		vec0 = vecExtrems1[iPlaneClosest1];
//		plane1 = planes[iPlaneClosest];
//		vec1 = vecExtrems[iPlaneClosest];
//	}
	
	// ptMax, ptMin
	{ 
		Line ln = plane0.intersect(plane1);
		Vector3d vecIntersect = ln.vecX();
		double dDim0 = qd.dD(vecIntersect);
		//
		// getslice for the 2 genBeams
		// get planeProfiles
		{
			Plane pnSlice(ln.ptOrg() + vec0 * dEps, vec0);
			PlaneProfile pp = gb1.envelopeBody().getSlice(pnSlice);
			pp.vis(3);
			// get extents of profile
			LineSeg seg = pp.extentInDir(ln.vecX());
			Point3d pt1 = seg.ptStart();
			Point3d pt2 = seg.ptEnd();
			if (pt1.dotProduct(vecIntersect) > pt2.dotProduct(vecIntersect))
			{ 
				Point3d pt = pt1;
				pt1 = pt2;
				pt2 = pt;
			}
			pt1 = ln.closestPointTo(pt1);
			pt2 = ln.closestPointTo(pt2);
			
			
			Plane pnSlice1(ln.ptOrg() + vec1 * dEps, vec1);
			PlaneProfile pp1 = gb.envelopeBody().getSlice(pnSlice1);
			pp1.vis(3);
			// get extents of profile
			LineSeg seg1 = pp1.extentInDir(ln.vecX());
			Point3d pt11 = seg1.ptStart();
			Point3d pt21 = seg1.ptEnd();
			if (pt11.dotProduct(vecIntersect) > pt21.dotProduct(vecIntersect))
			{ 
				Point3d pt = pt11;
				pt11 = pt21;
				pt21 = pt11;
			}
			pt11 = ln.closestPointTo(pt11);
			pt21 = ln.closestPointTo(pt21);
			ptMin = pt1;
			if (pt11.dotProduct(vecIntersect) > pt1.dotProduct(vecIntersect))
			{ 
				ptMin = pt11;
			}
			ptMax = pt2;
			if (pt21.dotProduct(vecIntersect) < pt2.dotProduct(vecIntersect))
			{ 
				ptMax = pt21;
			}
			ptMin.vis(2);
			ptMax.vis(2);
		}
		
//		ptMax = ln.closestPointTo(gb.ptCen()) + .5 * dDim0 * vecIntersect;
//		ptMin = ln.closestPointTo(gb.ptCen()) - .5 * dDim0 * vecIntersect;
//		
//		double dDim1 = qd1.dD(vecIntersect);
//		Point3d ptMax1 = ln.closestPointTo(gb1.ptCen()) + .5 * dDim1 * vecIntersect;
//		Point3d ptMin1 = ln.closestPointTo(gb1.ptCen()) - .5 * dDim1 * vecIntersect;
//		
//		if (vecIntersect.dotProduct(ptMax1) < vecIntersect.dotProduct(ptMax))
//		{ 
//			ptMax = ptMax1;
//		}
//		if (vecIntersect.dotProduct(ptMin1) > vecIntersect.dotProduct(ptMin))
//		{ 
//			ptMin = ptMin1;
//		}
	}
}
//End get the closest edge with the grip point//endregion 
	
	
//region line between 2 planes
	
	Line ln = plane0.intersect(plane1);
	Vector3d vecIntersect = ln.vecX();
	
	if(_kNameLastChangedProp=="_Pt0")
	{ 
		_Pt0 = ln.closestPointTo(_Pt0);
	}
	else if (_kNameLastChangedProp == "_PtG0")
	{ 
		// grip point was moved
		// project ptg at the edge found
		_PtG[0] = ln.closestPointTo(_PtG[0]);
		// dont move the part with ptg, ptg only to controll the face where part is attached to
//		_Pt0 = _PtG[0];
	}
	
	// if the part is displaced, move the pt0 and ptg0
	// to the found edge
	_Pt0 = ln.closestPointTo(_Pt0);
	_PtG[0] = ln.closestPointTo(_PtG[0]);
	
//End line between 2 planes//endregion 
	
	
//region only the first time the TSL is run (onInsert), capture one of the insertion methods
	
	int nMode = _Map.getInt("Mode");
	if (nMode == 0)
	{ 
		// only the first time
		// set to 1 so it does not repeat again
		_Map.setInt("Mode", 1);
		
//	 if 2beams, we have the T-connection between 2 beams
		if (_GenBeam.length() == 2)
		{ 
			GenBeam gb0 = _GenBeam[0];
			GenBeam gb1 = _GenBeam[1];
			
			Beam bm0 = (Beam) gb0;
			Beam bm1 = (Beam) gb1;
			
			if (bm0.bIsValid() && bm1.bIsValid())
			{ 
				// 2 valid beams
				// if point outside of the edge boundaries, 
				// insert the TSL at the center of the common edge
				// otherwise insert it where the point is clicked
				
				Point3d ptMaxCenter = ptMax + .5 * dC * vecIntersect;
				Point3d ptMinCenter = ptMin - .5 * dC * vecIntersect;
				
				if (_Pt0.dotProduct(vecIntersect) > ptMaxCenter.dotProduct(vecIntersect)
				 || _Pt0.dotProduct(vecIntersect) < ptMinCenter.dotProduct(vecIntersect))
				{
					// point outside the border
					_Pt0 = .5 * (ptMax + ptMin);
				}
			}
		}
	}
	
//End only the first time the TSL is run (onInsert), capture one of the insertion methods//endregion 
	
	
//region make sure pt0 is within the borders of the edge
	
	{ 
		ptMax.vis(1);
		ptMin.vis(2);
		Point3d ptMaxCenter = ptMax + .5 * dC * vecIntersect;
		ptMaxCenter.vis(4);
		Point3d ptMinCenter = ptMin - .5 * dC * vecIntersect;
		ptMinCenter.vis(7);
		
		if (_Pt0.dotProduct(vecIntersect) > ptMaxCenter.dotProduct(vecIntersect))
		{ 
			// pt0 outside the valid borders
			_Pt0 = ptMaxCenter;
		}
		if (_Pt0.dotProduct(vecIntersect) < ptMinCenter.dotProduct(vecIntersect))
		{ 
			// pt0 outside the valid borders
			_Pt0 = ptMinCenter;
		}
	}
	
//End make sure pt0 is within the borders of the edge//endregion 

	double dCrossProduct = vec0.crossProduct(vec1).length();

//region create 3d connection
	
	// vector at plane0 normal with the intersection line of 2 planes
	// and pointing away of plane1
	Vector3d vec0Normal = vec0.crossProduct(vecIntersect);
	if (vec0Normal.dotProduct(vec1) < dEps)
	{ 
		vec0Normal *= -1;
	}
	// at plane 1
	Vector3d vec1Normal = vec1.crossProduct(vecIntersect);
	if (vec1Normal.dotProduct(vec0) < dEps)
	{ 
		vec1Normal *= -1;
	}
	
	Vector3d vxBody = vec0Normal;
	Vector3d vyBody = vecIntersect;
	Vector3d vzBody = vec0;
//	vxBody.vis(_Pt0, 1);
//	vyBody.vis(_Pt0, 2);
//	vzBody.vis(_Pt0, 3);
	if((vxBody.crossProduct(vyBody)).dotProduct(vzBody)<dEps)
	{ 
		vyBody *= -1;
	}
	Body bd0(_Pt0, vxBody, vyBody, vzBody, dA, dC, dt, 1, 0, 1);
	bd0.vis(11);
	
	vxBody = vec1Normal;
	vyBody = vecIntersect;
	vzBody = vec1;
	if ((vxBody.crossProduct(vyBody)).dotProduct(vzBody) < dEps)
	{ 
		vyBody *= -1;
	}
	double dFactorVx = 1;
	double dFactorVz = 1;
	// transform if rotate is triggered
	Vector3d vecTranslate;
	if (iRotate180)
	{ 
		vecTranslate = dt * (vxBody - vzBody);
		bd0.transformBy(dt * (- vzBody));
		_Pt0 += vecTranslate;
		vxBody *= -1;
		dFactorVx = -1;
		dFactorVz = -1;
	}
	Body bd1(_Pt0, vxBody, vyBody, vzBody, dB, dC, dt, 1, 0, 1);
	
	// change back
	
	bd1.vis(11);
	vxBody.vis(_Pt0, 1);
	vyBody.vis(_Pt0, 2);
	vzBody.vis(_Pt0, 3);
	
//	dFactorVx = 1;
//	dFactorVz = 1;
//End create 3d connection//endregion
	
//region check the milling
	iMillingType = sMillingTypes.find(sMillingType);
	if (iMillingType == 1)
	{ 
		if(!iRotate180)
		{ 
			// male
			bd0.transformBy(-(vxBody) * (dt + dTolerance));
			bd1.transformBy(-(vxBody) * (dt + dTolerance));
			Point3d ptBc = _Pt0 - (vxBody) * (dt + dTolerance);
			ptBc.vis(2);
			if (dB > 0 && dC > 0 && dt > 0)
			{ 
				BeamCut bc0(ptBc, vxBody, vyBody, vzBody, dB, dC, (dt), 1, 0, 1 );
				bc0.cuttingBody().vis(5);
				gb.addTool(bc0);
				if (_GenBeam.length() == 2)
				{ 
					GenBeam gb1 = _GenBeam[1];
					gb1.addTool(bc0);
				}
			}
			
			if ((dt + dTolerance) > 0 && dC > 0 && dA + (dt + dTolerance) > 0)
			{ 
				BeamCut bc1(ptBc, vxBody, vyBody, vzBody, (dt + dTolerance), dC, dA + (dt + dTolerance), 1, 0, 1 );
				bc1.cuttingBody().vis(3);
				
				gb.addTool(bc1);
				if (_GenBeam.length() == 2)
				{ 
					GenBeam gb1 = _GenBeam[1];
					gb1.addTool(bc1);
				}
			}
		}
		else
		{ 
			// male
			bd0.transformBy((vxBody) * (dt + dTolerance));
			bd1.transformBy((vxBody ) * (dt + dTolerance));
			Point3d ptBc = _Pt0 + (vxBody) * (dt + dTolerance);
			ptBc.vis(2);
			if (dB > 0 && dC > 0 && dt > 0)
			{ 
				BeamCut bc0(ptBc, vxBody, vyBody, vzBody, dB, dC, (dt), 1, 0, 1 );
				bc0.cuttingBody().vis(5);
				gb.addTool(bc0);
				if (_GenBeam.length() == 2)
				{ 
					GenBeam gb1 = _GenBeam[1];
					gb1.addTool(bc0);
				}
			}
			
			if ((dt + dTolerance) > 0 && dC > 0 && dA + (dt + dTolerance) > 0)
			{ 
				ptBc += vxBody * dt;
				BeamCut bc1(ptBc, -vxBody , vyBody, vzBody, (dt + dTolerance), dC, dA + (dt + dTolerance), 1, 0, 1 );
				bc1.cuttingBody().vis(3);
				
				gb.addTool(bc1);
				if (_GenBeam.length() == 2)
				{ 
					GenBeam gb1 = _GenBeam[1];
					gb1.addTool(bc1);
				}
			}
		}
	}
	else if (iMillingType == 2)
	{ 
		if(!iRotate180)
		{ 
			// female
			bd0.transformBy(-(vzBody) * (dt + dTolerance));
			bd1.transformBy(-(vzBody) * (dt + dTolerance));
			Point3d ptBc = _Pt0 - (vzBody) * (dt + dTolerance);
			if(dB + (dt + dTolerance)>0 && dC>0 && (dt + dTolerance)>0)
			{ 
				BeamCut bc0(ptBc, vxBody, vyBody, vzBody, dB + (dt + dTolerance), dC, (dt + dTolerance), 1,0,1 );
				bc0.cuttingBody().vis(5);
				gb.addTool(bc0);
				if (_GenBeam.length() == 2)
				{ 
					GenBeam gb1 = _GenBeam[1];
					gb1.addTool(bc0);
				}
			}
			if(dt>0 && dC>0 && dA>0)
			{ 
				BeamCut bc1(ptBc, vxBody, vyBody, vzBody, (dt), dC, dA, 1,0,1 );
				bc1.cuttingBody().vis(3);
				
				gb.addTool(bc1);
				if (_GenBeam.length() == 2)
				{ 
					GenBeam gb1 = _GenBeam[1];
					gb1.addTool(bc1);
				}
			}
		}
		else
		{ 
			// female
			bd0.transformBy((vzBody) * (dt + dTolerance));
			bd1.transformBy((vzBody) * (dt + dTolerance));
			Point3d ptBc = _Pt0 + (vzBody) * (dt + dTolerance+dt);
			ptBc.vis(5);
			if(dB + (dt + dTolerance)>0 && dC>0 && (dt + dTolerance)>0)
			{ 
				BeamCut bc0(ptBc, vxBody, vyBody, -vzBody, dB + (dt + dTolerance), dC, (dt + dTolerance), 1,0,1 );
				bc0.cuttingBody().vis(5);
				gb.addTool(bc0);
				if (_GenBeam.length() == 2)
				{ 
					GenBeam gb1 = _GenBeam[1];
					gb1.addTool(bc0);
				}
			}
			if(dt>0 && dC>0 && dA>0)
			{ 
				BeamCut bc1(ptBc, vxBody, vyBody, vzBody, (dt), dC, dA, 1,0,1 );
				bc1.cuttingBody().vis(3);
				
				gb.addTool(bc1);
				if (_GenBeam.length() == 2)
				{ 
					GenBeam gb1 = _GenBeam[1];
					gb1.addTool(bc1);
				}
			}
		}
		
		
	}
	else if (iMillingType == 3)
	{ 
		if(!iRotate180)
		{ 
			// both
			bd0.transformBy(-(vxBody + vzBody) * (dt + dTolerance));
			bd1.transformBy(-(vxBody + vzBody) * (dt + dTolerance));
			// do the beamcut
			Point3d ptBc = _Pt0 - (vxBody+vzBody) * (dt + dTolerance);
			if(dB + (dt + dTolerance)>0 && dC>0 && (dt + dTolerance)>0)
			{ 
				BeamCut bc0(ptBc, vxBody, vyBody, vzBody, dB + (dt + dTolerance), dC, (dt + dTolerance), 1,0,1 );
	//		bc0.cuttingBody().vis(4);
				gb.addTool(bc0);
				if (_GenBeam.length() == 2)
				{ 
					GenBeam gb1 = _GenBeam[1];
					gb1.addTool(bc0);
				}
			}
			
			if((dt + dTolerance)>0 && dC>0 && dA + (dt + dTolerance)>0)
			{ 
				BeamCut bc1(ptBc, vxBody, vyBody, vzBody, (dt + dTolerance), dC, dA + (dt + dTolerance), 1,0,1 );
	//		bc1.cuttingBody().vis(3);
				gb.addTool(bc1);
				if (_GenBeam.length() == 2)
				{ 
					GenBeam gb1 = _GenBeam[1];
					gb1.addTool(bc1);
				}
			}
		}
		else
		{ 
			// both
			bd0.transformBy((vxBody + vzBody) * (dt + dTolerance));
			bd1.transformBy((vxBody + vzBody) * (dt + dTolerance));
			// do the beamcut
			Point3d ptBc = _Pt0 + (vxBody+vzBody) * (dt + dTolerance+dt);
			if(dB + (dt + dTolerance)>0 && dC>0 && (dt + dTolerance)>0)
			{ 
				BeamCut bc0(ptBc, vxBody, vyBody, -vzBody, dB + (dt + dTolerance), dC, (dt + dTolerance), 1,0,1 );
				bc0.cuttingBody().vis(4);
				gb.addTool(bc0);
				if (_GenBeam.length() == 2)
				{ 
					GenBeam gb1 = _GenBeam[1];
					gb1.addTool(bc0);
				}
			}
			
			if((dt + dTolerance)>0 && dC>0 && dA + (dt + dTolerance)>0)
			{ 
				BeamCut bc1(ptBc, -vxBody, vyBody, vzBody, (dt + dTolerance), dC, dA + (dt + dTolerance), 1,0,1 );
				bc1.cuttingBody().vis(3);
				gb.addTool(bc1);
				if (_GenBeam.length() == 2)
				{ 
					GenBeam gb1 = _GenBeam[1];
					gb1.addTool(bc1);
				}
			}
			if((dt + dTolerance)>0 && dC>0)
			{ 
				// the third beamcut
				BeamCut bc3(ptBc, -vxBody, vyBody, -vzBody, (dt + dTolerance), dC, (dt + dTolerance), 1,0,1 );
				bc3.cuttingBody().vis(3);
				gb.addTool(bc3);
			}
		}
	}
//End check the milling//endregion 
	
//region reposition ptg at the upper part of the connector
//	vxBody.vis(_Pt0, 1);
//	vyBody.vis(_Pt0, 2);
//	vzBody.vis(_Pt0, 3);
	_PtG[0] = _Pt0 + vyBody * .5 * dC;
//End reposition ptg at the upper part of the connector//endregion 
	
//region display
	Display dp(252);
	Body bd;
	bd.addPart(bd0);
	bd.addPart(bd1);
	dp.draw(bd);
//End display//endregion 
	
//region group assignment
	assignToLayer("i");
	assignToGroups(Entity(gb));
//End group assignment//endregion 
	
//region hardware
		
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
		Element elHW =gb.element(); 
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
		String sType = sFamily + "-" + sProduct;
		HardWrComp hwc(sProduct, 1); // the articleNumber and the quantity is mandatory
		
//		String sManufacturer = mapManufacturer.getString("Name");
		String sManufacturerHwc = mapManufacturer.getMapName();
		String sFamilyHwc=mapFamily.getMapName();
		String sMaterial = mapManufacturer.getString("Material");
		
		hwc.setManufacturer(sManufacturerHwc);
		hwc.setModel(sFamilyHwc);
		//hwc.setName(sHWName);
		hwc.setDescription(mapFamily.getString("FamilyDescription"));
		hwc.setMaterial(sMaterial);
		//hwc.setNotes(sHWNotes);
		
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(gb);
		hwc.setCategory(T("|Connector|"));
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		
//		hwc.setDScaleX(dB*2);
		hwc.setDScaleX(dB);
		hwc.setDScaleY(dA);
		hwc.setDScaleZ(dC);
		
	// apppend component to the list of components
		hwcs.append(hwc);
	}	
	// add nail component
	{ 
		// for each diameter type of the nail add the hardware
		for (int i=0;i<mapDiameters.length();i++) 
		{ 
			double dDiameter;
			int iNumber;
			Map mapDiameterI = mapDiameters.getMap(i);
			// 
			String k;
			Map m = mapDiameterI;//.getMap("SubNode[]");
						
			k = "Diameter"; if (m.hasDouble(k)) dDiameter = m.getDouble(k);
			k = "Number"; if (m.hasInt(k)) iNumber = m.getInt(k);
			
			HardWrComp hwc(sNail, iNumber); // the articleNumber and the quantity is mandatory
			hwc.setGroup(sHWGroupName);
			hwc.setLinkedEntity(gb);
			hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
			
			// diameter of nail, screw
			hwc.setDScaleX(0);
			hwc.setDScaleY(dDiameter);
			hwc.setDScaleZ(0);
			
			
		// apppend component to the list of components
			hwcs.append(hwc);
		}//next i
		
	}

// make sure the hardware is updated
	if (_bOnDbCreated)
		setExecutionLoops(2);
		
	_ThisInst.setHardWrComps(hwcs);	

//End hardware//endregion 





#End
#BeginThumbnail
















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
        <int nm="BreakPoint" vl="952" />
        <int nm="BreakPoint" vl="975" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20921: Add check when getting available families of choosen manufacturer" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="16" />
      <str nm="Date" vl="9/13/2024 5:48:21 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15990: if company XML found dont load Content\General XMLs" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="15" />
      <str nm="Date" vl="10/7/2022 10:46:14 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15990: Family written in &quot;Model&quot; of hardware; FamilyDescription is written in &quot;Description&quot; of hardware" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="14" />
      <str nm="Date" vl="10/7/2022 10:06:07 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15990: tool now uses new xml structure similar with GenericHanger" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="13" />
      <str nm="Date" vl="9/9/2022 5:15:20 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15990: change XML name to AngleBracketCatalog" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="12" />
      <str nm="Date" vl="9/7/2022 4:35:16 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End