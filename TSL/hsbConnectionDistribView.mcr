#Version 8
#BeginDescription
version value="1.10" date="24may20" author="marsel.nakuci@hsbcad.com"

HSB-7510: write in hardware note cd-ref-cd-ref-nr
HSB-7510: fix bug -Line 1159 (cannot access last element of an empty array) and write CD-Ref Number into hardware Infos
HSB-7510: result of calcDistance and nr shown in separated properties
HSB-7510: fix bug, write mapX, add line for insert by points
HSB-7405: add property project number
HSB-7405: add grip poins at start and end
HSB-7124: change name to hsbConnectionDistribView
HSB-7124: set the _Pt0
HSB-7124: change name to hsb-ConnectionDistribView
HSB-7124: support normal, parallel and arbitrary connections

This tsl creates a display of connectors (nails, screws etc.) distribution
It generates distribution at normal parallel and arbitrary connection between two panels
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 10
#KeyWords klh, connection, wall, floor, distribution
#BeginContents
/// <History>//region 
/// <version value="1.10" date="24may20" author="marsel.nakuci@hsbcad.com"> HSB-7510: write in hardware note cd-ref-cd-ref-nr </version>
/// <version value="1.9" date="13may20" author="marsel.nakuci@hsbcad.com"> HSB-7510: fix bug -Line 1159 (cannot access last element of an empty array) and write CD-Ref Number into hardware Infos </version>
/// <version value="1.8" date="13may20" author="marsel.nakuci@hsbcad.com"> HSB-7510: result of calcDistance and nr shown in separated properties </version>
/// <version value="1.7" date="07may20" author="marsel.nakuci@hsbcad.com"> HSB-7510: fix bug, write mapX, add line for insert by points </version>
/// <version value="1.6" date="29apr20" author="marsel.nakuci@hsbcad.com"> HSB-7405: add property project number </version>
/// <version value="1.5" date="27apr20" author="marsel.nakuci@hsbcad.com"> HSB-7405: add grip poins at start and end </version>
/// <version value="1.4" date="13apr20" author="marsel.nakuci@hsbcad.com"> HSB-7124: change name to hsbConnectionDistribView </version>
/// <version value="1.3" date="06apr20" author="marsel.nakuci@hsbcad.com"> HSB-7124: set the _Pt0 </version>
/// <version value="1.2" date="06apr20" author="marsel.nakuci@hsbcad.com"> HSB-7124: change name to hsb-ConnectionDistribView </version>
/// <version value="1.1" date="04apr20" author="marsel.nakuci@hsbcad.com"> HSB-7124: support normal, parallel and arbitrary connections </version>
/// <version value="1.0" date="27mar20" author="marsel.nakuci@hsbcad.com"> HSB-7124: initial </version>
/// </History>

/// <insert Lang=en>
/// Select entity, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates a display of connectors (nails, screws etc.) distribution
/// It generates distribution at normal parallel and arbitrary connection between two panels
/// </summary>

/// commands
// command to insert a G-connection
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbConnectionDistribView")) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|UserPrompt|"))) TSLCONTENT
//endregion
	
//region constants 
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
//end constants//endregion
	
//region read the xml file or the map object
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany + "\\TSL";
	String sFolder = "Settings";
	// name of the xml file 
	String sFileName = "hsbExcel2Xml";
	Map mapSetting;
	
// find settings file
	String sFolders[] = getFoldersInFolder(sPath);
	int bPathFound;
	if (_bOnInsert)
		bPathFound = sFolders.find(sFolder) >- 1 ? true : makeFolder(sPath + "\\" + sFolder);
	String sFullPath = sPath + "\\" + sFolder + "\\" + sFileName + ".xml";
	String sFile = findFile(sFullPath);

// read a potential mapObject
	MapObject mo(sDictionary ,sFileName);
	if (mo.bIsValid())
	{
	// read the map object
		if(bDebug)reportMessage("\n"+ scriptName() + " read the map object");
		mapSetting = mo.map();
		setDependencyOnDictObject(mo);
	}
	else if ((_bOnInsert || _bOnDebug || !_bOnDebug) && !mo.bIsValid() && sFile.length() > 0)
	{
		// create a mapObject to make the settings persistent
		if (bDebug)reportMessage("\n" + scriptName() + " read from xml");
		// read from xml
		mapSetting.readFromXmlFile(sFile);
		mo.dbCreate(mapSetting);// write into the database
	}
	else
	{ 
		reportMessage(TN("|no xml for screws found|"));
		eraseInstance();
		return;
	}
	if(mapSetting.length()<1)
	{ 
		reportMessage(TN("|wrong definition of the xml file 1001|"));
		eraseInstance();
		return;
	}
//	// get screw types
	String sScrewTypes[0];
	
//region get Project nr and sManufacturers from the mapSetting
	// 
	String sProjectNr;
	Map mapProject=mapSetting.getMap("Project");
	if (mapProject.hasString("Name"))
	{ 
		sProjectNr = mapProject.getString("Name");
	}
	//
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
//End get sManufacturers from the mapSetting//endregion 
//region get sConnection_Types
	String sConnectionTypes[0];
	Map mapConnection_types = mapSetting.getMap("Code[]");
	for (int i = 0; i < mapConnection_types.length(); i++)
	{
		Map mapConnection_typeI = mapConnection_types.getMap(i);
		if (mapConnection_typeI.hasString("CD-Ref") && mapConnection_types.keyAt(i).makeLower() == "code")
		{
			String _sConnection_type = mapConnection_typeI.getString("CD-Ref");
			if (sConnectionTypes.find(_sConnection_type) < 0)
			{
				sConnectionTypes.append(_sConnection_type);
			}
		}
	}
//End get sConnection_Types//endregion 
	
	if(sManufacturers.length()==0)	
	{ 
		reportMessage(TN("|no Manufacturer from xml|"));
		eraseInstance();
		return;
	}
//End read the xml file or the map object//endregion 	
	
//region properties
	String sProjectName=T("|Loaded Project|");	
	PropString sProject(nStringIndex++, sProjectNr, sProjectName);	
	sProject.setDescription(T("|Defines the Project|"));
	sProject.setCategory(category);
	sProject.setReadOnly(true);
	
	category = T("|Component|");
	// Manufacturer
	String sManufacturerName=T("|Manufacturer|");	
	PropString sManufacturer(nStringIndex++, sManufacturers, sManufacturerName);
	sManufacturer.setDescription(T("|Defines the Manufacturer|"));
	sManufacturer.setCategory(category);
	// Manufacturer categories
	String sModels[0];
	sModels.append("---");
	String sModelName=T("|Model|");	
	PropString sModel(nStringIndex++, "", sModelName);	
	sModel.setDescription(T("|Defines the Model|"));
	sModel.setCategory(category);
	// Article
	String sArticles[0];
	sArticles.append("---");
	String sArticleName=T("|Article|");	
	PropString sArticle(nStringIndex++, "", sArticleName);	
	sArticle.setDescription(T("|Defines the Article|"));
	sArticle.setCategory(category);
	// CD Ref.
	category = T("|Code|");
	String sCDREfName=T("|CD-Ref|");	
	PropString sCDREf(nStringIndex++, sConnectionTypes, sCDREfName);	
	sCDREf.setDescription(T("|Defines the CDREf|"));
	sCDREf.setCategory(category);
	// number
	String sNumberName=T("|CD-Ref Number|");	
	int nNumbers[]={1,2,3};
	PropInt nNumber(nIntIndex++, 0, sNumberName);	
	nNumber.setDescription(T("|Defines the Number|"));
	nNumber.setCategory(category);
	
	category = T("|Distribution|");
	//distance from the bottom / start
	String sDistanceBottomName = T("|Distance Bottom/Start|");
	PropDouble dDistanceBottom(nDoubleIndex++, U(0), sDistanceBottomName);
	dDistanceBottom.setDescription(T("|Defines the Distance at the Bottom|"));
	dDistanceBottom.setCategory(category);
	// distance from the top/end
	String sDistanceTopName = T("|Distance Top/End|");
	PropDouble dDistanceTop(nDoubleIndex++, U(0), sDistanceTopName);
	dDistanceTop.setDescription(T("|Defines the Distance at the Top|"));
	dDistanceTop.setCategory(category);
	
	// distance in between/ nr of parts (when negative input)
	String sDistanceBetweenName=T("|Distance between / Nr.| ");	
	PropDouble dDistanceBetween(nDoubleIndex++, U(5), sDistanceBetweenName);	
	dDistanceBetween.setDescription(T("|Defines the Distance Between the parts. -integer indicates nr of parts|"));
	// . Negative number will indicate nr of parts from the integer part of the inserted double
	dDistanceBetween.setCategory(category);
	// screw types
	// nr of parts/distance in between
	String sDistanceBetweenResultName=T("|Distance between|");	
	PropDouble dDistanceBetweenResult(nDoubleIndex++, U(0), sDistanceBetweenResultName);	
	dDistanceBetweenResult.setDescription(T("|Shows the calculated distance between the articles|"));
	dDistanceBetweenResult.setReadOnly(true);
	dDistanceBetweenResult.setCategory(category);
	
	String sNrResultName=T("|Nr.|");	
//	int nNrResults[]={1,2,3};
	PropInt nNrResult(nIntIndex++, 0, sNrResultName);	
	nNrResult.setDescription(T("|Shows the calculated quantity of articles|"));
	nNrResult.setReadOnly(true);
	nNrResult.setCategory(category);
//End properties//endregion 
	
