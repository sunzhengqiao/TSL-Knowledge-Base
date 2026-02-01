#Version 8
#BeginDescription
version value="1.2" date="06nov2020" author="thorsten.huck@hsbcad.com"
HSB-9621 consumes multipage driven protection areas and can be created as modelspace instance linked to a shopdrawing (multipage)

/// This tsl creates tagging and hatching of packages.
/// Hatches are based on painter definitions
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords Shopdrawing;Stacking;LKW;Truck;Lorry;Package;Paket;Label;Tag
#BeginContents
//region Part #1 bOnInsert

//region History
/// <History>
/// <version value="1.2" date="06nov2020" author="thorsten.huck@hsbcad.com"> HSB-9621 consumes multipage driven protection areas and can be created as modelspace instance linked to a shopdrawing (multipage)</version>
/// <version value="1.1" date="04nov2020" author="thorsten.huck@hsbcad.com"> HSB-9505 supports shopdraw views </version>
/// <version value="1.0" date="30oct2020" author="thorsten.huck@hsbcad.com"> HSB-9505 initial </version>
/// </History>

/// <insert Lang=en>
/// Select lorry packages, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates tagging and hatching of packages.
/// Hatches are based on painter definitions
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "f_LorryTag")) TSLCONTENT
//End History//endregion 

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
	
	String sPainters[] = PainterDefinition().getAllEntryNames().sorted();
//end Constants//endregion

//region DialogMode
	int nDialogMode = _Map.getInt("DialogMode");
	if (nDialogMode>0)
	{ 
	// add hatch	
		if (nDialogMode==1)
		{ 
			setOPMKey("addHatch");
			String sPainterName=T("|Painter|");	
			PropString sPainter(nStringIndex++, sPainters, sPainterName);	
			sPainter.setDescription(T("|Defines the Painter where the hatching will be stored to|"));
			sPainter.setCategory(category);

			String sColorName=T("|Color|");	
			PropInt nColor(nIntIndex++, 1, sColorName);	
			nColor.setDescription(T("|Defines the Color|"));
			nColor.setCategory(category);
			
			String sTransparencyName=T("|Transparency|");	
			PropInt nTransparency(nIntIndex++, 0, sTransparencyName);	
			nTransparency.setDescription(T("|Defines the Transparency|"));
			nTransparency.setCategory(category);			
		}
	// remove hatch	
		else if (nDialogMode==2)
		{ 
			setOPMKey("removeHatch");
	
			String sPainterName=T("|Painter|");	
			PropString sPainter(nStringIndex++, sPainters, sPainterName);	
			sPainter.setDescription(T("|Defines the Painter where the hatching will be stored to|"));
			sPainter.setCategory(category);
		}		
	
		return;
	}
	
//End DialogMode//endregion 

//region Properties
	category = T("|Tag|");
	String sFormatName=T("|Format|");	
	PropString sFormat(nStringIndex++, "@(PosNum)", sFormatName);	
	sFormat.setDescription(T("|Defines the Format|"));
	sFormat.setCategory(category);
	
	String sTagRules[] = { T("|Closest Location|"), T("|Outside of Object|")};
	String sTagRuleName=T("|Tag Placement|");	
	PropString sTagRule(nStringIndex++, sTagRules, sTagRuleName);	
	sTagRule.setDescription(T("|Defines the TagRule|"));
	sTagRule.setCategory(category);
	
	category = T("|Hatch|");
	String sApplyHatchName=T("|Hatch active|");	
	PropString sApplyHatch(nStringIndex++, sNoYes, sApplyHatchName);	
	sApplyHatch.setDescription(T("|Defines if the painter hatching is active|"));
	sApplyHatch.setCategory(category);	
	
	category = T("|Display|");
	String sDimStyleName=T("|Dimstyle|");	
	PropString sDimStyle(nStringIndex++, _DimStyles.sorted(), sDimStyleName);	
	sDimStyle.setDescription(T("|Defines the DimStyle|"));
	sDimStyle.setCategory(category);
	
	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(0), sTextHeightName);	
	dTextHeight.setDescription(T("|Defines the Text Height|"));
	dTextHeight.setCategory(category);		
