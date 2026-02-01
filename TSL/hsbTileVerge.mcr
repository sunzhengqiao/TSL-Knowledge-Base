#Version 8
#BeginDescription
This tsl creates an instance of verge tiles per roofplane and computes the quantity of the required tiles.
The roof plane needs to have a tile definition, the hsbTileGrid Tsl needs to be attached and the vertical tiling must be in range.

version value="2.7" date="23jul23" author="nils.gregor@hsbcad.com">HSB-19266: Use ridge connection tile map to detect last verge."
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
// <History> //region
///<version value="2.7" date="23jul23" author="nils.gregor@hsbcad.com">HSB-19266: Use ridge connection tile map to detect last verge."</version>
///<version value="2.6" date="08nov22" author="nils.gregor@hsbcad.com">HSB-16994: Bugfix first verge tile not shown. Added functionality to add half tiles if needed"</version>
///<version value="2.5" date="08nov22" author="nils.gregor@hsbcad.com">"HSB-16994 test to avoid error message</version>
///<version value="2.4" date="03Jul19" author="nils.gregor@hsbcad.com">HSB-12044 Bugfix amount of verge tiles when distribution is not done from lowest eave"</version>
///<version value="2.3" date="03Jul19" author="nils.gregor@hsbcad.com">Bugfix for drawing in meter"</version>
///<version value="2.2" date="20may19" author="nils.gregor@hsbcad.com">Added surface to the colour"</version>
///<version value="2.1" date="15apr19" author="nils.gregor@hsbcad.com">adjust quantity of tiles</version>
///<version value="2.0" date="05apr19" author="nils.gregor@hsbcad.com">Elementary changes in the behavior of the instance. Initial version for release V22</version>
/// <version value="1.3" date="22oct2018" author="thorsten.huck@hsbcad.com"> Inbox-694: add pitch and roof number </version>
/// <version value="1.2" date="26jul2018" author="thorsten.huck@hsbcad.com"> RS-142 eave verge tile added </version>
/// <version value="1.1" date="26jul2018" author="thorsten.huck@hsbcad.com"> RS-126 tile export supported as hardware for verge tiles and connecring verge tiles  </version>
/// <version value="1.0" date="27jun2018" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>


/// <insert Lang=en>
/// Select at least one roofplane with tile data assigned, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates an instance of verge tiles per roofplane and computes the quantity of the required tiles.
/// The roof plane needs to have a tile definition, the hsbTileGrid Tsl needs to be attached and the vertical tiling must be in range.
/// </summary>


// constants //region
	U(1,"mm");	
	double dEps = U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
//	bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));	
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	double pi = 3.14159265359;
	//endregion

// properties by settings
	int ncText = 7, ncHalfVerge = 12, ncVerge= 112, ncHalf, ncVergeRidge = 1, ncRidgeConnection=62, ncRidgeConnectionHalf=142,ncRidgeConnectionVerge=6;// colors
	int ntHalfVerge = 70, ntVerge= 80, ntHalf, ntVergeRidge = 70, ntRidgeConnection=90,ntRidgeConnectionHalf=90,ntRidgeConnectionVerge=90;// transparency


// bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		
	// prompt for roofplanes
		PrEntity ssErp(T("|Select roofplane"), ERoofPlane());
	  	if (ssErp.go())
			_Entity.append(ssErp.set());

	// create TSL
		for (int i=0;i<_Entity.length();i++) 
		{ 
			TslInst tslNew;				Vector3d vecXTsl= _XW;				Vector3d vecYTsl= _YW;
			GenBeam gbsTsl[] = {};		Entity entsTsl[] = {_Entity[i]};	Point3d ptsTsl[] = {};
			int nProps[]={};			double dProps[]={};					String sProps[]={};
			Map mapTsl;	
						
			tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
			 
		}//next i
		
		eraseInstance();	
		return;
	}	
// end on insert	__________________
	

// get roofplane from entity
	ERoofPlane rp;
	for (int i=0;i<_Entity.length();i++) 
	{ 
		ERoofPlane _rp = (ERoofPlane)_Entity[i]; 	
		if (_rp.bIsValid())
		{
			rp = _rp;
			
			TslInst tsls[] = rp.tslInstAttached();
			for(int j=0; j < tsls.length(); j++)
			{
				if( tsls[j] != _ThisInst && tsls[j].scriptName() == _ThisInst.scriptName() )
				{
					reportMessage("\n" + scriptName() + "-" + T("|already attached to roofplane.|"));
					eraseInstance();
					return;
				}
			}
			setDependencyOnEntity(rp);
			break;
		}
	}

// get some data from the roofplane
	CoordSys csRp = rp.coordSys();
	Vector3d vecX = csRp.vecX(), vecY = csRp.vecY(), vecZ = csRp.vecZ(),  vecYN=(vecY.crossProduct(_ZW)).crossProduct(-1*_ZW);
	Point3d ptOrg = csRp.ptOrg();
	Plane pnErp(ptOrg, vecZ);	
	_Pt0 = ptOrg;
	//_ThisInst.setAllowGripAtPt0(false);
	double dPitch = vecY.angleTo(vecYN);
	
// Adjust roof pitch for hardware
	double dPitchHW = dPitch * (180/pi);
	
