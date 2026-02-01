#Version 8
#BeginDescription
/// <version value="1.7" date="05apr19" author="nils.gregor@hsbcad.com"> The positioning height of the edge laths is now taken from the hsbTileHipRidge instance </version>

This tsl creates a tile lath distribution
Existing lath don´t react on changes to the roof plane.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 7
#KeyWords Tile;Lath
#BeginContents
/// <History>//region

/// <version value="1.7" date="05apr19" author="nils.gregor@hsbcad.com"> The positioning height of the edge laths is now taken from the hsbTileHipRidge instance </version>
/// <version value="1.6" date="13aug2018" author="thorsten.huck@hsbcad.com"> RS-125, no ridge battens for shed roofs </version>
/// <version value="1.5" date="03aug2018" author="thorsten.huck@hsbcad.com"> RS-125, creating hip and ridge battens </version>
/// <version value="1.4" date="20jul2018" author="thorsten.huck@hsbcad.com"> RS-141 </version>
/// <version value="1.3" date="11jul2018" author="thorsten.huck@hsbcad.com"> RS-123, RS-119 </version>
/// <version value="1.2" date="06jul2018" author="thorsten.huck@hsbcad.com"> RS-121, RS-120, RS-119, RS-122 </version>
/// <version value="1.1" date="22may2018" author="thorsten.huck@hsbcad.com"> reporting if lath definition is missing </version>
/// <version value="1.0" date="18jan2018" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select roofplane, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates a tile lath distribution
/// Existing lath don´t react on changes to the roof plane.
/// </summary>//endregion

// constants //region
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));
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
	//endregion

	String sMaterialName=T("|Material|");	
	PropString sMaterial(nStringIndex++, "C24", sMaterialName);	
	sMaterial.setDescription(T("|Defines the Material|"));
	sMaterial.setCategory(category);

// Verge
	category = T("|Verge|");
	String sVergeOffsetName=T("|X-Offset|");	
	PropDouble dVergeOffset(nDoubleIndex++, U(0), sVergeOffsetName);	
	dVergeOffset.setDescription(T("|Defines the Verge Offset|"));
	dVergeOffset.setCategory(category);
		

// extrusion overrides for eave lath
	category = T("|Eave|");
	String sProfiles[] = ExtrProfile().getAllEntryNames();
// remove round
	{ 
		int n = sProfiles.find(T("|Round|"));
		if (n>-1)
			sProfiles.removeAt(n);
	}
	
// order profiles
	for (int i=1;i<sProfiles.length();i++)
		for (int j=1;j<sProfiles.length()-1;j++)
		{
			String s1 = sProfiles[j];
			String s2 = sProfiles[j+1];
			if (s1.makeLower()>s2.makeLower())
				sProfiles.swap(j,j+1);	
		}
	String sProfileName=T("|Extrusion Profile|" + T(" |Override|"));	
	PropString sProfile(nStringIndex++, sProfiles, sProfileName);
	sProfile.setCategory(category);	


	int ncLath = 35;
	int ncHipLath=225 , ncRidgeLath = 145;


