#Version 8
#BeginDescription
version value="1.5" date="20oct2020" author="thorsten.huck@hsbcad.com"
HSB-9338 internal naming bugfix

HSB-5749  enhanced to snap dimpoionts to the reference zone if not a solid
HSB-5455 property 'reference' added to specify reference zone 

invalid range filtered on sections
protection range published, setup display enhanced

All tsls attached to the element are dimensioned at their origin point unless a filter rule applies and/or tsl based dimension points are published
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 5
#KeyWords Dimension;Coordinate;Format;Element;Section;Shopdrawing
#BeginContents
/// <History>//region
/// <version value="1.5" date="20oct2020" author="thorsten.huck@hsbcad.com"> HSB-9338 internal naming bugfix </version>
/// <version value="1.4" date="11oct2019" author="thorsten.huck@hsbcad.com"> HSB-5749  enhanced to snap dimpoionts to the reference zone if not a solid, default filter definition deployed </version>
/// <version value="1.3" date="23sep2019" author="thorsten.huck@hsbcad.com"> HSB-5455 property 'reference' added to specify reference zone </version>
/// <version value="1.2" date="11jul2019" author="thorsten.huck@hsbcad.com"> invalid range filtered on sections </version>
/// <version value="1.1" date="05jul2019" author="thorsten.huck@hsbcad.com"> protection range published, setup display enhanced </version>
/// <version value="1.0" date="04jul2019" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select entity, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
//All tsls attached to the element are dimensioned at their origin point unless a filter rule (A) applies and/or tsl based dimension points are published (B).
//
//The tool supports @(<Format>) definitions as an apendix to the cordinate dimension
//The dimension can be grouped as global dimension (image vertical dim) or placed nearby the dimension point as local dimension (image horizontal dimension)
//
//(A) Filter rules can be created by a settings xml file, see attached sample. Settings file to be imported/exported by hsbTslSettingsIO, path = <company>\tsl\settings
//(B) as default the origin of a tsl is taken. TSL Authors may publish custom dimension points by map
//// publish coordinate dimensions
//Map mapCoordinateDimension;
//mapCoordinateDimension.setPoint3dArray("Points", ptLocs);
//_Map.setMap("CoordinateDimension", mapCoordinateDimension);
//
//Other entities then tsl are foreseen to be supported, but not implemented yet.
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbViewCoordinateDimension")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "../|Add/Remove Format|") (_TM "|Select coordinate dimension|"))) TSLCONTENT
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
//end constants//endregion

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sFileName ="hsbViewCoordinateDimension";
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

//region Read Settings
	Map mapFilterRules, mapFilterRule;
	String sRules[0];
	String k;
	Map m;

