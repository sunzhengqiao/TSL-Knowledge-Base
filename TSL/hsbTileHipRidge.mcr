#Version 8
#BeginDescription
 This tsl creates instances per hip- and/or ridge line and computes the quantity of the required tiles.
 Pent and ridge connection tiles are created if required. 
Select at least two roofplane to create hip / ridge tiles. 

version value="2.7" date="23jul23" author="nils.gregor@hsbcad.com">HSB-19266: Updated tile type numbers".
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 7
#KeyWords 
#BeginContents
/// <History> //region
///<version value="2.7" date="23jul23" author="nils.gregor@hsbcad.com">HSB-19266: Updated tile type numbers"</version>
///<version value="2.6" date="08nov22" author="nils.gregor@hsbcad.com">Avoid version error message"</version>
///<version value="2.5" date="23may19" author="nils.gregor@hsbcad.com">Adjust ridge direction if alligned to _XW or _YW"</version>
///<version value="2.4" date="20may19" author="nils.gregor@hsbcad.com">Added surface to the colour"</version>
///<version value="2.3" date="16apr19" author="nils.gregor@hsbcad.com">changed behavior of pent tiles for "Can be staggered"</version>
///<version value="2.2" date="15apr19" author="nils.gregor@hsbcad.com">bugfix behavior of pent tiles</version>
///<version value="2.1" date="05apr19" author="nils.gregor@hsbcad.com">Bugfix</version>
///<version value="2.0" date="05apr19" author="nils.gregor@hsbcad.com">Elementary changes in the behavior of the instance. Initial version for release V22</version>
/// <version value="1.3" date="27jun2018" author="thorsten.huck@hsbcad.com"> RS-52, connecting tiles added </version>
/// <version value="1.2" date="22jun2018" author="thorsten.huck@hsbcad.com"> RS-108, RS-109, RS-110, RS-111 </version>
/// <version value="1.1" date="13jun2018" author="thorsten.huck@hsbcad.com"> new properties offset start / end added. Ridge/Hip shortening by offset definition of neighbouring segments</version>
/// <version value="1.0" date="12jun2018" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select roofplanes with tile data assigned, select properties or catalog entry and press OK
/// Select at least two roofplane to create hip / ridge tiles. 
/// </insert>

/// <summary Lang=en>
/// This tsl creates instances per hip- and/or ridge line and computes the quantity of the required tiles.
/// Pent and ridge connection tiles are created if required. 
/// Select at least two roofplane to create hip / ridge tiles. 
/// </summary>


//endregion

// constants //region
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=false;//_bOnDebug;
	bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));	
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	//endregion

// Properties //region
	String strAssemblyPath = _kPathHsbInstall+"\\Utilities\\RoofTiles\\RoofTilingManager.dll";  
	String strType = "hsbCad.Roof.TilingManager.Editor";
	String strFunction = "GetTiles";    
	String sNodeRoofTileWithFamily = "RoofTile[]\\RoofTile";
	
	String sDefaultEntries[] ={ T("|No Tile|"), T("|ByRoofplane|")};
	String sDefaultStartEndEntries[] ={ T("|No Tile|")};
	String sRidgeTiles[0]; sRidgeTiles = sDefaultEntries;
	String sRidgeTileName=T("|Ridge/Hip Tile|");	
	PropString sRidgeTile(nStringIndex++, sRidgeTiles, sRidgeTileName,1);	
	sRidgeTile.setDescription(T("|Specifies the ridge/hip tile|"));
	sRidgeTile.setCategory(category);

	category = T("|Start Tile|");
	String sStartTiles[0]; sStartTiles = sDefaultStartEndEntries;
	String sStartTileName=T("|Start Tile|");	
	PropString sStartTile(nStringIndex++, sStartTiles, sStartTileName,1);	
	sStartTile.setDescription(T("|Specifies the start tile|"));
	sStartTile.setCategory(category);

	String sStartOffsetName=T("|Offset|");	
	PropDouble dStartOffset(nDoubleIndex++, U(0), sStartOffsetName);	
	dStartOffset.setDescription(T("|Defines the start offset of the ridge/ hip tiles|"));
	dStartOffset.setCategory(category);

	category = T("|End Tile|");
	String sEndTiles[0]; sEndTiles = sDefaultStartEndEntries;
	String sEndTileName=T("|End Tile|");	
	PropString sEndTile(nStringIndex++, sEndTiles, sEndTileName,1);	
	sEndTile.setDescription(T("|Specifies the end tile|"));
	sEndTile.setCategory(category);

	String sEndOffsetName=T("|Offset| ");
	PropDouble dEndOffset(nDoubleIndex++, U(0), sEndOffsetName);	
	dEndOffset.setDescription(T("|Defines the end offset of the ridge/ hip tiles|"));
	dEndOffset.setCategory(category);
	
	category = T("|Replace tile|");
	String sOverwrites[] = { T("|Don´t replace|"), T("|Start Tile|"), T("|End Tile|")};
	String sOverwriteName=T("|Replace Start/ End Tile|");	
	PropString sOverwrite(nStringIndex++, sOverwrites, sOverwriteName,0);	
	sOverwrite.setDescription(T("|Replace the start/ end tile with selected tile(s)|"));
	sOverwrite.setCategory(category);	
	int nOverwrite = sOverwrites.find(sOverwrite);
	if (nOverwrite < 0) nOverwrite = 0;
	
	String sAllTiles[0]; sAllTiles = sDefaultStartEndEntries;
	String sAllTileName=T("|1st Start/ End Tile|");	
	PropString sAllTile(nStringIndex++, sAllTiles, sAllTileName);	
	sAllTile.setDescription(T("|Used to replace the first start/ end tile|"));
	sAllTile.setCategory(category);
	
	String sAllTile2s[0]; sAllTile2s = sDefaultStartEndEntries;
	String sAllTile2Name=T("|2nd Start/ End Tile|");	
	PropString sAllTile2(nStringIndex++, sAllTile2s, sAllTile2Name);	
	sAllTile2.setDescription(T("|Used to add a second start/ end tile|"));
	sAllTile2.setCategory(category);
	
	category = T("|Geometrie|");
	String sOffsetDirs[] = { T("|Parallel to edge|"), T("|Parallel to roofplane|")};
	String sOffsetDirName=T("|Offset direction|");	
	PropString sOffsetDir(nStringIndex++, sOffsetDirs, sOffsetDirName);	
	sOffsetDir.setDescription(T("|Defines the direction of the offset|"));
	sOffsetDir.setCategory(category);	
			
	String sRidgeOffsetName=T("|Z-Offset ridge|");	
	PropDouble dRidgeOffset(nDoubleIndex++, U(80), sRidgeOffsetName);	
	dRidgeOffset.setDescription(T("|Defines the ridge offset|"));
	dRidgeOffset.setCategory(category);
		
	String sHipOffsetName=T("|Z-Offset hip|");	
	PropDouble dHipOffset(nDoubleIndex++, U(130), sHipOffsetName);	
	dHipOffset.setDescription(T("|Defines the hip offset|"));
	dHipOffset.setCategory(category);


	String sPropNames[] = { sRidgeTileName,sStartTileName,sEndTileName};

// properties by settings
	int nc,ncText = 7, ncRidge = 134, ncStart = 44, ncEnd=244,ncRidgeConnection=62, ncRidgeConnectionHalf=142;// colors
	int nt,ntRidge = 70, ntStart = 70, ntEnd = 70,ntRidgeConnection=95,ntRidgeConnectionHalf=95;// transparency

