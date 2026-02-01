#Version 8
#BeginDescription
Shopdraw Dimensions for SIPs

Modified by: Chirag Sawjani (csawjani@itw-industry.com)
date: 13.07.2012 - version 1.0




#End
#Type E
#NumBeamsReq 1
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2012 by
*  hsbSOFT 
*
*  The program may be used and/or copied only with the written
*  permission from hsbSOFT, or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*
* REVISION HISTORY
* -------------------------
*
* Created by: Chirag Sawjani (csawjani@itw-industry.com)
* date: 13.07.2012 
* version 1.0: Release
*/

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
	String sCustomMapSettings[] = {"ChainContentDrill","DiameterUnit","AddExtremes", "AddAngles", "SegmentToArcLength",
		"ExtrProfDimMode","StereotypeOppositeDrill","DrawDrillCircles","StereotypeContour", "StereotypeExtremes",
		"StereotypeBeamcut","StereotypeOpening","DimAnglesOffset"};
	String sCustomMapTypes[] = {"int","int","int","int","double",
		"int","int","string","string","string",
		"string","string","double"};

// on MapIO
	String sArChainContentDrill[] = {T("|Chain Dimension|"),T("|Chain Dimension with Diameter|"),T("|Diameter only|"), T("|Diameter at Reference Point|"),  T("|Individual|") +" " + T("|Diameter at  Drill Point|"),T("|Suppress Drill Dimensions|")};	
	String sArDiameterUnit[] = {T("|DWG Unit|"),"m","cm","mm","in","ft"};		
	String sArAddAngle[] = {T("|Add|"),T("|Add and suppress same angle near by|"),T("|Do not show|")};
	String sArExtrProfDimMode[] = {T("|Low Detail|"),T("|High Detail|"),T("|Do not show|")};

	if (_bOnMapIO)
	{
		// define property
		String sArNY[] = {T("|No|"),T("|Yes|")};

		PropString ChainContentDrill(0,sArChainContentDrill,T("|Chain Content|") + " " + T("|Drill|"));
		ChainContentDrill.setDescription(T("|Defines the text content of the chain dimension points|"));		
		PropString DiameterUnit(1,sArDiameterUnit,"   " + T("|Diameter Units|"));
		DiameterUnit.setDescription(T("|Sets the unit for any text which displays diameter or radius values|"));
		PropString StereotypeOppositeDrill(5,sArNY,"   " + T("|use Stereotype 'OppositeDrill' on opposite Side|"));
		StereotypeOppositeDrill.setDescription(T("|Any Drill on the opposite Side will uses the Stereotype 'OppositeDrill' instead of 'Drill'|"));		
		PropString DrawDrillCircles(6,"","   " + T("|draw Drills as Circles|"));
		DrawDrillCircles.setDescription(T("|Enter|") + " '*;*' " + T("|to draw circles in component or zone colors.|") + " " + 
			T("|A color index will overwrite the default colors|")+","+T("|use|")+"';'"+T("|to separate entries, first entry represents viewing side, second entry opposite side.|") + " " +
			T("|Complete drills will be drawn in main view color.|"));	

		
		PropString AddExtremes(2,sArNY,T("|Additional Dimline Extremes|"));
		AddExtremes.setDescription(T("|Adds an additional dimline with the extreme dimpoints of the entity|"));
		PropString AddAngles(3,sArAddAngle,T("|Add Contour Angles|"));
		AddAngles.setDescription(T("|Adds angular dimensions if not 90°|"));
		PropDouble DimAnglesOffset(1,U(5),T("|Angular Dimension Offset|"));
		DimAnglesOffset.setDescription(T("|Angular Dimension Offset"));	
		PropDouble SegmentToArcLength(0,U(5),T("|Segment to Arc Length|"));
		SegmentToArcLength.setDescription(T("|Straight segments which could describe an Arc can be converted to an Arc|") + " " + T("|Sets the maximum length of segment which will be converted if applicable|"));	
		PropString ExtrProfDimMode(4,sArExtrProfDimMode,T("|Extrusion Profile Dimensioning|"));
		ExtrProfDimMode.setDescription(T("|Specifies how the dimension of an entity which is based on an extrusion profile will be displayed|"));

		PropString StereotypeContour(7,"Contour",T("|Stereotype|") + " " +T("|Contour Dimensioning|"));
		StereotypeContour.setDescription(T("|Specifies the Stereotype for the|") + " "  + T("|Contour Dimensioning|") + " " + T("|Stereotype needs to be set in the Layoutdefinition|") + " " + T("|Enter '---' to suppress dimensions|"));
		PropString StereotypeExtremes(8,"Extremes",T("|Stereotype|") + " " +T("|Extreme Dimensioning|"));
		StereotypeExtremes.setDescription(T("|Specifies the Stereotype for the|") + " "  + T("|Extreme Dimensioning|") + " " + T("|Stereotype needs to be set in the Layoutdefinition|") + " " + T("|Enter '---' to suppress dimensions|"));
		PropString StereotypeBeamcut(9,"Beamcut",T("|Stereotype|") + " "+ T("|Beamcut Dimensioning|"));
		StereotypeBeamcut.setDescription(T("|Specifies the Stereotype for the|") + " "  + T("|Beamcut Dimensioning|") + " " + T("|Stereotype needs to be set in the Layoutdefinition|") + " " + T("|Enter '---' to suppress dimensions|"));
		PropString StereotypeOpening(10,"Opening",T("|Stereotype|") + " " +T("|Opening Dimensioning|"));
		StereotypeOpening.setDescription(T("|Specifies the Stereotype for the|") + " "  + T("|Opening Dimensioning|") + " " + T("|Stereotype needs to be set in the Layoutdefinition|") + " " + T("|Enter '---' to suppress dimensions|"));		
		//PropString NotchDimMode(3,sArNotchDimMode,sCustomMapSettings[3]);// NotchDimMode


	// make sure the offsets are not set to zero when called the first time
		//if(!_Map.hasString(sCustomMapSettings[0]))		_Map.setString(sCustomMapSettings[0],String().formatUnit(U(200),2,0));	
		//if(!_Map.hasString(sCustomMapSettings[2]))		_Map.setString(sCustomMapSettings[2],String().formatUnit(U(800),2,0));
		//if(!_Map.hasString(sCustomMapSettings[3]))		_Map.setString(sCustomMapSettings[3],String().formatUnit(U(1200),2,0));
		if(!_Map.hasString(sCustomMapSettings[4]))		_Map.setString(sCustomMapSettings[4],String().formatUnit(U(5),2,0));
		if(!_Map.hasString(sCustomMapSettings[12]))	_Map.setString(sCustomMapSettings[12],String().formatUnit(U(25),2,0));

	// init the stereotypes with the defaults
		if(!_Map.hasString(sCustomMapSettings[8]))		_Map.setString(sCustomMapSettings[8],"Contour");
		if(!_Map.hasString(sCustomMapSettings[9]))		_Map.setString(sCustomMapSettings[9],"Extremes");
		if(!_Map.hasString(sCustomMapSettings[10]))		_Map.setString(sCustomMapSettings[10],"Beamcut");
		if(!_Map.hasString(sCustomMapSettings[11]))		_Map.setString(sCustomMapSettings[11],"Opening");				
	// find value in _Map, if found, change the property values
	
		ChainContentDrill.set(sArChainContentDrill[_Map.getString(sCustomMapSettings[0]).atoi()]);
		DiameterUnit.set(sArDiameterUnit[_Map.getString(sCustomMapSettings[1]).atoi()]);
		AddExtremes.set(sArNY[_Map.getString(sCustomMapSettings[2]).atoi()]);
		AddAngles.set(sArAddAngle[_Map.getString(sCustomMapSettings[3]).atoi()]);
		SegmentToArcLength.set(_Map.getString(sCustomMapSettings[4]).atof());
		ExtrProfDimMode.set(sArExtrProfDimMode[_Map.getString(sCustomMapSettings[5]).atoi()]);
		StereotypeOppositeDrill.set(sArNY[_Map.getString(sCustomMapSettings[6]).atoi()]);
		DrawDrillCircles.set(_Map.getString(sCustomMapSettings[7]).trimLeft().trimRight());

		StereotypeContour.set(_Map.getString(sCustomMapSettings[8]).trimLeft().trimRight());
		StereotypeExtremes.set(_Map.getString(sCustomMapSettings[9]).trimLeft().trimRight());
		StereotypeBeamcut.set(_Map.getString(sCustomMapSettings[10]).trimLeft().trimRight());
		StereotypeOpening.set(_Map.getString(sCustomMapSettings[11]).trimLeft().trimRight());
		DimAnglesOffset.set(_Map.getString(sCustomMapSettings[12]).atof());
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
													_Map.setString(sCustomMapSettings[6],sArNY.find(StereotypeOppositeDrill));
													_Map.setString(sCustomMapSettings[7],DrawDrillCircles.trimLeft().trimRight());

													_Map.setString(sCustomMapSettings[8],StereotypeContour.trimLeft().trimRight());
													_Map.setString(sCustomMapSettings[9],StereotypeExtremes.trimLeft().trimRight());
													_Map.setString(sCustomMapSettings[10],StereotypeBeamcut.trimLeft().trimRight());
													_Map.setString(sCustomMapSettings[11],StereotypeOpening.trimLeft().trimRight());																					
													_Map.setString(sCustomMapSettings[12],DimAnglesOffset);	
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
	
	Vector3d vNormal=gb.vecZ();

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
		// 5 = Suppress Circle Detection
	if (_bOnDebug)nChainContentDrill =4;
	
	int nDiameterUnit = mapOption.getInt(sCustomMapSettings[1]);
	int bAddExtremes= mapOption.getInt(sCustomMapSettings[2]);
	int nAddAngles= mapOption.getInt(sCustomMapSettings[3]);
	int nExtrProfDimMode= mapOption.getInt(sCustomMapSettings[5]);
	int bStereotypeOppositeDrill= mapOption.getInt(sCustomMapSettings[6]);
	
	int nArDrawCirlcesColor[0];
	{
		String s = mapOption.getString(sCustomMapSettings[7]);

		int nCnt;
		while (s.token(nCnt)!="")
		{
			String sThis = s.token(nCnt).trimLeft().trimRight();
			if (sThis=="*")nArDrawCirlcesColor.append(-1);
			else 	nArDrawCirlcesColor.append(sThis.atoi());
			nCnt++;
		}
	}

	// collect colors
	int bDrawDrillCircles;
	if (nArDrawCirlcesColor.length()>0) bDrawDrillCircles=true;
	
	
	double dSegmentToArcLength= mapOption.getDouble(sCustomMapSettings[4]);
	
	// set the default to 5mm if not specified
	if(!mapOption.hasDouble(sCustomMapSettings[4]))
		dSegmentToArcLength=U(5);

// stereotype definition
	String sStereotypeContour="*";
	String sStereotypeExtremes="*";
	String sStereotypeBeamcut="*";
	String sStereotypeOpening="*";
	sStereotypeContour= mapOption.getString(sCustomMapSettings[8]);
	sStereotypeExtremes=mapOption.getString(sCustomMapSettings[9]);
	sStereotypeBeamcut=mapOption.getString(sCustomMapSettings[10]);
	sStereotypeOpening=mapOption.getString(sCustomMapSettings[11]);

	double dAngleOffset=mapOption.getDouble(sCustomMapSettings[12]);
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
	AnalysedDrill drills[0];
	if (nChainContentDrill!=5)
		drills= AnalysedDrill().filterToolsOfToolType(tools);//,_kADPerpendicular);	
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
	Vector3d vecFreeY[0],vecFreeZ[0];
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
			vecFreeY.append(drills[i].vecFree());		
		}
		else if (drills[i].vecFree().isParallelTo(vArView[1]))
		{
			ptZ.append(drills[i].ptStartExtreme());		
			dDiamZ.append(drills[i].dDiameter());	
			vecFreeZ.append(drills[i].vecFree());			
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
				vecFreeY.swap(j,j+1);	
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
				vecFreeZ.swap(j,j+1);	
			}	
		}	
		
		