//End Properties//endregion 

//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		if (_kExecuteKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());	
			if (sEntries.findNoCase(_kExecuteKey,-1)>-1)
				setPropValuesFromCatalog(_kExecuteKey);
			else
				setPropValuesFromCatalog(sLastInserted);					
		}	
	// standard dialog	
		else	
			showDialog();
	
	
	// get current space
		int bInLayoutTab = Viewport().inLayoutTab();
		int bInPaperSpace = Viewport().inPaperSpace();
		Entity viewEnts[0];// find out if we are block space and have some shopdraw viewports
		if (!bInPaperSpace)viewEnts= Group().collectEntities(true, ShopDrawView(), _kMySpace);	

	// prompt for tsls
		Entity ents[0];
		PrEntity ssE;
		if (viewEnts.length()>0)
			ssE=PrEntity(T("|Select shopdraw viewport|"), ShopDrawView());
		else
		{
			ssE=PrEntity(T("|Select lorry packages (or its multipages)|"), Entity());
		}
	  	if (ssE.go())
			ents.append(ssE.set());
			
	// loop selection set to distinguish insertion mode
		TslInst packages[0];
		Entity multipages[0];
		ShopDrawView sdvs[0];
		for (int i=0;i<ents.length();i++) 
		{ 
			TslInst tsl = (TslInst)ents[i];
			ShopDrawView sdv = (ShopDrawView)ents[i];
			
			if (tsl.bIsValid() && tsl.scriptName().find("f_LorryPackage", 0, false) >- 1 && tsl.subMapXKeys().findNoCase("Hsb_Child[]" ,- 1) >- 1)
				packages.append(tsl);
			else if (ents[i].typeDxfName()=="HSBCAD_MULTIPAGE")
				multipages.append(ents[i]);
			else if (sdv.bIsValid())
				_Entity.append(sdv);
		}//next i
		
	// create TSL
		TslInst tslNew;				Map mapTsl;
		int bForceModelSpace = true;	
		String sExecuteKey,sCatalogName = sLastInserted;
		String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
		GenBeam gbsTsl[] = {};		Entity entsTsl[1];			Point3d ptsTsl[1];
	
	
	// create package instances
		for (int i=0;i<packages.length();i++) 
		{ 
			entsTsl[0] = packages[i]; 
			ptsTsl[0] = packages[i].ptOrg();
			tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 	 
		}//next i
		
	// create multipage instances
		for (int i=0;i<multipages.length();i++) 
		{ 
			entsTsl[0] = multipages[i]; 
			ptsTsl[0] = _Pt0;
			tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 	 
		}//next i
		
	// shopdraw setup mode
		if (_Entity.length()>0)
		{ 
			_Pt0 = getPoint();
		}
		else
			eraseInstance();			
		return;
	}	
// end on insert	__________________//endregion

//End Part #1//endregion 

//region Part #2 Get packages
//region Standards
	_ThisInst.setAllowGripAtPt0(false);
	_ThisInst.setSequenceNumber(100000);
	Point3d ptsZ[0];
	PlaneProfile pps[0]; double areas[0];

	Entity ents[0];
	
	Display dp(-1);
	dp.dimStyle(sDimStyle);
	double dD;
	if (dTextHeight>0)
	{
		dp.textHeight(dTextHeight);
		dD = dTextHeight;
	}
	else
		dD = dp.textHeightForStyle("O", sDimStyle);
	
	
	int nTagRule = sTagRules.find(sTagRule);
	int bHatch = sNoYes.find(sApplyHatch);	
	int bEditInPlace = _Map.getInt("EditInPlace");
	
	Vector3d vecX = _XU, vecY=_YU, vecZ = _ZU;
	Point3d ptOrg = _Pt0;
	CoordSys ms2ps, ps2ms;		
	
	
//End Standards//endregion 

