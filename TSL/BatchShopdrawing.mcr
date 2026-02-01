#Version 8
#BeginDescription
This tsl creates parent and/or nested shopdrawings of individual or nested items

#Versions
Version 3.1 03.12.2024 HSB-23092 max bounding of border fixed , Author Thorsten Huck
Version 3.0 02.12.2024 HSB-23092 mew property to enable optional selection of xref entities
Version 2.9 12.11.2024 HSB-22965 plotviewport naming, new command to specidy rectangular border
Version 2.8 17.06.2024 HSB-22271 bugfix header block creation on insert
Version 2.7 17.06.2024 HSB-22271 smoothening property published on insert
Version 2.6 03.04.2024 HSB-20206 assemblyDefinition supported to create nested
Version 2.5 02.04.2024 HSB-20206 naming of the property of the header clarified
Version 2.4 15.11.2023 HSB-20550 renesting of existing pages imrpoved, insert jig and margin grips added
Version 2.3 15.11.2023 HSB-20550 bugfix color and margin on creation, smoothing improved

Version 2.2 14.11.2023 HSB-20550 list token replaced to ?, simple shape recognition of schedule table added
Version 2.1 14.11.2023 HSB-20550 purging redundant dimlines improved, new property and context command for smoothing of bounding border, placement left over pages added, new properties for margin and color
Version 2.0 13.11.2023 HSB-20550 purges redundant dimlines on creation
Version 1.9 13.11.2023 HSB-20550 new subnesting and alignment
Version 1.8 08.08.2023 HSB-19707 instance will be purged on creation
Version 1.7 09.05.2023 HSB-18906 catching objectCollectionType on creation for hsbDesign25
Version 1.6 03.05.2023 HSB-18884 added support to purge existing plotviewports and blockrefs when running in redistribution mode, new options to toggle styles
Version 1.5 19.04.2023 HSB-18681 plotviewports and brefs appended, simple nesting respects bref outline, compatibel V25
Version 1.4 18.04.2023 HSB-18681 plotviewports and brefs appended, simple nesting respects bref outline
Version 1.3 10.03.2023 HSB-18245 revised and simple polygonal nesting included


















#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 3
#MinorVersion 1
#KeyWords 
#BeginContents

//region #Part1
	
//region <History>
// #Versions
// 3.1 03.12.2024 HSB-23092 max bounding of border fixed , Author Thorsten Huck
// 3.0 02.12.2024 HSB-23092 mew property to enable optional selection of xref entities , Author Thorsten Huck
// 2.9 12.11.2024 HSB-22965 plotviewport naming, new command to specidy rectangular border , Author Thorsten Huck
// 2.8 17.06.2024 HSB-22271 bugfix header block creation on insert , Author Thorsten Huck
// 2.7 17.06.2024 HSB-22271 smoothening property published on insert , Author Thorsten Huck
// 2.6 03.04.2024 HSB-20206 assemblyDefinition supported to create nested , Author Thorsten Huck
// 2.5 02.04.2024 HSB-20206 naming of the property of the header clarified , Author Thorsten Huck
// 2.4 15.11.2023 HSB-20550 renesting of existing pages imrpoved, insert jig and margin grips added , Author Thorsten Huck
// 2.3 15.11.2023 HSB-20550 bugfix color and margin on creation, smoothing improved , Author Thorsten Huck
// 2.2 14.11.2023 HSB-20550 list token replaced to ?, simple shape recognition of schedule table added , Author Thorsten Huck
// 2.1 14.11.2023 HSB-20550 purging redundant dimlines improved, new property and context command for smoothing of bounding border, placement left over pages added, new properties for margin and color , Author Thorsten Huck
// 2.0 13.11.2023 HSB-20550 purges redundant dimlines on creation , Author Thorsten Huck
// 1.9 13.11.2023 HSB-20550 new subnesting and alignment , Author Thorsten Huck
// 1.8 08.08.2023 HSB-19707 instance will be purged after creation , Author Thorsten Huck
// 1.7 09.05.2023 HSB-18906 catching objectCollectionType on creation for hsbDesign25 , Author Thorsten Huck
// 1.6 03.05.2023 HSB-18884 added support to purge existing plotviewports and blockrefs when running in redistribution mode, new options to toggle styles , Author Thorsten Huck
// 1.5 19.04.2023 HSB-18681 plotviewports and brefs appended, simple nesting respects bref outline, compatibel V25 , Author Thorsten Huck
// 1.4 18.04.2023 HSB-18681 plotviewports and brefs appended, simple nesting respects bref outline , Author Thorsten Huck
// 1.3 10.03.2023 HSB-18245 revised and simple polygonal nesting included , Author Thorsten Huck
// 1.2 07.10.2022 HSB-15687 POC plot viewport added , Author Thorsten Huck
// 1.1 15.06.2022 HSB-15687 removed drillPatternDimension as it is self suupporting in blockspace , Author Thorsten Huck
// 1.0 09.06.2022 HSB-15687 initial poc of nested individual multipages , Author Thorsten Huck

/// <insert Lang=en>
/// Select metalpart collection entity
/// </insert>

// <summary Lang=en>
// This tsl creates parent and/or nested shopdrawings of individual or nested items
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "AssemblyShopdrawing")) TSLCONTENT

//endregion		

//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	String sDefault =T("|_Default|");
	String tLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	
	int bLogger = true;
	
	String tDisabled = T("<|Disabled|>"), kParent = "isParent", kAssemblyData="AssemblyData",kBoundary = "Boundary", tDefaultEntry = T("<|Default|>");

// Color and view	
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
	
	int nMode = _Map.getInt("mode");
	String kSubMapXKey = "BatchShopdrawing";
	int bShowDebugLog;
	
	String sAssemblyScripts[] = { "AssemblyDefinition"};
//endregion 	

//region Jigs

// Jig Insert
	String kJigInsert = "jigInsert";
	if (_bOnJig && _kExecuteKey==kJigInsert) 
	{
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point		
		ptJig.setZ(0);
		
	    PlaneProfile pp = _Map.getPlaneProfile("pp");
		pp.transformBy(ptJig - _PtW);

	    Display dp(-1);
	    dp.trueColor(lightblue);
	   	dp.draw(pp, _kDrawFilled, 80);
	   	dp.draw(pp);
	    return;
	}

// Jig Rectangle
	String kJigRectangle = "jigRectangle";
	if (_bOnJig && _kExecuteKey==kJigRectangle) 
	{
	    Point3d pt1 = _Map.getPoint3d("pt1"); 
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point		
		ptJig.setZ(0);
		
	    PlaneProfile pp;
	    pp.createRectangle(LineSeg(pt1, ptJig), _XW, _YW);

	    Display dp(-1);
	    dp.trueColor(lightblue);
	   	dp.draw(pp, _kDrawFilled, 80);
	   	dp.trueColor(darkyellow);
	   	dp.draw(pp);
	    return;
	}


//endregion 

//region Functions #func


//region Function GetPlotPosNum
	// returns the neaxt available plotviewport number
	int GetPlotPosNum()
	{ 	
		Entity ents[] = Group().collectEntities(true, PlotViewport(), _kModelSpace);
		int posnum, posnums[0];
		for (int i=0;i<ents.length();i++) 
		{ 
			PlotViewport pv= (PlotViewport)ents[i]; 
			if (pv.bIsValid())
			{ 
				posnum = pv.posnum();
				if (posnum>0)
					posnums.append(posnum);
			}
		}//next i
		posnums = posnums.sorted();
		
		posnum = 1;
		for (int i=0;i<posnums.length();i++) 
		{ 
			if (posnums.find(posnum)>-1)
				posnum++;
			else
				break;
		}//next i

		return posnum;
	}//endregion

//region Function GetDefiningEntity
	// returns the defining entity of a multipage, if the showset consists only one entity the showset is taken
	Entity GetDefiningEntity(MultiPage page)
	{ 
	// Collect defining entity	
		Entity defineSet[] = page.defineSet();
		Entity showSet[] = page.showSet();
		Entity entDefine;
		if (showSet.length()==1)
			entDefine = showSet.first();
		else if (defineSet.length()>0)	
			entDefine = defineSet.first();		
		return entDefine;
	}//endregion


	//region Function getSegmentsOfMaxLength
	// returns all segments of a planeprofile or those which are <= the given length
	// pp: the planeprofile to analyse
	// maxLength: the max segment length, 0 returns all segments sorted smallest->greatest
	LineSeg[] getSegmentsOfMaxLength(PlaneProfile pp, double maxLength)
	{ 
		LineSeg out[0];
		pp.simplify();
		Point3d pts[] = pp.getGripVertexPoints();
		Vector3d vecZS = pp.coordSys().vecZ();
		for (int i = 0; i < pts.length(); i++)
		{
			Point3d pt1 = pts[i];
			Point3d pt2 = i < pts.length() - 2 ? pts[i + 1] : pts[0];
			LineSeg seg(pt1,pt2);
			if (maxLength==0 || seg.length()<=maxLength)
				out.append(seg);
		}
		
		if (maxLength==0)
		{ 
		// order alphabetically
			for (int i=0;i<out.length();i++) 
				for (int j=0;j<out.length()-1;j++) 
					if (out[j].length()>out[j+1].length())
						out.swap(j, j + 1);
		}
		
		
		return out;

	}//End getSegmentsOfMaxLength //endregion

	//region Function smoothenPlaneProfile
	// returns a smoothened shape by adding rectangles t short segments
	// pp: the planeprofile to analyse
	// maxLength: the max segment length
	void smoothenPlaneProfile(PlaneProfile& pp, double smoothing)
	{ 
		pp.simplify();
		Point3d pts[] = pp.getGripVertexPoints();
		Vector3d vecZS = pp.coordSys().vecZ();
		for (int i=0;i<pts.length();i++) 
		{ 
			Point3d pt0= i>0?pts[i-1]: pts[pts.length()-1];
			Point3d pt1= pts[i]; 
			Point3d pt2= i<pts.length()-2?pts[i+1]: pts[0];
			Point3d pt3= i<pts.length()-3?pts[i+2]: pts[0];
			
			Point3d ptm = (pt1 + pt2) * .5;
			Vector3d vecXS = pt2 - pt1; vecXS.normalize();
			Vector3d vecYS = vecXS.crossProduct(-vecZS);
			if (pp.pointInProfile(ptm+vecYS*dEps)==_kPointInProfile)
				vecYS *= -1;
			
			LineSeg seg(pt1,pt2);
			if (seg.length()<=smoothing)
			{ 
				double d0 = vecYS.dotProduct(pt0 - pt1);
				double d3 = vecYS.dotProduct(pt3 - pt2);
				
				PLine rec;
				if (d0>dEps)
				{ 
					rec.createRectangle(LineSeg(pt2, pt0), vecXS, vecYS);
					pp.joinRing(rec, _kAdd);
				}
				else if (d3>dEps)
				{ 
					rec.createRectangle(LineSeg(pt3, pt1), vecXS, vecYS);
					pp.joinRing(rec, _kAdd);
				}					
				
				if (bDebug){vecYS.vis(ptm, 3);	pt0.vis(0);	pt1.vis(1);	pt2.vis(2);	rec.vis(i);}
				
			}
			
		}//next i
		pp.simplify();
		return ;
	}//End smoothenPlaneProfile //endregion

	//region Function collectTslsByName
	// returns the amount of all tsl instances with a certain scriptname and modifis the input array
	// tsls: the array to search, if empty all tsls in modelspace are taken
	// names: the names of the tsls to be returned
	int getTslsByName(TslInst& tsls[], String names[])
	{ 
		int out;
		
		if (tsls.length()<1)
		{ 
			Entity ents[] = Group().collectEntities(true, TslInst(),  _kModelSpace);
			for (int i=0;i<ents.length();i++) 
			{ 
				TslInst t= (TslInst)ents[i]; 
				//reportNotice("\ngetTslsByName: " + t.scriptName() +" "+names);
				if (t.bIsValid() && names.findNoCase(t.scriptName(),-1)>-1)
					tsls.append(t);
			}//next i
		}
		else
		{ 
			for (int i=tsls.length()-1; i>=0 ; i--) 
			{ 
				TslInst t= (TslInst)tsls[i]; 
				if (t.bIsValid() && names.findNoCase(t.scriptName(),-1)<0)
					tsls.removeAt(i);
			}//next i			
		}
		
		out = tsls.length();
		return out;
	
	}//End collectTslsByName //endregion

	//region Function getMultipageTsls
	// returns the tsls attached to a multipage, optional name filter
	// t: the tslInstance to 
	TslInst[]  getMultipageTsls(MultiPage page, String names[])
	{ 
		TslInst out[0];
		
		Entity ents[] = Group().collectEntities(true, TslInst(),  _kModelSpace);
		for (int i=0;i<ents.length();i++) 
		{ 
			TslInst t= (TslInst)ents[i]; 
			//reportNotice("\ngetTslsByName: " + t.scriptName() +" "+names);
			if (t.bIsValid() && (names.length()<1 || (names.length()>0 && names.findNoCase(t.scriptName(),-1)>-1)))
			{
				Entity entsI[] = t.entity();
				if (entsI.find(page)>-1)
					out.append(t);	
			}
				
		}//next i
		//reportNotice("\ngetMultipageTsls: " + out.length());
		return out;
	}//End getMultipageTsls //endregion

