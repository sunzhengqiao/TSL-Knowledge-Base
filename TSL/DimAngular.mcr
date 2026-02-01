#Version 8
#BeginDescription
This tsl creates an angular dimension

#Versions
Version 2.7 15.11.2023 HSB-20640 arc length dimensions only created if format argument is given

Version 2.6 08.08.2023 HSB-19785 default warning 'invalid selection' disabled
Version 2.5 12.05.2023 HSB-18965 bugfix insert on multipages containing an isometric view
Version 2.4 03.03.2023 HSB-18196 arc reconstruction added
Version 2.3 15.02.2023 HSB-17977 accepting toleances when ignoring 90° or multiples of it
Version 2.2 31.01.2023 HSB-16830 insert location on paperspace viewports validated
Version 2.1 12.01.2023 HSB-17107 supports angular dim requests based on submapX hsb_DimensionInfo
Version 2.0 11.11.2022 HSB-16932 additional adjacent angle added, offset viewport placement fixed
Version 1.9 03.11.2022 HSB-16291 bugfix adjacent angle collection
Version 1.8 28.10.2022 HSB-16291 section support added, viewport filters added
Version 1.7 21.10.2022 HSB-16291 multipage and auto generation through blockspace definition supported
Version 1.6 19.10.2022 HSB-16291 basic element viewport support added
Version 1.5 15.10.2022 HSB-16507 filtering by painter and element  support added
Version 1.4 14.10.2022 HSB-16507 collection entity multipage support added
Version 1.3 07.10.2022 HSB-16507 genbeam multipage support added
Version 1.2 07.10.2022 HSB-16507 adjacent and complete angle trigger added
Version 1.1 16.09.2022 HSB-16507 reference modes added
Version 1.0 19.08.2022 HSB-16246 initial version

















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
//region Part #1

//region <History>
// #Versions
// 2.7 15.11.2023 HSB-20640 arc length dimensions only created if format argument is given , Author Thorsten Huck
// 2.6 08.08.2023 HSB-19785 default warning 'invalid selection' disabled , Author Thorsten Huck
// 2.5 12.05.2023 HSB-18965 bugfix insert on multipages containing an isometric view , Author Thorsten Huck
// 2.4 03.03.2023 HSB-18196 arc reconstruction added , Author Thorsten Huck
// 2.3 15.02.2023 HSB-17977 accepting toleances when ignoring 90° or multiples of it  , Author Thorsten Huck
// 2.2 31.01.2023 HSB-16830 insert location on paperspace viewports validated , Author Thorsten Huck
// 2.1 12.01.2023 HSB-17107 supports angular dim requests based on submapX hsb_DimensionInfo , Author Thorsten Huck
// 2.0 11.11.2022 HSB-16932 additional adjacent angle added, offset viewport placement fixed , Author Thorsten Huck
// 1.9 03.11.2022 HSB-16291 bugfix adjacent angle collection , Author Thorsten Huck
// 1.8 28.10.2022 HSB-16291 section support added, viewport filters added , Author Thorsten Huck
// 1.7 21.10.2022 HSB-16291 multipage and auto generation through blockspace definition supported , Author Thorsten Huck
// 1.6 19.10.2022 HSB-16291 basic element viewport support added , Author Thorsten Huck
// 1.5 15.10.2022 HSB-16507 filtering by painter and element  support added , Author Thorsten Huck
// 1.4 14.10.2022 HSB-16507 collection entity multipage support added , Author Thorsten Huck
// 1.3 07.10.2022 HSB-16507 genbeam multipage support added , Author Thorsten Huck
// 1.2 07.10.2022 HSB-16507 adjacent and complete angle trigger added , Author Thorsten Huck
// 1.1 16.09.2022 HSB-16507 reference modes added , Author Thorsten Huck
// 1.0 19.08.2022 HSB-16246 initial version, Author Thorsten Huck

/// <insert Lang=en>
/// Select entity and pick location
/// </insert>

// <summary Lang=en>
// This tsl creates an angular dimension
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "DimAngular")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Set Reference|") (_TM "|Select angular dimension|"))) TSLCONTENT
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
	
//regioor and view	
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
	int brown = rgb(153, 77, 0);

	Vector3d vecXView = getViewDirection(0);
	Vector3d vecYView = getViewDirection(1);
	Vector3d vecZView = getViewDirection(2);
	double dViewHeight = getViewHeight();	
//endregion 	
	
	String kJigViewport = "JigViewport",kJigAlignment="JigAlignment", tDefaultEntry = T("<|Default|>"),
	kShadow = "Shadow", kDir = "vecDir",kJigSelectAngle= "SelectAngleJig",
	tATInner=T("|Inner Angle|"), tATOuter=T("|Outer Angle|"), tATSelectSide = T("|Select Side|"),tRefHorizontal=T("|Horizontal Reference|"), 
	tRefVertical=T("|Vertical Reference|"), tATSmallest= T("|Smallest Angle|"), tATLargest = T("|Largest Angle|"),
	tSMVertex = T("|Vertex|"), tSMSegment = T("|Segment|"),
	kDimDimstyle = "Dimstyle", kTextHeight= "textHeight", kShape = "Shape", tDisabled=T("<|Disabled|>"), kVecRef="vecRefLine",
	tCorrespondingAngle=T("|Corresponding Angle|"), tFullAngle = T("|Full Angle|"), 
	tAdjacentAngle = T("|Adjacent Angles|"), tComplementaryAngle=T("|Full Complementary Angle|"),
	kJigSelectSegment = "JigSelectSegment",
	kJigSetupLocation = "SetupLocation", kViewportSetup = "ViewportSetup", kViewportOrg = "vecViewportOrg", kJigTextLocation="JigTextLocation",
	kBaseOffset = "BaseOffset",kBlockCreationMode = "BlockCreationMode", kAddTextLocation = "AddTextLocation";	
	
	String kArcLengthSymbol = "Ո";
//end Constants//endregion

//region Functions #func

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
		String def = ce.definition();
		MetalPartCollectionDef cd(def);
	
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




//	void drawPLine(PLine pl, double offset,  int color, int fillTransparent)
//	{ 
//		Display dp(color);
//		pl.transformBy(pl.coordSys().vecZ() * offset);
//		if (fillTransparent>0)
//			dp.draw(PlaneProfile(pl), _kDrawFilled, fillTransparent);
//		else
//			dp.draw(pl);
//	}
//	void drawPlaneProfile(PlaneProfile pp, double offset,  int color, int fillTransparent)
//	{ 
//		Display dp(color);
//		pp.transformBy(pp.coordSys().vecZ() * offset);
//		if (fillTransparent>0)
//			dp.draw(pp, _kDrawFilled, fillTransparent);
//		else
//			dp.draw(pp);
//	}	
//endregion 

//region bOnJig
	int bJig;

// Viewport
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
	    dp.trueColor(lightblue, 50);



	    double dMin = U(10e6);
	    int n;
	    for (int i=0;i<pps.length();i++) 
	    { 
	    	double d = (pps[i].closestPointTo(ptJig)-ptJig).length();
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
	    
	    
	    return;
	}
// Viewport Preview Graphics
	else if (_bOnJig && _kExecuteKey==kJigSetupLocation)
	{ 
		Point3d ptJig = _Map.getPoint3d("_PtJig");
		PlaneProfile ppLayout = _Map.getPlaneProfile("ppLayout");
		PlaneProfile ppViewport = _Map.getPlaneProfile("ppViewport");

		double dMax = getViewHeight()*2;
		PlaneProfile ppLayoutRange = ppLayout;
		ppLayoutRange.shrink(-dMax);
		ppLayoutRange.subtractProfile(ppLayout);
	
		Display dp(-1);
		dp.textHeight(getViewHeight() / 80);
		
		
		if (ppViewport.pointInProfile(ptJig)!=_kPointOutsideProfile)
		{
			dp.trueColor(darkyellow, 60);
			dp.draw(ppViewport,_kDrawFilled);
			
			dp.trueColor(lightblue, 60);
			dp.draw(ppLayoutRange,_kDrawFilled);
		}
		else if (ppLayout.pointInProfile(ptJig)==_kPointOutsideProfile)
		{
			dp.trueColor(darkyellow, 60);
			dp.draw(ppLayoutRange,_kDrawFilled);
			
			dp.trueColor(lightblue, 60);
			dp.draw(ppViewport,_kDrawFilled);			
		}	
		else
		{ 
			dp.trueColor(lightblue, 60);
			dp.draw(ppViewport,_kDrawFilled);
			dp.draw(ppLayoutRange,_kDrawFilled);
		}
		
		String text = T("|Pick point outside paperspace for element setup|") + "\\P"+
			T("|A point inside the viewport specifies a local instance|");
		dp.trueColor(red, 0);
		dp.draw(text, ptJig, _XW,_YW,0,0);
		bJig = true;
	}
// Text location
	else if (_bOnJig && _kExecuteKey==kJigTextLocation)
	{ 
		Point3d ptJig = _Map.getPoint3d("_PtJig");
		Vector3d vecX= _Map.getVector3d("vecX");
		Vector3d vecY= _Map.getVector3d("vecY");
		Vector3d vecZ = vecX.crossProduct(vecY);
		
		Point3d ptCenter = _Map.getPoint3d("ptCenter");
		Point3d ptArc = _Map.getPoint3d("ptArc");
		Point3d ptX1 = _Map.getPoint3d("ptX1");
		Point3d ptX2 = _Map.getPoint3d("ptX2");		
		Line(ptJig, vecZ).hasIntersection(Plane(ptCenter, vecZ), ptJig);

		double dDimScale = _Map.getDouble("dimScale");
		String text = _Map.getString("text");
		String dimStyle = _Map.getString(kDimDimstyle);
		double textHeight = _Map.getDouble(kTextHeight);

		Display dp(-1);
	    dp.trueColor(darkyellow, 50);
		dp.dimStyle(dimStyle);
		double textHeightForStyle = dp.textHeightForStyle("O", dimStyle);
		dp.textHeight(textHeight);
		int bUseTextHeight = abs(textHeight - textHeightForStyle) > dEps;


		DimAngular dimAng(ptCenter, ptX1, ptX2, ptArc);
		dimAng.setUseDisplayTextHeight(bUseTextHeight);	
		dimAng.setDimensionPlane(ptCenter, vecX, vecZ);
		dimAng.setDimScale(dDimScale);
		if (text.length()>0)
			dimAng.setText(text);
		dimAng.setTextLocation(ptJig);

		
	    
	    dp.draw(dimAng);
	    
		return;
	}
// Select Location
	else if (_bOnJig && _kExecuteKey==kJigSelectAngle)
	{ 
		Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point
		String dimStyle = _Map.getString(kDimDimstyle);
		String mode = _Map.getString("mode");
		double textHeight = _Map.getDouble(kTextHeight);
		double dDimScale =_Map.getDouble("DimScale");
		int nColor = _Map.getInt("Color");
		
		Point3d ptsX1[] = _Map.getPoint3dArray("ptsX1");
		Point3d ptsX2[] = _Map.getPoint3dArray("ptsX2");
		Point3d ptsCen[] = _Map.getPoint3dArray("ptsCen");
		
		
		PlaneProfile ppShape = _Map.getPlaneProfile(kShape);
		if (ppShape.area() < pow(dEps, 2)) { reportMessage("invalid shape"); return; }

		CoordSys cs = ppShape.coordSys();
		Point3d ptOrg = cs.ptOrg();
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();
		Vector3d vecZ = cs.vecZ();
		double radius = dViewHeight/50;
		
		Line(ptJig, vecZView).hasIntersection(Plane(ptOrg, vecZ), ptJig);
		
	// Display
		Display dp(-1);
		dp.dimStyle(dimStyle);
		double textHeightForStyle = dp.textHeightForStyle("O", dimStyle);
		dp.textHeight(textHeight);
		int bUseTextHeight = abs(textHeight - textHeightForStyle) > dEps;

	//region Collect inner and outer wedges
		PlaneProfile ppInners[0], ppOuters[0], ppCircles[0];
		for (int i=0;i<ptsCen.length();i++) 
		{ 
			Point3d ptCen = ptsCen[i]; 
			Point3d pt1 = ptsX1[i];
			Point3d pt2 = ptsX2[i];
			
			PLine circle; circle.createCircle(ptCen, cs.vecZ(), radius);	//circle.vis(252);
			
			Vector3d vecX1 = pt1 - ptCen; vecX1.normalize();	vecX1.vis(pt1, 1);
			Vector3d vecY1 = vecX1.crossProduct(-vecZ);
			Point3d pts1[] = Line(ptCen, -vecX1).orderPoints(circle.intersectPoints(Plane(ptCen, vecY1)),dEps);
			
			Vector3d vecX2 = pt2 - ptCen; vecX2.normalize();	vecX2.vis(pt2, 2);
			Vector3d vecY2 = vecX2.crossProduct(-vecZ);
			Point3d pts2[] = Line(ptCen, -vecX2).orderPoints(circle.intersectPoints(Plane(ptCen, vecY2)),dEps);
			
			if (pts1.length() < 1 || pts2.length() < 1)continue;
			
			pt1 = pts1.first();//pt1.vis(p);
			pt2 = pts2.first();//pt2.vis(p);			
			
			Point3d ptm = (pt1 + pt2) * .5;
			Vector3d vec = ptm - ptCen; vec.normalize(); // always relative to inner side
			if(ppShape.pointInProfile(ptCen + vec * dEps) !=_kPointInProfile)	vec *= -1;		
			
		// inner
			Point3d pt3Inner = ptCen + vec * radius;
			PLine plInner(vecZ);
			plInner.addVertex(ptCen);
			plInner.addVertex(pt1);
			plInner.addVertex(pt2, pt3Inner);
			plInner.close();
			plInner.convertToLineApprox(dEps);
			PlaneProfile ppInner(cs);
			ppInner.joinRing(plInner, _kAdd);
	
			Point3d pt3Outer = ptCen - vec * radius;
			PLine plOuter(vecZ);
			plOuter.addVertex(ptCen);
			plOuter.addVertex(pt1);
			plOuter.addVertex(pt2, pt3Outer);
			plOuter.close();
			plOuter.convertToLineApprox(dEps);
			PlaneProfile ppOuter(cs);
			ppOuter.joinRing(plOuter, _kAdd);
			
			circle.convertToLineApprox(dEps);
			PlaneProfile ppCircle(cs);
			ppCircle.joinRing(circle, _kAdd);	
			
			ppInners.append(ppInner);
			ppOuters.append(ppOuter);
			ppCircles.append(ppCircle);			
			
			//dp.draw(circle);
			//dp.draw(i, ptCen, _XW, _YW, 0, 0);
			
		}//next i
	//endregion 

	//region Select closest
	    double dMin = U(10e6);
	    int n;
	    for (int i=0;i<ppCircles.length();i++) 
	    { 
	    	double d = (ppCircles[i].closestPointTo(ptJig)-ptJig).length();
	    	if (d<dMin)
	    	{ 
	    		dMin = d;
	    		n = i;
	    	}	    	 
	    }//next i
	    
	    double dInner = (ppInners[n].closestPointTo(ptJig)-ptJig).length();
	    double dOuter = ( ppOuters[n].closestPointTo(ptJig)-ptJig).length();
	    
	//endregion 

	//region Draw
		for (int i=0;i<ppCircles.length();i++) 
		{ 
			dp.trueColor(lightblue, 50);
			PlaneProfile pp = ppCircles[i];
			
			PlaneProfile& ppI = ppInners[i];
			PlaneProfile& ppO = ppOuters[i];

			int bInnerIsLarge = ppI.area() > ppO.area();

		// select / default
			PlaneProfile ppRef = dInner < dOuter ? ppI : ppO;
		
		// only inner 
			if (mode==tATInner)
				ppRef = ppI;
		// only outer
			else if (mode == tATOuter)
				ppRef = ppO;
		// smallest
			else if (mode == tATSmallest)
				ppRef = bInnerIsLarge ? ppO : ppI;
		// largest
			else if (mode == tATLargest)
				ppRef = bInnerIsLarge ? ppI : ppO;			
			

			if (i == n)
			{	
				if (mode==tATSelectSide)
				{ 
					dp.draw(pp,_kDrawFilled);
					dp.draw(pp,_kDrawFilled);					
				}

				dp.trueColor(darkyellow, 50);
				dp.draw(ppRef,_kDrawFilled);
				
				dp.trueColor(white, 0);
				dp.draw(ppRef);

				Point3d pt1 = ptsX1[i];
				Point3d pt2 = ptsX2[i];
				Point3d ptCen = ptsCen[i];
				Point3d ptArc = ptJig;
				
				Vector3d vecX1 = pt1 - ptCen; vecX1.normalize();
				Vector3d vecX2 = pt2 - ptCen; vecX2.normalize();

				Vector3d vecArc = vecX1 + vecX2;vecArc.normalize();
				if (ppShape.pointInProfile(ptCen + vecArc * dEps) != _kPointInProfile)vecArc *= -1;
				if (mode == tATOuter)vecArc *= -1;
				else if (mode==tATSmallest && bInnerIsLarge)vecArc *= -1;
				else if (mode==tATLargest && !bInnerIsLarge)vecArc *= -1;
				
				double dJigRadius = (ptJig - ptCen).length();
				PLine plDimArc(vecZ);
				plDimArc.addVertex(ptCen + vecX1 * dJigRadius);
				plDimArc.addVertex(ptCen + vecX2 * dJigRadius, ptCen+vecArc*dJigRadius);
				
			// force location to be on the dedicated side	
				if (mode==tATInner || mode==tATOuter || mode==tATSmallest || mode==tATLargest)//&& !plDimArc.isOn(ptJig)
				{
					dp.color(2);
					ptArc = ptCen + vecArc * dJigRadius;
				}
//dp.draw(PLine(ptCen, ptCen + vecArc * U(20)));
//dp.draw(plDimArc);
//dp.draw("mode" + mode+"\PInnerisLarge"+ bInnerIsLarge+"\Pi" + ppI.area() +"\Po:" + ppO.area(), ptJig, _XW,_YW, 0, 0);

				
				if (nColor >- 1)dp.color(nColor);
				DimAngular dimAng(ptCen, pt2, pt1, ptArc);
				dimAng.setUseDisplayTextHeight(bUseTextHeight);
				dimAng.setDimensionPlane(ptCen, vecX, vecZ);
				dimAng.setDimScale(dDimScale);
				dimAng.setText("<>");				
				//dimAng.setTextLocation(ptText);
				dp.draw(dimAng);
			}
			else
			{
				
				dp.draw(ppRef,_kDrawFilled);
				dp.transparency(0);
				if (mode==tATSelectSide)
					dp.draw(pp);
			}

		}//next i
			
	//endregion 

		return;
	}
