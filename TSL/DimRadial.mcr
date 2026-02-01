#Version 8
#BeginDescription
This tsl creates an radial or diametric dimension

#Versions
Version 3.4 02.12.2024 HSB-23092 supporting metalparts of xref drawings
Version 3.3 14.02.2024 HSB-21240 mortise detection improved
Version 3.2 13.02.2024 HSB-21240 curvedStyle added, tool/contour overlay enhanced, various enhancements on detecting arcs

Version 3.1 12.02.2024 HSB-21240 perpendicular drills supressed, leader added
Version 3.0 08.02.2024 HSB-21396 bugfix blockspace toolset
Version 2.9 01.02.2024 HSB-20487 beam end alignment fixed
Version 2.8 01.02.2024 HSB-20487 arc length dimension appended
Version 2.7 26.01.2024 HSB-20487 completly revised, ,new property tool definition (use context command to specify)

Version 2.6 15.11.2023 HSB-20639 bugfix leader length moving multipages
Version 2.5 09.08.2023 HSB-19787 grips improved, dimstyle group assignment enhanced
Version 2.4 31.05.2023 HSB-19099 supports painter filtering when defined in blockspace, dimstyles which are associated to non radial(diametric) dimensions are not shown anymore
Version 2.3 20.04.2023 HSB-18761 caching improved, assemblyDefinitions collected via showSet, supports pages which use scale to fit
Version 2.2 19.04.2023 HSB-18708 consumes entities of AssemblyDefinitions
Version 2.1 03.04.2023 HSB-18554 considering potential opposite view during generate shopdrawing
Version 2.0 31.03.2023 HSB-18541 additional format variables are available through formatting expressions
Version 1.9 31.03.2023 HSB-18346 caching of analysed tools and shape added to improve performance















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
//region Part #1

//region <History>
// #Versions
// 3.4 02.12.2024 HSB-23092 supporting metalparts of xref drawings , Author Thorsten Huck
// 3.3 14.02.2024 HSB-21240 mortise detection improved , Author Thorsten Huck
// 3.2 13.02.2024 HSB-21240 curvedStyle added, tool/contour overlay enhanced, various enhancements on detecting arcs , Author Thorsten Huck
// 3.1 12.02.2024 HSB-21240 perpendicular drills supressed, leader added , Author Thorsten Huck
// 3.0 08.02.2024 HSB-21396 bugfix blockspace toolset , Author Thorsten Huck
// 2.9 01.02.2024 HSB-20487 beam end alignment fixed , Author Thorsten Huck
// 2.8 01.02.2024 HSB-20487 arc length dimension appended , Author Thorsten Huck
// 2.7 26.01.2024 HSB-20487 completly revised, ,new property tool definition (use context command to specify) , Author Thorsten Huck
// 2.6 15.11.2023 HSB-20639 bugfix leader length moving multipages , Author Thdeorsten Huck
// 2.5 09.08.2023 HSB-19787 grips improved, dimstyle group assignment enhanced , Author Thorsten Huck
// 2.4 31.05.2023 HSB-19099 supports painter filtering when defined in blockspace, dimstyles which are associated to non radial(diametric) dimensions are not shown anymore , Author Thorsten Huck
// 2.3 20.04.2023 HSB-18761 caching improved, assemblyDefinitions collected via showSet, supports pages which use scale to fit , Author Thorsten Huck
// 2.2 19.04.2023 HSB-18708 consumes entities of AssemblyDefinitions , Author Thorsten Huck
// 2.1 03.04.2023 HSB-18554 considering potential opposite view during generate shopdrawing , Author Thorsten Huck
// 2.0 31.03.2023 HSB-18541 additional format variables are available through formatting expressions , Author Thorsten Huck
// 1.9 31.03.2023 HSB-18346 caching of analysed tools and shape added to improve performance , Author Thorsten Huck
// 1.8 03.03.2023 HSB-18112 'Ø' will be displayed when using unit scaling in diametric mode, 'one by source' mode corrected , Author Thorsten Huck
// 1.7 27.02.2023 HSB-18112 bugfix insert in block space , Author Thorsten Huck
// 1.6 24.02.2023 HSB-18112 new properties and extended behaviour for block space setup, consumes shape and analysed drills , Author Thorsten Huck
// 1.5 23.02.2023 HSB-18112 supporting any drill with axis most aligned to view direction , Author Thorsten Huck
// 1.4 16.02.2023 HSB-16730 reconsruction of segmented contours enhanced, arc recognition improved
// 1.3 09.02.2023 HSB-16730 segmented contours will try to reconstruct into arc segments enhanced , Author Thorsten Huck
// 1.2 07.02.2023 HSB-16730 segmented contours will try to reconstruct into arc segments , Author Thorsten Huck
// 1.1 03.02.2023 HSB-17771 new options to distinguish between convex and concave dimensions , Author Thorsten Huck
// 1.0 08.11.2022 HSB-16730 initial version of radial and diametric dimensions , Author Thorsten Huck
// 0.2 04.11.2022 first beta , Author Thorsten Huck


/// <insert Lang=en>
/// Select entity and pick location
/// </insert>

// <summary Lang=en>
// The tsl creates an radial or diametric dimension

// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "DimRadial")) TSLCONTENT

// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_conscalcTslWithKey (_TM "|Regenerate Shopdrawing|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Similar|") (_TM "|Select Tool|"))) TSLCONTENT
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

	String tDefaultEntry = T("<|Default|>"),kBlockCreationMode = "BlockCreationMode";
	String kArcLengthSymbol = "ᴖ";//"Ո";
	String kSTContour="Contour", kSTOpening="Opening", kSTCurved="Curved";

//region Tool Types
	// both arrays need to be in synch as translated list will be presented to the user, but subTypes will be stored
	String sToolTypes[] =
	{
		"_kContour", "_kOpenings", 
		_kADPerpendicular, _kADRotated, _kADTilted, _kADHead, _kAD5Axis,									// Drill
		_kAMPerpendicular, _kAMRotated, _kAMTilted, _kAM5Axis, _kAMHeadPerpendicular,											// Mortise 
		_kAMHeadSimpleAngled, _kAMHeadSimpleAngledTwisted, _kAMHeadSimpleBeveled, _kAMHeadCompound						  		// Mortise 
	};

	String sToolTypesT[] =
	{
		T("|Contour|"), T("|Openings|"),
		T("|Drill, perpendicular|"), T("|Drill, rotated|"), T("|Drill, tilted|"), T("|Drill, head side|"), T("|Drill, 5-Axis|"), 
		T("|Mortise, perpendicular|"), T("|Mortise, rotated|"), T("|Mortise, tilted|"), T("|Mortise, 5-Axis|"), T("|Mortise, perpendicular beam end|"),				// Mortise 
		T("|Mortise, beam end simple angled|"), T("|Mortise, beam end simple angled and twisted|"), T("|Mortise, beam end simple beveled|"), _kAMHeadCompound		// Mortise 
	};
	{ 
		// auto translate missing
		String prefixes[] = { "_kAM", "_kABC"};
		for (int j=0;j<prefixes.length();j++) 
			for (int i=0;i<sToolTypesT.length();i++) 
			{ 
				String& s = sToolTypesT[i]; 
				if (s.find(prefixes[j],0, false)==0)
					s = T("|"+s.right(s.length() - prefixes[j].length())+"|");
			}//next i		
	}

	
//endregion 


//end Constants//endregion

