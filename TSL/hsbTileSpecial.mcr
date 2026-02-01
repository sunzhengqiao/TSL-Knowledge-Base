#Version 8
#BeginDescription
This Tsl creates special tiles in a selected roof plane. Half tiles are automatic added if neede.

version value="3.4" date="08nov22" author="nils.gregor@hsbcad.com"> HSB-16994: Avoid version error message.

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 3
#MinorVersion 4
#KeyWords 
#BeginContents
/// <summary Lang=de>
/// Dieses TSL definiert einen Sonderziegel in Abhängigkeit zu einer Dachfläche mit gültigen Ziegeldaten
/// </summary>

/// <summary Lang=en>
/// This Tsl creates special tiles in a selected roof plane. Half tiles are automatic added if needed.
/// </summary>

/// <insert=en>
/// Select a roofplane and an insertion point
/// </insert>

/// <insert=de>
/// Dachfläche und Einfügepunkt wählen
/// </insert>

/// History
///<version value="3.4" date="08nov22" author="nils.gregor@hsbcad.com"> HSB-16994: Avoid version error message" </version>
///<version value="3.3" date="18jan21" author="nils.gregor@hsbcad.com"> Bugfix Halftiles" </version>
///<version value="3.2" date="20may19" author="nils.gregor@hsbcad.com">Added surface to the colour"</version>
///<version value="3.1" date="15apr19" author="nils.gregor@hsbcad.com">adjusted quantity of tiles to subtract </version>
///<version value="3.0" date="05apr19" author="nils.gregor@hsbcad.com">Elementary changes in the behavior of the instance. Initial version for release V22</version>
///<version value="2.1" date="20jul2018" author="thorsten.huck@hsbcad.com"> RS-114 </version>
///<version value="2.0" date="25jun2018" author="thorsten.huck@hsbcad.com"> RS-113,RS-114, RS-115, RS-116 fixed, Display enhanced </version>
///<version value="1.9" date="04jun2018" author="thorsten.huck@hsbcad.com"> RS-56 fixed, only tiles of family taken, requires builds newer then may 29th 2018 </version>
///<version value="1.8" date="22may2018" author="thorsten.huck@hsbcad.com"> issue fixed if special tiles are in adjacent columns </version>
///<version value="1.7" date="12feb2018" author="thorsten.huck@hsbcad.com"> RS-56 fixed, 
/// - tiles of distribution range match with horizontal grid
/// - dependencies added to update in correct sequence if any involved tsl changes
/// - distribution corrected to full tiles + eventually one half tile
/// - location at verge blocked on insert or when dragging a special tile to a verge tile
/// - group assignment in dependency to horizontal grid grouping
/// - additional half tile added on single specials if inserted full special in half column or half special to to full column</version>
///<version value="1.6" date="17jan2018" author="thorsten.huck@hsbcad.com"> row behaviour and output added </version>
///<version value="1.3" date="29sept16" author="thorsten.huck@hsbcad.com"> dialog shows available special tiles during insert </version>
///<version value="1.2" date="26feb16" author="thorsten.huck@hsbcad.com"> standard dialog added </version>
///<version value="1.1" date="12nov15" author="thorsten.huck@hsbcad.com"> automatic cleanup of overlapping special tiles </version>
///<version value="1.0" date="18jun15" author="thorsten.huck@hsbcad.com"> initial </version>

// constants //region
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug= false;// _bOnDebug;
	
//	// read a potential mapObject defined by hsbDebugController
//	{ 
//		MapObject mo("hsbTSLDev" ,"hsbTSLDebugController");
//		if (mo.bIsValid()){Map m = mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug = true;	break;}}
//		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());		
//	}
	//bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));	
	
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	double pi = 3.1415926359;
	//endregion

	String strAssemblyPath = _kPathHsbInstall+"\\Utilities\\RoofTiles\\RoofTilingManager.dll";  
	String strType = "hsbCad.Roof.TilingManager.Editor";
	String strFunction = "GetTiles";    
//	String sNodeRoofTileWithFamily = "RoofTileWithFamily[]\\RoofTileWithFamily";
	String sNodeRoofTileWithFamily = "RoofTile[]\\RoofTile";	

	String sSpecialTiles[0];
	String sSpecialTileName=T("|Special Tile|");
	PropString sSpecialTile(0 ,sSpecialTiles, sSpecialTileName);
	sSpecialTile.setDescription(T("|The model of the selected special tile|"));	

// default properties of the display //TODO support settings
	String sDimStyle = _DimStyles.length() > 0 ? _DimStyles[0] : "";
	double dTxtH = U(20);

// properties by settings
	int ncText = 7, ncSpecial = 12, ncHalf= 44, ncStandard = 252;// colors
	int ntSpecial = 80, ntHalf = 50, ntStandard;// transparency


// supported tile types
	int nTileTypes[] ={ 0,7,15,16,17,18,19,20,21,22,90};// 0= Standard, 7= Half, Rest special tile types
	//for (int i=15;i<100;i++) nTileTypes.append(i); // special tiles start with index 15 = snow top

