#Version 8
#BeginDescription
#Versions
Version 1.4 11.11.2025 HSB-24891: Fix when running hsbExcelToMap , Author: Marsel Nakuci
Version 1.3 02.07.2024 HSB-22356 stock panels will be created on lower left, transparency increased
Version 1.2 10.04.2024 HSB-21861 display less opaque, new commmands to alter stock panel label
Version 1.1 14.03.2024 HSB-21640 Masterpanel openings improved, minor graphical fix
Version 1.0 13.03.2024 HSB-21640 intial version of hsbCLT-CreateStockPanels

This tsl creates stock panels, it requires settings or the import of stock definition table




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
// 1.4 11.11.2025 HSB-24891: Fix when running hsbExcelToMap , Author: Marsel Nakuci
// 1.3 02.07.2024 HSB-22356 stock panels will be created on lower left, transparency increased , Author Thorsten Huck
// 1.2 10.04.2024 HSB-21861 display less opaque, new commmands to alter stock panel label , Author Thorsten Huck
// 1.1 14.03.2024 HSB-21640 Masterpanel openings improved, minor graphical fix , Author Thorsten Huck
// 1.0 13.03.2024 HSB-21640 intial version of hsbCLT-CreateStockPanels , Author Thorsten Huck

/// <insert Lang=en>
/// Select masterpanels
/// </insert>

// <summary Lang=en>
// This tsl creates stock panels, it requires settings or the import of stock definition table
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert hsbCLT-CreateStockPanels")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Import Stock Sizes|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Import Settings|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Export Settings|") (_TM "|Select Tool|"))) TSLCONTENT

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

	String sDialogLibrary = _kPathHsbInstall + "\\Utilities\\DialogService\\TslUtilities.dll";
	String sClass = "TslUtilities.TslDialogService";	
	String listSelectorMethod = "SelectFromList";
	String optionsMethod = "SelectOption";
	String simpleTextMethod = "GetText";
	String askYesNoMethod = "AskYesNo";
	String showNoticeMethod = "ShowNotice";
	String showMultilineNotice = "ShowMultilineNotice";


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
	
	
	double dXOffsetLocation = U(20000); // the offset measured from the left 
	String tSubLabel2 = T("|Stock Panel|");
//end Constants//endregion

//region Functions #FU
	//region Function GetHsbVersionNumber
	// returns the main version number 27,28, 29..., 0 if it fails
	int GetHsbVersionNumber()
	{ 		
		String oeVersion = hsbOEVersion().makeUpper();
		int hsbVersion;
		int n1 = oeVersion.find("(",0, false)+1;
		int n2 = oeVersion.find(")", n1+1, false)-1;
		String mid = oeVersion.mid(n1, n2 - n1+1);
		mid.replace("BUILD ", "");
		String tokens[] = mid.tokenize(",");
		if (tokens.length()>0)
			hsbVersion = tokens.first().atoi();
	
		return hsbVersion;
	}//endregion	
//endregion Functions #FU

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="hsbCLT-CreateStockPanels";
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
	
	
//End Settings//endregion	

