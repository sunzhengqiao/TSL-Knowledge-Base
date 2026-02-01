#Version 8
#BeginDescription
version value="1.5" date="19feb2018" author="thorsten.huck@hsbcad.com"
new shape 'explicit radius' and multiple assignment added
#End
#Type E
#NumBeamsReq 1
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 5
#KeyWords 
#BeginContents
/// <History>//region
///<version value="1.5" date="19feb2018" author="thorsten.huck@hsbcad.com"> new shape 'explicit radius' and multiple assignment added </version>
///<version  value="1.4" date="24Sep2017" author="thorsten.huck@hsbcad.com"> new property alignment added </version>
///<version  value="1.3" date="25apr2016" author="thorsten.huck@hsbcad.com"> Quantity and Interdistance dependencies added </version>
///<version  value="1.2" date="22apr2016" author="thorsten.huck@hsbcad.com"> properties categorized, insertion supports distribution and multiple insertion </version>
///<version  value="1.1" date="21mar2012" author="th@hsbCAD.de"> bugfix</version>
///<version  value="1.0" date="22feb2012" author="th@hsbCAD.de"> initial </version>
/// </History>

/// <summary Lang=de>
/// Dieses TSL erzeugt ein Langloch in einem Stab.
/// </summary>

/// <summary Lang=en>
/// This tsl creates a slotted hole in a beam.
/// </summary>

/// History


/// <insert Lang=en>
/// Select entity, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates a slotted hole / mortise in a set of beams
/// </summary>//endregion


// constants //region
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));	
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	//endregion



// geometry	
	category = T("|Geometry|");

	String sLengthName=T("(A)   |Length|");	
	PropDouble dLength(nDoubleIndex++, U(80,2), sLengthName);	
	dLength.setDescription(T("|Defines the Length|"));
	dLength.setCategory(category);	
		
	String sWidthName=T("(B)   |Width|");	
	PropDouble dWidth(nDoubleIndex++, U(20,1), sWidthName);	
	dWidth.setDescription(T("|Defines the Width|"));
	dWidth.setCategory(category);

	String sDepthName=T("(C)   |Depth|");	
	PropDouble dDepth(nDoubleIndex++, U(0), sDepthName);	
	dDepth.setDescription(T("|Defines the Depth|") + T(", |0 = complete through|"));
	dDepth.setCategory(category);
	
	String sShapeName=T("(F)   |Shape|");	
	int nShapes[]={_kNotRound,_kRound,_kRounded, _kExplicitRadius};
	String sShapes[] = {T("|Rectangular|"),T("|Round|"),T("|Rounded|"), T("|Explicit Radius|")};
	PropString sShape(nStringIndex++, sShapes, sShapeName);	
	sShape.setDescription(T("|Defines the Shape|"));
	sShape.setCategory(category);
	

// alignment
	String sAlignmentCategory = T("|Alignment|");
	category = sAlignmentCategory;
	String sOffsetName=T("(D)  |Offset from Axis|");		
	PropDouble dOffset(nDoubleIndex++, U(0), sOffsetName);	
	dOffset.setDescription(T("|Defines the axis offset|"));
	dOffset.setCategory(category);
	
	String sAngleName=T("(E)   |Angle|");	
	PropDouble dAngle(nDoubleIndex++, 0, sAngleName, _kAngle);	
	dAngle.setDescription(T("|Defines the Angle|"));
	dAngle.setCategory(category);

	String sAlignmentName=T("(J)  |Alignment|");	
	String sAlignmentInserts[] ={T("|UCS|"), T("|Perpendicular to UCS|")};
	String sAlignments[] ={T("|unchanged|"), T("|change|")};
	
	PropString sAlignment(nStringIndex++, (_bOnInsert?sAlignmentInserts:sAlignments), sAlignmentName);	
	sAlignment.setDescription(T("|Defines the Alignment|"));
	sAlignment.setCategory(sAlignmentCategory);	
		
		
// geometry	
	category = T("|Geometry|");
	String sRadiusName=T("(R)   |Radius|");	
	PropDouble dRadius(nDoubleIndex++, U(0), sRadiusName);	
	dRadius.setDescription(T("|Defines the explicit radius|"));
	dRadius.setCategory(category);


// distribution
	category = T("|Distribution|");

	String sInterdistanceName=T("(G)  |Interdistance|");	
	PropDouble dInterdistance(nDoubleIndex++, U(0), sInterdistanceName);	
	dInterdistance.setDescription(T("|Defines the Interdistance|")+ " " + T("|0 = single tool|"));
	dInterdistance.setCategory(category);

	String sDistributionModes[] = {T("|Fixed|"),T("|Even|")};
	String sDistributionModeName=T("(H)  |Distribution Mode|");
	PropString sDistributionMode(nStringIndex++, sDistributionModes, sDistributionModeName);	
	sDistributionMode.setDescription(T("|Defines the Distribution Mode|"));
	sDistributionMode.setCategory(category);

	String sQtyName=T("(I)  |Quantity|");
	PropInt nQty(nIntIndex++, 1, sQtyName);	
	nQty.setDescription(T("|Defines the quantity|") + " " + T("|0 = by grip points|"));	
	nQty.setCategory(category);
	
	
// bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		
	// prompt for entities
		Beam beams[0];
		PrEntity ssE(T("|Select beam(s)|"), Beam());
	  	if (ssE.go())
			beams.append(ssE.beamSet());

		if (beams.length()<1)
		{ 
			eraseInstance();
			return;
		}


	// silent/dialog
		String sKey = _kExecuteKey;
		sKey.makeUpper();
		if (sKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			for(int i=0;i<sEntries.length();i++)
				sEntries[i] = sEntries[i].makeUpper();	
			if (sEntries.find(sKey)>-1)
				setPropValuesFromCatalog(sKey);
			else
				setPropValuesFromCatalog(sLastInserted);					
		}	
		else	
			showDialog();

	// validate geometry
		if (dLength<dEps || dWidth<dEps)
		{ 
			reportMessage("\n"+ scriptName() + ": "+T("|Invalid geometry.| ")+T("|Tool will be deleted.|"));
			eraseInstance();
			return;		
		}


	// insert UCS
		int nAlignment = sAlignmentInserts.find(sAlignment, 0);
		Vector3d vecXTsl =_XU;
		Vector3d vecYTsl =_YU;

	// prepare tsl cloning
		TslInst tslNew;
		GenBeam gbsTsl[1];// = {};
		Entity entsTsl[] = {};
		Point3d ptsTsl[] = {};
		int nProps[]={nQty};
		double dProps[]={dWidth,dLength, dDepth, dOffset, dAngle, dRadius,dInterdistance};
		String sProps[]={sShape,sAlignments[0], sDistributionMode};
		Map mapTsl;	
		String sScriptname = scriptName();


	// request distriburtion start/end if selected
		String sMsg = TN("|Pick point|");	
		int bDistribute = dInterdistance>dWidth;
		if (bDistribute)
		{
			sMsg = TN("|Pick first point of distribution along beam axis.|");
		}

	// keep on prompting until user breaks
		while (1)
		{
			ptsTsl.setLength(0);
		// get first point	
			Point3d pt1;			
			PrPoint ssP(sMsg);			
			if (ssP.go()==_kOk) 
				pt1=ssP.value();
			else 
				break; // breaking while
			
				
		// get optional second point	
			Point3d ptsGrip[0];
			if (bDistribute)
			{
				PrPoint ssP2 (TN("|Pick second point|") + " " + T("|<Enter> to insert a single tool|") ,pt1);
				if (ssP2.go()==_kOk) 
					ptsGrip.append(ssP2.value());
	
			// make the distribution adjustable from both sides		
				if (ptsGrip.length()>0)
				{
					ptsGrip.append(pt1); 
					pt1.setToAverage(ptsGrip); // this is _Pt0
				}					
			}
			ptsTsl.append(pt1);
			ptsTsl.append(ptsGrip);

			for (int i=0;i<beams.length();i++) 
			{ 
				Beam& bm = beams[i];
				vecXTsl = bm.vecX();
				vecYTsl = nAlignment==0?bm.vecY():bm.vecZ();
				gbsTsl[0]= bm; 
				tslNew.dbCreate(scriptName(), vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
					nProps, dProps, sProps,_kModelSpace, mapTsl);
			}

		}// end while




		eraseInstance();
		return;
	}	
// end on insert	__________________


// alignment
	int nAlignment = sAlignments.find(sAlignment, 0);
	
// Trigger Change
	String sTriggerChange = T("|Change Face|");
	addRecalcTrigger(_kContext, sTriggerChange);
	int bChangeFace=_Map.getInt("changeFace");
	int bChangeByProperty = _kNameLastChangedProp == sAlignmentName && nAlignment == 1;
	if (bChangeByProperty || (_bOnRecalc && (_kExecuteKey==sTriggerChange || _kExecuteKey==sDoubleClick)))
	{
		bChangeFace = bChangeFace ? false : true;
		_Map.setInt("changeFace",bChangeFace);
		
		if (bChangeByProperty)sAlignment.set(sAlignments[0]);
		setExecutionLoops(2);
		return;
	}	
	
// standards
	Beam bm = _Beam[0];
	Vector3d vecX = _XE;
	Vector3d vecY = (bChangeFace?_ZE:_YE);
	Vector3d vecZ = (bChangeFace?-_YE:_ZE);
	Vector3d vecXBm = vecX;
	vecX.vis(_Pt0, 1);
	vecY.vis(_Pt0, 3);
	vecZ.vis(_Pt0, 150);


// assigning
	assignToGroups(bm, 'T');	
	_ThisInst.setDrawOrderToFront(true);
	
