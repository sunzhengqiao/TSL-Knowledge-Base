#Version 8
#BeginDescription
#Versions
Version 2.4 31.07.2023 HSB-19709 X-Fix added if defined by freeprofile , Author Thorsten Huck
Version 2.3 31.07.2023 HSB-19709 new context commands to clone and remove mortises

Version 2.2 24.05.2023 HSB-19025 Slots can be cloned, settings can be accessed via context command
Version 2.1 23.05.2023 HSB-19025 beveled cuts operating on the edge of a panel can be cloned
Version 2.0 23.05.2023 HSB-19015 subnesting respects sublabel based override of oversize, tongue and groove connections accepted for tool cloning
Version 1.9 31.05.2022 HSB-15604 new context commands to clone beamcuts, freeprofiles supporting parent tsls. Sequential adding supported.
Version 1.8 31.05.2022 HSB-15604 new context commands to clone beamcuts
Version 1.7 25.05.2022 HSB-15542 new context command to clone drills as static tool to the subnesting
Version 1.6    06.07.2021    HSB-12521 Reference changed to lower right corner of subnesting
Version 1.5    26.05.2021    HSB-11998 transformation subnesting published
Version 1.4    11.05.2021    HSB-11860 name formatting corrected (information and name are separated by  default with '_') 
Version 1.3    11.05.2021    HSB-11860 name and order# (grade property) are written into a concatenated string (hsbSubnesting.ChildData) 
Version 1.2    11.05.2021    HSB-11858 contour detection enhanced, oversize of parent masterpanel-manager considered, openings supported

version value="1.1" date="17jul2019" author="thorsten.huck@hsbcad.com"> 
supports shopdrawing display, requires mapDimRequest consumers liek sd_EntitySymbolDisplay

This tsl creates a new panel representing a subnesting of a masterpanel.

The creation on insert is only done if no valid subnesting exists and the masterpanel contains at least one childpanel.
The panel carries a reference to the parent nesting.
Using the Format property one can display properties of the masterpanel using the format expressions, like @(Style)/P@(PosNum).
For ease of use one can use doubleclick to add/remove properties by index selection.
If the settings file contains an entry 'Format' no dialog is shown on insert. i.e. <str nm="Format" vl="@(Name)\P@(GrainDirection)\PPos: @(PosNum)"/>
To assign properties to the new subnesting panel one can use the following key words to assign any format expression to the selected property. The supported properties are:
Name, Label, Sublabel, Sublabel2, Grade, Material, Information
The maps 'Display' and 'DisplayChild' can be used to customize the appearance.
Default Settings can be exported if no settings file exists via custom context menu.
Use hsbTslSettingsIO to import customized settings.













#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 4
#KeyWords Nesting;Subnesting;Masterpanel;CLT;Shopdrawing
#BeginContents
//region Part #1
/// <History>//region
// #Versions
// 2.4 31.07.2023 HSB-19709 X-Fix added if defined by freeprofile , Author Thorsten Huck
// 2.3 31.07.2023 HSB-19709 new context commands to clone and remove mortises  , Author Thorsten Huck
// 2.2 24.05.2023 HSB-19025 Slots can be cloned, settings can be accessed via context command , Author Thorsten Huck
// 2.1 23.05.2023 HSB-19025 beveled cuts operating on the edge of a panel can be cloned , Author Thorsten Huck
// 2.0 23.05.2023 HSB-19015 subnesting respects sublabel based override of oversize, tongue and groove connections accepted for tool cloning , Author Thorsten Huck
// 1.9 31.05.2022 HSB-15604 new context commands to clone beamcuts, freeprofiles supporting parent tsls. Sequential adding supported. , Author Thorsten Huck
// 1.8 31.05.2022 HSB-15604 new context commands to clone beamcuts , Author Thorsten Huck
// 1.7 25.05.2022 HSB-15542 new context command to clone drills as static tool to the subnesting , Author Thorsten Huck
// 1.6 06.07.2021 HSB-12521 Reference changed to lower right corner of subnesting , Author Thorsten Huck
// 1.5 26.05.2021 HSB-11998 transformation subnesting published , Author Thorsten Huck
// 1.4 11.05.2021 HSB-11860 name formatting corrected (information and name are separated by  default with '_') , Author Thorsten Huck
// 1.3 11.05.2021 HSB-11860 name and order# (grade property) are written into a concatenated string (hsbSubnesting.ChildData) , Author Thorsten Huck
// 1.2 11.05.2021 HSB-11858 contour detection enhanced, oversize of parent masterpanel-manager considered, openings supported , Author Thorsten Huck

/// <version value="1.1" date="17jul2019" author="thorsten.huck@hsbcad.com"> supports shopdrawing display, requires mapDimRequest consumers liek sd_EntitySymbolDisplay </version>
/// <version value="1.0" date="16jul2019" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select masterpanel and pick an insertion point, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates a new panel representing a subnesting of a masterpanel.
/// 
/// The creation on insert is only done if no valid subnesting exists and the masterpanel contains at least one childpanel.
/// The panel carries a reference to the parent nesting.
/// Using the Format property one can display properties of the masterpanel using the format expressions, like @(Style)/P@(PosNum).
/// For ease of use one can use doubleclick to add/remove properties by index selection.
/// If the settings file contains an entry 'Format' no dialog is shown on insert. i.e. <str nm="Format" vl="@(Name)\P@(GrainDirection)\PPos: @(PosNum)"/>
/// To assign properties to the new subnesting panel one can use the following key words to assign any format expression to the selected property. The supported properties are:
/// Name, Label, Sublabel, Sublabel2, Grade, Material, Information
/// The maps 'Display' and 'DisplayChild' can be used to customize the appearance.
/// Default Settings can be exported if no settings file exists via custom context menu.
/// Use hsbTslSettingsIO to import customized settings.
/// </summary>


/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCLT-SubNesting")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "../|Add/Remove Format|") (_TM "|Select subnesting|"))) TSLCONTENT
//endregion

//int tick = getTickCount();
//reportNotice("\n"+ scriptName() + " starting " + _ThisInst.handle() + " at " + tick);

//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;

	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	
	String tPerpendicular = T("|Perpendicular|"), tBeveled = T("|Beveled|"), tAll =T("|All|"), tAny = T("|Any|");
	String tBottom = T("|bottom|"), tTop = T("|top|"), tThrough = T("|complete through|"), tEdge = T("|Edge|");

	String tNotRound = T("|Not round|"), tRound = T("|Round|"), tRounded = T("|Rounded|"), tExplicitRadius = T("|Explcit Radius|");
	String tRoundTypes[] = {tNotRound, tRound, tRounded, tExplicitRadius};
	int kRoundTyes[] ={ _kNotRound, _kRound, _kRounded, _kExplicitRadius};

// non public properties		
	//String sFormat = "@(POSNUM)\P@(Name)\P@(Style)\P@(Information)";
	String sAutoAttribute;

	double dLineTypeScale = 1;
	String sLineType = "CONTINUOUS";
	double dTextHeight = U(100);
	int nc = 3, ncChild = 253, ncOpening = 171;
	String sDimStyle = _DimStyles.first();

//end Constants//endregion

//region DialogMode
	int nDialogMode = _Map.getInt("DialogMode");
	if (nDialogMode>0)
	{ 
		if (nDialogMode == 1) // specify index when triggered to get different dialogs
		{
			setOPMKey("Drill");	

		category = T("|Category|");
			String sDiameterName=T("|Diameter|");	
			PropString sDiameter(nStringIndex++, "", sDiameterName);	
			sDiameter.setDescription(T("|Defines the diameter, a range of diameters (i.e. 0-20 to consume all diameters up to 20mm) or a list of diameters (i.e. 20;40 to consume only diameter 20mm and 40mm).|")+ T(" |Empty = all diameters|"));
			sDiameter.setCategory(category);
					
			String sAlignments[] = { tAll, tPerpendicular, tBeveled };
			String sAlignmentName=T("|Alignment|");	
			PropString sAlignment(nStringIndex++, sAlignments, sAlignmentName);	
			sAlignment.setDescription(T("|Defines the alignment which must apply to a drill|"));
			sAlignment.setCategory(category);
			
			
			String sFaces[] = {tAll, tBottom, tTop, tThrough, tEdge };
			String sFaceName=T("|Face|");	
			PropString sFace(nStringIndex++, sFaces, sFaceName);	
			sFace.setDescription(T("|Defines the face alignment which must apply to a drill|"));
			sFace.setCategory(category);
		}	
		else if (nDialogMode == 2) // specify index when triggered to get different dialogs
		{
			setOPMKey("Beamcut");	

		category = T("|Category|");		
			String sAlignments[] = { tAll, tPerpendicular, tBeveled };
			String sAlignmentName=T("|Alignment|");	
			PropString sAlignment(nStringIndex++, sAlignments, sAlignmentName);	
			sAlignment.setDescription(T("|Defines the alignment which must apply to a beamcut|"));
			sAlignment.setCategory(category);
						
			String sFaces[] = {tAll, tBottom, tTop, tThrough, tEdge };
			String sFaceName=T("|Face|");	
			PropString sFace(nStringIndex++, sFaces, sFaceName);	
			sFace.setDescription(T("|Defines the face alignment which must apply to a beamcut|"));
			sFace.setCategory(category);
		}	
		else if (nDialogMode == 3)
		{
			setOPMKey("FreeProfile");	

		category = T("|Category|");		
			String sTools[0];	
			Map mapTools = _Map.getMap("Tool[]");
			for (int i=0;i<mapTools.length();i++) 
			{ 
				String tool = mapTools.getString(i);
				if (sTools.findNoCase(tool, -1)<0)
					sTools.append(tool);
				 
			}//next i
			sTools = sTools.sorted();
			sTools.insertAt(0, tAny);

			String sToolName=T("|Tool|");	
			PropString sTool(nStringIndex++, sTools, sToolName);	
			sTool.setDescription(T("|Specifies the parent Tool which must refer to a free profile|"));
			sTool.setCategory(category);
						
			String sFaces[] = {tAll, tBottom, tTop, tEdge};
			String sFaceName=T("|Face|");	
			PropString sFace(nStringIndex++, sFaces, sFaceName);	
			sFace.setDescription(T("|Defines the face alignment which must apply to a free profile|"));
			sFace.setCategory(category);
		}
		else if (nDialogMode == 4) 
		{
			setOPMKey("Cut");	

		category = T("|Category|");	
			String sTools[0];	
			Map mapTools = _Map.getMap("Tool[]");
			for (int i=0;i<mapTools.length();i++) 
			{ 
				String tool = mapTools.getString(i);
				if (sTools.findNoCase(tool, -1)<0)
					sTools.append(tool);
				 
			}//next i
			sTools = sTools.sorted();
			sTools.insertAt(0, tAny);

			String sToolName=T("|Tool|");	
			PropString sTool(nStringIndex++, sTools, sToolName);	
			sTool.setDescription(T("|Specifies the parent Tool which must refer to a cut|"));
			sTool.setCategory(category);		
		
			String sAlignments[] = { tBeveled };
			String sAlignmentName=T("|Alignment|");	
			PropString sAlignment(nStringIndex++, sAlignments, sAlignmentName);	
			sAlignment.setDescription(T("|Defines the alignment which must apply to a cut|"));
			sAlignment.setCategory(category);

		}			
		else if (nDialogMode == 5) 
		{
			setOPMKey("Slot");	

		category = T("|Category|");	
			String sTools[0];	
			Map mapTools = _Map.getMap("Tool[]");
			for (int i=0;i<mapTools.length();i++) 
			{ 
				String tool = mapTools.getString(i);
				if (sTools.findNoCase(tool, -1)<0)
					sTools.append(tool);
				 
			}//next i
			sTools = sTools.sorted();
			sTools.insertAt(0, tAny);

			String sToolName=T("|Tool|");	
			PropString sTool(nStringIndex++, sTools, sToolName);	
			sTool.setDescription(T("|Specifies the parent tool which must refer to a slot|"));
			sTool.setCategory(category);		
//		
//			String sAlignments[] = { tBeveled };
//			String sAlignmentName=T("|Alignment|");	
//			PropString sAlignment(nStringIndex++, sAlignments, sAlignmentName);	
//			sAlignment.setDescription(T("|Defines the alignment which must apply to a cut|"));
//			sAlignment.setCategory(category);

		}			
		else if (nDialogMode == 6) // specify index when triggered to get different dialogs
		{
			setOPMKey("Mortise");	

		category = T("|Category|");		
			String sAlignments[] = { tAll};//, tPerpendicular, tBeveled };
			String sAlignmentName=T("|Alignment|");	
			PropString sAlignment(nStringIndex++, sAlignments, sAlignmentName);	
			sAlignment.setDescription(T("|Defines the alignment which must apply to a beamcut|"));
			sAlignment.setCategory(category);

			String sRoundTypes[0];
			sRoundTypes = tRoundTypes;
			sRoundTypes.append(tAny);
			String sRoundTypeName=T("|Rounding Type|");	
			PropString sRoundType(nStringIndex++, sRoundTypes, sRoundTypeName);	
			sRoundType.setDescription(T("|Defines the rounding type which must apply to a mortise|"));
			sRoundType.setCategory(category);
		}		
				
		
		else if (nDialogMode == 50) 
		{ 
			setOPMKey("Display");


		category = T("|General|");	
			String sDimStyleName=T("|DimStyle|");	
			PropString sDimStyle(nStringIndex++, _DimStyles.sorted(), sDimStyleName);	
			sDimStyle.setDescription(T("|Defines the DimStyle|"));
			sDimStyle.setCategory(category);
			
			String sTextHeightName=T("|Text Height|");	
			PropDouble dTextHeight(nDoubleIndex++, U(0), sTextHeightName);	
			dTextHeight.setDescription(T("|Defines the text height|"));
			dTextHeight.setCategory(category);
			
			String sColorName=T("|Color|");	
			PropInt nColor(nIntIndex++, nc, sColorName);	
			nColor.setDescription(T("|Defines the Color|"));
			nColor.setCategory(category);

		category = T("|Child Contour|");
			String sColor2Name=T("|Color| ");	
			PropInt nColor2(nIntIndex++, ncChild, sColorName);	
			nColor2.setDescription(T("|Defines the Color|"));
			nColor2.setCategory(category);		
		
			String sColorOpeningName=T("|Color Openings| ");	
			PropInt nColorOpening(nIntIndex++, ncOpening, sColorOpeningName);	
			nColorOpening.setDescription(T("|Defines the color of openings|"));
			nColorOpening.setCategory(category);	

			String sLineTypeName=T("|Linetype|");	
			PropString sLineType(nStringIndex++, _LineTypes.sorted(), sLineTypeName);	
			sLineType.setDescription(T("|Defines the LineType|"));
			sLineType.setCategory(category);
			if (_LineTypes.findNoCase(sLineType,-1)<0)
				sLineType.set(_LineTypes.first());
			
			String sLineTypeScaleName=T("|Linetype Scale|");	
			PropDouble dLineTypeScale(nDoubleIndex++, 1, sLineTypeScaleName, _kNoUnit);	
			dLineTypeScale.setDescription(T("|Defines the scale of the linetype|"));
			dLineTypeScale.setCategory(category);

		}
		else if (nDialogMode == 51) 
		{ 
			setOPMKey("PropertyCloning");

			Map m = _Map;
			Entity ent = m.getEntity("entDefine");
			MasterPanel master;
			if (ent.bIsValid())
				master = (MasterPanel)ent;
			Map mapAdd = m.getMap("mapAdd");

			String sDesc = T("|Defines from which source the property value will be cloned|");
		
			String sNameName=T("|Name|");	
			PropString sName(nStringIndex++, "", sNameName);	
			sName.setDescription(sDesc);
			sName.setCategory(category);
			if (master.bIsValid())sName.setDefinesFormatting(master, mapAdd);
			else	sName.setDefinesFormatting("MasterPanel", mapAdd);
			
			String sLabelName=T("|Label|");	
			PropString sLabel(nStringIndex++, "TXT", sLabelName);	
			sLabel.setDescription(T("|Defines the Label|"));
			sLabel.setCategory(category);
			if (master.bIsValid())sLabel.setDefinesFormatting(master, mapAdd);
			else	sLabel.setDefinesFormatting("MasterPanel", mapAdd);
			
			
			String sSubLabelName=T("|SubLabel|");	
			PropString sSubLabel(nStringIndex++, "TXT", sSubLabelName);	
			sSubLabel.setDescription(T("|Defines the SubLabel|"));
			sSubLabel.setCategory(category);
			if (master.bIsValid())sSubLabel.setDefinesFormatting(master, mapAdd);
			else	sSubLabel.setDefinesFormatting("MasterPanel", mapAdd);
			
			String sSubLabel2Name=T("|SubLabel2|");	
			PropString sSubLabel2(nStringIndex++, "TXT", sSubLabel2Name);	
			sSubLabel2.setDescription(T("|Defines the SubLabel2|"));
			sSubLabel2.setCategory(category);
			if (master.bIsValid())sSubLabel2.setDefinesFormatting(master, mapAdd);
			else	sSubLabel2.setDefinesFormatting("MasterPanel", mapAdd);
			
			String sGradeName=T("|Grade|");	
			PropString sGrade(nStringIndex++, "TXT", sGradeName);	
			sGrade.setDescription(T("|Defines the Grade|"));
			sGrade.setCategory(category);
			if (master.bIsValid())sGrade.setDefinesFormatting(master, mapAdd);
			else	sGrade.setDefinesFormatting("MasterPanel", mapAdd);
			
			String sMaterialName=T("|Material|");	
			PropString sMaterial(nStringIndex++, "TXT", sMaterialName);	
			sMaterial.setDescription(T("|Defines the Material|"));
			sMaterial.setCategory(category);
			if (master.bIsValid())sMaterial.setDefinesFormatting(master, mapAdd);
			else	sMaterial.setDefinesFormatting("MasterPanel", mapAdd);
			
			String sInformationName=T("|Information|");	
			PropString sInformation(nStringIndex++, "TXT", sInformationName);	
			sInformation.setDescription(T("|Defines the Information|"));
			sInformation.setCategory(category);
			if (master.bIsValid())sInformation.setDefinesFormatting(master, mapAdd);
			else	sInformation.setDefinesFormatting("MasterPanel", mapAdd);

		}		
		
		return;		
	}
