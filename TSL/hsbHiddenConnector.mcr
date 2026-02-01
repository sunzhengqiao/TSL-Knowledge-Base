#Version 8
#BeginDescription
#Versions:
Version 1.6 09.07.2025 HSB-24279: Add trigger "Show Tag" for baufritz , Author: Marsel Nakuci
Version 1.5 05.02.2025 HSB-23069: Fix bug at drill , Author: Marsel Nakuci
1.4 11/03/2024 HSB-21590: Add property for the fixtures, screws 
1.3 13.02.2023 HSB-17934: Initialize properties from xml only if they are not set in the properties 
1.2 08.07.2022 HSB-15937: Replace Mortise with house 
1.1 07.07.2022 HSB-15937: Expose xml parameters in properties 
1.0 14.06.2022 HSB-15731: initial 

This tsl creates RICON connector from KNAPP connectors






#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 6
#KeyWords Baufritz,Knapp,Ricon,connector
#BeginContents
//region <History>
// #Versions
// 1.6 09.07.2025 HSB-24279: Add trigger "Show Tag" for baufritz , Author: Marsel Nakuci
// 1.5 05.02.2025 HSB-23069: Fix bug at drill , Author: Marsel Nakuci
// 1.4 11/03/2024 HSB-21590: Add property for the fixtures, screwa Marsel Nakuci
// 1.3 13.02.2023 HSB-17934: Initialize properties from xml only if they are not set in the properties Author: Marsel Nakuci
// 1.2 08.07.2022 HSB-15937: Replace Mortise with house Author: Marsel Nakuci
// 1.1 07.07.2022 HSB-15937: Expose xml parameters in properties Author: Marsel Nakuci
// 1.0 14.06.2022 HSB-15731: initial Author: Marsel Nakuci

/// <insert Lang=en>
/// Select entities
/// </insert>

// <summary Lang=en>
// This tsl creates RICON connector from KNAPP connectors
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbHiddenConnector")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|UserPrompt|"))) TSLCONTENT
//endregion

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
//end Constants//endregion
	
//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="hsbHiddenConnector";
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
			reportNotice(TN("|A different Version of the settings has been found for|") + scriptName()+
			TN("|Current Version| ")+nVersion + "	" + _kPathDwg + TN("|Other Version| ") +nVersionInstall + "	" + sFile);
	}
//End Settings//endregion	

//region manufacturer map
	String sManufacturers[0];
//	sManufacturers.append("---");
	{ 
		// get the manufacturers
		Map mapManufacturers = mapSetting.getMap("Manufacturer[]");
		for (int i = 0; i < mapManufacturers.length(); i++)
		{
			Map mapManufacturerI = mapManufacturers.getMap(i);
			if (mapManufacturerI.hasString("Name") && mapManufacturers.keyAt(i).makeLower() == "manufacturer")
			{
				String _sManufacturerName = mapManufacturerI.getString("Name");
				if (sManufacturers.find(_sManufacturerName) < 0)
				{
					sManufacturers.append(_sManufacturerName);
				}
			}
		}
	}
	
	if (sManufacturers.length()<1)
	{ 
		reportMessage("\n"+ scriptName() + ": "+ T("|Could not find manufacturer data.| ")+ T("|Tool will be deleted.|"));
		eraseInstance();
		return;
	}
//End manufacturer map//endregion 
	
	
//region Properties
	category=T("|Component|");
	// Manufacturer
	// 0
	String sManufacturerName=T("|Manufacturer|");	
	PropString sManufacturer(nStringIndex++, sManufacturers, sManufacturerName);
	sManufacturer.setDescription(T("|Defines the Manufacturer|"));
	sManufacturer.setCategory(category);
	// Family
	// 1
	String sFamilies[0];
//	sFamilies.append("---");
	String sFamilyName=T("|Family|");	
	PropString sFamily(nStringIndex++, "", sFamilyName);	
	sFamily.setDescription(T("|Defines the Family|"));
	sFamily.setCategory(category);
	// Model
	// 2
	String sModels[0];
//	sModels.append("---");
	String sModelName=T("|Model|");
	PropString sModel(nStringIndex++, "", sModelName);
	sModel.setDescription(T("|Defines the Model|"));
	sModel.setCategory(category);
// Milling
	// 3
	category=T("|Tooling|");
	String sMillingName=T("|Milling|");
	String sMillings[]={ T("|Male|"),T("|Female|")};
	PropString sMilling(nStringIndex++, sMillings, sMillingName);
	sMilling.setDescription(T("|Defines the Milling side|"));
	sMilling.setCategory(category);
	
// Milling
	// 0
	category=T("|Milling|"+" "+T("|Female beam|"));
	String sMillingWidthFemaleName=T("|Width|");
	PropDouble dMillingWidthFemale(nDoubleIndex++, U(0), sMillingWidthFemaleName);	
	dMillingWidthFemale.setDescription(T("|Defines the Milling Width|"));
	dMillingWidthFemale.setCategory(category);
	// 1
	String sMillingHeightFemaleName=T("|Height|");
	PropDouble dMillingHeightFemale(nDoubleIndex++, U(0), sMillingHeightFemaleName);	
	dMillingHeightFemale.setDescription(T("|Defines the Milling Height|"));
	dMillingHeightFemale.setCategory(category);
	// 2
	String sMillingDepthFemaleName=T("|Depth|");
	PropDouble dMillingDepthFemale(nDoubleIndex++, U(0), sMillingDepthFemaleName);	
	dMillingDepthFemale.setDescription(T("|Defines the Milling Depth|"));
	dMillingDepthFemale.setCategory(category);
	
	category=T("|Milling|"+" "+T("|Male beam|"));
	// 3
	String sMillingWidthMaleName=T("|Width|"+" ");
	PropDouble dMillingWidthMale(nDoubleIndex++, U(0), sMillingWidthMaleName);	
	dMillingWidthMale.setDescription(T("|Defines the Milling Width|"));
	dMillingWidthMale.setCategory(category);
	// 4
	String sMillingHeightMaleName=T("|Height|"+" ");
	PropDouble dMillingHeightMale(nDoubleIndex++, U(0), sMillingHeightMaleName);	
	dMillingHeightMale.setDescription(T("|Defines the Milling Height|"));
	dMillingHeightMale.setCategory(category);
	// 5
	String sMillingDepthMaleName=T("|Depth|"+" ");
	PropDouble dMillingDepthMale(nDoubleIndex++, U(0), sMillingDepthMaleName);	
	dMillingDepthMale.setDescription(T("|Defines the Milling Depth|"));
	dMillingDepthMale.setCategory(category);
	
	category=T("|Position|");
	// 6
	String sDistanceHeightName=T("|Distance Height|");	
	PropDouble dDistanceHeight(nDoubleIndex++, U(0), sDistanceHeightName);	
	dDistanceHeight.setDescription(T("|Defines the Distance in Height direction|"));
	dDistanceHeight.setCategory(category);
	// 7
	String sDistanceWidthName=T("|Distance Width|");	
	PropDouble dDistanceWidth(nDoubleIndex++, U(0), sDistanceWidthName);	
	dDistanceWidth.setDescription(T("|Defines the Distance in Width direction|"));
	dDistanceWidth.setCategory(category);
	
	// nails, screws
	String sScrew;
	String sScrew1;
	String sSpezial=projectSpecial();
	int bIsBaufritz=sSpezial.makeLower()=="baufritz";
	//BF-06032024
	
	// HSB-21590
//	if(bIsBaufritz)
//	{
		// 4
		category=T("|Verbindungsmittel|");
		String sFixtures[]={T("|None|"),"Ricon S SK-Schraube 8x80", "Ricon S SK-Schraube 8x160","Megant SK-Schraube 8x240"};
		double dA[] ={ U(80), U(160), U(240), U(0)};
		String sFixtureName=T("|Verbindungsmittel Nebenträger|");	
		PropString sFixture(nStringIndex++, sFixtures, sFixtureName);	
		sFixture.setDescription(T("|Specifies the fixture for the connector at secondary beam.|"));
		if(!bIsBaufritz)sFixture.setReadOnly(_kHidden);
		sFixture.setCategory(category);
		// 5
		String sFixtures1[]={T("|None|"),"Ricon S SK-Schraube 8x80", "Ricon S SK-Schraube 8x160","Megant SK-Schraube 8x240"};
		String sFixture1Name=T("|Verbindungsmittel Hauptträger|");	
		PropString sFixture1(nStringIndex++, sFixtures1, sFixture1Name);	
		sFixture1.setDescription(T("|Specifies the fixture for the connector at main beam.|"));
		if(!bIsBaufritz)sFixture1.setReadOnly(_kHidden);
		sFixture1.setCategory(category);
//	}
	
	category=T("|Display|");
	String sColorName=T("|Color|");
	int nColors[]={1,2,3};
	PropInt nColor(nIntIndex++, 7, sColorName);
	nColor.setDescription(T("|Defines the Color|"));
	nColor.setCategory(category);
	
	
	
	
	// value t1
//	String sT1Name=T("|T1|");	
//	PropDouble dT1(nDoubleIndex++, U(50), sT1Name);	
//	dT1.setDescription(T("|Defines the T1 value|"));
//	dT1.setCategory(category);
	
//	String sOffsetYName=T("|Offset|")+" Y";	
//	PropDouble dOffsetY(nDoubleIndex++, U(0), sOffsetYName);	
//	dOffsetY.setDescription(T("|Defines the Offset in Y|"));
//	dOffsetY.setCategory(category);
//	
//	String sOffsetZName=T("|Offset|")+" Z";
//	PropDouble dOffsetZ(nDoubleIndex++, U(0), sOffsetZName);	
//	dOffsetZ.setDescription(T("|Defines the Offset in Z|"));
//	dOffsetZ.setCategory(category);

