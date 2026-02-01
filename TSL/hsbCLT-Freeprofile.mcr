#Version 8
#BeginDescription
#Versions
Version 2.5    27.02.2023 HSB-16803 invalid extrusion definitions will convert to path

Version 2.4    20.10.2021 HSB-13565 new custom commands to maintain additional properties, new setting property to set arc approximation (default = 0.1mm) ,
Version 2.3    30.06.2021    HSB-12442 alignment fixed if width > tool diameter
Version 2.2    25.06.2021    HSB-12409: do the tooling to get the cuttingBody in case it fails
Version 2.1    16.06.2021    HSB-12246 new tool mode 'Polyline Path Tool Combination' added (mode 4), new custom commands to store settings
Version 2.0    07.06.2021    HSB-12143 new tool mode 'Polyline Extrusion Body' added. The specified contour will not be manipulated and it is the designers responsibilty to choose the correct matching milling head


This tsl creates a freeprofile tool based on a selected polyline and one or multiple panels

NOTE The tool specification of the machine needs to be synchronized with the parameters in hsbcad.






#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 5
#KeyWords freeprofile;CLT;polyline
#BeginContents
//region Part #1
/// <History>//region
// #Versions
// 2.5 27.02.2023 HSB-16803 invalid extrusion definitions will convert to path , Author Thorsten Huck
// 2.4 20.10.2021 HSB-13565 new custom commands to maintain additional properties, new setting property to set arc approximation (default = 0.1mm) , Author Thorsten Huck , Author Thorsten Huck
// 2.3 30.06.2021 HSB-12442 alignment fixed if width > tool diameter , Author Thorsten Huck
// 2.2 25.06.2021 HSB-12409: do the tooling to get the cuttingBody in case it fails Author: Marsel Nakuci
// 2.1 16.06.2021 HSB-12246 new tool mode 'Polyline Path Tool Combination' added (mode 4), new custom commands to store settings , Author Thorsten Huck
// 2.0 07.06.2021 HSB-12143 new tool mode 'Polyline Extrusion Body' added. The specified contour will not be manipulated and it is the designers responsibilty to choose the correct matching milling head , Author Thorsten Huck
///	<version value="1.9" date="20oct2020" author="marsel.nakuci@hsbcad.com"> HSB-9663: add a tolerance </version>
///	<version value="1.8" date="20oct2020" author="thorsten.huck@hsbcad.com"> HSB-9338 internal naming bugfix </version>
/// <version value="1.7" date="15jul2020" author="thorsten.huck@hsbcad.com"> HSB-7281 solid tool width corrected if in circumference mode and width > tool diameter </version>
/// <version value="1.6" date="07may2020" author="thorsten.huck@hsbcad.com"> HSB-7491 performance improved by segmented defining contour, defining contour with arcs published for shopdrawings </version>
/// <version value="1.5" date="21apr2020" author="thorsten.huck@hsbcad.com"> HSB-7281 bugfix on beveled tools </version>
/// <version value="1.4" date="15apr2020" author="thorsten.huck@hsbcad.com"> HSB-7266 overshoot correction on open contours added, requires 22.1.54, 23.0.36 or higher </version>
/// <version value="1.3" date="01apr2020" author="thorsten.huck@hsbcad.com"> HSB-7178 new tool mode extrusion body with cleanup, catching paths which cannot be offseted by ACAD </version>
/// <version value="1.2" date="09mar2020" author="thorsten.huck@hsbcad.com"> HSB-6916 bugfix on insert for plines on contour </version>
/// <version value="1.1" date="09mar2020" author="thorsten.huck@hsbcad.com"> HSB-6700 typos fixed </version>
/// <version value="1.0" date="17feb2020" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select panels and polylines, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates a freeprofile tool based on a selected polyline and one or multiple panels
/// </summary>

/// <remark Lang=en>
/// The tool specification of the machine needs to be synchronized with the parameters in hsbcad.
/// </remark>


/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCLT-Freeprofile")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "../|Flip Side|") (_TM "|Select freeprofile tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "../|Add/Remove Panel|") (_TM "|Select freeprofile tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "../|Add Ecs|") (_TM "|Select freeprofile tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "../|Add/Remove Format|") (_TM "|Select freeprofile tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Specify Tool|"") (_TM "|Select freeprofile tool|"))) TSLCONTENT
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
		if(bDebug)reportMessage("\n\n"+ scriptName() + " starting " + _ThisInst.handle() );		
	}
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	
	String opmKey = "SpecifyTool";
//end Constants//endregion

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sFileName ="hsbCLT-Freeprofile";
	Map mapSetting;

