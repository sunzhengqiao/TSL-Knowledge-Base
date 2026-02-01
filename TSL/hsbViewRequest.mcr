#Version 8
#BeginDescription
This tsl draws pline, planeprofile or text requests specified in model tsls on a section.

#Versions
Version 1.1 23.11.2022 HSB-17135 painter definitions recreated in any dwg
Version 1.0 22.11.2022 HSB-17135 initail version of hsbViewRequest
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
//region <History>
// #Versions
// 1.1 23.11.2022 HSB-17135 painter definitions recreated in any dwg , Author Thorsten Huck

/// <insert Lang=en>
/// Select a section
/// </insert>

// <summary Lang=en>
// This tsl draws pline, planeprofile or text requests specified in model tsls on a section.
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbViewRequest")) TSLCONTENT
//endregion



//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;

	String tLastInserted =T("|_LastInserted|");
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	
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


	String kViewportOrg = "vecViewportOrg", tDefault = T("<|Default|>"), tDisabledEntry = T("<|Disabled|>");
	String kRequests = "DimRequest[]", kAllowedView = "AllowedView";
//end Constants//endregion

//region Painter streams
	String sAllPainters[] = PainterDefinition().getAllEntryNames().sorted();

	String sPainterStreamName=T("|Painter Definition|");	
	PropString sPainterStream(3, "", sPainterStreamName);	
	sPainterStream.setDescription(T("|Stores the data of the used painter definition to copy the definition via catalog|"));
	sPainterStream.setCategory(category);
	sPainterStream.setReadOnly(bDebug?0:_kHidden);

	String sExcludePainterStreamName=T("|Exclude Painter Definition|");	
	PropString sExcludePainterStream(4, "", sExcludePainterStreamName);	
	sExcludePainterStream.setDescription(T("|Stores the data of the used painter definition to copy the definition via catalog|"));
	sExcludePainterStream.setCategory(category);
	sExcludePainterStream.setReadOnly(bDebug?0:_kHidden);

	// on insert read catalogs to copy / create painters based on catalog entries
	if (_bOnInsert || _bOnElementConstructed)
	{ 
	// collect streams	
		String streams[0];
		String sScriptOpmName = bDebug?"hsbViewRequest":scriptName();
		String entries[] = TslInst().getListOfCatalogNames(sScriptOpmName);
		for (int i=0;i<entries.length();i++) 
		{ 
			String& entry = entries[i]; 
			Map map = TslInst().mapWithPropValuesFromCatalog(sScriptOpmName, entry);
			Map mapProp = map.getMap("PropString[]");
			
			for (int j=0;j<mapProp.length();j++) 
			{ 
				Map m = mapProp.getMap(j);
				int index = m.getInt("nIndex");
				String stream = m.getString("strValue");
				if ((index== 3 ||index==4) && streams.findNoCase(stream,-1)<0)
				{ 
					streams.append(stream);
				}
			}//next j 
		}//next i
		
	// process streams
		for (int i=0;i<streams.length();i++) 
		{ 	
			String& stream = streams[i];
			String _painters[0];
			_painters = sAllPainters;
			if (stream.length()>0)
			{ 
			// get painter definition from property string	
				Map m;
				m.setDxContent(stream , true);
				String name = m.getString("Name");
				String type = m.getString("Type").makeUpper();
				String filter = m.getString("Filter");
				String format = m.getString("Format");
				
			// create definition if not present	
				if (m.hasString("Name") && m.hasString("Type") && _painters.findNoCase(name,-1)<0 && name!=tDisabledEntry) // name.find(sPainterCollection,0,false)>-1 && 
				{ 
					PainterDefinition pd(name);
					pd.dbCreate();
					pd.setType(type);
					pd.setFilter(filter);
					pd.setFormat(format);
					
					if (pd.bIsValid())
					{ 
						sAllPainters.append(name);
					}
				}
			}
		}		
	}

//endregion 