//region Functions

	//region Function DrawPlaneProfile
	// draws a planeprofile
	// pp: the profile to be drawn
	// color: 0-255 index color, > 255 RGB
	// transparency: 0<value<100 transparency value, else curve style
	void DrawPlaneProfile(PlaneProfile pp, Display dp, int color, int transparency, Vector3d vecTrans)
	{ 
		pp.transformBy(vecTrans);
		if (color<256)
			dp.color(color);
		else	
			dp.trueColor(color);
		
		if (transparency>0 && transparency<100)
			dp.draw(pp, _kDrawFilled, transparency);
		dp.draw(pp);
		return;
	}//End drawShape //endregion

	//region Function filterTslsByName
	// returns all tsl instances with a certain scriptname
	// ents: the array to search, if empty all tsls in modelspace are taken
	// names: the names of the tsls to be returned, all if empty
	TslInst[] filterTslsByName(Entity ents[], String names[])
	{ 
		TslInst out[0];
		int bAll = names.length() < 1;

		if (ents.length()<1)
			ents = Group().collectEntities(true, TslInst(),  _kModelSpace);
		
		for (int i=0;i<ents.length();i++) 
		{ 
			TslInst t= (TslInst)ents[i]; 
			//reportNotice("\ngetTslsByName: " + t.scriptName() +" "+names);
			if (t.bIsValid())
			{
				if (!bAll && names.findNoCase(t.scriptName(),-1)>-1)
					out.append(t);	
				else if (bAll)
					out.append(t);									
			}
				
		}//next i

		return out;
	
	}//End filterTslsByName //endregion
	
	//region Function getToolData
	// returns
	// t: the tslInstance to 
	void getToolData(Map mapIn, double& dThicknesses[], double& dToolDiams[], double& dGaps[])
	{ 
		for (int i=0;i<mapIn.length();i++) 
		{ 
			Map m= mapIn.getMap(i);
			double thickness = m.getDouble("Thickness");
			double diameter = m.getDouble("Diameter");
			double gap = m.getDouble("Gap");
			
			if (thickness>0)
			{ 
				dThicknesses.append(thickness);
				dToolDiams.append(diameter);
				dGaps.append(gap);			
			}

		}//next i
		
	// order ascending
		for (int i=0;i<dThicknesses.length();i++) 
			for (int j=0;j<dThicknesses.length()-1;j++) 
				if (dThicknesses[j]>dThicknesses[j+1])
				{ 
					dThicknesses.swap(j, j + 1);
					dToolDiams.swap(j, j + 1);
					dGaps.swap(j, j + 1);					
				}
				
	}//End getToolData //endregion	

	//region Function getStockMap
	// returns
	// t: the tslInstance to 
	void getStockMap(Map mapIn, double& dXSizes[], double& dYSizes[], double& dValues[])
	{ 
		Map mapStock;
		Map mapSheets = mapIn.getMap("Sheets");
		for (int i=0;i<mapSheets.length();i++) 
		{ 
			Map mapSheet= mapSheets.getMap(i);
			if (mapSheet.length()>1 && mapSheet.getMap("1").length()>2 &&  mapSheet.hasMap("2"))
			{ 
				mapStock = mapSheet;
				Map mapX = mapStock.getMap(0);
				for (int i=1;i<mapX.length();i++) 
					dXSizes.append(mapX.keyAt(i).atof()); 
				int numCol = dXSizes.length();
				
				
				for (int i=1;i<mapStock.length();i++) 
				{
					Map m = mapStock.getMap(i);
					
					for (int j=0;j<m.length();j++) 
					{ 
						if (j==0)dYSizes.append(m.getDouble(j)); 
						else dValues.append(m.getDouble(j)); 
						 
					}//next j
					
				}
			}
			 
		}//next i
		return;
	}//End getStockMap //endregion	
	
	//region Function importSizeGrid
	// returns
	// t: the tslInstance to 
	void importSizeGrid(Map mapIn)
	{ 
		int nVersionNumber = GetHsbVersionNumber();
		String path = _kPathHsbInstall + "\\Utilities\\hsbExcelToMap\\hsbExcelToMap"+ (nVersionNumber>=28?".dll":".exe");
		if (findFile(path).length()<1)
		{ 
			reportNotice("\n" + T("|Unexpected error, could not find import method.|"));
			//return;
		}

		Map mapOut = callDotNetFunction2( path, "hsbCad.hsbExcelToMap.HsbCadIO", "ExcelToMap" , mapIn);
		if (mapOut.length()>0)
		{ 
			mapSetting.setMap("Sheets", mapOut.getMap("Sheets"));
			mapSetting.setString("LastAccessedFilePath", mapOut.getString("LastAccessedFilePath"));

			if (mo.bIsValid())
				mo.setMap(mapSetting);			
			else if (!mo.bIsValid() )// create a mapObject to make the settings persistent	
				mo.dbCreate(mapSetting);			
		}
		else if (bDebug)
		{ 
			reportNotice("\n" + T("|Could not find stock panel list.|"));
		}			
		
		return;
	}//End importSizeGrid //endregion

	//region Function GetPerpCorner
	// returns true or false if has found two perpendicular segments and modifies the ref point and the segment intersection
	// t: the tslInstance to 
	int GetPerpCorner(PLine ring, Point3d& ptRef, Point3d& ptx)
	{ 
		int out;
		Point3d pts[] = ring.vertexPoints(true);
		ptx.setToAverage(pts);
		ptRef = ptx;
		
		int max = pts.length();	
		double dMax;
		for (int p=0;p<pts.length();p++) 
		{ 
			Point3d pt1 = pts[p];
			
			int a2 = p + 1;
			if (a2 > max - 1)a2 -= max;
			Point3d pt2 = pts[a2];
			
			int a3 = p + 2;
			if (a3 > max - 1)a3 -= max;	
			Point3d pt3 = pts[a3];
			
			Point3d ptm = (pt1 + pt2) * .5;
			
			
			Vector3d vec0 = pt2-pt1;			
			Vector3d vec1 = pt2-pt3;
			
			double d0 = vec0.length();
			double d1 = vec1.length();
			double d01 = d0 > d1 ? d0 : d1;
			vec0.normalize();
			vec1.normalize();

			
			if (!vec0.isParallelTo(_XW) && !vec0.isParallelTo(_YW))
				continue;	
//			
//			vec0.vis(pt1, 3);
//			vec1.vis(pt2, 3);
			if (vec0.isPerpendicularTo(vec1) && dMax<d01)
			{
				dMax = d01;
				ptx = pt2;
				out = true;
			}
			 
		}//next p
		return out;
	
	}//End GetPerpCorner //endregion

	//region Function findEntry
	// returns the index of the x and y and the matching dimensions
	// t: the tslInstance to 
	int findEntry(PlaneProfile pp, double& dx, double& dy, double dXSizes[], double dYSizes[])
	{ 
		int x, y, n;

		double dX = pp.dX();
		double dY = pp.dY();



		for (int i=0;i<dXSizes.length();i++) 
		{ 
			if (dXSizes[i] > dX)
				break;
			x++;	
			dx = dXSizes[i];
		}//next i
		if (x==0)
			return -1;// no matching x-size found


		for (int i=0;i<dYSizes.length();i++) 
		{ 	
			
			if (dYSizes[i] > dY)
			{
				break;			 
			}
			y++;
			dy = dYSizes[i];
		}//next i		
		if (y==0)			
			return -1; // no matching y-size found	

		n = x + y * dXSizes.length();

		return n;
	}//End findEntry //endregion

	//region Function GetMinMaxStockSize
	// returns the min and max sizes of the stock which have an index value between 30 and 40
	// minX, minY, maxX, maxY: the params to specify min and max dimensions
	// dXSizes, dYSies, dValues: th einput parameters
	void GetMinMaxStockSize(double& minX, double& minY, double& maxX, double& maxY, double dXSizes[], double dYSizes[], double minValue, double maxValue, double dValues[])
	{
		double dx, dy;//, minX, minY, maxX, maxY;
		int numX = dXSizes.length();
		double areaMin=pow(U(10e5),2), areaMax;
		
	// loop columns	
		for (int i=0;i<dYSizes.length();i++)
		{ 
			double dy = dYSizes[i];
			for (int j=0;j<numX;j++)
			{ 
				int entry = i * numX + j;
				double value = entry >- 1 && entry < dValues.length() ? dValues[entry] : 0;
				if (value >= minValue && value< maxValue)
				{ 
					dx = dXSizes[j];
					
					double area = dx * dy;
					if (areaMin>area)
					{ 
						areaMin = area;
						minX = dx;
						minY = dy;
					}
					if (areaMax<area)
					{ 
						areaMax = area;
						maxX = dx;
						maxY = dy;
					}
					
				}
				
			}
		}
		
		return;
	}//End GetMinMaxStockSize //endregion	
	
	//region Function SimplifyPolygons
	// if a pline contains more than 5 vertices try to simplify into multiple be shrinkBlowup
	void SimplifyPolygons(PLine& rings[], double dGap)
	{ 

		PLine simples[0];
		for (int r=rings.length()-1; r>=0 ; r--) 
		{ 
			Point3d pts[] = rings[r].vertexPoints(true);
			if (pts.length()>5)
			{ 
				PlaneProfile pp2(rings[r]);
				int cnt=1, max = 5;
				while(cnt<max)
				{ 
					pp2.shrink(cnt*dGap);
					pp2.shrink(-cnt*dGap);
					//pp2.vis(cnt);
					PLine rings2[] = pp2.allRings(true, false);
					if (rings2.length()>1)
					{ 
						simples.append(rings2);
						rings.removeAt(r);
						break;
					}
					cnt++;
				}				
			}
		}
		rings.append(simples);
		return;
	
	}//End SimplifyPolygons //endregion

	//region Function CreateClt
	// creates a panel at the specified location and the corresponding childpanel
	Sip CreateClt(PlaneProfile pp, Vector3d vecTrans, String styleDef, int bParallelX, MasterPanel master)
	{ 
		Vector3d vecXGrain = bParallelX ? _XW : _YW;
		PLine plShape,rings[]=pp.allRings(true, false);
		
		if (rings.length()>0)
			plShape = rings.first();
		else
			plShape.createRectangle(pp.extentInDir(_XW), _XW, _YW);	
		plShape.transformBy(vecTrans);
		
		Sip clt;
		clt.dbCreate(plShape, styleDef);
		clt.setXAxisDirectionInXYPlane(vecXGrain);
		clt.setWoodGrainDirection(vecXGrain);
		clt.setSurfaceQualityOverrideBottom(master.formatObject("SurfaceQualityBottom"));
		clt.setSurfaceQualityOverrideTop(master.formatObject("SurfaceQualityTop"));
		clt.setSubLabel2(tSubLabel2);

		
		ChildPanel child;
		child.dbCreate(clt, pp.ptMid(), -vecXGrain.crossProduct(_ZW)); 
	
		return clt;
	}//End CreateClt //endregion

	
	//region Function ExtentToMasterEdge
	// returns
	// pp: the profile to stretch
	// ppMasterRect: the outer rectangular bounds
	// ppAllChilds: the profile of all contained childs to ceck intersection against
	void ExtentToMasterEdge(PlaneProfile& pp, PlaneProfile ppMasterRect, PlaneProfile ppAllChilds)
	{ 
		PlaneProfile ppOut(CoordSys());
		Vector3d vecDirs[] ={ _XW, _YW ,- _XW ,- _YW};
		
		PLine rings[] = pp.allRings(true, false);
		for (int r=0;r<rings.length();r++) 
		{ 
			PlaneProfile ppr(CoordSys());
			ppr.joinRing(rings[r], _kAdd);		//ppr.vis(81);
			Point3d ptm = ppr.ptMid();
			
			PlaneProfile ppFrees[0];
			int numFree; // count free directions
			Vector3d vecMultiFree;
			Point3d ptF;
			for (int i=0;i<vecDirs.length();i++) 
			{ 
				Vector3d vecDir = vecDirs[i];
				Vector3d vecPerp = vecDir.crossProduct(-_ZW);
				double dDir= .5*(i%2==1 ? ppr.dY() : ppr.dX());
				double dPerp= .5*(i%2==0 ? ppr.dY() : ppr.dX());
				Point3d pt = ptm+ vecDir * dDir;
				
			// Get extents of profile at edge of stretching direction	
				Point3d pts[] = Line(pt, vecPerp).orderPoints(ppr.intersectPoints(Plane(pt, vecDir), true, false),dEps);
				if (pts.length()>1)
				{ 
					pt = (pts.first() + pts.last()) * .5;
					dPerp = .5*abs(vecPerp.dotProduct(pts.first() - pts.last()));
					 
				}//next p
				else // stretching at edge has failed, possibly skewed: stretch from mid
				{ 
					pt = ptm;
				}
				//pt.vis(1);
				
				
				PlaneProfile ppx; ppx.createRectangle(LineSeg(pt+vecDir * U(10e4) - vecPerp*dPerp, pt+vecPerp*dPerp), vecDir, vecPerp);
				//
				PlaneProfile ppX = ppx;
				ppX.shrink(dEps); // avoid interscetions at neighbouring edge
				if (!ppX.intersectWith(ppAllChilds))
				{
					ppFrees.append(ppx);
					numFree++;
					if (numFree==1)
						ptF = pt;
					else if (numFree==2)
						Line(ptF, vecDir).hasIntersection(Plane(pt, vecDir), ptF);
						
					vecMultiFree += vecDir;
					//ppx.vis(4); 
				}
				
			}//next i
			
		// add the box created between two free directions	
			if (numFree>1)
			{ 
				vecMultiFree.normalize();
				vecMultiFree.vis(ptF, 1);
				PlaneProfile ppX;ppX.createRectangle(LineSeg(ptF, ptF+vecMultiFree*U(10e3)), _XW, _YW);
				ppOut.unionWith(ppX);
			}	
			ppOut.shrink(-dEps);
			//ppOut.vis(40);
			
		// add boxes of free directions	
			for (int i=0;i<ppFrees.length();i++) 
			{
				ppFrees[i].shrink(-dEps);	//ppFrees[i].vis(1);
				ppOut.unionWith(ppFrees[i]);
				//ppOut.vis(3);
			}
			
		// add original shape
			ppr.shrink(-dEps);
			ppOut.unionWith(ppr);
			ppOut.shrink(dEps);
			
			ppOut.intersectWith(ppMasterRect);
			
		}//next r
		ppOut.vis(3);
		pp = ppOut;
	}//End ExtentToMasterEdge //endregion
	
	//region Function RemoveVoidsWithOpenings
	// returns
	// t: the tslInstance to 
	void RemoveVoidsWithOpenings(PlaneProfile& pp)
	{ 
		PlaneProfile ppOut(CoordSys());
		PLine rings[] = pp.allRings(true, false);
		PLine openings[] = pp.allRings(false, true);
		for (int r = 0; r < rings.length(); r++)
		{
			PlaneProfile ppr(CoordSys());
			ppr.joinRing(rings[r], _kAdd);
			for (int o = 0; o < openings.length(); o++)
				ppr.joinRing(openings[o], _kSubtract);
			
			//{ Display dp(2); dp.draw(ppr, _kDrawFilled, 30);}
			
			//ppr.vis(r + 2);
			if (ppr.allRings(false, true).length() <1)
			{
				ppOut.joinRing(rings[r],_kAdd);
			}
			
			
		}
		pp = ppOut;
		return;
	}//End RemoveVoidsWithOpenings //endregion
	









