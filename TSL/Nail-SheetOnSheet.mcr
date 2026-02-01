#Version 8
#BeginDescription
#Versions
Version 1.2    08.12.2021   HSB-13560 new context commands to remove a rule from a configuration and to show all rules in report dialog
Version 1.1    29.04.2021   HSB-11012 initial version, grid naillines added
Version 1.0    23.04.2021   HSB-11012 initial version of sheet on sheet nailing

This tsl creates sheet/panel naillines on a sheets/panels



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords Nail;Naillines;Element;CNC
#BeginContents
//region Part #1

/// <History>//region
// #Versions
// 1.2 08.12.2021 HSB-13560 new context commands to remove a rule from a configuration and to show all rules in report dialog , Author Thorsten Huck
// 1.1 29.04.2021 HSB-11012 initial version, grid naillines added , Author Thorsten Huck
// 1.0 23.04.2021 HSB-11012 initial version of sheet on sheet nailing , Author Thorsten Huck

/// </History>

/// <insert Lang=en>
/// Select properties or catalog entry, then select elements or sheets, and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates sheet/panel naillines on a sheets/panels based on painter configurations.
/// </summary>

/// <remark Lang=en>
/// This tool requires painter definitions and as such it is only available for hsbcad equal or higher than version 23. 
/// Although it provides automatic creation of these definitions the user might want to adjust them.
/// The detection of valid naillines is based on painter definitions and will work on all element types and in all zones.
/// It is recommended to store rules in a configuration and insert a full set of rules by using the tool Nail-App
///
/// The configuration will be stored inside the dwg but can be imported and exported by using the XML-Settings ribbon command or by calling hsbTslSettingsIO 
/// </remark>

/// commands
// Command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "Nail-SheetOnSheet")) TSLCONTENT
// Optional commands of this tool, first one also accesible through doubleclick
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Edit in Place|") (_TM "|Select nailing tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add new Configuration|") (_TM "|Select nailing tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Remove Configuration|") (_TM "|Select nailing tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Save as rule|") (_TM "|Select nailing tool|"))) TSLCONTENT
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
	
	String sPainterCollection = "Nailing\\";
	String sByZoneBelow = sPainterCollection  + T("|byZoneBelow|");
	String sBySheet = sPainterCollection + T("|bySheet|");
	String k;
//end Constants//endregion

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="Nail-Configuration";
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

//region Read Settings
	String sConfigurations[0];
	Map mapConfigs;
{
// get configurations
	mapConfigs = mapSetting.getMap("Configuration[]");
	for (int i=0;i<mapConfigs.length();i++) 
	{ 
		Map m = mapConfigs.getMap(i);
		String name=m.getMapName();;
		if (name.length()>0 && sConfigurations.find(name)<0)	
			sConfigurations.append(name);	
	}//next i
}
//End Read Settings//endregion 

//region DialogMode
	int nDialogMode = _Map.getInt("DialogMode");
	if (nDialogMode>0)
	{ 
		String sConfigurationName=T("|Configuration|");	
		String opmKey;
		
	// Add Configuration	
		if (nDialogMode==1)
		{ 
			opmKey = "AddConfiguration";
			PropString sConfiguration(nStringIndex++, T("|Nailing Set|"), sConfigurationName);	
			sConfiguration.setDescription(T("|Defines the name of a configuration|"));
		}
	// Remove Configuration	
		else if (nDialogMode==2)
		{ 
			opmKey = "RemoveConfiguration";	
			PropString sConfiguration(nStringIndex++,sConfigurations, sConfigurationName);	
			sConfiguration.setDescription(T("|Defines the name of a configuration which will be removed.|"));
		}	
	// Define Rule	
		else if (nDialogMode==3)
		{ 
			opmKey = "DefineRule";
			PropString sConfiguration(nStringIndex++,sConfigurations, sConfigurationName);
			sConfiguration.setDescription(T("|Defines the name of a configuration|"));
	
			String sRuleNameName=T("|Rule Name|");	
			PropString sRuleName(nStringIndex++, T("|Rule Name|"), sRuleNameName);	
			sRuleName.setDescription(T("|Defines the nameof he rule|"));
			sRuleName.setCategory(category);	
		}
	// Delete Rule	
		else if (nDialogMode==4)
		{ 
			String sConfigurationName=T("|Configuration|");	
			PropString sConfiguration(nStringIndex++,sConfigurations, sConfigurationName);
			sConfiguration.setDescription(T("|Defines the name of a configuration|"));
			sConfiguration.setReadOnly(true);
		
			String sRules[0];
			for (int i=0;i<mapConfigs.length();i++) 
			{ 
				Map m = mapConfigs.getMap(i);
				String name=m.getMapName().makeUpper();
				if (name.length()>0 && sConfiguration.makeUpper()==name)	
				{ 
					Map mapRules = m.getMap("Rule[]");
					for (int j=0;j<mapRules.length();j++) 
					{ 
						m = mapRules.getMap(j);
						String name=m.getMapName();
						if (name.length()>0 && sRules.find(name)<0)	
							sRules.append(name);
					}
				}	
			}//next i
	
			String sRuleNameName=T("|Rule Name|");	
			PropString sRuleName(nStringIndex++, sRules, sRuleNameName);	
			sRuleName.setDescription(T("|Defines the name of he rule which will be deleted on OK|"));
			sRuleName.setCategory(category);	
		}		
		setOPMKey(opmKey);
		return;
	}
//End DialogMode//endregion 

//region Painter Collections
	String sPainters[] = PainterDefinition().getAllEntryNames().sorted();
	String sContactPainters[0], sNailingPainters[0];
	for (int i = 0; i < sPainters.length(); i++)
	{
		PainterDefinition pd(sPainters[i]);
		String type = pd.type();
		if (type == "Sheet" ||type == "Panel" || type == "Sip" )
		{
			sContactPainters.append(sPainters[i]);
			sNailingPainters.append(sPainters[i]);	
		}	
	}

