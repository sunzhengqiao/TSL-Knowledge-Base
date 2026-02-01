#Version 8
#BeginDescription
#Versions
4.7 13.03.2024 HSB-21653: Erase instance if invalid data found  
4.6 06.09.2023 HSB-19977: Set flag to False for "addRoofplanesAboveWallsAndRoofSectionsForRoofs" for TSLs "Soligno-AbrechnungBearbeitung" 
4.5 20230714: Holzius, include defining entity
4.4 16.02.2023 HSB-17987: show scriptName in reportMessages 
Version 4.3 12.12.2022 HSB-17929 consumes showset of multipage , 
Version 4.2 26.02.2021 HSB-8999 bugfix empty line feed with bottom alignment 
HSB-7776 cell content will be trimmed if exceeds column width (min 3 characters) 
HSB-7370 new context command to set the first column as subheader, requires first sorting criteria to be set for first column
HSB-5852 masterpanels added to supported entity types 
HSB-4832 etools added to export linked hardware

HSBCAD-542  massgroups and masselements assigned to an element will output there values in paperspace

DACH
Diese TSL erzeugt Bauteilliste basierend auf einer Berichtsdefinition des hsbExcelReport Designers.
/// Dieses TSL kann im Modellbereich, in einer Einzelzeichnung oder im Elementlayout verwendet werden.

/// Wählen Sie zunächst den Berichtsnamen und bestätigen Sie die Eingabe mit OK.
/// Wählen Sie nun einen Teilbericht und alle weiteren Eigenschaften aus.
/// Alternativ kann durch die Angabe eines Katalogeintrages die Anzeige des Eigneschaftsdialoges übersprungen werden.
/// Beispiel: ^C^C(hsb_scriptinsert "hsbReport" "Element") verwendet den Katalogeintrag 'Element'
/// Über einen Kontextbefehl kann die verwendete Berichtsdefinition auch nachträglich geändert werden.


EN
This tsl creates a report based on a report definition of the hsbExcelReport Designer.
This TSL can be used in model, in multipage definitions or in element layout.






#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 4
#MinorVersion 7
#KeyWords BOM;Report;Schedule;List;Output
#BeginContents
//region History

/// <summary Lang=de>
/// Diese TSL erzeugt Bauteilliste basierend auf einer Berichtsdefinition des hsbExcelReport Designers.
/// Dieses TSL kann im Modellbereich, in einer Einzelzeichnung oder im Elementlayout verwendet werden.
/// </summary>

/// <insert Lang=de>
/// Wählen Sie zunächst den Berichtsnamen und bestätigen Sie die Eingabe mit OK.
/// Wählen Sie nun einen Teilbericht und alle weiteren Eigenschaften aus.
/// Alternativ kann durch die Angabe eines Katalogeintrages die Anzeige des Eigneschaftsdialoges übersprungen werden.
/// Beispiel: ^C^C(hsb_scriptinsert "hsbReport" "Element") verwendet den Katalogeintrag 'Element'
/// Über einen Kontextbefehl kann die verwendete Berichtsdefinition auch nachträglich geändert werden.
/// </insert>

/// <summary Lang=en>
/// This tsl creates a report based on a report definition of the hsbExcelReport Designer.
/// This TSL can be used in model, in multipage definitions or in element layout.
/// </summary>

/// <insert Lang=en>
/// Select a report name and confirm with OK
/// Select the sub report (section) and remaining properties
/// Alternativly one can call the command without showing the dialog by using a catalog entry
/// Sample: ^C^C(hsb_scriptinsert "hsbReport" "Element") uses the catalog entry 'Element'
/// One can change the report definition by the custom command 'Change Report Definition'.
/// </insert>

/// History
// #Versions
// 4.7 13.03.2024 HSB-21653: Erase instance if invalid data found  Author: Marsel Nakuci
// 4.6 06.09.2023 HSB-19977: Set flag to False for "addRoofplanesAboveWallsAndRoofSectionsForRoofs" for TSLs "Soligno-AbrechnungBearbeitung" Author: Marsel Nakuci
// 4.4 16.02.2023 HSB-17987: show scriptName in reportMessages Author: Marsel Nakuci
// 4.3 12.12.2022 HSB-17929 consumes showset of multipage , Author Thorsten Huck
// 4.2 26.02.2021 HSB-8999 bugfix empty line feed with bottom alignment , Author Thorsten Huck
///<version value="4.1" date="28may20" author="thorsten.huck@hsbcad.com"> HSB-7776 cell content will be trimmed if exceeds column width (min 3 characters) </version>
///<version  value="4.0" date="25may20" author="thorsten.huck@hsbcad.com"> HSBCAD-7370 new context command to set the first column as subheader, requires first sorting criteria to be set for first column</version>
///<version  value="3.9" date="30apr20" author="david.delombaerde@hsbcad.com"> HSBCAD-6656 masterpanels added to recalctriggers add entities and remove entities </version>
///<version  value="3.8" date="11nov19" author="thorsten.huck@hsbcad.com"> HSBCAD-5852 masterpanels added to supported entity types </version>
///<version  value="3.7" date="04apr19" author="thorsten.huck@hsbcad.com"> HSBCAD-4832 etools added to export linked hardware </version>
///<version  value="3.6" date="21feb19" author="thorsten.huck@hsbcad.com"> HSBCAD-542 bugfix </version>
///<version  value="3.5" date="20feb19" author="thorsten.huck@hsbcad.com"> HSBCAD-542 massgroups and masselements assigned to an element will output there values in paperspace </version>
///<version  value="3.4" date="22dec17" author="thorsten.huck@hsbcad.com"> bugfix area and volume values </version>
///<version  value="3.3" date="27jun17" author="thorsten.huck@hsbcad.com"> supports resolving of referenced items of tsl entity array </version>
///<version  value="3.2" date="23jun17" author="thorsten.huck@hsbcad.com"> summary function also enabled for string based values (property set data)</version>
///<version  value="3.1" date="09may17" author="thorsten.huck@hsbcad.com"> summary function of report definition enabled </version>
///<version  value="3.0" date="24may16" author="thorsten.huck@hsbcad.com"> empty rows will be ignored (string bugfix) </version>
///<version  value="2.9" date="23may16" author="thorsten.huck@hsbcad.com"> empty rows will be ignored </version>
///<version  value="2.8" date="02dec14" author="th@hsbCAD.de"> empty rows will be ignored, II </version>
///<version  value="2.7" date="05nov14" author="th@hsbCAD.de"> decimal points fixed, empty rows will be ignored </version>
///<version  value="2.6" date="12sep14" author="th@hsbCAD.de"> first official release </version>
///<version  value="2.5" date="29aug14" author="th@hsbCAD.de"> zone selection in viewport mode enhanced </version>
///<version  value="2.4" date="29aug14" author="th@hsbCAD.de"> new context command to toggle visible items </version>
///<version  value="2.3" date="30apr14" author="th@hsbCAD.de"> text height scales column width </version>
///<version  value="2.2" date="17mar14" author="th@hsbCAD.de"> bugfixes </version>
///<version  value="2.1" date="29jan14" author="th@hsbCAD.de"> report stores report definition to support file transfer and/or missing report definition, hidden columns supported, header overrides added, catalog based creation supported</version>
///<version  value="2.0" date="22.oct12" author="th@hsbCAD.de">initial</version>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "_hsbReport")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "../|Disable first column as subheader|") (_TM "|Select schedule table|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "../|Set first column as subheader|") (_TM "|Select schedule table|"))) TSLCONTENT
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
	
	
	String strAssemblyPath = _kPathHsbInstall + "\\Utilities\\hsbExcel\\hsbExcel.dll";
	String strType = "hsbSoft.Cad.Reporting.ReportTslHelper";

// unit conversion constants	
	String sUnits[] = {"Meter","Centimeter","Millimeter"};
	double dUnits[] = {1000,10,1};	
//end constants//endregion

// property names	and other string constants
	String sReportEntryName=  T("|Report Name|");	
	String sSectionEntryName=  T("|Sub Report|");
	String sDimstyleName = T("|Dimstyle|");	
	String sTextHeightName = T("|Text Height|");	

	String sColumnWidthName =  T("|Column Widths|");
	String sDecimalsName =  T("|Decimals|");
	String sHeaderOverridesName=  T("|Header Overrides|");
	String sDescriptionName=  T("|Description|");	
	String sAlignmentName = T("|Alignment|");
	String sDirectionName = T("|Direction|");

	String sColorName= T("|Color|");
	String sColor2Name= T("|Color|") + T("|Child Entities|");
	
	String sAlignments[] = {T("|Horizontal|"),T("|Vertical|")};
	String sDirections[] = {T("|Bottom|"),T("|Top|")};