//endregion 

//region Get Settings
	String sLastAccessedFilePath = mapSetting.getString("LastAccessedFilePath");
	
//region Defaults
	Map mapToolings = mapSetting.getMap("Tool[]");
	if (mapToolings.length()<1)
	{ 
		Map m;
		m.setDouble("Thickness", U(160));
		m.setDouble("Diameter", U(40));
		m.setDouble("Gap", U(0));
		mapToolings.appendMap("Tool", m);
		m.setDouble("Thickness", U(170));
		m.setDouble("Diameter", U(60));
		m.setDouble("Gap", U(0));
		mapToolings.appendMap("Tool", m);
		mapSetting.setMap("Tool[]", mapToolings);		
	}
	double dThicknesses[0];
	double dToolDiams[0];
	double dGaps[0];	
	getToolData(mapToolings, dThicknesses, dToolDiams, dGaps);
//endregion

//endregion 

//region Properties
	
	String sCreateOpeningName=T("|Create Openings|");	
	PropString sCreateOpening(nStringIndex++, sNoYes, sCreateOpeningName);	
	sCreateOpening.setDescription(T("|Specifies whether or not potential openings will be created on the master panel.|")+ 
		T(" |Openings are detected based on the grid size definition with a value ranging between 20 and 29.|"));
	sCreateOpening.setCategory(category);
	int bAddOpeningToMaster = sCreateOpening == sNoYes[1];
	
	String sDistributions[] = { T("|Best Fit|"), T("|Maximum Sizes|")};
	String sDistributionName=T("|Distribution|");	
	PropString sDistribution(nStringIndex++, sDistributions, sDistributionName);	
	sDistribution.setDescription(T("|Specifies how panels should be distributed within large areas.| ") + 
		T("|Best fit approach reduces waste, while 'Maximum Sizes' will allow for nesting from the largest to the smallest dimensions.|"));
	sDistribution.setCategory(category);
	sDistribution.setReadOnly(_kHidden); //TODO