// contact painters
	sContactPainters = sContactPainters.sorted();
	if (sContactPainters.find(sByZoneBelow)<0)
	{
		sContactPainters.insertAt(0, sByZoneBelow);
	}	
//End Painter Collections//endregion 

//region Properties		
// SHEET
	category = T("|Tooling|");
	
	String sToolIndexName = T("|Tool Index|");
	PropInt nToolIndex(nIntIndex++, 1, sToolIndexName);
	nToolIndex.setDescription(T("|Defines the ToolIndex|"));
	nToolIndex.setCategory(category);	
	
	String sSpacingName = T("|Spacing|");
	PropDouble dSpacing(nDoubleIndex++, U(70), sSpacingName);
	dSpacing.setDescription(T("|Defines the spacing of the nailing|"));
	dSpacing.setCategory(category);
	
	String sSpacingModeName = T("|Spacing Mode|");
	String sSpacingModes[] ={ T("|Fixed Spacing|"),T("|Even Spacing|"),T("|Fixed Spacing, Last odd|")};
	PropString sSpacingMode(nStringIndex++, sSpacingModes, sSpacingModeName);	
	sSpacingMode.setDescription(T("|Defines the SpacingMode|"));
	sSpacingMode.setCategory(category);	

	String _sStrategies[] = { T("|Perimeter|"), T("|Perimeter + Grid|") ,T("|Grid|")};
	String sStrategies[]= _sStrategies.sorted();
	//sStrategies.insertAt(0, sDisabled);
	String sStrategyName=T("|Strategy|");	
	PropString sStrategy(nStringIndex++, sStrategies, sStrategyName);	
	sStrategy.setDescription(T("|Defines the Strategy|"));
	sStrategy.setCategory(category);


category = T("|Sheet|");
	
	String sPainterNailingName=T("|Painter|");	
	// support default painter creation
	if (_bOnInsert && sNailingPainters.findNoCase(sBySheet,-1)<0)sNailingPainters.insertAt(0, sBySheet);
	PropString sPainterNailing(nStringIndex++, sNailingPainters.sorted(), sPainterNailingName);	
	sPainterNailing.setDescription(T("|Defines the painter filter of the nailing entities.|"));
	sPainterNailing.setCategory(category);
	
	String sOffsetEdgeName=T("|Offset Edge|");	
	PropDouble dOffsetEdge(nDoubleIndex++, U(20), sOffsetEdgeName);	
	dOffsetEdge.setDescription(T("|Defines the general edge offset, can be overwritten by the bottom, top or side offsets|"));
	dOffsetEdge.setCategory(category);	

	String sOffsetBottomName=T("|Offset Bottom|");	
	PropDouble dOffsetBottom(nDoubleIndex++, U(0), sOffsetBottomName);	
	dOffsetBottom.setDescription(T("|Defines the offset at the bottom of a wall or on the -Y-Side of an element|, 0 = ") + sOffsetEdgeName);
	dOffsetBottom.setCategory(category);	

	String sOffsetTopName=T("|Offset Top|");	
	PropDouble dOffsetTop(nDoubleIndex++, U(0), sOffsetTopName);	
	dOffsetTop.setDescription(T("|Defines the offset at the top of a wall or on the +Y-Side of an element|, 0 = ") + sOffsetEdgeName);
	dOffsetTop.setCategory(category);

	String sMergeName=T("|Merge Gap|");	
	PropDouble dMerge(nDoubleIndex++, U(0), sMergeName);	
	dMerge.setDescription(T("|Defines how neighbouring contours will be merged|"));
	dMerge.setCategory(category);
	
// Grid
category = T("|Grid|");	
	String sGridOffsetName=T("|Offset|");	
	PropDouble dGridOffset(nDoubleIndex++, U(0), sGridOffsetName);	
	dGridOffset.setDescription(T("|Defines the grid offset for vertical or horizontal naillines|") + T(", |0 = byZone|"));
	dGridOffset.setCategory(category);

	String sGridModeName = T("|Spacing Mode|");
	String sGridModes[] ={ T("|Fixed Spacing|"),T("|Even Spacing|"),T("|Fixed Spacing, first and last odd|")};
	PropString sGridMode(nStringIndex++, sGridModes, sGridModeName);	
	sGridMode.setDescription(T("|Defines the spacing mode of a potential grid nailing|"));
	sGridMode.setCategory(category);
	
	String sGridAlignmentName=T("|Alignment|");	
	String sGridAlignments[] = { T("|Horizontal|"), T("|Vertical|")};
	PropString sGridAlignment(nStringIndex++, sGridAlignments, sGridAlignmentName);	
	sGridAlignment.setDescription(T("|Defines the GridAlignment|"));
	sGridAlignment.setCategory(category);
	
// CONTACT
category = T("|Contact|");
	
	String sPainterContactName=T("|Painter|");	
	if (_bOnInsert && sContactPainters.findNoCase(sByZoneBelow,-1)<0)sContactPainters.insertAt(0, sByZoneBelow);
	PropString sPainterContact(nStringIndex++, sContactPainters.sorted(), sPainterContactName);	
	sPainterContact.setDescription(T("|Defines the painter filter of the contact entities.|"));
	sPainterContact.setCategory(category);	
	
	String sOffsetEdgeContactName=T("|Offset Edge|");	
	PropDouble dOffsetEdgeContact(nDoubleIndex++, U(20), sOffsetEdgeContactName);	
	dOffsetEdgeContact.setDescription(T("|Defines the edge offset|"));
	dOffsetEdgeContact.setCategory(category);		

	String sMergeContactName=T("|Merge Gap|");	
	PropDouble dMergeContact(nDoubleIndex++, U(0), sMergeContactName);	
	dMergeContact.setDescription(T("|Defines how neighbouring contours will be merged|"));
	dMergeContact.setCategory(category);
	
	
	


