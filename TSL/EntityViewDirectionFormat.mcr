#Version 8
#BeginDescription
#Versions
Version 1.4 08.06.2022 HSB-15678 bugfix offset value
Version 1.3 01.10.2021 HSB-13291 automatic vertical text placement for any view not being parallel to Z-Direction of a panel will be set to top loading side if main view can be found. Requires usage of new option to select main view in block space. In modelspace this is detected automatically
Version 1.2 30.09.2021 HSB-13291 Dimstyle property added
Version 1.1 30.09.2021 HSB-13291 automatic detection of potential main view direction

The tsl provides two insertion modes:
   as blockspace TSL to be attached to a shopdrawviewport
    as model TSL to be attached to a multipage

This tsl shows properties by resolving format variables.
Although it is defined to work with any entity type it is mainly targeted for CLT panels. 
For these it provides two additional format instructions
@(LoadingInfo)
    strictly available only for panels with floor/roof association and not being drawn upright like a wall in model
    It displays loading info of the panel in dependency of the view direction compared to the
    most aligned Z-World direction of the panel.
    If the view direction matches world it shows 'Loading Top Side', else it will display 'Flip for Loading'.
    One could use alias definitions to alter / abbreviate the string
@(SurfaceQuality)
    strictly available if the view direction matches positive or negatrive Z-axis of the panel


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
#KeyWords 
#BeginContents
//region <History>
// #Versions
// 1.4 08.06.2022 HSB-15678 bugfix offset value , Author Thorsten Huck
// 1.3 01.10.2021 HSB-13291 automatic vertical text placement for any view not being parallel to Z-Direction of a panel will be set to top loading side if main view can be found. Requires usage of new option to select main view in block space. In modelspace this is detected automatically. , Author Thorsten Huck
// 1.2 30.09.2021 HSB-13291 Dimstyle property added , Author Thorsten Huck
// 1.1 30.09.2021 HSB-13291 automatic detection of potential main view direction , Author Thorsten Huck
// 1.0 28.09.2021 HSB-13291 initial version , Author Thorsten Huck

/// <insert Lang=en>
/// The tsl provides two insertion modes:
///    as blockspace TSL to be attached to a shopdrawviewport
///    as model TSL to be attached to a multipage
/// </insert>

// <summary Lang=en>
// This tsl shows properties by resolving format variables.
//Although it is defined to work with any entity type it is mainly targeted for CLT panels. For these it provides two additional format instructions
//@(LoadingInfo)
//    strictly available only for panels with floor/roof association and not being drawn upright liek a wall in model
//    It displays loading info of the panel in dependency of the view direction compared to the most aligned Z-World direction of the panel.
//    If the view direction matches world it shows 'Loading Top Side', else it will display 'Flip for Loading'.
//    One could use alias definitions to alter / abbreviate the string
// @(SurfaceQuality)
//    strictly available if the view direction matches positive or negatrive Z-axis of the panel
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "EntityViewDirectionFormat")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add/Remove Format|") (_TM "|Select Tool|"))) TSLCONTENT
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
		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());		
	}
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	
	String sAuto = T("|Automatic|");
	
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
	
	
//end Constants//endregion

//region Viewport Selection Jig
	if (_bOnJig && _kExecuteKey == "SelectViewport")
	{
		Point3d ptJig = _Map.getPoint3d("_PtJig"); //running point
		Plane pnZ(_PtW, _ZW);
		Line(ptJig, vecZView).hasIntersection(pnZ, ptJig);
		Map mapViewports = _Map.getMap("Viewport[]");
		PlaneProfile pps[0];
		for (int i = 0; i < _Map.length(); i++)
		{
			PlaneProfile pp = _Map.getPlaneProfile(i);
			pps.append(pp);
		}			
		Display dp(-1);

	// get closest view
		int n = -1;
		double dDist = U(10e6);
		
		for (int i = 0; i < pps.length(); i++)
		{
			double d = Vector3d(ptJig - pps[i].closestPointTo(ptJig)).length();
			if (d < dDist)
			{
				dDist = d;
				n = i;
			}
		}		
		
	// draw jig
		for (int i = 0; i < pps.length(); i++)
		{ 	
			PlaneProfile pp = pps[i];
			if (i==n)
			{ 
				PlaneProfile pp2 = pp;
				pp2.shrink(dViewHeight / 200);

				dp.trueColor(darkyellow, 50);
				dp.draw(pp2,_kDrawFilled);

				dp.color(1);
				dp.draw(pp);				
				pp.subtractProfile(pp2);
				dp.draw(pp,_kDrawFilled);
			}
			else
			{ 
				dp.trueColor(lightblue, 50);
				dp.draw(pp,_kDrawFilled);
			}
 
		}//next i				
		return;
	}		
