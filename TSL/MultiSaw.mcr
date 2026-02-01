#Version 8
#BeginDescription
This tsl creates a freeprofile tool based on multiple sawblades attached to a spindle

#Versions
Version 1.0 04.08.2023 HSB-19740 initial version
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
//region <History>
// #Versions
// 1.0 04.08.2023 HSB-19740 initial version , Author Thorsten Huck

/// <insert Lang=en>
/// Select genbeams and pick location
/// </insert>

// <summary Lang=en>
// This tsl creates a freeprofile tool based on multiple sawblades attached to a spindle
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "MultiSaw")) TSLCONTENT
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
	int darkyellow3D = bIsDark?rgb(157, 137, 88):rgb(254,234,185);
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
	
	String kJigGripDistribute = "JigGripDistribute";
	String kDistance = "Distance";
	
//end Constants//endregion


//region JIG
	String kJigSelectFace = "SelectFace";
	if (_bOnJig && _kExecuteKey== kJigSelectFace)
	{ 
		Point3d ptJig = _Map.getPoint3d("_PtJig"); //running point
		int bFront = ! _Map.hasInt("showFront") ? true : _Map.getInt("showFront");
		Map mapFaces = _Map.getMap("Face[]");
		PlaneProfile pps[0];
		
		
		
		
		double dDist = U(10e5);
		int index = - 1;
		for (int i = 0; i < mapFaces.length(); i++)
		{
			PlaneProfile pp = mapFaces.getPlaneProfile(i);
			CoordSys cs = pp.coordSys();
			Vector3d vecZ = cs.vecZ();
			Point3d ptOrg = cs.ptOrg();
			
			reportNotice("\nface i " + i +" " + vecZ);
			
//			Display dpx(i);
//			dpx.draw(PLine(pp.ptMid(), pp.ptMid() + vecZ * U(200)));

			double dFront = vecZ.dotProduct(vecZView);
			if ((dFront > 0 && bFront) || (dFront < 0 && !bFront))
			{
				Point3d pt = ptJig;
				Line(ptJig, vecZView).hasIntersection(Plane(ptOrg, vecZ), pt);//
				if (pp.pointInProfile(pt)==_kPointInProfile)
					index = pps.length();
				pps.append(pp);
			}
		}
		
		Display dp(-1);
		if (index < 0 && pps.length() > 0)index = 0;
		for (int i = 0; i < pps.length(); i++)
		{
			PlaneProfile pp = pps[i];
			
			if (in3dGraphicsMode())
			{ 
				pp.transformBy(pp.coordSys().vecZ() *10*dEps);
				dp.trueColor(i == index?darkyellow3D:lightblue);				
			}
			else
			{ 
				dp.trueColor(i == index?darkyellow:lightblue,75);				
			}
			dp.draw(pp, _kDrawFilled);
		}//next i

		return;		
	}		

	String kJigDirection = "GetDirectionJig";
	if (_bOnJig && _kExecuteKey== kJigDirection)
	{ 

		Point3d ptJig = _Map.getPoint3d("_PtJig"); //running point
		PlaneProfile pp = _Map.getPlaneProfile("pp");
		Vector3d vecDir = _Map.getVector3d("vecDir");
		double toolWidth = _Map.getDouble("toolWidth");
		
		CoordSys cs = pp.coordSys();
		Vector3d vecZ = pp.coordSys().vecZ();
		
		Point3d pt2,pt1 = _Map.hasPoint3d("pt1")?_Map.getPoint3d("pt1"):pp.ptMid();
		Line(ptJig, vecZ).hasIntersection(Plane(cs.ptOrg(), vecZ), pt2);
		
		Vector3d vecX = pt2 - pt1; vecX.normalize();
		if (!vecDir.bIsZeroLength())
			vecX = vecDir;
		
		LineSeg segs[] = pp.splitSegments(LineSeg(pt2 - vecX * U(10e4), pt2 + vecX * U(10e4)), true);


		Display dp(-1), dpRed(-1);
		dp.trueColor(darkyellow);
		dp.draw(pp, _kDrawFilled, 80);
		
		dpRed.trueColor(red);
		if (segs.length()>0)
		{
			for (int i=0;i<segs.length();i++) 
			{ 
				LineSeg seg  = segs[i]; 
				
				
				PlaneProfile ppx(cs);
				ppx.createRectangle(LineSeg(seg.ptStart() - .5 * cs.vecY() * toolWidth, seg.ptEnd() + .5 * cs.vecY() * toolWidth), cs.vecX(), cs.vecY());
				dpRed.draw(ppx, _kDrawFilled, 90);
				dpRed.draw(ppx);
				
				dpRed.draw(seg);
			}//next i

		}
		else
		{ 
			LineSeg seg (pt2 - vecX * U(100), pt2 + vecX * U(100));
			dp.draw(seg);
		}
		return;
	}

//END JIG //endregion 

