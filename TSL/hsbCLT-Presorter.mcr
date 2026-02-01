#Version 8
#BeginDescription
#Versions
Version 2.0 01.10.2024 HSB-22741 supports painter rules of corresponding folder, appends inverse erection sequence if specified

Version 1.28 15.11.2021 HSB-13027 sequence numbers left padded to support sorting, dispay bugfix



/// Setup: 
/// - export settings of any instance of 'hsbCLT-MasterPanelManager'
/// - modify and/or copy the section Sorting
/// - supported key words are SubLabel2, Style, Thickness, Package, Quality, Length, Width, Label, Sublabel, Information, Name, Element
/// - key words can be entered in english as translatable string, i.e. |Name| or as string of your localisation, i.e. Name
/// - import modified settings via 'hsbCLT-MasterPanelManager'
/// This tsl creates and sorts child panels
/// It requieres 'hsbCLT-MasterPanelManager' in one of the search paths and uses the external settings of 'hsbCLT-MasterPanelManager'


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 0
#KeyWords XRef;Nesting;CLT, presorter, sorter; format; formatObject
#BeginContents
//region History
/// <summary Lang=en>
/// This tsl creates and sorts child panels
/// It requieres 'hsbCLT-MasterPanelManager' in one of the search paths and uses the external settings of 'hsbCLT-MasterPanelManager'
/// </summary>

/// <remark Lang=en>
/// Setup: 
/// - export settings of any instance of 'hsbCLT-MasterPanelManager'
/// - modify and/or copy the section Sorting
/// - supported key words are SubLabel2, Style, Thickness, Package, SurfaceQuality, Length, Width, Label, Sublabel, Information, Name, Element
/// - import modified settings via 'hsbCLT-MasterPanelManager'
/// - Ranges are added to settings. Width range groups can be created. The biggest width in the group can be taken to set the masterpanel width.
/// - A map called "Range[]" has be be created, containing the range name, min/ max width and an int to specify if the group is used called "SetMPWidth".
/// - For sorting a mapCriteria is used. The "Property" value has to be "Ranges", and it has to contain a map called "Range[]" including all range names to sort for
///
/// - Extended properties are set as format, but can have a Prefix for display in the group text specification ("Holzart @(hsbCAD Panel.Holzart))
/// - The Prefix Holzart is used as displayed text, the format @(hsbCAD Panel.Holzart) to get the value.
/// </remark >
// #Versions
// 2.0 01.10.2024 HSB-22741 supports painter rules of corresponding folder, appends inverse erection sequence if specified , Author Thorsten Huck
// 1.28 15.11.2021 HSB-13027 sequence numbers left padded to support sorting, dispay bugfix , Author Thorsten Huck
///<version value="1.27" date="08dec2020" author="thorsten.huck@hsbcad.com"> HSB-9504 childpanels not aligned with world X-Axis will be rotated </version>
///<version value="1.26" date="20oct2020" author="thorsten.huck@hsbcad.com"> HSB-9338 internal naming bugfix </version>
///<version value="1.25" date=06jul2020" author="thorsten.huck@hsbcad.com"> HSB-8217 bugfix prefix on unknown variables </version>
///<version value="1.24" date="22may2020" author="nils.gregor@hsbcad.com"> HSB-7719 Add surface quality to sorting criterias </version>
///<version value="1.23" date="02apr2020" author="nils.gregor@hsbcad.com"> HSB-7187 Applied the missing functionality of merging and HSB-6882 Bugfix on grain direction</version>
///<version value="1.22" date="02apr2020" author="thorsten.huck@hsbcad.com"> HSB-7187 resolving version conflict introduced between 1.2 by NG and 1.20 and 1.21 by TH: HSB-6882 Add Graindirection as automatic sorting criteria, corrected Child and Header positions  </version>
///<version value="1.21" date=31mar2020" author="thorsten.huck@hsbcad.com"> HSB-7143 bugfix GIT merge </version>
///<version value="1.20" date="24mar2020" author="thorsten.huck@hsbcad.com"> HSB-7018 bugfix exposing range width to hsbCLT-MasterPanelManager  </version>
///<version value="1.19" date="18mar2020" author="nils.gregor@hsbcad.com"> HSB-6882 Changed selection for width used as range criteria </version>
///<version value="1.18" date="12mar2020" author="thorsten.huck@hsbcad.com"> HSB-6882 show dependencies enhanced (individual selection supported) </version>
///<version value="1.17" date="10mar2020" author="nils.gregor@hsbcad.com"> HSB-6882 Use only valid criteria </version>
///<version value="1.16" date="05mar2020" author="thorsten.huck@hsbcad.com"> HSB-6882 settings syntax adjusted, new context commands </version>
///<version value="1.15" date="24feb2020" author="thorsten.huck@hsbcad.com"> HSB-5645 dependency added to mapObject to update all instances on settings change, Sorting definition may specify display color, Header display supports descriptions and format variables, Out of range group added if width eranges are in use, surfaceQuality, surfaceQualityBottom and surfaceQualityTop added as supported properties</version>
///<version value="1.14" date="20feb20" author="nils.gregor@hsbcad.com"> HSB-5646: Other sorting criteria is respected. Prefix to display can be used  </version>
///<version value="1.13" date="05feb20" author="marsel.nakuci@hsbcad.com"> HSB-5646: fix position of tsl instance + write in mapX of the tsl the maxWidth </version>
///<version value="1.12" date="05feb20" author="marsel.nakuci@hsbcad.com"> HSB-5646: create separate TSL instance for each grouping </version>
///<version value="1.11" date="30jan2020" author="marsel.nakuci@hsbcad.com"> HSB-5646: write at mapx the max width found from all the panels of the group </version>
///<version value="1.10" date="07jan2020" author="marsel.nakuci@hsbcad.com"> HSB-5646, HSB-5645: show width range only once </version>
///<version value="1.9" date="13dez2019" author="marsel.nakuci@hsbcad.com"> HSB-5646: support in xml the format @(variable name) </version>
///<version value="1.8" date="13dez2019" author="marsel.nakuci@hsbcad.com"> HSB-5646: get properties from formatObjectVariables </version>
///<version value="1.7" date="09.12.2019" author="marsel.nakuci@hsbcad.com"> HSB-5819: in sChildProperties type the requested properties to be displayed </version>
///<version value="1.6" date="09.12.2019" author="marsel.nakuci@hsbcad.com"> HSB-5645: neglect ranges that are not declared within Range[], use sRangeValid </version>
///<version value="1.5" date="09.12.2019" author="marsel.nakuci@hsbcad.com"> HSB-5645: group panels in a range width </version>
///<version value="1.4" date="23sep2019" author="nils.gregor@hsbcad.com"> HSB-5635 presorting by length and width enhanced </version>
///<version value="1.2" date="06aug2019" author="thorsten.huck@hsbcad.com"> MPN-1, MPN-2, MPN-3 first draft of multi project nesting </version>
///<version value="1.2" date="20Sep17" author="thorsten.huck@hsbcad.com"> displays offset shadow if sublabel2 contains routing definition in the format <Route;Offset> </version>
///<version value="1.1" date="05aug16" author="thorsten.huck@hsbcad.com"> supports also property 'material' </version>
///<version value="1.0" date="27july16" author="thorsten.huck@hsbcad.com"> initial </version>		
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

	String sDialogLibrary = _kPathHsbInstall + "\\Utilities\\DialogService\\TslUtilities.dll";
	String sClass = "TslUtilities.TslDialogService";	
	String listSelectorMethod = "SelectFromList";
	String optionsMethod = "SelectOption";
	String simpleTextMethod = "GetText";
	String askYesNoMethod = "AskYesNo";
	String showNoticeMethod = "ShowNotice";
	String showMultilineNotice = "ShowMultilineNotice";

//region Color and view	
	int bIsDark;{int n = getBackgroundTrueColor();bIsDark = ((rgbR(n) + rgbB(n) + rgbG(n)) / 3 < 127);}
	int grey = bIsDark?rgb(199,200,202):rgb(99,100,102);
	int white = bIsDark?rgb(255,255,255):rgb(0,0,0);	
	
	int lightblue = rgb(204,204,255);
	int blue = rgb(69,84,185);	
	int darkblue = rgb(26,50,137);	
	int yellow = rgb(241,235,31);
	int darkyellow = rgb(254, 204, 102);
	int orange = rgb(242,103,34);
	int red = rgb(205,32,39);
	int purple = rgb(147,39,143);
	int petrol = rgb(16,86,137);
	int green = rgb(19,155,72);	

	Vector3d vecXView = getViewDirection(0);
	Vector3d vecYView = getViewDirection(1);
	Vector3d vecZView = getViewDirection(2);
	double dViewHeight = getViewHeight();	
//endregion 	

// categories
	String sCategoryAlignment = T("|Alignment|");
	String sCategoryCatalogs = T("|Catalog Entries|");	
	String sCategoryDisplay = T("|Display|");	
	String sCategoryChild = T("|Childpanel|");	
	String sCategorySorting = T("|Sorting|");	
	
	String kSequenceChild = "HSB_SequenceChild";
	String kPhase = "BuildingPhase";
	String kSequence = "SequenceNumber";
	String kInvSequence = "InverseSequenceNumber";	
//end Constants//endregion

//region Functions


