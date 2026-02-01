#Version 8
#BeginDescription
#Versions
Version 1.0 11.05.2022 HSB-15220 initial version , Author Thorsten Huck
Version 1.6 10.05.2022 HSB-15221 supports beam/panel connections HSB-15028 new keyhole options , Author Thorsten Huck

This TSL creates dove tail connections in various alignments
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
// 1.0 11.05.2022 HSB-15220 initial version , Author Thorsten Huck

/// <insert Lang=en>
/// Select male beams, then select female beams or panels
/// </insert>

// <summary Lang=en>
// This tsl creates mortise or house connections between 2 beams or between a beam and a panel
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbTenon")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Flip Direction|") (_TM "|Select tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Join|") (_TM "|Select tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Set horizontal alignment|") (_TM "|Select tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Set plump alignment|") (_TM "|Select tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Set vertical alignment|") (_TM "|Select tool|"))) TSLCONTENT
//endregion



//region Part #1
		
//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	// read a potential mapObject defined by hsbDebugController
	{ 
		MapObject mo("hsbTSLDev" ,"hsbTSLDebugController");
		if (mo.bIsValid()){Map m = mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug = true;	break;}}
		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());		
	}
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
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
	int orange = rgb(242,103,34);
	int red = rgb(205,32,39);
	int purple = rgb(47,39,143);
	int petrol = rgb(16,86,137);
	int green = rgb(19,155,72);	

	Vector3d vecXView = getViewDirection(0);
	Vector3d vecYView = getViewDirection(1);
	Vector3d vecZView = getViewDirection(2);
	double dViewHeight = getViewHeight();	
//endregion 	
	
	String kPropValues = "PropValues";
	
	String tTConnection = T("|T-Connection|"), tEnd2EndConnection = T("|End-End|");//

//end Constants//endregion

//region Properties
category = T("|Connection|");
	String sConnections[] = {tTConnection,  tEnd2EndConnection};// 
	String sConnectionName=T("|Connection|");	
	PropString sConnection(nStringIndex++, sConnections, sConnectionName);	
	sConnection.setDescription(T("|Defines the connection type|"));
	sConnection.setCategory(category);
	int nConnection = sConnections.find(sConnection,0);
	sConnection.setReadOnly((_bOnInsert || bDebug) ? false: _kHidden);
	
	
category = T("|Tool|");
	String tMortise = T("|Mortise|");
	String tMortiseNotRound = tMortise + T(", |not round|");
	String tMortiseRound = tMortise + T(", |round|");
	String tMortiseRounded = tMortise + T(", |rounded|");
	String tMortiseExplicit = tMortise + T(", |explicit radius|");
	
	String tHouse = T("|Housing|");
	String tHouseNotRound = tHouse + T(", |not round|");
	String tHouseRound = tHouse + T(", |round|");
	String tHouseRounded = tHouse + T(", |rounded|");
	String tHouseRelief = tHouse + T(", |relief cut|");
	String tHouseSmallRelief = tHouse + T(", |small relief cut|");	
	
	String sTypeName=T("|Type|");	
	String sTypes[] = { tMortiseNotRound,tMortiseRound,tMortiseRounded,tMortiseExplicit,tHouseNotRound,tHouseRounded,tHouseRelief,tHouseSmallRelief};
	PropString sType(nStringIndex++, sTypes, sTypeName);	
	sType.setDescription(T("|Defines the Type|"));
	sType.setCategory(category);


	String sYOffsetAName=T("|Offset Length| A");	
	PropDouble dYOffsetA(nDoubleIndex++, U(0), sYOffsetAName);	
	dYOffsetA.setDescription(T("|Defines the offset in length (positive direction)|"));
	dYOffsetA.setCategory(category);

	String sYOffsetBName=T("|Offset Length| B");
	PropDouble dYOffsetB(nDoubleIndex++, U(0), sYOffsetBName);	
	dYOffsetB.setDescription(T("|Defines the tolerance in length (negative direction)|"));
	dYOffsetB.setCategory(category);


	String sXWidthName=T("|Width|");	
	PropDouble dXWidth(nDoubleIndex++, U(45), sXWidthName,_kLength);	
	dXWidth.setDescription(T("|Defines the XWidth|"));
	dXWidth.setCategory(category);
	
	String sZDepthName=T("|Depth|");	
	PropDouble dZDepth(nDoubleIndex++, U(28), sZDepthName,_kLength);	
	dZDepth.setDescription(T("|Defines the ZDepth|"));
	dZDepth.setCategory(category);	
	
	String sExplicitRadiusName=T("|Explicit Radius|");	
	PropDouble dExplicitRadius(nDoubleIndex++, U(0), sExplicitRadiusName);	
	dExplicitRadius.setDescription(T("|Defines the explicit radius (Mortise only)|"));
	dExplicitRadius.setCategory(category);

