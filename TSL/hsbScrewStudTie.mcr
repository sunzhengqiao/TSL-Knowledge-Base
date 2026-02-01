#Version 8
#BeginDescription
#Versions:
Version 1.7 10.05.2023 HSB-18650 standard display published for share and make , Author Thorsten Huck
1.6 14.09.2021 HSB-13069: Add drill properties Author: Marsel Nakuci
version value="1.5" date="02feb2020" author="nils.gregor@hsbcad.com"> 
HSB-10161 Adjusted single mode and edit  element and wrong property set of products

This tsl creates a center stud lock between a stud and a t-connecting framing beam. 
If the T-connection consists of a double plate the outer beam will be taken as reference
The selectable manufacturers and products are defined in \tsl\settings\ScrewCatalog.xml 
of <\content general> or as customization in <company\>


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 7
#KeyWords screw catalog;Mitek;studlock;
#BeginContents
/// <History>//region
/// #Versions:
// 1.7 10.05.2023 HSB-18650 standard display published for share and make , Author Thorsten Huck
// Version 1.6 14.09.2021 HSB-13069: Add drill properties Author: Marsel Nakuci
/// <version value="1.5" date="02feb2020" author="nils.gregor@hsbcad.com"> HSB-10161 Adjusted single mode and edit  element and wrong property set of products</version>
/// <version value="1.4" date="28jan2020" author="nils.gregor@hsbcad.com"> HSB-10161 Adjusted behavior of single selection and editing element instances </version>
/// <version value="1.3" date="25jan2021" author="nils.gregor@hsbcad.com"> HSB-10161 Renamed Instance (former StudLock). Add ruleset, autoinsert, edit of element instances </version>
/// <version value="1.2" date="18aug2020" author="geoffroy.cenni@hsbcad.com"> replaced material, check for family geometry, dialog optimisation, check thread distance to post, check for duplicate positioning </version>
/// <version value="1.1" date="18aug2020" author="thorsten.huck@hsbcad.com"> bugfix detecting t-connection </version>
/// <version value="1.0" date="14aug2020" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select entity, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates a center stud lock between a stud and a t-connecting framing beam. 
/// If the T-connection consists of a double plate the outer beam will be taken as reference
/// The selectable manufacturers and products are defined in \tsl\settings\ScrewCatalog.xml 
/// of <\content general> or as customization in <company\>
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbScrewStudTie" "Mitek?StudLok")) TSLCONTENT

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
	String sDisabled = T("<|Disabled|>");
	String k;
//end Constants//endregion

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sFileName ="ScrewCatalog";
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
		if (sFile.length()<1)sFile=findFile(_kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\"+sFileName+".xml");		
		if (sFile.length()>0)
		{ 
			mapSetting.readFromXmlFile(sFile);
			mo.dbCreate(mapSetting);			
		}
	}		
//End Settings//endregion

//region Read Settings
	String sManufacturers[0];
	{
		Map m,mapManufacturers= mapSetting.getMap("Manufacturer[]");
		for (int i=0;i<mapManufacturers.length();i++) 
		{ 
			m = mapManufacturers.getMap(i); 
			String manufacturer;
			k="Name";		if (m.hasString(k))	manufacturer = m.getString(k);
			if (manufacturer.length()>0 && sManufacturers.findNoCase(manufacturer,-1)<0)
				sManufacturers.append(manufacturer);
		}//next i
	}
	if (sManufacturers.length()<1)
	{ 
		reportMessage("\n"+ scriptName() + ": "+ T("|Could not find manufacturer data.| ")+ T("|Tool will be deleted.|"));
		eraseInstance();
		return;	
	}
//End Read Settings//endregion 

// get mode
	int nMode = _Map.getInt("mode"); // 0 = insert, 1 = element, 2 = beam/beam	
	
// Autoinsert on element: Set instance to element calculation mode
	if(_Element.length() == 1 && nMode == 0)
	{
		nMode == 1;
		_Map.setInt("mode", 1);
	}
		