//region SelectSegmentJig
	else if (_bOnJig && _kExecuteKey == kJigSelectSegment)
	{ 	

		Point3d ptJig = _Map.getPoint3d("_PtJig");
		Vector3d vecZ = _Map.getVector3d("vecZ");
		Map mapSegments = _Map.getMap("Segment[]");
		PLine plines[0];
		for (int i=0;i<mapSegments.length();i++) 
			if (mapSegments.hasPLine(i))
				plines.append(mapSegments.getPLine(i)); 

		if (plines.length()>0)
			ptJig += vecZ * vecZ.dotProduct(plines.first().coordSys().ptOrg() - ptJig);

		
		int nSelected;
		double dDist = U(10e6);
		for (int i=0;i<plines.length();i++) 
		{ 
			double d  = (plines[i].closestPointTo(ptJig)-ptJig).length(); 
			if (d<dDist)
			{ 
				dDist = d;
				nSelected = i;
			}
		}//next i
		
		Display dp(-1);
		double gap = dViewHeight/200;
		for (int i=0;i<plines.length();i++) 
		{ 
			PLine pl = plines[i];
			if (i==nSelected)
			{ 
				Point3d pt1 = pl.ptStart();
				Point3d pt2 = pl.ptEnd();
				Vector3d vecXS = pt2 - pt1;vecXS.normalize();
				Vector3d vecYS = vecXS.crossProduct(vecZ);	
				Point3d ptm = (pt1+pt2) * .5;
				int bIsArc = !pl.isOn(ptm);

				int r = 255,g = 255;
				double d = gap / 20;
				PLine pl1,pl2;
				pl1 = pl;
				//pl1.offset(-gap*.5);
				pl2 = pl1;
				dp.draw(pl);
				for (int j=0;j<10;j++) 
				{ 
					dp.trueColor(rgb(r, g, 255));
					dp.draw(pl1);
					dp.draw(pl2);					
					if (bIsArc)
					{ 
						pl1.offset(d);
						pl2.offset(-d);							
					}
					else
					{ 
						pl1.transformBy(-vecYS*d);
						pl2.transformBy(vecYS*d);					
					}				
					r -= 30;
					g -= 10;
				}//next j				
			}
			else
			{ 
				dp.trueColor(darkyellow, 0);
				dp.draw(pl);
			}
		}		
		return;
	}			
		
//endregion 


//End bOnJig//endregion 

//region Painter Collections
	String sPainterCollection = "Dimension\\";
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
	sPainters.insertAt(0, tDefaultEntry);
	

	
//endregion 

//region Properties
category = T("|Behaviour|");
	String sAngleModeName=T("|Angle Mode|");	
	String sAngleModes[] = { tAdjacentAngle, tComplementaryAngle};
	PropString sAngleMode(2,sAngleModes, sAngleModeName);	
	sAngleMode.setDescription(T("|Defines the Angle Mode|"));
	sAngleMode.setCategory(category);
	if (sAngleModes.find(sAngleMode) < 0)sAngleMode.set(tAdjacentAngle);

	String sModes[] ={tSMVertex, tSMSegment};// { tATSelectSide, tATInner, tATOuter, tATSmallest, tATLargest, tRefHorizontal, tRefVertical};//
	String sModeName=T("|Snap Mode|");	
	PropString sMode(0, sModes, sModeName);	
	sMode.setDescription(T("|Defines the Mode|"));
	sMode.setCategory(category);
	if (sModes.find(sMode) < 0)sMode.set(tSMVertex);//tATSelectSide); //
	//sMode.setReadOnly(bDebug ? 0 : _kHidden); // TODO

	String sSuppress90Name=T("|Suppress 90°|");	
	PropString sSuppress90(3, sNoYes, sSuppress90Name);	
	sSuppress90.setDescription(T("|Suppresses angles of 90° degrees|"));
	sSuppress90.setCategory(category);
	if (sNoYes.findNoCase(sSuppress90 ,- 1) < 0)sSuppress90.set(sNoYes.last());

	String sPainterName=T("|Filter|");	
	String sPainterDesc = T(" |If a painter collection named 'Dimension' is found only painters of this collection are considered.|");
	PropString sPainter(1, sPainters, sPainterName);	
	sPainter.setDescription(T("|Defines the painter definition to filter entities|") +sPainterDesc );
	sPainter.setCategory(category);
	int nPainter = sPainters.find(sPainter);
	if (nPainter<0){ nPainter=0;sPainter.set(sPainters[nPainter]);}
	String sPainterDef = bFullPainterPath ? sPainter : sPainterCollection + sPainter;

category = T("|Display|");
	String sFormatName=T("|Text|");	
	PropString sFormat(4, "", sFormatName);	
	sFormat.setDescription(T("|Defines the content of the text.|") + 
		T(" |<> or empty specifies the default value, use format variables to customize content|") + 
		T(", |(i.e. @(Angle:RL0) to show the angle without decimals)|"));
	sFormat.setCategory(category);
	{ 
		Map mapAdd;
		mapAdd.appendDouble("Angle Dim", 32.5);// dummy data
		sFormat.setDefinesFormatting("GenBeam", mapAdd);
	}
	
	String sDimStyleName=T("|Dimstyle|");	
	PropString sDimStyle(5, _DimStyles.sorted(), sDimStyleName);	
	sDimStyle.setDescription(T("|Defines the Dimstyle|"));
	sDimStyle.setCategory(category);
	if (_DimStyles.find(sDimStyle) < 0)sDimStyle.set(_DimStyles.first());


	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(0), sTextHeightName, _kLength);	
	dTextHeight.setDescription(T("|Defines the text height of the dimension|") + T(", |0 = byDimstyle|"));
	dTextHeight.setCategory(category);	
	
	String sGlobalScaleName=T("|Global Scale Factor|");	
	PropDouble dGlobalScale(nDoubleIndex++, 1, sGlobalScaleName,_kNoUnit);	
	dGlobalScale.setDescription(T("|Defines the scale factor to rescale the dimension|"));
	dGlobalScale.setCategory(category);
	if (dGlobalScale <= 0)dGlobalScale.set(1);

	String sColorName=T("|Color|");	
	PropInt nColor(nIntIndex++, -1, sColorName);	
	nColor.setDescription(T("|Defines the Color of the dimension|") + T("|This option requires the dimstyle to be defined with colors byBlock|"));
	nColor.setCategory(category);

	String sLineTypes[0]; sLineTypes=_LineTypes.sorted();
	sLineTypes.insertAt(0, tDisabled);
	String sLineTypeName=T("|Leader Linetype|");	
	PropString sLineType(6, sLineTypes, sLineTypeName, sLineTypes.length()>1?1:0);	
	sLineType.setDescription(T("|Defines the linetype of a potential leade line.|"));
	sLineType.setCategory(category);		
	if(sLineTypes.findNoCase(sLineType ,- 1)<0)sLineType.set(tDisabled);

// References
	int bHasPage, bHasSection, bInBlockSpace, bHasSDV, bHasViewport = _Viewport.length() > 0, bIsHsbViewport;
	int	bIsViewportSetup;	// true if the instance is a setup instance placed outside of paperspace

	MultiPage page;
	ShopDrawView sdv;
	GenBeam gb;
	EntPLine epl;	
	MetalPartCollectionEnt ce;
	Element el;
	Entity entDefine, showSet[0];
	Element elParent;
	Section2d section;ClipVolume clipVolume;
	
	CoordSys cs(),ms2ps, ps2ms;
	double dScale = 1;
	Vector3d vecX=_XU, vecY=_YU, vecZ = _ZU;
	int bDeltaOnTop = true;	
	
	PlaneProfile ppShape, ppPreviewShape, ppCreationShape, ppLayout(cs);
//End Properties//endregion 

//region OnInsert #1	
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		if (_kExecuteKey.length()>0 && TslInst().getListOfCatalogNames(scriptName()).findNoCase(_kExecuteKey,-1)>-1)
			setPropValuesFromCatalog(_kExecuteKey);						
	// standard dialog	
		else	
			showDialog();
		
	// get current space and property ints
		int bInLayoutTab = Viewport().inLayoutTab();
		int bInPaperSpace = Viewport().inPaperSpace();
		int hasSDV; 
		
	// find out if we are block space and have some shopdraw viewports
		Entity entsSDV[0];
		if (!bInLayoutTab)
		{
			entsSDV= Group().collectEntities(true, ShopDrawView(), _kAllSpaces);
		
		// shopdraw viewports found and no genbeams or multipages are found
			if (entsSDV.length()>0)
			{ 
				hasSDV = true;
				Entity ents[]= Group().collectEntities(true, GenBeam(), _kAllSpaces);
				ents.append(Group().collectEntities(true, MultiPage(), _kAllSpaces));
				if (ents.length()<1)
				{ 
					bInBlockSpace = true;
				}
			}
		}	
	// Paperspace	
		if (bInLayoutTab && bInPaperSpace)
		{
			Viewport vp;
			_Viewport.append(getViewport(T("|Select a viewport|")));
			vp = _Viewport[_Viewport.length()-1]; 
			dScale = vp.dScale();
			elParent = vp.element();
			ms2ps = vp.coordSys();
			vecX = _XW; vecY = _YW; vecZ = _ZW;
			
			PlaneProfile ppViewport(CoordSys());
			{
				Vector3d vec = .5* (vecX * vp.widthPS() + vecY  * vp.heightPS());
				ppViewport.createRectangle(LineSeg(vp.ptCenPS()-vec,vp.ptCenPS()+vec), vecX, vecY);
			}

			{ 
				Layout l = vp.getLayout();
				int rotation = l.plotRotation();//returns 0, 90, 180 or 270
				Vector3d vec =  (vecX * l.paperSizeX() + vecY * l.paperSizeY());
				ppLayout.createRectangle(LineSeg(_PtW, _PtW + vec), vecX, vecY);
				CoordSys rot;rot.setToRotation(rotation, _ZW, _PtW);
				ppLayout.transformBy(rot);
				LineSeg seg = ppLayout.extentInDir(vecX);
				ppLayout.transformBy(vecX * abs(vecX.dotProduct(seg.ptEnd() - seg.ptStart())));
			}

			int bIsSetup = true;

			String prompt = T("|Pick point left and outside of paperspace|") ;

			Point3d pt = _PtW;//+_Map.getVector3d(kViewportOrg);
			PrPoint ssP(prompt);//, _PtW);
		    Map mapArgs;
		    mapArgs.setPlaneProfile("ppLayout", ppLayout);
		    mapArgs.setPlaneProfile("ppViewport", ppViewport);
  
		    int nGoJig = -1;
		    while (nGoJig != _kOk)
		    {
		        nGoJig = ssP.goJig(kJigSetupLocation, mapArgs);// kJigSetupLocation

		        if (nGoJig == _kOk)
		        {
		            pt = ssP.value(); //retrieve the selected point
		        }
		        else if (nGoJig == _kCancel ||  nGoJig == _kNone)
		        { 
		        	eraseInstance();
		            return; 
		        }
		    }

			sMode.set(tSMSegment); // currently only segment mode


		// make sure valid point (outside) has been selected
			if (ppViewport.pointInProfile(pt)== _kPointOutsideProfile && ppLayout.pointInProfile(pt)==_kPointInProfile)
			{ 
				Point3d pts[] = ppLayout.intersectPoints(Plane(pt, vecY), true, false);
				pts = Line(pt, vecX).orderPoints(pts);
				if (pts.length()>0)
				{ 
					Vector3d vecDir = - vecX;
					Point3d ptx = pts.first();
					double d1 = abs(vecX.dotProduct(ptx - pt));
					double d2 = abs(vecX.dotProduct(pts.last() - pt));
					
					if (d2<d1)
					{ 
						ptx = pts.last();
						vecDir *= -1;
					}
					
					pt = ptx +vecDir * 20 * dTextHeight*dScale;
				}
					
			}


			double dX = 9 * dTextHeight * dScale;
			double dY = 4 * dTextHeight * dScale;
			_Pt0 = pt+.5*(_XW*.7*dX+_YW*dY);
			_PtG.append(_Pt0 - 6 * _XW * dTextHeight*dScale - _YW* dTextHeight*dScale*.5);
			_Map.setVector3d(kViewportOrg, pt-_PtW);
			return;
		}
		
		
		else
		{
		// prompt for entities
			PrEntity ssE;
			if (bInBlockSpace)
			{ 
				ssE = PrEntity(T("|Select shopdraw viewports|"), ShopDrawView());
			}
			else if (hasSDV)
			{ 
				ssE = PrEntity(T("|Select reference (genbeams, elements, multipages, sections or shopdraw viewports|"), ShopDrawView());
				ssE.addAllowedClass(MultiPage());
			}		
			else
			{
				ssE = PrEntity(T("|Select reference (genbeams, elements, multipages, sections or shopdraw viewports|"), MultiPage());
			}
	
			ssE.addAllowedClass(GenBeam());
			ssE.addAllowedClass(Element());
			ssE.addAllowedClass(ChildPanel());	
			ssE.addAllowedClass(EntPLine());
			ssE.addAllowedClass(MetalPartCollectionEnt());
			ssE.addAllowedClass(Section2d());
			
			if (ssE.go())
				_Entity.append(ssE.set());			
		}
	
	}			
