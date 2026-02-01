#Version 8
#BeginDescription
#Versions
Version 1.6    05.03.2021
HSB-11074 new settings to control badge color and transparency, Import and Export of settings added , Author Thorsten Huck

version value="1.5" date="04nov2020" author="thorsten.huck@hsbcad.com"> 
HSB-9505 bugfix package transformation
HSB-9509 protection area exposed 
HSB-9337 bounding dimensions and bedding locations published for shopdrawings
HSB-9330 bugfix vertical offset on horizontal stacking 

HSB-8963 renamed from f_TruckPack
new properties to specify wrapping and edge protection
new output variables for bounding dimensions
rotation angle of vertical stacked walls exposed as format variable of the parent entity

HSB-8915 new resolution medium detail, additional variables published
HSB-8560 the follwing has been added: surface qualities, format resolving, bedding and edge protection


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 6
#KeyWords Stacking;Verladung;Truck;Pack;Package;LKW
#BeginContents
/// <History>//region
// #Versions
// 1.6 05.03.2021 HSB-11074 new settings to control badge color and transparency, Import and Export of settings added  , Author Thorsten Huck
/// <version value="1.5" date="04nov2020" author="thorsten.huck@hsbcad.com"> HSB-9505 bugfix package transformation </version>
/// <version value="1.4" date="30oct2020" author="thorsten.huck@hsbcad.com"> HSB-9509 protection area exposed </version>
/// <version value="1.3" date="19oct2020" author="thorsten.huck@hsbcad.com"> HSB-9337 bounding dimensions and bedding locations published for shopdrawings </version>
/// <version value="1.2" date="19oct2020" author="thorsten.huck@hsbcad.com"> HSB-9330 bugfix vertical offset on horizontal stacking </version>
/// <version value="1.1" date="25sep2020" author="thorsten.huck@hsbcad.com"> HSB-8963 renamed from f_TruckPack, new properties to specify wrapping and edge protection, new output variables for bounding dimensions, rotation angle of vertical stacked walls exposed as format variable of the parent entity</version>
/// <version value="1.0" date="23sep2020" author="thorsten.huck@hsbcad.com"> HSB-8915 new resolution medium detail, additional variables published </version>
/// <version value="0.2" date="17aug2020" author="thorsten.huck@hsbcad.com"> HSB-8560 the follwing has been added: surface qualities, format resolving, bedding and edge protection </version>
/// <version value="0.1" date="17aug2020" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select truck grid, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates a truck package, which groups stacked items in one entity.
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "f_TruckPackage")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "../|Add/Remove Format|") (_TM "|Select truck package|"))) TSLCONTENT
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
	String disabled = T("<|Disabled|>");
	
	String k;
	int nc = _ThisInst.color();
	int ncTxt = nc;
	int ntFill = 90;
	int ncBorder = nc;
	int ncFill = nc;
//end Constants//endregion

//region DialogMode
	int nDialogMode = _Map.getInt("DialogMode");
	if (nDialogMode>0)
	{ 
		if (nDialogMode == 1) // specify index when triggered to get different dialogs
		{
			setOPMKey("Display");	

		category = T("|Text|");
			String sColorName=T("|Color|");	
			PropInt nColor(nIntIndex++, 7, sColorName);	
			nColor.setDescription(T("|Defines the color of the text|"));
			nColor.setCategory(category);
			
		category = T("|Border|");	
			String sColorBorderName=T("|Color|");	
			PropInt nColorBorder(nIntIndex++, 7, sColorBorderName);	
			nColorBorder.setDescription(T("|Defines the color of the box around the text|"));
			nColorBorder.setCategory(category);			

		category = T("|Filling|");
			String sColorFillName=T("|Color|");	
			PropInt nColorFill(nIntIndex++, 7, sColorFillName);	
			nColorFill.setDescription(T("|Defines the color of the filling of the box around the text|"));
			nColorFill.setCategory(category);	

			String sTransparencyFillName=T("|Transparency|");	
			PropInt nTransparencyFill(nIntIndex++, 7, sTransparencyFillName);	
			nTransparencyFill.setDescription(T("|Defines the transparency of the filling|") + T("|100 = no filling|"));
			nTransparencyFill.setCategory(category);
		}			
		return;		
	}
//End DialogMode//endregion


//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sFileName ="f_Stacking";
	Map mapSetting;

// compose settings file location
	String sFolders[]=getFoldersInFolder(sPath); 
	int bPathFound = _bOnInsert ? sFolders.find(sFolder) >- 1 ? true : makeFolder(sPath + "\\" + sFolder) : false;
	String sFullPath = sPath+"\\"+sFolder+"\\"+sFileName+".xml";

