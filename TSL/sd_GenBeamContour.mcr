#Version 8
#BeginDescription
/// Version 1.9   th@hsbCAD.de   14.03.2011
/// bugfix drill chain content, 'Diameter at Reference Point' if this mode is selected the program will fall back to the mode
/// 'Diameter only' if different diameters have been detected
/// New option for the drill chain content 'Individual Diameter at Reference Point'
/// This option will create as many dimlines as different drill diameters are collected.
/// The stereotypes for these dimlines are composed with the string 'Drill' and the corresponding diameter 
/// in mm 'Drill'<Diameter[mm]>, i.e. for a diameter of 14mm one needs to add a stereotype called Drill14. If no
/// corresponding stereotypes are foundi it will fall back to the default stereotype which could then also be used
/// as one stereotype for all diameter variations

Consumes any beam and creates several dimrequests in dependency of the contour and containg drills
Uses the following Stereotypes: Drill, Extremes, Contour, Beamcut (optimized to 'relative to offset direction')




#End
#Type E
#NumBeamsReq 1
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 9
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// Consumes any GenBeam and creates several dimrequests in dependency of the contour and containg drills
/// </summary>

/// <insert Lang=en>
/// This tsl is only executed by the shopdraw engine and to use it one
/// needs to append it to the ruleset of a multipage style.
/// </insert>

/// <remark Lang=en>
/// This tsl requires the TSL mapIO_GetArcPLine.mcr in the drawing or
/// in one of the search path's 
/// </remark>

/// <remark Lang=en>
/// Uses the following Stereotypes: Drill, Extremes, Contour, Beamcut (optimized to 'relative to offset direction')
/// </remark>

/// History
/// Version 1.9   th@hsbCAD.de   14.03.2011
/// bugfix drill chain content, 'Diameter at Reference Point' if this mode is selected the program will fall back to the mode
/// 'Diameter only' if different diameters have been detected
/// New option for the drill chain content 'Individual Diameter at Reference Point'
/// This option will create as many dimlines as different drill diameters are collected.
/// The stereotypes for these dimlines are composed with the string 'Drill' and the corresponding diameter 
/// in mm 'Drill'<Diameter[mm]>, i.e. for a diameter of 14mm one needs to add a stereotype called Drill14. If no
/// corresponding stereotypes are foundi it will fall back to the default stereotype which could then also be used
/// as one stereotype for all diameter variations
/// Version 1.8   th@hsbCAD.de   11.03.2011
/// bugfix
/// Version 1.7   th@hsbCAD.de   11.03.2011
/// new option to display extrusion profile based views in a different level of detailing. Default is low detail.
/// Version 1.6   th@hsbCAD.de   28.02.2011
/// dimensioning of drills enhanced
/// simple housings supported
/// Version 1.5   th@hsbCAD.de   09.02.2011
/// intersecting drills at contour do not lead into staggered vertex dimension
/// openings of sheets and sip panels supported
/// Version 1.4   th@hsbCAD.de   18.01.2011
/// real Genbeam support. requires hsbCAD 2012
/// Version 1.3   th@hsbCAD.de   08.11.2010
/// new options
/// Version 1.0   th@hsbCAD.de   19.10.2010
/// initial


// basics and props
	U(1,"mm");
	double dEps = U(0.1);
	int nDebug=0;
	int bReportViews = false;
	int bReportOptions = false;	

// on insert
	if (_bOnInsert) {
		
		_GenBeam.append(getGenBeam());
		_Pt0 = getPoint("Select point near tool");
		return;
	}
//end on insert________________________________________________________________________________


// declare the options to be set through the Map
	// NOTE: the CustomMapSettings and CustomMapTypes need to have the same length !
	String sCustomMapSettings[] = {"ChainContentDrill","DiameterUnit","AddExtremes", "AddAngles", "SegmentToArcLength","ExtrProfDimMode"};
	String sCustomMapTypes[] = {"int","int","int","int","double","int"};