//End Properties//endregion 

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
			
		int bHasData = mapSetting.getMap("Sheets").length() > 0;
		if (!bHasData && findFile(sLastAccessedFilePath).length()>0)
		{ 
			Map mapIn; 
			mapIn.setString("LastAccessedFilePath", sLastAccessedFilePath);
			importSizeGrid(mapIn);
		}
		else if(!bHasData)
			importSizeGrid(Map());
		
	// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select masterpanels|"), MasterPanel());
		if (ssE.go())
			ents.append(ssE.set());
			

	// create TSL
		TslInst tslNew;
		GenBeam gbsTsl[] = {};
		int nProps[]={};			
		double dProps[]={};				
		String sProps[]={sCreateOpening, sDistribution};
		Map mapTsl;	

		
		for (int i=0;i<ents.length();i++) 
		{ 
			MasterPanel master = (MasterPanel)ents[i];
			if (!master.bIsValid()){ continue;}
			
			Point3d ptsTsl[] = {master.ptRef()};
			Entity entsTsl[] = {master};
			
			
			tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			
	
		
		}//next i

		eraseInstance();
		return;
	}			
//endregion 



//region General
	Display dp(-1);	
	dp.textHeight(U(50));
	
	_ThisInst.setDrawOrderToFront(-100);
	
	
//endregion 

//region Trigger

//region Trigger SetStockPanelLabel
	String sTriggerSetStockPanelLabel = T("|Set Stock Panel Label|");
	addRecalcTrigger(_kContextRoot, sTriggerSetStockPanelLabel );
	if (_bOnRecalc && _kExecuteKey==sTriggerSetStockPanelLabel)
	{
	
	// prompt for sips
		Entity ents[0];
		PrEntity ssE(T("|Select panels|"), Sip());
		if (ssE.go())
			ents.append(ssE.set());
		
		
		for (int i=0;i<ents.length();i++) 
		{ 
			Sip clt =(Sip)ents[i];
			if (clt.bIsValid())
				clt.setSubLabel2(tSubLabel2);
			 
		}//next i

		setExecutionLoops(2);
		return;
	}//endregion	


	String sTriggerRemoveStockPanelLabel = T("|Remove Stock Panel Label|");
	addRecalcTrigger(_kContextRoot, sTriggerRemoveStockPanelLabel );
	if (_bOnRecalc && _kExecuteKey==sTriggerRemoveStockPanelLabel)
	{
	
	// prompt for sips
		Entity ents[0];
		PrEntity ssE(T("|Select panels|"), Sip());
		if (ssE.go())
			ents.append(ssE.set());

		for (int i=0;i<ents.length();i++) 
		{ 
			Sip clt =(Sip)ents[i];
			if (clt.bIsValid())
				clt.setSubLabel2("");
			 
		}//next i

		setExecutionLoops(2);
		return;
	}//endregion	