// order dimstyles
	String sDimstyles[0];sDimstyles = _DimStyles;
	for (int i=0;i<sDimstyles .length();i++)
		for (int j=0;j<sDimstyles.length()-1;j++)
			if (sDimstyles[j]>sDimstyles[j+1])
				sDimstyles.swap(j,j+1);


// property categories
	String sCat1 = T("|Alignment|");
	String sCat2 = T("|Format|");
	String sCat3 = T("|Size|");
	
	
	
// Query existing reports
	// CallDotNet1 method that accepts the following parameters in the input array.
	// Index 0 - the full path of the company folder.
	// all reports are returned
	String sArguments[0];
	sArguments.append(_kPathHsbCompany);
	String sReportEntries[] = callDotNetFunction1(strAssemblyPath, strType, "Reports", sArguments);
	
// if the instance is already created it should have the report name stored. check if this name is avalable in all reportnames	
	String sReportEntryFromMap = _Map.getString("ReportEntry");
	if (sReportEntryFromMap.length()>0 && sReportEntries.find(sReportEntryFromMap)<0)
		sReportEntries.append(sReportEntryFromMap);	

	PropString sReportEntry(4, sReportEntries, sReportEntryName);	
	sReportEntry.setDescription(T("|Defines the parent report name|"));
	

// declare array of available Sub Reports
	String sSectionEntries[0];	

	
// summary variables
	String sSummaryTypes[]={ "Sum"};
	
	
// on insert
	if (_bOnInsert) 
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		
	// get a potential catalog entry name from the executeKey and validate it	
		String sEntry = _kExecuteKey;
		int bHasEntry;		
		if (sEntry.length()>0)
		{
			String sEntryUpper = sEntry;sEntryUpper.makeUpper();
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			for (int i=0;i<sEntries.length();i++)
			{
				String s=sEntries[i].makeUpper();
				if (s==sEntryUpper)
				{
				// set the properties
					setPropValuesFromCatalog(sEntry);
				// validate the values from catalog
				// check if the report selected by name is available
					bHasEntry=sReportEntries.find(sReportEntry)>-1;
					//if (bDebug) reportMessage("\ncatalog " + s + " found. The requested report " + sReportEntry + " is " + bHasEntry);
					if (bHasEntry)
						break;	
				}
			}
		}

	// if the no catalog entry was specified or it could not be found
	// show the dialog and select the report name first
		if (!bHasEntry)
		{				
			showDialog();
			sReportEntry.setReadOnly(true);
			setCatalogFromPropValues(sLastInserted);		
		}		

	// GetReportSections
		// CallDotNet1 method that accepts the following parameters in the input array.
		// Index 0 - the full path of the company folder.
		// Index 1 - the name of the report to get the sections for.
		String sArgumentsIn[0];
		sArgumentsIn.append(_kPathHsbCompany);		
		sArgumentsIn.append(sReportEntry);	
		//reportMessage("\nentry="+sReportEntry + "sArgumentsIn" + sArgumentsIn);
		sSectionEntries = callDotNetFunction1(strAssemblyPath, strType, "GetReportSections", sArgumentsIn);
					
		PropString sSectionEntry(1, sSectionEntries, sSectionEntryName,0);	
		sSectionEntry.setReadOnly(false);
		PropString sDescription(7, "", sDescriptionName);	
		PropString sAlign(2, sAlignments, sAlignmentName);	
		sAlign.setCategory(sCat1);	
		PropString sDirection(3, sDirections, sDirectionName);
		sDirection.setCategory(sCat1);
		PropString sHeaderOverrides(8, "", sHeaderOverridesName);
		sHeaderOverrides.setDescription(T("|Specifies overrides for each header of the columns.|") + " " + T("|Separate multiple entries by|")+ "' ;'");	
		
		PropString sColumnWidth(5, "", sColumnWidthName);
		sColumnWidth.setDescription(T("|Specify width of each column.|") + " " + T("|Separate multiple entries by|")+ "' ;'");	
		sColumnWidth.setCategory(sCat3);	
		PropString sDecimals(6, "", sDecimalsName );
		sDecimals.setDescription(T("|Specify the number of decimals.|") + " " + T("|Separate multiple entries by|")+ "' ;'");			
		sDecimals.setCategory(sCat2);	
		
		PropString sDimStyle(0, sDimstyles, sDimstyleName);
		sDimStyle.setCategory(sCat2);	
		PropDouble dTxtH(0,U(100), sTextHeightName);
		dTxtH.setCategory(sCat3);	
		PropInt nColor(0,0, sColorName);
		nColor.setCategory(sCat2);	
		PropInt nColor2(1,10, sColor2Name);	
		nColor2.setCategory(sCat2);
				
	// now select remaining properties
		if (!bHasEntry)		
			showDialog(sLastInserted);	
	// if executeKey expresses an valid entry set the properties by catalog		
		else
		{
			int bHasSection=sSectionEntries.find(sSectionEntry)>-1;
			if (bHasSection)	
				setPropValuesFromCatalog(sEntry);
			else
				showDialog();					
		}

	// mode
		int nMode=-1;// 0 = modelspace, 1=shopdraw space , 2=paperspace(element layout)

	// distinguish selection mode bySpace
		Entity viewEnts[] = Group().collectEntities(true, ShopDrawView(), _kMySpace);
		// shopdrawViews found: block space of a multipage
		if (viewEnts.length()>0)
		{
			_Entity.append(getShopDrawView());
			nMode=1;
		}
		// switch to paperspace succeeded: paperspace with viewports
		else if (Viewport().switchToPaperSpace())
		{
			_Viewport.append(getViewport(T("|Select a viewport|")));
			nMode=2;
		}
		// modelspace
		else
		{ 
		// declare a prompt	
			String sPrompt = T("|Select entities|");
			PrEntity ssE(sPrompt);		
		// add types
			ssE.addAllowedClass(GenBeam());
			ssE.addAllowedClass(Element());
			ssE.addAllowedClass(TslInst());
			ssE.addAllowedClass(MassGroup());
			ssE.addAllowedClass(FastenerAssemblyEnt());
			ssE.addAllowedClass(CollectionEntity());
			ssE.addAllowedClass(Opening());
			ssE.addAllowedClass(MasterPanel());
			
			if (ssE.go())
				_Entity.append(ssE.set());
			nMode=0;	
		}
	
	
	// nothing valid selected
		if (_Entity.length()<1 && _Viewport.length()<1)
			eraseInstance();
		_Pt0 = getPoint(T("|Pick insertion point|"));
		_Map.setInt("mode", nMode);
		return;					
	}// END on insert  _______________________________________________________________________END on insert 	

// if not on insert the current report needs to be validated (in case company structure has changed and report cannot be found
	else
	{
	// GetReportSections
		// CallDotNet1 method that accepts the following parameters in the input array.
		// Index 0 - the full path of the company folder.
		// Index 1 - the name of the report to get the sections for.
		String sArgumentsIn[0];
		sArgumentsIn.append(_kPathHsbCompany);		
		sArgumentsIn.append(sReportEntry);	
		sSectionEntries = callDotNetFunction1(strAssemblyPath, strType, "GetReportSections", sArgumentsIn);

	// if the report cannot be found the list of section mames would be empty -> append the section name which was perviously used	
		String sSectionEntryFromMap = _Map.getString("SectionEntry").makeUpper();
		if (sSectionEntryFromMap.length()>0)
		{
		// loop entries and compare one by one as find() would ignore cases and it might be appended twice
			int bFound;
			for (int i=0;i<sSectionEntries.length();i++)
			{
				String s = sSectionEntries[i];
				s.makeUpper();
				if (sSectionEntryFromMap==s)
				{
					bFound=true;
					break;	
				}
			}
			if (!bFound)
				sSectionEntries.append(sSectionEntryFromMap);
		}
			
									
	}

// validate selection set
	if (_Entity.length()<1 && _Viewport.length()<1)
	{
		reportMessage("\n"+scriptName()+" "+T("|invalid selection set|"));
		eraseInstance();
		return;
	}

	