//region Functions

	//region Viewport functions

	//region Function getPlaneProfileShopdrawViewport
	// returns the bounding planeprofile of a shopdrawviewport
	// sdv: the shopdrawViewport
	PlaneProfile getPlaneProfileShopdrawViewport(ShopDrawView sdv)
	{ 
		Point3d pts[] = sdv.gripPoints();
		Point3d ptCen = sdv.coordSys().ptOrg();
		double dX = U(1000), dY = dX; //something
		for (int i = 0; i < 2; i++)
		{
			Vector3d vec = i == 0 ? _XW : _YW;
			pts = Line(_Pt0, vec).orderPoints(pts);
			if (pts.length() > 0)
			{
				double dd = vec.dotProduct(pts.last() - pts.first());
				if (i == 0)dX = dd;
				else dY = dd;
			}
		}//next i
		
		Vector3d vec = .5 * (_XW * dX + _YW * dY);
		PlaneProfile pp; pp.createRectangle(LineSeg(ptCen - vec, ptCen + vec), _XW, _YW);
		return pp;
	}//End getPlaneProfileShopdrawViewport //endregion

	//region Function getModelView
	// returns a map containing all visible boundaries of each view and modifies the corresponding array
	// t: the tslInstance to 
	Map getMultipageViewProfiles(MultiPageView mpvs[],PlaneProfile& pps[])
	{ 
		Map out;
		pps.setLength(0);
		CoordSys cs();
		for (int i=0;i<mpvs.length();i++) 
		{ 
			MultiPageView& mpv = mpvs[i];				
			CoordSys ms2ps = mpv.modelToView();			

			PlaneProfile pp(cs);
			pp.joinRing(mpv.plShape(), _kAdd);
			
		//region Reduce to visible part of viewport
			Entity ents[] = mpv.showSet();
			PlaneProfile ppx(cs);
			for (int j=0;j<ents.length();j++) 
			{ 
				Quader q = ents[j].bodyExtents();
				q.transformBy(ms2ps);
				LineSeg seg(q.pointAt(-1, - 1 ,- 1), q.pointAt(1, 1, 1));
				PlaneProfile ppj; ppj.createRectangle(seg, _XW, _YW);
				ppx.unionWith(ppj);  
			}//next x
			ppx.createRectangle(ppx.extentInDir(_XW), _XW, _YW);
			if (ppx.area()>pow(dEps,2))
				pp.intersectWith(ppx);							
		//endregion 	

			pps.append(pp);
			out.appendPlaneProfile("pp", pp);
		}//next j
		return out;
	}//End getModelView //endregion

			
	//viewport functions //endregion 

	//region Function getDimStyles
	// returns
	// t: the tslInstance to 
	void getDimStyles(int nDimMode, String& sDimStyles[], String& sSourceDimStyles[])
	{ 
	
		sDimStyles.setLength(0);
		sSourceDimStyles.setLength(0);
		
	// Find DimStyle Overrides, order and add Linear only
		String key = "$1"; // linear
		if(nDimMode==0)
			key = "$3";
		else if(nDimMode==1)
			key = "$4";
		else if(nDimMode==2)
			key = "$3";
		else if(nDimMode==3)// arc measure: use angular
			key = "$2";			
		
	// append potential linear overrides	
		String sOverrides[0];
		for (int i=0;i<_DimStyles.length();i++) 
		{ 
			String dimStyle = _DimStyles[i]; 
			int n = dimStyle.find(key, 0, false);	// indicating it is a linear override of the dimstyle
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
		{ 
			for (int j=0;j<sDimStyles.length()-1;j++) 
				if (sDimStyles[j]>sDimStyles[j+1])
				{
					sDimStyles.swap(j, j + 1);
					sSourceDimStyles.swap(j, j + 1);
					}
		}

		return;
	}//End getDimStyles //endregion


	//region Function drawDim
	// draws a radial or diametric dim
	// ptLoc: a point on the arc
	// ptCen: the center point
	// arc: the arc or circle
	// mapParams: the parameters of the dim
	void drawDim(Point3d ptLoc, Point3d ptCen, PLine arc, Map mapParams)
	{ 
		
		Map m = mapParams;
			
		int nDimType = m.getInt("dimType");
		int bIsCircle = arc.isClosed();

		int bIsAuto = nDimType==3;
		int bIsRadial = nDimType==0 || (bIsAuto && !bIsCircle);

		double dUnitScale = m.getDouble("UnitScale");
		double leaderLength = m.getDouble("leaderLength");
		
		double textHeight = m.getDouble("textHeight");
		double dDimScale = m.getDouble("dimScale");
		double dScale = m.getDouble("Scale");
		String dimStyle = m.getString("dimStyle");
		String dimStyleUI = m.getString("dimStyleUI");

		String sDimStyles[0], sSourceDimStyles[0];
		getDimStyles(bIsRadial, sDimStyles, sSourceDimStyles);
		dimStyle = sSourceDimStyles[sDimStyles.find(dimStyleUI,0)];
		if (_DimStyles.findNoCase(dimStyle ,- 1) < 0)dimStyle = _DimStyles.first();			

		PlaneProfile ppShape = m.getPlaneProfile("ppShape");
		Point3d ptRef = m.getPoint3d("ptRef");
		Vector3d vecX = m.getVector3d("vecX");
		Vector3d vecY = m.getVector3d("vecY");
		Vector3d vecZ = m.getVector3d("vecZ");		
		int color = m.getInt("color");
		
		String text = m.getString("text");
		Point3d ptLeader = m.getPoint3d("ptLeader");
		double dRadius = m.hasDouble("Radius")?m.getDouble("Radius"):(ptLoc-ptCen).length();

		Display dp(color);
		dp.dimStyle(dimStyle, dScale);
		dp.addHideDirection(vecX);
		dp.addHideDirection(-vecX);
		dp.addHideDirection(vecY);
		dp.addHideDirection(-vecY);
		dp.textHeight(textHeight);		


		//reportNotice("\nscale " + dScale + " text " + text + " radius " + dRadius);
//	//	mapAdd.setDouble("CoordX", dCoordX,_kLength);
//	//	mapAdd.setDouble("CoordY", dCoordY,_kLength);		



	// Dimension

		if (bIsRadial)
		{ 
			DimRadial dim(ptCen, ptLoc, leaderLength);
			dim.setUseDisplayTextHeight(true);	
			dim.setDimensionPlane(ptCen, vecX, vecZ);
			dim.setDimScale(dDimScale);
			
			if (text.length()<1 && dUnitScale!=1)
				dim.setText("R"+dRadius*dUnitScale);
			else if (text.length()<1)
				dim.setText("R"+dRadius);				
			else if (text.length()>0)
				dim.setText(text);	
		
			if (m.hasPoint3d("ptLeader"))// && leaderLength>0) HSB-21420
				dim.setTextLocation(ptLeader);
		
		
			dp.draw(dim);	
			
	//		PLine plines[] = dim.getTextAreas(dp);
	//		for (int i=0;i<plines.length();i++) 
	//			ppTextArea.joinRing(plines[i],_kAdd); 
	
		}
		else
		{ 
			Vector3d vec = ptLoc - ptCen;
			
			DimDiametric dim(ptLoc, ptCen-vec, leaderLength);
			dim.setUseDisplayTextHeight(true);	
			dim.setDimensionPlane(ptCen, vecX, vecZ);
			dim.setDimScale(dDimScale);
	
			if (text.length()<1 && dUnitScale!=1)
				dim.setText("Ø"+2*dRadius*dUnitScale);
			else if (text.length()<1)
				dim.setText("Ø"+2*dRadius);				
			else if (text.length()>0)
				dim.setText(text);	
				
			if (m.hasPoint3d("ptLeader") )//&& leaderLength>0)	HSB-21420
				dim.setTextLocation(ptLeader);
	
			dp.draw(dim);	
		
	//		PLine plines[] = dim.getTextAreas(dp);
	//		for (int i=0;i<plines.length();i++) 
	//			ppTextArea.joinRing(plines[i],_kAdd);		
		}
//

		return;
		
	}//End drawDim //endregion

	//region Function drawDimAngular
	// draws a radial or diametric dim
	// ptLoc: a point on the arc
	// ptCen: the center point
	// arc: the arc or circle
	// mapParams: the parameters of the dim
	void drawDimAngular(Point3d ptLoc, Point3d ptCen, PLine arc, Map mapParams)
	{ 
		
		Map m = mapParams;
			
		int nDimType = m.getInt("dimType");
		int bIsCircle = arc.isClosed();

		int bIsAuto = nDimType==2;
		int bIsRadial = nDimType==0 || (bIsAuto && !bIsCircle);

		double dUnitScale = m.getDouble("UnitScale");
		double leaderLength = m.getDouble("leaderLength");
		
		double textHeight = m.getDouble("textHeight");
		double dDimScale = m.getDouble("dimScale");
		double dScale = m.getDouble("Scale");
		String dimStyle = m.getString("dimStyle");
		String dimStyleUI = m.getString("dimStyleUI");

		String sDimStyles[0], sSourceDimStyles[0];
		getDimStyles(3, sDimStyles, sSourceDimStyles);
		dimStyle = sSourceDimStyles[sDimStyles.find(dimStyleUI,0)];
		if (_DimStyles.findNoCase(dimStyle ,- 1) < 0)dimStyle = _DimStyles.first();			

		PlaneProfile ppShape = m.getPlaneProfile("ppShape");
		Point3d ptRef = m.getPoint3d("ptRef");
		Vector3d vecX = m.getVector3d("vecX");
		Vector3d vecY = m.getVector3d("vecY");
		Vector3d vecZ = m.getVector3d("vecZ");		
		int color = m.getInt("color");
		
		Vector3d vecCen = ptCen - ptLoc; 
		double radius = vecCen.length();
		vecCen.normalize();
		
		Point3d ptOnArc = m.hasPoint3d("ptArc") ? m.getPoint3d("ptArc") : ptLoc - vecCen * textHeight;
		Point3d ptLeader = ptOnArc;
		int bAddLeader = m.hasPoint3d("ptLeader");
		if (bAddLeader)
		{ 
			ptLeader = m.getPoint3d("ptLeader");
			ptLeader += vecZ * vecZ.dotProduct(ptOnArc - ptLeader);
		
			Vector3d vecN = ptLeader - ptCen; vecN.normalize(); vecN = vecN.crossProduct(vecZ);
			Point3d ptsX[] = arc.intersectPoints(Plane(ptLeader, vecN));
			
			if (ptsX.length()>0)
			{ 
				PLine c1; c1.createCircle(ptCen, vecZ, radius);
				PLine c2; c2.createCircle(ptCen, vecZ, (ptOnArc-ptCen).length());
				Point3d pt1 = c1.closestPointTo(ptLeader);
				Point3d pt2 = c2.closestPointTo(ptLeader);

				double da = (pt1-pt2).length();
				PLine arc2 = arc;
				arc2.offset(-da, true);	
				//Display dpp(2);		dpp.draw(arc2);
		
				Point3d pt3 = arc2.closestPointTo(ptLeader);
				double d3 = (pt3-ptLeader).length();
				if (d3<textHeight)
					bAddLeader = false;
				
			}
		}

		String text = m.getString("text");

		Display dp(color);
		dp.dimStyle(dimStyle, dScale);
		dp.addHideDirection(vecX);
		dp.addHideDirection(-vecX);
		dp.addHideDirection(vecY);
		dp.addHideDirection(-vecY);
		dp.textHeight(textHeight);		

	// Dimension	
		
		DimAngular dim(ptCen, arc.ptStart(), arc.ptEnd(), ptOnArc);
		dim.setUseDisplayTextHeight(true);	
		dim.setDimensionPlane(ptLoc, vecX, vecZ);
		dim.setDimScale(dDimScale);
		if (bAddLeader)
			dim.setTextLocation(ptLeader);					
		if (text.length()>0)
			dim.setText(text);	
		
		
		dp.draw(dim);




		return;
		
	}//End drawDimAngular //endregion


	//region ARC Functions
		
	//region Function drawArcs
	// draws the planeprofiles, the closest one will be highlighted
	// pps: the planeprofiles to be drawn
	// pt: the point to identify the closest
	// dp: the display to be used
	void drawArcs(PlaneProfile pps[], Point3d pt, Display dp)
	{ 
	    double dMin = U(10e6);
	    int n;
	    for (int i=0;i<pps.length();i++) 
	    { 
	    	double d = (pps[i].closestPointTo(pt)-pt).length();
	    	if (d<dMin)
	    	{ 
	    		dMin = d;
	    		n = i;
	    	}	    	 
	    }//next i
	    for (int i=0;i<pps.length();i++)
	    { 
	    	dp.trueColor(n==i?darkyellow:lightblue, n==i?0:50);
	    	dp.draw(pps[i], _kDrawFilled);
	    }	
	}//End drawArcs //endregion	
		
	//region Function createArcProfiles
	// returns an array of planeprofiles with the same length as arcs
	// arcs: a collection of arcs or circles
	// pn: the plane of the output
	PlaneProfile[] createArcProfiles(PLine arcs[], Plane pn)
	{ 
		PlaneProfile pps[arcs.length()];
		Vector3d vecZ = pn.normal();
		double dOff = getViewHeight() / 500;
		for (int i=0;i<arcs.length();i++) 
		{ 
			PLine arc = arcs[i];		
			if (!arc.isClosed())
			{ 
				PLine pl1 = arc;
				PLine pl2 = arc;
				pl1.offset(dOff, true);
				pl2.offset(-dOff, true);
				pl2.reverse();
				pl1.append(pl2);
				pl1.close();
				arc = pl1;
			}		
			
			arc.projectPointsToPlane(pn, vecZ);
			arc.convertToLineApprox(dEps);
			pps[i] = PlaneProfile(arc);		
		}
		return pps;
	}//End createArcProfiles //endregion

	//region Function findClosestArc
	// returns the index of the closest arc in relation to the specified point
	// arcs: the list of arcs or circles
	// ptLoc: the given location
	// vecZ: teh projection direction
	int findClosestArc(PLine arcs[], Point3d ptLoc, Vector3d vecZ)
	{
		int out = -1;
		double dDist = U(10e6);
		for (int i=0;i<arcs.length();i++)
		{ 
			PLine arc = arcs[i];

			Point3d ptx = arc.closestPointTo(ptLoc);
			ptx += vecZ * vecZ.dotProduct(ptLoc - ptx);
			double d = (ptx - ptLoc).length();
			if (d<dDist)
			{ 
				out = i;
				dDist = d;
			}	
		}	
		return out;
	}//End findClosestArc //endregion	

		
	//endregion 


	//region Function getGripByName
	// returns the grip index if found in array of grips
	// name: the name of the grip
	int getGripByName(Grip grips[], String name)
	{ 
		int out = - 1;
		for (int i=0;i<grips.length();i++) 
		{ 
			if (grips[i].name()== name)
			{
				out = i;
				break;
			}	 
		}//next i
		return out;
	}//End getGripByName //endregion

	//region Function convertToCircle
	// returns a circle if pline appears like a circle
	// t: the tslInstance to 
	int convertToCircle(PLine& plIn, Point3d& ptCen, double& radius)
	{ 
		int out;
		PLine pl = plIn;
		CoordSys cs = pl.coordSys();

		PlaneProfile pp(cs); pp.joinRing(pl,_kAdd);
		pl.convertToLineApprox(dEps);
		Point3d pts[] = pl.vertexPoints(true);
		Point3d ptm; ptm.setToAverage(pts);
		//pp.vis(20);
		
		int num = pts.length();
		int err;
		if (pts.length()>5 && abs(pp.dX()-pp.dY())<dEps)
		{ 
			double r = pp.dX()*.5;
			int bAsCircle = true;
			ptm = pp.ptMid();	//ptm.vis(2);
			for (int p=0;p<pts.length();p++) 
			{
				double d = (pts[p] - ptm).length();
				//pts[p].vis(4);
				if(abs(d-r)>dEps)
				{
					err++;
				}
				 
			}//next p
			
			
			if (err<3 && r>dEps)
			{
				plIn.createCircle(ptm, cs.vecZ(), r);
				ptCen = ptm;
				radius = r;
				out = true;
			}
			//ptm.vis(3);
			return out;
		}


	}//End convertToCircle //endregion

	//region Function convertRing
	// converts a segmented ring into a ring with arced segments and manipulates the IO map containing all arcs
	// returns the number of arcs found
	// pl: the pline to be converted
	// cs: the coordSys of the pline
	// parent: the parent entity of which the pline has been derived
	int convertRing(PLine& pl, String subType, Map& mapIO, Entity parent, PLine plLocks[])
	{ 
		int out;
		CoordSys cs = pl.coordSys();
		Vector3d vecZ = cs.vecZ();
		PlaneProfile ppRing(cs);
		ppRing.joinRing(pl, _kAdd);

//		if(bDebug)
//		{ 
//			EntPLine epl;
//			epl.dbCreate(pl);
//			epl.setColor(6);			
//		}


	// Buffer original
		PLine plOrg = pl;
		double shortestSeg = plOrg.length();
		{ 
			Point3d pts[] = plOrg.vertexPoints(false);
			for (int p = 0; p < pts.length()-1; p++)
			{ 
				double d=(pts[p+1]-pts[p]).length();
				if (d>dEps && shortestSeg>d)
					shortestSeg = d;
			}
		}	

	// try to reconstruct
		//pl.simplify();
		PLine plTmp = pl;
		plTmp.reconstructArcs(dEps, 75);		
		{ 
			double d1 = plTmp.length();
			double d2 = pl.length();
			if (d2>0 && d1/d2>.8) // assuming conversion was successful
				pl = plTmp;
		}

		//pl.vis(2);

		Point3d pts[] = pl.vertexPoints(true);
		int num = pts.length();


	// Try to convert into a circle (accepting up to 3 segments to fail)
		double _radius; Point3d _ptCen;
		int bIsCircle = convertToCircle(pl, _ptCen, _radius);	

		
		//pl.vis(2);


		if (bIsCircle)
		{ 
		// refuse if already collected by tools				
			for (int i=0;i<plLocks.length();i++) 
			{ 
				PlaneProfile pp(pl);
				double a = pp.area();
				pp.joinRing(plLocks[i], _kSubtract);
				if (pp.area()<.1*a)
				{
//					Display dp(2);
//					dp.draw(PlaneProfile(plLocks[i]), _kDrawFilled, 60); 
//					dp.color(6);
//					dp.draw(PlaneProfile(pl), _kDrawFilled, 30);
					return out;
				}	
			}//next i
//			
			out++;

		// store tool	
			Map m;
			m.setPLine("arc", pl);
			m.setPoint3d("ptCen", _ptCen);
			m.setDouble("radius", _radius);
			m.setEntity("tent", parent);
			m.setString("subType", subType);
			m.setPLine("plShape", pl);
			
			mapIO.appendMap("entry", m);
			return out;
		}

	// collect arcs loop vertices
		for (int p = 0; p < pts.length(); p++)
		{
			Point3d pt1 = pts[p];
			Point3d pt2 = pts[p < num - 1 ? p + 1 : 0];
			Point3d ptm = (pt1 + pt2) * .5;
			double d12 = (pt1 - pt2).length();
			int bIsArc = d12>U(1) && (pl.closestPointTo(ptm) - ptm).length() > dEps;
			
			if (bIsArc)
			{						
			// reconstruct the arc/circle
				PLine arc(vecZ);
				arc.addVertex(pt1);
				double d1 = pl.getDistAtPoint(pt1);
				if (abs(d1 - pl.length()) < dEps) d1 = 0;
				arc.addVertex(pt2, pl.getPointAtDist(d1 + dEps));
				if (arc.length() < dEps) { continue; }
				
				Point3d ptmx = arc.ptMid();// midpoint on arc						
				Vector3d vecXS = arc.getTangentAtPoint(ptmx);
				Vector3d vecYS = vecXS.crossProduct(-vecZ);vecYS.normalize();
				if (ppRing.pointInProfile(ptmx+vecYS*dEps)==_kPointInProfile)	
					vecYS *= -1;
				
			// calculate radius from circular segment
				Vector3d vecCen = ptm - ptmx;
				double h = vecCen.length();
				if (h < dEps)
				{
					continue;
				}
				double s = (pt2 - pt1).length();
				double radius = (4 * pow(h,2) + pow(s, 2)) / (8 * h);
				vecCen.normalize();
				Point3d ptCen = ptmx + vecCen* radius;					
				
			// refuse if already collected by tools	// HSB-21420	
				int bLocked;
				for (int i=0;i<plLocks.length();i++) 
				{ 
					PlaneProfile pp(arc);
					double a = pp.area();
					pp.joinRing(plLocks[i], _kSubtract);
					if (pp.area()<.1*a)
					{
//						Display dp(2);
//						dp.draw(PlaneProfile(plLocks[i]), _kDrawFilled, 60); 
//						dp.color(6);
//						dp.draw(PlaneProfile(arc), _kDrawFilled, 30);
						bLocked = true;
						continue;
					}	
				}//next i				
				if (bLocked)
				{
					continue;
				}
				
				
				Point3d ptDev = plOrg.closestPointTo(ptmx);
				//ptDev.vis(1);				ptmx.vis(1);
				double deviation = (ptDev - ptmx).length();
				
				//pt1.vis(2);pt2.vis(2);ptm.vis(2);ptmx.vis(2);
				if (deviation>.5*shortestSeg ||d12<(ptm-ptmx).length()) // HSB-21420 Beam GL_1013
				{ 
					if (bDebug)
					{ 
						reportNotice("Deviation failure");
						PLine(ptm, ptmx).vis(1);
					}	
					continue;
					
				}	
				
				//arc.vis(4);	ptCen.vis(p);
				//Display dp(4); dp.draw(arc);PLine (arc.ptStart(), _PtW, arc.ptEnd()).vis(150);

			// store tool	
				Map m;
				m.setPLine("arc", arc);
				m.setPoint3d("ptCen", ptCen);
				m.setDouble("radius", radius);
				m.setEntity("tent", parent);
				m.setString("subType", subType);
				m.setPLine("plShape", pl);
				
				mapIO.appendMap("entry", m);
				
				out++;
			}
		}
		return out;
	}//End convertRing //endregion

	//region Function getToolSubTypes
	// returns a list of toolSubtypes and the corresponding quantity
	// gbs: the genbeams to check
	// numToolSubTypes: the total quantity of each collected tool type
	String[] getToolSubTypes(GenBeam gbs[], int& numToolSubTypes[])
	{ 
		String toolSubTypes[0];
		numToolSubTypes.setLength(0);
		
		for (int i=0;i<gbs.length();i++)
		{ 
			GenBeam& gb = gbs[i];
			if (gb.bIsDummy()){ continue;}
			AnalysedTool ats[]=gb.analysedTools();
			for (int j=0;j<ats.length();j++) 
			{ 
				String toolSubType =ats[j].toolSubType(); 
				int n = toolSubTypes.findNoCase(toolSubType ,- 1);
				if (n<0)
				{
					toolSubTypes.append(toolSubType);
					numToolSubTypes.append(1);						
				}
				else
				{ 
					numToolSubTypes[n]++;
				}
			}//next j			
		}		
		
		return toolSubTypes;
	}//End getToolSubTypes //endregion

////region Function GetEntitiesOfCollection
//	// returns the type of collection and appends all entitities of a MetalPartCollectionEnt, TrussEnt or CollectionEnt/Def 
//	// ce: the metalpart collection entity
//	// type: 1 = MetalPartCollectionEnt, 2 = TrussEnt, 3=CollectionEnt
//	int GetEntitiesOfCollection(Entity ref, Entity& ents[])
//	{ 	
//		int out;
//		
//		MetalPartCollectionEnt mp = (MetalPartCollectionEnt)ref;
//		TrussEntity te = (TrussEntity)ref;
//		CollectionEntity ce = (CollectionEntity)ref;
//		String def;
//		
//		Beam beams[0]; 
//		Sheet sheets[0]; 
//		TslInst tsls[0]; 
//		Entity entsCE[0];
//
//		if (mp.bIsValid())
//		{ 
//			MetalPartCollectionDef cd=mp.definitionObject();//HSB-23092
//			beams = cd.beam();
//			sheets = cd.sheet();
//			tsls = cd.tslInst();
//			entsCE = cd.entity();			
//			out = 1;
//		}
//		else if (te.bIsValid())
//		{ 
//			def = te.definition();
//			TrussDefinition cd(def);
//			beams = cd.beam();
//			sheets = cd.sheet();
//			tsls = cd.tslInst();
//			entsCE = cd.entity();			
//			out = 2;
//		}
//		else if (ce.bIsValid())
//		{ 
//			def = ce.definition();
//			CollectionDefinition cd(def);
//			beams = cd.beam();
//			sheets = cd.sheet();
//			tsls = cd.tslInst();
//			entsCE = cd.entity();			
//			out = 3;
//		}		
//		else
//		{ 
//			return out;
//		}
//
//		for (int i=0;i<beams.length();i++) 
//			if (!beams[i].bIsDummy() && ents.find(beams[i])<0)
//				ents.append(beams[i]);
//		for (int i=0;i<sheets.length();i++) 
//			if (!sheets[i].bIsDummy() && ents.find(sheets[i])<0)
//				ents.append(sheets[i]);
//		for (int i=0;i<entsCE.length();i++) 
//			if (ents.find(entsCE[i])<0)
//				ents.append(entsCE[i]);				
//		return out;
//	}//endregion
//
//	//region Function filterTrussEntities
//	// returns truss entities
//	// ents: the parent collection
//	TrussEntity[] filterTrussEntities(Entity ents[])
//	{ 
//		TrussEntity out[0];
//		for (int i=0;i<ents.length();i++) 
//		{ 
//			TrussEntity x= (TrussEntity)ents[i]; 
//			if (x.bIsValid())
//				out.append(x);
//		}//next i		
//		return out;				
//	}//End filterTrussEntities //endregion
//	
////region Function FilterMetalPartCollections
//	// returns MetalPartCollectionEnt entities
//	// ents: the parent collection
//	MetalPartCollectionEnt[] FilterMetalPartCollections(Entity ents[])
//	{ 
//		MetalPartCollectionEnt out[0];
//		for (int i=0;i<ents.length();i++) 
//		{ 
//			MetalPartCollectionEnt x= (MetalPartCollectionEnt)ents[i]; 
//			if (x.bIsValid())
//				out.append(x);
//		}//next i		
//		return out;				
//	}//endregion

//	//region Function filterCollectionEntities
//	// returns truss entities
//	// ents: the parent collection
//	CollectionEntity[] filterCollectionEntities(Entity ents[])
//	{ 
//		CollectionEntity out[0];
//		for (int i=0;i<ents.length();i++) 
//		{ 
//			CollectionEntity x= (CollectionEntity)ents[i]; 
//			if (x.bIsValid())
//				out.append(x);
//		}//next i		
//		return out;				
//	}//End filterCollectionEntities //endregion
//
////region Function filterTslsByName
//	// returns all tsl instances with a certain scriptname
//	// ents: the array to search, if empty all tsls in modelspace are taken
//	// names: the names of the tsls to be returned, all if empty
//	TslInst[] filterTslsByName(Entity ents[], String names[])
//	{ 
//		TslInst out[0];
//		int bAll = names.length() < 1;
//		
//		if (ents.length()<1)
//			ents = Group().collectEntities(true, TslInst(),  _kModelSpace);
//		
//		for (int i=0;i<ents.length();i++) 
//		{ 
//			TslInst t= (TslInst)ents[i]; 
//			//reportNotice("\ngetTslsByName: " + t.scriptName() +" "+names);
//			if (t.bIsValid())
//			{
//				if (!bAll && names.findNoCase(t.scriptName(),-1)>-1)
//					out.append(t);	
//				else if (bAll)
//					out.append(t);									
//			}
//				
//		}//next i
//
//		return out;
//	
//	}//End filterTslsByName //endregion

	//region Function getNestedGenBeamMaps
	// returns a list of genbeams which are nested or part of the set
	// t: the tslInstance to 
	String kParent = "ParentEnrtity", kDef = "Definition";
	Map getNestedGenBeamMaps(Entity ents[])
	{ 
		Map out;

		for (int i=0;i<ents.length();i++) 
		{ 
			Map m;
			
			GenBeam gb = (GenBeam)ents[i]; 
		// append unnested	
			if (gb.bIsValid()) 
			{
				if (gb.bIsDummy())
				{ 
					continue;
				}
				GenBeam gbs[] ={ gb};
				Map m;
				m.setEntityArray(gbs, true, "ent[]", "", "ent");
				out.appendMap("entry", m);				
				continue;
			}

			String def;
			MetalPartCollectionEnt mpce = (MetalPartCollectionEnt)ents[i];	
			TrussEntity te = (TrussEntity)ents[i];
			CollectionEntity ce = (CollectionEntity)ents[i];
			BlockRef bref = (BlockRef)ents[i];
			Element el = (Element)ents[i];
			GenBeam gbsNested[0];
			
			if (mpce.bIsValid())
			{
				def = mpce.definition();
				MetalPartCollectionDef cd = mpce.definitionObject();//HSB-23092
				gbsNested = cd.genBeam();
				m.setEntity(kParent, mpce);
			}
						
			else if (te.bIsValid())
			{
				def = te.definition();
				TrussDefinition cd(def);
				gbsNested = cd.genBeam();
				m.setEntity(kParent, mpce);
			}
						
			else if (ce.bIsValid())
			{
				def = ce.definition();
				CollectionDefinition cd(def);
				gbsNested = cd.genBeam();
				m.setEntity(kParent, mpce);
			}			
			else if (bref.bIsValid())
			{
				def = bref.definition();
				Block cd(def);
				gbsNested = cd.genBeam();
				m.setEntity(kParent, mpce);
			}	
			else if (el.bIsValid())
			{
				gbsNested = el.genBeam();
				m.setEntity(kParent, el);
			}
			
			for (int i=gbsNested.length()-1; i>=0 ; i--) 
				if (gbsNested[i].bIsDummy())
					gbsNested.removeAt(i); 
					
			if (gbsNested.length()>0)
			{ 
				m.setEntityArray(gbsNested, true, "ent[]", "", "ent");
				m.setString(kDef, def);
				out.appendMap("entry", m);
			}
			
		}//next i

		return out;
	}//End getNestedGenBeamMaps //endregion

	//region Function getGenbeamBodies
	// returns a list of bodies excluding dummies as specified shape type
	// gbs: the selection set
	// shapeMode: the shape mode 0=real, 1=basic, 2 = envelope
	Body[] getGenbeamBodies(GenBeam& gbs[], int shapeMode)//, Entity solids[]
	{
		//reportNotice("\nXX getGenbeamBodies:");
		Body out[0];
		for (int i=gbs.length()-1; i>=0 ; i--) 		
			if (gbs[i].bIsDummy())
				gbs.removeAt(i);
		for (int i=0;i<gbs.length();i++) 	
		{ 
			GenBeam g = gbs[i];				
			Body bd;
			if (shapeMode==0)
				bd = g.realBody();
			else if (shapeMode==1)
				bd = g.envelopeBody(true, true);
			else if (shapeMode==2)
				bd = g.envelopeBody();					
			if (!bd.isNull())
				out.append(bd);

		}
//		for (int i=0;i<solids.length();i++) 
//		{ 
//			Entity e = solids[i];
//			if (gbs.find(e)>-1){ continue;}
//			Body bd;
//			if (shapeMode<2)
//				bd = e.realBody();			
//			else
//			{
//				Quader q = e.bodyExtents();			
//				if (q.dX()>dEps && q.dY()>dEps && q.dZ()>dEps)
//				{ 
//					bd = Body(q.pointAt(0, 0, 0), q.vecX(), q.vecY(), q.vecZ(), q.dX(), q.dY(), q.dZ(), 0, 0, 0);
//				}
//			}
//			if (!bd.isNull())
//				out.append(bd);
//			 
//		}//next i
		
		return out;
	}//Function getGenbeamBodies //endregion 

//endregion 

//region Jigs

// Select Viewport
	String kJigViewport = "JigViewport";
	if (_bOnJig && _kExecuteKey==kJigViewport) 
	{
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point		
		
	    PlaneProfile pps[0];
	    for (int i=0;i<_Map.length();i++) 
	    	if (_Map.hasPlaneProfile(i))
	    		pps.append(_Map.getPlaneProfile(i));
		if (pps.length()>0)
			ptJig.setZ(pps[0].coordSys().ptOrg().Z());

	    
	    Display dp(-1);
	    drawArcs(pps, ptJig, dp);
   
	    return;
	}		

// Insert
	String kJigInsert = "JigInsert";
	if (_bOnJig && _kExecuteKey == kJigInsert)
	{
		Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point		
		PlaneProfile ppShape = _Map.getPlaneProfile("ppShape");
		Point3d ptRef = _Map.getPoint3d("ptRef");
		int bGetArcLength = _Map.getInt("GetArcLength");
		
		Vector3d vecZ = _Map.getVector3d("vecZ");
		Plane pn(ptRef, vecZ);

		Map mapArcs = _Map.getMap("mapArcs");

		Display dp(-1);

	//region Collect arcs and circles
		PLine arcs[0], plShapes[0];
		int bIsCloseds[0];
		double radii[0];
		Point3d ptCens[0];
		Entity tents[0];
		String uids[0];
		String subTypes[0];
		for (int i=0;i<mapArcs.length();i++) 
		{ 
			Map m = mapArcs.getMap(i);
			PLine arc = m.getPLine("arc");			//arc.vis(6);
			PLine shape = m.getPLine("plShape");
			Point3d ptCen = m.getPoint3d("ptCen");
			double radius = m.getDouble("radius");
			Entity tent= m.getEntity("tent");
			String subType= m.getString("subType");
		

			arcs.append(arc);
			bIsCloseds.append(arc.isClosed());
			radii.append(radius);
			ptCens.append(ptCen);
			tents.append(tent);
			uids.append(tent.handle());
			plShapes.append(shape);
			subTypes.append(subType);
	
		}//next i
	//endregion 


		PlaneProfile pps[] = createArcProfiles(arcs, pn);
		if (pps.length()>0)
			ptJig.setZ(pps[0].coordSys().ptOrg().Z());

	    
	    drawArcs(pps, ptJig, dp);

		int cur = findClosestArc(arcs, ptJig, vecZ);
		if (cur >- 1)
		{
			PLine arc = arcs[cur];
			Point3d ptLoc = arc.closestPointTo(ptJig);
			Point3d ptCen = ptCens[cur];
			int bIsCircle = bIsCloseds[cur];
			
			Map mapParams = _Map;
			
			if (bGetArcLength)
				mapParams.setPoint3d("ptArc", ptJig);
			
			
			Map mapTool = mapArcs.getMap(cur);
			if(mapTool.length()>0)
			{ 
				String k;
				double d;
				k = "Depth";	d =mapTool.getDouble(k);	if (d>dEps)mapParams.setDouble(k, d,_kLength);
				k = "Angle";	d =mapTool.getDouble(k);	if (d>dEps)mapParams.setDouble(k, d,_kAngle);
				k = "Bevel";	d =mapTool.getDouble(k);	if (d>dEps)mapParams.setDouble(k, d,_kAngle);
				k = "Twist";	d =mapTool.getDouble(k);	if (d>dEps)mapParams.setDouble(k, d,_kAngle);
			}
			
			if (bGetArcLength && !bIsCircle)
				drawDimAngular(ptLoc, ptCen, arc, mapParams);
			else
				drawDim(ptLoc, ptCen, arc, mapParams);
		}
		return;
	}

//endregion 

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="DimRadial";
	Map mapSetting;

// compose settings file location
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
	
//Configurations
	Map mapConfigs = mapSetting.getMap("Configuration[]");
	String sConfigurations[0];
	for (int i=0;i<mapConfigs.length();i++) 
	{ 
		Map m = mapConfigs.getMap(i);
		String name = m.getMapName();
		if (name.length()>0 && sConfigurations.findNoCase(name,-1)<0)
			sConfigurations.append(name);
	}//next i	

// painter creation mode
	String kPainterManagementMode = "PainterManagementMode";
	int nPainterManagementMode = mapSetting.getInt(kPainterManagementMode);
	if (_Map.hasInt(kPainterManagementMode))
		nPainterManagementMode = _Map.getInt(kPainterManagementMode);

// Global Settings
	String sTriggerGlobalSetting = T("|Global Settings|");
	String kGlobalSettings = "GlobalSettings", kGroupAssignment= "GroupAssignment";
	int nGroupAssignment;
	Map mapGlobalSettings = mapSetting.getMap(kGlobalSettings);
	if (mapGlobalSettings.hasInt(kGroupAssignment))
		nGroupAssignment = mapGlobalSettings.getInt(kGroupAssignment);	
//End Settings//endregion

//region PreRequisites Painter Collections
	String sPainterCollection = "Dimension\\";
	String sPainters[0],sAllPainters[] = PainterDefinition().getAllEntryNames().sorted();

	for (int i=0;i<sAllPainters.length();i++) 
	{ 
		int bAdd = nPainterManagementMode>0 || sAllPainters[i].find(sPainterCollection,0,false)==0;
		
		if (bAdd)
		{
			PainterDefinition pd(sAllPainters[i]);
			if (!pd.bIsValid())
			{ 
				continue;
			}
			
		// add painter name	
			String name = sAllPainters[i];
			if(nPainterManagementMode==0)
				name = name.right(name.length() - sPainterCollection.length());
			if (sPainters.findNoCase(name,-1)<0)
			{
				sPainters.append(name);
			}		
		}		 
	}//next i	
	
	int bFullPainterPath = sPainters.length() < 1 || nPainterManagementMode>0;
	if (bFullPainterPath)
	{ 
		for (int i=0;i<sAllPainters.length();i++) 
		{ 
			String s = sAllPainters[i];
			if (sPainters.findNoCase(s,-1)<0)
				sPainters.append(s);
		}//next i		
	}
	sPainters.insertAt(0, tDefaultEntry);	


//PreRequisites //endregion 

//Part #1 //endregion 

//region Properties

//region Behaviour
category = T("|Behaviour|");
	String tAutomatic = T("|Automatic|"), tRadial = T("|Radial|"), tDiametric = T("|Diametric|"),tArcMeasure=T("|Arc Measure|"),
		tConvex = T("|Convex|"), tConcave = T("|Concave|"),
		tRadialConvex = tRadial + " " + tConvex, tRadialConcave = tRadial + " " + tConcave,	
		tDiametricConvex = tDiametric + " " + tConvex, tDiametricConcave = tDiametric + " " + tConcave;
	String sModes[] ={tRadial, tDiametric,tArcMeasure, tAutomatic};
	//String sModes[] ={tRadial, tRadialConvex, tRadialConcave, tDiametric, tDiametricConvex, tDiametricConcave};
	String sModeName=T("|Dimension Mode|");	
	PropString sMode(0, sModes, sModeName,0);	
	sMode.setDescription(T("|Defines the Mode|"));
	sMode.setCategory(category);
	if (sModes.find(sMode) < 0)sMode.set(tAutomatic);
	int bIsRadial = sMode.find(tRadial, 0, false)>-1;
	int bIsDiametric = sMode.find(tDiametric, 0, false)>-1;
	int bIsArcMeasure = sMode.find(tArcMeasure, 0, false)>-1;
//	int bIsConvex = sMode.find(tConvex, 0, false)>-1;
//	int bIsConcave = sMode.find(tConcave, 0, false)>-1;
	int bIsAuto = sMode.find(tAutomatic, 0, false)>-1;
	
	String sPainterName=T("|Filter|");	
	String sPainterDesc = T(" |If a painter collection named 'Dimension' is found only painters of this collection are considered.|");
	PropString sPainter(1, sPainters, sPainterName);	
	sPainter.setDescription(T("|Defines the painter definition to filter entities|") +sPainterDesc );
	sPainter.setCategory(category);
	int nPainter = sPainters.find(sPainter);
	if (nPainter<0){ nPainter=0;sPainter.set(sPainters[nPainter]);}


//region Tool Set
	String kAll = "All";
	String sToolSetName=T("|Tool Set|");	
	PropString sToolSet(4, kAll, sToolSetName);	
	sToolSet.setDescription(T("|Defines the ToolSet|"));
	sToolSet.setCategory(category);
	//sToolSet.setReadOnly(bDebug?false:_kHidden);
	
	//Legacy: try to replace existing property value
	// previous versions did not suppurt tool sets but the sources list
	String tAnyArc = T("|Any Arc|"), tAnyDrill = T("|Any Drill|"), tPerpDrill = T("|Perpendicular Drills|"), 
		tBevelDrills = T("|Beveled Drills|"), tContourShape = T("|Contour|"), tOpeningShape = T("|Opening|"), tAnyShape = tContourShape+"+"+tOpeningShape;
	String sSources[] = {tDefaultEntry, tAnyArc,tAnyDrill,tPerpDrill,tBevelDrills,tContourShape,tOpeningShape,tAnyShape};			
	if (sSources.findNoCase(sToolSet ,- 1) >- 1)
	{
		String newVal = kAll;
		if (sToolSet == tContourShape)newVal=sToolTypes[0];
		else if (sToolSet == tOpeningShape)newVal=sToolTypes[1];
		else if (sToolSet == tAnyShape)newVal=sToolTypes[0]+";"+sToolTypes[1];
		sToolSet.set(newVal);	
	}
	String sToolSets[] = sToolSet.tokenize(";");
//endregion 

	String sStereotypeName=T("|TSL / Stereotype|");
	PropString sStereotype(5, "", sStereotypeName);	
	sStereotype.setDescription(T("|Defines a semicolon ';' separated list to filter sources by tool and/or tsl name|"));
	sStereotype.setCategory(category);
	//sStereotype.setReadOnly(bDebug?false:_kHidden);
	String sStereotypes[] = sStereotype.tokenize(";");


	// any face not implemented, difficult to compare rings of both faces
	String tFace1 = T("|Viewing Side|"), tFace2 = T("|Opposite Viewing Side|"), tFaceAny = T("|Any Viewing Side|"), sFaces[] ={ tFace1, tFace2, tFaceAny};//, tFaceAny
	String sFaceName=T("|Face|");	
	PropString sFace(7, sFaces, sFaceName);	
	sFace.setDescription(T("|Defines the Face|"));
	sFace.setCategory(category);

//endregion 

//region Display

category = T("|Display|");
	String sFormatName=T("|Text|");	
	PropString sFormat(2, "<>", sFormatName);	
	sFormat.setDescription(T("|Defines the content of the text.|") + 
		T(" |<> will use the text defined by the dimstyle including the scale|")+
		T(", |empty specifies the default value, use format variables to customize content|") + 
		T(", |(i.e. @(Radius:RL0) to show the radius without decimals)|"));
	sFormat.setCategory(category);
	{ 
		Map mapAdd;
		mapAdd.appendDouble("Radius", U(260),_kLength);// dummy data
		mapAdd.appendDouble("Diameter", U(520),_kLength);// dummy data
		mapAdd.appendDouble("CoordX", U(320),_kLength);// dummy data
		mapAdd.appendDouble("CoordY", U(420),_kLength);// dummy data
		sFormat.setDefinesFormatting("GenBeam", mapAdd);
	}

//region DimStyles
	// Find DimStyle Overrides, order and add Linear only
	String sDimStyles[0], sSourceDimStyles[0];
	getDimStyles(bIsRadial, sDimStyles, sSourceDimStyles);

	String sDimStyleName=T("|Dimstyle|");	
	PropString sDimStyle(3, sDimStyles.sorted(), sDimStyleName);	
	sDimStyle.setDescription(T("|Defines the Dimstyle|"));
	sDimStyle.setCategory(category);
	String dimStyle = sSourceDimStyles[sDimStyles.find(sDimStyle,0)];
	if (_DimStyles.findNoCase(dimStyle ,- 1) < 0)dimStyle = _DimStyles.first();
//endregion

	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(0), sTextHeightName, _kLength);	
	dTextHeight.setDescription(T("|Defines the text height of the dimension|") + T(", |0 = byDimstyle|"));
	dTextHeight.setCategory(category);	
	
	String sGraphicScaleName=T("|Graphical Scale Factor|");	
	PropDouble dGraphicScale(nDoubleIndex++, 25, sGraphicScaleName,_kNoUnit);	
	dGraphicScale.setDescription(T("|Defines a factor to rescale arrows, dashes etc of the dimension|"));
	dGraphicScale.setCategory(category);
	if (dGraphicScale <= 0)dGraphicScale.set(1);

	String sLeaderLengthName=T("|Leader Length|");	
	PropDouble dLeaderLength(nDoubleIndex++, U(0), sLeaderLengthName, _kLength);	
	dLeaderLength.setDescription(T("|Defines the length of the leader|"));
	dLeaderLength.setCategory(category);
	dLeaderLength.setReadOnly(bDebug?false:_kHidden);
	
	String sUnitScaleName=T("|Unit Scale|");	
	PropDouble dUnitScale(nDoubleIndex++, 1, sUnitScaleName,_kNoUnit);	
	dUnitScale.setDescription(T("|Defines the scale factor to override drawing units by the given factor|") + T("|Read only value if format contains <>|"));
	dUnitScale.setCategory(category);
	if (dUnitScale<0)dUnitScale.set(1);
	if (sFormat.find("<>",0, false)>-1)
	{ 
		dUnitScale.setReadOnly(_kReadOnly);
		dUnitScale.set(1);
	}

	String sColorName=T("|Color|");	
	PropInt nColor(nIntIndex++, -1, sColorName);	
	nColor.setDescription(T("|Defines the Color of the dimension|") + T("|This option requires the dimstyle to be defined with colors byBlock|"));
	nColor.setCategory(category);

