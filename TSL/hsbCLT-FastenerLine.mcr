#Version 8
#BeginDescription
Select panels and specify insert rule

#Versions
Version 1.9 12.09.2024 HSB-22178 bugfix quantity rule edit, take II
Version 1.8 22.07.2024 HSB-22178 bugfix quantity rule edit
Version 1.7 03.06.2024 HSB-22179 resolves nterdistance by hardware
Version 1.6 08.08.2023 HSB-18845 duplicate creation fixed, detecting longest edge fixed, supports 'Interdistance' as format variable
Version 1.5 17.07.2023 HSB-18845 supports grips in wall and floor modes, accepts wall/floor connections if edge of wall panel has beamcut
Version 1.4 11.07.2023 HSB-18845 FastenerDatabase supported, new connection modes
Version 1.3 07.07.2023 HSB-18845 FastenerDatabase prepared
Version 1.2 07.07.2023 HSB-18845 new insertion methods, wall/wall mode added
Version 1.1 30.06.2023 HSB-18845 supporting polylines, display options extended
Version 1.0 29.06.2023 HSB-18845 first version of fastener line definition









#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 9
#KeyWords 
#BeginContents
//region Part #1
		

//region <History>
// #Versions
// 1.9 12.09.2024 HSB-22178 bugfix quantity rule edit, take II , Author Thorsten Huck
// 1.8 22.07.2024 HSB-22178 bugfix quantity rule edit , Author Thorsten Huck
// 1.7 03.06.2024 HSB-22179 resolves nterdistance by hardware , Author Thorsten Huck
// 1.6 08.08.2023 HSB-18845 duplicate creation fixed, detecting longest edge fixed, supports 'Interdistance' as format variable , Author Thorsten Huck
// 1.5 17.07.2023 HSB-18845 supports grips in wall and floor modes, accepts wall/floor connections if edge of wall panel has beamcut , Author Thorsten Huck
// 1.4 11.07.2023 HSB-18845 FastenerDatabase supported, new connection modes , Author Thorsten Huck
// 1.3 07.07.2023 HSB-18845 FastenerDatabase prepared , Author Thorsten Huck
// 1.2 07.07.2023 HSB-188845 new insertion methods, wall/wall mode added , Author Thorsten Huck
// 1.1 30.06.2023 HSB-18845 supporting polylines, display options extended , Author Thorsten Huck
// 1.0 29.06.2023 HSB-18845 first version of fastener line definition , Author Thorsten Huck

/// <insert Lang=en>
/// Select panels and specify insert rule
/// </insert>

// <summary Lang=en>
// This tsl creates distributions of fastener lines.
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCLT-FastenerLine")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|UserPrompt|"))) TSLCONTENT
//endregion

//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;

	String tDefault =T("|_Default|");
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
	
	String tFixed = T("|Fixed|"), tFixedOdd = T("|Fixed, last odd|"), tEven = T("|Even|");
	String sDistributionModes[] ={ tFixed, tEven, tFixedOdd};
	int nMode = _Map.getInt("mode");
	
// the dll of the fastenerAssembly	
	String sDllPath = _kPathHsbInstall + "\\FastenerAssembly\\FastenerManager.dll";
	String sClass = "FastenerManager.TslConnector";
	int bEnableFastenerManager = findFile(sDllPath)!="";

// the dll of the dialog service
	String stDialogLibrary = _kPathHsbInstall + "\\Utilities\\DialogService\\TslUtilities.dll";
	String stDialogClass = "TslUtilities.TslDialogService";	
	
	
	
//end Constants//endregion

//region Painters
	String tDisabledEntry= T("<|Disabled|>");
	String tFloorEntry = T("|Floor|");
	String tWallEntry = T("|Wall|");
	
	String tByLine = T("<|byLine|>");
	String tByCoplanar = T("<|Coplanar Connection|>");
	String tByWallConnection = T("<|Wall T-Connection|>");
	String tByWallFloorConnection = T("<|Wall-Floor Connection|>");

// Get or create default painter definition
	String sPainterCollection = "TSL\\FastenerLine\\";
	String sPainters[0],sAllPainters[] = PainterDefinition().getAllEntryNames().sorted();
	for (int i=0;i<sAllPainters.length();i++) 
	{ 
		if (sAllPainters[i].find(sPainterCollection,0,false)==0)
		{
			PainterDefinition pd(sAllPainters[i]);
			if (!pd.bIsValid())
			{ 
				continue;
			}
			
		// add painter name	
			String name = sAllPainters[i];
			name = name.right(name.length() - sPainterCollection.length());
			if (sPainters.findNoCase(name,-1)<0)
			{
				sPainters.append(name);
			}

				
		}		 
	}//next i

	{ 
		String name = tFloorEntry;
		if (sPainters.findNoCase(name,-1)<0)
		{ 
			Entity ents[] = Group().collectEntities(true, Sip(), _kModelSpace);
			String painter = sPainterCollection + name;
			PainterDefinition pd(painter);	
			if (!pd.bIsValid() && ents.length()>0)
			{ 
				pd.dbCreate();
				if (pd.bIsValid())
				{ 
					pd.setType("Panel");
					pd.setFilter("isParallelWorldZ = 'true'");
					pd.setFormat("@(GroupLevel2)");
				}
			}				
			if (sPainters.findNoCase(name,-1)<0 && pd.bIsValid())
			{
				sPainters.append(name);		
			}
		}		
	}
	{ 
		String name = tWallEntry;
		if (sPainters.findNoCase(name,-1)<0)
		{ 
			Entity ents[] = Group().collectEntities(true, Sip(), _kModelSpace);
			String painter = sPainterCollection + name;
			PainterDefinition pd(painter);	
			if (!pd.bIsValid() && ents.length()>0)
			{ 
				pd.dbCreate();
				if (pd.bIsValid())
				{ 
					pd.setType("Panel");
					pd.setFilter("isPerpendicularWorldZ = 'true'");
					pd.setFormat("@(GroupLevel2)");
				}
			}				
			if (sPainters.findNoCase(name,-1)<0 && pd.bIsValid())
			{
				sPainters.append(name);		
			}
		}		
	}

//endregion

//region FUNCTIONS

//region Function getSplitPLines
	// returns the split segments of a planeprofile as plines
	PLine[] getSplitPLines(PlaneProfile pp, LineSeg seg)
	{ 
		PLine plines[0];
		Vector3d vecZ = pp.coordSys().vecZ();
		LineSeg segs[] = pp.splitSegments(seg, true);
		for (int i=0;i<segs.length();i++) 
		{ 
			PLine pl(vecZ);
			pl.addVertex(segs[i].ptStart());
			pl.addVertex(segs[i].ptEnd());
			plines.append(pl);		 
		}//next i	

		return plines;
	}

//endregion 

//region Function filterPanelsByType
	// returns panels of a certain orientation
	// type == 1: returns panels which are upright n model like a wall
	// type == 2: returns panels which are coplanar to XY-World in model like a floor
	// type == 3: returns panles which are not of type 1 or 2
	// filterPanelsByType filters panels
	// filterEntityPanelsByType filters panels but accepts an entity array as argument
	Sip[] filterPanelsByType(Sip sips[], int type)
	{ 
		Sip sipsOut[0];
		for (int i=0;i<sips.length();i++) 
		{ 
			Sip sip = sips[i];
			Vector3d vec= sip.vecZ();
			if (vec.isPerpendicularTo(_ZW) && type ==1) // wall
				sipsOut.append(sip);
			else if (vec.isParallelTo(_ZW) && type ==2) // floor
				sipsOut.append(sip);		
			else if (type ==3) // other alignments
				sipsOut.append(sip);					
		}//next i	
		return sipsOut;
	}
	
	Sip[] filterEntityPanelsByType(Entity ents[], int type)
	{ 
		Sip sipsOut[0];
		for (int i=0;i<ents.length();i++) 
		{ 
			Sip sip = (Sip)ents[i];
			if (!sip.bIsValid()){ continue;}
			Vector3d vec= sip.vecZ();
			if (vec.isPerpendicularTo(_ZW) && type ==1) // wall
				sipsOut.append(sip);
			else if (vec.isParallelTo(_ZW) && type ==2) // floor
				sipsOut.append(sip);		
			else if (type ==3) // other alignments
				sipsOut.append(sip);					
		}//next i	
		return sipsOut;
	}	

	// filter perpendicular beams as a subset of entities which are perpendicular to one of the females
	Beam[] filterEntityBeamsByPanel(Entity ents[], Sip females[])
	{ 
		Beam out[0];

	// cast beams
		Beam beams[0];
		for (int i = 0; i < ents.length(); i++)
		{
			Beam b = (Beam)ents[i];
			if (b.bIsValid())
				beams.append(b);
		}
		
	// filter by females
		for (int i=0;i<females.length();i++) 
		{ 
			Vector3d vecN = females[i].vecZ();
			Beam bmPerps[] = vecN.filterBeamsPerpendicularSort(beams);
			for (int j=0;j<bmPerps.length();j++) 
			{ 
				Beam& b = bmPerps[j]; 
				if (out.find(b)<0)
					out.append(b);					 
			}//next x
		}//next i
		return out;
	}




	//endregion 

//region Function getTConnectedPanels
	// returns the connected panels at a given edge of a male panel
	// vecDir: the connection direction 
	// pnZ: the center plane of the main panel
	// radius: the radius of the connection
	// plEdge the edge pline to test a potential connection
	// sipOthers: the array of panels to test the connection against
	
	Sip[] getTConnectedPanels(Vector3d& vecDir, Plane pnZ, double radius, PLine plEdge, Sip sipOthers[])
	{ 
	// Get params of main panel
		Point3d ptCen = pnZ.ptOrg();
		Vector3d vecZ = pnZ.vecZ();
		Sip sipsX[0];

	// collect connecting panels 
		Vector3d vecXE = plEdge.ptEnd()-plEdge.ptStart();	vecXE.normalize();
		
		if (vecXE.isPerpendicularTo(vecDir))
		{ 
			plEdge.projectPointsToPlane(pnZ,vecZ);
			Body cap(plEdge.ptStart(), plEdge.ptEnd(), radius );
			if(vecDir.dotProduct(cap.ptCen()-ptCen)<0)
				vecDir *= -1;
			cap.vis(2);	//vecDir.vis(cap.ptCen(), 2);				
			sipsX= cap.filterGenBeamsIntersect(sipOthers);
		}
		
//		for(int i = 0; i< sipsX.length();i++)
//			PLine(ptCen, sipsX[i].ptCen()).vis(1);
		
		
		return sipsX;
	}
//endregion 

//region Function getConnectionEdges
	
	// returns the connection direction and filters the other panels 
	// according to it, i.e. for a wall / wall connection it will remove all floor panels
	
	// edges: the edges of the main panel
	// sipOthers: potential panels to be connected, filters output in respect of connection direction
	
	Vector3d getConnectionEdges(Sip sip, SipEdge& edges[], Sip& sipOthers[])
	{ 
	// Get params of main panel
		Vector3d vecZ = sip.vecZ();
		Point3d ptCen = sip.ptCen();
		Plane pnZ(ptCen, vecZ);
		double dH = sip.dH();
		
		SipEdge edgesOut[0];
		
	// Distinguish between wall and floor connections
		Sip sipsW[0], sipsF[0];
		for (int i=0;i<sipOthers.length();i++) 
		{ 
			Sip& sip1 = sipOthers[i];
			Vector3d vecZ1 = sip1.vecZ();
			if (vecZ1.isParallelTo(_ZW))
				sipsF.append(sip1);
			else if (vecZ1.isPerpendicularTo(_ZW))
				sipsW.append(sip1); 
		}//next i		
		int bIsFloor = sipsF.length() >= sipsW.length();		
		sipOthers = bIsFloor ? sipsF : sipsW;

	// get connection direction
		Vector3d vecDir = bIsFloor?_ZW:vecZ.crossProduct(-_ZW);
		
	// Collect connecting sips on vertical edges
		Sip sipOuts[0];
		for (int i=0;i<edges.length();i++) 
		{ 
			SipEdge edge= edges[i]; 
			PLine pl = edge.plEdge(); 
			Vector3d vecXE = pl.ptEnd()-pl.ptStart();	vecXE.normalize();
			
			int n = sip.findClosestRingIndex(pl.ptMid());
			if (n>-1){ continue;} // skip opening edges

			if ((bIsFloor && vecXE.isPerpendicularTo(_ZW)) || 
				(!bIsFloor && vecXE.isParallelTo(_ZW)))
			{
				//edge.vecNormal().vis(pl.ptMid(), 2);

				Sip sipsX[] = getTConnectedPanels(vecDir, pnZ, dH*.5, pl, sipOthers);
				if (sipsX.length() > 0)
				{
					sipOuts = sipsX;
					edgesOut.append(edge);	
				}
			}						 
		}//next i

		edges = edgesOut;
		if (edges.length()==1)
		{
			sipOthers = sipOuts;
			if (edges.first().vecNormal().dotProduct(vecDir)<0)
				vecDir *= -1;
		}
		return vecDir;		
	}
		
//endregion 

