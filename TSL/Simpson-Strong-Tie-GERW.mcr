#Version 8
#BeginDescription
#Versions:
1.2 01.09.2023 HSB-19908: On "Automatic" selection the TSL will consider the recommended gap value of 20mm; Type can now be freely changed manually 
version value="1.1" date="17.10.2019" 
add picture

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords simpson, strong-tie, gerb, gerg, gerw, connector
#BeginContents
/// <History>//region
///#Versions:
// 1.2 01.09.2023 HSB-19908: On "Automatic" selection the TSL will consider the recommended gap value of 20mm; Type can now be freely changed manually Author: Marsel Nakuci
/// <version value="1.1" date="17.10.2019" author="marsel.nakuci@hsbcad.com"> add picture </version>
/// <version value="1.0" date="15may2019" author="marsel.nakuci@hsbcad.com"> initial version </version>
/// </History>

/// <insert Lang=en>
/// Select beams, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates Gerberverbinder GERW see
/// https://www.strongtie.de/products/detail/gerberverbinder/539
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
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "Simpson-Strong-Tie-GERW")) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Swap Z-(-Z)|") (_TM "|UserPrompt|"))) TSLCONTENT
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
	String sTypes[] ={T("|Automatic|"),"GERW90", "GERW120", "GERW140", "GERW160", "GERW180", 
						"GERW200", "GERW220","GERW240","GERW260","GERW280","GERW300","GERW320",
						"GERW340", "GERW360", "GERW380", "GERW400", "GERW420"};
	
	String sTypeName=T("|Type|");	
	PropString sType(nStringIndex++, sTypes, sTypeName, 0);// by default GERB125
	sType.setDescription(T("|Defines the model of the connector|"));
	sType.setCategory(category);
//	sType.setReadOnly(true); // only info and output
	
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
	
//region dimension values for each type of connections

// for each property store values
	double dAs[] ={ 0, U(90), U(120), U(140), U(160), U(180), U(200), 
					   U(220), U(240), U(260), U(280), U(300), U(320),
					   U(340), U(360), U(380), U(400), U(420)};
	double dBs[] ={ 0, U(140), U(180), U(180), U(180), U(180), U(180),
					   U(180), U(180), U(180), U(180), U(180), U(180),
					   U(180), U(180), U(180), U(180), U(180)};
// parameter C is constant 20 for all types
	double dC = U(20);
// parameter T is constant 2 for all types
	double dT = U(2);
// nr of nails for each type (total in both sides)
	int nFullNumAs[] = { 0, 20, 56, 68, 80, 92, 104, 116, 128, 140,  
							152, 164, 176, 188, 200, 212, 224, 236};
	int nHalfNumAs[] = { 0, 12, 36, 44, 52, 60, 68, 76, 84, 92, 
							100, 108, 116, 124, 132, 140, 148, 156};
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
	// HSB-19908: Recommended gap between connector and beam height
	double dGapRecommended=U(20);
	int nType;
	nType=sTypes.find(sType);
	if(nType==0)
	{ 
	// Automatic is selected
	//	for (int i=1;i<dAs.length();i++) 
		for (int i=dAs.length()-1; i>=0 ; i--) 
		{ 
	//		if(abs(dAs[i]-dZ)<dEps)
			if((dZ-dAs[i])>=dGapRecommended)
			{
				nType=i;
				sType.set(sTypes[nType]);
				break;
			}
		}//next i
	}
	
	nType=sTypes.find(sType);
//End find model of the connection//endregion 	

//region trigger to swap X-(-X)

	int iSwapZ = _Map.getInt("swapZ");
// Trigger SwapX//region
	String sTriggerSwapX = T("../|Swap Z-(-Z)|");
	addRecalcTrigger(_kContext, sTriggerSwapX );
	if (_bOnRecalc && (_kExecuteKey==sTriggerSwapX || _kExecuteKey==sDoubleClick))
	{
		iSwapZ =! iSwapZ;
		_Map.setInt("swapZ", iSwapZ);
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
		Point3d ptA = ptCen - (.5 * dX - dMin) * vecXC;
		Point3d ptB = ptCen1 + (.5 * dX1 - dMin) * vecXC;
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
// nail numbers
	
// set shape
	PLine plShape(vecYC);
	Point3d pt = _Pt0 - vecXC * .5 * dB - vecZC * .5 * dZ;
	plShape.addVertex(pt);	pt += vecXC * dB;
	plShape.addVertex(pt);	pt += vecZC * dA; plShape.vis(2);
	plShape.addVertex(pt);	pt -= vecXC * dB; plShape.vis(2);
	plShape.addVertex(pt); plShape.vis(2);
	plShape.addVertex(pt);	plShape.close(); plShape.vis(2);
//	plShape.vis(6);
	
// group assignement
	assignToLayer("I");
	assignToGroups(Entity(bm0));
// build metal part
	Body bdLeft(plShape, vecYC * dT, 1);
	bdLeft.addPart(Body(_Pt0 - vecZC * .5 * dZ + vecYC * dT, vecXC, vecYC, vecZC, dB, dC, dT ,0 ,- 1 ,- 1));
	
	bdLeft.transformBy(vecYC * .5 * dY);
//	bdLeft.vis(3);
	
	Body bdRight = bdLeft;
	CoordSys csMirr;
	csMirr.setToMirroring(Plane(_Pt0, vecYC));
	bdRight.transformBy(csMirr);
//	bdRight.vis(3);
	
// swapping in X
	if(iSwapZ)
	{ 
		csMirr.setToMirroring(Plane(_Pt0, vecZC));
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
		
		hwc.setDScaleX(dB);// horizontal length
		hwc.setDScaleY(dA);// vertical length
		hwc.setDScaleZ(dC);// horizontal width
		
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
			iQuantity = nFullNumAs[nType];
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
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
"_]D`


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
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19908: On &quot;Automatic&quot; selection the TSL will consider the recommended gap value of 20mm; Type can now be freely changed manually" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="9/1/2023 1:17:28 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End