//endregion 



//region Properties
	String sFormatName=T("|Format|");	
	PropString sFormat(nStringIndex++, "", sFormatName);	
	sFormat.setDescription(T("|Defines the format to be resolved with properties of the defining entity|"));
	sFormat.setCategory(category);	
	
category = T("|Display|");
	String sTextHeightName=T("|Textheight|");	
	PropDouble dTextHeight(nDoubleIndex++, U(75), sTextHeightName);	
	dTextHeight.setDescription(T("|Defines the Textheight|"));
	dTextHeight.setCategory(category);
	
	String sColorName=T("|Color|");	
	PropInt nColor(nIntIndex++, 40, sColorName);	
	nColor.setDescription(T("|Defines the Color|"));
	nColor.setCategory(category);
	
	
category = T("|Alignment|");
	
	String sHorizontalAlignments[] = { sAuto, T("|Left|"), T("|Center|"), T("|Right|")};
	String sHorizontalAlignmentName=T("|Horizontal|");	
	PropString sHorizontalAlignment(nStringIndex++, sHorizontalAlignments, sHorizontalAlignmentName,0);	
	sHorizontalAlignment.setDescription(T("|Defines the horizontal alignment|"));
	sHorizontalAlignment.setCategory(category);
	
	String sVerticalAlignments[] = { sAuto,T("|Bottom|"), T("|Center|"), T("|Top|")};
	String sVerticalAlignmentName=T("|Vertical|");	
	PropString sVerticalAlignment(nStringIndex++, sVerticalAlignments, sVerticalAlignmentName,0);	
	sVerticalAlignment.setDescription(T("|Defines the vertical alignment|"));
	sVerticalAlignment.setCategory(category);	

