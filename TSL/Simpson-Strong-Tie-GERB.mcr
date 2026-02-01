#Version 8
#BeginDescription
version value="1.7" date="15mai2019" author="marsel.nakuci@hsbcad.com"
cosmetic
only connections aligned with _ZW are supported
setCompareKey as combination of scriptName() + sType + sNailPattern
avoid dublication of TSL for the same 2 beams
fix bug when beams selected in a continuous chain + add swap x-(-x)
check gap for skew splits of beams
initial

Select beams, select properties or catalog entry and press OK

This tsl creates Gerberverbinder GERB see
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
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 7
#KeyWords gerberverbinder,connection,beam,GERB, strongtie
#BeginContents
/// <History>//region
/// <version value="1.7" date="15mai2019" author="marsel.nakuci@hsbcad.com"> cosmetic </version>
/// <version value="1.6" date="11apr2019" author="marsel.nakuci@hsbcad.com"> only connections aligned with _ZW are supported </version>
/// <version value="1.5" date="11apr2019" author="marsel.nakuci@hsbcad.com"> setCompareKey as combination of scriptName() + sType + sNailPattern </version>
/// <version value="1.4" date="10apr2019" author="marsel.nakuci@hsbcad.com"> avoid dublication of TSL for the same 2 beams </version>
/// <version value="1.3" date="10apr2019" author="marsel.nakuci@hsbcad.com"> fix bug when beams selected in a continuous chain + add swap x-(-x) </version>
/// <version value="1.2" date="04apr2019" author="marsel.nakuci@hsbcad.com"> check gap for skew splits of beams </version>
/// <version value="1.1" date="04apr2019" author="marsel.nakuci@hsbcad.com"> include sugsstions from HSB-4759 </version>
/// <version value="1.0" date="28mar2019" author="marsel.nakuci@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select beams, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates Gerberverbinder GERB see
/// https://www.strongtie.de/products/detail/gerberverbinder/534
/// user selects all beams. A TSL instance will be created for every connection
/// where possible.
/// When no valid 2 beams are found for placing the connection,
/// a prompt will show up for clicking a point that will split the beam
/// plane from the point normal with first beam will split the beam
/// all beams in selection that are parallel with the first beam are also splitted
/// if possible the connection will be placed so that the connection better 
/// withstands the load from _ZW

/// With the custom command Swap Y-Z, the Y and Z vector of connection are swaped and
/// the connection is rotated 90degree to its X axis
/// With the custom command Swap X-(-X), the vector X of connection is swaped with -X
/// and the connection is mirrored to the YZ plane
///
/// </summary>

/// commands
// command to insert a G-connection
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "Simpson-Strong-Tie-GERB")) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Swap Y-Z|") (_TM "|UserPrompt|"))) TSLCONTENT
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
	String sTypes[] ={T("|Automatic|"),"GERB125", "GERB150", "GERB160", "GERB175", "GERB180", "GERB200-DE", "GERB220"};
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
	String sNails[] = { "CNA4,0x40", "CNA4,0x50", "CNA4,0x60"};
	String sNailName = T("|Nail type|");
	PropString sNail(nStringIndex++, sNails, sNailName);
	sNail.setDescription(T("|Defines the Nail type|"));
	sNail.setCategory(category);
	
//End properties//endregion 	
	
//region predefined dimensions for each type

// for each property store values
	double dAs[] ={ 0, U(129), U(154), U(160), U(179), U(180), U(201), U(220)};
	double dBs[] ={ 0, U(90), U(90), U(90), U(90), U(90), U(90), U(90)};
	double dCs[] ={ 0, U(27), U(29), U(30), U(33), U(33), U(33), U(34)};
	double dTs[] ={ 0, U(2), U(2), U(2), U(2), U(2), U(2), U(2)};
	
// nr of nails for each type (total in both sides)
	int nFullNumAs[] = { 0, 20, 28, 28, 28, 28, 32, 32};
	int nHalfNumAs[] = { 0, 16, 16, 16, 16, 16, 16, 16};
	int nFullNumCs[] = { 0, 8, 8, 8, 8, 8, 8, 8};
// nail dimensions
	double dXNail[] ={ U(40), U(50), U(60)};// nail length
	double dYNail[] ={ U(4), U(4), U(4)};// nail width