// read distributions 
	Map mapExport=rp.subMapX("Hsb_TileExportData");
	Point3d ptsH[] = mapExport.getPoint3dArray("HorizontalDistribution");
	Point3d ptsV[] = mapExport.getPoint3dArray("VerticalDistribution");
	double dZOffsetTilePlane = mapExport.getDouble("ZOffsetTilePlane");
	Vector3d vecZEave = mapExport.hasVector3d("vecZEave") ?mapExport.getVector3d("vecZEave"): vecZ;
	int bSwapStaggered = mapExport.getInt("Staggered");
	double dAvHalf = mapExport.getDouble("dAvHalf");
	double dColumnWidth = mapExport.getDouble("ColumnWidth");
	PlaneProfile ppRoof = mapExport.getPlaneProfile("ppRoof");
	ppRoof.vis(5);
	
	if(ptsH.length() < 2 || ptsV.length() < 2)
	{
		reportMessage("\n" + T("|Unexpected error.|"));
		eraseInstance();
		return;		
	}
		
	Vector3d vecXAlign(ptsH[1] - ptsH[0]); vecXAlign.normalize();
	int bCanStagger = true;


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
		Group groups[] = _ThisInst.groups();
		if (groups.length()>0)
			sHWGroupName=groups[0].name();
	}//endregion

// Displays
	Display dpPlan(ncVerge);
	int nc=ncVerge, nt=ntVerge;
// get tile datas

// Get family data//region
	Map mapFamilyDefinition = rp.subMapX("Hsb_RoofTile").getMap("RoofFamilyDefinition");
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
	int nTileDistribution = mapFamily.getInt("TileDistribution"); 

// get standard tile	
	Map mapStandardTile = mapFamilyDefinition.getMap("StandardRoofTile");
	double dWidthStandard = mapStandardTile.getDouble("Width");
//	double dLengthStandard= mapStandardTile.getDouble("Length");

// get manufacturer data
	Map mapManufacturer = mapStandardTile.getMap("ManufacturerData");
	String sManufacturer = mapManufacturer.getString("Manufacturer");	
	String sFamilyColor = mapFamilyDefinition.getMap("Characteristic").getString("Colour");	

// get possible half tile
	String strAssemblyPath = _kPathHsbInstall+"\\Utilities\\RoofTiles\\RoofTilingManager.dll";  
	String strType = "hsbCad.Roof.TilingManager.Editor";
	String strFunction = "GetTiles";    
	String sNodeRoofTileWithFamily = "RoofTile[]\\RoofTile";	
//	String sNodeRoofTileWithFamily = "RoofTileWithFamily[]\\RoofTileWithFamily";	

	// collect special tile names from database
	Map mapIn;
	mapIn.setString("ManufacturerId",mapManufacturer.getString("ID"));
	mapIn.setString("RoofTileFamilyId",mapFamily.getString("Id"));
	mapIn.setInt("TileType", 7); 
	Map mapOut= callDotNetFunction2(strAssemblyPath, strType, strFunction, mapIn);	
	Map mapTiles = mapOut.getMap(sNodeRoofTileWithFamily);
	Map mapHalfTile = mapTiles;
//endregion
	

// Get roof topology and its subsets//region
	EdgeTileData edges[] = rp.edgeTileData();
	
// collect all opening roofplanes
	ERoofPlane rpOpenings[0];
	rpOpenings = rp.findContainingRoofplanes();
	
	for (int i=0;i<rpOpenings.length();i++)
	{
		ERoofPlane& _rp = rpOpenings[i];
		edges.append(_rp.edgeTileData());
	}
	//endregion

// Get subsets of topology//region
	EdgeTileData verges[0];
	EdgeTileData ridges[0];
	EdgeTileData eaves[0];

	for (int i=0;i<edges.length();i++) 
	{ 
		EdgeTileData edge = edges[i];

		if(edge.tileType() == _kTileLeft || edge.tileType() == _kTileLeftOpening ||edge.tileType() == _kTileRight ||edge.tileType() == _kTileRightOpening )
		{
			verges.append(edge);
			continue;
		}
		if(edge.tileType() == _kTileRidge || edge.tileType() == _kTileBottomOpening)
		{
			ridges.append(edge);
			continue;
		}
		if(edge.tileType() == _kTileEave || edge.tileType() == _kTileTopOpening)
		{
			eaves.append(edge);
		}
	}//endregion	
//endregion	


// declare a map collecting all verge results
	Map mapVerge, mapVerges, mapPtG;		
	String sSwapVerge = _Map.getString("sSwapVerge");
	
	for(int i=0; i < _PtG.length(); i++)
	{
		if(_kNameLastChangedProp == "_PtG"+i)
		{
			int nV = i / 2;
			String sV = nV;
			Map mapSwapSingle  = _Map.getMap("mapSwapSingle");
			Map mapvecPerp = _Map.getMap("mapVecPerp");
			Vector3d vecPerp = mapvecPerp.getVector3d(sV);
			Map mapAddHalf = _Map.getMap("mapAddHalf");;
			if(_Map.hasMap("mapPtG"))
				mapPtG = _Map.getMap("mapPtG");
			if(_PtG.length() != mapPtG.length())
				break;
			if(sSwapVerge.token(nV).atoi() < 2)
				break;
					
			double d = vecY.dotProduct(mapPtG.getPoint3d(i) - _PtG[i]);
	
			if(d < dEps && d > -dEps)
			{	
				(mapAddHalf.getInt(sV))? mapAddHalf.setInt(sV, false): mapAddHalf.setInt(sV, true);
				_Map.setMap("mapAddHalf", mapAddHalf);
					
				(mapSwapSingle.getInt(sV))? mapSwapSingle.setInt(sV, false): mapSwapSingle.setInt(sV, true);
				_Map.setMap("mapSwapSingle", mapSwapSingle);			
				break;
			}						
		}
	}	

	