// bOnInsert//region
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		String sKey = _kExecuteKey;
		sKey.makeUpper();

	// flag erase lath mode
		int bErase = sKey.find("ERASELATH",0) >- 1;

	// flag split lath mode
		int bSplit = sKey.find("SPLITLATH",0) >- 1;

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
		
	// prompt for roofplanes
		PrEntity ssErp(T("|Select roofplane(s)|"), ERoofPlane());
	  	if (ssErp.go())
			_Entity.append(ssErp.set());
				
		
	// prompt for entities
		Beam beams[0];
		
	// erase	
		if (bErase || bSplit)
		{
		// collect handles of roofplanes
			String sHandles[0];
			for (int i=0;i<_Entity.length();i++) 	
				sHandles.append(_Entity[i].handle());			
			
		// select lathes	
			PrEntity ssE(T("|Select lath(s)|") + T("|<Enter> = all|"), Beam());
			Entity ents[0];
			if (ssE.go())
				ents = ssE.set();
	
		// select all		
			if (ents.length()<1)
				ents = Group().collectEntities(true, Beam(), _kModelSpace);
		
		// append only those which are tagged to be lathes
			for (int i=0;i<ents.length();i++) 
			{ 
				Beam b= (Beam)ents[i]; 
				if (sHandles.find(b.subLabel2())>-1)
					beams.append(b);
				 
			}//next i
		}
	// split
		if (bSplit)
		{
		// prompt for splitting locations
			while(1)
			{ 
				PrPoint ssP(TN("|Select point|")); 
				if (ssP.go()==_kOk) 
				{
					Point3d ptSplit=ssP.value();
				
				// split every lath
					Beam bmSplits[0];
					for (int i=0;i<beams.length();i++) 
					{ 
						Beam& bm = beams[i];
						Vector3d vecX = bm.vecX();
						double dL = bm.solidLength();
						
						if (abs(vecX.dotProduct(ptSplit-bm.ptCenSolid()))<.5*dL)
						{ 
							Beam bmSplit;
							bmSplit = bm.dbSplit(ptSplit, ptSplit);
							if (bmSplit.bIsValid())
								bmSplits.append(bmSplit);
						} 
					}//next i
					reportMessage("\n" + bmSplits.length() + T(" |lathes have been split.|"));
					beams.append(bmSplits);
					
				}
				else
					break;
				
				eraseInstance();
				return;	
			}	
		}		

	// create TSL
		TslInst tslNew;				
		GenBeam gbsTsl[] = {};		Entity entsTsl[1];					Point3d ptsTsl[1];
		int nProps[]={};			double dProps[]={dVergeOffset};		//double dProps[]={dVergeOffset, dHipOffset, dRidgeOffset};
		String sProps[]={sMaterial,sProfile};
		Map mapTsl;	
	
	// loop roofplanes
		for (int i=0;i<_Entity.length();i++) 
		{ 
			ERoofPlane rp = (ERoofPlane)_Entity[i];
			if (!rp.bIsValid())continue;
			
		// erase lath mode
			if (bErase)
			{ 	
				for (int i=beams.length()-1; i>=0 ; i--) 
					if (beams[i].type() == _kLath && beams[i].subLabel2()==rp.handle())
						beams[i].dbErase();								
			}
			else
			{ 
				Map mapX = rp.subMapX("Hsb_TileExportData");
				if (mapX.length() < 1)continue;
				
				ptsTsl[0]=rp.coordSys().ptOrg();
				entsTsl[0]=rp;
				tslNew.dbCreate(scriptName() , _XE ,_YE,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);		
			}
		}

		eraseInstance();
		return;
	}	
// end on insert	__________________//endregion


// Get and validate roofplane
	ERoofPlane rp;
	String sKey = "Hsb_TileExportData";
	if (_Entity.length()<1 || _Entity[0].subMapXKeys().find(sKey)<0)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|invalid selection set.|"));
		eraseInstance();
		return;
	}
	rp = (ERoofPlane)_Entity[0];
	setDependencyOnEntity(rp);
	
	
// Find tslHipRidge to get the elevation of the tiles
	TslInst tslHipRidges[] = rp.tslInstAttached();	
	for(int i=0; i < tslHipRidges.length();i++)
	{
		if(tslHipRidges[i].scriptName() != "hsbTileHipRidge")
			tslHipRidges.removeAt(i);
	}
	
// coordSys
	CoordSys cs = rp.coordSys();
	Vector3d vecX = cs.vecX();
	Vector3d vecY = cs.vecY();
	Vector3d vecZ = cs.vecZ();


//// collect all opening roofplanes
//// get main roof topology
	EdgeTileData edges[] = rp.edgeTileTopology();