//endregion 
	
// End Part #1
//endregion 	
	
//region Collect entities
	Entity entities[0];
	Vector3d vecZM = _ZU;
	PLine plSetupContour;
	int nActiveZoneIndex = - 999;
	
// Pre collecting section, sdv or multipages
	for (int i=0;i<_Entity.length();i++) 
	{ 
		Entity ent = _Entity[i];
		
	//region ShopdrawView
		ShopDrawView _sdv = (ShopDrawView) ent;		
		if (_sdv.bIsValid())
		{ 
			sdv = _sdv;
			bHasSDV = true;
			if (_bOnInsert)
				return;
			break;
		}		
	//endregion 	
	
	//region MultiPage
		MultiPage _page = (MultiPage) ent;
		if (_page.bIsValid())
		{ 
			page = _page;
			bHasPage = true;
			setDependencyOnEntity(ent);
			assignToGroups(ent, 'D');
			entDefine = ent;

		//region Select viewport on insert
			if (_bOnInsert)
			{ 	
			//region Collect all viewport profiles and the associated multipage view
				Map mapArgs;
				PlaneProfile ppVPs[0];
				MultiPageView mpvs[] = page.views();
				for (int j=0;j<mpvs.length();j++) 
				{ 
					MultiPageView& mpv = mpvs[j];
					
					ms2ps = mpv.modelToView();
					ps2ms = ms2ps;
					ps2ms.invert();						
					
					PlaneProfile pp(cs);
					// skip isometric views
					if (!ps2ms.vecX().isParallelTo(_ZW) && 
						!ps2ms.vecY().isParallelTo(_ZW) && !ps2ms.vecZ().isParallelTo(_ZW))
					{ 
						mpvs.removeAt(j);
						continue;
					}
					else
						pp.joinRing(mpv.plShape(), _kAdd);

					ppVPs.append(pp);
					mapArgs.appendPlaneProfile("pp", pp);
	

				}//next j			
			//endregion		
			
			//region Show Jig
				if (ppVPs.length() >1)
				{
					Point3d pt;
					
					PrPoint ssP(T("|Select viewport|")); //second argument will set _PtBase in map
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
				}
				//End Show Jig//endregion 					

			// store model view	
				Vector3d vecModelView = _ZW;
				vecModelView.transformBy(ps2ms);
				vecModelView.normalize();
				_Map.setVector3d("ModelView", vecModelView);
				
				page.regenerate();
			}	
		//endregion 

		//region Get show set
			entities = page.showSet();
			vecX = _XW;
			vecY = _YW;
			vecZ = _ZW;
			
			if (entities.length()<1)
			{
				reportMessage(TN("|No show set found for multipage| ") + page.handle());
				break;
			}			
		
		// keep relative loocation to multipage 
			Point3d ptOrg = page.coordSys().ptOrg();
			_Pt0.setZ(ptOrg.Z());
			if (_Map.hasVector3d("vecOrg") && !_bOnDbCreated && !bDebug)
			{
				Point3d ptX = _Pt0;
				if(_kNameLastChangedProp!="_Pt0")
					_Pt0 = ptOrg + _Map.getVector3d("vecOrg");
				for (int g=0;g<_PtG.length();g++) 
					if(_kNameLastChangedProp!="_PtG"+g)
						_PtG[g].transformBy(_Pt0-ptX);
			}
			for (int g=0;g<_PtG.length();g++)
				_PtG[g].setZ(ptOrg.Z());
		//endregion 

		//region Get selected view of multipage
			Vector3d vecModelView = _Map.getVector3d("ModelView");
			vecZM = _ZW;
			MultiPageView mpv, views[] = page.views();
			for (int i=0;i<views.length();i++) 
			{ 
				ms2ps = views[i].modelToView();
				ps2ms = ms2ps; ps2ms.invert();
				vecZM = _ZW;
				vecZM.transformBy(ps2ms);vecZM.normalize();
				if (vecModelView.isCodirectionalTo(vecZM))
				{ 
					//views[i].plShape().vis(1);
					break;
				}
			}//next i				
		//endregion 
		
			ppShape = PlaneProfile(CoordSys(ptOrg, vecX, vecY, vecZ));
		
			break;
		}			
	//endregion 
		
	//region Section
		Section2d _section = (Section2d) ent;
		if (_section.bIsValid())
		{ 
			//TODO scale
			section = _section;
			bHasSection = true;
			setDependencyOnEntity(ent);
			assignToGroups(ent, 'D');
			entDefine = ent;
			
			ms2ps = section.modelToSection();
			ps2ms = ms2ps; 	ps2ms.invert();	
			vecX = _XW; vecY = _YW; vecZ = _ZW;			

			vecZM = _ZW;
			vecZM.transformBy(ps2ms);	vecZM.normalize();
				
		// clip volume		
			clipVolume= section.clipVolume();
			if (!clipVolume.bIsValid())
			{ 
				eraseInstance();
				return;
			}
			_Entity.append(clipVolume);			
			setDependencyOnEntity(clipVolume);
		
			entities = clipVolume.entitiesInClipVolume(true);
			ppShape = PlaneProfile(CoordSys(section.coordSys().ptOrg(), vecX, vecY, vecZ));
			break;
		}				
	//endregion 	
	
		
	}//next i
	if (_Entity.length()==1 && !entDefine.bIsValid())
		entDefine = _Entity[0];



//region Blockspace with shopdrawviewport	
	if (_Entity.length()<1 && _Map.getInt(kBlockCreationMode)) // Blockspace creation
	{ 
		return;
	}
	if (bHasSDV)
	{ 
		ViewData viewDatas[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets, 0);
		int nIndFound = ViewData().findDataForViewport(viewDatas, sdv);//find the viewData for my view
	
	//region On Generate Shopdrawing
		if (_bOnGenerateShopDrawing && nIndFound>-1)
		{ 
			
		// Get multipage from _Map
			Entity entCollector = _Map.getEntity(_kOnGenerateShopDrawing +"\\entCollector");
			Map mapTslCreatedFlags = entCollector.subMapX("mpTslCreatedFlags");
			String uid = _Map.getString("UID"); // get the UID from map as instance does not exist onGenerateShopDrawing
			int bIsCreated = mapTslCreatedFlags.hasInt(uid);			

		// Create modelspace instance if not tagged as being created
			if (!bIsCreated && entCollector.bIsValid())
			{ 
				ViewData viewData = viewDatas[nIndFound];
			
			// Get defining genbeam
				Entity entDefine;
				Entity ents[] = viewData.showSetDefineEntities();
				if (ents.length() > 0)// && ents.first().bIsKindOf(GenBeam()))
					entDefine = ents.first();
				//if (!entDefine.bIsValid()) { continue; }
				
			// Transformations
				ms2ps = viewData.coordSys();
				ps2ms = ms2ps;
				ps2ms.invert();		
				
				
			// the viewdirection of this shopdrawview in modelspace
				Vector3d vecAllowedView = _ZW;
				vecAllowedView.transformBy(ps2ms);
				vecAllowedView.normalize();
				
				
			// create TSL
				TslInst tslNew;
				GenBeam gbsTsl[] = {};		Entity entsTsl[] = {entCollector};			Point3d ptsTsl[] = {_Pt0};
				int nProps[]={nColor};			
				double dProps[]={dTextHeight,dGlobalScale};				
				String sProps[]={sMode,sPainter,sAngleMode,sSuppress90,sFormat,sDimStyle,sLineType};
				Map mapTsl;	
				
				mapTsl.setVector3d("vecOrg",  _Pt0 - _PtW); // relocate to multipage
				
				{ 
					String k;
					k = "arcRadius"; 	if (_Map.hasDouble(k)) mapTsl.setDouble(k, _Map.getDouble(k));
					
					k = "vecArcOut"; 	if (_Map.hasVector3d(k)) mapTsl.setVector3d(k, _Map.getVector3d(k));
					k = "vecArc"; 		if (_Map.hasVector3d(k)) mapTsl.setVector3d(k, _Map.getVector3d(k));
					k = "vecN"; 		if (_Map.hasVector3d(k)) mapTsl.setVector3d(k, _Map.getVector3d(k));
					k = kBaseOffset; 	if (_Map.hasVector3d(k)) mapTsl.setVector3d(k, _Map.getVector3d(k));
					k = "vecTextLocation"; 	if (_Map.hasVector3d(k)) mapTsl.setVector3d(k, _Map.getVector3d(k));
					
				}
	
				mapTsl.setVector3d("ModelView", vecAllowedView);// the offset from the viewpport
				mapTsl.setInt(kBlockCreationMode, true);
	
				tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			
	
				if (tslNew.bIsValid())
				{
					if (nColor==-1 && _Map.hasInt("Color"))
						tslNew.setColor(_Map.getInt("Color"));
					tslNew.transformBy(Vector3d(0, 0, 0));
					
				// flag entCollector such that on regenaration no additional instances will be created	
					if (!bIsCreated)
					{
						bIsCreated=true;
						mapTslCreatedFlags.setInt(uid, true);
						entCollector.setSubMapX("mpTslCreatedFlags",mapTslCreatedFlags);
					}
				}				
			}
			
		}
	//endregion 

	//region Blockspace Setup
		else
		{ 
			bInBlockSpace = true;
			setDependencyOnEntity(sdv);
			_Map.setString("UID", _ThisInst.uniqueId()); // store UID to have access during _kOnGenerateShopDrawing
			if (nColor==-1 && _ThisInst.color()>-1)
				_Map.setInt("Color", _ThisInst.color());
			
		//region Get bounds of viewports
			PlaneProfile pp(cs);
			Point3d pts[] = sdv.gripPoints();
			Point3d ptCen= sdv.coordSys().ptOrg();
			double dX = U(1000), dY =dX; // something			
			for (int i=0;i<2;i++) 
			{ 
				Vector3d vec = i == 0 ? _XW : _YW;
				pts = Line(_Pt0, vec).orderPoints(pts);
				if (pts.length()>0)	
				{
					double dd = vec.dotProduct(pts.last() - pts.first());
					if (i == 0)dX = dd;
					else dY = dd;
				}
				 
			}//next i
			
			PLine pl;
			Vector3d vec = .5 * (_XW * dX + _YW * dY);
			pl.createRectangle(LineSeg(ptCen - vec, ptCen + vec), _XW, _YW);
			pp.joinRing(pl, _kAdd);		
			pp.extentInDir(_XW).vis(1);					
		//endregion 

		//region Display
			int bUseTextHeight;
			Display dp(-1);
			dp.trueColor(brown);
			dp.dimStyle(sDimStyle, dScale);
			double textHeight = dTextHeight*dScale;
			double textHeightForStyle = dp.textHeightForStyle("O", sDimStyle)*dScale;
			double dDimScale = (dGlobalScale>0?dGlobalScale:1)*dScale;
			if (dTextHeight<= 0) 
				textHeight = textHeightForStyle;
			else 
			{
				bUseTextHeight = true;
				dp.textHeight(textHeight);
			}				
		//endregion 

		//region Create preview graphics
			dX -= textHeight;
			dY -= textHeight;
			vec = .5 * (_XW * dX + _YW * dY);
			pl = PLine(_ZW);
			Point3d pt = ptCen - vec;
			
			// get potential planeprofile
			Map m = sdv.subMapX("Preview");
			Entity originator = m.getEntity("originator");
			if (m.hasPlaneProfile("pp") && originator.bIsValid())
			{ 
				ppPreviewShape = m.getPlaneProfile("pp");
				//ppPreviewShape.extentInDir(_XW+_YW).vis(3);
			}			
			else
			{ 
				pl.addVertex(pt);
				pl.addVertex(pt+_YW*.5*dY);
				pl.addVertex(pt+_XW*(dX-.5*dY)+_YW*dY);
				pl.addVertex(pt+_XW*(dX-.5*dY), pt+_XW*dX+.5*_YW*dY);
				pl.close();
	
				ppPreviewShape=PlaneProfile(cs);
				ppPreviewShape.joinRing(pl,_kAdd);
				PlaneProfile ppSub = ppPreviewShape;
				double dShrink = (dX < dY ? dX : dY) *.25;
				dShrink = textHeight < dShrink ? 2*textHeight:dShrink;
				ppSub.shrink(dShrink);
				ppPreviewShape.subtractProfile(ppSub);

			// store against parent sdv
				originator = _ThisInst;
				m.setEntity("originator", originator);
				m.setPlaneProfile("pp", ppPreviewShape);
				sdv.setSubMapX("Preview", m);
			}
			
		// only the originator draws the preview	
			if (originator == _ThisInst)
			{ 
				dp.trueColor(brown);
				dp.draw(ppPreviewShape);
			}			

			ppShape = ppPreviewShape;
			if (_bOnDbCreated)
			{ 
				_Pt0 = pt+_YW*.5*dY;
				Vector3d vec = _YW - _XW; vec.normalize(); 
				_PtG.append(_Pt0 + vec * 4 * textHeight);
				_PtG.append(_Pt0 - _XW * 4 * textHeight);
			}
		//endregion 	

		}
	//endregion 
	}			
	//endregion 

//region Paperspace Viewport	
	else if (bHasViewport)
	{ 
		Viewport vp = _Viewport.first();
		dScale = vp.dScale();
		elParent = vp.element();
		
		ms2ps = vp.coordSys();
		ps2ms = ms2ps;	ps2ms.invert();		
		vecX = _XW; vecY = _YW; vecZ = _ZW;
		
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
				if (nPainter>0 || nActiveZoneIndex==999 || z==nActiveZoneIndex)
					entities.append(g);					 
			}					
		}
		
	//Viewport Setup Graphics: currently restricted to be left of paperspace, can be anywhere outside once HSB-16830 is implemented
		bIsViewportSetup = ppLayout.pointInProfile(_Pt0)==_kPointOutsideProfile;//_XW.dotProduct(_Pt0 - _PtW) < dTextHeight * dScale;

	}//endregion

// All other entities	
	else if(!bHasSection && !bHasPage)
		entities = _Entity;
	if (bDebug)reportNotice(("\n" + entities.length() + " entities filtered dependent to ") + entDefine.typeDxfName());