// find settings file
	String sFolders[]=getFoldersInFolder(sPath); 
	int bPathFound;
	if (_bOnInsert)
		bPathFound= sFolders.find(sFolder)>-1?true:makeFolder(sPath+"\\"+sFolder);	
	String sFullPath = sPath+"\\"+sFolder+"\\"+sFileName+".xml";
	String sFile=findFile(sFullPath); 
	// if no settings file could be found in company try to find it in the installation path
	if (sFile.length()<1)sFile=findFile(_kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\"+sFileName+".xml");


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

// This TSL supports two alternatives two specify the tool data: 1. through xml based settings or 2. by opmKey-based catalog entries
//region SpecifyTool Mode (2)
	int nMode = _Map.getInt("mode");// 1 = tool specification mode
	if (nMode==1)
	{
		setOPMKey(opmKey);
	
		String sToolnameName=T("|Toolname|");	
		PropString sToolname(nStringIndex++, "", sToolnameName);	
		sToolname.setDescription(T("|Defines the Toolname|"));
		sToolname.setCategory(category);
		
		String sDiameterName=T("|Diameter|");	
		PropDouble dDiameter(nDoubleIndex++, U(0), sDiameterName);	
		dDiameter.setDescription(T("|Defines the Diameter|"));
		dDiameter.setCategory(category);
		
		String sLengthName=T("|Length|");	
		PropDouble dLength(nDoubleIndex++, U(0), sLengthName);	
		dLength.setDescription(T("|Defines the Length|"));
		dLength.setCategory(category);
		
		String sToolindexName=T("|Toolindex|");	
		PropInt nToolindex(nIntIndex++, 0, sToolindexName);	
		nToolindex.setDescription(T("|Defines the Toolindex|"));
		nToolindex.setCategory(category);
		
	
		//setExecutionLoops(2);
		return;
	}//endregion	

//region DialogMode
	int nDialogMode = _Map.getInt("DialogMode");
	if (nDialogMode>0)
	{ 
		if (nDialogMode == 1) // specify index when triggered to get different dialogs
		{
			setOPMKey("Display");	

		category = T("|Display|");
			String sColorName=T("|Color|");	
			PropInt nColor(nIntIndex++, 7, sColorName);	
			nColor.setDescription(T("|Defines the color|"));
			nColor.setCategory(category);

			String sTransparencyName=T("|Transparency|");	
			PropInt nTransparency(nIntIndex++, 50, sTransparencyName);	
			nTransparency.setDescription(T("|Defines the Transparency|"));
			nTransparency.setCategory(category);
			
			String sDimStyleName=T("|Dimstyle|");	
			PropString sDimStyle(nStringIndex++, _DimStyles.sorted(), sDimStyleName);	
			sDimStyle.setDescription(T("|Defines the DimStyle|"));
			sDimStyle.setCategory(category);
			
			String sTextHeightName=T("|TextHeight|");	
			PropDouble dTextHeight(nDoubleIndex++, U(0), sTextHeightName);	
			dTextHeight.setDescription(T("|Defines the TextHeight|"));
			dTextHeight.setCategory(category);
			
		category = T("|Extrusion|");	
			PropInt nColor2(nIntIndex++, 7, sColorName);	
			nColor2.setDescription(T("|Defines the color|"));
			nColor2.setCategory(category);

			String sColorRef2Name=T("|Color Reference Side|");	
			PropInt nColorRef2(nIntIndex++, 7, sColorName);	
			nColorRef2.setDescription(T("|Defines the color|"));
			nColorRef2.setCategory(category);

			PropInt nTransparency2(nIntIndex++, 50, sTransparencyName);	
			nTransparency2.setDescription(T("|Defines the Transparency|"));
			nTransparency2.setCategory(category);
	
			PropString sDimStyle2(nStringIndex++, _DimStyles.sorted(), sDimStyleName);	
			sDimStyle2.setDescription(T("|Defines the DimStyle|"));
			sDimStyle2.setCategory(category);
	
			PropDouble dTextHeight2(nDoubleIndex++, U(0), sTextHeightName);	
			dTextHeight2.setDescription(T("|Defines the TextHeight|"));
			dTextHeight2.setCategory(category);
						
		category = T("|Contour|");	
			PropInt nColor3(nIntIndex++, 7, sColorName);	
			nColor3.setDescription(T("|Defines the color|"));
			nColor3.setCategory(category);

			String sColorRef3Name=T("|Color Reference Side|");	
			PropInt nColorRef3(nIntIndex++, 7, sColorName);	
			nColorRef3.setDescription(T("|Defines the color|"));
			nColorRef3.setCategory(category);

			PropInt nTransparency3(nIntIndex++, 50, sTransparencyName);	
			nTransparency3.setDescription(T("|Defines the Transparency|"));
			nTransparency3.setCategory(category);
	
			PropString sDimStyle3(nStringIndex++, _DimStyles.sorted(), sDimStyleName);	
			sDimStyle3.setDescription(T("|Defines the DimStyle|"));
			sDimStyle3.setCategory(category);
	
			PropDouble dTextHeight3(nDoubleIndex++, U(0), sTextHeightName);	
			dTextHeight3.setDescription(T("|Defines the TextHeight|"));
			dTextHeight3.setCategory(category);			
			
			

		}			
		
		else if (nDialogMode == 2) // specify index when triggered to get different dialogs
		{
			setOPMKey("Tool");
			
		category = T("|Tool|");	
			String sDiameterName=T("|Diameter|");	
			PropDouble dDiameter(nDoubleIndex++, U(20), sDiameterName);	
			dDiameter.setDescription(T("|Defines the tool diameter|"));
			dDiameter.setCategory(category);
			
			String sLengthName=T("|Length|");	
			PropDouble dLength(nDoubleIndex++, U(0), sLengthName);	
			dLength.setDescription(T("|Defines the tool length|"));
			dLength.setCategory(category);
			
			String sToolIndexName=T("|ToolIndex|");	
			PropInt nToolIndex(nIntIndex++, 4, sToolIndexName);	
			nToolIndex.setDescription(T("|Defines the ToolIndex|"));
			nToolIndex.setCategory(category);
			
			String sNameName=T("|Name|");	
			PropString sName(nStringIndex++, "Millhead", sNameName);	
			sName.setDescription(T("|Defines the name of the tool|"));
			sName.setCategory(category);
			
		category = T("|Arc Approximation|");		
			String sAccuracyName=T("|Accuracy|");	
			PropDouble dAccuracy(nDoubleIndex++, dEps, sAccuracyName);	
			dAccuracy.setDescription(T("|Defines the accuracy of arc to line segment approximation.|") + T("|Accuracy = 0 means no line approximation|"));
			dAccuracy.setCategory(category);
		}
		else if (nDialogMode == 3)// Beamcut
		{
			setOPMKey("Edit Tool Combination");
			
			String sMinStraightName=T("|Min. Length|");	
			PropDouble dMinStraight(nDoubleIndex++, U(500), sMinStraightName);	
			dMinStraight.setDescription(T("|Defines the minmal length of a straight segment to be replaced as beamcut|"));
			dMinStraight.setCategory(category);
			
			String sOverlapName=T("|Overlap|");	
			PropDouble dOverlap(nDoubleIndex++, U(100), sOverlapName);	
			dOverlap.setDescription(T("|Defines the overlap of the remaining freeprofiles into the beamcut replacements.|"));
			dOverlap.setCategory(category);			
		}		
		return;		
	}
//End DialogMode//endregion	


//region Variables
	String scriptName = bDebug ? "hsbCLT-Freeprofile" : scriptName();
	String scriptOpmName = scriptName + "-" +opmKey;
	String sOpmEntries[0]; if(mapSetting.length()<1)sOpmEntries = TslInst().getListOfCatalogNames(scriptOpmName);

// default modes, not used as soon as settings or opmKey catalogs are found	
	String sDefaultModes[] = {T("|Finger Mill|"),T("|Universal Mill|"),T("|Vertical Finger Mill|")};
	double sDefaultDiameters[0];
	double sDefaultLengths[0];
	int nDefaultModes[0];
	if (mapSetting.length()<1)
	{ 
		PLine pl(_Pt0, _Pt0 + _XW * U(100));
		for (int i=0;i<sDefaultModes.length();i++) 
		{ 
			FreeProfile fp(pl,_kLeft);
			fp.setCncMode(i);
			sDefaultDiameters.append(fp.millDiameter());
			sDefaultLengths.append(0);
			nDefaultModes.append(i);			 
		}//next i		
	}
//End variables//endregion 

//region Read Settings
	int bHasXmlSetting;
	String sToolNames[0];
	double dDiameters[0];
	double dLengths[0], dAccuracies[0];
	int nToolIndices[0];
	double dLineApproxAccuracy = dEps;
	
// mode 4 : path beamcut combination
	Map mapToolModes;
	double dMinStraight = U(500);
	double dOverlap = U(100);	
	
{ 
	String k;

// Settings approach (1)
	Map m,mapTools= mapSetting.getMap("Tool[]");
	mapToolModes = mapSetting.getMap("ToolMode[]");
	for (int i=0;i<mapTools.length();i++) 
	{ 
		Map m= mapTools.getMap(i);
		
		String name;
		int index, bOk=true;
		double diameter, length, accuracy;
		k="Diameter";		if (m.hasDouble(k) && m.getDouble(k)>0)	diameter = m.getDouble(k);	else bOk = false;
		k="Length";			if (m.hasDouble(k) && m.getDouble(k)>0)	length = m.getDouble(k);	else bOk = false;
		k="Name";			if (m.hasString(k))	name = m.getString(k);		else bOk = false;
		k="ToolIndex";		if (m.hasInt(k))	index = m.getInt(k); 		else bOk = false;
		
		k="Accuracy";		if (m.hasDouble(k)) accuracy = m.getDouble(k);
		
		if (bOk && sToolNames.find(name)<0 && nToolIndices.find(index)<0)
		{
			sToolNames.append(name);
			nToolIndices.append(index);
			dDiameters.append(diameter);
			dLengths.append(length);
			
			dAccuracies.append(accuracy);
			
			bHasXmlSetting = true;
		}	
	}//next i
	
// tool modes parameters
	for (int i=0;i<mapToolModes.length();i++) 
	{ 
		Map m= mapToolModes.getMap(i);		
		String name = m.getMapName();
		
	// mode 4	
		if (name == "Mode4")
		{ 
			k="MinLengthStraight";		if (m.hasDouble(k) && m.getDouble(k)>0)	dMinStraight = m.getDouble(k);
			k="Overlap";				if (m.hasDouble(k) && m.getDouble(k)>0)	dOverlap = m.getDouble(k);
		}		 
	}//next i


// Get settings from opmKey catalog based definition
	if (sToolNames.length()<1 && sOpmEntries.length()>0)
	{ 
	// Declare TSL cloning variables
		TslInst t;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
		GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
		int nProps[]={};			double dProps[]={};				String sProps[]={};
		Map mapTsl;	
		mapTsl.setInt("mode", 1);
		
	// collect well defined entries
		for (int i=0;i<sOpmEntries.length();i++) 
		{ 
		// skip default and last
			if (sOpmEntries[i].find(sLastInserted, 0, false) >- 1 || sOpmEntries[i].find(sDefault, 0, false) >- 1) continue;			
			t.dbCreate(scriptName, vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, sOpmEntries[i],true, mapTsl,"","");	
			t.setPropValuesFromCatalog(sOpmEntries[i]);
			if (t.bIsValid())
			{
				String name=t.propString(0);
				double diameter=  t.propDouble(0);
				double length=t.propDouble(1);
				int index=t.propInt(0);
	
				if (diameter>0 && sToolNames.find(name)<0 && nToolIndices.find(index)<0)
				{
					sToolNames.append(name);
					nToolIndices.append(index);
					dDiameters.append(diameter);
					dLengths.append(length);
				}	
				t.dbErase();
			}
		}//next i
		if(bDebug)reportMessage("\n"+ scriptName() + " tool properties defined by opmKey catalog (" + sToolNames.length()+")");
	}

// append predefined values if no custom list found
	if (sToolNames.length()<1)
	{ 
		for (int i=0;i<sDefaultModes.length();i++) 
		{ 
			int n =sToolNames.find(sDefaultModes[i]); 	
			if (n<0)// && nToolIndices.find(nDefaultModes[i])<0)
			{ 
				sToolNames.append(sDefaultModes[i]);
				nToolIndices.append(nDefaultModes[i]);
				dDiameters.append(sDefaultDiameters[i]);
				dLengths.append(0);// unknown
			}	 
		}//next i

		reportMessage("\n"+ scriptName() + T(": |Unexpected error, please validate your tool definition.| ")+T("|Tool will be deleted.|"));
		eraseInstance();
		return;		
	}
}
//End Read Settings//endregion 

//region Properties
	category = T("|Alignment|");
	String sSideName=T("|Side|");	
	String sSides[] = {T("|Reference Side|"), T("|Opposite Side|")};
	PropString sSide(nStringIndex++, sSides, sSideName, 1);
	sSide.setDescription(T("Specifies the tool to be on the reference or opposite side of the panel."));
	sSide.setCategory(category);
	
	String sAlignments[] = {T("|Left|"),T("|Center|"),T("|Right|")};
	String sAlignmentName=T("|Alignment|");	
	PropString sAlignment(nStringIndex++, sAlignments, sAlignmentName);	
	sAlignment.setDescription(T("|Defines the alignment of the tool seen in the direction of the defining polyline.|"));
	sAlignment.setCategory(category);
	//  Polyline Path
	
	String tPolylinePath = T("|Polyline Path|"),tExtrusionBody =T("|Extrusion Body|"),
		tExtrusionCleanup =T("|Extrusion Body|") + T(" (|Corner Cleanup|)"),tPolylienExtriusion = T("|Polyline Extrusion Body|"),
		tPolylineCombination = T("|Polyline Path Tool Combination|");
	
	String sToolModes[] ={tPolylinePath, tExtrusionBody, tExtrusionCleanup, tPolylienExtriusion, tPolylineCombination};
	String sToolModeName=T("|Mode|");	
	PropString sToolMode(nStringIndex++, sToolModes.sorted(), sToolModeName);	
	sToolMode.setDescription(T("|Defines the wether the tool will mill the contour or the entire tool path area.|") + 
	"\n" + tPolylinePath + T(": |the freeprofile will only mill along the specified path|") + 
	"\n" + tExtrusionBody + T(": |the area of the specified path will be milled completely|") + T(" |and the path will be automatically rounded if applicable|")+
	"\n" + tExtrusionCleanup + T(": |the area of the specified path will be milled completely|") + T(" |and sharp corners will receive an automatic cleanup|")+ 
	"\n" + tPolylienExtriusion + T(": |the area of the specified path will be milled completely|") + T(" |and the path will not be modified|")+ 
	"\n" + tPolylineCombination + T(": |the freeprofile will only mill along the specified path|") + T(" |and straight segments extending the threshold will be excluded from the path and replaced by beamcuts|") 
	);
	sToolMode.setCategory(category);
	if (sToolMode == T("|Contour|"))sToolMode.set(tPolylinePath); // Version 2.1 toolname changed from contour to 'Polyline Path'
	int nToolMode = 0;
	
	if (sToolMode == tPolylinePath)nToolMode = 0;
	if (sToolMode == tExtrusionBody)nToolMode = 1;
	if (sToolMode == tExtrusionCleanup)nToolMode = 2;
	if (sToolMode == tPolylienExtriusion)nToolMode = 3;
	if (sToolMode == tPolylineCombination)nToolMode = 4;
	
	
	sToolModes.find(sToolMode);
	int bSolidPathOnly = nToolMode == 0 || nToolMode == 4;
	
// GEOMETRY
	category = T("|Tool|");
	String sToolNameName=T("|Tool|");
	PropString sToolName(nStringIndex++, sToolNames.sorted(), sToolNameName);
	sToolName.setDescription(T("|Defines the CNC Tool|"));
	sToolName.setCategory(category);
	if (sToolNames.findNoCase(sToolName,-1)<0 && sToolNames.length()>0)
	{ 
		sToolName.set(sToolNames.first());
		reportMessage("\n" + scriptName() + ": " +T("|Tool definition not found, changed to| "+sToolName));
	}

	String sDepthName=T("|Depth|");	
	PropDouble dDepth(nDoubleIndex++, U(20), sDepthName);	
	dDepth.setDescription(T("|Defines the depth of the tool|") + T(", |0 = complete through|"));
	dDepth.setCategory(category);

	String sWidthName=T("|Width|");	
	PropDouble dWidth(nDoubleIndex++, U(30), sWidthName);	
	dWidth.setDescription(T("|Defines the width of the tool|")+ T(", |0 = byDiameter|") );
	dWidth.setCategory(category);	
	
// DISPLAY
	category = T("|Display|");
	String sFormatName=T("|Format|");	
	PropString sFormat(nStringIndex++, "R@(Radius)", sFormatName);	
	sFormat.setDescription(T("|Defines the format of the description.|"));
	sFormat.setCategory(category);
//End Properties//endregion 

//region bOnInsert
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
		
	// prompt for panels and polylines
		Sip sips[0];
		EntPLine epls[0];	
	
		String promptDefault = T("|Select panels and polylines|");
		String prompt = promptDefault;
		while (sips.length()<1 || epls.length()<1)
		{ 
			PrEntity ssE(prompt, Sip());
			ssE.addAllowedClass(EntPLine());
			if (ssE.go())
			{
				Entity ents[0];
				ents.append(ssE.set());
				
			// get sips and entplines		
				for (int i=0;i<ents.length();i++) 
				{ 
					Sip sip = (Sip)ents[i];
					if (sip.bIsValid() && sips.find(sip)<0)
					{
						sips.append(sip);
						continue;
					}
					EntPLine epl = (EntPLine)ents[i];
					if (epl.bIsValid() && epls.find(epl)<0)
					{
						epls.append(epl);
						continue;
					}			 
				}//next i				
				prompt = promptDefault + T(", |Panels|(") + sips.length() + T("), |Polylines|(") + epls.length()+")";
				if (epls.length()<1 && sips.length()>0)
					prompt += T(", |at least 1 polyline required|");
				else if (epls.length()>0 && sips.length()<1)
					prompt += T(", |at least 1 panel required|");					
			}
			else
				break;	
		}


	// create instances per polyline
		if (epls.length()>0)
		{ 
			for (int i=0;i<epls.length();i++) 
			{ 
				EntPLine epl = epls[i];
				PLine pl = epl.getPLine();
			
			// test area or splitSegment
				LineSeg seg;
				PLine plHull;
				plHull.createConvexHull(Plane(pl.ptStart(), pl.coordSys().vecZ()), pl.vertexPoints(true));
				PlaneProfile ppPL;
				if (plHull.area()>pow(dEps,2))
					ppPL=PlaneProfile(plHull);
			// test intersection	
				else
				{ 
					Point3d pts[] = pl.vertexPoints(true);
					seg = LineSeg(pts.first(), pts.last());
				}
				
			// create TSL
				TslInst tslNew;
				GenBeam gbsTsl[] = {};		Entity entsTsl[] = {epls[i]};	Point3d ptsTsl[] = {pl.ptStart()};
				int nProps[]={};			double dProps[]={dDepth, dWidth};				String sProps[]={sSide,sAlignment, sToolMode,sToolName,sFormat};
				Map mapTsl;	
				
				
			// collect panels intersecting the pline
				for (int j=0;j<sips.length();j++) 
				{ 
					Sip sip= sips[j];
				
				// get shape of panel
					PlaneProfile pp(sip.plEnvelope());
					PLine plOpenings[] = sip.plOpenings();
					for (int k=0;k<plOpenings.length();k++) 
						pp.joinRing(plOpenings[k],_kSubtract); 
					
				// collect if intersecting	
					int bCollect;
					if (seg.length()<dEps)
					{ 
						PlaneProfile _pp = pp;
						_pp.intersectWith(ppPL);
						if (_pp.area()>pow(dEps,2))
							bCollect = true;
						if(bDebug)reportMessage("\n"+ scriptName() + " case 1 = " + bCollect);	
					}
					else if (pp.splitSegments(seg,true).length()>0)
					{ 	
						bCollect = true;
						if(bDebug)reportMessage("\n"+ scriptName() + " case 2 = " + bCollect);
					}
				// test if any vertex of the pline is within or on sip shadow
					if (!bCollect);
					{ 
						pl.projectPointsToPlane(Plane(pp.coordSys().ptOrg(), pp.coordSys().vecZ()), sip.vecZ());
						Point3d pts[] = pl.vertexPoints(true);
						for (int p=0;p<pts.length();p++) 
						{ 
							if (Vector3d(pp.closestPointTo(pts[p])-pts[p]).length()<dEps)
							{
								bCollect=true;
								break;
							}
							 
						}//next p
						if(bDebug)reportMessage("\n"+ scriptName() + " case 3 = " + bCollect);
					}
					if (bCollect)
						gbsTsl.append(sip);
					
				}//next j
					
			// create if panels found
				if(bDebug)reportMessage("\n"+ scriptName() + " has found " + gbsTsl.length() + " panels against polyline " + epl.handle());	
				if (gbsTsl.length()>0)
					tslNew.dbCreate(scriptName() , _XU ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	
				 
			}//next i
			
		}
		eraseInstance();	
		return;
	}	
// end on insert	__________________//endregion
		
//End Part #1//endregion 

//region Part #2
//region Set general behaviour and get references
	_ThisInst.setAllowGripAtPt0(false);
	setEraseAndCopyWithBeams(_kBeam0);
	Sip sips[0];sips = _Sip;
	EntPLine epl;
	PLine plDefine;
	Entity ents[0]; ents=_Entity;

	EcsMarker ecs;
	for (int i=0;i<ents.length();i++) 
	{ 
		EntPLine _epl = (EntPLine)ents[i];
		if (_epl.bIsValid() && !epl.bIsValid())
		{
			epl = _epl;
			setDependencyOnEntity(epl);
			plDefine = epl.getPLine();
			//_Pt0 = plDefine.closestPointTo(_Pt0);
		}
		else if (ents[i].bIsKindOf(EcsMarker()))
		{ 
			ecs = (EcsMarker)ents[i];
			setDependencyOnEntity(ecs);
		}
	}//next i			
//End set general behaviour and get references//endregion 

//region Trigger
//region Trigger AddRemovePanel
	String sTriggerAddRemovePanel = T("|Add/Remove Panel|");
	addRecalcTrigger(_kContextRoot, sTriggerAddRemovePanel );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddRemovePanel)
	{
	// prompt for panels
		Entity ents[0];
		PrEntity ssE(T("|Select panels"), Sip());
		if (ssE.go())
			ents.append(ssE.set());
	
	// add or remove
		for (int i=0;i<ents.length();i++) 
		{ 
			int n = _Sip.find(ents[i]);
		// remove	
			if (n>-1)
				_Sip.removeAt(n);
			else
				_Sip.append((Sip)ents[i]);
			 
		}//next i

		setExecutionLoops(2);
		return;
	}//endregion	