//region Default rule settings
	mapFilterRules= mapSetting.getMap("FilterRule[]");
	if (mapFilterRules.length()<1)
	{ 
		Map mapDefaultRule;
		mapDefaultRule.setString("Name", T("|Sherpa|"));

		Map mapFormats, mapFormat;
		mapFormat.setString("Format", "@(ScriptName)");
		mapFormat.setString("Value", "Sherpa");
		mapFormat.setInt("Operation", 0); // 0 = exclude, 1 = include
		mapFormats.appendMap("Format", mapFormat);

		mapDefaultRule.setMap("Format[]", mapFormats);	
		mapFilterRules.appendMap("FilterRule",mapDefaultRule);
	}
	
	if(mapSetting.length()<1)
	{
		//mapSetting.setMap("Style[]", mapStyles); // not supported yet
		mapSetting.setMap("FilterRule[]", mapFilterRules);		
		
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
	
//End Default rule settings//endregion 	


//Filter
	category = T("|Content|");

	String sAttributeName=T("|Format|");	// 1
	PropString sAttribute(nStringIndex++, "", sAttributeName);	
	sAttribute.setDescription(T("|Defines the text and/or attributes.|") +  T(" |Multiple lines are separated by '\P'|") + T(" |Attributes can also be added or removed by context commands.|"));
	sAttribute.setCategory(category);
	
// get applicable rules
	for (int i=0;i<mapFilterRules.length();i++) 
	{ 
		m = mapFilterRules.getMap(i); 
		String name;
		int _nType;
		k="Name";		if (m.hasString(k))		name=T(m.getString(k));
		k="Type";		if (m.hasInt(k))		_nType=m.getInt(k);
		if (sRules.find(name)<0 && name.length()>0)
			sRules.append(name);	 
	}//next i		
	sRules = sRules.sorted();
	sRules.insertAt(0, T("|<Disabled>|"));

	String sRuleName=T("|Filter Rule|");
	PropString sRule(nStringIndex++, sRules, sRuleName);	 // prev Index 8
	sRule.setDescription(T("|Specifies a filter rule.|"));
	sRule.setCategory(category);
	if (sRules.length() < 2)sRule.setReadOnly(true);
	if (sRules.find(sRule) < 0  && sRules.length()>0)sRule.set(sRules[0]);

	String sReferences[] = { T("|byElement|")};
	for (int i=0;i<11;i++) 
		sReferences.append(T("|Zone| ") + (i - 5));
	String sReferenceName=T("|Reference|");	
	PropString sReference(4, sReferences, sReferenceName);	// 1.3: keep property sequence of previous versions
	sReference.setDescription(T("|Defines the reference of the dimension.| ") + T("|In case the specified reference is invalid the reference will fall back to zone 0 or the element outline.|"));
	sReference.setCategory(category);

//Display
	category = T("|Display|");
	
	String sAlignmentName=T("|Alignment|");
	String sAlignments[] ={ T("|Horizontal Local|"), T("|Horizontal Global|"), T("|Vertical Local|"),T("|Vertical Global|")};
	PropString sAlignment(nStringIndex++, sAlignments, sAlignmentName);	
	sAlignment.setDescription(T("|Defines the Alignment|"));
	sAlignment.setCategory(category);

	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(0), sTextHeightName);	
	dTextHeight.setDescription(T("|Defines the Text Height|") + " " + T("|0 = byDimstyle|"));
	dTextHeight.setCategory(category);

	String sDimStyleName=T("|Dimstyle|");	
	PropString sDimStyle(nStringIndex++, _DimStyles.sorted(), sDimStyleName);	
	sDimStyle.setDescription(T("|Defines the Dimstyle|"));
	sDimStyle.setCategory(category);
	
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

	// get current space
		int bInLayoutTab = Viewport().inLayoutTab();
		int bInPaperSpace = Viewport().inPaperSpace();

	// find out if we are block space and have some shopdraw viewports
		Entity viewEnts[0];
		if (!bInLayoutTab)viewEnts= Group().collectEntities(true, ShopDrawView(), _kMySpace);

	// distinguish selection mode bySpace
		if (viewEnts.length()>0)
			_Entity.append(getShopDrawView());
	// switch to paperspace succeeded: paperspace with viewports
		if (_Entity.length()<1)
		{ 
		// papaerspace get viewPort
			if (bInLayoutTab)
			{
				_Viewport.append(getViewport(T("|Select a viewport|")));
			}	
		// modelspace: get Section2d or ClipVolume
			else
			{ 
			// prompt for entities
				Entity ents[0];
				PrEntity ssE(T("|Select Section2d|"), Section2d());
				if (ssE.go())
					ents.append(ssE.set());
			
			// create TSL
				TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
				GenBeam gbsTsl[] = {};		Entity entsTsl[1];			Point3d ptsTsl[] = {_Pt0};
				int nProps[]={};
				double dProps[]={dTextHeight};
				String sProps[]={sAttribute,sRule,sAlignment,sDimStyle,sReference};
				Map mapTsl;	
	
			// create per section
				for (int i=0;i<ents.length();i++) 
				{ 
					entsTsl[0] = ents[i]; 
					tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	 
				}//next i
							
				eraseInstance();
				return;		
			}			
		}


	// pick location
		_Pt0 = getPoint(T("|Pick a point outside of paperspace|")); 		
		
		return;
	}	
// end on insert	__________________
	

// on creation
	if (_bOnDbCreated)setExecutionLoops(2);
	_ThisInst.setSequenceNumber(500);
	