//region Function GetPlotviewRange
	// returns the planeprofile of the plotview range subtracting a potential bref header
	// creates plotviewport and bref
	// layoutName: the name of the layout (mandatory)
	// headerName: the name of the header block (optional)
	// ptIns: the insertion point
	// pt01: the upper left of master
	// pt02: the lower right corner of the master
	// pv: plotviewport
	// bref: the blockref of the header
	PlaneProfile GetPlotviewRange(String layoutName, String headerName, Point3d ptIns, Point3d& pt01, Point3d& pt02, double& dXMaster,double& dYMaster,PlotViewport& pv, BlockRef& bref)
	{ 
		if(bShowDebugLog)reportNotice(TN("     |Adding plotviewport|"));
		PlaneProfile out(CoordSys());
		pv.dbCreate(layoutName, ptIns);
		
		dXMaster = pv.dX();
		dYMaster = pv.dY();	

		out.createRectangle(LineSeg(ptIns, ptIns+_XW*dXMaster+_YW*dYMaster),_XW,_YW);
		Point3d ptm = out.ptMid();
		pt01 = ptm- .5 * (_XW * dXMaster - _YW *dYMaster);	pt01.vis(1);
		pt02 = ptm + .5 * (_XW * dXMaster - _YW * dYMaster);	pt02.vis(2);

	// Create Header BRef
		if (headerName != tDisabled)
		{ 
			CoordSys cs(pt02 , _XW,_YW , _ZW );
			bref.dbCreate(cs, headerName); 
		}

	// subtract extents of blockref
		if (bref.bIsValid())
		{ 		
			Quader qdr = bref.extentsWcs();
			LineSeg seg(qdr.pointAt(-1,-1,-1), qdr.pointAt(1,1,1));			
			PLine rec; rec.createRectangle(seg, _XW, _YW);
			if (rec.area()<out.area())
				out.joinRing(rec, _kSubtract);			
		}

		return out;
	}//endregion

	//region Function getMetalPartEntities
	// appends all entitities of a MetalPartCollectionEnt/Def 
	// ce: the metalpart collection entity
	Entity[] getMetalPartEntities(Entity refCE, Entity& ents[])
	{ 	
		MetalPartCollectionEnt ce = (MetalPartCollectionEnt)refCE;
		if (!ce.bIsValid())
		{ 
			return ents;
		}

		MetalPartCollectionDef cd=ce.definitionObject();//HSB-23092
	
		Beam beams[] = cd.beam();
		Sheet sheets[] = cd.sheet();
		TslInst tsls[] = cd.tslInst();
		Entity entsMP[] = cd.entity();
		
		for (int i=0;i<beams.length();i++) 
			if (!beams[i].bIsDummy() && ents.find(beams[i])<0)
				ents.append(beams[i]);
		for (int i=0;i<sheets.length();i++) 
			if (!sheets[i].bIsDummy() && ents.find(sheets[i])<0)
				ents.append(sheets[i]);
		for (int i=0;i<entsMP.length();i++) 
			if (ents.find(entsMP[i])<0)
				ents.append(entsMP[i]);				
		return ents;
	}//End getMetalPartEntities //endregion

	//region Function getShowsetPlaneProfile
	// returns the plane profile of the showset of a multipage view
	PlaneProfile getShowsetPlaneProfile(MultiPageView view, int bRectangular)
	{ 
		MultiPage page = view.multiPage();	
		CoordSys csp = page.coordSys();
		PlaneProfile out(csp);
		Plane pn(csp.ptOrg(), _ZW);

		Entity showSet[] = view.showSet();
		CoordSys ms2ps = view.modelToView();
		
		//reportNotice("\ngetShowsetPlaneProfile: showSet " + showSet.length());
		for (int i=0;i<showSet.length();i++) 
		{ 
			Entity e = showSet[i];
			GenBeam gb = (GenBeam)e;
			MetalPartCollectionEnt ce = (MetalPartCollectionEnt)e;
			TslInst t = (TslInst)e;
			PlaneProfile pp(csp);
			//reportNotice("\ngetShowsetPlaneProfile: e " + e.handle() + " "+e.typeDxfName());
			if (gb.bIsValid())
			{ 
				 if (gb.bIsDummy()) { continue;}
				 Body bd = gb.envelopeBody(false, true);
				 bd.transformBy(ms2ps);
				 pp.unionWith(bd.shadowProfile(pn));
				 pp.shrink(-dEps);
				 out.unionWith(pp);
			}
			else if (ce.bIsValid())
			{ 
				CoordSys cs =ce.coordSys();
				cs.transformBy(ms2ps);
				
				Entity ents[0];
				ents = getMetalPartEntities(ce, ents);
				//reportNotice("\ngetShowsetPlaneProfile: metalpart ents " + ents.length());
				for (int j = 0; j < ents.length(); j++)
				{
					gb = (GenBeam)ents[j];
					if (gb.bIsDummy()) { continue;}
					Body bd = gb.envelopeBody(false, true);	//bdEnt.vis(40);
					bd.transformBy(cs);
					pp.unionWith(bd.shadowProfile(pn));
					pp.shrink(-dEps);
					out.unionWith(pp);
				}
			
			}
//			else if (t.bIsValid())
//			{ 
//				Display dp(i);
//				dp.draw(t.scriptName(), t.ptOrg(), _XW, _YW, 0, 0);
//			}
//			if (bDebug)
//				pp.vis(i);
			
			
		}
		
		if (bRectangular)
			out.createRectangle(out.extentInDir(_XW), _XW, _YW);
		
//		if (bDebug)
//		{ 
//			Display dp(2);
//			dp.draw(out);
//			out.shrink(dEps);			
//		}

		return out;
	}//End getShowsetPlaneProfile //endregion

	//region Function setBoundingProfile
	// reduces the profile by blowup and shrink until it consists only of one ring
	// pp: the profile to be manipulated
	// margin: the value which will be used as blowup/shrink and as margin, if not given 10mm will be used
	void setBoundingProfile(PlaneProfile& pp, double margin)
	{ 
		double merge = margin > 0 ? margin : U(10);
		PLine rings[] = pp.allRings(true, false);
		
		if (rings.length()==1)
		{ 
			pp.shrink(-margin);
		}

		int attempt = 1, cnt = pp.extentInDir(_XW).length();
		while (rings.length()>1 && cnt>0)
		{ 
			PlaneProfile pp1 = pp;
			pp1.shrink(-attempt * merge);
			pp1.shrink(attempt * merge);
			//pp1.vis(attempt);
			rings = pp1.allRings(true, false);
			if (rings.length()==1)
			{ 
				pp = pp1;
				pp.shrink(-margin);
				break;
			}
			cnt--;
			attempt++;
		}
	
//		if (bDebug)
//		{
//			Display dp(4);
//			dp.draw(pp, _kDrawFilled, 80);
//		}

		return;
	}//End setBoundingProfile //endregion

	//region Function getPageBlockPlaneProfile
	// returns a planeprofile of nested blocks of a multipage
	// t: the tslInstance to 
	PlaneProfile getPageBlockPlaneProfile(MultiPage page, PlaneProfile ppIn)
	{ 	
		CoordSys cs = page.coordSys();
		PlaneProfile out(cs);
		out.unionWith(ppIn);
		out.shrink(-dEps);
	
		String sBlocks[] = page.blocks();
		for (int i=0;i<sBlocks.length();i++) 
		{ 
			Block block(sBlocks[i]);
			
			Entity ents[] = block.entity();
			for (int j=0;j<ents.length();j++) 
			{ 
				CoordSys csb = cs;
				BlockRef bref= (BlockRef)ents[j];
				TslInst t= (TslInst)ents[j];
				//reportNotice("\ngetPageBlockPlaneProfile: " +ents[j].typeDxfName() + " "+ ents.length());
				if (bref.bIsValid())
				{ 
					Block block2(bref.definition());
					LineSeg seg = block2.getExtents();
					csb.transformBy(bref.coordSys());
					seg.transformBy(csb);
					PlaneProfile pp;
					pp.createRectangle(seg, _XW, _YW);
					pp.shrink(-dEps);
					out.unionWith(pp);
				}
				else if (t.bIsValid() && t.scriptName().find("hsbScheduleTable",0,false)>-1)
				{ 
					
					Map m = t.map();
					//reportNotice("\ngetPageBlockPlaneProfile: " +ents[j].typeDxfName() + " "+ ents.length() + " " + t.scriptName() + "\n" + m);
					
					PlaneProfile pp =m.getPlaneProfile("Shape");
					pp.transformBy(cs);
					pp.vis(3);
					out.unionWith(pp);					
				}
				 
			}//next x
		}//next i	
		out.shrink(dEps);
		return out;	
	}///endregion

//region CombinedNesting
	
//region Function RunNester
	void RunNester(NesterCaller& nester, PlaneProfile ppMaster, int& nMasterIndices[], int& nLeftOverChilds[], NesterData nd)
	{ 
		NesterMaster nm(_ThisInst.handle(), ppMaster);
		nester.addMaster(nm);	

		int nSuccess = nester.nest(nd, true);
		if (bDebug)reportMessage("\n\n	NestResult: "+nSuccess);
		if (nSuccess!=_kNROk) 
		{
			reportNotice("\n" + scriptName() + ": " + T("|Not possible to nest|"));
			if (nSuccess==_kNRNoDongle)
				reportNotice("\n" + scriptName() + ": " + T("|No dongle present|"));
			setExecutionLoops(2);
			return;
		}		

		nMasterIndices = nester.nesterMasterIndexes();	
		nLeftOverChilds = nester.leftOverChildIndexes();

		return ;
	}//endregion	
	
//region Function GetGridLocations
	// simplifies the range profile and the grid locations in x and -y
	void GetGridLocations(PlaneProfile& ppx, Point3d& ptsX[], Point3d& ptsY[], int& numX, int& numY)
	{ 
		ppx.simplify();
		Point3d pt=ppx.ptMid();
		CoordSys cs = ppx.coordSys();
		Line lnX(pt, cs.vecX());
		Line lnY(pt, -cs.vecY());
		
		ptsX=ppx.getGripVertexPoints();
		ptsY = lnY.orderPoints(lnY.projectPoints(ptsX), dEps);
		ptsX = lnX.orderPoints(lnX.projectPoints(ptsX), dEps);
		numX = ptsX.length();
		numY = ptsY.length();
		
		return;
	}//endregion			
	