//region Properties
	category = T("|Filter|");
	String sPainters[] = PainterDefinition().getAllEntryNames().sorted();
	sPainters.insertAt(0, sDisabled);
	String sPainterName=T("|Painter|");	
	PropString sPainter(nStringIndex++, sPainters, sPainterName);	
	sPainter.setDescription(T("|A filter which will use painter definitions|"));
	sPainter.setCategory(category);		
	
	String categoryRules = T("|Ruleset|");
	String sPositionNames [] = { T("|Top plate|"), T("|Bottom plate|"), T("|Both plates|")};
	String sPositionName=T("|Position|");	
	PropString sPosition(nStringIndex++, sPositionNames, sPositionName);	
	sPosition.setDescription(T("|Defines the position of the screws|"));
	sPosition.setCategory(categoryRules); 
	int nPosition = sPositionNames.find(sPosition);
	
	String sDistributionNames[] ={ T("|Every Stud|"), T("|Every odd Stud|"), T("|Every even Stud|")};
	String sDistributionName=T("|Distribution|");	
			
	String sOpeningPosNames [] = {T("|Screws in King studs, none in cripples|"), T("|Screws in King stud and cripples|"), T("|No rule for openings|")};
	String sOpeningPosName=T("|Opening rule|");	
	
	if(nMode == 1)
	{
		PropString sDistribution(2, sDistributionNames, sDistributionName);	
		sDistribution.setDescription(T("|Defines the distribution of the screws|"));
		sDistribution.setCategory(categoryRules);
						
		PropString sOpeningPos(3, sOpeningPosNames, sOpeningPosName);	
		sOpeningPos.setDescription(T("|Defines the positioning at openings. The first two rules will always at screws at openings|"));
		sOpeningPos.setCategory(categoryRules);	
	}
	if(nMode < 2)
		nStringIndex += 2;
	
	// HSB-13069 tooling
	category = T("|Drill|");
	String sDrillName=T("|Drill|");	
	int iIndexDrillProp = 4;
	if (nMode <2)iIndexDrillProp = 6;
	PropString sDrill(iIndexDrillProp, sNoYes, sDrillName);	
	sDrill.setDescription(T("|Defines if Drill should be applied|"));
	sDrill.setCategory(category);
	// diameter
	String sDiameterDrillName=T("|Diameter|");	
	PropDouble dDiameterDrill(1, U(0), sDiameterDrillName);	
	dDiameterDrill.setDescription(T("|Defines the Diameter of Drill|"));
	dDiameterDrill.setCategory(category);
	
	// extra Length
	String sLengthDrillName=T("|Depth|");
	PropDouble dLengthDrill(2, U(0), sLengthDrillName);	
	dLengthDrill.setDescription(T("|Defines the Length of the Drill|"));
	dLengthDrill.setCategory(category);

	category = T("|General|");
	String sManufacturerName=T("|Manufacturer|");	
	PropString sManufacturer(nStringIndex++, sManufacturers, sManufacturerName);	
	sManufacturer.setDescription(T("|Defines the Manufacturer|"));
	sManufacturer.setCategory(category);	

	String sFamilies[0];
	String sFamilyName=T("|Family|");	
	int nIndexFamily = nStringIndex++;

	String sLengthName=T("|Length|");	
	int nIndexLength = nDoubleIndex++;
	double dLengths[0];
	
	String sMaterials[0];
	String sMaterial;
	
	String sURLs[0];
	String sURL;
	
	String sArticleNumbers[0];
	String sArticleNumber;
	
	String sDescriptions[0];
	String sDescription;
	
	int iColors[0];
	int iColor;
	
	double dThreadDiameters[0];
	double dThreadDiameter;
	
	double dHeadDiameters[0];
	double dHeadDiameter;
	
	double dHeadLengths[0];
	double dHeadLength;
	
	int bElementSelected;
//End Properties//endregion 