// Painterdefinition selected
	if (nPainter>0)
	{ 
	// buffer collectoin entities to be re-added after painter filter
		Entity entCEs[0];
		for (int i=0;i<entities.length();i++) 
			if (entities[i].bIsKindOf(CollectionEntity()))
				entCEs.append(entities[i]); 
		
	// Element: if the set contains only one element and painter is selected we assume the targe will be a subset of the element items	
		if (entities.length()==1 && entities.first().bIsKindOf(Element()))
		{ 
			elParent = (Element)entities.first();
			Entity ents2[0];
			// genbeams
			{ 
				GenBeam x[] = elParent.genBeam();
				for (int i=0;i<x.length();i++) 
					ents2.append(x[i]); 
			}	
			if (ents2.length()>0)
				entities = ents2;
		}
	
		PainterDefinition pd(sPainterDef);
		entities = pd.filterAcceptedEntities(entities);
		if (entities.length()<1 && !bJig && !bHasViewport)
		{ 
			if (_kNameLastChangedProp==sPainterName)
			{ 
				String prompt = "\n" + sPainter + T(" |does not return any entity and the dimension will be purged|")+
					T("|Do you want to keep the instance with mo filter instead? [No/Yes]|");
				String ret = getString(prompt);
				if (ret.length()>0 && ret.left(1).makeUpper()==T("|Yes|").makeUpper().left(1))
				{ 
					sPainter.set(tDefaultEntry);
					setExecutionLoops(2);
					return;
				}				
			}
			else
			{
				reportMessage(TN("|No entities found in selection set|"));
				eraseInstance();
				return;				
			}
		}
		
	// re-add page in case painter filters it	
		for (int i=0;i<entCEs.length();i++) 		
			if(entities.find(entCEs[i])<0)
				entities.append(entCEs[i]); 

	}
		
//endregion 	

//region Resolve Entities to retrieve dimension shape
	Element elParents[0];
	for (int i=0;i<entities.length();i++) 
	{ 
		Entity& ent =  entities[i];
		
		if (bDebug)reportNotice("\n	resolving " + i + " = " + ent.typeDxfName() + " " + ent.handle());
		
		gb=(GenBeam)ent;
		epl=(EntPLine)ent;
		ce = (MetalPartCollectionEnt)ent;
		el = (Element)ent;

		Element _elParent = ent.element();


	// GenBeam	
		if (gb.bIsValid())
		{
			if (!entDefine.bIsValid() || entDefine==gb)
			{ 
				Quader qdr(gb.ptCen(), gb.vecX(), gb.vecY(), gb.vecZ(), gb.solidLength(), gb.solidWidth(), gb.solidHeight(), 0, 0, 0);			
				//qdr.vis(2);_ZU.vis(qdr.pointAt(0, 0, 0), 2);
				Vector3d vecX, vecY;
				Vector3d vecZ = qdr.vecD(_ZU);
				
				if (vecZ.isCodirectionalTo(_ZU))
				{ 
					vecX = _XU;
					vecY = _YU;
				}
				else if (vecZ.isParallelTo(gb.vecX()))
					vecX = gb.vecZ();
				else
				{
					vecX = gb.vecX();	
					if (vecX.isParallelTo(_YU))
						vecX = gb.vecY();
				}
					
				vecY = vecX.crossProduct(-vecZ);
				
				// align with element Y
				if (_elParent .bIsValid() && vecY.dotProduct(_elParent .vecY())<0)
				{ 
					vecX *= -1;
					vecY *= -1;
				}
				// align with _ZW
				else if (vecY.isParallelTo(_ZW) && vecY.dotProduct(_ZW)<0)
				{ 
					vecX *= -1;
					vecY *= -1;
				}
				cs = CoordSys(gb.ptCen() +vecZ *  .5 * qdr.dD(vecZ), vecX, vecY, vecZ);
				cs.vis(2);
				ppShape = PlaneProfile(cs);
				entDefine = gb;
				vecZM = vecZ;
			}	
			if (bDebug)reportNotice("\n	genbeam " + gb.posnum() + " " + gb.type());
	
			//Vector3d vecZM = gb.vecZ();
			Body bd = gb.realBody();
			
			if (bHasViewport || bHasSection || bHasPage)
			{ 
				bd.vis(4);
				bd.transformBy(ms2ps);
				bd.vis(3);
				//vecZM.transformBy(ms2ps); vecZM.normalize();
			}
			Plane pn(cs.ptOrg(), vecZ);
			PlaneProfile pp;
			if (vecZ.isParallelTo(vecZM))
				pp= bd.extractContactFaceInPlane(pn, 2*dEps);
			if (pp.area()<pow(dEps,2))
				pp = bd.shadowProfile(pn);
			pp.shrink(-dEps);
			ppShape.unionWith(pp);

		}
	// EntPLine	
		else if (epl.bIsValid())
		{
			PLine pl = epl.getPLine();
			CoordSys csp = pl.coordSys();
			if (csp.vecZ().isParallelTo(_ZW))
				csp = CoordSys(csp.ptOrg(), _XW, _YW, _ZW);
			else if (csp.vecZ().isPerpendicularTo(_ZW))
				csp = CoordSys(csp.ptOrg(), _ZW.crossProduct(csp.vecZ()), _ZW, csp.vecZ());	
			ppShape = PlaneProfile(csp);
			ppShape.joinRing(pl, _kAdd);
			ppShape.shrink(-dEps);
			setDependencyOnEntity(ent);
			entDefine = ent;
			break;
		}
	// CollectionEntity
		else if (ce.bIsValid())
		{ 
			MetalPartCollectionDef cd=ce.definition();
			if (!cd.bIsValid())continue;
			if (bDebug)reportNotice("\n	collection entity " + ce.definition());
			CoordSys cse =ce.coordSys();

			if (bHasSection || bHasPage || bHasViewport)
				cse.transformBy(ms2ps);
			
			Vector3d vecZM = vecZ;//_ZW;
			//vecZM.transformBy(cse);			
			//vecZM.transformBy(ps2ms);

			vecZM.vis(ce.coordSys().ptOrg(),6);
			
			cs = CoordSys (cse.ptOrg(), _XU, _YU, _ZU);
			if (!bHasSection && !bHasPage && !bHasViewport)
				ppShape = PlaneProfile(cs);
			PlaneProfile shape(cs);	

			Entity _ents[0];
			getMetalPartEntities(ce, _ents);

//			if (nPainter>-1) // TODO
//			{ 
//				PainterDefinition pd(sPainterDef);
//				_ents = pd.filterAcceptedEntities(_ents);
//			}

			for (int j=0;j<_ents.length();j++) 
			{ 
				
				Body b;
				GenBeam g=(GenBeam)_ents[j];
				if (g.bIsValid())
				{
					CoordSys csg = g.coordSys();
					csg.transformBy(cse);
					
					if (csg.vecX().isParallelTo(vecZ) || csg.vecY().isParallelTo(vecZ) || csg.vecZ().isParallelTo(vecZ))
					{ 
						b = g.envelopeBody(true, true);
					}
					else
					{ 
						// rejecting as not coplanar to view;
					}
//					
//					
//					
//					csg.transformBy(b.ptCen() - csg.ptOrg());
//					csg.vis(2);
					
				}
				else 
				{
					b = _ents[j].realBody();
					//b.transformBy(cse);
				}

				if (b.isNull()){continue;}
				b.transformBy(cse);
				
				b.vis(j+1);						
				Point3d pts[] = b.extremeVertices(-vecZM);
				if (pts.length() < 1)continue;
				Plane pn(pts.first(), -vecZM);
				PlaneProfile pp = b.extractContactFaceInPlane(pn, dEps);
				if (pp.area()<pow(dEps,2))
					pp = b.shadowProfile(pn);
				pp.shrink(-dEps);	//pp.vis(j+1);
				shape.unionWith(pp);				 
			}//next j

			ppShape.unionWith(shape);
			shape.vis(2);

		}
	// Element
		else if (el.bIsValid())
		{ 
			if (!entDefine.bIsValid())
			{ 
				entDefine = el;
				
			}

			PLine pl;
			vecZM.vis(_Pt0, 150);
			Vector3d vecXE = vecX, vecYE = vecY, vecZE = vecZ;
			if (vecZM.isParallelTo(el.vecX()))
			{ 
				vecXE = el.vecZ();
				vecYE = el.vecY();
				vecZE = -el.vecX();
				
				pl.createRectangle(el.segmentMinMax(), vecXE, vecYE);
			}
			else if (vecZM.isParallelTo(el.vecY()))
			{ 
				vecXE = el.vecX();
				vecYE = -el.vecZ();
				vecZE = el.vecY();					

				pl = el.plOutlineWall();
				if (pl.area()<pow(dEps,2))
					pl.createRectangle(el.segmentMinMax(), vecXE, vecYE);
					
			// override for planview		
				if (vecZE.isParallelTo(_ZW))
				{ 
					vecXE = _XW;
					vecYE = _YW;
					vecZE = _ZW;
				}
			}
			else
			{ 
				vecXE = el.vecX();
				vecYE = el.vecY();
				vecZE = el.vecZ();					
				pl = el.plEnvelope();
			}
			
		// set coordSys to element in model if defining entity
			if (entDefine == el || !entDefine.bIsValid())
			{ 
				vecX = vecXE;
				vecY = vecYE;
				vecZ = vecZE;					
				if (!entDefine.bIsValid())
				{
					entDefine = el;
					ppShape = PlaneProfile(CoordSys(el.ptOrg(), vecXE, vecYE, vecZE));
				}
			
			}
			
			cs = CoordSys(el.ptOrg(), vecXE, vecYE, vecZE);
			PlaneProfile pp(cs);
			pp.joinRing(pl, _kAdd);
			pp.shrink(-dEps);
			pp.transformBy(ms2ps);
			//pp.vis(2);
			ppShape.unionWith(pp);
		}
	
	// collect potential parent element
		if (elParent.bIsValid() && elParents.find(_elParent )<0)
			elParents.append(_elParent );
	
	}
	ppShape.shrink(dEps);
	ppShape.simplify();
	
	//reportNotice("\n	shape "  + " = " + ppShape.area());
	//if(bDebug)drawPlaneProfile(ppShape, 0, 2, 60);//#func

//region Display
	int bUseTextHeight;
	Display dp(nColor);
	dp.dimStyle(sDimStyle, dScale);
	dp.addHideDirection(vecX);
	dp.addHideDirection(-vecX);
	dp.addHideDirection(vecY);
	dp.addHideDirection(-vecY);
	
	double textHeight = dTextHeight*dScale;
	double textHeightForStyle = dp.textHeightForStyle("O", sDimStyle)*dScale;
	double dDimScale = (dGlobalScale>0?dGlobalScale:1)*dScale;
	if (dTextHeight<= 0) 
		textHeight = textHeightForStyle;
	else 
	{
		bUseTextHeight = true;
		dp.textHeight(textHeight);
	}
	
	int bSuppress90 = sSuppress90 == sNoYes.last();
//	int bIsRefMode = sMode == tRefVertical || sMode == tRefHorizontal;
	int bFullAngle = sAngleMode==tComplementaryAngle;
	
//endregion 

//region Group assignment
	if (!bHasPage && !bHasSection && !bHasViewport)
	{ 
		if (elParents.length()==1)
			assignToElementGroup(elParents.first(), true, 0, 'D');
		else if (elParents.length()>1)
		{ 
			for (int i=0;i<elParents.length();i++) 
				assignToElementGroup(elParents[i], false, 0, 'D');		
		}	
		else if (entities.length()>0)
			assignToGroups(entities.first(), 'D');
	}	
//endregion 



//region Draw Setup Graphiocs in Paperspace
	if (bIsViewportSetup)
	{ 
		assignToLayer("0");
		sMode.set(tSMSegment);
		sMode.setReadOnly(true);

		double dX = 9 * dTextHeight * dScale;
		double dY = 4 * dTextHeight * dScale;

		PLine pl(_ZW);
		Point3d pt = _PtW+ (_Map.hasVector3d(kViewportOrg)?_Map.getVector3d(kViewportOrg):-_XW*1.5*dX);			
		pl.addVertex(pt);
		pl.addVertex(pt+_XW*.7*dX+_YW*dY);
		pl.addVertex(pt+_XW*dX+_YW*dY);
		pl.addVertex(pt+_XW*dX);
		pl.close();
		plSetupContour = pl;
		
		ppPreviewShape = PlaneProfile(cs);
		ppPreviewShape.joinRing(pl,_kAdd);
		
		ppCreationShape = ppShape;
		ppShape = ppPreviewShape;
			
		PlaneProfile pp1 = ppPreviewShape;
		PlaneProfile pp2 = pp1;
		pp2.shrink(.5*dTextHeight * dScale);
		pp1.subtractProfile(pp2);
		
		Display dpc(-1);
		dpc.trueColor(darkyellow);
		dpc.draw(pp1, _kDrawFilled, 80);
		dpc.draw(pp1);		

	// draw info
		String filter = T("|None|");
		if (nPainter > 0)filter = sPainter;
		else if (nActiveZoneIndex == 999)filter = T("|All Zones|");
		else if (nActiveZoneIndex >-999)filter = T("|Zone| ")+nActiveZoneIndex;

		String text = scriptName() + T("\\P|Filter|: " + filter);
		text += " ("+entities.length() + ")";
		dp.draw(text, pt, _XW,_YW, 1 ,- 2);
			
		if (bJig)
			return;	
			
					
			
	}
// Layer assignment to current viewport element layer	
	else if (bIsHsbViewport)
	{ 
		String currentLayer = _ThisInst.layerName();
		String layerName = "VP~HSBEL" + elParent.number() + "~";
		if (currentLayer.left(8)!="VP~HSBEL")
			assignToLayer(layerName);			
	} 
	//endregion 

	if (!bHasViewport && ppShape.area()<pow(dEps,2))
	{ 
		if (entities.length()>0 || bDebug)
			reportMessage("\n" + T("|Invalid selection|"));
		eraseInstance();
		return;
	}

	
	if (!elParent.bIsValid())
		elParent = entDefine.element();
//endregion 

//region Analyse Shapes
	double radius = .1* textHeight;//dViewHeight/30;
	
	cs = ppShape.coordSys();
	vecX = cs.vecX();
	vecY = cs.vecY();
	vecZ = cs.vecZ();	
	
	PLine rings[] = ppShape.allRings();
	
	Point3d ptsCen[0], ptsX1[0], ptsX2[0], ptsAll[0];
	int bIsArcs[0]; // a flag if the first segment is an arc	
	Vector3d vecsN[0];
	PLine plArcSegs[0];
	
	// variables for the creation mode of viewports and multipages
	Point3d ptsCen_C[0], ptsX1_C[0], ptsX2_C[0], ptsAll_C[0];
	int bIsArcs_C[0]; // a flag if the first segment is an arc	
	Vector3d vecsN_C[0];
	PLine plArcSegs_C[0];	
	
	
	Map mapArgs;
	mapArgs.setString("mode", sMode);
	mapArgs.setPlaneProfile(kShape, ppShape);
	mapArgs.setDouble("DimScale", dDimScale);
	mapArgs.setInt("Color", nColor);
	mapArgs.setString(kDimDimstyle, sDimStyle);
	mapArgs.setDouble(kTextHeight, textHeight);

