#Version 8
#BeginDescription
version value="1.5" date="06jul2020" author="thorsten.huck@hsbcad.com"
HSB-7730 removal of support only on context command doubleclick, sloped support display alignment adjusted
adding a support creates an instance which displays the support. 

HSB-5591 bugfix vertical/horizontal on windows
HSB-5591 new insertion mode 'byLine' added 

This tsl creates supporting crosspieces on openings and doors.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 5
#KeyWords CLT;Opening;Door;Crosspiece;Bridge;Transport;Support
#BeginContents
//region Part #1
//region History
/// <History>
/// <version value="1.5" date="06jul2020" author="thorsten.huck@hsbcad.com"> HSB-7730 removal of support only on context command doubleclick, sloped support display alignment adjusted </version>
/// <version value="1.4" date="03jul2020" author="thorsten.huck@hsbcad.com"> HSB-7730 adding a support creates an instance which displays the support.  </version>
/// <version value="1.3" date="21may2020" author="thorsten.huck@hsbcad.com"> HSB-5591 bugfix vertical/horizontal on windows </version>
/// <version value="1.2" date="11may2020" author="thorsten.huck@hsbcad.com"> HSB-5591 new insertion mode 'byLine' added </version>
/// <version value="1.1" date="30apr2020" author="thorsten.huck@hsbcad.com"> HSB-5591 initial </version>
/// </History>

/// <insert Lang=en>
/// Select panels, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates supporting crosspieces on openings and doors. 
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCLT-OpeningSupport")) TSLCONTENT
//endregion

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
//end Constants//endregion


// distinguish modes
	int nMode = _Map.getInt("mode"); // 0 = distribution/creation , 1 = single support
	int nc = 253, nt = 80;
//End Part #1//endregion 

//region Creation mode #2
if (nMode==0)
{ 
//region Properties
	category = T("|Geometry|");
	String sWidthName=T("|Width|");	
	PropDouble dWidth(nDoubleIndex++, U(200), sWidthName);	
	dWidth.setDescription(T("|Defines the width of the support perpendicular to the supporting direction.|"));
	dWidth.setCategory(category);
	
	String sAlignmentName=T("|Alignment|");	
	String sAlignments[] = { T("|Automatic|"), T("|Horizontal|"), T("|Vertical|")};
	PropString sAlignment(nStringIndex++, sAlignments, sAlignmentName);	
	sAlignment.setDescription(T("|Defines the Alignment fo the support.|") + T(" |Automatic will place the support perpendicular to the open direction in door edge/mode.|") + T("|In window mode automatic will support perpendicular to the largest opening dimension|"));
	sAlignment.setCategory(category);	
	
	String sOffsetName=T("|Offset|");	
	PropDouble dOffset(nDoubleIndex++, U(0), sOffsetName);	
	dOffset.setDescription(T("|Defines the offset from center (opening) or edge (door) perpendicular to the selected alignment|"));
	dOffset.setCategory(category);	
	
	category = T("|Filter|");
	String sTypeName=T("|Opening Mode|");	
	String sTypes[] ={ T("|All|"), T("|bySelection|"), T("|Window|"), T("|Door/Edge|"), T("|byLine|")};
	PropString sType(nStringIndex++, sTypes, sTypeName);	
	sType.setDescription(T("|Filters openings by type or selection.|"));
	sType.setCategory(category);

	String sMinDimensionName=T("|Min. Dimension|");	
	PropDouble dMinDimension(nDoubleIndex++, U(0), sMinDimensionName);	
	dMinDimension.setDescription(T("|Defines the minmal size of the opening perpendicular to the selected alignment|"));
	dMinDimension.setCategory(category);
			
//End Properties//endregion 

//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		String sKey = _kExecuteKey;
		sKey.makeUpper();
		if (sKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			if (sEntries.findNoCase(sKey,-1)>-1)			
				setPropValuesFromCatalog(sKey);
			else
				showDialog();					
		}		
		else	
			showDialog();
		
	// get mode
		int nType = sTypes.find(sType, 0);
		
	// by selection	
		if (nType==1)
		{ 
			Sip sip = getSip();
			_Sip.append(sip);
			Point3d ptCen = sip.ptCenSolid();
			
		// prompt for point input
			PrPoint ssP(TN("|Select opening by a point inside or on the opening|")); 
			while(1)
			{ 
				if (ssP.go()==_kOk) 
					_PtG.append(ssP.value()); // append the selected points to the list of grippoints _PtG	
				else
					break;
			}

		}
	// by Line	
		else if (nType==4)
		{ 
			Sip sip = getSip();
			_Sip.append(sip);
			Point3d ptCen = sip.ptCenSolid();
			
		// prompt for point input
			_PtG.append(getPoint(TN("|Pick start point of support|")));
			PrPoint ssP(TN("|Pick end point of support|"),_PtG[0]); 
			if (ssP.go()==_kOk) 
				_PtG.append(ssP.value()); // append the selected points to the list of grippoints _PtG	
			else
			{ 
				eraseInstance();
				return;
			}
		}		
		else
		{ 
		
		// prompt for sips
			Entity ents[0];
			PrEntity ssE(T("|Select panels|"), Sip());
			if (ssE.go())
				ents.append(ssE.set());
			for (int i=0;i<ents.length();i++) 
			{ 
				Sip sip= (Sip)ents[i];
				if (
				sip.bIsValid())
					_Sip.append(sip);
				 
			}//next i
					
		}
		
		if (bDebug)_Pt0 = getPoint();
		
		return;
	}	