// bOnInsert//region
	if(_bOnInsert)
	{
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
			if (!bOk)
			{
				reportNotice("\n" + scriptName() + ": " + T("|NOTE, the specified OPM key| '") +sOpmKey+T("' |cannot be found in the list of Manufacturers.|"));
				sOpmKey = "";
			}
		}
		else
		{
		// sOpmKey not specified, show the dialog
			sProject.setReadOnly(true);
			sManufacturer.setReadOnly(false);
			sModel.set("---");
			sModel.setReadOnly(true);
			sArticle.set("---");
			sArticle.setReadOnly(true);
			sCDREf.setReadOnly(false);
			nNumber.setReadOnly(false);
			
			dDistanceBottom.setReadOnly(false);
			dDistanceTop.setReadOnly(false);
			dDistanceBetween.setReadOnly(false);
			dDistanceBetweenResult.setReadOnly(true);
			nNrResult.setReadOnly(true);
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
					Map mapModels = mapManufacturerI.getMap("Model[]");
					if (mapModels.length() < 1)
					{
						// wrong definition of the map
						reportMessage(TN("|no Model definition for this manufacturer|"));
						eraseInstance();
						return;
					}
					for (int j = 0; j < mapModels.length(); j++)
					{
						Map mapModelJ = mapModels.getMap(j);
						if (mapModelJ.hasString("Name") && mapModels.keyAt(j).makeLower() == "model")
						{
							String sName = mapModelJ.getString("Name");
							if (sModels.find(sName) < 0)
							{
								// populate sFamilies
								sModels.append(sName);
								if (bDebug)reportMessage("\n" + scriptName() + " sName: " + sName);
							}
						}
					}
				
				// set the model
					if (sTokens.length() < 2)// Model not defined in opmkey, showdialog
					{ 
						// set array of smodels and get the first by default
						// manufacturer is set, set as readOnly
						sProject.setReadOnly(true);
						sManufacturer.setReadOnly(true);
						sModel.setReadOnly(false);
						sModel = PropString(2, sModels, sModelName, 0);
						sModel.set(sModels[0]);
						sArticle = PropString(3, sArticles, sArticleName, 0);
						sArticle.set("---");
						sArticle.setReadOnly(true);
						sCDREf.setReadOnly(false);
						nNumber.setReadOnly(false);
						
						dDistanceBottom.setReadOnly(false);
						dDistanceTop.setReadOnly(false);
						dDistanceBetween.setReadOnly(false);
						dDistanceBetweenResult.setReadOnly(true);
						nNrResult.setReadOnly(true);
						showDialog("---");
	//					showDialog();
						
						if(bDebug)reportMessage("\n"+ scriptName() + " from dialog ");
						if(bDebug)reportMessage("\n"+ scriptName() + " sArticle "+sArticle);
					}
					else
					{ 
						// see if sTokens[1] is a valid model name as in sModels from mapSetting
						int indexSTokens = sModels.find(sTokens[1]);
						if (indexSTokens >- 1)
						{ 
							// find
			//				sModel = PropString(1, sModels, sModelName, indexSTokens);
							sModel.set(sTokens[1]);
							if(bDebug)reportMessage("\n"+ scriptName() + " from tokens ");
						}
						else
						{ 
							// wrong definition in the opmKey, accept the first model from the xml
							reportMessage(TN("|wrong definition of the OPM key|"));
							sModel.set(sModels[0]);
						}
					}
					if (sModel != "---")
					{ 
						// for the chosen family get models and nails. first find the map of selected family
						for (int j = 0; j < mapModels.length(); j++)
						{ 
							Map mapModelJ = mapModels.getMap(j);
							if (mapModelJ.hasString("Name") && mapModels.keyAt(j).makeLower() == "model")
							{
								String _sModelName = mapModelJ.getString("Name");
								if (_sModelName.makeUpper() != sModel.makeUpper())
								{
									// not this model, keep looking
									continue;
								}
							}
							else
							{
								// not a manufacturer map
								continue;
							}
							
							// mapModelJ is found, populate types and nails
							// map of the selected model is found
							// get its types
							Map mapArticles = mapModelJ.getMap("Article[]");
							if (mapArticles.length() < 1)
							{
								// wrong definition of the map
								reportMessage(TN("|no article definition for this family|"));
								eraseInstance();
								return;
							}
							
							for (int k = 0; k < mapArticles.length(); k++)
							{
								Map mapArticleK = mapArticles.getMap(k);
								if (mapArticleK.hasString("Name") && mapArticles.keyAt(k).makeLower() == "article")
								{
									String sName = mapArticleK.getString("Name");
									if (sArticles.find(sName) < 0)
									{
										// populate sArticles
										sArticles.append(sName);
										if (bDebug)reportMessage("\n" + scriptName() + " sName: " + sName);
									}
								}
							}
							
							// set the model
							if (sTokens.length() < 3)
							{ 
								// article not set in opm key, show the dialog to get the opm key
								// set array of sArticles and get the first by default
								// model is set, set as readOnly
								sProject.setReadOnly(true);
								sManufacturer.setReadOnly(true);
								sModel.setReadOnly(true);
								
								sArticle.setReadOnly(false);
								sArticle = PropString(3, sArticles, sArticleName, 0);
								sArticle.set(sArticles[0]);
								sCDREf.setReadOnly(false);
								nNumber.setReadOnly(false);
								
								dDistanceBottom.setReadOnly(false);
								dDistanceTop.setReadOnly(false);
								dDistanceBetween.setReadOnly(false);
								dDistanceBetweenResult.setReadOnly(true);
								nNrResult.setReadOnly(true);
								//
								showDialog("---");
		//						showDialog();
								if(bDebug)reportMessage("\n"+ scriptName() + " from dialog ");
								if(bDebug)reportMessage("\n"+ scriptName() + " sArticle "+sArticle);
							}
							else
							{ 
								// see if sTokens[1] is a valid model name as in sModels from mapSetting
								int indexSTokens = sArticles.find(sTokens[1]);
								if (indexSTokens >- 1)
								{ 
									// find
					//				sModel = PropString(1, sModels, sModelName, indexSTokens);
									sArticle.set(sTokens[1]);
									if(bDebug)reportMessage("\n"+ scriptName() + " from tokens ");
								}
								else
								{ 
									// wrong definition in the opmKey, accept the first model from the xml
									reportMessage(TN("|wrong definition of the OPM key|"));
									sArticle.set(sArticles[0]);
								}
							}
							// models and nails are set
							break;
						}
						// family is set
						break;
					}
					else
					{ 
						sArticle.set(sArticles[0]);
						break;
					}
				}
			}
		}
		else
		{ 
			sModel.set(sModels[0]);
			sArticle.set(sArticles[0]);
		}
//	// silent/dialog
//		String sKey = _kExecuteKey;
//		sKey.makeUpper();
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
		// prompt selection of panels
		Entity ents[0];
		
		PrEntity ssE(T("|Select panel(s) or Enter to define a distribution|"), Sip());
		if (ssE.go())
			ents.append(ssE.set());
		
		if (ents.length() > 0)
		{ 
			Sip sips[0];
			for (int i = 0; i < ents.length(); i++)
			{ 
				Sip sip = (Sip)ents[i];
				if (sip.bIsValid() && sips.find(sip) < 0)sips.append(sip);
			}//next i
			
			_Sip.append(sips);
		}
		else
		{ 
			// prompt to select points
			_PtG.append(getPoint(TN("|Select start point of distribution|")));
			_PtG.append(getPoint(TN("|Select end point of distribution|")));
//			_Map.setPoint3d("ptStart", ptStart);
//			_Map.setPoint3d("ptEnd", ptEnd);
		}
		return;
	}
// end on insert	__________________//endregion
	
	if(dDistanceBetween ==0)
		dDistanceBetween.set(U(5));