//region Deterimine if shopdraw mode
	ShopDrawView sdv;
	int bHasSDV,bIsBlockSpace;
	Entity entsDefineSet[0],entsShowSet[0],entMultipage;
	for (int i=0;i<_Entity.length();i++) 
	{ 
		sdv = (ShopDrawView)_Entity[i];
		if (sdv.bIsValid())
		{ 
			entMultipage = _Map.getEntity("Generation\\entCollector");
			if (!entMultipage.bIsValid())
				entMultipage = _Map.getEntity(_kOnGenerateShopDrawing +"\\entCollector");
			vecX =_XW;
			vecY = _YW;
			vecZ = _ZW;	
			
			bHasSDV = true;
			ViewData viewDatas[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets,0); // 2 means verbose
			int nIndex = ViewData().findDataForViewport(viewDatas, sdv);// find the viewData for my view
			if (nIndex>-1)
			{ 
				ViewData viewData = viewDatas[nIndex];
//				dXVp = viewData.widthPS();
//				dYVp = viewData.heightPS();
//				ptCenVp= viewData.ptCenPS();
				
				ms2ps = viewData.coordSys();				
				ps2ms = ms2ps; ps2ms.invert();
				
				entsDefineSet = viewData.showSetDefineEntities();
				entsShowSet = viewData.showSetEntities();
				
				if(bDebug)reportMessage("\n"+ scriptName() + " define set  " + entsDefineSet);
				
				bIsBlockSpace = true;
				
			}
			else
			{ 
				Display dp(-1);
				dp.textHeight(U(80));
				dp.draw(scriptName() + "\\P"+T("|Defines tags and hatches of a lorry package|"), _Pt0, _XW, _YW, 1, 0);
				return;
			}	
		}
	}
//End Deterimine if shopdraw mode//endregion 

//region Get Packages
	TslInst packages[0];
	
	for (int i=0;i<_Entity.length();i++) 
	{
		TslInst tsl = (TslInst)_Entity[i];
		sdv = (ShopDrawView)_Entity[i];
		if (tsl.bIsValid() && tsl.scriptName().find("f_LorryPackage", 0, false) >- 1 && tsl.subMapXKeys().findNoCase("Hsb_Child[]" ,- 1) >- 1)
		{
			packages.append(tsl);
			setDependencyOnEntity(tsl);
		}
		else if (_Entity[0].typeDxfName()=="HSBCAD_MULTIPAGE")
		{ 
			entMultipage = _Entity[0];
			CoordSys csMP = entMultipage.coordSys();
			_Pt0 = csMP.ptOrg();
			setDependencyOnEntity(entMultipage);
			vecX =_XW;
			vecY =_YW;
			vecZ =_ZW;

		// get view data from the entColllector
			ViewData viewDatas[0];
			Map mapShopdrawData=entMultipage.subMapX("mpShopdrawData"); // the multipage has sd_ViewDataExporter or sdOptimizeViewDirection attached which provide a map of the viewDatas
			Map mapViewData = mapShopdrawData.getMap(_kOnGenerateShopDrawing + "\\ViewData[]");
			viewDatas = ViewData().convertFromSubMap( mapShopdrawData, _kOnGenerateShopDrawing + "\\" + _kViewDataSets, 2); 			
					
		// get defining entity from first view
			for (int v=0;v<viewDatas.length();v++) 
			{ 
				ViewData viewData = viewDatas[v];
				//_Pt0 = viewData.ptCenPS();
				Entity ents[] = viewData.showSetDefineEntities();
				if (ents.length()>0)
				{ 
					entsDefineSet = ents;
					bHasSDV = true;
					ms2ps = viewData.coordSys();	
					ms2ps.transformBy(csMP); // NOTE: transformation must consider multipage coordSys!
					ps2ms = ms2ps; ps2ms.invert();
					break;
				}
			}	
			
		// compose ModelMap, workaround until HSB-9058 is implemented
			if (entsDefineSet.length()<1)
			{ 
			// this approach is not suitable as the transformation of the viewport is not known
				reportNotice("\n" + scriptName() + TN("|Could not find viewport definitions.|") +TN("|Please attach one of the following tools to the block definition|")+
				"\n\n	sd_ViewDataExporter"+
				"\n	sd_OptimizeViewOrientation"+
				"\n\n"+ T("|Tool will be deleted.|"));
				eraseInstance();
				return;
//				ModelMap mm;
//				mm.setEntities(_Entity);
//				mm.dbComposeMap(ModelMapComposeSettings());
//				Map map = mm.map();
//				Map mapMultiPage = map.getMap("Model\\Multipage");
//				Map mapObjectCollection = mapMultiPage.getMap("ObjectCollection");	
//			
//			// get define and show sets
//				for (int i=0;i<mapObjectCollection.length();i++) 
//				{ 
//					Map m = mapObjectCollection.getMap(i);
//					String name = m.getMapName();
//					for (int j=0;j<m.length();j++) 
//					{ 
//						Entity e = m.getEntity(j);
//						if (e.bIsValid()) 
//						{
//							bHasSDV = true;
//							//ms2ps = CoordSys(mapMultiPage.getPoint3d("ptOrg"), mapMultiPage.getVector3d("vecX"), mapMultiPage.getVector3d("vecY"), mapMultiPage.getVector3d("vecZ") );
//							if (name=="defineSet")entsDefineSet.append(e); 
//							else if (name=="showSet")entsShowSet.append(e); 
//						}
//					}//next j							 
//				}//next i	
//	
//			// maintain location when multipage gets moved	
//				Point3d ptOrgMP = mapMultiPage.getPoint3d("ptOrg");
//				Vector3d vecOrgCurrent = _Pt0 - ptOrgMP;
//				Vector3d vecOrgPrevious = _Map.getVector3d("vecOrg");
//				if (_kNameLastChangedProp!="_Pt0" && _Map.hasVector3d("vecOrg") && vecOrgCurrent!=vecOrgPrevious)
//					_Pt0 = ptOrgMP + vecOrgPrevious;				
//				if (!_Map.hasVector3d("vecOrg")|| _kNameLastChangedProp=="_Pt0")
//					_Map.setVector3d("vecOrg", vecOrgCurrent);
//				ptOrgMP.vis(4);					
			}
		}
	}	
	
	if (bHasSDV && packages.length()<1 && entsDefineSet.length()>0)
	{ 
		
		TslInst tsl = (TslInst)entsDefineSet.first();
		if (tsl.bIsValid() && tsl.scriptName().find("f_LorryPackage", 0, false) >- 1 && tsl.subMapXKeys().findNoCase("Hsb_Child[]" ,- 1) >- 1)
		{
			packages.append(tsl);
			//reportMessage("\n"+ scriptName() + " package found");
			setDependencyOnEntity(tsl);
		}		
	}
	
	

	if (packages.length()<1)
	{ 
		//if(bDebug)
		reportMessage("\n"+ scriptName() + " no packages found");
		eraseInstance();
		return;
	}	