//End Properties//endregion 

//region bOnInsert
	if(_bOnInsert)
	{
	//region Dialog
		if (insertCycleCount()>1) { eraseInstance(); return; }
		

	// silent/dialog
		if (_kExecuteKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());	
			if (sEntries.findNoCase(_kExecuteKey,-1)>-1)
				setPropValuesFromCatalog(_kExecuteKey);
			else
				setPropValuesFromCatalog(sLastInserted);					
		}	
	// standard dialog	
		else	
			showDialog();			
	//End Dialog//endregion 	

	//region Create new painter if bySheet has been selected
		if (sPainterNailing == sBySheet)
		{ 
		// prepare TSL cloniing
			TslInst tslNew;				Map mapTsl=_Map;	
			GenBeam gbsTsl[] = {};		Entity entsTsl[1];			Point3d ptsTsl[1];
			int nProps[]={nToolIndex};
			double dProps[]={dSpacing,dOffsetEdge,dOffsetBottom,dOffsetTop,dMerge,dGridOffset, dOffsetEdgeContact,dMergeContact};
			String sProps[]={sSpacingMode,sStrategy,sPainterNailing,sGridMode,sGridAlignment,sPainterContact};

			String sMaterials[0]; // the collection of potential new painter names
			PrEntity ssE(T("|Select sheets|"), Sheet());
		  	if (ssE.go())
				_Sheet.append(ssE.sheetSet());	
		
		// collect elements to which this will be created
			for (int i=0;i<_Sheet.length();i++) 
			{ 
				Sheet& sh = _Sheet[i];
				Element el =sh.element();
				if (el.bIsValid() && _Element.find(el)<0)
					_Element.append(el);
					
				String sMaterial = sh.material();
				if (sMaterial.length()>0 && sMaterials.findNoCase(sMaterial,-1)<0)
				{
					sMaterials.append(sMaterial);
					
					if (sContactPainters.findNoCase(sPainterCollection+sMaterial,-1)<0)
					{ 
						PainterDefinition pd(sPainterCollection+sMaterial);
						pd.dbCreate();
						pd.setType("Sheet");
						pd.setFilter("((Equals(Material,'"+sMaterial+"')))");						
					}
	
				}
			}//next i
			
		// create for each material selected	
			for (int j=0;j<sMaterials.length();j++) 
			{ 
				sProps[2] = sPainterCollection + sMaterials[j];
			// create for each element	
				for (int i=0;i<_Element.length();i++) 
				{ 
					entsTsl[0] = _Element[i]; 
					ptsTsl[0] = _Element[i].ptOrg();
					tslNew.dbCreate(scriptName() , _Element[i].vecX() ,_Element[i].vecY(),gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	 
				}//next i	
				 
			}//next j
		}			
	//End Create new painter if bySheet has been selected//endregion 

	//region Create by element selection
		else
		{ 
		// create TSL
			TslInst tslNew;				Map mapTsl;						int bForceModelSpace = true;		
			String sCatalogName = sLastInserted;						String sExecuteKey;	
			String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
			GenBeam gbsTsl[] = {};		Entity entsTsl[1];				Point3d ptsTsl[] = {_Pt0};		
						
			PrEntity ssE(T("|Select elements|"), Element());
		  	if (ssE.go())
				_Element.append(ssE.elementSet());	
				
			for (int i=0;i<_Element.length();i++) 
			{ 
				entsTsl[0] = _Element[i]; 
				ptsTsl[0] = _Element[i].ptOrg();
				tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent);		 
			}//next i				
				
		}			
	//End Create by element selection//endregion 		

		eraseInstance();	
		return;
	}	
// end on insert	__________________//endregion

//endregion 

//region Validate element and get variables
	if (_Element.length()<1)
	{
		reportMessage(TN("|Element reference not found.|"));
		eraseInstance();
		return;	
	}
	Element& el = _Element[0];
	CoordSys cs = el.coordSys();
	Vector3d vecX = cs.vecX();
	Vector3d vecY = cs.vecY();
	Vector3d vecZ = cs.vecZ();
	Point3d ptOrg = cs.ptOrg();
	double dWidth0 = el.dBeamHeight();
	Line lnX(ptOrg, vecX);
	Line lnY(ptOrg, vecY);
	setDependencyOnEntity(el);
	
	int nSpacingMode = sSpacingModes.find(sSpacingMode);
	if (dSpacing <=0)
	{ 
		dSpacing.set(U(70));
		reportMessage(TN("|Spacing must be > 0|") + T("|Spacing has been adjusted to| ") + dSpacing);
	}
	
	// 0 = Perimeter
	// 1 = Perimeter + Grid
	// 2 = Grid
	int nStrategy = _sStrategies.find(sStrategy); 
	int nGridMode = sGridModes.find(sGridMode, 0);
	int nGridAlignment = sGridAlignments.find(sGridAlignment, 0); // 0 = horizontal , 1 == vertical
	
	if (nStrategy == 0)
	{ 
		dGridOffset.setReadOnly(_kHidden);
		sGridMode.setReadOnly(_kHidden);
		sGridAlignment.setReadOnly(_kHidden);
	}
	
	
	
//endregion	
	
//region Collect entities by painter
	Sheet allSheets[] = el.sheet();
	Sip allSips[] = el.sip();


// Nailing painter
	PainterDefinition pdNailing(sPainterNailing);
	Sheet sheets[]=pdNailing.filterAcceptedEntities(el.sheet());			
	if (sheets.length()<1)
	{
		reportMessage("\n"+ scriptName() +  T(": |Could not find any sheets to be nailed.|")); 
		eraseInstance();
		return;
	}