//region Function SetInvertedErectionSequence
	// assigings the inverted value of the erection sequence
	void SetInvertedErectionSequence(Entity ents[])
{

	
	// get existing phases and its max value
		String phases[0];
		for (int i=0;i<ents.length();i++) 
		{ 
			if (ents[i].subMapXKeys().findNoCase(kSequenceChild,-1)<0)
			{ 
				continue;
			}
			
			Map m= ents[i].subMapX(kSequenceChild); 
			String phase = m.getString(kPhase);
			int n = phases.findNoCase(phase ,- 1);
			if (n<0)
				phases.append(phase);
			
		}//next i
		
	// loop each phase and assign the inverted value per phase
		for (int p=0;p<phases.length();p++) 
		{ 
			String thisPhase= phases[p]; 
			Entity entsPhase[0];
			int nSequences[0];
			for (int i=ents.length()-1; i>=0 ; i--) 
			{ 
				Map m= ents[i].subMapX(kSequenceChild); 
				String phase = m.getString(kPhase);
				int sequence = m.getInt(kSequence);
				if (thisPhase==phase)
				{
					entsPhase.append(ents[i]);
					nSequences.append(sequence);
				}
			}//next i

		// order by sequence
			for (int i=0;i<entsPhase.length();i++) 
				for (int j=0;j<entsPhase.length()-1;j++) 
					if (nSequences[j]>nSequences[j+1])
					{
						entsPhase.swap(j, j + 1);
						nSequences.swap(j, j + 1);						
					}
			
		// assign inverted subsequence
			int inv=1;
			for (int i=entsPhase.length()-1; i>=0 ; i--) 
			{ 
				Map m= entsPhase[i].subMapX(kSequenceChild);
				m.setInt(kInvSequence, inv);
				entsPhase[i].setSubMapX(kSequenceChild, m);
				inv++;				
			}//next i

		}//next j

		return;
	}//endregion


	
//endregion 

//region Painter
	String sPainters[0],sAllPainters[] = PainterDefinition().getAllEntryNames().sorted();
	String sPainterCollection = "TSL\\hsbCLT-Presorter\\";

	for (int i=0;i<sAllPainters.length();i++) 
	{ 
		String sPainter = sAllPainters[i];
		PainterDefinition pd(sPainter);
		if (!pd.bIsValid() || pd.format().find("@(",0, false)<0)
			continue;
	
		if (sPainter.find(sPainterCollection,0,false)==0)
		{
			String s = sPainter;
			s = s.right(s.length() - sPainterCollection.length());
			if (sPainters.findNoCase(s,-1)<0)
				sPainters.append(s);
		}		 
	}//next i
	
//AutoCreate Certain definitions
	String tOrderStyleSequenceSet = T("|byStyle and Sequence|");
	if (_bOnInsert || bDebug || _bOnRecalc)
	{
		
		if (sPainters.findNoCase(tOrderStyleSequenceSet,-1)<0)
		{ 
			String name = tOrderStyleSequenceSet;
			String painter = sPainterCollection + name;
			PainterDefinition pd(painter);	
			if (!pd.bIsValid())
			{ 
				pd.dbCreate();
				if (pd.bIsValid())
				{ 
					pd.setType("Panel");
					pd.setFilter("");
					pd.setFormat("@(Style:PL8;0)_@(Hsb_SequenceChild."+kInvSequence+":PL4;0:D;\"0000\")?@(Style:PL8;0)_@(IsPerpendicularToWorldZ)");
				}
			}	
				
			if (pd.bIsValid() && sPainters.findNoCase(name,-1)<0)
				sPainters.append(name);		
		}			
	}
//endregion 

//region Settings
// settings PART 1/2
// settings are stored in external files but they are only updated upon request or if no settings are found in the dictionary of the dwg
	String sDictEntries[] = {"MasterPanelManagerSettings", "Freight-PackageSettings"};
	Map mapSettings;
	Map mapDefaults,mapDefault; // add optional submaps named as the dict entry

//presorting, default map in case no xml or no map object found
	Map mapSortings;
	{
		Map mapCriteria, mapCriterias,mapSorting;
		mapCriteria.setString("Property", "Sublabel2");	
		mapCriteria.setString("Filter", "!=HU");	
		mapCriteria.setInt("Order",1);
		mapCriteria.setInt("Group",1);	
		mapCriterias.appendMap("Criteria", mapCriteria);

		mapCriteria.setString("Property", "Style");	
		mapCriteria.setString("Filter", "");	
		mapCriteria.setInt("Order",1);
		mapCriteria.setInt("Group",1);	
		mapCriterias.appendMap("Criteria", mapCriteria);		
		
		mapSorting.setString("Name", "Standard");
		mapSorting.setMap("Criteria[]", mapCriterias);
		
		mapSortings.appendMap("Sorting", mapSorting);
		mapDefault.appendMap("Sorting[]", mapSortings);
	}	
// ranges map for the criteria Width
	Map mapRanges;		

// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sFileName ="MasterPanelManagerSettings";
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
	
// read settings
	double dRowOffset = U(500);
	double dMaxWidthMaster = U(3500);
	
	double dRowLength;
	int bAlignRight, dLinetypeScale=1, nColorShadow;
	String sLineType= "Continuous";
	if (mapSetting.length()>0)
	{
		String k;
		k = "Sorting[]";
		mapSortings = mapSetting.getMap(k);
		if (mapSortings.length()<1 && sPainters.length()<1)	
		{
			mapSortings= mapDefault.getMap(k);
		}
		
	// maps of all ranges
		mapRanges = mapSetting.getMap("Range[]");
		String sKey;	
		k = "RowOffset";			if (mapSetting.hasDouble(k))	dRowOffset = mapSetting.getDouble(k);
		k = "Length";				if (mapSetting.hasDouble(k))	dRowLength = mapSetting.getDouble(k);
		k = "LineTypeScaleFactor"; 	if (mapSetting.hasDouble(k))	dLinetypeScale = mapSetting.getDouble(k);

	// int	
		k = "AlignRight";			if (mapSetting.hasInt(k))		bAlignRight = mapSetting.getInt(k);
		k = "Color";				if (mapSetting.hasInt(k))		nColorShadow = mapSetting.getInt(k);
		k = "LineType";				if (mapSetting.hasString(k))	sLineType = mapSetting.getString(k);
		
		k = "Width";		if (mapSetting.hasDouble(k))	dMaxWidthMaster = mapSetting.getDouble(k);
	}

// collect rules from settings
	String sRules[0];	
	for(int i=0;i<mapSortings.length();i++)
		if (mapSortings.hasMap(i))
			sRules.append(mapSortings.getMap(i).getString("Name"));	
			
	// remove painter rules which conflict with xml rule names		
	for (int i=sPainters.length()-1; i>=0 ; i--) 
		if (sRules.findNoCase(sPainters[i],-1)>-1)
			sPainters.removeAt(i); 
	
	sRules.append(sPainters);	
	
	

	
	
//End Settings//endregion

//region Properties

	String sRuleName =T("|Rule|");
	PropString sRule(0,sRules.sorted(),sRuleName,0);
	sRule.setDescription(T("|Defines the rules to be displayed.|") );
	sRule.setCategory(sCategorySorting );
	sRule.setControlsOtherProperties(true);

	String tAscending=T("|Ascending|"), tDescending= T("|Descending|"),sSortingDirs[] = { tAscending, tDescending};
	String sSortingDirName=T("|Sorting Direction|");	
	PropString sSortingDir(3, sSortingDirs, sSortingDirName);	
	sSortingDir.setDescription(T("|Defines the sorting direction, only applicable for painter based rules|"));
	sSortingDir.setCategory(sCategorySorting);

// child panel
	String sFaceAlignmentName=T("|Top Face Alignment|");	
	String sFaceAlignments[] = {T("|Unchanged|"), T("|Higher Quality|"), T("|Lower Quality|")};
	PropString sFaceAlignment(1, sFaceAlignments, sFaceAlignmentName,1);						// 6
	sFaceAlignment.setDescription(T("|Defines the alignment of the child panel|"));
	sFaceAlignment.setCategory(sCategoryChild);

	String sChildPropertiesName =T("|Description Properties|");
	PropString sChildProperties(2,"@(" + T("|" + "Width" + "|") + ")",sChildPropertiesName );
	sChildProperties.setDescription(T("|Defines the properties to be displayed.|") + " " + T("|Separate multiple entries with a semicolon.|"));
	sChildProperties.setCategory(sCategoryChild );
	
//endregion 
	