// get grid data
	Map mapExportData = rp.subMapX("Hsb_TileExportData");
	Point3d ptsVGrid[] = mapExportData.getPoint3dArray("VerticalDistribution");
	//double dZOffsetTilePlane = mapExportData.getDouble("ZOffsetTilePlane");
	int bFrontCutMode = mapExportData.getInt("FrontCutMode");
	PlaneProfile ppRoof = mapExportData.getPlaneProfile("ppRoof");
	Vector3d vecZEave=bFrontCutMode?vecZ:_ZW;

	CoordSys csTile = ppRoof.coordSys();
	//CoordSys csTile(cs.ptOrg()+vecZ*dZOffsetTilePlane, vecX, vecY, vecZ);
	Plane pnTile(csTile.ptOrg(), vecZ);

// get projected roofplane in tile/ridge/hip plane	//region
	PlaneProfile ppTileRoof = ppRoof;

// get tile definitions
	Map mapEdgeTileDatas = rp.subMapX("Hsb_RoofEdgeTileData").getMap("EdgeTileData[]");
	Map mapRoofFamilyDefinition = rp.subMapX("Hsb_RoofTile").getMap("RoofFamilyDefinition");

	Map mapRidgeDefinition;
	for(int i=0;i<mapEdgeTileDatas .length();i++)
	{
		Map m= mapEdgeTileDatas.getMap(i);
		int n = m.getInt("EdgeType");
		if (n==1 && m.hasMap("RidgeDefinition"))
			mapRidgeDefinition=	m.getMap("RidgeDefinition");
	}
	
// RS-141 roofplanes without any ridge cannot provide a ridge definition, try to find a definition based on one of the partner roofs
	if (mapRidgeDefinition.length()<1)
	{ 
		for (int i=0;i<edges.length();i++) 
		{ 
			ERoofPlane rpPartner= edges[i].partnerRoofplane(); 
			EdgeTileData _edges[] = rpPartner.edgeTileTopology();
			for (int j=0;j<_edges.length();j++)
			{
				EdgeTileData edge = _edges[j];
				if(edge.tileType()==_kTileRidge)
				{ 
					mapRidgeDefinition= edge.tileMap();//
					break;
				}
			}
			if (mapRidgeDefinition.length() > 0)break;
		}//next i		
	}

// get standard lath section from a potential ridge definition, lath dimensions
	double dYLath,dZLath;
	if (mapRidgeDefinition.length()>0)
	{
		dYLath = mapRidgeDefinition.getDouble("LathWidth");
		dZLath = mapRidgeDefinition.getDouble("LathHeight");
	}
	if (dYLath<dEps || dZLath < dEps)
	{ 
		reportNotice("\n" + scriptName() + T("|could not detect the section of the laths.|") + T("|Did you specify the eave and ridge tile?|"));
		if (!bDebug)eraseInstance();
		return;
	}

// get eave lath override definition
	String sEaveMaterial = sMaterial;
	double dXProfile, dYProfile;
	PlaneProfile ppEp;
	int nProfile = sProfiles.find(sProfile, 0);
	if (nProfile>0)
	{ 
		ExtrProfile ep(sProfile);
		ppEp=ep.planeProfile();
	
	// get extents of profile
		LineSeg seg = ppEp.extentInDir(vecX);
		dXProfile = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
		dYProfile = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));

		CoordSys csEp;
		csEp.setToAlignCoordSys(_PtW, _XW, _YW, _ZW, cs.ptOrg()+vecZ*.5*dYProfile+vecY*.5*dXProfile, - vecY, vecZ, - vecX);
		ppEp.transformBy(csEp);
		ppEp.vis(2);

		String timberMaterial = ep.timberMaterial();
		if (timberMaterial.length()>0)
			sEaveMaterial = timberMaterial;
	}


// collect standard lath distribution segments
	Point3d ptRef;
	LineSeg segLaths[0];
	for (int i = 0; i < ptsVGrid.length(); i++)	
	{ 
		Point3d& pt = ptsVGrid[i];
		ptRef = pt;
		LineSeg seg(pt,pt-vecY*dYLath+vecZ*dZLath);
		segLaths.append(seg);
		seg.vis(1);
	}
	ptRef.vis(6);
	