//region get map of manufacturer
	sProject.set(sProjectNr);
	// manufacturer should not be allowed to change
	Map mapManufacturer;
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
		int indexManufacturer = sManufacturers.find(sManufacturer);
	//End get map of manufacturer//endregion
	// get the models of this model and populate the property list
		Map mapModels = mapManufacturer.getMap("Model[]");
		sModels.setLength(0);
		sModels.append("---");
		for (int i = 0; i < mapModels.length(); i++)
		{
			Map mapModelI = mapModels.getMap(i);
			if (mapModelI.hasString("Name") && mapModels.keyAt(i).makeLower() == "model")
			{
				String sName = mapModelI.getString("Name");
				if (sModels.find(sName) < 0)
				{
					// populate sModels with all the sModels of the selected manufacturer
					sModels.append(sName);
				}
			}
		}
		int indexModel = sModels.find(sModel);
		if (indexModel >- 1 )
		{
			// selected sModelis contained in sModels
			sModel = PropString(2, sModels, sModelName, indexModel);
//			sModel.set(sModels[indexModel]);
			if(sManufacturer!="---"&& indexModel==0 && _kNameLastChangedProp==sManufacturerName)
			{
				sModel.set(sModels[1]);
//					sModel = PropString(1, sModels, sModelName, 1);
			}
		}
		else
		{
			// existing sModel is not found, model has been changed so set 
			// to sModel the first Model from sModels
			sModel = PropString(2, sModels, sModelName, 1);
			sModel.set(sModels[1]);
		}
		if (sModel != "---")
		{ 
			// get map of model
			Map mapModel;
			for (int i = 0; i < mapModels.length(); i++)
			{ 
				Map mapModelI = mapModels.getMap(i);
				if (mapModelI.hasString("Name") && mapModels.keyAt(i).makeLower() == "model")
				{
					String _sModelName = mapModelI.getString("Name");
					String _sModel = sModel;_sModel.makeUpper();
					if (_sModelName.makeUpper() != _sModel)
					{
						continue;
					}
				}
				else
				{ 
					// not a manufacturer map
					continue;
				}
				mapModel = mapModels.getMap(i);
				break;
			}
	// set Type
			Map mapArticles = mapModel.getMap("Article[]");
			sArticles.setLength(0);
			for (int i = 0; i < mapArticles.length(); i++)
			{
				Map mapArticleI = mapArticles.getMap(i);
				if (mapArticleI.hasString("Name") && mapArticles.keyAt(i).makeLower() == "article")
				{
					String sName = mapArticleI.getString("Name");
					if (sArticles.find(sName) < 0)
					{
						// populate sArticles with all the sArticles of the selected categry
						sArticles.append(sName);
					}
				}
			}
			int indexArticle = sArticles.find(sArticle);
			if (indexArticle >- 1)
			{
				// selected sModelis contained in sModels
				sArticle = PropString(3, sArticles, sArticleName, indexArticle);
				if(sModel!="---"&& indexArticle==0 && (_kNameLastChangedProp==sManufacturerName || _kNameLastChangedProp==sModelName))
				{
					sArticle.set(sArticles[0]);
//					sArticle = PropString(2, sArticles, sArticleName, 1);
				}
			}
			else
			{
				// existing sModel is not found, Article has been changed so set 
				// to sModel the first Model from sModels
				sArticle = PropString(3, sArticles, sArticleName, 0);
				sArticle.set(sArticles[0]);
			}
		}
		else
		{ 
			sArticles.setLength(0);
			sArticles.append("---");
			sArticle = PropString(3, sArticles, sArticleName, 0);
			sArticle.set(sArticles[0]);
		}
	}
	else
	{ 
		sModels.setLength(0);
		sModels.append("---");
		
		sModel = PropString(2, sModels, sModelName, 0);
		sModel.set(sModels[0]);
		sArticles.setLength(0);
		sArticles.append("---");
		sArticle = PropString(3, sArticles, sArticleName, 0);
		sArticle.set(sArticles[0]);
	}
	
	// get map of the selected article
	Map mapArticle;
	int iArticleFound = false;
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
						Map mapModels = mapManufacturer.getMap("Model[]");
						for (int ii = 0; ii < mapModels.length(); ii++)
						{
							Map mapModelI = mapModels.getMap(ii);
							if (mapModelI.hasString("Name") && mapModels.keyAt(ii).makeLower() == "model")
							{
								String sName = mapModelI.getString("Name");
								String _sModelName = mapModelI.getString("Name");
								String _sModel = sModel;_sModel.makeUpper();
								if (_sModelName.makeUpper() == _sModel)
								{ 
									// this model
									Map mapModel = mapModelI;
									Map mapArticles = mapModel.getMap("Article[]");
									for (int iii = 0; iii < mapArticles.length(); iii++)
									{ 
										Map mapArticleI = mapArticles.getMap(iii);
										if (mapArticleI.hasString("Name") && mapArticles.keyAt(iii).makeLower() == "article")
										{ 
											String sName = mapArticleI.getString("Name");
											String _sArticleName = mapArticleI.getString("Name");
											String _sArticle = sArticle;_sArticle.makeUpper();
											if (_sArticleName.makeUpper() == _sArticle)
											{ 
												mapArticle = mapArticleI;
												iArticleFound = true;
												break;
											}
										}
									}
									if (iArticleFound)break;
								}
							}
						}
						if (iArticleFound)break;
					}
				}
			}
		}
	}
	
	// get map of connectionType
	Map mapConnection;
	for (int i = 0; i < mapConnection_types.length(); i++)
	{
		Map mapConnection_typeI = mapConnection_types.getMap(i);
		if (mapConnection_typeI.hasString("CD-Ref") && mapConnection_types.keyAt(i).makeLower() == "code")
		{
			String _sConnection_type = mapConnection_typeI.getString("CD-Ref");
			if (_sConnection_type == sCDREf)
			{
				mapConnection=mapConnection_typeI;
				break;
			}
		}
	}
	int iColour = mapConnection.getInt("Colour");
	Point3d ptsDis[0];
