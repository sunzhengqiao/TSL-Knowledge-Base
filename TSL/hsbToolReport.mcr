#Version 8
#BeginDescription
This tsl creates a schedule table of referenced drills. It can be used in modelspace, paperspace and element layout

#Versions:
Version 1.10 14.07.2025 HSB-24280: Add format properties for diameter and depth , Author: Marsel Nakuci
version value="1.9" date="20sep2019" author="thorsten.huck@hsbcad.com"> 
HSB-5637 subtaype assignment fixed
supports ordering by normal, beveled and edge drills 





#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 10
#KeyWords 
#BeginContents
/// <History>//region
///#Versions:
// 1.10 14.07.2025 HSB-24280: Add format properties for diameter and depth , Author: Marsel Nakuci
/// <version value="1.9" date="20sep2019" author="thorsten.huck@hsbcad.com"> HSB-5637 subtaype assignment fixed  </version>
/// <version value="1.8" date="19apr2018" author="thorsten.huck@hsbcad.com"> supports ordering by normal, beveled and edge drills  </version>
/// <version value="1.7" date="05feb2018" author="thorsten.huck@hsbcad.com"> bugfix symbol projection to Z=0 </version>
/// <version value="1.6" date="26jul2017" author="thorsten.huck@hsbcad.com"> schedule table hidden if no tools collected </version>
/// <version value="1.5" date="25jul2017" author="thorsten.huck@hsbcad.com"> bugfix multiple views </version>
/// <version value="1.4" date="25jul2017" author="thorsten.huck@hsbcad.com"> supports multiple views and non perpendicular drills </version>
/// <version value="1.3" date="24jul2017" author="thorsten.huck@hsbcad.com"> color bars of schedule table display solid for through drills, else it shows a ring </version>
/// <version value="1.2" date="24jul2017" author="thorsten.huck@hsbcad.com"> bugfix sequential colors, headers of schedule table in shopdrawings only created if tools are present, bugfix exclude list </version>
/// <version value="1.1" date="24jul2017" author="thorsten.huck@hsbcad.com"> bugfix scaling shopdrawings </version>
/// <version value="1.0" date="04jul2017" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select entity, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates a schedule table of referenced drills. It can be used in modelspace, paperspace and element layout
/// </summary>//endregion



// constants //region
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));	
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	//endregion

// Display
	category=T("|Display|");
	
	String sDimStyleName=T("|Dimstyle|");	
	PropString sDimStyle(nStringIndex++, _DimStyles, sDimStyleName);
	sDimStyle.setCategory(category);

	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(0), sTextHeightName);	
	dTextHeight.setDescription(T("|Defines the Text Height|") + " " + T("|(0 = by dimstyle)|"));
	dTextHeight.setCategory(category);

	String sColorName=T("|Color|");	
	PropInt nColor(nIntIndex++, 0, sColorName);	
	nColor.setDescription(T("|Defines the Color|"));
	nColor.setCategory(category);
	// HSB-24280
	String sFormatDiameterName=T("|FormatDiameter|");	
	PropString sFormatDiameter(nStringIndex++, "@(Diameter:CU;mm:DN0)", sFormatDiameterName);	
	sFormatDiameter.setDescription(T("|Defines the format for diameter|"));
	sFormatDiameter.setCategory(category);
	
	String sFormatDepthName=T("|FormatDepth|");	
	PropString sFormatDepth(nStringIndex++, "@(Depth:CU;mm:DN0)", sFormatDepthName);	
	sFormatDepth.setDescription(T("|Defines the format for depth|"));
	sFormatDepth.setCategory(category);
	
		
// SETTINGS //region
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sScript = _bOnDebug?"hsbToolReport":scriptName();
	Map mapSetting;

// find settings file
	String sFolders[]=getFoldersInFolder(sPath); 
	int bPathFound;
	if (_bOnInsert)
		bPathFound= sFolders.find(sFolder)>-1?true:makeFolder(sPath+"\\"+sFolder);	
	String sFullPath = sPath+"\\"+sFolder+"\\"+sScript+".xml";
	String sFile=findFile(sFullPath); 