//endregion 	

category = T("|Distribution Rules|");
	String sDistributionName=T("|Distribution|");	
	String tAllArc = T("|All|"), tOneBySource = T("|One by Source|"), tOneByRadius = T("|One by Radius|");
	String sDistributions[] = {tDefaultEntry, tAllArc,tOneBySource,tOneByRadius };
	PropString sDistribution(6,sDistributions, sDistributionName);	
	sDistribution.setDescription(T("|Defines how multiple arcs and drills are dimensioned|") + T(", |Default = byRadius|"));
	sDistribution.setCategory(category);
	sDistribution.setReadOnly((bDebug || _Viewport.length()>0)?false:_kHidden);

//End Properties //endregion

//region References

//region Flags
	int bHasPage, bHasSection, bInBlockSpace, bHasSDV, bHasViewport = _Viewport.length() > 0, bIsHsbViewport, bHasWcs;	
	int	bIsViewportSetup;	// true if the instance is a setup instance placed outside of paperspace

	addRecalcTrigger(_kGripPointDrag, "_Grip");	
	addRecalcTrigger(_kGripPointDrag, "_Pt0");
	
	int bIsBlockCreationMode = _Map.getInt(kBlockCreationMode);	
	if (_Entity.length()<1 && bIsBlockCreationMode) // Blockspace creation: the multipage is not valid when creating the tsl instance
	{ 
		return;
	}	
			