// some variables
	double dXVp, dYVp; // X/Y of viewport/shopdrawviewport
	Point3d ptCenVp=_Pt0;
	int nActiveZoneIndex = 99;
	int nc = _ThisInst.color();
	
	int nAlignment = sAlignments.find(sAlignment, 0);// 0 = horizontal , 2= horizontal global,3 = vertical , 4= vertical global
	int bIsGlobal = nAlignment == 1 || nAlignment == 3;
	int bIsVertical = nAlignment >1;
	
	int nReference = 99, nPReference = sReferences.find(sReference); // 99 = by Defineset, else zone
	
	Vector3d vecDir = bIsVertical?_XW:_YW;
	Vector3d vecPerp = bIsVertical?_YW:_XW;
	Vector3d vecDirMS = vecDir;
	Element el;
	ElementMulti em;
	int bIsElementViewport;	
	Point3d ptMidEl;
	LineSeg segEl;

	CoordSys ms2ps, ps2ms;

	Point3d ptDatum = _Pt0;
	Point3d ptRef = _Pt0;
	
	double dXLeader = dTextHeight;
	double dXOffset = dTextHeight;
	
	
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
				mapFormats = m.getMap("Format[]");
				break;
			}		 
		}//next i
	}
//End GetFilterRule//endregion 



//region get defining viewport entity
//region Collect parent entities
	ShopDrawView sdv;
	Section2d section;ClipVolume clipVolume;
	Entity entsDefineSet[0],entsShowset[0];
	int bHasSDV, bHasSection;
	for (int i=0;i<_Entity.length();i++) 
	{ 
		sdv = (ShopDrawView)_Entity[i]; 
		if (sdv.bIsValid())
		{ 
		// interprete the list of ViewData in my _Map
			ViewData viewDatas[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets,0); // 2 means verbose
			int nIndex = ViewData().findDataForViewport(viewDatas, sdv);// find the viewData for my view
			if (nIndex>-1)
			{ 
				ViewData viewData = viewDatas[nIndex];
				dXVp = viewData.widthPS();
				dYVp = viewData.heightPS();
				ptCenVp= viewData.ptCenPS();
				
				ms2ps = viewData.coordSys();
				ps2ms = ms2ps; ps2ms.invert();
				
				entsDefineSet = viewData.showSetDefineEntities();
				entsShowset = viewData.showSetEntities();
				for (int j=0;j<entsDefineSet.length();j++) 
				{ 
					el= (Element)entsDefineSet[j]; 
					if (el.bIsValid())break;					 
				}//next j
			}
			bHasSDV = true;
			break;
		}
		section = (Section2d)_Entity[i]; 
		if (section.bIsValid())
		{
			bHasSection = true;
			clipVolume= section.clipVolume();
			if (!clipVolume.bIsValid())
			{ 
				eraseInstance();
				return;
			}
			_Entity.append(clipVolume);
			ms2ps = section.modelToSection();
			ps2ms = ms2ps; ps2ms.invert();
			entsShowset = clipVolume.entitiesInClipVolume();
			_ThisInst.setAllowGripAtPt0(bIsGlobal);
			setDependencyOnEntity(section);
			setDependencyOnEntity(clipVolume);
			
		}
		
	}//next i		
//End Collect parent entities//endregion 


// it has no shopdraw viewport and no viewport
	if (!bHasSDV && _Viewport.length()==0 && !bHasSection && Viewport().switchToPaperSpace()) 
	{
		Display dp(1);
		if (dTextHeight>0)dp.textHeight(U(dTextHeight));
		dp.draw(scriptName() + T(": |please add a viewport|"), _Pt0, _XW, _YW, 1, 0);

	// Trigger AddViewPort
		String sTriggerAddViewPort = T("|Add Viewport|");
		addRecalcTrigger(_kContext, sTriggerAddViewPort );
		if (_bOnRecalc && (_kExecuteKey==sTriggerAddViewPort || _kExecuteKey==sDoubleClick))
		{
			_Viewport.append(getViewport(T("|Select a viewport|"))); 
			setExecutionLoops(2);
			return;
		}	
		return; // _Viewport array has some elParents
	}
	