//End DialogMode//endregion

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sFileName ="hsbCLT-SubNesting";
	Map mapSetting;

// find settings file
	String sFolders[]=getFoldersInFolder(sPath); 
	int bPathFound;
	if (_bOnInsert)
		bPathFound= sFolders.find(sFolder)>-1?true:makeFolder(sPath+"\\"+sFolder);	
	String sFullPath = sPath+"\\"+sFolder+"\\"+sFileName+".xml";
	String sFile=findFile(sFullPath); 

// read a potential mapObject
	MapObject mo(sDictionary ,sFileName);
	if (mo.bIsValid())
	{
		mapSetting=mo.map();
		setDependencyOnDictObject(mo);
	}
	// create a mapObject to make the settings persistent	
	else if ((_bOnInsert || _bOnDebug) && !mo.bIsValid() && sFile.length()>0)
	{
		mapSetting.readFromXmlFile(sFile);
		mo.dbCreate(mapSetting);
	}		
//End Settings//endregion

//region Properties

	String sAttributeName=T("|Format|");	// 1
	PropString sAttribute(nStringIndex++, "", sAttributeName);	
	sAttribute.setDescription(T("|Defines the text and/or attributes.|") + " " + T("|Multiple lines are separated by a backslash + P|") + " '\P'" + " " + T("|Attributes can also be added or removed by context commands.|"));
	sAttribute.setCategory(category);


	String sCloneName, sCloneMaterial, sCloneLabel, sCloneSubLabel, sCloneSubLabel2, sCloneGrade, sCloneInfo;
	sCloneName = "@(Information)_@(Name)";
	sCloneLabel = "@(Posnum)";
	
	if(mapSetting.length()<1)
	{ 
	
	// Format
		mapSetting.setString("Format", sAttribute);

	// Display	
		{
			Map m;
			m.setDouble("TextHeight", dTextHeight);
			m.setInt("Color", nc);
			m.setString("DimStyle", sDimStyle);
			mapSetting.setMap("Display", m);
		}
	// DisplayChild
		{
			Map m;
			//m.setDouble("TextHeight", dTextHeight);
			m.setInt("Color", ncChild);
			//m.setString("DimStyle", sDimStyle);
			m.setString("LineType", sLineType);
			m.setDouble("LineTypeScale", dLineTypeScale);
			mapSetting.setMap("DisplayChild", m);
		}		
	// PropertyCloning	
		{
			Map m;
			m.setString("Name", sCloneName);
			m.setString("Label", sCloneLabel);
			mapSetting.setMap("PropertyCloning", m);
		}		
		
		
	// GeneralMapObject	
		{
			Map m;
			m.setString("Identifier", sFileName);
			mapSetting.setMap("GeneralMapObject", m);
		}
		
	// Trigger ExportDefaultRule//region
		String sTriggerExportDefaultRule = T("|Export Default Settings|");
		addRecalcTrigger(_kContext, sTriggerExportDefaultRule );
		if (_bOnRecalc && _kExecuteKey==sTriggerExportDefaultRule)
		{
			mapSetting.writeToXmlFile(sFullPath);
			mo.dbCreate(mapSetting);
			setExecutionLoops(2);
			return;
		}//endregion		
	}
	
	//region Read Settings
	Map mapPropCloning;
	{
		String k;
		Map m = mapSetting;
		k="Format";				if (m.hasString(k))		sAutoAttribute = m.getString(k);
		
		
		m= mapSetting.getMap("Display");
		k="TextHeight";			if (m.hasDouble(k))		dTextHeight = m.getDouble(k);
		k="DimStyle";			if (m.hasString(k))		sDimStyle = m.getString(k);
		k="Color";				if (m.hasInt(k))		nc = m.getInt(k);

		m= mapSetting.getMap("DisplayChild");
//		k="TextHeight";			if (m.hasDouble(k))		dTextHeight = m.getDouble(k);
//		k="DimStyle";			if (m.hasString(k))		sDimStyle = m.getString(k);
		k="Color";				if (m.hasInt(k))		ncChild = m.getInt(k);
		k="ColorOpening";		if (m.hasInt(k))		ncOpening = m.getInt(k);
		k="LineTypeScale";			if (m.hasDouble(k))	dLineTypeScale = m.getDouble(k);
		k="LineType";			if (m.hasString(k))		sLineType = m.getString(k);
		
		mapPropCloning= mapSetting.getMap("PropertyCloning");
	}
	//End Read Settings//endregion 

//End Properties//endregion 

//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }

	// silent/dialog
		String sKey = _kExecuteKey;
		sKey.makeUpper();

	// set property if defined in settings
		if (sAutoAttribute.length()>0)
			sAttribute.set(sAutoAttribute);
		else if (sKey.length()>0)
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
		
	// prompt for masterpanels
		Entity ents[0];
		PrEntity ssE(T("|Select masterpanels|"), MasterPanel());
	  	if (ssE.go())
			ents.append(ssE.set());
			
	
	// cast masters
		MasterPanel masters[0];
		for (int i=0;i<ents.length();i++) 
		{ 
			MasterPanel master= (MasterPanel)ents[i];
			if (master.bIsValid())
				masters.append(master);
			 
		}//next i
		if (masters.length()<1)
		{ 
			reportMessage("\n" + scriptName() + ": " +T("|invalid references, tool will be deleted.|"));
			eraseInstance();
			return;	
		}
		
	// get shape from first to show translation of grip		
		PLine plShape = masters.first().plShape();
		LineSeg seg = PlaneProfile(plShape).extentInDir(_XW);
		Point3d ptFrom = seg.ptMid();
	
	// prompt for point input
		Point3d ptTo = ptFrom;
		PrPoint ssP(TN("|Select insert point|"),ptFrom); 
		if (ssP.go()==_kOk) 
			ptTo = ssP.value();
	
		ptTo.setZ(0);
		ptFrom.setZ(0);
		Vector3d vec = ptTo-ptFrom;	
		
	// prepare TSL
		TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
		GenBeam gbsTsl[] = {};		Entity entsTsl[1];				Point3d ptsTsl[1];
		int nProps[]={};			double dProps[]={};				String sProps[]={sAttribute};
		Map mapTsl;	
					
	// create per master
		for (int i=0;i<masters.length();i++) 
		{ 
			MasterPanel master= masters[i];
		
		// validate if master has already an existing subnesting
			Map m = master.subMapX("hsbSubnesting");
			Entity entSip = m.getEntity("Sip");
			if (entSip.bIsValid())
			{ 
				reportMessage("\n" + scriptName() + ": " +T("|Creation refused for masterpanel| ") + master.number() + T(" |because subnesting panel exists.|"));
				continue;
			}
			
		// validate if master has chailds
			if (master.nestedChildPanels().length()<1)
			{ 
				reportMessage("\n" + scriptName() + ": " +T("|Creation refused for masterpanel| ") + master.number() + T(" |because no child panels could be found.|"));
				continue;
			}


			PLine plShape = master.plShape();
			LineSeg seg = PlaneProfile(plShape).extentInDir(_XW);
			ptsTsl[0]= seg.ptMid()+vec;
			entsTsl[0] = master;
			
			tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	
//			if (tslNew.bIsValid())
//				tslNew.transformBy(Vector3d(0, 0, 0));
			 
		}//next i

		eraseInstance();
		return;
	}	
// end on insert	__________________//endregion

//End Part 1//endregion

//region Part #2

//region Get Master
	if (_Entity.length()<1 || !_Entity.first().bIsKindOf(MasterPanel()))	
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|invalid references, tool will be deleted.|"));
		eraseInstance();
		return;	
	}
	MasterPanel master = (MasterPanel)_Entity[0];
	setDependencyOnEntity(master);	
	ChildPanel childs[] = master.nestedChildPanels();	

// surface quality	
	String sqTop,sqBottom; 
	SipComponent components[0];
	if (master.bIsValid())
	{

		SipStyle style(master.style());
		sqTop = master.surfaceQualityOverrideTop();
		if (sqTop.length() < 1)sqTop = style.surfaceQualityTop();
		if (sqTop.length() < 1)sqTop = "?";
		int nQualityTop = SurfaceQualityStyle(sqTop).quality();
		
		sqBottom = master.surfaceQualityOverrideBottom();
		if (sqBottom.length() < 1)sqBottom = style.surfaceQualityBottom();
		if (sqBottom.length() < 1)sqBottom = "?";
		int nQualityBottom = SurfaceQualityStyle(sqBottom).quality();
	}
	
// find potential masterPanelManager attached HSB-11858
	double dOversize, dSpacing;
	{ 
		TslInst mpm;
		Entity ents[] = Group().collectEntities(true, TslInst(), _kModelSpace);
		for (int i=0;i<ents.length();i++) 
		{ 
			TslInst t= (TslInst)ents[i]; 
			if (t.bIsValid() && t.scriptName().find("hsbCLT-MasterPanelManager", 0, false) >- 1)
			{
				Entity _ents[] = t.entity();
				if (_ents.find(master)>-1)
				{ 
					mpm = t;
					break;					
				}
			}		 
		}//next i
		if (mpm.bIsValid())
		{
			dOversize = mpm.propDouble(1);
			dSpacing = mpm.propDouble(4);
		}
	}
	



//End Get Master//endregion 

//region Get sip if possible
	Sip sip;
	Body bdEnv;
	double dH;
	String sSubnestingList; //  a string containing every nested panel (name/oder number)
	CoordSys csSip;
	if (_Sip.length()>0)
	{
		sip = _Sip.first();
		csSip = sip.coordSys();
		
		_Entity.append(sip);
		setDependencyOnEntity(sip);
	}
//End Get sip if possible//endregion 

//region coordSys and ref Location
	Vector3d vecX = _XW;
	Vector3d vecY = _YW;
	Vector3d vecZ = _ZW;
	Plane pnW(_Pt0, _ZW);	
	
	CoordSys csRef(_Pt0, vecX, vecY, vecZ);
	Point3d ptRef = _Pt0;
	
	PlaneProfile ppSip(csRef);
	if (sip.bIsValid())
	{ 
		bdEnv = sip.envelopeBody(false, true);
		ppSip.unionWith(bdEnv.shadowProfile(pnW));
		dH = sip.dH();		
		ptRef = sip.ptCen() + .5 * vecX * ppSip.dX() - .5 * vecY * ppSip.dY()-vecZ*.5*dH;

	}
	ptRef.vis(1);

//End coordSys and ref Location//endregion 

//region Display
	Display dp(nc);
	dp.dimStyle(sDimStyle);
	dp.textHeight(dTextHeight);

	double dFactor = 1;
	double dTextHeightStyle = dp.textHeightForStyle("O",sDimStyle);
	if (dTextHeight>0)
	{
		dFactor=dTextHeight/dTextHeightStyle;
		dTextHeightStyle=dTextHeight;
		dp.textHeight(dTextHeight);
	}
	
