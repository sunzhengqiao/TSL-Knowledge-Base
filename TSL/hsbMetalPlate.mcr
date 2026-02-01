#Version 8
#BeginDescription
1.0 12.05.2021 HSB-11670: initial Author: Marsel Nakuci


This tsl creates metal plates that can connect 2 or 3 genbeams
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
//region <History>
// #Versions
// Version 1.0 12.05.2021 HSB-11670: initial Author: Marsel Nakuci

/// <insert Lang=en>
/// Select entities
/// </insert>

// <summary Lang=en>
// This tsl creates metal plates that can connect 2 or 3 genbeams
// 
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbMetalPlate")) TSLCONTENT
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
	String sFileName ="MetalPlateCatalog";
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
	
	String sManufacturers[0];
	sManufacturers.append("---");
	{ 
		// get the models of this family and populate the property list
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
	
//region Properties
	category = T("|Component|");
	// Manufacturer
	String sManufacturerName=T("|Manufacturer|");	
	PropString sManufacturer(nStringIndex++, sManufacturers, sManufacturerName);
	sManufacturer.setDescription(T("|Defines the Manufacturer|"));
	sManufacturer.setCategory(category);
	// Family
	String sFamilys[0];
	sFamilys.append("---");
	String sFamilyName=T("|Family|");	
	PropString sFamily(nStringIndex++, "", sFamilyName);	
	sFamily.setDescription(T("|Defines the Family|"));
	sFamily.setCategory(category);
	// Product
	String sProducts[0];
	sProducts.append("---");
	String sProductName=T("|Product|");
	PropString sProduct(nStringIndex++, "", sProductName);
	sProduct.setDescription(T("|Defines the Product|"));
	sProduct.setCategory(category);
// insertion mode	
	category = T("|Insertion Mode|");
	String sModeInsertName=T("|Mode|");	
	String sModeInserts[] ={ T("|Single|"), T("|Multiple|")};
	PropString sModeInsert(nStringIndex++, sModeInserts, sModeInsertName);	
	sModeInsert.setDescription(T("|Defines the ModeInsert|"));
	sModeInsert.setCategory(category);
	// this property only in insertion for distribution
	category = T("|Alignment|");
	String sFaceName=T("|Face|");	
	String sFaces[] ={ T("|View Direction|"), T("|Normal to View Direction|"), T("|All|")};
	PropString sFace(nStringIndex++, sFaces, sFaceName);	
	sFace.setDescription(T("|Defines the Face|"));
	sFace.setCategory(category);
	// side
	String sSideName = T("|Side|");
	String sSides[] ={ T("|One|"), T("|Both|") };
	PropString sSide(nStringIndex++, sSides, sSideName);
	sSide.setDescription(T("|Defines the Side|"));
	sSide.setCategory(category);
	// offset
	String sOffsetLengthName=T("|Offset Length|");	
	PropDouble dOffsetLength(nDoubleIndex++, U(0), sOffsetLengthName);	
	dOffsetLength.setDescription(T("|Defines the OffsetLength|"));
	dOffsetLength.setCategory(category);
	String sOffsetWidthName=T("|Offset Width|");	
	PropDouble dOffsetWidth(nDoubleIndex++, U(0), sOffsetWidthName);	
	dOffsetWidth.setDescription(T("|Defines the OffsetWidth|"));
	dOffsetWidth.setCategory(category);
	// rotation
	String sRotateName=T("|Rotate|");	
	PropDouble dRotate(nDoubleIndex++, U(0), sRotateName);	
	dRotate.setDescription(T("|Defines the Rotate|"));
	dRotate.setCategory(category);
	
	// nr parts to be joined
//	String sNrPartsName=T("|NrParts|");	
//	int nNrPartss[]={2,3};
//	PropInt nNrParts(nIntIndex++, nNrPartss, sNrPartsName);	
//	nNrParts.setDescription(T("|Defines the NrParts|"));
//	nNrParts.setCategory(category);
	
	String sTypeName=T("|Type|");	
	String sTypes[] ={ T("|2 Genbeams|"), T("|3 Genbeams|")};
	PropString sType(nStringIndex++, sTypes, sTypeName);	
	sType.setDescription(T("|Defines the Type|"));
	sType.setCategory(category);
	// multiple insertion
	//multiple mode; single mode
	
	//side for multiple mode -> side in view orientation; side normal with view orientation
	// side 1, both
	
//End Properties//endregion 
	
//region jig
	String strJigAction1 = "strJigAction1";
	if (_bOnJig && _kExecuteKey==strJigAction1) 
	{ 
		Point3d ptJig = _Map.getPoint3d("_PtJig");
		Vector3d vecView = getViewDirection();
		Map mapCouples = _Map.getMap("mapCouples");
		
//		Display dp(252);
		Display dp(2);
		Display dpHighlight(3);
		for (int i=0;i<mapCouples.length();i++) 
		{ 
			Map mapI = mapCouples.getMap(i);
			PlaneProfile pp1 = mapI.getPlaneProfile("pp1");
			PlaneProfile pp2 = mapI.getPlaneProfile("pp2");
			Entity ent1= mapI.getEntity("ent1");
			Entity ent2= mapI.getEntity("ent2");
			GenBeam gb1 = (GenBeam)ent1;
			GenBeam gb2 = (GenBeam)ent2;
			Point3d ptCenPart=mapI.getPoint3d("ptCenPart");
			PlaneProfile ppPart = mapI.getPlaneProfile ("ppPart");
			if (ppPart.coordSys().vecZ().dotProduct(vecView)<0)continue;
			dp.draw(ppPart, _kDrawFilled);
			Plane pn(pp1.coordSys().ptOrg(), pp1.coordSys().vecZ());
			Point3d ptJigPn= ptJig.projectPoint(pn, dEps, vecView);
			if(ppPart.pointInProfile(ptJigPn)==_kPointInProfile)
					dpHighlight.draw(ppPart, _kDrawFilled, 60);
//			dp.draw(pp1, _kDrawFilled);
//			dp.draw(pp2, _kDrawFilled);
			dp.color(1);
			dp.textHeight(U(100));
//			dp.draw("cen", ptCenPart, _XW, _YW, 0, 0, _kDeviceX);
			dp.color(2);
		}//next i
		
//		dp.draw("ss", ptJig, _XW, _YW, 0, 0, _kDeviceX);
		return
	}
//End jig//endregion 
//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }

	// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select Genbeams|"), GenBeam());
		if (ssE.go())
			ents.append(ssE.set());
		
		GenBeam gbs[0];
		for (int i=0;i<ents.length();i++) 
		{ 
			GenBeam gbI = (GenBeam) ents[i];
			if(gbs.find(gbI)<0 && gbI.bIsValid())
				gbs.append(gbI);
		}//next i
		// get opm key from the _kExecuteKey
		String sTokens[] = _kExecuteKey.tokenize("?");
		
		// load properties from catalogue if a catalogue is choosen
		// if executekey is a catalogue then load properties from this catalogue
		// catalogue should not be a manufacturer
		int iCatalog = false;
		if (sTokens.length() == 1 && _kExecuteKey.length() > 0)
		{
	//		reportNotice("\n _kExecuteKey " + _kExecuteKey);
	//		String files[] = getFilesInFolder(_kPathHsbCompany + "\\tsl\\catalog\\", scriptName() + " * .xml");
	//		for (int i = 0; i < files.length(); i++)
	//		{
	//			String entry = files[i].left(files[i].length() - 4);
	//			reportNotice("\n files " + entry);
	//			String sEntries[] = TslInst().getListOfCatalogNames(entry);
	//			
	//			reportNotice("\n using sEntries " + sEntries);
	//			if (sEntries.findNoCase(_kExecuteKey ,- 1) >- 1)
	//			{
	//				Map map = _ThisInst.mapWithPropValuesFromCatalog(entry, _kExecuteKey);
	//				setPropValuesFromMap(map);
	//				
	//				reportNotice("\n using map " + map);
	//				break;
	//			}
	//		}//next i
	
			// silent/dialog
			if (_kExecuteKey.length() > 0)
			{
				String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
				if (sEntries.findNoCase(_kExecuteKey ,- 1) >- 1)
				{
					if(sManufacturers.find(sTokens[0])<0)
					{
						setPropValuesFromCatalog(_kExecuteKey);
						iCatalog = true;
					}
				}
			}
		}
		
		if(!iCatalog)
		{
			String sOpmKey;
			if (sTokens.length() > 0)
			{
				sOpmKey = sTokens[0];
			}
			else
			{
				sOpmKey = "";
			}
			// get the Manufacturer from the _kExecuteKey or from the dialog box
			// validate the opmkeys, should be one of the Manufacturers supported
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
						//					setOPMKey(sManufacturers[i]);
						sManufacturer.setReadOnly(true);
						break;
					}
				}//next i
				// the opmKey does not match any family name -> reset
				if ( ! bOk)
				{
					reportNotice("\n" + scriptName() + ": " + T("|NOTE, the specified OPM key| '") +sOpmKey+T("' |cannot be found in the list of Manufacturers.|"));
					sOpmKey = "";
				}
			}
			else
			{
				// sOpmKey not specified, show the dialog
				sManufacturer.setReadOnly(false);
				if (sManufacturers.length() > 0)sManufacturer.set(sManufacturers[1]);
				sFamily.set("---");
				sFamily.setReadOnly(true);
				sProduct.set("---");
				sProduct.setReadOnly(true);
				// alignment
//	//			sAlignment.setReadOnly(false);
//				sAlignment.setReadOnly(_kHidden);
//				dAngle.setReadOnly(false);
//				dGapNail.setReadOnly(false);
//	//			nZone.setReadOnly(_kHidden);
//				// Drill
//				sModeDistribution.setReadOnly(false);
//				dDistanceBottom.setReadOnly(false);
//				dDistanceTop.setReadOnly(false);
//				dDistanceBetween.setReadOnly(false);
				showDialog("---");
				//			setOPMKey(sManufacturer);
				//			sOpmKey = sManufacturer;
			}
		
			// from the mapSetting get all the defined families
			if (sManufacturer != "---")
			{
				if (mapSetting.length() > 0)
				{
					Map mapManufacturers = mapSetting.getMap("Manufacturer[]");
					if (mapManufacturers.length() < 1)
					{
						// wrong definition of the map
						reportMessage(TN("|wrong definition of the map, no Manufacturer|"));
						eraseInstance();
						return;
					}
					// find choosen Manufacturer
					for (int i = 0; i < mapManufacturers.length(); i++)
					{
						Map mapManufacturerI = mapManufacturers.getMap(i);
						if (mapManufacturerI.hasString("Name") && mapManufacturers.keyAt(i).makeLower() == "manufacturer")
						{
							String _sManufacturerName = mapManufacturerI.getString("Name");
							if (_sManufacturerName.makeUpper() != sManufacturer.makeUpper())
							{
								// not this family, keep looking
								continue;
							}
						}
						else
						{
							// not a Manufacturer map
							continue;
						}
						
						// map of the selected Manufacturer is found
						// get its families
						Map mapFamilys = mapManufacturerI.getMap("Family[]");
						if (mapFamilys.length() < 1)
						{
							// wrong definition of the map
							reportMessage(TN("|no Family definition for this manufacturer|"));
							eraseInstance();
							return;
						}
						for (int j = 0; j < mapFamilys.length(); j++)
						{
							Map mapFamilyJ = mapFamilys.getMap(j);
							if (mapFamilyJ.hasString("Name") && mapFamilys.keyAt(j).makeLower() == "family")
							{
								String sName = mapFamilyJ.getString("Name");
								if (sFamilys.find(sName) < 0)
								{
									// populate sFamilies
									sFamilys.append(sName);
									if (bDebug)reportMessage("\n" + scriptName() + " sName: " + sName);
								}
							}
						}
						
						// set the Family
						if (sTokens.length() < 2)//Family not defined in opmkey, showdialog
						{
							// set array of sFamilys and get the first by default
							// manufacturer is set, set as readOnly
							sManufacturer.setReadOnly(true);
							sFamily.setReadOnly(false);
							sFamily = PropString(1, sFamilys, sFamilyName, 0);
							sFamily.set(sFamilys[0]);
							if (sFamilys.length() > 0)sFamily.set(sFamilys[1]);
							sProduct = PropString(2, sProducts, sProductName, 0);
							sProduct.set("---");
							sProduct.setReadOnly(true);
							//
//							sAlignment.setReadOnly(_kHidden);
//							dAngle.setReadOnly(false);
//							dGapNail.setReadOnly(false);
//	//						nZone.setReadOnly(_kHidden);
//							// distribution
//							sModeDistribution.setReadOnly(false);
//							dDistanceBottom.setReadOnly(false);
//							dDistanceTop.setReadOnly(false);
//							dDistanceBetween.setReadOnly(false);
							showDialog("---");
							//					showDialog();

						}
						else
						{
							// see if sTokens[1] is a valid Family name as in sFamilys from mapSetting
							int indexSTokens = sFamilys.find(sTokens[1]);
							if (indexSTokens >- 1)
							{
								// find
								//				sFamily = PropString(1, sFamilys, sFamilyName, indexSTokens);
								sFamily.set(sTokens[1]);
								if (bDebug)reportMessage("\n" + scriptName() + " from tokens ");
							}
							else
							{
								// wrong definition in the opmKey, accept the first Family from the xml
								reportMessage(TN("|wrong definition of the OPM key|"));
								sFamily.set(sFamilys[0]);
								if (sFamilys.length() > 0)sFamily.set(sFamilys[1]);
							}
						}
						if (sFamily != "---")
						{
							// for the chosen family get Familys and nails. first find the map of selected family
							for (int j = 0; j < mapFamilys.length(); j++)
							{
								Map mapFamilyJ = mapFamilys.getMap(j);
								if (mapFamilyJ.hasString("Name") && mapFamilys.keyAt(j).makeLower() == "family")
								{
									String _sFamilyName = mapFamilyJ.getString("Name");
									if (_sFamilyName.makeUpper() != sFamily.makeUpper())
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
								
								// mapFamilyJ is found, populate types and nails
								// map of the selected Family is found
								// get its types
								Map mapProducts = mapFamilyJ.getMap("Product[]");
								if (mapProducts.length() < 1)
								{
									// wrong definition of the map
									reportMessage(TN("|no Product definition for this family|"));
									eraseInstance();
									return;
								}
								
								for (int k = 0; k < mapProducts.length(); k++)
								{
									Map mapProductK = mapProducts.getMap(k);
									//								if (mapProductK.hasString("Name") && mapProducts.keyAt(k).makeLower() == "product")
									if (mapProductK.hasString("Name") && mapProducts.keyAt(k).makeLower() == "product")
									{
										//									String sName = mapProductK.getString("Name");
										String sName = mapProductK.getString("Name");
										if (sProducts.find(sName) < 0)
										{
											// populate sProducts
											sProducts.append(sName);
											if (bDebug)reportMessage("\n" + scriptName() + " sName: " + sName);
										}
									}
								}
								
								// set the family
								if (sTokens.length() < 3)
								{
									// Product not set in opm key, show the dialog to get the opm key
									// set array of sProducts and get the first by default
									// family is set, set as readOnly
									sManufacturer.setReadOnly(true);
									sFamily.setReadOnly(true);
									
									sProduct.setReadOnly(false);
									sProduct = PropString(2, sProducts, sProductName, 0);
									sProduct.set(sProducts[0]);
									if (sProducts.length() > 0)sProduct.set(sProducts[1]);
									// Alignment
//									sAlignment.setReadOnly(_kHidden);
//									dAngle.setReadOnly(false);
//									dGapNail.setReadOnly(false);
//	//								nZone.setReadOnly(_kHidden);
//									// distribution
//									sModeDistribution.setReadOnly(false);
//									dDistanceBottom.setReadOnly(false);
//									dDistanceTop.setReadOnly(false);
//									dDistanceBetween.setReadOnly(false);
									showDialog("---");
									//						showDialog();
									if (bDebug)reportMessage("\n" + scriptName() + " from dialog ");
									if (bDebug)reportMessage("\n" + scriptName() + " sProduct " + sProduct);
								}
								else
								{
									// see if sTokens[1] is a valid family name as in sFamilys from mapSetting
									int indexSTokens = sProducts.find(sTokens[1]);
									if (indexSTokens >- 1)
									{
										// find
										//				sModel = PropString(1, sModels, sModelName, indexSTokens);
										sProduct.set(sTokens[1]);
										if (bDebug)reportMessage("\n" + scriptName() + " from tokens ");
									}
									else
									{
										// wrong definition in the opmKey, accept the first family from the xml
										reportMessage(TN("|wrong definition of the OPM key|"));
										sProduct.set(sProducts[0]);
										if (sProducts.length() > 0)sProduct.set(sProducts[1]);
									}
								}
								// familys and nails are set
								break;
							}
							// family is set
							break;
						}
						else
						{
							sProduct.set(sProducts[0]);
							if (sProducts.length() > 0)sProduct.set(sProducts[1]);
							break;
						}
					}
				}
			}
			else
			{
				sFamily.set(sFamilys[0]);
				if (sFamilys.length() > 0)sFamily.set(sFamilys[1]);
				sProduct.set(sProducts[0]);
				if (sProducts.length() > 0)sProduct.set(sProducts[1]);
			}
		}
		
		int iModeInsert = sModeInserts.find(sModeInsert);
	
		if(iModeInsert==0)
		{ 
			// single instance, support jig
			// get mapProduct of choosen product
			Map mapFamily;
			Map mapProduct;
			int iFamilyFound = false;
			int iProductFound = false;
			{ 
				Map mapManufacturers = mapSetting.getMap("Manufacturer[]");
				if(sManufacturer!="---")
				{ 
					for (int i = 0; i < mapManufacturers.length(); i++)
					{ 
						Map mapManufacturerI = mapManufacturers.getMap(i);
						if (mapManufacturerI.hasString("Name") && mapManufacturers.keyAt(i).makeLower() == "manufacturer")
						{
							String _sManufacturerName = mapManufacturerI.getString("Name");
							String _sManufacturer = sManufacturer;_sManufacturer.makeUpper();
							if (_sManufacturerName.makeUpper() == _sManufacturer)
							{
								// this manufacturer
								Map mapManufacturer = mapManufacturerI;
								Map mapFamilys = mapManufacturer.getMap("Family[]");
								for (int ii = 0; ii < mapFamilys.length(); ii++)
								{
									Map mapFamilyI = mapFamilys.getMap(ii);
									if (mapFamilyI.hasString("Name") && mapFamilys.keyAt(ii).makeLower() == "family")
									{
			//							String sName = mapFamilyI.getString("Name");
										String _sFamilyName = mapFamilyI.getString("Name");
										String _sFamily = sFamily;_sFamily.makeUpper();
										if (_sFamilyName.makeUpper() == _sFamily)
										{ 
											// this family
											mapFamily = mapFamilyI;
											iFamilyFound = true;
											Map mapProducts = mapFamily.getMap("Product[]");
											for (int iii = 0; iii < mapProducts.length(); iii++)
											{ 
												Map mapProductI = mapProducts.getMap(iii);
												if (mapProductI.hasString("Name") && mapProducts.keyAt(iii).makeLower() == "product")
												{ 
													String _sProductName = mapProductI.getString("Name");
													String _sProduct = sProduct;_sProduct.makeUpper();
													if (_sProductName.makeUpper() == _sProduct)
													{ 
														mapProduct = mapProductI;
														iProductFound = true;
														break;
													}
												}
											}
											if (iProductFound)break;
										}
									}
								}
								if (iProductFound)break;
							}
						}
					}
				}
			}
			double dLengthPart = mapProduct.getDouble("Length");
			double dWidthPart = mapProduct.getDouble("Width");
			double dLengthWidthMax = dLengthPart > dWidthPart ? dLengthPart : dWidthPart;
			String sStringStart = "|Select insertion point [";
			String sOptions;
			int iType = sTypes.find(sType);
			if(iType==0)
			{ 
				sOptions = "3Genbeams]|";
			}
			else if(iType==1)
			{ 
				sOptions = "2Genbeams]|";
			}
			PrPoint ssP(sStringStart+sOptions);
			Map mapArgs;
//			mapArgs.setEntityArray(gbs,true, "gbs", "", "");
			// all possible planeprofiles
			// all maps with valid planeprofiles and their genbeams
			Map mapCouples, mapCouples2, mapCouples3;
			// +x,-x,+y,-y,+z,-z
			Body bds[0];
			PlaneProfile pps[0];
			for (int i=0;i<gbs.length();i++) 
			{ 
				GenBeam gbI = gbs[i];
				Quader qdI(gbI.ptCen(), gbI.vecX(), gbI.vecY(), gbI.vecZ(), gbI.solidLength(), gbI.solidWidth(), gbI.solidHeight());
				Body bdI = gbI.envelopeBody();
				bds.append(bdI);
				Vector3d vecsI[] ={ gbI.vecX() ,- gbI.vecX(), gbI.vecY() ,- gbI.vecY(), gbI.vecZ() ,- gbI.vecZ()};
				for (int ii=0;ii<vecsI.length();ii++) 
				{ 
					Point3d pt = gbI.ptCen() + vecsI[ii] * (.5 * qdI.dD(vecsI[ii]) - 2*dEps);
					PlaneProfile ppI = bdI.getSlice(Plane(pt, vecsI[ii]));
					pps.append(ppI);
				}//next ii
			}//next i
			
			// ppParts
			PlaneProfile ppParts[0],ppParts2[0],ppParts3[0];
			// we investigate up to "couples" of 3 genbeams
//			if(nNrParts==2)
//			if(sTypes.find(sType)==0)
			{ 
				for (int i=0;i<gbs.length();i++) 
				{ 
					for (int j=i+1;j<gbs.length();j++) 
					{
						for (int iP=0;iP<6;iP++) 
						{ 
							PlaneProfile ppI = pps[i*6+iP];
							CoordSys csI = ppI.coordSys();
							PlaneProfile ppI_ = ppI;
							ppI_.shrink(-U(20));
							PlaneProfile ppIntersect = ppI_;
							PlaneProfile ppUnion = ppI_;
						 
	//					 	reportMessage("\n" + scriptName() + " j" + j);
							for (int jP=0;jP<6;jP++) 
							{ 
								PlaneProfile ppJ = pps[j*6+jP];
								CoordSys csJ = ppJ.coordSys();
								// check if planes codirectional
								if (!csI.vecZ().isCodirectionalTo(csJ.vecZ()))continue;
								// check if in same plane
								if (abs(csI.vecZ().dotProduct(csI.ptOrg() - csJ.ptOrg())) > dEps)continue;
								// check if intersect
								
								PlaneProfile ppJ_ = ppJ;
								ppJ_.shrink(-U(20));
								if ( ! ppIntersect.intersectWith(ppJ_))continue;
								ppUnion.unionWith(ppJ_);
								ppIntersect = ppUnion;
								// calc ptCenPart, vecLength
								Point3d ptCenPart;
								Vector3d vecLengthPart, vecWidthPart;
								PlaneProfile ppPart(csI);
								PLine plPart();
								{ 
									PlaneProfile ppIshrink = ppI;
									ppIshrink.shrink(2*dEps);
									PlaneProfile ppJshrink = ppJ;
									ppJshrink.shrink(2*dEps);
									//
									PlaneProfile ppIextend = ppI;
									ppIextend.shrink(-2*dEps);
									PlaneProfile ppJextend = ppJ;
									ppJextend.shrink(-2*dEps);
									//
									Vector3d vecsI[] ={ gbs[i].vecX(), gbs[i].vecY(), gbs[i].vecZ()};
									// two vectors in plane of planeprofile
									Vector3d _vecsI[0];
									for (int iV=0;iV<vecsI.length();iV++) 
									{ 
										if(csI.vecZ().isParallelTo(vecsI[iV]))continue; 
										_vecsI.append(vecsI[iV]);
									}//next iV
									if(_vecsI.length()!=2)
									{ 
										reportMessage(TN("|unexpected; 2 vectors|"));
										eraseInstance();
										return;
									}
									Vector3d vecXi = _vecsI[0];
									Vector3d vecYi = _vecsI[1];
									// PlaneProfile I
									PlaneProfile ppIlongX(ppI.coordSys());
									PlaneProfile ppIlongY(ppI.coordSys());
									// get extents of profile
									LineSeg segI = ppIshrink.extentInDir(vecXi);
									double dXi = abs(vecXi.dotProduct(segI.ptStart()-segI.ptEnd()));
									double dYi = abs(vecYi.dotProduct(segI.ptStart()-segI.ptEnd()));
									PLine pl();
									pl.createRectangle(LineSeg(segI.ptMid()-.5*dXi*vecXi-U(10e3)*vecYi, 
											segI.ptMid() + .5 * dXi * vecXi + U(10e3) * vecYi), vecXi, vecYi);
									ppIlongY.joinRing(pl, _kAdd);
									pl = PLine();
									pl.createRectangle(LineSeg(segI.ptMid()-.5*dYi*vecYi-U(10e3)*vecXi, 
											segI.ptMid() + .5 * dYi * vecYi + U(10e3) * vecXi), vecXi, vecYi);
									ppIlongX.joinRing(pl, _kAdd);
									// PlaneProfile J
									// long in X direction
									PlaneProfile ppJlongX(ppJ.coordSys());
									// very long in Y direction
									PlaneProfile ppJlongY(ppJ.coordSys());
									// get extents of profile
									LineSeg segJ = ppJshrink.extentInDir(vecXi);
									double dXj = abs(vecXi.dotProduct(segJ.ptStart()-segJ.ptEnd()));
									double dYj = abs(vecYi.dotProduct(segJ.ptStart()-segJ.ptEnd()));
									pl=PLine();
									pl.createRectangle(LineSeg(segJ.ptMid()-.5*dXj*vecXi-U(10e3)*vecYi, 
											segJ.ptMid() + .5 * dXj * vecXi + U(10e3) * vecYi), vecXi, vecYi);
									ppJlongY.joinRing(pl, _kAdd);
									pl = PLine();
									pl.createRectangle(LineSeg(segJ.ptMid()-.5*dYj*vecYi-U(10e3)*vecXi, 
											segJ.ptMid() + .5 * dYj * vecYi + U(10e3) * vecXi), vecXi, vecYi);
									ppJlongX.joinRing(pl, _kAdd);
									PlaneProfile ppIntersectShrink = ppIshrink;
									if(ppIntersectShrink.intersectWith(ppJshrink))
									{ 
										ptCenPart = ppIntersectShrink.extentInDir(vecXi).ptMid();
										vecLengthPart = vecXi;
										vecWidthPart = csI.vecZ().crossProduct(vecLengthPart);
									}
									else
									{ 	
										PlaneProfile ppIlongXIntersect = ppIlongX;
										PlaneProfile ppIlongYIntersect = ppIlongY;
										if(ppIlongXIntersect.intersectWith(ppJlongX))
										{ 
											vecLengthPart = vecXi;
											vecWidthPart = csI.vecZ().crossProduct(vecLengthPart);
											// fix in Y direction
											ptCenPart = ppIlongXIntersect.extentInDir(vecXi).ptMid();
											// fix in x direction
											PLine plIJ();
											plIJ.createRectangle(LineSeg(ppI.extentInDir(vecXi).ptMid(),
													ppJ.extentInDir(vecXi).ptMid()), vecXi, vecYi);
											PlaneProfile ppIJ(ppI.coordSys());
											ppIJ.joinRing(plIJ, _kAdd);
											ppIJ.subtractProfile(ppIlongY);
											ppIJ.subtractProfile(ppJlongY);
											Point3d ptCenPartX = ppIJ.extentInDir(vecXi).ptMid();
											ptCenPart += vecXi * vecXi.dotProduct(ptCenPartX - ptCenPart);
										}
										else if(ppIlongYIntersect.intersectWith(ppJlongY))
										{ 
											vecLengthPart = vecYi;
											vecWidthPart = csI.vecZ().crossProduct(vecLengthPart);
											// fix in y direction
											ptCenPart = ppIlongYIntersect.extentInDir(vecXi).ptMid();
											// fix in x direction
											PLine plIJ();
											plIJ.createRectangle(LineSeg(ppI.extentInDir(vecXi).ptMid(),
													ppJ.extentInDir(vecXi).ptMid()), vecXi, vecYi);
											PlaneProfile ppIJ(ppI.coordSys());
											ppIJ.joinRing(plIJ, _kAdd);
											ppIJ.subtractProfile(ppIlongX);
											ppIJ.subtractProfile(ppJlongX);
											Point3d ptCenPartY = ppIJ.extentInDir(vecXi).ptMid();
											ptCenPart += vecYi * vecYi.dotProduct(ptCenPartY - ptCenPart);
										}
									}
								}
//								if(nNrParts==2)
								{ 
									// valid connection
									Map map;
									map.setPlaneProfile("pp1", ppI);
									map.setPlaneProfile("pp2", ppJ);
									map.setEntity("ent1", gbs[i]);
									map.setEntity("ent2", gbs[j]);
									map.setInt("indexVec1", iP);
									map.setInt("indexVec2", jP);
									map.setPoint3d("ptCenPart", ptCenPart);
									map.setVector3d("vecLengthPart", vecLengthPart);
									map.setVector3d("vecWidthPart", vecWidthPart);
									plPart.createRectangle(LineSeg(ptCenPart-.5*dLengthPart*vecLengthPart
							 - .5 * dWidthPart * vecWidthPart, ptCenPart + .5 * dLengthPart * vecLengthPart + .5 * dWidthPart * vecWidthPart), vecLengthPart, vecWidthPart);
							 		ppPart.joinRing(plPart,_kAdd);
							 		map.setPlaneProfile("ppPart", ppPart);
									mapCouples.appendMap("couple", map);
									ppParts.append(ppPart);
									//
									mapCouples2.appendMap("couple", map);
									ppParts2.append(ppPart);
								}
							}//next jP
						}//next j
					 }//next iP
				}//next i
			}
//			else if(nNrParts==3)
//			else if(sTypes.find(sType)==1)
			{ 
				for (int i=0;i<gbs.length();i++) 
				{ 
					for (int j=i+1;j<gbs.length();j++)
					{
						for (int k=j+1;k<gbs.length();k++)
						{ 
							for (int iP=0;iP<6;iP++) 
							{ 
								PlaneProfile ppI = pps[i*6+iP];
								CoordSys csI = ppI.coordSys();
								PlaneProfile ppI_ = ppI;
								ppI_.shrink(-U(20));
								PlaneProfile ppIntersect = ppI_, ppIntersect2 = ppI_, 
								ppIntersect3 = ppI_, ppIntersect4 = ppI_;
								
								PlaneProfile ppUnion = ppI_;
							 
		//					 	reportMessage("\n" + scriptName() + " j" + j);
								for (int jP=0;jP<6;jP++) 
								{ 
									PlaneProfile ppJ = pps[j*6+jP];
									CoordSys csJ = ppJ.coordSys();
									// check if planes codirectional
									if (!csI.vecZ().isCodirectionalTo(csJ.vecZ()))continue;
									// check if in same plane
									if (abs(csI.vecZ().dotProduct(csI.ptOrg() - csJ.ptOrg())) > dEps)continue;
									// check if intersect
									
									PlaneProfile ppJ_ = ppJ;
									ppJ_.shrink(-U(20));
									PlaneProfile ppIntersectJ = ppJ_, ppIntersectJ2 = ppJ_;
									for (int kP = 0; kP < 6; kP++)
									{
										PlaneProfile ppK = pps[k * 6 + kP];
										CoordSys csK = ppK.coordSys();
										if (!csI.vecZ().isCodirectionalTo(csK.vecZ()))continue;
										if (abs(csI.vecZ().dotProduct(csI.ptOrg() - csK.ptOrg())) > dEps)continue;
										
										PlaneProfile ppK_ = ppK;
										ppK_.shrink(-U(20));
										// genbeams must be close enougn
										// they must be close enough (ij and ik) or (ij and jk) || (ik and jk)
										if ( !( (ppIntersect.intersectWith(ppJ_) &&
											 ppIntersect2.intersectWith(ppK_)) ||
											 (ppIntersect3.intersectWith(ppJ_) &&
											 ppIntersectJ.intersectWith(ppK_)) ||
											 (ppIntersect4.intersectWith(ppK_) &&
											 ppIntersectJ2.intersectWith(ppK_))))continue;
										
										ppUnion.unionWith(ppJ_);
										ppIntersect = ppUnion;
										// calc ptCenPart, vecLength
										Point3d ptCenPart;
										Vector3d vecLengthPart, vecWidthPart;
										PlaneProfile ppPart(csI);
										PLine plPart();
										{
											PlaneProfile ppIshrink = ppI;
											ppIshrink.shrink(2 * dEps);
											PlaneProfile ppJshrink = ppJ;
											ppJshrink.shrink(2 * dEps);
											//
											PlaneProfile ppIextend = ppI;
											ppIextend.shrink(-.5*dLengthWidthMax);
											PlaneProfile ppJextend = ppJ;
											ppJextend.shrink(-.5*dLengthWidthMax);
											PlaneProfile ppKextend = ppK;
											ppKextend.shrink(-.5*dLengthWidthMax);
											//
											Vector3d vecsI[] ={ gbs[i].vecX(), gbs[i].vecY(), gbs[i].vecZ()};
											// two vectors in plane of planeprofile
											Vector3d _vecsI[0];
											for (int iV = 0; iV < vecsI.length(); iV++)
											{
												if (csI.vecZ().isParallelTo(vecsI[iV]))continue;
												_vecsI.append(vecsI[iV]);
											}//next iV
											if (_vecsI.length() != 2)
											{
												reportMessage(TN("|unexpected; 2 vectors|"));
												eraseInstance();
												return;
											}
											
											Vector3d vecXi = _vecsI[0];
											Vector3d vecYi = _vecsI[1];
											
											PlaneProfile ppIntersectAll=ppIextend;
											ppIntersectAll.intersectWith(ppJextend);
											ppIntersectAll.intersectWith(ppKextend);
											
											
											if(ppIntersectAll.area()<pow(dEps,2))
											{ 
												reportMessage("\n"+ scriptName() + T("|unexpected area|"));
												continue;
											}
											ptCenPart = ppIntersectAll.extentInDir(vecXi).ptMid();
											vecLengthPart = vecXi;
											vecWidthPart = csI.vecZ().crossProduct(vecLengthPart);
										}
//										if (nNrParts == 2)
										{
											// valid connection
											Map map;
											map.setPlaneProfile("pp1", ppI);
											map.setPlaneProfile("pp2", ppJ);
											map.setPlaneProfile("pp3", ppK);
											map.setEntity("ent1", gbs[i]);
											map.setEntity("ent2", gbs[j]);
											map.setEntity("ent3", gbs[k]);
											map.setInt("indexVec1", iP);
											map.setInt("indexVec2", jP);
											map.setInt("indexVec3", kP);
											map.setPoint3d("ptCenPart", ptCenPart);
											map.setVector3d("vecLengthPart", vecLengthPart);
											map.setVector3d("vecWidthPart", vecWidthPart);
											plPart.createRectangle(LineSeg(ptCenPart - .5 * dLengthPart * vecLengthPart
											 - .5 * dWidthPart * vecWidthPart, ptCenPart + .5 * dLengthPart * vecLengthPart + .5 * dWidthPart * vecWidthPart), vecLengthPart, vecWidthPart);
											ppPart.joinRing(plPart, _kAdd);
											map.setPlaneProfile("ppPart", ppPart);
											mapCouples.appendMap("couple", map);
											ppParts.append(ppPart);
											//
											//
											mapCouples3.appendMap("couple", map);
											ppParts3.append(ppPart);
										}
									}
								}//next jP
							}//next j
						}
					 }//next iP
				}//next i
			}
			if(sTypes.find(sType)==0)
				mapArgs.setMap("mapCouples", mapCouples2);
			else if(sTypes.find(sType)==1)
				mapArgs.setMap("mapCouples", mapCouples3);
			
			// create TSL
			TslInst tslNew;		Vector3d vecXTsl= _XW;	Vector3d vecYTsl= _YW;
			GenBeam gbsTsl[] = {};	Entity entsTsl[] = {};	Point3d ptsTsl[] = {_Pt0};
			int nProps[]={};		
			double dProps[]={dOffsetLength, dOffsetWidth, dRotate};			
			String sProps[]={sManufacturer, sFamily, sProduct, sModeInsert,sFace,sSide, sType};
			Map mapTsl;	
			int nGoJig = -1;
			while (nGoJig != _kOk && nGoJig != _kNone)
			{ 
				nGoJig = ssP.goJig(strJigAction1, mapArgs);
				if (nGoJig == _kOk)
				{
					Point3d ptJig = ssP.value();
					Vector3d vecView = getViewDirection();
					PlaneProfile ppPartsThis[0];
					Map mapCouplesThis;
					if (sTypes.find(sType) == 0)
					{
						ppPartsThis.append(ppParts2);
						mapCouplesThis = mapCouples2;
						sProps[6] = sType;
					}
					else if (sTypes.find(sType) == 1)
					{
						ppPartsThis.append(ppParts3);
						mapCouplesThis = mapCouples3;
						sProps[6] = sType;
					}
					for (int iP=0;iP<ppPartsThis.length();iP++) 
					{ 
						Map mapPart;
						PlaneProfile ppIp = ppPartsThis[iP];
						if ( ppIp.coordSys().vecZ().dotProduct(vecView)<0)continue;
						Plane pn(ppIp.coordSys().ptOrg(), ppIp.coordSys().vecZ());
						Point3d ptJigPn= ptJig.projectPoint(pn, dEps, vecView);
						if(ppIp.pointInProfile(ptJigPn)==_kPointInProfile)
						{ 
							mapPart = mapCouplesThis.getMap(iP);
							Entity ent1=mapPart.getEntity("ent1");
							GenBeam gb1 = (GenBeam)ent1;
							Entity ent2=mapPart.getEntity("ent2");
							GenBeam gb2 = (GenBeam)ent2;
							GenBeam gb3;
							if(mapPart.hasEntity("ent3"))
							{ 
								Entity ent3=mapPart.getEntity("ent3");
								gb3 = (GenBeam)ent3;
							}
							PlaneProfile pp1 = mapPart.getPlaneProfile("pp1");
							gbsTsl.setLength(0);
							gbsTsl.append(gb1);
							gbsTsl.append(gb2);
							if(gb3.bIsValid())gbsTsl.append(gb3);
							mapTsl.setVector3d("vecPlane", pp1.coordSys().vecZ());
							tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
							nGoJig = -1;
						}
					}//next iP
				}
				else if (nGoJig == _kKeyWord)
				{ 
					int iIndex= ssP.keywordIndex();
					reportMessage("\n"+ scriptName() + " sType"+sType);
					
					if(iIndex==0)
					{ 
						if(sTypes.find(sType)==0)
						{ 
							sType.set(sTypes[1]);
							sOptions = "2Genbeams]|";
							mapArgs.setMap("mapCouples", mapCouples3);
						}
						else if(sTypes.find(sType)==1)
						{ 
							sType.set(sTypes[0]);
							sOptions = "3Genbeams]|";
							mapArgs.setMap("mapCouples", mapCouples2);
						}
						ssP=PrPoint (sStringStart+sOptions);
					}
				}
				else if (nGoJig == _kCancel)
				{ 
					eraseInstance(); // do not insert this instance
	            	return; 
				}
			}
		}
		else
		{ 
			// distribute for each couple
			// create TSL
			TslInst tslNew;			Vector3d vecXTsl= _XW;	Vector3d vecYTsl= _YW;
			GenBeam gbsTsl[] ={ };	Entity entsTsl[] = { };	Point3d ptsTsl[] = { _Pt0};
			int nProps[]={};			
			double dProps[]={dOffsetLength, dOffsetWidth, dRotate};				
			String sProps[]={sManufacturer, sFamily, sProduct, sModeInsert,sFace,sSide, sType};
			// set to single instance
			sProps[3] = sModeInserts[0];
			Map mapTsl;	
			
			Vector3d vecView = getViewDirection();
			Body bds[0];
			PlaneProfile pps[0];
			for (int i=0;i<gbs.length();i++) 
			{ 
				GenBeam gbI = gbs[i];
				Quader qdI(gbI.ptCen(), gbI.vecX(), gbI.vecY(), gbI.vecZ(), gbI.solidLength(), gbI.solidWidth(), gbI.solidHeight());
				Body bdI = gbI.envelopeBody();
				bds.append(bdI);
				Vector3d vecsI[] ={ gbI.vecX() ,- gbI.vecX(), gbI.vecY() ,- gbI.vecY(), gbI.vecZ() ,- gbI.vecZ()};
				for (int ii=0;ii<vecsI.length();ii++) 
				{ 
					Point3d pt = gbI.ptCen() + vecsI[ii] * (.5 * qdI.dD(vecsI[ii]) - 2*dEps);
					PlaneProfile ppI = bdI.getSlice(Plane(pt, vecsI[ii]));
					pps.append(ppI);
				}//next ii
			}//next i
			
			// ppParts
			PlaneProfile ppParts[0];
			// we investigate up to "couples" of 3 genbeams
//			if(nNrParts==2)
			if(sTypes.find(sType)==0)
			{ 
				for (int i=0;i<gbs.length();i++) 
				{ 
					for (int j=i+1;j<gbs.length();j++) 
					{
						for (int iP=0;iP<6;iP++) 
						{ 
							PlaneProfile ppI = pps[i*6+iP];
							CoordSys csI = ppI.coordSys();
							PlaneProfile ppI_ = ppI;
							ppI_.shrink(-U(20));
							PlaneProfile ppIntersect = ppI_;
							PlaneProfile ppUnion = ppI_;
						 
	//					 	reportMessage("\n" + scriptName() + " j" + j);
							for (int jP=0;jP<6;jP++) 
							{ 
								PlaneProfile ppJ = pps[j*6+jP];
								CoordSys csJ = ppJ.coordSys();
								// check if planes codirectional
								if (!csI.vecZ().isCodirectionalTo(csJ.vecZ()))continue;
								// check if in same plane
								if (abs(csI.vecZ().dotProduct(csI.ptOrg() - csJ.ptOrg())) > dEps)continue;
								// check if intersect
								PlaneProfile ppJ_ = ppJ;
								ppJ_.shrink(-U(20));
								if ( ! ppIntersect.intersectWith(ppJ_))continue;
								
								// check if same direction as vecView
								if ( ppI.coordSys().vecZ().dotProduct(vecView)<0)continue;
								
//								if(nNrParts==2)
								{ 
									gbsTsl.setLength(0);
									gbsTsl.append(gbs[i]);
									gbsTsl.append(gbs[j]);
//									sProps[6] = sType;
									mapTsl.setVector3d("vecPlane", ppI.coordSys().vecZ());
									tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
								}
	
							}//next jP
							
						}//next j
					 }//next iP
				}//next i
			}
//			else if(nNrParts==3)
			else if(sTypes.find(sType)==1)
			{ 
				for (int i=0;i<gbs.length();i++) 
				{ 
					for (int j=i+1;j<gbs.length();j++)
					{
						for (int k=j+1;k<gbs.length();k++)
						{ 
							for (int iP=0;iP<6;iP++) 
							{ 
								PlaneProfile ppI = pps[i*6+iP];
								CoordSys csI = ppI.coordSys();
								PlaneProfile ppI_ = ppI;
								ppI_.shrink(-U(20));
								PlaneProfile ppIntersect = ppI_, ppIntersect2 = ppI_, 
								ppIntersect3 = ppI_, ppIntersect4 = ppI_;
								
								PlaneProfile ppUnion = ppI_;
							 
		//					 	reportMessage("\n" + scriptName() + " j" + j);
								for (int jP=0;jP<6;jP++) 
								{ 
									PlaneProfile ppJ = pps[j*6+jP];
									CoordSys csJ = ppJ.coordSys();
									// check if planes codirectional
									if (!csI.vecZ().isCodirectionalTo(csJ.vecZ()))continue;
									// check if in same plane
									if (abs(csI.vecZ().dotProduct(csI.ptOrg() - csJ.ptOrg())) > dEps)continue;
									// check if intersect
									
									PlaneProfile ppJ_ = ppJ;
									ppJ_.shrink(-U(20));
									PlaneProfile ppIntersectJ = ppJ_, ppIntersectJ2 = ppJ_;
									for (int kP = 0; kP < 6; kP++)
									{
										PlaneProfile ppK = pps[k * 6 + kP];
										CoordSys csK = ppK.coordSys();
										if (!csI.vecZ().isCodirectionalTo(csK.vecZ()))continue;
										if (abs(csI.vecZ().dotProduct(csI.ptOrg() - csK.ptOrg())) > dEps)continue;
										
										PlaneProfile ppK_ = ppK;
										ppK_.shrink(-U(20));
										// genbeams must be close enougn
										// they must be close enough (ij and ik) or (ij and jk) || (ik and jk)
										if ( !( (ppIntersect.intersectWith(ppJ_) &&
											 ppIntersect2.intersectWith(ppK_)) ||
											 (ppIntersect3.intersectWith(ppJ_) &&
											 ppIntersectJ.intersectWith(ppK_)) ||
											 (ppIntersect4.intersectWith(ppK_) &&
											 ppIntersectJ2.intersectWith(ppK_))))continue;
										
										// check if same direction as vecView
										if ( ppI.coordSys().vecZ().dotProduct(vecView)<0)continue;
										
										{ 
											gbsTsl.setLength(0);
											gbsTsl.append(gbs[i]);
											gbsTsl.append(gbs[j]);
											gbsTsl.append(gbs[k]);
											mapTsl.setVector3d("vecPlane", ppI.coordSys().vecZ());
											tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
										}
										
										
									}
								}//next jP
							}//next j
						}
					 }//next iP
				}//next i
			}
		}
		eraseInstance();
		return;
	}