//endregion 

//region Grip
	int indexOfMovedGrip = Grip().indexOfMovedGrip(_Grip);
	int bOnDragEnd,bDrag;
	Vector3d vecOffsetApplied;
	Grip grip;
	if (indexOfMovedGrip>-1)
	{ 
		bDrag = _bOnGripPointDrag && _kExecuteKey=="_Grip";
		bOnDragEnd = !_bOnGripPointDrag;		
		grip= _Grip[indexOfMovedGrip];
		vecOffsetApplied = grip.vecOffsetApplied();
	}
	
	String kGripLoc = "Location", kGripLeader = "Leader", kGripArcLength = "ArcLength";
	int nGripLoc = getGripByName(_Grip, kGripLoc);
	Point3d ptLoc =nGripLoc>-1?_Grip[nGripLoc].ptLoc():_Pt0;
	if (_Map.hasPoint3d("ptLoc") && nGripLoc<0)  // BlockCreationMode sets location grip
	{ 
		ptLoc = _Map.getPoint3d("ptLoc");
//		_Grip.setLength(0);
//		nGripLoc = - 1;
//		
//		_Map.removeAt("ptLoc", true);
	}
	int nGripLeader = getGripByName(_Grip, kGripLeader);
	int nGripArcLength = getGripByName(_Grip, kGripArcLength);
	double leaderLength = dLeaderLength;
	
	
//endregion 

//region Entities
	MultiPage page;
	ShopDrawView sdvs[0];
	GenBeam gb;
	EntPLine epl;	
	MetalPartCollectionEnt mpce;
	TrussEntity te;
	CollectionEntity ce;
	Element el;
	Entity entDefine, showSet[0];
	Element elParent;
	Section2d section;ClipVolume clipVolume;
	
	CoordSys cs(),ms2ps, ps2ms;
	double dScale = 1;
	Vector3d vecX=_XU, vecY=_YU, vecZ = _ZU, vecZM =_ZU;
	int bDeltaOnTop = true;	
	
	int nActiveZoneIndex = - 999;
	
	Point3d ptOrg = _Pt0;
	Map mapX; String kKeyX = "DimInfo";
	
	Viewport vp;		
//endregion 

//endregion 	

//region OnInsert #1
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }

	// get current space and property ints
		int bInLayoutTab = Viewport().inLayoutTab();
		int bInPaperSpace = Viewport().inPaperSpace();
		int bInBlockSpace, bHasSDV;



	//region Determine types to be selected and showDialog
		int bSelectPage, bSelectEnt;
		
		Entity entsSDV[]= Group().collectEntities(true, ShopDrawView(), _kModelSpace);
		int bSelectSDV = entsSDV.length() > 0;
		
		if (bInLayoutTab || bSelectSDV)
		{ 
			sToolSet.setReadOnly(false);
			sStereotype.setReadOnly(false);
			sDistribution.setReadOnly(false);				
		}

	// silent/dialog
		if (_kExecuteKey.length()>0 && TslInst().getListOfCatalogNames(scriptName()).findNoCase(_kExecuteKey,-1)>-1)
			setPropValuesFromCatalog(_kExecuteKey);						
	// standard dialog	
		else	
			showDialog();

	//legacy check
		if (sSources.findNoCase(sToolSet ,- 1) >- 1)
		{
			String newVal = kAll;
			if (sToolSet == tContourShape)newVal=sToolTypes[0];
			else if (sToolSet == tOpeningShape)newVal=sToolTypes[1];
			else if (sToolSet == tAnyShape)newVal=sToolTypes[0]+";"+sToolTypes[1];
			sToolSet.set(newVal);	
		}



		bIsRadial = sMode.find(tRadial, 0, false)>-1;
		bIsAuto = sMode.find(tAutomatic, 0, false)>-1;
//		bIsConvex = sMode.find(tConvex, 0, false)>-1;
//		bIsConcave = sMode.find(tConcave, 0, false)>-1;	
	//endregion 

	//region Prompt for selection
	
	// PaperSpace
		if (bInLayoutTab && bInPaperSpace)
		{
			_Viewport.append(getViewport(T("|Select a viewport|")));
			bHasViewport=true;
			vp = _Viewport.first();
			elParent = vp.element();
			bIsHsbViewport = elParent.bIsValid();
		
		// switch to modelspace to select entities
			if(!bIsHsbViewport)
			{ 
				bSelectEnt = true;
				int bSuccess = Viewport().switchToModelSpace();
				bSuccess = _Viewport[0].setCurrent();	
			}
		}
	// ModelSpace	
		else
			bSelectEnt = true;
			
			
		if(bSelectEnt)	
		{ 
			bSelectPage= Group().collectEntities(true, MultiPage(), _kModelSpace, false).length()>0;
			int bSelectSection= Group().collectEntities(true, Section2d(), _kModelSpace, false).length()>0;
		
		// prompt for entities			
			String prompt = T("|Select reference|"), prompt2;
			if (bSelectSDV)
				prompt2 += T("|Shopdraw Viewport|");
			if (bSelectPage)
				prompt2 += (prompt2.length()>0?", " :"")+T("|Multipage|");
			if (bSelectSection)
				prompt2 += (prompt2.length()>0?", " :"")+T("|Section|");	

			if (prompt2.length()<1)
				prompt = T("|Select reference (genbeams, elements, collections, polylines|");
			else
			{
				prompt2 += T(" |or other hsb entities|");
				prompt2 = " (" + prompt2 + ")";
			}
				
			PrEntity ssE(prompt + prompt2, GenBeam());
			if (bSelectPage && !bHasViewport)
			{
				ssE.addAllowedClass(MultiPage());
			}
			if (!bIsHsbViewport)ssE.addAllowedClass(Element());
			ssE.addAllowedClass(ChildPanel());	
			ssE.addAllowedClass(EntPLine());
			ssE.addAllowedClass(MetalPartCollectionEnt());
			ssE.addAllowedClass(TrussEntity());
			ssE.addAllowedClass(CollectionEntity());
			if (bSelectSection && !bHasViewport)ssE.addAllowedClass(Section2d());
			if (bSelectSDV&& !bHasViewport)ssE.addAllowedClass(ShopDrawView());
			
			if (ssE.go())
				_Entity.append(ssE.set());			
		}
	
		if (bHasViewport && !bIsHsbViewport)
		{ 
			int bSuccess = Viewport().switchToPaperSpace();	
		}
		
	//endregion 	

	}	
	
	int nFaceMode =sFaces.find(sFace,0);
	if (nFaceMode < 0)nFaceMode = 0;	
	int nFace = nFaceMode!=0?-1:1;
	//else if (nFaceMode==2)nFace=0;
	
	int bSelectAll = sToolSet == kAll || sToolSet=="";
	int bSelectContour = sToolSet.find(sToolTypes[0] ,0, false) > -1;
	int bSelectOpening = sToolSet.find(sToolTypes[1] ,0, false) > -1;
//endregion 

//region Paperspace Viewport
	if (bHasViewport)
	{ 
		vp = _Viewport.first();
		dScale = vp.dScale();
		ms2ps = vp.coordSys();
		ps2ms = ms2ps;	ps2ms.invert();
		vecX = _XW; vecY = _YW; vecZ = _ZW;
		vecZM = vecZ;	vecZM.transformBy(ps2ms);	vecZM.normalize();
	
		elParent = vp.element();
		bIsHsbViewport = elParent.bIsValid();

		if(bIsHsbViewport)
		{ 
			nActiveZoneIndex = vp.activeZoneIndex();
			entDefine = elParent;
			GenBeam genbeams[] = elParent.genBeam();
			for (int i=0;i<genbeams.length();i++) 
			{ 
				GenBeam& g = genbeams[i];
				int z = g.myZoneIndex();
				
			// collect all to filter by painter or if activezone is set to all, else only zones matching the active zone	
				if (sPainter!=tDefaultEntry || nActiveZoneIndex==999 || z==nActiveZoneIndex)
					showSet.append(g);					 
			}					
		}
		else
			showSet.append(_Entity);	
	}
	//endregion	

//region Entity based
	else
	{
	//region Collect showset from container entities such as multipage, section etc
		for (int i = 0; i < _Entity.length(); i++)
		{
			Entity& e = _Entity[i];
			
		//region ShopDrawView
			ShopDrawView sdv = (ShopDrawView)e;
			if (sdv.bIsValid())
			{
				bHasSDV = true;
				sDistribution.setReadOnly(false);
				sStereotype.setReadOnly(false);
				sToolSet.setReadOnly(false);
				sdvs.append(sdv);
				//continue;
				
				if (_bOnInsert)
				{ 
					_Pt0 = getPoint(T("|Pick location for setup graphics|"));
					return;					
				}
			}
			//endregion 
			
		//region Multipage
			page = (MultiPage)e;
			if (page.bIsValid())
			{
				bHasPage = true;
				setDependencyOnEntity(e);
				assignToGroups(e, 'D'); // TODO layer assignment
				entDefine = page;
				MultiPageView mpv, mpvs[] = page.views();
				Vector3d vecModelView = _Map.getVector3d("ModelView");
				showSet = page.showSet();
				
			//region Get Multipage Viewport on insert
				if (_bOnInsert)
				{ 
				//Collect all viewport profiles and the associated multipage view
					Map mapArgs;
					PlaneProfile ppVPs[0];
					mapArgs = getMultipageViewProfiles(mpvs, ppVPs);
					
				//region Select a viewport of the multipage
					if (ppVPs.length() >1)
					{
						Point3d pt;
						
						PrPoint ssP(T("|Select viewport|")); //second argument will set _PtBase in map
						ssP.setSnapMode(TRUE, 0); // turn off all snaps
						int nGoJig = - 1;
						while (nGoJig != _kOk && nGoJig != _kNone)
						{
							nGoJig = ssP.goJig(kJigViewport, mapArgs);
							if (nGoJig == _kOk)
							{
								pt = ssP.value(); //retrieve the selected point
								pt.setZ(0);
								
								// get the index of the closest viewport
								double dMin = U(10e6);
								
								for (int i = 0; i < ppVPs.length(); i++)
								{
									double d = (ppVPs[i].closestPointTo(pt) - pt).length();
									if (d < dMin)
									{
										dMin = d;
										//reportMessage(TN("|view| i "+i));
										
										MultiPageView view = mpvs[i];
										ms2ps = view.modelToView();
										ps2ms = ms2ps;
										ps2ms.invert();
									}
								}//next i
							}
							else if (nGoJig == _kCancel)
							{
								eraseInstance(); //do not insert this instance
								return;
							}
						}
						ssP.setSnapMode(false,0); // turn off all snaps
					}
				//endregion 			
		
				// store model view	
					vecModelView = _ZW;
					vecModelView.transformBy(ps2ms);
					vecModelView.normalize();
					_Map.setVector3d("ModelView", vecModelView);					
				}					
			//endregion 
				
			//region Keep Grips at location when moving the mulztipage
				ptOrg = page.coordSys().ptOrg();	//ptOrg.vis(2);
				Vector3d vecOrg = ptOrg-_Pt0;
				if (!vecOrg.bIsZeroLength() && !bDrag && !_bOnInsert)
				{ 	
					_Pt0.transformBy(vecOrg);
					for (int g=0;g<_Grip.length();g++) 
					{ 
						Point3d pt = _Grip[g].ptLoc(); 						
						pt.transformBy(vecOrg);
						_Grip[g].setPtLoc(pt);
					}//next g
	
					setExecutionLoops(2);
					return;
				}
				if (!_bOnInsert)	
					_Pt0 = ptOrg;				
			//endregion 	
			
			//region Get selected view of multipage				
				if (vecModelView.bIsZeroLength() && !_bOnInsert)
				{
					reportNotice("\nunexpected error collecting the corresponding view");
				}			
				for (int i = 0; i < mpvs.length(); i++)
				{
					ms2ps = mpvs[i].modelToView();
					ps2ms = ms2ps; ps2ms.invert();
					vecZM = _ZW;
					vecZM.transformBy(ps2ms);	vecZM.normalize();
					if (vecModelView.isCodirectionalTo(vecZM))
					{
						mpvs[i].plShape().vis(i);
						showSet = mpvs[i].showSet();
						dScale = mpvs[i].viewScale();
						vecZM.vis(_Pt0, 150);
//						vecModelView.vis(_Pt0, 2);
						break; //ms2ps is set now
					}
				}//next i//endregion 	
				
				break; //only one page allowed
			}
			//endregion 
			
		//region Section
			section = (Section2d) e;
			if (section.bIsValid())
			{
				bHasSection = true;
				setDependencyOnEntity(e);
				assignToGroups(e, 'D');
				entDefine = e;
				
				ms2ps = section.modelToSection();
				ps2ms = ms2ps; 	ps2ms.invert();
				vecX = _XW; vecY = _YW; vecZ = _ZW;
				
				vecZM = _ZW;
				vecZM.transformBy(ps2ms);	vecZM.normalize();
				
				// clip volume		
				clipVolume = section.clipVolume();
				if ( ! clipVolume.bIsValid())
				{
					eraseInstance();
					return;
				}
				_Entity.append(clipVolume);
				setDependencyOnEntity(clipVolume);
				showSet = clipVolume.entitiesInClipVolume(true);
				
				
				break; //only one section allowed
			}
			//endregion
		}
	//Collect showset from container //endregion 
	
	//region Collect showset of model selection set
		if (!bHasPage && !bHasSDV && !bHasSection)
		{ 
			for (int i = 0; i < _Entity.length(); i++)
			{
				Entity& e = _Entity[i];	
		
				MetalPartCollectionEnt mpce = (MetalPartCollectionEnt)e;
				TrussEntity te = (TrussEntity)e;
				CollectionEntity ce = (TrussEntity)e;
				if (mpce.bIsValid() ||te.bIsValid() ||ce.bIsValid())
				{ 
					showSet.append(ce);
					continue;
				}					
	
				EntPLine epl = (EntPLine) e;
				if (epl.bIsValid())	
				{ 
					PLine pl = epl.getPLine();
					if (pl.isClosed() || pl.vertexPoints(true).length()>2)
						showSet.append(epl);
					continue;	
				}
			
				GenBeam gb = (GenBeam) e;
				if (gb.bIsValid())	
				{ 
					showSet.append(gb);
					continue;
				}
			}			
		}	
		if (bHasSDV ||bHasPage)
			;
		else if (_Entity.length()<1 || showSet.length()<1)
		{ 
			reportMessage("\n" + scriptName() + T(" |no reference found|") + "\n" +
				T("|Selection set| (") + _Entity.length() + T("), |Show set| (") + showSet.length()+")");
			
			if (!bDebug)eraseInstance();
			return;
		}
		else
			entDefine = showSet.first();
		assignToGroups(entDefine, 'D');
	//Collect Entities //endregion 	

	}
	//reportNotice("\nShowset returned " + showSet.length() + " Page: "+ bHasPage);
//Entity based //endregion 

//region Display
	int bUseTextHeight;
	Display dpJig(-1), dp(nColor);
	dpJig.trueColor(darkyellow, 50);
	dp.dimStyle(dimStyle, dScale);
	dp.addHideDirection(vecX);
	dp.addHideDirection(-vecX);
	dp.addHideDirection(vecY);
	dp.addHideDirection(-vecY);
	
	double textHeight = dTextHeight*dScale;
	double textHeightForStyle = dp.textHeightForStyle("O", dimStyle)*dScale;
	double dDimScale = (dGraphicScale>0?dGraphicScale:1)*dScale;
	if (dTextHeight<=0) 
		textHeight = textHeightForStyle;
	else 
	{
		bUseTextHeight = true;
		dp.textHeight(textHeight);
	}

//endregion 

