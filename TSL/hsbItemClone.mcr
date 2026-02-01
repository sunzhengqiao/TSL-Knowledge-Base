#Version 8
#BeginDescription
#Versions: 
Version 1.11 01.02.2024 HSB-21273 collection via freight items supported. items referenced via freight item will be sorted by package

1.10 13.11.2023 HSB-20615: Implement graindirection check
1.9 13.11.2023 HSB-20615: Add trigger to show/hide grain direction in model
version value="1.8" date="20oct2020" HSB-9338 internal naming bugfix </version>
HSB-7236 bugfix sheet grain direction rules


supports bodyImporter, bugfix location panel
supports all genbeam types and supports special nesting

This tsl creates a flattend display of a genbeam and sorts it by style and/or custom criterias.



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 11
#KeyWords Nesting;plan view; child
#BeginContents
//region Part 1
/// <History>//region
/// #Versions:
// 1.11 01.02.2024 HSB-21273 collection via freight items supported. items referenced via freight item will be sorted by package , Author Thorsten Huck
// 1.10 13.11.2023 HSB-20615: Implement graindirection check for Baufritz Author: Marsel Nakuci
// 1.9 13.11.2023 HSB-20615: Add trigger to show/hide grain direction in model Author: Marsel Nakuci
/// <version value="1.8" date="20oct2020" author="thorsten.huck@hsbcad.com"> HSB-9338 internal naming bugfix </version>
/// <version value="1.7" date="07apr2020" author="thorsten.huck@hsbcad.com"> HSB-7236 bugfix sheet grain direction rules </version>
/// <version value="1.6" date="19feb2020" author="thorsten.huck@hsbcad.com"> HSB-6716 new display properties LengthGrain and WidthGrain introduced </version>
/// <version value="1.5" date="18feb2020" author="thorsten.huck@hsbcad.com"> HSB-6716 filter rules introduced, new sheet grain alignments, grain symbol display enhanced </version>
/// <version value="1.4" date="04oct2019" author="thorsten.huck@hsbcad.com"> HSB-5710 bugfix if no grain direction set against panels </version>
/// <version value="1.3" date="17sep2019" author="thorsten.huck@hsbcad.com"> default property adjusted to \P syntax</version>
/// <version value="1.2" date="09Apr2019" author="thorsten.huck@hsbcad.com"> new parameters in settings, line feed now done with '\P' </version>
/// <version value="1.1" date="04Oct2018" author="thorsten.huck@hsbcad.com"> supports bodyImporter, bugfix location panel </version>
/// <version value="1.1" date="12sep2018" author="thorsten.huck@hsbcad.com"> supports all genbeam types and supports special nesting </version>
/// <version value="1.0" date="15may2018" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select genbeam, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates a flattend display of a genbeam and sorts it by style and/or custom criterias.
/// </summary>//endregion

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
	
// family key words
	String sItemX = "Hsb_ItemClone";		


	double dMaxRowLength = U(25000);
	double dDistToNext = U(500);
	int nDisplayMode;
	String sProjectSpecial=projectSpecial();
	sProjectSpecial.trimLeft();
	sProjectSpecial.trimRight();
	int bIsBaufritz=sProjectSpecial.makeUpper()=="BAUFRITZ";
	
	String kDataLink = "DataLink", kScriptItem = "hsbFreight-Item";
//end Constants//endregion

//region Functions

	//region Function filterTslsByName
	// returns all tsl instances with a certain scriptname
	// ents: the array to search, if empty all tsls in modelspace are taken
	// names: the names of the tsls to be returned, all if empty
	TslInst[] filterTslsByName(Entity ents[], String names[])
	{ 
		TslInst out[0];
		int bAll = names.length() < 1;
		
		if (ents.length()<1)
			ents = Group().collectEntities(true, TslInst(),  _kModelSpace);
		
		for (int i=0;i<ents.length();i++) 
		{ 
			TslInst t= (TslInst)ents[i]; 
			//reportNotice("\ngetTslsByName: " + t.scriptName() +" "+names);
			if (t.bIsValid())
			{
				if (!bAll && names.findNoCase(t.scriptName(),-1)>-1)
					out.append(t);	
				else if (bAll)
					out.append(t);									
			}
				
		}//next i

		return out;
	
	}//End filterTslsByName //endregion
	
	
	
//endregion 


//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sFileName ="hsbItemClone";
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
//End Settings
	
	
// build a default map if no settings are found
	int bExportDefaultSetting;
	
	String _sDimStyle,sLineTypeBody,sLineTypeOversize;
	double _dTextHeight,dLineTypeScaleBody=1,dLineTypeScaleOversize=1;
	int nc=7, ncOversize=1, ncGrainWall=12, ncGrainRoof=34, ncBody=7;
	
	if (mapSetting.length()<1)
	{ 
		Map mapDefault;
		
		Map mapSorts;
		{ 
			Map mapOrderBy,mapOrderBys, mapSort;
			mapOrderBy.setString("Property", "Name");
			mapOrderBy.setInt("IsAscending", true);
			mapOrderBys.appendMap("OrderBy", mapOrderBy);
			mapSort.setString("Name", T("|Name ascending|"));
			mapSort.appendMap("OrderBys", mapOrderBys);	
			mapSorts.appendMap("Sort", mapSort);
		}
		{ 
			Map mapOrderBy,mapOrderBys, mapSort;
			mapOrderBy.setString("Property", "SolidLength");
			mapOrderBy.setInt("IsAscending", true);
			mapOrderBys.appendMap("OrderBy", mapOrderBy);

			mapOrderBy.setString("Property", "SolidWidth");
			mapOrderBy.setInt("IsAscending", true);
			mapOrderBys.appendMap("OrderBy", mapOrderBy);

			mapSort.setString("Name", T("|Length and Width ascending|"));
			mapSort.appendMap("OrderBy[]", mapOrderBys);	
			mapSorts.appendMap("Sort", mapSort);
		}
		mapDefault.appendMap("Sort[]", mapSorts);

		mapDefault.setDouble("MaxRowLength",dMaxRowLength);
		mapDefault.setDouble("Interdistance",dDistToNext);
		mapDefault.setInt("DisplayMode",nDisplayMode);

		mapSetting = mapDefault;
		bExportDefaultSetting = true;
	}
	else
	{ 
		String k;
		Map m= mapSetting;
		k = "MaxRowLength"; 	if (m.hasDouble(k))dMaxRowLength = m.getDouble(k);
		k = "Interdistance"; 	if (m.hasDouble(k))dDistToNext = m.getDouble(k);	
		k = "DisplayMode"; 		if (m.hasInt(k))nDisplayMode = m.getInt(k);	

		k = "Display\\Text"; 	if (mapSetting.hasMap(k))m = mapSetting.getMap(k);
		k = "TextHeight"; 		if (m.hasDouble(k))_dTextHeight = m.getDouble(k);
		k = "DimStyle"; 		if (m.hasString(k))_sDimStyle= m.getString(k);
		k = "Color"; 			if (m.hasInt(k))nc = m.getInt(k);

		k = "Display\\Body"; 			if (mapSetting.hasMap(k))m = mapSetting.getMap(k);
		k = "LineType"; 		if (m.hasString(k))sLineTypeBody = m.getString(k).makeUpper();			
		k = "LineTypeScale"; 	if (m.getDouble(k)>0)dLineTypeScaleBody = m.getDouble(k);
		k = "Color"; 			if (m.hasInt(k))nc = m.getInt(k);	

		k = "Display\\Oversize"; 		if (mapSetting.hasMap(k))m = mapSetting.getMap(k);
		k = "LineType"; 		if (m.hasString(k))sLineTypeOversize = m.getString(k).makeUpper();			
		k = "LineTypeScale"; 	if (m.getDouble(k)>0)dLineTypeScaleOversize = m.getDouble(k);
		k = "Color"; 			if (m.hasInt(k))ncOversize = m.getInt(k);	

		k = "Display\\GrainDirection"; 	if (mapSetting.hasMap(k))m = mapSetting.getMap(k);
		k = "ColorWall"; 		if (m.hasInt(k))ncGrainWall = m.getInt(k);
		k = "ColorRoof"; 		if (m.hasInt(k))ncGrainRoof = m.getInt(k);
	}

//endregion	

//region SELECTION SET (deprecated if FilterRules found)
// get general selection set if defined
	String sSupportedClasses[] ={ "genbeam", "sheet", "beam", "sip", "entpline", "tslinst.bodyimporter"};
	String sSupportedTslNames[] = { "bodyimporter"};
	String sTslNames[0];
	Map mapSelectionSet = mapSetting.getMap("SelectionSet");	
	Map mapAllowedClasses = mapSelectionSet.getMap("AllowedClass[]");
	
//End SELECTION SET deprecated if FilterRules found//endregion 

//region FILTER RULES
	Map mapFilterRules= mapSetting.getMap("FilterRule[]"), mapFilterRule;
	String sRules[0];
// get applicable rules
	{ 
		String k; Map m;
		for (int i=0;i<mapFilterRules.length();i++) 
		{ 
			m = mapFilterRules.getMap(i); 
			String name;
			int _nType;
			k="Name";		if (m.hasString(k))		name=T(m.getString(k));
			//k="Type";		if (m.hasInt(k))		_nType=m.getInt(k);
			if (sRules.find(name)<0 && name.length()>0)//&& (nType==0 ||nType==_nType))
				sRules.append(name);	 
		}//next i		
	}
	sRules = sRules.sorted();
	sRules.insertAt(0, T("|<Disabled>|"));		
//End FILTER RULES//endregion 

//region Properties
	category = T("|Item|");
	
