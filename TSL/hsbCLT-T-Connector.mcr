#Version 8
#BeginDescription
version  value="1.0" date="16sep14" author="th@hsbCAD.de"
initial

This TSL creates a T-shaped connector for CLT panels.
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
/// <summary>
/// This TSL creates a T-shaped connector for CLT panels.
/// </summary>

/// <insert Lang=en>
/// Select one panel and an insertion point at an edge to attach this tsl. 
/// Optional one can select a second panel (not parallel) to stretch corresponding to this panel
/// </insert>

/// History
///<version  value="1.0" date="16sep14" author="th@hsbCAD.de"> initial </version>



// basics and props
	U(1,"mm");
	double dEps = U(0.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	
// Geometry
	String sCat1 = T("|Geometry|");
	String sLengthName= "   "+T("|Length|");
	PropDouble dLength (nDoubleIndex++, U(300),sLengthName);
	dLength.setCategory(sCat1);
	
	String sWidthName= "   "+T("|Width|");
	PropDouble dWidth (nDoubleIndex++, U(100),sWidthName);
	dWidth.setCategory(sCat1);
	
	String sHeightName= "   "+T("|Height|");
	PropDouble dHeight (nDoubleIndex++, U(215),sHeightName);
	dHeight.setCategory(sCat1);

	String sThicknessName= "   "+T("|Thickness|");
	PropDouble dThickness (nDoubleIndex++, U(10),sThicknessName);
	dThickness.setCategory(sCat1);	

// location
	String sCat2 = T("|Location|");
	String sEdgeOffsetName= "   "+T("|Edge Offset|");
	PropDouble dEdgeOffset (nDoubleIndex++, U(40),sEdgeOffsetName);
	dEdgeOffset.setCategory(sCat2);

	String sCenterOffsetName= "   "+T("|Center Offset|");
	PropDouble dCenterOffset (nDoubleIndex++, U(0),sCenterOffsetName);
	dCenterOffset.setCategory(sCat2);

// Slot
	String sCat3 = T("|Slot|");
	String sGapXName= "   "+T("|Gap|") + " X";
	PropDouble dGapX(nDoubleIndex++, U(10),sGapXName);
	dGapX.setCategory(sCat3);

	String sGapYName= "   "+T("|Gap|") + " Y";
	PropDouble dGapY(nDoubleIndex++, U(1),sGapYName);
	dGapY.setCategory(sCat3);
	
	String sGapZName= "   "+T("|Gap|") + " Z";
	PropDouble dGapZ(nDoubleIndex++, U(1),sGapZName);
	dGapZ.setCategory(sCat3);
	
// drill pattern
	String sCat4 = T("|Drill Pattern|");
	String sDiameterName="   "+ T("|Diameter|");
	PropDouble dDiameter (nDoubleIndex++, U(14),sDiameterName);
	dDiameter.setCategory(sCat4);

	/*String sFastenerStyleName=T("|Fastener Assembly|");	
	String sFadStyles[0];
	sFadStyles.append(T("|-not selected-|"));
	sFadStyles.append(FastenerAssemblyDef().getAllEntryNames());
	PropString sFadStyle(nStringIndex++,sFadStyles, sFastenerStyleName);
	sFadStyle.setDescription(T("|Specifies the style of the fasteners to be inserted.|") + " " + 
		T("|If no fastener style is selected the diameter is specified by diameter property.|"));
	sFadStyle.setCategory(sCat4);
	*/
	
	String sRowName="   "+ T("|Rows|");
	PropInt nRows(nIntIndex++, 5,sRowName);
	nRows.setCategory(sCat4);

	String sRowOffsetName="   "+ T("|Offset Row|");
	PropDouble dRowOffset (nDoubleIndex++, U(42),sRowOffsetName);
	dRowOffset.setCategory(sCat4);

	String sColumnName="   "+ T("|Columns|");
	PropInt nColumns(nIntIndex++, 5,sColumnName);
	nColumns.setCategory(sCat4);

	String sColumnOffsetName="   "+ T("|Offset Column|");
	PropDouble dColumnOffset (nDoubleIndex++, U(42),sColumnOffsetName);
	dColumnOffset.setCategory(sCat4);

	String sPatternModeName= "   "+T("|Pattern Mode|");
	String sPatternModes[] = {T("|1 Pattern|"), T("|2 Patterns|")};
	PropString sPatternMode(nStringIndex++, sPatternModes,sPatternModeName);
	sPatternMode.setCategory(sCat4);
	
	String sPatternOffsetXName="   "+ T("|Pattern Offset|") + " X";
	PropDouble dPatternOffsetX (nDoubleIndex++, U(0),sPatternOffsetXName);
	dPatternOffsetX.setCategory(sCat4);

	String sPatternOffsetYName="   "+ T("|Pattern Offset|") + " Y";
	PropDouble dPatternOffsetY (nDoubleIndex++, U(0),sPatternOffsetYName);
	dPatternOffsetY.setCategory(sCat4);

		
// on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
	
	// set properties from catalog
		if (_kExecuteKey!="")
			setPropValuesFromCatalog(_kExecuteKey);			
		else
			showDialog();
		
	// get main CLT
		_Sip.append(getSip(T("|Select male CLT Panel|")));


		PrEntity ssE(T("|Select female CLT Panel|") + " (" + T("|optional|")+")", Sip());
		Entity ents[0];
		if (ssE.go()) 
			ents= ssE.set();
	
	// collect a panel which is not parallel and not main sip
		Sip sips[0];
		for (int e =0;e<ents.length();e++)
		{
			Sip sip = (Sip)ents[e];		
			if (_Sip.find(sip)<0 && !sip.vecZ().isParallelTo(_Sip[0].vecZ()))
			{
				_Sip.append(sip);
				break;
			}
		}

		_Pt0 =getPoint();	
		return;
	}
