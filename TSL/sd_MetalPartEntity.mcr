#Version 8
#BeginDescription
/// Version 1.2   th@hsbCAD.de   11.03.2011
/// bugfix assembly dimensions alignment
/// the metalpart collection may now be composed by genbeams and not only beams

/// Consumes any the category _kRCMetalPartCollectionEnt and
/// creates several dimrequests in dependency of containing entities and viewing direction


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// Consumes any the category _kRCMetalPartCollectionEnt and
/// creates several dimrequests in dependency of containing entities and viewing direction
/// </summary>

/// <insert Lang=en>
/// This tsl is only executed by the shopdraw engine and to use it one
/// needs to append it to the ruleset of a multipage style.
/// </insert>

/// <remark Lang=en>
/// Uses the following Stereotypes: Drill, Extremes, Contour, beamcut
/// </remark>

/// History
/// Version 1.2   th@hsbCAD.de   11.03.2011
/// bugfix assembly dimensions alignment
/// the metalpart collection may now be composed by genbeams and not only beams
/// Version 1.1   th@hsbCAD.de   25.10.2010
/// assembly dimensions limited to entities parallel/ perpendicular to the the ent coordSys
/// Version 1.0   th@hsbCAD.de   19.10.2010
/// initial


// standards
	U(1,"mm");
	double dEps = U(.01);
	int nDebug = 0;

// on insert
	if (_bOnInsert) {
		// when this tsl is inserted as entity in the drawing (so not in shopdraw ruleset)
		Entity ent = getEntity();
		reportMessage("\nType: "+ent.typeDxfName() );
		if (ent.bIsKindOf(CollectionEntity()))
		{
			_Entity.append(ent);
			_Pt0 = getPoint();
		}
		return;
	}

// declare the options to be set through the Map
	// NOTE: the CustomMapSettings and CustomMapTypes need to have the same length !
	String sCustomMapSettings[] = {"ChainContentDrill","DiameterUnit","offsetBaselineContour", "offsetBaselineExtremes", "offsetBaselineDrill"};
	String sCustomMapTypes[] = {"int","int","double","double","double"};