//region FUNCTIONS
	GenBeam[] getCoplanarGenbeams(GenBeam genbeams[], Point3d ptFace, Vector3d vecFace)
	{ 
		GenBeam out[0];
		if (genbeams.length()==1)
		{ 
			out = genbeams;
			
		}
		else
		{ 
			for (int i=0;i<genbeams.length();i++) 
			{ 
				GenBeam gb = genbeams[i];
				int bIsBeam = gb.bIsKindOf(Beam());
	
				Vector3d vecY = gb.vecY();
				Vector3d vecZ = gb.vecZ();
				Point3d ptCen = gb.ptCen();
				
				if (vecFace.isParallelTo(vecZ))
				{ 
					Point3d pt = ptCen + vecFace * .5*gb.dH();
					if (abs(vecFace.dotProduct(ptFace-pt))<dEps)
						out.append(gb);
				}
				else if (bIsBeam && vecFace.isParallelTo(vecY))
				{ 
					Point3d pt = ptCen + vecFace * .5*gb.dW();
					if (abs(vecFace.dotProduct(ptFace-pt))<dEps)
						out.append(gb);
				}	 
			}//next i			
		}


		return out;
	}

	Map getToolMap(Map mapTools, String toolName)
	{ 
		Map out;	
		for (int i=0;i<mapTools.length();i++) 
		{ 
			Map m = mapTools.getMap(i);
			if (m.getMapName() == toolName)
			{ 
				out = m;
				break;
			}			 
		}//next i		
		
		return out;
	}

	double[] getToolData(Map mapTool, int& color, double& width, double& depth, int& toolIndex, double& toolWidth, double& radius) 
	{ 
		
		String k;
		k = "Color"; if (mapTool.hasInt(k))color = mapTool.getInt(k);
		k = "ToolIndex"; if (mapTool.hasInt(k))toolIndex = mapTool.getInt(k);
		k = "Wdith"; if (mapTool.hasDouble(k))width = mapTool.getDouble(k);
		k = "Depth"; if (mapTool.getDouble(k)>dEps) depth = mapTool.getDouble(k);
		k = "ToolRadius"; if (mapTool.getDouble(k)>dEps) radius = mapTool.getDouble(k);
		
		toolWidth = width;
		
		double out[0];
		Map map = mapTool.getMap(kDistance + "[]");
		for (int i=0;i<map.length();i++) 
		{ 
			double d = map.getDouble(i);
			if (d>0)
			{
				out.append(map.getDouble(i));
				toolWidth += d;
			}
		}//next i		
		


		return out;
	}

	Vector3d selectDirection(GenBeam gb, Vector3d& vecFace, Point3d& ptFace, Point3d& ptLoc, Map mapArgs)
	{ 
		double dH = vecFace.isParallelTo(gb.vecZ())?gb.dH():gb.dW();
		Body bd = gb.envelopeBody(false, true);
		Plane pnFace(ptFace, vecFace);
		PrPoint ssP(T("|Select first point [Lengthwise/Crosswise/Align/FlipSide]|")); // second argument will set _PtBase in map
	    Vector3d vecDir = gb.vecX();
	    PlaneProfile pp = gb.envelopeBody(false, true).extractContactFaceInPlane(pnFace, dEps);
		
		mapArgs.setPlaneProfile("pp", pp);
 		mapArgs.setVector3d("vecDir", vecDir);
	    int nGoJig = -1;
	    Point3d ptsDir[0];
	    while (nGoJig != _kNone)//nGoJig != _kOk && nGoJig != _kNone)
	    {
	        nGoJig = ssP.goJig(kJigDirection, mapArgs); 

	        if (nGoJig == _kOk && ptsDir.length()<2)
	        {
	            Point3d pt = ssP.value();
	            Line(pt, vecFace).hasIntersection(pnFace, pt);
	            ptsDir.append(pt);
	            mapArgs.setPoint3d("pt1", pt);
	            
	        // alignment specified    
	            if (!vecDir.bIsZeroLength())
	            {
	            	ptLoc = pt;
	            	break;
	            }
	            else if (ptsDir.length()==2)
	            { 
		            vecDir = ptsDir[1] - ptsDir[0];
		            if (vecDir.bIsZeroLength())
		            	vecDir = gb.vecX();
		            else
		            	vecDir.normalize();	
		            break;
	            }
	           
	        }
	        else if (nGoJig == _kKeyWord)
	        { 
	        	int key = ssP.keywordIndex();
	            if (key == 0)
	            {
	            	vecDir= gb.vecX();
	            	mapArgs.setVector3d("vecDir", vecDir);
	            	reportNotice("\nLengthwise vecDir = " +vecDir + " " + vecFace);
	            	if (ptsDir.length()>0)break;
	            }
	            else if (key == 1)
	            {
	            	vecDir= gb.vecX().crossProduct(-vecFace);
	            	mapArgs.setVector3d("vecDir", vecDir);
	            	reportNotice("\nCrosswise vecDir = " +vecDir+ " " + vecFace);
	            	if (ptsDir.length()>0)break;
	            }
	            else if (key == 2)
	            {
	            	vecDir= Vector3d(0, 0, 0);;
	            	mapArgs.removeAt("vecDir", true);
	            }	            
	            else if (key == 3)
	            { 
	            	vecFace *= -1;
	            	ptFace = gb.ptCen() + .5 * vecFace * dH;
					pnFace = Plane(ptFace, vecFace);

					pp = bd.extractContactFaceInPlane(pnFace, dEps);
					mapArgs.setPlaneProfile("pp", pp);

	            }
	        }
	        else if (nGoJig == _kCancel)
	        { 
	        	break;
	        }
	    }			
		
		if (ptsDir.length()>0)
			ptLoc = ptsDir.first();
		else
			vecDir = Vector3d(0, 0, 0); // invalidates function to indicate wrong input


		return vecDir;
	}

	Point3d getExtremePointInDir(PlaneProfile pp, Point3d ptAxis, Vector3d vecDir)
	{ 
		Point3d pt = ptAxis;

		LineSeg segs[] = pp.splitSegments(LineSeg(pt - vecDir * U(10e5), pt + vecDir * U(10e5)), true);
		Point3d pts[0];
		for (int i=0;i<segs.length();i++) 
		{ 
			pts.append(segs[i].ptStart());
			pts.append(segs[i].ptEnd());	 
		}//next i
		pts = Line(pt, - vecDir).orderPoints(pts, dEps);
		if (pts.length()>0)
			pt = pts.first();
		return pt;
	}
	PLine getSplitPLineInDir(PlaneProfile pp, Point3d ptAxis, Vector3d vecDir)
	{ 
		PLine pl(pp.coordSys().vecZ());
		Point3d pt = ptAxis;

		LineSeg segs[] = pp.splitSegments(LineSeg(pt - vecDir * U(10e5), pt + vecDir * U(10e5)), true);
		Point3d pts[0];
		for (int i=0;i<segs.length();i++) 
		{ 
			pts.append(segs[i].ptStart());
			pts.append(segs[i].ptEnd());	 
		}//next i
		pts = Line(pt, - vecDir).orderPoints(pts, dEps);
		if (pts.length()>0)
		{
			pl.addVertex(pts.first());
			pl.addVertex(pts.last());	
		}
		return pl;
	}	