if(_Sip.length()>=2)
{ 
	if (_Sip.length() < 2)
	{ 
		reportMessage(TN("|2 panels needed|"));
		eraseInstance();
		return;
	}
//	reportMessage("\n" + scriptName() + " nr sips: " + _Sip.length());
//	return
	int iMode = _Map.getInt("iMode");
	if(iMode==0)
	{ 
		_Map.setInt("iMode", 1);
		// distribution mode
		// collect all couples that have a common range and create a tsl for each couple
		int iParallel[0];
		int jParallel[0];
		for (int i=0;i<_Sip.length();i++) 
		{ 
			for (int j=0;j<_Sip.length();j++) 
			{ 
				// no pair with itself
				if (i == j)continue;
				Sip sipI = _Sip[i];
				Point3d ptCenI = sipI.ptCen();
				Vector3d vecXi = sipI.vecX();
				Vector3d vecYi = sipI.vecY();
				Vector3d vecZi = sipI.vecZ();
				double dZi = sipI.dD(vecZi);
				Body bdI = sipI.envelopeBody(true, true);
				Sip sipJ = _Sip[j];
				Point3d ptCenJ = sipJ.ptCen();
				Vector3d vecXj = sipJ.vecX();
				Vector3d vecYj = sipJ.vecY();
				Vector3d vecZj = sipJ.vecZ();
				double dZj = sipJ.dD(vecZj);
				Body bdJ = sipJ.envelopeBody(true, true);
				
				// support only 90 degree connections or parallel
//				if ( ! vecZi.isPerpendicularTo(vecZj) && !vecZi.isParallelTo(vecZj))
//					continue;
				
				if(vecZi.isPerpendicularTo(vecZj))
				{ 
					Sip sipMale, sipFemale;
					int iCommonPlaneFound = false;
					// sipi female, sipj male
					{
						// project to female and must have intersection
						PlaneProfile ppIi = bdI.shadowProfile(Plane(ptCenI , vecZi));
						PlaneProfile ppJi = bdJ.shadowProfile(Plane(ptCenI , vecZi));
						ppIi.shrink(dEps);
						ppJi.shrink(dEps);
						PlaneProfile ppInter = ppIi;
						ppInter.intersectWith(ppJi);
						if(ppInter.area()<dEps || !ppIi.intersectWith(ppJi))
						{ 
							// sipI not a female
							continue;
						}
					}
					
					// get extractContactFaceInPlane from the 2 panels
					PlaneProfile ppI = bdI.extractContactFaceInPlane(Plane(ptCenI + .5 * vecZi * dZi, vecZi), dEps);
//					ppI.vis(3);
					PlaneProfile ppJ = bdJ.extractContactFaceInPlane(Plane(ptCenI + .5 * vecZi * dZi, vecZi), dEps);
//					ppJ.vis(3);
					iCommonPlaneFound = true;
					if (ppJ.area() < dEps)iCommonPlaneFound = false;
					if(iCommonPlaneFound)
					{ 
						sipFemale = sipI;
						sipMale = sipJ;
					}
					if(!iCommonPlaneFound)
					{ 
						// try -vecZi
						ppI = bdI.extractContactFaceInPlane(Plane(ptCenI - .5 * vecZi * dZi, vecZi), dEps);
						ppI.vis(3);
						
						ppJ = bdJ.extractContactFaceInPlane(Plane(ptCenI - .5 * vecZi * dZi, vecZi), dEps);
						ppJ.vis(3);
					}
					iCommonPlaneFound = true;
					if (ppJ.area() < dEps)iCommonPlaneFound = false;
					if(iCommonPlaneFound)
					{ 
						sipFemale = sipI;
						sipMale = sipJ;
					}
					// sipI male and sipJ female
//					if ( ! iCommonPlaneFound)
//					{ 
//						// try sipi male and sipj female
//						iCommonPlaneFound = false;
//						PlaneProfile ppI = bdI.extractContactFaceInPlane(Plane(ptCenJ + .5 * vecZj * dZj, vecZj), dEps);
//	//					ppI.vis(3);
//						PlaneProfile ppJ = bdJ.extractContactFaceInPlane(Plane(ptCenJ + .5 * vecZj * dZj, vecZj), dEps);
//	//					ppJ.vis(3);
//						iCommonPlaneFound = true;
//						if (ppI.area() < dEps)iCommonPlaneFound = false;
//						if(iCommonPlaneFound)
//						{ 
//							sipFemale = sipJ;
//							sipMale = sipI;
//						}
//						if(!iCommonPlaneFound)
//						{ 
//							// try -vecZi
//							ppI = bdI.extractContactFaceInPlane(Plane(ptCenJ - .5 * vecZj * dZj, vecZj), dEps);
//							ppI.vis(3);
//							
//							ppJ = bdJ.extractContactFaceInPlane(Plane(ptCenJ - .5 * vecZj * dZj, vecZj), dEps);
//							ppJ.vis(3);
//						}
//						if (ppI.area() < dEps)iCommonPlaneFound = false;
//						if(iCommonPlaneFound)
//						{ 
//							sipFemale = sipJ;
//							sipMale = sipI;
//						}
//					}
//					
					if (iCommonPlaneFound)
					{ 
					// create TSL
						TslInst tslNew;	Vector3d vecXTsl= _XW;	Vector3d vecYTsl= _YW;
						GenBeam gbsTsl[] = {sipMale, sipFemale}; Entity entsTsl[] = {};	Point3d ptsTsl[] = {_Pt0};
						int nProps[] ={ nNumber, nNrResult };	
						double dProps[] ={ dDistanceBottom,dDistanceTop,dDistanceBetween, dDistanceBetweenResult};	
						String sProps[] ={sProject, sManufacturer, sModel, sArticle,sCDREf};
						Map mapTsl;	
						//
						mapTsl.setInt("iMode", 1);
						tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			
					}
//					// 90 degree connection
//					// project to xy of sipj
//					PlaneProfile ppIj(sipJ.coordSys());
//					ppIj = bdI.shadowProfile(Plane(ptCenJ, vecZj));
//					PlaneProfile ppJj(sipJ.coordSys());
//					ppJj = bdJ.shadowProfile(Plane(ptCenJ, vecZj));
//					
////					ppIj.vis(2);
////					ppJj.vis(2);
//					ppIj.shrink(-dEps);
//					ppJj.shrink(-dEps);
//					
//					PlaneProfile ppInter = ppIj;
//					ppInter.intersectWith(ppJj);
//					ppInter.vis(3);
//					
//					
//					// sipi female, sipj male
//					PlaneProfile ppIi(sipI.coordSys());
//					ppIi = bdI.shadowProfile(Plane(ptCenI, vecZi));
//					PlaneProfile ppJi(sipI.coordSys());
//					ppJi=bdJ.shadowProfile(Plane(ptCenI, vecZi));
				}
				if(vecZi.isParallelTo(vecZj))
				{ 
					Body bdItot = sipI.envelopeBody(false, false);
					Body bdJtot = sipJ.envelopeBody(false, false);
					Body bdIReal = sipI.realBody();
					Body bdJReal = sipJ.realBody();
					if ( ! bdItot.hasIntersection(bdJtot))continue;
					// parallel connection
					PlaneProfile ppI = bdIReal.shadowProfile(Plane(ptCenJ + .5 * vecZj * dZj, vecZj));
					PlaneProfile ppJ = bdJReal.shadowProfile(Plane(ptCenJ + .5 * vecZj * dZj, vecZj));
					
					// find common range
					PlaneProfile ppCommon = ppI;
					int iHasIntersect = ppCommon.intersectWith(ppJ);
					if (ppCommon.area() > pow(dEps, 2) || iHasIntersect)
					{ 
						// check if this Article already inserted
						{ 
							int iExist = false;
							for (int ii=0;ii<iParallel.length();ii++) 
							{ 
								if(iParallel[ii]==j && jParallel[ii]==i)
								{ 
									iExist = true;
									break;
								}
								 
							}//next ii
							if (iExist)continue;
							iParallel.append(i);
							jParallel.append(j);
						}
					// create TSL
						TslInst tslNew;	Vector3d vecXTsl= _XW;	Vector3d vecYTsl= _YW;
						GenBeam gbsTsl[] = { sipI, sipJ};	Entity entsTsl[] = { };	Point3d ptsTsl[] = { _Pt0};
						int nProps[]={nNumber, nNrResult}; 
						double dProps[]={dDistanceBottom,dDistanceTop,dDistanceBetween, dDistanceBetweenResult}; 
						String sProps[]={sProject,sManufacturer, sModel, sArticle,sCDREf};
						Map mapTsl;	
						mapTsl.setInt("iMode", 1);
						//
						tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			
					}
				}
				else //if(0)
				{ 
					_Pt0 = sipI.ptCen();
					_ThisInst.setAllowGripAtPt0(false);
					// no nead for setCompareKey, instances with no body representation will get a different posnum
					Body bdItot = sipI.envelopeBody(true,false);
					Body bdJtot = sipJ.envelopeBody(true,false);
					Quader qdi(ptCenI, vecXi, vecYi, vecZi, sipI.solidLength(), sipI.dD(vecYi), sipI.dD(vecZi));
					Quader qdj(ptCenJ, vecXj, vecYj, vecZj, sipJ.solidLength(), sipJ.dD(vecYj), sipJ.dD(vecZj));
					Body bdiQuad(qdi);
					Body bdjQuad(qdj);
					bdiQuad.vis(3);
					bdjQuad.vis(4);
					if ( ! bdiQuad.hasIntersection(bdjQuad))continue;
					
				// check if this Article already inserted
					{ 
						int iExist = false;
						for (int ii=0;ii<iParallel.length();ii++) 
						{ 
							if(iParallel[ii]==j && jParallel[ii]==i)
							{ 
								iExist = true;
								break;
							}
							 
						}//next ii
						if (iExist)continue;
						iParallel.append(i);
						jParallel.append(j);
					}
					
					// two plane vectors pointing on the same side
					Vector3d vecZiSide = sipI.vecZ();
					Vector3d vecZjSide = sipJ.vecZ();
					
					if (vecZjSide.dotProduct(vecZiSide) < 0)
						vecZjSide *= -1;
						
					Plane pniSide(ptCenI + vecZiSide * .5 * dZi, vecZiSide);
					Plane pnjSide(ptCenJ + vecZjSide * .5 * dZj, vecZjSide);
					Line ln1 = pniSide.intersect(pnjSide);
					
					Plane pniSide1(ptCenI - vecZiSide * .5 * dZi, vecZiSide);
					Plane pnjSide1(ptCenJ - vecZjSide * .5 * dZj, vecZjSide);
					Line ln2 = pniSide1.intersect(pnjSide1);
					
				// create TSL //
					TslInst tslNew;	Vector3d vecXTsl= _XW;	Vector3d vecYTsl= _YW;
					GenBeam gbsTsl[] = { sipI, sipJ};	Entity entsTsl[] = { };	Point3d ptsTsl[] = { _Pt0};
					int nProps[]={nNumber, nNrResult}; 
					double dProps[]={dDistanceBottom,dDistanceTop,dDistanceBetween, dDistanceBetweenResult}; 
					String sProps[]={sProject,sManufacturer, sModel, sArticle,sCDREf};
					Map mapTsl;	
					mapTsl.setInt("iMode", 1);
					//
					tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	
				}
			}//next j
		}//next i
		eraseInstance();
		return;
	}
//	return
	
	if (iMode == 1 || iMode == 2)
	{ 
		if (_bOnDbCreated)
		{
			setExecutionLoops(2);
		}
//		else if (_kExecutionLoopCount == 1)
//		{ 
//			setExecutionLoops(3);
//		}
		if(_Sip.length()!=2)
		{ 
			reportMessage(TN("|2 panels required|"));
			eraseInstance();
			return;
		}
		// male
		Sip sip0 = _Sip[0];
		Vector3d vecX0 = sip0.vecX();
		Vector3d vecY0 = sip0.vecY();
		Vector3d vecZ0 = sip0.vecZ();
		Point3d ptCen0 = sip0.ptCen();
		double dZ0 = sip0.dD(vecZ0);
		Body bd0 = sip0.envelopeBody(true, true);
		Body bd0Real = sip0.realBody();
		// female
		Sip sip1 = _Sip[1];
		Vector3d vecX1 = sip1.vecX();
		Vector3d vecY1 = sip1.vecY();
		Vector3d vecZ1 = sip1.vecZ();
		Point3d ptCen1 = sip1.ptCen();
		double dZ1 = sip1.dD(vecZ1);
		Body bd1 = sip1.envelopeBody(true, true);
		Body bd1Real = sip1.realBody();
		bd1Real.vis(4);
//		bd1.vis(4);
		CoordSys cs = sip1.coordSys();
		// part length/diameter
//		double dPartLength = U(10);
		double dPartLength = U(0);
		
		
		_Pt0 = ptCen0;
//		return;
		Display dp(iColour);
//		Point3d ptsDis[0];
		ptsDis.setLength(0);
		if(vecZ0.isPerpendicularTo(vecZ1))
		{ 
			// normal connection
			//sip0 male; sip1 female
			// vector pointing from female to male panel
			Vector3d vecZfemale = vecZ1;
			PlaneProfile pp0 = bd0Real.extractContactFaceInPlane(Plane(ptCen1 + .5 * vecZ1 * dZ1, vecZ1), dEps);
			PlaneProfile pp1 = bd1Real.extractContactFaceInPlane(Plane(ptCen1 + .5 * vecZ1 * dZ1, vecZ1), dEps);
			if(pp0.area()<dEps)
			{ 
				pp0 = bd0Real.extractContactFaceInPlane(Plane(ptCen1 - .5 * vecZ1 * dZ1, vecZ1), dEps);
				pp1 = bd1Real.extractContactFaceInPlane(Plane(ptCen1 - .5 * vecZ1 * dZ1, vecZ1), dEps);
				vecZfemale = - vecZ1;
			}
			pp0.vis(3);
			pp1.vis(3);
			PlaneProfile pp = pp0;
			pp.intersectWith(pp1);
			// display of area of screw distribution
//			dp.draw(pp);
			PLine pls[] = pp.allRings();
			// sort planeprofiles
			PlaneProfile pps[0];Point3d pts[0];
			for (int i=0;i<pls.length();i++) 
			{ 
				PlaneProfile ppi = pp;ppi.subtractProfile(pp);
				ppi.joinRing(pls[i], _kAdd);
				pps.append(ppi);
				LineSeg segi = ppi.extentInDir(vecX0);
				Point3d pti = segi.ptMid();
				pts.append(pti);
			}//next i
		// order alphabetically
			for (int i=0;i<pts.length();i++) 
				for (int j=0;j<pts.length()-1;j++) 
					if (vecX0.dotProduct(pts[j]) > vecX0.dotProduct(pts[j + 1]))
						{
							pts.swap(j, j + 1);
							pls.swap(j, j + 1);
						}
				
			// distribute for each ring
			if(iMode==1)
			{ 
				// set for this the calculation mode
				_Map.setInt("iMode", 2);
				_Map.setInt("iRing", 0);
				// create other TSLs
				if (pls.length() > 1)
				{ 
					for (int i = 1; i < pls.length(); i++)
					{ 
					// create TSL
						TslInst tslNew;	Vector3d vecXTsl= _XW;	Vector3d vecYTsl= _YW;
						GenBeam gbsTsl[] = { sip0, sip1};	Entity entsTsl[] = { };	Point3d ptsTsl[] = { _Pt0};
						int nProps[]={nNumber, nNrResult}; 
						double dProps[]={dDistanceBottom,dDistanceTop,dDistanceBetween, dDistanceBetweenResult}; 
						String sProps[]={sProject,sManufacturer, sModel, sArticle,sCDREf};
						Map mapTsl;	
						mapTsl.setInt("iMode", 2);
						mapTsl.setInt("iRing", i);
						//
						tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
						if (_Entity.find(tslNew) < 0)_Entity.append(tslNew);
					}//next i
				}
			}
			if (iMode == 2)
			{ 
				// calculation mode
				int iRing = _Map.getInt("iRing");
				if (pls.length() < iRing + 1)
				{ 
					// 
					eraseInstance();
					return;
				}
				PLine pl = pls[iRing];
				PlaneProfile ppThis = pp;
				ppThis.subtractProfile(pp);
				ppThis.joinRing(pl, _kAdd);
				Point3d ptMidPpThis;
				{ 
					// get center of ppthis
					// get extents of profile
					LineSeg seg = ppThis.extentInDir(vecZ0);
					ptMidPpThis = seg.ptMid();
				}
				dp.draw(ppThis);
//				Point3d pts[] = pl.intersectPoints(Plane(ptCen0, vecZ0));
				Point3d pts[] = pl.intersectPoints(Plane(ptMidPpThis, vecZ0));
				if(pts.length()<2)
				{ 
					Display dpError(1);
					dpError.draw("Error", _Pt0, _XW, _YW, 0, 0, _kDeviceX);
					return;
				}
				if (pts.length() != 2)
				{ 
//					reportMessage(TN("|unexpected error|"));
//					eraseInstance();
//					return;
					// sort the points
					Vector3d vecDir = pts.last() - pts.first();
					vecDir.normalize();
					// project points in line and order them
					pts = Line(pts[0],vecDir).orderPoints(Line(pts[0],vecDir).projectPoints(pts));
				}
				pts.first().vis(1);
				pts.last().vis(1);
				// distribute between 2 points
				Point3d ptStart = pts.first();
				Point3d ptEnd = pts.last();
				if(_PtG.length()==0)
				{ 
					_PtG.append(ptStart);
					_PtG.append(ptEnd);
				}
				else
				{ 
					ptStart = _PtG[0];
					ptEnd = _PtG[1];
				}
				Vector3d vecDir = ptEnd - ptStart;
				vecDir.normalize();
				vecDir.vis(ptStart);
				double dLengthTot = (ptEnd - ptStart).dotProduct(vecDir);
				// set pt0
				LineSeg seg = ppThis.extentInDir(vecDir);
				_Pt0 = seg.ptMid();
				_ThisInst.setAllowGripAtPt0(false);
				//
				if (dDistanceBottom + dDistanceTop > dLengthTot)
				{ 
					reportMessage(TN("|no distribution possible|"));
					return;
				}
				Point3d pt1 = ptStart + vecDir * dDistanceBottom;
				Point3d pt2 = ptEnd - vecDir * (dDistanceTop+ dPartLength);
				double dDistTot = (pt2 - pt1).dotProduct(vecDir);
				if (dDistTot < 0)
				{ 
					reportMessage(TN("|no distribution possible|"));
					return;
				}
				if (dDistanceBetween >= 0)
				{ 
					// distance in between > 0; distribute with distance
					// modular distance
					double dDistMod = dDistanceBetween + dPartLength;
					int iNrParts = dDistTot / dDistMod;
					// calculated modular distance between subsequent parts
					
					double dDistModCalc = 0;
					if (iNrParts != 0)
						dDistModCalc = dDistTot / iNrParts;
					
					// first point
					Point3d pt;
					pt = ptStart + vecDir * (dDistanceBottom + dPartLength / 2);
	//				pt.vis(1);
					ptsDis.append(pt);
					if(dDistModCalc>0)
					{ 
						for (int i = 0; i < iNrParts; i++)
						{ 
							pt += vecDir * dDistModCalc;
		//					pt.vis(1);
							ptsDis.append(pt);
						}
					}
					dDistanceBetweenResult.set(dDistModCalc-dPartLength);
					// set nr of parts
//					dDistanceBetweenResult.set(-(ptsDis.length()));
					nNrResult.set(ptsDis.length());
				}
				else
				{ 
					double dDistModCalc;
					//
					int nNrParts = -dDistanceBetween / 1;
					if(nNrParts==1)
					{ 
						dDistModCalc = dDistanceBottom;
						ptsDis.append(ptStart + vecDir * dDistanceBottom );
					}
					else
					{ 
						double dDistMod = dDistTot / (nNrParts - 1);
						dDistModCalc = dDistMod;
						int nNrPartsCalc = nNrParts;
						// clear distance between parts
						double dDistBet = dDistMod - dPartLength;
						if (dDistBet < 0)
						{ 
							// distance between 2 subsequent parts < 0
							
							dDistModCalc = dPartLength;
							// nr of parts in between 
							nNrPartsCalc = dDistTot / dDistModCalc;
							nNrPartsCalc += 1;
						}
						// first point
						Point3d pt;
						pt = ptStart + vecDir * (dDistanceBottom + dPartLength / 2);
						ptsDis.append(pt);
						pt.vis(1);
						for (int i = 0; i < (nNrPartsCalc - 1); i++)
						{ 
							pt += vecDir * dDistModCalc;
							pt.vis(1);
							ptsDis.append(pt);
						}//next i
					}
					// set calculated distance between parts
//					dDistanceBetweenResult.set(dDistModCalc-dPartLength);
					dDistanceBetweenResult.set(dDistModCalc-dPartLength);
					// set nr of parts
					nNrResult.set(ptsDis.length());
				}
				// draw distribution
				for (int i=0;i<ptsDis.length();i++) 
				{ 
					Point3d pt = ptsDis[i];
					PLine pl(vecZ1);
//					pl.createCircle(pt, vecZ1, dPartLength / 2);
					pl.createCircle(pt, vecZ1, U(5));
					dp.draw(pl);
				}//next i
			}
		}
		else if(vecZ0.isParallelTo(vecZ1))
		{ 
			// parallel connection
			Sip sipMale, sipFemale;
			Body bd0tot = sip0.envelopeBody(false, false);
			Body bd1tot = sip1.envelopeBody(false, false);
			
			if ( ! bd0tot.hasIntersection(bd1tot))
			{
				reportMessage(TN("|unexpected error|"));
				eraseInstance();
				return;
			}
			
			PlaneProfile pp0 = bd0Real.shadowProfile(Plane(ptCen1 + .5 * vecZ1 * dZ1, vecZ1));
			PlaneProfile pp1 = bd1Real.shadowProfile(Plane(ptCen1 + .5 * vecZ1 * dZ1, vecZ1));
			
			PlaneProfile pp = pp0;
			int iHasIntersect = pp.intersectWith(pp1);
			if(!iHasIntersect)
			{ 
				// no intersection
				reportMessage(TN("|no intersection|"));
				eraseInstance();
				return;
			}
			PLine pls[] = pp.allRings();
			// sort planeprofiles
			PlaneProfile pps[0];Point3d pts[0];
			for (int i=0;i<pls.length();i++) 
			{ 
				PlaneProfile ppi = pp;ppi.subtractProfile(pp);
				ppi.joinRing(pls[i], _kAdd);
				pps.append(ppi);
				LineSeg segi = ppi.extentInDir(vecX0);
				Point3d pti = segi.ptMid();
				pts.append(pti);
			}//next i
			
		// get extents of profile
			LineSeg seg = pp.extentInDir(vecX0);
			double dX = abs(vecX0.dotProduct(seg.ptStart() - seg.ptEnd()));
			double dY = abs(vecY0.dotProduct(seg.ptStart() - seg.ptEnd()));
			Vector3d vecDistribution = vecX0;
			if (dY > dX)vecDistribution = vecY0;
		// order alphabetically
			for (int i = 0; i < pts.length(); i++)
				for (int j = 0; j < pts.length() - 1; j++)
					if (vecDistribution.dotProduct(pts[j]) > vecDistribution.dotProduct(pts[j + 1]))
					{
						pts.swap(j, j + 1);
						pls.swap(j, j + 1);
					}
					
			// distribute for each ring
			if(iMode==1)
			{ 
				// set for this the calculation mode
				_Map.setInt("iMode", 2);
				_Map.setInt("iRing", 0);
				// create other TSLs
				if (pls.length() > 1)
				{ 
					for (int i = 1; i < pls.length(); i++)
					{ 
					// create TSL
						TslInst tslNew;	Vector3d vecXTsl= _XW;	Vector3d vecYTsl= _YW;
						GenBeam gbsTsl[] = { sip0, sip1};	Entity entsTsl[] = { };	Point3d ptsTsl[] = { _Pt0};
						int nProps[]={nNumber, nNrResult}; 
						double dProps[]={dDistanceBottom,dDistanceTop,dDistanceBetween, dDistanceBetweenResult}; 
						String sProps[]={sProject,sManufacturer, sModel, sArticle,sCDREf};
						Map mapTsl;	
						mapTsl.setInt("iMode", 2);
						mapTsl.setInt("iRing", i);
						//
						tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
						if (_Entity.find(tslNew) < 0)_Entity.append(tslNew);
					}//next i
				}
			}
			if (iMode == 2)
			{ 
				// calculation mode
				int iRing = _Map.getInt("iRing");
				if (pls.length() < iRing + 1)
				{ 
					// 
					eraseInstance();
					return;
				}
				PLine pl = pls[iRing];
				PlaneProfile ppThis = pp;
				ppThis.subtractProfile(pp);
				ppThis.joinRing(pl, _kAdd);
				dp.draw(ppThis);
				// points for distribution
				Point3d ptStart, ptEnd;
				PLine plsThis[] = ppThis.allRings();
				Point3d ptsThis[0];
				// HSB-7510: find the smallest edge
				if(plsThis.length()>0)
					ptsThis= plsThis[0].vertexPoints(false);
				if(plsThis.length()==1 && ptsThis.length()==5)
				{ 
					double dDistMin=U(10e7); 
					int iMin = -1;
					// find smallest segment 
					for (int i=0;i<ptsThis.length()-1;i++) 
					{ 
						double dDist = (ptsThis[i] - ptsThis[i + 1]).length();
						if(dDist<dDistMin)
						{ 
							dDistMin = dDist;
							iMin = i;
						}
					}//next i
					int iMapMin2[] ={ 2, 3, 0, 1};
					ptStart = .5*(ptsThis[iMin] + ptsThis[iMin + 1]);
					ptEnd = .5*(ptsThis[iMapMin2[iMin]] + ptsThis[iMapMin2[iMin] + 1]);
					ptStart.vis(2);
					ptEnd.vis(2);
				}
				else
				{ 
					Point3d pts[] = pl.intersectPoints(Plane(seg.ptMid(), vecZ0.crossProduct(vecDistribution)));
					if (pts.length() != 2)
					{ 
	//					reportMessage(TN("|unexpected error|"));
	//					eraseInstance();
	//					return;
						// sort the points
						Vector3d vecDir = pts.last() - pts.first();
						vecDir.normalize();
						// project points in line and order them
						pts = Line(pts[0],vecDir).orderPoints(Line(pts[0],vecDir).projectPoints(pts));
					}
					pts.first().vis(1);
					pts.last().vis(1);
					// distribute between 2 points
					
					ptStart = pts.first();
					ptEnd = pts.last();
				}
				
				if(_PtG.length()==0)
				{ 
					_PtG.append(ptStart);
					_PtG.append(ptEnd);
				}
				else
				{ 
					ptStart = _PtG[0];
					ptEnd = _PtG[1];
				}
				Vector3d vecDir = ptEnd - ptStart;
				vecDir.normalize();
				vecDir.vis(ptStart);
				double dLengthTot = (ptEnd - ptStart).dotProduct(vecDir);
				// set pt0
				LineSeg seg = ppThis.extentInDir(vecDir);
				_Pt0 = seg.ptMid();
				_ThisInst.setAllowGripAtPt0(false);
				//
				if (dDistanceBottom + dDistanceTop > dLengthTot)
				{ 
					reportMessage(TN("|no distribution possible|"));
					return;
				}
				Point3d pt1 = ptStart + vecDir * dDistanceBottom;
				Point3d pt2 = ptEnd - vecDir * (dDistanceTop+ dPartLength);
				double dDistTot = (pt2 - pt1).dotProduct(vecDir);
				if (dDistTot < 0)
				{ 
					reportMessage(TN("|no distribution possible|"));
					return;
				}
				
				if (dDistanceBetween >= 0)
				{ 
					// distance in between > 0; distribute with distance
					// modular distance
					double dDistMod = dDistanceBetween + dPartLength;
					int iNrParts = dDistTot / dDistMod;
					// calculated modular distance between subsequent parts
					
					double dDistModCalc = 0;
					if (iNrParts != 0)
						dDistModCalc = dDistTot / iNrParts;
					
					// first point
					Point3d pt;
					pt = ptStart + vecDir * (dDistanceBottom + dPartLength / 2);
	//				pt.vis(1);
					ptsDis.append(pt);
					if(dDistModCalc>0)
					{ 
						for (int i = 0; i < iNrParts; i++)
						{ 
							pt += vecDir * dDistModCalc;
		//					pt.vis(1);
							ptsDis.append(pt);
						}
					}
					// 
//					dDistanceBetweenResult.set(-(ptsDis.length()));
					dDistanceBetweenResult.set(dDistModCalc-dPartLength);
					// set nr of parts
					nNrResult.set(ptsDis.length());
				}
				else
				{ 
					double dDistModCalc;
					//
					int nNrParts = -dDistanceBetween / 1;
					if(nNrParts==1)
					{ 
						dDistModCalc = dDistanceBottom;
						ptsDis.append(ptStart + vecDir * dDistanceBottom );
					}
					else
					{ 
						double dDistMod = dDistTot / (nNrParts - 1);
						dDistModCalc = dDistMod;
						int nNrPartsCalc = nNrParts;
						// clear distance between parts
						double dDistBet = dDistMod - dPartLength;
						if (dDistBet < 0)
						{ 
							// distance between 2 subsequent parts < 0
							
							dDistModCalc = dPartLength;
							// nr of parts in between 
							nNrPartsCalc = dDistTot / dDistModCalc;
							nNrPartsCalc += 1;
						}
						// first point
						Point3d pt;
						pt = ptStart + vecDir * (dDistanceBottom + dPartLength / 2);
						ptsDis.append(pt);
						pt.vis(1);
						for (int i = 0; i < (nNrPartsCalc - 1); i++)
						{ 
							pt += vecDir * dDistModCalc;
							pt.vis(1);
							ptsDis.append(pt);
						}//next i
					}
					// set calculated distance between parts
					dDistanceBetweenResult.set(dDistModCalc-dPartLength);
					// set nr of parts
					nNrResult.set(ptsDis.length());
				}
				// draw distribution
				for (int i=0;i<ptsDis.length();i++) 
				{ 
					Point3d pt = ptsDis[i];
					PLine pl(vecZ1);
//					pl.createCircle(pt, vecZ1, dPartLength / 2);
					pl.createCircle(pt, vecZ1, U(5));
					dp.draw(pl);
				}//next i
			}
		}
		else
		{ 
			// not perpendicular, not parallel connection, angle connection
			Body bd0tot = sip0.envelopeBody(false, false);
			Body bd1tot = sip1.envelopeBody(false, false);
			Quader qd0(ptCen0, vecX0, vecY0, vecZ0, sip0.solidLength(), sip0.dD(vecY0), sip0.dD(vecZ0));
			Quader qd1(ptCen1, vecX1, vecY1, vecZ1, sip1.solidLength(), sip1.dD(vecY1), sip1.dD(vecZ1));
			Body bd0Quad(qd0);bd0tot = bd0Quad;
			Body bd1Quad(qd1);bd1tot = bd1Quad;
			if ( ! bd0tot.hasIntersection(bd1tot))
			{
				reportMessage(TN("|unexpected error|"));
				eraseInstance();
				return;
			}
					
			Vector3d vecZ0Side = vecZ0;
			Vector3d vecZ1Side = vecZ1;
			
			if (vecZ1Side.dotProduct(vecZ0Side) < 0)
						vecZ1Side *= -1;
						
			Plane pn0Side(ptCen0 + vecZ0Side * .5 * dZ0, vecZ0Side);
			Plane pn1Side(ptCen1 + vecZ1Side * .5 * dZ1, vecZ1Side);
			Line ln1 = pn0Side.intersect(pn1Side);
			
			Plane pn0Side1(ptCen0 - vecZ0Side * .5 * dZ0, vecZ0Side);
			Plane pn1Side1(ptCen1 - vecZ1Side * .5 * dZ1, vecZ1Side);
			Line ln2 = pn0Side1.intersect(pn1Side1);
			
			// plane of intersection
			Plane pnIntersect(ln1.ptOrg(), ln1.ptOrg() + ln1.vecX() * U(100), ln2.ptOrg());
			Vector3d vecXpn = ln1.vecX().crossProduct(pnIntersect.normal());
			Vector3d vecYpn = ln1.vecX();
			
			Body bdInter=bd0tot;
			bdInter.intersectWith(bd1tot);
//			bdInter.vis(2);
			PlaneProfile ppInter = bdInter.shadowProfile(pnIntersect);
//			ppInter.vis(5);
			// get extents of profile
			LineSeg segInter = ppInter.extentInDir(vecXpn);
//			double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
//			double dY = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
			
			PLine plInter;
			plInter.createRectangle(segInter, vecXpn, vecYpn);
			
			PlaneProfile pp(plInter);
//			dp.draw(pp);
//			pp.vis(3);
			PLine pls[] = pp.allRings();
			// sort planeprofiles
			PlaneProfile pps[0];Point3d pts[0];
			for (int i=0;i<pls.length();i++) 
			{ 
				PlaneProfile ppi = pp;ppi.subtractProfile(pp);
				ppi.joinRing(pls[i], _kAdd);
				pps.append(ppi);
				LineSeg segi = ppi.extentInDir(vecX0);
				Point3d pti = segi.ptMid();
				pts.append(pti);
			}//next i
			
		// get extents of profile
			LineSeg seg = pp.extentInDir(vecXpn);
			double dX = abs(vecX0.dotProduct(seg.ptStart() - seg.ptEnd()));
			double dY = abs(vecY0.dotProduct(seg.ptStart() - seg.ptEnd()));
			Vector3d vecDistribution = vecYpn;
		// order alphabetically
			for (int i = 0; i < pts.length(); i++)
				for (int j = 0; j < pts.length() - 1; j++)
					if (vecDistribution.dotProduct(pts[j]) > vecDistribution.dotProduct(pts[j + 1]))
					{
						pts.swap(j, j + 1);
						pls.swap(j, j + 1);
					}
					
			// distribute for each ring
			if(iMode==1)
			{ 
				// set for this the calculation mode
				_Map.setInt("iMode", 2);
				_Map.setInt("iRing", 0);
				// create other TSLs
				if (pls.length() > 1)
				{ 
					for (int i = 1; i < pls.length(); i++)
					{ 
					// create TSL
						TslInst tslNew;	Vector3d vecXTsl= _XW;	Vector3d vecYTsl= _YW;
						GenBeam gbsTsl[] = { sip0, sip1};	Entity entsTsl[] = { };	Point3d ptsTsl[] = { _Pt0};
						int nProps[]={nNumber, nNrResult}; 
						double dProps[]={dDistanceBottom,dDistanceTop,dDistanceBetween, dDistanceBetweenResult}; 
						String sProps[]={sProject,sManufacturer, sModel, sArticle,sCDREf};
						Map mapTsl;	
						mapTsl.setInt("iMode", 2);
						mapTsl.setInt("iRing", i);
						//
						tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
						if (_Entity.find(tslNew) < 0)_Entity.append(tslNew);
					}//next i
				}
			}
			if (iMode == 2)
			{ 
				// calculation mode
				int iRing = _Map.getInt("iRing");
				if (pls.length() < iRing + 1)
				{ 
					// 
					eraseInstance();
					return;
				}
				PLine pl = pls[iRing];
				PlaneProfile ppThis = pp;
				ppThis.subtractProfile(pp);
				ppThis.joinRing(pl, _kAdd);
				ppThis.vis(2);
				dp.draw(ppThis);
				Point3d pts[] = pl.intersectPoints(Plane(seg.ptMid(), vecXpn));
				if (pts.length() != 2)
				{ 
//					reportMessage(TN("|unexpected error|"));
//					eraseInstance();
//					return;
					// sort the points
					Vector3d vecDir = pts.last() - pts.first();
					vecDir.normalize();
					// project points in line and order them
					pts = Line(pts[0],vecDir).orderPoints(Line(pts[0],vecDir).projectPoints(pts));
				}
				pts.first().vis(1);
				pts.last().vis(1);
				// distribute between 2 points
				Point3d ptStart = pts.first();
				Point3d ptEnd = pts.last();
				if(_PtG.length()==0)
				{ 
					_PtG.append(ptStart);
					_PtG.append(ptEnd);
				}
				else
				{ 
					ptStart = _PtG[0];
					ptEnd = _PtG[1];
				}
				Vector3d vecDir = ptEnd - ptStart;
				vecDir.normalize();
				vecDir.vis(ptStart);
				double dLengthTot = (ptEnd - ptStart).dotProduct(vecDir);
				// set pt0
				LineSeg seg = ppThis.extentInDir(vecDir);
				_Pt0 = seg.ptMid();
				_ThisInst.setAllowGripAtPt0(false);
				//
				if (dDistanceBottom + dDistanceTop > dLengthTot)
				{ 
					reportMessage(TN("|no distribution possible|"));
					return;
				}
				Point3d pt1 = ptStart + vecDir * dDistanceBottom;
				Point3d pt2 = ptEnd - vecDir * (dDistanceTop+ dPartLength);
				double dDistTot = (pt2 - pt1).dotProduct(vecDir);
				if (dDistTot < 0)
				{ 
					reportMessage(TN("|no distribution possible|"));
					return;
				}
				
				if (dDistanceBetween >= 0)
				{ 
					// distance in between > 0; distribute with distance
					// modular distance
					double dDistMod = dDistanceBetween + dPartLength;
					int iNrParts = dDistTot / dDistMod;
					// calculated modular distance between subsequent parts
					
					double dDistModCalc = 0;
					if (iNrParts != 0)
						dDistModCalc = dDistTot / iNrParts;
					
					// first point
					Point3d pt;
					pt = ptStart + vecDir * (dDistanceBottom + dPartLength / 2);
	//				pt.vis(1);
					ptsDis.append(pt);
					if(dDistModCalc>0)
					{ 
						for (int i = 0; i < iNrParts; i++)
						{ 
							pt += vecDir * dDistModCalc;
		//					pt.vis(1);
							ptsDis.append(pt);
						}
					}
					// set nr of parts
//					dDistanceBetweenResult.set(-(ptsDis.length()));
					dDistanceBetweenResult.set(dDistModCalc-dPartLength);
					// set nr of parts
					nNrResult.set(ptsDis.length());
				}
				else
				{ 
					double dDistModCalc;
					//
					int nNrParts = -dDistanceBetween / 1;
					if(nNrParts==1)
					{ 
						ptsDis.append(ptStart + vecDir * dDistanceBottom );
					}
					else
					{ 
						double dDistMod = dDistTot / (nNrParts - 1);
						dDistModCalc = dDistMod;
						int nNrPartsCalc = nNrParts;
						// clear distance between parts
						double dDistBet = dDistMod - dPartLength;
						if (dDistBet < 0)
						{ 
							// distance between 2 subsequent parts < 0
							
							dDistModCalc = dPartLength;
							// nr of parts in between 
							nNrPartsCalc = dDistTot / dDistModCalc;
							nNrPartsCalc += 1;
						}
						// first point
						Point3d pt;
						pt = ptStart + vecDir * (dDistanceBottom + dPartLength / 2);
						ptsDis.append(pt);
						pt.vis(1);
						for (int i = 0; i < (nNrPartsCalc - 1); i++)
						{ 
							pt += vecDir * dDistModCalc;
							pt.vis(1);
							ptsDis.append(pt);
						}//next i
					}
					// set calculated distance between parts
					dDistanceBetweenResult.set(dDistModCalc-dPartLength);
					// set nr of parts
					nNrResult.set(ptsDis.length());
				}
				// draw distribution
				for (int i=0;i<ptsDis.length();i++) 
				{ 
					Point3d pt = ptsDis[i];
					PLine pl(pnIntersect.normal());
//					pl.createCircle(pt, pnIntersect.normal(), dPartLength / 2);
					pl.createCircle(pt, pnIntersect.normal(), U(5));
					dp.draw(pl);
				}//next i
			}
		}
	}
}
else
{ 
		// no grip at pt0
		_ThisInst.setAllowGripAtPt0(false);
	// not attache to any panel, inserted with 2 points
		if(_PtG.length()!=2)
		{ 
			//
			eraseInstance();
			return;
		}
		Point3d ptStart = _PtG[0];
		Point3d ptEnd = _PtG[1];
		LineSeg lSeg(ptStart, ptEnd);
		_Pt0 = .5 * (_PtG[0] + _PtG[1]);
		// distribution
		Display dp(iColour);
		dp.draw(lSeg);
//		Point3d ptsDis[0];
		ptsDis.setLength(0);
		Vector3d vecDir = ptEnd - ptStart;
		vecDir.normalize();
//		double dPartLength = U(10);
		double dPartLength = U(0);
		
		Point3d pt1 = ptStart + vecDir * dDistanceBottom;
		Point3d pt2 = ptEnd - vecDir * (dDistanceTop+ dPartLength);
		double dDistTot = (pt2 - pt1).dotProduct(vecDir);
		if (dDistTot < 0)
		{ 
			reportMessage(TN("|no distribution possible|"));
			return;
		}
		Vector3d vecNormal;
		if (abs(vecDir.dotProduct(_XW)) > 0)
		{ 
			vecNormal = vecDir.crossProduct(_XW);
			vecNormal.normalize();
		}
		else
		{ 
			vecNormal = vecDir.crossProduct(_YW);
			vecNormal.normalize();
		}
		
		if (dDistanceBetween >= 0)
		{ 
			// distance in between > 0; distribute with distance
			// modular distance
			double dDistMod = dDistanceBetween + dPartLength;
			int iNrParts = dDistTot / dDistMod;
			// calculated modular distance between subsequent parts
			double dDistModCalc = 0;
			if (iNrParts != 0)
				dDistModCalc = dDistTot / iNrParts;
			
			// first point
			Point3d pt;
			pt = ptStart + vecDir * (dDistanceBottom + dPartLength / 2);
//				pt.vis(1);
			ptsDis.append(pt);
			if(dDistModCalc>0)
			{ 
				for (int i = 0; i < iNrParts; i++)
				{ 
					pt += vecDir * dDistModCalc;
//					pt.vis(1);
					ptsDis.append(pt);
				}
			}
			// set nr of parts
//			dDistanceBetweenResult.set(-(ptsDis.length()));
			dDistanceBetweenResult.set(dDistModCalc-dPartLength);
			// set nr of parts
			nNrResult.set(ptsDis.length());
		}
		else
		{ 
			double dDistModCalc;
			//
			int nNrParts = -dDistanceBetween / 1;
			if(nNrParts==1)
			{ 
				dDistModCalc = dDistanceBottom;
				ptsDis.append(ptStart + vecDir * dDistanceBottom );
			}
			else
			{ 
				double dDistMod = dDistTot / (nNrParts - 1);
				dDistModCalc = dDistMod;
				int nNrPartsCalc = nNrParts;
				// clear distance between parts
				double dDistBet = dDistMod - dPartLength;
				if (dDistBet < 0)
				{ 
					// distance between 2 subsequent parts < 0
					
					dDistModCalc = dPartLength;
					// nr of parts in between 
					nNrPartsCalc = dDistTot / dDistModCalc;
					nNrPartsCalc += 1;
				}
				// first point
				Point3d pt;
				pt = ptStart + vecDir * (dDistanceBottom + dPartLength / 2);
				ptsDis.append(pt);
				pt.vis(1);
				for (int i = 0; i < (nNrPartsCalc - 1); i++)
				{ 
					pt += vecDir * dDistModCalc;
					pt.vis(1);
					ptsDis.append(pt);
				}//next i
			}
			// set calculated distance between parts
//			dDistanceBetweenResult.set(dDistModCalc);
			dDistanceBetweenResult.set(dDistModCalc-dPartLength);
			// set nr of parts
			nNrResult.set(ptsDis.length());
		}
		// draw distribution
		for (int i=0;i<ptsDis.length();i++) 
		{ 
			Point3d pt = ptsDis[i];
			PLine pl(vecNormal);
//			pl.createCircle(pt, vecNormal, dPartLength / 2);
			pl.createCircle(pt, vecNormal, U(5));
			dp.draw(pl);
		}//next i
}

