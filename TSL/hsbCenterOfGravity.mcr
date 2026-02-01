#Version 8
#BeginDescription
#Versions
Version 5.32 04/11/2025 HSB-24576: For tsls with no realbody, try to get the realbody from iso direction; include HSB_E-Insulation when getting element tsls , Author Marsel Nakuci
Version 5.31 15.10.2025 HSB-23906 bugfix if material not set with one component defined

Version 5.30 10.04.2025 HSB-22284 debug message removed
Version 5.29 17.03.2025 HSB-22284 MetalPartCollectionEntities of elements added, style based data considered for COG calculation
Version 5.28 04.02.2025 HSB-23445: Make sure nonzero value when dividing
Version 5.27 20.11.2024 HSB-23011: Cleanup the custom calculation
Version 5.26 07/06/2024 HSB-20484: When using the density from mapx, it is in kg/unit3. No transformation in "mm" needed
Version 5.25 27/05/2024 HSB-20484: Consider mapX densities in "OpeningCOG" 
Version 5.24 08.04.2024 HSB-21836: Consider element when in viewport in layout 
Version 5.23 22.02.2024 HSB-21284 dynamic update of genbeam submap if not element related
Version 5.22 19.02.2024 HSB-21284 dependency og linked genbeams added
Version 5.21 01.02.2024 HSB-21286: only update painter catalog when property "painter" is changed 

Version 5.20 30.01.2024 HSB-21242 performance improved when attached to elements, automatic rereading on missing density data disabled
Version 5.19 05/10/2023 Make sure mapobject is only updated when it is different, otherwise the dependencyondictobject causes lot of retriggers
Version 5.18 11.09.2023 HSB-20024: Write weight in mapX of genbeams on _bOnviewportsSetInLayout 
Version 5.17 17.07.2023 HSB-19480: from attached tsls include only hsbElementInsulation; We dont need other volumetric tsls that might consume the element 
Version 5.16 13.07.2023 HSB-19480: For element, Include attached tsls, not only those in the group
Version 5.15 22.06.2023 HSB-19249 resolving of text fixed
Version 5.14 12.05.2023 HSB-18650  all displays published for share and make
Version 5.13 10.05.2023 HSB-18650 standard display published for share and make
Version 5.12 17.03.2023 HSB-18360: Fo rpanels go in lumps only if component realbody not OK 
Version 5.11 10.01.2023 HSB-16692: Add painter filter

requires 'hsbMaterialTable.dll' to be in one of the content dll sub folders
density definition dialog included, dialog can be callled by entry 'ShowDensityDialog' or double click on an instance
the format of the material databank has been changed. An optional old file structure will be converted into the new structure. 
Context support to add or remove materials

This tsl calculates the center of gravity of a selection of solids and displays it.























#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 5
#MinorVersion 32
#KeyWords Center of gravity; COG;Schwerpunkt;Centro de gravedad
#BeginContents
//region History

// #Versions
// 5.32 04/11/2025 HSB-24576: For tsls with no realbody, try to get the realbody from iso direction; include HSB_E-Insulation when getting element tsls , Author Marsel Nakuci
// 5.31 15.10.2025 HSB-23906 bugfix if material not set with one component defined Thorsten Huck
// 5.30 10.04.2025 HSB-22284 debug message removed , Author Thorsten Huck
// 5.29 17.03.2025 HSB-22284 MetalPartCollectionEntities of elements added, style based data considered for COG calculation , Author Thorsten Huck
// 5.28 04.02.2025 HSB-23445: Make sure nonzero value when dividing , Author: Marsel Nakuci
// 5.27 20.11.2024 HSB-23011: Cleanup the calculation for Baufritz , Author Marsel Nakuci
// 5.26 07/06/2024 HSB-20484: When using the density from mapx, it is in kg/unit3. No transformation in "mm" needed Marsel Nakuci
// 5.25 27/05/2024 HSB-20484: Consider mapX densities in "OpeningCOG" Marsel Nakuci
// 5.24 08.04.2024 HSB-21836: Consider element when in viewport in layout Author: Marsel Nakuci
// 5.23 22.02.2024 HSB-21284 dynamic update of genbeam submap if not element related , Author Thorsten Huck
// 5.22 19.02.2024 HSB-21284 dependency og linked genbeams added  , Author Thorsten Huck
// 5.21 01.02.2024 HSB-21286: only update painter catalog when property "painter" is changed Author: Marsel Nakuci
// 5.20 30.01.2024 HSB-21242 performance improved when attached to elements, automatic rereading on missing density data disabled , Author Thorsten Huck
//5.19 05/10/2023 Make sure mapobject is only updated when it is different, otherwise the dependencyondictobject causes lot of retriggers Author: Robert Pol
// 5.18 11.09.2023 HSB-20024: Write weight in mapX of genbeams on _bOnviewportsSetInLayout Author: Marsel Nakuci
// 5.17 17.07.2023 HSB-19480: from attached tsls include only hsbElementInsulation; We dont need other volumetric tsls that might consume the element Author: Marsel Nakuci
// 5.16 13.07.2023 HSB-19480: For element, Include attached tsls, not only those in the group Author: Marsel Nakuci
// 5.15 22.06.2023 HSB-19249 resolving of text fixed , Author Thorsten Huck
// 5.14 12.05.2023 HSB-18650  all displays published for share and make , Author Thorsten Huck
// 5.13 10.05.2023 HSB-18650 standard display published for share and make , Author Thorsten Huck
// 5.12 17.03.2023 HSB-18360: Fo rpanels go in lumps only if component realbody not OK Author: Marsel Nakuci
// 5.11 10.01.2023 HSB-16692: Add painter filter Author: Marsel Nakuci
// 5.10 01.12.2022 14257655: write "RL" instead of "Rl" to avoid confusion between capital "i" or lowercase "L" Author: Marsel Nakuci
// 5.9 31.10.2022 HSB-9869: Distinguish between composite and non-composite beams Author: Marsel Nakuci
// 5.8 19.10.2022 HSB-16848: Remove OPM name "-Insert"; use hidden variables Author: Marsel Nakuci
// 5.7 30.09.2022 HSB-15062: Consider TSLs that contain mapX "CenterOfGravity" and provide "Center" and "Weight" Author: Marsel Nakuci
// Version 5.6 13.10.2021 HSB-13481: ignore only entities with 0 volume that are not opening assembly. opening assemblies have a volume from their subcomponents Author: Marsel Nakuci
// Version 5.5 13.10.2021 HSB-13481: when found use BF-OpeningCenterOfGravity for calculation of openings Author: Marsel Nakuci
// 5.4 12.10.2021 HSB-13481: Call TSL BF-OpeningCenterOfGravity if found in company directory for calculation of assembly openings: Marsel Nakuci
// 5.3 10.06.2021 HSB-10308 using new dll location , Author Thorsten Huck
// Version 5.2 25.05.2021 add description how to control decimal points Author: Marsel Nakuci
// Version 5.1 27.04.2021 HSB-9367: default material in XML is always saved in english as DEFAULT Author: Marsel Nakuci
///<version value="5.0" date=06nov2020" author="thorsten.huck@hsbcad.com"> HSB-9621 COG used in shopdrawings publishes protection area to multipage to avoid overlapping tagging. </version>
///<version value="4.9" date=15jul2020" author="thorsten.huck@hsbcad.com"> HSB-7113 the property 'Display Weight' has been changed to 'Format' which specifies the format to be resolved.  Legacy instances will automatically convert to '@(Weight) kg' if <Yes> had been used. </version>
///<version value="4.8" date=09jul2020" author="thorsten.huck@hsbcad.com"> HSB-8246 individual component calculation of panels skipped if all components have the same material </version>
///<version value="4.7" date=15apr2020" author="thorsten.huck@hsbcad.com"> HSB-7007, HSB-7085 using ptCentreOfGravity for any genbeam type to bugfix COG far away from _PtW items </version>
///<version value="4.6" date=15nov19" author="thorsten.huck@hsbcad.com"> HSB-5938 bugfix coordinate dimensions in shopdrawing </version>
///<version value="4.5" date=11nov19" author="thorsten.huck@hsbcad.com"> HSB-5810 bugfix for panels which are based on multiple components and alignment fix if added to shopdrawings </version>
///<version value="4.4" date=23jul19" author="thorsten.huck@hsbcad.com"> HSB-5406 bugfix storing density table in mapObject on mapIO call  </version>
///<version value="4.3" date=13may19" author="thorsten.huck@hsbcad.com"> HSB-4985 insert further improved, requires in layout improved, requires versions 21.4.42, 22.0.77, 23.0.3 or higher </version>
///<version value="4.2" date=29apr19" author="thorsten.huck@hsbcad.com"> insert in layout improved, supports 3DSolids (no property material attached assumes steel as default material) </version>
///<version value="4.1" date=04apr19" author="thorsten.huck@hsbcad.com"> HSBCAD-4814: properties restructured, display of weight is now a property, weight >=10 kg is rounded, material search deactivated for panels where the style name and the material name matches for the first 6 characters (custom request) </version>
///<version value="4.0" date=03apr19" author="thorsten.huck@hsbcad.com"> HSBCAD-4814: add shopdraw support and coordinate dimension </version>
///<version value="3.9" date=20dec18" author="thorsten.huck@hsbcad.com"> HSBCAD-335: assignning of extended submapx fixed on element </version>
///<version value="3.8" date=08Aug18" author="thorsten.huck@hsbcad.com"> bugfix property dialog </version>
///<version value="3.7" date=04Jul18" author="thorsten.huck@hsbcad.com"> when inserted in individual mode a subMapX 'ExtendedProperties' is written, which contains the values of the COG and the calculated weight </version>
///<version value="3.6" date=04Jul18" author="thorsten.huck@hsbcad.com"> new property on insert allows selection of insertion mode. In paperspace the insertion mode is based on a viewport </version>
///<version value="3.5" date=25jan18" author="thorsten.huck@hsbcad.com"> Sequence set to -1, ptCen of resident entities published </version>
///<version  value="3.4" date="19dec17" author="thorsten.huck@hsbcad.com"> entities with no material assigned will use default material and not trigger the automatic reloading of the density database </version>
///<version  value="3.3" date="18dec17" author="thorsten.huck@hsbcad.com"> text display enhanced for non element references </version>
///<version  value="3.2" date="15dec17" author="thorsten.huck@hsbcad.com"> material update on mapIO if not stored in map object </version>
///<version  value="3.1" date="12dec17" author="thorsten.huck@hsbcad.com"> new options to display the weight in a viewport. Automatic update from current materials.xml file if no materials were cached in map object </version>
///<version  value="3.0" date="28sep17" author="thorsten.huck@hsbcad.com"> bugfix insert in viewport mode with no current element </version>
///<version  value="2.9" date="28sep17" author="thorsten.huck@hsbcad.com"> bugfix text display in viewport mode </version>
///<version  value="2.8" date="18aug17" author="thorsten.huck@hsbcad.com"> genbeams dependencies added if based on an element </version>
///<version  value="2.7" date="02aug17" author="thorsten.huck@hsbcad.com"> paperspace behaviour enhanced </version>
///<version  value="2.6" date="24apr17" author="thorsten.huck@hsbcad.com"> bugfix for nested massgroup and metalPartCollectionEnt dependencies </version>
///<version  value="2.5" date="30mar17" author="thorsten.huck@hsbcad.com"> display of weight now also supported with custmo block display </version>
///<version  value="2.4" date="28july16" author="thorsten.huck@hsbcad.com"> Panel: resolving all individual components if defined </version>
///<version  value="2.3" date="11nov15" author="thorsten.huck@hsbcad.com"> Panel: if no material is defined for a panel the material of the index axis component is taken from the panel style. This is only an approximation  as multiple components materials may be in use </version>
///<version  value="2.2" date="07sep15" author="thorsten.huck@hsbcad.com"> the weight of a potential element is exported with mapX content 'ExtendedProperties'  </version>
///<version  value="2.1" date="27jan15" author="th@hsbCAD.de"> 'hsbMaterialTable.dll' is now language independent and located in the general content folder of hsbCAD </version>
///<version  value="2.0" date="23oct14" author="th@hsbCAD.de"> requires 'hsbMaterialTable.dll' to be in one of the content dll sub folders, density definition dialog included, dialog can be callled by entry 'ShowDensityDialog' </version>
///<version  value="1.8" date="21oct14" author="th@hsbCAD.de"> the format of the material databank has been changed. An optional old file structure will be converted into the new structure. Context support to add or remove materials</version>
///<version  value="1.7" date="15jul14" author="th@hsbCAD.de"> tsl instances will query their material, if no material is defined 'Steel' is used as default, but can be overwritten by any propertyset containing a property 'Material' (translated) </version>
///<version  value="1.6" date="04jun14" author="th@hsbCAD.de"> bugfix, now unit independent </version>
///<version  value="1.5" date="12dec13" author="th@hsbCAD.de"> weight will display below gravity symbol</version>
///<version  value="1.4" date="05nov12" author="th@hsbCAD.de"> bugfix returning weight</version>
///<version  value="1.3" date="11jul12" author="th@hsbCAD.de"> debug log disabled, returns also the weight</version>
///<version  value="1.2" date="10jul12" author="th@hsbCAD.de"> mass groups, metal part collections added. new custom command to add/remove entities</version>
///<version  value="1.1" date="10jul12" author="th@hsbCAD.de"> display enhanced, dummies ignored</version>
///<version  value="1.0" date="03jul12" author="th@hsbCAD.de"> initial</version>