// on MapIO
	String sArChainContentDrill[] = {T("|Chain Dimension|"),T("|Chain Dimension with Diameter|"),T("|Diameter only|"), T("|Diameter at Reference Point|"),  T("|Individual|") +" " + T("|Diameter at  Reference Point|")};	
	String sArDiameterUnit[] = {T("|DWG Unit|"),"m","cm","mm","in","ft"};		
	String sArAddAngle[] = {T("|Add|"),T("|Add and suppress same angle near by|"),T("|Do not show|")};
	String sArExtrProfDimMode[] = {T("|Low Detail|"),T("|High Detail|"),T("|Do not show|")};
	if (_bOnMapIO)
	{
		// define property
		String sArNY[] = {T("|No|"),T("|Yes|")};

		PropString ChainContentDrill(0,sArChainContentDrill,T("|Chain Content|") + " " + T("|Drill|"));
		ChainContentDrill.setDescription(T("|Defines the text content of the chain dimension points|"));		
		PropString DiameterUnit(1,sArDiameterUnit,T("|Diameter Units|"));
		DiameterUnit.setDescription(T("|Sets the unit for any text which displays diameter or radius values|"));
		PropString AddExtremes(2,sArNY,T("|Additional Dimline Extremes|"));
		AddExtremes.setDescription(T("|Adds an additional dimline with the extreme dimpoints of the entity|"));
		PropString AddAngles(3,sArAddAngle,T("|Add Contour Angles|"));
		AddAngles.setDescription(T("|Adds angular dimensions if not 90°|"));
		PropDouble SegmentToArcLength(0,U(5),T("|Segment to Arc Length|"));
		SegmentToArcLength.setDescription(T("|Straight segments which could describe an Arc can be converted to an Arc|") + " " + T("|Sets the maximum length of segment which will be converted if applicable|"));	
		PropString ExtrProfDimMode(4,sArExtrProfDimMode,T("|Extrusion Profile Dimensioning|"));
		ExtrProfDimMode.setDescription(T("|Specifies how the dimension of an entity which is based on an extrusion profile will be displayed|"));

		//PropString NotchDimMode(3,sArNotchDimMode,sCustomMapSettings[3]);// NotchDimMode


	// make sure the offsets are not set to zero when called the first time
		//if(!_Map.hasString(sCustomMapSettings[0]))		_Map.setString(sCustomMapSettings[0],String().formatUnit(U(200),2,0));	
		//if(!_Map.hasString(sCustomMapSettings[2]))		_Map.setString(sCustomMapSettings[2],String().formatUnit(U(800),2,0));
		//if(!_Map.hasString(sCustomMapSettings[3]))		_Map.setString(sCustomMapSettings[3],String().formatUnit(U(1200),2,0));
		if(!_Map.hasString(sCustomMapSettings[4]))		_Map.setString(sCustomMapSettings[4],String().formatUnit(U(5),2,0));

												
	// find value in _Map, if found, change the property values
	
		ChainContentDrill.set(sArChainContentDrill[_Map.getString(sCustomMapSettings[0]).atoi()]);
		DiameterUnit.set(sArDiameterUnit[_Map.getString(sCustomMapSettings[1]).atoi()]);
		AddExtremes.set(sArNY[_Map.getString(sCustomMapSettings[2]).atoi()]);
		AddAngles.set(sArAddAngle[_Map.getString(sCustomMapSettings[3]).atoi()]);
		SegmentToArcLength.set(_Map.getString(sCustomMapSettings[4]).atof());
		ExtrProfDimMode.set(sArExtrProfDimMode[_Map.getString(sCustomMapSettings[5]).atoi()]);
		//offsetBaselineExtremes.set(_Map.getString(sCustomMapSettings[3]).atof());
		//offsetBaselineDrill.set(_Map.getString(sCustomMapSettings[4]).atof());
		//showIndividualDepth.set(sArIndividualDepthWidth[_Map.getString(sCustomMapSettings[0]).atoi()]);
		
		// show the dialog to the user
		showDialog("---"); // use "---" such that the set values are used, and not the last dialog values
		_Map = Map();

		int nInd;
		// interpret the properties, and fill _Map
		// by checking the index default values will not be written to _Map
													_Map.setString(sCustomMapSettings[0],sArChainContentDrill.find(ChainContentDrill));	
													_Map.setString(sCustomMapSettings[1],sArDiameterUnit.find(DiameterUnit));	
													_Map.setString(sCustomMapSettings[2],sArNY.find(AddExtremes));
													_Map.setString(sCustomMapSettings[3],sArAddAngle.find(AddAngles));
		if (SegmentToArcLength>=0)			_Map.setString(sCustomMapSettings[4],SegmentToArcLength);	
													_Map.setString(sCustomMapSettings[5],sArExtrProfDimMode.find(ExtrProfDimMode));
		//if (offsetBaselineExtremes>=0)	_Map.setString(sCustomMapSettings[3],offsetBaselineExtremes);	
		//if (offsetBaselineDrill>=0)		_Map.setString(sCustomMapSettings[4],offsetBaselineDrill);				
		//nInd = sArIndividualDepthWidth.find(showIndividualDepth,0); 		if (nInd>0)  _Map.setString(sCustomMapSettings[0],nInd);
		
		return;
	}


	GenBeam gb;
	if (_GenBeam.length()>0) 
		gb = _GenBeam[0]; // would be valid if added to a GenBeam in the drawing
	if (!gb.bIsValid() && _Entity.length()>0)
		gb= (GenBeam)_Entity[0]; // when the shopdraw engine calls this Tsl, the _Entity array contains the Beam
		
	if (!gb.bIsValid()) {
		reportMessage("\n"+scriptName() +": " + T("|No GenBeam found. !Instance erased.|"));
		eraseInstance();
		return;
	}