// on MapIO
	String sArChainContentDrill[] = {T("|Chain Dimension|"),T("|Chain Dimension with Diameter|"),T("|Diameter only|"), T("|Diameter only at Start|")};	
	String sArDiameterUnit[] = {T("|DWG Unit|"),"m","cm","mm","in","ft"};		
	if (_bOnMapIO)
	{
		// define property
		String sArNY[] = {T("|No|"),T("|Yes|")};

		PropString ChainContentDrill(0,sArChainContentDrill,T("|Chain Content|") + " " + T("|Drill|"));
		ChainContentDrill.setDescription(T("|Defines the text content of the chain dimension points|"));		
		PropString DiameterUnit(1,sArDiameterUnit,T("|Diameter Units|"));
		DiameterUnit.setDescription(T("|Sets the unit for any text which displays diameter or radius values|"));
		PropDouble offsetBaselineContour(1,U(800),T("|Offset Dimline|") + " " + T("|Contour|"));
		offsetBaselineContour.setDescription(T("|The offset of the dimension line to the dimensioned object|") + " " + T("|(0 = do not show)|"));
		PropDouble offsetBaselineExtremes(2,U(1400),T("|Offset Dimline|") + " " + T("|Extremes|"));
		offsetBaselineExtremes.setDescription(T("|The offset of the dimension line to the dimensioned object|") + " " + T("|(0 = do not show)|"));		
		PropDouble offsetBaselineDrill(3,U(200),T("|Offset Dimline|") + " " + T("|Drills|"));
		offsetBaselineDrill.setDescription(T("|The offset of the dimension line to the dimensioned object|") + " " + T("|(0 = do not show)|"));	
		//PropString NotchDimMode(3,sArNotchDimMode,sCustomMapSettings[3]);// NotchDimMode


	// make sure the offsets are not set to zero when called the first time
		//if(!_Map.hasString(sCustomMapSettings[0]))		_Map.setString(sCustomMapSettings[0],String().formatUnit(U(200),2,0));	
		if(!_Map.hasString(sCustomMapSettings[2]))		_Map.setString(sCustomMapSettings[2],String().formatUnit(U(800),2,0));
		if(!_Map.hasString(sCustomMapSettings[3]))		_Map.setString(sCustomMapSettings[3],String().formatUnit(U(1200),2,0));
		if(!_Map.hasString(sCustomMapSettings[4]))		_Map.setString(sCustomMapSettings[4],String().formatUnit(U(200),2,0));

												
	// find value in _Map, if found, change the property values
	
		ChainContentDrill.set(sArChainContentDrill[_Map.getString(sCustomMapSettings[0]).atoi()]);
		DiameterUnit.set(sArDiameterUnit[_Map.getString(sCustomMapSettings[1]).atoi()]);
		offsetBaselineContour.set(_Map.getString(sCustomMapSettings[2]).atof());
		offsetBaselineExtremes.set(_Map.getString(sCustomMapSettings[3]).atof());
		offsetBaselineDrill.set(_Map.getString(sCustomMapSettings[4]).atof());
		//showIndividualDepth.set(sArIndividualDepthWidth[_Map.getString(sCustomMapSettings[0]).atoi()]);
		
		// show the dialog to the user
		showDialog("---"); // use "---" such that the set values are used, and not the last dialog values
		_Map = Map();

		int nInd;
		// interpret the properties, and fill _Map
		// by checking the index default values will not be written to _Map
													_Map.setString(sCustomMapSettings[0],sArChainContentDrill.find(ChainContentDrill));	
													_Map.setString(sCustomMapSettings[1],sArDiameterUnit.find(DiameterUnit));	
		if (offsetBaselineContour>=0)		_Map.setString(sCustomMapSettings[2],offsetBaselineContour);	
		if (offsetBaselineExtremes>=0)	_Map.setString(sCustomMapSettings[3],offsetBaselineExtremes);	
		if (offsetBaselineDrill>=0)		_Map.setString(sCustomMapSettings[4],offsetBaselineDrill);				
		//nInd = sArIndividualDepthWidth.find(showIndividualDepth,0); 		if (nInd>0)  _Map.setString(sCustomMapSettings[0],nInd);
		
		return;
	}

// on debug or generate sd
	if (_bOnDebug || _bOnGenerateShopDrawing)
	{
		int nEnts = _Entity.length();
		String strRep = scriptName()+" reports "+nEnts+" entities.";
		for (int e=0; e<_Entity.length(); e++) 
		{
			Entity entE = _Entity[e];
			String strEnt = entE.typeName();
			strRep += "\n" + strEnt;
		}
		reportMessage("\n"+strRep );
	}

// stopp if no entity attached
	if (_Entity.length()==0) return;

// declare the map of options
	Map mapOption;


// a debug set of view modes
	mapOption.setInt("showViewX",true);
	mapOption.setInt("showViewY",true);	
	mapOption.setInt("showViewZ",true);
	mapOption.setInt("showDrillViewX",true);
	mapOption.setInt("showDrillViewY",true);	
	mapOption.setInt("showDrillViewZ",true);

// append user defined map settings to the options map
	for (int s = 0;s<sCustomMapSettings.length();s++)	
	{
		for (int i = 0;i<_Map.length();i++)
		{
			if (_Map.keyAt(i).makeUpper()==sCustomMapSettings[s].makeUpper() && _Map.hasString(i))
			{
				if (sCustomMapTypes.length() < s)
					;
				else if (sCustomMapTypes[s] == "int")
					mapOption.setInt(sCustomMapSettings[s],_Map.getString(i).atoi()); 	
				else if (sCustomMapTypes[s] == "double")
					mapOption.setDouble(sCustomMapSettings[s],_Map.getString(i).atof()); 						
				else
					mapOption.setString(sCustomMapSettings[s],_Map.getString(i)); 
			}
		}
	}

