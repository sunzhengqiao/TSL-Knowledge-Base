#Version 8
#BeginDescription
version value="1.0" date="23oct2019" author="thorsten.huck@hsbcad.com">
HSB-5806 initial

This tsl sets the project settings of a bomlink project and stores it in the dwg.
Optional one can remove potential settings.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords bomLink;Setting;Export
#BeginContents
/// <History>//region
/// <version value="1.0" date="23oct2019" author="thorsten.huck@hsbcad.com"> HSB-5806 initial </version>
/// </History>

/// <insert Lang=en>
/// Select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl sets the project settings of a bomlink project and stores it in the dwg.
/// Optional one can remove potential settings.
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "bomLinkSettings")) TSLCONTENT
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

//region Prerequisiites
	String strAssemblyPathProject=_kPathHsbInstall+"\\BOMLink\\hsbSoft.BomLink.Tsl.dll";
	String strTypeProject="hsbSoft.BomLink.Tsl.TslBomLink";
	String strFunctionProject="Projects";

	String strAssemblyPath=_kPathHsbInstall+"\\BOMLink\\hsbSoft.BomLink.Tsl.dll";
	String strType="hsbSoft.BomLink.Tsl.TslBomLink";
	String strFunction="AssignVariables";

	String sKeyX = "HSB_PROJECTSETTINGS";

	String sParameters[0];
	sParameters.append(_kPathHsbCompany);
//End Prerequisiites//endregion 

//region Properties
	String sProjects[] = callDotNetFunction1(strAssemblyPathProject, strTypeProject, strFunctionProject, sParameters);
	String sRemoveSetting = T("<|Remove bomLink Settings|>");
	sProjects.insertAt(sProjects.length(), sRemoveSetting);
	String sProjectName=T("|Project|");	
	PropString sProject(nStringIndex++, sProjects, sProjectName);	
	sProject.setDescription(T("|Defines the current bomLink Project|"));
	sProject.setCategory(category);
	
// make sure at least one project is found or subMapX is found
	if (sProjects.length()<2 && subMapXKeysProject().find(sKeyX)<0)
	{ 
		reportMessage("\n"+ scriptName() + ": " + T("|Could not find any project definitions, please run configuration first.|")+T("|Tool will be deleted.|"));
		eraseInstance();
		return;	
	}
//End Properties//endregion 


//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
			
		if (bDebug)reportNotice("\nKeyX: " + sKeyX + " current entries : " + subMapXKeysProject() + sProject);	
		
	// if only one potentiall project is found do not show any dialog
		int bHasProject = subMapXKeysProject().find(sKeyX) >- 1;
		if (!bHasProject && sProjects.length()==2)
		{ 
			sProject.set(sProjects.first());
		}
		else
		{ 
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
			{
				Map m = subMapXProject(sKeyX);
				String _sProject = m.getString("BOMLINKPROJECT");
			// preset the current project	
				if (sProjects.find(_sProject)>-1)
				{ 
					sProject.set(_sProject);
					showDialog("---");
				}
				else
					showDialog();
			}			
		}
		return;
	}	
// end on insert	__________________//endregion

// remove settings
	if (sProject==sRemoveSetting)
	{ 
		Map m= subMapXProject(sKeyX);	
		String _sProject = m.getString("BOMLINKPROJECT");
		removeSubMapXProject(sKeyX);
		reportMessage("\n" + scriptName() + ": " +_sProject + T(" |has been removed.|"));
		eraseInstance();
		return;
	}

// get bomLink data
	Map mapIn;
	mapIn.setString("COMPANY", _kPathHsbCompany);
	mapIn.setString("PROJECT", sProject);
    _Map = callDotNetFunction2(strAssemblyPath, strType, strFunction, mapIn);

	if (_Map.hasMap("Errors"))
	{
		Map m=_Map.getMap("Errors");
		if (m.hasString("Message"))
		{
			String sError=m.getString("Message");
			reportMessage(sError);
		}
	}

// set the project map	
	_Map.setString("BOMLINKPROJECT", sProject);
	setSubMapXProject(sKeyX, _Map);
	reportMessage("\n" + scriptName() + ": " +sProject + T(" |has been set as bomLink project.|"));
	if (!bDebug)eraseInstance();
	return;


	
	
#End
#BeginThumbnail
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
&3D2N0F""

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
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End