// on insert//region
	if (_bOnInsert)
	{	
		if (insertCycleCount()>1) { eraseInstance(); return; }

	// show the dialog if no catalog in use
		if (_kExecuteKey != "")
			setPropValuesFromCatalog(_kExecuteKey);	
		
	// get roofplane	
		_Entity.append(getERoofPlane());
		ERoofPlane erp = (ERoofPlane)_Entity[0];

	// get family data
		Map mapFamilyDefinition = erp.subMapX("Hsb_RoofTile").getMap("RoofFamilyDefinition");
		if (mapFamilyDefinition.length()<1)
		{
			reportMessage("\n" + _ThisInst.opmName() + " " + T("|could not find valid roof tile data.|") + T("|Please make sure the roofplane has a roof tile style assigned.|") +
			T("|The tool will be deleted.|"));
			eraseInstance();
			return;
		}
		Map mapFamily = mapFamilyDefinition.getMap("RoofTileFamily");
		String sFamilyName = mapFamily.getString("FamilyName");	
		String sFamilyId = mapFamily.getString("Id");	
		Map mapManufacturer = mapFamilyDefinition.getMap("StandardRoofTile\\ManufacturerData");

	// collect special tile names from database
		Map mapIn;
		mapIn.setString("ManufacturerId",mapManufacturer.getString("ID"));
		mapIn.setString("RoofTileFamilyId",mapFamily.getString("Id"));
		for (int i=0;i<nTileTypes.length();i++)
		{
		// get tile data from database
			mapIn.setInt("TileType",nTileTypes[i]); 
			Map mapOut= callDotNetFunction2(strAssemblyPath, strType, strFunction, mapIn);	
			Map mapTiles = mapOut.getMap(sNodeRoofTileWithFamily);
			
			if(mapTiles.length() > 0)
			{
				String sName = mapTiles.getString("Name");
				if (sSpecialTiles.find(sName)<0)
					sSpecialTiles.append(sName);				
			}			
		}// next i
	
	// order alphabetically
		for (int i=0;i<sSpecialTiles.length();i++)	
			for (int j=0;j<sSpecialTiles.length()-1;j++)
			{
				String s1 = sSpecialTiles[j];
				String s2 = sSpecialTiles[j+1];
				
				if(s1.makeLower()>s2.makeLower())
					sSpecialTiles.swap(j,j+1);
			}


	// no special tiles found
		if (sSpecialTiles.length()<1)
		{
			reportMessage("\n" + scriptName() + " " + T("|Could not find any special tiles.|")+ " " + T("|Tool will be deleted.|"));
			eraseInstance();
			return;	
		}
	
	//redeclare tile type property, redeclare other properties to maintain property sequence
		sSpecialTile=PropString(0 ,sSpecialTiles, sSpecialTileName,0);
		if (sSpecialTiles.find(sSpecialTile)<0 && sSpecialTiles.length()>0)
		{
			sSpecialTile.set(sSpecialTiles[0]);
		}
		sSpecialTile.setCategory(sFamilyName);
		
	// show the dialog if no catalog in use
		if (_kExecuteKey == "")
			showDialog();		


	// prompt for locations
		TslInst tslSpecials[0];
		while(1)
		{ 
		// prompt for point input
			PrPoint ssP(TN("|Select point|")); 
			if (ssP.go()==_kOk) 
			{
				_Pt0 = ssP.value(); // append the selected points to the list of grippoints _PtG
				
			// create TSL
				TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
				GenBeam gbsTsl[] = {};		Entity entsTsl[] = {erp};		Point3d ptsTsl[] = {_Pt0};
				int nProps[]={};			double dProps[]={};				String sProps[]={sSpecialTile};
				Map mapTsl;	
				
				tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
						nProps, dProps, sProps,_kModelSpace, mapTsl);	
				if (tslNew.bIsValid())
				{
				// update created instances	
					if (tslSpecials.length()>0)	
						tslSpecials[tslSpecials.length()-1].transformBy(Vector3d(0,0,0));
					tslSpecials.append(tslNew);
				}
			}
			else
				break;				
		}							

		eraseInstance();
		return;
	}//endregion

	
// validate roofplane //region
	if (_Entity.length()<1 || !_Entity[0].bIsKindOf(ERoofPlane()))		
	{
		eraseInstance();
		return;	
	}	
	else
		setDependencyOnEntity(_Entity[0]);	

		
// get the roofplane and its coordSys
	ERoofPlane erp = (ERoofPlane)_Entity[0];
	CoordSys csErp = erp.coordSys();
	Vector3d vecX=csErp.vecX(), vecY=csErp.vecY(), vecZ=csErp.vecZ(), vecYN=vecY.crossProduct(_ZW).crossProduct(-_ZW);
	Vector3d vecXrp = vecX;
	Point3d ptOrg = csErp.ptOrg();
	PLine plEnvelope = erp.plEnvelope();
	Plane pnErp(ptOrg, vecZ);
	PlaneProfile ppErp(plEnvelope);
	double dAreaErp =ppErp.area();
	LineSeg segErp = ppErp.extentInDir(vecX);
	double dXErp = abs(vecX.dotProduct(segErp.ptStart()-segErp.ptEnd()));
	double dYErp = abs(vecY.dotProduct(segErp.ptStart()-segErp.ptEnd()));
	Line lnX(ptOrg,vecX);
	Line lnY(ptOrg,vecY);//endregion
	
	double dPitch = vecY.angleTo(vecYN) * 180 / pi;

// collect all special tile instances attached to this roofplane and a potential grid tsl to get grouping information//region
	TslInst tslGrid;
	TslInst tslTileVerge, tslTileHipRidge;
	TslInst tslsSpecial[]=erp.tslInstAttached();	

	for (int i=tslsSpecial.length()-1;i>=0;i--)
	{
		String name = tslsSpecial[i].scriptName();
		String u = name;
		
		if(u.find("hsbTileVerge",0) > -1)
			tslTileVerge = tslsSpecial[i];
			
		if(u.find("hsbTileHipRidge",0) > -1)
			tslTileHipRidge = tslsSpecial[i];
		
		if (u.makeUpper().find("TILEGRID",0)>-1)
		{ 
			String o = tslsSpecial[i].opmName();
			if (o.makeUpper().find("HORIZONTAL", 0) < 0)continue;
			tslGrid = tslsSpecial[i];
			if (tslGrid.groups().length()>0)
				_ThisInst.assignToGroups(tslGrid, 'I');
			tslsSpecial.removeAt(i);
		}
		else if(tslsSpecial[i]==_ThisInst)
		{
			tslsSpecial.removeAt(i);
			i--;
		}
		else if (bDebug && scriptName() =="__HSB__PREVIEW" && u=="HSBTILESPECIAL")
		{	
			continue;
		}
		else if (name!=_ThisInst.scriptName() )
		{
			tslsSpecial.removeAt(i);		
			i--;
		}
	}

// set dependency to horizontal tile grid
	if (tslGrid.bIsValid())
	{ 
		_Entity.append(tslGrid);
		setDependencyOnEntity(tslGrid);
	}
	
// the collection of all involved roofplanes	
	ERoofPlane erps[] = {erp};//endregion


// get family data//region
	Map mapFamilyDefinition = erp.subMapX("Hsb_RoofTile").getMap("RoofFamilyDefinition");
	if (mapFamilyDefinition.length()<1)
	{
		reportMessage("\n" + _ThisInst.opmName() + " " + T("|could not find valid roof tile data.|") + T("|Please make sure the roofplane has a roof tile style assigned.|") +
		T("|The tool will be deleted.|"));
		//eraseInstance();
		return;
	}
	Map mapFamily = mapFamilyDefinition.getMap("RoofTileFamily");
	String sFamilyName = mapFamily.getString("FamilyName");	
	String sFamilyId = mapFamily.getString("Id");	
	Map mapManufacturer = mapFamilyDefinition.getMap("StandardRoofTile\\ManufacturerData");
	Map mapStandardTile = mapFamilyDefinition.getMap("StandardRoofTile");
	int nNumStandardTile;
	int nTileDistribution = mapFamily.getInt("tileDistribution");
	int bCanBeStaggered = ( 0 < nTileDistribution && nTileDistribution< 3) ? true : false;