//region Dim plane and prop lists
	bHasWcs = bHasPage  || bHasSDV || bHasSection || bHasViewport;

	// legacy: grip location was specified by vector -> reset to default = 0
	if (_Map.hasVector3d("vecOrgLeader") && dLeaderLength>dEps)
	{ 
		dLeaderLength.set(0);
		_Map.removeAt("vecOrgLeader", true);
	}

	int nProps[]={nColor};			
	double dProps[]={dTextHeight,dGraphicScale,dLeaderLength,dUnitScale};				
	String sProps[]={sMode, sPainter,sFormat,sDimStyle,sToolSet,sStereotype,sDistribution,sFace};
	Plane pn(_Pt0, vecZ);
	if (bHasWcs)pn = Plane(_PtW, _ZW);
//endregion 

//region Painter and parameter list
	String sPainterDef = bFullPainterPath ? sPainter : sPainterCollection + sPainter;
	PainterDefinition pdDim(sPainterDef);
	
	String sTypeDim, sTypeRef;
	int bIsValidPDdim, bIsValidPDRef;
	if (!bHasSDV && pdDim.bIsValid())
	{ 
		sTypeDim = pdDim.type();
		bIsValidPDdim = true;
		setDependencyOnDictObject(pdDim);
		
		int num = showSet.length();
		showSet = pdDim.filterAcceptedEntities(showSet);
		
		if (showSet.length()<1)
		{ 
			reportNotice("\n" + T("|The selected painter filters all entities|\n") + sPainterDef + TN("|Tool will be deleted|"));
			eraseInstance();
			return;
		}
		
	}
	int bIsTrussPD = bIsValidPDdim && sTypeDim== "TrussEntity";
	int bIsGenBeamPD = bIsValidPDdim && (sTypeDim== "GenBeam" || sTypeDim == "Beam"  || sTypeDim == "Sheet"  || sTypeDim == "Panel");
	int bIsOpeningPD = bIsValidPDdim && (sTypeDim == "Opening" || sTypeDim == "OpeningSF");
	int bIsElementPD = bIsValidPDdim && (sTypeRef == "Element" || sTypeRef== "ElementWallSF"|| sTypeRef== "ElementRoof");

	int bGetArcLength = sFormat.find("ArcLength",0, false) >- 1;

	Map mapParams;
    mapParams.setVector3d("vecX", vecX);
    mapParams.setVector3d("vecY", vecY);
    mapParams.setVector3d("vecZ", vecZ);
    mapParams.setPoint3d("ptRef", _Pt0);
    mapParams.setInt("dimType", bIsAuto?3:(bIsRadial?0:(bIsDiametric?1:2)));
    mapParams.setDouble("textHeight", textHeight);
    mapParams.setDouble("dimScale", dDimScale);
    mapParams.setDouble("Scale", dScale);
	mapParams.setDouble("UnitScale", dUnitScale);	
	mapParams.setString("dimStyle", dimStyle);
	mapParams.setString("dimStyleUI", sDimStyle);
	mapParams.setInt("color", nColor);
	mapParams.setInt("GetArcLength", bGetArcLength);

//endregion 

//region Blockspace Mode
	int bIsBlockSpaceSetup;
	Entity entCollector;
	Vector3d vecZViews[0];
	int bDebugCreation;// = true;
	if (bHasSDV)
	{ 
	//region On generate shopdrawing
		if (_bOnGenerateShopDrawing)
		{ 
		// Get multipage from _Map
			entCollector = _Map.getEntity(_kOnGenerateShopDrawing +"\\entCollector");	
			Map mapTslCreatedFlags = entCollector.subMapX("mpTslCreatedFlags");
			String uid = _Map.getString("UID"); // get the UID from map as instance does not exist onGenerateShopDrawing
			int bIsCreated = mapTslCreatedFlags.hasInt(uid);
			
			MultiPage page = (MultiPage)entCollector;
			if (page.bIsValid())
			for (int v=0;v<sdvs.length();v++) 
			{ 
				if (bDebugCreation)reportNotice("\ncreating sdv " + v + " for uid " + uid);
				ShopDrawView sdv = sdvs[v]; 
				
				ViewData viewDatas[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets, 0);
				int nIndFound = ViewData().findDataForViewport(viewDatas, sdv);//find the viewData for my view

			// Create modelspace instance if not tagged as being created
				if (entCollector.bIsValid() && nIndFound>-1)
				{ 
					ViewData viewData = viewDatas[nIndFound];
				
					Entity ents[] = viewData.showSetDefineEntities();
					for (int i=0;i<ents.length();i++) 
						if (showSet.find(ents[i])<0)
							showSet.append(ents[i]); 

				// Transformations
					ms2ps = viewData.coordSys();
					ps2ms = ms2ps;
					ps2ms.invert();				
			
				// the viewdirection of this shopdrawview in modelspace
					Vector3d vecAllowedView = _ZW;
					vecAllowedView.transformBy(ps2ms);
					vecAllowedView.normalize();
					vecZViews.append(vecAllowedView);
			
				// create TSL
					if (!bIsCreated)
					{ 
						TslInst tslNew;
						GenBeam gbsTsl[] = {};		Entity entsTsl[] = {entCollector};			Point3d ptsTsl[] = {_Pt0};

						Map mapTsl;	
						mapTsl.setVector3d("ModelView", vecAllowedView);// the offset from the viewpport
						mapTsl.setInt(kBlockCreationMode, true);
			
						tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			
			
						if (tslNew.bIsValid())
						{
							if (bDebugCreation)reportNotice(" succeeded " + tslNew.handle() + " " + vecAllowedView);
//							if (nColor==-1 && _Map.hasInt("Color"))
//								tslNew.setColor(_Map.getInt("Color"));
							//reportNotice("\nBlockCreator done");
							tslNew.transformBy(Vector3d(0, 0, 0));
						}						
					}
				
				}					 
			}//next v			

		// flag entCollector such that on regenaration no additional instances will be created	
			if (!bIsCreated)
			{
				bIsCreated=true;
				mapTslCreatedFlags.setInt(uid, true);
				entCollector.setSubMapX("mpTslCreatedFlags",mapTslCreatedFlags);
			}

		}			
	//endregion 

	//region Draw BlockSpace Setup #BS
		else
		{
			bIsBlockSpaceSetup = true;
			_Map.setString("UID", _ThisInst.uniqueId()); //store UID to have access during _kOnGenerateShopDrawing
			addRecalcTrigger(_kGripPointDrag, "_PtG0");
			
		//region Get bounds of viewports
			PlaneProfile ppBounds[0];
			for (int j = 0; j < sdvs.length(); j++)
			{
				ShopDrawView sdv = sdvs[j];
				setDependencyOnEntity(sdv);
				PlaneProfile pp = getPlaneProfileShopdrawViewport(sdv);
				//pp.extentInDir(_XW).vis(j);
				ppBounds.append(pp);			

			// draw guide line
				Point3d pt1, pt2, pt3, pt4;
				pt1 = _Pt0;
				pt4 = pp.closestPointTo(pt1);
				Point3d ptMid = (pt1 + pt4) / 2;	//ptMid.vis(6);
				{ 
					Vector3d vec = ptMid - pt4; 
					double d = vec.length();
					vec.normalize();
					pt3 = pt4 + vec * .5 * d;
				}
				pt2 = pt1-_YW*_YW.dotProduct(pt1-ptMid);
				PLine pl (pt1, pt2, pt3, pt4);
				if (pl.length()>3*textHeight)
				{
					pl.trim(3*textHeight, false);
					dp.draw(pl);
				}


			// draw node
				PLine plCir; plCir.createCircle(pt4, _ZW, U(5));
				plCir.convertToLineApprox(dEps);
				dp.draw(plCir);
				dp.draw(PlaneProfile(plCir), _kDrawFilled, 50);					
			}//next i
		//endregion 			
		
		//region Draw Pseudo Dim Object	
			int bIsContour = sToolSets.findNoCase(sToolTypes[0] ,- 1)>-1;
			int bIsOpening = sToolSets.findNoCase(sToolTypes[1] ,- 1)>-1;
			int bIsDrill= sToolSet.find("_kAD",0, false)>-1;
			int bIsMortise= sToolSet.find("_kAM",0, false)>-1;

			
		// get shape (drill or contour)
			PLine shape; 
			double dRadius = textHeight*1.5;
			Point3d ptsCen[0], ptCen = _Pt0;
			if (bIsDrill)
			{
				shape.createCircle(ptCen, _ZW, dRadius);
			}
			else
			{ 
				dRadius = .5*textHeight;
				shape.createRectangle(LineSeg(_Pt0 - (_XW + _YW) * textHeight, _Pt0 + (_XW + _YW) * textHeight), _XW, _YW);
				ptsCen = shape.vertexPoints(true);
				shape.offset(-.5 * textHeight, true);
			}
			dp.draw(shape);

		// Get center and point on arc	
			Vector3d vecArc = _XW + _YW; vecArc.normalize();
			Point3d ptX = shape.closestPointTo(_PtG.length()>0?_PtG[0]:_Pt0 + (_XW + _YW) * 1.5 * textHeight);
			if (!bIsDrill)// get closest ptCen
			{ 
				double dMin = textHeight * 3;
				for (int i=0;i<ptsCen.length();i++) 
				{ 
					double d =(ptsCen[i]-ptX).length(); 
					if (d<dMin)
					{ 
						dMin = d;
						ptCen = ptsCen[i];
					}					 
				}//next i	
			}

		//Draw Pseudo Dim Object //endregion 	

		//region Grip Management
			if (_PtG.length()<1)
			{ 
				vecArc = _XW + _YW;
				vecArc.normalize();
				ptX = shape.closestPointTo(ptCen + vecArc * dRadius);
				
				Point3d pt = ptX;
				if (dLeaderLength>0)
					pt += vecArc * dLeaderLength;
				_PtG.append(pt);	
			}
			else
			{ 
				vecArc = _PtG[0] - ptCen; vecArc.normalize();
				ptX = ptCen + vecArc * dRadius;
			}
			
			if (_kNameLastChangedProp=="_PtG0")
			{ 
				dLeaderLength.set(abs(vecArc.dotProduct(_PtG[0] - ptX)));
			}

		//endregion 

		//region Dim
			if (_kNameLastChangedProp==sLeaderLengthName)
			{
				Point3d pt = ptX;
				if (dLeaderLength>0)
					pt += vecArc * dLeaderLength;
				_PtG[0]=pt;	
			}
			
			
			PLine arc(_ZW);
			Vector3d vecx = _XW; if (_XW.dotProduct(_PtG[0] - _Pt0) < 0)vecx *= -1;
			Vector3d vecy = _YW; if (_YW.dotProduct(_PtG[0] - _Pt0) < 0)vecy *= -1;
				
			arc.addVertex(_Pt0+vecx * textHeight * 1.5+vecy * textHeight);
			arc.addVertex(_Pt0+vecy * textHeight * 1.5+vecx * textHeight, tan(22.5));
			
			
			ptX.vis(4);

		// Additional data
			Map mapAdd;
			mapAdd.setDouble("<>", sMode  == tRadial?dRadius*dUnitScale:dRadius*2*dUnitScale,_kLength);
			mapAdd.setDouble("Radius", dRadius*dUnitScale,_kLength);
			mapAdd.setDouble("Diameter", 2*dRadius*dUnitScale,_kLength);
			if (bGetArcLength)
				mapAdd.setDouble("ArcLength", arc.length()*dUnitScale,_kLength);//arcs[i].length()
//			mapAdd.setDouble("CoordX", ptCen.X()*dUnitScale,_kLength);
//			mapAdd.setDouble("CoordY", ptCen.Y()*dUnitScale,_kLength);

		// Text
			String sThisFormat;
			if (sFormat.length() < 1)
			{
				if (sMode==tArcMeasure)
					sThisFormat = "@(ArcLength:RL1)";			
				else
					sThisFormat="<>";
			}
			else
				sThisFormat = sFormat;

			
			Entity entFormat=_ThisInst;	
			String text= entFormat.formatObject(sThisFormat, mapAdd);
			text = text.trimLeft().trimRight();
			if(bGetArcLength && sFormat.find("ArcLength",0,false)==2)// add prefix
				text = kArcLengthSymbol + text;
//
			mapParams.setString("text", text);
			//mapParams.setDouble("leaderLength", dLeaderLength);
			//mapParams.setPoint3d("ptLeader", ptX);
			
			if (!bIsDrill && bGetArcLength && bIsAuto)
			{ 
				//arc.vis(2);
				drawDimAngular(ptX, ptCen, arc, mapParams);
		
			}
			else
			{ 
				drawDim(ptX, ptCen, shape, mapParams);		
			}			
			
		//region draw setup info text

			int n;
			text="";
			if (sToolSet.length()>0)
			{ 
				if (sToolSet==kAll)
					text =T("|" + kAll + "|");					
				else if (bIsContour && bIsOpening)
					text = T("|Circumference|");					
				else
				{
					if (bIsContour)text += (text.length()>0?", ":"")+T("|Contour|");
					if (bIsOpening)text += (text.length()>0?", ":"")+T("|Opening|");
				}

				if (bIsDrill)text += (text.length()>0?", ":"")+T("|Drills|");							
				if (bIsMortise)text += (text.length()>0?", ":"")+T("|Mortises|");
										
				if (text.length()>0)
					n++;
			}	
			else
			{ 
				text += T("|" + kAll + "|");
				n++;
			}
			if (sPainter!=tDefaultEntry && pdDim.bIsValid())
			{
				text += "\n"+sPainter;
				n++;
			}				
			if (sStereotype.length()>0)
			{ 
				text += "\n"+sStereotype;
				n++;
			}				
			if (sDistribution.length()>0)
			{ 
				text += "\n"+sDistribution;
				n++;
			}				

			dp.textHeight(textHeight / n);
			dp.draw(text, _Pt0, _XW, _YW, 0, 0);
				
		//endregion 
		
		//endregion 

		//region Trigger
			// Trigger AddViewport
				String sTriggerAddViewport = T("|Add Viewport|");
				addRecalcTrigger(_kContextRoot, sTriggerAddViewport );
				if (_bOnRecalc && (_kExecuteKey==sTriggerAddViewport || _kExecuteKey==sDoubleClick))
				{
				// prompt for entities
					Entity ents[0];
					PrEntity ssE(T("|Select viewports|"), ShopDrawView());
					if (ssE.go())
						ents.append(ssE.set());
					
					for (int i=0;i<ents.length();i++) 
						if (_Entity.find(ents[i])<0)
							_Entity.append(ents[i]); 
					
					setExecutionLoops(2);
					return;
				}	
				
			// Trigger RemoveViewport
				String sTriggerRemoveViewport = T("|Remove Viewport|");
				if (sdvs.length()>1)
					addRecalcTrigger(_kContextRoot, sTriggerRemoveViewport );
				if (_bOnRecalc && _kExecuteKey==sTriggerRemoveViewport)
				{
				// prompt for entities
					Entity ents[0];
					PrEntity ssE(T("|Select viewports|"), ShopDrawView());
					if (ssE.go())
						ents.append(ssE.set());
					
					for (int i=0;i<ents.length();i++) 
					{
						int n = _Entity.find(ents[i]);
						if (n>-1)
						{ 
							_Entity.removeAt(n);
						}
						if (_Entity.length()==1)
							break;
					}	
					setExecutionLoops(2);
					return;
				}					
		//endregion
		
		}
	//END Draw Setup of Blockspace //endregion 
		
	}	
//END BlockSpace //endregion 	

//region Collect dim entities and build shape
	PlaneProfile ppShadow(CoordSys(_Pt0, vecX, vecY, vecZ));
	int numContour, numOpening;
	Point3d ptFaces[0]; // a collection of face points to adust _Pt0 in model mode
	
	Map mapArcs;
	