//region collect eave lath definitions and locations
	for (int i=0;i<edges.length();i++) 
	{ 
		EdgeTileData& edge = edges[i];
		Map mapEdge = edge.tileMap();
		int nType = mapEdge.getInt("EdgeType");
		if (nType != _kTileEave)continue;

	// get eaves definition
		double dOffset =mapEdge.getDouble("offset");
		Map mapEavesDefinition = mapEdge.getMap("EavesDefinition");
		if (mapEavesDefinition.length() < 1)continue;

	// get lath section from definition
		double dHeight = mapEavesDefinition.getDouble("LathHeight");
		double dWidth = mapEavesDefinition.getDouble("LathWidth");
		
	// get local coordSys from seg
		LineSeg seg = edge.segment(); //seg.vis(i);
		Vector3d vecXSeg = seg.ptEnd() - seg.ptStart();vecXSeg.normalize();
		Point3d ptMid = seg.ptMid()+vecY*dOffset;
		int bOk = Line(ptMid, vecZEave).hasIntersection(pnTile, ptMid);
		if ( ! bOk)continue;
		
	// append the segment as diagonal of the lath
		LineSeg segLath(ptMid - vecXSeg * .5 * seg.length(), ptMid + vecXSeg * .5 * seg.length() + vecY * dWidth + vecZ * dHeight);
		segLaths.append(segLath);
	}
	//endregion

//region create laths
	for (int i = segLaths.length()-1; i >= 0; i--)
	{
		LineSeg& segLath = segLaths[i];
		Point3d ptLath = segLath.ptMid();
		LineSeg segs[0];
		
	// Make sure the special lath are created with length of eaves and standart lath are not in that area (NG)
	// eave laths will contribute their length by the X-componnent
		double dXLath=abs(vecX.dotProduct(segLath.ptStart()-segLath.ptEnd()));
		double dYLath=abs(vecY.dotProduct(segLath.ptStart()-segLath.ptEnd()));
		double dZLath=abs(vecZ.dotProduct(segLath.ptStart()-segLath.ptEnd()));
		
	//	as looping from last to first eave laths can contribute a subtraction area to avoid overlappings to the standard lath
		int bIsEave;
		if (dXLath>dEps)
		{ 
			PLine pl;
			pl.createRectangle(segLath, vecX, vecY);
			ppTileRoof.joinRing(pl, _kSubtract);
			segs.append(segLath);
			bIsEave = true;
		}
		else
		{ 
			LineSeg seg(ptLath-vecX*U(10e4),ptLath+vecX*U(10e4));//seg.vis(3);		
			segs = ppTileRoof.splitSegments(seg,true);			
		}
		
	// create laths
		for (int j=0;j<segs.length();j++) 
		{ 
		// get length and location from splitted segment
			if (!bIsEave)
			{
				dXLath = segs[j].length();
				ptLath = segs[j].ptMid();
			}
			if (dXLath < dEps || dYLath < dEps || dZLath < dEps) continue;
			//ptLath.vis(2);	

			if (!bDebug)
			{ 
				Beam bm;
				bm.dbCreate(ptLath, vecX, vecY, vecZ, dXLath, dYLath, dZLath, 0, 0,0);
				if (nProfile>0 && bIsEave)
				{
					bm.setExtrProfile(sProfile);
					double d = bm.solidLength();// force solid creation
					bm.transformBy(vecY * .5 * (bm.dD(vecY) - dYLath)+ vecZ * .5 * (bm.dD(vecZ) - dZLath));
					bm.setMaterial(sEaveMaterial);
				}
				else
				{
					bm.setMaterial(sMaterial);
				}
				bm.setType(_kLath);
				bm.setColor(ncLath);
				bm.setSubLabel2(rp.handle());// store the rp handle for a potential erasing
				_Beam.append(bm);				
			}
			else
			{ 
				Body bd;
				if (nProfile>0 && bIsEave)
				{ 
					PlaneProfile _ppEp = ppEp;
					_ppEp.transformBy((segs[j].ptMid()-vecZ*.5*dYLath-vecY*.5*dZLath) - cs.ptOrg());
					_ppEp.vis(5);
					PLine plRings[] = _ppEp.allRings();
					int bIsOp[] = _ppEp.ringIsOpening();
					for (int r=0;r<plRings.length();r++)
						if (!bIsOp[r])
							bd.combine(Body(plRings[r], vecX*dXLath,0));
					for (int r=0;r<plRings.length();r++)
						if (bIsOp[r])
							bd.subPart(Body(plRings[r], vecX*dXLath*2,0));			
				}				
				else
					bd=Body(segs[j].ptMid(), vecX, vecY, vecZ, dXLath, dYLath, dZLath, 0, 0,0);
				
				bd.vis(ncLath);
			}					
		}
	}
	//endregion


