#Version 8
#BeginDescription
#Versions
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
#MinorVersion 6
#KeyWords 
#BeginContents
/// <summary Lang=de>
/// Dieses TSL erzeugt Schwalbenschwanzverbindungen in verschiedenen Ausrichtungen.
/// Es werden die Werkzeugformen Schwalbenschwanz und Fremdfeder unterstützt
/// Bei der Angabe eines Zwischenabstandes wird - sofern anwendbar - eine Duplexverbindung erzeugt
/// </summary>

/// <summary Lang=en>
/// This TSL creates dove tail connections in various alignments
/// It supports the common dove tool as well as a loose joinery connection
/// With a given interdistance a duplex connection will be generated where ever applicable
/// </summary>

/// History
// #Versions
// 1.6 10.05.2022 HSB-15221 supports beam/panel connections HSB-15028 new keyhole options , Author Thorsten Huck
/// 1.5 14.03.2022 HSB-14935 default property values modified, Author Thorsten Huck
/// <version value="1.4" date=22Jun20" author="geoffroy.cenni@hsbcad.com">  support rotated and non-perpendicular beams. Add an additional Mortis Depth. </version>
/// <version value="1.3" date=05Mar20" author="david.delombaerde@hsbcad.com">  setting boundaries when moving the grippoint. And resetting the value when grip is out of bounds. </version>
/// <version value="1.2" date=24Oct15" author="thorsten.huck@hsbcad.com"> reference edges consider common edges of the connection </version>
/// <version value="1.1" date=14Oct15" author="thorsten.huck@hsbcad.com"> dialog image enhanced </version>
/// <version value="1.0" date=07Oct15" author="thorsten.huck@hsbcad.com"> initial </version>

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
	
	String tTConnection = T("|T-Connection|"), tEnd2EndConnection = T("|End-End|"), tPConnection = T("|Parallel Connection|");//
	String tButterfly = T("|Butterfly|"), tDove = T("|Dovetail|");
//end Constants//endregion

//region Properties
category = T("|Connection|");
	String sConnections[] = {tTConnection,  tEnd2EndConnection,tPConnection};// 
	String sConnectionName=T("|Connection|");	
	PropString sConnection(nStringIndex++, sConnections, sConnectionName);	
	sConnection.setDescription(T("|Defines the connection type|"));
	sConnection.setCategory(category);
	int nConnection = sConnections.find(sConnection,0);
	sConnection.setReadOnly((_bOnInsert || bDebug) ? false: _kHidden);
	
	String sTypes[] = { tDove, tButterfly};
	String sTypeName=T("|Type|");	
	PropString sType(nStringIndex++, sTypes, sTypeName);	
	sType.setDescription(T("|Defines the Type|"));
	sType.setCategory(category);
	if (sTypes.findNoCase(sType ,- 1) < 0)sType.set(tDove);
	if (sConnection == tPConnection)
	{ 
		sType.setReadOnly((_bOnInsert || bDebug) ? false: _kHidden);
		sType.set(tButterfly);
	}
	
category = T("|Dovetail|");
	String sXWidthName=T("|Width|");	
	PropDouble dXWidth(nDoubleIndex++, U(45), sXWidthName,_kLength);	
	dXWidth.setDescription(T("|Defines the XWidth|"));
	dXWidth.setCategory(category);
	
	String sZDepthName=T("|Depth|");	
	PropDouble dZDepth(nDoubleIndex++, U(28), sZDepthName,_kLength);	
	dZDepth.setDescription(T("|Defines the ZDepth|"));
	dZDepth.setCategory(category);	
	
	String sAdditionalDepthName=T("|Additional Depth|");	
	PropDouble dAdditionalDepth(nDoubleIndex++, U(0), sAdditionalDepthName,_kLength);	
	dAdditionalDepth.setDescription(T("|Defines the AdditionalDepth|"));
	dAdditionalDepth.setCategory(category);	
	dAdditionalDepth.setReadOnly(_bOnInsert || bDebug || sType!=tButterfly ?false:_kHidden);
	
	String sOffsetName=T("|Offset|");	
	PropDouble dOffset(nDoubleIndex++, U(0), sOffsetName,_kLength);	
	dOffset.setDescription(T("|Defines the offset from bottom|"));
	dOffset.setCategory(category);

	String sAngleName=T("|Angle|");	
	PropDouble dAngle(nDoubleIndex++, 10, sAngleName, _kAngle);	
	dAngle.setDescription(T("|Defines the Angle|"));
	dAngle.setCategory(category);
	dAngle.setReadOnly(_bOnInsert || bDebug || sType!=tButterfly ?false:_kHidden);