// redeclare properties	
	PropString sSectionEntry(1, sSectionEntries, sSectionEntryName,0);
	PropString sDescription(7, "", sDescriptionName);	
	PropString sAlign(2, sAlignments, sAlignmentName);		
	sAlign.setCategory(sCat1);	
	PropString sDirection(3, sDirections, sDirectionName);
	sDirection.setCategory(sCat1);
	PropString sHeaderOverrides(8, "", sHeaderOverridesName);
	sHeaderOverrides.setDescription(T("|Specifies overrides for each header of the columns.|") + " " + T("|Separate multiple entries by|")+ "' ;'");	

	PropString sColumnWidth(5, "", sColumnWidthName);
	sColumnWidth.setDescription(T("|Specify width of each column.|") + " " + T("|Separate multiple entries by|")+ "' ;'");	
	sColumnWidth.setCategory(sCat3);		
	PropString sDecimals(6, "", sDecimalsName );
	sDecimals.setDescription(T("|Specify the number of decimals.|") + " " + T("|Separate multiple entries by|")+ "' ;'");	
	sDecimals.setCategory(sCat2);	
	PropString sDimStyle(0, sDimstyles, sDimstyleName);	
	sDimStyle.setCategory(sCat2);	
	PropDouble dTxtH(0,U(100), sTextHeightName);			
	dTxtH.setCategory(sCat3);
	PropInt nColor(0,0, sColorName);	
	nColor.setCategory(sCat2);		
	PropInt nColor2(1,10, sColor2Name);	
	nColor2.setCategory(sCat2);

	
// invalid section name
	if (sSectionEntries.find(sSectionEntry)<0)
	{
		if (sSectionEntries.length()>0)
		{
			sSectionEntry.set(sSectionEntries[0]);
		}
		else
		{
			reportMessage("\n"+scriptName()+" "+T("|Invalid Section Name|"));
			eraseInstance();
			return;				
		}
	}

// my coordSys
	Vector3d vecX,vecY,vecZ;
	vecX=_XW;
	vecY=_YW;
	vecZ=_ZW;
	_Pt0.vis(1);

// get ints
	int nAlign= sAlignments.find(sAlign);	
	int nDir= sDirections.find(sDirection);
	int bShowDependencies = _Map.getInt("ShowDependencies");
	int bShowOnlyVisible=_Map.getInt("ShowOnlyVisible");
	
// swap vecs if vertical alignment
	if (nAlign>0)
	{
		vecX = _YW;
		vecY = -_XW;
	}

// collect potentially defined header overrides	
	String sHeaders[0];
	String sList = sHeaderOverrides;
	for (int i = 0; i < 3; i++)
	{
		while (sList.length()>0 || sList.find(";",0)>-1)
		{
			String sToken = sList.token(0);	
			sToken.trimLeft().trimRight();	
			sHeaders.append(sToken);
			int x = sList.find(";",0);
			sList.delete(0,x+1);
			sList.trimLeft();	
			if (x==-1)
				sList = "";	
		}
	}
		
// collect potentially defined column width	
	double dColumnWidths[0];
	sList = sColumnWidth;
	for (int i = 0; i < 3; i++)
	{
		while (sList.length()>0 || sList.find(";",0)>-1)
		{
			String sToken = sList.token(0);	
			sToken.trimLeft().trimRight().makeUpper();
			double d = 	abs(sToken.atof());
		// scale value if textheight has changed
			if (_kNameLastChangedProp ==sTextHeightName && d>0)
			{
				double dPrevTextHeight = _Map.getDouble("textHeight");
				if (dPrevTextHeight>0)
				{
					d = d*dTxtH/dPrevTextHeight;
				}		
			}	
			
			dColumnWidths.append(d);
			int x = sList.find(";",0);
			sList.delete(0,x+1);
			sList.trimLeft();	
			if (x==-1)
				sList = "";	
		}
	}
	if (_kNameLastChangedProp ==sTextHeightName)
	{
		String sValue;
		for (int i=0;i<dColumnWidths.length();i++)
		{
			if (i!=dColumnWidths.length()-1)
				sValue+=dColumnWidths[i]+"; ";
			else
				sValue+=dColumnWidths[i];
		}			
		sColumnWidth.set(sValue);	
		_PtG.setLength(0);	
	}

// collect potentially defined decimals	
	int nArDecimals[0];
	sList = sDecimals;
	for (int i = 0; i < 3; i++)
	{
		while (sList.length()>0 || sList.find(";",0)>-1)
		{
			String sToken = sList.token(0);	
			sToken.trimLeft().trimRight().makeUpper();	
			nArDecimals.append(abs(sToken.atoi()));
			int x = sList.find(";",0);
			sList.delete(0,x+1);
			sList.trimLeft();	
			if (x==-1)
				sList = "";	
		}
	}	


// get mode
	int nMode=_Map.getInt("mode"); // 0 = modelspace, 1=shopdraw space , 2=paperspace(element layout)	



// add change report trigger
	String sTriggerChangeReportDef = T("|Change Report Definition|");
	addRecalcTrigger(_kContext, sTriggerChangeReportDef);

// trigger Change Report Definition
	if (_bOnRecalc && _kExecuteKey==sTriggerChangeReportDef)
	{
		_Map.removeAt("SectionName", true);
		sReportEntry.setReadOnly(false);
		sSectionEntry.setReadOnly(true);
		//setCatalogFromPropValues(sLastInserted);	
		showDialog();//sLastInserted);
		sReportEntry.setReadOnly(true);
		sSectionEntry.setReadOnly(false);	

		String sArgumentsIn[0];
		sArgumentsIn.append(_kPathHsbCompany);		
		sArgumentsIn.append(sReportEntry);	
		sSectionEntries = callDotNetFunction1(strAssemblyPath, strType, "GetReportSections", sArgumentsIn);

		//sReportEntry = PropString(4, sReportEntries, sReportEntryName);	
		sSectionEntry = PropString (1, sSectionEntries, sSectionEntryName,0);
		// make sure it is not left blank
		if (sSectionEntries.find(sSectionEntry)<0 && sSectionEntries.length()>0) sSectionEntry.set(sSectionEntries[0]);
		sDescription = PropString (7, "", sDescriptionName);
		sAlign = PropString (2, sAlignments, sAlignmentName);	
		sDirection = PropString (3, sDirections, sDirectionName);
		sHeaderOverrides = PropString (8, "", sHeaderOverridesName);
		sHeaderOverrides.setDescription(T("|Specifies overrides for each header of the columns.|") + " " + T("|Separate multiple entries by|")+ "' ;'");	
		sColumnWidth =PropString (5, "", sColumnWidthName);
		sColumnWidth.setDescription(T("|Specify width of each column.|") + " " + T("|Separate multiple entries by|")+ "' ;'");	
		sDecimals=PropString (6, "", sDecimalsName );
		sDecimals.setDescription(T("|Specify the number of decimals.|") + " " + T("|Separate multiple entries by|")+ "' ;'");	
		sDimStyle=PropString (0, sDimstyles, sDimstyleName);	
		dTxtH=PropDouble (0,U(100), sTextHeightName);			
		nColor=PropInt (0,0, sColorName);	
		nColor2=PropInt (1,10, sColor2Name);	 	

		showDialog();
		setExecutionLoops(2);		
	}
// lock the report name, to change a report one has to use the context command
	sReportEntry.setReadOnly(true);


// Trigger SetSubheader
	int bToggleSubheader = _Map.getInt("ToggleSubheader");
	String sToggleSubheader =bToggleSubheader?T("../|Disable first column as subheader|"):T("../|Set first column as subheader|");
	addRecalcTrigger(_kContext, sToggleSubheader);
	if (_bOnRecalc && _kExecuteKey==sToggleSubheader)
	{
		bToggleSubheader = bToggleSubheader ? false : true;
		_Map.setInt("ToggleSubheader", bToggleSubheader);		
		setExecutionLoops(2);
		return;
	}