// read a potential mapObject
	MapObject mo(sDictionary ,sFileName);
	if (mo.bIsValid())
	{
		mapSetting=mo.map();
		setDependencyOnDictObject(mo);
	}
	// create a mapObject to make the settings persistent	
	else if ((_bOnInsert || _bOnDebug) && !mo.bIsValid() )
	{
		String sFile=findFile(sFullPath); 
	// if no settings file could be found in company try to find it in the installation path
		if (sFile.length()<1)sFile=findFile(_kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\"+sFileName+".xml");		
		if (sFile.length()>0)
		{ 
			mapSetting.readFromXmlFile(sFile);
			mo.dbCreate(mapSetting);			
		}
	}		
//End Settings//endregion

//region Read Settings
	String sWraps[] ={};
	double dWrapThickness;
	int nWrapColor, nWrapTransparency;
	Map mapWraps;
{
	String k;
	Map m = mapSetting.getMap("Package");
	
	//	k="Color";				if (m.hasInt(k))	nColor = m.getInt(k);
	//	k="DimStyle";			if (m.hasString(k))	sDimStyle= m.getString(k);
	//	k="TextHeight";			if (m.hasDouble(k))	dTextHeight= m.getDouble(k);
	
	{

		mapWraps = m.getMap("Wrap[]");
		for (int i = 0; i < mapWraps.length(); i++)
		{
			Map mapWrap = mapWraps.getMap(i);
			String name = mapWrap.getString("Name");
			if (name.length() > 0 && sWraps.findNoCase(name ,- 1) < 0 && name.find(disabled, 0, false) < 0)
				sWraps.append(name);
		}//next i
		sWraps=sWraps.sorted();
		sWraps.insertAt(0, disabled);
		
		m = mapSetting.getMap("Package\\Tag");
		k="Color";				if (m.hasInt(k))	ncTxt = m.getInt(k);
		k="Transparency";		if (m.hasInt(k))	ntFill = m.getInt(k);
		k="BorderColor";		if (m.hasInt(k))	ncBorder = m.getInt(k);
		k="FillColor";			if (m.hasInt(k))	ncFill = m.getInt(k);		
		
	}
}
//End Read Settings//endregion 

//region Properties
// Wrapping
	category = T("|Wrappping|");
	String sEdgeProtection1Name=T("|Protection Type 1|");	
	PropDouble dEdgeProtection1(nDoubleIndex++, U(0), sEdgeProtection1Name);	
	dEdgeProtection1.setDescription(T("|Defines the thickness of the edge protection|")+ T(" |0 = no edge protection|") + 
	T("|Applies for the upmost item of a horizontal stacking and for any wall in vertical stacks where it is not rotated|"));
	dEdgeProtection1.setCategory(category);

	String sEdgeProtection2Name=T("|Protection Type 2|");	
	PropDouble dEdgeProtection2(nDoubleIndex++, U(0), sEdgeProtection2Name);	
	dEdgeProtection2.setDescription(T("|Defines the thickness of the edge protection|")+ T(" |0 = no edge protection|")+ 
	T("|Applies for any rotated wall in vertical stacks.|"));
	dEdgeProtection2.setCategory(category);
	
	String sWrapName=T("|Wrapping|");	
	PropString sWrap(nStringIndex++, sWraps, sWrapName);	
	sWrap.setDescription(T("|Defines the wrapping of the package.|") + (sWraps.length()==1?T("|NOTE: Please specify wrapping materials in settings definition.|"):""));
	sWrap.setCategory(category);	

// Display
	category = T("|Display|");	
	String sResolutions[] = { T("|Low Detail|"), T("|Medium Detail|"), T("|High Detail|")};
	String sResolutionName=T("|Resolution|");	
	PropString sResolution(nStringIndex++, sResolutions, sResolutionName);	
	sResolution.setDescription(T("|Defines the Resolution|"));
	sResolution.setCategory(category);

	String sFormatName=T("|Format|");	
	PropString sFormat(nStringIndex++, "@(Truck)", sFormatName);	
	sFormat.setDescription(T("|Defines the format of the description|"));
	sFormat.setCategory(category);
	
	String sDimStyleName=T("|DimStyle|");	
	PropString sDimStyle(nStringIndex++, _DimStyles.sorted(), sDimStyleName);	
	sDimStyle.setDescription(T("|Defines the DimStyle|"));
	sDimStyle.setCategory(category);
	
	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(0), sTextHeightName);	
	dTextHeight.setDescription(T("|Defines the Text Height|") + T("|0 = byDimStyle|"));
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
		
		
	// prompt for tsls
		Entity ents[0];
		PrEntity ssE(T("|Select stacked trucks|"), TslInst());
	  	if (ssE.go())
			ents.append(ssE.set());
		
		//_Pt0 = getPoint();
		
	// create TSL
		TslInst tslNew;
		GenBeam gbsTsl[] = {};		Entity entsTsl[1];				Point3d ptsTsl[0];
		int nProps[]={};			double dProps[]={dEdgeProtection1,dEdgeProtection2, dTextHeight};				String sProps[]={sWrap,sResolution,sFormat,sDimStyle};
		Map mapTsl;	
					
	// loop tsls
		for (int i=ents.length()-1; i>=0 ; i--) 
		{ 
			TslInst tsl=(TslInst)ents[i];
			if (tsl.bIsValid() && tsl.scriptName().find("f_truck",0,false)>-1)
			{ 
				Map map = tsl.map();
				if (map.getInt("isGrid")==1)
				{ 
					entsTsl[0] = tsl;
					tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
				}
			}
		}	
		
		eraseInstance();
		return;
	}	
// end on insert	__________________//endregion

//region Validate truck grid reference
	TslInst truckGrid, truck;
	CoordSys csGrid2Package;
	for (int i=0;i<_Entity.length();i++) 
	{ 
		TslInst tsl=(TslInst)_Entity[i];
		if (tsl.bIsValid() && tsl.scriptName().find("f_truck",0,false)>-1 && tsl.map().getInt("isGrid"))
		{ 
			truckGrid = tsl;
			setDependencyOnEntity(tsl);
			break;
		} 
	}//next i
	
	if (!truckGrid.bIsValid())
	{ 
		reportMessage("\n"+ scriptName() + ": " + T("|Could not find a valid truck grid reference.|")+T(" |Tool will be deleted.|"));
		eraseInstance();
		return;	
	}
	else
	{
	// write parent data to this (child), (over)write submapX
		Map m;
		m.setString("MyUid", truckGrid.handle());		
		m.setPoint3d("ptOrg", truckGrid.ptOrg(), _kRelative);
		m.setVector3d("vecX", _XW, _kScalable); // coordsys carries size
		m.setVector3d("vecY", _YW, _kScalable);
		m.setVector3d("vecZ", _ZW, _kScalable);
		_ThisInst.setSubMapX("Hsb_Parent",m);
		
		// get truckGrid to truck transformation
		m=truckGrid.subMapX("Hsb_Grid2Truck");	
		truck.setFromHandle(m.getString("MyUid"));
		csGrid2Package = CoordSys(m.getPoint3d("ptOrg"),m.getVector3d("vecX"),	m.getVector3d("vecY"),	m.getVector3d("vecZ"));
	}