category = T("|Alignment|");
	String sOffsetXName=T("|Horizontal offset|");	
	PropDouble dOffsetX(nDoubleIndex++, U(0), sOffsetXName,_kLength);	
	dOffsetX.setDescription(T("|Defines the horizontal offset from the male axis.|"));
	dOffsetX.setCategory(category);
	dOffsetX.setReadOnly((_bOnInsert || bDebug || sConnection!=tPConnection) ?false:_kHidden);

	String sRotationName=T("|Rotation|");	
	PropDouble dRotation(nDoubleIndex++, U(0), sRotationName, _kAngle);	
	dRotation.setDescription(T("|Defines the Rotation|"));
	dRotation.setCategory(category);
	dRotation.setReadOnly(_bOnInsert || bDebug || (sType!=tButterfly || dOffset>0) ?false:_kHidden);

	String sInterDistanceName=T("|Duplex Interdistance|");	
	PropDouble dInterDistance(nDoubleIndex++, U(0), sInterDistanceName,_kLength);	
	dInterDistance.setDescription(T("|0 = single dovetail|")) + T(", |Butterfly connections only|");
	dInterDistance.setCategory(category);
	dInterDistance.setReadOnly(_bOnInsert || bDebug || sType==tButterfly ?false:_kHidden);
	