//region OnInsert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }	

		sChildProperties.setDefinesFormatting("Sip");

	// silent/dialog
		if (_kExecuteKey.length()>0)
			setPropValuesFromCatalog(_kExecuteKey);	
		else
			showDialog();		

		PainterDefinition pd(sRule);
		int bIsPainterRule = sPainters.findNoCase(sRule) >- 1 && pd.bIsValid();
	

	// prompt for masterpanels
		PrEntity ssE(T("|Select panels(s) or any referenced entity (child or master panels, freight item(s), packages or trucks)|") , MasterPanel());
		ssE.addAllowedClass(TslInst());
		ssE.addAllowedClass(Sip());
		ssE.addAllowedClass(ChildPanel());
		
		ssE.allowNested(true);
		
		Entity entsSet[0];
		if (ssE.go())
			entsSet= ssE.set();	
		

	// declare the tsl props
		TslInst tslNew;
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		GenBeam gbs[0];
		Entity ents[0];
		Point3d pts[0];
		int nProps[] = {};
		double dProps[] = {};
		String sProps[] = {sRule, sFaceAlignment, sChildProperties,sSortingDir};
		Map mapTsl;

	// collect what we have got from the selection set
		ChildPanel childs[0];
		Sip sips[0];
		TslInst tslPackages[0], tslTrucks[0], tslItems[0];
		MasterPanel masters[0];	 
		if(bDebug)reportMessage("\n"+ scriptName() + " " + entsSet.length() + " entities selected...");
		for (int i=0;i <entsSet.length();i++)
		{
			Entity ent = entsSet[i];
			if (ent.bIsKindOf(Sip ()))
				sips.append((Sip)ent);
			else if (ent.bIsKindOf(ChildPanel()))
				childs.append((ChildPanel)ent);
			else if (ent.bIsKindOf(TslInst ()))
			{
				TslInst tsl = (TslInst)entsSet[i];
				if (!tsl.bIsValid())continue;
				Map map = tsl.map();
				if(map.getInt("isTruckContainer"))
					tslTrucks.append(tsl);
				else if(map.getInt("isPackageContainer"))
					tslPackages.append(tsl);
				else if(map.getInt("isFreightItem"))
					tslItems.append(tsl);						
			}
			else if (ent.bIsKindOf(MasterPanel()))
				masters.append((MasterPanel)ent);								
		}
	
	// collect packages from trucks
		for (int i=0;i <tslTrucks.length();i++)
		{
			Entity ents[] = tslTrucks[i].entity();
			for (int e=0;e<ents.length();e++)
			{
				TslInst tsl = (TslInst)ents[e];
				if (!tsl.bIsValid())continue;
				Map map = tsl.map();
				if(map.getInt("isPackageContainer") && tslPackages.find(tsl)<0)
				{
					tslPackages.append(tsl);
					if (bDebug)reportMessage("\n	Package " + tsl.color() + " of truck " + i + " added.");	
				}	
			}	
		}	
		if(bDebug)reportMessage("\n	"+ tslPackages.length() + " packages");
				
	// collect items from packages
		for (int i=0;i <tslPackages.length();i++)
		{
			Entity ents[] = tslPackages[i].entity();
			for (int e=0;e<ents.length();e++)
			{
				TslInst tsl = (TslInst)ents[e];
				if (!tsl.bIsValid())continue;
				Map map = tsl.map();
				if(map.getInt("isFreightItem") && tslItems.find(tsl)<0)
				{
					tslItems.append(tsl);	
					//if (bDebug)reportMessage("\n		Item " + tsl.handle() + " of package " + i + " added.");	
				}						
			}	
		}
		if(bDebug)reportMessage("\n	"+ tslItems.length() + " items");					

	// collect panels from freight items
		for (int i=0;i<tslItems.length();i++)
		{
			TslInst tsl =tslItems[i];
			if (!tsl.bIsValid())continue;
			GenBeam gbs[] = tsl.genBeam();
			if (gbs.length()==1 && gbs[0].bIsKindOf(Sip()))
			{
				Sip sip = (Sip)gbs[0];
				if (sips.find(sip)<0)
					sips.append(sip);
			}		
		}
		if(bDebug)reportMessage("\n	"+ sips.length() + " panels by items");	
	
	// filter by painter
		if (bIsPainterRule)
		{ 
			sips = pd.filterAcceptedEntities(sips);
		}

	// Vectors
		Vector3d vecX =_XW;
		Vector3d vecY =_YW;
		Vector3d vecZ =_ZW;

	// create childs
		_Pt0 = getPoint(TN("|Pick insertion point|"));
		if (sips.length()>0)
		{
			double dYOffset = U(300);
			
		
			Point3d ptInsert = _Pt0;
			
			for(int i=0;i<sips.length();i++)
			{
				Sip sip= sips[i];

				Map mapMaster = sip.subMapX("Masterpanel");
				if (mapMaster.length()>0)
				{ 
					reportMessage("\n" + T("|Panel|") + (sip.posnum()>-1?sip.posnum()+" ":"") + sip.name() + T(" |already nested in| ") + mapMaster.getString("FileName") + T(", |Masterpanel| ") + mapMaster.getInt("Number"));
					continue;
				}

				PLine plEnvelope = sip.plEnvelope();
				ChildPanel child;
				child.dbCreate(sips[i], ptInsert, vecY);
	
				CoordSys cs2Me = child.sipToMeTransformation();
				plEnvelope.transformBy(cs2Me);
				plEnvelope.vis(i);
				
				PlaneProfile pp(plEnvelope);
				LineSeg seg = pp.extentInDir(vecX);seg.vis(i);
				double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
				double dY = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));				

				Vector3d vecXGrain = sip.woodGrainDirection();
				vecXGrain.transformBy(cs2Me);
				double dRotation = vecXGrain.angleTo(_XW);

			// rotate if crosswise
				if (dY>dX && dX<=dMaxWidthMaster && dY>dMaxWidthMaster)
				{ 
					dRotation += 90;
					if(bDebug)reportMessage("\nrotation" +dRotation); 
				}

				if (abs(dRotation)>dEps)
				{
					CoordSys csRot;
					csRot.setToRotation(dRotation, _ZW, child.coordSys().ptOrg());
					child.transformBy(csRot);	
					plEnvelope.transformBy(csRot);
				}
				//vecXGrain.vis(child.coordSys().ptOrg(),4);
				
				pp=PlaneProfile (plEnvelope);
				seg = pp.extentInDir(vecX);seg.vis(i);
				dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
				dY = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
					
				child.transformBy((ptInsert-seg.ptMid())+vecX*.5*dX-vecY*.5*dY);
				childs.append(child);
				ptInsert.transformBy(-vecY*(dY+dYOffset));			
			}// next i
			if(bDebug)reportMessage("\n		"+ childs.length() + " created");	
		}// end create childs
		
	// create sorter
		if (childs.length()>0)
		{
			pts.append(_Pt0);//getPoint(TN("|Pick insertion point|")));
			for(int i=0;i<childs.length();i++)
				ents.append(childs[i]);	
				
			SetInvertedErectionSequence(ents);	
				
			tslNew.dbCreate(scriptName(), vecUcsX, vecUcsY, gbs, ents, pts, nProps, dProps, sProps, _kModelSpace, mapTsl);	
		}// end create clone

		eraseInstance();	
		return;
	}
// END IF on insert____________________________________________________________________________________________

//endregion 

//region Remove entities if map has been set remotly (especially from MasterPanelManager when nesting a subset of this inst)
	int bRemoveEnt;	
	Entity entsRemovals[0];
	if (_Map.hasMap("RemoveEnt[]"))
	{
		Entity ents[0];
		Map m = _Map.getMap("RemoveEnt[]");
		for(int i=0;i<m.length();i++)
		{
			Entity ent = m.getEntity(i);
			if (ent.bIsValid())
			{
				int n = _Entity.find(ent);
				if (n>-1)
				{
					if(bDebug)reportMessage("\n"+ scriptName() + " removing child " + ent.handle());
					entsRemovals.append(ent);
					_Entity.removeAt(n);
				}
			}
		}// next i

		//return;
		_Map.removeAt("RemoveEnt[]", true);
		//bRemoveEnt=true;
	}
	
	_Pt0.setZ(0);		
//endregion 

//region Get selection set
	PainterDefinition pd;
	int bIsPainterRule = sPainters.findNoCase(sRule) >- 1;
	if (bIsPainterRule)
	{
		pd=PainterDefinition(sPainterCollection + sRule);
		bIsPainterRule = pd.bIsValid();		
	}
	sSortingDir.setReadOnly(bDebug||bIsPainterRule ? false : _kHidden);

// collect sips from childs
	Sip sips[0];
	ChildPanel childs[0];
	for(int i=0;i<_Entity.length();i++)
	{
		Entity ent = _Entity[i];

		ChildPanel child= (ChildPanel)ent;
		if(child.bIsValid())
		{
			Sip sip = child.sipEntity();
			if (sip.bIsValid())
			{
				childs.append(child);
				sips.append(sip);
			}
		}
	}// next i		

	if (sips.length()<1)
	{ 
		if (bDebug)reportMessage("\n" + scriptName() + " " + _ThisInst.handle() + " no sips found");
		eraseInstance();
		return;
	}


	if(bDebug)reportMessage("\n"+ scriptName() + " " + _ThisInst.handle() + " got " + sips.length() +" panels" + childs.length() + " - " + _Entity.length());
		
//endregion 

//	get all available objectVariables for all panels
// use for this one of the panels
	Entity ents[0];
	for (int i=0;i<sips.length();i++) 
	{ 
		ents.append(sips[i]); 		 
	}//next i
	SetInvertedErectionSequence(ents);	

	
//	ents.append(childs[0]);
	Sip sip0 = sips[0];
	
	String sObjectVariables[0];
	for (int i = 0; i < ents.length(); i++)
	{ 
		String _sObjectVariables[0];
		_sObjectVariables.append(ents[i].formatObjectVariables());
		
	// append all variables, they might vary by type as different property sets could be attached
		for (int j = 0; j < _sObjectVariables.length(); j++)
		{
			String variable = _sObjectVariables[j];
			if (sObjectVariables.find(variable) < 0)
				sObjectVariables.append(variable);
		}
	}//next
	
	// add some custom variables for the sip
	{ 
		String k;
		k = "Calculate Weight"; if (sObjectVariables.find(k) < 0 && sip0.realBody().volume()>pow(dEps,3))sObjectVariables.append(k);
		// other custom properties for the panels
		k = "GrainDirection";		if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
		k = "GrainDirectionText";	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
		k = "GrainDirectionTextShort";	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
		k = "SurfaceQuality";	if(sObjectVariables.find(k) < 0)sObjectVariables.append(k);
		k = "SurfaceQualityTop";	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
		k = "SurfaceQualityBottom";	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
		k = "SipComponent.Name";	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
		k = "SipComponent.Material";	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
	
	// add custom variable that was hardcoded before
		k = "Package";	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
	}
	
