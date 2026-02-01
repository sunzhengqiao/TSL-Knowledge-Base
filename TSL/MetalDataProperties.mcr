#Version 8
#BeginDescription
This tsl assigns material properties to collection entities and/or collection definitions
Data is predefined in <company\\TSL\\settings\\MetalDataProperties.xml (must be present)
It attaches the following data to metalpart collection definition
   MetalStyleData_MATERIAL  
   MetalStyleData_GRADE
   MetalStyleData_FINISH
   MetalStyleData_DENSITY
   MetalStyleData_NAME
   MetalStyleData_WEIGHT [kg]

   It attaches the following data to metalpart collection entities
    MetalEntityData.NAME
    MetalEntityData.MOUNTING
    MetalEntityData.EXC
    MetalEntityData.INFORMATION

#Versions
Version 1.5 03.06.2025 HSB-24124 Fasteners are excluded from weight calculation
Version 1.4 30.05.2023 HSB-19082 style data also written when changing entities. info to command line added
Version 1.3 21.02.2023 HSB-17970  bugfix volume calculation on complex solids
Version 1.2 21.02.2023 HSB-17970 weight calculation fixed, requires hsbDesign 25.1.65 or higher
Version 1.1 15.02.2023 HSB-17970 weight calculation fixed, volume added to style data
Version 1.0 15.12.2022 HSB-17353 initial version to specify metalpart style and/or entity property data





#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 5
#KeyWords 
#BeginContents
//region <History>
// #Versions
// 1.5 03.06.2025 HSB-24124 Fasteners are excluded from weight calculation , Author Thorsten Huck
// 1.4 30.05.2023 HSB-19082 style data also written when changing entities. info to command line added , Author Thorsten Huck
// 1.3 21.02.2023 HSB-17970  bugfix volume calculation on complex solids  , Author Thorsten Huck
// 1.2 21.02.2023 HSB-17970 weight calculation fixed, requires hsbDesign 25.1.65 or higher , Author Thorsten Huck
// 1.1 15.02.2023 HSB-17970 weight calculation fixed, volume added to style data , Author Thorsten Huck
// 1.0 15.12.2022 HSB-17353 initial version to specify metalpart style and/or entity property data , Author Thorsten Huck

/// <insert Lang=en>
/// Select metalpart collection entities to specify data by entity or press enter to specify by style
/// </insert>

// <summary Lang=en>
// This tsl assigns material properties to collection entities and/or collection definitions
// Data is predefined in <company\\TSL\\settings\\MetalDataProperties.xml (must be present)
// It attaches the following data to metalpart collection definition
//	MetalStyleData_MATERIAL		
//	MetalStyleData_GRADE
//	MetalStyleData_FINISH
//	MetalStyleData_DENSITY
//	MetalStyleData_NAME
//	MetalStyleData_WEIGHT [kg]
//
// It attaches the following data to metalpart collection entities
// 	MetalEntityData.NAME
// 	MetalEntityData.MOUNTING
//	MetalEntityData.EXC
//	MetalEntityData.INFORMATION

// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "MetalDataProperties")) TSLCONTENT
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
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	
	String kEntityKey = "MetalEntityData", kStyleKey = "MetalStyleData";
	String kMaterialName = "Name", kGrade = "Grade", kFinish = "Finish", kExc = "EXC", kMounting = "Mounting", kInformation = "Information";
	String tVaries = T("<|Varies|>");
	
	
	int bLogger;//=true;
//end Constants//endregion

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="MetalDataProperties";
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




//region Properties
	String sMaterials[0];

// Materials	
	Map mapMaterials = mapSetting.getMap("Material[]");
	for (int i=0;i<mapMaterials.length();i++) 
	{ 
		Map m = mapMaterials.getMap(i);
		
		String name = m.getMapName();
		if (sMaterials.findNoCase(name,-1)<0)
			sMaterials.append(name);
	}//next i
	if (sMaterials.length()<1 ||mapMaterials.length()<1)
	{ 
		reportNotice("\n***************** " + scriptName() + "*****************\n\n"+T("|This tool requires material definitions defined in| \n") +
			sFullPath + TN("|Please contact your local support.|") +"\n\n***********************************************************");
		eraseInstance();
		return;
	}