// end on insert	__________________//endregion	

// create TSL
	TslInst tslNew;
	int bForceModelSpace = true;	
	String sCatalogName = sLastInserted;
	String sExecuteKey;
	String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
	GenBeam gbsTsl[1];			Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
	int nProps[]={nc,nt};		double dProps[]={};				String sProps[]={};
	Map mapTsl;	
	mapTsl.setInt("mode", 1);

	int bCatalogEntry = TslInst().getListOfCatalogNames(scriptName() + "-Display").length() > 0;

// loop all sips	
	for (int s=0;s<_Sip.length();s++) 
	{ 
		Sip sip= _Sip[s]; 
		
	//region Get Standards
	// standards
		Point3d ptCen = sip.ptCenSolid();
		Vector3d vecX = sip.vecX(), vecY=sip.vecY(), vecZ=sip.vecZ();
		Plane pnZ(ptCen, vecZ);
		CoordSys cs = sip.coordSys();
		
		int nType = sTypes.find(sType);
		int nAlignment = sAlignments.find(sAlignment, 0);
		
		PLine plEnvelope = sip.plEnvelope();
		
	// get openings
		PlaneProfile ppSipReal = sip.realBody().shadowProfile(pnZ);
		PlaneProfile ppSip = ppSipReal;
		ppSip.removeAllOpeningRings();
		LineSeg segSip = ppSip.extentInDir(vecX);
		PLine plOpenings[0];
		if (nType!=3)
			plOpenings= sip.plOpenings();
		Vector3d vecDirections[plOpenings.length()];// keep arrays in sync: zeroLength = window
	
	// bounding max profile		
		PlaneProfile ppMax(cs);
		PLine plMax;
		plMax.createRectangle(segSip, vecX, vecY);
		ppMax.joinRing(plMax, _kAdd);
		ppMax.subtractProfile(ppSip);		
	//End Get Standards//endregion 	
	
	//region//Get door openings
		if (nType!=2 && nType!=4) // not window and not byLine
		{ 
			PLine rings[] = ppMax.allRings(true, false);
			for (int r=0;r<rings.length();r++) 
			{ 
				PLine pl = rings[r];
				pl.vis(2);
		
				PlaneProfile pp(cs);
				pp.joinRing(pl,_kAdd);
				LineSeg seg = pp.extentInDir(vecX);
				double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
				double dY = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
				
				Point3d ptMid = seg.ptMid();
				
				Point3d pts[] = { ptMid - vecX * .5 * dX, ptMid + vecX * .5 * dX, ptMid - vecY * .5 * dY, ptMid + vecY * .5 * dY};
				
			// refuse openings with multiple free directions
				int bOk=true;
				int nFree;
				Vector3d vecDir;
				for (int i=0;i<pts.length();i++) 
				{ 
					if (plMax.isOn(pts[i]) && pl.isOn(pts[i]))
					{
						if ((nAlignment == 2 && i < 2) || (nAlignment == 1 && i >1))bOk = false;
						pts[i].vis(bOk);
						vecDir = pts[i] - ptMid;
						nFree++;
					}	 
				}//next i
				if (nFree !=1 || !bOk)continue;
		
				plOpenings.append(pl);
				vecDirections.append(vecDir); // 1 = horizontal, 2 = vertical
				
				pl.vis(r);
			// door type openings have only one free direction in their XY plane
		
				
			}//next r
			
		}
			
	//End // get door openings//endregion 	
	
	//region Remove openings not selected when in bySelection mode
		if (nType==1 && _PtG.length()>0)
		{ 
			for (int i=0;i<_PtG.length();i++) 
				_PtG[i]+=_ZU*_ZU.dotProduct(ptCen-_PtG[i]); 

			for (int i=plOpenings.length()-1; i>=0 ; i--)
			{ 
				PlaneProfile pp(cs);
				pp.joinRing(plOpenings[i], _kAdd);	
				
				int bFound;
				for (int p=0;p<_PtG.length();p++) 
				{ 
					if (pp.pointInProfile(_PtG[p])!=_kPointOutsideProfile)
					{
						bFound = true;
						break; 
					}
					 
				}//next p
				
				if (!bFound)
				{ 
					pp.extentInDir(vecX).vis(40);
					plOpenings.removeAt(i);
					vecDirections.removeAt(i);
				}
			}
		}
	//End Remove openings not slected when in bySelection mode//endregion 

	//region Add support by line, points should be on existing contour
		else if (nType==4)
		{ 
			PlaneProfile ppOpening(cs);
			for (int i=0;i<plOpenings.length();i++) 
				ppOpening.joinRing(plOpenings[i], _kAdd);
				
		// project grips	
			for (int i=0;i<_PtG.length();i++) 
				_PtG[i]+=vecZ*vecZ.dotProduct(ptCen-_PtG[i]); 
			
		// declare list of potential supports
			PLine plSupports[0];
			
		// get direction	
			Vector3d vecDir = _PtG[1] - _PtG[0];
			vecDir.normalize();
			Vector3d vecPerp = vecDir.crossProduct(-vecZ);		
			
		// get outside split segments	
			LineSeg seg(_PtG[0]-vecDir*dEps,_PtG[1]+vecDir*dEps);
			LineSeg segs[] = ppSipReal.splitSegments(seg, false);
			for (int i=0;i<segs.length();i++) 
			{ 
				Point3d ptMid = segs[i].ptMid();
				int bIsWindow = ppOpening.area() > pow(dEps,2) && ppOpening.pointInProfile(ptMid) != _kPointOutsideProfile;
				
				
			// skip if test dir dimension below given min Width
				Vector3d vecDim = abs(vecDir.dotProduct(vecX))>abs(vecDir.dotProduct(vecY))?vecX : vecY;
				double dTestDim = abs(vecDim.dotProduct(segs[i].ptStart() - segs[i].ptEnd()));
				if (dMinDimension>0 && dTestDim<dMinDimension)
				{ 
					segs[i].vis(1);
					continue;
				}
				segs[i].vis(3);
				
//				// check if this instance is the creator of multiple	
//					if (plOpenings.length() == 1)bIsDistribution = false;
				
				
			// create support within an existing opening
				if (bIsWindow)
				{ 
				// find opening : test each opening ring
					for (int r=0;r<plOpenings.length();r++) 	
					{ 
						PlaneProfile ppOp(plOpenings[r]);
						if (ppOp.pointInProfile(ptMid)!=_kPointOutsideProfile)	
						{ 
						// create support shape
							PLine pl;
							pl.createRectangle(LineSeg(_PtG[0]-vecDir *U(10e3)-vecPerp*.5*dWidth, _PtG[1]+vecDir*U(10e3)+vecPerp*.5*dWidth), vecDir, vecPerp);
							pl.transformBy(vecPerp * dOffset);	
	
							PlaneProfile ppX = ppOp;
							ppX.intersectWith(PlaneProfile(pl));
							
						// make sure the shape will intersect the panel shape	
							PlaneProfile ppX2 = ppX;
							ppX2.transformBy(-vecDir * dEps);
							ppX.unionWith(ppX2);//ppX.vis(2);

						// test rings against opening intersection and create support	
							PLine ringsX[] = ppX.allRings(true, false);
							for (int q=0;q<ringsX.length();q++) 
							{ 
								PlaneProfile pp(ringsX[q]);
								pp.intersectWith(ppOp);
								if (pp.area()>pow(dEps,2))
								{ 
									if (!bDebug)
									{
										gbsTsl[0] = sip;
										ptsTsl[0]=ppX.extentInDir(vecDir).ptMid();
										sip.addRing(ringsX[q]);
										
										tslNew.dbCreate(scriptName() , vecDir ,vecPerp,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);		
										if (bCatalogEntry && tslNew.bIsValid())
											tslNew.setPropValuesFromCatalog(sLastInserted);
													
									}
									else
										ringsX[q].vis(2);
									break;
								}	 
							}//next q

						}
					}
				}
			// add support and create new opening by it
				else
				{ 
				// based on the split segment create a small rectangle and merge with existing shape	
					LineSeg _seg(segs[i].ptStart() - (vecDir + vecPerp) * dEps, segs[i].ptEnd() + (vecDir + vecPerp) * dEps);
					PLine pl;
					pl.createRectangle(_seg, vecDir, vecPerp);	//pl.vis(3);
					PlaneProfile ppTest = ppSip;
					ppTest.joinRing(pl, _kAdd);
					
				// find openings of merged shape: test each opening ring	
					PLine rings[] = ppTest.allRings(false, true);
					for (int r=0;r<rings.length();r++) 
					{ 
						PlaneProfile ppOp(rings[r]);//ppOp.vis(2);
					// get side relative to defining segment	
						Vector3d vecSide = vecPerp;
						if (ppOp.pointInProfile(ptMid+vecPerp*3*dEps)!=_kPointInProfile)
							vecSide *= -1;
						vecSide.vis(ptMid,2);	
						
					// create support shape
						pl.createRectangle(LineSeg(_PtG[0]-vecDir *U(10e3), _PtG[1]+vecDir*U(10e3)+vecSide*dWidth), vecDir, vecPerp);
						pl.transformBy(vecSide * dOffset);
						pl.vis(1);
						PlaneProfile ppX = ppMax;
						ppX.intersectWith(PlaneProfile(pl));
						
					// make sure the shape will intersect the panel shape	
						PlaneProfile ppX2 = ppX;
						ppX2.transformBy(-vecDir * dEps);
						ppX.unionWith(ppX2);
					
					// test rings against opening intersection and create support	
						PLine ringsX[] = ppX.allRings(true, false);
						for (int q=0;q<ringsX.length();q++) 
						{ 
							PlaneProfile pp(ringsX[q]);
							pp.intersectWith(ppOp);
							if (pp.area()>pow(dEps,2))
							{ 
							// get the midpoint of the new opening
								PlaneProfile _ppOp = ppOp;
								_ppOp.joinRing(ringsX[q], _kSubtract);
								_ppOp.vis(6);
								_ppOp.extentInDir(vecDir).ptMid().vis(6);
								
								if (!bDebug)
								{
									gbsTsl[0] = sip;
									ptsTsl[0]=ppX.extentInDir(vecDir).ptMid();
									sip.addRing(ringsX[q]);
									tslNew.dbCreate(scriptName() , vecDir ,vecPerp,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);		
									if (bCatalogEntry && tslNew.bIsValid())
										tslNew.setPropValuesFromCatalog(sLastInserted);

								}
								else
								{ 
									ringsX[q].vis(2);
								}
									
								break;
							}	 
						}//next q
					}//next r 					
				}

			}//next i


			if (!bDebug)eraseInstance();
			return;
		}
	//End Add support by line//endregion 
	
	//region Add support for all applicable openings
	// exclude openings not matching the minimal size
		for (int i=plOpenings.length()-1; i>=0 ; i--) 
		{ 
			PlaneProfile pp(cs);
			pp.joinRing(plOpenings[i], _kAdd);
			LineSeg seg = pp.extentInDir(vecX);
			LineSeg segSupport;
 
			double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
			double dY = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
			
			Point3d ptLoc = seg.ptMid();
			Vector3d vecDir = vecDirections[i];
			double dDir;
			if(vecDir.bIsZeroLength())
			{ 
				if (nAlignment==0)//automatic
				{ 
					dDir = dX>=dY?dX:dY;
					vecDir = dX>=dY?vecX:vecY;						
				}				
				else if (nAlignment==1)//horizontal
				{ 
								
					dDir = dX;
					vecDir = vecX;						
				}
				else if (nAlignment==2)// vertical
				{ 
					dDir = dY;
					vecDir = vecY;		
				}
				
				ptLoc += vecDir * dOffset;
			}
			else
			{ 
				dDir = vecDir.length();
				vecDir.normalize();
				ptLoc += vecDir * (dDir - .5*dWidth-dOffset);
			}
	
			if (dDir < dMinDimension)
			{
				pp.vis(1);
				continue;
			}

			pp.vis(3);
			seg.vis(3);
			
		//region Add Support	
			dX += dEps;
			dY += dEps;
			ptLoc.vis(4);
			PLine plSupport;
			int bIsHorizontal = vecDir.isParallelTo(vecX);
			if (bIsHorizontal)
				segSupport = LineSeg(ptLoc - .5 * (vecX * dWidth + vecY *dY) , ptLoc + .5 * (vecX * dWidth + vecY * dY));			
			else
				segSupport = LineSeg(ptLoc - .5 * (vecX * dX + vecY * dWidth), ptLoc + .5 * (vecX * dX + vecY * dWidth));	


			plSupport.createRectangle(segSupport, vecX, vecY);
			plSupport.vis(2);
			if (!bDebug)
			{
				gbsTsl[0] = sip;
				ptsTsl[0]=PlaneProfile(plSupport).extentInDir(vecDir).ptMid();
				sip.addRing(plSupport);
				tslNew.dbCreate(scriptName() , vecX ,vecY,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);		
				if (bCatalogEntry && tslNew.bIsValid())
					tslNew.setPropValuesFromCatalog(sLastInserted);
			}
			
		//End Add Support//endregion 		
		}//next i
			
	//End Add support for all applicable openings//endregion 
				 
	}//next s
		