//	// get translated list of variables
//	String sTranslatedVariables[0];
//	for (int i = 0; i < sObjectVariables.length(); i++)
//	{ 
//		sTranslatedVariables.append(T("|" + sObjectVariables[i] + "|"));
//	}
//	
//	// order both arrays alphabetically
//	for (int i=0;i<sTranslatedVariables.length();i++)
//		for (int j=0;j<sTranslatedVariables.length()-1;j++) 
//			if (sTranslatedVariables[j]>sTranslatedVariables[j+1])
//			{
//				sObjectVariables.swap(j, j + 1);
//				sTranslatedVariables.swap(j, j + 1);
//			}		
//	
// trigger to select the desired format

//region Trigger AddRemoveFormat
//	String sTriggerAddRemoveFormat = T("|Add/Remove Format|");
//	addRecalcTrigger(_kContext, "../"+sTriggerAddRemoveFormat );
//	if (_bOnRecalc && (_kExecuteKey=="../"+sTriggerAddRemoveFormat || _kExecuteKey==sTriggerAddRemoveFormat))
//	{
//		String sPrompt;
////		if (bHasSDV && entsDefineSet.length()<1)
////			sPrompt += "\n" + T("|NOTE: During a block setup only limited properties are accesable, but you can enter \nany valid format expression or use custom catalog entries.|");
//		sPrompt+="\n"+ T("|Select a property by index to add(+) or to remove(-)|") + T(" ,|-1 = Exit|");
//		reportNotice(sPrompt);
//		
//		for (int s=0;s<sObjectVariables.length();s++) 
//		{ 
//			String key = sObjectVariables[s]; 
//			String keyT = sTranslatedVariables[s];
//			String sValue;
//			for (int j=0;j<ents.length();j++) 
//			{ 
//				String _value = ents[j].formatObject("@(" + key + ")");
//				if (_value.length()>0)
//				{ 
//					sValue = _value;
//					break;
//				}
//			}//next j
//
//			String sAddRemove = sChildProperties.find(key,0, false)<0?"(+)" : "(-)";
//			int x = s + 1;
//			String sIndex = ((x<10)?"    " + x:"   " + x)+ "  "+sAddRemove+"  :";
//			
//			reportNotice("\n"+sIndex+keyT + "........: "+ sValue);
//			
//		}//next i
//		int nRetVal = getInt(sPrompt)-1;
//				
//	// select property	
//		while (nRetVal>-1)
//		{ 
//			if (nRetVal>-1 && nRetVal<=sObjectVariables.length())
//			{ 
//				String newAttrribute = sChildProperties;
//	
//			// get variable	and append if not already in list	
//				String variable ="@(" + sObjectVariables[nRetVal] + ")";
//				int x = sChildProperties.find(variable, 0);
//				if (x>-1)
//				{
//					int y = sChildProperties.find(")", x);
//					String left = sChildProperties.left(x);
//					String right= sChildProperties.right(sChildProperties.length()-y-1);
//					newAttrribute = left + right;
//					reportMessage("\n" + sObjectVariables[nRetVal] + " new: " + newAttrribute);				
//				}
//				else
//				{ 
//					newAttrribute+="@(" +sObjectVariables[nRetVal]+")";
//								
//				}
//				sChildProperties.set(newAttrribute);
//				reportMessage("\n" + sChildPropertiesName + " " + T("|set to|")+" " +sChildProperties);	
//			}
//			nRetVal = getInt(sPrompt) - 1;
//		}
//		setExecutionLoops(2);
//		return;
//	}	
//endregion

	
// get some enums from properties and settings
	int nFaceAlignment = sFaceAlignments.find(sFaceAlignment);// 0 = unchanged, 1 = higher quality , 2= lower quality
	if (nFaceAlignment <0 && sFaceAlignments.length()>0)sFaceAlignment.set(sFaceAlignments[0]);	
	int nLeftRight =(bAlignRight)?-1:1;//1 = left, -1 = right

// extract property names for child and master
	String sChildPropertyNames[0];
	String sList= sChildProperties;
	
	while (sList.length()>0 || sList.find(";",0)>-1)
	{
		String sToken = sList.token(0);	
		sToken = T(sToken.trimLeft().trimRight());
		sToken.makeUpper();
		sChildPropertyNames.append(sToken);
		int x = sList.find(";", 0);
		sList.delete(0, x + 1);
		sList.trimLeft();	
		if (x == -1)sList = "";
	}	
	
// on the event of changing the rule
	String sEvents[] = {sRuleName,"_Pt0", sFaceAlignmentName,sChildPropertiesName, sSortingDirName };
	if (sEvents.find(_kNameLastChangedProp)>-1 || _bOnRecalc || _bOnDbCreated || bRemoveEnt)
	{
		//ACTION
		setExecutionLoops(2);
	}

//region Get selected sorting rule in mapCriterias
	


// map of criterias in the selected sorting rule
	int nColor = 161;
	Map mapSorting,mapCriterias;
	if (!bIsPainterRule)
	{ 
		String k;		
		for (int i = 0; i < mapSortings.length(); i++)
		{
			Map m = mapSortings.getMap(i);
			k = "Name"; 
			if (m.getString(k)==sRule)
			{ 
				mapSorting = m;
				mapCriterias = m.getMap("Criteria[]");
				break;				
			}
		}// next i		
		
		k = "Color"; if (mapSorting.hasInt(k))nColor = mapSorting.getInt(k);
		
		if (mapCriterias.length() < 1)
		{
			reportMessage("\n" + scriptName() + ": " + T("|The selected rule|") + " " + sRule + " " + T("  |is not accesible|"));
			mapCriterias = mapDefault.getMap("Sorting[]\\Sorting\\Criteria[]");
		}		
	}	
//endregion 

	
//region Display
// declare displays
	Display dp(nColor);
	dp.textHeight(U(200));
	Display dpShadow(nColorShadow);
	dpShadow.lineType(sLineType, dLinetypeScale);	
	
//endregion 	



//region XML Rule
	int nCriterias[0];
	String sCriteriaFormats[0];
	int nWidthMapIndex = -1, nCounter = -1; // V1.17 Use only valid criteria
	int bOrderRange;
	String sPropDisplays[0];
	
	String sSortFormat;
	if (bIsPainterRule)
	{ 
		String ftr = pd.formatToResolve();
		String tokens[] = ftr.tokenize("?");
		if (tokens.length()==2)
		{ 
			sSortFormat = tokens[0];
			sCriteriaFormats.append(tokens[1]);			
		}
		else
			sCriteriaFormats.append(ftr);	
	}
	else
	{ 
	// keeps the indices if properties for which it is required sorting

		Map mapTemp;
		for(int i=0;i<mapCriterias.length();i++)
		{
		// get property
			if ( ! mapCriterias.hasMap(i))continue;
			Map m = mapCriterias.getMap(i);
			String sProperty = m.getString("Property");
			sCriteriaFormats.append(sProperty);	
			
			int nLeft = sProperty.find("@", 0);
			sProperty = sProperty.right(sProperty.length() - nLeft);
			
			// remove @()
			sProperty.trimLeft("@(");		
			sProperty.trimRight(")");
			
		// Check if trim sets nLeft to 0
			if(nLeft < 1)
			{
				sPropDisplays.append(sProperty);
			}		
	
		// verify if in hardcoded list
			// dont consider case sensitive 
			int nProperty = sObjectVariables.findNoCase(sProperty);
			
			if (nProperty>-1 && nCriterias.find(nProperty)<0)
			{	
				// found from the list and not defined twice
				nCriterias.append(nProperty);
				mapTemp.appendMap("Criteria", m);
				nCounter++;
				if(bDebug)reportMessage("\n"+ " Sorting criteria: " + sProperty);
			}
			else if(sProperty.find("Ranges",0,false)>-1 && sProperty.length()==6)
			{				
			// Get special information of Range[], Functionality not property dependent
				nCriterias.append(-1);
				nCounter++;
				bOrderRange = m.getInt("Order");
				nWidthMapIndex = nCounter;
				mapTemp.appendMap("Criteria", m);
				if(bDebug)reportMessage("\n"+ " Sorting criteria: " + sProperty);
			}	
		}	
	
	// override validated and sorted criteria map
	// includes only valid criterias of existing properties in sProps
	// nCriterias has array of indices of the requested properties as criteria 
	// from list of available properties in sProps
		mapCriterias = mapTemp;		
	}
	
//endregion 

	

	
// declare char arrays as helper of sorting numbers
	char charsDown[]={'J','I','H','G','F','E','D','C','B','A'};
	char charsUp[]={'A','B','C','D','E','F','G','H','I','J'};	