// TriggerFlipSide
	String sTriggerFlipSide = T("|Flip Side|");
	addRecalcTrigger(_kContextRoot, sTriggerFlipSide );
	if (_bOnRecalc && (_kExecuteKey==sTriggerFlipSide || _kExecuteKey==sDoubleClick))
	{
		String side = sSide;
		if (side == sSides.first())side = sSides.last();
		else if (side == sSides.last())side = sSides.first();
		sSide.set(side);
		setExecutionLoops(2);
		return;
	}

//region Trigger SpecifyTool
	if (!bHasXmlSetting)
	{ 
		String sTriggerSpecifyTool = T("|Specify Tool|");
		addRecalcTrigger(_kContext, sTriggerSpecifyTool );
		if (_bOnRecalc && _kExecuteKey==sTriggerSpecifyTool)
		{
		// create TSL
			TslInst t;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
			GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {};
			int nProps[]={};			double dProps[]={};				String sProps[]={};
			Map mapTsl;
			mapTsl.setInt("mode", 1);
						
			t.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			
	
			if (t.bIsValid())
			{ 
			// get all existing catralog entries
				String entries[] = t.getListOfCatalogNames();
				
				
				t.showDialog();
				
			// validate entry
				int bOk=true;
				String name = t.propString(0);
				double diameter = t.propDouble(0);
				double length = t.propDouble(1);
				double index = t.propInt(0);
				
				if (name.length() < 1 || diameter<=0 || index<0)bOk = false;
				
				
				if (bOk)
				{ 
					t.setCatalogFromPropValues(name);
				}
				
				t.dbErase();
			}
	
			setExecutionLoops(2);
			return;
		}
	}//endregion
		
//End Trigger//endregion 

// get normal of polyline
	Vector3d vecNormal = plDefine.coordSys().vecZ();	
	
	int nAlignment = sAlignments.find(sAlignment,1)-1; // -1 = left, 0 = center , 1 = right
	int nToolIndex = sToolNames.find(sToolName, 0);
	int nCncMode = nToolIndices[nToolIndex];
	double dDiameter = dDiameters[nToolIndex];	
	double dLength = dLengths[nToolIndex];

	dLineApproxAccuracy = dAccuracies.length() > nToolIndex ? dAccuracies[nToolIndex] : dLineApproxAccuracy;
	sToolName.setDescription(T("|Defines the CNC Tool|") + ", Ø "+dDiameter + (dLength>0?"/"+dLength:""));