// declare the map of options
	Map mapOption;
	
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
		// 3 = Diameter at  Reference Point
		// 4 = Individual Diameter at  Reference Point
		if (_bOnDebug)nChainContentDrill =4;
	int nDiameterUnit = mapOption.getInt(sCustomMapSettings[1]);
	int bAddExtremes= mapOption.getInt(sCustomMapSettings[2]);
	int nAddAngles= mapOption.getInt(sCustomMapSettings[3]);
	int nExtrProfDimMode= mapOption.getInt(sCustomMapSettings[5]);
	
	double dSegmentToArcLength= mapOption.getDouble(sCustomMapSettings[4]);
	// set the default to 5mm if not specified
	if(!mapOption.hasDouble(sCustomMapSettings[4]))
		dSegmentToArcLength=U(5);
		
	//double dOffsetBaselineExtremes= mapOption.getDouble(sCustomMapSettings[3]);
	//double dOffsetBaselineSloped= mapOption.getDouble(sCustomMapSettings[4]);

// is extrusionProfile based
	int bHasExtrProf;
	if (gb.bIsKindOf(Beam()) && ExtrProfile().getAllEntryNames().find(((Beam)gb).extrProfile())>1)
		bHasExtrProf=true;

// The parent key which is used in definition of a DimRequest is used to group all DimRequests.
	String strParentKey = String(scriptName());
	

// the gb coordsys (aligned for hip and valley rafters for aligned projected views
	Vector3d vxGb,vyGb,vzGb;
	vxGb = gb.vecX();
	vyGb = gb.vecY();
	vzGb = gb.vecZ();	

	vxGb.vis(_Pt0,1);vyGb.vis(_Pt0,3);vzGb.vis(_Pt0,150);							
	Point3d ptCen = gb.ptCenSolid();
	double dLenSolid = gb.solidLength();	
	
// collect some specific tools of this beam
	AnalysedTool tools[] = gb.analysedTools(_bOnDebug); // 2 means verbose reportNotice 
	AnalysedDrill drills[]= AnalysedDrill().filterToolsOfToolType(tools);//,_kADPerpendicular);	
	AnalysedBeamCut beamcuts[]= AnalysedBeamCut().filterToolsOfToolType(tools);//,_kADPerpendicular);	

// possible view directions in length
	Vector3d vArView[0];//	
	vArView.append(gb.vecY());	//vArView[0].vis(_Pt0,0);
	vArView.append(-gb.vecZ()); //vArView[1].vis(_Pt0,1);
	
// declare view vecs
	Vector3d vxView, vyView, vzView;	
	vxView = vxGb;

// collect drill dim points for the two main views and circles of the drill
	Point3d ptY[0], ptZ[0];
	double dDiamY[0], dDiamZ[0];
	PLine plArDrill[0];
	for (int i=0;i<drills.length();i++)
	{
		plArDrill.append(PLine(drills[i].vecZ()));
		plArDrill[i].createCircle(drills[i].ptStartExtreme(),drills[i].vecZ(),drills[i].dRadius());
		//plArDrill[i].vis(i);
		if (drills[i].vecFree().isParallelTo(vArView[0]))
		{
			ptY.append(drills[i].ptStartExtreme());
			dDiamY.append(drills[i].dDiameter());	
		}
		else if (drills[i].vecFree().isParallelTo(vArView[1]))
		{
			ptZ.append(drills[i].ptStartExtreme());		
			dDiamZ.append(drills[i].dDiameter());	
		}			
	}
	
// order by diameter
	// gb.vecY view
	for (int i=0;i<ptY.length();i++)		
		for (int j=0;j<ptY.length()-1;j++)
		{
			if (dDiamY[j]>dDiamY[j+1])
			{
				ptY.swap(j,j+1);
				dDiamY.swap(j,j+1);	
			}	
		}	
	// gb.vecZ view
	for (int i=0;i<ptZ.length();i++)		
		for (int j=0;j<ptZ.length()-1;j++)
		{
			if (dDiamZ[j]>dDiamZ[j+1])
			{
				ptZ.swap(j,j+1);
				dDiamZ.swap(j,j+1);	
			}	
		}	
		
		
// the body
	Body bd = gb.realBody();	

				