//region QUALITY: collect sorting strings of quality
	String sQualityDescriptions[0];
	String sQualityDefinitions[0];
	int nAQualities[0], nBQualities[0];
	String sStyleNames[0];
	double dStyleAreas[0];

	for (int c = 0; c < sips.length(); c++)
	{
		Sip sip = sips[c];
		ChildPanel child = childs[c];
		if (!sip.bIsValid())continue;
	
	// get surface quality
		String styleName = sip.style();
		
		
		SipStyle style(styleName);
		String entries[2];
		int qualities[0];
		entries[0]=style.surfaceQualityTop();
		if (sip.surfaceQualityOverrideTop()!="")	entries[0] = sip.surfaceQualityOverrideTop();

		entries[1]=style.surfaceQualityBottom();
		if (sip.surfaceQualityOverrideBottom()!="")	entries[1] = sip.surfaceQualityOverrideBottom();

		qualities.append(SurfaceQualityStyle(entries[0]).quality());
		qualities.append(SurfaceQualityStyle(entries[1]).quality());

	// swap quality if child is flipped
		int bIsFlipped = child.bIsFlipped();
		if(bIsFlipped) 
		{
			entries.swap(0,1);			
			qualities.swap(0,1);
		}	
		
	// flip child if face alignment does not match
		if ((nFaceAlignment==1 && qualities[0]<qualities[1]) || (nFaceAlignment==2 && qualities[0]>qualities[1]))// higher or lower quality on top face
		{
			if(bDebug)reportMessage("\n		flipping due to face alignment");

			if (bIsFlipped)bIsFlipped=false;
			else	bIsFlipped=true;
			child.setBIsFlipped(bIsFlipped);
			
			entries.swap(0,1);			
			qualities.swap(0,1);			
		}		
	
	// convert to string
		String key =  qualities[0];
		String valueA;
		for(int i=0;i<key.length();i++){String s = key.getAt(i);int n = s.atoi();valueA+= charsDown[n];}// next i	
		
		key =  qualities[1];
		String valueB;
		for(int i=0;i<key.length();i++){String s =key.getAt(i);int n = s.atoi();valueB+= charsDown[n];}// next i	
		
	// store QualityDefinitions	
		sQualityDefinitions.append(valueA + ";" +valueB);
		sQualityDescriptions.append(entries[0]+ "(" +entries[1] + ")");		
	}		

//End Quality //endregion 

//region // PACKAGES: collect sorting strings of packages _________________________________________________________PACKAGE
	String sPackages[sips.length()];
	int nPackages[sips.length()];
	// find the index of package
	int nPackage = sObjectVariables.findNoCase("Package",-1);
	if (nPackage>-1)
	{
	// assign helper chars
		int c = nCriterias.find(nPackage);
		
		int bAscending = mapCriterias.getMap(c).getInt("Order");
		char chars[0];
		chars = (bAscending?charsUp:charsDown);
						
		for(int a=0;a<sips.length();a++)
		{
			Sip sip = sips[a];
		// get a potential freight item and package link
			TslInst freightItem, freightPackage;
			{
				Entity entTools[]= sip.eToolsConnected();	
				for(int t=0;t<entTools.length();t++)
				{ 
					if (entTools[t].bIsKindOf(TslInst()) && ((TslInst)entTools[t]).map().getInt("isFreightItem") )
					{
						freightItem=(TslInst)entTools[t];
						break;
					}
				}
					
			// get potential parent package	
				if (freightItem.bIsValid())
				{
					Map mapX = freightItem.subMapX("Hsb_PackageChild");
					freightPackage.setFromHandle(mapX.getString("ParentUID"));		
				}
			}
			
			String sPackage;
			if (freightPackage.bIsValid())
			{
			// get package number
				nPackages[a]=  freightPackage.color();
				String key =  nPackages[a];

			// append leading zeros
				{
					int n = key.length();
					if (n<5)for(int i=0;i<(5-n);i++) key= "0"+key;
				}
			
			// convert to string	
				for(int i=0;i<key.length();i++){String s = key.getAt(i);int n = s.atoi();sPackage+= chars[n];}// next i	
			}
			sPackages[a] = sPackage;
			//if(bDebug)reportMessage("\n"+ scriptName() + " panel " + sip.name() + " is assigned to package " + nPackages[a] + " " + sPackage);
		}
	}	

	int nPackageMapIndices[0];
	if (nCriterias.find(nPackage) >- 1)
	{ 
		nPackageMapIndices.append(nCriterias.find(nPackage));
	}	
//End // PACKAGES: collect sorting strings of packages _________________________________________________________PACKAGE//endregion 

//region Get all ranges if range property is selected
	// min/max Width if Ranges is used as sorting criteria
	double dMinWidths[0], dMaxWidths[0];	
	// map of requested ranges for the width
	Map mapRangesWidth;
	// Name of the Ranges group
	String sRangeNames[0];
	// Defines if Range group is used to set max width of masterpanel
	int nWriteWidthInMaps[0], bWriteWidthInMap;
	// initialize the range for width
	int nCurrentRange = 0;
	
// collect sort keys length and width relative to grain direction
	double dWidths[sips.length()];	

// The graindirection is always used as the first sorting criteria
	int nGrainDirections[0];
	for (int a = 0; a < sips.length(); a++)
	{
		Sip sip = sips[a];
		double dY = sip.dW(), dX = sip.dL();

		if(dY > dX && dX <= dMaxWidthMaster && dY > dMaxWidthMaster)
		{
			dWidths[a] = dX;
			nGrainDirections.append(0);
		}
		else
		{
			dWidths[a] = dY;
			nGrainDirections.append(1);
		}						   
	}
	
	if (nWidthMapIndex > -1)
	{	
		Map mapWidth = mapCriterias.getMap(nWidthMapIndex);
	// get width ranges	
		if (mapWidth.hasMap("Range[]"))
		{ 
			// ranges prompted for this width criteria
			mapRangesWidth = mapWidth.getMap("Range[]");
			for (int i = 0; i < mapRangesWidth.length(); i++)
			{ 		
				// get the prompted name of the range from the map of all ranges
				String name = mapRangesWidth.getString(i);
				if (mapRanges.hasMap(name))
				{ 
					Map mapRange = mapRanges.getMap(name);
					if (mapRange.hasDouble("min") && mapRange.hasDouble("max"))
					{ 
						// there is a min and a max, get the 2 values
						dMinWidths.append(mapRange.getDouble("min"));
						dMaxWidths.append(mapRange.getDouble("max"));
						sRangeNames.append(name);
						nWriteWidthInMaps.append(true);//mapRange.getInt("SetMPWidth"));
					}
				}
			}//next i
		}
		
	// order width ranges by
		for (int i=0;i<dMaxWidths.length();i++) 
			for (int j=0;j<dMaxWidths.length()-1;j++) 
				if (dMaxWidths[j]>dMaxWidths[j+1])
				{
					dMaxWidths.swap(j, j + 1);
					dMinWidths.swap(j, j + 1);
					sRangeNames.swap(j, j + 1);
					nWriteWidthInMaps.swap(j, j + 1);
				}
	// append a left over group: this group shall collect any item not within any range
		dMaxWidths.append(U(100000));
		dMinWidths.append(0);
		sRangeNames.append(T("|Out of range|"));
		nWriteWidthInMaps.append(false);
	}		
//End Get all ranges if range property is selected//endregion 


// collect sort keys for each panel by given properties					 
	String sSortKeys[sips.length()];
	
	if (sSortFormat.length()>0 && sSortFormat.find("@(",0,false)>-1)
	{ 
		for(int i=0;i<sips.length();i++)
			sSortKeys[i] = sips[i].formatObject(sSortFormat);
	}
	else
	{ 
		for (int i = -1; i < nCriterias.length(); i++)
		{
			int c = (i > -1)? nCriterias[i] : 0;
	
			for(int a=0;a<sips.length();a++)
			{
				String key;
				String sx = sips[a].formatObject("@(Hsb_Sequencechild.SequenceNumber)");
		
			// Graindirection is the first and always used sorting criteria 
				if(i == -1)
				{
					if(nGrainDirections.length() > a)
						sSortKeys[a] += nGrainDirections[a];
				}
				// Add Ranges to Sortkeys
				else if (i == nWidthMapIndex)
				{ 
				// use always [mm] and append leading zeros
					double value = 1000 / U(1000) * dWidths[a];
					key = value;
					if (value > U(10000))key = "0" + value;
					else if (value > U(1000))key = "00" + value;
					else if (value > U(100))key = "000" + value;
					else if (value > U(10))key = "0000" + value;
					else if (value > U(1))key = "00000" + value;
	
	//			// Make sure the length of the width is in mm so the double converted to the string is less than 1
	//				double dMM = 1000 / U(1000);
	//				//key =  (bOrderRange) ? 1 - 1 / dMM * dWidths[a] : 1 / dMM * dWidths[a];// 1.15 deprectaed
	//				key = dMM * dWidths[a] ;
				}
				else if (nPackageMapIndices.find(i) >- 1)
				{ 
					key = sPackages[a];
				}
				else if (c>-1 && c<sObjectVariables.length())
				{
					String format = "@(" + sObjectVariables[c] + ")";
					if (format.find("SurfaceQuality",0,false)>-1)
						key = sQualityDefinitions[a];
					else if (format.find("Hsb_Sequencechild.SequenceNumber",0,false)>-1) // HSB-13027: pad number left to make the int a sorting string
					{
						format = "@(" + sObjectVariables[c] + ":PL5;0)";
						key = sips[a].formatObject(format);			
					}
					else
						key = sips[a].formatObject(format);
				}
				sSortKeys[a] += "_"+key;
				if ( ! i == nCriterias.length() - 1)sSortKeys[a] += ";";
			}
		}// next i		
	}


	// order by sortkey	
	int bDescending = bIsPainterRule && sSortingDir == tDescending;
	for (int a = 0; a < sips.length(); a++)
	{ 
		for (int b = 0; b < sips.length() - 1; b++)
		{
			String key0 = sSortKeys[b];
			String key1 = sSortKeys[b+1];
			if ((!bDescending &&  key0 > key1) || (bDescending &&  key0 < key1))
			{
				sips.swap(b, b + 1);
				childs.swap(b, b + 1);
				sSortKeys.swap(b, b + 1);
				sQualityDescriptions.swap(b, b + 1);
				sQualityDefinitions.swap(b, b + 1);
				sPackages.swap(b, b + 1);
				dWidths.swap(b, b + 1);
				nPackages.swap(b, b + 1);
				sPropDisplays.swap(b, b + 1);
				nGrainDirections.swap(b, b + 1);
			}
		}// next b
	}
	

	double dTextHeight = U(200); 	
	dp.textHeight(dTextHeight);

	int nTag;
	Point3d ptLoc = _Pt0;
	double dMaxY;

	Vector3d vecXE = _XW;// TODO specify reading direction, vecZView to resolve combined surface quality bottom/top
	Vector3d vecYE = _YW;
	