//END Function //endregion 

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="MultiSaw";
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
	Map mapTools;
	String sToolNames[0];
	int nc = 4;
{
	String k;
	Map m;
	mapTools= mapSetting.getMap("Tools[]");
	for (int i=0;i<mapTools.length();i++) 
	{ 
		m = mapTools.getMap(i);
		String name = m.getMapName();
		if (name.length()>0 && sToolNames.findNoCase(name,-1)<0)
			sToolNames.append(name);
		 
	}//next i
	
// global settings	
	m = mapSetting;
	k="Color";			if (m.hasInt(k))	nc = m.getInt(k);
//
//
//	k="DoubleEntry";		if (m.hasDouble(k))	dDoubleEntry = m.getDouble(k);
//	k="StringEntry";		if (m.hasString(k))	sStringEntry = m.getString(k);
//	
	
}

// Default if no tool definition was found
	if (sToolNames.length()<1)
	{ 
		String name = T("<|Default|>");
		Map map;
		map.setInt("Color", nc);
		map.setDouble("Width", U(3.5));
		map.setDouble("Depth", U(14));
		map.setDouble("ToolRadius", U(125));
		map.setInt("ToolIndex", 99);
		
		Map m;
		m.appendDouble(kDistance, U(15));
		m.appendDouble(kDistance, U(15));
		m.appendDouble(kDistance, U(30));
		m.appendDouble(kDistance, U(15));
		m.appendDouble(kDistance, U(15));
		m.appendDouble(kDistance, U(15));

		map.setMap(kDistance+"[]", m);
		map.setMapName(name);
		
		mapTools.appendMap("Tool", map);
		mapSetting.setMap("Tools[]", mapTools);
		sToolNames.append(name);
	}
//End Read Settings//endregion 
	
	
	
	
	
//End Settings//endregion	

//region Properties

category = T("|Tool|");
	String sToolName=T("|Tool|");	
	PropString sTool(nStringIndex++, sToolNames.sorted(), sToolName);	
	sTool.setDescription(T("|Defines the name of he tool.|"));
	sTool.setCategory(category);

	String sDepthName=T("|Depth|");	
	PropDouble dDepth(nDoubleIndex++, U(0), sDepthName);	
	dDepth.setDescription(T("|Defines the depth of the tool|") + T(", |0 = byToolDefinition|"));
	dDepth.setCategory(category);