category = T("|Display|");
	String sDimStyleName=T("|DimStyle|");	
	PropString sDimStyle(nStringIndex++, _DimStyles.sorted(), sDimStyleName);	
	sDimStyle.setDescription(T("|Defines the DimStyle|"));
	sDimStyle.setCategory(category);
	
	
	

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
		
	// get current space and property ints
		int bInLayoutTab = Viewport().inLayoutTab();
		int bInPaperSpace = Viewport().inPaperSpace();

	// find out if we are block space and have some shopdraw viewports
		Entity viewEnts[0];
		if (!bInLayoutTab)viewEnts= Group().collectEntities(true, ShopDrawView(), _kMySpace);

	// distinguish selection mode bySpace
		if (viewEnts.length()>0)
		{
			_Entity.append(getShopDrawView());
			_Pt0 = getPoint();
			
		// prompt for additional viewport
			Entity ents[0];
			PrEntity ssE(T("|Select main viewport (optional)|"), ShopDrawView());
			if (ssE.go())
				ents.append(ssE.set());
			if(ents.length()>0)
				_Entity.append(ents.first());
			
			
		}
		else
		{
		// prompt for entities
			Entity ents[0];
			PrEntity ssE(T("|Select multipages|"), MultiPage());
			if (ssE.go())
				ents.append(ssE.set());
			
			MultiPage mps[0];
			for (int i=0;i<ents.length();i++) 
			{ 
				MultiPage mp =  (MultiPage)ents[i];
				if (mp.bIsValid())
					mps.append(mp); 			 
			}//next i
		
			if (mps.length()==1)
			{
				_Pt0 = getPoint();
				_Entity.append(mps.first());
			}
			else if (mps.length()>1)
			{ 
				MultiPage mp = mps.first();
			// prompt for point input	
				Point3d ptRef = mps.first().coordSys().ptOrg();
				Point3d ptLoc = ptRef;
				 
				
				
				Map mapArgs;
				MultiPageView mpvs[]= mp.views();
				PlaneProfile ppViewports[0];
				//showSet = mp.showSet();

			// get outline of viewports
				PlaneProfile ppViewport;
				for (int i = 0; i < mpvs.length(); i++)
				{
					MultiPageView& mpv = mpvs[i];
					PlaneProfile pp(mp.coordSys());
					pp.joinRing(mpv.plShape(), _kAdd);
					ppViewports.append(pp);
					mapArgs.appendPlaneProfile("pp", pp);
				}


			// select viewport
				String prompt = T("|Select view|",ptRef);
				PrPoint ssP(prompt);

				int nGoJig = - 1;
				while (nGoJig != _kNone && nGoJig != _kOk)
				{
					nGoJig = ssP.goJig("SelectViewport", mapArgs);				
					if (nGoJig == _kOk)//Jig: point picked
					{
						ptLoc = ssP.value();
//						double dDist = U(10e6);
//						for (int i = 0; i < ppViewports.length(); i++)
//						{
//							double d = Vector3d(pt - ppViewports[i].closestPointTo(pt)).length();
//							if (d < dDist)
//							{
//								dDist = d;
//								nViewport = i;
//								ppViewport = ppViewports[i];
//							}
//						}
//						
//						if (nViewport >- 1)
//						{
//							MultiPageView mpv = mpvs[nViewport];
//							ViewData vdata = mpv.viewData();//vdatas[nViewport];
//							ms2ps = mpv.modelToView();
//							ps2ms = ms2ps;
//							ps2ms.invert();	
//							
//							showSet = mpv.showSet();
//							ppViewport = ppViewports[nViewport];
////							
////							Vector3d vecModelView = _ZW;
////							vecModelView.transformBy(ps2ms);
////							vecModelView.normalize();
////							_Map.setVector3d("ModelView", vecModelView);
//						}
					}
					// Jig: cancel
					else if (nGoJig == _kCancel)
					{
						break;
					}
				}
//
//
//
//				PrPoint ssP(TN("|Select point in view|") ); 
//				if (ssP.go()==_kOk) 
//					ptLoc = ssP.value(); // append the selected points to the list of grippoints _PtG
//				
				ptLoc += _ZW * _ZW.dotProduct(ptRef - ptLoc);
				Vector3d vecLoc = ptLoc - ptRef;

			// create TSL
				TslInst tslNew;				Map mapTsl;
				int bForceModelSpace = true;	
				String sExecuteKey,sCatalogName = sLastInserted;
				String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
				GenBeam gbsTsl[] = {};		Entity entsTsl[1];			Point3d ptsTsl[1];
			
				for (int i=0;i<mps.length();i++) 
				{ 
					MultiPage mp = mps[i];
					ptsTsl[0] = mp.coordSys().ptOrg() + vecLoc;
					entsTsl[0] = mp;
					tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent);  
				}//next i			
				eraseInstance();
			}
			else
				eraseInstance();
		}
		return;
	}	
// end on insert	__________________//endregion
	
	
//region Get references
	if (_Entity.length()<1)
	{ 
		eraseInstance();
		return;
	}
	else 
		setDependencyOnEntity(_Entity[0]);
		
	MultiPage mp = (MultiPage)_Entity[0];
	ShopDrawView sdv = (ShopDrawView)_Entity[0];
		
	Entity ents[0], showSet[0], defSet[0];
	
	int bIsMultipage = mp.bIsValid();
	int bIsSdv= sdv.bIsValid();
	int bHasMain; // flag if main view has been found
	int bIsSetup;
	
	CoordSys cs(_PtW, _XW, _YW, _ZW);
	
	int nIndex = -1;
	
	double scale = 1;
	double dXVp, dYVp; // X/Y of viewport/shopdrawviewport
	Point3d ptCenVp=_Pt0;	
	CoordSys ms2ps, ps2ms, ms2psMain;

	