// the body
	Body bd = gb.envelopeBody(false,true);	
				
// loop view directions
	Point3d ptDrill[0];
	ptDrill = ptY;

	double dDiam[0];
	dDiam = dDiamY;
	Vector3d vecArFree[0];
	vecArFree = vecFreeY;
	
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
			if (bStereotypeOppositeDrill && vzDimline.isParallelTo(vecArFree[i]) && !vzDimline.isCodirectionalTo(vecArFree[i]))
				sStereotypeDrill = "OppositeDrill";	
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
					if (nChainContentDrill==0 || nChainContentDrill==4)
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
							drRad.setStereotype(sStereotypeDrill);//
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
					else if(nChainContentDrill==3)// || nChainContentDrill==4)
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
					
				// draw any drill in its component or zone color if flagged	
					if (xy==0 && bDrawDrillCircles)
					{
					// get the index of the viewing direction
						int nViewIndex;
						if (vzDimline.isParallelTo(vecArFree[i]) && !vzDimline.isCodirectionalTo(vecArFree[i]) && nArDrawCirlcesColor.length()>1)	
							nViewIndex=1;
						
					// distinguish color by entity type and dependencies
						int nCircleColor;
						Element el = gb.element();
						if (gb.bIsKindOf(Sip()))
						{
							int c;
						// set color by given token
							nCircleColor = nArDrawCirlcesColor[nViewIndex];	
													
						// set color by component
							if (nArDrawCirlcesColor[nViewIndex]==-1)
							{
								Sip sip =(Sip)gb;
								SipStyle style(sip.style());
								SipComponent scAr[] =style.sipComponents(); 
								if (nViewIndex==1) c=scAr.length()-1;
								nCircleColor = scAr[c].dimColor();	
							}

						}
						else if (el.bIsValid() && nArDrawCirlcesColor[nViewIndex]==-1)
						{
							nCircleColor = nArDrawCirlcesColor[nViewIndex];						
						}	
						else if (el.bIsValid())
						{
							nCircleColor = el.zone(gb.myZoneIndex()).color();						
						}	
					
					// debug
						//reportNotice("\nView: " + nViewIndex + ", Color: " + nCircleColor + " Array: " +nArDrawCirlcesColor );	
						
												
					// compose the circle dimrequest	
						PLine plCirc(vzDimline);
						plCirc.createCircle(ptDrill[i],vzDimline,dThisDiameter/2);
						DimRequestPLine dpl(strParentKey, plCirc,nCircleColor);
						dpl.addAllowedView(vzDimline,true);
						addDimRequest(dpl); 
					}	
					
				}	
				// y-dim
				vxDimline = vyView;
				vyDimline = vxDimline.crossProduct(-vzView);				
			}// next xy
		}// next i loop drills

	// set arrays for other view direction
		ptDrill=ptZ;
		dDiam = dDiamZ;
		vecArFree = vecFreeZ;
	}