// loop view directions
	Point3d ptDrill[0];
	ptDrill = ptY;
	double dDiam[0];
	dDiam = dDiamY;
	
	for (int v=0; v<vArView.length(); v++) 
	{
		Vector3d vzView = -vArView[v];
		Vector3d vyView = vxView.crossProduct(-vzView);
		
		Vector3d vxDimline = vxView;
		Vector3d vyDimline = vxDimline.crossProduct(-vzView);
		Vector3d vzDimline = vzView;
		
	// the contour
		PlaneProfile ppShadow = bd.shadowProfile(Plane(ptCen,vzView));
		//PlaneProfile pp = ppShadow;
		//pp.transformBy(vzView *U(200));
		//pp.vis(211);
		
	// get offseted outline
		PlaneProfile ppDimOutline = ppShadow;
		ppDimOutline.shrink(-U(5));
		PLine plRings[] =ppDimOutline.allRings();;
		int bIsOp[] = ppDimOutline.ringIsOpening();
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
		
		plRings =ppShadow.allRings();
		bIsOp =ppShadow.ringIsOpening();
		PLine plEnvelope, plOpenings[0];
		for (int r=0; r< plRings.length();r++)
		{
			if (!bIsOp[r] && plRings[r].area()>plEnvelope.area())	
				plEnvelope	= plRings[r];
			else if(bIsOp[r])
			{
				plOpenings.append(plRings[r]);
				PLine pl = plRings[r];
				pl.transformBy(vzView*U(200));
				pl.vis(2);
			}
		}

		
	// vertices
		Point3d ptAll[] = plEnvelope.vertexPoints(true);
		Point3d ptExtr[0];
		
	// analyse drill points	
		double dArDiam[0];
		for (int i=0;i<ptDrill.length();i++)
		{
			if (dArDiam.find(dDiam[i])<0)
				dArDiam.append(dDiam[i]);	
		}
		int bHasMultipleDiams =dArDiam.length()>1;
		
	// change potential setting if multiple diameters are detected
		if (bHasMultipleDiams && nChainContentDrill==3)
		{
			nChainContentDrill=2;
			reportMessage("\n" + T("|Content changed to|" + ": " + sArChainContentDrill[nChainContentDrill]));	
		}	

	// loop drills		
		Point3d ptDim[0];
		for (int i=0;i<ptDrill.length();i++)
		{
		// the diameter and its qty in the chain	
			double dThisDiameter = 	dDiam[i];
			int nQty;
			if (bHasMultipleDiams)
			for (int i=0;i<dDiam.length();i++)
				if (dDiam[i]==dThisDiameter)
					nQty++;
		

			
		// build the stereotype
			String sStereotypeDrill = "Drill";
			if(nChainContentDrill==4)
			{
				String s;
				s.formatUnit(dThisDiameter/U(1,"mm"));
				sStereotypeDrill = sStereotypeDrill +s;
				
			}	
			
			
		// format the diameter: use this if the shopdraw unit varies from the dwg unit	
			String sDiameter = dThisDiameter;
			if (nDiameterUnit>0)
				sDiameter.formatUnit(dThisDiameter/U(1,"mm")/U(1,sArDiameterUnit[nDiameterUnit]), 2,3);			
			
		// x-dim	
			vxDimline = vxView;
			vyDimline = vxDimline.crossProduct(-vzView);			
				
			for (int xy=0;xy<2;xy++)
			{
				ptExtr = Line(ptCen,vxDimline).orderPoints(ptAll);	
	
				ptDim.setLength(0);
				if (ptExtr.length()>1)
				{				
					ptDim.append(ptExtr[0]);	
					ptDim.append(ptDrill[i]);
					ptDrill[i].vis(4);
					ptDim.append(ptExtr[ptExtr.length()-1]);
				}	
	
				for (int p = 0; p < ptDim.length();p++)
				{
				// snap to outline contour
					Point3d pt = ptDim[p];
					Point3d ptNext[] = plOutline.intersectPoints(Plane(pt,vxDimline));
					ptNext = Line(pt,-vyDimline).orderPoints(ptNext);
					if (ptNext.length()>0)	pt=ptNext[0];					
					
					DimRequestPoint dr(strParentKey , pt, vxDimline, vyDimline);//
					dr.setStereotype(sStereotypeDrill);//
					if (p==0)dr.setIsChainDimReferencePoint(true);					
					

					// content builder
					String s = " ";

					// 0 = Chain Dimension
					if (nChainContentDrill==0)
					{
						if (p==0)	s = " ";
						else			s = "<>"; 
						
						if (p==1 && xy==0)
						{
							Vector3d vxChoord = _XW+_YW;
							CoordSys csThis;
							csThis.setToAlignWorldToPlane(Plane(_Pt0,vzView));
							vxChoord.transformBy(csThis);
							vxChoord.normalize();
							DimRequestRadial drRad(strParentKey,ptDim[1],ptDim[1]+vxChoord *.5 * dThisDiameter);
							drRad.addAllowedView(vzView, TRUE); //vecView
							addDimRequest(drRad);
							//drRad.vis(6);	
						}

					}
					else if (p>0 && nChainContentDrill==0)	s = "<>";// + "_0";
					// 1 = Chain Dimension with Diameter
					else if(nChainContentDrill==1)
					{
						if (p!=1)	s = "<>"; 	
						else			s = "<>"+ " " + T("|Ø|") + sDiameter;//+"_1;					
					}
					// 2 = Diameter only
					else if(nChainContentDrill==2)
					{
						if (p!=1)	s = " "; 	
						else			s = T("|Ø|") + sDiameter; 	
									
					}
					// 3 = Diameter only at Reference Point
					else if(nChainContentDrill==3 || nChainContentDrill==4)
					{
						if(p==0)
						{
							s = T("|Ø|") + sDiameter;
							if (pt.length()>1)
								s = nQty + "x" + s;	
						}
						else
							s =" ";						
					}								
							
					dr.setNodeTextCumm(s);
					dr.addAllowedView(vzDimline, true);//bAlsoReverseDirection); //vecView
					dr.vis(xy); // visualize for debugging 
					addDimRequest(dr); // append to shop draw engine collector
				}	
				// y-dim
				vxDimline = vyView;
				vyDimline = vxDimline.crossProduct(-vzView);				
			}// next xy
		}// next i loop drills

	// set arrays for other view direction
		ptDrill=ptZ;
		dDiam = dDiamZ;
	}