//End predefined dimensions for each type//endregion 

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
	
//region if no beam or only one beam, connection not possible

// get beams and vecs
	if (_Beam.length()<2)
	{ 
		eraseInstance();
		return;
	}

//End if no beam or only one beam, connection not possible//endregion 	

//region avoid duplication of TSL in dbcreate, if entered twice at the same place
		
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

//End avoid duplication of TSL if entered twice at the same place//endregion 

//region general data for the 2 beams
	
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
	
//End general data for the 2 beams//endregion 
	
//region some checks of the 2 beams

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
	
//End some checks of the 2 beams//endregion 
	
//region connection vector from beam[0] to beam[1]

// get connection vector
	Vector3d vecXC = vecX;
	if (vecXC.dotProduct(ptCen1 - ptCen) < 0)vecXC *= -1;
	
	Vector3d vecYC = vecXC.crossProduct(-vecZ);
	Vector3d vecZC = vecXC.crossProduct(vecYC);
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
//End connection vector from beam[0] to beam[1]//endregion 
	
//region find model of the connection

// get model of connection
	int nType;
	for (int i=1;i<dAs.length();i++) 
	{ 
		if(abs(dAs[i]-dZ)<dEps)
		{
			nType=i;
			sType.set(sTypes[nType]);
			break;
		}
	}//next i

//End find model of the connection//endregion 	

//region trigger to swap X-(-X)

	int iSwapX = _Map.getInt("swapX");
// Trigger SwapX//region
	String sTriggerSwapX = T("../|Swap X-(-X)|");
	addRecalcTrigger(_kContext, sTriggerSwapX );
	if (_bOnRecalc && (_kExecuteKey==sTriggerSwapX || _kExecuteKey==sDoubleClick))
	{
		iSwapX =! iSwapX;
		_Map.setInt("swapX", iSwapX);
		setExecutionLoops(2);
		return;
	}//endregion	

//End trigger to swap X-(-X)//endregion 

//region if no type found for the beams

// validate type
	if (nType<1)
	{ 
	// if no connection found for the direction aligned with _ZW then not valid
		reportMessage("\n"+ scriptName() + ": "+ T("|Invalid geometry| ")+T("|Tool will be deleted.|"));
		eraseInstance();
		return;
	}
	
//End if not type found for the beams//endregion 		
	

//region cut/stretch beams according to where Pt0 is
	
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

//End cut/stretch beams according to where Pt0 is//endregion 
	
//region connection

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
		Body bdLeft(plShape, vecYC * dT, 1);
		bdLeft.addPart(Body(_Pt0-vecZC*.5*dZ+vecYC*dT, vecXC, vecYC, vecZC, dB, dC, dT,-1,-1,-1));
		bdLeft.addPart(Body(_Pt0+vecZC*.5*dZ+vecYC*dT, vecXC, vecYC, vecZC, dB, dC, dT,1,-1,1));
		
		bdLeft.transformBy(vecYC * .5 * dY);
		bdLeft.vis(3);

		Body bdRight = bdLeft;
		CoordSys csMirr;
		csMirr.setToMirroring(Plane(_Pt0, vecYC));
		bdRight.transformBy(csMirr);
		bdRight.vis(3);

	// swapping in X
		if(iSwapX)
		{ 
			csMirr.setToMirroring(Plane(_Pt0, vecXC));
			bdLeft.transformBy(csMirr);
			bdRight.transformBy(csMirr);
		}
	// Display
		Display dp(252);
		dp.draw(bdLeft);
		dp.draw(bdRight);
		
//End connection//endregion 
		
//region Hardware
	
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
		
//End Hardware//endregion 

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
M`A$#$0`_`/W\HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****``C-)L%+10`449S1NQ0`FP4H&*-U&:`
M`C--9?2D<[ONFOGSXL>&_CYX>\07EUX=U'0?&V@SS&2/3I-ND:A9)V1)>8YO
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
J]?2GPZ\/S>$/A]H>DW#127&EZ?;VDC1DE&:.-4)7(!QD<9`K<HJ;@?_9



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
        <int nm="BREAKPOINT" vl="567" />
      </lst>
    </lst>
  </lst>
  <lst nm="TslInfo">
    <lst nm="TSLINFO">
      <lst nm="TSLINFO" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End