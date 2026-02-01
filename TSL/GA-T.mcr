#Version 8
#BeginDescription
#Versions:
2.24 16.05.2023 HSB-18969 catching invalid manufacturer definition

2.23 07.10.2022 HSB-15990: if company XML found dont load Content\General XMLs
2.22 07.10.2022 HSB-15990: Family written in "Model" of hardware; FamilyDescription is written in "Description" of hardware
2.21 09.09.2022 HSB-15990: tool now uses new xml structure similar with GenericHanger Author: Marsel Nakuci
2.20 07.09.2022 HSB-15990: change XML name to AngleBracketCatalog Author: Marsel Nakuci
Version 2.19   10.01.2022    HSB-14106 group assignment added
Version 2.18   21.12.2021  HSB-14106 display published for hsbMake and hsbShare
Version 2.17   14.12.2021   HSB-13752: fix nr of hardwares
Version 2.16   12.11.2021   HSB-12683: improve report for the update of xml file
Version 2.15   06.09.2021   HSB-11990: support connection of two crossing beams on top of each other
Version 2.14   02.09.2021   HSB-11990: change type from "T" to "O" and allow Truss entities
Version 2.13   28.04.2021   V2.13: Improve report message

<version value="2.12" date="11dec20" author="nils.gregor@hsbcad.com"> 

HSB-8881: Bugfix in use "disabled" instead of "---" 
HSB-8881: use "disabled" instead of "---" 
HSB-8881: fix bug in description, set manufacturer without translating
HSB-8881: changes at selection prompt
HSB-8881: differentiate the prompt depending when painter definition is selected or not
HSB-8881: support painter definition
HSB-8982: check the version conflict of XML

This tsl creates angle brckets for beams of type T
It supports multiple manufacturers like SimpsonStrongTie, Würth etc
Definition of the parts is done in an xml file
This xml file serves as a database for the parameters of all angle brackets
The script supports only connection between normal planes
On insert if the part can not be inserted at the selected position, the script
will try the mirrored position and then the rotated position
if no position is found, the tsl will be erased
After being inserted it will show the message not possible if
the user will try to change its parameters to an impossible configuration

on insert the script will try to place the bracket in the direction of the female beam.
If that will not be possible, the script will try the rotated position










#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 24
#KeyWords GA, Lux, haus, angle, bracket, simpson, strong, tie, würth, T
#BeginContents
/// <History>//region
//#Versions:
// 2.24 16.05.2023 HSB-18969 catching invalid manufacturer definition , Author Thorsten Huck
// 2.23 07.10.2022 HSB-15990: if company XML found dont load Content\General XMLs Author: Marsel Nakuci
// 2.22 07.10.2022 HSB-15990: Family written in "Model" of hardware; FamilyDescription is written in "Description" of hardware Author: Marsel Nakuci
// 2.21 09.09.2022 HSB-15990: tool now uses new xml structure similar with GenericHanger Author: Marsel Nakuci
// 2.20 07.09.2022 HSB-15990: change XML name to AngleBracketCatalog Author: Marsel Nakuci
// 2.19 10.01.2022 HSB-14106 group assignment added , Author Thorsten Huckdbdbbbbbb
// 2.18 21.12.2021 HSB-14106 display published for hsbMake and hsbShare , Author Thorsten Huck
// Version 2.17 14.12.2021 HSB-13752: fix nr of hardwares Author: Marsel Nakuci
// Version 2.16 12.11.2021 HSB-12683: improve report for the update of xml file Author: Marsel Nakuci
// Version 2.15 06.09.2021 HSB-11990: support connection of two crossing beams on top of each other Author: Marsel Nakuci
// Version 2.14 02.09.2021 HSB-11990: change type from "T" to "O" and allow Truss entities Author: Marsel Nakuci
// Version 2.13 28.04.2021 V2.13: Improve report message Author: Marsel Nakuci
/// <version value="2.12" date="11dec20" author="nils.gregor@hsbcad.com"> HSB-8881: Bugfix in use "disabled" instead of "---" </version>
/// <version value="2.11" date="18oct20" author="marsel.nakuci@hsbcad.com"> HSB-8881: use "disabled" instead of "---" </version>
/// <version value="2.10" date="18oct20" author="marsel.nakuci@hsbcad.com"> HSB-8881: fix bug in description, set manufacturer without translating </version>
/// <version value="2.9" date="16oct20" author="marsel.nakuci@hsbcad.com"> HSB-8881: changes at selection prompt </version>
/// <version value="2.8" date="15oct20" author="marsel.nakuci@hsbcad.com"> HSB-8881: differentiate the prompt depending when painter definition is selected or not </version>
/// <version value="2.7" date="12oct20" author="marsel.nakuci@hsbcad.com"> HSB-8881: support painter definition </version>
/// <version value="2.6" date="25sep20" author="marsel.nakuci@hsbcad.com"> HSB-8982: check the version conflict of XML </version>
/// <version value="2.5" date="21sep20" author="marsel.nakuci@hsbcad.com"> HSB-8922: support catalogue calling from palette command and set name of TSL same as choosen family </version>
/// <version value="2.4" date="18sep20" author="marsel.nakuci@hsbcad.com"> HSB-7708: fix typo in description, add TSL image </version>
/// <version value="2.3" date="17sep20" author="marsel.nakuci@hsbcad.com"> HSB-7708: add urls in xml, choose as default the first nail in the dropdown </version>
/// <version value="2.2" date="06mar20" author="marsel.nakuci@hsbcad.com"> HSB-5725: fix typo collusion-> collision </version>
/// <version value="2.1" date="04mar20" author="marsel.nakuci@hsbcad.com"> HSB-5725: fix ppSubtract, add collusion check, load default values in dialog </version>
/// <version value="2.0" date="03mar20" author="marsel.nakuci@hsbcad.com"> HSB-5725: on insert try to plase angle along the _X1, if not all area of bracket is covered then dont place bracket </version>
/// <version value="1.9" date="13feb20" author="marsel.nakuci@hsbcad.com"> HSB-5725: include ucs when creating tslNew.dbcreate, needed for definition of _Z0 </version>
/// <version value="1.8" date="22.11.2019" author="marsel.nakuci@hsbcad.com"> HSB-5725: fix bug at house for bothsides </version>
/// <version value="1.7" date="22.11.2019" author="marsel.nakuci@hsbcad.com"> HSB-5725: on insert try to place connection where it can be placed </version>
/// <version value="1.6" date="21.11.2019" author="marsel.nakuci@hsbcad.com"> HSB-5725: comments from Thorsten 19.11.2019 </version>
/// <version value="1.5" date="18.11.2019" author="marsel.nakuci@hsbcad.com"> HSB-5725: display text "not possible" if not possible, similar to sherpa </version>
/// <version value="1.4" date="18.11.2019" author="marsel.nakuci@hsbcad.com"> HSB-5725: escape command with right click </version>
/// <version value="1.3" date="18.11.2019" author="marsel.nakuci@hsbcad.com"> HSB-5725: kosmetik </version>
/// <version value="1.2" date="11.11.2019" author="marsel.nakuci@hsbcad.com"> HSB-5725: connect with the xml file </version>
/// <version value="1.1" date="11.11.2019" author="marsel.nakuci@hsbcad.com"> HSB-5725: comments in yt from 11.11.2019 </version>
/// <version value="1.0" date="31.10.2019" author="marsel.nakuci@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select entity, insert properties or catalog, select the male beams, select the female beams and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates angle brckets for beams of type T
/// It supports multiple manufacturers like SimpsonStrongTie, Würth etc
/// Definition of the parts is done in an xml file
/// This xml file serves as a database for the parameters of all angle brackets
/// The script supports only connection between normal planes
/// On insert if the part can not be inserted at the selected position, the script
/// will try the mirrored position and then the rotated position
/// if no position is found, the tsl will be erased
/// After being inserted it will show the message "not possible" if
/// the user will try to change its parameters to an impossible configuration
/// </summary>

/// commands
// command to insert a G-connection
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "GA-T")) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|flip Y axis|") (_TM "|select the GA-T tsl to apply the command|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|swap legs|") (_TM "|select the GA-T tsl to apply the command|"))) TSLCONTENT
//endregion
	

//region constants 
	U(1, "mm");
	double dEps = U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick = "TslDoubleClick";
	int bDebug = _bOnDebug;
	// read a potential mapObject defined by hsbDebugController
	{ 
		MapObject mo("hsbTSLDev" , "hsbTSLDebugController");
		if (mo.bIsValid()) { Map m = mo.map(); for (int i = 0; i < m.length(); i++) if (m.getString(i) == scriptName()) { bDebug = true; 	break; }}
		if (bDebug)reportMessage("\n" + scriptName() + " starting " + _ThisInst.handle());
	}
	String sDefault = T("|_Default|");
	String sLastInserted = T("|_LastInserted|");
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	String kGeneric = "GenericAngle_";
	String kArticle = "ArticleNumber", kManufacturer = "Manufacturer";
//end constants//endregion

//int nDialogMode = _Map.getInt("DialogMode");
//{ 
//	if (nDialogMode>0)
//	{ 
//		if (nDialogMode == 3)
//		{
//			setOPMKey("AddManufacturer");
//			
//			String list[0];
//			for (int i=0;i<_Map.length();i++) 
//			{ 
//				if (_Map.hasString(i))
//					list.append(_Map.getString(i)); 	 
//			}//next i
//	
//			list = list.sorted();
//			list.insertAt(0, T("|<none>|"));
//
//			String sManufacturerName=T("|Manufacturer|");	
//			PropString sManufacturer(nStringIndex++, list, sManufacturerName);	
//			sManufacturer.setDescription(T("|Defines the Manufacturer|"));
//			sManufacturer.setCategory(category);
//		}	
//		else if (nDialogMode == 4)
//		{
//			setOPMKey("RemoveManufacturer");
//			
//			String list[0];
//			for (int i=0;i<_Map.length();i++) 
//			{ 
//				if (_Map.hasString(i))
//					list.append(_Map.getString(i)); 	 
//			}//next i
//	
//			list = list.sorted();
//
//			String sManufacturerName=T("|Manufacturer|");	
//			PropString sManufacturer(nStringIndex++, list, sManufacturerName);	
//			sManufacturer.setDescription(T("|Defines the Manufacturer|"));
//			sManufacturer.setCategory(category);
//		}
//		return;		
//	}
//}


//region Settings
// settings prerequisites
	String sOpmName = "GenericAngle";
	String sOpmNameOld = "GA-T";
	
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

// region get sManufacturers from the mapSetting
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

// Append to manufacturers
//	Map mapManufacturers= mapSetting.getMap("Manufacturer[]");
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
//endregion
//End Settings//endregion
	
	
//region properties
	// HSB-8881: add painter definition
	String sPainters[] = PainterDefinition().getAllEntryNames().sorted();
	String sPainterDefault = T("<|Disabled|>");
	sPainters.insertAt(0, sPainterDefault);
	
	// manufacturers of the angle bracket
	String sManufacturerName = T("|Manufacturer|");
	PropString sManufacturer(0, sManufacturers, sManufacturerName);
	sManufacturer.setDescription(T("|Defines the Manufacturer|"));
	sManufacturer.setCategory(category);
	
	// families of the angle bracket
	String sFamilies[0];
	String sFamilyName = T("|Family|");
	PropString sFamily(1, sFamilies.sorted(), sFamilyName);
	
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
	
	// side of male beam on which the bracket is inserted
	category = T("|Positioning|");
	String sSidesHorizontal[] ={ T("|left|"), T("|right|"), T("|both|")};
	String sSideHorizontalName=T("|Side horizontal|");	
	PropString sSideHorizontal(4, sSidesHorizontal, sSideHorizontalName);	
	sSideHorizontal.setDescription(T("|Defines the Side in horizontal direction|"));
	sSideHorizontal.setCategory(category);
	
	// offset relative to the center of male beam
	String sOffsetName=T("|Offset|");	
	PropDouble dOffset(nDoubleIndex++, U(0), sOffsetName);	
	dOffset.setDescription(T("|Defines the Offset|"));
	dOffset.setCategory(category);
	
	// properties for milling
	category = T("|Milling|");
	String sMillingTypes[] ={ T("|none|"), T("|male|"), T("|female|"), T("|both|")};
	String sMillingTypeName=T("|Milling Type|");	
	PropString sMillingType(5, sMillingTypes, sMillingTypeName);	
	sMillingType.setDescription(T("|Defines the MillingType|"));
	sMillingType.setCategory(category);
	
	String sToleranceName=T("|Tolerance|");	
	PropDouble dTolerance(nDoubleIndex++, U(0), sToleranceName);	
	dTolerance.setDescription(T("|Defines the Tolerance|"));
	dTolerance.setCategory(category);
	// add painter property for male beams
	category = T("|Painter|");
	String sPainterMaleName=T("|Male beam|");	
	PropString sPainterMale(6, sPainters, sPainterMaleName);	
	sPainterMale.setDescription(T("|Defines the Painter definition of Male beams|"));
	sPainterMale.setCategory(category);
	// add painter property for female beams
	String sPainterFemaleName=T("|Female beam|");	
	PropString sPainterFemale(7, sPainters, sPainterFemaleName);	
	sPainterFemale.setDescription(T("|Defines the Painter definition of Female beams|"));
	sPainterFemale.setCategory(category);
	category = T("|Alignment|");
	String sZaxisAlignName=T("|Z Axis Align|");	
	String sZaxisAligns[] ={ "Z", "-Z", "Y", "-Y"};
	PropString sZaxisAlign(8, sZaxisAligns, sZaxisAlignName);	
	sZaxisAlign.setDescription(T("|Defines the ZaxisAlign|"));
	sZaxisAlign.setCategory(category);
//End properties//endregion 
	
	
// bOnInsert//region
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		String sTokens[] = _kExecuteKey.tokenize("?");
//		reportMessage("\n"+ scriptName() + " sTokens.length()"+sTokens.length());
//		reportMessage("\n"+ scriptName() + " _kExecuteKey"+_kExecuteKey);
		
		// HSB-8922: load properties from catalogue if a catalogue is choosen
	// if executekey is a catalogue then load properties from this catalogue
	// catalogue should not be a familyname
		if (sTokens.length()==1 && _kExecuteKey.length()>0)
		{ 
			reportNotice("\n _kExecuteKey " +_kExecuteKey);
			String files[] =  getFilesInFolder(_kPathHsbCompany+"\\tsl\\catalog\\", scriptName()+"*.xml");
			for (int i=0;i<files.length();i++) 
			{ 
				String entry = files[i].left(files[i].length() - 4);
				reportNotice("\n files " + entry);
				String sEntries[] = TslInst().getListOfCatalogNames(entry);
				
				reportNotice("\n using sEntries " + sEntries);
				if (sEntries.findNoCase(_kExecuteKey,-1)>-1)
				{ 
					Map map = _ThisInst.mapWithPropValuesFromCatalog(entry, _kExecuteKey);
					setPropValuesFromMap(map);
					
					reportNotice("\n using map " + map);
					break;
				}
			}//next i
		}
		else
		{ 
			sZaxisAlign.setReadOnly(_kHidden);
		// get opm key from the _kExecuteKey
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
//						sManufacturer.set(T(sManufacturers[i]));
						sManufacturer.set(sManufacturers[i]);
	//					setOPMKey(sManufacturers[i]);
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
				//
				sSideHorizontal.setReadOnly(false);
				dOffset.setReadOnly(false);
				//
				sMillingType.setReadOnly(false);
				dTolerance.setReadOnly(false);
				showDialog("---");
	//			setOPMKey(sManufacturer);
				sOpmKey = sManufacturer;
			}
			
		// sOpmKey is set, enter Product
		// read the xml for this family
			if(bDebug)reportMessage("\n"+ scriptName() + " mapSetting.length() "+ mapSetting.length());
			
			// from the mapSetting get all the defined families
			if (mapSetting.length() > 0)
			{
//				Map mapManufacturers = mapSetting.getMap("Manufacturer[]");
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
//					if (mapManufacturerI.hasString("Name") && mapManufacturers.keyAt(i).makeLower() == "manufacturer")
					if (mapManufacturers.keyAt(i).makeLower() == "manufacturer")
					{
//						String sManufacturerName = mapManufacturerI.getString("Name");
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
//						if (mapFamilyJ.hasString("Name") && mapFamilies.keyAt(j).makeLower() == "family")
						if (mapFamilies.keyAt(j).makeLower() == "family")
						{
//							String sName = mapFamilyJ.getString("Name");
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
						sFamily.set(sFamilies[0]);
						sProduct = PropString(2, sProducts, sProductName, 0);
						sProduct.set("---");
						sProduct.setReadOnly(true);
						sNail = PropString(3, sNails, sNailName, 0);
						sNail.set("---");
						sNail.setReadOnly(true);
						//
						sSideHorizontal.setReadOnly(false);
						dOffset.setReadOnly(false);
						//
						sMillingType.setReadOnly(false);
						dTolerance.setReadOnly(false);
						showDialog("---");
	//					showDialog();
						
						if(bDebug)reportMessage("\n"+ scriptName() + " from dialog ");
						if(bDebug)reportMessage("\n"+ scriptName() + " sProduct "+sProduct);
					}
					else
					{ 
						// see if sTokens[1] is a valid product name as in sProducts from mapSetting
						int indexSTokens = sFamilies.find(sTokens[1]);
						sFamily = PropString(1, sFamilies, sFamilyName, 0);
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
//						if (mapFamilyJ.hasString("Name") && mapFamilies.keyAt(j).makeLower() == "family")
						if (mapFamilies.keyAt(j).makeLower() == "family")
						{
//							String sFamilyName = mapFamilyJ.getString("Name");
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
//							if (mapProductK.hasString("Name") && mapProducts.keyAt(k).makeLower() == "product")
							if (mapProducts.keyAt(k).makeLower() == "product")
							{
//								String sName = mapProductK.getString("Name");
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
							sProduct.set(sProducts[0]);
							sNail.setReadOnly(false);
							sNail = PropString(3, sNails, sNailName, 0);
							// HSB-7708: by default in dialog set the first nail
							sNail.set(sNails[0]);
							sMillingType.setReadOnly(false);
							//
							sSideHorizontal.setReadOnly(false);
							dOffset.setReadOnly(false);
							//
							sMillingType.setReadOnly(false);
							dTolerance.setReadOnly(false);
							showDialog("---");
	//						showDialog();
							if(bDebug)reportMessage("\n"+ scriptName() + " from dialog ");
							if(bDebug)reportMessage("\n"+ scriptName() + " sProduct "+sProduct);
						}
						else
						{ 
							// see if sTokens[1] is a valid product name as in sProducts from mapSetting
							int indexSTokens = sProducts.find(sTokens[2]);
							if (indexSTokens >- 1)
							{ 
								// find
				//				sProduct = PropString(1, sProducts, sProductName, indexSTokens);
								sProduct.set(sTokens[2]);
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
		}
		int iCount = 0;
		// insertion process of angle brackets
		String sPromptMale = T("|Select male beams or trusses|");
		String sPromptFemale = T("|Select female beams or trusses|");

		if (sPainterMale != sPainterDefault)
			sPromptMale = T("|Select male beams/trusses to be filtered out by the painter selection|");
		if (sPainterFemale != sPainterDefault)
			sPromptFemale = T("|Select female beams/trusses to be filtered out by the painter selection|");
		while (iCount < 100)
		{ 
			// prompt selection of male beams
		// prompt for beams
			Beam beamsMale[0];
			Entity entsMale[0];
			PrEntity ssMale(sPromptMale, Beam());
			ssMale.addAllowedClass(TrussEntity());
			if (ssMale.go())
			{
//				beamsMale.append(ssMale.beamSet());
				entsMale.append(ssMale.set());
			}
				
//			if (beamsMale.length() == 0)break;
			if (entsMale.length() == 0)break;
				
		// prompt selection of female beams
			Beam beamsFemale[0];
			Entity entsFemale[0];
			PrEntity ssFemale(sPromptFemale, Beam());
			ssFemale.addAllowedClass(TrussEntity());
			if (ssFemale.go())
			{
//				beamsFemale.append(ssFemale.beamSet());
				entsFemale.append(ssFemale.set());
			}
			
//			if (beamsFemale.length() == 0)break;
			if (entsFemale.length() == 0)break;
		
			
		// HSB-8881: apply the painter definition
			// from all selection filter only those belonging to the definition
			if(sPainterMale!=sPainterDefault)
			{ 
				PainterDefinition pDm(sPainterMale);
//				beamsMale = pDm.filterAcceptedEntities(beamsMale);
				entsMale = pDm.filterAcceptedEntities(entsMale);
			}
			
			if(sPainterFemale!=sPainterDefault)
			{ 
				PainterDefinition pDf(sPainterFemale);
//				beamsFemale = pDf.filterAcceptedEntities(beamsFemale);
				entsFemale = pDf.filterAcceptedEntities(entsFemale);
			}
			
		// remove those already in beamsMale
//			for (int i = beamsFemale.length() - 1; i >= 0; i--)
			for (int i = entsFemale.length() - 1; i >= 0; i--)
			{ 
//				if (beamsMale.find(beamsFemale[i]) >- 1)
				if (entsMale.find(entsFemale[i]) >- 1)
				{ 
					// remove if already included at male beam selection
//					beamsFemale.removeAt(i);
					entsFemale.removeAt(i);
				}
			}//next i
		// create TSL
			TslInst tslNew; Vector3d vecXTsl = _XU; Vector3d vecYTsl = _YU;
			GenBeam gbsTsl[0]; Entity entsTsl[2]; Point3d ptsTsl[0];
			int nProps[0]; double dProps[0]; String sProps[0];
			Map mapTsl;	
			
			//prompt point to define direction if one of beamsFemale is parallel to _ZU
//			int iPromptPoint = false;
//			for (int i=0;i<beamsFemale.length();i++) 
//			{ 
//				if (beamsMale[i].vecX().isParallelTo(_ZU))iPromptPoint = true;
//			}//next i
//			if (iPromptPoint)
//			{
//				// prompt for point input
//				Point3d pt2;
//				PrPoint ssP(TN("|Select point|"), beamsMale[0].ptCen());
//				if (ssP.go()==_kOk) 
//					pt2 = (ssP.value());
//			}
			// create a tsl instance for each valid male-female connection
//			for (int i = 0; i < beamsMale.length(); i++)
			for (int i = 0; i < entsMale.length(); i++)
			{ 
				Quader qdMale;
				Beam bmMale = (Beam)entsMale[i];
				TrussEntity trussMale = (TrussEntity)entsMale[i];
				if(bmMale.bIsValid())
				{ 
					// beam selected
					qdMale=Quader(bmMale.ptCen(), bmMale.vecX(), bmMale.vecY(), bmMale.vecZ(),
						bmMale.dL(), bmMale.dW(), bmMale.dH(), 0, 0, 0);
				}
				else if(trussMale.bIsValid())
				{ 
					CoordSys csTruss = trussMale.coordSys();
					Vector3d vecXt = csTruss.vecX();
					Vector3d vecYt = csTruss.vecY();
					Vector3d vecZt = csTruss.vecZ();
					Point3d ptOrgTruss = trussMale.ptOrg();
					String strDefinition = trussMale.definition();
					TrussDefinition trussDefinition(strDefinition);
					Beam beamsTruss[] = trussDefinition.beam();
					Body bdTruss;
					for (int i=0;i<beamsTruss.length();i++) 
					{ 
				//		beamsTruss[i].envelopeBody().vis(4);
						bdTruss.addPart(beamsTruss[i].envelopeBody());
					}//next i
					bdTruss.transformBy(csTruss);
					Point3d ptCenBd = bdTruss.ptCen();
					PlaneProfile ppX = bdTruss.shadowProfile(Plane(ptCenBd, vecXt));
					LineSeg segX = ppX.extentInDir(vecYt);
					Point3d ptCenX = segX.ptMid();
					Point3d ptCenTruss = ptCenX;
					PlaneProfile ppY = bdTruss.shadowProfile(Plane(ptCenBd, vecYt));
					LineSeg segY = ppY.extentInDir(vecXt);
					ptCenTruss += vecXt * vecXt.dotProduct(segY.ptMid() - ptCenTruss);
					double dLx = bdTruss.lengthInDirection(vecXt);
					double dLy = bdTruss.lengthInDirection(vecYt);
					double dLz = bdTruss.lengthInDirection(vecZt);
					qdMale=Quader(ptCenTruss, vecXt, vecYt, vecZt, dLx, dLy, dLz,0,0,0);
				}
//				Beam bmMale = beamsMale[i];
				Entity entMale = entsMale[i];
//				gbsTsl[0] = bmMale;
				entsTsl[0] = entMale;
//				Vector3d vxMale = bmMale.vecX();
				Vector3d vxMale = qdMale.vecX();
				// loop females
//				for (int j = 0; j < beamsFemale.length(); j++)
				for (int j = 0; j < entsFemale.length(); j++)
				{ 
//					Beam bmFemale = beamsFemale[j];
					Quader qdFemale;
					Beam bmFemale = (Beam) entsFemale[j];
					Entity entFemale = entsFemale[j];
					TrussEntity trussFemale = (TrussEntity)entsFemale[j];
					if(bmFemale.bIsValid())
					{ 
						// beam selected
						qdFemale=Quader(bmFemale.ptCen(), bmFemale.vecX(), bmFemale.vecY(), bmFemale.vecZ(),
							bmFemale.dL(), bmFemale.dW(), bmFemale.dH(), 0, 0, 0);
					}
					else if(trussFemale.bIsValid())
					{ 
						CoordSys csTruss = trussFemale.coordSys();
						Vector3d vecXt = csTruss.vecX();
						Vector3d vecYt = csTruss.vecY();
						Vector3d vecZt = csTruss.vecZ();
						Point3d ptOrgTruss = trussFemale.ptOrg();
						String strDefinition = trussFemale.definition();
						TrussDefinition trussDefinition(strDefinition);
						Beam beamsTruss[] = trussDefinition.beam();
						Body bdTruss;
						for (int i=0;i<beamsTruss.length();i++) 
						{ 
					//		beamsTruss[i].envelopeBody().vis(4);
							bdTruss.addPart(beamsTruss[i].envelopeBody());
						}//next i
						bdTruss.transformBy(csTruss);
						Point3d ptCenBd = bdTruss.ptCen();
						PlaneProfile ppX = bdTruss.shadowProfile(Plane(ptCenBd, vecXt));
						LineSeg segX = ppX.extentInDir(vecYt);
						Point3d ptCenX = segX.ptMid();
						Point3d ptCenTruss = ptCenX;
						PlaneProfile ppY = bdTruss.shadowProfile(Plane(ptCenBd, vecYt));
						LineSeg segY = ppY.extentInDir(vecXt);
						ptCenTruss += vecXt * vecXt.dotProduct(segY.ptMid() - ptCenTruss);
						double dLx = bdTruss.lengthInDirection(vecXt);
						double dLy = bdTruss.lengthInDirection(vecYt);
						double dLz = bdTruss.lengthInDirection(vecZt);
						qdFemale=Quader(ptCenTruss, vecXt, vecYt, vecZt, dLx, dLy, dLz,0,0,0);
					}
//					Vector3d vxFemale = bmFemale.vecX();
					Vector3d vxFemale = qdFemale.vecX();
					if (vxMale.isParallelTo(vxFemale))
					{
						// parallel, not allowed
						continue;
					}
//					LineBeamIntersect lbi(bmMale.ptCen(), vxMale, bmFemale);
//					Point3d ptI = lbi.pt1();
//					Point3d ptImin = bmFemale.ptCen();
//					Point3d ptImax = bmFemale.ptCen();
//					ptImin.transformBy(-vxFemale * bmFemale.solidLength() * .5);
//					ptImax.transformBy(vxFemale * bmFemale.solidLength() * .5);
//					double dInt = vxFemale.dotProduct(ptI - bmFemale.ptCen());
//					double dIntMin = vxFemale.dotProduct(ptImin - bmFemale.ptCen());
//					double dIntMax = vxFemale.dotProduct(ptImax - bmFemale.ptCen());
//					// intersection outside the female length
//					if (dInt <= dIntMin || dInt >= dIntMax)
//					{
//						continue;
//					}
//					// no contact can be found
//					if ( ! lbi.bHasContact())
//					{
//						// create TSL also if the vecX of male does not intersect the female
////						continue;
//					}

					Body bdFemale, bdMaleLong;
					bdFemale = Body(qdFemale);
					bdMaleLong=Body(qdMale.ptOrg(), 
						qdMale.vecX(), qdMale.vecY(),qdMale.vecZ(),
						U(10e4),(qdMale.dD(qdMale.vecY())+dEps), (qdMale.dD(qdMale.vecZ())+dEps),
						0, 0, 0);
					if ( ! bdMaleLong.hasIntersection(bdFemale))continue;
					
//					reportMessage("\n"+scriptName()+" "+T("|create tsl|"));
					
//					gbsTsl[1] = bmFemale;
					entsTsl[1] = entFemale;
					// properties
					sProps.setLength(0);
					sProps.append(sManufacturer);
					sProps.append(sFamily);
					sProps.append(sProduct);
					sProps.append(sNail);
					sProps.append(sSideHorizontal);
	//				sProps.append(sSideVertical);
					sProps.append(sMillingType);
					// HSB-8881
					sProps.append(sPainterMale);
					sProps.append(sPainterFemale);
					// 
					dProps.setLength(0);
					dProps.append(dOffset);
					dProps.append(dTolerance);
					// map for swaping legs
					// create TSL
					tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
				}//next j
			}//next i
		}
		// 
		eraseInstance();
		return;
	}
// end on insert	__________________//endregion

//Display dp1(2);
//dp1.textHeight(U(100));
//dp1.draw("text", _Pt0, _XW, _YW, 0, 0);
////_Pt0.vis(1);

//region when tsl is copied, it keeps the reference to the 2 beams it is attached to
	setKeepReferenceToGenBeamDuringCopy(_kAllBeams);
//End when tsl is copied, it keeps the reference to the 2 beams it is attached to//endregion 


//region Y axis multiplyer
	// initialize it
	double yAxisMultiplyer = 1;
	if ( ! _Map.hasDouble("yAxisMultiplyer"))
	{ 
		// if not found initiate with 1.0
		_Map.setDouble("yAxisMultiplyer", 1.0);
	}
	yAxisMultiplyer = _Map.getDouble("yAxisMultiplyer");
//	_Y0 *= yAxisMultiplyer;
//End Y axis multiplyer//endregion 
	
	
//region trigger to flip the _Y0
// Trigger flip _Y axis//region
	String sTriggerflipYaxis = T("|flip Y axis|");
	addRecalcTrigger(_kContext, sTriggerflipYaxis );
	if (_bOnRecalc && (_kExecuteKey==sTriggerflipYaxis || _kExecuteKey==sDoubleClick))
	{
		double yy = _Map.getDouble("yAxisMultiplyer");
		yy *= -1;
		_Map.setDouble("yAxisMultiplyer", yy);
		
		setExecutionLoops(2);
		return;
	}//endregion	
//End trigger to flip the _Y0//endregion 
	
//region rotate yz
	int iRotateYZ = 0;
	if ( ! _Map.hasInt("iRotateYZ"))
	{ 
		_Map.setInt("iRotateYZ", 0);
	}
	iRotateYZ = _Map.getInt("iRotateYZ");
//End rotate yz//endregion 

int iAlign = _Map.getInt("iAlign");
	
//region rotate yz on first time if not possible, if not possible again then delete
//	int iMode = _Map.getInt("iMode");
////	iMode = 0;
////	iMode = 1;
//	if (iMode == 0)
//	{ 
//		_Map.setInt("iMode", 1);
//	}
	
//	int iCount = _Map.getInt("iCount");
//	iCount++;
//	_Map.setInt("iCount", iCount);

	int iFound = _Map.getInt("iFound");
//End rotate yz on first time if not possible, if not possible again then delete//endregion 	
	
//region trigger to swap legs when asymetric
	int iSwapLegs = 0;
	if ( ! _Map.hasInt("iSwapLegs"))
	{ 
		// if not found initiate with 1
		_Map.setInt("iSwapLegs", 0);
	}
	iSwapLegs = _Map.getInt("iSwapLegs");
	
// Trigger swapLegs//region
	String sTriggerSwapLegs = T("|swap legs|");
	addRecalcTrigger(_kContext, sTriggerSwapLegs );
	if (_bOnRecalc && (_kExecuteKey == sTriggerSwapLegs ))
	{
		
		int ii = _Map.getInt("iSwapLegs");
		ii =! ii;
		_Map.setInt("iSwapLegs", ii);
		
		setExecutionLoops(2);
		return;
	}//endregion
//End trigger to swap legs when asymetric//endregion 
	
	
//region validation
//	if (_Beam.length() != 2)
//	{ 
//		reportMessage(TN("|2 beams needed|"));
//		eraseInstance();
//		return;
//	}

	if(_Entity.length()!=2)
	{ 
		reportMessage("\n"+scriptName()+" "+T("|2 entities of type beam or truss are needed|"));
		eraseInstance();
		return;
	}
//	return;
	Quader qd0, qd1;
	Beam bm0, bm1;
	TrussEntity truss0, truss1;
	bm0 = (Beam)_Entity[0];
	truss0 = (TrussEntity)_Entity[0];
	bm1 = (Beam)_Entity[1];
	truss1 = (TrussEntity)_Entity[1];
	if(bm0.bIsValid())
	{ 
		qd0=Quader(bm0.ptCen(),bm0.vecX(),bm0.vecY(),bm0.vecZ(),
			bm0.dL(), bm0.dD(bm0.vecY()), bm0.dD(bm0.vecZ()),
			0, 0, 0);
	}
	else if(truss0.bIsValid())
	{ 
		CoordSys csTruss = truss0.coordSys();
		Vector3d vecXt = csTruss.vecX();
		Vector3d vecYt = csTruss.vecY();
		Vector3d vecZt = csTruss.vecZ();
		Point3d ptOrgTruss = truss0.ptOrg();
		String strDefinition = truss0.definition();
		TrussDefinition trussDefinition(strDefinition);
		Beam beamsTruss[] = trussDefinition.beam();
		Body bdTruss;
		for (int i=0;i<beamsTruss.length();i++) 
		{ 
	//		beamsTruss[i].envelopeBody().vis(4);
			bdTruss.addPart(beamsTruss[i].envelopeBody());
		}//next i
		bdTruss.transformBy(csTruss);
		Point3d ptCenBd = bdTruss.ptCen();
		PlaneProfile ppX = bdTruss.shadowProfile(Plane(ptCenBd, vecXt));
		LineSeg segX = ppX.extentInDir(vecYt);
		Point3d ptCenX = segX.ptMid();
		Point3d ptCenTruss = ptCenX;
		PlaneProfile ppY = bdTruss.shadowProfile(Plane(ptCenBd, vecYt));
		LineSeg segY = ppY.extentInDir(vecXt);
		ptCenTruss += vecXt * vecXt.dotProduct(segY.ptMid() - ptCenTruss);
		double dLx = bdTruss.lengthInDirection(vecXt);
		double dLy = bdTruss.lengthInDirection(vecYt);
		double dLz = bdTruss.lengthInDirection(vecZt);
		qd0=Quader(ptCenTruss, vecXt, vecYt, vecZt, dLx, dLy, dLz,0,0,0);
	}
	if(bm1.bIsValid())
	{ 
		qd1=Quader(bm1.ptCen(),bm1.vecX(),bm1.vecY(),bm1.vecZ(),
			bm1.dL(), bm1.dD(bm1.vecY()), bm1.dD(bm1.vecZ()),
			0, 0, 0);
	}
	else if(truss1.bIsValid())
	{ 
		CoordSys csTruss = truss1.coordSys();
		Vector3d vecXt = csTruss.vecX();
		Vector3d vecYt = csTruss.vecY();
		Vector3d vecZt = csTruss.vecZ();
		Point3d ptOrgTruss = truss1.ptOrg();
		String strDefinition = truss1.definition();
		TrussDefinition trussDefinition(strDefinition);
		Beam beamsTruss[] = trussDefinition.beam();
		Body bdTruss;
		for (int i=0;i<beamsTruss.length();i++) 
		{ 
	//		beamsTruss[i].envelopeBody().vis(4);
			bdTruss.addPart(beamsTruss[i].envelopeBody());
		}//next i
		bdTruss.transformBy(csTruss);
		Point3d ptCenBd = bdTruss.ptCen();
		PlaneProfile ppX = bdTruss.shadowProfile(Plane(ptCenBd, vecXt));
		LineSeg segX = ppX.extentInDir(vecYt);
		Point3d ptCenX = segX.ptMid();
		Point3d ptCenTruss = ptCenX;
		PlaneProfile ppY = bdTruss.shadowProfile(Plane(ptCenBd, vecYt));
		LineSeg segY = ppY.extentInDir(vecXt);
		ptCenTruss += vecXt * vecXt.dotProduct(segY.ptMid() - ptCenTruss);
		double dLx = bdTruss.lengthInDirection(vecXt);
		double dLy = bdTruss.lengthInDirection(vecYt);
		double dLz = bdTruss.lengthInDirection(vecZt);
		qd1=Quader(ptCenTruss, vecXt, vecYt, vecZt, dLx, dLy, dLz,0,0,0);
	}
//	qd0.vis(1);
//	qd1.vis(3);
	Body bd0 = Body(qd0);
	Body bd1 = Body(qd1);
	Point3d ptCen0, ptCen1;
	ptCen0 = qd0.ptOrg();
	ptCen1 = qd1.ptOrg();
	Vector3d _vecX0, _vecY0, _vecZ0;
	Vector3d _vecX1, _vecY1, _vecZ1;
	_vecX0 = qd0.vecX();
	// vecX0 pointing toward connection
	if ((ptCen1 - ptCen0).dotProduct(_vecX0) < 0)_vecX0 *= -1;
	_vecZ0 = qd0.vecZ();
	if (_vecZ0.dotProduct(_ZU) < 0)_vecZ0 *= -1;
	_vecY0 = _vecZ0.crossProduct(_vecX0);
	
	int iZaxisAlign = sZaxisAligns.find(sZaxisAlign);
	if(iZaxisAlign>0)
	{ 
		Vector3d _vecZ0_ = _vecZ0;
		Vector3d _vecY0_ = _vecY0;
		if(iZaxisAlign==1)
		{ 
			// -Z
			_vecZ0 *= -1;
			_vecY0 *= -1;
		}
		else if(iZaxisAlign==2)
		{ 
			// Y
			_vecZ0 = _vecY0_;
			_vecY0 = -_vecZ0_;
		}
		else if(iZaxisAlign==3)
		{ 
			// -Y
			_vecZ0 = -_vecY0_;
			_vecY0 = _vecZ0_;
		}
	}
	// get the plane of connection
	PlaneProfile pp0(Plane(ptCen0, qd0.vecX()));
	PLine pl0;
	pl0.createRectangle(LineSeg(ptCen0-.5*qd0.vecY()*qd0.dD(qd0.vecY())-.5*qd0.vecZ()*qd0.dD(qd0.vecZ()),
	ptCen0+.5*qd0.vecY()*qd0.dD(qd0.vecY())+.5*qd0.vecZ()*qd0.dD(qd0.vecZ())),
		qd0.vecY(), qd0.vecZ());
	pp0.joinRing(pl0, _kAdd);
	Vector3d vecsPlane[] ={ qd1.vecY(), - qd1.vecY(), qd1.vecZ() ,- qd1.vecZ()};
	int iPlanesOpposite[] ={ 1, 0, 3, 2};
	double dWidths[]={ qd1.dD(vecsPlane[0]), qd1.dD(vecsPlane[1]),
			qd1.dD(vecsPlane[2]), qd1.dD(vecsPlane[3])};
	
	Plane plns[]={ Plane(ptCen1+vecsPlane[0]*.5*dWidths[0], vecsPlane[0]),
		Plane(ptCen1+vecsPlane[1]*.5*dWidths[1], vecsPlane[1]),
		Plane(ptCen1+vecsPlane[2]*.5*dWidths[2], vecsPlane[3]),
		Plane(ptCen1 + vecsPlane[3] * .5 * dWidths[3], vecsPlane[3])};
		
	PlaneProfile pps[] ={ PlaneProfile(plns[0]), PlaneProfile(plns[1]),
		PlaneProfile(plns[2]),PlaneProfile(plns[3])};
//	plns[0].vis(3);
	pps[0] = bd1.shadowProfile(plns[0]);
	pps[1] = bd1.shadowProfile(plns[1]);
	pps[2] = bd1.shadowProfile(plns[2]);
	pps[3] = bd1.shadowProfile(plns[3]);
//	pps[0].vis(5);
	// find the plane pf contact
	double dAlignmentDir = 0;// initialize
	int iPlaneConntact = -1;
	for (int ip=0;ip<vecsPlane.length();ip++) 
	{ 
		// 
		PlaneProfile pp0Intersect = pp0;
		pp0Intersect.shrink(-dEps);
		int iIntersect = pp0Intersect.intersectWith(pps[ip]);
		if ( ! iIntersect)continue;
		// from all possible intersections get the most aligned
		double dAlignmentDirI = vecsPlane[ip].dotProduct(-_vecX0);
		if(dAlignmentDirI>dAlignmentDir)
		{ 
			dAlignmentDir = dAlignmentDirI;
			iPlaneConntact = ip;
		}
	}//next ip
	
	if(iPlaneConntact<0)
	{ 
		reportMessage("\n"+scriptName()+" "+T("|the two entities can not be connected|"));
		eraseInstance();
		return;
	}
	
	// check if the male support the female i.e. female on tp of male (or male on top of female)
	// or the male intersects the female
	int iBeamsIntersect=true;
	{ 
		PlaneProfile pp0IntersectShrink = pp0;
		pp0IntersectShrink.shrink(dEps);
		PlaneProfile pp0IntersectExtend = pp0;
		pp0IntersectExtend.shrink(-dEps);
		int iIntersectShrink = pp0IntersectShrink.intersectWith(pps[iPlaneConntact]);
		int iIntersectExtend = pp0IntersectExtend.intersectWith(pps[iPlaneConntact]);
		if ( ! iIntersectShrink && iIntersectExtend)iBeamsIntersect = false;
	}
	
	Plane pnContact = plns[iPlaneConntact];
	_Pt0 = Line(ptCen0, qd0.vecX()).intersect(pnContact, 0);
	
	//
	_vecX1 = qd1.vecX();
	_vecZ1 = vecsPlane[iPlaneConntact];
	if (_vecX0.dotProduct(_vecZ1) < 0)_vecZ1 *= -1;
	_vecY1 = _vecZ1.crossProduct(_vecX1);
	// male beam
//	_Beam0.envelopeBody().vis(1);
	qd0.vis(1);
	// female beam
//	_Beam1.envelopeBody().vis(2);
	qd1.vis(3);
	_Pt0.vis(1);
	
	
	// corner points of _Beam0 at connection plane
//	_Pt1.vis(3);
//	_Pt2.vis(3);
//	_Pt3.vis(3);
//	_Pt4.vis(3);
	
//	ptCen0 = _Beam0.ptCen();
//	ptCen1 = _Beam1.ptCen();
//	// vectors at male beam
//	_X0.vis(ptCen0, 1);
//	_Y0.vis(ptCen0, 5);
//	_Z0.vis(ptCen0, 3);
//	// vectors at female beam
//	_X1.vis(ptCen1, 1);
//	_Y1.vis(ptCen1, 5);
//	_Z1.vis(ptCen1, 3);
//	setOPMKey(sManufacturer);
	// HSB-8922: set opmkey as the choosen family
	setOPMKey(sFamily);
	
	// change _Z0 and _Y0 so that _Y0 mos aligned with the _x1
//	if(abs(_Z0.dotProduct(_X1))>abs(_Y0.dotProduct(_X1)))
//	{ 
//		Vector3d vecTemp = _Y0;
//		_Y0 = _Z0;
//		_Z0 = vecTemp;
//	}
	
	// _Z0 and _Y1 are most aligned with the _ZU 
	// _Z1 is always normal to the contact plane of the T connection in the 
	// direction of the _X0 vector (pointing from male to female)
	
	// at the moment of insertion
	
//	if ( ! _X0.isPerpendicularTo(_X1))
//	{ 
//		reportMessage(TN("|only normal angle T connections are supported|"));
//		eraseInstance();
//		return;
//	}
//End validation//endregion 
	
	
//region stretch male beam to plane of contact with female beam
	if(bm0.bIsValid() && iBeamsIntersect)
	{ 
		Point3d ptCut = _Pt0;
//		Cut cut(ptCut, _Z1);
		Cut cut(ptCut, _vecZ1);
		bm0.addTool(cut, _kStretchOnToolChange);
	}
//End stretch male beam to plane of contact with female beam//endregion 
	
//region selected properties, side, milling
	// selected side
	int iSideHorizontalSelected = sSidesHorizontal.find(sSideHorizontal);
//	int isideVerticalSelected = sSidesVertical.find(sSideVertical);
	//	selected milling type
	int iSelectedMilling = sMillingTypes.find(sMillingType);
//End selected properties, side, milling//endregion 
	
//region geometric variables
	double dApart;
	double dBpart;
	double dCpart;
	double dTpart;
	// milling data
	int iMillingType = 0;
	String sMillingTypeXml = "none";
	double dToleranceXml = 0;
	// HSB-7708: add url of selected family of bracket
	String sURL;
//End geometric variables//endregion
	
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
	
// HSB-18969 catch invalid manufacturer
	if (mapManufacturer.length()<1)
	{
		String c;
		if (bm0.bIsValid())
			c += bm0.formatObject(T("|PosNum|: @(PosNum) @(Name:D)"));
		if (truss0.bIsValid())
			c += (c.length()>0?"\n":"")+truss0.formatObject(T("|Truss|: @(Definition:D)"));
		if (bm1.bIsValid())
			c += (c.length()>0?"\n":"")+bm1.formatObject(T("|PosNum|: @(PosNum) @(Name:D)"));		
		if (truss1.bIsValid())
			c += (c.length()>0?"\n":"")+truss1.formatObject(T("|Truss|: @(Definition:D)"));			
		
		
		reportNotice("\n\n***** " + _ThisInst.opmName() + " *****" + TN("|The selected manufacturer cannot be found in the loaded settings.| (") + sManufacturer + ")"+
		TN("|Tool will be deleted, please review connection|\n") + c  + "\n"+
		TN("|Please review the product definitions in the settings file.|\n") +
		sFullPath + "\n***********************************************************\n");
		
	//	eraseInstance();
	//	return;
	}
	
	
	
	
	
//End get map of manufacturer//endregion
	
//region if the family property changes, the Product property must be corrected
// in sProducts are kept all available products of the selected family
	// initialize array of all Products
	Map mapFamily;
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
		sFamily = PropString(1, sFamilies, sFamilyName, 0);
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
		sURL = mapFamilyI.getString("URL");
		mapFamily=mapFamilyI;
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
//			if (mapNails.keyAt(j).makeLower() == "nail")
			{
				String sName = mapNailJ.getString("Name");
//				String sName = mapNailJ.getMapName();
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
		reportMessage("\n"+scriptName()+" "+T("|Error|")+ 1001);
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
						
						k = "A"; if (m.hasDouble(k)) dApart = m.getDouble(k);
						k = "B"; if (m.hasDouble(k)) dBpart = m.getDouble(k);
						k = "C"; if (m.hasDouble(k)) dCpart = m.getDouble(k);
						k = "t"; if (m.hasDouble(k)) dTpart = m.getDouble(k);
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
	// HSB-7708: add url of selected family of bracket
	_ThisInst.setHyperlink(sURL);
//region part geometry
	// length leg1, leg2
//	double dApart = U(80);
//	double dBpart = U(120);
//	// width of leg
//	double dCpart = U(40);
//	// thickness of leg
//	double dTpart = U(2);
	
	double dA = dApart;
	double dB = dBpart;
	if (iSwapLegs)
	{ 
		dB = dApart;
		dA = dBpart;
	}
	double dC = dCpart;
	double dT = dTpart;
//End part geometry//endregion 
//return;
	int iMode = _Map.getInt("iMode");
	if (iMode == 0)
	{ 
		// for first time rotate if not aligned to _X1
		_Map.setInt("iMode", 1);
//		if(abs(_Z0.dotProduct(_X1))>abs(_Y0.dotProduct(_X1)))
		if(abs(_vecZ0.dotProduct(_vecX1))>abs(_vecY0.dotProduct(_vecX1)))
		{ 
			_Map.setInt("iRotateYZ", 1);
			_Map.setInt("iAlign", 1);
			setExecutionLoops(2);
			return;
		}
	}
//	return;
//region create 3d part
//	Vector3d vecY0 = _Y0 * yAxisMultiplyer;
	Vector3d vecY0 = _vecY0 * yAxisMultiplyer;
//	Vector3d vecZ0 = _Z0;
	Vector3d vecZ0 = _vecZ0;
	if (iRotateYZ)
	{ 
		vecY0 = _vecZ0 * yAxisMultiplyer;
		vecZ0 = - _vecY0;
	}
	vecY0.vis(_Pt0, 2);
	// HSB-13752
	int iNrParts = 0;
	Body bd;
	// do for each of the side options selected
	if(iBeamsIntersect)
	{ 
		// standart T case, 
		if (iSideHorizontalSelected == 0)
		{ 
			// left side is selected or both
			// to be inserted on the side of _Y0 
			// horizontal direction is with respect to _Y0
			// sectional values of male and female beam
	//		double dWidth0 = _Beam0.dD(vecY0);
			double dWidth0 = qd0.dD(vecY0);
	//		double dHeight0 = _Beam0.dD(vecZ0);
			double dHeight0 = qd0.dD(vecZ0);
			//
	//		double dWidth1 = _Beam0.dD(_Z1);
			double dWidth1 = qd0.dD(_vecZ1);
	//		double dHeight1 = _Beam1.dD(_Y1);
			double dHeight1 = qd1.dD(_vecY1);
			//
			Plane pnMale(ptCen0 + vecY0 * .5 * dWidth0, vecY0);
	//		Plane pnFemale(ptCen1 - _Z1 * .5 * dWidth1, _Z1);
			Plane pnFemale(ptCen1 - _vecZ1 * .5 * dWidth1, _vecZ1);
			Line ln = pnMale.intersect(pnFemale);
			vecY0.vis(ptCen0);
	//		pnMale.vis(3);
	//		ln.vis(1);
			// we consider upward vector aligned with _Z0
			Vector3d vecDir = ln.vecX();
			if (vecDir.dotProduct(vecZ0) < 0)
			{ 
				vecDir *= -1;
			}
	//		vecDir.vis(_Pt0);
	//		Vector3d vecMale = -_X0;
			Vector3d vecMale = -_vecX0;
			// see if 2 planes normal with each other
			// _Y0 is the vector of plane at male beam
			// _Z1 is the vector of plane at female beam
	//		if ( ! vecY0.isPerpendicularTo(_Z1))
	//		if ( ! vecY0.isPerpendicularTo(_vecZ1))
			if ( abs(vecY0.dotProduct(_vecZ1))>dEps)
			{ 
				// not perpendicular
	//			reportMessage(TN("|only normal angle T connections are supported|"));
				if (iFound == 0)
				{ 
					if(!iAlign)
					{ 
						if (iRotateYZ == 0)
						{ 
							// rotation never done
							// for first time try to rotate y0z0
							// rotation is only tried at firs time
							_Map.setInt("iRotateYZ", 1);
							setExecutionLoops(2);
							if (_kExecutionLoopCount == 0) setExecutionLoops(2);
							if (_kExecutionLoopCount == 1) setExecutionLoops(3);
							if (_kExecutionLoopCount == 2) setExecutionLoops(4);
							if (_kExecutionLoopCount == 3) setExecutionLoops(5);
							return;
						}
						else
						{ 
							// rotation was done and 
							// solution was never found
	//						reportMessage(TN("|only normal angle T connections are supported|"));
							// V2.13
							reportMessage("\n"+scriptName()+" "+T("|Part can not be fitted|"));
							eraseInstance();
							return;
						}
					}
					else
					{ 
						if(iRotateYZ == 1)
						{ 
							_Map.setInt("iRotateYZ", 0);
							setExecutionLoops(2);
							if (_kExecutionLoopCount == 0) setExecutionLoops(2);
							if (_kExecutionLoopCount == 1) setExecutionLoops(3);
							if (_kExecutionLoopCount == 2) setExecutionLoops(4);
							if (_kExecutionLoopCount == 3) setExecutionLoops(5);
							return;
						}
						else
						{ 
							// rotation was done and 
							// solution was never found
	//						reportMessage(TN("|only normal angle T connections are supported|"));
							// V2.13
							reportMessage("\n"+scriptName()+" "+T("|Part can not be fitted|"));
							eraseInstance();
							return;
						}
					}
				}
				// a solution used to exist, display message
	//			eraseInstance();
				Display dp(1);
				String sTextError = T("|not possible|");
				dp.draw(sTextError, _Pt0, _vecX0, vecY0, 0, 0, _kDeviceX );
				return;
			}
	//		if ( ! vecMale.isParallelTo(_vecZ1))
			if ( abs(abs(vecMale.dotProduct(_vecZ1))-1)>dEps)
			{ 
				// not parallel to _X0
				// make it like _Z1 (normal with the plane of contact)
				vecMale = -_vecZ1;
			}
			
			Vector3d vecFemale = vecMale.crossProduct(vecDir);
			vecFemale.normalize();
			if (vecFemale.dotProduct(vecY0) < 0)
			{ 
				vecFemale *= -1;
			}
			// point where the bracket will be attached
			Point3d ptPart = pnMale.closestPointTo(_Pt0);
			//
			vecDir.vis(ptPart);
			vecMale.vis(ptPart);
			vecFemale.vis(ptPart);
			
			// check if the part touches female beam and male beam
			// it will be accepted that the part only need to touch the female and male beam
			// _Pt0 must be within the length of female beam, It is always within the range of male beam because
			// male beam is streched at the female beam
			
	//		Point3d ptFemale1 = ptCen1 - .5 * _vecX1 * _Beam1.solidLength();
			Point3d ptFemale1 = ptCen1 - .5 * _vecX1 * qd1.dD(qd1.vecX());
			ptFemale1.vis(3);
	//		Point3d ptFemale2 = ptCen1 + .5 * _vecX1 * _Beam1.solidLength();
			Point3d ptFemale2 = ptCen1 + .5 * _vecX1 * qd1.dD(qd1.vecX());
			ptFemale2.vis(3);
			ptPart.vis(4);
			
			// check ptpart is within the planeProfile of the female beam
			Plane pnMaleCut(ptPart + vecMale * dEps, vecMale);
			Plane pnFemaleCut(ptPart - vecMale * dEps, vecMale);
			PlaneProfile ppMaleCut = bd0.getSlice(pnMaleCut);
			PlaneProfile ppFemaleCut = bd1.getSlice(pnFemaleCut);
			ppFemaleCut.intersectWith(ppMaleCut);
			PlaneProfile ppIntersect = ppFemaleCut;
			ppIntersect.vis(3);
	//		ppIntersect.shrink(-.5 * dC);
			// get extents of profile
			LineSeg segIntersect = ppIntersect.extentInDir(vecDir);
			Point3d ptMin = segIntersect.ptStart();
			Point3d ptMax = segIntersect.ptEnd();
			if (ptMin.dotProduct(vecDir) > ptMax.dotProduct(vecDir))
			{ 
				ptMin = segIntersect.ptEnd();
				ptMax = segIntersect.ptStart();
			}
			ptMin.vis(4);
			ptMax.vis(4);
			
			// segment considering extension left and right with .5*dC
			LineSeg segIntersectDc(ptMin - .5 * dC * vecDir, ptMax + .5 * dC * vecDir);
			PLine pl;
			pl.createRectangle(segIntersectDc, vecDir, vecFemale);
			PlaneProfile ppIntersectDc(pl);
			ptMin = segIntersectDc.ptStart();
			ptMax = segIntersectDc.ptEnd();
			if (ptMin.dotProduct(vecDir) > ptMax.dotProduct(vecDir))
			{ 
				ptMin = segIntersectDc.ptEnd();
				ptMax = segIntersectDc.ptStart();
			}
			
			double dOffsetMax = (ptMax - ptPart).dotProduct(vecDir);
			double dOffsetMin = (ptMin - ptPart).dotProduct(vecDir);
			double dOffsetCalc = dOffset;
			
	//		if (dOffset > dOffsetMax)
	//		{ 
	//			dOffset.set(dOffsetMax);
	//		}
	//		if (dOffset < dOffsetMin)
	//		{ 
	//			dOffset.set(dOffsetMin);
	//		}
			
			if (dOffsetCalc > dOffsetMax)
			{ 
				dOffsetCalc=dOffsetMax;
			}
			if (dOffsetCalc < dOffsetMin)
			{ 
				dOffsetCalc=dOffsetMin;
			}
	//		ptPart += dOffset * vecDir;
			ptPart += dOffsetCalc * vecDir;
			
			// remove extension by .5*dC
	//		ppIntersect.shrink(-.5 * dC);
			ppIntersectDc.shrink(-dEps);
			// add a tolerance
	//		ppIntersect.shrink(-dEps);
			
			PLine plPart(vecMale);
			PlaneProfile ppPart();
			{ 
				Point3d pt1 = ptPart - vecDir * .5 * dC;
				Point3d pt2 = ptPart + vecDir * .5 * dC + vecFemale * dB;
				LineSeg ls(pt1, pt2);
				plPart.createRectangle(ls, vecFemale, vecDir);
	//			plPart.vis(1);
			}
	//		ppPart.joinRing(plPart, _kAdd);
			ppPart = PlaneProfile(plPart);
	//		ppPart.vis(1);
			PlaneProfile ppFemale = bd1.shadowProfile(Plane(_Pt0, vecMale));
			PlaneProfile ppSubtract = ppPart;
			ppSubtract.subtractProfile(ppFemale);
			
	//		if (ppIntersectDc.pointInProfile(ptPart) != _kPointInProfile)
			if (ppSubtract.area() > dEps)
			{ 
				// point outside the profile, part can not be inserted
	//			reportMessage(TN("|part can not be inserted|"));
				if (iFound == 0)
				{ 
					if (yAxisMultiplyer == 1)
					{ 
						// rotation never done
						// for first time try to rotate y0z0
						// rotation is only tried at firs time
						_Map.setDouble("yAxisMultiplyer", - 1);
						setExecutionLoops(2);
						if (_kExecutionLoopCount == 0) setExecutionLoops(2);
						if (_kExecutionLoopCount == 1) setExecutionLoops(3);
						if (_kExecutionLoopCount == 2) setExecutionLoops(4);
						if (_kExecutionLoopCount == 3) setExecutionLoops(5);
						return;
					}
					else
					{ 
						if(!iAlign)
						{ 
							// try rotationg yz
							if (iRotateYZ == 0)
							{
								_Map.setInt("iRotateYZ", 1);
								// set the y0 at initial position
								_Map.setDouble("yAxisMultiplyer", 1);
								setExecutionLoops(2);
								if (_kExecutionLoopCount == 0) setExecutionLoops(2);
								if (_kExecutionLoopCount == 1) setExecutionLoops(3);
								if (_kExecutionLoopCount == 2) setExecutionLoops(4);
								if (_kExecutionLoopCount == 3) setExecutionLoops(5);
								return;
							}
							else
							{ 
								// rotation was done and flipping was done
								// solution was never found
	//							reportMessage(TN("|only normal angle T connections are supported|"));
								// V2.13
								reportMessage("\n"+scriptName()+" "+T("|Part can not be fitted|"));
								eraseInstance();
								return;
							}
						}
						else
						{ 
							if(iRotateYZ == 1)
							{ 
								_Map.setInt("iRotateYZ", 0);
								_Map.setDouble("yAxisMultiplyer", 1);
								setExecutionLoops(2);
								if (_kExecutionLoopCount == 0) setExecutionLoops(2);
								if (_kExecutionLoopCount == 1) setExecutionLoops(3);
								if (_kExecutionLoopCount == 2) setExecutionLoops(4);
								if (_kExecutionLoopCount == 3) setExecutionLoops(5);
								return;
							}
							else
							{ 
								// rotation was done and 
								// solution was never found
	//							reportMessage(TN("|only normal angle T connections are supported|"));
								// V2.13
								reportMessage("\n"+scriptName()+" "+T("|Part can not be fitted|"));
								eraseInstance();
								return;
							}
						}
					}
				}
				Display dp(1);
				String sTextError = T("|not possible|");
				dp.draw(sTextError, _Pt0, _vecX0, vecY0, 0, 0, _kDeviceX );
	//			eraseInstance();
				return;
			}
			
			// solution was found set 
			if (iFound == 0)
			{ 
				_Map.setInt("iFound", 1);
			}
			if(dOffsetCalc!=dOffset)
				dOffset.set(dOffsetCalc);
			// create part
			iNrParts++;
			// at male 
			Body bd0(ptPart, vecMale, vecDir, vecFemale,
							dA, dC, dT, 1, 0, 1 );
			// at female
			Body bd1(ptPart, vecFemale, vecDir, vecMale,
							dB, dC, dT, 1, 0, 1 );
			// milling
			if (iSelectedMilling == 1 )
			{ 
				// male is selected
				bd0.transformBy(-vecFemale * (dT + dTolerance));
				bd1.transformBy(-vecFemale * (dT + dTolerance));
				// beamcut
				Point3d ptBeamCut = ptPart;//-vecFemale*(dT+dTolerance);
				
	//			BeamCut bc0(ptBeamCut, vecMale, vecDir, vecFemale,
	//						dA+(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
				// hause
				ptBeamCut.vis(3);
				House hs0(ptBeamCut, vecMale, vecDir, -vecFemale,
							dA+(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
				hs0.setRoundType(_kReliefSmall);
	//			hs0.setEndType(_kFemaleSide);
	//			hs0.cuttingBody().vis(2);
				// hause
	//			bc0.cuttingBody().vis(5);
				if(bm0.bIsValid())
					bm0.addTool(hs0);
			}
			if(iSelectedMilling == 2)
			{ 
				// female is selected
				bd0.transformBy(-vecMale * (dT + dTolerance));
				bd1.transformBy(-vecMale * (dT + dTolerance));
				// beamcut
				Point3d ptBeamCut = ptPart;//-vecMale*(dT+dTolerance);
				
	//			BeamCut bc1(ptBeamCut, vecFemale, vecDir, vecMale,
	//						dB+(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
							
				House hs1(ptBeamCut, vecFemale, vecDir, -vecMale,
							dB+(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
				hs1.setRoundType(_kReliefSmall);
				ptBeamCut.vis(6);
				hs1.cuttingBody().vis(2);
	//			bc1.cuttingBody().vis(5);
				if(bm1.bIsValid())
					bm1.addTool(hs1);
			}
			if (iSelectedMilling == 3)
			{ 
				// the common cut
				Point3d ptBeamCut = ptPart - (vecMale) * (dT + dTolerance);
				
				
				House hs010(ptBeamCut, vecMale, vecDir, -vecFemale,
							dA + (dT + dTolerance), dC, (dT + dTolerance), 1, 0, 1 );
				hs010.setRoundType(_kReliefSmall);
				
	//			hs010.cuttingBody().vis(2);
	//			BeamCut bc01(ptBeamCut, vecFemale, vecDir, vecMale,
	//						(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
	//						
				if(bm0.bIsValid())
					bm0.addTool(hs010);
				
				ptBeamCut = ptPart - (vecFemale) * (dT + dTolerance);
				House hs011(ptBeamCut, vecFemale, vecDir, -vecMale,
							dB + (dT + dTolerance), dC, (dT + dTolerance), 1, 0, 1 );
				hs011.setRoundType(_kReliefSmall);
				
	//			hs011.cuttingBody().vis(2);
				if(bm1.bIsValid())
					bm1.addTool(hs011);
				// displacement
				bd0.transformBy(-vecFemale * (dT + dTolerance));
				bd1.transformBy(-vecFemale * (dT + dTolerance));
				bd0.transformBy(-vecMale * (dT + dTolerance));
				bd1.transformBy(-vecMale * (dT + dTolerance));
				
			}
			bd0.vis(2);
			bd1.vis(2);
			bd.addPart(bd0);
			bd.addPart(bd1);
		}
		if (iSideHorizontalSelected == 1)
		{ 
			// right is selected or both
			// sectional values of male and female beam
			double dWidth0 = qd0.dD(vecY0);
			double dHeight0 = qd0.dD(vecZ0);
			//
			double dWidth1 = qd1.dD(_vecZ1);
			double dHeight1 = qd1.dD(_vecY1);
			//
			Plane pnMale(ptCen0 - vecY0 * .5 * dWidth0, vecY0);
			Plane pnFemale(ptCen1 - _vecZ1 * .5 * dWidth1, _vecZ1);
			Line ln = pnMale.intersect(pnFemale);
			
			// we consider upward vector aligned with _Z0
			Vector3d vecDir = ln.vecX();
			if (vecDir.dotProduct(vecZ0) < 0)
			{ 
				vecDir *= -1;
			}
			
			Vector3d vecMale = -_vecX0;
			// see if 2 planes normal with each other
			// _Y0 is the vector of plane at male beam
			// _Z1 is the vector of plane at female beam
			
	//		if ( ! vecY0.isPerpendicularTo(_vecZ1))
			if ( abs(vecY0.dotProduct(_vecZ1))>dEps)
			{ 
				// not perpendicular
	//			reportMessage(TN("|only normal angle T connections are supported|"));
				if (iFound == 0)
				{ 
					if(!iAlign)
					{ 
						if (iRotateYZ == 0)
						{ 
							// rotation never done
							// for first time try to rotate y0z0
							// rotation is only tried at firs time
							_Map.setInt("iRotateYZ", 1);
							setExecutionLoops(2);
							if (_kExecutionLoopCount == 0) setExecutionLoops(2);
							if (_kExecutionLoopCount == 1) setExecutionLoops(3);
							if (_kExecutionLoopCount == 2) setExecutionLoops(4);
							if (_kExecutionLoopCount == 3) setExecutionLoops(5);
							return;
						}
						else
						{ 
							// rotation was done and 
							// solution was never found
	//						reportMessage(TN("|only normal angle T connections are supported|"));
							// V2.13
							reportMessage("\n"+scriptName()+" "+T("|Part can not be fitted|"));
							eraseInstance();
							return;
						}
					}
					else
					{ 
						if(iRotateYZ == 1)
						{ 
							_Map.setInt("iRotateYZ", 0);
							setExecutionLoops(2);
							if (_kExecutionLoopCount == 0) setExecutionLoops(2);
							if (_kExecutionLoopCount == 1) setExecutionLoops(3);
							if (_kExecutionLoopCount == 2) setExecutionLoops(4);
							if (_kExecutionLoopCount == 3) setExecutionLoops(5);
							return;
						}
						else
						{ 
							// rotation was done and 
							// solution was never found
	//						reportMessage(TN("|only normal angle T connections are supported|"));
							// V2.13
							reportMessage("\n"+scriptName()+" "+T("|Part can not be fitted|"));
							eraseInstance();
							return;
						}
					}
				}
				
				
				// a solution used to exist, display message
	//			eraseInstance();
				Display dp(1);
				String sTextError = T("|not possible|");
				dp.draw(sTextError, _Pt0, _vecX0, vecY0, 0, 0, _kDeviceX );
				return;
			}
	//		if ( ! vecMale.isParallelTo(_vecZ1))
			if ( abs(abs(vecMale.dotProduct(_vecZ1))-1)>dEps)
			{ 
				// not parallel to _X0
				// make it like _Z1 (normal with the plane of contact)
				vecMale = -_vecZ1;
			}
			Vector3d vecFemale = vecMale.crossProduct(vecDir);
			vecFemale.normalize();
			if (vecFemale.dotProduct(vecY0) > 0)
			{ 
				vecFemale *= -1;
			}
			
			Point3d ptPart = pnMale.closestPointTo(_Pt0);
			//
			vecDir.vis(ptPart);
			vecMale.vis(ptPart);
			vecFemale.vis(ptPart);
			// check if the part touches female beam and male beam
			// it will be accepted that the part only need to touch the female and male beam
			// _Pt0 must be within the length of female beam, It is always within the range of male beam because
			// male beam is streched at the female beam
	//		Point3d ptFemale1 = ptCen1 - .5 * _X1 * _Beam1.solidLength();
			Point3d ptFemale1 = ptCen1 - .5 * _vecX1 * qd1.dD(qd1.vecX());
	//		Point3d ptFemale2 = ptCen1 + .5 * _X1 * _Beam1.solidLength();
			Point3d ptFemale2 = ptCen1 + .5 * _vecX1 * qd1.dD(qd1.vecX());
			ptFemale1.vis(1);
			ptFemale2.vis(3);
			
			// check ptpart is within the planeProfile of the female beam
			Plane pnMaleCut(ptPart + vecMale * dEps, vecMale);
			Plane pnFemaleCut(ptPart - vecMale * dEps, vecMale);
			PlaneProfile ppMaleCut = bd0.getSlice(pnMaleCut);
			PlaneProfile ppFemaleCut = bd1.getSlice(pnFemaleCut);
			ppFemaleCut.intersectWith(ppMaleCut);
			PlaneProfile ppIntersect = ppFemaleCut;
			ppIntersect.vis(3);
	//		ppIntersect.shrink(-.5 * dC);
			// get extents of profile
			LineSeg segIntersect = ppIntersect.extentInDir(vecDir);
			Point3d ptMin = segIntersect.ptStart();
			Point3d ptMax = segIntersect.ptEnd();
			if (ptMin.dotProduct(vecDir) > ptMax.dotProduct(vecDir))
			{ 
				ptMin = segIntersect.ptEnd();
				ptMax = segIntersect.ptStart();
			}
	//		ptMin.vis(4);
	//		ptMax.vis(4);
			
			// segment considering extension left and right with .5*dC
			LineSeg segIntersectDc(ptMin - .5 * dC * vecDir, ptMax + .5 * dC * vecDir);
			PLine pl;
			pl.createRectangle(segIntersectDc, vecDir, vecFemale);
			PlaneProfile ppIntersectDc(pl);
			ptMin = segIntersectDc.ptStart();
			ptMax = segIntersectDc.ptEnd();
			if (ptMin.dotProduct(vecDir) > ptMax.dotProduct(vecDir))
			{ 
				ptMin = segIntersectDc.ptEnd();
				ptMax = segIntersectDc.ptStart();
			}
			
			double dOffsetMax = (ptMax - ptPart).dotProduct(vecDir);
			double dOffsetMin = (ptMin - ptPart).dotProduct(vecDir);
			
	//		if (dOffset > dOffsetMax)
	//		{ 
	//			dOffset.set(dOffsetMax);
	//		}
	//		if (dOffset < dOffsetMin)
	//		{ 
	//			dOffset.set(dOffsetMin);
	//		}
			double dOffsetCalc = dOffset;
			if (dOffsetCalc > dOffsetMax)
			{ 
				dOffsetCalc=dOffsetMax;
			}
			if (dOffsetCalc < dOffsetMin)
			{ 
				dOffsetCalc=dOffsetMin;
			}
	//		ptPart += dOffset * vecDir;
			ptPart += dOffsetCalc * vecDir;
			
			// remove extension by .5*dC
	//		ppIntersect.shrink(.5 * dC);
			// add a tolerance
	//		ppIntersect.shrink(-dEps);
			ppIntersectDc.shrink(-dEps);
	//		ppIntersectDc.vis(3);
	
			PLine plPart(vecMale);
			PlaneProfile ppPart;
			{ 
				Point3d pt1 = ptPart - vecDir * .5 * dC;
				Point3d pt2 = ptPart + vecDir * .5 * dC + vecFemale * dB;
				LineSeg ls(pt1, pt2);
				plPart.createRectangle(ls, vecFemale, vecDir);
			}
	//		ppPart.joinRing(plPart, _kAdd);
			ppPart = PlaneProfile(plPart);
			ppPart.vis(1);
			PlaneProfile ppFemale = bd1.shadowProfile(Plane(_Pt0, vecMale));
			PlaneProfile ppSubtract = ppPart;
			ppSubtract.subtractProfile(ppFemale);
			
	//		if (ppIntersectDc.pointInProfile(ptPart) != _kPointInProfile)
			if (ppSubtract.area() > dEps)
			{ 
				// point outside the profile, part can not be inserted
	//			reportMessage(TN("|part can not be inserted|"));
				if (iFound == 0)
				{ 
					if (yAxisMultiplyer == 1)
					{ 
						// rotation never done
						// for first time try to rotate y0z0
						// rotation is only tried at firs time
						_Map.setDouble("yAxisMultiplyer", -1);
						setExecutionLoops(2);
						if (_kExecutionLoopCount == 0) setExecutionLoops(2);
						if (_kExecutionLoopCount == 1) setExecutionLoops(3);
						if (_kExecutionLoopCount == 2) setExecutionLoops(4);
						if (_kExecutionLoopCount == 3) setExecutionLoops(5);
						return;
					}
					else
					{ 
						// try rotationg yz
						if(!iAlign)
						{ 
							// try rotationg yz
							if (iRotateYZ == 0)
							{
								_Map.setInt("iRotateYZ", 1);
								// set the y0 at initial position
								_Map.setDouble("yAxisMultiplyer", 1);
								setExecutionLoops(2);
								if (_kExecutionLoopCount == 0) setExecutionLoops(2);
								if (_kExecutionLoopCount == 1) setExecutionLoops(3);
								if (_kExecutionLoopCount == 2) setExecutionLoops(4);
								if (_kExecutionLoopCount == 3) setExecutionLoops(5);
								return;
							}
							else
							{ 
								// rotation was done and flipping was done
								// solution was never found
	//							reportMessage(TN("|only normal angle T connections are supported|"));
								// V2.13
								reportMessage("\n"+scriptName()+" "+T("|Part can not be fitted|"));
								eraseInstance();
								return;
							}
						}
						else
						{ 
							if(iRotateYZ == 1)
							{ 
								_Map.setInt("iRotateYZ", 0);
								_Map.setDouble("yAxisMultiplyer", 1);
								setExecutionLoops(2);
								if (_kExecutionLoopCount == 0) setExecutionLoops(2);
								if (_kExecutionLoopCount == 1) setExecutionLoops(3);
								if (_kExecutionLoopCount == 2) setExecutionLoops(4);
								if (_kExecutionLoopCount == 3) setExecutionLoops(5);
								return;
							}
							else
							{ 
								// rotation was done and 
								// solution was never found
	//							reportMessage(TN("|only normal angle T connections are supported|"));
								// V2.13
								reportMessage("\n"+scriptName()+" "+T("|Part can not be fitted|"));
								eraseInstance();
								return;
							}
						}
					}
				}
				Display dp(1);
				String sTextError = T("|not possible|");
				dp.draw(sTextError, _Pt0, _vecX0, vecY0, 0, 0, _kDeviceX );
	//			eraseInstance();
				return;
			}
			// solution was found set 
			if (iFound == 0)
			{ 
				_Map.setInt("iFound", 1);
			}
			if(dOffsetCalc!=dOffset)
				dOffset.set(dOffsetCalc);
			// create part
			iNrParts++;
			// at male 
			Body bd0(ptPart, vecMale, vecDir, vecFemale,
							dA, dC, dT, 1, 0, 1 );
			// at female
			Body bd1(ptPart, vecFemale, vecDir, vecMale,
							dB, dC, dT, 1, 0, 1 );
			// milling
			if (iSelectedMilling == 1)
			{ 
				// male is selected
				bd0.transformBy(-vecFemale * (dT + dTolerance));
				bd1.transformBy(-vecFemale * (dT + dTolerance));
				// beamcut
				Point3d ptBeamCut = ptPart;//-vecFemale*(dT+dTolerance);
				House hs0(ptBeamCut, vecMale, vecDir, -vecFemale,
							dA+(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
				hs0.setRoundType(_kReliefSmall);
				
	//			BeamCut bc0(ptBeamCut, vecMale, vecDir, vecFemale,
	//						dA+(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
	//			bc0.cuttingBody().vis(5);
				if(bm0.bIsValid())
					bm0.addTool(hs0);
			}
			if(iSelectedMilling == 2)
			{ 
				// female is selected
				bd0.transformBy(-vecMale * (dT + dTolerance));
				bd1.transformBy(-vecMale * (dT + dTolerance));
				// beamcut
				Point3d ptBeamCut = ptPart;//-vecMale*(dT+dTolerance);
				House hs1(ptBeamCut, vecFemale, vecDir, -vecMale,
							dB+(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
				hs1.setRoundType(_kReliefSmall);
	//			BeamCut bc1(ptBeamCut, vecFemale, vecDir, vecMale,
	//						dB+(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
	//			bc1.cuttingBody().vis(5);
	//			_Beam1.addTool(hs1);
				if(bm1.bIsValid())
					bm1.addTool(hs1);
	//			else if(truss1.bIsValid())
	//				truss1.addTool(hs1);
			}
			if (iSelectedMilling == 3)
			{ 
				// the common cut
				Point3d ptBeamCut = ptPart - (vecMale) * (dT + dTolerance);
	//			BeamCut bc01(ptBeamCut, vecFemale, vecDir, vecMale,
	//						(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
				ptPart.vis(5);
				House hs010(ptBeamCut, vecMale, vecDir, -vecFemale,
							dA+(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
				hs010.setRoundType(_kReliefSmall);
				hs010.cuttingBody().vis(3);
				if(bm0.bIsValid())
					bm0.addTool(hs010);
				
				ptBeamCut = ptPart - (vecFemale) * (dT + dTolerance);
				House hs011(ptBeamCut, vecFemale, vecDir, -vecMale,
							dB+(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
				hs011.setRoundType(_kReliefSmall);
				
	//			_Beam1.addTool(hs011);
				if(bm1.bIsValid())
					bm1.addTool(hs011);
				// displacement
				bd0.transformBy(-vecFemale * (dT + dTolerance));
				bd1.transformBy(-vecFemale * (dT + dTolerance));
				bd0.transformBy(-vecMale * (dT + dTolerance));
				bd1.transformBy(-vecMale * (dT + dTolerance));
			}
			
			bd0.vis(2);
			bd1.vis(2);
			
			bd.addPart(bd0);
			bd.addPart(bd1);
		}
		if (iSideHorizontalSelected == 2)
		{ 
			// variable to track current calculation
			int iFoundCurrent = false;
			// left side
			{ 
				// sectional values of male and female beam
				double dWidth0 = qd0.dD(vecY0);
				double dHeight0 = qd0.dD(vecZ0);
				//
				double dWidth1 = qd1.dD(_vecZ1);
				double dHeight1 = qd1.dD(_vecY1);
				//
				Plane pnMale(ptCen0 + vecY0 * .5 * dWidth0, vecY0);
				Plane pnFemale(ptCen1 - _vecZ1 * .5 * dWidth1, _vecZ1);
				Line ln = pnMale.intersect(pnFemale);
				
				// we consider upward vector aligned with _Z0
				Vector3d vecDir = ln.vecX();
				if (vecDir.dotProduct(vecZ0) < 0)
				{ 
					vecDir *= -1;
				}
		//		vecDir.vis(_Pt0);
				Vector3d vecMale = -_vecX0;
				// see if 2 planes normal with each other
				// _Y0 is the vector of plane at male beam
				// _Z1 is the vector of plane at female beam
				
	//			if ( ! vecY0.isPerpendicularTo(_vecZ1))
				if ( abs(vecY0.dotProduct(_vecZ1))>dEps)
				{ 
					// not perpendicular
					reportMessage("\n"+scriptName()+" "+T("|only normal angle T connections are supported|"));
					
	//				Display dp(1);
	//				String sTextError = T("|not possible|");
	//				dp.draw(sTextError, _Pt0, _X0, vecY0, 0, 0, _kDeviceX );
	//				return;
				}
				else
				{ 
					// can be possible
	//				if ( ! vecMale.isParallelTo(_vecZ1))
					if ( abs(abs(vecMale.dotProduct(_vecZ1))-1)>dEps)
					{ 
						// not parallel to _X0
						// make it like _Z1 (normal with the plane of contact)
						vecMale = -_vecZ1;
					}
					
					Vector3d vecFemale = vecMale.crossProduct(vecDir);
					vecFemale.normalize();
					if (vecFemale.dotProduct(vecY0) < 0)
					{ 
						vecFemale *= -1;
					}
					// point where the bracket will be attached
					Point3d ptPart = pnMale.closestPointTo(_Pt0);
					
					// move the ptPart by the offset value
					// maximal offset that can be moved
					
					vecDir.vis(ptPart);
					vecMale.vis(ptPart);
					vecFemale.vis(ptPart);
					
					// check if the part touches female beam and male beam
					// it will be accepted that the part only need to touch the female and male beam
					// _Pt0 must be within the length of female beam, It is always within the range of male beam because
					// male beam is streched at the female beam
					
	//				Point3d ptFemale1 = ptCen1 - .5 * _X1 * _Beam1.solidLength();
					Point3d ptFemale1 = ptCen1 - .5 * _vecX1 * qd1.dD(qd1.vecX());
	//				Point3d ptFemale2 = ptCen1 + .5 * _X1 * _Beam1.solidLength();
					Point3d ptFemale2 = ptCen1 + .5 * _vecX1 * qd1.dD(qd1.vecX());
					
					// check ptpart is within the planeProfile of the female beam
					Plane pnMaleCut(ptPart + vecMale * dEps, vecMale);
					Plane pnFemaleCut(ptPart - vecMale * dEps, vecMale);
	//				PlaneProfile ppMaleCut = _Beam0.envelopeBody().getSlice(pnMaleCut);
					PlaneProfile ppMaleCut = bd0.getSlice(pnMaleCut);
	//				PlaneProfile ppFemaleCut = _Beam1.envelopeBody().getSlice(pnFemaleCut);
					PlaneProfile ppFemaleCut = bd1.getSlice(pnFemaleCut);
					ppFemaleCut.intersectWith(ppMaleCut);
					PlaneProfile ppIntersect = ppFemaleCut;
					ppIntersect.vis(3);
	//				ppIntersect.shrink(-.5 * dC);
					// get extents of profile
					LineSeg segIntersect = ppIntersect.extentInDir(vecDir);
					Point3d ptMin = segIntersect.ptStart();
					Point3d ptMax = segIntersect.ptEnd();
					if (ptMin.dotProduct(vecDir) > ptMax.dotProduct(vecDir))
					{ 
						ptMin = segIntersect.ptEnd();
						ptMax = segIntersect.ptStart();
					}
					
					
					// segment considering extension left and right with .5*dC
					LineSeg segIntersectDc(ptMin - .5 * dC * vecDir, ptMax + .5 * dC * vecDir);
					PLine pl;
					pl.createRectangle(segIntersectDc, vecDir, vecFemale);
					PlaneProfile ppIntersectDc(pl);
					ptMin = segIntersectDc.ptStart();
					ptMax = segIntersectDc.ptEnd();
					if (ptMin.dotProduct(vecDir) > ptMax.dotProduct(vecDir))
					{ 
						ptMin = segIntersectDc.ptEnd();
						ptMax = segIntersectDc.ptStart();
					}
					ptMin.vis(4);
					ptMax.vis(4);
					
					double dOffsetMax = (ptMax - ptPart).dotProduct(vecDir);
					double dOffsetMin = (ptMin - ptPart).dotProduct(vecDir);
					
//					if (dOffset > dOffsetMax)
//					{ 
//						dOffset.set(dOffsetMax);
//					}
//					if (dOffset < dOffsetMin)
//					{ 
//						dOffset.set(dOffsetMin);
//					}
					double dOffsetCalc = dOffset;
					if (dOffsetCalc > dOffsetMax)
					{ 
						dOffsetCalc=dOffsetMax;
					}
					if (dOffsetCalc < dOffsetMin)
					{ 
						dOffsetCalc=dOffsetMin;
					}
//					ptPart += dOffset * vecDir;
					ptPart += dOffsetCalc * vecDir;
					
					// remove extension by .5*dC
	//				ppIntersectDc.shrink(.5 * dC);
					// add a tolerance
					ppIntersectDc.shrink(-dEps);
					ppIntersectDc.vis(3);
					//
					PLine plPart(vecMale);
					PlaneProfile ppPart;
					{ 
						Point3d pt1 = ptPart - vecDir * .5 * dC;
						Point3d pt2 = ptPart + vecDir * .5 * dC + vecFemale * dB;
						LineSeg ls(pt1, pt2);
						plPart.createRectangle(ls, vecFemale, vecDir);
					}
	//				ppPart.joinRing(plPart, _kAdd);
					ppPart = PlaneProfile(plPart);
					ppPart.vis(1);
					PlaneProfile ppFemale = bd1.shadowProfile(Plane(_Pt0, vecMale));
					PlaneProfile ppSubtract = ppPart;
					ppSubtract.subtractProfile(ppFemale);
					
	//				if (ppIntersectDc.pointInProfile(ptPart) != _kPointInProfile)
					if (ppSubtract.area() > dEps)
					{ 
						// point outside the profile, part can not be inserted
	//					reportMessage(TN("|enters left|"));
	//					
	//					Display dp(1);
	//					String sTextError = T("|not possible|");
	//					dp.draw(sTextError, _Pt0, _X0, vecY0, 0, 0, _kDeviceX );
	//		//			eraseInstance();
	//					return;
					}
					else
					{ 
						iFoundCurrent = 1;
						// connection can be created
						if (iFound == 0)
						{ 
							_Map.setInt("iFound", 1);
						}
						if(dOffsetCalc!=dOffset)
							dOffset.set(dOffsetCalc);
						// create part
						iNrParts++;
						// at male 
						Body bd0(ptPart, vecMale, vecDir, vecFemale,
										dA, dC, dT, 1, 0, 1 );
						// at female
						Body bd1(ptPart, vecFemale, vecDir, vecMale,
										dB, dC, dT, 1, 0, 1 );
						// milling
						if (iSelectedMilling == 1 )
						{ 
							// male is selected
							bd0.transformBy(-vecFemale * (dT + dTolerance));
							bd1.transformBy(-vecFemale * (dT + dTolerance));
							// beamcut
							Point3d ptBeamCut = ptPart;//-vecFemale*(dT+dTolerance);
							
				//			BeamCut bc0(ptBeamCut, vecMale, vecDir, vecFemale,
				//						dA+(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
							// hause
							ptBeamCut.vis(3);
							House hs0(ptBeamCut, vecMale, vecDir, -vecFemale,
										dA+(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
							hs0.setRoundType(_kReliefSmall);
				//			hs0.setEndType(_kFemaleSide);
				//			hs0.cuttingBody().vis(2);
							// hause
				//			bc0.cuttingBody().vis(5);
							if(bm0.bIsValid())
								bm0.addTool(hs0);
						}
						if(iSelectedMilling == 2)
						{ 
							// female is selected
							bd0.transformBy(-vecMale * (dT + dTolerance));
							bd1.transformBy(-vecMale * (dT + dTolerance));
							// beamcut
							Point3d ptBeamCut = ptPart;//-vecMale*(dT+dTolerance);
							
				//			BeamCut bc1(ptBeamCut, vecFemale, vecDir, vecMale,
				//						dB+(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
										
							House hs1(ptBeamCut, vecFemale, vecDir, -vecMale,
										dB+(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
							hs1.setRoundType(_kReliefSmall);
							ptBeamCut.vis(6);
							hs1.cuttingBody().vis(2);
				//			bc1.cuttingBody().vis(5);
							if(bm1.bIsValid())
								bm1.addTool(hs1);
						}
						if (iSelectedMilling == 3)
						{ 
							// the common cut
							Point3d ptBeamCut = ptPart - (vecMale) * (dT + dTolerance);
							
							
							House hs010(ptBeamCut, vecMale, vecDir, -vecFemale,
									dA + (dT + dTolerance), dC, (dT + dTolerance), 1, 0, 1 );
							hs010.setRoundType(_kReliefSmall);
							
				//			hs010.cuttingBody().vis(2);
				//			BeamCut bc01(ptBeamCut, vecFemale, vecDir, vecMale,
				//						(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
				//				
							if(bm0.bIsValid())
								bm0.addTool(hs010);
							
							ptBeamCut = ptPart - (vecFemale) * (dT + dTolerance);
							House hs011(ptBeamCut, vecFemale, vecDir, -vecMale,
									dB + (dT + dTolerance), dC, (dT + dTolerance), 1, 0, 1 );
							hs011.setRoundType(_kReliefSmall);
							
				//			hs011.cuttingBody().vis(2);
							if(bm1.bIsValid())
								bm1.addTool(hs011);
							// displacement
							bd0.transformBy(-vecFemale * (dT + dTolerance));
							bd1.transformBy(-vecFemale * (dT + dTolerance));
							bd0.transformBy(-vecMale * (dT + dTolerance));
							bd1.transformBy(-vecMale * (dT + dTolerance));
							
						}
						bd0.vis(2);
						bd1.vis(2);
						bd.addPart(bd0);
						bd.addPart(bd1);
					}
				}
			}
			// right side
			{ 
				// right is selected or both
				// sectional values of male and female beam
				double dWidth0 = qd0.dD(vecY0);
				double dHeight0 = qd0.dD(vecZ0);
				//
				double dWidth1 = qd0.dD(_vecZ1);
				double dHeight1 = qd1.dD(_vecY1);
				//
				Plane pnMale(ptCen0 - vecY0 * .5 * dWidth0, vecY0);
				Plane pnFemale(ptCen1 - _vecZ1 * .5 * dWidth1, _vecZ1);
				Line ln = pnMale.intersect(pnFemale);
				
				// we consider upward vector aligned with _Z0
				Vector3d vecDir = ln.vecX();
				if (vecDir.dotProduct(vecZ0) < 0)
				{ 
					vecDir *= -1;
				}
				
				Vector3d vecMale = -_vecX0;
				// see if 2 planes normal with each other
				// _Y0 is the vector of plane at male beam
				// _Z1 is the vector of plane at female beam
				
	//			if ( ! vecY0.isPerpendicularTo(_vecZ1))
				if ( abs(vecY0.dotProduct(_vecZ1))>dEps)
				{ 
	//				// not perpendicular
	//				reportMessage(TN("|only normal angle T connections are supported|"));
	//				
	//				if (iFound == 0)
	//				{ 
	//					if (iRotateYZ == 0)
	//					{ 
	//						// rotation never done
	//						// for first time try to rotate y0z0
	//						// rotation is only tried at firs time
	//						_Map.setInt("iRotateYZ", 1);
	//						setExecutionLoops(2);
	//						if (_kExecutionLoopCount == 0)
	//						{
	//							setExecutionLoops(2);
	//						}
	//						if (_kExecutionLoopCount == 1)
	//						{ 
	//							setExecutionLoops(3);
	//						}
	//						if (_kExecutionLoopCount == 2)
	//						{ 
	//							setExecutionLoops(4);
	//						}
	//						return;
	//					}
	//					else
	//					{ 
	//						// rotation was done and 
	//						// solution was never found
	//						reportMessage(TN("|only normal angle T connections are supported|"));
	//						eraseInstance();
	//						return;
	//					}
	//					
	//				}
	//				// a solution used to exist, display message
	//	//			eraseInstance();
	//				Display dp(1);
	//				String sTextError = T("|not possible|");
	//				dp.draw(sTextError, _Pt0, _X0, vecY0, 0, 0, _kDeviceX );
	//				return;
				}
				else
				{
	//				if ( ! vecMale.isParallelTo(_vecZ1))
					if ( abs(abs(vecMale.dotProduct(_vecZ1))-1)>dEps)
					{ 
						// not parallel to _X0
						// make it like _Z1 (normal with the plane of contact)
						vecMale = - _vecZ1;
					}
					Vector3d vecFemale = vecMale.crossProduct(vecDir);
					vecFemale.normalize();
					if (vecFemale.dotProduct(vecY0) > 0)
					{ 
						vecFemale *= -1;
					}
					
					Point3d ptPart = pnMale.closestPointTo(_Pt0);
					
					vecDir.vis(ptPart);
					vecMale.vis(ptPart);
					vecFemale.vis(ptPart);
					// check if the part touches female beam and male beam
					// it will be accepted that the part only need to touch the female and male beam
					// _Pt0 must be within the length of female beam, It is always within the range of male beam because
					// male beam is streched at the female beam
	//				Point3d ptFemale1 = ptCen1 - .5 * _X1 * _Beam1.solidLength();
					Point3d ptFemale1 = ptCen1 - .5 * _vecX1 * qd1.dD(qd1.vecX());
	//				Point3d ptFemale2 = ptCen1 + .5 * _X1 * _Beam1.solidLength();
					Point3d ptFemale2 = ptCen1 + .5 * _vecX1 * qd1.dD(qd1.vecX());
					ptFemale1.vis(1);
					ptFemale2.vis(3);
					
					// check ptpart is within the planeProfile of the female beam
					Plane pnMaleCut(ptPart + vecMale * dEps, vecMale);
					Plane pnFemaleCut(ptPart - vecMale * dEps, vecMale);
					PlaneProfile ppMaleCut = bd0.getSlice(pnMaleCut);
					PlaneProfile ppFemaleCut = bd1.getSlice(pnFemaleCut);
					ppFemaleCut.intersectWith(ppMaleCut);
					PlaneProfile ppIntersect = ppFemaleCut;
					ppIntersect.vis(3);
	//				ppIntersect.shrink(-.5 * dC);
					// get extents of profile
					LineSeg segIntersect = ppIntersect.extentInDir(vecDir);
					Point3d ptMin = segIntersect.ptStart();
					Point3d ptMax = segIntersect.ptEnd();
					if (ptMin.dotProduct(vecDir) > ptMax.dotProduct(vecDir))
					{ 
						ptMin = segIntersect.ptEnd();
						ptMax = segIntersect.ptStart();
					}
					
			
					// segment considering extension left and right with .5*dC
					LineSeg segIntersectDc(ptMin - .5 * dC * vecDir, ptMax + .5 * dC * vecDir);
					PLine pl;
					pl.createRectangle(segIntersectDc, vecDir, vecFemale);
					PlaneProfile ppIntersectDc(pl);
					ptMin = segIntersectDc.ptStart();
					ptMax = segIntersectDc.ptEnd();
					if (ptMin.dotProduct(vecDir) > ptMax.dotProduct(vecDir))
					{ 
						ptMin = segIntersectDc.ptEnd();
						ptMax = segIntersectDc.ptStart();
					}
					ptMin.vis(4);
					ptMax.vis(4);
					//
					double dOffsetMax = (ptMax - ptPart).dotProduct(vecDir);
					double dOffsetMin = (ptMin - ptPart).dotProduct(vecDir);
					
//					if (dOffset > dOffsetMax)
//					{ 
//						dOffset.set(dOffsetMax);
//					}
//					if (dOffset < dOffsetMin)
//					{ 
//						dOffset.set(dOffsetMin);
//					}
					double dOffsetCalc = dOffset;
					if (dOffsetCalc > dOffsetMax)
					{ 
						dOffsetCalc=dOffsetMax;
					}
					if (dOffsetCalc < dOffsetMin)
					{ 
						dOffsetCalc=dOffsetMin;
					}
//					ptPart += dOffset * vecDir;
					ptPart += dOffsetCalc * vecDir;
					
					// remove extension by .5*dC
	//				ppIntersect.shrink(.5 * dC);
					// add a tolerance
	//				ppIntersect.shrink(-dEps);
					ppIntersectDc.shrink(-dEps);
					ppIntersectDc.vis(3);
	//				ptPart.vis(1);
					
					PLine plPart(vecMale);
					PlaneProfile ppPart;
					{ 
						Point3d pt1 = ptPart - vecDir * .5 * dC;
						Point3d pt2 = ptPart + vecDir * .5 * dC + vecFemale * dB;
						LineSeg ls(pt1, pt2);
						plPart.createRectangle(ls, vecFemale, vecDir);
					}
	//				ppPart.joinRing(plPart, _kAdd);
					ppPart = PlaneProfile(plPart);
					ppPart.vis(1);
					PlaneProfile ppFemale = bd1.shadowProfile(Plane(_Pt0, vecMale));
					PlaneProfile ppSubtract = ppPart;
					ppSubtract.subtractProfile(ppFemale);
	//				if (ppIntersectDc.pointInProfile(ptPart) != _kPointInProfile)
					if (ppSubtract.area() > dEps)
					{ 
						// point outside the profile, part can not be inserted
	//					reportMessage(TN("|enters right|"));
						
	//					reportMessage(TN("|part can not be inserted|"));
	//					Display dp(1);
	//					String sTextError = T("|not possible|");
	//					dp.draw(sTextError, _Pt0, _X0, vecY0, 0, 0, _kDeviceX );
	//		//			eraseInstance();
	//					return;
					}
					else
					{ 
						iFoundCurrent = 1;
						// connection can be created
						if (iFound == 0)
						{ 
							_Map.setInt("iFound", 1);
						}
						if(dOffsetCalc!=dOffset)
							dOffset.set(dOffsetCalc);
						// create part
						iNrParts++;
						// at male 
						Body bd0(ptPart, vecMale, vecDir, vecFemale,
										dA, dC, dT, 1, 0, 1 );
						// at female
						Body bd1(ptPart, vecFemale, vecDir, vecMale,
										dB, dC, dT, 1, 0, 1 );
						// milling
						if (iSelectedMilling == 1)
						{ 
							// male is selected
							bd0.transformBy(-vecFemale * (dT + dTolerance));
							bd1.transformBy(-vecFemale * (dT + dTolerance));
							// beamcut
							Point3d ptBeamCut = ptPart;//-vecFemale*(dT+dTolerance);
							House hs0(ptBeamCut, vecMale, vecDir, -vecFemale,
										dA+(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
							hs0.setRoundType(_kReliefSmall);
							
				//			BeamCut bc0(ptBeamCut, vecMale, vecDir, vecFemale,
				//						dA+(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
				//			bc0.cuttingBody().vis(5);
							if(bm0.bIsValid())
								bm0.addTool(hs0);
						}
						if(iSelectedMilling == 2)
						{ 
							// female is selected
							bd0.transformBy(-vecMale * (dT + dTolerance));
							bd1.transformBy(-vecMale * (dT + dTolerance));
							// beamcut
							Point3d ptBeamCut = ptPart;//-vecMale*(dT+dTolerance);
							House hs1(ptBeamCut, vecFemale, vecDir, -vecMale,
										dB+(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
							hs1.setRoundType(_kReliefSmall);
				//			BeamCut bc1(ptBeamCut, vecFemale, vecDir, vecMale,
				//						dB+(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
				//			bc1.cuttingBody().vis(5);
							if(bm1.bIsValid())
								bm1.addTool(hs1);
						}
						if (iSelectedMilling == 3)
						{ 
							// the common cut
							Point3d ptBeamCut = ptPart - (vecMale) * (dT + dTolerance);
				//			BeamCut bc01(ptBeamCut, vecFemale, vecDir, vecMale,
				//						(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
							ptPart.vis(5);
							House hs010(ptBeamCut, vecMale, vecDir, -vecFemale,
									dA + (dT + dTolerance), dC, (dT + dTolerance), 1, 0, 1 );
							hs010.setRoundType(_kReliefSmall);
							hs010.cuttingBody().vis(3);
							if(bm0.bIsValid())
								bm0.addTool(hs010);
							
							ptBeamCut = ptPart - (vecFemale) * (dT + dTolerance);
							House hs011(ptBeamCut, vecFemale, vecDir, -vecMale,
									dB + (dT + dTolerance), dC, (dT + dTolerance), 1, 0, 1 );
							hs011.setRoundType(_kReliefSmall);
							if(bm1.bIsValid())
								bm1.addTool(hs011);
							// displacement
							bd0.transformBy(-vecFemale * (dT + dTolerance));
							bd1.transformBy(-vecFemale * (dT + dTolerance));
							bd0.transformBy(-vecMale * (dT + dTolerance));
							bd1.transformBy(-vecMale * (dT + dTolerance));
						}
						
						bd0.vis(2);
						bd1.vis(2);
						
						bd.addPart(bd0);
						bd.addPart(bd1);
					}
				}
			}
			
			// after this calculation
			if (iFound == 0)
			{ 
				// never found
				if (iFoundCurrent == 0)
				{ 
					if(!iAlign)
					{ 
						if (iRotateYZ == 0)
						{ 
							// never rotated, try rotation
							_Map.setInt("iRotateYZ", 1);
							setExecutionLoops(2);
							if (_kExecutionLoopCount == 0) setExecutionLoops(2);
							if (_kExecutionLoopCount == 1) setExecutionLoops(3);
							if (_kExecutionLoopCount == 2) setExecutionLoops(4);
							if (_kExecutionLoopCount == 3) setExecutionLoops(5);
						}
						else
						{ 
							// rotation was tried
							reportMessage("\n"+scriptName()+" "+T("|connection not possible|"));
							eraseInstance();
							return;
						}
					}
					else
					{ 
						if (iRotateYZ == 1)
						{ 
							// never rotated, try rotation
							_Map.setInt("iRotateYZ", 0);
							setExecutionLoops(2);
							if (_kExecutionLoopCount == 0) setExecutionLoops(2);
							if (_kExecutionLoopCount == 1) setExecutionLoops(3);
							if (_kExecutionLoopCount == 2) setExecutionLoops(4);
							if (_kExecutionLoopCount == 3) setExecutionLoops(5);
						}
						else
						{ 
							// rotation was tried
							reportMessage("\n"+scriptName()+" "+T("|connection not possible|"));
							eraseInstance();
							return;
						}
					}
				}
			}
			else
			{ 
				// was once found
				if (iFoundCurrent == 0)
				{ 
					//currently not found, show display
					// display not possible
					Display dp(1);
					String sTextError = T("|not possible|");
					dp.draw(sTextError, _Pt0, _vecX0, vecY0, 0, 0, _kDeviceX );
					return;
				}
				
			}
		}
	}
	else if(!iBeamsIntersect)
	{ 
		// 2.15
		// special case, male on top of female 
		// or female on top of male
		// do calculation for both wrt. "T" type left, right
		// and property left right will mean side wrt female beam
		if (iSideHorizontalSelected == 0 || iSideHorizontalSelected == 2)
		{
			// left or both
			Vector3d _vecX0support = _vecX0;
			_vecX0 = _vecX0support;
			_vecY0 = _vecZ0.crossProduct(_vecX0);
			_vecY0.normalize();
			
			pnContact = plns[iPlaneConntact];
			Point3d _Pt0support = Line(ptCen0, qd0.vecX()).intersect(pnContact, 0);
//			_Pt0support =_Pt0;
			_vecX1 = qd1.vecX();
			_vecZ1 = vecsPlane[iPlaneConntact];
			if (_vecX0.dotProduct(_vecZ1) < 0)_vecZ1 *= -1;
			_vecY1 = _vecZ1.crossProduct(_vecX1);
			
			
			// variable to track current calculation
			int iFoundCurrent = false;
			// left side
			{ 
				// sectional values of male and female beam
				double dWidth0 = qd0.dD(vecY0);
				double dHeight0 = qd0.dD(vecZ0);
				//
				double dWidth1 = qd1.dD(_vecZ1);
				double dHeight1 = qd1.dD(_vecY1);
				//
				Plane pnMale(ptCen0 + vecY0 * .5 * dWidth0, vecY0);
				Plane pnFemale(ptCen1 - _vecZ1 * .5 * dWidth1, _vecZ1);
				Line ln = pnMale.intersect(pnFemale);
				
				// we consider upward vector aligned with _Z0
				Vector3d vecDir = ln.vecX();
				if (vecDir.dotProduct(vecZ0) < 0)
				{ 
					vecDir *= -1;
				}
		//		vecDir.vis(_Pt0);
				Vector3d vecMale = -_vecX0;
				// see if 2 planes normal with each other
				// _Y0 is the vector of plane at male beam
				// _Z1 is the vector of plane at female beam
				
	//			if ( ! vecY0.isPerpendicularTo(_vecZ1))
				if ( abs(vecY0.dotProduct(_vecZ1))>dEps)
				{ 
					// not perpendicular
					reportMessage("\n"+scriptName()+" "+T("|only normal angle T connections are supported|"));
					
	//				Display dp(1);
	//				String sTextError = T("|not possible|");
	//				dp.draw(sTextError, _Pt0, _X0, vecY0, 0, 0, _kDeviceX );
	//				return;
				}
				else
				{ 
					// can be possible
	//				if ( ! vecMale.isParallelTo(_vecZ1))
					if ( abs(abs(vecMale.dotProduct(_vecZ1))-1)>dEps)
					{ 
						// not parallel to _X0
						// make it like _Z1 (normal with the plane of contact)
						vecMale = -_vecZ1;
					}
					
					Vector3d vecFemale = vecMale.crossProduct(vecDir);
					vecFemale.normalize();
					if (vecFemale.dotProduct(vecY0) < 0)
					{ 
						vecFemale *= -1;
					}
					// point where the bracket will be attached
//					Point3d ptPart = pnMale.closestPointTo(_Pt0);
					Point3d ptPart = pnMale.closestPointTo(_Pt0support);
					
					// move the ptPart by the offset value
					// maximal offset that can be moved
					
					vecDir.vis(ptPart);
					vecMale.vis(ptPart);
					vecFemale.vis(ptPart);
					
					// check if the part touches female beam and male beam
					// it will be accepted that the part only need to touch the female and male beam
					// _Pt0 must be within the length of female beam, It is always within the range of male beam because
					// male beam is streched at the female beam
					
	//				Point3d ptFemale1 = ptCen1 - .5 * _X1 * _Beam1.solidLength();
					Point3d ptFemale1 = ptCen1 - .5 * _vecX1 * qd1.dD(qd1.vecX());
	//				Point3d ptFemale2 = ptCen1 + .5 * _X1 * _Beam1.solidLength();
					Point3d ptFemale2 = ptCen1 + .5 * _vecX1 * qd1.dD(qd1.vecX());
					
					// check ptpart is within the planeProfile of the female beam
					Plane pnMaleCut(ptPart + vecMale * dEps, vecMale);
					Plane pnFemaleCut(ptPart - vecMale * dEps, vecMale);
	//				PlaneProfile ppMaleCut = _Beam0.envelopeBody().getSlice(pnMaleCut);
					PlaneProfile ppMaleCut = bd0.getSlice(pnMaleCut);
	//				PlaneProfile ppFemaleCut = _Beam1.envelopeBody().getSlice(pnFemaleCut);
					PlaneProfile ppFemaleCut = bd1.getSlice(pnFemaleCut);
					ppFemaleCut.intersectWith(ppMaleCut);
					PlaneProfile ppIntersect = ppFemaleCut;
					ppIntersect.vis(3);
	//				ppIntersect.shrink(-.5 * dC);
					// get extents of profile
					LineSeg segIntersect = ppIntersect.extentInDir(vecDir);
					Point3d ptMin = segIntersect.ptStart();
					Point3d ptMax = segIntersect.ptEnd();
					if (ptMin.dotProduct(vecDir) > ptMax.dotProduct(vecDir))
					{ 
						ptMin = segIntersect.ptEnd();
						ptMax = segIntersect.ptStart();
					}
					
					
					// segment considering extension left and right with .5*dC
					LineSeg segIntersectDc(ptMin - .5 * dC * vecDir, ptMax + .5 * dC * vecDir);
					PLine pl;
					pl.createRectangle(segIntersectDc, vecDir, vecFemale);
					PlaneProfile ppIntersectDc(pl);
					ptMin = segIntersectDc.ptStart();
					ptMax = segIntersectDc.ptEnd();
					if (ptMin.dotProduct(vecDir) > ptMax.dotProduct(vecDir))
					{ 
						ptMin = segIntersectDc.ptEnd();
						ptMax = segIntersectDc.ptStart();
					}
					ptMin.vis(4);
					ptMax.vis(4);
					
					double dOffsetMax = (ptMax - ptPart).dotProduct(vecDir);
					double dOffsetMin = (ptMin - ptPart).dotProduct(vecDir);
					
//					if (dOffset > dOffsetMax)
//					{ 
//						dOffset.set(dOffsetMax);
//					}
//					if (dOffset < dOffsetMin)
//					{ 
//						dOffset.set(dOffsetMin);
//					}
					double dOffsetCalc = dOffset;
					if (dOffsetCalc > dOffsetMax)
					{ 
						dOffsetCalc=dOffsetMax;
					}
					if (dOffsetCalc < dOffsetMin)
					{ 
						dOffsetCalc=dOffsetMin;
					}
//					ptPart += dOffset * vecDir;
					ptPart += dOffsetCalc * vecDir;
					
					// remove extension by .5*dC
	//				ppIntersectDc.shrink(.5 * dC);
					// add a tolerance
					ppIntersectDc.shrink(-dEps);
					ppIntersectDc.vis(3);
					//
					PLine plPart(vecMale);
					PlaneProfile ppPart;
					{ 
						Point3d pt1 = ptPart - vecDir * .5 * dC;
						Point3d pt2 = ptPart + vecDir * .5 * dC + vecFemale * dB;
						LineSeg ls(pt1, pt2);
						plPart.createRectangle(ls, vecFemale, vecDir);
					}
	//				ppPart.joinRing(plPart, _kAdd);
					ppPart = PlaneProfile(plPart);
					ppPart.vis(1);
					PlaneProfile ppFemale = bd1.shadowProfile(Plane(_Pt0support, vecMale));
					PlaneProfile ppSubtract = ppPart;
					ppSubtract.subtractProfile(ppFemale);
					
	//				if (ppIntersectDc.pointInProfile(ptPart) != _kPointInProfile)
					if (ppSubtract.area() > dEps)
					{ 
						// point outside the profile, part can not be inserted
	//					reportMessage(TN("|enters left|"));
	//					
	//					Display dp(1);
	//					String sTextError = T("|not possible|");
	//					dp.draw(sTextError, _Pt0, _X0, vecY0, 0, 0, _kDeviceX );
	//		//			eraseInstance();
	//					return;
					}
					else
					{ 
						iFoundCurrent = 1;
						// connection can be created
						if (iFound == 0)
						{ 
							_Map.setInt("iFound", 1);
						}
						if(dOffsetCalc!=dOffset)
							dOffset.set(dOffsetCalc);
						// create part
						iNrParts++;
						// at male 
						Body bd0(ptPart, vecMale, vecDir, vecFemale,
										dA, dC, dT, 1, 0, 1 );
						// at female
						Body bd1(ptPart, vecFemale, vecDir, vecMale,
										dB, dC, dT, 1, 0, 1 );
						// milling
						if (iSelectedMilling == 1 )
						{ 
							// male is selected
							bd0.transformBy(-vecFemale * (dT + dTolerance));
							bd1.transformBy(-vecFemale * (dT + dTolerance));
							// beamcut
							Point3d ptBeamCut = ptPart;//-vecFemale*(dT+dTolerance);
							
				//			BeamCut bc0(ptBeamCut, vecMale, vecDir, vecFemale,
				//						dA+(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
							// hause
							ptBeamCut.vis(3);
							House hs0(ptBeamCut, vecMale, vecDir, -vecFemale,
										dA+(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
							hs0.setRoundType(_kReliefSmall);
				//			hs0.setEndType(_kFemaleSide);
				//			hs0.cuttingBody().vis(2);
							// hause
				//			bc0.cuttingBody().vis(5);
							if(bm0.bIsValid())
								bm0.addTool(hs0);
						}
						if(iSelectedMilling == 2)
						{ 
							// female is selected
							bd0.transformBy(-vecMale * (dT + dTolerance));
							bd1.transformBy(-vecMale * (dT + dTolerance));
							// beamcut
							Point3d ptBeamCut = ptPart;//-vecMale*(dT+dTolerance);
							
				//			BeamCut bc1(ptBeamCut, vecFemale, vecDir, vecMale,
				//						dB+(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
										
							House hs1(ptBeamCut, vecFemale, vecDir, -vecMale,
										dB+(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
							hs1.setRoundType(_kReliefSmall);
							ptBeamCut.vis(6);
							hs1.cuttingBody().vis(2);
				//			bc1.cuttingBody().vis(5);
							if(bm1.bIsValid())
								bm1.addTool(hs1);
						}
						if (iSelectedMilling == 3)
						{ 
							// the common cut
							Point3d ptBeamCut = ptPart - (vecMale) * (dT + dTolerance);
							
							
							House hs010(ptBeamCut, vecMale, vecDir, -vecFemale,
									dA + (dT + dTolerance), dC, (dT + dTolerance), 1, 0, 1 );
							hs010.setRoundType(_kReliefSmall);
							
				//			hs010.cuttingBody().vis(2);
				//			BeamCut bc01(ptBeamCut, vecFemale, vecDir, vecMale,
				//						(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
				//				
							if(bm0.bIsValid())
								bm0.addTool(hs010);
							
							ptBeamCut = ptPart - (vecFemale) * (dT + dTolerance);
							House hs011(ptBeamCut, vecFemale, vecDir, -vecMale,
									dB + (dT + dTolerance), dC, (dT + dTolerance), 1, 0, 1 );
							hs011.setRoundType(_kReliefSmall);
							
				//			hs011.cuttingBody().vis(2);
							if(bm1.bIsValid())
								bm1.addTool(hs011);
							// displacement
							bd0.transformBy(-vecFemale * (dT + dTolerance));
							bd1.transformBy(-vecFemale * (dT + dTolerance));
							bd0.transformBy(-vecMale * (dT + dTolerance));
							bd1.transformBy(-vecMale * (dT + dTolerance));
							
						}
						bd0.vis(2);
						bd1.vis(2);
						bd.addPart(bd0);
						bd.addPart(bd1);
					}
				}
			}
			// right side
			{ 
				// right is selected or both
				// sectional values of male and female beam
				double dWidth0 = qd0.dD(vecY0);
				double dHeight0 = qd0.dD(vecZ0);
				//
				double dWidth1 = qd0.dD(_vecZ1);
				double dHeight1 = qd1.dD(_vecY1);
				//
				Plane pnMale(ptCen0 - vecY0 * .5 * dWidth0, vecY0);
				Plane pnFemale(ptCen1 - _vecZ1 * .5 * dWidth1, _vecZ1);
				Line ln = pnMale.intersect(pnFemale);
				
				// we consider upward vector aligned with _Z0
				Vector3d vecDir = ln.vecX();
				if (vecDir.dotProduct(vecZ0) < 0)
				{ 
					vecDir *= -1;
				}
				
				Vector3d vecMale = -_vecX0;
				// see if 2 planes normal with each other
				// _Y0 is the vector of plane at male beam
				// _Z1 is the vector of plane at female beam
				
	//			if ( ! vecY0.isPerpendicularTo(_vecZ1))
				if ( abs(vecY0.dotProduct(_vecZ1))>dEps)
				{ 
	//				// not perpendicular
	//				reportMessage(TN("|only normal angle T connections are supported|"));
	//				
	//				if (iFound == 0)
	//				{ 
	//					if (iRotateYZ == 0)
	//					{ 
	//						// rotation never done
	//						// for first time try to rotate y0z0
	//						// rotation is only tried at firs time
	//						_Map.setInt("iRotateYZ", 1);
	//						setExecutionLoops(2);
	//						if (_kExecutionLoopCount == 0)
	//						{
	//							setExecutionLoops(2);
	//						}
	//						if (_kExecutionLoopCount == 1)
	//						{ 
	//							setExecutionLoops(3);
	//						}
	//						if (_kExecutionLoopCount == 2)
	//						{ 
	//							setExecutionLoops(4);
	//						}
	//						return;
	//					}
	//					else
	//					{ 
	//						// rotation was done and 
	//						// solution was never found
	//						reportMessage(TN("|only normal angle T connections are supported|"));
	//						eraseInstance();
	//						return;
	//					}
	//					
	//				}
	//				// a solution used to exist, display message
	//	//			eraseInstance();
	//				Display dp(1);
	//				String sTextError = T("|not possible|");
	//				dp.draw(sTextError, _Pt0, _X0, vecY0, 0, 0, _kDeviceX );
	//				return;
				}
				else
				{
	//				if ( ! vecMale.isParallelTo(_vecZ1))
					if ( abs(abs(vecMale.dotProduct(_vecZ1))-1)>dEps)
					{ 
						// not parallel to _X0
						// make it like _Z1 (normal with the plane of contact)
						vecMale = - _vecZ1;
					}
					Vector3d vecFemale = vecMale.crossProduct(vecDir);
					vecFemale.normalize();
					if (vecFemale.dotProduct(vecY0) > 0)
					{ 
						vecFemale *= -1;
					}
					
					Point3d ptPart = pnMale.closestPointTo(_Pt0support);
					
					vecDir.vis(ptPart);
					vecMale.vis(ptPart);
					vecFemale.vis(ptPart);
					// check if the part touches female beam and male beam
					// it will be accepted that the part only need to touch the female and male beam
					// _Pt0 must be within the length of female beam, It is always within the range of male beam because
					// male beam is streched at the female beam
	//				Point3d ptFemale1 = ptCen1 - .5 * _X1 * _Beam1.solidLength();
					Point3d ptFemale1 = ptCen1 - .5 * _vecX1 * qd1.dD(qd1.vecX());
	//				Point3d ptFemale2 = ptCen1 + .5 * _X1 * _Beam1.solidLength();
					Point3d ptFemale2 = ptCen1 + .5 * _vecX1 * qd1.dD(qd1.vecX());
					ptFemale1.vis(1);
					ptFemale2.vis(3);
					
					// check ptpart is within the planeProfile of the female beam
					Plane pnMaleCut(ptPart + vecMale * dEps, vecMale);
					Plane pnFemaleCut(ptPart - vecMale * dEps, vecMale);
					PlaneProfile ppMaleCut = bd0.getSlice(pnMaleCut);
					PlaneProfile ppFemaleCut = bd1.getSlice(pnFemaleCut);
					ppFemaleCut.intersectWith(ppMaleCut);
					PlaneProfile ppIntersect = ppFemaleCut;
					ppIntersect.vis(3);
	//				ppIntersect.shrink(-.5 * dC);
					// get extents of profile
					LineSeg segIntersect = ppIntersect.extentInDir(vecDir);
					Point3d ptMin = segIntersect.ptStart();
					Point3d ptMax = segIntersect.ptEnd();
					if (ptMin.dotProduct(vecDir) > ptMax.dotProduct(vecDir))
					{ 
						ptMin = segIntersect.ptEnd();
						ptMax = segIntersect.ptStart();
					}
					
			
					// segment considering extension left and right with .5*dC
					LineSeg segIntersectDc(ptMin - .5 * dC * vecDir, ptMax + .5 * dC * vecDir);
					PLine pl;
					pl.createRectangle(segIntersectDc, vecDir, vecFemale);
					PlaneProfile ppIntersectDc(pl);
					ptMin = segIntersectDc.ptStart();
					ptMax = segIntersectDc.ptEnd();
					if (ptMin.dotProduct(vecDir) > ptMax.dotProduct(vecDir))
					{ 
						ptMin = segIntersectDc.ptEnd();
						ptMax = segIntersectDc.ptStart();
					}
					ptMin.vis(4);
					ptMax.vis(4);
					//
					double dOffsetMax = (ptMax - ptPart).dotProduct(vecDir);
					double dOffsetMin = (ptMin - ptPart).dotProduct(vecDir);
					
//					if (dOffset > dOffsetMax)
//					{ 
//						dOffset.set(dOffsetMax);
//					}
//					if (dOffset < dOffsetMin)
//					{ 
//						dOffset.set(dOffsetMin);
//					}
					double dOffsetCalc = dOffset;
					if (dOffsetCalc > dOffsetMax)
					{ 
						dOffsetCalc=dOffsetMax;
					}
					if (dOffsetCalc < dOffsetMin)
					{ 
						dOffsetCalc=dOffsetMin;
					}
//					ptPart += dOffset * vecDir;
					ptPart += dOffsetCalc * vecDir;
					
					// remove extension by .5*dC
	//				ppIntersect.shrink(.5 * dC);
					// add a tolerance
	//				ppIntersect.shrink(-dEps);
					ppIntersectDc.shrink(-dEps);
					ppIntersectDc.vis(3);
	//				ptPart.vis(1);
					
					PLine plPart(vecMale);
					PlaneProfile ppPart;
					{ 
						Point3d pt1 = ptPart - vecDir * .5 * dC;
						Point3d pt2 = ptPart + vecDir * .5 * dC + vecFemale * dB;
						LineSeg ls(pt1, pt2);
						plPart.createRectangle(ls, vecFemale, vecDir);
					}
	//				ppPart.joinRing(plPart, _kAdd);
					ppPart = PlaneProfile(plPart);
					ppPart.vis(1);
					PlaneProfile ppFemale = bd1.shadowProfile(Plane(_Pt0support, vecMale));
					PlaneProfile ppSubtract = ppPart;
					ppSubtract.subtractProfile(ppFemale);
	//				if (ppIntersectDc.pointInProfile(ptPart) != _kPointInProfile)
					if (ppSubtract.area() > dEps)
					{ 
						// point outside the profile, part can not be inserted
	//					reportMessage(TN("|enters right|"));
						
	//					reportMessage(TN("|part can not be inserted|"));
	//					Display dp(1);
	//					String sTextError = T("|not possible|");
	//					dp.draw(sTextError, _Pt0, _X0, vecY0, 0, 0, _kDeviceX );
	//		//			eraseInstance();
	//					return;
					}
					else
					{ 
						iFoundCurrent = 1;
						// connection can be created
						if (iFound == 0)
						{ 
							_Map.setInt("iFound", 1);
						}
						if(dOffsetCalc!=dOffset)
							dOffset.set(dOffsetCalc);
						// create part
						iNrParts++;
						// at male 
						Body bd0(ptPart, vecMale, vecDir, vecFemale,
										dA, dC, dT, 1, 0, 1 );
						// at female
						Body bd1(ptPart, vecFemale, vecDir, vecMale,
										dB, dC, dT, 1, 0, 1 );
						// milling
						if (iSelectedMilling == 1)
						{ 
							// male is selected
							bd0.transformBy(-vecFemale * (dT + dTolerance));
							bd1.transformBy(-vecFemale * (dT + dTolerance));
							// beamcut
							Point3d ptBeamCut = ptPart;//-vecFemale*(dT+dTolerance);
							House hs0(ptBeamCut, vecMale, vecDir, -vecFemale,
										dA+(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
							hs0.setRoundType(_kReliefSmall);
							
				//			BeamCut bc0(ptBeamCut, vecMale, vecDir, vecFemale,
				//						dA+(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
				//			bc0.cuttingBody().vis(5);
							if(bm0.bIsValid())
								bm0.addTool(hs0);
						}
						if(iSelectedMilling == 2)
						{ 
							// female is selected
							bd0.transformBy(-vecMale * (dT + dTolerance));
							bd1.transformBy(-vecMale * (dT + dTolerance));
							// beamcut
							Point3d ptBeamCut = ptPart;//-vecMale*(dT+dTolerance);
							House hs1(ptBeamCut, vecFemale, vecDir, -vecMale,
										dB+(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
							hs1.setRoundType(_kReliefSmall);
				//			BeamCut bc1(ptBeamCut, vecFemale, vecDir, vecMale,
				//						dB+(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
				//			bc1.cuttingBody().vis(5);
							if(bm1.bIsValid())
								bm1.addTool(hs1);
						}
						if (iSelectedMilling == 3)
						{ 
							// the common cut
							Point3d ptBeamCut = ptPart - (vecMale) * (dT + dTolerance);
				//			BeamCut bc01(ptBeamCut, vecFemale, vecDir, vecMale,
				//						(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
							ptPart.vis(5);
							House hs010(ptBeamCut, vecMale, vecDir, -vecFemale,
									dA + (dT + dTolerance), dC, (dT + dTolerance), 1, 0, 1 );
							hs010.setRoundType(_kReliefSmall);
							hs010.cuttingBody().vis(3);
							if(bm0.bIsValid())
								bm0.addTool(hs010);
							
							ptBeamCut = ptPart - (vecFemale) * (dT + dTolerance);
							House hs011(ptBeamCut, vecFemale, vecDir, -vecMale,
									dB + (dT + dTolerance), dC, (dT + dTolerance), 1, 0, 1 );
							hs011.setRoundType(_kReliefSmall);
							if(bm1.bIsValid())
								bm1.addTool(hs011);
							// displacement
							bd0.transformBy(-vecFemale * (dT + dTolerance));
							bd1.transformBy(-vecFemale * (dT + dTolerance));
							bd0.transformBy(-vecMale * (dT + dTolerance));
							bd1.transformBy(-vecMale * (dT + dTolerance));
						}
						
						bd0.vis(2);
						bd1.vis(2);
						
						bd.addPart(bd0);
						bd.addPart(bd1);
					}
				}
			}
			
			// after this calculation
			if (iFound == 0)
			{ 
				// never found
				if (iFoundCurrent == 0)
				{ 
					if(!iAlign)
					{ 
						if (iRotateYZ == 0)
						{ 
							// never rotated, try rotation
							_Map.setInt("iRotateYZ", 1);
							setExecutionLoops(2);
							if (_kExecutionLoopCount == 0) setExecutionLoops(2);
							if (_kExecutionLoopCount == 1) setExecutionLoops(3);
							if (_kExecutionLoopCount == 2) setExecutionLoops(4);
							if (_kExecutionLoopCount == 3) setExecutionLoops(5);
						}
						else
						{ 
							// rotation was tried
							reportMessage("\n"+scriptName()+" "+T("|connection not possible|"));
							eraseInstance();
							return;
						}
					}
					else
					{ 
						if (iRotateYZ == 1)
						{ 
							// never rotated, try rotation
							_Map.setInt("iRotateYZ", 0);
							setExecutionLoops(2);
							if (_kExecutionLoopCount == 0) setExecutionLoops(2);
							if (_kExecutionLoopCount == 1) setExecutionLoops(3);
							if (_kExecutionLoopCount == 2) setExecutionLoops(4);
							if (_kExecutionLoopCount == 3) setExecutionLoops(5);
						}
						else
						{ 
							// rotation was tried
							reportMessage("\n"+scriptName()+" "+T("|connection not possible|"));
							eraseInstance();
							return;
						}
					}
				}
			}
			else
			{ 
				// was once found
				if (iFoundCurrent == 0)
				{ 
					//currently not found, show display
					// display not possible
					Display dp(1);
					String sTextError = T("|not possible|");
					dp.draw(sTextError, _Pt0support, _vecX0, vecY0, 0, 0, _kDeviceX );
					return;
				}
				
			}
			
		}
		if (iSideHorizontalSelected == 1 || iSideHorizontalSelected == 2)
		{ 
//			// right or both
			Vector3d _vecX0support = -_vecX0;
			_vecX0 = _vecX0support;
			_vecY0 = _vecZ0.crossProduct(_vecX0);
			_vecY0.normalize();
			
			int iPlaneConntactsupport = iPlanesOpposite[iPlaneConntact];
			iPlaneConntact = iPlaneConntactsupport;
			pnContact = plns[iPlaneConntact];
			Point3d _Pt0support = Line(ptCen0, qd0.vecX()).intersect(pnContact, 0);
//			_Pt0support =_Pt0;
			_vecX1 = qd1.vecX();
			_vecZ1 = vecsPlane[iPlaneConntact];
			if (_vecX0.dotProduct(_vecZ1) < 0)_vecZ1 *= -1;
			_vecY1 = _vecZ1.crossProduct(_vecX1);
			
			// variable to track current calculation
			int iFoundCurrent = false;
			// left side
			{ 
				// sectional values of male and female beam
				double dWidth0 = qd0.dD(vecY0);
				double dHeight0 = qd0.dD(vecZ0);
				//
				double dWidth1 = qd1.dD(_vecZ1);
				double dHeight1 = qd1.dD(_vecY1);
				//
				Plane pnMale(ptCen0 + vecY0 * .5 * dWidth0, vecY0);
				Plane pnFemale(ptCen1 - _vecZ1 * .5 * dWidth1, _vecZ1);
				Line ln = pnMale.intersect(pnFemale);
				
				// we consider upward vector aligned with _Z0
				Vector3d vecDir = ln.vecX();
				if (vecDir.dotProduct(vecZ0) < 0)
				{ 
					vecDir *= -1;
				}
		//		vecDir.vis(_Pt0);
				Vector3d vecMale = -_vecX0;
				// see if 2 planes normal with each other
				// _Y0 is the vector of plane at male beam
				// _Z1 is the vector of plane at female beam
				
	//			if ( ! vecY0.isPerpendicularTo(_vecZ1))
				if ( abs(vecY0.dotProduct(_vecZ1))>dEps)
				{ 
					// not perpendicular
					reportMessage("\n"+scriptName()+" "+T("|only normal angle T connections are supported|"));
	//				Display dp(1);
	//				String sTextError = T("|not possible|");
	//				dp.draw(sTextError, _Pt0, _X0, vecY0, 0, 0, _kDeviceX );
	//				return;
				}
				else
				{ 
					// can be possible
	//				if ( ! vecMale.isParallelTo(_vecZ1))
					if ( abs(abs(vecMale.dotProduct(_vecZ1))-1)>dEps)
					{ 
						// not parallel to _X0
						// make it like _Z1 (normal with the plane of contact)
						vecMale = -_vecZ1;
					}
					
					Vector3d vecFemale = vecMale.crossProduct(vecDir);
					vecFemale.normalize();
					if (vecFemale.dotProduct(vecY0) < 0)
					{ 
						vecFemale *= -1;
					}
					// point where the bracket will be attached
//					Point3d ptPart = pnMale.closestPointTo(_Pt0);
					Point3d ptPart = pnMale.closestPointTo(_Pt0support);
					
					// move the ptPart by the offset value
					// maximal offset that can be moved
					
					vecDir.vis(ptPart);
					vecMale.vis(ptPart);
					vecFemale.vis(ptPart);
					
					// check if the part touches female beam and male beam
					// it will be accepted that the part only need to touch the female and male beam
					// _Pt0 must be within the length of female beam, It is always within the range of male beam because
					// male beam is streched at the female beam
					
	//				Point3d ptFemale1 = ptCen1 - .5 * _X1 * _Beam1.solidLength();
					Point3d ptFemale1 = ptCen1 - .5 * _vecX1 * qd1.dD(qd1.vecX());
	//				Point3d ptFemale2 = ptCen1 + .5 * _X1 * _Beam1.solidLength();
					Point3d ptFemale2 = ptCen1 + .5 * _vecX1 * qd1.dD(qd1.vecX());
					
					// check ptpart is within the planeProfile of the female beam
					Plane pnMaleCut(ptPart + vecMale * dEps, vecMale);
					Plane pnFemaleCut(ptPart - vecMale * dEps, vecMale);
	//				PlaneProfile ppMaleCut = _Beam0.envelopeBody().getSlice(pnMaleCut);
					PlaneProfile ppMaleCut = bd0.getSlice(pnMaleCut);
	//				PlaneProfile ppFemaleCut = _Beam1.envelopeBody().getSlice(pnFemaleCut);
					PlaneProfile ppFemaleCut = bd1.getSlice(pnFemaleCut);
					ppFemaleCut.intersectWith(ppMaleCut);
					PlaneProfile ppIntersect = ppFemaleCut;
					ppIntersect.vis(3);
	//				ppIntersect.shrink(-.5 * dC);
					// get extents of profile
					LineSeg segIntersect = ppIntersect.extentInDir(vecDir);
					Point3d ptMin = segIntersect.ptStart();
					Point3d ptMax = segIntersect.ptEnd();
					if (ptMin.dotProduct(vecDir) > ptMax.dotProduct(vecDir))
					{ 
						ptMin = segIntersect.ptEnd();
						ptMax = segIntersect.ptStart();
					}
					
					
					// segment considering extension left and right with .5*dC
					LineSeg segIntersectDc(ptMin - .5 * dC * vecDir, ptMax + .5 * dC * vecDir);
					PLine pl;
					pl.createRectangle(segIntersectDc, vecDir, vecFemale);
					PlaneProfile ppIntersectDc(pl);
					ptMin = segIntersectDc.ptStart();
					ptMax = segIntersectDc.ptEnd();
					if (ptMin.dotProduct(vecDir) > ptMax.dotProduct(vecDir))
					{ 
						ptMin = segIntersectDc.ptEnd();
						ptMax = segIntersectDc.ptStart();
					}
					ptMin.vis(4);
					ptMax.vis(4);
					
					double dOffsetMax = (ptMax - ptPart).dotProduct(vecDir);
					double dOffsetMin = (ptMin - ptPart).dotProduct(vecDir);
					
//					if (dOffset > dOffsetMax)
//					{ 
//						dOffset.set(dOffsetMax);
//					}
//					if (dOffset < dOffsetMin)
//					{ 
//						dOffset.set(dOffsetMin);
//					}
					double dOffsetCalc = dOffset;
					if (dOffsetCalc > dOffsetMax)
					{ 
						dOffsetCalc=dOffsetMax;
					}
					if (dOffsetCalc < dOffsetMin)
					{ 
						dOffsetCalc=dOffsetMin;
					}
//					ptPart += dOffset * vecDir;
					ptPart += dOffsetCalc * vecDir;
					
					// remove extension by .5*dC
	//				ppIntersectDc.shrink(.5 * dC);
					// add a tolerance
					ppIntersectDc.shrink(-dEps);
					ppIntersectDc.vis(3);
					//
					PLine plPart(vecMale);
					PlaneProfile ppPart;
					{ 
						Point3d pt1 = ptPart - vecDir * .5 * dC;
						Point3d pt2 = ptPart + vecDir * .5 * dC + vecFemale * dB;
						LineSeg ls(pt1, pt2);
						plPart.createRectangle(ls, vecFemale, vecDir);
					}
	//				ppPart.joinRing(plPart, _kAdd);
					ppPart = PlaneProfile(plPart);
					ppPart.vis(1);
					PlaneProfile ppFemale = bd1.shadowProfile(Plane(_Pt0support, vecMale));
					PlaneProfile ppSubtract = ppPart;
					ppSubtract.subtractProfile(ppFemale);
					
	//				if (ppIntersectDc.pointInProfile(ptPart) != _kPointInProfile)
					if (ppSubtract.area() > dEps)
					{ 
						// point outside the profile, part can not be inserted
	//					reportMessage(TN("|enters left|"));
	//					
	//					Display dp(1);
	//					String sTextError = T("|not possible|");
	//					dp.draw(sTextError, _Pt0, _X0, vecY0, 0, 0, _kDeviceX );
	//		//			eraseInstance();
	//					return;
					}
					else
					{ 
						iFoundCurrent = 1;
						// connection can be created
						if (iFound == 0)
						{ 
							_Map.setInt("iFound", 1);
						}
						if(dOffsetCalc!=dOffset)
							dOffset.set(dOffsetCalc);
						// create part
						iNrParts++;
						// at male 
						Body bd0(ptPart, vecMale, vecDir, vecFemale,
										dA, dC, dT, 1, 0, 1 );
						// at female
						Body bd1(ptPart, vecFemale, vecDir, vecMale,
										dB, dC, dT, 1, 0, 1 );
						// milling
						if (iSelectedMilling == 1 )
						{ 
							// male is selected
							bd0.transformBy(-vecFemale * (dT + dTolerance));
							bd1.transformBy(-vecFemale * (dT + dTolerance));
							// beamcut
							Point3d ptBeamCut = ptPart;//-vecFemale*(dT+dTolerance);
							
				//			BeamCut bc0(ptBeamCut, vecMale, vecDir, vecFemale,
				//						dA+(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
							// hause
							ptBeamCut.vis(3);
							House hs0(ptBeamCut, vecMale, vecDir, -vecFemale,
										dA+(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
							hs0.setRoundType(_kReliefSmall);
				//			hs0.setEndType(_kFemaleSide);
				//			hs0.cuttingBody().vis(2);
							// hause
				//			bc0.cuttingBody().vis(5);
							if(bm0.bIsValid())
								bm0.addTool(hs0);
						}
						if(iSelectedMilling == 2)
						{ 
							// female is selected
							bd0.transformBy(-vecMale * (dT + dTolerance));
							bd1.transformBy(-vecMale * (dT + dTolerance));
							// beamcut
							Point3d ptBeamCut = ptPart;//-vecMale*(dT+dTolerance);
							
				//			BeamCut bc1(ptBeamCut, vecFemale, vecDir, vecMale,
				//						dB+(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
										
							House hs1(ptBeamCut, vecFemale, vecDir, -vecMale,
										dB+(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
							hs1.setRoundType(_kReliefSmall);
							ptBeamCut.vis(6);
							hs1.cuttingBody().vis(2);
				//			bc1.cuttingBody().vis(5);
							if(bm1.bIsValid())
								bm1.addTool(hs1);
						}
						if (iSelectedMilling == 3)
						{ 
							// the common cut
							Point3d ptBeamCut = ptPart - (vecMale) * (dT + dTolerance);
							
							
							House hs010(ptBeamCut, vecMale, vecDir, -vecFemale,
									dA + (dT + dTolerance), dC, (dT + dTolerance), 1, 0, 1 );
							hs010.setRoundType(_kReliefSmall);
							
				//			hs010.cuttingBody().vis(2);
				//			BeamCut bc01(ptBeamCut, vecFemale, vecDir, vecMale,
				//						(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
				//				
							if(bm0.bIsValid())
								bm0.addTool(hs010);
							
							ptBeamCut = ptPart - (vecFemale) * (dT + dTolerance);
							House hs011(ptBeamCut, vecFemale, vecDir, -vecMale,
									dB + (dT + dTolerance), dC, (dT + dTolerance), 1, 0, 1 );
							hs011.setRoundType(_kReliefSmall);
							
				//			hs011.cuttingBody().vis(2);
							if(bm1.bIsValid())
								bm1.addTool(hs011);
							// displacement
							bd0.transformBy(-vecFemale * (dT + dTolerance));
							bd1.transformBy(-vecFemale * (dT + dTolerance));
							bd0.transformBy(-vecMale * (dT + dTolerance));
							bd1.transformBy(-vecMale * (dT + dTolerance));
							
						}
						bd0.vis(2);
						bd1.vis(2);
						bd.addPart(bd0);
						bd.addPart(bd1);
					}
				}
			}
			// right side
			{ 
				// right is selected or both
				// sectional values of male and female beam
				double dWidth0 = qd0.dD(vecY0);
				double dHeight0 = qd0.dD(vecZ0);
				//
				double dWidth1 = qd0.dD(_vecZ1);
				double dHeight1 = qd1.dD(_vecY1);
				//
				Plane pnMale(ptCen0 - vecY0 * .5 * dWidth0, vecY0);
				Plane pnFemale(ptCen1 - _vecZ1 * .5 * dWidth1, _vecZ1);
				Line ln = pnMale.intersect(pnFemale);
				
				// we consider upward vector aligned with _Z0
				Vector3d vecDir = ln.vecX();
				if (vecDir.dotProduct(vecZ0) < 0)
				{ 
					vecDir *= -1;
				}
				
				Vector3d vecMale = -_vecX0;
				// see if 2 planes normal with each other
				// _Y0 is the vector of plane at male beam
				// _Z1 is the vector of plane at female beam
				
	//			if ( ! vecY0.isPerpendicularTo(_vecZ1))
				if ( abs(vecY0.dotProduct(_vecZ1))>dEps)
				{ 
	//				// not perpendicular
	//				reportMessage(TN("|only normal angle T connections are supported|"));
	//				
	//				if (iFound == 0)
	//				{ 
	//					if (iRotateYZ == 0)
	//					{ 
	//						// rotation never done
	//						// for first time try to rotate y0z0
	//						// rotation is only tried at firs time
	//						_Map.setInt("iRotateYZ", 1);
	//						setExecutionLoops(2);
	//						if (_kExecutionLoopCount == 0)
	//						{
	//							setExecutionLoops(2);
	//						}
	//						if (_kExecutionLoopCount == 1)
	//						{ 
	//							setExecutionLoops(3);
	//						}
	//						if (_kExecutionLoopCount == 2)
	//						{ 
	//							setExecutionLoops(4);
	//						}
	//						return;
	//					}
	//					else
	//					{ 
	//						// rotation was done and 
	//						// solution was never found
	//						reportMessage(TN("|only normal angle T connections are supported|"));
	//						eraseInstance();
	//						return;
	//					}
	//					
	//				}
	//				// a solution used to exist, display message
	//	//			eraseInstance();
	//				Display dp(1);
	//				String sTextError = T("|not possible|");
	//				dp.draw(sTextError, _Pt0, _X0, vecY0, 0, 0, _kDeviceX );
	//				return;
				}
				else
				{
	//				if ( ! vecMale.isParallelTo(_vecZ1))
					if ( abs(abs(vecMale.dotProduct(_vecZ1))-1)>dEps)
					{ 
						// not parallel to _X0
						// make it like _Z1 (normal with the plane of contact)
						vecMale = - _vecZ1;
					}
					Vector3d vecFemale = vecMale.crossProduct(vecDir);
					vecFemale.normalize();
					if (vecFemale.dotProduct(vecY0) > 0)
					{ 
						vecFemale *= -1;
					}
					
					Point3d ptPart = pnMale.closestPointTo(_Pt0support);
					
					vecDir.vis(ptPart);
					vecMale.vis(ptPart);
					vecFemale.vis(ptPart);
					// check if the part touches female beam and male beam
					// it will be accepted that the part only need to touch the female and male beam
					// _Pt0 must be within the length of female beam, It is always within the range of male beam because
					// male beam is streched at the female beam
	//				Point3d ptFemale1 = ptCen1 - .5 * _X1 * _Beam1.solidLength();
					Point3d ptFemale1 = ptCen1 - .5 * _vecX1 * qd1.dD(qd1.vecX());
	//				Point3d ptFemale2 = ptCen1 + .5 * _X1 * _Beam1.solidLength();
					Point3d ptFemale2 = ptCen1 + .5 * _vecX1 * qd1.dD(qd1.vecX());
					ptFemale1.vis(1);
					ptFemale2.vis(3);
					
					// check ptpart is within the planeProfile of the female beam
					Plane pnMaleCut(ptPart + vecMale * dEps, vecMale);
					Plane pnFemaleCut(ptPart - vecMale * dEps, vecMale);
					PlaneProfile ppMaleCut = bd0.getSlice(pnMaleCut);
					PlaneProfile ppFemaleCut = bd1.getSlice(pnFemaleCut);
					ppFemaleCut.intersectWith(ppMaleCut);
					PlaneProfile ppIntersect = ppFemaleCut;
					ppIntersect.vis(3);
	//				ppIntersect.shrink(-.5 * dC);
					// get extents of profile
					LineSeg segIntersect = ppIntersect.extentInDir(vecDir);
					Point3d ptMin = segIntersect.ptStart();
					Point3d ptMax = segIntersect.ptEnd();
					if (ptMin.dotProduct(vecDir) > ptMax.dotProduct(vecDir))
					{ 
						ptMin = segIntersect.ptEnd();
						ptMax = segIntersect.ptStart();
					}
					
			
					// segment considering extension left and right with .5*dC
					LineSeg segIntersectDc(ptMin - .5 * dC * vecDir, ptMax + .5 * dC * vecDir);
					PLine pl;
					pl.createRectangle(segIntersectDc, vecDir, vecFemale);
					PlaneProfile ppIntersectDc(pl);
					ptMin = segIntersectDc.ptStart();
					ptMax = segIntersectDc.ptEnd();
					if (ptMin.dotProduct(vecDir) > ptMax.dotProduct(vecDir))
					{ 
						ptMin = segIntersectDc.ptEnd();
						ptMax = segIntersectDc.ptStart();
					}
					ptMin.vis(4);
					ptMax.vis(4);
					//
					double dOffsetMax = (ptMax - ptPart).dotProduct(vecDir);
					double dOffsetMin = (ptMin - ptPart).dotProduct(vecDir);
					
//					if (dOffset > dOffsetMax)
//					{ 
//						dOffset.set(dOffsetMax);
//					}
//					if (dOffset < dOffsetMin)
//					{ 
//						dOffset.set(dOffsetMin);
//					}
					double dOffsetCalc = dOffset;
					if (dOffsetCalc > dOffsetMax)
					{ 
						dOffsetCalc=dOffsetMax;
					}
					if (dOffsetCalc < dOffsetMin)
					{ 
						dOffsetCalc=dOffsetMin;
					}
//					ptPart += dOffset * vecDir;
					ptPart += dOffsetCalc * vecDir;
					
					// remove extension by .5*dC
	//				ppIntersect.shrink(.5 * dC);
					// add a tolerance
	//				ppIntersect.shrink(-dEps);
					ppIntersectDc.shrink(-dEps);
					ppIntersectDc.vis(3);
	//				ptPart.vis(1);
					
					PLine plPart(vecMale);
					PlaneProfile ppPart;
					{ 
						Point3d pt1 = ptPart - vecDir * .5 * dC;
						Point3d pt2 = ptPart + vecDir * .5 * dC + vecFemale * dB;
						LineSeg ls(pt1, pt2);
						plPart.createRectangle(ls, vecFemale, vecDir);
					}
	//				ppPart.joinRing(plPart, _kAdd);
					ppPart = PlaneProfile(plPart);
					ppPart.vis(1);
					PlaneProfile ppFemale = bd1.shadowProfile(Plane(_Pt0support, vecMale));
					PlaneProfile ppSubtract = ppPart;
					ppSubtract.subtractProfile(ppFemale);
	//				if (ppIntersectDc.pointInProfile(ptPart) != _kPointInProfile)
					if (ppSubtract.area() > dEps)
					{ 
						// point outside the profile, part can not be inserted
	//					reportMessage(TN("|enters right|"));
						
	//					reportMessage(TN("|part can not be inserted|"));
	//					Display dp(1);
	//					String sTextError = T("|not possible|");
	//					dp.draw(sTextError, _Pt0, _X0, vecY0, 0, 0, _kDeviceX );
	//		//			eraseInstance();
	//					return;
					}
					else
					{ 
						iFoundCurrent = 1;
						// connection can be created
						if (iFound == 0)
						{ 
							_Map.setInt("iFound", 1);
						}
						if(dOffsetCalc!=dOffset)
							dOffset.set(dOffsetCalc);
						// create part
						iNrParts++;
						// at male 
						Body bd0(ptPart, vecMale, vecDir, vecFemale,
										dA, dC, dT, 1, 0, 1 );
						// at female
						Body bd1(ptPart, vecFemale, vecDir, vecMale,
										dB, dC, dT, 1, 0, 1 );
						// milling
						if (iSelectedMilling == 1)
						{ 
							// male is selected
							bd0.transformBy(-vecFemale * (dT + dTolerance));
							bd1.transformBy(-vecFemale * (dT + dTolerance));
							// beamcut
							Point3d ptBeamCut = ptPart;//-vecFemale*(dT+dTolerance);
							House hs0(ptBeamCut, vecMale, vecDir, -vecFemale,
										dA+(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
							hs0.setRoundType(_kReliefSmall);
							
				//			BeamCut bc0(ptBeamCut, vecMale, vecDir, vecFemale,
				//						dA+(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
				//			bc0.cuttingBody().vis(5);
							if(bm0.bIsValid())
								bm0.addTool(hs0);
						}
						if(iSelectedMilling == 2)
						{ 
							// female is selected
							bd0.transformBy(-vecMale * (dT + dTolerance));
							bd1.transformBy(-vecMale * (dT + dTolerance));
							// beamcut
							Point3d ptBeamCut = ptPart;//-vecMale*(dT+dTolerance);
							House hs1(ptBeamCut, vecFemale, vecDir, -vecMale,
										dB+(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
							hs1.setRoundType(_kReliefSmall);
				//			BeamCut bc1(ptBeamCut, vecFemale, vecDir, vecMale,
				//						dB+(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
				//			bc1.cuttingBody().vis(5);
							if(bm1.bIsValid())
								bm1.addTool(hs1);
						}
						if (iSelectedMilling == 3)
						{ 
							// the common cut
							Point3d ptBeamCut = ptPart - (vecMale) * (dT + dTolerance);
				//			BeamCut bc01(ptBeamCut, vecFemale, vecDir, vecMale,
				//						(dT + dTolerance), dC, (dT + dTolerance), 1,0,1 );
							ptPart.vis(5);
							House hs010(ptBeamCut, vecMale, vecDir, -vecFemale,
									dA + (dT + dTolerance), dC, (dT + dTolerance), 1, 0, 1 );
							hs010.setRoundType(_kReliefSmall);
							hs010.cuttingBody().vis(3);
							if(bm0.bIsValid())
								bm0.addTool(hs010);
							
							ptBeamCut = ptPart - (vecFemale) * (dT + dTolerance);
							House hs011(ptBeamCut, vecFemale, vecDir, -vecMale,
									dB + (dT + dTolerance), dC, (dT + dTolerance), 1, 0, 1 );
							hs011.setRoundType(_kReliefSmall);
							if(bm1.bIsValid())
								bm1.addTool(hs011);
							// displacement
							bd0.transformBy(-vecFemale * (dT + dTolerance));
							bd1.transformBy(-vecFemale * (dT + dTolerance));
							bd0.transformBy(-vecMale * (dT + dTolerance));
							bd1.transformBy(-vecMale * (dT + dTolerance));
						}
						
						bd0.vis(2);
						bd1.vis(2);
						
						bd.addPart(bd0);
						bd.addPart(bd1);
					}
				}
			}
			
			// after this calculation
			if (iFound == 0)
			{ 
				// never found
				if (iFoundCurrent == 0)
				{ 
					if(!iAlign)
					{ 
						if (iRotateYZ == 0)
						{ 
							// never rotated, try rotation
							_Map.setInt("iRotateYZ", 1);
							setExecutionLoops(2);
							if (_kExecutionLoopCount == 0) setExecutionLoops(2);
							if (_kExecutionLoopCount == 1) setExecutionLoops(3);
							if (_kExecutionLoopCount == 2) setExecutionLoops(4);
							if (_kExecutionLoopCount == 3) setExecutionLoops(5);
						}
						else
						{ 
							// rotation was tried
							reportMessage("\n"+scriptName()+" "+T("|connection not possible|"));
							eraseInstance();
							return;
						}
					}
					else
					{ 
						if (iRotateYZ == 1)
						{ 
							// never rotated, try rotation
							_Map.setInt("iRotateYZ", 0);
							setExecutionLoops(2);
							if (_kExecutionLoopCount == 0) setExecutionLoops(2);
							if (_kExecutionLoopCount == 1) setExecutionLoops(3);
							if (_kExecutionLoopCount == 2) setExecutionLoops(4);
							if (_kExecutionLoopCount == 3) setExecutionLoops(5);
						}
						else
						{ 
							// rotation was tried
							reportMessage("\n"+scriptName()+" "+T("|connection not possible|"));
							eraseInstance();
							return;
						}
					}
					
				}
			}
			else
			{ 
				// was once found
				if (iFoundCurrent == 0)
				{ 
					//currently not found, show display
					// display not possible
					Display dp(1);
					String sTextError = T("|not possible|");
					dp.draw(sTextError, _Pt0support, _vecX0, vecY0, 0, 0, _kDeviceX );
					return;
				}
			}
		}
	}
//End create 3d part//endregion 
	
	
//region display
	Display dp(252);
	dp.showInDxa(true);
	dp.draw(bd);
//End display//endregion 


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
		Element elHW =_Entity[0].element(); 
		if (elHW.bIsValid()) 	
		{
			sHWGroupName=elHW.elementGroup().name();
			
			// HSB-14106
			int z;
			if (bm0.bIsValid()) z = bm0.myZoneIndex();
			else if (truss0.bIsValid()) z = truss0.myZoneIndex();
			assignToElementGroup(elHW, true, z, 'I');
			
		}
	// loose
		else
		{
			//HSB-14106
			if (bm0.bIsValid()) assignToGroups(bm0, 'I');
			if (truss0.bIsValid()) assignToGroups(truss0, 'I');
			
			Group groups[] = _ThisInst.groups();
			if (groups.length()>0)
				sHWGroupName=groups[0].name();
		}		
	}
	
	// add main componnent
	{ 
		String sType = sFamily + "-" + sProduct;
		// In articlenumber we write the product
		HardWrComp hwc(sProduct, 1*iNrParts); // the articleNumber and the quantity is mandatory
		
//		String sManufacturer = mapManufacturer.getString("Name");
		String sManufacturerHwc = mapManufacturer.getMapName();
		String sFamilyHwc=mapFamily.getMapName();
		String sMaterial = mapManufacturer.getString("Material");
		
		hwc.setManufacturer(sManufacturerHwc);
		// Family is written in the model
		hwc.setModel(sFamilyHwc);
		//hwc.setName(sHWName);
		hwc.setDescription(mapFamily.getString("FamilyDescription"));
		hwc.setMaterial(sMaterial);
		//hwc.setNotes(sHWNotes);
		
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(_Entity[0]);
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
			
			HardWrComp hwc(sNail, iNumber*iNrParts); // the articleNumber and the quantity is mandatory
			hwc.setGroup(sHWGroupName);
			hwc.setLinkedEntity(_Entity[0]);
			hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
			
			// diameter of nail, screw
			hwc.setDScaleX(0);
			hwc.setDScaleY(dDiameter);
			hwc.setDScaleZ(0);
			
		// apppend component to the list of components
			hwcs.append(hwc);
		}//next i
		
	}
	if (_bOnDbCreated)
		setExecutionLoops(2);
		
	_ThisInst.setHardWrComps(hwcs);	
//End hardware//endregion 

//region check collision with other brackets
	_Map.setBody("body", bd);
	TslInst tslGAs[0];
	Entity ents[] = Group().collectEntities(true, TslInst(), _kModelSpace);
	for (int j = 0; j < ents.length(); j++)
	{
		TslInst t = (TslInst)ents[j];
		if ( ! t.bIsValid())
		{
			// not a TslInst
			continue;
		}
		// its a TslInst
//		String ss = _ThisInst.scriptName();
		if ((t.scriptName() != "GA-T") || (t.scriptName() != _ThisInst.scriptName()))
		{
			// not a GA-T TSL
			continue;
		}
		if (t == _ThisInst)continue;
		tslGAs.append(t);
		
		Body bdOther = t.map().getBody("body");
		if (bdOther.hasIntersection(bd))
		{ 
			if(_Entity.find(t)<0)
			{ 
				t.recalc();
				_Entity.append(t);
				setDependencyOnEntity(t);
			}
			else
			{ 
				setDependencyOnEntity(t);
			}
			Display dp(1);
			String sTextError = T("|Collision!!!|");
			dp.draw(sTextError, _Pt0, _XW, _YW, 0, 0, _kDeviceX );
			return;
		}
		else
		{ 
			if(_Entity.find(t)>-1)
			{ 
				_Entity.removeAt(_Entity.find(t));
			}
		}
	}
//End check collision with other brackets//endregion 

//region Triggers
//{ 
//	TslInst tslDialog;			Map mapTsl;
//	GenBeam gbsTsl[] = { };		Entity entsTsl[] = { };			Point3d ptsTsl[] = { _Pt0};
//	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };
//
//	//region Trigger Add Manufacturer
//	String sTriggerAddManufacturer = T("|Add Manufacturer to Defaults|");
//	addRecalcTrigger(_kContext, sTriggerAddManufacturer );
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
//			tslDialog.dbCreate(scriptName() , _XW, _YW, gbsTsl, entsTsl, 
//				ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
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
//}
//End Triggers//endregion 






#End
#BeginThumbnail
M0DUV?@4``````#8````H````D`$``"P!```!`!@``````$!^!0#$#@``Q`X`
M````````````________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________?__
M^O_^^?_]_/[^_O[^__[]___[___[_O_Z_O_X_/_X^?_Z^__Z_O[^__[___[_
M___^^O_[^?_[^O_^^O[_^?[_^?[_^OS__/S_^___^?_[]__[]O_\^_S__OS_
M__S___[__________________________________O[^________________
M______________W___W^__W^__[]___[___\___^___^_________/[^_/[^
M^O_]^O_]^?_[^O_]______W___S___S__?[__/[^_O_[_O_[__[^__W___S_
M__S__OW__/[__/[__/[^__W^__[]__[]__[]__[]_O_]_/_]_?_^^__^^__^
M_?_^_?_^_O_]_O_]__[]_O_]_/[^_/[^_________/_]^O_]_O[^_O[^_/[_
M^___^___^____O[^__[]___^___\_?_^^__^_?_^_?_^___^__[]__[]__[]
M__[]__[]___^___^___^_?_^_/_]^O_]____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________?__^__^^O_^_?________[^
M__[]___[___Z___[_/_[^_[\^_W]_OW________^___\^O_[^?_[^O_^^O[_
M^?[_^?[__/W__/W__?__^O_]^?_[^?_[_/[^_O[^____________________
M_____________________O[^_O[^_________________________OW__OW_
M__[^__[]___^___^___^_________/[^_/[^_/[^_/_]^O_]^O_[^O_[_O_]
M_O[^__W__?W__?[__?___/_[_O_[_O[^__[^__W__OW__O[^_/[^^O[__/[_
M__[^__[]__[]__[^_O[^_O[^_O[^_?___?___?___?_^___^_O_]_O_]__[]
M_O_]_/_]_/[^_______^_/_]_/_]_/[^_/[^_/[_^___^O__^O___/[__O[^
M___^_?_^^O_^^?[_^O_^_/[^_______^__[]__[]__[]___^___^___^___^
M___^_/[^_/[^________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________^_?_\^__\_?____[__OW___[^___[___[___^_/[^
M_/S__/O__/S__/[__?_\_?_[^O_[^O_]^O_^^?[_]___^/[]_/[^__[^__[_
M_____O_]_/_Z_O_W_O_W___[___\___________^___^___^___^___^___^
M_O[^_O[^_O[^_______________^_?__^OW_^?S_^OW__/[______?__^___
M^___^O[__/[__/[^_O[^_O_]_/_[^__^^__\_/_Z_/_Z_?__^_[_^_[_^___
M^O_]_/_[_/_]_O_[_O_[_O_[_/_[^O_]^?[_^?[__?___O[^_O[^_OW__OW_
M_OW__OW___[___[___[________^__[]___[___[_O_[_/_[_/_]___^___^
M_O_Z_/_[_/_]_/[^^O[_^O__^/__^/__^?[_^OW__?__^___^/S_]OS_^?W_
M^?[_^___^____?_^_?_^_?_^_?_^_?_______________OW__O[^________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___^___^__[___[___[__OW__O[^_O_]___^_?___/S_^OS__/S_^____?_\
M_?_\_O[^_OW_^O[_^?[_]_[_]OW__/W___S___S___W___W__O_[_O_V_O_V
M___^__[____________^___^___^___^___^___^_O[^_O[^_O[^________
M___^___^_?__^?[_^?W__?___?_^___^_?_^^___^O__^OW__/[__O[^_O_]
M___[_O_[_?_^^__\_O_W_O_X_?_^_?___?__^____?_^_?_\_/_]_O_[_O_Z
M_O_Z_/_Z^O_[^O[_^OW__?___?_^_/[^_O[^__W___W___W___[___[___[_
M_______^__[]_O_]_O_]_O_]_/_]_/_]_______^___Z___Z_O_]_O[^_/[^
M^___^O_^^O__^O[__/[__?___?__^?S_^/S_^OW_^O[_^___^__^^__^^__^
M^__^^___^____?___?____[___W___W_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________O[^_O[^__W___[___W__?G___O_
M__[__/O]_?__^__^^__^^/W\]_S[_/[__/O]__[__OC]__O___G_^OS]]O[^
M]OS_]?O_^?K__/G___C__?7___O___[__?_Y_O_[__K___G___S________^
M_O_]_O_]___^___^___^_?W]__[__OW___________[]___[___\_?_^_?_\
M___Y_OWS___X___Z^_[\^O[_^_[__?________[]___[__[]_/[^_/_]___X
M_/OQ___\______W]__W\_?OZ___^____^??W___\___Y___[_/WY__[__?S^
M_/_[^__W___[___[__WY__[[___\__WX___Z___[__WY_?SX___^^_W]^?W^
M^?W^^_W^_?___OW___W]__SW___Y__[Z___^___^___\___Y___Y______[_
M___[___[___^___^__[Z___\___Y_?_Y_?_\]?KX^O_]^?_^^O__^___^OS]
M__[___W]_____OS\_________________OS\__[^_________?O[________
M_OS\____________________^_O[_________?W]_____?W]____________
M_____/S\________^_O[____^_GY_?O[__________________W]______[^
M__[^______W]______[^__________W]__W]_________?O[____________
M__W]__W]_____________________?W]_________?W]_____/S\_____?W]
M_____O[^____^_O[_/S\____^_O[________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________O[^__S__OC]__O___W___W___[_^OG[^/KZ^O_^\_CV
M^__\^__^]_GY^_S_^_C___K_[>G_\O#_Z_/_V>7_U^#_T-?_U=O_V][_V]G_
MY.'_W=S_[O'_\_K_]?S__/G_^//___S____________^___^___^___^___^
M_/O]__[___[_^?GY___^^_KV^_OU]?3J[^WB\.W>].[;\^W:[>;5^/7G_/SV
M_?_^_?___?_____^__[]___[__[]_/[^_O_]\_+D^?3E[NC=\>KA\^WB\^_D
M[NG@___Z___^__[]___[___W___U__[S___Y___X___S[^_=W]S-U,_`R\2U
MR,"OSL2ST<>VWM;%^?+A___U___X_O[X^_SZ_?__^?W^_/[__/[_^_K^____
M___U__WR___W___X___X__SQ___T___S___W__WT]NW@]>O:]^[@___Q___R
M___P___U__[S_?OS___[_?_^]_S[^/W^^OW_^_W^_?W]__[^__S[______W]
M__W]__[^_OS\_________?O[__W]_____?O[\.[N[NSL[NSLZ>?G[NSL\/#P
M_?W]_____O[^_____O[^^?GY_O[^^_O[_____/S\_O[^____^_O[_?W]____
M__[^__________[^_?O[__W]______________W]______[^_____OS\____
M__[^__W]_OS\______W]__[^______[^_?O[__W]________]O3TZNCHZ.;F
MZ^GI[.KJ[.SL]/3T^OKZ_____O[^_____/S\_O[^^_O[^OKZ_________?W]
M_O[^_?W]_O[^________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__O_^_CZ___[___Y_/[X_O_[_____OW_^OG[____^_[\^O_]^O__]_O_]_K_
MYN__W>__D:?H0%:H$":%&RF3'"J4'BZ/'BN-'2B0&B.*(2Z*=XC+W?7_Y?K_
M]O[__/W__OW____________^___^___\_?_^_?_^_OW_^_K\__S^_____OKY
M___[___Y8%U.+R@/,B@*-RH*-2@(/C(60CHC___W_O[X___^_______^__[[
M__[[__[]_/[____[?7=D+",(-BL0-BL0+R0(-2T0-"P5].W<__[U__OV___X
M___T___QTLRUGI-]9EQ$03D<-2T/,B@*-2H,."L+."P*.RP+/"T,/#`.-BT,
M65,VG)B`X=[/___X^_KV_O_]]_KX_?___?W]___[___TX]S(Q;NIKJ./CX1P
M=6E17U$T0S48."@1."@1-20)/2L,/2L,.RP,44$D>6M/LJ6+\>;2___T__SS
M_?SX_/[^^?W^^_[_^OS]_______[__[Z_/KY_________/KZ_OS\________
MY>/CT<_/M;.SL:^OM[6UL[&QL[&QM+*RKZVMM;6UKZ^OM+2TOKZ^T]/3____
M____________^_O[________ZNKJU=75O;V]KZ^OL:^OLK"PLK"PM[6UR<?'
MX=_?]O3T_____OS\______W]T]'1L:^OLK"P[>OK^??W__W]________^_GY
M__________W]____V-;6O[V]KZVMLK"PM+*RM+*RM+*RM+*RKJZNKZ^OL+"P
MN+BXO[^_TM+2XN+B\?'Q________^?GY^_O[_O[^________^_O[________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________?S^_O[^_?_[^O_U^/_V
M^__[___^_O[^_____/KZ_?__]?O_Z_;_Y?+_WN[_D*;@.%FH*5"S($*Y#RRR
M#!ZK"1>E$!^C#B&B#B"I$22M#R2E*T&JA:+?W/3_Z/3^]_O\_OW___[_____
M___^_O_]___\_?_^_?___?S^_OW___[___[^__W\__[Y_?SR8EY+."T-/BT&
M02T$02\&/"P(3$$E___S_OST___^______[]__[[__[[__[]_/[____Z@7EB
M."L+."H&.RX(/2X'.RX(,B<)]NW9___W___Z__[W]_+C.#(;+R4'."H-/RX-
M.RL&/"T&0"\(/BT&/2L"/2P!/BT"/BX`/C$#.S`$-"L%-RX-,RP1:F-0^?'D
M___X___[^__Z_?[\___V,RT6+R0(."P0-B@+.RP,/2T)/"H!/RT$02X-/RP+
M0RT)/RL"13$(0R\&/2D`/2H%0B\,.2D,:EU'U,N]___W___\____^_W]^_W]
M___^___[___\___^_____OS\________T,[.M[6UL:^OM+*RL[&QM+*RM+*R
ML[&QL[&QM+*RMK2TMK:VK:VML;&QLK*RM[>W^/CX_____O[^_O[^_O[^ZNKJ
MMK:VM+2TL+"PL+"PM;6UL:^OMK2TM[6UM;.SL[&QL*ZNL[&QOKR\X^'A____
MX^'AK:NKM;.SM+*RXN#@_____________/KZ______W]_?O[UM34L:^OMK2T
MLK"PM;.SMK2TL:^OL*ZNM+*RM;.SM+2TKZ^OL+"PK:VMLK*RLK*RL;&QKZ^O
MM;6U]_?W____________^_O[^_O[________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________?_^^/W[]OWX^/_^^O_^^/OY^OGU__WX_OS[
M^OW_Z?+_W.W_BZ7G/UZY'4.O&42]$D##$CW*#S'$!QJQ#ARR$1^N!A>D"!ZL
M`!6G!1VS(3G!,4>QI;C[[/;_^_[__?[___[______O_]^_[\_/_[_?_^_?__
M_OW___[___[__/KZ__WY___Y__[S8UY)/"P(0BT`2#`"12X!/"D#34(D___Q
M___X___^_O[^__[]__[[___Z___[_/[^___Z?G1</BX*0"T'0"\$02X!/2T#
M.RP,^N_;__WV__[]___\]?'F+R<0-2H,.28%02L'/RP!/RP`/RD`/RD`02X#
M1#$$0C`!/2X`0C,"03,"/3`".BX$."P(0#,33D$G\NG5___R___X^_[U___T
M.3$3.B\).BT'03$,.BD"0B\$0"P`02T`/"D#.B@#1#$&0BT`.R@`02X!1C$$
M02L!0RT$02X).2<*.BP5I)J)__[S___Z___\_O_]___^__[Z___\_OS[____
M__[^[.KJO;N[LK"PM+*RM;.SM;.SMK2TM+*RL:^OLK"PL[&QLK"PKZVML:^O
ML[&QL:^OLK"PN[FY_____OS\______W]X^'AL[&QM;.SLK"PL[&QL*ZNM+*R
MM+*RL[&QKZVML*ZNMK2TMK2TM+*RM[6UMK2TPL#`P+Z^LK"PM+*RL[&QZ.;F
M_?O[______________W]__[^Q</#LK"PN+:VM+*RL:^OL[&QM+*RM+*RM+*R
MM+*RL*ZNL+"PL;&QMK:VLK*RM+2TL;&QL[.SL[.SL+"P_________/S\____
M_____?W]_O[^________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_/_]_?_^^/W\^O_^^O__]_S]^?W^^O[_]?K_\/?_XN[_I[OR5&_`($.K%CZ\
M&$3-%D76#3W1#CK3%#?4"!NX#AJT$AVT#ARP"AZS!!RR`!.Q%B[&*3_&.4ZQ
MQ]7_[O7_^?K___[___[__O_]^_[\_/_[_?___?___?S___[_^O?Y__W]___\
M___U___S:&)+.RL'23(%1"P`0RP`0S`+5DHN__KM___\^___^O[___[]___Z
M___X___Z_/_]___X@'=</2L&0"P#1C$$2#0%0"T"/2X.]NK8__[Y__K[___\
M\.[C+"8//C`302L(1"H%0RT#1#$&13$(0B\)02X)/BP'/BT&0C((/3`"-RL`
M/3$!/B\!0C((/"L$/2H';F!$___Q^OSP_?[T___Q/3,1/2\%134+.2D`/BT"
M0C`!2C4"1#``/2L&/2T)/2T#/RX#134+.RL!0"T"12\%0BP"1C`'0B\*.2<(
M-2<0J*"/___U___[___[_?OZ___^___^____________N[FYL:^OMK2TK:NK
MNKBXM+*RL:^ONKBXRLC(T<_/U]75V]G9T<_/T<_/Q</#MK2TM+*RNKBX_OS\
M__[^____^??WLK"PO+JZM+*RM+*RL[&QMK2TL*ZNN[FYO[V]O+JZM+*RL:^O
MLK"PL[&QL[&QLK"PL:^OM+*RL[&QKZVML[&QZ^GI_OS\__W]__[^_____/KZ
MQ\7%L[&QLK"PL*ZNL:^OL:^ON;>WR\G)WMS<Y>/CY.+BX=_?V]O;S\_/N;FY
MM;6UL+"PL+"PL;&QLK*RKZ^O_/S\_O[^_____O[^_________?W]________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________?[\_?[\__[^__[__?G^
M^?C_]?O_Y/#_TN7_F+/S46_()DFW%CN[&#_*&D'3$SO/#SK-%4#7%T#=%#?5
M"AZY#AJT$QBS$!6P!1*J#1ZU!!NS%3#'&SC)*D?`2&"TW.O_\//__/O__?__
M_?_^_?_^_?_\_?___?___?S_^OG]__[__OS\_OOV___V__[P:F1-/2X./BD#
M0RT$13$(-R8%2#XF___X^/W\]_W_^?[__O[^___Z___X___X_/_[___V@GI<
M.RT#0C($13$"0R\`0"P#.RL.^.[=___\^?GY_?_\\O7F+"@/,R@(02H*1BT+
M/BL(/"T,.2L..RP20C0>13@B0#,=.S`5-"D+-RX).BX&."L`/RX#0B\$2#((
M.2D%V-*____W___X___Q/3$/.RL!0S(+/RX'03`)/"L`/BP`/BP#.2L.-RP0
M-2H*."P*,B<)-2H,.2L'/BT&0"T"0"H`02X#02\*.BT--2L3QK^N__[U___[
M_/KY__[___W______OS\O;N[MK2TLK"PM[6ULK"PLK"PS<O+\O#P__W]__W]
M_________OS\__________W]______[^Z^GI_________OS\R<?'M;.SL:^O
MM;.SL:^OM;.SY>/C__[^__W]_________?O[\_'QY.+BS<O+M[6UKJRLL[&Q
MM[6UL[&QM+*RL[&QY^7E__________W]__W]V-;6L[&QL:^OMK2TMK2TKZVM
MV]G9_?O[______W]__W]__[^_____O[^_____/S\^?GYV-C8M;6UL+"PMK:V
ML;&Q_?W]_/S\_____O[^________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________^__O\__W^__[__O;]_/G_Y>W_L,/\3&JW(46I
M&T2_$CW($#O2$CW:#C?3%#[7"C7,#CC1$CG8%C;5$RG$"QFR#Q.R&AV\$1FS
M!A2M!QRT$R[%&CG2'3[))T>X77;&X>O_\_7_^_[__?___?___?___?___/[^
M__[___O__OO]___^___[_/OQ___U8UQ(.2P,/BP'0"L%02X(.2@'2C\I___W
M^___]_W_^?[__O[^___[___Z___Z_/_]___T@'E8.2X"/BX`0S`#12X!02P&
M.BH-^>_=_OOV_?_^]OSWZ?#C+2P8,"D0544NCGQEIYJ$TL>S_/#>__[P___S
M___U__WS__[OP[JF3$,H."P(0S,)/BL`02T`1RX"02T*E(UY___V__[T___P
M/C$103`).BD"0"\(.BD"/2P%0#`+8U8V@WMDFI.`N+*;PKREO+6BFY2!7E0\
M.RT0/BL%1"X$1C$$1#$&.2@!.RX.3$0M___T__SW____^OG]_?S___S^U]75
MMK2TL[&QM[6UL:^OMK2TZ^GI_?O[_____OS\_OS\______W]____________
M__[^__________[^______W]____M+*RL[&QL[&QLK"PM+*R\.[N_?O[____
M_____?O[__W]______[^__________W]RLC(L:^OL[&QM;.SM;.SL[&QZ>?G
M__W]_OS\______[^M+*RM;.SM;.SM+*RM+*RXN#@^OCX______[^________
M__[^_____?W]____________Y.3DL;&QKZ^OM+2TJJJJ_________/S\____
M____^OKZ____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__S]__[_^OKZ__[___S_[^K_<8#%*T6I)4:[&T+"%D#($3_-#CO2"CK5"3O3
M"SW5"CS6#3K7%3S:%3;3&#/*!ABQ$!:U%!:X$1JX`Q*N!QFT$RK&%S;3%3O/
M%C_$(T>R@97<XNS_[_;_^OW_^?G__/S_]OOZ_?____O___W___W^___[_O_X
M_O_W__[T85I)-BL+.BL$/2T#02X(/RD%4T(G___V_/[^^?[]_/[^______W^
M__S___W^_O[^___S@WQ;/"\#/BX#0S`%1BX$1"T'/"H-^.W9___U_?_\^?_Z
M\?7O@X1ZX-_5___W___Z___[__WY__SX__SU__WV___X___X___U___R[N71
M0#$003`%2#("2#`"12L#/BD*;&-/__[P__[V___S0C070S`*.RH`0C('/R\$
M.BT':5Y"___N___R___U___S___S___Y___W___VJZ&//2L,0R\&0RP`0RP`
M2#$$/"D#-RD,LJN8___[^/K[^OW_^OK___[_M;.SM+*RN+:VL:^OL:^OZ>?G
M__W]_________________________________?W]_O[^_________O[^____
M______W]M+*RL[&QM;.SLK"PQL3$__W]______W]_________O[^_O[^_O[^
M_O[^____________VMC8LK"PMK2TM;.SMK2TZ>?G______[^_?O[Z.;FLK"P
MLK"PMK2TM+*RS\W-_________________________________O[^________
M____YN;FM+2TLK*RL+"PL;&Q____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________W^__S]_/[^_?____G_
M[>S_/$ZK"":C&#7`'CW.&S[.%#S0#3K1"CK5"3W7`CC3##_<#S[<$3K6%CK4
M&SS2!R"V"A:R$1BU"A:R$!^["!JS#B>]&#W3%4#5#CW.&D7$*4>LH;3WY_/_
M\?C_^_S_^_O_^O_]_/_]__O___W___S]___Z_O_X_O_W__WU8EM*-BL+.BP"
M/2T#02\&02H$54,F___U_/_]^_[\_/_]______W___S___W__O_]___SA7Q;
M/"X$/BX$0R\&1BT%1"P(/BH+^NW7___T_O_[_/_]_/_]___\^OOW^O_^^?W^
M^OG[__[^__[____^__W\_?SX_?[Z___[___W___O85,V02\&1#`!2#$#2"X)
M/"@)4D<Q___P___Y___Q0#`302\&02X!0#`!/S`"."P(8UU&___R___W___Z
M___W_?_Y_/W[__W\__[Z___WH91Z.B@#3#0*12T`12X`1#$&/BT,;&%+___Y
M^OS\_?[__/W_W][@L:^OM;.SLK"PL[&QS<O+^OCX____________________
M_____________________O[^_O[^_O[^_O[^_O[^_/KZ]/+RL*ZNLK"PM;.S
MLK"PT<_/______[^_____?W]_O[^_____________O[^_?W]_/S\____W=O;
MM;.SMK2TL[&QM[6UZNCH____________R,;&L[&QN;>WLK"PM+*R_?O[____
M_____________________________O[^____________YN;FL[.SLK*RL+"P
ML;&Q________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________^__W]____^_S__/K_YNO_&2^5`!VD"!VN$R2Z
M(3;-(#K4%#K6#3K7!S?5"SW="SW=##S:##C3$3S3$3W0!"F[!!RL#1NO"QFQ
M!!*J#R.Q!R2N#CS%"T#,#3[0#3G(&T+"+$RKO]?_Y?/_\??^_?__]OWV^/[Y
M^_S___W___S]___[___[___Z___U8EQ)."P*/"P"/BT"0S`%02L"54,D___U
M_/_]^/_Z^?_[_?_^_O_]_O[^_/_]^O_[___RA7Q;/"X$/BX$0R\&1"X%0BP(
M/"H-^.W9___W_/W[_?[\___^___Z___X___\^__Z^O_[^?WX^OKZ_/O]_OW_
M_/[^^O_]_?_\_OST___T23TE.BL*03$'/BT"/RX'.RP+4D@P___R___U___P
M13,40"T"1#`!03``/S`"."P(8UU&___T__[Y_O_[^__Z_/_[_?_______O_]
M_?SR___N2#L;/2H$1C$$0RX!0S`%0"X).2P2__SO__[Z___[___^P;^_L[&Q
ML:^OM;.SL[&Q\.[N____________________________________________
M_?W]_?W]_O[^________^_O[\_/SM;.SM;.SLK"PM;.ST,[._OS\__[^____
M_/S\_?W]_O[^_O[^_?W]_O[^____________WMS<L[&QMK2TL[&QNKBXZ>?G
M_?O[_OS\____MK2TL*ZNLK"PN+:VS\W-____________________________
M________________________YN;FL[.SLK*RL;&QL;&Q________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__S^__[_____^OG[_?G_T];_%2F4"!ZL#!JN$1RT$!RX&BW*&SG8$#C7#SS:
M!C;4#CW;#3W9$3W6$3S1"SK+"C+`!1^I$B*J%""H&2:F&2J9'CFH%D'`"3[*
M#3_5#3S4$D'2'$>\.UNFS.+_ZO?_^/__^/[Y_?_\_/W__?[__/W[___[__W^
M__[]___T9%Y'.BP(/2L"/BT"0S`%02L"54,D___U^O_^^/_\^?_]^__^_/_]
M_/[^_/_]^?_[___SA7M=/BT&/RT$0R\&1"X%0BP(/"H-^.S:___X_O[^____
M_OWY_?OQ___U___W___V___R___R___W___Y___[__[V___U___T___TF)%]
M."L1.BL*/2P%03$&."H`."P*;&5,___T__[T___S1C050RT#1#`!0"X`0"\$
M.BP(95Q(___U__[Z_O[^_/[^^O_^_?__^/OY_?_^_O_V___O@WI?.RL&/BT"
M0"\$/BP#/RP&."@+ZN'3___X__OT__KUM[.RMK2TL*ZNN+:VO+JZ__[^__[^
M__[^_________________________________O[^_O[^_________O[^____
M_____?W]L[&QJZFIM[6UL:^OP;^_______W]________________________
M_____O[^_?W]____X-[>MK2TM;.SK:NKM;.SZ>?G________\O#PL:^OM+*R
ML:^OM+*RYN3D_/KZ____________________________________________
M____Y>7ELK*RLK*RLK*RL;&Q____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________[__/G___W____^_/O]__?_
MN[?K&B64"QFH%!VT$1:Q$!FW"ABX"B/%%3?7$#G5$3W6$#K3$#O2%#W5#CG,
M#CO(&T')#R*G%!^9(BB3/T29E9C5O<G_*$:]$CW0##S8!CS7"#[1"S[$'D6Y
M57/&V?'_Z/G_^O[__OW___S__O[^^O_V_/_Z_OS___S____R:F%&/"P(/RP!
M/BX`0S`#02L!4T,F___V^O[_^/W^^?[_^____/[^_OW__/[__/[^___VAGI>
M/BP'/RP&0R\&1"X$0"T(.BH-]NS:__[Y^OKZ_OS\___[__ON___N___NN+*;
MB8%<?'%+;5]":5L_:UQ":EY":%Y`:%Y`4D<I.RP,.2<"0"X%1C,&0B\"0S,(
M.BX,EH][___T___[___V0C`31"X%1S`#02P`0BX%.BL*95M)__[U__W\__[_
M_/W_^O[_^OW[_/_]_?_^_?_[___RL*R4.R\-/2P%/BT&0"T'0BX%/RP+Q[VK
M___V___V^/#IM;&PL:^OM;.SL:^OT,[.__W]______[^________________
M_________________O[^_O[^_________?W]_?W]________O[V]M+*RMK2T
ML:^OM+*RY>/C_________O[^_O[^_O[^_?W]_?W]________________W=O;
ML[&QM;.SLK"PN;>WZNCH__W]____ZNCHM+*RLK"PM;.SKZVM\.[N________
M____________________________________________Y>7ELK*RLK*RLK*R
ML;&Q________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________[__OK_^OG_^_W]_/S_]N__FI72&223#1RH"A6L$!FV
M"Q:T"ABX`QFY`A^]$C3-&T#0&3_#'4/!&SVX'D"W*TV^*D2N+SN@;'#(KK+Y
MYNG_]/7_W./_*D*R$SG-"SC6"3S9"$#5"T#0&$;0'46V:8K/VO#_\OC_^_C_
M__O___[]^O_V^?_Z^OW___S^___S;F-(/BL(/RP!/BX`03$#/RP!4T,F__[W
M_/W_^?S_^OW__?___OW___W___W___W___[WB'E?/BP'/RT$03`%0B\$0"T'
M.BH-]NS;__[[______S[__GR___QIIN%2D`H-"H,/"\#/S`"02X(0B\*0"T(
M/2P%0"\(1#,,.RH#02X(0B\$13`#0BX`0"T`03`)-RD,V-'"___X___\___W
M0"\41"T'0RT#0RT#02T$/"L*9UQ(__[U__WZ__[__/W__?_____^_O_[]OGW
M_?_[_/_UT]*^."T-.RP%/2T(/BT&1"X$/RP)MZV;__WT___X\.CALZ^NLK"P
MM;.SL*ZNV=?7__W]____________________________________________
M_O[^_O[^_____O[^_________?W]RLC(N[FYLK"PL*ZNMK2TM+*RW-K:__W]
M_/S\_____________O[^_____O[^_?W]__W]WMS<M[6UL[&QL:^OMK2TZ^GI
M__[^_?O[Y^7EM;.SKZVMLK"PMK2T^_GY____________________________
M________________________Y>7EL;&QLK*RL[.SL;&Q________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________[_
M_?S_^/K_]OW_\??_[.G_9VFO%2>2#B6I"1VP`QBP"1NV!QNV`QNQ`QNP!1VR
M%2ZR.5B[4&^^;HC.BJ'?HK/KR-3_Z>O_ZNO_[O/_[//_]?C_V^C_.5>\&D+0
M#SC4$#W;##O2%4;8!CG+$#_&(4:XB:'SX.K_^_O___K___W^^_[\^O_^]__^
M^O[Y___S<&)+/BL*/RL"/BX`03$#/RP!54,D__[W_OW__?S__OW_______[^
M__W^__W^__W^__[VBGE?/RP'/RT$03$#0C`!/R\%."H-]NS;__WZ_OS\__SY
M___W@G=A-2H,,28&/S,/.BT'/"T&/"P'/2T(/2X'/R\%/BX$/2T#02X(/RL"
M2#,&/BD`0S`#/RP&0"X/8%(____V_?_\^/W\___V0S4902P&0BP"12\%02T$
M.RL'9EM%___R___W__[]_OW__O[^__[Z___Z___\_?_Y___Y\>_=-RH*03`)
M/BX)/"L$0BP"02X+K::5__WU___ZZ^;CL*RKM;.SLK"PM+*RW=O;______[^
M_________________________________________?W]_O[^____________
M_____?W]____M;6UL*ZNM;.SLK"PM+*RM;.SM+*RO;V]Q,3$RLK*R\O+Q\?'
MP<'!NKJZM;6UL:^OLK"PL:^OM;.SL[&QLK"PZ^GI________X-[>L*ZNMK2T
ML[&QM;.S__W]_OS\____________________________________________
M____Y.3DL+"PLK*RM+2TL;&Q____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________?__^_[_^?S_^/[_[O+_ZNG_
M.T"+$".2"R&H`Q>J"!JS#!RU"ANR!QFL!AFJ"QVP%2>DE:?ZU.;_V>O_W>O_
M[_?_\??__/W__?__]?K_]?O_^?W_X^__.5FX%C[&$CG1%CW;$SG3#SG.#S[5
M%$#3&S_+,DR^NLG_[/#__OC___W^_?W]^__^]O_\^O[X___S<&--/RH*/RL"
M/BX`0#$#/RP!54,D___V__W__OW__O[^___^___[__[]__[[__[[___UBGE?
M/RP'/RX#03$"0C$`/R\$."H-].S;___\_OS\___[N+&B-"@,/2\+/"P'.RP%
M/"H%/BP'/2T(/"P'/"X$/R\$03$&0C`'0"T'/"D#/BP#/RT$.RP%.RP,3CTH
M\N;:___X^/W[^O_____V0S@:02\&0S`#1"\"0"T".RL&9EU"___O___V___Z
M_O_]_O[^__W\___\^_GX_/WY_O_Z___Q.RP+0S$(/RT(/2P%1"T`0"X)G9B)
M___\___[Z.;EK*JJLK"PL[&QM+*RY>/C_OS\________________________
M_________________O[^_O[^_________?W]_?W]________^_O[Z^OKN;>W
MLK"PL[&QLK"PM;.SM[6UJ*BHKJZNLK*RL;&QKZ^OL+"PLK*RM+2TKZVMM+*R
MMK2TM;.SM;.SM;.S[NSL_OS\__[^Y.+BLK"PM;.SL:^OL*ZN____________
M____________________________________________Y.3DL+"PLK*RM;6U
ML;&Q________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________?__^/__]/O^^_[_]_?_Y>3_+#!_&2:@"QJL%B"T%!FQ
M$Q6O$!6N$Q^S#1NO#!JN%"">=GG*Y>?_Y^[_\_S_\/G_]O__^/[Y_/_[^?S_
M^_S_^_K_Y>[_0F2^%T'"$SC.&#K:&3C5&SK5&SW6%#7+&SO0*$/#0U>OS=K_
M]/7___[___[]___\^O_^_?_\___R9UQ&0B\.0RX(/BX#03$&/BL`5$4E__WR
M__[]_?[\^__Z_/_Z_/_V___Y___W___X___NC7QA02X)/BT"0#`!0S(!0#`%
M.2X0\^O:___\__W\___V6%$^-RH*.RL!03`%0"T`2#((02L"02P&0S`*/2L"
M/RX#0C`'/BL%0"P)0"T,."D(.BT--RP0>&U9^>WC__KV___Z^O_Z^O_\___S
M/30203$#02\`1#`!/RP`/"T&9U]"___M___R___Y^O[Y_/[^__W]__[__/S\
M___^___[^O/B/"P(/RP!0B\)1#`'12X!0C`+HIV._?_\^OW[Y.;FM;.SL:^O
MM;.SM;.SX-[>_?O[_____?O[_____?W]_____O[^_/S\_____O[^_/S\____
M________________________________^_O[[.SLO[^_KJZNL[.SMK2TL[&Q
ML[.SM;6ULK*RL+"PL[.SL[.SKZ^OK:VMN+:VMK2TM;.SKZVML[&QL[&QZNCH
M________YN3DL*ZNLK"PN;>WKJRL______[^_________/S\_?W]_____?W]
M^_O[_________/S\_____O[^Z>GILK*RL+"PKZ^OL;&Q________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________?__
M]_W\^O__^_W^\O+_\/'_,SJ#&RRE"AZQ#A^V"ABQ$ARV%B"Z"1>P"1JQ"!RQ
M$B.B.CV8X.'_[_/_]?O_]_[_]?W\^O_[^O_\^?W^_?S_^?;_Y>O_57'/&3Z^
M'#W0%S+0%2W-'3;4%2O&&C')&##(%"VS*D&G:'J[[/7__/[^__[]__[]_O_]
M_O_[___T9UQ(/RP+0"L%0#`&0#`%/RT$3T`@___U___\_O_Z_?_[^/_X^__[
M]OKT^/SV^_SR___PAWE<.R@"03$#0S0#0C$`/BX#.BX2\NK9__WY_?SX___V
M,BH3.RL'0B\$0B\"0"T`0R\&/RP'/RT.5T<J850T7$\O7D\O85$T7U`V8%([
M>F]9E8QXYN#-__[Q__OW___\___Z_/_X^__[___R/C0203$#02\`0B\"1#,(
M.2P&95]"___K___S_/[X^__^^____?S__/O___[__/S\___[X]S)0"T*2#`&
M13$(/RD`1R\!/RT(L:R=_/_[_?_^Y>?GLK*RL*ZNL*ZNM;.SV]G9__W]_OS\
M____^_O[^_O[_________________/S\____________________________
M_________O[^________^OKZY^?GS,S,O+JZM+*RL;&QL+"PL[.SL[.SL;&Q
MLK*RL[.SL;&QN+:VNKBXL[&QM[6UM+*RN;>WZ^GI_____/KZZ^GIL[&QL[&Q
ML:^ON+:V^_GY_________/S\_________?W]________^OKZ_?W]_O[^____
M_/S\X^/CL[.SLK*RL;&QL;&Q____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________?___/[^__[]_/S_ZO+_
MI+?P.UK')D_:%T3;%4#=$#3.#R[)"2+$`!6U`!VR`R.J%"F<DZ/PZ/7_^/__
M^/S]^?W^]__^]?_]^O_]^?C_]O'_T-'_%BR2!"&B!ARJ"AVT"!NX`Q:U#!>U
M#QNU"QNN#R.F%RN6<X;)Y_?_]__[_O[^__[^_?[Z___W__WV:EM+0"L+1C`'
M.BH`0#`&/BL%4T0D__SO^_OU^_WW^?_Z^O_^\?GX^/__^O__^__^__WRBWUA
M/2H$0#`"0#$`/B\`/3`$-RL/].O=___[___\UM/$*R0)0#$*0S`#0R\`/"L`
M."\*A'UB___R___W__SQ___U__OL___R___T___U__WT___X__WU___X___[
M__[Y___Z___Z___[___R0C,20S`%0RT#0BX%/RP'."D)9%Q%__[O___X^OW[
M^OW_]OG^_?S_^/C^^?K^_O[^___YL:B4/BL&0RP`0"@`2S0'2C($/2L&Q<&O
M_?_Y_?[Z_O_]LK"PM[6UMK2TL:^OQ</#_____OS\_____________?W]^_O[
M_________/S\____________________________________________^OKZ
M________^?GY_?W]________\O+R[.SL[>WM[N[N^/CX_____?W]____W=O;
MMK2TM;.SLK"PM+*R[>OK_?O[____\O#PL*ZNLK"PM+*RM+*RZ>?G_____/S\
M_/S\_/S\_O[^_____O[^_?W]_____?W]_/S\_O[^____YN;FLK*RKJZNKZ^O
ML;&Q________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________?OZ___^_?S^\/G_W.__6WW1*%C.&E3C#TWG
M%D_H&TSH($?I)4SK%T;=$#[+%S["3FW0U.K_[O?__?S___[_]_S_^/__^__^
M^/K_[.C_>WO'$B*3#R.J#R"M#1VP"!>S"QJW$1BU%!FT%1RQ$R"@$R2%L\7_
MZ/C_^/_\_?____[__?_Y___W__WV;%U-/2@(1#$&/BX$/S$'/2H$2CL;___R
M___U___Y___[]OOY^O__]OK_]/C]^/W\___W>FM102X(/R\!/B\`/BX`/S$'
M,B4+_O7G__WY_?WWRL:T,BH-/2\%02\`12X!/RT$1#T<___H__[T_/KY_O[^
M^?KX___[___X__SW___\____^_O[___^_?SX__SW___Z___Z__[[___\___S
M0C,312X(0RP&1"P(0BX+-B8)85E"___T___W_/W[_/W__?W__?S___[___[_
M___[__SO?G):0"T(2C,&12X!1C$$12X!.BH&WMK(___X___[___\M[6TM+*R
ML:^OMK2TN+:V_/KZ______[^_O[^_________/S\_O[^_________/S\____
M_____________________________________/S\_/S\_____O[^_____/S\
M_?W]^OKZ_O[^________________________W-K:LK"PMK2TM;.SL[&QZNCH
M__[^______W]M+*RL[&QL[&QL[&QV=?7_____?W]_____O[^^?GY________
M_?W]_O[^_____?W]_?W]_?W]YN;FL;&QL+"PL;&QL;&Q________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__[]__S]_?CY__S^_?[_[/;_S^;_27'$%U'.#U3G"$[B$E/K%4KG%DSG#DKC
M%5/G%U'@*5?-AZ3OX.S_]_7___C__?O_^_[_]OK[]/C_Y>G_-CR5%"">#AZM
M!Q:H#1VP"ANR$!ZW#ABR#!*K&!NS(2>D/4J6X_#_\/G_^__^^___^___^O_[
M___Y__WV;EY-1#`-/RP`0#`&.BL$/BP#1S03O[2@___R__[Q__[S___\__[_
M^??]__[____^__[S3D`D/BT&/B\!/S$!/R\!/2T(.BP6___V__WY_?WWR<6S
M,2D+.RT#0"T`1"P"/RP&6$XL___M___T___[_____?[\___[^_SS__[Z_/W[
M^OS]_?___?_^^_WW___Y___W__[[__[]___^___U0C(512T)0RL'12P*1"T-
M-R4(;&!(___L___V__SW__[___W^_OGV___[__WX___T_//?/2\2/BL%0BT`
M1"X$1S0)/RP&/"X1___R___W_O[X___\S,K)KZVMM+*RM+*RLK"PX^'A____
M_?O[^OKZ_/S\_________O[^_O[^_____O[^________________________
M_____________O[^_____/S\_____/S\_____?W]_____________?W]_/S\
M^_O[_?W]_____OS\Y>/CM;.SM;.SLK"PM+*RZ.;F______W]____P\'!N;>W
MLK"PM+*RPL#`________^?GY_/S\_____O[^_O[^_____O[^^_O[^_O[____
M_/S\Y^?GL;&QL;&QKJZNL;&Q____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________OS\__[__?___/S\
M]_K_Y?'_MM+_,V7%%%31$EKD"$[B#T[F$$[H#$_J"4WF$%+G%U#5-%[#E*[T
MZ/'_]O7__/C___W__?W_[?'_I*OP%B&)&R2J#1BO$R&W"QFQ"1JQ"1JQ$B"T
M$1NN%QBN(B.;?H;"Y.S_^/O_____^O[_^___^O_^___Y___U;F!*/BP'/BX`
M/"T&/2X'02T$0"T(-R@.B7YHZ-[&___P__SR__WY__O[__WY__WPCX1P.2D,
M/RT(/"P!/B\!/RX#/"P(959#___W___^___[U=&_+B8(/"X$0B\"02H$02L'
M/BX*WM.W___R__WV___Z___Z_?SR___W___X___W___Z___Y__[T___UR\:W
MM:^B__[[__[]___^___U0#(50RX(1"T'12T)0BH&0B\,2ST@J)^$].O7___Q
M___U___X___T___R___T[.72858X/2T(03`%02X!1#$&.RH#.BL*;F5*___V
M_?WW___\___\Y^7DMK2TLK"PL[&QL*ZNM[6U\.[N_________O[^_/S\____
M_____?W]_____O[^_________________________________/S\_/S\____
M_O[^_____/S\_O[^_____________O[^_?W]_________O[^_O[^____S<O+
MLK"PLK"PM+*RL*ZN\_'Q^OCX_____OS\X^'AL[&QM+*RM;.SL:^OW-K:_?W]
M_?W]_________O[^_?W]________________________Y>7EKJZNL;&QMK:V
ML;&Q________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________^?O[^___]__]^/__^OS]_?W_^/G_Y/#_J,K_)5FS
M&%;2#U/B#%'D#E+K"D_L$%/P"4KB&5CB&%C.)URWI\7^X.W_]?7___K_^?C_
M\?+_/D>A&"2B%1RI#A2M$1JW#AJX"AFV"QZU!1RH$B2M%1FG)2:6T=7_^/K_
M__O___[__?S__?W__/W____Z___O:V-%.BL$03`%.2D$/"L$0BP#1"X%0C(.
M.BL*/"\)<&(^N*N1SL"MULBVP;.=74XM0C(-/2T)/R\*/"P"/2T"/RT$/"L*
MK)R+__WU__S[_O[X___O.3$3."D"0B\$0BH&0RP,.B8#2#@;MZF6Y-S+__[O
M___P___M___K_/7BZ.'.SLFTL*J3>W19.2X2.BD/?6Y;___X_O_]^__\___R
M/C0203`%1"X$13`#13`#0B\".RT#-"H".BX*6DTMEXANKZ&*NJZ2J9Z"?W9;
M,2<)0#`+0C$&0"T`0S`%/2L".2D%.2X2N+*?_?[U_?_^_/W[__W\__[^NKBX
MM[6UL*ZNL:^OLK"POKR\_/KZ^?GY_____/S\^_O[_____O[^_?W]_O[^____
M____________________________________^_O[_____O[^_________O[^
M^_O[_O[^_________?W]_________?W][.KJM;.SMK2TM+*RL[&QLK"P____
M______[^______[^M[6UL:^ON+:VM+*RL[&QWM[>^OKZ____^OKZ_/S\____
M____^_O[_?W]_____?W]_?W]X.#@M;6UL+"PKZ^OL;&Q________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_?__^/W\]__[]__]^OW__OS___S^]??_W?'_BJ[J*US"'EK<#5+?"5#G#%#O
M#E#O"4SE"E#@$5C>&UK,,%^SLM'_X>S_\_3_]O7_M[CP'B>6%1^L$AFL%!JS
M$1:X#QB[#!BV!QBN"1VJ#B&F&2*B14BJ[O#_^?G___O___W___O__OW__OW_
M___[___N:V1#/B\(/2L"/"L$02X(2#`&0BP"/RP'/BP'/2P!/RX#/"H%/"H+
M/"P/."<&13('/BL`/2L"/2L"/R\%0C$*/2T)."H.X]C*___Y___^___\___R
M8UQ!.2L'/BL%02L(1"X+0"H'-R0#."<,.2P2,2@-.#$6.B\3/#(4-RP.-BL-
M-BL+-BL+-RL).RP+.B8'A75>___W_/_[^__[___R/C0203`%0B\"13`#1"X`
M0BX`/S$!/3`"/S(&.2H#0"T*/RP).RD$/RT(.RT)0#`+/"L`.BH`1#,(0C((
M."@#-2H*5T\X___S_O_[]_S[_?___?S^____\_'QL:^OL:^OM;.SM;.SL:^O
MN;>WV-C8_/S\____^_O[_____O[^_/S\____________________________
M_____________?W]Z.CH_____?W]_________?W]_____?W]_O[^_____?W]
M_____O[^\/#PN[FYLK"PL[&QM;.SLK"PR,;&__[^______________[^W-K:
MMK2TL:^OM;.SM[6UK:VMP\/#Y^?G________^_O[_?W]_____/S\____X^/C
MS<W-LK*RKJZNMK:VL+"PL;&Q____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________[^__[]___[^__\^_[_
M^_[___[__?W_\?;_VNS_78'-*E[)$E;9"5+D"4SI!4?F"5'K"E'H#4SB%5'9
M(EO/-&6[NMK_U>C_XN?_6UVK&R*A%1ZU$!FP#A:P%AN]#A.U$AJT$!FP#!BL
M%2&I&R>7@(C5[?#__OW___K___O___O___[^_/[___[Z___O;&)$/RX'0RT#
M/RD`0BP"1S(%02X#0"T,/"<'1#`'1C`&02T$/"L$.2D%/2L&02T$0RX!23($
M0R\`.RD`-RD%-RP0@'EF___X___[_/_]_O_[___US,:S.B\3/BT,/BL&02P&
M13(,/"H%/BP'/2T).RL&/"P'.RP%/BT&/S`)0#`+/2T).2L'.RP+.2H).BL+
M?7%9___V___\_O_X___M03040"P#0RP&0RT$1S`#2#0%.RT`/3,$/3(&/"X$
M0S$(/RD`1S`#02H`13`#0"T`0"T"/2T"/B\(-BH&.C`2.3(9U-"^__[T_O_[
M^___]?C\_?[___[___[^W]W=MK2TKZVMM[6UM[6UL[&QM+*RMK2TP;^_T]'1
MX=_?XN#@W]W=W=O;U=/3T<_/QL3$M+*RMK:V_?W]_____O[^_O[^____M;6U
MM+2TO+JZR\G)X=_?Y.+B[>OK\.[N\>_O[NSLY^7EVMC8QL3$M+*RN+:VL:^O
MM+*RL[&QL:^O[^WM______W]____^_O[____^OKZRLK*L[.SLK*RL;&QM+2T
MLK*RL+"PL[.SO;V]Q\?'R,C(P\/#N[FYM+*RM+*RKZVMLK"PMK2TLK"PL[&Q
ML;&Q________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________^___^___\_?_^^_[_^?W__OW__OW__/O_[_;_
MT.K_273#(U_1"T[9#5#I"$SK!4_K"5'K$4[J%%'G$U?@'%O-,V2RJ\W_J;K_
M&R2+%R&J#QJR$QRS%AZW$!>T$1>V%!FT$1>P$QNT$AVC&B:&LKKU\O;___[_
M__K___O___S^_O_]_/[^_O_Z___Q;&%&0C`+0BP"12T#1S$'/"P`0C((.R<(
M0BT102L'12\%0S`%/RT$.RH#.RD$02P&1C`&1"\"0B\$/2H'."P03D<S___T
M_O[X^_[\^OS\^OW[___W___SM:R8-RH0/2X..R@%/RT(/RP&/2H$02\&0"X%
M02X#1#$&/2H`/RP!/2L"0"T(/BL(/BT,-R@(-B8)?G-=___W___\___X___M
M0S030"P#0RP&0RP&1R\%02P`/C$%."\$.3$)-"H".BD"2#()1S`#1"L`23(%
M0"T"/"H!0#`+-BH(,B@*/C<>U<^\___T___W_?[\_/[_^_[_]_K^__[___[^
M____YN3DMK2TKJRLN;>WL*ZNM;.SLK"PLK"PM+*RM;.SL[&QL[&QM;.SM[*S
MM[*SKZVMM;.SM[>W_____?W]_________/S\LK*RL;&QL[&QLK"PM*^PN+.T
MLK"PL[&QL[&QL[&QM;.SMK2TM+*RL*ZNLK"PMK2TLK"PM[6UW-K:_____/KZ
M_OS\_?W]____^/CX_?W]____T]/3JZNKL[.SLK*RLK*RL+"PKZ^OL;&QL[.S
ML;&QKJZNLZZOM;"QM[6ULK"PLK"PL:^OM+*RM;.SL;&Q________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________________________________________^
M___\___^__[__?[_^O_^^O[__/W__OW_^_K\\_G_YO?_O-K_.67`)%K7#4WA
M"4[K"%#J#%+L"TSJ!4CC!5+E"E7?&US6-6C</F#7#B6C"1RE#1NJ$AJJ%!NN
M%!RU$QJW$A:U$A>T$1NU%B&A-CR/YNG_]?7__O[^_/S__?W_^?[\^O_[_/_[
M___Z___R:E])/2T)/BH!0RT$/BH!/BX#/S,+."<,.24,02T*02P&/BL%0"T'
M02\*0"T(0RP&02P&/2H'.2D,,B4+;V92^?'D__[V___^_/[^_?___/S\___^
M__[V___TU,R[3D,M-RD-/2H)02P&02P&1#`'/RL"0"H!23,*1"X%1"X%/RH$
M0RT)/"@%/RP+/RT./BP/@')?___Z_?_^_O_Z___M1#820"T"02T$0RT$0"H!
M1S(,7U$MAWY=,2H)-2P+-B<'/BL*/2D&.R<$/"D&/"P(/"T,-2H,-RP095Y%
MYN#-___S___T___[^_SZ^?O\_?[_^_S__OW______?O[__W]]O3TR\G)K:NK
MN;>WM+*RM+*RM;.SMK2TM;.SL[&QLK"PL[&QLJVNM[*SLK"PM+*RN+BX^_O[
M^_W]_?___?___/[^NKJZKJZNLK"PM;.SL:RMMK&RL[&QL[&QLK"PL[&QL[&Q
MM+*RM+*RM;.SL*ZNL:^OM[6UW=O;_____OS\_?O[________^OKZ_____O[^
M_____O[^ZNKJP,#`L+"PL;&QLK*RL;&QL+"PKZ^OKZ^OL+"PM[*SLJVNK:NK
MLK"PN+:VL:^OM+*RL:^OL;&Q____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________________________^_____?[_^_[_^O_^
M^O_]_/[__/[____^^O_^\_S_X_?_I<'_-V'&&U39"T_D#%#I!TWG#U+O"$WJ
M!%'M!E+K!DS?&57E'DS:`!VL!R&Q"1JI$QRL%AZN$1NO#QJR$!:U#Q:S%B&X
M%!V6AH?+\>__^OG_^_SZ^O[_^O__^/_Z^?_Z_/_[___Z___T:EY,-B<'0B\)
M02X(/BT&.BX&4$8D___M[-[,PK.9DX1D6$DI-RH*-2<*.BP//RT..BH-/C(:
M@'9DT<FX__[Q__[W___[_____/O]^_K^^/?Y__W]___^__SW___W__WPN[2A
M>6Q20C(5.BL+/"T-."<&/RX-.2@'.BD(.2<(.RP,/"P/.2L/7E$WHI1]T\:P
M___R__[]_?___O_Z___M1#<10"T`02X#0BX%1"T'/BH'95D]___JZ.++F9%Z
M23TE,R8,-28,-BD/-RH0,28+23TEBG]IS<:S___P___R___T___Y_?SX___^
M_____/[__OW__O[^____________________\_'QV]G9O+JZN;>WM+*RL:^O
MLK"PM+*RM;.SM+*RM;"QL:^OM+*RM+*RR\O+^_O[_?__^_W]^/KZ_?__U]?7
MO[^_M+*RKJRLL*NLMK2TM+*RM+*RM;.SM[6UMK2TL[&QL:^OLK"PO[V]U]75
M__[^______[^______[^_/KZ_____?W]_________?W]^OKZ_O[^_O[^Z^OK
MUM;6OKZ^LK*RLK*RL[.SL;&QKZ^OM;.SR<3%W=O;\>_OX^'AMK2TL[&QM;.S
ML;&Q________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________W__OW_^O_^^O_^^O_^_?_^_?_\_?_\^O[Y_/_[
M]_CV]/K_X?'_?IO@+%O'%E+:#U3G"4_I!DGD$%/P!4OL#5'R#U#N#$KD&4[E
M$C_6`!JS"R*Z#ARR#QNO#ARP#!JP$1FS%AZW#ARJ'B>6R,;Z^O3__OK__?[\
M^O_]^/_^]O_Z^O_[_/_[___Z__WV9EY-/"X1/BP'."8!03$-,RH%24,F__SO
M___W___T___R___P^_?EZ.76W]G,YM_0\>K;___V^??M___Y___[__SX_OS[
M______[^__[___[___W_^_O[__W]__W\__[Z___Y___Q___SV];'Q,"NP;VJ
MLZ^<M;&>LJZ;OKJGR,2RXMW.__SN___W___X_?SR___[_O[^_/[^_?_Y___N
M0C82/BX`/RX#0"X%.R8`02X-:%Q$__WJ___R___R___U_/'CZN'3[.33ZN+1
M\^S=___S___T__[S___W___Y___Z__SX___^_/S\_O[^^_O[^?GY_____?W]
M_/S\_/S\_/S\_________?W]____^_O[\?'QZ.CHY.3DX^/CX>'AWM[>[.KJ
M[^WM_____O[^_____?W]^OS\_/[^_?___?__^_O[_?W]_O[^\/#PYN3DW=O;
MVMC8T]/3S\_/T-#0U=75W=W=Y^?G\/#P_?W]_________/S\_O[^_?W]____
M_?W]_____/S\_/S\_O[^^OKZ_________O[^_________________/S\^?GY
M^_O[______[^__[^_?O[__[^Z.;FLK"PLK"PM;.SL;&Q________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________[_
M__S__OW_^O_]^?_[^O_]_?_\_?_[_?_[^__\^/SW___^^OO_\OG_W_#_98C8
M+E[.$T[9#5#H"T[F"DWH#U#O"4GK"DOJ$5#N"TCD'E3O%#W:`!FV!ARW!1:M
M#!RO$1VQ$1NO%1^M$R&C-3^=[NK__O;___[__?[\^O_[^O_\^?_[^__\___[
M___[__[Y95Y/-"<'.B<!1C,-/BP'.3`+2$0H___W___\__WX__WU___U___X
M___\_O_[___[___\_O_[_?_^]_CV___^__[^__________[^__[^_?O[_?W]
M^?O\_?__^___^O_^^_W]_O_[_?_Y___[___Y_O_V___V_/WS___X___X___Y
M_O_Z___[^OOW]_KX_?__^?O[_/[__/[^_?_Y___O0S<5/BT"/RT$02\&02P&
M0"\.8EA`___Q___U___[__SW__KU___X__SS___V___Y___W^_?R___\_OOW
M__W\___^___^_____?W]____^_O[_________________________?W]^_O[
M_?W]_/S\_O[^_O[^_O[^_O[^_________________?O[_____?W]_____O[^
M_/[^_?___/[^^OS\_________O[^^OKZ______W]_____O[^_O[^________
M_O[^_/S\_/S\____^OKZ____^_O[_/S\____]_?W____^_O[____________
M_O[^_/S\^?GY_____O[^_?W]_?W]______________________W]________
M____Z>?GLK"PL[&QL:^OL;&Q____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________W___[^^O_]^?_[^O_Z
M_/_Z_O_X_/_Z^?_^^O___?W]_/O]]OG^Z_/_TN;_57;&(E'+&5/B#D_@"T_D
M#DWE%%+L$$_G$5+J#%#I"DKE%$CH"S76`!BW!QNV#QJR$QJO$!JH%2*D%2&1
M>X73[NW___W__OW__/[__/_[_?_[_/_]___^__[]__[]__[Y95Y-/2T)0BT`
M1"T`13('."P"1S\A___W__OZ___\_O_[_O_[_/_[^?[]^?W^^_W^^_W]^/W\
M^O__^____/[^___^_O_]___^_?OZ_?OZ___^___^_/[^^/W\^O__^?[_^O[_
M_OW___W]______[]__[]___\___[___[__[Z___[__[]___^_____/S\__[_
M_OW______O_[_?_Y___Q0S86/BL%/RT$02\&/RP!.RL&95Q!___M___X_?W]
M_?G^__[____^___\_?SX_?OZ___^______[^__W___S^_OW__OW______?W]
M^OOY___^^OOY^_O[_?W]_O[^_________?W]_?W]____________________
M_O[^_O[^_________/S\_________O[^_/[^_?__^_W]^OS\_/[^_?___?__
M_/[^_?W]________^_O[_____O[^_O[^_O[^____________________^_O[
M^OKZ_________/S\____^_O[_________?W]_?W]_____________O[^____
M_____O[^_?W]^_O[^_O[_O[^_____OS\_________?O[Z.;FM+*RMK2TM;.S
ML[&Q________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________^___^^__^^?_]_/_Z_/_Z_O_[_/[^^/W_^/__
M^/W\_?_^_/O]]_G_YO#_QMO_/V7%&DS*%5/=$E7F#D[B$U'E$5'E$U7J!DWD
M"D[G$DOG&DKH!"C(`QRZ#!JS%!ZR#ANG$R":(2N)O,3_\/7__/W__/S__/W_
M_O_[___[__[]__[___W^__[[___W95],-R<"2#$#1BX`0BL`/3`$3T<I_OGP
M___________^___^_/_]^___^_____[__?__^___]OS[^?[]_?___/W[___^
M_?SX___\___[_O_[^OOY_?_^^O_]^?_^]OS[^_____[___[__?K\__[^____
M_OS[___^___^___^___^__[]^_O[_____OW__OW________^_O_[_?_Y___R
M0S49/BL&/RT$03`%02X!.BP"9U]"___Q___Z_/[__?S_]_7[_?W]___^____
M_O[^^_K\__[_^_K^__[___[_^OG]_OW______/W[___^_/WY_O_[________
M____________________^_O[_____O[^_O[^_________O[^_O[^________
M_?W]_/S\^_O[_?__^OS\_/[^_?___?___?__^/KZ_?___________?W]____
M_________________________O[^_O[^_O[^_________O[^____^_O[____
M_/S\____^OKZ_________O[^^OKZ_____O[^_O[^____________________
M_____O[^______[^______W]ZNCHLK"PL[&QM;.SL[&Q________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________________________________________^
M___[___[_?___/[^_/_[_O_]__W__OS_^?O_^/S_^?_]^__\_?___/W_]_G_
MY_+_H;W]+UV\'%?5$E3B#5#A#U+E#E'D"TWB#5#H$U+J%4[E&DOC'TGH`""_
M!1NV"QVP#!RK&2>?.T*1X>?_\OK_]_S]_?W__OS__OS\___\__W\__S[__S\
M__[Y___T8EU(.BP(1#$&12X!02P`/"\#2D(D__WT__[^_O[^_O_]___^___^
M___^______[______/_]^__^_?_^_?_^___^___^___^___^___^___^___^
M_?_^_?_^^O_]^O_]_/_]_O[^_O[^_O[^_O_]_O_]___\___\___\___\___\
M___\___^___^_?___?_____^_O_[___[_OWY___T0S49/RP'/2L"03$#0C`!
M/R\$9U]!___N_O_Z^___^?S__?W__/[^_/_]_/[^_/[^_?___/[__/W__/W_
M_/W__/W__/[__/[^_/_]_/_]_/_[_/_[____________________________
M_____________________________________________________?___?__
M_?___?___?___?___?___?______________________________________
M____________________________________________________________
M_________________________________________________________O[^
M____YN3DLK"PM;.SLK"PM+*R______[^__[^_________O[^____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________________^___[___[___^_______^
M_O[^__S__OO__?S_^_[_^__^^__\_?_^______[^\_G_W?3_A:[M*5W(%U79
M$%'<"$S;$5?G#%'D"4WB"$?='UCJ'E+E'$SH'D?C`22Z`1RM"1VK'2><@87&
M[.[_]/W_^?_]__W___O___[_^??W__W\___\__WX__SU___R9%Y'.BX,/BP#
M0BP"0BP"0#((2D(D___W_OW__/[__/[^_O_]___^___^______[______O_]
M_O_]___^___^___^___________________________^___^___\___\___^
M_O[^_O[^_O[^_______^___^___^___^___^___^___^___^_?___?___?__
M___^___\___\__[Z___U/C`41#$,/RT$/R\!0C$`/R\$9U]!___O_O_Z^___
M^?S_^____/[^_?_^_?_^_?___/[^_/[__/[__/[__/W__/[__/[^_/[^_/_]
M_/_]_/_[_/_]________________________________________________
M_________________________________?___?___?___?___?___?___?__
M_?__________________________________________________________
M____________________________________________________________
M_____________________________?W]_O[^^_O[_O[^Z>?GM;.SL[&QL*ZN
ML[&Q______[^__[^_________O[^________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________?___?___?_^___[___[______[___W___W___W___W_
M_O[^_O_]_?_\_?_^_/[^]OW_Z?S_T?+_7XK;(EC*'EO;#E+;!4[8"E3B"4_B
M$53G$$O=&E/D%4WB&4_B%D;4`">R"B&M&224Q<3\]_;_^/__]__X_OO]__K_
M__S__OO]___\_O_V___W___W__[O9EY'-BL+."@#1S$(2#((.RT#344G___X
M]O?[^OW_^OW__/[^_/[^_/[__?____[___[___[^__[]__[^_O[^______[_
M_OW__OW__OW__OW__OW________^___^___\___^__[___W___W___[___[_
M__[___[___[___[___[___[___[___[___[___[___[___[^_/KY___^__[S
M.BP0/2P%/BX#/BX`02\`/R\%9UY#___Q___[_?__^_[\_?_^___\___\___\
M___^_O_]_O[^_O[^_O[^_OW__O[^_/[^_/[^_/_]_/_]_/_]_/_]________
M____________________________________________________________
M_____________________?___?___?___?__________________________
M____________________________________________________________
M____________________________________________________________
M_________O[^_________O[^Z>?GM+*RLK"PM+*RLK"P______[^__[^____
M_____O[^____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________?__
M^OW_^O[__O_Z___Y___^__[___W___W___W___S]__S]__W\_/_]^O_]_/[^
M^/[]\?_[Y_S_Q^7_3'+$+%N]*5_*'US*'5S.'EO3'5;1(5;/(E7/(EC4(5?3
M)%;4&$"^#"*@)B^1YN/__?K_^__\]O[T_OS\__S___O___W__?_\^__W___X
M___T___P<&51-RP.02\*0"H`12X!.RH`4$4E__WV__[_^_[_^____/[^_/[^
M_/[__/W__?[___[___[^__[]__[^__[^_OW__OW__OW__OW__OW__OW__OW_
M_OW________^___^___^__[___[___W___[___W___[___W___[___[___[_
M__[___[___[___[___[___[_________^OKZ___X030:.BH%.2L!/BX#/R\!
M/2T(9UQ&___T___[_?_^_/_[_?_[___\___\___\___\___^_O_]_O[^_O[^
M_________/[^_/[^_/_]_/_]_/_]_/_]____________________________
M____________________________________________________________
M_?___?___?___?______________________________________________
M____________________________________________________________
M_________________________________________________O[^________
M____Y^7EL[&QL:^OLK"PL:^O__________[^_________O[^____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________?__^OS__/S__O_[___Z_O_Z
M_?_^_?____[___W^__W^__W^_____?__^___^___^O[__/[^]?O_Y_/_V>K_
MNM#_J\;^EK;QAZSJ>9S@:(O4:8S62&^Z.V:U,%VT,UJ]05[&.$FJ8FFR\?'_
M_OW_^O[X^?[U___^__S^__W___S^_?_\^__[^_[U___X__[S8UE'-RH*/BP#
M2S$#23``2#("64DD__ON___^_______^_O_[_O_[_O_]_O[^__[___[___[^
M__[^__W___W__OW__OW__OW__OW___[___[___[___[__O[^_O[^_O[^_O[^
M_O[^_/[___[__?____[__?____[__?___?___?___?___?___?___?___?__
M____________]_?W__WU.2\7.BL*/3`*/"T&/BP#/"P(9UQ(__[U___^____
M_O_[___[_O_[_O_]_O_]___^___^___^___^___^_________________O[^
M_O[^_O[^_O[^________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________?__^?O[________Z.;FN+:VM;.SL:^O
MLJVN__[_______[^____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________[__/S__OS__O_]_O_Z_/_Z_/_[_/[^_O[^__W^__W^
M__W^_____?___?___?___OW___W]_OW_^_W_\?3_\OC_Z_;_Y?+_XO/_X?#_
MW?#_TNC_SNG_S^__O=W_K\G_H[;ZGJOIN+[K\_3___[_^__Z_/WY___^__S^
M__S^__[_^_[\^?_Z_?[\___\___XF92%-2H./BP'2S(&12L`13$"44$=___U
M_OKY_____O_]___[___Z_O_[_O_]__[___[__O[^_O[^__________[__OW_
M_OW__OW___[___[___[__O[^_O[^_/[^_/[^_/[^_/[^_/[^_/[^_?___?__
M_?___?___?___?___?___?___?___?___?___?_____^___\_O_]_/[____\
M;V53-"8*.2T+.RT)/2P%/"L*9UQ(__[U___^__[__O_]___\_O_]_/_]_O[^
M___^___^___^___^___^_________________________O[^_O[^________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________?__^_W]________X^'AM+*RL[&QM;.SL*NL__W^______[^____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__W___W__O[^_/_]_/_]_/_]_/_]_O_]___^__[]_?[\^_W]_/[__OW___W_
M__W_____^_O[_OW___W_^OW_^/O_^/S_[_+_]/;_]OK_\/O_Z?C_Y/?_Y/7_
MZ?/_[?7_[_G_[?7_]OG_^OW__?___?W]^OS]_OW___O^__[__?W]_?____[_
M^/3Y___^_?[TM+"=1#D>/2H)0BT'/"P"4TDK__[W_?S_^O[__/[^_O_[___[
M___\__[]__[^_O[^_____?_________^_______^_O_]_O_]_O_]_O_]_/_]
M_/_]_/_]^O_]^O_^^O_^_?_^___^________________________________
M___________________^___\_O_Z^OOW^_____W]___SLJ2.0C8:."L+.RL'
M.BL+9UQ(__[U__[___[___W______/[^^O_^_?___?___?___?___?___?__
M__________________[___[___W___W_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________^_W]_/[^_O[^
M^_O[Z.;FM[6UL:RMM[*SKZJK__W^______[^________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________[__________?___?_^
M_?_^___^___^___^_O_]^_[\^OS\^_W]_OW___W___W^_____?W]____^_CZ
M_____?S^^_K^__[___[___W\_?_\^/_\^/__]____?___/[^]_SZ]_[[^___
M^/O__/W___[_^_W^__[___S]__S]____^?CZ__W___W_]_GY___\___VZ^33
M<65-.BP0-RT/13\H__WX_?[_^O[__/[^___^___\___\__[]__[^_O[^____
M_?___?_^_?_^___^___^___^_O_[_O_]_O_]_/_]_/_]_?_^^__^^___^___
M_?_^___^___________________________________________________^
M___\___[_/_[^O[__O[^___X__[PZ^#,6$XV-2D--2D18UM*__WV______[_
M__W___[__?__^____?___?___?___?___/[^_/[^__________________[_
M__[___[___W_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________^_W]_?___?W]________S\W-M;.SL[&Q
MKZJK__[^______[^____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________[___[_____
M_______^_?___?___?___________?___?___?___?____[_____________
M__________________[___[________^___[___U___UMK"C+B@;/STS__WY
M_O_]___________^___^___^____________________________________
M_______^_____________________?___?___?______________________
M___________________________________________^___^___^_?_____^
M___Z___X___V___UJ**5,"H?6UA0___Z__W\_____?W]_________?______
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________/S\________^_O[____[>WMO;V]L:^O_____O[^_____?W]
M_?W]________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^
M_____O[^_O[^_O[^_O[^_O[^____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________^___[__[Y___Z___ZY.'==G-O___\___\___^___^________
M_________?___?______________________________________________
M____________________________________________________________
M_________________________O[^_______^___^___[___[___[__[Y___Z
MU-',?GUY__[Z___^_?[\________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________O[^^_O[____
M_____/S\_?W]_____O[^U-34_____?W]_____?W]_________O[^________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________?W]
M_?W]_?W]_?W]_?W]_?W]_?W]_?W]_?W]_/S\_?W]_____?W]_?W]_?W]_?W]
M_?W]_O[^____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________________________________^___\_OWY
M___\_OWY___\___[__W\__W\___^___^____________________________
M____________________________________________________________
M____________________________________________________________
M_____/[^_/[^_O_]___^___^___[___[___[__[Z___\__[]__W\^_SZ_O_]
M_?__]_GY____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________O[^_/S\_?W]_________O[^____
M^/CX_?W]_O[^_____/S\_____O[^_O[^____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________/S\_?W]_?W]____________
M_____________________________?W]_?W]_O[^_?W]_?W]____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________W\___\__[Z___[__[Z_OWY___^
M___^___^___^________________________________________________
M____________________________________________________________
M_____________________________________________/[^_/[^_O_]___^
M___^___^___\___[___\__[Z_OS[__[]___^___^^/KZ_?______________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________?W]________^OKZ_O[^_____/S\^_O[____^OKZ_________?W]
M_O[^________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________O[^_O[^_O[^
M_O[^_O[^_____________________O[^\O+RW]_?S\_/NKJZM;6UQ<7%VMK:
M[.SL^OKZ_________________O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________^___^_O_]___^___^___^^OOY_O_]________________
M____________________________________________________________
M____________________________________________________________
M_________________________/[^_/[^_O[^_______^___^___^___^__W\
M___^___^_/W[_________/[^^OS\________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________?W]_O[^
M_________?W]_________O[^_?W]_________O[^_?W]________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____O[^_O[^_O[^_O[^_?W]_O[^_?W]_/S\_/S\_____________/S\[N[N
MXN+BR<G)M+2TFIJ:?7U]:FIJ6EI:2DI*5%14<'!PC(R,HZ.CR,C(V=G9YN;F
M_/S\_____________?W]_/S\_/S\_/S\_/S\_O[^_O[^_O[^_?W]________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________________________________^_/W[
M___^^OOY_?[\___^___^___^____________________________________
M____________________________________________________________
M____________________________________________________________
M_____/[^_/[^___________^___^___^___^__[]^_GX_?[\___^]O;V_O[^
M_?__^OS\____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________^OKZ^_O[_____________O[^^?GY
M_?W]_________?W]_____________O[^____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________O[^^_O[_O[^_/S\_/S\
M_?W]_________________/S\X.#@R<G)JJJJD)"0?7U];&QL:6EI:VMK=75U
M@8&!@X.#=G9V9V=G6EI:5E965U=79&1D;V]O@8&!I:6EO[^_VMK:^?GY____
M_________________?W]^_O[_?W]^_O[____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________/[^_?__]_GY_?__^?O[_?___/[^
M]/;V________________________________________________________
M____________________________________________________________
M_____________________________________________/[__/[__?___?__
M___________^___^_O_]^_SZ____^OKZ^_W]_?__]_GZ_?______________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________O[^_________?W]^_O[_O[^_____________________O[^_O[^
M_____?W]_O[^________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________?W]_?W]_________________O[^\/#PU]?7MK:V
MBXN+?7U]>GIZ=G9V=75U?'Q\C(R,EY>7FYN;H*"@G)R<A86%A86%CX^/BHJ*
M=75U=75U;V]O965E75U=8&!@:6EI='1TA86%D9&1L;&QTM+2Z>GI_O[^____
M_O[^^_O[_?W]________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________?__^?O[_?__]_GY_?___?__]_GY_?__________________
M____________________________________________________________
M____________________________________________________________
M_________________________?___?___?___?_____________^___^_?[\
M___^^_O[^_O[_?__]_GY_?__^_W^________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________?W]________
M_________O[^_/S\_O[^____^_O[_________/S\____^OKZ____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________O[^_?W]_?W]_O[^_O[^________
M____________Z.CHU=75O+R\GIZ>BXN+=W=W:VMK<W-S?7U]E965FYN;GY^?
MHJ*BHZ.CFYN;C(R,?W]_<W-S965E<7%QB8F)E965CHZ.E)24E965D9&1BHJ*
M?W]_<W-S9V=G8&!@75U=8V-C<7%Q@("`I*2DR,C(_____O[^^_O[________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________?___?__
M_?___?___?___?___?___?______________________________________
M____________________________________________________________
M____________________________________________________________
M_____?___?___?___?___________________________O[^_O[^_/[__/[_
M_/[__/[_____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________O[^_O[^_____________/S\________
M_O[^_O[^_____?W]________________________V]O;M+2TF9F9?7U]<7%Q
M;FYN='1T>WM[@H*"D9&1H*"@HZ.CK*RLDI*2A86%=G9V;&QL8F)B7EY>8F)B
M;&QL<W-S>GIZ>WM[A86%DI*2E965E)24EI:6D9&1DI*2BXN+BHJ*DI*2DY.3
MBHJ*@("`<G)R>7EY:6EIM;6U_____O[^_O[^_O[^_O[^________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________?___?___?___?___?___?___?__
M_?__________________________________________________________
M____________________________________________________________
M_____________________________________________?___?___?___?__
M_________________________O[^_O[^_/[__/[__/[__/[_____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________O[^_____?W]_?W]_O[^_?W]_/S\________________________
M[.SLS,S,HZ.CA(2$;&QL9V=G<G)R>7EY@X.#DY.3FYN;H:&AI:6EHJ*BE)24
M>7EY<7%Q9&1D7%Q<8V-C9V=G<7%Q?7U]@H*"B(B(DY.3E965C(R,@H*"<7%Q
M<W-S;&QLCHZ.H*"@K*RLG)R<AH:&>'AX?'Q\B(B(DY.3FYN;GY^?BXN+=G9V
M1D9&PL+"_________/S\^_O[_O[^________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________?___?___?___?___?___?___?___?__________________
M____________________________________________________________
M____________________________________________________________
M_________________________?___?______________________________
M_________O[^_O[^_O[^_/[^_?__________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________?W]_/S\^_O[
M^_O[_________________/S\Z>GIR\O+KZ^OD)"0>'AX;6UM<'!P<W-S?GY^
MD)"0G9V=H*"@HJ*BHZ.CG)R<A(2$>7EY?'Q\<W-S8F)B9V=G;V]O=W=W@("`
MBHJ*BHJ*DY.3FIJ:GIZ>G)R<H:&AG)R<G9V=E965F)B8E965B8F)E965K*RL
ML+"PJZNKGY^?C(R,@("`@X.#BXN+E)24C(R,A(2$?W]_3$Q,T]/3_____/S\
M_/S\_?W]____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________?___?__
M_?___?___?___?___?___?______________________________________
M____________________________________________________________
M____________________________________________________________
M_____?___?___________________________________________O[^____
M_?___?______________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________V]O;JJJJ
MA(2$;FYN7EY>75U=;FYN@X.#CHZ.HZ.CJJJJL+"PIJ:FGIZ>C(R,?'Q\;&QL
M86%A7%Q<6EI:86%A;V]O=G9V>GIZA(2$@8&!@X.#BHJ*C(R,EI:6H*"@GY^?
MH:&AJZNKI:6EG9V=J:FII:6EJZNKDY.3GIZ>I*2DI:6EJ*BHK:VMJZNKJZNK
MJJJJH*"@H*"@L+"P='1TFIJ:3DY.7EY>________^_O[_O[^____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________/S\_/S\_/S\_____?W]_O[^^_O[_O[^________
M________^?GYX^/CO;V]DY.386%A3T]/4U-3965E>'AXB8F)G9V=JZNKJJJJ
MI:6EH*"@DY.3?'Q\8V-C6EI:4E)25U=775U=8V-C='1T>7EY@H*"B8F)?W]_
MBHJ*CX^/DY.3D9&1FYN;HJ*BG9V=DI*2E)24DI*2D9&1D9&1E)24FYN;EY>7
MF9F9E)24HZ.CHZ.CHJ*BIJ:FKZ^OJZNKK*RLM+2TL[.SMK:VSL[.X^/CP<'!
M?'Q\EI:6/CX^3T]/_________/S\_/S\_?W]________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________O[^_____?W]
M_O[^_/S\_/S\_________________?W]\?'QV=G9O+R\G)R<@H*";V]O:VMK
M;FYN@X.#E)24GY^?HJ*BHZ.CG9V=D)"0CHZ.>7EY:&AH9F9F965E9&1D965E
M;FYN=75U@("`@("`?W]_@X.#@X.#A(2$C8V-E965C(R,CHZ.E965F9F9EY>7
MG9V=F9F9F)B8FYN;EI:6DY.3CX^/D9&1E)24F)B8FIJ:EY>7H*"@IZ>GIJ:F
MI*2DJJJJL+"PM+2TNKJZO+R\N;FYPL+"R\O+U]?7J:FI@8&!=G9V1D9&F)B8
M_________/S\_/S\_?W]________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________O[^_O[^_____O[^
M_O[^_________O[^_O[^_O[^_____O[^_________________/S\]/3T[^_O
MZ.CHP\/#GIZ>>7EY:VMK:&AH;&QL>WM[BHJ*G9V=H*"@H*"@G9V=DY.3B(B(
M<G)R9&1D75U=7U]?7U]?86%A:&AH<W-S?GY^AH:&A(2$@("`>'AX?W]_AX>'
M@X.#B8F)CHZ.DI*2E)24E965D9&1D)"0E965EI:6D9&1DI*2E)24DI*2D9&1
MDY.3CX^/EY>7F)B8GIZ>H:&AHJ*BI*2DIZ>GK*RLK*RLJ*BHKJZNKJZNJ:FI
MKJZNN+BXOKZ^PL+"N[N[S\_/C(R,A86%9V=G1T='N[N[_____O[^_?W]_?W]
M_O[^________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________O[^_O[^_?W]_?W]_O[^_?W]_?W]_O[^_O[^_?W]_?W]
M_________O[^^?GY\_/SYN;FU=75M;6UC(R,;V]O75U=8&!@;6UMA(2$E965
MGY^?H:&AH:&AEY>7B(B(=W=W;V]O8&!@3T]/3T]/5E968V-C;6UM=G9V?GY^
M@("`@H*"A86%AX>'AH:&B8F)B8F)?GY^@("`AH:&BHJ*C8V-D9&1DI*2CHZ.
MCX^/E)24CHZ.DY.3D)"0D)"0EY>7G)R<IZ>GFYN;D)"0C8V-C(R,D9&1G)R<
MHJ*BGY^?I:6EHZ.CH:&AGIZ>H*"@F)B8EI:6DY.3M;6UR\O+Q\?'TM+2T-#0
MT]/3X^/CFYN;@8&!5U=74U-3RLK*_____?W]_O[^____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________?W]
M_/S\_?W]_?W]_/S\_?W]_O[^________________[>WMW-S<Q,3$K*RLE)24
M?'Q\<G)R<'!P?7U]B8F)F)B8H*"@H:&AG)R<CHZ.?W]_=75U:FIJ75U=5U=7
M6EI:7%Q<9&1D:&AH<W-S>GIZA(2$BHJ*B8F)AH:&@H*"?'Q\?7U]@8&!BHJ*
MA86%B8F)BXN+?'Q\?7U]?W]_AX>'CHZ.BHJ*BHJ*D)"0E)24EY>7F)B8N;FY
MT-#0Z>GI\/#P^?GYZ.CHU=75R\O+J*BHB(B(D)"0FYN;G9V=G)R<F)B8F)B8
MG)R<H*"@I:6EN;FYO;V]R,C(QL;&Q,3$S\_/XN+BX^/C[^_OU=75AX>'=W=W
M2TM+=75U]_?W_____/S\_O[^____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________O[^_O[^_________O[^_O[^_?W]_?W]________________
M____^?GYYN;FT='1O;V]CHZ.?GY^=75U=75U>'AX?GY^C8V-FIJ:GY^?EY>7
MCHZ.@H*">'AX:FIJ7U]?6%A86EI:7%Q<8F)B965E;V]O='1T?GY^?'Q\@8&!
MB8F)D)"0CX^/C8V-D)"0C(R,AH:&@("`@("`?GY^A(2$A86%A86%@("`@X.#
MAH:&BXN+CX^/D)"0D9&1EY>7H:&AD9&1:&AHZNKJ____________________
M________U]?7>'AX?7U]CX^/EI:6F9F9G9V=K*RLIJ:FI*2DJJJJM[>WNKJZ
MQ<7%Q\?'Q<7%R\O+V=G9X^/CY>7E\/#PO;V]>'AX;6UM2TM+F)B8^?GY____
M_O[^________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________O[^_________O[^_________O[^_/S\_/S\
M_O[^_____?W]________________]O;VY^?GUM;6OKZ^IZ>GBHJ*<'!P8F)B
M>WM[C(R,F)B8G9V=GY^?EY>7C(R,?W]_<7%Q7U]?6%A84E)24E)26%A88&!@
M9F9F;FYN<W-S>GIZ@("`AH:&AH:&C8V-A(2$A86%B8F)D)"0D)"0C(R,CX^/
MD9&1B8F)AH:&BHJ*B8F)BHJ*@X.#A(2$B8F)B(B(C(R,D9&1DI*2EY>7E)24
MF9F9KJZN:6EI,#`PDI*2Q\?'U=75W-S<X>'AV-C8T='1MK:VAX>'<G)R:FIJ
M@H*"F9F9GIZ>FIJ:I*2DJJJJJ:FIK:VML;&QM+2TO[^_P,#`PL+"P\/#S<W-
MU=75X>'AX^/CYN;FF)B8B8F)9V=G1T='MK:V_O[^_____O[^_O[^________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____?W]_O[^_O[^_/S\_____O[^_?W]_O[^____________________Z.CH
MT-#0M+2TF9F9AX>'?'Q\=75U>7EYAX>'CX^/G9V=G9V=DI*2AX>'?7U]<7%Q
M965E86%A65E95U=75%1475U=9&1D:&AH;6UM;FYN='1T?'Q\?W]_@H*"A(2$
M@X.#A86%@H*"A(2$?W]_A(2$BHJ*B(B(AX>'BHJ*C8V-CX^/CHZ.C(R,CHZ.
MCHZ.DI*2F)B8E)24D)"0D9&1CHZ.D9&1E965EY>7K*RLO[^_>GIZ:FIJ4%!0
M5%14:&AH='1T?'Q\=75U<7%Q:6EI>7EYFYN;:&AHA86%E965G9V=FYN;GIZ>
MJZNKJ:FIJJJJL+"PLK*RO+R\L[.SP\/#S<W-S<W-T]/3X.#@V-C8VMK:U=75
MEI:6@("`65E97%Q<W=W=_____?W]^_O[_O[^________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________O[^_O[^_____O[^_?W]_?W]_?W]____
M________________]/3TW=W=P,#`I:6EDI*2@("`>'AX='1T>7EYA(2$CHZ.
ME965EY>7EI:6CX^/AH:&:&AH7U]?75U=75U=6UM;6%A86EI:6UM;75U=8V-C
M:&AH;&QL<'!P=W=W=G9V>GIZ@8&!@X.#@X.#@("`?GY^@("`?W]_?W]_?GY^
M?GY^?W]_?7U]A86%BXN+CX^/DI*2DY.3E)24E)24DY.3F)B8F)B8EY>7F)B8
MEI:6D9&1DI*2CHZ.C8V-I*2DW-S<N;FYJ:FIK*RLDI*2@("`=W=W>GIZA(2$
MBXN+EI:6H:&ABHJ*<W-SEY>7G)R<H*"@GIZ>IJ:FIZ>GKJZNL;&QL[.SM;6U
MN[N[N[N[P\/#U=75T]/3U-34WM[>WM[>V]O;X.#@QL;&DI*2?GY^2$A(?GY^
M]/3T_____/S\_O[^____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________O[^_O[^
M_O[^_O[^_/S\_/S\_O[^_O[^________________]/3TWM[>QL;&J:FICX^/
M?GY^<G)R<'!P<W-S?GY^C8V-E965F)B8EY>7CHZ.@H*"='1T9V=G7U]?6UM;
M55555U=765E97%Q<8F)B86%A9&1D:6EI8F)B:VMK<'!P;&QL<G)R=G9V>7EY
M?'Q\?GY^?W]_?GY^?W]_?'Q\?'Q\?W]_?GY^?W]_?7U]?'Q\?GY^A(2$C8V-
MBXN+C8V-CHZ.D)"0E965DI*2EY>7E)24E)24E)24D9&1BXN+C8V-CHZ.C(R,
ME965N+BXW-S<O;V]N[N[K*RLH:&AGY^?I*2DJ*BHHJ*BFIJ:C8V-?GY^EI:6
MIZ>GHZ.CJ:FIIJ:FKJZNI*2DKJZNM[>WO;V]OKZ^P<'!S,S,S,S,SL[.SL[.
MRLK*U]?7U]?7V-C8W=W=Z.CHN[N[BXN+=W=W24E)HZ.C_/S\_O[^_O[^____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________O[^_O[^_____/S\^_O[_/S\________________
M________Z^OKP\/#I*2DBXN+='1T;&QL<7%Q?GY^A(2$CX^/G9V=HJ*BG)R<
MD)"0@X.#='1T:&AH86%A7%Q<65E96UM;5U=77%Q<7EY>7U]?7U]?9&1D8V-C
M9&1D:6EI<'!P:FIJ;FYN;V]O;FYN>WM[>GIZ=W=W>7EY?7U]?GY^?'Q\>GIZ
M>WM[@X.#>WM[@8&!A86%@8&!@X.#AH:&A86%BHJ*AX>'AH:&@H*"@("`A(2$
MA(2$AH:&BHJ*C(R,CX^/DY.3CX^/DY.3DI*2DY.3E965F9F9JZNKO+R\NKJZ
MJ*BHEI:6E)24E)24C8V-?GY^@8&!DY.3F9F9H:&AGY^?HJ*BKJZNK*RLJJJJ
MJ*BHKZ^OO+R\Q<7%P<'!Q,3$RLK*T-#0RLK*KZ^OGIZ>GIZ>PL+"SL[.VMK:
MZNKJX>'AIZ>GCHZ.7U]?4%!0W=W=_____/S\________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________O[^_O[^_?W]^_O[
M_/S\_/S\____________________\?'QTM+2LK*RC8V-<'!P9F9F:VMK=75U
M>WM[BXN+F9F9G9V=G9V=E)24AX>'>GIZ<G)R9F9F6EI:65E96EI:5U=76EI:
M6EI:6%A86EI:7EY>75U=8&!@965E9&1D86%A8F)B9V=G:6EI:FIJ<'!P<W-S
M<7%Q<W-S<W-S<7%Q<7%Q=G9V>WM[?GY^?W]_?W]_?W]_A86%?'Q\?7U]@8&!
MA86%@("`@H*"C(R,BXN+AH:&@H*"?GY^?'Q\?GY^@X.#BXN+DY.3DI*2EY>7
MF)B8DY.3EI:6E)24CX^/DY.3D)"0BHJ*EI:6FIJ:HZ.CI*2DG9V=EI:6HZ.C
MI:6EGIZ>FIJ:EI:6EI:6G)R<H:&AG)R<I*2DI:6EK:VMN+BXN;FYNKJZQ,3$
MPL+"Q\?'S\_/O;V]HJ*BH:&AD9&1MK:VR<G)R<G)V-C8X>'AV=G9G)R<A86%
M5U=75E96^OKZ____^_O[_O[^____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________/S\_?W]_____?W]_/S\_?W]________________]/3TV=G9
MM;6UF9F9@("`;FYN:FIJ;V]O>7EYB(B(DY.3EY>7F)B8DI*2BXN+?'Q\<'!P
M:VMK7U]?7%Q<6%A86%A85E966%A86EI:65E96UM;7%Q<5E966%A87%Q<7EY>
M8&!@8F)B9&1D965E:6EI;6UM;6UM<'!P;6UM<W-S<7%Q<7%Q<7%Q<'!P;V]O
M>'AX?'Q\?GY^>GIZ>WM[?'Q\@X.#AX>'BHJ*B8F)AH:&@8&!?GY^?W]_A86%
MAH:&@X.#AX>'C(R,B(B(AH:&C8V-D9&1CHZ.CHZ.D)"0DY.3F)B8F)B8BHJ*
MBXN+CHZ.BHJ*BXN+E)24DI*2DY.3FIJ:FIJ:EI:6G9V=FYN;FYN;FIJ:GY^?
MHJ*BI*2DH:&AK*RLK*RLK*RLL[.SM[>WNKJZP,#`PL+"QL;&QL;&P<'!N+BX
MM;6UQL;&SL[.T='1T='1T='1U-34XN+BQ\?'E)24@8&!0$!`GY^?_____O[^
M_/S\________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________?W]____________________
M\O+RTM+2GY^?=75U6%A84E)26%A8:&AH?W]_D9&1FYN;IZ>GH*"@DY.3@X.#
M;V]O7U]?5%143DY.34U-4%!04%!034U-55555%144U-35E965%14555565E9
M5U=74U-34U-375U=75U=8&!@9V=G8V-C965E:6EI9V=G8V-C8F)B965E965E
M965E9V=G9&1D965E:VMK:FIJ:VMK;&QL:FIJ=W=W>7EY>7EY=W=W?'Q\@("`
M@H*"?'Q\?GY^>WM[?7U]@8&!BHJ*CX^/D)"0B8F)B8F)D9&1CX^/?GY^@X.#
MCX^/B(B(D9&1DY.3CHZ.B8F)@H*"@("`A86%A86%F)B8D9&1A(2$D)"0E965
MEI:6D)"0C(R,EY>7H*"@GIZ>G9V=D9&1E)24H:&AG)R<J*BHK*RLL;&QLK*R
MN[N[NKJZO[^_O[^_QL;&S<W-S<W-S<W-R<G)S<W-Q<7%P,#`Q<7%P\/#O+R\
MN[N[OKZ^O;V]T='1[.SLL;&QG)R<65E904%!]O;V_/S\_/S\____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________/S\____W=W=Q\?'K*RLB(B(<7%Q9&1D965E<G)R@8&!
MC8V-E965F)B8G)R<CHZ.@X.#>7EY:&AH5%144%!03DY.4E)24U-34U-34%!0
M4U-39F9F7EY>3DY.5%144E)25E964E)24U-365E965E96UM;6EI:7EY>8V-C
M7U]?9F9F9&1D7U]?86%A9V=G965E9F9F:6EI:FIJ;FYN;&QL;&QL<W-S:6EI
M:FIJ;V]O;V]O;V]O<W-S=W=W>'AX=G9V='1T>WM[?'Q\=W=W@X.#@X.#>WM[
M<W-S?W]_AX>'BHJ*B8F)B8F)BXN+B(B(B8F)@8&!C(R,BXN+CX^/EI:6D)"0
MC(R,CHZ.C(R,AH:&AH:&CHZ.CX^/D)"0D)"0E965C8V-EI:6EI:6E965E)24
MEI:6D)"0DI*2F9F9H*"@H:&AI:6EK:VMK:VMK:VML;&QMK:VPL+"O;V]O;V]
MP\/#O[^_M+2TO[^_PL+"PL+"Q,3$Q,3$Q\?'Q,3$P,#`PL+"R<G)RLK*W]_?
MV-C8G)R<B(B(34U-='1T_?W]_/S\________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________O[^
MZ.CH5U=79V=G9&1D:VMK=75UAX>'DY.3FIJ:F9F9D9&1B8F)>7EY:VMK6UM;
M5%1434U-45%145%14E)25%144U-355555U=74U-33T]/7EY>8F)B4E)245%1
M5%14555565E96EI:7%Q<6UM;8&!@8V-C9&1D8F)B8F)B86%A7U]?8&!@86%A
M9V=G:&AH:FIJ;&QL:VMK;6UM;FYN:6EI;V]O:&AH;6UM=G9V<G)R='1T<'!P
M;6UM<'!P<W-S<'!P<W-S;V]O:FIJ=75U<G)R@("`?'Q\@8&!BXN+A86%@8&!
MA(2$@H*"?GY^AX>'B8F)C(R,BHJ*B(B(CX^/AX>'A(2$@8&!B8F)BXN+BHJ*
MCX^/C8V-C(R,E965CHZ.DY.3DY.3DY.3EI:6E965EY>7G)R<G)R<IJ:FH:&A
MI:6EIJ:FJ*BHK*RLK*RLK*RLK:VMN[N[P,#`P<'!P,#`O;V]N+BXK:VMLK*R
MM[>WPL+"P,#`Q<7%P\/#OKZ^O[^_Q,3$Q,3$R\O+W=W=R,C(BHJ*?'Q\+2TM
M_____?W]____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________O[^_O[^________>'AX<7%QBXN+E)24F9F9
MF9F9D)"0@8&!<G)R7EY>4E)224E)1T='24E)3DY.4U-33T]/4%!05E965555
M45%13$Q,3DY.4E)245%14%!02DI*3T]/5E965%1465E97%Q<7%Q<7EY>7%Q<
M7%Q<75U=7EY>8&!@7U]?7U]?8&!@86%A9&1D86%A9F9F8&!@8V-C:6EI:FIJ
M:VMK<G)R>'AX;6UM;FYN<7%Q<'!P@("`G)R<N;FYW=W=\?'Q^?GY_/S\_/S\
M]?7UZ.CHQL;&FYN;?W]_='1T>'AX@H*"B8F)BHJ*BXN+C8V-CX^/B8F)CHZ.
MBXN+D)"0AH:&BXN+CHZ.BXN+BHJ*C8V-CX^/C8V-DY.3E965D9&1EY>7DY.3
MEY>7DI*2EI:6FIJ:G)R<GIZ>HJ*BI:6EJ*BHM[>WO[^_M+2TIZ>GK*RLL+"P
MM+2TM+2TO;V]O;V]P\/#Q,3$QL;&R\O+RLK*S,S,PL+"P<'!O[^_O;V]Q\?'
MPL+"O;V]P\/#Q\?'R<G)Q,3$X.#@M[>WCX^/<7%QY>7E_____O[^_O[^_O[^
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____?W]^_O[________;6UMB8F)C8V-@H*"<'!P8V-C6UM;4E)23DY.2TM+
M24E)3$Q,3T]/2TM+55556UM;4E)224E)24E)1T='1T='24E)1D9&2TM+3$Q,
M3DY.45%145%155555%1455555U=765E96EI:6UM;7EY>8F)B86%A7EY>7U]?
M8&!@7U]?8F)B965E8F)B9&1D9V=G:6EI;6UM;6UM;6UM<'!P:VMK;6UM<W-S
M?7U]M+2TX^/C____________________________________________ZNKJ
MQ<7%DY.3;&QL>GIZC8V-BHJ*BHJ*CX^/D)"0BXN+@X.#C8V-C(R,CHZ.CX^/
MCX^/DY.3DY.3CHZ.BXN+D)"0CX^/C(R,C8V-D)"0CHZ.E)24D9&1E965EY>7
MG9V=F9F9B8F)D)"0F9F9G)R<HZ.CN;FYJJJJK*RLK*RLKJZNMK:VN;FYO+R\
MP,#`O;V]Q,3$N+BXLK*RJ*BHN;FYS<W-R\O+PL+"O[^_O[^_P\/#Q\?'S,S,
MR\O+T-#0[>WMJ*BHBXN+@X.#_________/S\_?W]____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________O[^_O[^_/S\____WM[>
MAX>'8F)B6EI:55553T]/2DI*2$A(1D9&1D9&1$1$0T-#2DI*2TM+0D)"2$A(
M24E)1D9&145%145%1T='24E)3$Q,3$Q,3$Q,3DY.4U-34U-33$Q,4%!03T]/
M3DY.4%!05E966%A86UM;7EY>8&!@7U]?8&!@86%A8&!@7U]?7U]?9F9F:&AH
M:VMK;V]O<7%Q;FYN:FIJ<7%Q<G)R<'!P?W]_;&QLR,C(_____________O[^
M_O[^_____________________/S\_O[^____________]?7UJ:FI>'AX?GY^
MCHZ.BHJ*CX^/D9&1C8V-@8&!AX>'BHJ*BXN+C8V-C(R,CX^/D9&1CHZ.CHZ.
M@8&!A(2$B8F)DY.3CX^/B8F)C(R,DI*2F)B8F9F9CX^/@8&!>WM[AX>'D)"0
M>7EY<W-SMK:VJ:FII:6EI:6EIZ>GLK*RL[.SM;6UN+BXMK:VO;V]EI:6CX^/
MC(R,E)24Q\?'P<'!NKJZN[N[O+R\O+R\P\/#Q<7%Q,3$Q<7%W-S<U=75G)R<
M4E)2KJZN_____O[^_?W]________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________O[^_?W]_O[^________?W]_>7EY.SL[1$1$0T-#1$1$
M145%1$1$0$!`0$!`/S\_0$!`/CX^0$!`/CX^0$!`0$!`1T='34U-34U-3DY.
M45%14%!045%145%14E)24U-33T]/3DY.45%14%!03DY.2TM+3T]/4U-35U=7
M5U=76EI:6UM;6EI:8F)B9F9F:&AH:FIJ;FYN<7%Q:VMK;FYN;FYN:FIJ:6EI
M>'AX>'AXE965D)"00D)"]O;V____^_O[^_O[_?W]_?W]________________
M_O[^_?W]_____O[^_/S\^_O[________KJZN86%A@H*"D)"0CX^/CHZ.CHZ.
MBHJ*AX>'B(B(@X.#A(2$AX>'B(B(AX>'B8F)C(R,B8F)C8V-CHZ.DY.3C8V-
MA(2$>WM[F9F9G9V=G9V=CHZ.>GIZ?7U]B8F)CX^/@("`B(B(IJ:FF)B8EY>7
MI:6EG)R<JJJJIJ:FEY>7HJ*BH:&AJZNKK*RLG)R<@("`H:&APL+"P,#`N+BX
MN+BXO+R\O+R\P,#`O[^_O[^_O;V]O+R\T]/3TM+2=75U65E9XN+B_____?W]
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________O[^_?W]
M_/S\_O[^____PL+"<W-S4E)2/3T]0T-#1T='145%0D)"0D)"/CX^.SL[.SL[
M/#P\/CX^0D)"0T-#0T-#1T='2$A(2DI*145%/CX^0$!`1D9&3$Q,3T]/4U-3
M4U-34%!045%145%14U-33T]/3$Q,2TM+2TM+45%15%147%Q<8&!@9F9F;&QL
M;6UM=75U:VMK9V=G:FIJ:6EI;&QL9V=G:6EI;FYN=G9V?GY^L+"P;FYN'Q\?
MT-#0_____?W]^_O[^_O[_O[^_____________O[^_/S\^/CX\_/S]_?W_/S\
M________Z.CHD)"065E9<W-SC8V-D9&1D)"0C(R,E)24CHZ.BHJ*@8&!A(2$
MAX>'AH:&A86%AH:&B8F)CX^/D)"0C8V-C(R,BXN+?W]_>WM[BHJ*BXN+B8F)
ME)24DI*2D9&1EI:6HJ*BFIJ:HJ*BF)B8E)24B8F)E)24FYN;I*2DI*2D@8&!
MG9V=IZ>GFYN;EY>7BHJ*A86%Q\?'P\/#P,#`O+R\N+BXO;V]P<'!P\/#P<'!
MO[^_OKZ^N+BXNKJZX^/CA86%9F9FAX>'^OKZ_____O[^_O[^_O[^________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________O[^_/S\_?W]_/S\____X^/C@8&!C(R,
M.CHZ.CHZ/CX^0$!`/S\_/#P\/3T]/CX^/3T]0$!`1$1$1$1$1T='1T='145%
M0T-#/#P\2DI*7EY>:VMK;6UM8F)B3DY.0T-#145%3DY.4U-33T]/3T]/4E)2
M5%144E)24U-34U-35E9665E96EI:6EI:9&1D9F9F7U]?965E9F9F965E8V-C
M965E9V=G9F9F:FIJ:VMK<W-SB8F)PL+";V]O,C(R=W=W[^_O____________
M_____________?W]_?W]^OKZ^/CX^?GY________[.SLO;V]BHJ*?7U]9&1D
M:FIJB8F)D9&1D)"0CX^/C8V-BXN+BXN+AH:&B(B(BHJ*BHJ*B8F)AX>'AX>'
MB(B(BXN+CHZ.C8V-CHZ.A(2$A(2$CX^/F9F9CX^/@X.#>WM[?GY^AX>'CX^/
MGIZ>HZ.CH*"@DY.3FIJ:J:FIFIJ:E965F)B8E)24F9F9GY^?DY.3FIJ:I*2D
MM+2TN[N[Q<7%S\_/R<G)O[^_P<'!P<'!PL+"P<'!P<'!P\/#N+BXLK*RRLK*
MJ:FI>GIZ86%AL;&Q_________?W]_/S\_?W]________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________O[^_/S\^_O[_O[^^OKZHZ.CAH:&='1T-34U.CHZ.SL[.3DY.SL[
M/S\_0D)"1D9&1D9&145%1$1$145%145%1D9&1$1$2TM+@H*"N[N[UM;6Y>7E
MX>'AS<W-K*RLE965<'!P3$Q,3$Q,3DY.45%14U-35U=75U=75E965U=75555
M5%1455556UM;6UM;7EY>6EI:7%Q<965E:6EI9&1D965E:6EI:VMK<'!P<'!P
M<W-SD)"0TM+2H*"@;&QL34U-@H*"O;V]X>'A]?7U^_O[_O[^____________
M____^OKZ]/3TX.#@N;FYC(R,<G)RA(2$CX^/9&1D;6UMB8F)CHZ.B8F)BHJ*
MAX>'A(2$AH:&B(B(B(B(AX>'AX>'A(2$@X.#@X.#B(B(AX>'C8V-DI*2C(R,
MB(B(B8F)C(R,CHZ.AH:&B8F)B(B(?'Q\?'Q\>7EYG)R<F9F9L;&QB(B(@X.#
MP\/#N+BXJJJJI*2DI*2DJ*BHK:VMKJZNN[N[N[N[N+BXMK:VM[>WO[^_P\/#
MS,S,T-#0R\O+QL;&PL+"P\/#PL+"N[N[N;FYO;V]V]O;E)24;6UM;V]OU=75
M_____/S\_?W]_?W]____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________O[^_O[^
M____Q,3$B(B(E9652DI*/S\_0$!`04%!0D)"1$1$145%145%1T='2$A(1D9&
M04%!0D)"0T-#1$1$.SL[5E96^?GY____________________________Z^OK
M7%Q<0$!`45%14%!02DI*34U-3DY.4%!04E)245%14U-35U=76%A86%A89F9F
M7U]?6EI:8&!@;&QL:VMK:VMK<W-S<'!P<7%Q<W-S=75UBHJ*RLK*X.#@CHZ.
M?7U]86%A6EI:;6UMB(B(EY>7HJ*BJ:FIN+BXO+R\KJZNG)R<C8V-=G9V:&AH
M?7U]I:6EM[>W?7U]7U]?>WM[A86%AH:&AX>'A(2$B(B(B(B(A(2$AH:&B8F)
MB8F)AH:&@8&!>WM[?'Q\BHJ*B(B(C(R,DI*2BXN+AH:&A86%@("`?7U]?GY^
MD)"0G9V=BHJ*@X.#B8F)EI:6AX>'AH:&CHZ.FIJ:OKZ^L;&QN+BXQ<7%P\/#
MP,#`O+R\M[>WM;6UMK:VKJZNKZ^OE)24@("`FYN;GY^?OKZ^PL+"P,#`OKZ^
MO[^_Q<7%O[^_O;V]N;FYX.#@PL+"=G9V86%ADY.3_____O[^_?W]________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________O[^_____/S\FIJ:C8V-8F)B/CX^
M0$!`0T-#0D)"1$1$24E)2$A(04%!/3T]/S\_0T-#145%2$A(1$1$5%148&!@
M0$!`BHJ*T]/3ZNKJ\_/S]?7U\/#PW]_?KZ^O@X.#>GIZ24E)04%!1D9&3T]/
M3$Q,34U-6EI:75U=7%Q<5E966%A86%A87EY>86%A7%Q<8&!@7U]?9&1D;V]O
M<'!P<W-S<W-S<G)R=75U<G)R<W-SCHZ.XN+BX^/CFIJ:DI*2BXN+?GY^<'!P
M:FIJ9V=G9V=G:6EI;V]O<G)R=75U@8&!DY.3L+"PQ,3$M+2T>WM[965E@H*"
MD9&1C(R,BXN+C8V-B(B(@X.#B(B(@X.#@H*"AX>'A86%@("`A(2$B(B(A(2$
MAH:&AX>'A86%A(2$A86%A(2$?W]_?'Q\=W=W>7EY>'AXBXN+FYN;FIJ:G)R<
MG9V=J*BHKZ^OJJJJI*2DJZNKN+BXL;&QKZ^OL[.SN[N[NKJZO[^_OKZ^OKZ^
MN;FYL+"PJZNKHZ.CC(R,AX>'G9V=K:VMJ:FIKJZNO;V]PL+"P<'!OKZ^M+2T
MP<'!WM[>L+"P?GY^9V=GKZ^O_____/S\_/S\________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________?W]_____/S\JJJJ=75U2$A(/3T]/3T].SL[/S\_0D)"0D)"
M0$!`.SL[.CHZ.SL[/S\_0$!`0$!`/S\_7EY>CX^/;FYN3$Q,5555:VMK>WM[
MA(2$?W]_='1T9V=G?7U]I*2D3T]/0$!`2DI*4%!034U-5E968&!@6EI:6UM;
M75U=7EY>7EY>7EY>9V=G:FIJ9V=G8V-C8F)B:VMK<'!P;V]O<'!P=W=W;V]O
M='1T;FYN<7%QG)R<XN+BX>'AL;&QDY.3DY.3GIZ>HJ*BGIZ>FYN;FYN;H:&A
MI*2DL;&QM[>WM;6UJ*BHB8F):VMK;6UMAH:&C8V-CHZ.C(R,BXN+D9&1CHZ.
MC8V-BHJ*AX>'@("`@("`?'Q\?7U]?GY^A(2$AX>'AH:&AX>'A(2$A(2$B(B(
MAH:&?7U]>GIZ>'AX>WM[@H*"@X.#AH:&C8V-E965G)R<HZ.CAH:&BXN+F)B8
ME965DI*2CHZ.A(2$C(R,K*RLMK:VN+BXNKJZN+BXM[>WK*RLGIZ>DI*2CX^/
MK*RLM;6UN[N[N;FYO;V]P,#`PL+"P,#`O[^_O+R\M[>WS\_/T]/3FIJ:<G)R
M='1TX>'A_____/S\_O[^________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________?W]_?W]____
M____H:&A4%!0.CHZ.SL[.#@X/#P\.CHZ/S\_0$!`/CX^.CHZ-S<W.3DY.SL[
M.SL[/CX^.3DY8&!@HZ.CO+R\M[>WDI*2=G9V:VMK:FIJ;V]O?7U]EI:6NKJZ
MEY>7/S\_34U-5%145U=74%!05E967EY>5U=75%145U=78F)B7EY>7%Q<:6EI
M>7EY75U=9&1D8F)B;6UM;6UM;6UM:&AH<'!P=W=W>'AX:VMK='1T='1TE)24
MQL;&[^_OUM;6K*RLE)24D)"0F)B8GY^?HZ.CK*RLK*RLH*"@CX^/=75U;6UM
M;&QL?'Q\C8V-CX^/BHJ*BHJ*C(R,BXN+E)24DY.3DY.3C8V-BHJ*B(B(?W]_
M?GY^@H*"?W]_>GIZ?7U]A86%AX>'A86%C8V-B(B(@X.#?W]_?7U]=W=W>7EY
M@8&!B(B(?W]_B(B(G)R<CHZ.?7U]?W]_BHJ*M;6UM+2T;&QL=G9VI:6E?'Q\
M>7EYA86%F)B8E965AH:&CX^/?GY^AX>'GIZ>N+BXMK:VM;6UO;V]PL+"P,#`
MQ,3$Q\?'P<'!O+R\Q<7%LK*RN+BXTM+2NKJZ@H*"7U]?HZ.C_?W]_O[^_?W]
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________?W]_O[^____?W]_+BXN/#P\1D9&
M2$A(145%0$!`/#P\.3DY.#@X.CHZ/3T]/3T]0T-#145%1T='0D)"-#0T45%1
MJZNKQ\?'Q\?'Q,3$P,#`P,#`P<'!NKJZJZNKAX>'2TM+1T='4U-36EI:4U-3
M4E)265E96UM;65E97%Q<75U=8&!@7EY>7U]?65E96UM;8F)B:VMK:VMK9V=G
M:VMK9F9F:&AH;FYN;FYN:6EI<'!P='1T='1T<G)R<G)R=G9VFIJ:QL;&Q\?'
MM;6UHZ.CFIJ:D)"0@H*"<W-S?GY^BHJ*F9F9HZ.CGIZ>F)B8DI*2D)"0CHZ.
MC8V-DI*2D)"0DI*2B(B(BXN+C8V-C(R,?W]_@("`?7U]>7EY?'Q\>'AX='1T
M@X.#A86%?W]_?7U]?'Q\>GIZ>'AX?7U]@("`?7U]=75U<G)R>'AXB(B(@("`
MAH:&AX>'>'AX='1TB8F)DI*2JJJJR<G)TM+2UM;6LK*RG)R<DY.3D)"0FYN;
MGY^?L[.SN;FYN+BXJJJJK*RLM[>WO+R\O[^_PL+"P<'!Q<7%P\/#O[^_NKJZ
MM+2TL+"PNKJZZ>GIN+BX>'AX5%14Q\?'_____O[^_?W]_?W]____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________?W]____U=758F)B/3T]145%3DY.04%!0$!`0D)"0T-#
M0T-#1D9&2TM+145%/S\_/3T].SL[.SL[/3T]-S<W3$Q,7EY><7%Q@("`C8V-
MD)"0@X.#;V]O555524E)24E)2TM+3$Q,5%144%!04U-36%A86%A865E97U]?
M75U=8&!@75U=8&!@9V=G:&AH:VMK;6UM;6UM9&1D9V=G:FIJ:6EI:VMK=G9V
M<'!P;FYN='1T>7EY<7%Q<W-S=W=W>GIZ?'Q\AH:&EI:6FYN;GIZ>FIJ:EY>7
ME965FYN;E965DY.3DY.3F9F9EI:6E)24DY.3CX^/C(R,C8V-B(B(A(2$?W]_
MA(2$?'Q\=75U=W=W@("`@8&!?W]_>'AX>WM[?W]_@H*"AH:&A86%A86%A(2$
MA86%@("`?GY^>WM[>GIZ<W-S='1T='1T=W=W@8&!@H*"?7U]@X.#EI:6J:FI
MIZ>GJJJJJJJJKZ^OMK:VM;6UKZ^OI:6EHJ*BIJ:FIZ>GF)B8H*"@HJ*BK*RL
MM;6UM[>WN[N[N[N[O+R\P,#`O[^_O+R\N+BXL;&QK*RLKJZNM[>WS\_/TM+2
MH*"@<7%Q?'Q\Z.CH_____/S\_/S\________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________?W]
M_O[^____P\/#2DI*.SL[45%104%!1$1$24E)34U-1D9&04%!04%!/CX^.SL[
M.SL[/3T]/#P\/CX^.CHZ/#P\.CHZ/S\_0T-#2$A(24E)145%04%!/S\_145%
M145%2$A(145%34U-45%145%15E966UM;7%Q<65E95U=77EY>7EY>6EI:965E
M;V]O;V]O86%A75U=9V=G9&1D965E;FYN;&QL<7%Q<7%Q='1T='1T>7EY=W=W
M<7%Q?W]_AX>'@X.#@8&!A86%CHZ.CHZ.BHJ*C8V-BHJ*CX^/E)24DI*2E965
MEI:6CX^/BXN+CHZ.D9&1D)"0DY.3CX^/A86%A86%AX>'CHZ.A(2$@("`?W]_
MB(B(@8&!>'AXA86%BHJ*@H*"AX>'BXN+CHZ.A86%B8F)@X.#@H*"?7U]?'Q\
M?7U]>GIZ>WM[BHJ*DY.3C(R,C(R,GIZ>C(R,B8F)C8V-B8F)BHJ*A(2$A86%
MHZ.CI:6EI*2DFYN;BXN+CHZ.E)24A(2$AH:&D9&1I:6EJ*BHHZ.CL;&QM[>W
MNKJZN[N[LK*RM+2TKZ^OJJJJJJJJK:VMN;FYWM[>Q<7%CX^/8F)BIZ>G^_O[
M_____/S\____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________?W]_?W]_O[^____R<G)/#P\
M1T='2DI*2$A(34U-0T-#-S<W-C8V.3DY/3T].CHZ.SL[0$!`/CX^/#P\/3T]
M1$1$1T='24E)1$1$1$1$145%1T='3DY.3$Q,1T='2DI*3$Q,24E)3DY.4%!0
M45%155556%A865E95U=76%A86UM;7EY>65E99&1D7%Q<55557EY>8&!@7EY>
M;&QL9&1D9F9F:FIJ9V=G:&AH='1T=75U<W-SA(2$@("`B(B(B(B(AX>'@X.#
M@8&!@X.#A(2$@("`A(2$BHJ*BXN+CX^/EY>7EI:6E)24E965CX^/C8V-CHZ.
MDI*2E965DI*2FIJ:G)R<DY.3EI:6AX>'AX>'D)"0D)"0A86%@8&!@8&!AH:&
MB(B(@("`=G9V@H*"@H*">WM[A(2$@8&!?W]_?W]_>WM[=G9V>'AX?GY^>'AX
M>'AXBXN+C8V-C8V-EI:6G)R<D9&1D9&1B8F)65E9B(B(F9F9F9F9GIZ>D)"0
MDI*2>GIZAX>'HZ.CIJ:FHJ*BH:&AG9V=HZ.CK*RLLK*RP,#`OKZ^NKJZN[N[
ML+"PIZ>GJ:FIJZNKQ\?'[.SLMK:VAH:&7U]?QL;&_____?W]_________O[^
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________?W]_?W]_/S\_?W]____H*"@/S\_1T='24E)2$A(/3T]
M.CHZ.CHZ.SL[.SL[.SL[/CX^0T-#0T-#0$!`/3T]0$!`1$1$2$A(24E)24E)
M2DI*24E)2$A(2$A(1$1$145%24E)3$Q,3T]/24E)3T]/5%146EI:6EI:6UM;
M7EY>75U=6EI:5U=77EY>8F)B75U=86%A8V-C8V-C:6EI:&AH;&QL<'!P<G)R
M;&QL;FYN<7%Q='1T>GIZ?GY^@8&!A(2$AH:&AX>'B(B(B(B(AH:&A(2$A86%
MBHJ*CHZ.CHZ.BXN+CX^/DY.3D)"0D)"0DY.3D9&1CHZ.B8F)BXN+DI*2CHZ.
MA(2$BHJ*A86%BXN+D)"0BXN+BHJ*BHJ*BXN+AX>'@("`?7U]@8&!@("`?7U]
M>GIZ?'Q\>7EY?'Q\>7EY=75U=W=W>7EY='1T=G9V<G)R@X.#CX^/AX>'@8&!
MA(2$C8V-C8V-AX>'B(B(D9&1E965FIJ:EI:6FYN;H*"@B8F)D)"0G)R<G9V=
MI*2DK:VML;&QKZ^OL+"PKZ^OK*RLM;6UP,#`NKJZLK*RKZ^OIZ>GI*2DMK:V
MW-S<XN+BF9F9;V]O;V]O]?7U_________O[^_?W]____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________O[^
M_____O[^_/S\________-34U0D)"2TM+2$A(/CX^/3T].CHZ.CHZ.3DY/#P\
M0$!`0T-#1$1$0T-#04%!04%!0T-#04%!0D)"1T='2$A(2$A(24E)1D9&1$1$
M1D9&2$A(2DI*4%!04%!05%143T]/4E)25E966%A88&!@86%A8V-C7EY>6EI:
M75U=8&!@7EY>8F)B8V-C9V=G:&AH;FYN:VMK<'!P<W-S<7%Q;FYN>WM[>'AX
M<W-S>'AX>WM[@H*"B(B(@X.#@H*"AH:&AX>'AX>'CHZ.D9&1D)"0B8F)CHZ.
MD9&1D)"0C8V-C(R,BHJ*B8F)AX>'C8V-D)"0B(B(A(2$A86%A86%B8F)B(B(
MB8F)BHJ*BHJ*BXN+B8F)@H*"?W]_@H*"?W]_?W]_?W]_>GIZ>7EY>GIZ=W=W
M<W-S='1T=75U<W-S=W=W=75U>7EYCX^/C8V-CHZ.F9F9JZNKK:VMFYN;FIJ:
MFIJ:GIZ>F)B8E)24E965DY.3C8V-G9V=H:&AHZ.CJJJJK*RLL+"PKZ^OMK:V
MM[>WKJZNL[.SOKZ^O;V]M;6UM+2TL+"PIZ>GJ*BHO+R\Y>7EP<'!C8V-7U]?
MLK*R_________/S\_?W]________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________O[^_?W]_/S\____
MCX^/+BXN0T-#3$Q,145%/S\_.CHZ.CHZ.3DY.SL[/3T]0$!`0$!`0$!`04%!
M0D)"145%145%145%1$1$145%24E)2$A(1D9&2$A(3$Q,2DI*2DI*3T]/4%!0
M5%144E)24%!04E)2555565E96EI:7EY>8F)B7U]?6UM;8F)B7EY>9F9F8V-C
M;&QL;6UM;&QL;&QL;FYN<7%Q<'!P=G9V=G9V<W-S<G)R>7EY='1T=W=W>WM[
M>WM[?GY^@8&!AH:&AX>'C(R,DI*2C8V-BXN+D)"0CX^/C8V-B8F)B8F)BHJ*
MBXN+C8V-D)"0EI:6F)B8FIJ:F)B8DY.3C(R,B(B(B8F)@H*"@8&!B8F)BXN+
MBXN+B8F)A86%@H*"@8&!@("`>WM[>7EY=G9V=W=W<G)R<G)R<'!P<G)R=W=W
M@("`AX>'E)24FIJ:IZ>GP,#`OKZ^NKJZL[.SKJZNJJJJIJ:FDI*2CHZ.C8V-
M?W]_C8V-FYN;F)B8H:&AH:&AJ:FIKZ^OL+"PM;6UO;V]N[N[NKJZOKZ^O[^_
MN;FYM[>WL[.SKJZNIZ>GJJJJQ\?'Y.3DL;&QAX>'9F9FU-34_____/S\_O[^
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________?W]^_O[_/S\_/S\^OKZ965E,3$Q0T-#2DI*
M1T='2$A(0T-#/CX^/3T]/#P\/#P\/3T]/3T]/CX^/CX^0D)"145%2$A(1$1$
M0T-#145%0T-#04%!0T-#24E)24E)2$A(3$Q,2$A(5E966%A8555545%14U-3
M5E96555555558&!@8V-C75U=965E86%A9V=G965E<'!P;V]O;&QL;6UM<7%Q
M;V]O965E>GIZ<7%Q;FYN=75U=W=W=75U>WM[?'Q\?GY^@8&!?7U]@("`AH:&
MD)"0D)"0CHZ.B8F)BXN+C8V-B(B(?'Q\?7U]@("`CHZ.D9&1DI*2F)B8F9F9
MF)B8F9F9F)B8FIJ:FYN;DY.3BXN+@X.#A(2$A86%B8F)A86%AX>'A(2$@8&!
M@H*"?GY^>GIZ=75U<7%Q;6UM;V]O<G)R<'!P<W-S?W]_AH:&BXN+E965H:&A
MLK*RM;6UN[N[O;V]M[>WL;&QIJ:FF9F9CX^/A86%@X.#CHZ.DY.3E)24GY^?
MHJ*BJ:FILK*RL[.SN+BXN[N[N;FYO+R\Q,3$O[^_O+R\M[>WL;&QKZ^OK:VM
MK*RLN;FYV=G9W-S<EY>7<G)R@H*"_________/S\____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____O[^_?W]_?W]_?W]____W]_?;FYN,C(R145%2$A(1D9&/S\_/3T]/S\_
M/CX^/S\_/CX^/#P\.CHZ/#P\0$!`/S\_1$1$0D)"04%!0D)"0$!`04%!0D)"
M1T='3$Q,24E)3T]/2TM+4U-34%!04E)255555%1445%145%15E9675U=86%A
M8&!@:&AH9&1D9&1D:FIJ:VMK;&QL9V=G9V=G;V]O;V]O;FYN='1T=W=W<G)R
M<W-S>'AX=W=W>GIZ>GIZ?7U]@X.#@X.#@X.#@X.#B(B(@H*"AH:&BHJ*C(R,
MCX^/D)"0C8V-C(R,A86%@("`AH:&DY.3FIJ:FIJ:E965FYN;FYN;EI:6EI:6
MEI:6G)R<EY>7DY.3DY.3B8F)A86%@X.#@X.#@8&!?'Q\>'AX<W-S<'!P;V]O
M;FYN:FIJ;6UM<W-S=G9V>7EY@H*"BHJ*D)"0FIJ:IZ>GM+2TOKZ^P<'!NKJZ
MJJJJFYN;D9&1BHJ*@H*"C(R,D)"0DY.3EI:6F)B8F9F9I*2DIZ>GL;&QM+2T
MN+BXN;FYO+R\O[^_O+R\J*BHI:6EHZ.CI:6EIJ:FHZ.CI:6EN;FYWM[>R<G)
M@8&!9V=GJ*BH_____/S\_/S\_O[^________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________O[^
M_?W]____W=W=9V=G-#0T1$1$0D)"/#P\.CHZ.CHZ.CHZ/CX^/3T]/#P\.CHZ
M/#P\/S\_/3T]/CX^/CX^/S\_04%!0D)"04%!1$1$24E)2DI*1T='34U-3T]/
M3DY.24E)2DI*3DY.45%15%145%145U=775U=86%A7%Q<7U]?75U=8F)B:VMK
M9V=G:&AH9V=G965E;V]O=G9V='1T<'!P<G)R='1T=W=W>GIZ>GIZ>'AX>GIZ
M?GY^@X.#@X.#A86%@H*"@X.#A(2$AX>'AH:&BXN+D)"0EI:6F)B8EI:6DI*2
MC(R,C(R,CX^/EI:6FYN;EI:6GIZ>HJ*BFYN;EY>7FYN;HZ.CH:&AG9V=G9V=
MDI*2C8V-BXN+A86%@8&!>WM[=75U;6UM:VMK;V]O;V]O;&QL;&QL<'!P=G9V
M>7EY@("`BXN+E965F9F9IJ:FM;6UOKZ^L[.SGY^?EI:6GY^?KJZNG)R<AX>'
M@H*"AH:&D)"0E965DY.3F)B8GY^?I:6EK*RLK:VML+"PM[>WP<'!P\/#P,#`
MGIZ>FYN;EY>7EI:6GIZ>H:&AGIZ>IJ:FP<'!Y^?GIJ:F?GY^9F9FZNKJ____
M_/S\_?W]____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________O[^_O[^_/S\____U-3434U-
M,S,S0T-#0T-#/3T].#@X.3DY/#P\.SL[.CHZ/#P\.#@X/#P\/S\_/S\_/CX^
M/CX^0$!`1$1$1$1$1T='24E)145%1D9&34U-34U-34U-34U-3DY.4U-35E96
M5E9655556EI:9F9F65E9555575U=65E975U=8V-C:FIJ:6EI9V=G:6EI:&AH
M;FYN9V=G:6EI<7%Q=G9V@X.#>7EY='1T>GIZ?W]_@8&!AX>'A86%A86%@H*"
MAH:&?W]_BHJ*BHJ*CX^/CX^/E965DY.3DI*2EI:6F9F9F)B8F)B8F9F9G9V=
MH*"@I*2DJ:FIJZNKJ:FIJ:FIJZNKIZ>GHZ.CG)R<E)24D9&1D9&1AH:&A86%
M?GY^>GIZ<G)R:6EI:&AH;V]O<7%Q<G)R=G9V>7EY?'Q\@X.#E)24G9V=IJ:F
MMK:VQ,3$LK*RE965L[.SVMK:[N[N[.SLWM[>Q<7%I:6EJZNKEI:6DY.3E965
MH:&AHJ*BHZ.CJ:FILK*RM[>WMK:VO[^_P\/#PL+"KJZNKJZNHZ.CHJ*BHJ*B
MIZ>GJJJJJ*BHL[.SUM;6W]_?CHZ.<W-SCX^/_____O[^_?W]____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________O[^_?W]________TM+27EY>.#@X0T-#0D)"0$!`
M.SL[.CHZ.SL[.#@X.#@X.3DY.#@X.CHZ0$!`0T-#0T-#1$1$0T-#0T-#1D9&
M1T='24E)2TM+3$Q,2DI*4%!045%14E)24%!055555E965E967%Q<65E95555
M5U=775U=8F)B86%A7%Q<86%A9&1D9F9F9&1D:FIJ9V=G965E9F9F;&QL<'!P
M;6UM<W-S<G)R>7EY>GIZ=W=W>WM[?W]_?7U]@X.#BHJ*?'Q\B(B(A(2$AH:&
MC(R,AX>'B(B(CX^/DY.3E965F9F9H*"@I:6EJ:FII*2DJ:FIL+"PLK*RMK:V
MM;6UL;&QL+"PK*RLI*2DFIJ:D9&1BHJ*A86%@X.#?GY^>7EY<W-S<'!P;FYN
M;FYN9V=G9F9F<'!P>'AX>GIZ@H*"E965G)R<J:FIP\/#H*"@7EY>D9&1_O[^
M_________/S\\O+R____________G9V==W=WC8V-CX^/E965F9F9GY^?K:VM
MM+2TN+BXNKJZM[>WM[>WN;FYM;6UJJJJK*RLK:VMJJJJJ:FIIJ:FH*"@K:VM
MY>7ESL[.>WM[='1TM[>W_________O[^_O[^________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_O[^________________P\/#4U-3.3DY1$1$0D)"/#P\-S<W/#P\.3DY.CHZ
M.CHZ.SL[/3T]/CX^/S\_0T-#145%1$1$145%1D9&3DY.45%12DI*2DI*34U-
M34U-2TM+3T]/3DY.4E)25%144U-35%145%145E964U-386%A8&!@6%A86UM;
M:&AH9&1D8F)B9V=G:VMK:VMK;FYN;FYN:VMK<G)R;FYN;6UM='1T<G)R=G9V
M>GIZ>GIZ@("`>WM[?'Q\@H*"@H*"?W]_?GY^?GY^@X.#@("`@("`B8F)BHJ*
MCX^/DY.3G9V=H:&AIJ:FJ:FIL+"PLK*RM;6UN[N[O;V]NKJZM[>WL[.SK:VM
MFIJ:DY.3BHJ*?GY^>7EY?'Q\>7EY=75U<G)R<'!P;V]O;FYN:FIJ;&QL<G)R
M='1T=G9VDI*2F)B8L+"PJZNK>'AX24E)65E9IJ:FT]/3XN+BZ>GIWM[>U-34
MP<'!@8&!;&QL?7U]C(R,AX>'DY.3FYN;I*2DKZ^ONKJZN;FYM+2TN+BXM;6U
MO;V]N;FYK:VMK*RLKJZNK*RLK*RLK:VMH:&AF9F9OKZ^Y>7EJ*BH='1T?7U]
MYN;F_____/S\_/S\____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________/S\^_O[____
M____K:VM.SL[/3T]0T-#/CX^.3DY.CHZ.SL[/#P\/S\_0$!`04%!/S\_0$!`
M0D)"145%1T='2TM+2TM+3DY.34U-3$Q,34U-2TM+3$Q,2DI*3$Q,3T]/4U-3
M4E)24U-36EI:5E965E9675U=9F9F8F)B8V-C8&!@965E:6EI965E:VMK:&AH
M9F9F=75U>WM[=G9V?'Q\@("`=W=W<'!P<G)R='1T=G9V>'AX>'AX>7EY?7U]
M?GY^@H*">7EY>GIZ@X.#?W]_=75U<G)R@X.#A(2$AX>'@X.#B8F)F9F9J:FI
MJZNKL;&QM[>WN;FYMK:VNKJZOKZ^O[^_NKJZL+"PG)R<CHZ.A(2$A(2$=W=W
M=75U<G)R<'!P<'!P;&QL<7%Q<W-S=G9V>7EY?GY^>GIZD)"0DI*2BHJ*FYN;
MBXN+@("`?'Q\5555.CHZ2DI*75U=:VMK:FIJ8V-C5E96:VMKCX^/?W]_DY.3
MC(R,C8V-EY>7I*2DJJJJM+2TPL+"R<G)P\/#O+R\N;FYM;6UJ:FII:6EK*RL
MK:VMKJZNL;&QKZ^OI:6EKZ^OVMK:Y.3D=G9V<G)RF9F9_____O[^^_O[_O[^
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________O[^_/S\________OKZ^1T='/#P\
M1D9&1$1$.SL[.#@X-C8V.CHZ/3T]0D)"1T='1$1$0T-#2$A(24E)24E)3T]/
M34U-1D9&2$A(3DY.4E)25%146%A865E955554E)24U-37%Q<7U]?9&1D:6EI
M9F9F86%A86%A965E965E:6EI9V=G9&1D:FIJ='1T<'!P;V]O:VMK>'AX='1T
M;6UM='1T?'Q\A(2$>GIZ<'!P;6UM?'Q\?GY^>'AX=W=W=G9V=G9V;6UM9V=G
M<'!P?'Q\@("`>'AX>GIZ=G9V?7U]?'Q\@("`G)R<I*2DI:6EKZ^ON[N[OKZ^
MP\/#P,#`N[N[M;6UHJ*BG9V=DI*2:6EI<'!P?7U]>7EY;FYN='1T='1T<W-S
M;&QL;6UM<G)R=G9V?W]_A(2$BHJ*D9&1IJ:FN+BXK*RLM;6UOKZ^R<G)P\/#
MEI:6@8&!?7U]A86%F)B8J*BHL+"PC(R,=W=WF)B8F9F9G9V=HZ.CHJ*BIZ>G
MJJJJK:VMJ:FIKJZNM;6UO+R\L[.SKJZNJ:FIH*"@GY^?H:&AF9F9IJ:FJZNK
MHZ.CKZ^OY>7ER<G)>GIZ='1TO+R\_____O[^_?W]____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________?W]_O[^_/S\____^_O[HJ*B1$1$/S\_2$A(0T-#.CHZ.3DY
M0$!`0$!`0T-#1T='1D9&1T='1T='24E)1T='1T='2TM+4%!02TM+3T]/4U-3
M4E)25%145%144U-35E966UM;65E96EI:86%A965E8V-C965E965E9F9F9V=G
M;6UM;6UM;6UM<7%Q=W=W;6UM<'!P=W=W=75U>GIZ<G)R<G)R='1T=G9V>7EY
M>WM[=W=W>WM[>WM[=75U<7%Q;&QL;V]O;&QL8V-C:6EI;V]O<G)R<'!P;V]O
M>'AX@H*"AH:&C8V-F9F9G)R<HJ*BIJ:FL;&QO+R\PL+"Q<7%Q,3$OKZ^JZNK
MEI:6E)24CHZ.86%A8&!@=W=WA(2$>7EY='1T=75U<W-S<W-S<'!P>'AX@("`
MA86%AX>'BHJ*BXN+G)R<LK*RL+"PO;V]L;&QL+"PL;&QL[.SLK*RL[.SJ:FI
MFIJ:B(B(@("`BHJ*B(B(F)B8HJ*BHJ*BJ*BHM+2TP\/#R,C(Q<7%O;V]O+R\
MM+2TMK:VK:VMHZ.CGY^?G9V=H:&AI:6EJ:FIIZ>GH:&AJZNKQ,3$[N[NIJ:F
M=G9VBXN+Z>GI_____?W]_?W]_?W]________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____O[^_____O[^A86%.CHZ/S\_24E)0$!`/3T]0T-#0T-#0T-#1$1$1D9&
M1$1$0T-#145%145%145%1T='3$Q,24E)3DY.5%1445%12TM+3T]/5%145U=7
M6UM;65E975U=:&AH8F)B7%Q<7EY>:VMK:VMK9&1D='1T=75U;6UM;V]O<7%Q
M:VMK;&QL;FYN<7%Q;V]O:FIJ<7%Q<W-S=G9V<G)R<7%Q>7EY=G9V<G)R<G)R
M;6UM<'!P8V-C8F)B86%A9F9F965E86%A9&1D9F9F:VMK<'!P=75U?'Q\AX>'
MEY>7EY>7G9V=J:FIL[.SO;V]Q<7%P<'!N+BXL[.SCX^/A86%B8F)?'Q\5E96
M4U-3A86%AX>'@("`>WM[>GIZ=G9V<7%Q<'!P>GIZ@("`A(2$C(R,B(B(FIJ:
MI*2DGIZ>FYN;J*BHHJ*BG)R<G9V=F9F9BHJ*>'AX>'AX@("`AX>'B8F)BXN+
MG9V=H:&AG)R<K*RLM+2TQL;&S,S,R,C(R,C(P\/#M;6UMK:VL;&QJZNKJJJJ
MIZ>GJ:FIK:VMK:VMJJJJIJ:FHZ.CI*2DWM[>WM[>@X.#=G9VM+2T________
M_/S\_?W]____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________?W]_/S\________
ME9650T-#0D)"3$Q,1D9&0$!`/3T]0$!`04%!1$1$1$1$0D)"145%1$1$2DI*
M2$A(2DI*2DI*2$A(3$Q,3DY.3T]/2DI*45%16%A85E966EI:6UM;7U]?86%A
M8F)B8&!@:&AH:&AH86%A;&QL8V-C86%A:6EI9F9F='1T?GY^<'!P:VMK;6UM
M?7U]>'AX='1T>'AX=W=W;&QL:VMK:FIJ:FIJ;FYN9F9F:&AH8V-C9F9F965E
M9&1D75U=6UM;8V-C8V-C86%A7U]?9V=G:FIJ;FYN@8&!CHZ.EY>7FIJ:H:&A
MK:VML;&QL+"PK:VMEY>7A86%A86%B(B(@H*"?GY^6%A83$Q,;V]O@X.#A(2$
M@("`?GY^?W]_>GIZ>WM[?GY^@H*"G)R<E)24EY>7FYN;H:&AIJ:FF9F9CHZ.
MBHJ*AX>'@H*"AH:&='1T<7%Q>'AX?'Q\AH:&D9&1E)24GIZ>HZ.CJZNKKZ^O
MN;FYQ,3$O[^_P<'!P\/#O[^_N;FYLK*RK*RLK:VML;&QK*RLJ:FII:6EIJ:F
MIJ:FI*2DJJJJM;6UV]O;S\_/>7EY>WM[S<W-_____?W]^_O[_?W]________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________?W]_/S\_?W]____[^_OB8F).SL[1D9&2TM+
M0D)"/CX^0D)"0$!`0T-#1D9&1$1$145%145%1$1$1T='24E)2$A(2$A(24E)
M2$A(3DY.4%!055555U=75%146%A886%A86%A7EY>8F)B8F)B9&1D8&!@965E
M:&AH:6EI9V=G:&AH9&1D9V=G<W-S<G)R;6UM<7%Q;FYN;V]O;&QL;&QL<W-S
M<W-S;V]O:6EI;6UM;6UM9V=G9&1D965E8F)B7U]?6EI:6UM;6EI:6UM;6UM;
M65E96UM;7%Q<86%A:6EI=75UA86%BHJ*CX^/E965G)R<HZ.CHZ.CFYN;D9&1
MEY>7C8V-BXN+AX>'AX>'>WM[45%145%1:VMKA(2$AH:&@H*"?7U]?GY^@8&!
MA(2$@H*"FYN;GIZ>GY^?K*RLJZNKI*2DFIJ:E965BXN+@H*">WM[?W]_?7U]
M@("`@X.#@("`B(B(@("`@X.#EY>7JZNKL[.SO+R\NKJZQ\?'S,S,Q,3$NKJZ
MO;V]O+R\M[>WM+2TK:VMKJZNL+"PKJZNJ:FIJ:FIJJJJJZNKJ*BHL[.ST-#0
MZ.CHJ*BH<G)RGIZ>]?7U____^_O[_/S\____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____O[^_O[^_O[^_O[^____[.SL=75U/S\_0T-#2$A(0T-#0$!`/CX^/S\_
M0$!`0D)"0D)"04%!0D)"1$1$145%24E)2$A(3$Q,2DI*34U-45%15%144U-3
M4U-365E97U]?75U=86%A7%Q<7%Q<86%A7%Q<8&!@965E:6EI;6UM;FYN:VMK
M:6EI:VMK=75U=75U='1T;6UM=75U<G)R;FYN<7%Q<W-S;V]O;&QL;&QL:&AH
M9V=G9F9F8F)B7EY>7EY>5E965U=755555%1445%145%14E)24E)25U=78&!@
M9V=G>7EYAH:&BHJ*BXN+DY.3FIJ:FIJ:E965D)"0D9&1BXN+B8F)CHZ.B(B(
MC(R,<'!P4U-34U-3;FYN?W]_@8&!@X.#A86%B8F)C8V-BXN+EI:6HZ.CJ:FI
MJZNKHZ.CG9V=EY>7DY.3BHJ*@("`=W=W?'Q\@X.#B8F)@X.#@H*"D9&1CX^/
MD)"0D9&1GIZ>H*"@L;&QO;V]Q\?'RLK*Q,3$N;FYN+BXM;6UL;&QM;6UL;&Q
MKJZNK:VMK:VMJZNKJZNKKJZNK*RLJ*BHI:6EMK:VUM;6S\_/BHJ*>GIZOKZ^
M_?W]_O[^_?W]________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________?W]
M_?W]____[^_O>'AX.CHZ1T='24E)0T-#/3T]/3T]/S\_/S\_/S\_0$!`04%!
M1$1$145%24E)1T='2TM+24E)3$Q,34U-3DY.34U-3T]/5E9675U=555575U=
M75U=75U=7EY>7U]?8F)B:6EI9&1D:6EI;6UM:VMK:FIJ;6UM?GY^>'AX<G)R
M;6UM='1T<'!P;V]O<'!P<7%Q;&QL;FYN:VMK965E:&AH:6EI8&!@75U=75U=
M5E964U-33T]/34U-24E)2DI*2TM+3$Q,34U-3T]/6EI:;6UM?'Q\A(2$B(B(
MC8V-D)"0CX^/CHZ.D)"0E965D)"0B8F)BHJ*@H*"@X.#?GY^9&1D4U-365E9
M9F9F=G9V?GY^A(2$C8V-CHZ.CHZ.E)24G9V=I*2DIJ:FH*"@GIZ>E)24AH:&
M@8&!?'Q\<'!P<G)R>'AX@8&!@8&!AH:&CX^/C(R,FYN;I:6EH:&AFYN;JZNK
MNKJZN+BXO[^_QL;&O[^_N;FYMK:VL[.SM;6UL;&QM+2TL;&QK:VMK:VMJZNK
MJJJJJ:FIJZNKIJ:FI*2DL[.SV]O;N+BX>WM[BHJ*W=W=_____O[^________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________?W]_/S\_?W]____YN;F:6EI
M-#0T2$A(2DI*0D)"0$!`04%!/S\_/3T]/S\_0$!`0T-#145%2$A(1D9&1T='
M3$Q,3T]/34U-34U-34U-3DY.55555E966%A865E95U=77EY>75U=8V-C9&1D
M;6UM965E965E:&AH:FIJ;&QL;&QL<G)R='1T;6UM;FYN=75U;FYN;&QL<'!P
M<G)R;V]O<W-S<7%Q;&QL;V]O965E6UM;7%Q<86%A4U-34%!03$Q,24E)145%
M145%2$A(2$A(34U-3T]/4U-386%A<G)R>WM[?W]_@8&!BHJ*B8F)@8&!@8&!
MB(B(BHJ*@H*"=G9V>7EY<W-S<W-S:&AH55553T]/6%A8:FIJ='1T=G9VBXN+
MBXN+B8F)E)24E965G9V=GY^?G)R<FYN;D)"0?7U]>'AX>'AX=75U<'!P;6UM
M<W-S@X.#DI*2CHZ.C(R,EY>7HZ.CI*2DKJZNQ,3$R,C(P,#`P\/#Q\?'O;V]
MO[^_P,#`NKJZN[N[NKJZNKJZL[.SL[.SKJZNJ:FIIZ>GJZNKJZNKJJJJH:&A
MH:&ARLK*V]O;G9V=;FYNJZNK^/CX________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________O[^_O[^_/S\________W=W=:&AH/S\_1T='2TM+1$1$
M0D)"0$!`/S\_0$!`0D)"0D)"145%0T-#0T-#0T-#1T='1T='2DI*3DY.5%14
M5%145%145%147%Q<6UM;55555U=77U]?965E7U]?:FIJ:6EI:VMK;6UM;FYN
M;6UM:VMK:VMK;FYN;V]O<'!P<'!P<'!P<7%Q;V]O;&QL;FYN<G)R<7%Q:VMK
M:FIJ9V=G8&!@75U=9V=G5%142DI*1T='1T='1$1$0D)"04%!0$!`1D9&2DI*
M34U-55559F9F='1T=G9V>WM[B(B(B(B(@X.#@("`?'Q\?'Q\='1T:6EI;V]O
M;6UM:6EI:&AH7%Q<1D9&3DY.7EY>965E:VMK?7U]BHJ*C8V-E)24E)24E965
MD9&1D9&1D)"0AX>'>7EY<7%Q<W-S=75U;V]O='1T=W=W>7EY?GY^@8&!AX>'
MEI:6FIJ:GY^?L[.SO[^_QL;&S<W-T-#0T-#0S\_/OKZ^PL+"P<'!N[N[N+BX
MM;6UL;&QKZ^OIZ>GJ*BHIZ>GJJJJHJ*BI*2DHJ*BI:6EJZNKUM;6R<G)AH:&
M=75US,S,_____O[^_/S\_?W]____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____O[^_____?W]____UM;6;FYN0$!`24E)2$A(0D)"0$!`0$!`04%!0D)"
M0T-#1$1$0D)"0D)"1$1$0D)"1$1$24E)2DI*45%1555555554U-36%A87EY>
M6UM;7%Q<8&!@8V-C8&!@965E9&1D:FIJ;FYN<W-S:FIJ:6EI:6EI:&AH;FYN
M<W-S<7%Q<G)R<'!P;6UM;6UM<'!P;V]O:VMK9V=G:&AH965E9F9F7EY>9&1D
M65E92DI*0T-#0T-#0T-#0T-#0$!`/#P\/CX^04%!2$A(3T]/6EI:;6UM='1T
M=W=W@H*"BXN+AX>'>GIZ='1T<7%Q;&QL:6EI9F9F965E7EY>7%Q<7%Q<3T]/
M1D9&5E9675U=9&1D<'!P>GIZA86%D)"0E)24DY.3D)"0C8V-B(B(?7U]=G9V
M<'!P<7%Q<'!P;6UM?'Q\B8F)@X.#A(2$B8F)CHZ.C8V-DY.3HZ.CKZ^OL;&Q
MNKJZR\O+T='1U=75V=G9OKZ^O+R\N[N[M;6UM+2TKZ^OK*RLI*2DH*"@IZ>G
MI:6EIZ>GHJ*BFYN;HJ*BH*"@GIZ>N;FYW-S<K:VM=G9VD9&1ZNKJ_____/S\
M_?W]________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________/S\____
M____UM;68&!@,S,S2$A(1$1$/S\_/#P\/CX^/CX^/S\_04%!0T-#04%!1D9&
M0T-#0T-#2$A(2TM+2TM+34U-45%14E)24U-37%Q<8F)B7U]?86%A86%A8V-C
M9&1D8V-C9V=G:VMK:&AH4%!03DY.7EY>6EI:65E98&!@<'!P=G9V;V]O<'!P
M<'!P<G)R=75U<7%Q:&AH:VMK:VMK:6EI7EY>8&!@8F)B3DY.0T-#1$1$0T-#
M04%!0$!`/S\_.SL[/3T]145%3$Q,5%148F)B<G)R?'Q\A86%CX^/BXN+>WM[
M;V]O:FIJ9&1D6UM;75U=7U]?6%A85E966%A865E93$Q,1$1$4%!07EY>:&AH
M;V]O='1TAX>'E)24E)24BXN+A(2$?W]_=W=W<W-S;6UM:VMK<'!P=G9V=W=W
M?GY^A86%CHZ.FIJ:G)R<FIJ:E965FYN;J:FIN[N[Q,3$P\/#Q\?'S,S,R<G)
MN[N[M;6UK:VML+"PL+"PJZNKIZ>GH:&AGIZ>G9V=I:6EJZNKJ:FIHJ*BI:6E
MH:&AH*"@I*2DT='1S\_/AX>'<W-SO[^______O[^^OKZ________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________?W]_____O[^____V=G99F9F/CX^
M145%1$1$/CX^/CX^/CX^0$!`/3T]0$!`1$1$145%145%0T-#0T-#1T='2DI*
M3$Q,3DY.4E)25%146%A86EI:6UM;7%Q<965E9F9F:&AH:FIJ;6UM9V=G>WM[
MM;6UU-34X>'A[.SL[.SLO+R\B(B(9V=G;&QL>WM[>'AX<7%Q=W=W>7EY='1T
M<G)R;&QL;FYN:VMK7U]?965E7EY>1D9&145%0T-#04%!0$!`04%!0$!`0$!`
M/CX^0D)"1D9&5U=7:&AH?'Q\AH:&BXN+C8V-A(2$<7%Q9F9F6UM;7EY>5E96
M5%1445%14E)24%!03DY.34U-/CX^-S<W5E968F)B9F9F;6UM;V]O?'Q\@X.#
M>WM[<W-S;V]O;&QL:6EI9V=G965E:&AH;&QL9&1D<G)R<G)R=W=WA(2$FIJ:
MF9F9H*"@JJJJL;&QN;FYO[^_P<'!R<G)Q,3$Q\?'N+BXL+"PM;6UM;6UL+"P
MKJZNL;&QJ:FII*2DH*"@D9&1D9&1FYN;H:&AI:6EJZNKHZ.CGIZ>L+"PUM;6
MN[N[?'Q\<G)RV]O;_____/S\____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________O[^_____?W]________S,S,9V=G0T-#1D9&0D)"/S\_/#P\
M/S\_0D)"04%!0$!`0T-#0T-#1$1$1T='2$A(34U-34U-4%!04%!05%146UM;
M6UM;8V-C8&!@8F)B7U]?8F)B;&QL:VMK8&!@SL[.____________________
M________JJJJ5555;6UM<G)R<'!P>'AX@X.#B8F)?'Q\<W-S<G)R:FIJ8V-C
M8V-C9F9F55550D)"0$!`0$!`/S\_/CX^/S\_/S\_/#P\/3T]0$!`4%!07U]?
M=75U@X.#@H*"BXN+B(B(;6UM8V-C6UM;8&!@5U=73T]/34U-2TM+2$A(1$1$
M1T='0D)"-34U.SL[5E968&!@9V=G9V=G:&AH<G)R<7%Q;&QL:6EI965E8V-C
M965E8V-C8F)B86%A:6EI<7%Q='1T?7U]AX>'A86%CHZ.GY^?GY^?IJ:FJZNK
MMK:VP\/#Q\?'R<G)R,C(O[^_M[>WN+BXM[>WKZ^OK*RLKZ^OIJ:FH:&AGIZ>
MG9V=H:&AH*"@EY>7E)24F9F9FIJ:FIJ:G9V=OKZ^W-S<EI:6;&QLBXN+____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________Q\?'45%1-C8V1D9&/S\_.SL[/#P\0$!`0D)"0$!`04%!
M1D9&0T-#2$A(1D9&2DI*5%145%144U-35E9675U=8&!@965E7U]?9V=G9&1D
M<'!P?GY^9V=G/3T]=75UQ\?'\O+R_________?W]S<W-IJ:F?GY^75U=5E96
M86%A;FYN<'!P=W=W@8&!?GY^=G9V<G)R=75U:VMK965E7EY>:6EI2DI*/CX^
M/CX^/#P\/3T]/3T]/#P\.CHZ/S\_04%!145%5555:FIJ?7U]AX>'A86%AH:&
M<'!P9V=G65E955554E)23DY.24E)1$1$04%!0D)"/S\_0T-#0$!`,3$Q.SL[
M5U=7:6EI8F)B7U]?9&1D:6EI:&AH8F)B75U=8F)B9F9F7U]?7EY>8&!@:6EI
M8F)B>WM[>WM[B8F)C(R,?GY^CHZ.E965H*"@L[.SQ,3$S<W-T='1S<W-SL[.
MO;V]M;6UKJZNHZ.CI:6EK*RLIZ>GGIZ>FYN;I*2DJZNKJZNKJ:FIKJZNL+"P
MHZ.CBHJ*AH:&BXN+HJ*BU]?7O[^_@("`6EI:W]_?____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________?W]_O[^____
MW]_?;&QL1$1$24E)1$1$0$!`.3DY/3T]1$1$0$!`/CX^145%145%1T='3DY.
M4E)245%14%!05E967%Q<6UM;86%A:6EI;6UM<'!P<W-SHJ*BH:&A@X.#7%Q<
M.SL[-#0T.SL[0$!`145%5555:&AHCHZ.F)B86%A88F)B?'Q\>GIZ>7EY>GIZ
M@X.#?W]_A86%>'AX<W-S;&QL;FYN:VMK8V-C1D9&/3T]/CX^.SL[.3DY.#@X
M.#@X.CHZ04%!1$1$1D9&5555;&QL>GIZB(B(DY.3BXN+>'AX9V=G5U=73T]/
M2DI*145%0D)"04%!/3T]/3T]/3T]/#P\/S\_,#`P-34U24E)7U]?9&1D8F)B
M86%A965E9&1D8V-C7U]?75U=6UM;75U=6UM;65E98&!@>'AX:FIJ:&AH?7U]
MDY.3F9F9CX^/CHZ.G9V=J:FIP<'!T-#0T='1S,S,O[^_N;FYIZ>GH:&AEI:6
MBXN+C8V-FYN;H:&AF)B8D)"0DY.3HZ.CJ:FIK:VMI:6EI:6EF)B8AX>'=75U
MG)R<W-S<HZ.CAX>'86%A[^_O_____/S\____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________O[^_/S\_____O[^Q\?'9&1D0T-#145%
M0T-#/3T]0$!`04%!1$1$145%0T-#1$1$2DI*2TM+3$Q,45%15E966EI:8F)B
M965E8F)B9V=G965E8F)B:FIJF)B8PL+"LK*RP,#`P,#`I:6ED9&1BXN+E965
MF9F9G9V=FIJ:<7%Q8&!@<W-S>7EY@8&!?'Q\>GIZC(R,HJ*BG9V=@X.#<7%Q
M<7%Q;V]O;&QL:&AH6%A80$!`/CX^/CX^.CHZ.SL[.CHZ.3DY/#P\/S\_0T-#
M3T]/9&1D=G9VA86%CX^/B(B(>7EY;6UM7%Q<4%!024E)0T-#0$!`/CX^.SL[
M.3DY.SL[.SL[/#P\-C8V-#0T.SL[4E)275U=9&1D86%A7U]?7EY>8F)B7EY>
M6UM;6%A85E966%A86EI:86%A:&AH;FYN=G9V>WM[?GY^C8V-E965C(R,KJZN
MPL+"Q,3$RLK*R,C(P<'!M+2TKZ^OKJZNKZ^OIZ>GEI:6BXN+AX>'BXN+CHZ.
ME965G9V=HZ.CHZ.CIJ:FH:&AF9F9EI:6E965CX^/C(R,N+BXKZ^O?W]_<7%Q
MHJ*B_____O[^_?W]____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________O[^_O[^________PL+"6%A804%!2$A(1$1$0D)"/S\_0T-#
M0T-#1D9&1D9&2DI*3DY.45%15U=765E97EY>8&!@965E8F)B8F)B:6EI:&AH
M;&QLAH:&R<G)VMK:O;V]L;&QM;6UL[.SNKJZO;V]K:VME965='1T8V-C>7EY
M?7U]@("`BXN+AH:&@8&!@("`F9F9HZ.CGIZ>A(2$?GY^=W=W;6UM:6EI;6UM
M4E)2/#P\/CX^/CX^.3DY/CX^.CHZ.CHZ/3T]04%!24E)75U==75UAX>'C8V-
MBHJ*?GY^<W-S8V-C6%A82TM+0D)"0$!`0$!`/3T].CHZ.CHZ.CHZ.CHZ.CHZ
M,S,S,C(R0$!`5E9675U=8V-C7U]?6EI:6EI:6EI:5U=75U=74U-35%146%A8
M65E9965E9F9F=W=WA(2$B(B(E)24G9V=HJ*BM[>WOKZ^PL+"S<W-Q,3$O+R\
MM+2TJJJJJ*BHJ:FIH:&AG9V=G)R<F9F9CHZ.B(B(B8F)DI*2IJ:FH:&AG9V=
MFIJ:F)B8DY.3D9&1CX^/CHZ.H*"@O;V]E965?'Q\:&AH[N[N____^_O[_?W]
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________R,C(9F9F2$A(2$A(1D9&/3T]/#P\0D)"0T-#1D9&3$Q,45%1
M4U-35%145E966%A86EI:8&!@7%Q<8V-C9V=G9V=G965E965E:FIJEI:6O+R\
MIJ:FF)B8FYN;D)"0C(R,>7EY:FIJ<W-S@X.#A(2$AH:&A(2$@8&!AH:&B(B(
MB(B(DY.3@8&!CHZ.E)24A(2$@("`>'AX<7%Q;V]O:6EI2DI*/CX^/CX^/S\_
M.CHZ.SL[.3DY.SL[04%!1D9&3T]/9&1D?'Q\B(B(B8F)?GY^>'AX9&1D75U=
M4U-31T='0T-#/S\_.CHZ.3DY.#@X.3DY.3DY/#P\.3DY,S,S,3$Q/S\_3T]/
M65E97U]?8V-C6UM;6%A85E965%145U=75E964U-36%A8;&QL8V-C9F9F>'AX
MC(R,E965FIJ:KZ^ON;FYP,#`PL+"R,C(R\O+Q<7%M+2TLK*RI:6EF9F9K*RL
MU=75[.SL____]?7UV=G9T]/3K*RLCHZ.EI:6FIJ:EI:6D9&1C8V-C8V-C(R,
MBXN+CHZ.K*RLQ<7%?7U]>7EYAH:&_________?W]____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________?W]_____?W]O[^_
M8&!@04%!2$A(145%0$!`0D)"145%1T='3$Q,4%!04U-35%145E965E9665E9
M7EY>8&!@8V-C7U]?8V-C:&AH:&AH:FIJ:6EI<G)R?W]_AH:&AX>'>'AX>GIZ
M>WM[=G9V>WM[>7EY?GY^A86%C8V-CHZ.CX^/CX^/B8F)CHZ.BHJ*AX>'A(2$
M?W]_@("`?'Q\=G9V;V]O:6EI7%Q<0D)"/S\_04%!04%!/CX^.#@X/3T]0T-#
M0T-#2TM+65E9<7%QA(2$C8V-DY.3@H*":FIJ8V-C7EY>34U-24E)0D)"/3T]
M.3DY.3DY.3DY.#@X.SL[.#@X.#@X,3$Q-34U0$!`55555E967%Q<7EY>6%A8
M5%144U-35%144U-35%145U=77EY>8V-C9V=G>GIZBHJ*CHZ.EI:6I:6EK*RL
ML[.SO+R\RLK*RLK*PL+"M+2TL+"PCX^/>7EYT]/3____________________
M____^_O[C8V-;6UMB(B(C(R,BHJ*B8F)BXN+D)"0DY.3DY.3HJ*BQ,3$J*BH
M>'AX>WM[RLK*_____O[^_________O[^____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________O[^_?W]_____O[^PL+"65E90D)"24E)145%
M0D)"0T-#145%1T='34U-4E)24U-355556%A86EI:65E99F9F75U=7EY>9&1D
M:6EI:&AH;6UM<7%Q;V]O;V]O<'!P<'!P=75U>WM[>7EY=W=W?'Q\>WM[@H*"
MB8F)E965EY>7D9&1FIJ:B(B(B8F)E)24B8F)AH:&A(2$?GY^>7EY=75U<'!P
M:FIJ:6EI5U=704%!/CX^1D9&04%!.SL[/#P\0T-#1$1$145%4%!09F9F?'Q\
MD9&1F9F9D9&1?7U]<'!P9F9F5E9634U-1$1$/S\_.SL[.CHZ.CHZ.CHZ.3DY
M.#@X.CHZ,C(R,C(R,S,S1T='45%15E9675U=75U=5U=74E)24%!03DY.45%1
M5%145E967U]?8V-C<G)R>GIZ?7U]BHJ*F)B8IJ:FL+"PN[N[Q<7%R<G)PL+"
MN[N[L;&Q>7EY3T]/@H*"OKZ^S<W-U=75U=75S,S,N[N[G9V=?W]_<W-S@8&!
MBXN+C(R,CHZ.D9&1EI:6F9F9G9V=HZ.CN+BXU=75EY>7<G)RC8V-[^_O____
M_O[^_O[^_?W]_O[^____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________P<'!75U=/CX^24E)2$A(04%!0T-#145%2DI*
M34U-3DY.4E)25%145E9665E98F)B7%Q<7U]?86%A9F9F;&QL;6UM<'!P='1T
M>'AX=W=W<G)R>'AX?GY^>WM[?W]_@8&!AH:&C8V-D9&1DI*2D9&1DY.3DY.3
MCX^/DY.3D)"0BHJ*AH:&A(2$?GY^?W]_?7U]=G9V;V]O:FIJ:6EI5%14.CHZ
M04%!1T='145%/S\_/S\_0D)"0T-#2$A(6%A8;V]OCX^/EI:6GIZ>D9&1?'Q\
M<'!P8F)B5U=72TM+0$!`/S\_/CX^.CHZ.3DY.#@X.3DY.CHZ-S<W,3$Q,C(R
M-S<W04%!3T]/5E9675U=7EY>5E964%!02TM+3DY.4E)24E)27%Q<8&!@8&!@
M9F9F<G)R@("`CHZ.GIZ>JZNKM[>WO[^_S\_/T='1Q<7%O[^_D9&1?GY^9V=G
M6%A89V=G<'!P<7%Q:6EI:6EI<G)REI:6?7U]@X.#F)B8F9F9GIZ>GY^?HJ*B
MHZ.CJJJJK*RLL;&QV=G9W-S<@("`<W-SKZ^O_____O[^_?W]_?W]_O[^____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________/S\
M________PL+"4%!0.3DY24E)2$A(145%1$1$1T='24E)2TM+3DY.4%!045%1
M6EI:8F)B86%A8V-C8F)B965E:6EI;&QL;V]O=75U>GIZ?'Q\?W]_='1T?W]_
M@("`A(2$B(B(C(R,C8V-CHZ.D9&1E)24F9F9E)24E965G9V=E965D9&1DY.3
MCHZ.AX>'@X.#@("`?'Q\=G9V<'!P;&QL965E24E)-C8V1$1$2$A(2$A(0$!`
M0D)"0T-#1$1$4E)29F9FB(B(EI:6G9V=F9F9@("`>'AX9V=G7U]?4%!00$!`
M1$1$/S\_.3DY.#@X.3DY.#@X.#@X.3DY-34U,3$Q,S,S-S<W0T-#4U-34U-3
M6%A87%Q<5U=73DY.2TM+34U-3DY.5U=77EY>86%A9F9F;&QL>WM[BHJ*E965
MHJ*BM;6UQ\?'T]/3T-#0Q\?'SL[.Q<7%KZ^OJ:FIG)R<BHJ*@X.#CHZ.GIZ>
MG)R<E965C8V-?7U]EI:6I*2DHJ*BI:6EIJ:FJ*BHK:VMM+2TMK:VMK:VSL[.
MYN;FP\/#;6UMA(2$X>'A_____O[^_O[^____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________?W]_O[^________Q,3$5U=7
M04%!2DI*2$A(1$1$1$1$1T='3$Q,34U-4E)25E9655557%Q<75U=86%A86%A
M:6EI;&QL:6EI;6UM=75U>WM[?'Q\=G9V@H*"?7U]?'Q\A(2$AH:&BHJ*D9&1
MDY.3E965E)24DI*2D9&1F9F9G)R<CHZ.DI*2FIJ:DY.3CX^/BXN+BHJ*@X.#
M?W]_?'Q\=G9V;6UM7U]?0T-#.SL[0T-#1D9&1T='145%145%0T-#2$A(6EI:
M@X.#D)"0F9F9GIZ>CHZ.@8&!;FYN965E5U=724E)0T-#/S\_/#P\.SL[.3DY
M.3DY.3DY.#@X.3DY-#0T,#`P,C(R-S<W1$1$3DY.45%16%A87%Q<5E963T]/
M2TM+3T]/4U-35E9675U=9F9F;V]O>GIZBXN+FYN;J:FIM[>WP\/#RLK*TM+2
MR<G)S<W-VMK:V-C8R<G)L+"PI:6EHJ*BI:6EHJ*BD)"0B(B(C8V-HJ*BKZ^O
MJJJJK*RLM;6UM+2TL+"PM[>WOKZ^PL+"Q,3$TM+2XN+B\/#PK*RL<G)RHZ.C
M_____O[^_?W]________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________O[^_____/S\________P,#`8&!@04%!2$A(2DI*145%
M1T='3$Q,3T]/45%15%1455555%145U=76EI:7U]?:&AH:VMK;6UM<'!P=W=W
M?'Q\>'AX;FYN?7U]>'AX>7EY@("`?GY^@("`B8F)D)"0DI*2C8V-DY.3CHZ.
MC(R,E)24D9&1D9&1EI:6DI*2D)"0C8V-C(R,AX>'@("`?'Q\=W=W<'!P;&QL
M7%Q</CX^/CX^0T-#2DI*24E)2$A(145%145%4%!0>GIZAH:&DY.3G9V=F)B8
MC(R,>7EY;6UM86%A5%142$A(0D)"/CX^/3T].3DY.3DY.CHZ.3DY.CHZ.#@X
M+R\O,#`P,C(R-#0T/CX^3DY.4U-36%A87%Q<5E963T]/3$Q,4%!045%15U=7
M8&!@:6EI=G9VBHJ*G9V=K:VMOKZ^P,#`Q,3$V-C8S\_/Q\?'R\O+S<W-SL[.
MP<'!M;6UJ:FII*2DG9V=G)R<HZ.CL+"PL+"PL[.SM;6UM[>WOKZ^N[N[NKJZ
MP\/#R\O+T]/3U]?7W-S<Z>GI]O;V[>WMD)"0>7EYXN+B_____/S\_O[^____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________O[^_/S\________T-#08V-C04%!2TM+3$Q,2DI*2DI*1D9&3$Q,
M45%145%15U=75U=75U=76EI:86%A9F9F:FIJ;6UM;FYN>7EY=75U?'Q\=G9V
M@8&!@H*"AX>'AH:&AX>'CHZ.DY.3E965E965E965D9&1D)"0EI:6FIJ:FIJ:
ME965F)B8E965D9&1BXN+A86%AX>'?'Q\='1T<G)R:&AH9V=G3DY.-S<W0D)"
M2$A(3DY.2$A(145%1D9&7EY>;&QL=G9VD9&1FIJ:E)24A86%=W=W;V]O86%A
M5U=73$Q,145%04%!/#P\.CHZ.SL[/#P\.CHZ-S<W.CHZ.3DY.#@X,C(R+R\O
M,3$Q.SL[34U-5%1455556UM;6EI:4U-34%!055555E968&!@<7%Q?GY^E965
MJJJJNKJZV-C8Z>GI[>WMX^/CV-C8U-34Q\?'O;V]L;&QM;6UN[N[M;6UL+"P
MN[N[R<G)RLK*Q<7%P<'!QL;&R,C(R\O+R<G)QL;&S<W-V]O;ZNKJ\?'QZNKJ
M\O+R\O+R^?GY^_O[IJ:F965EVMK:_____O[^________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________?W]_?W]
M_____O[^P<'!7U]?0D)"2TM+2TM+24E)34U-2TM+24E)45%15U=74E)24E)2
M555565E98&!@965E:6EI;FYN=W=W>WM[?'Q\?W]_AX>'A86%@("`A(2$A86%
MBXN+E)24DI*2D)"0CHZ.E965G9V=E)24F)B8F)B8DI*2F9F9G)R<E965CX^/
MCHZ.C8V-@("`>7EY=75U;&QL:VMK75U=/S\_/3T]145%34U-4U-32TM+1D9&
M5E96:6EI<7%QBHJ*E965CX^/C(R,>WM[<'!P9F9F7EY>5%1424E)0D)"0$!`
M/3T]/3T].CHZ.SL[.CHZ.#@X.CHZ.3DY-C8V,#`P,C(R-S<W/3T]3T]/5E96
M3T]/5U=76UM;5E964E)25U=77U]?:FIJ>7EYDY.3K*RLPL+"VMK:Z.CH[N[N
MZNKJWM[>U]?7T]/3T='1QL;&O[^_Q,3$PL+"P\/#O;V]Q<7%T='1T='1SL[.
MT-#0T='1T='1UM;6U=75S\_/SL[.T]/3X>'AW-S<[.SL\O+R]/3T^/CXN+BX
M4%!0FYN;____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________P,#`2DI*
M,S,S1D9&3$Q,2DI*34U-34U-2TM+5U=74%!03T]/45%165E98&!@7EY>9&1D
M:VMK:6EI;FYN?GY^AH:&@8&!?'Q\?W]_B8F)DI*2CHZ.BXN+E)24FIJ:C8V-
MD9&1F)B8I*2DH:&AEY>7E965DY.3BXN+CHZ.C8V-B(B(@H*"@("`@8&!>7EY
M=75U<7%Q:6EI34U--34U/S\_3$Q,4E)23$Q,0T-#34U-7U]?;FYN?W]_B8F)
MBHJ*BHJ*?W]_<W-S;&QL9&1D6%A82DI*0D)"04%!/3T]/#P\.SL[.CHZ.SL[
M.#@X.#@X.3DY.3DY-#0T,3$Q-#0T-#0T0T-#5E9665E93$Q,555565E95555
M5%146UM;:&AH;FYNB(B(I*2DO+R\UM;6Z.CH\/#P[N[NZ^OKWM[>U=75TM+2
MU-34SL[.R<G)T-#0W=W=T]/3R,C(QL;&Q\?'S\_/U-34U=75V-C8U]?7T]/3
MU-34S<W-P,#`PL+"NKJZQ\?'U=75S<W-S<W-M+2T6%A86%A8W-S<________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________?W]________VMK::6EI0T-#1$1$1$1$/CX^
M0D)"0T-#0T-#3T]/555565E98&!@8F)B965E965E;6UM<G)R;6UM:FIJ;&QL
M;6UM>7EYAX>'@X.#A(2$BHJ*CX^/DY.3E)24C8V-DI*2C8V-C8V-DY.3CX^/
MD)"0DI*2C8V-B8F)B8F)A(2$?'Q\A(2$BHJ*?7U]=75U:VMK9F9F:&AH4%!0
M.#@X0D)"1T='2TM+1T='3DY.4U-3965E=G9V?GY^AX>'D)"0AH:&?W]_=W=W
M;6UM86%A5E963$Q,/S\_/3T]/S\_/CX^.CHZ/#P\.SL[.#@X-S<W-S<W-S<W
M,C(R,3$Q,S,S+2TM-34U3T]/65E955557%Q<8F)B75U=6%A86UM;9F9F<W-S
MBHJ*J*BHT='1YN;F[>WMZ^OKZ^OKX>'AV-C8S\_/R<G)T-#0U]?7UM;6TM+2
MUM;6T='1R<G)Q\?'P\/#Q\?'TM+2T='1T-#0S,S,O[^_OKZ^OKZ^O;V]MK:V
MIJ:FI:6EK*RLIJ:FFYN;=G9V.3DYEY>7_____O[^____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________?W]_O[^____S,S,:&AH0D)"1D9&/S\_.SL[/#P\04%!145%34U-
M5U=76EI:86%A9V=G9V=G:VMK;FYN?'Q\?'Q\='1T>WM[=W=W?7U]@8&!AX>'
MDY.3DY.3DI*2FYN;DY.3DY.3CHZ.DY.3DI*2CX^/F)B8FIJ:F9F9F)B8E)24
MBXN+B(B(AH:&AH:&@H*"?7U]='1T<W-S9V=G7EY>2$A(.SL[1T='3$Q,1T='
M3$Q,4%!075U=;FYN>'AX>WM[AX>'BHJ*@X.#='1T:VMK965E7%Q<4U-324E)
M/S\_04%!0$!`/CX^.SL[.CHZ.CHZ.3DY.3DY-S<W-34U,#`P+2TM,#`P,3$Q
M-34U4E)24%!05%14965E:FIJ965E86%A9&1D<W-SBXN+IJ:FS,S,W]_?[^_O
MZ^OKY^?GW]_?U]?7S,S,Q,3$Q<7%SL[.T]/3T]/3Q<7%Q,3$QL;&P\/#P<'!
MPL+"P\/#O[^_O+R\N+BXL;&QJZNKJ*BHIJ:FJ*BHJ:FIG)R<CHZ.DY.3AH:&
M<W-S3DY.=G9VZ>GI_____?W]____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________O[^_/S\_O[^____
M____Q\?'75U=04%!0T-#0D)".CHZ/S\_1D9&2DI*3$Q,55558&!@8F)B8V-C
M9V=G;6UM<G)R<G)R<W-S>7EY?GY^?GY^@X.#B(B(DY.3DI*2B8F)CHZ.D)"0
ME965C8V-D)"0GIZ>EI:6E)24G9V=HZ.CFYN;CX^/CX^/A(2$@H*"AH:&C8V-
MA86%?W]_>GIZ:FIJ9F9F6EI:/#P\0$!`2TM+2TM+24E)2TM+4%!0965E<W-S
M?'Q\AH:&AX>'@H*"=G9V;6UM9V=G75U=55555E96145%0D)"/S\_/3T]/3T]
M.CHZ.3DY.SL[.CHZ.3DY-S<W-34U,#`P+BXN,3$Q+BXN/#P\2DI*4E)26EI:
M9&1D;V]O<G)R<7%Q=G9VB(B(IJ:FOKZ^S,S,VMK:[N[NZ.CHY>7EV=G9R\O+
MRLK*Q<7%PL+"QL;&R\O+O+R\MK:VL;&QM[>WN+BXM[>WMK:VLK*RK*RLIJ:F
MI:6EG)R<DI*2E)24B(B(?W]_<W-S9V=G:6EI<G)R<'!P7%Q<75U=R\O+____
M_?W]_?W]____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________V=G9<'!P145%
M1T='1D9&/S\_0D)"0T-#24E)4%!065E96UM;9&1D9F9F9&1D9V=G=G9V<G)R
M=G9V?7U]?'Q\A(2$@8&!@("`D9&1D9&1C8V-F9F9CHZ.C8V-CX^/EY>7D9&1
MD9&1F)B8H:&AGIZ>EI:6CHZ.C(R,C(R,@X.#A(2$@H*">GIZ>'AX<G)R:FIJ
M965E4U-30$!`1$1$2TM+2$A(24E)34U-6UM;:VMK<'!P?7U]@X.#A(2$?7U]
M=G9V;FYN9&1D7%Q<4E)21T='1$1$.SL[/#P\1D9&0D)".CHZ.3DY.CHZ.CHZ
M.3DY-34U-34U+R\O+BXN+R\O+R\O-34U145%55556%A88F)B;6UM>'AX='1T
M?7U]FIJ:N[N[S,S,R\O+Y^?GXN+BV=G9TM+2R<G)P<'!P,#`N;FYLK*RK:VM
MKZ^OK*RLJJJJIJ:FI*2DHJ*BFIJ:DY.3C8V-A(2$>WM[;&QL6UM;45%11D9&
M0$!`3$Q,6EI:8F)B>7EYDI*2BXN+:&AHIZ>G^?GY_____/S\____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________O[^_O[^____V-C8;V]O.3DY145%145%0D)"0D)"
M1T='2DI*3T]/5E9675U=8F)B965E:&AH;6UM=75U<W-S>'AX=W=W?W]_A86%
M@H*"@X.#AX>'B(B(BXN+BHJ*D)"0E965E965E)24DY.3DY.3DY.3E)24DI*2
MBHJ*B8F)C(R,BXN+A86%A(2$?7U]>WM[=G9V;V]O9F9F6UM;0T-#/CX^24E)
M3DY.3DY.34U-5%14965E;FYN='1T>WM[@("`>GIZ=75U;V]O:6EI8F)B5U=7
M3DY.24E)/CX^/CX^/CX^/3T]/#P\.SL[.SL[.SL[.#@X-34U-C8V,3$Q+R\O
M+R\O,#`P+R\O-S<W1D9&5E968&!@7U]?:6EI>'AX@H*"BXN+G9V=M[>WQ,3$
MX.#@VMK:S,S,Q<7%P,#`M;6UL;&QIZ>GJ*BHJ*BHH:&AH:&AFYN;D9&1CX^/
MB(B(?7U]<W-S:6EI9V=G8F)B45%11$1$1$1$5%14;&QL@("`CHZ.CX^/I:6E
MRLK*P,#`AX>'CX^/[.SL_____O[^________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_O[^_/S\_O[^____UM;6:VMK/S\_145%1$1$0D)"0T-#145%1T='34U-4U-3
M6EI:86%A:6EI:FIJ:6EI;6UM='1T=75U?W]_BXN+BXN+B(B(AX>'AH:&@X.#
M@H*"A86%BXN+C8V-C8V-CX^/AH:&A(2$AX>'BHJ*AH:&@H*"AX>'B(B(AH:&
M>WM[>WM[?'Q\>WM[=G9V;&QL7U]?3T]/.SL[/CX^3DY.3$Q,2TM+4U-36UM;
M:&AH='1T>WM[@8&!?'Q\=G9V<G)R:VMK9&1D7U]?55553DY.0T-#0$!`/3T]
M/3T]/3T]/3T]/#P\.CHZ.3DY.3DY-34U-34U,S,S+BXN+R\O+BXN,#`P-C8V
M0$!`3$Q,5E965E9686%A=W=WC(R,IJ:FMK:VM;6UR,C(RLK*O;V]N;FYM[>W
ML;&QJ*BHG9V=E965D9&1AX>'A86%?W]_>WM[>WM[<7%Q:VMK:FIJ965E9F9F
M9&1D6EI:45%14U-3@X.#L+"PN;FYM[>WJZNKM[>WX^/CSL[.DI*2?GY^V]O;
M_____O[^____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________O[^_O[^_O[^_?W]____
MZ>GI?GY^04%!04%!0T-#/S\_0D)"1D9&2DI*2TM+4%!075U=8V-C9V=G8F)B
M:6EI<7%Q<W-S=75U?7U]?GY^@("`@H*"B8F)D9&1E)24BXN+?7U]?'Q\@8&!
MA86%?7U]?W]_@H*"@H*"A86%@X.#A86%B(B(BHJ*@8&!?'Q\?GY^?GY^>'AX
M<G)R965E9&1D2TM+.#@X2TM+3$Q,2DI*3T]/4U-36UM;;FYN=75U?GY^@H*"
M?'Q\=75U;&QL965E86%A5E964%!01T='0T-#/CX^/#P\/CX^/3T]/#P\.SL[
M.CHZ.CHZ-S<W-C8V-34U,S,S,C(R+R\O+R\O,3$Q-#0T.#@X0T-#4%!04U-3
M4U-386%AFYN;O+R\NKJZLK*RL+"PH*"@F)B8E965DI*2BXN+?W]_=W=W=75U
M>7EY=75U>GIZ@("`?W]_=W=W<W-S<G)R:&AH:&AH:VMK<G)R<W-S>WM[I*2D
MK*RLH*"@CX^/C(R,G9V=O;V]J*BHAH:&='1TQL;&_____O[^____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________/S\_O[^____Y^?G@("`.#@X/S\_
M0$!`0$!`0D)"1D9&1T='34U-6EI:6%A87EY>8V-C:VMK<'!P;FYN<G)R=W=W
M?W]_GIZ>O+R\R\O+V-C8WM[>T]/3O+R\EY>7=W=W?W]_?GY^?GY^@H*"?7U]
M@("`A(2$A86%AH:&AH:&AH:&AH:&@H*"?GY^?W]_>7EY<'!P:VMK75U=04%!
M2$A(34U-3T]/3$Q,3T]/5555965E;6UM=G9V?7U]?'Q\=W=W;6UM9V=G965E
M6UM;5%143$Q,1T='0D)"/3T]/CX^/CX^/#P\/#P\.CHZ.3DY.3DY-S<W-#0T
M-34U-C8V-C8V,S,S+R\O,#`P-S<W.CHZ0$!`34U-55554U-3:6EIC(R,G)R<
ME)24E)24DI*2BHJ*@X.#A(2$BHJ*@X.#@X.#C8V-DI*2AX>'>GIZ=G9V<W-S
M?W]_B(B(<7%Q8V-C8F)B8V-C:FIJ;V]O<7%Q;6UM7U]?7%Q<:FIJ@H*"BXN+
MDI*2B(B(@H*"=W=WL;&Q^/CX_O[^________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________O[^_?W]________Z.CHDY.32DI*0D)"0$!`0$!`0D)"1$1$
M24E)4E)25%145E967EY>:&AH9&1D9V=G=G9V8F)B='1TV-C8____________
M____________WM[>;V]O:FIJ?'Q\@("`@X.#?W]_@("`AH:&B(B(C(R,CHZ.
MC(R,AX>'@("`A86%A86%?7U]=G9V;6UM:VMK6EI:0$!`2TM+3$Q,3$Q,3T]/
M4E)26UM;965E;FYN<W-S<W-S<G)R;FYN:VMK:FIJ86%A7EY>5%1424E)1D9&
M0D)"/S\_/CX^/CX^0$!`/3T].CHZ.CHZ.#@X-C8V-#0T-34U.#@X-C8V,3$Q
M,#`P,C(R-34U-34U.CHZ/S\_0D)"24E)6%A88V-C;FYN<'!PBXN+KZ^OJJJJ
MIZ>GIJ:FFIJ:D)"0@8&!@X.#?'Q\=W=W<7%Q<7%QA86%A(2$;V]O86%A6UM;
M965E9F9F7U]?6UM;5U=76UM;;&QL>7EY@H*"@H*"A(2$AH:&BXN+A(2$D)"0
MZNKJ________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________O[^
M____________\_/SH:&A/#P\0D)"0T-#0T-#2$A(24E)2TM+34U-4%!05555
M65E965E9:FIJ?GY^6EI:3DY.A(2$KZ^OR<G)U-34U=75R\O+LK*RDI*2:FIJ
M:6EI>GIZA86%A86%AH:&AX>'C8V-CHZ.EY>7FYN;EY>7C(R,BHJ*C8V-A86%
M@8&!>'AX<7%Q;&QL:&AH.#@X145%2TM+3DY.3DY.3DY.5E9675U=9V=G;V]O
M;&QL;&QL;V]O;6UM:FIJ:6EI8F)B555545%134U-1$1$0D)"0$!`04%!/S\_
M/S\_/3T]/#P\-S<W-C8V,S,S-#0T-34U-34U-34U-#0T-#0T-#0T,S,S-34U
M-34U-S<W/#P\04%!145%6%A87EY>='1TK*RLKZ^OE965DI*2CHZ.A86%<W-S
M=75U?'Q\AH:&?GY^AH:&B(B(>GIZ;V]O9&1D8V-C;&QL;&QL:6EI;6UM<G)R
M=75U?'Q\@8&!@X.#@X.#AX>'D)"0E965C8V-?7U]X>'A________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________?W]____\_/S
M0$!`.#@X1$1$1$1$1T='2$A(2DI*1D9&3T]/4U-345%165E9<'!PCHZ.@("`
M;V]O5U=73T]/6UM;9F9F9V=G8F)B8&!@:VMKC8V-<7%Q>'AXBXN+AH:&B(B(
MC8V-CX^/D9&1EI:6FYN;FYN;F)B8F)B8E)24C(R,B8F)?GY^<G)R:&AH9F9F
M.SL[/3T]2TM+4%!034U-3$Q,3T]/5U=78F)B;6UM;6UM;&QL;FYN;V]O;FYN
M:VMK8V-C6UM;7U]?5555145%145%0$!`0$!`/#P\/CX^/#P\.SL[.#@X-C8V
M-#0T-34U-#0T,S,S-C8V-S<W.#@X-C8V,C(R,S,S-#0T,3$Q-#0T.3DY0$!`
M55557%Q<>'AXP,#`S,S,B8F)>7EY=G9V>7EY@("`@8&!?GY^A86%@H*"@X.#
M=75U9F9F965E:&AH<'!P=75U>'AX>7EY?7U]@8&!@X.#?W]_?'Q\@H*"@X.#
MCHZ.F9F9G)R<D)"0=W=WT='1____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________O[^_O[^____P,#`6UM;/3T]1$1$145%
M04%!145%24E)3T]/45%145%15E96:VMKF)B8IZ>GK:VML+"PEI:6AX>'@("`
MAX>'GIZ>JJJJK*RLAH:&:VMK@8&!B8F)BXN+D)"0EI:6E)24EY>7D9&1D)"0
MG)R<FIJ:F9F9G9V=FYN;FYN;DI*2A86%=G9V9&1D34U--#0T/CX^4E)24E)2
M34U-2TM+55556UM;8V-C:FIJ;&QL;FYN;&QL;&QL;V]O:6EI8V-C75U=5555
M2DI*1$1$/S\_/3T]/CX^/CX^0$!`0$!`.CHZ.#@X-34U,S,S-C8V-34U-#0T
M-S<W.3DY.SL[-S<W,C(R+BXN,#`P-34U-C8V/#P\2DI*4U-3>WM[T-#0O[^_
M8F)B<7%Q>'AX>WM[A(2$;6UM:FIJ;V]O9V=G:VMK<'!P=W=W?7U]?7U]@("`
M?7U]?GY^?GY^>GIZ>WM[@H*"@X.#>'AXAX>'E)24G9V=I*2DJ:FIGIZ>>WM[
MM[>W^_O[____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________O[^_/S\_?W]____P<'!75U=/S\_1T='1$1$1$1$1D9&1D9&34U-
M5U=76UM;8F)B@8&!JZNKM[>WK*RLI:6EH:&AGIZ>JJJJK*RLFYN;A(2$=W=W
M@("`B(B(AX>'C8V-DY.3EY>7G)R<H*"@G)R<EY>7G)R<F9F9F9F9G9V=GY^?
MFIJ:DI*2B8F)@8&!<7%Q86%A/CX^-34U2TM+4%!03$Q,2$A(34U-55557EY>
M9V=G;&QL;V]O;FYN<W-S?'Q\:VMK=G9V9F9F6%A84%!01T='04%!/3T]04%!
M04%!1$1$0T-#/3T]-S<W-S<W-34U-#0T,S,S-34U-S<W.#@X.CHZ.CHZ-S<W
M,C(R,3$Q,C(R-C8V/S\_0D)"3T]/<G)RI:6EEI:6=G9VDY.3E965B(B(=W=W
M;6UM<'!P<G)R>7EY@8&!A86%@8&!@8&!@8&!@("`>GIZ?GY^?7U]?7U]@H*"
MB(B(A(2$?W]_C(R,FYN;HJ*BJJJJL[.SI:6E@H*"L+"P^/CX____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________?W]_?W]____
M________Q\?'65E9-C8V04%!0T-#1$1$0D)"34U-4U-375U=86%A9V=G=G9V
MC8V-M+2TO;V]HZ.CDY.3CHZ.AH:&A86%B8F)B8F)BXN+B(B(A86%CHZ.EY>7
MFIJ:GY^?H:&AI:6EH:&AG9V=IJ:FIJ:FI*2DHJ*BG9V=E)24CHZ.A(2$=W=W
M<'!P5%14-34U/CX^3T]/45%10T-#1$1$4%!06%A8965E='1T;V]O;6UM;V]O
M?7U]=G9V9V=G9&1D=G9V55551D9&1$1$0D)"/CX^0$!`04%!0$!`/3T].3DY
M-#0T-C8V-C8V-#0T-S<W.3DY.CHZ.#@X.CHZ.SL[.SL[-S<W,#`P-34U/#P\
M04%!24E)<7%QM;6UM[>WM;6UKZ^ODY.3@("`=W=W?GY^@8&!?7U]@8&!AH:&
MBHJ*@X.#@("`@H*"A86%@("`?GY^@X.#AX>'B8F)DY.3CX^/EI:6F)B8H:&A
MJZNKL+"PN[N[JZNKAH:&H:&A]?7U________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________/S\_O[^____[^_OA(2$
M04%!/#P\04%!0$!`1T='34U-4%!05U=79F9F:&AH965E7U]?:&AH>GIZ@8&!
M@8&!@8&!A(2$A86%B(B(CX^/D)"0DI*2G)R<HJ*BH*"@G9V=G9V=GIZ>J*BH
MI:6EH:&AJ*BHK:VMJ:FIJ*BHIJ:FI:6ECX^/@H*"<G)R<7%Q0T-#,C(R1D9&
M45%175U=7%Q<3T]/5E967EY>9F9F:FIJ;FYN=G9V<7%Q>WM[<'!P>7EY:&AH
M6EI:6%A8145%0$!`/3T]/3T]0$!`/CX^0D)"/3T],S,S-34U-C8V,C(R,S,S
M-34U-S<W.CHZ.3DY.3DY.SL[.3DY,S,S-#0T.#@X2DI*;6UML;&QM+2TG)R<
MC8V-@8&!@H*"A86%B8F)BXN+B(B(AX>'AH:&BHJ*B(B(E)24E965DI*2DI*2
MCX^/B8F)B(B(D9&1F9F9FIJ:F9F9E965FYN;IJ:FN;FYR,C(U]?7TM+2G)R<
ME965[N[N____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________/S\_/S\_?W]____[.SLBXN+3$Q,04%!145%2$A(
M2DI*34U-4E)275U=9&1D;6UM='1T>WM[?GY^?7U]?W]_A86%@X.#CX^/CX^/
ME965E)24EI:6G)R<H:&AH:&AHJ*BI:6EJ*BHKJZNL;&QL[.SL;&QK:VMIZ>G
MIJ:FGY^?FIJ:DI*2BHJ*<'!P<'!P2DI*.3DY.3DY2DI*4E)22DI*2DI*4E)2
M6EI:8F)B9F9F<G)R>GIZ?GY^='1TA86%EI:6:&AH?7U]6EI:3$Q,0D)"0$!`
M/3T]/3T]/#P\/S\_/3T].CHZ.3DY-S<W,S,S-C8V.#@X.#@X/#P\.CHZ/#P\
M.SL[-C8V,C(R,S,S-C8V965ED)"0H*"@EI:6D)"0D9&1DI*2D)"0BHJ*C(R,
MD)"0DI*2EI:6CX^/BXN+B8F)DI*2DY.3DY.3CHZ.D)"0DI*2CX^/FYN;HZ.C
MG9V=J*BHI*2DJ:FIM+2TN+BXQ,3$VMK:VMK:I*2DAH:&X^/C____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_O[^_?W]_?W]_?W]____ZNKJE)242$A(/3T]145%2$A(3$Q,3T]/5E9675U=
M965E<G)R>7EY@8&!A86%B8F)BXN+D9&1FIJ:D)"0FIJ:G)R<GIZ>H:&AJ:FI
MIJ:FJ:FIJZNKJZNKK:VML[.SL[.SKZ^OK:VMJ*BHHZ.CF9F9CX^/C8V-AX>'
M<G)R9V=G24E)-C8V,#`P04%!4E)22$A(2$A(3DY.4U-36EI:8V-C;FYN<G)R
MA86%BHJ*>7EY>7EYA(2$?7U]7U]?4%!01T='1$1$0D)"/S\_/CX^/3T]04%!
M/CX^.#@X-S<W-C8V-34U-34U.CHZ/CX^/CX^/CX^/3T]-C8V,#`P-S<W-#0T
M=75UAX>'D9&1DY.3C8V-D9&1EI:6DY.3D9&1DI*2E965F9F9G)R<E965G)R<
MG)R<E965EI:6FYN;EY>7FYN;GIZ>G9V=J:FIIZ>GHZ.CJ*BHIJ:FKZ^ONKJZ
MOKZ^Q\?'V=G9VMK:I*2D?W]_W-S<_____O[^_O[^____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________?W]_/S\
M________L[.S4U-3/S\_2$A(34U-34U-4E)265E97EY>9V=G;V]O<W-S?'Q\
MB8F)E)24EI:6GIZ>EI:6H:&AI*2DGIZ>G9V=J*BHJZNKJJJJJZNKJZNKJ*BH
ML+"PK:VMH:&AGY^?G9V=EI:6BHJ*AH:&A(2$@("`9V=G1D9&.SL[-#0T-#0T
M.3DY4%!04%!02$A(2$A(3DY.65E9965E;FYN;V]OF)B8E965>WM[B8F)?W]_
M?GY^@8&!6EI:2DI*24E)1$1$04%!04%!/CX^0D)"04%!/#P\.SL[-S<W.3DY
M-S<W.SL[/S\_04%!0$!`.3DY-#0T-34U.#@X0T-#<G)RCX^/F)B8EY>7G9V=
MGIZ>F9F9F9F9FYN;FYN;GIZ>FYN;H:&AGY^?F9F9F9F9H:&AF9F9DY.3F)B8
MI*2DKZ^OKJZNKJZNI*2DI*2DJJJJLK*RK:VMKZ^ONKJZOKZ^SL[.X^/CN[N[
M?W]_SL[.____^_O[_O[^________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________O[^_?W]_O[^_/S\_____?W]N;FY7%Q<
M/#P\2$A(3$Q,3T]/5U=77EY>9F9F:VMK=75U@8&!AX>'DY.3FIJ:F9F9GIZ>
MJ*BHI*2DG)R<GY^?J*BHIZ>GH*"@I*2DHZ.CHJ*BGIZ>GIZ>FIJ:E)24D9&1
MBHJ*@H*"?7U]?'Q\<W-S24E)/#P\.#@X-#0T-34U,C(R2TM+4%!02DI*1T='
M4%!06UM;8F)B:FIJ=G9V@8&!?W]_G)R<DI*2BXN+E)24BXN+965E5%143DY.
M145%1$1$04%!1$1$1$1$1$1$/S\_.SL[.#@X.#@X.#@X.SL[0$!`145%04%!
M-C8V-#0T/#P\0T-#5%14>WM[CHZ.D)"0G)R<J*BHJ:FIHZ.CFIJ:G)R<H:&A
MH:&AHJ*BHZ.CH*"@HJ*BI*2DI:6EJJJJI:6EFIJ:EI:6IZ>GKZ^OKJZNJ:FI
MI*2DKJZNLK*RJZNKIZ>GM+2TM[>WS,S,Z.CHP\/#?GY^P,#`_O[^_O[^____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________O[^_O[^_?W]_/S\_?W]________P<'!8V-C/CX^1T='3T]/4U-3
M65E99&1D9V=G=G9VA86%A86%C8V-G9V=GY^?G9V=H:&AH:&AG)R<G)R<H:&A
MH*"@G)R<F9F9E965EY>7DI*2DI*2CX^/B8F)A86%?GY^<W-S:FIJ7U]?3T]/
M.SL[.3DY.#@X-34U-#0T,3$Q1$1$45%13DY.2DI*3DY.5E9686%A;6UM?GY^
M@H*"BHJ*J:FIFIJ:GIZ>IJ:FC8V-:6EI6UM;45%124E)1$1$0$!`1$1$1T='
M1T='0D)"/S\_/#P\.SL[.CHZ/#P\0D)"1T='04%!-C8V/#P\145%3DY.6%A8
M@H*"DY.3EI:6H:&AK*RLJZNKJJJJK*RLIZ>GJJJJJ:FIJJJJJ:FIIZ>GJ:FI
MJ*BHIJ:FIZ>GK:VMJZNKF9F9F9F9IZ>GK*RLKJZNJZNKL+"PIJ:FJ:FIK:VM
MLK*RKZ^OP\/#Y.3DR\O+@H*"K:VM_/S\_____O[^____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________?W]_/S\
M_?W]_O[^^_O[________V=G9<G)R1D9&2TM+4%!04U-36UM;8V-C='1T@H*"
MA(2$AX>'DI*2F9F9D)"0D)"0DI*2D9&1C8V-BXN+CHZ.D)"0C(R,B8F)BHJ*
MC(R,@("`>WM[;V]O:FIJ7%Q<3T]/1T='0T-#0$!`.3DY.#@X.3DY-34U,S,S
M-#0T0$!`3T]/4U-334U-3DY.4U-36EI:8V-C?7U]A(2$<7%QI:6EKJZNM[>W
MJ*BHCHZ.<7%Q7U]?65E94%!01D9&145%0D)"1D9&24E)145%0D)"/CX^/CX^
M/#P\/CX^1$1$24E)0D)"/3T]2TM+3T]/5%148&!@B(B(EI:6GY^?JZNKL;&Q
ML;&QM+2TN[N[O+R\M;6UMK:VK:VMKJZNL;&QJZNKJ:FIJ*BHJZNKIZ>GK*RL
MK*RLIJ:FH:&AHZ.CJ*BHKJZNK*RLIZ>GI:6EJJJJJ:FII:6EL;&QV-C8U=75
MB(B(F)B8^OKZ_____/S\_O[^____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________O[^_O[^_________O[^_____O[^
M____VMK:?7U].#@X145%3T]/555575U=:6EI='1T>WM[@H*"A(2$AH:&@8&!
MA86%@X.#@8&!@8&!@X.#A86%AX>'AX>'@8&!>'AX;6UM7U]?6UM;4U-33DY.
M24E)24E)2DI*145%/#P\.SL[.3DY.#@X-34U-34U-C8V04%!34U-55553T]/
M34U-4%!065E98V-C>GIZ@X.#:&AHJ*BHOKZ^O+R\JZNKDY.3?W]_:VMK7EY>
M4E)224E)1$1$145%145%1$1$1$1$04%!/CX^/#P\/3T]/3T]1$1$24E)0T-#
M1D9&5%145%1455556EI:BHJ*E965HZ.CL[.SO+R\O;V]Q,3$P\/#P\/#O[^_
MOKZ^M[>WL+"PIZ>GIZ>GJJJJLK*RM[>WIZ>GH*"@J*BHK:VMI*2DH*"@IJ:F
MKZ^OJJJJJ*BHG)R<HZ.CJZNKK*RLKZ^OT='1U]?7CX^/CHZ.^?GY_____O[^
M_/S\________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________?W]________X^/CC(R,0T-#
M0$!`34U-4%!06UM;:&AH;&QL='1T<'!P<7%Q=G9V>'AX>7EY>'AX=G9V<G)R
M:VMK965E7U]?65E94E)22DI*2TM+3T]/3$Q,34U-3T]/4U-355554U-31D9&
M-S<W.#@X/CX^.3DY-S<W.CHZ04%!2$A(4U-34E)234U-3DY.5U=77U]?<G)R
MB8F)@8&!IZ>GP,#`OKZ^L;&QGY^?CX^/=75U8V-C5%142DI*1$1$1T='1T='
M1T='2DI*0D)"/S\_/S\_0D)"0$!`0D)"145%1$1$4%!05%143T]/4U-3:6EI
MBHJ*F9F9I*2DL;&QN[N[P<'!Q\?'R<G)QL;&P\/#O[^_O[^_M[>WK*RLL+"P
ML[.SKJZNJZNKI:6EH*"@HJ*BIJ:FI:6EI*2DGY^?IJ:FHJ*BIJ:FI*2DIZ>G
MJJJJJJJJK*RLR,C(V-C8F9F9@("`\?'Q_____?W]_O[^________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________?W]____[^_ODI*2145%0D)"1D9&3$Q,6%A8
M7EY>9V=G:6EI:&AH;6UM:6EI9&1D7U]?7%Q<5U=73T]/2DI*24E)2TM+3$Q,
M3T]/4%!05%145E967U]?9F9F;&QL:FIJ9V=G7EY>/S\_/3T]04%!.CHZ.CHZ
M0$!`04%!1$1$45%15E9645%14%!05E9665E9:VMK@X.#DI*2JZNKO;V]O+R\
MR,C(M+2TEY>7>GIZ9V=G5U=734U-24E)1D9&2DI*3DY.3DY.1T='0D)"0$!`
M0T-#1$1$145%0T-#2DI*55555%144%!05E96<G)RB8F)EI:6IZ>GL;&QO+R\
MQ,3$T-#0T-#0S,S,Q<7%P,#`O[^_L;&QJ:FIK:VMK*RLK:VMJ*BHIJ:FH:&A
MFYN;H:&AHZ.CI:6EHJ*BH:&AEI:6F)B8I*2DJZNKJ*BHI:6EHJ*BO[^_U]?7
MG9V==75UZ>GI_____/S\_O[^____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____O[^________[>WM>GIZ-#0T1D9&2DI*45%15U=77EY>86%A75U=5E96
M2TM+2$A(1D9&2$A(2$A(145%145%4%!05U=765E99&1D:VMK:6EI<'!P=G9V
M<7%Q<W-S<'!P:FIJ8V-C55552TM+1T='04%!04%!2DI*2TM+1$1$34U-6EI:
M5%144%!05E967%Q<;FYNA86%BXN+HZ.CO;V]O+R\T-#0P\/#FIJ:=75U:VMK
M7%Q<4U-334U-2$A(2TM+3T]/4U-32TM+1D9&04%!/S\_0D)"1D9&0D)"3$Q,
M5E965%144%!065E9<'!PC(R,DI*2IZ>GO+R\PL+"R<G)S\_/SL[.S<W-R<G)
MP\/#MK:VM;6UJJJJIZ>GIZ>GJJJJJJJJKJZNI*2DE965D9&1EY>7H:&AI:6E
MHZ.CGIZ>D)"0CX^/GIZ>I:6EJ*BHH*"@MK:VU-34JZNK;V]OW]_?_____?W]
M_?W]________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________O[^____
MU-348&!@0$!`34U-5E9675U=8V-C3$Q,1$1$2$A(/S\_/S\_2$A(2TM+3T]/
M6%A875U=7%Q<8V-C8V-C:6EI;FYN8V-C8V-C;6UM:&AH86%A7%Q<7%Q<5U=7
M4U-34%!045%13DY.3$Q,3DY.45%10T-#145%65E965E94U-3555575U=965E
M<W-SF9F9V]O;NKJZT='1Z^OKS\_/J*BHBHJ*=W=W6UM;45%12TM+3$Q,34U-
M4U-34E)224E)1$1$1D9&0T-#0D)"1T='145%34U-65E965E94U-386%A='1T
MD9&1DY.3GIZ>J*BHM[>WQ\?'R,C(R<G)Q,3$QL;&P\/#O+R\O;V]L+"PK:VM
MG9V=H:&AHJ*BI:6EIZ>GH*"@E965FIJ:HJ*BJ*BHH:&ADI*2C(R,AX>'BHJ*
MCX^/FYN;K:VMO;V]S<W-L;&Q:VMKPL+"_____?W]____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________HJ*B3$Q,45%17U]?
M:6EI:6EI2$A(7U]?=G9V8F)B55558F)B8V-C:VMK;6UM8V-C6EI:65E975U=
M7%Q<75U=8&!@8&!@7U]?75U=4U-334U-55556EI:8F)B75U=6EI:5U=74E)2
M3DY.34U-1$1$04%!4U-36%A855555%1455557U]?:FIJE)24^OKZO+R\PL+"
MY^?GW-S<L[.SBXN+;6UM6UM;4E)234U-34U-3DY.5%144%!03$Q,2$A(2TM+
M24E)0D)"0T-#145%3$Q,6%A85U=75%1465E9>'AXB8F)DI*2DI*2G)R<J:FI
MQ<7%Q<7%P\/#O[^_O[^_O;V]KZ^OMK:VM;6UL+"PHZ.CH:&AI:6EH*"@F)B8
MBHJ*@H*"@X.#E)24I:6EHJ*BDI*2CHZ.F9F9D9&1?GY^C(R,H*"@N+BXR\O+
MNKJZ<W-SM[>W_____/S\________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________?W]____T-#09&1D5%148F)B<W-SDI*2:6EIB(B(JZNK
MBHJ*;&QL;FYN;&QL8&!@55555U=775U=7U]?7U]?5E965%145U=74U-35555
M75U=8F)B:6EI;FYN<7%Q<7%Q<G)R<'!P<W-S:&AH5E963T]/2TM+0T-#4%!0
M65E965E955555%147EY>:VMK@8&!GIZ>KJZNR<G)Z.CHU-34M;6UEI:6=W=W
M8&!@55554E)22TM+3$Q,3DY.3$Q,2$A(1T='2DI*24E)1T='1T='1$1$24E)
M5U=765E95%1475U=>GIZ?GY^B(B(CX^/FYN;H*"@K*RLN;FYQ\?'Q\?'M+2T
MM[>WN+BXK*RLMK:VKJZNJZNKHJ*BCHZ.=W=W@8&!J*BHN;FYDI*2<'!PC8V-
MEY>7GIZ>FIJ:G9V=H*"@FIJ:AX>'A86%KJZNU=75S<W-?'Q\J*BH________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________?W]
M____^?GYDY.375U=>WM[EY>7S\_/>GIZ;&QLAH:&8&!@2TM+3$Q,3$Q,3T]/
M5%145%1465E965E97U]?965E:VMK<W-S=W=W>WM[>GIZ=W=W='1T<7%Q<G)R
M<W-S<7%Q;6UM:FIJ;V]O;&QL555545%11T='2TM+7%Q<86%A8F)B8&!@9F9F
M;&QL;6UMGY^?R<G)UM;6W=W=Y>7ERLK*EI:6@H*"8V-C65E95U=74U-34%!0
M4E)24U-32TM+2$A(2$A(1T='24E)3T]/3$Q,3T]/45%16%A86UM;='1TA(2$
M@8&!@H*"?'Q\CX^/J*BHM[>WN;FYO+R\O+R\N;FYK:VMKZ^OIZ>GMK:VN+BX
ML[.SFYN;I:6E\/#P________________R\O+A(2$@H*"D)"0F)B8FYN;FYN;
MI*2DI:6EEI:6G9V=M+2TOKZ^@8&!AH:&_____?W]____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________?W]_O[^____J:FI7EY><'!P
M?W]_<G)R='1T9F9F5E964U-334U-1T='24E)4%!065E98F)B;6UM=75U>'AX
M>WM[>7EY=W=W=W=W='1T<W-S=75U<G)R<7%Q=75U=75U<W-S<'!P;FYN:VMK
M;V]O75U=4%!024E)1T='65E97EY>6EI:75U=9&1D<'!P>'AXG)R<O+R\PL+"
MTM+2TM+2OKZ^G9V=='1T6UM;6UM;6%A84U-355554U-35%143DY.34U-4%!0
M34U-2DI*34U-2TM+3T]/3T]/555575U==W=WA(2$>WM[A86%C(R,D9&1G)R<
MJ:FIM;6UM+2TN;FYP,#`M+2TJZNKH:&AJZNKJZNKI:6EMK:V\O+R________
M_?W]_/S\_?W]____Z^OKD9&1A(2$EI:6G)R<FIJ:FIJ:HJ*BGY^?GIZ>KZ^O
MM[>WB(B(?GY^________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________?W]_/S\____P\/#:FIJ:FIJ?W]_9F9F>GIZ;FYN6EI:
M7%Q<7%Q<86%A:6EI<G)R=75U=W=W>GIZ=W=W>WM[=W=W>'AX>7EY>WM[=75U
M=G9V=G9V=75U=G9V>'AX=W=W=W=W=75U<W-S;6UM:&AH:6EI4%!01$1$0T-#
M5E9675U=6UM;7U]?8F)B;V]O@("`BHJ*IJ:FK*RLPL+"M[>WJ:FID9&1<G)R
M86%A86%A6UM;4U-35%1445%14U-33DY.3DY.34U-4%!03DY.3$Q,2TM+3T]/
M4E)26%A875U=<W-S@X.#=G9V?7U]CX^/E965G)R<IZ>GM;6UMK:VNKJZQ,3$
MO+R\KZ^OK:VML;&QJ*BHHJ*BZ>GI_____O[^_?W]_O[^_____/S\_?W]____
MOKZ^@X.#FYN;FYN;G)R<FIJ:H:&AI:6EHJ*BJJJJN+BXCX^/<G)R_O[^____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________O[^
M_O[^____W-S<@X.#<W-S@8&!CX^/BXN+CX^/DY.3C(R,A86%?W]_>GIZ>7EY
M>7EY>7EY?'Q\>GIZ?GY^?W]_?7U]?7U]?7U]?'Q\?7U]?GY^?7U]>GIZ>7EY
M?7U]>WM[>7EY=G9V;V]O:FIJ<'!P5555/#P\/#P\4U-39&1D9V=G8V-C9&1D
M:FIJ;FYN@8&!D)"0G)R<L+"PL[.SL;&QG9V=@("`:VMK7EY>6UM;5U=75E96
M55555E963T]/3$Q,3DY.34U-4%!03T]/3$Q,45%15E966%A87U]?<W-S@X.#
M>GIZ@H*"AX>'DY.3GY^?KZ^ON[N[R,C(O;V]P\/#PL+"NKJZJ:FIL[.SL+"P
ML[.S_____O[^_/S\_?W]_________O[^_/S\____YN;FA86%H*"@H:&AGY^?
MH:&AHJ*BH*"@GIZ>M+2TP,#`G)R<9V=G\?'Q________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________YN;FBHJ*>'AX
MA86%CX^/F)B8F9F9EI:6C8V-A86%?'Q\>7EY>'AX>GIZ>WM[?7U]>WM[@8&!
M@X.#A86%@X.#?GY^?GY^?W]_@8&!@8&!@X.#?W]_@("`@8&!?GY^=W=W='1T
M:VMK;6UM75U=0$!`/#P\45%1965E:6EI:&AH:6EI<7%Q<7%QCHZ.FYN;G9V=
MIJ:FM+2TMK:VGIZ>@X.#='1T965E6UM;6EI:6EI:6%A87EY>4U-345%15%14
M5%1445%13DY.3DY.5%1455555U=786%A<'!P>WM[>WM[C8V-BXN+D)"0EY>7
MKZ^OP,#`S,S,QL;&P\/#P<'!N;FYH*"@KJZNJ:FIDY.3^OKZ_____O[^_?W]
M_________O[^_/S\____Y^?GA86%H*"@H*"@GIZ>HJ*BH:&AHJ*BHJ*BL;&Q
MQ\?'JZNK:&AHZ^OK____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________\/#PDI*2>GIZC8V-D)"0E965E965E965
MCX^/B(B(@("`?'Q\>WM[?7U]?'Q\@("`@H*"A86%AX>'BHJ*AH:&A86%AX>'
MA(2$@8&!@H*"AH:&B8F)A(2$AH:&@X.#?'Q\=W=W:VMK:FIJ8F)B145%/CX^
M34U-965E;6UM:VMK:VMK<7%Q<W-SA86%EI:6GIZ>JZNKM;6UL[.SJ:FID)"0
M=75U965E75U=75U=65E955556UM;6%A85%145U=765E95E964%!03DY.5%14
M5%146%A8965E?'Q\>'AX>WM[B(B(DI*2FIJ:GIZ>KZ^OO;V]R\O+R,C(P,#`
MP\/#N[N[H*"@JJJJHJ*BDY.3_O[^_____/S\_?W]_________O[^_/S\____
MUM;6A86%G)R<GY^?H:&AG)R<GY^?I*2DI:6EK*RLR<G)M;6U:6EIW-S<____
M_O[^________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________]/3TEY>7>7EYCHZ.EY>7EY>7EI:6E965D9&1BHJ*?W]_?7U]?W]_
M@H*"?W]_AH:&C8V-B8F)BHJ*C(R,C8V-C8V-C8V-BHJ*AH:&B8F)BXN+D9&1
MAX>'C(R,AH:&?'Q\>'AX;&QL:&AH9F9F2TM+0$!`2DI*8F)B:VMK:FIJ;V]O
M;FYN='1T>7EYC8V-G)R<JJJJL+"PJZNKHZ.CB(B(<7%Q9V=G86%A7EY>6EI:
M65E97%Q<6EI:5U=76UM;7%Q<6UM;5%144%!04E)25U=76UM;:6EIA86%AX>'
M=W=W@8&!CX^/F9F9GY^?L;&QMK:VQ<7%S<W-Q<7%OKZ^S<W-OKZ^M+2TJJJJ
MO+R\_____/S\_/S\_O[^_O[^_O[^_?W]_O[^____JJJJBHJ*G)R<GIZ>HJ*B
MG9V=H:&AI*2DI*2DJZNKQ<7%N[N[<W-SP\/#_____/S\________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________]O;VEY>7>GIZ
MC(R,F)B8G)R<FIJ:EI:6D)"0BXN+A(2$?W]_@H*"AH:&B(B(C(R,D9&1D9&1
MDY.3D9&1E965D9&1CX^/D9&1D)"0D9&1DI*2E965CHZ.DI*2C(R,@("`>7EY
M='1T:&AH965E45%11$1$2TM+7U]?;&QL;FYN;6UM;FYN=75U?'Q\AH:&EI:6
MJZNKK:VMG)R<BXN+AH:&<G)R9V=G86%A86%A7%Q<6%A88&!@7U]?7%Q<7EY>
M6EI:6UM;55554E)25E965U=786%A;6UM@H*"AX>'>7EY@8&!C8V-FIJ:GIZ>
MK*RLNKJZP<'!R,C(Q,3$LK*RQ,3$S,S,R\O+U-34T-#0_____/S\^_O[_O[^
M_?W]_O[^_O[^____U]?7EY>7EY>7EY>7E)24H:&AHJ*BI:6EHJ*BEI:6HJ*B
MO[^_O[^_?7U]M[>W_____O[^____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________]O;VF)B8>7EYD9&1FYN;G)R<G)R<FIJ:
MEI:6DY.3BHJ*B(B(B8F)C(R,CX^/D)"0E965F9F9F9F9FIJ:FYN;F)B8EY>7
MEY>7EY>7F9F9F)B8EY>7C(R,DI*2BHJ*A(2$?7U]>GIZ;FYN:&AH6%A82TM+
M3$Q,7%Q<;&QL<7%Q<'!P<G)R>'AX?'Q\@("`D)"0FIJ:HJ*BGIZ>D9&1CX^/
M?'Q\;&QL965E:&AH8V-C8F)B75U=7U]?8&!@8V-C8&!@6EI:4U-345%165E9
M5U=786%A<W-S@("`@X.#>GIZ=G9V@H*"CHZ.GIZ>LK*RP,#`PL+"Q,3$Q,3$
MMK:VM[>WQ<7%S<W-W]_?V=G9Y.3D________________________X.#@HJ*B
MH*"@GIZ>F9F9G)R<H:&AHJ*BHJ*BI:6EH*"@H*"@L[.SNKJZ@("`HJ*B____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________]?7UF)B8>WM[D9&1FYN;G)R<FIJ:G9V=FYN;F9F9D9&1D)"0D9&1
MCX^/D9&1D9&1E)24F)B8G)R<G9V=G)R<GIZ>GY^?FYN;FIJ:F9F9FIJ:F)B8
MC8V-E)24CHZ.A86%?GY^=W=W<G)R;&QL75U=3T]/2TM+6UM;:FIJ;FYN<W-S
M=G9V>'AX>WM[@X.#BHJ*D9&1E965FYN;E)24B(B(?7U]<7%Q9&1D:FIJ:VMK
M:6EI8&!@75U=86%A8F)B8F)B7%Q<5%144E)26EI:6%A86UM;=G9V@H*"A(2$
M=W=W=75U>WM[@8&!F9F9JZNKN+BXQ\?'P<'!NKJZPL+"O[^_O;V]R,C(T]/3
MW]_?U]?7W]_?[^_O^_O[^OKZZNKJS\_/J*BHGIZ>HJ*BH:&AGY^?HJ*BG9V=
MHJ*BHZ.CJ:FIJ:FII:6EM;6UM;6U@X.#D9&1_________O[^____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________\?'QEI:6@8&!
ME)24G9V=G)R<GIZ>H:&AGY^?FIJ:E965E)24DI*2CX^/CX^/E)24EY>7EI:6
MGY^?GIZ>H:&AG9V=H*"@GY^?GIZ>F)B8G)R<FYN;D)"0DI*2CX^/A86%@8&!
M=W=W=75U<7%Q8V-C4E)23$Q,6UM;:&AH:VMK<W-S=75U>'AX>WM[?W]_AX>'
MC(R,E)24DI*2A86%@H*"?GY^='1T:&AH965E:FIJ:&AH965E8F)B8&!@86%A
M86%A6EI:4U-34%!05U=77%Q<7%Q<<G)RA86%B(B(=G9V>'AX?'Q\BHJ*HZ.C
MIJ:FKZ^OI*2DD9&1I*2DM[>WN;FYO[^_O;V]PL+"R<G)W]_?VMK:Q,3$N+BX
MN;FYL[.SK:VMHZ.CJ:FIK:VMIJ:FG)R<GIZ>G)R<IJ:FJ*BHIZ>GI*2DHJ*B
MM[>WN+BXBXN+C(R,_________/S\________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________Z^OKDY.3B(B(FYN;GY^?G)R<GIZ>I:6E
MI*2DH*"@G)R<FYN;E965E965DI*2EI:6E)24F9F9H*"@F)B8I*2DJ*BHHZ.C
MG9V=GY^?F9F9EY>7E965D9&1CX^/B8F)B(B(AH:&>WM[=G9V=75U:FIJ5E96
M34U-65E99F9F:FIJ=75U>GIZ>7EY@H*"AH:&@("`DY.3K*RLIZ>GE965BXN+
M>GIZ='1T;FYN965E86%A9&1D;FYN8V-C86%A6UM;65E96UM;55554E)26EI:
M8V-C6UM;:6EI@X.#C8V->7EYBXN+H:&AH:&AHJ*BE)24EI:6HZ.CO+R\Q<7%
MN;FYL;&QM;6UNKJZN+BXLK*RNKJZO[^_N[N[N+BXMK:VKZ^OKJZNK*RLJ:FI
MJ*BHH*"@I*2DHJ*BEY>7GY^?K*RLL;&QK*RLHZ.CM+2TR,C(FIJ:>WM[^OKZ
M_____/S\____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________X.#@C(R,AH:&FYN;FYN;GY^?HZ.CHZ.CHJ*BH:&AH:&AG9V=FYN;
MG)R<EY>7EY>7EY>7G)R<F9F9GIZ>I*2DHJ*BI:6EH:&AF9F9FYN;F)B8DI*2
MD9&1D)"0DY.3AX>'@H*">WM[>'AX=G9V;&QL65E93$Q,5E969&1D:6EI<W-S
M=W=W<7%Q?7U]CX^/A(2$B8F)C8V-E965H:&AEI:6>'AX<G)R<7%Q:FIJ965E
M:6EI:6EI965E9V=G86%A6EI:6UM;6EI:6UM;7EY>9F9F7EY>;6UM@H*"@("`
M?GY^@H*"CHZ.C(R,C(R,DI*2HJ*BO;V]U=75U]?7L;&QLK*RKZ^ON;FYN+BX
ML[.SM[>WN[N[N;FYL[.SM+2TLK*RK:VMK*RLJ:FIH*"@GIZ>I:6EIZ>GHJ*B
MGIZ>HZ.CK:VMJJJJG9V=L+"PRLK*J*BH>'AX\_/S_____/S\____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________W-S<D)"0BHJ*
MGY^?H*"@H*"@H*"@H*"@H*"@G)R<GY^?H*"@GY^?G)R<EI:6F9F9G9V=G9V=
MEY>7GY^?IJ:FH:&AIJ:FJ:FIH*"@FYN;EY>7E965EY>7E965DI*2BXN+A86%
M?7U]>7EY=W=W;V]O7%Q<34U-5%149V=G;FYN='1T;V]O:&AH;V]O?'Q\>'AX
MBHJ*D)"0D)"0BHJ*C8V-BHJ*?'Q\;6UM:6EI9V=G9&1D7U]?86%A9&1D9F9F
M7U]?75U=7%Q<65E97EY>9V=G7EY>=G9VBHJ*?W]_?W]_?W]_>7EY@H*"BHJ*
ME965G9V=O+R\N[N[O;V]M;6UIJ:FHJ*BP,#`M+2TM;6UO[^_N;FYMK:VN;FY
MMK:VKJZNLK*RK*RLIZ>GF9F9E965FIJ:HZ.CIJ:FHZ.CH:&AI*2DJ*BHGIZ>
MJ*BHR\O+L;&Q=W=W[.SL_____/S\________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________VMK:C(R,A86%EY>7GIZ>G)R<G9V=HZ.C
MI*2DIJ:FHZ.CG)R<GY^?G)R<G)R<G9V=GIZ>G9V=G)R<G)R<HJ*BH*"@HJ*B
MI*2DIZ>GI*2DG9V=F)B8E965EY>7E965A86%A(2$?GY^>WM[>WM[=W=W:6EI
M5E9655558V-C<G)R=75U>WM[?GY^?'Q\?GY^AH:&BHJ*CHZ.C(R,CX^/D)"0
M?7U]<'!P='1T='1T;V]O<7%Q;FYN:FIJ;&QL:6EI9&1D86%A6UM;5U=786%A
M:&AH9&1D@H*"AX>'?'Q\>GIZ=G9V>WM[@H*"B8F)C(R,FYN;N;FYP<'!M[>W
MJJJJJJJJHZ.CJZNKMK:VM+2TN;FYMK:VM+2TLK*RKJZNJZNKIZ>GJZNKJZNK
MI*2DGY^?I*2DJ*BHGIZ>H*"@I*2DIJ:FI*2DH*"@JJJJRLK*L[.S=W=WW-S<
M_____/S\____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________UM;6C8V-@X.#EI:6HJ*BHZ.CG9V=HJ*BHZ.CI:6EHZ.CH:&AGIZ>
MGIZ>I:6EH:&AFYN;H:&AF9F9F9F9GY^?HJ*BH*"@H:&AIJ:FH:&AH*"@G9V=
MEI:6EY>7D9&1A86%@8&!?GY^>WM[?'Q\>WM[;FYN75U=5E9686%A;&QL=75U
M>'AX?W]_@X.#?W]_A86%B(B(B8F)C(R,C(R,AX>'?7U]=75U=G9V<G)R;V]O
M=G9V<'!P9&1D:6EI:6EI8V-C86%A6UM;65E986%A86%A6UM;@("`B(B(A86%
M>'AX>7EY?W]_AX>'CHZ.DI*2H*"@K:VMKZ^OKZ^OHZ.CI*2DL[.SJ:FIJ:FI
MN+BXN+BXLK*RL+"PLK*RKZ^OLK*RL[.SKZ^OI*2DGY^?I*2DJZNKJ*BHI*2D
MG9V=G)R<HZ.CIJ:FI*2DJJJJPL+"N;FY=W=WS\_/_____?W]____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________O[^____TM+2B8F)AH:&
MG9V=H*"@H*"@GIZ>I*2DIZ>GJ*BHJJJJIZ>GI*2DHJ*BH:&ABXN+>7EY>GIZ
MBXN+E)24GIZ>I*2DGY^?GY^?H*"@G9V=FIJ:FIJ:G9V=EY>7DI*2CX^/@X.#
M@("`?7U]?7U]?7U]<7%Q8F)B6%A886%A;&QL=G9V>7EY?'Q\@8&!@H*"A(2$
MBXN+C8V-CHZ.C(R,A86%?W]_>GIZ<W-S<'!P;V]O<W-S9V=G86%A:6EI:FIJ
M8F)B86%A7U]?6UM;86%A8F)B75U=?GY^B(B(@8&!=G9V=W=W?GY^@("`CHZ.
MG9V=GIZ>G)R<HJ*BIZ>GIZ>GIZ>GIJ:FK:VMJJJJL;&QL;&QL;&QKZ^OL[.S
MLK*RM+2TM[>WKZ^OJJJJJ:FIH:&AJZNKJ:FIIJ:FFYN;FIJ:HJ*BHZ.CI*2D
MIZ>GP,#`O+R\?GY^QL;&_____?W]________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________O[^_?W]____SL[.BHJ*BHJ*F)B8G9V=H*"@H*"@HJ*B
MI*2DIZ>GJJJJJZNKIJ:FA(2$4%!0+R\O*2DI+"PL5%14AH:&E)24GIZ>G)R<
MH*"@GIZ>GY^?F9F9EI:6F9F9F9F9EY>7E)24E)24AX>'@8&!@8&!?7U];V]O
M75U=5%147EY>:6EI=W=WA(2$E)24@("`AH:&AH:&BHJ*BXN+C8V-C(R,AX>'
M@X.#>WM[>'AX='1T<G)R<W-S:FIJ:&AH:FIJ:FIJ:&AH8V-C7U]?5U=775U=
M9V=G8&!@A86%C(R,>WM[>GIZ>WM[?7U]@H*"B8F)CX^/B(B(FIJ:I*2DG9V=
MIZ>GIZ>GI:6EIZ>GJZNKKJZNJ*BHJ:FIL+"PLK*RM+2TM;6UM;6UM;6UM;6U
MM+2TKJZNJ:FII:6EIZ>GI*2DI:6EJ:FIH:&AHJ*BK*RLQ<7%Q,3$@X.#N;FY
M_____?W]____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________O[^
M_?W]____S,S,A86%C(R,FIJ:H*"@H*"@HJ*BHZ.CJ*BHIZ>GJJJJK*RL?'Q\
M.3DY(R,C4E)2C(R,L;&QQL;&R,C(E965DY.3FIJ:GY^?H:&AGY^?G9V=FYN;
MF9F9F)B8FYN;C(R,BXN+B8F)@8&!@H*"@8&!=75U86%A4E)275U=:VMK=75U
M?7U]CX^/?7U]AH:&A(2$BHJ*BXN+C8V-D)"0D)"0A86%?GY^?'Q\=75U<W-S
M<7%Q;V]O;&QL;V]O;V]O;&QL9V=G86%A5U=78&!@9V=G7%Q<BHJ*BXN+@H*"
M?W]_?GY^@("`AH:&AX>'C(R,CX^/E)24FIJ:G9V=H:&AHZ.CHJ*BJZNKIZ>G
MKJZNK:VMJ:FIJ:FIKJZNLK*RM+2TLK*RM;6ULK*RM+2TMK:VKZ^OJJJJJ:FI
MK*RLJJJJIZ>GHJ*BHZ.CI:6EO+R\R,C(@X.#IZ>G_____?W]____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________O[^_?W]____Q<7%?W]_B8F)
MFYN;H*"@GIZ>H:&AJ*BHJZNKJ*BHJZNKC(R,/S\_+BXN=75US\_/_?W]____
M________O;V]A(2$F9F9F)B8FIJ:EY>7G)R<GIZ>F9F9EI:6EI:6BHJ*B8F)
MBHJ*@("`@("`A(2$>7EY9&1D4U-37%Q<:6EI<W-S=75U>'AX?7U]?7U]@H*"
MB8F)B(B(BHJ*C(R,CHZ.A86%?GY^>GIZ<W-S<'!P<W-S<W-S;V]O='1T<G)R
M;V]O;&QL9&1D5E968F)B;&QL7EY>B(B(BXN+@8&!?'Q\?'Q\?7U]?GY^@8&!
MBXN+EI:6E)24F9F9EI:6G)R<F9F9FIJ:JJJJJZNKJZNKK:VMJ*BHJ*BHK*RL
ML;&QM;6UM+2TMK:VN[N[N;FYM;6UL+"PJZNKJ*BHJZNKKZ^OJZNKJZNKIZ>G
MIZ>GMK:VP\/#BXN+FYN;_____O[^________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________?W]_/S\____P,#`@H*"CHZ.GIZ>H:&AGY^?I*2DJ*BH
MJJJJKJZNJJJJ7%Q<+2TMBXN+^_O[_________O[^_O[^____XN+B?7U]G9V=
MF9F9F)B8FIJ:GIZ>GIZ>EY>7EI:6E965CHZ.BHJ*AH:&AH:&@H*"A86%?7U]
M:&AH5E966UM;:&AH<G)R=W=W?'Q\@8&!>GIZ@H*"B(B(BXN+BHJ*C(R,C(R,
MA(2$?GY^>WM[=W=W=G9V=75U<7%Q;&QL='1T=75U;V]O;&QL9&1D555586%A
M;6UM75U=AH:&B(B(?GY^@("`?'Q\?7U]@8&!AH:&C8V-CX^/CX^/EY>7DY.3
MEI:6FYN;G)R<HZ.CH*"@K*RLK*RLJ:FIKJZNLK*RL;&QL[.SM+2TM+2TO+R\
MM[>WK:VMK:VMK:VMJ:FIJ*BHJZNKJ:FIJZNKK:VMJZNKL[.SQL;&F9F9DI*2
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________O[^
M_O[^____O[^_@("`C(R,G9V=G9V=FYN;HZ.CIZ>GKZ^OO;V]BHJ*0T-#L;&Q
M_____O[^_?W]_O[^_____?W]____S\_/@H*"G)R<HJ*BI*2DI:6EH:&AGIZ>
MEY>7EI:6DY.3DI*2C8V-D)"0AX>'AX>'A(2$?'Q\;FYN5E965%14965E<W-S
M?'Q\@8&!?GY^@8&!A86%AX>'AX>'C8V-D9&1D9&1AX>'@8&!?GY^>WM[<W-S
M=75U=W=W;V]O<'!P;V]O;V]O9F9F4U-34%!08V-C:VMK:&AHB(B(?GY^>GIZ
M>GIZ?7U]@8&!@8&!@X.#B(B(B(B(C8V-DY.3E)24G)R<H*"@HZ.CI:6EI*2D
MIJ:FJ:FIJ:FIJ*BHKJZNL[.SMK:VMK:VM[>WM;6UKZ^OKZ^OL+"PK*RLJZNK
MK:VMIZ>GHJ*BHZ.CHZ.CI:6EKZ^OQL;&KJZN@("`^/CX________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________O[^_O[^____N;FY@8&!CX^/
MGIZ>FYN;G9V=I:6EI:6EJZNKP<'!CHZ.;&QLXN+B____^_O[_O[^________
M________KZ^OBXN+EY>7G)R<I*2DJ:FIJ:FIGY^?EY>7G)R<EY>7EI:6DY.3
MCX^/BXN+BHJ*AX>'@8&!<W-S5U=745%19V=G;FYN>7EY?7U]=G9V@8&!BXN+
MBHJ*B8F)BXN+D)"0CHZ.A86%@("`>WM[>GIZ=75U=W=W='1T;6UM<W-S<7%Q
M;6UM8F)B4E)24U-37EY>8F)B;FYNCX^/AH:&>7EY?'Q\?GY^?W]_?7U]@X.#
MB8F)B8F)C8V-E965FIJ:IJ:FH*"@G9V=HJ*BI*2DIZ>GJJJJJ*BHJ:FIK:VM
ML;&QM+2TKJZNM+2TM+2TLK*RJJJJK:VMJZNKI:6EJ:FIK*RLJ*BHJ:FIJ:FI
MIZ>GKZ^ORLK*LK*R?GY^]?7U____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________?W]_O[^____N+BX@X.#CHZ.FIJ:GY^?G9V=G9V=I*2D
MIZ>GMK:VF)B8D)"0]?7U____^_O[_O[^____________\?'QE)24G9V=F)B8
MF)B8H:&AHZ.CIZ>GHJ*BG)R<GIZ>FYN;GIZ>EI:6D)"0BHJ*A(2$@X.#@H*"
M=75U6%A83DY.8F)B;FYN=G9V?7U]>GIZ?W]_B(B(B8F)B(B(BHJ*BXN+E)24
MC(R,AH:&?GY^>7EY?W]_?'Q\='1T;V]O=75U=75U;V]O75U=4%!055557%Q<
M8V-C<7%QBHJ*AH:&@X.#>WM[@X.#@8&!?GY^@8&!AX>'C(R,CHZ.CX^/E)24
MI*2DI:6EHJ*BI:6EHZ.CJ*BHHZ.CH:&AIZ>GKZ^OL+"PL+"PLK*RLK*RJZNK
MJ:FIJZNKK*RLJ:FIKZ^OK:VML+"PJZNKK:VMK*RLJ*BHL;&QQL;&LK*R=75U
MZ^OK_________O[^_O[^________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________?W]
M_O[^_?W]M+2T@H*"B8F)E965F9F9GIZ>H:&AG)R<DY.3HZ.CO[^_OKZ^\?'Q
M_____/S\_/S\_O[^____]_?WFYN;D)"0IJ:FI:6EG)R<G9V=HZ.CGY^?H*"@
MHZ.CEY>7FYN;H*"@EI:6B8F)B(B(A86%A86%@("`='1T7%Q<3DY.8&!@;V]O
M>7EY@("`AH:&A86%AH:&C(R,BHJ*BXN+C8V-C(R,B(B(A86%@H*"?GY^=W=W
M=G9V>WM[=G9V>WM[>'AX=W=W:&AH6%A88F)B965E9&1D<7%QC(R,B8F)A(2$
M>GIZ>WM[@8&!A(2$A86%B(B(C(R,C8V-B8F)CX^/E)24D)"0E965G)R<G9V=
MGIZ>FYN;H:&AJZNKK*RLL;&QJJJJJ*BHLK*RKJZNIZ>GK:VMKZ^OM[>WN[N[
MIZ>GHJ*BJ*BHKZ^OLK*RKJZNJZNKPL+"Q\?'?GY^V=G9_____O[^_?W]_O[^
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________/S\L[.S@H*"AX>'
MDY.3EI:6GIZ>HZ.CGY^?E965EI:6M[>WRLK*Y.3D________________]/3T
MK*RLEY>7GY^?HZ.CHZ.CF9F9EI:6H:&AH*"@GIZ>H:&AGIZ>D9&1EI:6F9F9
MD9&1C(R,CHZ.CHZ.AX>'?7U]75U=34U-7%Q<;6UM?7U]A(2$B(B(BHJ*AX>'
MAX>'B8F)C(R,CHZ.BXN+AX>'AH:&?7U]>WM[='1T<W-S=75U<W-S=W=W=W=W
M>'AX<7%Q8F)B:&AH9&1D8F)B;6UMCHZ.D9&1A86%@("`?W]_?W]_@X.#B8F)
MD)"0DI*2CHZ.C(R,CX^/CX^/E)24DI*2G9V=GIZ>G)R<G9V=J*BHJZNKI:6E
MJJJJK:VMKZ^OL;&QKZ^OKZ^OKZ^OK:VMP<'!R<G)NKJZKJZNK:VMK:VMJJJJ
MI*2DJJJJP\/#Q\?'@("`T-#0_____?W]_?W]________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________?W]_/S\____^OKZK:VM>GIZC(R,E)24FIJ:HZ.CHZ.CH*"@
MH:&AD)"0C8V-N+BXW-S<Y>7E\O+R\/#PU=75H:&AF9F9L+"PK*RLI:6EH*"@
MHJ*BFYN;FYN;I*2DGY^?I:6EI:6EE)24D9&1DI*2DI*2C(R,D9&1DY.3C8V-
M@H*"75U=2TM+7%Q<:VMK=G9V?'Q\@8&!B(B(BXN+AH:&A86%C(R,DI*2D9&1
MDI*2@H*"?7U]?GY^>GIZ>'AX<W-S<G)R=W=W>GIZ>7EY<W-S965E8F)B7EY>
M8F)B<G)RCX^/E965C8V-@H*"@("`?7U]?W]_AH:&CX^/C8V-CX^/C8V-BXN+
ME)24EI:6E)24GIZ>EY>7GY^?IJ:FIZ>GIJ:FIJ:FJ:FIJ:FIJ*BHIJ:FJZNK
ML;&QM[>WN+BXM+2TO[^_P<'!Q,3$O+R\L+"PMK:VKZ^OK*RLO;V]SL[.@X.#
MQL;&_____/S\_O[^_?W]________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____]_?WHZ.CC8V-EY>7B(B(H:&AE)24G9V=G)R<H*"@H*"@FYN;EI:6I*2D
MJZNKGIZ>FYN;GIZ>I:6EH:&AL+"PJ*BHK*RLJ*BHI:6EHJ*BH*"@HZ.CI:6E
MIZ>GIJ:FI:6EEY>7F)B8E)24B(B(B8F)AX>'B8F)B(B(;&QL4U-37%Q<:VMK
M=W=W?7U]AX>'B8F)A(2$BHJ*C8V-B(B(CHZ.CX^/AX>'B(B(AH:&?W]_>'AX
M=75U<7%Q>'AX?7U]>7EY>7EY=75U8V-C7%Q<6UM;9V=G>WM[D9&1D)"0C8V-
M@("`?7U]?7U]@("`?'Q\A86%D)"0C8V-E965EY>7B8F)CHZ.D)"0E)24EY>7
MFIJ:G9V=IJ:FJ*BHJ*BHHZ.CI*2DKJZNK:VMHZ.CK*RLL[.SN+BXL+"PH*"@
MGIZ>K*RLKZ^OM+2TN+BXKZ^OJJJJNKJZTM+2FIJ:IJ:F_____O[^_O[^_?W]
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________]O;VHZ.CAH:&G9V=
MDY.3E)24DI*2FYN;HZ.CH*"@IJ:FI*2DGY^?I:6EJ*BHJ:FIJJJJK:VMJJJJ
MI*2DK*RLJJJJK*RLK:VMI:6EHZ.CIJ:FHJ*BG)R<FYN;HZ.CHJ*BFYN;G9V=
ME965C(R,C8V-A86%BHJ*BHJ*;V]O55556EI:;&QL=75U@("`A86%B(B(B8F)
MAH:&C8V-CHZ.CHZ.BXN+B8F)A(2$@8&!@X.#>7EY='1T<7%Q<'!P<W-S?7U]
M>7EY='1T9F9F8&!@5U=79&1D>7EYD)"0CX^/C(R,@H*"@H*"A(2$A86%A86%
MBHJ*D9&1D)"0CX^/DI*2D)"0D9&1C8V-H*"@H*"@FYN;GIZ>I*2DI*2DIZ>G
MJJJJJ:FIJ*BHJZNKJ*BHKZ^OK:VML+"PIZ>GJJJJGY^?F)B8I*2DM[>WL+"P
MIZ>GJ*BHNKJZS\_/H*"@H:&A_____?W]_?W]_?W]____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________]?7UHZ.C@8&!F)B8F9F9H*"@E)24E)24I*2D
MIZ>GJZNKJZNKH*"@G9V=I:6EK:VMJZNKJ:FIIZ>GK:VMJ:FIH:&AK:VMJ:FI
MI:6EIJ:FIZ>GHJ*BH*"@G)R<H:&AJ:FIFYN;F9F9F9F9DY.3C8V-B8F)BHJ*
MBHJ*<7%Q5E9665E9:VMK=75U?GY^@X.#AX>'A(2$AX>'BHJ*C8V-CHZ.C8V-
MB8F)A(2$@8&!?7U]?'Q\>7EY<W-S<'!P<G)R>'AX=G9V<G)R9&1D86%A6UM;
M8F)B=75UCX^/D)"0CX^/B(B(@X.#@8&!@8&!A(2$B(B(AX>'B8F)BXN+D)"0
MG)R<F)B8EY>7E)24FIJ:GY^?H*"@HZ.CHJ*BI:6EJZNKKJZNJZNKK:VMK:VM
MJJJJL;&QK:VMIJ:FI*2DI:6EGIZ>H:&AL;&QJ*BHIZ>GIJ:FMK:VT]/3J*BH
MFIJ:_____?W]_/S\____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________O[^
M____\O+RGY^?@("`DI*2D9&1GIZ>E)24E965H:&AJ*BHJZNKJJJJIJ:FHZ.C
MHZ.CJ*BHIZ>GJ*BHIZ>GJ:FIK:VMI:6EHZ.CJ*BHJZNKJZNKI:6EI*2DJ*BH
MFIJ:H*"@HZ.CEY>7G)R<HZ.CE965DI*2BXN+CHZ.CX^/='1T5%146EI:;FYN
M<W-S>WM[?GY^@X.#B(B(C(R,C(R,C8V-CX^/D)"0C(R,@X.#A(2$?GY^>7EY
M=G9V<W-S=75U=75U>7EY>7EY=75U965E7U]?7U]?9F9F>WM[E)24EI:6D9&1
MC(R,AH:&A(2$A86%AH:&BXN+D)"0C8V-GIZ>H:&AE)24E)24DI*2EI:6D9&1
MFIJ:H*"@IZ>GI:6EJ*BHK*RLL+"PK:VMJ*BHM[>WIJ:FGY^?I*2DJJJJI:6E
MH:&AJ*BHL;&QIZ>GI:6EI:6EJJJJO+R\TM+2K*RLDI*2________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________O[^____\?'QGY^?B(B(FYN;
MFIJ:FYN;DY.3EY>7H:&AIJ:FJJJJJJJJJ:FIJ:FIIZ>GJ*BHJ*BHJ:FIIZ>G
MIJ:FJZNKJJJJI:6EIJ:FJ:FIJZNKJJJJJJJJJ*BHHZ.CIJ:FF9F9F)B8G9V=
MJ*BHEI:6DY.3EI:6CX^/C(R,>'AX5U=76%A8;6UM<'!P?GY^@8&!@8&!AH:&
MBHJ*BHJ*C(R,D9&1CHZ.BXN+AX>'A86%?GY^>WM[='1T<G)R<'!P='1T>'AX
M>7EY?7U]<G)R8F)B8&!@:6EI>GIZCX^/EI:6DY.3BHJ*BHJ*B8F)A86%A(2$
MB8F)C8V-C(R,CX^/EY>7F9F9D9&1DY.3F)B8E)24F9F9GY^?J:FIL+"PL[.S
MLK*RJJJJK*RLKJZNNKJZK:VMIZ>GH*"@I:6EJ:FIJ:FIJ:FIK*RLJ:FIIJ:F
MHZ.CJ*BHN[N[S<W-L+"PC8V-_/S\_____?W]________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________[>WMG9V=@H*"EI:6GY^?GY^?F9F9G9V=HZ.C
MIZ>GJ:FIJ*BHJ:FIJZNKJZNKHZ.CIZ>GJJJJJ*BHJ:FIIZ>GJ*BHJZNKIZ>G
MJ*BHJ:FIJ*BHJ*BHIJ:FH:&AHJ*BE)24EY>7G9V=FYN;E965F)B8FIJ:CHZ.
MBHJ*?GY^7EY>65E9:FIJ;V]O=W=WCX^/?GY^@8&!C(R,C(R,C8V-CHZ.C(R,
MB8F)B(B(A(2$?7U]?'Q\=W=W='1T<'!P<W-S>'AX>WM[?GY^=75U8F)B7%Q<
M9V=G=75UB8F)DY.3EY>7BXN+B(B(CHZ.BXN+AH:&BHJ*C8V-C(R,CHZ.E965
ME)24CHZ.EI:6F9F9FIJ:F)B8GIZ>JZNKLK*RM[>WO;V]MK:VM+2TLK*RQ<7%
MQ<7%MK:VJ*BHK:VMJ*BHJ:FIKJZNJ:FIHJ*BI*2DHZ.CH*"@L[.SS,S,M+2T
MD)"0\_/S_____/S\_O[^________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____[.SLF)B8@("`DY.3GIZ>GY^?FIJ:HZ.CI:6EIZ>GIJ:FIJ:FJ*BHJ:FI
MK*RLI*2DIZ>GHJ*BI*2DIZ>GI:6EJ:FIKJZNJZNKI:6EI:6EHZ.CHZ.CI:6E
MH:&AGY^?F)B8E)24H:&AG9V=EI:6G)R<F)B8DI*2CHZ.@H*"8V-C65E9:VMK
M<7%Q<'!PEY>7@("`?W]_AH:&BXN+C(R,BXN+C8V-C(R,B8F)AH:&?W]_>GIZ
M=W=W<G)R=75U=75U>'AX>GIZ>WM[;V]O7U]?5E969V=G>GIZ@8&!C(R,F)B8
MCX^/C(R,D9&1C8V-C8V-DI*2F)B8EI:6DI*2D)"0CHZ.C(R,D)"0FIJ:FIJ:
MG9V=G9V=KJZNO+R\NKJZOKZ^Q\?'P\/#M+2TN;FYS<W-Q,3$N+BXM+2TJ:FI
MJ:FIKZ^OJ:FIH*"@H:&AHZ.CHZ.CL+"PQ<7%L+"PCX^/Z^OK_____O[^_?W]
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________O[^____[.SLFIJ:AH:&F)B8
MG9V=GY^?G9V=HJ*BI:6EIZ>GIJ:FJ:FIK*RLJ:FIJ:FIJ*BHIJ:FG9V=GIZ>
MHJ*BGY^?I:6EJZNKKJZNIJ:FI*2DI:6EHZ.CI:6EG)R<GIZ>HJ*BEY>7EI:6
ME965G9V=H*"@FIJ:EY>7CX^/@H*"9&1D6%A8:&AH<G)R=G9V@("`@("`A86%
MA86%B(B(C(R,CHZ.C8V-CX^/BXN+A86%?7U]=W=W=75U<'!P='1T>GIZ?'Q\
M=75U>WM[<'!P7U]?5E969V=G?GY^@8&!C(R,CHZ.CX^/CHZ.CX^/BXN+BXN+
MD)"0EI:6DI*2C8V-D)"0D9&1FIJ:F)B8EI:6HJ*BHJ*BH*"@K*RLP,#`Q\?'
MP\/#Q<7%OKZ^L;&QH:&AJZNKN+BXN[N[J:FII*2DK:VML+"PJ:FIJ*BHHZ.C
MH:&AI*2DJ*BHN[N[MK:VAX>'W]_?_________O[^____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________?W]____ZNKJF9F9B8F)F9F9F9F9HJ*BHZ.CI:6EIZ>G
MIJ:FIZ>GJ:FIJZNKJJJJJ:FIJJJJJ*BHGY^?I:6EH:&AH:&AIZ>GJZNKJZNK
MJJJJJ*BHJ*BHI:6EGY^?GY^?H*"@GY^?E965E965EY>7G)R<G)R<FIJ:FIJ:
ME965AH:&:FIJ7%Q<965E;&QL;V]OA(2$BXN+@X.#A(2$AX>'CHZ.CX^/C(R,
MC8V-AX>'?W]_?GY^=W=W<'!P<W-S=W=W>7EY>WM[>WM[>GIZ<'!P8&!@5E96
M965E?GY^CX^/DY.3EY>7C(R,D)"0D9&1D9&1DI*2DI*2DY.3CX^/CHZ.E)24
MEY>7F)B8GY^?GY^?I*2DI:6EI*2DJJJJL[.SN;FYPL+"Q<7%O+R\N[N[M+2T
MH*"@FYN;K:VMJZNKJ:FIIZ>GI*2DHJ*BI*2DHZ.CH:&AH:&AH:&ANKJZO;V]
MCHZ.U-34_____O[^_O[^________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________O[^_/S\
M____Z.CHF)B8B(B(F9F9FIJ:GIZ>HJ*BHZ.CI:6EIJ:FJ*BHJJJJJJJJIJ:F
MIZ>GJ*BHH:&AI*2DJJJJIZ>GI:6EI:6EK*RLJ:FIJJJJJ*BHJJJJIJ:FHJ*B
MH:&AH:&AIJ:FFYN;J*BHK*RLH:&AFIJ:G)R<FYN;F9F9BHJ*;V]O6UM;965E
M:&AH;6UM@("`AX>'@H*"@8&!A86%B(B(BHJ*CHZ.C(R,AX>'?GY^?7U]=G9V
M=75U<7%Q<G)R<W-S>7EY?7U]?GY^<W-S8F)B6%A88V-C?7U]E965F)B8F)B8
MBXN+C(R,CHZ.D)"0EI:6DI*2D)"0D9&1D)"0E965G)R<GIZ>GY^?J:FIGY^?
MH*"@HJ*BIZ>GM;6UM;6UL[.SM[>WO;V]P\/#PL+"MK:VJJJJM+2TL;&QJZNK
MIZ>GHZ.CI*2DI*2DIZ>GIZ>GI:6EI*2DM+2TLK*RCHZ.RLK*_____?W]_?W]
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________O[^_?W]____Y>7EEI:6BHJ*FIJ:
MFYN;H*"@H:&AI*2DIJ:FJJJJIZ>GJ*BHK:VMI:6EI*2DHZ.CG9V=J:FIK:VM
MIJ:FIJ:FI:6EJ*BHJJJJK*RLJJJJJ:FIIJ:FJ*BHI*2DHJ*BH*"@FIJ:JJJJ
MI*2DGIZ>FIJ:GIZ>F9F9EY>7B8F)<7%Q6%A88V-C:FIJ<'!P?GY^?W]_A(2$
MA(2$A86%AX>'AX>'C8V-CHZ.B(B(@8&!?7U]>'AX>WM[<G)R<W-S<7%Q='1T
M=G9V?W]_>7EY9V=G7%Q<9F9F=W=WE)24FIJ:F9F9D9&1B8F)CX^/C8V-CX^/
MD9&1D9&1D9&1CX^/CHZ.EY>7HJ*BIZ>GN[N[L+"PN+BXI*2DK*RLOKZ^MK:V
ML;&QIJ:FI*2DN;FYO[^_P<'!M[>WLK*RK*RLHJ*BIJ:FIZ>GJ*BHIZ>GK:VM
MKJZNJJJJI:6EL;&QM[>WE)24P\/#_____?W]_?W]____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________?W]____XN+BD)"0C8V-G)R<H*"@H:&AH:&AIJ:FI*2D
MI:6EI:6EIZ>GJ:FIJJJJHJ*BH:&AHZ.CJJJJH*"@H:&AIJ:FJJJJHJ*BI:6E
MJ*BHJZNKIZ>GJ*BHJJJJJZNKJ:FIH:&AFYN;J:FIJ:FIH*"@H*"@H*"@G9V=
MEI:6BHJ*=75U6EI:9&1D:&AH<W-S?7U]@H*"B(B(B8F)B8F)B8F)BHJ*C8V-
MB8F)?W]_?GY^>GIZ='1T=75U=75U>GIZ?7U]=75U>'AX@("`@H*";FYN8&!@
M:VMK=G9VE965HJ*BHJ*BEY>7EY>7D9&1D)"0CHZ.C8V-D9&1E)24D9&1E965
MEI:6DY.3FYN;KJZNL+"PQ,3$S\_/PL+"N;FYN;FYJZNKI:6EHZ.CH:&AOKZ^
MN+BXKJZNIJ:FJ*BHJ*BHI*2DHZ.CHZ.CIJ:FI:6EI*2DIJ:FJ:FIM;6UP<'!
MH:&ALK*R_____O[^_?W]________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____W]_?D)"0CX^/FYN;G)R<G)R<I:6EGY^?I*2DHJ*BGIZ>H:&AHJ*BHJ*B
MFYN;I*2DK:VMK*RLJ:FIH*"@J*BHHJ*BG9V=HJ*BK*RLJZNKJ*BHJ*BHK*RL
MJZNKKJZNJZNKHZ.CJJJJK:VMH:&AH*"@HJ*BGIZ>EY>7C8V->WM[6UM;:6EI
M:6EI<'!P>'AX@X.#AX>'A86%AX>'B8F)BXN+B(B(B8F)A(2$?W]_>GIZ=G9V
M=W=W=G9V>'AX>WM[=W=W>'AX@("`AH:&<G)R8&!@;&QL>GIZE965G9V=H*"@
MEY>7FIJ:DY.3D)"0DI*2D9&1D)"0D9&1D9&1E965E)24DY.3DI*2F9F9G9V=
MIJ:FO[^_QL;&L[.SK*RLKJZNIZ>GI*2DJZNKN;FYKJZNI:6EIZ>GI*2DIZ>G
MIZ>GIJ:FJ:FIIZ>GHZ.CGY^?HJ*BH*"@IZ>GP<'!I*2DL+"P_________O[^
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________W-S<CX^/D9&1G9V=
MFYN;FIJ:HJ*BH:&AIZ>GH:&AG)R<GY^?HZ.CHZ.CFYN;GY^?J*BHKJZNK*RL
MJ*BHIZ>GJ:FIG9V=GIZ>I:6EJ:FIJZNKJZNKJZNKIJ:FKJZNK:VMJ:FIK:VM
MI:6EFIJ:EY>7HJ*BG9V=E)24B(B(=G9V7U]?;6UM;6UM<G)R>7EYA(2$AH:&
MB(B(AH:&AX>'AX>'BHJ*C(R,AX>'@("`?'Q\>7EY<W-S=W=W=G9V>7EY>GIZ
M>GIZ@("`AX>'<W-S7EY>;&QL>7EYFIJ:EY>7H*"@FYN;GIZ>FYN;EY>7G)R<
MEI:6D9&1D)"0DI*2E965F9F9FIJ:DY.3H:&AF)B8N+BXR\O+O+R\P,#`K:VM
MI*2DK:VMK*RLIJ:FL;&QKJZNGIZ>H:&AIJ:FIZ>GI*2DIZ>GIJ:FH:&AIJ:F
MHZ.CH*"@I:6EM;6UQ<7%J*BHJJJJ________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________U]?7CX^/E)24FIJ:EI:6FIJ:EI:6FYN;F)B8
MG)R<HZ.CH*"@H:&AIJ:FIJ:FI:6EHZ.CJZNKJJJJJZNKK:VMIJ:FJ:FIIJ:F
MH:&AJ:FIJ*BHJ*BHK*RLM+2TR\O+M[>WJZNKJ*BHH:&AH*"@HZ.CH*"@F9F9
ME)24BHJ*<G)R75U=:VMK<G)R=G9V>WM[?W]_@H*"AX>'B(B(BHJ*BHJ*BHJ*
MAH:&@8&!A86%?W]_>'AX>'AX>7EY>WM[?7U]?W]_@8&!A(2$AX>'<7%Q6EI:
M:VMKA86%F)B8HJ*BIZ>GFIJ:G9V=F9F9F)B8GIZ>G)R<E)24DY.3E)24EY>7
MHJ*BG9V=F9F9L+"PK:VMM+2TN+BXKZ^ODY.3HJ*BIZ>GG9V=HZ.CMK:VJ*BH
MJZNKJJJJI*2DIJ:FI:6EIJ:FI*2DHJ*BG9V=EY>7J*BHL[.SJZNKLK*RP\/#
MK*RLH*"@^_O[_____?W]________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____UM;6BHJ*CX^/G9V=G9V=FYN;DY.3C8V-DY.3G9V=H*"@GY^?H*"@I:6E
MJ*BHK*RLJJJJJJJJK:VMKJZNJZNKJJJJJ*BHI*2DI:6EL;&QKZ^OJ*BHIJ:F
MK:VMO[^_OKZ^KJZNL+"PJ:FIIJ:FI:6EH:&AG9V=FIJ:AH:&;FYN8&!@:FIJ
M<W-S<W-S<G)R@8&!@X.#@8&!@X.#AH:&AX>'B8F)B(B(AH:&A86%?7U]=W=W
M>GIZ=G9V>7EY?'Q\?'Q\?'Q\@X.#AX>'='1T7EY>;V]OAH:&G9V=H:&AGY^?
MF9F9F)B8H*"@FIJ:FIJ:EI:6DY.3FYN;FIJ:FIJ:IZ>GHJ*BG)R<FYN;G9V=
MH*"@E)24FIJ:GY^?GIZ>IJ:FHJ*BH*"@Q,3$M[>WHZ.CI:6EHJ*BH*"@J*BH
MIZ>GH:&AH*"@HJ*BE965CX^/HJ*BL+"PL;&QQ\?'M+2TG9V=]?7U_____?W]
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________U=75BXN+D9&1FIJ:
MFIJ:FIJ:G)R<CX^/D9&1EY>7G9V=HJ*BHJ*BJ*BHK*RLJJJJJ:FIJ:FIK:VM
MK*RLJJJJKJZNK:VMI:6EIZ>GLK*RL[.SKZ^OIJ:FJ*BHKJZNM[>WJZNKKJZN
MJ:FII:6EI*2DH*"@G)R<FYN;B8F)=W=W9&1D;&QL<G)R=G9V=75U>7EYA(2$
MAX>'A86%A86%B8F)BHJ*BHJ*B(B(@X.#='1T?'Q\>GIZ=W=W>GIZ>GIZ>7EY
M>GIZ@8&!AX>'=W=W86%A;&QLAH:&GIZ>I*2DK:VMD)"0CHZ.G)R<F)B8F)B8
MF9F9F)B8FIJ:FIJ:FYN;FYN;FYN;K:VMT-#0VMK:V-C8KZ^OBHJ*EY>7HZ.C
MH*"@H:&AI*2DLK*RP<'!JJJJI*2DH:&AI*2DI*2DHZ.CHJ*BI*2DI:6EH:&A
MEI:6GIZ>I*2DJZNKO[^_M[>WF9F9\?'Q_____?W]____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________TM+2B8F)CX^/FYN;F9F9G9V=HZ.CH*"@G9V=
MF)B8F9F9HJ*BI*2DIJ:FIZ>GJJJJJ:FIJZNKK*RLHJ*BJ:FIJ*BHM+2TK:VM
MIJ:FJ:FIK*RLK:VMJ:FIJZNKJJJJIJ:FJZNKKJZNJ*BHI:6EH*"@FIJ:EI:6
MFIJ:D)"0A(2$8F)B;V]O>'AX='1T?7U]>WM[>7EY?W]_?W]_A(2$BXN+BHJ*
MBHJ*AX>'@X.#?7U]>'AX=75U=G9V>WM[>'AX?'Q\@("`?W]_AH:&>WM[965E
M9F9FA86%H:&AI:6EIJ:FHZ.CF9F9FIJ:EI:6CX^/DY.3EI:6EY>7GIZ>FIJ:
MM;6U[.SL____________________SL[.E)24FYN;JJJJI:6EI*2DGIZ>KZ^O
MNKJZJJJJGY^?IJ:FIJ:FIZ>GJ:FIJ:FIJ*BHJ*BHI:6EGY^?IZ>GJJJJM+2T
MN;FYF9F9Z^OK_____?W]________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____T='1C(R,DY.3FYN;F)B8GY^?G9V=GIZ>FIJ:GIZ>GY^?H*"@I:6EJ*BH
MJJJJJZNKJ:FIJ:FIK:VMI:6EJJJJK*RLJJJJJJJJJ:FIJJJJIZ>GIZ>GJ*BH
MJZNKK*RLK*RLIJ:FIZ>GJ:FIJ:FIHZ.CGY^?EI:6DY.3D9&1@H*"86%A:&AH
M=W=W>7EY>WM[?'Q\@("`@("`@8&!@X.#AX>'AX>'B(B(B(B(AH:&@H*">7EY
M=W=W=W=W>WM[>WM[?GY^?W]_@X.#AX>'?7U]9V=G:VMKA(2$G9V=I*2DJ*BH
MIJ:FGIZ>GIZ>GY^?E965DY.3EI:6FYN;G)R<M;6U^/CX_____O[^_/S\_/S\
M_?W]________QL;&DI*2H:&AH:&AGY^?JZNKGY^?K*RLN;FYHJ*BHZ.CJ*BH
MJZNKK:VMK*RLJ*BHI:6EIZ>GI*2DGIZ>I*2DMK:VMK:VF9F9Y>7E_____O[^
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________O[^_O[^____SL[.BXN+EI:6G)R<
MFIJ:GY^?GY^?H*"@H*"@G)R<GIZ>H*"@HJ*BJ*BHJJJJJ:FIIZ>GIZ>GJZNK
MJJJJJJJJJJJJIZ>GJ:FIJZNKJ:FIIZ>GIZ>GJJJJJ*BHJ:FIJ*BHI:6EI*2D
MJ:FIIZ>GI:6EI*2DG9V=E)24CHZ.@H*"965E;6UM<W-S>WM[@8&!>'AX@("`
MA(2$@X.#A86%B(B(AX>'AH:&AH:&A(2$?GY^>WM[=W=W>7EY>7EY?7U]@H*"
M@H*"A86%BHJ*?7U]:6EI<7%Q@X.#G)R<HZ.CIZ>GHZ.CHJ*BG9V=G)R<EI:6
MEI:6FIJ:G9V=JJJJZ>GI_____?W]_?W]_?W]_?W]_?W]_/S\____ZNKJHZ.C
MFIJ:IJ:FHJ*BHJ*BFYN;H:&ALK*RG)R<I*2DKJZNK:VMK*RLJ:FIJ*BHIZ>G
MJ*BHJ:FIH*"@I*2DM;6UM+2TE)24V]O;_____O[^____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________?W]_?W]____R<G)B8F)EI:6G9V=F)B8G9V=H:&AI*2DIZ>G
MGY^?EY>7FIJ:GIZ>I:6EJ:FIIJ:FH:&AHJ*BJJJJKZ^OJ*BHJ*BHJZNKJJJJ
MK:VMK:VMJ:FIJ:FIJZNKJJJJJ*BHI*2DJJJJIJ:FH*"@HZ.CI:6EHZ.CHJ*B
MF9F9CX^/A(2$:&AH<W-S=75U>'AXA86%?7U]?GY^A86%@H*"A86%B8F)AX>'
MAH:&AH:&@("`>GIZ>WM[=G9V=G9V=W=W>'AX?GY^@8&!@H*"AX>'@H*";6UM
M9V=G@8&!GY^?H:&AJJJJG)R<H*"@GIZ>F9F9EY>7G)R<I:6EGIZ>M[>W^?GY
M_O[^_/S\_________O[^_?W]_O[^____^OKZMK:VG9V=KZ^OK:VMIJ:FHJ*B
MI:6EH:&AGY^?I*2DL[.SL[.SJJJJIJ:FHZ.CI:6EJZNKK*RLJJJJHJ*BK:VM
MP,#`F)B8TM+2_____?W]________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________O[^_?W]
M____Q\?'B8F)E965G9V=EY>7FYN;GIZ>I*2DHZ.CI:6EGIZ>EI:6GY^?IZ>G
MIZ>GI:6EH:&AI*2DJ:FILK*RJ:FIJ*BHJJJJJZNKK*RLJJJJJ:FIJ*BHJJJJ
MKJZNJJJJIJ:FK:VMIJ:FGY^?HJ*BHZ.CGY^?G)R<EY>7E965AX>';6UM;FYN
M>7EY=G9V>WM[@8&!?W]_@X.#AX>'A86%AX>'AH:&A86%AH:&@H*">GIZ>7EY
M<7%Q='1T?7U]>WM[?7U]?7U]@("`A86%BHJ*;6UM86%A>WM[GY^?GIZ>I*2D
MEI:6DI*2GIZ>G)R<F)B8EI:6HJ*BHZ.CF)B8[>WM_____O[^____________
M_O[^_?W]____^/CXL[.SGY^?MK:VL[.SL+"PM[>WM+2TGIZ>GIZ>GY^?I*2D
MK*RLJZNKIJ:FHJ*BI:6EJ:FII:6EIZ>GI:6EJJJJM+2TFYN;S\_/_____O[^
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________O[^____P\/#AX>'EI:6H:&A
MF9F9G9V=FIJ:I*2DIJ:FIZ>GI*2DG)R<EY>7FYN;IJ:FJ:FIJ*BHIJ:FJ*BH
MJ*BHKJZNK:VMJ*BHJZNKK*RLJZNKJZNKK:VMK*RLK:VMJJJJJ*BHHZ.CI:6E
MHJ*BHZ.CHZ.CHJ*BI*2DGIZ>EI:6B(B(;V]O:FIJ=G9V?7U]>GIZ>WM[@H*"
M@H*"A(2$@H*"A(2$A86%B(B(@X.#?'Q\=W=W=W=W='1T=G9V>7EY?GY^>GIZ
M@H*"@H*"@X.#B8F)<G)R;FYN@H*"H:&AGIZ>I*2DF)B8F)B8G)R<FYN;F)B8
ME)24GIZ>JJJJJ*BH\O+R_O[^_/S\_________O[^_?W]_?W]____[^_OJZNK
MGIZ>IJ:FJJJJJ:FIL[.SN;FYL+"PI*2DHJ*BI*2DHZ.CH*"@JJJJIZ>GJ*BH
MJZNKHZ.CH*"@IZ>GJ*BHLK*RE)24P,#`_____O[^____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________O[^_AX>'F9F9HJ*BG)R<FIJ:F9F9HZ.CI*2D
MIJ:FIJ:FI:6EFIJ:EY>7H:&AJ*BHK:VMIJ:FJ:FIH:&AJZNKK:VMJZNKK:VM
MK*RLK*RLJJJJK:VMK*RLJZNKJJJJK:VMH:&AHJ*BI*2DGY^?F9F9GIZ>IJ:F
MGIZ>EI:6B8F)<G)R;6UM>7EY@("`AH:&?'Q\<7%Q<W-S@H*"@H*"@X.#@X.#
MB(B(@X.#>WM[>'AX=W=W=G9V=W=W=75U>WM[>WM[?W]_@X.#AH:&B8F)=W=W
M<G)RB(B(G9V=GIZ>G9V=GIZ>H*"@GIZ>GIZ>GIZ>GIZ>J:FIN+BXQ<7%^?GY
M_____/S\_O[^_O[^_O[^_?W]_O[^____U]?7GY^?J*BHGIZ>IJ:FJ*BHKJZN
MJJJJJJJJJ:FIK*RLJ:FIKJZNIJ:FJJJJK:VMK*RLJ:FIJJJJI:6EIZ>GJ:FI
ML[.SE)24M[>W_____O[^________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____P,#`B8F)EY>7GY^?H:&AGY^?H*"@HJ*BIJ:FIJ:FJ*BHJ*BHHJ*BGY^?
MHZ.CJ:FIIZ>GH:&AK:VMJ*BHI*2DIZ>GJJJJJZNKK:VMJZNKJ*BHJZNKK*RL
MJJJJJJJJJJJJHZ.CGY^?HJ*BHJ*BF)B8E965GIZ>F)B8E)24BHJ*<W-S;V]O
M@8&!>'AXB8F)@H*":&AH<'!PA(2$AH:&@X.#@X.#AX>'A(2$?GY^=G9V<W-S
M=W=W?'Q\>GIZ?GY^@("`@8&!@("`BXN+CHZ.='1T;V]OBXN+G9V=GIZ>HZ.C
MG)R<I:6EHJ*BHZ.CJJJJJJJJLK*RS,S,R\O+X>'A_________/S\_?W]____
M_O[^____]/3TKJZNG9V=L+"PJJJJJ:FIKZ^OJZNKKZ^OJ*BHK*RLK*RLK:VM
MN+BXL;&QMK:VL[.SKJZNJZNKJJJJIZ>GG9V=J:FIN;FYHZ.CM+2T_____O[^
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________O[^____O+R\B8F)FYN;HJ*B
MH*"@HJ*BHZ.CI*2DI:6EI*2DI*2DIJ:FIJ:FHJ*BHJ*BIZ>GJ:FIJ*BHIZ>G
MIJ:FI:6EI:6EIJ:FJ:FIJ:FIJJJJJZNKJ:FIJ:FIJ:FIJ*BHHZ.CI:6EIZ>G
MJ*BHHZ.CH:&AH*"@G)R<EY>7DI*2BXN+=75U<'!P@H*"AH:&@X.#@H*"?W]_
M?7U]?7U]?'Q\@X.#A(2$@H*"@X.#@H*">GIZ>'AX=G9V>7EY>WM[>GIZ?'Q\
M@8&!?7U]@X.#C(R,>WM[<W-SAH:&G9V=EI:6J:FIGY^?GY^?G9V=GIZ>K:VM
ML[.SMK:VO+R\UM;6U-34W]_?^OKZ________________U]?7I*2DF)B8I*2D
MJ:FIJZNKJ*BHK*RLIJ:FIJ:FK:VML+"PJ*BHL+"PN[N[N[N[JZNKIZ>GKZ^O
MM+2TJ:FIJZNKJJJJK*RLO;V]KZ^OLK*R_____O[^____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________?W]_O[^____N[N[CHZ.H*"@H:&AGIZ>HZ.CGIZ>GIZ>IJ:F
MI*2DI:6EI*2DIJ:FH:&AH*"@HZ.CI*2DI*2DHJ*BI*2DI:6EI:6EJ:FIL;&Q
MKJZNK:VMKZ^OK:VMK:VMIJ:FI:6EGIZ>J*BHJ*BHHJ*BI*2DI:6EI:6EH*"@
MFIJ:E965BHJ*<W-S<'!P@("`A86%A(2$@8&!?GY^>WM[@8&!?7U]>7EY@8&!
M?GY^@X.#A(2$>WM[>WM[>WM[>'AX>7EY=W=W?W]_B8F)A(2$@8&!B(B(?'Q\
M='1TA86%F9F9FIJ:H*"@IZ>GH:&AFIJ:FIJ:JJJJK:VMKJZNIZ>GLK*RW=W=
MW=W=RLK*VMK:V-C8U-34MK:VFIJ:GY^?H*"@H*"@HJ*BCHZ.GIZ>HJ*BJJJJ
MK*RLJZNKL+"PK:VML;&QKZ^OK*RLK*RLLK*RLK*RK*RLK:VMKJZNK:VMK*RL
MN;FYL[.SKJZN_?W]_O[^________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________?W]_O[^
M_O[^N;FYD)"0GIZ>GIZ>H*"@GIZ>H:&AFYN;H*"@I*2DIZ>GIZ>GIJ:FHZ.C
MHJ*BHZ.CGIZ>H:&AI*2DIJ:FJJJJIZ>GK*RLL+"PL;&QL;&QKJZNK:VMJZNK
MJZNKHJ*BHZ.CHZ.CJ:FII:6EJJJJHZ.CI*2DGY^?F)B8C8V-A86%='1T<G)R
M?'Q\?GY^B8F)A86%@8&!;V]O=75U?W]_?W]_=W=W@("`A86%@8&!?'Q\>WM[
M=G9V>GIZ=G9V@("`@("`C8V-D)"0B(B(A86%>WM[<'!P@X.#H*"@G9V=EI:6
MJ:FIL+"PH*"@FYN;IZ>GL+"PL[.SIJ:FF9F9JJJJQ\?'PL+"N+BXL+"PF)B8
MG9V=K:VMJ:FIJ:FIJ*BHJ:FII:6EL[.SIZ>GJ*BHJZNKM;6UO;V]N[N[L;&Q
MLK*RK:VMJ*BHJ:FIJ*BHIZ>GIJ:FK:VMM+2TL+"PM;6UL+"PK:VM^?GY____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________O[^_/S\L;&QC8V-H*"@GIZ>
MGY^?H:&AHZ.CHZ.CH:&AH:&AIJ:FI*2DIZ>GJJJJHJ*BGIZ>HJ*BHJ*BIJ:F
MJ*BHIJ:FKJZNL;&QL[.SL;&QMK:VN+BXM+2TJJJJH:&AGIZ>L+"PI*2DG9V=
MJ:FII:6EHZ.CHZ.CIJ:FI*2DEY>7CHZ.>GIZ<'!P?GY^A86%A(2$AX>'A86%
MA(2$>7EY=G9V?GY^@H*"@8&!?'Q\?GY^@H*">'AX='1T>GIZ>GIZ@("`C8V-
MC(R,D9&1E)24E965?GY^=G9VC8V-E)24EI:6JZNKG)R<IJ:FK:VMHZ.CG9V=
MJ*BHL;&QHJ*BGY^?G9V=B(B(CHZ.CHZ.I*2DK:VMJ:FIJJJJJJJJL[.SJZNK
MJZNKK*RLH:&AKZ^ON[N[JZNKH:&AHJ*BR,C(N;FYI*2DJ:FIJ:FIGY^?G9V=
MIJ:FI*2DEY>7L[.SPL+"N+BXMK:VJ:FI]/3T________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________O[^_?W]KZ^O@X.#G9V=GY^?H:&AHJ*BH:&AI*2DI*2D
MI:6EI*2DIJ:FJ*BHJ*BHI*2DH*"@I*2DIZ>GIJ:FJJJJK:VMKZ^OL[.SLK*R
MFIJ:=W=W:&AH:&AH@("`IZ>GJ*BHH:&AJZNKJZNKI*2DIZ>GI*2DHZ.CI:6E
MHZ.CFIJ:CX^/>'AX<7%QAX>'A86%@H*"A(2$?W]_@8&!@("`?GY^?'Q\?GY^
M?W]_?GY^?'Q\>WM[>7EY?7U]>GIZ@H*"A86%CHZ.CX^/F)B8F)B8F9F9AX>'
M=W=WCX^/I:6EIZ>GJZNKIJ:FI*2DIJ:FGY^?HJ*BK*RLM;6UHZ.CGIZ>E)24
MCX^/DY.3BXN+G9V=H:&AKZ^OM;6ULK*RL[.SLK*RJJJJJ*BHK*RLJ:FIG9V=
MBXN+HJ*B@8&!H*"@N[N[L;&QJ:FIIZ>GL[.SNKJZL+"PK:VMF9F9AH:&F)B8
MM[>WN[N[JJJJ\/#P____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________O[^_O[^
M^_O[K*RL@8&!FIJ:HJ*BH*"@HJ*BHZ.CHZ.CHJ*BI*2DI*2DIJ:FJ:FIIZ>G
MI:6EIZ>GI:6EJZNKJ:FIKZ^OLK*RMK:VJZNK>GIZ0D)"*2DI)R<G+BXN1D9&
MF)B8J:FII:6EI*2DJJJJJJJJIZ>GHJ*BG)R<H*"@HJ*BGIZ>DY.3>WM[<7%Q
MA86%AH:&AH:&AH:&@("`=W=W?7U]?W]_?GY^?'Q\@8&!A86%@("`?7U]?'Q\
M?W]_?GY^@H*"AX>'B(B(B8F)DI*2EY>7GY^?B8F)>'AXF9F9J*BHK*RLKJZN
MKJZNK:VMH:&AH:&AIZ>GKJZNN;FYM+2TJZNKEY>7DI*2I*2DGIZ>I*2DHZ.C
MEY>7M;6UL;&QIJ:FI*2DJ:FIJZNKJ:FIAH:&@X.#>GIZB8F)@8&!E965L;&Q
MKZ^OIZ>GFIJ:J:FIK:VMH*"@FIJ:GIZ>I:6EFYN;IJ:FMK:VJ*BHY^?G____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________]_?WIJ:FB(B(F)B8GIZ>
MHJ*BGIZ>IZ>GG9V=GY^?H:&AI:6EIJ:FJ:FIJZNKI:6EI:6EIJ:FKJZNL+"P
MKZ^ON+BXK:VM4U-3'1T=,3$Q=75UL+"PY.3D____M;6UF9F9K:VMHJ*BIJ:F
MJ:FII*2DI:6EGIZ>FYN;H*"@GY^?F9F9@("`<G)RB(B(CX^/A86%AX>'B8F)
M=G9V>WM[?GY^?GY^?7U]?GY^@H*"@8&!@("`?'Q\>7EY=W=W?'Q\B(B(DY.3
MD9&1D9&1E965H:&ABXN+?'Q\IZ>GKJZNK:VMK*RLK:VMJZNKJZNKIJ:FJJJJ
MK:VMK:VMLK*RM+2TJJJJEY>7EY>7FIJ:GIZ>L+"PIJ:FK*RLK:VMK:VMIJ:F
MJ*BHL;&QJZNK@("`D)"0H:&AE965GIZ>I:6EK*RLIJ:FIJ:FDI*2C(R,EI:6
MF)B8FYN;HJ*BI:6EO;V]M;6UIZ>GG)R<V]O;________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________]O;VI:6EC(R,G9V=F)B8FIJ:I:6EI*2DH:&AH*"@
MH:&AI:6EJZNKJZNKJJJJJ*BHI:6EIJ:FK:VML[.SK*RLN+BX?'Q\(2$A2$A(
MJ*BH]/3T____________YN;FE965H:&AIJ:FH*"@I*2DJ*BHIZ>GHZ.CG)R<
MF9F9F)B8F9F9A(2$='1TBXN+C8V-?GY^B(B(AH:&>7EY>WM[?GY^?W]_?7U]
M?GY^?GY^?W]_@8&!?7U]@8&!>WM[@("`A(2$D)"0E965E)24F)B8IZ>GC8V-
M@X.#IJ:FL;&QK:VML;&QK*RLJ:FIKZ^OK*RLJJJJHZ.CHJ*BHZ.CK:VMK*RL
MCX^/CHZ.GIZ>GY^?KJZNKZ^ON;FYJ*BHHJ*BJ:FIJ*BHJZNKL+"PG9V=DY.3
MJZNKJJJJJJJJGY^?EY>7J:FIJJJJGIZ>G)R<M+2TM[>WJ*BHHZ.CF9F9L[.S
MP\/#LK*RFYN;UM;6____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M]/3TI*2DBXN+HJ*BG9V=F)B8GY^?IZ>GIZ>GJ:FII:6EJ:FIKJZNKZ^OK*RL
MJJJJJZNKKJZNK:VMKZ^OM+2TI*2D/S\_.#@XN;FY_________O[^_?W]_?W]
M_O[^GY^?F)B8IZ>GIZ>GH*"@G)R<HJ*BI:6EHJ*BG9V=E965DI*2B(B(='1T
M@X.#BHJ*@X.#AH:&?'Q\;6UM='1T>7EY?'Q\?W]_@8&!@("`@8&!@8&!@("`
M?GY^@("`@("`A86%CHZ.E965F)B8G9V=IZ>GD)"0C8V-J:FIL;&QL;&QL;&Q
MJZNKJ*BHLK*RK*RLJJJJI:6EHZ.CHJ*BIZ>GL;&QG)R<CX^/IJ:FJZNKJJJJ
MKZ^OL+"PJZNKJ*BHIZ>GI:6EKJZNK*RLG)R<L;&QKJZNJZNKG9V=D)"0BXN+
MH*"@JZNKIJ:FG9V=I*2DJZNKJ*BHJZNKLK*RO[^_NKJZO;V]HZ.CSL[.____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________\_/SHJ*BBHJ*G9V=H:&A
MI:6EE965IJ:FJJJJKZ^OL[.SKZ^OK:VMKZ^OL;&QKZ^OL+"PM+2TL+"PKJZN
MO+R\CX^/,C(RE)24_________/S\_/S\_O[^_O[^]/3TH*"@G9V=H:&AJ*BH
MHJ*BE965G)R<HZ.CH:&AG9V=EY>7CHZ.AH:&;V]O?W]_B(B(D9&1BXN+?W]_
M;&QL=75U>GIZ?'Q\?W]_@("`?GY^>WM[@8&!AH:&>'AX?GY^@H*"A86%D)"0
MC8V-DY.3GIZ>IZ>GE)24FIJ:K*RLKZ^OL[.SM[>WK:VMJJJJL;&QL;&QK:VM
MHZ.CGY^?IZ>GI:6EIJ:FI:6EG)R<HJ*BJJJJJ:FIK:VMJJJJJ:FIJJJJK*RL
MI:6EI*2DI*2DDY.3IZ>GIZ>GHJ*BI:6EK:VMI*2DH*"@L;&QJ:FII:6EJJJJ
MJ:FIJZNKI:6EDY.3JJJJNKJZP\/#J:FIQL;&________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________O[^____\?'QGIZ>D)"0HZ.CFIJ:J:FIL;&QGY^?GY^?L;&Q
MPL+"KZ^OJJJJL+"PL+"PL;&QLK*RKZ^OLK*RKZ^OO[^_@8&!0D)"Y^?G____
M_/S\_/S\_/S\_O[^_?W]R\O+CHZ.I*2DI:6EIJ:FIJ:FF9F9EY>7FIJ:F9F9
MF9F9F)B8D9&1@8&!<G)R@8&!AX>'C8V-BXN+B(B(?7U]?'Q\?'Q\@("`@8&!
M@X.#?W]_?W]_@H*"@8&!>'AX?W]_BXN+BXN+D)"0CX^/CX^/D)"0H*"@FIJ:
MHZ.CJ:FIK:VML+"PM+2TK*RLJ:FIL;&QL+"PJJJJIJ:FFYN;G9V=E965I:6E
MHJ*BK*RLJ*BHK*RLK:VMJ:FIKJZNK:VMIZ>GJ:FIK*RLI*2DK:VMJZNKHZ.C
ML[.SNKJZLK*RK:VMJ*BHE)24L[.SI:6EDY.3GIZ>HJ*BG)R<I*2DA86%F)B8
MO[^_P,#`K*RLP,#`____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________O[^____
M[N[NFYN;C(R,I*2DH:&AGIZ>L;&QLK*RIZ>GJ:FIOKZ^N;FYL+"PN+BXN+BX
ML[.SK:VML;&QKJZNJ*BHP\/#@X.#9&1D_____O[^_?W]_/S\_/S\_?W]____
MH*"@F9F9H:&AIZ>GHZ.CH*"@G9V=FYN;FIJ:F)B8EI:6E965F9F9D9&1<W-S
M>WM[B8F)@X.#@X.#B8F)B(B(AH:&@X.#@X.#@8&!@H*"@8&!@8&!@8&!?W]_
M?W]_@H*"BHJ*CX^/EI:6FIJ:FIJ:EY>7GIZ>FIJ:J:FIK:VMJ:FIJZNKL;&Q
MK*RLK*RLJZNKL;&QK*RLJJJJJ:FIHZ.CB(B(B(B(L+"PJZNKIZ>GK:VMK:VM
MK:VMJJJJKZ^OK*RLIJ:FK*RLJZNKKZ^OJZNKGIZ>HZ.CIJ:FG)R<GY^?G9V=
MC8V-K:VMG9V=A86%HJ*BJZNKJ*BHL+"PDY.3HJ*BMK:VO;V]KJZNN[N[____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________[>WMFIJ:B(B(G9V=I*2D
MG9V=I:6ELK*RK:VMGIZ>L;&QP\/#N;FYN[N[N;FYKZ^OJ*BHK:VMJ:FII*2D
MO[^_H:&AAH:&_____O[^_O[^_?W]_/S\____\_/SF9F9I*2DH*"@IJ:FIZ>G
MHJ*BG9V=H:&AH:&AFIJ:E965C(R,DY.3FIJ:=75U@8&!CX^/B8F)A86%@8&!
MB8F)B(B(AH:&@X.#@H*"@X.#@("`?GY^@("`@("`@X.#AX>'AX>'BHJ*DI*2
MFYN;H*"@H*"@GY^?F9F9GY^?IJ:FJZNKJJJJKZ^OIZ>GIJ:FI:6EJ:FIKJZN
MKJZNJ:FIJ*BHIJ:FC(R,J:FIKJZNIJ:FI:6EK*RLKJZNJZNKKZ^OKJZNJJJJ
MK:VMK:VMKZ^OH*"@AX>'HJ*BKJZNIZ>GL+"PHZ.CF9F9J*BHGIZ>B(B(G)R<
MKZ^OIZ>GI:6EI*2DL;&QL+"PN[N[K:VMN;FY________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________O[^____[>WMF)B8B(B(F9F9G)R<GY^?H*"@H*"@IZ>GJ:FI
MK*RLM;6UKJZNJZNKJZNKJ*BHIZ>GIZ>GJ:FIIZ>GL;&QQ,3$FYN;________
M____________^/CXP,#`H:&AG9V=IJ:FIJ:FIJ:FH*"@GY^?G9V=GY^?F)B8
MF)B8CX^/C(R,FIJ:=75U?7U]D)"0D9&1C8V-@8&!?W]_A(2$AX>'@("`@("`
M@X.#@X.#@8&!@X.#@8&!AX>'C8V-CHZ.BXN+C(R,E)24G9V=GY^?FIJ:H:&A
MG)R<EI:6IJ:FI*2DIJ:FJ*BHIZ>GI*2DIJ:FH*"@I:6EJ*BHI*2DKJZNI*2D
MHJ*BL+"PJ*BHH:&AI:6EJZNKK*RLJJJJK:VMK*RLK*RLJJJJK:VMKJZNGIZ>
MIJ:FJJJJGIZ>N+BXO;V]L[.SKJZNKZ^OK:VMK:VMK:VMK:VMIZ>GKJZNM;6U
MLK*RN[N[KJZNM;6U____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________?W]____
MZNKJEI:6B(B(G)R<GIZ>F)B8GIZ>G9V=HZ.CK*RLM+2TL;&QL+"PK*RLJ*BH
MIJ:FJ*BHHJ*BGIZ>H:&AIZ>GJZNKTM+2Y^?G]O;V____^OKZW-S<JJJJFYN;
MI:6EGIZ>I*2DJZNKG9V=F9F9I*2DG)R<FYN;G9V=GIZ>FIJ:FIJ:FYN;?'Q\
M?GY^BXN+CX^/D)"0CHZ.?W]_@H*"@("`@8&!@("`?W]_@X.#@X.#AH:&@X.#
M@("`D)"0CX^/D9&1DI*2D9&1EI:6FIJ:FYN;HZ.CIJ:FH:&AGY^?J:FIJ:FI
MK*RLJ:FIH:&AH*"@H:&AG9V=FYN;J*BHI:6EHZ.CI:6EK:VMI:6EIJ:FIJ:F
MJ*BHJZNKJJJJJJJJHZ.CIJ:FI:6EK*RLK:VMIZ>GKZ^OH:&A<G)RJ:FIP,#`
MM+2TKJZNM[>WK*RLJ:FIG)R<EY>7L[.SE)24C(R,M;6UN;FYM;6UKJZN]?7U
M_?W]________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________O[^_/S\____YN;FE965C(R,GY^?G)R<
MFIJ:GY^?H:&AHJ*BJ*BHLK*RLK*RIJ:FIZ>GK*RLJ*BHIZ>GH*"@F)B8GY^?
MGY^?G9V=LK*RT-#0R\O+Q\?'OKZ^JJJJI:6EI:6EHZ.CI:6EIZ>GK*RLF9F9
MH*"@J*BHGY^?G9V=G)R<F9F9FYN;GIZ>FIJ:AX>'?'Q\B8F)AH:&B(B(BXN+
MAX>'@X.#?W]_@("`@8&!@("`@H*"AX>'A86%B(B(A(2$BXN+D)"0DI*2DI*2
MDI*2EI:6F)B8G)R<G)R<HZ.CK*RLGY^?FYN;JJJJJ:FIHJ*BD9&1G9V=KZ^O
MIZ>GG9V=HZ.CIZ>GI*2DI:6EKZ^OJ*BHHZ.CJ*BHK:VMJJJJJ*BHJZNKIZ>G
MIZ>GIJ:FIJ:FI:6EIZ>GK*RLIJ:F;V]OHZ.CP,#`P<'!L[.SJ:FIC(R,IZ>G
MJ*BH@H*"JZNKIZ>GA(2$LK*RMK:VMK:VL+"P\O+R_?W]_?W]____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________?W]_/S\____X.#@DI*2DY.3FYN;EI:6GY^?H:&AHJ*BHZ.CJZNK
MK:VMM+2TJ*BHG9V=H:&AJ*BHKJZNJ*BHF)B8GIZ>H:&AHZ.CEY>7HJ*BI*2D
MJZNKJ:FII*2DIZ>GH:&AIJ:FIJ:FJJJJIZ>GF9F9J*BHJZNKIZ>GIJ:FIJ:F
MG)R<E965FYN;G9V=BHJ*?7U]?7U]?'Q\AH:&BHJ*C(R,A(2$?GY^>GIZ>WM[
M?'Q\A(2$B8F)B(B(C(R,E)24BHJ*B(B(F9F9G9V=F)B8FIJ:G)R<FIJ:GIZ>
MHJ*BIJ:FGIZ>DY.3DY.3J*BHGIZ>E965FIJ:JJJJH:&AF)B8HJ*BJZNKIZ>G
MIJ:FJJJJK:VMK:VMLK*RKZ^OIZ>GJJJJK*RLKJZNJJJJJ:FIJJJJJ:FIJZNK
MJZNKH*"@D)"0JZNKMK:VN[N[R,C(K*RL@8&!EY>7J*BHAX>'C(R,H*"@G)R<
MKJZNLK*RKZ^OK:VM[.SL_/S\_?W]________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
MVMK:C8V-EI:6H*"@FYN;H:&AJ*BHIZ>GI*2DJ:FIKJZNKZ^OK:VMG9V=FYN;
MIJ:FI*2DI:6EG)R<DI*2JZNKL;&QL;&QJ*BHG9V=GY^?HZ.CI:6EJ*BHI*2D
MGY^?H*"@J*BHG)R<HJ*BHZ.CI*2DI:6EH:&AG9V=H:&AF9F9E)24I:6EFYN;
MAH:&C(R,B(B(A(2$B(B(BHJ*CHZ.?'Q\@8&!B(B(@8&!@H*"@8&!B8F)DY.3
ME)24E)24FIJ:F)B8FIJ:I*2DG9V=GIZ>GIZ>F9F9G9V=H:&AIJ:FKZ^OHJ*B
MGY^?I*2DJ*BHJ*BHHZ.CHJ*BH*"@J:FIJJJJJZNKIZ>GIZ>GHJ*BJ:FII*2D
MI:6EH:&AH:&AIJ:FJ:FIGIZ>G9V=J:FII*2DJ*BHK:VMGY^?IZ>GC8V-I:6E
MMK:VKZ^ON[N[I*2D@X.#I*2DMK:VM+2TKJZNM;6UP,#`PL+"M+2TKZ^OY>7E
M_/S\_O[^____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________V]O;C(R,DI*2I:6EH:&A
MH:&AJJJJJJJJH:&AK*RLJZNKJ*BHI:6EH:&AG9V=FYN;G9V=I:6EGY^?E)24
MI*2DJZNKK*RLJZNKJ*BHIZ>GI*2DI:6EK*RLIZ>GIJ:FJ:FIK*RLIZ>GIJ:F
MJJJJKJZNIJ:FH*"@FYN;HZ.CH:&AG)R<GY^?EI:6CHZ.DI*2C(R,D)"0D9&1
MCHZ.BHJ*?W]_?W]_AX>'AX>'BHJ*C(R,B(B(C(R,E965G)R<GIZ>GY^?FIJ:
MH:&AGY^?G9V=I*2DI*2DHZ.CJ:FIJZNKI*2DJZNKDY.3H:&AK*RLK*RLIJ:F
MK*RLK:VMH:&AH:&AJJJJK:VMJJJJJ:FIKJZNJZNKK*RLJZNKI*2DJ*BHJJJJ
MIJ:FHZ.CDI*2D9&1FIJ:F)B8EY>7FYN;A86%J:FIO;V]KJZNKJZNL+"PM+2T
MN[N[F)B8G)R<I*2D@X.#J*BHO;V]M[>WI:6EVMK:_/S\_?W]____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________O[^____V]O;CX^/C(R,G)R<HJ*BHJ*BI*2DH:&AIJ:FKZ^O
MJ*BHHZ.CHZ.CH*"@FIJ:DY.3CHZ.G9V=HZ.CIJ:FH*"@JJJJL+"PK*RLJZNK
MJ:FIJ*BHIZ>GK*RLKZ^OJ:FIL+"PJJJJIJ:FJJJJJ:FIKZ^OJ:FIGY^?FYN;
MHJ*BH*"@G9V=FYN;EY>7E965EY>7D)"0E965D)"0E)24CX^/BHJ*BXN+BXN+
MBXN+B8F)DI*2D)"0D9&1E)24GIZ>G9V=H:&AHZ.CHZ.CHJ*BHJ*BI:6EIZ>G
MJ*BHK:VMJ*BHI:6EJ:FIEY>7H:&AKJZNJZNKIJ:FIJ:FL[.SJZNKIZ>GK:VM
MI*2DKZ^OL;&QK*RLJJJJK*RLK:VMJ:FII:6EH:&AI*2DIJ:F@("`CX^/AX>'
MC8V-JZNKM+2TEY>7JZNKMK:VL+"PKZ^OKJZNM[>WOKZ^@8&!C8V-IJ:F>7EY
MFIJ:MK:VN+BXHJ*BUM;6_?W]_O[^________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________?W]____
MUM;6B8F)CX^/FYN;H:&AI:6EJZNKJZNKJ:FILK*RJZNKHJ*BGY^?FYN;FYN;
MG9V=EI:6DY.3I:6EK*RLJ:FII*2DK*RLJZNKL+"PL;&QJJJJJZNKIZ>GI:6E
ML+"PKZ^OJZNKJ*BHGY^?IZ>GHJ*BGY^?FYN;G9V=HJ*BIZ>GH:&AFYN;G)R<
MG9V=FIJ:DI*2EY>7CHZ.E)24CHZ.BXN+C(R,D9&1E)24DI*2E)24E965E965
MEY>7FYN;G9V=H:&AIJ:FIJ:FI*2DJ*BHIJ:FG9V=H:&AI*2DGY^?JZNKKJZN
MJZNKJJJJG)R<EY>7I*2DJ:FII:6EK*RLJ:FII:6EJ*BHJZNKHJ*BIZ>GKZ^O
ML;&QK*RLGY^?H:&AI:6EG9V=G9V=BHJ*@X.#E)24FYN;IZ>GH:&AJJJJM+2T
MLK*RM+2TKZ^OJ:FII:6EJ:FIBXN+G9V=JJJJCHZ.GIZ>L+"PK*RLF)B8S,S,
M_O[^________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________O[^____U-34BXN+F)B8H*"@H*"@
MI:6EIJ:FI:6EJ*BHG9V=EI:6F9F9GY^?G9V=GIZ>IZ>GJ:FIJ:FIJ*BHGIZ>
MIZ>GJJJJJ*BHJZNKL[.SL[.SL;&QL+"PKZ^OKJZNKZ^OK:VMK*RLL+"PJZNK
MIZ>GF9F9GIZ>I*2DFIJ:FYN;GY^?HJ*BHZ.CGY^?FYN;H*"@FYN;E)24DY.3
MD)"0D9&1DY.3EY>7DY.3EI:6FIJ:F9F9G)R<FYN;G)R<GIZ>GIZ>H*"@I*2D
MHZ.CIJ:FJ*BHK*RLK:VMGY^?G9V=KJZNJJJJK*RLK:VMJJJJK:VMKZ^OG)R<
MFYN;H:&AHJ*BIZ>GJZNKIZ>GJ*BHHZ.CI*2DJJJJI*2DH:&AK*RLJZNKH*"@
MFYN;HZ.CIJ:FK*RLEY>7HJ*BIJ:FGIZ>@X.#G)R<P,#`N;FYP,#`J*BHH:&A
MIZ>GHZ.CGIZ>K*RLJ:FII:6EI:6EFYN;FYN;PL+"_O[^_O[^____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________?W]____T='1AX>'F9F9I:6EIJ:FJJJJI*2DI*2DHZ.CFYN;
MDY.3EI:6GY^?I*2DH*"@I:6EJ*BHIJ:FJ*BHK:VMH:&AGIZ>J:FIK*RLM;6U
ML[.SL+"PLK*RK*RLKJZNJZNKIZ>GI:6EK:VMJ:FIJ:FIIJ:FI:6EJ:FIHJ*B
MG)R<FIJ:FYN;HJ*BHJ*BGY^?F9F9F)B8EI:6EI:6D9&1C8V-C8V-E)24EI:6
ME)24FIJ:G)R<G9V=GIZ>GY^?H:&AI:6EHJ*BHZ.CIJ:FJ*BHJ*BHK*RLKZ^O
MI:6EGIZ>JZNKJZNKIZ>GK*RLIZ>GJJJJL;&QKZ^OHJ*BDY.3EY>7I*2DHJ*B
MJZNKL;&QJJJJIZ>GI:6EIJ:FI*2DI*2DGY^?H:&AG9V=IZ>GJJJJIJ:FCX^/
MD9&1J*BHNKJZB8F)C(R,O;V]N;FYM+2TI:6EHJ*BJ*BHJZNKK*RLH:&AC8V-
MFYN;L;&QI:6EFIJ:O+R\_O[^____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________O[^____
MT-#0BXN+G)R<JJJJJJJJJ:FII:6EJ*BHH*"@E)24EY>7DY.3D9&1G9V=J*BH
MIZ>GJ:FIIZ>GHZ.CL[.SE)24DI*2IJ:FL;&QNKJZMK:VL;&QLK*RK:VMJZNK
ML+"PI*2DIZ>GIJ:FK*RLK:VMIZ>GI:6EIZ>GJ*BHI*2DG9V=EY>7FIJ:G9V=
MH*"@G)R<D9&1EI:6F)B8E965E965EY>7F)B8F)B8E)24FIJ:G9V=GIZ>H*"@
MH:&AI:6EJ*BHI*2DH*"@IZ>GJ:FIJ:FIK*RLJZNKJJJJJ*BHJZNKK*RLK*RL
MIZ>GJ*BHKJZNJZNKIJ:FH:&AGIZ>DI*2D)"0F)B8J:FIL;&QJ:FII:6EJZNK
MIJ:FI*2DHZ.CH*"@H*"@H:&AI:6EJ*BHK*RLDY.3H*"@HJ*BJ*BHG9V=I:6E
MO+R\NKJZMK:VH*"@EI:6I:6EHJ*BI:6EH*"@JZNKK:VMJ*BHJ:FIG9V=N+BX
M_O[^_?W]____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________R\O+AX>'GY^?KZ^OJJJJ
MHZ.CI*2DH:&ADY.3DY.3F9F9D9&1D9&1EY>7H:&AIZ>GIZ>GJ*BHI:6EKJZN
MJ*BHIJ:FJ:FIIZ>GM+2TMK:VKZ^OKJZNL;&QJJJJL;&QI*2DK:VMJ*BHJ:FI
MKZ^OIJ:FH:&AHZ.CIZ>GH:&AH:&AH*"@GY^?FIJ:FIJ:G9V=F9F9EI:6EY>7
MG9V=F9F9FYN;GY^?F9F9F)B8FIJ:GY^?GIZ>H:&AIJ:FIZ>GIJ:FI*2DH:&A
MH:&AI*2DI*2DIJ:FK*RLK:VMKZ^OK:VMIJ:FK:VMHJ*BJ*BHJJJJHJ*BJ*BH
MIJ:FGIZ>FYN;EY>7DI*2G)R<I:6ELK*RJ:FIK:VMJJJJHJ*BH:&AHJ*BGY^?
MI:6EJZNKJ:FIK:VMG9V=HJ*BK*RLL+"PGIZ>J*BHKZ^OLK*RN+BXM[>WF)B8
MDY.3DY.3EI:6IJ:FI:6EH*"@J*BHK*RLHJ*BL;&Q_____/S\_O[^________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________R,C(@H*"G9V=JZNKIJ:FH*"@HZ.CD)"0AH:&G9V=
MEY>7E)24F)B8G9V=GY^?IJ:FIZ>GJ:FIJ*BHJ*BHL[.SJJJJJZNKIJ:FGIZ>
MIZ>GKZ^OJ:FIJ*BHJJJJK*RLJZNKL;&QK*RLK*RLKJZNJJJJIJ:FHJ*BI:6E
MIJ:FI*2DHJ*BG9V=FIJ:F9F9GIZ>G9V=E965DI*2FYN;FIJ:G)R<H*"@GIZ>
MG)R<FYN;GY^?G9V=H:&AJ:FII:6EI*2DH:&AH:&AGY^?HZ.CI*2DIZ>GL;&Q
ML[.SL;&QIJ:FG9V=HJ*BJ*BHI:6EF9F9F9F9I:6EK*RLG)R<HJ*BIJ:FF)B8
MHZ.CF)B8GY^?J*BHJ:FIJJJJIJ:FI:6EHJ*BH*"@IJ:FM;6UM+2TK:VMI*2D
MF)B8MK:VJJJJB8F)C(R,L+"PKJZNKZ^OM+2THJ*BH:&AI*2DI*2DFYN;DY.3
MD9&1J*BHKZ^OI:6EK:VM_____/S\_O[^____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
MR,C(BHJ*FIJ:HZ.CI*2DH*"@GIZ>BHJ*@8&!G9V=FIJ:GY^?GY^?GY^?I:6E
MJ*BHJJJJJZNKI:6EIJ:FIZ>GIZ>GK*RLKZ^OJ:FIH*"@KJZNM;6UGIZ>GY^?
MIZ>GI:6EJ:FIL;&QKZ^OL+"PJJJJJ*BHHJ*BHZ.CJZNKHZ.CG9V=GIZ>G9V=
MFYN;GIZ>G)R<EI:6CX^/EI:6FYN;FIJ:FYN;G)R<H*"@H*"@GIZ>GY^?HJ*B
MH*"@IZ>GI:6EHZ.CG9V=H:&AI*2DHJ*BJ*BHLK*RL[.SLK*RIJ:FH:&AEI:6
MJ*BHFIJ:EY>7GY^?G9V=H*"@HZ.CHZ.CL+"PJ*BHG9V=E)24C8V-IZ>GL+"P
MJJJJJ*BHJ:FII:6EGIZ>HZ.CKJZNKZ^OJZNKC8V-@8&!K:VML+"PEI:6AH:&
MKZ^OKZ^OI*2DDI*2GY^?IZ>GIJ:FK*RLF)B8J:FIK:VMI:6EKJZNH*"@IJ:F
M_____/S\____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________Q,3$@8&!FYN;H:&AHJ*B
MJJJJH:&AD)"0E)24EY>7H*"@GIZ>G9V=GIZ>I:6EJZNKK:VMJZNKIZ>GJZNK
MJJJJI*2DK*RLL;&QM+2TKZ^OK:VMJZNKJJJJH:&AIJ:FI:6EGY^?M+2TKZ^O
MI:6EJ:FIJ*BHHZ.CGY^?H*"@H*"@I*2DJ:FIIJ:FGY^?G9V=H:&AI*2DGIZ>
MDY.3EY>7F9F9FYN;GIZ>GIZ>H:&AHJ*BH:&AH*"@F)B8JJJJI*2DF9F9DY.3
MFIJ:FIJ:G9V=I*2DI:6EHZ.CJJJJJ:FIJ*BHGY^?G9V=F)B8GY^?K:VMJZNK
MI:6EJZNKI*2DF9F9I*2DJJJJGY^?H*"@F)B8EI:6GY^?JZNKM+2TM+2TK:VM
MI*2DJ:FIHJ*BL;&QDI*2?GY^F)B8J:FIH*"@HJ*BK:VMJJJJHZ.CEY>7F9F9
MJZNKKJZNM[>WLK*RGY^?GIZ>J*BHL;&QI:6EH*"@_____?W]____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________Q,3$A86%G9V=HZ.CG)R<H:&AF)B8CX^/F9F9D9&1
MGY^?HJ*BG)R<GY^?I:6EIZ>GJJJJJZNKH:&AKZ^OK:VMJZNKK:VMIJ:FFIJ:
MH*"@M+2TJJJJHJ*BJJJJH:&AKJZNHJ*BJ:FIJZNKHJ*BIZ>GIZ>GHJ*BFYN;
ME)24FIJ:GIZ>FYN;GY^?H:&AH:&AIJ:FI:6EH:&AEI:6F)B8F9F9G9V=H:&A
MGY^?G9V=HJ*BHZ.CGIZ>HZ.CEI:6D9&1E965EI:6E965EY>7G9V=H:&AI:6E
MGY^?I*2DIJ:FIJ:FFYN;DI*2F9F9IJ:FJZNKKJZNJ*BHK*RLJ*BHD9&1DY.3
MJJJJJ:FII:6EG)R<F)B8E)24GY^?IZ>GKJZNKZ^OK:VMKZ^OIJ:FKZ^OJ*BH
ME965CX^/H:&AK:VMJZNKL[.SM+2TKJZNF)B8EI:6H:&AHJ*BG9V=F9F9E)24
MJJJJN+BXL[.SJ*BHHJ*B________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
MQ,3$BXN+GY^?JJJJIJ:FC(R,A(2$@X.#D)"0FIJ:F)B8I:6EH:&AG)R<H:&A
MI*2DJJJJHZ.CD9&1F)B8KZ^OJZNKJJJJG)R<CHZ.E)24MK:VO[^_IJ:FIJ:F
MG)R<IZ>GJJJJFYN;G)R<I*2DI*2DI*2DJ:FIH*"@E)24H*"@H*"@G9V=G9V=
MFYN;GY^?JZNKI:6EHZ.CI*2DFYN;EI:6H*"@I*2DHJ*BH:&AI*2DF)B8DY.3
MG9V=E)24EI:6BHJ*CX^/G)R<DI*2EY>7E)24GIZ>GY^?F)B8G)R<FIJ:FYN;
MFYN;IJ:FGIZ>IZ>GKJZNIJ:FIJ:FJ*BHI*2DI:6EJ:FIJJJJJ*BHJ:FIJ:FI
MJ*BHKJZNF9F9FIJ:K*RLL[.SL;&QIJ:FHJ*BJZNKL+"PP,#`LK*RC8V-B(B(
MM+2TLK*RN+BXHZ.CDI*2HJ*BFYN;M+2TI*2DIZ>GHJ*BLK*RKJZNK*RLIZ>G
M_____?W]____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________P<'!C8V-HZ.CI*2DHJ*B
MFYN;?7U]C8V-E965E)24F9F9H*"@JJJJH:&AFIJ:F9F9I:6EF)B8E965CHZ.
MKJZNK*RLFIJ:DI*2F)B8C8V-H*"@N[N[P,#`KZ^OGIZ>EY>7H*"@L+"PK*RL
MI:6EFIJ:G)R<H*"@GY^?HJ*BFIJ:G)R<JZNKL;&QK:VMI*2DI:6EH:&AH*"@
MHJ*BH:&AI*2DHZ.CGIZ>FIJ:FYN;EI:6EY>7CX^/DI*2FYN;EI:6FYN;D9&1
ME965E)24IJ:FH:&ACX^/A(2$A86%BHJ*J:FIKJZNEY>7G)R<FYN;H:&AHZ.C
MI:6EJ*BHJ:FIIJ:FJJJJN+BXJ*BHHZ.CJJJJKJZNL;&QL+"PI*2DGIZ>HJ*B
MK:VMJ:FIIJ:FHJ*BG9V=H:&ANKJZJ:FIF)B8>GIZF)B8P,#`MK:VLK*RH:&A
MLK*RI*2D@H*"B8F)>WM[<W-SGIZ>N+BXKJZNH*"@____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________N[N[C8V-HJ*BGY^?G9V=J:FIFIJ:D9&1C(R,DY.3
MHZ.CHJ*BGIZ>G9V=HJ*BGY^?GIZ>FYN;FYN;E965MK:VKZ^OFYN;C8V-FIJ:
MEI:6E965H:&AM[>WN+BXH*"@JZNKIJ:FJZNKL;&QKJZNIJ:FHZ.CH:&AHZ.C
MHJ*BH:&AHZ.CI:6EIZ>GJ*BHH*"@HJ*BH:&AHZ.CH*"@FIJ:GY^?IZ>GH*"@
MFYN;F9F9FYN;E965C8V-EY>7CHZ.B8F)GIZ>GIZ>DY.3EI:6F9F9EY>7H*"@
MF9F9FIJ:DY.3G)R<GY^?HJ*BI*2DH*"@HZ.CHJ*BI:6EIZ>GHJ*BHJ*BGY^?
MHJ*BIJ:FJ*BHFIJ:H:&AJJJJL[.SL[.SL+"PKJZNJZNKKJZNLK*RLK*RFIJ:
MC8V-G)R<GIZ>H*"@F9F9JZNKL[.SKZ^OEI:6@H*"EI:6F)B8@("`AH:&@8&!
M=W=WH:&AL;&QIZ>GFYN;_____?W]________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
MN[N[D)"0H:&AG)R<B(B(F9F9HZ.CI*2DE)24EY>7IJ:FHZ.CG9V=H*"@I:6E
MI*2DHZ.CEI:6E965F9F9KZ^OKJZNJ:FIEI:6EI:6F)B8F9F9G)R<KJZNL;&Q
MCX^/HJ*BK*RLK:VMJZNKIJ:FIZ>GHZ.CG9V=HJ*BJZNKJZNKI*2DH*"@HZ.C
MH*"@FYN;GIZ>G9V=G9V=IJ:FHZ.CHJ*BIJ:FHZ.CGY^?GIZ>G9V=HZ.CFIJ:
MGY^?EI:6DI*2F)B8HJ*BG9V=G)R<F9F9HZ.CHJ*BF)B8E)24G9V=F)B8AH:&
MIZ>GJ:FIJJJJI:6EGY^?HJ*BI*2DHZ.CIZ>GHJ*BI:6EI*2DJJJJI*2DH:&A
ML;&QN[N[N[N[O[^_L[.SI*2DI:6EJ*BHL+"PLK*RBHJ*F)B8L;&QJ*BHFIJ:
MGY^?H*"@G9V=D)"0?GY^A86%G)R<@X.#B8F)DY.3D)"0KZ^OL+"PJ*BHFIJ:
M_____/S\_O[^________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________?W]N+BXCHZ.H*"@GY^?D)"0
MCX^/DY.3I*2DJ:FIJ*BHH*"@HJ*BJ*BHIZ>GIJ:FJ*BHJ*BHG9V=DY.3GIZ>
MH*"@G9V=J*BHFIJ:F9F9EI:6E)24H*"@JZNKH:&AFIJ:I*2DE)24F9F9I*2D
MI*2DM;6UI*2DFYN;H*"@J:FIH:&AH:&AGY^?FYN;G)R<HZ.CHZ.CH*"@H:&A
MHJ*BIJ:FI*2DHJ*BHZ.CG)R<FYN;EI:6F)B8GY^?D)"0FYN;H:&AJ:FIG9V=
MJ*BHI*2DF)B8JJJJI*2DI:6EIJ:FEI:6F9F9CX^/J:FIK*RLJ:FII:6EI:6E
MJJJJJ:FIJZNKK:VMK*RLIJ:FKJZNK:VMKZ^OJZNKI*2DI:6EJ*BHLK*RKZ^O
MJ:FII:6EI:6EI:6EI*2DC(R,E)24FIJ:DY.3A86%C8V-E)24G)R<J*BHCHZ.
M?GY^E)24G9V=B8F)FIJ:IJ:FJZNKL;&QI:6EE965____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________?W]M[>WB(B(HJ*BIJ:FG9V=FYN;H:&AGY^?H:&AHJ*B
MG9V=HZ.CJZNKIZ>GI*2DJ*BHI*2DGIZ>EI:6I*2DF)B8E965EY>7F9F9EI:6
MG)R<K*RLJ*BHG)R<E)24JZNKJ*BHK:VMH*"@FIJ:FYN;J*BHIZ>GH:&AH*"@
MIJ:FGY^?HJ*BJ*BHI*2DHJ*BGY^?HZ.CHZ.CG)R<H*"@HZ.CH*"@H*"@GY^?
MFIJ:F)B8E965FIJ:I*2DHJ*BG)R<HZ.CGY^?IJ:FIJ:FIJ:FHJ*BIZ>GHJ*B
MIZ>GJ*BHF9F9FYN;FYN;L;&QL+"PK*RLK:VMJJJJJZNKJ*BHIZ>GKZ^OL[.S
MJZNKGY^?JZNKLK*RK:VMK:VMJZNKIZ>GK*RLOKZ^N;FYL;&QL;&QK*RLFIJ:
M>GIZDY.3G9V=G)R<DY.3F)B8J*BHN+BXK*RLH*"@H*"@IJ:FIZ>GI:6EIJ:F
MIZ>GJ*BHKJZNK:VMF)B8________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________________^_O[
MLK*RA86%GY^?H:&AHJ*BG)R<G9V=HZ.CH:&AHZ.CH:&AH:&AHZ.CIJ:FIZ>G
MJ:FIIJ:FFYN;D9&1FYN;FIJ:HJ*BHJ*BEI:6DY.3H:&AL+"PFIJ:EI:6HZ.C
MIJ:FIJ:FJ:FIIJ:FJ*BHHJ*BIZ>GJ:FIJ:FIJ*BHJ*BHJ*BHJJJJK*RLIJ:F
MI:6EHJ*BH:&AHJ*BG9V=G9V=HJ*BGIZ>FYN;EY>7E965EY>7E965EI:6G)R<
MHZ.CJ:FIHZ.CH:&AKJZNL[.SIJ:FG)R<G)R<H:&AI:6EIJ:FH:&AI:6EI*2D
MK*RLJJJJK:VMK:VMJZNKK:VMJJJJI*2DKJZNL[.SKJZNJ*BHKZ^OLK*RK*RL
MK:VMKZ^OLK*RJJJJL;&QMK:VQ<7%R,C(JJJJKJZNF9F9F9F9I:6EF)B8EI:6
ME)24CX^/I*2DKZ^OJ:FIJJJJJ*BHI*2DIZ>GHZ.CJZNKJ:FIK:VMKZ^OEI:6
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________]_?WJJJJ@8&!G)R<GY^?H:&A
MHZ.CI*2DI:6EH*"@H*"@IJ:FH:&AG9V=IJ:FJ*BHKJZNK:VMCX^/AX>'D)"0
MB8F)I*2DK:VMDY.3F)B8GIZ>F9F9F)B8I*2DI:6EIJ:FJ:FIK*RLJZNKKZ^O
MJJJJIZ>GH:&AJZNKK:VMIZ>GJZNKJZNKIJ:FHJ*BIJ:FH*"@G)R<HJ*BIZ>G
MEY>7GIZ>GIZ>GIZ>E965EI:6HZ.CHJ*BG9V=EI:6C8V-H:&AI:6EGIZ>G9V=
MIZ>GJ:FIFYN;DI*2H*"@HJ*BHZ.CFIJ:I:6EIJ:FJZNKJZNKJ:FIJ:FIK:VM
MJZNKKZ^OJ*BHJZNKL[.SL+"PK:VMJZNKK*RLK*RLL+"PL+"PK:VMK:VMIZ>G
MH:&AMK:VM[>WL[.SJJJJ@8&!B8F)EY>7?W]_B8F)C8V-?7U]DI*2JJJJIJ:F
MHZ.CIJ:FH:&AI:6EIZ>GJ*BHJ*BHJJJJK*RLE)24____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________]_?WJ*BH>WM[EI:6FIJ:EY>7G)R<I*2DF9F9G9V=HZ.C
MIZ>GIZ>GHZ.CIZ>GJ:FIJZNKJZNKEY>7C8V-E)24C(R,J:FIL;&QEY>7F9F9
MD9&1D)"0GY^?I:6EH*"@L;&QKZ^OK:VMK*RLJZNKJZNKI:6EI*2DIZ>GJJJJ
MJ*BHIZ>GH:&AH*"@HZ.CHJ*BG)R<H*"@GY^?HJ*BIJ:FG)R<G)R<HJ*BF9F9
MFIJ:G)R<D9&1G9V=JJJJHJ*BD9&1H:&AI*2DFYN;F9F9FYN;HZ.CG)R<F9F9
MG)R<HJ*BHZ.CIJ:FI:6EJZNKK:VMHJ*BI*2DJJJJJJJJJJJJIZ>GJJJJK:VM
MK:VMH:&AIZ>GJJJJK*RLKJZNJZNKK*RLK:VMK:VMK*RLJ*BHI:6EKJZNGIZ>
M;FYN@H*"HZ.C@("`AX>'EI:6BXN+FYN;J*BHIZ>GIJ:FJ*BHHZ.CJ*BHJ*BH
MIJ:FJ:FIK*RLKJZNEI:6________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________________]?7U
MJ*BH?7U]CHZ.E)24F)B8FYN;GIZ>F9F9H*"@IJ:FI:6EHZ.CHZ.CH*"@GY^?
MHZ.CI*2DGY^?CHZ.HZ.CIZ>GIZ>GI*2DI:6EEI:6EI:6F)B8F)B8H*"@JJJJ
MJ:FIK*RLL+"PJZNKJ*BHK*RLH:&AI*2DJJJJJ:FIHZ.CIJ:FJ:FIHJ*BG9V=
MGIZ>FYN;GY^?GY^?G)R<IZ>GG)R<EY>7EY>7EY>7HJ*BH:&AG)R<FIJ:HZ.C
MHJ*BHJ*BHZ.CIJ:FHJ*BG9V=FYN;HJ*BHJ*BF9F9EY>7DI*2G9V=IJ:FIJ:F
MK*RLK:VMHJ*BI:6EJ*BHJZNKJZNKJ:FIJ*BHIZ>GIZ>GF)B8H:&AHZ.CI*2D
MIZ>GIJ:FIJ:FIZ>GJ:FIK:VMJ:FIHJ*BI:6EGIZ>>WM[?W]_BXN+B8F)A86%
MD9&1F9F9I:6EIZ>GIZ>GH:&AH*"@H*"@J:FIIJ:FI:6EIZ>GJJJJKZ^OEY>7
M_O[^________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________\_/SIJ:F?'Q\AX>'EI:6G)R<
MF)B8H:&AI:6EIJ:FJ:FII:6EGIZ>GY^?GY^?GIZ>G9V=EI:6G9V=BXN+L[.S
MIZ>GE965HZ.CIJ:FDI*2EI:6H:&AH:&AG9V=I*2DIJ:FJ:FIJJJJJZNKK*RL
MJZNKIJ:FI*2DIZ>GIJ:FI*2DH:&AH:&AH*"@G)R<HJ*BIZ>GH:&AI*2DHZ.C
MFYN;EI:6DI*2CHZ.DI*2EY>7FYN;HJ*BI*2DE)24EY>7HJ*BH:&AH:&AH*"@
MH*"@H*"@H:&AI*2DHZ.CI:6EFYN;H*"@HZ.CI*2DIJ:FK:VMIJ:FIJ:FJJJJ
MK*RLK:VMJ:FIIJ:FI*2DJZNKH:&AI:6EK:VMIJ:FK:VMIJ:FI*2DI*2DIJ:F
MI:6EJ:FIH:&AG9V=I*2DFIJ:C(R,DI*2GY^?EI:6FYN;G9V=I*2DI:6EIZ>G
MH:&AH:&AI:6EIZ>GI*2DI*2DI:6EJ*BHK:VMEI:6^OKZ________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________\_/SI*2D>WM[CX^/DY.3E965DI*2H*"@J:FIJ:FIJ:FI
MI*2DFYN;H*"@JZNKJZNKIJ:FCX^/G)R<E965HJ*BDY.3FYN;KJZNE)24D9&1
MG)R<H*"@HZ.CHZ.CF)B8I*2DJ*BHJ:FILK*RK:VMK*RLJ*BHIJ:FI:6EI*2D
MIZ>GHZ.CG9V=HJ*BG9V=H*"@I:6EH*"@J*BHJZNKGIZ>EI:6F)B8F)B8GIZ>
ME965DI*2F9F9FIJ:BXN+CX^/HZ.CHZ.CH:&AGIZ>G)R<G9V=GIZ>G)R<HZ.C
MJ*BHGY^?IJ:FH:&AGY^?K:VMJ:FIGY^?J:FIJJJJIJ:FIZ>GJ:FII:6EG)R<
MKJZNJ*BHIJ:FJ:FIHZ.CJ:FIJ:FII:6EHJ*BIZ>GI:6EIJ:FHZ.CGY^?HZ.C
MJ*BHJJJJI:6EHJ*BI:6EI*2DHJ*BH*"@H:&AH:&AI:6EIJ:FI:6EJ*BHI:6E
MJ*BHI*2DJZNKLK*RFYN;]O;V_____O[^____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________________[^_O
MG)R<@H*"GIZ>F9F9EI:6GIZ>HJ*BI:6EHJ*BHZ.CI*2DH*"@GY^?I*2DJ:FI
MJZNKGY^?EI:6CHZ.G9V=J:FIG9V=DI*2B8F)D)"0IJ:FIJ:FHZ.CK:VMHZ.C
MH*"@H*"@J:FIKJZNIJ:FJZNKJ*BHJ:FIJZNKI*2DIZ>GK*RLI:6EIZ>GK:VM
MJZNKJZNKL+"PJ*BHJ*BHHZ.CHZ.CK*RLK*RLH:&AE965DI*2DI*2@("`;FYN
M8&!@4%!08&!@<'!PC8V-EY>7G9V=GY^?D9&1D9&1G)R<H*"@HZ.CGY^?HZ.C
MI*2DJJJJI*2DHZ.CHZ.CH:&AHJ*BJ*BHJZNKI:6EJ:FIJ:FII*2DJ:FIHZ.C
MG)R<JZNKJ*BHH:&AJJJJI:6EGIZ>IZ>GIZ>GIZ>GH:&AJ:FIJZNKJ:FIHZ.C
MIJ:FJ:FII:6EH*"@GY^?I:6EHZ.CHZ.CH:&AHZ.CJ:FIIJ:FI:6EK:VMF)B8
M\/#P_____O[^________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________[^_OF9F9?'Q\GIZ>G)R<EI:6
MH*"@I:6EHJ*BH*"@I:6EI:6EGIZ>G9V=GY^?IZ>GKJZNH:&AEY>7@H*"HJ*B
ML+"PI*2DCX^/C(R,E)24JJJJIZ>GJJJJIZ>GH*"@I:6EH:&AK*RLGIZ>G)R<
MHZ.CIZ>GJ*BHJ:FIIJ:FIZ>GJ:FII:6EIZ>GKZ^OM+2TN;FYN[N[JJJJHZ.C
ML+"PJJJJK*RLIJ:FDY.3AX>'=W=W:&AH.CHZ+R\O.#@X2TM+4E)24E)26EI:
M>WM[E)24G)R<FIJ:FIJ:I:6EHZ.CIJ:FI*2DJ*BHH:&AI*2DI*2DJ:FII:6E
MH*"@IJ:FI*2DHJ*BIJ:FI:6EJJJJJZNKK*RLJ*BHHZ.CIZ>GJJJJJ*BHJJJJ
MJZNKJ:FIJ:FIIJ:FK*RLHJ*BI*2DIZ>GKJZNIZ>GH:&AIJ:FIZ>GH:&AHJ*B
MHZ.CGIZ>H*"@GY^?H*"@I:6EHZ.CI*2DIJ:FFIJ:[.SL________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________\/#PH*"@A(2$GY^?H:&AHJ*BEY>7HJ*BIZ>GI*2DL+"P
MJ:FIH:&AHJ*BN+BXL;&QEY>7L;&QI:6EBHJ*D)"0J:FILK*RGIZ>DI*2E965
MHJ*BJZNKJ*BHIZ>GH:&AJZNKJ*BHHJ*BHJ*BH:&AIJ:FH:&AJ:FIJ*BHI*2D
MHJ*BK:VMJ*BHHZ.CHZ.CIZ>GIJ:FP,#`O;V]KJZNK*RLKJZNIZ>GGIZ>F9F9
M5U=7'!P<`P,#65E9IZ>GVMK:^/CX]O;V[.SLL;&Q:FIJ:VMKEY>7G9V=FYN;
MHJ*BHJ*BI:6EK:VMKZ^OHZ.CI*2DI*2DK:VMH:&AG9V=J:FIJ:FIIJ:FJ*BH
MI*2DJ:FIKZ^OG9V=J:FIL+"PJJJJJJJJJ*BHHJ*BIJ:FK:VMJ:FII*2DJ:FI
MHZ.CHZ.CJ*BHKJZNK*RLH:&AGY^?HZ.CHZ.CI*2DHJ*BHJ*BGIZ>I*2DH:&A
MF)B8GIZ>GIZ>IJ:FHZ.CY.3D____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________________[>WM
MG)R<@X.#FIJ:HJ*BIZ>GH*"@EY>7I:6EGY^?DY.3G9V=K:VML+"PG9V=D9&1
MH:&AGY^?D9&1G)R<K*RLF)B8F9F9G9V=A(2$F9F9KZ^OM+2TJJJJI:6EI:6E
MH:&AH:&AD)"0G)R<G)R<L+"PJ*BHGY^?HJ*BJ:FIFIJ:EY>7KJZNJZNKO+R\
ML[.SI:6EGIZ>JJJJN;FYKJZNI:6ED9&186%A)R<G(B(B=W=W[^_O________
M________________________KJZN>'AXFYN;GY^?IZ>GJJJJJ:FIJ:FIHJ*B
MI:6EJJJJKZ^OM;6UK:VMH:&AFYN;GY^?IZ>GLK*RJZNKIZ>GJ*BHJ*BHIJ:F
MI*2DJZNKIZ>GJ:FIIZ>GI*2DI:6EIZ>GI*2DI:6EIZ>GK*RLJJJJJ:FIHZ.C
MIJ:FI*2DH*"@GIZ>I:6EH*"@JJJJIZ>GJ*BHK:VMHZ.CE)24J*BHKZ^OFIJ:
MV-C8________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________Z^OKFYN;B8F)HJ*BH*"@GIZ>
MGY^?FIJ:G)R<IZ>GH*"@I*2DJZNKD9&1D)"0HZ.CK:VMEI:6CX^/G)R<N[N[
MIZ>GJ*BHJZNK@H*"D)"0HJ*BJJJJK:VMJZNKJ:FIFYN;HJ*BIZ>GJZNKHZ.C
MG9V=KZ^OKZ^OJZNKK:VML+"PK:VMJ*BHJZNKK:VMKZ^OOKZ^I:6EE)24I*2D
MN+BXD9&16%A8(B(B-S<WL;&Q_________/S\_/S\_/S\_O[^^_O[^_O[_/S\
M____ZNKJG9V=D)"0GIZ>HJ*BFYN;I*2DJ*BHI*2DI:6EI:6EHZ.CJJJJJZNK
MI:6EH*"@I:6EJ:FIJZNKIJ:FJ*BHIZ>GI:6EJ*BHLK*RK:VMJ*BHJ*BHJ*BH
MKJZNK*RLJJJJJ*BHIJ:FHZ.CIZ>GJ:FIH:&AHJ*BI*2DIZ>GI:6EH:&AIZ>G
MJ*BHIJ:FJ:FII:6EIJ:FJ:FIIZ>GI:6EJJJJG9V=U=75________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________Z.CHE)24@H*"G)R<H*"@I*2DH:&AE965GIZ>J*BHGY^?
MF9F9D)"0DY.3IJ:FJJJJL+"PHJ*BCX^/G)R<PL+"N;FYK:VMK*RL@X.#C(R,
MGIZ>IJ:FJJJJKJZNJJJJI:6EH:&AG9V=HZ.CJ*BHHJ*BHZ.CJJJJKJZNK:VM
ML+"PL[.SLK*RM[>WM;6UM;6ULK*RL+"PJ:FIJJJJI:6E7EY>'Q\?2TM+T-#0
M_________?W]_O[^_?W]_?W]_?W]_O[^_?W]_O[^_O[^____T='1BXN+E965
MH*"@H:&AIJ:FIJ:FIZ>GHJ*BI:6EJ*BHJ*BHI:6EIJ:FI:6EJ*BHKZ^OL+"P
MI:6EJJJJIZ>GIZ>GJ:FIK*RLIJ:FJJJJKJZNJ*BHK*RLK:VMJ*BHJ:FIK:VM
MHZ.CI:6EH*"@H:&AH:&AGY^?I*2DHZ.CJ:FIJJJJI:6EH:&AIZ>GIJ:FI:6E
MJ:FII:6EJ:FIK:VMHZ.CS\_/____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________________Y.3D
MD)"0BHJ*H*"@FYN;E965H:&AI*2DG)R<H*"@G)R<EI:6EY>7IJ:FJZNKJJJJ
MKJZNH:&ACHZ.G)R<L[.SK:VMHZ.CF9F9BXN+D)"0J:FIJ:FIJ:FIJ:FIHZ.C
MIZ>GIZ>GH*"@IZ>GIZ>GL+"PFYN;HJ*BJ:FIHZ.CI*2DJZNKM+2TM[>WM+2T
MJ*BHGIZ>PL+"PL+"L+"P='1T*BHJ45%1[.SL_____?W]^_O[_O[^________
M_____________________?W]____\_/SL+"PEI:6GIZ>IJ:FGY^?I:6EL+"P
MI*2DIZ>GJZNKK:VMJ:FIJ*BHJ:FIKJZNM+2TKZ^OK:VMJ*BHLK*RKJZNK:VM
MK*RLG9V=J:FIMK:VJ:FIJJJJK:VMIJ:FHZ.CG9V=I*2DIJ:FGY^?GY^?H*"@
MHJ*BI*2DI:6EIZ>GJ:FIIJ:FI*2DI:6EK:VMJ:FII*2DH*"@I*2DK*RLHJ*B
MS<W-________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________X^/CD)"0BXN+GIZ>GY^?EI:6
MG)R<I:6EHJ*BGY^?HJ*BJ*BHJ:FIH*"@GY^?JZNKK:VMF9F9C8V-FIJ:JZNK
MHZ.CIZ>GDI*2CHZ.E965J:FIJZNKL+"PK*RLJ:FIHJ*BI:6EI*2DKZ^OJ:FI
MIZ>GI:6EJJJJHJ*BH:&AJJJJJJJJL;&QM[>WKZ^OJ*BHIJ:FK*RLM;6UKJZN
M2DI*,#`PK:VM_____?W]_O[^_O[^________________________________
M_?W]_O[^____QL;&G9V=I*2DHZ.CHJ*BHZ.CJ*BHJ:FII:6EI:6EJJJJJ*BH
MJ*BHI:6EI:6EJ*BHJZNKL[.SK:VMK*RLL[.SK*RLK*RLHZ.CHJ*BJZNKK:VM
MI*2DA(2$9F9F5E963T]/8&!@AH:&GIZ>G9V=GY^?H:&AHJ*BH:&AHJ*BH*"@
MHJ*BJJJJIJ:FJZNKJJJJHZ.CJZNKJJJJJ*BHJ*BHR,C(________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________X.#@DI*2C(R,G9V=G9V=GIZ>H:&AI*2DF)B8GIZ>IZ>G
MI:6EHZ.CGY^?G9V=J*BHJZNKFIJ:A86%EY>7J*BHHZ.CJ:FIDI*2C(R,EI:6
MK*RLM+2TKZ^OK*RLK:VMHJ*BIJ:FJ*BHJ:FIJ*BHI:6EL+"PK*RLH:&AH*"@
MIJ:FKJZNLK*RLK*RJ*BHJJJJJZNKIZ>GKJZNG)R<+BXN<G)R]O;V_____?W]
M_O[^_____________________________________O[^_?W]____T-#0HJ*B
MI*2DI*2DJZNKI:6EHZ.CJ:FIHZ.CI*2DIJ:FI:6EIZ>GJJJJIJ:FIJ:FJJJJ
MN;FYL[.SH*"@J:FIJZNKJZNKIZ>GIJ:FHJ*BDY.3;FYN.CHZ+BXN/#P\5%14
M7EY>=75UBXN+FIJ:GY^?I*2DI:6EH*"@GIZ>G9V=H*"@HJ*BIJ:FIJ:FI:6E
MHZ.CK:VMK:VMJ*BHIZ>GP,#`____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________________WM[>
MD9&1C8V-G)R<F)B8HZ.CJ*BHGY^?E965FYN;IJ:FIZ>GHJ*BHJ*BHZ.CI*2D
MHZ.CG)R<B(B(F)B8JJJJHZ.CHJ*BFIJ:FIJ:G9V=IZ>GL[.SJ*BHIJ:FJZNK
MK:VMJZNKK*RLJ:FIIJ:FI*2DKJZNK:VMK*RLIZ>GIZ>GL[.SL;&QKZ^OLK*R
MK:VMK:VMJJJJK:VMAH:&/3T]O[^_________________________________
M_____________________O[^________SL[.H*"@I:6EJ*BHKZ^OJZNKHJ*B
MI*2DIJ:FIJ:FIJ:FIZ>GJJJJJJJJIZ>GJ*BHL+"PL[.SKJZNI:6EGY^?IJ:F
MK*RLK*RLJ:FIAX>'1$1$(R,C2$A(BHJ*P\/#[N[N\_/SUM;6GY^?DY.3GY^?
MH*"@I:6EIJ:FI*2DHZ.CHZ.CH*"@I*2DIJ:FIJ:FH:&AHZ.CIJ:FKJZNJ*BH
MN[N[________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________W=W=C(R,C8V-GY^?G)R<GY^?
MHZ.CHZ.CFYN;I*2DIZ>GHZ.CJ:FIJZNKJ*BHIZ>GHJ*BGIZ>G)R<G)R<H:&A
MIZ>GI*2DI:6EI:6EJ*BHIJ:FIZ>GI*2DI*2DJ*BHK:VMJ:FIJZNKJ:FIIZ>G
MIZ>GKZ^OL[.SM+2TJZNKKZ^OKZ^OK*RLJ*BHNKJZLK*RJ:FIJJJJK*RL@("`
M6EI:XN+B____________________________________________________
M_?W]_O[^____Q<7%GIZ>IZ>GIJ:FJZNKKJZNI*2DGIZ>H:&AK*RLJZNKKJZN
MK:VMI:6EIJ:FK*RLL+"PK:VMK:VMK:VMI*2DI:6EIJ:FJJJJFYN;45%1("`@
M<G)RR\O+]/3T________________Z>GIG)R<F)B8G9V=HJ*BJ*BHI:6EI*2D
MIJ:FIZ>GHZ.CI:6EH:&AGIZ>G9V=HJ*BK*RLK*RLN+BX_O[^____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________W-S<BHJ*B(B(H:&AH*"@G9V=GY^?HZ.CI*2DH:&AH*"@
MIZ>GJ:FIJJJJJZNKIZ>GI:6EIZ>GI:6EIJ:FIJ:FGY^?GY^?IJ:FIJ:FJZNK
MIZ>GH:&AI:6EHJ*BJ*BHJ:FIIZ>GJZNKJZNKIZ>GJ*BHKJZNLK*RM;6UKJZN
MK:VMJ*BHJ*BHJ:FIIZ>GJJJJK*RLJ:FIKZ^O?7U]=G9V^/CX____________
M_________________________________O[^_____O[^____\/#PL+"PGY^?
MJ*BHIZ>GKJZNJ*BHK:VMJ:FIJZNKKJZNJZNKJZNKL[.SL;&QKZ^OL+"PK:VM
MIZ>GI*2DK:VMI:6EGY^?HZ.CJ*BH>GIZ*RLK:VMKY>7E_________?W]_?W]
M_O[^_O[^_?W]L;&QE965HJ*BH:&AHZ.CI*2DJ*BHJZNKJ:FIIJ:FJZNKI*2D
MIJ:FH*"@GIZ>J:FIK*RLL+"P^OKZ________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________________V]O;
MBXN+A86%FYN;GY^?FYN;GY^?HJ*BHJ*BH*"@H*"@J:FIJJJJI:6EJ*BHI:6E
MI:6EIJ:FHJ*BIZ>GIJ:FFIJ:F)B8G9V=HZ.CJJJJI:6EFYN;HZ.CHJ*BI:6E
MJJJJIJ:FI:6EK:VMJZNKJJJJJJJJK:VMLK*RL;&QKJZNIZ>GIJ:FI:6EH:&A
MHJ*BI:6EIZ>GLK*R@X.#BXN+____________________________________
M_________O[^_/S\_O[^_?W]____W=W=HZ.CH:&AIJ:FIJ:FJ*BHGY^?I:6E
MK*RLL[.SL;&QJJJJI*2DJZNKL[.SL;&QJZNKJ:FIHZ.CIJ:FJZNKIZ>GHZ.C
MHZ.CHJ*B9&1D/CX^O;V]_____/S\_?W]_?W]_/S\_O[^_?W]^_O[K*RLE965
MHZ.CH:&AI:6EI:6EHZ.CIJ:FI:6EIZ>GK:VMIJ:FIJ:FH:&AFYN;HJ*BJJJJ
MIJ:F\_/S____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________U]?7AH:&B8F)F9F9G9V=G)R<
MG)R<G)R<H:&AI*2DHJ*BHJ*BJ*BHHZ.CGIZ>HJ*BHZ.CHJ*BIJ:FIZ>GH*"@
MH*"@GY^?GIZ>H*"@IZ>GHZ.CGY^?HJ*BIJ:FH:&AIZ>GI:6EM;6UKJZNJ*BH
MJ:FIJ:FIL+"PKJZNKZ^OK*RLIZ>GK:VMKJZNI*2DGY^?F)B8JZNKK:VMCHZ.
MF)B8_____________________________________________/S\_/S\_/S\
M____]_?WO[^_H*"@HJ*BGY^?HJ*BI*2DHZ.CG)R<K:VMKJZNJZNKJ:FII:6E
MHJ*BJJJJJ*BHI*2DIJ:FJ:FIJJJJI*2DI:6EHZ.CI:6EJ*BH86%A9V=GY.3D
M_____?W]_________/S\^_O[____^/CXH:&AF)B8I:6EIZ>GKJZNK:VMHJ*B
MGIZ>GIZ>I*2DIJ:FHZ.CI:6EGIZ>H*"@HZ.CKZ^OH:&A\/#P____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________UM;6AX>'B8F)GY^?G)R<G9V=H*"@E)24G)R<HZ.CI:6E
MHJ*BH:&AHJ*BH:&AGY^?GIZ>GIZ>G9V=G9V=GY^?J:FIIZ>GH:&AG9V=HJ*B
MJJJJIZ>GI*2DI*2DI:6EHJ*BHJ*BL;&QL[.SKJZNIJ:FIZ>GKJZNK:VMK*RL
ML+"PKZ^OJJJJJ:FII*2DJ:FIGY^?I:6EMK:VK:VMFIJ:_O[^____________
M_________________________________/S\_O[^____S,S,DY.3H:&AJ*BH
MIJ:FHJ*BJZNKIZ>GIZ>GFYN;JJJJK:VMIZ>GK:VMJ:FIJ*BHIZ>GI*2DJ*BH
MH*"@HZ.CH:&AIJ:FJJJJJJJJJ:FI;FYNFIJ:_____?W]_/S\_________O[^
M_O[^____W=W=EI:6H:&AI:6EHJ*BGY^?GY^?H:&AGY^?GY^?GIZ>I:6EG9V=
MG)R<G)R<GIZ>F)B8K:VMEY>7Z^OK________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________________T]/3
MA(2$BXN+GY^?HJ*BGY^?GY^?EY>7FYN;HZ.CHJ*BHZ.CGIZ>H*"@HZ.CHJ*B
MHZ.CI:6EH*"@GY^?FYN;J:FIJJJJHZ.CI:6EI*2DJ*BHHJ*BHZ.CI*2DH*"@
MJ:FIJZNKGY^?LK*RM;6UK:VMJJJJJ:FIJ*BHJJJJL[.SL+"PJ:FIIJ:FJ:FI
MIZ>GHJ*BHZ.CKZ^OOKZ^K*RL]/3T________________________________
M_?W]_____/S\________V]O;HZ.CGY^?IZ>GI*2DHJ*BHZ.CKZ^OJJJJK:VM
MH:&AGIZ>J:FIK:VMJZNKIZ>GIZ>GJ*BHJ*BHHZ.CH*"@H:&AF)B8H:&AHJ*B
MJZNKLK*R@("`JZNK_____O[^_/S\_?W]_O[^_?W]________KJZNEY>7HJ*B
MI:6EHJ*BG)R<FYN;H*"@J*BHI*2DEY>7GY^?I:6EH:&AF)B8EI:6DI*2EI:6
M:VMKY>7E____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________T='1A(2$B(B(F9F9FIJ:HJ*B
MH*"@HJ*BG)R<G)R<HJ*BH*"@F)B8G9V=H*"@H*"@I:6EI:6EHZ.CH*"@GIZ>
MF9F9HJ*BI*2DG9V=HZ.CI*2DHJ*BIZ>GJZNKIZ>GKJZNM[>WHJ*BHJ*BLK*R
MQ<7%JZNKGIZ>K*RLJJJJIJ:FJJJJK:VMK:VMJ*BHHZ.CJ:FIIJ:FK*RLO+R\
MR,C(X.#@____^_O[_/S\_____?W]_?W]_?W]_O[^_/S\____________X.#@
MGIZ>GY^?IJ:FJ:FIHZ.CI*2DJ:FII*2DJZNKJ*BHIZ>GFIJ:F)B8I:6EI*2D
MHJ*BH:&AI:6EJ*BHG)R<HZ.CHZ.CEI:6I:6EJ*BHJ*BHN[N[G)R<O;V]____
M_____O[^_/S\_O[^________W-S<C8V-FYN;GY^?G9V=HJ*BJ*BHI*2DHJ*B
MGY^?IJ:FI*2DG)R<J*BHHZ.CH*"@E965CX^/@X.#34U-X^/C____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________R,C(@8&!DI*2IZ>GGIZ>EY>7DY.3IZ>GIJ:FIZ>GH:&A
MGY^?HJ*BHZ.CI*2DI*2DHJ*BH*"@H:&AH*"@L+"PGY^?FIJ:I:6EKJZNHZ.C
MGIZ>GIZ>J:FIIJ:FHZ.CJZNKKJZNLK*RJ*BHJZNKN[N[Q<7%IJ:FG)R<IJ:F
MH:&AIJ:FJJJJJZNKJZNKJ*BHKJZNL;&QI:6EKJZNV=G9[N[N^_O[________
M_O[^_O[^_O[^_O[^_O[^________^_O[NKJZ?GY^FYN;J:FIJ:FII:6EGY^?
MI:6EI:6EGY^?IJ:FIJ:FIJ:FJ:FIHJ*BGY^?HZ.CHJ*BH:&AI:6EI:6EI*2D
MHJ*BGY^?H*"@FYN;F9F9H*"@JJJJO+R\QL;&W-S<^_O[________________
MWM[>DY.3HZ.CH:&AHJ*BFYN;F9F9HZ.CI*2DH:&AFIJ:G)R<IZ>GH:&AF9F9
MG9V=GIZ>F)B8BXN+*RLKUM;6____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________O[^R,C(
M>WM[B(B(GY^?G)R<GY^?EI:6GIZ>G)R<GY^?H*"@I*2DI*2DI*2DHJ*BI*2D
MI*2DGIZ>HZ.CIZ>GHJ*BI*2DHJ*BHJ*BIJ:FI*2DIZ>GI*2DH:&AI*2DIZ>G
MKJZNJ:FIL+"PK:VMGY^?GY^?M+2TNKJZK:VMHZ.CI*2DIZ>GIJ:FI*2DIZ>G
MJJJJK*RLGY^?HJ*BI:6EJJJJSL[.[.SL^OKZ_O[^_____O[^_____O[^_O[^
M\?'QUM;6KJZNFYN;HZ.CFYN;GY^?G)R<G)R<I*2DI:6EGIZ>HJ*BI*2DHJ*B
MFIJ:GIZ>HZ.CGIZ>FYN;GY^?FYN;GIZ>GY^?G9V=FYN;G9V=I:6EJ*BHJZNK
MIJ:FI*2DK:VMP<'!PL+"N;FYN;FYO;V]LK*RJJJJG9V=H*"@IZ>GHZ.CHJ*B
MHJ*BI*2DIJ:FHZ.CG9V=H:&AH*"@D9&1B8F)GIZ>H:&AD9&1BHJ*2DI**BHJ
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________?W]Q,3$?'Q\A(2$FIJ:F)B8F9F9
MF9F9HJ*BGY^?GIZ>HZ.CI*2DHJ*BHZ.CI:6EHZ.CHZ.CIJ:FHJ*BI*2DFYN;
MI*2DJ*BHHZ.CHZ.CGY^?IZ>GJ*BHGIZ>IZ>GK*RLK*RLJJJJJJJJK*RLLK*R
MHJ*BH*"@K:VMJJJJH*"@H*"@HJ*BGY^?G9V=HJ*BJ:FIHJ*BJ*BHI*2DG9V=
MG)R<JJJJO[^_X>'A[N[NX>'AV]O;V]O;T-#0N[N[JJJJGY^?HJ*BJJJJJ*BH
MG)R<EY>7FYN;F9F9G)R<H*"@F9F9GIZ>HJ*BIZ>GF)B8E965F)B8EY>7E965
MEY>7E)24G9V=FIJ:FIJ:H*"@F9F9J*BHI:6EIZ>GK*RLI:6EG)R<GY^?KJZN
MKJZNHJ*BIJ:FHJ*BG9V=HJ*BG9V=I*2DI:6EKJZNKZ^OIJ:FI*2DJ*BHI:6E
MGIZ>GIZ>GIZ>G)R<IZ>GH*"@@8&!6%A8(B(B@8&!_____/S\____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________?W]Q,3$?'Q\@("`F)B8H:&AFYN;GY^?HJ*BI*2DIJ:FH:&A
MI:6EHJ*BH*"@HZ.CHJ*BH:&AIJ:FH*"@H:&AG9V=I*2DI:6EI*2DIJ:FH*"@
MGIZ>JZNKK:VMJ:FIJZNKKZ^OKJZNJJJJIZ>GIZ>GKJZNJJJJG9V=H:&AI*2D
MJ*BHHJ*BG)R<H*"@K*RLH*"@IZ>GJJJJI*2DGY^?GIZ>F9F9HJ*BJZNKL;&Q
MNKJZNKJZL;&QL+"PJ*BHH:&AJ*BHIJ:FJ*BHI*2DHZ.CGY^?HZ.CHJ*BG)R<
MG9V=G9V=G9V=E965FYN;GY^?H:&AFYN;GY^?GIZ>GY^?G)R<EI:6E)24EY>7
MG9V=EY>7HZ.CIJ:FI:6EIZ>GI:6EH*"@H:&AI*2DIJ:FJZNKK*RLJ*BHHJ*B
MI:6EI:6EHJ*BIJ:FK*RLK:VMJ*BHHJ*BGIZ>G)R<GIZ>G)R<H:&AHJ*BFIJ:
MC8V-7U]?(2$A<G)R_____/S\_?W]________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________?W]PL+"
M?GY^C(R,GIZ>H*"@EI:6G)R<I*2DHJ*BI*2DGY^?HJ*BH:&AH:&AHZ.CH:&A
MHJ*BJJJJHJ*BHZ.CI*2DI:6EH:&AHJ*BIJ:FIJ:FI*2DJ:FIJZNKK*RLL[.S
MJJJJK*RLIZ>GJ:FIHZ.CHZ.CJ:FIHZ.CGIZ>H:&AI*2DI:6EI*2DH:&AH:&A
MH*"@G9V=H*"@HJ*BIJ:FH*"@GIZ>IJ:FIZ>GI*2DI*2DI:6EI:6EIZ>GI:6E
MIZ>GJ:FII:6EJ:FIHJ*BGIZ>H:&AGIZ>G)R<DY.3EY>7IJ:FH:&AE)24HJ*B
MF)B8F9F9FYN;EY>7EI:6FYN;HJ*BGY^?FIJ:G)R<H*"@H*"@HJ*BHJ*BJJJJ
MJZNKIJ:FI:6EIJ:FJ:FIJJJJJJJJJZNKIJ:FH:&AGY^?IJ:FIJ:FHJ*BGY^?
MH:&AHJ*BH:&AH*"@G9V=GY^?FYN;G)R<G)R<F9F9<7%Q*2DI4E)2X^/C____
M_/S\_O[^____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________/S\O[^_>7EYA(2$GIZ>HJ*BF)B8
MF9F9FYN;G9V=HJ*BGY^?H:&AHJ*BH*"@HZ.CHZ.CHJ*BIZ>GHZ.CGY^?E)24
M?7U];6UM965E=G9VD)"0GY^?JJJJKJZNKJZNK*RLL+"PK*RLHZ.CIJ:FHJ*B
MIZ>GIZ>GIJ:FGY^?G9V=F9F9H*"@IZ>GI*2DGY^?GY^?EI:6F)B8GY^?J*BH
MGY^?G9V=G)R<H:&AHJ*BHZ.CHZ.CHJ*BH:&AHJ*BHJ*BIZ>GHJ*BIJ:FHZ.C
MG)R<HJ*BG9V=G9V=FIJ:F)B8H:&AIZ>GG9V=EY>7DI*2C(R,G)R<GIZ>G)R<
MGIZ>H:&AH:&AH:&AGY^?G)R<GY^?J:FIIJ:FJ:FIJ*BHJ*BHIZ>GIZ>GIZ>G
MI:6EI:6EIZ>GIZ>GHZ.CIJ:FIJ:FHJ*BEI:6DI*2EI:6FIJ:GIZ>HJ*BGY^?
MGIZ>DY.3E)24EI:6A(2$-34U.3DYR<G)_____?W]_/S\_?W]____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________/S\O[^_>WM[@("`E)24H*"@H:&AG9V=G9V=GIZ>G)R<G9V=
MHJ*BHJ*BH:&AGY^?H:&AH:&AGY^?GIZ>>GIZ2DI*+2TM,#`P0T-#8&!@=G9V
MBHJ*H*"@J:FIIZ>GH*"@KJZNL;&QHJ*BH*"@HZ.CI*2DIJ:FI*2DH*"@G)R<
MEI:6FIJ:H*"@I:6EJ*BHI:6EHJ*BGIZ>GIZ>GIZ>FYN;G9V=GIZ>HJ*BH*"@
MI*2DH:&AHJ*BI*2DI:6EHJ*BJZNKJJJJHJ*BHZ.CG)R<FIJ:EY>7G9V=IZ>G
MI:6EF)B8F)B8HJ*BHJ*BH*"@G)R<HZ.CGY^?HJ*BIZ>GJ:FIJJJJJZNKJ:FI
MG)R<GIZ>KJZNJZNKIZ>GHZ.CI:6EJ*BHIZ>GI:6EHJ*BH*"@H*"@HZ.CHJ*B
MH:&AHJ*BH:&AFYN;E965DI*2CX^/E)24FYN;FYN;G9V=EI:6D9&1C8V-145%
M)R<GO;V]_____O[^_?W]_?W]_O[^________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________^_O[OKZ^
M?GY^@8&!CHZ.E)24FYN;G9V=H*"@G9V=FIJ:FYN;HJ*BHZ.CH*"@GY^?HJ*B
MH*"@IZ>G='1T,S,S%1456EI:HZ.CRLK*U=75R\O+JJJJD)"0GY^?G)R<FYN;
MEY>7GIZ>IZ>GGY^?J:FIHJ*BG9V=HJ*BG9V=GIZ>H*"@FIJ:G)R<FYN;I:6E
MJ*BHHJ*BH*"@GY^?GIZ>FIJ:GY^?IJ:FI*2DGY^?I*2DIJ:FI:6EF9F9H*"@
MKJZNL+"PI*2DH*"@HJ*BGIZ>G9V=G)R<G9V=I:6EI:6EGY^?H*"@G9V=I:6E
MH*"@H:&AI*2DIZ>GJ*BHJ:FIKJZNL+"PKJZNK:VMIZ>GGY^?HJ*BIZ>GI:6E
MH:&AGY^?IZ>GI*2DG)R<H*"@GIZ>F9F9EI:6G9V=E965FIJ:F9F9G)R<FYN;
MFIJ:EY>7E)24D9&1D9&1DI*2CHZ.D)"06UM;$!`0DY.3_________O[^_?W]
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________^_O[O+R\>WM[BHJ*FIJ:F)B8G)R<
MGIZ>GIZ>G)R<FIJ:GIZ>GIZ>H*"@H*"@G)R<H:&AJ*BH@8&!+"PL,S,SF)B8
MW-S<_?W]____________Z.CHJ*BHF9F9HJ*BG)R<G9V=FYN;F9F9G)R<I:6E
MHZ.CGIZ>GIZ>FYN;FIJ:H:&AGIZ>GIZ>GIZ>HJ*BJZNKJ:FIH:&AI*2DHJ*B
MGY^?GIZ>GY^?H:&AH:&AHZ.CGY^?I:6EI:6EFIJ:FYN;JJJJHZ.CH:&AGY^?
MGIZ>GY^?HJ*BIZ>GI:6EH:&AGY^?K*RLIJ:FGIZ>I:6EIZ>GI:6EIJ:FJ:FI
MJJJJKJZNJJJJH:&AI:6EI*2DHJ*BG9V=GY^?HZ.CGY^?FYN;FYN;GY^?FIJ:
ME)24DY.3EI:6DY.3F9F9E965EY>7CHZ.DY.3DI*2BXN+A(2$?7U]?W]_@H*"
M?W]_D9&1;6UM&AH:=G9V^?GY____^_O[_/S\_O[^____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________^OKZN;FY>7EYAX>'G9V=GIZ>G9V=G)R<G)R<GY^?FYN;GY^?
MG)R<GIZ>G9V=FIJ:H:&AGY^?2TM+,#`PL+"P_____________O[^_/S\____
M_?W]R,C(EI:6HZ.CI*2DHJ*BHJ*BEI:6G9V=FIJ:GY^?GY^?FYN;FYN;GY^?
MHZ.CHJ*BIJ:FK*RLGIZ>F)B8HZ.CI*2DH:&AH:&AHJ*BG9V=EI:6FIJ:G)R<
MHZ.CG)R<HJ*BIZ>GH:&AFIJ:G9V=H*"@IZ>GJ:FIIJ:FHJ*BIZ>GJ:FIIZ>G
MI*2DI:6EJJJJHZ.CI*2DHJ*BI:6EJ*BHHZ.CI:6EJJJJJZNKHZ.CG)R<H*"@
MI*2DHZ.CGY^?G9V=G)R<FIJ:F9F9EI:6FIJ:GIZ>EI:6E)24EY>7F)B8E)24
MD)"0C8V-@("`@X.#?GY^@H*"AX>'CX^/I*2DM;6ULK*RM;6U/S\_1T=']?7U
M_____?W]_/S\_/S\_O[^________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________^/CXL[.S
M>7EY@X.#E)24FYN;G9V=FYN;F9F9FYN;G)R<FYN;F9F9FYN;F9F9E965H:&A
MC(R,)24EF9F9_?W]_________O[^_O[^_?W]_?W]____V=G9FYN;FYN;GIZ>
MGY^?G)R<G9V=FYN;F)B8GIZ>H*"@GY^?HZ.CJ*BHJZNKHJ*BGY^?I*2DG9V=
MA(2$AH:&JJJJH:&AG9V=GIZ>G9V=FYN;F)B8E)24DY.3F)B8I*2DI*2DJ:FI
MKZ^OHZ.CDY.3FYN;L+"PL+"PJ:FIJ*BHJ*BHJ*BHIZ>GIZ>GI:6EG)R<GIZ>
MGIZ>FYN;IJ:FJ:FIH*"@FYN;I*2DH:&AH:&AFYN;G)R<F9F9E965EI:6F9F9
MGIZ>FIJ:F)B8E965EI:6DI*2D9&1BHJ*@8&!=W=W;&QL=75UBXN+JZNKQ\?'
MU]?7S<W-M[>WE965<W-S3DY.,S,S*RLKU=75_____?W]_____?W]_O[^_?W]
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________^/CXL[.S?'Q\CX^/F9F9G)R<GIZ>
MGY^?G)R<F9F9F9F9FIJ:FIJ:G)R<GY^?G9V=HZ.C?W]_;6UMY>7E____^_O[
M_/S\_____________O[^^_O[R,C(F)B8F9F9GIZ>FIJ:FIJ:F)B8HZ.CI:6E
MGY^?H:&AH:&AH*"@H*"@FIJ:EI:6DI*2EI:6J:FIG9V=D)"0GY^?H:&AH*"@
MHZ.CH*"@H:&AHZ.CHJ*BGY^?H:&AHJ*BGY^?K*RLJZNKJJJJI:6EG)R<FIJ:
MJ:FIKZ^OK*RLIJ:FH:&AJ:FIIJ:FH:&AGY^?H*"@HJ*BF)B8CHZ.E965FIJ:
MF9F9FIJ:G9V=FYN;EY>7E965FIJ:FIJ:AH:&D9&1C(R,@X.#@8&!>'AX>'AX
M?GY^?W]_C8V-DY.3PL+"RLK*M;6UPL+"C(R,8&!@2$A(/S\_145%5E96=G9V
MHJ*BQ,3$Y>7E____^_O[_O[^_____O[^_____O[^____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________]_?WLK*R?'Q\C8V-FIJ:F)B8FIJ:FYN;EI:6GY^?GY^?F9F9
MF)B8G9V=HJ*BHZ.CH:&A?W]_H:&A]?7U_?W]_/S\^_O[________________
M[>WMI:6EE)24G)R<GIZ>GIZ>FIJ:H:&AJ*BHIJ:FE)24GIZ>HJ*BFYN;FYN;
ME965G)R<G9V=FYN;I:6EHJ*BI*2DI:6EHJ*BHZ.CJZNKJ:FIJ:FIJ:FIJZNK
MGIZ>H*"@L;&QK*RLH:&AGIZ>J*BHJJJJI*2DG)R<G9V=I*2DIJ:FHZ.CH:&A
MGY^?I*2DIJ:FH*"@FYN;F9F9F9F9F9F9EY>7EI:6EI:6FYN;FIJ:F9F9EI:6
MD)"0D)"0AX>'>GIZ<'!P='1T>WM[E)24I*2DL;&QOKZ^N+BXM[>WF9F9<G)R
M45%1.CHZ/S\_4%!0;FYNE)24N+BXV=G9\O+R^_O[_____________/S\_/S\
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________]/3TL;&Q
M@("`BXN+F)B8GIZ>EI:6D9&1CHZ.H:&AGIZ>F)B8F9F9F)B8F)B8FIJ:HZ.C
MC(R,L+"P]O;V_O[^_O[^^_O[_O[^_O[^_O[^____VMK:CHZ.FYN;GY^?H*"@
MGY^?G9V=GY^?F9F9F9F9FIJ:G)R<G)R<G)R<DI*2F)B8HJ*BIJ:FI*2DIJ:F
MJ:FIJJJJJJJJK*RLK*RLJZNKKZ^OK*RLI:6EJ:FIH:&AF9F9IZ>GJ:FIHJ*B
MG)R<HZ.CJJJJK*RLJ:FIJ*BHGIZ>FYN;FYN;G)R<EY>7FYN;H:&AGY^?F9F9
MGY^?GIZ>HZ.CFIJ:EI:6D9&1CHZ.B8F)@8&!;6UM65E9<G)R>GIZDI*2TM+2
M]O;V\?'QQ<7%G9V==W=W2$A('AX>$!`0&AH:5E96E)24P<'!YN;F_/S\____
M_____________________O[^_?W]_/S\_/S\_/S\____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________\_/SJJJJ?'Q\C(R,FIJ:GIZ>HZ.C
MGIZ>DY.3EY>7HJ*BHZ.CH*"@EY>7EI:6EI:6GIZ>GY^?KJZN\_/S_____O[^
M^_O[____________Q,3$BHJ*GIZ>FYN;F9F9G)R<HZ.CHJ*BGIZ>FIJ:H*"@
MIJ:FIJ:FGY^?HZ.CIZ>GHZ.CI*2DJZNKK*RLJJJJK:VMIZ>GHJ*BHJ*BIJ:F
MG)R<GIZ>HZ.CJ*BHH*"@HJ*BI*2DDI*2H*"@IJ:FH*"@F)B8EY>7G)R<FYN;
MF)B8F9F9G)R<FYN;E965G)R<FIJ:EI:6EY>7EY>7@("`@X.#@H*"?W]_=75U
M=W=W>7EYAX>'F9F9O;V]X>'AU=75S<W-N[N[=W=W.#@X("`@(R,C/S\_;6UM
MI:6EZNKJ____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________\O+RIJ:F=G9VC(R,F)B8E965EY>7E965DI*2FYN;FYN;GY^?
MEI:6F)B8FIJ:G)R<H*"@HJ*BHZ.CHJ*BL;&QS<W-V=G9M;6UFIJ:DY.3GY^?
MG)R<GY^?H*"@IJ:FJ*BHIZ>GJ:FIJJJJI:6EIZ>GIZ>GI*2DIJ:FHZ.CIJ:F
MJ*BHJJJJI:6EG9V=JJJJJJJJI*2DGIZ>GIZ>GY^?HJ*BG)R<EI:6FIJ:F9F9
MFYN;G)R<FYN;FYN;GY^?FYN;F9F9FIJ:E)24D)"0AX>'B(B(C(R,A86%@8&!
M?GY^?GY^>'AX>7EY@("`K*RLQL;&N;FYKZ^OEI:6;FYN3T]//S\_1T='7U]?
MDI*2O[^_[.SL_____________________________?W]_/S\_/S\_____/S\
M_?W]________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________[^_OHZ.C
M>7EYA(2$D)"0G)R<EY>7F9F9EI:6DY.3F)B8FIJ:E)24E965FIJ:GY^?GY^?
MH:&AHZ.CG9V=GY^?F)B8CX^/EI:6G9V=J*BHIJ:FJJJJJJJJIJ:FIJ:FJ*BH
MI*2DI*2DIZ>GI*2DHZ.CHZ.CHJ*BIZ>GI:6EHZ.CIJ:FIZ>GI:6EI*2DI*2D
MHZ.CGIZ>F9F9F9F9DY.3G)R<GY^?EY>7AX>'CHZ.G)R<G)R<G9V=E965C8V-
MBXN+@("`AX>'B8F)AX>'@H*"BXN+DI*2CHZ.DI*2J:FIO;V]J:FIEY>7DY.3
M='1T75U=45%18&!@?7U]IJ:FT-#0_____________________________O[^
M_____O[^_O[^_____O[^_O[^_________O[^_O[^____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________\/#PI:6E>WM[C(R,EI:6EY>7F)B8
MG)R<DI*2EY>7F9F9G)R<G9V=F9F9FYN;GY^?H:&AIJ:FJ:FII:6EI:6EIJ:F
MJZNKIJ:FGIZ>J*BHJ*BHIJ:FIZ>GI:6EI:6EI*2DI*2DHZ.CIJ:FI*2DHJ*B
MHJ*BHZ.CI*2DH*"@G9V=G9V=GY^?HJ*BH:&AFYN;G9V=G)R<DY.3F)B8D9&1
MDY.3EY>7F)B8C(R,@X.#A(2$AX>'AX>'@8&!@("`?GY^B(B(D9&1E965H*"@
MH:&AG9V=F9F9?GY^='1T>7EY<G)R;6UM<G)R?GY^KZ^OR,C(Y^?G^_O[____
M_____________O[^_O[^_?W]_?W]_?W]_?W]_?W]____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________[N[NGY^?@("`E965FIJ:F9F9EY>7FYN;D9&1E965G9V=G9V=
MH*"@H*"@H*"@H*"@I:6EJJJJJZNKK*RLJ*BHIZ>GJ:FIJZNKIZ>GK*RLIJ:F
MHZ.CHZ.CHZ.CHZ.CH:&AHZ.CHJ*BGY^?HZ.CHJ*BG)R<GY^?GY^?F9F9EI:6
MFIJ:EY>7DY.3F9F9FIJ:FYN;E)24CX^/BHJ*B8F)C(R,@8&!@H*"A86%B(B(
MAH:&BHJ*C(R,BHJ*BHJ*DY.3F9F9DY.3?GY^?W]_=75U;6UM;6UM;V]O?GY^
MC8V-IJ:FT='1Z.CH_/S\_________________O[^_/S\_?W]_/S\_O[^____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________\O+RJZNK
MB(B(FIJ:G9V=FIJ:GIZ>GY^?FYN;EY>7G)R<H*"@I*2DI*2DI*2DHZ.CI*2D
MIZ>GI*2DJ*BHI:6EIZ>GJ*BHJ:FIIJ:FJJJJK*RLJJJJH*"@GIZ>G9V=FYN;
MH:&AGY^?F)B8F)B8F9F9F9F9F)B8FIJ:G9V=G)R<F9F9D)"0A(2$@H*"@H*"
M@8&!?GY^BXN+@H*"@H*"B(B(B(B(D)"0HJ*BHJ*BD)"0C8V-@8&!;V]O:VMK
M=75U<'!P<7%Q<'!PAX>'GY^?O[^_WM[>]O;V________________________
M_?W]_?W]_?W]_/S\_?W]_?W]_?W]_O[^____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________?W]W]_?FIJ:@8&!F)B8H*"@G9V=
MG)R<HJ*BGY^?GIZ>FYN;H*"@HJ*BI:6EI*2DI*2DIJ:FH:&AH:&AI*2DIJ:F
MHZ.CHZ.CHJ*BH:&AH*"@GY^?G9V=FYN;EI:6EY>7H*"@G9V=EI:6F)B8CHZ.
MD)"0CX^/C(R,C(R,B(B(@H*"=G9V<G)R;FYN@X.#CHZ.I:6EL+"PL;&QGY^?
M?W]_>GIZ;6UM7U]?4E)25E96965E=75UB8F)GIZ>L;&QS<W-W-S<[.SL_?W]
M_________________________?W]_?W]_O[^_?W]_O[^_O[^_____O[^____
M_O[^________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________X.#@FYN;?7U]DI*2FIJ:FYN;GY^?H*"@GY^?G)R<
MFIJ:GIZ>H:&AI*2DHZ.CH:&AH*"@G9V=F9F9FYN;G9V=H*"@F9F9E965EI:6
MF)B8E)24EY>7FIJ:F)B8DY.3E965CHZ.AH:&?7U]?'Q\>'AX>'AXAH:&CX^/
MB(B(E)24F)B8GY^?I:6EEY>7BXN+9V=G8V-C5U=765E99V=G>WM[EY>7J:FI
MO+R\SL[.WM[>\?'Q_/S\________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________O[^_?W]
M____Z.CHGY^??7U]D)"0EY>7FYN;H*"@G)R<G9V=F)B8F)B8EI:6FIJ:G9V=
MFIJ:FIJ:FIJ:E)24E)24F9F9H:&AFIJ:E)24E)24E965D)"0CX^/C8V-AX>'
M>WM[?W]_?W]_>GIZB8F)B8F)E965F)B8H*"@E965?W]_<W-S9&1D8&!@6EI:
M86%A9F9F?'Q\D)"0IJ:FQ\?'VMK:[.SL____________________________
M_?W]_/S\_?W]_?W]_?W]_O[^____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________O[^_?W]_O[^____]O;VH:&A=75U
MCHZ.EI:6G)R<FYN;F)B8EY>7EI:6D9&1E965G9V=GY^?F)B8EY>7E965CX^/
MB8F)CX^/DY.3B(B(@8&!?'Q\='1T;6UM>'AX?GY^EI:6GIZ>J:FIDY.3DI*2
M:&AH7U]?145%-#0T,#`P.SL[65E9?W]_GIZ>OKZ^U]?7Y>7E\?'Q^/CX_O[^
M_____________________O[^_?W]_/S\_/S\_?W]_O[^_O[^_?W]_O[^_O[^
M_?W]________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________O[^_____?W]_____?W]LK*R=W=WAH:&C8V-C8V-EY>7
MFIJ:F9F9D9&1CHZ.D)"0D)"0CHZ.A(2$>'AX='1T=75U<7%Q<G)RAH:&AH:&
MEI:6H*"@J:FICX^/>7EY5%14/#P\-C8V*RLK,C(R1$1$9V=GCX^/OKZ^X.#@
MYN;F[>WM]?7U^_O[____________________________________________
M_____O[^_O[^_O[^_O[^_________O[^_________O[^________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____/S\^OKZ________NKJZ<W-S@H*"B(B(A(2$BHJ*C8V-@X.#>7EY<W-S
M<G)R>7EY?W]_D9&1C8V-H:&AIZ>G@X.#D)"0=W=W?7U]86%A2DI*,#`P*RLK
M45%1;6UMCHZ.L[.STM+2[N[N^_O[_O[^_________________O[^_O[^_/S\
M_O[^_________?W]____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________/S\_/S\_/S\____
M____MK:V5%14<7%Q>WM[:&AH;V]O?'Q\BHJ*JZNKHZ.CGIZ>GIZ>IZ>GB(B(
M8&!@0D)")B8F$!`0"`@(`P,#(R,C5U=7DI*2P<'!_/S\________________
M_________?W]_?W]_O[^_?W]_?W]_?W]_/S\_/S\_____________/S\____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________/S\_O[^____Y.3D=G9V<W-S
MH:&ADI*2A86%>7EY9&1D0$!`'Q\?$Q,3%!04)"0D0D)";&QLDI*2Q<7%]/3T
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________/S\_/S\________UM;6;6UM3DY..SL[,3$Q-S<W0D)"
M6EI:=G9VEY>7O+R\UM;6[N[N_____________________?W]_/S\_O[^_?W]
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_O[^_/S\_O[^____SL[.:FIJ;6UMEY>7N;FYV=G9]O;V________________
M_________?W]_O[^_/S\_/S\_?W]_/S\____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________O[^^_O[_?W]____
M_________________________________/S\_O[^_O[^_/S\_O[^_O[^^_O[
M_?W]_O[^_?W]________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________/S\_?W]_O[^_/S\_O[^_O[^_?W]_?W]^_O[
M_O[^_O[^_____O[^_________O[^_________O[^_____O[^_O[^________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_?W]_O[^________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
)____________



















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
        <int nm="BreakPoint" vl="1488" />
        <int nm="BreakPoint" vl="1402" />
        <int nm="BreakPoint" vl="1459" />
        <int nm="BreakPoint" vl="1441" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18969 catching invalid manufacturer definition" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="24" />
      <str nm="DATE" vl="5/16/2023 8:52:12 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15990: if company XML found dont load Content\General XMLs" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="23" />
      <str nm="DATE" vl="10/7/2022 10:47:40 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15990: Family written in &quot;Model&quot; of hardware; FamilyDescription is written in &quot;Description&quot; of hardware" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="22" />
      <str nm="DATE" vl="10/7/2022 9:53:54 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15990: tool now uses new xml structure similar with GenericHanger" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="21" />
      <str nm="DATE" vl="9/9/2022 4:42:21 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15990: change XML name to AngleBracketCatalog" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="20" />
      <str nm="DATE" vl="9/7/2022 2:17:17 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-14106 group assignment added" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="19" />
      <str nm="DATE" vl="1/10/2022 4:21:34 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-14106 display published for hsbMake and hsbShare" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="18" />
      <str nm="DATE" vl="12/21/2021 8:36:58 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13752: fix nr of hardwares" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="17" />
      <str nm="DATE" vl="12/14/2021 2:51:51 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-12683: improve report for the update of xml file" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="16" />
      <str nm="DATE" vl="11/12/2021 9:04:24 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-11990: support connection of two crossing beams on top of each other" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="15" />
      <str nm="DATE" vl="9/6/2021 11:25:03 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-11990: change type from &quot;T&quot; to &quot;O&quot; and allow Truss entities" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="14" />
      <str nm="DATE" vl="9/2/2021 11:04:00 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End