//End Get Packages//endregion 
		
//End Part #2 Get packages//endregion 

//region Part #3 Loop packages and display hatch by reference
	CoordSys csView(ptOrg, vecX, vecY, vecZ);	
	Plane pnZ(ptOrg, vecZ);
	PlaneProfile ppProtect(csView);
	
// get protection area from multipage subMapX
	if (entMultipage.bIsValid())
	{ 
		Map m = entMultipage.subMapX("ProtectArea");
		PlaneProfile pp= m.getPlaneProfile("ppProtect");
		if (!bIsBlockSpace)pp.transformBy(entMultipage.coordSys());
		pp.vis(2);
		ppProtect.unionWith(pp);
		
		if (bDebug)
		{ 
			Display dp(4);
			dp.draw(PLine(_PtW, _Pt0,pp.ptMid()));
			dp.draw(pp);			
		}

	}
	
	for (int i=0;i<packages.length();i++) 
	{ 
		TslInst& pack= packages[i];
		
	// get package coordSys
		Map m = pack.subMapX("AdditionalVariables");
		int nStackingType = -1; // unknown
		String k = "Truck Type";	
		if (m.hasString(k)) 
			nStackingType = m.getString(k).atoi();
		CoordSys cs2Package;
		{ 
			Map m = pack.subMapX("Hsb_Truck2Package");
			cs2Package = CoordSys(m.getPoint3d("ptOrg"),m.getVector3d("vecX"),m.getVector3d("vecY"),m.getVector3d("vecZ"));
		}		
		
	// get refs
		m = pack.subMapX("Hsb_Child[]");
		Entity _ents[] = m.getEntityArray("Entity[]", "", "Entity");
		
		Body bdPack = pack.realBody(); //bdPack.transformBy(vecZ * U(10)); bdPack.vis(2);
		if (bHasSDV)bdPack.transformBy(ms2ps);
		//bdPack.vis(1);		

		m = pack.map();
		if (nTagRule==1)					ppProtect.unionWith(bdPack.shadowProfile(pnZ));
		if (m.hasPlaneProfile("ppProtect") && !bHasSDV)	// customer request: package tag protection only required in model
		{
			PlaneProfile ppX = m.getPlaneProfile("ppProtect");
			//if (bHasSDV)ppX.transformBy(ms2ps);
			ppProtect.unionWith(ppX);
		}
		ptsZ.append(bdPack.extremeVertices(vecZ));

	// loop refs
		for (int j=0;j<_ents.length();j++) 
		{ 
			Entity ent = _ents[j];
			
		// get transformation to package
			Map m= ent.subMapX("Hsb_Item2Truck");
			CoordSys cs(m.getPoint3d("ptOrg"), m.getVector3d("vecX"), m.getVector3d("vecY"),m.getVector3d("vecZ"));
			cs.transformBy(cs2Package);
		
			
			Point3d pt = _Pt0;
			Body bd;
			
		// get transformed body
			Sip sip = (Sip)ent;
			if (sip.bIsValid())		bd = sip.envelopeBody(false, true);	
			else					bd = ent.realBody();
			bd.transformBy(cs);		
			if (bHasSDV)bd.transformBy(ms2ps);
			//bd.vis(j);
			
			Point3d pts[] = bd.extremeVertices(vecZ);
			if (pts.length() > 0 && !bHasSDV)pt = pts.last();
			
			PlaneProfile pp(CoordSys(pt, vecX, vecY, vecZ));
			pp.unionWith(bd.shadowProfile(Plane(pt, vecZ)));
			pps.append(pp);
			areas.append(pp.area());
			ents.append(ent);
			
			//pp.vis(j);
		}//next j
	}//next i
	