//region Function getConnectionEdges2
	
	// returns the connection direction and filters the other panels 
	// according to it, i.e. for a wall / wall connection it will remove all floor panels
	
	// edges: the edges of the main panel
	// sipOthers: potential panels to be connected, filters output in respect of connection direction
	
	Map getConnectionsInDir(Sip sip, SipEdge& edges[], Sip& sipOthers[], Vector3d vecDir)
	{ 
	// Get params of main panel
		Vector3d vecZ = sip.vecZ();
		Point3d ptCen = sip.ptCen();
		Plane pnZ(ptCen, vecZ);
		double dH = sip.dH();
		
		int bIsFloor = vecDir.isParallelTo(_ZW);
		int bIsWall = vecDir.isPerpendicularTo(_ZW);
		
		SipEdge edgesOut[0];
		
	// Distinguish between wall and floor connections
		Sip sipsC[0];
		for (int i=0;i<sipOthers.length();i++) 
		{ 
			Sip& sip1 = sipOthers[i];
			Vector3d vecZ1 = sip1.vecZ();
			if (vecZ1.isParallelTo(_ZW) && bIsFloor) // floor alignment
				sipsC.append(sip1);
			else if (vecZ1.isPerpendicularTo(_ZW) && bIsWall)// wall alignment
				sipsC.append(sip1); 
		}//next i						
		sipOthers = sipsC;


	// Collect connecting sips on vertical edges
		Map mapOut;
		for (int i=0;i<edges.length();i++) 
		{ 
			SipEdge edge= edges[i]; 
			PLine plEdge = edge.plEdge(); 
			Vector3d vecXE = edge.ptEnd()-edge.ptStart();	vecXE.normalize();
			
			int n = sip.findClosestRingIndex(edge.ptMid());
			if (n>-1){ continue;} // skip opening edges

			if ((bIsFloor && vecXE.isPerpendicularTo(_ZW)) || 
				(bIsWall && vecXE.isParallelTo(_ZW)))
			{
				//edge.vecNormal().vis(plEdge.ptMid(), 2);

				Sip sipsX[] = getTConnectedPanels(vecDir, pnZ, dH*.5, plEdge, sipOthers);
				if (sipsX.length() > 0)
				{
					Map m;
					m.setVector3d("vecDir", vecDir);
					m.setEntityArray(sipsX,true, "ent[]", "", "ent");
					m.setPLine("plEdge",plEdge);
					mapOut.appendMap("Connection", m);	
				}
			}						 
		}//next i

		return mapOut;		
	}
		
//endregion 

//region Function getPainterGroups
	// returns a map containing the groups entities of the painterdefinition
	// painterDef: the name of the painter definition
	// folderName: the folder name of the painter definition
	// the returnded map contains n entries
	Map getPainterGroups(String painterDef, String folderName, Entity ents[])
	{ 
		
		Map mapOut;
		Entity entsPD[0];
		PainterDefinition pd(folderName+painterDef);			
		if (pd.bIsValid())
		{
			String sFormat = pd.format();
			entsPD= pd.filterAcceptedEntities(ents); 
			
		// Collect groupings
			String sGroupings[0];
			for (int j = 0; j < entsPD.length(); j++)
			{
				Entity& e = entsPD[j];
				Sip sip = (Sip)e;
				if ( ! sip.bIsValid())
				{
					continue;
				}
				String grouping = e.formatObject(sFormat);
				if (sGroupings.findNoCase(grouping ,- 1) < 0)
				{
					sGroupings.append(grouping);
					
					Vector3d vecZ = sip.vecZ();
					int isFloor = vecZ.isParallelTo(_ZW);
					int isWall = vecZ.isPerpendicularTo(_ZW);
					
				// accept only items of this group
					Entity entsG[0];
					for (int x=0;x<entsPD.length();x++) 
					{ 
						Entity ex = entsPD[x];
						if (ex.formatObject(sFormat)==grouping)
							entsG.append(ex);
					}//next j						

				// append map	
					Map m;
					if (isFloor)m.setInt("isFloor", isFloor);
					if (isWall)m.setInt("isWall", isWall);
					m.setString("folder", folderName);
					m.setString("painter", painterDef);
					m.setString("grouping", grouping);
					m.setEntityArray(entsG, true, "Entity[]", "", "Entity");
					m.setMapName(painterDef);
					mapOut.appendMap("Entry", m);
				}
			}
		}
		return mapOut;
	}//endregion 

//region setHardwareFromFastener
	HardWrComp setHardwareFromFastener(Map map, int quantity)
	{ 
		HardWrComp hwc(map.getString("Model"), quantity);
			
		//hwc.setName(map.getString("name"));
		hwc.setDescription(map.getString("description"));
		hwc.setManufacturer(map.getString("manufacturer"));
		hwc.setMaterial(map.getString("material"));
		hwc.setCategory(map.getString("type"));
		hwc.setNotes(map.getString("notes"));
		
		hwc.setDScaleX(map.getDouble("Length"));
		hwc.setDScaleY(map.getDouble("Diameter"));
		hwc.setDScaleZ(0);

		hwc.setRepType(_kRTTsl);
		
		return hwc;
	}//endregion 

//region SetHardwareFromHwcMap
	HardWrComp SetHardwareFromHwcMap(Map map, int quantity)
	{ 		
		HardWrComp hwc(map.getString("articleNumber"), quantity);//HSB-22178
					
		hwc.setName(map.getString("name"));
		hwc.setDescription(map.getString("description"));
		hwc.setManufacturer(map.getString("manufacturer"));
		hwc.setMaterial(map.getString("material"));
		hwc.setCategory(map.getString("category"));
		
		hwc.setDScaleX(map.getDouble("dScaleX"));
		hwc.setDScaleY(map.getDouble("dScaleY"));
		hwc.setDScaleZ(map.getDouble("dScaleZ"));

		hwc.setRepType(_kRTTsl);

		return hwc;
	}//endregion 


//region Function GetToken
	// returns the value of the key/value coupled, specified key in the given format
	// t: the tslInstance to 
	Map GetToken(String tokens[], String keyToken, int formatType)
	//formatType: 0 = string, 1 = int, 2 = _kLength, 3=_kArea, 4=_kVolume
	{ 
		Map out;
		String key = keyToken;
		key.makeUpper();
		for (int i=0;i<tokens.length();i++) 
		{ 
			String val = tokens[i].makeUpper(); 
			if (val==key && i<tokens.length()+1)
			{ 
				if (formatType == 1)
					out.setInt(keyToken,tokens[i+1].atoi());
				else if (formatType == 2)
					out.setDouble(keyToken,tokens[i+1].atof(),_kLength);
				else if (formatType == 2)
					out.setDouble(keyToken,tokens[i+1].atof(),_kArea);
				else if (formatType == 2)
					out.setDouble(keyToken,tokens[i+1].atof(),_kVolume);					
//				i++;
				break;
			}	
//			else
//			{ 
//				m.setString("notes",tokens[i]);
//			}
		}//next i
		
		return out;
	}//endregion


//region Function GetHardwareFormat
	// modifies the map and appends entries to resolve formatting of hardware if the entry doesn't exist
	void GetHardwareFormat(Map& mapAdd, HardWrComp hwc)
	{ 
		String articleNumber = hwc.articleNumber();
		String name = hwc.name();
		String description = hwc.description();
		String material = hwc.material();
		String category = hwc.category();
		
		double dScaleX = hwc.dScaleX();
		double dScaleY = hwc.dScaleY();
		double dScaleZ = hwc.dScaleZ();
	
	// Compose additional map for formatting the hardware
		String k;
		k = "articleNumber"; 	if (!mapAdd.hasString(k))mapAdd.setString(k, articleNumber);
		k = "quantity"; 		if (!mapAdd.hasInt(k))mapAdd.setInt(k, hwc.quantity());
		k = "name"; 			if (name.length()>0 && !mapAdd.hasString(k))mapAdd.setString(k, name);
		k = "description"; 		if (description.length()>0 && !mapAdd.hasString(k))mapAdd.setString(k, description);
		k = "material";		 	if (material.length()>0 && !mapAdd.hasString(k))mapAdd.setString(k, material);
		k = "category"; 		if (category.length()>0 && !mapAdd.hasString(k))mapAdd.setString(k, category);
		
		k = "dScaleX";	if (dScaleX>0 && !mapAdd.hasDouble(k))mapAdd.setDouble(k, dScaleX);
		k = "dScaleY";	if (dScaleY>0 && !mapAdd.hasDouble(k))mapAdd.setDouble(k, dScaleY);
		k = "dScaleZ";	if (dScaleZ>0 && !mapAdd.hasDouble(k))mapAdd.setDouble(k, dScaleZ);
		
		String sTokens[] = hwc.notes().tokenize(";");
		Map mapToken = GetToken(sTokens, "Interdistance", 2);//formatType: 0 = string, 1 = int, 2 = _kLength, 3=_kArea, 4=_kVolume
		if (mapToken.length()>0)
			mapAdd.copyMembersFrom(mapToken);

		return;
	}//endregion 


	Map HardWrCompToMap(HardWrComp hwc)
	{
		Map m;
		
		m.setString("articleNumber",hwc.articleNumber());
		m.setString("name",hwc.name());
		m.setString("description",hwc.description());
		m.setString("manufacturer",hwc.manufacturer());
		m.setString("model",hwc.model());
		m.setString("material",hwc.material());
		m.setString("category",hwc.category());
		
		// HSB-22179 resolve interdistance
		String sTokens[] = hwc.notes().tokenize(";");
		if (sTokens.length()==1)
			m.setString("notes",hwc.notes());
		else
		{ 
			Map mapToken = GetToken(sTokens, "Interdistance", 2);
			m.copyMembersFrom(mapToken);
		}
		
//		else
//		{ 
//			for (int i=0;i<tokens.length();i++) 
//			{ 
//				String val = tokens[i]; 
//				if (val.makeUpper()=="INTERDISTANCE" && i<tokens.length()+1)
//				{ 
//					m.setDouble("Interdistance",tokens[i+1].atof());
//					i++;
//				}	
//				else
//				{ 
//					m.setString("notes",tokens[i]);
//				}
//			}//next i
//		}
		m.setInt("quantity",hwc.quantity());
		
		m.setDouble("dScaleX",hwc.dScaleX());
		m.setDouble("dScaleY",hwc.dScaleY());
		m.setDouble("dScaleZ",hwc.dScaleZ());		
		
		
		return m;
	}

//endregion 

//region DialogMode
	int nDialogMode = _Map.getInt("DialogMode");
	if (nDialogMode>0)
	{ 
		if (nDialogMode == 1) // specify index when triggered to get different dialogs
		{
			setOPMKey("AddDetail");	

		category = T("|General|");
//			String sColorName=T("|Color|");	
//			PropInt nColor(nIntIndex++, 7, sColorName);	
//			nColor.setDescription(T("|Defines the color|"));
//			nColor.setCategory(category);
//
			String sNameName=T("|Name|");	
			PropString sName(nStringIndex++, T("|Name|"), sNameName);	
			sName.setDescription(T("|Defines the name of the detail|"));
			sName.setCategory(category);

		}	
		else if (nDialogMode == 2) // specify index when triggered to get different dialogs
		{
			setOPMKey("AddEditRule");	

		category = T("|Rule|");

//
			String sNameName=T("|Name|");	
			PropString sName(nStringIndex++, T("|Name|"), sNameName);	
			sName.setDescription(T("|Defines the name of the detail|"));
			sName.setCategory(category);
			sName.setReadOnly(true);
			
			String sRuleName=T("|Rule|");	
			PropString sRule(nStringIndex++, T("|New Rule|"), sRuleName);	
			sRule.setDescription(T("|Defines the name of the rule|"));
			sRule.setCategory(category);
		
		category = T("|Distribution|");
			String sStartEndOffsetName=T("|Offset|");	
			PropDouble dStartEndOffset(nDoubleIndex++, U(0), sStartEndOffsetName);	
			dStartEndOffset.setDescription(T("|Defines the offset at the start and end of the distribution line for this rule|"));
			dStartEndOffset.setCategory(category);
			
			String sInterdistanceName=T("|Interdistance|");	
			PropDouble dInterdistance(nDoubleIndex++, U(0), sInterdistanceName);	
			dInterdistance.setDescription(T("|Defines the Interdistance|"));
			dInterdistance.setCategory(category);

			String sDistributionModeName=T("|Mode|");	
			PropString sDistributionMode(nStringIndex++, sDistributionModes, sDistributionModeName);	
			sDistributionMode.setDescription(T("|Defines the mode of the distribution|"));
			sDistributionMode.setCategory(category);		

		category = T("|Display|");
			String sColorName=T("|Color|");	
			PropInt nColor(nIntIndex++, 7, sColorName);	
			nColor.setDescription(T("|Defines the color|"));
			nColor.setCategory(category);

			String sTransparencyName=T("|Transparency|");	
			PropInt nTransparency(nIntIndex++, 60, sTransparencyName);	
			nTransparency.setDescription(T("|Defines the Transparency|"));
			nTransparency.setCategory(category);
			
			String sSizeName=T("|Size|");	
			PropDouble dSize(nDoubleIndex++, U(10), sSizeName);	
			dSize.setDescription(T("|Defines the size of the visualisation|") + T("|0 = no visualisation|"));
			dSize.setCategory(category);

		}		
		else if (nDialogMode == 3) // specify index when triggered to get different dialogs
		{
			setOPMKey("SelectRule");	

		category = T("|Rule|");
			String sNameName=T("|Name|");	
			PropString sName(nStringIndex++, T("|Name|"), sNameName);	
			sName.setDescription(T("|Defines the name of the detail|"));
			sName.setCategory(category);
			sName.setReadOnly(true);
			
			Map m = _Map.getMap("Rule[]");
			String rules[0];
			for (int i=0;i<m.length();i++) 
				rules.append(m.getString(i)); 

			String sRuleName=T("|Rule|");	
			PropString sRule(nStringIndex++, rules, sRuleName);	
			sRule.setDescription(T("|Defines the name of the rule to perform the action|"));
			sRule.setCategory(category);
		}		

		else if (nDialogMode == 4)
		{
			setOPMKey("DeleteDetail");	
	
			Map m = _Map.getMap("Entry[]");
			String entries[0];
			for (int i=0;i<m.length();i++) 
				entries.append(m.getString(i)); 

		category = T("|Rule|");
			String sNameName=T("|Name|");	
			PropString sName(nStringIndex++, entries, sNameName);	
			sName.setDescription(T("|Defines the name of the detail to be erased|"));
			sName.setCategory(category);

		}	

		return;		
	}