//endregion 	
	

//region Get closest view of multipages
	PlaneProfile ppViewport;
	if (bIsMultipage)
	{ 
		
	// keep location if mp gets moved
		if (_kNameLastChangedProp!="_Pt0" &&_Map.hasVector3d("vecLoc"))// 
		{ 
			_Pt0 = mp.coordSys().ptOrg() + _Map.getVector3d("vecLoc");
		}

		MultiPageView mpvs[0]; 
		PlaneProfile ppViewports[0];
		mpvs = mp.views();

		if (mpvs.length()<1)
		{ 
			reportMessage("\n"+ scriptName() + T("|Invalid multipage| ")+T("|Tool will be deleted.|"));
			eraseInstance();
			return;
		}
		
	// get outline of viewports	
		MultiPageView mpvMain; // the viewport with vecZ of sip as view direction
		for (int i = 0; i < mpvs.length(); i++)
		{
			MultiPageView mpv = mpvs[i];
			PlaneProfile pp(cs);
			pp.joinRing(mpv.plShape(), _kAdd);
			ppViewports.append(pp);			pp.vis(i);
				
		// get a potential main view
			ViewData viewData = mpv.viewData();
			showSet = mpv.showSet();
			defSet = viewData.showSetDefineEntities();
			ms2ps = mpv.modelToView();
			Entity entDef;
			if (showSet.length()==1)
				entDef = showSet[0];	
			else if (defSet.length()>0)
				entDef = defSet[0];		
			
			Sip sip = (Sip)entDef;
			Vector3d vecZ, vecZPS;
			if (sip.bIsValid())
			{
				vecZPS = sip.vecZ();
				vecZPS.transformBy(ms2ps);
				vecZPS.normalize();			

				if (vecZPS.isParallelTo(_ZW))
				{
					vecZPS.vis(mpv.plShape().closestPointTo(_Pt0), i);
					ms2psMain = ms2ps;
					bHasMain = true;
				}
			}
		}	
		
	// get closest
		double dist = U(10e6);
		for (int i=0;i<ppViewports.length();i++) 
		{ 
			Point3d pt = ppViewports[i].closestPointTo(_Pt0);
			double d = (pt - _Pt0).length();
			if (d<dist)
			{ 
				dist = d;
				nIndex = i;
			}
		}//next i
		
		if (nIndex<0)
		{ 
			reportMessage("\n"+ scriptName() + T("|Unexpected error| ")+T("|Tool will be deleted.|"));
			eraseInstance();
			return;			
		}
		
		MultiPageView mpv = mpvs[nIndex];
		ms2ps = mpv.modelToView();
		ps2ms = ms2ps; ps2ms.invert();
		ViewData viewData = mpv.viewData();//vdatas[nViewport];
		scale = viewData.dScale();
		showSet = mpv.showSet();
		defSet = viewData.showSetDefineEntities();
		
		ppViewport = ppViewports[nIndex];
		//ppViewport.transformBy(ms2ps);
		ppViewport.vis(1);
		
	}
//endregion 

