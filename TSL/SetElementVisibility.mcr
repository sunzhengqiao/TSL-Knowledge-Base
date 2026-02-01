#Version 8
#BeginDescription
Version 1.0 24.02.2021 
HSB-1906 new command to control visibility of a set of element groups , Author Thorsten Huck

This tsl controls the visibility of a set of elements

Version 1.1 04.03.2021 HSB-1906 regen added on turning groups on , Author Thorsten Huck
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords Group;Visibility;Turn on;turn off;on;off
#BeginContents
//region <History>
// #Versions
// 1.1 04.03.2021 HSB-1906 regen added on turning groups on , Author Thorsten Huck
// Version 1.0 24.02.2021 HSB-1906 new command to control visibility of a set of element groups , Author Thorsten Huck

/// <insert Lang=en>
/// Select properties and press ok.
/// </insert>

// <summary Lang=en>
// This tsl controls the visibility of a set of elements  
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "ToggleELementVisibility")) TSLCONTENT

//endregion
//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug = _bOnDebug || _kShiftKeyPressed;
	if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());		

	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
//end Constants//endregion

//region Properties
	
// get floors
	String sSelectAll = T("<|Select All|>");
	Entity ents[] = Group().collectEntities(true, Element(), _kModelSpace);
	String sFloors[0];
	Element elements[0];
	for (int i=0;i<ents.length();i++) 
	{ 
		Element el = (Element)ents[i];
		elements.append(el);
		Group gr = el.elementGroup(); 
		String house = gr.namePart(0);
		String floor = gr.namePart(1);
		String part2 = gr.namePart(2);
		
		if (sFloors.findNoCase(floor,-1)<0)
			sFloors.append(floor);
	}//next i
	sFloors = sFloors.sorted();
	sFloors.insertAt(0, sSelectAll);
	
	String sFloorName=T("|Storey|");	
	PropString sFloor(nStringIndex++, sFloors, sFloorName);	
	sFloor.setDescription(T("|Defines the Floor|"));
	sFloor.setCategory(category);
	
	String kInterior = T("|Walls (interior)|");
	String kExterior = T("|Walls (exterior)|");
	String kWall = T("|Walls (any)|");	
	String kFloorCeiling = T("|Floor/Ceiling|");
	String kRoof = T("|Roof|");
	
	String sFilters[] = {kInterior,kExterior,kWall,kFloorCeiling,kRoof };
	sFilters = sFilters.sorted();
	sFilters.insertAt(0, sSelectAll);
	String sFilterName=T("|Element Filter|");	
	PropString sFilter(nStringIndex++, sFilters, sFilterName);	
	sFilter.setDescription(T("|Defines the Filter|"));
	sFilter.setCategory(category);

	String sVisibilities[] = { T("|toggle state|"), T("|On|"), T("|Off|")};
	String sVisibilityName=T("|Set Visibility|");	
	PropString sVisibility(nStringIndex++, sVisibilities, sVisibilityName);	
	sVisibility.setDescription(T("|Defines the Visibility|"));
	sVisibility.setCategory(category);
	
	
	

//End Properties//endregion 	


//region bOnInsert
	if(_bOnInsert)
	{
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
		
		int nVisibility = sVisibilities.find(sVisibility,0);
		int bEveryElement = sFilter == sSelectAll;
		
	// filter elements	
		Group groups[0];
		for (int i=elements.length()-1; i>=0 ; i--) 
		{ 
			Element el =elements[i]; 
			Group group = el.elementGroup();
			
			if (sSelectAll != sFloor && group.namePart(1)!=sFloor){ continue;}
			
			
			ElementWallSF wallSF = (ElementWallSF)el;
			ElementRoof roof= (ElementRoof)el;
			if (wallSF.bIsValid() && (sFilter == kInterior || sFilter == kExterior))
			{ 
				int bExposed = wallSF.exposed();
				if ((bExposed && sFilter == kExterior) || (!bExposed && sFilter == kInterior) || (sFilter==kWall))
					groups.append(group);
			}
			else if (roof.bIsValid() && (sFilter == kFloorCeiling || sFilter == kRoof))
			{ 
				int bIsFloorCeiling = el.vecZ().isParallelTo(_ZW);
				if ((bIsFloorCeiling && sFilter == kFloorCeiling) || (!bIsFloorCeiling && sFilter == kRoof))
					groups.append(group);
			}	
			else if (bEveryElement)
				groups.append(group);
		}//next i
		
	// distinguish visibility by whatever is opposite to current

		int bVisibilityOn = nVisibility==2?true:false;
		if (nVisibility==0)
		{
			int nNumOn, nNumOff;
			for (int i=0;i<groups.length();i++) 
				if (groups[i].groupVisibility(false)==_kOn)
					nNumOn++; 
			nNumOff = 	groups.length()-nNumOn;				
			bVisibilityOn=nNumOff < nNumOn;
		}
		
	// toggle visibilty
		int cnt;
		for (int i=0;i<groups.length();i++) 
		{ 
			if (bVisibilityOn && groups[i].groupVisibility(false)!=_kOff)
			{
				groups[i].turnGroupVisibilityOff(false);
				cnt++;
			}
			else if (!bVisibilityOn && groups[i].groupVisibility(false)!=_kOn)
			{ 
				groups[i].turnGroupVisibilityOn(false);
				cnt++;
			}	
		}

		reportMessage("\n" + cnt + T(" |groups have been switched| ") + (bVisibilityOn? T("|off|"): T("|on|") ));
		
		if (bVisibilityOn)
			eraseInstance(); // no regen needed
		return;
	}	
// end on insert	__________________//endregion

	pushCommandOnCommandStack("_REGEN");
	eraseInstance();
	return;

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
      <str nm="Comment" vl="HSB-1906 regen added on turning groups on" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="3/4/2021 9:21:40 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End