//CombinedNesting //endregion 

	//region Function filterPlotGroup
	// modifies the list of profiles and referenced entities according to the filter
	int filterPlotGroup(String filter, PlaneProfile& pps[], Entity& ents[], String filters[])
	{ 
		PlaneProfile ppsG[0];
		Entity entsG[0];
		
		if (pps.length() != ents.length() || filters.length()!= ents.length())
		{ 
			reportMessage("\n" + scriptName() + ": " +T("|unexpecded error calling| filterPlotGroup:"));
			return;
		}
		for (int i = 0; i < pps.length(); i++)
			if (filters[i] == filter)
			{
				ppsG.append(pps[i]);
				entsG.append(ents[i]);
			}
			
		pps = ppsG;
		ents = entsG;
		
		return ents.length();
	}//End filterPlotGroup //endregion

	//region Function collectUniqueKeys
	// returns a unique string list from a given array
	// t: the tslInstance to 
	String[] collectUniqueKeys(String list[])
	{ 
		String out[0];
		
		for (int i=0;i<list.length();i++) 
		{ 
			String tokens[] = list[i].tokenize("?");
			String token = tokens.length() > 0 ? tokens.first() : "-";
			if (out.findNoCase(token,-1)<0)
				out.append(token);
		}
		
	// order alphabetically
		for (int i=0;i<out.length();i++) 
			for (int j=0;j<out.length()-1;j++) 
				if (out[j]>out[j+1])
					out.swap(j, j + 1);

		return out;
	}//End collectUniqueKeys //endregion

	//region Function orderByHierachy
	// returns modified arrays which are ordered by hierachy and descending child area
	// t: the tslInstance to 
	String[] orderByHierachy(String key, String& filters[], String& tags[], Entity& childs[], PlaneProfile& pps[])
	{ 
		String out[0];

		String _tags[0], _filters[0], _hierarchies[0];
		Entity _childs[0];
		PlaneProfile _pps[0];

		for (int i=0;i<tags.length();i++) 
		{ 
			String tokens[] = tags[i].tokenize("?");
			String token = tokens.length() > 0 ? tokens.first() : "-";
			if (token == key)
			{ 
				String hierarchy = token;
				hierarchy += tokens.length() > 1 ? "_1" : "_0";
				
				double area = U(10e10)-pps[i].area();
				Map m; m.setDouble("smx", area);
				String sArea = _ThisInst.formatObject("@(smx:RL0:PL15;0)", m);
				
				out.append(hierarchy+"?"+sArea);
				_tags.append(tags[i]);
				_pps.append(pps[i]);
				_filters.append(filters[i]);
				_childs.append(childs[i]);
			}
		} 

	// order by hierachy
		for (int i=0;i<_tags.length();i++) 
			for (int j=0;j<_tags.length()-1;j++) 
				if (out[j]>out[j+1])
				{
					out.swap(j, j + 1);
					_tags.swap(j, j + 1);
					_pps.swap(j, j + 1);
					_childs.swap(j, j + 1);	
					_filters.swap(j, j + 1);					
				}		
			

		tags=_tags;
		childs=_childs;
		pps=_pps;
		filters=_filters;


		return out;
	}//End orderByHierachy //endregion
	
	//region Function GetNestedGenbeams
	// returns the tag and the genbeams of a collectionEntity
	GenBeam[] GetNestedGenbeams(Entity e, String& tag)
	{ 
		GenBeam gbs[0];
		
		CollectionEntity ce= (CollectionEntity)e;
		MetalPartCollectionEnt mpce= (MetalPartCollectionEnt)e;
		TrussEntity te= (TrussEntity)e;
		TslInst t = (TslInst)e;
		String def;
		if (mpce.bIsValid())
		{ 
			MetalPartCollectionDef cd = mpce.definitionObject();//HSB-23092
			gbs = cd.genBeam();
		}
		else if (te.bIsValid())
		{ 
			def = te.definition();
			TrussDefinition td(def);
			gbs = td.genBeam();
		}		
		else if (ce.bIsValid())
		{ 
			def = ce.definition();
			CollectionDefinition cd(def);
			gbs = cd.genBeam();
		}	
		else if (t.bIsValid() && t.scriptName().find("AssemblyDefinition",0,false)==0)
		{ 
			def = t.scriptName();
			gbs = t.genBeam();
			Entity _ents[] = t.entity();
			for (int i=0;i<_ents.length();i++) 
			{ 
				GenBeam g= (GenBeam)_ents[i];
				if (g.bIsValid() && gbs.find(g)<0)
					gbs.append(g);
				 
			}//next i
			
		}		
		
		for (int i=gbs.length()-1; i>=0 ; i--) 
			if (gbs[i].bIsDummy())
				gbs.removeAt(i);
		if (tag.length() < 1)tag = def;		
		return gbs;
	}//End GetNestedGenbeams //endregion	
//endregion 

//#Part1 //endregion 

//region Mode 3: Draw Border Mode: an OPM override with limited properties_______________________________________
	if (nMode==3)
	{ 
		setOPMKey("Border");

	//region Properties
		String sMarginName=T("|Margin|");	
		PropDouble dMargin(nDoubleIndex++, U(150), sMarginName);	
		dMargin.setDescription(T("|Defines the margin of the border|"));
		dMargin.setCategory(category);

		String sSmoothingName=T("|Smoothing|");	
		PropDouble dSmoothing(nDoubleIndex++, U(10), sSmoothingName);	
		dSmoothing.setDescription(T("|Defines the the smoothing of the border|"));
		dSmoothing.setCategory(category);	
		
		String sColorName=T("|Color|");	
		PropInt nColor(nIntIndex++, 2, sColorName);	
		nColor.setDescription(T("|Defines the Color|"));
		nColor.setCategory(category);
	//endregion 

	//region Grip Manipulation
		addRecalcTrigger(_kGripPointDrag, "_Grip");	
		_ThisInst.setAllowGripAtPt0(false);
		int indexOfMovedGrip = Grip().indexOfMovedGrip(_Grip);
		Vector3d vecOffsetApplied;
		int bDrag, bOnDragEnd;
		Grip grip;
		if (indexOfMovedGrip>-1)
		{
			bDrag = _bOnGripPointDrag && _kExecuteKey=="_Grip";
			bOnDragEnd = !_bOnGripPointDrag;
			grip=_Grip[indexOfMovedGrip];
			vecOffsetApplied = grip.vecOffsetApplied();
			
		}
	//endregion 


	//region References and defaults
		MultiPage pages[0];
		for (int i=0;i<_Entity.length();i++) 
		{ 
			MultiPage page= (MultiPage)_Entity[i]; 
			if (page.bIsValid())
			{ 
				pages.append(page);
				setDependencyOnEntity(page);
				
			//region Collect potential dimlines to trigger purging of redundant dimlines
				if (!bDrag && _Map.getInt("RemotePurge"))
				{ 
					String names[] = { "DimLine"};
					TslInst tsls[] = getMultipageTsls(page, names);
	
					if (tsls.length()>0)
					{ 
						TslInst& t = tsls.first();
						//reportNotice("\n    trigger remote purge of " + t.handle() + " " + tsls.length()) + " loop " + _kExecutionLoopCount;
						
						Map m = t.map();
						m.setInt("RemotePurge", true);
						t.setMap(m);
						t.transformBy(Vector3d(0, 0, 0));						
					}	
				}
			//endregion 				
			}
		}//next i
		_Map.removeAt("RemotePurge", true);
		
		
		if (pages.length()<1)
		{ 
			eraseInstance();
			return;
		}	
		
		if (_bOnDbCreated)
		{
		// push request on command stack to trigger dimline purging
			_Map.setInt("RemotePurge", true);
			pushCommandOnCommandStack("HSB_RECALC");
 			pushCommandOnCommandStack("(handent \""+_ThisInst.handle()+"\")");	
 			pushCommandOnCommandStack("(Command \"\")");

		}
		if (pages.first().groups().length()>0)
			assignToGroups(pages.first(), 'I');

	//endregion 
	
	//region Transform Set
		PLine plShape = _Map.getPLine("shape");
		if (bOnDragEnd && !vecOffsetApplied.bIsZeroLength())
		{
			Point3d ptFrom = _PtW+_Map.getVector3d("vecOrg");
			Vector3d vec = _Pt0 - ptFrom;
			for (int i=0;i<pages.length();i++) 
				pages[i].transformBy(vecOffsetApplied); 

			if (_Map.hasPLine("shape"))
			{ 
				plShape.transformBy(vecOffsetApplied);
				_Map.setPLine("shape", plShape);
			}


			setExecutionLoops(2);
			return;
		}
	//endregion 

	//region Trigger ResetShape
		int bResetShape;
		String sTriggerResetShape = T("|Reset Shape|");
		addRecalcTrigger(_kContextRoot, sTriggerResetShape );
		if (_bOnRecalc && _kExecuteKey==sTriggerResetShape)
		{
			if (_Map.hasPLine("shape"))
			{ 
				_Map.removeAt("shape", true); // remove custom shape	
				setExecutionLoops(2);
			}

			bResetShape=true;	
			dSmoothing.set(U(300));
		}//endregion	

	//region Collect shape
		PlaneProfile ppBorder(CoordSys());
		if (plShape.area()>pow(U(1),2))
		{ 
			ppBorder.joinRing(plShape,_kAdd);		
		}
		else
		{ 
			for (int j = 0; j < pages.length(); j++)
			{
				MultiPage page = pages[j];
				CoordSys cs = page.coordSys();
				
				PlaneProfile pp(cs);			
				Map m = page.subMapX(kSubMapXKey);
				if (!bDebug && !bResetShape && m.hasPlaneProfile("ppShowSet") && m.hasVector3d("vecOrg"))
				{ 
					pp = m.getPlaneProfile("ppShowSet");				
					pp.transformBy(cs.ptOrg() - ( _PtW + m.getVector3d("vecOrg")));
				}
				
				if (pp.area()<pow(dEps,2))
				{ 
					Entity showSetPage[] = page.showSet();
					MultiPageView views[] = page.views();
					for (int v=0;v<views.length();v++) 
					{
						pp.unionWith(getShowsetPlaneProfile(views[v], true));
					}
					pp = getPageBlockPlaneProfile(page, pp);
					
					//m = page.subMapX(kSubMapXKey);
				
				// update shape
					if (pp.allRings().length()>0)
					{ 
						m.setPlaneProfile("ppShowSet", pp);
						m.setVector3d("vecOrg", cs.ptOrg() - _PtW);
						page.setSubMapX(kSubMapXKey,m);
					}
					
				}
				ppBorder.unionWith(pp);
				
			}			
		
			setBoundingProfile(ppBorder, dMargin);
		}

		if (_bOnDbCreated)
			_Pt0 = ppBorder.ptMid() - .5 * (_XW * ppBorder.dX() + _YW * ppBorder.dY());
		_Pt0 = ppBorder.closestPointTo(_Pt0);
		_Map.setVector3d("vecOrg", _Pt0 - _PtW);
	//endregion 


	PlaneProfile ppMax; ppMax.createRectangle(ppBorder.extentInDir(_XW), _XW, _YW);
	PlaneProfile ppMax2 = ppMax;
	ppMax2.shrink(-U(300));
	ppMax2.subtractProfile(ppMax);
	//{Display dpx(1); dpx.draw(ppMax2, _kDrawFilled,20);}


	//region Smoothen and Draw
		Display dp(nColor);
		if (dSmoothing>0)
		{ 
			LineSeg segs[] = getSegmentsOfMaxLength(ppBorder, dSmoothing);
			int cnt;
			while (cnt < 100 && segs.length() > 0)
			{
				smoothenPlaneProfile(ppBorder, dSmoothing);
				segs = getSegmentsOfMaxLength(ppBorder, dSmoothing);
				cnt++;
				
				PlaneProfile ppx = ppBorder;
				if(ppx.intersectWith(ppMax2))
				{ 
					ppBorder = ppMax;
					break;
				}
			}
		}
		
		if (bDrag)
		{
			ppBorder.transformBy(vecOffsetApplied);
			dp.trueColor(lightblue);
			dp.draw(ppBorder,_kDrawFilled, 80);
		}	

		dp.draw(ppBorder);
	//endregion 


	//region Grips
		_Grip.setLength(0);
		Point3d pts[] = ppBorder.getGripVertexPoints();
		for (int i=0;i<pts.length();i++) 
		{ 		
			Point3d pt = pts[i]; 
			Grip g;
			g.setPtLoc(pt);
			g.setVecX(_XW);
			g.setVecY(_YW);			
			g.addHideDirection(_XW);
			g.addHideDirection(-_XW);
			g.addHideDirection(_YW);
			g.addHideDirection(-_YW);			
			g.setColor(4);
			g.setShapeType(_kGSTCircle);
			g.setName("grip" + i);
			g.setToolTip(T("|Moves the boundary to a new location|"));
			_Grip.append(g); 			 
		}//next i
		
	//endregion 


	//region Trigger Smoothen
		


		String sTriggerSmoothen = T("|Smoothen (Double Click)|");
		if (ppMax.area()>=ppBorder.area()+pow(U(1),2)) // HSB-22965 smoothening limited to bounding rectangle
		{
			addRecalcTrigger(_kContextRoot, sTriggerSmoothen);
			if (_bOnRecalc && (_kExecuteKey==sTriggerSmoothen || _kExecuteKey==sDoubleClick))
			{
				LineSeg segs[] = getSegmentsOfMaxLength(ppBorder, 0);
				for (int i = 0; i < segs.length(); i++)
				{
					if (segs[i].length() > dSmoothing)
					{
						dSmoothing.set(segs[i].length());
						break;
					}
				}
				setExecutionLoops(2);
				return;
			}		
		}//endregion	


		//region Trigger SpecifyRectangle
			String sTriggerSpecifyRectangle = T("|Specify Rectangle|");
			addRecalcTrigger(_kContextRoot, sTriggerSpecifyRectangle );
			if (_bOnRecalc && _kExecuteKey==sTriggerSpecifyRectangle)
			{
				Point3d pt2,pt1 = getPoint(T("|Pick first point of rectangle|"));
				pt1.setZ(0);
			//region PrPoint with Jig
			
				PrPoint ssP(T("|Pick second point of rectangle|"), pt1); // second argument will set _PtBase in map
			    Map mapArgs;
			   	mapArgs.setPoint3d("pt1", pt1);
			    int nGoJig = -1;
			    while (nGoJig != _kOk && nGoJig != _kNone)
			    {
			        nGoJig = ssP.goJig(kJigRectangle, mapArgs); 
			        if (bDebug)reportMessage("\ngoJig returned: " + nGoJig);
			        
			        if (nGoJig == _kOk)
			        {
			            pt2 = ssP.value(); //retrieve the selected point
			        }
			        else if (nGoJig == _kCancel)
			        { 
			            return; 
			        }
			    }			
			//endregion 
				
				LineSeg seg(pt1, pt2);
				if (seg.length()>dEps)
				{ 
					PLine pl;
					pl.createRectangle(seg, _XW, _YW);
					_Map.setPLine("shape", pl);
				}
				
				setExecutionLoops(2);
				return;
			}//endregion	
		



		return;
	}