//region Get view by shopdrawview
	else if (bIsSdv)
	{ 
	// interprete the list of ViewData in my _Map
		ViewData viewDatas[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets,0); // 2 means verbose
		nIndex = ViewData().findDataForViewport(viewDatas, sdv);// find the viewData for my view
			
		if (nIndex>-1)
		{ 
			ViewData viewData = viewDatas[nIndex];
			dXVp = viewData.widthPS();
			dYVp = viewData.heightPS();
			ptCenVp= viewData.ptCenPS();
			
			ppViewport.createRectangle(LineSeg(ptCenVp - .5 * (_XW * dXVp + _YW * dYVp), ptCenVp + .5 * (_XW * dXVp + _YW * dYVp)), _XW, _YW);
			
			ms2ps = viewData.coordSys();
			ps2ms = ms2ps; ps2ms.invert();
			
			defSet = viewData.showSetDefineEntities();
			showSet = viewData.showSetEntities();
//			for (int j=0;j<entsDefineSet.length();j++) 
//			{ 
//				el= (Element)entsDefineSet[j]; 
//				if (el.bIsValid())break;					 
//			}//next j
		}	

		else
		{ 
			Point3d pts[] = sdv.gripPoints();
			ptCenVp.setToAverage(pts);
			pts = Line(_Pt0, _XW).orderPoints(pts);
			if (pts.length()>0)dXVp = abs(_XW.dotProduct(pts.last() - pts.first()));
			pts = Line(_Pt0, _YW).orderPoints(pts);
			if (pts.length()>0)dYVp = abs(_YW.dotProduct(pts.last() - pts.first()));
			ppViewport.createRectangle(LineSeg(ptCenVp - .5 * (_XW * dXVp + _YW * dYVp), ptCenVp + .5 * (_XW * dXVp + _YW * dYVp)), _XW, _YW);
			bIsSetup = true;
		}

	// get main view
		for (int i=0;i<viewDatas.length();i++) 
		{ 
			ViewData viewData = viewDatas[i]; 
			CoordSys ms2ps = viewData.coordSys(); 
	//			Entity defSet = viewData.showSetDefineEntities();
//			showSet = viewData.showSetEntities();
			
			Entity entDef;
			if (showSet.length()==1)
				entDef = showSet[0];	
			else if (defSet.length()>0)
				entDef = defSet[0];		
			
			Sip sip = (Sip)entDef;
			Vector3d vecZ, vecZPS;
			
			if (sip.bIsValid())
			{
				vecZPS = sip.vecZ();
				vecZPS.transformBy(ms2ps);
				vecZPS.normalize();			
				if (vecZPS.isParallelTo(_ZW))
				{
					ms2psMain = ms2ps;
					bHasMain = true;
				}
			}			
			
		}//next i


	//region Trigger AddMainView
		if (bIsSetup)
		{ 
			if (_Entity.length()==1)
			{ 
				String sTriggerAddMainView = T("|Add Main View|");
				addRecalcTrigger(_kContextRoot, sTriggerAddMainView );
				if (_bOnRecalc && _kExecuteKey==sTriggerAddMainView)
				{
					_Entity.append(getShopDrawView());		
					setExecutionLoops(2);
					return;
				}	
			}
			if (_Entity.length()==2)
			{ 
				String sTriggerSetMainView = T("|Set Main View|");
				addRecalcTrigger(_kContextRoot, sTriggerSetMainView );
				if (_bOnRecalc && _kExecuteKey==sTriggerSetMainView)
				{
					_Entity[1]=getShopDrawView();		
					setExecutionLoops(2);
					return;
				}
				String sTriggerRemoveMainView = T("|Remove Main View|");
				addRecalcTrigger(_kContextRoot, sTriggerRemoveMainView );
				if (_bOnRecalc && _kExecuteKey==sTriggerRemoveMainView)
				{
					_Entity.setLength(1);		
					setExecutionLoops(2);
					return;
				}				
			}	
			//endregion				
		}
	}
	
//endregion 