// collect special tile names from database//region
// prerequisites to read database
	Map mapIn;
	mapIn.setString("ManufacturerId",mapManufacturer.getString("ID"));
	mapIn.setString("RoofTileFamilyId",sFamilyId);

// collect special tile names from database
	Map mapSpecialTiles[0];
	for (int i=0;i<nTileTypes.length();i++)
	{
	// get tile data from database
		mapIn.setInt("TileType",nTileTypes[i]);
		Map mapOut= callDotNetFunction2(strAssemblyPath, strType, strFunction, mapIn);	
		Map mapTiles = mapOut.getMap(sNodeRoofTileWithFamily);
		
		if(mapTiles.length() > 0)
		{
			String sName = mapTiles.getString("Name");
			if (sSpecialTiles.find(sName)<0)
			{
				sSpecialTiles.append(sName);
				mapSpecialTiles.append(mapTiles);
			}		
		}
	}// next i

// order alphabetically
	for (int i=0;i<sSpecialTiles.length();i++)	
		for (int j=0;j<sSpecialTiles.length()-1;j++)
		{
			String s1 = sSpecialTiles[j];
			String s2 = sSpecialTiles[j+1];
			
			if(s1.makeLower()>s2.makeLower())
			{
				sSpecialTiles.swap(j,j+1);
				mapSpecialTiles.swap(j,j+1);
			}
		}


// no special tile sfound
	if (sSpecialTiles.length()<1)
	{
		reportMessage("\n" + scriptName() + " " + T("|Could not find any special tiles.|")+ " " + T("|Tool will be deleted.|"));
		eraseInstance();
		return;	
	}

// redeclare tile type property
	sSpecialTile=PropString(0 ,sSpecialTiles, sSpecialTileName);
	int nSpecialTile = sSpecialTiles.find(sSpecialTile);	
	if (nSpecialTile <0 && sSpecialTiles.length()>0)
	{
		nSpecialTile =0;
		sSpecialTile.set(sSpecialTiles[nSpecialTile]);
	}
	sSpecialTile.setCategory(sFamilyName);

//	if(_bOnRecalc)
	{
		if (nSpecialTile != _Map.getInt("nSpecialTile"))
		{
			_Map.setInt("nSpecialTile", nSpecialTile);
			setExecutionLoops(2);
			return;
		}	
	}
	_Map.setInt("nSpecialTile", nSpecialTile);
			
// get grid data
	Map mapExport = erp.subMapX("Hsb_TileExportData");
	Point3d ptsHGrid[] = mapExport.getPoint3dArray("HorizontalDistribution");
	PlaneProfile ppRoof = mapExport.getPlaneProfile("ppRoof");
	PlaneProfile ppPositioning = mapExport.getPlaneProfile("ppPositioning");
	PlaneProfile ppHalfs = mapExport.getPlaneProfile("ppHalfs");
	PlaneProfile ppHalfRCs = mapExport.getPlaneProfile("ppHalfRCs");
	double dColumnWidth = mapExport.getDouble("ColumnWidth");
	int bFirstRow = mapExport.getInt("Staggered");
	double dDistance = mapExport.getDouble("Distance");
	int nHorizontalAlignment = mapExport.getInt("nHorizontalAlignment");
	double dAvHalf = mapExport.getDouble("dAvHalf");
	Point3d ptsHalfColumns[] = mapExport.getPoint3dArray("PtGsHalfColumn");
	
	LineSeg segV0 = ppRoof.extentInDir(vecY);
	Point3d ptsVGrid[0];
	ptsVGrid.append(segV0.ptStart());	
	ptsVGrid.append(mapExport.getPoint3dArray("VerticalDistribution"));	

	if (nHorizontalAlignment == 2) vecX = - vecX;
	int bInStaggeredRow = false;

// the display
	Display dpPlan(ncHalf), dpModel(ncHalf);
	dpPlan.dimStyle(sDimStyle);
	dpPlan.textHeight(dTxtH);
	dpPlan.addViewDirection(_ZW);
	dpModel.dimStyle(sDimStyle);
	dpModel.textHeight(dTxtH);
	dpModel.addHideDirection(_ZW);

// get the tile map of the selected special tile
	Map mapTile;
	if (mapSpecialTiles.length()>nSpecialTile)
		mapTile = mapSpecialTiles[nSpecialTile];
	
// identify half special tile by width: any special tile < 80% of the standard width is considered to be a halftile
	double dWidth = (mapTile.getDouble("HorizontalTileSpacing\\Minimum") + mapTile.getDouble("HorizontalTileSpacing\\Maximum"))/2;
	double dStandardWidth = (mapStandardTile.getDouble("HorizontalTileSpacing\\Minimum") + mapStandardTile.getDouble("HorizontalTileSpacing\\Maximum"))/2;
	int bIsHalf;
	int bIsFull;

	if (dStandardWidth >0 && dWidth>0 && dWidth<0.9*dStandardWidth)
	{ 
		bIsHalf = true;
	}
	else
		bIsFull = true;	
		
// bring ptRef to VGrid plane
	Point3d ptRef = Line(_Pt0, _ZW).intersect(pnErp,0);
	if (ptsVGrid.length()>0)
		ptRef = Line(ptRef,_ZW).intersect(Plane(ptsVGrid[0], vecZ),0);


// find nearest location//region
	Point3d ptsY[0];
	int nRow=-1;

	for (int i = 0; i < ptsVGrid.length()-1; i++)
	{
		Point3d pt1 = ptsVGrid[i];
		Point3d pt2 = ptsVGrid[i+1];
		double d1 = vecY.dotProduct(pt1-ptRef);	
		double d2 = vecY.dotProduct(pt2-ptRef);

		if (d1>dEps && d2<dEps || d1<dEps && d2>dEps)
		{		
			if(d1>dEps && d2<dEps)
			{
				ptsY.append(pt1);
				ptsY.append(pt2);				
			}
			else
			{
				ptsY.append(pt2);
				ptsY.append(pt1);				
			}
	
			nRow=i;
			break;			
		}
	}//endregion

	Point3d tt = ptsVGrid[ptsVGrid.length() - 1];
	Point3d ptsX[0];
	int nColumn =-1;
	