// end on insert	__________________//endregion
	
	
Map mapManufacturer;
Map mapManufacturers = mapSetting.getMap("Manufacturer[]");
if(sManufacturer!="---")
{ 
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
	// set family and product
//	int indexManufacturer = sManufacturers.find(sManufacturer);
	Map mapFamilys = mapManufacturer.getMap("Family[]");
	sFamilys.setLength(0);
	sFamilys.append("---");
	for (int i = 0; i < mapFamilys.length(); i++)
	{
		Map mapFamilyI = mapFamilys.getMap(i);
		if (mapFamilyI.hasString("Name") && mapFamilys.keyAt(i).makeLower() == "family")
		{
			String sName = mapFamilyI.getString("Name");
			if (sFamilys.find(sName) < 0)
			{
				// populate sFamilys with all the sFamilys of the selected manufacturer
				sFamilys.append(sName);
			}
		}
	}
	int indexFamily = sFamilys.find(sFamily);
	if (indexFamily >- 1 )
	{
		// selected sFamily contained in sFamilys
		sFamily = PropString(1, sFamilys, sFamilyName, indexFamily);
//			sFamily.set(sFamilys[indexFamily]);
		if(sManufacturer!="---"&& indexFamily==0 && _kNameLastChangedProp==sManufacturerName)
		{
			sFamily.set(sFamilys[1]);
//					sFamily = PropString(1, sFamilys, sFamilyName, 1);
		}
	}
	else
	{
		// existing sFamily is not found, Family has been changed so set 
		// to sFamily the first Family from sFamilys
		sFamily = PropString(1, sFamilys, sFamilyName, 1);
		sFamily.set(sFamilys[1]);
	}
	if (sFamily != "---")
	{ 
		// get map of Family
		Map mapFamily;
		for (int i = 0; i < mapFamilys.length(); i++)
		{ 
			Map mapFamilyI = mapFamilys.getMap(i);
			if (mapFamilyI.hasString("Name") && mapFamilys.keyAt(i).makeLower() == "family")
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
			mapFamily = mapFamilys.getMap(i);
			break;
		}
// set Type
		Map mapProducts = mapFamily.getMap("Product[]");
		sProducts.setLength(0);
		for (int i = 0; i < mapProducts.length(); i++)
		{
			Map mapProductI = mapProducts.getMap(i);
			if (mapProductI.hasString("Name") && mapProducts.keyAt(i).makeLower() == "product")
			{
				String sName = mapProductI.getString("Name");
				if (sProducts.find(sName) < 0)
				{
					// populate sProducts with all the sProducts of the selected categry
					sProducts.append(sName);
				}
			}
		}
		int indexProduct = sProducts.find(sProduct);
		if (indexProduct >- 1)
		{
			// selected sModelis contained in sModels
			sProduct = PropString(2, sProducts, sProductName, indexProduct);
			if(sFamily!="---"&& indexProduct==0 && (_kNameLastChangedProp==sManufacturerName || _kNameLastChangedProp==sFamilyName))
			{
				sProduct.set(sProducts[0]);
//					sProduct = PropString(2, sProducts, sProductName, 1);
			}
		}
		else
		{
			// existing sModel is not found, Product has been changed so set 
			// to sModel the first Model from sModels
			sProduct = PropString(2, sProducts, sProductName, 0);
			sProduct.set(sProducts[0]);
		}
	}
	else
	{ 
		sProducts.setLength(0);
		sProducts.append("---");
		sProduct = PropString(2, sProducts, sProductName, 0);
		sProduct.set(sProducts[0]);
	}
}
else
{ 
	sFamilys.setLength(0);
	sFamilys.append("---");
	
	sFamily = PropString(1, sFamilys, sFamilyName, 0);
	sFamily.set(sFamilys[0]);
	sProducts.setLength(0);
	sProducts.append("---");
	sProduct = PropString(2, sProducts, sProductName, 0);
	sProduct.set(sProducts[0]);
}

