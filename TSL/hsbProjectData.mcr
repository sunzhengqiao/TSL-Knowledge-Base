#Version 8
#BeginDescription

/// Version 1.1    th@hsbCAD.de  19.08.2011
/// configuration path modified
/// beta bugfixes

/// <summary Lang=en>
/// This TSL sets extended user defined project data and displays it in the drawing
/// </summary>

/// <summary Lang=en>
/// Dieses TSL schreibt, verwaltet und stellt erweiterte Projektdaten in der Zeichnung dar.
/// </summary>








#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This TSL sets extended user defined project data and displays it in the drawing
/// </summary>

/// <summary Lang=en>
/// Dieses TSL schreibt, verwaltet und stellt erweiterte Projektdaten in der Zeichnung dar.
/// </summary>


/// <insert=en>
/// Select entries in dialog and pick insertion point
/// </insert>

/// <remark=de>
/// Erfordert <hsbCAD>\Custom\hsbProjectData.dll
/// </remark>

/// <remark=en>
/// Requires <hsbCAD>\Custom\hsbProjectData.dll
/// </remark>

/// History
/// Version 1.1    th@hsbCAD.de  19.08.2011
/// configuration path modified
/// beta bugfixes
/// Version 1.0    th@hsbCAD.de  18.08.2011
/// initial



//basics and props
	Unit(1,"mm"); // script uses mm
	double dEps=U(.1);
	int bOnDebug=false;
// 
	String sDictionary = "ITWDEDICT";
	String sEntry= "hsbProjectData";
	String sConfigPath = _kPathHsbCompany + "\\TSL\\CATALOG\\hsbProjectDataConfig.xml";

	String strAssemblyPath = _kPathHsbInstall + "\\Custom\\hsbProjectData.dll";
	String strType = "hsbSoft.Tsl.projectData.ProjectData";
	String strFunction = "RunFromTsl";


// set array of property values from MO
	MapObject mo(sDictionary ,sEntry); // will lookup automatically 
	String sArNames[0];
	Map mapEntries;
	if (mo.bIsValid())
	{
		mapEntries= mo.map().getMap("Entry[]");
 		for (int i=0;i<mapEntries.length();i++)
		{
			Map mapEntry = mapEntries.getMap(i);
			sArNames.append(mapEntry.getString("Label"));	
		}
	} 
	
	PropString sName(0,sArNames, T("|Field Name|"),0);

	String sArHAlign[] = {T("|Left|"),T("|Center|"),T("|Right|")};
	String sArVAlign[] = {T("|Bottom|"),T("|Center|"),T("|Top|")};	

	PropDouble dTxtH(0,U(20),T("|Text Height|"));	
	PropString sHAlign(2,sArHAlign,T("|Horizontal|"),1);
	PropString sVAlign(3,sArVAlign,T("|Vertical|"),1);
	PropString sDimStyle(1,_DimStyles,T("|Dimstyle|"));	
	PropInt nColor(0, 3, T("|Color|"));	


// declare the tsl props
	TslInst tslNew;
	Vector3d vUcsX = _XU;
	Vector3d vUcsY = _YU;
	GenBeam gbAr[0];
	Entity entAr[0];
	Point3d ptAr[0];
	int nArProps[0];
	double dArProps[0];
	String sArProps[0];
	Map mapTsl;
	String sScriptname = scriptName();
	
