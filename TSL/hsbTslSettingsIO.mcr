#Version 8
#BeginDescription
This tsl imports/exports custom settings

#Versions
Version 1.9 19.08.2021 HSB-12899 defaults from content general are read , Author Thorsten Huck


version value="1.8" date="17sept2019" author="thorsten.huck@hsbcad.com"
HSB-5627: supports import from <hsbcad>\content\general\tsl\settings if no custom version of the same name was found in company

HSB-5122 From now on the export of the settings will write an identifier into the xml file. If the file will be renamed this identifier is used to specify the entry name of the map object / the settings.
If a settings file is imported and has an identifier it will remember the custom file name to be used on future exports.

supports export of settings which are only stored in the dwg
reporting further enhanced 

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 9
#KeyWords Setting;mapObject;Properties
#BeginContents
/// <History>//region
// #Versions
// 1.9 19.08.2021 HSB-12899 defaults from content general are read , Author Thorsten Huck

/// <version value="1.8" date="17sept2019" author="thorsten.huck@hsbcad.com"> HSB-5627: supports import from <hsbcad>\content\general\tsl\settings if no custom version of the same name was found in company / the settings.If a settings file is imported and has an identifier it will remember the custom file name to be used on future exports. </version>
/// <version value="1.7" date="28may2019" author="thorsten.huck@hsbcad.com"> HSB-5122: From now on the export of the settings will write an identifier into the xml file. If the file will be renamed this identifier is used to specify the entry name of the map object / the settings.If a settings file is imported and has an identifier it will remember the custom file name to be used on future exports. </version>
/// <version value="1.6" date="10oct2018" author="thorsten.huck@hsbcad.com"> HSB-CAD 181: case insensitive search added for folder names </version>
/// <version value="1.4" date="26mar2018" author="thorsten.huck@hsbcad.com"> user messages enhanced, bugfix if only one settings file present </version>
/// <version value="1.4" date="26mar2018" author="thorsten.huck@hsbcad.com"> supports export of settings which are only stored in the dwg </version>
/// <version value="1.3" date="22mar2018" author="thorsten.huck@hsbcad.com"> reporting further enhanced </version>
/// <version value="1.2" date="22Aug2017" author="thorsten.huck@hsbcad.com"> reporting enhanced and erase mode added </version>
/// </History>

/// <insert Lang=en>
/// Select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl imports/exports custom settings
/// </summary>//endregion


// Commands
// command to create tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbTslSettingsIO")) TSLCONTENT

// Sample with existing catalog 'Stacking'
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbTslSettingsIO" "Stacking")) TSLCONTENT

// constants //region
	U(1,"mm");	
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

// settings prerequisites
	String sDictionary = "hsbTSL";
	String sFolder = "Settings";	String sFolderLower = sFolder;sFolderLower.makeLower(); // remove once find() has an option bCaseSensitive
	String sPath = _kPathHsbCompany+"\\TSL";


// find settings file
	String sFolders[]=getFoldersInFolder(sPath); 
	int bFolderFound=sFolders.findNoCase(sFolder,0)>-1;
//	// search case insensitive
//	if (!bFolderFound)
//		for (int i=0;i<sFolders.length();i++) 
//		{ 
//			String s = sFolders[i];
//			s.makeLower();
//			if (sFolderLower==s)
//			{ 
//				bFolderFound = true;
//				break;
//			}
//			 
//		}//next i
		
// collect files from company first		
	String sFiles[0];
	String sFullPaths[0];// HSB-12899 store full path to distinguish between company and content general locations
	if (bFolderFound)
		sFiles=getFilesInFolder(sPath+"\\"+sFolder, "*.xml");

	for (int i=0;i<sFiles.length();i++) 
		sFullPaths.append(sPath+"\\"+sFolder+"\\"+sFiles[i]); 