//End Display//endregion 

//region get style by first child
	String style;
	Vector3d vecGrain=vecX;
	if (childs.length()>0)
	{ 
		ChildPanel& c = childs.first();
		Sip sipX = c.sipEntity();
		style = sipX.style();
		Vector3d _vecGrain = sipX.woodGrainDirection();
		if (!_vecGrain.bIsZeroLength())
		{
			vecGrain = _vecGrain;
			vecGrain.transformBy(c.sipToMeTransformation());
		}
	}
	else
	{ 
		Display dpErr(1);
		dpErr.draw(scriptName() + ": " + T("|no child panles found.|"), ptRef,vecX, vecY,0,0);
		return;
		
	}		
//End get style by first child//endregion 

//region get bounding profile of all childs HSB-11858
	PlaneProfile ppContour(csRef);
	PlaneProfile ppChilds[0];
	Sip panels[0];
	Body bodies[0];
	double oversizes[0];
	
	for (int i=0;i<childs.length();i++) 
	{ 
		Sip panel=childs[i].sipEntity();
		String sSubnesting = panel.name() + ":"+panel.grade();
		sSubnestingList += (sSubnestingList.length()>0?";":"")+sSubnesting;

	//region Get additional child offset if specified //HSB-19015	
		double oversize = dOversize;
		String sSubLabel2 = panel.subLabel2().makeUpper();
		if (sSubLabel2.length()>0)
		{ 
			String sSublabel2Tokens[]=sSubLabel2.tokenize(";");
			if (sSublabel2Tokens.length()>1)
			{ 
				String sRoute = sSublabel2Tokens.first();
				double dOffset = sSublabel2Tokens.last().atof();
				if (sRoute.length()>0)	oversize=dOffset;
			}
		// compatibility to previous approach
			else if (sSubLabel2!="HU")
				oversize=dOversize;	
		}				
	//endregion 

	// Get/collect blown-up child contour
		Body bd = panel.envelopeBody(false, true);
		bodies.append(bd);
		bd.transformBy(childs[i].sipToMeTransformation());
		PlaneProfile pp = bd.shadowProfile(pnW);//childs[i].realBody()
		pp.shrink(-oversize);	
		ppChilds.append(pp);
		panels.append(panel);
		oversizes.append(oversize);// //HSB-19015	

		
	// contribute to contour	
		pp.removeAllOpeningRings();
		ppContour.unionWith(pp);
	}//next i
	LineSeg segContour = ppContour.extentInDir(vecX);	segContour.vis(4);
	
// the transformation
	double dXS, dYS;
	CoordSys cs;
	if (!sip.bIsValid())
		cs.setToTranslation(ptRef - segContour.ptMid());
	else
	{
		dXS = ppSip.dX();
		dYS = ppSip.dY();
		
		Point3d ptFrom=segContour.ptMid()+.5*vecX*ppContour.dX()-.5*vecY*ppContour.dY();	//ptFrom.vis(2);
		cs.setToAlignCoordSys(ptFrom, vecX, vecY, vecZ, ptRef, csSip.vecX(), csSip.vecY(), csSip.vecZ());
	}
	ppContour.transformBy(cs);	
	
	Vector3d vecGrainSip = vecGrain;
	vecGrainSip.transformBy(cs);
	vecGrainSip.normalize();
	
// resolve into one ring
	int nCntMax = 1000, nCnt=1;
	PLine plRings[] = ppContour.allRings(true, false);
	double dMerge = U(1);
	while (nCnt<nCntMax && plRings.length()>1)
	{ 
		ppContour.shrink(-nCnt * dMerge);
		ppContour.shrink(nCnt * dMerge);
		plRings = ppContour.allRings(true, false);
		nCnt++;
	}	
	PLine plContour = plRings.first();	
//End get bounding profile of all childs//endregion 

//region Get potentrial gap profile
	PlaneProfile ppGap(CoordSys(_Pt0, _XW, _YW, _ZW));
	for (int p = 0; p < panels.length(); p++)
	{ 
		PlaneProfile pp = ppChilds[p];
		Sip& panel = panels[p];
		pp.transformBy(cs);		pp.vis(p);
		ppGap.unionWith(pp);
		
	}
	PlaneProfile ppx = ppContour;
	ppx.subtractProfile(ppGap);
	ppGap = ppx;
	ppGap.vis(6);
	//PLine plGapRings[] = ppGap.allRings(true, false);	
	
	
//endregion 

//region Create panel on creation
	if (_bOnDbCreated)
	{ 
		Sip sip;
		sip.dbCreate(plContour, style, - 1);
		sip.setXAxisDirectionInXYPlane(vecX);
		sip.setWoodGrainDirection(vecGrainSip);
		_Sip.append(sip);
		
	// store reference to parent master
		Map m;
		m.setEntity("Sip", sip);
		
		master.setSubMapX("hsbSubnesting", m);
		
		setExecutionLoops(2);
		return;
	}
	else if (!sip.bIsValid())
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|invalid references, tool will be deleted.|"));
		if(!bDebug)eraseInstance();
		return;	
	}
//End Create panel on creation//endregion 

//region Set Panel Properties
	if(!vecGrainSip.isParallelTo(sip.woodGrainDirection()))
		sip.setWoodGrainDirection(vecGrainSip);

	sip.setSurfaceQualityOverrideBottom(sqBottom);
	sip.setSurfaceQualityOverrideTop(sqTop);
	
	Map mapSubX;
	mapSubX.setString("ChildData",sSubnestingList);
	mapSubX.setPoint3d("ptOrg", cs.ptOrg());
	mapSubX.setVector3d("vecX", cs.vecX());
	mapSubX.setVector3d("vecY", cs.vecY());
	mapSubX.setVector3d("vecZ", cs.vecZ());	
	sip.setSubMapX("hsbSubNesting", mapSubX);
	
	Point3d ptFace = ptRef;// - csSip.vecZ() * sip.dH() * .5;

	int nNumStaticDrill = sip.getToolsStaticOfTypeDrill().length();
	int nNumStaticCut = sip.getToolsStaticOfTypeCut().length();
	int nNumStaticBeamcut = sip.getToolsStaticOfTypeBeamCut().length();

//region Property cloning
	if (mapPropCloning.length()>0)
	{ 
		Map m = mapPropCloning;
		for (int i=0;i<m.length();i++) 
		{ 
			if (!m.hasString(i))continue;
			String format= m.getString(i); 
			String key= m.keyAt(i).makeUpper();
			if (format.length()<1)
			{ 
				continue;
			}
		// get format by object
			String value = master.formatObject(format);
			
		//region resolve unknown
			int left = value.find("@(", 0);
			
		// get formatVariables and prefixes
			if (left >- 1)
			{
				// tokenize does not work for strings like '(@(KEY))'
				String sTokens[0];
				while (value.length() > 0)
				{
					left = value.find("@(", 0);
					int right = value.find(")", left);
					
					// key found at first location	
					if (left == 0 && right > 0)
					{
						String sVariable = value.left(right + 1).makeUpper();
						
						if (sVariable == "@(POSNUM)") sTokens.append(master.number());
						else if (sVariable == "@(NAME)") sTokens.append(master.name());
						else if (sVariable == "@(INFORMATION)") sTokens.append(master.information());
						else if (sVariable == "@(STYLE)") sTokens.append(master.style());
						else if (sVariable == "@(GRAINDIRECTIONTEXT)")sTokens.append(vecGrain.isParallelTo(_XW) ? T("|Lengthwise|") : T("|Crosswise|"));
						else if (sVariable == "@(GRAINDIRECTIONTEXTSHORT")sTokens.append(vecGrain.isParallelTo(_XW) ? T("|Grain LW|") : T("|Grain CW|"));
						else if (sVariable == "@(surfaceQualityBottom)".makeUpper())sTokens.append(sqBottom);
						else if (sVariable == "@(surfaceQualityTop)".makeUpper())	sTokens.append(sqTop);
						else if (sVariable == "@(SURFACEQUALITY)")
						{
							String sQualities[] ={ sqBottom, sqTop};
							if (sip.vecZ().dotProduct(vecZ) > 0)sQualities.swap(0, 1);
							String sQuality = sQualities[0] + " (" + sQualities[1] + ")";
							sTokens.append(sQuality);
						}
						//							else if (sVariable=="@(Graindirection)".makeUpper())
						//								sTokens.append("        ");// 8 blanks
						else if (sVariable == "@(SipComponent.Name)".makeUpper())
						{
							SipComponent component = SipStyle(sip.style()).sipComponentAt(0);
							sTokens.append(component.name());
						}
						else if (sVariable == "@(SipComponent.Material)".makeUpper())
						{
							SipComponent component = SipStyle(sip.style()).sipComponentAt(0);
							sTokens.append(component.material());
						}
						value = value.right(value.length() - right - 1);
					}
					// any text inbetween two variables	
					else if (left > 0 && right > 0)
					{
						sTokens.append(value.left(left));
						value = value.right(value.length() - left);
					}
					// any postfix text
					else
					{
						sTokens.append(value);
						value = "";
					}
				}
				
				for (int j = 0; j < sTokens.length(); j++)
					value += sTokens[j];
			}
		
		//End resolve unknown//endregion 
				
		// Name
			if (key=="NAME" && sip.name()!=value)
			{
				if (value.left(1) == "_")value = value.right(value.length() - 1); // skip leading '_'
				sip.setName(value);
			}
		// Label
			else if (key=="LABEL" && sip.label()!=value)				sip.setLabel(value);				
		// SubLabel
			else if (key=="SUBLABEL" && sip.subLabel()!=value)			sip.setSubLabel(value);	
		// SubLabel2
			else if (key=="SUBLABEL2" && sip.subLabel()!=value)			sip.setSubLabel2(value);	
		// Grade
			else if (key=="GRADE" && sip.grade()!=value)				sip.setGrade(value);
		// Material
			else if (key=="MATERIAL" && sip.material()!=value)			sip.setMaterial(value);
		// Informatiom
			else if (key=="INFORMATION" && sip.information()!=value)	sip.setInformation(value);	
		}//next i
		
	}
//End Property cloning//endregion 

// numbering
	if (sip.posnum()<0)
		sip.assignPosnum(1,false);
	
			
//End Set Panel Properties//endregion 

//End Part #2//endregion

//region //Trigger _Pt0 
	if (_kNameLastChangedProp=="_Pt0")
	{
		Point3d ptTo = _Pt0 + vecX * .5*dXS - vecY * .5*dYS;

		sip.transformBy(vecX * vecX.dotProduct(ptTo - ptRef) + vecY * vecY.dotProduct(ptTo - ptRef)+ vecZ * vecZ.dotProduct(ptTo - ptRef));
		setExecutionLoops(2);
		return;
	}
	else
		_Pt0 = ptRef-vecX*.5*dXS+vecY*.5*dYS;
	//endregion	

//region Dialog Trigger
	Map mapCloning;

{ 
	// create TSL
	TslInst tslDialog;			Map mapTsl;						
	GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };
	
//region Trigger CloneAll	
	String sTriggerCloneAll = T("|Clone all tools|");
	addRecalcTrigger(_kContextRoot, sTriggerCloneAll );
	if (bDebug || (_bOnRecalc && _kExecuteKey==sTriggerCloneAll))
	{
		{
			Map m;
			m.setString("Tool", tAny);
			m.setString("Face", tAll);
			mapCloning.setMap("FreeProfile", m);	
		}
			
		{
			Map m;
			m.setString("Diameter", ""); // any
			m.setString("Alignment", tAll);
			m.setString("Face", tAll);
			mapCloning.setMap("Drill", m);	
		}		
		
		{
			Map m;
			m.setString("Alignment", tAll);
			m.setString("Face", tAll);
			mapCloning.setMap("Beamcut", m);	
		}
		
		{
			Map m;
			m.setString("Tool", tAny);
			m.setString("Alignment", tBeveled);
			mapCloning.setMap("Cut", m);	
		}	

		{
			Map m;
			m.setString("Tool", tAny);
			mapCloning.setMap("Slot", m);	
		}	
		
		{
			Map m;
			m.setString("Tool", tAny);
			mapCloning.setMap("Mortise", m);	
		}		

	}//endregion	

	
//region Trigger CloneDrills
	String sTriggerCloneDrills = T("|Clone Drills|");
	addRecalcTrigger(_kContextRoot, sTriggerCloneDrills );
	if ((_bOnRecalc && _kExecuteKey==sTriggerCloneDrills))
	{
		mapTsl.setInt("DialogMode",1);
		
		String sDiameter, sAlignment = tAll, sFace = tAll;	
		sProps.append(sDiameter); // all diameters
		sProps.append(sAlignment); // any alignment
		sProps.append(sFace); // any face

		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{ 	
				int num = sip.removeToolsStaticOfType(Drill());
				if (num>0)reportNotice("\n"+ num + T(" |drills removed from subnesting panel|"));

				sDiameter = tslDialog.propString(0);
				sAlignment = tslDialog.propString(1);
				sFace = tslDialog.propString(2);

				if (sDiameter=="" && sAlignment == tAll && sFace== tAll)
				{
					reportNotice("\n"+ sip.removeToolsStaticOfType(Drill()) + T(" |drills removed from subnesting panel|"));
				}

				Map m;
				m.setString("Diameter", sDiameter);
				m.setString("Alignment", sAlignment);
				m.setString("Face", sFace);
				mapCloning.setMap("Drill", m);
			}
			tslDialog.dbErase();
			if (!bOk)
				return;
		}

		// do not return to perform map based cloning
	}
	//endregion	

//region Trigger CloneBeamcuts
	String sTriggerCloneBeamcuts = T("|Clone Beamcuts|");
	addRecalcTrigger(_kContextRoot, sTriggerCloneBeamcuts );
	if ((_bOnRecalc && _kExecuteKey==sTriggerCloneBeamcuts))
	{
		mapTsl.setInt("DialogMode",2);
		
		String sAlignment = tAll, sFace = tAll;	
		sProps.append(sAlignment); // any alignment
		sProps.append(sFace); // any face

		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{ 
				sAlignment = tslDialog.propString(0);
				sFace = tslDialog.propString(1);				

				if (sAlignment==tAll  && sFace== tAll)
				{ 
					int num = sip.removeToolsStaticOfType(BeamCut());
					if (num>0)reportNotice("\n"+ num + T(" |beamcuts removed from subnesting panel|"));					
				}

				Map m;
				m.setString("Alignment", sAlignment);
				m.setString("Face", sFace);
				mapCloning.setMap("Beamcut", m);				

			}
			tslDialog.dbErase();
			if (!bOk)
				return;	
		}				
		// do not return to perform map based cloning	
	}