// get map of the selected product
Map mapFamily;
Map mapProduct;
int iFamilyFound = false;
int iProductFound = false;
{ 
	Map mapManufacturers = mapSetting.getMap("Manufacturer[]");
	if(sManufacturer!="---")
	{ 
		for (int i = 0; i < mapManufacturers.length(); i++)
		{ 
			Map mapManufacturerI = mapManufacturers.getMap(i);
			if (mapManufacturerI.hasString("Name") && mapManufacturers.keyAt(i).makeLower() == "manufacturer")
			{
				String _sManufacturerName = mapManufacturerI.getString("Name");
				String _sManufacturer = sManufacturer;_sManufacturer.makeUpper();
				if (_sManufacturerName.makeUpper() == _sManufacturer)
				{
					// this manufacturer
					Map mapManufacturer = mapManufacturerI;
					Map mapFamilys = mapManufacturer.getMap("Family[]");
					for (int ii = 0; ii < mapFamilys.length(); ii++)
					{
						Map mapFamilyI = mapFamilys.getMap(ii);
						if (mapFamilyI.hasString("Name") && mapFamilys.keyAt(ii).makeLower() == "family")
						{
//							String sName = mapFamilyI.getString("Name");
							String _sFamilyName = mapFamilyI.getString("Name");
							String _sFamily = sFamily;_sFamily.makeUpper();
							if (_sFamilyName.makeUpper() == _sFamily)
							{ 
								// this family
								mapFamily = mapFamilyI;
								iFamilyFound = true;
								Map mapProducts = mapFamily.getMap("Product[]");
								for (int iii = 0; iii < mapProducts.length(); iii++)
								{ 
									Map mapProductI = mapProducts.getMap(iii);
									if (mapProductI.hasString("Name") && mapProducts.keyAt(iii).makeLower() == "product")
									{ 
										String _sProductName = mapProductI.getString("Name");
										String _sProduct = sProduct;_sProduct.makeUpper();
										if (_sProductName.makeUpper() == _sProduct)
										{ 
											mapProduct = mapProductI;
											iProductFound = true;
											break;
										}
									}
								}
								if (iProductFound)break;
							}
						}
					}
					if (iProductFound)break;
				}
			}
		}
	}
}