// end on insert	


// validate sset
	if (_Sip.length()<1)
	{
		eraseInstance();
		return;
	}	
	setEraseAndCopyWithBeams(_kBeam0);

// main panel
	Sip sip0 = _Sip[0];
	Vector3d vecX, vecY, vecZ;
	vecZ = sip0.vecZ();
	Point3d ptCen = sip0.ptCenSolid();
	assignToGroups(sip0,'I');
	double dH = sip0.dH();

// secondary (optional)
	Sip sip1;
// collect attached tools if in potential stretching mode	
	TslInst tsls[0];
	int nNumEdges[0]; // collector of edges which are stretched by other instances
	if (_Sip.length()>1)	
	{
		sip1 = _Sip[1];
		
	// collect tools
		Entity entTools[] = sip0.eToolsConnected();
		for (int e=0;e<entTools.length();e++)
		{
			TslInst tsl = (TslInst)entTools[e];
			if (tsl.scriptName()==scriptName() && tsl.bIsValid() && tsl!=_ThisInst)
			{
				tsls.append(tsl);	
				Map map = tsl.map();
				if (map.hasInt("numEdge"))
					nNumEdges.append(map.getInt("numEdge"));
			}
		}	
		//reportMessage("\ntools = "+tsls.length()+ " " + nNumEdges);
	}

// get fastener and its diameter
	double dThisDiam = dDiameter;
	/*
	if (sFadStyles.find(sFadStyle)>0)
	{
		dDiameter.setReadOnly(true);
		FastenerAssemblyDef fadef(sFadStyle);
		FastenerListComponent flc = fadef.listComponent();
		FastenerComponentData fcd = flc.componentData();
		dThisDiam = fcd.mainDiameter();
	}
	*/
	
// ints
	int nPatternMode=sPatternModes.find(sPatternMode,0);
	
// get male sip edges
	SipEdge edges[] = sip0.sipEdges();

// get relevant edge	index
	int nNumEdge=-1;
	double dMin=sip0.solidLength()+sip0.solidWidth();
	for (int i=0;i<edges.length();i++)
	{
		PLine plEdge=edges[i].plEdge();
		Vector3d vecNormal = edges[i].vecNormal();
		vecNormal.vis(edges[i].ptMid(),3);
		double dDist= abs(vecNormal.dotProduct(_Pt0-edges[i].ptMid()));
		if (dDist<dMin)
		{
			nNumEdge=i;
			dMin = dDist;
		}
	}
	
// validate relevant edge
	if (nNumEdge<0)
	{
		reportMessage("\n" + scriptName() + " " + T("|encountered an unexpected error.|") + T("|Please contact your local hsbCAD support.|"));
		eraseInstance();
		return;	
	}
	SipEdge edge=edges[nNumEdge];

// get projected reference pline
	PLine plRef = edge.plEdge();
	vecY = edge.vecNormal();
	vecX = vecY.crossProduct(vecZ);
	vecX.vis(_Pt0,1);vecY.vis(_Pt0,3);vecZ.vis(_Pt0,150);
	