// Collect potential center points from shape
	int numShape = bIsViewportSetup ? 2 : 1;
	for (int k=0;k<numShape;k++) 
	{ 	
		PLine rings_K[0];
		if (k==0)
			rings_K =rings; 
		else if (k==1) // use the shape of the collected entities
			rings_K = ppCreationShape.allRings();
//		
//	//region Remove circles or small openings 
//		for (int r=rings_K.length()-1; r>=0 ; r--) 
//		{ 
//			PLine& pl = rings_K[r]; 
//			if (pl.area()<pow(U(30),2))
//			{ 
//				//drawPLine(pl, U(50), r, 60);//#func
//				rings_K.removeAt(r);
//				continue;
//			}
//			
//			PlaneProfile pp1(pl);		
//			if (abs(pp1.dX()-pp1.dY())>dEps){ continue;}
//			PLine c; c.createCircle(pp1.ptMid(), pp1.coordSys().vecZ(), pp1.dX() * .5);
//			
//			PlaneProfile pp2(c);
//			pp1.subtractProfile(pp2);
//		
//			if (pp1.area()<pow(U(1),2))
//			{ 
//				//drawPLine(pl, U(50), r, 60);//#func
//				rings_K.removeAt(r);
//				continue;
//			}
//			
//		}//next r
//		
//			
//	//endregion 	
		
		
		
		
		for (int r=0;r<rings_K.length();r++) 
		{ 
			PLine& pl = rings_K[r]; pl.vis(252);
			
			pl.reconstructArcs(dEps, 70);
			pl.simplify();

			PlaneProfile ppRing(cs);
			ppRing.joinRing(pl, _kAdd);
			Point3d pts[] = pl.vertexPoints(true);
			int num = pts.length();		
			ptsAll.append(pts);
			
		// loop vertices
			for (int p = 0; p < pts.length(); p++)
			{
				int a = p+1;a = a > num - 1 ? a-num:a;
				int b = p+2;b = b > num-1 ? b-num:b;
	
				Point3d pt1 = pts[p];
				Point3d ptCen = pts[a];
				Point3d pt2 = pts[b];	//pt1.vis(p); pt2.vis(p + 1);
				ptCen.vis(4);
				
	
				int bIsArc1;
				{
					Point3d ptm = (pt1 + ptCen) * .5;
					bIsArc1 = (pl.closestPointTo(ptm) - ptm).length() > dEps; // tolerance issue with = !pl.isOn((pt1 + ptCen) * .5);	
				}
				int bIsArc2;
				{
					Point3d ptm = (pt2 + ptCen) * .5;
					bIsArc2 = (pl.closestPointTo(ptm) - ptm).length() > dEps; // = !pl.isOn( (pt2 + ptCen) * .5);
				}
				if (bIsArc1 )
				{
					if(sFormat.find("Arc Length",0, false)<1) { continue;}//TODO
					pt2 = ptCen;
					Vector3d vecXS = pt2 - pt1;vecXS.normalize();
					Vector3d vecYS = vecXS.crossProduct(-vecZ);vecYS.normalize();
					Point3d ptm = (pt1 + pt2) * .5;
				
				// the arc
					PLine plArc(vecZ);
					plArc.addVertex(pt1);
					plArc.addVertex(pt2, pl.getPointAtDist(pl.getDistAtPoint(pt1)+dEps));	
					if (plArc.length() < dEps){continue;}
							
					Point3d ptmx = plArc.ptMid();// midpoint on arc
					
				// calculate radius from circular segment
					Vector3d vecCen = ptm - ptmx;
					double h = (ptm - ptmx).length();
					if (h < dEps){continue;}
					double s = (pt2 - pt1).length();
					double radius = (4 * pow(h,2) + pow(s, 2)) / (8 * h);
					
				//	get center and circle
					vecCen.normalize();
					if (ppRing.pointInProfile(ptmx+vecYS*dEps)==_kPointInProfile)	vecYS *= -1;	
					//vecYS.vis(ptCen, 72);
					ptCen = ptmx + vecCen* radius;
					
					//PLine circle; circle.createCircle(ptCen, vecZ, radius);		circle.vis(1);
					
					
					if (k==0)
					{ 
						ptsCen.append(ptCen);
						ptsX1.append(pt1);
						ptsX2.append(pt2);
						bIsArcs.append(true);
						vecsN.append(-vecCen);
						plArcSegs.append(plArc);
					}
					else
					{ 
						ptsCen_C.append(ptCen);
						ptsX1_C.append(pt1);
						ptsX2_C.append(pt2);
						bIsArcs_C.append(true);	
						vecsN.append(-vecCen);
						plArcSegs_C.append(plArc);
					}
					//vecsN[vecsN.length()-1].vis(ptCen,4);
					continue;
				}			
				else if (bIsArc2)
				{
					continue;
				}
				
	
				
				PLine circle; circle.createCircle(ptCen, cs.vecZ(), radius);	//circle.vis(252);
				
				Vector3d vecX1 = pt1 - ptCen; vecX1.normalize();	//vecX1.vis(pt1, 1);
				Vector3d vecY1 = vecX1.crossProduct(-vecZ);
				Point3d pts1[] = Line(ptCen, -vecX1).orderPoints(circle.intersectPoints(Plane(ptCen, vecY1)),dEps);
				
				Vector3d vecX2 = pt2 - ptCen; vecX2.normalize();	//vecX2.vis(pt2, 2);
				Vector3d vecY2 = vecX2.crossProduct(-vecZ);
				Point3d pts2[] = Line(ptCen, -vecX2).orderPoints(circle.intersectPoints(Plane(ptCen, vecY2)),dEps);
				
				Vector3d vecN = - vecX1 - vecX2; vecN.normalize();
				if (ppShape.pointInProfile(ptCen + vecN * dEps) == _kPointInProfile)vecN *= -1;
				
				
			// suppress 90° or 180°
				double dAngle = vecX1.angleTo(vecX2);
				if (bSuppress90 && (vecX1.isPerpendicularTo(vecX2) || vecX1.isParallelTo(vecX2) || abs(dAngle-90)<dEps || abs(dAngle-180)<dEps|| abs(dAngle-270)<dEps))
				{
					continue;
				}
				
				if (pts1.length() < 1 || pts2.length() < 1)continue;
				
				pt1 = pts1.first();//pt1.vis(p);
				pt2 = pts2.first();//pt2.vis(p);
				
				if (k==0)
				{ 
					ptsCen.append(ptCen);
					ptsX1.append(pt1);
					ptsX2.append(pt2);	
					bIsArcs.append(false);
					vecsN.append(vecN);
					plArcSegs.append(PLine (pts[p], ptCen, pts[b]));		
					
					//vecN.vis(ptCen,4);
				}
				else if (k==1)
				{ 
					ptsCen_C.append(ptCen);
					ptsX1_C.append(pt1);
					ptsX2_C.append(pt2);	
					bIsArcs_C.append(false);
					vecsN.append(vecN);
					plArcSegs_C.append(PLine (pts[p], ptCen, pts[b]));					
				}

			}// next p
		}//next r			 
	}//next k
	
	
//region Collect potential dimrequests
String kDimInfo = "Hsb_DimensionInfo", kPtX1 = "ptXLine1", kPtX2 = "ptXLine2", kPtCenter = "ptCenter", kRequests = "DimRequest[]", kAllowedView = "AllowedView";
{ 
	Entity entRequesters[0];
	for (int i=0;i<entities.length();i++) 
	{ 
		GenBeam gb = (GenBeam)entities[i];
		if (gb.bIsValid())
		{ 
			Entity tents[] = gb.eToolsConnected();
			for (int j=0;j<tents.length();j++) 
			{
				String s = tents[j].typeDxfName();
				String keys[] = tents[j].subMapXKeys();
				if (entRequesters.find(tents[j])<0 && tents[j].subMapXKeys().findNoCase(kDimInfo,-1)>-1)
					entRequesters.append(tents[j]); 				
			}
 
		}
		else
		{ 
			TslInst tents[] = entities[i].tslInstAttached();
			for (int j=0;j<tents.length();j++) 
				if (entRequesters.find(tents[j])<0 && tents[j].subMapXKeys().findNoCase(kDimInfo,-1)>-1)
					entRequesters.append(tents[j]); 
		}	  
	}//next i
	
	for (int i=0;i<entRequesters.length();i++) 
	{ 
		Entity e= entRequesters[i]; 
		Map mapRequests = e.subMapX(kDimInfo).getMap(kRequests);
		
		for (int j=0;j<mapRequests.length();j++) 
		{ 
			Map m= mapRequests.getMap(j);
			
			if (!m.hasPoint3d(kPtCenter)|| !m.hasPoint3d(kPtX1) || !m.hasPoint3d(kPtX2))
			{ 
				if (bDebug)reportNotice("\n" + j + " request not of type dimAngular");
				continue;
			}

			m.transformBy(ms2ps);
			Point3d ptCen = m.getPoint3d(kPtCenter);
			Vector3d vecAllowed = m.getVector3d(kAllowedView);		vecAllowed.vis(ptCen,150);	
			
			if (!vecAllowed.isParallelTo(vecZ))
			{ 
				continue;
			}
			Point3d pt1 = m.getPoint3d(kPtX1);				
			Point3d pt2 = m.getPoint3d(kPtX2);				

			PlaneProfile ppShape = m.getPlaneProfile("shape");
			ppShape.transformBy(ms2ps); // no clue why this needs to be transformed again

			PLine circle; circle.createCircle(ptCen, cs.vecZ(), radius);	circle.vis(1);
			
			Vector3d vecX1 = pt1 - ptCen; vecX1.normalize();	//vecX1.vis(pt1, 1);
			Vector3d vecY1 = vecX1.crossProduct(-vecZ);
			Point3d pts1[] = Line(ptCen, -vecX1).orderPoints(circle.intersectPoints(Plane(ptCen, vecY1)),dEps);
			
			Vector3d vecX2 = pt2 - ptCen; vecX2.normalize();	//vecX2.vis(pt2, 2);
			Vector3d vecY2 = vecX2.crossProduct(-vecZ);
			Point3d pts2[] = Line(ptCen, -vecX2).orderPoints(circle.intersectPoints(Plane(ptCen, vecY2)),dEps);
			
			Vector3d vecN = - vecX1 - vecX2; vecN.normalize();
			if (ppShape.pointInProfile(ptCen + vecN * dEps) == _kPointInProfile)vecN *= -1;

			if (bHasPage)
			{ 
				pt1.setZ(page.coordSys().ptOrg().Z());
				pt2.setZ(page.coordSys().ptOrg().Z());
				ptCen.setZ(page.coordSys().ptOrg().Z());
				
			}
			pt1.vis(1);pt2.vis(2);vecAllowed.vis(ptCen, 5);

			ptsX1.append(pt1);
			ptsX2.append(pt2);
			ptsCen.append(ptCen);

			bIsArcs.append(false);
			vecsN.append(vecN);
			plArcSegs.append(PLine (pt1, ptCen, pt2));

			if (!m.getVector3d(kAllowedView).isParallelTo(vecZ)){ continue;}
			
			// hsbDesign 26 or hiegher only
			//drawPlaneProfile(ppShape, 0, 3, 50);//#func
			 
		}//next j
		
		
		
		
		
	}//next i
	
}

		
//endregion 	
	
	
	mapArgs.setPoint3dArray("ptsX1", ptsX1);
	mapArgs.setPoint3dArray("ptsX2", ptsX2);
	mapArgs.setPoint3dArray("ptsCen", ptsCen);		

//endregion 