double dLengthPart, dWidthPart;
if(iProductFound)
{
	String s;
	s="Length"; if(mapProduct.hasDouble(s))dLengthPart= mapProduct.getDouble(s);
	s="Width"; if(mapProduct.hasDouble(s))dWidthPart= mapProduct.getDouble(s);
}
double dLengthWidthMax = dLengthPart > dWidthPart ? dLengthPart : dWidthPart;
double dThicknessPart = U(0.95);
String sUrl, sMaterial;
if(iFamilyFound)
{
	String s;
	s="Material"; if(mapFamily.hasString(s))sMaterial= mapFamily.getString(s);
	s="url"; if(mapFamily.hasString(s))sUrl= mapFamily.getString(s);
}
if(sUrl!="")
	_ThisInst.setHyperlink(sUrl);
int iModeInsert = sModeInserts.find(sModeInsert);
if(iModeInsert!=0)
{ 
	reportMessage(TN("|Multiple insertion mode only supported on insert|"));
	eraseInstance();
	return;
}
//return;
//if(iModeInsert==0)
{ 
	// hide irelevant properties
	sModeInsert.setReadOnly(_kHidden);
	sFace.setReadOnly(_kHidden);
//	nNrParts.setReadOnly(_kHidden);
	sType.setReadOnly(_kHidden);
	
	// single instance
	if(_GenBeam.length()<2)
	{ 
		reportMessage(TN("|2 GenBeams needed|"));
		eraseInstance();
		return;
	}
	GenBeam gbs[0];
	gbs.append(_GenBeam);
	// 
	GenBeam gb0 = _GenBeam[0];
	Point3d ptCen0 = gb0.ptCen();
	Vector3d vecX0 = gb0.vecX();
	Vector3d vecY0 = gb0.vecY();
	Vector3d vecZ0 = gb0.vecZ();
	//
	GenBeam gb1 = _GenBeam[1];
	Point3d ptCen1 = gb1.ptCen();
	Vector3d vecX1 = gb1.vecX();
	Vector3d vecY1 = gb1.vecY();
	Vector3d vecZ1 = gb1.vecZ();
	assignToLayer("i");
	assignToGroups(Entity(gb0));
	Body bds[0];
	PlaneProfile pps[0];
	for (int i=0;i<gbs.length();i++) 
	{ 
		GenBeam gbI = gbs[i];
		Quader qdI(gbI.ptCen(), gbI.vecX(), gbI.vecY(), gbI.vecZ(), gbI.solidLength(), gbI.solidWidth(), gbI.solidHeight());
		Body bdI = gbI.envelopeBody();
		bds.append(bdI);
		Vector3d vecsI[] ={ gbI.vecX() ,- gbI.vecX(), gbI.vecY() ,- gbI.vecY(), gbI.vecZ() ,- gbI.vecZ()};
		for (int ii=0;ii<vecsI.length();ii++) 
		{ 
			Point3d pt = gbI.ptCen() + vecsI[ii] * (.5 * qdI.dD(vecsI[ii]) - 2*dEps);
			PlaneProfile ppI = bdI.getSlice(Plane(pt, vecsI[ii]));
			pps.append(ppI);
		}//next ii
	}//next i
	if(!_Map.hasVector3d("vecPlane"))
	{ 
		reportMessage(TN("|Plane vector not defined|"));
		eraseInstance();
		return;
	}
	int iSide = sSides.find(sSide);
	Vector3d vecPlaneMap = _Map.getVector3d("vecPlane");
	Vector3d vecPlane;
	Vector3d vecLengthPart, vecWidthPart;
	// for opposite side
	Vector3d vecPlaneOpp;
	Vector3d vecLengthPartOpp, vecWidthPartOpp;
	
	Point3d ptCenPart;
	Point3d ptCenPartOpp;
	// v
	Vector3d vecPlanes[0];
	Vector3d vecLengthParts[0], vecWidthParts[0];
	Point3d ptCenParts[0];
	
	int iPlaneFound;
//	if(nNrParts==2)
	if(sTypes.find(sType)==0)
	{ 
		for (int i=0;i<gbs.length();i++) 
		{ 
			for (int j=i+1;j<gbs.length();j++) 
			{ 
				for (int iP = 0; iP < 6; iP++)
				{
					PlaneProfile ppI = pps[i * 6 + iP];
					CoordSys csI = ppI.coordSys();
					vecPlane = gb0.vecD(vecPlaneMap);
	//				vecPlaneOpp=gb0.vecD(-vecPlaneMap);
					if(iSide==0)
					{
						if (!csI.vecZ().isCodirectionalTo(vecPlane))continue;
					}
					PlaneProfile ppI_ = ppI;
					ppI_.shrink(-U(20));
					PlaneProfile ppIntersect = ppI_;
					PlaneProfile ppUnion = ppI_;
					for (int jP = 0; jP < 6; jP++)
					{
						PlaneProfile ppJ = pps[j*6+jP];
						CoordSys csJ = ppJ.coordSys();
						// check if planes codirectional
						if (!csI.vecZ().isCodirectionalTo(csJ.vecZ()))continue;
						// check if in same plane
						if (abs(csI.vecZ().dotProduct(csI.ptOrg() - csJ.ptOrg())) > dEps)continue;
						// check if intersect
						PlaneProfile ppJ_ = ppJ;
						ppJ_.shrink(-U(20));
						if ( ! ppIntersect.intersectWith(ppJ_))continue;
						// found
						vecPlanes.append(csI.vecZ());
						iPlaneFound = true;
						ppUnion.unionWith(ppJ_);
						ppIntersect = ppUnion;
						// calc ptCenPart, vecLength
						PlaneProfile ppPart(csI);
	//					PLine plPart();
						{ 
							PlaneProfile ppIshrink = ppI;
							ppIshrink.shrink(2*dEps);
							PlaneProfile ppJshrink = ppJ;
							ppJshrink.shrink(2*dEps);
							
							//
							Vector3d vecsI[] ={ gbs[i].vecX(), gbs[i].vecY(), gbs[i].vecZ()};
							// two vectors in plane of planeprofile
							Vector3d _vecsI[0];
							for (int iV=0;iV<vecsI.length();iV++) 
							{ 
								if(csI.vecZ().isParallelTo(vecsI[iV]))continue; 
								_vecsI.append(vecsI[iV]);
							}//next iV
							if(_vecsI.length()!=2)
							{ 
								reportMessage(TN("|unexpected; 2 vectors|"));
								eraseInstance();
								return;
							}
							Vector3d vecXi = _vecsI[0];
							Vector3d vecYi = _vecsI[1];
							// PlaneProfile I
							PlaneProfile ppIlongX(ppI.coordSys());
							PlaneProfile ppIlongY(ppI.coordSys());
							// get extents of profile
							LineSeg segI = ppIshrink.extentInDir(vecXi);
							double dXi = abs(vecXi.dotProduct(segI.ptStart()-segI.ptEnd()));
							double dYi = abs(vecYi.dotProduct(segI.ptStart()-segI.ptEnd()));
							PLine pl();
							pl.createRectangle(LineSeg(segI.ptMid()-.5*dXi*vecXi-U(10e3)*vecYi, 
									segI.ptMid() + .5 * dXi * vecXi + U(10e3) * vecYi), vecXi, vecYi);
							ppIlongY.joinRing(pl, _kAdd);
							pl = PLine();
							pl.createRectangle(LineSeg(segI.ptMid()-.5*dYi*vecYi-U(10e3)*vecXi, 
									segI.ptMid() + .5 * dYi * vecYi + U(10e3) * vecXi), vecXi, vecYi);
							ppIlongX.joinRing(pl, _kAdd);
							// PlaneProfile J
							PlaneProfile ppJlongX(ppJ.coordSys());
							PlaneProfile ppJlongY(ppJ.coordSys());
							// get extents of profile
							LineSeg segJ = ppJshrink.extentInDir(vecXi);
							double dXj = abs(vecXi.dotProduct(segJ.ptStart()-segJ.ptEnd()));
							double dYj = abs(vecYi.dotProduct(segJ.ptStart()-segJ.ptEnd()));
							pl=PLine();
							pl.createRectangle(LineSeg(segJ.ptMid()-.5*dXj*vecXi-U(10e3)*vecYi, 
									segJ.ptMid() + .5 * dXj * vecXi + U(10e3) * vecYi), vecXi, vecYi);
							ppJlongY.joinRing(pl, _kAdd);
							pl = PLine();
							pl.createRectangle(LineSeg(segJ.ptMid()-.5*dYj*vecYi-U(10e3)*vecXi, 
									segJ.ptMid() + .5 * dYj * vecYi + U(10e3) * vecXi), vecXi, vecYi);
							ppJlongX.joinRing(pl, _kAdd);
							
							PlaneProfile ppIntersectShrink = ppIshrink;
							if(ppIntersectShrink.intersectWith(ppJshrink))
							{ 
								ptCenPart = ppIntersectShrink.extentInDir(vecXi).ptMid();
								vecLengthPart = vecXi;
								vecWidthPart = csI.vecZ().crossProduct(vecLengthPart);
								ptCenParts.append(ptCenPart);
							}
							else
							{ 
								PlaneProfile ppIlongXIntersect = ppIlongX;
								PlaneProfile ppIlongYIntersect = ppIlongY;
								if(ppIlongXIntersect.intersectWith(ppJlongX))
								{ 
									vecLengthPart = vecXi;
									vecWidthPart = csI.vecZ().crossProduct(vecLengthPart);
									vecLengthParts.append(vecLengthPart);
									vecWidthParts.append(vecWidthPart);
									ptCenPart = ppIlongXIntersect.extentInDir(vecXi).ptMid();
									// fix in x direction
									PLine plIJ();
									plIJ.createRectangle(LineSeg(ppI.extentInDir(vecXi).ptMid(),
											ppJ.extentInDir(vecXi).ptMid()), vecXi, vecYi);
									PlaneProfile ppIJ(ppI.coordSys());
									ppIJ.joinRing(plIJ, _kAdd);
									ppIJ.subtractProfile(ppIlongY);
									ppIJ.subtractProfile(ppJlongY);
									Point3d ptCenPartX = ppIJ.extentInDir(vecXi).ptMid();
									ptCenPart += vecXi * vecXi.dotProduct(ptCenPartX - ptCenPart);
									ptCenParts.append(ptCenPart);
									// apply 
								}
								else if(ppIlongYIntersect.intersectWith(ppJlongY))
								{ 
									vecLengthPart = vecYi;
									vecWidthPart = csI.vecZ().crossProduct(vecLengthPart);
									vecLengthParts.append(vecLengthPart);
									vecWidthParts.append(vecWidthPart);
									ptCenPart = ppIlongYIntersect.extentInDir(vecXi).ptMid();
									// fix in x direction
									PLine plIJ();
									plIJ.createRectangle(LineSeg(ppI.extentInDir(vecXi).ptMid(),
											ppJ.extentInDir(vecXi).ptMid()), vecXi, vecYi);
									PlaneProfile ppIJ(ppI.coordSys());
									ppIJ.joinRing(plIJ, _kAdd);
									ppIJ.subtractProfile(ppIlongX);
									ppIJ.subtractProfile(ppJlongX);
									Point3d ptCenPartY = ppIJ.extentInDir(vecXi).ptMid();
									ptCenPart += vecYi * vecYi.dotProduct(ptCenPartY - ptCenPart);
									
									ptCenParts.append(ptCenPart);
								}
							}
						}
	//					plPart.createRectangle(LineSeg(ptCenPart-.5*dLengthPart*vecLengthPart
	//						 - .5 * dWidthPart * vecWidthPart, ptCenPart + .5 * dLengthPart * vecLengthPart + .5 * dWidthPart * vecWidthPart), vecLengthPart, vecWidthPart);
	//					ppPart.joinRing(plPart,_kAdd);
	//					if (iPlaneFound)break;
						if (ptCenParts.length() == 1 && iSide == 0)break;
						if (ptCenParts.length() == 2 && iSide == 1)break;
						
					}
	//				if (iPlaneFound)break;
					if (ptCenParts.length() == 1 && iSide == 0)break;
					if (ptCenParts.length() == 2 && iSide == 1)break;
				}
	//			if (iPlaneFound)break;
				if (ptCenParts.length() == 1 && iSide == 0)break;
				if (ptCenParts.length() == 2 && iSide == 1)break;
			}
	//		if (iPlaneFound)break;
			if (ptCenParts.length() == 1 && iSide == 0)break;
			if (ptCenParts.length() == 2 && iSide == 1)break;
		}//next i
	}
//	if(nNrParts==3)
	else if(sTypes.find(sType)==1)
	{ 
		for (int i=0;i<gbs.length();i++) 
		{ 
			for (int j=i+1;j<gbs.length();j++) 
			{ 
				for (int k=j+1;k<gbs.length();k++)
				{ 
					for (int iP = 0; iP < 6; iP++)
					{
						PlaneProfile ppI = pps[i * 6 + iP];
						CoordSys csI = ppI.coordSys();
						PlaneProfile ppI_ = ppI;
								ppI_.shrink(-U(20));
						
						PlaneProfile ppIntersect = ppI_, ppIntersect2 = ppI_, 
								ppIntersect3 = ppI_, ppIntersect4 = ppI_;
		//				vecPlaneOpp=gb0.vecD(-vecPlaneMap);
						vecPlane = gb0.vecD(vecPlaneMap);
						if(iSide==0)
						{
							if (!csI.vecZ().isCodirectionalTo(vecPlane))continue;
						}
						PlaneProfile ppUnion = ppI_;
						for (int jP = 0; jP < 6; jP++)
						{
							PlaneProfile ppJ = pps[j*6+jP];
							CoordSys csJ = ppJ.coordSys();
							// check if planes codirectional
							if (!csI.vecZ().isCodirectionalTo(csJ.vecZ()))continue;
							// check if in same plane
							if (abs(csI.vecZ().dotProduct(csI.ptOrg() - csJ.ptOrg())) > dEps)continue;
							// check if intersect
							PlaneProfile ppJ_ = ppJ;
							ppJ_.shrink(-U(20));
							PlaneProfile ppIntersectJ = ppJ_, ppIntersectJ2 = ppJ_;
							for (int kP = 0; kP < 6; kP++)
							{
								PlaneProfile ppK = pps[k * 6 + kP];
								CoordSys csK = ppK.coordSys();
								if (!csI.vecZ().isCodirectionalTo(csK.vecZ()))continue;
								if (abs(csI.vecZ().dotProduct(csI.ptOrg() - csK.ptOrg())) > dEps)continue;
								
								PlaneProfile ppK_ = ppK;
								ppK_.shrink(-U(20));
								// genbeams must be close enougn
								// they must be close enough (ij and ik) or (ij and jk) || (ik and jk)
								if ( !( (ppIntersect.intersectWith(ppJ_) &&
									 ppIntersect2.intersectWith(ppK_)) ||
									 (ppIntersect3.intersectWith(ppJ_) &&
									 ppIntersectJ.intersectWith(ppK_)) ||
									 (ppIntersect4.intersectWith(ppK_) &&
									 ppIntersectJ2.intersectWith(ppK_))))continue;
									 
								// found
								vecPlanes.append(csI.vecZ());
								iPlaneFound = true;
								ppUnion.unionWith(ppJ_);
								ppIntersect = ppUnion;
								// calc ptCenPart, vecLength
								PlaneProfile ppPart(csI);
			//					PLine plPart();
								{ 
									PlaneProfile ppIshrink = ppI;
									ppIshrink.shrink(2*dEps);
									PlaneProfile ppJshrink = ppJ;
									ppJshrink.shrink(2*dEps);
									//
									PlaneProfile ppIextend = ppI;
									ppIextend.shrink(-.5*dLengthWidthMax);
									PlaneProfile ppJextend = ppJ;
									ppJextend.shrink(-.5*dLengthWidthMax);
									PlaneProfile ppKextend = ppK;
									ppKextend.shrink(-.5*dLengthWidthMax);
									//
									Vector3d vecsI[] ={ gbs[i].vecX(), gbs[i].vecY(), gbs[i].vecZ()};
									// two vectors in plane of planeprofile
									Vector3d _vecsI[0];
									for (int iV=0;iV<vecsI.length();iV++) 
									{ 
										if(csI.vecZ().isParallelTo(vecsI[iV]))continue; 
										_vecsI.append(vecsI[iV]);
									}//next iV
									if(_vecsI.length()!=2)
									{ 
										reportMessage(TN("|unexpected; 2 vectors|"));
										eraseInstance();
										return;
									}
									Vector3d vecXi = _vecsI[0];
									Vector3d vecYi = _vecsI[1];
									
									PlaneProfile ppIntersectAll=ppIextend;
									ppIntersectAll.intersectWith(ppJextend);
									ppIntersectAll.intersectWith(ppKextend);
									
									if(ppIntersectAll.area()<pow(dEps,2))
									{ 
										reportMessage("\n"+ scriptName() + T("|unexpected area|"));
										continue;
									}
									ptCenPart = ppIntersectAll.extentInDir(vecXi).ptMid();
									vecLengthPart = vecXi;
									vecWidthPart = csI.vecZ().crossProduct(vecLengthPart);
									ptCenParts.append(ptCenPart);
									vecLengthParts.append(vecLengthPart);
									vecWidthParts.append(vecWidthPart);
								}
								if (ptCenParts.length() == 1 && iSide == 0)break;
								if (ptCenParts.length() == 2 && iSide == 1)break;
							}
		//					plPart.createRectangle(LineSeg(ptCenPart-.5*dLengthPart*vecLengthPart
		//						 - .5 * dWidthPart * vecWidthPart, ptCenPart + .5 * dLengthPart * vecLengthPart + .5 * dWidthPart * vecWidthPart), vecLengthPart, vecWidthPart);
		//					ppPart.joinRing(plPart,_kAdd);
		//					if (iPlaneFound)break;
							if (ptCenParts.length() == 1 && iSide == 0)break;
							if (ptCenParts.length() == 2 && iSide == 1)break;
						}
		//				if (iPlaneFound)break;
						if (ptCenParts.length() == 1 && iSide == 0)break;
						if (ptCenParts.length() == 2 && iSide == 1)break;
					}
					if (ptCenParts.length() == 1 && iSide == 0)break;
					if (ptCenParts.length() == 2 && iSide == 1)break;
				}
	//			if (iPlaneFound)break;
				if (ptCenParts.length() == 1 && iSide == 0)break;
				if (ptCenParts.length() == 2 && iSide == 1)break;
			}
	//		if (iPlaneFound)break;
			if (ptCenParts.length() == 1 && iSide == 0)break;
			if (ptCenParts.length() == 2 && iSide == 1)break;
		}//next i
	}
	if(ptCenParts.length()==0)
	{ 
		reportMessage("\n"+ scriptName() + T("|Beams not OK|"));
		eraseInstance();
		return;
	}
	_Pt0 = ptCenParts[0];
	int iSwap = _Map.getInt("swap");
	if(_Map.hasVector3d("vecLengthPart"))
		vecLengthPart = _Map.getVector3d("vecLengthPart");
	else
		_Map.setVector3d("vecLengthPart", vecLengthPart);
	//
//	if(_Map.hasVector3d("vecWidthPart"))
//		vecLengthPart = _Map.getVector3d("vecWidthPart");
//	else
//		_Map.setVector3d("vecWidthPart", vecWidthPart);
	vecWidthPart = vecPlanes[0].crossProduct(vecLengthPart);
	if(vecPlaneMap.dotProduct(vecPlanes[0])<0)vecWidthPart = vecPlanes[1].crossProduct(vecLengthPart);
	//
	for (int i=0;i<ptCenParts.length();i++) 
	{ 
		// if two planes when both sides is selected
		Plane pn(ptCenParts[i], vecPlanes[i]);
		PlaneProfile ppPart(Plane(ptCenParts[i], vecPlanes[i]));
		Vector3d vecLengthPartI=vecLengthPart, vecWidthPartI=vecWidthPart, vecPlaneI=vecPlanes[i];
		double dOffsetLengthI=dOffsetLength, dRotateI=dRotate;
		if(vecPlaneMap.dotProduct(vecPlanes[i])<0)
		{ 
			vecLengthPartI = -vecLengthPart;
			vecPlaneI=vecPlanes[i];
			vecWidthPartI = vecPlaneI.crossProduct(vecLengthPartI);
			dOffsetLengthI = -dOffsetLength;
			dRotateI = -dRotate;
		}
		PLine plPart();
		plPart.createRectangle(LineSeg(ptCenParts[i]-.5*dLengthPart*vecLengthPartI
							 - .5 * dWidthPart * vecWidthPartI, ptCenParts[i] + .5 * dLengthPart * vecLengthPartI + .5 * dWidthPart * vecWidthPartI), vecLengthPartI, vecWidthPartI);
		ptCenParts[i].vis(1);
		plPart.transformBy(vecPlaneI * vecPlaneI.dotProduct(ptCenParts[i] - plPart.coordSys().ptOrg()));
		plPart.vis(1);
		Body bdPart(plPart, vecPlaneI*dThicknessPart,1);
		ppPart.joinRing(plPart,_kAdd);
		// rotate
		CoordSys csRot;
		csRot.setToRotation(dRotateI, vecPlaneI, ptCenParts[i]);
		bdPart.transformBy(csRot);
		ppPart.transformBy(csRot);
		bdPart.vis(2);
		CoordSys csDisp;
		bdPart.transformBy(vecLengthPartI*dOffsetLengthI);
		bdPart.transformBy(vecWidthPartI*dOffsetWidth);
		ppPart.transformBy(vecLengthPartI*dOffsetLengthI);
		ppPart.transformBy(vecWidthPartI*dOffsetWidth);
		Display dp(252);
		dp.draw(ppPart, _kDrawFilled);
		dp.draw(bdPart);
		
//		vecLengthParts[i].vis(ptCenParts[i], 1);
//		vecWidthParts[i].vis(ptCenParts[i], 3);
	}//next i
//	if(iPlaneFound)
//	{ 
//		Display dp(1);
////		PlaneProfile pp1=gbs[0].envelopeBody().shadowProfile(Plane(gbs[0].ptCen()))
//	}

//region Trigger swapSide
	String sTriggerswapSide = T("|Swap Side|");
	// trigger only if one side not for both
	if(iSide!=1)	
		addRecalcTrigger(_kContextRoot, sTriggerswapSide );
	if (_bOnRecalc && _kExecuteKey==sTriggerswapSide)
	{
		iSwap =! iSwap;
		_Map.setInt("swap", iSwap);
		vecPlaneMap	*=-1;
		_Map.setVector3d("vecPlane",vecPlaneMap);
		dRotate.set(-dRotate);
		_Map.setVector3d("vecLengthPart" ,- vecLengthPart);
		dOffsetLength.set(-dOffsetLength);
		setExecutionLoops(2);
		return;
	}//endregion	


int iQuantity = iSide + 1;

//region
// Hardware
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
		Element elHW =gb0.element(); 
		// check if the parent entity is an element
		if (!elHW.bIsValid())	elHW = (Element)gb0;
		if (elHW.bIsValid()) 	sHWGroupName=elHW.elementGroup().name();
	// loose
		else
		{
			Group groups[] = _ThisInst.groups();
			if (groups.length()>0)	sHWGroupName=groups[0].name();
		}		
	}
	
// add main componnent
	{ 
		HardWrComp hwc(sFamily, iQuantity); // the articleNumber and the quantity is mandatory
		
		hwc.setManufacturer(sManufacturer);
		
		hwc.setModel(sProduct);
//		hwc.setName(sHWName);
//		hwc.setDescription(sHWDescription);
		hwc.setMaterial(sMaterial);
//		hwc.setNotes(sHWNotes);
		
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(gb0);	
		hwc.setCategory(T("|Connector|"));
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		
		hwc.setDScaleX(dLengthPart);
		hwc.setDScaleY(dWidthPart);
		hwc.setDScaleZ(dThicknessPart);
		
	// apppend component to the list of components
		hwcs.append(hwc);
	}

// make sure the hardware is updated
	if (_bOnDbCreated)	setExecutionLoops(2);				
	_ThisInst.setHardWrComps(hwcs);	
//endregion

}
#End
#BeginThumbnail

#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-11670: initial" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="5/12/2021 1:14:33 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End