//End DialogMode//endregion

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="hsbCLT-FastenerLine";
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
		if (sFile.length()<1) sFile=findFile(sPathGeneral+sFileName+".xml");	
		if (sFile.length()>0)
		{ 
			mapSetting.readFromXmlFile(sFile);
			mo.dbCreate(mapSetting);			
		}
	}
	// validate version when creating a new instance
	if(_bOnDbCreated)
	{ 
		int nVersion = mapSetting.getInt("GeneralMapObject\\Version");
		String sFile = findFile(sPathGeneral + sFileName + ".xml");		// set default xml path
		if (sFile.length()<1) sFile=findFile(sFullPath);				// set custom xml path if no default found
		Map mapSettingInstall; mapSettingInstall.readFromXmlFile(sFile);	// read the xml from installation directory
		int nVersionInstall = mapSettingInstall.getMap("GeneralMapObject").getInt("Version");		
		if(sFile.length()>0 && nVersion!=nVersionInstall)
			reportNotice(TN("|A different Version of the settings has been found for|") + scriptName()+
			TN("|Current Version| ")+nVersion + "	" + _kPathDwg + TN("|Other Version| ") +nVersionInstall + "	" + sFile);
	}

//region Read Settings
	String sDetails[0];
	Map mapDetails= mapSetting.getMap("Detail[]");
{
	String k;

	for (int i=0;i<mapDetails.length();i++) 
	{ 
		Map m= mapDetails.getMap(i);
		String name = m.getMapName();
		if (sDetails.findNoCase(name,-1)<0 && name.length()>0)
			sDetails.append(name);
	}//next i
	sDetails = sDetails.sorted();
	if (sDetails.length()<1)
		sDetails.append(T("|Detail| 1"));

//	k="DoubleEntry";		if (m.hasDouble(k))	dDoubleEntry = m.getDouble(k);
//	k="StringEntry";		if (m.hasString(k))	sStringEntry = m.getString(k);
//	k="IntEntry";			if (m.hasInt(k))	sIntEntry = m.getInt(k);
	
}
//End Read Settings//endregion 	
	
	
	
//End Settings//endregion	

//region Properties
category = T("|Selection|");
	String sInsertModes[0];
	String sSecondaries[0];

// Get entities to contribute to selction property during insert
	Map mapFilters; // TODO modify / to be reworked when HSB-19396 is implemented
	if (0 && _bOnInsert)// || bDebug) // 
	{ 	
		Entity ents[] = Group().collectEntities(true, Sip(), _kModelSpace);
		for (int i=0;i<sPainters.length();i++) 
		{ 
			String painterDef =sPainters[i];
			Map map = getPainterGroups(painterDef, sPainterCollection, ents);
			for (int j=0;j<map.length();j++) 
			{  			
				Map m = map.getMap(j); 

				String g = m.getString("grouping");
				String p = m.getString("painter");
				int isFloor = m.getInt("isFloor");
				int isWall = m.getInt("isWall");
				
				String sInsertMode = p + "-" + g;
				if ((isFloor ||isWall) && sInsertModes.find(sInsertMode)<0)
					sInsertModes.append(sInsertMode);

				mapFilters.appendMap("Entry", m);
			}
		}// next i
		sInsertModes = sInsertModes.sorted();
	}

	sInsertModes.insertAt(0, tByWallConnection);
	sInsertModes.insertAt(0, tByWallFloorConnection);
	sInsertModes.insertAt(0, tByCoplanar);
	sInsertModes.insertAt(0, tByLine);
	String sInsertModeName=T("|Insert Mode|");	
	PropString sInsertMode(nStringIndex++, sInsertModes, sInsertModeName);	
	sInsertMode.setDescription(T("|Defines the selection preset for the first reference of a connection|"));
	sInsertMode.setCategory(category);
	sInsertMode.setReadOnly(bDebug || _bOnInsert ? false : _kHidden);
	
category = T("|Fastener|");
	String sDetailName=T("|Detail|");	
	PropString sDetail(nStringIndex++, sDetails, sDetailName);	
	sDetail.setDescription(T("|Defines the detail with the distribution rules|"));
	sDetail.setCategory(category);
	if (sDetails.length()>0 && sDetails.find(sDetail)<0)
		sDetail.set(sDetails.first());
	
category = T("|Display|");
	String sFormatName=T("|Format|");	
	PropString sFormat(nStringIndex++, "", sFormatName);	
	sFormat.setDescription(T("|Defines the Format|"));
	sFormat.setCategory(category);

	//region DimStyle
	// Find DimStyle Overrides, order and add Linear only
	String sDimStyles[0], sSourceDimStyles[0];
	{ 
	// append potential linear overrides	
		String sOverrides[0];
		for (int i=0;i<_DimStyles.length();i++) 
		{ 
			String dimStyle = _DimStyles[i]; 
			int n = dimStyle.find("$0", 0, false);	// indicating it is a linear override of the dimstyle
			if (n>-1 && sSourceDimStyles.find(dimStyle,-1)<0)
			{
				sDimStyles.append(dimStyle.left(n));
				sSourceDimStyles.append(dimStyle);
			}
		}//next i
		
	// append all non overrides	
		for (int i = 0; i < _DimStyles.length(); i++)
		{
			String dimStyle = _DimStyles[i]; 
			int nx = dimStyle.find("$", 0, false);	// <0 it is not any override of the dimstyle
			if (nx<0 && sDimStyles.findNoCase(dimStyle)<0)
			{ 
				sDimStyles.append(dimStyle);
				sSourceDimStyles.append(dimStyle);				
			}
		}

	// order alphabetically
		for (int i=0;i<sDimStyles.length();i++) 
			for (int j=0;j<sDimStyles.length()-1;j++) 
				if (sDimStyles[j]>sDimStyles[j+1])
				{
					sDimStyles.swap(j, j + 1);
					sSourceDimStyles.swap(j, j + 1);
				}
	}		
	String sDimStyleName=T("|Dimstyle|");	
	PropString sDimStyle(nStringIndex++, sDimStyles, sDimStyleName);	
	sDimStyle.setDescription(T("|Defines the Dimstyle|"));
	sDimStyle.setCategory(category);
	String dimStyle = sSourceDimStyles[sDimStyles.find(sDimStyle,0)];
	if (_DimStyles.findNoCase(dimStyle ,- 1) < 0)dimStyle = _DimStyles.first();		
	
	//endregion 	
	
	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(0), sTextHeightName);	
	dTextHeight.setDescription(T("|Defines the text height of the dimension|") + T(", |0 = byDimstyle|"));
	dTextHeight.setCategory(category);
	
	String tSText = T("|Text|"), tSBox=T("|Box|"), tSFilled= T("|Filled Box|");
	String sStyles[] ={tSFilled, tSBox, tSText};
	String sStyleName=T("|Style|");	
	PropString sStyle(nStringIndex++, sStyles, sStyleName);	
	sStyle.setDescription(T("|Defines the Style|"));
	sStyle.setCategory(category);
	if (sStyles.find(sStyle) < 0)sStyle.set(tSFilled);

	String sColorName=T("|Color|");	
	PropInt nColor(nIntIndex++, -1, sColorName);	
	nColor.setDescription(T("|Defines the color|") +  T(" |-1 = byConnectionType|"));
	nColor.setCategory(category);
	
	
	


//End Properties//endregion 