// ExecutionClasses
	String sExcTypes[] = { "EXC1", "EXC2", "EXC3"};
	Map mapExcs = mapSetting.getMap("ExecutionClass[]");
	if (mapExcs.length()>0)
	{ 
		String ss[0];
		for (int i=0;i<mapExcs.length();i++) 
		{ 
			String s = mapExcs.getString(i);
			if (ss.findNoCase(s,-1)<0)
				ss.append(s); 	 
		}//next i
		if (ss.length()>0)
			sExcTypes = ss;
	}

// Mountings
	String sMountingTypes[] = { T("|Factory|"), T("|On Site|")};
	Map mapMountings = mapSetting.getMap("Mounting[]");
	if (mapMountings.length()>0)
	{ 
		String ss[0];
		for (int i=0;i<mapMountings.length();i++) 
		{ 
			String s = mapMountings.getString(i);
			if (ss.findNoCase(s,-1)<0)
				ss.append(s); 	 
		}//next i
		if (ss.length()>0)
			sMountingTypes = ss;
	}

	String sMaterialName=T("|Material|");	
	PropString sMaterial(nStringIndex++,sMaterials , sMaterialName);	
	sMaterial.setDescription(T("|Defines the Material|"));
	sMaterial.setCategory(category);

	
	sExcTypes.append(tVaries);
	String sExcTypeName=T("|Execution Class|");	
	PropString sExcType(nStringIndex++, sExcTypes, sExcTypeName);	
	sExcType.setDescription(T("|Defines the Execution Class|"));
	sExcType.setCategory(category);
	
	sMountingTypes.append(tVaries);
	String sMountingName=T("|Mounting|");	
	PropString sMounting(nStringIndex++, sMountingTypes, sMountingName);	
	sMounting.setDescription(T("|Defines the Mounting|"));
	sMounting.setCategory(category);
	
	String sInformationName=T("|Information|");	
	PropString sInformation(nStringIndex++, "", sInformationName);	
	sInformation.setDescription(T("|Defines the Information|"));
	sInformation.setCategory(category);

	String sEntries[] = MetalPartCollectionDef().getAllEntryNames().sorted(); 
	String sStyleName=T("|Style|");	
	PropString sStyle(nStringIndex++, sEntries, sStyleName);	
	sStyle.setDescription(T("|Defines the Style|"));
	sStyle.setCategory(category);


//End Properties//endregion 



	//bDebug = true;

//region OnInsert #1
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }

	// prompt for entities
		PrEntity ssE(T("|Select metalparts|") + T(", |<Enter> to specify by style|"), MetalPartCollectionEnt());
		if (ssE.go())
			_Entity.append(ssE.set());
			
		if (bDebug)
			_Pt0 = getPoint();
	}			
//endregion OnInsert #1			
	
//region Get references
	MetalPartCollectionEnt ces[0];
	String sEntMaterials[0], sExcs[0], sInformations[0], sMountings[0];
	for (int i=0;i<_Entity.length();i++) 
	{ 
		MetalPartCollectionEnt ce = (MetalPartCollectionEnt)_Entity[i]; 
		if (ce.bIsValid())
		{ 
			ces.append(ce);			
			Map m = ce.subMapX(kEntityKey);
			
			MetalPartCollectionDef cd(ce.definition());
			Map mapCD=cd.subMapX(kStyleKey);
			
			if (bLogger)
			{ 
				reportNotice("\nReading " + ce.handle() + " " +ce.definition());//" mapCD:" + mapCD);
				for (int j=0;j<m.length();j++) 
					reportNotice("\n	"+m.keyAt(j)+"	-	" + (m.hasDouble(j)?m.getDouble(j):m.getString(j))); 
			}
 

			sEntMaterials.append(mapCD.getString(kMaterialName));
			sExcs.append(m.getString(kExc));
			sMountings.append(m.getString(kMounting));
			sInformations.append(m.getString(kInformation));
		}
		 
	}//next i