//endregion	

//region Trigger CloneMortises
	String sTriggerCloneMortises = T("|Clone Mortises|");
	addRecalcTrigger(_kContextRoot, sTriggerCloneMortises );
	if ((_bOnRecalc && _kExecuteKey==sTriggerCloneMortises))
	{
		mapTsl.setInt("DialogMode",6);

//	//region // Collect available linked tools
//		String sTools[0];
//		for (int p = 0; p < panels.length(); p++)
//		{
//			Sip& panel = panels[p];
//			double oversize = oversizes[p];
//			
//			AnalysedMortise smortises[] = AnalysedMortise().filterToolsOfToolType(panel.analysedTools());
//			
//			for (int i = 0; i < smortises.length(); i++)
//			{
//				AnalysedMortise at = smortises[i];
//				ToolEnt tent = at.toolEnt();
//				TslInst tsl = (TslInst)tent;
//
//				if (tsl.bIsValid())
//					if (sTools.findNoCase(tsl.scriptName(),-1)<0)
//						sTools.append(tsl.scriptName());
//			}
//		}
//		Map mapTools;
//		for (int i=0;i<sTools.length();i++) 
//			mapTools.appendString("Tool",sTools[i]);
//		mapTsl.setMap("Tool[]", mapTools);	
//		//endregion 

		String sAlignment = tAll, sRoundType = tAny;	
		sProps.append(sAlignment); // any alignment
		sProps.append(sRoundType); // any roundtype

		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{ 
				sAlignment = tslDialog.propString(0);
				sRoundType = tslDialog.propString(1);				

				if (sAlignment==tAll)//  && sFace== tAll)
				{ 
					int num = sip.removeToolsStaticOfType(Mortise());
					if (num>0)reportNotice("\n"+ num + T(" |mortises removed from subnesting panel|"));					
				}

				Map m;				
				m.setString("Alignment", sAlignment);
				m.setString("RoundType", sRoundType);
				mapCloning.setMap("Mortise", m);
			}
			tslDialog.dbErase();
			if (!bOk)
				return;	
		}				
		// do not return to perform map based cloning	
	}
	//endregion	

//region Trigger CloneFreeprofile	
	String sTriggerCloneFreeProfile = T("|Clone Freeprofiles|");
	addRecalcTrigger(_kContextRoot, sTriggerCloneFreeProfile );
	if (_bOnRecalc && _kExecuteKey==sTriggerCloneFreeProfile)
	{
	// Collect available linked tools
		String sTools[0];
		for (int p = 0; p < panels.length(); p++)
		{
			Sip& panel = panels[p];
			double oversize = oversizes[p];
			
			AnalysedFreeProfile afps[] = AnalysedFreeProfile().filterToolsOfToolType(panel.analysedTools());
			
			for (int i = 0; i < afps.length(); i++)
			{
				AnalysedFreeProfile at = afps[i];
				ToolEnt tent = at.toolEnt();
				TslInst tsl = (TslInst)tent;

				if (tsl.bIsValid())
				{
					String k="hsbCLT-TongueGroove";
					if (sTools.findNoCase(k,-1)<0)
					{ 
						sTools.append(k);
						continue;
					}					


					k="hsbCLT-X-Fix"; // group all X-Fix TSL's'
					k = tsl.scriptName().find(k, 0, false) >- 1 ? k : tsl.scriptName();
					if (sTools.findNoCase(k,-1)<0)
					{ 
						sTools.append(k);
						continue;
					}				
				}	
			}
		}
		Map mapTools;
		for (int i=0;i<sTools.length();i++) 
			mapTools.appendString("Tool",sTools[i]); 

		mapTsl.setInt("DialogMode",3);
		mapTsl.setMap("Tool[]", mapTools);
		String sTool = tAny, sFace = tAll;	
		sProps.append(sTool); // any tool
		sProps.append(sFace); // any face

		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{ 	
				sTool = tslDialog.propString(0);
				sFace = tslDialog.propString(1);	

				if (sTool==tAny  && sFace== tAll)
				{
					reportNotice("\n"+ sip.removeToolsStaticOfType(FreeProfile()) + T(" |free profiles removed from subnesting panel|"));
				}

				Map m;
				m.setString("Tool", sTool);
				m.setString("Face", sFace);
				mapCloning.setMap("FreeProfile", m);			
			}
			tslDialog.dbErase();
			if (!bOk)
				return;	
		}	
	}//endregion

//region Trigger CloneCuts
	String sTriggerCloneCuts = T("|Clone Cuts|");
	addRecalcTrigger(_kContextRoot, sTriggerCloneCuts );
	if ((_bOnRecalc && _kExecuteKey==sTriggerCloneCuts))
	{
		mapTsl.setInt("DialogMode",4);
		
	//region // Collect available linked tools
		String sTools[0];
		for (int p = 0; p < panels.length(); p++)
		{
			Sip& panel = panels[p];
			double oversize = oversizes[p];
			
			AnalysedCut acuts[] = AnalysedCut().filterToolsOfToolType(panel.analysedTools());
			
			for (int i = 0; i < acuts.length(); i++)
			{
				AnalysedCut at = acuts[i];
				ToolEnt tent = at.toolEnt();
				TslInst tsl = (TslInst)tent;

				if (tsl.bIsValid())
					if (sTools.findNoCase(tsl.scriptName(),-1)<0)
						sTools.append(tsl.scriptName());
			}
		}
		Map mapTools;
		for (int i=0;i<sTools.length();i++) 
			mapTools.appendString("Tool",sTools[i]);
		mapTsl.setMap("Tool[]", mapTools);	
		//endregion 

		
		String sTool = tAny, sAlignment = tBeveled;	
		sProps.append(sTool); // any tool
		sProps.append(sAlignment);  // any alignment

		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{ 	
				int num = sip.removeToolsStaticOfType(Cut());
				if (num>0)reportNotice("\n"+ num + T(" |cuts removed from subnesting panel|"));

				sTool = tslDialog.propString(0);
				sAlignment = tslDialog.propString(1);

				if (sAlignment == tBeveled)
				{
					reportNotice("\n"+ sip.removeToolsStaticOfType(Cut()) + T(" |cuts removed from subnesting panel|"));
				}

				Map m;
				m.setString("Alignment", sAlignment);
				m.setString("Tool", sTool);
				mapCloning.setMap("Cut", m);
			}
			tslDialog.dbErase();
			if (!bOk)
				return;
		}

		// do not return to perform map based cloning
	}
	//endregion	

//region Trigger CloneSlots
	String sTriggerCloneSlots = T("|Clone Slots|");
	addRecalcTrigger(_kContextRoot, sTriggerCloneSlots );
	if ((_bOnRecalc && _kExecuteKey==sTriggerCloneSlots))
	{
		mapTsl.setInt("DialogMode",5);
		
	//region // Collect available linked tools
		String sTools[0];
		for (int p = 0; p < panels.length(); p++)
		{
			Sip& panel = panels[p];
			double oversize = oversizes[p];
			
			AnalysedSlot aslots[] = AnalysedSlot().filterToolsOfToolType(panel.analysedTools());
			
			for (int i = 0; i < aslots.length(); i++)
			{
				AnalysedSlot at = aslots[i];
				ToolEnt tent = at.toolEnt();
				TslInst tsl = (TslInst)tent;

				if (tsl.bIsValid())
					if (sTools.findNoCase(tsl.scriptName(),-1)<0)
						sTools.append(tsl.scriptName());
			}
		}
		Map mapTools;
		for (int i=0;i<sTools.length();i++) 
			mapTools.appendString("Tool",sTools[i]);
		mapTsl.setMap("Tool[]", mapTools);	
		//endregion 

		
		String sTool = tAny;//, sAlignment = tBeveled;	
		sProps.append(sTool); // any tool
		//sProps.append(sAlignment);  // any alignment

		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{ 	
				int num = sip.removeToolsStaticOfType(Slot());
				if (num>0)reportNotice("\n"+ num + T(" |slots removed from subnesting panel|"));

				sTool = tslDialog.propString(0);
				//sAlignment = tslDialog.propString(1);

//				if (sAlignment == tBeveled)
//				{
//					reportNotice("\n"+ sip.removeToolsStaticOfType(Slot()) + T(" |slots removed from subnesting panel|"));
//				}
//
				Map m;
				//m.setString("Alignment", sAlignment);
				m.setString("Tool", sTool);
				mapCloning.setMap("Slot", m);
			}
			tslDialog.dbErase();
			if (!bOk)
				return;
		}

		// do not return to perform map based cloning
	}
	//endregion	



//region Trigger RemoveAllStatic
	String RemoveAllStatic = T("|Remove All Tools|");
	addRecalcTrigger(_kContextRoot, RemoveAllStatic );
	if (_bOnRecalc && _kExecuteKey==RemoveAllStatic && sip.bIsValid())
	{
	// remove all static drills of the subNesting panel
		int num, numRemoved = sip.removeToolsStaticOfType(Drill());
		num += numRemoved;
		if (numRemoved>0)reportNotice("\n"+ numRemoved + T(" |drills removed from subnesting panel|"));	
		
		numRemoved = sip.removeToolsStaticOfType(BeamCut());
		num += numRemoved;
		if (numRemoved>0)reportNotice("\n"+ numRemoved + T(" |beamcuts removed from subnesting panel|"));		

		numRemoved = sip.removeToolsStaticOfType(Mortise());
		num += numRemoved;
		if (numRemoved>0)reportNotice("\n"+ numRemoved + T(" |mortises removed from subnesting panel|"));
		
		numRemoved = sip.removeToolsStaticOfType(FreeProfile());
		num += numRemoved;
		if (numRemoved>0)reportNotice("\n"+ numRemoved + T(" |free profiles removed from subnesting panel|"));		

		numRemoved = sip.removeToolsStaticOfType(Cut());
		num += numRemoved;
		if (numRemoved>0)reportNotice("\n"+ numRemoved + T(" |cuts removed from subnesting panel|"));	
		
		numRemoved = sip.removeToolsStaticOfType(Slot());
		num += numRemoved;
		if (numRemoved>0)reportNotice("\n"+ numRemoved + T(" |slots removed from subnesting panel|"));			

		numRemoved = sip.removeToolsStaticOfType(SolidSubtract());
		num += numRemoved;
		if (numRemoved>0)reportNotice("\n"+ numRemoved + T(" |solid subtractions removed from subnesting panel|"));		
		
		if (num<1)
		{ 
			reportNotice(TN("|Could not find any static tool of type Drill, Beamcut, Freeprofile or SolidSubtract which could be removed|"));
		}

		_Map.removeAt("Static[]", true);
		setExecutionLoops(2);
		return;
	}//endregion

//region Trigger RemoveStaticDrills
	String sTriggerRemoveStaticDrills = T("|Remove Drills|");
	if (nNumStaticDrill>0)addRecalcTrigger(_kContextRoot, sTriggerRemoveStaticDrills );
	if (_bOnRecalc && _kExecuteKey==sTriggerRemoveStaticDrills && sip.bIsValid())
	{
	// remove all static drills of the subNesting panel
		int numRemoved = sip.removeToolsStaticOfType(Drill());
		reportNotice("\n"+ numRemoved + T(" |drills removed from subnesting panel|"));				
		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger RemoveStaticBeamcuts
	String sTriggerRemoveStaticBeamcuts = T("|Remove Beamcuts|");
	if (nNumStaticBeamcut>0)addRecalcTrigger(_kContextRoot, sTriggerRemoveStaticBeamcuts );
	if (_bOnRecalc && _kExecuteKey==sTriggerRemoveStaticBeamcuts && sip.bIsValid())
	{
	// remove all static veamcuts of the subNesting panel
		int numRemoved = sip.removeToolsStaticOfType(BeamCut());
		reportNotice("\n"+ numRemoved + T(" |beamcuts removed from subnesting panel|"));				
		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger RemoveStaticMortises
	String sTriggerRemoveStaticMortises = T("|Remove Mortises|");
	addRecalcTrigger(_kContextRoot, sTriggerRemoveStaticMortises );
	if (_bOnRecalc && _kExecuteKey==sTriggerRemoveStaticMortises && sip.bIsValid())
	{
	// remove all static veamcuts of the subNesting panel
		int numRemoved = sip.removeToolsStaticOfType(Mortise());
		reportNotice("\n"+ numRemoved + T(" |mortises removed from subnesting panel|"));				
		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger RemoveStaticFreeprofiles
	String sTriggerRemoveStaticFreeProfiles = T("|Remove Freeprofiles|");
	addRecalcTrigger(_kContextRoot, sTriggerRemoveStaticFreeProfiles );
	if (_bOnRecalc && _kExecuteKey==sTriggerRemoveStaticFreeProfiles && sip.bIsValid())
	{
	// remove all static drills of the subNesting panel
		int numRemoved = sip.removeToolsStaticOfType(FreeProfile());
		reportNotice("\n"+ numRemoved + T(" |free profiles removed from subnesting panel|"));	
		numRemoved = sip.removeToolsStaticOfType(SolidSubtract());
		reportNotice("\n"+ numRemoved + T(" |solid subtractions removed from subnesting panel|"));	
		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger RemoveStaticCuts
	String sTriggerRemoveStaticCuts = T("|Remove Cuts|");
	if (nNumStaticCut>0)addRecalcTrigger(_kContextRoot, sTriggerRemoveStaticCuts );
	if (_bOnRecalc && _kExecuteKey==sTriggerRemoveStaticCuts && sip.bIsValid())
	{
	// remove all static drills of the subNesting panel
		int numRemoved = sip.removeToolsStaticOfType(Cut());
		reportNotice("\n"+ numRemoved + T(" |cuts removed from subnesting panel|"));				
		setExecutionLoops(2);
		return;
	}//endregion

//region Trigger RemoveStaticSlots
	String sTriggerRemoveStaticSlots = T("|Remove Slots|");
	addRecalcTrigger(_kContextRoot, sTriggerRemoveStaticSlots );
	if (_bOnRecalc && _kExecuteKey==sTriggerRemoveStaticSlots && sip.bIsValid())
	{
	// remove all static drills of the subNesting panel
		int numRemoved = sip.removeToolsStaticOfType(Slot());
		reportNotice("\n"+ numRemoved + T(" |slots removed from subnesting panel|"));				
		setExecutionLoops(2);
		return;
	}//endregion


//region Dialog Trigger
{ 
	// create TSL
	TslInst tslDialog;			Map mapTsl;						
	GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };
	
//region Trigger DisplaySettings
	String sTriggerDisplaySetting = T("|Display settings|");
	addRecalcTrigger(_kContext, sTriggerDisplaySetting );
	if (_bOnRecalc && _kExecuteKey==sTriggerDisplaySetting)	
	{ 
		mapTsl.setInt("DialogMode",50);
		nProps.append(nc);
		nProps.append(ncChild);
		nProps.append(ncOpening);
		
		dProps.append(dTextHeight);
		dProps.append(dLineTypeScale);
		
		sProps.append(sDimStyle);
		sProps.append(sLineType);
	
		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{ 
				nc = tslDialog.propInt(0);
				ncChild = tslDialog.propInt(1);
				ncOpening = tslDialog.propInt(2);
				
				dTextHeight= tslDialog.propDouble(0);
				dLineTypeScale = tslDialog.propDouble(1);
				
				sDimStyle  = tslDialog.propString(0);
				sLineType = tslDialog.propString(1);

				Map m = mapSetting.getMap("Display");
				m.setDouble("TextHeight", dTextHeight);
				m.setInt("Color", nc);
				m.setString("DimStyle", sDimStyle);
				mapSetting.setMap("Display", m);
				
				m = mapSetting.getMap("DisplayChild");
				m.setInt("Color", ncChild);
				m.setString("LineType", sLineType);
				m.setDouble("LineTypeScale", dLineTypeScale);				
				mapSetting.setMap("DisplayChild", m);
				
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);				
			}
			tslDialog.dbErase();
		}
		setExecutionLoops(2);
		return;	
	}
	//endregion	


//region Trigger PropertyCloning
	String sTriggerCloningSetting = T("|Property Cloning Settings|");
	addRecalcTrigger(_kContext, sTriggerCloningSetting );
	if (_bOnRecalc && _kExecuteKey==sTriggerCloningSetting)	
	{ 
		mapTsl.setInt("DialogMode",51);
		
		if (master.bIsValid())
			mapTsl.setEntity("entDefine", master);
		
		if (sip.bIsValid())
		{ 
			Map m;
			String vars[] = sip.formatObjectVariables();
			for (int i=0;i<vars.length();i++) 
				m.appendString(vars[i], T("|Dummy Value|")); 
			mapTsl.setMap("mapAdd", m);
		}
		
		
		
		sProps.setLength(7);
		Map m = mapPropCloning;
		for (int i = 0; i < m.length(); i++)
		{
			if ( ! m.hasString(i))continue;
			String format = m.getString(i);
			String key = m.keyAt(i).makeUpper();
			
			if (key == "NAME")sProps[0]=format;
			else if (key == "LABEL")sProps[1]=format;
			else if (key == "SUBLABEL")sProps[2]=format;
			else if (key == "SUBLABEL2")sProps[3]=format;	
			else if (key == "GRADE")sProps[4]=format;
			else if (key == "MATERIAL")sProps[5]=format;
			else if (key == "INFORMATION")sProps[6]=format;
		}

		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{ 	
				m.setString("NAME", tslDialog.propString(0));
				m.setString("LABEL", tslDialog.propString(1));
				m.setString("SUBLABEL", tslDialog.propString(2));
				m.setString("SUBLABEL2", tslDialog.propString(3));
				m.setString("GRADE", tslDialog.propString(4));
				m.setString("MATERIAL", tslDialog.propString(5));
				m.setString("INFORMATION", tslDialog.propString(6));
				
				mapSetting.setMap("PropertyCloning", m);
				
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);				
			}
			tslDialog.dbErase();
		}
		setExecutionLoops(2);
		return;	
	}
	//endregion	