// Trigger ChangeVerge
	int bChangeVerge = _Map.getInt("ChangeVerge");
	String sTriggerChangeVerge =bChangeVerge?T("|Reset verge|"):T("|Change verge|");
	addRecalcTrigger(_kContext, sTriggerChangeVerge);
	if (_bOnRecalc && _kExecuteKey==sTriggerChangeVerge)
	{
		bChangeVerge = bChangeVerge ? false : true;
		_Map.setInt("ChangeVerge", bChangeVerge);

		if(bChangeVerge == false)
		{
			_PtG.setLength(0);
			_Map.removeAt("mapSwapSingle", true);
			_Map.removeAt("mapPtG", true);
			_Map.removeAt("mapAddHalf", true);
		}					
	}
	
	// Trigger Half tiles
	int bAllowHalfTiles = _Map.hasInt("AllowHalfTileFillUp") ? _Map.getInt("AllowHalfTileFillUp") : true;
	String sTriggerAllowHalfTiles =bAllowHalfTiles? T("|Don´t fill up with half tiles|"):T("|Fill up with half tiles|");
	addRecalcTrigger(_kContext, sTriggerAllowHalfTiles);
	if (_bOnRecalc && _kExecuteKey==sTriggerAllowHalfTiles)
	{
		bAllowHalfTiles = !bAllowHalfTiles;
		_Map.setInt("AllowHalfTileFillUp", bAllowHalfTiles);				
	}
	
	
// Get Information from potential RidgeVerge Tsl if top verge has to be replaced
	Map mapRVConnectors;
	Map mapReplaceHalf;
	Map mapVergeTops;
	Map mapTilesToSubtract;
	
	PlaneProfile ppPositioning = mapExport.getPlaneProfile("ppPositioning");
	PlaneProfile ppHalfs;
	
	{ 
		//Map mapRidgeData = rp.subMapX("mapRidgeData");
		Map mapRidgeData = mapExport.getMap("mapRidgeData");
		if(mapRidgeData.getEntity("ChildTsl").bIsValid())
		{
			mapRVConnectors = mapRidgeData.getMap("mapRvConnectors");	
			mapReplaceHalf = mapRidgeData.getMap("mapReplaceHalf");
		}		
	}
	