//	
//	
//	
//	
//	
//	if (ces.length()<1)
//	{ 
//		eraseInstance();
//		return;
//	}


// Get variies state
	int bVaries[4];
	for (int v=0;v<bVaries.length();v++) 
	{ 
		int varies;
		for (int i=0;i<ces.length();i++) 
		{ 
			for (int j=i+1;j<ces.length();j++) 
			{ 
				if (v == 0 && sEntMaterials[i] != sEntMaterials[j])varies = true;
				else if (v == 1 && sExcs[i] != sExcs[j])varies = true;
				else if (v == 2 && sMountings[i] != sMountings[j])varies = true;
				else if (v == 3 && sInformations[i] != sInformations[j])varies = true;
				
				if (varies)break;
			}//next i	
			if (varies)break;
		}//next i
		bVaries[v]=varies; 		 
	}//next v
	
//	if (bLogger)
//		reportNotice("\nProperties vary: " + bVaries);
//endregion 	
	
//region OnInsert #2 entities selected
	int bEntityMode = ces.length()>0;
	String sStyleNames[0];
	if(_bOnInsert && bEntityMode)
	{ 
		sStyle.setReadOnly(_kHidden);
		sMaterials.append(tVaries);
		sMaterial=PropString (0,sMaterials , sMaterialName);
	// silent/dialog
		if (_kExecuteKey.length()>0 && TslInst().getListOfCatalogNames(scriptName()).findNoCase(_kExecuteKey,-1)>-1)
			setPropValuesFromCatalog(_kExecuteKey);						
	// standard dialog	
		else	
		{
		// override as varies
			for (int i=0;i<bVaries.length();i++) 
			{ 			
				int b = bVaries[i];
				if (i == 0)sMaterial.set(b?tVaries:sEntMaterials.first());
				else if (i == 1)sExcType.set(b?tVaries:sExcs.first());
				else if (i == 2)sMounting.set(b?tVaries:sMountings.first());
				else if (i == 3)sInformation.set(b?tVaries:sInformations.first());
			}//next i			
			
			setCatalogFromPropValues("xDummy");
			showDialog("xDummy");
		}
	}		

	else if(_bOnInsert && !bEntityMode)
	{ 
		sExcType.setReadOnly(_kHidden);
		sMounting.setReadOnly(_kHidden);
		sInformation.setReadOnly(_kHidden);
		
	// silent/dialog
		if (_kExecuteKey.length()>0 && TslInst().getListOfCatalogNames(scriptName()).findNoCase(_kExecuteKey,-1)>-1)
			setPropValuesFromCatalog(_kExecuteKey);						
	// standard dialog	
		else	
			showDialog();
	
//		//remove all
//		MetalPartCollectionDef cd(sStyle);
//		String keys[] = cd.subMapXKeys();
//		for (int i=0;i<keys.length();i++) 
//			cd.removeSubMapX(keys[i]); 


	
	}
	if (!bEntityMode)sStyleNames.append(sStyle);
	if (bLogger)reportNotice("\nStyleNames: " + sStyleNames);
//endregion OnInsert #2