/// <summary Lang=de>
/// Dieses TSL berechnet den Schwerpunkt von Volumenkörpern und stellt diesen dar. 
/// Die Darstellung erfolgt ansichtsabhängig als einfaches Symbol. Beinhaltet die
/// Zeichnung einen Block mit dem gleichen Namen wie das TSL, so wird dieser zur 
/// Darstellung verwendet. 
/// Die Datei <hsbCompany>Abbund\materials.xml muss vorhanden sein und wird beim
/// ersten Start erzeugt, sollte sie nicht existieren. Mittels des Katalogeintrages 
/// 'ShowDensityDialog' oder durch Doppelklick (alt. Kontextbefehl) einer Instanz 
/// wird der Dialog zur Bearbeitung der Dichten angezeigt.
/// </summary>

/// <summary Lang=en>
/// This tsl calculates the center of gravity of a selection of solids and displays it.
/// The display is view dependent a simple line work. If a block with the same name
/// as the script name is found in the dwg, the tsl will draw this as display
/// The file <hsbCompany>Abbund\materials.xml must exist. One can edit the density definitions
/// by calling the tsl with the catalog entry 'ShowDensityDialog' or by doubleclick/context menu of an instance
/// </summary>

/// <insert Lang=de>
/// Dieses TSL hat drei verschiedene Einfügemechanismen und erfordert eine gesonderte Datei zur Definition der Dichten.
/// 1. beinhaltet der Auswahlsatz Elemente, so werden alle Stäbe, Platten und Panele, sowie TSL's der Elemente berechnet. 
///    Optional können auch Fenster und Türen ausgewertet werden.
/// 2. beinhaltet der Auswahlsatz keine Elemente, so wird der Schwerpunkt von allen gewählten Volumenkörper berechnet. 
/// 3. nach einer optionalen Leereingabe der Objektwahl kann ein hsbAnsichtsfenster gewählt werden um den Schwerpunkt im
///    Elementlayout darzustellen
/// </insert>

/// <insert Lang=en>
/// This TSL has 3 different methods to be inserted
/// 1. if the selection set contains elements it will calculate the center 
/// of gravity from all linked beams, sheets, panels and tsl's
/// 2. if the selection set contains no elements it will calculate the
///    center of gravity from all selected solids.
/// 3. if the selection of solids is skipped with <Enter> one can select an 
///    hsbViewport to display it in layout
/// </insert>

/// <remark Lang=de>
/// Tsl's, metalpartCollection Entities, MassGroups and Mass Elements will obtain 'Steel' as default material
/// The programm will search for a property with name 'Material' to overwrite this (first appearance is taken)
/// </remark>

/// <remark Lang=de>
/// Die Berechnung basiert auf dem Volumen und dem Material der gewählten 
/// Bauteile. Wird keine Materialentsprechung in der Dichtetabelle
/// gefunden, so wird eine Dichte von 500kg/m³ angenommen. 
/// Für Türen und Fenster werden die Materialien ‚Window' und ‚Door'	
/// verwendet.
/// Die Dichte wird in der Einheit kg/m³ definiert.
/// </remark>


/// <remark Lang=en>
/// The calculation is based on the material name and the volume of the solid. 
/// If no matching material can be found in the density table a density of 500kg/m3
/// will be used. Windows and doors will use the material ‚window' and 'door'
/// Densities need to be defined in kg/m³
/// </remark>


/// <remark Lang=en>
/// The tsl can also be called as mapIO function from other tsl's and will
/// return the point of gravity 
/// snippet
///		Map mapIO;
///		Map mapEntities;
///		for (int e=0;e<ents.length();e++)
///			mapEntities.appendEntity("Entity", ents[e]);
///		mapIO.setMap("Entity[]",mapEntities);
///		TslInst().callMapIO(scriptName(), mapIO);
///		ptCen = mapIO.getPoint3d("ptCen");// returning the center of gravity
///		double dWeight = mapIO.getDouble("Weight");// returning the weight
/// </remark>

/// History


//reportMessage("\nexecuting " + scriptName());
//End History//endregion 
	
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
	String sCatalogPainter=scriptName()+"LastUsedPainterCatalog"; // reserved to save props and painter stream from the last recalced TSL
	String sProjectSpecial=projectSpecial();
	sProjectSpecial.makeUpper();
	int bBaufritz=sProjectSpecial=="BAUFRITZ";
	
	String kMetalStyleData = "MetalStyleData"; // submapX key which is used to store style specific data of metalPartEnts
//end constants//endregion
	
//region Functions FU	
//region Function GetComponentMaterials
	// returns a list of materails stored in the components of the style
	String[] GetComponentMaterials(SipStyle style, int num)
	{ 
		String materials[0];

		for(int i=0;i<num ;i++)
		{ 
			SipComponent c = style.sipComponentAt(i);
			String mat = c.material().makeUpper();
			materials.append(mat);
		}
		
		return materials;
	}//endregion	
	
//endregion	
	
	
//region Properties
	int nTick = getTickCount();
	String sDensityDialogKey = "ShowDensityDialog";
	
	category = T("|Display|");
	PropDouble dSize(0, U(120), T("|Symbol Size|"));
	dSize.setCategory(category);
	dSize.setDescription(T("|Specifies the symbol size (Paperspace = 0 -> do not display)|"));
	
	PropInt nColor(nIntIndex++, 1, T("|Color|"));
	nColor.setCategory(category);
	nColor.setDescription(T("|The color of symbol and text.|"));
	
	String sTransparencyName=T("|Transparency|");	
	PropInt nTransparency(nIntIndex++, 70, sTransparencyName);	
	nTransparency.setDescription(T("|Enter transparency value, -1=byLayer, -2=byBlock. Enter value in range [-2, 100]|"));
	nTransparency.setCategory(category);
	
	String sStyles[] ={T("|Rhomb|"),T("|Circle|"),T("|Rhomb|")+T(" + |Coordinates|"),T("|Circle|")+T(" + |Coordinates|")};
	String sStyleName=T("|Style|");	
	PropString sStyle(2, sStyles, sStyleName,0);	
	sStyle.setDescription(T("|Defines the Style|"));
	sStyle.setCategory(category);
	if (sStyles.find(sStyle) < 0)sStyle.set(sStyles[0]);
	
	category = T("|Text|");
	String sDimStyleName=T("|DimStyle|");	
	PropString sDimStyle(1, _DimStyles.sorted(), sDimStyleName);	
	sDimStyle.setDescription(T("|Defines the Dimstyle of the weight and its precision.|"));
	sDimStyle.setCategory(category);
	
	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(1, U(80), sTextHeightName);	
	dTextHeight.setDescription(T("|Defines the Text Height|") + " " + T("|0 = byDimstyle|"));
	dTextHeight.setCategory(category);
	
	String sFormatName=T("|Format|");	
	PropString sFormat(3, "@(Weight) kg", sFormatName,1);	
	sFormat.setDescription(T("|Specifies the format expression.| ") + T(" |'@(Weight) kg' will display the weight with the appendix kg.| ")
		+T(" |'@(Weight:RL0) kg' will supress the decimal points, '@(Weight:RL1) kg' will show one decimal point.| "));
	sFormat.setCategory(category);
	
	PropString sIncludeWindowDoor(0, sNoYes, T("|Include Windows + Doors|"));
	sIncludeWindowDoor.setDescription(T("|Defines whether windows and doors should be calculated by an average weight.|"));
	
// HSB-16848
	category = T("|General|");
	String sModeName = T("|Mode|");
	String sModes[] ={ T("|Assembly|"), T("|Single instance|")};//, T("|Viewport|")};
	PropString sMode(5, sModes, sModeName);
	sMode.setDescription(T("|Defines the mode of insertion.| '") + sModes[0]+ T("' |calculates the POG per selected instance, while| '") + sModes[1] +T(" |calculates the POG of the selection set as one assembly.|"));
	sMode.setCategory(category);
	
// HSB-16692: Add Painter 
	category=T("|Filter|");
	String sRules[0];
	String sPainters[]=PainterDefinition().getAllEntryNames().sorted();
	String sPainterCollection="hsbCenterOfGravity";
	
	for (int i=sPainters.length()-1; i>=0 ; i--) 
		if (sPainters[i].length()<1)
			sPainters.removeAt(i);
	
	int bPainterCollectionFound;
	for (int i=0;i<sPainters.length();i++) 
	{ 
		if (sPainters[0].find(sPainterCollection,0,false)==0)
		{ 
			bPainterCollectionFound = true;
			break;
		}
	}
	if(bPainterCollectionFound)
	for (int i=sPainters.length()-1; i>=0 ; i--) 
	{ 
		// keep only those of collection if at least one found
		String sPainter = sPainters[i];
		if (sPainter.find(sPainterCollection,0,false)<0)
		{ 
			sPainters.removeAt(i);
			continue;
		}
	}//next i
	
	String sPainterStreamName=T("|PainterStream|");	
	PropString sPainterStream(4, "", sPainterStreamName);	
	sPainterStream.setDescription(T("|Defines the PainterStream|"));
	sPainterStream.setCategory(category);
	sPainterStream.setReadOnly(bDebug?0:_kHidden);
	
	// on insert read catalogs to copy / create painters based on catalog entries
	if (_bOnInsert || _bOnElementConstructed || _bOnDbCreated)
	{
		// HSB-15906: collect streams	
		String streams[0];
		String sScriptOpmName=bDebug?"hsbCenterOfGravity":scriptName();
		String entries[]=TslInst().getListOfCatalogNames(sScriptOpmName);
		int iStreamIndices[]={4};//index 1 of the stream property
		for (int i=0;i<entries.length();i++)
		{
			String& entry=entries[i];
			Map map=TslInst().mapWithPropValuesFromCatalog(sScriptOpmName, entry);
			Map mapProp=map.getMap("PropString[]");
			
			for (int j=0; j<mapProp.length(); j++)
			{
				Map m=mapProp.getMap(j);
				int index=m.getInt("nIndex");
				String stream=m.getString("strValue");
				if (iStreamIndices.find(index) >- 1 && streams.findNoCase(stream,- 1) < 0)
				{
					streams.append(stream);
				}
			}//next j
		}//next i
		
		for (int i=0;i<streams.length(); i++)
		{
			String& stream=streams[i];
			String _painters[0];
			_painters=sPainters;
			if (stream.length() > 0)
			{
				// get painter definition from property string	
				Map m;
				m.setDxContent(stream,true);
				String name=m.getString("Name");
				String type=m.getString("Type").makeUpper();
				String filter=m.getString("Filter");
				String format=m.getString("Format");
				// create definition if not present	
				//				if (m.hasString("Name") && m.hasString("Type") && name.find(sPainterCollection,0,false)>-1 &&
				//					_painters.findNoCase(name,-1)<0)
				if (m.hasString("Name") && m.hasString("Type") && _painters.findNoCase(name,- 1) < 0)
				{
					PainterDefinition pd(name);
					if (!pd.bIsValid())
					{
						pd.dbCreate();
						pd.setType(type);
						pd.setFilter(filter);
						pd.setFormat(format);
						
						if (pd.bIsValid())
						{
							sPainters.append(name);
						}
					}
				}
			}
		}
	}
	
	sRules=sPainters;
	String sDisabled=T("|<Disabled>|");
	sRules.insertAt(0,sDisabled);
	
	String sRuleName=T("|Painter Rule|");	
	PropString sRule(6, sRules, sRuleName);	
	sRule.setDescription(T("|Defines the painter definition to filter entities.|"));
	sRule.setCategory(category);
	
	String sDictionary="tslDict";
	String sEntry ="Density";
	String sPathOld=_kPathHsbCompany+"\\Abbund\\hsbGenBeamDensityConfig.xml";
	String sPathNew=_kPathHsbCompany+"\\Abbund\\Materials.xml";
	String sMaterialName=T("|Material|");
	
	String strAssemblyPath = _kPathHsbInstall + "\\Utilities\\hsbMaterialDensityTable\\hsbMaterialDensityTable.dll";
	String strType = "hsbCad.Tsl.Insertion.MapTransaction";
	String strFunction = "LoadMaterialTable";
	
	String sFindDll=findFile(strAssemblyPath);
	if (sFindDll=="") 
	{ 
		// old location
		strAssemblyPath = _kPathHsbInstall + "\\Content\\General\\MaterialTable\\hsbMaterialTable.dll";
		strType = "hsbSoft.Tsl.Insertion.MapTransaction";
		strFunction = "LoadMaterialTable";
	}