// read a potential mapObject
	MapObject mo(sDictionary ,sScript);
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
	
	
	// build a default map if no settings are found
	int bExportDefaultSetting;
	if (mapSetting.length()<1)
	{ 
	// color mapping
		Map mapSeqs;
		int nSeqColors[]={ 14,144,94,134,174,214,24,64,104,154};

		for (int i=0;i<nSeqColors.length();i++) 
		{ 
			Map mapSeq;
			mapSeq.setInt("Color",nSeqColors[i]);

			mapSeq.setDouble("Transparency",30);
			mapSeqs.appendMap((i+1), mapSeq);
		}
		mapSetting.setMap("SequentialColor[]", mapSeqs);
	
	// exclusion list
		Map mapExlude;
		mapExlude.appendString("ScriptName", "DummyScriptName1");
		mapExlude.appendString("ScriptName", "DummyScriptName2");
		mapSetting.setMap("ExcludeScriptName[]", mapExlude);
		bExportDefaultSetting = true;
	}	//endregion		


// bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		String sKey = _kExecuteKey;
		sKey.makeUpper();

		if (sKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(sScript);
			for(int i=0;i<sEntries.length();i++)
				sEntries[i] = sEntries[i].makeUpper();	
			if (sEntries.find(sKey)>-1)
				setPropValuesFromCatalog(sKey);
			else
				setPropValuesFromCatalog(sLastInserted);					
		}	
		else	
			showDialog();

	// declare a prompt	
		String sPrompt = T("|Select a defining entity (GenBeam, Element, ShopDrawView)|" + " " + T("|<Enter> to select a paperspace viewport|"));
		PrEntity ssE(sPrompt);		
	// add types
		ssE.addAllowedClass(GenBeam());
		ssE.addAllowedClass(Element());
		ssE.addAllowedClass(ShopDrawView());	

	// prompt for entities
	  	if (ssE.go())
			_Entity.append(ssE.set());
			
		if (_Entity.length()<1)
		{ 
			Viewport vp = getViewport(T("|Select a viewport|")); // select viewport
			_Viewport.append(vp);
		}	
		
		_Pt0 = getPoint();
		
		return;
	}	
// end on insert	__________________


// read persistent settings
	Map mapSeqs = mapSetting.getMap("SequentialColor[]");
	Map mapExclude = mapSetting.getMap("ExcludeScriptName[]");
	int nNumSeqColor = mapSeqs.length();

// get exclude list
	String sExcludeScripts[0];
	for (int i=0;i<mapExclude.length();i++) 
	{ 
		String sExcludeScript =mapExclude.getString(i).makeUpper();
		if (sExcludeScript.length()>0)
			sExcludeScripts.append(sExcludeScript); 	 
	}
	

// get mode by reference
	int nMode;
	ShopDrawView sdv;
	ViewData vds[0];
	Element el;
	Entity entDefine;
	
	GenBeam gbDefines[0];
	Viewport vp; // mode=1

// declare transformations
	CoordSys ms2ps, ps2ms;

	Vector3d vecX=_XW, vecY=_YW, vecZ=_ZW;

	Vector3d _vecX, _vecY, _vecZ;
	Point3d _ptCen;
	Quader qdr;

	ViewData vwData;