category = T("|Tolerances|");	
	String sGapLengthName=T("|Length|");	
	PropDouble dGapLength(nDoubleIndex++, U(0), sGapLengthName);	
	dGapLength.setDescription(T("|Defines the offset in length (positive direction)|"));
	dGapLength.setCategory(category);
	
	String sGapWidthName=T("|Width|");	
	PropDouble dGapWidth(nDoubleIndex++, U(0), sGapWidthName);	
	dGapWidth.setDescription(T("|Defines the tolerance in width|"));
	dGapWidth.setCategory(category);

	String sGapDepthName=T("|Depth|");	
	PropDouble dGapDepth(nDoubleIndex++, U(0), sGapDepthName);	
	dGapDepth.setDescription(T("|Defines the tolenace in depth|"));
	dGapDepth.setCategory(category);


category = T("|Alignment|");
	String sOffsetXName=T("|X-Offset|");	
	PropDouble dOffsetX(nDoubleIndex++, U(0), sOffsetXName,_kLength);	
	dOffsetX.setDescription(T("|Defines the axis offset in length direction.|"));
	dOffsetX.setCategory(category);

	String sRotationName=T("|Rotation|");	
	PropDouble dRotation(nDoubleIndex++, U(0), sRotationName, _kAngle);	
	dRotation.setDescription(T("|Defines the Rotation|"));
	dRotation.setCategory(category);


//End Properties//endregion 

//region bOnJig
	if (_bOnJig && _kExecuteKey=="JigRotate") 
	{
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point
	    Point3d ptAxis = _Map.getPoint3d("ptAxis");
	    Body bd = _Map.getBody("body");
	    Vector3d vecX = _Map.getVector3d("vecX");
	    Vector3d vecY = _Map.getVector3d("vecY");	    
	    Vector3d vecZ = _Map.getVector3d("vecZ");
	    Vector3d vecBase = _Map.getVector3d("vecBase");	    
	    if (vecBase.bIsZeroLength())return;

	    setPropValuesFromMap(_Map.getMap(kPropValues));	

	    PlaneProfile ppM = _Map.getPlaneProfile("shape");
	    
	    if (vecZ.isParallelTo(vecZView))ptAxis += vecZView * 1.2 * _Map.getDouble("Length");
		Line(ptJig, vecZ).hasIntersection(Plane(ptAxis, vecZ), ptJig);
		
		Vector3d vecTo = ptJig - ptAxis;
		vecTo.normalize();
		double rotation = vecBase.angleTo(vecTo,vecZ);		
		rotation -= dRotation;
		
		CoordSys csRot;
    	csRot.setToRotation(rotation, vecZ, ptAxis);
    	vecX.transformBy(csRot);
    	vecY.transformBy(csRot);
    	
    	//ppM.transformBy(csRot);

		Display dp(-1);	    
	    dp.trueColor(darkyellow,50);  
	    
	    
		double dXMax, dYMax;
		{ 
			LineSeg segs[] = ppM.splitSegments(LineSeg(ppM.ptMid() - vecX * U(10e4), ppM.ptMid() + vecX * U(10e4)), true);
				dXMax = segs.first().length();
		}
		{ 
			LineSeg segs[] = ppM.splitSegments(LineSeg(ppM.ptMid() - vecY * U(10e4), ppM.ptMid() + vecY * U(10e4)), true);
				dYMax = segs.first().length();
		}		
		//ppM.extentInDir(vecX).vis(6);

	//region Tooling
		Point3d pt = ptAxis+vecY*(dYOffsetB-dYOffsetA);
		
		// Male
		double dX = dXWidth<dXMax?dXWidth:dXMax;
		double dY = dYMax-dYOffsetA-dYOffsetB;
		double dZ = dZDepth;
		
		Mortise mtm(pt, vecX,vecY, vecZ, dX, dY, dZ, 0, 0, 1);
		mtm.setEndType(_kFemaleSide);
		bd.intersectWith(mtm.cuttingBody());
	    dp.draw(bd);
	    //dp.draw(ppM, _kDrawFilled);
	    
	    dp.color(_ThisInst.color());
	    dp.draw(ppM);	    
    
	    
	// draw angle
		double dSize = dViewHeight / 10;
		double dBulge = (rotation > 180 ? rotation - 360 : rotation) ;
		PLine pl(vecZ);
		pl.addVertex(ptAxis);
		pl.addVertex(ptAxis+vecBase*dSize);
		pl.addVertex(ptAxis+vecTo*dSize, tan(dBulge*.25));
		pl.close();
		
		dp.trueColor(blue,50);
		dp.draw(PlaneProfile(pl), _kDrawFilled);
		
		dp.textHeight(.25 * dSize);
		dp.color(7);
		dp.draw( String().formatUnit(dBulge, 2, 1) + "°",ptAxis + (vecBase + vecTo) * .5 * dSize, vecXView, vecYView, 0, 0 );
		
	    return;
	}	
	if (_bOnJig && _kExecuteKey=="JigSplit") 
	{
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point
	    Point3d ptCen = _Map.getPoint3d("ptCen");
	    Vector3d vecX = _Map.getVector3d("vecX");
	    Vector3d vecY = _Map.getVector3d("vecY");
	    Vector3d vecZ = _Map.getVector3d("vecZ"); 
	    Body bd = _Map.getBody("body");
	    setPropValuesFromMap(_Map.getMap(kPropValues));	
	    
	    double dL = _Map.getDouble("Length")-4*dZDepth;
	
			
	    PLine pl(ptCen - vecZ * .5 * dL, ptCen + vecZ * .5 * dL);
 		ptJig = pl.closestPointTo(ptJig);    
	    PlaneProfile ppShape = bd.getSlice(Plane(ptJig, vecZ));

		double dYHeight = bd.lengthInDirection(vecY);
		Point3d pt = ptJig + vecY * .5*dYHeight;
//		Dove dv (pt, vecX, vecY, vecZ, dXWidth, dYHeight-dOffset, dZDepth, dAngle, _kMaleEnd);	
//		bd.addTool(dv);	
//

		Display dp(-1);
		
		if(in3dGraphicsMode())
	   		dp.trueColor(lightblue,80 );			
		else
	   		dp.trueColor(white);    
//	    dp.draw(ppShape, _kDrawFilled);	    
	    dp.color(_ThisInst.color());
	    dp.draw(ppShape);
	    dp.draw(bd);
	    return;
	}	