//End Part #1 //endregion 

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
		
		int bByLine = sInsertMode == tByLine;
		int bByCoplanar = sInsertMode == tByCoplanar;
		int bByWallConnection = sInsertMode == tByWallConnection;
		int bByWallFloorConnection = sInsertMode == tByWallFloorConnection;

	// TSL Cloning Prerequisites
		Entity entsTsl[] = {};						
		int nProps[]={nColor};			double dProps[]={dTextHeight};				
		String sProps[]={sInsertMode,sDetail, sFormat,sDimStyle,sStyle};
		Map mapTsl;	
		



		if (bByLine)
		{ 
			Entity ents[0];
			PrEntity ssE(T("|Select panels and (optional) defining polylines|"), Sip());
			ssE.addAllowedClass(EntPLine());
			if (ssE.go())
				ents.append(ssE.set());
		
		// collect panels and epls	
			for (int i=0;i<ents.length();i++) 
			{ 
				Sip sip = (Sip)ents[i]; 
				EntPLine epl= (EntPLine)ents[i];
				if (sip.bIsValid())
					_Sip.append(sip);
				else if (epl.bIsValid())
					_Entity.append(epl);
			}//next i				
				
		//region Set as distribution instance based on plines and panels
			if (_Entity.length()>0)
			{ 
				_Map.setInt("mode", 6);
				return;
			}
		//endregion 	
				
		}
		else if (bByCoplanar)
		{ 
			Entity ents[0];
			PrEntity ssE(T("|Select connecting panels|"), Sip());
			if (ssE.go())
				ents.append(ssE.set());
		
		// collect panels
			for (int i=0;i<ents.length();i++) 
			{ 
				Sip sip = (Sip)ents[i]; 
				if (sip.bIsValid())
					_Sip.append(sip);
			}//next i				

			
			
			_Map.setInt("mode", 2);
			//reportNotice("\ncreating mode 2 for sips "+ _Sip.length());//XX
			return;	
				
		}	
		else if (bByWallConnection)
		{ 
			mapTsl.setInt("mode",3);
			
		//region Keep on prompting until nothing selected or ESC		
			PrEntity ssE(T("|Select panels|"), Sip());				
			while (ssE.go() && (ssE.set().length()>0)) 
			{ 
				Entity ents[0];
				ents.append(ssE.set());	
				
				Sip males[] = filterEntityPanelsByType(ents, 1); // 1 = wall
				Sip females[] = males; // 2 = wall
				int numM = males.length();
				int numF = females.length();
				if (numM<2)
				{ 
					eraseInstance();
					return;
				}
							
			// create male / female connections
				reportMessage("\n" + scriptName() + T(" |connecting| ") + 
					numM + (numM==1?T(" |wall panel|"):T(" |wall panels|")));
					
				for (int i=0;i<males.length();i++) 
				{ 
					Sip sip = males[i];
				
				// create TSL
					TslInst tslNew;;
					GenBeam gbsTsl[] = {sip};
					for (int j=0;j<females.length();j++)
					{
						if (sip==females[j]){ continue;}
						gbsTsl.append(females[j]);
					}
									
					Point3d ptsTsl[] = {sip.ptCen()};					
					if (!bDebug && gbsTsl.length()>1)
					{
						tslNew.dbCreate(scriptName() , sip.vecX() ,sip.vecY(),gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	
					}
					
					
				}//next i				
				
			}
		//endregion 

			if (!bDebug) eraseInstance();
			return;


			
//			Entity ents[0];
//			PrEntity ssE(T("|Select conneting panels|"), Sip());
//			if (ssE.go())
//				ents.append(ssE.set());
//		
//		// collect panels and epls	
//			for (int i=0;i<ents.length();i++) 
//			{ 
//				Sip sip = (Sip)ents[i]; 
//				if (sip.bIsValid())
//					_Sip.append(sip);
//			}//next i				
//				
//		//region Set as distribution instance based on panels
//			if (_Sip.length()>1)
//			{ 
//				_Map.setEntityArray(_Sip, true, "Male[]", "", "Male");
//				_Map.setInt("mode", 1);
//				_Map.setInt("type",3);
//			}
//			else
//			{ 
//				eraseInstance();
//			}
//			return;
//		//endregion 	
				
		}		
		else if (bByWallFloorConnection)
		{ 
			
	
		//region Keep on prompting until nothing selected or ESC		
			PrEntity ssE(T("|Select panels and headers|"), Sip());
			ssE.addAllowedClass(Beam());
			while (ssE.go() && (ssE.set().length()>0)) 
			{ 
				Entity ents[0];
				ents.append(ssE.set());	
				
				Sip males[] = filterEntityPanelsByType(ents, 1); // 1 = wall
				Sip females[] = filterEntityPanelsByType(ents, 2); // 2 = floor
				int numM = males.length();
				int numF = females.length();				
				
			// get potential header beams connecting to a floor panel	
				Beam bmMales[0];
				if (numF>0)
					bmMales= filterEntityBeamsByPanel(ents, females);
				int numB = bmMales.length();

				if ((numM<1 && numB<1) || numF<1)
				{ 
					eraseInstance();
					return;
				}
							
			//region Create male / female panel connections
				reportMessage("\n" + scriptName() + T(" |connecting| ") + 
					numM + (numM==1?T(" |wall panel|"):T(" |wall panels|")) + T(" |and| ") + 
					numF + (numF==1?T(" |floor panel|"):T(" |floor panels|")));
					
				for (int i=0;i<males.length();i++) 
				{ 
					Sip sip = males[i];
				
				// create TSL
					TslInst tslNew;;
					GenBeam gbsTsl[] = {sip};
					for (int j=0;j<females.length();j++)
						gbsTsl.append(females[j]);
									
					Point3d ptsTsl[] = {sip.ptCen()};
					
					if (!bDebug && gbsTsl.length()>1)
					{
						mapTsl.setInt("mode",4);
						tslNew.dbCreate(scriptName() , sip.vecX() ,sip.vecY(),gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	
					}
				}//next i					
			//endregion 
			
			//region Create male beam / female panel connections
				reportMessage("\n" + scriptName() + T(" |connecting| ") + 
					numB + (numB==1?T(" |beam|"):T(" |beams|")) + T(" |and| ") + 
					numF + (numF==1?T(" |floor panel|"):T(" |floor panels|")));
					
				for (int i=0;i<bmMales.length();i++) 
				{ 
					Beam b = bmMales[i];
				
				// create TSL
					TslInst tslNew;;
					GenBeam gbsTsl[] = {b};
					for (int j=0;j<females.length();j++)
						gbsTsl.append(females[j]);
									
					Point3d ptsTsl[] = {b.ptCen()};
					
					if (!bDebug && gbsTsl.length()>1)
					{
						mapTsl.setInt("mode",8);
						tslNew.dbCreate(scriptName() , b.vecX() ,b.vecY(),gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	
					}
				}//next i					
			//endregion 				
				
			}
		//endregion 

			if (!bDebug) eraseInstance();
			return;
		}
		else
		{ 
			eraseInstance();
		// Get insertion mode from 	

			
			
//			Entity males[0], females[0];
//			int nType; // 0 = byLine, 1=floor, 2=wall/floor, 3 =wall/wall
//			for (int i=0;i<mapFilters.length();i++) 
//			{ 
//				Map m = mapFilters.getMap(i);
//				
//				String g = m.getString("grouping");
//				String p = m.getString("painter");
//				String folder = m.getString("folder"); 
//				int isFloor = m.getInt("isFloor");
//				int isWall = m.getInt("isWall");
//				
//				String insertMode = p + "-" + g;
//				String def = folder + p;
//				PainterDefinition pd(def);
//				if (insertMode == sInsertMode)
//				{ 
//					if (isWall)
//					{	
//						nType = 3; // wall/wall
//					}
//					else if(isFloor)
//						nType = 1; // floor or floor/wall
//						
//						
//					males = m.getEntityArray("Entity[]", "", "Entity");	
//
//				}
//				if (!bSkipSecondary && val == sSecondary && sSecondary!=sInsertMode)
//				{ 
//					females= m.getEntityArray("Entity[]", "", "Entity");
//			
//				}				
//			}//next i			
//
//			reportNotice("\n"+scriptName() + T(" |inserting connections on| ") + (males.length()+females.length()) + T(" |panels, please wait...|"));
//
//			_Map.setInt("mode", 1); // Distribution Mode
//			_Map.setEntityArray(males, false, "Male[]", "", "Male");
//			_Map.setEntityArray(females, false, "Female[]", "", "Female");
//			_Map.setInt("type", nType);
			
		}		
		
		
		return;
	}			
//endregion 

//region Part #2

//region Standards
	Sip sip,sips[] = _Sip, sipOthers[0];
	Beam beams[] = _Beam;
	Vector3d vecX = _XE, vecY = _YE, vecZ = _ZE;
	Point3d ptCen = _Pt0;
	double dH;
	
	PLine plines[0]; //the segments to distribute the fasteners on
	Map mapAdd; // a map containing the additional fastener tag data
				
// Collect potential entplines
	EntPLine epls[0];
	for (int i=0;i<_Entity.length();i++) 
	{ 
		Entity& e = _Entity[i];
		EntPLine epl= (EntPLine)e;
		
		if (epl.bIsValid())
		{
			epls.append(epl);
			plines.append(epl.getPLine());
			setDependencyOnEntity(e);
		}
		 
	}//next i

// assignment
	PlaneProfile pps[0];
	PLine plEnvelopes[0];
	if (sips.length()>0)
	{ 
		sip = sips[0];	
		ptCen = sip.ptCen();
		vecX = sip.vecX();
		vecY = sip.vecY();
		vecZ = sip.vecZ();
		dH = sip.dH();
		Point3d ptFace = sip.ptCen() + vecZ * .5 * sip.dH();
		Plane pn(ptFace, vecZ);
		
		sipOthers = sips;
		
		Element elements[0];
		for (int i=0;i<sips.length();i++) 
		{ 
			plEnvelopes.append(sips[i].plEnvelope());
			PlaneProfile pp(CoordSys(ptFace, vecX, vecY, vecZ));
			pp.unionWith(sip.envelopeBody(false, true).shadowProfile(pn));
			pps.append(pp);
			
			Element el = sips[i].element();
			if (el.bIsValid() && elements.find(el)<0)
				elements.append(el);	 
		}//next i
		
	// has element
		if (elements.length()>0)
			for (int i=0;i<elements.length();i++) 
				assignToElementGroup(elements[i], elements.length()>1,0,'I'); 
	// loose panel
		else
			assignToGroups(sips[0], 'I');
	}
	
// PLine only
	else if (epls.length()>0)
	{ 
		assignToGroups(epls.first(), 'I');	
	}		


// White Display needs to be declared first to overlap others
	Display dpWhite(-1), dp(-1);
	dpWhite.trueColor(rgb(255, 255, 254),30);

	dpWhite.showInDxa(true);
	dp.showInDxa(true);
	

	double textHeight = dTextHeight;
	if (textHeight<=0)
		textHeight = dp.textHeightForStyle("O", dimStyle);
	else
		dp.textHeight(textHeight);

// Text Grip
	int nIndexTagGrip = -1;
	for (int i=0;i<_Grip.length();i++) 
	{ 
		if (_Grip[i].name() == "tag")
		{
			nIndexTagGrip = i;
			break;
		}	 
	}//next i


// Behaviour
	setCloneDuringBeamSplit(_kAuto);
	setKeepReferenceToGenBeamDuringCopy(_kAllBeams);
	_ThisInst.setDrawOrderToFront(true);	
	if (nIndexTagGrip>-1)
		_ThisInst.setAllowGripAtPt0(false);

//endregion 

//region Trigger
	
//region Trigger RevertDirection
	int bRevert = _Map.getInt("revertDirection");
	String sTriggerRevertDirection = T("|Revert Direction|");
	addRecalcTrigger(_kContextRoot, sTriggerRevertDirection );
	if (_bOnRecalc && _kExecuteKey==sTriggerRevertDirection)
	{
		_Map.setInt("revertDirection",!bRevert);		
		setExecutionLoops(2);
		return;
	}//endregion	
	
	
//endregion 

// decalre range to be drawn
	PlaneProfile ppRange;


//region Mode 0: PLine alike
	
	if (nMode == 0)
	{ 
		
		;
		
		
		
	}	
//endregion 	

//region Mode 1: Distribute #1
	else if (nMode == 1)
	{
		Entity ents[0];
		int type = _Map.getInt("type");
		int num;
		
	// get males	
		ents= _Map.getEntityArray("Male[]", "", "Male");
		
		Sip sips[0], sips0[0],sips1[0];
		Body bodies[0], bodies0[0], bodies1[0];

		for (int i=0;i<ents.length();i++)
		{
			Sip sipI =(Sip)ents[i];
			sips.append(sipI);
			Body bd = sipI.envelopeBody();
			bodies.append(bd);
		}


	// distribute floor
		if (type==1)
		{ 
			Plane pn(_Pt0, _ZW);

			
		//region Find one-on-one
			int tick = getTickCount();
//			 int ergebnis = 1;
//            for (int i = 1; i<= n; i++)
//                ergebnis *= i;
			for (int i=0;i<sips.length();i++) 
			{ 
				Body bdA = bodies[i];					//bdA.vis(i);
				for (int j=i+1;j<sips.length();j++) 
				{ 
					Body bdB = bodies[j];				//bdB.vis(j);
					if (bdA.hasIntersection(bdB))
					{ 
						
					// debug
						if (bDebug)
						{ 
							PLine pl (bdA.ptCen(), bdB.ptCen());
							pl.vis(i%4);								
						}
	
						else
						{ 
						// create TSL
							TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
							GenBeam gbsTsl[] = {sips[i],sips[j]};		
							Entity entsTsl[] = {};			
							Point3d ptsTsl[] = {sips[i].ptCen()};
							int nProps[]={(nColor<0?3:nColor)};			
							double dProps[]={dTextHeight};				
							String sProps[]={sInsertMode,sDetail, sFormat,sDimStyle,sStyle};;
							Map mapTsl;	
							mapTsl.setInt("mode",2);			
							tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	
							
							if (tslNew.bIsValid())
							{
								num++;
							}
						}	
					}	
				}//next j
			}//next i
			if(bDebug)reportNotice("\ntick : " + (getTickCount()-tick));
		//endregion 
			
		}
		
	// distribute Wall/Wall	
		else if (type==3)
		{ 
			//bDebug = true;
			
			for (int i = 0; i < sips.length(); i++)
			{
				Sip sip0 = sips[i];
				Point3d ptCen = sip0.ptCen();
				Vector3d vecZ0 = sip0.vecZ();
				double radius = sip0.dH()*.5;
				Plane pnZ(ptCen, vecZ0);
				SipEdge edges[] = sip0.sipEdges();
				
				Sip sipOthers[0];sipOthers = sips;
				sipOthers.removeAt(i); // remove main
				
			// get direction vector	
				Vector3d vecDir = getConnectionEdges(sip0, edges, sipOthers);

			// Get panels being connected to edge
				for (int j=0;j<edges.length();j++) 
				{ 
					PLine plEdge = edges[j].plEdge();
					Sip sipFemales[] = getTConnectedPanels(vecDir, pnZ, radius, plEdge, sipOthers);

					if (sipFemales.length()>0 && !bDebug)
					{ 
						reportNotice(".");
					// create TSL
						TslInst tslNew;;
						GenBeam gbsTsl[] = {sip0};
						for (int jj=0;jj<sipFemales.length();jj++)
							gbsTsl.append(sipFemales[jj]);
						Entity entsTsl[] = {};			
						Point3d ptsTsl[] = {plEdge.ptMid()};
						int nProps[]={(nColor<0?4:nColor)};			double dProps[]={dTextHeight};				
						String sProps[]={sInsertMode,sDetail, sFormat,sDimStyle,sStyle};;
						Map mapTsl;	
						mapTsl.setInt("mode",3);	
						if (!bDebug)
							tslNew.dbCreate(scriptName() , vecDir ,vecDir.crossProduct(-vecZ0),gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	
						
						if (tslNew.bIsValid())
							num++;
					
					}					 
				}//next j
				
			



//region OLD
//				double r = sip0.dH()*.5;
//				if (!vecZ0.isPerpendicularTo(_ZW)){ continue;}
//				
//				Body bdA = bodies[i];					bdA.vis(i);
//				
//			// get horizontal vec
//				//Vector3d vecDir = vecZ0.crossProduct(-_ZW);
//				
//				
//			// Collect connecting sips on vertical edges
//				
//				for (int j=edges.length()-1; j>=0 ; j--) 
//				{ 
//					PLine pl = edges[j].plEdge();
//					Vector3d vecXE = pl.ptEnd()-pl.ptStart();	vecXE.normalize(); 
//					if (vecXE.isParallelTo(_ZW))
//					{
//						pl.projectPointsToPlane(pnZ,vecZ0);
//						if (pl.length() < dEps) { continue;};
//						Body cap(pl.ptStart(), pl.ptEnd(), r );
//						cap.vis(j);
//						
//						if(vecDir.dotProduct(cap.ptCen()-ptCen)<0)
//							vecDir *= -1;
//						vecDir.vis(cap.ptCen(), i);
//						
//						Sip sipsX[]= cap.filterGenBeamsIntersect(sipOthers);
//					
//					// remove results coplanar to this
//						for (int jj=sipsX.length()-1; jj>=0 ; jj--) 
//							if (sipsX[jj].vecZ().isParallelTo(vecZ0))
//								sipsX.removeAt(jj); 
//
//						if (sipsX.length()>0 && !bDebug)
//						{ 
//						// create TSL
//							TslInst tslNew;;
//							GenBeam gbsTsl[] = {sip0};
//							for (int jj=0;jj<sipsX.length();jj++)
//								gbsTsl.append(sipsX[jj]);
//							Entity entsTsl[] = {};			
//							Point3d ptsTsl[] = {cap.ptCen()};
//							int nProps[]={(nColor<0?4:nColor)};			double dProps[]={dTextHeight};				
//							String sProps[]={sInsertMode,sDetail, sFormat,sDimStyle,sStyle};;
//							Map mapTsl;	
//							mapTsl.setInt("mode",3);	
//							if (!bDebug)
//								tslNew.dbCreate(scriptName() , vecDir ,vecDir.crossProduct(-vecZ0),gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	
//							
//							if (tslNew.bIsValid())
//								num++;
//						
//						}
//						else
//						{ 
//							for (int jj=0;jj<sipsX.length();jj++) 
//							{ 
//								sipsX[jj].envelopeBody().vis(i); 
//								 
//							}//next jj							
//						}
//						
//						
//						
//						
//					}
//				}//next j		
//endregion 


				
			}// next i
		}
		
		if (!bDebug)
		{ 
			//reportNotice("\n"+num + " " + scriptName() + T(" |created|"));
			eraseInstance();
			return;
		}
		else
		{ 
			Display dpx(1);
			dpx.textHeight(U(100));
			dpx.draw(scriptName(), _Pt0, _XW, _YW, 0, 0, _kDevice);					
		}
		
		
	}
//endregion

//region Mode 2: Floor Connection #M2
	else if (nMode==2)	
	{ 
		if (nColor < 0)nColor.set(nMode);
		
	//region Redistribute one-on-one connections
		if (sips.length()>2)
		{ 
		
		// Prerequisites TSL
			TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;		
			Entity entsTsl[] = {};			
			int nProps[]={(nColor<0?3:nColor)};			
			double dProps[]={dTextHeight};				
			String sProps[]={sInsertMode,sDetail, sFormat,sDimStyle,sStyle};;
			Map mapTsl;	
			mapTsl.setInt("mode",2);		

		// collect envelope bodies
			Body bodies[0];
			for (int i=0;i<sips.length();i++)
				bodies.append(sips[i].envelopeBody());
			
			for (int i=0;i<sips.length();i++) 
			{ 
				Body bdA = bodies[i];					//bdA.vis(i);
				Vector3d vecZA = sips[i].vecZ(); 
				for (int j=i+1;j<sips.length();j++) 
				{ 
					Vector3d vecZB = sips[j].vecZ();
					if (!vecZA.isParallelTo(vecZB))
					{ 
						continue;
					}
					
					
					Body bdB = bodies[j];				//bdB.vis(j);
					if (bdA.hasIntersection(bdB))
					{ 
						
					// debug
						if (bDebug)
						{ 
							PLine pl (bdA.ptCen(), bdB.ptCen());
							pl.vis(i%4);								
						}
	
						else
						{ 
							
							reportNotice("\n" + _ThisInst.handle() + " creates new instance with others " + sips[j].handle());//XX
							
							bdB.intersectWith(bdA);
							
						// create TSL
							GenBeam gbsTsl[] = {sips[i],sips[j]};					
							Point3d ptsTsl[] = {bdB.ptCen()};
							tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	
							
//							if (tslNew.bIsValid())
//								num++;
						}	
					}	
				}//next j
			}//next i
		
			if (!bDebug)eraseInstance();
			return;
		}		
	//endregion 

		if (sips.length()<2)
		{ 
			eraseInstance();
			return;
		}

		Sip sip1 = sips[1];
		SipEdge edge, edges[] = sip.sipEdges();
		
		Point3d ptCen1=sip1.ptCen();		
		Vector3d vecZ1 = sip1.vecZ();

		Point3d ptFace = ptCen - vecZ * .5 * dH;
		
		
		Body bd0 = sip.envelopeBody();
		Body bd1 = sip1.envelopeBody();
		Body bdX = bd0;
		bdX.intersectWith(bd1);
		
		if (bdX.isNull() || !vecZ.isParallelTo(vecZ1))
		{ 
			reportMessage(TN("|No intersection found.|"));	
			eraseInstance();
			return;
		}
		
	// Get edge	
		Point3d ptCenX = bdX.ptCen();
		int nRing = sip.findClosestRingIndex(ptCenX); //ptCen1
		int nEdge = sip.findClosestEdgeIndex(ptCenX); 
		if (nEdge <0)
		{ 
			eraseInstance();
			return;
		}
		edge = edges[nEdge];
		
		//_Pt0 = edge.ptMid();
		PLine plEdge = edge.plEdge();			plEdge.vis(6);

		Vector3d vecXC = plEdge.ptEnd() - plEdge.ptStart(); vecXC.normalize();
		Vector3d vecYC = vecXC.crossProduct(-vecZ);
		Vector3d vecZC = vecZ;
		CoordSys csFace(ptFace, vecXC, vecYC, vecZC);		csFace.vis(3);	

		Plane pnFace (ptFace, vecZC);
		PlaneProfile pp0(csFace);
		pp0.unionWith(sip.envelopeBody(false, true).extractContactFaceInPlane(pnFace, dEps));
		
		PlaneProfile pp1(pp0.coordSys());
		bd1 = sip1.envelopeBody(false, true);
		pp1 = bd1.shadowProfile(pnFace);
		
		ppRange = pp1;
		ppRange.intersectWith(pp0);

		LineSeg seg(ppRange.ptMid() - vecXC*U(10e4), ppRange.ptMid() + vecXC*U(10e4));
		plines.append(getSplitPLines(ppRange, seg));

	}



//endregion 

//region Mode 3: byWall #M3
	else if (nMode==3 && sips.length()>1)
	{ 
		//reportNotice("\n" + _ThisInst.handle() + " runs in mode " + nMode + " _Sip " + _Sip + " Detail " + sDetail);
		
		if (nColor < 0)nColor.set(nMode);

		Plane pnZ(ptCen, vecZ);
		SipEdge edges[] = sip.sipEdges();
		Sip sipOthers[0]; sipOthers = sips;
		sipOthers.removeAt(0);
		
		Vector3d vecDir = getConnectionEdges(sip, edges, sipOthers);
		vecDir.vis(_Pt0, 4);
		
		Sip sipsX[0]; 
		Plane pnFace;
		
		int bPurge; // purge this instance if it is a distributing instance
		for (int i=0;i<edges.length();i++) 
		{ 
			Sip sipsTX[] = getTConnectedPanels(vecDir, pnZ, dH*.5, edges[i].plEdge(), sipOthers);
			if (sipsTX.length()<1){ continue;}
			
		// connected panels of this instance	
			if (sipsX.length()<1)
			{ 
				vecDir = edges[i].vecNormal();
				sipsX = sipsTX;
				pnFace = Plane(edges[i].ptMid(), vecDir);
				
			// reset _Sip array if a one-to-one relation has been detected to avoid incremental creation of connections
				if (sipsX.length()==1)
				{ 
					_Sip.setLength(0);
					_Sip.append(sip);
					_Sip.append(sipsX[0]);
				}
				
			}
		// multiple edges: create additional instances
			else if (!bDebug)
			{ 
				bPurge = true;
				//reportNotice("\n" + _ThisInst.handle() + " creates new instance with others " + sipsTX);
				
				
			// create TSL
				TslInst tslNew;;
				GenBeam gbsTsl[] = {sip};
				for (int j=0;j<sipsTX.length();j++)
					gbsTsl.append(sipsTX[j]);
				Entity entsTsl[] = {};			
				Point3d ptsTsl[] = {edges[i].plEdge().ptMid()};
				int nProps[]={nColor};			double dProps[]={dTextHeight};				
				String sProps[]={sInsertMode,sDetail, sFormat,sDimStyle,sStyle};;
				Map mapTsl;	
				mapTsl.setInt("mode",3);			
				tslNew.dbCreate(scriptName() , vecDir ,vecDir.crossProduct(-vecZ),gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);								
			}
		}//next i
		if (sipsX.length()<1 || bPurge)
		{ 
			//reportNotice("\n" + _ThisInst.handle() + " will be purged");
			eraseInstance();
			return;
		}
		
	//region Get fastener segments
		Vector3d vecZ1 = vecDir;
		Vector3d vecY1 = vecZ.crossProduct(vecZ1);
		Vector3d vecX1 = vecY1.crossProduct(vecZ1);
		Vector3d vecPerp = vecDir.crossProduct(-vecZ);
		PlaneProfile pp0(CoordSys(pnFace.ptOrg(), vecX1, vecY1, vecZ1));
		pp0.unionWith(sip.envelopeBody().extractContactFaceInPlane(pnFace, dEps));
		if (pp0.area()<pow(dEps,2))
			pp0.unionWith(sip.envelopeBody().getSlice(pnFace));
		if (pp0.area()<pow(dEps,2))
			pp0.unionWith(sip.envelopeBody().shadowProfile(pnFace));	
		pp0.vis(1);	
		
		
		PlaneProfile pp1(pp0.coordSys());
		for (int i=0;i<sipsX.length();i++) 
		{ 
			PlaneProfile pp(pp0.coordSys());
			//pp.unionWith(sipsX[i].envelopeBody(false, true).shadowProfile(pnFace)); 
			pp.unionWith(sipsX[i].envelopeBody(false, true).extractContactFaceInPlane(pnFace, dEps)); 
			pp.shrink(-dEps);
			pp1.unionWith(pp);
		}//next i
		pp1.shrink(dEps);	//pp1.vis(3);	
		
		ppRange = pp1;
		ppRange.intersectWith(pp0);

		LineSeg seg(pp0.ptMid() - vecY1 * U(10e4), pp0.ptMid() + vecY1 * U(10e4));			
		plines.append(getSplitPLines(ppRange, seg));		

	//endregion 

	// purge
		if (plines.length()<1)
		{ 
			String msg = T(": |Panels| ")+(sip.posnum()<0?sip.handle():sip.posnum()) + ": ";
			for (int i=0;i<sipsX.length();i++) 
			{ 
				Sip sipX = sipsX[i];
				if (i > 0)msg += ", ";
				msg += (sipX.posnum() < 0 ? sipX.handle() : sipX.posnum()); 
			}//next i
			
			
			reportNotice("\n" + scriptName() + msg + TN(" |No segments found, purging tool|") );
			eraseInstance();
			return;
		}

	}
//endregion 

//region Mode 4: byWallFloor #4
	else if (nMode==4 && sips.length()>1)
	{ 
		if (nColor < 0)nColor.set(nMode);

		Plane pnZ(ptCen, vecZ);
		SipEdge edges[] = sip.sipEdges();
		Sip sipOthers[0]; sipOthers = sips;
		sipOthers.removeAt(0);

		Map mapConnections = getConnectionsInDir(sip, edges, sipOthers, _ZW);

		int numConnection = mapConnections.length();
		if (numConnection<1)
		{ 
			eraseInstance();
			return;
		}
	//region Redistribute if multiple connections are found
		else if (numConnection>1)
		{ 
			for (int i=0;i<mapConnections.length();i++) 
			{ 
				Map m = mapConnections.getMap(i); 
				Entity ents[] = m.getEntityArray("ent[]", "", "ent");
				PLine plEdge = m.getPLine("plEdge");
			// create TSL
				TslInst tslNew;;
				GenBeam gbsTsl[] = {sip};
				for (int j=0;j<ents.length();j++)
				{
					Sip sip1 = (Sip)ents[j];
					if (sip1.bIsValid())
						gbsTsl.append(sip1);
				}
				Entity entsTsl[] = {};			
				Point3d ptsTsl[] = {plEdge.ptMid()};
				int nProps[]={nColor};			double dProps[]={dTextHeight};				
				String sProps[]={sInsertMode,sDetail, sFormat,sDimStyle,sStyle};;
				Map mapTsl;	
				mapTsl.setInt("mode",4);			
				
				if (!bDebug)
					tslNew.dbCreate(scriptName() , _YW ,_ZW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);				
				 
			}//next i
			if (!bDebug)
			{
				eraseInstance();
				return;
			}
		}//endregion 

	//region Connection Mode
		Map m = mapConnections.getMap(0); 
		Entity ents[] = m.getEntityArray("ent[]", "", "ent");
		Sip females[0];
		for (int i=0;i<_Sip.length();i++) 
			if (ents.find(_Sip[i])>-1)
				females.append(_Sip[i]);

	//Get Contact Plane
		PLine plEdge = m.getPLine("plEdge");				//plEdge.vis(1);
		Vector3d vecFace = m.getVector3d("vecDir");
		Point3d ptFace = plEdge.ptMid();
		int nEdge = sip.findClosestEdgeIndex(ptFace);
		if (nEdge >- 1)
		{
			ptFace = edges[nEdge].ptMid();
			vecFace = edges[nEdge].vecNormal();
		}	
		Plane pnFace(ptFace, vecFace);

		Vector3d vecXC = vecFace.crossProduct(-vecZ);
		Vector3d vecYC = vecXC.crossProduct(-vecFace);
		Vector3d vecZC = vecXC.crossProduct(vecYC);
		CoordSys csFace(ptFace, vecXC, vecYC, vecZC);		//csFace.vis(3);	

	//Connection PlaneProfile
		Body bd0 = sip.realBody();
		PlaneProfile pp0(csFace);
		pp0.unionWith(bd0.extractContactFaceInPlane(pnFace, dEps));		pp0.vis(1);	
				
		PlaneProfile pp1(pp0.coordSys());
		for (int i=females.length()-1; i>=0 ; i--) 
		{ 
			PlaneProfile pp(pp0.coordSys());
			pp.unionWith(females[i].envelopeBody().extractContactFaceInPlane(pnFace, dEps)); 
			
		
			pp.shrink(-dEps);
			pp1.unionWith(pp);
		}//next i			
		pp1.shrink(dEps);	//pp1.vis(3);
		
// Suspected to cause crashes, feature removed 	V1.6	
//	//region Fall back to potential beamcut plane if no contact could be found
//		if (pp1.area()<pow(dEps,2) && females.length()>0)
//		{ 
//			Sip sip1 = females.first();
//			ptFace = sip1.ptCen() - .5 * vecZC * sip1.dH();
//			pnFace = Plane (ptFace, vecFace);
//			csFace=CoordSys(ptFace, vecXC, vecYC, vecZC);
//			
//			PlaneProfile pp0B(csFace);
//			pp0B.unionWith(bd0.extractContactFaceInPlane(pnFace, dEps));		pp0B.vis(1);	
//			
//			PlaneProfile pp1B(pp0B.coordSys());
//			for (int i=females.length()-1; i>=0 ; i--) 
//			{ 
//				PlaneProfile pp(pp0B.coordSys());
//				pp.unionWith(females[i].envelopeBody().extractContactFaceInPlane(pnFace, dEps)); 
//				
//			
//				pp.shrink(-dEps);
//				pp1B.unionWith(pp);
//			}//next i			
//			pp1B.shrink(dEps);	pp1B.vis(3);			
//			
//			pp0 = pp0B;
//			pp1 = pp1B;
//			
//		}
//	//endregion 	
		

	// purge non intersecting females from _Sip
		if (_Sip.length()>females.length()+1 && ppRange.area()>pow(dEps,2))
		{ 
			for (int i=_Sip.length()-1; i>=0 ; i--) 
			{ 
				if (_Sip[i]==sip){ continue;}
				PlaneProfile pp(pp0.coordSys());
				pp.unionWith(_Sip[i].envelopeBody().extractContactFaceInPlane(pnFace, dEps)); 
				if (!pp.intersectWith(pp0))
					_Sip.removeAt(i);					
			}
		}


		ppRange = pp1;
		ppRange.intersectWith(pp0);			//ppRange.vis(6);
		
		LineSeg seg(pp0.ptMid() - vecXC * U(10e4), pp0.ptMid() + vecXC * U(10e4));			
		plines.append(getSplitPLines(ppRange, seg));

	//END Connection Mode//endregion 

	}//endregion 

//region Mode 5: ByLine
	else if (nMode==5)
	{ 
		Point3d pts[] = _Map.getPoint3dArray("pts");
		if (sips.length()<1 || pts.length()<2)
		{ 
			eraseInstance();
			return;
		}
		_ThisInst.setAllowGripAtPt0(false);
		
		Sip sip0 = sips[0];
		Point3d ptCen0 = sip0.ptCen();
		Vector3d vecX0 = sip0.vecX();
		Vector3d vecY0 = sip0.vecY();
		Vector3d vecZ0 = sip0.vecZ();
		double dZ0 = sip0.dH();		
		
		Point3d ptFace = ptCen0 - vecZ0 * .5 * dZ0;
		Plane pn(ptFace, vecZ0);
		
		Vector3d vecDir = _Map.getVector3d("vecDir");
		if (vecDir.bIsZeroLength())
		{ 
			vecDir = pts.first()-pts.last();
			vecDir.normalize();
			_Map.setVector3d("vecDir", vecDir);
		}
		Vector3d vecPerp = vecDir.crossProduct(-vecZ0);
		
		Point3d ptRef = _Pt0;
		ptRef += vecZ0 * vecZ0.dotProduct(ptFace - ptRef);
		Line ln(ptRef, vecDir);
		
		if (_Grip.length()<2)
		{ 
			_Grip.setLength(0);

			for (int i=0;i<pts.length();i++) 
			{ 
				Grip grip(pts[i]);
			    grip.setShapeType(_kGSTArrow);
			    grip.setColor(4);
			    grip.addHideDirection(vecDir);
				grip.addHideDirection(-vecDir);
				grip.setVecX(vecDir);
				grip.setVecY(vecPerp);
				grip.setToolTip(T("|Move grip to adjust length of fastener line|"));
				 _Grip.append(grip);
				 
				 vecDir*= - 1;
				 vecPerp*= - 1;
				 
				 if (i == 1)break;
			}//next i
		}
		else
		{ 
			for (int i=0;i<_Grip.length();i++) 
			{ 
				Grip& grip = _Grip[i];
				grip.setPtLoc(ln.closestPointTo(grip.ptLoc()));
//
//				vecDir*= - 1;
//				vecPerp*= - 1;
//				 
				if (i == 1)break;
			}//next i			
		}
		
	// add tag location grip	
		if (_Grip.length()<3)
		{ 
			Grip grip(_Pt0+vecPerp * U(150));
		    grip.setShapeType(_kGSTCircle);
		    grip.setName("tag");
		    grip.setColor(40);
		    grip.addHideDirection(vecDir);
			grip.addHideDirection(-vecDir);
			grip.setVecX(vecDir);
			grip.setVecY(vecPerp);
			grip.setToolTip(T("|Move to adjust tag location|"));
			 _Grip.append(grip);		
		}
		
		PLine pl(vecZ0);
		pl.addVertex(_Grip[0].ptLoc());
		pl.addVertex(_Grip[1].ptLoc());
		plines.append(pl);
		
		dp.addHideDirection(vecDir);
		dp.addHideDirection(-vecDir);	
		dp.draw(pl);

	}
//endregion

//region Mode 6: Distribute by polylines and panels
	else if (nMode == 6)
	{
	// create TSL
		TslInst tslNew;
				
		int nProps[]={nColor};			
		double dProps[]={dTextHeight};				
		String sProps[]={sInsertMode,sDetail, sFormat,sDimStyle,sStyle};
		Map mapTsl;	

	// Loop plines	
		for (int i=0;i<plines.length();i++) 
		{ 
			PLine& pl = plines[i]; 
			CoordSys csp = pl.coordSys();
			Vector3d vecZP = csp.vecZ();
			Vector3d vecXTsl = csp.vecX(), vecYTsl = csp.vecY();

			Point3d ptsTsl[] = {};
			GenBeam gbsTsl[] = {};
			Entity entsTsl[] = {epls[i]};	
		
		
		// Loop intersecting sip / shapes / envelopes
			for (int j=0;j<pps.length();j++) 
			{ 
				PlaneProfile pp= pps[j]; 
				CoordSys csj = pp.coordSys();
				Vector3d vecZJ = csj.vecZ(); 

				if (vecZJ.isPerpendicularTo(vecZP))
				{ 
					continue;
				}
				Plane pnj (csj.ptOrg(), vecZJ);
				PLine plj = pl;
				plj.projectPointsToPlane(pnj, vecZP);

			// accept if intersecting or one of the points is inside
				if (plj.length()<dEps){ continue;}
				int bOk = plj.intersectPLineAsDistances(plEnvelopes[j]).length()>0;
				if (pp.pointInProfile(plj.ptStart()) != _kPointOutsideProfile) bOk = true;

				if (bOk)
				{
				// set origin and vecs	
					if (ptsTsl.length()<1)
					{
						ptsTsl.append(plj.ptMid());
						vecXTsl = csj.vecX();
						vecYTsl = csj.vecY();						
						
					}

					gbsTsl.append(sips[j]);
				}
					
				plj.vis(bOk?3:1);	
					
			}
		
		// no panel reference found, use mid of pline as reference location	
			if (gbsTsl.length()<1)
				ptsTsl.append(pl.ptMid());	

		
			if (bDebug) 
				;
			else
				tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);

		}//next i

		if (!bDebug) eraseInstance();
		else dp.draw(scriptName(), _Pt0, _XW, _YW, 1, 0);
		return;
	}
//endregion

//region Mode 8: byBeamFloor
	else if (nMode==8 && sips.length()>0 && beams.length()>0)  //#8
	{ 
		if (nColor < 0)nColor.set(nMode);

	// Main ref beam beam mode
		Beam b = beams.first();
		vecX = b.vecX();
		vecZ = b.vecD(_ZW);
		vecY = vecX.crossProduct(-vecZ);
		ptCen = b.ptCen();

	//region Redistribute if multiple connections are found
		if (beams.length()>1)
		{ 
			for (int i=0;i<beams.length();i++) 
			{ 
			// create TSL
				TslInst tslNew;;
				GenBeam gbsTsl[] = {beams[i]};
				for (int j=0;j<_Sip.length();j++)
					gbsTsl.append(_Sip[j]);
				Entity entsTsl[] = {};			
				Point3d ptsTsl[] = {beams[i].ptCen()};
				int nProps[]={nColor};			double dProps[]={dTextHeight};				
				String sProps[]={sInsertMode,sDetail, sFormat,sDimStyle,sStyle};;
				Map mapTsl;	
				mapTsl.setInt("mode",8);			
				
				if (!bDebug)
					tslNew.dbCreate(scriptName() , vecX ,vecY,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);				
				 
			}//next i
			if (!bDebug)
			{
				eraseInstance();
				return;
			}
		}//endregion 

	// collect panels aligned with the contact direction
		Sip females[0];
		for (int i=0;i<_Sip.length();i++) 
			if (_Sip[i].vecZ().isParallelTo(vecZ))
				females.append(_Sip[i]);

	//Get Contact Plane
		Vector3d vecFace = vecZ;
		Point3d ptFace = ptCen+vecFace*.5*b.dD(vecZ);
		Plane pnFace(ptFace, vecFace);

		CoordSys csFace(ptFace, vecX, vecY, vecZ);		//csFace.vis(3);

	//region Connection PlaneProfile
		PlaneProfile pp0(csFace);
		pp0.unionWith(b.realBody().extractContactFaceInPlane(pnFace, dEps));		//pp0.vis(1);	
				
		PlaneProfile pp1(pp0.coordSys());
		for (int i=females.length()-1; i>=0 ; i--) 
		{ 
			PlaneProfile pp(pp0.coordSys());
			pp.unionWith(females[i].realBody().extractContactFaceInPlane(pnFace, dEps)); 
			
		// test if it intersects, else remove
			PlaneProfile ppTest = pp;
			if (!ppTest.intersectWith(pp0))
			{ 
				females.removeAt(i);
				continue;
			}
		
		// enlarge slightly and append to merged overall
			pp.shrink(-dEps);
			pp1.unionWith(pp);
		}//next i			
		pp1.shrink(dEps);	//pp1.vis(3);	
		
	// purge panels if not intersecting
		int numF = females.length();
		if (numF==0)
		{ 
			eraseInstance();
			return;
		}
		else if (numF!=_Sip.length())
			_Sip = females;
		
		
		ppRange = pp1;
		ppRange.intersectWith(pp0);

		LineSeg seg(pp0.ptMid() - vecX * U(10e4), pp0.ptMid() + vecX * U(10e4));			
		plines.append(getSplitPLines(ppRange, seg));
//	//endregion 






	}//endregion 

//region Draw Range
	CoordSys cs = ppRange.coordSys();
	if (ppRange.area()>pow(dEps,2))
	{ 
		Display dpx(nColor);
		dpx.addHideDirection(cs.vecX());
		dpx.addHideDirection(-cs.vecX());
		dpx.addHideDirection(cs.vecY());
		dpx.addHideDirection(-cs.vecY());
		
		dpx.draw(ppRange, _kDrawFilled, 80);
		
		
		//Debug
		if (bDebug)
		{ 
			dpx.textHeight(U(100));
			dpx.draw(scriptName() + " mode " + nMode, _Pt0, _XW, _YW, 0, 0, _kDevice);					
		}		
	}
	else if (plines.length()<1 && _Sip.length()>1)
	{ 
		reportMessage(TN("|Could not find any contact between panels|"));
		eraseInstance();
		return;
		
	}
	
//endregion 


//region Range / PLine Grip Management
	PLine plGrips[0];
	plGrips = plines;
	
	if (ppRange.area()>pow(dEps,2))
	{ 
		int nPLineIndices[0];
		for (int i=0;i<plGrips.length();i++) 
		{ 
			PLine pl = plGrips[i];
			
		// find indexed grips
			Point3d pts[] = pl.vertexPoints(true);
			if (pts.length()!=2){ continue;}
			
			int n1=-1, n2=-1;
			Vector3d vecXP= pts[1] - pts[0]; vecXP.normalize();
			for (int j=0;j<_Grip.length();j++) 
			{ 
				Grip grip = _Grip[j]; 
				String name = grip.name().makeLower();
				
				if (name == "pl"+"_"+i+"_0")
					n1 = j;
				else if (name == "pl"+"_"+i+"_1")
					n2 = j;

				if (n1>-1 && n2>-1)
				{
					nPLineIndices.append(i);
					break;
				}
			}//next j			

			
		// grips found
			if (n1>-1 && n2>-1)
			{ 
				int inds[] ={ n1, n2};
				Line lnX(pts[0], vecXP);
				pl = PLine(pl.coordSys().vecZ());
				
				for (int j=0;j<inds.length();j++) 
				{ 
					Grip& grip = _Grip[inds[j]];
					Point3d pt = lnX.closestPointTo(grip.ptLoc());
					
				// make sure grip is within range
					if (ppRange.pointInProfile(pt)==_kPointOutsideProfile)
						pt = pts[j]; // fall back to default location
			
					grip.setPtLoc(pt);			
					pl.addVertex(pt); 
				}//next j
	
				if (pl.length()>0)
					plGrips[i] = pl;
	
			}
		// create grips
			else if (!vecXP.bIsZeroLength())
			{ 
				Vector3d vecYP = vecXP.crossProduct(-cs.vecZ());
				for (int j=0;j<pts.length();j++) 
				{ 
					Grip grip;
					grip.setPtLoc(pts[j]);
					grip.setColor(4);
			 		grip.setShapeType(_kGSTArrow);
				    grip.setName("pl"+"_"+i+"_"+j);				
					grip.setVecX(vecXP*(j==0?-1:1));
					grip.setVecY(vecYP*(j==0?-1:1));
	
				    grip.addHideDirection(cs.vecX());
					grip.addHideDirection(-cs.vecX());
				    grip.addHideDirection(cs.vecY());
					grip.addHideDirection(-cs.vecY());		
	
					_Grip.append(grip); 
				}//next j
				nPLineIndices.append(i);
			}	 
		}//next i
		
	//region Purge redundnat pline based grips, i.e. if the contour has changed
		int bGripPurged;
		for (int i=_Grip.length()-1; i>=0 ; i--) 
		{ 
			Grip grip=_Grip[i]; 
			String name = grip.name().makeLower();
			if (name.left(3)=="pl_")
			{ 
				String tokens[] = name.tokenize("_");
				int n = tokens[1].atoi();
				if (nPLineIndices.find(n)<0)
				{ 
					_Grip.removeAt(i);
					bGripPurged = true;
				}
			}			
		}//next i
		if (bGripPurged)
			for (int i=0;i<_Grip.length();i++) 
			{ 
				if (_Grip[i].name() == "tag")
				{
					nIndexTagGrip = i;
					break;
				}	 
			}//next i			
	//endregion 

		
		
		
	}



//endregion 

//region Fastener Distribution
	Map mapDetail;
	for (int i=0;i<mapDetails.length();i++) 
	{ 
		Map m= mapDetails.getMap(i);
		String name = m.getMapName();
		if (name.length()>0 && sDetail.find(name,0,false)==0 && name.length()==sDetail.length())
		{ 
			mapDetail = m;
			break;
		}				 
	}//next i
	HardWrComp hwcs[0];

	Map mapRules = mapDetail.getMap("Rule[]");
	String sRuleNames[0];
	for (int i=0;i<mapRules.length();i++) 
	{ 
		Map m= mapRules.getMap(i);
		sRuleNames.append(m.getMapName());
		double offset = m.getDouble("StartEndOffset");
		double interdistance = m.getDouble("Interdistance");
		double size = m.getDouble("size");
		int nc = m.getInt("color");
		int nt = m.getInt("transparency");
		int distributionType = m.getInt("DistributionType");//{ tFixed, tEven, tFixedOdd};		
		
	// append / add interdistance as format variable
		if (mapAdd.setDouble("Interdistance" + (i>0?(i + 1):""), interdistance, _kLength));

		Map mapFasteners = m.getMap("Fastener[]");
		
		int bHasFastenerData, bHasHardwareData;
		for (int i=0;i<mapFasteners.length();i++)
		{ 
			Map m= mapFasteners.getMap(i); 
			if (m.hasString("articleNumber"))
				bHasHardwareData = true;
			else if (m.hasMap("selectedScrews"))
				bHasFastenerData = true;						
			if (bHasHardwareData || bHasFastenerData)
				break;
		}

		
		Display dp(nc);
		
		
		for (int j=0;j<plGrips.length();j++) 
		{ 
			PLine pl = plGrips[j];
			Vector3d vecN = pl.coordSys().vecZ();
			
			pl.trim(offset, false);
			pl.trim(offset, true);
			if (pl.length()<dEps){ continue;}
			if (bRevert)pl.reverse();
			
			double length = pl.length();
			double dist = interdistance>0?interdistance:length;
			int num;

		// even	
			if (distributionType==1)
			{
				num = length / dist+.9999;
				dist = length / num;
			}
		// fixed
			else
			{
				num = length / dist;
			}
			num++;
		// fixed, last odd
			if (distributionType==2)
				num++;

			double loc;
			for (int p=0;p<num;p++) 
			{ 
				Point3d pt;
			// fixed, last odd
				if (distributionType==2 && loc>pl.length())
					pt = pl.ptEnd();
				else				
					pt = pl.getPointAtDist(loc);
				PLine c;
				c.createCircle(pt, vecN, size * .5);
				dp.draw(c);
				if (nt>0 && nt<100)
				{ 
					c.convertToLineApprox(dEps);
					dp.draw(PlaneProfile(c), _kDrawFilled, nt);
				}
				loc += dist;				 
			}//next p
		
//		// special: interdistance = 0 -> increase amount
//			if (abs(dist - length) < dEps)num++;

			
		// Add fasteners to hardware
		// Fastener Database #FD
			if (bEnableFastenerManager && bHasFastenerData)
			{
				Map map = mapFasteners.getMap("selectedScrews");
				
				for (int i = 0; i < map.length(); i++)
				{
					Map m= map.getMap(i);
					String articleNumber = m.getString("Model");
					if (articleNumber.length()>0)
					{
						HardWrComp hwc = setHardwareFromFastener(m, num);
						GetHardwareFormat(mapAdd, hwc);
						hwcs.append(hwc);
					}						
					
				}
			}
		// Hardware Approach	
			else
			{
				for (int i = 0; i < mapFasteners.length(); i++)
				{
					Map mi= mapFasteners.getMap(i); 
					
					String articleNumber = mi.getString("articleNumber");
					int quantity= mi.getInt("quantity");
					
					if (articleNumber.length()>0 && quantity>0)
					{ 
						HardWrComp hwc = SetHardwareFromHwcMap(mi, num*quantity);//HSB-22178
						hwc.setNotes("Interdistance;" + dist); //HSB-22179 resolve interdistance
						GetHardwareFormat(mapAdd, hwc);
						hwcs.append(hwc);	
						
						if (bDebug)reportNotice("\nHWc " + hwc.articleNumber() + " " + hwc.quantity());
						
						
					}						
					
				}	
			}			
		}//next j
	}//next i

	_ThisInst.setHardWrComps(hwcs);
	sFormat.setDefinesFormatting(_ThisInst, mapAdd);
	
	String text;
	if (sFormat.length()>0 && hwcs.length()>0)
	{ 
		for (int i=0;i<hwcs.length();i++) 
		{ 
			HardWrComp hwc = hwcs[i]; 
			Map m = HardWrCompToMap(hwc);			
			if (text.length() > 0)text += "\\P";
			text += _ThisInst.formatObject(sFormat, m);
		}//next i	
	}
	else if (sFormat.length() > 0)
	{
		text= _ThisInst.formatObject(sFormat, mapAdd);
	}
	if (text.length()<1)
		text = sDetail;	
	
//region Text
	Vector3d vecXT = vecX;
	Vector3d vecYT = vecY;
	Vector3d vecZT = vecZ;
	if (plines.length()>0)
	{ 
		CoordSys csp = plines[0].coordSys();	csp.vis(3);
		vecXT = csp.vecX();
		vecYT = csp.vecY();
		vecZT = csp.vecZ();
		
	// floor aligned	
		if (csp.vecZ().isParallelTo(_ZW) &&  (vecXT.dotProduct(_XW)<0 || vecXT.isCodirectionalTo(-_YW)))
		{ 
			vecXT *= -1;
		}
	// wall aligned
		else if (csp.vecZ().isPerpendicularTo(_ZW) &&  (vecYT.dotProduct(_ZW)<0 || vecYT.isCodirectionalTo(-_XW)))
		{ 
			vecXT *= -1;
		}		
		vecYT = vecXT.crossProduct(-vecZT);	
	}
	
// Add tag location grip	
	if (nIndexTagGrip<0 && ppRange.area()>pow(dEps,2))
	{ 
		Point3d pt = ppRange.ptMid();
		pt.vis(6);
		Grip grip(ppRange.ptMid()+vecYT * textHeight);
	    grip.setShapeType(_kGSTCircle);
	    grip.setName("tag");
	    grip.setColor(40);
	    grip.addHideDirection(vecXT);
		grip.addHideDirection(-vecXT);
	    grip.addHideDirection(vecYT);
		grip.addHideDirection(-vecYT);		
		grip.setVecX(vecXT);
		grip.setVecY(vecYT);
		grip.setToolTip(T("|Move to adjust tag location|"));
		 _Grip.append(grip);
		_ThisInst.recalc();
	}
	else if (nIndexTagGrip>-1)
	{ 
		Grip& grip = _Grip[nIndexTagGrip];
		grip.ptLoc().vis(2);
	    grip.addHideDirection(vecXT);
		grip.addHideDirection(-vecXT);
	    grip.addHideDirection(vecYT);
		grip.addHideDirection(-vecYT);
		grip.setVecX(vecXT);
		grip.setVecY(vecYT);
	}

	
	Point3d ptTxt = nIndexTagGrip>-1?_Grip[nIndexTagGrip].ptLoc():_Pt0;

	
//region Display Draw
	Display dpView(-1), dpModel(-1);
	dpView.dimStyle(dimStyle);
	dpView.textHeight(textHeight);
	dpView.addViewDirection(vecZT);
	dpView.addViewDirection(-vecZT);

	dpModel.dimStyle(dimStyle);
	dpModel.textHeight(textHeight);
	dpModel.addHideDirection(vecXT);
	dpModel.addHideDirection(-vecXT);	
	dpModel.addHideDirection(vecYT);
	dpModel.addHideDirection(-vecYT);
	dpModel.addHideDirection(vecZT);
	dpModel.addHideDirection(-vecZT);
	
	dpView.draw(text,ptTxt, vecXT, vecYT, 0, 0,_kDevice);
	dpModel.draw(text,ptTxt, vecXT, vecYT, 0, 0);	
	
	{ 
		Vector3d vec = .5*(vecXT * dp.textLengthForStyle(text, dimStyle, textHeight)+vecYT*dp.textHeightForStyle(text, dimStyle, textHeight));
		
		PLine pl;
		pl.createRectangle(LineSeg(ptTxt - vec, ptTxt + vec), vecXT, vecYT);
		pl.offset(-.4 * textHeight, true);
		if (sStyle==tSFilled)
			dpWhite.draw(PlaneProfile(pl), _kDrawFilled);
		if (sStyle!=tSText)	
			dpView.draw(pl);
			
	// Leader		
		Point3d pt2 = ptTxt;
		double dDist = U(10e10);
		for (int i=0;i<plines.length();i++) 
		{ 
			Point3d pt = plines[i].closestPointTo(ptTxt);
			double d = (pt - ptTxt).length();
			if (d<dDist)
			{ 
				dDist = d;
				pt2 = pt;
			}
		}//next i
		
		vec = ptTxt - pt2; vec.normalize();
		Vector3d vecN = vec.crossProduct(-vecZT);
		Point3d pts[] = Line(ptTxt, vec).orderPoints(pl.intersectPoints(Plane(ptTxt, vecN)));
		
		Point3d pt1 = pl.closestPointTo(pt2);		
		if (pts.length()>0)
			pt1 = pts.first();
		
		//pt1.vis(6);pt2.vis(6);pl.vis(6);
		PLine plLeader(pt1, pt2);
		plLeader.vis(2);
		if (plLeader.length()>3*textHeight && PlaneProfile(pl).pointInProfile(pt2)==_kPointOutsideProfile)
		{ 
			dpView.draw(plLeader);
		}
			
	}		
//endregion 	
	

	
//endregion 	


	
	
//endregion 






//End Part #2 //endregion 


//region Type dependent triggers

	//region Trigger Add Floor Panels
		String sTriggerAddFloor= T("|Add Floor Panels|");
		if (nMode==4 ||nMode == 8)
			addRecalcTrigger(_kContextRoot, sTriggerAddFloor);
		if (_bOnRecalc && _kExecuteKey==sTriggerAddFloor)
		{
		// prompt for entities
			Entity ents[0];
			PrEntity ssE(T("|Select floor panels|"), Sip());
			if (ssE.go())
				ents.append(ssE.set());
			
			Sip females[] = filterEntityPanelsByType(ents, 2);
			for (int i=0;i<females.length();i++) 
			{ 
				int n = _Sip.find(females[i]);
				if (n<0)
					_Sip.append(females[i]);
				 
			}//next i
			setExecutionLoops(2);
			return;
		}//endregion	
	
	//region Trigger Remove Floor Panels
		String sTriggerRemoveFloor= T("|Remove Floor Panels|");
		if (_Sip.length()>2 && (nMode==4 ||nMode == 8))
			addRecalcTrigger(_kContextRoot, sTriggerRemoveFloor);
		if (_bOnRecalc && _kExecuteKey==sTriggerRemoveFloor)
		{
		// prompt for entities
			Entity ents[0];
			PrEntity ssE(T("|Select floor panels|"), Sip());
			if (ssE.go())
				ents.append(ssE.set());
			
			Sip females[] = filterEntityPanelsByType(ents, 2);
			for (int i=0;i<females.length();i++) 
			{ 
				int n = _Sip.find(females[i]);
				if (n>-1)
					_Sip.removeAt(n);
				if (_Sip.length()<3)
				{ 
					break;
				}
				 
			}//next i
			setExecutionLoops(2);
			return;
		}//endregion	
		
//endregion 

//region Dialog Trigger
{ 
	// create TSL
	TslInst tslDialog;			Map mapTsl;						
	GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };
	
//region Trigger AddDetail
	// add a parent node to the list of details, if new call add rule also
	String sTriggerAddDetail = T("|Add Detail|");
	addRecalcTrigger(_kContext, sTriggerAddDetail );
	int bAddRule;
	if (_bOnRecalc && _kExecuteKey==sTriggerAddDetail)	
	{ 
		int bAdd = true;						
		String detail = sDetail;
		if (findFile(stDialogLibrary)!="")
		{ 
			Map mapIn;
			mapIn.setString("Title", T("|New Detail|"));
			mapIn.setString("Text", T("|Enter a new detail name|"));
			Map mapOut = callDotNetFunction2(stDialogLibrary, stDialogClass, "GetText", mapIn);

			detail = mapOut.getString("Text");
			bAdd = detail.length() > 0;
		}
	
	// Check existing details		
		Map mapDetails = mapSetting.getMap("Detail[]");
		if (bAdd)
		{ 
			String name;
			for (int i=0;i<mapDetails.length();i++) 
			{ 
				Map m= mapDetails.getMap(i);
				name = m.getMapName();
				if (name.length()>0 && detail.find(name,0,false)==0 && name.length()==detail.length())
				{ 
					bAdd = false;
					break;
				}				 
			}//next i
			if (!bAdd)
				reportNotice("\n" + T("|NOTE: Detail| ") + "'"+name+"'" + T(" |already exists|"));
			
		// Purge invalid details
			for (int i=mapDetails.length()-1; i>=0 ; i--) 
			{ 
				Map m= mapDetails.getMap(i);
				String name = m.getMapName();
				if (name.length()<1)
					mapDetails.removeAt(i, true);
				
			}//next i	
		}
	
	// Add Detail	
		if (bAdd)
		{ 
			Map m;
			m.setMapName(detail);
			mapDetails.appendMap("Detail", m);
			sDetail.set(detail);
			bAddRule = true;
			
			mapSetting.setMap("Detail[]", mapDetails);
			if (mo.bIsValid())mo.setMap(mapSetting);
			else mo.dbCreate(mapSetting);			
			
		}
   
		
	// no new detail added	
		if (!bAddRule)
		{ 
			setExecutionLoops(2);
			return;			
		}
		
		sProps.setLength(0);	
	
		//reportNotice("\nadding detail ended " + _ThisInst.handle());//XX
	}
	//endregion	

//region Trigger RemoveDetail
	// delete a parent node of the list of details
	String sTriggeRemoveDetail = T("|Delete Detail|");
	if (sDetails.length()>0)addRecalcTrigger(_kContext, sTriggeRemoveDetail );
	if (_bOnRecalc && _kExecuteKey==sTriggeRemoveDetail)
	{ 
		Map m;
		for (int i=0;i<sDetails.length();i++)
			m.appendString("Entry",sDetails[i]); 
		mapTsl.setMap("Entry[]", m);

		mapTsl.setInt("DialogMode",4);
		String detail = sDetail;
		sProps.append(detail);
			
		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{ 
				detail = tslDialog.propString(0);
				for (int i=0;i<mapDetails.length();i++) 
				{ 
					Map m= mapDetails.getMap(i);
					String name = m.getMapName();
					if (name.length()>0 && detail.find(name,0,false)==0 && name.length()==detail.length())
					{ 
						mapDetails.removeAt(i, true);
						break;
					}				 
				}//next i
				mapSetting.setMap("Detail[]", mapDetails);
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);				
			}
			tslDialog.dbErase();
		}
		return;			
	}
	//endregion	