//region OnInsert #2
	if(_bOnInsert)
	{
	
	//region Jig the shape contour
		//if (!bIsRefMode)
		{ 
			PrPoint ssP(T("|Pick location or [All/SelectSide/Inner/Outer/SMallest/Largest]|")); // second argument will set _PtBase in map
			ssP.setSnapMode(TRUE, 0); // turn off all snaps
		    int nGoJig = -1;
		    while (nGoJig != _kNone && ptsCen.length()>0) // nGoJig != _kOk && 
		    {
		        nGoJig = ssP.goJig(kJigSelectAngle, mapArgs); 
	
		        if (nGoJig == _kOk)
		        {
		            Point3d ptPick = ssP.value(); //retrieve the selected point
		            Line(ptPick, vecZView).hasIntersection(Plane(cs.ptOrg(), vecZ), ptPick);
		            
				//find closest
					int n = -1;
					double dMin = U(10e7);
					for (int i=0;i<ptsCen.length();i++) 
					{ 
						double d = (ptPick-ptsCen[i]).length();
						if (d<dMin)
						{ 
							dMin = d;
							n=i;	
						}		 
					}//next i
					
				// create TSL
					TslInst tslNew;				Map mapTsl;
					int bForceModelSpace = true;	
					String sExecuteKey,sCatalogName = tLastInserted;
					String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
					GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {ptsCen[n],ptPick};
					
					if (bHasPage || bHasSection)
						entsTsl.append(entDefine);
					else
						entsTsl = entities;
					
					if (_Map.hasVector3d("ModelView"))
						mapTsl.setVector3d("ModelView", _Map.getVector3d("ModelView"));
						
					tslNew.dbCreate(scriptName() , _XU ,_YU,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 	
					
//					if (tslNew.bIsValid() && nColor>-1)
//						tslNew.setColor(nColor);
					
				// remove points
					ptsCen.removeAt(n);
					ptsX1.removeAt(n);
					ptsX2.removeAt(n);
	   
	   
				   	mapArgs.setPoint3dArray("ptsX1", ptsX1);
					mapArgs.setPoint3dArray("ptsX2", ptsX2);
					mapArgs.setPoint3dArray("ptsCen", ptsCen);
		        }
		        else if (nGoJig == _kKeyWord)
		        { 
		        	int n = ssP.keywordIndex();
		            if (n == 0) // insert all
		            { 
					// create TSL
						TslInst tslNew;				Map mapTsl;
						int bForceModelSpace = true;	
						String sExecuteKey,sCatalogName = tLastInserted;
						String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
						GenBeam gbsTsl[] = {};		Entity entsTsl[] = {entities[0]};			Point3d ptsTsl[1];
					
						for (int i=0;i<ptsCen.length();i++) 
						{ 
							ptsTsl[0] = ptsCen[i];
							tslNew.dbCreate(scriptName() , _XU ,_YU,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 
							
//							if (tslNew.bIsValid() && nColor>-1)
//								tslNew.setColor(nColor);
						}
	
			            eraseInstance(); // do not insert this instance
			            return; 
								            	
		            }
		            else if (n == 1)
		                sMode.set(tATSelectSide);	               
		            else if (n == 2)
		                sMode.set(tATInner);
		            else if (n == 3)
		                sMode.set(tATOuter);
		            else if (n == 4)
		                sMode.set(tATSmallest);
		            else if (n == 5)
		                sMode.set(tATLargest);
	  
		            if (n>=1 && n<=5)
		            { 
		            	mapArgs.setString("mode", sMode);
		            }
		        }
		        else if (nGoJig == _kCancel)
		        { 
		            eraseInstance(); // do not insert this instance
		            return; 
		        }
		    }			
				
		}
	//End Show Jig//endregion 

		eraseInstance();
		return;
	}	
//endregion 

//region General
//	sMode.setReadOnly(bDebug?0:_kHidden);
//	if (!bHasSDV)
//	{
//		sSuppress90.setReadOnly(bDebug?0:_kHidden);
//		if (sSuppress90==sNoYes.last())sSuppress90.set(sNoYes.first());
//	}
//	nColor.setReadOnly(bDebug?0:_kHidden);


	radius = .05 * textHeight;
	for (int i=0;i<_PtG.length();i++) 
		_PtG[i] += vecZ * vecZ.dotProduct(cs.ptOrg() - _PtG[i]); 
		
	double dArcRadius = _Map.getDouble("arcRadius");
	if (dArcRadius<=dEps)dArcRadius=3*textHeight;// default Radius
	double dTextOffset = dArcRadius + .5 * textHeight;	
	
	String lineType = sLineType;
	vecX.vis(_Pt0, 1);
	vecY.vis(_Pt0, 3);
	vecZ.vis(_Pt0, 150);
	
	// set drag color
	int bDrag = _bOnGripPointDrag && _kNameLastChangedProp.find("_Pt", 0, false) >- 1;
	if (bDrag)
	{
		//reportNotice("\ndrag keys "+_ThisInst.subMapXKeys() );
		
	// make the leader visible during drag	
		int n = sLineTypes.findNoCase("Continuous" ,- 1);
		if (n < 0 && sLineTypes.length() > 1)n = 1;
		if (n>-1)lineType = sLineTypes[n];
		
		dp.trueColor(lightblue, bIsDark?80:30);
		dp.draw(ppShape, _kDrawFilled);
		dp.trueColor(darkyellow);
	
	}
//	else
//		reportNotice("\nsubmapX keys "+_ThisInst.subMapXKeys() );
		
	_Pt0+= vecZ * vecZ.dotProduct(cs.ptOrg() - _Pt0); 
	
//endregion 

//region Blockspace Creation: clone this instance to detected locations
	if (_Entity.length()>0 && _Map.getInt(kBlockCreationMode)) 
	{
		
	// Get defining parameters from map
		Vector3d vecN = _Map.getVector3d("vecN");
		Vector3d vecXA = vecN.crossProduct(vecZ);
		double r = _Map.getDouble("ArcRadius");
		Vector3d vecArcOut = _Map.getVector3d("vecArcOut");
		Vector3d vecArc = _Map.getVector3d("vecArc");
		Vector3d vecBaseOffset = _Map.getVector3d(kBaseOffset);
		Vector3d vecTextLocation = _Map.getVector3d("vecTextLocation");
		
		vecXA.vis(_Pt0, 51);
		vecN.vis(_Pt0, 51);
		vecArc.vis(_Pt0, 40);
		
		//bDebug = true;
	// loop target locations
		if (!vecN.bIsZeroLength() && bHasPage)
		for (int i=0;i<ptsCen.length();i++) 
		{ 
			Point3d pt = ptsCen[i]; 
			
			Vector3d vecNB = vecsN[i];
			Vector3d vecXB = vecNB.crossProduct(vecZ);
			Vector3d vecArcB = vecArc;
			
			CoordSys cs2B; cs2B.setToAlignCoordSys(pt, vecXA, vecN, vecZ, pt, vecXB, vecNB, vecZ);
			vecArcB.transformBy(cs2B);
			vecBaseOffset.transformBy(cs2B);
			vecTextLocation.transformBy(cs2B);
				
			pt += vecBaseOffset;
			Point3d ptG0 = pt + vecArcB * r+vecBaseOffset;
			Point3d ptG1 = pt + vecArcB * r+vecTextLocation;
			
			
			if (bDebug)
			{ 
				pt.vis(1);	//vecsN[i].vis(pt, 161);
				vecArcB.vis(ptG0, i);
				vecXB.vis(ptG1, 40);
				vecsN[i].vis(ptG1, 160);
			}
			
			else
			{ 
			// create TSL
				TslInst tslNew;
				GenBeam gbsTsl[] = {};		Entity entsTsl[] = {page};			Point3d ptsTsl[] = {pt, ptG0};
				int nProps[]={nColor};			
				double dProps[]={dTextHeight,dGlobalScale};				
				String sProps[]={sMode,sPainter,sAngleMode,sSuppress90,sFormat,sDimStyle,sLineType};
				Map mapTsl;	
				
				if (!vecTextLocation.bIsZeroLength())
				{
					ptsTsl.append(ptG1);
					mapTsl.setInt(kAddTextLocation, true);
				}
				mapTsl.setVector3d("vecOrg",  pt - _PtW); // relocate to multipage
				
				{ 
					String k;
					k = "arcRadius"; 	if (_Map.hasDouble(k)) mapTsl.setDouble(k, _Map.getDouble(k));

					k = "ModelView"; 	if (_Map.hasVector3d(k)) mapTsl.setVector3d(k, _Map.getVector3d(k));
				}

				tslNew.dbCreate(scriptName() , vecX ,vecY,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	
				
				if (tslNew.bIsValid() && _ThisInst.color()>-1 && nColor==-1)
					tslNew.setColor(_ThisInst.color());
				
			}
			 
		}//next i
		
		
		if (bDebug)
			dp.draw(kBlockCreationMode + "\nR="+r, _Pt0, vecX, vecY, 1, 0);
		else
		{ 
			//_Map.removeAt(kBlockCreationMode, true);
			eraseInstance();
		}
		return;
	}
	
	
	
	
//endregion 

//region Identify if center is on vertex or on shape segment

// POI
	Point3d pt1, pt2, ptX1, ptX2, ptCen = _Pt0;	
	
// Get closest position on shape
	double dMin = U(10e6);
	Point3d ptClosest = _Pt0;
	PLine plThis;
	for (int r=0;r<rings.length();r++) 
	{ 
		Point3d pt = rings[r].closestPointTo(_Pt0);
		double d = (pt - _Pt0).length();
		if (d<dMin)
		{ 
			dMin = d;
			if (sMode==tSMSegment)
				ptClosest = pt; // assuming not to be in vertex mode
			plThis = rings[r];
		}
	}//next r
	if (plThis.length()<dEps)
	{ 
		reportNotice("\n"+ T("|Unexpected error|"));
		eraseInstance();
		return;
	}

	int nVertex=-1;

	if (sMode==tSMVertex)
	{ 
		double dMin = U(10e6);
		int n = -1;
		for (int i=0;i<ptsCen.length();i++) 
		{ 
			double d = (ptsCen[i] - _Pt0).length();
			if (d<dMin)
			{
				dMin = d;
				n = i;
			}	 
		}//next i
		if (n>-1)
		{
			ptClosest = _Pt0;
			nVertex = n;
		}
	}
	else
	{ 
		for (int i=0;i<ptsCen.length();i++) 
		{ 
			double d = (ptsCen[i] - ptClosest).length();
			if (d<dEps)
			{
				nVertex = i;
				ptClosest = ptsCen[i];
				break;; 
			}	 
		}//next i		
	}

	_Pt0.vis(nVertex);
	Vector3d vecLoc = _Pt0 - ptClosest;
//endregion 

//region Get vectors
	Vector3d vecX1=_XU, vecX2=_YU, vecTan, vecN;
	double dAngle;
	int bIsArc;
	PLine plDefine(vecZ);
	
// Vertex Dimension	
	if (nVertex>-1)
	{ 
		ptCen = ptsCen[nVertex];
		pt1 = ptsX1[nVertex];
		pt2 = ptsX2[nVertex];	
		bIsArc = bIsArcs[nVertex];

		vecX1 = pt1 - ptCen; vecX1.normalize();
		vecX2 = pt2 - ptCen; vecX2.normalize();
		
		vecN = vecsN[nVertex];
		vecTan = vecX1 - vecX2; vecTan.normalize();

		plDefine = PLine(pt1, ptCen, pt2);
	
	}
// Segment Dimension	
	else
	{ 
		ptCen = ptClosest;  // default = closest to shape
		Vector3d vecXT = vecX;
		Vector3d vecYT = vecY;
		if (elParent.bIsValid())
		{ 
			vecXT = elParent.vecX();
			vecYT = elParent.vecY();
			
			vecXT.transformBy(ms2ps); vecXT.normalize();
			vecYT.transformBy(ms2ps); vecYT.normalize();
			
			//vecXT.vis(_Pt0, 40);
		}
		
		
	// Get first vector of dim on shape
		double d0 = plThis.getDistAtPoint(ptCen);
		Point3d ptNext = plThis.getPointAtDist(d0 <= dEps ? plThis.length() - dEps : d0 - dEps);
		//vecX1 = ptNext - ptCen; vecX1.normalize();	
		
	//region Check if segment is an arc
		Point3d ptm = (ptNext + ptCen) * .5;
		if (plThis.isOn(ptm)) // find start and end vertex of this segment or get the corresponding arc
		{ 
			for (int i=0;i<plArcSegs.length();i++) 
			{ 
				PLine arc = plArcSegs[i];
				if (bIsArcs[i] && arc.isOn(ptCen))
				{ 
					//arc.transformBy(vecZ * U(100));
					arc.vis(2);
					ptCen = ptsCen[i];
					pt1 = arc.ptStart();//ptsX1[n];	
					pt2 = arc.ptEnd();//ptsX2[n];
					pt1.vis(211); pt2.vis(211);ptCen.vis(6);
					bIsArc = true;
					
					vecX1 = pt1 - ptCen; vecX1.normalize();
					vecX2 = pt2 - ptCen; vecX2.normalize();
		
					ptX1 = pt1 + vecX1 * dEps;
					ptX2 = pt2 + vecX2 * dEps;
		
					vecTan = vecX1 - vecX2; vecTan.normalize();	
					
					plDefine = arc;
					_Pt0 = ptClosest; // do not allow offset dragging of _Pt0
					break;
				}
			}//next i	
		}	
		
		if (vecTan.bIsZeroLength())
			vecTan = plThis.getTangentAtPoint(ptCen);
		vecN = vecTan.crossProduct(-vecZ);
		if (PlaneProfile(plThis).pointInProfile(ptCen+vecN*dEps)==_kPointInProfile)
			vecN *= -1;
	//endregion 

	//region Not an arc
		if (!bIsArc)
		{ 
		// Get vectors
			vecX1 = plThis.getTangentAtPoint(ptClosest);
			vecX2 = vecXT;
			if (vecX1.isParallelTo(vecX2))vecX2 = vecYT;
			
		// make sure vecX2 points towards outside shape as default
			if (ppShape.pointInProfile(ptCen+vecX2*dEps)==_kPointInProfile)
			{
				vecX2 *= -1;		
			}
			plDefine = PLine(ptCen + vecX1 * textHeight, ptCen, ptCen + vecX2 * textHeight);
			//plDefine.vis(6);
		}
			
	//endregion 	

		
	}


// Location of angular dimension is based on _Pt0 (can be offseted to shape)	
	if (!bIsArc)
	{ 
		ptX1 = _Pt0 + vecX1 * dEps;		vecX1.vis(ptX1, 70);
		ptX2 = _Pt0 + vecX2 * dEps;		vecX2.vis(ptX2, 70);		
	}
	
	vecTan.vis(ptCen,40);

// Default Vector to a point on the dimension arc
	Vector3d vecArc = vecTan.crossProduct(vecZ);
	if (ppShape.pointInProfile(ptClosest+vecArc*dEps)==_kPointInProfile)
		vecArc *= -1;
	
	Point3d ptCenter = bIsArc ? ptCen : _Pt0;
	Point3d ptArc = ptCenter + vecArc * dArcRadius;			//ptArc.vis(2);




// Arc: adjust radius and vector based on existing grip
	if (_PtG.length()<1)
		_PtG.append(ptArc);
	else
	{
		Vector3d vec = _PtG[0] - ptCenter;
		if (vec.bIsZeroLength()) // make sure grip is never on center
			_PtG[0].transformBy(vecArc *3* textHeight);

		ptArc = _PtG[0];
		vecArc = _PtG[0] - ptCenter;
		vecArc.normalize();
		dArcRadius = (ptArc - ptCenter).length();
		dArcRadius = dArcRadius < dEps ?3 * textHeight:dArcRadius;
	}
	if (vecArc.dotProduct(ptArc - ptCenter) < 0)vecArc *= -1;	
	vecArc.vis(ptArc,2);
	
	//PLine plCirc; plCirc.createCircle(ptCenter, vecZ, dArcRadius); 	plCirc.vis(6); //debug control circle
//endregion 

//region Collect potential variations of opposite or adjacent angles
	Vector3d vecArcOut = vecX1+vecX2; vecArcOut.normalize();
	if (ppShape.pointInProfile(ptClosest + vecArcOut * dEps) == _kPointInProfile)
		vecArcOut *= -1;

	int bOuterIsMin = vecArcOut.dotProduct(vecX1 + vecX2) > 0;

	Point3d ptsA[0], ptsB[0], ptsC[0];
	if (bIsArc)
	{ 
		vecArcOut = vecN;
		vecX1.vis(pt1, 3);
		vecX2.vis(pt2, 3);
		
		ptX1 = pt1;
		ptX2 = pt2;

		ptsA.append(ptCen + vecX1 * dArcRadius);
		ptsB.append(ptCen + vecX2 * dArcRadius);
		ptsC.append(ptArc);//- vecArcOut * dArcRadius);		

	}
	else
	{ 
	// append outer
		if (bOuterIsMin)
		{ 
			// small arc
			ptsA.append(_Pt0+vecX1*dArcRadius);
			ptsB.append(_Pt0+vecX2*dArcRadius);
			ptsC.append(_Pt0+vecArcOut*dArcRadius);	
	
			// opposite small or big
			ptsA.append(_Pt0-(bFullAngle?-1:1)*vecX1*dArcRadius);
			ptsB.append(_Pt0-(bFullAngle?-1:1)*vecX2*dArcRadius);
			ptsC.append(_Pt0-vecArcOut*dArcRadius);
		}
	
	// append opposite
		else if (!bOuterIsMin)
		{
			ptsA.append(_Pt0 + vecX1 * dArcRadius);
			ptsB.append(_Pt0 + vecX2 * dArcRadius);
			ptsC.append(_Pt0 - vecArcOut * dArcRadius);
			
		// append inner
			ptsA.append(_Pt0-(bFullAngle?-1:1)*vecX1*dArcRadius);
			ptsB.append(_Pt0-(bFullAngle?-1:1)*vecX2*dArcRadius);
			ptsC.append(_Pt0+vecArcOut*dArcRadius);		
		}
	
	// append neighbours
		if(!bFullAngle)
		{ 
			Vector3d vec;
	
			if (vecX1.isParallelTo(vecX))
			{ 
				if (vecY.dotProduct(vecX2)>0)
				{ 
					vec = vecX2 + vecY; vec.normalize();
					ptsA.append(_Pt0+vecX2*dArcRadius);
					ptsB.append(_Pt0+vecY*dArcRadius);	
					ptsC.append(_Pt0+vec*dArcRadius);
					
					vec = vecX2 + vecY; vec.normalize();
					ptsA.append(_Pt0-vecX2*dArcRadius);
					ptsB.append(_Pt0-vecY*dArcRadius);	
					ptsC.append(_Pt0-vec*dArcRadius);					
				}
				else if (vecX1.dotProduct(vecX2)<0)
				{ 
					vec = vecX2 -vecY; vec.normalize();
					ptsA.append(_Pt0+vecX2*dArcRadius);
					ptsB.append(_Pt0-vecY*dArcRadius);	
					ptsC.append(_Pt0+vec*dArcRadius);

					ptsA.append(_Pt0-vecX2*dArcRadius);
					ptsB.append(_Pt0+vecY*dArcRadius);	
					ptsC.append(_Pt0-vec*dArcRadius);					
				}
			}
			else if (vecX2.isParallelTo(vecX))
			{ 
				if (vecY.dotProduct(vecX1)>0)
				{ 
					vec = vecX1 + vecY; vec.normalize();
					ptsA.append(_Pt0+vecX1*dArcRadius);
					ptsB.append(_Pt0+vecY*dArcRadius);	
					ptsC.append(_Pt0+vec*dArcRadius);
					
					ptsA.append(_Pt0-vecX1*dArcRadius);
					ptsB.append(_Pt0-vecY*dArcRadius);	
					ptsC.append(_Pt0-vec*dArcRadius);					
				}
				else if (vecX1.dotProduct(vecX2)<0)
				{ 
					vec = vecX1 -vecY; vec.normalize();
					ptsA.append(_Pt0+vecX1*dArcRadius);
					ptsB.append(_Pt0-vecY*dArcRadius);	//HSB-16291 bugfix adjacent angle collection
					ptsC.append(_Pt0+vec*dArcRadius);
					
					ptsA.append(_Pt0-vecX1*dArcRadius);
					ptsB.append(_Pt0+vecY*dArcRadius);	//HSB-16291 bugfix adjacent angle collection
					ptsC.append(_Pt0-vec*dArcRadius);					
				}
				else if (vecY.dotProduct(vecX1)<0)
				{ 
					vec = -vecX1 +vecY; vec.normalize();
					ptsA.append(_Pt0-vecX1*dArcRadius);
					ptsB.append(_Pt0+vecY*dArcRadius);	//HSB-16291 bugfix adjacent angle collection
					ptsC.append(_Pt0+vec*dArcRadius);					
				}

			}
			vec = vecX1 - vecX2; vec.normalize();
			ptsA.append(_Pt0+vecX1*dArcRadius);
			ptsB.append(_Pt0-vecX2*dArcRadius);		
			ptsC.append(_Pt0+vec*dArcRadius);
			
			ptsA.append(_Pt0-vecX1*dArcRadius);
			ptsB.append(_Pt0+vecX2*dArcRadius);		
			ptsC.append(_Pt0-vec*dArcRadius);
		}
		
	}
	vecArcOut.vis(ptArc, 1);


// collect all possible arcs
	PLine plSnapArcs[0];
	for (int i = 0; i < ptsA.length(); i++)
	{
		PLine pl(vecZ);
		pl.addVertex(ptsA[i]);
		pl.addVertex(ptsB[i], ptsC[i]);
		plSnapArcs.append(pl);
	}
	
// order by arc length: the arc to be used is detected sequentially by closest point to the arc, as such the shortest one should be first
	for (int i=0;i<plSnapArcs.length();i++) 
		for (int j=0;j<plSnapArcs.length()-1;j++) 
			if (plSnapArcs[j].length()>plSnapArcs[j+1].length())
			{
				plSnapArcs.swap(j, j + 1);
				ptsA.swap(j, j + 1);
				ptsB.swap(j, j + 1);
				ptsC.swap(j, j + 1);
			}			
	if (bDebug)
	{ 
		for (int i=0;i<plSnapArcs.length();i++) 
		{ 
			PLine pl = plSnapArcs[i];
			Vector3d vec = ptsC[i] - _Pt0;; vec.normalize();
			pl.offset(U(3) * i, true);
			pl.vis(i+1); 
		}					
	}			
			
			

// Get arc to be used
	PLine plDimArc;
	for (int i=0;i<ptsA.length();i++) 
	{ 
		PLine pl = plSnapArcs[i];
		double d = (pl.closestPointTo(ptArc) - ptArc).length();
		if (d<dEps)//pl.isOn(ptArc))
		{ 
			plDimArc = pl;
			break;
		}
	}//next i
	//plDimArc.vis(41);
	
// Build a profile to reset the potential text location if grip is within this range	
	PlaneProfile ppArcRing(cs);
	if (plDimArc.length()>dEps)
	{ 
		double dimOffset = dArcRadius > .5 * textHeight ? .5 * textHeight : .5 * dArcRadius;
		if (!bIsArc)
		{ 	
			vecX1 = plDimArc.ptStart()-_Pt0; vecX1.normalize();
			ptX1 = _Pt0 + vecX1 * dimOffset;
			
			vecX2 = plDimArc.ptEnd()-_Pt0; vecX2.normalize();
			ptX2 = _Pt0 + vecX2 * dimOffset;			
		}

		
		PLine pl1 = plDimArc;
		pl1.offset(dimOffset);
		PLine pl2 = plDimArc;
		pl2.offset(-dimOffset);
		pl2.reverse();
		pl1.append(pl2);
		pl1.close();
		ppArcRing.joinRing(pl1, _kAdd);		
		//ppArcRing.vis(6);
	}

//endregion 

//region Dimension
	dAngle = vecX1.angleTo(vecX2);


	// additional formatting values	
	Map mapAdd;
	mapAdd.appendDouble("Angle Dim", dAngle);
	if (bIsArc)
		mapAdd.appendDouble("Arc Length", plDefine.length());


// Text
	String text = entDefine.formatObject(sFormat, mapAdd);	
	text = text.trimLeft().trimRight();
	sFormat.setDefinesFormatting(entDefine, mapAdd);

// Dimension		
	DimAngular dimAng(ptCenter, ptX1, ptX2, ptArc);
	dimAng.setUseDisplayTextHeight(bUseTextHeight);	
	dimAng.setDimensionPlane(ptCen, vecX, vecZ);
	dimAng.setDimScale(dDimScale);
	if (text.length()>0)
		dimAng.setText(text);


//region Text Location
// Trigger SwapText
	int bAddTextLocation = _Map.getInt(kAddTextLocation);
	String sTriggerSetTextLocation =bAddTextLocation?T("|Text Location byDimstyle|"):T("|Set Text Location|");
	addRecalcTrigger(_kContextRoot, sTriggerSetTextLocation);
	if (_bOnRecalc && _kExecuteKey==sTriggerSetTextLocation)
	{
		bAddTextLocation = !bAddTextLocation;
		_Map.setInt(kAddTextLocation, bAddTextLocation);	

	//region Get text location
		if (bAddTextLocation)
		{ 
			PrPoint ssP(TN("|Pick point|"));
		    Map mapArgs;
		    mapArgs.setPoint3d("ptCenter", ptCenter);
		    mapArgs.setPoint3d("ptX1", ptX1);
		    mapArgs.setPoint3d("ptX2", ptX2);
		    mapArgs.setPoint3d("ptArc", ptArc);
		    mapArgs.setDouble("dimScale", dDimScale);
		    mapArgs.setString(kDimDimstyle, sDimStyle);
		    mapArgs.setDouble(kTextHeight, textHeight);

		    mapArgs.setString("text", text);
		    mapArgs.setVector3d("vecX", vecX);
		    mapArgs.setVector3d("vecY", vecY);

		    
		    int nGoJig = -1;
		    while (nGoJig != _kOk && nGoJig != _kNone)
		    {
		        nGoJig = ssP.goJig(kJigTextLocation, mapArgs); 
		        if (nGoJig == _kOk)
		            _PtG.append(ssP.value());
		        else if (nGoJig == _kCancel)
		            break; 
		    }			
		}			
	//endregion 

		setExecutionLoops(2);
		return;
	}
	
	if (bAddTextLocation)
	{ 

	// Text Location: get text areas
		PlaneProfile ppText(cs);
		{ 
			PLine plines[] = dimAng.getTextAreas(dp);
			for (int i=0;i<plines.length();i++) 
				ppText.joinRing(plines[i], _kAdd);
			ppText.vis(2);	
		}
		if (_PtG.length()<2)
			_PtG.append(_PtG[0] + vecArc * U(30)*dScale);
		
		int bHasCustomLocation = _Map.hasVector3d("vecGrip1");
		double dPreviousArcRadius = _Map.getDouble("arcRadius");
		if (_PtG.length()>1)
		{
			Point3d& pt = _PtG[1];
			pt += vecZ * vecZ.dotProduct(_Pt0 - pt);
	
			int bReset = ppText.pointInProfile(pt) != _kPointOutsideProfile;	
			if  (dPreviousArcRadius>0 && dPreviousArcRadius<dArcRadius && _kNameLastChangedProp=="_PtG0")
				bReset = true;
	
		// snap grip to arc ring segment to avoid grips 0 and 1 to be near to each other
			if (ppArcRing.pointInProfile(pt)==_kPointInProfile)
			{
				pt = ppArcRing.closestPointTo(pt);
				if (!bDrag)_Map.removeAt("vecGrip1", true);
			}
		//reset to default location: grip is not outside textArea or radius has been increased	
			else if (bReset)
			{
				PlaneProfile ppInt = ppText;
				ppInt.intersectWith(ppArcRing);
				
				if (ppInt.area()>pow(dEps,2))
					pt = ppArcRing.closestPointTo(pt);//
				else
					pt = ppText.extentInDir(vecX).ptMid();
					
				if (bHasCustomLocation && !bDrag)
					_Map.removeAt("vecGrip1", true);
			}
		// custom text location			
			else
			{
				dimAng.setTextLocation(pt);
				if (!bDrag)_Map.setVector3d("vecGrip1", pt - _PtW);
			}
		}



	}
	else if (_PtG.length()>1)
	{ 
		_PtG.setLength(1);
	}
	
	
	
//endregion 

	_Map.setDouble("arcRadius", dArcRadius);
	if (bInBlockSpace)
	{ 	
		_Map.setVector3d("vecArc", vecArc);
		//_Map.setVector3d("vecArcOut", vecArcOut);
		_Map.setVector3d("vecN",vecArcOut);// TODO the aligning of the coordSys fails when offseted : vecN
		_Map.setVector3d(kBaseOffset, _Pt0-ptCen);
		if (bAddTextLocation)
			_Map.setVector3d("vecTextLocation", _PtG[1]-ptArc);		
	}

	dp.draw(dimAng);	
//endregion 

//region Leader
	PLine plRange = plDimArc;
	plRange.addVertex(_Pt0);
	plRange.close();
	PlaneProfile ppRange(plRange);
	ppRange.shrink(-.6 * textHeight);
	//ppRange.vis(5);


	Vector3d vecLeader = _Pt0 - ptCen;
	Point3d ptRange = ppRange.closestPointTo(ptCen);		//ptRange.vis(6);
	double dLeader = abs(vecLeader.dotProduct(ptRange - ptCen));
	vecLeader.normalize();

	if (!bIsArc && dLeader>textHeight && lineType != tDisabled)
	{
		double r = .1 * textHeight;
		if (bDrag && nVertex>-1)
		{
			r = dViewHeight / 60;
			dp.trueColor(darkyellow);
			dp.transparency(0);	
		}
		
		PLine circle;
		circle.createCircle(ptCen, vecZ, r);
		circle.convertToLineApprox(dEps);	

		dp.draw(PlaneProfile(circle), _kDrawFilled, 80);
		dp.draw(circle);			
		dp.lineType(lineType, U(1));

		if (ppRange.pointInProfile(ptCen)==_kPointOutsideProfile)	
			dp.draw(PLine(ptCen, ptRange));
	}		
//endregion 

//region Viewport
if (bIsViewportSetup)
{
	
	PlaneProfile shape = ppCreationShape;
	if (nVertex >- 1)
	{
		dp.trueColor(red);
		dp.draw(T("|Vertex mode not supported|") + TN("|Please adjust base point|"), ppShape.ptMid(), _XW - _YW, _XW + _YW, 0, 0);
	}
	
	//shape.vis(1);
	
	// get normal on reference
	Vector3d vecNormal = vecTan.crossProduct(vecZ);
	if (ppShape.pointInProfile(ptCen + vecNormal * dEps) == _kPointInProfile)
		vecNormal *= -1;
	//vecNormal.vis(ptCen, 3);
//	
//// get mid of segment
//	Point3d ptm = ptCen;
//	double dc = plThis.getDistAtPoint(ptCen);
//	LineSeg seg;
//	{ 
//		Point3d pts[] = plThis.vertexPoints(false);
//		for (int i=0;i<pts.length()-1;i++) 
//		{ 
//			pts[i].vis(7);
//			double d0 = plThis.getDistAtPoint(pts[i]);
//			double d1 = i == pts.length()-2?plThis.length():plThis.getDistAtPoint(pts[i+1]);
//			
//			if (d0<dc && d1>dc)
//			{
//				seg = LineSeg(pts[i] , pts[i + 1]);
//				ptm = plThis.closestPointTo((pts[i] +pts[i + 1]) * .5);
//				break;
//			} 
//		}//next i
//		
//	}
//	
//	ptm.vis(6);
	
	
	
	// dim location offset grip
		Vector3d vecDimOffset = _Pt0 - ptCen;		{Vector3d vec = vecDimOffset; vec.normalize(); vec.vis(ptCen, 211);}

	// text location grip
		Vector3d vecRefText;
		if (_PtG.length()>1)
		{ 
			vecRefText = _PtG[1] - _PtG[0];
		}
		
		
	// flag the orientation of the reference dim, positive x and y orientation	
		int bIsXP = vecNormal.dotProduct(vecX)>0;
		int bIsYP = vecNormal.dotProduct(vecY)>0;
		
		int bIsCenXP = vecX.dotProduct(ptCen - ppShape.ptMid()) > 0;
		int bIsCenYP = vecY.dotProduct(ptCen - ppShape.ptMid()) > 0;
		
	//region Segment Mode
		if (nVertex < 0)
		{ 
		//region find segment on ref and calculate percentage of mid offset
			double dMidOffset;
			{ 
				ptCen.vis(4);
				LineSeg seg;
				PLine rings[] = ppShape.allRings();	
				for (int i = 0; i < rings.length(); i++)
				{
					PLine& pl = rings[i];
					double h = Vector3d(pl.closestPointTo(ptCen) - ptCen).length();
					if (h > dEps)continue; // not on this ring
					
					Point3d pts[] = pl.vertexPoints(true);
					double d0 = pl.getDistAtPoint(ptCen);
					// loop vertices
					for (int p = 0; p < pts.length(); p++)
					{
						Point3d pt1 = pts[p];
						Point3d pt2 = pts[p<pts.length()-1?p+1:0];
						
						double d1 = pl.getDistAtPoint(pt1);
						double d2 = pl.getDistAtPoint(pt2);
						if (d2 <= dEps)d2 = pl.length();
						
						if (d0 > d1 && d0<d2)
						{ 
							seg = LineSeg(pt1, pt2);
							break;
						}	
					}
				}
				seg.vis(6);		seg.ptMid().vis(20);	
				if (seg.length()>0)
				{ 
					Vector3d vec = seg.ptEnd() - seg.ptStart(); vec.normalize();
					
					if (!vec.crossProduct(vecNormal).isCodirectionalTo(vecZ))
						vec *= -1;
					
					vec.vis(seg.ptMid(), 1);
					double d = vec.dotProduct(seg.ptMid() - ptCen);
					if (abs(d)>dEps)
					{ 
						dMidOffset = d/(.5*seg.length());	
					}

				}

				
			}
		//endregion 
	
	
		//region Loop all rings of creation shape
			PLine rings[] = ppCreationShape.allRings(true,false);
			for (int i=0;i<rings.length();i++) 
			{ 
				PLine& pl = rings[i]; 
					
				Point3d pts[] = pl.vertexPoints(true);
			
			// loop vertices and find coaligned segments
				for (int p = 0; p < pts.length(); p++)
				{
					Point3d pt1 = pts[p];
					Point3d pt2 = pts[p<pts.length()-1?p+1:0];
					Point3d ptm = (pt1 + pt2) * .5;
					double h = Vector3d(pl.closestPointTo(ptm) - ptm).length();
					int bIsArc = h > dEps;
					if (bIsArc){continue;}
					
					Vector3d vecXS = pt2 - pt1; vecXS.normalize();
					Vector3d vecYS = vecXS.crossProduct(vecZ);
					if (shape.pointInProfile(ptm+vecYS*dEps)==_kPointInProfile)
						vecYS *= -1;
					if (!vecXS.crossProduct(vecYS).isCodirectionalTo(vecZ))
						vecXS *= -1;
						
vecXS.vis(ptm, 1);
vecYS.vis(ptm, 3);
					double dDotX = abs(vecXS.dotProduct(vecX));
					double dDotY = abs(vecXS.dotProduct(vecY));					
					LineSeg seg(pt1, pt2);
					if (dDotX <0.01 || dDotY<0.01)
					{ 
						//seg.vis(1);
						continue;
					}
					
				// accept only segments with same main Y-Direction	
					int bIsXPC = vecYS.dotProduct(vecX)>0;
					int bIsYPC = vecYS.dotProduct(vecY)>0;
					
					if (bIsYP!=bIsYPC)
					{ 
						//seg.vis(1);
						continue;
					}
					//seg.vis(3);
					
				// mirror if on opposite side
					Vector3d vecArc_C = vecArc;
					Vector3d vecX1_C = vecX1;
		
vecX1_C	.vis(ptm, 5);	
					Vector3d vecX2_C = vecX2;
					Vector3d vecDimOffset_C = vecDimOffset;
					Vector3d vecRefText_C = vecRefText;
					CoordSys cs2_C; // transformation from ref to this dim
					if (bIsXP!=bIsXPC)
					{ 
						CoordSys csMirr;
						csMirr.setToMirroring(Plane(ptCen, vecX));	
						cs2_C = csMirr;
					}
					if (bIsYP!=bIsYPC)
					{ 
						CoordSys csMirr;
						csMirr.setToMirroring(Plane(ptCen, vecY));	
						cs2_C.transformBy(csMirr);
					}	
					if (bIsXP!=bIsXPC ||bIsYP!=bIsYPC)
					{ 
						vecArc_C.transformBy(cs2_C);
						vecX1_C.transformBy(cs2_C);
						vecX2_C.transformBy(cs2_C);	
						vecDimOffset_C.transformBy(cs2_C);
						vecRefText_C.transformBy(cs2_C);	
					}
					vecArc_C.vis(ptm,3);
					//vecRefText_C.vis(ptm,6);
					if (vecXS.dotProduct(vecX1_C)<0)
						vecXS *= -1;
					
					{ 
						Vector3d vec = vecDimOffset_C;
						vec.normalize();
						vec.vis(ptm, 40);
					}
					
					
					
				// the location is offseted by the same ratio as on the reference	
					Point3d ptDim = ptm - vecXS*dMidOffset*.5*seg.length()+vecDimOffset_C;
					Point3d ptArc_C = ptDim + vecArc_C*dArcRadius;
					ptArc_C.vis(6);					
					
					Point3d ptX1_C = ptDim + vecXS * .5 * textHeight;		//ptX1_C.vis(5);
					Point3d ptX2_C = ptDim + vecX2_C * .5 * textHeight;	//ptX2_C.vis(5);
				
				// Leader
					int bHasOffset_C = vecDimOffset_C.length() > textHeight;
					if (bHasOffset_C && lineType!=tDisabled)
					{ 
						dp.draw(PLine(ptm - vecXS*dMidOffset*.5*seg.length(), ptDim));
					}
				
				// Text
					String text_C = entDefine.formatObject(sFormat, mapAdd);	
					text_C = text_C.trimLeft().trimRight();
			
				// Dimension				
					DimAngular dimAng_C(ptDim, ptX1_C, ptX2_C, ptArc_C);
					dimAng_C.setUseDisplayTextHeight(bUseTextHeight);	
					dimAng_C.setDimensionPlane(ptDim, vecX, vecZ);
					dimAng_C.setDimScale(dDimScale);
					if (vecRefText_C.length()>textHeight)
						dimAng_C.setTextLocation(ptArc_C+vecRefText_C);					
					if (text.length()>0)
						dimAng_C.setText(text);	
					
					
					dp.draw(dimAng_C);
				}
				 
			}//next i				
		//endregion 

		}
	//endregion 	
		
	//region Vertex Mode // TODO not supported yet
		else if (0)
		{ 
			shape.ptMid().vis(6);
			ppShape.ptMid().vis(6);
			for (int i=0;i<ptsCen_C.length();i++) 
			{ 
				Point3d ptCen_C = ptsCen_C[i]; 

				int bIsCenXP_C = vecX.dotProduct(vecNormal)>0;//ptCen_C - shape.ptMid()) > 0;
				int bIsCenYP_C = vecY.dotProduct(vecNormal)>0;//ptCen_C - shape.ptMid()) > 0;
				
				if (bIsCenYP_C != bIsCenYP)continue;
				
				
				Point3d ptX1_C = ptsX1_C[i];		//ptX1_C.vis(5);
				Point3d ptX2_C = ptsX2_C[i];	//ptX2_C.vis(5);
				
				Vector3d vecX1_C = ptCen_C - ptX1_C; vecX1_C.normalize();	
				Vector3d vecX2_C = ptCen_C - ptX2_C; vecX2_C.normalize();	
				
			// ignore nearly 0 or 180°	
				if (1-abs(vecX1_C.dotProduct(vecX2_C)) < 0.1)continue;
				
				dp.draw(abs(vecX1_C.dotProduct(vecX2_C)), ptCen_C, _XW, _YW, 1, 0);
				
				Vector3d vecArc_C = (vecX1_C + vecX2_C) * .5; vecArc_C.normalize();
				

				CoordSys cs2_C; // transformation from ref to this dim
				if (bIsCenYP!=bIsCenYP_C)
				{ 
					CoordSys csMirr;
					csMirr.setToMirroring(Plane(ptCen, vecX));	
					cs2_C = csMirr;
				}
				if (bIsCenXP!=bIsCenXP_C)
				{ 
					CoordSys csMirr;
					csMirr.setToMirroring(Plane(ptCen, vecY));	
					cs2_C.transformBy(csMirr);
				}
				
				
				
				Vector3d vecArcRef = vecArc;

				if (bIsCenYP!=bIsCenYP_C || bIsCenXP!=bIsCenXP_C)
				{ 
					vecArcRef.transformBy(cs2_C);
				}
				
				
				
				//if (vecArcRef.dotProduct(vecArc_C) < 0)continue;
				
				
				vecArcRef.vis(ptCen_C, 4);
				vecX1_C.vis(ptCen_C, 1);
				vecX2_C.vis(ptCen_C, 3);
				ptCen_C.vis(6);
				PLine pl = plArcSegs_C[i];
				//pl.vis(i);
				
				Point3d ptDim = ptCen_C;
				Point3d ptArc_C = ptDim + vecArcRef*dArcRadius;
				ptX1_C = ptDim + vecX1_C * .1 * textHeight;
				ptX2_C = ptDim + vecX2_C * .1 * textHeight;
				
				
				
			// Text
				String text_C = entDefine.formatObject(sFormat, mapAdd);	
				text_C = text_C.trimLeft().trimRight();
			
			// Dimension				
				DimAngular dimAng_C(ptDim, ptX1_C, ptX2_C, ptArc_C);
				dimAng_C.setUseDisplayTextHeight(bUseTextHeight);	
				dimAng_C.setDimensionPlane(ptDim, vecX, vecZ);
				dimAng_C.setDimScale(dDimScale);
//				if (bHasOffset_C)
//					dimAng_C.setTextLocation(ptArc_C+vecRefText_C);					
				if (text.length()>0)
					dimAng_C.setText(text);	
				
				
				dp.draw(dimAng_C);
				
				
				
				
			}//next i

			
		}			
	//endregion 	
	
		
	}
//endregion 

//region Trigger
// Trigger FullAngle
	String sTriggerFullAngle =bFullAngle?T("|Adjacent Angles|"):T("|Full Complementary Angle|");
	addRecalcTrigger(_kContextRoot, sTriggerFullAngle);
	if (_bOnRecalc && (_kExecuteKey==sTriggerFullAngle || _kExecuteKey == sDoubleClick))
	{
		sAngleMode.set(bFullAngle?tAdjacentAngle:tComplementaryAngle);	
		setExecutionLoops(2);
		return;
	}
	
	
//region Trigger AddSimilar
	String sTriggerAddSimilar = T("|Add Similar|");
	addRecalcTrigger(_kContextRoot, sTriggerAddSimilar );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddSimilar)
	{
		
	//region Show Jig
		PrPoint ssP(T("|Select new location|"), _Pt0); // second argument will set _PtBase in map
	    Map mapArgs;
	    
		mapArgs.setString("mode", sMode);
		mapArgs.setPlaneProfile(kShape, ppShape);
		mapArgs.setDouble("DimScale", dDimScale);
		mapArgs.setInt("Color", nColor);
		mapArgs.setString(kDimDimstyle, sDimStyle);
		mapArgs.setDouble(kTextHeight, textHeight);

		mapArgs.setPoint3dArray("ptsX1", ptsX1);
		mapArgs.setPoint3dArray("ptsX2", ptsX2);
		mapArgs.setPoint3dArray("ptsCen", ptsCen);	
		
	    int nGoJig = -1;
	    while (nGoJig != _kOk && nGoJig != _kNone)
	    {
	        nGoJig = ssP.goJig(kJigSelectAngle, mapArgs); 
	        if (bDebug)reportMessage("\ngoJig returned: " + nGoJig);
	        
	        if (nGoJig == _kOk)
	        {
	            Point3d pt = ssP.value(); //retrieve the selected point
	            Point3d ptG0 = pt + (_PtG[0] - ptArc);
			// create TSL
				TslInst tslNew;
				GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {pt, ptG0};
				int nProps[]={nColor};			
				double dProps[]={dTextHeight,dGlobalScale};				
				String sProps[]={sMode,sPainter,sAngleMode,sSuppress90,sFormat,sDimStyle,sLineType};
				Map mapTsl;	
				
				if (bAddTextLocation)
				{
					Point3d ptG1 = ptG0 + (_PtG[1] - ptArc);
					ptsTsl.append(ptG1);
				}

				
				String k;
				if (bHasPage)
				{
					mapTsl.setVector3d("vecOrg",  pt - _PtW); // relocate to multipage
					k = "ModelView"; 	if (_Map.hasVector3d(k)) mapTsl.setVector3d(k, _Map.getVector3d(k));
					entsTsl.append(page);
				}
				else if (bHasSection)
				{
					entsTsl.append(section);
				}	
				else if (!bHasViewport)
				{
					entsTsl.append(entDefine);
				}
					
				k = "arcRadius"; 	if (_Map.hasDouble(k)) mapTsl.setDouble(k, _Map.getDouble(k));

				tslNew.dbCreate(scriptName() , vecX ,vecY,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	
				
				if (tslNew.bIsValid() && _ThisInst.color()>-1 && nColor==-1)
					tslNew.setColor(_ThisInst.color());	            
	            
	            
	            
	        }
	        else if (nGoJig == _kCancel)
	        { 
	            break;
	        }
	    }			
	//End Show Jig//endregion 

		setExecutionLoops(2);
		return;
	}//endregion	
	
	
	if (bHasPage)
	{ 
	//region Trigger RegenerateShopdrawing
		String sTriggerRegenerateShopdrawing = T("|Regenerate Shopdrawing|");
		addRecalcTrigger(_kContextRoot, sTriggerRegenerateShopdrawing );
		if (_bOnRecalc && _kExecuteKey==sTriggerRegenerateShopdrawing)
		{
			page.regenerate();		
			setExecutionLoops(2);
			return;
		}//endregion	
		
	}
	
	
	

	if (bHasViewport)
	{ 
		//region Trigger SetupLocation
			String sTriggerSetupLocation = T("|Pick Viewport Setup Location|");
			addRecalcTrigger(_kContextRoot, sTriggerSetupLocation );
			if (_bOnRecalc && _kExecuteKey==sTriggerSetupLocation)
			{
				
			//region Show Jig
//				Map m = _ThisInst.subMapX(kViewportSetup);
//			    Point3d pt = m.hasPoint3d("pt")?m.getPoint3d("pt"):_PtW;
//				
				Point3d pt = _PtW+_Map.getVector3d(kViewportOrg);
				
				Point3d ptFrom = pt;
				
				PrPoint ssP(T("|Pick new location|"), pt);
			    Map mapArgs;
			   
			    int nGoJig = -1;
			    while (nGoJig != _kOk && nGoJig != _kNone)
			    {
			        nGoJig = ssP.goJig(kJigSetupLocation, mapArgs); 

			        if (nGoJig == _kOk)
			        {
			            pt = ssP.value(); //retrieve the selected point
			        }
			        else if (nGoJig == _kCancel)
			        { 
			            return; 
			        }
			    }			
			//End Show Jig//endregion 
			
				
//				m.setPoint3d("pt", pt);
//				_ThisInst.setSubMapX(kViewportSetup, m);

				_Map.setVector3d(kViewportOrg, pt - _PtW);
				
				Vector3d vec = pt - ptFrom;
				if (bIsViewportSetup && vec.length()>0)
				{ 
					_Pt0.transformBy(vec);
					for (int i=0;i<_PtG.length();i++) 
						_PtG[i].transformBy(vec); 	
				}


				setExecutionLoops(2);
				return;
			}//endregion	
		
	}
	


	addRecalcTrigger(_kGripPointDrag, "_Pt0");
	for (int i=0;i<_PtG.length();i++) 
		addRecalcTrigger(_kGripPointDrag, "_PtG"+i);		
//endregion 

//region Multipage: store current location relative to mp location
	if(bHasPage)
	{ 
		Point3d ptOrg = page.coordSys().ptOrg();
		Vector3d vecOrg = Vector3d(_Pt0 - ptOrg);
		_Map.setVector3d("vecOrg", vecOrg);	
	}		
//endregion 










#End
#BeginThumbnail
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
:`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`__]D`








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
        <int nm="BreakPoint" vl="3193" />
        <int nm="BreakPoint" vl="2257" />
        <int nm="BreakPoint" vl="3039" />
        <int nm="BreakPoint" vl="2602" />
        <int nm="BreakPoint" vl="1534" />
        <int nm="BreakPoint" vl="3140" />
        <int nm="BreakPoint" vl="3137" />
        <int nm="BreakPoint" vl="3122" />
        <int nm="BreakPoint" vl="2966" />
        <int nm="BreakPoint" vl="3033" />
        <int nm="BreakPoint" vl="3025" />
        <int nm="BreakPoint" vl="3018" />
        <int nm="BreakPoint" vl="3193" />
        <int nm="BreakPoint" vl="2257" />
        <int nm="BreakPoint" vl="3039" />
        <int nm="BreakPoint" vl="2602" />
        <int nm="BreakPoint" vl="1534" />
        <int nm="BreakPoint" vl="3140" />
        <int nm="BreakPoint" vl="3137" />
        <int nm="BreakPoint" vl="3122" />
        <int nm="BreakPoint" vl="2966" />
        <int nm="BreakPoint" vl="3033" />
        <int nm="BreakPoint" vl="3025" />
        <int nm="BreakPoint" vl="3018" />
        <int nm="BreakPoint" vl="1609" />
        <int nm="BreakPoint" vl="2224" />
        <int nm="BreakPoint" vl="1804" />
        <int nm="BreakPoint" vl="1517" />
        <int nm="BreakPoint" vl="2409" />
        <int nm="BreakPoint" vl="1840" />
        <int nm="BreakPoint" vl="1893" />
        <int nm="BreakPoint" vl="1926" />
        <int nm="BreakPoint" vl="1937" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20640 arc length dimensions only created if format argument is given" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="11/15/2023 10:53:54 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19785 default warning 'invalid selection' disabled" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="8/8/2023 2:34:52 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18965 bugfix insert on multipages containing an isometric view" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="5/12/2023 2:14:49 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18196 arc reconstruction added" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="3/3/2023 11:21:57 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17977 accepting toleances when ignoring 90° or multiples of it " />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="2/15/2023 11:47:49 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16830 insert location on paperspace viewports validated" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="1/31/2023 10:46:48 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17107 supports angular dim requests based on submapX hsb_DimensionInfo" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="1/12/2023 12:31:31 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16932 additional adjacent angle added, offset viewport placement fixed" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="11/11/2022 3:00:24 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16291 bugfix adjacent angle collection" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="11/3/2022 3:00:29 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16291 section support added, viewport filters added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="10/28/2022 9:54:20 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16291 multipage and auto generation through blockspace definition supported" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="10/21/2022 4:14:00 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16291 basic element viewport support added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="10/19/2022 2:41:01 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16507 filtering by painter and element  support added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="10/15/2022 2:02:19 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16507 collection entity multipage support added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="10/14/2022 7:15:21 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16507 genbeam multipage support added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="10/7/2022 4:48:22 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16507 adjacent and complete angle trigger added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="10/7/2022 4:28:44 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16507 reference modes added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="9/16/2022 1:45:01 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16246 initial version" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="8/19/2022 3:11:51 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End