//region Painter Collections
	String sPainterCollection = "Dimension\\";
	String sPainters[0];
	for (int i=0;i<sAllPainters.length();i++) 
	{ 
		if (sAllPainters[i].find(sPainterCollection,0,false)==0)
		{
			String s = sAllPainters[i];
			s = s.right(s.length() - sPainterCollection.length());
			if (sPainters.findNoCase(s,-1)<0)
				sPainters.append(s);
		}		 
	}//next i
	int bFullPainterPath = sPainters.length() < 1;
	if (bFullPainterPath)
	{ 
		for (int i=0;i<sAllPainters.length();i++) 
		{ 
			String s = sAllPainters[i];
			if (sPainters.findNoCase(s,-1)<0)
				sPainters.append(s);
		}//next i		
	}
	sPainters.insertAt(0, tDisabledEntry);
//endregion 


//region Properties
category = T("|General|");
	String sPainterName=T("|Filter|");	
	String sPainterDesc = T(" |If a painter collection named 'Dimension' is found only painters of this collection are considered.|");
	PropString sPainter(nStringIndex++, sPainters, sPainterName);	
	sPainter.setDescription(T("|Defines the painter definition to filter entities.|") +sPainterDesc );
	sPainter.setCategory(category);
	int nPainter = sPainters.find(sPainter);
	if (nPainter<0){ nPainter=0;sPainter.set(sPainters[nPainter]);}
	String sPainterDef = bFullPainterPath ? sPainter : sPainterCollection + sPainter;

	String sExcludePainterName=T("|TSL Exclude Filter|");	
	PropString sExcludePainter(nStringIndex++, sPainters, sExcludePainterName);	
	sExcludePainter.setDescription(T("|Defines the painter definition to exclude requests of specified tsls|") +sPainterDesc );
	sExcludePainter.setCategory(category);
	int nExcludePainter = sPainters.find(sExcludePainter);
	if (nExcludePainter<0){ nExcludePainter=0;sExcludePainter.set(sPainters[nExcludePainter]);}
	String sExcludePainterDef = bFullPainterPath ? sExcludePainter : sPainterCollection + sExcludePainter;

category = T("|Display|");
	String sDimStyleName=T("|Dimstyle|");	
	String sDimStyles[0]; sDimStyles = _DimStyles.sorted();
	sDimStyles.insertAt(0, tDefault);
	PropString sDimStyle(nStringIndex++, sDimStyles, sDimStyleName);	
	sDimStyle.setDescription(T("|Defines the Dimstyle|"));
	sDimStyle.setCategory(category);
	
	if (sDimStyles.find(sDimStyle) < 0)sDimStyle.set(sDimStyles.first());	


	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(0), sTextHeightName, _kLength);	
	dTextHeight.setDescription(T("|Defines the text height of the dimension|") + T(", |0 = byRequest|"));
	dTextHeight.setCategory(category);	



//End Properties//endregion 


// References
	int nColor;
	int bHasPage, bHasSection, bInBlockSpace, bHasSDV, bHasViewport = _Viewport.length() > 0, bIsHsbViewport;
	int	bIsViewportSetup;	// true if the instance is a setup instance placed outside of paperspace

	MultiPage page;
	ShopDrawView sdv;
	GenBeam gb;
	EntPLine epl;	
	MetalPartCollectionEnt ce;
	Element el;
	Entity entDefine, showSet[0];
	Element elParent;
	Section2d section;ClipVolume clipVolume;
	
	CoordSys cs(),ms2ps, ps2ms;
	double dScale = 1;
	Vector3d vecX=_XU, vecY=_YU, vecZ = _ZU;
	int bDeltaOnTop = true;	