//End bOnJig//endregion 

//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		if (_kExecuteKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());	
			if (sEntries.findNoCase(_kExecuteKey,-1)>-1)
				setPropValuesFromCatalog(_kExecuteKey);
			else
				setPropValuesFromCatalog(sLastInserted);					
		}	
	// standard dialog	
		else	
			showDialog();
		
		nConnection = sConnections.find(sConnection,0);
		
		
	// create TSL
		TslInst tslNew;				Map mapTsl;
		int bForceModelSpace = true;	
		String sExecuteKey,sCatalogName = sLastInserted;
		String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
		GenBeam gbsTsl[2] ;		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};


		Beam males[0];
		GenBeam females[0];
		
		
	// prompt for male beams			
		PrEntity ssE(T("|Select male beams|"), Beam());
		if (ssE.go())
			males.append(ssE.beamSet());
		
	// prompt for females
		Entity ents[0];
		ssE = PrEntity (T("|Select female beams or panels|"), Beam());
		ssE.addAllowedClass(Sip());
		if (ssE.go())
			ents.append(ssE.set());			
		
		for (int i=0;i<ents.length();i++) 
		{ 
			GenBeam gb= (GenBeam)ents[i];
			if (gb.bIsValid() && males.find(gb)<0)
				females.append(gb);	 
		}//next i
		
		
	//region T- and End2ENd Connections
		{ 			
		// Create instance by connection
			for (int i=0;i<males.length();i++) 
			{ 
				Beam& b= males[i]; 
				Vector3d vecX0 = b.vecX();
				Vector3d vecY0 = b.vecY();
				Point3d ptCen0 = b.ptCen();
				gbsTsl[0]=b;
				
				for (int j=0;j<females.length();j++) 
				{ 
					GenBeam& f= females[j];
					Beam bm1 = (Beam)f;
					Vector3d vecX1 = f.vecX();
					Vector3d vecY1 = f.vecY();
					Vector3d vecZ1 = f.vecZ();
					
				// Beam2Beam	
					if (bm1.bIsValid())
					{ 
						Point3d ptCen1 = bm1.ptCen();
						
					// parallel	
						if (vecX0.isParallelTo(vecX1))
						{
							Plane pn(ptCen0,vecX0);
							PlaneProfile pp0 = b.envelopeBody().shadowProfile(pn);
							PlaneProfile pp1 = bm1.envelopeBody().shadowProfile(pn);
							pp0.intersectWith(pp1);
							if (pp0.area()<pow(dXWidth,2))
							{ 
								continue;// ignore parallel, apparently intersection not sufficient	
							}	
							Vector3d vecXT = vecX0;
							if (vecXT.dotProduct(ptCen1 - ptCen0) < 0)vecXT *= -1;
							ptsTsl[0] = ptCen0 + vecXT * .5 * b.solidLength();
							
						}
						else
						{ 
							LineBeamIntersect lbi(ptCen0, vecX0, bm1);
							if (!lbi.bHasContact())
							{
								reportNotice("\n" + bm1.handle() + " not intersecting male " + b.handle());
								continue;
							}							
						}
						gbsTsl[1]=bm1;
						tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 
					}
				// Beam2Panel	
					else
					{ 
						if (vecX0.isPerpendicularTo(vecZ1))continue;// ignore parallel
						Point3d ptCen1 = f.ptCen();
						
						Plane pn(ptCen1, vecZ1);
						Point3d ptX;
						if (Line(ptCen0, vecX0).hasIntersection(pn, ptX))
						{
							Vector3d vecN = vecZ1;
							if (vecN.dotProduct(ptX - ptCen0) < dEps)vecN *= -1;
							pn.transformBy(f.vecD(vecN) * .5 * f.dD(vecN));
							
							PlaneProfile pp = f.envelopeBody(true, true).shadowProfile(pn);
							if (pp.pointInProfile(ptX) == _kPointOutsideProfile)
							{
								reportNotice("\n" + bm1.handle() + " not intersecting male panel " + f.handle());
								continue;
							}
							
							gbsTsl[1]=f;
							tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 
							
						}
					}
				}//next j
			}//next i
			if (females.length()>0 && !bDebug)eraseInstance();
					
		// Split male if no female has been selected
			{ 
				Beam& bm0= males.first(); 
				Vector3d vecX0 = bm0.vecX();
				Vector3d vecY0 = bm0.vecY();
				Vector3d vecZ0 = bm0.vecZ();
				Point3d ptCen0 = bm0.ptCen();
				double dX = bm0.solidLength();
				Line lnX(ptCen0, vecX0);
				
			//region Show Jig
				PrPoint ssP(T("|Pick point [Flip direction/]|"), ptCen0-vecX0*.5*dX); // second argument will set _PtBase in map
			    ssP.setSnapMode(TRUE, 0);
			    Map mapArgs;
				mapArgs.setDouble("Length", dX);
				mapArgs.setPoint3d("ptCen", ptCen0);
				mapArgs.setVector3d("vecX", -vecY0);
				mapArgs.setVector3d("vecY", vecZ0);
				mapArgs.setVector3d("vecZ", vecX0);
				mapArgs.setBody("body", bm0.envelopeBody(false, true));
				mapArgs.setMap("kPropValues", mapWithPropValues());
				mapArgs.setInt("_Highlight", in3dGraphicsMode()); 

			    int nGoJig = -1;
			    while (nGoJig != _kOk && nGoJig != _kNone)
			    {
			        nGoJig = ssP.goJig("JigSplit", mapArgs); 
			        if (bDebug)reportMessage("\ngoJig returned: " + nGoJig);
			        
			        if (nGoJig == _kOk)
			        {
			            _Pt0 = lnX.closestPointTo(ssP.value());
			        }
			        else if (nGoJig == _kKeyWord)
			        { 
			            if (ssP.keywordIndex() == 0)
			            {
			            	vecX0 *= -1;
			            	vecZ0 *= -1;
			            	mapArgs.setVector3d("vecX", -vecY0);
							mapArgs.setVector3d("vecZ", vecX0);
			            }
//			            else 
//			                mapArgs.setInt("isLeft", FALSE);
			        }
			        else if (nGoJig == _kCancel)
			        { 
			            eraseInstance(); // do not insert this instance
			            return; 
			        }
			    }
			    
			    ssP.setSnapMode(false, 0);
			    
			//End Show Jig//endregion 
			
				Beam bm1;
				Point3d ptTo, ptFrom;
				bm1 = bm0.dbSplit(_Pt0,_Pt0);	
				_Beam.append(bm0);	
				_Beam.append(bm1);	
				sConnection.set(tEnd2EndConnection);
	
			}
		}
	//endregion 	
		

		
		return;
	}	