// Loop verges//region
	for (int v=0;v < verges.length();v++) 	
	{ 	
	// declare edge and get tile data//region
		EdgeTileData edge = verges[v];
		Map mapEdge= edge.tileMap();
		Map mapRoofTiles = mapEdge.getMap("Rooftile[]");			
		LineSeg seg = edge.segment(); seg.vis(v+1);
		double dEdgeOffSet = mapEdge.getDouble("Offset");
		
		// get connected ridge edge to get the size of the last tile of the verge.
		Map mapRidge;
		for(int r = 0; r < ridges.length(); r++)
		{
			LineSeg segRidge = ridges[r].segment();
			if( Vector3d(seg.ptEnd() - segRidge.ptEnd()).length() < U(0.5) || Vector3d(seg.ptEnd() - segRidge.ptStart()).length() < U(0.5) || 
			    Vector3d(seg.ptStart() - segRidge.ptEnd()).length() < U(0.5) || Vector3d(seg.ptStart() - segRidge.ptStart()).length() < U(0.5))
		    	{
			    	mapRidge = ridges[r].tileMap();
			    	break;
		    	}
		}
		
		// get connected eave edge to get the distribution of the eave tile.
		Map mapEave;
		for(int r = 0; r < eaves.length(); r++)
		{
			LineSeg segEave = eaves[r].segment();
			if( Vector3d(seg.ptEnd() - segEave.ptEnd()).length() < U(0.5) || Vector3d(seg.ptEnd() - segEave.ptStart()).length() < U(0.5) || 
			    Vector3d(seg.ptStart() - segEave.ptEnd()).length() < U(0.5) || Vector3d(seg.ptStart() - segEave.ptStart()).length() < U(0.5))
		    	{
			    	mapEave = eaves[r].tileMap();
			    	break;
		    	}
		}
		
		double dEaveTile = mapRoofTiles.getMap(0).getDouble("DistanceToTopOfLathKey");
		
		Vector3d vecDir,vecPerp;
		vecDir = seg.ptEnd() - seg.ptStart();vecDir.normalize();
		vecPerp = vecZ.crossProduct(vecDir);
		
		Map mapVecPerp = _Map.getMap("mapVecPerp");
		mapVecPerp.setVector3d(v, vecPerp);
		_Map.setMap("mapVecPerp", mapVecPerp);
		vecPerp.vis(seg.ptMid(), edge.tileType());	
		
		seg.transformBy(vecPerp * dEdgeOffSet);
		Point3d ptsSeg[] ={ seg.ptStart(), seg.ptEnd()};	
		
	// Check if edge has more than one point
		Line lnDir(seg.ptMid(), vecY);	
		LineSeg segRoof = ppRoof.extentInDir(vecY); 
		
		if(ptsV.length() > 1)
		{
			ptsV.append(segRoof.ptStart());						
		}

		ptsV = Line(segRoof.ptMid(), vecY).orderPoints(ptsV);
		
		ptsSeg = lnDir.orderPoints(ptsSeg);
		if (ptsSeg.length() < 2)continue;
		seg = LineSeg(ptsSeg[0], ptsSeg[1]); seg.vis(4);
		
	// Distance from top lath to ridge. A standard tile or a ridge connection can give the value
		String sV = v;
		double dLAF = mapRoofTiles.getMap(0).getMap("VerticalTilingDefinition").getDouble("RidgeBattenDistance");
		int nUseRVCons = -1;
				
		for (int i = 0; i < mapRVConnectors.length(); i++)
		{
			if (mapRVConnectors.keyAt(i).atoi() == v && mapRVConnectors.getMap(sV).length() >0)
				{
					dLAF = mapRVConnectors.getDouble("dLAF");
					nUseRVCons = v;
					break;
				}
		}
		
		double dDTop = vecY.dotProduct(segRoof.ptEnd() - ptsV.last());
		if(dDTop - dLAF > U(1))
			ptsV.append(segRoof.ptEnd() - vecY*dLAF);;
		
		
		double dDistInPitch = dZOffsetTilePlane * tan(dPitch);
		Vector3d vecTop;
		
		if(vecY.dotProduct(ptsV.last() - ptsSeg[1]) < dDistInPitch + U(5))
		{
			vecTop = _ZW;
		}
		else
			vecTop = vecZEave;

	// get a pline representing the edge, stretch a tiny litlle bit to catch intersecting points		
		LineSeg segV(Line(ptsSeg[0] - vecY * U(5), vecZEave).intersect(pnErp, dZOffsetTilePlane), Line(ptsSeg[1] + vecY * U(5), vecTop).intersect(pnErp, dZOffsetTilePlane));	
		
	// Get width of current column//region
		double dLastColumnWidth;
		double dDistToColumn;
		{
			Vector3d vecPt (ptsH[0] - ptsH[1]);
			vecPt.normalize();
			Point3d pt = seg.ptMid() ;
			pt.vis(v);
			
			for (int p=0;p<ptsH.length()-1;p++) 
			{ 
				Point3d ptA = ptsH[p];
				Point3d ptB = ptsH[p + 1];
				
				double dB = vecPt.dotProduct(pt - ptB);
				double dA = vecPt.dotProduct(ptA-pt);
				
				double dd = - vecPerp.dotProduct(pt - ptA) - 2 * dEps;
			
				if (dA>-dEps && dB> -dEps)
				{
					dDistToColumn = (-vecPerp.dotProduct(pt - ptA)-2*dEps > 0) ? dA : dB;
					dLastColumnWidth = vecPt.dotProduct(ptA - ptB);
					break;
				}			
			}
		}//endregion
		
		
	// Collect unique widths and all tiles data//region
		double dWidths[0],dUniqueWidths[0]; 
		double dVerticalMinSpacings[0],dVerticalMaxSpacings[0];
		double dTileWidth, dTileWidth1;
		double dVMaxTop = vecY.dotProduct(ptsV.last() - ptsSeg.last()); 
		double dVMaxBottom = vecY.dotProduct(ptsSeg[0] - ptsV[0]); 
		int bAppended;
		
		
		for (int i=0;i<mapRoofTiles.length();i++) 
		{ 
		// tile data
			Map m = mapRoofTiles.getMap(i);
				
		
		// verge tile width
			dTileWidth = m.getMap("HorizontalTileSpacing").getDouble("Minimum");	
			dTileWidth1 = m.getMap("HorizontalTileSpacing").getDouble("Maximum");			
			
		// replace width by full/half width of current column if found
			double dWidth = (dTileWidth + dTileWidth1) * 0.5;
			if (dColumnWidth>0) 
				if(dColumnWidth+dEps > dTileWidth && dColumnWidth < dTileWidth1+dEps)	
					dWidth = dColumnWidth;	
					
		// If verge has a Standard or half tile and is on the right side the width has to be extended
			if(m.getInt("TileType") == 0 || m.getInt("TileType") == 7)
			{
				if( !vecPerp.isCodirectionalTo(vecX))
				{
					double dw = dWidth > dTileWidth-dEps && dWidth < dTileWidth1+dEps ? dWidth : (dTileWidth + dTileWidth1) / 2;
					double dAdd = m.getDouble("Width") - dw;
					dWidth += dAdd;
				}
			}
			
			if (dUniqueWidths.find(dWidth)<0)
				dUniqueWidths.append(dWidth);
			dWidths.append(dWidth);

		// vertical tiling
			dVerticalMinSpacings.append(m.getDouble("VerticalTilingDefinition\\VerticalTileSpacing\\Minimum"));
			dVerticalMaxSpacings.append(m.getDouble("VerticalTilingDefinition\\VerticalTileSpacing\\Maximum"));	
			
			if(dVerticalMaxSpacings.last() > dEps && ! bAppended)
			{
				dVMaxTop += dVerticalMaxSpacings.last();		
				dVMaxBottom += dVerticalMaxSpacings.last();
				bAppended = true;
			}
		}	
		
		if(dUniqueWidths.length() < 1)
			continue;
		
	//Swap verge tiles if single verge is changed and half tiles are added
		int bSwapSingle;
		{ 
			String sV = v;
			if( _Map.getMap("mapSwapSingle").getInt(sV))
				bSwapSingle = true;		
		}
		

	// Transform verge tiles to the next column and make sure they fit for calculation
		double dMove = U(2000);
		double dUsedVerge;
		int bMoveChanged;
		
		for(int i=0; i < dUniqueWidths.length(); i++)
		{		
			double d1 = abs(dDistToColumn - dUniqueWidths[i]);
			double d2 = abs(dMove);
			
			if(d1 < d2)
			{
				dMove = dDistToColumn - dUniqueWidths[i] - dEdgeOffSet;	
				dUsedVerge = dUniqueWidths[i];
			}
		}
		
		
		int nSign = (dMove >= 0) ? 1 : - 1;
		double dCheckHalf = dUsedVerge + dMove - nSign * dColumnWidth;
		int bCheckHalf = true;
		if (abs(dUsedVerge - dCheckHalf) < abs(dCheckHalf - dAvHalf)) bCheckHalf = false;
		dMove = (dUsedVerge > dColumnWidth && abs(dMove) + dEps > dColumnWidth && bCheckHalf) ? dMove - nSign*dColumnWidth : dMove;
	
			
		if( dUniqueWidths.length() == 1 && dAvHalf > dEps && abs(abs(dMove) - dAvHalf) < abs(dMove))
		{
			dMove += (dMove < 0) ? dAvHalf : - dAvHalf;
			if(bCanStagger)			
				bMoveChanged = true;
		}
		
		if(abs(dMove + dEdgeOffSet) > U(0.5))
		{
			segV.transformBy(vecPerp * dMove);	segV.vis(5);			
		}


	// String is used to avoid swaping verges with only full tiles
		sSwapVerge = _Map.getString("sSwapVerge");

		if(sSwapVerge.tokenize(";").length() < verges.length())
		{
			if(sSwapVerge.tokenize(";").length() < 1)
				sSwapVerge = dUniqueWidths.length() + ";";
			else
				sSwapVerge += dUniqueWidths.length() + ";";
			_Map.setString("sSwapVerge", sSwapVerge);			
		}
		
		if(sSwapVerge.token(v).atoi() != dUniqueWidths.length())
		{
			String sTokens[] = sSwapVerge.tokenize(";");
			sSwapVerge = " ";

			for(int i=0; i < sTokens.length(); i++)
			{
				if( i != v)
					sSwapVerge += sTokens[i] + ",";
				else
					sSwapVerge += dUniqueWidths.length() + ";";
			}
			_Map.setString("sSwapVerge", sSwapVerge);		
			_Map.removeAt("mapAddHalf", true);
		}
		
		int nI = v*2;
			
	// Created PtGs for the first time
		if(bChangeVerge && _PtG.length() <= nI)
		{
			_PtG.append(segV.ptStart());
			_PtG.append(segV.ptEnd());
		}
	
	// Change verge length if PtGs are existing
		if( _PtG.length() > nI)
		{
			double dVMax = U(5);
//			LineSeg segV1(segV.ptStart() - vecDir * dVMax, segV.ptEnd() + vecDir * dVMax);
			LineSeg segV1(segV.ptStart() - vecY * dVMaxBottom, segV.ptEnd() + vecY * dVMaxTop); 
			_PtG[nI] = segV1.closestPointTo(_PtG[nI]);
			_PtG[nI + 1] = segV1.closestPointTo(_PtG[nI + 1]);				
			segV = LineSeg(_PtG[nI], _PtG[nI + 1]);
		}
		
		PLine plSeg(segV.ptStart(), segV.ptEnd());	

	// Collectors of tile data and swap stagger//region
		int nNumUniqueWidth = dUniqueWidths.length();
		int nQuantities[dWidths.length()];	
	
	// Distribution is staggered and only full verge tiles are used
		int bHalfInLine[2];
		int bAddHalf;

		if(nTileDistribution == 1 || nTileDistribution == 2)
		{
			if(nNumUniqueWidth > 0 && nTileDistribution != 2)
				bHalfInLine[0] = 1;
			if(nNumUniqueWidth > 1)
				bHalfInLine[1] = 1;	
			if(nTileDistribution == 2 && bMoveChanged)
			{
				bHalfInLine[0] = 1;	
				bHalfInLine[1] = 1;	
			}
			
			if(nNumUniqueWidth == 1)
			{
				Map mapAddHalf = _Map.getMap("mapAddHalf");
				mapAddHalf.setInt(v, true);		
				_Map.setMap("mapAddHalf", mapAddHalf);
			}
		}
		else if(dAvHalf > dEps && abs(dUsedVerge - dDistToColumn - dAvHalf) < U(0.5))
		{
			bHalfInLine[0] = 1;
			bHalfInLine[1] = 1;
			bAddHalf = true;
		}

	// Swap unique verge tiles if distribution starts with half verges
		if (!bSwapStaggered && dUniqueWidths.length()==2)
				dUniqueWidths.swap(0,1);

		if((nTileDistribution == 1 || nTileDistribution ==2 ) && _Map.hasMap("mapAddHalf"))
		{
			Map mapAddHalf = _Map.getMap("mapAddHalf");
			String sV = v;
			bAddHalf = mapAddHalf.getInt(sV);
		}

	
	// Loop vertical grip points, distribute eave to top//region
		Point3d pts[0]; pts = ptsV;	
				
		int n, s; 
		Point3d ptPL1,ptPL2;
		double dLength; 
		Map mapRow, mapRows;
		int nQuantitiesHalf;
		int nSubFull;
		Point3d ptsCheck[0];
		PlaneProfile ppCheck;
		int nRVCons = -1;
		Map mapTopVerge;
		int bLastVergeTile;
		
		double dRidgeConMin, dRidgeConMax;
		
		if(mapRidge.length() > 0)
		{
			Map mapTiling = mapRidge.getMap("RidgeConnectionDefinition[]").getMap("RidgeConnectionDefinition").getMap("VerticalTilingDefinition");
			if(mapTiling.length())
			{
				Map mapSpacing = mapTiling.getMap("VerticalTileSpacing");
				
				if(mapSpacing.length())
				{
					dLAF = mapTiling.getDouble("RidgeBattenDistance");	
					dRidgeConMin = mapSpacing.getDouble("Minimum");
					dRidgeConMax = mapSpacing.getDouble("Maximum");
				}				
			}
		}
		
		double dEaveMin, dEaveMax;
		
		if(mapEave.length() > 0)
		{
			Map mapSpacing = mapEave.getMap("EavesDefinition").getMap("VerticalTilingDefinition").getMap("VerticalTileSpacing");

			if(mapSpacing.length())
			{
				dEaveMin = mapSpacing.getDouble("Minimum");
				dEaveMax = mapSpacing.getDouble("Maximum");
			}				
		}
		
		double dPrevVergeLength = 0;
		for (int p = 0; p < pts.length()-1; p++)
		{					
		// find valid intersection with edge		
			Point3d ptsA[] = plSeg.intersectPoints(Plane(pts[p], vecDir)); 	
			Point3d ptsB[] = plSeg.intersectPoints(Plane(pts[p + 1], vecDir));	 
						
			int bReplaceHalf;
			

			if(ptsB.length() < 1 && ptsA.length() >0 && s >0)
			{
				if(vecY.dotProduct(plSeg.ptEnd() - ptsA[0]) > dLAF  + U(5)+dEps)	
				{
					ptsB.append(plSeg.ptEnd());
				}	
				bLastVergeTile = true;
			}
			

			if (ptsB.length() < 1 )
			{
			// increment/set index
				n++;
				if (n > dUniqueWidths.length() - 1)n = 0;
				bHalfInLine.swap(0, 1);
				if (s>0) break;
				continue;				
			}

			if(ptsA.length()< 1)
			{			
				double dist = dLAF > dEps ? dLAF : U(15);
				
				if(vecY.dotProduct(ptsB[0] - plSeg.ptStart()) > dist)
				 	ptsA.append(plSeg.ptStart());
				else
				{
				// increment/set index
					n++;
					if (n > dUniqueWidths.length() - 1)n = 0;
					bHalfInLine.swap(0, 1);
					continue;					
				}
			}

		//	Get location and dimensions on the edge
			Point3d ptA = ptsA[0], ptB = ptsB[0]; 

			dLength=abs(vecDir.dotProduct(ptB - ptA));			
			if (dLength < dEps)continue;
			
			if(p < pts.length() -2)
			{
				Point3d ptsC[] = plSeg.intersectPoints(Plane(pts[p + 2], vecDir));	 
				
				if(ptsC.length() > 0)
				{
					if(ptsC.length() < U(1) || ptsB.length() > 0 &&  vecY.dotProduct(ptsC[0] - ptsB[0]) < dLAF + dEps )
					{
						bLastVergeTile = true;					
					}					
				}								
			}			
			else if(dRidgeConMax > dEps && dRidgeConMin - dEps < dLength && dRidgeConMax + dEps > dLength)
			{
				bLastVergeTile = true;	
			}
			
		// Points to adjust _PtGs later on	
			if(s == 0)
			{
				ptPL1 = ptA;
				s++;
			}
			else
				s++;
				
			ptPL2 = ptB; 

		// The first verge tile at the first eave can not be choosen by length. It needs to be choosen by the second tile length !!	
			if(s==1 )
			{
			// Adjust sequence or add half tiles to the verges
				int bArgument1 = p%2 ==0 &&  (dUniqueWidths[n] > dUsedVerge + dEps || dUniqueWidths[n] < dUsedVerge - dEps);
				int bArgument2 = p%2 ==1 &&  (dUniqueWidths[n] < dUsedVerge + dEps && dUniqueWidths[n] > dUsedVerge - dEps);
				if(p%2 == 0)
					bHalfInLine.swap(0, 1);
					
				int bSwap = ((bArgument1 || bArgument2) && bMoveChanged) ? false : true;
				
			// Adjustment for staggered tiles
				if(nTileDistribution == 1)
				{
					if(bSwap && (bArgument1 || bArgument2  || bMoveChanged))
						if(dUniqueWidths.length() > 1)
							n = (n == 0) ?  1 : 0;
					else	 
						bHalfInLine.swap(0, 1);		
						
				// Swap sequence if single verge is swaped		
					if(dUniqueWidths.length() > 1 && bSwapSingle)
							n = (n == 0) ?  1 : 0;	
				}

			// Adjust length of 1st verge if more than one verge of the same width can be choosen
				Point3d ptsA1[0];
				Point3d ptsB1[0];
				if (pts.length() > p + 2)
				{
					ptsA1 = plSeg.intersectPoints(Plane(pts[p+1], vecDir));
					ptsB1 = plSeg.intersectPoints(Plane(pts[p + 2], vecDir));						
				}
				
				if (p > 1  && pts.length() <= p + 4 )
				{
					ptsA1.insertAt(0, pts[p]);
					ptsB1.insertAt(0, pts[p+1]);					
				}
	
				if(ptsA1.length()>0 && ptsB1.length()>0 )
				{
					dLength = abs(vecDir.dotProduct(ptsB1[0] - ptsA1[0]));	
				}					
			}	
			
		// The last verge can be a ridge verge connetion tile with different length, that needs a special check
			if(bLastVergeTile || p == pts.length()-2)
			{
				if (nUseRVCons > -1)
				{
					nRVCons = nUseRVCons;
				}
		
				for(int i=0; i < mapReplaceHalf.length(); i++)
				{
					if(mapReplaceHalf.keyAt(i).atoi() == v)
					{
						bReplaceHalf = mapReplaceHalf.getInt(sV);
						break;
					}
				}	
				
				if(p > 1 && !bLastVergeTile)
					dLength = vecY.dotProduct(pts[p] - pts[p-1]);
			}
			
			//Verges should have a bigger length to be counted.
			if (dLength < U(15)) continue;
			
			double dWidth = dUniqueWidths[n];	
			int nInd = -1;
			
			double dUsedMinV;
			
		
		// distinguish between 9er and 11er: the widths array coaligns with dVerticalMinSpacings	
			if(dWidths.length() > 1)
			{	
				for (int j=0;j<dWidths.length();j++) 
				{ 
					double dVerticalMinSpacing = dVerticalMinSpacings[j];
					double dVerticalMaxSpacing = dVerticalMaxSpacings[j];

					if (dLength<dVerticalMinSpacing-dEps || dLength>dVerticalMaxSpacing+dEps)
					{ 	
						if(!bLastVergeTile || bLastVergeTile && (dPrevVergeLength < dVerticalMinSpacing-dEps || dPrevVergeLength > dVerticalMaxSpacing+dEps) )
						{
							continue;							
						}
					}
				
					if(dWidths[j] < dUniqueWidths[n] +dEps && dWidths[j] > dUniqueWidths[n] - dEps)
					{
						nInd = j;	
						dUsedMinV = dVerticalMinSpacing;
						dPrevVergeLength = dLength;
						break;
					}			
				}
			}			
			else 
			{
				if (bLastVergeTile || (dVerticalMinSpacings[0]>0 && dVerticalMaxSpacings[0]>0 && (dLength<dVerticalMaxSpacings[0]+dEps && dLength>dVerticalMinSpacings[0]-dEps)))
					nInd = 0;
			}
			
			if(s==1 && nInd == -1)
			{
				continue;				
			}

			if(nInd == -1 )
			{
				break;
			}

			nc=ncVerge;
			nt = ntVerge;
			
			if(nRVCons == -1)
				nQuantities[nInd]++;
			
		// Check if ptA is to fare outside the verge
			if(vecPerp.dotProduct(seg.ptMid()-ptA) > dAvHalf - U(10))
			{
				ptA += vecPerp * dAvHalf;
				ptB += vecPerp * dAvHalf;
			}		
			
			// Make the first verge longe, so it fit´s to the overhang at the eave
			if(s==1 &&  ppRoof.pointInProfile(segV.ptStart() - vecY*U(10)) == 1)
			{
				double dPointDist = vecY.dotProduct(ptB - ptA); ppRoof.vis(5);
			
				if(dEaveMin > dEps)
				{
					double dEaveLength = dEaveMin;
				
					if(dEaveMax -dEaveMin > dEps)
					{
						Map mapSpacing = mapRoofTiles.getMap("VerticalTileDefinition").getMap("VerticalTileSpacing");
						if(mapSpacing.length() > 0)
						{
							double dPCTiles = (mapSpacing.getDouble("Maximum") - mapSpacing.getDouble("Minimum")) / (vecY.dotProduct(ptB - ptA) - mapSpacing.getDouble("Minimum"));
							dEaveLength += (dEaveMax - dEaveMin) * dPCTiles;
						}
					}	
					
					ptA -= vecY * (dEaveTile - dEaveLength);
				}
				else
				{
					double dFirst = dEaveTile - dPointDist;
					if(dFirst > U(-10))
					{
						ptA -= vecY * dFirst;					
					}					
				}
			}

			LineSeg segTile(ptA, ptB + vecPerp * dWidth); segTile.vis(2);
			PLine plRec;
			plRec.createRectangle(segTile, vecDir, vecPerp);
			PlaneProfile ppTile(CoordSys(ptA, vecX, vecY, vecZ)); ppTile.joinRing(plRec, _kAdd);
			
			dpPlan.color(nc);
			if(nRVCons > -1)
				dpPlan.color(82);
				
			if (nt>0 && nt<100)	dpPlan.draw(ppTile, _kDrawFilled, nt);
				dpPlan.draw(ppTile);
			
		// PlaneProfile for positioning special tiles
			ppPositioning.subtractProfile(ppTile);
				
			if(ppCheck.area() < dEps)
				ppCheck = ppTile;
			else
				ppCheck.unionWith(ppTile);
				
		// increment/set index of staggered
			n++;
			if (n>dUniqueWidths.length()-1)n = 0;	
			
			double dCheck = dWidth;
			Point3d ptSegEnd = segTile.ptEnd();
			
			if(bAllowHalfTiles && bHalfInLine[0] &&  bAddHalf && !bReplaceHalf)
			{
				ptSegEnd += vecPerp * dAvHalf;
				
				Point3d ptC = ptA + vecPerp * dWidth;
				LineSeg segHalf(ptC, ptB + vecPerp * (dWidth + dAvHalf));
				PLine plHalf;
				plHalf.createRectangle(segHalf, vecDir, vecPerp);
				PlaneProfile ppHalf(CoordSys(ptC, vecX, vecY, vecZ)); ppHalf.joinRing(plHalf, _kAdd);
				
			// Check if special tiles are at the position of the half tiles
				int nContinue;
				
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
				ppSpecials.vis(4);
				
			// validate roofplane
				if (!rp.bIsValid())
				{
					reportMessage("\n" + scriptName() + ": " +T("|no valid roofplane found|"));
					eraseInstance();
					return;	
				}	
				
				if(ppSpecials.area() > dEps)
				{
					PlaneProfile ppHalf1 = ppHalf;
					ppHalf1.intersectWith(ppSpecials);
					if(ppHalf1.area() > dEps)
						nContinue = true;
				}
				
				if(! nContinue)
				{
					dpPlan.color(44);
					if (nt>0 && nt<100)	dpPlan.draw(ppHalf, _kDrawFilled, nt-30);
						dpPlan.draw(ppHalf);
					
					if(ppHalf.area() < dEps)
						ppHalfs = ppHalf;
					else	
						ppHalfs.unionWith(ppHalf);
					
					ppCheck.unionWith(ppHalf);
					
				// PlaneProfile for positioning special tiles
					//ppPositioning.subtractProfile(ppHalf);
										
					dCheck += dAvHalf;				
					nQuantitiesHalf++;		
					
				// if Verge is a full tile and a half tile is added two tiels have to be subtracted
					int nTileType = mapRoofTiles.getMap(nInd).getInt("TileType");
					if(nTileType == 1 || nTileType == 2)
						nSubFull++;
				}
			}

			mapTopVerge.setPoint3d("ptStart", segTile.ptStart()); 
			mapTopVerge.setPoint3d("ptEnd", segTile.ptEnd()); 
			mapTopVerge.setInt("TileType", mapRoofTiles.getMap(nInd).getInt("TileType"));
			(bHalfInLine[0] && bAddHalf) ? mapTopVerge.setDouble("AddHalf", dAvHalf) : mapTopVerge.setDouble("AddHalf", 0);
	
			
		// Swap	Tiles if staggered			
			bHalfInLine.swap(0, 1);
			
			if(bLastVergeTile)
				break;
		}	//next p//endregion

		mapVergeTops.appendMap("mapTopVerge", mapTopVerge);
		
		Map mapCheck;// = _Map.getMap("mapCheck");
		mapCheck.setPlaneProfile(v, ppCheck);
		_Map.setMap("mapCheck", mapCheck);
		
		
		if(_PtG.length()> nI)
		{
			_PtG[nI] = ptPL1;
			_PtG[nI + 1] = ptPL2;
			
			mapPtG.setPoint3d(nI, _PtG[nI]);
			mapPtG.setPoint3d(nI + 1, _PtG[nI + 1]);
		}
		
		int nHardWareRun = nQuantities.length();
		if(nQuantitiesHalf > 0)
			nHardWareRun ++;
		if(nRVCons != -1)
			nHardWareRun++;

	// Add hardware of all detected verge tiles //region
		for (int i = 0; i < nHardWareRun; i++)
		{
			int nQty;
			Map m;
			if(i < nQuantities.length())
			{
				nQty = nQuantities[i];
				 m = mapRoofTiles.getMap(i);
				 int nType = m.getInt("TileType");
				 nSubFull += nQty;
				 
			}
			else if ( nQuantitiesHalf > 0 && i == nQuantities.length())
			{
				nQty = nQuantitiesHalf;
				m = mapHalfTile;
			}
			else if(nRVCons != -1)
			{
				String sRVCons = nRVCons;
				nQty = 1;
				m = mapRVConnectors.getMap(sRVCons);
				nSubFull++;
			}
			
			
			if (nQty < 1) continue;
			{ 
				//Map m = mapRoofTiles.getMap(i);
				HardWrComp hwc(m.getString("ArticleNumber"), nQty); // the articleNumber and the quantity is mandatory
				
				hwc.setManufacturer(mapManufacturer.getString("Manufacturer"));
				
				hwc.setModel(sFamilyName);
				hwc.setName(m.getString("Name"));//		hwc.setDescription("");
				hwc.setMaterial(mapFamilyDefinition.getString("Characteristic\Surface") + " " + mapFamilyDefinition.getString("Characteristic\Colour"));//		
				hwc.setNotes(rp.roofNumber());

				hwc.setGroup(sHWGroupName);
				hwc.setLinkedEntity(rp);	
				hwc.setCategory(T("|Rooftiles|"));
				hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
				
				hwc.setDScaleX(m.getDouble("Length"));
				hwc.setDScaleY(m.getDouble("Width"));
				hwc.setDScaleZ(0);
				
				hwc.setDAngleA(dPitchHW);
				
			// apppend component to the list of components
				hwcs.append(hwc);					
			}
		}//endregion
		
	//Collect amount of full tiles to subtract from tile grid
		mapTilesToSubtract.setInt("FullTile", (nSubFull + mapTilesToSubtract.getInt("FullTile")));	
		
	}//next v
	
	if(hwcs.length() < 1)
	{
		reportMessage(T("|No verge tile in distribution range found. Instance erased|"));
		eraseInstance();
		return;
	}
	
	

	