// on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		
	// show the dialog if no catalog in use
		if (_kExecuteKey == "" )
		{
			setPropValuesFromCatalog(T("|_LastInserted|"));		
		}
	// set properties from catalog		
		else	
			setPropValuesFromCatalog(_kExecuteKey);	
		
		
		String sArEntries[] = MapObject().getAllEntryNames(sDictionary);
		if (bOnDebug)reportNotice("\nMO entries:" + sArEntries + "\nMapEntries: " + mapEntries);

	// the maps for the dialog
		Map mapDialog;


	// if the hsbProjectData entry and the configuration file in company is not present preset a default
		if (findFile(sConfigPath)=="" && sArEntries.find(sEntry)<0)
		{
			if (bOnDebug)reportNotice("\nthe hsbProjectData entry and the configuration file in company is not present preset a default");
			Map mapEntry;
			mapEntry.setString("Value", projectName());
			mapEntry.setString("Label", T("|Project Name|"));	
			mapEntry.setString("Group", T("|Project Data|"));	
			mapEntries.appendMap("Entry",mapEntry);
	
			mapEntry.setString("Value", projectNumber());
			mapEntry.setString("Label", T("|Project Number|"));	
			mapEntry.setString("Group", T("|Project Data|"));	
			mapEntries.appendMap("Entry",mapEntry);
	
			mapEntry.setString("Value", projectCity());
			mapEntry.setString("Label", T("|City|"));	
			mapEntry.setString("Group", T("|Project Data|"));	
			mapEntries.appendMap("Entry",mapEntry);
			
			mapEntry.setString("Value", projectComment());
			mapEntry.setString("Label", T("|Comment|"));	
			mapEntry.setString("Group", T("|Project Data|"));	
			mapEntries.appendMap("Entry",mapEntry);						
			
			mapEntry.setString("Value", projectUser());
			mapEntry.setString("Label", T("|User|"));	
			mapEntry.setString("Group", T("|Project Data|"));	
			mapEntries.appendMap("Entry",mapEntry);
			
			mapEntry.setString("Value", projectRevision());
			mapEntry.setString("Label", T("|Revision|"));	
			mapEntry.setString("Group", T("|Project Data|"));	
			mapEntries.appendMap("Entry",mapEntry);
	
			mapEntry.setString("Value", projectSpecial());
			mapEntry.setString("Label", T("|Special|"));	
			mapEntry.setString("Group", T("|Project Data|"));	
			mapEntries.appendMap("Entry",mapEntry);
			
			MapObject mo(sDictionary ,sEntry); // will lookup automatically 
			if (!mo.bIsValid()) { // if object is found, bIsValid is TRUE
			// add the properties to a map, and the map to the MapObject
				Map map;
				map.setMap("Entry[]",mapEntries);
				mo.dbCreate(map); // make sure the dictionary and entry name are set in the constructor before calling dbCreate
				//bDataBaseChanged = TRUE;
			}
			else {
			// The style already exists.
				reportNotice("\n" + T("|Unable to create new MapObject in dictionary because it already exists.|") + " " +mo.entryName()+" / " +mo.dictionaryName());
			}
			if (!mo.bIsValid()) {
			// should not happen.
				reportNotice("\nSomething is wrong with MapObject name "+mo.entryName()+" for dictionary " +mo.dictionaryName());
			}
			
		// set data of mapDialog
			mapDialog.setMap("Entry[]", mapEntries);		
		}

	// configuration found but no MO set yet
		else if (findFile(sConfigPath)!="" && !mo.bIsValid())
		{
		// read default hsbProject data			
			mapDialog.readFromXmlFile(sConfigPath);
			Map mapEntries = mapDialog.getMap("Entry[]");
			if (bOnDebug)reportNotice("\nconfiguration found but no MO set yet" + mapEntries);
			
			

			
			Map mapUpdatedEntries;
			for (int i=0;i<mapEntries.length();i++)
			{
				Map mapEntry = mapEntries.getMap(i);
				String sLabel = mapEntry.getString("Label");
				if (sLabel == T("|Project Name|"))
					mapEntry.setString("Value", projectName());	
				else if (sLabel  == T("|Project Number|"))
					mapEntry.setString("Value", projectNumber());
				else if (sLabel == T("|City|"))
					mapEntry.setString("Value", projectCity());					
				else if (sLabel  == T("|Comment|"))
					mapEntry.setString("Value", projectComment());
				else if (sLabel  == T("|User|"))
					mapEntry.setString("Value", projectUser());
				else if (sLabel  == T("|Revision|"))
					mapEntry.setString("Value", projectRevision());
				else if (sLabel  == T("|Special|"))
					mapEntry.setString("Value", projectSpecial());
				mapUpdatedEntries.appendMap("Entry",mapEntry);
			}
			mapEntries=mapUpdatedEntries;
			mapDialog.setMap("Entry[]",mapEntries);
			
		}
	// the MO is valid and entriues are found
		else if (findFile(sConfigPath)=="" && sArEntries.find(sEntry)>-1 && mapEntries.length()>0)
		{
			if (bOnDebug)reportNotice("\nthe MO is valid and entriues are found");
			mapDialog.setMap("Entry[]", mapEntries);
		}
		
	// the MO is valid
		else if (mo.bIsValid())
		{
			if (bOnDebug)reportNotice("\nthe MO is valid");
			mapDialog.setMap("Entry[]", mapEntries);
		}			

	// update standard hsbCAD Project settings
		for (int i=0;i<mapEntries.length();i++)
		{
			Map mapEntry = mapEntries.getMap(i);
			String sLabel = mapEntry.getString("Label");
			String sValue = mapEntry.getString("Value");
			if (sLabel == T("|Project Name|"))			{setProjectName(sValue);}	
			else if (sLabel == T("|Project Name|"))	{setProjectNumber(sValue);}
			else if (sLabel == T("|City|"))				{setProjectCity(sValue);}
			else if (sLabel == T("|Comment|"))			{setProjectComment(sValue);}
			else if (sLabel == T("|User|"))				{setProjectUser(sValue);}
			else if (sLabel == T("|Revision|"))			{setProjectRevision(sValue);}
			else if (sLabel == T("|Special|"))			{setProjectSpecial(sValue);}
		}

		
	// add some general property values to the mapDialog
		Map mapDim;
		for (int i=0;i<_DimStyles.length();i++)
			mapDim.appendString("DimStyle",_DimStyles[i]);			
		mapDialog.setMap("DimStyle[]", mapDim);
		Map mapHAlign;
		for (int i=0;i<sArHAlign.length();i++)
			mapHAlign.appendString("HAlign",sArHAlign[i]);			
		mapDialog.setMap("HAlign[]", mapHAlign);		
		Map mapVAlign;
		for (int i=0;i<sArVAlign.length();i++)
			mapVAlign.appendString("VAlign",sArVAlign[i]);			
		mapDialog.setMap("VAlign[]", mapVAlign);			
		Map mapProperties;
		mapProperties.setInt("Color", nColor);
		mapProperties.setDouble("TxtH", dTxtH);
		mapProperties.setString("HAlign", sHAlign);
		mapProperties.setString("VAlign", sVAlign);	
		mapProperties.setString("DimStyle", sDimStyle);				
		mapDialog.setMap("Property[]", mapProperties);
		
		mapDialog.setString("configPath",sConfigPath);
		//mapDialog.writeToXmlFile("c:\\temp\\aDialog.xml");
		
		if (bOnDebug)reportNotice("\nbefore dialog call: " + mapDialog);
		Map mapOut = callDotNetFunction2(strAssemblyPath, strType, strFunction, mapDialog);

	// erase Instance if cancel has been pressed
		if (mapOut.getInt("DialogResult")==0)
		{
			eraseInstance();
			return;	
		}
		//mapOut.readFromXmlFile("c:\\temp\\aaprojektdaten.xml");
		
	// write a new MO from the returned map	
		if (!mo.bIsValid() && mapOut.getMap("Entry[]").length()>0)
		{
				mapEntries = mapOut.getMap("Entry[]");
			// add the properties to a map, and the map to the MapObject
				Map map;
				map.setMap("Entry[]",mapEntries);
				mo.dbCreate(map); // make sure the dictionary and entry name are set in the constructor before calling dbCreate
				reportMessage("\n" + T("|Dictionary|") + " " + sDictionary + "/" + sEntry + " " + T("|created from mapOut|"));
	
		}
		
	// update the MO
		else if (mo.bIsValid() && mapOut.hasMap("Entry[]"))
		{
			Map map= mo.map();
			Map mapNewEntries = mapOut.getMap("Entry[]");
			
		// loop for matching entry, replace value if applicable
			Map mapUpdatedEntries, mapAdditionalEntries;
			
			// updtae existing
			for (int i=0;i<mapEntries.length();i++)
			{
				Map mapEntry= mapEntries.getMap(i);
				String sLabel = mapEntry.getString("Label");
				for (int j=0;j<mapNewEntries.length();j++)
				{
					Map mapNewEntry= mapNewEntries.getMap(j);
					if (mapNewEntry.getString("Label") == sLabel)
					{
						mapEntry.setString("Value", mapNewEntry.getString("Value"));
						mapEntry.setInt("Visible", mapNewEntry.getInt("Visible"));
						break;
					}
				}	
				mapUpdatedEntries.appendMap("Entry", mapEntry);	
			}

			// add additional
			for (int i=0;i<mapNewEntries.length();i++)
			{
				int bFound;
				Map mapNewEntry= mapNewEntries.getMap(i);
				String sLabel = mapNewEntry.getString("Label");
				for (int j=0;j<mapEntries.length();j++)
				{
					Map mapEntry= mapEntries.getMap(j);
					if (mapEntry.getString("Label") == sLabel)
					{
						bFound=true;
						break;
					}
				}
				if (!bFound)	
					mapAdditionalEntries.appendMap("Entry", mapNewEntry);	
			}	
			for (int i=0;i<mapAdditionalEntries.length();i++)	
				mapUpdatedEntries.appendMap("Entry", mapAdditionalEntries.getMap(i));
			mapEntries=mapUpdatedEntries;	
			
			map.setMap("Entry[]",mapEntries);
			mo.setMap(map);
			reportMessage("\n" + T("|Dictionary|") + " " + sDictionary + "/" + sEntry + " " + T("|has been updated with|") + " " + mapEntries.length() + " " + T("|Entries|"));
		// erase the instance if not in insert mode	
			if (mapOut.getInt("eraseInstance")==true)
			{ 
				eraseInstance();
				return;
			}
		}	

	// set properties from mapOut
		if (mapOut.hasMap("Property[]"))
		{
			Map map = mapOut.getMap("Property[]");
			nColor.set(map.getInt("Color"));
			double d = map.getDouble("TxtH");
			if (d>0) dTxtH.set(d);
			String s = map.getString("Dimstyle"); 
			if (_DimStyles.find(s)>-1) sDimStyle.set(s);
			s = map.getString("HAlign");
			if (sArHAlign.find(s)>-1) sHAlign.set(s);
			s = map.getString("VAlign");
			if (sArVAlign.find(s)>-1) sVAlign.set(s);			
		}
	// get the insertion point for insert mode	
		Point3d ptRef = getPoint();
		nArProps.append(nColor);

		//mapOut.writeToXmlFile("c:\\temp\\aOut.xml");		
		//mapEntries.writeToXmlFile("c:\\temp\\aOutEntries.xml");	
	// for all entries being selected create an instance
		for (int i=0;i<mapEntries.length();i++)	
		{
			Map mapEntry = mapEntries.getMap(i);
			int bSelected = mapEntry.getInt("Visible");
			//reportNotice("\n" + mapEntry.getString("Label") + " is selected: " + bSelected );
			if (bSelected)
			{
				sArProps.setLength(0);
				
				sArProps.append(mapEntry.getString("Label"));
				sArProps.append(sDimStyle);
				sArProps.append(sHAlign);
				sArProps.append(sVAlign);

				ptAr.setLength(0);
				ptAr.append(ptRef);
				
				
				tslNew.dbCreate(sScriptname, vUcsX,vUcsY,gbAr, entAr, ptAr, 
					nArProps, dArProps, sArProps,_kAllSpaces, mapTsl); // create new instance		
				
				ptRef.transformBy(-_YU*dTxtH*1.5);
				
			}	
		}
	// set catalog
		setCatalogFromPropValues(T("|_LastInserted|"));	

		eraseInstance();
		return;		
	}	
// end on insert		

// update properties if not set
	if ((sName=="" || sArNames.find(sName)<0) && sArNames.length()>0)sName.set(sArNames[0]);

// set dependency
	setDependencyOnDictObject(mo);

	
// Display
	Display dp(nColor);	
	dp.dimStyle(sDimStyle);
	dp.textHeight(dTxtH);

// alignment flags
	double dXFlag = sArHAlign.find(sHAlign)-1;
	double dYFlag = sArVAlign.find(sVAlign)-1;
	
// text to display
	String sTxt = "---";
	if (!mo.bIsValid()) sTxt="???";
	
// get value of selected field
	int nName = sArNames.find(sName);
	Map mapEntry = mapEntries.getMap(nName);
	String sValue = mapEntry.getString("Value");
	if (sValue!="") sTxt = sValue;

// draw
	dp.draw(sTxt,_Pt0,_XU,_YU,dXFlag,dYFlag);		
	
	
	
	
	

		










#End
#BeginThumbnail
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
7)&H4?I45JU2-DW]W]?Y%TZ<'JOQ/_]G6
`



#End