//region bOnInsert
	if (_bOnInsert)
	{
		if (insertCycleCount() > 1) { eraseInstance(); return; }
		
		String sOptions[] ={ T("|Element|"), T("|Beams|")};
		// prompt mode element or beams
		String sInsertChoice = getString(T("|Select insertion mode| => " + " [" + T("|Element|") + "/" + T("|Beams|") + "] ")).makeUpper();
		if (sInsertChoice == "" || sInsertChoice == "E")
			bElementSelected = true;
	
		if(bElementSelected)
		{			
			PropString sDistribution(2, sDistributionNames, sDistributionName);	
			sDistribution.setDescription(T("|Defines the distribution of the screws|"));
			sDistribution.setCategory(categoryRules);
						
			PropString sOpeningPos(3, sOpeningPosNames, sOpeningPosName);	
			sOpeningPos.setDescription(T("|Defines the positioning at openings. The first two rules will always at screws at openings|"));
			sOpeningPos.setCategory(categoryRules);					
		}
		else
			sPosition.setReadOnly(true);
		
	// tokens given by the executeKey to preselect manufacturer and family	
		String sTokens[] = _kExecuteKey.tokenize("?");
		int bHasToken = sTokens.length() > 0;

		Map m,mapManufacturer,mapFamilies, mapFamily;
		int n = -1;
		if (bHasToken)n=sManufacturers.findNoCase(sTokens.first() ,- 1);
		int bManufacturerIsValid = bHasToken && sTokens.length()>0 && n>-1 && sManufacturers[n].length()==sTokens.first().length();

	// manufacturer given by token entry
		if (bManufacturerIsValid)
		{		
			sManufacturer.set(sManufacturers[n]);
			reportNotice("\nManufacturer set to " + sManufacturer);
		}
	// prompt user to select the manufacturer	
		else
		{ 
			if(sManufacturers.length() > 1) showDialog();				
			if(sManufacturers.length() == 1) sManufacturer.set(sManufacturers[0]);
		}

	//region collect families of this manufacturer
		Map mapManufacturers;
		mapManufacturers= mapSetting.getMap("Manufacturer[]");
		for (int i=0;i<mapManufacturers.length();i++) 
		{ 
			m = mapManufacturers.getMap(i); 
			String manufacturer;
			k="Name";		if (m.hasString(k))	manufacturer = m.getString(k);
			
			if (sManufacturer==manufacturer)
			{ 
				mapManufacturer = m;
				k="Family[]";		if (m.hasMap(k))	mapFamilies = m.getMap(k);
				for (int j=0;j<mapFamilies.length();j++) 
				{ 
					m = mapFamilies.getMap(j); 
					String name;
					k="Name";		if (m.hasString(k))	name = m.getString(k);
					
					if (name.length()>0 && sFamilies.findNoCase(name,-1)<0)
					{
						sFamilies.append(name);
					}
					
				}//next j
				break;
			}	
		}//next i				
	//End collect families of this manufacturer//endregion 

		category = T("|Product|");
		if(sManufacturers.length() > 1) sManufacturer.setReadOnly(true);
		PropString sFamily(nIndexFamily, sFamilies, sFamilyName);

	// family given by token entry
		int bFamilyIsValid = sTokens.length()>1 && sFamilies.findNoCase(sTokens[1],-1)>-1;
		if (bFamilyIsValid)
		{
			int n = sFamilies.findNoCase(sTokens[1] ,- 1);
			sFamily.set(sFamilies[n]);
		}
		else
		{ 
			if(sFamilies.length() > 1) showDialog();				
			if(sFamilies.length() == 1) sFamily.set(sFamilies[0]);
		}

	//region collect products of this family
		for (int i = 0; i < mapFamilies.length(); i++)
		{
			m = mapFamilies.getMap(i);
			String family;
			k = "Name";		if (m.hasString(k))	family = m.getString(k);

			if (sFamily == family)
			{
				mapFamily = m;
				Map mapProducts;
				k="Product[]";		if (m.hasMap(k))	mapProducts = m.getMap(k);
				
				for (int j=0;j<mapProducts.length();j++) 
				{ 
					double length;
					m = mapProducts.getMap(j); // getting the product by index
					k="Length";		if (m.hasDouble(k))	length = m.getDouble(k);
					if (length>0 && dLengths.find(length)<0)
						dLengths.append(length);
				}//next j
				
				
				break;
			}
		}
	//endregion 
	
		if(sFamilies.length() > 1) sFamily.setReadOnly(true);

		PropDouble dLength(nIndexLength, dLengths, sLengthName);
		showDialog("---");
		
		if(bElementSelected)
		{
		// Redeclare props
			PropString sDistribution(2, sDistributionNames, sDistributionName);							
			PropString sOpeningPos(3, sOpeningPosNames, sOpeningPosName);	
			
			Map mapAllProps = _ThisInst.mapWithPropValuesFromCatalog(scriptName(), sLastInserted);
			mapAllProps = mapAllProps.getMap("PropString[]");
					
			for(int i=0; i < mapAllProps.length(); i++)
			{
				Map m = mapAllProps.getMap(i);
						
				if(sDistributionName == m.getString("strName"))
					sDistribution.set(m.getString("strValue"));
				else if(sOpeningPosName == m.getString("strName"))
					sOpeningPos.set(m.getString("strValue"));
			}							
			
		//region Selection
		// default prompt for walls
			Entity ents[0];
			PrEntity ssE(T("|Select wall elements|"), ElementWallSF());
			ssE.addAllowedClass(ElementMulti());
			if (ssE.go())
				ents.append(ssE.set());
				
			if (ents.length() > 0)
			{ 				
				// create TSL
					TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
					GenBeam gbsTsl[] = {};		Entity entsTsl[1];				Point3d ptsTsl[] = {_Pt0};
					int nProps[]={};			
					double dProps[]={dLength,dDiameterDrill,dLengthDrill};		
					String sProps[]={sPainter, sPosition, sDistribution, sOpeningPos, sManufacturer, sFamily,sDrill};
					Map mapTsl;												
					mapTsl.setInt("mode", 1); // 0 = insert, 1 = element, 2 = beam/beam						
				
				for (int i=0;i<ents.length();i++) 
				{ 
					entsTsl[0] = ents[i];
					tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
					 
				}//next i
				eraseInstance();
			}	
		//End Selection//endregion 			
		}
		else
		{
			_Beam.append(getBeam(T("|Select male beam|")));
			_Beam.append(getBeam(T("|Select female beam|")));
			
			// create TSL
			TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
			GenBeam gbsTsl[] = { _Beam[0], _Beam[1]};		Entity entsTsl[] = { };				Point3d ptsTsl[] = { _Pt0};
			int nProps[]={};			
			double dProps[]={dLength,dDiameterDrill,dLengthDrill};		
			String sProps[]={sPainter, sPosition, sManufacturer, sFamily,sDrill};
			Map mapTsl;												
			mapTsl.setInt("mode", 2); // 0 = insert, 1 = element, 2 = beam/beam		
			mapTsl.setInt("SetPosition", true);

			tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);

			eraseInstance();
		}
		if (bDebug)_Pt0 = getPoint();
		
		return;
	}	
// end on insert	__________________//endregion

	if(_ThisInst.hasPropString(4))
	{ 
		
	}