category = T("|Alignment|");
	String kReferenceFace = T("|Bottom Face|"),kTopFace =  T("|Top Face|");
	String sFaceName=T("|Face|");
	String sFaces[] ={ kReferenceFace, kTopFace };
	PropString sFace(nStringIndex++, sFaces, sFaceName);	
	sFace.setDescription(T("|Defines the Face|"));
	sFace.setCategory(category);
	int nFace = sFace == kReferenceFace ?- 1 : 1;
	
	String sOffsetAName=T("|Offset Start|");	
	PropDouble dOffsetA(nDoubleIndex++, U(0), sOffsetAName);	
	dOffsetA.setDescription(T("|Defines the OffsetA|"));
	dOffsetA.setCategory(category);
	
	String sOffsetBName=T("|Offset End|");	
	PropDouble dOffsetB(nDoubleIndex++, U(0), sOffsetBName);	
	dOffsetB.setDescription(T("|Defines the OffsetB|"));
	dOffsetB.setCategory(category);	
	
	
//endregion 

//region OnInsert
	if (_bOnInsert)
	{
		if (insertCycleCount() > 1) { eraseInstance(); return; }
		
		// silent/dialog
		if (_kExecuteKey.length() > 0 && TslInst().getListOfCatalogNames(scriptName()).findNoCase(_kExecuteKey ,- 1) >- 1)
			setPropValuesFromCatalog(_kExecuteKey);
			// standard dialog
		else
			showDialog();
		
		
		//region Get Selection Set
		Entity ents[0];
		PrEntity ssE(T("|Select genbeams|"), GenBeam());
		if (ssE.go())
			ents.append(ssE.set());
		
		
		// collect genbeams
		for (int i = 0; i < ents.length(); i++)
		{
			GenBeam gb = (GenBeam)ents[i];
			if (gb.bIsValid())
				_GenBeam.append(gb);
		}//next i
	}
//OnInsert 2 //endregion 		

//region Get References
	if (_GenBeam.length()<1)
	{ 
		reportMessage(TN("|nor references found|"));	
		eraseInstance();
		return;
	}
	GenBeam gbRef =_GenBeam.first();
	GenBeam genbeams[0]; genbeams = _GenBeam;
	Vector3d vecX = gbRef.vecX();
	Vector3d vecY = gbRef.vecY();				
	Vector3d vecZ = gbRef.vecZ();
	Point3d ptCen = gbRef.ptCen();
	Quader qdr = gbRef.bodyExtents();
	int bIsBeam = gbRef.bIsKindOf(Beam());
	Body bdRef = gbRef.envelopeBody(false, true);
	double dH= gbRef.dH();


	Vector3d vecFace;
	Point3d ptFace;
	
	Plane pnFace;
//endregion 

//region Tool Data
	Map mapTool = getToolMap(mapTools, sTool);

	int color = nc, toolIndex = 99;
	double dWidth = U(3.5);
	double dToolWidth = dWidth;
	double dThisDepth = dDepth;
	double dToolRadius;
	double dDistances[] = getToolData(mapTool, color, dWidth, dThisDepth, toolIndex,dToolWidth, dToolRadius);
	if (dDepth > 0)dThisDepth = dDepth;

// calculate overshoot value
	double dOvershoot;
	if (dToolRadius>0)
	{
		double r = dToolRadius;
		double h = dThisDepth;
		dOvershoot = sqrt(2 * r * h - pow(h, 2));
	}
//endregion 