//region Trigger EditRule
	String sTriggerEditRule = T("|Edit Rule|");
	Map mapRule;
	if (sRuleNames.length()>0)
	{
		addRecalcTrigger(_kContext, sTriggerEditRule );	
		if (_bOnRecalc && _kExecuteKey==sTriggerEditRule)	
		{ 
			mapTsl.setInt("DialogMode",3);
			Map m;
			for (int i=0;i<sRuleNames.length();i++)
				m.appendString("Rule",sRuleNames[i]); 
			mapTsl.setMap("Rule[]", m);
			
			String detail = sDetail;
			sProps.append(detail);		
			
			String rule = sRuleNames.first();
			sProps.append(rule);

			tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
			if (tslDialog.bIsValid())
			{
				int bOk = tslDialog.showDialog();
				if (bOk)
				{ 
					detail = tslDialog.propString(0);
					rule = tslDialog.propString(1);			

					Map mapDetail;
					for (int i=0;i<mapDetails.length();i++) 
					{ 
						Map m= mapDetails.getMap(i);
						String name = m.getMapName();
						if (name.length()>0 && detail.find(name,0,false)==0 && name.length()==detail.length())
						{ 
							mapDetails.removeAt(i, true);
							mapDetail = m;
							break;
						}				 
					}//next i
	
					for (int i=0;i<mapRules.length();i++) 
					{ 
						Map m= mapRules.getMap(i);
						String name = m.getMapName();
						if (name.length()>0 && rule.find(name,0,false)==0 && name.length()==rule.length())
						{ 
							mapRule = m;
							break;
						}				 
					}//next i				
				}
				tslDialog.dbErase();
			}	
			
			
		}	
		sProps.setLength(0);
		
	}//endregion	