// RULE	
	String sRuleName=T("|Rule|");
	PropString sRule(3, sRules, sRuleName);	 // prev Index 8
	sRule.setDescription(T("|Specifies a filter rule.|"));
	sRule.setCategory(category);
	if (sRules.length() < 2)sRule.setReadOnly(true);
	if (sRules.find(sRule) < 0  && sRules.length()>0)sRule.set(sRules.first());

// SORTING
	Map mapSort = mapSetting.getMap("Sort[]");
	String sSortings[0];
	for (int i = 0; i < mapSort.length(); i++)
	{
		Map m = mapSort.getMap(i);
		String sEntry = m.getString("Name");
		if (sEntry.length() > 0 && sSortings.find(sEntry) < 0)
			sSortings.append(sEntry);
	}
	String sSortingName=T("|Sorting|");	
	PropString sSorting(nStringIndex++, sSortings, sSortingName);	
	sSorting.setDescription(T("|Defines the Sorting|"));
	sSorting.setCategory(category);
	if (sSortings.length() < 2)sSorting.setReadOnly(true);

//OVERSIZE
	String sOversizeName=T("|Oversize|");	
	PropDouble dOversize(nDoubleIndex++, U(0), sOversizeName);	
	dOversize.setDescription(T("|Defines the oversize of the item.|"));
	dOversize.setCategory(category);

// Display
	category = T("|Display|");
	
// Format
	String sAttributeName=T("|Format|");	
	PropString sAttribute(nStringIndex++, "@(PosNum)\P@(Length) x @(Width)", sAttributeName);	
	sAttribute.setDescription(T("|Defines the text and/or attributes.|") + " " + T("|Multiple lines are separated by|") + " '\\P'" + " " + T("|Attributes can also be added or removed by context commands.|"));
	sAttribute.setCategory(category);	
	
	
	String sDimStyleName=T("|DimStyle|");	
	PropString sDimStyle(nStringIndex++, _DimStyles.sorted(), sDimStyleName);
	if (_DimStyles.find(_sDimStyle)>-1) // if defined in settings use the value as readonly
	{ 
		sDimStyle.setReadOnly(true);
		if (sDimStyle != _sDimStyle)sDimStyle.set(_sDimStyle);
	}
	sDimStyle.setDescription(T("|Defines the DimStyle|"));
	sDimStyle.setCategory(category);
	
	String sTextHeightName=T("|Text Height|");
	PropDouble dTextHeight(nDoubleIndex++, U(0), sTextHeightName);	
	if (_dTextHeight>0) // if defined in settings use the value as readonly
	{ 
		dTextHeight.setReadOnly(true);
		if (dTextHeight != _dTextHeight)dTextHeight.set(_dTextHeight);
		dTextHeight.setDescription(T("|Specifies the text height|"));
	}	
	else
		dTextHeight.setDescription(T("|Overrides the Text Height|") + T(" |0 = by dimstyle|"));
	dTextHeight.setCategory(category);		
	
//End Properties//endregion 

//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }

	// silent/dialog
		String sKey = _kExecuteKey;
		sKey.makeUpper();
		int bShowDialog=true;
		
		if (sKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName()+"-Frame");
			for(int i=0;i<sEntries.length();i++)
				sEntries[i] = sEntries[i].makeUpper();	
			if (sEntries.length()>0 && sEntries.find(sKey)>-1)
			{
				setPropValuesFromCatalog(sKey);
				bShowDialog=false;
			}				
		}	
		if (bShowDialog)	
			showDialog();
	
	// get potential override of the selection set
		for (int i = 0; i < mapSort.length(); i++)
		{
			Map m = mapSort.getMap(i);
			String sEntry = m.getString("Name");
			//reportMessage("\nEntry = " + sEntry);
			if (sEntry != sSorting)continue;
			
		// get general selection set if defined
			Map mapSelectionSet2 = mapSort.getMap(i).getMap("SelectionSet");
			if(mapSelectionSet2.length()>0)
				mapSelectionSet = mapSelectionSet2;	
		}
		
	//region GetFilterRule
		int nRule = sRules.find(sRule);
		Map mapFormats;
		if (nRule>0)
		{ 
			for (int i=0;i<mapFilterRules.length();i++) 
			{ 
				Map m= mapFilterRules.getMap(i);
				if (T(m.getString("Name"))==sRule)
				{ 
					mapFilterRule = m;
					mapAllowedClasses = m.getMap("AllowedClass[]");
					mapFormats = m.getMap("Format[]");
					break;
				}		 
			}//next i
			if(bDebug)reportMessage("\nRule " + nRule + " formats (" +mapFormats.length()+") "+ mapFormats + " maps " + mapFormats.getMap(0));	
		}
	//End GetFilterRule//endregion 	

	//region Freight Specials
		String sAllTslNames[] = TslScript().getAllEntryNames();	
		int bHasFreightItem = sAllTslNames.findNoCase(kScriptItem ,- 1);
		
	//endregion 



	// select source entities
		PrEntity ssE;
		String sAllowedClasses[0];
		String msg3 = + (bHasFreightItem ? T(", |Freight Items|") : "");
		if(mapAllowedClasses.length()<1)
		{
			String prompt = T("|Select source genbeams|") + msg3;
			ssE = PrEntity(prompt,GenBeam());
			if (bHasFreightItem)
				ssE.addAllowedClass(TslInst());
		}
		else
		{ 
			String sMsg = T("|Select source entities| ");
			String sMsg2;
			for (int i=0;i<mapAllowedClasses.length();i++) 
			{ 
				String sAllowedClass = mapAllowedClasses.getString(i).makeLower();
				int bClassFound = sAllowedClasses.findNoCase(sAllowedClass,false);
				int nSupportedClass = sSupportedClasses.findNoCase(sAllowedClass,-1);

				if (bClassFound || nSupportedClass<0)continue;
				if (sMsg2.length() > 0)sMsg2 += ", ";
				if(nSupportedClass==0)
				{ 
					sMsg2 += T("|GenBeam|")+msg3;
					if (sAllowedClasses.length()<1)			ssE = PrEntity(sMsg+"("+sMsg2+")",GenBeam());	
					else									{ssE.addAllowedClass(GenBeam());	sAllowedClasses.append(sAllowedClass);}
				}
				else if(nSupportedClass==1)
				{ 
					sMsg2 += T("|Sheet|")+ msg3;
					if (sAllowedClasses.length()<1)			ssE = PrEntity(sMsg+"("+sMsg2+")",Sheet());	
					else									{ssE.addAllowedClass(Sheet());		sAllowedClasses.append(sAllowedClass);			}
				}	
				else if(nSupportedClass==2)
				{ 
					sMsg2 += T("|Beam|")+ msg3;
					if (sAllowedClasses.length()<1)			ssE = PrEntity(sMsg+"("+sMsg2+")",Beam());	
					else									{ssE.addAllowedClass(Beam());		sAllowedClasses.append(sAllowedClass);			}
				}					
				else if(nSupportedClass==3)
				{ 
					sMsg2 += T("|Panel|")+ msg3;
					if (sAllowedClasses.length()<1)			ssE = PrEntity(sMsg+"("+sMsg2+")",Sip());	
					else									{ssE.addAllowedClass(Sip());		sAllowedClasses.append(sAllowedClass);			}
				}
				else if(nSupportedClass==4)
				{ 
					sMsg2 += T("|Polyline|");
					if (sAllowedClasses.length()<1)			ssE = PrEntity(sMsg+"("+sMsg2+")",EntPLine());	
					else									{ssE.addAllowedClass(EntPLine());	sAllowedClasses.append(sAllowedClass);				}
				}
				else if(nSupportedClass==5)
				{ 
					sMsg2 += T("|BodyImporter|");
					if (sAllowedClasses.length()<1)			ssE = PrEntity(sMsg+"("+sMsg2+")",TslInst());	
					else									{ssE.addAllowedClass(TslInst());	sAllowedClasses.append(sAllowedClass);}
					sTslNames.append(sSupportedTslNames[0]);
				}				
				if (bHasFreightItem)
					ssE.addAllowedClass(TslInst());
			}//next i
		}

	// run prompt
		ssE.allowNested(true);
		if (ssE.go())
			_Entity= ssE.set();
		
		
	//region Collect defining entities of selected Freight Items
		int bFreightSelected;
		if (bHasFreightItem)
		{ 
			String names[] ={ kScriptItem};
			TslInst items[] = filterTslsByName(_Entity, names);
			
			for (int i=0;i<items.length();i++) 
			{ 
				GenBeam gbs[]=items[i].genBeam();
				if (gbs.length()>0 && _Entity.find(gbs.first())<0)
				{
					_Entity.append(gbs.first());
					bFreightSelected = true;
				}
				 
			}//next i
			
		}
	//endregion 	
		
		
		
		
		
	// purge invalid tsl's
		for (int i=_Entity.length()-1; i>=0 ; i--) 
		{ 
			TslInst tsl=(TslInst)_Entity[i]; 
			if (!tsl.bIsValid())continue;
			
		// remove unsupported tsls
			String scriptName = tsl.scriptName();
			if (bDebug)reportMessage("\nscript " + scriptName + " found");
			if (sSupportedTslNames.findNoCase(scriptName,-1)<0)
			{
				if (bDebug)reportMessage("\nremoving script " + scriptName + " found");
				_Entity.removeAt(i);
			}
		}//next i

	// run filter
	// check format rules for genbeams
		if (mapFormats.length()>0)
		for (int i = _Entity.length() - 1; i >= 0; i--)
		{
			Entity ent = _Entity[i];
			int type = - 1;
			GenBeam gb = (GenBeam)ent;
			if (gb.bIsValid())type = 0;
			
			if (ent.bIsKindOf(Sheet()))type = 1;
			else if (ent.bIsKindOf(Beam()))type = 2;
			else if (ent.bIsKindOf(Sip()))type = 3;			
			
			if (type < 0)continue;

			int bAdd = true;
			for (int j = 0; j < mapFormats.length(); j++)
			{
				Map m = mapFormats.getMap(j);
				String format = m.getString("Format");
				String values[0];
				if (m.hasMap("Value[]"))
				{ 
					Map m2 = m.getMap("Value[]");
					for (int k=0;k<m2.length();k++) 
					{ 
						if(m2.hasString(k) && m2.keyAt(k).makeUpper()=="VALUE")
							values.append(m2.getString(k));
						 
					}//next k
					
				}
				else if (m.hasString("Value"))
					values.append(m.getString("Value"));

				String _value = ent.formatObject(format);
				int nOperation = m.getInt("Operation");

			// resolve unknown
				if (format.find("@(Color)",0,false)>-1)
					_value = ent.color();
				else if (format.find("@(Beamtype)",0,false)>-1 && gb.bIsValid())
					_value = _BeamTypes[gb.type()];			
				_value.makeUpper();
			
				int bMatch = values.findNoCase(_value, -1) >- 1;
				
				//reportMessage("\nValues: " + values + "\noperation: " + nOperation + " match: " + bMatch);
				// exclude operation, values match	or include operation, values do not match
				if ((nOperation == 0 && bMatch) || (nOperation == 1 && !bMatch))
				{
					bAdd = false;
					break;
				}		
			}
			if (!bAdd)
			{
				if(bDebug)reportMessage("\n" +gb.material() + " refused");
				_Entity.removeAt(i);
			}
		}
	
		_Map.setInt("mode", 1);	
		_Map.setInt("FreightSelected", bFreightSelected);

			
	// prompt for location
		Point3d ptFrom, ptTo;
		{ 
			Point3d pts[0];
			for (int i=0;i<_Entity.length();i++) 
			{ 
				Entity ent = _Entity[i];
				PLine pl = ent.getPLine();
				Point3d _pts[] = pl.vertexPoints(true);
				if (_pts.length()>0)
				{ 
					Point3d pt;
					pt.setToAverage(_pts);
					pts.append(pt);
				}
				else
				{ 
					Body bd = ent.realBody();
					if (bd.volume()>pow(dEps,3))
						pts.append(bd.ptCen());
				}
			}//next i
			if (pts.length()>0)
				ptFrom.setToAverage(pts);
			else
				ptFrom = getPoint(T("|Pick base point|"));
		}

		Point3d pts[0];
		while (pts.length()<1) 
		{
			PrPoint ssP("\n" + T("|Select target location|"),ptFrom); 
			if (ssP.go()==_kOk) 
				pts.append(ssP.value()); // append the selected points to the list of grippoints _PtG
			else
				break; // out of infinite while
		}
		if (pts.length()>0)
			_Pt0=pts[0];
		else
			eraseInstance();
		return;
	}	