// get viewport data
	Viewport vp;
	if (_Viewport.length()>0)
	{ 
		vp = _Viewport[_Viewport.length()-1]; // take last element of array
		_Map.setString("ViewHandle", vp);
		_Viewport[0] = vp; // make sure the connection to the first one is lost
		ms2ps = vp.coordSys();
		ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps
	
		dXVp = vp.widthPS();
		dYVp = vp.heightPS();
		ptCenVp= vp.ptCenPS();	
		
	// check if the viewport has hsb data
		el = vp.element();
		nActiveZoneIndex = vp.activeZoneIndex();
		ptDatum = el.ptOrg();
	}

// element viewport/shopdraw viewport
	bIsElementViewport = el.bIsValid();
	Map mapParent, mapParents=_Map.getMap("Parent[]"); // the map wich stores the grip relation
	if (bIsElementViewport)
	{ 
		
		em = (ElementMulti)el;	
		segEl = el.segmentMinMax();
		segEl.transformBy(ms2ps);
		ptMidEl = segEl.ptMid();ptMidEl.vis(2);
		
		if (mapParents.hasMap(el.handle()))
			mapParent = mapParents.getMap(el.handle());
	}
	else if (mapParents.hasMap("View"))
		mapParent = mapParents.getMap("View");
	//reportMessage("\nXXX is element viewport");

// scale	
	Vector3d vecScale(1, 0, 0);
	vecScale.transformBy(ps2ms);
	double dScale = vecScale.length();

// get viewdirection in model
	Vector3d vecXView = _XW;	vecXView.transformBy(ps2ms);	vecXView.normalize();
	Vector3d vecYView = _YW;	vecYView.transformBy(ps2ms);	vecYView.normalize();
	Vector3d vecZView = _ZW;	vecZView.transformBy(ps2ms);	vecZView.normalize();
	//vecZView.vis(el.ptOrg(), 4);
	

// world plane in MS
	Plane pnZPS(_PtW, _ZW);
	Plane pnZMS = pnZPS;
	pnZMS.transformBy(ps2ms);
	CoordSys csW(_Pt0, _XW, _YW, _ZW);
	CoordSys csMS = csW;
	csMS.transformBy(ps2ms);
	
// the viewport / section profile 
	PlaneProfile ppVp, ppVpInverse, ppClip, ppParent;
	Body bdClip;
	if (bHasSection)
	{ 
		bdClip = clipVolume.clippingBody();
		bdClip.vis(2);
		ppClip = bdClip.shadowProfile(Plane(clipVolume.coordSys().ptOrg(), clipVolume.viewFromDir()));
		ppVp = ppClip;
		ppVp.transformBy(ms2ps);
		ppParent = ppVp;
			
	// get extents of profile
		LineSeg seg = ppVp.extentInDir(_XW);
		ptCenVp = seg.ptMid();
		dXVp = 10*abs(_XW.dotProduct(seg.ptStart()-seg.ptEnd()));
		dYVp = 10*abs(_YW.dotProduct(seg.ptStart()-seg.ptEnd()));
		ppVp.createRectangle(seg, _XW, _YW);
		//_Pt0 = ppVp.closestPointTo(_Pt0);
	}
	else
		ppVp.createRectangle(LineSeg(ptCenVp-.5*(_XW*dXVp+_YW*dYVp),ptCenVp+.5*(_XW*dXVp+_YW*dYVp)),_XW,_YW);

//End get defining viewport entity//endregion 

// declare entity collections by type
	Entity ents[0], entsAll[0];
	TslInst tsls[0];
	