//region Trigger Import/Export Settings
	if (findFile(sFullPath).length()>0)
	{ 
		String sTriggerImportSettings = T("|Import Settings|");
		addRecalcTrigger(_kContext, sTriggerImportSettings );
		if (_bOnRecalc && _kExecuteKey==sTriggerImportSettings)
		{
			mapSetting.readFromXmlFile(sFullPath);	
			if (mapSetting.length()>0)
			{ 
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);	
				reportMessage(TN("|Settings successfully imported from| ") + sFullPath);	
			}
			setExecutionLoops(2);
			return;
		}			
	}

// Trigger ExportSettings
	if (mapSetting.length() > 0)
	{
		String sTriggerExportSettings = T("|Export Settings|");
		addRecalcTrigger(_kContext, sTriggerExportSettings );
		if (_bOnRecalc && _kExecuteKey == sTriggerExportSettings)
		{
			int bWrite;
			if (findFile(sFullPath).length()>0)
			{ 
				String sInput = getString(T("|Are you sure to overwrite existing settings?|") + " [" + T("|No|") +"/"+T("|Yes|")+"]").left(1);
				bWrite = sInput.makeUpper() == T("|Yes|").makeUpper().left(1);
			}
			else bWrite = true;
				
			if (bWrite && mapSetting.length() > 0)
			{ 
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);
				
			// make sure the path exists	//HSB-10750
				int bPathFound= sFolders.find(sFolder)>-1?true:makeFolder(sPath+"\\"+sFolder);	
				
			// write file	
				mapSetting.writeToXmlFile(sFullPath);
				
			// report rsult of writing	
				if (findFile(sFullPath).length()>0)		reportMessage(TN("|Settings successfully exported to| ") + sFullPath);
				else									reportMessage(TN("|Failed to write to| ") + sFullPath);		
			}
			
			setExecutionLoops(2);
			return;
		}
	}
	//endregion 
}
//End Dialog Trigger//endregion 




//region Trigger Import/Export Settings
	if (findFile(sFullPath).length()>0)
	{ 
		String sTriggerImportSettings = T("|Import Settings|");
		addRecalcTrigger(_kContext, sTriggerImportSettings );
		if (_bOnRecalc && _kExecuteKey==sTriggerImportSettings)
		{
			mapSetting.readFromXmlFile(sFullPath);	
			if (mapSetting.length()>0)
			{ 
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);	
				reportMessage(TN("|Settings successfully imported from| ") + sFullPath);	
			}
			setExecutionLoops(2);
			return;
		}			
	}

// Trigger ExportSettings
	if (mapSetting.length() > 0)
	{
		String sTriggerExportSettings = T("|Export Settings|");
		addRecalcTrigger(_kContext, sTriggerExportSettings );
		if (_bOnRecalc && _kExecuteKey == sTriggerExportSettings)
		{
			int bWrite;
			if (findFile(sFullPath).length()>0)
			{ 
				String sInput = getString(T("|Are you sure to overwrite existing settings?|") + " [" + T("|No|") +"/"+T("|Yes|")+"]").left(1);
				bWrite = sInput.makeUpper() == T("|Yes|").makeUpper().left(1);
			}
			else bWrite = true;
				
			if (bWrite && mapSetting.length() > 0)
			{ 
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);
				
			// make sure the path exists	//HSB-10750
				int bPathFound= sFolders.find(sFolder)>-1?true:makeFolder(sPath+"\\"+sFolder);	
				
			// write file	
				mapSetting.writeToXmlFile(sFullPath);
				
			// report rsult of writing	
				if (findFile(sFullPath).length()>0)		reportMessage(TN("|Settings successfully exported to| ") + sFullPath);
				else									reportMessage(TN("|Failed to write to| ") + sFullPath);		
			}
			
			setExecutionLoops(2);
			return;
		}
	}
	//endregion 
}
//End Dialog Trigger//endregion 