// Trigger ImportStockSizes//region
	String sTriggerImportStockSizes = T("|Import Stock Sizes|");
	addRecalcTrigger(_kContext, sTriggerImportStockSizes );
	if (_bOnRecalc && (_kExecuteKey==sTriggerImportStockSizes || _kExecuteKey==sDoubleClick))
	{
		Map mapIn; 
		mapIn.setString("LastAccessedFilePath", mapSetting.getString("LastAccessedFilePath"));
		reportNotice("\nmapin" + mapIn + "\n"+mapIn.getString("LastAccessedFilePath"));
		importSizeGrid(mapIn);
		setExecutionLoops(2);
		return;
	}//endregion	

//region Dialog Trigger
{ 
	// create TSL
	TslInst tslDialog;			Map mapTsl;						
	GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };


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

//endregion 

//region Get and Validate StockSizes
	
	double dXSizes[0], dYSizes[0], dValues[0];
	getStockMap(mapSetting, dXSizes, dYSizes, dValues);
	if (dXSizes.length()<2 && dYSizes.length()<2)
	{ 
		reportNotice("\n" + T("|Unexpected error, please verify stock size definitions|"));
		dp.draw(scriptName(), _Pt0, _XW, _YW, 1, 0);
		return;
	}

	double dMinX, dMinY, dMaxX, dMaxY;
	GetMinMaxStockSize(dMinX, dMinY, dMaxX, dMaxY, dXSizes, dYSizes, 30,40,dValues);
	double dAreaMin = dMinX * dMinY;
	double dAreaMax = dMaxX * dMaxY;
	
//endregion 

//region Get Master
	CoordSys cs();
	Plane pn(_PtW, _ZW);	
	
	for (int i=0;i<_Sip.length();i++) 
		_Entity.append(_Sip[i]); 

	MasterPanel master;	
	for (int i=0;i<_Entity.length();i++) 
	{ 
		Entity e = _Entity[i];		
		if (!master.bIsValid())
			master = (MasterPanel)e; 		
		setDependencyOnEntity(e);
	}//next i

	if (!master.bIsValid())
	{ 
		eraseInstance();
		return;
	}

	PlaneProfile ppMaster(cs);
	ppMaster.joinRing(master.plShape(), _kAdd);	
	PlaneProfile ppMasterRect; ppMasterRect.createRectangle(ppMaster.extentInDir(_XW), _XW, _YW);
	
	double dXMaster = ppMaster.dX();
	double dYMaster = ppMaster.dY();
	Point3d ptMid = ppMaster.ptMid();
	Vector3d vecXGrain = master.getMainGrainDirectionFromChildPanels();

// openings	
	PlaneProfile ppMasterOpening(cs);
	int openingCount = master.openingCount(); 
	PLine plOpenings[0];
	for (int i=0;i<openingCount;i++) 
	{ 
		PLine plOpening = master.plOpeningAt(i);
		
		if (bAddOpeningToMaster)
		{ 
			//ppMaster.joinRing(plOpening,_kSubtract); 
			plOpenings.append(plOpening); 
			ppMasterOpening.joinRing(plOpening, _kAdd);
		}
		else
			master.removeOpeningAt(i); 	

	}//next i

	double dThickness = master.dThickness(), dSpacing;
	double dMasterOversizeX, dMasterOversizeY;;
	
	TslInst tslMPM;
	TslInst tslQCs[0]; // a list of QC toolings attached to the master
	PlaneProfile ppQC(cs);
	{ 
		String name1="hsbCLT-Masterpanelmanager".makeUpper();
		String name2="hsbCLT-QC".makeUpper();
		
		TslInst tsls[] = master.tslInstAttached();
		for (int i=0;i<tsls.length();i++) 
		{ 
			TslInst t = tsls[i];
			String scriptName = t.scriptName().makeUpper();
			if (scriptName == name1 && !tslMPM.bIsValid())
			{ 
				tslMPM = t;
				dSpacing = tslMPM.propDouble(4);
				Map m = t.map();
				
				dMasterOversizeX = m.getDouble("MasterOversizeX");
				dMasterOversizeY = m.getDouble("MasterOversizeY");
			}
			else if (scriptName == name2 && tslQCs.find(t)<0)
			{ 
				tslQCs.append(t);
				ppQC.unionWith(t.map().getPlaneProfile("ppQC"));
			}
		}//next i	
	}
	
// Preview location
	Point3d ptBase= ppMaster.ptMid();
	ptBase -= .5*(_XW * dXMaster+_YW * dYMaster);
	Point3d ptLoc = _Pt0;
	if (_bOnDbCreated)
	{
		ptLoc = ptBase+_XW*dXOffsetLocation;		
		_Pt0 = ptLoc;
	}
	_Pt0.vis(1); ptBase.vis(4);
	Vector3d vecLoc = _Pt0 - ptBase;