// viewport mode
	if (_Viewport.length()>0)
	{
		vp =_Viewport[0];
		nMode=1;
		
	// set transformations and collect defining entitiy	
		ms2ps = vp.coordSys();
		ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps
		el = vp.element();	
		gbDefines.append(el.genBeam());		
	}
	else
	{ 
	// loop referenced entities
		for (int i=0; i<_Entity.length(); i++)
		{
			Entity ent=_Entity[i];
		// shopdraw view dependency		
			if (ent.bIsKindOf(ShopDrawView()))
			{
				sdv = (ShopDrawView)ent;
				entDefine=ent;
				nMode=2;
			// get view data		
				int bError = 0; // 0 means FALSE = no error	
				if (!bError && !sdv.bIsValid()) bError = 1;	
				
			// interprete the list of ViewData in my _Map
				ViewData viewDatas[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets,0); // 2 means verbose
				int nIndFound = ViewData().findDataForViewport(viewDatas, sdv);// find the viewData for my view
				if (!bError && nIndFound<0) bError = 2; // no viewData found
			
				Entity ents[0];
				if (!bError)
				{
					vwData = viewDatas[nIndFound];
					vds.append(vwData);
					if (vds.length()>1)
						continue;					
					ms2ps = vwData.coordSys(); // transformation to view
				
				// collect the entities of main view
					ents = vwData.showSetDefineEntities();
					for (int e=0; e<ents.length(); e++)
					{
						Entity _ent=ents[e];
						GenBeam genbeams[0];
					// element
						if (_ent.bIsKindOf(Element()))
						{
							el = (Element)_ent;
							genbeams.append(el.genBeam());	
						}
					// genbeam
						else if (_ent.bIsKindOf(GenBeam()))
						{
							genbeams.append((GenBeam)_ent);
						}	
						for (int g=0; g<genbeams.length(); g++)
							if (gbDefines.find(genbeams[g])<0)
								gbDefines.append(genbeams[g]);
					}
						
				}
				
			// the inverse transformation
				ps2ms = ms2ps;
				ps2ms.invert();		
			}
		// element
			else if (ent.bIsKindOf(Element()))
			{
				el = (Element)ent;
				GenBeam genbeams[0];
				genbeams=el.genBeam();	
				for (int g=0; g<genbeams.length(); g++)
					if (gbDefines.find(genbeams[g])<0)
						gbDefines.append(genbeams[g]);
			}
		// genbeam
			else if (ent.bIsKindOf(GenBeam()))
			{
				GenBeam gb = (GenBeam)ent;
				if (gbDefines.find(gb)<0)
					gbDefines.append(gb);
			}	
		}		
	}
	

// add/remove viewports
	if (nMode==2)
	{ 
	// trigger add view
		String sTriggerAddView = T("|Add View|");
		addRecalcTrigger(_kContext, sTriggerAddView);
		if (_bOnRecalc && _kExecuteKey==sTriggerAddView)
		{
			PrEntity ssE(T("|Select a set of shopdraw views|"), ShopDrawView());
			if (ssE.go()) {
				Entity ents[] = ssE.set();
				for (int e=0; e<ents.length(); e++) 
				{
					ShopDrawView _sdv = (ShopDrawView)ents[e];
					if (!_sdv.bIsValid()) continue;	
					if (_Entity.find(_sdv)<0)
						_Entity.append(_sdv);
				}
			}
			setExecutionLoops(2);
			return;			
		}
	// trigger remove view
		String sTriggerRemoveView = T("|Remove View|");
		if (_Entity.length()>2)
		{ 
			addRecalcTrigger(_kContext, sTriggerRemoveView);
			if (_bOnRecalc && _kExecuteKey==sTriggerRemoveView)
			{
				ShopDrawView sdv = getShopDrawView();
				int n=_Entity.find(sdv);
				if (n>-1)
					_Entity.removeAt(n);
				setExecutionLoops(2);
				return;	
			}		
		}
	
	}

	
// set the scaling	
	double dScale = ps2ms.scale();

// declare display
	Display dp(nColor);
	dp.dimStyle(sDimStyle);
	_ThisInst.setDrawOrderToFront(false);
	
	double dFactor = 1;
	double dTextHeightStyle = dp.textHeightForStyle("O",sDimStyle);
	double dThisTextHeight = dTextHeightStyle;
	if (dTextHeight>0)
	{
		dFactor=dTextHeight/dTextHeightStyle;
		dTextHeightStyle=dTextHeight;
		dp.textHeight(dTextHeight);
		dThisTextHeight = dTextHeight;
	}

	
	
// collect drills
	AnalysedTool tools[0];
	for (int i=0;i<gbDefines.length();i++) 
	{ 
		GenBeam gb = gbDefines[i];
		
	// preset vecs
		if (i==0)
		{
			_vecX = gb.vecX();
			_vecY = gb.vecY();
			_vecZ = gb.vecZ();
			_ptCen = gb.ptCenSolid();
			qdr = Quader(_ptCen, _vecX,_vecY,_vecZ, gb.solidLength(), gb.solidWidth(), gb.solidHeight(),0,0,0);
		}		
		tools.append(gbDefines[i].analysedTools(1)); 	 
	}
	AnalysedDrill drills[]=AnalysedDrill().filterToolsOfToolType(tools);
 

 // remove drills 
 // - which toolEnt is in list of exclude scripts

	 for (int i=drills.length()-1; i>=0 ; i--) 
	 { 
	 	//reportMessage("\ndrill " + i + " of " + drills.length());
	 	Entity ent=drills[i].toolEnt(); 
	 	TslInst tsl = (TslInst)ent;
	 	if (tsl.bIsValid())
	 	{
	 		String sScriptName=tsl.scriptName().makeUpper();
	 		
	 		if (sExcludeScripts.find(sScriptName)>-1)
	 		{
	 			//reportMessage("\n" + sScriptName + " based drill removed");
	 			drills.removeAt(i);
	 		}
	 	} 
	 }