// validate width in polyline path modes
	if (bSolidPathOnly && dDiameter>0 && dWidth<dDiameter && dWidth!=0)
	{ 
		reportMessage(TN("|The width of a contour milling cannot be smaller then the tool diameter.|"));
		dWidth.set(dDiameter);
		setExecutionLoops(2);
		return;	
	}
	
// validate mode if path is not closed //HSB-16803
	if (!plDefine.isClosed() && abs(dWidth-dDiameter)<dEps && !bSolidPathOnly)
	{ 
		sToolMode.set(tPolylinePath);
		reportMessage(TN("|Tool Mode corrected to| ") + tPolylinePath);
		setExecutionLoops(2);
		return;
	}
	
	
	

//region Get valid panels and default vectors
// exclude any panel being perpendicular to the normal
	for (int i=sips.length()-1; i>=0 ; i--) 
		if (vecNormal.isPerpendicularTo(sips[i].vecZ()))
			sips.removeAt(i); 

// validate
	if (sips.length()<1 || !epl.bIsValid())
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|invalid selection set.|"));
		eraseInstance();
		return;
	}
	
// get main ref
	Sip sip = sips.first();
	Vector3d vecX, vecY, vecZ;
	vecX = sip.vecX();
	vecY = sip.vecY();
	vecZ = sip.vecZ();
	assignToGroups(sip, 'I');
	epl.assignToGroups(sip, 'T');
//End Get valid panels//endregion 

//region Check for duplicates
	if (_bOnDbCreated)
	{ 
		Entity eTools[] = sip.eToolsConnected();
		TslInst tsls[0];
		for (int i=0;i<eTools.length();i++) 
		{ 
			TslInst t =(TslInst)eTools[i]; 
			if (!t.bIsValid() ||t==_ThisInst)continue;
			if ((bDebug && t.scriptName() != scriptName()) || (bDebug && t.scriptName()!="hsbCLT-Freeprofile")) continue;

			Entity ents[] = t.entity();
			Sip sips2[] = t.sip();
			
			if (ents.find(epl)>-1 && sips2.find(sip)>-1)
			{ 
				reportMessage("\n"+ scriptName() + ": "+T("|The polyine is already linked to the same panel.| ")+T("|Tool will be deleted.|"));
				eraseInstance();
				return;	
			}
		}//next i
	}	
//End Check for duplicates//endregion 

//region Get face and tool normal
	int nSide = sSides.find(sSide) == 1 ? 1 :-1;
	Vector3d vecFace = vecZ * nSide;
	if (vecNormal.dotProduct(vecFace)<0)
	{ 
		vecNormal *= -1;
		plDefine.flipNormal();
	}
		
	vecNormal.vis(plDefine.ptStart(), 2);
	vecFace.vis(plDefine.ptEnd(), 150);

	int nc = nSide==1?6:3; // default color
	int nt; // default transparency


// get relevant plane in face
	Point3d ptsX[0];
	Quader qdrRef;
	for (int i=0;i<sips.length();i++) 
	{ 
		Sip s=sips[i]; 
		ptsX.append(s.ptCen() - s.vecZ() * .5*s.dH());
		ptsX.append(s.ptCen() + s.vecZ() * .5*s.dH());
//		Quader qdr(s.ptCen(), s.vecX(), s.vecY(), s.vecZ(), s.solidLength(), s.solidWidth(), s.solidHeight(), 0, 0, 0);
//		ptsX.append(qdr.pointAt(1, 1, 1));
//		ptsX.append(qdr.pointAt(-1, -1, -1)); 
	}//next i
	ptsX = Line(_Pt0, vecFace).orderPoints(ptsX);
	if (ptsX.length()<1)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|unexpected error|"));
		eraseInstance();
		return;
	}
	Point3d ptFace = ptsX.last();
	Plane pnFace(ptFace, vecFace);
	Plane pnNormal(ptFace, vecNormal);
	//pnFace.vis(2);	

//End Get face and tool normaöl//endregion 	

//region Get common profile and defining tool contour
// get common profile
	PlaneProfile ppCommon(sips.first().coordSys());
	for (int i=0;i<sips.length();i++) 
		ppCommon.joinRing(sips[i].plEnvelope(), _kAdd); 
	for (int i = 0; i < sips.length(); i++)
	{
		PLine plOpenings[] = sips[i].plOpenings();
		for (int j = 0; j < plOpenings.length(); j++)
			ppCommon.joinRing(plOpenings[j], _kSubtract);
	}

// get defining tool contour
	plDefine.projectPointsToPlane(pnNormal, vecNormal);
	PLine plTool = plDefine;
	int bIsClosed =plTool.isClosed();
		
	
	
// revert pline 
	{ 
		PlaneProfile pp(plTool);
		Point3d pts[] = plTool.vertexPoints(false);
		Point3d pt = plTool.getPointAtDist(2*dEps);
		Vector3d vecXS = plTool.getTangentAtPoint(pt);
		Vector3d vecYS = vecXS.crossProduct(-plTool.coordSys().vecZ());
		if (pp.area()>pow(dEps,2) && pp.pointInProfile(pt+vecYS*dEps)!=_kPointInProfile)
			plTool.reverse();
	}
//End Get common profile and defining tool contour//endregion 
//End Part #2//endregion 

//region Modification of tool pline with fillets and cleanups
// set alignment to center if closed and toolmode complete
	_Map.setPLine("plDefine", plTool);
	double dMillDiameter = dWidth<=0?dDiameter:dWidth;
	if (bIsClosed && !bSolidPathOnly)
	{
		dMillDiameter = dDiameter;
		if (nAlignment!=0)//-1 = left, 0 = center , 1 = right
		{
			nAlignment = 0;
			sAlignment.set(sAlignments[nAlignment+1]);	
		}
		sAlignment.setReadOnly(true);
	}