// Get Elements
	Element elements[0];
	PlaneProfile ppRefZone(csMS); 
	if (bIsElementViewport)
	{
		entsAll = el.elementGroup().collectEntities(true, TslInst(), _kModelSpace);
		elements.append(el);
		
	// validate reference
		if (nPReference>0) // by zone
		{ 
			nReference = 0;
			for (int i=-5;i<6;i++) 
			{ 
				if (el.zone(i).dH()<dEps) continue;
				if (nPReference-6 == i)
				{ 
					nReference = i;
					break;
				}	 
			}//next i			
		}
	
	// set datum
		vecDirMS.transformBy(ps2ms);
		if (nReference!=99 && nReference>-6 && nReference<6)
		{ 
			GenBeam genBeams[] = el.genBeam(nReference);
			Point3d _pts[0];
			for (int i=0;i<genBeams.length();i++) 
			{
				Body bd = genBeams[i].envelopeBody(false, true);
				_pts.append(bd.extremeVertices(vecDirMS)); 
				PlaneProfile pp = bd.shadowProfile(Plane(bd.ptCen(), csMS.vecZ()));
				//pp.vis(i);
				PLine plRings[] = pp.allRings(TRUE,FALSE);
				for (int r=0;r<plRings.length();r++)
					ppRefZone.joinRing(plRings[r],_kAdd);
			}
			_pts=Line(_Pt0, vecDirMS).orderPoints(_pts);
			if (_pts.length() > 0)
				ptDatum = _pts.first();
		}
	
	
	}
	else
	{ 
		entsAll = entsShowset;
	}
	ppRefZone.shrink(-dEps);
	ppRefZone.shrink(dEps);
	ppRefZone.removeAllOpeningRings();
	ppRefZone.vis(3);
	ppRefZone.transformBy(ms2ps);
	ppRefZone.vis(3);
	

	
//region element viewport
	//if (bIsElementViewport)
	{
		el.plOutlineWall().vis(1);
		// TSL	
		//if (nType==5)
		{
			//Entity _ents[] = el.elementGroup().collectEntities(true, TslInst(), _kModelSpace);
			for (int j = 0; j < entsAll.length(); j++)
			{
				TslInst t = (TslInst)entsAll[j];
//				t.ptOrg().vis(5);
//				
//				Display dp(1);
//				dp.textHeight(U(5));
//				dp.draw(t.scriptName(), t.ptOrg(), t.coordSys().vecX(), t.coordSys().vecY(), 1, 0);
//				
//				Entity _ents[] = t.entity();
//				if (_ents.find(el) < 0)continue;
				
				//if (!t.bIsValid() || (bAddSolidScript && t.realBody().volume()<pow(dEps,3))){continue;}
				//if(bAddScriptAll || sScripts.find(t.scriptName())>-1)
				{
					tsls.append(t);
					ents.append(t);
				}
			}
		}
		
	// check format rules
		for (int i=ents.length()-1; i>=0 ; i--) 
		{ 
			GenBeam gb = (GenBeam)ents[i];
			TslInst tsl = (TslInst)ents[i];
			
			int bAdd = true;
			for (int j=0;j<mapFormats.length();j++) 
			{ 
				m= mapFormats.getMap(j);
//				int nEntityType = m.getInt("Type");
//				if (nEntityType != 0 && nEntityType != 1) continue;
				
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
				String _value = ents[i].formatObject(format);
				int nOperation = m.getInt("Operation");
				
			// resolve unknown
				if (format.find("@(Color)",0,false)>-1)
					_value = ents[i].color();
				else if (format.find("@(Beamtype)",0,false)>-1 && gb.bIsValid())
					_value = _BeamTypes[gb.type()];
				else if (format.find("@(ScriptName)",0,false)>-1 && tsl.bIsValid())
					_value = tsl.scriptName();

				//reportMessage("\nformat " + format + " value " + value + " _value " + _value + " operation " + nOperation);
				
				int bMatch = values.findNoCase(_value, -1) >- 1;
				
			// exclude operation, values match	or include operation, values do not match
				if ((nOperation == 0 && bMatch) || (nOperation == 1 && !bMatch))
				{
					bAdd = false;
					break;
				}
			}//next j	
			if (!bAdd)
			{
				int x = tsls.find(ents[i]);
				ents.removeAt(i);
				if (x >- 1)tsls.removeAt(x);
			}
		}//next i	
	}
//End element viewport//endregion	

//region get list of available object variables
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