//Contact painter
	int nContactPainter = sContactPainters.find(sPainterContact);
	PainterDefinition pdContact(sPainterContact);
	
	// create byZonebelow painter definition if selected and not present	
	if (sPainterContact==sByZoneBelow && !pdContact.bIsValid())
	{	
		pdContact = PainterDefinition(sByZoneBelow);
		pdContact.dbCreate();
		pdContact.setType("Sheet");
		pdContact.setFilter("((Equals(IsDummy,'false')))");
		//if(bDebug)reportNotice("\nNew painter definition created: "+sByZoneBelow + " with filter: " + pdContact.filter());
		setExecutionLoops(2);
		return;
	}

	GenBeam gbContacts[0];
	for (int i=0;i<allSheets.length();i++) gbContacts.append(allSheets[i]);
	for (int i=0;i<allSips.length();i++) gbContacts.append(allSips[i]);
	if (nContactPainter>0) // defined by painter
		gbContacts = pdContact.filterAcceptedEntities(gbContacts);

		
	//End Contact painter



//End Collect entities//endregion 

//region Nailing Zone	
	int nZone=99,nZones[0];

// get preset zone index
	k = "myZoneIndex";
	int bHasZoneIndex = _Map.hasInt(k);
	if(bHasZoneIndex) 
	{
		nZone = _Map.getInt(k);
		assignToElementGroup(el,true, nZone,'E');// assign to element tool sublayer	

	// erase all nailing linesx
		if (_bOnDbCreated)
		{ 
			NailLine nlines[] = el.nailLine();
			for (int t=nlines.length()-1;t>=0;t--) 
				if (nlines[t].zoneIndex()==nZone)
					nlines[t].dbErase();			
		}


	// reset if nailing painter changes
		if (_kNameLastChangedProp==sPainterNailingName)
		{ 
			_Map.removeAt(k, true);
			bHasZoneIndex = false;
			nZone = 99;
		}
	}

// collect all zones of nailing subset, remove all sheets not matching the zone preset
	for (int i=sheets.length()-1; i>=0 ; i--) 
	{ 
		int n= sheets[i].myZoneIndex();
		if (nZones.find(n)<0)
			nZones.append(n);
		if (bHasZoneIndex && n!=nZone)
			sheets.removeAt(i);
	}//next i