//End Properties//endregion 
	
//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		String sTokens[] = _kExecuteKey.tokenize("?");
		
		// select 2 beams, first selected defines the male beam
		// prompt for beams
		
		String sPromptMale = T("|Select male beams|");
		String sPromptFemale = T("|Select female beams|");
		
		Beam beamsMale[0];
		Entity entsMale[0];
		PrEntity ssMale(sPromptMale, Beam());
		ssMale.addAllowedClass(TrussEntity());
		if (ssMale.go())
		{
//				beamsMale.append(ssMale.beamSet());
			entsMale.append(ssMale.set());
		}
		
		Beam beamsFemale[0];
		Entity entsFemale[0];
		PrEntity ssFemale(sPromptFemale, Beam());
		ssFemale.addAllowedClass(TrussEntity());
		if (ssFemale.go())
		{
//				beamsFemale.append(ssFemale.beamSet());
			entsFemale.append(ssFemale.set());
		}
		
	// for now we keep separated male beams and female beams
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
		
	// collect only valid couples
		Entity entsMaleValid[0],entsFemaleValid[0];
		
		// create TSL
		TslInst tslNew; Vector3d vecXTsl = _XU; Vector3d vecYTsl = _YU;
		GenBeam gbsTsl[0]; Entity entsTsl[2]; Point3d ptsTsl[0];
		int nProps[0]; double dProps[0]; String sProps[0];
		Map mapTsl;	
		
		for (int i = 0; i < entsMale.length(); i++)
		{
			Quader qdMale;
			Beam bmMale = (Beam)entsMale[i];
			TrussEntity trussMale = (TrussEntity)entsMale[i];
			if (bmMale.bIsValid())
			{
				// beam selected
				qdMale = Quader(bmMale.ptCen(), bmMale.vecX(), bmMale.vecY(), bmMale.vecZ(),
				bmMale.dL(), bmMale.dW(), bmMale.dH(), 0, 0, 0);
			}
			Entity entMale = entsMale[i];
			//				gbsTsl[0] = bmMale;
			entsTsl[0] = entMale;
			//				Vector3d vxMale = bmMale.vecX();
			Vector3d vxMale = qdMale.vecX();
			
			for (int j = 0; j < entsFemale.length(); j++)
			{
				//					Beam bmFemale = beamsFemale[j];
				Quader qdFemale;
				Beam bmFemale = (Beam) entsFemale[j];
				Entity entFemale = entsFemale[j];
				TrussEntity trussFemale = (TrussEntity)entsFemale[j];
				if (bmFemale.bIsValid())
				{
					// beam selected
					qdFemale = Quader(bmFemale.ptCen(), bmFemale.vecX(), bmFemale.vecY(), bmFemale.vecZ(),
					bmFemale.dL(), bmFemale.dW(), bmFemale.dH(), 0, 0, 0);
				}
				Vector3d vxFemale = qdFemale.vecX();
				
				if(abs(abs(vxMale.dotProduct(vxFemale))-1.0)<dEps)
				{ 
					// parallel
					continue;
				}
				
				Body bdFemale, bdMaleLong;
				bdFemale = Body(qdFemale);
				bdMaleLong=Body(qdMale.ptOrg(), 
					qdMale.vecX(), qdMale.vecY(),qdMale.vecZ(),
					U(10e4),(qdMale.dD(qdMale.vecY())+dEps), (qdMale.dD(qdMale.vecZ())+dEps),
					0, 0, 0);
				if ( ! bdMaleLong.hasIntersection(bdFemale))
				{
					// extantion of male can not intersect female beam
					continue;
				}
				
			// valid connection
				entsMaleValid.append(entMale);
				entsFemaleValid.append(entFemale);
			
//			// create TSL instance
//				entsTsl[1] = entFemale;
//				sProps.setLength(0);
//				sProps.append(sManufacturer);
//				sProps.append(sFamily);
//				sProps.append(sModel);
//				
//			// create TSL
//				tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, 
//					ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
			}
		}
		
		if(entsMaleValid.length()==0 || entsFemaleValid.length()==0)
		{ 
			// 
			reportMessage("\n"+scriptName()+" "+T("|No valid couple found|"));
			eraseInstance();
			return;
		}
		
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
			else if(sManufacturers.length()==1)
			{ 
				// only 1 manufacturer available
				sManufacturer.set(sManufacturers[0]);
	//					setOPMKey(sManufacturers[i]);
				sManufacturer.setReadOnly(true);
			}
			else
			{ 
			// show dialog to chose manufacturer
				sManufacturer.setReadOnly(false);
				sFamily.set("---");
				sFamily.setReadOnly(true);
				sModel.set("---");
				sModel.setReadOnly(true);
				sMilling.setReadOnly(false);
				sFixture.setReadOnly(false);
				sFixture1.setReadOnly(false);
				
				showDialog("---");
				sOpmKey = sManufacturer;
			}
			
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
					if (mapManufacturerI.hasString("Name") && mapManufacturers.keyAt(i).makeLower() == "manufacturer")
					{
						String sManufacturerName = mapManufacturerI.getString("Name");
						String _sManufacturer = sManufacturer;_sManufacturer.makeUpper();
						if (sManufacturerName.makeUpper() != _sManufacturer)
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
						if (mapFamilyJ.hasString("Name") && mapFamilies.keyAt(j).makeLower() == "family")
						{
							String sName = mapFamilyJ.getString("Name");
							if (sFamilies.find(sName) < 0)
							{
								// populate sFamilies
								sFamilies.append(sName);
								if (bDebug)reportMessage("\n" + scriptName() + " sName: " + sName);
							}
						}
					}
					
					if (sTokens.length() >= 2)
					{
						// see if sTokens[1] is a valid model name as in sModels from mapSetting
						int indexSTokens = sFamilies.find(sTokens[1]);
						sFamily = PropString(1, sFamilies, sFamilyName, 0);
						if (indexSTokens >- 1)
						{
							// find
							//				sModel = PropString(1, sModels, sModelName, indexSTokens);
							sFamily.set(sTokens[1]);
							if (bDebug)reportMessage("\n" + scriptName() + " from tokens ");
						}
						else
						{
							// wrong definition in the opmKey, accept the first model from the xml
							reportMessage("\n"+scriptName()+" "+T("|wrong definition of the OPM key|"));
							
							sFamily.set(sFamilies[0]);
						}
					}
					else if (sFamilies.length() == 1)
					{
						sFamily = PropString(1, sFamilies, sFamilyName, 0);
						sFamily.set(sFamilies[0]);
					}
					else
					{
						// dialog for family
						sManufacturer.setReadOnly(true);
						sFamily.setReadOnly(false);
						sFamily = PropString(1, sFamilies, sFamilyName, 0);
						sFamily.set(sFamilies[0]);
						sModel = PropString(2, sModels, sModelName, 0);
						sModel.set("---");
						sModel.setReadOnly(true);
						sMilling.setReadOnly(false);
						sFixture.setReadOnly(false);
						sFixture1.setReadOnly(false);
						showDialog("---");
					}
					
					// for the chosen family get models and nails. first find the map of selected family
					for (int j = 0; j < mapFamilies.length(); j++)
					{
						Map mapFamilyJ = mapFamilies.getMap(j);
						if (mapFamilyJ.hasString("Name") && mapFamilies.keyAt(j).makeLower() == "family")
						{
							String sFamilyName = mapFamilyJ.getString("Name");
							String _sFamily = sFamily;_sFamily.makeUpper();
							
							if (sFamilyName.makeUpper() != _sFamily)
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
						
						// mapFamilyJ is found, populate models and nails
						// map of the selected family is found
						// get its models
						Map mapModels = mapFamilyJ.getMap("Model[]");
						if (mapModels.length() < 1)
						{
							// wrong definition of the map
							reportMessage("\n"+scriptName()+" "+T("|no model definition for this family|"));
							eraseInstance();
							return;
						}
						
						for (int k = 0; k < mapModels.length(); k++)
						{
							Map mapModelK = mapModels.getMap(k);
							if (mapModelK.hasString("Name") && mapModels.keyAt(k).makeLower() == "model")
							{
								String sName = mapModelK.getString("Name");
								if (sModels.find(sName) < 0)
								{
									// populate sModels
									sModels.append(sName);
									if (bDebug)reportMessage("\n" + scriptName() + " sName: " + sName);
								}
							}
						}
						
						if (sTokens.length() >= 3)
						{
							// see if sTokens[1] is a valid model name as in sModels from mapSetting
							int indexSTokens = sModels.find(sTokens[2]);
							if (indexSTokens >- 1)
							{
								// find
								//				sModel = PropString(1, sModels, sModelName, indexSTokens);
								sModel.set(sTokens[2]);
								if (bDebug)reportMessage("\n" + scriptName() + " from tokens ");
							}
							else
							{
								// wrong definition in the opmKey, accept the first model from the xml
								reportMessage("\n"+scriptName()+" "+T("|wrong definition of the OPM key|"));
								sModel.set(sModels[0]);
							}
						}
//						else if (sModels.length() == 1)
//						{
//							sModel.set(sModels[0]);
//							reportMessage("\n"+scriptName()+" "+T("|model0|"));
//						}
						else
						{
							// show dialog
							// model not set in opm key, show the dialog to get the opm key
							// set array of smodels and get the first by default
							// family is set, set as readOnly
							sManufacturer.setReadOnly(true);
							sFamily.setReadOnly(true);
							sModel.setReadOnly(false);
							sModel = PropString(2, sModels, sModelName, 0);
							sModel.set(sModels[0]);
							sMilling.setReadOnly(false);
							sFixture.setReadOnly(false);
							sFixture1.setReadOnly(false);
							showDialog("---");
						}
						// models set
						break;
					}
					// family set
					break;
				}
			}
		}
		
		// create TSL instances
		for (int ient=0;ient<entsMaleValid.length();ient++) 
		{ 
			Beam bmI =(Beam) entsMaleValid[ient];
			for (int jent=0;jent<entsFemaleValid.length();jent++) 
			{ 
				Beam bmJ=(Beam)entsFemaleValid[jent];
				
				if ( ! bmI.bIsValid() || !bmJ.bIsValid())continue;
				
				entsTsl.setLength(0);
				entsTsl.append(bmI);
				entsTsl.append(bmJ);
				sProps.setLength(0);
			// properties component
				sProps.append(sManufacturer);
				sProps.append(sFamily);
				sProps.append(sModel);
			// properties Tooling
				sProps.append(sMilling);
				sProps.append(sFixture);
				sProps.append(sFixture1);
				
				dProps.setLength(0);
				dProps.append(dMillingWidthFemale);
				dProps.append(dMillingHeightFemale);
				dProps.append(dMillingDepthFemale);
				dProps.append(dMillingWidthMale);
				dProps.append(dMillingHeightMale);
				dProps.append(dMillingDepthMale);
				dProps.append(dDistanceHeight);
				dProps.append(dDistanceWidth);
//				dProps.append(dOffsetY);
//				dProps.append(dOffsetZ);

				nProps.setLength(0);
				nProps.append(nColor);
			// create TSL
				tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, 
					ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
			}//next jent
		}//next ient
		
		eraseInstance();
		return;
	}