// Get tool index
	int nTool;
	for (int i=0;i<dThicknesses.length();i++) 
	{ 
		double d = dThicknesses[i]-dThickness;
		if (d<dEps){ continue;}
		
		if (abs(d)<dEps)
		{ 
			nTool = 0;
			break;
		}
		 
	}//next i
	if (nTool<0)
	{ 
		reportMessage("\n" + T("|invalid thickness|"));
		eraseInstance();
		return;
	}
	double dGap= dGaps[nTool], dDiameter=dToolDiams[nTool];
	
	
	String sStyleDef;
	Sip clts[0];
	ChildPanel childs[] = master.nestedChildPanels();
	PlaneProfile ppAllChilds(cs), ppChilds[0];	int inds[0];
	PlaneProfile ppChildsNet(cs);
	for (int i=0;i<childs.length();i++) 
	{ 	
		ChildPanel& child = childs[i]; 
		
	// CLT	
		Sip clt = child.sipEntity();
		clts.append(clt);
		CoordSys csi = child.sipToMeTransformation();		
		if (sStyleDef=="")sStyleDef = clt.style();
	
	// Append/Remove any tagged stock panel to be visualized as one
		String subLabel2 = clt.subLabel2();
		int bHasStockPanelLabel = subLabel2.length()>0 && tSubLabel2.find(subLabel2, 0, false) == 0;
		int bIsStockPanel = _Sip.find(clt) >- 1;
		if (bHasStockPanelLabel && !bIsStockPanel)
		{ 
			_Sip.append(clt);
		}
		else if (!bHasStockPanelLabel && bIsStockPanel)
		{ 
			_Sip.removeAt(_Sip.find(clt));
		}		

	// Body and Profile
		Body bd = clt.envelopeBody(true, true);
		bd.transformBy(csi);
		
		PlaneProfile ppChild(cs);
		ppChild.unionWith(bd.shadowProfile(pn));
		//dp.draw(ppChild);//.vis(252);
		ppChilds.append(ppChild);
		inds.append(_Sip.find(clt));
		
		
		ppAllChilds.unionWith(ppChild);
		ppChild.shrink(-dSpacing-dEps);
		ppChildsNet.unionWith(ppChild);
		 
	}//next i
	ppChildsNet.shrink(dSpacing+dEps);
	//{ Display dp(6); dp.draw(ppChildsNet, _kDrawFilled, 20);}
	ppChildsNet.shrink(-dDiameter-dGap);
	ppChildsNet.intersectWith(ppMasterRect);
	if (bDebug) { Display dp(6); dp.draw(ppChildsNet);}//, _kDrawFilled, 20);}
	// { Display dp(6); dp.draw(ppChildsNet, _kDrawFilled, 20);}
	
	PlaneProfile ppMasterOverSize(cs);
	if (dMasterOversizeX>0)
	{ 
		Vector3d vec = .5 * (_XW * dMasterOversizeX + _YW * dYMaster);
		PLine rec; 
		rec.createRectangle(LineSeg(ptMid - vec, ptMid + vec), _XW, _YW);
		rec.transformBy(_XW * .5 * (dXMaster - dMasterOversizeX));
		ppMasterOverSize.joinRing(rec, _kAdd);
		rec.transformBy(-_XW * (dXMaster - dMasterOversizeX));
		ppMasterOverSize.joinRing(rec, _kAdd);

		
		vec = .5 * (_YW * dMasterOversizeY + _XW * dXMaster);
		rec.createRectangle(LineSeg(ptMid - vec, ptMid + vec), _XW, _YW);
		rec.transformBy(_YW * .5 * (dYMaster - dMasterOversizeY));
		ppMasterOverSize.joinRing(rec, _kAdd);
		rec.transformBy(-_YW * (dYMaster - dMasterOversizeY));
		ppMasterOverSize.joinRing(rec, _kAdd);
		//ppMasterOverSize.vis(4);		
		
	}
	
	
	
	PlaneProfile ppNet = ppMaster;
	ppNet.subtractProfile(ppChildsNet);
	ppNet.subtractProfile(ppMasterOverSize);
	ppNet.subtractProfile(ppQC);
	//{ Display dp(3); dp.draw(ppNet, _kDrawFilled, 20);}
	
	double dMasterOversize = dMasterOversizeX > dMasterOversizeY ? dMasterOversizeX : dMasterOversizeY;
	PlaneProfile ppRaw = ppMaster;
	ppRaw.subtractProfile(ppAllChilds);
	ppRaw.subtractProfile(ppMasterOverSize);
//	ppRaw.removeAllOpeningRings();
//	ppRaw.shrink(dMasterOversize);
//	ppRaw.shrink(-dMasterOversize);

	//{ Display dp(4); dp.draw(ppRaw, _kDrawFilled, 30);}

	RemoveVoidsWithOpenings(ppRaw);	
//	{ Display dp(4); dp.draw(ppRaw, _kDrawFilled, 30);}
	ExtentToMasterEdge(ppRaw, ppMasterRect, ppAllChilds);
	PLine plRawRings[] = ppRaw.allRings(true, false); // used to identify subtractions
	