//region OnInsert 2
	if(_bOnInsert)
	{		
	//region Face selection if view direction not orthogonal to one of the 4 faces of the ref genbeam
	// Get face of insertion
		int bIsOrthoView = gbRef.vecD(vecZView).isParallelTo(vecZView);	
		if (bIsOrthoView)
			vecFace = vecZView;
		else if(bIsBeam)
		{
			vecFace =gbRef.vecD(vecZView);
		}
		else
		{
			vecFace = vecZView.dotProduct(vecZ) > 0 ? vecZ :- vecZ;
		}
		

	// set face
		if (vecFace.isParallelTo(vecX))
		{
			reportMessage("\n"+ scriptName() + T("|Insertion in YZ-Plane not supported| ")+T("|Tool will be deleted.|"));
			eraseInstance();
			return;
		}	

		if (!bIsOrthoView && bIsBeam)
		{
			int nFaceIndex = - 1;
			int bFront = true; //default to pick a face on viewing side
			Map mapArgs, mapFaces;
			mapArgs.setInt("_Highlight", in3dGraphicsMode());
			mapArgs.setInt("showFront", bFront);
			
		// Set Faces and profiles
			Vector3d vecFaces[0];
			if (bIsBeam)
			{ 
				Vector3d vecs[] ={ vecY, vecZ , - vecY, - vecZ};
				vecFaces = vecs;
			}
			else
			{ 
				Vector3d vecs[] ={ vecZ ,- vecZ};
				vecFaces = vecs;				
			}			

			PlaneProfile ppFace,pps[0];//yz-y-z
			for (int i=0;i<vecFaces.length();i++) 
			{ 
				Vector3d vecFaceI = vecFaces[i];
				PlaneProfile pp = bdRef.extractContactFaceInPlane(Plane(ptCen+vecFaceI*.5*gbRef.dD(vecFaceI), vecFaceI), U(1)); 
				pps.append(pp);
				mapFaces.appendPlaneProfile("pp", pp);

				if (bIsOrthoView && vecFace.isCodirectionalTo(vecFaceI))
				{
					nFaceIndex = i;
					ppFace = pp;
					mapArgs.setInt("FaceIndex", nFaceIndex);
				}
				
			}//next i
			mapArgs.setMap("Face[]", mapFaces);	


		//region Face selection
			int nGoJig = -1;
			PrPoint ssP(T("|Select face|")+ T(" |[Flip face]|"));
			ssP.setSnapMode(TRUE, 0); // turn off snaps
		    while (!bIsOrthoView && nGoJig != _kOk && nGoJig != _kNone)
		    {
		        nGoJig = ssP.goJig(kJigSelectFace, mapArgs); 
	
		        if (nGoJig == _kOk)
		        {
		            Point3d ptPick = ssP.value();
					int index;
					for (int i=0;i<pps.length();i++) 
					{
						PlaneProfile pp = pps[i];
						CoordSys cs = pp.coordSys();
						Vector3d vecZ = cs.vecZ();
						if (vecZ.isPerpendicularTo(vecZView))continue;
						Point3d ptOrg = cs.ptOrg();
						double dFront = vecZ.dotProduct(vecZView);
						if((dFront>0 && bFront) || (dFront<0 && !bFront)) // accept only profiles in view wirection or opposite
						{
							Point3d pt = ptPick;
							Line(pt, vecZView).hasIntersection(Plane(ptOrg, vecZ), pt);
							if (pp.pointInProfile(pt)==_kPointInProfile)
								index = i;
						}
					}    
		            
		            if (index>-1)
		            { 
		            	vecFace = gbRef.vecD(pps[index].coordSys().vecZ());	
		            	mapArgs.setInt("FaceIndex", index);
		            	nFaceIndex = index;
		            	ppFace = pps[index];	
		            }  
		        } 
		    	else if (nGoJig == _kKeyWord)
		        { 
		        // toggle in or opposite view	
		            if (ssP.keywordIndex() == 0)
		            {
		            	bFront =!bFront;
		            	mapArgs.setInt("showFront", bFront);
		            }    
		        }   
		        else
		        { 
		            eraseInstance(); // do not insert this instance
		            return; 
		        }
		    }			
			//End Face selection//endregion 		
			ssP.setSnapMode(false, 0); // turn on snaps	
	
		}
		// orthogonal view, set ref or top side
		else
		{ 
			vecFace*=nFace; 
		}
		
		dH = gbRef.dD(vecFace);
		ptFace = ptCen + .5 * vecFace * dH;
		pnFace = Plane(ptFace, vecFace);
		_Map.setVector3d("vecFace", vecFace);
	//endregion 


		

//	//region Get direction Jig
//		PrPoint ssP(T("|Select first point [Lengthwise/Crosswise/FlipSide]|")); // second argument will set _PtBase in map
//	    Vector3d vecDir = vecX;
//	    PlaneProfile pp = bdRef.extractContactFaceInPlane(pnFace, dEps);
//	    Map mapArgs;
//		mapArgs.setPlaneProfile("pp", pp);
// 
//	    int nGoJig = -1;
//	    Point3d ptsDir[0];
//	    while (nGoJig != _kNone)//nGoJig != _kOk && nGoJig != _kNone)
//	    {
//	        nGoJig = ssP.goJig(kJigDirection, mapArgs); 
//
//	        if (nGoJig == _kOk && ptsDir.length()<2)
//	        {
//	            Point3d pt = ssP.value();
//	            Line(pt, vecFace).hasIntersection(pnFace, pt);
//	            ptsDir.append(pt);
//	            mapArgs.setPoint3d("pt1", pt);
//	            
//	            if (ptsDir.length()==2)
//	            { 
//		            vecDir = ptsDir[1] - ptsDir[0];
//		            if (vecDir.bIsZeroLength())
//		            	vecDir = vecX;
//		            else
//		            	vecDir.normalize();	
//		            break;
//	            }
//	           
//	        }
//	        else if (nGoJig == _kKeyWord)
//	        { 
//	        	int key = ssP.keywordIndex();
//	            if (key == 0)
//	            {
//	            	vecDir== vecX;
//	            	if (ptsDir.length()>0)break;
//	            }
//	            else if (key == 1)
//	            {
//	            	vecDir== vecX.crossProduct(vecFace);
//	            	if (ptsDir.length()>0)break;
//	            }
//	            else if (key == 2)
//	            { 
//	            	vecFace *= -1;
//	            	ptFace = ptCen + .5 * vecFace * dH;
//					pnFace = Plane(ptFace, vecFace);
//					_Map.setVector3d("vecFace", vecFace);
//					
//					pp = bdRef.extractContactFaceInPlane(pnFace, dEps);
//					mapArgs.setPlaneProfile("pp", pp);
//
//	            }
//	        }
//	        else if (nGoJig == _kCancel)
//	        { 
//	        	break;
//	        }
//	    }			
//
//			
//	//End Get direction Jig//endregion 
//	
		Map mapArgs;
		mapArgs.setDouble("toolWidth", dToolWidth);
		
		Point3d ptLoc;
		Vector3d vecDir = vecX;
		vecDir = selectDirection(gbRef, vecFace, ptFace, ptLoc, mapArgs);	
	
		if (vecDir.bIsZeroLength())
			eraseInstance();
		else
		{
			_Map.setVector3d("vecDir", vecDir);
			
		// set side property
			if (vecFace.isCodirectionalTo(-vecZ) && sFace!=kReferenceFace)
				sFace.set(kReferenceFace);
			else if (vecFace.isCodirectionalTo(vecZ) && sFace!=kTopFace)
				sFace.set(kTopFace);
			else if (vecFace.isCodirectionalTo(-vecY) && sFace!=kReferenceFace)
				sFace.set(kReferenceFace);	
			else if (vecFace.isCodirectionalTo(vecY) && sFace!=kTopFace)
				sFace.set(kTopFace);
			
			_Pt0 = ptLoc;
		}
		return;
	}			