// rotation
	if (dAngle !=0)
	{
		CoordSys csRot;
		csRot.setToRotation(dAngle,vecZ,_Pt0 );
		vecX.transformBy(csRot);
		vecY.transformBy(csRot);
	}	
	
// ref point
	Point3d ptRef = _Pt0 - .5*vecZ* bm.dD(vecZ)+vecY*dOffset;
	
// ints and doubles
	int nShape = nShapes[sShapes.find(sShape,0)];
	int nDistributionMode = sDistributionModes.find(sDistributionMode,0);
			
	double dThisDepth = dDepth;
	if (dThisDepth <=0)	dThisDepth = bm.dD(vecZ);	



	


// add grips if not present yet
	if (_PtG.length()<2 && (dInterdistance>dEps))
	{ 
		_PtG.append(_Pt0 - vecXBm * .5 * dInterdistance);
		_PtG.append(_Pt0 + vecXBm * .5 * dInterdistance);
		
	}

// relocate grips and reset start		
	for(int i=0;i<_PtG.length();i++)
		_PtG[i].transformBy(_YU*_YU.dotProduct(_Pt0 -_PtG[i])+_ZU*_ZU.dotProduct(_Pt0 -_PtG[i]));


// distance between grips if any
	double dDist;
	if (_PtG.length()>1)
	{ 
		dDist = abs(vecXBm.dotProduct(_PtG[0] - _PtG[1]));
	}



// control properties on certain events
	String sEvents[] = {sInterdistanceName, sDistributionModeName, sQtyName, "_PtG0", "_Pt0", "_PtG1"};
	int nEvent = sEvents.find(_kNameLastChangedProp);
	if (_bOnDbCreated)
	{
		if(dInterdistance<=0)nEvent =0;
		else if(nQty<=0)nEvent =2;
		else if(nDistributionMode==1)nEvent =1;
	} 
	double dStep = dInterdistance;	

// fix	
	int bUpdate;
	if (nEvent == 3 || nEvent==5)	
	{
		_Pt0.setToAverage(_PtG);	
	}
	if (nDistributionMode==0 && dInterdistance>0)
	{
		if (nQty<=0 || nEvent==0 || nEvent == 3 || nEvent==5)
		{
			int n = dDist/dInterdistance+1;
			nQty.set(n);
			bUpdate=true;
		}
	// case distrMode || qty			
		else if (nEvent==1 || nEvent==2)
		{
			_PtG[0]=_PtG[1]+vecXBm*dInterdistance*(nQty-1);
			//ptEnd = _PtG[0];
			_Pt0.setToAverage(_PtG);	
			bUpdate=true;	
		}	
	}
// even
	else if (nDistributionMode==1)
	{
		if (dInterdistance>0 && (nQty<=0  || nEvent == 3 || nEvent==5 || nEvent==0))
		{
			int n = dDist/dInterdistance+1.99;
			nQty.set(n);	
			dStep = dDist/(nQty-1);
			dInterdistance.set(dStep);
			bUpdate=true;
		}		
	// distrMode or qty	
		else if ((nEvent==1 ||nEvent ==2) && nQty>1)
		{
			dStep = dDist/(nQty-1);
			//if (nEvent==2) 
			dInterdistance.set(dStep);
			reportMessage("\n" + scriptName() + ": " +T("|Interdistance|") + " " + T("|adjusted to|") + " " + dInterdistance);
			bUpdate=true;
		}
					
	}

// force recalc	
	if (bUpdate)
		_ThisInst.transformBy(Vector3d(0,0,0));


// collect locations
	Point3d ptsLoc[0];
	if (dDist<dEps ||nQty==1)
		ptsLoc.append(ptRef);
	else
	{ 
		Point3d ptLoc = ptRef - vecXBm * .5 * dDist;
		for (int i=0;i<nQty;i++) 
		{ 
			ptsLoc.append(ptLoc);
			ptLoc.transformBy(vecXBm * dStep);
			 
		}
		
	}
	
	
// display
	Display dp(_ThisInst.color());
	
// add tools	
	for (int i=0;i<ptsLoc.length();i++) 
	{
		Point3d& ptLoc = ptsLoc[i];
		ptLoc.vis(i);


	// declare mortise
		Mortise ms(ptLoc, vecX, vecY,vecZ, dLength, dWidth, dThisDepth*2 , 0,0,0);
		ms.setEndType(_kFemaleSide);
		ms.setRoundType(nShape);
		if (nShape==_kExplicitRadius)
			ms.setExplicitRadius(dRadius);
		else
		{ 
			dRadius.set(0);
			//dRadius.setReadOnly(true);
		}
		bm.addTool(ms);	


	
		Body bd = ms.cuttingBody();
		PlaneProfile pp = ms.cuttingBody().shadowProfile(Plane(ptRef, vecZ));
		dp.draw(pp);
		pp.transformBy(vecZ * dThisDepth);
		dp.draw(pp);

	}


	


	
	
#End
#BeginThumbnail
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
(>:W***`/_]F>
`

#End