// erase me if no tools found
	if (nMode==0 && drills.length()<1)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|no tools found to be reported.|"));
		
		eraseInstance();
		return;
	}
 
 
 // order drills by depth and diameter
	for (int i=0;i<drills.length();i++) 
		for (int j=0;j<drills.length()-1;j++)
			if (drills[j].dDepth()>drills[j+1].dDepth())
			{
				drills.swap(j,j+1);
			}
	for (int i=0;i<drills.length();i++) 
		for (int j=0;j<drills.length()-1;j++)
			if (drills[j].dDiameter()>drills[j+1].dDiameter())
			{
				drills.swap(j,j+1);
			}
			
 // by side
	for (int i=0;i<drills.length();i++) 
		for (int j=0;j<drills.length()-1;j++)
		{
			if (drills[j].vecFree().isParallelTo(_vecZ)<drills[j+1].vecFree().isParallelTo(_vecZ))
			{
				drills.swap(j,j+1);
			}
		}
		
		
//// order types alphabetically
//	for (int i=0;i<drills.length();i++) 
//		for (int j=0;j<drills.length()-1;j++) 
//		{
//			String s1 = drills[j].toolType();
//			String s2 = drills[j+1].toolType();
//			if (s1>s2)
//			{
//				drills.swap(j, j + 1);
//			}
//		}		
		 
 
 // build a map with one entry per diameter/depth	
 	Map mapDrills;	
	for (int i=0;i<drills.length(); i++) 	
	{ 
		AnalysedDrill drill = drills[i];
		
		String sDiameter = drill.dDiameter();
		for (int j=0;j<10-sDiameter.length();j++) 
			sDiameter="0"+sDiameter;
		
		String sDepth = drill.dDepth();
		for (int j=0;j<10-sDepth.length();j++) 
			sDepth="0"+sDepth;	
		
		drills[i].vecSide().vis(drills[i].ptStart(), i);
		
	// build a sort key
		String sSortKey=1;
		if (drills[i].vecFree().isParallelTo(_vecZ))
			sSortKey = 0;
		else if (drills[i].vecSide().isPerpendicularTo(_vecZ))	
			sSortKey = 2;

			
			
		String sEntryName = sSortKey+"_"+sDiameter +  sDepth;//

		Map mapDrill= mapDrills.getMap(sEntryName);
		mapDrill.appendInt("Drill",i);
		mapDrills.setMap(sEntryName, mapDrill);	
	}

// order map by key
	Map mapTemp;
	for (int k=0;k<3;k++) 
		for (int i=0;i<mapDrills.length();i++)
			if (mapDrills.keyAt(i).left(1).atoi()==k)	
				mapTemp.appendMap(mapDrills.keyAt(i), mapDrills.getMap(i));
	mapDrills = mapTemp;	



// get column width, min 4x textHeight
	double dColWidths[0], dTotalWidth;
	String sHeaders[] ={T("|Color|"),T("|Qty|"),T("|Ø|"),T("|Depth|")};
	for (int i=0;i<sHeaders.length();i++) 
	{ 
		double dL=dp.textLengthForStyle(sHeaders[i],sDimStyle)*dFactor*1.2;
		double dColWidth = dL<=4*dThisTextHeight?4*dThisTextHeight:dL;
		dColWidths.append(dColWidth);
		dTotalWidth+=dColWidth;
	}
	