//region OnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		if (_kExecuteKey.length()>0 && TslInst().getListOfCatalogNames(scriptName()).findNoCase(_kExecuteKey,-1)>-1)
			setPropValuesFromCatalog(_kExecuteKey);						
	// standard dialog	
		else	
			showDialog();
		
	// get current space and property ints
		int bInLayoutTab = Viewport().inLayoutTab();
		int bInPaperSpace = Viewport().inPaperSpace();
		int hasSDV; 
		
	// find out if we are block space and have some shopdraw viewports
		Entity entsSDV[0];
//		if (!bInLayoutTab)
//		{
//			entsSDV= Group().collectEntities(true, ShopDrawView(), _kAllSpaces);
//		
//		// shopdraw viewports found and no genbeams or multipages are found
//			if (entsSDV.length()>0)
//			{ 
//				hasSDV = true;
//				Entity ents[]= Group().collectEntities(true, GenBeam(), _kAllSpaces);
//				ents.append(Group().collectEntities(true, MultiPage(), _kAllSpaces));
//				if (ents.length()<1)
//				{ 
//					bInBlockSpace = true;
//				}
//			}
//		}	
//	// Paperspace	
//		if (bInLayoutTab && bInPaperSpace)
//		{
//			Viewport vp;
//			_Viewport.append(getViewport(T("|Select a viewport|")));
//			vp = _Viewport[_Viewport.length()-1]; 
//			dScale = vp.dScale();
//			elParent = vp.element();
//			ms2ps = vp.coordSys();
//			vecX = _XW; vecY = _YW; vecZ = _ZW;
//			
//			
//			int bIsSetup = true;
//
//			String prompt = T("|Pick point left and outside of paperspace|") ;
//			
//			Point3d pt = getPoint(prompt);
//
//			int bUseTextHeight;
//			Display dp(nColor);
//			String dimStyle = sDimStyle;
//			if (_DimStyles.find(sDimStyle)<0)
//				dimStyle = _DimStyles.first();
//			dp.dimStyle(dimStyle, dScale);
//			
//			double textHeight = dTextHeight*dScale;
//			double textHeightForStyle = dp.textHeightForStyle("O", dimStyle)*dScale;
//			if (dTextHeight<= 0) 
//				textHeight = textHeightForStyle;
//
//			double dX = 9 * textHeight;
//			double dY = 4 * textHeight;
//			Vector3d vec = - _XW + _YW; vec.normalize();
//			_Pt0 = pt+.5*(_XW+_YW)*dY+vec*.5*dY;
//			_PtG.append(_Pt0 +vec * textHeight*.5); 
//			_Map.setVector3d(kViewportOrg, pt-_PtW);
//			return;
//		}
//		
//		
//		else
		{
		// prompt for entities
			PrEntity ssE;
//			if (bInBlockSpace)
//			{ 
//				ssE = PrEntity(T("|Select shopdraw viewports|"), ShopDrawView());
//			}
//			else if (hasSDV)
//			{ 
//				ssE = PrEntity(T("|Select reference (genbeams, elements, multipages, sections or shopdraw viewports|"), ShopDrawView());
//				ssE.addAllowedClass(MultiPage());
//			}		
//			else
//			{
//				ssE = PrEntity(T("|Select reference (genbeams, elements, multipages, sections or shopdraw viewports|"), MultiPage());
//			}
			ssE = PrEntity(T("|Select a section|"), Section2d());
	
//			ssE.addAllowedClass(GenBeam());
//			ssE.addAllowedClass(Element());
//			ssE.addAllowedClass(ChildPanel());	
//			ssE.addAllowedClass(EntPLine());
//			ssE.addAllowedClass(MetalPartCollectionEnt());
//			ssE.addAllowedClass(Section2d());
			
			if (ssE.go())
				_Entity.append(ssE.set());			
		}
			
		return;
	}			
//endregion 