// properties
	int nChainContentDrill = mapOption.getInt(sCustomMapSettings[0]);
		// 0 = Chain Dimension
		// 1 = Chain Dimension with Diameter
		// 2 = Diameter only
		// 3 = Diameter only at Start
	int nDiameterUnit = mapOption.getInt(sCustomMapSettings[1]);	
	double dOffsetBaselineContour= mapOption.getDouble(sCustomMapSettings[2]);
	double dOffsetBaselineExtremes= mapOption.getDouble(sCustomMapSettings[3]);
	double dOffsetBaselineSloped= mapOption.getDouble(sCustomMapSettings[4]);

// cast to collection
	MetalPartCollectionEnt ce = (MetalPartCollectionEnt)_Entity[0];
	//reportMessage("\...and is valid:" + ce.bIsValid() + "unit = " +nDiameterUnit);
	if (!ce.bIsValid()) {
		eraseInstance(); // just erase from DB
		return;
	}
	String strDefinition = ce.definition();

	MetalPartCollectionDef cd(ce.definition());
	if (!cd.bIsValid()) {
	//	eraseInstance(); // just erase from DB
		return;
	}
	

// get the coordSys of the collection
	CoordSys cs = ce.coordSys();

	String strParentKey = String("Dim "+scriptName());

// collect subentities of the ce and some of the tools
	Entity entArMpc[]= cd.entity();
	GenBeam gbArMpc[] = cd.genBeam();
	GenBeam gbAr[0];
	TslInst tslSymbol[0], tslArMpc[] = cd.tslInst();
	if (nDebug==1)	reportNotice("\n"+ tslArMpc.length() + " temp tsl symbol definitions collected");
	if (nDebug==1)	reportNotice("\n"+ gbAr.length() + " gbAr collected");
	
	// collect symbol tsl's directly from the metalpart
	for (int b=0; b<tslArMpc.length(); b++) 
		if (tslArMpc[b].bIsValid() && tslArMpc[b].map().hasMap("Symbol[]") && tslSymbol.find(tslArMpc[b])<0)
			tslSymbol.append(tslArMpc[b]);
			
	// collect drills and symbol tsl's from beams of the metalpart					
	AnalysedDrill drills[0];
	for (int b=0; b<gbArMpc.length(); b++) 
		if (!gbArMpc[b].bIsDummy())
		{
			gbAr.append(gbArMpc[b]);
			AnalysedTool tools[] = gbArMpc[b].analysedTools();
			drills.append(AnalysedDrill ().filterToolsOfToolType(tools, _kADPerpendicular));	
			
			Entity entArSymbol[] = gbArMpc[b].eToolsConnected();
			for (int t=0; t<entArSymbol.length(); t++) 
			{
				TslInst tsl = (TslInst)entArSymbol[t];
				if (tsl.bIsValid() && tsl.map().hasMap("Symbol[]") && tslSymbol.find(tsl)<0)
					tslSymbol.append(tsl);
			}
		}
	
// build viewing coordSys and conditions
	Vector3d vArViewX[]={cs.vecX(),cs.vecZ(),cs.vecZ()};
	Vector3d vArViewY[]={cs.vecY(),cs.vecY(),cs.vecX()};
	int bShowView[] = {mapOption.getInt("showViewZ"),mapOption.getInt("showViewY"),mapOption.getInt("showViewX")};
	int bShowDrillView[] = {mapOption.getInt("showDrillViewZ"),mapOption.getInt("showDrillViewY"),mapOption.getInt("showDrillViewX")};

	int nDebugColorCounter = 1;

	double dBaselineOffset = U(50);