// 	childs have been previously sorted
	// so they will be filled one line after each other
	int bOneGroup = true;
	ChildPanel childsThis[0];
	Point3d ptTsl = _Pt0;
	double dMaxWidthThis = 0;
	
	
	
//region Make sure basic child alignment does not exceed max width HSB-9504 Childpanles are expected to be aligned parallel to _XW if current dY exceeds max master width
	for (int a = 0; a < childs.length(); a++)
	{
		ChildPanel child = childs[a];
		PlaneProfile pp(CoordSys(_Pt0, _XW, _YW, _ZW));
		pp.unionWith(child.realBody().shadowProfile(Plane(_Pt0, _ZW)));
		
		LineSeg seg = pp.extentInDir(_XW);
		
		double dX = abs(_XW.dotProduct(seg.ptStart()-seg.ptEnd()));
		double dY = abs(_YW.dotProduct(seg.ptStart()-seg.ptEnd()));	
		
		if (dY>dMaxWidthMaster && dX<=dMaxWidthMaster)
		{ 	
			CoordSys csRot;
			csRot.setToRotation(90, _ZW, seg.ptMid());
			child.transformBy(csRot);
			seg.transformBy(csRot);			//seg.vis(3);			
		}
		else if (bDebug)
			seg.vis(1);
	}		
//endregion 

	
	
	
	
//region Transform child to sorted location and apply a group tag
	for (int a = 0; a < childs.length(); a++)
	{
		ChildPanel child = childs[a];
	// transformation
		CoordSys cs;
		cs = child.sipToMeTransformation();
		
	// set color
		dp.color(nColor);	
		
	// get dX and dY
		Sip sip = sips[a];
			
		LineSeg seg = PlaneProfile(sip.plEnvelope()).extentInDir(sip.vecX());
		seg.transformBy(cs);
		seg.vis(a);
		double dX = abs(_XW.dotProduct(seg.ptStart()-seg.ptEnd()));
		double dY = abs(_YW.dotProduct(seg.ptStart()-seg.ptEnd()));
		//if (dMaxY<dY)dMaxY=dY;		// merge HSB-7187

	// test if group conditions apply
		int bLineFeed;
		int bRange;
//		String sTxts[0]; // deprecated 1.15

		if(nCriterias.length() < 1)
		{
			if(a > 0 && nGrainDirections[a] != nGrainDirections[a-1])
				bLineFeed = true;			
		}
		
		for(int i=0;i<nCriterias.length();i++)
		{
			if(a > 0 && nGrainDirections[a] != nGrainDirections[a-1])
				bLineFeed = true;
			
		// get group condition
			int c = nCriterias[i];
			int bWidth = (i == nWidthMapIndex)? true : false;
			int bNewGroup = mapCriterias.getMap(i).getInt("Group");
			if (!bNewGroup)continue;// && !bOneGroup

		// get properties of this and the previous
			String p1, p2;
			
			if(bWidth)
			{
				// if width is requested
				if (dMinWidths.length() > 0)
				{ 
					{ 
						// has to be grouped in groups of width ranges
						double dMin = dMinWidths[nCurrentRange];
						double dMax = dMaxWidths[nCurrentRange];
						// get the range
						if (dWidths[a] >= dMinWidths[nCurrentRange] && dWidths[a] < dMaxWidths[nCurrentRange])
						{ 
							// Max width is writen into map
							if (nWriteWidthInMaps[nCurrentRange])
								bWriteWidthInMap = true;

							continue;
						}
						else
						{ 
						// create or find a new range
							int bRangeFound = false;
							for (int j = 0; j < dMinWidths.length(); j++)
							{ 
								if (dWidths[a] >= dMinWidths[j] && dWidths[a] < dMaxWidths[j])
								{ 
									nCurrentRange = j;
									p1 = sRangeNames[nCurrentRange];
									
									// Max width is writen into map
									if (nWriteWidthInMaps[nCurrentRange])
										bWriteWidthInMap = true;

//									sTxts.append(T("|Width Range|") + ": " + p1);// deprecated 1.15
									if (a > 0)p2 = dWidths[a - 1];
									bRangeFound = true;
									break;
								}
							}//next j
							if (!bRangeFound)
							{ 
								reportMessage("\n"+ scriptName() + ": " + T("|Unexpected error while grouping to range.| ")+T("|Tool will be deleted.|"));
								eraseInstance();
								return;	
							}
						}
					}
				}
				else
				{ 
					// do a group for each width
					p1 = dWidths[a];
//					sTxts.append(T("|Width Range|") + ": " + p1);// deprecated 1.15
					if (a > 0)p2 = dWidths[a - 1];
				}
			}// width
			
			if(!bWidth && c>-1 && c<sObjectVariables.length())
			{
				String format;
				String key = sObjectVariables[c];
				if(key == "SurfaceQuality")
				{
					p1 = sQualityDefinitions[a];
					if (a>0)p2 = sQualityDefinitions[a-1];
				}
				else if (sObjectVariables[c].find("Hsb_Sequencechild.SequenceNumber",0,false)>-1)
				{ 
					format = "@(" + sObjectVariables[c] + ":PL5;0)";
					p1 = sip.formatObject(format);
					if (a>0)p2 = sips[a-1].formatObject(format);
				}					
				else
				{ 
					format = "@(" + sObjectVariables[c] + ")";
					p1 = sip.formatObject(format);
					if (a>0)p2 = sips[a-1].formatObject(format);
				}
			}
			else if(!bOrderRange)
			{
				p1 = p2;
			}
	
		// set linefeed whilst keeping any linefeed being set					
			if (a > 0)
				bLineFeed = (bLineFeed ? true : p1 != p2);
		}
			

	// offset to current location
		double dXLoc =abs( _XW.dotProduct(ptLoc-_Pt0));//nLeftRight*
		double dR = dRowLength-dXLoc;
		
	// line feed as dX extents max row length	
		if ((dR<=0 && dR<dX) || bLineFeed)
		{
			ptLoc.transformBy(_XW*_XW.dotProduct(_Pt0-ptLoc)-_YW*(dMaxY+ (bLineFeed?2:1)*dRowOffset));	
			dMaxY =0;
		}
		
	// transform
		Point3d pt = seg.ptMid() - nLeftRight * .5 * _XW * dX + .5 * _YW * dY;	
		child.transformBy(ptLoc-pt);
		ptLoc.transformBy(nLeftRight*_XW * (dX+U(500)));	

		if (bLineFeed && bLastExecutionLoop()) 
		{ 
			// create tsl
			TslInst tslNew;			Vector3d vecXTsl= _XW;	Vector3d vecYTsl= _YW;
			GenBeam gbsTsl[] = {};	Entity entsTsl[] = {};	Point3d ptsTsl[] = {ptTsl};
			int nProps[] ={ };		double dProps[] ={ };	String sProps[] ={ sRule, sFaceAlignment, sChildProperties, sSortingDir};
			Map mapTsl = _Map;	
			
			if(childsThis.length() == 0)
				childsThis.append(child);
			
			for (int ii = 0; ii < childsThis.length(); ii++)
			{ 
				entsTsl.append(childsThis[ii]);
			}//next ii
			//				
			tslNew.dbCreate(scriptName(), vecXTsl, vecYTsl, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);

			// new group
			childsThis.setLength(0);
			bOneGroup = false;
		}
		
		//Collect childs for new instance
		childsThis.append(child);
		
	// Set max width. This has to be after creating a new instance HSB-7187 // V1.20
		if (dMaxY<dY)dMaxY=dY;																	  
		// Get max width of childs per instance. Used if range is sorting criteria
		if (dWidths[a] > dMaxWidthThis)
			dMaxWidthThis = dWidths[a];
		
		// we have child and sip
		CoordSys ms2ps(_PtW, _XW, _YW, _ZW); // TODO assign modelspace to paperspace transformation if text needs to be displayed in paperspace
		Vector3d vecZE = vecXE.crossProduct(vecYE);
		
		Vector3d vecXGrain, vecYGrain;
		int nRowGrain = - 1;
		double dLengthBeforeGrain; // the potential line number of the grain symbol and the amount of characters in the same row befor symbol
		int nGrainMode = -1; // 0 = X lengthwise, 1 = Y crosswise, 2 = Z parallel to view
		String sqTop,sqBottom; 
		SipComponent components[0];
		HardWrComp hwcs[0];
		Point3d ptCen;
		
//	if (sip.bIsValid())
//	{
		vecXGrain = sip.woodGrainDirection();
		vecYGrain = vecXGrain.crossProduct(sip.vecZ());
		if (!vecXGrain.bIsZeroLength())
		{
			if (child.bIsValid())
			{
				vecXGrain.transformBy(child.sipToMeTransformation());
				vecYGrain.transformBy(child.sipToMeTransformation());
			}
			vecXGrain.transformBy(ms2ps);
			vecYGrain.transformBy(ms2ps);
											
			nGrainMode = sip.vecX().isParallelTo(vecXGrain) ? 0 : 1;
			if (nGrainMode>-1 && !vecZE.bIsZeroLength() && vecXGrain.isParallelTo(vecZE))
				nGrainMode = 2;
		}

		SipStyle style(sip.style());
		sqTop = sip.surfaceQualityOverrideTop();
		if (sqTop.length() < 1)sqTop = style.surfaceQualityTop();
		if (sqTop.length() < 1)sqTop = "?";
		int nQualityTop = SurfaceQualityStyle(sqTop).quality();
		
		sqBottom = sip.surfaceQualityOverrideBottom();
		if (sqBottom.length() < 1)sqBottom = style.surfaceQualityBottom();
		if (sqBottom.length() < 1)sqBottom = "?";
		int nQualityBottom = SurfaceQualityStyle(sqBottom).quality();
		
		components = style.sipComponents();
		
		ptCen = sip.ptCen();
		ms2ps.setToAlignCoordSys(ptCen, sip.vecX(), sip.vecY(), sip.vecZ(), ptCen, vecXE , vecYE, vecZE);
//	}

		Entity ent = sip;//HSB-13027  ents[a];		
		int bIsSolid = ent.realBody().volume() > pow(dEps, 3);
		String sLines[0];// store the resolved variables by line (if \P was found)	
		String sValues[0];	
		String sValue=  ent.formatObject(sChildProperties);
	
	// parse for any \P (new line)
		String sx2 = sip.formatObject("@(Hsb_Sequencechild.SequenceNumber)");
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
					//left = value.find("@(", 0);
					int right = value.find(")", left);
					
				// key found at first location	
					if (left == 0 && right > 0)
					{
						String sVariable = value.left(right + 1);
	
					// any solid	
						if (bIsSolid && sVariable.find("@(Calculate Weight)",0,false)>-1)
						{
							Map mapIO,mapEntities;
							mapEntities.appendEntity("Entity", ent);
							mapIO.setMap("Entity[]",mapEntities);
							TslInst().callMapIO("hsbCenterOfGravity", mapIO);
							double dWeight = mapIO.getDouble("Weight");// / dConversionFactor;
							
							String sTxt;
							if (dWeight<10)	sTxt.formatUnit(dWeight, 2,1);			
							else			sTxt.formatUnit(dWeight, 2,0);
							sTxt = sTxt + " kg";						
							sTokens.append(sTxt);
						}

					// SIP
						else if (sip.bIsValid())
						{ 
							if (sVariable.find("@(GrainDirectionText)",0,false)>-1)
								sTokens.append(vecXGrain.isParallelTo(_XW) ? T("|Lengthwise|") : T("|Crosswise|"));
							else if (sVariable.find("@(GrainDirectionTextShort)",0,false)>-1)
								sTokens.append(vecXGrain.isParallelTo(_XW) ? T("|Grain LW|") : T("|Grain CW|"));
							else if (sVariable.find("@(surfaceQualityBottom)",0,false)>-1)
								sTokens.append(sqBottom);	
							else if (sVariable.find("@(surfaceQualityTop)",0,false)>-1)
								sTokens.append(sqTop);	
							else if (sVariable.find("@(SurfaceQuality)",0,false)>-1)
							{
								String sQualities[] ={sqBottom, sqTop};
								if (!vecZE.bIsZeroLength() && sip.vecZ().isCodirectionalTo(vecZE))sQualities.swap(0, 1);
								String sQuality = sQualities[0] + " (" + sQualities[1] + ")";
								sTokens.append(sQuality);	
							}
							else if (sVariable.find("@(Graindirection)",0,false)>-1 && !vecXGrain.bIsZeroLength())
							{
								nRowGrain = sLines.length();
								String sBefore;
								for (int j=0;j<sTokens.length();j++) 
									sBefore += sTokens[j]; // the potential characters before the grain direction symbol
								dLengthBeforeGrain = dp.textLengthForStyle(sBefore, _DimStyles.first(), dTextHeight);
								sTokens.append("    ");//  4 blanks, symbol size max 4 characters lengt
							}
							else if (sVariable.find("@(SipComponent.Name)",0,false)>-1)
								sTokens.append(SipStyle(sip.style()).sipComponentAt(0).name());								
							else if (sVariable.find("@(SipComponent.Material)",0,false)>-1)
								sTokens.append(SipStyle(sip.style()).sipComponentAt(0).material());								
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
					left = value.find("@(", 0);
				}
	
				for (int j=0;j<sTokens.length();j++) 
					value+= sTokens[j]; 
			}
			//sAppendix += value;
			sLines.append(value);
		}	
		String sText;
		for (int j=0;j<sLines.length();j++) 
		{ 
			sText += sLines[j];
			if (j < sLines.length() - 1)sText += "\\P";		 
		}//next j

		dp.draw(sText, seg.ptMid(), vecXE, vecYE, 0, 0);
		Point3d ptT = seg.ptMid();ptT.vis(2);
		
		if (bLineFeed)
		{
//			ptTsl = _Pt0 - nLeftRight * _XW * U(500) - _YW * _YW.dotProduct(_Pt0 - pt);
			ptTsl = _Pt0 - _YW * _YW.dotProduct(_Pt0 - pt);			
			if (dMinWidths.length()>0 && nCurrentRange==dMinWidths.length()-1)
				ptTsl -= _YW * 2 * dRowOffset;		
		}
		