//region Clone Tools
	if (mapCloning.length()>0)
	{ 

	// get list of static tools which have been added to the subnesting
		Map mapStatics = _Map.getMap("Static[]");
		int numFreeProfile,numDrill,numBeamcut, numCut, numSlot, numMortise, numAny;
		String sEntryFreeProfile, sEntryDrill, sEntryBeamcut, sEntryCut, sEntrySlot, sEntryMortise;
		Cut cutsX[0];
		
		for (int p = 0; p < panels.length(); p++)
		{
			String key;			
			Sip& panel = panels[p];
			double oversize = oversizes[p];
			Vector3d vecZS = panel.vecZ();
	
		// trransformation model to subpanel
			CoordSys cs2sub = childs[p].sipToMeTransformation();
			cs2sub.transformBy(cs);
			
			CoordSys sub2ms = cs2sub;
			sub2ms.invert();
			Vector3d vecZMS = _ZW;
			vecZMS.transformBy(sub2ms); vecZMS.normalize();

			if (0)
			{ 
				Body bdReal = panel.realBody();
				//bdReal.vis(252);
				bdReal.transformBy(cs2sub);
				bdReal.vis(252);
			}


		// collect tools	
			AnalysedTool tools[] = panel.analysedTools();
			AnalysedBeamCut abcs[] = AnalysedBeamCut().filterToolsOfToolType(tools);
			AnalysedDrill ads[] = AnalysedDrill().filterToolsOfToolType(tools);
			AnalysedFreeProfile afps[] = AnalysedFreeProfile().filterToolsOfToolType(tools);
			AnalysedSlot aslots[] = AnalysedSlot().filterToolsOfToolType(tools);
			AnalysedCut acuts[] = AnalysedCut().filterToolsOfToolType(tools);
			AnalysedMortise amos[] = AnalysedMortise().filterToolsOfToolType(tools);
			String keyDebug="FreeProfile" ; // empty for all, else give type  = "Mortise"


		//region Clone Drills #DR
			key= "Drill";
			if ((keyDebug==key || keyDebug=="") && mapCloning.hasMap(key))
			{ 
				Map m = mapCloning.getMap(key);
				String sDiameter = m.getString("Diameter");
				String sAlignment = m.getString("Alignment");
				String sFace = m.getString("Face");
				sEntryDrill = key + "_" +sDiameter+"_"+ sAlignment + "_" + sFace;
				
				double dMinRanges[0], dMaxRanges[0];
				double dDiameters[0];
			
			//region Tokenize diameter input
				String tokens[0];
				if (sDiameter.find(";",0,false)>-1)
					tokens = sDiameter.tokenize(";");
				else
					tokens.append(sDiameter);
				
				for (int i=0;i<tokens.length();i++) 
				{ 
					String token = tokens[i];
					int n = token.find("-", 0, false);
					
				// Range	
					if (n>-1)
					{ 
						String left = token.left(n).trimLeft(). trimRight();
						String right= token.right(token.length()-n-1).trimLeft(). trimRight();
						
						double minMax[] = { left.atof(), right.atof()};
						if (minMax.first()>minMax.last())
							minMax.swap(0, 1);
							
					// not a valid range, use a s singular value
						double min = minMax.first();
						double max = minMax.last();
						if (abs(min-max)<dEps)
						{ 
							if (dDiameters.find(min)<0)
								dDiameters.append(min);
							continue;
						}
					
					// append to ranges if min not found
						if (dMinRanges.find(min)<0)
						{
							dMinRanges.append(min);
							dMaxRanges.append(max);							
						}
					}
				// Singular value
					else
					{ 
						double value = token.atof();
						if (value>0 && dDiameters.find(value)<0)
							dDiameters.append(value);					
					}
					 
				}//next i					
			//endregion
				
			//region Loop Drills
				for (int i = 0; i < ads.length(); i++)
				{
					AnalysedDrill ad = ads[i];
					Point3d ptStartExtreme = ad.ptStartExtreme();
					Point3d ptEndExtreme = ad.ptEndExtreme();
					double dDiameter = ad.dDiameter();
					
					int bAdd = sDiameter == "";//all
					if (dDiameters.find(dDiameter) >- 1)
						bAdd = true;
					else
					{
						for (int j = 0; j < dMinRanges.length(); j++)
						{
							double min = dMinRanges[j];
							double max = dMaxRanges[j];
							
							if (dDiameter > min && dDiameter <= max)
							{
								bAdd = true;
								break;
							}
						}//next j
					}
	
					// test alignment
					Vector3d vecFree = ad.vecFree();
					vecFree.transformBy(cs2sub);
					vecFree.normalize();
					
					if (sAlignment == tPerpendicular && ( ! vecFree.isParallelTo(_ZW) && !vecFree.isPerpendicularTo(_ZW)))
					{
						if(bDebug)reportMessage("\n" + sAlignment + " does not match");
						bAdd = false;
					}
					else if (sAlignment == tBeveled && (vecFree.isParallelTo(_XW) || vecFree.isParallelTo(_YW) || vecFree.isParallelTo(_ZW)))
					{
						if(bDebug)reportMessage("\n" + sAlignment + " does not match");
						bAdd = false;
					}
					
					if (sFace == tBottom && vecFree.dotProduct(_ZW) > 0)
					{
						if(bDebug)reportMessage("\n" + sFace + " does not match");
						bAdd = false;
					}
					else if (sFace == tTop && vecFree.dotProduct(_ZW) < 0)
					{
						if(bDebug)reportMessage("\n" + sFace + " does not match");
						bAdd = false;
					}
					else if (sFace == tThrough && !ad.bThrough())
					{
						if(bDebug)reportMessage("\n" + sFace + " does not match");
						bAdd = false;
					}
					else if (sFace == tEdge && !vecFree.isPerpendicularTo(_ZW))
					{
						if(bDebug)reportMessage("\n" + sFace + " does not match");
						bAdd = false;
					}
					
					//reportNotice("\n" + dDiameter + " " + (bAdd ? "" : "not ") + "accepted with alignment " + sAlignment + " on face" + sFace);						
					if (bAdd)
					{ 
						ptStartExtreme.transformBy(cs2sub);
						ptEndExtreme.transformBy(cs2sub);

						Drill drill(ptStartExtreme, ptEndExtreme, .5 * dDiameter);
						sip.addToolStatic(drill);	

						numDrill++;
					}
					
				}//next i
				numAny += numDrill;
			//endregion 

			}//endregion 
						
		//region Clone Beamcuts #BC
			key= "Beamcut";
			if ((keyDebug==key || keyDebug=="") && mapCloning.hasMap(key))
			{ 
				Map m = mapCloning.getMap(key);
				String sAlignment = m.getString("Alignment");
				String sFace = m.getString("Face");
				sEntryBeamcut = key + "_" + sAlignment + "_" + sFace;
				
			// check if tool type is already attached
				if (!bDebug)
				for (int i=0;i<mapStatics.length();i++) 
				{ 
					String staticEntry = mapStatics.getString(i);
					if (sEntryBeamcut==staticEntry)
					{
						if (bDebug)reportNotice("\n"+staticEntry + " already added");
						abcs.setLength(0); 
						break;
					}
				}//next i	

//				for (int i = 0; i < abcs.length(); i++)
//				{ 
//					AnalysedBeamCut at = abcs[i];
//					Quader qdr= at.quader();
//					Point3d pt = qdr.pointAt(0,0,0);
//					Vector3d vecXQ = qdr.vecX();
//					Vector3d vecYQ = qdr.vecY();
//					Vector3d vecZQ = qdr.vecZ();
//					
//					qdr.transformBy(cs2sub);
//					qdr.vis(i);
//				}
//
//				if (0)
				for (int i = 0; i < abcs.length(); i++)
				{
					AnalysedBeamCut at = abcs[i];
					Quader qdr= at.quader();
					Point3d pt = qdr.pointAt(0,0,0);
					Vector3d vecXQ = qdr.vecX();
					Vector3d vecYQ = qdr.vecY();
					Vector3d vecZQ = qdr.vecZ();					
					qdr.vis(i);
					ToolEnt tent = at.toolEnt();
					TslInst tsl = (TslInst)tent;

					if (tsl.bIsValid())
					{ 
						String script = tsl.scriptName();
					
//					// do not allow any tongueGroove
//						if (script.find("hsbCLT-TongueGroove", 0, false) >- 1)
//						{ 
//							continue;							
//						}
					}

					Quader qdr2= qdr;
				// extent quader in free direction to consider oversize on cloning the beamcut
					Vector3d vecs[] ={ vecXQ, vecYQ, vecZQ, -vecXQ, -vecYQ, -vecZQ};
					for (int v=0;v<vecs.length();v++) 
					{ 
						Vector3d vec = vecs[v];
						double dD = qdr.dD(vec);
						vec.vis(qdr.pointAt(0, 0, 0), v);
						
						double dLenX = qdr.dD(vecXQ);
						double dLenY = qdr.dD(vecYQ);
						double dLenZ = qdr.dD(vecZQ);

						

					// skip tools not free or with tool direction perp to xy plane	
						if (at.bIsFreeD(vec))//HSB-19015  && !vec.isParallelTo(vecZS))
						{	
							double dStretch;

						// try to stretch beamcuts at edge if free and perp to panels vecZ		
							if (vec.isPerpendicularTo(vecZS))
							{
								dStretch= dSpacing > 2*oversize ? .5*dSpacing : oversize;
							// get dimension in direction	
								double dD;
								if (v == 0 || v == 3)dD=dLenX;
								else if (v == 1 || v == 4)dD=dLenY;
								else if (v == 2 || v == 5)dD=dLenZ;

							// add gap value if on gap profile
								Point3d pt1 = qdr.pointAt(0, 0, 0)+vec*(.5*dD+dStretch);
								pt1.transformBy(cs2sub);
								Point3d pt2 = pt1;								
								if (ppGap.pointInProfile(pt1)!=_kPointOutsideProfile)
								{ 
									Vector3d vecDir = vec;		vecDir.transformBy(cs2sub);
									Vector3d vecPerp = vecDir.crossProduct(_ZW);

								// find next to pt1
									Point3d pts[] = ppGap.intersectPoints(Plane(pt1, vecPerp), true, false);
									pts = Line(pt1, vecDir).orderPoints(pts);								
									for (int pp=0;pp<pts.length();pp++) 
									{ 
										double d=vecDir.dotProduct(pts[pp]-pt1);
										if(d>dEps)
										{ 
											pt2 = pts[pp];//pts[pp].vis(v);
											break;
										}									 
									}//next pp
									
								// add to default stretch	
									if (vecDir.dotProduct(pt2-pt1)>dEps)
									{ 
										dStretch += vecDir.dotProduct(pt2 - pt1)*.5;
										//pt1.vis(p);		pt2.vis(p);	
									}									
								}
								//pt1.vis(4);									
							}
							else
							{ 
								dStretch = qdr.dD(vec);
							}
						// stretch the quader
							pt += vec * .5*dStretch;	
							if (v == 0 || v == 3)dLenX += dStretch;
							else if (v == 1 || v == 4)dLenY += dStretch;
							else if (v == 2 || v == 5)dLenZ += dStretch;
							
							qdr = Quader(pt, vecXQ,vecYQ, vecZQ, dLenX, dLenY,dLenZ,0,0,0);  
							//qdr.vis(v);
						}							 
					}//next v


					Vector3d vecSide = at.vecSide();
					vecSide.transformBy(cs2sub);
					vecSide.normalize();
					
					int bAdd = true;

					if (sAlignment == tPerpendicular && ( ! vecSide.isParallelTo(_ZW) && !vecSide.isPerpendicularTo(_ZW)))
						bAdd = false;
					else if (sAlignment == tBeveled && (vecSide.isParallelTo(_XW) || vecSide.isParallelTo(_YW) || vecSide.isParallelTo(_ZW)))
						bAdd = false;						
					if(bDebug && !bAdd)
						reportMessage("\n" + sAlignment + " does not match");
					
					if (sFace == tBottom && !at.bIsFreeD(-qdr.vecD(vecZMS)))
						bAdd = false;
					else if (sFace == tTop && !at.bIsFreeD(qdr.vecD(vecZMS)))
						bAdd = false;
					else if (sFace == tThrough && !at.bIsFreeD(-qdr.vecD(at.vecSide())))
						bAdd = false;
					else if (sFace == tEdge && !vecSide.isPerpendicularTo(_ZW))
						bAdd = false;
					if(bDebug && !bAdd)
						reportMessage("\n" + sFace + " does not match");
						

					qdr.transformBy(cs2sub);	
					pt = qdr.pointAt(0,0,0);	
					
					//vecSide.vis(pt, i);
					if (bDebug)
					{ 
						;//qdr.vis(91);
					}
					else if (bAdd)
					{ 
						BeamCut bc(pt,qdr.vecX(), qdr.vecY(), qdr.vecZ(), qdr.dD(qdr.vecX()), qdr.dD(qdr.vecY()), qdr.dD(qdr.vecZ()),0,0,0 );
						sip.addToolStatic(bc);	
						numBeamcut++;
					}
				}
				numAny += numBeamcut;
			}//endregion 

		//region Clone Freeprofiles #FP
			key= "FreeProfile";	
			if ((keyDebug==key || keyDebug=="") && mapCloning.hasMap(key))
			{ 			
				Map m = mapCloning.getMap(key);
				String toolName = m.getString("Tool");
				String face = m.getString("Face");
				sEntryFreeProfile = key + "_" + toolName + "_" + face;

//			// check if tool type is already attached
//				if (!bDebug)
//				{ 
//					for (int i=0;i<mapStatics.length();i++) 
//					{ 
//						String staticEntry = mapStatics.getString(i);
//						if (sEntryFreeProfile==staticEntry)
//						{
//							reportNotice("\n"+toolName + " at face " + face + " already added" + "\nsEntryFreeProfile "+sEntryFreeProfile +"\nstaticEntry"+staticEntry);
//							afps.setLength(0); 
//							break;
//						}
//					}//next i					
//				}
	
				ToolEnt tents[0];
				for (int i = 0; i < afps.length(); i++)
				{
					AnalysedFreeProfile at = afps[i];
					ToolEnt tent = at.toolEnt();
					TslInst tsl = (TslInst)tent; 
					Vector3d vecSide = at.vecSide();
					double dDepth = at.dDepth();
					int nCncMode = at.nCncMode();
					int machinePathOnly = at.machinePathOnly();
					int solidPathOnly = at.solidPathOnly();
					double millDiameter= at.millDiameter();
					
					Vector3d vecDir;					
					//at.genBeamQuader().vis(4);

					int bIsTongueGroove, bIsXFix, bIsFemale; 
					String script;
					if (tsl.bIsValid())
					{ 
						script = tsl.scriptName();

						bIsXFix = script.find("hsbCLT-X-Fix", 0, false) >- 1;
						bIsTongueGroove = script.find("hsbCLT-TongueGroove", 0, false) >- 1;						
	
						if (bIsXFix)
						{
							Map map = tsl.map();
							vecDir = map.getVector3d("vecDir");
						}

						else if (bIsTongueGroove)
						{ 
							Map m = tsl.map();
							vecDir = m.getVector3d("vecDir");
							
							Entity entFemales[] = m.getEntityArray("Female[]", "", "Female");// HSB-19015 used to identify male or female assignment and to swap tool direction
							if (entFemales.find(at.genBeam())>-1)
							{
								vecDir *= -1;
								bIsFemale = true;
							}
						// collect tooling entitiies to obtain grouped solid subtracts later on		
							else if (tents.find(tsl)<0)
								tents.append(tsl);
							//continue;							
						}
	
					// accept only selected scripts	
						if (toolName!=tAny && script.find(toolName, 0, false) < 0)
						{ 
							reportMessage("\n" + script + T(" |not accepted for cloning|"));
							continue;
						}						
					}

					//reportNotice("\n" + script + " accepted");


					vecSide.transformBy(cs2sub);
					Point3d ptSide = sip.ptCen() + vecSide * .5 * dH;
					vecSide.vis(ptSide, 1);

				// accept only freeprofiles on selected side
					if (face == tBottom && vecSide.dotProduct(_ZW) > 0)
					{
						if(bDebug)reportMessage("\n" + face + " does not match");
						continue;
					}
					else if (face == tTop && vecSide.dotProduct(_ZW) < 0)
					{
						if(bDebug)reportMessage("\n" + face + " does not match");
						continue;
					}
	
	
	
					PLine plTool = at.plDefining();
					plTool.transformBy(cs2sub);
					
					if (!bIsTongueGroove)
					{ 

						
						plTool.projectPointsToPlane(Plane(ptSide, vecSide), vecSide);
						if (!plTool.coordSys().vecZ().isCodirectionalTo(sip.vecZ()))
							plTool.flipNormal();
						plTool.convertToLineApprox(U(15));	
						
						plTool.vis(4);
						
					}						
				// transform direction of tongueGroove
					else if (!vecDir.bIsZeroLength())
					{ 
						vecDir.transformBy(cs2sub);
						vecDir.normalize();
						//vecDir.vis(plTool.ptMid(), bIsFemale?211:161);
					}					

					FreeProfile fp;
					if (solidPathOnly)
					{ 		
						fp = FreeProfile(plTool, 0);
						fp.setSolidPathOnly(true);
						if(millDiameter>0)
							fp.setSolidMillDiameter(millDiameter);
					}
					else if(bIsTongueGroove)
					{ 
						Point3d pt = sip.ptCen() - vecZ * (.5 * dH - dDepth);
						plTool.projectPointsToPlane(Plane(pt, vecZ), vecZ);
						Point3d ptsClose[] = { plTool.ptEnd() + vecDir * U(300), plTool.ptStart() + vecDir * U(300)};
						//ptsClose[0].vis(1);ptsClose[1].vis(2);	plTool.vis(i);
						
						Point3d ptX; ptX.setToAverage(ptsClose);
						if (ppContour.pointInProfile(ptX) == _kPointInProfile) // tongueGroove not at edge invalid
						{
							continue;
						}
								
						fp = FreeProfile(plTool, ptsClose);
						fp. setCutDefiningAsOne(true);
					}					
					else
					{ 
						fp = FreeProfile(plTool, plTool.vertexPoints(true));
						fp.setMachinePathOnly(machinePathOnly);
					}
					
					if (!bIsTongueGroove)
					{ 
						fp.setDepth(dDepth);
						
					}
					
					fp.setDoSolid(true);
					fp.setCncMode(nCncMode);
	
					if (bDebug)
					{
						fp.cuttingBody().vis(i);
					}
					else
					{
						reportMessage("\n" +" adding freeprofile of script " +script);
						sip.addToolStatic(fp);
						numFreeProfile++;
					}
					
				}// next afps				

			// Add potential solid subtracts
				for (int i=0;i<tents.length();i++) 
				{ 
					TslInst tsl= (TslInst)tents[i]; 
					if (!tsl.bIsValid())
					{ 
						continue;
					}
					Map m = tsl.map();
					Map mapSosus = m.getMap("SolidSubtract[]");
					for (int j=0;j<mapSosus.length();j++) 
					{ 
						Map m = mapSosus.getMap(j);
						Body bdx = m.getBody("SolidSubtract");
						if (bdx.isNull()){ continue;}
						bdx.transformBy(cs2sub);		//bdx.vis(6);
						SolidSubtract sosu(bdx, _kSubtract);
						sip.addToolStatic(sosu);
					}//next j
	 
				}//next i of tents
				numAny += numFreeProfile;
			}
		//endregion 
			
		//region Clone Cuts #CT
			key= "Cut";	
			if ((keyDebug==key || keyDebug=="") && mapCloning.hasMap(key))
			{ 
				Map m = mapCloning.getMap(key);
				String sAlignment = m.getString("Alignment");			
				String toolName = m.getString("Tool");
				//String face = m.getString("Face");
				sEntryCut = key + "_" + toolName;// + "_" + face;
				
			// check if tool type is already attached
				if (!bDebug)
				{ 
					for (int i=0;i<mapStatics.length();i++) 
					{ 
						String staticEntry = mapStatics.getString(i);
						if (sEntryCut==staticEntry)
						{
							if (bDebug)reportNotice("\n"+toolName + " already added"); //" at face " + face + 
							acuts.setLength(0); 
							break;
						}
					}//next i					
				}

			// Loop all cuts	
				for (int i = 0; i < acuts.length(); i++)
				{
					AnalysedCut at = acuts[i];

					ToolEnt tent = at.toolEnt();
					TslInst tsl = (TslInst)tent;
					
					int bIsTongueGroove = tsl.bIsValid() && tsl.scriptName().find("hsbCLT-TongueGroove", false ,- 1) >- 1;
					
					Vector3d vecSide = at.vecSide();
					Vector3d vecNormal= at.normal();
					double dAngle = at.dAngle();
					double dBevel= at.dBevel();
					Point3d ptOrg = at.ptOrg();
					Point3d pts[] = at.bodyPointsInPlane();
					
				//region Get additional child offset if specified //HSB-19015	
					double oversize = dOversize;
					String sSubLabel2 = at.genBeam().subLabel2().makeUpper();
					if (sSubLabel2.length()>0)
					{ 
						String sSublabel2Tokens[]=sSubLabel2.tokenize(";");
						if (sSublabel2Tokens.length()>1)
						{ 
							String sRoute = sSublabel2Tokens.first();
							double dOffset = sSublabel2Tokens.last().atof();
							if (sRoute.length()>0)	oversize=dOffset;
						}
					// compatibility to previous approach
						else if (sSubLabel2!="HU")
							oversize=dOversize;	
					}	
					
					
					if (bIsTongueGroove)
					{ 
						oversize += tsl.propDouble(7)+tsl.propDouble(9);// get depth
					}
					
				//endregion 					
	
				//region transform to subnesting	
					vecNormal.transformBy(cs2sub);	vecNormal.normalize();
					vecSide.transformBy(cs2sub);	vecSide.normalize();
					ptOrg.transformBy(cs2sub);	
					for (int p=0;p<pts.length();p++) 
							pts[p].transformBy(cs2sub);
				
					// reject no beveled cuts
					if (vecNormal.isParallelTo(vecZ))
					{ 
						vecNormal.vis(ptOrg, 6);
						continue;
					}				
				//endregion 
	
				//region Get stretch direction and order bodyPoints
					Vector3d vecStretchDir = vecNormal.crossProduct(-vecZ).crossProduct(vecZ);	vecStretchDir.normalize();
					double dAngleTo = vecStretchDir.angleTo(vecNormal);
					if (abs(dAngleTo)<.1)
					{ 
						vecNormal.vis(ptOrg, 1);
						continue;						
					}
					pts = Line(ptOrg, -vecStretchDir).orderPoints(pts, dEps);
					
				// assuming that the average bodyPoint in stretchDir can identify if the tool operates on the edge	
					int bOnEdge;
					Point3d ptIn = ptOrg;
					if (pts.length()>0)
					{ 
						ptIn.setToAverage(pts);
						ptIn += vecStretchDir * (vecStretchDir.dotProduct(pts.first() - ptIn) + oversize+dEps);
						//ptIn.vis(6);
						if (ppContour.pointInProfile(ptIn)!=_kPointInProfile)
							bOnEdge = true;
						
					}
					
				// Collect unique cuts on an edge	
					if (bOnEdge)
					{ 
						Cut cut(Cut(ptOrg, vecNormal));
					// only append if not alreday collected
						int bFound;
						for (int j=0;j<cutsX.length();j++) 
						{ 
							Point3d pt= cutsX[j].ptOrg();
							Vector3d normal= cutsX[j].normal();
							normal.vis(pt,4);
							double dd = abs(vecNormal.dotProduct(ptOrg - pt));
							if (normal.isCodirectionalTo(vecNormal) &&  abs(vecNormal.dotProduct(ptOrg-pt))<dEps)//
							{ 
								bFound = true;
								break;
							}	 	
						}//next j

					// append this cut
						if (!bFound)
						{ 
							cutsX.append(cut);
							if (bDebug)
							{
								vecNormal.vis(ptOrg, bOnEdge ? 3 : 2);vecStretchDir.vis(ptIn, 20);
							}
							else
							{ 
								sip.addToolStatic(Cut(ptOrg, vecNormal), 0);
								numCut++;								
							}	
						}

					}
				// cuts on the inside not supported yet	
					else
					{ 
						vecNormal.vis(ptOrg, 2);
					}	
				//endregion 		
	
				}// next i of acuts
				numAny += numCut;
			}//endregion 

		//region Clone Slots #SL
			key= "Slot";	
			if ((keyDebug==key || keyDebug=="") && mapCloning.hasMap(key))
			{ 
				Quader qdrSip = sip.quader();
				qdrSip.vis(4);
				
				Map m = mapCloning.getMap(key);
				//String sAlignment = m.getString("Alignment");			
				String toolName = m.getString("Tool");
				//String face = m.getString("Face");
				sEntrySlot = key + "_" + toolName;// + "_" + face;
				
			// check if tool type is already attached
				if (!bDebug)
				{ 
					for (int i=0;i<mapStatics.length();i++) 
					{ 
						String staticEntry = mapStatics.getString(i);
						if (sEntrySlot==staticEntry)
						{
							if (bDebug)reportNotice("\n"+toolName +  " already added");//" at face " + face +
							acuts.setLength(0); 
							break;
						}
					}//next i					
				}
				
			// Loop all slots	
				for (int i = 0; i < aslots.length(); i++)
				{
					AnalysedSlot at = aslots[i];

					ToolEnt tent = at.toolEnt();
					TslInst tsl = (TslInst)tent;				
					CoordSys cst = at.coordSys();
					Point3d ptSurface = at.ptOnSurface();
					Vector3d vecSide = at.vecSide();
					Quader qdr= at.quader();
					double dDepth = at.dDepth();

				//region transform to subnesting	
					qdr.transformBy(cs2sub);
					cst.transformBy(cs2sub);
					vecSide.transformBy(cs2sub);	vecSide.normalize();
					ptSurface.transformBy(cs2sub);	
				
				//endregion

				// Get point on surface and add tool
					Point3d ptX = ptSurface;
					ptX += vecSide * (vecSide.dotProduct(qdrSip.pointAt(0, 0, 0) - ptSurface) + .5 * qdrSip.dD(vecSide));	//ptX.vis(3);
					
					Point3d ptSlot;
					if (Line(ptSurface, cst.vecZ()).hasIntersection(Plane(ptX, vecSide), ptSlot))
					{ 
						double dDepthAdd = cst.vecZ().dotProduct(ptSlot-ptSurface);

//						qdr.vis(7);
//						cst.vecX().vis(ptSurface, 1);		cst.vecY().vis(ptSurface, 3);		cst.vecZ().vis(ptSurface, 150);
//						vecSide.vis(qdr.pointAt(0,0,0), 2);
						
						Slot slot(ptSlot, cst.vecX(), cst.vecY(), cst.vecZ(), qdr.dD(cst.vecX()), qdr.dD(cst.vecY()), dDepth + dDepthAdd, 0, 0, 1 );
						if (bDebug)
							slot.cuttingBody().vis(6);
						else
						{ 
							sip.addToolStatic(slot);
							numSlot++;								
						}
					}
				}// next i of aslots
				numAny += numSlot;
			}//endregion 

		//region Clone Mortise #MS
			key= "Mortise";
			if ((keyDebug==key || keyDebug=="") && mapCloning.hasMap(key))
			{ 
				Map m = mapCloning.getMap(key);
				String sAlignment = m.getString("Alignment");
				String sRoundType = m.getString("RoundType");
				
				int roundType=-1, n = tRoundTypes.find(sRoundType);// -1 = any
				if (n>-1)
					roundType = kRoundTyes[n];
	
				sEntryMortise = key + "_" + sAlignment + "_" + sRoundType;
				
			// check if tool type is already attached
				if (!bDebug)
				for (int i=0;i<mapStatics.length();i++) 
				{ 
					String staticEntry = mapStatics.getString(i);
					if (sEntryMortise==staticEntry)
					{
						if (bDebug)reportNotice("\n"+staticEntry + " already added");
						amos.setLength(0); 
						break;
					}
				}//next i	

				for (int i = 0; i < amos.length(); i++)
				{
					AnalysedMortise at = amos[i];
					Quader qdr= at.quader();
					Point3d pt = at.ptOnSurface();
					Vector3d vecXQ = qdr.vecX();
					Vector3d vecYQ = qdr.vecY();
					Vector3d vecZQ = qdr.vecZ();					
					qdr.vis(i);
					ToolEnt tent = at.toolEnt();
					TslInst tsl = (TslInst)tent;

					int nRoundType = at.nRoundType();
					double dExplicitRadius = at.dCornerRadius();



					if (tsl.bIsValid())
					{ 
						String script = tsl.scriptName();
					
//					// do not allow any tongueGroove
//						if (script.find("hsbCLT-TongueGroove", 0, false) >- 1)
//						{ 
//							continue;							
//						}
					}

//

					Vector3d vecSide = at.vecSide();
					vecSide.transformBy(cs2sub);
					vecSide.normalize();
					
					int bAdd = true;					
					if (roundType>-1 && roundType!=nRoundType)
					{ 
						bAdd = false;
						reportMessage("\n" + sRoundType + " does not match");
					}

					qdr.transformBy(cs2sub);	
					pt.transformBy(cs2sub);	
					
					Vector3d vecZT = qdr.vecD(-vecSide);
					Vector3d vecXT = qdr.vecX();
					Vector3d vecYT = vecXT.crossProduct(-vecZT);
					vecXT = vecYT.crossProduct(vecZT);

					//vecSide.vis(pt, i);
					if (bDebug)
					{ 
						pt.vis(3);
						Body bdq(pt,vecXT, vecYT, vecZT,  qdr.dD(vecXT), qdr.dD(vecYT), qdr.dD(vecZT),0,0,1 );
						bdq.vis(nRoundType);
						vecZT.vis(pt, 150);
					}
					else if (bAdd)
					{ 

						Mortise mortise(pt,vecXT, vecYT, vecZT,  qdr.dD(vecXT), qdr.dD(vecYT), qdr.dD(vecZT),0,0,1 );
						mortise.setRoundType(nRoundType);
						
						if (dExplicitRadius>0 && nRoundType==_kExplicitRadius)
							mortise.setExplicitRadius(dExplicitRadius);
						sip.addToolStatic(mortise);	
						numMortise++;
					}
				}
				numAny += numMortise;
			}//endregion 

		}//next panel

		if (numDrill>0 && sEntryDrill.length()>0)
		{ 	
			reportNotice("\n"+ numDrill + T(" |drills added.|"));
			mapStatics.appendString("Entry", sEntryDrill);
			_Map.setMap("Static[]",mapStatics);
		}
		if (numBeamcut>0 && sEntryBeamcut.length()>0)
		{ 	
			reportNotice("\n"+ numBeamcut + T(" |beamcuts added|"));
			mapStatics.appendString("Entry", sEntryBeamcut);
			_Map.setMap("Static[]",mapStatics);
		}
		if (numFreeProfile>0 && sEntryFreeProfile.length()>0)
		{ 	
			reportNotice("\n"+ numFreeProfile + T(" |free profiles added|"));
			mapStatics.appendString("Entry", sEntryFreeProfile);
			_Map.setMap("Static[]",mapStatics);
		}		
		if (numCut>0 && sEntryCut.length()>0)
		{ 	
			reportNotice("\n"+ numCut + T(" |cuts added|"));
			mapStatics.appendString("Entry", sEntryCut);
			_Map.setMap("Static[]",mapStatics);
		}		
		if (numSlot>0 && sEntrySlot.length()>0)
		{ 	
			reportNotice("\n"+ numSlot + T(" |slots added|"));
			mapStatics.appendString("Entry", sEntrySlot);
			_Map.setMap("Static[]",mapStatics);
		}
		if (numMortise>0 && sEntryMortise.length()>0)
		{ 	
			reportNotice("\n"+ numMortise + T(" |mortises added|"));
			mapStatics.appendString("Entry", sEntryMortise);
			_Map.setMap("Static[]",mapStatics);
		}		
		return;
	}
