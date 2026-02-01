#Version 8
#BeginDescription
This Tsl tool creates and adds multi element data to the drawing. 
The selected elements will be passed to the multi element composer.
The composer is started by this tool automatically. 
After creating the multi elements, this tool will update the existing multi elements shown in the drawing. 
If no multi elements exist, use the tool to show a preview of the multi element or the tool that creates them.

1.7 22.02.2022 HSB-14360 Add option to handle updates and refresh multiwall Author: Nils Gregor


1.8 04/11/2022 Add option to not recalc existing multi-element tsls Author: Robert Pol
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 8
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2008 by
*  hsbSOFT IRELAND
*
*  The program may be used and/or copied only with the written
*  permission from hsbSOFT, or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*
* REVISION HISTORY
* -------------------------
*
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 22.08.2012
* version 1.0: First version
*
* date: 14.11.2012
* version 1.2: Add the option to choose group and also now it's independant from the version of hsb that it's running on
*
* date: 15.09.2016
* version 1.04: Also trigger hsb_DrawMultiElement for recalc.
*
* date: 13.12.2021 
* version 1.6 HSB-13941 Provide default export group. Author: Nils Gregor
*
*/

	Unit (1, "mm");
	
	String arGroups[] = ModelMap().exporterGroups();
	String allMWExports[0];
	String sDefaultGroup = T("|Default export group|");

//Add all exporter groups containing the hsbMultiwallExporter
	String sMWGroupPath = _kPathHsbInstall + "\\Export\\Interfaces\\hsbMultiwallExporter.dll";
	String sMWGroupFile = "hsbSoft.Cad.IO.CreateDefaultMWGroup";
	{ 
		Map mapIn;
		Map mapOut = callDotNetFunction2(sMWGroupPath, sMWGroupFile, "GetGroupsWithHsbMultiwallExporter", mapIn);
		
		if(mapOut.getInt("Error"))
		{
			reportWarning(TN("|The hsbMultiwallComposer license is missing.|") + TN("|Tool will be deleted.|"));
			eraseInstance();
			return;
		}
		
		for (int i=0; i<arGroups.length(); i++)
		{
			String sGroupTokens[] = arGroups[i].tokenize("_");
			for(int j=0; j < sGroupTokens.length(); j++)
			{
				if (sGroupTokens[j].makeUpper()=="MW")
				{
					allMWExports.append(arGroups[i]);
					break;
				}			
			}
		}
		
		if(mapOut.hasMap("MapWithGroupNames"))
		{
			Map mapGroups = mapOut.getMap("MapWithGroupNames");
			for(int i=0; i < mapGroups.length(); i++)
			{
				String sGroupName = mapGroups.getString(i);
				if(allMWExports.find(sGroupName,-1) < 0)
					allMWExports.append(sGroupName);
			}
			
			// If the exporter groups don´t contain the default group, Add default text to create it.
			if(allMWExports.find("hsb_MW_Export_Group_for_Multiwalls", -1) < 0)
			{
				allMWExports.append(sDefaultGroup);
			}
		}
	}

	if (allMWExports.length()==0)
	{
		allMWExports=arGroups;
	}
	
	
	PropString sMWExport(0, allMWExports, T("|Export Group|"), 0);
	sMWExport.setDescription(T("|Select an export group. Only groups containing \"MW\" and separated by \"_\"  or groups that contain the  \"Multiwall Export Starter\" export are shown.|") 
							+T(" |If \"Default export group\" is selected, a new group called \"hsb_MW_Export_Group_for_Multiwalls\" is created.|"));
	
	PropString nameFormat(1, "@(Code)_@(SW)", T("|Name Format|"));
	nameFormat.setDescription(T("|The name format for naming the multi elements|.") + "@(Code)_@(SW)" + T(" |will be used when left blank|.") + TN("|Other example for a name format is|: MW_@(Seq)"));
	
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	PropString sUpDateExisting(2, sNoYes, T("|Update existing multi elements|"), 1);
	sUpDateExisting.setDescription(T("|Defines if existing multi elements are updated and loose all changes.|"));
	
	String sClearMetaDataName=T("|Clear multi element meta data|");	
	PropString sClearMetaData(3, sNoYes, sClearMetaDataName);	
	sClearMetaData.setDescription(T("|Deletes all existing multi elements and clears the data.|"));

	PropString sRecalcExistingTsls(4, sNoYes, T("|Recalc existing multi element tsls|"), 1);
	sRecalcExistingTsls.setDescription(T("|Defines if existing multi element tsls recalculated|"));
	
	
	if( _bOnInsert )
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		
		if (_kExecuteKey=="")
			showDialogOnce();
		
		
		PrEntity ssE(T("Select one or More Elements"), Element());
		if( ssE.go() ){
			_Element.append(ssE.elementSet());
		}
	
		return;
	}

	//Delete existing multi element data.
	if(sNoYes.find(sClearMetaData))
	{
		Entity allElements[]=Group().collectEntities(true, Element(), _kModel);
		for (int e=0; e<allElements.length(); e++)
		{
			Element el=(Element) allElements[e];
			
			if (el.bIsValid())
			{
				Map mp=el.subMapX("hsb_Multiwall");
				if (mp.length()>0)
				{
					el.removeSubMapX("hsb_Multiwall");
				}
			}
		}
	}