//endregion 

//region #Part2

//region Painter Collections
	String sPainterCollection = "AssemblyShopdrawing\\";
	String sPainters[0],sAllPainters[] = PainterDefinition().getAllEntryNames().sorted();
	for (int i=0;i<sAllPainters.length();i++) 
	{ 
		if (sAllPainters[i].find(sPainterCollection,0,false)==0)
		{
			String s = sAllPainters[i];
			s = s.right(s.length() - sPainterCollection.length());
			if (sPainters.findNoCase(s,-1)<0)
				sPainters.append(s);
		}		 
	}//next i
	int bFullPainterPath = sPainters.length() < 1;
	if (bFullPainterPath)
	{ 
		for (int i=0;i<sAllPainters.length();i++) 
		{ 
			String s = sAllPainters[i];
			if (sPainters.findNoCase(s,-1)<0)
				sPainters.append(s);
		}//next i		
	}
	else
		sPainters.insertAt(0, sPainterCollection);	// add collection to execute multiple painters
	sPainters.insertAt(0, tDisabled);
	String sPainterDesc = T(" |If a painter collection named 'AssemblyShopdrawing' is found only painters of this collection are considered.|");
//endregion 

//region MultiPage Styles
	String sStyles [] = MultiPageStyle().getAllEntryNames().sorted();	
	if (sStyles.length()<1)
	{ 
		reportNotice(TN("|No multipage styles found in this drawing|"));
		eraseInstance();
		return;
	}
	String sCEStyles[] ={ tDisabled};
	String sTSLStyles[] ={ tDisabled};
	String sGBStyles[] ={ tDisabled};
	for (int i=0;i<sStyles.length();i++) 
	{ 
		MultiPageStyle mps(sStyles[i]); 
		int type =mps.objectCollectionType(); 
		if (type==_kOCTMetalPartCollectionEnt)
			sCEStyles.append(sStyles[i]);
		else if (type==_kOCTTslDefined)
			sTSLStyles.append(sStyles[i]);	
		else if (type==_kOCTIndividualShopDrawing)
			sGBStyles.append(sStyles[i]);				
	}//next i	
	
//endregion 

//region Properties
category = T("|Collection Styles|");
	String sStyleName=T("|Metalpart Style|");	
	PropString sStyleCE(0,sCEStyles, sStyleName);	
	sStyleCE.setDescription(T("|Defines the multipage style of the parent object|"));
	sStyleCE.setCategory(category);
	
	String tCreateNested = T("|Create Nested|"), tOnlyNested = T("|Only Nested|");
	String sCreatedNestings[] = { tDisabled, tCreateNested, tOnlyNested};
	String sCreateNestedCEName=T("|Metalpart Nestings|");	
	PropString sCreateNestedCE(8, sCreatedNestings, sCreateNestedCEName);	
	sCreateNestedCE.setDescription(T("|Defines if the child entities of a metalpart collection will also create their defining individual shopdrawings|"));
	sCreateNestedCE.setCategory(category);

	String sStyleAssemblyName=T("|Assembly-TSL Style|");	
	PropString sStyleAssembly(9,sTSLStyles, sStyleAssemblyName);	
	sStyleAssembly.setDescription(T("|Defines the multipage style of the parent tsl assembly object|"));
	sStyleAssembly.setCategory(category);

	String sCreatedAssemblyNestings[] = { tDisabled, tCreateNested, tOnlyNested};
	String sCreateNestedAssemblyName=T("|Assembly Nestings|");	
	PropString sCreateNestedAssembly(10, sCreatedNestings, sCreateNestedAssemblyName);	
	sCreateNestedAssembly.setDescription(T("|Defines if the child entities of a tsl based assembly will also create their defining individual shopdrawings|"));
	sCreateNestedAssembly.setCategory(category);


category = T("|Individual Styles|");
	String sStyleBeamName=T("|Beam|");	
	PropString sStyleBeam(1,sGBStyles , sStyleBeamName);	
	sStyleBeam.setDescription(T("|Defines the multipage style for entities of type beam|"));
	sStyleBeam.setCategory(category);

	String sStyleSheetName=T("|Sheet|");	
	PropString sStyleSheet(2,sGBStyles , sStyleSheetName);	
	sStyleSheet.setDescription(T("|Defines the multipage style for entities of type sheet|"));
	sStyleSheet.setCategory(category);

	String sStylePanelName=T("|Panel|");	
	PropString sStylePanel(3,sGBStyles , sStylePanelName);	
	sStylePanel.setDescription(T("|Defines the multipage style for entities of type panel|"));
	sStylePanel.setCategory(category);

	String sGenbeamPainterName=T("|Filter|");	
	PropString sGenbeamPainter(13, sPainters, sGenbeamPainterName);	
	sGenbeamPainter.setDescription(T("|Defines the painter definition to filter entities of the individual styles|") +sPainterDesc );
	sGenbeamPainter.setCategory(category);
	int nPainterGb = sPainters.find(sGenbeamPainter);
	if (nPainterGb<0)
	{
		nPainterGb=0;
		sGenbeamPainter.set(sPainters[nPainterGb]);
	}
	String sPainterGenbeamDef = bFullPainterPath ? sGenbeamPainter : sPainterCollection + sGenbeamPainter;	


category = T("|Filter + Grouping|");
	String sPainterName=T("|Painter|");	

	String sAllowNestedName=T("|Allow selection in XRef|");	
	PropString sAllowNested(12, sNoYes, sAllowNestedName,0);	
	sAllowNested.setDescription(T("|Defines whether the selection of entities also allows entities within block references or XRefs|"));
	sAllowNested.setCategory(category);
	if (sNoYes.findNoCase(sAllowNested ,- 1) < 0) sAllowNested.set(sNoYes[0]);

	PropString sPainter(4, sPainters, sPainterName);	
	sPainter.setDescription(T("|Defines the painter definition to filter entities|") +sPainterDesc );
	sPainter.setCategory(category);
	int nPainter = sPainters.find(sPainter);
	if (nPainter<0){ nPainter=0;sPainter.set(sPainters[nPainter]);}
	String sPainterDef = bFullPainterPath ? sPainter : sPainterCollection + sPainter;

	String tAscending = T("|Ascending|"), tDescending = T("|Descending|"), sSortDirections[] ={ tAscending, tDescending};
	String sSortDirectionName=T("|Sort Direction|");	
	PropString sSortDirection(11,sSortDirections, sSortDirectionName);	
	sSortDirection.setDescription(T("|Defines the Sorting Direction|"));
	sSortDirection.setCategory(category);
//
//	String tBySize = T("|bySize|"), tByPainter = T("|byPainter|"), sStrategies[] ={ tByPainter,tBySize};
//	String sStrategyName=T("|Strategy|");	
//	PropString sStrategy(12, sStrategies, sStrategyName);	
//	sStrategy.setDescription(T("|Defines the Strategy|"));
//	sStrategy.setCategory(category);
	
	String sMarginName=T("|Margin|");	
	PropDouble dMargin(nDoubleIndex++, U(150), sMarginName);	
	dMargin.setDescription(T("|Defines the margin of the border embracing the grouped subset|"));
	dMargin.setCategory(category);

	String sSmoothingName=T("|Smoothing|");	
	PropDouble dSmoothing(nDoubleIndex++, U(400), sSmoothingName);	
	dSmoothing.setDescription(T("|Defines the the smoothing of the border|"));
	dSmoothing.setCategory(category);

	String sColorName=T("|Color|");	
	PropInt nColor(nIntIndex++, 2, sColorName);	
	nColor.setDescription(T("|Defines the color of the embracing border|"));
	nColor.setCategory(category);


category = T("|Plot Viewport|");
	String sLayouts[] = Layout().getAllEntryNames().sorted();
	sLayouts.insertAt(0, tDisabled);
	String sLayoutName=T("|Layout|");	
	PropString sLayout(5, sLayouts, sLayoutName);	
	sLayout.setDescription(T("|Defines the Layout which is used to create plot viewports.|") + T("|The selection of the layout is mandatory if nested shopdrawings are to be created.|"));
	sLayout.setCategory(category);
	if (sLayouts.findNoCase(sLayout ,- 1) < 0)sLayout.set(tDisabled);
	//sLayout.setReadOnly(nMode==2?0:true);

	String sFormatPlotViewportName=T("|Format|");	
	PropString sFormatPlotViewport(7, "@(Definition:D)@(PosNum:D)", sFormatPlotViewportName);	
	sFormatPlotViewport.setDescription(T("|Defines the format of the plot viewport|"));
	sFormatPlotViewport.setCategory(category);

	String sBlockNames[0]; 
//	if (!bDebug || _bOnInsert)
		sBlockNames = _BlockNames.sorted();
	for (int i=sBlockNames.length()-1; i>=0 ; i--) 
		if (sBlockNames[i].left(1)=="*")
			sBlockNames.removeAt(i); 
	sBlockNames.insertAt(0, tDisabled);		
	String sHeaderName=T("|Title Block|");	
	PropString sHeader(6,sBlockNames, sHeaderName);	
	sHeader.setDescription(T("|Specifies the block that will be utilized for the presentation of the page header.|"));
	sHeader.setCategory(category);


	
//End Properties//endregion 