//End Properties//endregion
	
// declare the mapObject	
	MapObject mo(sDictionary ,sEntry); // will do lookup automatically
	
/// flag if density dialog should show
	int bShowDensityDialog = _kExecuteKey==sDensityDialogKey;
	
// previous to version 1.7 the file hsbGenBeamDensityConfig.xml was used to read the denisties
// newer versions refer to a slightly different structure 
	String sOldFileName = findFile(sPathOld);
	String sNewFileName = findFile(sPathNew);
	if (sOldFileName.length()>0 && sNewFileName.length()<1 && !bShowDensityDialog)
	{
		Map mapOld;
		mapOld.readFromXmlFile(sPathOld);
		
	// write to new structure
		Map mapMaterial, mapMaterials;
		String sMaterials[0];
		for (int i=0;i<mapOld.length();i++)
		{
			String sMaterial = mapOld.keyAt(i);
			double dDensity = mapOld.getDouble(i);
			if (sMaterials.find(sMaterial)<0 && dDensity >0)
			{
				mapMaterial.setString("Material", sMaterial);
				mapMaterial.setDouble("Density", dDensity, _kNoUnit);
				mapMaterials.appendMap("Material", mapMaterial);
			}
		}
		Map mapOut;
		mapOut.setMap("Material[]", mapMaterials);
		mapOut.writeToXmlFile(sPathNew);
		
	// replace an existing mapObject
		if (mo.bIsValid()) 
			mo.setMap(mapOut);	
		
	// tell the user		
		reportMessage("\n**********" + scriptName() + "**********\n" + 
		T("|The density definition file|") +"\n   " + sPathOld +  TN("|has been converted to a new format.|") + 
		"\n   " + sPathNew + TN("|You may delete the old definition from your file system.|"));
		reportMessage("\n*************************************");			
	}
// on insert and no existing material density definitions show density mapping dialog	
	else if ((sNewFileName.length()<1 || bShowDensityDialog) && _bOnInsert)
	{
		if (sNewFileName.length()<1)
		{
		// write an initial version with some default materials
			String sPresetMaterials[] = {T("|Default|"), "Aluminium", "BSH", "Edelstahl", "GKB", "Kork", "KVH","MDF", "OSB", T("|Steel|")};
			double dPresetDensities[] = {500,            2500,        500,    7800,        950,   110,    500,  900,   800,    7700};
			Map mapMaterials;
			for (int i=0;i<sPresetMaterials.length();i++)
			{
				Map mapMaterial;
				mapMaterial.setString("Material", sPresetMaterials[i]);
				mapMaterial.setDouble("Density", dPresetDensities[i],_kNoUnit);
				mapMaterials.appendMap("Material", mapMaterial);
			}		
			Map mapOut;
			mapOut.setMap("MATERIAL[]", mapMaterials);
			mapOut.writeToXmlFile(sPathNew);
		}
		
	// call the dialog	
		Map mapIn;
		mapIn.setString("Path", sPathNew);
		Map mapOut = callDotNetFunction2(strAssemblyPath, strType, strFunction, mapIn);	
		
		if (bShowDensityDialog)
		{
			eraseInstance();
			return;
		}		
	}
	
// create a mapObject if it does not exist
	if (!mo.bIsValid()) 
	{
	// read data from xml
	// check if xml file exists
		if (findFile(sPathNew).length()<4)
		{
			reportMessage("\n**********" + scriptName() + "**********\n" + 
			T("|The density definition file|") +"\n" + sPathNew + "\n" + T("|could not be found.|") + "\n" + T("|Tool will be deleted.|"));
			reportMessage("\n*************************************");
			eraseInstance();
			return;
		}
	// read the file
		Map map;
		map.readFromXmlFile(sPathNew);
		mo.dbCreate(map);
	}
	
// on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) {eraseInstance(); return;}

	// get current space
		int bInLayoutTab=Viewport().inLayoutTab();
		int bInPaperSpace=Viewport().inPaperSpace();
		
	// find out if we are block space and have some shopdraw viewports
		Entity viewEnts[0];
		if (!bInLayoutTab)viewEnts=Group().collectEntities(true, ShopDrawView(), _kMySpace);
		
		int nMode;
		if (viewEnts.length()>0)
		{
			_Entity.append(getShopDrawView());
			_Pt0=getPoint();
			return;
		}
		
	// prompt selection			
		Entity ents[0];		
		if (bInPaperSpace)
		{
			Viewport vp=getViewport(T("|Select a viewport|")); // select viewport
	  		_Viewport.append(vp);
	  		_Pt0=getPoint(T("|Pick a point (outside of paperspace no text should be displayed)|"));
			return;
		}
		else
		{
			showDialog();
			nMode = sModes.find(sMode, 0);
			
			PrEntity ssE(T("|Select entities|"), Entity());
			if (ssE.go())
				ents = ssE.set();
		}
		
	// save stream of painter
		int nPainter=sPainters.findNoCase(sRule,-1);
		{ 
			PainterDefinition painter;
			if (nPainter>-1)
			{
				painter=PainterDefinition(sPainters[nPainter]);
			}
			if (painter.bIsValid())
			{ 
				Map m;
				m.setString("Name", painter.name());
				m.setString("Type",painter.type());
				m.setString("Filter",painter.filter());
				m.setString("Format",painter.format());
				sPainterStream.set(m.getDxContent(true));
			}
			_ThisInst.setCatalogFromPropValues(sCatalogPainter);
		}
		
	// analyse the selection set for elements or loose entities
		Element el[0];
		Entity entsLoose[0];
		for (int e=0;e<ents.length();e++)
		{
			if (!ents[e].bIsValid()){ continue;}
		// collect any element
			if (ents[e].bIsKindOf(ElementWall()) || ents[e].bIsKindOf(ElementRoof()))
				el.append((Element)ents[e]);
		// only do this as long as no elements were collected and ignore non solids
			else if (el.length()<1 && ents[e].realBody().volume()>pow(dEps,3))
				entsLoose.append(ents[e]);
		}
		
	// create TSL
		TslInst tslNew;
		GenBeam gbsTsl[]={}; Entity entsTsl[]={}; Point3d ptsTsl[]={};
		int nProps[]={nColor, nTransparency};
		double dProps[]={dSize, dTextHeight};
		String sProps[]={sIncludeWindowDoor,sDimStyle,sStyle,sFormat,sPainterStream,sMode,sRule};
		Map mapTsl;
		
		mapTsl.setInt("mode", nMode);
		
	// insert element based or to the selection of loose entities
		if (el.length()>0)
		{
			for (int e=0;e<el.length();e++)
			{
				entsTsl.setLength(0);
				entsTsl.append(el[e]);
				tslNew.dbCreate(scriptName(),el[e].vecX(),el[e].vecY(),gbsTsl,entsTsl,
					ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);
			}// next e
		}
	// assembly
		else if (nMode==0)
		{		
			entsTsl=entsLoose;
			tslNew.dbCreate(scriptName(),_XU,_YU,gbsTsl,entsTsl,
				ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);
		}
	// individual
		else if (nMode==1)
		{	
			for (int i=0;i<entsLoose.length();i++) 
			{ 
				entsTsl.setLength(0);
				entsTsl.append(entsLoose[i]);
				tslNew.dbCreate(scriptName(),_XU,_YU,gbsTsl,entsTsl,
					ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);
			}//next i
		}
	// erase the calling instance
		eraseInstance();
		return;
	}
	
// make sure the style is protected, and that this Tsl is updated when the style changes.
	setDependencyOnDictObject(mo);

// HSB-16848:
	sMode.setReadOnly(_kHidden);
// get the density records from mo
	Map mapMaterials = mo.map().getMap("Material[]");
	double dDefaultDensity = 500;
	
// load from file
	String sMsg = scriptName() + ": " + T("|could not find a valid density table.|");
	
	Map m;
	m.readFromXmlFile(sNewFileName);
	Map fileMapMaterials = m.getMap("Material[]");
	int mapMaterialsAreEqual = true;
	if (fileMapMaterials.length() != mapMaterials.length())
	{
		mapMaterialsAreEqual = false;
	}
	
	if (mapMaterialsAreEqual)
	{
		for (int m = 0;m<mapMaterials.length();m++)
		{
			if (mapMaterials.keyAt(m) != fileMapMaterials.keyAt(m))
			{
				mapMaterialsAreEqual = false;
				break;
			}
			
			Map materialMap = mapMaterials.getMap(m);
			Map fileMaterialMap = fileMapMaterials.getMap(m);
			if (fileMaterialMap.length() != fileMaterialMap.length())
			{
				mapMaterialsAreEqual = false;
				break;
			}
			for (int mm = 0;mm<materialMap.length();mm++)
			{
				if (materialMap.keyAt(mm) != fileMaterialMap.keyAt(mm))
				{
					mapMaterialsAreEqual = false;
					break;
				}
				String material;
				String fileMaterial;
				if (materialMap.hasString(mm))
				{
					material = materialMap.getString(mm);
				}

				if (fileMaterialMap.hasString(mm))
				{
					fileMaterial = fileMaterialMap.getString(mm);
				}

				
				if (material != fileMaterial)
				{
					mapMaterialsAreEqual = false;
					break;								
				}
				
				String density;
				String fileDensity;
				if (materialMap.hasDouble(mm))
				{
					density = materialMap.getDouble(mm);
				}

				if (fileMaterialMap.hasDouble(mm))
				{
					fileDensity = fileMaterialMap.getDouble(mm);
				}
				
				if (density != fileDensity)
				{
					mapMaterialsAreEqual = false;
					break;								
				}
			}
		}
	}
	
	// only change map if not equal, setdependencyondictobject was causing a lot of recalcs
	if (!mapMaterialsAreEqual)
	{
		mapMaterials = m.getMap("Material[]");
		if (mapMaterials.length() > 0 && mo.bIsValid())
		{
			reportNotice(sMsg);
			mo.setMap(m);
		}
	}
// load on IO	
	if (_bOnMapIO && mapMaterials.length()<1 && sNewFileName.length()>0 && mo.bIsValid())
	{ 
		Map m;
		m.readFromXmlFile(sNewFileName);
		mapMaterials = m.getMap("Material[]");
		if (mapMaterials.length()>0)
		{
			mo.setMap(m);
			reportMessage("\n" + scriptName() + T(": |Densities automatically loaded from| ")  + sNewFileName);
		}	
	}
	if (mapMaterials.length()<1)
		reportMessage("\n" + scriptName() + ": " + T("|could not find a valid density table.|") + " " + sNewFileName + " " + T("|The calculation is now based on the default density of|") + " " + dDefaultDensity + " kg/m³");
	
// search a potential default material
	for (int m=0;m<mapMaterials.length();m++)
	{
		Map mapMaterial = mapMaterials.getMap(m);
		String s = mapMaterial.getString("Material");
		double d = mapMaterial.getDouble("Density");		
//		if (T("|Default|").makeUpper() == s.makeUpper() && d>0)
		// HSB-9367: in XML it is written always DEFAULT
		if ("DEFAULT" == s.makeUpper() && d>0)
		{
			dDefaultDensity =d;
			//reportMessage("\n	"+s + " accepted default density " + d);
			break;
		}
	}
	
	
	int bIncludeWindowDoor=sNoYes.find(sIncludeWindowDoor,0);
	String sMissingDensities[0];
	
