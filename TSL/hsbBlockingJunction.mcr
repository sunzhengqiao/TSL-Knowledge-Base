#Version 8
#BeginDescription
#Versions
Version 1.4 18.08.2021 HSB-12839 tsl version conflicts resolved, merged 1.2 of 12aug2021 , Author Thorsten Huck
Version 1.3 17.08.2021 HSB-12159 debug display removed , Author Thorsten Huck
Version 1.2 16.08.2021 HSB-12159 new offset properties added , Author Thorsten Huck

version value="1.1" date="28oct2020" author="thorsten.huck@hsbcad.com"> 
HSB-9299 element plugin insertion fixed




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
#KeyWords 
#BeginContents
//region Part #1
/// <History>//region
// #Versions
// 1.4 18.08.2021 HSB-12839 tsl version conflicts resolved, merged 1.2 of 12aug2021 , Author Thorsten Huck
// 1.3 17.08.2021 HSB-12159 debug display removed , Author Thorsten Huck
// Version 1.2 16.08.2021 HSB-12159 new offset properties added , Author Thorsten Huck
/// <version value="1.1" date="28oct2020" author="thorsten.huck@hsbcad.com"> HSB-9299 element plugin insertion fixed </version>
/// <version value="1.0" date="27oct2020" author="thorsten.huck@hsbcad.com"> HSB-9299 supports element plugin insertion, beam based insertion fixed, jig only visible in view direction </version>
/// <version value="0.2" date="27oct2020" author="thorsten.huck@hsbcad.com"> HSB-9299 initial </version>
/// </History>

/// <insert Lang=en>
/// Select properties or catalog entry, then select walls (default) or press enter to select beams
/// </insert>

/// <summary Lang=en>
/// This tsl creates a blocking junction based on packed beams with the same module or on beams with an equidistant offset.
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbBlockingDistribution")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Erase Blocking|") (_TM "|Select Blocking Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Change Distribution to Center Offset|") (_TM "|Select Blocking Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Change Distribution to Interdistancet|") (_TM "|Select Blocking Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Change Distribution to Quantity|") (_TM "|Select Blocking Tool|"))) TSLCONTENT
//endregion



//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	//d-bm. read a potential mapObject defined by hsbDebugController
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

//region Properties
	String sLengthName=T("|Length|");	
	PropDouble dLength(nDoubleIndex++, U(300), sLengthName);	
	dLength.setDescription(T("|Defines the Length of the Blocking|"));
	dLength.setCategory(category);
	
	category = T("|Distribution|");
	String sDistributionModes[] = {T("|Center Offset|"),T("|Interdistance|"), T("|Quantity|")}; 
	String sDistributionModeName=T("|Mode|");	
	PropString sDistributionMode(nStringIndex++, sDistributionModes, sDistributionModeName);	
	sDistributionMode.setDescription(T("|Defines the DistributionMode|"));
	sDistributionMode.setCategory(category);

	// get distribution mode
	int nDistributionMode = sDistributionModes.find(sDistributionMode);
	if (nDistributionMode<0){ sDistributionMode.set(sDistributionModes.first()); setExecutionLoops(2); return;}

	String sDistributionValueName=T("|Value|");
	if (!_bOnInsert)
	{ 
		sDistributionValueName = sDistributionModes[nDistributionMode];
	}
	PropDouble dDistributionValue(nDoubleIndex++, U(0), sDistributionValueName);	
	dDistributionValue.setDescription(T("|Defines the value specified by the distribution mode|"));
	dDistributionValue.setCategory(category);

	
	String sOffsetTopName=T("|Offset Top|");	
	PropDouble dOffsetTop(nDoubleIndex++, U(479), sOffsetTopName);	
	dOffsetTop.setDescription(T("|Defines the OffsetTop|"));
	dOffsetTop.setCategory(category);
	if (dOffsetTop < 0)dOffsetTop.set(0);

	String sOffsetBottomName=T("|Offset Bottom|");	
	PropDouble dOffsetBottom(nDoubleIndex++, U(479), sOffsetBottomName);	
	dOffsetBottom.setDescription(T("|Defines the OffsetBottom|"));
	dOffsetBottom.setCategory(category);
	if (dOffsetBottom < 0)dOffsetBottom.set(0);

	
	category = T("|Display|");
	String sDimStyleName=T("|Dimstyle|");	
	PropString sDimStyle(nStringIndex++, _DimStyles.sorted(), sDimStyleName);	
	sDimStyle.setDescription(T("|Defines the Dimstyle|"));
	sDimStyle.setCategory(category);