// offset pline two both sides to receive round filled pline
	if (bSolidPathOnly)
	{ 
		int bIsWide = dWidth > dDiameter;
		double offset = bIsWide?(dWidth-dDiameter)*.5:0;
		//plTool.vis(255);
		if (nAlignment!=0)// left or right
		{ 	
			if (bIsWide)
			{
				plTool.offset(nAlignment*.5*dWidth,false);		plTool.vis(3);
			}
			else
			{ 
				plTool.offset(nAlignment*.5*dDiameter,false);		plTool.vis(3);
			}			
		}
		//plTool.vis(3);
	}
	else if (nToolMode==1)
	{ 
		double area = plTool.area();
		plTool.offset(-.5*dDiameter);			plTool.vis(2);

		if (plTool.area()-area>pow(dEps,2))
		{
			plTool.offset(dDiameter,false);		plTool.vis(4);
			plTool.offset(-.5*dDiameter);		plTool.vis(3);
		}
		else if (_bOnDbCreated || _kNameLastChangedProp==sToolNameName)
		{ 
			reportMessage(TN("|Could not offset contour for smoothening, original tool path used.|"));			
		}
	}
	else if (nToolMode==2)
	{ 
		PLine plCleanUp(plTool.coordSys().vecZ());
		PlaneProfile ppTool(plTool);
		
		Point3d pts[] = plTool.vertexPoints(true);

	// loop vertices
		for (int i=0;i<pts.length();i++) 
		{ 
		//region Look at previous and next segment
			int n = i == 0 ? pts.length() - 1 : i - 1;
			int m = i == pts.length() - 1 ? 0: i + 1;
			
		// test if one of the segments is an arc and if the arc is concave or convex
			Point3d ptN = (pts[i] + pts[n]) * .5;	//ptN.vis(i);
			int bIsArcN = ! plTool.isOn(ptN);
			int bIsConcaveN = ppTool.pointInProfile(ptN)==_kPointOutsideProfile;
			Point3d ptM = (pts[i] + pts[m]) * .5;	//ptM.vis(i);
			int bIsArcM = ! plTool.isOn(ptM);
			int bIsConcaveM = ppTool.pointInProfile(ptM)==_kPointOutsideProfile;				
		//End Look at previous and next segment//endregion 	

			
		// arc and first vertex	
			if ((bIsArcN || bIsArcM) && plCleanUp.vertexPoints(true).length()==0)
				plCleanUp.addVertex(pts[i]);
		// previous is a convex arc		
			else if (bIsArcN && !bIsConcaveN)
			{
				double d = plTool.getDistAtPoint(pts[i])-dEps;
				if (d <= dEps)d = plTool.length() - dEps;
				plCleanUp.addVertex(pts[i],plTool.getPointAtDist(d));
				//plCleanUp.vis(6);
			}
		// next segment is convex arc	
			else if (bIsArcM && !bIsConcaveM)
			{
				//pts[i].vis(6);
				plCleanUp.addVertex(pts[i]);
			}
		// two straight segments or connecting to a concave arc	
			else if ((!bIsArcN && !bIsArcM) || (bIsConcaveN ||bIsConcaveM))
			{ 
			// 'a' is the segemnt before, 'b' is the segment after the vertex	
				double d = plTool.getDistAtPoint(pts[i])-dEps;
				if (d <= dEps)d = plTool.length() - dEps;
				Point3d ptA = plTool.getPointAtDist(d);
				Vector3d vecA = pts[i] - ptA;	vecA.normalize();
				d = plTool.getDistAtPoint(pts[i])+dEps;
				if (d >plTool.length())d = dEps;
				Point3d ptB = plTool.getPointAtDist(d);
				Vector3d vecB = pts[i] - ptB;	vecB.normalize();
				Vector3d vecM = vecA + vecB; 	vecM.normalize();	vecM.vis(pts[i], 4);
				
				Vector3d vecAY = vecM.crossProduct(vecA).crossProduct(-vecA);	vecAY.normalize();	//vecA.vis(pts[i], 1); vecAY.vis(pts[i], 3);			
				Vector3d vecBY = vecM.crossProduct(vecB).crossProduct(-vecB);	vecBY.normalize();	//vecBY.vis(pts[i], 3);
								
			//region find center of cleanup circle
				Point3d ptX;
				int bOk=Line(pts[i] - vecAY * .5 * dDiameter, vecA).hasIntersection(Plane(pts[i] - vecBY * .5 * dDiameter, vecBY), ptX);
				double delta = vecM.dotProduct(pts[i] - ptX);
				//ptX.vis(2);
				ptX += vecM * (delta-dDiameter * .5);	//ptX.vis(20);
				PLine plCirc;
				plCirc.createCircle(ptX, vecZ, dDiameter * .5);
				plCirc.vis(252);					
			//End find center of cleanup circle//endregion 					


				Vector3d vecMY = vecM.crossProduct(-vecZ);
				Point3d ptsA[] = Line(pts[i], vecA).orderPoints(plCirc.intersectPoints(Plane(pts[i], vecAY)));
				Point3d ptsB[] = Line(pts[i], vecB).orderPoints(plCirc.intersectPoints(Plane(pts[i], vecBY)));
				if (ptsA.length()>0 && ptsB.length()>0)
				{ 
				// test for sharp angles
					int bIsSharp = vecM.dotProduct(ptX-((ptsA.first() + ptsB.first()) * .5))>dEps;
				//region corners < 90°
					if (bIsSharp)
					{ 
						
						vecMY.vis(ptsA.first(), 4);
						Point3d ptsM[] = Line(ptX, -vecMY).orderPoints(plCirc.intersectPoints(Plane(ptX, vecM)));
						if (ptsM.length()>0)
						{ 
							Point3d pt = ptsM.first();							//pt.vis(0);
							Line(pt, vecM).hasIntersection(Plane(pts[i], vecAY), pt);
							pt -= vecA * dEps;
							pt = plTool.closestPointTo(pt);						//pt.vis(4);
							
							if (bIsConcaveN)
							{	
								double d = plTool.getDistAtPoint(pt)-dEps;
								if (d <= dEps)d = plTool.length() - dEps;
								plCleanUp.addVertex(pt, plTool.getPointAtDist(d));	
							}
							else												//pt.vis(40);

							plCleanUp.addVertex(pt);
							pt = ptsM.first();									//pt.vis(3);
							plCleanUp.addVertex(pt);
							pt = ptsM.last();									//pt.vis(2);
							plCleanUp.addVertex(pt, pts[i]);
							Line(pt, vecM).hasIntersection(Plane(pts[i], vecBY), pt);
							pt -= vecB * dEps;
							pt = plTool.closestPointTo(pt);
							plCleanUp.addVertex(pt);
						}							
					}		
				//End corners < 90°//endregion 	
				// corners >=90°	
					else
					{ 
						ptsA.first().vis(1);									//ptsB.first().vis(1);
						plCleanUp.addVertex(ptsA.first());
						plCleanUp.addVertex(ptsB.first(), pts[i]);						
					}

				}
				else
					plCleanUp.addVertex(pts[i]);	
			}
//			if (bDebug)
//			{ 
////				PLine pl(pts[n], pts[i], pts[m]);
////				pl.transformBy(vecZ * (i+1) * U(15));
////				pl.vis(i);		
//				
//				PLine pl = plCleanUp;
//				pl.transformBy(-vecZ * (i+1) * U(15));
//				pl.vis(i);
//			}
		}//next i
		plCleanUp.close();		//plCleanUp.vis(6);
		
		if (plCleanUp.area()>plTool.area())
			plTool = plCleanUp;
		
		
	// buffer the shape
		plTool.convertToLineApprox(U(1));
		PLine _plTool = plTool;
		double area = plTool.area();
		plTool.offset(-.5*dDiameter);			
		double area1 = plTool.area();
		if (area1-area>pow(dEps,2))
		{
			//plTool.vis(2);
			area = plTool.area();
			plTool.offset(dDiameter,false);		
			area1 = plTool.area();
			if (area1-area>pow(dEps,2))
			{
				//plTool.vis(4);
				plTool.offset(-.5*dDiameter);	
				//plTool.vis(3);
			}
			else 
				plTool = _plTool;
		}
		else if (_bOnDbCreated || _kNameLastChangedProp==sToolNameName)
		{ 
			reportMessage(TN("|Could not offset contour for smoothening, original tool path used.|"));			
		}
	}		
	else if (nToolMode==3)
	{ 
		; // do nothing, it's the designers responsibility to specify the contour matching with the tool
	}
	
	
	//plTool.vis(1);		
//End Alignment and fillet pline//endregion 

//region Get length of tool path and validate if tooling pline intersects any of the panels
	double dLengthPath=plTool.length();
	Point3d ptsTool[] = plTool.vertexPoints(bIsClosed?false:true);
	Point3d ptStart, ptEnd;
	if (ptsTool.length()>0)
	{ 
		ptStart = ptsTool.first();
		ptEnd = ptsTool.last();	
	}

	{ 
		dLengthPath = 0;
		//ppCommon.vis(4);
		PLine pl = plTool;
		pl.convertToLineApprox(dDiameter);
		ptsTool= pl.vertexPoints(bIsClosed?false:true);
		PlaneProfile ppCommonExtend = ppCommon;
		// HSB-9663: add a tolerance
		ppCommonExtend.shrink(-U(dEps));
		for (int i=0;i<ptsTool.length()-1;i++) 
		{ 
			LineSeg seg(ptsTool[i],ptsTool[i+1]);
//			LineSeg segs[] = ppCommon.splitSegments(seg,true);
			// HSB-9663: add a tolerance
			LineSeg segs[] = ppCommonExtend.splitSegments(seg,true);
			for (int j=0;j<segs.length();j++) 
			{ 
			// get start and end of real tool on contour mode	
				if (i == 0 && j == 0)ptStart = segs[j].ptStart();
				else if (i == ptsTool.length()-2 && j == 0)ptEnd = segs[j].ptEnd();
				
				dLengthPath += segs.length();
				//segs[j].transformBy(vecZ * U(100));segs[j].vis((i+j)%8); 
				//segs[j].ptStart().vis(j);
			}//next j
		}//next i
	}
	if (dLengthPath<dEps)
	{ 
		reportMessage("\n"+ scriptName() + ": "+T("|The polyline does not intersect any panel of the selction set.| ")+T("|Tool will be deleted.|"));
		eraseInstance();
		return;	

	}
	if (!bIsClosed)
	{
		ptStart.vis(1);ptEnd.vis(1);
	}			
//End Get length of tool path and validate if tooling pline intersects any of the panels//endregion 
	
//region Trigger AddEcs
	String sTriggerAddEcs = T("|Add Ecs|");
	if (!ecs.bIsValid())addRecalcTrigger(_kContextRoot, sTriggerAddEcs );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddEcs)
	{
		Vector3d vecXE = plTool.getTangentAtPoint(plTool.getPointAtDist(dEps));
		Vector3d vecYE = vecXE.crossProduct(-vecNormal);
		CoordSys cs(plTool.ptStart(), vecXE, vecYE, vecNormal);
		EcsMarker ecs;
		ecs.dbCreate(cs);
		if (ecs.bIsValid())
		{
			_Map.setVector3d("vecX", vecXE);
			_Map.setVector3d("vecY", vecYE);
			_Map.setVector3d("vecZ", vecNormal);
			
			_Entity.append(ecs);
		}
		setExecutionLoops(2);
		return;
	}//endregion	

//region EcsAlignment
	if (ecs.bIsValid() && _Map.hasVector3d("vecX"))
	{ 
		Vector3d vecXE = _Map.getVector3d("vecX");
		Vector3d vecYE = _Map.getVector3d("vecY");
		Vector3d vecZE = _Map.getVector3d("vecZ");
		
		vecXE.vis(_Pt0, 1);
		vecYE.vis(_Pt0, 3);
				
	// transform if anything has chasnged
		CoordSys csE = ecs.coordSys();
		csE.vecX().vis(csE.ptOrg(), 1);
		csE.vecY().vis(csE.ptOrg(), 3);
		
		
		if (!(csE.vecX().isCodirectionalTo(vecXE) && 
			csE.vecY().isCodirectionalTo(vecYE) && 
			csE.vecZ().isCodirectionalTo(vecZE)))
		{ 
			CoordSys cs;
			cs.setToAlignCoordSys(csE.ptOrg(), vecXE, vecYE, vecZE, csE.ptOrg(),csE.vecX(), csE.vecY(), csE.vecZ());
			epl.transformBy(cs);
			_Map.setVector3d("vecX", csE.vecX());
			_Map.setVector3d("vecY", csE.vecY());
			_Map.setVector3d("vecZ", csE.vecZ());		
			setExecutionLoops(2);
			return;
		}
		
		else
			vecZE.vis(_Pt0, 150);
	}
//End EcsAlignment//endregion 

// transform tooling pline to face
	Point3d pts[] = Line(_Pt0, vecFace).orderPoints(plTool.vertexPoints(false));	
	{ 
		Point3d ptX;
		if (pts.length() > 0 && Line(pts.first(), vecNormal).hasIntersection(pnFace, ptX))
		{
			//ptX.vis(2);
			plTool.transformBy(ptX - pts.first());//
			pts = Line(_Pt0, vecFace).orderPoints(plTool.vertexPoints(false));
		}
	}