// on MapIO
	if (_bOnMapIO)
	{
		int bDebugIO = _Map.getInt("debug");
		if (bDebugIO)reportMessage("\n" + scriptName() + " mapIO call...");
		Map mapIn=_Map;
		Map mapMissing;	
		int nNumEmptyMaterial;
		Map mapOut;
		_Map = mapOut; // clear _Map and initialize as invalidation map
		
		Entity ents[0];
		Map mapEntities = mapIn.getMap("Entity[]");
		//if (bDebugIO)	reportMessage("\n" + scriptName() + " has map length " + mapEntities .length());
		for (int e=0;e<mapEntities .length();e++)
		{
			Entity ent = mapEntities.getEntity(e);
			if (ent.bIsValid())
			{
				ents.append(ent);
				if (bDebugIO)reportMessage("\ntype: " + ent.typeDxfName() + " " + ent.handle());
			}
		}
		if (bDebugIO)reportMessage("\n" + scriptName() + " has ents " + ents.length());

	//// rebuild the collection if massgroups where found
		//Entity entsExtended[0];
		//for (int e=0;e<ents.length();e++)
		//{
			//if (ents[e].bIsKindOf(MassGroup()))
			//{
				//MassGroup mg =(MassGroup)ents[e];
				//entsExtended.append(mg.entity());
			//}
			//else
				//entsExtended.append(ents[e]);	
		//}
		//ents=entsExtended;	// reassign			
		//if (bDebugIO)reportMessage("\n" + scriptName() + " has ents2 " + ents.length());
	// HSB-15062
	// collect weights and COGs if found in a TSL mapX
		double dTslMapWeights[0];
		Point3d ptTslMapPoints[0];
	// collect two arrays of bodies and materials as well as collection entities and mass groups
		Body bodies[0], bodiesCE[0]; // for simplicity just store the real of the MetalPartCollectionEnt in this synch array of ces
		String materials[0];
		MassGroup massGroups[0]; 
		MetalPartCollectionEnt ces[0];
		Entity entRefs[0];
		Point3d ptCens[0];// version value="4.7" date=15nov19" author="thorsten.huck@hsbcad.com"> HSB-7007, HSB-7085 using ptCentreOfGravity for any genbeam type to bugfix COG far away from _PtW items
		// HSB-20484
		double dDensitiesMapx[0];
		double dWeightsMapx[0];// weights from mapx
		for (int e=0;e<ents.length();e++)
		{
			Entity ent = ents[e];
			if (!ent.bIsValid())continue;
			Body bdReal = ent.realBody();
			
			double dVolume = bdReal.volume();
			int nTslMapx;
		
		// HSB-15062
			if (ent.bIsKindOf(TslInst()))
			{ 
				TslInst tsl = (TslInst)ent;
				if(tsl.bIsValid())
				{ 
					if(tsl.subMapXKeys().findNoCase("CenterOfGravity",0)>-1)
					{ 
						Map mapCenter=tsl.subMapX("CenterOfGravity");
						if(mapCenter.hasDouble("Weight") && mapCenter.hasPoint3d("Center"))
						{ 
							nTslMapx=true;
						}
					}
					if(dVolume<pow(U(1),3))
					{ 
						// HSB-24576: try to get the body from iso direction
						Vector3d vecD=_XW+_YW+_ZW;vecD.normalize();
						bdReal = ent.realBody(vecD);
						dVolume = bdReal.volume();
					}
				}
			}
		// HSB-18360:
			if(dVolume<pow(dEps,3) && !ent.bIsKindOf(Opening()) && !nTslMapx && !ent.bIsKindOf(Sip())) 
			{
				continue;
			}
			if (bDebugIO)reportMessage("\n" + e + " " + ent.typeDxfName() + " has Volume: " +dVolume);

			String sMaterial;

		// SIP	
			if (ent.bIsKindOf(Sip()))
			{
				Sip sip = (Sip)ent;
				if (sip.bIsDummy())continue;
				Vector3d vecZ=sip.vecZ();
				SipStyle style(sip.style());
				int nNum = style.numSipComponents();
				sMaterial=sip.material();
				String sComponentMaterials[] = GetComponentMaterials(style, nNum);//HSB-23906
				
			// collect component materials
				int bByComponent = nNum > 1 && sMaterial=="";
				
				if (bByComponent)
				{ 
					if (bDebugIO)reportMessage("\nbByComponent n=" + nNum);
					if (sComponentMaterials.length()<2)
						bByComponent = false;
				}
				
			// use component material as default if no material set	
				if (sMaterial=="" && sComponentMaterials.length()>0)
				{
					sMaterial = sComponentMaterials.first();
				}
			
			// iterate through components if material is not set or multiple components are defined
				if (bByComponent)
				{
					
					if (bDebugIO && !bByComponent)reportMessage("\nbByComponent n=" + nNum + " no material set ");
					//PLine plEnvelope=sip.plEnvelope();
					for(int i=0;i<nNum ;i++)
					{
						// HSB-5810 use realBodyOfComonentAt instead of simplified solid and intersection
						SipComponent c = style.sipComponentAt(i);
						double d = c.dThickness();
						String mat = c.material();
						//Body bd(plEnvelope, vecZ*d,1);
						Body bd = sip.realBodyOfComponentAt(i);
						
						//int bOk=bd.intersectWith(bdReal);
						Body lumps[] = bd.decomposeIntoLumps();
						if(bd.volume()<pow(dEps,3))
						{ 
						// HSB-18360: go in lumps only if realbody of component not ok
							for(int l=0;l<lumps.length();l++)
							{
								reportMessage("\n" + lumps[l].volume()+ " lump vol in comp " + i + " thickness="+d);
								bodies.append(lumps[l]);
								materials.append(mat);
								entRefs.append(ent);
								ptCens.append(lumps[l].ptCen());//HSB-7007, HSB-7085 
								dDensitiesMapx.append(-1);
								dWeightsMapx.append(-1);
							}
						}
						else
						{ 
							if (bDebugIO)reportMessage("\nadding body to bodies");
							bodies.append(bd);
							materials.append(mat);
							entRefs.append(ent);
							ptCens.append(bd.ptCen());//HSB-7007, HSB-7085
							dDensitiesMapx.append(-1);
							dWeightsMapx.append(-1);
						}
						//plEnvelope.transformBy(vecZ * d);
					}// next i
				}
				else
				{
					bodies.append(bdReal);
					materials.append(sMaterial);
					entRefs.append(ent);
					ptCens.append(sip.ptCentreOfGravity());//HSB-7007, HSB-7085 
					dDensitiesMapx.append(-1);
					dWeightsMapx.append(-1);
				}	
				
			}// END IF SIP
			
		// BEAM	
			else if(ents[e].bIsKindOf(Beam()))
			{ 
			// HSB-9869: distinguish between non composite and composite beams
				Beam bm=(Beam)ents[e];
				if (bm.bIsDummy())continue;
				
				String sExtrProfile = bm.extrProfile();
				ExtrProfile extrProfile(sExtrProfile);
				String sExtrusionMats[] = extrProfile.componentMaterials();
				if(sExtrusionMats.length()==0)
				{ 
				// not composite
					bodies.append(bdReal);
					materials.append(bm.material());
					entRefs.append(ent);
					ptCens.append(bm.ptCentreOfGravity());
					dDensitiesMapx.append(-1);
					dWeightsMapx.append(-1);
					if (bDebugIO)reportMessage("\n" + e + " " + ent.typeDxfName() + " accepted material: " +bm.material());
				}
				else
				{ 
				// composite beam
					PlaneProfile componentProfiles[]=extrProfile.componentProfiles();
					CoordSys cs;
					cs.setToAlignCoordSys(_PtW,_XW,_YW,_ZW,
						bm.ptCen(),bm.vecY(),bm.vecZ(),bm.vecX());
						
					for (int iE=0;iE<sExtrusionMats.length();iE++) 
					{ 
						PlaneProfile pp = componentProfiles[iE];
						pp.transformBy(cs);
						PLine pls[] = pp.allRings(true, false);
						if(pls.length()>0)
						{ 
							Body bd(pls[0],bm.vecX()*bm.dL(),0);
//							bd.intersectWith(bdReal);
							bodies.append(bd);
							materials.append(sExtrusionMats[iE]);
							entRefs.append(bm);
							ptCens.append(bd.ptCen());
							dDensitiesMapx.append(-1);
							dWeightsMapx.append(-1);
							if (bDebugIO)reportMessage("\n" + e + " " + ent.typeDxfName() + " accepted material: " +sExtrusionMats[iE]);
						}
					}//next iE
				}
			}
		// BEAM / SHEET	
			else if (ents[e].bIsKindOf(GenBeam()))
			{
				GenBeam gb =(GenBeam)ents[e]; 
				if (gb.bIsDummy())continue;
				bodies.append(bdReal);
				materials.append(gb.material());
				entRefs.append(ent);
				ptCens.append(gb.ptCentreOfGravity());
				dDensitiesMapx.append(-1);
				dWeightsMapx.append(-1);
				if (bDebugIO)reportMessage("\n" + e + " " + ent.typeDxfName() + " accepted material: " +gb.material());
			}// END IF BEAM / SHEET				

		// TSL assuming that any tsl is made of steel unless a property set was found
			else if (ent.bIsKindOf(TslInst()))
			{
				TslInst tsl =(TslInst)ent;
				if (!tsl.bIsValid())continue;
			// HSB-15062
				if(tsl.subMapXKeys().findNoCase("CenterOfGravity",0)>-1)
				{ 
					Map mapCenter=tsl.subMapX("CenterOfGravity");
					if(mapCenter.hasDouble("Weight") && mapCenter.hasPoint3d("Center"))
					{ 
						dTslMapWeights.append(mapCenter.getDouble("Weight"));
						ptTslMapPoints.append(mapCenter.getPoint3d("Center"));
						continue;
					}
				}
				
				sMaterial=tsl.materialDescription();
				
			// get all prop sets of it
				String sPropSetNames[] = ent.attachedPropSetNames();
				String sPropertyNames[] = {sMaterialName};
			// loop all property sets
				for (int i=0; i<sPropSetNames.length();i++)
				{
					Map map = ent.getAttachedPropSetMap(sPropSetNames[i],sPropertyNames);
					if (map.hasString(sMaterialName))
					{
						sMaterial=map.getString(sMaterialName);
						break;// first appearance taken	
					}
				}// next i	
				
			// fall back to steel
				if (sMaterial=="")	sMaterial=T("|Steel|");
				bodies.append(bdReal);
				materials.append(sMaterial);
				entRefs.append(ent);
				ptCens.append(bdReal.ptCen());
				dDensitiesMapx.append(-1);
				dWeightsMapx.append(-1);
			}// END IF TSL 

		// OPENING windows, doors and assemblies	
			else if (ent.bIsKindOf(Opening()))
			{
				int type = ((Opening)ent).openingType();
				if(bBaufritz)
				{ 
					// HSB-23011: for Baufritz do calculation with "BF-OpeningCenterOfGravity"
					if(type==_kAssembly || type==_kDoor || type==_kWindow)
					{ 
						String sPath = _kPathHsbCompany+"\\TSL";
						String sFileName ="BF-OpeningCenterOfGravity.mcr";
						String sFullPath = sPath+"\\"+sFileName;
						String sFile=findFile(sFullPath); 
						if (sFile.length()>0)
						{ 
							Opening op = (Opening)ent;
							// BF-OpeningCenterOfGravity.mcr found in the company directory
						// create TSL
							TslInst tslNew;			Vector3d vecXTsl= _XW;		Vector3d vecYTsl= _YW;
							GenBeam gbsTsl[] = {};	Entity entsTsl[] = {ent};	Point3d ptsTsl[] = {_Pt0};
							int nProps[]={};		double dProps[]={};			String sProps[]={};
							Map mapTsl;	
							tslNew.dbCreate("BF-OpeningCenterOfGravity" , vecXTsl ,vecYTsl,gbsTsl, entsTsl, 
								ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
						}
					}
				
					if((type==_kAssembly || type==_kDoor || type==_kWindow) && ent.subMapXKeys().find("BF-OpeningInfo")>-1)
					{ 
						// HSB-23011: when information provided by BF-OpeningCenterOfGravity
						Map mapX = ent.subMapX("BF-OpeningInfo");
						for (int im=0;im<mapX.length();im++) 
						{ 
							Map mapI=mapX.getMap(im); 
							bodies.append(mapI.getBody("Body"));
							ptCens.append(mapI.getPoint3d("ptCen"));
							entRefs.append(mapI.getEntity("entRef"));
							int iType = mapI.getInt("iOpeningType");
							if(mapI.hasString("Material"))
							{ 
								sMaterial=mapI.getString("Material");
							}
							else
							{ 
								if (iType == _kDoor){sMaterial = "Door";}
								else {sMaterial = "Window";}
							}
							
							materials.append(sMaterial);
							dDensitiesMapx.append(-1);
							dWeightsMapx.append(-1);
						}//next im
						// opening was processed
						continue;
					}
				}
				if((type==_kAssembly || type==_kDoor || type==_kWindow) && ent.subMapXKeys().find("OpeningCOG")>-1)
				{ 
					// information is written in mapX OpeningCOG by hsbCenterOfGravity_setOpeningWeight
					// HSB-20484
					Map mapX = ent.subMapX("OpeningCOG");
					// calculation with density is favorable because it decreases the errors if the opening volume is changed
					double dDensityI=mapX.getDouble("Density");
					dDensitiesMapx.append(dDensityI);
					double dWeightI=-U(1);
					if(mapX.hasDouble("Weight"))
					{ 
						dWeightI=mapX.getDouble("Weight");
					}
					dWeightsMapx.append(dWeightI);
					bodies.append(bdReal);
					materials.append(sMaterial);	
					entRefs.append(ent);
					ptCens.append(bdReal.ptCen());
				}
				else
				{ 
					if(dVolume<pow(dEps,3)) continue;
					if (type == _kNoOpening || type == _kOpening){continue;}
					else if (type == _kDoor)sMaterial="Door";
					else	sMaterial="Window";
					bodies.append(bdReal);
					materials.append(sMaterial);	
					entRefs.append(ent);
					ptCens.append(bdReal.ptCen());
					dDensitiesMapx.append(-1);
					dWeightsMapx.append(-1);
				}
			}

		// MASS ELEMENT
			else if (ent.bIsKindOf(MassElement()))
			{
			// preset default material	
				sMaterial=T("|Steel|");
				
			// get all prop sets of it
				String sPropSetNames[] = ent.attachedPropSetNames();
				String sPropertyNames[] = {sMaterialName};
			// loop all property sets
				for (int i=0; i<sPropSetNames.length();i++)
				{
					Map map = ent.getAttachedPropSetMap(sPropSetNames[i],sPropertyNames);
					if (map.hasString(sMaterialName))
					{
						sMaterial=map.getString(sMaterialName);
						break;// first appearance taken	
					}
				}// next i	
				bodies.append(bdReal);
				materials.append(sMaterial);
				entRefs.append(ent);
				ptCens.append(bdReal.ptCen());
				dDensitiesMapx.append(-1);
				dWeightsMapx.append(-1);
				//reportMessage("\n accepted massElement " +ent.handle());
			}// END IF MASS ELEMENT
		
		// MASSGROUP	
			else if (ent.bIsKindOf(MassGroup()))
			{	
				MassGroup item=(MassGroup)ent;
				if (item.bIsValid())
					massGroups.append(item);	
			}
		// CollectionENt	
			else if (ent.bIsKindOf(MetalPartCollectionEnt()))
			{	
				MetalPartCollectionEnt ce =(MetalPartCollectionEnt)ent;
				if (ce.bIsValid())
				{
					ces.append(ce);	
					bodiesCE.append(bdReal);
				}
			}
			
		// 3DSolid
			else if (ent.typeDxfName() == "3DSOLID")
			{
			// preset default material
				sMaterial = T("|Steel|");
				
			// get all prop sets of it
				String sPropSetNames[] = ent.attachedPropSetNames();
				String sPropertyNames[] = {sMaterialName};
			// loop all property sets
				for (int i=0; i<sPropSetNames.length();i++)
				{
					Map map = ent.getAttachedPropSetMap(sPropSetNames[i],sPropertyNames);
					if (map.hasString(sMaterialName))
					{
						sMaterial=map.getString(sMaterialName);
						break;// first appearance taken	
					}
				}// next i					
	
				bodies.append(bdReal);
				materials.append(sMaterial);
				entRefs.append(ent);
				ptCens.append(bdReal.ptCen());
				dDensitiesMapx.append(-1);
				dWeightsMapx.append(-1);
			}
		}// next e

	// calculate the center of gravity by iterating through each body
		Point3d ptCen;	
		double dM1;
		if (mapIn.hasDouble("Weight") && mapIn.hasPoint3d("ptCen"))
		{
			ptCen = mapIn.getPoint3d("ptCen");
			dM1 = mapIn.getDouble("Weight");
		}
		
		
		for (int e=0;e<bodies.length();e++)
		{	
			Body bd = bodies[e];
			String material = materials[e];
			Entity ent = entRefs[e];
			if (bDebugIO)reportMessage("\n	body " + e + " of "+ ent.typeDxfName() + " " + ent.handle() + " material " + material);
		// get density
			double dDensity = dDefaultDensity ;// kg/m3	

		// search density map	
			int bOk;
			if(dDensitiesMapx[e]<0)
			{ 
				// density not defined in mapX
				if (material.length()>0)	
				{
					//if (bDebugIO)reportMessage("\nsearching " + material + "\n" + mapMaterials);
					for (int x=0;x<mapMaterials.length();x++)
					{
						Map mapMaterial = mapMaterials.getMap(x);
						String m = mapMaterial.getString("Material");
						double d = mapMaterial.getDouble("Density");
						//if (bDebugIO)reportMessage("\n" +m + " vs "+ material + " d " + d);
						if (material.makeUpper() == m.makeUpper() && d>0)
						{
							if (bDebugIO)reportMessage("\n	"+m + " accepted with density " +d);
							bOk=true;
							dDensity=d;
							break;
						}
						//else if (bDebugIO) reportMessage("\n	"+m + " rejected");
					}
					
				// collect missing densities
					int bIsMissing = !bOk && sMissingDensities.find(material) < 0;
					
				// special test: do not collect materials if based on style name		
					if (ent.bIsKindOf(Sip()))
					{ 
						Sip sip = (Sip)ent;
						String style = sip.style().makeUpper();
						if (style.length()>6 && style.left(6)==material.left(6))
							bIsMissing = false;
					}
					if (bIsMissing)
					{
						sMissingDensities.append(material);	
					}					
				}
				else
					nNumEmptyMaterial++;
			}
			if(dDensitiesMapx[e]>0)
			{
				// density defined in mapx
				dDensity=dDensitiesMapx[e];
			}
		// the ptCen of the body
			Point3d ptThisCen= ptCens[e];// //HSB-7007, HSB-7085 		//bd.ptCen();
			double dM2=dDensity*bd.volume()/(pow(U(1000,"mm"),3));;
			if(dWeightsMapx[e]>0)
			{ 
				// weight is defined in mapx
				dM2=dWeightsMapx[e];
				if (bDebugIO)reportMessage("\n	"+dM2 + " mass taken from map");
			}
			if(dDensitiesMapx[e]>0)
			{ 
				// If in MapX are provided both the weight and the densities
				// the density will take precedence
				// HSB-20484
				dM2=dDensity*bd.volume();
				
			}
			
		// calculate the point of gravity one by one	
			if (dM1<=0)
			{
				ptCen= bd.ptCen();
				dM1 = dM2;	
				
//				if (bDebugIO)
//				{
//					EntPLine epl;
//					epl.dbCreate(PLine(_PtW,ptCen));
//					epl.setColor(e);
//				}	
			}
			else
			{
				//ptThisCen//Point3d ptCenB = bd.ptCen();
				
				if (bDebugIO)
				{
					EntPLine epl;
					epl.dbCreate(PLine(_PtW,ptThisCen));//ptCen,
					epl.setColor(e);
				}	
				
				Vector3d vec=ptThisCen-ptCen;//ptCenB-ptCen;
				double c = vec.length();
				vec.normalize();
				double b = (dM1*c)/(dM1+dM2);
				ptCen.transformBy(vec*(c-b));
				dM1 += dM2;	
			}
		}// next body e	
	
		//reportNotice("\n"+bodies.length()+": contributed total weight " + dM1 + "[kg]" + " ces found " + ces.length());
	
	
	// add mass group entities
		for (int e=0;e<massGroups.length();e++)
		{
			Entity items[] = massGroups[e].entity();; 

			Map mapIO;
			Map mapEntities;
			for (int m=0;m<items.length();m++)
			{
				int nOperation = massGroups[e].operation(items[m]);
				if (nOperation!=_kAOPAdditive)
				{
					//reportMessage("\n refused massElement " +items[m].handle());
					continue;
				}
				mapEntities.appendEntity("Entity", items[m]);				
			}

			if (dM1>0)
			{
				mapIO.setPoint3d("ptCen", ptCen);
				mapIO.setDouble("Weight", dM1);
				
			}
			mapIO.setMap("Entity[]",mapEntities);
			TslInst().callMapIO(scriptName(), mapIO);
			ptCen= mapIO.getPoint3d("ptCen");	
			dM1 = mapIO.getDouble("Weight");
		}

	// add collection entities	
		for (int e=0;e<ces.length();e++)
		{
			MetalPartCollectionEnt ce = ces[e];
			MetalPartCollectionDef cd = ce.definitionObject();
			Body bdReal = bodiesCE[e];
			
		//region Check if style based weight definition applies //HSB-22284
			if (cd.subMapXKeys().findNoCase(kMetalStyleData,-1)>-1)
			{ 
				int tick = getTickCount();
				Map mapX = cd.subMapX(kMetalStyleData);
				double dM2 = mapX.getDouble("Weight");
				Point3d ptThisCen = bdReal.ptCen();

				if (dM1<=0)
				{
					ptCen= ptThisCen;
					dM1 = dM2;	
				}
				else
				{
					Vector3d vec=ptThisCen-ptCen;
					double c = vec.length();
					vec.normalize();
					// c = a+b
					// m1*a = m2*b
					double b = (dM1*c)/(dM1+dM2);
					ptCen.transformBy(vec*(c-b));
					dM1 += dM2;	
				}

				//reportNotice("\n"+ce.definition()+": " + dM2 + "[kg], time elapsed " + (getTickCount()-tick)+ "ms, total = " + dM1 + "[kg]");
				continue;
			}				
		//endregion 
		
		//region Iterate through content (to be reviewed)
				
		//endregion 
		

			CoordSys csMce = ce.coordSys();
			
			CoordSys csDefSpace = csMce;
			csDefSpace.invert();
			Entity items[] = cd.entity();; 

		// collect child assemblies
			MetalPartCollectionEnt ces2[0];
			MassGroup mgs2[0];
			for (int f=0;f<items.length();f++) 
			{ 
				MetalPartCollectionEnt ce2 =(MetalPartCollectionEnt)items[f]; 
				if (ce2.bIsValid()&& ces2.find(ce2)<0)
				{
					ces2.append(ce2);		
					continue;
				}

				MassGroup mg2 =(MassGroup)items[f]; 
				if (mg2.bIsValid() && mgs2.find(mg2)<0)
					mgs2.append(mg2);		
			}

		// remove any item which has a parent in the list of items
			int nNumBefore = items.length();
			for (int f=items.length()-1; f>=0 ; f--) 
			{ 
				GenBeam gb = (GenBeam)items[f];
				if (gb.bIsDummy() || items[f].realBody().volume()<pow(dEps,3))
				{
					items.removeAt(f);
					continue;
				}
				
				
				
				for (int g=0;g<ces2.length();g++) 
				{ 
					MetalPartCollectionDef d(ces2[g].definition()); 
					if (d.entity().find(items[f])>-1)
					{
						items.removeAt(f);
						break;
					}
				}
				for (int g=0;g<mgs2.length();g++) 
				{ 
					if (mgs2[g].entity().find(items[f])>-1)
					{
						items.removeAt(f);
						break;
					}
				}				
			}

			Map mapIO;
			Map mapEntities;
			for (int m=0;m<items.length();m++)
			{
				mapEntities.appendEntity("Entity", items[m]);
				//reportMessage("\nappending item " + items[m].typeDxfName());
			}
			if (dM1>0)
			{
				ptCen.transformBy(csDefSpace);
				mapIO.setPoint3d("ptCen", ptCen);
				mapIO.setDouble("Weight", dM1);	
			}
			mapIO.setMap("Entity[]",mapEntities);
			mapIO.setInt("debug", bDebugIO);
			TslInst().callMapIO(scriptName(), mapIO);
			ptCen= mapIO.getPoint3d("ptCen");	
			ptCen.transformBy(csMce );
			dM1 = mapIO.getDouble("Weight");
		}
		
	// HSB-15062: add weights form mapX of TSLs
		for (int e=0;e<dTslMapWeights.length();e++) 
		{ 
			double dWeightE= dTslMapWeights[e];
			Point3d ptTslMapPointE=ptTslMapPoints[e];
			Point3d ptTot=(dM1*ptCen)+(dWeightE*ptTslMapPointE);
			dM1+=dWeightE;
			
			if (bDebugIO)reportMessage("\n	"+dWeightE + " added from map");
			// HSB-23445
			if(dM1>0)
			{
				ptCen=ptTot/dM1;
			}
		}//next e
		
		for (int s=0;s<sMissingDensities.length();s++)
			mapMissing.appendString("missing", sMissingDensities[s]);
		if (mapMissing.length()>0)
			mapOut.setMap("Missing[]", mapMissing);
		mapOut.setPoint3d("ptCen",ptCen);
		mapOut.setDouble("Weight",dM1,_kNoUnit);
		mapOut.setInt("NumEmptyMaterial",nNumEmptyMaterial);
		
		_Map=mapOut;
		return;
	}
// END mapIO


// triggers to add or remove
// add  triggers	
	String sTriggers[] = {T("|Add Entity|"),T("|Remove Entity|")};
	for (int i = 0; i < sTriggers.length(); i++)
		addRecalcTrigger(_kContext, sTriggers[i]);
	
	// add
	if (_bOnRecalc && _kExecuteKey==sTriggers[0])
	{
	// prompt selection			
		PrEntity ssE(T("|Select entities|"), Entity());
		Entity ents[0];
	  	if (ssE.go())
	    	ents= ssE.set();
	// analyse the selection set for elements or loose entities
		Element el[0];
		Entity entsLoose[0];
		for (int e=0;e<ents.length();e++)
		{
			if (!ents[e].bIsValid()){ continue;}
		// collect any element
			if (ents[e].bIsKindOf(ElementWall()) || ents[e].bIsKindOf(ElementRoof()))	
			{
				_Element.append((Element)ents[e]);
			}
		// only do this as long as no elements were collected		
			else if (el.length()<1)
			{
			// ignore non solids	
				if (ents[e].realBody().volume()>pow(dEps,3))
					entsLoose.append(ents[e]);	
			}				
		}	

	// insert element based or to the selection of loose entities
		if (el.length()>0)
		{
			_Element.setLength(0);
			_Element.append(el[0]);
		}
		else
		{		
			for (int e=0;e<entsLoose.length();e++)
				if (_Entity.find(entsLoose[e])<0)
					_Entity.append(entsLoose[e]);					
		}				
	}	
	if (_bOnRecalc && _kExecuteKey==sTriggers[1])
	{
	// prompt selection			
		PrEntity ssE(T("|Select entities to remove|"), Entity());
		Entity ents[0];
	  	if (ssE.go())
	    	ents= ssE.set();	
		for (int e=0;e<ents.length();e++)
		{
			int n=_Entity.find(ents[e]);
			if (n>-1)
				_Entity.removeAt(n);	
		}	
	}

// blind trigger
	addRecalcTrigger(_kContext, "________________");


/// reload materials
// Trigger Load Density Table
	String sTriggerLoadDensityTable = T("|Load Densities from Database|");
	if (sNewFileName.length()>0)
		addRecalcTrigger(_kContext, sTriggerLoadDensityTable );
	int bLoad;
	if (_bOnRecalc && _kExecuteKey==sTriggerLoadDensityTable)
	{
		bLoad = true;
	}	

// add material trigger
	String sTriggerAddMaterial= T("|Add Material to Database|");
	addRecalcTrigger(_kContext, sTriggerAddMaterial);
	if (_bOnRecalc && (_kExecuteKey==sTriggerAddMaterial || _kExecuteKey==sDoubleClick) )
	{
		Map mapIn;
		mapIn.setString("Path", sPathNew);
		Map mapOut = callDotNetFunction2(strAssemblyPath, strType, strFunction, mapIn);	
		mo.setMap(mapOut);
	}
	
// declare and collect entities
	ShopDrawView sdv;int bHasSDV;Entity entsDefineSet[0], entMultipage;
	Entity ents[0];
	Element el;
	CoordSys cs, ms2ps, ps2ms;
	Point3d ptOrg;	
	Vector3d vecX,vecY,vecZ;	
	double dScale=1;
	int bHasViewport, bHasElement;
	if (_Element.length()>0)
	{
		el = _Element[0];
		bHasElement = el.bIsValid();
		int n = _Entity.find(el);
		if (n>-1 && _Entity.length()>1)//HSB-21242
		{ 
			_Entity[0] = el;
			_Entity.setLength(1); 
		}
		
	}
	else if (_Viewport.length()>0)
	{
		Viewport vp = _Viewport[_Viewport.length()-1]; // take last element of array
		_Viewport[0] = vp; // make sure the connection to the first one is lost
		
		// check if the viewport has hsb data
//		if (!vp.element().bIsValid()) 
//		{
//			eraseInstance();
//			return;
//		}
		ms2ps = vp.coordSys();
		ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps
		el = vp.element();
	// HSB-21836
		bHasElement = el.bIsValid();
		dScale = ps2ms.scale();	
		bHasViewport=true;
	}
	else
	{ 
		for (int i=0;i<_Entity.length();i++) 
		{ 
			ShopDrawView _sdv = (ShopDrawView)_Entity[i]; 
			GenBeam gb = (GenBeam)_Entity[i];
			if (_sdv.bIsValid())
			{ 
				sdv = _sdv;
				
				entMultipage = _Map.getEntity("Generation\\entCollector");
				if (!entMultipage.bIsValid())
					entMultipage = _Map.getEntity(_kOnGenerateShopDrawing +"\\entCollector");	

				//reportMessage("\nXXXsdv found");
				
			// interprete the list of ViewData in my _Map
				ViewData viewDatas[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets,0); // 2 means verbose
				int nIndex = ViewData().findDataForViewport(viewDatas, sdv);// find the viewData for my view
				if (nIndex>-1)
				{ 
					ViewData viewData = viewDatas[nIndex];
					
					ms2ps = viewData.coordSys();
					ps2ms = ms2ps; ps2ms.invert();
					dScale = ps2ms.scale();	
					
					entsDefineSet=viewData.showSetDefineEntities();
					for (int j=0;j<entsDefineSet.length();j++) 
					{ 
						el=(Element)entsDefineSet[j]; 
						if (el.bIsValid())break;					 
					}//next j
				}
				bHasSDV=true;
			}
			else if(gb.bIsValid())//HSB-21284
				setDependencyOnEntity(gb);
		}//next i
	}
	
	
	if(bHasElement)
	{
		
		cs=el.coordSys();
		ptOrg=cs.ptOrg();
		//_Pt0 = el.ptOrg();
		vecX=cs.vecX();
		vecY=cs.vecY();
		vecZ=cs.vecZ();

		GenBeam gb[]=el.genBeam(); 
		for (int i=0;i<gb.length();i++)		
		{
// HSB-21242		
//			int n=_Entity.find(gb[i]);
//			if (n<0)
//			{ 
//				_Entity.append(gb[i]);
//				n=_Entity.length() - 1;
//			}
//			setDependencyOnEntity(_Entity[n]);
			ents.append(gb[i]);
		}
		
		// HSB-19480: Include attached tsls, not only those in the group
		TslInst tsls[]=el.tslInst(); 
		TslInst tslsAttached[] =el.tslInstAttached(); 
		for (int i=0;i<tsls.length();i++)		
		{
			if(ents.find(tsls[i])<0)
				ents.append(tsls[i]);
		}
		// HSB-24576
		String sTslsAllowed[]={"hsbElementInsulation","HSB_E-Insulation"};
		for (int i=0;i<tslsAttached.length();i++)
		{
			// HSB-24576
//			if(tslsAttached[i].scriptName()!="hsbElementInsulation")continue;
			if(sTslsAllowed.findNoCase(tslsAttached[i].scriptName())<0)continue;
			if(ents.find(tslsAttached[i])<0)
				ents.append(tslsAttached[i]);
		}
		
		if(bIncludeWindowDoor)
		{
			Opening openings[] =el.opening(); 
			for (int i=0;i<openings.length();i++)		
				ents.append(openings[i]);
		}
		
	// Append metalparts being attached to the element	// HSB-22284
		Entity entsCE[] = el.elementGroup().collectEntities(true, MetalPartCollectionEnt(), _kModelSpace);
		ents.append(entsCE);
		
		
		if (!bHasViewport)
		{
			setDependencyOnEntity(el);
			assignToElementGroup(el,true,0,'E');
		}
	}
	else// if (!bHasSDV)
	{
		if (bHasSDV)
			ents=entsDefineSet;
		else
			ents=_Entity;
	
		if (ents.length()>0 && ents[0].bIsKindOf(GenBeam()))
		{
			CoordSys cs=((GenBeam)ents[0]).coordSys();
			vecX=cs.vecX();
			vecY=cs.vecY();
			vecZ=cs.vecZ();
		}
		else 
		{
			vecX=_XE;
			vecY=_YE;
			vecZ=_ZE;
		}	
	}
	
// HSB-16848: Filter entities
	int nRule=sRules.find(sRule);
	if(sRule!=sDisabled) // HSB-21242 improving performance
	{ 
		PainterDefinition painterEntities;
		if(ents.length()>0)
		{ 
	//			painterEntities=PainterDefinition(sPainterCollection + "\\" + sRule);
			painterEntities=PainterDefinition(sRule);
			if(painterEntities.bIsValid())
			{
				ents=painterEntities.filterAcceptedEntities(ents);
			}
		}
		if (painterEntities.bIsValid())
		{ 
			Map m;
			m.setString("Name", painterEntities.name());
			m.setString("Type",painterEntities.type());
			m.setString("Filter",painterEntities.filter());
			m.setString("Format",painterEntities.format());
			sPainterStream.set(m.getDxContent(true));
		}
		
//		if(!_bOnViewportsSetInLayout)// HSB-21242 improving performance
		// HSB-21286: only update catalog when property is changed
		if(_kNameLastChangedProp==sRuleName)// HSB-21242 improving performance
			_ThisInst.setCatalogFromPropValues(sCatalogPainter);
	}

	
	// HSB-20024: Write weight in mapX of genbeams
	if(ents.length()>0)
	{ 
		if(!bHasElement || (bHasElement && _bOnViewportsSetInLayout) || _bOnDbCreated)
		{ 
			
		// update mapX for genbeams
			for (int e=0;e<ents.length();e++) 
			{ 
				GenBeam gb=(GenBeam)ents[e];
				if(gb.bIsValid())
				{ 
					Map mapIO;
					Map mapEntities;
					mapEntities.appendEntity("Entity",ents[e]);
					mapIO.setMap("Entity[]",mapEntities);
					TslInst().callMapIO(scriptName(),mapIO);
					double dWeightE=mapIO.getDouble("Weight");
					
					Map mapX;
					mapX.setDouble("Weight",dWeightE);
					gb.setSubMapX("COG",mapX);
				}
			}//next e
		}
	}
	
	
	// center and weight
	Point3d ptCen;
	double dWeight;
	if(_bOnDebug)
	{
	// rebuild the collection if massgroups where found
		Entity entsExtended[0];
		for (int e=0;e<ents.length();e++)
		{
			if (!ents[e].bIsValid()){ continue;}
			if (ents[e].bIsKindOf(MassGroup()))
			{
				MassGroup mg =(MassGroup)ents[e];
				entsExtended.append(mg.entity());
			}
			else
				entsExtended.append(ents[e]);	
		}
		ents=entsExtended;	// reassign		
		
		
		
		double dM1;
		for (int e=0;e<ents.length();e++)
		{
			if (!ents[e].bIsValid()){ continue;}
			Body bd = ents[e].realBody();
			double dVolume = bd.volume();
			//if(dVolume<pow(dEps,3)) continue;	
			
		// get density
			double dDensity = dDefaultDensity ;// kg/m3	
			String sMaterial;
		// genBeam	
			if (ents[e].bIsKindOf(Sip()))
			{
				Sip sip = (Sip)ents[e];
				Vector3d vecZSip=sip.vecZ();
				if (!sip.bIsValid())continue;
				SipStyle style(sip.style());
				int nNum = style.numSipComponents();
				sMaterial=sip.material();
				
			// iterate through components if material is not set or multiple components are defined
				if (sMaterial=="" || nNum >1)
				{
					Body bdReal = sip.realBody();
					PLine plEnvelope=sip.plEnvelope();
					for(int i=0;i<nNum ;i++)
					{
						SipComponent c = style.sipComponentAt(i);
						double d = c.dThickness();
						String s = c.material();
						Body bd(plEnvelope, vecZSip*d,1);
						int bOk=bd.intersectWith(bdReal);
						bd.transformBy(vecZSip*U(1000));
						
						Body lumps[] = bd.decomposeIntoLumps();
						for(int l=0;l<lumps.length();l++)
							lumps[l].vis(i);

						plEnvelope.transformBy(vecZSip*d);
					}// next i
				}	
				
			}
		// genBeam	
			else if (ents[e].bIsKindOf(GenBeam()))
				sMaterial=((GenBeam)ents[e]).material();
		// assuming that any tsl is made of steel unless a property set was found
			else if (ents[e].bIsKindOf(TslInst()))
			{
			// get default material from tsl.material
				TslInst tsl =(TslInst)ents[e];
				sMaterial=tsl.materialDescription();
						
			// if no material is set default it to steel and look in property sets
				if (sMaterial.length()<1)
				{
					sMaterial=T("|Steel|");
				// get all prop sets of it
					String sPropSetNames[] = ents[e].attachedPropSetNames();
					String sPropertyNames[] = {sMaterialName};
				// loop all property sets
					for (int i=0; i<sPropSetNames.length();i++)
					{
						Map map = ents[e].getAttachedPropSetMap(sPropSetNames[i],sPropertyNames);
						if (map.hasString(sMaterialName))
						{
							sMaterial=map.getString(sMaterialName);
							break;// first appearance taken	
						}
					}// next i
				}				
			}
		// windows, doors and assemblies	
			else if (ents[e].bIsKindOf(Opening()))
			{
				int type = ((Opening)ents[e]).openingType();
				if (type == _kNoOpening || type == _kOpening){continue;}
				else if (type == _kDoor)sMaterial="Door";
				else	sMaterial="Window";
			}
		// other entity types
			else
			{
			// get all prop sets of it
				String sPropSetNames[] = ents[e].attachedPropSetNames();
				String sPropertyNames[] = {sMaterialName};
			// loop all property sets
				for (int i=0; i<sPropSetNames.length();i++)
				{
					Map map = ents[e].getAttachedPropSetMap(sPropSetNames[i],sPropertyNames);
					if (map.hasString(sMaterialName))
					{
						sMaterial=map.getString(sMaterialName);
						break;// first appearance taken	
					}
				}// next i					
			}
			
		// search map								
			int bOk;
			if (sMaterial.length()>0)	
			{
				if (bDebug)reportMessage("\nsearching " + sMaterial + "\n" + mapMaterials);
				for (int m=0;m<mapMaterials.length();m++)
				{
					Map mapMaterial = mapMaterials.getMap(m);
					String s = mapMaterial.getString("Material");
					double d = mapMaterial.getDouble("Density");
					
					if (sMaterial.makeUpper() == s.makeUpper() && d>0)
					{
						//reportMessage("\n	"+s + " accepted");
						bOk=true;
						dDensity=d;
						break;
					}
					//else reportMessage("\n	"+s + " rejected");
					
				}
			}
			
		// collect missing densities
			if (!bOk && sMissingDensities.find(sMaterial)<0)
			{
				sMissingDensities.append(sMaterial);	
			}

		// the ptCen of the body
			Point3d ptThisCen= bd.ptCen();
			double dM2 = dDensity *dVolume/(pow(U(1000,"mm"),3));//1000000000;
			
		// if the entity is of type metalpart collection entity get the point of gravity and the weight from an individual call	
			if (ents[e].bIsKindOf(MetalPartCollectionEnt()))
			{
				MetalPartCollectionEnt ce =(MetalPartCollectionEnt)ents[e];
				MetalPartCollectionDef cd(ce.definition());
				CoordSys csMce = ce.coordSys();
				Entity entsMce[] = cd.entity();; 

				Map mapIO;
				Map mapEntities;
				for (int m=0;m<entsMce.length();m++)
					mapEntities.appendEntity("Entity", entsMce[m]);
				mapIO.setMap("Entity[]",mapEntities);
				TslInst().callMapIO(scriptName(), mapIO);
				ptThisCen= mapIO.getPoint3d("ptCen");	
				ptThisCen.transformBy(csMce );
				double dThisWeight= 	mapIO.getDouble("Weight");	
				if (dThisWeight>0)dM2=dThisWeight;		
			}

			if (dM1<=0)
			{
				ptCen= ptThisCen;
				dM1 = dM2;	
			}
			else
			{
				Point3d ptCenB = ptThisCen;
				ptCenB.vis(e);
				//bd.vis(e);
				//dp.color(e);
				//dp.draw(PLine(ptCenB,ptCen));			
				Vector3d vec=ptCenB-ptCen;
				double c = vec.length();
				vec.normalize();
				// c = a+b
				// m1*a = m2*b
				double b = (dM1*c)/(dM1+dM2);
				ptCen.transformBy(vec*(c-b));
				dM1 += dM2;	
			}
			ptCen.vis(e);
		}
	}
	else if (ents.length()>0)
	{
		
// call mapIO
		Map mapIO;
		Map mapEntities;
		for (int e=0;e<ents.length();e++)
			mapEntities.appendEntity("Entity", ents[e]);
		
		mapIO.setMap("Entity[]",mapEntities);
		TslInst().callMapIO(scriptName(), mapIO);
		ptCen = mapIO.getPoint3d("ptCen"); ptCen.vis(2);
		dWeight = mapIO.getDouble("Weight");	
	
		if ((bLoad || _kNameLastChangedProp=="_Pt0") && findFile(sPathNew).length()>3)
		{
			reportMessage("\n"+T("|Rereading densities|")+(el.bIsValid()?T("|Element| ")+el.number():""));
		// read the file
			Map map;
			map.readFromXmlFile(sPathNew);
			mo.setMap(map);
			mapMaterials = mo.map().getMap("Material[]");	
			bLoad = true;
			//sMissingDensities.setLength(0);
		}		
	
		
	// report missing densities
		if(mapIO.hasMap("Missing[]"))
		{
			reportMessage("\n"+(el.bIsValid()?T("|Element| ")+el.number():"") +" "+ _Viewport.length()+_bOnViewportsSetInLayout+_kExecutionLoopCount );
			Map mapMissing = mapIO.getMap("Missing[]");
			int bWarn = mapMissing.length() > 0;
			String msg;
			
			if (bWarn)
				msg+=TN("|Warning|: ") +T("|The density of the following material(s) is not defined|: ");	
			
			for (int m=0;m<mapMissing .length();m++)
				msg+=(m>0?", ":"")+mapMissing.getString(m);			
		
			int nNumEmptyMaterial = mapIO.getInt("NumEmptyMaterial");
			if (nNumEmptyMaterial>0)
			{
				msg+="\n" + nNumEmptyMaterial + (nNumEmptyMaterial==1?T(" |entitiy does not have|"):T(" |entities do not have|")) + T(" |a proper material name assigned.|") + 
					T(" |Default materials have been used instead.|");
			}				

		// Do not reread if in set layout and appended to model
			if (_Viewport.length()<1 && _bOnViewportsSetInLayout && bWarn && !bLoad)
			{ 
				msg ="\n"+scriptName()+": "+ TN("|User action required, please ensuree proper material definition table!|") + msg;
				reportMessage(msg);
			}


		// reread xml if material not found
		// check if xml file exists
			else if (bWarn && findFile(sPathNew).length()>3 && !bLoad)
			{	
				if (el.bIsValid())
				{ 
					msg = "\n"+scriptName()+": "+TN("|User action required, please ensuree proper material definition table!|\n") + msg;
					reportMessage(msg);	
					bWarn = false;
				}
				else
				{ 
					reportMessage("\n"+scriptName()+": "+msg + TN("|Rereading densities| ") + (el.bIsValid()?T("|Element| ")+el.number():""));
				
				// read the file
					Map map;
					map.readFromXmlFile(sPathNew);
					mo.setMap(map);	
					sMissingDensities.setLength(0);					
				}

			}
			
		// show tick
			if (bWarn)reportMessage(" (" + (getTickCount() - nTick)+ "ms)");
		}	
	}	
	
// viewport setup display
	double dThisSize = bHasViewport?dSize /dScale:(dSize<=0?U(100):dSize);//
	if(bHasViewport)
	{
		ptCen.transformBy(ms2ps);
		vecX = _XW;
		vecY=_YW;
		vecZ=_ZW;
		
		Display dpViewport(nColor);
		dpViewport.dimStyle(sDimStyle);
		if (dTextHeight>0)
			dpViewport.textHeight(dTextHeight);
		String sTxt;
		if (dTextHeight<=0)
		{		
			double dStyleHeight = dpViewport.textHeightForStyle("O", sDimStyle);
			dpViewport.textHeight(dStyleHeight/dScale);
			sTxt= scriptName();
			sTxt+=(dSize <= 0 ? ", " + T("|symbol invisble|"):"");
		}
		else
		{ 
			if (dWeight<10)
				sTxt.formatUnit(dWeight, 2,1);			
			else
				sTxt.formatUnit(dWeight, 2,0);
			sTxt = sTxt + " kg";
		}
		sTxt+=(!el.bIsValid() ? ", " + T("|no element available|"):"");
		dpViewport.draw(sTxt, _Pt0, _XW, _YW, 1, 0);

	}
	else if (bHasSDV)
	{ 
		vecX = _XW;	vecX.transformBy(ps2ms);	vecX.normalize();
		vecY = _YW;	vecY.transformBy(ps2ms);	vecY.normalize();
		vecZ = vecX.crossProduct(vecY);

	// shopdraw setup	
		if(ents.length()<1)	
			ptCen=_Pt0;
	// shopdraw		
		else 
			ptCen.transformBy(ms2ps);
	}
	else
	{
		_Pt0 = ptCen;
	}
	vecX.vis(_Pt0, 1);
	vecY.vis(_Pt0, 3);
	vecZ.vis(_Pt0, 150);	


// get style
	int nStyle = sStyles.find(sStyle, 0);
	int bDrawRhomb = nStyle==0 || nStyle==2, bDrawCircle= nStyle==1 || nStyle==3, bAddCoordinate= nStyle==2 || nStyle==3;

// Display
	Display dp(nColor),dpModel(nColor), dpZ(bDebug?150:nColor);
	dp.dimStyle(sDimStyle);
	dp.showInDxa(true);
	if (dTextHeight>0)dp.textHeight(dTextHeight);
	
	dpModel.addHideDirection(vecX);
	dpModel.addHideDirection(vecY);
	dpModel.addHideDirection(vecZ);
	dpModel.addHideDirection(-vecX);
	dpModel.addHideDirection(-vecY);
	dpModel.addHideDirection(-vecZ);
	dpModel.dimStyle(sDimStyle);
	dpModel.showInDxa(true);
	if (dTextHeight>0)dpModel.textHeight(dTextHeight);	

	
	dpZ.addViewDirection(vecZ);
	dpZ.addViewDirection(-vecZ);
	dpZ.dimStyle(sDimStyle);
	dpModel.showInDxa(true);
	if (dTextHeight>0)dpZ.textHeight(dTextHeight);

//region Object Data formatting HSB-7113
	Map mapAdditionalVariables;
	{ 
		mapAdditionalVariables.appendDouble("Weight", dWeight);
	}
// format text
	String format = sFormat;
	// legacy: the property used to be a no/yes property
	if (format==sNoYes.first())
	{
		format = "";
		sFormat.set(format);
	}
	else if (format==sNoYes.last())
	{
		format = "@(Weight) kg";
		sFormat.set(format);
	}
	String sText;
	for (int i=0;i<ents.length();i++) 
	{ 
		if (ents[i].bIsValid())
		{
			sText = ents[i].formatObject(format,mapAdditionalVariables);
			break;
		}		 
	}//next 
//End Object Data formatting//endregion 

	_ThisInst.setModelDescription(sText);
	PlaneProfile ppProtect(CoordSys(_PtW, _XW, _YW, _ZW)); // declaration of a protection area, only used in shopdrawings
	
// query blocknames for custom display
	double dSym = dSize/dScale;
	String sBlockName = _bOnDebug?"hsbCenterOfGravity":scriptName();
	if(dThisSize>0 && _BlockNames.find(sBlockName)>-1)
	{
		Block bl(sBlockName);
		LineSeg seg = bl.getExtents();
		double _dY = abs(_YW.dotProduct(seg.ptStart()-seg.ptEnd()));
		dSym = dSym / _dY;
		CoordSys cs;
		cs.setToAlignCoordSys(_PtW, _XW,_YW,_ZW, ptCen,vecX*dSym,vecY*dSym,vecZ*dSym);
		seg.transformBy(cs);
	// get extents of profile
		double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
		double dY = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
		Point3d ptTxt = seg.ptMid()-vecY*.5*dY;

		dpZ.draw(sText, ptTxt, vecX, vecY, 0 ,- 1.2);		
	}
	else if(dThisSize>0)
	{
		PLine pl(vecZ);
		PlaneProfile pps[0];
		
	// get display text 
		double dDeltaTxt = .7 * dThisSize;

	// collect coordinates
		Point3d ptsC[0];
		if (bAddCoordinate)
		{
			double dDeltaTxt = .7 * dThisSize;
			for (int i = 0; i < ents.length(); i++)
			{
				Body bd = ents[i].realBody();
				ptsC.append(bd.extremeVertices(vecX));
				ptsC.append(bd.extremeVertices(vecY));
				ptsC.append(bd.extremeVertices(vecZ));
			}//next i
		}

	// get view directions
		Vector3d vecDirs[] ={ vecX, vecY, vecZ};
		Vector3d vecPerps[] ={vecY, vecZ, vecX};	
		if (bHasSDV)
		{ 
		// HSB-5810 alignment in a shopdrawing is always XY-World	
			vecDirs.setLength(0); 
			vecPerps.setLength(0);
			vecDirs.append(_XW);
			vecPerps.append(_YW);
		}
		
	// loop view directions		
		for (int i = 0; i < vecDirs.length(); i++)
		{
			Vector3d vecDir = vecDirs[i];
			Vector3d vecPerp = vecPerps[i];
			Vector3d vecView = vecDir.crossProduct(vecPerp);
			
		// set display	
			Display dp(nColor);
			dp.addViewDirection(vecView);
			dp.addViewDirection(-vecView);
			dp.dimStyle(sDimStyle);
			dp.textHeight(dTextHeight);
	
		// draw outline and collect profiles	
			PLine pl(vecView);
			if (bDrawCircle)
			{ 
				pl.createCircle(ptCen, vecView, .5*dThisSize);
				dp.draw(pl);
				if (i==0 && !bHasSDV)dpModel.draw(pl);
				
				pl=PLine(vecView);
				pl.addVertex(ptCen);
				pl.addVertex(ptCen-vecDir*.5*dThisSize);
				pl.addVertex(ptCen+vecPerp*.5*dThisSize, tan(-22.5));
				pl.close();

				PlaneProfile pp(pl);
				pps.append(pp);
	
				CoordSys csRot;
				csRot.setToRotation(180,vecView,ptCen);
				pp.transformBy(csRot);	
				pps.append(pp);
			}
			else if (bDrawRhomb)
			{ 
				pl.addVertex(ptCen-vecDir*.5*dThisSize);
				pl.addVertex(ptCen+vecDir*.5*dThisSize);
				pl.addVertex(ptCen);
				pl.addVertex(ptCen-vecPerp*.5*dThisSize);
				pl.addVertex(ptCen+vecPerp*.5*dThisSize);
				dp.draw(pl);	
				if (i == 0 && !bHasSDV)dpModel.draw(pl);
				
				pl.createRectangle(LineSeg(ptCen-.5*(vecDir+vecPerp)*sqrt(.5*pow(dThisSize,2)),ptCen+.5*(vecDir+vecPerp)*sqrt(.5*pow(dThisSize,2))),vecDir,vecPerp);
				CoordSys csRot;			csRot.setToRotation(45,vecDir.crossProduct(vecPerp),ptCen);
				pl.transformBy(csRot);
				PlaneProfile pp(pl);
				PlaneProfile pp2(pl);
				pp2.shrink(dSym *.1);
				pp.subtractProfile(pp2);
				pps.append(pp);

			}

		// draw profiles
			for (int j=0;j<pps.length();j++)
			{ 
				PlaneProfile pp = pps[j];
				if (nTransparency<100&& nTransparency!=0)
				{
					dp.draw(pp,_kDrawFilled,nTransparency);
					if (i==0 && !bHasSDV)dpModel.draw(pp,_kDrawFilled,nTransparency);					
				}
				else
				{
					dp.draw(pp,_kDrawFilled);	
					if (i==0 && !bHasSDV)dpModel.draw(pp,_kDrawFilled);		
				}
				if (bHasSDV) ppProtect.unionWith(pp);
			}
			
		// draw coordinates
			if (bAddCoordinate)
			{ 
				Vector3d _vecDir=vecDir, _vecPerp=vecPerp;
				if (bHasSDV)
				{ 
					_vecDir.transformBy(ps2ms);_vecDir.normalize();
					_vecPerp.transformBy(ps2ms);_vecPerp.normalize();
					
				}
				Point3d _ptCen = ptCen;
				_ptCen.transformBy(ps2ms);
				Point3d _pts[] = Line(_ptCen,_vecDir).orderPoints(ptsC);
				Point3d ptsPerp[] = Line(_ptCen,_vecPerp).orderPoints(ptsC);
				if (_pts.length()>0)
				{ 
					Point3d pt1 = _pts[0], pt2 = _pts[_pts.length() - 1];
					//pt1.vis(2);pt2.vis(2);
					String s1; s1.formatUnit(_vecDir.dotProduct(_ptCen-pt1), sDimStyle);
					String s2; s2.formatUnit(_vecDir.dotProduct(pt2-_ptCen), sDimStyle);
					dp.draw(s1, ptCen-vecDir*dDeltaTxt, vecDir, vecPerp, -1, 0, _kDevice);
					dp.draw(s2, ptCen+vecDir*dDeltaTxt, vecDir, vecPerp, 1, 0,_kDevice);
				}	
				_pts = Line(_ptCen,_vecPerp).orderPoints(ptsC);
				if (_pts.length()>0)
				{ 
					Point3d pt1 = _pts[0], pt2 = _pts[_pts.length() - 1];
					//pt1.vis(2);pt2.vis(2);
					String s1; s1.formatUnit(_vecPerp.dotProduct(_ptCen-pt1), sDimStyle);
					String s2; s2.formatUnit(_vecPerp.dotProduct(pt2-_ptCen), sDimStyle);
					dp.draw(s1, ptCen-vecPerp*dDeltaTxt, vecPerp,-vecDir, -1, 0, _kDevice);
					dp.draw(s2, ptCen+vecPerp*dDeltaTxt, vecPerp,-vecDir, 1, 0,_kDevice);
				}				
			}

		// draw text
			double d = (dThisSize < dTextHeight * 2 ? dTextHeight * 2 : dThisSize) * .6;
			double y = dp.textHeightForStyle(sText, sDimStyle, dTextHeight)*.5+d;
			double x = dp.textLengthForStyle(sText, sDimStyle, dTextHeight)*.5+d;		
		
			if (sText.length()>0 && bAddCoordinate)
			{
				Point3d pt = ptCen +vecDir *x + vecPerp*y;
				dp.draw(sText, pt, vecDir,vecPerp,0,0,_kDevice);
				if (bHasSDV)//HSB-9621
				{
					PlaneProfile pp; pp.createRectangle(LineSeg(pt - .5*vecDir*x-.5*vecPerp*y, pt + .5*vecDir*x + vecPerp * .5 * y), vecDir, vecPerp);
					ppProtect.unionWith(pp);
				}				
			}
			else if (sText.length()>0)
			{
				Point3d pt = ptCen + vecDir * d;
				dp.draw(sText, pt , vecDir,vecPerp,1,0,_kDevice);	
				
				if (bHasSDV)//HSB-9621
				{
					PlaneProfile pp; pp.createRectangle(LineSeg(pt - vecPerp * .5 * y, pt + vecDir * x + vecPerp * .5 * y), vecDir, vecPerp);
					ppProtect.unionWith(pp);
				}
				
			}
			
			
		}
	
	// store protection in submapX of entCollector //HSB-9621
		if (bHasSDV)
		{ 
			Map mapX = entMultipage.subMapX("ProtectArea");
			PlaneProfile pp = mapX.getPlaneProfile("ppProtect");
			pp.unionWith(ppProtect);
			mapX.setPlaneProfile("ppProtect", pp);
			entMultipage.setSubMapX("ProtectArea", mapX);
			//reportMessage(TN("|Protection area stored| ") + ppProtect.area() + " by " + scriptName());
		}
	
	}


// write weight into mapX of an individual entity
	if (el.bIsValid())
	{
		String sExt = "ExtendedProperties";	
		Map map = el.subMapX(sExt)	;
		map.setDouble("Weight", dWeight);
		map.setPoint3d("ptCen", ptCen);
		el.setSubMapX(sExt,map);	
	}



// TriggerFlipSide
	int bShowDependecies = _Map.getInt("ShowDependecies");
	String sTriggerShowDependecies = bShowDependecies?T("|Hide dependencies|"):T("|Show dependencies|");
	addRecalcTrigger(_kContext, sTriggerShowDependecies );
	if (_bOnRecalc && _kExecuteKey==sTriggerShowDependecies)
	{
		if (bShowDependecies)bShowDependecies=false;
		else bShowDependecies=true;
		 _Map.setInt("ShowDependecies",bShowDependecies);
		setExecutionLoops(2);
		return;
	}

// show dependencies	
	if (bShowDependecies )
	{
	// rebuild the collection if massgroups where found
		Entity entsExtended[0];
		for (int e=0;e<ents.length();e++)
		{
			if (ents[e].bIsKindOf(MassGroup()))
			{
				MassGroup mg =(MassGroup)ents[e];
				entsExtended.append(mg.entity());
			}
			else
				entsExtended.append(ents[e]);	
		}
		ents=entsExtended;	// reassign			
		
		for (int e=0;e<ents.length();e++)
		{
			Body bd =ents[e].realBody();
			if (bd.volume()<pow(dEps,3))continue; 
			Point3d ptRef =bd.ptCen();
			if(bHasViewport)ptRef.transformBy(ms2ps); 
			dp.draw(PLine(ptRef,ptCen));
		}	
	}

	_ThisInst.setSequenceNumber(10000);






#End
#BeginThumbnail
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
;JW*JL:_,N66NELHFM[*"%MNZ.-5.*L44`?_9
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
        <int nm="BreakPoint" vl="1993" />
        <int nm="BreakPoint" vl="1992" />
        <int nm="BreakPoint" vl="1792" />
        <int nm="BreakPoint" vl="1691" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24576: For tsls with no realbody, try to get the realbody from iso direction; include HSB_E-Insulation when getting element tsls" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="32" />
      <str nm="Date" vl="11/4/2025 11:10:51 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23906 bugfix if material not set with one component defined" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="31" />
      <str nm="Date" vl="10/15/2025 1:58:48 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22284 debug message removed" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="30" />
      <str nm="Date" vl="4/10/2025 9:27:59 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22284 MetalPartCollectionEntities of elements added, style based data considered for COG calculation" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="29" />
      <str nm="Date" vl="3/17/2025 5:40:35 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23445: Make sure nonzero value when dividing" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="28" />
      <str nm="Date" vl="2/4/2025 8:44:07 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23011: Cleanup the calculation for Baufritz" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="27" />
      <str nm="Date" vl="11/20/2024 9:43:41 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20484: When using the density from mapx, it is in kg/unit3. No transformation in &quot;mm&quot; needed" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="26" />
      <str nm="Date" vl="6/7/2024 1:34:47 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20484: Consider mapX densities in &quot;OpeningCOG&quot;" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="25" />
      <str nm="Date" vl="5/27/2024 9:29:32 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21836: Consider element when in viewport in layout" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="24" />
      <str nm="Date" vl="4/8/2024 11:46:00 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21284 dynamic update of genbeam submap if not element related" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="23" />
      <str nm="Date" vl="2/22/2024 3:30:10 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21284 dependency og linked genbeams added " />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="22" />
      <str nm="Date" vl="2/19/2024 8:43:22 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21286: only update painter catalog when property &quot;painter&quot; is changed" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="21" />
      <str nm="Date" vl="2/1/2024 11:43:52 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21242 performance improved when attached to elements, automatic rereading on missing density data disabled" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="20" />
      <str nm="Date" vl="1/30/2024 9:59:48 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Make sure mapobject is only updated when it is different, otherwise the dependencyondictobject causes lot of retriggers" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="19" />
      <str nm="Date" vl="10/5/2023 3:10:59 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20024: Write weight in mapX of genbeams on _bOnviewportsSetInLayout" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="18" />
      <str nm="Date" vl="9/11/2023 4:37:00 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19480: from attached tsls include only hsbElementInsulation; We dont need other volumetric tsls that might consume the element" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="17" />
      <str nm="Date" vl="7/17/2023 9:15:11 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19480: For element, Include attached tsls, not only those in the group" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="16" />
      <str nm="Date" vl="7/13/2023 5:03:31 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19249 resolving of text fixed" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="15" />
      <str nm="Date" vl="6/22/2023 2:23:54 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18650  all displays published for share and make" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="14" />
      <str nm="Date" vl="5/12/2023 9:53:55 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18650 standard display published for share and make" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="13" />
      <str nm="Date" vl="5/10/2023 1:04:40 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18360: Fo rpanels go in lumps only if component realbody not OK" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="12" />
      <str nm="Date" vl="3/17/2023 11:06:25 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16692: Add painter filter" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="11" />
      <str nm="Date" vl="1/10/2023 3:13:11 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="14257655: write &quot;RL&quot; instead of &quot;Rl&quot; to avoid confusion between capital &quot;i&quot; or lowercase &quot;L&quot;" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="10" />
      <str nm="Date" vl="12/1/2022 9:12:07 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-9869: Distinguish between composite and non-composite beams" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="10/31/2022 4:58:50 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16848: Remove OPM name &quot;-Insert&quot;; use hidden variables" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="10/19/2022 8:39:20 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15062: Consider TSLs that contain mapX &quot;CenterOfGravity&quot; and provide &quot;Center&quot; and &quot;Weight&quot;" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="9/30/2022 9:26:37 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13481: ignore only entities with 0 volume that are not opening assembly. opening assemblies have a volume from their subcomponents" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="10/13/2021 5:06:49 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13481: when found use BF-OpeningCenterOfGravity for calculation of openings" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="10/13/2021 8:30:41 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-10308 using new dll location" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="6/10/2021 12:14:06 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End