//End Properties//endregion 

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


	// create TSL
		TslInst tslNew;				Map mapTsl;
		int bForceModelSpace = true;	
		String sExecuteKey,sCatalogName = sLastInserted;
		String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
		GenBeam gbsTsl[] = {};		Entity entsTsl[1];			Point3d ptsTsl[] = {_Pt0};
		

	// prompt for elements
		PrEntity ssE(T("|Select elements|")+T("|<Enter> to select pair of outer beams|"), ElementWallSF());
	  	if (ssE.go())
			_Element.append(ssE.elementSet());
		
		if (_Element.length()>0)
		{ 
			for (int i=0;i<_Element.length();i++) 
			{ 
				entsTsl[0] = _Element[i]; 
				ptsTsl[0] = _Element[i].ptOrg();
				tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 	
		
			}//next i
			
			eraseInstance();		
			return;		
			
		}
		else
		{ 
			PrEntity ssB(T("|Select a pair of outer beams|"), Beam());
	  		Beam beams[0];
	  		if (ssB.go())
	  			beams = ssB.beamSet();
	  		
	  		Element el;
	  		for (int i=0;i<beams.length();i++) 
	  		{ 
	  			Element _el=beams[i].element();
	  			if (_el.bIsValid())
	  			{
	  				el = _el;
	  				break;
	  			}
	  			 
	  		}//next i
	  		
	  	// remmove beams from another element	
	  		for (int i=beams.length()-1; i>=0 ; i--) 
	  		{  
	  			Element _el=beams[i].element();
	  			if (_el!=el)
	  			{ 
	  				beams.removeAt(i);
	  				continue;
	  			}
	  		}//next i
	  		
	  		Vector3d vecX = el.vecX();
	  		_Beam = vecX.filterBeamsPerpendicularSort(beams);
	  		_Element.append(el);
	  		_Pt0 = el.ptOrg();
	  		if (_Beam.length()<2)
	  		{ 
	  			eraseInstance();
	  			return;
	  		}
	  		
	  		_Map.setInt("mode", 1);
	  		return;
		}
	}	
// end on insert	__________________//endregion

//region mapIO: support property dialog input via map on element creation
{
	int bHasPropertyMap = _Map.hasMap("PROPSTRING[]") && _Map.hasMap("PROPDOUBLE[]");
	if (_bOnMapIO)
	{ 
		if (bHasPropertyMap)
			setPropValuesFromMap(_Map);	
		showDialog();
		_Map = mapWithPropValues();
		return;
	}
	if (_bOnElementDeleted)
	{
		eraseInstance();
		return;
	}
	else if (_bOnElementConstructed && bHasPropertyMap)
	{ 
		setPropValuesFromMap(_Map);
		_Map = Map();
	}	
}		
//End mapIO: support property dialog input via map on element creation//endregion 

//region General all modes
	int nMode = _Map.getInt("mode"); // 0 = get junctions

// validate and declare element variables
	if (_Element.length()<1)
	{
		reportMessage(TN("|Element reference not found.|"));
		eraseInstance();
		return;	
	}
	ElementWallSF el = (ElementWallSF)_Element[0];
	CoordSys cs = el.coordSys();
	Vector3d vecX = cs.vecX();
	Vector3d vecY = cs.vecY();
	Vector3d vecZ = cs.vecZ();
	Point3d ptOrg = cs.ptOrg();
	assignToElementGroup(el,true, 0,'E');// assign to element tool sublayer

	Vector3d vecXView = getViewDirection(0);
	Vector3d vecYView = getViewDirection(1);
	Vector3d vecZView = getViewDirection(2);

	Plane pnZ(ptOrg, vecZ);
	Plane pnY(ptOrg, vecY);
	CoordSys csY(ptOrg, vecX ,- vecZ, vecY);
	

	Display dpJig(40), dpModel(40);
	dpJig.elemZone(el, 0, 'T');
	dpJig.dimStyle(sDimStyle);
	dpJig.textHeight(U(80));
	dpJig.addViewDirection(vecZView);
	
	dpModel.elemZone(el, 0, 'T');
	dpModel.dimStyle(sDimStyle);
	dpModel.textHeight(U(80));	
	//dpModel.draw(scriptName() , ptOrg, vecX, - vecZ, 1, 1);