//region bOnInsert
	if (_bOnInsert)
	{
		if (insertCycleCount() > 1) { eraseInstance(); return; }
		
		// silent/dialog
		if (_kExecuteKey.length() > 0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			if (sEntries.findNoCase(_kExecuteKey ,- 1) >- 1)
				setPropValuesFromCatalog(_kExecuteKey);
			else
				setPropValuesFromCatalog(tLastInserted);
		}
		// standard dialog	
		else
			showDialog();
	
	
	// invalid properties selected
		if (sStyleCE == tDisabled && sStyleBeam == tDisabled && 
			sStyleSheet == tDisabled && sStylePanel == tDisabled && sStyleAssembly == tDisabled)
		{
			reportNotice(TN("|At least one of the types must use a valid multipage style.|"));
			eraseInstance();
			return;
		}
		
	// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select entities|"), MetalPartCollectionEnt());
		if (sAllowNested==sNoYes[1])// HSB-22965 // HSB-23092
			ssE.allowNested(true); 
		
		if (sStyleBeam != tDisabled)ssE.addAllowedClass(Beam());
		if (sStyleSheet != tDisabled)ssE.addAllowedClass(Sheet());
		if (sStylePanel != tDisabled)ssE.addAllowedClass(Sip());
		if (sStyleAssembly != tDisabled)ssE.addAllowedClass(TslInst());
		ssE.addAllowedClass(MultiPage());
		ssE.addAllowedClass(PlotViewport());
		ssE.addAllowedClass(BlockRef());
		if (ssE.go())
			ents.append(ssE.set());
	
	//region Filter only expected assembly TSL's'
		if (sStyleAssembly != tDisabled)
		{
			for (int i=ents.length()-1; i>=0 ; i--) 
			{ 
				TslInst t=(TslInst)ents[i]; 
				if (t.bIsValid() && sAssemblyScripts.findNoCase(t.scriptName(),-1)<0)
					ents.removeAt(i);
			}//next i
		}
	//endregion 
	
	
	

	// Avoid mixed mode insertion		
		MultiPage pages[0];
		BlockRef brefs[0];
		PlotViewport pvs[0];
		for (int i=0;i<ents.length();i++) 
		{ 
			MultiPage page = (MultiPage)ents[i]; 
			PlotViewport pv = (PlotViewport)ents[i]; 
			BlockRef bref = (BlockRef)ents[i]; 
			if (page.bIsValid())
				pages.append(page);
			else if (pv.bIsValid())
				pvs.append(pv);	
			else if (bref.bIsValid())
				brefs.append(bref);					
			else
				_Entity.append(ents[i]);
		}//next i
		
		if (_Entity.length()>0)
		{
			//if (bShowDebugLog)reportMessage("\n"+_Entity.length() + " _Entities collected");
			_Map.setInt("mode", 1);
		}
		else if (pages.length()>0)
		{ 
			for (int i=0;i<pages.length();i++)
				_Entity.append(pages[i]);
			_Map.setInt("mode", 2);
			_Map.setInt("renest", true);
		}
		else
		{ 
			reportNotice(TN("|This tool requires at least one genbeam, collection entity or a multipage in the selection set.|"));
			eraseInstance();
			return;
		}
	
		
	//region Get preview range
		if (sLayout!=tDisabled)
		{ 
			Point3d pt01, pt02, ptIns=_PtW;
			double dX, dY;
			PlotViewport pv;
			BlockRef bref;
			PlaneProfile ppPreview = GetPlotviewRange(sLayout, sHeader, ptIns, pt01, pt02, dX, dY, pv, bref);
			if (pv.bIsValid())pv.dbErase();
			if (bref.bIsValid())bref.dbErase();
	
		//region Show Jig
			PrPoint ssP(T("|Select insertion point|")); // second argument will set _PtBase in map
		    Map mapArgs;
		   	mapArgs.setPlaneProfile("pp", ppPreview);
		    int nGoJig = -1;
		    while (nGoJig != _kOk && nGoJig != _kNone)
		    {
		        nGoJig = ssP.goJig(kJigInsert, mapArgs); 
		        if (bDebug)reportMessage("\ngoJig returned: " + nGoJig);
		        
		        if (nGoJig == _kOk)
		        {
		            Point3d pt = ssP.value(); //retrieve the selected point
		            pt.setZ(0);
		            _Pt0=pt; //append the selected points to the list of grippoints _PtG
		        }
//		        else if (nGoJig == _kKeyWord)
//		        { 
//		            if (ssP.keywordIndex() == 0)
//		                mapArgs.setInt("isLeft", TRUE);
//		            else 
//		                mapArgs.setInt("isLeft", FALSE);
//		        }
		        else if (nGoJig == _kCancel)
		        { 
		            eraseInstance(); // do not insert this instance
		            return; 
		        }
		    }			
		//End Show Jig//endregion 

		}
	// preview size unkown	
		else
		{
			_Pt0 = getPoint();
		}
	//endregion 		

		
		
	//Purge potential plotviewports and bref if in selection set	
		if (pages.length()>0)
		{ 

		// erase BatchShopdrawing tsl's attached to any page
			String names[] = { "BatchShopdrawing"};
			TslInst tsls[0];
			int num =  getTslsByName(tsls, names);	
			for (int i=tsls.length()-1; i>=0 ; i--) 
			{ 
				int bErase;
				TslInst t = tsls[i];
				if (t==_ThisInst){ continue;}
				Entity ents[] = t.entity();
				for (int j=0;j<pages.length();j++) 
				{ 
					if (ents.find(pages[j])>-1)
					{
						bErase = true;
						break;
					} 
				}//next j
				if (bErase)
				{
					if (bShowDebugLog)reportNotice(TN("|Purging| ") + t.scriptName());				
					t.dbErase();
				}
				 
			}//next i
			
			
			
			
			
			
			for (int i=pvs.length()-1; i>=0 ; i--) 
				pvs[i].dbErase();
			for (int i=brefs.length()-1; i>=0 ; i--) 
			{
				BlockRef& bref = brefs[i];
				if (bref.bIsValid() && sHeader.find(bref.definition(), 0, false)>-1)
					bref.dbErase();				
			}				
		}		
		
		
		return;
	}	
// end on insert	__________________//endregion

//region Standards
	
	Point3d ptRef = _Pt0;
	CoordSys cs(ptRef, _XW, _YW, _ZW);

	Display dp(1);
	dp.textHeight(U(80));
	
	int bIsParent = _Map.getInt(kParent);
	MultiPageStyle style(sStyleCE);
	String sChildStyles[0];
	if (sChildStyles.findNoCase(sStyleBeam)<0)
		sChildStyles.append(sStyleBeam);
	if (sChildStyles.findNoCase(sStyleSheet)<0)
		sChildStyles.append(sStyleSheet);	
	if (sChildStyles.findNoCase(sStylePanel)<0)
		sChildStyles.append(sStylePanel);			
//endregion 

//#Part2 //endregion 

//region #Part3

//region Mode 1: Multipage Creation Mode
	if (nMode==1)
	{ 
		//bDebug = true;
		int bCreateNestedCE = sCreateNestedCE == tCreateNested || sCreateNestedCE == tOnlyNested;
		int bCreateCE = sCreateNestedCE != tOnlyNested;
		
		int bCreateNestedTslAssembly = sCreateNestedAssembly == tCreateNested || sCreateNestedAssembly == tOnlyNested;
		int bCreateTslAssembly = sCreateNestedAssembly != tOnlyNested;
		
	//region Filter entities	
		Entity 	ents[0];
		String tags[0],filters[0]; //must be in synch with ents
		if (nPainter>0)
		{ 
			
			String sMyPainters[0];
			if (sPainter == sPainterCollection && sPainters.length()>2)
			{ 
				for (int i=0;i<sPainters.length();i++) 
				{ 
					String& s = sPainters[i]; 
					if (s!=tDisabled && s!=sPainterCollection)
						sMyPainters.append(s);
				}//next i
			}
			else
				sMyPainters.append(sPainter);
			
			
			
		// loop painters (could be multiple if parent folder / PainterCollection selected)	
			for (int j=0;j<sMyPainters.length();j++) 
			{ 
				String sPainterDef = bFullPainterPath ? sMyPainters[j] : sPainterCollection + sMyPainters[j]; 
				
				PainterDefinition pd(sPainterDef);
				String type = pd.type();
				String ftr = pd.formatToResolve();

				Entity entsPD[] = pd.filterAcceptedEntities(_Entity);				
				
			// order by grouping					
			// collect unique tags
				for (int i=entsPD.length()-1; i>=0 ; i--) 
				{ 
					Entity& e = entsPD[i];
					String tag;
					if (ftr.length()>0 && ftr.find("@(",0, false)>-1)
						tag = e.formatObject(ftr);
					else // no grouping defined
						tag = e.uniqueId();	

					if (tags.findNoCase(tag,-1)<0 && ents.find(e)<0)
					{
						ents.append(e);
						tags.append(tag);
						filters.append(sPainterDef);
					}
					else
						entsPD.removeAt(i);
				}//next i
					
			}//next j
			
		// order by tag
			for (int i=0;i<tags.length();i++) 
				for (int j=0;j<tags.length()-1;j++) 
				{
					String s1 = filters[j] + tags[j];
					String s2 = filters[j+1] + tags[j+1];
					if (s1>s2)
					{
						ents.swap(j, j + 1);
						tags.swap(j, j + 1);
						filters.swap(j, j + 1);
					}						
				}


			if (ents.length()<1)
			{ 
				reportNotice("\n" + "*** " + scriptName() + " ***" +
					TN("|The selected painter does return any item of the current selection set.|") + 
					TN("|You might want to try with a different selection set and/or with a different painter definition.|"));	
				if (bDebug)
				{ 
					String text = scriptName();
					for (int i=0;i<_Entity.length();i++) 
					{ 
						Entity e = _Entity[i]; 
						text+="\n"+e.typeDxfName(); 
					}//next i
					
					dp.draw(text, _Pt0, _XW, _YW, 1, 0);
				}
				else
					eraseInstance();
				return;
			}


		// sort descending			
			if (sSortDirection==tDescending)
			{ 
				ents.reverse();
				tags.reverse();
				filters.reverse();
			}			

			reportNotice("\n" + "*** " + scriptName() + T(" *** |working on| ") + ents.length() + T(" |entities|"));

	
		}
		else
		{
			ents = _Entity;
			for (int i=0;i<ents.length();i++) 
			{	
				tags.append(ents[i].handle());
				filters.append("");
			}
		}
	//endregion 	

	//region Refuse entities to which no style has been selected
		for (int i=ents.length()-1; i>=0 ; i--) 
		{ 
			Entity& e= ents[i]; 
			MetalPartCollectionEnt ce= (MetalPartCollectionEnt)e;
			Beam bm = (Beam)e;
			Sheet sh= (Sheet)e;
			Sip sip= (Sip)e;
			
			if ((ce.bIsValid() && sStyleCE== tDisabled) || 
				(bm.bIsValid() && sStyleBeam== tDisabled)  ||  
				(sh.bIsValid() && sStyleSheet== tDisabled) ||
				(sip.bIsValid() && sStylePanel== tDisabled) ) 
			{
				ents.removeAt(i);
				tags.removeAt(i);
				filters.removeAt(i);
			}				
		}//next i			
	//endregion 




	//region Get parent entities such as collectionEntity to collect potential childs
		Entity entsTemp[0]; entsTemp =ents;		
		for (int i=0;i<entsTemp.length();i++) 
		{ 
			Entity& e= entsTemp[i]; 
			//reportNotice("\nGet parent ents of " + e.formatObject("@(scriptName:D)@(definition:D)") + " creation CE-TSL " +sChildStyles + " " + bCreateNestedCE+"-"+bCreateNestedTslAssembly);
			//MetalPartCollectionEnt ce= (MetalPartCollectionEnt)e;
			CollectionEntity ce= (CollectionEntity)e;
			TslInst tsl = (TslInst)e;
			String tag = tags[i];
			String filter = filters[i];

			GenBeam gbs[0];
			
			if (sChildStyles.length()>0 && bCreateNestedCE && ce.bIsValid())//ce.bIsValid() && 
				gbs = GetNestedGenbeams(e, tag);
			else if (sChildStyles.length()>0 && bCreateNestedTslAssembly && tsl.bIsValid())
				gbs = GetNestedGenbeams(e, tag);
			//reportNotice("...collected " + gbs.length());


			if (nPainterGb>0)
			{ 
				int n = gbs.length();
				PainterDefinition pd(sPainterGenbeamDef);
				gbs = pd.filterAcceptedEntities(gbs);
				//reportNotice("\nSubset CE/TSL " + gbs.length() +"/"+n);
			}
			
			for (int j=0;j<gbs.length();j++) 
			{ 
				GenBeam& g = gbs[j];
				
				int pos = g.posnum();
				String tagC = pos < 1 ? g.handle() : pos;
				tagC = tag + "?" + g.typeDxfName()+"?" + tagC;
				//reportNotice("\nLooping parent genbeam " + g.formatObject("@(posnum:D) @(typeName:D)"));
				Beam bm= (Beam)g;
				if (bm.bIsValid() && sStyleBeam!=tDisabled && ents.find(bm)<0 && tags.findNoCase(tagC)<0)
				{ 
					MultiPageStyle mps(sStyleBeam);
					if (mps.objectCollectionType()!=_kOCTIndividualShopDrawing){ continue;}
					ents.append(bm);
					tags.append(tagC);
					filters.append(filter);
					continue;
				}
				
				Sheet sh= (Sheet)g;
				if (sh.bIsValid() && sStyleSheet!=tDisabled  && ents.find(sh)<0 && tags.findNoCase(tagC)<0)
				{ 
					MultiPageStyle mps(sStyleSheet);
					if (mps.objectCollectionType()!=_kOCTIndividualShopDrawing){ continue;}
					ents.append(sh);
					tags.append(tagC);
					filters.append(filter);
					continue;
				}
				
				Sip sip= (Sip)g;
				if (sip.bIsValid() && sStylePanel!=tDisabled  && ents.find(sip)<0 && tags.findNoCase(tagC)<0)
				{ 
					MultiPageStyle mps(sStylePanel);
					if (mps.objectCollectionType()!=_kOCTIndividualShopDrawing){ continue;}
					ents.append(sip);
					tags.append(tagC);
					filters.append(filter);
					continue;
				}		
				
			}//next j			
			
			
		}//next i
		//reportNotice("\nents/Temp" + entsTemp.length() + "__" + ents.length());
		
		
	// remove collection entities or assembly tsls if selected
		for (int i=entsTemp.length()-1; i>=0 ; i--) 
		{ 
			Entity e=entsTemp[i]; 
			CollectionEntity ce= (CollectionEntity)e;
			TslInst tsl= (TslInst)e;
			int n = ents.find(e);
			
			if (n>-1 && (!bCreateCE && ce.bIsValid()) || 
			(!bCreateTslAssembly && tsl.bIsValid()) )
			{ 
				//reportNotice("\nRemove of " + e.formatObject("@(scriptName:D)@(definition:D)@(Handle)") + " at n="+n);
				ents.removeAt(n);
				tags.removeAt(n);
				filters.removeAt(n);	
				
				entsTemp.removeAt(i);
			}	
		}//next i			

	
	// reorder if new entries have been appended
		if (ents.length()>entsTemp.length() && nPainter>0)
		{ 
			for (int i=0;i<tags.length();i++) 
				for (int j=0;j<tags.length()-1;j++) 
				{
					String s1 = filters[j] + tags[j];
					String s2 = filters[j+1] + tags[j+1];
					if (s1>s2)
					{
						ents.swap(j, j + 1);
						tags.swap(j, j + 1);
						filters.swap(j, j + 1);
					}					
					
				}
		// sort descending			
			if (sSortDirection==tDescending)
			{ 
				ents.reverse();
				tags.reverse();
				filters.reverse();
			}			
		}
	
	//endregion 

	//region Create pages and corresponding TSL
		MultiPage pages[0];

		TslInst tslNew;
		GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
		int nProps[]={nColor};			double dProps[]={dMargin,dSmoothing};				
		String sProps[]={sStyleCE,sStyleBeam, sStyleSheet, sStylePanel, sPainter,
			sLayout,sHeader,sFormatPlotViewport,sCreateNestedCE,sStyleAssembly, 
			sCreateNestedAssembly,sSortDirection,sAllowNested,sGenbeamPainter};

		Map mapTsl;	

		String myStyle = sStyleCE;	
		
	// Create a tsl instance and a corresponding page
		String text = scriptName();
		Point3d pt = _Pt0;
		if (sLayout!=tDisabled)
			pt += (_XW + _YW ) * dMargin;
			
		String myStyles[] ={ sStyleCE, sStyleBeam, sStyleSheet, sStylePanel, sStyleAssembly};
		for (int i=0;i<ents.length();i++) 
		{ 
			
			Entity& e = ents[i]; 
			MultiPage page;

			//reportNotice("\nCreate Page for " + e.formatObject("@(scriptName:D)@(definition:D)@(Handle)"));


			CoordSys csPage(pt, _XW, _YW, _ZW);
			
			for (int j=0;j<myStyles.length();j++) 
			{ 
				String style = myStyles[j]; 
				if (style == tDisabled) { continue;}
				sProps[0] = tDisabled;//ce
				sProps[1] = tDisabled;//beam
				sProps[2] = tDisabled;//sheet
				sProps[3] = tDisabled;//panel
				sProps[11] = tDisabled;//panel
				sProps[j] = style;
				
				MultiPageStyle mps(style);//HSB-18906 catching objectCollectionType on creation for hsbDesign25
				
			//region the referenced Entity
				Entity x;
				MetalPartCollectionEnt ce= (MetalPartCollectionEnt)e;
				Beam bm = (Beam)e;
				Sheet sh = (Sheet)e;
				Sip sip = (Sip)e;
				TslInst tsl = (TslInst)e;
				
				if (j==0 && ce.bIsValid())
					x = ce;
				else if (j==1 && bm.bIsValid())
					x = bm;
				else if (j==2 && sh.bIsValid())
					x = sh;
				else if (j==3 && sip.bIsValid())
					x = sip;
				else if (j==4 && tsl.bIsValid())
					x = sip;					
				else
				{
					continue;
				}
				
				
				if (x.bIsValid() && style != tDisabled)
				{ 
					
				// Create Multipage
					Entity defines[] ={ x};
					
					if (defines.length() > 0)
					{	
						if (!bDebug)
							page.dbCreate(csPage, style, defines, mps.objectCollectionType());//HSB-18906 catching objectCollectionType on creation for hsbDesign25
						else
							text += "\n"	+ style + " " + x.typeName() + " "+ x.handle() + " " + tags[i] + " " + filters[i];
						if (page.bIsValid())
						{					
						// add subMapX
							Map m;
							m.setString("Filter", filters[i]);
							m.setString("Tag", tags[i]);
							// cannot store entity dependent data like planeprofile at this stage
							page.setSubMapX(kSubMapXKey, m);
//							page.regenerate();
							pages.append(page);

							pt += _XW * U(4000); // dummy value
						}
					}	
					continue;
				}					
			//endregion 					 
			}//next j
		}//next i

	//endregion 

		if (pages.length()>0) // alter mode and references for plot viewport creation
		{ 
			reportNotice("\n    " + pages.length() +T(" |multipages created.|"));
			_Entity.setLength(0);
			for (int i=0;i<pages.length();i++) 
			{
				_Entity.append(pages[i]); 
				pages[i].regenerate();
			}


//			nMode = 2;
//			_Map.setInt("mode", nMode);
//			setExecutionLoops(2);

			TslInst tslNew;
			GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
			int nProps[]={nColor};			double dProps[]={dMargin,dSmoothing};				

			String sProps[]={sStyleCE,sStyleBeam, sStyleSheet, sStylePanel, sPainter,
			sLayout,sHeader,sFormatPlotViewport,sCreateNestedCE,sStyleAssembly, 
			sCreateNestedAssembly,sSortDirection,sAllowNested,sGenbeamPainter};
			
			Map mapTsl;	
			entsTsl = _Entity;
			mapTsl.setInt("mode", 2);
			
			if (bDebug)
			{ 
				sPainter.set(tDisabled); // the painter property would erase the instance as it finds only multipages
				dp.draw(scriptName() , _Pt0, _XW, _YW, 1, -1);
			}
			else
			{
				tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
				eraseInstance();
			}
			
			//if (tslNew.bIsValid())
				
			return;
		}
		else if (bDebug)
		{
			dp.draw(text , _Pt0, _XW, _YW, 1, -1);
			return;
		}
		else
		{ 
			reportNotice(TN("|No multipages have been created.|"));
			eraseInstance();
			return;
		}
	}