//region adding Properties
	Map m,mapManufacturer,mapFamilies, mapFamily;
	Map mapManufacturers;
	mapManufacturers= mapSetting.getMap("Manufacturer[]");
	for (int i=0;i<mapManufacturers.length();i++) 
	{ 
		m = mapManufacturers.getMap(i); 
		String manufacturer;
		k="Name";		if (m.hasString(k))	manufacturer = m.getString(k);
		
		if (sManufacturer==manufacturer)
		{ 
			mapManufacturer = m;
			k="Family[]";		if (m.hasMap(k))	mapFamilies = m.getMap(k);		
			
			for (int j=0;j<mapFamilies.length();j++) 
			{ 
				m = mapFamilies.getMap(j); 
				String name;
				k="Name";		if (m.hasString(k))	name = m.getString(k);
				
				if (name.length()>0 && sFamilies.findNoCase(name,-1)<0)
					sFamilies.append(name);
			}//next j
			break;
		}	
	}//next i		
	sManufacturer.setReadOnly(true);
	
	PropString sFamily(nIndexFamily, sFamilies, sFamilyName);	
	sFamily.setDescription(T("|Defines the Family|"));
	sFamily.setCategory(category);
	sFamily.setReadOnly(true);
	setOPMKey(sFamily);
	
	for (int i = 0; i < mapFamilies.length(); i++)
	{
		m = mapFamilies.getMap(i);
		String family;
		k = "Name";		if (m.hasString(k))	family = m.getString(k);

		if (sFamily == family)
		{
			Map mapProducts;
			k="Product[]";		if (m.hasMap(k))	mapProducts = m.getMap(k);
			
			for (int j=0;j<mapProducts.length();j++) 
			{ 
				double length;
				Map m2 = mapProducts.getMap(j); // getting the product by index
				k="Length";				if (m2.hasDouble(k))	length = m2.getDouble(k);
				
				if (length>0 && dLengths.find(length)<0)
				{
					double dTempHeadDia, dTempThreadDia, dTempHeadLength;
					k = "Diameter Thread";	if(m.hasDouble(k)) dTempThreadDia = m.getDouble(k);
					k = "Diameter Head";	if(m.hasDouble(k)) dTempHeadDia = m.getDouble(k);
					k = "Length Head";		if(m.hasDouble(k)) dTempHeadLength = m.getDouble(k);
					if (dTempHeadDia == 0 || dTempThreadDia == 0 || dTempHeadLength == 0) continue;
					dThreadDiameters.append(dTempThreadDia);
					dHeadDiameters.append(dTempHeadDia);
					dHeadLengths.append(dTempHeadLength);
					
					dLengths.append(length);
					k = "Material";			sMaterials.append(m.hasString(k) ? m.getString(k) : "");
					k = "url";				sURLs.append(m.hasString(k) ? m.getString(k) : "");
					k = "ArticleNumber";	sArticleNumbers.append(m2.hasString(k) ? m2.getString(k) : "");
					k = "Description";		sDescriptions.append(m2.hasString(k) ? m2.getString(k) : "");
					k = "Color";			iColors.append(m2.hasInt(k) ? m2.getInt(k) : 252);
				}
			}//next j
			
			break;
		}
	}	
	
	PropDouble dLength(nIndexLength, dLengths, sLengthName);	
	dLength.setDescription(T("|Defines the Length|"));
	dLength.setCategory(category);
//endregion	

	int nProductIndex = dLengths.find(dLength);
	sMaterial = sMaterials[nProductIndex];
	sURL = sURLs[nProductIndex];
	_ThisInst.setHyperlink(sURL);
	sArticleNumber = sArticleNumbers[nProductIndex];
	sDescription = sDescriptions[nProductIndex];
	iColor = iColors[nProductIndex];
	dThreadDiameter = dThreadDiameters[nProductIndex];
	dHeadDiameter = dHeadDiameters[nProductIndex];
	dHeadLength = dHeadLengths[nProductIndex];

	int iDrill = sNoYes.find(sDrill);
	double dLengthDrillReal=dLengthDrill,dDiameterDrillReal = dDiameterDrill;
	if (dLengthDrill == 0)
	{
		dLengthDrillReal = dLength;
	}
	if (dDiameterDrill <= 0)
	{
		dDiameterDrill.set(0);
		dDiameterDrillReal = dThreadDiameter;
	}
	
	PainterDefinition painter;
	int nPainter = sPainters.find(sPainter);
	if (nPainter>0)
		painter = PainterDefinition(sPainter);
	