// end on insert	__________________//endregion

//region References and defaults
	Beam male, bmFemale;
	GenBeam female;
	Sip panel;
	Element el;
	
	if (_Beam.length()>0)
	{
		male = _Beam[0];
		_Entity.append(male);
		setDependencyOnEntity(male);
		el = male.element();
	}
	else
	{ 
		reportMessage("\n"+ scriptName() + T("|This tool requires 2 beams or 1 beam and 1 panel| ")+T("|Tool will be deleted.|"));
		eraseInstance();		return;
	}
	Point3d ptCen1,ptCen0= male.ptCen();	
	Vector3d vecX0 = male.vecX();	
	Vector3d vecY0 = male.vecY();
	Vector3d vecZ0 = male.vecZ();
	vecX0.vis(ptCen0,1); vecY0.vis(ptCen0,3); vecZ0.vis(ptCen0,150);	
		
	Vector3d vecX1, vecY1, vecZ1;	
	if (_Sip.length()>0)
	{
		panel= _Sip[0];
		ptCen1= panel.ptCen();
		vecX1 = panel.vecX();	
		vecY1 = panel.vecY();
		vecZ1 = panel.vecZ();	vecZ1.vis(ptCen1,150);	
		female = panel;
		setDependencyOnEntity(panel);
	}
	else if (_Beam.length()>1)
	{
		bmFemale= _Beam[1];
		ptCen1= bmFemale.ptCen();
		vecX1 = bmFemale.vecX();	
		vecY1 = bmFemale.vecY();
		vecZ1 = bmFemale.vecZ();
		female = bmFemale;
		setDependencyOnEntity(bmFemale);
	}
		
	int bHasPanel = panel.bIsValid();
	int bIsParallel = vecX0.isParallelTo(vecX1);
	int bIsEnd2End = sConnection == tEnd2EndConnection;
	int bIsMortise = sType.find(tMortise ,0, false) >- 1;
	int bIsHouse = sType.find(tHouse ,0, false) >- 1;
	
	int nRoundType = _kRound;
	if (bIsMortise)
	{ 
		if (sType == tMortiseNotRound)nRoundType = _kNotRound;
		else if (sType == tMortiseRounded)nRoundType = _kRounded;
		else if (sType == tMortiseExplicit && abs(dExplicitRadius)>dEps) nRoundType = _kExplicitRadius;		
	}
	else if (bIsHouse)
	{ 
		if (sType == tHouseNotRound)nRoundType = _kNotRound;
		else if (sType == tHouseRounded)nRoundType = _kRounded;
		else if (sType == tHouseSmallRelief) nRoundType = _kReliefSmall;
		else if (sType == tHouseRelief) nRoundType = _kRelief;		
	}
	// beam2panel only supports T-Connection
	if (bHasPanel && sConnection!=tTConnection)
		sConnection.set(tTConnection);

	if (!female.bIsValid() && !bDebug)//
	{ 
		reportMessage("\n"+ scriptName() + T("|This tool requires 2 beams or 1 beam and 1 panel| ")+T("|Tool will be deleted.|"));
		eraseInstance();	return;
	}	
	_Entity.append(female);
	setDependencyOnEntity(female);	
	
	int bHasElement = el.bIsValid();	
	if (bHasElement)
		assignToElementGroup(el, true, 0, 'T');
	else
		assignToGroups(male, 'T');
	setKeepReferenceToGenBeamDuringCopy(_kAllBeams); 
	_ThisInst.setAllowGripAtPt0(bIsParallel);

	Body bdMale = male.envelopeBody(false, true);
	Body bdFemale = female.envelopeBody(false, true);