//region Display

	Entity entDef;
	if (showSet.length()==1)
		entDef = showSet[0];	
	else if (defSet.length()>0)
		entDef = defSet[0];

		
	Sip sip = (Sip)entDef;
	Beam bm = (Beam)entDef;
	Sheet sh= (Sheet)entDef;
	GenBeam gb= (Sheet)entDef;
	Element el= (Element)entDef;
	TslInst tsl= (TslInst)entDef;
	Opening op= (Opening)entDef;

	Map mapAdditionals;
	String sVariables[]=entDef.formatObjectVariables();
	
	PlaneProfile ppShadow;

	Point3d ptCen,ptGrainLocation=_Pt0;
	Map mapX;
	Vector3d vecZ, vecZPS, vecZUp;
	int bRefIsTop=true;
	if (sip.bIsValid())
	{ 
		String surfaceQualityBot = sip.formatObject("@(SurfaceQualityBottomStyleDefinition.Name)");
		String surfaceQualityTop = sip.formatObject("@(SurfaceQualityTopStyleDefinition.Name)");
		ptCen = sip.ptCen();
		vecZ = sip.vecZ();			vecZ.vis(ptCen, 150);

		vecZPS = vecZ;
		vecZPS.transformBy(ms2ps);
		vecZPS.normalize();			vecZPS.vis(_Pt0, 150);
		
		Vector3d vecZPSMain = vecZPS;
		if (bHasMain)
		{ 
			vecZPSMain = vecZ;
			vecZPSMain.transformBy(ms2psMain);
			vecZPSMain.normalize();	
		}	
		
		
		vecZUp = vecZ;
		if (vecZUp.dotProduct(_ZW) < 0)
		{
			bRefIsTop = false;
			vecZUp *= -1;
		}
		if (bHasMain)
			vecZUp.transformBy(ms2psMain);		
		else
			vecZUp.transformBy(ms2ps);
		vecZUp.normalize();		vecZUp.vis(_Pt0, 5);

	// get association wall = 0 , roof/floor = 1
		String sLoadingInfo; // empty by default
		mapX = sip.subMapX("ExtendedProperties");
		if (mapX.getInt("isFloor") && !vecZ.isPerpendicularTo(_ZW)) // ignore any panel being upright in model
		{
			sLoadingInfo = vecZUp.dotProduct(_ZW) > 0 ?  T("|Loading Top Side|") : T("|Flip for Loading|") ;
		}
	
		String k;
		k = "LoadingInfo";
		if (sVariables.findNoCase(k,-1)<0)
		{
			sVariables.append(k);
			mapAdditionals.setString(k, sLoadingInfo);
		}
		k = "SurfaceQuality";
		if (sVariables.findNoCase(k,-1)<0)
		{
			String qualities[] = { surfaceQualityBot, surfaceQualityTop};
			String quality;
			if (vecZPSMain.isParallelTo(_ZW))
			{ 
				if (vecZPSMain.isCodirectionalTo(_ZW))qualities.swap(0, 1);
				quality = qualities[0]+"("+qualities[1]+")";
			}
			sVariables.append(k);
			mapAdditionals.setString(k, quality);
		}		
		
		Body bd = sip.realBody();
		bd.transformBy(ms2ps);
		ppShadow = bd.shadowProfile(Plane(_Pt0, _ZW));
		
		
		sip.realBody().vis(7);
		
	}

	//ms2ps.vecZ().vis(_Pt0,150);
	


	sVariables = sVariables.sorted();

//endregion 



//region Alignment
	Vector3d vecXRead=_XW, vecYRead;
	if (sip.bIsValid() && vecZPS.isParallelTo(_ZW))
	{ 
		Vector3d vecXGrain = sip.woodGrainDirection();
		vecXGrain = vecXGrain.bIsZeroLength() ? sip.vecX() : sip.woodGrainDirection();
		vecXGrain.transformBy(ms2ps);
		vecXGrain.normalize();
		vecXRead = vecXGrain;
		
		if (vecXRead.isParallelTo(_XW))vecXRead = _XW;
		if (vecXRead.isParallelTo(_YW))vecXRead = _YW;
		
		
	}
	else if (vecZPS.isParallelTo(_XW))
	{ 
		vecXRead = _YW;
	}

	vecYRead = vecXRead.crossProduct(-_ZW);


	int nHorizontalAlignment = sHorizontalAlignments.find(sHorizontalAlignment);
	int nVerticalAlignment = sVerticalAlignments.find(sVerticalAlignment);
	if (nHorizontalAlignment <0)nHorizontalAlignment = 0;
	if (nVerticalAlignment <0)nVerticalAlignment = 0;

	Point3d ptText = _Pt0;
	int nHorizontalText, nVerticalText;

	if (nHorizontalAlignment==0)
	{ 
		double d = vecXRead.dotProduct(ppViewport.ptMid() - _Pt0);
		if (d < dEps)nHorizontalText = -1;
		else if (d > dEps)nHorizontalText = 1;
		else nHorizontalText = 0;
		
		if(ppShadow.area()>pow(dEps,2))
		{ 
			Point3d pt = ppShadow.closestPointTo(ptText);
			ptText += vecXRead * vecXRead.dotProduct(pt - ptText);
		}
		
		
	}
	else
		nHorizontalText=nHorizontalAlignment-2;