//End General all modes//endregion 

//region Get junctions
	if (nMode==0)
	{ 

	// create TSL
		TslInst tslNew;
		GenBeam gbsTsl[] = {};		Entity entsTsl[1];			Point3d ptsTsl[] = {ptOrg};
		int nProps[]={};			double dProps[]={dLength,dDistributionValue,dOffsetTop,dOffsetBottom};			String sProps[]={sDistributionMode,sDimStyle};
		Map mapTsl;	mapTsl.setInt("mode", 1);
	
	// get connected walls and tsls
		Element elConnects[] = el.getConnectedElements();
		TslInst tsls[] = el.tslInstAttached();
		
	// wait if no beams present yet
		Beam beams[] = el.beam();
		if (beams.length()<1)
		{ 
			Display dp(1);
			dp.textHeight(U(80));
			dp.draw(scriptName() + T("|no beams found.|"), ptOrg, vecX, - vecZ, 1, 1);
			setExecutionLoops(2);
			return;
		}
		
	// get beam packs, set differntiation by module
		auto studs[] = vecX.filterBeamsPerpendicularSort(beams);
		String sDffers[0];
		for (int i=0;i<studs.length();i++) sDffers.append(studs[i].module()); 
		EntityCollection  packs[]= Beam().composeBeamPacks(studs, sDffers);

	// validate beam packs if intersecting with wall connection
		for (int i=0;i<packs.length();i++) 
		{ 
			EntityCollection pack = packs[i];
			Beam beams[] = pack.beam();
 
 		// the pack needs to have at least 3 beams
 			if (beams.length() < 3)continue;
 			
 		// check if there  is already an instance assigociated to the module
 			int bSkipPack;
 			String sModule = beams.first().module();
 			for (int j=0;j<tsls.length();j++) 
 			{ 
 				if (scriptName() != tsls[j].scriptName())continue;
 				Beam _beams[]=tsls[j].beam(); 
 				if (_beams.length()>0 && sModule==_beams.first().module())
 				{ 
 					bSkipPack = true;
 					break;
 				} 
 			}//next j
 			if (bSkipPack)continue;

 		// get pack outline 
 			PlaneProfile pp(csY);
 			for (int j=0;j<beams.length();j++) 
 				pp.unionWith(beams[j].envelopeBody().shadowProfile(pnY)); 
			pp.shrink(-dEps);			pp.shrink(dEps); 			
			pp.createRectangle(pp.extentInDir(vecX), vecX,-vecZ);	pp.vis(3);
 
 		// allow only beam packs which intersect with a connected wall
 			int bIsFemale;
 			for (int j=0;j<elConnects.length();j++) 
 			{ 
 				ElementWallSF el2= (ElementWallSF)elConnects[j]; 
				if (vecX.isParallelTo(el2.vecX())) continue;								 
 				auto seg = el2.segmentMinMax();
 				
 				Point3d pts[] = pp.intersectPoints(Plane(seg.ptMid(), el2.vecZ()), true, false);
 				if (pts.length()>0)
 				{ 
 					bIsFemale = true;
 					seg.vis(j);
 					break;
 				}
 			}//next j
			if (!bIsFemale)continue;
	
		// create distribution instance
			if (!bDebug)
			{ 
				entsTsl[0] = el;
				gbsTsl.setLength(0);
				for (int j=0;j<beams.length();j++) 
					gbsTsl.append(beams[j]); 	 
				tslNew.dbCreate(scriptName() , vecX ,vecY,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);							
			}
		}//next i

	// erase the junction detector instance
		if (!bDebug)
		{ 
			eraseInstance();
			return;
		}
	}
//End Get junctions//endregion 		

//End Part #1//endregion 