//
//endregion 

//region Tool CoordSys
	Vector3d vecX, vecY, vecZ,vecXC0,vecYM, vecBase;
	Point3d ptX;
	double dXMale, dYMale;
	Plane pnF;
	PlaneProfile ppZ;
//endregion
//
//endregion END part #1

//region PANEL connection	
	if (bHasPanel)
	{ 
		if (!bDebug && vecX0.isPerpendicularTo(vecZ1))
		{
			reportMessage("\n" + T("|Male beam may not be parallel panel XY-plane.|"));
			eraseInstance();	return;
		}
		pnF = Plane(ptCen1, vecZ1);
		if (Line(ptCen0, vecX0).hasIntersection(pnF, ptX))
		{
			vecZ = vecZ1;				
			if (vecZ.dotProduct(ptCen0-ptX) < dEps)vecZ *= -1;
			pnF.transformBy(panel.vecD(vecZ) * .5 * panel.dD(vecZ));
			vecZ *= -1;
			Line(ptCen0, vecX0).hasIntersection(pnF, ptX);
			PlaneProfile pp = bdFemale.shadowProfile(pnF);
			if (pp.pointInProfile(ptX) == _kPointOutsideProfile)
			{
				reportNotice("\n" + male.handle() + " not intersecting male panel " + panel.handle());
				eraseInstance();	return;
			}				
		}			
	}//endregion
	
//region Beam2Beam	
	else
	{ 
		if (bIsParallel)
		{ 
		//region Trigger Join
			String sTriggerJoin = T("|Join|");
			addRecalcTrigger(_kContextRoot, sTriggerJoin );
			if (_bOnRecalc && _kExecuteKey==sTriggerJoin)
			{
				male.dbJoin(bmFemale);
				eraseInstance();
				return;
			}//endregion	
			
		// make sure location will not be dragged outside valid range	
			if ( _kNameLastChangedProp == "_Pt0" && _Map.hasVector3d("vecPt0"))
			{ 
				Vector3d vecXT = male.vecX();
				if (vecXT.dotProduct(ptCen1 - ptCen0) < 0)
					vecXT *= -1;
				Point3d ptMax0 = ptCen0- vecXT * .5 * male.dL();
				double d0 = vecXT.dotProduct(_Pt0 - ptMax0)-2*dZDepth;
				Point3d ptMax1 = ptCen1+ vecXT * .5 * bmFemale.dL();
				double d1 = vecXT.dotProduct(ptMax1 - _Pt0)-2*dZDepth;		
				if (d0 < 0 || d1 < 0)
				{ 
					_Pt0 = _PtW + _Map.getVector3d("vecPt0");
				}
				
			}
			vecZ = male.vecX();
			ptX = _Pt0;
			ptX = Line(ptCen0, vecZ).closestPointTo(ptX);
			if (vecZ.dotProduct(ptX - male.ptCen()) < 0)vecZ *= -1;				
			
		}
		else
		{ 
			LineBeamIntersect lbi(ptCen0, vecX0, bmFemale);
			if (!lbi.bHasContact())
			{
				reportMessage("\n" + T("|Beams do not connect.|"));
				eraseInstance();	return;
			}
			
		// Mitre	
			if (sConnection == tEnd2EndConnection)
				Line(ptCen0, vecX0).hasIntersection(Plane(ptCen1, bmFemale.vecD(vecX0)), ptX);
			else
				ptX = lbi.pt1();
			vecZ = lbi.vecNrm1();				
		}
		
	//Trigger FlipDirection
		String sTriggerFlipDirection = T("|Flip Direction|");
		addRecalcTrigger(_kContextRoot, sTriggerFlipDirection );
		if (_bOnRecalc && _kExecuteKey==sTriggerFlipDirection)
		{
			_Beam.swap(0,1);		
			setExecutionLoops(2);
			return;
		}	

	}
//endregion 	


	if (vecX0.isParallelTo(_ZW))
		vecY = male.vecZ();
	else
		vecY = male.vecD(_ZW);
	vecXC0 = vecX0; if (vecXC0.dotProduct(vecZ) < 0)vecXC0 *= -1; // the vecX of male pointing towards connection