// Get buffered data to speed up dragging	
	if(bDrag && _Map.hasMap("Arcs"))
	{
		mapArcs=_Map.getMap("Arcs");
		ptFaces=_Map.getPoint3dArray("ptFaces");
		numContour=_Map.getInt("numContour");
		numOpening=_Map.getInt("numOpening");
	}	
	else if(!bIsBlockSpaceSetup)
	{
		Map mapEnts = getNestedGenBeamMaps(showSet);
		//reportNotice("\ngetNestedGenBeamMaps returned " + mapEnts.length());
		for (int i=0;i<mapEnts.length();i++) 
		{ 
		
		//region Get genbeams from collection	
			Map m= mapEnts.getMap(i);
			Entity ents[] = m.getEntityArray("ent[]", "", "ent");
			GenBeam gbs[0];
			for (int j=0;j<ents.length();j++) 
			{ 
				GenBeam gb= (GenBeam)ents[j];
				if (gb.bIsValid())
					gbs.append(gb);
				 
			}//next j		
			if (bIsGenBeamPD)
				gbs = pdDim.filterAcceptedEntities(gbs);
	
			if (gbs.length()<1){ continue;}			
		//Get genbeams from collection	 //endregion 
	
		//region Get potential parent transformation
			CoordSys csThis;
			String def = m.getString(kDef);
			Entity parent = m.getEntity(kParent);
			
			Vector3d vecZMThis = vecZM;
			
			if (parent.bIsValid())
			{ 
				MetalPartCollectionEnt ce = (MetalPartCollectionEnt)parent;
				BlockRef bref = (BlockRef)parent;
				if (ce.bIsValid())
					csThis = ce.coordSys();
				else if (bref.bIsValid())
					csThis = bref.coordSys();	
					
					
				CoordSys inv = csThis;
				inv.invert();
				vecZMThis.transformBy(inv);
				vecZMThis.normalize();
					
					
			}
			csThis.transformBy(ms2ps);			
		//endregion 
	
		//region Loop collected genbeams
			
			Body bodies[] = getGenbeamBodies(gbs, 0);//0=real, 1=basic, 2 = envelope		
			for (int j=0;j<gbs.length();j++) 
			{ 
				GenBeam gb = gbs[j];
				CoordSys csg = gb.coordSys();
				
				Sip pa = (Sip)gb;
				Beam bm = (Beam)gb;
				
				
				Body bd= bodies[j]; 
				//nFace = -1;
				Vector3d vecXG = gb.vecX();
				Vector3d vecYG = gb.vecY();
				Vector3d vecZG = gb.vecZ();
				Vector3d vecFace = gb.vecD(vecZMThis);
				
				Point3d ptCen = bd.ptCen();
//				vecXG.vis(ptCen, 1);
//				vecYG.vis(ptCen, 3);
//				vecZG.vis(ptCen, 150);
//				vecZMThis.vis(ptCen, 2);
//				bd.vis(6);				
//				PLine (bd.ptCen(),_PtW).vis(3);

				if (vecZMThis.isParallelTo(vecXG))
					vecFace = vecXG*(vecZMThis.isCodirectionalTo(vecXG)?1:-1);
				else if (vecFace.isParallelTo(vecZG)) // catch slight tolerances
					vecFace = vecZG;
				vecFace *= nFace;
				
			// ignore beveled
				int isParallelTo = vecFace.isParallelTo(vecZMThis);
				if (!isParallelTo) // accept slight tolerances //HSB-21240 ST17
				{ 
					double d= abs(vecFace.dotProduct(vecZMThis));
					isParallelTo = abs(d - 1) < 0.01;
				}
				
				if (!isParallelTo)
				{ 			
					//bd.vis(1);	
					continue;
				}
				
				
				double dFace = vecZMThis.isParallelTo(vecXG) ?gb.solidLength()*.5: .5*gb.dD(vecZMThis);
				Point3d ptFace = gb.ptCen() + vecFace * dFace;
				Plane pnFace(ptFace, vecFace);
				//vecFace.vis(pnFace.ptOrg(),3);
	//			vecZM.vis(pnFace.ptOrg(),4);			
				ptFace.transformBy(csThis);
				ptFaces.append(ptFace);
			
			// Get shape
				PLine plToolArcs[0]; // collected arcs and circles of this genbeam
				PlaneProfile ppTool(cs),ppShape(cs);
				{
					PlaneProfile pp=(bd.extractContactFaceInPlane(pnFace, dEps));
					if (bDebug)	{bd.vis(j);pp.vis(2);}
					pp.transformBy(csThis);
					ppShape.unionWith(pp);
				}
				PLine plOpenings[] = ppShape.allRings(false, true);
				PLine plContours[] = ppShape.allRings(true, false);	

			//region CurveStyle: override shape and contour rings when seen from main face
				int bHasCurvedStyle;
				if (bm.bIsValid() && bm.vecY().isParallelTo(vecZMThis))
				{ 
					String curvedStyle = bm.curvedStyle();
					//reportNotice("\ncurved " + curvedStyle);
					CurvedStyle cStyle(bm.curvedStyle());
					if (curvedStyle!=_kStraight && cStyle.bIsValid())
					{ 
						CoordSys csx;
						csx.setToAlignCoordSys(_PtW, _XW,_YW,_ZW, csg.ptOrg(), csg.vecX(), csg.vecZ(), -csg.vecY());
						PLine plBase = cStyle.baseCurve();
						PLine plTop = cStyle.topCurve();
						
						plBase.transformBy(csx);
						plTop.transformBy(csx);
						
						if (plTop.length()>dEps && plBase.length()>dEps)
						{
							if((plTop.ptStart()-plBase.ptEnd()).length()>dEps)
								plTop.reverse();
								
							plBase.append(plTop);
							plBase.close();
							//plBase.vis(3);	
							plBase.transformBy(csThis);
							ppShape = PlaneProfile(cs);
							ppShape.joinRing(plBase, _kAdd);
							plContours.setLength(0);
							plContours.append(plBase);
							bHasCurvedStyle = true;
						}

						
					}
				}
			//endregion 

				ppShadow.unionWith(ppShape);
	
			//region Collect all analysed tools unless filter specified
				AnalysedTool tools[] = gb.analysedTools(1); 
//				for (int j2=0;j2<tools.length();j2++) 
//					reportNotice("\n"+tools[j2].toolSubType()); 				
				if (sStereotype.length()>0)
				{ 
					String list[] = sStereotype.tokenize(";");
					for (int j2=tools.length()-1; j2>=0 ; j2--) 
					{ 
						Entity tent= tools[j2].toolEnt();
						TslInst t = (TslInst)tent;
						if (t.bIsValid())
						{ 
							if(list.findNoCase(t.scriptName(),-1)<0)
							{ 
								tools.removeAt(j2);
								continue;
							}
						}
						else if (list.findNoCase(tent.typeDxfName(),-1)<0)
						{ 
							tools.removeAt(j2);
							continue;
						}
					}//next j2	
				}
			//endregion 
				
			//region Drills
				AnalysedDrill drills[]= AnalysedDrill().filterToolsOfToolType(tools);
				
			// filter valid drills
				for (int j2=drills.length()-1; j2>=0 ; j2--) 
				{ 
					AnalysedDrill a= drills[j2]; 
					Vector3d vecSide = a.vecSide();
					Vector3d vecFree = a.vecFree();
					int bThrough = a.bThrough();

					int isPerpendicularTo = vecSide.isPerpendicularTo(vecZMThis);
					if (!isPerpendicularTo)// accept slight tolerances //HSB-21240 ST17
					{ 
						double d= abs(vecSide.dotProduct(vecZMThis));
						isPerpendicularTo = d < 0.01;	
						
					}
//
					if (isPerpendicularTo||  
						(nFaceMode<2 && vecFace.dotProduct(vecSide)<0 && !bThrough))
					{
						vecSide.vis(a.ptStart(), 1);
						drills.removeAt(j2);
					}
				}//next j2
	
				for (int j2=0;j2<drills.length();j2++) 
				{ 
					AnalysedDrill a= drills[j2];		
					Vector3d vecSide = a.vecSide();
					
					String toolSubType  = a.toolSubType();
					Point3d ptStart = a.ptStart();
					Point3d ptEnd = a.ptEndExtreme();
					Vector3d vecFree = a.vecFree();//ptEnd-ptStart; 	vecFree.normalize();//

					int bAdd2Map = bSelectAll || sToolSets.findNoCase(a.toolSubType()) >- 1;
					
					double radius = a.dRadius();
					vecFree.vis(ptStart, 1);//vecSide.vis(ptStart, 4);//vecZMThis.vis(ptEnd, 3);

					//reportNotice("\nj2 = " + j2 + " " + radius);
					double radiusPS = radius * dScale;
					PLine c;
					ptStart.transformBy(csThis);
					Line(ptStart, vecZ).hasIntersection(Plane(ptOrg, vecZ), ptStart);
					c.createCircle(ptStart, vecZ, radiusPS);
					
					
					plToolArcs.append(c);
					ppTool.joinRing(c,_kAdd); 
					
					
				// store tool
					if (bAdd2Map)
					{ 
						Map m;
						m.setPLine("arc", c);
						m.setPoint3d("ptCen", ptStart);
						m.setDouble("angle", a.dAngle());
						m.setDouble("bevel", a.dBevel());
						m.setDouble("depth", a.dDepth());
						m.setInt("through", a.bThrough());
						m.setDouble("radius", radius);
						
						m.setEntity("tent", a.toolEnt());
						m.setString("subType", a.toolSubType());
						m.setPLine("plShape", c);
						mapArcs.appendMap("entry", m);					
					}
					if (bDebug)c.vis(bAdd2Map?3:12);
					ppShape.joinRing(c, _kAdd); // manipulate contact shape to avoid duplicate collection of these rings
					
				}//next i			
				
				
			//Drills //endregion 	
	
			//region Mortise			
				AnalysedMortise mortises[]= AnalysedMortise().filterToolsOfToolType(tools);
				for (int j2 = 0; j2 < mortises.length(); j2++)
				{
					
					AnalysedMortise& a= mortises[j2];
					String toolSubType  = a.toolSubType();
					int bAdd2Map = bSelectAll || sToolSets.findNoCase(toolSubType) >- 1;
	
					double radius = a.dCornerRadius();
					Vector3d vecSide = a.vecSide();
					Quader q = a.quader();
					int bThrough = abs(q.dD(vecSide) - 2*dFace) < dEps;
					
					if (vecSide.isPerpendicularTo(vecZMThis) ||  (vecFace.dotProduct(vecSide)<0 && !bThrough)  )
					{
						continue;
					}				
					if (radius < dEps) 
					{
						continue; 
					}
					
					
				// store tool	
					Map m;
					m.setDouble("radius", radius);
					m.setDouble("angle", a.dAngle());
					m.setDouble("bevel", a.dBevel());
					m.setDouble("twist", a.dTwist());
					m.setDouble("depth", a.dDepth());
					m.setInt("rounType", a.nRoundType());
					m.setEntity("tent", a.toolEnt());
					m.setString("subType", a.toolSubType());
	
					CoordSys cst = a.coordSys();
					Vector3d vecXT = cst.vecX();
					Vector3d vecYT = cst.vecY();
					Vector3d vecZT = cst.vecZ();
					
					double dx = q.dD(vecXT)*.5;
					double dy = q.dD(vecYT)*.5;//q.dD(vecYT)
	
					q.vis(4);
					Point3d pt = a.ptOrg();
					vecXT.vis(pt, 1);vecYT.vis(pt, 3);

					if (vecZT.dotProduct(vecFace) < 0)vecXT *= -1;
					PLine pl(vecFace);

					
				// not slot type	
					if (dx>radius && dy>radius)
					{ 
						pl.createRectangle(LineSeg(pt - vecXT * dx - vecYT * 2*dy, pt + vecXT * dx + vecYT *2* dy), vecXT, vecYT);
						pl.offset(radius, false);
						pl.offset(-radius, true);	
						pl.transformBy(csThis);
						m.setPLine("plShape", pl);
						
						Point3d pts[0];
						pts.append(pt - vecXT * (dx - radius) - vecYT * (dy- radius));
						pts.append(pt + vecXT * (dx - radius) - vecYT * (dy- radius));
						pts.append(pt + vecXT * (dx - radius) + vecYT * (dy- radius));
						pts.append(pt - vecXT * (dx - radius) + vecYT * (dy- radius));						
						
						for (int p=0;p<pts.length();p++) 
						{ 
							Point3d ptc = pts[p];
							ptc.transformBy(csThis);	//ptc.vis(2);
							Point3d pt1 = ptc - vecXT * radius;
							Point3d pt2 = ptc - vecYT * radius;
							PLine arc(vecFace);
							arc.addVertex(pt1);
							arc.addVertex(pt2, tan(-22.5));
							
							m.setPLine("arc", arc);
							m.setPoint3d("ptCen", ptc);
							if(bAdd2Map)mapArcs.appendMap("entry", m);	
							
							if (p == 0 || p == 3)vecXT *= -1;
							if (p == 1 || p == 2)vecYT *= -1;
			
						}//next p	
					}
					else
					{ 
						Point3d pts[0];
						if (dx>dy)
						{ 
							pts.append(pt + vecXT * (dx - radius) - vecYT * dy);
							pts.append(pt - vecXT * (dx - radius) - vecYT * dy);
							pts.append(pt - vecXT * (dx - radius) + vecYT * dy);							
							pts.append(pt + vecXT * (dx - radius) + vecYT * dy);													
						}
						else
						{ 
							pts.append(pt - vecXT * dx - vecYT * (dy - radius));
							pts.append(pt - vecXT * dx + vecYT * (dy- radius));
							pts.append(pt + vecXT * dx + vecYT * (dy- radius));
							pts.append(pt + vecXT * dx - vecYT * (dy- radius));					
						}
	
						pl.addVertex(pts[0]);
						pl.addVertex(pts[1]);
						pl.addVertex(pts[2], tan(-45));
						pl.addVertex(pts[3]);
						pl.addVertex(pts[0], tan(-45));
						pl.close();							pl.vis(6);
						pl.transformBy(csThis);
						m.setPLine("plShape", pl);
	
						if(bAdd2Map)
						{ 
							
							{ 
								Point3d ptc = (pts[1] + pts[2]) * .5;
								ptc.transformBy(csThis);	//ptc.vis(2);
			
								PLine arc(vecFace);
								arc.addVertex(pts[1]);
								arc.addVertex(pts[2], tan(-45));
								arc.transformBy(csThis);	//arc.vis(4);
								plToolArcs.append(arc);
								
								m.setPLine("arc", arc);
								m.setPoint3d("ptCen", ptc);
								mapArcs.appendMap("entry", m);						
							}
							{ 
								Point3d ptc = (pts[3] + pts[0]) * .5;
								ptc.transformBy(csThis);	//ptc.vis(2);
			
								PLine arc(vecFace);
								arc.addVertex(pts[3]);
								arc.addVertex(pts[0], tan(-45));
								arc.transformBy(csThis);	//arc.vis(4);
								plToolArcs.append(arc);
								
								m.setPLine("arc", arc);
								m.setPoint3d("ptCen", ptc);
								mapArcs.appendMap("entry", m);						
							}						
							
						}
						
							
						
						
					}
					
	//				pt.transformBy(csThis);
	//				vecXT.transformBy(csThis);	vecXT.normalize();vecXT.vis(pt, 1);
	//				vecYT.transformBy(csThis);	vecYT.normalize();vecYT.vis(pt, 3);
	
					if (bDebug)pl.vis((bAdd2Map ? 3 : 1));	
					{ 
						PlaneProfile pp(cs);
						pp.joinRing(pl, _kAdd);
						pp.shrink(-dEps);
						ppShape.unionWith(pp); // manipulate contact shape to avoid duplicate collection of these rings
					}
					
	
					//if (bDebug){q.transformBy(csThis);q.vis(3);}
					ppTool.joinRing(pl,_kAdd); 
				}
			//endregion 
	
				//if (bDebug)	{ bd.transformBy(csThis); bd.vis(j); }//ppShape.vis(2); }
				
				
				//ppTool.vis(40);
				PLine plToolRings[] = ppTool.allRings(true, false);
				//if (bDebug){Display dp(4); dp.draw(ppTool,_kDrawFilled,60);}
	
			//region Collect opening rings of shape	
				for (int r=plOpenings.length()-1; r>=0 ; r--) 
				{ 
					PLine pl = plOpenings[r];
					
					Map mapTmp=mapArcs; 
					int _numOpening = convertRing(pl, kSTOpening, mapTmp,gb,plToolArcs); // convert segmented into arced and return as subType 'opening'
					numOpening += _numOpening;
				
				// append if selected	
		 			if(_numOpening>0 && bSelectAll || bSelectOpening)
		 			{
		 				mapArcs = mapTmp;
		 				if(bDebug)pl.vis(71);
//		 				PLine(pl.ptStart(), _PtW).vis(4);
		 			}
		 			else if (bDebug) 
		 				pl.vis(251);
//					else
//						pl.vis(1);
					//PLine (_PtW, pl.ptStart()).vis(6);
				}//next r //endregion 
	
	
//			for (int r=0;r<plToolArcs.length();r++) 
//				plToolArcs[r].vis(r);
	
	
	 		//region Collect contour ring of shape	 	 			
	 			for (int r=0;r<plContours.length();r++) 
	 			{ 
	 				PLine& pl = plContours[r]; 	
	 				Map m=mapArcs;
	 				int num = convertRing(pl, bHasCurvedStyle?kSTCurved:kSTContour, m, gb,plToolArcs); // convert segmented into arced and return as subType 'contour'
	 				numContour += num;
	 			// append if selected	
		 			if(num>0 && bSelectAll || bSelectContour)
		 			{
		 				mapArcs = m;
		 				if (bDebug)pl.vis(41);
		 				plToolArcs.append(pl); // avoid duplicates, see HSB-21240 ST17
		 			}
		 			else if (bDebug) pl.vis(252);
	 			}//next r //endregion  
	
			}//next j			
		//Loop collected genbeams //endregion 
	
		}//next i of mapEnts		
	}
	//if (bDebug){Display dp(4); dp.draw(ppShadow,_kDrawFilled,60);}

// Buffer data to speed up dragging	
	if(!bDrag)
	{
		_Map.setMap("Arcs", mapArcs);
		_Map.setPoint3dArray("ptFaces", ptFaces);
		_Map.setInt("numContour", numContour);
		_Map.setInt("numOpening", numOpening);
	}
	
// project instance to top most face if in model
	if (!bHasPage && !bHasSection && !bHasSDV && _Viewport.length()<1)
	{ 
		Line(_Pt0, vecZ).orderPoints(ptFaces, dEps);
		if (ptFaces.length()>0)
		{
			double d = vecZ.dotProduct(ptFaces.last() - _Pt0);
			if (abs(d)>dEps)
			{
				_Pt0 += vecZ * d;
				setExecutionLoops(2);
			}
		}
		pn = Plane(_Pt0, vecZ);
	}
	
	
	
//endregion 