//Create the default group
	if(sMWExport == sDefaultGroup)
	{
		Map mapIn;
		Map mapOut = callDotNetFunction2(sMWGroupPath, sMWGroupFile, "CreateDefaultGroup", mapIn);
		
		if(mapOut.getInt("Error"))
		{
			reportWarning(TN("|The export could not be created.|") + TN("|Tool will be deleted.|"));
			eraseInstance();
			return;
		}
		
		if(mapOut.hasString("ExportGroupName"))
			sMWExport.set(mapOut.getString("ExportGroupName"));
	}
	
	String sversion=hsbOEVersion();
	
	Group gp;
	//Entity allElements[]=gp.collectEntities(true, Element(), _kModel);
	
	String strAssemblyPath = _kPathHsbInstall+"\\NetAC\\MultiElementTools.dll";
	//String strAssemblyPath = _kPathHsbInstall+"\\NetAC\\MultiwallTools.dll";
	String sFind=findFile(strAssemblyPath);
	Map mapIn;
	
	Entity ents[0];
	
	String sNumber[0];

//Collect all the entities that need to be send to the ModelMap
	for(int i=0; i<_Element.length(); i++)//
	{
		Element el=(Element) _Element[i];
		if (!el.bIsValid()) continue;
		
		String nThisNumber=el.number();
		
		if (sNumber.find(nThisNumber, -1) ==-1)
		{
			ents.append(el);
			
			Group gpThisEl = el.elementGroup();
			Entity entThisEl[] = gpThisEl.collectEntities(true, Entity(), _kModel);
			ents.append(entThisEl);
		}
	}