// End2End Connection
	if (bIsEnd2End)
	{ 
		Vector3d vecXC1 = vecX1;
		if (vecXC1.dotProduct(ptX - ptCen1) < 0)vecXC1 *= -1;
		
		if (!bIsParallel)
		{ 
			Vector3d vecM = vecXC1 + vecXC0;
			vecM.normalize();
			vecZ = vecZ.crossProduct(vecM).crossProduct(-vecM);
			vecZ.normalize();	
			vecM.vis(_Pt0, 40);
		// auto correct X-offset for non perpendicular connections on creation	
			if (_bOnDbCreated || bDebug)
			{
				int sgn = vecM.dotProduct(vecY.crossProduct(vecZ))>0?-1:1;
				double dAngle = vecXC0.angleTo(vecXC1);
				dOffsetX.set(sgn*sin(dAngle)*U(20)); // typical diameter of milling head
			}						
		}
	}

	vecX = vecY.crossProduct(vecZ);
	Vector3d vecXM = male.vecD(vecX);
	vecY = vecXM.crossProduct(-vecZ);	vecY.normalize();
	vecX = vecY.crossProduct(vecZ);		vecX.normalize();
	vecX.vis(ptX, 1);	vecY.vis(ptX, 3);	vecZ.vis(ptX, 150);
		

	
	// rotate
	vecBase = vecY;
	if (abs(dRotation)>dEps)
	{ 
		CoordSys csRot;
		csRot.setToRotation(dRotation, vecZ, _Pt0);
		vecX.transformBy(csRot);
		vecY.transformBy(csRot);
	}	
	vecYM = male.vecD(vecY);	//vecYM.vis(ptX, 4);
	dXMale = male.dD(vecX);
	dYMale = male.dD(vecY);
	

	ptX += vecX * dOffsetX;
	_Pt0 = ptX;
	pnF=Plane(ptX, vecZ);
//		ptX+=vecX*dOffsetX;	
//
//	//region Get female contact face and relevant points and conditions
//		PlaneProfile ppFemale(CoordSys(ptX, vecX, vecY, vecZ));
//		ppFemale.unionWith(bdFemale.extractContactFaceInPlane(pnF, dEps));
//		if (bDebug)ppFemale.shrink(-dEps);
//		//ppFemale.vis(6);
//		
//		ptEnd = ptX + vecZ * dZDepth;
//		ppZ = PlaneProfile(CoordSys(ptEnd, vecX, vecY, vecZ));
//	
//		Line lnY(ptX, vecY);
//		Plane pnYM(ptCen0, vecYM);				pnYM.vis(1);
//		ptBottom = lnY.intersect(pnYM, -.5 * dYMale);
//		ptTop = lnY.intersect(pnYM, .5 * dYMale);
//		double dYHeight = vecY.dotProduct(ptTop-ptBottom)-dOffset;	
//	
//		// keyhole
//		int nAddKey = ppFemale.pointInProfile(ptTop + vecY * U(1)) != _kPointOutsideProfile && dHeightKey>=0; // 0 = no keyHole, 1 = default keyhole, 2 = custom size
//		if (nAddKey > 0 && dHeightKey > dEps)nAddKey++;
//		
//		
//	//endregion 
//
//

// Get X- and Y- max dimensions
	PlaneProfile ppM = bdMale.shadowProfile(Plane(ptCen0, vecXC0));
	ppM.project(pnF, vecXC0, dEps);
	double dXMax=male.dD(vecX), dYMax=male.dD(vecY);
	{ 
		LineSeg segs[] = ppM.splitSegments(LineSeg(ppM.ptMid() - vecX * U(10e4), ppM.ptMid() + vecX * U(10e4)), true);
		if (segs.length()>0)
			dXMax = segs.first().length();
	}
	{ 
		LineSeg segs[] = ppM.splitSegments(LineSeg(ppM.ptMid() - vecY * U(10e4), ppM.ptMid() + vecY * U(10e4)), true);
		if (segs.length()>0)
			dYMax = segs.first().length();
	}		
	//ppM.extentInDir(vecX).vis(6);

//region Tooling
	Point3d pt = ptX+vecY*(dYOffsetB-dYOffsetA);
	
	// Male
	double dX = dXWidth<dXMax?dXWidth:dXMax;
	if (dX <= dEps)dX = male.dD(vecX);
	double dY = dYMax-dYOffsetA-dYOffsetB;
	if (dY <= dEps)dY = male.dD(vecY);
	double dZ = dZDepth;
	
// MALE	
	if (dZ<=0) // instamce will be deleted
	{ 
		if (bIsParallel)
		{
			male.dbJoin(bmFemale);
			eraseInstance();
			return;
		}
		male.addToolStatic(Cut(ptX, vecZ),bDebug?_kStretchNot:_kStretchOnToolChange);
	}
	else if (bIsHouse)
	{ 
		House hs(pt, vecX,vecY, vecZ, dX, dY, dZ, 0, 0, 1);
		hs.setEndType(_kMaleEnd);
		hs.setRoundType(nRoundType);
		male.addTool(hs,bDebug?_kStretchNot:_kStretchOnToolChange);		
	}
	else
	{ 
		Mortise mt(pt, vecX,vecY, vecZ, dX, dY, dZ, 0, 0, 1);
		mt.setEndType(_kMaleEnd);
		mt.setRoundType(nRoundType);
		if (nRoundType==_kExplicitRadius && dExplicitRadius>dEps)
			mt.setExplicitRadius(dExplicitRadius);
		male.addTool(mt,bDebug?_kStretchNot:_kStretchOnToolChange);		
	}