// stretch edge if in valid stretch mode
	if (sip1.bIsValid() && sip1.vecZ().isParallelTo(vecY) && vecY.dotProduct(sip1.ptCenSolid()-ptCen)>dEps && nNumEdges.find(nNumEdge)<0)
	{
		Point3d ptX = Line(_Pt0,vecY).intersect(Plane(sip1.ptCenSolid(),vecY),-.5*sip1.dH());
		ptX.vis(1);
		plRef.transformBy(vecY*vecY.dotProduct(ptX-edge.ptMid()));	
		if (abs(vecY.dotProduct(ptX-_Pt0))>dEps)
			sip0.stretchEdgeTo(edge.ptMid(),Plane(ptX-vecY*dEdgeOffset,vecY));
		_Map.setInt("numEdge", nNumEdge);

	}	
	else
	{
		_Map.removeAt("numEdge",true);		
		plRef.transformBy(vecY*dEdgeOffset);
		plRef.vis(1);
	}		
	plRef.transformBy(vecZ*(vecZ.dotProduct(ptCen-edge.ptMid())+dCenterOffset));
	plRef.vis(1);
	_Pt0 = plRef.closestPointTo(_Pt0);





	
	CoordSys cs(_Pt0,vecX,vecY,vecZ);
	
// declare slot
	double dX = dLength+2*dGapX;
	double dY = dHeight+dGapY;
	double dZ = dThickness+2*dGapZ;
	
	if (dX>dEps && dY>dEps && dZ>dEps)
	{
		Slot slot(_Pt0, vecX, -vecZ, -vecY, dX, dZ, dY, 0,0,1);
		//slot.cuttingBody().vis(2);
		sip0.addTool(slot);
	}

// the solid
	Body bd(_Pt0, vecX, vecY, vecZ, dLength, dHeight, dThickness, 0,-1,0);
	bd.addPart(Body(_Pt0, vecX, vecY, vecZ, dLength, dThickness, dWidth, 0,-1,0));

// drill pattern
	if (dThisDiam>0)
	{
		Point3d ptPatternBaseRef = _Pt0-vecY*.5*dHeight; ptPatternBaseRef .vis(2);
	// auto correct pattern offset if duplex and too small
		double dMinPatternOffsetX=((nColumns-1)/2+.5)*dColumnOffset;
		if (nPatternMode==1 && dPatternOffsetX<dMinPatternOffsetX)
		{
			dPatternOffsetX.set(dMinPatternOffsetX);
		}

		//_ThisInst.resetFastenerGuidelines();	
			
				
	// loop patterns
		double dThixX = dPatternOffsetX-(nColumns-1)*dColumnOffset/2;
		double dThixY = -dPatternOffsetY-(nRows-1)*dRowOffset/2;//(nRows-1)/2*
		int nDir=1;
		for (int p=0;p<(nPatternMode+1);p++)
		{
			Point3d ptPatternRef=ptPatternBaseRef+vecX*nDir*dThixX+vecY*dThixY;
			ptPatternRef.vis(6);
			
		// distribute rows

			for (int j=0;j<nColumns;j++)
			{
				Point3d ptRow = ptPatternRef+nDir*vecX*j*dColumnOffset ;
				int n= nRows;
			// transform and reduce rows for diagonal pattern
			//	if(j%2==1 && nPattern==1)
			//	{
			//		ptRow.transformBy(vx*dAlternateOffset);
			//		n-=1;
			//	}
				for (int i=0;i<n;i++)
				{
					Point3d ptDr = ptRow +vecY*i*dRowOffset-vecZ*dCenterOffset;
					Drill dr(ptDr+vecZ*dH, ptDr-vecZ*dH, dThisDiam/2);
					//dr.cuttingBody().vis(2);
					sip0.addTool(dr);
					bd.addTool(dr);
/*
					if (sFadStyles.find(sFadStyle)>0)
					{
					// fastener assembly guideline
						FastenerGuideline fg(ptDr+vecZ*.5*dH, ptDr-vecZ*.5*dH,dThisDiam/2);		
						_ThisInst.addFastenerGuideline(fg);
						
					// add FA if style selected
						FastenerAssemblyEnt faeNew;
						faeNew.dbCreate(sFadStyle, cs);
						// also anchor the new fastener to me.
						faeNew.anchorTo(_ThisInst,ptDr,dH);				
						//ptDr.vis(2);
					}
*/					

				}	
			}			

			nDir*=-1;
		}// next p pattern	
		
		
	}// END IF drill pattern

// Display and draw
	Display dp(252);
	dp.draw(bd);	
	
	
	
	
#End
#BeginThumbnail
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
&L*KLD?_9
`

#End