//region Distribution
	else if (nMode==1)
	{ 

		_ThisInst.setAllowGripAtPt0(_PtG.length()>0);
		sDistributionMode.setReadOnly(true);
	
	//region Flag blockings to be created
		String events[] = { sDistributionValueName, sDistributionModeName, sOffsetBottomName, sOffsetTopName};
		int bCreate = _bOnElementConstructed || _bOnDbCreated || events.find(_kNameLastChangedProp)>-1 || _Map.getInt("createBlocking");			
	//End Flag blockings to be created//endregion 	
				
	//region Trigger other modes
		int nPrevDistr = _Map.getInt("previousDistribution");
		String sTriggers[0]; sTriggers = sDistributionModes;
		sTriggers.removeAt(sTriggers.findNoCase(sDistributionMode ,- 1));
		for (int i=0;i<sTriggers.length();i++) 
		{ 
			addRecalcTrigger(_kContextRoot, T("|Change Distribution to| ")+sTriggers[i]);
			if (_bOnRecalc && _kExecuteKey==T("|Change Distribution to| ")+sTriggers[i])
			{
				int nNewDistributionMode = sDistributionModes.find(sTriggers[i]);
				sDistributionMode.set(sTriggers[i]);
			// change from quantity to distance	
				if (nNewDistributionMode!=2 && nPrevDistr==2)
					dDistributionValue.set(getDouble(T("|Enter new distribution value|")));
			// change from distance to quantity
				else if (nNewDistributionMode==2 && nPrevDistr!=2)
					dDistributionValue.set(getInt(T("|Enter quantity|")));
			// change distance mode
				else if (nNewDistributionMode!=2 && nPrevDistr!=nNewDistributionMode)
				{
					double ret = getDouble(T("|Enter new distribution value|"));
					if (ret <= 0)ret = dDistributionValue;
					dDistributionValue.set(ret);		
				}
				_PtG.setLength(0);
				_Map.setInt("createBlocking", true);
				setExecutionLoops(2); return;	
			} 
		}//next i
		_Map.setInt("previousDistribution", nDistributionMode);
		//endregion	
		
	//region Validate properties
		int nQuantity = nDistributionMode == 2 ? dDistributionValue : 0;
		if (nDistributionMode==0 && dDistributionValue<dLength)
		{ 
			dDistributionValue.set(dLength);
			reportMessage("\n" + scriptName() + ": " +sDistributionModes[0] + T(" |adjusted to| ")+dDistributionValue);
			setExecutionLoops(2); return;	
		}
		else if (nDistributionMode==1 && dDistributionValue<0)
		{ 
			dDistributionValue.set(0);
			reportMessage("\n" + scriptName() + ": " +sDistributionModes[1] + T(" |adjusted to| ")+dDistributionValue);
			setExecutionLoops(2); return;	
		}
		else if (nDistributionMode==2 && nQuantity<2)
		{ 
			dDistributionValue.set(2);
			reportMessage("\n" + scriptName() + ": " +sDistributionModes[2] + T(" |adjusted to| ")+2);
			setExecutionLoops(2); return;	
		}		
		double dDistance = nDistributionMode != 2 ? dDistributionValue : 0;				
	//End Validate properties//endregion 	
	
	//region Validate beams and get envelope
		Beam beams[] = vecX.filterBeamsPerpendicularSort(_Beam);
		if (beams.length()<2)
		{ 
			reportMessage("\n"+ scriptName() + T("|Invalid selection set.| ")$+T("|Tool will be deleted.|"));
			eraseInstance();
			return;
		}	
		
	// get module envelope
		PlaneProfile ppZ(cs);
		for (int i=0;i<beams.length();i++) 
			ppZ.unionWith(beams[i].envelopeBody(false, true).shadowProfile(pnZ));  

		PLine rings[] = ppZ.allRings(true, false);
		int cnt=1;
		double dMerge = beams.first().dD(vecX) * .5;
		while (cnt<20 && rings.length()>1)
		{ 
			double d = cnt * dMerge;
			ppZ.shrink(-d);
			ppZ.shrink(d);
			rings = ppZ.allRings(true, false);
			cnt++;
		}
		ppZ.vis(1);	
		Line lnY(ppZ.ptMid(), vecY);

	// range extremes
		LineSeg segZ = ppZ.extentInDir(vecY);
		Point3d ptsYMinMax[] ={ segZ.ptStart(), segZ.ptEnd()};


	// get ref and blocking beams
		Beam blockings[0];
		blockings= beams;
		blockings.removeAt(0);
		blockings.removeAt(blockings.length()-1);
		Beam bmRef = beams.first();
	//End Validate beams//endregion 
	
	//region No blockings found, create from scratch based on geometry of first
		if (blockings.length()<1)
		{ 
		// get offset axis to axis
			double dOffset = vecX.dotProduct(beams.last().ptCen() - beams.first().ptCen())-.5*(beams.first().dD(vecX)+beams.last().dD(vecX));
			dOffset = ((int)dOffset * 100) / 100; // round
			double dX = bmRef.dD(vecX);
			
			int num = (dOffset / dX);
	
			if (num*dX == dOffset)
			{ 
				if (!bDebug)
				{ 
					for (int i=0;i<num;i++) 
					{ 
						Point3d pt = bmRef.ptCen();
						pt += vecY * (vecY.dotProduct(ptsYMinMax.first() - pt) + dOffsetBottom + .5 * dLength);
						pt += vecX * (i + 1) * dX;
						
						Beam bm;
						bm.dbCreate(pt, vecY, - vecX, vecZ, dLength, dX, bmRef.dD(vecZ), 0, 0 ,- 1);
						bm.setMaterial(bmRef.material());
						bm.setGrade(bmRef.grade());
						bm.setType(_kBlocking);
						bm.setModule(bmRef.module());
						bm.setColor(bmRef.color());			
						bm.assignToElementGroup(el, true, 0, 'Z');	
						_Beam.append(bm);	
						
						bm=bm.dbCopy();
						bm.transformBy(vecY * (vecY.dotProduct(ptsYMinMax.last() - pt) - dOffsetTop - .5 * dLength));
						_Beam.append(bm);
					}//next i
					_Map.setInt("createBlocking", true);
					setExecutionLoops(2);					
				}
				else
				{ 
					double d = bmRef.solidLength();
					for (int i=0;i<num;i++)
					{ 
						Body bd = bmRef.realBody();
						Point3d pt = bd.ptCen();
						bd.addTool(Cut(pt - bmRef.vecX() * .5 * dLength, -bmRef.vecX()), 1);
						bd.addTool(Cut(pt + bmRef.vecX() * .5 * dLength, bmRef.vecX()), 1);
						
						bd.transformBy(vecX * (i + 1) * dX);
						bd.vis(6);
					}
				}

				return;	
			}
			else
			{ 
				reportMessage("\n" + scriptName() + ": " +T("|The offset between the selected beams cannot be divided by the width of the beam.|"));
				eraseInstance();
				return;
			}
		}			
	//End No blockings found, create from scratch based on geometry of first
	//endregion 
	
	//region Blockings found
		else
		{ 

			Point3d ptsX[0];
			for (int i=0;i<blockings.length();i++) 
				ptsX.append(blockings[i].ptCen()); 
			Line lnX(ptOrg, vecX);	
			ptsX = Line(_Pt0, vecX).orderPoints(lnX.projectPoints(ptsX), dEps);
		
		// Grip Jig
			Point3d ptsDim[0]; // 		// collection of dimpoints
			int bShowGripJig= (_bOnGripPointDrag && _kExecuteKey == "_PtG0") && !vecZView.isParallelTo(vecY);	
			double dThisDistance = dDistance;
			Point3d ptJigRef = _Map.getPoint3d("ptJigRef"); ptJigRef.vis(1);
			int bOutOfRange;
			if (bShowGripJig)
			{
				_ThisInst.setDrawOrderToFront(true);
				dThisDistance = abs(vecY.dotProduct(ptJigRef - _PtG[0]));
			}

		// Distribute at blocking locations along vecX
			for (int x=0;x<ptsX.length();x++) 		
			{ 
				Point3d& ptX =ptsX[x];	ptX.vis(3);
			// set _Pt0 on creation	
				if (x == 0 && _bOnDbCreated)
					_Pt0 = ptX-vecX*.5*(ppZ.dX()+bmRef.dD(vecX));

			//region Get dimensions of first blocking found at axis
				double dX, dZ;
				for (int i=0;i<blockings.length();i++) 
				{ 
					if (abs(vecX.dotProduct(blockings[i].ptCen()-ptX))<dEps)
					{ 
						dX = blockings[i].dD(vecX);
						dZ = blockings[i].dD(vecZ);
						break;
					}
				}
				if (dX < dEps || dZ < dEps)continue;					
			//End get geometry of first blocking found at axis//endregion 

			// get range
				//ppZ.extentInDir(vecX).vis(3);
				Point3d pts[] = ppZ.intersectPoints(Plane(ptX, vecX), true, false);
				pts = lnY.orderPoints(pts);
				if (pts.length() < 2)continue;	
				
				if  (x==0)ptsDim.append(pts);

			// distribute
				Point3d ptNew = ptX;
				
				Point3d ptsY[0];
	 			
	 			ptNew += vecY* vecY.dotProduct(ptsYMinMax.first()-ptNew) + vecY * (dOffsetBottom + .5 * dLength);
				//pts.first() + vecY * .5 * dLength; //Version 1.1
	 			ptsY.append(ptNew);	
	 			Point3d ptBottom = ptsY.first() + vecY * .5 * dLength;	 ptBottom.vis(4);
				
				ptNew += vecY* vecY.dotProduct(ptsYMinMax.last()-ptNew) - vecY * (dOffsetTop+ .5 * dLength);
				ptsY.append(ptNew);//pts.last() - vecY * .5 * dLength);	
				Point3d ptTop = ptsY.last() - vecY * .5 * dLength;	ptTop.vis(6);
					
				int qty=2;
				Point3d ptLast = ptsY.first();
				double dDistToTop = vecY.dotProduct(ptTop - ptLast) - .5 * dLength;
				
			// get delta value	
				double dDelta = dThisDistance + (nDistributionMode == 0 ? 0 : dLength);
				if (nDistributionMode==2)
				{ 
					int num = nQuantity - 2;
					double range = vecY.dotProduct(ptTop - ptBottom);
					if (num>0)
						dDelta = ((range -(num*dLength)) / (num+1))+dLength;
					else
					{
						dDelta = range+dLength;	
						dDistToTop = 0;
					}
				}

				while (qty<20 && dDistToTop>dDelta)
				{ 
					ptLast += vecY * dDelta;
					ptLast.vis(qty);
					ptsY.append(ptLast);
					qty++;
					dDistToTop = vecY.dotProduct(ptTop - ptLast) - .5 * dLength;
					//reportMessage("\n"+ scriptName() + " dist: " +dDistToTop+ " exce " + _kExecutionLoopCount);
					if (nDistributionMode == 1)dDistToTop -= .5 * dLength;
				}
				ptsY = Line(_Pt0, vecY).orderPoints(ptsY, dEps);
				
				for (int i = 0; i < ptsY.length(); i++)
				{
					Point3d& pt = ptsY[i];pt.vis(i);

				// get jig references
					if (x == 0)
					{
					 	if (nDistributionMode == 0)ptsDim.append(pt);
		 				else 
		 				{
		 					if (i>0)
		 						ptsDim.append(pt-vecY*.5*dLength);
		 					ptsDim.append(pt+vecY*.5*dLength);
		 				}			
					}	
				// create blocking
					if (bCreate)
					{ 
						Beam bm;
						bm.dbCreate(ptsY[i], vecY, - vecX, vecZ, dLength, dX, dZ, 0, 0 ,- 1);
						bm.setMaterial(bmRef.material());
						bm.setGrade(bmRef.grade());
						bm.setType(_kBlocking);
						bm.setModule(bmRef.module());
						bm.setColor(bmRef.color());			
						bm.assignToElementGroup(el, true, 0, 'Z');
						_Beam.append(bm);
					}
				// show jig	
					else if (bShowGripJig)
					{ 
		 				Body bd (pt, vecY, - vecX, vecZ, dLength, dX, dZ, 0, 0 ,- 1);		 				//bd.vis(i);
		 				PlaneProfile pp = bd.shadowProfile(Plane(pt, vecZView));
		 				
		 				if (dThisDistance < dLength)
		 				{
		 					dpJig.color(1);
		 					PLine pl;
		 					pl.createCircle(pt, vecZView, dX);
		 					pp=PlaneProfile(pl);
		 					PlaneProfile ppSub = pp;
		 					ppSub.shrink(dX * .2);
		 					pp.subtractProfile(ppSub);
		 					bOutOfRange = true;
		 				}

		 				dpJig.draw(pp, _kDrawFilled, bOutOfRange?0:60);
		 				dpJig.draw(pp);
		 				if (bOutOfRange)break;
//		 				auto segs[] = bd.hideDisplay(CoordSys(pt, vecXView, vecYView, vecZView), false, false, false);
//		 				dpModel.color(1);
//		 				dpModel.draw(segs);		 					
					} 
				// grip modified, update distribution value	
					else if (x==0 && _kNameLastChangedProp=="_PtG0")
					{ 
						dThisDistance = vecY.dotProduct( _PtG[0]-ptJigRef);
						if (dThisDistance>dLength)
							dDistributionValue.set(dThisDistance);	
						_PtG[0] = lnY.closestPointTo(_PtG[0]);
						_Map.setInt("createBlocking", true);
						setExecutionLoops(2);
						break;
					}
				}
			}
			
		//Draw diagonal on every blocking
			for (int i=0;i<blockings.length();i++) 
			{ 
				Body bd = blockings[i].envelopeBody(false,true); 
				Point3d pts[] = bd.extremeVertices(vecX + vecY + vecZ);
 				if (pts.length()>1)
 					dpModel.draw(PLine(pts.first(), pts.last()));
				 
			}//next i
			
		 // grip registering
 			ptsDim = Line(_Pt0, vecY).orderPoints(ptsDim, dEps);
 			if (ptsDim.length()>2 && nDistributionMode!=2) // no grip if mode is set to quantity
 			{ 			
				ptJigRef = ptsDim[1];	
 				_Map.setPoint3d("ptJigRef",ptJigRef);		ptJigRef.vis(3);
 				
 				if (_PtG.length()<1)
 				{
 					Point3d ptGrip = ptsDim[2];
 					_PtG.append(ptGrip);//+vecY*(nDistributionMode==0?.5*dLength:0));		
 				}
 			}	
 			if (_PtG.length()>0)
 			{ 
 				_PtG[0].vis(170);
 				addRecalcTrigger(_kGripPointDrag, "_PtG0");	
 				
 			}	
			if (bShowGripJig)
			{ 
				if (!bOutOfRange)
				{ 
					
					DimLine dl(_Pt0, vecY, vecY.crossProduct(-vecZView));
					Dim dim(dl,  ptsDim, "<>",  "<>", _kDimDelta); 
					dpJig.draw(dim);
					//if (bDebug)reportMessage("\ndragging to offset "+ dThisDistance);					
				}
				return;
			}
			if (bDebug)dpJig.draw(scriptName(), _Pt0, _XW, _YW, 1, 0, _kDeviceX);			
		}//End Blockings found
		//endregion 

	//region Purge existing blockings	
		if (bCreate)
		{ 
			if (_Map.hasInt("createBlocking")) 
				_Map.removeAt("createBlocking", true);
			else
				_PtG.setLength(0);
			
			for (int i=blockings.length()-1; i>=0 ; i--) 
				if (blockings[i].bIsValid())
					blockings[i].dbErase();
					
			_ThisInst.transformBy(Vector3d(0,0,0));		
			return;
		}			
	//End Purge existing blockings	//endregion 
			
	//region Trigger EraseBlockings
		String sTriggerEraseBlockings = T("|Erase Blockings|");
		if (blockings.length()>0)
		{ 
			addRecalcTrigger(_kContextRoot, sTriggerEraseBlockings );
			if (_bOnRecalc && _kExecuteKey==sTriggerEraseBlockings)
			{
				for (int i=blockings.length()-1; i>=0 ; i--) 
					if (blockings[i].bIsValid())
						blockings[i].dbErase(); 
				eraseInstance();
				return;
			}			
		}//endregion

	}
//End Distribution
//endregion 


	
	


#End
#BeginThumbnail
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
<DP66,6;9^/]D!.0O@@AW,0````!)14Y$KD)@@@``




#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="460" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12839 tsl version conflicts resolved, merged 1.2 of 12aug2021" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="8/18/2021 9:40:47 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12159 debug display removed" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="8/17/2021 9:32:38 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12159 new offset properties added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="8/16/2021 4:36:17 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End