//endregion 

//region Defaults and Tool CoordSys
	// copy behaviour
	setEraseAndCopyWithBeams(_kBeam0);

	vecFace = sFace == kReferenceFace?-vecZ:vecZ;
	if (bIsBeam && _Map.hasVector3d("vecFace"))
	{
		vecFace = _Map.getVector3d("vecFace");
		if (vecFace.isParallelTo(vecY))
			dH = gbRef.dW();
		
	}
	ptFace = ptCen + vecFace * .5 * dH;
	vecFace.vis(ptFace, 150);
	pnFace =Plane (ptFace, vecFace);
	genbeams= getCoplanarGenbeams(_GenBeam, ptFace, vecFace);
		
	Vector3d vecXT = _Map.hasVector3d("vecDir") ? _Map.getVector3d("vecDir") : vecX;
	vecXT.vis(ptFace, 2);
	
	Vector3d vecYT = vecXT.crossProduct(vecFace);
	
	Vector3d vecYN =vecYT;
	if(vecFace.isCodirectionalTo(-vecZ) || vecFace.isCodirectionalTo(-vecY)) 
		vecYT*=-1;

	
	CoordSys csTool(ptFace, vecXT, vecYT, vecFace);
	PlaneProfile ppFace(csTool);
	for (int i=0;i<genbeams.length();i++) 
	{ 
		PlaneProfile pp= genbeams[i].envelopeBody(false, true).extractContactFaceInPlane(pnFace, dEps);
		pp.shrink(-dEps);
		ppFace.unionWith(pp); 
	}//next i
	ppFace.shrink(dEps);	ppFace.vis(4);			
		
	Display dp(140), dpTool(1);	
//endregion 	

//region Grip Management #GM

	// when the instance gets copied the UID changes and the grips will be reset
	if (!_bOnGripPointDrag)
	{ 
		String prevUID = _Map.getString("UID");
		String currentUID = _ThisInst.uniqueId();
		if (prevUID.length()>0 && prevUID!=currentUID)
			_Grip.setLength(0);
		_Map.setString("UID",currentUID);		
	}

	//_Grip.setLength(0);
	addRecalcTrigger(_kGripPointDrag, "_Grip");	
	_ThisInst.setAllowGripAtPt0(false);
	String kGripBase="Base", kGripRotate="Rotate";
	String kGrips[] = { kGripBase, kGripRotate};
	int nGrips[] ={-1,-1};
	Point3d ptLocRotate = (getExtremePointInDir(ppFace, _Pt0, vecXT) + _Pt0) * .5;
	
	Point3d ptLocs[] ={ _Pt0, ptLocRotate};
	for (int i=0;i<_Grip.length();i++) 
	{ 
		Point3d pt = _Grip[i].ptLoc();
		pt += vecFace * vecFace.dotProduct(ptFace - pt);
		_Grip[i].setPtLoc(pt);
		
		int n = kGrips.findNoCase(_Grip[i].name() ,- 1);
		if (n >- 1)nGrips[n] = i;	 	
	}	
	