//endregion 

// get boxed contour
	PlaneProfile ppBox;
	ppBox.createRectangle(ppContour.extentInDir(vecX), vecX, vecY)	;
	ppContour.vis(4);
	ppBox.vis(3);


//region Draw potential differences
	PlaneProfile ppContourSip(csSip);		
	ppContourSip.joinRing(sip.plEnvelope(), _kAdd);
	
	PlaneProfile ppA = ppContourSip;
	ppA.subtractProfile(ppContour);
	int bSetLoopTwice;
	if (ppA.area()>pow(dEps,2))
	{ 
		Display dpA(1);
		dpA.draw(ppA, _kDrawFilled, 60);
		bSetLoopTwice = true;
	}
	PlaneProfile ppB = ppContour;
	ppB.subtractProfile(ppContourSip);
	if (ppB.area()>pow(dEps,2))
	{ 
		Display dpB(4);
		dpB.draw(ppB, _kDrawFilled, 60);
		bSetLoopTwice = true;
	}
	if (bSetLoopTwice)
		setExecutionLoops(2);
	
//End Draw potential differences//endregion 


// set to general array of ents to make reuse of snippets
	Entity ents[] ={ master};
	String k;

//region get list of available object variables
	Map mapAdditionalVariables;
	mapAdditionalVariables.setString("ChildData", sSubnestingList);
	String sObjectVariables[0];
	for (int i=0;i<ents.length();i++) 
	{ 
		String _sObjectVariables[0];
		_sObjectVariables.append(ents[i].formatObjectVariables());
		
	// append all variables, they might vary by type as different property sets could be attached
		for (int j=0;j<_sObjectVariables.length();j++)  
			if(sObjectVariables.find(_sObjectVariables[j])<0)
				sObjectVariables.append(_sObjectVariables[j]); 
	}//next
	if (sObjectVariables.find("ChildData") < 0)sObjectVariables.append("ChildData");

//region add custom variables
	for (int i=0;i<ents.length();i++)
	{ 
		//k = "Calculate Weight"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			
//	// add quantity as object variable
//		if (ents[i].bIsKindOf(GenBeam()))
//		{
//			k = "Quantity"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);	
//		}
		// Masterpanel	
		if (ents[i].bIsKindOf(MasterPanel()))
		{ 
			k = "PosNum"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "Name"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "Information"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "Style"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			
			k = "GrainDirection"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "GrainDirectionText"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "GrainDirectionTextShort"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "SurfaceQuality"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "SurfaceQualityTop"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "SurfaceQualityBottom"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "SipComponent.Name"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "SipComponent.Material"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
		}
	}	
	
// get translated list of variables
	String sTranslatedVariables[0];
	for (int i=0;i<sObjectVariables.length();i++) 
		sTranslatedVariables.append(T("|"+sObjectVariables[i]+"|")); 
	
// order alphabetically
	for (int i=0;i<sTranslatedVariables.length();i++) 
		for (int j=0;j<sTranslatedVariables.length()-1;j++) 
			if (sTranslatedVariables[j]>sTranslatedVariables[j+1])
			{
				sObjectVariables.swap(j, j + 1);
				sTranslatedVariables.swap(j, j + 1);
			}
			
//End add custom variables//endregion 


//End get list of available object variables//endregion 