// end on insert	__________________//endregion	

//region general, both modes
// get mode
	// 0 = item mode
	// 1 = frame/collector mode
	int nMode = _Map.getInt("mode");
	//sRule.setReadOnly(true);


//region GetFilterRule
	int nRule = sRules.find(sRule);
	Map mapFormats;
	if (nRule>0)
	{ 
		for (int i=0;i<mapFilterRules.length();i++) 
		{ 
			Map m= mapFilterRules.getMap(i);
			if (T(m.getString("Name"))==sRule)
			{ 
				mapFilterRule = m;
				mapAllowedClasses = m.getMap("AllowedClass[]");
				mapFormats = m.getMap("Format[]");
				break;
			}		 
		}//next i
	}
//End GetFilterRule//endregion 	



// get global mapping of a sheet grain direction
	int nGrainDirectionSheet=mapSetting.getInt("GrainDirectionSheet");
	{ 
		String k;
		Map m = mapSetting;
		k = "GrainDirectionSheet"; if (m.hasInt(k))nGrainDirectionSheet = m.getInt(k);
		m=mapFilterRule;
		k = "GrainDirectionSheet"; if (m.hasInt(k))nGrainDirectionSheet = m.getInt(k);
		
	}
	// 0 = byEntity X
	// 1 = byEntity Y
	// 2 = byElement X
	// 3 = byElement Y	
	// 4 = biggest dim
	// 5 = smallest dim
	if (0 && bDebug)nGrainDirectionSheet = _ThisInst.color();
	
// display
	Display dpText(nc), dpModel(ncBody);	
	dpText.dimStyle(sDimStyle);
	double dFactor = 1;
	double dTextHeightStyle = dpText.textHeightForStyle("O",sDimStyle);	
	if (dTextHeight>0)
	{
		dFactor=dTextHeight/dTextHeightStyle;
		dTextHeightStyle=dTextHeight;
		dpText.textHeight(dTextHeight);
	}
	dTextHeightStyle=dTextHeightStyle<U(10)?U(10):dTextHeightStyle;	

	
//endregion End general, both modes

		
//End Part 1//endregion 