//region Write submapX by Entity
// keep original value if property varies
	for (int i=0;i<ces.length();i++) 
	{ 
		MetalPartCollectionEnt ce = ces[i]; 
		String styleName = ce.definition();
		MetalPartCollectionDef cd(styleName);
		Map mapCD=cd.subMapX(kStyleKey);
		
		Map m = ce.subMapX(kEntityKey);
		
		if (sMaterial!=tVaries)
		{
			m.setString(kMaterialName,sMaterial);			
			
			if (mapCD.getString(kMaterialName)!=sMaterial && sStyleNames.findNoCase(ce.definition(),-1)<0)
			{ 
				sStyleNames.append(ce.definition());
				if (bLogger)reportNotice("\nWrite CD subMapX..." + ce.definition());	
			}
		}

		if (sExcType!=tVaries)
			m.setString(kExc,sExcType);
		if (sMounting!=tVaries)
			m.setString(kMounting,sMounting);
		if (sInformation!=tVaries)
			m.setString(kInformation,sInformation);	
					
	// rewrite weight		
		{ 
		// get material data
			Map map;
			for (int i=0;i<mapMaterials.length();i++) 
			{ 
				Map m2 = mapMaterials.getMap(i);
				String name = m2.getMapName();
				if (name==sMaterial)
				{ 
					map = m2;
					map.setString("Name", name);
					break;
				}	 
			}//next i
	
		// calculate the weight
			Body bd;

//		// HSB-17970 from definition
			{ 
				GenBeam gbs[] = cd.genBeam();
				Entity ents[] = cd.entity();
				for (int i=0;i<gbs.length();i++) 
				{
					
					if (!gbs[i].bIsDummy())
						bd.combine(gbs[i].realBody()); 
//					else if (bLogger)
//						reportNotice("\nrefusing "+gbs[i].bIsDummy() + " " + gbs[i].handle() + " " + gbs[i].color() + " " + gbs[i].solidLength());	
				}
						
				
				for (int i=0;i<ents.length();i++) 
				{ 
					if (gbs.find(ents[i])>-1){ continue;}

					// HSB-24124
					if (ents[i].bIsKindOf(FastenerAssemblyEnt())){ continue;}

					Body b = ents[i].realBody();
					if (!b.isNull())
					{
						bd.combine(b);		
//						if (bLogger)
//							reportNotice("\nadding volume "+b.volume()+ " " + ents[i].typeDxfName() + " " + ents[i].handle());	
					}
//					else if (bLogger)
//						reportNotice("\nrefusing "+ ents[i].typeDxfName() + " " + ents[i].handle());	
						
				}//next i				
			}	

			double dVol = bd.volume() / 10e8;
			mapCD.setDouble("Volume", dVol);
			double density = mapCD.getDouble("Density");
			if (density>0)
				mapCD.setDouble("Weight", dVol * density);
			cd.setSubMapX("MetalStyleData", mapCD);
			if (bLogger)
			{
				String text = "\nStyle updated " + styleName;
				for (int j=0;j<mapCD.length();j++) 
					text+="\n" + mapCD.keyAt(j) +"	-	"+ (mapCD.hasDouble(j)?mapCD.getDouble(j):mapCD.getString(j)); 
				reportNotice(text + "\n");
			}


		}	
	
			
		ce.setSubMapX(kEntityKey,m);	
		
	//region prompt user of changes being applied
		{ 
			String text = "\n" + scriptName() + T(" |has written data against the entity| ") + ce.handle() + " " + ce.definition();
			for (int j=0;j<m.length();j++) 
				text+="\n	" + m.keyAt(j)+ ": "+ (m.hasDouble(j)?m.getDouble(j):m.getString(j)); 			
			
			m = mapCD;
			text += TN("|The style has been updated with the following entries| ");			
			for (int j=0;j<m.length();j++) 
				text+="\n	" + m.keyAt(j)+ ": "+ (m.hasDouble(j)?m.getDouble(j):m.getString(j)); 
			
			reportMessage(text);				
		}		
	//endregion  
			



	}//next i
	
//endregion 