//endregion

	// bOnInsert //region
	if (_bOnInsert)
	{
		if (insertCycleCount() > 1) { eraseInstance(); return; }
			
		// prompt for rps
		PrEntity ssErp(T("|Select roofplane(s)|"), ERoofPlane());
		if (ssErp.go())
			_Entity.append(ssErp.set());
	}
	
	// query roofplanes
	// get potential family definition
		Map mapFamilyDefinition;
		
		for (int i=0;i<_Entity.length();i++) 
		{ 
			ERoofPlane rp = (ERoofPlane)_Entity[i]; 
			if (!rp.bIsValid())continue;
			mapFamilyDefinition = rp.subMapX("Hsb_RoofTile").getMap("RoofFamilyDefinition");
			if (mapFamilyDefinition.hasMap("RoofTileFamily")) break;
		}
		
	// Get family data //region
		if (mapFamilyDefinition.length()<1)
		{
			reportMessage("\n" + _ThisInst.opmName() + " " + T("|could not find valid roof tile data.|") + T("|Please make sure the rp has a roof tile style assigned.|") +
			T("|The tool will be deleted.|"));
			eraseInstance();
			return;
		}
	
	// Get family data
		Map mapFamily = mapFamilyDefinition.getMap("RoofTileFamily");
		String sFamilyId = mapFamily.getString("Id");	
		Map mapManufacturer = mapFamilyDefinition.getMap("StandardRoofTile\\ManufacturerData");
		String sManufacturerId = mapManufacturer.getString("Id");
		int nDistribution = mapFamily.getInt("TileDistribution");
		String sFamilyName = mapFamily.getString("FamilyName");	
		String sManufacturer=mapManufacturer.getString("Manufacturer");
		String sFamilyCharacteristic = mapFamilyDefinition.getString("Characteristic\Surface") + " " + mapFamilyDefinition.getString("Characteristic\Colour");
		_Map.setInt("nDistribution", nDistribution);
		
	// collect ridge/hip and start and end tiles
	// Collect data from database
		int nTiles[] ={6,8,9, 4,5,12,13,25,26};// Ridge, RidgeStart, RidgeEnd	

		String sRidgesNames[0], sStartNames[0], sEndNames[0], sOverwriteNames[0];
	// prerequisites to read database
		Map mapIn;
		mapIn.setString("ManufacturerId",sManufacturerId);
		mapIn.setString("RoofTileFamilyId",sFamilyId);
		
		double dWidth;
		
		Map mapVergeRidge, mapVergePent, mapRidgeTiles, mapStartTiles, mapEndTiles, mapOverwrites ;
		
	// get tile data from database
		for (int t=0;t<nTiles.length();t++) 
		{ 						
			mapIn.setInt("TileType",nTiles[t]); 
			Map mapOut= callDotNetFunction2(strAssemblyPath, strType, strFunction, mapIn);
			Map mapFamilyTiles = mapOut.getMap("RoofTile[]");		
			if (mapFamilyTiles.length() < 0) continue;
			String sNames[0];
			Map mapTiles;
			
			if(t > 2 && t <7)
			{
				mapVergeRidge.appendMap("mapFamiliyTiles",mapFamilyTiles);	
			}
			
			else if(t > 6)
			{
				mapVergePent.appendMap("mapFamiliyTiles",mapFamilyTiles);	
			}

			else if(t < 3)
			{
				for (int m=0;m<mapFamilyTiles.length() ;m++)
				{
					Map mapTile = mapFamilyTiles.getMap(m);
					String sName = mapTile.getString("Name");
				
					 if (sName.length()>0 && sNames.find(sName)<0)
					{
						sNames.append(sName);
						mapTiles.appendMap("Tile",mapTile);
						if(t>0)
						{
							mapOverwrites.appendMap("Tile",mapTile);
							sOverwriteNames.append(sName);
						}
					}
				}
				if (t == 0)
				{
					mapRidgeTiles = mapTiles;
					sRidgesNames = sNames;
					dWidth = mapTiles.getDouble("Tile\\Width");
				}
				else if (t == 1)
				{
					mapStartTiles = mapTiles;
					sStartNames = sNames;
				}
				else if (t == 2)
				{
					mapEndTiles = mapTiles;	
					sEndNames = sNames;
				}		
			}
		}	
		
		_Map.setMap("mapVergeRidge", mapVergeRidge);
		_Map.setMap("mapVergePent", mapVergePent);
		

	// Redeclare tile properties		
		nStringIndex=0;
		sRidgeTiles.append(sRidgesNames);
		sRidgeTile=PropString(nStringIndex++, sRidgeTiles, sRidgeTileName);	
		if (sRidgeTiles.find(sRidgeTile) < 0 && sRidgeTiles.length() > 0)sRidgeTile.set(sRidgeTiles[sRidgeTiles.length()-1]);

		sStartTiles.append(sStartNames);
		sStartTile=PropString(nStringIndex++, sStartTiles, sStartTileName);	
		if (sStartTiles.find(sStartTile) < 0 && sStartTiles.length() > 0)sStartTile.set(sStartTiles[sStartTiles.length()-1]);

		sEndTiles.append(sEndNames);
		sEndTile=PropString(nStringIndex++, sEndTiles, sEndTileName);	
		if (sEndTiles.find(sEndTile) < 0 && sEndTiles.length() > 0)sEndTile.set(sEndTiles[sEndTiles.length()-1]);
			
		sOverwrite = PropString (nStringIndex++, sOverwrites, sOverwriteName,0);
		sAllTiles.append(sStartNames); sAllTiles.append(sEndNames);
		sAllTile = PropString (nStringIndex++, sAllTiles, sAllTile2Name);	
		sAllTile2s.append(sStartNames); sAllTile2s.append(sEndNames);		
		sAllTile2 = PropString (nStringIndex++, sAllTile2s, sAllTile2Name);	
		
	if(_bOnInsert)	
	{ 		
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
		else	 if(_Entity.length()>1)
			showDialog("---");
		
		return;
	}	
// end on insert	__________________//endregion

// Collect entities and set/get edges //region
// Get rps from entity
	ERoofPlane rps[0];
	for (int i=0;i<_Entity.length();i++) 
	{ 
		ERoofPlane rp = (ERoofPlane)_Entity[i]; 
		if (rp.bIsValid())
		{
			setDependencyOnEntity(rp);
			rps.append(rp);
		}
	}
	
// validate rp If only one roof exists it can be a single slooped roof with penttiles.
	if (rps.length()<1)
	{
		reportMessage("\n" + scriptName() + ": " +T("|no valid rps found|"));
		eraseInstance();
		return;	
	}//endregion
		
// Order by handle //region
	for (int i=0;i<rps.length();i++) 
		for (int j=0;j<rps.length()-1;j++) 
			if (rps[j].handle()>rps[j+1].handle())
				rps.swap(j, j + 1);//endregion


// Get relevant edges and edge type
	ERoofPlane& rp1 = rps[0];
	CoordSys cs1 = rp1.coordSys();
	Point3d ptOrg1 = cs1.ptOrg();
	Vector3d vecZ1 = cs1.vecZ();
	PLine plEnvelope1 = rp1.plEnvelope();	
	EdgeTileData edges1[] = rp1.edgeTileTopology();	
	String sHandle1 = rp1.handle();
	

// Prepare tsl cloning //region
	TslInst tslNew;
	Vector3d vecXTsl= _XE;		Vector3d vecYTsl= _YE;
	GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};
	Point3d ptsTsl[] = {};
	int nProps[]={};		double dProps[]={dStartOffset, dEndOffset, dRidgeOffset, dHipOffset};		String sProps[]={sRidgeTile,sStartTile,sEndTile, sOverwrite, sAllTile, sAllTile2, sOffsetDir};
	Map mapTsl = _Map;	
//endregion


// Create hip/ridge edges as 1 to 1 relation //region
	if (rps.length()>2)
	{ 	
	// get topology and find edges
		for (int j = 0; j < rps.length(); j++)
		{
			ERoofPlane& rp1 = rps[j];
			CoordSys cs = rp1.coordSys();
			EdgeTileData _edges[] = rp1.edgeTileTopology();

		// create per relevant edges
			for (int i = 0; i < _edges.length(); i++)
			{
				EdgeTileData edge = _edges[i];
				LineSeg seg = edge.segment();
				Vector3d vecXSeg = seg.ptEnd() - seg.ptStart();
				vecXSeg.normalize();

			// skip non ridge / hip edges
				int nType = edge.tileType();
				if (nType!=_kTileRidge && nType!=_kTileHip)continue;
	
			// skip single edges
				String sPartner = edge.partnerRoofplane().handle();
				if (sPartner.length() < 1)continue;
				
			// get partner and check if in sset
				ERoofPlane rp2;
				rp2.setFromHandle(sPartner);
				int n = rps.find(rp2);
				if (n < 0)continue;
				
			// check if partner is of higher priority / handle sequence
				if (n < j)continue;

				if (!vecXSeg.isPerpendicularTo(_ZW))//hip, turn of end tile
					sProps[2] = sDefaultEntries[0];
				else
					sProps[2] = sEndTile;

				ptsTsl.setLength(0);
				ptsTsl.append(seg.ptMid());
				
				entsTsl.setLength(0);
				entsTsl.append(rp1);
				entsTsl.append(rp2);

				if (!bDebug)
					tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);		
				else
				{
					Point3d pt1; pt1.setToAverage(rp1.plEnvelope().vertexPoints(true));
					Point3d pt2; pt2.setToAverage(rp2.plEnvelope().vertexPoints(true));		
					(PLine(pt1, pt2)).vis(i);
				}
			}
		}
		if (!bDebug)
			eraseInstance();
		return;
	}//endregion

// Avoid duplicates on same pair of roofplanes //region
	Entity ents[] = Group().collectEntities(true, TslInst(), _kModelSpace);
	for (int i=0;i<ents.length();i++) 
	{ 
		TslInst tsl = (TslInst)ents[i];
		if (tsl.bIsValid() && tsl.scriptName()==scriptName() && tsl!=_ThisInst)
		{ 
			Entity entRefs[] = tsl.entity();
		// ridge and hip style	
			if (entRefs.length()==2 && rps.length()>1 && entRefs.find(rps[0])>-1 && entRefs.find(rps[1])>-1)
			{ 
				if(bDebug)reportMessage("\n" + scriptName() + ": " +T("|removing duplicate...|"));
				eraseInstance();
				return;
			}			
		} 
	}//endregion
	
	