// non resident tsl, purge
	if (!bDebug)
	{ 
		eraseInstance();
		return;
	}	

}
//End Creation mode//endregion 

//region Single Support Mode #3
else if (nMode==1)
{ 
	setOPMKey("Display");
	
//bDebug = true;
//region Properties
	category = T("|Display|");
	
	String sColorName=T("|Color|");	
	PropInt nColor(nIntIndex++, nc, sColorName);	
	nColor.setDescription(T("|Defines the Color|"));
	nColor.setCategory(category);
	
	String sTransparencyName=T("|Transparency|");	
	PropInt nTransparency(nIntIndex++, nt, sTransparencyName);	
	nTransparency.setDescription(T("|Defines the Transparency|"));
	nTransparency.setCategory(category);	
	
//End Properties//endregion 

//region Standards
// validate, only one panel allowed
	Sip sip;
	if (_Sip.length()<1)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|This tool requires at least one panel|"));
		eraseInstance();
		return;
	}
	else
		sip = _Sip[0];	

// standards	
	Vector3d vecX = sip.vecX(), vecY=sip.vecY(), vecZ=sip.vecZ();
	CoordSys cs = sip.coordSys();
	Point3d ptCen = sip.ptCenSolid();
	Plane pnRef(ptCen - vecZ * .5 * sip.dH(), vecZ);
	
	PLine plOpenings[]= sip.plOpenings();
	PlaneProfile ppShadow = sip.envelopeBody(false,true).shadowProfile(pnRef);	
	for (int i=0;i<plOpenings.length();i++) ppShadow.joinRing(plOpenings[i],_kSubtract); 		//ppShadow.vis(1);
	
	assignToGroups(sip, 'I');
	