//END Multipage Creation Mode //endregion 

//region Get References			
	MetalPartCollectionEnt ce;
	Sheet sh; 
	Sip sip;
	Beam bm;
	GenBeam genbeams[0];
	MultiPage page,pages[0]; // collect all dependent multipages
	PlotViewport pv, pvs[0];
	EntPLine epls[0]; PLine plines[0]; // debug only
	BlockRef bref, brefs[0];
	TslInst tsl;
	
	for (int i=0;i<_Entity.length();i++) 
	{ 
		Entity& ent = _Entity[i];
		
		MetalPartCollectionEnt _ce= (MetalPartCollectionEnt)ent;
		Beam _bm= (Beam)ent;
		Sheet _sh= (Sheet)ent;
		Sip _sip= (Sip)ent;
		MultiPage _page = (MultiPage)ent;
		TslInst _tsl = (TslInst)ent;
		EntPLine epl = (EntPLine)ent;
		PlotViewport pv = (PlotViewport)ent;
		BlockRef _bref = (BlockRef)ent;
		
		if (_ce.bIsValid())
		{
			ce = _ce;
			sFormatPlotViewport.setDefinesFormatting(ce,_Map);			
		}
		else if (_bm.bIsValid() && sStyleBeam != tDisabled)
		{
			bm = _bm;
			sFormatPlotViewport.setDefinesFormatting(bm,_Map);
			genbeams.append(bm);	
		}
		else if (_sh.bIsValid() && sStyleSheet != tDisabled)
		{
			sh = _sh;
			sFormatPlotViewport.setDefinesFormatting(sh,_Map);			
			genbeams.append(sh);	
		}	
		else if (_sip.bIsValid() && sStylePanel != tDisabled)
		{
			sip = _sip;
			sFormatPlotViewport.setDefinesFormatting(sip,_Map);			
			genbeams.append(sip);	
		}
		else if (_tsl.bIsValid() && sStyleAssembly != tDisabled)
		{
			tsl = _tsl;
			sFormatPlotViewport.setDefinesFormatting(tsl,_Map);			
			//genbeams.append(tsl);	
		}
		else if (pv.bIsValid())
		{
			pvs.append(pv);	
		}
		else if (_bref.bIsValid())
		{
			bref = _bref;
			brefs.append(bref);	
		}			
		else if (_page.bIsValid())
		{ 
			if (!page.bIsValid())
			{
				page = _page;
			}
			pages.append(_page);		
		}
		else if (epl.bIsValid())
		{
			plines.append(epl.getPLine());
			epls.append(epl);
		}
//	// collect assemblyShopdraw tsls to collect all multipages	
//		else if (tsl.bIsValid() && tsl.scriptName()==(bDebug?"AssemblyShopdrawing":scriptName()))
//		{
//			Entity _ents[] = tsl.entity();
//			for (int j=0;j<_ents.length();j++)
//			{ 
//				MultiPage _page = (MultiPage)_ents[j];
//				if (_page.bIsValid() && pages.find(_page)<0)
//					pages.append(_page);
//			}
//		}		
	}//next i
		
//endregion 

//#Part3 //endregion 