// loop view directions
	for (int v=0; v<vArViewX.length(); v++) 
	{
		Vector3d vxView = vArViewX[v];
		Vector3d vyView = vArViewY[v];
		Vector3d vzView = vxView.crossProduct(vyView);
		//vzView.vis(_Pt0,v);
		
		CoordSys csPs2Ms;
		csPs2Ms.setToAlignCoordSys(_Pt0,vxView,vyView,vzView,_Pt0,_XW,_YW,_ZW);
		
		//vxView.vis(_Pt0,v);

	// declare ring/opening arrays for temp usage
		PLine plRings[0];
		int bIsOp[0];
	
	// collect extremes and assembly points
		Point3d ptAssemblyX[0],ptAssemblyY[0],ptAssembly[0];
		Point3d ptExtr[0];
		PlaneProfile ppShadow;
		for (int b=0; b<gbAr.length(); b++)
		{
			Body bd = gbAr[b].realBody();
			
			Quader qdr;
			if (!gbAr[b].bIsKindOf(Beam()))
			{
				Beam bmDummy;
				bmDummy.dbCreate(bd, gbAr[b].vecX(), gbAr[b].vecY(), gbAr[b].vecZ());
				qdr = bmDummy.quader();	
				bmDummy.dbErase();
			}
			else
				qdr = ((Beam)gbAr[b]).quader();
				
			bd.transformBy(cs);
			qdr .transformBy(cs);
			// debug
			if (0)//v==0)
			{
				qdr.vis(3);
				bd.transformBy(_XW* U(200));
				bd.vis(b);
				vxView.vis(bd.ptCen(),b);
				Vector3d(qdr.vecD(vxView)).vis(bd.ptCen(),3);
				bd.transformBy(_XW* -U(200));
			}
			//bd.transformBy(vxView*U(.01));
			//if (v==1)bd.vis(v+1);
			//vzView.vis(bd.ptCen(),v+1);
			
		// the shadow of the beam	
			PlaneProfile ppBeamShadow=bd.shadowProfile(Plane(cs.ptOrg(),vzView));
			
		// collect assembly points of this	
			plRings =ppBeamShadow.allRings();;
			bIsOp = ppBeamShadow.ringIsOpening();
			PLine plBeamOutline;
			for (int r=0; r<plRings.length(); r++) 
				if (!bIsOp[r] && plBeamOutline.area()<plRings[r].area())
					plBeamOutline= plRings[r];
			
		// convert to potentially arced pline			
		 	Map mapIO;
			mapIO.setPLine("pline",plBeamOutline);
			TslInst().callMapIO("mapIO_GetArcPLine", mapIO);
			plBeamOutline= mapIO.getPLine("pline");					

			ptAssembly = Line(_Pt0,vxView).orderPoints(plBeamOutline.vertexPoints(true));
			if (ptAssembly.length()>1 && vxView.isParallelTo(qdr.vecD(vxView)))
			{
				ptAssemblyX.append(ptAssembly[0]);
				ptAssemblyX.append(ptAssembly[ptAssembly.length()-1]);
			}
			ptAssembly = Line(_Pt0,vyView).orderPoints(plBeamOutline.vertexPoints(true));
			if (ptAssembly.length()>1 && vyView.isParallelTo(qdr.vecD(vyView)))
			{
				ptAssemblyY.append(ptAssembly[0]);
				ptAssemblyY.append(ptAssembly[ptAssembly.length()-1]);
			}
					
		// combine to the view mpc pp	
			if (ppShadow.area()<pow(dEps,2))
				ppShadow = ppBeamShadow;	
			else
				ppShadow.unionWith(ppBeamShadow);
		}
		LineSeg ls = ppShadow.extentInDir(vxView);
		ptExtr.append(ls.ptStart());
		ptExtr.append(ls.ptEnd());
		
	// get offseted outline
		PlaneProfile ppDimOutline = ppShadow;
		ppDimOutline.shrink(-U(5));
		plRings =ppDimOutline.allRings();;
		bIsOp = ppDimOutline.ringIsOpening();
		PLine plOutline;
		for (int r=0; r<plRings.length(); r++) 
			if (!bIsOp[r] && plOutline.area()<plRings[r].area())
				plOutline = plRings[r];
		if (nDebug ==1)
		{		
			DimRequestPLine dpl("xxx" , plOutline,1);
			dpl.addAllowedView(vzView,true);
			addDimRequest(dpl); 
		}
		
	// collect drills which are parallel with this view
		AnalysedDrill drillsView[0];
		Point3d ptDrill[0];
		double dArDiam[0], dArDiamGroups[0];
		for (int d=0; d<drills.length(); d++) 
		{
			Vector3d vzDrillView = drills[d].vecFree();
			vzDrillView.transformBy(cs);
			if (!vzDrillView.isParallelTo(vzView))continue;
			drillsView.append(drills[d]);
			Point3d pt = drills[d].ptStart();				
			pt.transformBy(cs);
			ptDrill.append(pt);
			double dThisDiam = drills[d].dDiameter();
			dArDiam.append(dThisDiam);
			if (dArDiamGroups.find(dThisDiam)<0)
				dArDiamGroups.append(dThisDiam);
		}	
		
	// modify the content settings of the drills if multiple diameters are detected
		int bHasMultipleDiams;
		if (dArDiamGroups.length()>1)
		{
			if (nChainContentDrill==1)nChainContentDrill=0;			
			else if (nChainContentDrill==3)nChainContentDrill=2;
			bHasMultipleDiams=true;	
			reportMessage("\n" + T("|Content changed to|" + ": " + sArChainContentDrill[nChainContentDrill]));	
		}	
					
	// loop for X and Y dimlines	
		Vector3d vxArDim[] = {vxView,vyView};
		Vector3d vyArDim[] = {vyView,-vxView};
		for(int xy=0;xy<2;xy++)
		{	
			Vector3d vxDimline = vxArDim[xy], vyDimline= vyArDim[xy];
			Point3d ptDim[0];
			ptDim.append(ptExtr[0]);
			ptDim.append(ptExtr[1]);
			ptDim= Line(_Pt0,vxDimline).orderPoints(ptDim);	
			
		// dimension extremes	
			if (1)
			{	
				//ptDim= Line(_Pt0,vxDimline).orderPoints(ptDim);	
					
				for (int p=0; p<ptDim.length(); p++) 
				{
					Point3d pt = ptDim[p];
					Point3d ptNext[] = plOutline.intersectPoints(Plane(pt,vxDimline));
					ptNext = Line(pt,-vyDimline).orderPoints(ptNext);
					if (ptNext.length()>0)	pt=ptNext[0];
					DimRequestPoint dr(strParentKey , pt, vxDimline , vyDimline );
					dr.setStereotype("Extremes");//
					//dr.setNodeTextCumm("<>");// + ": " + sTxt[p]);
					if (p==0)dr.setIsChainDimReferencePoint(true);
					dr.addAllowedView(vzView,true);
					//dr.vis(v);//nDebugColorCounter++); // visualize for debugging 
					addDimRequest(dr); // append to shop draw engine collector	
				}		
			}
			
		// loop drills and dim if requested
			if (bShowDrillView[v] && ptDrill.length()>0)
			{	
				int nIndexOffset = ptDim.length();
				ptDim.append(ptDrill);				
				for (int p=0; p<ptDim.length(); p++) 
				{
					double dThisDiameter;
					if (dArDiam.length()>0)
						dThisDiameter = dArDiam[0];
					// set this diameter to the indexed drill
					if (p>(nIndexOffset-1))
						 dThisDiameter= dArDiam[p-nIndexOffset];
					
				// format the diameter: use this if the shopdraw unit varies from the dwg unit	
					String sDiameter = dThisDiameter;
					if (nDiameterUnit>0)
						sDiameter.formatUnit(dThisDiameter/U(1,"mm")/U(1,sArDiameterUnit[nDiameterUnit]), 2,3);
					

				// snap the dimpoint to an imaginary offseted outline
					Point3d pt = ptDim[p];
					Point3d ptNext[] = plOutline.intersectPoints(Plane(pt,vxDimline));
					ptNext = Line(pt,-vyDimline).orderPoints(ptNext);
					if (ptNext.length()>0 && nDebug !=2)	pt=ptNext[0];		
					if (nDebug >0)
					{		
						DimRequestPLine dpl("xxx" , PLine(pt,ptDim[p]),3);
						dpl.addAllowedView(vzView,true);
						addDimRequest(dpl); 
					}
		
					
					DimRequestPoint dr(strParentKey , pt, vxDimline , vyDimline );
					dr.setStereotype("Drill");//
					
					// content builder
					String s = " ";
					if (p==0)
					{
						dr.setIsChainDimReferencePoint(true);
						if(!bHasMultipleDiams && nChainContentDrill==3)
						{
							s = T("|Ø|") + sDiameter;
							if (pt.length()>1)
								s = ptDrill.length() + "x" + s;	
						}
						else
							s =" ";
					}
					else if (p>0 && nChainContentDrill==0)	s = "<>";// + "_0";							
					else if (p>1 && nChainContentDrill==1)	s = "<>"+ " " + T("|Ø|") + sDiameter;//+"_1;
					else if (p>0 && nChainContentDrill==1)	s = "<>"; 				
					else if (p>1 && nChainContentDrill==2)	s = T("|Ø|") + sDiameter;//+"_2"; 				
					else if (p>1 && nChainContentDrill==3)	s = " ";//+"_3";

					dr.setNodeTextCumm(s);
					dr.addAllowedView(vzView,true);
					//dr.vis(1);//nDebugColorCounter++); // visualize for debugging 
					addDimRequest(dr); // append to shop draw engine collector	
				}		
			}// END iF show drill in view
			
		// create assembly dimlines
			if (xy==0)ptAssembly=ptAssemblyX;
			else if (xy==1)ptAssembly=ptAssemblyY;
			if (ptAssembly.length()>3)
			{
				//reportMessage("\ncreating assembly dimline for "+ ptAssembly.length() + " points (" + xy + ")");	
				Point3d ptDim[0];
				ptDim.append(ptExtr);
				ptDim.append(ptAssembly);
				ptDim= Line(_Pt0,vxDimline).orderPoints(ptDim);	

				for (int p=0; p<ptDim.length(); p++) 
				{
					Point3d pt = ptDim[p];
					Point3d ptNext[] = plOutline.intersectPoints(Plane(pt,vxDimline));
					ptNext = Line(pt,vyDimline).orderPoints(ptNext);
					if (ptNext.length()>0)	pt=ptNext[0];
					DimRequestPoint dr(strParentKey , pt, vxDimline , -vyDimline );
					dr.setStereotype("Contour");//
					//dr.setNodeTextCumm("<>");// + ": " + sTxt[p]);
					if (p==0)dr.setIsChainDimReferencePoint(true);
					dr.addAllowedView(vzView,true);
					//dr.vis(v);//nDebugColorCounter++); // visualize for debugging 
					addDimRequest(dr); // append to shop draw engine collector	
				}		
			}// END IF assembly points
	
		}// next xy	
		
	// draw symbols if existant // depreciated -> moved to block definition tsl
		if (nDebug==1)	reportNotice("\n"+ tslSymbol.length() + " tsl symbol definitions collected");
		if(0)
		for(int t=0;t<tslSymbol.length();t++)
		{
			Map mapSymbols = tslSymbol[t].map().getMap("Symbol[]");
			Map mapCoordSys = tslSymbol[t].map().getMap("CoordSys");
			CoordSys csSym, cs2;
			//csSym.setToAlignCoordSys(mapCoordSys.getPoint3d("ptOrg"),mapCoordSys.getVector3d("vx"),mapCoordSys.getVector3d("vy"),mapCoordSys.getVector3d("vz"),
			//	mapCoordSys.getPoint3d("ptOrg"),_XW,_YW,_ZW);
			csSym.setToAlignCoordSys(cs.ptOrg(),cs.vecX(),cs.vecY(),cs.vecZ(),
				cs.ptOrg(),_XW,_YW,_ZW);
			
			//cs2.setToAlignCoordSys(_PtW,_XW,_YW,)
			for(int s=0;s<mapSymbols.length();s++)
			{
				if (nDebug==1)	reportNotice("\n   looping map");
				
				Map mapSymbol = mapSymbols.getMap(s);				
				if (!mapSymbol.hasPLine("pline")) continue;
				if (nDebug==1)	reportNotice("...pline collected");
				PLine pl = mapSymbol.getPLine("pline");
				pl.transformBy(cs);
				pl.transformBy(csSym);
				pl.vis(v+1);
				int nColor =mapSymbol.getInt("color");
				DimRequestPLine drpl(strParentKey,pl, nColor);
				drpl.addAllowedView(vzView,true);		
				addDimRequest(drpl);

			}	
		}
	}// next v view





#End
#BeginThumbnail
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
.O5,7;CHB?K_C3L%S_]FH
`



#End