//region Display

	String dimStyle = sDimStyle;
	if (_DimStyles.find(sDimStyle)<0)
		dimStyle = _DimStyles.first();

	int bUseTextHeight;
	Display dp(nColor);
	dp.dimStyle(dimStyle, dScale);
	dp.addHideDirection(vecX);
	dp.addHideDirection(-vecX);
	dp.addHideDirection(vecY);
	dp.addHideDirection(-vecY);
	
	double textHeight = dTextHeight*dScale;
	if (dTextHeight<= 0) 
		textHeight = dp.textHeightForStyle("O", dimStyle)*dScale;
	else 
	{
		bUseTextHeight = true;
		dp.textHeight(textHeight);
	}

//endregion 


//region Write painter data to properties
	PainterDefinition pd , pdEx;
	if (nPainter > 0)
		pd = PainterDefinition(sPainterDef);	
	if (nExcludePainter> 0)
		pdEx = PainterDefinition(sExcludePainterDef);	
	String entry = sPainter; entry+= sExcludePainter;
	if (pd.bIsValid())
	{ 	
		Map m;
		m.setString("Name", pd.name());
		m.setString("Type",pd.type());
		m.setString("Filter",pd.filter());
		m.setString("Format",pd.format());
		sPainterStream.set(m.getDxContent(true));
		_ThisInst.setCatalogFromPropValues(entry);
	}
	if (pdEx.bIsValid())
	{ 
		Map m;
		m.setString("Name", pdEx.name());
		m.setString("Type",pdEx.type());
		m.setString("Filter",pdEx.filter());
		m.setString("Format",pdEx.format());
		sExcludePainterStream.set(m.getDxContent(true));
		_ThisInst.setCatalogFromPropValues(entry);
	}	
//End Write painter data to properties//endregion 



//region Collect entities
	Vector3d vecZModelView = _ZW;
	Plane pnRef(_PtW, _ZW);
	Entity entities[0];
	for (int i=0;i<_Entity.length();i++) 
	{ 
		Entity ent = _Entity[i];

	//region Section
		Section2d _section = (Section2d) ent;
		if (_section.bIsValid())
		{ 
			//TODO scale
			section = _section;
			bHasSection = true;
			setDependencyOnEntity(ent);
			assignToGroups(ent, 'I');
			entDefine = ent;
			
			ms2ps = section.modelToSection();
			ps2ms = ms2ps; 	ps2ms.invert();	
			vecX = _XW; vecY = _YW; vecZ = _ZW;			

			pnRef = Plane(section.coordSys().ptOrg(), section.coordSys().vecZ());
			cs = section.coordSys();
			
		// clip volume		
			clipVolume= section.clipVolume();
			if (!clipVolume.bIsValid())
			{ 
				eraseInstance();
				return;
			}
			_Entity.append(clipVolume);			
			setDependencyOnEntity(clipVolume);
		
			entities = clipVolume.entitiesInClipVolume(true);
		
		// store the initial entity set
			if (_bOnDbCreated)
			{ 
				_Map.setEntityArray(entities, false, "Entity[]", "", "Entity");
			}			
			
			
			
		//region Set the included set 	
			if (_bOnDbCreated || _bOnRecalc || bDebug || _kNameLastChangedProp == sPainterName)
			{ 
				if (nPainter > 0)
				{ 
					PainterDefinition pd(sPainterDef);
					Entity entsPD[]= pd.filterAcceptedEntities(entities);
					if (entsPD.length() < entities.length())
					{
					// collect entitries to be excluded	
						Entity entsEx[0];
						for (int j=0;j<entities.length();j++) 
							if (entsPD.find(entities[j])<0)
								entsEx.append(entities[j]);	 
					
						if (entsPD.length()<1)
						{
							reportMessage(TN("|The entities of the section were not modfiied by the selected filter| ") + sPainter +
								TN("|The result would set the section invisible as no entities remain in the set.|"));
						}							
						else
						{
							clipVolume.setIncludedEntities(entsPD);	
							clipVolume.setExclusionEntities(entsEx);	
							
							pushCommandOnCommandStack("_AEC2DSECTIONRESULTREFRESH");
	 						pushCommandOnCommandStack("(handent \""+section.handle()+"\")");
							pushCommandOnCommandStack("(Command \"\")");

							
							reportMessage(TN("|The entities of the section have been modfiied by the selected filter| ") + sPainter + " ("+entsPD.length()+")");
						}
					}					
				}
				else if (nPainter==0 && _kNameLastChangedProp == sPainterName)
				{ 
					Entity ents[]= _Map.getEntityArray("Entity[]", "", "Entity");
					if (ents.length() < 1)
					{
						reportMessage(TN("|The entities of the section could not be restored|"));
					}
					else
					{	
						Entity entsEx[0];
						clipVolume.setExclusionEntities(entsEx);
						clipVolume.setIncludedEntities(ents);
						reportMessage(TN("|The entities of the section have been restored|") + " ("+ents.length()+")");
						
						pushCommandOnCommandStack("_AEC2DSECTIONRESULTREFRESH");
 						pushCommandOnCommandStack("(handent \""+section.handle()+"\")");
						pushCommandOnCommandStack("(Command \"\")");	

					}					
				}
			}
		//endregion 	

		// set _Pt0 to lower left of section		
			Body bd =clipVolume.clippingBody();
			bd.transformBy(ms2ps);		bd.vis(3);
			PlaneProfile pp(cs);
			pp.unionWith(bd.shadowProfile(pnRef));
			if (pp.area()>pow(dEps,2))
				_Pt0 = pp.ptMid() - .5 * (vecX * pp.dX() + vecY * pp.dY());
			break;
		}				
	//endregion 


		
	}	
	vecZModelView.transformBy(ps2ms); vecZModelView.normalize();
	//pnRef.vis(2);
	