// hardware export
// Hardware//region
// collect existing hardware
	HardWrComp hwcs[] = _ThisInst.hardWrComps();
	
// remove any tsl repType: the assumption is that any hardware article of type _kRTTsl has been attached by this instance
	for (int i=hwcs.length()-1; i>=0 ; i--) 
		if (hwcs[i].repType() == _kRTTsl)
			hwcs.removeAt(i); 

// declare the groupname of the hardware components
	String sHWGroupName;
	// set group name
	{ 
	// element
		// try to catch the element from the parent entity
//		Element elHW =sip0.element(); 
//		// check if the parent entity is an element
//		if (!elHW.bIsValid())
//			elHW = (Element)sip0;
//		if (elHW.bIsValid()) 
//			sHWGroupName=elHW.elementGroup().name();
//	// loose
//		else
		{
			Group groups[] = _ThisInst.groups();
			if (groups.length()>0)
				sHWGroupName=groups[0].name();
		}		
	}
	
// add main componnent
	{ 
		HardWrComp hwc(sArticle, ptsDis.length()); // the articleNumber and the quantity is mandatory
		
		hwc.setManufacturer(sManufacturer);
		
		hwc.setModel(sModel);
//				hwc.setName(sHWName);
		hwc.setDescription(mapArticle.getString("Description"));
		hwc.setMaterial(mapArticle.getString("Material"));
//		hwc.setNotes(mapArticle.getString("Notes"));
		hwc.setNotes(sCDREf+"-"+nNumber);
		
		hwc.setGroup(sHWGroupName);
//		hwc.setLinkedEntity(sip0);	
		hwc.setCategory(T("|Connector|"));
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		
		if(mapArticle.hasDouble("ScaleX/Length"))
		{ 
			hwc.setDScaleX(mapArticle.getDouble("ScaleX/Length"));
		}
		else if(mapArticle.hasInt("ScaleX/Length"))
		{ 
			int iVar = mapArticle.getInt("ScaleX/Length");
			hwc.setDScaleX(iVar);
		}
		else if(mapArticle.hasString("ScaleX/Length"))
		{ 
			String sVar = mapArticle.getString("ScaleX/Length");
			double dX = sVar.atof();
			hwc.setDScaleX(dX);
		}
		// width
		if(mapArticle.hasDouble("ScaleY/Width/Diameter"))
		{ 
			hwc.setDScaleY(mapArticle.getDouble("ScaleY/Width/Diameter"));
		}
		else if(mapArticle.hasInt("ScaleY/Width/Diameter"))
		{ 
			int iVar = mapArticle.getInt("ScaleY/Width/Diameter");
			hwc.setDScaleY(iVar);
		}
		else if(mapArticle.hasString("ScaleY/Width/Diameter"))
		{ 
			String sVar = mapArticle.getString("ScaleY/Width/Diameter");
			double dY = sVar.atof();
			hwc.setDScaleY(dY);
		}
		// height
		if(mapArticle.hasDouble("ScaleZ/Height/Thickness"))
		{ 
			hwc.setDScaleZ(mapArticle.getDouble("ScaleZ/Height/Thickness"));
		}
		else if(mapArticle.hasInt("ScaleZ/Height/Thickness"))
		{ 
			int iVar = mapArticle.getInt("ScaleZ/Height/Thickness");
			hwc.setDScaleZ(iVar);
		}
		else if(mapArticle.hasString("ScaleZ/Height/Thickness"))
		{ 
			String sVar = mapArticle.getString("ScaleZ/Height/Thickness");
			double dZ = sVar.atof();
			hwc.setDScaleZ(dZ);
		}
	// uncomment to specify area, volume or weight
	//	hwc.setDAngleA(dHWArea);
	//	hwc.setDAngleB(dHWVolume);
	//	hwc.setDAngleG(dHWWeight);
		
	// apppend component to the list of components
		hwcs.append(hwc);
	}