//Clone instance for all affected zones
	if(!bHasZoneIndex)
	{ 
	// create TSL
		TslInst tslNew;				Map mapTsl=_Map;	
		GenBeam gbsTsl[] = {};		Entity entsTsl[] = {el};			Point3d ptsTsl[] = {ptOrg};
		int nProps[]={nToolIndex};
		double dProps[]={dSpacing,dOffsetEdge,dOffsetBottom,dOffsetTop,dMerge,dGridOffset, dOffsetEdgeContact,dMergeContact};
		String sProps[]={sSpacingMode,sStrategy,sPainterNailing,sGridMode,sGridAlignment,sPainterContact};

		for (int i=0;i<nZones.length();i++) 
		{ 
			mapTsl.setInt("myZoneIndex", nZones[i]); // instead of property set the zone to be a map based
			tslNew.dbCreate(scriptName() , vecX ,vecY,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	
		}//next i
				
		eraseInstance();
		return;		
	}
	
//End Nailing Zone//endregion 


//region Contact Zone
// Remove any contact genbeam which is not below the designated zone
	if (nZone!=99)
	{ 
		int sgn = nZone==0?1:nZone / abs(nZone);
		for (int i=gbContacts.length()-1; i>=0 ; i--) 
		{ 
			int n =gbContacts[i].myZoneIndex()*sgn; 
			if (n>=nZone*sgn)
				gbContacts.removeAt(i);
		}//next i		
	}

	if (gbContacts.length()<1)
	{ 
		reportMessage("\n"+ scriptName() + T(": |Could not find contact entity in zone| ") + nZone+T(" |Tool will be deleted.|"));
		if (!bDebug)eraseInstance();
		return;	
	}

	

//End Contact Zone//endregion 

//region Get nail base plane
	ElemZone zone = el.zone(nZone);
	
	double dZoneWidth = zone.dVar("width");
	double dZoneHeight = zone.dVar("height");
	String sZoneDistr = zone.distribution();
	
	
	Point3d ptOrgZ = zone.ptOrg();
	Vector3d vecFace = zone.vecZ();
	Plane pn(zone.ptOrg(), vecFace);	
	CoordSys csZone(ptOrgZ, vecX, vecX.crossProduct(-vecFace), vecFace);
	double dZoneOffsetZ = vecFace.dotProduct(ptOrgZ - ptOrg) - (nZone < 0 ? el.dBeamWidth() : 0)+dEps;
//End Get nail base plane//endregion 

//region Collect nailable area
	PlaneProfile ppNails[0],ppNail(csZone);//
	PlaneProfile ppUnion(csZone);
 	for (int i=0;i<sheets.length();i++) 
 	{ 
 		Sheet& sheet = sheets[i];
 		if (sheet.myZoneIndex() != nZone)continue;
 		PlaneProfile pp(csZone);
		pp.unionWith(sheet.profShape());

		pp.shrink(dEps-dMerge);
		ppNail.unionWith(pp);
		ppUnion.unionWith(pp);
 	}//next i	
	ppNail.shrink(dMerge+dOffsetEdge-dEps);	
	ppUnion.shrink(dMerge-dEps);
	
	//ppNail.subtractProfile(el.noNailProfile(nZone));//Trim by NoNail	
	{ 
		PLine rings[0];
		
		{ 
			rings= ppNail.allRings(true, false);
			for (int r=0;r<rings.length();r++) 
			{ 
				PlaneProfile pp(csZone);
				pp.joinRing(rings[r], _kAdd); 
				ppNails.append(pp);
			}//next r			
		}
		
		{
			
			rings = ppNail.allRings(false, true);
			for (int i = 0; i < ppNails.length(); i++)
			{
				for (int r = 0; r < rings.length(); r++)
					ppNails[i].joinRing(rings[r],_kSubtract);
			}//next i
		}
	}	

	ppNail.vis(252);
//End Collect nailable area//endregion 

//region Grid Nailing
	LineSeg segGrids[0];
	if (nStrategy==1 ||nStrategy == 2)
	{ 
		double dGridDelta = dGridOffset;
		Vector3d vecDir = nGridAlignment == 0?vecY:vecX;
		if (dGridDelta<=0)
		{
			dGridDelta = .5*(nGridAlignment == 0 ? dZoneHeight : dZoneWidth); // half grid
		}
	
		
		PLine rings[]= ppNail.allRings(true, false);
		
		for (int r=0;r<rings.length();r++) 
		{ 
			if (dGridDelta<=0)
			{ 
				reportMessage("\n" + scriptName() + ": " +T("|The sheeting type of zone| ") + nZone + T(", |element| ")+ el.number() +   T(" |does not support a half grid dimension|"));				
				break;
			}
			PlaneProfile pp(csZone);
			pp.joinRing(rings[r], _kAdd); 

			double dX = pp.dX();
			double dY = pp.dY();
			

			LineSeg seg = pp.extentInDir(vecX);	//seg.vis(j);
			Point3d ptFrom = seg.ptStart();
			Point3d ptTo = seg.ptEnd();
			double dMySpacing = dGridDelta;
			double dL = abs(vecDir.dotProduct(ptTo-ptFrom));
			if (dL < .25 * dGridDelta)continue; // skip very short segments			
			
			int num;
			if (nGridMode==1)// even
			{ 
				num = dL / dGridDelta;
				if (num*dGridDelta<dL)dMySpacing = dL / (num + 1);
			}	
			else if (nGridMode == 2) //fixed + odd
			{
				num = dL / dGridDelta;
				if (num < 1)num = 1;
				dL = num * dGridDelta;
				double d = vecDir.dotProduct(ptTo - ptFrom)-dL;
				if (d>dEps)
				{ 
					num++;
					ptFrom += vecDir * (.5 * d-dGridDelta);
					ptTo -= vecDir * .5 * d;					
				}
			}
			else // fixed
			{ 
				num = dL / dGridDelta;
				if (num < 1)num = 1;
				dL = num * dMySpacing;
				ptTo = ptFrom + vecDir*dL;
			}	

			
			Vector3d vecPerp = vecDir.crossProduct(-vecZ);
			Point3d ptX = ptFrom;
			ptX+=vecPerp*vecPerp.dotProduct(seg.ptMid()-ptX);
			for (int i=0;i<num;i++) 
			{ 
				ptX += vecDir * dMySpacing;				
				segGrids.append(LineSeg(ptX - vecPerp * U(10e3), ptX + vecPerp * U(10e3)));
				//vecPerp.vis(ptX,i);
				//segGrids[segGrids.length()-1].vis(i);		 
			}//next i
			
			//ptFrom.vis(1);			ptTo.vis(1);
			
		}//next r			
	
	}
//End Grid Nailing//endregion 


//region Collect contact area
	PlaneProfile ppContact(csZone);//
	
 	for (int i=0;i<gbContacts.length();i++) 
 	{ 
 		PlaneProfile pp(csZone);
 		Sheet sheet= (Sheet)gbContacts[i];
		if (sheet.bIsValid())
		{ 
			pp.unionWith(sheet.profShape());
			
		}
		else
		{ 
			Sip sip= (Sip)gbContacts[i];
			if (sip.bIsValid())
			{ 
				pp.unionWith(sip.envelopeBody().extractContactFaceInPlane(pn,dEps));
			}
		}
		ppUnion.unionWith(pp);
		pp.shrink(dEps-dMergeContact);
		if (pp.area()>pow(dEps,2))ppContact.unionWith(pp);	
 		//pp.vis(i);
 	}//next i	
	ppContact.shrink(dMergeContact+dOffsetEdgeContact-dEps);
	//ppContact.subtractProfile(el.noNailProfile(nZone+(nZone<0?1:-1)));//Trim by NoNail
	ppContact.vis(2);
//End Collect nailable area//endregion 

//region Bottom / Top Offset
	if (dOffsetBottom>0 || dOffsetTop>0)
	{ 
		ppUnion.removeAllOpeningRings();
		double dX = ppUnion.dX();
		double dY = ppUnion.dY();
		Point3d pt = ppUnion.ptMid();
		pt.vis(3);
		if (dOffsetBottom>0)
		{ 
			PlaneProfile pp; pp.createRectangle(LineSeg(pt - vecY * dY - vecX * dX, pt -  vecY * (.5 *dY - dOffsetBottom) + vecX * dX), vecX, vecY);
			//pp.vis(6);
			ppContact.subtractProfile(pp);
		}
		if (dOffsetTop>0)
		{ 
			PlaneProfile pp; pp.createRectangle(LineSeg(pt + vecY * dY - vecX * dX, pt +vecY * ( .5 * dY - dOffsetTop) + vecX * dX), vecX, vecY);
			//pp.vis(6);
			ppContact.subtractProfile(pp);
		}
	}
//End Bottom / Top Offset//endregion 




// Trigger EditInPlace//region
	String sTriggerEditInPlace = T("|Edit in Place|");
	int bExplode;
	addRecalcTrigger(_kContextRoot, sTriggerEditInPlace );
	if (_bOnRecalc && (_kExecuteKey==sTriggerEditInPlace || _kExecuteKey==sDoubleClick))
	{
		bExplode=true;
	}//endregion


//region Collect nailing segments of contact profiles
	LineSeg segNails[0];

// loop sheet perimeters
	for (int i=0;i<ppNails.length();i++) 
	{ 
		PlaneProfile pp = ppNails[i];
		pp.intersectWith(ppContact);

		if (nStrategy==0 ||nStrategy==1) // perimeter or perimeter+grid)
		{
			PLine rings[] = pp.allRings();
			for (int r=0;r<rings.length();r++) 
			{ 
				PLine ring = rings[r];
				//ring.convertToLineApprox(dSpacing*.5);
				//ring.vis(r);
				Point3d pts[]=ring.vertexPoints(false);

			// convert to bounding box if circular
				if (pts.length()<4)
				{ 
					PlaneProfile pp(ring);
					pp.shrink(-dEps); // the boxed circle needs to be slightly bigger to make sure that the splitSegments returns only one segment instead of being splitted at the tangent
					ring.createRectangle(pp.extentInDir(vecX), vecX, vecY);
					pts=ring.vertexPoints(false);
				}
		
				for (int p=0;p<pts.length()-1;p++) 
				{ 
					Point3d pt1 = pts[p]; 
					Point3d pt2 = pts[p+1]; 
					LineSeg seg(pt1, pt2); seg.vis(1);
					
					PlaneProfile pp = ppContact;
					pp.subtractProfile(el.noNailProfile(nZone));//Trim by NoNail
					pp.subtractProfile(el.noNailProfile(nZone+(nZone<0?1:-1)));//Trim by NoNail
					
					LineSeg segs[] = pp.splitSegments(seg, true);
					//if (bDebug)	for (int s=0;s<segs.length();s++) segs[s].vis(4); 	
					segNails.append(segs);
				}//next p	

			}//next r	
		}
		
		if (nStrategy == 1 || nStrategy == 2) //grid or perimeter + grid)
		{
			pp.subtractProfile(el.noNailProfile(nZone));//Trim by NoNail		
			
			for (int j=0;j<segGrids.length();j++) 
			{ 
				LineSeg segs[] = pp.splitSegments(segGrids[j], true);
				segNails.append(segs);		 
			}//next j
		}
	}//next i

//endregion 

//region Add naillines
	for (int j=0;j<segNails.length();j++) 
	{ 
		LineSeg seg = segNails[j];	//seg.vis(j);
		Point3d ptFrom = seg.ptStart();
		Point3d ptTo = seg.ptEnd();
		double dMySpacing = dSpacing;
		double dL = seg.length();
		if (dL < .5 * dSpacing)continue; // skip very short segments			
		if (nSpacingMode==0)// fixed
		{ 
			int num = dL / dSpacing;
			Vector3d vecDir = ptTo - ptFrom; vecDir.normalize();
			if (num < 1)num = 1;
			dL = num * dMySpacing;
			ptTo = ptFrom + vecDir*dL;
		}
		else if (nSpacingMode==1)// even
		{ 
			int num = dL / dSpacing;
			if (num*dSpacing<dL)dMySpacing = dL / (num + 1);
		}						
		if (bDebug)seg.vis(abs(dSpacing-dMySpacing)>dEps?1:nSpacingMode+40);
		else
		{ 
			ElemNail nail(nZone, ptFrom, ptTo, dMySpacing, nToolIndex);
			
			if(bExplode)
			{
				NailLine nl;		
				nl.dbCreate(el, nail);
			}	
			else
				el.addTool(nail);
		}
	}//next j		
//End Add naillines//endregion

//region Trigger
{ 
	


// create TSL
	TslInst tslDialog;			Map mapTsl;						
	GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };
			

//region Trigger AddNewConfig
	String sTriggerAddNewConfig = T("|Add new Configuration|");
	addRecalcTrigger(_kContext, sTriggerAddNewConfig );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddNewConfig)
	{
		mapTsl.setInt("DialogMode",1);
		sProps.append(T("|Default|"));
		
		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						
		
		if (tslDialog.bIsValid())
		{ 
			int bOk = tslDialog.showDialog();		
			if (bOk)
			{ 
				String sName = tslDialog.propString(0);
			// invalid name
				if (sName.length()<1)reportMessage("\n" + T("|Invalid name.|"));
			// add new configuration
				else if (sConfigurations.findNoCase(sName,-1)<0);
				{ 
					Map mapConfig;
					mapConfig.setMapName(sName);
					mapConfigs.appendMap("Configuration", mapConfig);
					mapSetting.setMap("Configuration[]", mapConfigs);
					if (mo.bIsValid())mo.setMap(mapSetting);
					else mo.dbCreate(mapSetting);
				}				
			}
			tslDialog.dbErase();
		}
		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger RemoveSet
	if (sConfigurations.length()>0)
	{ 
		String sTriggerRemoveConfig = T("|Remove Configuration|");
		addRecalcTrigger(_kContext, sTriggerRemoveConfig );
		if (_bOnRecalc && _kExecuteKey==sTriggerRemoveConfig)
		{
	
			mapTsl.setInt("DialogMode",2);
			tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						
			
			if (tslDialog.bIsValid())
			{ 
				int bOk = tslDialog.showDialog();
				
				if (bOk)
				{ 
					String removeName = tslDialog.propString(0);
					Map _mapConfigs;
					for (int i=0;i<mapConfigs.length();i++) 
					{ 
						Map m = mapConfigs.getMap(i);
						String name =m.getMapName();
						if (name.length()>0 && name!=removeName)
							_mapConfigs.appendMap("Configuration",m); 
					}//next i
					mapSetting.setMap("Configuration[]", _mapConfigs);
					if (mo.bIsValid())mo.setMap(mapSetting);
				}
				tslDialog.dbErase();
			}
			setExecutionLoops(2);
			return;
		}		
	}//endregion	

//region Trigger AddRule
	String sTriggerAddRule = T("|Save as rule|");
	addRecalcTrigger(_kContextRoot, sTriggerAddRule );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddRule)
	{
	// append default configuration	
		if (sConfigurations.length()<1)
		{ 
			sConfigurations.append("Default");
			Map mapConfig;
			mapConfig.setMapName(sConfigurations.first());
			mapConfigs.appendMap("Configuration", mapConfig);
			mapSetting.setMap("Configuration[]", mapConfigs);
			if (mo.bIsValid())mo.setMap(mapSetting);
			else mo.dbCreate(mapSetting);			
		}
		
	// prepare dialog instance	
		mapTsl.setInt("DialogMode",3);
		sProps.append(sConfigurations.first());
		sProps.append(sPainterNailing);	
		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						
		
		if (tslDialog.bIsValid())
		{ 
			int bOk = tslDialog.showDialog();
			if (bOk)
			{
				String sConfiguration = tslDialog.propString(0);
				String sRuleName = tslDialog.propString(1);
				
				sRuleName = sRuleName.length() < 1 ? sPainterNailing : sRuleName;
				
			// get current configuration	
			 	Map mapAllConfigs,mapConfig;
				for (int i = 0; i < mapConfigs.length(); i++)
				{
					Map m = mapConfigs.getMap(i);
					String name = m.getMapName();
					if (name.length()>0 && name==sConfiguration)
					{
						mapConfig = m;
						reportMessage("\nConfiguration found " + name);
					}
					else if(m.length()>0)
						mapAllConfigs.appendMap("Configuration",m);
				}	
				
			// get current rule
			 	Map mapRules=mapConfig.getMap("Rule[]"), _mapRules,mapRule;
				for (int i=0; i<mapRules.length(); i++)
				{
					Map m = mapRules.getMap(i);
					String name = m.getMapName();
					if (name.length()>0 && name==sRuleName)
						mapRule = m;
					else if(m.length()>0)
						_mapRules.appendMap("Rule",m);
				}
				mapRules = _mapRules;
				
			// Overwrite existing rule
				int bAdd=true;
				if (mapRule.length()>0)
				{ 
					String sInput = getString(T("|Overwrite existing rule?|") + " [" + T("|No|") +"/"+T("|Yes|")+"]");
					if (sInput.makeUpper()!=T("|Yes|").makeUpper().left(1))
					{	
						reportMessage("\n" + scriptName() + " " + T("|canceled|")+ ".");
						bAdd = false;
					}
				}
				
			// add current rule
				if (bAdd)
				{ 
					mapRule.setString("scriptName", scriptName());
					mapRule.setMap("PropertyMap",_ThisInst.mapWithPropValues());
					mapRule.setMapName(sRuleName);		
					mapRules.appendMap("Rule",mapRule);
					
					mapConfig.setMap("Rule[]", mapRules);
					mapAllConfigs.appendMap("Configuration",mapConfig);
					mapSetting.setMap("Configuration[]", mapAllConfigs);
					if (mo.bIsValid())mo.setMap(mapSetting);					
				}

			}
			tslDialog.dbErase();
		}
		setExecutionLoops(2);
		return;			
	}
	//endregion	
	