//End Validate truck grid reference//endregion 

//region Get enums, map and its data
	_ThisInst.setAllowGripAtPt0(false);
	int nResolution = sResolutions.find(sResolution,0);
	
// get wrap display
	if (sWrap.find(disabled, 0, false) < 0)
	{ 
		Map m = mapWraps;
		k = "Thickness"; 	if (m.hasDouble(k)) dWrapThickness = m.getDouble(k);
		k = "Color"; 		if (m.hasInt(k)) 	nWrapColor = m.getInt(k);
		k = "Transparency"; if (m.hasInt(k)) 	nWrapTransparency = m.getInt(k);
		
		for (int i = 0; i < mapWraps.length(); i++)
		{
			Map mapWrap = mapWraps.getMap(i);
			String name = mapWrap.getString("Name");
			if (name==sWrap)
			{ 
				Map m = mapWrap;
				k = "Thickness"; 	if (m.hasDouble(k)) dWrapThickness = m.getDouble(k);
				k = "Color"; 		if (m.hasInt(k)) 	nWrapColor = m.getInt(k);
				k = "Transparency"; if (m.hasInt(k)) 	nWrapTransparency = m.getInt(k);
				break;
			}
		}//next i		
	}

	Map map = truckGrid.map();
	Point3d ptCOG = map.getPoint3d("ptCOG");
	double dWeight = map.getDouble("Weight");
	Map mapCells = map.getMap("Cell[]");
	int nStackingType = -1; // unknown

	k = "type";	if (map.hasInt(k)) nStackingType = map.getInt(k);
	
	// transformation from projected COG to _Pt0
	CoordSys cs2Package;
	{ 
		Point3d pt = ptCOG;
		pt.setZ(0);
		if (_bOnDbCreated)_Pt0 = pt;
		cs2Package.setToTranslation(_Pt0 - pt);
	}
	
	// transform to horizontal
	if (nStackingType==0)
	{ 
		CoordSys csHor;
		csHor.setToAlignCoordSys(_Pt0, _XW, - _ZW, _YW, _Pt0, _XW, _YW, _ZW);
		cs2Package.transformBy(csHor);
	}
	ptCOG.transformBy(cs2Package);
	ptCOG.vis(4);
		
//End get map and its data//endregion 

//region Get the stacked entities
	Map mapRequests;
	Entity ents[0], items[0];
	for (int i=0;i<mapCells.length();i++) 
	{ 
		Map cell = mapCells.getMap(i);
		Entity entCellItems[] = cell.getEntityArray("Item[]", "", "Item");
		for (int j=0;j<entCellItems.length();j++) 
		{ 
			Entity item = entCellItems[j];
			Map mapX = item.subMapX("Hsb_item");

			Entity ref;
			ref.setFromHandle(mapX.getString("MYUID"));
			if(ref.bIsValid())
			{
				ents.append(ref); 
				items.append(item);
			}
		}//next j
	}//next i
	
// store referenced entities in subMapX
	{ 
		Map map;
		map.setEntityArray(ents,false,"Entity[]", "", "Entity");
		_ThisInst.setSubMapX("Hsb_Child[]", map);
	}
	
	
	if (ents.length()<1)
	{ 
		Display dp(1);
		dp.draw(scriptName() + ": " + T("|No items found.|"), _Pt0, _XW, _YW, 1, 0);
		return;
	}
	
	
//End Get the stacked entities//endregion 