// draw headers
	Vector3d vecDir = -vecY;
	Point3d ptTxt=_Pt0+vecDir*.5*dThisTextHeight;
	Point3d pt=ptTxt;
	double dColWidth;
	PLine pl;
	if (mapDrills.length()>0 || (nMode==2 && _bOnGenerateShopDrawing!=TRUE))
	{
		for (int i=0;i<sHeaders.length();i++)
		{ 
			String sValue = sHeaders[i];
			dColWidth = dColWidths[i];
			
			Point3d _pt=pt+vecDir*dThisTextHeight*2;
	
		// text
			pt.transformBy(vecX*.5*dColWidth);
			dp.draw(sValue, pt, vecX, vecY, 0,-1);
			pt.transformBy(vecX*.5*dColWidth);
						
		// draw box	
			pl.createRectangle(LineSeg(_pt,pt), vecX, vecY);
			pl.transformBy(-vecDir*.5*dThisTextHeight);
			dp.draw(pl);
		}
		ptTxt.transformBy(vecDir*dThisTextHeight*2); 
	}

// draw, but only if not during shopdraw generation
	if (_bOnGenerateShopDrawing!=TRUE) 
	{
		for (int e=0;e<_Entity.length(); e++) 
		{
			ShopDrawView sdvThis = (ShopDrawView)_Entity[e];
			if (!sdvThis .bIsValid())	{continue;}
			Point3d pt1, pt2, pt3, pt4;
			pt4 = sdvThis.coordSys().ptOrg();
			pt1 = pl.closestPointTo(pt4);
			
			Point3d ptMid = (pt1+pt4)/2;
			pt2 = pt1-_YW*_YW.dotProduct(pt1-ptMid);
			pt3 = pt4-_YW*_YW.dotProduct(pt4-ptMid);
			dp.draw(PLine(pt1,pt2,pt3,pt4));
		}
	}


	