//region Trigger DeleteRule
	// delete selected rule and save to settings //HSB-13560
	for (int c=0;c<sConfigurations.length();c++) 
	{ 
		String sTriggerDeleteRule = T("|Delete rule|");
		if (sConfigurations.length()>1)
			sTriggerDeleteRule += " ("+sConfigurations[c]+ ")";
		addRecalcTrigger(_kContext, sTriggerDeleteRule );
		if (_bOnRecalc && _kExecuteKey==sTriggerDeleteRule)
		{
			
		// prepare dialog instance	
			mapTsl.setInt("DialogMode",4);
			sProps.append(sConfigurations[c]);	
			tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						
			
			if (tslDialog.bIsValid())
			{ 
				int bOk = tslDialog.showDialog();
				if (bOk)
				{
					String sConfiguration = tslDialog.propString(0);
					String sRuleName = tslDialog.propString(1);

				// get current configuration	
				 	Map mapUpdatedConfigs,mapConfig;
					for (int i = 0; i < mapConfigs.length(); i++)
					{
						Map m = mapConfigs.getMap(i);
						String name = m.getMapName();					
						if (name.length()>0 && name==sConfiguration)
						{
							//reportNotice("\nmodifying configuration "+ name);
							mapConfig = m;
						}
						else if(m.length()>0)
							mapUpdatedConfigs.appendMap("Configuration",m);
					}
					mapConfigs = mapUpdatedConfigs;
					
				// rewrite config wihout selected rule
				 	Map mapRules=mapConfig.getMap("Rule[]"), mapUpdatedRules,mapRule;
				 	//reportNotice("\nConfiguration "+ mapConfig.getMapName() + " has " +mapRules.length() + " rules" );
					for (int i=0; i<mapRules.length(); i++)
					{
						Map m = mapRules.getMap(i);
						String name = m.getMapName();
						if (name.length()>0 && name==sRuleName)
						{
							;//reportNotice("\nremoving rule "+ name);
						}
						else if(m.length()>0)
							mapUpdatedRules.appendMap("Rule",m);
					}
					mapConfig.setMap("Rule[]", mapUpdatedRules);
					//reportNotice("\nConfiguration "+ mapConfig.getMapName() + " now has " +mapUpdatedRules.length() + " rules" );
					mapConfigs.appendMap("Configuration",mapConfig);
					mapSetting.setMap("Configuration[]", mapConfigs);
					if (mo.bIsValid())mo.setMap(mapSetting);
				}
				tslDialog.dbErase();
			}
			setExecutionLoops(2);
			return;			
		}

	}//next c
	//endregion