//region Write Submap by Style
	for (int j=0;j<sStyleNames.length();j++) 
	{ 
		String styleName = sStyleNames[j];
		if (bLogger)
			reportNotice("\nwriting data for style " + styleName);
		
		
		
	// get material data
		Map map;
		for (int i=0;i<mapMaterials.length();i++) 
		{ 
			Map m = mapMaterials.getMap(i);
			String name = m.getMapName();
			if (name==sMaterial)
			{ 
				map = m;
				map.setString("Name", name);
				break;
			}	 
		}//next i
	
		if (map.length()>0 && sEntries.findNoCase(styleName,-1)>-1)
		{
			MetalPartCollectionDef cd(styleName);
			Entity ents[] = Group().collectEntities(true, MetalPartCollectionEnt(), _kModelSpace);
			for (int i=ents.length()-1; i>=0 ; i--) 
			{ 
				MetalPartCollectionEnt ce= (MetalPartCollectionEnt)ents[i]; 
				if (!ce.bIsValid() || ce.definition()!=styleName)
					ents.removeAt(i);
			}//next i
			
		// calculate the weight
			Body bd;

//		// HSB-17970 from definition
			{ 
				GenBeam gbs[] = cd.genBeam();
				Entity ents[] = cd.entity();
				for (int i=0;i<gbs.length();i++) 
				{
					
					if (!gbs[i].bIsDummy())
						bd.combine(gbs[i].realBody()); 
//					else if (bLogger)
//						reportNotice("\nrefusing "+gbs[i].bIsDummy() + " " + gbs[i].handle() + " " + gbs[i].color() + " " + gbs[i].solidLength());	
				}
						
				
				for (int i=0;i<ents.length();i++) 
				{ 
					if (gbs.find(ents[i])>-1){ continue;}

					// HSB-24124
					if (ents[i].bIsKindOf(FastenerAssemblyEnt())){ continue;}

					Body b = ents[i].realBody();
					if (!b.isNull())
					{
						bd.combine(b);		
//						if (bLogger)
//							reportNotice("\nadding volume "+b.volume()+ " " + ents[i].typeDxfName() + " " + ents[i].handle());	
					}
//					else if (bLogger)
//						reportNotice("\nrefusing "+ ents[i].typeDxfName() + " " + ents[i].handle());	
						
				}//next i				
			}
			
			double dVol = bd.volume() / 10e8;
			map.setDouble("Volume", dVol);
			double density = map.getDouble("Density");
			if (density>0)
				map.setDouble("Weight", dVol * density);
			cd.setSubMapX("MetalStyleData", map);
			if (bLogger)
			{
				String text = "\nstyle updated " + styleName;
				for (int j=0;j<map.length();j++) 
					text+="\n" + map.keyAt(j)+ "	-	"+ (map.hasDouble(j)?map.getDouble(j):map.getString(j)); 
				reportNotice(text);
			}


	//region prompt user of changes being applied
		{ 	
			Map m= map;
			String text = TN("|The style has been updated with the following entries| ");			
			for (int j=0;j<m.length();j++) 
				text+="\n	" + m.keyAt(j)+ ": "+ (m.hasDouble(j)?m.getDouble(j):m.getString(j));
				
			text += "\n" + ents.length() + T(" |entities related to this style have been updated.|");
				
			reportMessage(text);				
		}		
	//endregion 



		// update potential entities	
			for (int i=0;i<ents.length();i++) 
			{ 
				ents[i].transformBy(Vector3d(0,0,0)); 			 
			}//next i
			
			
			
			
		}

	}//next j
		
//endregion 




	if (!bDebug)
	{
		eraseInstance();
		return;
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
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="453" />
        <int nm="BreakPoint" vl="492" />
        <int nm="BreakPoint" vl="524" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24124 Fasteners are excluded from weight calculation" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="6/3/2025 3:51:24 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19082 style data also written when changing entities. info to command line added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="5/30/2023 3:22:25 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17970  bugfix volume calculation on complex solids " />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="2/21/2023 9:39:31 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17970 weight calculation fixed, requires hsbDesign 25.1.65 or higher" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="2/21/2023 9:07:35 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17970 weight calculation fixed, volume added to style data" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="2/15/2023 10:20:18 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17353 initial version to specify metalpart style and/or entity property data" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="12/15/2022 11:28:15 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End