// Init Hardware //region
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
		Group groups[] = rps[0].groups();
		if (groups.length()>0)
			sHWGroupName=groups[0].name();
	}
	//endregion
	
	// Displays //region
	Display dpPlan(ncText);

//endregion	
	_ThisInst.setAllowGripAtPt0(FALSE);
	
// Check if single roof has a shed roof definition. Else erase Instance
	if(rps.length() ==1)
	{
		int bHasShedDef;
		Map mapEdges = rps[0].subMapX("Hsb_RoofEdgeTileData").getMap("EdgeTileData[]");
		for(int j=0; j < mapEdges.length(); j++)
		{
			int nRidgeType = mapEdges.getMap(j).getInt("RidgeDefinition\\RidgeTile\\TileType");
			if(nRidgeType ==23)
			{
				bHasShedDef = true;
				break;
			}
		}
		if(! bHasShedDef)
		{
			reportMessage(T("|Select minimum two roofplanes to create a ridge. Instance will be deleted|"));
			eraseInstance();
			return;		
		}
	}
	
	if(rps.length() > 1 )
	{
	// Export distances to hsbTileLath
		double dRidgeOffsetExport = dRidgeOffset;
		double dHipOffsetExport = dHipOffset;
//		double dWidth;
		
	// a second roofplane is only valid for ridges or hips.
		ERoofPlane rp2= rps[1];
		CoordSys cs2 = rp2.coordSys();
		Vector3d vecZ2 = cs2.vecZ();
		Point3d ptOrg2 = cs2.ptOrg();
		PLine plEnvelope2 = rp2.plEnvelope();
		EdgeTileData edges2[] = rp2.edgeTileTopology();
		
		int nRidgeTile = sRidgeTiles.find(sRidgeTile, 1);
		int nStartTile = sStartTiles.find(sStartTile);
		int nEndTile = sEndTiles.find(sEndTile);
		int nAllTile = sAllTiles.find(sAllTile);
		int nAllTile2 = sAllTile2s.find(sAllTile2);
		int nTypes[0] ;
		
		if(nOverwrite == 0)
		{
			 int n[] = {nRidgeTile, nStartTile, nEndTile};
			nTypes = n;			
		}
		else if (nOverwrite == 1)
		{
			nTypes.append(nRidgeTile);
			nTypes.append(nAllTile);
			nTypes.append(nAllTile2);
			nTypes.append(nEndTile);
		}
		else if (nOverwrite == 2)
		{
			nTypes.append(nRidgeTile);
			nTypes.append(nStartTile);
			nTypes.append(nAllTile);
			nTypes.append(nAllTile2);
		}
	
	// filter relevant edges or
		EdgeTileData edges[0];
		Vector3d vecDir;
		for (int i = 0; i < edges1.length(); i++)
		{
			EdgeTileData edge = edges1[i];
			LineSeg seg = edge.segment();
			Vector3d vecXSeg = seg.ptEnd() - seg.ptStart();
			vecXSeg.normalize();
	
		// skip non ridge / hip edges
			int nType = edge.tileType();
			if (nType!=_kTileRidge && nType!=_kTileHip)continue;
	
		// get partner handle
			String sPartner = edge.partnerRoofplane().handle();
		
		// skip shed edge 
			if (sPartner.length() < 1)
				continue;
	
		// get partner and check if in sset
			ERoofPlane _rp2;
			_rp2.setFromHandle(sPartner);
			int n = rps.find(_rp2);
			if (n < 0)continue;
			
		// this is a relevant edge
		LineSeg segTest = edge.segment();
		//segTest.vis(3);
			edges.append(edge);
			if (vecDir.bIsZeroLength())vecDir = vecXSeg;
			
			if(vecDir.isParallelTo(_XW))
				vecDir = -_XW;
			else if(vecDir.isParallelTo(_YW))
				vecDir = -_YW;
			
		}
			
	// validate amount of edges
		if (edges.length()<1)
		{ 
			if (rp2.bIsValid())reportMessage("\n" + scriptName() + ": " +T("|could not find any edge|"));
			eraseInstance();
			return;
		}//endregion
	
	// distinguish between ridge and hip//region
		int bIsRidge = vecDir.isPerpendicularTo(_ZW);
		// ridge direction may be swapped
		if (bIsRidge)
		{ 
		// TriggerFlipSide
			int bFlip = _Map.getInt("flip");
			String sTriggerFlipSide = T("|Flip Direction|");
			addRecalcTrigger(_kContext, sTriggerFlipSide );
			if (_bOnRecalc && (_kExecuteKey==sTriggerFlipSide || _kExecuteKey==sDoubleClick))
			{
				if (bFlip)bFlip=false;
				else bFlip=true;
				 _Map.setInt("flip",bFlip);
				setExecutionLoops(2);
				return;
			}
//			if (bFlip)vecDir *= -1;
		}
		// hip direction is always pointing to the ridge
		else if (vecDir.dotProduct(_ZW) < 0)
			vecDir *= -1;
		if (!bIsRidge)
			ncRidge = 154;
			
	// order edges along vecDir
		for (int i=0;i<edges.length();i++) 
			for (int j=0;j<edges.length()-1;j++) 
			{
				double d1 = vecDir.dotProduct(_Pt0 - edges[j].segment().ptMid());
				double d2 = vecDir.dotProduct(_Pt0 - edges[j+1].segment().ptMid());
				if (d1<d2)
					edges.swap(j, j + 1);
			}
		//endregion	
	
	
	// Get the relevant tile maps//region
	// Ridge/hip tile
		Map mapRidgeTile;
		// by roofplane
		if (nRidgeTile==1)
		{ 
		// find tile definition in edge of roofplane 1
			for (int i=0;i<edges.length();i++) 
			{ 
			// get edge	
				EdgeTileData& edge = edges[i];
				Map mapTiles = edge.tileMap().getMap("RoofTile[]");
			// search first appearance of a ridge tile	
				for (int j=0;j<mapTiles.length();j++) 
				{ 
					Map m = mapTiles.getMap(j);
					if (m.getInt("TileType")==6)
					{
						mapRidgeTile = m;
						break;
					}
				}		
				if (mapRidgeTile.length()>0)	break;
			}
		// if nothing could be found in first plane, try to find one in roofplane 2
			if (mapRidgeTile.length()<1)
				for (int i=0;i<edges2.length();i++) 
				{ 
				// get edge	
					EdgeTileData& edge = edges2[i];
					
				// get partner and check if roofplane 1
					if (sHandle1!=edge.partnerRoofplane().handle())continue;
					
					Map mapTiles = edge.tileMap().getMap("RoofTile[]");
				// search first appearance of a ridge tile	
					for (int j=0;j<mapTiles.length();j++) 
					{ 
						Map m = mapTiles.getMap(j);
						if (m.getInt("TileType")==6)
						{
							mapRidgeTile = m;
							break;// break j
						}
					}		
					if (mapRidgeTile.length()>0)	break;//break i
				}
		// if no tile could be found fall back to the first found
			if (mapRidgeTile.length()<1 && sRidgeTiles.length() > 2)
			{ 
				reportMessage("\n" + scriptName() + ": " +(bIsRidge?T("|no ridge tile specified| "):T("|no hip tile specified| "))+ T("|on this edge while the property is set to byRoofplane.|") + T(" |Using first tile of family definition instead.|"));
				mapRidgeTile = mapRidgeTiles.getMap(0);
				sRidgeTile.set(sRidgeTiles[2]);
			}		
		}
		// by property selected
		else if (nRidgeTile>1)
		{ 
			mapRidgeTile = mapRidgeTiles.getMap(nRidgeTile-2); 
		}
		
	// start tile
		Map mapStartTile;
		if (nStartTile>0)
			mapStartTile = mapStartTiles.getMap(nStartTile-1); 
	
	// end tile
		Map mapEndTile;
		if (nEndTile>0)
			mapEndTile = mapEndTiles.getMap(nEndTile-1); 	
			
	// overwrite tile
		Map mapOverwrite;
		if(nAllTile > 0)
			mapOverwrite = mapOverwrites.getMap(nAllTile - 1);
			
	// overwrite tile2
		Map mapOverwrite2;
		if(nAllTile2 > 0)
			mapOverwrite2 = mapOverwrites.getMap(nAllTile2 - 1);			
		
	//endregion
	
	// Get geometry data of selected tiles //region
		int nTL = nTypes.length();
		double dXMins[nTL], dXMaxs[nTL], dYs[nTL];
		for (int i=0;i< nTL;i++) // looping ridge, start and end types
		{ 
		// case map by type
			Map m;
			if(nOverwrite ==0)
			{
				if (i==0)m = mapRidgeTile; 			
				else if (i==1)m = mapStartTile;
				else if (i==2)m = mapEndTile;				
			}
			if(nOverwrite ==1)
			{
				if (i==0)m = mapRidgeTile; 			
				else if (i==1)m = mapOverwrite;
				else if (i==2)m = mapOverwrite2;
				else if (i==3)m = mapEndTile;				
			}
			if(nOverwrite ==2)
			{
				if (i==0)m = mapRidgeTile; 			
				else if (i==1)m = mapStartTile;
				else if (i==2)m = mapOverwrite;		
				else if (i==3)m = mapOverwrite2;	
			}			
			
		// get values	
			String k;
			k = "Width"; 	if(m.hasDouble(k)) dYs[i] = m.getDouble(k); 
			m = m.getMap("HorizontalTileSpacing");
			k = "Minimum"; 	if(m.hasDouble(k)) dXMins[i] = m.getDouble(k);
			k = "Maximum"; 	if(m.hasDouble(k)) dXMaxs[i] = m.getDouble(k);
		}//endregion
		

	// loop all edges //region
		int bIsSingleSegment = edges.length()==1;
		_Map.removeAt("mapPlines", true);
		Map mapPlines;  

		for (int i = 0; i < edges.length(); i++)
		{
		// flag if this edge can have a start or end tile
			int bCanStart=bIsSingleSegment, bCanEnd=bIsSingleSegment;
			if (!bCanStart && i == 0)bCanStart = true;
			if (!bCanEnd && i == edges.length()-1)bCanEnd= true;
		
		// get edge	
			EdgeTileData& edge = edges[i];
			LineSeg seg = edge.segment(); 
			
			Point3d ptMid = seg.ptMid();
			Vector3d vecXSeg = seg.ptEnd() - seg.ptStart();
			vecXSeg.normalize();	
	
		//String sPartner = edge.partnerRoofplane().handle();
			Map mapEdge = edge.tileMap();
			ERoofPlane rp = edge.myRoofplane();
			ERoofPlane rp2 = edge.partnerRoofplane();
			CoordSys csRp = rp.coordSys();
			Vector3d vecPerp = vecDir.crossProduct(-_ZW);
			Vector3d vecZEdge = _ZW.crossProduct(vecDir).crossProduct(-vecDir);
			vecZEdge.normalize();
			vecZEdge.vis(ptMid, 6);

		// Find roofplane that match the edge (The edge is always the length where both roofplanes have contact)
			Point3d ptMatch = edge.segment().ptMid();
			EdgeTileData edgeRP1[] = rp.edgeTileTopology();
			EdgeTileData edgeRP2[] = rp2.edgeTileTopology();
			PlaneProfile ppRoofEdge;
			Map m;
			
			for(int k=0; k < 2;k++)
			{
				if(k==0)
					m = rp.subMapX("Hsb_TileExportData");			
				else
					m = rp2.subMapX("Hsb_TileExportData");	

				ppRoofEdge = m.getPlaneProfile("ppRoof");				
				Point3d ptsPP[] = ppRoofEdge.getGripEdgeMidPoints();
				double dEdge = U(20000);
				int nEdgeNum = - 1;
				LineSeg segComp;	
				
				for(int j=0; j < ptsPP.length();j++)
				{
					double dComp = (ptMatch - ptsPP[j]).length();
					if(dComp < dEdge)
					{
						dEdge = dComp;
						nEdgeNum = j;
					}
				}
				
				if(nEdgeNum > -1)
				{
					Point3d ptsPPVertex[] = ppRoofEdge.getGripVertexPoints();
					if(nEdgeNum > 0)
						segComp = LineSeg(ptsPPVertex[nEdgeNum], ptsPPVertex[nEdgeNum - 1]);
					else
						segComp = LineSeg(ptsPPVertex[nEdgeNum], ptsPPVertex.last());					
				}
			
				if(k==0)
					seg = segComp;
				else if(segComp.length() < seg.length())
					seg = segComp;
			}			
			
		// Set startpoint and add extra height
			Point3d ptStart; 
			{ 
				Map mapExport=rp.subMapX("Hsb_TileExportData");
				Vector3d vecZEave = mapExport.hasVector3d("vecZEave") ?mapExport.getVector3d("vecZEave"): _ZW;	
				int bPlumb = (vecZEave.isParallelTo(_ZW)) ? true : false;
				
				double dOffsetS = dStartOffset, dOffsetE = -dEndOffset;
				
			// redesigne LineSeg seg it should follow 
				{ 
					if(vecDir.dotProduct(seg.ptEnd() - seg.ptStart()) < 0)
					{
						seg = LineSeg(seg.ptEnd(), seg.ptStart());
					}			
				}
				
				if(_Map.getInt("flip"))
				{
					vecDir *= -1;
					dOffsetS = -dEndOffset;
					dOffsetE = dStartOffset;
				}
				
				Point3d ptS = seg.ptStart();
				Point3d ptE = seg.ptEnd();
				ptS += vecDir * dOffsetS;
				ptE += vecDir * dOffsetE;
				
				double dHeight = _ZW.dotProduct(ptS - ptE);

				double dHipOffsetUsed = dHipOffset;				
				double dRidgeOffsetUsed = dRidgeOffset;	
				double dHipOffsetX= dHipOffsetUsed* tan(vecZEdge.angleTo(_ZW));
				Vector3d vecOffsetDir;
				
				if(sOffsetDirs.find(sOffsetDir) == 0)
				{
					vecOffsetDir = vecZEdge;
					ptS += vecDir * dHipOffsetX;
					ptE += vecDir * dHipOffsetX;
					dRidgeOffsetExport *= cos(_ZW.angleTo(vecZ1));
					dHipOffsetExport *= cos(_ZW.angleTo(vecZ1));
				}
				else
				{
					vecOffsetDir = _ZW;
					dHipOffsetUsed = dHipOffsetUsed / cos(_ZW.angleTo(vecZ1));	
					dRidgeOffsetUsed = dRidgeOffsetUsed / cos(_ZW.angleTo(vecZ1));
				}
				
				if(dHeight > dEps)
				{
					ptE += vecOffsetDir * dHipOffsetUsed;
					ptS += vecOffsetDir * dHipOffsetUsed;
					//if(!bPlumb)   // Usually a hip is never constructed plumb !!!!
						ptE -= vecDir* dHipOffsetX;
					seg = LineSeg(ptE, ptS);
					ptStart = ptE;	
				}

				else if(dHeight < -dEps)
				{
					ptE += vecOffsetDir * dHipOffsetUsed;
					ptS += vecOffsetDir * dHipOffsetUsed;
					//if(!bPlumb)  // Usually a hip is never constructed plumb !!!!
						ptS -= vecDir* dHipOffsetX;
					seg = LineSeg(ptS, ptE);
					ptStart = ptS;					
				}
				else
				{	
					ptS += _ZW * dRidgeOffsetUsed;
					ptE += _ZW * dRidgeOffsetUsed;
					seg = LineSeg(ptS, ptE);
					ptStart = (vecDir.dotProduct(ptS - ptE) > 0) ? ptE : ptS;					
				}		
			}
			
			double dCos = (vecZ1.angleTo(vecZEdge)+ vecZ2.angleTo(vecZEdge))/2;
			
			double dRidgeWidth = 0.5 * dWidth / cos(dCos);

			PLine pl;
//			pl.createCircle(seg.ptMid(), vecXSeg, dYs[0]);
			pl.createCircle(seg.ptMid(), vecXSeg, dRidgeWidth); pl.vis(2);
			if (pl.area() < pow(dEps, 2))continue;
	
		// subtract pline of roof body
			Point3d pts[] = plEnvelope1.vertexPoints(true);
			pts.append(plEnvelope2.vertexPoints(true));
			PLine plR;
			plR.createConvexHull(Plane(seg.ptMid(), vecXSeg), pts);
			
			double dL = seg.length();;
			if (dL < dEps) continue;
		// set contact body			
			Body bd(pl, vecDir * dL, 0);		
			Body bdR(plR, vecDir * 2 * dL, 0); bd.vis(3);pl.vis(2);
			bdR.addTool(Cut(ptOrg1, vecZ1),0);
			bdR.addTool(Cut(ptOrg2, vecZ2),0);
			bdR.transformBy(vecZEdge * vecZEdge.dotProduct(seg.ptMid()-ptMid));
			bd.subPart(bdR);
	
		// get contact faces
			PlaneProfile pp1 = bd.extractContactFaceInPlane(Plane(seg.ptMid(), vecZ1), dEps);	
			PlaneProfile pp2 = bd.extractContactFaceInPlane(Plane(seg.ptMid(), cs2.vecZ()), dEps);				
			
		// Write Plines from edges to _Map, so the lath tsl can read the information
			PLine plEdge(seg.ptStart(), seg.ptEnd());
			mapPlines.appendPLine("plEdge", plEdge);

			
		// distribute
			double dStart, dEnd, dXMin, dXMax;
			//double dLength = seg.length()-dStartOffset-dEndOffset;
			double dLMin=dL, dLMax = dL;//dLength
			if (bCanStart && nStartTile>0 && dXMins[1]>0 && dXMaxs[1]>0)
			{ 
				dLMin -= dXMins[1];
				if (nOverwrite == 1) dLMin -= dXMins[2];
				dLMax -= dXMaxs[1];
				if (nOverwrite == 1) dLMax -= dXMaxs[2];				
				dStart = (dXMins[1] + dXMaxs[1]) / 2;
			}
			if (bCanEnd && nEndTile>0 && dXMins[2]>0 && dXMaxs[2]>0)
			{ 
				
				dLMin -= dXMins.last();
				if (nOverwrite == 2) dLMin -= dXMins[2];
				dLMax -= dXMaxs.last();
				if (nOverwrite == 2) dLMax -= dXMaxs[2];
				dEnd = (dXMins[2] + dXMaxs[2]) / 2;
			}
			double dDist;
			if (dXMins[0] == dXMaxs[0]) 
				dDist = dXMaxs[0];
			else
				dDist = (dXMins[0] + dXMaxs[0]) / 2;
			
			int nNum=(dDist>0 ? dLMin / dDist+.99:0);
			if (nNum>0)dDist = dLMin / nNum;			
				
		// create an arrow pline
			PLine plArrow;
			{
				double dArrowSize = dXMins[0]*.5;
				Point3d pt = ptStart;
				Vector3d vecX = vecDir, vecY=vecPerp;
				plArrow=PLine(pt+vecX*.5*dArrowSize,pt+vecX*.25*dArrowSize+vecY*.1*dArrowSize,pt+vecX*.3*dArrowSize+vecY*.02*dArrowSize,pt-vecX*.3*dArrowSize+vecY*.02*dArrowSize);
				plArrow.addVertex(pt-vecX*.3*dArrowSize-vecY*.02*dArrowSize);
				plArrow.addVertex(pt+vecX*.3*dArrowSize-vecY*.02*dArrowSize);
				plArrow.addVertex(pt+vecX*.25*dArrowSize-vecY*.1*dArrowSize);
				plArrow.close();
				plArrow.transformBy(vecDir*dArrowSize);
				dpPlan.draw(plArrow);
			}
	

		// Start Tile//region	
			PLine plTile;
			double dX = dStart;
			double dY = U(1000);
			String sNotes;
			if(rp1.roofNumber().length() > 0 &&  rp2.roofNumber().length() > 0)
				sNotes = ( rp1.roofNumber() < rp2.roofNumber())? rp1.roofNumber() + " + " + rp2.roofNumber() : rp2.roofNumber() + " + " + rp1.roofNumber();
			
			if (dStart>0)
			{ 
				int n = (nOverwrite ==1) ? 2 : 1;
				for(int j=0; j < n; j++ )
				{
					if(n==2)
					{
						dX = (j == 0) ? dXMins[1] : dXMins[2];
					}
					if (dX < dEps) continue;
					
					nc = ncStart; nt = ntStart;	dpPlan.color(nc);
					plTile.createRectangle(LineSeg(ptStart-vecPerp*.5*dY, ptStart+vecPerp*.5*dY+vecDir*dX), vecDir, vecPerp);
					PlaneProfile pp(plTile), ppX;
					
					ppX = pp1;
					ppX.intersectWith(pp);
					if (nt>0 && nt<100)dpPlan.draw(ppX, _kDrawFilled, nt);
					dpPlan.draw(ppX);
		
					ppX = pp2;
					ppX.intersectWith(pp);
					if (nt>0 && nt<100)dpPlan.draw(ppX, _kDrawFilled, nt);
					dpPlan.draw(ppX);				
					
//					ptStart.transformBy(vecDir * dStart);
					ptStart.transformBy(vecDir * dX);
					
				// hardware item			
					Map m;
					if(nOverwrite ==0)
						m= mapStartTile;
					else
						m = (j == 0) ? mapOverwrite : mapOverwrite2;
						

					HardWrComp hwc(m.getString("ArticleNumber"), 1); // the articleNumber and the quantity is mandatory
					hwc.setManufacturer(sManufacturer);			
					hwc.setModel(sFamilyName);
					hwc.setName(m.getString("Name"));
					hwc.setMaterial(sFamilyCharacteristic);
					hwc.setNotes( sNotes);
					hwc.setGroup(sHWGroupName);
					hwc.setLinkedEntity(rps[0]);	
					hwc.setCategory(T("|Rooftiles|"));
					hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
					hwc.setDScaleX(m.getDouble("Length"));
					hwc.setDScaleY(m.getDouble("Width"));
					hwc.setDScaleZ(0);	
					
				// apppend component to the list of components
					hwcs.append(hwc);	
				}
			}//endregion
			
		// Ridge/hip tile distribution//region	
			dX = dDist < dXMins[0] ? dXMins[0] : dDist; 
			plTile.createRectangle(LineSeg(ptStart-vecPerp*.5*dY, ptStart+vecPerp*.5*dY+vecDir*dX), vecDir, vecPerp);
			PlaneProfile pp(plTile);
			// set color and transparancy	
			nc = ncRidge; nt = ntRidge;		dpPlan.color(nc);
			for (int x=0;x<nNum;x++) 
			{ 	
				PlaneProfile ppX;
				ppX = pp1;
				ppX.intersectWith(pp);
				if (nt>0 && nt<100)dpPlan.draw(ppX, _kDrawFilled, nt);
				dpPlan.draw(ppX);
				
				ppX = pp2;
				ppX.intersectWith(pp);
				if (nt>0 && nt<100)dpPlan.draw(ppX, _kDrawFilled, nt);
				dpPlan.draw(ppX);
				
				
				pp.transformBy(vecDir * dDist);
				ptStart.transformBy(vecDir * dDist);	 
			}
			if(nNum>0)
			{ 
			// hardware item
				Map m = mapRidgeTile;
				HardWrComp hwc(m.getString("ArticleNumber"), nNum); // the articleNumber and the quantity is mandatory
				hwc.setManufacturer(sManufacturer);			
				hwc.setModel(sFamilyName);
				hwc.setName(m.getString("Name"));
				hwc.setMaterial(sFamilyCharacteristic);
				hwc.setNotes(sNotes);
				hwc.setGroup(sHWGroupName);
				hwc.setLinkedEntity(rps[0]);	
				hwc.setCategory(T("|Rooftiles|"));
				hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
				hwc.setDScaleX(m.getDouble("Length"));
				hwc.setDScaleY(m.getDouble("Width"));
				hwc.setDScaleZ(0);
				
			// apppend component to the list of components
				hwcs.append(hwc);				
			}//endregion
			
		// End Tile //region
			dX = dEnd;
			if (dEnd>0)
			{ 
				int n = (nOverwrite > 0) ? 2 : 1;
				
				for (int j = 0; j < n; j++)
				{
					if(n==2)
					{
						dX = (j == 0) ? dXMins[3] : dXMins[2];
					}
					if (dX < dEps) continue;
					
				// set color and transparancy
					nc = ncEnd; nt = ntEnd;	dpPlan.color(nc);
					
					plTile.createRectangle(LineSeg(ptStart-vecPerp*.5*dY, ptStart+vecPerp*.5*dY+vecDir*dX), vecDir, vecPerp);
					PlaneProfile pp(plTile), ppX;
					
					ppX = pp1;
					ppX.intersectWith(pp);
					//ppX.intersectWith(PlaneProfile(plEnvelope1));
					if (nt>0 && nt<100)dpPlan.draw(ppX, _kDrawFilled, nt);
					dpPlan.draw(ppX);
					
					ppX = pp2;
					ppX.intersectWith(pp);
					//ppX.intersectWith(PlaneProfile(plEnvelope2));
					if (nt>0 && nt<100)dpPlan.draw(ppX, _kDrawFilled, nt);
					dpPlan.draw(ppX);	
										
					ptStart.transformBy(vecDir * dX);
				
				// hardware item			
					Map m;
					if (nOverwrite == 0)
						m = mapEndTile;
					else
						m = (j == 0) ? mapOverwrite : mapOverwrite2;

					HardWrComp hwc(m.getString("ArticleNumber"), 1); //the articleNumber and the quantity is mandatory
					hwc.setManufacturer(sManufacturer);
					hwc.setModel(sFamilyName);
					hwc.setName(m.getString("Name"));
					hwc.setMaterial(sFamilyCharacteristic);
					hwc.setNotes(sNotes);
					hwc.setGroup(sHWGroupName);
					hwc.setLinkedEntity(rps[0]);
					hwc.setCategory(T("|Rooftiles|"));
					hwc.setRepType(_kRTTsl); //the repType is used to distinguish between predefined and custom components
					hwc.setDScaleX(m.getDouble("Length"));
					hwc.setDScaleY(m.getDouble("Width"));
					hwc.setDScaleZ(0);
					
					// apppend component to the list of components
					hwcs.append(hwc);
				}
			}//endregion			
		}//endregion		
		
	// Export distances to hsbTileLath
		Map mapExport = rp1.subMapX("Hsb_TileExportData");
		mapExport.setDouble("RidgeOffset", dRidgeOffsetExport);
		mapExport.setDouble("HipOffset", dHipOffsetExport);
		rp1.setSubMapX("Hsb_TileExportData", mapExport);
		
		mapExport = rp2.subMapX("Hsb_TileExportData");
		rp2.setSubMapX("Hsb_TileExportData", mapExport);
		
		_Map.setMap("mapPlines", mapPlines);
	}