//region Trigger RuleReport
	String sTriggerRuleReport = T("|Show Rule Definitions|");
	addRecalcTrigger(_kContext, sTriggerRuleReport );
	if (_bOnRecalc && _kExecuteKey==sTriggerRuleReport)
	{
		reportNotice("\n\n" + T("|Rule Definitions|"));

		for (int i = 0; i < mapConfigs.length(); i++)
		{
			Map mapConfig = mapConfigs.getMap(i);
			reportNotice("\n\n"  +T("|Configuration| ")+mapConfig.getMapName() + " ________________________________");
					
			for (int ii = 0; ii < mapConfig.length(); ii++)
			{
				Map mapRules = mapConfig.getMap(ii);
				for (int j = 0; j < mapRules.length(); j++)
				{
					Map mapRule = mapRules.getMap(j);
					reportNotice("\n\n   *** "  +T("|Rule| ")+mapRule.getMapName() + ": " + mapRule.getString("scriptName"));
					Map mapPropMaps = mapRule.getMap("PropertyMap");
					
					for (int jj = 0; jj < mapPropMaps.length(); jj++)
					{ 
						Map mapPropTypes = mapPropMaps.getMap(jj);
						
						for (int x = 0; x < mapPropTypes.length(); x++)
						{ 
							Map m = mapPropTypes.getMap(x);
							
							String format = "   @(strName)	";// "   @(strName:PR20; )";

							String text = "	";
							if (m.getMapKey().find("Int",-1)>-1)
								format += m.getInt("IValue");
							else if (m.getMapKey().find("Double",-1)>-1)
								format += m.getDouble("dValue");
							else if (m.getMapKey().find("String",-1)>-1)
							{ 
								String s = m.getString("strValue");
								if (s.find("Name",0,false)>-1 && s.find("Type",0,false)>-1 && s.find("Filter",0,false)>-1 && s.find("Format",0,false)>-1)
									continue;
								
								format += s;
							}
							//format += "   @(strDesc)";
							
							reportNotice("\n   "+_ThisInst.formatObject(format,m));
						}
					}
				}
			}	
		}

		
		setExecutionLoops(2);
		return;
	}//endregion	

}
//End Trigger//endregion 