//region Collect arcs and circles
	PLine arcs[0], plShapes[0];
	int bIsCloseds[0];
	double radii[0];
	Point3d ptCens[0];
	Entity tents[0];
	String uids[0];
	String subTypes[0];
	for (int i=0;i<mapArcs.length();i++) 
	{ 
		Map m = mapArcs.getMap(i);
		PLine arc = m.getPLine("arc");		//arc.vis(6);
		PLine shape = m.getPLine("plShape");
		Point3d ptCen = m.getPoint3d("ptCen");
		double radius = m.getDouble("radius");
		Entity tent= m.getEntity("tent");

		

		arcs.append(arc);
		bIsCloseds.append(arc.isClosed());
		radii.append(radius);
		ptCens.append(ptCen);
		tents.append(tent);
		uids.append(tent.handle());
		plShapes.append(shape);
		subTypes.append(m.getString("subType"));
	}//next i
	
	if (!bIsBlockSpaceSetup && mapArcs.length()<1)
	{ 
		if (bDebug)reportMessage("\n" + scriptName() + T(" |could not find any arcs or circles|"));
		//if (_bOnInsert && bDebug)_Pt0 = getPoint();
//		if (bDebug)dp.draw(scriptName(), _Pt0, _XU, _YU, 1, 0);
		if (!bDebug)
			eraseInstance();
		return;
	}
		
	
//endregion 