// Loop topologies to identify connecting verge tiles//region

	for (int k = 0; k < rps.length(); k++)
	{ 
		ERoofPlane& rp = rps[k];
		
		TslInst tsls[] = rp.tslInstAttached();
		
		int nContinue;
		for(int i=0; i < tsls.length(); i++)
		{
			if( tsls[i].scriptName() == _ThisInst.scriptName() && tsls[i] != _ThisInst && tsls[i].map().getInt("PentTiles"))
			{
				nContinue = true;
				break;
			}
		}
		if(nContinue)
			continue;
		
//		EdgeTileData edges[] = rp.edgeTileTopology();
		EdgeTileData edges[] = rp.edgeTileData();
		
		CoordSys cs = rps[k].coordSys();
		Vector3d vecZ = cs.vecZ();
		
	// read distributions 
		Map mapExport=rp.subMapX("Hsb_TileExportData");
		
		Point3d ptsH[] = mapExport.getPoint3dArray("HorizontalDistribution");
		Point3d ptsV[] = mapExport.getPoint3dArray("VerticalDistribution");
		double dHalfTile = mapExport.getDouble("dAvHalf");
		double dZOffsetTilePlane = mapExport.getDouble("ZOffsetTilePlane");	
		PlaneProfile ppRoof = mapExport.getPlaneProfile("ppRoof");
		double dColumnWidth = mapExport.getDouble("ColumnWidth");
		PlaneProfile ppPositioning = mapExport.getPlaneProfile("ppPositioning");
		Map  mapTilesToSubtract;
		
		int nDistribution = _Map.getInt("nDistribution");
		int nNumFull2Remove, nNumHalf2Remove;	
		Map  mapVergeEdgeData  = mapExport.getMap("VergeEdgeData");		
		
	// Map with top verge tiles that might be replaced by verge-ridge tiles
		int bConnectionTiles;
		int bReplaceVerge;
		Map mapRVConnectors;
		Map mapVergeTops;
		Map mapReplaceHalf;
		PlaneProfile ppHalfRCs;
		
	//Return Instance if basic information are missing. (It´s assumed that the _hsbTileGrid is not attached yet)
		if(ptsV.length()  < 2)
			return;
		if(ptsH.length()  < 2)
			return;
				
		if( mapVergeEdgeData.getEntity("ParentTsl").bIsValid())	
		{
			bReplaceVerge = true;
			mapVergeTops = mapVergeEdgeData.getMap("VergeTops[]");
		}

		else
			mapExport.removeAt("VergeEdgeData", true);
//			rp.removeSubMapX("VergeEdgeData");

		for (int i =0 ; i < edges.length(); i++) 
		{ 
		// get ridge edge	
			EdgeTileData edge = edges[i];
			if (edge.tileType() != _kTileRidge )continue;		
				
		// check if this edge has connected tiles attached
			Map mapEdge = edge.tileMap();
			Map mapRCDefs = mapEdge.getMap("RidgeConnectionDefinition[]");
			Map mapRCTilesRow, mapRCTilesAll;
			int bContinue; // continue if related tile is a standard tile
			int bIsPent;
			
			for(int j=0; j < mapRCDefs.length(); j++)
			{
				Map map = mapRCDefs.getMap(j).getMap("RelatedTile\\RoofTile");
				int nTileType = map.getInt("TileType");
				
			// Check if related tiles are pent tiles
				if(nTileType > 22 && nTileType < 27)
				{
					bIsPent = true;
				}
				
				if(nTileType == 0)
				{
					bContinue = true;
					break;
				}
				mapRCTilesAll.appendMap("RCTiles", map);
				
				if(nTileType == 3 || nTileType == 23)
					mapRCTilesRow.setMap("Full", map);
				if(nTileType == 14 || nTileType == 24)
					mapRCTilesRow.setMap("Half", map);
			}
			
		// Related tile is a standard tile
			if (bContinue) continue;

			double dLAF = mapRCDefs.getDouble("RidgeConnectionDefinition\\VerticalTilingDefinition\\RidgeBattenDistance");
			if (mapRCTilesRow.length() < 1)continue;// no connected tile defined

			nc = ncRidgeConnection;	nt = ntRidgeConnection; dpPlan.color(nc);

			LineSeg seg = edge.segment();	
			Point3d ptStart = seg.ptStart(); 
			Point3d ptEnd = seg.ptEnd(); 
			Vector3d vecYrp = cs.vecY();
			Vector3d vecZrp = cs.vecZ();
			
		// Find top/bottom position of connection tiles 
			Point3d ptSt, ptE;
			double dPitch = _ZW.angleTo(vecZrp);
			Point3d ptRidge = ptStart + _ZW*(dZOffsetTilePlane / cos(dPitch));
			int nPtsV;

			for(int j= ptsV.length()-1; j > -1; j--)
			{
				if ( vecYrp.dotProduct((ptStart -vecYrp*(dLAF+dEps)) - ptsV[j])< 0) continue;
				
				if( j < ptsV.length()-1 )
				{
					ptSt = ptsV[j]; 
					ptE = ptsV[j+1]; 
					nPtsV = j;
					break;
				}				
			}
					 			
			double dTileY = vecYrp.dotProduct(ptE - ptSt);
			double dER = vecYrp.dotProduct(ptSt - ptsH[0]);
			
		// Make sure Start and End point is always in vecXD direction 
			Vector3d vecXD (ptsH[1] - ptsH[0]); vecXD.normalize();
			Point3d ptRCSt , ptRCE;
			int bSt, bE;
			{
				LineSeg segRC[] = ppRoof.splitSegments(LineSeg(ptSt - vecXD * U(100000), ptSt + vecXD * U(100000)), true); 
				Point3d ptRidgeSt = (vecXD.dotProduct(ptStart - ptEnd) < 0) ? ptStart : ptEnd;
				//ptRidgeSt -= vecYrp * dTileY;
				Point3d ptRidgeE = (vecXD.dotProduct(ptStart - ptEnd) > 0) ? ptStart : ptEnd;	
				//ptRidgeE -= vecYrp * dTileY;
				Point3d ptRoofSt = (vecXD.dotProduct(segRC[0].ptStart() - segRC[0].ptEnd()) < 0) ? segRC[0].ptStart() : segRC[0].ptEnd();	 
				Point3d ptRoofE = (vecXD.dotProduct(segRC[0].ptStart() - segRC[0].ptEnd()) > 0) ? segRC[0].ptStart() : segRC[0].ptEnd();
				Vector3d vecSt (ptRidgeSt - ptRidgeE); vecSt.normalize(); vecSt.vis(ptRidgeSt, 2);
				Vector3d vecE (ptRidgeE - ptRidgeSt); vecE.normalize(); vecE.vis(ptRidgeE, 3);
				
				 ptRCSt = ptRoofSt; 
//				 if(ppRoof.pointInProfile(ptRidgeSt-vecXD*U(1)) ==0)
				 if(ppRoof.pointInProfile(ptRidgeSt+vecSt*U(50)) ==0)
				 {
					 ptRCSt =  ptRidgeSt -vecYrp*vecYrp.dotProduct(ptRidgeSt - ptRoofSt)	;
					 bSt = true;
				 }
				 
				ptRCE = ptRoofE; Point3d pt = ptRidgeE + vecE * U(50); pt.vis(4); ppRoof.vis(3);
//				 if(ppRoof.pointInProfile(ptRidgeE-vecXD*U(1)) ==0)
				 if(ppRoof.pointInProfile((ptRidgeE+vecE*U(50))) ==0)
				 {
					 ptRCE = ptRidgeE -vecYrp*vecYrp.dotProduct(ptRidgeE - ptRoofE);
					 bE = true;
				 }
			}

			Point3d ptStVerge = ptRCSt, ptEVerge = ptRCE; 	
			
		// Add vergeridge or vergepent tiles to mapVergeRidge for eventual overwrite
			Map mapUsedRidge;			
			
			if(bIsPent)
				mapUsedRidge = _Map.getMap("mapVergePent");
			else
				 mapUsedRidge = _Map.getMap("mapVergeRidge");	
				 
			double dHalfAdded[2];
				
		// find adjacent verge edge to this
			if(bReplaceVerge)
			{	
				for(int j=0; j < mapVergeTops.length();j++)
				{
					Map m = mapVergeTops.getMap(j);
					Point3d ptVergeTop = m.getPoint3d("ptEnd");	ptVergeTop.vis(4);	
					Point3d ptVergeBottom = m.getPoint3d("ptStart");	ptVergeBottom.vis(5);
					double dHalfAdd = m.getDouble("AddHalf");
					
					ptSt.vis(2);
					ptE.vis(3);

				// Vertical test if ridge verge connection can exist			
					if (vecYrp.dotProduct(ptSt - ptVergeTop) < -dEps && vecYrp.dotProduct(ptE - ptVergeTop) > - dEps)
					{
						int bArgument1 = vecXD.dotProduct( ptVergeTop - (ptRCSt + vecXD * U(20))) > 0 && vecXD.dotProduct( ptVergeBottom - (ptRCSt + vecXD * U(20))) < 0;
						int bArgument2 = vecXD.dotProduct( ptVergeTop - (ptRCE - vecXD * U(20))) < 0 && vecXD.dotProduct( ptVergeBottom - (ptRCE - vecXD * U(20))) > 0;	

					// Horizontal test if ridge verge connection can exist
						if( bArgument1 || bArgument2)
						{
							int nTileType = m.getInt("TileType");

							if (bArgument1) 
							{
								ptStVerge = ptVergeTop;							
								dHalfAdded[0] = dHalfAdd;

								if(dHalfAdd)
									mapReplaceHalf.setInt(j, true);	
							}
							
							if (bArgument2) 
							{
								ptEVerge = ptVergeTop;
								dHalfAdded[1] = dHalfAdd;
								
								if(dHalfAdd)
									mapReplaceHalf.setInt(j, true);	
							}
							
							if(nTileType == 1)// Replace left verge by RidgeVergeConnector left
							{
								int nType = bIsPent ? 26 : 4;
								Map mapRP;
								for (int ma = 0; ma < mapRCTilesAll.length(); ma++)
								{
									Map m = mapRCTilesAll.getMap(ma);
									if (m.getInt("TileType") == nType)
									{
										mapRP = m;
										break;
									}
								}
								if (mapRP.length() < 1)
								{							
									mapRP = mapUsedRidge.getMap(0).getMap("RoofTile");
								}
								
								if(mapRP.getString("ID").length() > 0)
								{
									mapRP.setDouble("dLAF", dLAF);
									mapRVConnectors.setMap(j, mapRP);									
								}								
							}			
							else if(nTileType == 2) // Replace right verge by RidgeVergeConnector right
							{ 
								int nType = bIsPent ? 25 : 5;
								Map mapRP;
								for (int ma = 0; ma < mapRCTilesAll.length(); ma++)
								{
									Map m = mapRCTilesAll.getMap(ma);
									if (m.getInt("TileType") == nType)
									{
										mapRP = m;
										break;
									}
								}
								
								if (mapRP.length() < 1)
								{							
									mapRP = mapUsedRidge.getMap(1).getMap("RoofTile");
								}
								
								if(mapRP.getString("ID").length() > 0)
								{
									mapRP.setDouble("dLAF", dLAF);
									mapRVConnectors.setMap(j, mapRP);									
								}	
							}	
							else if(nTileType == 10)// Replace left half verge by RidgeVergeConnector half left		
							{ 
								Map mapRP;
								for (int ma = 0; ma < mapRCTilesAll.length(); ma++)
								{
									Map m = mapRCTilesAll.getMap(ma);
									if (m.getInt("TileType") == 12)
									{
										mapRP = m;
										break;
									}
								}
								if (mapRP.length() < 1)
								{							
									mapRP = mapUsedRidge.getMap(2).getMap("RoofTile");
								}
								
								if(mapRP.getString("ID").length() > 0)
								{
									mapRP.setDouble("dLAF", dLAF);
									mapRVConnectors.setMap(j, mapRP);									
								}
							}
							else if(nTileType == 11) // Replace right half verge by RidgeVergeConnector half right
							{
								Map mapRP;
								for (int ma = 0; ma < mapRCTilesAll.length(); ma++)
								{
									Map m = mapRCTilesAll.getMap(ma);
									if (m.getInt("TileType") == 13)
									{
										mapRP = m;
										break;
									}
								}
								if (mapRP.length() < 1)
								{							
									mapRP = mapUsedRidge.getMap(3).getMap("RoofTile");
								}
								
								if(mapRP.getString("ID").length() > 0)
								{
									mapRP.setDouble("dLAF", dLAF);
									mapRVConnectors.setMap(j, mapRP);									
								}
							}
							if(nTileType == 0)// Replace standard tile by RidgeConnector 
							{
								Map mapRP = mapRCTilesRow.getMap("Full");
								if(mapRP.getString("ID").length() > 0)
								{
									mapRP.setDouble("dLAF", dLAF);
									mapRVConnectors.setMap(j, mapRP);									
								}
							}							
							if(nTileType == 7)// Replace standard half tile by RidgeConnector 
							{ 
								Map mapRP = mapRCTilesRow.getMap("Half");
								if(mapRP.getString("ID").length() > 0)
								{
									mapRP.setDouble("dLAF", dLAF);
									mapRVConnectors.setMap(j, mapRP);									
								}							
							}
							else
								continue;
						}
					}
				}				
			}	
			
			double dAdjust = -1;
			int nQtyFull[10];
			int nHalfSub;
			int nInStaggered;
			if(nDistribution == 1)
				nInStaggered= (nPtsV % 2 == 0) ? 1 : 0;
			int nFirst, nLast, nFull;
			Point3d ptH2;
			Point3d ptHalfs[0];	
			Point3d ptD;
			int bUseHalfs = 0 < nDistribution && nDistribution< 3;
			double dAddTile = dColumnWidth / 2 + U(40);
			dAddTile -= (bUseHalfs) ? dHalfTile : 0;
			
		// Get width of half pent tile if existing to find out if tile s a half tile
			double dHMin, dHMax;					
			if(mapRCTilesRow.length() > 1)
			{
				dHMin = mapRCTilesRow.getMap("Half").getMap("HorizontalTileSpacing").getDouble("Minimum");
				dHMax = mapRCTilesRow.getMap("Half").getMap("HorizontalTileSpacing").getDouble("Maximum");
			}
			
			vecXD.vis(cs.ptOrg(), 6); ptEVerge.vis(5); ptRCE.vis(6);

		// Create ridge connection tiles
			for(int l=0 ; l < ptsH.length()-1;l++)
			{
				if (l + 1 >= ptsH.length()) break;
				
				Point3d ptH0 = ptsH[l] + vecXD * nInStaggered * dHalfTile; ptH0.vis(2);
				Point3d ptH1 = ptsH[l + 1] + vecXD*nInStaggered*dHalfTile;	

				if ( vecXD.dotProduct(ptH0 - ptStVerge) < - dEps) continue; ptStVerge.vis(4);
				
				if(nFull != 1 && nFirst == 1 && ptH2 != _PtW)
				{
					ptH0 = ptH2;
					nFirst ++;
				}
				
				if(nFirst == 0)
				{											
					nFirst = 1;
					if(dHalfAdded[0] > dEps || ptStVerge == ptRCSt)
					{			
						double dFirst = vecXD.dotProduct(ptH0 - ptStVerge); 					
						double dColumn = (ptH1 - ptH0).length();
						ptH1 = ptStVerge+ vecXD * (dColumn - dColumnWidth + dFirst) - vecYrp*vecYrp.dotProduct(ptStVerge - ptH0)- vecZrp*vecZrp.dotProduct(ptStVerge - ptH0); 
						ptH2 = ptH1;
						dColumn -= U(40);
						
						if(l > 0 && vecXD.dotProduct(ptStVerge - (ptsH[l-1]+ vecXD*nInStaggered*dHalfTile) ) <dAddTile )
						{ 
							ptH1 = ptH0;
							ptH0 = ptsH[l - 1] + vecXD * nInStaggered * dHalfTile;					
						}					
						 else if (bSt && dFirst < dColumn && dFirst > dHalfTile)
							ptH0 = ptStVerge - vecYrp*vecYrp.dotProduct(ptStVerge - ptH0) + vecXD*(dFirst - dHalfTile);
						else if (bSt && dFirst <  U(60))
						{ 
							;						
						}
						else
							ptH0 = ptStVerge - vecYrp*vecYrp.dotProduct(ptStVerge - ptH0) - vecZrp*vecZrp.dotProduct(ptStVerge - ptH0);
		
						l--;
					}
					else
						ptH0 = ptStVerge - vecYrp*vecYrp.dotProduct(ptStVerge - ptH0)- vecZrp*vecZrp.dotProduct(ptStVerge - ptH0);
						
				// Add points for standard half tile
					Point3d ptHBefore;
					if (l > - 1) ptHBefore = ptsH[l] + vecXD * nInStaggered * dHalfTile; 

					double dDiff = vecXD.dotProduct(ptHBefore - ptRCSt); 
					
					if(bUseHalfs && (ptHBefore != _PtW && ptH0 != _PtW && dDiff < dEps && abs(dDiff) < dColumnWidth - U(30) && abs(dDiff) > dAddTile))
					{
						if(dHalfTile > dEps && vecXD.dotProduct(ptH0 - ptHBefore) > dHalfTile + dEps)
							ptH0 = ptHBefore + vecXD * dHalfTile;
						ptHalfs.append(ptHBefore);
						ptHalfs.append(ptH0);
					}			
				}
				
				double dLast = vecXD.dotProduct(ptH1 - ptEVerge); ptH1.vis(5);
				 int bAddHalf; 
				
				if(dLast > -U(1))
				{
					 ptH2 = ptH1; 
					
					if(dLast > U(1) && bE  && ( (dLast < dAddTile && !bUseHalfs) || (dLast < dHalfTile && bUseHalfs)))
						ptH1 = ptEVerge - vecYrp*vecYrp.dotProduct(ptEVerge - ptH1) - vecXD*(dHalfTile - dLast) - vecZrp*vecZrp.dotProduct(ptEVerge - ptH0);			

					else if (bE && dLast > (ptH1-ptH0).length() - dAddTile)
					{ 
						break;						
					}
					else
						ptH1 = ptEVerge - vecYrp*vecYrp.dotProduct(ptEVerge - ptH1)- vecZrp*vecZrp.dotProduct(ptEVerge - ptH0);

						
				// Add points for standard half tile
					if(bUseHalfs && (vecXD.dotProduct(ptRCE - ptH2) < dEps && vecXD.dotProduct(ptRCE - ptEVerge) < dEps))
					{
						if(dHalfTile > dEps && vecXD.dotProduct(ptH2 - ptH1) > dHalfTile + dEps)
							ptH1 = ptH2 - vecXD * dHalfTile;
						ptHalfs.append(ptH1);
						ptHalfs.append(ptH2);
					}					
					nLast = true;
				}
				
				if(l < ptsH.length()-2 && vecXD.dotProduct(ptH1 - ptH0) < dHalfTile + dEps)
				{		
					double dd = vecXD.dotProduct(ptEVerge - ptH0);
					
					if(vecXD.dotProduct(ptsH[l+2] - ptH0) + nInStaggered*dHalfTile < dColumnWidth + dEps)
					{
						ptH1 = ptsH[l + 2] + vecXD * nInStaggered * dHalfTile;
						l++;
						nFull = true;
					}
					
					else if(vecXD.dotProduct(ptEVerge - ptH0)  < dColumnWidth + 2*dEps)
					{
						if(ptHalfs.length() == 0)
						ptH1 = ptEVerge - vecYrp*vecYrp.dotProduct(ptEVerge - ptH1);
						nLast = true;
					}
				}
					
				LineSeg segTile(ptH0 + vecYrp * (dER + dTileY) + vecZrp*dZOffsetTilePlane, ptH1 + vecYrp * dER + vecZrp*dZOffsetTilePlane);
				PLine plTile;
				plTile.createRectangle(segTile, vecXD, vecYrp);
				PlaneProfile ppTile(plTile);
				ppTile .intersectWith(ppRoof);
					
				if(ppTile.area() < U(50))
					continue;
					
				dpPlan.color(nc); 
				if (nt>0 && nt<100)	dpPlan.draw(ppTile, _kDrawFilled, nt);
					dpPlan.draw(ppTile);
					
			//PLaneProfile for the positioning of special tiles
				ppPositioning.subtractProfile(ppTile);
						
				int nQty = - 1;
				segTile = ppTile.extentInDir(vecXD);
				double dWidthPent = vecXD.dotProduct(segTile.ptEnd() - segTile.ptStart());
					
				if(dWidthPent > dHMin-U(1) && dWidthPent < dHMax+U(1))
				{
					nQty = 1;	
					int bTrueA = (ptStVerge != _PtW) ? vecXD.dotProduct(ptH0 - ptStVerge) > U(1) : vecXD.dotProduct(ptH1 - (ptRCSt + vecXD * dHalfTile)) > U(1);
					int bTrueB = (ptEVerge != _PtW) ? vecXD.dotProduct(ptEVerge - ptH1) > U(1) : vecXD.dotProduct((ptRCE - vecXD * dHalfTile) - ptH1) > U(1);

					if(bTrueA && bTrueB)
						nHalfSub ++;
				}

				else
					nQty = 0;
	
				if(nQty > -1)
					nQtyFull[nQty]++;		
				
				if (nLast)
					break;
			}	

			
		// Add a standard half tile to the roof
			if(ptHalfs.length() > 0)
			{

			// get attached special tiles to check if eventual half tiles can be added
				TslInst tsls[] = rp.tslInstAttached();
				PlaneProfile ppSpecials;
				
				for(int i=0; i < tsls.length();i++)
				{		
					if(tsls[i].scriptName() == "hsbTileSpecial")
					{
						if(ppSpecials.area() < dEps)
							ppSpecials = tsls[i].map().getPlaneProfile("ppSpecial");
						else
							ppSpecials.unionWith(tsls[i].map().getPlaneProfile("ppSpecial"));
					}	
				}
			
				for(int j=0;  j < ptHalfs.length();j+=2)
				{
					LineSeg segTile(ptHalfs[j] + vecYrp * (dER + dTileY) + vecZrp*dZOffsetTilePlane, ptHalfs[j+1] + vecYrp * dER + vecZrp*dZOffsetTilePlane);
					PLine plTile;
					plTile.createRectangle(segTile, vecXD, vecYrp);
					PlaneProfile ppTile(plTile);
					ppTile .intersectWith(ppRoof);
						
					if(ppTile.area() < U(50))
						continue;
						
					PlaneProfile ppTile1 = ppTile;
					ppTile1.intersectWith(ppSpecials);
					
					if(ppTile1.area() > dEps)
						continue;
						
					dpPlan.color(44); 
					if (nt>0 && nt<100)	dpPlan.draw(ppTile, _kDrawFilled, 70);
						dpPlan.draw(ppTile);
					
					if(ppHalfRCs.area() < dEps)
						ppHalfRCs = ppTile;
					else
						ppHalfRCs.unionWith(ppTile);
						
					nQtyFull[2]++;
				}			
			}
		
			if(nHalfSub > 0)
				mapTilesToSubtract.setInt("HalfTile", nHalfSub);
			
		// hardware item
			for(int j=0; j < nQtyFull.length();j++)
				if (nQtyFull[j]>0)
				{ 
					Map m;
					
					int nHalf;
					if(j > 0)
						nHalf += nQtyFull[j]; 
					
					if(j == 0)
					{
						mapTilesToSubtract.setInt("FullTile", nQtyFull[0]);
						m = mapRCTilesRow.getMap("Full");						
					}

					else if (j==1)	
						m = mapRCTilesRow.getMap("Half");	
					
					else
					{
					// get half tile data from database							
						Map mapIn;
						mapIn.setString("ManufacturerId",mapManufacturer.getString("ID"));
						mapIn.setString("RoofTileFamilyId",mapFamily.getString("Id"));
						mapIn.setInt("TileType",7);    
						Map mapOut = callDotNetFunction2(strAssemblyPath, strType, "GetTiles", mapIn);
						m = mapOut.getMap("RoofTile[]\\RoofTile");		
					}					

						
				
					if(j > 0 && j == nQtyFull.length()-1)
						mapTilesToSubtract.setInt("HalfTile", nHalf);					
					
					bConnectionTiles = true;

					HardWrComp hwc(m.getString("ArticleNumber"), nQtyFull[j]); // the articleNumber and the quantity is mandatory
					hwc.setManufacturer(sManufacturer);			
					hwc.setModel(sFamilyName);
					hwc.setName(m.getString("Name"));
					hwc.setMaterial(sFamilyCharacteristic);
					hwc.setGroup(sHWGroupName);
					hwc.setLinkedEntity(rp);	
					hwc.setNotes(rp.roofNumber());
					hwc.setCategory(T("|Rooftiles|"));
					hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
					hwc.setDScaleX(m.getDouble("Length"));
					hwc.setDScaleY(m.getDouble("Width"));
					hwc.setDScaleZ(0);	
					hwcs.append(hwc);
				}
		}	
		
		if(bReplaceVerge)
		{
			Map map; 
			map.setEntity("ChildTsl", _ThisInst);
			map.setMap("mapRVConnectors", mapRVConnectors);
			map.setMap("mapReplaceHalf", mapReplaceHalf);
			mapExport.setMap("mapRidgeData", map);
//			rp.setSubMapX("mapRidgeData", map);
		}	
		
		if(ppHalfRCs.area() > dEps)
			mapExport.setPlaneProfile("ppHalfRCs", ppHalfRCs);
		mapExport.setPlaneProfile("ppPositioning", ppPositioning);
		rp.setSubMapX("Hsb_TileExportData", mapExport);
		
	// Add tiles to subtract from amount of hsbTileGrid
		_Map.setMap("TilesToSubtract", mapTilesToSubtract);
		_Map.setInt("PentTiles",true);
	}
//endregion


// set hardware and final validation //region
// make sure the hardware is updated
	if (_bOnDbCreated)
		setExecutionLoops(2);			
	_ThisInst.setHardWrComps(hwcs);	

// invalid
	if (_kExecutionLoopCount>1 && hwcs.length()<1)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|could not evaluate any tiles.|"));
		eraseInstance();
		return;
		
	}//endregion






#End
#BeginThumbnail
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
C&N:GM6Y1513D`E0!^7-=)9Q-;64$#$%HT"DCIP*LT4`?_]GZ
`











#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="Resource[]">
    <lst nm="IMAGE[]" />
  </lst>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS">
        <int nm="BREAKPOINT" vl="1325" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-16994: avoid version error message" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="11/8/2022 12:33:59 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End