// end on insert	__________________//endregion

if(_Entity.length()<2)
{ 
	// 2 beams needed
	reportMessage("\n"+scriptName()+" "+T("|2 beams are needed|"));
	eraseInstance();
	return;
}

// basic information
Beam bm0=(Beam)_Entity[0];
Point3d ptCen0=bm0.ptCen();
Vector3d vecX0=bm0.vecX();
Vector3d vecY0=bm0.vecY();
Vector3d vecZ0=bm0.vecZ();
Quader qd0;
qd0=Quader(bm0.ptCen(),bm0.vecX(),bm0.vecY(),bm0.vecZ(),
		   bm0.dL(), bm0.dD(bm0.vecY()), bm0.dD(bm0.vecZ()),
		   0, 0, 0);
_Pt0 = ptCen0;
Body bd0 = Body(qd0);
	
Beam bm=(Beam)_Entity[1];
Point3d ptCen=bm.ptCen();
Vector3d vecX=bm.vecX();
Vector3d vecY=bm.vecY();
Vector3d vecZ=bm.vecZ();
Quader qd;
qd=Quader(bm.ptCen(),bm.vecX(),bm.vecY(),bm.vecZ(),
		  bm.dL(), bm.dD(bm.vecY()), bm.dD(bm.vecZ()),
		  0, 0, 0);
Body bd = Body(qd);

int bModeMale = _Map.getInt("ModeMale");
assignToLayer("i");
if(!bModeMale)
{
	assignToGroups(bm);
}
else if(bModeMale)
{
	assignToGroups(bm0);
}