//region Purge any instance not returning any nailing
	if (bDebug)
	{ 
		Display dp(-1);
		dp.textHeight(U(80));
		dp.draw(scriptName() + "\\PZone: " + nZone + "\\PNaillines: " + segNails.length(), _Pt0, _XW, _YW, 1, 0, _kDeviceX);
	}
	else if (segNails.length()<1 || bExplode)
	{ 
		eraseInstance();
		return;
	}
	
//End Purge any instance not returning any nailing//endregion 






#End
#BeginThumbnail
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
M?^ILN?+NJ8RTJYBM)?;2V?K+L\J^1$38_D5#EE1#O\9N:R_I)Z7%0[6HFQ["
M!(\EU;#Z6Y,9QQHW(\AI3;B.>IMQ"D*(E$9%S^ZFW'L=-\90MB]J:T:\J9;Z
M[*[H*RJ2E6]S3U3\YV$N'$GL*C3HL:;&6:37'EL-2&%&A1*0:FGDK;4:5$1E
MR7@8R8N7EX-RR<*VRG(6NDH2<)+5:/246FM5L>W:C%DXN+FTO'S*Z[:'IK&<
M5*+TVK5236Q[5L/NA"&T);;2E"$)2A"$))*$(21$E*4D1$E*2+@B+P(A@E*4
MY.<VW-O5M[6V][;[6S-&,814()*"6B2V));DEV)'Z'R?0````````?Q24K2I
M"TI6A:32M"B)25)47"DJ2?)*2HCX,C]T>QE*,E*+:DGJFMZ9XTI)QDM8LCW4
M]55U.M\'9JJV!6,OXEB\E]JOAQX3;TD\>JV#D.HC-MI<?-AAM'69&KH0DN>"
M(7'X@\RYCS/K3F=W,K[LBV&?D0C*V<K'&$;[.&"<FVHK5Z16Q:O1;2J]#X&#
MR_I+EU6!3515/"HG)5PC!2FZ:]9-123D]%K)[7HM7L+<Z<^37WP\#XN4*K1N
M99K.PF@9S$8A8>M[M;]H2H^SC9@M/1_OJ/X<_H('J3W8_OQ-OXZT<\``````
M````````````````````````````````````````````````````"C._>PS5
MVW+6XV!@<^5HO=-LLI5AL/":V+)ILRGMI(FE;:UT\]"QO9#:D))I<U:H.1-1
M^6HEM$29\QG,N3\OYM7P9E:<DMDELE'R2^IZKO1O87,LSE\^/&FTNV+VQ?E7
MUK1^)JOV7CFU>W6:W7=QF)1,9I'I+4*IW;B3\RYT;D+S[RH\)JSR"4PQ::HO
MYZO*+YMR9J+$7*D(B5MG;.)6L<OYQT?S#E^MV)K?B+N7IQ7C'M\L=>]I(O7+
M>H\3,TKR-*LCQ]5^1]GD>G<FS[D9*(E),E)41&E1&1D9&7)&1EX&1D*@6,_H
M```````````PO6_J[P+]2\6_(<$67K/_`##FW]RROY\RO])_XKRS^WX_\F!:
MK3GR:^^'@?%RA!4;F3=G830,YB,0L/6]VM^T)4?9QLP6GH_WU'\.?T$#U)[L
M?WXFW\=:.>``````````````````````````````````````````````````
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
M````````````````````````````````````````````````````````````
I``````````````````````````````````````````````````!__]D`








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
      <str nm="Comment" vl=" HSB-13560 new context commands to remove a rule from a configuration and to show all rules in report dialog" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="12/8/2021 12:50:57 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11012 initial version, grid naillines added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="4/29/2021 5:12:58 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End