//region add custom variables
	for (int i=0;i<ents.length();i++)
	{ 
		k = "Calculate Weight"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			
//	// add quantity as object variable
//		if (ents[i].bIsKindOf(GenBeam()))
//		{
//			k = "Quantity"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);	
//		}
		// Beam	
		if (ents[i].bIsKindOf(Beam()))
		{
			k = "Surface Quality"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
		}
		// Sip	
		else if (ents[i].bIsKindOf(Sip()))
		{ 
			k = "GrainDirection"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "GrainDirectionText"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "GrainDirectionTextShort"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "SurfaceQuality"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "SurfaceQualityTop"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "SurfaceQualityBottom"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "SipComponent.Name"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "SipComponent.Material"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
		}
		else if (ents[i].bIsKindOf(TslInst()))
		{ 
			k = "Posnum"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);	
		}
	// metalpart collection entity	
		else if (ents[i].bIsKindOf(MetalPartCollectionEnt()))
		{ 
			k = "Definition"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);	
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
	String sTriggerAddRemoveFormat = T("|Add/Remove Format|");
	addRecalcTrigger(_kContext, "../"+sTriggerAddRemoveFormat );

	if (_bOnRecalc && (_kExecuteKey=="../"+sTriggerAddRemoveFormat || _kExecuteKey==sTriggerAddRemoveFormat))
	{
		String sPrompt;
		if (bHasSDV && entsDefineSet.length()<1)
			sPrompt += "\n" + T("|NOTE: During a block setup only limited properties are accesable, but you can enter \nany valid format expression or use custom catalog entries.|");
		sPrompt+="\n"+ T("|Select a property by index to add(+) or to remove(-)|") + T(" ,|0 = Exit|");
		reportNotice(sPrompt);
		
		for (int s=0;s<sObjectVariables.length();s++) 
		{ 
			String key = sObjectVariables[s]; 
			String keyT = sTranslatedVariables[s];
			String value;
			for (int j=0;j<ents.length();j++) 
			{ 
				String _value = ents[j].formatObject("@(" + key + ")");
				if (_value.length()>0)
				{ 
					value = _value;
					break;
				}
			}//next j

			String sAddRemove = sAttribute.find(key,0, false)<0?"(+)" : "(-)";
			int x = s + 1;
			String sIndex = ((x<10)?"    " + x:"   " + x)+ "  "+sAddRemove+"  :";
			
			reportNotice("\n"+sIndex+keyT + "........: "+ value);
			
		}//next i
		int nRetVal = getInt(sPrompt)-1;
				
	// select property	
		while (nRetVal>-1)
		{ 
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
			nRetVal = getInt(sPrompt)-1;
		}
	
		setExecutionLoops(2);
		return;
	}	
	
	
//endregion 

// transform direction to paperspace
	Vector3d vecXRead, vecYRead;
	vecXRead = vecPerp;
	vecYRead = vecXRead.crossProduct(-_ZW);
	vecDir.transformBy(ps2ms);
	vecDir.normalize();
	vecPerp.transformBy(ps2ms);
	vecPerp.normalize();	

// reference point of global dimensions refers to _Pt0 in modelspace
	ptRef.transformBy(ps2ms);
	Line ln(ptRef, vecDir);
	int bIsValidRef=true;
	if (!bHasSection)
	{ 
		LineSeg seg(_Pt0 - vecYRead * U(10e4), _Pt0 + vecYRead * U(10e4)); seg.vis(3);
		LineSeg segs[] = ppVp.splitSegments(seg, true);
		bIsValidRef = segs.length() > 0;
	}

//region Display
	Display dp(nc);
	dp.dimStyle(sDimStyle);
// validate / automatic text height
	if (dTextHeight<=0)
		dTextHeight.set(dp.textHeightForStyle("O",sDimStyle) * vp.dScale());	
	double dFactor = 1;
	double dTextHeightStyle = dp.textHeightForStyle("O",sDimStyle);
	if (dTextHeight>0)
	{
		dFactor=dTextHeight/dTextHeightStyle;
		dTextHeightStyle=dTextHeight;
		dp.textHeight(dTextHeight);
	}	