//region Treat polyline path as extrusion if width > diameter
	if (dWidth>dDiameter && 
		(bSolidPathOnly &&  !bIsClosed))
	{ 
		PLine plNewTool = plTool;// HSB-12442
		
		PlaneProfile pp(CoordSys(ptFace,vecX, vecX.crossProduct(-vecFace), vecFace));//XX
		
		double offset = (dWidth - dDiameter) * .5;
		int nStep = (offset / (.5*dDiameter))+1;
		
		for (int k=0;k<2;k++) 
		{ 
			int sgn = k == 0 ?- 1 : 1;
			double _offset;
			for (int i=0;i<nStep;i++) 
			{ 
				_offset +=sgn* .5 * dDiameter;
				plNewTool = plTool;// HSB-12442

				if (abs(_offset) > offset)_offset = sgn*offset;
				plNewTool.offset(_offset,false);plNewTool.vis(i);
				FreeProfile fp;	
				fp=FreeProfile(plNewTool, 0);
				fp.setSolidMillDiameter(dDiameter);
				fp.setSolidPathOnly(true);
				//fp.setDepth(U(10e2));
				if (pp.area()>pow(dEps,2))
					pp.unionWith(fp.cuttingBody().getSlice(pnNormal));
				else
					pp = fp.cuttingBody().getSlice(pnNormal);		
				//pp.vis(i);	
			}//next i
						
			 
		}//next k
		//pp.vis(6);
		
	// this should only have one ring
		PLine rings[] = pp.allRings(true, false);
		if (rings.length()>0)
		{ 
			//if (bDebug){Display dp(2); dp.draw(pp, _kDrawFilled, 40);}
			plNewTool = rings.first();
			//plNewTool.vis(2);

			plNewTool.offset(.5*dDiameter);plNewTool.vis(1);
			plNewTool.offset(-.5*dDiameter);plNewTool.vis(3);			
			plTool = plNewTool;
			nToolMode = 1;
			bSolidPathOnly = false;
			bIsClosed = true;
		}
	}
//Treat polyline path as extrusion if width > diameter
//endregion 


// Declare plines defining a freeprofile
	PLine plTools[] ={ plTool}; // by default it is only one, unless ToolMode = 4


//region Polyline Path Beamcut Combination
	CoordSys csFace(ptFace, vecX, vecX.crossProduct(-vecFace), vecFace);
	PlaneProfile ppBeamcutShape(csFace);
	
	
	if (bSolidPathOnly && nToolMode==4)
	{ 

	// analyse path
		PLine& pl = plTool;
		Point3d pts[] = pl.vertexPoints(true);

	//region collect segment type
		int types[0]; // per segment, 0 = arc, 1 = straight, 2 = straight extending min straight length
		for (int p=0;p<pts.length()-1;p++) 
		{ 
			Point3d pt1 = pts[p];
			Point3d pt2 = pts[p+1];
			
			double d = (pl.getDistAtPoint(pt1) + pl.getDistAtPoint(pt2)) * .5;
			Point3d ptx = pl.getPointAtDist(d);
			Point3d ptm = (pt1 + pt2) * .5;
			if (Vector3d(ptx-ptm).length()<dEps)// straight
			{ 
				double dL = (pt2 - pt1).length();
				types.append(dL<=dMinStraight?1:2);
			}
			else
				types.append(0);
		}			
	//End collect segment type//endregion 

	//region collect extended freeprofiles of defining pline
		PLine plines[0];	
		
		for (int p = 0; p < pts.length() - 1; p++)
		{
			int bDoPath = types[p] < 2; // ars or short straights will be processed as freeprofile
			Point3d pt1 = pts[p];
			Point3d pt2 = pts[p + 1];
			double dL = (pt2 - pt1).length();
			
			double d = (pl.getDistAtPoint(pt1) + pl.getDistAtPoint(pt2)) * .5;
			Point3d ptx = pl.getPointAtDist(d); // mid point on arc
			Point3d ptm = (pt1 + pt2) * .5; // mid point
			
			int bPreviousIsPath = p > 0 && types[p - 1] < 2;
			int bNextIsPath = p < pts.length() - 2 && types[p + 1] < 2;
			
		// add path
			if (bDoPath)
			{
				PLine path(vecFace);
			// collect previous path to append segment
				if (bPreviousIsPath && plines.length() > 0) 
					path = plines.last();
			// new path	
				else
				{
				// add start vertex extended on previous segment
					if (p > 0 && types[p - 1] == 2)
					{
						double dA = pl.getDistAtPoint(pt1) - dOverlap;
						if (dA > 0)
							path.addVertex(pl.getPointAtDist(dA));
					}
				// 	append or start vertex
					path.addVertex(pt1);
				}
				
			// append arc	
				if (types[p] == 0)
					path.addVertex(pt2, ptx);
			// append short straight segment		
				else
					path.addVertex(pt2);
				
			// append extended on next segment	
				if (p < pts.length() - 2 && types[p + 1] == 2) //&& types[p] == 0
				{
					double dA = pl.getDistAtPoint(pt2) + dOverlap;
					if (dA < pl.length())
						path.addVertex(pl.getPointAtDist(dA));
					else
						path.addVertex(pl.ptEnd());
				}
				
			// reasign path	
				if (bPreviousIsPath && plines.length() > 0)
					plines.last() = path;
			// add new path		
				else
					plines.append(path);
				
			// the current path ends on defining path	
				if (Vector3d(path.ptEnd() - pl.ptEnd()).length() < dEps)
				{
					if (bDebug){path.transformBy(vecZ * U(300));path.vis(5);}				
					break;
				}
				else if (bDebug){ path.transformBy(vecZ * U(300));path.vis(p);}
			}
		// add Beamcuts
			else if (dL>dEps && dMillDiameter>dEps && dDepth>dEps)
			{
				Vector3d vecXBc = pt2 - pt1; vecXBc.normalize();
				Vector3d vecYBc = vecXBc.crossProduct(-vecFace);
				BeamCut bc (pt1, vecXBc, vecYBc, vecFace, dL, dMillDiameter, dDepth * 2, 1, 0, 0);
				bc.cuttingBody().vis(6);
				bc.addMeToGenBeamsIntersect(sips);
				
				PlaneProfile pp = bc.cuttingBody().shadowProfile(pnFace);
				ppBeamcutShape.unionWith(pp);
			}
		}	
		
		plTools = plines;
	//End collect extended freeprofiles//endregion 
	
	}
	int bDrawBeamcut = ppBeamcutShape.area() > pow(dEps, 2);
//End Polyline Path Combination//endregion 

// HSB-12409
Body bdSips;
for (int i=0;i<sips.length();i++) 
{ 
	Body bdI(sips[i].ptCen(), sips[i].vecX(),sips[i].vecY(), sips[i].vecZ(),
		sips[i].dL() * 100, sips[i].dW() * 100, sips[i].dH(), 0, 0, 0);
	bdSips.addPart(bdI);
}//next i


//region Loop defining tool plines
	PlaneProfile ppFreeprofile(csFace), ppOutline=ppBeamcutShape;
	for (int t=0;t<plTools.length();t++) 
	{ 
		plTool = plTools[t]; 
		
	// define tool	
		FreeProfile fp;
	
		
		Body bdCaps[0];// potential drills at the end of a trimmed pline
		if (bSolidPathOnly)
		{ 
		//region Caps	
			// HSB-7266 and HSB-6647 trim open contours with default tool diameter	
			if (!bIsClosed && plTool.length()>dDiameter)
			{ 
			// trim pline at start end and add a solid subtract for rounded display
			// start of polyline
				Point3d ptX;
				ptX= plTool.ptStart();
				if (ppCommon.pointInProfile(ptX)==_kPointInProfile && ppBeamcutShape.pointInProfile(ptX)==_kPointOutsideProfile)
				{ 
					plTool.trim(dDiameter * .5, false);
					Point3d pt = plTool.ptStart();
					Body bd(pt, pt - vecFace * dDepth, dDiameter * .5);bd.vis(4);
					bdCaps.append(bd);
				}
			// End of polyline
				ptX= plTool.ptEnd();
				if (ppCommon.pointInProfile(ptX)==_kPointInProfile  && ppBeamcutShape.pointInProfile(ptX)==_kPointOutsideProfile)
				{ 
					plTool.trim(dDiameter * .5, true);
					Point3d pt = plTool.ptEnd();
					Body bd(pt, pt - vecFace * dDepth, dDiameter * .5);bd.vis(5);
					bdCaps.append(bd);			
				}			
			}	
		//End Caps//endregion 
			_Map.setPLine("plTool", plTool);// store before segmmentation
			if (dLineApproxAccuracy>0)plTool.convertToLineApprox(dLineApproxAccuracy);
			fp=FreeProfile(plTool, 0);
			
			fp.setSolidPathOnly(true);
		}
		else if (nToolMode==1 || nToolMode==2)
		{
			//plTool.vis(0);
			_Map.setPLine("plTool", plTool);// store before segmmentation
			if (dLineApproxAccuracy>0)plTool.convertToLineApprox(dLineApproxAccuracy);
			fp=FreeProfile(plTool, plTool.vertexPoints(true));
			fp.setMachinePathOnly(false);
		}
		else if (nToolMode==3)
		{
			if (dLineApproxAccuracy>0)plTool.convertToLineApprox(dLineApproxAccuracy);
			fp=FreeProfile(plTool, plTool.vertexPoints(true));
			fp.setMachinePathOnly(false);
		}	
	
		double dSolidDiameter =(dWidth > dDiameter && bSolidPathOnly)?dWidth: dDiameter;// HSB-7281
		fp.setSolidMillDiameter(dSolidDiameter);
		fp.setDepth(dDepth);
		fp.setCncMode(nCncMode);
		//fp.setDoSolid(false);	
		
	//region Add Tool
		// HSB-12409
		Body bdSipsCp = bdSips;
		Body bdTool = bdSipsCp;
		bdSipsCp.addTool(fp);
		bdTool.subPart(bdSipsCp);
//		Body bdTool = fp.cuttingBody();
		Point3d ptsExtr[] = bdTool.extremeVertices(vecNormal);

		
	// transform the freeProfile to upmost intersection	
		if (!vecNormal.isParallelTo(vecFace))
		{ 
			PlaneProfile pp = bdTool.shadowProfile(Plane(ptFace, vecNormal));
			PLine rings[] = pp.allRings(true, false);
			Point3d pts[0];
			for (int i=0;i<rings.length();i++) 
			{ 
				if (dLineApproxAccuracy>0)
					rings[i].convertToLineApprox(dLineApproxAccuracy); 
				Point3d _pts[] = rings[i].vertexPoints(true);
				Point3d pt;
				for (int j=0;j<_pts.length();j++) 
					if (Line(_pts[j], vecNormal).hasIntersection(pnFace, pt))
						pts.append(pt);	 
			}//next i
			
			pts= Line(_Pt0, vecNormal).orderPoints(pts);
	
			if (pts.length()>0 && ptsExtr.length()>0)
			{ 
				Vector3d vec = vecNormal * (vecNormal.dotProduct(pts.last() - ptsExtr.first())-dDepth);
				fp.transformBy(vec);//
				bdTool.transformBy(vec);
				for (int i=0;i<bdCaps.length();i++) 
				{ 
					bdCaps[i].transformBy(vec);
					SolidSubtract sosu(bdCaps[i], _kSubtract);
					sosu.addMeToGenBeamsIntersect(sips); 
				}//next i
				
				vec.normalize();
				//vecNormal.vis(pts.last(), 1);
			}			
		}	
	
		//bdTool.vis(6);	
//		fp.addMeToGenBeamsIntersect(sips);
		fp.addMeToGenBeams(sips);
	//End Add Tool//endregion 		

	// the symbol is made out of the freeprofile body
		PlaneProfile pp= bdTool.getSlice(pnFace);//shadowProfile(Plane(pt1, vecNormal));		
		for (int i=0;i<bdCaps.length();i++) 
			pp.unionWith(bdCaps[i].shadowProfile(pnFace));		

		pp.intersectWith(ppCommon);
 		ppFreeprofile.unionWith(pp);
 		ppOutline.unionWith(pp);
	}//next t
		