// GetReportDefinition
	// CallDotNet2 method that accepts the following parameters as keys in the input map.
	// ReportName - name of the report to retrieve the definition for.
	// CompanyPath - the full path of the company folder.

	// The output map contains the report definition under the key: ReportDefinition.
	if (_bOnDbCreated || (_bOnRecalc && bDebug) || (_bOnRecalc && _kExecuteKey==sTriggerChangeReportDef))
	{
		if (bDebug)reportMessage("\nstoring report definition in map...");
		Map mapIn;
		mapIn.setString("ReportName", sReportEntry);	
		mapIn.setString("CompanyPath", _kPathHsbCompany);	
		Map mapZones= _Map.getMap("Zone[]");
		_Map = callDotNetFunction2(strAssemblyPath, strType, "GetReportDefinition", mapIn);
		_Map.setMap("Zone[]",mapZones);
		_Map.setInt("mode", nMode);
		_Map.setInt("ShowDependencies",bShowDependencies);
		_Map.setInt("ShowOnlyVisible", bShowOnlyVisible);
		_Map.setInt("ToggleSubheader", bToggleSubheader);
		if (bDebug)_Map.writeToDxxFile(_kPathDwg + "\\reportOut.dxx");
	}

// add entity trigger	
	String sAddTrigger = T("|Add entities|");
	addRecalcTrigger(_kContext, sAddTrigger );
	if (_bOnRecalc && _kExecuteKey==sAddTrigger )
	{
		Entity ents[0] ;
	// declare a prompt	
		PrEntity ssE(T("|Select entities|"), GenBeam());
		ssE.addAllowedClass(Element());
		ssE.addAllowedClass(MasterPanel());
		ssE.addAllowedClass(TslInst());
		ssE.addAllowedClass(MassGroup());
		ssE.addAllowedClass(FastenerAssemblyEnt());
		ssE.addAllowedClass(CollectionEntity());
		ssE.addAllowedClass(Opening());			
		if (ssE.go())
		{
			ents= ssE.set();
		}
		for (int e=0; e<ents.length();e++)
		{
			int n = _Entity.find(ents[e]);
			if (n<0) _Entity.append(ents[e]);	
		}
	}


// remove entity trigger	
	String sRemoveTrigger = T("|Remove entities|");
	addRecalcTrigger(_kContext, sRemoveTrigger );
	if (_bOnRecalc && _kExecuteKey==sRemoveTrigger )
	{
		Entity ents[0] ;
		
	// declare a prompt	
		PrEntity ssE(T("|Select entities|"), GenBeam());
		ssE.addAllowedClass(Element());
		ssE.addAllowedClass(MasterPanel());
		ssE.addAllowedClass(TslInst());
		ssE.addAllowedClass(MassGroup());
		ssE.addAllowedClass(FastenerAssemblyEnt());
		ssE.addAllowedClass(CollectionEntity());
		ssE.addAllowedClass(Opening());			
		
		if (ssE.go())
		{
			ents= ssE.set();
		}
		for (int e=0; e<ents.length();e++)
		{
			int n = _Entity.find(ents[e]);
			if (n>-1)
				_Entity.removeAt(n);	
		}
	}

// toggle visibility trigger	
	String sToggleVisibilityTrigger = T("|Show only visible entities|");
	if (bShowOnlyVisible)
		sToggleVisibilityTrigger = T("|Show all entities|");
	addRecalcTrigger(_kContext, sToggleVisibilityTrigger );
	if (_bOnRecalc && _kExecuteKey==sToggleVisibilityTrigger )
	{
		if (bShowOnlyVisible)
			bShowOnlyVisible=false;
		else
			bShowOnlyVisible=true;
		_Map.setInt("ShowOnlyVisible", bShowOnlyVisible);
		setExecutionLoops(2);
	}
	
	
// declare modelmap entities
	Entity entsMM[0],_entsMM[0];
	entsMM = _Entity;
	
// resolve potentially referenced entities of tsl's
	for (int i=entsMM.length()-1; i>=0 ; i--) 
	{ 
		TslInst tsl= (TslInst)entsMM[i];
		if (tsl.bIsValid())
		{ 
			Entity ents[]=tsl.map().getEntityArray("EntityRef[]", "", "Handle");
			if (ents.length()>0)
			{ 
				entsMM.removeAt(i);
				_entsMM.append(ents);
				
			}
		}
	}
	entsMM.append(_entsMM);	
	if(bDebug)reportMessage("\n"+ scriptName() + " tsl based entities (" + entsMM.length()+")");
	

	
// remove invisible entities if toggled
	if(bShowOnlyVisible)
	{	
		for (int i=entsMM.length()-1;i>=0;i--)
			if (!entsMM[i].isVisible())
				entsMM.removeAt(i);	
	}
	
// collect items which are not numbered
	GenBeam gbNoPosnums[0];
	if (nMode!=1)// not in shopdraw mode
		for (int i=entsMM.length()-1;i>=0;i--)
		{
			if (entsMM[i].bIsKindOf(GenBeam()))
			{
				GenBeam gb = (GenBeam)entsMM[i];
				if (gb.posnum()==-1) 
					gbNoPosnums.append(gb);
			}	
		}
// order by type
	for (int i=0;i<gbNoPosnums.length();i++)
		for (int j=0;j<gbNoPosnums.length()-1;j++)
		{
			GenBeam gb1=gbNoPosnums[j], gb2=gbNoPosnums[j+1];
			String s1, s2;
			if (gb1.element().bIsValid())
				s1+=gb1.element().number();
			if (gb2.element().bIsValid())
				s2+=gb2.element().number();
			s1+= gb1.typeDxfName();
			s2+= gb2.typeDxfName();
			if (s1>s2)
				gbNoPosnums.swap(j,j+1);
		}
				
// apply posnums and report to user
	if (nMode!=1)// not in shopdraw mode
	for (int i=0;i<gbNoPosnums.length();i++)
	{		
		GenBeam gb = gbNoPosnums[i];	
		int nPos = gb.assignPosnum(1, true);
		String sMsg = "\n";
		Element el = gb.element();
		if (el.bIsValid()) sMsg+=T("|Element|") + " " + el.number() + " ";
		sMsg += gb.typeDxfName() + " " + gb.solidLength() + "x" + gb.solidWidth() + "x" +gb.solidHeight() + " " + T("PosNum") + ": " + nPos;
//		reportMessage(sMsg);
		reportMessage("\n"+scriptName()+" "+T(sMsg));
		
		if (i==gbNoPosnums.length()-1)
			reportMessage("\n***** " +scriptName() + " " + sDescription + " " + T("|has applied posnums to|") + " " +gbNoPosnums.length() +" " + T("|unnumbered items.|") +" *****");		
	}

	
// dummy trigger
	addRecalcTrigger(_kContext,"_________________________");

// show/hide dependencies trigger	
	String sShowHideTrigger = T("|Show dependencies|");
	addRecalcTrigger(_kContext, sShowHideTrigger );
	if (_bOnRecalc && (_kExecuteKey==sShowHideTrigger ||  _kExecuteKey==sDoubleClick))
	{
		if (bShowDependencies) bShowDependencies =false;
		else	bShowDependencies =true;
		_Map.setInt("ShowDependencies",bShowDependencies);	
	}
	
// show/hide dependencies	
	if (bShowDependencies)
	{
		for (int i=0;i<entsMM.length();i++)
		{
			int c = 0;
			Point3d pt = _Pt0;
			Entity ent = entsMM[i];
			if (ent.bIsKindOf(Beam()))
			{
				c=40;
				pt = ((Beam)ent).ptCen();
			}
			else if (ent.bIsKindOf(Sheet()))
			{
				c=12;
				pt = ((Sheet)ent).ptCen();
			}			
			else if (ent.bIsKindOf(Sheet()))
			{
				c=5;
				pt = ((Sheet)ent).ptCen();
			}			
			else if (ent.bIsKindOf(Element()))
			{
				c=4;
				pt = ((Element)ent).ptOrg();
			}
			else if (ent.bIsKindOf(TslInst()))
			{
				c=94;
				pt = ((TslInst)ent).ptOrg();
			}
			else if (ent.bIsKindOf(Opening()))
			{
				c=172;
				pt = ((Opening)ent).coordSys().ptOrg();
			}
			else if (ent.bIsKindOf(FastenerAssemblyEnt()))
			{
				c=252;
				pt=((FastenerAssemblyEnt)ent).coordSys().ptOrg();
			}
			else if (ent.bIsKindOf(CollectionEntity()))
			{
				c=250;
				pt=((CollectionEntity)ent).coordSys().ptOrg();
			}
			Display dpDep(c);
			dpDep.draw(PLine(_Pt0,pt));
		}
		
	}
		