//region Trigger AddRule
	String sTriggerAddRule = T("|Add Rule|");
	addRecalcTrigger(_kContext, sTriggerAddRule );
	if ((_bOnRecalc && _kExecuteKey==sTriggerAddRule) || mapRule.length()>0 || bAddRule)	
	{ 
		mapTsl.setInt("DialogMode",2);

		String detail = sDetail;
		String rule = T("|New Rule|");
		String distribution = tEven;
		double offset, spacing, size = U(10);
		int nDistributionType, nc, nt=60;
		
		if (mapRule.length()>0)
		{ 
			rule = mapRule.getMapName();
			int nDistributionType = mapRule.getInt("DistributionType");
			if (nDistributionType == 1)distribution = tEven;
			else if (nDistributionType == 2)distribution = tFixedOdd;
			
			offset = mapRule.getDouble("StartEndOffset");
			spacing = mapRule.getDouble("Interdistance");
			size = mapRule.getDouble("size");
			
			nc = mapRule.getInt("Color");
			nt = mapRule.getInt("Transparency");
			
		}

		sProps.append(detail);		
		sProps.append(rule);		
		sProps.append(distribution);

		dProps.append(offset);
		dProps.append(spacing);
		dProps.append(size);
			
		nProps.append(nc);
		nProps.append(nt);
		
		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{ 
				detail = tslDialog.propString(0);
				rule = tslDialog.propString(1);			
				distribution = tslDialog.propString(2);
				
				nDistributionType = sDistributionModes.find(distribution, 0);
				
				
				offset = tslDialog.propDouble(0);
				spacing = tslDialog.propDouble(1);
				size = tslDialog.propDouble(2);
				
				nc =  tslDialog.propInt(0);
				nt =  tslDialog.propInt(1);
	
				Map mapDetail, mapDetails = mapSetting.getMap("Detail[]");
				for (int i=0;i<mapDetails.length();i++) 
				{ 
					Map m= mapDetails.getMap(i);
					String name = m.getMapName();
					if (name.length()>0 && detail.find(name,0,false)==0 && name.length()==detail.length())
					{ 
						mapDetail = m;
						mapDetails.removeAt(i, true);
						break;
					}				 
				}//next i

				Map mapRule, mapRules = mapDetail.getMap("Rule[]");
				for (int i=0;i<mapRules.length();i++) 
				{ 
					Map m= mapRules.getMap(i);
					String name = m.getMapName();
					if (name.length()>0 && rule.find(name,0,false)==0 && name.length()==rule.length())
					{ 
						mapRule = m;
						mapRules.removeAt(i, true);
						break;
					}				 
				}//next i
				
			//region Set rule parameters
				mapRule.setMapName(rule);

				mapRule.setDouble("StartEndOffset", offset);
				mapRule.setDouble("Interdistance", spacing);
				mapRule.setDouble("Size", size);
				
				mapRule.setInt("Color", nc);
				mapRule.setInt("Transparency", nt);
					
				mapRule.setInt("DistributionType", nDistributionType);
			
			//region Get and show hardware/fastener dialog
				HardWrComp hwcs[0];
				Map mapFasteners = mapRule.getMap("Fastener[]");
				int bHasFastenerData, bHasHardwareData;
				for (int i=0;i<mapFasteners.length();i++)
				{ 
					Map m= mapFasteners.getMap(i); 
					if (m.hasString("articleNumber"))
						bHasHardwareData = true;
					else if (m.hasMap("selectedScrews"))
						bHasFastenerData = true;						
					if (bHasHardwareData || bHasFastenerData)
						break;
				}
				
			//region Fastener Database #FD
				if (bEnableFastenerManager && bHasFastenerData)
				{ 
				// remove any tsl driven entry	
					hwcs = _ThisInst.hardWrComps();				
					for (int i=hwcs.length()-1; i>=0 ; i--) 
						if (hwcs[i].repType()==_kRTTsl)
							hwcs.removeAt(i); 

				// Show Selection Dialog
					mapFasteners = callDotNetFunction2(sDllPath, sClass, "ShowFastenerSelectorDialog",mapFasteners);
					
				// append to hardware
					Map map = mapFasteners.getMap("selectedScrews");
					for (int i=0;i<map.length();i++) 
					{ 
						Map m= map.getMap(i); 
						String articleNumber = m.getString("Model");
						
						if (articleNumber.length()>0)
						{ 
							HardWrComp hwc = setHardwareFromFastener(m, 1);
							hwcs.append(hwc);
						}						
					}
				}//endregion 

			//region Hardware Approach
				else
				{ 
					//reportNotice("\nHardware approach:");
					for (int i=0;i<mapFasteners.length();i++) 
					{ 
						Map m= mapFasteners.getMap(i); 					
						String articleNumber = m.getString("articleNumber");
						int quantity= m.getInt("quantity");
						
						if (articleNumber.length()>0 && quantity>0)
						{ 
							HardWrComp hwc = SetHardwareFromHwcMap(m, quantity);
							hwcs.append(hwc);
							
							//if (bDebug)reportNotice("\ninit hwc with " + hwc.articleNumber() + " " + hwc.quantity());
						}
					}//next i
	
					
				// Show Hardware Dialog and write to map	
					hwcs=HardWrComp().showDialog(hwcs);								
					mapFasteners = Map();
					for (int i=0;i<hwcs.length();i++) 
					{ 
						HardWrComp hwc = hwcs[i];	
						if (hwc.articleNumber().length()>0 && hwc.quantity()>0)
						{ 
							if (bDebug)reportNotice("\nstoring hwc with " + hwc.articleNumber() + " " + hwc.quantity());
							Map m = HardWrCompToMap(hwc);
							mapFasteners.appendMap("Fastener", m);
						}
					}//next i					
				}//endregion 

				mapRule.setMap("Fastener[]", mapFasteners);//endregion
				
			//endregion 	
		
			// append rule to detail and detail to list of details
				mapRules.appendMap("Rule", mapRule);
				mapDetail.setMap("Rule[]", mapRules);
				mapDetails.appendMap("Detail", mapDetail);
				sDetail.set(detail);

				mapSetting.setMap("Detail[]", mapDetails);
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);				
			}
			tslDialog.dbErase();
		}
		
		//reportNotice("\nadding rule ended " + _ThisInst.handle());//XX
		setExecutionLoops(2);
		return;	
	}
	//endregion	