// Create hip/ ridge lath 
	PLine plsEdge[0];
	Entity enLath[0];

	for (int i = 0; i < tslHipRidges.length(); i++)
	{
		Map mapPline;
		mapPline = tslHipRidges[i].map().getMap("mapPlines");
		for (int j = 0; j < mapPline.length(); j++)
			plsEdge.append(mapPline.getPLine(j));
	}
			
	// create laths		
	for (int s=0;s<plsEdge.length();s++) 
	{ 
		Point3d ptEdgeMid = plsEdge[s].ptMid();
		double dDist;
		int nEdge =- 1;
							
		for(int i=0; i< edges.length();i++)
		{
			if(i==0)
			{
				dDist = (ptEdgeMid - edges[i].segment().ptMid()).length();	
				nEdge = 0;
			}

			double dCompare = (ptEdgeMid - edges[i].segment().ptMid()).length();
			if(dCompare < dDist)	
			{
				dDist = dCompare;
				nEdge = i;
			}	
		}	
			
		int nStretchType = edges[nEdge].tileType();
		ERoofPlane rpPartner = edges[nEdge].partnerRoofplane();
		Map mapExportPartner = rpPartner.subMapX("Hsb_TileExportData");
		Entity enLathAttached[] = mapExportPartner.getEntityArray("lathKey", "lathName", "lathEntry" );
					
		Vector3d vecXSeg = ptEdgeMid - plsEdge[s].ptStart(); vecXSeg.normalize();
		Vector3d vecZSeg = _ZW.crossProduct(vecXSeg).crossProduct(-vecXSeg);vecZSeg.normalize();
		Vector3d vecYSeg = vecXSeg.crossProduct(-vecZSeg);

		Body bd(plsEdge[s].ptMid(), vecXSeg, vecYSeg, vecZSeg, plsEdge[s].length(), dYLath, dZLath, 0, 0,-1);
		int bContinue;
		for(int i=0; i < enLathAttached.length(); i++)
		{
			if(bd.hasIntersection(((Beam)enLathAttached[i]).envelopeBody()))
				bContinue = true;
		}
		
		if (bContinue) continue;

		Beam bm;
		bm.dbCreate(plsEdge[s].ptMid(), vecXSeg, vecYSeg, vecZSeg, plsEdge[s].length(), dYLath, dZLath, 0, 0,-1);
		bm.setMaterial(sMaterial);
		if (nStretchType==_kTileRidge)
		{ 
			bm.setName(T("|Ridge Lath|"));
			bm.setColor(ncRidgeLath);
		}
		else
		{ 
			bm.setName(T("|Hip Lath|"));
			bm.setColor(ncHipLath);
		}
		bm.setType(_kLath);
		bm.setSubLabel2(rp.handle());// store the rp handle for a potential erasing
		_Beam.append(bm);	
		enLath.append(bm);

	}//next s
	
	mapExportData.setEntityArray(enLath, false, "lathKey", "lathName", "lathEntry" );
	rp.setSubMapX("Hsb_TileExportData", mapExportData);

//endregion End Create Ridge Lath


	if (!bDebug)
	{ 
		eraseInstance();
		return;
	}
	
#End
#BeginThumbnail
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
5TEE"UM8P0,06CC"DCIP*L44`?__9
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
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End