// purge if Section2D is invalid
	if (clipVolume.bIsValid() && !bHasSection)
	{ 
		eraseInstance();
		return;
	}





//endregion 	

//region Resolve Entities
	Map mapRequests;
	TslInst tsls[0];
	Beam beams[0];
	Sip panels[0];
	Sheet sheets[0];


// Exclude TSL Filter
	String sExcludeScripts[0];
	if (nExcludePainter>0) // collect exclude tsls from model set
	{ 
		TslInst tslEx[0];
		PainterDefinition pdEx(sExcludePainterDef);
		Entity entsEx[] = pdEx.filterAcceptedEntities(entities);
		
		for (int j=0;j<entsEx.length();j++) 
		{ 
			TslInst t = (TslInst)entsEx[j];
			if (!t.bIsValid()){ continue;}
			String s= t.scriptName();
			if (sExcludeScripts.findNoCase(s,-1)<0)
				sExcludeScripts.append(s);				 
		}//next j
	}	


// Entity filtering
	if (nPainter > 0)
	{
		PainterDefinition pd(sPainterDef);
		entities = pd.filterAcceptedEntities(entities);
	}

	for (int i = 0; i < entities.length(); i++)
	{
		Entity& ent = entities[i];
		
		//if (bDebug)reportNotice("\n	resolving " + i + " = " + ent.typeDxfName() + " " + ent.handle());
		
		gb=(GenBeam)ent;
		epl=(EntPLine)ent;
		ce = (MetalPartCollectionEnt)ent;
		el = (Element)ent;
		TslInst tsl=(TslInst)ent;


	// append potential requests stored in submapX
		if(ent.subMapXKeys().findNoCase("Hsb_DimensionInfo",-1)>-1)
		{ 
			Map _mapRequests = ent.subMapX("Hsb_DimensionInfo\\DimRequest[]");
			for (int j=0;j<_mapRequests.length();j++) 
				mapRequests.appendMap("Request",_mapRequests.getMap(j)); 
		
		}

	// GenBeam	
		if (gb.bIsValid())
		{
			Sip panel = (Sip)gb;
			Sheet sheet = (Sheet)gb;
			Beam beam = (Beam)gb;
			
			if (panel.bIsValid())
				panels.append(panel);
			else if (beam.bIsValid())
				beams.append(beam);
			else if (panel.bIsValid())
				sheets.append(sheet);
				
			
			Body bd = gb.realBody();
			bd.transformBy(ms2ps);
			bd.vis(i);
			
		//region Get valid tsls
			TslInst ts[] = gb.tslInstAttached();
			
			Entity tents[] = gb.eToolsConnected();
			for (int j=0;j<tents.length();j++) 
			{ 
				TslInst t= (TslInst)tents[j]; 
				if (t.bIsValid() && ts.find(t)<0)
					ts.append(t);				 
			}//next j
			
		// append exclusion entries if not found yet
			if (nExcludePainter>0)
			{ 
				TslInst tslEx[0];
				PainterDefinition pdEx(sExcludePainterDef);
				tslEx = pdEx.filterAcceptedEntities(ts);
				
				for (int j=0;j<tslEx.length();j++) 
				{ 
					String s= tslEx[j].scriptName();
					if (sExcludeScripts.findNoCase(s,-1)<0)
						sExcludeScripts.append(s);				 
				}//next j
			}
		
		// remove any if in the exclude list
			for (int j=ts.length()-1; j>=0 ; j--) 
				if (sExcludeScripts.findNoCase(ts[j].scriptName(),-1)>-1)
					ts.removeAt(j); 
		//endregion 		


		//region Collect requests
			for (int j=0;j<ts.length();j++) 
			{ 
				TslInst t= ts[j]; 
				int bHasRequest;
				Map m = t.map().getMap(kRequests);
				for (int x=0;x<m.length();x++) 
				{ 
					Map request= m.getMap(x);
					
					if (request.getVector3d(kAllowedView).isParallelTo(vecZModelView))
					{ 
						mapRequests.appendMap("Request", request);
						bHasRequest = true;	
					}					 
				}//next x
				
				if(bHasRequest && tsls.find(t)<0)
					tsls.append(t);
				 
			}//next j					
		//endregion 			

		}
	
	// TslInstance
		else if (tsl.bIsValid())
		{ 
			TslInst& t = tsl;
			
			if (sExcludeScripts.findNoCase(t.scriptName(),-1)>-1)
			{ 
				continue;
			}
			
			
			
			int bHasRequest;
			Map m = t.map().getMap(kRequests);
			for (int x=0;x<m.length();x++) 
			{ 
				Map request= m.getMap(x);
				
				if (request.getVector3d(kAllowedView).isParallelTo(vecZModelView))
				{ 
					mapRequests.appendMap("Request", request);
					bHasRequest = true;	
				}					 
			}//next x
			
			if(bHasRequest && tsls.find(t)<0)
				tsls.append(t);			
		}
	// Element
		else if (el.bIsValid())
		{ 
			TslInst ts[] = el.tslInstAttached();	
			for (int j=0;j<ts.length();j++) 
			{ 
				TslInst t= ts[j]; 
				
				if (sExcludeScripts.findNoCase(t.scriptName(),-1)>-1)
				{ 
					continue;
				}
				
			// collect requests			
				int bHasRequest;
				Map m = t.map().getMap(kRequests);
				for (int x=0;x<m.length();x++) 
				{ 
					Map request= m.getMap(x);
					
					if (request.getVector3d(kAllowedView).isParallelTo(vecZModelView))
					{ 
						mapRequests.appendMap("Request", request);
						bHasRequest = true;	
					}					 
				}//next x
				
				if(bHasRequest && tsls.find(t)<0)
					tsls.append(t);
				 
			}//next j			
		}		
	
	}
	
	vecZ.vis(_Pt0, 150);