//region Place Tags
	
	Point3d ptRef = _Pt0;
	ptsZ = Line(_Pt0, vecZ).orderPoints(ptsZ, dEps);
	if (ptsZ.length() > 0)ptRef = ptsZ.last()+vecZ*dEps;
	
// order by area
	for (int i=0;i<areas.length();i++) 
		for (int j=0;j<areas.length()-1;j++) 
			if (areas[j]>areas[j+1])
			{
				pps.swap(j, j + 1);				
				areas.swap(j, j + 1);				
				ents.swap(j, j + 1);
			}
						

//region Draw Hatches
	if (bHatch>0)
	{ 
	//Get all painters with a valid hatch def
		
		for (int i=sPainters.length()-1; i>=0 ; i--) 
		{ 
			PainterDefinition painter(sPainters[i]);
			if (!painter.bIsValid())// || painter.subMapXKeys().findNoCase(scriptName(),-1)<0)
			{ 
				continue;
			}
			
			Map m = painter.subMapX(bDebug?"f_LorryTag":scriptName());
			int nc = m.getInt("Color");
			int nt = m.getInt("Transparency");
			
			Entity _ents[] = painter.filterAcceptedEntities(ents);
			for (int j=0;j<_ents.length();j++) 
			{ 
				Entity ent = _ents[j]; 
			
			// get planeprofile
				int n = ents.find(ent);
				if (n < 0)continue;
				PlaneProfile pp = pps[n];
				
				Display dp(nc);
				if (nt>0)
					dp.draw(pp, _kDrawFilled, nt);
				dp.draw(pp);
				//pp.vis(nc);
				 
			}//next i	
		}//next i
	}		
//End Draw Hatches