category = T("|Keyhole|");
	String sHeightKeyName=T("|Height|");	
	PropDouble dHeightKey(nDoubleIndex++, U(0), sHeightKeyName,_kLength);	
	dHeightKey.setDescription(T("|Defines the height of the keyhole|") + T(" |0 = Automatic, -1 = Disabled|"));
	dHeightKey.setCategory(category);
	dHeightKey.setReadOnly(_bOnInsert || bDebug || sType!=tButterfly ?false:_kHidden);
	
	String sWidthKeyName=T("|Width|");	
	PropDouble dWidthKey(nDoubleIndex++, U(0), sWidthKeyName,_kLength);	
	dWidthKey.setDescription(T("|Defines the width of the keyhole|") + T(" |0 = Automatic|"));
	dWidthKey.setCategory(category);
	dWidthKey.setReadOnly(_bOnInsert || bDebug || sType!=tButterfly ?false:_kHidden);
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

	    PlaneProfile ppShape = _Map.getPlaneProfile("shape");
	    
	    if (vecZ.isParallelTo(vecZView))ptAxis += vecZView * 1.2 * _Map.getDouble("Length");
		Line(ptJig, vecZ).hasIntersection(Plane(ptAxis, vecZ), ptJig);
		
		Vector3d vecTo = ptJig - ptAxis;
		vecTo.normalize();
		double rotation = vecBase.angleTo(vecTo,vecZ);		
		rotation -= dRotation;
		
		CoordSys csRot;
    	csRot.setToRotation(rotation, vecZ, ptAxis);
    	ppShape.transformBy(csRot);

		Display dp(-1);	    
	    dp.trueColor(darkyellow,50);    

	    
	// try body display    
	    Quader qdr(bd.ptCen(), vecX, vecY, vecZ, bd.lengthInDirection(vecX), bd.lengthInDirection(vecY), bd.lengthInDirection(vecZ), 0, 0, 0);
	    vecX.transformBy(csRot);
	    vecY.transformBy(csRot);
	    Point3d ptTop, ptBottom;	    
	    if (Line(ptAxis, vecY).hasIntersection(qdr.plFaceD(vecY), ptTop))
	    { 
	    	PlaneProfile pp = bd.shadowProfile(Plane(ptAxis, vecZ));
	    	dp.draw(pp);
	    	
	    	Line(ptAxis, - vecY).hasIntersection(qdr.plFaceD(-vecY), ptBottom);
		    double dYHeight = vecY.dotProduct(ptTop-ptBottom);
		    Dove dv (ptTop, vecX, vecY, vecZ, dXWidth, dYHeight-dOffset, dZDepth, dAngle, _kMaleEnd);	
			bd.addTool(dv);
			bd.addTool(Cut(ptAxis ,- vecZ), 0);
		    dp.draw(bd);
		    ppShape = bd.extractContactFaceInPlane(Plane(ptAxis + vecZ * dZDepth, vecZ), dEps);
	    }
	    
	    dp.draw(ppShape, _kDrawFilled);
	    
	    dp.color(_ThisInst.color());
	    dp.draw(ppShape);	    
    
	    
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
		Dove dv (pt, vecX, vecY, vecZ, dXWidth, dYHeight-dOffset, dZDepth, dAngle, _kMaleEnd);	
		bd.addTool(dv);	


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
		if (sConnection!=tPConnection)
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
		
	//region P-Connection
		else if (sConnection==tPConnection)	
		{ 
			ptsTsl[0] = getPoint(T("|Pich location|"));
		// Create instances by connection
			for (int i = 0; i < males.length(); i++)
			{
				Beam& bm0 = males[i];
				Vector3d vecX0 = bm0.vecX();
				Vector3d vecY0 = bm0.vecY();
				Vector3d vecZ0 = bm0.vecZ();
				Point3d ptCen0 = bm0.ptCen();
				gbsTsl[0] = bm0;
				
				for (int j = 0; j < females.length(); j++)
				{
					GenBeam& f = females[j];
					Beam bm1 = (Beam)f;
					Vector3d vecX1 = f.vecX();
					Vector3d vecY1 = f.vecY();
					Vector3d vecZ1 = f.vecZ();
					
				// Beam2Beam	
					if (bm1.bIsValid())
					{ 
						;
					}
				// Beam2Panel	not well aligned
					else if (!vecZ1.isParallelTo(vecY0) && !vecZ1.isParallelTo(vecZ0))
					{
						if (bDebug)reportNotice("\n" + bm1.handle() + " must be aligned with Z-Axis of" + f.handle());
						continue;
					}
					gbsTsl[1] = f;
					tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent);
				}
			}
			eraseInstance();
		}
	//endregion 	
		else
		{ 
			reportMessage("\n" + scriptName() + ": " +T("|undefined insert option|"));
			eraseInstance();
			
		}
		
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
	int bIsButterfly = sType == tButterfly;
	double angle = bIsButterfly ? 0 : abs(dAngle);
	


	int qty = 1;
	double dXWidthTotal = dXWidth + dInterDistance;
	if (bIsButterfly && dInterDistance>=dXWidth+U(20))
	{
		qty++;
		dXWidthTotal +=dInterDistance;
	}


	if (!female.bIsValid() )//&& !bDebug
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
	_ThisInst.setAllowGripAtPt0(sConnection == tPConnection);

	Body bdFemale = female.envelopeBody(false, true);
	int nMaleEndType = bIsButterfly?_kFemaleEnd:_kMaleEnd;
	int nFemaleEndType = bIsEnd2End?_kFemaleEnd:_kFemaleSide;

//endregion 

//region Tool CoordSys
	Vector3d vecX, vecY, vecZ,vecXC0,vecYM, vecBase;
	Point3d ptX;
	double dXMale, dYMale;
	Plane pnF;
	Body bdTool;
	PlaneProfile ppZ;
	Point3d ptTop, ptBottom, ptEnd;
//endregion

//endregion END part #1