//End Loop defining tool plines//endregion 


	Point3d pt1 = ppFreeprofile.closestPointTo(pts.first());

// display
	Display dp(nc);
	dp.addViewDirection(vecZ);
	dp.addViewDirection(-vecZ);
	String sDimStyle = _DimStyles.first();
	double textHeight = dp.textHeightForStyle("O", sDimStyle);
	{ 
		String k;
		Map mapDisplay= mapSetting.getMap("Display");
		Map m = mapDisplay;
		k="Transparency";		if (m.hasInt(k))	nt = m.getInt(k);
		k="Color";				if (m.hasInt(k))	nc = m.getInt(k);
		k="ColorRef";			if (m.hasInt(k) && nSide==-1)	nc = m.getInt(k);
		k="DimStyle";			if (m.hasString(k) && _DimStyles.findNoCase(m.getString(k),-1)>-1)	sDimStyle = m.getString(k);
		k="TextHeight";			if (m.hasDouble(k))	{textHeight = m.getDouble(k);dp.textHeight(textHeight);}

		k="Contour";		
		if (nToolMode==0 && mapDisplay.hasMap(k))
		{
			m = mapDisplay.getMap(k);
			k="Transparency";		if (m.hasInt(k))	nt= m.getInt(k);
			k="Color";				if (m.hasInt(k))	nc= m.getInt(k);
			k="ColorRef";			if (m.hasInt(k) && nSide==-1)	nc = m.getInt(k);
			k="DimStyle";			if (m.hasString(k) && _DimStyles.findNoCase(m.getString(k),-1)>-1)	sDimStyle = m.getString(k);
			k="TextHeight";			if (m.hasDouble(k))	textHeight = m.getDouble(k);		
		}
		k="Extrusion";		
		if ((nToolMode==1 || nToolMode==2) && mapDisplay.hasMap(k))
		{
			m = mapDisplay.getMap(k);
			k="Transparency";		if (m.hasInt(k))	nt = m.getInt(k);
			k="Color";				if (m.hasInt(k))	nc = m.getInt(k);
			k="ColorRef";			if (m.hasInt(k) && nSide==-1)	nc = m.getInt(k);
			k="DimStyle";			if (m.hasString(k) && _DimStyles.findNoCase(m.getString(k),-1)>-1)	sDimStyle = m.getString(k);
			k="TextHeight";			if (m.hasDouble(k))	textHeight = m.getDouble(k);				
		}
		
	}
	if (nc == -2)nc = nCncMode;
	dp.color(nc);
	dp.draw(ppOutline);
	
	Display dpModel(nc);
	dpModel.dimStyle(sDimStyle);
	dpModel.textHeight(textHeight);
	dpModel.addHideDirection(vecZ);
	dpModel.addHideDirection(-vecZ);
	dpModel.draw(ppFreeprofile);
	
	if (nt > 0) 
	{
		dp.draw(ppFreeprofile, _kDrawFilled, nt);
		dpModel.draw(ppFreeprofile, _kDrawFilled, nt);
	}

// provide output data
	double dArea = plTool.area();

//region Parse text and display if founsd
//region Collect list of available object variables and append properties which are unsupported by formatObject (yet)
	String sObjectVariables[] = _ThisInst.formatObjectVariables();

//region Add custom variables for format resolving
	// adding custom variables or variables which are currently not supported by core
	String sCustomVariables[] ={ "Radius", "Diameter", "Length", "Area"};
	for (int i=0;i<sCustomVariables.length();i++)
	{ 
		String k = sCustomVariables[i];
		if (sObjectVariables.find(k) < 0)
			sObjectVariables.append(k);
	}	
	
// get translated list of variables
	String sTranslatedVariables[0];
	for (int i=0;i<sObjectVariables.length();i++) 
		sTranslatedVariables.append(T("|"+sObjectVariables[i]+"|")); 
	
// order both arrays alphabetically
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
	String sTriggerAddRemoveFormat = T("|Add/Remove Format|");
	addRecalcTrigger(_kContextRoot, sTriggerAddRemoveFormat );
	if (_bOnRecalc && (_kExecuteKey==sTriggerAddRemoveFormat || _kExecuteKey==sTriggerAddRemoveFormat))
	{
		String sPrompt;
//		if (bHasSDV && entsDefineSet.length()<1)
//			sPrompt += "\n" + T("|NOTE: During a block setup only limited properties are accesable, but you can enter \nany valid format expression or use custom catalog entries.|");
		sPrompt+="\n"+ T("|Select a property by index to add or to remove|") + T(" ,|-1 = Exit|");
		reportNotice(sPrompt);
		
		for (int s=0;s<sObjectVariables.length();s++) 
		{ 
			String key = sObjectVariables[s]; 
			String keyT = sTranslatedVariables[s];
			String sValue;
			for (int j=0;j<ents.length();j++) 
			{ 
				String _value = ents[j].formatObject("@(" + key + ")");
				if (_value.length()>0)
				{ 
					sValue = _value;
					break;
				}
			}//next j

			//String sSelection= sFormat.find(key,0, false)<0?"" : T(", |is selected|");
			String sAddRemove = sFormat.find(key,0, false)<0?"   " : "√";
			int x = s + 1;
			String sIndex = ((x<10)?"    " + x:"  " + x)+ "  "+sAddRemove+"   ";//
			
			reportNotice("\n"+sIndex+keyT + "........: "+ sValue);
			
		}//next i
		int nRetVal = getInt(sPrompt)-1;
				
	// select property	
		while (nRetVal>-1)
		{ 
			if (nRetVal>-1 && nRetVal<=sObjectVariables.length())
			{ 
				String newAttrribute = sFormat;
	
			// get variable	and append if not already in list	
				String variable ="@(" + sObjectVariables[nRetVal] + ")";
				int x = sFormat.find(variable, 0);
				if (x>-1)
				{
					int y = sFormat.find(")", x);
					String left = sFormat.left(x);
					String right= sFormat.right(sFormat.length()-y-1);
					newAttrribute = left + right;
					reportMessage("\n" + sObjectVariables[nRetVal] + " new: " + newAttrribute);				
				}
				else
				{ 
					newAttrribute+="@(" +sObjectVariables[nRetVal]+")";
								
				}
				sFormat.set(newAttrribute);
				reportMessage("\n" + sFormatName + " " + T("|set to|")+" " +sFormat);	
			}
			nRetVal = getInt(sPrompt)-1;
		}
	
		setExecutionLoops(2);
		return;
	}	
	
	
//endregion 

//region Resolve format by entity
	String text;// = "R" + dDiameter * .5;
	if (sFormat.length()>0)
	{ 
		String sLines[0];// store the resolved variables by line (if \P was found)	
		String sValues[0];	
		String sValue=  _ThisInst.formatObject(sFormat);
	
	// parse for any \P (new line)
		int left= sValue.find("\\P",0);
		while(left>-1)
		{
			sValues.append(sValue.left(left));
			sValue = sValue.right(sValue.length() - 2-left);
			left= sValue.find("\\P",0);
		}
		sValues.append(sValue);	
	
	// resolve unknown variables
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
						String sVariable = value.left(right + 1);
						
						//"Radius", "Diameter", "Length", "Area"
						String s;
						if (sVariable.find("@("+sCustomVariables[0]+")",0,false)>-1)
						{
							s.formatUnit(dDiameter*.5,_kLength);
							sTokens.append(s);
						}
						else if (sVariable.find("@("+sCustomVariables[1]+")",0,false)>-1)
						{
							s.formatUnit(dDiameter,_kLength);
							sTokens.append(s);	
						}
						else if (sVariable.find("@("+sCustomVariables[2]+")",0,false)>-1)
						{ 
							s.formatUnit(dLengthPath,_kLength);
							sTokens.append(s);
						}							
						else if (sVariable.find("@("+sCustomVariables[3]+")",0,false)>-1)
						{ 
							s.formatUnit(dArea,_kArea);
							sTokens.append(s);
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
//	
				for (int j=0;j<sTokens.length();j++) 
					value+= sTokens[j]; 
			}
//			//sAppendix += value;
			sLines.append(value);
		}	
//		
	// text out
		for (int j=0;j<sLines.length();j++) 
		{ 
			text += sLines[j];
			if (j < sLines.length() - 1)text += "\\P";		 
		}//next j
	}
//		
//End Resolve format by entity//endregion 