// bInStaggeredRow is only used for staggered distribution and not for CanBeStaggered
	if(nTileDistribution == 1)
	{
		if(dDistance > dEps && (nRow%2) == 0 && bFirstRow == 1)
			bInStaggeredRow = true;
		if(dDistance > dEps && (nRow%2) == 1 && bFirstRow == 0)
			bInStaggeredRow = true;		
	}

	double dptsY = vecY.dotProduct(ptsY[0] - ptsHGrid[0]);

	for (int i = 0; i < ptsHGrid.length()-1; i++)
	{
		Point3d pt1 = ptsHGrid[i];	
		Point3d pt2 = ptsHGrid[i + 1]; 	

		double d1 = vecX.dotProduct(pt1-ptRef);	
		double d2 = vecX.dotProduct(pt2-ptRef);
		int a = i;
		double dCol = abs(vecX.dotProduct(pt2 - pt1));
		
		if(dCol < dAvHalf + dEps)
			dCol = dColumnWidth;
		
	// Check if special tile is in staggered row. If dDistance is 0 
		if(bInStaggeredRow && !(d1<dEps && d2>dEps))
		{
			d1 += dCol-dDistance;
			d2 += dDistance;
		}
		
		if (d1<dEps && d2>dEps)
		{	
			if(nTileDistribution == 1 && ((nRow%2) == 0 && bFirstRow == 1 || (nRow%2) != 0 && bFirstRow == 0))
			{
				pt1 += vecX * (dCol - dDistance);
				pt2 += vecX * dDistance;
			}

			ptsX.append(pt1);
			ptsX.append(pt2);	
			nColumn = a;
			break;
		}
	}

// get potential half tile
	Map mapHalfTile;
	int bHasHalfTile, nNumHalfTile;

	{
		mapIn.setInt("TileType",7); // 7 = half tile 
		Map mapOut= callDotNetFunction2(strAssemblyPath, strType, strFunction, mapIn);
		Map mapTiles = mapOut.getMap(sNodeRoofTileWithFamily);
		if(mapTiles.length() > 0)
		{
			mapHalfTile = mapTiles;//.getMap("HorizontalTileSpacing");			
			bHasHalfTile = true;			
		}
	}
	
// Control half tiles of verge and ridges that are replaced by the special tile
	if(_Map.hasPlaneProfile("ppHalfs"))
	{
		if(_Map.getPlaneProfile("ppHalfs").area()+dEps < ppHalfs.area())
		{
			_Map.removeAt("ppHalfs", true);
			_Map.removeAt("HalfVergeRemoved", true);
		}
	}
	
	if(_Map.hasPlaneProfile("ppHalfRCs"))
	{
		if(_Map.getPlaneProfile("ppHalfRCs").area()+dEps < ppHalfs.area())
		{
			_Map.removeAt("ppHalfRCs", true);
			_Map.removeAt("HalfRidgeRemoved", true);
		}
	}
	
	_Map.removeAt("plTile", true);

// test against family distribution. If half tiles are not half a full this Tsl can not staggere
	if(dAvHalf > 0.52*dColumnWidth || dAvHalf < 0.48*dColumnWidth)
		bCanBeStaggered = false;	
		

// update all specials of same row if location has been dragged and update the ppSecials
	if ( _kNameLastChangedProp=="_Pt0")
	{ 		
		for (int i = 0; i < tslsSpecial.length(); i++)
		{
			Map m = tslsSpecial[i].map();
			if (nRow==m.getInt("row") || _Map.getInt("row") == m.getInt("row"))
				tslsSpecial[i].transformBy(Vector3d(0, 0, 0));
		}
	}
	
	
	//if (_bOnDbCreated  || _kNameLastChangedProp=="_Pt0")//|| _bOnRecalc
	{	
		vecXrp.vis(ptRef, 5);
		Point3d ptRefLast = ptRef, ptRefFirst = ptRef, ptRefValidPos = ptRef + vecX * dAvHalf; ptRefValidPos.vis(4);
		if(bCanBeStaggered)
		{
			ptRefLast -= vecX * dAvHalf; 	
			ptRefFirst += vecX * dColumnWidth; 
		}	
			
	//region test interference with other specials
		for (int i=0;i<tslsSpecial.length();i++)
		{
			String s = tslsSpecial[i].scriptName();
			Map map = tslsSpecial[i].map();
			PLine plTile = map.getPLine("plTile"); 	
			if (plTile.area()<pow(dEps,2)) continue;
			
			PlaneProfile ppPlTile(plTile); 
			if (ppPlTile.pointInProfile(ptRef)!=_kPointOutsideProfile)
			{
				int bErase=true;
				{
				// reset to previous location
					Point3d ptPrev = _PtW+_Map.getVector3d("vecOrg");
					if (ppPlTile.pointInProfile(ptPrev)==_kPointOutsideProfile)
					{
						reportMessage("\n" + T("|Tile cannot be moved to this location.|"));
						_Pt0=ptPrev;
						bErase=false;
					}				 	
				}
			// all failed, erase instance	
				if (bErase)
				{
					reportMessage("\n" + sSpecialTile + " " + T("|will be deleted.|"));
					eraseInstance();
					return;
				}
			}
// Einschränken auf Staggered wenn Datenbank bereit			
			if(bCanBeStaggered && (ppPlTile.pointInProfile(ptRefFirst) ==_kPointInProfile || ppPlTile.pointInProfile(ptRefLast) ==_kPointInProfile))
			{
				_Map.setInt("bAutoReact", true);		
				tslsSpecial[i].recalcNow();
				break;
			}
			else
			{
				_Map.setInt("bAutoReact", false);				
			}
					
		}//endregion
		
	// Check if special tile is at position of standard half verge tile
		if (ppHalfs.area() > dEps)
		{
			if (tslTileVerge.bIsValid())
			{
				if (ppHalfs.pointInProfile(ptRef) != _kPointOutsideProfile || ppHalfs.pointInProfile(ptRefValidPos) != _kPointOutsideProfile)
				{
					_Map.setInt("HalfVergeRemoved", true);
				}
				else if (_Map.getInt("HalfVergeRemoved"))
				{
					_Map.setPlaneProfile("ppHalfs", ppHalfs, _kAbsolute);
				}
			}
			
			else
				mapExport.removeAt("ppHalfs", true);
		}
		
	// Check if special tile is at position of standard half pent tile
		if(ppHalfRCs.area() > dEps)
		{
			if(tslTileHipRidge.bIsValid())
			{
				if(ppHalfRCs.pointInProfile(ptRef) != _kPointOutsideProfile || ppHalfRCs.pointInProfile(ptRefValidPos) !=_kPointOutsideProfile)
				{
					_Map.setInt("HalfRidgeRemoved",true);
				}	
				else if(_Map.getInt("HalfRidgeRemoved"))
				{
					_Map.setPlaneProfile("ppHalfRCs", ppHalfRCs, _kAbsolute);				
				}
			}

			else
				mapExport.removeAt("ppHalfRCs",true);
		}
		
		if(_kNameLastChangedProp=="_Pt0" && (ppHalfs.area() > dEps || ppHalfRCs.area() > dEps))
				erp.transformBy(Vector3d(0, 0, 0));
		
		
		if (ppPositioning.pointInProfile(ptRef)!=_kPointInProfile || ppPositioning.pointInProfile(ptRefValidPos)!=_kPointInProfile )
		{
			int bErase=true;
			reportMessage(_kNameLastChangedProp);
			if (_kNameLastChangedProp=="_Pt0")
			{
			// reset to previous location
				Point3d ptPrev = _PtW+_Map.getVector3d("vecOrg");
				if (ppPositioning.pointInProfile(ptPrev) !=_kPointOutsideProfile)
				{
					reportMessage("\n" + T("|Tile cannot be moved to this location.|"));
					_Pt0=ptPrev;
					bErase=false;
				}		 	
			}

		// all failed, erase instance	
			if (bErase)
			{
				reportMessage("\n" + sSpecialTile + " " + T("|will be deleted.|"));
				eraseInstance();
				return;
			}	
		}
	}

	
