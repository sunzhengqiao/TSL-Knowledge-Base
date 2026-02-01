#Version 8
#BeginDescription
version value="1.2" date="17.10.2019" author="marsel.nakuci@hsbcad.com" 
add picture
cosmetic
initial

Select beams, select properties or catalog entry and press OK


This tsl creates Gerberverbinder GERG see
https://www.strongtie.de/products/detail/gerberverbinder/534
user selects all beams. A TSL instance will be created for every connection
where possible.
When no valid 2 beams are found for placing the connection,
a prompt will show up for clicking a point that will split the beam
plane from the point normal with first beam will split the beam
all beams in selection that are parallel with the first beam are also splitted
if possible the connection will be placed so that the connection better 
withstands the load from _ZW

With the custom command Swap Y-Z, the Y and Z vector of connection are swaped and
the connection is rotated 90degree to its X axis
With the custom command Swap X-(-X), the vector X of connection is swaped with -X
and the connection is mirrored to the YZ plane
#End
#Type O
#NumBeamsReq 1
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords gerb, gerw, GERG, connection, verbinder, simpson, strong-tie
#BeginContents
/// <History>//region
/// <version value="1.2" date="17.10.2019" author="marsel.nakuci@hsbcad.com"> add picture </version>
/// <version value="1.1" date="15mai2019" author="marsel.nakuci@hsbcad.com"> cosmetic </version>
/// <version value="1.0" date="18apr2019" author="marsel.nakuci@hsbcad.com"> initial version </version>
/// </History>

/// <insert Lang=en>
/// Select beams, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates Gerberverbinder GERG see
/// https://www.strongtie.de/products/detail/gerberverbinder/534
/// user selects all beams. A TSL instance will be created for every connection
/// where possible.
/// When no valid 2 beams are found for placing the connection,
/// a prompt will show up for clicking a point that will split the beam
/// plane from the point normal with first beam will split the beam
/// all beams in selection that are parallel with the first beam are also splitted
/// if possible the connection will be placed so that the connection better 
/// withstands the load from _ZW

/// With the custom command Swap X-(-X), the vector X of connection is swaped with -X
/// and the connection is mirrored to the YZ plane
///
/// </summary>

/// commands
// command to insert a G-connection
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "Simpson-Strong-Tie-GERG")) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Swap X-(-X)|") (_TM "|UserPrompt|"))) TSLCONTENT
//endregion

//region constants 
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
//end constants//endregion

//region properties
// type of connection
	String sTypes[] ={T("|Automatic|"),"GERG120/180-B", "GERG120/200-B", "GERG140/200-B", "GERG120/220-B", "GERG140/220-B", 
			"GERG160/220-B", "GERG120/240-B","GERG140/240-B","GERG160/240-B","GERG120/260-B","GERG140/260-B","GERG160/260-B"};
	String sTypeName=T("|Type|");	
	PropString sType(nStringIndex++, sTypes, sTypeName, 0);// by default GERB125
	sType.setDescription(T("|Defines the model of the connector|"));
	sType.setCategory(category);
	sType.setReadOnly(true); // only info and output
	
// gap 
	String sGapName=T("|Gap|");	
	PropDouble dGap(nDoubleIndex++, U(10), sGapName);	
	dGap.setDescription(T("|Defines the Gap|"));
	dGap.setCategory(category);
	
// nail pattern
	category = T("|Nailing|");
	String sNailPatterns[] ={ T("|Full Nailing|"), T("|Part Nailing|")};
	String sNailPatternName=T("|Nailing Pattern|");	
	PropString sNailPattern(nStringIndex++, sNailPatterns, sNailPatternName);	
	sNailPattern.setDescription(T("|Defines the nail pattern|"));
	sNailPattern.setCategory(category);
	
// Nail type
	String sNails[] = { "CNA4,0xl Kammnageln", "CSA5,0xl Schrauben"};
	String sNailName = T("|Nail type|");
	PropString sNail(nStringIndex++, sNails, sNailName);
	sNail.setDescription(T("|Defines the Nail type|"));
	sNail.setCategory(category);
	