// automatic placement	
	if (nVerticalAlignment==0) 
	{ 
		double d = vecYRead.dotProduct(ppViewport.ptMid() - _Pt0);
		if (d < dEps)nVerticalText = 1;
		else if (d > dEps)nVerticalText = -1;
		else nVerticalText = 0;	
		
		if(ppShadow.area()>pow(dEps,2))
		{ 
			Point3d pt;
		// main view	
			if (vecZUp.isParallelTo(vecZPS))
				pt= ppShadow.closestPointTo(ptText);
		// any view not parallel with main view
			else
			{
				// text location always on main face
				Vector3d vecFace = vecZPS;vecFace.vis(_Pt0, 2);
				if (!bRefIsTop)vecFace *= -1;
				LineSeg seg = ppShadow.extentInDir(vecFace);// HSB-15678 vecZUp
				pt = ppShadow.ptMid() + vecFace * .5*abs(vecFace.dotProduct(seg.ptEnd() - seg.ptStart()));
				vecFace.vis(pt,2);
				seg.vis(3);
				ppShadow.vis(4);
				
				double d = vecFace.dotProduct(pt - seg.ptMid());
				if (d < 0)nVerticalText = 1;
				else if (d > 0)nVerticalText = -1;	
				
				if (vecFace.isParallelTo(vecYRead) && vecFace.isCodirectionalTo(vecYRead))
					nVerticalText *= -1;

			}
			ptText += vecYRead * vecYRead.dotProduct(pt - ptText);
		}		
	}
	else
		nVerticalText = nVerticalAlignment-2;	

		
// reposition if in automatic mode in main view	
	if (mapX.hasPoint3d("GrainLocation") && vecZPS.isParallelTo(_ZW) && !bIsSetup)
	{
		ptGrainLocation = mapX.getPoint3d("GrainLocation");
		ptGrainLocation.transformBy(ms2ps);
	
		if (nHorizontalAlignment == 0) 
		{
			ptText += vecXRead*vecXRead.dotProduct(ptGrainLocation - ptText);
			nHorizontalText = 0;
			if (bIsMultipage)_Pt0 = ptText;
		}
		if (nVerticalAlignment == 0) 
		{
			ptText += vecYRead*vecYRead.dotProduct(ptGrainLocation - ptText);
			nVerticalText = 0;	
			if (bIsMultipage)_Pt0 = ptText;
		}
	}
	

	
	
//endregion 

//region Multipage
	// store relative multipage location
	if (bIsMultipage)
	{
		_Map.setVector3d("vecLoc", _Pt0 - mp.coordSys().ptOrg());
	}	
//endregion 


//region Text Display
	String sText;
	if(entDef.bIsValid())
	{
		sText= entDef.formatObject(sFormat, mapAdditionals);	
	}
	else
		sText = T("|Block Setup| ") + scriptName() + "\\P"+sFormat;
	
	if (bIsMultipage && sText.length()<1)
	{ 
			reportMessage("\n"+ scriptName() + T("|No text found| ")+T("|Tool will be deleted.|"));
			eraseInstance();
			return;
	}
	
	Display dp(nColor);
	dp.dimStyle(sDimStyle);
	dp.textHeight(dTextHeight);
	dp.draw(sText, ptText, vecXRead, vecYRead, nHorizontalText*(bIsSetup?1:1.5), nVerticalText*(bIsSetup?1:1.5));
	
	vecXRead.vis(ptText, 1);
	vecYRead.vis(ptText, 3);