//region Build and transform Package Solid and collect potential drawRequests
	
	Body bodies[0], bdPack, bdEdgeProtection;
	for (int i=0;i<ents.length();i++) 
	{ 
		Entity ent= ents[i];
		Entity item= items[i];
		GenBeam gb = (GenBeam)ent;
		ElementWall wall = (ElementWall)ent;
		Body bd;
		if (gb.bIsValid() && nResolution<2)
			bd = gb.envelopeBody(true, false);
		else
			bd = ent.realBody();
		
		Map m= ent.subMapX("Hsb_Item2Truck");
		CoordSys cs(m.getPoint3d("ptOrg"), m.getVector3d("vecX"), m.getVector3d("vecY"),m.getVector3d("vecZ"));
		cs.transformBy(cs2Package);

	// get potential draw to dim requests byItem	
		Map _mapRequests = item.subMapX("Hsb_DimensionInfo").getMap("DimRequest[]");
		for (int j=0;j<_mapRequests.length();j++) 
		{
			Map m = _mapRequests.getMap(j);
			if (m.hasPlaneProfile("PlaneProfile"))
			{ 
				PlaneProfile pp = m.getPlaneProfile("PlaneProfile");
				pp.transformBy(cs);
				m.setPlaneProfile("PlaneProfile", pp);
			}
			//m.transformBy(cs);
			mapRequests.appendMap("DimRequest",m); 
		}

	// debug test
		if (bDebug && 0)
		{ 
			Map m;
			Vector3d dirs[] ={ _XW, _YW, _ZW};
			for (int v=0;v<dirs.length();v++) 
			{ 
				Point3d pts[0];
				pts = bd.extremeVertices(dirs[v]);
				if (pts.length()>0)
				{ 
					PLine pl(pts.first(), pts.last());
					m.setVector3d("AllowedView", v>1?dirs[0]:dirs[v+1]);
					m.setInt("AlsoReverseDirection", true);
					m.setInt("Color",v==0?1:v==2?3:150);
					m.setString("lineType",_LineTypes.first());
					m.setPLine("pline", pl);
					m.transformBy(cs);
					mapRequests.appendMap("DimRequest", m);
				} 
			}//next v
		}	
		
		
	//region store wall association in additional Stacking data
		if (gb.bIsValid())
		{ 
			Element el = gb.element();
			if (el.bIsValid()) wall = (ElementWall)el;
		}
		String sWallRotation;
		if (wall.bIsValid())
		{ 
			CoordSys csWall = wall.coordSys();
			csWall.transformBy(cs);		//csWall.vis(4);
			
			Vector3d vecYWall = csWall.vecY();
			Vector3d vecZWall = csWall.vecZ();
			int bIsVertical = vecZWall.isPerpendicularTo(_ZW);
			int bIsHorizontal= vecZWall.isParallelTo(_ZW);
			
			if (bIsVertical)
			{ 
				double d = vecYWall.angleTo(_ZW);
				sWallRotation.formatUnit(d, 2, 0);				
			}
		}
		{ 
			Map m = ent.subMapX("Hsb_StackingData");
			k = "Wall Rotation";
			if (sWallRotation=="" && m.hasString(k))	m.removeAt(k, true);
			else										m.setString(k, sWallRotation);
			ent.setSubMapX("Hsb_StackingData",m);
		}
	//End Stacking data//endregion 	

		bd.transformBy(cs);//bd.vis(21);
		bodies.append(bd);
		bdPack.addPart(bd);		
		
		
	//region Edge Protection Vertical Stacking
		double 	edgeProtection = (sWallRotation == "90" ||sWallRotation == "270") ? dEdgeProtection2 : dEdgeProtection1;
		if (edgeProtection>0 && nStackingType==1)
		{ 
			PlaneProfile ppY = bd.shadowProfile(Plane(bd.ptCen(),_YW));
			ppY.vis(4);
			
			PLine plines[] = ppY.allRings(true, false);
			for (int p=0;p<plines.length();p++) 
			{ 
				PLine pl= plines[p]; 
				Point3d pts[] = pl.vertexPoints(false);
				for (int p=0;p<pts.length()-1;p++) 
				{ 
					Point3d pt1 = pts[p];
					Point3d pt2 = pts[p+1];
					Point3d ptMid = ppY.closestPointTo((pt1 + pt2) * .5);
					Vector3d vecXS = pt2 - pt1; vecXS.normalize();
					Vector3d vecYS = vecXS.crossProduct(-_YW);
					if (ppY.pointInProfile(ptMid+vecYS*dEps)!=_kPointOutsideProfile)
						vecYS *= -1;
					if (vecYS.isPerpendicularTo(_ZW) || vecYS.dotProduct(_ZW)<=0)continue;
					
					//vecYS.vis(ptMid, 3);
				
				// ignore segments intersecting rings above
					PlaneProfile ppRec;
					ppRec.createRectangle(LineSeg(pt1, pt2 + vecYS * U(10e4)), vecXS, vecYS);
					ppRec.intersectWith(ppY);
					if (ppRec.area() > pow(U(10), 2))continue;
	
					LineSeg seg(pt1 - _YW * U(10e4), pt2 + _YW * U(10e4));
					PlaneProfile pp;
					pp.createRectangle(seg, vecXS, _YW);
					PlaneProfile pp2 = bdPack.extractContactFaceInPlane(Plane(pt1, vecYS), dEps);
					//pp2.project(Plane(pt1, vecYS), _ZW, dEps);
					pp.intersectWith(pp2);
					//pp.vis(p);
					
					PLine rings[] = pp.allRings(true, false);
					for (int r=0;r<rings.length();r++) 
						bdEdgeProtection.addPart(Body(rings[r], vecYS*edgeProtection,1));
						
				}//next p			 
			}//next i			
			
			
		}
	//End Edge Protection//endregion 	
		
		
		
		//if (i == 0)csGrid2Package = cs;
		//bd.vis(i+1);
		 
	}//next i
		
//End Build and transform Package Solid//endregion 






//region Get boundings in truck view
	PlaneProfile ppPack = bdPack.shadowProfile(Plane(_Pt0, _ZW));
	//ppPack.createRectangle(ppPack.extentInDir(_XW), _XW, _YW); // uncomment to refer to boundings
	CoordSys csMove;
	if (nStackingType==0)
	{ 
		Point3d pts[] = bdPack.extremeVertices(_ZW);
		double dZPack = bdPack.lengthInDirection(_ZW);
		Point3d ptMid = ppPack.extentInDir(_XW).ptMid();
		Vector3d vecTrans = _Pt0-ptMid;
		ppPack.transformBy(vecTrans);
		if (pts.length()>0)
			vecTrans += _ZW*_ZW.dotProduct(_Pt0-pts.first());//+.5 * _ZW * dZPack; HSB-9330
		csMove.setToTranslation(vecTrans);
		bdPack.transformBy(csMove);
		for (int i=0;i<bodies.length();i++) 
			bodies[i].transformBy(csMove);	
		cs2Package.transformBy(csMove);
		
	// Edge protection Horizontal Stacking	
		if (dEdgeProtection1>0)
		{ 
			Point3d pts[] = bdPack.extremeVertices(_ZW);
			pts = Line(_Pt0 ,- _ZW).orderPoints(pts);
			if (pts.length()>0)
			{ 
				Plane pn(pts.first(), _ZW);
				PlaneProfile pp = bdPack.extractContactFaceInPlane(pn, dEps);
				PLine rings[] = pp.allRings(true, false);
				for (int r=0;r<rings.length();r++) 
					bdEdgeProtection.addPart(Body(rings[r], _ZW*dEdgeProtection1,1));
			}
		}	
	}
	//ppPack.vis(1);