// setup / control display	
	int bDrawSetupInfo = true;
	if (bHasSDV && entsDefineSet.length() >0)
		bDrawSetupInfo=false ;
	else if (bHasSection && ents.length() >0)
		bDrawSetupInfo=false ;
	if (bDrawSetupInfo)
	{ 
		String sText = scriptName();
		if (nActiveZoneIndex!=99)sText+="\\P" + T("|Zone| ")+ nActiveZoneIndex;
		sText+=" " + sAlignment;
		if(nRule>0)sText+="\\P"+sRuleName + ": " + sRule;
		if(!bIsValidRef && bIsGlobal)
		{
			dp.color(1);
			sText += "\\P" + T("|No intersection found for global dimension, \\Pplease adjust location.|");
		}
		dp.draw(sText, _Pt0, _XW, _YW, 1, -1);
		
		//dp.draw(sTypeName + ": " + sType + (nType==5?sSetupText2:"") + " ("+ents.length()+"), " + T("|Priority| ")+(nPriority+1),  _Pt0, _XW, _YW, 1, -2);
		//dp.draw(T("|Format|") + ": " + sAutoAttribute,  _Pt0, _XW, _YW, 1, -5);		
	}

//End Display//endregion 


//region Protection area
	PlaneProfile ppProtect(csW);
	
//End Protection area//endregion 