//region T- or End2End-Connection
	if (sConnection!=tPConnection) 
	{ 
	// PANEL connection	
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
		}
	// Beam2Beam	
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
				ptX = _Pt0;
				vecZ = male.vecX();
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
			pnF = Plane(ptX, vecZ);
			
		//region Trigger FlipDirection
			String sTriggerFlipDirection = T("|Flip Direction|");
			addRecalcTrigger(_kContextRoot, sTriggerFlipDirection );
			if (_bOnRecalc && _kExecuteKey==sTriggerFlipDirection)
			{
				_Beam.swap(0,1);		
				setExecutionLoops(2);
				return;
			}//endregion	

		}
			
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
		vecYM = male.vecD(vecY);	vecYM.vis(ptX, 4);
		dXMale = male.dD(vecX);
		dYMale = male.dD(vecY);
		
		// horizontal offset, limited to male edge
		double dOffsetXMax = .5 * (dXMale - dXWidth);
		if (dOffsetX>0 && abs(dOffsetX)>dOffsetXMax)
		{
			int sgn = dOffsetX / abs(dOffsetX);
			dOffsetX.set(sgn*dOffsetXMax);
			reportMessage("\n" + sOffsetXName + T(" |has been adjusted to| ") + dOffsetXMax);	
		}
		
		
	
		
		
		_Pt0 = ptX;
		ptX+=vecX*dOffsetX;	

	//region Get female contact face and relevant points and conditions
		PlaneProfile ppFemale(CoordSys(ptX, vecX, vecY, vecZ));
		ppFemale.unionWith(bdFemale.extractContactFaceInPlane(pnF, dEps));
		if (bDebug)ppFemale.shrink(-dEps);
		//ppFemale.vis(6);
		
		ptEnd = ptX + vecZ * dZDepth;
		ppZ = PlaneProfile(CoordSys(ptEnd, vecX, vecY, vecZ));
	
		Line lnY(ptX, vecY);
		Plane pnYM(ptCen0, vecYM);				pnYM.vis(1);
		ptBottom = lnY.intersect(pnYM, -.5 * dYMale);
		ptTop = lnY.intersect(pnYM, .5 * dYMale);
		double dYHeight = vecY.dotProduct(ptTop-ptBottom)-dOffset;	
	
		// keyhole
		int nAddKey = ppFemale.pointInProfile(ptTop + vecY * U(1)) != _kPointOutsideProfile && dHeightKey>=0; // 0 = no keyHole, 1 = default keyhole, 2 = custom size
		if (nAddKey > 0 && dHeightKey > dEps)nAddKey++;
		
		
	//endregion 


	//region Tooling
		
	
	// STRETCH
		if (nMaleEndType==_kMaleEnd)
			male.addTool(Cut(ptEnd, vecZ),_kStretchOnToolChange);
		else if (nMaleEndType==_kFemaleEnd)
			male.addTool(Cut(ptX, vecZ),_kStretchOnToolChange);		
		if (!bHasPanel && nFemaleEndType==_kFemaleEnd)
			bmFemale.addTool(Cut(_Pt0, -vecZ), _kStretchOnToolChange);	

		if (dYHeight>dEps)
		{
			Point3d pt = ptTop-vecX*(qty==2?.5*dInterDistance:0);			
			for (int i = 0; i < qty; i++)
			{
				pt.vis(1);
	
			// Male Dove
				Dove dv0;				
				if (nMaleEndType==_kFemaleEnd)
					dv0 = Dove(pt, -vecX, vecY, -vecZ, dXWidth, dYHeight, dZDepth, angle, nMaleEndType);	
				else
					dv0 = Dove(pt, vecX, vecY, vecZ, dXWidth, dYHeight, dZDepth, angle, nMaleEndType);
				male.addTool(dv0,true);	
	
				ppZ.unionWith(male.realBody().extractContactFaceInPlane(Plane(ptEnd, vecZ), dEps));
				ppZ.vis(2);
			
			// Female Dove
				Dove dv1 (pt, vecX, vecY, vecZ, dXWidth, dYHeight, dZDepth + dAdditionalDepth, angle, nFemaleEndType);
				dv1.setAddKeyhole(nAddKey==1);
				female.addTool(dv1);			
	
				if (bIsButterfly)
				{ 
					Body bdMale = male.envelopeBody(false, true);
					Body bdFemale = female.envelopeBody(false, true);				
				// Get tooling body	
					Body bdA = bdMale;
					bdMale.addTool(dv0);  
					bdA.subPart(bdMale);
					bdA.addTool(Cut(ptX-vecZ*dEps, vecZ), 0);// catch tolerance issues
					bdTool.combine(bdA);
					
					Body bdB = bdFemale;
					bdFemale.addTool(dv1);
					bdB.subPart(bdFemale);
					bdB.addTool(Cut(ptX+vecZ*dEps, -vecZ), 0);// catch tolerance issues
					bdTool.combine(bdB);				
				}
	
			// KEYYHOLE
				double dX = dWidthKey > dEps ? dWidthKey : ppZ.dX();
				if (nAddKey>1 && dX>dEps)
				{ 
					BeamCut bc(pt, vecX, vecY, vecZ, dX, dHeightKey, 2*(dZDepth + dAdditionalDepth), 0, 1, 0);
					female.addTool(bc);
				}				
				pt+=vecX*dInterDistance;	
			}



	
		}
	
		
	//endregion 

