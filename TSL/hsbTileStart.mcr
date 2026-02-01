#Version 8
#BeginDescription

value="1.6" date="12 jun19" author="nils.gregor@hsbcad.com">Changed default path for roofscaping report 

 This Tsl guides through the roofscaping and starts all relevant functionalities. 
 You can apply roof tile data to roofplane or export the data to excel.
 Work flow:
 1) Add roof tile data.
  2) Define edges.
  3) When the tile grid is created, adjust the vertical tiling and double click the text "Adjust vertical tiling and double click".
  4) Verge and/ or hip/ ridge tiles are created if required.
 End of guided input.
 Special tiles and/or lath have to be added separate to the roof plane.
 To export the tile data press <E> and select the roof planes.
 The default export is done with the roofscaping report in content General
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 6
#KeyWords 
#BeginContents
/// <History>//region
/// <version value="1.6" date="12jun19" author="nils.gregor@hsbcad.com">Changed default path for roofscaping report </version>
/// <version value="1.5" date="23may19" author="nils.gregor@hsbcad.com">Adjusted translation </version>
/// <version value="1.4" date="20may19" author="nils.gregor@hsbcad.com"> Erase instance, if no exporter group is found </version>
/// <version value="1.3" date="16may19" author="nils.gregor@hsbcad.com"> find default exporter group in content General </version>
/// <version value="1.2" date="16may19" author="nils.gregor@hsbcad.com"> changed reading exporter groups </version>
/// <version value="1.1" date="15may19" author="nils.gregor@hsbcad.com"> change starting sequence </version>
/// <version value="1.0" date="19nov18" author="nils.gregor@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Start dialog/export and/or select roof planes. 
/// </insert>

/// <summary Lang=en>


/// </summary>//endregion
/// This Tsl guides through the roofscaping and starts all relevant functionalities. 
/// You can apply roof tile data to roofplane or export the data to excel.
/// Work flow:
///  1) Add roof tile data.
///  2) Define edges.
///  3) When the tile grid is created, adjust the vertical tiling and double click the text "Adjust vertical tiling and double click".
///  4) Verge and/ or hip/ ridge tiles are created if required.
/// End of guided input.
/// Special tiles and/or lath have to be added separate to the roof plane.
/// To export the tile data press <E> and select the roof planes.
/// The default export is done with the roofscaping report in content General


// constants //region
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	double pi = 3.142;
	// read a potential mapObject defined by hsbDebugController
	{ 
		MapObject mo("hsbTSLDev" ,"hsbTSLDebugController");
		if (mo.bIsValid()){Map m = mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug = true;	break;}}
		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());		
	}
	
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|Settings|");
	String sNoLater[] = { T("|No|"), T("|After adjusting tile grid|")};
	//endregion
	
// Get export groups
	String sFiles[0];
	String sFolder = _kPathHsbCompany+"\\Export\\catalogue\\groups.xml"; 
	
// Get Roofscaping export from content General as standard export
	String sGroupDefault = _kPathHsbInstall + "\\Content\\General\\hsbCompany\\Export\\catalogue\\groups.xml";
	Map mapGroups;
	mapGroups.readFromXmlFile(sGroupDefault);
	if(mapGroups.getMap("ExportGroup").hasString("Name"))
		sFiles.append(mapGroups.getMap(0).getString("Name"));
		
// Get all other exporter groups from the company folder
	mapGroups.readFromXmlFile(sFolder);
	for(int i=0; i < mapGroups.length();i++)
	{
		String sName = mapGroups.getMap(i).getString("Name");
		sFiles.append(sName);
	}
	
// If no exporter group is found report message and erase instance
	if(sFiles.length() < 1)
	{
		reportMessage(TN("|Please define an Exporter Group first and try again.|"));
		eraseInstance();
		return;	
	}