// draw by entry list
	int c = mapSetting.getInt("DrillTypeColor[]\Normal");
	if (c>0)dp.color(c);
	int bDrawSeparationLine=true; // if any non vecZ aligned drill is present draw a separation line to indicate these drills
	int bDrawSeparationLine2=true; // if any non vecZ aligned drill is present draw a separation line to indicate these drills
	for (int i=0;i<mapDrills.length();i++) 
	{ 
	// get content of each entry
		Map map = mapDrills.getMap(i);
		//String key = mapDrills.keyAt(i);
		
	// quantity
		int nQty = map.length();
		int nIndex =map.hasInt("Drill")?map.getInt("Drill"):-1;
	
	// get FirstOrDefault AnalysedDrill
		AnalysedDrill drillDefault;
		if (nIndex>-1 && nIndex<drills.length())
			drillDefault = drills[nIndex];
		
		double dDiameter,dDepth;
		String sDiameterFormat,sDepthFormat;
		if (drillDefault.bIsValid())
		{
			dDiameter= round(drillDefault.dDiameter());
			dDepth = round(Vector3d(drillDefault.ptStartExtreme()-drillDefault.ptEndExtreme()).length());//drillDefault.dDepth());
			GenBeam gb = drillDefault.genBeam();
			// HSB-24280
			Map mapAdd;
			double dDiam=drillDefault.dDiameter();
			double dDep=Vector3d(drillDefault.ptStartExtreme()-drillDefault.ptEndExtreme()).length();
			mapAdd.appendDouble("Diameter",dDiam);
			mapAdd.appendDouble("Depth",dDep);
			sDiameterFormat=gb.formatObject(sFormatDiameter,mapAdd);
			sDepthFormat=gb.formatObject(sFormatDepth,mapAdd);
		}

	// draw one line per entry
		Point3d pt=ptTxt;
//		String sValues[]= {"",nQty,dDiameter,dDepth};
		String sValues[]= {"",nQty,sDiameterFormat,sDepthFormat};
		int c=0;
		
		for (int c=0;c<dColWidths.length();c++) 
		{ 
			String sValue = sValues[c];
			dColWidth = dColWidths[c];
			
		// draw separation line once if non Z drills are present
			if (bDrawSeparationLine && mapDrills.keyAt(i).left(1)=="1")
			{ 
				int c = mapSetting.getInt("DrillTypeColor[]\Beveled");
				if (c>0)dp.color(c);
				pt.vis(6);
				bDrawSeparationLine=false;
				
			// draw separation line
				PLine pl;
				pl.createRectangle(LineSeg(pt,pt+vecX*dTotalWidth+vecDir*dThisTextHeight*.2), vecX, vecY);
				pl.transformBy(-vecDir*.6*dThisTextHeight);
				dp.draw(PlaneProfile(pl), _kDrawFilled);				
				
			}
		// draw separation line once if non Z drills are present
			else if (bDrawSeparationLine2 && mapDrills.keyAt(i).left(1) == "2")
			{
				int c = mapSetting.getInt("DrillTypeColor[]\Edge");
				if (c>0)dp.color(c);
				pt.vis(6);
				bDrawSeparationLine2 = false;
				
				// draw separation line
				PLine pl;
				pl.createRectangle(LineSeg(pt, pt + vecX * dTotalWidth + vecDir * dThisTextHeight * .2), vecX, vecY);
				pl.transformBy(-vecDir * .6 * dThisTextHeight);
				dp.draw(PlaneProfile(pl), _kDrawFilled);
			}
												
			Point3d _pt=pt+vecDir*dThisTextHeight*2;

		// text	
			pt.transformBy(vecX*(dColWidth-dThisTextHeight));
			dp.draw(sValue, pt, vecX, vecY, -1,-1);	 
			pt.transformBy(vecX*(dThisTextHeight));
		
		// draw box
			PLine pl;
			pl.createRectangle(LineSeg(_pt,pt), vecX, vecY);
			pl.transformBy(-vecDir*.5*dThisTextHeight);
			dp.draw(pl);
			

			
			
		// draw colored box 
			if (c==0)
			{
			
			// get potential sequential color definition
				int _color=i+1;
				int _transparency=0;

			// make sure the requested key index is defined, keep repeating colors if list of definition is too short	
				while(_color>nNumSeqColor)
				{
					_color-=nNumSeqColor;
				}
				
				if (mapSeqs.hasMap((String)_color))
				{ 
					Map m=mapSeqs.getMap((String)_color);
					String key;
					key = "Color";
					if (m.hasInt(key))
						_color=m.getInt(key);
					key = "Transparency";
					if (m.hasDouble(key))
						_transparency=m.getDouble(key);
				}
				
				
				Display dpX(_color);
			
			// schedule	
				PlaneProfile pp(pl);
				pp.shrink(.5*dThisTextHeight);
				if (!drillDefault.bThrough())
				{ 
					PlaneProfile ppSub=pp;
					ppSub.shrink(.3*dThisTextHeight);
					pp.subtractProfile(ppSub);
					
				}

				if (_transparency>0)
					dpX.draw(pp,_kDrawFilled,_transparency);
				else
					dpX.draw(pp,_kDrawFilled);
				
			// model / XSpace
				for (int j=0;j<map.length();j++) 
				{ 
					int n =map.hasInt(j)?map.getInt(j):-1; 

				// get FirstOrDefault AnalysedDrill
					AnalysedDrill drill;
					if (n>-1 && n<drills.length())
						drill = drills[n];

					if (drill.bIsValid())
					{
						double dRadius= drill.dRadius();
						Point3d ptStart = drill.ptStart();
						Point3d ptStartExtreme = drill.ptStartExtreme();
						Point3d ptEndExtreme = drill.ptEndExtreme();
						
						int bIsPerpendicular = drill.toolSubType()==_kADPerpendicular;
						double _dZ;
					
						//if (gbDefines.length()>1)
						{ 
							GenBeam gb = drill.genBeam();
							_vecX = gb.vecX();
							_vecY = gb.vecY();
							_vecZ = gb.vecZ();	
							_ptCen = gb.ptCenSolid();
							_dZ = gb.solidHeight();
							qdr = Quader(_ptCen, _vecX,_vecY,_vecZ, gb.solidLength(), gb.solidWidth(), _dZ,0,0,0);
						}
						
					// get vecFace as most aligned to the quader
						Vector3d vecFace = qdr.vecD(drill.vecFree());
						// make sure 45° aligned drills do not use the most aligned vec towards X or Y
						double dZExtr = abs(_vecZ.dotProduct(_ptCen-ptStartExtreme));
						if (dZExtr>_dZ*.5 && vecFace.isPerpendicularTo(_vecZ))
							vecFace = vecFace.dotProduct(_vecZ)>0?-_vecZ:_vecZ;						
						vecFace.vis(ptStart, 1);
					
					
					// set transformation to most aligend view
						CoordSys _ms2ps=ms2ps;
						int nFlip=1;
						if (nMode==2 && vds.length()>1)
						{ 
						// loop views
							for (int v=0;v<vds.length();v++) 
							{ 
								ViewData vd = vds[v];
								CoordSys cs = vd.coordSys();
								CoordSys _cs=cs;
								_cs.invert();
								Vector3d vec=_ZW;
								vec.transformBy(_cs);
								if (vec.isParallelTo(vecFace))
								{ 
									_ms2ps=cs;
									//reportMessage("\ndrill " + i + " " + drill.vecFree() + " in view " + v);
									break;
								}	 
							}
						}
						CoordSys _ps2ms=_ms2ps;
						_ps2ms.invert();
//
					// declare profile
						PLine pl;
						pl.createCircle(ptStart, vecFace, dRadius);
						PlaneProfile pp(pl.coordSys());
						
					// use slice for any tilted	
						if (!bIsPerpendicular)
						{ 
							Body bd(ptStartExtreme,ptEndExtreme, dRadius);
							pp = bd.getSlice(Plane(ptStart, vecFace));
//							if (!drill.bThrough())
//							{ 
//								PLine pl; pl.createRectangle(LineSeg(ptStart-vecXView*dRadius*5,ptStart+dRadius*5*(vecXView-nFlip*vecYView)), vecXView, vecYView);
//								pl.vis(2);
//								pp.joinRing(pl,_kSubtract);
//							}
						}
					// add circle
						else
							pp.joinRing(pl,_kAdd);
						
					// subtract 1/3 part of profile if not through
						if (!drill.bThrough() && bIsPerpendicular)
						{ 
							PlaneProfile ppSub=pp;
							ppSub.shrink(.66*dRadius);
							pp.subtractProfile(ppSub);
						}
							
						pp.transformBy(_ms2ps);
					
					

					
					
					// subtract upper or lower part if not through
						if (!drill.bThrough())
						{ 
							LineSeg seg = pp.extentInDir(vecX);
							double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
							double dY = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
						
						// orientation
							Vector3d vec = vecFace;
							vec.transformBy(_ms2ps);
							int nFlip = vec.dotProduct(vecZ)<0?1:-1;
						
							PLine pl;
							pl.createRectangle(seg, vecX,vecY);
							pl.transformBy(nFlip * vecY*.5*dY);
							pp.joinRing(pl,_kSubtract);
						}	
						
		
					// project to world
						if (nMode==2)
							pp.transformBy(_ZW*_ZW.dotProduct(_PtW-pp.coordSys().ptOrg()));
							
						dpX.draw(pp);
							
						
						Display dpDrill(_color);
						if (!bDebug)
						{
							dpDrill.addViewDirection(qdr.vecD(vecFace));
							dpDrill.addViewDirection(qdr.vecD(-vecFace));
						}

						if (_transparency>0)
							dpDrill.draw(pp,_kDrawFilled,_transparency);
						else
							dpDrill.draw(pp,_kDrawFilled);	
					}
				}
			}
		}
		ptTxt.vis(i);
		ptTxt.transformBy(vecDir*dThisTextHeight*2); 
	}
	
// EXPORT/UPDATE
	if (bExportDefaultSetting && sFile.length()<1)
	{ 
		String sExportSettingsTrigger = T("|Export Default Settings|");
		addRecalcTrigger(_kContext,sExportSettingsTrigger );				
		if (_bOnRecalc && _kExecuteKey == sExportSettingsTrigger )
		{
			mapSetting.writeToXmlFile(sFullPath);	
			reportNotice("\n" + scriptName()  +TN("|A settings default file is written to|") + "\n\n" + sFullPath + "\n\n" + 
				T("|You can now adjust your settings and reload them into the drawing using 'Import TSL Settings' (hsbTslSettingsIO)|") );
			
		}
	}

	


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
        <int nm="BreakPoint" vl="575" />
      </lst>
    </lst>
  </lst>
  <lst nm="TslInfo">
    <lst nm="TSLINFO" />
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24280: Add format properties for diameter and depth" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="10" />
      <str nm="Date" vl="7/14/2025 2:55:33 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End