// Set if special tiles react on each other and fill the tiles inbetween
	int bReactOnOther = (nTileDistribution == 2 && dDistance > 0)? true : false; // Instance should not react on others if tiles are staggered
	if(!_Map.hasInt("MineOnOther"))
		_Map.setInt("MineOnOther", bReactOnOther);
	if(_Map.hasInt("ReactOnOther"))
		bReactOnOther = _Map.getInt("ReactOnOther");
	_Map.setInt("ReactOnOther", bReactOnOther);
	String sReactOnOther =bReactOnOther? T("|Don´t react on other Special tiles|"):T("|React on other Special tiles|");
	addRecalcTrigger(_kContext, sReactOnOther);
	
	if (_bOnRecalc && _kExecuteKey==sReactOnOther)
	{
		bReactOnOther = bReactOnOther ? false : true;
		_Map.setInt("ReactOnOther", bReactOnOther);	
		_Map.setInt("MineOnOther", _Map.getInt("ReactOnOther"));
		setExecutionLoops(2);
		return;
	}
	
	// Set TSL to ReactOnOther if the TSL is side by side with other TSL
	if(_Map.getInt("bAutoReact"))
	{
//		_Map.setInt("MineOnOther", _Map.getInt("ReactOnOther"));		
		_Map.setInt("ReactOnOther", true);
	}
	
	else if(!_Map.getInt("bAutoReact") && _Map.hasInt("MineOnOther"))
		_Map.setInt("ReactOnOther", _Map.getInt("MineOnOther"));
	
	
//region collect special tiles of same row
	TslInst tslsRow[0];
	int nOtherColumns[0];
	
	if(bReactOnOther)
	{
		for (int i=0;i<tslsSpecial.length();i++) 
		{ 			
			Map m = tslsSpecial[i].map();
			if (m.getInt("row")==nRow)
			{
				tslsRow.append(tslsSpecial[i]);	
				nOtherColumns.append(m.getInt("column"));
			}
		}		
	}

	
// order other special tiles by column
	for (int i=0;i<tslsRow.length();i++) 
		for (int j=0;j<tslsRow.length()-1;j++) 
			if (nOtherColumns[j]>nOtherColumns[j+1])
			{ 
				nOtherColumns.swap(j, j + 1);
				tslsRow.swap(j, j + 1);
			}	
			
// flag if this has a previous distribution
	int bHasPrevious;
	for (int i=nOtherColumns.length()-1; i > -1;i--) 
		if (nOtherColumns[i]<nColumn)
		{ 
			 if(tslsRow[i].map().getInt("ReactOnOther") ==true || _Map.getInt("bAutoReact"))
				bHasPrevious = true;
			break;
		}


// flag if this needs to maintain the distributrion to the next in row
	TslInst tslOther;
	for (int i=0;i<tslsRow.length();i++) 
	{ 
		TslInst& tsl = tslsRow[i];
		
		if (!bDebug)
		{
			_Entity.append(tsl);
			setDependencyOnEntity(tsl);
		}

		double dX = vecX.dotProduct(tslsRow[i].ptOrg()-ptRef);
		if (dX>0)
		{ 
			 if(tsl.map().getInt("ReactOnOther")  || tsl.map().getInt("bAutoReact") )
				tslOther = tsl;
			break;
		}	
	}
	

// Trigger debug other tsl trigger
	if (bDebug)
	{
		String sTriggerDebug = "select debug other tsl";
		addRecalcTrigger(_kContext, sTriggerDebug);
		if (_bOnRecalc && _kExecuteKey==sTriggerDebug)
		{
			_Entity.append(getEntity());
			int n = _Entity.length();
			if (n>2)
				_Entity.swap(n, 1);
			setExecutionLoops(2);
			return;
		}
		if (_Entity.length()>1)
			tslOther = (TslInst)_Entity[1];
	}//endregion
	
//region get bounding pline of special and align in parent column
	PLine plTile(vecZ);
	int bIsInHalfColumn, bIsLeftAligned=true;
	double dWidthTile=dWidth, dWidthColumn=dWidth, dWidthNextColumn;
	Point3d pt1, pt2, ptA1, ptA2; // grid locations
	LineSeg seg;

// Boolean to allow position of tiles. The staggered distribution is desided by the half tile width as long as no other information are given
	int bHasValidPos = true;
		
// The right side point of the special tile 		
	Point3d ptLoc;
	