//Order exporter groups
	for (int i=1;i<sFiles.length();i++)
		for (int j=i;j<sFiles.length()-1;j++)
		{
			String s1 = sFiles[j];
			String s2 = sFiles[j+1];
			s1.makeUpper();
			s2.makeUpper();
			if(s1>s2)
				sFiles.swap(j,j+1);
		}	
	
//// collect and order exporter groups
//	String sExporterGroups[] = ModelMap().exporterGroups();
//	for (int i=0;i<sExporterGroups.length();i++)
//		for (int j=0;j<sExporterGroups.length()-1;j++)
//		{
//			String s1 = sExporterGroups[j];
//			String s2 = sExporterGroups[j+1];
//			s1.makeUpper();
//			s2.makeUpper();
//			if(s1>s2)
//				sExporterGroups.swap(j,j+1);
//		}

	String sVergeName=T("|Create verge tiles|");	
	PropString sVerge(nStringIndex++, sNoLater, sVergeName,1);	
	sVerge.setDescription(T("|Defines the verges|"));
	sVerge.setCategory(category);
	int nVerge = sNoLater.find(sVerge);	

	String sRidgeName=T("|Create ridge tiles|");	
	PropString sRidge(nStringIndex++, sNoLater, sRidgeName,1);	
	sRidge.setDescription(T("|Defines the ridges|"));
	sRidge.setCategory(category);
	int nRidge = sNoLater.find(sRidge);
	
	String sTileGridCatalogName=T("|Use TileGrid catalog|");	
	String sTileGridCatalogs[] = TslInst().getListOfCatalogNames("_hsbTileGrid");
	PropString sTileGridCatalog(nStringIndex++, sTileGridCatalogs, sTileGridCatalogName);	
	sTileGridCatalog.setDescription(T("|Defines the TileGridCatalog|"));
	sTileGridCatalog.setCategory(category);
	
	String sRidgeTileCatalogName=T("|Use TileHipRidge catalog|");
	String sRidgeTileCatalogs[] = TslInst().getListOfCatalogNames("hsbTileHipRidge");
	PropString sRidgeTileCatalog(nStringIndex++, sRidgeTileCatalogs, sRidgeTileCatalogName);	
	sRidgeTileCatalog.setDescription(T("|Defines the RidgeTileCatalog|"));
	sRidgeTileCatalog.setCategory(category);	
	