//	// Draw grouping information // deprecated 1.15
//		if (bLineFeed || a==0)
//		{
//			Point3d ptTxt = _Pt0-nLeftRight*_XW * U(500)- _YW*_YW.dotProduct(_Pt0-pt);
//			ptTxt.vis(3);
//			ptTsl = ptTxt;
//			for(int i=0;i<sTxts.length();i++)
//			{
//				String sTxt = sTxts[i];
//				dp.draw(sTxt,ptTxt, _XW,_YW,-nLeftRight, -1+(i*-3));
//			}// next i	
//			nTag++;
//		}
	}// next a child
		
//endregion 
	


//region Get Header description from first panel
	String sHeader = " "; // Otherwise 1st text is not lined up. This goes with "+ _YW * U(300)" in Line 1425
	if (childs.length()>0)
	{ 
		Sip sip= childs.first().sipEntity();

		sChildProperties.setDefinesFormatting(sip);


		SipStyle style(sip.style());
		String sqTop = sip.surfaceQualityOverrideTop();
		if (sqTop.length() < 1)sqTop = style.surfaceQualityTop();
		if (sqTop.length() < 1)sqTop = "?";
		int nQualityTop = SurfaceQualityStyle(sqTop).quality();
		
		String sqBottom = sip.surfaceQualityOverrideBottom();
		if (sqBottom.length() < 1)sqBottom = style.surfaceQualityBottom();
		if (sqBottom.length() < 1)sqBottom = "?";
		int nQualityBottom = SurfaceQualityStyle(sqBottom).quality();

		for (int i=0;i<sCriteriaFormats.length();i++) 
		{ 
			String format = sCriteriaFormats[i]; 			
			String value = sip.formatObject(format);
			
		// resolve unknown variables
			int left = value.find("@(", 0);
			if (left>-1)
			{ 
				String _value = value;
				int right = value.find(")", left);
			// key found
				if (left >-1 && right > 0)
				{ 
					String sVariable = value.left(right + 1);
					sVariable = sVariable.right(sVariable.length()-left);
					if (sVariable.find("@(surfaceQualityBottom)",0,false)>-1)
						_value = sqBottom;
					else if (sVariable.find("@(surfaceQualityTop)",0,false)>-1)
						_value = sqTop;
					else if (sVariable.find("@(surfaceQuality)",0,false)>-1)
						_value = sqBottom+"_"+sqTop;	
					else if (sVariable.find("@(Ranges)",0,false)>-1)
						_value = sRangeNames[nCurrentRange];						
					else
						_value = T("|not found|");
					value=value.left(left)+_value+value.right(value.length()-right-1);	
				}			
			}
			if (value.length()>0)
			{ 
				if (sHeader.length() > 0)sHeader += "\P";
				sHeader += value;
			}
			int n = 2;				 
		}//next i
	// draw header
		dp.draw(sHeader,_Pt0-nLeftRight*_XW * U(500) + _YW * U(300), _XW,_YW,-nLeftRight, -1);	
	}
//End Get Header description from first panel//endregion 