//endregion 	


//region Draw Requests
	int numRequestAdded;
	for (int i=0;i<mapRequests.length();i++) 
	{ 
		Map m  = mapRequests.getMap(i);
		m.transformBy(ms2ps);
		
	//region Text
		if (m.hasString("text"))
		{ 
			String text = m.getString("text");
			Point3d pt = m.getPoint3d("ptLocation");
			pt += cs.vecZ() * cs.vecZ().dotProduct(cs.ptOrg() - pt);
			Vector3d vecXT = m.getVector3d("vecX");
			Vector3d vecYT = m.getVector3d("vecY");
			double dXFlag = m.getDouble("dXFlag");
			double dYFlag = m.getDouble("dYFlag");
			int bAlsoReverse = m.getInt("AlsoReverseDirection");

			//if (bAlsoReverse)
			{ 
				Vector3d vecZT = vecXT.crossProduct(vecYT);
				if (vecZT.dotProduct(vecZ)<0)
				{
					vecYT *= -1;
					dYFlag *= -1;
				}
			}
			
			vecXT.vis(pt, 1);
			vecYT.vis(pt, 3);			
			

			dp.dimStyle(m.hasString("dimStyle") ? m.getString("dimStyle") : sDimStyle);
			if (sDimStyle==tDefault && dTextHeight<=0 && m.getDouble("textHeight")>0)
				dp.textHeight(m.getDouble("textHeight"));
			else
				dp.textHeight(textHeight);
			dp.color(m.hasInt("Color")?m.getInt("Color"): nColor);
	
			dp.draw(text, pt, vecXT, vecYT, dXFlag, dYFlag);
			numRequestAdded++;
		}
	//endregion 
	
	//region PlaneProfile
		else if (m.hasPlaneProfile("PlaneProfile"))
		{ 
			PlaneProfile pp(cs);
			pp.unionWith(m.getPlaneProfile("PlaneProfile"));
			int nDrawFilled = m.getInt("DrawFilled");
			int nt = m.getInt("Transparency");
			
			if (m.hasInt("trueColor"))
				dp.trueColor(m.getInt("trueColor"));
			else
				dp.color(m.hasInt("Color")?m.getInt("Color"): nColor);	

			if (nt>0 && nt<100)
				dp.draw(pp,nDrawFilled, nt);
			else
				dp.draw(pp,nDrawFilled);
			numRequestAdded++;	
		}			
	//endregion 
	
	//region PLine
		else if (m.hasPLine("pline"))
		{ 
			PLine pl = m.getPLine("pline");
			pl.projectPointsToPlane(pnRef, cs.vecZ());
			dp.color(m.hasInt("Color")?m.getInt("Color"): nColor);
			dp.draw(pl);
			numRequestAdded++;
		}			
	//endregion 	
 
	}//next i
		