// counter of full and half tiles
	int nNumFull2Remove, nNumHalf2Remove;
	
			
	if (ptsX.length()>0 && ptsY.length()>0)
	{
		pt1 = Line(ptsY[1], vecX).intersect(Plane(ptsX[0], vecX), 0);	pt1.vis(5);
		pt2 = Line(ptsY[0], vecX).intersect(Plane(ptsX[1], vecX), 0); 	pt2.vis(4);
		dWidthColumn = vecX.dotProduct(pt2 - pt1);
		ptA1=pt1;
		ptA2=pt2;
		
//		Point3d ptPos = ppPositioning.closestPointTo(pt1); ptPos.vis(6);
		CoordSys csPositioning = ppPositioning.coordSys();
		Plane pnPositioning (csPositioning.ptOrg(), csPositioning.vecZ());
		Point3d ptPos = pt1.projectPoint(pnPositioning,0); 
		
	// Default tile is left aligned
		if(bIsHalf)
			ptLoc = ptPos + vecX * (dColumnWidth - dAvHalf);
		else
			ptLoc = ptPos + vecX * dColumnWidth;

		ptLoc.vis(2);
		
	// identify half/full width of special tile
		bIsInHalfColumn = dWidthColumn < 0.9 * dStandardWidth;
		dWidthTile = dWidthColumn;	
		
		if(!bCanBeStaggered && !bIsInHalfColumn && bIsHalf)
		{
			bHasValidPos = false;
			reportMessage("\n" + T("|Invalid location or tile type.|") + " " + T("|Tool will be deleted.|"));					
		}
		
			
	// half width special
		if (bIsHalf)
		{ 
			if(!bIsInHalfColumn)
				dWidthTile= dAvHalf;
			
			ptA2= ptA1+vecX*dWidthTile+vecY*vecY.dotProduct(ptA2-ptA1);
			seg = LineSeg(ptA1, ptA2); 
		}
		

	// full width special tile	
		else
		{
			if (!bCanBeStaggered && bIsInHalfColumn)
			{
				bHasValidPos = false;
				reportMessage("\n" + T("|Invalid location or tile type.|") + " " + T("|Tool will be deleted.|"));					
			}
			
		// full width special tile in half column
			if (bIsInHalfColumn)
			{				
				if (nColumn<ptsHGrid.length()-2)
				{
					dWidthNextColumn = vecX.dotProduct(ptsHGrid[nColumn + 2] - ptsHGrid[nColumn + 1]);
					dWidthTile+= .5*dWidthNextColumn;
				}
				else 
					dWidthTile *= 2;
				ptA2 = ptA1 + vecX * dWidthTile + vecY * vecY.dotProduct(pt2 - pt1);	
			}
			seg = LineSeg(ptA1, ptA2);	
		}

		
	// allow tiles to be placed in half line positions	
		if(bCanBeStaggered)
		{				
		// align left right
			double d1 = abs(vecX.dotProduct(ptRef - pt1));
			double d2 = abs(vecX.dotProduct(ptRef - pt2));	

			if(bInStaggeredRow)
			{
				d1 -= dDistance;
				d2 -= dDistance;
			}

		// right aligned
			if (d1 > d2 && !bIsInHalfColumn && !bIsHalf)
			{
				Vector3d vec = vecX * (vecX.dotProduct(ptA2 - ptA1) - dAvHalf);
				ptA1.transformBy(vec);
				ptA2.transformBy(vecX * dAvHalf);
				seg = LineSeg(ptA1, ptA2);	
				dWidthTile = vecX.dotProduct(ptA2 - ptA1);

				if(bIsHalf)
					ptLoc = ptA1 + 1 * vecX*dAvHalf;
				else
					ptLoc = ptA1 + 2 * vecX*dAvHalf;				
			}	
			else
				bIsLeftAligned = false;
		}
			
	// draw tile name
		if (dTxtH>0)
		{ 
			Vector3d vecXRead = seg.ptEnd() - seg.ptStart(); 
			
			vecXRead.normalize();
			if (csErp.vecX().dotProduct(seg.ptEnd() - seg.ptStart())<0)vecXRead *= -1;
			Vector3d vecYRead = vecXRead.crossProduct(-_ZW);
			
		// Invalid location. Tiles are colored green and additional text is drawn
			if(!bHasValidPos)
			{
				dpPlan.color(6);
				dpPlan.textHeight(2 * dTxtH);
				dpModel.textHeight(2 * dTxtH);
			
				ptA2= ptA1+vecX*dWidth+vecY*vecY.dotProduct(ptA2-ptA1);
				seg = LineSeg(ptA1, ptA2);
				
				dpModel.draw(T("|Invalid location|"), seg.ptMid()+vecY*2*dTxtH-vecX*2*dTxtH, vecXRead, vecYRead, 0,0);	
				dpPlan.draw(T("|Invalid location|"), seg.ptMid()+vecY*2*dTxtH-vecX*2*dTxtH, vecXRead, vecYRead, 0,0);	
				dpPlan.textHeight(dTxtH);
				dpModel.textHeight(dTxtH);	
			}

			dpModel.color(ncText);
			dpModel.draw(sSpecialTile, seg.ptMid(), vecXRead, vecYRead, 0,0);			
			vecXRead = vecXRead.crossProduct(_ZW).crossProduct(-_ZW);
			vecXRead.normalize();
			vecYRead = vecXRead.crossProduct(-_ZW);
			dpPlan.color(ncText);
			dpPlan.draw(sSpecialTile, seg.ptMid(), vecXRead, vecYRead, 0,0);
		}

	// draw special tile
		plTile.createRectangle(seg, vecX, vecY);	
		dpPlan.color(ncSpecial);dpModel.color(ncSpecial);
		
		if(!bHasValidPos)
			dpPlan.color(181);
		{ 
			PlaneProfile ppTile(plTile);
			ppTile.intersectWith(ppPositioning);
			
			if(ppTile.area() > U(50))
			{
				if (ntSpecial>0 && ntSpecial<100)
				dpPlan.draw(ppTile, _kDrawFilled, ntSpecial);
				dpPlan.draw(ppTile);
				dpModel.draw(ppTile);	
				
				double dUsedWidth = abs(vecX.dotProduct(seg.ptEnd() - seg.ptStart()));
				if(dAvHalf + dEps < dUsedWidth)
					nNumFull2Remove++;
			}	
			
		// Store position of special tile, so additional half tiles at the verges can react on them
			_Map.setPlaneProfile("ppSpecial", ppTile);
		}


		if (_bOnDebug)
		{
			dpPlan.draw("Row: " + nRow + " Column: " + nColumn, seg.ptMid(), vecX, vecY, 0,-3);
			
		}
	// publish tile contour to enable collision check with identical grid location
	if(plTile.area() > dEps)
		_Map.setPLine("plTile", plTile);		
	}