//region Mode 0: item mode
	if (nMode==0)	
	{ 
		if (!bDebug)sSorting.setReadOnly(true);
		
	//region Validate entDefine and cast
		Entity entDef;
		GenBeam gb;
		Sip sip;
		Sheet sheet;
		Beam beam;
		Element el;
		TslInst tsl;
		ChildPanel child;
		if (_Entity.length()>0)
		{
			entDef = _Entity[0];
			gb= (GenBeam)entDef;
			tsl= (TslInst)entDef;
			child = (ChildPanel)entDef;
		}
		else if (_GenBeam.length()>0)
		{ 
			gb =  _GenBeam[0]; 
			entDef = gb;
		}
		Quader qdr;

	// Display
		nc = entDef.color();
		dpText.color(nc);
		dpModel.color(ncBody);
		if (_LineTypes.find(sLineTypeBody)>-1)dpModel.lineType(sLineTypeBody, dLineTypeScaleBody);
	
	// CoordSys
		CoordSys csDef, cs2Clone;
		CoordSys cs2Model;
		PlaneProfile ppShape;
		_Pt0.setZ(0);
		Point3d ptOrgE = _Pt0;
		//_XE.vis(_Pt0, 1);		_YE.vis(_Pt0, 3);		_ZE.vis(_Pt0, 150);

	// declare variables of the raw dimensions
		double dLength, dWidth; // the XY dimensions
		Body bd;
		Vector3d vecX, vecY, vecZ;

	//region Sip & tsl specifics
		int nQualityTop, nQualityBottom;
		Vector3d vecXGrain, vecYGrain;
		int nRowGrain = - 1;
		double dLengthBeforeGrain; // the potential line number of the grain symbol and the amount of characters in the same row befor symbol
		String sqTop,sqBottom; 
		SipComponent components[0];
		HardWrComp hwcs[0];			
	//End Validate entDefine and cast//endregion 

	
	//region GenBeam
		if (gb.bIsValid())
		{
			el = gb.element();
			sip = (Sip)gb;
			sheet = (Sheet)gb;
			beam = (Beam)gb;
			vecX = gb.vecX();
			vecY = gb.vecY();
			vecZ = gb.vecZ();
			ptOrgE = gb.ptCenSolid();ptOrgE.vis(2);
			qdr=Quader(ptOrgE, vecX, vecY, vecZ, gb.dL(), gb.dW(), gb.dH(), 0, 0, 0);	

		// stream body	
			if (nDisplayMode==1)	bd= gb.realBody();				
			else					bd= gb.envelopeBody(true,true);					

		//region Get coordSy and shape of SHEET
			if (sheet.bIsValid())
			{		
				ppShape = sheet.profShape();
				if (nGrainDirectionSheet==1 || (!el.bIsValid() && nGrainDirectionSheet==3))
				{ 
					vecX = vecY;
					vecY = vecX.crossProduct(-vecZ);
				}
				else if (nGrainDirectionSheet==2 && el.bIsValid())
				{ 
					vecX = el.vecX();
					vecY = el.vecY();
					vecZ = el.vecZ();
				}
				else if (nGrainDirectionSheet==3 && el.bIsValid())
				{ 
					vecX = el.vecY();
					vecZ = el.vecZ();
					vecY = vecX.crossProduct(-vecZ);	
				}
				else if (nGrainDirectionSheet==4 && sheet.dL()<sheet.dW())
				{ 
					vecX = vecY;
					vecY = vecX.crossProduct(-vecZ);					
				}
				else if (nGrainDirectionSheet==5 && sheet.dL()>sheet.dW())
				{ 
					vecX = vecY;
					vecY = vecX.crossProduct(-vecZ);					
				}
				
//				if (nGrainDirectionSheet ==2 || nGrainDirectionSheet ==3)
//				{ 
//					vecXGrain = vecX;
//					vecYGrain = vecY;
//				}
//				else 
				if (nGrainDirectionSheet > -1 && nGrainDirectionSheet<2)
				{
					vecXGrain = gb.vecX();
					vecYGrain = gb.vecY();

				}
				else
				{ 
					vecXGrain = vecX;
					vecYGrain = vecY;
				}				
			// get shape	
				ppShape = PlaneProfile(CoordSys(ptOrgE, vecX, vecY, vecZ));
				PLine plRings[]=bd.shadowProfile(Plane(bd.ptCen(), vecZ)).allRings(true,false);
				for (int r=0;r<plRings.length();r++) 
					ppShape.joinRing(plRings[r], _kAdd);					
			}				
		//End // get coordSy and shape of SHEET//endregion 
		
		//region Get coordSy and shape of SIP
			else if (sip.bIsValid())
			{
				vecX = sip.woodGrainDirection().bIsZeroLength()?vecX:sip.woodGrainDirection();
				vecY = vecX.crossProduct(-vecZ);

			// get shape	
				ppShape = PlaneProfile(CoordSys(ptOrgE, vecX, vecY, vecZ));
				PLine plRings[]=bd.shadowProfile(Plane(bd.ptCen(), vecZ)).allRings(true,false);
				for (int r=0;r<plRings.length();r++) 
				{
					plRings[r].vis(1);
					ppShape.joinRing(plRings[r], _kAdd);
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

				//ptCen = sip.ptCen();
				//
				//ms2ps.setToAlignCoordSys(ptCen, sip.vecX(), sip.vecY(), sip.vecZ(), ptCen, vecXView , vecYView, vecZView);
				//ptCen.transformBy(ms2ps);
				
				vecXGrain = sip.woodGrainDirection();
				vecYGrain = vecXGrain.crossProduct(sip.vecZ());
				if (!vecXGrain.bIsZeroLength())
				{
					if (child.bIsValid())
					{
						vecXGrain.transformBy(child.sipToMeTransformation());
						vecYGrain.transformBy(child.sipToMeTransformation());
					}					
				}			
			}			
		//End // get coordSy and shape of SIP//endregion  
		
		//region Get coordSy and shape of BEAM
			else
			{
				ppShape = bd.shadowProfile(Plane(bd.ptCen(),vecZ));
			}//endregion  
		
		//region Transform body and profile to clone location and draw
			LineSeg seg = ppShape.extentInDir(gb.vecX());	//			seg.vis(2);	
			csDef = CoordSys(seg.ptMid(), vecX,vecY, vecZ);	//csDef.vis(2);	

			cs2Clone.setToAlignCoordSys(csDef.ptOrg(), csDef.vecX(), csDef.vecY(), csDef.vecZ(), _Pt0, _XE, _YE, _ZE);	
			ppShape.transformBy(cs2Clone);
			
			ppShape.coordSys().vecX().vis(_Pt0,2);
			bd.transformBy(cs2Clone);
			dpModel.draw(bd);			
			
		//apply oversize
			if (dOversize>0)
		 		ppShape.shrink(-dOversize);

		// get extents of profile
			LineSeg segShape = ppShape.extentInDir(_XE);
			//segShape.vis(2);
			dLength = abs(_XE.dotProduct(segShape.ptStart()-segShape.ptEnd()));
			dWidth = abs(_YE.dotProduct(segShape.ptStart()-segShape.ptEnd()));			
		//endregion 
		}
 					
	//End GenBeam//endregion 

	//region TSL
		else if (tsl.bIsValid())	
		{ 
		// stream body	
			bd=tsl.realBody();	
			if (bd.volume()<pow(dEps,3))
			{ 
				eraseInstance();
				return;
			}
			bd.vis(3);
			ptOrgE = bd.ptCen();
			
		// get coordSys
			Map mapX = tsl.subMapX("IfcData");
			vecX = mapX.getVector3d("vecX");
			vecY = mapX.getVector3d("vecY");
			vecZ = mapX.getVector3d("vecZ");
			
			CoordSys csDef(bd.ptCen(), vecX,vecY, vecZ);
			ppShape = bd.shadowProfile(Plane(ptOrgE, csDef.vecZ()));
			
			cs2Clone.setToAlignCoordSys(csDef.ptOrg(), csDef.vecX(), csDef.vecY(), csDef.vecZ(), _Pt0, _XE, _YE, _ZE);	
			ppShape.transformBy(cs2Clone);
			bd.transformBy(cs2Clone);
			dpModel.draw(bd);

		//apply oversize
			if (dOversize>0)
		 		ppShape.shrink(-dOversize);

		// get extents of profile
			LineSeg segShape = ppShape.extentInDir(_XE);
			segShape.vis(2);
			dLength = abs(_XE.dotProduct(segShape.ptStart()-segShape.ptEnd()));
			dWidth = abs(_YE.dotProduct(segShape.ptStart()-segShape.ptEnd()));
		}				
	//End TSL//endregion 

	//region Not Supported
		else
		{ 
			reportMessage("\n" + scriptName() + ": " +T("|the type|")  + entDef.typeDxfName() + T(" |is not supported yet.|"));
			if (!bDebug)eraseInstance();
			return;
		}			
	//End Not Supported//endregion 

		
		cs2Model = cs2Clone;
		cs2Model.invert();
		Vector3d vecZView = _ZW;
		vecZView.transformBy(cs2Model);
		vecZView.normalize();
vecXGrain.vis(_Pt0, 1);
		vecXGrain.transformBy(cs2Clone);
		vecYGrain.transformBy(cs2Clone);
		vecXGrain.normalize();vecXGrain.vis(_Pt0, 1);
		vecYGrain.normalize();					
	//endregion	
	
	//region Trigger
	
	// trigger double click / incremental rotation
		String sTriggerRotations[] = {T("|Rotate 90°|"),T("|Rotate 180°|")};
		double dRotations[] = {90,180};		
		for(int i=0;i<sTriggerRotations.length();i++)
		{
			String sTriggerRotation= sTriggerRotations[i];
			addRecalcTrigger(_kContext, sTriggerRotation);
			
			if (_bOnRecalc && (_kExecuteKey==sTriggerRotation)) 
			{
				double dRotation = dRotations[i];
				CoordSys csRot;
				csRot.setToRotation(dRotation, _ZW, _Pt0);
				_ThisInst.transformBy(csRot);
				setExecutionLoops(2);
				return;					
			}					
		}	
	
	// trigger flip face
		String sTriggerFlipFace = T("|Flip Face|");	
		addRecalcTrigger(_kContext, sTriggerFlipFace);		
		if (_bOnRecalc && (_kExecuteKey==sTriggerFlipFace)) 
		{
			CoordSys csRot;
			csRot.setToRotation(180, vecX, ptOrgE);
			_ThisInst.transformBy(csRot);
			setExecutionLoops(2);
			return;					
		}
		
		addRecalcTrigger(_kContext, "----------------------------" );
		String sTriggerSetFormat = T("|Set Format Expression|");
		addRecalcTrigger(_kContext, sTriggerSetFormat );
		if (_bOnRecalc && _kExecuteKey==sTriggerSetFormat)
		{
	
		// get list of available object variables
			String sObjectVariables[0];
		 
			String _sObjectVariables[0];
			if (beam.bIsValid()){_sObjectVariables.append(beam.formatObjectVariables());}
			else if (sheet.bIsValid()){_sObjectVariables.append(sheet.formatObjectVariables());}
			else if (sip.bIsValid()){_sObjectVariables.append(sip.formatObjectVariables());}
			else if (tsl.bIsValid()){_sObjectVariables.append(tsl.formatObjectVariables());}
			
		// append all variables, they might vary by type as different property sets could be attached
			for (int j=0;j<_sObjectVariables.length();j++)  
				if(sObjectVariables.find(_sObjectVariables[j])<0)
					sObjectVariables.append(_sObjectVariables[j]); 
			
		//region add custom variables
			{ 
				String k;
				k = "Calculate Weight"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
		
				// Sip	
				if (sip.bIsValid())
				{ 
					k = "GrainDirectionText"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
					k = "GrainDirectionTextShort"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
					k = "SurfaceQuality"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
					k = "SurfaceQualityTop"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
					k = "SurfaceQualityBottom"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);	
				}
			}	
		//End add custom variables
		
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
		//End get list of available object variables//endregion 			
				
			String sPrompt;
			sPrompt+="\n"+ T("|Select a property by index to add(+) or to remove(-)|");
			reportNotice(sPrompt);
			
			for (int s=0;s<sObjectVariables.length();s++) 
			{ 
				String key = sObjectVariables[s]; 
				String keyT = sTranslatedVariables[s];
				String value;
				String _value = entDef.formatObject("@(" + key + ")");
				if (_value.length()>0)
					value = _value;
	
				String sAddRemove = sAttribute.find(key,0, false)<0?"(+)" : "(-)";
				int x = s + 1;
				String sIndex = ((x<10)?"    " + x:"   " + x)+ "  "+sAddRemove+"  :";
				
				reportNotice("\n"+sIndex+keyT + "........: "+ value);
				
			}//next i
			int nRetVal = getInt(sPrompt)-1;
				
		// select property	
			if (nRetVal>-1 && nRetVal<=sObjectVariables.length())
			{ 
				String newAttrribute = sAttribute;
	
			// get variable	and append if not already in list	
				String variable ="@(" + sObjectVariables[nRetVal] + ")";
				int x = sAttribute.find(variable, 0);
				if (x>-1)
				{
					int y = sAttribute.find(")", x);
					String left = sAttribute.left(x);
					String right= sAttribute.right(sAttribute.length()-y-1);
					newAttrribute = left + right;
					reportMessage("\n" + sObjectVariables[nRetVal] + " new: " + newAttrribute);				
				}
				else
				{ 
					newAttrribute+="@(" +sObjectVariables[nRetVal]+")";
								
				}
				sAttribute.set(newAttrribute);
				reportMessage("\n" + sAttributeName + " " + T("|set to|")+" " +sAttribute);	
			}				
			setExecutionLoops(2);
			return;
		}	
		
	// add show / hide relathion trigger
		String sToggleRelationTrigger = T("|Show Relation|");
		int bShowRelation = _Map.getInt("ShowRelation");
		if (bShowRelation)sToggleRelationTrigger = T("|Hide Relation|");
		addRecalcTrigger(_kContext, sToggleRelationTrigger );
		if (_bOnRecalc && _kExecuteKey==sToggleRelationTrigger) 
		{
			if (bShowRelation)	bShowRelation=false;
			else bShowRelation=true;
			_Map.setInt("ShowRelation",bShowRelation);
			setExecutionLoops(2);
			return;
		}
		
	//HSB-20615: Trigger ShowGrainDirectionInModelForAllItem
		String sTriggerShowGrainDirectionInModelForAllItem = T("|Show Grain Direction In Model|");
		String sTriggerDontShowGrainDirectionInModelForAllItem = T("|Hide Grain Direction In Model|");
		addRecalcTrigger(_kContext, sTriggerShowGrainDirectionInModelForAllItem);
		addRecalcTrigger(_kContext, sTriggerDontShowGrainDirectionInModelForAllItem);
		if (_bOnRecalc && _kExecuteKey==sTriggerShowGrainDirectionInModelForAllItem
			|| _kExecuteKey==sTriggerDontShowGrainDirectionInModelForAllItem)
		{
			int bShow=_kExecuteKey==sTriggerShowGrainDirectionInModelForAllItem;
			TslInst tsls[0];
			Entity ents[]=Group().collectEntities(true,TslInst(),_kModelSpace);
			for (int i=0;i<ents.length();i++) 
			{ 
				TslInst tslI=(TslInst)ents[i];
				if(!tslI.bIsValid())continue;
				if(tslI.scriptName()!="hsbItemClone")continue;
				if(tsls.find(tslI)<0)
					tsls.append(tslI);
				Map mapI=tslI.map();
				if(bShow)
					mapI.setInt("GrainDirectionInModel",true);
				else
					mapI.setInt("GrainDirectionInModel",false);
				tslI.setMap(mapI);
				tslI.recalcNow();
			}//next i
			if(bShow)
				_Map.setInt("GrainDirectionInModel",true);
			else
				_Map.setInt("GrainDirectionInModel",false);
			setExecutionLoops(2);
			return;
		}
		int bShowGrainInModel=_Map.getInt("GrainDirectionInModel");
		
	//End Trigger//endregion 
	
	//region Display
	Vector3d vecXView = _XW;
	Vector3d vecYView = _YW;

		String sLines[0];// store the resolved variables by line (if \P was found)	
		String sValues[0];	
		String sValue=  entDef.formatObject(sAttribute);
	
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
	
					// any solid	
						if (sVariable.find("@(Calculate Weight)",0,false)>-1)
						{
							Map mapIO,mapEntities;
							mapEntities.appendEntity("Entity", entDef);
							mapIO.setMap("Entity[]",mapEntities);
							TslInst().callMapIO("hsbCenterOfGravity", mapIO);
							double dWeight = mapIO.getDouble("Weight");// / dConversionFactor;
							
							String sTxt;
							if (dWeight<10)	sTxt.formatUnit(dWeight, 2,1);			
							else			sTxt.formatUnit(dWeight, 2,0);
							sTxt = sTxt + " kg";						
							sTokens.append(sTxt);
						}
					// SHEET
						else if (sheet.bIsValid())
						{ 
							if (sVariable.find("@(GrainDirectionText)",0,false)>-1)
								sTokens.append(vecXGrain.isParallelTo(_XW) ? T("|Lengthwise|") : T("|Crosswise|"));
							else if (sVariable.find("@(GrainDirectionTextShort)",0,false)>-1)
								sTokens.append(vecXGrain.isParallelTo(_XW) ? T("|Grain LW|") : T("|Grain CW|"));
							else if (sVariable.find("@(Graindirection)",0,false)>-1 && !vecXGrain.bIsZeroLength())
							{
								nRowGrain = sLines.length();
								String sBefore;
								for (int j=0;j<sTokens.length();j++) 
									sBefore += sTokens[j]; // the potential characters before the grain direction symbol
								dLengthBeforeGrain = dpText.textLengthForStyle(sBefore, sDimStyle, dTextHeight);
								sTokens.append("  ");//  2 blanks, symbol size max 2 characters lengt
							}
						// the grain direction of a sheet can be assigned to X or Y of the sheet: take the corresponding value of vecGrainX
							else if (sVariable.find("@(LengthGrain",0,false)>-1)
							{ 
								String key = "@(LengthGrain";
								String appendix = sVariable.right(sVariable.length()-key.length());
								Vector3d vecXGrainModel = vecXGrain;
								vecXGrainModel.transformBy(cs2Model);
								vecXGrainModel = qdr.vecD(vecXGrainModel);
								String out;

								vecXGrainModel.vis(ptOrgE, 1);
								sheet.vecX().vis(ptOrgE, 2);
								
								if (vecXGrainModel.isParallelTo(sheet.vecX()))
									out = sheet.formatObject("@(SolidLength"+appendix);
								else
									out = sheet.formatObject("@(SolidWidth"+appendix);
								sTokens.append(out);
							}
						// the grain direction of a sheet can be assigned to X or Y of the sheet: take the corresponding value of vecGrainY
							else if (sVariable.find("@(WidthGrain",0,false)>-1)
							{ 
								String key = "@(WidthGrain";
								String appendix = sVariable.right(sVariable.length()-key.length());
								Vector3d vecXGrainModel = vecXGrain;
								vecXGrainModel.transformBy(cs2Model);
								vecXGrainModel = qdr.vecD(vecXGrainModel);
								String out;
								if (vecXGrainModel.isParallelTo(sheet.vecX()))
									out = sheet.formatObject("@(SolidWidth"+appendix);
								else
									out = sheet.formatObject("@(SolidLength"+appendix);
								sTokens.append(out);
							}	
									
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
								if (!vecZView.bIsZeroLength() && sip.vecZ().isCodirectionalTo(vecZView))sQualities.swap(0, 1);
								String sQuality = sQualities[0] + " (" + sQualities[1] + ")";
								sTokens.append(sQuality);	
							}
							else if (sVariable.find("@(Graindirection)",0,false)>-1 && !vecXGrain.bIsZeroLength())
							{
								nRowGrain = sLines.length();
								String sBefore;
								for (int j=0;j<sTokens.length();j++) 
									sBefore += sTokens[j]; // the potential characters before the grain direction symbol
								dLengthBeforeGrain = dpText.textLengthForStyle(sBefore, sDimStyle, dTextHeight);
								sTokens.append("  ");//  2 blanks, symbol size max 2 characters lengt
							}
							else if (sVariable.find("@(SipComponent.Name)",0,false)>-1)
								sTokens.append(SipStyle(sip.style()).sipComponentAt(0).name());								
							else if (sVariable.find("@(SipComponent.Material)",0,false)>-1)
								sTokens.append(SipStyle(sip.style()).sipComponentAt(0).material());								
						}
					// BEAM
						else if (beam.bIsValid())
						{ 
							if (sVariable.find("@(Surface Quality)",0,false)>-1)	sTokens.append(beam.texture());
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

	// text out
		String sText;
		for (int j=0;j<sLines.length();j++) 
		{ 
			sText += sLines[j];
			if (j<sLines.length()-1)sText+="\\P";
		}//next j
		dpText.draw(sText,_Pt0,vecXView,vecYView,0,0);
		Vector3d vecXGrainModel;
		if(bIsBaufritz)
		{ 
		// save grain direction in a map
			vecXGrainModel = vecXGrain;
			vecXGrainModel.transformBy(cs2Model);
			vecXGrainModel=vecXGrainModel.crossProduct(_ZW).crossProduct(_ZW);
			vecXGrainModel.normalize();
			_Map.setVector3d("vecXGrain",vecXGrainModel);
		}
	// draw the grain direction symbol
		PLine plGrainDirection;
		if (nRowGrain>-1 && sLines.length()>0)
		{ 
			double dYBox = dpText.textHeightForStyle(sText, sDimStyle, dTextHeight);
			double dRowHeight = dYBox / sLines.length();

			double dX = abs(vecXGrain.dotProduct(vecXGrain))-1<dEps ? 2*dpText.textLengthForStyle("O", sDimStyle, dTextHeight) : .8*dTextHeight;
			Point3d pt = _Pt0 + vecYView * (.5*(dYBox-dRowHeight)-nRowGrain*dRowHeight);
			if (dLengthBeforeGrain > 0)pt += vecXView * .5 * (dLengthBeforeGrain + dX);
			PLine pl;	
			pl.addVertex(pt - vecXGrain * .5 * dX - vecYGrain * .5 * dTextHeight);
			pl.addVertex(pt - vecXGrain  * dX);
			pl.addVertex(pt + vecXGrain  * dX);
			pl.addVertex(pt + vecXGrain * .5 * dX + vecYGrain * .5 * dTextHeight);
			dpText.draw(pl);
		// HSB-20615: show grain direction in model
			if(bShowGrainInModel)
			{ 
				pl.transformBy(cs2Model);
				plGrainDirection=pl;
				pl.vis(3);
				dpText.draw(pl);
			}
		}
		if(bIsBaufritz)
		{ 
		// HSB-20615: for baufritz test the eave area sheets
		// see if all are in the same direction
		// collect all elements 
			PlaneProfile ppEls(Plane(ptOrgE,_ZW));
			ppEls.joinRing(el.plEnvelope(),_kAdd);
			
			ppEls.shrink(-U(20));
			PlaneProfile ppThis(ppEls.coordSys());
			ppThis.joinRing(sheet.plEnvelope(),_kAdd);
			PlaneProfile ppSheet=ppThis;
			ppThis.shrink(-U(20));
			PLine pls[]=ppEls.allRings(true,false);
			Body bdEls(pls[0],el.vecZ()*U(200));
			
			Entity entEls[]=Group().collectEntities(true,ElementRoof(), _kModelSpace);
			int nThisElIndex=entEls.find(el);
			if(nThisElIndex>-1)
			{ 
				entEls.removeAt(nThisElIndex);
			}
			ElementRoof eRoofsThis[0];
			for (int ii=entEls.length()-1;ii>=0;ii--)
			{ 
				int nNewElementFound;
				for (int i=0;i<entEls.length();i++) 
				{ 
					ElementRoof eI=(ElementRoof)entEls[i];
					if(!eI.bIsValid())continue;
					PlaneProfile ppI(ppEls.coordSys());
					ppI.joinRing(eI.plEnvelope(),_kAdd);
					ppI.shrink(U(-20));
					PLine plsI[]=ppI.allRings(true,false);
					PlaneProfile ppInter=ppI;
					if(ppInter.intersectWith(ppEls))
					{ 
						// check body intersection
						Body bdI(plsI[0],eI.vecZ()*U(200));
						if(bdI.hasIntersection(bdEls))
						{ 
							bdEls.addPart(bdI);
							ppEls.unionWith(ppI);
							nNewElementFound=true;
							entEls.removeAt(i);
							eRoofsThis.append(eI);
						}
					}
				}//next i
				if(!nNewElementFound)break;
			}//next i
			ppEls.shrink(U(20));
			ppEls.vis(1);
			ppThis.subtractProfile(ppEls);
			if(ppThis.area()>U(1))
			{ 
				// it is an eave sheet 
				// continue test
				int bIsWrong;
				// 	get all hsbItemClone tsls
				TslInst tsls[0];
				Entity ents[]=Group().collectEntities(true,TslInst(),_kModelSpace);
				Vector3d vecGrains[0];
				int nQuantities[0];
				for (int i=0;i<ents.length();i++) 
				{ 
					TslInst tslI=(TslInst)ents[i];
					if(!tslI.bIsValid())continue;
					if(tslI.scriptName()!="hsbItemClone")continue;
					if(tslI==_ThisInst)continue;
					Sheet sheetsI[]=tslI.sheet();
					if(sheetsI.length()==0)continue;
					Element eI=sheetsI[0].element();
					if(eRoofsThis.find(eI)<0)continue;
					if(tsls.find(tslI)<0)
						tsls.append(tslI);
					if(!tslI.map().hasVector3d("vecXGrain"))
						continue;
					Vector3d vecI=tslI.map().getVector3d("vecXGrain");
					int nIndexVec=-1; 
					for (int ii=0;ii<vecGrains.length();ii++) 
					{ 
						if(vecGrains[ii].isParallelTo(vecI))
						{
							nIndexVec=ii;
							nQuantities[ii]+=1;
							break;
						}
					}//next i
					if(nIndexVec<0)
					{ 
						vecGrains.append(vecI);
						nQuantities.append(1);
					}
				}
				// 
				if(vecGrains.length()>0)
				{
					Vector3d vecMajority=vecGrains[0];
					int nMajority=nQuantities[0];
					for (int i=0;i<nQuantities.length();i++) 
					{ 
						if(nQuantities[i]>nMajority)
							vecMajority=vecGrains[i];
					}//next i
					if(!vecXGrainModel.isParallelTo(vecMajority))
					{ 
						bIsWrong=true;
					}
				}
				if(bIsWrong)
				{ 
					if(bShowGrainInModel)
					{ 
						Display dpError(1);
						
	//					dpError.draw(plGrainDirection);
						PLine pl1=plGrainDirection;
						pl1.offset(U(5));
//						dpError.draw(plGrainDirection);
						PLine pl2=plGrainDirection;
						pl2.offset(-U(5));
						pl2.reverse();
						pl1.append(pl2);
						pl1.close();
						dpError.draw(pl1);
						PlaneProfile ppGrainDirection(pl1);
						dpError.draw(ppGrainDirection,_kDrawFilled);
						
						// get extents of profile
						LineSeg seg = ppSheet.extentInDir(vecX);
						dpError.draw(seg);
						seg = ppSheet.extentInDir(vecY);
						dpError.draw(seg);
					}
				}
			}
		}

	// draw oversize
		if (dOversize>0)
		{ 
			dpModel.color(ncOversize);
			if (_LineTypes.find(sLineTypeOversize)>-1)
				dpModel.lineType(sLineTypeOversize, dLineTypeScaleOversize);
			dpModel.draw(ppShape);
			dpModel.color(ncBody);
		}


	// draw relation if toggled
		if (bShowRelation)
		{
			Display dpRelation(_ThisInst.color());	
			Point3d ptStart = _Pt0;
			Point3d ptEnd = ptOrgE;
			Point3d ptMid = (ptStart+ptEnd)/2;
			Vector3d vecs[] ={_XW,_YW,_ZW};
	
			for (int v=0;v<vecs.length();v++)
			{
				double d = vecs[v].dotProduct(ptEnd-ptStart)*.5;
				Vector3d vec = vecs[v]*d;
				dpRelation.draw(PLine(ptStart, ptStart+vec));
				dpRelation.draw(PLine(ptEnd, ptEnd-vec));
				ptStart.transformBy(vec);
				ptEnd.transformBy(-vec);	
			}
		}


//End Display//endregion 

//	//region OLDDISPLAY
//if(0){ 
//	//region Get Display Text Content
//		String sValues[0];
//		{
//			String s= entDef.formatObject(sAttribute);//.tokenize("\P");
//			int left= s.find("\\P",0);
//			while(left>-1)
//			{
//				sValues.append(s.left(left));
//				s = s.right(s.length() - 2-left);
//				left= s.find("\\P",0);
//			}
//			sValues.append(s);
//		}
//		String sLines[0];	
//	
//	// resolve unknown and draw 
//		//reportMessage("\n"+ scriptName() + " values i "+i +" " + sValues);
//		for (int i = 0; i < sValues.length(); i++)
//		{
//			String& value = sValues[i];
//			int left = value.find("@(", 0);
//			
//		// get formatVariables and prefixes
//			if (left>-1)
//			{ 
//				//String sVariables[] = sLines[i].tokenize("@(*)");
//				// tokenize does not work for strings like '(@(KEY))'
//				String sTokens[0];
//				while (value.length() > 0)
//				{
//					left = value.find("@(", 0);
//					int right = value.find(")", left);
//					
//				// key found at first location	
//					if (left == 0 && right > 0)
//					{
//						String sVariable = value.left(right + 1).makeUpper();
//
//						if (sVariable=="@(CALCULATE WEIGHT)")
//						{
//							Map mapIO,mapEntities;
//							mapEntities.appendEntity("Entity", entDef);
//							mapIO.setMap("Entity[]",mapEntities);
//							TslInst().callMapIO("hsbCenterOfGravity", mapIO);
//							double dWeight = mapIO.getDouble("Weight");// / dConversionFactor;
//							double n = int(dWeight * 1000);
//							dWeight = n/1000;	// to overcome the missing methods on the custom objectvariables						
//							sTokens.append(dWeight);
//						}
////						else if (sVariable=="@(QUANTITY)")
////						{
////							int n=-1;
////							if (g.bIsValid())n= sUniqueKeys.find(String(g.posnum()));
////							if (t.bIsValid())n= sUniqueKeys.find(String(t.posnum()));
////							if (n>-1)
////							{ 
////								int nQuantity = nQuantities[n];
////							// as tag show only quantity > 1, as header (static) show any value	
////								if ((bHasStaticLoc && nQuantity>0) || (!bHasStaticLoc && nQuantity>1) )
////									sTokens.append(nQuantities[n]);	
////							}	
////						}
//						//region Sip unsupported by formatObject
//						else if (sheet.bIsValid())
//						{ 
//							if (sVariable=="@(GRAINDIRECTIONTEXT)")
//								sTokens.append(vecGrain.isParallelTo(_XW) ? T("|Lengthwise|") : T("|Crosswise|"));
//							else if (sVariable=="@(GRAINDIRECTIONTEXTSHORT")
//								sTokens.append(vecGrain.isParallelTo(_XW) ? T("|Grain LW|") : T("|Grain CW|"));							
//						}
//						//End Sip unsupported by formatObject//endregion 
//						
//						//region Sip unsupported by formatObject
//						else if (sip.bIsValid())
//						{ 
//							if (sVariable=="@(GRAINDIRECTIONTEXT)")
//								sTokens.append(vecGrain.isParallelTo(_XW) ? T("|Lengthwise|") : T("|Crosswise|"));
//							else if (sVariable=="@(GRAINDIRECTIONTEXTSHORT")
//								sTokens.append(vecGrain.isParallelTo(_XW) ? T("|Grain LW|") : T("|Grain CW|"));
//							else if (sVariable=="@(surfaceQualityBottom)".makeUpper())
//								sTokens.append(sqBottom);	
//							else if (sVariable=="@(surfaceQualityTop)".makeUpper())
//								sTokens.append(sqTop);	
//							else if (sVariable=="@(SURFACEQUALITY)")
//							{
//								String sQualities[] ={sqBottom, sqTop};
//								if (sip.vecZ().isCodirectionalTo(vecZView))sQualities.swap(0, 1);
//								String sQuality = sQualities[0] + " (" + sQualities[1] + ")";
//								sTokens.append(sQuality);	
//							}							
//						}
//						//End Sip unsupported by formatObject//endregion 						
//						value = value.right(value.length() - right - 1);
//					}
//				// any text inbetween two variables	
//					else if (left > 0 && right > 0)
//					{
//						sTokens.append(value.left(left));
//						value = value.right(value.length() - left);
//					}
//				// any postfix text
//					else
//					{
//						sTokens.append(value);
//						value = "";
//					}
//				}
//
//				for (int j=0;j<sTokens.length();j++) 
//					value+= sTokens[j]; 
//			}
//			if (value.length()>0)
//				sLines.append(value);
//		}	
//				
//	//End Get Display Text Content//endregion 
//
//	
//
//	// reading vecs
//		Vector3d vecXRead=_XE, vecYRead;
//		if (vecXRead.isParallelTo(_XW) && vecXRead.dotProduct(_XW)<0)
//		{ 
//			vecXRead *= -1;
//		}
//		else if (vecXRead.isParallelTo(_YW) && vecXRead.dotProduct(_YW)<0)
//		{ 
//			vecXRead *= -1;
//		}		
//		vecYRead = vecXRead.crossProduct(-_ZW);
//
//		vecXRead.vis(_Pt0 + _XW * U(200), 1);
//		vecYRead.vis(_Pt0 + _XW * U(200), 3);		
//		
//		double dGrainHeight;
//		int bDrawGrainPLine = !tsl.bIsValid(); // do not draw grain for body importer
//	
//	// get blockname
//		String sBlockName; // if specified draw block based grain direction
//		int nColorGrain=(el.bIsValid()&&!el.bIsKindOf(ElementWall()))?34:12;
//		
//		if(sip.bIsValid())
//		{		
//		// get association if set
//			int nAssociation = sip.subMap("ExtendedProperties").getInt("IsFloor");// get association 0 = wall, 1 = floor
//			if (nAssociation==0) sBlockName = "hsbGrainDirectionWall";
//			else if (nAssociation==1) sBlockName = "hsbGrainDirectionFloor";
//			nColorGrain = nAssociation==0?ncGrainWall:ncGrainRoof;
//			int bDrawBlock;
//			String _sBlockName = sBlockName;_sBlockName.makeLower();
//			for (int i=0;i<_BlockNames.length();i++) 
//			{ 
//				String s = _BlockNames[i]; 
//				bDrawBlock = _sBlockName == s.makeLower();
//				if (bDrawBlock)break;
//			}
//		// block not loaded
//			if (!bDrawBlock)sBlockName = "";
//		}
//
//	//region draw text
//		int nNumLine = sLines.length();
//		int bIsEven = nNumLine % 2 == 0;
//		
//		int nBlankLine;
//		if (sip.bIsValid())
//		{ 
//			nBlankLine = nNumLine * .5;
//			sLines.insertAt(nBlankLine, "");
//			nNumLine++;
//		}
//		
//	// rebuild string to be displayed
//		String sText;
//		for (int i=0;i<nNumLine;i++) 
//			sText+= (i>0?"\\P":"")+sLines[i]; 				
//		dpText.draw(sText, _Pt0, vecXRead, vecYRead, 0, 0);	
//	
//	
//	// draw block or pline grain
//		if (bDrawGrainPLine || sBlockName.length()>0)
//		{ 
//			dpText.color(nColorGrain);
//			
//			double dTextHeightDisplay = dpText.textHeightForStyle(sText, sDimStyle, dTextHeightStyle);
//			double dHeightLine = dTextHeightDisplay / nNumLine;		
//			Point3d ptX = _Pt0 + vecYRead * (.5 * dTextHeightDisplay-(nBlankLine+.5)*dHeightLine);
//			
////			PLine plRec; plRec.createRectangle(LineSeg(ptX-.5*(vecXRead*U(1000)+vecYRead * dHeightLine),ptX+.5*(vecXRead*U(100)+vecYRead * dHeightLine)), vecXRead, vecYRead);
////			plRec.vis(3);		ptX.vis(3);	
//			
//		// draw block based grain direction symbol
//			if (sBlockName.length()>0)
//			{
//				Block block(sBlockName);
//			
//			// scale to size
//				LineSeg seg = block.getExtents();
//				//seg.transformBy(cs2Clone);
//				seg.vis(5);
//				double dX = abs(_XW.dotProduct(seg.ptStart() - seg.ptEnd()));
//				double dY = abs(_YW.dotProduct(seg.ptStart() - seg.ptEnd()));
//				if (dY>dEps)
//				{ 
//					double dBlockScaleFactor = dHeightLine / dY;
//					//dY *= dBlockScaleFactor;
//					dpText.draw(Block(sBlockName), ptX, vecXRead*dBlockScaleFactor, vecYRead*dBlockScaleFactor, vecXRead.crossProduct(vecYRead)*dBlockScaleFactor);
//					bDrawGrainPLine = false;
//				}
//				//dGrainHeight = dY;
//			}		
//		// draw pline based grain direction	
//			if (bDrawGrainPLine)
//			{
//				PLine plGrainSymbol(_ZE);
//				plGrainSymbol.addVertex(ptX + (vecXRead * dHeightLine - vecYRead * dHeightLine*.5));
//				plGrainSymbol.addVertex(ptX + (vecXRead * dHeightLine*2));
//				plGrainSymbol.addVertex(ptX + (-vecXRead * dHeightLine*2));
//				plGrainSymbol.addVertex(ptX + (-vecXRead * dHeightLine + vecYRead * dHeightLine*.5));
//				dpText.draw(plGrainSymbol);
//			}
//			dpText.color(nc);
//		}
//	//End draw text//endregion 	
//}
//	//End OLDDISPLAY//endregion 

	// store clone reference in mapX
		Map m;
		if (gb.bIsValid())
		{ 
			m.setString("UID", gb.handle());
			m.setPoint3d("ptOrg", _Pt0, _kRelative);
			m.setVector3d("vecX", cs2Clone.vecX()*gb.solidLength(), _kScalable); // coordsys carries size
			m.setVector3d("vecY", cs2Clone.vecY()*gb.solidWidth(), _kScalable);
			m.setVector3d("vecZ", cs2Clone.vecZ()*gb.solidHeight(), _kScalable);			
		}
		else if(tsl.bIsValid())
		{ 
			Body bd = tsl.realBody();
			m.setString("UID", tsl.handle());
			m.setPoint3d("ptOrg", _Pt0, _kRelative);
			m.setVector3d("vecX", cs2Clone.vecX()*bd.lengthInDirection(vecX), _kScalable); // coordsys carries size
			m.setVector3d("vecY", cs2Clone.vecY()*bd.lengthInDirection(vecY), _kScalable);
			m.setVector3d("vecZ", cs2Clone.vecZ()*bd.lengthInDirection(vecZ), _kScalable);			
		}

		if (ppShape.area()>pow(dEps,2))
			m.setPlaneProfile("profShape", ppShape);
		_ThisInst.setSubMapX(sItemX,m);		
		
		
	}