//End properties//endregion 	
	
//region dimension values for each type of connections

// for each property store values
	double dAs[] ={ 0, U(182), U(202), U(202), U(222), U(222), U(222), 
					   U(242), U(242), U(242), U(262), U(262), U(262)};
	double dBs[] ={ 0, U(90), U(90), U(90), U(90), U(90), U(90),
					   U(90), U(90), U(90), U(90), U(90), U(90)};
	double dCs[] ={ 0, U(122), U(122), U(142), U(122), U(142), U(162),
					   U(122), U(142), U(162), U(122), U(142), U(162)};
	double dTs[] ={ 0, U(2), U(2), U(2), U(2), U(2), U(2), U(2)};
// nr of 5mm holes
	int nHoles[] ={ 52, 56, 56, 60, 60, 60, 
					60, 60, 60, 72, 72, 72};
// nr of nails for each type (total in both sides)
	int nFullNumAs[] = { 0, 20, 28, 28, 28, 28, 32, 32};
	int nHalfNumAs[] = { 0, 16, 16, 16, 16, 16, 16, 16};
	int nFullNumCs[] = { 0, 8, 8, 8, 8, 8, 8, 8};
// nail dimensions
	double dXNail[] ={ U(40), U(50), U(60)};// nail length
	double dYNail[] ={ U(4), U(4), U(4)};// nail width		
	
//End dimension values for each type of connections//endregion 