//End Standards//endregion 	

//region Keep track of the opening to which the support has been added to
// check if an opening has been appended or removed
	int nNumOpening = plOpenings.length();
	int nNumOpeningPrev;
	int bGetOpeningIndex;
	int nIndex = -1;
	if (_Map.hasInt("index"))
	{
		nIndex = _Map.getInt("index");						if (bDebug)reportMessage(("\nStored opening index = ")+nIndex);	
	}
	else
	{
		bGetOpeningIndex = true;							if(bDebug)reportMessage(("\nRequest GetOpeningIndex set to true with index ")+nIndex + " and " + nNumOpening + " openings");
	}

	if (_Map.hasInt("numOpening"))
	{ 
		nNumOpeningPrev= _Map.getInt("numOpening");
		bGetOpeningIndex = nNumOpeningPrev != nNumOpening;	if(bDebug)reportMessage(("\nPrevious amount of openings= ")+nNumOpeningPrev + " vs current " +nNumOpening);		
	}
	
	if (bGetOpeningIndex || nIndex<0)
	{ 
		int index = -1;
		double dMin = U(10e4);
	//find nearest opening	
		for (int i=0;i<plOpenings.length();i++) 
		{ 
			PLine plOpening= plOpenings[i];
			Point3d ptNext = plOpening.closestPointTo(_Pt0);
			double d = Vector3d(ptNext - _Pt0).length();
			if (d<dMin)	{dMin = d;index = i;}	 
		}//next i
	
	// index found
		if (index>-1)
		{ 
		// the new opening is not accessible during creation	
			//if(!_bOnDbCreated)
			{ 	
				_Pt0 = plOpenings[index].closestPointTo(_Pt0);	
				_Map.setVector3d("vecRef", _Pt0 - sip.ptRef());
				if (bDebug)reportMessage(("\nsnapping to index ")+index + " and " + nNumOpening + " openings");
			}
//			else if (bDebug)										
//				reportMessage(("\ndo not snap on create with ")+index + " and " + nNumOpening + " openings");
			
			_Map.setInt("index", index);
			_Map.setInt("numOpening", nNumOpening);
			setExecutionLoops(2);
			return;
		}
	}
	
	PLine plOpening;
	if(nIndex>-1 && nIndex<plOpenings.length())
	{ 
		plOpening = plOpenings[nIndex];
		LineSeg seg = PlaneProfile(plOpening).extentInDir(vecX);
		seg.vis(nIndex);
	}
	else
	{ 
		double dMin = U(10e4);
		for (int i=0;i<plOpenings.length();i++) 
		{ 
			PLine _plOpening= plOpenings[i];

			Point3d ptNext = _plOpening.closestPointTo(_Pt0);
			double d = Vector3d(ptNext - _Pt0).length();
			if (d<dMin)
			{
				dMin = d;
				plOpening = _plOpening;
			}	 
		}//next i			
	}