//region Trigger AddRemoveFormat
//	String sTriggerAddRemoveFormat = T("|Add/Remove Format|");
//	addRecalcTrigger(_kContextRoot, sTriggerAddRemoveFormat );
//
//	if (_bOnRecalc && (_kExecuteKey=="../"+sTriggerAddRemoveFormat || _kExecuteKey==sTriggerAddRemoveFormat))
//	{
//		String sPrompt;
////		if (bHasSDV && entsDefineSet.length()<1)
////			sPrompt += "\n" + T("|NOTE: During a block setup only limited properties are accesable, but you can enter \nany valid format expression or use custom catalog entries.|");
//		sPrompt+="\n"+ T("|Select a property by index to add(+) or to remove(-)|") + T(" ,|0 = Exit|");
//		reportNotice(sPrompt);
//		
//		for (int s=0;s<sObjectVariables.length();s++) 
//		{ 
//			String key = sObjectVariables[s]; 
//			String keyT = sTranslatedVariables[s];
//			String value;
//			for (int j=0;j<ents.length();j++) 
//			{ 
//				String _value = ents[j].formatObject("@(" + key + ")");
//				if (_value.length()>0)
//				{ 
//					value = _value;
//					break;
//				}
//			}//next j
//
//			String sAddRemove = sAttribute.find(key,0, false)<0?"(+)" : "(-)";
//			int x = s + 1;
//			String sIndex = ((x<10)?"    " + x:"   " + x)+ "  "+sAddRemove+"  :";
//			
//			reportNotice("\n"+sIndex+keyT + "........: "+ value);
//			
//		}//next i
//		int nRetVal = getInt(sPrompt)-1;
//				
//	// select property	
//		while (nRetVal>-1)
//		{ 
//			if (nRetVal>-1 && nRetVal<=sObjectVariables.length())
//			{ 
//				String newAttrribute = sAttribute;
//	
//			// get variable	and append if not already in list	
//				String var ="@(" + sObjectVariables[nRetVal] + ")";
//				int x = sAttribute.find(var, 0);
//				if (x>-1)
//				{
//					int y = sAttribute.find(")", x);
//					String left = sAttribute.left(x);
//					String right= sAttribute.right(sAttribute.length()-y-1);
//					newAttrribute = left + right;
//					reportMessage("\n" + sObjectVariables[nRetVal] + " new: " + newAttrribute);				
//				}
//				else
//				{ 
//					newAttrribute+="@(" +sObjectVariables[nRetVal]+")";
//								
//				}
//				sAttribute.set(newAttrribute);
//				reportMessage("\n" + sAttributeName + " " + T("|set to|")+" " +sAttribute);	
//			}
//			nRetVal = getInt(sPrompt)-1;
//		}
//	
//		setExecutionLoops(2);
//		return;
//	}	
//	
//	
//endregion 


//region Tag Display
// resolve variables
	String sValues[0];
	{
		String s=  master.formatObject(sAttribute, mapAdditionalVariables);

		int left= s.find("\\P",0);
		while(left>-1)
		{
			sValues.append(s.left(left));
			s = s.right(s.length() - 2-left);
			left= s.find("\\P",0);
		}
		sValues.append(s);
	}	
		
// resolve unknown
	//reportMessage("\n"+ scriptName() + " values i "+i +" " + sValues);
	String sLines[0];
	for (int v= 0; v < sValues.length(); v++)
	{
		String& value = sValues[v];
		int left = value.find("@(", 0);
		
	// get formatVariables and prefixes
		if (left>-1)
		{ 
			// tokenize does not work for strings like '(@(KEY))'
			String sTokens[0];
			while (value.length() > 0)
			{
				left = value.find("@(", 0);
				int right = value.find(")", left);
				
			// key found at first location	
				if (left == 0 && right > 0)
				{
					String sVariable = value.left(right + 1).makeUpper();

					if (sVariable=="@(POSNUM)") sTokens.append(master.number());
					else if (sVariable=="@(NAME)") sTokens.append(master.name());
					else if (sVariable=="@(INFORMATION)") sTokens.append(master.information());
					else if (sVariable=="@(STYLE)") sTokens.append(master.style());
					else if (sVariable=="@(GRAINDIRECTIONTEXT)")sTokens.append(vecGrain.isParallelTo(_XW) ? T("|Lengthwise|") : T("|Crosswise|"));
					else if (sVariable=="@(GRAINDIRECTIONTEXTSHORT")sTokens.append(vecGrain.isParallelTo(_XW) ? T("|Grain LW|") : T("|Grain CW|"));
					else if (sVariable=="@(surfaceQualityBottom)".makeUpper())sTokens.append(sqBottom);	
					else if (sVariable=="@(surfaceQualityTop)".makeUpper())	sTokens.append(sqTop);	
					else if (sVariable=="@(SURFACEQUALITY)")
					{
						String sQualities[] ={sqBottom, sqTop};
						if (sip.vecZ().dotProduct(vecZ)>0)sQualities.swap(0, 1);
						String sQuality = sQualities[0] + " (" + sQualities[1] + ")";
						sTokens.append(sQuality);	
					}
					else if (sVariable=="@(Graindirection)".makeUpper())	
						sTokens.append("        ");// 8 blanks					
					else if (sVariable=="@(SipComponent.Name)".makeUpper())
					{
						SipComponent component = SipStyle(sip.style()).sipComponentAt(0);
						sTokens.append(component.name());								
					}
					else if (sVariable=="@(SipComponent.Material)".makeUpper())
					{
						SipComponent component = SipStyle(sip.style()).sipComponentAt(0);
						sTokens.append(component.material());								
					}	
					value = value.right(value.length() - right - 1);
				}
			// any text inbetween two variables	
				else if (left > 0 && right > 0)
				{
					sTokens.append(value.left(left));
					value = value.right(value.length() - left);
				}
			// any postfix text
				else
				{
					sTokens.append(value);
					value = "";
				}
			}

			for (int j=0;j<sTokens.length();j++) 
				value+= sTokens[j]; 
		}
		//sAppendix += value;
		sLines.append(value);
	}		

// declare mapReuests
	Map mapRequests;


// build text
	String sText;
	int nNumLineGrain = -1; // the index of the line where a potential grain pline will be drawn
	for (int i=0;i<sLines.length();i++) 
	{
		String sLine = sLines[i];
		sText+= (i>0?"\\P":"")+sLine; 
		if (sLine.find("        ",0)>-1)nNumLineGrain = i;
	}


// draw tag
	dp.draw(sText, _Pt0, vecX, vecY, 0, 0);		
	{ 
		Map mapRequest;
		mapRequest.setInt("Color", nc); // optional
		mapRequest.setVector3d("AllowedView", csSip.vecZ()); 
		mapRequest.setInt("AlsoReverseDirection", true); // optional
		mapRequest.setVector3d("vecDimLineDir", vecX);
		mapRequest.setVector3d("vecPerpDimLineDir", -vecZ);
		mapRequest.setString("Text", sText); // "*" to collect any
		mapRequest.setDouble("textHeight", dTextHeight); 
		mapRequest.setPoint3d("ptLocation", _Pt0);
		mapRequest.setVector3d("vecX", csSip.vecX());
		mapRequest.setVector3d("vecY", csSip.vecY());
		mapRequests.appendMap("DimRequest", mapRequest);		
	}
	
	
//	Map mapRequest,mapRequests; 
//	mapRequest.setString("DimRequestPoint", "DimRequestPoint"); // "DimRequestPoint" is the keyword for DimRequestPoint
//	mapRequest.setVector3d("AllowedView", vecY); 
//	mapRequest.setInt("AlsoReverseDirection", rue); // optional
//	mapRequest.setVector3d("vecDimLineDir", vecX);
//	mapRequest.setVector3d("vecPerpDimLineDir", -vecZ);
//	mapRequest.setString("stereotype", sStereotype); // "*" to collect any
//	mapRequest.setPoint3d("ptLocation", pt);
//	mapRequest.setPoint3dArray("Node[]", pts); // optional to store an array of points
//	mapRequest.setPoint3dArray("RefPoint[]", ptsRef);//optional
//	mapRequests.appendMap("DimRequest", mapRequest);	
//		
//	_Map.setMap("DimRequest[]", mapRequests);	

	
//End Tag Display//endregion 

//region draw grain direction if applicable
	if (nNumLineGrain >- 1)
	{
		Vector3d vecXGrain = sip.woodGrainDirection();
		Vector3d vecYGrain = vecXGrain.crossProduct(sip.vecZ());
		double dTextHeightDisplay = dp.textHeightForStyle(sText, sDimStyle, dTextHeightStyle);
		double dHeightLine = dTextHeightDisplay / sLines.length();	
		Point3d ptX = _Pt0 + vecY * (.5 * dTextHeightDisplay - (nNumLineGrain+.5) * dHeightLine);//ptX.vis(2);
		PLine plGrainSymbol(vecZ);

		{ 	
			Quader qdr(ptX, vecX, vecY, vecZ, 2 * dHeightLine, .5*dHeightLine, dHeightLine, 0, 0, 0);
			double dXG = qdr.dD(vecXGrain);
			
			plGrainSymbol.addVertex(ptX + (vecXGrain * .5*dXG - vecYGrain * dXG*.25));
			plGrainSymbol.addVertex(ptX + (vecXGrain * dXG));
			plGrainSymbol.addVertex(ptX + (-vecXGrain * dXG));
			plGrainSymbol.addVertex(ptX + (-vecXGrain * .5*dXG + vecYGrain * dXG*.25));				
		}
		dp.draw(plGrainSymbol);	

		{
			Map mapRequest;
			mapRequest.setPLine("Pline", plGrainSymbol);
			mapRequest.setInt("DrawFilled", _kDrawAsCurves);
			mapRequest.setInt("Color", nc);
			mapRequest.setVector3d("AllowedView", csSip.vecZ()); 
			mapRequest.setInt("AlsoReverseDirection", true); // optional
			mapRequests.appendMap("DimRequest", mapRequest);		
		}	

	}
//End draw grain direction if applicable//endregion 

//region Draw childs
// show child outlines
	dp.color(ncChild);
	Plane pnFace(ptFace, csSip.vecZ());
	Map mapRequest;
	mapRequest.setInt("DrawFilled", _kDrawAsCurves);
	
	mapRequest.setVector3d("AllowedView", csSip.vecZ()); 
	mapRequest.setInt("AlsoReverseDirection", true); // optional	
	if (sLineType!="CONTINUOUS" && dLineTypeScale>0)
	{ 
		dp.lineType(sLineType, dLineTypeScale);
		mapRequest.setString("LineType", sLineType);
		mapRequest.setDouble("LineTypeScale", dLineTypeScale);
	}
	
	for (int i=0;i<ppChilds.length();i++) 
	{ 
		PlaneProfile pp= ppChilds[i]; 
		pp.transformBy(cs);
		
		PLine rings[0];
		
	// Contour
		dp.color(ncChild);
		mapRequest.setInt("Color", ncChild);
		rings = pp.allRings(true, false);
		for (int r=0;r<rings.length();r++) 
		{ 
			PLine pl = rings[r];
			pl.projectPointsToPlane(pnFace, csSip.vecZ());
			dp.draw(pl);
			
			mapRequest.setPLine("Pline", pl);
			mapRequests.appendMap("DimRequest", mapRequest);
		}//next r

	// Openings
		dp.color(ncOpening);
		mapRequest.setInt("Color", ncOpening);
		rings = pp.allRings(false,true);
		for (int r=0;r<rings.length();r++) 
		{ 
			PLine pl = rings[r];
			pl.projectPointsToPlane(pnFace, csSip.vecZ());
			dp.draw(pl);
			
			mapRequest.setPLine("Pline", pl);
			mapRequests.appendMap("DimRequest", mapRequest);
		}//next r


	}//next i

	


	
	
//End Draw childs//endregion 

_Map.setMap("DimRequest[]", mapRequests);




//reportNotice("\n"+ scriptName() + " ended " + _ThisInst.handle() + " elapsed " + (getTickCount()-tick));
//








#End
#BeginThumbnail
M_]C_X``02D9)1@`!``$`8`!@``#__@`?3$5!1"!496-H;F]L;V=I97,@26YC
M+B!6,2XP,0#_VP"$``("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("
M`@("`@,#`@(#`@("`P0#`P,#!`0$`@,$!`0$!`,$!`,!`@("`@("`@("`@,"
M`@(#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#
M`P,#`P,#`__$`:(```$%`0$!`0$!```````````!`@,$!08'"`D*"P$``P$!
M`0$!`0$!`0````````$"`P0%!@<("0H+$``"`0,#`@0#!04$!````7T!`@,`
M!!$%$B$Q008346$'(G$4,H&1H0@C0K'!%5+1\"0S8G*""0H6%Q@9&B4F)R@I
M*C0U-C<X.3I#1$5&1TA)2E-455976%E:8V1E9F=H:6IS='5V=WAY>H.$A8:'
MB(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4U=;7
MV-G:X>+CY.7FY^CIZO'R\_3U]O?X^?H1``(!`@0$`P0'!00$``$"=P`!`@,1
M!`4A,08205$'87$3(C*!"!1"D:&QP0DC,U+P%6)RT0H6)#3A)?$7&!D:)B<H
M*2HU-C<X.3I#1$5&1TA)2E-455976%E:8V1E9F=H:6IS='5V=WAY>H*#A(6&
MAXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&Q\C)RM+3U-76
MU]C9VN+CY.7FY^CIZO+S]/7V]_CY^O_``!$(`2P!D`,!$0`"$0$#$0'_V@`,
M`P$``A$#$0`_`/W\H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@
M`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@
M`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@
M`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@
M`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@
M`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@
M`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@
M`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`
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
70`4`%`!0`4`%`!0`4`%`!0`4`%`'_]D`






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
        <int nm="BreakPoint" vl="2494" />
        <int nm="BreakPoint" vl="2373" />
        <int nm="BreakPoint" vl="876" />
        <int nm="BreakPoint" vl="2603" />
        <int nm="BreakPoint" vl="2656" />
        <int nm="BreakPoint" vl="2633" />
        <int nm="BreakPoint" vl="2202" />
        <int nm="BreakPoint" vl="2263" />
        <int nm="BreakPoint" vl="2277" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19709 X-Fix added if defined by freeprofile" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="7/31/2023 4:23:51 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19709 new context commands to clone and remove mortises " />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="7/31/2023 2:58:48 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19025 Slots can be cloned, settings can be accessed via context command" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="5/24/2023 10:42:56 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19025 beveled cuts operating on the edge of a panel can be cloned" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="5/23/2023 3:34:04 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19015 subnesting respects sublabel based override of oversize, tongue and groove connections accepted for tool cloning" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="5/23/2023 8:45:48 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15604 new context commands to clone beamcuts, freeprofiles supporting parent tsls. Sequential adding supported." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="5/31/2022 5:26:16 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15604 new context commands to clone beamcuts" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="5/31/2022 8:43:29 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15542 new context command to clone drills as static tool to the subnesting" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="5/25/2022 1:33:51 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12521 Reference changed to lower right corner of subnesting" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="7/6/2021 3:07:51 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11998 transformation subnesting published" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="5/26/2021 1:29:27 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11860 name formatting corrected (information and name are separated by  default with '_')" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="5/11/2021 4:51:59 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11860 name and order# (grade property) are written into a concatenated string (hsbSubnesting.ChildData)" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="5/11/2021 1:22:46 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11858 contour detection enhanced, oversize of parent masterpanel-manager considered, openings supported" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="5/11/2021 11:16:48 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End