//region Create a tsl instance for each group if not at the first time, delete the initial tsl
	if (!bOneGroup && bLastExecutionLoop())
	{ 
	// create tsl for the last group
		TslInst tslNew;			Vector3d vecXTsl= _XW;	Vector3d vecYTsl= _YW;
		GenBeam gbsTsl[] = {};	Entity entsTsl[] = {};	Point3d ptsTsl[] = {ptTsl};
		int nProps[] ={ };		double dProps[] ={ };	String sProps[] ={ sRule, sFaceAlignment, sChildProperties, sSortingDir};
		Map mapTsl = _Map;	
		
		for (int ii = 0; ii < childsThis.length(); ii++)
		{ 
			entsTsl.append(childsThis[ii]);
		}//next ii

		tslNew.dbCreate(scriptName(), vecXTsl, vecYTsl, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
		
		eraseInstance();
		return;
	}		
//End Create a tsl instance for each group if not at the first time, delete the initial tsl//endregion 

// Trigger ShowDependencies
	int bShowDependencies = _Map.getInt("ShowDependencies");
	String sTriggerShowDependencies =bShowDependencies?T("../|Hide Dependencies|"):T("../|Show Dependencies|");
	addRecalcTrigger(_kContext, sTriggerShowDependencies);
	if (_bOnRecalc && (_kExecuteKey==sTriggerShowDependencies || _kExecuteKey==sDoubleClick))
	{
		bShowDependencies = bShowDependencies ? false : true;
		_Map.setInt("ShowDependencies", bShowDependencies);	
		
		if (bShowDependencies)
		{ 
		// prompt for entities
			Entity ents[0];
			PrEntity ssE(T("|Select child panels to trace|") + T(", |<Enter> = all|"), ChildPanel());
			if (ssE.go())
				ents.append(ssE.set());
			_Map.setEntityArray((ents.length()<1?childs:ents),false,"Trace[]","","Trace");	

		}
		else
			_Map.removeAt("Trace[]", true);
		
		
		
		setExecutionLoops(2);
		return;
	}
	if (bShowDependencies)
	{ 
		Entity ents[] = _Map.getEntityArray("Trace[]","","Trace");
		if (ents.length() < 1)
		{ 
			for (int i=0;i<childs.length();i++)
				ents.append(childs[i]);
		}

		for (int i=0;i<ents.length();i++) 
		{ 
			ChildPanel c= (ChildPanel)ents[i]; 
			if ( ! c.bIsValid())continue;
			Sip s = c.sipEntity();
			
			Point3d pts[0];
			Point3d ptA=c.realBody().ptCen(), ptB=s.ptCen(), ptB2=ptB+s.vecZ()*s.dH()*2, ptC;
			pts.append(ptA);
			ptC = (ptA + ptB2) / 2;ptC.vis(2);
			double dX=_XW.dotProduct(ptA - ptC);
			double dY =_XW.dotProduct(ptA - ptC);
			double dZ =_ZW.dotProduct(ptA - ptC);
			pts.append(ptC + _XW*dX+_ZW*dZ);
			
			if (abs(dZ)>0)
			{
				pts.append(pts.last()-_ZW*dZ);
				pts.append(pts.last()-_XW*2*dX);
				pts.append(pts.last()-_ZW*dZ);	
			}
			pts.append(ptB2);
			pts.append(ptB);
			
			Display dpTrace(0);
			for (int j=0;j<pts.length()-1;j++) 
			{ 
				dpTrace.color(i % 10);
				dpTrace.draw(PLine(pts[j], pts[j+1]));	
				 
			}//next j 
		}//next i		
	}

//region Rotation Triggers
	String sTriggerRotateAll = T("../|Rotate All 90°|");
	addRecalcTrigger(_kContext, sTriggerRotateAll );

	String sTriggerRotate90 = T("../|Rotate 90°|");
	addRecalcTrigger(_kContext, sTriggerRotate90 );
	String sTriggerRotate180 = T("../|Rotate 180°|");
	addRecalcTrigger(_kContext, sTriggerRotate180 );

	String sTriggerFlipRotateChild = T("../|Flip + Rotate Child|");
	addRecalcTrigger(_kContext, sTriggerFlipRotateChild );
	String sTriggerFlipChild = T("../|Flip Child|");
	addRecalcTrigger(_kContext, sTriggerFlipChild );

	String sFlipTriggers[] ={sTriggerRotate90,sTriggerRotate180,sTriggerFlipRotateChild,sTriggerFlipChild};
	int nFlipRotateTrigger = sFlipTriggers.find(_kExecuteKey);

	if (_bOnRecalc && _kExecuteKey==sTriggerRotateAll)
	{
		for (int i=0;i<childs.length();i++) 
		{ 
			CoordSys csRot;
			csRot.setToRotation(90, _ZW, childs[i].realBody().ptCen());
			childs[i].transformBy(csRot);	 
		}//next i
		_Map.setInt("UpdateLocation", true);
		setExecutionLoops(2);
		return;
	}	

	if (_bOnRecalc && nFlipRotateTrigger>-1)
	{
		// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select child panels|"), ChildPanel());
		if (ssE.go())
			ents.append(ssE.set());
		
		double dAngle = nFlipRotateTrigger==0?90:180;
		for (int i = 0; i < ents.length(); i++)
		{
			ChildPanel child = (ChildPanel)ents[i];
			CoordSys csRot;
			csRot.setToRotation(dAngle, _ZW, ents[i].realBody().ptCen());
			if (nFlipRotateTrigger!=3)
				child.transformBy(csRot);
			else if (nFlipRotateTrigger>1)
			{ 
				int flipped = child.bIsFlipped()?false:true;
				child.setBIsFlipped(flipped);
			}
		}//next i
		_Map.setInt("UpdateLocation", true);
		setExecutionLoops(2);
		return;
	}
	
// update display after rotation	
	if (_Map.getInt("UpdateLocation"))
	{ 
		_ThisInst.transformBy(Vector3d(0, 0, 0));
		setExecutionLoops(2);
		_Map.removeAt("UpdateLocation", true);
		return;
	}		
	
	//endregion

//region Publish maps
	// write the mapx
	for (int a = 0; a < childs.length(); a++)
	{
		ChildPanel child = childs[a];
		// set subMaxX with tag info to allow grouped execution of masterPanelManager
		Map mapX;
		mapX.setString("tag", _ThisInst.handle() + "_" + nTag);
		child.setSubMapX("presorter", mapX);
	}
	
	// write at tsl instance the max width of the group
	Map mapXTsl;
	
	if(bWriteWidthInMap)
	{
		double defaultWidth;
		for (int i=0;i<dMaxWidths.length();i++) 
		{ 
			if (dMaxWidths[i]>=dMaxWidthThis)
			{
				defaultWidth=dMaxWidths[i];
				break;
			}
			if (defaultWidth<=0)
				defaultWidth = dMaxWidthThis;
		}//next i
		
		mapXTsl.setDouble("DefaultWidth", defaultWidth);
		_ThisInst.setSubMapX("PresorterData", mapXTsl);		
	}		
//End Publish maps//endregion 	
	




#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`$L`9`#`2(``A$!`Q$!_\0`
M'P```04!`0$!`0$```````````$"`P0%!@<("0H+_\0`M1```@$#`P($`P4%
M!`0```%]`0(#``01!1(A,4$&$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*
M%A<8&1HE)B<H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&EJ<W1U
M=G=X>7J#A(6&AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&
MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ>KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!
M`0$!`0````````$"`P0%!@<("0H+_\0`M1$``@$"!`0#!`<%!`0``0)W``$"
M`Q$$!2$Q!A)!40=A<1,B,H$(%$*1H;'!"2,S4O`58G+1"A8D-.$E\1<8&1HF
M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@H.$
MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#W^BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BJDVI65O?VUA-<QI=W6[R82WS/M
M!)('H`.M6Z`"BBB@`HHHH`***J6.I66II,]C<QW"0RF&1HSD!QC(S[9%`%NB
MBB@`HHHH`****`"BBB@`HHHH`**:S*B%G8*H&22<`4D<B2QK)&=R,,J?44`/
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHKC/''BK^RK8Z?92?Z;*/G8?\LE/]3V_/TK*M6C1@YR-\/AYXBHJ<-V
M0Z]\0X]-U&2SL;9+GR^'D+X&[N!ZXKGKWXIZI#`T@MK.-1T^5B?YURMI:SWM
MU';6T;232-A5'4US6L_:(]3GM+A#&]O(T90]B#@UX4,5B:TF[V7]:'UU/+,'
M32@XIR\_S/H;P1X@?Q+X8@OY]GVC>\<P08`8'C_QTJ?QK4UNZELM`U&[@(6:
M"UED0D9`95)'\J\H^"^K^5J%_H[M\LR">('^\O##\01_WS7J/B;_`)%36/\`
MKQF_]`->[AY<\$SY;,:'L,1**VW7S/GSX7:C>:K\7-/O+^YDN;F03%Y)&R3^
MZ?\`3VKZ8KY&\!^(+7PMXOL]8O(II8(%D#)"`6.Y&48R0.I'>O3;G]H)!,1:
M^'6:+LTMWM8_@%./SKMJP<I:(\BC4C&/O,]LHKA_!'Q.TKQI,UFD,EEJ"KO^
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
G`<G<6.NZIM6Y5%13D`E0!^7-=+9PM;6,$#D%HXPI(Z<"IZ*`/__9
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
        <int nm="BreakPoint" vl="1731" />
        <int nm="BreakPoint" vl="877" />
        <int nm="BreakPoint" vl="1225" />
        <int nm="BreakPoint" vl="874" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-22741 supports painter rules of corresponding folder, appends inverse erection sequence if specified" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="10/1/2024 1:22:36 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13027 sequence numbers left padded to support sorting, dispay bugfix" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="28" />
      <str nm="DATE" vl="11/15/2021 12:02:56 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End