//End Keep track of the opening to which the support has been added to//endregion 

//region Keep track of the position relative to ptRef
	Point3d ptRef = sip.ptRef();
	if (_Map.hasVector3d("vecRef"))
	{ 
		Vector3d vecRef = _Map.getVector3d("vecRef");
		Vector3d _vecRef = _Pt0 - ptRef;
		if (!vecRef.isCodirectionalTo(_vecRef) || vecRef.length()!=_vecRef.length())
			_Pt0 = ptRef + vecRef;
	}
	else
	{ 
		 _Map.setVector3d("vecRef", _Pt0 - ptRef);
	}	
//End Keep track of the position relative to ptRef//endregion 
	
//region Get opening edge from edges
	SipEdge edge,edge2, edges[]=sip.sipEdges();	
	double dMin = U(10e4);
	int nEdge1 = -1;
	for (int i=0;i<edges.length();i++) 
	{ 
		SipEdge e= edges[i];
		PLine pl = e.plEdge();
		double d = Vector3d(pl.closestPointTo(_Pt0)-_Pt0).length();//e.ptMid()
		if (d<dMin)
		{ 
			dMin = d;
			edge = e;
			nEdge1 = i;
		}	 
	}//next i
	PLine plEdge = edge.plEdge();
	Point3d ptMidE1 = edge.ptMid();
	Vector3d vecNormal = edge.vecNormal().crossProduct(vecZ).crossProduct(-vecZ);
	vecNormal.normalize();					vecNormal.vis(ptMidE1, 2);
	
	double dMin1 = U(10e4);
	double dMin2 = U(10e4);
	int nEdge2 = -1;
	for (int i=0;i<edges.length();i++) 
	{ 
		if (i == nEdge1)continue;
		SipEdge e= edges[i];
		
		Vector3d vecXE = e.ptEnd() - e.ptStart();vecXE.normalize();
		Vector3d vecZE = vecXE.crossProduct(e.vecNormal());
		Point3d pt = e.ptMid();				
		Line(pt, vecZE).hasIntersection(pnRef, pt);//e.vecNormal().vis(pt, plOpening.isOn(pt));

	// ignore segments on same ring
		if (plOpening.isOn(pt)){continue;}
	
		Point3d ptMidE2 = e.ptMid();

		double d1 = Vector3d(ptMidE1-e.plEdge().closestPointTo(ptMidE1)).length();
		double d2 = Vector3d(ptMidE2-plEdge.closestPointTo(ptMidE2)).length();
		if (d1<dMin1 && d2<dMin2)
		{ 
			edge2 = e;
			dMin1 = d1;
			dMin2 = d2;
		}
	}

	Vector3d vecNormal2 = edge2.vecNormal().crossProduct(vecZ).crossProduct(-vecZ);
	vecNormal2.normalize();					vecNormal2.vis(edge2.ptMid(), 2);		