//End Get boundings in truck view//endregion 




	csGrid2Package.transformBy(cs2Package);






//region Get bedding grids relevant on this
	TslInst beddings[0];
	Vector3d vecTransBedding;
	Body bdBedding;
	Point3d ptsBeddingX[0];
	{
		double width, height;
		Entity ents[] = Group().collectEntities(true, TslInst(), _kModelSpace);	
		for (int i=0;i<ents.length();i++) 
		{ 
			TslInst bedding=(TslInst)ents[i];
			if (!bedding.bIsValid() || bedding.scriptName().find("f_grid",0,false)<0){continue;}
			
			Entity _ents[] = bedding.entity();
			if (_ents.find(truckGrid)<0){ continue;}
			
			beddings.append(bedding);
			Point3d grips[] = bedding.gripPoints();
			if (grips.length() > 0)grips.removeAt(0); // remove _Pt0
			
			width = bedding.propDouble(1);
			height= bedding.propDouble(2);
			
			if (width <= 0 || height <= 0)continue;
			
			for (int p=0;p<grips.length();p++) 
			{ 
				Point3d pt= grips[p]; 
				pt.transformBy(csGrid2Package);
				pt.setZ(_Pt0.Z());
				pt.vis(p);
				
				PlaneProfile pp;
				pp.createRectangle(LineSeg(pt - (.5 * _XW * width+ _YW * U(10e4)), pt + (.5 * _XW * width+ _YW * U(10e4))), _XW, _YW);
				pp.intersectWith(ppPack);
				
				PLine rings[] = pp.allRings(true, false);
				for (int r=0;r<rings.length();r++) 
					bdBedding.addPart(Body(rings[r], _ZW*height,1)); 

			// collect bedding location for shopdrawings
				if (pp.area()>pow(dEps,2))
					ptsBeddingX.append(pt);


			}//next p
			
			break;// only one bedding allowed	 	
		}//next i
		
		//bdBedding.vis(4);
		double dZBedding = bdBedding.lengthInDirection(_ZW);
		if (dZBedding>0)
		{ 
			vecTransBedding = _ZW * dZBedding;
			bdPack.transformBy(vecTransBedding);
			cs2Package.transformBy(vecTransBedding);
			for (int i=0;i<bodies.length();i++) 
				bodies[i].transformBy(vecTransBedding); 	
				
			bdEdgeProtection.transformBy(vecTransBedding);	
		}
	}
//End Get bedding grids relevant on this//endregion 

	{ 
	// publish package transformation to submapX
		Map m;
		m.setString("MyUid", _ThisInst.handle());		
		m.setPoint3d("ptOrg", cs2Package.ptOrg(), _kRelative);
		m.setVector3d("vecX", cs2Package.vecX(), _kScalable); // coordsys carries size
		m.setVector3d("vecY", cs2Package.vecY(), _kScalable);
		m.setVector3d("vecZ", cs2Package.vecZ(), _kScalable);
		_ThisInst.setSubMapX("Hsb_Truck2Package",m);		
	}


//region Simplify pack body
	PlaneProfile ppY = bdPack.shadowProfile(Plane(_Pt0,_YW));
//	if (0 && nResolution==0)// deprecated 1.0
//	{ 
//		PlaneProfile ppX = bdPack.shadowProfile(Plane(_Pt0,_XW));
//		PlaneProfile pps[] ={ ppX, ppY, ppPack};
//		Body bdXYZs[3];
//		for (int xyz=0;xyz<pps.length();xyz++) 
//		{ 
//			PlaneProfile pp = pps[xyz];
//			int cnt;
//			PLine rings[]= pp.allRings(true, false);
//			double dIncr = U(10);
//			while (cnt<100 && rings.length()>1)
//			{ 
//				cnt++;
//				pp.shrink(cnt *- dIncr);
//				pp.shrink(cnt * dIncr);
//				rings= pp.allRings(true, false);
//			}	
//			
//			Body bd;
//			for (int i=0;i<rings.length();i++) 
//				bd.addPart(Body(rings[i], pp.coordSys().vecZ()*U(10e4),0)); 
//			bdXYZs[xyz] = bd;
//			
//			if (xyz == 0) ppX = pp;
//			else if (xyz == 1) ppY = pp;
//			if (xyz == 2) ppPack = pp;
//			
//		}//next xyz
//
//		Body bdNew= bdXYZs.last();
//		for (int i=0;i<bdXYZs.length()-1;i++) 
//			bdNew.intersectWith(bdXYZs[i]);
//		
//		if (bdNew.volume()>pow(U(1),3))
//		{
//			bdNew.vis(5);
//			bdPack = bdNew;
//		}	
//	}	
//End Simplify pack body//endregion 