// the shopdraw view	
	ShopDrawView sdv;
	if (nMode==1)
	{
	// on generate shopdrawing -> mode 2
		if (_bOnGenerateShopDrawing)
		{
			Entity entDefine;	
		// interprete the list of ViewData in my _Map
			ViewData arViewData[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets,2); // 2 means verbose
			
		// use the first entity / ShopDrawView for defining the show set from the define set.
		// Take also the first ShopDrawView to define the original entity reference coordsys to align for.
			sdv = (ShopDrawView)_Entity[0];
			if (!sdv.bIsValid())
			{
				reportMessage("\nError in "+scriptName()+": first entity is not a ShopDrawView.");
				return;
			}
				
			int nIndFound = ViewData().findDataForViewport(arViewData, sdv);// find the viewData for my view
			if (nIndFound>=0) 
			{ 
			// my entView its viewdata is found at index nIndFound
				ViewData vwData = arViewData[nIndFound];
				Entity showSet[] = vwData.showSetEntities();
				Entity defineSet[] = vwData.showSetDefineEntities();

				if (defineSet.length()>0)
					entDefine = defineSet.first();
					
					
				entsMM.append(showSet);
				// 20230714: Holzius, include defining entity
				if(entsMM.find(entDefine)<0)
					entsMM.append(entDefine);
				nMode=2;	
					
			}
			if (!entDefine.bIsValid()) 
			{
				reportMessage("\nError in "+scriptName()+": no define set entity found.");
				return;
			}	
		}// END IF if (_bOnGenerateShopDrawing && _kExecuteKey==_kShopDrawViewDataShowSet )	
	
	// if not in shopdraw mode
		else
		{
			for (int i=0; i<_Entity.length(); i++)
			{
				if (_Entity[i].bIsKindOf(ShopDrawView()))
				{
					sdv = (ShopDrawView)_Entity[i];
					entsMM.append(sdv);
					nMode=2;
					break;	
				}
			}
		}
		if (!sdv.bIsValid())
		{
			reportMessage("\n"+scriptName()+" "+T("|Shopdraw view is invalid.|"));
			eraseInstance();
			return;		
		}		
	}
// END IF shopdraw view  ___________________________________________________________________ shopdraw view	
// Elementlayout	______________________________________________________________________________________Elementlayout			
	else if (_Viewport.length()>0)
	{
		Viewport vp;
		vp = _Viewport[_Viewport.length()-1]; // take last element of array
		_Viewport[0] = vp; // make sure the connection to the first one is lost		
		
		Element element = vp.element();
		//Entity ents[] = vp.viewData().showSetDefineEntities();
		if (!element.bIsValid()) return;
		nMode=2;
		
		int nActiveZone = vp.activeZoneIndex();
		Map mapZones = _Map.getMap("Zone[]");
		int nZones[0];	

	// collect zones which are in use
		String sInfoZones;
		String sSep;
		for (int m=0;m<mapZones.length();m++)	
			if (mapZones.hasInt(m))
			{
				int nZone = mapZones.getInt(m);
				if (nZones.find(nZone)<0)
					nZones.append(nZone);
			}	
		
	// order zones
		for (int n=0;n<nZones.length();n++)
			for (int m=0;m<nZones.length()-1;m++)
				if (nZones[m]>nZones[m+1])
					nZones.swap(m, m+1);
					
	// build an info string
		String sInfo;
		for (int n=0;n<nZones.length();n++)
		{
			sInfo+= sSep+nZones[n];
			sSep = ", ";
		}
		if (sInfo.length()<1) sInfo = T("|current Zone|") + " " +nActiveZone ;
		
	// add state dependent triggers
	// event trigger Add Zone
		String sTriggerAddZone = T("|Add/Remove zone|") + " (" + sInfo+")";
		addRecalcTrigger(_kContext, sTriggerAddZone );		
		if (_bOnRecalc && _kExecuteKey==sTriggerAddZone)
		{
		// declare zones		
			int nThisZone=getInt("\n" + T("|Enter Zone Index (99 = all Zones)|") + " " + T("|selected zones|") + ": " + sInfo);
			int nFound = nZones.find(nThisZone);
		// add all zones
			if (nThisZone==99)
			{
				int nAll[]={-5,-4,-3,-2,-1,0,0,1,2,3,4,5};
				nZones=nAll;
			}
		// remove all zones	
			else if (nThisZone==-99)
			{
				int nAll[]={nActiveZone};
				nZones=nAll;
			}
		// remove zone		
			else if (nFound>-1)
			{
				nZones.removeAt(nFound);
			}	
		// remove zone		
			else if (nFound<0 && (nThisZone>-6 && nThisZone<11))
			{
			// translate to -5...0...5
				if (nThisZone>5 && nThisZone<11)
					nThisZone*=-(nThisZone-5);			
				nZones.append(nThisZone);
			}				
	
		// write to map	
			mapZones=Map();		
			for (int i=0;i<nZones.length();i++)
				mapZones.appendInt("Zone",nZones[i]);
			_Map.setMap("Zone[]",mapZones);	
			setExecutionLoops(2);
		}
		
	// collect zone indices to manipulate selection set
		// length() == 0 : current zone
		// length() == 11: all zones
		// else individual set zones

		for (int m=0;m<mapZones.length();m++)	
			if (mapZones.hasInt(m))
				nZones.append(mapZones.getInt(m));

	// append active zone if no zones selected
		if (nZones.length()<1)
			nZones.append(nActiveZone);	
	
	// the element	
		Element el;
		el = vp.element();	
		entsMM.append(el);
		
	//for compatibility with R17 do not use the collectEntities method on group
		GenBeam gb[0];
	// if no zones are selected take the current zone
		if (nZones.length()<1) 
			gb=el.genBeam(vp.activeZoneIndex());	
	// for all take all genbeams of the element
		else if (nZones.length()==11) 
			gb=el.genBeam();
	// append genbeams of each selected zone			
		else
		{
			for (int i=0;i<nZones.length();i++)
				gb.append(el.genBeam(nZones[i]));	
		}		
		for (int i=0;i<gb.length();i++)
		{
			entsMM.append(gb[i]);
		}
			
		Opening op[]=el.opening();
		TslInst tsl[]=el.tslInst();	

		Entity entsEl[] = el.elementGroup().collectEntities(true, MassGroup(), _kModelSpace);
		entsEl.append(el.elementGroup().collectEntities(true, MassElement(), _kModelSpace));

		for (int i=0;i<op.length();i++)entsMM.append(op[i]);	
		for (int i=0;i<tsl.length();i++)entsMM.append(tsl[i]);	
		for (int i=0;i<entsEl.length();i++)
			if (entsMM.find(entsEl[i])<0)
				entsMM.append(entsEl[i]);	
		
	}