//End Get opening edges//endregion 

//region Get support contour and Display
// get orthogonal direction
	Vector3d vecPerp = - vecNormal;
	//if (!vecNormal.isParallelTo(vecNormal2))
	{ 
	// project edge midpoint to shadwow
		SipEdge e= edge2;
		Vector3d vecXE = e.ptEnd() - e.ptStart();vecXE.normalize();
		Vector3d vecZE = vecXE.crossProduct(e.vecNormal());
		Point3d pt = e.ptMid();				
		Line(pt, vecZE).hasIntersection(pnRef, pt);//e.vecNormal().vis(pt, plOpening.isOn(pt));

	// test free directions
		int bHasFreeDir;
		Point3d pts[] = Line(pt,vecX).orderPoints(ppShadow.intersectPoints(Plane(pt, vecY), true, true),dEps);
		//for (int i=0;i<pts.length();i++) pts[i].vis(i); 

	// door/edge style test in vecX
		if (pts.length()>0)
		{
			if (abs(vecX.dotProduct(pts.first() - pt)) < dEps) 
			{
				vecPerp = -vecX;
				bHasFreeDir = true;
			}
			else if (abs(vecX.dotProduct(pts.last() - pt)) < dEps)
			{
				vecPerp = vecX;
				bHasFreeDir = true;
			}
		}
		if (!bHasFreeDir)
		{
			pts= Line(pt,vecY).orderPoints(ppShadow.intersectPoints(Plane(pt, vecX), true, true),dEps);
			//for (int i=0;i<pts.length();i++) pts[i].vis(i); 
			if (pts.length()>0)
			{ 
			if (abs(vecY.dotProduct(pts.first() - pt)) < dEps) 
			{
				vecPerp = -vecY;
				bHasFreeDir = true;
			}
			else if (abs(vecY.dotProduct(pts.last() - pt)) < dEps)
			{
				vecPerp = vecY;
				bHasFreeDir = true;
			}
			}			
		}
		
		if (!bHasFreeDir)
		{ 
			vecPerp = abs(vecNormal.dotProduct(vecX)) > abs(vecNormal.dotProduct(vecY)) ? vecX : vecY;
			if (vecNormal.dotProduct(vecPerp) > 0)vecPerp *= -1;			
		}

		
	}
	vecPerp.vis(ptMidE1, 1);
	Vector3d vecDir = vecPerp.crossProduct(vecZ);
	