// FEMALE
	dX += 2*dGapWidth;
	dY += 2*dGapLength;
	dZ += dGapDepth;
	if (dZ<=0) // instamce will be deleted
	{ 
		if (bIsEnd2End)
			female.addToolStatic(Cut(ptX, -vecZ),_kStretchOnToolChange);
		eraseInstance();
		return;	
	}	
	else if (bIsHouse)
	{ 
		House hs(pt, vecX,vecY, vecZ, dX, dY, dZ, 0, 0, 1);
		hs.setEndType(bIsEnd2End?_kFemaleEnd:_kFemaleSide);
		hs.setRoundType(nRoundType);
		female.addTool(hs,bDebug?_kStretchNot:_kStretchOnToolChange);		
	}
	else
	{ 
		Mortise mt(pt, vecX,vecY, vecZ, dX, dY, dZ, 0, 0, 1);
		mt.setEndType(bIsEnd2End?_kFemaleEnd:_kFemaleSide);
		mt.setRoundType(nRoundType);
		if (nRoundType==_kExplicitRadius && abs(dExplicitRadius)>dEps)
			mt.setExplicitRadius(dExplicitRadius);
		female.addTool(mt,bDebug?_kStretchNot:_kStretchOnToolChange);		
	}
	
//endregion 

//region Trigger Rotate90
	String sTriggerRotate90 = T("|Rotate 90°|");
	addRecalcTrigger(_kContextRoot, sTriggerRotate90 );
	if (_bOnRecalc && (_kExecuteKey==sTriggerRotate90|| _kExecuteKey==sDoubleClick))
	{
		double rotation = dRotation;
		rotation += 90;
		if (rotation>=360)
			rotation -= 360;
		dRotation.set(rotation);	
		setExecutionLoops(2);
		return;
	}//endregion


//region Trigger Rotate
	String sTriggerRotate = T("|Rotate|");
	addRecalcTrigger(_kContextRoot, sTriggerRotate );
	if (_bOnRecalc &&_kExecuteKey==sTriggerRotate)
	{		
		//_Map.removeAt("Rotation", true); 
		Point3d pt = _Pt0 + vecY * U(100);
		
	//region Show Jig
		PrPoint ssP(T("|Pick point for new angle [Angle]|"), _Pt0); // second argument will set _PtBase in map
	    ssP.setSnapMode(TRUE, 0);
	    Map mapArgs;
		mapArgs.setPoint3d("ptAxis", _Pt0);
		mapArgs.setVector3d("vecBase", vecBase);
		mapArgs.setPoint3d("ptCen", ptCen0);
		mapArgs.setVector3d("vecX", vecX);
		mapArgs.setVector3d("vecY", vecY);
		mapArgs.setVector3d("vecZ", vecZ);	
	   	mapArgs.setPlaneProfile("shape", ppM);	

		mapArgs.setBody("body", bdFemale);
		mapArgs.setMap("kPropValues", mapWithPropValues());
		mapArgs.setInt("_Highlight", in3dGraphicsMode()); 		
		
		
		double rotation = dRotation;
	    int nGoJig = -1;
	    while (nGoJig != _kOk && nGoJig != _kNone)
	    {
	        nGoJig = ssP.goJig("JigRotate", mapArgs); 
	        if (bDebug)reportMessage("\ngoJig returned: " + nGoJig);
	        
	        if (nGoJig == _kOk)
	        {
	            pt = ssP.value(); //retrieve the selected point
	            pt += vecZ * vecZ.dotProduct(_Pt0 - pt);
	            
	         	Vector3d vecTo = pt - _Pt0;
			    vecTo.normalize();		    	
			    rotation = vecBase.angleTo(vecTo, vecZ); 
	        }
	        else if (nGoJig == _kKeyWord && ssP.keywordIndex() == 0)
	        { 
	            rotation = getDouble(T("|Enter rotation angle|"));
	            break;
	        }
	        else if (nGoJig == _kCancel)
	        { 
	            return; 
	        }
	    }
	    ssP.setSnapMode(false, 0);
	    if (abs(rotation -dRotation)>dEps)
	    	dRotation.set(rotation);
	//End Show Jig//endregion 

		setExecutionLoops(2);
		return;					


	}//endregion	

//region Trigger SetVertical
	if (abs(dRotation)>dEps)
	{
		String sTriggerSetVertical = T("|Set vertical alignment|");
		addRecalcTrigger(_kContextRoot, sTriggerSetVertical );
		if (_bOnRecalc && _kExecuteKey == sTriggerSetVertical)
		{
			dRotation.set(0);
			setExecutionLoops(2);
			return;
		}
	}//endregion