//	if (plRawRings)
//	{ 
//		double dMinX, dMinY, dMaxX, dMaxY;
//		GetMinMaxStockSize(dMinX, dMinY, dMaxX, dMaxY, dXSizes, dYSizes, 0,10,dValues);
//		
//	}
	
	
	
	
	
	
	//dp.draw(ppNet);
	//{ Display dp(4); dp.draw(ppRaw, _kDrawFilled, 30);}


	PLine rings[] = ppNet.allRings(true, false);
	SimplifyPolygons(rings, dGap);
	//ppNet.removeAllRings();
	
	PlaneProfile ppShapes[0], ppSplitShapes[0], ppPolygons[0], ppSubtraction(cs);
	PLine plSubtractions[0];


	for (int r=0;r<rings.length();r++) 
	{ 
		PlaneProfile pp(cs); 
		pp.joinRing(rings[r], _kAdd);
		double dX = pp.dX();
		double dY = pp.dY();
		
		//{ Display dp(43); dp.draw(pp, _kDrawFilled, 20);}	

	// check if rectangular
		double area = pp.area();
		int bIsRectangular = abs(area - (dX * dY)) < pow(U(1), 2);

		double dx, dy;
		int nEntry = findEntry(pp, dx, dy, dXSizes, dYSizes);
		if (nEntry==-1)
		{ 
			continue;
		}

		int value=dValues[nEntry];
		
		Point3d ptn = pp.ptMid();
		ptn -= .5 * (_XW*(dX-dx)+_YW * (dY - dy));
		Vector3d vec = .5 * (_XW * dx + _YW * dy);
		PlaneProfile ppn; ppn.createRectangle(LineSeg(ptn - vec, ptn + vec), _XW, _YW);
		
		
		
	// ignore first group
		if (value<=10)
		{ 
			if (bDebug)
			{
				dp.color(252);
				dp.draw(pp.extentInDir(_XW));
			}
			continue;
		}
	// subract from master
		else if (value<=20)
		{ 
			pp.vis(2);
			PLine pl;
		// find intersceting raw ring to be subtracted
			for (int j=0;j<plRawRings.length();j++) 
			{ 
				//plRawRings[j].vis(j);
				PlaneProfile ppr(cs);
				ppr.joinRing(plRawRings[j], _kAdd);
				

				if (ppr.intersectWith(pp))
				{ 
					//{ Display dp(3); dp.draw(ppr, _kDrawFilled, 20);}					
					pl=plRawRings[j];
					break;
				}
				 
			}//next r
			
			if (pl.area()<pow(dEps,2))
				pl = rings[r];

			// TODO
			if (pl.vertexPoints(true).length()<5)
			{ 
				//plSubtractions.append(pl);
				ppSubtraction.joinRing(pl, _kAdd);
			}

			
			
			if (bDebug)
			{
				dp.color(2);
				dp.draw(pp.extentInDir(_XW));
			}
		}
	// accept new rectangular shape
		else if (bIsRectangular && value<=30)
		{ 
			dp.color(3);
			ppShapes.append(ppn);
		}
	// collect rectangular split shape
		else if (bIsRectangular && value<=40)
		{ 
			dp.color(1);
			ppn = pp; // use full range to split
			ppSplitShapes.append(pp);
		}

		else
		{ 
			ppn = pp;
			//ppn.intersectWith(ppNet);
			ppPolygons.append(ppn);
		}

		if (bDebug && bIsRectangular)// && value<=30)
		{ 
			dp.draw(dx+"x"+dy+"\n"+dX+"x"+dY+"\n"+nEntry + " "+value, pp.ptMid(),_XW,_YW,0,0,_kDevice);
			dp.draw(rings[r]);
			dp.draw(ppn, _kDrawFilled, bIsRectangular?60:10);
		}

		//rings[r].vis(r); 
	}//next i	

//	 
	// { Display dp(221); dp.draw(ppNet, _kDrawFilled, 60);}
	
//endregion 

//region Analyse polygonal shapes
	PlaneProfile ppNetPoly = ppNet;
	ppNetPoly.shrink(dDiameter+dGap);

	for (int i=0;i<ppPolygons.length();i++) 
	{ 
		//dp.color(6);
		PlaneProfile ppPolygon = ppPolygons[i]; 
		ppPolygon.intersectWith(ppNetPoly);
		
		int cnt;
		while(cnt<5 && ppPolygon.area()>dAreaMin)
		{ 
			//if (bDebug)dp.draw(ppPolygon, _kDrawFilled, 60);
			PLine rings[] = ppPolygon.allRings(true, false);		
			
			for (int r=0;r<rings.length();r++)
			{ 
				PLine ring = rings[r];
				PlaneProfile pp(cs);
				pp.joinRing(ring, _kAdd);
				double dX = pp.dX();
				double dY = pp.dY();			
				
			// find longest segment with perp
				Point3d ptRef , ptX;
				Vector3d vecX0=_XW, vecY0=_YW;
				int bOk = GetPerpCorner(ring, ptRef, ptX);
				
				Vector3d vecXR = _XW, vecYR = _YW;
				if (bOk)
				{ 	
					Vector3d vecRef = ptX - ptRef;
					vecRef.normalize();
					
					if (vecRef.dotProduct(vecXR)>0)vecXR *= -1;
					if (vecRef.dotProduct(vecYR)>0)vecYR *= -1;	
				}
	
				PlaneProfile ppn;
				int nEntry, value = -1;
				for (int xn=0;xn<dXSizes.length();xn++) 
				{ 
					double dx =dXSizes[xn];
					if (dx > dX)break;
					
					for (int yn=0;yn<dYSizes.length();yn++) 
					{ 
						double dy =dYSizes[yn];
						if (dy > dY)break;
	
						Vector3d vec = .5 * (_XW * dx + _YW * dy);
						PLine rec; rec.createRectangle(LineSeg(ptX-vec, ptX +vec), _XW, _YW);
	
						if (bOk)
							rec.transformBy(.5*(vecXR * dx + vecYR * dy));
	
						PlaneProfile ppRec(rec);
						PlaneProfile ppRecX(rec);
						
						ppRecX.subtractProfile(pp);
						if (ppRecX.area()>pow(dEps,2))
						{ 
							break;
						}
						
						if (ppn.area()>ppRec.area())
						{ 
							continue;
						}
						double dx0;
						int entry = findEntry(ppRec, dx0, dy, dXSizes, dYSizes);
						if (entry==-1)
						{ 
							continue;
						}
						value=dValues[entry];
						if (value<30)
						{ 
							continue;
						}	
	
						{
							ppn = ppRec;
							nEntry = entry;
							//rec.vis(xn);
						}
											 
					}//next yn
				}//next xn
				
			// accept new rectangular shape
				if (value>=20 && value<=30)
				{ 
					dp.color(3);
					ppShapes.append(ppn);
				}
			// collect rectangular split shape
				else if (value>30 && value<=40)
				{ 
					dp.color(1);
					ppSplitShapes.append(ppn);
				}
	
				//dp.draw(ppn, _kDrawFilled, 60);
				
				ppn.shrink(-dGap-dDiameter);
				//dp.draw(ppn);
				pp.subtractProfile(ppn);
				
			// modify polygon shape	
				ppPolygon.subtractProfile(ppn);
				ppPolygon.intersectWith(ppNetPoly);
				ppPolygon.shrink(dGap); // earclipping
				ppPolygon.shrink(-dGap);
				//dp.draw(ppPolygon);

				//dp.color(6);
				if (bDebug)dp.draw(pp, _kDrawFilled, 60);
				
			}
			
			
					
			
			cnt++;
		}

	}//next i
		
//endregion 