// create support contour
	PLine pl1(edge.ptStart(),edge.ptEnd(),edge.ptEnd()+vecPerp * U(10e4),edge.ptStart()+vecPerp * U(10e4));
	PLine pl2(edge2.ptStart(),edge2.ptEnd(),edge2.ptEnd()-vecPerp * U(10e4),edge2.ptStart()-vecPerp * U(10e4));
	PlaneProfile pp1(pl1);
	PlaneProfile pp2(pl2);
	PlaneProfile ppContour = pp1;
	ppContour.intersectWith(pp2);
	
// give up
	if (ppContour.area()<pow(dEps,2))
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|could not find any support area.|"));
		eraseInstance();
		return;
	}
	
// draw	
	Display dp(nColor);
	dp.draw(ppContour, _kDrawFilled, nTransparency);		
//End Get support contour and Display//endregion 

//region Trigger RemoveSupport
	String sTriggerRemoveSupport = T("../|Remove Support|");
	addRecalcTrigger(_kContext, sTriggerRemoveSupport );
	if (_bOnRecalc && (_kExecuteKey == sTriggerRemoveSupport))
	{
		PlaneProfile pp(cs);
		pp.joinRing(plOpening,_kAdd); 
		PLine rings[] = ppContour.allRings(true, false);
		for (int i=0;i<rings.length();i++) 
			pp.joinRing(rings[i],_kAdd); 
		pp.shrink(-dEps);
		pp.shrink(dEps);
		
		rings = pp.allRings(true, false);
		for (int i=0;i<rings.length();i++)
			sip.addOpening(rings[i], false);
		eraseInstance();
		return;
	}//endregion	

}
//End Single Support Mode//endregion 