// find outside location and draw text
	if (text.length()>0)
	{ 
		if (_PtG.length() < 1)_PtG.append(pt1);
		String events[] ={ sWidthName, sSideName, sAlignmentName, sToolModeName};
		if (_bOnDbCreated || events.find(_kNameLastChangedProp)>-1 || bDebug)
		{ 
			double dX = dp.textLengthForStyle(text, sDimStyle, textHeight);
			double dY = dp.textHeightForStyle(text, sDimStyle, textHeight);
			PlaneProfile ppText;
			ppText.createRectangle(LineSeg(pt1-.5*(vecX*dX+vecY*dY),pt1+.5*(vecX*dX+vecY*dY)), vecX, vecY);//ppText.vis(6);
			ppFreeprofile.removeAllOpeningRings();
			ppText.intersectWith(ppFreeprofile);
			if (ppText.area()>pow(dEps,2))
			{ 
				LineSeg segs[] = ppText.splitSegments(LineSeg (ppFreeprofile.extentInDir(vecX).ptMid(),pt1), true);
				if (segs.length()>0)
				{
					//segs.first().vis(5);
					Vector3d v = Vector3d(segs.first().ptEnd() - segs.first().ptStart());
					double d = v.length() + .25 * textHeight;
					v.normalize();
					pt1 += v*d;
				}
			}
			pt1.vis(3);	
			_PtG[0] = pt1;	
		}
		dpModel.draw(text, _PtG[0], vecX, vecY, 0, 0);
		dp.draw(text, _PtG[0], vecX, vecY, 0, 0, _kDevice);
	}
	else
		_PtG.setLength(0);


			
//End Parse text and display if founsd//endregion 

//region Trigger
{
	// create TSL
	TslInst tslDialog;			Map mapTsl;
	GenBeam gbsTsl[] = { };		Entity entsTsl[] = { };			Point3d ptsTsl[] = { _Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };

	//Trigger ToolModeSettings
	if (nToolMode==4)
	{ 
		String sTriggerEditToolMode = T("|Edit Toolmode|");
		addRecalcTrigger(_kContext, sTriggerEditToolMode );
		if (_bOnRecalc && _kExecuteKey==sTriggerEditToolMode)
		{			
		// prepare dialog instance
			mapTsl.setInt("DialogMode", 3);
			tslDialog.dbCreate(scriptName() , _XW, _YW, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
			
			if (tslDialog.bIsValid())
			{
				int bOk = tslDialog.showDialog();
				
				if (bOk)
				{ 	
					dMinStraight = tslDialog.propDouble(0);
					dOverlap = tslDialog.propDouble(1);
					
					if (dMinStraight<dEps)
						reportMessage(TN("|The length of a straight segment must be > 0|"));
					else if (dOverlap>=dMinStraight)
						reportMessage(TN("|The overlapping length must be smaller the length of a straight segment|"));	
					else
					{ 
						String modeName= "Mode4";
						Map mapToolMode;
						mapToolMode.setDouble("MinLengthStraight", dMinStraight);
						mapToolMode.setDouble("Overlap", dOverlap);
						mapToolMode.setMapName(modeName);
			
					// write rules
						Map mapNewToolModes;
						for (int i=0;i<mapToolModes.length();i++) 
						{ 
							Map m = mapToolModes.getMap(i); 
							String name = m.getMapName();
							if (name == modeName || name.length()<1){ continue;}
							mapNewToolModes.appendMap("ToolMode", m);
						}//next i
						mapNewToolModes.appendMap("ToolMode", mapToolMode);
						mapToolModes = mapNewToolModes;
		
						mapSetting.setMap("ToolMode[]", mapToolModes);			
						if (mo.bIsValid())mo.setMap(mapSetting);
						else mo.dbCreate(mapSetting);					
					}	
				}
				tslDialog.dbErase();
			}
	
			setExecutionLoops(2);
			return;
		}		
	}
//region Trigger ConfigureDisplay
	String sTriggerConfigureDisplay = T("|Configure Display|");
	addRecalcTrigger(_kContext, sTriggerConfigureDisplay );
	if (_bOnRecalc && _kExecuteKey==sTriggerConfigureDisplay)
	{
		// prepare dialog instance
		mapTsl.setInt("DialogMode", 1);
	
		String k;
		Map mapDisplay= mapSetting.getMap("Display");
		Map m = mapDisplay;
	
		int n; double d; String s;
	
		// Display
		k="Color";			nProps.append(m.hasInt(k)?m.getInt(k):nc);
		k="Transparency";	nProps.append(m.hasInt(k)?m.getInt(k):nt);
		k="DimStyle";		sProps.append(m.hasString(k)?m.getString(k):sDimStyle);
		k="TextHeight";		dProps.append(m.hasDouble(k)?m.getDouble(k):textHeight);
		
		// Extrusion
		m = mapSetting.getMap("Extrusion");
		k="Color";			nProps.append(m.hasInt(k)?m.getInt(k):nc);
		k="ColorRef";		nProps.append(m.hasInt(k)?m.getInt(k):nc);
		k="Transparency";	nProps.append(m.hasInt(k)?m.getInt(k):nt);
		k="DimStyle";		sProps.append(m.hasString(k)?m.getString(k):sDimStyle);
		k="TextHeight";		dProps.append(m.hasDouble(k)?m.getDouble(k):textHeight);

		// Contour
		m = mapSetting.getMap("Contour");
		k="Color";			nProps.append(m.hasInt(k)?m.getInt(k):nc);
		k="ColorRef";		nProps.append(m.hasInt(k)?m.getInt(k):nc);
		k="Transparency";	nProps.append(m.hasInt(k)?m.getInt(k):nt);
		k="DimStyle";		sProps.append(m.hasString(k)?m.getString(k):sDimStyle);
		k="TextHeight";		dProps.append(m.hasDouble(k)?m.getDouble(k):textHeight);
	
		tslDialog.dbCreate(scriptName() , _XW, _YW, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
		
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{	
				// Display
				m = Map();
				m.setInt("Color", tslDialog.propInt(0));
				m.setInt("Transparency", tslDialog.propInt(1));
				m.setString("DimStyle", tslDialog.propString(0));
				m.setDouble("TextHeight", tslDialog.propDouble(0));
				mapSetting.setMap("Display",m);
			
				// Extrusion
				m = Map();
				m.setInt("Color", tslDialog.propInt(2));
				m.setInt("ColorRef", tslDialog.propInt(3));
				m.setInt("Transparency", tslDialog.propInt(4));
				m.setString("DimStyle", tslDialog.propString(1));
				m.setDouble("TextHeight", tslDialog.propDouble(1));
				mapSetting.setMap("Extrusion",m);


				// Contour
				m = Map();
				m.setInt("Color", tslDialog.propInt(5));
				m.setInt("ColorRef", tslDialog.propInt(6));
				m.setInt("Transparency", tslDialog.propInt(7));
				m.setString("DimStyle", tslDialog.propString(2));
				m.setDouble("TextHeight", tslDialog.propDouble(2));
				mapSetting.setMap("Contour",m);

				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);
			}
			tslDialog.dbErase();
		}
		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger ConfigureDisplay
	String sTriggerConfigureTool= T("|Configure Tool|");
	addRecalcTrigger(_kContext, sTriggerConfigureTool );
	if (_bOnRecalc && _kExecuteKey==sTriggerConfigureTool)
	{
		// prepare dialog instance
		mapTsl.setInt("DialogMode", 2);

		dProps.append(dDiameter);
		dProps.append(dLength);
		nProps.append(nCncMode);
		sProps.append(sToolName);
	
		dProps.append(dLineApproxAccuracy);
	
		tslDialog.dbCreate(scriptName() , _XW, _YW, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
		
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{	
				String name = tslDialog.propString(0);
				
				Map mapTool;
				mapTool.setDouble("Diameter", tslDialog.propDouble(0));
				mapTool.setDouble("Length", tslDialog.propDouble(1));
				mapTool.setInt("ToolIndex", tslDialog.propInt(0));
				mapTool.setString("Name",name );
				
				mapTool.setDouble("Accuracy", tslDialog.propDouble(2));
				
				Map mapTools = mapSetting.getMap("Tool[]");
				Map mapTemp;
				for (int i=0;i<mapTools.length();i++) 
				{ 
					Map m = mapTools.getMap(i);
					if (m.getString("Name")!=name)
						mapTemp.appendMap("Tool",m); 	 
				}//next i
				mapTemp.appendMap("Tool",mapTool); 

				mapSetting.setMap("Tool[]",mapTemp);
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);
			}
			tslDialog.dbErase();
		}
		setExecutionLoops(2);
		return;
	}//endregion

//region Trigger ImportSettings
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
			else
				bWrite = true;
				
			if (bWrite && mapSetting.length() > 0)
			{ 
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);
				
			// make sure the path exists	//HSB-10750
				int bPathFound= sFolders.find(sFolder)>-1?true:makeFolder(sPath+"\\"+sFolder);	
				
			// write file	
				mapSetting.writeToXmlFile(sFullPath);
				
			// report rsult of writing	
				if (findFile(sFullPath).length()>0)
					reportMessage(TN("|Settings successfully exported to| ") + sFullPath);
				else
					reportMessage(TN("|Failed to write to| ") + sFullPath);
				
			}
			
			setExecutionLoops(2);
			return;
		}
	}



}


#End
#BeginThumbnail
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
I#59T-PRC;3!A&8;1-IBP#,-H&_Y_BZ[!N3\W8WD`````245.1*Y"8((`














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
        <int nm="BreakPoint" vl="1031" />
        <int nm="BreakPoint" vl="1460" />
        <int nm="BreakPoint" vl="401" />
        <int nm="BreakPoint" vl="784" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16803 invalid extrusion definitions will convert to path" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="2/27/2023 4:43:23 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13565 new custom commands to maintain additional properties, new setting property to set arc approximation (default = 0.1mm) , Author Thorsten Huck" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="10/20/2021 6:46:01 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12442 alignment fixed if width &gt; tool diameter" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="6/30/2021 8:39:14 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12409: do the tooling to get the cuttingBody in case it fails" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="6/25/2021 11:02:21 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12246 new tool mode 'Polyline Path Tool Combination' added (mode 4), new custom commands to store settings" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="6/16/2021 4:53:07 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12143 new tool mode 'Polyline Extrusion Body' added. The specified contour will not be manipulated and it i sthe designers responsibilty to choose the correct matching milling head" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="6/7/2021 4:45:32 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End