// append default settings files from content general
	{ 
		String _sFiles[0];
		_sFiles=getFilesInFolder(_kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder, "*.xml");	
		for (int i=0;i<_sFiles.length();i++) 
		{ 
			if (sFiles.findNoCase(_sFiles[i],-1)<0)
			{
				sFiles.append(_sFiles[i]);
				sFullPaths.append(_kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\"+_sFiles[i]); 
				//reportMessage("\n" + _sFiles[i] + " appended");
			}
		}	
	}

		
		
	int bOnlyExports[sFiles.length()]; // a flag whether a setting can be imported and exported

// trim extension
	for (int i=0;i<sFiles.length();i++) 
	{ 
		String sFile = sFiles[i];
		int n = sFile.find(".xml",0);
		if (n>-1)
			sFile = sFile.left(n);
		sFiles[i]=sFile;
	}
	if(bDebug)reportMessage(TN("|The following settings files have been found in| ") + sPath+"\\"+sFolder + ":\n" + sFiles+"\n");
	

// append any setting which is found in this dwg and not already appended
	String sAllEntries[] = MapObject().getAllEntryNames(sDictionary);
	{ 
		for (int i=0;i<sAllEntries.length();i++) 
		{ 
			String sEntry = sAllEntries[i];
			sEntry.makeLower();
			int bAdd = true;
			for (int j=0;j<sFiles.length();j++) 
			{ 
				String sFile = sFiles[j]; 
				sFile.makeLower();
				if (sFile==sEntry)
				{ 
					bAdd = false;
					break;
				}	 
			}
			if (bAdd)
			{
				//reportMessage("	match "+ sAllEntries[i]);
				sFiles.append(sAllEntries[i]);
				sFullPaths.append(sAllEntries[i]);
				bOnlyExports.append(true);
			}
		}
	}



// order alphabetically
	for (int i=0;i<sFiles.length();i++) 
		for (int j=0;j<sFiles.length()-1;j++) 
			if (sFiles[j]>sFiles[j+1])
			{
				sFiles.swap(j, j + 1);
				sFullPaths.swap(j, j + 1);
				bOnlyExports.swap(j, j + 1);
			}
	
	if (sFiles.length()<1)
	{ 
		reportMessage("\n" + scriptName() + ": " +TN("|No settings found in the drawing and in| ")+sPath+"\\"+sFolder+"\n");
		eraseInstance();
		return;
		
	}
	
// Properties
	String sSettingName=T("|Setting|");	
	PropString sSetting(nStringIndex++, sFiles, sSettingName);	
	sSetting.setDescription(T("|Defines the Setting|"));
	sSetting.setCategory(category);

	String sModeName=T("|Mode|");	
	String sModes[] ={ T("|Import|"), T("|Export|"), T("|Erase|")};
	PropString sMode(nStringIndex++, sModes, sModeName);	
	sMode.setDescription(T("|Defines the read/write mode or erases the settings from the database of the drawing.|"));
	sMode.setCategory(category);

// bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		String sKey = _kExecuteKey;
		sKey.makeUpper();

		if (sKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			for(int i=0;i<sEntries.length();i++)
				sEntries[i] = sEntries[i].makeUpper();	
			if (sEntries.find(sKey)>-1)
				setPropValuesFromCatalog(sKey);
			else
				setPropValuesFromCatalog(sLastInserted);					
		}	
		else	
			showDialog();
		
		
	// get mode
		int nMode = sModes.find(sMode);
		int nFile = sFiles.find(sSetting);

	// validate import/export mode
		if (nFile>-1 && nMode==0 && bOnlyExports[nFile])
		{ 
			reportMessage("\n" + scriptName() + T(" |No import file found, the settings of| ") + sSetting + T(" |can only be exported.|"));
			eraseInstance();
			return;
		}
		
		
	// read a potential mapObject
		Map mapSetting;
		String sSettingIdentifier = sSetting;
	// import
		if (nMode==0)
		{ 
			String fullPath = sFullPaths[nFile];//// HSB-12899
			reportMessage("\n" + scriptName()+": reading " +fullPath);
			mapSetting.readFromXmlFile(fullPath);
			reportMessage("\n" + mapSetting);	
			
			Map m = mapSetting.getMap("GeneralMapObject");
			if (m.hasString("Identifier"))
			{ 
				String _sSettingIdentifier = m.getString("Identifier");
			
			// use identifier instead of file name	
				if (_sSettingIdentifier.length() > 0)
					sSettingIdentifier = _sSettingIdentifier;
					
			// store custom file name for future exports
				if (sSettingIdentifier != sSetting)
				{ 
					m.setString("CustomFileName", sSetting);
					mapSetting.setMap("GeneralMapObject", m);
					reportMessage("\n" + T("|custom file name stored| ") + sSetting + T(" |against setting| ") +  sSettingIdentifier);
				}
			}
			
			
		}
		MapObject mo(sDictionary ,sSettingIdentifier);
		int bOk;
			
	// import
		if (nMode==0)
		{
			if (mapSetting.length() > 0)
			{
				bOk = true;
				if (mo.bIsValid())
				{
					mo.setMap(mapSetting);
				// update all references which might need an update
					Entity ents[] = mo.getReferencesToMe();
					for (int i=0;i<ents.length();i++) 
					{ 
						if (ents[i]!=_ThisInst)
						{
							TslInst tsl =(TslInst)ents[i]; 
							if (tsl.bIsValid())
								tsl.recalcNow();
						}	 
					}
					reportMessage("\n" +ents.length() + " "+ T("|entities updated with settings| ") + mapSetting);
				}
				else
				{
					mo.dbCreate(mapSetting);
					
				}
			}
			else
				reportMessage("\n" +sSetting + ": " +T("|Could not find any values.|"));
		}
	// export
		else if (nMode==1)
		{
			if (mo.bIsValid() && mo.map().length()>0)
			{
				bOk = true;
				mapSetting = mo.map();
				String sFileName = sSetting; // Default file name

			// get identifier data
				Map m = mapSetting.getMap("GeneralMapObject");
				String sSettingIdentifier = m.getString("Identifier");
				
			// set identifier	
				if (sSettingIdentifier.length()<1)
				{
					sSettingIdentifier = sSetting;
					m.setString("Identifier", sSetting);
					mapSetting.setMap("GeneralMapObject", m);
				}
			// read potential customFileName
				else if (m.hasString("CustomFileName"))
				{ 
					String _sFileName = m.getString("CustomFileName");
				// use custom file name	
					if (_sFileName.length() > 0)
						sFileName = _sFileName;
				}

				String sFullPath = sPath + "\\" + sFolder + "\\" + sFileName + ".xml";
				mapSetting.writeToXmlFile(sFullPath);
				reportMessage("\n" +sSettingIdentifier + ": " +mapSetting.length() + " "+T("|main entries exported.|\n") + sFullPath);
			}
			else
				reportMessage("\n" +sSetting + ": " +T("|No existing settings found.|"));			
		}	
		else if (nMode==2)
		{ 
			String sInput = getString(T("|Are you sure to erase the settings permanently?|") + " [" + T("|No|") +"/"+T("|Yes|")+"]");
			if (sInput.makeUpper()!=T("|Yes|").makeUpper().left(1))
			{	
				reportMessage("\n" + scriptName() + " " + T("|canceled|")+ ".");
				eraseInstance();
				return;
			}			

			
		// collect all references which might need an update
			Entity ents[0];
			if (mo.bIsValid())
			{
				ents= mo.getReferencesToMe();
				mo.dbErase();
				reportMessage("\n" + T("|The entry| ") + sSetting + T(" |has been removed from the dictionary| ") + sDictionary);
				String sRemainingEntries[] = MapObject().getAllEntryNames(sDictionary);
				reportMessage("\n" + sRemainingEntries.length() + T(" |remaining entries have been found.|"));
				for (int i=0;i<sRemainingEntries.length();i++) 
				{ 
					reportMessage("\n(" + (i+1)+")	"+sRemainingEntries[i]);
					 
				}//next i	
			}
		// update all references
			for (int i=0;i<ents.length();i++) 
			{ 
				if (ents[i]!=_ThisInst)
				{
					TslInst tsl =(TslInst)ents[i]; 
					if (tsl.bIsValid())
						tsl.recalcNow();
				}	 
			}			
			

			eraseInstance();
			return;
		}
		
	// report settings
		reportMessage("\n" + sSetting +(bOk?"":T(" |not|"))+T(" |successfully|")+(nMode==0?T("|imported|"):T("|exported|")));
		Map s = mapSetting;
		for (int i=0;i<s.length();i++)
		{
			if (s.hasDouble(i))	reportMessage("\n	" + s.keyAt(i) +"	" + s.getDouble(i));
			if (s.hasString(i))	reportMessage("\n	" + s.keyAt(i) +"	" + s.getString(i));
			if (s.hasInt(i))		reportMessage("\n	" + s.keyAt(i) +"	" + s.getInt(i));
			if (s.hasMap(i))
			{
				
				Map m = s.getMap(i);
				reportMessage("\n	" + s.keyAt(i) +"	(" + m.length() + " " + T("|entries|")+")");
				for (int j=0;j<m.length();j++)
				{
					
					if (m.hasDouble(j))	reportMessage("\n		" + m.keyAt(j) +"	" + m.getDouble(j));
					if (m.hasString(j))	reportMessage("\n		" + m.keyAt(j) +"	" + m.getString(j));
					if (m.hasInt(j))		reportMessage("\n		" + m.keyAt(j) +"	" + m.getInt(j));
					if (m.hasMap(j))
					{
						Map x = m.getMap(j);
						reportMessage("\n		" + m.keyAt(j) +"	(" + x.length() + " " + T("|entries|")+")");
						
						for (int k=0;k<x.length();k++)
						{
							
							if (x.hasDouble(k))	reportMessage("\n		" + x.keyAt(k) +"	" + x.getDouble(k));
							if (x.hasString(k))	reportMessage("\n		" + x.keyAt(k) +"	" + x.getString(k));
							if (x.hasInt(k))		reportMessage("\n		" + x.keyAt(k) +"	" + x.getInt(k));
							if (x.hasMap(k))
							{
								Map y = x.getMap(k);
								reportMessage("\n		" + x.keyAt(k) +"	(" + y.length() + " " + T("|entries|")+")");
							}
						}
						
						
						
					}
				}
				
			}
		}
		
		
		
			
	//	_Pt0 = getPoint();
		eraseInstance();
		return;
	}	
// end on insert	__________________

#End
#BeginThumbnail
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
1MK&"!B"T<84D=.!5BB@#_]GZ
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
        <int nm="BreakPoint" vl="154" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12899 defaults from content general are read" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="8/19/2021 9:05:34 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End