#End
#BeginThumbnail
M_]C_X``02D9)1@`!`@``9`!D``#_[``11'5C:WD``0`$````9```_^X`#D%D
M;V)E`&3``````?_;`(0``0$!`0$!`0$!`0$!`0$!`0$!`0$!`0$!`0$!`0$!
M`0$!`0$!`0$!`0$!`0("`@("`@("`@("`P,#`P,#`P,#`P$!`0$!`0$"`0$"
M`@(!`@(#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#
M`P,#`P,#`P,#_\``$0@!+`&0`P$1``(1`0,1`?_$`-D``0`"`P$!`0$!`0``
M```````'"08("@4$`0,""P$!``(#`0$!``````````````8'`@4(!`,!$```
M!@(!`00%"`<%!0<%`0```0(#!`4&!P@1$A.V."$4M#9W%75V-[=XN`DQ(G,U
M%A>'02/6EUA1,E88V&%",R0E&9E2U9;7F`H1``(!`@,"!0X'"PD'!0$````!
M`@,$$04&(0<Q$C)S-4%187&!D;$B$W2T-G8W4K+"LQ1U"*'10F*2(\,T1%2%
MP8*#Q-05E1<X\/%RTC-3).%#8T46HO_:``P#`0`"$0,1`#\`[^``````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M``````!&&RMT:MU!'K7=BYK48]-O7)$?%\<ZR;;-<TG14H6]4X'@=''L\TSR
M\2AQ)E!IH$Z8HC+HT8PJ5*=*#J591C!=5M)=]F4(3J2XE-.4WU$L60+*W7O3
M8Z31J76,+5>-R8Z'(NR>0<>6]?/$XZMV/+H>/^)7%=D<JOG0$$E19/DF&6]<
M^Z7>U;W=K:5&[W5-E0QA:IUJG7X(]][7W%@^N;RUR"ZJX2KM4X=^7>X%W7W#
M`[[16)V\1[(-\;-V-LVUC+9F1\DRO85GK^DPZQBOM3*VXU]B^L)>`8?@&34$
MEH_DS((44LLBMF:56SJE+6N*W6HLRJS\HZGDH)XI1V+NX[7VFVNP2"WR6QI1
MXG$X\FN&6U]SK=S;V3&]2<B<CQG=^N-&'L&1O37^QK/+:"@S#*JEBGV3@=M0
MX1EFQH%9;9141J^BVMBZZ7$)=;'DO5%7=Q#:CO3K&]?D2)+<AT_J9YI<?0:L
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
MXH-+21(-;$)YY9K5W;2>THS,_28DR22P6Q(T;;;Q?"92/T_`````````````
M```````````````````````````````````````````````````JXV9YGMW?
M,&HO#]T*QUQTA2YGY4B=:6_4ZG._)1J3G_OA=_MV/8XPKZIRV2^')1APP,@`
M``QBUS&BJKJMQ8GI]UF=TPN518#B--<YIL*_B,NDU*FT6!8E`NLNMZ^`HS5*
MDQX;D>(TE3CZVVT*6GVV677V8S\G94IU'U<%L7;D]B[K1Y;F]M;.''N:D8+L
MO:^TN%]Q&RFO>'O*':?<3+R!CW&_$G^PX<O-RA;'VU-C&?9<:A8!B%^S@^)*
MFQG2>B6%CDEG*B.()N90F9J0B<Y=H.;PJ9I5P7P(;7W9/9WD^PR*WNK(K&%A
M3Q?PI\'<BMO?:[1OWJ7@GQ[U59U>5S*&SVWL>H?1,@;+W/.B9OD=79-D;;=K
MB5$BMJ=<ZULRBDEEQ[%J*C5(0GJ]WCBW%KG=AE.79;'BV5*,'U^&3[<GBWVL
M<"*7>87E]+C7-24EUN!+M);/N&XPV)XP````````````````````````````
M````````````````````````````````````````JXV9YGMW?,&HO#]T*QUQ
MTA2YGY4B=:6_4ZG._)1J3G_OA=_MV/8XPKZIRV2^')1AJE)0E2UJ)*4D:E*4
M9)2E*2ZFI1GT(B(B])C`R/*P=W+=QR%0]!:^RC=/9>G0WLIQ9N%7:GJYU>OU
M:;&M]PY#*K-?N3*F>M#4^LJIEMD$4E&HJUSLJ(2++M+9OF.$XT_)4'^%/Q5A
MV%RGV,%AV337N?9=98Q<^/57X,-O??`NZ\>P;R:\_+IS#(5Q[+D1MDX%>IV.
M^_JG04BSH:MQDF>ZG4F3[MNX4#8V209+Q=^Q+QJMU_81NO=*=>2DUN3W+M$Y
M9:83O&[BMV?%A^2GB^ZVGUB)7NJ+ZXQC;)4:?8VR[[X.XD^R6&ZHTCJ31E&]
MCNI->XQ@==-<9D6[E'7-MV^26##:VTW.79"_W^09AD#I.*-VQM)4N<^M:E..
MJ4I1G,*=*G1@J=&,84UP)))+M);".3G.I)SJ-RF^%MXM]UDIC,Q`````````
M````````````````````````````````````````````````````````````
M```T3Y`<=-G6&>W&ZM+W5)>7-U18_4YIJ#-S14564,XF5FBLM<"S^OB/3<-S
M!<"U6T]'MHMM36AQ8C254IG+L'8[GNGJ6<I55-PNH1P3X8M<.#7#P]5=YFZR
MG.*F6MTW%2MY/%K@:?!BG_(^^C2:MX^<J-TY382:S53.BZ!Z8B/89=O6UHIU
MC!4TAJ'+5C&M-891E$S.)%5+C.M.IG7N+5LTB2_7V,N,XVZJ'6FA+VM5<K^I
M&E2QX(^-)^!)/J/:^ND2.XU7;4X*-I"4ZF'#+Q4O"WAW%V3<#77Y<>DJ8HMG
MNF5<<DLC0B,MZ)LQJ$UJ>)+9?]>Z5&D:AMG`IT:'9I0_7R,D:R6[KU,M=W9&
MM';.<9=I[*<LPE;TDZR_#EXTNXWL7\U(BUYG&87V*K5&J;_!CLCWNKW6S?\`
MCQX\..Q$B,,Q8L5EJ/&C1VD,1X\=A"6F6&&6DI;999;224I21)2DB(BZ#=FK
M/[``````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
>`````````````````````````````````````__9


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