// subcomponents A,B,C,D
	// mapX for the sub components
	Map mapX;
	{ 
		String sSubs[] ={ "SubA", "SubB", "SubC", "SubD"};
		String sSubQtys[] ={ "SubA Qty", "SubB Qty", "SubC Qty", "SubD Qty"};
		
		for (int iSub=0;iSub<sSubs.length();iSub++) 
		{ 
			String sSubI = mapArticle.getString(sSubs[iSub]);
			int iSubQtyI = mapArticle.getInt(sSubQtys[iSub]);
			mapX.setString(sSubs[iSub], sSubI);
			mapX.setInt(sSubQtys[iSub], iSubQtyI);
			if(sSubI!="" && iSubQtyI>0)
			{ 
				// reference of article
				String sTokens[] = sSubI.tokenize("_");
				if(sTokens.length()!=3)
					continue;
				
				String sManufacturer = sTokens[0];
				String sModel = sTokens[1];
				String sArticle = sTokens[2];
				
				Map mapArticle;
				int iArticleFound = false;
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
									Map mapModels = mapManufacturer.getMap("Model[]");
									for (int ii = 0; ii < mapModels.length(); ii++)
									{
										Map mapModelI = mapModels.getMap(ii);
										if (mapModelI.hasString("Name") && mapModels.keyAt(ii).makeLower() == "model")
										{
											String sName = mapModelI.getString("Name");
											String _sModelName = mapModelI.getString("Name");
											String _sModel = sModel;_sModel.makeUpper();
											if (_sModelName.makeUpper() == _sModel)
											{ 
												// this model
												Map mapModel = mapModelI;
												Map mapArticles = mapModel.getMap("Article[]");
												for (int iii = 0; iii < mapArticles.length(); iii++)
												{ 
													Map mapArticleI = mapArticles.getMap(iii);
													if (mapArticleI.hasString("Name") && mapArticles.keyAt(iii).makeLower() == "article")
													{ 
														String sName = mapArticleI.getString("Name");
														String _sArticleName = mapArticleI.getString("Name");
														String _sArticle = sArticle;_sArticle.makeUpper();
														if (_sArticleName.makeUpper() == _sArticle)
														{ 
															mapArticle = mapArticleI;
															iArticleFound = true;
															break;
														}
													}
												}
												if (iArticleFound)break;
											}
										}
									}
									if (iArticleFound)break;
								}
							}
						}
					}
				}
				if(iArticleFound)
				{ 
					// create hardware for subcomponent
					HardWrComp hwc(sArticle, ptsDis.length()*iSubQtyI); // the articleNumber and the quantity is mandatory
		
					hwc.setManufacturer(sManufacturer);
					
					hwc.setModel(sModel);
	//				hwc.setName(sHWName);
					hwc.setDescription(mapArticle.getString("Description"));
					hwc.setMaterial(mapArticle.getString("Material"));
//					hwc.setNotes(mapArticle.getString("Notes"));
					hwc.setNotes(sCDREf+"-"+nNumber);
					
					hwc.setGroup(sHWGroupName);
//					hwc.setLinkedEntity(sip0);	
					hwc.setCategory(T("|Connector|"));
					hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
					
					if(mapArticle.hasDouble("ScaleX/Length"))
					{ 
						hwc.setDScaleX(mapArticle.getDouble("ScaleX/Length"));
					}
					else if(mapArticle.hasInt("ScaleX/Length"))
					{ 
						int iVar = mapArticle.getInt("ScaleX/Length");
						hwc.setDScaleX(iVar);
					}
					else if(mapArticle.hasString("ScaleX/Length"))
					{ 
						String sVar = mapArticle.getString("ScaleX/Length");
						double dX = sVar.atof();
						hwc.setDScaleX(dX);
					}
					// width
					if(mapArticle.hasDouble("ScaleY/Width/Diameter"))
					{ 
						hwc.setDScaleY(mapArticle.getDouble("ScaleY/Width/Diameter"));
					}
					else if(mapArticle.hasInt("ScaleY/Width/Diameter"))
					{ 
						int iVar = mapArticle.getInt("ScaleY/Width/Diameter");
						hwc.setDScaleY(iVar);
					}
					else if(mapArticle.hasString("ScaleY/Width/Diameter"))
					{ 
						String sVar = mapArticle.getString("ScaleY/Width/Diameter");
						double dY = sVar.atof();
						hwc.setDScaleY(dY);
					}
					// height
					if(mapArticle.hasDouble("ScaleZ/Height/Thickness"))
					{ 
						hwc.setDScaleZ(mapArticle.getDouble("ScaleZ/Height/Thickness"));
					}
					else if(mapArticle.hasInt("ScaleZ/Height/Thickness"))
					{ 
						int iVar = mapArticle.getInt("ScaleZ/Height/Thickness");
						hwc.setDScaleZ(iVar);
					}
					else if(mapArticle.hasString("ScaleZ/Height/Thickness"))
					{ 
						String sVar = mapArticle.getString("ScaleZ/Height/Thickness");
						double dZ = sVar.atof();
						hwc.setDScaleZ(dZ);
					}
				// uncomment to specify area, volume or weight
				//	hwc.setDAngleA(dHWArea);
				//	hwc.setDAngleB(dHWVolume);
				//	hwc.setDAngleG(dHWWeight);
					
				// apppend component to the list of components
					hwcs.append(hwc);
				}
			}
//					type variable = sSubs[i]; 
		}//next i
	}
// save mapX
_ThisInst.setSubMapX("mapXSubComponents", mapX);

// make sure the hardware is updated
	if (_bOnDbCreated)
		setExecutionLoops(2);
	
	_ThisInst.setHardWrComps(hwcs);	
	//endregion
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
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="TslInfo">
    <lst nm="TSLINFO">
      <lst nm="TSLINFO">
        <lst nm="TSLINFO">
          <lst nm="TSLINFO">
            <lst nm="TSLINFO">
              <lst nm="TSLINFO" />
            </lst>
          </lst>
        </lst>
      </lst>
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End