// compose MM and run map report
	Map mapReport;
	if (entsMM.length()>0)
	{
	// collect child entities
		if(bDebug)reportMessage("\n"+ scriptName() + " has " + entsMM.length() + " entities");
		
		Entity ents[0];
		for (int i=0;i<entsMM.length();i++) 
		{ 
			GenBeam gb = (GenBeam)entsMM[i];
			if (gb.bIsValid())
			{ 
				Entity _ents[] = gb.eToolsConnected();
				if(bDebug)reportMessage("\n"+ gb.handle() + " has " + _ents.length() + " etools");
				for (int j=0;j<_ents.length();j++) 
					if (ents.find(_ents[j])<0)
						ents.append(_ents[j]); 
			}
			 ents.append(entsMM[i]);
		}//next i
		if(bDebug)reportMessage("\n"+ scriptName() + " has now " + ents.length() + " entities");

	// set some export flags
		ModelMapComposeSettings mmFlags;
		mmFlags.addSolidInfo(TRUE); // default FALSE
		mmFlags.addAnalysedToolInfo(false); // default FALSE
		mmFlags.addElemToolInfo(TRUE); // default FALSE
		mmFlags.addConstructionToolInfo(TRUE); // default FALSE
		mmFlags.addHardwareInfo(TRUE); // default FALSE
		mmFlags.addRoofplanesAboveWallsAndRoofSectionsForRoofs(TRUE); // default FALSE
		mmFlags.addCollectionDefinitions(TRUE); // default FALSE

	// compose ModelMap
		ModelMap mm;
		mm.setEntities(ents);
//		mm.dbComposeMap(mmFlags);

	// get report definition from global map
		Map mapReportDefinition = _Map.getMap("ReportDefinition");
		
		// HSB-19938, HSB-19977: for TSL reports make sure addRoofplanesAboveWallsAndRoofSectionsForRoofs is set to false
		// we dont want tsls from roofplanes be counted at walls
		// 
		String sQuery=mapReportDefinition.getMap("SectionCollection[]\\ReportSection\\RowDefinition[]\\RowDefinition").
			getString("Query");
		sQuery.trimLeft();
		sQuery.trimRight();
		String ss1 = "(SCRIPTNAME='SOLIGNO-ABRECHNUNGBEARBEITUNG')";
		sQuery.makeUpper();
		if(sQuery==ss1)
		{ 
			mmFlags.addRoofplanesAboveWallsAndRoofSectionsForRoofs(FALSE);
		}
		mm.dbComposeMap(mmFlags);
		
	// RunMapReport
		// This method has been changed to accept a key "Report" that contains the report definition Map.
		// The "ReportName" is still required.
		Map mapIn;
		mapIn.setMap("Report", mapReportDefinition);
		mapIn.setString("ReportName", sReportEntry);	
		mapIn.setMap("Model", mm.map());

		mapReport = callDotNetFunction2(strAssemblyPath, strType, "RunMapReport", mapIn);	
		if (bDebug)
		{
			String sPath = _kPathDwg + "\\hsbReportMapIn.dxx";
			mapIn.writeToDxxFile(sPath);
			reportMessage("\n" + scriptName() + ": " + sPath + " written.");
			sPath = _kPathDwg + "\\hsbReportMapOut.dxx";
			mapReport.writeToDxxFile(sPath);
			reportMessage("\n" + scriptName() + ": " + sPath + " written.");
		}		
	}// END IF compose MM and run map report

// special debug: read _map from file
	if (0)_Map.readFromDxxFile("D:\\hsbCAD\\hsbProjekte\\DEF\\Development\\hsbReport\\hsbReportMapOut.dxx");


// reset grips if alignment changes
	if (sAlignmentName==_kNameLastChangedProp)
		_PtG.setLength(0);

// get section map from main map	
	Map mapSection,mapSections;
	mapSections =  mapReport.getMap("Report").getMap("Section[]");
	for (int i=0; i<mapSections.length(); i++)
	{
		Map map = mapSections.getMap(i);
		if (map.getString("Name").makeUpper() == sSectionEntry.makeUpper())
			mapSection=mapSections.getMap(i);	
	}

	if (mapSection.length()<1)
	{
		reportMessage("\n"+scriptName() + ": " + T("|report definition invalid, no section data found|"));
		String sPath = _kPathDwg + "\\mapSection.dxx";
		_Map.writeToDxxFile(sPath);
		setExecutionLoops(2);
		//if (!bDebug)eraseInstance();//#001
		return;
	}
	else if (bDebug)
	{ 
		mapSection.writeToDxxFile(_kPathDwg + "\\mapSection.dxx");
	}
	
// get rows of this section
	Map mapRows =mapSection.getMap("Row[]");
	int nRows = mapRows.length();
	if (bDebug)reportMessage("\nreport has " + nRows + " rows");

// display
	Display dp(nColor);
	double dScale = 1;//vwData.dScale();
	dp.dimStyle(sDimStyle,1/dScale);
	double dColFactor = dTxtH/dp.textHeightForStyle("W",sDimStyle);
	dp.textHeight(dTxtH);

// some values regarding the row
	double dRowFactor = 2;
	double dRowHeight = dTxtH*dRowFactor;
	double dCharWidth = dp.textLengthForStyle("W",sDimStyle, dTxtH);//dColFactor * 
	double dXOffset = 5*dCharWidth ;
	
// get column headers and the width of each column
	String sHeaderNames[0];
	Map mapColumnHeaders = mapSection.getMap("ColumnHeaders[]").getMap("ColumnHeaders").getMap("ColumnHeader[]");
	double dColumnHeaderWidths[0];
	for (int r=0;r<mapColumnHeaders .length();r++)
	{
		String sHeader;
		if (sHeaders.length()>r && sHeaders[r].length()>0)
		{
			sHeader=sHeaders[r];
		// translate if piped
			if (sHeader.find("|",0)>-1)
				sHeader = T(sHeader);			
		}
		else
			sHeader = T(mapColumnHeaders.getMap(r).getString("DisplayName"));

	// get column header width	from display name
		double dColumnHeaderWidth= dColFactor *dp.textLengthForStyle(sHeader,sDimStyle) + dCharWidth ;//
		int n = dColumnHeaderWidth*1000;
		dColumnHeaderWidth =n/1000;
		if (dColumnHeaderWidth<=0)dColumnHeaderWidth=dXOffset;
		dColumnHeaderWidths.append(dColumnHeaderWidth); 
		sHeaderNames.append(sHeader);
	}		
	
// get amount of columns from first row
	int nNumColumns;
	nNumColumns= mapColumnHeaders.length();
		
// create grips and and store column widths if not set
	int bSetColumnWidth = sColumnWidth.length()<1;	
	String sColumnWidthTmp;
	for (int i=0;i<nNumColumns;i++)
	{
	// collect column width for initial use if no widths are predefined		
		double dWidth = dXOffset;
		if (dColumnHeaderWidths.length()>i-1)dWidth=dColumnHeaderWidths[i];		
		sColumnWidthTmp+=dWidth ;
		if (i<nNumColumns-1)sColumnWidthTmp+="; ";		
		
		Point3d ptRef = _Pt0;
		if (_PtG.length()>0)ptRef = _PtG[_PtG.length()-1];
		if (_PtG.length()<=i)
		{
			_PtG.append(ptRef+ vecX*dWidth);
		}
	}
	if (bSetColumnWidth) 
	{
		sColumnWidth.set(sColumnWidthTmp);
		setExecutionLoops(2);
	}
	
// LineFeed
	Vector3d vyLineFeed = -vecY*dRowFactor*dTxtH;	

// snap to line, if column is hidden offset grip slightly opposite to direction	
	Vector3d vyDescriptionLF;
	if (nDir==1 && sDescription!="")vyDescriptionLF=vyLineFeed;
	double dYHiddenColumn; // defines the grip offset of hidden columns
	for (int i=0;i<_PtG.length();i++)
	{
		Point3d ptPrev=_Pt0;
		if (i>0) ptPrev=_PtG[i-1];
		double dX = vecX.dotProduct(_PtG[i]-ptPrev);
	// set y offset for hidden columns	
		if (dX<=dEps)
			dYHiddenColumn+=.2*dRowHeight;		
		else
	// reset hidden column offset
			dYHiddenColumn=0;
		_PtG[i].transformBy(vyDescriptionLF+vecY*(vecY.dotProduct(_Pt0-_PtG[i])-dYHiddenColumn) + vecZ*vecZ.dotProduct(_Pt0-_PtG[i]));
	}
	
// adjust column width on insert or if property width has changed
	if (dColumnWidths.length()>0 &&
		(_bOnDbCreated || _kNameLastChangedProp.find(sColumnWidthName,0)>-1 || sAlignmentName==_kNameLastChangedProp))
	{
		Point3d ptRef = _Pt0;
		for (int i=0;i<dColumnWidths.length();i++)
		{
			if (_PtG.length()>i)
			{			
				double d = vecX.dotProduct(_PtG[i]-ptRef);
				double c = dColumnWidths[i]-d;
				_PtG[i].transformBy(vecX*c);
				ptRef = _PtG[i];
			// shift this + remaining grips accordingly	
				for (int j=i+1;j<_PtG.length();j++)
					_PtG[j].transformBy(vecX*c);
			}	
		}	
	}	

// update column width property when a grip has been dragged
	if (_kNameLastChangedProp.find("_PtG",0)>-1)
	{
		String sValue;
		Point3d ptRef = _Pt0;
		// get index
		int nIndex = _kNameLastChangedProp.right(_kNameLastChangedProp.length()-4).atoi();
		for (int i=0;i<_PtG.length();i++)
		{
			if (i>0)sValue+=";";
			double d = vecX.dotProduct(_PtG[i]-ptRef);
			
			// for all grips to the right of the selected one, use the previous value
			if (dColumnWidths.length()>i && nIndex<i)		break;

			sValue+=d;
			if (dColumnWidths.length()>i)dColumnWidths[i]=d;
			ptRef = _PtG[i];
		}
		for (int i=nIndex+1;i<_PtG.length();i++)
		{
			if (dColumnWidths.length()<=i)continue;
			if (i>nIndex+1)sValue+=";";
			double c = dColumnWidths[i];	
			_PtG[i]=ptRef+vecX*c;	
			sValue+=c;
			ptRef = _PtG[i];
		}			
		sColumnWidth.set(sValue);
		setExecutionLoops(2);
	}	