//region onInsert #3 prompt for location
	if (_bOnInsert && !bIsBlockSpaceSetup)
	{ 

		int nDimType = mapParams.getInt("dimType");
		
		// dummym value
		double dRadius = U(12);
		Map mapAdd;
		mapAdd.setDouble("Radius", dRadius,_kLength);
		mapAdd.setDouble("Diameter", 2*dRadius,_kLength);
		mapAdd.setDouble("ArcLength", U(60),_kLength);
		mapAdd.setDouble("Depth", U(100),_kLength);
		mapAdd.setDouble("Angle", U(30),_kAngle);
		mapAdd.setDouble("Bevel", U(45),_kAngle);
		mapAdd.setDouble("Twist", U(60),_kAngle);



		// Text
		Entity entFormat=entDefine;
//		if (tent.bIsValid())
//			entFormat = tent;
		//sFormat.setDefinesFormatting(entFormat, mapAdd);	
		String text= entFormat.formatObject(sFormat, mapAdd);
		text = text.trimLeft().trimRight();		
		
		

	//region Show Jig
		PrPoint ssP(T("|Pick location [Radial/Diametric/arcMeasure/Automatic]|")); // second argument will set _PtBase in map
		mapParams.setString("text", text);
	   	mapParams.appendMap("mapArcs", mapArcs); 
	   
	    int nGoJig = -1;
	    while (nGoJig != _kNone)//nGoJig != _kOk && 
	    {
	        nGoJig = ssP.goJig(kJigInsert, mapParams); 
	        //if (bDebug)reportMessage("\ngoJig returned: " + nGoJig);
	        
	        if (nGoJig == _kOk)
	        {
	            Point3d ptPick = ssP.value();
	            Line(ptPick, vecZ).hasIntersection(pn, ptPick);
	            
	            if (bGetArcLength)
		            _Map.setPoint3d("ptArc", ptPick);	
		            
	            int cur = findClosestArc(arcs, ptPick, vecZ);
	            if (cur>-1)
	            	ptPick = arcs[cur].closestPointTo(ptPick);
	            _Pt0 = ptPick;

	        }
	        else if (nGoJig == _kKeyWord)
	        { 
	        	int key = ssP.keywordIndex();
	        	
	            if (key == 0)//radial
	            {
	            	nDimType = 0;
	            }
	            else if (key == 1)//diametric
	            {
	            	nDimType = 1;

	            }
	            else if (key == 2)//arc measure
	            {
	            	nDimType = 2;           	
	            }	            
	            else if (key == 3)//auto
	            {
	            	nDimType = 3;           	
	            }
	            mapParams.setInt("dimType", nDimType);
	            sMode.set(sModes[nDimType]);
	            
	            //reportNotice("\ndimType is now " + nDimType);
	            
	        }
	        else if (nGoJig == _kCancel)
	        { 
	            eraseInstance(); // do not insert this instance
	            return; 
	        }
	        
	    // create TSL
			TslInst tslNew;
			GenBeam gbsTsl[] = {};		Entity entsTsl[] = {entDefine};			Point3d ptsTsl[] = {_Pt0};		
			Map mapTsl;	
			mapTsl.setVector3d("ModelView", _Map.getVector3d("ModelView"));
	        mapTsl.setPoint3d("ptLoc", _Pt0);
			tslNew.dbCreate(scriptName() , vecX ,vecY,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
	        
	        
	        
	    }			
	//End Show Jig//endregion 

		eraseInstance();
		return;
	}
//endregion 

//region Distribute BlockCreationMode #BCM
	// A distribution instance is created on generate shopdrawing and creates individual instances based on settings
	if (bIsBlockCreationMode)// || _ThisInst.color()==4)
	{ 
//		_ThisInst.setColor(4);
//		bDebug = true;

		int bAddArcMeasure = sFormat.find("@(ArcLength", 0, false) >- 1 || sMode == tArcMeasure;


	//region Tag each location
		String tags[0];
		int bOneByDefault = sDistribution==tDefaultEntry;
		int bOneBySource = sDistribution == tOneBySource || sDistribution==tDefaultEntry;
		int bOneByRadius = sDistribution == tOneByRadius;
		for (int i=0;i<arcs.length();i++) 
		{ 
			PLine& arc = arcs[i];
			
			Point3d ptRef = arc.ptMid();
			if (plShapes[i].length()>0)
				ptRef = plShapes[i].ptStart();
			
			Line(ptRef, vecZ).hasIntersection(Plane(_Pt0, vecZ), ptRef);
			//ptRef.vis(6);
			String tag = String().formatUnit(radii[i],2,2) ;//+"_"+ String().formatUnit(bevels[i],2,2); 
			if (bOneByDefault)
				tag += (_Pt0-ptRef).length();
			else if (bOneBySource)
				tag += uids[i];				
			tags.append(tag);
		}//next i
	
	// order by tag
		for (int i=0;i<tags.length();i++) 
			for (int j=0;j<tags.length()-1;j++) 
				if (tags[j]>tags[j+1])
				{
					arcs.swap(j, j + 1);
					radii.swap(j, j + 1);
					bIsCloseds.swap(j, j + 1);
					tags.swap(j, j + 1);
					tents.swap(j, j + 1);
					uids.swap(j, j + 1);
					ptCens.swap(j, j + 1);
					plShapes.swap(j, j + 1);
					subTypes.swap(j, j + 1);
				}
	
	// remaining locs
		if (bOneBySource || bOneByRadius)
			for (int i=tags.length()-1; i>0 ; i--) 
			{ 
				if (tags[i]==tags[i-1])
				{ 
					arcs.removeAt(i);
					radii.removeAt(i);
					bIsCloseds.removeAt(i);
					tags.removeAt(i);
					tents.removeAt(i);
					uids.removeAt(i);
					ptCens.removeAt(i);
					plShapes.removeAt(i);
					subTypes.removeAt(i);
				}	
			}//next i			
	//endregion 		

	// create TSL
		TslInst tslNew;
		GenBeam gbsTsl[] = {};		Entity entsTsl[] = {page};			Point3d ptsTsl[] = {ptOrg};		
		

		// Instances should allow dragging it to any location once created
		//String sProps[]={sMode, sPainter,sFormat,sDimStyle,sToolSet,sStereotype,sDistribution,sFace};
		sProps[4]=kAll; 
		sProps[5]=""; 
		sProps[6]=tAllArc; 

		dLeaderLength.set(0);
		dProps[2] = dLeaderLength; // default to no leader

	//region Distribute
		for (int i=0;i<arcs.length();i++) 
		{ 
			PLine& arc = arcs[i];

			Point3d ptLoc = arcs[i].ptMid();
			Point3d ptCen = ptCens[i];
			double radius = radii[i];
			int isClosed = bIsCloseds[i];
			String subType = subTypes[i];
			Vector3d vecCen = ptLoc-ptCen;	vecCen.normalize();
			
			Map mapTsl;	
			mapTsl.setVector3d("ModelView", _Map.getVector3d("ModelView"));			
			
		// on circles take 45°	
			if (isClosed)
				ptLoc = arc.closestPointTo(ptCen + (vecX + vecY) * radius);
		
		// half circle take 45°
			else
			{ 
				if (subType==kSTCurved && bAddArcMeasure)
				{
					ptLoc = arc.getPointAtDist(arc.length() * .25);	
					
					Point3d ptArc = ptLoc -vecCen * 3 * textHeight;
					if (ppShadow.pointInProfile(ptArc)!=_kPointOutsideProfile)
						ptArc = ptLoc +vecCen * 3 * textHeight;
					mapTsl.setPoint3d("ptArc", ptArc);
				}
				else
					ptLoc = arc.getPointAtDist(arc.length() * .75);
//				Vector3d vecTan = arc.getTangentAtPoint(ptLoc);
//				vecTan.vis(ptLoc, 120);
//				if (vecTan.isParallelTo(vecX))vecTan = vecX;
//				else if (vecTan.isParallelTo(vecY))vecTan = vecY;					
//				if (vecTan.isParallelTo(vecX)|| vecTan.isPerpendicularTo(vecX))
//				{
//					ptLoc = arc.closestPointTo(ptCen + (vecTan + vecCen) * radius);
//					vecTan.vis(ptLoc, 130);
//				}
			}
			mapTsl.setPoint3d("ptLoc", ptLoc);

				
				
			if (bDebug)
			{ 
				dp.color(i);;
				DimRadial dim(ptCen, ptLoc, 0);
				dim.setUseDisplayTextHeight(bUseTextHeight);	
				dim.setDimensionPlane(ptCen, vecX, vecZ);
				dim.setDimScale(dDimScale);	
				dim.setText("R" + radius);
				
				if (mapTsl.hasPoint3d("ptArc"))
					dim.setTextLocation(mapTsl.getPoint3d("ptArc"));
				dp.draw(dim);
			}
			else
			{ 
				
				

				
				tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
			}
			 
		}//next i
			
	//endregion 		
		

		if (!bDebug)
		{
			eraseInstance();
			return;
		}
		else
		{ 
			dp.textHeight(U(200));
			dp.draw("BlockCreationMode (" + arcs.length()+")", _Pt0, _XU, _YU, 1, 1);
			//_Map.setInt(kBlockCreationMode, true);
			return;
		}
		
	}
//endregion 

//region Trigger
 
//region Trigger DefineToolSets
	String sTriggerDefineToolSets = T("|Define Tool Sets|");
	addRecalcTrigger(_kContextRoot, sTriggerDefineToolSets );
	if (_bOnRecalc && _kExecuteKey==sTriggerDefineToolSets)
	{
		GenBeam gbs[0];
		Map mapEnts = getNestedGenBeamMaps(showSet);
		for (int i = 0; i < mapEnts.length(); i++)
		{
			Map m= mapEnts.getMap(i);
			Entity ents[] = m.getEntityArray("ent[]", "", "ent");
			for (int j=0;j<ents.length();j++) 
			{ 
				GenBeam gb= (GenBeam)ents[j];
				if (gb.bIsValid())
					gbs.append(gb);
				 
			}//next j			
		}
		if (bIsGenBeamPD)
			gbs = pdDim.filterAcceptedEntities(gbs);
			
		int numToolSubTypes[0];
		String toolSubTypes[] = getToolSubTypes(gbs, numToolSubTypes);
		
		if (numOpening>0)
		{ 
			toolSubTypes.append("_kOpenings");
			numToolSubTypes.append(numOpening);
		}
		if (numContour>0)
		{ 
			toolSubTypes.append("_kContour");
			numToolSubTypes.append(numContour);
		}		
		
		Map mapIn,mapItems;
		mapIn.setString("Title", T("|Tool Set Definition|"));
		mapIn.setString("Prompt", T("|Select tools which can contribute to the dimensioning|") + TN("|The number in brackets indictaes the appearance of the tool of the current object|"));
		mapIn.setInt("EnableMultipleSelection", true);
		mapIn.setInt("ShowSelectAll", true);

	// Append selected entries first
		String sEntries[0], sSelectedEntries[0];
		sSelectedEntries= sToolSets;
		for (int i = 0; i < sSelectedEntries.length(); i++)
		{
			String& entry = sSelectedEntries[i];
			String& entryT = sToolTypesT[i];
			int n = sToolTypes.findNoCase(entry,-1);
			if (n>-1 && sEntries.findNoCase(entryT,-1)<0)
				sEntries.append(entryT);
		}

	// Append remaining entries	
		for (int i = 0; i < sToolTypes.length(); i++)
		{ 
			String& entryT = sToolTypesT[i];
			if (sEntries.findNoCase(entryT,-1)<0)
				sEntries.append(entryT);
		}

	// append to list
		for (int i = 0; i < sEntries.length(); i++)
		{ 
			String entryT = sEntries[i];
			int n = sToolTypesT.findNoCase(entryT,-1);
			String entry = n>-1?sToolTypes[n]:"";
			
			int x = toolSubTypes.findNoCase(entry ,- 1);
			if (x>-1)
				entryT += " (" + numToolSubTypes[x]+")";
		
			Map m;
			m.setString("Text", entryT);
			//m.setString("ToolTip", toolTips[i]);
			int isSelected = (sToolSet==kAll || sToolSets.find(entry) >- 1) ? true : false; // preselect all if flagged all
			m.setInt("IsSelected", isSelected);
			mapItems.appendMap("Item", m);	
		}				
		mapIn.setMap("Items[]", mapItems);


		Map mapOut = callDotNetFunction2(sDialogLibrary, sClass, listSelectorMethod, mapIn);// optionsMethod,listSelectorMethod				
		int bCancel = mapOut.getInt("WasCancelled");
		if (!bCancel)
		{ 
			Map mapSelections = mapOut.getMap("Selection[]");
			String out;
			sToolSets.setLength(0);
			for (int i=0;i<mapSelections.length();i++) 
			{ 
				String entryT = mapSelections.getString(i);
				int x = entryT.find(" (",0, false);
				if (x>-1)
					entryT = entryT.left(x);

				int n = sToolTypesT.findNoCase(entryT,-1);
				String entry = n>-1?sToolTypes[n]:"";
				if (n>-1 && sToolTypes.findNoCase(entry,-1)>-1)
				{ 
					sToolSets.append(entry);
					out += (out.length()>0?";":"") + entry;
				}
				 
			}//next i
			sToolSet.set(out);		
		}

		setExecutionLoops(2);
		return;
	}//endregion	


//region Trigger SetStereotypes
	String sTriggerSetStereotypes = T("|Define TSL/Parent Tool Sets|");
	addRecalcTrigger(_kContextRoot, sTriggerSetStereotypes );
	if (_bOnRecalc && _kExecuteKey==sTriggerSetStereotypes)
	{
		String sExcludeScriptStarts[] = {"sd_", "hsbView", "dim","_hsbRe", "AssemblyShop", "BatchShop","Stack", "hsbTslSettings", "Metaldata", "multipage","AssemblyDef" , 
		"hsbCenterOfGravity", "hsbEntityTag", "hsbBOM", "hsbScheduleTable", "hsbLayout", "HSB_D-", "HSB_G-", "hsbAcis", 
		"mapIO","hsb_MultiW", "Layout"}; // TODO to be extended

		Map mapIn,mapItems;
		mapIn.setString("Title", T("|TSL/Parent Tool Selection|"));
		mapIn.setString("Prompt", T("|Select entries of which you want to collect tool dimensioning|"));
		mapIn.setInt("EnableMultipleSelection", true);
		mapIn.setInt("ShowSelectAll", true);
		
	// Get all selected entries
		String sEntries[0], sSelectedEntries[0];
		sSelectedEntries= sStereotypes;
		sEntries = sSelectedEntries;

	// Append all tsl scripts available in model	
		String scriptNames[] = TslScript().getAllEntryNames().sorted();
		for (int i = 0; i < scriptNames.length(); i++)
		{ 
			String& entry = scriptNames[i];
			if (sEntries.findNoCase(entry,-1)>-1){ continue;}
			int bSkip;
			for (int j = 0; j < sExcludeScriptStarts.length(); j++)
			{
				if (entry.find(sExcludeScriptStarts[j],0,false)==0)
				{ 
					bSkip = true;
					break;
				}
			}
			if (bSkip)continue;
			sEntries.append(entry);
		}

		
	// Append a predefined list of eTools which are supported
		String sETools[] ={ "hsb_EBeamcut", "hsb_EFree_Drill", "hsb_ESurfaceDrill", "hsb_ESlot", "hsb_EZapf", "_kACSimpleAngled"};
		String sEToolTips[] ={ T("|A generic tool which describes a quader tool|"), T("|A generic drill tool|"), T("|A generic drill tool assigned to one of the main faces|"), 
			T("|A generic slot tool|"), T("|A generic tenon tool|"),T("|A simple cut|")	};
		for (int i=0;i<sETools.length();i++) 
		{ 
			String& entry = sETools[i]; 
			if (sEntries.findNoCase(entry,-1)<0)
				sEntries.append(entry);
		}//next i

	// Add ToolTip data
		String toolTips[sEntries.length()];
		for (int i = 0; i < sEntries.length(); i++)
		{ 
			String& entry = sEntries[i];
			int n = sETools.findNoCase(entry ,- 1);
			if (n>-1)
				toolTips[i] = sEToolTips[n];
			else
				toolTips[i] = T("|Collects points of all tooling operations which this tool defines.|") + T("|Note, some tools do not contribute tool data.|");
		}
		

	// append to list
		for (int i = 0; i < sEntries.length(); i++)
		{ 
			String& entry = sEntries[i];
			Map m;
			m.setString("Text", entry);
			m.setString("ToolTip", toolTips[i]);
			m.setInt("IsSelected", sSelectedEntries.find(entry)>-1?1:0);
			mapItems.appendMap("Item", m);	
		}				
		mapIn.setMap("Items[]", mapItems);


		Map mapOut = callDotNetFunction2(sDialogLibrary, sClass, listSelectorMethod, mapIn);// optionsMethod,listSelectorMethod				
		int bCancel = mapOut.getInt("WasCancelled");
		if (!bCancel)
		{ 
			Map mapSelections = mapOut.getMap("Selection[]");
			String out;
			sSelectedEntries.setLength(0);
			for (int i=0;i<mapSelections.length();i++) 
			{ 
				String entry = mapSelections.getString(i); 
				if (entry.length()>0 && sSelectedEntries.findNoCase(entry)<0)
				{ 
					sSelectedEntries.append(entry);
					out += (out.length()>0?";":"") + entry;
				}
				 
			}//next i
			sStereotype.set(out);		
		}	

		setExecutionLoops(2);
		return;
	}//endregion


	if (bIsBlockSpaceSetup || bHasSDV)
	{ 
		return;
	}


//End Trigger //endregion

//region Find nearest arc
	int cur = findClosestArc(arcs, ptLoc, vecZ);
	if (cur<0)
	{ 
		dp.color(1);
		dp.draw(scriptName(), _Pt0, _XU, _YU, 1, 0);
		return;
	}
	else if (!bDrag && !bOnDragEnd)
	{ 
		_Map.setInt("CurrentIndex", cur);
	}


	PLine arc = arcs[cur];
	Point3d ptCen = ptCens[cur];
	double dRadius =radii[cur];
	Entity tent= tents[cur];	
	int isClosed = bIsCloseds[cur];
	Map mapTool = mapArcs.getMap(cur);
	//arc.vis(4);
	ptLoc = arc.closestPointTo(ptLoc);
	Vector3d vecArc = ptLoc - ptCen; 	vecArc.normalize();
	
	Point3d ptLeader = ptLoc + vecArc * (leaderLength <= 0 ? textHeight : leaderLength);


//region Auto Format Update
	String format = sFormat;	
	if (!bGetArcLength && !isClosed && (sMode == tAutomatic || sMode==tArcMeasure )  && tent.bIsKindOf(GenBeam()))
	{ 
		format.trimLeft().trimRight();
		if (format.length() < 1)
			format = "@(ArcLength:RL1)";			

	// Arc Measure
		if (format.find("@(ArcLength", 0, false) >- 1)
			format = kArcLengthSymbol + "@(ArcLength:RL0) " + format;
		bGetArcLength=true;	
	}
		
//endregion 


	// draw potential when dragging
	if (bDrag)
	{ 
		if (_Map.hasInt("CurrentIndex") && indexOfMovedGrip!=nGripLeader)
		{ 
			
			int _cur = _Map.getInt("CurrentIndex");
			//reportNotice("\na"+bDrag+bOnDragEnd+nGripLeader+indexOfMovedGrip+_cur+cur);
			if (_cur!=cur)
				leaderLength=0;
		}
		
		PlaneProfile pps[] = createArcProfiles(arcs, pn);
		drawArcs(pps, ptLoc, dpJig);
	}



//endregion 

//region Grip Management #GM2

// create location grip
	if (!bDrag && nGripLoc<0)
	{ 
		Grip gp;
		gp.setPtLoc(ptLoc);
		gp.setName(kGripLoc);
		gp.setColor(40);
		gp.setShapeType(_kGSTCircle);	
		gp.setIsRelativeToEcs(false);
		
		gp.setVecX(vecX);
		gp.setVecY(vecY);
		
		gp.addHideDirection(vecX);
		gp.addHideDirection(-vecX);
		gp.addHideDirection(vecY);
		gp.addHideDirection(-vecY);	
		
		gp.setToolTip(T("|Moves location of the dimension|"));
		
		_Grip.append(gp);
		nGripLoc = _Grip.length() - 1;
		
		if(_Map.hasPoint3d("ptLoc"))
			_Map.removeAt("ptLoc", true);
		
	}
	else if (nGripLoc>-1  && !bDrag)
	{
		_ThisInst.setAllowGripAtPt0(bDebug);
		Grip& gp = _Grip[nGripLoc];
		gp.setPtLoc(ptLoc);					
	}
	
// create leader grip
	if (!bDrag && nGripLeader<0)
	{ 
		Grip gp;
		gp.setPtLoc(ptLeader);
		gp.setName(kGripLeader);
		gp.setColor(leaderLength>textHeight?150:252);
		gp.setShapeType(_kGSTCircle);	
		gp.setIsRelativeToEcs(false);
		
		gp.setVecX(vecX);
		gp.setVecY(vecY);
		
		gp.addHideDirection(vecX);
		gp.addHideDirection(-vecX);
		gp.addHideDirection(vecY);
		gp.addHideDirection(-vecY);	
		
		gp.setToolTip(T("|Specifies an additional leader of the dimension in dependdency of the current dimstyle settings. \nMove near to base point to deactivate.|"));
		
		_Grip.append(gp);
		nGripLeader = _Grip.length() - 1;
	}
	else if (nGripLeader>-1  && !bDrag && !bOnDragEnd)
	{
		Grip& gp = _Grip[nGripLeader];


		if (_kNameLastChangedProp==sLeaderLengthName) //
		{
			gp.setPtLoc(ptLoc - vecArc * (leaderLength<textHeight?textHeight:leaderLength));
			gp.setColor(leaderLength>textHeight?150:252);
		}	
//		gp.setPtLoc(ptLoc);		
	}	

//region Create / Remove ArcLength Grip
// create leader grip
	if (!bDrag && nGripArcLength<0 && bGetArcLength)
	{ 
		Grip gp;
		
		Point3d pt = _Map.hasPoint3d("ptArc") ? _Map.getPoint3d("ptArc") : ptLoc + vecArc * textHeight;
		
		gp.setPtLoc(ptLoc+vecArc*textHeight);
		gp.setName(kGripArcLength);
		gp.setColor(150);
		gp.setShapeType(_kGSTCircle);	
		gp.setIsRelativeToEcs(false);
		
		gp.setVecX(vecX);
		gp.setVecY(vecY);
		
		gp.addHideDirection(vecX);
		gp.addHideDirection(-vecX);
		gp.addHideDirection(vecY);
		gp.addHideDirection(-vecY);	

		_Grip.append(gp);
		nGripArcLength = _Grip.length() - 1;
		
//		if(_Map.hasPoint3d("ptArc"))
//			_Map.removeAt("ptArc", true);		
		
	}
	if (!bDrag && !bGetArcLength && nGripArcLength>-1)
	{ 
		_Grip.removeAt(nGripArcLength);
		setExecutionLoops(2);
		return;
	}
//endregion 
	



	
	if (bOnDragEnd)
	{ 
		
		if (indexOfMovedGrip==nGripLoc)
		{ 
			//reportNotice("\nstored cur " +_Map.getInt("CurrentIndex") + " vs cur "+ cur);
			//reportNotice("\nb"+bDrag+bOnDragEnd+nGripLeader+indexOfMovedGrip);
			if (_Map.hasInt("CurrentIndex"))
			{ 
				int _cur = _Map.getInt("CurrentIndex");
				if (_cur!=cur)
				{ 
					if (nGripLeader>-1)
					{ 
						Grip& gp = _Grip[nGripLeader];
						Point3d pt = gp.ptLoc();
						if (leaderLength<=textHeight)
						{ 
							pt = ptLoc + vecArc * textHeight;
							gp.setColor(252);
						}
						else
						{ 
							pt.transformBy(vecOffsetApplied);
							gp.setColor(150);
						}				
						gp.setPtLoc(pt);						
					}
					if (nGripArcLength>-1)
					{ 
						Grip& gp = _Grip[nGripArcLength];
						Point3d pt = gp.ptLoc();
//						if (leaderLength<=textHeight)
//						{ 
//							pt = ptLoc + vecArc * textHeight;
//							gp.setColor(252);
//						}
//						else
						{ 
							pt.transformBy(vecOffsetApplied);
							gp.setColor(150);
						}				
						gp.setPtLoc(pt);						
					}
					
					
					
					
					
					_Map.setInt("CurrentIndex", cur);
				}				
			}
		}		
		
		else if(indexOfMovedGrip == nGripLeader)
		{ 
			Grip& gp = _Grip[nGripLeader];
			
			double d = (gp.ptLoc() - ptLoc).length();
			if (d>textHeight)
			{
				ptLeader = gp.ptLoc();
				dLeaderLength.set(d);
				gp.setColor(150);
			}
			else
			{
				dLeaderLength.set(0);	
				ptLeader = ptLoc + vecArc * textHeight;
				gp.setPtLoc(ptLeader);
				gp.setColor(252);
			}
			
		}		
	}
	else if (_kNameLastChangedProp==sLeaderLengthName && nGripLeader>-1) 
	{ 
		Grip& gp = _Grip[nGripLeader];
		gp.setPtLoc(ptLeader);
	}
//endregion 

//region Draw Dimension
	Map mapAdd;
	mapAdd.setDouble("Radius", dRadius,_kLength);
	mapAdd.setDouble("Diameter", 2*dRadius,_kLength);
	mapAdd.setDouble("ArcLength", arc.length(),_kLength);

	if(mapTool.length()>0)
	{ 
		String k;
		double d;
		k = "Radius";	d =mapTool.getDouble(k);	if (d>dEps)mapParams.setDouble(k, d,_kLength);mapAdd.setDouble(k, d,_kLength);
		k = "Depth";	d =mapTool.getDouble(k);	if (d>dEps)mapParams.setDouble(k, d,_kLength);mapAdd.setDouble(k, d,_kLength);
		k = "Angle";	d =mapTool.getDouble(k);	if (d>dEps)mapParams.setDouble(k, d,_kAngle);mapAdd.setDouble(k, d,_kNoUnit);
		k = "Bevel";	d =mapTool.getDouble(k);	if (d>dEps)mapParams.setDouble(k, d,_kAngle);mapAdd.setDouble(k, d,_kAngle);
		k = "Twist";	d =mapTool.getDouble(k);	if (d>dEps)mapParams.setDouble(k, d,_kAngle);mapAdd.setDouble(k, d,_kAngle);
	}

// Text
	Entity entFormat=entDefine;
	if (tent.bIsValid())
		entFormat = tent;
	sFormat.setDefinesFormatting(entFormat, mapAdd);	
	String text= entFormat.formatObject(format, mapAdd);
	text = text.trimLeft().trimRight();
	mapParams.setString("text", text);
	
	
	
	if(bGetArcLength)
	{
		if (format.find("@(ArcLength",0,false)==2)
			text = kArcLengthSymbol + text;
		if (nGripLeader>-1)
			mapParams.setPoint3d("ptLeader", _Grip[nGripLeader].ptLoc());
		
		if (nGripArcLength>-1)
			mapParams.setPoint3d("ptArc", _Grip[nGripArcLength].ptLoc());			
	}
	else if (nGripLeader>-1)// && leaderLength>0) // HSB-21420
		mapParams.setPoint3d("ptLeader", _Grip[nGripLeader].ptLoc());
		
	if (!arc.isClosed() && bGetArcLength && (bIsAuto ||bIsArcMeasure))
	{ 

		drawDimAngular(ptLoc, ptCen, arc, mapParams);

	}
	else
	{ 
		drawDim(ptLoc, ptCen, arc, mapParams);		
		if (bDebug)dp.draw(scriptName(), _Pt0, _XU, _YU, 1, 0);
	}

	

//endregion 
	



//region TRIGGER
{ 
	// create TSL
	TslInst tslDialog;			Map mapTsl;						
	GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };
	
	String sFolders[]=getFoldersInFolder(sPath); 


//region Trigger PainterManagement
	String sTriggerPainterManagement = T("|Painter Management|");
	addRecalcTrigger(_kContext, sTriggerPainterManagement );
	if (_bOnRecalc && _kExecuteKey==sTriggerPainterManagement)
	{

		Map mapIn,mapItems;
		mapIn.setString("Title", T("|Painter Management|"));
		mapIn.setString("Prompt", T("|Select an option to specify automatic painter creation and usage.|"));
		mapIn.setString("Alignment", "Left");
		
		String tPMDefault = T("|Only Painter Definitions inside folder| (")+sPainterCollection+")", tPMInstanceOff = T("|All Painter Definitions for this dimension|"),
			tPMAllOff = T("|All Painter Definitions for any dimension|");
		String sPMOptions[] = { tPMDefault,tPMInstanceOff,tPMAllOff };
		String sPMTips[0];
		sPMTips.append(T("|A folder with certain painter definitions will be created.| (") +sPainterCollection + T(") |Any painter outside of the folder will be ignored.|"));
		sPMTips.append(T("|A folder with certain painter definitions will be created.| (") +sPainterCollection + T(") |This dimension will allow any painter definition.|"));
		sPMTips.append(T("|A folder with certain painter definitions will not be created.|") + " " + T("|Any painter definition will be accepted.|"));

		for (int i = 0; i < sPMOptions.length(); i++)
		{ 		
			Map m;
			m.setString("Text", sPMOptions[i]);
			m.setString("ToolTip", sPMTips[i]);
			mapItems.appendMap("Item", m);	
		}				
		mapIn.setMap("Items[]", mapItems);
		
		if (nPainterManagementMode>-1)
			mapIn.setInt("SelectedIndex", nPainterManagementMode);//__when selected index is present, it is used over initial selection set by int in items list

		Map mapOut = callDotNetFunction2(sDialogLibrary, sClass, optionsMethod, mapIn);// optionsMethod,listSelectorMethod				
		String value = mapOut.getString("Selection");
		
		nPainterManagementMode = sPMOptions.findNoCase(value ,- 1);		
		if (nPainterManagementMode<0)
			nPainterManagementMode = 0;		
		if (nPainterManagementMode==1)
			_Map.setInt(kPainterManagementMode,nPainterManagementMode );	
		else
		{ 
			_Map.removeAt(kPainterManagementMode, true);
			mapSetting.setInt(kPainterManagementMode,nPainterManagementMode );			
			if (mo.bIsValid())mo.setMap(mapSetting);
			else mo.dbCreate(mapSetting);			
		}
	
		
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
				String sFolders[]=getFoldersInFolder(sPath); 
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




}//TRIGGER //endregion


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
        <int nm="BreakPoint" vl="3326" />
        <int nm="BreakPoint" vl="2091" />
        <int nm="BreakPoint" vl="2323" />
        <int nm="BreakPoint" vl="2190" />
        <int nm="BreakPoint" vl="279" />
        <int nm="BreakPoint" vl="3817" />
        <int nm="BreakPoint" vl="3576" />
        <int nm="BreakPoint" vl="3180" />
        <int nm="BreakPoint" vl="3775" />
        <int nm="BreakPoint" vl="306" />
        <int nm="BreakPoint" vl="2538" />
        <int nm="BreakPoint" vl="689" />
        <int nm="BreakPoint" vl="734" />
        <int nm="BreakPoint" vl="801" />
        <int nm="BreakPoint" vl="3197" />
        <int nm="BreakPoint" vl="3216" />
        <int nm="BreakPoint" vl="2293" />
        <int nm="BreakPoint" vl="2763" />
        <int nm="BreakPoint" vl="3800" />
        <int nm="BreakPoint" vl="3541" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23092 supporting metalparts of xref drawings" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="12/2/2024 10:15:43 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21240 mortise detection improved" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="2/14/2024 1:00:58 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21240 curvedStyle added, tool/contour overlay enhanced, various enhancements on detecting arcs" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="2/13/2024 5:11:23 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21240 perpendicular drills supressed, leader added" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="2/12/2024 6:02:04 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21396 bugfix blockspace toolset" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="2/8/2024 12:03:31 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20487 beam end alignment fixed" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="2/1/2024 5:18:11 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20487 arc length dimension appended" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="2/1/2024 11:42:01 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20487 completly revised, ,new property tool definition (use context command to specify)" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="1/26/2024 3:24:21 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20639 bugfix leader length moving multipages" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="11/15/2023 2:46:56 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19787 grips improved, dimstyle group assignment enhanced" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="8/9/2023 10:14:05 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19099 supports painter filtering when defined in blockspace, dimstyles which are associated to non radial(diametric) dimensions are not shown anymore" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="5/31/2023 3:54:57 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18761 caching improved, assemblyDefinitions collected via showSet, supports pages which use scale to fit" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="4/20/2023 4:46:01 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18708 consumes entities of AssemblyDefinitions" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="4/19/2023 2:47:45 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18554 considering potential opposite view during generate shopdrawing" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="4/3/2023 11:09:32 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18541 additional format variables are available through formatting expressions" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="3/31/2023 3:27:39 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18346 caching of analysed tools and shape added to improve performance" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="3/31/2023 12:40:47 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18112 'Ø' will be displayed when using unit scaling in diametric mode" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="3/3/2023 9:29:40 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18112 bugfix insert in block space" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="2/27/2023 3:23:00 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18112 new properties and extended behaviour for block space setup, consumes shape and analysed drills" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="2/24/2023 5:01:20 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18112 supporting any drill with axis most aligned to view direction" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="2/23/2023 6:53:25 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16730 segmented contours will try to reconstruct into arc segments enhanced II" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="2/16/2023 8:49:38 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16730 segmented contours will try to reconstruct into arc segments enhanced" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="2/9/2023 8:31:47 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16989 segmented contours will try to reconstruct into arc segments" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="2/7/2023 8:59:06 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17771 new options to distinguish between convex and concave dimensions" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="2/3/2023 12:20:10 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16730 initial version of radial and diametric dimensions" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="11/8/2022 9:33:03 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="first beta" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="11/4/2022 4:16:01 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End