//region Upper Edge Protection


	
	if (0 && dEdgeProtection1>0)
	{	
		//PlaneProfile ppY = bdPack.shadowProfile(Plane(_Pt0,_YW));
		ppY.vis(4);
		PLine plines[] = ppY.allRings(true, false);
		for (int i=0;i<plines.length();i++) 
		{ 
			PLine pl= plines[i]; 
			Point3d pts[] = pl.vertexPoints(false);
			for (int p=0;p<pts.length()-1;p++) 
			{ 
				Point3d pt1 = pts[p];
				Point3d pt2 = pts[p+1];
				Point3d ptMid = ppY.closestPointTo((pt1 + pt2) * .5);
				Vector3d vecXS = pt2 - pt1; vecXS.normalize();
				Vector3d vecYS = vecXS.crossProduct(-_YW);
				if (ppY.pointInProfile(ptMid+vecYS*dEps)!=_kPointOutsideProfile)
					vecYS *= -1;
				if (vecYS.isPerpendicularTo(_ZW) || vecYS.dotProduct(_ZW)<=0)continue;
				
				//vecYS.vis(ptMid, 3);
			
			// ignore segments intersecting rings above
				PlaneProfile ppRec;
				ppRec.createRectangle(LineSeg(pt1, pt2 + vecYS * U(10e4)), vecXS, vecYS);
				ppRec.intersectWith(ppY);
				if (ppRec.area() > pow(U(10), 2))continue;

				LineSeg seg(pt1 - _YW * U(10e4), pt2 + _YW * U(10e4));
				PlaneProfile pp;
				pp.createRectangle(seg, vecXS, _YW);
				PlaneProfile pp2 = bdPack.extractContactFaceInPlane(Plane(pt1, vecYS), dEps);
				//pp2.project(Plane(pt1, vecYS), _ZW, dEps);
				pp.intersectWith(pp2);
				//pp.vis(p);
				
				PLine rings[] = pp.allRings(true, false);
				for (int r=0;r<rings.length();r++) 
					bdEdgeProtection.addPart(Body(rings[r], vecYS*dEdgeProtection1,1));
					
			}//next p			 
		}//next i	
	}
	
//End Top Edge Protection//endregion 


//region Bounding body
	Body bdBoundary=bdPack;
	if (bdEdgeProtection.volume()>pow(dEps,3))bdBoundary.combine(bdEdgeProtection);
	if (bdBedding.volume()>pow(dEps,3))bdBoundary.combine(bdBedding);
	
//End Bounding body//endregion 


//region Formatting
	Map mapAdditionalVariables;
	String sObjectVariables[] = _ThisInst.formatObjectVariables();
	
// append additional variables
	{ 
		String name;
		name = "Length";	
		if (sObjectVariables.findNoCase(name ,- 1) < 0)
		{
			sObjectVariables.append(name);
			mapAdditionalVariables.appendDouble(name, bdPack.lengthInDirection(_XW));
		}
		name = "Width";		
		if (sObjectVariables.findNoCase(name ,- 1) < 0)
		{
			sObjectVariables.append(name);
			mapAdditionalVariables.appendDouble(name, bdPack.lengthInDirection(_YW));
		}
		name = "Height";	
		if (sObjectVariables.findNoCase(name ,- 1) < 0) 
		{
			sObjectVariables.append(name);
			mapAdditionalVariables.appendDouble(name, bdPack.lengthInDirection(_ZW));
		}

		name = "BoundingLength";	
		if (sObjectVariables.findNoCase(name ,- 1) < 0)
		{
			sObjectVariables.append(name);
			mapAdditionalVariables.appendDouble(name, bdBoundary.lengthInDirection(_XW));
		}
		name = "BoundingWidth";		
		if (sObjectVariables.findNoCase(name ,- 1) < 0)
		{
			sObjectVariables.append(name);
			mapAdditionalVariables.appendDouble(name, bdBoundary.lengthInDirection(_YW));
		}
		name = "BoundingHeight";	
		if (sObjectVariables.findNoCase(name ,- 1) < 0) 
		{
			sObjectVariables.append(name);
			mapAdditionalVariables.appendDouble(name, bdBoundary.lengthInDirection(_ZW));
		}

		name = "Weight";	
		if (sObjectVariables.findNoCase(name ,- 1) < 0) 
		{
			sObjectVariables.append(name);
			mapAdditionalVariables.appendDouble(name, dWeight);
		}
		
		
		mapAdditionalVariables.appendPoint3d("ptMid", ppPack.extentInDir(_XW).ptMid());
	}

	// append truck variables
	if (truck.bIsValid())
	{ 
		String sTruckObjectVariables[] = truck.formatObjectVariables();
		for (int i=0;i<sTruckObjectVariables.length();i++) 
		{ 
			if (sObjectVariables.find(sTruckObjectVariables[i]) >- 1)continue;

			String name = "Truck "+sTruckObjectVariables[i]; 
			String value = truck.formatObject("@("+sTruckObjectVariables[i]+")");
			mapAdditionalVariables.appendString(name, value);
			sObjectVariables.append(name);
		}//next i
		
	}

	_ThisInst.setSubMapX("AdditionalVariables", mapAdditionalVariables);// Expose additionalVariables

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