//region Analyse split shapes
	for (int i = 0; i < ppSplitShapes.length(); i++)
	{
		PlaneProfile pp = ppSplitShapes[i];
		double dX = pp.dX();
		double dY = pp.dY();
		
		//if (bDebug){dp.color(1);dp.draw(pp, _kDrawFilled, 70);		}
		
		
		Vector3d vecDir = dX > dY ? _YW : _XW;
		Vector3d vecPerp = vecDir.crossProduct(-_ZW);
		
		Vector3d vec = vecDir * U(10e5) + vecPerp * .5 * (dGap + dDiameter);
		PlaneProfile rec;
		rec.createRectangle(LineSeg(pp.ptMid() - vec, pp.ptMid() + vec), vecDir, vecPerp);
		pp.subtractProfile(rec);
		//if (bDebug){dp.color(1);dp.draw(pp, _kDrawFilled, 80);		}

		
		PLine rings[] = pp.allRings(true, false);
		
		for (int r = 0; r < rings.length(); r++)
		{
			PLine ring = rings[r];
			PlaneProfile ppn(cs);
			ppn.joinRing(ring, _kAdd);
			dX = ppn.dX();
			dY = ppn.dY();
			double dx, dy;
			int value, entry = findEntry(ppn, dx, dy, dXSizes, dYSizes);
			
			if (entry>-1)
			{ 
				value = dValues[entry];
				if (value>=20 && value<=30)
				{ 	
					ppShapes.append(ppn);
					if (bDebug) {dp.color(3); dp.draw(ppn, _kDrawFilled, 60); }
				}
			}
			
			
		}//next r
	
	}
//endregion 

//region Subtract Areas
	plSubtractions= ppSubtraction.allRings(true, false);	
	for (int i=0;i<plSubtractions.length();i++) 
	{ 
		PLine& pl= plSubtractions[i]; 
//		PlaneProfile pp(cs);
//		pp.joinRing(pl, _kAdd);

		if (bDebug)pl.vis(4);
		if (bAddOpeningToMaster)
			master.appendOpening(pl);
		 
	}//next i
		
//endregion 

//region Create Shapes
	if (ppShapes.length()<1 && _Sip.length()<1)
	{ 
		reportNotice("\n" + scriptName() + T("|No valid shapes detected for| ") + master.number());
		if (!bDebug)
			eraseInstance();
		return;
	}

	if (_Sip.length()<1)
	{ 
		for (int i=0;i<ppShapes.length();i++) 
		{ 
			PlaneProfile pp(cs);
			pp.unionWith(ppShapes[i]);
			
				
			double dX = pp.dX();
			double dY = pp.dY();
			
			if (bDebug)
			{
				dp.color(40);		dp.draw(pp, _kDrawFilled, 70);	 
			}
			else
			{ 
				Sip clt= CreateClt(pp, vecLoc, sStyleDef, vecXGrain.isParallelTo(_XW), master);
				_Sip.append(clt);				
			}

			
		}//next i	
		setExecutionLoops(2);
		if (_kExecutionLoopCount==0)
			return;
	}

	
	
//// Get Shapes of created panels
//	PlaneProfile ppClts[0];
//	for (int i=0;i<_Sip.length();i++) 
//	{ 
//		Sip clt= _Sip[i]; 
//		int n = clts.find(clt);
//		if (n>-1)
//		{ 
//			PlaneProfile pp = childs[n].realBody().shadowProfile(pn);
//			ppClts.append(pp);
//		}	
//		 
//	}//next i
//
	
//endregion 


//region Draw
	DrawPlaneProfile(ppMaster, dp, 12, 0, vecLoc);
	
// highlight created stock panels	
	for (int i=0;i<ppChilds.length();i++) 
	{
		
		if (inds[i]<0)
			DrawPlaneProfile(ppChilds[i], dp, 41, 0,vecLoc);
		else
			DrawPlaneProfile(ppChilds[i], dp, 141, 90,Vector3d());				
	}
	
// draw potential shapes if not created	
	for (int i=0;i<ppShapes.length();i++) 
	{
		PlaneProfile pp = ppShapes[i];
		if(!pp.intersectWith(ppAllChilds))
		{
			DrawPlaneProfile(ppShapes[i], dp, darkyellow, 0,Vector3d());
			DrawPlaneProfile(ppShapes[i], dp, darkyellow, 30,vecLoc);
		}
		
	}
	
	if (bAddOpeningToMaster)
	{ 
		int openingCount = master.openingCount(); 
		for (int i=0;i<openingCount;i++) 
			DrawPlaneProfile(PlaneProfile(master.plOpeningAt(i)), dp, green, 80, vecLoc);			
	}
	else
		for (int i=0;i<plSubtractions.length();i++) 
			DrawPlaneProfile(PlaneProfile(plSubtractions[i]), dp, 253, 60, vecLoc);	
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
        <int nm="BreakPoint" vl="257" />
        <int nm="BreakPoint" vl="228" />
        <int nm="BreakPoint" vl="1233" />
        <int nm="BreakPoint" vl="1168" />
        <int nm="BreakPoint" vl="1107" />
        <int nm="BreakPoint" vl="1200" />
        <int nm="BreakPoint" vl="1087" />
        <int nm="BreakPoint" vl="1515" />
        <int nm="BreakPoint" vl="1193" />
        <int nm="BreakPoint" vl="1421" />
        <int nm="BreakPoint" vl="1161" />
        <int nm="BreakPoint" vl="1091" />
        <int nm="BreakPoint" vl="1018" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24891: Fix when running hsbExcelToMap" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="11/11/2025 4:17:16 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22356 stock panels will be created on lower left, transparency increased" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="7/2/2024 5:11:13 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21861 display less opaque, new commmands to alter stock panel label" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="4/10/2024 5:19:18 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21640 Masterpanel openings improved, minor graphical fix" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="3/14/2024 4:06:11 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21640 intial version of hsbCLT-CreateStockPanels" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="3/13/2024 4:54:40 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End