//region Trigger Rotate
	String sTriggerRotate = T("|Rotate|");
	addRecalcTrigger(_kContextRoot, sTriggerRotate );
	if (_bOnRecalc &&(_kExecuteKey==sTriggerRotate|| _kExecuteKey==sDoubleClick))
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
	   	mapArgs.setPlaneProfile("shape", ppZ);	
		mapArgs.setDouble("Length", male.solidLength());

		mapArgs.setBody("body", male.envelopeBody());
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

	
	}
// END T- or E2E-Connection	
//endregion	


//region Parallel Connection (Butterfly only)
	else if (sConnection==tPConnection)
	{ 	

		

		Body bdMale = male.envelopeBody(false, true);
		Body bdFemale = female.envelopeBody(false, true);
		
	// Beam2Panel	
		if (bHasPanel)
		{ 
		// get potential connection directions on beam
			PlaneProfile pp = bdMale.shadowProfile(Plane(ptCen0, vecZ1));
			PLine rings[] = pp.allRings(true, false);		
			LineSeg segs[0];
			Point3d pts[0];
			if (rings.length() >0)
				pts= rings.first().vertexPoints(false);
			for (int i=0;i<pts.length()-1;i++) 
			{ 
				Point3d pt1= pts[i]; 
				Point3d pt2= pts[i+1];
				Vector3d vecXS = pt2 - pt1; 
				if (vecXS.length()<1.1*dXWidthTotal){ continue;}
				vecXS.normalize();
				
				LineSeg seg(pt1, pt2);
				Point3d ptm = (pt1 + pt2) * .5;
				
				
				Vector3d vecYS = vecXS.crossProduct(-vecZ1);
				if (pp.pointInProfile(ptm + vecYS * dEps) != _kPointOutsideProfile)
				{
					vecYS *= -1;
					seg = LineSeg (pt2, pt1);
				}
				//vecYS.vis(ptm, 2);
				segs.append(seg); 
			}//next i
			
		// Get panel edges	
			SipEdge edges[] = panel.sipEdges();
			
			
		// Get common edge
			LineSeg segCommon;
			double dMin = U(10e5);
			for (int i=0;i<segs.length();i++)
			{ 
				LineSeg seg = segs[i];
				Point3d pt1 = seg.ptStart();
				Point3d pt2 = seg.ptEnd();
				Vector3d vecXS = pt2-pt1; vecXS.normalize();
				Vector3d vecYS = vecXS.crossProduct(-vecZ1);
				pt1 += vecXS * .5*dXWidthTotal;
				pt2 -= vecXS * .5*dXWidthTotal;
				
				PlaneProfile pp0;
				pp0.createRectangle(LineSeg(pt1 - vecYS * dZDepth, pt2 + vecYS * dZDepth), vecXS, vecYS);
				for (int j=0;j<edges.length();j++) 
				{ 
					SipEdge edge = edges[j];

					Vector3d vecYE = edge.vecNormal();
					vecYE = vecYE.crossProduct(vecZ1).crossProduct(-vecZ1); vecYE.normalize();
					Vector3d vecXE = vecYE.crossProduct(vecZ1);
					
				// ignore if not inverseColinear
					if (!vecYS.isParallelTo(vecYE) || (vecYS.isParallelTo(vecYE) && vecYS.isCodirectionalTo(vecYE)))
					if (abs(vecYS.dotProduct(edge.ptMid()-seg.ptMid()))>dEps)
					{ 
						continue;
					}						 
					
				// ignore if not touching
					if (abs(vecYS.dotProduct(edge.ptMid()-seg.ptMid()))>dEps)
					{ 
						continue;
					}
				// accept if common length range
					PlaneProfile pp1;		pp1.createRectangle(LineSeg(edge.ptStart() - vecYS * dZDepth-vecXE*.5*dXWidthTotal, edge.ptEnd() + vecYS * dZDepth+vecXE*.5*dXWidthTotal), vecXS, vecYS);
					if (pp1.intersectWith(pp0))
					{ 
						LineSeg segC(pp1.ptMid() - vecXS * .5 * pp1.dX(), pp1.ptMid() + vecXS * .5 * pp1.dX());
						
						Point3d ptNext = segC.closestPointTo(_Pt0);
						double d = Vector3d(ptNext - _Pt0).length();
						if (d<dMin)
						{ 
							dMin = d;
							segCommon = segC;
						}
						pp1.vis(6);	vecYE.vis(edge.ptMid(), 4);vecYS.vis(seg.ptMid(), 3);
					}
				}//next i				
			}

			segCommon.vis(4);

		// valid common range
			if (segCommon.length())
			{ 
				vecX = segCommon.ptEnd() - segCommon.ptStart(); vecX.normalize();
				vecY = vecZ1;
				if(abs(dRotation-180)<dEps)
				{ 
					vecX *= -1;
					vecY *= -1;
				}
				vecZ = vecX.crossProduct(vecY);
				ptX = segCommon.closestPointTo(_Pt0);
				if (pp.pointInProfile(ptX+vecZ*dEps)==_kPointInProfile)
				{ 
					vecX *= -1;
					vecZ *= -1;
				}
				
				_Pt0 = ptX;
				//vecX.vis(ptX, 1);vecY.vis(ptX, 3);vecZ.vis(ptX, 150);

			// get common profile
				PlaneProfile pp0(CoordSys(ptX, vecX, vecY, vecZ));
				pp0.unionWith(bdMale.extractContactFaceInPlane(Plane(ptX, vecZ), dEps));
				PlaneProfile pp1 = bdFemale.extractContactFaceInPlane(Plane(ptX, vecZ), dEps);
				pp0.intersectWith(pp1);
				pp1.createRectangle(LineSeg(segCommon.ptStart() - vecY * U(10e3), segCommon.ptEnd() + vecY * U(10e3)), vecY, vecY);
				pp0.intersectWith(pp1);
				pp0.vis(4);
				
			// not touching
				if (pp0.area()<pow(dXWidth,2))
				{ 
					reportMessage(TN("|Could not find common range.|") + T(" |Tool will be deleted|"));					
					eraseInstance();
					return;
				}
			
				Point3d pts[] ={ ptCen1 - .5 * vecZ1 * female.dD(vecY), ptCen1 + .5 * vecZ1 * female.dD(vecY)};
				pts.append(ptCen0 - .5 * male.vecD(vecY) * male.dD(vecY));
				pts.append(ptCen0 + .5 * male.vecD(vecY) * male.dD(vecY));
				pts = Line(ptCen0, vecY).orderPoints(pts);
				
				
				Line(ptX, vecY).hasIntersection(Plane(pts.last(), vecY), ptTop);
				Line(ptX, vecY).hasIntersection(Plane(pts.first(), -vecY), ptBottom);
				
				double dYHeight = vecY.dotProduct(ptTop - ptBottom)- dOffset;
				
			// Male Dove
				nMaleEndType = vecX.isParallelTo(male.vecX())?_kFemaleSide:_kFemaleEnd;
				Dove dv0(ptTop, -vecX, vecY, -vecZ, dXWidth, dYHeight, dZDepth, 0, nMaleEndType);
				dv0.setContinuousMortise(abs(dOffset) < dEps);
				male.addTool(dv0, 0);
			
			// Female DOve
				Dove dv1(ptTop, vecX, vecY, vecZ, dXWidth, dYHeight, dZDepth, 0, _kFemaleSide);
				dv1.setContinuousMortise(abs(dOffset) < dEps);
				female.addTool(dv1, 0);				
				
			// Get tooling body	
				Body bdA = bdMale; //bdA.transformBy(-vecZ * dEps); // catch tolerance issues
				bdMale.addTool(dv0);
				bdA.subPart(bdMale);
				bdA.addTool(Cut(ptX-vecZ*dEps, vecZ), 0);// catch tolerance issues
				bdTool.combine(bdA);
				
				Body bdB = bdFemale;//bdB.transformBy(vecZ * dEps);// catch tolerance issues
				bdFemale.addTool(dv1);
				bdB.subPart(bdFemale);
				bdB.addTool(Cut(ptX+vecZ*dEps, -vecZ), 0);// catch tolerance issues
				bdTool.combine(bdB);
	
//				bdTool.transformBy(vecX * U(300));
//				bdTool.vis(4);				ptX.vis(3);
		
			}

		}	
		else
		{ 
			if ( !bIsParallel)
			{
				reportMessage(T("|Beams must be parallel.|") + T(" |Tool will be deleted|"));
				eraseInstance();
				return;
			}
		
			vecX = vecX0;
			vecZ = male.vecD(ptCen1 - ptCen0);
			vecY = vecX.crossProduct(-vecZ);
			if ( ! vecX.isParallelTo(_ZW) && vecY.dotProduct(_ZW) < 0)
			{
				vecX *= -1;
				vecY *= -1;
			}
			if(abs(dRotation-180)<dEps)
			{ 
				vecX *= -1;
				vecY *= -1;
			}

		// Get insertion point
			Plane pn(ptCen0 + vecZ * .5 * male.dD(vecZ), vecZ);
			if ( ! Line(_Pt0, vecZ).hasIntersection(pn, ptX))
			{
				reportMessage(T("|Invalid plane.|") + T(" |Tool will be deleted|"));
				eraseInstance();
				return;				
			}	
			

			Point3d pts[] ={ ptCen1 - .5 * vecZ1 * female.dD(vecY), ptCen1 + .5 * vecZ1 * female.dD(vecY)};
			pts.append(ptCen0 - .5 * male.vecD(vecY) * male.dD(vecY));
			pts.append(ptCen0 + .5 * male.vecD(vecY) * male.dD(vecY));
			pts = Line(ptCen0, vecY).orderPoints(pts);

		// get common profile
			PlaneProfile pp0(CoordSys(ptX, vecX, vecY, vecZ));
			pp0 = bdMale.extractContactFaceInPlane(pn, dEps);
			
			PlaneProfile pp1(CoordSys(ptX, vecX, vecY, vecZ));
			pp1 = bdFemale.extractContactFaceInPlane(pn, dEps);
			
			PlaneProfile ppCommon = pp0;
			ppCommon.intersectWith(pp1);
			
		// not touching
			if (ppCommon.area()<pow(dXWidth,2))
			{ 
				reportMessage(TN("|Could not find common range.|") + T(" |Tool will be deleted|"));					
				eraseInstance();
				return;
			}			
			ppCommon.vis(1);
			Line(ptX, vecY).hasIntersection(Plane(pts.last(), vecY), ptTop);
			Vector3d vecXD = vecX * .5 * (ppCommon.dX() - dXWidthTotal);
			LineSeg seg( ppCommon.ptMid() - vecXD, ppCommon.ptMid() + vecXD);
			seg.transformBy(vecY * vecY.dotProduct(ptTop-ppCommon.ptMid()));		//seg.vis(3);
			ptX = seg.closestPointTo(ptX);
			_Pt0 = ptX;
			vecX.vis(ptX, 1);vecY.vis(ptX, 3);vecZ.vis(ptX, 150);

			Line(ptX, vecY).hasIntersection(Plane(pts.last(), vecY), ptTop);
			Line(ptX, vecY).hasIntersection(Plane(pts.first(), -vecY), ptBottom);
			double dYHeight = vecY.dotProduct(ptTop - ptBottom)- dOffset;
			
		
		//region Dovetails
			nMaleEndType = vecX.isParallelTo(male.vecX())?_kFemaleSide:_kFemaleEnd;	
			Point3d pt = ptTop-vecX*(qty==2?.5*dInterDistance:0);
			
			for (int i=0;i<qty;i++) 
			{ 
				
			// Male Dove				
				Dove dv0(pt, -vecX, vecY, -vecZ, dXWidth, dYHeight, dZDepth, 0, nMaleEndType);
				dv0.setContinuousMortise(abs(dOffset) < dEps);
				male.addTool(dv0, 0);
			
			// Female Dove
				Dove dv1(pt, vecX, vecY, vecZ, dXWidth, dYHeight, dZDepth, 0, _kFemaleSide);
				dv1.setContinuousMortise(abs(dOffset) < dEps);
				female.addTool(dv1, 0);				
				
			// Get tooling body	
				Body bdA = bdMale;
				bdMale.addTool(dv0);  
				bdA.subPart(bdMale);
				bdA.addTool(Cut(ptX-vecZ*dEps, vecZ), 0);// catch tolerance issues
				bdTool.combine(bdA);
				
				Body bdB = bdFemale;
				bdFemale.addTool(dv1);
				bdB.subPart(bdFemale);
				bdB.addTool(Cut(ptX+vecZ*dEps, -vecZ), 0);// catch tolerance issues
				bdTool.combine(bdB);				
				
				//bdTool.transformBy((vecX +vecY)* U(300)); bdTool.vis(4);
				pt += vecX * dInterDistance;
			}//next i
		//endregion 
		
		}

	//region Trigger Rotate
		String sTriggerRotate = T("|Rotate|");
		addRecalcTrigger(_kContextRoot, sTriggerRotate );
		if ((_bOnRecalc &&(_kExecuteKey==sTriggerRotate|| _kExecuteKey==sDoubleClick)) ||_kNameLastChangedProp == sRotationName)
		{		
			if (abs(dRotation)<90)
				dRotation.set(180);
			else
				dRotation.set(0);

			setExecutionLoops(2);
			return;					
		}//endregion	


	}
	
//endregion


//region Display
	Display	dpModel(-1);
	dpModel.trueColor(lightblue);
	
	
	
	if (bIsButterfly)
	{
		dpModel.draw(bdTool);	
		dpModel.draw(PLine(_Pt0-vecZ*dZDepth,_Pt0+vecZ*dZDepth));
	}
	else
	{ 
		dpModel.draw(ppZ);
		dpModel.draw(PLine(ptTop, Line(ptTop, vecXC0).intersect(Plane(ptEnd, vecZ),0)));	
		LineSeg segs[] = ppZ.splitSegments(ppZ.extentInDir(vecY), true);
		dpModel.draw(segs);		
	}

//endregion 


// keep track of valid position for E2E
if (bIsEnd2End)
{
	_Map.setVector3d("vecPt0", _Pt0 - _PtW);
	
}
if (bIsParallel)
	addRecalcTrigger(_kGripPointDrag, "_Pt0");



	




#End
#BeginThumbnail
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
GK60OA^[@&RVU.1(^RXKH:*`,.V\.B*[2ZFNY)9$.1D5N444`?__9
`








#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS">
        <int nm="BREAKPOINT" vl="1048" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15221 supports beam/panel connections HSB-15028 new keyhole options" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="5/10/2022 2:12:17 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End