// place tags, smallest visible area first	
	for (int i=0;i<ents.length();i++) 
	{ 
		Entity ent= ents[i]; 
		PlaneProfile pp = pps[i];
	
		int bHasGrip = bEditInPlace && i < _PtG.length();
		Point3d ptMid = pp.ptMid();
		Point3d pt = bHasGrip?_PtG[i]:ptMid;
		if (!bHasSDV)
			pt+=vecZ*vecZ.dotProduct(ptRef-pt);
	
		String text = ent.formatObject(sFormat);
		
		double dX = dp.textLengthForStyle(text,sDimStyle, dTextHeight);
		double dY = dp.textHeightForStyle(text,sDimStyle, dTextHeight);
		LineSeg seg(pt - .5 * (vecX * dX + vecY * dY), pt + .5 * (vecX * dX + vecY * dY));
		PlaneProfile box; box.createRectangle(seg, vecX, vecY);
		box.shrink(-.5*dTextHeight);
		//box.vis(2);
	
		double dL = pp.dX();
		int num = dL / dD-1, cnt=1;
		LineSeg axis(ptMid - vecX * dL * .45, ptMid + vecX * dL * .45);
		int bAddGuider;
		if (!bHasGrip)
		{ 
			PlaneProfile ppTemp = ppProtect;
			ppTemp.intersectWith(box);
			auto area = ppTemp.area();	
			
		// attempt to place on axis	
			while(area>pow(dEps,2)&& cnt<num)
			{ 
				auto n = cnt % 2 == 1 ? 1 :- 1;
				pt+= vecX * n * cnt * dD;
				
				box.transformBy(pt - box.ptMid());
				ppTemp = ppProtect;
				ppTemp.intersectWith(box);
				
				area = ppTemp.area();
				//pt.vis(cnt);	
				cnt++;
				bAddGuider = true;
			}
	
		// second attempt follow outer ring
			PlaneProfile pp2 = pp;
			int maxLoop;
			while(area>pow(dEps,2) && maxLoop<20)
			{ 
				pp2.shrink(-dD);
				PLine pl, rings[] = pp2.allRings(true, false);
				double max;
				for (int r=0;r<rings.length();r++) 
				{ 
					if (rings[r].area()>max)
					{
						max = rings[r].area();
						pl = rings[r];
					}	 
				}//next r
				num = pl.length() / dD;
				cnt = 0;
				while(area>pow(dEps,2) && cnt<num)// 
				{ 
					pt = pl.getPointAtDist(cnt * dD);	//pt.vis(2);
					box.transformBy(pt - box.ptMid());	//box.vis(cnt);		
					ppTemp = ppProtect;
					ppTemp.intersectWith(box);
					area = ppTemp.area();
					cnt++;
				}
				maxLoop++;
			}
			
			if (bEditInPlace && !bHasGrip)
				_PtG.append(pt);
		}

	// add guide line
		if (bAddGuider || bEditInPlace)
		{ 
			Point3d pt1 = box.ptMid();
			auto segs[] = box.splitSegments(axis, false);
			auto dir = vecX.dotProduct(pt1 - pp.ptMid()) < 0 ?1 : -1;
			pt1 += vecX * dir * .5*box.dX();
			
			auto min = U(10e4);
			Point3d pt2 = axis.closestPointTo(pt1 + vecX * dir * dD);
			for (int j=0;j<segs.length();j++) 
			{ 
				segs[j].vis(j);
				Point3d pt3 = segs[j].closestPointTo(pt2);
				double d = (pt3 - pt1).length();
				if (d<min)
				{ 
					pt2 = pt3;
					min = d;
				} 
			}//next j
			
			PLine pl(pt1, pt2);
			dp.draw(pl);
			pl.createCircle(pt2, vecZ, .1 * dD);
			dp.draw(PlaneProfile(pl), _kDrawFilled);	
		}
		
		dp.draw(box);
		dp.draw(text, pt, vecX, vecY, 0, 0);		//box.vis(3);
		ppProtect.unionWith(box);	
		//pp.vis(i);
 
	}//next i
	//ppProtect.vis(6);
//End place Tags
//endregion 	


//endregion 

//End Loop packages and display hatch by item//endregion 

//region Trigger
{
// Trigger EditInPlace	
	String sTriggerGripToggle =bEditInPlace?T("../|Grip points off|"):T("../|Grip points on|");
	addRecalcTrigger(_kContextRoot, sTriggerGripToggle);
	if (_bOnRecalc && (_kExecuteKey==sTriggerGripToggle || _kExecuteKey==sDoubleClick))
	{
		bEditInPlace = bEditInPlace ? false : true;
		_Map.setInt("EditInPlace", bEditInPlace);	
		
		if (!bEditInPlace)_PtG.setLength(0);
		setExecutionLoops(2);
		return;
	}

// create TSL
	TslInst tslDialog;			Map mapTsl;						
	GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };

//region Trigger AddRule
	String sTriggerSetHatchPainter= T("|Set painter hatches|");
	addRecalcTrigger(_kContextRoot, sTriggerSetHatchPainter );
	if (_bOnRecalc && _kExecuteKey==sTriggerSetHatchPainter)
	{
		mapTsl.setInt("DialogMode",1);			
		tslDialog.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);				
		
		if (tslDialog.bIsValid())
		{ 
			if (tslDialog.showDialog())
			{ 
				String sPainter = tslDialog.propString(0);
				PainterDefinition painter(sPainter);
				if (painter.bIsValid())
				{ 
					Map m;
					m.setInt("Color", tslDialog.propInt(0));
					m.setInt("Transparency", tslDialog.propInt(1));			
					painter.setSubMapX(scriptName(), m);					
				}
			
			}
			tslDialog.dbErase();
		}
		setExecutionLoops(2);
		return;
	}//endregion

//region Trigger RemoveHatch
	String sTriggerRemoveHatchPainter = T("|Remove painter hatches|");
	addRecalcTrigger(_kContextRoot, sTriggerRemoveHatchPainter );
	if (_bOnRecalc && _kExecuteKey==sTriggerRemoveHatchPainter)
	{
		mapTsl.setInt("DialogMode",2);			
		tslDialog.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);				
		
		if (tslDialog.bIsValid())
		{ 
			if (tslDialog.showDialog())
			{ 
				String sPainter = tslDialog.propString(0);
				PainterDefinition painter(sPainter);
				if (painter.bIsValid() && painter.subMapXKeys().findNoCase(scriptName(),-1)>0)
					painter.removeSubMapX(scriptName());							
			}
			tslDialog.dbErase();
		}
		setExecutionLoops(2);
		return;
	}//endregion
	
//region Trigger ListpainterHatches
	String sTriggerListpainterHatches = T("|List Painter Hatches|");
	addRecalcTrigger(_kContextRoot, sTriggerListpainterHatches );
	if (_bOnRecalc && _kExecuteKey==sTriggerListpainterHatches)
	{
		String key = bDebug ? "f_LorryTag" : scriptName();
		
		
		String names[] ={ T("|Painter|")};
		String colors[] ={ T("|Color|")};
		String transparencies[] ={ T("|Transparency|")};
		int numA=names.first().length();
		int numB=colors.first().length();
		int numC=transparencies.first().length();
		
		for (int i=0;i<sPainters.length();i++) 
		{ 
			PainterDefinition painter(sPainters[i]);
			if (!painter.bIsValid() || painter.subMapXKeys().findNoCase(key,-1)<0)
			{ 
				continue;
			}
			Map m = painter.subMapX(key);
			int nc = m.getInt("Color");
			int nt = m.getInt("Transparency");
			
			if (sPainters[i].length() > numA)numA = sPainters[i].length();
			names.append(sPainters[i]);
			colors.append(nc);
			transparencies.append(nt);
		}//next i
		
		String out;
		for (int i=0;i<names.length();i++) 
		{ 
			String name = names[i];
			for (int j=name.length();j<numA;j++) 
				name += "  ";

			String color = colors[i];
			for (int j=color.length();j<numB;j++) 
				color = "  "+color;

			String transparency = transparencies[i];
			for (int j=transparency.length();j<numC;j++) 
				transparency = "  "+transparency ;

			out += "\n"+name + "	" + color + "	" + transparency;
		}//next i
		
		if (out.length()>0)
			out = T("|The following painter definitions have a valid hatch definition|:\n\n") + out;
		else
			out = T("|No painter painter definitions with valid hatch definitions could be found.|");
		reportNotice(out);	

		setExecutionLoops(2);
		return;
	}//endregion	
	
	
}//endregion
	
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
        <int nm="BreakPoint" vl="664" />
        <int nm="BreakPoint" vl="482" />
      </lst>
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End