//region Trigger AddRemoveFormat
{ 
	Entity ents[] ={_ThisInst};//
	String sTriggerAddRemoveFormat = T("|Add/Remove Format|");
	addRecalcTrigger(_kContext, "../"+sTriggerAddRemoveFormat );
	if (_bOnRecalc && (_kExecuteKey=="../"+sTriggerAddRemoveFormat || _kExecuteKey==sTriggerAddRemoveFormat))
	{
		String sPrompt;
		sPrompt+="\n"+ T("|Select a property by index to add or to remove|") + T(", |Exit with 0|");
		reportNotice(sPrompt);
		
		for (int s=0;s<sObjectVariables.length();s++) 
		{ 
			String key = sObjectVariables[s]; 
			String keyT = sTranslatedVariables[s];
			String sValue;
			for (int j=0;j<ents.length();j++) 
			{ 
				String _value = ents[j].formatObject("@(" + key + ")", mapAdditionalVariables);
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
				String var ="@(" + sObjectVariables[nRetVal] + ")";
				int x = sFormat.find(var, 0);
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
}	
//endregion 

	String text = _ThisInst.formatObject(sFormat,mapAdditionalVariables);
//End Formatting//endregion 

//region Display
	Display dpModel(nc), dpBedding(nc), dpEdge(32), dpText(ncTxt), dpPlan(nc);
	dpText.dimStyle(sDimStyle);
	dpText.addHideDirection(_XW);dpText.addHideDirection(-_XW);
	dpText.addHideDirection(_YW);dpText.addHideDirection(-_YW);
	if(dTextHeight>0)dpText.textHeight(dTextHeight);
	
	dpPlan.addViewDirection(_ZW);
	dpEdge.addHideDirection(_ZW);
	dpEdge.addHideDirection(-_ZW);
	
	if (nResolution==0)
	{
		dpModel.addHideDirection(_ZW);
		PlaneProfile pp = ppPack;//bdPack.shadowProfile(Plane(_Pt0, _ZW));
		pp.vis(2);
		pp.shrink(-U(100));
		pp.shrink(U(100));
		dpPlan.draw(pp);
	}	
	dpModel.draw(bdPack);
	dpBedding.draw(bdBedding);
	
	if (dEdgeProtection1>0)dpEdge.draw(bdEdgeProtection);
	
	// draw if package is wrapped
	if (dWrapThickness>0)
	{ 
		Display dpWrap(nWrapColor);
		dpWrap.addViewDirection(_ZW);
		
		PlaneProfile ppWrap = ppPack;
		
	// make sure it only consists of one ring. Obviously this could change the outline
		PLine rings[] = ppWrap.allRings(true, false);
		{ 
			int cnt=1;
			while (cnt<10 && rings.length()>0)
			{ 
				PlaneProfile pp = ppWrap;
				double d = cnt * U(20);
				pp.shrink(-d);
				pp.shrink(d);
				rings=pp.allRings(true, false);
				if (rings.length()==1)
					ppWrap = pp;
				cnt++;
			}
		}
		PlaneProfile ppSub = ppWrap;
		ppSub.shrink(dWrapThickness);
		ppWrap.subtractProfile(ppSub);
		if (nWrapTransparency > 0 && nWrapTransparency < 100)dpWrap.draw(ppWrap, _kDrawFilled, nWrapTransparency);
		else dpWrap.draw(ppWrap, _kDrawFilled);
	}
	

// get badge reference location on top of package
	Point3d ptTagRef = _Pt0 + _ZW*(mapAdditionalVariables.getDouble("BoundingHeight")+dEps);
	ptTagRef.vis(2);	
	
// text	
	PlaneProfile ppText;
	if (text.length()>0)
	{ 
		if (_PtG.length() < 1)_PtG.append(ptTagRef);
		Point3d pt = _PtG[0];
		pt += _ZW * _ZW.dotProduct(ptTagRef - pt);

		double dD = dpText.textHeightForStyle("O", sDimStyle, dTextHeight);
		double dX = dpText.textLengthForStyle(text, sDimStyle, dTextHeight)+dD;
		double dY = dpText.textHeightForStyle(text, sDimStyle, dTextHeight)+dD;
	
	// box
		PlaneProfile pp;
		//pt.setZ(0);//pt += _ZW * _ZW.dotProduct(ptCOG - pt);
		pp.createRectangle(LineSeg(pt - .5 * (_XW * dX + _YW * dY), pt + .5 * (_XW * dX + _YW * dY)), _XW, _YW);
		dpText.color(ncFill);
		dpText.draw(pp,_kDrawFilled, ntFill);
		dpText.color(ncBorder);
		dpText.draw(pp);
		ppText = pp;
		
	// guide line
		Point3d pt1 = ppPack.closestPointTo(ptCOG);
		//pt1.setZ(0);
		pt1 += _ZW * _ZW.dotProduct(ptTagRef - pt1);	//pt1.vis(1);
		
		Point3d pt2 = pp.closestPointTo(pt1);
		//pt2.setZ(0);//
		pt2 += _ZW * _ZW.dotProduct(ptTagRef - pt2);	//pt2.vis(2);
		
		if (ppPack.pointInProfile(pt2)==_kPointOutsideProfile && ppPack.pointInProfile(pt)==_kPointOutsideProfile)
		{ 
			Vector3d vecDir = pt2 - pt1;
			double dD = vecDir.length();
			vecDir.normalize();
			
			Point3d pt3 = ptCOG; 
			pt3 += _ZW * _ZW.dotProduct(ptTagRef - pt3);//pt3.setZ(0);
			PLine pl(pt2,pt2-vecDir*.3*dD,pt3);
			if (ppPack.pointInProfile(ptCOG)==_kPointOutsideProfile)
			{
				Point3d pt = ppPack.closestPointTo(ptCOG);
				//pt.setZ(0);
				pt += _ZW * _ZW.dotProduct(ptTagRef - pt);
				pl.addVertex(ppPack.closestPointTo(pt));
			}
			dpText.draw(pl);
		}
	// text
		dpText.color(ncTxt);
		dpText.draw(text,pt,  _XW, _YW, 0, 0);
				
	}
	else
		_PtG.setLength(0);
	
// mapRequests
	if (nResolution!=0)
	for (int j=0;j<mapRequests.length();j++) 
	{ 
		Map m= mapRequests.getMap(j); 
		int color = m.getInt("color");
		Display dp(color);
	// draw plines in high detail	
		if (m.hasPLine("pline") && nResolution==2)
		{ 
			PLine pline = m.getPLine("pline");
			dp.draw(pline);	
		}
	// draw planeprofiles	
		else if (m.hasPlaneProfile("PlaneProfile"))
		{ 
			PlaneProfile pp = m.getPlaneProfile("PlaneProfile");
			pp.transformBy(vecTransBedding);
			pp.transformBy(csMove);
			
			int nt = m.getInt("Transparency");
			int drawFilled = m.getInt("DrawFilled");
			if (nt>0 && nt<100)
			{
				dp.draw(pp,_kDrawFilled, nt);
				dp.draw(pp);
			}
			else if (drawFilled)
			{
				dp.draw(pp, _kDrawFilled);
				dp.draw(pp);
			}

		// high detail
			else if (nResolution==2)
				dp.draw(pp);
		}		 
	}//next i
	
	
//End Display//endregion 



//region Publish extents as dimrequests
	{ 
		Map mapRequests;// = item.subMapX("Hsb_DimensionInfo").getMap("DimRequest[]");

		Vector3d vecDirs[] = {_XW, _XW, -_YW};
		Vector3d vecPerps[] = {_YW, _ZW, _ZW};
		for (int i=0;i<vecDirs.length();i++) 
		{ 
			Vector3d vecDir= vecDirs[i];
			Vector3d vecPerp= vecPerps[i];
			Vector3d vecZView = vecDir.crossProduct(vecPerp);
			
			Map mapRequest;
			mapRequest.setString("DimRequestPoint", "DimRequestPoint");
			mapRequest.setVector3d("AllowedView", vecZView);
			mapRequest.setInt("AlsoReverseDirection", true);
			mapRequest.setVector3d("vecDimLineDir", vecDir);
			mapRequest.setVector3d("vecPerpDimLineDir", vecPerp);
			mapRequest.setString("stereotype", scriptName());
			
		// points in vecDir to be dimensioned
			Point3d nodes[] = bdPack.extremeVertices(vecDir);
			if (i!=2)nodes.append(ptsBeddingX);
			mapRequest.setPoint3dArray("Node[]", nodes);
			mapRequests.appendMap("DimRequest", mapRequest);
			
		// points in vecPerp to be dimensioned	
			mapRequest.setVector3d("vecDimLineDir", vecPerp);
			mapRequest.setVector3d("vecPerpDimLineDir", -vecDir);
			mapRequest.setPoint3dArray("Node[]", bdPack.extremeVertices(vecPerp));
			mapRequests.appendMap("DimRequest", mapRequest);			
			
			
			
			
			
		}//next i
		
		Map mapX = _ThisInst.subMapX("Hsb_DimensionInfo");
		mapX.setMap("DimRequest[]", mapRequests);
		_ThisInst.setSubMapX("Hsb_DimensionInfo",mapX);
		
	}	
	
// publish protect area of tag
	_Map.setPlaneProfile("ppProtect", ppText);
	
	
	
//End Publish extents as dimrequests//endregion 



//region Dialog Trigger
{ 
	// create TSL
	TslInst tslDialog;			Map mapTsl;						
	GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };
	
//region Trigger DisplaySettings
	String sTriggerDisplaySetting = T("|Badge Display|");
	addRecalcTrigger(_kContext, sTriggerDisplaySetting );
	if (_bOnRecalc && _kExecuteKey==sTriggerDisplaySetting)	
	{ 
		mapTsl.setInt("DialogMode",1);
		nProps.append(ncTxt);
		nProps.append(ncBorder);
		nProps.append(ncFill);
		nProps.append(ntFill);
			
		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{ 
				ncTxt = tslDialog.propInt(0);
				ncBorder = tslDialog.propInt(1);
				ncFill = tslDialog.propInt(2);
				ntFill = tslDialog.propInt(3);
				
				
				Map m = mapSetting.getMap("Package\\Tag");
				m.setInt("Color",ncTxt);
				m.setInt("Transparency",ntFill);
				m.setInt("BorderColor",ncBorder);
				m.setInt("FillColor",ncFill);
				
				mapSetting.setMap("Package\\Tag", m);
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);				
			}
			tslDialog.dbErase();
		}
		setExecutionLoops(2);
		return;	
	}
	//endregion	

//region Trigger Import/Export Settings
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
			else bWrite = true;
				
			if (bWrite && mapSetting.length() > 0)
			{ 
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);
				
			// make sure the path exists	//HSB-10750
				int bPathFound= sFolders.find(sFolder)>-1?true:makeFolder(sPath+"\\"+sFolder);	
				
			// write file	
				mapSetting.writeToXmlFile(sFullPath);
				
			// report rsult of writing	
				if (findFile(sFullPath).length()>0)		reportMessage(TN("|Settings successfully exported to| ") + sFullPath);
				else									reportMessage(TN("|Failed to write to| ") + sFullPath);		
			}
			
			setExecutionLoops(2);
			return;
		}
	}
	//endregion 
}
//End Dialog Trigger//endregion 






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
        <int nm="BreakPoint" vl="163" />
        <int nm="BreakPoint" vl="132" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11074 new settings to control badge color and transparency, Import and Export of settings added " />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="3/5/2021 2:22:57 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End