//region loop detected entities and collect dim points
	double dXFlag = 1;
	if (bIsGlobal && vecXRead.dotProduct(ptCenVp - _Pt0) > 0)dXFlag *= -1;
	
	for (int i=0;i<ents.length();i++) 
	{ 
		TslInst t = (TslInst)ents[i];
		
		int bIsSolid = t.realBody().volume() > pow(dEps, 3);
		Point3d pts[0];
		
		String sAppendix;
		
		if (t.bIsValid())
		{
		// get location by publsihed submap
			String k = "CoordinateDimension";
			Map m = t.map().getMap(k);	
			k = "Points"; if (m.hasPoint3dArray(k)) pts = m.getPoint3dArray(k);
		
		// use tsl origin as default location
			if (pts.length()<1)	pts.append(t.ptOrg());		
		}

	//region Get Display Text Content
	// resolve variables as appendix
		String sValues[0];
		{
			String s=  ents[i].formatObject(sAttribute);

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

						if (sVariable=="@(CALCULATE WEIGHT)")
						{
							Map mapIO,mapEntities;
							mapEntities.appendEntity("Entity", ents[i]);
							mapIO.setMap("Entity[]",mapEntities);
							TslInst().callMapIO("hsbCenterOfGravity", mapIO);
							double dWeight = mapIO.getDouble("Weight");// / dConversionFactor;
							
							String sTxt;
							if (dWeight<10)
								sTxt.formatUnit(dWeight, 2,1);			
							else
								sTxt.formatUnit(dWeight, 2,0);
							sTxt = sTxt + " kg";						
							sTokens.append(sTxt);
						}
//						else if (sVariable=="@(QUANTITY)")
//						{
//							int n=-1;
//							//if (g.bIsValid())n= sUniqueKeys.find(String(g.posnum()));
//							if (t.bIsValid())n= sUniqueKeys.find(String(t.posnum()));
//							if (n>-1)
//							{ 
//								int nQuantity = nQuantities[n];
//							// as tag show only quantity > 1, as header (static) show any value	// beams are packed if possible
//								if ((bHasStaticLoc && nQuantity>0) || (!bHasStaticLoc && nQuantity>1 && !b.bIsValid()) )
//								{
//									sTokens.append(nQuantities[n]);	
//								}
//							}	
//						}					
//						else if (g.bIsValid() && g.bIsKindOf(Beam()))
//						{ 
//							Beam beam = (Beam)g;
//							if (sVariable=="@(SURFACE QUALITY)") sTokens.append(beam.texture());
//						}
//					// opening unsupported by formatObject
//						else if (o.bIsValid())
//						{ 
//							if (sVariable=="@(WIDTH)") sTokens.append(o.width());
//							else if (sVariable=="@(HEIGHT)") sTokens.append(o.height());
//							else if (sVariable=="@(RISE)") sTokens.append(o.rise());
//						}
					// tslInstance unsupported by formatObject
						else if (t.bIsValid())
						{ 
							if (sVariable=="@(POSNUM)") sTokens.append(t.posnum());
						}						
						//region Sip unsupported by formatObject
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
//							else if (sVariable=="@(Graindirection)".makeUpper())
//								sTokens.append("        ");// 8 blanks
//							else if (sVariable=="@(SipComponent.Name)".makeUpper())
//							{
//								SipComponent component = SipStyle(sip.style()).sipComponentAt(0);
//								sTokens.append(component.name());								
//							}
//							else if (sVariable=="@(SipComponent.Material)".makeUpper())
//							{
//								SipComponent component = SipStyle(sip.style()).sipComponentAt(0);
//								sTokens.append(component.material());								
//							}																
//						}
//					// metalpart collection entity
//						else if (metal.bIsValid())
//						{ 
//							if (sVariable=="@(DEFINITION)") sTokens.append(metal.definition());
//						}
						//End Sip unsupported by formatObject//endregion 						
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

	// build appendix
		for (int i=0;i<sLines.length();i++) 
			sAppendix+= (i>0?"\\P":"")+sLines[i]; 

	//endregion
		
		//ppVp.vis(3);		
	// collect global
		if (bIsGlobal)
			pts = ln.projectPoints(ln.orderPoints(pts, dEps));
		
	// draw per point	
		for (int p=0;p<pts.length();p++) 
		{ 
			Point3d& pt1 = pts[p];			
			
		// calculate coordinate dimension value
			double coordinate = vecDir.dotProduct(pt1 - ptDatum);
			
		// ignore points outside of viewport
			pt1.transformBy(ms2ps);
			if (ppVp.pointInProfile(pt1) != _kPointInProfile)continue;

		// snap to outline if otside and not solid
			if (!bIsGlobal && !bIsSolid && ppRefZone.pointInProfile(pt1)==_kPointOutsideProfile)
			{
				LineSeg segs[] = ppRefZone.splitSegments(LineSeg(pt1 - vecXRead * U(10e4), pt1 + vecXRead * U(10e4)), true);
				Point3d _pts[0];
				for (int s=0;s<segs.length();s++) 
				{ 
					_pts.append(segs[s].ptStart());
					_pts.append(segs[s].ptEnd());
				}//next s
				_pts = Line(_Pt0, vecXRead).orderPoints(_pts);			
				if (_pts.length()>1)
				{ 
					double d1 = abs(vecXRead.dotProduct(pt1-_pts.first()));
					double d2 = abs(vecXRead.dotProduct(pt1-_pts.last()));
					if (d1 < d2)pt1 = _pts.first();
					else pt1 = _pts.last();
				}	
			}
			pt1.vis(5);
			
			
		// format value	
			String value;
			value.formatUnit(coordinate, 2, 0);
			value += sAppendix;
			
		// draw at offset location
			Point3d pt2 =pt1+ vecXRead * dXFlag*(dXOffset+dXLeader);
			dp.draw(value, pt2, vecXRead, vecYRead, dXFlag, 0);
			double dX = dp.textLengthForStyle(value, sDimStyle, dTextHeight);
			double dY = dp.textHeightForStyle(value, sDimStyle, dTextHeight)*1.2;
			
		// get boundings	
			PLine pl(pt2+vecYRead*.5*dY, pt2+vecYRead*.5*dY+dXFlag*vecXRead*dX,pt2-vecYRead*.5*dY+dXFlag*vecXRead*dX,pt2-vecYRead*.5*dY);
			
		// draw leader
			if (dXLeader>0)
			{
				dp.draw(PLine(pt1, pt2));//pt1 - vecXRead * dXFlag*dXLeader));
				pl.addVertex(pt1); // include leader in boundings
			}
			pl.close();
			pl.vis(6);
			ppProtect.joinRing(pl, _kAdd);
			//vecPerp.vis(pt, 3);
		}//next p
	}//next i
//End loop detected entities//endregion 

// publish protection range
	if (ppProtect.area()>pow(dEps,2))
	{
		Map mapProtect;
		mapProtect.setPlaneProfile("ppProtect", ppProtect);
		_ThisInst.setSubMapX("ViewProtect", mapProtect);
	}
	else
		_ThisInst.removeSubMapX("ViewProtect");
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
I!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0!_]D`




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