// Check if verge tiles overlap. If draw inner verges magenta
	Map mapCheck = _Map.getMap("mapCheck");
			
	for(int i=0; i < mapCheck.length(); i++)
	{
		for(int j= i+1; j< mapCheck.length();j++)
		{
			PlaneProfile ppCheck = mapCheck.getPlaneProfile(i);
			PlaneProfile ppCheck1 = mapCheck.getPlaneProfile(j); 
	
			if(ppCheck1.intersectWith(ppCheck))
			{
				reportMessage(T("|Vergetiles overlap. Change verge!|"));
				Display dpCheck(6);
				PlaneProfile ppCheck2 = mapCheck.getPlaneProfile(j);
				dpCheck.draw(ppCheck, _kDrawFilled, 70);
				dpCheck.draw(ppCheck2);
			}		
		}
	}
			
	_ThisInst.setHardWrComps(hwcs);
	
	if(mapPtG.length() > 0)
		_Map.setMap("mapPtG", mapPtG);
		

// store the verges map in subMapX of the roofplane 
	if (mapVergeTops.length()>0)
	{ 
		Map mapX;
		mapX.setEntity("ParentTsl", _ThisInst);
		mapX.setMap("VergeTops[]", mapVergeTops);
		mapExport.setMap("VergeEdgeData", mapX);
		//rp.setSubMapX("VergeEdgeData", mapX);
		rp.transformBy(Vector3d(0, 0, 0));
	}
	
	if(ppHalfs.area() >0)
		mapExport.setPlaneProfile("ppHalfs", ppHalfs);
	mapExport.setPlaneProfile("ppPositioning", ppPositioning);
	rp.setSubMapX("hsb_TileExportData", mapExport);
	
// Add tiles to subtract from amount of hsbTileGrid
	_Map.setMap("TilesToSubtract", mapTilesToSubtract);

//endregion

#End
#BeginThumbnail









#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS">
        <int nm="BREAKPOINT" vl="862" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-16994: Bugfix first verge tile not shown. Added functionality to add half tiles if needed" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="11/8/2022 12:09:14 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Test to avoid error message" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="11/8/2022 11:09:58 AM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End