// beam/beam single connection
	if (nMode==2)
	{ 
		//Has T connection?
		if(_Beam.length() < 2 || _Beam0.vecX().isParallelTo(_Beam1.vecX()))
		{
			reportMessage("\n"+ scriptName() + ": "+T("|Tool will be deleted.|"));
			eraseInstance();
			return;	
		}
		
		Beam bmMale = _Beam0;
		Beam bmFemale = _Beam1;
		
	// If beam is in element, provide edit/ delete functionality for all element instances
		Element el = bmMale.element();		
		if(el.bIsValid())
		{
			Vector3d vecYE = el.vecY();
			
			if(_Map.getInt("SetPosition") == true)
			{	
				(vecYE.dotProduct(bmMale.ptCen() - bmFemale.ptCen()) > 0) ? sPosition.set(sPositionNames[1]) : sPosition.set(sPositionNames[0]);	
				_Map.setInt("SetPosition", false);
			}		
		
		// Reset position if property changes. An eventual secound instance at the oposite side is controlled too
			if(_bOnDbCreated)
				_Map.setInt("Position", nPosition);

			if(_Map.getInt("Position") != nPosition )
			{
				_Map.setInt("Position", nPosition);
				Vector3d vecYE = el.vecY();
				int bRestPosition;
				if((nPosition == 0 && vecYE.dotProduct(_Pt0 - bmMale.ptCen()) < 0) || (nPosition == 1 && vecYE.dotProduct(_Pt0 - bmMale.ptCen()) > 0))
					bRestPosition = true;
	
				if(nPosition == 2 || bRestPosition)
				{
					Beam bmFems[] = bmMale.vecX().filterBeamsPerpendicular(bmMale.element().beam());
					Body bdMale(bmMale.ptCen(), bmMale.vecX(), bmMale.vecY(), bmMale.vecZ(), bmMale.dL() + U(40), bmMale.dW(), bmMale.dH());
					bmFems = bdMale.filterGenBeamsIntersect(bmFems);
					
					int nBm = bmFems.find(bmFemale);
					if( nBm > -1)
						bmFems.removeAt(nBm);	
		
					if(bmFems.length() > 0)
					{
						if(painter.bIsValid())
						{ 
							for (int b=bmFems.length()-1; b>=0 ; b--) 
							{ 
								Beam bm=bmFems[b]; 
								if (!bm.acceptObject(painter.filter()))
								{
									bmFems.removeAt(b);
								}
							}//next j
						}
						
						if(bmFems.length() > 0)
						{
							Entity ents[] = bmMale.eToolsConnected();			
							for(int i=ents.length()-1; i > -1; i--)
							{
								TslInst tsl = (TslInst)ents[i];
								if(!tsl.bIsValid() || tsl == _ThisInst)
									continue;
								if(tsl.scriptName() == _ThisInst.scriptName())
								{
									ents[i].dbErase();					
								}
							}		
							
							// create TSL
							TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
							GenBeam gbsTsl[] = {bmMale, bmFems.last() };			Entity entsTsl[] = { };			Point3d ptsTsl[] = { };
							int nProps[]={};			
							double dProps[]={dLength,dDiameterDrill,dLengthDrill};		
							String sProps[]={sPainter,sPosition,  sManufacturer,  sFamily,sDrill};
							Map mapTsl;												
							mapTsl.setInt("mode", 2); // 0 = insert, 1 = element, 2 = beam/beam	
							
								tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	
							
							if(bRestPosition)
							{
								eraseInstance();
								return;
							}							
						}
					}	
					if(bmFems.length() < 1)
					{
						reportMessage("|Resetting position was not successful. Instance will be deleted|");
						eraseInstance();
						return;
					}
				}
			}
		
		// Trigger control all element instances of this//region			
			String sTriggerDeleteAllFromElement = T("|Delete all from element|");
			addRecalcTrigger(_kContext, sTriggerDeleteAllFromElement );
			String sTriggerEditAllFromElement = T("|Edit all from element|");
			addRecalcTrigger(_kContext, sTriggerEditAllFromElement );
			
			if (_bOnRecalc && (_kExecuteKey==sTriggerDeleteAllFromElement || _kExecuteKey == sTriggerEditAllFromElement))
			{
				TslInst tsls[] = el.tslInst();
				
			// Restart instance for this element
				if (_kExecuteKey == sTriggerEditAllFromElement)
				{			
					PropString sDistribution(nStringIndex++, sDistributionNames, sDistributionName);	
					sDistribution.setDescription(T("|Defines the distribution of the screws|"));
					sDistribution.setCategory(categoryRules);
									
					PropString sOpeningPos(nStringIndex++, sOpeningPosNames, sOpeningPosName);	
					sOpeningPos.setDescription(T("|Defines the positioning at openings. The first two rules will always at screws at openings|"));
					sOpeningPos.setCategory(categoryRules);					
			
					Map m,mapManufacturer,mapFamilies, mapFamily;
					
					sManufacturer.setReadOnly(false);
					dLength.setReadOnly(true);
					
					showDialog();							
			
				//region collect families of this manufacturer
					sFamilies.setLength(0);
					Map mapManufacturers;
					mapManufacturers= mapSetting.getMap("Manufacturer[]");
					for (int i=0;i<mapManufacturers.length();i++) 
					{ 
						m = mapManufacturers.getMap(i); 
						String manufacturer;
						k="Name";		if (m.hasString(k))	manufacturer = m.getString(k);
						
						if (sManufacturer==manufacturer)
						{ 
							mapManufacturer = m;
							k="Family[]";		if (m.hasMap(k))	mapFamilies = m.getMap(k);
							for (int j=0;j<mapFamilies.length();j++) 
							{ 
								m = mapFamilies.getMap(j); 
								String name;
								k="Name";		if (m.hasString(k))	name = m.getString(k);
								
								if (name.length()>0 && sFamilies.findNoCase(name,-1)<0)
									sFamilies.append(name);
							}//next j
							break;
						}	
					}//next i				
				//End collect families of this manufacturer//endregion 
			
					category = T("|Product|");
					sManufacturer.setReadOnly(true);
					
					PropString sFamily(nIndexFamily, sFamilies, sFamilyName);
					sFamily.setReadOnly(false);
					
					dLengths.setLength(0);
					PropDouble dLength(nIndexLength, dLengths, sLengthName);
			
					showDialog();	
					
					sFamily.setReadOnly(true);
			
				//region collect products of this family
					for (int i = 0; i < mapFamilies.length(); i++)
					{
						m = mapFamilies.getMap(i);
						String family;
						k = "Name";		if (m.hasString(k))	family = m.getString(k);
			
						if (sFamily == family)
						{
							mapFamily = m;
							Map mapProducts;
							k="Product[]";		if (m.hasMap(k))	mapProducts = m.getMap(k);
							
							for (int j=0;j<mapProducts.length();j++) 
							{ 
								double length;
								m = mapProducts.getMap(j); // getting the product by index
								k="Length";		if (m.hasDouble(k))	length = m.getDouble(k);
								if (length>0 && dLengths.find(length)<0)
									dLengths.append(length);
							}//next j
							break;
						}
					}
				//endregion 
				
				//Redeclare dLengths
					if(true)
					{
						dLength.setReadOnly(false);
						PropDouble dLength(nIndexLength, dLengths, sLengthName);				
						if(sFamilies.length() > 1) sFamily.setReadOnly(true);
						showDialog();					
					}
					
					for(int i = tsls.length()-1; i > -1; i--)
					{
						if(tsls[i].bIsValid() && tsls[i].scriptName() == _ThisInst.scriptName())
						{
							tsls[i].dbErase();
						}
					}
										
				// create TSL
					TslInst tslNew;				Vector3d vecXTsl = _XW;			Vector3d vecYTsl = _YW;
					GenBeam gbsTsl[] = { };		Entity entsTsl[] = { el };				Point3d ptsTsl[] = { _Pt0};
					int nProps[] ={ };			
					double dProps[] ={ dLength,dDiameterDrill,dLengthDrill};		
					String sProps[] ={ sPainter, sPosition, sDistribution, sOpeningPos, sManufacturer, sFamily,sDrill};
					Map mapTsl;												
					mapTsl.setInt("mode", 1); //0 = insert, 1 = element, 2 = beam / beam
					
					tslNew.dbCreate(scriptName() , vecXTsl , vecYTsl, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
				}
				
				if(_kExecuteKey==sTriggerDeleteAllFromElement)
				for(int i = tsls.length()-1; i > -1; i--)
				{
					if(tsls[i].bIsValid() && tsls[i].scriptName() == _ThisInst.scriptName())
					{
						tsls[i].dbErase();
					}
				}
				eraseInstance();
				return;			
			}//endregion				
			assignToElementGroup(el, true, 0, 'T');
		}
		else
			assignToGroups(bmMale,'I');		


	// Standard behavior of single connection
		setDependencyOnEntity(bmMale);
		
		Vector3d vecXT = bmMale.vecX();
		Point3d pt;
		int bOK = Line(bmMale.ptCen(), vecXT).hasIntersection(Plane(bmFemale.ptCen(),bmFemale.vecD(vecXT)),pt);
		if(!bOK)
		{ 
			reportMessage("\n"+ scriptName() + ": "+T("|Tool will be deleted.|"));
			eraseInstance();
			return;	
		}
		
		if(vecXT.dotProduct(pt-bmMale.ptCen()) < 0)
		{ 
			vecXT = -vecXT;
		}
		double dDiameter = U(8);
		bOK = Line(bmMale.ptCen(), vecXT).hasIntersection(Plane(bmFemale.ptCen() +bmFemale.vecD(vecXT)*.5*bmFemale.dD(vecXT),bmFemale.vecD(vecXT)),pt);
		_Pt0 = pt;
		int bIsScrewSunk = 1;
		int bIsHeadIncludedInThreadLength = 1;
		
		Point3d ptHeadBottom = bIsScrewSunk ? pt : pt + vecXT * dHeadLength ;
		Point3d ptThreadTop = bIsScrewSunk ? pt - vecXT * dHeadLength : pt ;
		Point3d ptThreadBottom = bIsHeadIncludedInThreadLength ? ptThreadTop - vecXT * (dLength - dHeadLength) : ptThreadTop - vecXT * dLength ;		
						
		//Check if thread length can reach the post
		double dMaleHeight = bmMale.dL();
		double dDistanceToPost = vecXT.dotProduct(ptThreadTop - bmMale.ptCen()) - bmMale.dL() * .5;
		if (dDistanceToPost > dLength)
		{
			eraseInstance();
			return;
		}
		
		//Check if tool has already been implemented on same location
		Entity etools[] = bmMale.eToolsConnected();
		for (int i=0;i<etools.length();i++) 
		{ 
			TslInst tsl = (TslInst)etools[i];
			if ( ! tsl.bIsValid() || _ThisInst == tsl) continue;
			if(_ThisInst.ptOrg() == tsl.ptOrg() && !_bOnDebug)
			{ 
				eraseInstance();
				return;
			}
		}//next i
		
		Body bdThread(ptThreadTop, ptThreadBottom, dThreadDiameter/2);
		bdThread.vis(6);
		Display dp(252);
		dp.showInDxa(true); //HSB-18650 standard display published for share and make
		dp.draw(bdThread);
		
		// HSB-13069 Drill
		if (iDrill)
		{
			Drill dr(pt + vecXT * dEps, pt - vecXT * (dLengthDrillReal + dEps), .5 * dDiameterDrillReal);
			bmMale.addTool(dr);
			bmFemale.addTool(dr);
		}
		
		Body bdHead(ptHeadBottom, ptThreadTop, dHeadDiameter/2);
		bdHead.vis(6);
		
		dp.color(iColor); //default 252
		dp.draw(bdHead);
	
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
		{ 
			HardWrComp hwc(sArticleNumber, 1); // the articleNumber and the quantity is mandatory
			
			hwc.setManufacturer(sManufacturer);
			
			hwc.setModel(sFamily);
			hwc.setName(sDescription);
			hwc.setDescription(sDescription);
			hwc.setMaterial(sMaterial);
			//hwc.setNotes(sHWNotes);
			
			hwc.setGroup(sHWGroupName);
			hwc.setLinkedEntity(_ThisInst);	
			hwc.setCategory(T("|Fixture|"));
			hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
			
			hwc.setDScaleX(dLength);
			hwc.setDScaleY(dThreadDiameter);
			//hwc.setDScaleZ(dHWHeight);
			
		// apppend component to the list of components
			hwcs.append(hwc);
		}
	
	// make sure the hardware is updated
		if (_bOnDbCreated)	setExecutionLoops(2);				
		_ThisInst.setHardWrComps(hwcs);	
		//endregion	
	}
	
	
// element: find beam/beam relations. This instance exists only as filter and get erased than.
	else if (nMode==1)
	{ 	
		PropString sDistribution(2, sDistributionNames, sDistributionName);							
		PropString sOpeningPos(3, sOpeningPosNames, sOpeningPosName);	
		
	// create TSL
		TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
		GenBeam gbsTsl[2];			Entity entsTsl[] = {};			Point3d ptsTsl[] = {};
		int nProps[]={};			
		double dProps[]={dLength,dDiameterDrill,dLengthDrill};		
		String sProps[]={sPainter, sPosition, sManufacturer,  sFamily,sDrill};
		Map mapTsl;		

		int nDistribution = sDistributionNames.find(sDistribution);
		int nOpeningPos = sOpeningPosNames.find(sOpeningPos);
		
		for (int i=0;i<_Element.length();i++) 
		{ 
			Element el = _Element[i]; 
			_Pt0 = el.ptOrg();
			entsTsl.setLength(0);
			entsTsl.append(el);
			
			Vector3d vecY = el.vecY();
			Vector3d vecX = el.vecX();
			Vector3d vecZ = el.vecZ();
			
			// find beams
			Beam bmAll[] = el.beam();
			Beam bmMales[0], bmFemales[0];
			
			//Get All Male beams
			bmMales = vecX.filterBeamsPerpendicularSort(bmAll);
			
			//Check if painer is valid and remove male beams
			if(painter.bIsValid())
			{ 
				for (int j=bmMales.length()-1; j>=0 ; j--) 
				{ 
					Beam bm=bmMales[j]; 
					if (!bm.acceptObject(painter.filter()))
					{
						bmMales.removeAt(j);
					}
				}//next j
			}			
			
			//Get All Female beams
			for (int j=0;j<bmAll.length();j++) 
			{ 
				Beam bm = bmAll[j]; 
				if(!bm.vecX().isParallelTo(vecY))
				{ 
					bmFemales.append(bm);
				}
			}//next jfm


			//region Check rule for screws at openings
			double dOpeningWidths[0];
			Beam bmOps[0];
			
			if(nOpeningPos < 2)
			{
				Opening ops[] = el.opening();
				
				for(int i=0; i < ops.length(); i++)
				{
					CoordSys csOp = ops[i].coordSys();
					Point3d ptOpMid = csOp.ptOrg() + csOp.vecX() * 0.5 * ops[i].width() + csOp.vecY() * 0.5 * ops[i].height();
					
				// Get the opening distances (start and end) from element ptOrg to check if beams are in that range
					if(nOpeningPos == 0)
					{
						double dOpMid = vecX.dotProduct(ptOpMid - _Pt0);
						double dOpW2 = 0.5 * ops[i].width();
						dOpeningWidths.append(dOpMid - dOpW2);
						dOpeningWidths.append(dOpMid + dOpW2);
					}
				
				// Get the first beam left and right of the opening which is assumed to be a Kingstud. The assumption is that this is the first stud of a side by side
				// collection of studs which is longer than the first stud found at the opening. 					
					if(nOpeningPos < 2)
					{
						Beam bmsL[] = Beam().filterBeamsHalfLineIntersectSort(bmMales, ptOpMid, - vecX, true);
						Beam bmsR[] = Beam().filterBeamsHalfLineIntersectSort(bmMales, ptOpMid, vecX, true);	
						
						for(int j=0; j < 2; j++)
						{
							Beam bms[0];
							bms = (j == 0) ? bmsL : bmsR;
							Beam bm;
							Vector3d vec = (j == 0) ? - vecX : vecX;
							
							for(int k=0; k < bms.length(); k++)
							{
								bm = bms[k];
								if(k < bms.length()-1)
								{
									double d = vec.dotProduct(bms[k + 1].ptCen() - bm.ptCen());		
								// Next stud is not touching this stud
									if(0.5 *(bm.dW() + bms[k+1].dW()) + dEps < d)
									{
										bmOps.append(bm);
										break;
									}
								// Next stud has the same length as this stud. This stud is already longer than the first stud. So this stud is assumed to be the Kingstud
									else if(bm.dL() > bms[0].dL()+dEps && bm.dL() + dEps > bms[k+1].dL())
									{
										bmOps.append(bm);
										break;										
									}
								}
							// No other stud has match criterias, so take the last stud found
								else
								{
									bmOps.append(bm);
									break;
								}
							}
						}
					}
				}
			}					
			//End Check rule for screws at openings//endregion 
			
		// Set screws only at Kingstuds. Ignore Painter rule
			if(nDistribution == 3)
				bmMales = bmOps;
				
			bmMales = vecX.filterBeamsPerpendicularSort(bmMales);
			Point3d ptCenLastBm;
			int nInLine;

			double dMinSideDistance = U(70);
			for (int j=0; j < bmMales.length();j++) 
			{ 				
				Beam bmMale = bmMales[j]; 
				Point3d ptCenMale = bmMale.ptCen();
				double dLenMale = bmMale.solidLength();
				Vector3d vecXT = bmMale.vecX();
				Vector3d vecZT = bmMale.vecD(vecZ);
				Vector3d vecYT = vecXT.crossProduct(-vecZT);
				
				//region nDistribution > 0 beams lined up in vecX direction are handled as one beam
					if( abs(vecX.dotProduct(ptCenLastBm - ptCenMale)) < dEps)
						nInLine++;
				
					ptCenLastBm = ptCenMale;
								
					if (nDistribution == 1 && (j - nInLine) % 2 == 0 || nDistribution == 2 && (j - nInLine) % 2 == 1)
					{
						if(bmOps.find(bmMale) == -1)
						{
							continue;
						}
					}
						
					ptCenLastBm = ptCenMale;						
				//End nDistribution > 0 beams lined up in vecX direction are handled as one beam//endregion 
				
			// Check beams in on top or underneath openings
				if(nOpeningPos == 0)
				{
					double dDist = vecX.dotProduct(ptCenMale - _Pt0); 
					int bContinueMales;
					
					for(int k=0; k < dOpeningWidths.length(); k+=2)
					{
						if(k < dOpeningWidths.length()-1)
						{
							if(dDist > dOpeningWidths[k] && dDist < dOpeningWidths[k+1])
							{
								bContinueMales = true;
								break;
							}
						}
					}
					if(bContinueMales)
						continue;
				}
				
				if (bmMale.dD(vecZT) < dMinSideDistance)continue;// ignore smaller studs

				Beam bmFemAttached[0];
				double radiusCapsule = U(20); // .5 * (bmMale.dH() > bmMale.dW() ? bmMale.dW() : bmMale.dH());				
				Body bdCaps(ptCenMale, vecXT, bmMale.vecY(), bmMale.vecZ(), dLenMale+2*radiusCapsule, bmMale.dD(vecYT), dMinSideDistance, 0, 0, 0);
				Beam bmFemsCapInterSect[] = bdCaps.filterGenBeamsIntersect(bmFemales);
				
				Vector3d vecUpMale = (vecY.dotProduct(vecXT) > 0)? vecXT : - vecXT;
				
				for (int f=0;f<bmFemsCapInterSect.length();f++) 
				{ 
					Beam bmFemCapInterSect = bmFemsCapInterSect[f];
					Point3d ptFemCapCen = bmFemCapInterSect.ptCen();
					Vector3d vecFemCapXT = bmFemCapInterSect.vecD(vecXT);
					vecXT = vecUpMale;
					
					Point3d pt;
					int bOK = Line(bmMale.ptCen(), vecXT).hasIntersection(Plane(ptFemCapCen,vecFemCapXT),pt);
		
					if(vecXT.dotProduct(pt-bmMale.ptCen()) < 0)
					{ 
						if(nPosition == 0)
							continue;
						vecXT = -vecXT;
						vecYT = -vecYT;
					}
					else if(nPosition == 1)
						continue;
						
					bOK = Line(bmMale.ptCen(), vecXT).hasIntersection(Plane(ptFemCapCen +vecFemCapXT*.5*bmFemCapInterSect.dD(vecXT),vecFemCapXT),pt);
						
					Body bdTEst(pt + vecXT * U(1), vecXT, vecYT, vecZT, dLength + U(1), dThreadDiameter * 2, dMinSideDistance, -1,0,0 );
					
					Beam bmFemalePars[] = bdTEst.filterGenBeamsIntersect(bmFemales);
					bmFemalePars = bmFemCapInterSect.vecD(-vecXT).filterBeamsPerpendicularSort(bmFemalePars);
					
					if(painter.bIsValid())
					{ 
						for (int b=bmFemalePars.length()-1; b>=0 ; b--) 
						{ 
							Beam bm=bmFemalePars[b]; 
							if (!bm.acceptObject(painter.filter()))
							{
								bmFemalePars.removeAt(b);
							}
						}//next j
					}
										
					if (bmFemalePars.length() < 1) continue;

					int bFound = bmFemAttached.find(bmFemalePars.last());
					if (bFound > -1) continue;
					bmFemAttached.append(bmFemalePars.last());
				
					gbsTsl.setLength(0);
					gbsTsl.append(bmMale);
					gbsTsl.append(bmFemalePars.last());
					
					entsTsl.setLength(0);
					entsTsl.append(el);
					mapTsl.setInt("mode", 2); // 0 = insert, 1 = element, 2 = beam/beam	
					
					if(!bDebug) tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
				}//next f
			}//next j
		}//next i
				
		if (!bDebug)eraseInstance();
	}
	

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
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18650 standard display published for share and make" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="5/10/2023 1:09:12 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13069: Add drill properties" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="9/14/2021 10:13:24 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-10161 Adjusted single mode and edit  element and wrong property set of products" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="2/2/2021 5:40:44 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End