//End mode 0: item mode //endregion 
	
//region Mode 1 Distribution/Frame 
	else if (nMode==1)
	{ 
		_Pt0.vis(1);
		if (_Entity.length()<1)
		{ 
			if (!bDebug)eraseInstance();
			return;
		}
		int bFreightSelected = _Map.getInt("FreightSelected");
		
	// append sorting property
		Map mapSortings = mapSetting.getMap("Sort[]");
//		String sSortings[0];
//		for (int i = 0; i < mapSortings.length(); i++)
//		{
//			Map m = mapSortings.getMap(i);
//			String sEntry = m.getString("Name");
//			if (sEntry.length() > 0 && sSortings.find(sEntry) < 0)
//				sSortings.append(sEntry);
//		}
//		String sSortingName=T("|Sorting|");	
//		PropString sSorting(nStringIndex++, sSortings, sSortingName);	
//		sSorting.setDescription(T("|Defines the Sorting|"));
//		sSorting.setCategory(category);
//		if (sSortings.length() < 1)sSorting.setReadOnly(true);	
		
	// get grain direction of sheeting
		int nSorting = sSortings.find(sSorting);

		if (nSorting>-1 && mapSortings.getMap(nSorting).hasInt("GrainDirectionSheet"))
		{ 
			nGrainDirectionSheet = mapSortings.getMap(nSorting).getInt("GrainDirectionSheet");
		}
		
		
	// get all items in this dwg to check existing references
		Entity entItems[] = Group().collectEntities(true,TslInst(), _kModelSpace);
		TslInst tslItems[0];
		for (int i=entItems.length()-1; i>=0 ; i--) 
		{ 
			TslInst tsl = (TslInst)entItems[i];
			if (tsl.scriptName()==scriptName() && tsl!=_ThisInst && tsl.map().getInt("mode")==0)
				tslItems.append(tsl);	
		}//next i	
		if (bDebug)reportMessage("\n" + scriptName() + ": " +tslItems.length()+T(" |found in dwg|"));
		

	// collect style data as additional array of same length
		String sStyles[_Entity.length()];
		for (int i=0;i<_Entity.length();i++)
		{ 
			Entity ent = _Entity[i]; 
			GenBeam  gb= (GenBeam)ent;
			TslInst  tsl= (TslInst)ent;
			String sStyle;
		// genbeam
			if (gb.bIsValid())
			{
				Sip sip = (Sip)ent;
				Sheet sheet = (Sheet)ent;
				Beam beam = (Beam)ent;
				if (sip.bIsValid())
					sStyle = sip.formatObject("@(Style)");
				else if(sheet.bIsValid())
					sStyle = "sheet_"+sheet.material() + "_"+gb.dH();
				else if(beam.bIsValid())
					sStyle = "beam_"+beam.material() + "_"+gb.dH();	
					
			// append package data if available
				Map m = gb.subMapX("Fracht");
				if (bFreightSelected && m.hasInt("Paket"))
					sStyle += "_Pak"+_ThisInst.formatObject("@(Paket:PL4;0)", m);
		
			}
		// tsl
			else if (tsl.bIsValid())
			{ 
				sStyle = tsl.scriptName();
			
			// try to get dimensions from subMapX
				Map m;
				m = tsl.subMapX("IfcData");
				if (m.hasDouble("SolidHeight"))
					sStyle += "_" + m.getDouble("SolidHeight");
				
			}
			else
				sStyle = ent.typeDxfName()+"_"+ent.color();
			sStyles[i] = sStyle;
		}

	// order by style
		for (int i=0;i<_Entity.length();i++) 
			for (int j=0;j<_Entity.length()-1;j++) 
				if (sStyles[j]>sStyles[j+1])
				{	
					_Entity.swap(j, j + 1);
					sStyles.swap(j, j + 1);
				}

	// create clones
		Point3d ptRow = _Pt0;
		Point3d ptPlan=ptRow;
		CoordSys csPlan(_Pt0, _XW,_YW,_ZW);
		double dMaxRowHeight;
		for (int i=0;i<_Entity.length();i++) 
		{ 
			Entity ent = _Entity[i]; 
			GenBeam  gb= (GenBeam)ent;
			TslInst  tsl= (TslInst)ent;
			CoordSys csDef;
		
		// check if an item exists to this
			int bOk = true;
			for (int j=0;j<tslItems.length();j++) 
			{ 
				Map m = tslItems[j].subMapX(sItemX);
				Entity e;
				e.setFromHandle(m.getString("UID"));
				if (e.bIsValid() && e==ent)
				{ 
					reportMessage("\n" + scriptName() + ": " +gb.typeDxfName() + " ("+gb.posnum()+") " + T("|has already an item associated at| ") + tslItems[j].ptOrg());
					bOk = false;
					break;
					
				}
				 
			}//next j
			if (!bOk)continue;
		
		
		// genbeam
			if (gb.bIsValid())
			{ 
				Sip sip = (Sip)ent;
				Sheet sheet= (Sheet)ent;
				Beam beam = (Beam)ent;
				Vector3d vecX = gb.vecX();
				Vector3d vecY = gb.vecY();
				Vector3d vecZ = gb.vecZ();
				
				gb.ptCenSolid().vis(2);
				
				Quader qdr(gb.ptCenSolid(), vecX, vecY, vecZ,gb.solidLength(), gb.solidWidth(), gb.solidHeight(), 0,0,0);
				csDef = CoordSys(gb.ptCenSolid(), vecX,vecY, vecZ);
				
			// stream body	
				Body bd;
				if (nDisplayMode==1)
					bd= gb.realBody();				
				else
					bd= gb.envelopeBody(true,true);		
//bd.transformBy(vecZ * U(100));
//bd.vis(3);
			// the profile
				PlaneProfile ppShape;
				if (sheet.bIsValid())
				{
					Element el = sheet.element();
	// 0 = byEntity X
	// 1 = byEntity Y
	// 2 = byElement X
	// 3 = byElement Y	
	// 4 = biggest dim
	// 5 = smallest dim
					if (nGrainDirectionSheet==1 || (!el.bIsValid() && nGrainDirectionSheet==3))
					{ 
						vecX = vecY;
						vecY = vecX.crossProduct(-vecZ);
					}
					else if (nGrainDirectionSheet==2 && el.bIsValid())
					{ 
						vecX = el.vecX();
						vecY = el.vecY();
						vecZ = el.vecZ();
					}
					else if (nGrainDirectionSheet==3 && el.bIsValid())
					{ 
						vecX = el.vecY();
						vecZ = el.vecZ();
						vecY = vecX.crossProduct(-vecZ);	
					}
					else if (nGrainDirectionSheet==4 && sheet.dL()<sheet.dW())
					{ 
						vecX = vecY;
						vecY = vecX.crossProduct(-vecZ);					
					}
					else if (nGrainDirectionSheet==5 && sheet.dL()>sheet.dW())
					{ 
						vecX = vecY;
						vecY = vecX.crossProduct(-vecZ);					
					}
					
					csDef = CoordSys(gb.ptCenSolid(), vecX,vecY, vecZ);
					ppShape = PlaneProfile(csDef);
					ppShape.joinRing(sheet.plEnvelope(), _kAdd);
				}
				else if (sip.bIsValid())
				{
					
					vecX = sip.woodGrainDirection().bIsZeroLength()?vecX:sip.woodGrainDirection();
					vecY = vecX.crossProduct(-vecZ);
					csDef = CoordSys(gb.ptCenSolid(), vecX,vecY, vecZ);
					csDef.vis(2);
					ppShape = PlaneProfile(csDef);
					PLine plRings[] = bd.shadowProfile(Plane(bd.ptCen(), vecZ)).allRings(true, false);
					for (int r=0;r<plRings.length();r++) 
					{
						plRings[r].vis(1);
						ppShape.joinRing(plRings[r], true); 
					}
				}
				else
				{
					ppShape = bd.shadowProfile(Plane(bd.ptCen(), csDef.vecZ()));
				}
				
				//ppShape.vis(6);
				LineSeg seg = ppShape.extentInDir(gb.vecX());
				seg.vis(2);
					
				double dX = qdr.dD(vecX);
				double dY = qdr.dD(vecY);
				
				
				//csDef.ptOrg().vis(i);

			// new style
				int bNewStyle = i > 0 && sStyles[i] != sStyles[i - 1];
			
			// new row, if new style increment offset
				if (_XW.dotProduct((ptPlan+_XW*dX)-ptRow)>dMaxRowLength ||bNewStyle)
				{ 
					ptRow -= _YW * ((bNewStyle?2:1)*dDistToNext+dMaxRowHeight);
					ptPlan=ptRow;
					dMaxRowHeight = 0;
				}
					
			// collect max row height	
				if (dMaxRowHeight<dY)
					dMaxRowHeight = dY;
				
				ptPlan+=.5*(_XW*dX-_YW*dY);
				csPlan = CoordSys(ptPlan, _XW,_YW,_ZW);
				ptPlan.vis(i);
				CoordSys csMS2Plan;
				csMS2Plan.setToAlignCoordSys(csDef.ptOrg(), csDef.vecX(), csDef.vecY(), csDef.vecZ(), csPlan.ptOrg(), csPlan.vecX(), csPlan.vecY(), csPlan.vecZ());
				
				
				ppShape.transformBy(csMS2Plan);
				//dpModel.draw(ppShape, _kDrawFilled, 60);
				
			// create clone
				TslInst tslNew;
				GenBeam gbsTsl[] = {gb};	Entity entsTsl[] = {};			Point3d ptsTsl[] = {ptPlan};
				int nProps[]={};
				double dProps[]={dOversize,dTextHeight};	
				String sProps[]={sSorting, sAttribute, sDimStyle, sRule};
				Map mapTsl;	
				
				if (!bDebug)
					tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			
				else	
					dpModel.draw(ppShape);

				ptPlan+=(_XW*(.5*dX+dDistToNext)+.5*_YW*dY);
			}
			
		//region TslInst.BodyImporter
			else if (tsl.bIsValid())	
			{ 
			// stream body	
				Body bd=tsl.realBody();	
				bd.vis(i);
				
			// get coordSys
				Map mapX = tsl.subMapX("IfcData");
				Vector3d vecX = mapX.getVector3d("vecX");
				Vector3d vecY = mapX.getVector3d("vecY");
				Vector3d vecZ = mapX.getVector3d("vecZ");
				
				CoordSys csDef(bd.ptCen(), vecX,vecY, vecZ);
				PlaneProfile ppShape = bd.shadowProfile(Plane(bd.ptCen(), csDef.vecZ()));
					
			// get extents of profile
				LineSeg seg = ppShape.extentInDir(vecX);
				double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
				double dY = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
				
			// new style
				int bNewStyle = i > 0 && sStyles[i] != sStyles[i - 1];	
				
			// new row, if new style increment offset
				if (_XW.dotProduct((ptPlan+_XW*dX)-ptRow)>dMaxRowLength ||bNewStyle)
				{ 
					ptRow -= _YW * ((bNewStyle?2:1)*dDistToNext+dMaxRowHeight);
					ptPlan=ptRow;
					dMaxRowHeight = 0;
				}
			// collect max row height	
				if (dMaxRowHeight<dY)
					dMaxRowHeight = dY;
					
				ptPlan+=.5*(_XW*dX-_YW*dY);
				csPlan = CoordSys(ptPlan, _XW,_YW,_ZW);
				ptPlan.vis(i);
				CoordSys csMS2Plan;
				csMS2Plan.setToAlignCoordSys(csDef.ptOrg(), csDef.vecX(), csDef.vecY(), csDef.vecZ(), csPlan.ptOrg(), csPlan.vecX(), csPlan.vecY(), csPlan.vecZ());
				

				
				ppShape.transformBy(csMS2Plan);
				ppShape.vis(i);

			// create clone
				TslInst tslNew;
				GenBeam gbsTsl[] = {};	Entity entsTsl[] = {tsl};			Point3d ptsTsl[] = {ptPlan};
				int nProps[]={};
				double dProps[]={dOversize,dTextHeight};	
				String sProps[]={sSorting, sAttribute, sDimStyle,sRule};
				Map mapTsl;	
				
				if (!bDebug)
					tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			
				else	
				{
					dpModel.draw(ppShape);
				}

				ptPlan+=(_XW*(.5*dX+dDistToNext)+.5*_YW*dY);

			}
		//endregion End TslInst.BodyImporter	
			
		}//next i
		if (!bDebug)
		{
			eraseInstance();
			return;
		}
		
	}


//End Distribution/Frame Mode 1 //endregion 	



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
        <int nm="BreakPoint" vl="1459" />
        <int nm="BreakPoint" vl="1370" />
        <int nm="BreakPoint" vl="2002" />
        <int nm="BreakPoint" vl="1952" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21273 collection via freight items supported. items referenced via freight item will be sorted by package" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="11" />
      <str nm="Date" vl="2/1/2024 9:03:11 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20615: Implement graindirection check for Baufritz" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="10" />
      <str nm="Date" vl="11/13/2023 5:03:33 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20615: Add trigger to show/hide grain direction in model" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="11/13/2023 9:51:55 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End