// get pt0 at intersection of male with female beam
Map mapManufacturer;
Map mapManufacturers = mapSetting.getMap("Manufacturer[]");
// get mapManufacturer
for (int i = 0; i < mapManufacturers.length(); i++)
{ 
	Map mapManufacturerI = mapManufacturers.getMap(i);
	if (mapManufacturerI.hasString("Name") && mapManufacturers.keyAt(i).makeLower() == "manufacturer")
	{
		String _sManufacturerName = mapManufacturerI.getString("Name");
		String _sManufacturer = sManufacturer;_sManufacturer.makeUpper();
		if (_sManufacturerName.makeUpper() != _sManufacturer)
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

Map mapFamilies = mapManufacturer.getMap("Family[]");
sFamilies.setLength(0);
for (int i = 0; i < mapFamilies.length(); i++)
{
	Map mapFamilyI = mapFamilies.getMap(i);
	if (mapFamilyI.hasString("Name") && mapFamilies.keyAt(i).makeLower() == "family")
	{
		String sName = mapFamilyI.getString("Name");
		if (sFamilies.find(sName) < 0)
		{
			// populate sFamilies with all the sFamilies of the selected manufacturer
			sFamilies.append(sName);
		}
	}
}
int indexFamily = sFamilies.find(sFamily);
sFamily = PropString(1, sFamilies, sFamilyName, 1);


if (indexFamily >- 1 )
{
	// selected sFamily contained in sFamilies
	sFamily = PropString(1, sFamilies, sFamilyName, indexFamily);
//			sFamily.set(sFamilies[indexFamily]);
	if(sManufacturer!="---"&& indexFamily==0 && _kNameLastChangedProp==sManufacturerName)
	{
		sFamily.set(sFamilies[1]);
//		sFamily = PropString(1, sFamilies, sFamilyName, 1);
	}
}
else
{
	// existing sFamily is not found, Family has been changed so set 
	// to sFamily the first Family from sFamilies
	sFamily = PropString(1, sFamilies, sFamilyName, 1);
	sFamily.set(sFamilies[0]);
}

// get map of Family
Map mapFamily;
for (int i = 0; i < mapFamilies.length(); i++)
{ 
	Map mapFamilyI = mapFamilies.getMap(i);
	if (mapFamilyI.hasString("Name") && mapFamilies.keyAt(i).makeLower() == "family")
	{
		String _sFamilyName = mapFamilyI.getString("Name");
		String _sFamily = sFamily;_sFamily.makeUpper();
		if (_sFamilyName.makeUpper() != _sFamily)
		{
			continue;
		}
	}
	else
	{ 
		// not a manufacturer map
		continue;
	}
	mapFamily = mapFamilies.getMap(i);
	break;
}

Map mapModels=mapFamily.getMap("Model[]");
sModels.setLength(0);
for (int i = 0; i < mapModels.length(); i++)
{
	Map mapModelI=mapModels.getMap(i);
	if (mapModelI.hasString("Name") && mapModels.keyAt(i).makeLower() == "model")
	{
		String sName = mapModelI.getString("Name");
		if (sModels.find(sName) < 0)
		{
			// populate sModels with all the sModels of the selected categry
			sModels.append(sName);
		}
	}
}
int indexModel=sModels.find(sModel);
sModel=PropString(2, sModels, sModelName, 0);
if (indexModel>- 1)
{
	// selected sModelis contained in sModels
	sModel = PropString(2, sModels, sModelName, indexModel);
	if(sFamily!="---"&& indexModel==0 && (_kNameLastChangedProp==sManufacturerName || _kNameLastChangedProp==sFamilyName))
	{
		sModel.set(sModels[0]);
//		sModel=PropString(2, sModels, sModelName, 1);
	}
}
else
{
	// existing sModel is not found, Model has been changed so set 
	// to sModel the first Model from sModels
	sModel=PropString(2, sModels, sModelName, 0);
	sModel.set(sModels[0]);
}


// common calculation for both male and female
// get map of the selected model
Map mapModel;
int bModelFound = false;
{
	// 
	Map mapModels = mapFamily.getMap("Model[]");
	for (int iii = 0; iii < mapModels.length(); iii++)
	{
		Map mapModelI = mapModels.getMap(iii);
		if (mapModelI.hasString("Name") && mapModels.keyAt(iii).makeLower() == "model")
		{
			String _sModelName = mapModelI.getString("Name");
			String _sModel = sModel;_sModel.makeUpper();
			if (_sModelName.makeUpper() == _sModel)
			{
				mapModel = mapModelI;
				bModelFound = true;
				break;
			}
		}
	}
}

String sUrl;
String s;
s = "url"; if(mapModel.hasString(s))sUrl = mapModel.getString(s);
_ThisInst.setHyperlink(sUrl);

//setOPMKey(sManufacturer);

//setKeepReferenceToGenBeamDuringCopy(_kAllBeams);
//setEraseAndCopyWithBeams(_kBeam01);

//_Pt0 = ptCen0;
// get intersection of axis of male with plane of female
// get the plane of connection
// vector pointing toward the female beam
Vector3d _vecX0=vecX0;
if ((ptCen-ptCen0).dotProduct(_vecX0) < 0)_vecX0*= -1;

PlaneProfile pp0(Plane(ptCen0, qd0.vecX()));
PLine pl0;
pl0.createRectangle(LineSeg(ptCen0-.5*qd0.vecY()*qd0.dD(qd0.vecY())-.5*qd0.vecZ()*qd0.dD(qd0.vecZ()),
ptCen0+.5*qd0.vecY()*qd0.dD(qd0.vecY())+.5*qd0.vecZ()*qd0.dD(qd0.vecZ())),
	qd0.vecY(), qd0.vecZ());
pp0.joinRing(pl0, _kAdd);

Vector3d vecsPlane[] ={ qd.vecY(), - qd.vecY(), qd.vecZ() ,- qd.vecZ()};
int iPlanesOpposite[] ={ 1, 0, 3, 2};
double dWidths[]={qd.dD(vecsPlane[0]), qd.dD(vecsPlane[1]),
		qd.dD(vecsPlane[2]), qd.dD(vecsPlane[3])};

Plane plns[]={ Plane(ptCen+vecsPlane[0]*.5*dWidths[0], vecsPlane[0]),
	Plane(ptCen+vecsPlane[1]*.5*dWidths[1], vecsPlane[1]),
	Plane(ptCen+vecsPlane[2]*.5*dWidths[2], vecsPlane[3]),
	Plane(ptCen + vecsPlane[3] * .5 * dWidths[3], vecsPlane[3])};
	
PlaneProfile pps[] ={ PlaneProfile(plns[0]), PlaneProfile(plns[1]),
	PlaneProfile(plns[2]),PlaneProfile(plns[3])};
//	plns[0].vis(3);
pps[0] = bd.shadowProfile(plns[0]);
pps[1] = bd.shadowProfile(plns[1]);
pps[2] = bd.shadowProfile(plns[2]);
pps[3] = bd.shadowProfile(plns[3]);

double dAlignmentDir = 0;// initialize
int iPlaneConntact = -1;
for (int ip=0;ip<vecsPlane.length();ip++) 
{ 
	// 
	PlaneProfile pp0Intersect = pp0;
	pp0Intersect.shrink(-dEps);
	int bIntersect = pp0Intersect.intersectWith(pps[ip]);
	if ( ! bIntersect)continue;
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
int bBeamsIntersect=true;
{ 
	PlaneProfile pp0IntersectShrink = pp0;
	pp0IntersectShrink.shrink(dEps);
	PlaneProfile pp0IntersectExtend = pp0;
	pp0IntersectExtend.shrink(-dEps);
	int bIntersectShrink = pp0IntersectShrink.intersectWith(pps[iPlaneConntact]);
	int bIntersectExtend = pp0IntersectExtend.intersectWith(pps[iPlaneConntact]);
	if ( ! bIntersectShrink && bIntersectExtend)bBeamsIntersect = false;
}

Plane pnContact = plns[iPlaneConntact];
_Pt0 = Line(ptCen0, qd0.vecX()).intersect(pnContact, 0);

// body for the hanging beam (secondary beam) and the stud (main beam)
Map mapPart=mapModel.getMap("Part");
double dLengthPart=mapPart.getDouble("Length");
double dWidthPart=mapPart.getDouble("Width");
double dThicknessPart=mapPart.getDouble("Thickness");
// 
double dTopHanger=mapPart.getDouble("TopHanger");
//double dBottHanger=mapPart.getDouble("BottHanger");
//double dTopBott=mapPart.getDouble("TopBott");

Map mapNailFemales=mapModel.getMap("NailFemale[]");
Map mapNailMales=mapModel.getMap("NailMale[]");
Body bdPartBeam, bdPartStud;
{ 
	Body bdMain(_Pt0,_XW,_YW,_ZW,dLengthPart,dWidthPart,dThicknessPart,0,0,1);
//	bdMain.vis(1);
	_XW.vis(_Pt0, 1);
	_YW.vis(_Pt0, 5);
	_ZW.vis(_Pt0, 3);
	// add cylinder part
	Point3d ptCyl=_Pt0+_XW*(.5*dLengthPart-dTopHanger);
//	ptCyl.vis(6);
	Body bdCyl(ptCyl, ptCyl + _ZW * 2 * dThicknessPart, U(7));
//	bdCyl.vis(3);
	bdPartBeam.addPart(bdMain);
	bdPartBeam.addPart(bdCyl);
//	bdPartBeam.vis(6);
	
	bdPartStud.addPart(bdMain);
	ptCyl=_Pt0-_XW*(.5*dLengthPart-dTopHanger);
	bdCyl=Body (ptCyl, ptCyl + _ZW * 2 * dThicknessPart, U(7));
	bdPartStud.addPart(bdCyl);
//	bdPartStud.vis(6);
}

_Pt0.vis(1);
vecsPlane[iPlaneConntact].vis(_Pt0,1);

Vector3d vecXmilling = bm0.vecD(_ZW);
// project vecXmilling to the plane of contace
vecXmilling=vecsPlane[iPlaneConntact].crossProduct(vecXmilling.crossProduct(vecsPlane[iPlaneConntact]));
vecXmilling.normalize();
vecXmilling.vis(_Pt0, 6);
Vector3d vecXpart = vecXmilling;
Vector3d vecYpart,vecZpart;
// get top point of milling
Point3d ptTopMilling=bm0.ptCen()+.5*bm0.vecD(_ZW)*bm0.dD(_ZW);
int bIntersectT=Line(ptTopMilling,vecX0).hasIntersection(pnContact,ptTopMilling);
//ptTopMilling.vis(3);
Point3d ptBottomMilling=bm0.ptCen()-.5*bm0.vecD(_ZW)*bm0.dD(_ZW);
int bIntersectB=Line(ptBottomMilling,vecX0).hasIntersection(pnContact,ptBottomMilling);

String sPropStringNames[]={sManufacturerName,sFamilyName,sModelName,
	sMillingName};
String sPropStringValues[]={sManufacturer,sFamily,sModel,
	sMilling};
String sPropDoubleNames[] ={sMillingWidthFemaleName,sMillingHeightFemaleName,sMillingDepthFemaleName,
  sMillingWidthMaleName,sMillingHeightMaleName,sMillingDepthMaleName,
  sDistanceHeightName,sDistanceWidthName};
double dPropDoubleValues[] ={dMillingWidthFemale,dMillingHeightFemale,dMillingDepthFemale,
 dMillingWidthMale,dMillingHeightMale,dMillingDepthMale,dDistanceHeight,dDistanceWidth};
String sPropIntNames[] ={ };
int nPropIntValues[]={ };
if(!bModeMale || bModeMale)
{ 
	TslInst tslSibling;
	String sSiblingName="maleTsl";
	String sSiblingNameOther="femaleTsl";
	int bModeMaleTsl = true;
	if(bModeMale)
	{
		sSiblingName="femaleTsl";
		sSiblingNameOther="maleTsl";
		bModeMaleTsl = false;
	}
	if(!_Map.hasEntity(sSiblingName))
	{ 
	// create TSL
		TslInst tslNew; Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
		GenBeam gbsTsl[] = {}; Entity entsTsl[] = {bm0,bm}; Point3d ptsTsl[] = {_Pt0};
		int nProps[]={}; 
//		double dProps[]={dOffsetY,dOffsetZ}; 
		double dProps[]={dMillingWidthFemale,dMillingHeightFemale,
		 dMillingDepthFemale,dMillingWidthMale,dMillingHeightMale,
		 dMillingDepthMale,dDistanceHeight,dDistanceWidth}; 
		String sProps[]={sManufacturer,sFamily,sModel,sMilling,sFixture,sFixture1};
		Map mapTsl;
		
		mapTsl.setInt("ModeMale", bModeMaleTsl);
		mapTsl.setEntity(sSiblingNameOther, _ThisInst);
		tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, 
			ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
		tslNew.recalc();
		tslSibling = tslNew;
	}
	else
	{
	
		Entity tslEnt = _Map.getEntity(sSiblingName);
		TslInst tslSiblingThis = (TslInst)tslEnt;
		if ( ! tslSiblingThis.bIsValid())
		{
			TslInst tslNew; Vector3d vecXTsl = _XW; Vector3d vecYTsl = _YW;
			GenBeam gbsTsl[] = { bm0, bm}; Entity entsTsl[] = {bm0,bm}; Point3d ptsTsl[] = { _Pt0};
			int nProps[] ={};
//			double dProps[] ={dOffsetY,dOffsetZ};
			double dProps[]={dMillingWidthFemale,dMillingHeightFemale,
		     dMillingDepthFemale,dMillingWidthMale,dMillingHeightMale,
		     dMillingDepthMale,dDistanceHeight,dDistanceWidth}; 
			String sProps[] ={sManufacturer,sFamily,sModel,sMilling,sFixture,sFixture1};
			Map mapTsl;
			mapTsl.setInt("ModeMale", bModeMaleTsl);
			mapTsl.setEntity(sSiblingNameOther, _ThisInst);
			tslNew.dbCreate(scriptName() , vecXTsl , vecYTsl, gbsTsl, entsTsl,
			ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
			tslNew.recalc();
			tslSibling = tslNew;
		}
		else
		{
			tslSibling = tslSiblingThis;
		}
	}
	Map mapSibling = tslSibling.map();
	mapSibling.setEntity(sSiblingNameOther, _ThisInst);
	tslSibling.setMap(mapSibling);
//		if(tslMale.bIsValid())
	_Map.setEntity(sSiblingName, tslSibling);
	if (_Entity.find(tslSibling) < 0)
		_Entity.append(tslSibling);
	setDependencyOnEntity(tslSibling);
	int nPropStringIndex=sPropStringNames.find(_kNameLastChangedProp);
	int nPropDoubleIndex=sPropDoubleNames.find(_kNameLastChangedProp);
	int nPropIntIndex=sPropIntNames.find(_kNameLastChangedProp);
	if(nPropStringIndex>-1)
	{ 
	// a string was changed
		tslSibling.setPropString(nPropStringIndex,sPropStringValues[nPropStringIndex]);
	}
	else if(nPropDoubleIndex>-1)
	{ 
		tslSibling.setPropDouble(nPropDoubleIndex,dPropDoubleValues[nPropDoubleIndex]);
	}
	else if(nPropIntIndex>-1)
	{ 
		tslSibling.setPropInt(nPropIntIndex,nPropIntValues[nPropIntIndex]);
	}
}

// see the side of the milling
int nMilling = sMillings.find(sMilling);
Map mapMilling=mapModel.getMap("Milling");
Map mapMillingBeamParameters=mapModel.getMap("MillingBeamParameters");
double dLengthMilling = mapMilling.getDouble("Length");
double dWidthMilling = mapMilling.getDouble("Width");
double dDepthMilling = mapMilling.getDouble("Depth");
double dCoverMilling = mapMillingBeamParameters.getDouble("Cover");
double dRadiusMilling = mapMilling.getDouble("Radius");

String sPropMillingNames[]={sManufacturerName,sFamilyName,sModelName,sMillingName};
if(_bOnDbCreated || sPropMillingNames.find(_kNameLastChangedProp)>-1)
{ 
// set the xml values
	if(nMilling)
	{ 
	// female is getting milled
		if(_kNameLastChangedProp==sMillingName)
		{ 
			// property is changed
			double _dMillingWidthFemale=dMillingWidthFemale;
			double _dMillingHeightFemale=dMillingHeightFemale;
			double _dMillingDepthFemale=dMillingDepthFemale;
			dMillingWidthFemale.set(dMillingWidthMale);
			dMillingHeightFemale.set(dMillingHeightMale);
			dMillingDepthFemale.set(dMillingDepthMale);
		//
			dMillingWidthMale.set(_dMillingWidthFemale);
			dMillingHeightMale.set(_dMillingHeightFemale);
			dMillingDepthMale.set(_dMillingDepthFemale);
		}
		else
		{ 
			// initialised
			if(dMillingWidthFemale==U(0))
				dMillingWidthFemale.set(dWidthMilling);
			if(dMillingHeightFemale==U(0))
				dMillingHeightFemale.set(dLengthMilling);
			if(dMillingDepthFemale==U(0))
				dMillingDepthFemale.set(dDepthMilling);
		}
	}
	else 
	{ 
	// male is getting milled
		if(_kNameLastChangedProp==sMillingName)
		{ 
			double _dMillingWidthMale=dMillingWidthMale;
			double _dMillingHeightMale=dMillingHeightMale;
			double _dMillingDepthMale=dMillingDepthMale;
			dMillingWidthMale.set(dMillingWidthFemale);
			dMillingHeightMale.set(dMillingHeightFemale);
			dMillingDepthMale.set(dMillingDepthFemale);
		//
			dMillingWidthFemale.set(_dMillingWidthMale);
			dMillingHeightFemale.set(_dMillingHeightMale);
			dMillingDepthFemale.set(_dMillingDepthMale);
		}
		else
		{ 
			if(dMillingWidthMale==U(0))
				dMillingWidthMale.set(dWidthMilling);
			if(dMillingHeightMale==U(0))
				dMillingHeightMale.set(dLengthMilling);
			if(dMillingDepthMale==U(0))
				dMillingDepthMale.set(dDepthMilling);
		}
	}
}
Vector3d vecZmilling = bm.vecD(-_vecX0);
Vector3d vecYmilling=vecZmilling.crossProduct(vecXmilling);
ptTopMilling+=vecXmilling*dDistanceHeight;
ptBottomMilling+=vecXmilling*dDistanceHeight;
ptTopMilling+=vecYmilling*dDistanceWidth;
ptBottomMilling+=vecYmilling*dDistanceWidth;
// drills
Point3d ptPart;


double dDiameterRounding = U(30);
if(nMilling==0)
{ 
	// mill male bm0
	Vector3d vecZmilling = bm.vecD(-_vecX0);
	Vector3d vecYmilling=vecZmilling.crossProduct(vecXmilling);
	vecYpart = vecYmilling;
	vecZpart=vecZmilling;
	vecYmilling.vis(ptBottomMilling, 2);
	// male is being milled
	if(bModeMale)
	{
		if(dMillingHeightMale>dEps && dMillingWidthMale>dEps && dMillingDepthMale>dEps)
		{ 
			House hs(ptBottomMilling,vecXmilling,vecYmilling,vecZmilling,
			2*dMillingHeightMale,dMillingWidthMale,dMillingDepthMale,0,0,1);
			hs.cuttingBody().vis(3);
		//	hs.setRoundType(_kExplicitRadius);
//			hs.setRoundType(_kNotRound);
//			hs.setExplicitRadius(dRadiusMilling);
			hs.setRoundType(_kRelief);
            hs.setEndType(_kFemaleEnd);
            hs.cuttingBody().vis(3);
            if(!bDebug)
			{
				bm0.addTool(hs);
			}
		}
		ptPart=ptBottomMilling+vecXmilling*(dCoverMilling+.5*dLengthPart);
		ptPart += vecZmilling * dMillingDepthMale;
		ptPart.vis(2);
		if(bIsBaufritz)
		{ 
		// 
//			Point3d ptDrill=ptBottomMilling+vecXmilling*dMillingHeightMale;
//			ptDrill-=.5*dMillingWidthMale*vecYmilling;
//			Vector3d vecMove=vecYmilling-vecXmilling;vecMove.normalize();
//			ptDrill += vecMove * .5 * dDiameterRounding;
//			ptDrill.vis(2);
//			Drill drRound(ptDrill,ptDrill+vecZmilling*dMillingDepthMale,.5*dDiameterRounding);
//			bm0.addTool(drRound);
//		// 
//			ptDrill=ptBottomMilling+vecXmilling*dMillingHeightMale;
//			ptDrill+=.5*dMillingWidthMale*vecYmilling;
//			ptDrill.vis(2);
//			vecMove=-vecYmilling-vecXmilling;vecMove.normalize();
//			vecMove.vis(ptDrill);
//			ptDrill += vecMove * .5 * dDiameterRounding;
//			ptDrill.vis(2);
//			drRound=Drill(ptDrill,ptDrill+vecZmilling*dMillingDepthMale,.5*dDiameterRounding);
//			bm0.addTool(drRound);
			if(sModel=="RICON S 200/60 VS")
			{ 
			// apply directional drills
				Point3d ptDrill=ptBottomMilling+vecXmilling*(dMillingHeightMale-U(40));
				if(dMillingHeightMale<dEps)
					ptDrill=ptBottomMilling+vecXmilling*(U(210)-U(40));
				ptDrill.vis(3);
				Drill drRound(ptDrill,ptDrill+vecZmilling*(dMillingDepthMale+U(1.5)),.5*dDiameterRounding);
				drRound.cuttingBody().vis(4);
				bm0.addTool(drRound);
			}
		}
		
		vecZpart=-vecZmilling;
		// drill
		// HSB-23069
		Map mapDrills = mapModel.getMap("DrillMale[]");
		if(!bIsBaufritz)
		for (int idr=0;idr<mapDrills.length();idr++) 
		{ 
			Map mapDrillI = mapDrills.getMap(idr);
			Point3d ptDrill;
			if(mapDrillI.hasDouble("TopDrill"))
			{ 
				ptDrill=ptPart+vecXmilling*(.5*dLengthPart-mapDrillI.getDouble("TopDrill"));
			}
			else if(mapDrillI.hasDouble("BottomDrill"))
			{ 
				ptDrill=ptPart-vecXmilling*(.5*dLengthPart-mapDrillI.getDouble("BottomDrill"));
			}
			if(mapDrillI.hasDouble("SideAxis"))
			{ 
				ptDrill += mapDrillI.getDouble("SideAxis") * vecYmilling;
			}
//			ptDrill += vecZmilling * dDepthMilling;
			ptDrill.vis(4);
			double dLengthDrillI = mapDrillI.getDouble("Length");
			double dDiameterDrillI = mapDrillI.getDouble("Diameter");
			Drill dr(ptDrill,ptDrill+vecZmilling*dLengthDrillI,.5*dDiameterDrillI);
			bm0.addTool(dr);
		}//next idr
	}
	else if(!bModeMale)
	{ 
		ptPart=ptBottomMilling+vecXmilling*(dCoverMilling+.5*dLengthPart);
		vecZmilling *= -1;
		vecYmilling *= -1;
		if(dMillingHeightFemale>dEps && dMillingWidthFemale>dEps && dMillingDepthFemale>dEps)
		{ 
			Point3d _ptBottomMilling=ptBottomMilling+vecXmilling*(dMillingHeightMale-.5*dMillingHeightFemale);
//			ptBottomMilling-=-vecXmilling*(dMillingHeightMale-.5*dMillingHeightFemale);
			
			House hs(_ptBottomMilling,vecXmilling, vecYmilling, vecZmilling,
			 dMillingHeightFemale,dMillingWidthFemale,dMillingDepthFemale,0,0,1);
//			hs.setRoundType(_kNotRound);
//			hs.setExplicitRadius(dRadiusMilling);
			hs.setRoundType(_kRelief);
            hs.setEndType(_kFemaleSide);
            hs.cuttingBody().vis(3);

			bm.addTool(hs);
			_ptBottomMilling.vis(3);
//			ptPart=ptBottomMilling+vecXmilling*(dCoverMilling+.5*dLengthPart);
			ptPart+=vecZmilling*dMillingDepthFemale;
//			if(sSpezial.makeLower()=="baufritz")
//			{ 
			// 
//				_ptBottomMilling+=-vecXmilling*.5*dMillingHeightFemale;
//				Point3d ptDrill=_ptBottomMilling+vecXmilling*dMillingHeightFemale;
//				ptDrill-=.5*dMillingWidthFemale*vecYmilling;
//				Vector3d vecMove=vecYmilling-vecXmilling;vecMove.normalize();
//				ptDrill += vecMove * .5 * dDiameterRounding;
//				ptDrill.vis(2);
//				Drill drRound(ptDrill,ptDrill+vecZmilling*dMillingDepthFemale,.5*dDiameterRounding);
//				bm.addTool(drRound);
//			// 
//				ptDrill=_ptBottomMilling+vecXmilling*dMillingHeightFemale;
//				ptDrill+=.5*dMillingWidthFemale*vecYmilling;
//				ptDrill.vis(2);
//				vecMove=-vecYmilling-vecXmilling;vecMove.normalize();
//				vecMove.vis(ptDrill);
//				ptDrill += vecMove * .5 * dDiameterRounding;
//				ptDrill.vis(2);
//				drRound=Drill(ptDrill,ptDrill+vecZmilling*dMillingDepthFemale,.5*dDiameterRounding);
//				bm.addTool(drRound);
//				
//			// 
//				ptDrill=_ptBottomMilling;
//				ptDrill+=.5*dMillingWidthFemale*vecYmilling;
//				ptDrill.vis(2);
//				vecMove=-vecYmilling+vecXmilling;vecMove.normalize();
//				vecMove.vis(ptDrill);
//				ptDrill += vecMove * .5 * dDiameterRounding;
//				ptDrill.vis(2);
//				drRound=Drill(ptDrill,ptDrill+vecZmilling*dMillingDepthFemale,.5*dDiameterRounding);
//				bm.addTool(drRound);
//				
//				ptDrill=_ptBottomMilling;
//				ptDrill-=.5*dMillingWidthFemale*vecYmilling;
//				ptDrill.vis(2);
//				vecMove=+vecYmilling+vecXmilling;vecMove.normalize();
//				vecMove.vis(ptDrill);
//				ptDrill += vecMove * .5 * dDiameterRounding;
//				ptDrill.vis(2);
//				drRound=Drill(ptDrill,ptDrill+vecZmilling*dMillingDepthFemale,.5*dDiameterRounding);
//				bm.addTool(drRound);
//			}
//			vecZmilling *= -1;
		}
		if (bIsBaufritz)
		{
			if(sModel=="RICON S 200/60 VS")
			{ 
				Point3d _ptBottomMilling=ptBottomMilling+vecXmilling*(dMillingHeightMale-.5*dMillingHeightFemale);
				_ptBottomMilling+=-vecXmilling*.5*dMillingHeightFemale;
				Point3d ptDrill=_ptBottomMilling+vecXmilling*(U(40));
				ptDrill.vis(3);
				Drill drRound(ptDrill,ptDrill+vecZmilling*(dMillingDepthFemale+U(1.5)),.5*dDiameterRounding);
				drRound.cuttingBody().vis(4);
				bm.addTool(drRound);
			}
		}
//		ptPart=ptBottomMilling+vecXmilling*(dCoverMilling+.5*dLengthPart);
		Map mapDrills = mapModel.getMap("DrillFemale[]");
		if(!bIsBaufritz)
		for (int idr=0;idr<mapDrills.length();idr++) 
		{ 
			Map mapDrillI = mapDrills.getMap(idr);
			Point3d ptDrill;
			if(mapDrillI.hasDouble("TopDrill"))
			{ 
				ptDrill=ptPart+vecXmilling*(.5*dLengthPart-mapDrillI.getDouble("TopDrill"));
			}
			else if(mapDrillI.hasDouble("BottomDrill"))
			{ 
				ptDrill=ptPart-vecXmilling*(.5*dLengthPart-mapDrillI.getDouble("BottomDrill"));
			}
			if(mapDrillI.hasDouble("SideAxis"))
			{ 
				ptDrill += mapDrillI.getDouble("SideAxis") * vecYmilling;
			}
//			ptDrill += vecZmilling * dDepthMilling;
			ptDrill.vis(4);
			double dLengthDrillI = mapDrillI.getDouble("Length");
			double dDiameterDrillI = mapDrillI.getDouble("Diameter");
			Drill dr(ptDrill,ptDrill+vecZmilling*dLengthDrillI,.5*dDiameterDrillI);
			bm.addTool(dr);
		}//next idr
	}
}
else if(nMilling==1)
{ 
	// mill female bm
	// direction of depth
	Vector3d vecZmilling = bm.vecD(_vecX0);
	Vector3d vecYmilling=vecZmilling.crossProduct(vecXmilling);
	vecYpart = vecYmilling;
	vecZpart=-vecZmilling;
	vecYmilling.vis(ptTopMilling, 2);
	if(!bModeMale)
	{ 
		if(dMillingHeightFemale>dEps && dMillingWidthFemale>dEps && dMillingDepthFemale>dEps)
		{ 
			House hs(ptTopMilling,vecXmilling, vecYmilling, vecZmilling,
			 2*dMillingHeightFemale,dMillingWidthFemale,dMillingDepthFemale,0,0,1);
	//		hs.setRoundType(_kExplicitRadius);
//			hs.setRoundType(_kNotRound);
	//		hs.setExplicitRadius(dRadiusMilling);
			hs.setRoundType(_kRelief);
            hs.setEndType(_kFemaleSide);
            hs.cuttingBody().vis(3);
			bm.addTool(hs);
		}
		ptPart=ptTopMilling-vecXmilling*(dCoverMilling+.5*dLengthPart);
		if(dMillingHeightFemale>dEps)
			ptPart=ptTopMilling-vecXmilling*(dMillingHeightFemale-.5*dLengthPart);
		
		ptPart+=vecZmilling * dMillingDepthFemale;
		ptPart.vis(3);
		ptTopMilling.vis(1);
		// add roundings
		if(bIsBaufritz)
		{ 
		// 
//			Point3d ptDrill=ptTopMilling-vecXmilling*dMillingHeightFemale;
//			ptDrill-=.5*dMillingWidthFemale*vecYmilling;
//			Vector3d vecMove=vecYmilling+vecXmilling;vecMove.normalize();
//			ptDrill += vecMove * .5 * dDiameterRounding;
//			ptDrill.vis(2);
//			Drill drRound(ptDrill,ptDrill+vecZmilling*dMillingDepthFemale,.5*dDiameterRounding);
//			bm.addTool(drRound);
//		// 
//			ptDrill=ptTopMilling-vecXmilling*dMillingHeightFemale;
//			ptDrill+=.5*dMillingWidthFemale*vecYmilling;
//			ptDrill.vis(2);
//			vecMove=-vecYmilling+vecXmilling;vecMove.normalize();
//			vecMove.vis(ptDrill);
//			ptDrill += vecMove * .5 * dDiameterRounding;
//			ptDrill.vis(2);
//			drRound=Drill(ptDrill,ptDrill+vecZmilling*dMillingDepthFemale,.5*dDiameterRounding);
//			bm.addTool(drRound);
			if(sModel=="RICON S 200/60 VS")
			{ 
			// apply directional drills
				Point3d ptDrill=ptTopMilling-vecXmilling*(dMillingHeightFemale-U(40));
				if(dMillingHeightFemale<dEps)
					ptDrill=ptTopMilling-vecXmilling*(U(210)-U(40));
				ptDrill.vis(3);
				Drill drRound(ptDrill,ptDrill+vecZmilling*(dMillingDepthFemale+U(1.5)),.5*dDiameterRounding);
				drRound.cuttingBody().vis(4);
				bm.addTool(drRound);
			}
		}
		
		// Drill
		Map mapDrills = mapModel.getMap("DrillFemale[]");
		if(!bIsBaufritz)
		for (int idr=0;idr<mapDrills.length();idr++) 
		{ 
			Map mapDrillI = mapDrills.getMap(idr);
			Point3d ptDrill;
			if(mapDrillI.hasDouble("TopDrill"))
			{ 
				ptDrill=ptPart+vecXmilling*(.5*dLengthPart-mapDrillI.getDouble("TopDrill"));
			}
			else if(mapDrillI.hasDouble("BottomDrill"))
			{ 
				ptDrill=ptPart-vecXmilling*(.5*dLengthPart-mapDrillI.getDouble("BottomDrill"));
			}
//			ptDrill += vecZmilling * dDepthMilling;
			if(mapDrillI.hasDouble("SideAxis"))
			{ 
				ptDrill += mapDrillI.getDouble("SideAxis") * vecYmilling;
			}
			ptDrill.vis(4);
			double dLengthDrillI = mapDrillI.getDouble("Length");
			double dDiameterDrillI = mapDrillI.getDouble("Diameter");
			Drill dr(ptDrill,ptDrill+vecZmilling*dLengthDrillI,.5*dDiameterDrillI);
			bm.addTool(dr);
		}//next idr
		
	}
	else if(bModeMale)
	{
		ptTopMilling.vis(3);
		ptPart=ptTopMilling-vecXmilling*(dCoverMilling+.5*dLengthPart);
		vecZmilling *= -1;
		vecYmilling *= -1;
		if(dMillingHeightMale>dEps && dMillingWidthMale>dEps && dMillingDepthMale>dEps)
		{ 
			Point3d _ptTopMilling=ptTopMilling-vecXmilling*(dMillingHeightFemale-.5*dMillingHeightMale);
//			ptTopMilling-=vecXmilling*(dMillingHeightFemale-.5*dMillingHeightMale);
			
			
			House hs(_ptTopMilling,vecXmilling, vecYmilling, vecZmilling,
			  dMillingHeightMale,dMillingWidthMale,dMillingDepthMale,0,0,1);
//			hs.setRoundType(_kExplicitRadius);
//			hs.setRoundType(_kNotRound);
//			hs.setExplicitRadius(dRadiusMilling);
			hs.setRoundType(_kRelief);
            hs.setEndType(_kFemaleEnd);
            hs.cuttingBody().vis(3);
            
			bm0.addTool(hs);
			ptPart+=vecZmilling*dMillingDepthMale;
			// add roundings
			if(bIsBaufritz)
			{ 
			// 
//				_ptTopMilling+=vecXmilling*.5*dMillingHeightMale;
//				Point3d ptDrill=_ptTopMilling-vecXmilling*dMillingHeightMale;
//				ptDrill-=.5*dMillingWidthMale*vecYmilling;
//				Vector3d vecMove=vecYmilling+vecXmilling;vecMove.normalize();
//				ptDrill += vecMove * .5 * dDiameterRounding;
//				ptDrill.vis(2);
//				Drill drRound(ptDrill,ptDrill+vecZmilling*dMillingDepthMale,.5*dDiameterRounding);
//				bm0.addTool(drRound);
//			// 
//				ptDrill=_ptTopMilling-vecXmilling*dMillingHeightMale;
//				ptDrill+=.5*dMillingWidthMale*vecYmilling;
//				ptDrill.vis(2);
//				vecMove=-vecYmilling+vecXmilling;vecMove.normalize();
//				vecMove.vis(ptDrill);
//				ptDrill += vecMove * .5 * dDiameterRounding;
//				ptDrill.vis(2);
//				drRound=Drill(ptDrill,ptDrill+vecZmilling*dMillingDepthMale,.5*dDiameterRounding);
//				bm0.addTool(drRound);
//			//	
//				ptDrill=_ptTopMilling;
//				ptDrill+=.5*dMillingWidthMale*vecYmilling;
//				ptDrill.vis(2);
//				vecMove=-vecYmilling-vecXmilling;vecMove.normalize();
//				vecMove.vis(ptDrill);
//				ptDrill += vecMove * .5 * dDiameterRounding;
//				ptDrill.vis(2);
//				drRound=Drill(ptDrill,ptDrill+vecZmilling*dMillingDepthMale,.5*dDiameterRounding);
//				bm0.addTool(drRound);
//				
//				ptDrill=_ptTopMilling;
//				ptDrill-=.5*dMillingWidthMale*vecYmilling;
//				ptDrill.vis(2);
//				vecMove=+vecYmilling-vecXmilling;vecMove.normalize();
//				vecMove.vis(ptDrill);
//				ptDrill += vecMove * .5 * dDiameterRounding;
//				ptDrill.vis(2);
//				drRound=Drill(ptDrill,ptDrill+vecZmilling*dMillingDepthMale,.5*dDiameterRounding);
//				bm0.addTool(drRound);
//				if(sModel=="RICON S 200/60 VS")
//				{ 
//				// apply directional drills
//					Point3d ptDrill=_ptTopMilling-vecXmilling*(U(40));
//					Drill drRound(ptDrill,ptDrill+vecZmilling*(dMillingDepthMale+U(1.5)),.5*dDiameterRounding);
//					bm0.addTool(drRound);
//				}
			}
			
			
		}
		vecZmilling.vis(ptTopMilling);
		if (bIsBaufritz)
		{
			if(sModel=="RICON S 200/60 VS")
			{ 
				Point3d _ptTopMilling=ptTopMilling-vecXmilling*(dMillingHeightFemale-.5*dMillingHeightMale);
				if(dMillingHeightFemale<dEps)
					_ptTopMilling=ptTopMilling-vecXmilling*(U(210)-.5*dMillingHeightMale);
				_ptTopMilling+=vecXmilling*.5*dMillingHeightMale;
				if(dMillingHeightMale<dEps)
					_ptTopMilling += vecXmilling*dLengthPart;
				Point3d ptDrill=_ptTopMilling-vecXmilling*(U(40));
				ptDrill.vis(3);
				Drill drRound(ptDrill,ptDrill+vecZmilling*(dMillingDepthMale+U(1.5)),.5*dDiameterRounding);
				drRound.cuttingBody().vis(4);
				bm0.addTool(drRound);
			}
		}
		vecZmilling *= -1;
		vecYmilling *= -1;
		ptPart.vis(2);
		vecZpart=vecZmilling;
//		ptPart+=vecZmilling * dDepthMilling;
		Map mapDrills = mapModel.getMap("DrillMale[]");
		if(!bIsBaufritz)
		for (int idr=0;idr<mapDrills.length();idr++) 
		{ 
			Map mapDrillI = mapDrills.getMap(idr);
			Point3d ptDrill;
			if(mapDrillI.hasDouble("TopDrill"))
			{ 
				ptDrill=ptPart+vecXmilling*(.5*dLengthPart-mapDrillI.getDouble("TopDrill"));
			}
			else if(mapDrillI.hasDouble("BottomDrill"))
			{ 
				ptDrill=ptPart-vecXmilling*(.5*dLengthPart-mapDrillI.getDouble("BottomDrill"));
			}
			if(mapDrillI.hasDouble("SideAxis"))
			{ 
				ptDrill += mapDrillI.getDouble("SideAxis") * vecYmilling;
			}
//			ptDrill += vecZmilling * dDepthMilling;
			ptDrill.vis(4);
			double dLengthDrillI = mapDrillI.getDouble("Length");
			double dDiameterDrillI = mapDrillI.getDouble("Diameter");
			Drill dr(ptDrill,ptDrill-vecZmilling*dLengthDrillI,.5*dDiameterDrillI);
			bm0.addTool(dr);
		}//next idr
	}
}

sScrew = sFixture;
sScrew1 = sFixture1;
//# nebenträger
int nFixture=sFixtures.find(sFixture);
// hauptträger
int nFixture1=sFixtures1.find(sFixture1);

//region prepare hardware 
 // Hardware for the main part
 
// collect existing hardware
	HardWrComp hwcs[] = _ThisInst.hardWrComps();
	
// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
	for (int i=hwcs.length()-1; i>=0 ; i--) 
		if (hwcs[i].repType() == _kRTTsl)
			hwcs.removeAt(i); 

// declare the groupname of the hardware components
	Beam bmThis=bm0;
	if(!bModeMale)bmThis=bm;
	
	String sHWGroupName;
	// set group name
	{ 
	// element
		// try to catch the element from the parent entity
		Element elHW =bm0.element(); 
		// check if the parent entity is an element
		if (!elHW.bIsValid())	elHW = (Element)bmThis;
		if (elHW.bIsValid()) 	sHWGroupName=elHW.elementGroup().name();
	// loose
		else
		{
			Group groups[] = _ThisInst.groups();
			if (groups.length()>0)	sHWGroupName=groups[0].name();
		}		
	}
//End prepare hardware //endregion

//region Tag Display
// HSB-24279: Trigger ShowTag
	int bShowTag = _Map.getInt("ShowTag");
	
	if(bIsBaufritz)
	{ 
		if (!_Map.hasInt("ShowTag"))
		{ 
			bShowTag = true;
			_Map.setInt("ShowTag", true);
		}
		String sTriggerShowTag =bShowTag?T("../|Hide Badge|"):T("../|Show Badge|");
		addRecalcTrigger(_kContext, sTriggerShowTag);
		if (_bOnRecalc && _kExecuteKey==sTriggerShowTag)
		{
			bShowTag = bShowTag ? false : true;
			_Map.setInt("ShowTag", bShowTag);		
			setExecutionLoops(2);
			return;
		}
	}
//endregion Tag Display

Body bdPart;
// draw part
if(!bModeMale)
{ 
	// main beam
	sFixture.setReadOnly(_kHidden);
	// 
	bdPart = bdPartStud;
	CoordSys csAlign;
	ptPart.vis(6);
	csAlign.setToAlignCoordSys(_Pt0,_XW,_YW,_ZW,ptPart,vecXpart,vecYpart,vecZpart);
	bdPart.transformBy(csAlign);
	bdPart.vis(3);
	
	if(0)
	{ 
		Element elHW =_ThisInst.element(); 
		String sHWGroupName;
		sHWGroupName=elHW.elementGroup().name();
		HardWrComp hwcs[0];
		int nCount = 1;
		HardWrComp hwc(sModel,nCount); // the articleNumber and the quantity is mandatory		
		hwc.setManufacturer(sManufacturer);
		hwc.setModel(sModel);
		hwc.setName(sFamily);
		hwc.setDescription(T("|Nail|"));
		hwc.setMaterial("Stahl verzinkt");
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(_ThisInst);	
		hwc.setCategory(T("|Connector|"));
		hwc.setNotes(T("|Werk|"));
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		hwc.setCountType(_kCTAmount);
		hwc.setDScaleX(dLengthMilling);
		hwc.setDScaleY(dWidthMilling);
		hwc.setDScaleZ(dDepthMilling);
		
		hwcs.append(hwc);
	}
	if(nFixture1>0 && bIsBaufritz)
	{ 
		HardWrComp hwc1(sScrew,32); // the articleNumber and the quantity is mandatory		
		hwc1.setManufacturer(sManufacturer);
		hwc1.setModel(sModel);
		hwc1.setName(sFamily);
		hwc1.setDescription(T("|Screw|"));
		hwc1.setMaterial("Stahl verzinkt");
		hwc1.setGroup(sHWGroupName);
		hwc1.setLinkedEntity(_ThisInst);	
		hwc1.setCategory(T("|Fixtures|"));
		hwc1.setNotes(T("|Werk|"));
		hwc1.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		hwc1.setCountType(_kCTAmount);
		hwc1.setDScaleX(dLengthMilling);
		hwc1.setDScaleY(dWidthMilling);
		hwc1.setDScaleZ(dDepthMilling);
		
		hwcs.append(hwc1);
	}
	else
	{ 
		for (int i=0;i<mapNailFemales.length();i++) 
		{ 
			Map m=mapNailFemales.getMap(i);
			int nQty=m.getInt("Quantity");
			String sArticleNr=m.getString("ArticleNumber");
			
			HardWrComp hwc(sArticleNr, nQty); // the articleNumber and the quantity is mandatory
		
			hwc.setManufacturer(sManufacturer);
			
//			hwc.setModel(sModel);
//			hwc.setName(sFamily);
	//			hwc.setDescription(sHWDescription);
			String sHWMaterial="Stahl verzinkt";
			hwc.setMaterial(sHWMaterial);
//			hwc.setNotes(T("|Werk|"));
			
			hwc.setGroup(sHWGroupName);
			hwc.setLinkedEntity(bm0);	
			hwc.setCategory(T("|Fixtures|"));
			hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
			
//			hwc.setDScaleX(dLengthMilling);
//			hwc.setDScaleY(dWidthMilling);
//			hwc.setDScaleZ(dDepthMilling);
			
		// apppend component to the list of components
			hwcs.append(hwc);
		}//next i
		// add articles of two screws at DrillFemale[]
		Map mapDrills = mapModel.getMap("DrillFemale[]");
		for (int i=0;i<mapDrills.length();i++) 
		{ 
			Map m=mapDrills.getMap(i);
			if(!m.hasString("ArticleNumber"))
			{ 
				continue;
			}
			String sArticleNr=m.getString("ArticleNumber");
			HardWrComp hwc(sArticleNr, 1); // the articleNumber and the quantity is mandatory
		
			hwc.setManufacturer(sManufacturer);
			
//			hwc.setModel(sModel);
//			hwc.setName(sFamily);
	//			hwc.setDescription(sHWDescription);
			String sHWMaterial="Stahl verzinkt";
			hwc.setMaterial(sHWMaterial);
//			hwc.setNotes(T("|Werk|"));
			
			hwc.setGroup(sHWGroupName);
			hwc.setLinkedEntity(bm0);	
			hwc.setCategory(T("|Fixtures|"));
			hwc.setRepType(_kRTTsl);
			hwcs.append(hwc);
		}//next i
	}
	//BF-06032024 component labeling
	if(bIsBaufritz && bShowTag)// HSB-24279
	{ 
		Point3d ptText = ptPart + vecYmilling* U(150);
		
		if (_PtG.length()<1)
			_PtG.append(ptText);
				
		PLine plText(ptPart, _PtG[0]);
		String strTxt = "1x " + sModel + ",\n 32x " + sScrew;
		Display dp1(3);
		dp1.dimStyle("BF 1.0");
		dp1.textHeight(U(40));
		dp1.addHideDirection(-vecZ);
		dp1.draw(strTxt,_PtG[0],  -vecYmilling, -vecZmilling, 0, 1);
		dp1.draw(plText);
		
//		if(0)
		
	}
}
else if(bModeMale)
{ 
	// secondary beam, nebenträger
	sFixture1.setReadOnly(_kHidden);
	bdPart=bdPartBeam;
	CoordSys csAlign;
	ptPart.vis(6);
	csAlign.setToAlignCoordSys(_Pt0,_XW,_YW,_ZW,ptPart,vecXpart,vecYpart,vecZpart);
	bdPart.transformBy(csAlign);
	bdPart.vis(3);
	
	if(nFixture>0 && bIsBaufritz)
	{ 
		HardWrComp hwc1(sScrew1,32); // the articleNumber and the quantity is mandatory		
		hwc1.setManufacturer(sManufacturer);
		hwc1.setModel(sModel);
		hwc1.setName(sFamily);
		hwc1.setDescription(T("|Screw|"));
		hwc1.setMaterial("Stahl verzinkt");
		hwc1.setGroup(sHWGroupName);
		hwc1.setLinkedEntity(_ThisInst);	
		hwc1.setCategory(T("|Fixtures|"));
		hwc1.setNotes(T("|Werk|"));
		hwc1.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		hwc1.setCountType(_kCTAmount);
		hwc1.setDScaleX(dLengthMilling);
		hwc1.setDScaleY(dWidthMilling);
		hwc1.setDScaleZ(dDepthMilling);
		
		hwcs.append(hwc1);
	}
	else
	{ 
		for (int i=0;i<mapNailMales.length();i++) 
		{ 
			Map m=mapNailMales.getMap(i);
			int nQty=m.getInt("Quantity");
			String sArticleNr=m.getString("ArticleNumber");
			
			HardWrComp hwc(sArticleNr, nQty); // the articleNumber and the quantity is mandatory
		
			hwc.setManufacturer(sManufacturer);
			
//			hwc.setModel(sModel);
//			hwc.setName(sFamily);
	//			hwc.setDescription(sHWDescription);
			String sHWMaterial="Stahl verzinkt";
			hwc.setMaterial(sHWMaterial);
//			hwc.setNotes(T("|Werk|"));
			
			hwc.setGroup(sHWGroupName);
			hwc.setLinkedEntity(bm0);	
			hwc.setCategory(T("|Fixtures|"));
			hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
			
//			hwc.setDScaleX(dLengthMilling);
//			hwc.setDScaleY(dWidthMilling);
//			hwc.setDScaleZ(dDepthMilling);
			
		// apppend component to the list of components
			hwcs.append(hwc);
		}//next i
		// add articles of two screws at DrillMale[]
		Map mapDrills = mapModel.getMap("DrillMale[]");
		for (int i=0;i<mapDrills.length();i++) 
		{ 
			Map m=mapDrills.getMap(i);
			if(!m.hasString("ArticleNumber"))
			{ 
				continue;
			}
			String sArticleNr=m.getString("ArticleNumber");
			HardWrComp hwc(sArticleNr, 1); // the articleNumber and the quantity is mandatory
		
			hwc.setManufacturer(sManufacturer);
			
//			hwc.setModel(sModel);
//			hwc.setName(sFamily);
	//			hwc.setDescription(sHWDescription);
			String sHWMaterial="Stahl verzinkt";
			hwc.setMaterial(sHWMaterial);
//			hwc.setNotes(T("|Werk|"));
			
			hwc.setGroup(sHWGroupName);
			hwc.setLinkedEntity(bm0);	
			hwc.setCategory(T("|Fixtures|"));
			hwc.setRepType(_kRTTsl);
			hwcs.append(hwc);
		}//next i
	}
	//BF-06032024 component labeling
	if(bIsBaufritz && bShowTag)// HSB-24279
	{ 
		Point3d ptText=ptPart-vecYmilling*U(450)-vecZmilling*U(75);
		
		if (_PtG.length()<1)
			_PtG.append(ptText);
				
		PLine plText(ptPart, _PtG[0]);
		String strTxt = "1x " + sModel + ",\n 32x " + sScrew1;
		Display dp1(3);
		dp1.dimStyle("BF 1.0");
		dp1.textHeight(U(40));
		dp1.addHideDirection(-vecZ);
		dp1.draw(strTxt,_PtG[0],-vecZmilling, vecYmilling, 0, 1);
		dp1.draw(plText);
		
		if(0)
		{ 
			Element elHW =_ThisInst.element(); 
			String sHWGroupName;
			sHWGroupName=elHW.elementGroup().name();
			HardWrComp hwcs[0];
			int nCount = 1;
			HardWrComp hwc(sModel,nCount); // the articleNumber and the quantity is mandatory		
			hwc.setManufacturer(sManufacturer);
			hwc.setModel(sModel);
			hwc.setName(sFamily);
			hwc.setDescription(T("|Nail|"));
			hwc.setMaterial("Stahl verzinkt");
			hwc.setGroup(sHWGroupName);
			hwc.setLinkedEntity(_ThisInst);	
			hwc.setCategory(T("|Connector|"));
			hwc.setNotes(T("|Werk|"));
			hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
			hwc.setCountType(_kCTAmount);
			hwc.setDScaleX(dLengthMilling);
			hwc.setDScaleY(dWidthMilling);
			hwc.setDScaleZ(dDepthMilling);
			
			hwcs.append(hwc);
		}
	}
}


// Hardware//region

	
// add main componnent
	{ 
		HardWrComp hwc(sModel, 1); // the articleNumber and the quantity is mandatory
		
		hwc.setManufacturer(sManufacturer);
		
		hwc.setModel(sModel);
		hwc.setName(sFamily);
//			hwc.setDescription(sHWDescription);
		String sHWMaterial="Stahl verzinkt";
		hwc.setMaterial(sHWMaterial);
		hwc.setNotes(T("|Werk|"));
		
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(bm0);	
		hwc.setCategory(T("|Connector|"));
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		
		hwc.setDScaleX(dLengthMilling);
		hwc.setDScaleY(dWidthMilling);
		hwc.setDScaleZ(dDepthMilling);
		
	// apppend component to the list of components
		hwcs.append(hwc);
	}

// make sure the hardware is updated
	if (_bOnDbCreated)	setExecutionLoops(2);				
	_ThisInst.setHardWrComps(hwcs);	
//endregion

Display dp(7);
dp.color(nColor);
dp.draw(bdPart);







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
        <int nm="BreakPoint" vl="1694" />
        <int nm="BreakPoint" vl="1728" />
        <int nm="BreakPoint" vl="1691" />
        <int nm="BreakPoint" vl="1380" />
        <int nm="BreakPoint" vl="1274" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24279: Add trigger &quot;Show Tag&quot; for baufritz" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="7/9/2025 8:56:23 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23069: Fix bug at drill" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="2/5/2025 5:12:34 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21590: Add property for the fixtures, screwa" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="3/11/2024 2:55:09 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17934: Initialize properties from xml only if they are not set in the properties" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="2/13/2023 8:56:15 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15937: Replace Mortise with house" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="7/8/2022 9:01:31 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15937: Expose xml parameters in properties" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="7/7/2022 10:18:49 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15731: initial" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="6/14/2022 6:01:04 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End