// distribute full tiles to next
	if (tslOther.bIsValid() && bHasValidPos)
	{ 	
		
	// get data of second tile
		dpPlan.color(ncStandard);dpModel.color(ncStandard);
		Map m = tslOther.map();
		int bIsLeftAligned2 = m.getInt("isLeftAligned");
		int bIsInHalfColumn2 = m.getInt("isInHalfColumn");
		int nColumn2 = m.getInt("column");	
		LineSeg segB = PlaneProfile(m.getPLine("plTile")).extentInDir(vecX);
		double dXB = abs(vecX.dotProduct(segB.ptStart()-segB.ptEnd()));
		Point3d ptB1 = segB.ptMid()-vecX*.5*dXB;
		Point3d ptB2 = segB.ptMid()+vecX*.5*dXB;

		double dWidthColumn2 = vecX.dotProduct(ptsHGrid[nColumn2+1] - ptsHGrid[nColumn2]);

		int bIsHalf2;
		if (dStandardWidth >0 && dXB>0 && dXB<0.9*dStandardWidth)
			bIsHalf2 = true;

	// interdistance
		double dInterdistance = abs(vecX.dotProduct(ptB1 - ptA2));
		int nNum;
		if (dStandardWidth>0)
			nNum = dInterdistance / dColumnWidth+.99;

	// evaluate if an additional half tile is required inbetween
		double dFillGap = dInterdistance - nNum * dWidthColumn;//dStandardWidth;
		int bAddHalfTile = abs(dFillGap) > .25 * dWidthColumn && abs(dFillGap) < .6 * dWidthColumn;//dStandardWidth;
	
	// do not add half tile if the tile is half and right aligned of a distribution
		if (bHasPrevious && !bIsLeftAligned && bIsHalf)
			bAddHalfTile = false;
		
		
	// If more special tiles are in one line, the gap is filled with as many full tiles as possible
		if(bCanBeStaggered && bReactOnOther)
		{		
		// Avoid overlaping
			if(vecX.dotProduct(ptB1-ptLoc) < -dEps)
			{
				if (_kNameLastChangedProp=="_Pt0")
				{
				// reset to previous location
					Point3d ptPrev = _PtW+_Map.getVector3d("vecOrg");

						reportMessage("\n" + T("|Tile cannot be moved to this location.|"));
						_Pt0=ptPrev;
						setExecutionLoops(2);
						return;				 	
				}					
			}
			
			
			Point3d ptLoc1 = ptLoc;
			ptLoc1 += vecY * vecY.dotProduct(pt1 - ptLoc1);
			Vector3d vecDistance = (ptB1 - ptLoc1); 	
			double dDistance =abs(vecX.dotProduct(vecDistance));
			int nFullTiles = (dDistance + dEps) / dColumnWidth;
			double dRest = dDistance - nFullTiles * dColumnWidth;
			
		// Find out if half tiles are in the distance. If, the half tile is not taken into count
			int nHalfColumns;
			for(int i=0; i < ptsHalfColumns.length(); i++)
			{
				if(vecX.dotProduct(ptB1 - ptsHalfColumns[i]) > 0 && vecX.dotProduct(ptsHalfColumns[i] - ptLoc1) > 0 )
					nHalfColumns ++;
			}

	
		// distribute full tiles
			if ((nFullTiles>0 || dRest > U(20)))
			{ 	
				PLine plX;				
				int nNoHalf;
	
				for (int i=0; i < nFullTiles; i++) 
				{ 	
					double dX = dColumnWidth;
					LineSeg segX(ptLoc1, ptLoc1 + vecX * dX + vecY * vecY.dotProduct(pt2 - ptLoc1)); 
					plX.createRectangle(segX, vecX, vecY);	
					PlaneProfile ppTile(plX);
					if (ntHalf>0 && ntHalf<100)
						dpPlan.draw(ppTile, _kDrawFilled, ntSpecial);
					dpPlan.draw(ppTile);						
					ptLoc1.transformBy(vecX * dX);
				}	
					
				if(dRest > U(20))
				{					
					LineSeg segX(ptLoc1, ptLoc1 + vecX * dRest + vecY * vecY.dotProduct(pt2 - ptLoc1)); 
					plX.createRectangle(segX, vecX, vecY);	
					PlaneProfile ppTile(plX);
					if (ntHalf>0 && ntHalf<100)
						dpPlan.draw(ppTile, _kDrawFilled, ntSpecial);
					dpPlan.draw(ppTile);
					if(dRest < 0.9 * dColumnWidth)
						dpPlan.draw(segX);
						
					if(nHalfColumns%2 ==0)
						nNumHalfTile++;
				}
			}			
		}
	}
	
	
// Trigger fillHalfs
	int bFillHalfs = true;
	if(_Map.hasInt("fillHalfs"))
		bFillHalfs = _Map.getInt("fillHalfs");
	String sTriggerfillHalfs =bFillHalfs? T("|Don`t add half tile|"):T("|Add half tile|");
	addRecalcTrigger(_kContext, sTriggerfillHalfs);
	if (_bOnRecalc && _kExecuteKey==sTriggerfillHalfs)
	{
		bFillHalfs = bFillHalfs ? false : true;
		_Map.setInt("fillHalfs", bFillHalfs);		
		setExecutionLoops(2);
		return;
	}
	

// Fall through to create additional halftiles
	int nEnd = 0;
	int nStart = 0;
	
// Change bHasValidPos if tile is in staggered row
	if(!bFirstRow)
		bIsLeftAligned = (bIsLeftAligned) ? false : true;

	
	if(bHasValidPos && bFillHalfs)
	{	
	// Half tile at the left side of a full column
		if (bIsHalf && !bIsInHalfColumn && bIsLeftAligned && !tslOther.bIsValid())
		{
			nStart = 1;
			nEnd = 2;
			nNumFull2Remove++;
		}

	
	// Half tile at the right side of a full column
		else if (bIsHalf && !bIsInHalfColumn && !bIsLeftAligned && !bHasPrevious )
		{
			nStart = 0;
			nEnd = 1;
			nNumFull2Remove++;
		}
		
	// Full tile in half column and no other tiles at the right side
		if(bIsFull && bIsInHalfColumn)
		{
			if(bIsLeftAligned && !tslOther.bIsValid())
			{
				nStart = 1;
				nEnd = 2;				
			}
				
			if(!bIsLeftAligned && !bHasPrevious)
			{
				nStart = 0;
				nEnd = 1;				
			}
			nNumFull2Remove++;
			nNumHalf2Remove++;
		}

	// append additional half tiles to full tile
		 if (bIsFull && !bIsInHalfColumn && !bIsLeftAligned)
		 { 
			if(!tslOther.bIsValid() || !bReactOnOther)
			{
				nEnd = 2;				
			}
			else
				nEnd = 1;
				
			if(bHasPrevious )
				nStart = 1;
	
			double dColumnWidth1 = vecX.dotProduct(ptsHGrid[nColumn + 2] - ptsHGrid[nColumn + 1]);
			if(dColumnWidth1 < 0.52 * dWidthColumn)
			{
				nStart = (bHasPrevious )? 1:0;
				nEnd = 1;
				nNumHalf2Remove++;
			}
			
			if(nEnd - nStart == 2)
				nNumFull2Remove ++;	
			else if(bHasPrevious && nNumHalfTile == 1)
				nNumFull2Remove ++;	
			else if(bHasPrevious && (nEnd - nStart == 1))
				nNumFull2Remove ++;	
			else if(!bHasPrevious && (nEnd - nStart == 1) && nNumHalfTile)
				nNumFull2Remove ++;	
			
		}

		double dX = dAvHalf;
		PLine plX;	
	
	// Add half tile(s) left or/and right	
		if (dX>0)
		{		
			ptLoc += vecY * vecY.dotProduct(pt1 - ptLoc);
			
			for(int i=nStart; i< nEnd; i++)
			{
				LineSeg segX(ptLoc, ptLoc + vecX * dX + vecY * vecY.dotProduct(pt2 - ptLoc)); 

				plX.createRectangle(segX, vecX, vecY);
				if(i==0)
				{
					segX.transformBy(-vecX * (dWidthTile + vecX.dotProduct(segX.ptEnd() - segX.ptStart())));
					plX.transformBy(-vecX * (dWidthTile + vecX.dotProduct(segX.ptEnd() - segX.ptStart())));
				}

				dpPlan.color(ncHalf);dpModel.color(ncHalf);
				PlaneProfile ppTile(plX); 
				double dArea = ppTile.area()-dEps;
				ppTile.intersectWith(ppPositioning);
				
				if (ppTile.area() < U(50)) continue;
				
				if (ntHalf>0 && ntHalf<100)
					dpPlan.draw(ppTile, _kDrawFilled, ntHalf);					

				dpPlan.draw(ppTile);
			// Avoid drawing the diagonale if the half tile is cutted
				if(dArea < ppTile.area())
					dpPlan.draw(segX);	
				nNumHalfTile++;		
			}
		}			
	}
	