// bOnInsert//region
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		
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
		{
			sType.set(sTypes[0]);
			showDialog("---");
		}
		
	// prompt for beams
		PrEntity ssE(T("|Select beam(s)|"), Beam());
		if (ssE.go())
			_Beam.append(ssE.beamSet());
	//
		if(_Beam.length()<1)
		{ 
			reportMessage(TN("|Select at least one beam|"));
			eraseInstance();
			return;
		}
		
	// create TSL
		TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
		GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
		int nProps[]={};			double dProps[]={};				String sProps[]={};
		Map mapTsl;	
		mapTsl.setInt("mode", 1); //set tool mode
	// put the properties
		dProps.append(dGap);
		sProps.append(sType);
		sProps.append(sNailPattern);
		sProps.append(sNail);
		
	// find all valid pairs for connection
		Beam beams[0];
		beams.append(_Beam);// make a copy of all beams
		
		for (int i=0;i<_Beam.length();i++) 
		{ 
			if(!_Beam[i].bIsValid())
			{ 
				continue;
			}
			Beam bm0 = _Beam[i];
			Point3d ptCen = bm0.ptCenSolid();
			Vector3d vecX = bm0.vecX();
			Vector3d vecY = bm0.vecY();
			Vector3d vecZ = bm0.vecZ();
			double dX = bm0.solidLength();
			Line ln(ptCen, vecX);
			
			Body bm0Body = bm0.envelopeBody(true, true);
			Plane pnX(ptCen+U(100)*vecX, vecX);
			PlaneProfile ppbm0Sec = bm0Body.shadowProfile(pnX);
			LineSeg segBm0 = ppbm0Sec.extentInDir(vecY);
			Plane pnZ(segBm0.ptMid(), vecZ);
			segBm0.ptMid().vis(2);
			PlaneProfile ppbm0Z = bm0Body.getSlice(pnZ);
			ppbm0Z.vis(1);
			// points intersected with ln
			PLine pls[] = ppbm0Z.allRings(true, false); // not openings
			if(pls.length()<1)
			{ 
				if(bDebug)reportMessage("\n"+ scriptName() + "unexpected error 1 ");
				eraseInstance();
				return;
			}
			PLine pl = pls[0];
			Point3d pts[] = pl.intersectPoints(ln);// pline with line
			if(pts.length()<1)
			{ 
				if(bDebug)reportMessage("\n"+ scriptName() + "unexpected error 2 ");
				eraseInstance();
				return;
			}
			int iPaired = false;
			for (int j=beams.length()-1; j>=0 ; j--) 
			{ 
				if(!beams[j].bIsValid())
				{ 
					continue;
				}
				Beam bm1 = beams[j]; 
				Point3d ptCen1 = bm1.ptCenSolid();
				Vector3d vecX1 = bm1.vecX();
				Vector3d vecY1 = bm1.vecY();
				Vector3d vecZ1 = bm1.vecZ();
				double dX1 = bm1.solidLength();
				
				Body bm1Body = bm1.envelopeBody(true, true);
				Plane pnX1(ptCen1+U(100)*vecX1, vecX1);
				PlaneProfile ppbm1Sec = bm1Body.shadowProfile(pnX1);
				LineSeg segBm1 = ppbm1Sec.extentInDir(vecY1);
				Plane pnZ1(segBm1.ptMid(), vecZ1);
				segBm1.ptMid().vis(2);
				PlaneProfile ppbm1Z = bm1Body.getSlice(pnZ1);
				ppbm1Z.vis(1);
				
			// do tests
				// test if parallel
				if (!vecX.isParallelTo(vecX1))
				{ 
					if(bDebug)reportMessage("\n"+ scriptName() + "Beams are not parallel ");
					continue;
				}
				
				// test if in line
				if (abs(vecZ.dotProduct(ptCen-ptCen1))>dEps || abs(vecY.dotProduct(ptCen-ptCen1))>dEps)
				{ 
					if(bDebug)reportMessage("\n"+ scriptName() + "Beams are not on the same axis ");
					continue;
				}	
				 // test dimensions
				if (abs(bm0.dD(vecZ)-bm1.dD(vecZ))>dEps || abs(bm0.dD(vecY)-bm1.dD(vecY))>dEps)
				{ 
					if(bDebug)reportMessage("\n"+ scriptName() + "Beams are not of same section ");
					continue;
				}
				
			// get connection vector
				Vector3d vecXC = vecX;
				if (vecXC.dotProduct(ptCen1 - ptCen) < 0)vecXC *= -1;
				
			// points intersected with ln
				PLine pls1[] = ppbm1Z.allRings(true, false);
				if(pls1.length()<1)
				{ 
					if(bDebug)reportMessage("\n"+ scriptName() + "unexpected error 3 ");
					eraseInstance();
					return;
				}
				pl = pls1[0];
				Point3d pts1[] = pl.intersectPoints(ln);
				if(pts1.length()<1)
				{ 
					if(bDebug)reportMessage("\n"+ scriptName() + "unexpected error 4 ");
					eraseInstance();
					return;
				}
			// check gap
				Line lnXC(ptCen, vecXC);
				pts = lnXC.orderPoints(pts);
				pts1 = lnXC.orderPoints(pts1);
				Point3d pt0End = pts[pts.length() - 1];pt0End.vis(7);
				Point3d pt1Start = pts1[0];pt1Start.vis(7);
				if(((pt1Start-pt0End).length()-dGap)>dEps)
				{ 
					if(bDebug)reportMessage("\n"+ scriptName() + "Gap larger than the defined gap ");
					continue;
				}
				
			// all tests completed, generate TSL
				gbsTsl.setLength(0);
				gbsTsl.append(bm0);
				gbsTsl.append(bm1);
				iPaired = true;
			// create tsl
				tslNew.dbCreate(scriptName(), vecXTsl , vecYTsl, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
				
			}//next j
			if(iPaired)
			{ 
			// bm0 in "i" was paired with all, it is then removed from beams
				int iFound = beams.find(bm0);
				if(iFound>-1)
				{ 
					beams.removeAt(iFound);
					if(bDebug)reportMessage("\n"+ scriptName() + " found"+iFound);
				}
			}
		}//next i
		if(bDebug)reportMessage("\n"+ scriptName() + "_Beam.length() "+_Beam.length()+"beams.length() "+beams.length());
		
		if(_Beam.length()==beams.length())
		{ 
		// no pair found, prompt point selection
			
			//get Point	
			Point3d ptCut = getPoint(TN("|Select the Point|"));
			Beam bm0 = _Beam[0];
			Vector3d vecX = bm0.vecX();// only beams parallel to this one are considered
			Plane pnCut(ptCut, vecX);// cutting plane
			int nType = sTypes.find(sType);// type of connection
			if (nType < 0)nType = 0;
		// split beams with the plane
			for (int i=0;i<_Beam.length();i++) 
			{ 
				Beam bm1 = _Beam[i];
				Point3d ptCen1 = bm1.ptCenSolid();
				Vector3d vecX1 = bm1.vecX();
				Vector3d vecY1 = bm1.vecY();
				Vector3d vecZ1 = bm1.vecZ();
				double dX1 = bm1.solidLength();
				Line ln(ptCen1, vecX);
				
			// test if parallel
				if (!vecX.isParallelTo(vecX1))
				{ 
					reportMessage("\n"+ scriptName() + ": "+T("|Beams are not parallel.| "));
					continue;
				}
				
			// intersection point
				Point3d ptIntersect;
				int iHasIntersect = ln.hasIntersection(pnCut, ptIntersect);
				double dMin = dBs[nType];
				Point3d ptA = ptCen1 - (.5 * dX1-dMin) * vecX1;
				Point3d ptB = ptCen1 + (.5 * dX1-dMin) * vecX1;
				if (vecX1.dotProduct(ptIntersect-ptA)<0 || vecX1.dotProduct(ptIntersect-ptB)>0)
				{ 
				// point outside of beam boudaries
					continue;
				}
				
			// do the splitting
				Beam bmNew = bm1.dbSplit(ptCut, ptCut);
				ptsTsl[0] = ptCut;
				gbsTsl.setLength(0);// create an arrow pline
				gbsTsl.append(bm1);
				gbsTsl.append(bmNew);
			
			// create tsl
				tslNew.dbCreate(scriptName() , vecXTsl , vecYTsl, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
			}//next i
		}	
		eraseInstance();
		return;
	}	
// end on insert	__________________//endregion	
	
//region if no beam or only one in selection

// get beams and vecs
	if (_Beam.length()<2)
	{ 
		eraseInstance();
		return;
	}

//End if no beam or only one in selection//endregion 
	
		
		
//region avoid TSL dublication if entered twice at the same place

// avoid dublication of TSL for the same 2 beams in bondbcreated
		if(_bOnDbCreated)
		{ 
			Group grp;
			//bAlsoInSubGroups = true
			Entity arEnt[] = grp.collectEntities(true, TslInst(), _kModelSpace);
			for (int i=arEnt.length()-1; i>=0 ; i--) 
			{ 
				TslInst t=(TslInst)arEnt[i];
				if(t.scriptName()!=scriptName())
				{ 
					continue;
				}
			// see if t is connected to the same beams
				Beam beamTsl[] = t.beam();
				if(beamTsl.length()<2)
				{ 
					continue;
				}
				int iSame = true;
			// 2 cases when the same
			// beam 1,2 of Tsl and 1,2 of ThisInst
			// 1,2 and 2,1
				if(  (beamTsl[0]==_Beam[0] && beamTsl[1]==_Beam[1])
				   ||(beamTsl[0]==_Beam[1] && beamTsl[1]==_Beam[0]) )
				{
					eraseInstance();
					return;
				}
			}//next i
		}

//End avoid TSL dublication if entered twice at the same place//endregion 
	
//region general data

	Beam bm0 = _Beam[0], bm1 = _Beam[1];
// group assignment
	assignToGroups(bm0, 'I');
// set the type of nailing to deciding the posnum assignment
	String sCompareKey = scriptName() + sType + sNailPattern + sNail;
	setCompareKey(sCompareKey);
	
// bm0 vectors
	Point3d ptCen = bm0.ptCenSolid();
	Vector3d vecX = bm0.vecX();
	Vector3d vecY = bm0.vecY();
	Vector3d vecZ = bm0.vecZ();
	double dX = bm0.solidLength();
	Line ln(ptCen, vecX);
	vecX.vis(ptCen, 1);

// bm1
	Point3d ptCen1 = bm1.ptCenSolid();
	Vector3d vecX1 = bm1.vecX();
	Vector3d vecY1 = bm1.vecY();
	Vector3d vecZ1 = bm1.vecZ();
	double dX1 = bm1.solidLength();
	vecX1.vis(ptCen1, 1);

//End general data//endregion 

//region some validations

// test if parallel
	if (!vecX.isParallelTo(vecX1))
	{ 
		reportMessage("\n" + scriptName() + ": " + T("|Beams are not parallel.| ") + T("|Tool will be deleted.|"));
		eraseInstance();
		return;	
	}

// test if in line
	if (vecZ.dotProduct(ptCen-ptCen1)>dEps || vecY.dotProduct(ptCen-ptCen1)>dEps)
	{ 
		reportMessage("\n" + scriptName() + ": " + T("|Beams are not on the same axis.| ") + T("|Tool will be deleted.|"));
		eraseInstance();
		return;	
	}	
	
// test dimensions
	if (abs(bm0.dD(vecZ)-bm1.dD(vecZ))>dEps || abs(bm0.dD(vecY)-bm1.dD(vecY))>dEps)
	{ 
		reportMessage("\n" + scriptName() + ": " + T("|Beams are not of same section.| ") + T("|Tool will be deleted.|"));
		eraseInstance();
		return;	
	}
	
//End some validations//endregion 
	

//region orientation of the connection wrt _ZW

// get connection vector
	Vector3d vecXC = vecX;
	if (vecXC.dotProduct(ptCen1 - ptCen) < 0)vecXC *= -1;
	
	Vector3d vecYC = vecXC.crossProduct(-vecZ);
	Vector3d vecZC = vecXC.crossProduct(vecYC);
	
	if(vecZC.dotProduct(_ZW)<dEps)
	{ 
		vecYC *= -1;
		vecZC *= -1;
	}
	
	double dZ = bm0.dD(vecZC);
	double dY = bm0.dD(vecYC);
	
// the prefered vector should be the one closer with the _ZW coordinate
	Vector3d vecZW = bm0.vecD(_ZW);
	if(abs(vecZW.dotProduct(vecYC))>dEps)
	{ 
		vecYC = vecZC;
		vecZC=vecXC.crossProduct(vecYC);
		
		dY = bm0.dD(vecYC);
		dZ = bm0.dD(vecZC);
	}
	
//End orientation of the connection wrt _ZW//endregion 
	
	
//region get the connection type

// get model
	int nType;
	for (int i=1;i<dAs.length();i++) 
	{ 
		if(abs(dAs[i]-U(2)-dZ)<dEps)
		{
			// height fulfilled
			if(abs(dCs[i]-U(2)-dY)<dEps)
			{ 
				// width fulfilled
				nType=i;
				sType.set(sTypes[nType]);
				break;
			}
		}
	}//next i

//End get the connection type//endregion

//region swap X-(-X) trigger

	int iSwapX = _Map.getInt("swapX");
// Trigger SwapX//region
	String sTriggerSwapX = T("|Swap X-(-X)|");
	addRecalcTrigger(_kContext, sTriggerSwapX );
	if (_bOnRecalc && (_kExecuteKey==sTriggerSwapX || _kExecuteKey==sDoubleClick))
	{
		iSwapX =! iSwapX;
		_Map.setInt("swapX", iSwapX);
		setExecutionLoops(2);
		return;
	}//endregion

//End swap X-(-X) trigger//endregion 
		
		
//region if no type fits the beams geometry

// validate type
	if (nType<1)
	{ 
	// if no connection found for the direction aligned with _ZW then not valid
		reportMessage("\n"+ scriptName() + ": "+ T("|Invalid geometry| ")+T("|Tool will be deleted.|"));
		eraseInstance();
		return;	
	}		

//End if no type fits the beams geometry//endregion 
		
	
//region do the cut/stretch when _Pt0 of connection is moved
	
// get _Pt0
	int bSnap = _kNameLastChangedProp == "_Pt0";
	if (bSnap)
	{ 
		Point3d ptPrev = _Pt0;

	// test locaion against bm0
		double dMin= dBs[nType];
		Point3d ptA = ptCen - (.5 * dX-dMin) * vecXC;
		Point3d ptB = ptCen1 + (.5 * dX1-dMin) * vecXC;
		if (vecXC.dotProduct(_Pt0-ptA)<0 || vecXC.dotProduct(_Pt0-ptB)>0)
			bSnap = false;
	}		
	if (bSnap)
		_Pt0 = ln.closestPointTo(_Pt0);
	else
		{
		// middle point between 2 beams
			_Pt0 = .5 * (ptCen + .5 * dX * vecXC + ptCen1 - .5 * dX1 * vecXC);
		}
	vecXC.vis(_Pt0, 2);
	
// add cuts
	bm0.addToolStatic(Cut(_Pt0-vecXC*.5*dGap, vecXC), _kStretchOnToolChange);
	bm1.addToolStatic(Cut(_Pt0+vecXC*.5*dGap, -vecXC), _kStretchOnToolChange);
	
//End do the cut/stretch when _Pt0 of connection is moved//endregion 
	
//region generate connection

// get values, dimensions
	double dA = dAs[nType];
	double dB = dBs[nType];
	double dC = dCs[nType];
	double dT = dTs[nType];
// nail numbers

// set shape
	PLine plShape(vecYC);
	Point3d pt = _Pt0 - vecXC * dB - vecZC * .5 * dZ;
	plShape.addVertex(pt);		pt += vecXC * dB;
	plShape.addVertex(pt);		pt += vecZC * dA/3;
	plShape.addVertex(pt);		pt += vecZC * dA/3+vecXC*dB;
	plShape.addVertex(pt);		pt += vecZC * dA/3;
	plShape.addVertex(pt);		pt -= vecXC * dB;
	plShape.addVertex(pt);		pt -= vecZC * dA/3;
	plShape.addVertex(pt);		pt -= vecZC * dA/3+vecXC*dB;		
	plShape.addVertex(pt);		plShape.close();
	plShape.vis(6);
	
// group assignement
	assignToLayer("I");
	assignToGroups(Entity(bm0));
// build metal part
	Body bdTotal;
	Body bdLeft(plShape, vecYC * dT, 1);
//		bdLeft.addPart(Body(_Pt0-vecZC*.5*dZ+vecYC*dT, vecXC, vecYC, vecZC, dB, dC, dT,-1,-1,-1));
	bdLeft.addPart(Body(_Pt0 + vecZC * .5 * dZ + vecYC * dT, vecXC, vecYC, vecZC, dB, dC/3.0, dT, 1 ,- 1, 1));
	
	bdLeft.transformBy(vecYC * .5 * dY);
	bdLeft.vis(3);

	Body bdRight = bdLeft;
	CoordSys csMirr;
	csMirr.setToMirroring(Plane(_Pt0, vecYC));
	bdRight.transformBy(csMirr);
	bdRight.vis(3);
	
// bottom plate
	PLine plShapeBottom(vecZC);
	pt = _Pt0 - dB * vecXC - (.5 * dC + dT) * vecYC;
	pt.vis(2);
	plShapeBottom.addVertex(pt);	pt += vecXC * dB;
	plShapeBottom.addVertex(pt);	pt += vecYC * .25*(dC+2*dT);
	plShapeBottom.addVertex(pt);	pt += vecXC * (dT + U(2)); Point3d ptRefBottom = pt;
	plShapeBottom.addVertex(pt);	pt += vecYC * .5*(dC+2*dT);
	plShapeBottom.addVertex(pt);	pt -= vecXC * (dT + U(2));
	plShapeBottom.addVertex(pt);	pt += vecYC * .25*(dC+2*dT);
	
//		plShapeBottom.addVertex(pt);	pt += vecYC * (dC+2*dT);
	plShapeBottom.addVertex(pt);	pt -= vecXC * dB;
	plShapeBottom.addVertex(pt);	pt -= vecYC * (2.0 / 9.0) * dC + vecYC * dT;
	plShapeBottom.addVertex(pt);	pt += -(1.0 / 9.0) * vecYC * dC + (1.0 / 6.0) * vecXC * 2 * dB;
	plShapeBottom.addVertex(pt);	pt -= vecYC * (3.0 / 9.0) * dC;
	plShapeBottom.addVertex(pt);	pt+=-(1.0 / 9.0) * vecYC * dC - (1.0 / 6.0) * vecXC * 2 * dB;
	plShapeBottom.addVertex(pt);	plShapeBottom.close();
	plShapeBottom.vis(3);
	
	Body bdBottom(plShapeBottom, vecZC * dT, 1);
	csMirr.setToMirroring(Plane(_Pt0, vecZC));
	bdBottom.transformBy(csMirr);
	bdBottom.transformBy(-vecZC * .5 * dZ);
	bdBottom.vis(3);
	
	PLine plShapeBehind(vecX);
	pt = ptRefBottom;
	plShapeBehind.addVertex(pt); pt += vecYC * (.125 * (dC + 2 * dT)) + vecZC * U(30);
	plShapeBehind.addVertex(pt); pt += vecYC * (.25 * (dC + 2 * dT));
	plShapeBehind.addVertex(pt); pt += vecYC * (.125 * (dC + 2 * dT)) - vecZC * U(30);
	plShapeBehind.addVertex(pt); plShapeBehind.close();
	plShapeBehind.vis(3);
	
	Body bdBehind(plShapeBehind, - vecXC, 1);
	bdBehind.transformBy(-vecZC * .5 * dZ);
	bdBehind.vis(3);
	
// Display
	Display dp(252);
	bdTotal.addPart(bdLeft);
	bdTotal.addPart(bdBottom);
	bdTotal.addPart(bdBehind);
	bdTotal.addPart(bdRight);
	
// swapping in X
	if(iSwapX)
	{ 
		csMirr.setToMirroring(Plane(_Pt0, vecXC));
		bdTotal.transformBy(csMirr);
//			bdLeft.transformBy(csMirr);
//			bdRight.transformBy(csMirr);
	}
	
	dp.draw(bdTotal);
//		dp.draw(bdLeft);
//		dp.draw(bdRight);

//End generate connection//endregion 

// Hardware//region

// collect existing hardware
	HardWrComp hwcs[] = _ThisInst.hardWrComps();
	
// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
	for (int i=hwcs.length()-1; i>=0 ; i--) 
		if (hwcs[i].repType() == _kRTTsl)
			hwcs.removeAt(i); 

// declare the groupname of the hardware components
	String sHWGroupName;
	// set group name
	{ 
	// element
		// try to catch the element from the parent entity
		Element elHW =bm0.element(); 
		if (elHW.bIsValid()) 	
			sHWGroupName=elHW.elementGroup().name();
	// loose
		else
		{
			Group groups[] = _ThisInst.groups();
			if (groups.length()>0)
				sHWGroupName=groups[0].name();
		}		
	}
	
// add main componnent
	{ 
		HardWrComp hwc(sType, 1); // the articleNumber and the quantity is mandatory
		
		hwc.setManufacturer("Simpson StrongTie");
		
		hwc.setModel(sType);
		//hwc.setName(sHWName);
		//hwc.setDescription(sHWDescription);
		hwc.setMaterial("S 250 GD +Z 275 gemäß DIN EN 10346");
		//hwc.setNotes(sHWNotes);
		
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(bm0);	
		hwc.setCategory(T("|Connector|"));
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		
		hwc.setDScaleX(dB*2);
		hwc.setDScaleY(dA);
		hwc.setDScaleZ(dC);
		
	// apppend component to the list of components
		hwcs.append(hwc);
	}			

// add nail componnents
	{
		int nPatternNail = sNailPatterns.find(sNailPattern);// nail pattern
		int nNail = sNails.find(sNail);// nail type
		if (nPatternNail < 0)nPatternNail = 0;
		int iQuantity;
		if(nPatternNail==0)
		{ 
		// Full pattern
			iQuantity = nFullNumAs[nType] + nFullNumCs[nType];
		}
		else if(nPatternNail==1)
		{ 
		// partly distribution
			iQuantity = nHalfNumAs[nType];
		}
		
		HardWrComp hwc(sNail, iQuantity); // the articleNumber and the quantity is mandatory
		
		hwc.setManufacturer("Simpson StrongTie");
		hwc.setModel(sNail);
		hwc.setQuantity(iQuantity);
		
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(bm0);	
		hwc.setCategory(T("|Nail|"));
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		
		hwc.setDScaleX(dXNail[nNail]);
		hwc.setDScaleY(dYNail[nNail]);
		hwc.setDScaleZ(0);
	// apppend component to the list of components
		hwcs.append(hwc);
	}

// make sure the hardware is updated
	if (_bOnDbCreated)
		setExecutionLoops(2);
		
	_ThisInst.setHardWrComps(hwcs);	

//End hardware//endregion 
#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_X0!F17AI9@``34T`*@````@`!@$2``,`
M```!``$```,!``4````!````5@,#``$````!`````%$0``$````!`0```%$1
M``0````!```.Q%$2``0````!```.Q````````8:@``"QC__;`$,``@$!`@$!
M`@("`@("`@(#!0,#`P,#!@0$`P4'!@<'!P8'!P@)"PD("`H(!P<*#0H*"PP,
M#`P'"0X/#0P."PP,#/_;`$,!`@("`P,#!@,#!@P(!P@,#`P,#`P,#`P,#`P,
M#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#/_``!$(`2P!
MD`,!(@`"$0$#$0'_Q``?```!!0$!`0$!`0```````````0(#!`4&!P@)"@O_
MQ`"U$``"`0,#`@0#!04$!````7T!`@,`!!$%$B$Q008346$'(G$4,H&1H0@C
M0K'!%5+1\"0S8G*""0H6%Q@9&B4F)R@I*C0U-C<X.3I#1$5&1TA)2E-45597
M6%E:8V1E9F=H:6IS='5V=WAY>H.$A8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJ
MLK.TM;:WN+FZPL/$Q<;'R,G*TM/4U=;7V-G:X>+CY.7FY^CIZO'R\_3U]O?X
M^?K_Q``?`0`#`0$!`0$!`0$!`````````0(#!`4&!P@)"@O_Q`"U$0`"`0($
M!`,$!P4$!``!`G<``0(#$00%(3$&$D%1!V%Q$R(R@0@40I&AL<$)(S-2\!5B
M<M$*%B0TX27Q%Q@9&B8G*"DJ-38W.#DZ0T1%1D=(24I35%565UA96F-D969G
M:&EJ<W1U=G=X>7J"@X2%AH>(B8J2DY25EI>8F9JBHZ2EIJ>HJ:JRL[2UMK>X
MN;K"P\3%QL?(R<K2T]35UM?8V=KBX^3EYN?HZ>KR\_3U]O?X^?K_V@`,`P$`
M`A$#$0`_`/W\HHHH`**"<"D5LF@!:***`"BBB@`HHHH`****`"BBB@`HHHH`
M***&.!0`44WS*56R:`%HH8X%-\R@!U%-\S_.:4%MQX&WL<]:`%HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***``C(INRG,<"F[Z`#91LH5LFG4`-V4;*5VVBF^<*`%V4;*3S<TI?B@`*4U
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
'@5O45('_V0``

#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End