//region Mode 2: Nest in PlotViewports
	if (nMode==2 && pages.length()>0 && sLayout != tDisabled)
	{ 
		//bDebug = true;
		if (bDebug)
		{ 
			Display dp(1);
			dp.textHeight(U(200));
			dp.draw(scriptName(), _Pt0, _XW, _YW, 1, 0);
			reportNotice(TN("     |Start nesting of| ") + pages.length() + T(" |multipages|"));			
		}

	//region Nesting Prerequisites

	//region Nester Data
	// set nester data
		double dDuration = 1;
		int bNestInOpening = false;
		double dNestRotation = 360;//set value in degrees: 0 for any angle, 90 for rotations per 90 degrees, 360 for no rotations allowed
		int nAlignment = 1;
		int bMirror = true; // top aligned
		double dGap;
	
		NesterData nd;
		nd.setAllowedRunTimeSeconds(dDuration); //seconds
		nd.setMinimumSpacing(dGap);
		nd.setChildOffsetX(0);
		nd.setGenerateDebugOutput(false);
		nd.setNesterToUse(_kNTRectangularNester);

		int bNest = _bOnDbCreated || (bDebug);// && _bOnRecalc);//_Map.getInt(kCallNester);			
	//endregion 

	//region Init Master
		PlaneProfile ppMaster(CoordSys()),ppx(CoordSys());
		double dXMaster, dYMaster;
		Point3d pt01, pt02;
		ppMaster = GetPlotviewRange(sLayout, sHeader, _Pt0, pt01,pt02, dXMaster, dYMaster, pv, bref);
//		if (bDebug && pv.bIsValid()) pv.dbErase();	
//		if (bDebug && bref.bIsValid()) bref.dbErase();
		if (bDebug)ppMaster.vis(3);

		Point3d ptX = _Pt0 + _YW * dYMaster;
		Vector3d vecXLeftOver = _XW*(dXMaster+U(2000));

	//endregion 
	
	//region Collect boundaries of each page and append to synch arrays
		PlaneProfile ppsAll[0];	Entity 	entsAll[0];	String filtersAll[0], tagsAll[0];		
		
		for (int j=0;j<pages.length();j++) 
		{ 
			MultiPage page= pages[j]; 
			CoordSys cs = page.coordSys();
			PlaneProfile pp(cs);

		//Collect submap data
			Map m = page.subMapX(kSubMapXKey);
			String filter = m.getString("Filter");
			if (filter.find(sPainterCollection,0,false)>-1)
				filter = filter.right(filter.length() - sPainterCollection.length() ); // extract only painter name	

		//region Get view extents
			if(!_Map.getInt("renest")) // do not use buffered shape when renesting existing shopdrawings
				pp.unionWith(m.getPlaneProfile("ppShowSet"));
			if (pp.area()<pow(dEps,2))
			{ 
				MultiPageView views[] = page.views();
				for (int v=0;v<views.length();v++) 
					pp.unionWith(getShowsetPlaneProfile(views[v], true));
				pp = getPageBlockPlaneProfile(page, pp);				
			}	
			
			if (pp.allRings().length()>0)
			{ 
				Map m = page.subMapX(kSubMapXKey);
				m.setPlaneProfile("ppShowSet", pp);
				m.setVector3d("vecOrg", cs.ptOrg() - _PtW);
				page.setSubMapX(kSubMapXKey,m);
			}
			setBoundingProfile(pp, dMargin);
			
		//endregion 

		// Append
			if (pp.area() > pow(dEps, 2))
			{
				entsAll.append(page);
				filtersAll.append(filter);		
				tagsAll.append(m.getString("tag"));//tag);	
				ppsAll.append(pp);	
				
				pp.vis(4);
			}
		}// next j
		
	
	// collect unique keys
		String sUniqueKeys[] = collectUniqueKeys(tagsAll);
		if (sSortDirection==tDescending)
			sUniqueKeys.reverse();			
	//endregion

	//End Nesting Prerequisites //endregion 
	



	//region Loop unique groups
		Entity entAllLeftOvers[0];
		PlaneProfile ppAllLeftOvers[0];	
		String sUniqueLeftOverKeys[0],sAllLeftOverKeys[0];

		for (int i=0;i<sUniqueKeys.length();i++) 
		{ 
		
		//region Get synch arrays
			String key = sUniqueKeys[i];
			PlaneProfile pps[0];	Entity 	ents[0];	String tags[0];

			for (int i=0;i<entsAll.length();i++) 
			{ 
				String tokens[] = tagsAll[i].tokenize("?");
				if (tokens.length() > 0 && tokens[0] == key)
				{
					ents.append(entsAll[i]);
					pps.append(ppsAll[i]);
					tags.append(tagsAll[i]);
				}
			}//next i

			for (int i=0;i<tags.length();i++) 
				for (int j=0;j<tags.length()-1;j++) 
				{
					if (tags[j]>tags[j+1])
					{
						ents.swap(j, j + 1);
						pps.swap(j, j + 1);
						tags.swap(j, j + 1);
					}					
					
				}	
				
			if(ents.length()<1)
			{ 
				continue;
			}
		//endregion 
			
		//region Collect max extents
			double dXMax, dYMax;
			for (int j=0;j<pps.length();j++) 
			{ 
				PlaneProfile pp = pps[j];
				double dX = pp.dX();
				double dY = pp.dY();
				dXMax = dXMax < dX ? dX : dXMax;
				dYMax = dYMax < dY ? dY : dYMax;
			}//next j
			if (dXMax<=0 || dYMax<=0){continue;}					
		//endregion 	
	
		// Get dominant Shape
			PlaneProfile ppPar = pps[0];
			double dXPar=ppPar.dX();
			double dYPar=ppPar.dY();
			 
		//region SubNesting
			PlaneProfile ppBound(CoordSys());
	
			CoordSys csChildNestings[0];
			Entity entChildNestings[0];
			PlaneProfile ppChildNestings[0];

			CoordSys csLeftOvers[0];
			Entity entLeftOvers[0];
			PlaneProfile ppLeftOvers[0];

			// no nester for small set
			Point3d ptXn = ptX+_XW * dXPar;			 
			 
			if(bNest && ents.length()>1)
			{ 
		
			//region Init Nester
				double dNetArea; // the net area of all childs
				NesterCaller nester;
				NesterChild ncs[0];	
				for (int j=1;j<ents.length();j++) 
				{ 
					dNetArea += pps[j].area();
					NesterChild nc(ents[j].handle(), pps[j]);
					nc.setNestInOpenings(bNestInOpening);
					nc.setRotationAllowance(dNestRotation);
					nester.addChild(nc);
					ncs.append(nc);
				}			
			//endregion 
	
			//region Run iterations of nester until no left overs
				int nMasterIndices[0],nLeftOverChilds[0];
				PlaneProfile ppSubMaster(CoordSys());			
				
				// estimate required submaster profile
				double dXRest = _XW.dotProduct((_Pt0 + _XW * dXMaster) - ptXn); // the remaining dist to the point most right of the master
				double dXM = dNetArea/dYMax*1.5;
				double dYM = dYMax;
				if (dXM < dXRest)dXM = dXRest;//reportNotice("\nXM= " +dXM + "-"+dXMaster);
				
				if (dXM>dXMaster)
				{ 
					dXM = dXMaster;
					dYM +=.3*dYMax;
				}
				
				
				// initial nesting
				ppSubMaster.createRectangle(LineSeg(ptXn, ptXn + _XW *dXM +  _YW * dYM ), _XW, _YW);
				RunNester(nester, ppSubMaster, nMasterIndices, nLeftOverChilds, nd);//nester, ncs, 
				//ppSubMaster.vis(2);
				
				int cnt;
				while (nLeftOverChilds.length()>0 && cnt<10)//dXM < (dXMaster - dXPar))
				{ 
					dXM += .3*dYMax;	

					if (dXM>dXMaster)
					{ 
						dXM = dXMaster;
						dYM +=.3*dYMax;
					}
				
					if (dXM>dXMaster ||dYM>dYMaster)
					{ 
						break;
					}
					nester = NesterCaller();
					for (int j=0;j<ncs.length();j++) 
						nester.addChild(ncs[j]);
	
					//reportNotice("\nXM= " +dXM +" at cnt " + cnt);
					ppSubMaster.createRectangle(LineSeg(ptXn, ptXn + _XW *dXM +  _YW * dYM ), _XW, _YW);	//ppSubMaster.vis(5);	
					RunNester(nester, ppSubMaster, nMasterIndices, nLeftOverChilds, nd);//nester, ncs
					//reportNotice("\ni: "+i + ", " +" attempt " + (cnt+1) + " wirth dX "+ dXM + " leftOvers " + nLeftOverChilds.length());	
					cnt++;
				}				
			//endregion 
	
			//region Loop over the nester masters and get the transformations for each
	
			// transform collection shapes and get transformations (same length)
				for (int m=0; m<nMasterIndices.length(); m++) 
				{
					int nIndexMaster = nMasterIndices[m];
					int nChildIndices[] = nester.childListForMasterAt(nIndexMaster);
					CoordSys csWorldXformIntoMasters[] = nester.childWorldXformIntoMasterAt(nIndexMaster);
					if (nChildIndices.length()!=csWorldXformIntoMasters.length()) 
					{
						reportNotice("\n" + scriptName()+": " + T("|The nesting result is invalid!|"));
						break;
					}
					
				// locate the childs within the master
					for (int c=0; c<nChildIndices.length(); c++) 
					{
						int nIndexChild = nChildIndices[c];
						String strChild = nester.childOriginatorIdAt(nIndexChild);	//if (bDebug)reportMessage("\n		Child "+nIndexChild+" "+strChild);
						
						Entity ent; ent.setFromHandle(strChild);
						CoordSys cs = csWorldXformIntoMasters[c];
	
						int n = ents.find(ent);
						if (n>-1)
						{ 
							PlaneProfile ppn = pps[n];
							ppn.transformBy(cs);	//ppn.vis(ent.color());
							ppBound.unionWith(ppn);
							
							csChildNestings.append(cs);
							entChildNestings.append(ent);
							ppChildNestings.append(ppn);
						}
					}
				}
			//endregion 
							
			//region Postprocess alignment
//				double dSmoothing = U(300);
//				if (dSmoothing>0)
//				{ 
//					LineSeg segs[] = getSegmentsOfMaxLength(ppBound, dSmoothing);
//					int cnt;
//					while (cnt < 100 && segs.length() > 0)
//					{
//						smoothenPlaneProfile(ppBound, dSmoothing);
//						segs = getSegmentsOfMaxLength(ppBound, dSmoothing);
//						cnt++;
//					}
//				}			
			
			
				Point3d ptMidBound = ppBound.ptMid();//ppBound.vis(40);
				Vector3d vecMidBound = _YW * 0.5 * ppBound.dY();		
				Vector3d vecAlign=_YW* _YW.dotProduct(ptX -(ptMidBound+nAlignment*vecMidBound));
	
				ppBound = PlaneProfile(CoordSys());
				for (int j=0;j<entChildNestings.length();j++) 
				{ 
					Entity ent = entChildNestings[j];
					PlaneProfile pp= ppChildNestings[j]; 
					CoordSys cs= csChildNestings[j]; 		
					Vector3d vec;
				
				// mirror/align opposite Y-Side
					if (bMirror)
						vec= _YW * _YW.dotProduct(ptMidBound - pp.ptMid()) * 2;
					vec += vecAlign;	
					cs.transformBy(vec);				
					pp.transformBy(vec);
					csChildNestings[j].transformBy(vec);
					
					ppBound.unionWith(pp);	
					if (bDebug)
					{ 					
						pp.vis(211);	
					}	 
				}//next j
				

				
				
				
				
			//endregion 	
		
			// TODO append left overs
			//nLeftOverChilds
		
			}
		//endregion 	
			
		//region Append transformed parent entity shape
			int bAllowNest = true;
			if (ents.length()>0)
			{ 
				Vector3d vec = ptX - ppPar.ptMid();
				vec += 0.5 * (_XW * dXPar - nAlignment*_YW * dYPar);
				
				ppPar.transformBy(vec);
				ptX += _XW * (ppBound.dX()+dXPar);
				
				ppBound.unionWith(ppPar);
				ppBound.shrink(-U(100));
				ppBound.shrink(U(100));		ppBound.vis(i);
				
				CoordSys cs(); cs.transformBy(vec);
				
				bAllowNest = (dXMaster - ppBound.dX() >= 0 && dYMaster - ppBound.dY() >= 0);
				
			// Test if it would fit in master
				if (bAllowNest)
				{ 
					PlaneProfile ppa = ppBound;
					Point3d pta1 = ppa.ptMid() - .5 * (_XW * ppa.dX() - _YW * ppa.dY());
					ppa.transformBy(pt01 - pta1);
					ppa.subtractProfile(ppMaster);	ppa.vis(4);
					if (ppa.area()>pow(U(10),2))
						bAllowNest = false;
				}

			// accept 	
				if (bAllowNest)
				{ 
					csChildNestings.insertAt(0, cs);
					entChildNestings.insertAt(0,ents[0]);
					ppChildNestings.insertAt(0,pps[0]);					
				}
			// reject if larger than master	
				else
				{ 
					csLeftOvers.append(csChildNestings);
					entLeftOvers.append(entChildNestings);
					ppLeftOvers.append(ppChildNestings);
					
					csLeftOvers.insertAt(0, cs);
					entLeftOvers.insertAt(0,ents[0]);
					ppLeftOvers.insertAt(0,pps[0]);	
					
					csChildNestings.setLength(0);
					entChildNestings.setLength(0);
					ppChildNestings.setLength(0);	

					ppBound.vis(1);
				}
			}			
		//endregion 
	
		//region Row Nesting
			double dX = ppBound.dX();
			double dY = ppBound.dY();
			Point3d ptm = ppBound.ptMid();
			Point3d pt1 = ptm-.5*(_XW*dX-_YW*dY);
			Point3d pt2 = ptm+.5*(_XW*dX-_YW*dY);	
	
			Vector3d vecTrans;
			
			if (bAllowNest)// disable for only subnesting
			{ 
				//reportNotice("\nbAllowNest hit");
				PlaneProfile pp = ppBound;
				ptX = pt01;
				Vector3d vec = ptX - pt1;
					
			// Grid locations: try to place at next grid location
				Point3d ptsX[0], ptsY[0];
				int numX, numY;
				GetGridLocations(ppx, ptsX, ptsY, numX, numY);	
	
				int bOk, cnt, cntX=1,cntY=1;
				while (!bOk && cnt<10000)
				{ 
					pp.transformBy(vec); //pp.vis(252);//pp.extentInDir(_XW).vis(i);
					ptX.transformBy(vec);
					pt1 += vec;	//pt1.vis(2);	
					pt2 += vec; //pt2.vis(2);	
		
				//region Next Row and next Master Tests
				// Continue in next row if extremes are not within master
					int bNextRow = numX>0 && (ppMaster.pointInProfile(pt2)==_kPointOutsideProfile || ppMaster.pointInProfile(pt1)==_kPointOutsideProfile);
	
				// test intersection with nested range
					PlaneProfile ppt = pp;
					int bHasIntersection = ppt.intersectWith(ppx);
					int bAccept = numX < 1 || !bHasIntersection;
	
				// Continue in next row if extremes are not within master
					if (bNextRow) 
					{
						//reportNotice("\nnext row hit");
						
						ptX += _XW *_XW.dotProduct(pt01-ptX);
						if (cntY<numY)
						{ 
							ptX += _YW*_YW.dotProduct(ptsY[cntY] - ptX);
							cntY++;
						}	
						else
							ptX -= _YW*pp.dY()*.1;// not an exact movement
						cntX = 1; // start allover again
						vec = ptX - pt1;
						pp.transformBy(vec);	pt1+=vec;	pt2+=vec;
						pp.vis(32);
						//PLine(pt1, pt2).vis(32+cnt);
//						{ 
//							EntPLine epl;
//							epl.dbCreate(PLine(pt1, pt2));
//							epl.setColor(cnt);
//						}
	
	
						ppt = pp;
						bHasIntersection = ppt.intersectWith(ppx);
						bAccept = numX < 1 || !bHasIntersection;
					}
	
				// next master shape: out of range
					double dy2 = _YW.dotProduct(pt2 - pt02);
					int bNextMaster = dy2 < 0 && bNextRow && numX<2; // extents out of range // TODO check if doesn't fit at all					
				//endregion 
				
				//region Test if out of master range
					if (bAccept && !bNextMaster)
					{ 
						PlaneProfile ppOut = pp;
						ppOut.subtractProfile(ppMaster);
						
					// partial out of master	
						if (ppOut.area()>pow(U(10),2))
						{ 
							vec= _XW*_XW.dotProduct(pt01-ptX);
							
						// grid point found	
							if (cntY<numY)
							{ 
								vec += _YW*_YW.dotProduct(ptsY[cntY] - ptX);
								cntY++;
							}	
						// no grid point found, iterate by partial dY	
							else
								vec -= _YW*pp.dY()*.1;// not an exact movement
							
						// test if new location would be out of Y master range	
							Point3d pt = pt2 + vec;
							dy2 = _YW.dotProduct(pt - pt02);
							bNextMaster = dy2 < 0;
							
							//pp.vis(cnt);	
							cnt++;
							if (!bNextMaster)
							{
								continue;
							}
						}
					}
										
				//Test if out of master range //endregion 
	
				//region Create and offset new master
					if (bNextMaster)
					{
						cntX = numX;
						vecXLeftOver +=  _XW * dXMaster;

						ppMaster = GetPlotviewRange(sLayout, sHeader, pt02, pt01,pt02, dXMaster, dYMaster, pv, bref);
						ptX = pt01;
						vec = Vector3d();
						ppx = PlaneProfile(CoordSys());
						pp.transformBy((pt01 + .5 * (_XW * dX - _YW * dY)) - pp.ptMid());
						
						reportNotice("\n        new pv on next master, PV:" +  pv.handle());
						
						//pp.vis(1);
					}					
				//endregion 	
							
				//region Location is accepted
					if (bAccept)
					{	
						double a1 = ppx.area();
						ppx.unionWith(pp);
						double a2 = ppx.area();
						
					// test if intersection was successfull: if triangle shapes hit a pp on one point the union fails
						if (abs(a1-a2)<pow(U(2),2))
						{ 
							//pp.vis(40);
						// add a small rectangle on the blownup intersection	
							PlaneProfile ppa = pp;
							ppa.shrink(-dEps);
							ppa.intersectWith(ppx);
							ppa.shrink(-dEps);
							ppa.createRectangle(ppa.extentInDir(_XW), _XW, _YW);
							ppx.unionWith(ppa);
							ppx.unionWith(pp);	
							//a2 = ppx.area();
						}
						
						
					// collect new grid points	
						GetGridLocations(ppx, ptsX, ptsY, numX, numY);
		
						//pp.vis(i);
						bOk = true;
						break;
					}					
				//endregion 
	
				//region Invalid location, move to next X-Location
					else if (cntX<numX)
					{ 
						double d1 = _XW.dotProduct(ptsX[cntX] - pt1);//(pp.ptMid()-_XW*.5*pp.dX()));//ptX);
						double d2 = ppt.dX();
					// move by minimal intersection	
						if (d2>dEps && d2<d1 && d2<dX  && _XW.dotProduct(ptX - pt01)>0)
						{ 
							vec = _XW*(d2);
	//						if (i>8){ppBound.vis(20);ppt.vis(211);PLine(ptsX[cntX]+_YW*U(300),ptsX[cntX]-_YW*U(3000),ptX).vis(cnt);}
						}
					// move to grid location	
						else
						{ 
							vec = _XW*d1;
							cntX++;						
						}
					}					
				//endregion 
	
					cnt++;
				}					 
		
				//PLine (ptX, _PtW).vis(3);
				vecTrans = pp.ptMid() - ptm;
				ppBound.transformBy(vecTrans);
				//ppBound.vis(i);	
	
			}
		//END Row Nesting //endregion 
		
		//region The final transformations
			if (bShowDebugLog)reportNotice(TN("     |Transforming pages of subset| ")+key + " ("+ entChildNestings.length() + ")");

			Entity entDefines[0]; // a collector of defining entities to set the plotViewPortName
			for (int j=0;j<entChildNestings.length();j++) 
			{ 
				Entity e = entChildNestings[j];
				
			// collect defining entity	
				MultiPage page = (MultiPage)e;
				if (page.bIsValid())
				{ 
					Entity entDefine = GetDefiningEntity(page);
					if (entDefine.bIsValid() && entDefines.find(entDefine)<0)
						entDefines.append(entDefine);
				}

				if (bShowDebugLog)reportNotice("\n        j:" +j +" definings: "+ entDefines.length() + " PV:" +  pv.handle());
				int n = ents.find(e);
				if (n>-1)
				{ 
					Display dp(i);//e.color());
					
					PlaneProfile pp = pps[n];
					dp.draw(pp, _kDrawFilled, 80);
					
					CoordSys cs = csChildNestings[j];
					cs.transformBy(vecTrans);
					//Vector3d vec = ppChildNestings[j].ptMid() - pps[n].ptMid();
					pp.transformBy(cs);
					if (bNest && !bDebug)//!bDebug)// ||bNest)
					{
						e.transformBy(cs);	
					}

					dp.draw(pp, _kDrawFilled, 80);
					dp.draw(pp);
					
				}
			}//next j

		// HSB-22965
			if (pv.bIsValid()) // set plotviewport name and posnum
			{ 
				String name;
				String formatPV = sFormatPlotViewport.length()>0?sFormatPlotViewport:"@(posnum:D)@(Definition:D)@(ScriptName:D)-@(Handle)";
				for (int j=0;j<entDefines.length();j++) 
				{ 
					String txt= entDefines[j].formatObject(formatPV); 
					name += (name.length() > 0 ? ";" : "") + txt;
				}//next j
				pv.setName(name);				
				if (pv.posnum()<0)
					pv.setPosnum(GetPlotPosNum());
			}
			
			
			

			for (int j=0;j<entLeftOvers.length();j++) 
			{ 
				Entity e = entLeftOvers[j];
				int n = ents.find(e);
				if (n>-1)
				{ 
					PlaneProfile pp = pps[n];
					CoordSys cs = csLeftOvers[j];
//					vecXLeftOver += .5 * _XW * pp.dX();
//					cs.transformBy(vecXLeftOver);
//					vecXLeftOver += .5 * _XW * pp.dX();
					pp.transformBy(cs);
					if (bNest && !bDebug)//!bDebug)// ||bNest)
					{
						e.transformBy(cs);	
						ppAllLeftOvers.append(pp);
						entAllLeftOvers.append(e);	
						sAllLeftOverKeys.append(key);
						if (sUniqueLeftOverKeys.findNoCase(key,-1)<0)
							sUniqueLeftOverKeys.append(key);
					}
						
					Display dp(252);
					dp.draw(pp, _kDrawFilled, 80);
					dp.color(2);
					dp.draw(pp);
					
				}
			}//next j
			 
			 
		//endregion 	 
		
		// Create Border Instance
		if (bNest)
		{ 
		// create TSL
			TslInst tslNew;
			GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
			int nProps[]={nColor};		double dProps[]={dMargin, dSmoothing};	
			String sProps[]={};
			Map mapTsl;	
			
			mapTsl.setInt("mode", 3);
			entsTsl.append(entChildNestings);
						
			tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			
		}
		
		
		
		
		}//___________________next i
			
	//endregion 


	//region Transform left overs and create grouping

		vecXLeftOver = _XW * (_XW.dotProduct(pt02 - _Pt0)+ U(2000) );//
		String keyGroup;
		for (int i=0;i<sUniqueLeftOverKeys.length();i++) 
		{ 
			Entity entsTsl[0]; // a collection of pages which have the same unique key-> create border instance
			String key = sUniqueLeftOverKeys[i]; 
			for (int j=0;j<entAllLeftOvers.length();j++) 
			{ 
				String keyJ = sAllLeftOverKeys[j];
				if (key!=keyJ){ continue;}

				Entity e = entAllLeftOvers[j];
				PlaneProfile pp = ppAllLeftOvers[j];
				pp.transformBy(vecXLeftOver);
				if (bNest && !bDebug)
				{
					e.transformBy(vecXLeftOver);
					entsTsl.append(e);
				}

				if (bDebug)
				{
					Display dp(6);
					dp.draw(pp, _kDrawFilled, 80);
					dp.draw(pp);
				}

			}//next j

			if (entsTsl.length()>0)
			{ 
			// create TSL			
				TslInst tslNew;
				GenBeam gbsTsl[] = {};		Point3d ptsTsl[] = {_Pt0+vecXLeftOver};
				int nProps[]={nColor};			
				double dProps[]={dMargin, dSmoothing};					
				String sProps[]={};
				Map mapTsl;	
				
				mapTsl.setInt("mode", 3);
							
				tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			

			}		 
		}//next i
		
	//END Transform left overs and create grouping //endregion 




		reportNotice(TN("*** |nesting done, please wait for screen refresh| "));
		if (!bDebug)
			eraseInstance();
		return;
	}