//Create grips
	for (int i=0;i<kGrips.length();i++) 
	{ 
		if (nGrips[i]<0)
		{ 
			Grip grip;
			grip.setPtLoc(ptLocs[i]);
			grip.setVecX(i==0?vecXT:vecYT);
			grip.setVecY(i==0?vecYT:vecXT);
			grip.setColor(i==0?150:4);
			grip.setShapeType(i==0 ? _kGSTAcad : _kGSTDiamond);
			grip.setName(kGrips[i]);
			grip.setIsRelativeToEcs(i == 0 ? false : true);
			
			if (i==0)
				grip.setToolTip(T("|Moves the location of tool|"));
			else if (i==1)
				grip.setToolTip(T("|Specifies new alignment of tool|"));


			grip.addHideDirection(vecXT);
			grip.addHideDirection(-vecXT);
			grip.addHideDirection(vecYT);
			grip.addHideDirection(-vecYT);
			
			_Grip.append(grip);
			nGrips[i] = _Grip.length() - 1;
		}
	}//next i	
	
	int nGripBase = nGrips[0];
	int nGripRotate = nGrips[1];
	
	Point3d ptBase = nGripBase >- 1 ? _Grip[nGripBase].ptLoc() : ptLocs[0];

	int indexOfMovedGrip = Grip().indexOfMovedGrip(_Grip); 
	int bBaseGripMoved = nGripBase>-1 && !_Grip[nGripBase].vecOffsetApplied().bIsZeroLength();
	int bGripRotate= indexOfMovedGrip >-1 && indexOfMovedGrip == nGripRotate;
	if (indexOfMovedGrip >- 1) dp.trueColor(darkyellow);
	
//	reportNotice("\nGrip Report:\n" + 
//		"\ngrips" + _Grip.length()+
//		"\nbBaseGripMoved: " +bBaseGripMoved + 
//		"\nindexOfMovedGrip: " +indexOfMovedGrip + 
//		"\n_bOnGripPointDrag" + _bOnGripPointDrag+
//		"\nbGripRotate" + bGripRotate+
//		"\nkNameLast" + _kNameLastChangedProp
//		);
//	
//endregion 

//region Grips dragged
	if (bBaseGripMoved && _kNameLastChangedProp=="_Grip")
	{ 
		_Pt0=ptBase;
		setExecutionLoops(2);
	}
	else if (bGripRotate)
	{ 
		Vector3d vec = _Grip[nGripRotate].ptLoc()-_Pt0;
		vec.normalize();
		_Map.setVector3d("vecDir", vec);
		vecXT = vec;
		vecYT = vecXT.crossProduct(-vecFace);
		setExecutionLoops(2);
	}
//endregion 

//region Get Max Length / Range
	Point3d ptRef = _Pt0;
	ptRef += vecFace * vecFace.dotProduct(ptFace - ptRef); 
	PlaneProfile ppRange(csTool);
	{ 
		Vector3d vec = vecXT * U(10e5) + vecYT * .5 * dToolWidth;
		ppRange.createRectangle(LineSeg(ptRef - vec, ptRef + vec), vecXT, vecYT);
	}
	
	ppRange.intersectWith(ppFace);	ppRange.vis(3);
	int bHasOffset = dOffsetA >= dEps || dOffsetB >= dEps;

//endregion 
	