// get the row definitions from the report definition
	Map mapRowDefinitions = _Map.getMap("ReportDefinition\SectionCollection[]\ReportSection\\RowDefinition[]");


// collect grips
	Point3d ptX[0];
	ptX.append(_Pt0-vyDescriptionLF);
	ptX.append(_PtG);
	Point3d ptRow = _Pt0-vecY*dTxtH;
	if (mapRows.length()<1 && nDir==0)
		ptRow.transformBy(vyLineFeed);
	int bShopdrawSetup =nRows<1 && nMode==2;

// transform accordingly to direction
	if (nDir==0)
	{
	// shift one line if header names are given
		for (int i=0;i<sHeaderNames.length();i++) 
		{ 
			if (sHeaderNames[i].length()>0)
			{
				ptRow.transformBy(-vyLineFeed); 
				break;
			}			 
		}//next i

	// shift one line up if row is not empty
		for (int r=0;r<nRows;r++)	
		{
			Map mapCells = mapRows.getMap(r).getMap("Cell[]");
			
			int bHasValue;
			for (int i=0;i<mapCells.length();i++) 
			{ 
			// get the cell and it's type
				Map mapCell = mapCells.getMap(i);
				if (mapCell.hasInt("Value") || mapCell.hasDouble("Value"))
					bHasValue=true;
				else if (mapCell.hasString("Value") && mapCell.getString("Value")!="")
					bHasValue=true;		
				if (bHasValue)break;	
				 
			}//next i

			if (!bHasValue || (nRows==0 && !bShopdrawSetup))continue;
			ptRow.transformBy(vecY*2*dTxtH);
		}

		
	// on shopdraw debug flip preview
		if (mapRows.length()<1)
		{
			ptRow.transformBy(-vyLineFeed );
		}
	}

// draw description
	if (sDescription!="")
	{
		if (nDir==0)ptRow.transformBy(-vyLineFeed);
		double dX=abs(vecX.dotProduct(_PtG[_PtG.length()-1]-_Pt0));
		PLine plRec(vecZ);
		plRec.createRectangle(LineSeg(ptRow+vecY*.5*dRowFactor*dTxtH, ptRow+vecX*dX-vecY*.5*dRowFactor*dTxtH),vecX,vecY);
		dp.draw(plRec);
		dp.draw(sDescription,ptRow+vecX*.5*dX ,vecX,vecY,0,0);	
		ptRow.transformBy(vyDescriptionLF);	
		if (nDir==0)ptRow.transformBy(vyLineFeed);
	}

// declare an array of sums
	double dSummaries[ptX.length()-1];