//Nest in PlotViewports //endregion 






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
        <int nm="BreakPoint" vl="1516" />
        <int nm="BreakPoint" vl="1855" />
        <int nm="BreakPoint" vl="2763" />
        <int nm="BreakPoint" vl="1350" />
        <int nm="BreakPoint" vl="2593" />
        <int nm="BreakPoint" vl="432" />
        <int nm="BreakPoint" vl="1784" />
        <int nm="BreakPoint" vl="2367" />
        <int nm="BreakPoint" vl="2363" />
        <int nm="BreakPoint" vl="2261" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23092 max bounding of border fixed" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="12/3/2024 8:53:18 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23092 mew property to enable optional selection of xref entities" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="12/2/2024 10:14:41 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22965 plotviewport naming, new command to specidy rectangular border" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="11/12/2024 5:00:06 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22271 bugfix header block creation on insert" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="6/17/2024 4:37:36 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22271 smoothening property published on insert" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="6/17/2024 8:56:08 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20206 assemblyDefinition supported to create nested" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="4/3/2024 3:14:06 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20206 naming of the property of the header clarified" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="4/2/2024 9:29:13 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20550 renesting of existing pages imrpoved, insert jig and margin grips added" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="11/15/2023 12:19:40 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20550 bugfix color and margin on creation, smoothing improved" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="11/15/2023 11:09:36 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20550 list token replaced to ?, simple shape recognition of schedule table added" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="11/14/2023 4:07:34 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20550 purging redundant dimlines improved, new property and context command for smoothing of bounding border, placement left over pages added, new properties for margin and color" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="11/14/2023 12:50:57 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20550 purges redundant dimlines on creation" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="11/13/2023 5:50:33 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20550 new subnesting and alignment" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="11/13/2023 4:06:06 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19707 instance will be purged after creation" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="8/8/2023 3:13:16 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18906 catching objectCollectionType on creation for hsbDesign25" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="5/9/2023 5:11:37 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18884 added support to purge existing plotviewports and blockrefs when running in redistribution mode, new options to toggle styles" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="5/3/2023 2:24:50 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18681 plotviewports and brefs appended, simple nesting respects bref outline, compatibel V25" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="4/19/2023 8:16:43 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18681 plotviewports and brefs appended, simple nesting respects bref outline" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="4/18/2023 5:28:51 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18245 revised and simple polygonal nesting included" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="3/10/2023 4:26:54 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End