//region Trigger SetVertical
	if (vecZ.isPerpendicularTo(_ZW) && !vecY.isCodirectionalTo(_ZW))
	{
		String sTriggerSetPlump = T("|Set plump alignment|");
		addRecalcTrigger(_kContextRoot, sTriggerSetPlump );
		if (_bOnRecalc && _kExecuteKey == sTriggerSetPlump)
		{
			dRotation.set(vecBase.angleTo(_ZW, vecZ));
			setExecutionLoops(2);
			return;
		}
	}//endregion
//region Trigger SetHorizontal
	if (vecZ.isPerpendicularTo(_ZW) && !vecY.isPerpendicularTo(_ZW))
	{
		String sTriggerSetHorizontal = T("|Set horizontal alignment|");
		addRecalcTrigger(_kContextRoot, sTriggerSetHorizontal );
		if (_bOnRecalc && _kExecuteKey == sTriggerSetHorizontal)
		{
			dRotation.set(vecBase.angleTo(_ZW, vecZ)+90);
			setExecutionLoops(2);
			return;
		}
	}//endregion	


//	}
//// END T- or E2E-Connection	
////endregion	
//
//
//
//
////region Display
	Display	dpModel(-1);
	dpModel.trueColor(lightblue);

		
	if (_bOnGripPointDrag)
	{
		PlaneProfile pp = _Map.getPlaneProfile("shape");
		Point3d ptRef =_PtW+_Map.getVector3d("vecPt0");
		Line ln(ptRef, vecX0);
		pp.transformBy(ln.closestPointTo(_Pt0) - pp.coordSys().ptOrg());
		
		PLine rings[] = pp.allRings(true, false);
		if (rings.length()>0)
		{ 
			Body bd(rings.first(), vecZ * dZDepth ,1);
			dpModel.draw(bd);
		}
		dpModel.draw(ppM);
	}
	else
	{ 
		Body bdReal = male.realBody();
		PlaneProfile ppReal = bdReal.extractContactFaceInPlane(Plane(ptX + vecZ * dZDepth, vecZ), dEps);
		dpModel.draw(ppReal);		
		if (bIsParallel)
			_Map.setPlaneProfile("shape", ppReal);
		else
			_Map.removeAt("shape", true);
			
	// display coordinate axises
		double dAxisMin = U(20);
		Point3d ptAxis=ptX + vecZ * dZDepth;
		double dXAxis = .5*dX-dGapWidth;
		double dYAxis = .5*dY-dGapLength;
		
		PLine plXPos (ptAxis, ptAxis+vecX*dXAxis);
		PLine plXNeg (ptAxis, ptAxis-vecX*dXAxis);
		PLine plYPos (ptAxis, ptAxis+vecY*dYAxis);
		PLine plYNeg (ptAxis, ptAxis-vecY*dYAxis);
		//PLine plZPos (ptAxis, ptAxis+vecZ*dZAxis);
		PLine plZNeg (ptAxis, ptAxis-vecZ*dZDepth);
	
		Display dpAxis(-1);

		dpAxis.color(1);		dpAxis.draw(plXPos);
		dpAxis.color(14);		dpAxis.draw(plXNeg);
		dpAxis.color(3);		dpAxis.draw(plYPos);
		dpAxis.color(96);		dpAxis.draw(plYNeg);
		//dpAxis.color(150);	dpAxis.draw(plZPos);
		dpAxis.color(154);	dpAxis.draw(plZNeg);
	}
////endregion 
	
	//dpModel.draw(ppReal);

// keep track of valid position for E2E
	if (bIsEnd2End)
	{
		_Map.setVector3d("vecPt0", _Pt0 - _PtW);
		
	}
	if (bIsParallel)
		addRecalcTrigger(_kGripPointDrag, "_Pt0");
	

//region Trigger ShowCommands
	String sTriggerShowCommands = T("|Show Commands|");
	addRecalcTrigger(_kContext, sTriggerShowCommands );
	if (_bOnRecalc && _kExecuteKey==sTriggerShowCommands)
	{

		String text = TN("|You can create a toolbutton, a palette- or a ribbon command using one of the following commands.|")+
			TN("|Copy one o the lines below into the command property of the button definition|");	
		text += "\n\n"+ T("|Command to insert the tool|");
		text += "\n^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert \"hsbTenon\")) TSLCONTENT";
		
		text += "\n\n"+ T("|Optional commands of this tool|");
		text += "\n^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Flip Direction|\") (_TM \"|Select tool|\"))) TSLCONTENT";
		text += "\n^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Join|\") (_TM \"|Select tool|\"))) TSLCONTENT";
		text += "\n^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Set horizontal alignment|\") (_TM \"|Select tool|\"))) TSLCONTENT";
		text += "\n^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Set plump alignmen|\") (_TM \"|Select tool|\"))) TSLCONTENT";
		text += "\n^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Set vertical alignment|\") (_TM \"|Select tool|\"))) TSLCONTENT";
		reportNotice(text);
	
			
		setExecutionLoops(2);
		return;
	}//endregion	



#End
#BeginThumbnail

#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15220 initial version" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="5/11/2022 2:26:44 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End