// draw table
	String sSubHeader;
	for (int r=-1;r<nRows;r++)	
	{
		Map mapRow = mapRows.getMap(r);
		Map mapCells = mapRow.getMap("Cell[]");

		String sRowDefinitionName = mapRow.getString("Name");
		String sNextRowDefinitionName;
		if (r<nRows-2)sNextRowDefinitionName= mapRows.getMap(r+1).getString("Name");
	// flag sums to be written
		int bWriteSum = r>-1 && r==nRows-1 || (sNextRowDefinitionName!="" && sNextRowDefinitionName!=sRowDefinitionName);
		
		sNextRowDefinitionName=sRowDefinitionName;
		
	// get the column properties from row definition
		Map mapColumns;
		if (sRowDefinitionName!="")
		{
			for (int i=0;i<mapRowDefinitions.length();i++)
			{
				Map mapRowDefinition = mapRowDefinitions.getMap(i);
				String sCRowDefinitionName = mapRowDefinition.getString("Name");	
				if (sRowDefinitionName==sCRowDefinitionName)
					mapColumns=mapRowDefinition.getMap("Columns[]");
			}
		}	
		//else if (_bOnDebug)
		//	continue;
		
			
	// skip blank rows
		if (mapCells.length()<1 && r>-1 && !bShopdrawSetup)
		{
			if(bDebug)reportMessage("\n"+ scriptName() + " skip blank row " +r);
			continue;
		}
		
		int nLevel = mapRow.getInt("Level"); 
		if (nRows<1 && nMode==2) nRows=1;  // nMode=2 -> Shopdrawspace
	
		
	// test empty row
		int bIsEmptyRow=(r<0)?false:true;
		for (int i=0;i<ptX.length()-1;i++)		
		{
		// get the cell and it's type
			Map mapCell = mapCells.getMap(i);
			if (mapCell.hasInt("Value") || mapCell.hasDouble("Value"))
				bIsEmptyRow=false;
			else if (mapCell.hasString("Value") && mapCell.getString("Value")!="")
				bIsEmptyRow=false;		
			if (!bIsEmptyRow)break;	
		}	
		//if(bDebug)reportMessage("\n"+ scriptName() + " row " +r + " is empty " + bIsEmptyRow);
		
		if (!bIsEmptyRow)
		{
			for (int i=0;i<ptX.length()-1;i++)	
			{	
			// get column width, do not draw any data for hidden columns	
				double dColumnWidth;
				if (dColumnWidths.length()>i)dColumnWidth=dColumnWidths[i];
				if (dColumnWidth<=dEps && !bShopdrawSetup)continue;
			
			// get column definition for this cell
				Map mapColumn;// this is just prepared for further use, currently not used
				if (mapColumns.length()>i)
					mapColumn = mapColumns.getMap(i);
			
					
			// get the cell and it's type
				Map mapCell = mapCells.getMap(i);
				int nDataType; // 0 = string, 1=int, 2=double
				String sValue = mapCell.getString("Value");
				int nDir=0;
			
			// flag summaries
				int nSummaryType = sSummaryTypes.find(mapColumn.getString("SummaryType"));
				//reportMessage("\ncolumn " + i + " summary type = " +nSummaryType + "("+mapColumn.getString("SummaryType") +")");
			
			// get unit type
				int nUnitType = mapColumn.hasInt("UnitType")?mapColumn.getInt("UnitType"):-1;
				
				
				if (mapCell.hasInt("Value"))
				{
					nDataType=1;
					nDir=1;
					int value = mapCell.getInt("Value");
				// collect sum
					if (nSummaryType==0)
					{
						dSummaries[i]+=value;
					}
					sValue = value;
					//reportMessage(" as type int");
				}
				else if (mapCell.hasDouble("Value"))
				{
					nDataType=2;
					nDir=2;
									
					String sUnit = mapCell.getString("Unit");
					int nUnit = sUnits.find(sUnit);
				
				// fall back to drawing units
					if (nUnit<0)
					{
						if (U(1000)/1000==1)nUnit=2;
						else if (U(1000)/1000==.1)nUnit=1;
						else if (U(1000)/1000==.001)nUnit=0;
					}	
					
					double value = mapCell.getDouble("Value");
				// collect sum
					if (nSummaryType==0)	
						dSummaries[i]+=value;
				
				// take the override from the property if available		
					if (nUnit>-1)
					{
						int nDecimals =((String)dUnits[nUnit]).length()-1;
						if (nArDecimals.length()>i) nDecimals= nArDecimals[i];
						sValue.formatUnit(value,2,nDecimals);
						//	sValue.formatUnit(value/U(1,"mm")/dUnits[nUnit],2,nDecimals);// 3.4
					}
					else
						sValue =value;
						
				// ensure a leading 0
					if(sValue.left(1)==".")
						sValue="0"+sValue;
					//reportMessage(" as type double");		
				}
				else
				{ 
				// check if string should be shown as a double
					double d=sValue.atof();
					if (((String)d)==sValue)
						nDir=2;// format as double

				// collect sum
					if (nSummaryType==0)
					{
						dSummaries[i]+=d;
						
					}
					//reportMessage(" as type string summary: " + dSummaries[i]);
				}
					
	
			// overwrite to display the header
				if (r==-1 && sHeaderNames.length()>i)
				{	
					sValue = sHeaderNames[i];
					nDir=1;		
				}
				
				// region Subheader: if subheader is activated draw content only once and suppress inbetween gridlines HSB-7370
				int nDrawMode;// 0 = rectangle, 1 = left line, 2 = left and top line)
				if (bToggleSubheader && i==0)
				{
//					if (r <0)
//						sValue = "";
					if(r>-1)
					{ 
						if (sValue!=sSubHeader)
						{
							nDrawMode = 2;
							sSubHeader = sValue;
						}
						else
						{
							sValue = "";
							nDrawMode = 1;
						}
					}
				}
				// endregion
				
				Point3d pt[] = {ptX[i],(ptX[i]+ptX[i+1])/2,ptX[i+1]};	
				for (int p=0;p<pt.length();p++)
					pt[p].transformBy(-(p-1) * .5*vecX*dCharWidth +vecY * vecY.dotProduct(ptRow-pt[p]));
				Point3d ptText = pt[nDir];
	
			// transfom first column if leveled
				double dLengthForStyle = dp.textLengthForStyle(sValue, sDimStyle, dTxtH);
				if(i==0)	ptText.transformBy(nLevel*vecX*dCharWidth);
				if (nLevel>0) dp.color(nColor2);// set second level color
				if (nDir==2 && dLengthForStyle>=dColumnWidth)	ptText.transformBy(-vecX*dCharWidth);

			// get length of text				
				if (dLengthForStyle>dColumnWidth)
				{ 
					double dMax = dColumnWidth - dp.textLengthForStyle("..", sDimStyle, dTxtH)-dCharWidth;
					while (sValue.length()>2 && dLengthForStyle>dMax)
					{ 
						sValue = sValue.left(sValue.length() - 1);
						dLengthForStyle = dp.textLengthForStyle(sValue, sDimStyle, dTxtH);
					}
					sValue += "...";
				}
				// HSB-21653
				if(nMode==2 && sdv.bIsValid())
				{
				// when inserted in block space of shopdraw
					if(sValue.find("@",-1,false)>-1)
					{ 
						reportMessage("\n"+scriptName()+" "+T("|Invalid data found, instance will be deleted|"));
						eraseInstance();
						return;
					}
				}
				dp.draw(sValue,ptText ,vecX,vecY,-(nDir-1),0);
				if (nLevel>0) dp.color(nColor);// reset second level color
				
				PLine pl(vecZ);
			
			// draw rectangle
				if (nDrawMode==0)
					pl.createRectangle(LineSeg(pt[0]-vecX*.5*dCharWidth+vecY*.5*dRowFactor*dTxtH, pt[2]+vecX*.5*dCharWidth-vecY*.5*dRowFactor*dTxtH),vecX,vecY);
			// draw left line
				else if (nDrawMode==1)
					pl = PLine(pt[0] - vecX * .5 * dCharWidth + vecY * .5 * dRowFactor * dTxtH, pt[0] - vecX * .5 * dCharWidth - vecY * .5 * dRowFactor * dTxtH);
			// draw left and top line
				else if (nDrawMode==2)
					pl = PLine(pt[2] + vecX * .5 * dCharWidth + vecY * .5 * dRowFactor * dTxtH,
						pt[0] - vecX * .5 * dCharWidth + vecY * .5 * dRowFactor * dTxtH,
						pt[0] - vecX * .5 * dCharWidth - vecY * .5 * dRowFactor * dTxtH);
			
			// if it is the last row also draw the bottom line
				if (nDrawMode>0 && r == nRows-1)
					pl.addVertex(pt[2] + vecX * .5 * dCharWidth - vecY * .5 * dRowFactor * dTxtH);
						
						
				pl.vis(1);
				dp.draw(pl);
			}// next i cell
			ptRow.transformBy(vyLineFeed);
		}
		
	// write summaries
		int bOk;
		if (bWriteSum)
		{
			ptRow.vis(3);
		// loop columns
			
			for (int i=0;i<ptX.length()-1;i++)	
			{ 
				if (dSummaries.length()<i ||  dSummaries[i]<=0)continue;
				String sValue;
				
			// get column width, do not draw any data for hidden columns	
				double dColumnWidth;
				if (dColumnWidths.length()>i)dColumnWidth=dColumnWidths[i];
				if (dColumnWidth<=dEps && !bShopdrawSetup)continue;
			
			// get column definition for this cell
				Map mapColumn;// this is just prepared for further use, currently not used
				if (mapColumns.length()>i)
					mapColumn = mapColumns.getMap(i);
	
			// get the cell and it's type
				Map mapCell = mapCells.getMap(i);
				int nDataType; // 0 = string, 1=int, 2=double
				int nDir=0;
				
				if (mapCell.hasInt("Value"))
				{
					nDataType=1;
					nDir=1;
					int value = dSummaries[i];
					sValue = value;
				}
				else if (mapCell.hasDouble("Value"))
				{
					nDataType=2;
					nDir=2;
					String sUnit = mapCell.getString("Unit");
					int nUnit = sUnits.find(sUnit);
					double value = dSummaries[i];
				
				// fall back to drawing units
					if (nUnit<0)
					{
						if (U(1000)/1000==1)nUnit=2;
						else if (U(1000)/1000==.1)nUnit=1;
						else if (U(1000)/1000==.001)nUnit=0;
					}	
					

				
				// take the override from the property if available		
					if (nUnit>-1)
					{
						int nDecimals =((String)dUnits[nUnit]).length()-1;
						if (nArDecimals.length()>i) nDecimals= nArDecimals[i];
						sValue.formatUnit(value,2,nDecimals);
						//sValue.formatUnit(value/U(1,"mm")/dUnits[nUnit],2,nDecimals); // 3.4
					}
					else
						sValue =value;
						
				// ensure a leading 0
					if(sValue.left(1)==".")
						sValue="0"+sValue;
							
				}
				if (mapCell.hasString("Value"))
				{
					nDataType=2;
					nDir=2;
					double value = dSummaries[i];
					sValue = value;
				}
				
				Point3d pt[] = {ptX[i],(ptX[i]+ptX[i+1])/2,ptX[i+1]};	
				for (int p=0;p<pt.length();p++)
					pt[p].transformBy(-(p-1) * .5*vecX*dCharWidth +vecY * vecY.dotProduct(ptRow-pt[p]));
				Point3d ptText = pt[nDir];
	
			// transfom first column if leveled
				if(i==0)	ptText.transformBy(nLevel*vecX*dCharWidth);
				if (nLevel>0) dp.color(nColor2);// set second level color
				if (nDir==2)ptText.transformBy(-vecX*dCharWidth);
				dp.draw(sValue,ptText ,vecX,vecY,-(nDir-1),0);
				if (nLevel>0) dp.color(nColor);// reset second level color
				
				PLine plRec(vecZ);
				plRec.createRectangle(LineSeg(pt[0]-vecX*.5*dCharWidth+vecY*.5*dRowFactor*dTxtH, pt[2]+vecX*.5*dCharWidth-vecY*.5*dRowFactor*dTxtH),vecX,vecY);
				dp.draw(plRec);	
				
				bOk = true;
			}// next i of ptX

		}// END IF (bWriteSum)
		if (bOk)
		{
			ptRow.transformBy(vyLineFeed);
			for (int i=0;i<dSummaries.length();i++) 
			{ 
				dSummaries[i]=0; 	 
			}
			ptRow.vis(7);
		}		
		
		
		ptRow.vis(r);
	}	


	
// debug draw	
	if (bDebug)dp.draw( sReportEntry+"/"+sSectionEntry,_Pt0,_XW,_YW,1,0,_kDevice);

// store report name in use. if the dwg is send to another PC/Installation the stored report must be used 	
	_Map.setString("SectionEntry", sSectionEntry);
	_Map.setString("ReportEntry",sReportEntry);
	_Map.setDouble("textHeight",dTxtH);	
	






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
      <str nm="Comment" vl="HSB-21653: Erase instance if invalid data found " />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="3/13/2024 8:34:02 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19977: Set flag to False for &quot;addRoofplanesAboveWallsAndRoofSectionsForRoofs&quot; for TSLs &quot;Soligno-AbrechnungBearbeitung&quot;" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="9/6/2023 4:15:18 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl=" 20230714: Holzius, include defining entity" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="7/14/2023 2:23:00 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17987: show scriptName in reportMessages" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="2/16/2023 8:48:00 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17929 consumes showset of multipage" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="12/12/2022 12:50:54 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End