´
// draw a line between the two viewports to indicate there is a main view
	if (bIsSetup && _Entity.length()>1)
	{ 
		ShopDrawView sdvMain = (ShopDrawView)_Entity[1];
		if (sdvMain.bIsValid())
		{ 
			Point3d pt,pts[] = sdvMain.gripPoints();
			pt.setToAverage(pts);
			PLine pl(pt, ptCenVp,_Pt0);
			dp.draw(pl);
			dp.draw(T("|Main View|"), pt, _XW, _YW, 0, 0);
		}
		
		
	}
//endregion 




//region Add/RemoveFormat
	String sTriggerAddRemoveFormat = T("|Add/Remove Format|");
	addRecalcTrigger(_kContextRoot, sTriggerAddRemoveFormat );
	if (_bOnRecalc && (_kExecuteKey==sTriggerAddRemoveFormat))
	{
		String sPrompt;
		sPrompt+="\n"+  T("|Select a property by index to add or to remove|") + T(", |0 = Exit|");
		reportNotice("\n"+sPrompt);

		for (int s=0;s<sVariables.length();s++) 
		{ 
			String key = sVariables[s]; 
			String value;
			if (mapAdditionals.hasString(key))
				value = mapAdditionals.getString(key);
			else if (mapAdditionals.hasDouble(key))
				value = mapAdditionals.getDouble(key);
			else if (mapAdditionals.hasInt(key))
				value = mapAdditionals.getInt(key);
			else
				value = _ThisInst.formatObject("@(" + key + ")");

			String sAddRemove = sFormat.find(key,0, false)<0?"   " : "√";
			int x = s + 1;
			String sIndex = ((x<10)?"    " + x:"  " + x)+ "  "+sAddRemove+"   ";//
			
			reportNotice("\n"+sIndex+T("|"+key +"|")+ "........: "+ value);
			
		}//next i
		reportNotice("\n"+sPrompt);
		
		int nRetVal = getInt(sPrompt)-1;	

				
	// select property	
		while (nRetVal>-1)
		{ 
			if (nRetVal>-1 && nRetVal<=sVariables.length())
			{ 
				String newFormat = sFormat;
	
			// get variable	and append if not already in list	
				String variable ="@(" + sVariables[nRetVal] + ")";
				int x = sFormat.find(variable, 0);
				if (x>-1)
				{
					int y = sFormat.find(")", x);
					String left = sFormat.left(x);
					String right= sFormat.right(sFormat.length()-y-1);
					newFormat = left + right;
					//reportMessage("\n" + sVariables[nRetVal] + " new: " + newFormat);				
				}
				else
				{ 
					newFormat+="@(" +sVariables[nRetVal]+")";
								
				}
				sFormat.set(newFormat);
				reportMessage("\n" + sFormatName + " " + T("|set to|")+" " +sFormat);	
				reportNotice("\n" + sFormatName + " " + T("|set to|")+" " +sFormat);	
			}
			nRetVal = getInt(sPrompt)-1;
		}
	
		setExecutionLoops(2);
		return;
	}
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
        <int nm="BreakPoint" vl="838" />
        <int nm="BreakPoint" vl="430" />
        <int nm="BreakPoint" vl="437" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15678 bugfix offset value" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="6/8/2022 10:20:00 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13291 automatic vertical text placement for any view not being parallel to Z-Direction of a panel will be set to top loading side if main view can be found. Requires usage of new option to select main view in block space. In modelspace this is detected automatically." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="10/1/2021 10:46:20 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13291 Dimstyle property added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="9/30/2021 4:31:22 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13291 automatic detection of potential main view direction" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="9/30/2021 12:16:22 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End