// a single  half tile	
	if(bIsHalf && bIsInHalfColumn)
		nNumHalf2Remove++;		
	

// Hardware//region
// collect existing hardware
	HardWrComp hwcs[] = _ThisInst.hardWrComps();
	
// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
	for (int i=hwcs.length()-1; i>=0 ; i--) 
		if (hwcs[i].repType() == _kRTTsl)
			hwcs.removeAt(i); 

// declare the groupname of the hardware components
	String sHWGroupName;
	// set group name
	{ 
	// element
		// try to catch the element from the parent entity
		Element elHW =erp.element(); 
		// check if the parent entity is an element
		if (!elHW.bIsValid())
			elHW = (Element)erp;
		if (elHW.bIsValid()) 
			sHWGroupName=elHW.elementGroup().name();	
	// loose
		else
		{
			Group groups[] = _ThisInst.groups();
			if (groups.length()>0)
				sHWGroupName=groups[0].name();
		}		
	}
	
// add main componnent
	if (mapTile.length()>0)
	{ 
		HardWrComp hwc(mapTile.getString("ArticleNumber"), 1); // the articleNumber and the quantity is mandatory
		
		hwc.setManufacturer(mapManufacturer.getString("Manufacturer"));		
		hwc.setModel(sFamilyName);
		hwc.setName(mapTile.getString("Name"));
		hwc.setMaterial(mapFamilyDefinition.getString("Characteristic\Surface") + " " + mapFamilyDefinition.getString("Characteristic\Colour"));
		hwc.setNotes(erp.roofNumber());	
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(erp);	
		hwc.setCategory(T("|Rooftiles|"));
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components	
		hwc.setDScaleX(mapTile.getDouble("Length"));
		hwc.setDScaleY(mapTile.getDouble("Width"));
		hwc.setDScaleZ(0);
		hwc.setDAngleA(dPitch);

		
	// apppend component to the list of components
		hwcs.append(hwc);	
	}
	
		
// add sub componnent: potential half tile
	if (nNumHalfTile>0)
	{ 
		Map m = mapHalfTile;
		HardWrComp hwc(m.getString("ArticleNumber"), nNumHalfTile); // the articleNumber and the quantity is mandatory
		
		hwc.setManufacturer(mapManufacturer.getString("Manufacturer"));	
		hwc.setModel(sFamilyName);
		hwc.setName(m.getString("Name"));
		hwc.setMaterial(mapFamilyDefinition.getString("Characteristic\Surface") + " " + mapFamilyDefinition.getString("Characteristic\Colour") );
		hwc.setNotes(erp.roofNumber());	
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(erp);	
		hwc.setCategory(T("|Rooftiles|"));
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components	
		hwc.setDScaleX(m.getDouble("Length"));
		hwc.setDScaleY(m.getDouble("Width"));
		hwc.setDScaleZ(0);
		hwc.setDAngleA(dPitch);
		
	// apppend component to the list of components
		hwcs.append(hwc);

	}	

// make sure the hardware is updated
	if (_bOnDbCreated)
		setExecutionLoops(2);
				
	_ThisInst.setHardWrComps(hwcs);	
	//endregion


// show debug data
	if (0 && bDebug)
	{		
		Point3d ptTxt = _Pt0 + vecX * U(1000);
		dpPlan.draw(sFamilyName,ptTxt , vecX, vecY, .9,0);	
		
		double dYFlag =-3;

		dpPlan.color(43);
		dpPlan.draw(sNodeRoofTileWithFamily ,ptTxt , vecX, vecY, 0.9,dYFlag);
		dYFlag-=3;
		dpPlan.color(252);

		
		for (int i=0;i<nTileTypes.length();i++)
		{
		// get tile data from database
			mapIn.setInt("TileType",nTileTypes[i]);     
			Map mapOut= callDotNetFunction2(strAssemblyPath, strType, strFunction, mapIn);	
			Map mapTiles = mapOut.getMap(sNodeRoofTileWithFamily);

			if (mapTile.length()<1)continue;
			dpPlan.draw(mapTiles .getInt("TileType")+ ": " +mapTiles .getString("Name") + " dX=" +mapTiles .getDouble("Width") + " Max:" +mapTiles.getMap("HorizontalTileSpacing").getDouble("Maximum"),ptTxt, vecX, vecY, 1,dYFlag);		
			dYFlag-=3;	
		}
	}

// store previous location
	_Map.setVector3d("vecOrg", _Pt0-_PtW);

// publsih tile map of this special tile
	_Map.setMap("RoofTile", mapTile);
	_Map.setInt("row", nRow);
	_Map.setInt("column", nColumn);
	_Map.setInt("isHalf", bIsHalf);
	_Map.setInt("isHalfColumn", bIsInHalfColumn);
	_Map.setInt("isLeftAligned", bIsLeftAligned);
	
// Add tiles to subtract from amount of hsbTileGrid
	Map mapTilesToSubtract;
	mapTilesToSubtract.setInt("FullTile", nNumFull2Remove);
	mapTilesToSubtract.setInt("HalfTile", nNumHalf2Remove);
	_Map.setMap("TilesToSubtract", mapTilesToSubtract);	

	


#End
#BeginThumbnail
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
G!R=S8:[JFU;E45%.0"5`'Y<UTEG"UO900,06CC"DCIP*L44`?__9
`



















#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-16994: Avoid version error message" />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="11/8/2022 12:36:44 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End