//region Trigger RemoveRule
	String sTriggerRemoveRule = T("|Remove Rule|");
	if (sRuleNames.length()>1)
	{
		addRecalcTrigger(_kContext, sTriggerRemoveRule );
		
		if (_bOnRecalc && _kExecuteKey==sTriggerRemoveRule)	
		{ 
			mapTsl.setInt("DialogMode",3);
			Map m;
			for (int i=0;i<sRuleNames.length();i++)
				m.appendString("Rule",sRuleNames[i]); 
			mapTsl.setMap("Rule[]", m);
			
			String detail = sDetail;
			sProps.append(detail);		
			
			String rule = sRuleNames.first();
			sProps.append(rule);

			tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						
			if (tslDialog.bIsValid())
			{
				int bOk = tslDialog.showDialog();
				if (bOk)
				{ 
					detail = tslDialog.propString(0);
					rule = tslDialog.propString(1);			

					Map mapDetail;
					for (int i=0;i<mapDetails.length();i++) 
					{ 
						Map m= mapDetails.getMap(i);
						String name = m.getMapName();
						if (name.length()>0 && detail.find(name,0,false)==0 && name.length()==detail.length())
						{ 
							mapDetails.removeAt(i, true);
							mapDetail = m;
							reportNotice("\ndetail " + name);
							break;
						}				 
					}//next i
	
					Map mapRules = mapDetail.getMap("Rule[]");
					for (int i=0;i<mapRules.length();i++) 
					{ 
						Map m= mapRules.getMap(i);
						String name = m.getMapName();
						if (name.length()>0 && rule.find(name,0,false)==0 && name.length()==rule.length())
						{ 
							mapRules.removeAt(i, true);
							reportNotice("\ndetail " + name);
							break;
						}				 
					}//next i
	
					mapDetail.setMap("Rule[]", mapRules);
					mapDetails.appendMap("Detail", mapDetail);
					sDetail.set(detail);
					mapSetting.setMap("Detail[]", mapDetails);					
					if (mo.bIsValid())mo.setMap(mapSetting);
					else mo.dbCreate(mapSetting);				
				}
				tslDialog.dbErase();
			}
			setExecutionLoops(2);
			return;	
		}		
		
	}
	//endregion	