//endregion 


//region Draw Statistics
	if (bHasSection && (bDebug || numRequestAdded<1))
	{ 
		_ThisInst.setAllowGripAtPt0(true);
		String text = scriptName();
		if (beams.length()>0)text += "\\P"+beams.length() + T(" |Beams|");
		if (panels.length()>0)text += "\\P"+panels.length() + T(" |Panels|");
		if (sheets.length()>0)text += "\\P"+sheets.length() + T(" |Sheets|");
		if (mapRequests.length()>0)text += "\\P"+numRequestAdded+ "/"+mapRequests.length() + T(" |Requests|");
		
		if (numRequestAdded<1)
		{
			text += "\\P" + entities.length() + T(" |Entities|");
			text +=  TN("|No display requests could be found associated to any of the entities.|");
		}
		Display dpInfo(255);
		dpInfo.textHeight(U(40));
		dpInfo.draw(text, _Pt0, vecX, vecY, 1, - 1);
	}
	else
		_ThisInst.setAllowGripAtPt0(false);
//endregion 




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
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="330" />
        <int nm="BreakPoint" vl="238" />
        <int nm="BreakPoint" vl="674" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17135 painter definitions recreated in any dwg" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="11/23/2022 9:46:19 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17135 initail version of hsbViewRequest" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="11/22/2022 5:28:12 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End