// loop view directions	
	
// add contour dimensions
	Vector3d vxArView[0],vyArView[0];
	vxArView.append(gb.vecX());	vyArView.append(-gb.vecY());	//Front View
	vxArView.append(gb.vecX());	vyArView.append(gb.vecZ());	//Top View
	vxArView.append(gb.vecY());	vyArView.append(gb.vecZ());	//Left View
	
	for (int v=0; v< vxArView.length();v++)
	//int v=1;
	{
		Vector3d vxView,vyView,vzView;
		vxView = vxArView[v];
		vyView = vyArView[v];
		vzView = vxArView[v].crossProduct(vyArView[v]);
		if(v==1)vzView.vis(_Pt0,150);
		Vector3d vyArDim[] = {vxView,vyView,-vxView,-vyView};

	// the contour
		PlaneProfile ppShadow = bd.shadowProfile(Plane(ptCen,vzView));
		LineSeg lsShadow = ppShadow.extentInDir(vxView);
	// get offseted outline
		PlaneProfile ppDimOutline = ppShadow;
		ppDimOutline.shrink(-U(5));
		PLine plRings[] =ppDimOutline.allRings();;
		int bIsOp[] = ppDimOutline.ringIsOpening();
		PLine plOutline;
		for (int r=0; r<plRings.length(); r++) 
			if (!bIsOp[r] && plOutline.area()<plRings[r].area())
				plOutline = plRings[r];
		
		plRings =ppShadow.allRings();
		bIsOp =ppShadow.ringIsOpening();
		PLine plShadow;
		for (int r=0; r< plRings.length();r++)
		{
			if (!bIsOp[r] && plRings[r].area()>plShadow.area())	
				plShadow	= plRings[r];
		}
		
	// the array of plines to be dimensioned
		PLine	plArEnvelope[]={plShadow};
		// collect potential openings
		if (vzView.isParallelTo(gb.vecZ()) && gb.bIsKindOf(Sip()))
		{
			Sip sip = (Sip)gb;
			plArEnvelope.append(sip.plOpenings());
		}
		else if (vzView.isParallelTo(gb.vecZ()) && gb.bIsKindOf(Sheet()))
		{
			Sheet sheet = (Sheet)gb;
			plArEnvelope.append(sheet.plOpenings());
		}
		// special rule for extrusion profile based beams
		else if (vzView.isParallelTo(gb.vecX()) && gb.bIsKindOf(Beam()) && bHasExtrProf && nExtrProfDimMode!=1)
		{
			// reset all plines
			plArEnvelope.setLength(0);
			// for low detail mode append the boxed shape
			if (nExtrProfDimMode==0)
			{
				PLine pl;
				pl.createRectangle(lsShadow, vxView,vyView);
				plArEnvelope.append(pl);
			}
		}		
		if (_bOnDebug && v==1)
		{
			//reportNotice("\nplines in list: "+plArEnvelope.length());
			plArEnvelope[0].vis(1);
			//return;
		}
		
	// process all plines, the first one is the outer contour (stereotype)	
		for (int e=0; e< plArEnvelope.length();e++)
		{
			PLine plEnvelope = plArEnvelope[e];
			PLine plArcs[0];

		// add potential radial dimensions
			if (!plEnvelope.coordSys().vecZ().isParallelTo(vzView))
				continue;

			//reportNotice("\nDim of pline e: " + e + " in View " + v);		
			{
			 	Map mapIO;
				mapIO.setPLine("pline",plEnvelope);			
				
			// test if the pline has even segments
				// the default of the segment length on which the conversion will work 
				// is set to 5mm, on contours with a set of segments of an even length 
				// the value will be overwritten, i.e. a round extrusion seen in vecX
				mapIO.setDouble("MaxSegLength",dSegmentToArcLength); 
				Point3d pt[] = plEnvelope.vertexPoints(false);
				if (pt.length()>17)
				{
					double dEvenSeg;
					int bEvenSegLength=true;
					for (int i=0;i<pt.length()-1;i++)	
					{	
						int n = i+1;		
						Vector3d vxSeg = pt[n]-pt[i];
						double dL = vxSeg.length();
						if (i==0)
							dEvenSeg = dL;
						else if(abs(dEvenSeg-dL)>dEps)
							bEvenSegLength=false;
		
					}
					if(bEvenSegLength && dSegmentToArcLength<dEvenSeg+dEps)
					{
						reportMessage("\n" + scriptName() + ": " + 
							T("|The maximal segment length has been adjusted to|")+ ": " +  (dEvenSeg+dEps) + ", " + T("|Viewport|") + " " + v); 
						mapIO.setDouble("MaxSegLength",dEvenSeg+dEps);
					}
				}
				
			// convert the pline to an arced pline if applicable
				TslInst().callMapIO("mapIO_GetArcPLine", mapIO);
				plEnvelope = mapIO.getPLine("pline");
				//plEnvelope.vis(2);
				// create a debug pline
				if(0)
				{
					EntPLine epl;
					epl.dbCreate(plEnvelope);
					epl.setColor(v);
				}			
	
			// get the arcs of the conversion
				Map mapArcs = mapIO.getMap("Arc[]");
				Point3d ptCen[0], ptChord[0];
				for (int a=0;a<mapArcs.length();a++)
				{	
					Map mapArc = mapArcs.getMap(a);
					ptCen.append(mapArc.getPoint3d("ptCenter"));
					ptChord.append(mapArc.getPoint3d("ptChord"));	
					plArcs.append(mapArc.getPLine("arc"));	
				}	
				//reportNotice("\nview " + v + " has " + plArcs.length() + " arcs");
				
			// cleanup tolerances
				for (int a=ptCen.length()-1;a>0;a--)
				{
					double dRadius1 = Vector3d(ptCen[a]-ptChord[a]).length();
					double dRadius2 = Vector3d(ptCen[a-1]-ptChord[a-1]).length();
					double dCenToCen = Vector3d(ptCen[a]-ptCen[a-1]).length();
					if (dCenToCen<dEps && abs(dRadius1-dRadius2)<dEps)
					{
						ptCen.removeAt(a);
						ptChord.removeAt(a);		
					}
				}			
				
			// add dim	
				for (int a=0;a<ptCen.length();a++)
				{
					DimRequestRadial drRad(strParentKey,ptCen[a],ptChord[a]);
					drRad.addAllowedView(vzView, TRUE); //vecView
					addDimRequest(drRad);
					drRad.vis(6);		
				}	
			}
		//END potential radial dimensions
	
		// vertices of the redefined plEnvelope
			if (v==1)plEnvelope.vis(211);
			Point3d pt[] = plEnvelope.vertexPoints(false);
	
		// continue for circles
			if (pt.length()<4)continue;
			Point3d ptExtr[0];
			LineSeg lsShadow = ppShadow.extentInDir(vxView);
			ptExtr.append(lsShadow.ptStart());
			ptExtr.append(lsShadow.ptEnd());

		// add optional angular dimension
			//if (_bOnDebug) nAddAngles=2;
			if (nAddAngles<2)
			{
				double dLastAngle; // store the previous angle to suppress next angle if identical and on same vertex
				int nLastVertex;
				for (int i=0;i<pt.length()-1;i++)
				{
					
				// the points and vectors for the angular dimension	
					Point3d ptCen = pt[i];
					double d0 = plEnvelope.getDistAtPoint(ptCen);			
					if (d0==0)
					{
						 d0 =plEnvelope.length();
					}
					Point3d pt1=plEnvelope.getPointAtDist(d0-dEps);
					double d1 = plEnvelope.getDistAtPoint(ptCen);			
					if (d1==plEnvelope.length()) d1 =0;
					Point3d pt2=plEnvelope.getPointAtDist(d1+dEps);	

				// ensure that the points are not on one of the drill circles
					// this happens i.e. when a drill is located at the edge of a genBeam and the drill is not completely inside
					int bOnDrill=false;
					for (int c=0;c<plArDrill.length();c++)
					{
						PLine pl = plArDrill[c];
						if (pl.coordSys().vecZ().isParallelTo(vzView))
						{
							pl.transformBy(vzView*vzView.dotProduct(pt1-pl.coordSys().ptOrg()));
							if (Vector3d(pl.closestPointTo(pt1)-pt1).length()<10*dEps || 
								Vector3d(pl.closestPointTo(pt2)-pt2).length()<10*dEps)
							{
								bOnDrill=true;					
								pl.vis(3);
								break;
							}
						}
					}
					if (bOnDrill)
						continue;
	
					
					Vector3d v1, v2;
					v1 = pt1-ptCen; v1.normalize();
					v2 = pt2-ptCen; v2.normalize();
					double dAngle = v1.angleTo(v2,v1);
					
				// if selected by the user suppress angles which are nearby and have the same angle as the previous one	
					int bIsNearAndSame;
					if (nAddAngles == 1 && abs(dLastAngle-dAngle)<dEps &&
						 i==nLastVertex && i>0 && 
						(pt[i]-pt[i-1]).length()<U(75))
						bIsNearAndSame=true;
					
					
					if (abs(dAngle-90)<0.5 || abs(dAngle-180)<0.5 || abs(dAngle-270)<0.5 ||
						bIsNearAndSame ||
						!plEnvelope.isOn(ptCen+v1*.5*dEps) || 
						!plEnvelope.isOn(ptCen+v2*.5*dEps))
					{
						
						dLastAngle=0;
						continue;
					}
					else
					{
						dLastAngle=dAngle;
						nLastVertex=i+1;	
					}
		
				// build the angular dimension
		 			Vector3d vAng = v1+v2; vAng.normalize();
					DimRequestAngular dr(strParentKey, ptCen, pt1, pt2, ptCen + vAng*U(25)); 
					dr.addAllowedView(vzView, TRUE); //vecView
					addDimRequest(dr); // append to shop draw engine collector					
					dr.vis(1);
				}	
			}
		// END optional angular dimension	
	
		
	
		// STRAIGHT loop x and y view for straight segments
			for (int xy=0;xy<vyArDim.length();xy++)
			{	
				if (xy>1 && e!=0) continue;
				//reportNotice("\n   xy view: " + xy);
				Vector3d vxDimline,vyDimline;
				vyDimline = vyArDim[xy];
				vxDimline = vyDimline.crossProduct(vzView);
				
				for (int i=0;i<pt.length()-1;i++)	
				{				
					LineSeg ls(pt[i+1],pt[i]);
					Vector3d vxSeg = pt[i+1]-pt[i];
					double dL = vxSeg.length();
					vxSeg.normalize();
				// get the vector pointing outside
					Vector3d vySeg = vxSeg.crossProduct(vzView);
					if (PlaneProfile(plEnvelope).pointInProfile(ls.ptMid()+vySeg*dEps) != _kPointOutsideProfile)
						vySeg*=-1;	
					//vySeg.vis(ls.ptMid(),3);			
	
	
				// add extremes (only once per main direction) and only for the outer contour
					if (xy<2 && bAddExtremes && e==0)
					{
						Point3d ptDim[0];
						ptDim.append(ptExtr);
						for (int p = 0; p < ptDim.length();p++)
						{
						// snap to outline contour
							Point3d pt = ptDim[p];
							Point3d ptNext[] = plOutline.intersectPoints(Plane(pt,vxDimline));
							ptNext = Line(pt,-vyDimline).orderPoints(ptNext);
							if (ptNext.length()>0)	pt=ptNext[0];						
							
							DimRequestPoint dr(strParentKey , pt, vxDimline, vyDimline);	
							dr.setStereotype("Extremes");
							if(p==0)
								dr.setNodeTextCumm("");				
							else
								dr.setNodeTextCumm("<>");// + sTxtPostFix);	
								
							dr.addAllowedView(vzView, TRUE); //vecView
							//dr.vis(xy); // visualize for debugging 
							addDimRequest(dr); // append to shop draw engine collector		
						}
					}	
				
				// ensure this point is not on one of the drill circles or on one of the arcs
					plArDrill.append(plArcs);
					int bOnDrill=false;
					for (int c=0;c<plArDrill.length();c++)
					{
						PLine pl = plArDrill[c];
						if (pl.coordSys().vecZ().isParallelTo(vzView))
						{
							pl.transformBy(vzView*vzView.dotProduct(pt[i]-pl.coordSys().ptOrg()));
							if (Vector3d(pl.closestPointTo(pt[i])-pt[i]).length()<10*dEps)
							{
								bOnDrill=true;					
								//pl.vis(2);
								break;
							}
						}
					}
					if (bOnDrill)
						continue;
	
	
	
				// only for openings or segments which are aligned with this dim direction		
					if (e>0 ||(vyArDim[xy].dotProduct(vySeg)>0 && !vyArDim[xy].isPerpendicularTo(vySeg)))
					{
					// test if segment is an inner contour segment (such as a beamcut)	
						Point3d ptInt[] = plEnvelope.intersectPoints(ls.ptMid(),vySeg);
						int bHasIntersection;
						for (int p = 0; p < ptInt.length();p++)
							if (vySeg.dotProduct(ptInt[p]-ls.ptMid())>dEps)
								bHasIntersection=true;
						if (bHasIntersection)
							ls.ptMid().vis(2);
						
						Point3d ptDim[0];
						ptDim.append(ptExtr);
						ptDim.append(pt[i]);
						ptDim = Line(_Pt0,vxDimline).orderPoints(ptDim);
						
						pt[i].vis(3);
					// toleance issue: ignore points which are very closed to the previous
						for (int p = ptDim.length()-2; p >=0;p--)
							if(abs(vxDimline.dotProduct(ptDim[p]-ptDim[p+1]))<dEps)
								ptDim.removeAt(p);
			
					// continue if not required as total dim
						if (bAddExtremes && ptDim.length()<3 || (!bAddExtremes && xy>1 && ptDim.length()<3))continue;	
			
						for (int p = 0; p < ptDim.length();p++)
						{
						// snap to outline contour							
							Point3d pt = ptDim[p];
							Point3d ptNext[] = plOutline.intersectPoints(Plane(pt,vxDimline));
							ptNext = Line(pt,-vyDimline).orderPoints(ptNext);
							if (ptNext.length()>0)	pt=ptNext[0];	

							DimRequestPoint dr;
						// the dimrequest of beamcuts of the outer contour	
							if (e==0 && bHasIntersection && ptDim.length()>2)
							{
								if (ptNext.length()>1)	pt=ptNext[1];
								dr = DimRequestPoint(strParentKey , pt, vxDimline, -vyDimline);	
								dr.setStereotype("Beamcut");
							}
						// the dimrequest of contour points or openings
							else
							{
								dr = DimRequestPoint(strParentKey , pt, vxDimline, vyDimline);	
								if (e==0)
									dr.setStereotype("Contour");
								else
									dr.setStereotype("Opening");							
							}
							
							if(p==0)
								dr.setNodeTextCumm("");				
							else
								dr.setNodeTextCumm("<>");// + sTxtPostFix);	
								
							dr.addAllowedView(vzView, TRUE); //vecView
							//dr.vis(xy); // visualize for debugging 
							//if (bHasIntersection)
							addDimRequest(dr); // append to shop draw engine collector		
						}
					}		
				}// next p
			}// next xy
		// END STRAIGHT loop x and y view for straight segments
		}// next e of plArEnvelope	
		
		
	// append beamcuts (i.e. simple housing)
		plOutline.vis(1);


		for (int i=0; i<beamcuts.length();i++)
		{
			// x-dim	
			Vector3d vxDimline = vxView;
			Vector3d vyDimline = vxDimline.crossProduct(-vzView);			

			if (beamcuts[i].toolSubType() == _kABCSimpleHousing || beamcuts[i].toolSubType() == _kABCDado)
			{	
				AnalysedBeamCut abc = beamcuts[i];
				if (!abc.coordSys().vecZ().isParallelTo(vzView))continue;
				Quader qdr = abc.quader();
				qdr.vis(3);
				
			// loop for x and y component		
				for (int xy=0;xy<2;xy++)
				{					
					int iDir = 1;
					Point3d ptDim[0];
					
					double dX=qdr.dD(vxDimline), dY=qdr.dD(vyDimline);
					
					// test distance to outline to distinguish if a linear dimline is required
					int bIsLinear;
					Point3d ptTmp[] = plOutline.intersectPoints(Plane(qdr.ptOrg(),vxDimline));
					if (ptTmp.length()>1)
					{
						double d0 = abs(vyDimline.dotProduct(qdr.ptOrg()-ptTmp[0]));
						double d1 = abs(vyDimline.dotProduct(qdr.ptOrg()-ptTmp[1]));
						double dDist=d0;
						Point3d pt = ptTmp[0];
						if (d1<d0)
						{
							pt = ptTmp[1];
							dDist = d0;	
						}
						
						// swap dimside
						if (Vector3d(qdr.ptOrg()-pt).dotProduct(vyDimline)<0)iDir*=-1;
						
						
						// add a linear dim if the location of the tool is more then it's value from the plOutline
						if (dDist>dY) bIsLinear=true;
							
						pt.vis(3);
					}
					ptDim.append(lsShadow.ptStart());
					ptDim.append(lsShadow.ptEnd());
					ptDim = Line(_Pt0,vxDimline).orderPoints(ptDim);
					
					ptDim.append(qdr.ptOrg()-vxDimline*.5*dX);
					ptDim.append(qdr.ptOrg()+vxDimline*.5*dX);

					for (int p = 0; p < ptDim.length();p++)
					{
					// snap to outline contour							
						Point3d pt = ptDim[p];
						//Point3d ptNext[] = plOutline.intersectPoints(Plane(pt,vxDimline));
						//ptNext = Line(pt,-vyDimline).orderPoints(ptNext);
						//if (ptNext.length()>0)	pt=ptNext[0];

						DimRequestPoint dr;
						dr = DimRequestPoint(strParentKey , pt, vxDimline, iDir*-vyDimline);	
						dr.setStereotype("Beamcut");
							
						if(p==0)
							dr.setNodeTextCumm("");				
						else
							dr.setNodeTextCumm("<>");// + sTxtPostFix);	
						dr.addAllowedView(vzView, TRUE); //vecView
						dr.vis(xy+5); // visualize for debugging 
						addDimRequest(dr); // append to shop draw engine collector	
					}// next p	
					// y-dim
					vxDimline = vyView;
					vyDimline = vxDimline.crossProduct(-vzView);							
				}// next xy

			}// END if kABCSimpleHousing				
		}// next i beamcut
	}// next view v





#End
#BeginThumbnail
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
!V3,/
`






#End