//region Trigger ShowFastenerManager
	String sTriggerShowFastenerManager = T("|Show Fastener Manager|");
	if (bEnableFastenerManager)
		addRecalcTrigger(_kContext, sTriggerShowFastenerManager );
	if (_bOnRecalc && _kExecuteKey==sTriggerShowFastenerManager)
	{

//		Map mapCheck = callDotNetFunction2(sDllPath, sClass, "VerifyDatabase");
//		int bConnectedToDatabase = mapCheck.getInt("DatabaseExists");
//		if (bConnectedToDatabase == false) 
//		{
		Map mapCheck=	callDotNetFunction2(sDllPath, sClass, "ShowFastenerManager");
			
//			
//			//bShowFastenerManager = true;
//			String stDialogLibrary = _kPathHsbInstall + "\\Utilities\\DialogService\\TslUtilities.dll";
//			String stDialogClass = "TslUtilities.TslDialogService";
//			Map m;
//			m.setString(T("|Notice|"), "No Fastener Database Found, please connect one");
//			callDotNetFunction2(stDialogLibrary, stDialogClass, "ShowNotice", mpDialog);
//		}


		setExecutionLoops(2);
		return;
	}//endregion




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
        <int nm="BreakPoint" vl="1446" />
        <int nm="BreakPoint" vl="330" />
        <int nm="BreakPoint" vl="1790" />
        <int nm="BreakPoint" vl="1496" />
        <int nm="BreakPoint" vl="1519" />
        <int nm="BreakPoint" vl="3300" />
        <int nm="BreakPoint" vl="1446" />
        <int nm="BreakPoint" vl="330" />
        <int nm="BreakPoint" vl="1790" />
        <int nm="BreakPoint" vl="1496" />
        <int nm="BreakPoint" vl="1519" />
        <int nm="BreakPoint" vl="3295" />
        <int nm="BreakPoint" vl="3157" />
        <int nm="BreakPoint" vl="2703" />
        <int nm="BreakPoint" vl="2001" />
        <int nm="BreakPoint" vl="2118" />
        <int nm="BreakPoint" vl="2393" />
        <int nm="BreakPoint" vl="2524" />
        <int nm="BreakPoint" vl="604" />
        <int nm="BreakPoint" vl="572" />
        <int nm="BreakPoint" vl="2615" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22178 bugfix quantity rule edit, take II" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="9/12/2024 9:26:01 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22178 bugfix quantity rule edit" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="7/22/2024 9:09:16 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22179 resolves nterdistance by hardware" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="6/3/2024 10:09:18 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18845 duplicate creation fixed, detecting longest edge fixed, supports 'Interdistance' as format variable" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="8/8/2023 12:29:17 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18845 supports grips in wall and floor modes, accepts wall/floor connections if edge of wall panel has beamcut" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="7/17/2023 12:26:23 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18845 FastenerDatabase supported, new connection modes" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="7/11/2023 4:56:30 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18845 FastenerDatabase prepared" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="7/7/2023 3:56:56 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-188845 new insertion methods, wall/wall mode added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="7/7/2023 3:05:28 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18845 supporting polylines, display options extended" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="6/30/2023 2:54:51 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18845 first version of fastener line definition" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="6/29/2023 4:47:14 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End