//region Add tooling
	PLine rings[] = ppRange.allRings(true, false);
	int num = dDistances.length()+1;
	int bIsSkewed;
	
	// loop every ring of the range
	for (int r=0;r<rings.length();r++) 
	{ 	
		PlaneProfile pp(csTool);
		pp.joinRing(rings[r],_kAdd);
		
		PlaneProfile ppBox=pp;
		ppBox.createRectangle(pp.extentInDir(vecXT), vecXT, vecYT);	
		bIsSkewed = (abs(ppBox.area() - pp.area()) > pow(U(1), 2));
		//pp.extentInDir(vecXT).vis(bIsSkewed?1:2);


		double dLength = ppBox.dX();		
	// segment to short	
		if (dLength<=dOffsetA+dOffsetB)
		{ 
			pp.vis(1);
			continue;
		}
		dLength -= (dOffsetA + dOffsetB);
		
	// segment to short due to to tool radius/depth	
		if (dLength<2*dOvershoot)
		{ 
			pp.vis(6);
			continue;
		}
		
		if (indexOfMovedGrip>-1)
		{
			dp.draw(pp,_kDrawFilled,70);
		}
		else if (bIsSkewed)
			dp.draw(pp);

		Point3d ptX = ptRef;
		ptX -= vecYN * .5 * (dToolWidth-dWidth);
		for (int i=0;i<num;i++) 
		{ 
			Point3d pt = ppBox.ptMid()+vecXT*.5*(dOffsetA-dOffsetB);
			pt += vecYN * vecYN.dotProduct(ptX - pt);
			
			
		// adjust location and length if skewed with offsets
			if (bIsSkewed && bHasOffset)
			{ 
				Vector3d vec = vecXT * U(10e5) + vecYT * .5 * dWidth;
				PlaneProfile ppx;
				ppx.createRectangle(LineSeg(pt-vec, pt+vec), vecXT, vecYT);	
				ppx.intersectWith(pp);
				ppx.createRectangle(ppx.extentInDir(vecXT), vecXT, vecYT);

				dLength = ppx.dX();
			// segment to short	
				if (dLength<=dOffsetA+dOffsetB)
				{ 
					ppx.vis(1);
					continue;
				}
				dLength -= (dOffsetA + dOffsetB);
				
			// segment to short due to to tool radius/depth	
				if (dLength<2*dOvershoot)
				{ 
					pp.vis(6);
					continue;
				}				
				pt = ppx.ptMid();
			}

			Body bd;
			
		// Offset defined: show tooling with radius of sawblade
			if (bHasOffset && dToolRadius>0)
			{ 
				PLine plShape(vecYT);
				plShape.addVertex(pt-vecXT*.5*dLength+vecFace*U(5));
				plShape.addVertex(pt-vecXT*.5*dLength);
				plShape.addVertex(pt-vecXT*(.5*dLength-dOvershoot)-vecFace*dThisDepth, dToolRadius,false);
				plShape.addVertex(pt+vecXT*(.5*dLength-dOvershoot)-vecFace*dThisDepth);
				plShape.addVertex(pt+vecXT*.5*dLength, dToolRadius,false);
				plShape.addVertex(pt+vecXT*.5*dLength+vecFace*U(5));
				plShape.close();			//plShape.vis(4);	
				
				bd = Body(plShape, vecYT * dWidth, 0);
				
			// offset defined, but skewed distribution: create individual slots	
				if (bIsSkewed)
				{ 
					Slot slot(pt+vecFace*dEps, vecXT, vecYT, vecFace, dLength, dWidth, dThisDepth+dEps, 0, 0 ,- 1);
					slot.setDoSolid(false);
					for (int x=0;x<genbeams.length();x++) 
						genbeams[x].addTool(slot); 					
				}	
			}
		// no offset defined, just create boxed shape	
			else
				bd = Body(pt+vecFace*dEps, vecXT, vecYT, vecFace, dLength, dWidth, dThisDepth+dEps, 0, 0 ,- 1);

			bd.vis(3);
			
		// during dragging of a grip	
			if (_bOnGripPointDrag)
			{	
				dp.draw(bd);
			}
		// add solid tooling	
			else
			{ 
				SolidSubtract sosu(bd, _kSubtract);
				for (int x=0;x<genbeams.length();x++) 
					genbeams[x].addTool(sosu); 
			
			}

			if (i == num - 1)break;
			ptX+=vecYN*dDistances[i];
		}//next i	


	// Export Tool Path
		if (!bIsSkewed || !bHasOffset)
		{ 
			Point3d pt = _Pt0+vecFace*vecFace.dotProduct(ptFace-_Pt0);
			PLine plTool = getSplitPLineInDir(ppBox,pt, vecXT);
			plTool.vis(1);	
			dpTool.draw(plTool);
			
			Point3d ptsClose[] = plTool.vertexPoints(true);
			for (int i=0;i<ptsClose.length();i++) 
				ptsClose[i]+=vecFace*U(100); 


			FreeProfile fp(plTool,ptsClose);//ptCutAwayFemale );//HSB-18962
			fp.setDepth(dThisDepth);
			fp.setCncMode(toolIndex);
//			fp.setSolidMillDiameter(dWidth);
//			fp.cuttingBody().vis(6);
			
			for (int x=0;x<genbeams.length();x++) 
				genbeams[x].addTool(fp);
	
		}

	}//next r		 
//endregion 


//region TRIGGER


//region Trigger SetAlignmentX
	String sTriggerSetXAlignment = T("|Select X-Alignment|");
	addRecalcTrigger(_kContextRoot, sTriggerSetXAlignment );
	if (_bOnRecalc && _kExecuteKey==sTriggerSetXAlignment)
	{
		_Grip.setLength(0);
		_Map.setVector3d("vecDir", vecX);
		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger SetAlignmentY
	String sTriggerSetYAlignment = T("|Select Y-Alignment|");
	addRecalcTrigger(_kContextRoot, sTriggerSetYAlignment );
	if (_bOnRecalc && _kExecuteKey==sTriggerSetYAlignment)
	{
		_Grip.setLength(0);
		_Map.setVector3d("vecDir", vecY);
		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger RevertDirection
	String sTriggerRevert = T("|Revert Direction|");
	addRecalcTrigger(_kContextRoot, sTriggerRevert );
	if (_bOnRecalc && _kExecuteKey==sTriggerRevert)
	{
		_Grip.setLength(0);
		_Map.setVector3d("vecDir", -vecXT);
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
}//endregion 
//End Dialog Trigger//endregion 
	

		
//END TRIGGER //endregion 
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
        <int nm="BreakPoint" vl="1137" />
        <int nm="BreakPoint" vl="1115" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19740 initial version" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="8/4/2023 3:29:30 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End