//	PropString sExporterGroup(nStringIndex++,sExporterGroups, T("|Exporter Group|"));
//	sExporterGroup.setCategory("Export");

	PropString sExporterGroup(nStringIndex++,sFiles, T("|Exporter Group|"));
	sExporterGroup.setCategory("Export");
	
	// bOnInsert//region
		if(_bOnInsert)
		{
			if (insertCycleCount()>1) { eraseInstance(); return; }
			
		// silent/dialog
			String sKey = _kExecuteKey;
			sKey.makeUpper();
			int bStart = true;
		
			if (sKey.length()>0)
			{
			// Restart key after launching Roof Tile Family Selector
				if (sKey == "START") bStart = false;
					
				String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
				for(int i=0;i<sEntries.length();i++)
					sEntries[i] = sEntries[i].makeUpper();	
				if (sEntries.find(sKey)>-1)
					setPropValuesFromCatalog(sKey);
				else
					setPropValuesFromCatalog(sLastInserted);		
								
			// Export started by ribbon in contentDach
				if(sKey.find("EXPORT",0) > -1)
					_Map.setString("E", "E");
			}	
				
			else
			{
				String sDialog = getString(T("|Type <D> for dialog, <E> for export, <Enter> attach roof data|"));
				sDialog = sDialog.makeUpper();				
					
				if(sDialog == "D")
					showDialog();
						
				if(sDialog == "E")
				{
					_Map.setString("E", sDialog);			
					setPropValuesFromCatalog(sLastInserted);	
				}

			}
				
		// No entity selection after restart when Roof Tile Faily Selector was launched
			if(bStart)
			{	
			// prompt for roofplanes
				PrEntity ssErp(T("|Select roofplane(s)|"), ERoofPlane());
				  if (ssErp.go())
					_Entity.append(ssErp.set());
					
				if(_Entity.length() < 1)
				{
					reportMessage("No roofplanes found, instance will be deleted");
					eraseInstance();
					return;
				}
								
				return;						
			}
		}	
		
	// end on insert	__________________//endregion

		int bFinished;

	// Attaching all required data and Tsl functionality  to the roofplane
		if(_Map.getString("E") != "E")
		{
			Vector3d vecX, vecY;
			Display dp(2);
			int nTextHeight;
	
		// Start Roof Tile Family Selector on all roof planes and restart Tsl  (First run)
			if(_Entity.length() > 0 && ! _Map.getInt("SecoundRun"))
			{	
				String sHandles[0];
				
				for(int i=0; i < _Entity.length(); i++)
				{
					sHandles.append(_Entity[i].handle());
					ERoofPlane rp = (ERoofPlane)_Entity[i];
					
				// Make sure old data is deleted
					rp.removeSubMapX("hsb_TileExportData");
					TslInst tsls[] = rp.tslInstAttached();
					
					for(int j= tsls.length()-1; j > -1;j--)
					{
						if(tsls[j].scriptName().find("hsbTile",0) > -1)
							tsls[j].dbErase();
					}
										
					Map mapExport;
					mapExport.setInt("hsbTileStart", true);
					rp.setSubMapX("hsb_TileExportData", mapExport);
				}
			
			// Start tile definition for roofplanes
				pushCommandOnCommandStack("_HSB_ROOFPLANETILEDEFINTION");
				for(int i=0; i < sHandles.length();i++)
				{
					String sHandle = sHandles[i];
					pushCommandOnCommandStack("(handent \""+sHandle+"\")");	
				}
				pushCommandOnCommandStack("(Command \"\")");
						
				_ThisInst.setCatalogFromPropValues("start");
			
				pushCommandOnCommandStack("(hsb_Scriptinsert \"hsbTileStart\" \"start\")");				
				eraseInstance();
			}
			
		// Attach Tsls to the roofplanes (Secound run)
			else
			{		
				int bAddEdgeData;		
				String sHandle;
				Entity ents[0];
				
			// Find roof planes from first run and add them to _Entity
				if(_Entity.length() < 1)
				{
					ERoofPlane rp;
					ERoofPlane rps[] = rp.getAllRoofPlanes();
					
					for(int i=0; i < rps.length(); i++)
					{
						rp = rps[i];
						Map mapExport = rp.subMapX("hsb_TileExportData");
						if(mapExport.getInt("hsbTileStart"))
						{
							mapExport.setInt("hsbTileStart", false);
							rp.setSubMapX("hsb_TileExportData", mapExport);	
							_Entity.append(rp);	
							ents.append(rp);	
						}
					}				
				}
	
				else
					ents = _Entity;
					
				_Map.setInt("SecoundRun", true);
				
				for(int i=0; i < ents.length(); i++)
				{
					setDependencyOnEntity(ents[i]);
				}
			
				if(ents.length() < 1)
				{
					reportMessage  ("No roofplanes found, instance will be deleted");					
					eraseInstance();
					return;
				}
				
			// Show edges without edge data set and visualize them. All edges need edge data to continue
				for(int i=0; i < ents.length();i++)
				{
					ERoofPlane rp = (ERoofPlane) ents[i];
					EdgeTileData ed[] = rp.edgeTileData();
					Map mapRp = rp.subMapX("Hsb_RoofEdgeTileData").getMap("EdgeTileData[]");
					int nNumEds;
					Vector3d vecZrp = rp.coordSys().vecZ();
				
					for(int j=0; j < mapRp.length(); j++)
					{
						Map mapEdge = mapRp.getMap(j);
						
						if(mapEdge.hasMap("EdgeDefinition") || mapEdge.hasMap("RidgeDefinition"))
							nNumEds++;
						else
						{
							LineSeg seg(mapEdge.getPoint3d("pt1"), mapEdge.getPoint3d("pt2"));
							String sEdge = T("|Add edgeData|");
							Display dpEdge(3);
							Vector3d vecXE (seg.ptEnd() - seg.ptStart());
							Vector3d vecYE = vecZrp.crossProduct(vecXE);
							
							if(mapEdge.getInt("EdgeType") == 1)
							{
								vecYE = rp.coordSys().vecY();
								vecXE = rp.coordSys().vecX();
							}
						
							dpEdge.draw(seg);
							dpEdge.draw(sEdge, seg.ptMid(), vecXE, vecYE, 0, -5 );
						}
					}
					
					if(nNumEds == ed.length())
						bAddEdgeData = true;
				}		
		
			//Prepare cloning for hsbTileHipRidge and hsbTileVerge Tslsl
				CoordSys csRoof = ((ERoofPlane)ents[0]).coordSys();
				if(_bOnDbCreated)
					_Pt0 = csRoof.ptOrg();
				vecX = csRoof.vecX();
				vecY = csRoof.vecY();
					
				// create TSL
					TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
					GenBeam gbsTsl[] = {};		Entity entsTsl[0];	entsTsl=ents;		Point3d ptsTsl[] = {_Pt0};
					Map mapTsl;	
					
				if( bAddEdgeData)
				{						
					tslNew.dbCreate("_hsbTileGrid" , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, sTileGridCatalog,_kModelSpace, mapTsl, sTileGridCatalog,"");
					
				// The vertical tiling of the _hsbTileGid Tsl has to be in range before moveing on
					int nTileGrid;						
					String sFinish = T("|Adjust vertical tiling and double click|");
					Display dp(2);
					dp.draw(sFinish, _Pt0, vecX, vecY, 1, 9);

					
				// toggle grid visibility by double click and start remaining Tsls
					if (_bOnRecalc &&  _kExecuteKey==sDoubleClick) 	
					{
						if(nRidge == 1)
						{
							tslNew.dbCreate("hsbTileHipRidge" , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, sRidgeTileCatalog,_kModelSpace, mapTsl,"","");				
						}
			
						if(nVerge ==1 )
							for(int i=0; i<ents.length();i++)
							{
								Entity ent[0]; ent.append(ents[i]);
								if(nVerge == 1)
									tslNew.dbCreate("hsbTileVerge" , vecXTsl ,vecYTsl,gbsTsl, ent, ptsTsl, "",_kModelSpace, mapTsl,"","");					
							}	
						bFinished = true;
					}
				}				
			}
			
		}
		
	// update all Tsls, calculate the quantity of standard and half tiles and write the amound to the _hsbTileGrid Tsl
		Entity ents[0]; 
		
		if(_Entity.length() > 0)
		{
			ents = _Entity;
		}
			
		for(int i=0; i < _Entity.length(); i++)
		{
			int nFullToRemove;
			int nHalfToRemove;
			int nFullTiles;
			int nHalfTiles;
			Map mapHardware;
			TslInst TileGrid;		
			
		// Update roofplane
			ERoofPlane rp = (ERoofPlane)ents[i];	
			rp.transformBy(Vector3d(0, 0, 0));			
			TslInst tsls[] = rp.tslInstAttached();
			
		// get all hsbTile Tsls and all tiles to be subtracted
			for(int j=0; j < tsls.length(); j++)
			{
				if(tsls[j].scriptName() != "hsbTileLath" && tsls[j].scriptName().find("hsbTile",0) > -1)
				{
					if (tsls[j] == _ThisInst) continue;
					
					ents.append(tsls[j]);		
					
				// Store _hsbTileGrid-Vertical separate. This Tsl gets the standard and hlf tiles attached
					if(tsls[j].opmName() == "_hsbTileGrid-Vertical")
						TileGrid = tsls[j];	
					
				// Get tiles to subtract from all Tsl to charge final amount
					Map mapTsl = tsls[j].map();
					if (mapTsl.hasMap("TilesToSubtract"))
					{
						nFullToRemove += mapTsl.getMap("TilesToSubtract").getInt("FullTile");
						nHalfToRemove += mapTsl.getMap("TilesToSubtract").getInt("HalfTile");						
					}
				// Get total tile quantity of _hsbTileGrid-Vertical
					else if( mapTsl.hasMap("mapHardware"))
					{
						nFullTiles = mapTsl.getMap("mapTiles").getInt("FullTiles");
						nHalfTiles = mapTsl.getMap("mapTiles").getInt("HalfTiles");
						mapHardware = mapTsl.getMap("mapHardware");
					}
				}
			}
				
		// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
		// collect existing hardware
			HardWrComp hwcs[0];
				
			if(TileGrid.bIsValid())
			{
				hwcs = TileGrid.hardWrComps();
					
				for (int i=hwcs.length()-1; i>=0 ; i--) 
					if (hwcs[i].repType() == _kRTTsl)
						hwcs.removeAt(i); 			
			}
				
		//Create hardware for full and half tiles and attach it to _hsbTileGrid-Vertical
			for(int i=0; i < 2; i++)
			{ 
				int nQty;
				String sName;
					
				if(i==0 && nFullTiles > 0)
				{
					nQty = nFullTiles - nFullToRemove;
					sName = mapHardware.getString("FullTileName");
				}
				else if (i==1 && nHalfTiles > 0)
				{
					nQty = nHalfTiles - nHalfToRemove;
					sName = mapHardware.getString("HalfTileName");
				}
				else 
					continue;
						
				//Map m = mapRoofTiles.getMap(i);
				HardWrComp hwc(i, nQty); 
					
				hwc.setManufacturer(mapHardware.getString("Manufacturer"));
						
				hwc.setModel(mapHardware.getString("Model"));
				hwc.setName(sName);
				hwc.setMaterial(mapHardware.getString("Material"));//		
				hwc.setNotes(rp.roofNumber());
		
				hwc.setGroup(mapHardware.getString("Group"));
				hwc.setLinkedEntity(mapHardware.getEntity("LinkedEntity"));	
				hwc.setCategory(mapHardware.getString("Category"));
				hwc.setRepType(_kRTTsl); 
						
				hwc.setDScaleX(mapHardware.getDouble("DScaleX"));
				hwc.setDScaleY(mapHardware.getDouble("DScaleY"));
				hwc.setDScaleZ(mapHardware.getDouble("DScaleZ"));

				hwc.setDAngleA( mapHardware.getDouble("DAngleA") * (180 / pi));
			// apppend component to the list of components
				hwcs.append(hwc);					
			}
					
			if(hwcs.length() > 0 && TileGrid.bIsValid())
				TileGrid.setHardWrComps(hwcs);				
		}
		
	// Erase Instance if started in attaching Mode
		if(_Map.getString("E") != "E" && bFinished)
		{
			eraseInstance();
			return;
		}

	// Export Tiles to excel list
		if(_Map.hasString("E"))
		{		
			// set some export flags
			ModelMapComposeSettings mmFlags;
			mmFlags.addHardwareInfo(TRUE); // default FALSE
			mmFlags.addRoofplanesAboveWallsAndRoofSectionsForRoofs(TRUE); // default FALSE
			mmFlags.addCollectionDefinitions(TRUE); // default FALSE
			String strDestinationFolder = _kPathDwg;
		
		// Map that contains the keys that need to be overwritten in the ProjectInfo 
			Map mapProjectInfoOverwrite;
	
		// compose ModelMap
			ModelMap mm;
			mm.setEntities(ents);
			mm.dbComposeMap(mmFlags);			

		// call the exporter			
			int bOk = ModelMap().callExporter(mmFlags, mapProjectInfoOverwrite, ents, sExporterGroup, strDestinationFolder);
			if (!bOk)
				reportMessage("\nTsl::callExporter failed.");	
			
			eraseInstance();
			return;
		}

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
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End