// loop view directions	
	
// add contour dimensions
	Vector3d vxArView[0],vyArView[0];
	vxArView.append(gb.vecX());	vyArView.append(-gb.vecY());	//Front View
	vxArView.append(gb.vecX());	vyArView.append(gb.vecZ());	//Top View
	vxArView.append(gb.vecZ());	vyArView.append(gb.vecY());	//Left View
	Element el=gb.element();
	
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
			if (v==1)
			{
				plEnvelope.vis(211);
			}
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
					ptCen.vis(3);
					double d0 = plEnvelope.getDistAtPoint(ptCen);			
					if (d0==0)
					{
						 d0 =plEnvelope.length();
					}
					Point3d pt1=plEnvelope.getPointAtDist(d0-dEps);
					pt1.vis(1);
					double d1 = plEnvelope.getDistAtPoint(ptCen);			
					if (d1==plEnvelope.length()) d1 =0;
					Point3d pt2=plEnvelope.getPointAtDist(d1+dEps);	
					pt2.vis(2);

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
					
					
					//Only include accute angles
					if (abs(dAngle-90)<0.5 || abs(dAngle)>90 ||//|| abs(dAngle-180)<0.5 || abs(dAngle-270)<0.5 ||
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
					//int bIsNormal;
					//if (vNormal.isParallelTo(vzView))	bIsNormal = true;
					//if(bIsNormal)
					{
			 			Vector3d vAng = v1+v2; vAng.normalize();
						DimRequestAngular dr(strParentKey, ptCen, pt1, pt2, ptCen + vAng*dAngleOffset); 
						dr.addAllowedView(vzView, TRUE); //vecView
						addDimRequest(dr); // append to shop draw engine collector					
						dr.vis(1);
					}
				}	
			}
		// END optional angular dimension	
	
			/* CONTOUR CODE */
			
			Plane plnZ (ptCen, vzGb);
			
			Plane plnNormal (ptCen, vNormal);
			
			PlaneProfile ppGenBeam (plnNormal);
			
			ppGenBeam=bd.shadowProfile(plnNormal);
			ppGenBeam.shrink(-U(2));
			ppGenBeam.shrink(U(2));
			
			//ppGenBeam.vis(1);
			
			PLine plAllRingsBm[]=ppGenBeam.allRings();
			PLine plOutline;
			
			for (int i=0; i<plAllRingsBm.length(); i++)
			{
				if (plAllRingsBm[i].area()>plOutline.area())
				{
					plOutline=plAllRingsBm[i];
				}
			}
			
			PLine plNewOutline(vNormal);
			Point3d arPtAll[] = plOutline.vertexPoints(false);
			
			Point3d ptArNoClose[0];
			
			if( arPtAll.length() > 2 )
			{
				ptArNoClose.append(arPtAll[0]);
				for (int i=1; i<arPtAll.length(); i++)
				{
					//Analyze initial point with last point and next point
					Point3d pt=arPtAll[i];
					Vector3d v1(arPtAll[i-1] - arPtAll[i]);
					if(v1.length() >U(2)) 
					{
						ptArNoClose.append(arPtAll[i]);
					}
				}
				ptArNoClose.append(ptArNoClose[0]);
			}
			
			
			if( ptArNoClose.length() > 2 )
			{
				plNewOutline.addVertex(ptArNoClose[0]);
				for (int i=1; i<ptArNoClose.length()-1; i++)
				{
					//Analyze initial point with last point and next point
					Point3d pt=ptArNoClose[i];
					Vector3d v1(ptArNoClose[i-1] - ptArNoClose[i]);
					v1.normalize();
					Vector3d v2(ptArNoClose[i] - ptArNoClose[i+1]);
					v2.normalize();
					if( abs(v1.dotProduct(v2)) <0.99 ) 
					{
						plNewOutline.addVertex(ptArNoClose[i]);
					}
				}
			}
			
			plNewOutline.close();
			plNewOutline.vis(1);
			
			Point3d ptAllVertex[]=plNewOutline.vertexPoints(false);
			
			PlaneProfile ppElOutline(plnNormal);
			ppElOutline.joinRing(plNewOutline, false);
			
			Vector3d vAllNormals[0];
			Point3d ptAllToDim[0];
			
			Vector3d vNormalEdges[0];
			LineSeg lsAllEdges[0];
			
			Point3d vExtraDimNormal[0];
			Point3d ptExtraDimA[0];
			Point3d ptExtraDimB[0];
			
			for (int i=0; i<ptAllVertex.length()-1; i++)
			{
				Point3d ptA=ptAllVertex[i];
				//ptA.vis(4);
				Point3d ptB=ptAllVertex[i+1];
				//ptB.vis(3);
				LineSeg ls (ptA, ptB);
				
				Vector3d vSegDir=ptA-ptB;
				vSegDir.normalize();
				Vector3d vSegNormal=vNormal.crossProduct(vSegDir);
				vSegNormal.normalize();
				
				//This point are point on the linesegment but a bit to the inside of them
				Point3d ptA1=ptA-vSegDir*U(2);
				Point3d ptB1=ptB+vSegDir*U(2);
				//ptA1.vis();
				//ptB1.vis();
				
				Line lnA1 (ptA1, vSegNormal);
				Line lnB1 (ptB1, vSegNormal);
				
				LineSeg lsAToFront(ptA+vSegNormal*U(4000), ptA1+vSegNormal*U(0.1));
				LineSeg lsAToBack(ptA-vSegNormal*U(4000), ptA1-vSegNormal*U(0.1));
			
				LineSeg lsBToFront(ptB+vSegNormal*U(4000), ptB1+vSegNormal*U(0.1));
				LineSeg lsBToBack(ptB-vSegNormal*U(4000), ptB1-vSegNormal*U(0.1));
				
				PLine plAToFront(vNormal);
				plAToFront.createRectangle(lsAToFront, vSegNormal, vSegDir);
				
				PLine plAToBack(vNormal);
				plAToBack.createRectangle(lsAToBack, vSegNormal, vSegDir);
				
				PLine plBToFront(vNormal);
				plBToFront.createRectangle(lsBToFront, vSegNormal, vSegDir);
				
				PLine plBToBack(vNormal);
				plBToBack.createRectangle(lsBToBack, vSegNormal, vSegDir);
				
				PlaneProfile ppAToFront(plAToFront);
				PlaneProfile ppAToBack(plAToBack);
				PlaneProfile ppBToFront(plBToFront);
				PlaneProfile ppBToBack(plBToBack);
			
				ppAToFront.intersectWith(ppElOutline);
				ppAToBack.intersectWith(ppElOutline);
				ppBToFront.intersectWith(ppElOutline);
				ppBToBack.intersectWith(ppElOutline);
				
				int nIntFront=0;
				int nIntBack=0;
				int nA=0;
				int nB=0;
				if (ppAToFront.area()/U(1)*U(1)>U(0.1)*U(0.1))//Intersect
				{
					nIntFront++;
					nA++;
				}
				if (ppAToBack.area()/U(1)*U(1)>U(0.1)*U(0.1))//Intersect
				{
					nIntBack++;
					nA++;
				}
				if (ppBToFront.area()/U(1)*U(1)>U(0.1)*U(0.1))//Intersect
				{
					nIntFront++;
					nB++;
				}
				if (ppBToBack.area()/U(1)*U(1)>U(0.1)*U(0.1))//Intersect
				{
					nIntBack++;
					nB++;
				}
				if (nIntFront>nIntBack)
				{
					vSegNormal=-vSegNormal;
				}
				if (nA<2)
				{
					ptAllToDim.append(ptA);
					vAllNormals.append(vSegNormal);
				}
				if (nB<2)
				{
					ptAllToDim.append(ptB);
					vAllNormals.append(vSegNormal);
				}
				
				if (nIntFront+nIntBack>2)
				{
					vExtraDimNormal.append(vSegNormal);
					ptExtraDimA.append(ptA);
					ptExtraDimB.append(ptB);
				}
				
				if ((ptA-ptB).length()>U(2))
				{
					vNormalEdges.append(vSegNormal);
					lsAllEdges.append(ls);
				}
			}
			
			//Collect all the diferent Normals
			Vector3d vNormalGroup[0];
			for (int i=0; i<vAllNormals.length(); i++)
			{
				int nNew=true;
				for (int j=0; j<vNormalGroup.length(); j++)
				{
					if (vAllNormals[i].dotProduct(vNormalGroup[j])>0.99)
					{
						nNew=false;
						break;
					}
				}
				if (nNew)
					vNormalGroup.append(vAllNormals[i]);
			}
			
			Vector3d vViewDir=_XW+_YW;
			//vViewDir.transformBy(ps2ms);
			vViewDir.normalize();
			
			Vector3d vReadView=-_XW+_YW;
			//vReadView.transformBy(ps2ms);
			vReadView.normalize();
			
			String sHandleUsed[0];
			
			Dim dmBeams[0];
			Vector3d vDimBmNormal[0];
			int nCounter[0];
			
			for (int n=0; n<vNormalGroup.length(); n++)
			{
				Vector3d vThisDimNormal=vNormalGroup[n];
				Vector3d vDimDirection=vThisDimNormal.crossProduct(vNormal);
				vDimDirection.normalize();
				
				Vector3d vxText=vDimDirection;
				Vector3d vyText=vThisDimNormal;
				
				int nDeltaTop=false;
				
				if (vViewDir.dotProduct(vxText)<0)
					vxText=-vxText;
			
				if (vReadView.dotProduct(vyText)<0)
				{
					//vyText=-vyText;
					nDeltaTop=true;
				}
				
				//Points of the Contour
				Point3d ptToDim[0];
				Point3d ptAllBaseDim[0];
				for (int j=0; j<vAllNormals.length(); j++)
				{
					if (vAllNormals[j].dotProduct(vThisDimNormal)>0.999)
					{
						ptToDim.append(ptAllToDim[j]);
						ptAllBaseDim.append(ptAllToDim[j]);
					}
				}
				
				//Lineseg on this orientation
				LineSeg lsThisDirection[0];
				for (int j=0; j<vNormalEdges.length(); j++)
				{
					if (vNormalEdges[j].dotProduct(vThisDimNormal)>0.999)
					{
						lsThisDirection.append(lsAllEdges[j]);
						ptAllBaseDim.append(lsAllEdges[j].ptStart());
					}
				}
				
				Point3d ptBaseDim;
				ptAllBaseDim=ptToDim;
				ptAllBaseDim[0].vis();
				Line ln (ptAllBaseDim[0], -vThisDimNormal);
				ptAllBaseDim=ln.orderPoints(ptAllBaseDim);
				ptBaseDim=ptAllBaseDim[0];
				ptBaseDim=ptBaseDim+vThisDimNormal;
				
				vThisDimNormal.vis(_Pt0);
				
				if (lsThisDirection.length()>0)
				{
					Point3d ptDimJoist[0];
					
					if (ptAllBaseDim.length()>1)
					{
						Line lnExt (ptAllBaseDim[0], vDimDirection);
						ptAllBaseDim=lnExt.orderPoints(ptAllBaseDim);
						ptDimJoist.append(ptAllBaseDim[0]);
						ptDimJoist.append(ptAllBaseDim[ptAllBaseDim.length()-1]);
					}
					
					for (int j=0; j<lsThisDirection.length(); j++)
					{
						Beam bmToDim[0];
						
						LineSeg ls=lsThisDirection[j];
						Line lnSegment (ls.ptMid(), vDimDirection);
						LineSeg lsThisEdge (ls.ptStart(), ls.ptEnd()-vThisDimNormal*U(150));
			
						PLine plThisEdge(vNormal);
						plThisEdge.createRectangle(lsThisEdge, vDimDirection, vThisDimNormal);
						PlaneProfile ppThisEdge(plThisEdge);
						ppThisEdge.shrink(-U(2));
						//ppThisEdge.joinRing(plThisEdge, false);
						
						ppThisEdge.vis(2);
						
			
					}
					/*
					if (ptDimJoist.length()>1 && nYesNoBeam)
					{
						DimLine dLine (ptBaseDim, vxText, vyText);
						Dim dim (dLine, ptDimJoist, "<>",  "<>", _kDimDelta, _kDimNone);
						if(nDeltaTop)
						{
							dim.setDeltaOnTop(FALSE);
						} 
						dim.transformBy(ms2ps);
						
						dmBeams.append(dim);
						vDimBmNormal.append(vThisDimNormal);
						nCounter.append(ptDimJoist.length());
						
						//dp.draw(dim);
						ptBaseDim=ptBaseDim+vThisDimNormal*dOffsetBt;
					}
					*/
				}
			
				
				if (ptToDim.length()>1)
				{
					
					Line lnX (ptBaseDim, vDimDirection);
					ptToDim=lnX.projectPoints(ptToDim);
					ptToDim=lnX.orderPoints(ptToDim);
					int bIsNormal;
					//if (nYesNoShape)
					{
						DimLine dLine(ptBaseDim, vxText, vyText);
						Dim dim (dLine, ptToDim, "<>",  "<>", _kDimDelta, _kDimNone);
						if(nDeltaTop)
						{
							dim.setDeltaOnTop(FALSE);
						} 
						
						//ignore if only two points
						if(ptToDim.length()>2)
						{
						
							for(int p=0;p<ptToDim.length();p++)
							{
								if (vNormal.isParallelTo(vzView))	bIsNormal = true;
								if(bIsNormal)
								{
									Point3d pt=ptToDim[p];
									DimRequestPoint dr(strParentKey , pt, vxText, vyText);	
									dr.setStereotype(sStereotypeContour);
									dr.addAllowedView(vzView, TRUE); //vecView
									dr.vis(4); // visualize for debugging 
									//Overall Dimension line
									addDimRequest(dr); // append to shop draw engine collector	
									//dim.transformBy(ms2ps);
									//dp.draw(dim);
								}
							}
						}
						ptBaseDim=ptBaseDim+vThisDimNormal;
					}
					
					//if (nYesNoOverAll)
					{
						if (( ptToDim.length()>2 ) || (ptToDim.length()>1))
						{
							Point3d ptOverAll[0];
							ptOverAll.append(ptToDim[0]);
							ptOverAll.append(ptToDim[ptToDim.length()-1]);
							
							Line lnOverAll(ptBaseDim, vxText);
							ptOverAll=lnOverAll.projectPoints(ptOverAll);
							ptOverAll=lnOverAll.orderPoints(ptOverAll);
							
							DimLine dLineOverAll(ptBaseDim, vxText, vyText);
							Dim dimOverAll (dLineOverAll, ptOverAll, "<>", "<>", _kDimDelta, _kDimNone);
							if(nDeltaTop)
							{
								dimOverAll.setDeltaOnTop(FALSE);
							}
							
							for(int p=0;p<ptOverAll.length();p++)
							{
								if (vNormal.isParallelTo(vzView))	bIsNormal = true;
								if(bIsNormal)
								{
									Point3d pt=ptOverAll[p];
									DimRequestPoint dr(strParentKey , pt, vxText, vyText);	
									dr.setStereotype(sStereotypeExtremes);
									dr.addAllowedView(vzView, TRUE); //vecView
									dr.vis(4); // visualize for debugging 
									//Overall Dimension line
									addDimRequest(dr); // append to shop draw engine collector	
									//dim.transformBy(ms2ps);
									//dp.draw(dim);
								}
							}
							
							ptBaseDim=ptBaseDim+vThisDimNormal;
						}
					}
				}
			}
			for (int n=0; n<vExtraDimNormal.length(); n++)
			{
				Vector3d vThisDimNormal=vExtraDimNormal[n];
				Vector3d vDimDirection=vThisDimNormal.crossProduct(vNormal);
				vDimDirection.normalize();
				
				Vector3d vxText=vDimDirection;
				Vector3d vyText=vThisDimNormal;

				int bIsNormal;
				if (vNormal.isParallelTo(vzView))	bIsNormal = true;
				if(bIsNormal)
				{
					Point3d ptA=ptExtraDimA[n];
					Point3d ptB=ptExtraDimB[n];
					DimRequestLinear dr(strParentKey , ptA, ptB, vyText);	
					//drA.setStereotype(sStereotypeBeamcut);
					dr.setMinimumOffsetFromDimLine(U(10));
					dr.addAllowedView(vzView, TRUE); //vecView
					dr.vis(4); // visualize for debugging 
					//Overall Dimension line
					addDimRequest(dr); // append to shop draw engine collector	
					//dim.transformBy(ms2ps);
					//dp.draw(dim);
					
					//DimRequestPoint drB(strParentKey , ptB, vxText, vyText);	
					//drB.setStereotype(sStereotypeBeamcut);
					//drB.addAllowedView(vzView, TRUE); //vecView
					//drB.vis(4); // visualize for debugging 
					//Overall Dimension line
					//addDimRequest(drB); // append to shop draw engine collector	

				}

			}
			
		
	//====Other Code====
		// STRAIGHT loop x and y view for straight segments
			for (int xy=0;xy<vyArDim.length();xy++)
			{	
				if (xy>1 && e!=0) continue;
				//reportNotice("\n   xy view: " + xy);
				Vector3d vxDimline,vyDimline;
				vyDimline = vyArDim[xy];
				vxDimline = vyDimline.crossProduct(-vzView);
				
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
					
					//if (xy<2 && bAddExtremes && e==0 && sStereotypeExtremes!="---")
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
							dr.setStereotype(sStereotypeExtremes);
							if(p==0)
								dr.setNodeTextCumm("");				
							else
								dr.setNodeTextCumm("<>");// + sTxtPostFix);	
								
							dr.addAllowedView(vzView, TRUE); //vecView
							//dr.vis(xy); // visualize for debugging 
							//Overall Dimension line
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
	
	
				/*
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
					// force vertical dimline on the left, vec needs to be flipped	
						int nFlipSort=1;
						if (xy==1 || xy==3)nFlipSort*=-1;
						ptDim = Line(_Pt0,nFlipSort*vxDimline).orderPoints(ptDim);
						
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
								if (sStereotypeBeamcut=="---") {continue;}
								if (ptNext.length()>1)	pt=ptNext[1];
								dr = DimRequestPoint(strParentKey , pt, vxDimline, -vyDimline);	
								dr.setStereotype(sStereotypeBeamcut);
							}
						// the dimrequest of contour points or openings
							else
							{
								dr = DimRequestPoint(strParentKey , pt, vxDimline, vyDimline);	
								if (e==0)
								{
									if (sStereotypeContour=="---") {continue;}
									dr.setStereotype(sStereotypeContour);
								}
								else
								{
									if (sStereotypeOpening=="---") {continue;}
									dr.setStereotype(sStereotypeOpening);
								}							
							}
							
							if(p==0)
								dr.setNodeTextCumm(" ");				
							else
								dr.setNodeTextCumm("<>");// + sTxtPostFix);	
								
							dr.addAllowedView(vzView, TRUE); //vecView
							//dr.vis(xy); // visualize for debugging 
							//if (bHasIntersection)
							//All other dimensions
							addDimRequest(dr); // append to shop draw engine collector		
						}
						
						
					}
					*/
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

			if ((beamcuts[i].toolSubType() == _kABCSimpleHousing || beamcuts[i].toolSubType() == _kABCDado) && sStereotypeBeamcut!="---")
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
						dr.setStereotype(sStereotypeBeamcut);
							
						if(p==0)
							dr.setNodeTextCumm(" ");				
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
7)&H4?I45JU2-DW]W]?Y%TZ<'JOQ/_]G6
`








#End