// set some export flags
	ModelMapComposeSettings mmOutFlags;
	mmOutFlags.addSolidInfo(TRUE); // default FALSE
	mmOutFlags.addAnalysedToolInfo(TRUE); // default FALSE
	mmOutFlags.addElemToolInfo(TRUE); // default FALSE
	mmOutFlags.addConstructionToolInfo(TRUE); // default FALSE
	mmOutFlags.addHardwareInfo(TRUE); // default FALSE
	mmOutFlags.addRoofplanesAboveWallsAndRoofSectionsForRoofs(TRUE); // default FALSE
	mmOutFlags.addCollectionDefinitions(TRUE); // default FALSE
	
	ModelMap mmOut;
	mmOut.setEntities(ents);
	mmOut.dbComposeMap(mmOutFlags);
	
	mapIn.appendMap("Model", mmOut.map());
	mapIn.setString("ExportGroup", sMWExport);
	mapIn.setInt("RemoveExistingMWMetadata", false); 			// MultiElementTools defaults this to true.
	mapIn.setInt("RenameMW", false); 							// MultiElementTools defaults this to true.
	
	String mwNameFormat = nameFormat;
	if (mwNameFormat == "") mwNameFormat = "@(Code)_@(SW)";
	mapIn.setString("MWNameFormat", mwNameFormat); 		// MultiElementTools defaults this to @(Code)_@(SW).
	mapIn.setInt("Debug", 1);	
	
	mapIn.writeToDxxFile("C:\\Temp\\MultiwallOutup.dxx");


	Map mapOut;
	
	if (sFind!="")
	{
		//String strAssemblyPath = _kPathHsbInstall + "\\Content\\UK\\TSL\\DLLs\\MaterialTable\\hsbMaterialTable.dll";
		String strType = "hsbSoft.Cad.Model.TslMultiElementTools";
		String strFunction = "ComposeMultiwallsToMetadata";
		
		mapOut = callDotNetFunction2(strAssemblyPath, strType, strFunction, mapIn);
		
		mapOut .writeToDxxFile("C:\\Temp\\MultiwallBackFromDll.dxx");
	}


	int a=mapOut.length();
	
	if ( a<=0 ) //!mapOut.hasString("Result") ||
	{
		reportNotice("No Valid dll or path not found");
	}
	
	int bVersionIs18 = FALSE;
	String sTest=hsbOEVersion();
	if (hsbOEVersion().find("hsbCAD18", -1) == 0)
	{
		bVersionIs18 = TRUE;
	}
	
	Map mpModel=mapOut.getMap("Model\\Model");
	
	Map mpNewElement[0];
	String sNewElementNumber[0];

	if (bVersionIs18)
	{
		for (int m=0; m<mpModel.length(); m++)
		{
			Map mpElement=mpModel.getMap(m);
			
			if (mpElement.hasString("ElementWall\\Element\\Wall\\Entity\\ElementNumber"))
			{
				String sElementNumber=mpElement.getString("ElementWall\\Element\\Wall\\Entity\\ElementNumber");
		
				Map mpX=mpElement.getMap("ElementWall\\Element\\Wall\\Entity\\MAPX[]");
			
				for (int i=0; i<mpX.length(); i++)
				{
					Map mp=mpX.getMap(i);
					String sKey=mp.getMapName();
					sKey.makeUpper();
					if (sKey=="HSB_MULTIWALL")
					{
						mpNewElement.append(mp);
						sNewElementNumber.append(sElementNumber);
						break;
					}
				}
			}
		}
		
		for (int i=0; i<_Element.length(); i++)
		{
			Element el=_Element[i];
			String sNumber=el.number();
			
			int nLoc=sNewElementNumber.find(sNumber, -1);
			
			if (nLoc!=-1)
			{
				el.setSubMapX("Hsb_Multiwall", mpNewElement[nLoc]);
			}
		}
	}


	Map mpTemp=mapOut.getMap("Model");
	
	ModelMap mm;
	mm.setMap(mpTemp);	

// set some import flags
	ModelMapInterpretSettings mmFlags;
	mmFlags.resolveEntitiesByHandle(FALSE); // default FALSE
	mmFlags.resolveElementsByNumber(TRUE); // default FALSE
	mmFlags.setBeamTypeNameAndColorFromHsbId(FALSE); // default FALSE

// interpret ModelMap
	if (!bVersionIs18)
	{
		mm.dbInterpretMap(mmFlags);
	}


	Group gr; // default constructor, or empty groupname means complete drawing 
	int bAlsoInSubGroups = TRUE;
	Entity arEnt[] = gr.collectEntities( bAlsoInSubGroups, TslInst(), _kModelSpace);
	
	String drawMultiElementTsls[] = {
		"HSB_MULTIWALLDRAW",
		"HSB_DRAWMULTIELEMENT",
		"HSB_CREATEMULTIELEMENTS"
	};
	
	if (sNoYes.find(sRecalcExistingTsls))
	{
		
		
		for (int i = 0; i < arEnt.length(); i++) {
			TslInst tsl = (TslInst) arEnt[i];
			
			if ( ! tsl.bIsValid())
				continue;
			
			if (drawMultiElementTsls.find(tsl.scriptName().makeUpper()) != -1 )
			{
				if (sNoYes.find(sUpDateExisting))
					tsl.recalcNow(T("../|Refresh all Multielements|"));
				else
					tsl.recalcNow("update Multielements");
			}
		}
	}

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
      <str nm="Comment" vl="Add option to not recalc existing multi-element tsls" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="11/4/2022 2:47:49 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14360 Add option to handle updates and refresh multiwall" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="2/22/2022 10:55:19 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13941 Provide default export group." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="12/13/2021 3:15:55 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Name Formation option added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="5/28/2021 12:23:30 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End