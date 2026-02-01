#Version 8
#BeginDescription
#Versions
2.4 04.11.2021 HSB-13467: expose sequence number, align blocking Coord so that width is aligned with wall width Author: Marsel Nakuci
2.3 03.11.2021 HSB-13467: fix grade Author: Marsel Nakuci
2.2 02.11.2021 HSB-13467: add sequenceNumber Author: Marsel Nakuci
Version 2.1 02.11.2021 HSB-13467: add property "Justification" , Author Marsel Nakuci
Version 2.0 17.05.2021 HSB-11517 accepting a gap >=0 to integrate blocking, set gap < 0 to exclude. Default beamtype changed to SFBlocking , Author Thorsten Huck

version value="1.9" date="08oct2020" author="thorsten.huck@hsbcad.com"
HSB-9091 detection of connected walls limited to parallel walls


This tsl creates a distribution of blocking beams and stretches vertical and diagonal beams accordingly.




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 4
#KeyWords Element;Blocking;Filler
#BeginContents
//region Part #1
//region History
/// <History>
// #Versions
// Version 2.4 04.11.2021 HSB-13467: expose sequence number, align blocking Coord so that width is aligned with wall width Author: Marsel Nakuci
// Version 2.3 03.11.2021 HSB-13467: fix grade Author: Marsel Nakuci
// Version 2.2 02.11.2021 HSB-13467: add sequenceNumber Author: Marsel Nakuci
// 2.1 02.11.2021 HSB-13467: add property "Justification" , Author Marsel Nakuci
// 2.0 17.05.2021 HSB-11517 accepting a gap >=0 to integrate blocking, set gap < 0 to exclude. Devualt beamtype changed to SFBlocking , Author Thorsten Huck
/// <version value="1.9" date="08oct2020" author="thorsten.huck@hsbcad.com"> HSB-9091 detection of connected walls limited to parallel walls </version>
/// <version value="1.8" date="25may2019" author="thorsten.huck@hsbcad.com"> HSB-4976 staggering fixed </version>
/// <version value="1.7" date="15may2019" author="thorsten.huck@hsbcad.com"> HSB-4976 selection by element and/or beams improved, tooling delegatzed to hsbBeamcutElement </version>
/// <version value="1.6" date="21oct2019" author="thorsten.huck@hsbcad.com"> HSB-5765 new properties 'Nailing' and 'Staggered distribution' added </version>
/// <version value="1.5" date="18oct2019" author="thorsten.huck@hsbcad.com"> HSB-5765 detection of adjacent beams of connected elements enhanced </version>
/// <version value="1.4" date="08oct2019" author="thorsten.huck@hsbcad.com"> HSB-5728 bugfix: the height of the blocking beam is not extended in vecZ by eps anymore </version>
/// <version value="1.3" date="31jul2019" author="thorsten.huck@hsbcad.com"> HSB-5450 new property gap for tooling of partial intersecting beams </version>
/// <version value="1.2" date="18jun2019" author="thorsten.huck@hsbcad.com"> HSB-4976 beam based insertion enhanced, supports coplanar beam groups not being linked to an element </version>
/// <version value="1.1" date="06may2019" author="thorsten.huck@hsbcad.com"> new alignment property, new range selection if based on 1 element </version>
/// <version value="1.0" date="09mar2018" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// This script provides three methods of insertion
/// beam based: Select all beams representing one element, select properties and press OK.
/// element based: Select one or multiple elements, set properties and press OK
/// element tsl based: insert the tsl as element tsl and specify the properties or the catalog name, Generate construction.
/// </insert>

/// <summary Lang=en>
/// This tsl creates a distribution of blocking beams and stretches vertical and diagonal beams accordingly.

// Commands
// commmand to create insulation
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbElementBlocking")) TSLCONTENT
/// </summary>//endregion

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

//region Properties
	category = T("|Geometry|");
	String sHeightName=T("|Height|");	
	PropDouble dHeight(nDoubleIndex++, U(0), sHeightName);	
	dHeight.setDescription(T("|Defines the Height|") + T(" |0 = by zone|"));
	dHeight.setCategory(category);
	
	String sWidthName=T("|Width|");	
	PropDouble dWidth(nDoubleIndex++, U(0), sWidthName);	
	dWidth.setDescription(T("|Defines the Width|")+ T(" |0 = by zone|"));
	dWidth.setCategory(category);
	
	category = T("|Beam Properties|");
	String sMaterialName=T("|Material|");	
	PropString sMaterial(nStringIndex++, "", sMaterialName);	
	sMaterial.setDescription(T("|Defines the Material|"));
	sMaterial.setCategory(category);
	
	String sGradeName=T("|Grade|");	
	PropString sGrade(nStringIndex++, "", sGradeName);	
	sGrade.setDescription(T("|Defines the Grade|"));
	sGrade.setCategory(category);
	
	String sNameName=T("|Name|");	
	PropString sName(nStringIndex++, "", sNameName);	
	sName.setDescription(T("|Defines the Name|"));
	sName.setCategory(category);
	
	String sColorName=T("|Color|");	
	PropInt nColor(nIntIndex++, 4, sColorName);	
	nColor.setDescription(T("|Defines the Color|"));
	nColor.setCategory(category);

	String sNailings[] ={ T("|Disabled|"), T("|Enabled|")};
	String sNailingName=T("|Nailing|");	
	PropString sNailing(7,sNailings, sNailingName);	
	sNailing.setDescription(T("|Defines the Nailing|"));
	sNailing.setCategory(category);
	
	category = T("|Alignment|");
	String sClearanceName=T("|Bottom Clearance|");	
	PropString sClearance(8, U(25), sClearanceName);	
	sClearance.setDescription(T("|Defines the clearance between the bottom rail or lower blocking and the next blocking.|")+
	T("|Separate multiple entries by semicolon| ';' ") + T("|You can specify absolute values like| 400;400;300 ") + T("|or a fraction of the maximum inner height i.e.| 1/3;1/3;1/5"));
	sClearance.setCategory(category);

	String sPostFilterName=T("|Post Filter|");	
	PropString sPostFilter(nStringIndex++, "", sPostFilterName);	
	sPostFilter.setDescription(T("|Defines the criteria to identify a post|") + T(", |Color and/or beamtypes are supported, separate entries by semikolon|"));
	sPostFilter.setCategory(category);

	String sSplitFilterName=T("|Split Filter|");	
	PropString sSplitFilter(nStringIndex++, "", sSplitFilterName);	
	sSplitFilter.setDescription(T("|Defines the criteria to identify splitting studs|") + T(", |Color and/or beamtypes are supported, separate entries by semikolon|"));
	sSplitFilter.setCategory(category);	
	
	String sAlignments[] = { T("|Icon Side|"), T("|Center|"), T("|Opposite Side|")};
	String sAlignmentName=T("|Alignment|");	
	PropString sAlignment(nStringIndex++, sAlignments, sAlignmentName);	
	sAlignment.setDescription(T("|Defines the Alignment|"));
	sAlignment.setCategory(category);
	
	String sStaggeredName=T("|Staggered Distribution|");	
	PropString sStaggered(nStringIndex++, sNoYes, sStaggeredName);	
	sStaggered.setDescription(T("|Defines the if the blocking distribution will be staggered.|"));
	sStaggered.setCategory(category);
	// HSB-13467
	String sJustificationName=T("|Justification|");	
	String sJustifications[] ={ T("|Top|"), T("|Middle|"), T("|Bottom|") };
	PropString sJustification(9, sJustifications, sJustificationName, 2);	
	sJustification.setDescription(T("|Property only valid for fraction entries.|")+" "+T("|Defines the Justification of the blocking.|")+" "+T("|It can be top face of the blocking, middle axis or bottom face.|"));
	sJustification.setCategory(category);
	
	category = T("|Tooling|");
	String sGapName=T("|Gap|");	
	PropDouble dGap(nDoubleIndex++, U(0), sGapName);	
	dGap.setDescription(T("|Defines the gap between partial intersecting beams and the blocking.|"));
	dGap.setCategory(category);
	
	int nBlockingBeamType = _kBlocking;
	double dMinBlockingLength = U(50);	
	double dMinSplitResultLength = U(50);
	
	category = T("|Sequence|");
	String sSequenceName=T("|Sequence|");	
	PropInt nSequence(nIntIndex++, 70, sSequenceName);	
	nSequence.setDescription(T("|Defines the sequence number used to sort the list of Tsl's during execution of eg OnElementConstructed|")+" "+
	T("|The list of tsl's is sorted from low to high sequenceNumber.|")+" "+
	T("|Negative values will come before the 0.|")+" "+
	T("|So the sequenceNumber can be positive or negative.|"));
	nSequence.setCategory(category);

//End Properties//endregion 	
		
// on mapIO: support property dialog input via map on element creation
	{
		int bHasPropertyMap = _Map.hasMap("PROPSTRING[]") && _Map.hasMap("PROPINT[]") && _Map.hasMap("PROPDOUBLE[]");
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
		else if(bHasPropertyMap)
		{ 
			setPropValuesFromMap(_Map);
			_Map = Map();
		}
	}	


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
		
	// prompt for elements
		PrEntity ssE(T("|Select elements|") + T(", |<Enter> to select a set of beams of one element|"), Element());
	  	if (ssE.go())
			_Element.append(ssE.elementSet());

	// prepare tsl cloning
		TslInst tslNew;
		GenBeam gbsTsl[] = {};		Entity entsTsl[1] ;
		Point3d ptsTsl[1];// = {};
		int nProps[]={nColor, nSequence};		
		double dProps[]={dHeight, dWidth,dGap};		
		String sProps[]={sMaterial,sGrade,sName,sPostFilter,sSplitFilter,sAlignment, sStaggered, sNailing, sClearance,sJustification};
		Map mapTsl;	
		String sScriptname = scriptName();
		
	// prompt for beams
		Beam beams[0];
	// get border posts if only one element selected
		if (_Element.length()==1)
		{ 
			Element el = _Element[0];
			Vector3d vecX = el.vecX();
			PrEntity ssB(T("|Select 2 studs defining the distribution range|") + T(", |<Enter> to distribute over entire element|"), Beam());
		  	if (ssB.go())
				beams.append(ssB.beamSet());
			beams=vecX.filterBeamsPerpendicularSort(beams);
			
		// make sure selected beams belong to the element
			Beam _beams[] = el.beam();
			for (int i=beams.length()-1; i>=0 ; i--) 
				if (_beams.find(beams[i])<0)
					beams.removeAt(i);
	
		// append to genbeam array
			if (beams.length()>1)
			{ 
				gbsTsl.append(beams[0]);
				gbsTsl.append(beams[beams.length()-1]);
				mapTsl.setInt("hasBoundary", true); // a flag if the range inbetween needs to be collected
			}
		}
	//region get beams of beam group
		else if (_Element.length()<1)
		{ 
			PrEntity ssB(T("|Select beams(s)|"), Beam());
		  	if (ssB.go())	beams.append(ssB.beamSet());
				
		// get the first element found
			Element el;
			for (int i=0;i<beams.length();i++) 
			{ 
				el = beams[i].element();
				if (el.bIsValid())
				{
					_Element.append(el);
					break;		 
				}
			}//next i
			
		// append only those beams which belong to this elememnt
			for (int i=0;i<beams.length();i++) 
			{ 
				Element _el = beams[i].element();
				if (_el.bIsValid() && _el == el)
					gbsTsl.append(GenBeam(beams[i]));
			}//next i	
		}			
	//End get beams of beam group//endregion 

	// insert per element
		for(int i=0;i<_Element.length();i++)
		{
			entsTsl[0]=_Element[i];	
			ptsTsl[0]=_Element[i].ptOrg();
			
			tslNew.dbCreate(scriptName(), _Element[i].vecX() ,_Element[i].vecY(),gbsTsl, entsTsl, ptsTsl, 
					nProps, dProps, sProps,_kModelSpace, mapTsl);	
			
			if(bDebug && tslNew.bIsValid())reportMessage("\n"+ scriptName() + " created for " +_Element[i].number());
		}
		eraseInstance();
		return;
	}	
// end on insert	__________________
//endregion 
		
//End Part #1//endregion 
//	return
	// HSB-13467
	_ThisInst.setSequenceNumber(nSequence);
//region Validate and declare element variables
	if (_Element.length()<1)
	{
		reportMessage(TN("|Element reference not found.|"));
		eraseInstance();
		return;	
	}
	Element el = _Element[0];
	CoordSys cs = el.coordSys();
	Vector3d vecX = cs.vecX();
	Vector3d vecY = cs.vecY();
	Vector3d vecZ = cs.vecZ();
	Point3d ptOrg = cs.ptOrg();
	
	
	assignToElementGroup(el,true, 0,'E');// assign to element tool sublayer
	Plane pnZ(ptOrg, vecZ);
	LineSeg segMinMax=el.segmentMinMax();
	Beam beams[]= el.beam();
	
	double dXMax = abs(vecX.dotProduct(segMinMax.ptStart()-segMinMax.ptEnd()));
	double dYMax = abs(vecY.dotProduct(segMinMax.ptStart()-segMinMax.ptEnd()));
	
	int bHasBoundary = _Map.getInt("hasBoundary") && _Beam.length() == 2;
	int nAlignment = sAlignments.find(sAlignment, 0); // 0= Icon, 1=center, 2 = opposite icon
	int bIsStaggered = sNoYes.find(sStaggered) == 1;
	int bIsNailable = sNailings.find(sNailing) == 1;
	
	String material = sMaterial.length() > 0 ? sMaterial : el.zone(0).material();
//	String grade = sGrade.length();
	String grade = sGrade.length()>0?sGrade:0;
	
// get post filter criterias
	String sPostFilters[] = sPostFilter.tokenize(";");
	int nBeamTypePostFilters[0];
	int nColorPostFilters[0];
	for (int i=0;i<sPostFilters.length();i++) 
	{ 
		String sFilter = sPostFilters[i];
		int c = sFilter.atoi();
		int n = _BeamTypes.findNoCase(sPostFilters[i],-1);
		if ((String)c==sPostFilters[i])
			nColorPostFilters.append(c);
		else if (n>-1)
			nBeamTypePostFilters.append(n); 
	}
	int bHasBeamTypePostFilter = nBeamTypePostFilters.length() > 0;
	int bHasColorPostFilter = nColorPostFilters.length() > 0;
	
// get split filter criterias
	String sSplitFilters[] = sSplitFilter.tokenize(";");
	int nBeamTypeSplitFilters[0];
	int nColorSplitFilters[0];
	for (int i=0;i<sSplitFilters.length();i++) 
	{ 
		String sFilter = sSplitFilters[i];
		int c = sFilter.atoi();
		int n = _BeamTypes.findNoCase(sSplitFilters[i],-1);
		if ((String)c==sSplitFilters[i])
			nColorSplitFilters.append(c);
		else if (n>-1)
			nBeamTypeSplitFilters.append(n); 
	}
	int bHasBeamTypeSplitFilter = nBeamTypeSplitFilters.length() > 0;
	int bHasColorSplitFilter = nColorSplitFilters.length() > 0;
//End Validate and declare element variables//endregion 
	
//region wait state
	if (beams.length()<1)
	{ 
		Display dp(-1);
		dp.textHeight(U(50));
		dp.draw(scriptName(), segMinMax.ptMid(), vecX, vecY,0,0, _kDevice);
		return;
	}		
//End wait state//endregion 
	
//region get planview shadow from beams and store bodies 
	Body bodies[0]; String handles[0];
	PlaneProfile pp(CoordSys(ptOrg, vecX, - vecZ, vecY));
	Plane pn(ptOrg,vecY);
	for (int i=0;i<beams.length();i++) 
	{ 
		Body bd = beams[i].envelopeBody(false, true);
		bodies.append(bd);
		handles.append(beams[i].handle());
		
		PlaneProfile _pp=bd.shadowProfile(pn);
		PLine plRings[] =_pp.allRings(true, false);
		for (int r=0;r<plRings.length();r++) 
			pp.joinRing(plRings[r],_kAdd);  
	}//next i
	pp.vis(2);
//End get planview shadow from beams//endregion 
	
//region get additional beams of adjacent elements
	ElementWall elw = (ElementWall)el;
	if (elw.bIsValid())
	{ 
		Group gr(el.elementGroup().namePart(0));
		
	// get bounds of zone 0	
		LineSeg seg;
		if (pp.area()<pow(dEps,2))
			seg =LineSeg (ptOrg-vecX*U(10), ptOrg + vecX * (dXMax+U(10)) - vecZ * el.dBeamWidth());	
		else
		{ 
			seg = pp.extentInDir(vecX);
			seg = LineSeg (seg.ptStart() - vecX * U(10), seg.ptEnd() + vecX * U(10));
		}
		//seg.vis(3);
		
		PLine plZone0; plZone0.createRectangle(seg, vecX, vecZ);
		Body bdTest(plZone0, vecY*dYMax, 1);//bdTest.vis(252); // //HSB-5765
		
	// collect elements of this group and find adjacent beams
		Entity ents[]=gr.collectEntities(true, ElementWall(), _kModelSpace); 
		for (int i=0;i<ents.length();i++) 
		{ 
			Element el2 = (Element)ents[i]; 
			if (ents[i] == el || !el2.bIsValid() || !el2.vecX().isParallelTo(vecX))continue;
			
			//HSB-5765
			Beam beams2[] = bdTest.filterGenBeamsIntersect(el2.beam());
			for (int j=0;j<beams2.length();j++) 
			{ 
				Beam b = beams2[j];
				
			// extend the segmentMinMax to left and/or right if adjacent studs are found
				if (b.vecX().isParallelTo(vecY))
				{
					b.realBody().vis(4);
					beams.append(b); 
					bodies.append(b.envelopeBody(false, true));
					handles.append(b.handle());
				}
			}//next j
		}	
	}		
//End get additional beams of adjacent elements//endregion 
	
// get frame profile in element view
	PlaneProfile ppElement(cs);
	for (int i=0;i<beams.length();i++) 
	{ 
		PlaneProfile pp=bodies[i].shadowProfile(Plane(ptOrg, vecZ));
		pp.shrink(-dEps);
		PLine rings[] = pp.allRings(true, false);
		for (int r=0;r<rings.length();r++) 
			ppElement.joinRing(rings[r], _kAdd);
	}//next i
	//ppElement.shrink(-dEps);
	ppElement.shrink(dEps); 
	LineSeg segFrame = ppElement.extentInDir(vecX);
	ppElement.removeAllOpeningRings();ppElement.vis(3);
	segMinMax = ppElement.extentInDir(vecX);
	segMinMax.vis(6);
	dXMax = abs(vecX.dotProduct(segMinMax.ptStart()-segMinMax.ptEnd()));
	
//region Set base test body
	double dYBlock=dHeight==0?el.dBeamHeight():abs(dHeight);
	double dZBlock=dWidth==0?el.dBeamWidth():abs(dWidth);
	double dXBlock = dXMax;
	Point3d ptRef = segMinMax.ptMid();
	ptRef += vecY * vecY.dotProduct(ptOrg - ptRef) + vecZ * vecZ.dotProduct(ptOrg - ptRef);		
//End Set base test body//endregion 


//region Collect beams defining splitters
	Beam splitters[0];
	splitters=_Beam;
	// set test body size and location
	if (bHasBoundary)
	{ 
		Beam bm1 = splitters.first();
		Point3d pt1 = bm1.ptCenSolid();
		double d1 = bm1.dD(vecX);
		Beam bm2 = splitters.last();
		Point3d pt2 = bm2.ptCenSolid();
		double d2 = bm2.dD(vecX);

		dXBlock = vecX.dotProduct(pt2 - pt1) + .5 * (d1 + d2);
		ptRef= ((pt1 - .5 * vecX * d1) + (pt2 + .5 * vecX * d2)) * .5;
		ptRef += vecY * vecY.dotProduct(ptOrg - ptRef) + vecZ * vecZ.dotProduct(ptOrg - ptRef);	
		
	}
	else if (splitters.length()<2)
	{ 
		splitters = beams;
	}
	// coming from _Beam
	else
	{ 
		Point3d pts[0];
		for (int i=0;i<splitters.length();i++) 
		{ 
			Beam b = splitters[i];
			int n = handles.find(splitters[i].handle());
			if (n < 0)continue;	
			pts.append(bodies[n].extremeVertices(vecX));
		}
		pts = Line(_Pt0, vecX).orderPoints(pts);
		if (pts.length()>0)
		{ 
			dXBlock = vecX.dotProduct(pts.last() - pts.first());
			ptRef += vecX * vecX.dotProduct((pts.last() +pts.first()) * .5 - ptRef);
		}
	}
	
// the test body to find intersecting beams
	ptRef -= vecZ * nAlignment*.5 * el.dBeamWidth();// 0= Icon, 1=center, 2 = opposite icon
	Body bdTest(ptRef, vecX, vecY, vecZ, dXBlock, dYBlock, dZBlock, 0, 1 ,nAlignment- 1); 
	bdTest.vis(2);	ptRef.vis(52);
//End Collect beams defining splitters//endregion 

//return
// get base plate(s), vertical beams and non vertical beams
	Beam bmHorizontals[] = vecY.filterBeamsPerpendicularSort(splitters);
	Beam bmVerticals[] = vecX.filterBeamsPerpendicularSort(splitters);
	Beam bmNonVerticals[0];
	for (int i=0;i<splitters.length();i++) 
		if (!splitters[i].vecX().isParallelTo(vecY))
			bmNonVerticals.append(splitters[i]); 

// get opening subtraction bodies
	Opening openings[]=el.opening();
	Body bdOpenings[0];
	for (int i=0;i<openings.length();i++) 
	{ 
		PLine pl= openings[i].plShape(); 
		Body bd(pl, vecZ*U(10e3),0); 
		bdOpenings.append(bd);
	}//next i
	
	//ppElement.vis(2);
	double dRange = abs(vecY.dotProduct(segFrame.ptStart() - segFrame.ptEnd()));	
//	return
//region Distribution
	
//region Collect clearances
	// get clearance values
	double dElevations[0];
	int bIsAbsolutes[0]; // keep in sync with dElevations
	if (dRange>0)
	{ 
		String value = sClearance;
		String values[] = value.tokenize(";");
		
	// atof the values
		for (int i=0;i<values.length();i++) 
		{ 
			value = values[i].trimLeft().trimRight(); 
			double dValue = value.atof();
			int x = value.find("/",0);
			if (x>-1)
			{ 
				double numerator = value.left(x).atof();
				double denominator = value.right(value.length() - x-1).atof();
				if (denominator>0)
					dValue = numerator / denominator;	
			}
			if (dValue>0)
			{
				dElevations.append(dValue);
				bIsAbsolutes.append(x >- 1 ? false : true);
			}
		// check if the unlikely event happened that a user has inserted it with an catalog entry where the clearance has been a double instead of string 
			else if (value.find("Unit",0,false)>-1)
			{ 
				value = value.right(value.length() - 5);
				value = value.left(value.length() - 1);
				dValue = value.atof();
			}
	
		}//next i	
	}

	// set values to absolute clearance value
	int nNum = dElevations.length();
//	if (nNum > 1) dRange -= nNum * dYBlock;
	for (int i=0;i<dElevations.length();i++) 
	{ 
		if (!bIsAbsolutes[i])
			dElevations[i]*=dRange; 
	}//next i			
	//End Collect clearances//endregion 
	int iJustification = sJustifications.find(sJustification);
//region Loop elevations
	for (int i=0;i<dElevations.length();i++) 
	{ 
		double elevation = dElevations[i]; 
		Body blockingsA[0],blockingsB[0]; // B only used if staggered
		Beam splits[0], integrations[0],bmBlockings[0]; // beams which need to be splitted or get integrations by the blocking		
		
	// for a staggered distribution add a second offseted test body
		Body _bdTest = bdTest;
//		_bdTest.transformBy(vecY * elevation);
		if(!bIsAbsolutes[i])
		{ 
			_bdTest.transformBy(vecY * elevation);
			if(iJustification==0)
			{ 
				//top
				_bdTest.transformBy(-vecY * _bdTest.lengthInDirection(vecY));
			}
			else if(iJustification==1)
			{ 
				// middle
				_bdTest.transformBy(-vecY * .5*_bdTest.lengthInDirection(vecY));
				
			}
			else if(iJustification==2)
			{ 
				// bottom
//				_bdTest.transformBy(vecY * _bdTest.lengthInDirection(vecY));
			}
		}
		else
		{ 
			_bdTest.transformBy(vecY * elevation);
		}
		_bdTest.vis(2);
		Body bdTests[] ={ _bdTest};	
		if (bIsStaggered)
		{ 
			Body bd = bdTests.first();
			bd.transformBy(-vecY * dYBlock);
			bdTests.insertAt(0, bd);
		}
	
	//region Loop staggered / unstaggered test bodies
		for (int j=0;j<bdTests.length();j++) 
		{ 
			_bdTest = bdTests[j];
			//_bdTest.vis(j);
			
			Point3d ptCen = _bdTest.ptCen();
			Point3d pts[] = { ptCen - vecY * .5 * dYBlock, ptCen + vecY * .5 * dYBlock };
		
		// exclude openings
			for (int ii=0;ii<bdOpenings.length();ii++) 
				_bdTest.subPart(bdOpenings[ii]); 
	
		// filter all intersecting beams
			Beam _beams[0];
			if (bHasBoundary)_beams = _bdTest.filterGenBeamsIntersect(beams);
			else _beams= _bdTest.filterGenBeamsIntersect(splitters); 

		// divide collection into intersecting beams, beams to be splitted and partial intersections
			Beam intersects[0], partials[0];
			for (int ii=0;ii<_beams.length();ii++) 
			{ 
				Beam b = _beams[ii];
				int n = handles.find(_beams[ii].handle());
				if (n < 0)continue;
				Body bd =bodies[n]; 
	
			// identify if this beam will get the blocking integrated
				int bPostFilterValid = (bHasColorPostFilter && nColorPostFilters.find(b.color())>-1) || (bHasBeamTypePostFilter && nBeamTypePostFilters.find(b.type())>-1);
				double dDeltaZ = b.dD(vecZ) - dZBlock;
				if (dDeltaZ>dEps && 
					!b.vecX().isParallelTo(vecX) && 
					(bHasColorPostFilter || bHasBeamTypePostFilter) &&
					!bPostFilterValid)
				{
					if (integrations.find(b)<0) integrations.append(b);
					//bd.vis(70);
					continue;
				}

			// identify if this beam is to be splitted or integrated by the blocking
				if ( !b.vecX().isParallelTo(vecX) && 
					((bHasColorSplitFilter && nColorSplitFilters.find(b.color()) >- 1) ||
					(bHasBeamTypeSplitFilter && nBeamTypeSplitFilters.find(b.type())>-1)))
				{
				// any beam smaller than 50% of the blocking will be integrated
					if(dZBlock<.5*b.dD(vecZ) && integrations.find(b)<0) 
					{
						integrations.append(b);	
					}
				// any other beam will be splitted	
					else if (splits.find(b)<0)	
					{
						splits.append(b);
					}
					continue;
				}

			// test intersection
				bd.intersectWith(_bdTest);
				double dY = bd.lengthInDirection(vecY);
				double dZ = bd.lengthInDirection(vecZ);
				// horizontal
				if (b.vecX().isParallelTo(vecX) && abs(dY-dYBlock)>dEps)
				{ 
					bd=Body(b.ptCenSolid(), b.vecX(), b.vecD(vecY), b.vecD(vecZ), b.solidLength(), b.dD(vecY), b.dD(vecZ)+dEps, 0, 0, 0);
					_bdTest.subPart(bd);
				}
				//partial
				else if (abs(dZ-dZBlock)>dEps)
				{
					//partials.append(b);
					bd.vis(3);
				}
				else // intersection
				{
					intersects.append(b);
					bd.vis(22);
				}
			}//next ii

// now done with hsbBeamcutElement
//		// subtract partials with potential gap	
//			for (int ii=0;ii<partials.length();ii++) 
//			{  
//				Beam b = partials[ii];
//				Body bd(b.ptCenSolid(), b.vecX(), b.vecY(), b.vecZ(), b.solidLength(), b.solidWidth()+2*dGap, b.solidHeight()+2*dGap, 0, 0, 0);
//				_bdTest.subPart(bd);
//			}//next ii
			
		// subtract intersections	
			for (int ii=0;ii<intersects.length();ii++) 
			{  
				Beam b = intersects[ii];
				Vector3d vecXB = b.vecX();
				if (!vecXB.isPerpendicularTo(vecZ)) {continue};				
				Vector3d vecZB = b.vecD(vecZ);
				Vector3d vecYB = vecXB.crossProduct(-vecZB);
								
				Body bd(b.ptCenSolid(), vecXB, vecYB, vecZB, b.solidLength(), b.dD(vecYB), b.dD(vecZB)+dEps, 0, 0, 0);
				_bdTest.subPart(bd);
				
			}//next ii		
			_bdTest.vis(i);
			
			
		// decompose and filter invalid lumps
			Body lumps[] = _bdTest.decomposeIntoLumps();
			for (int ii=lumps.length()-1; ii>=0 ; ii--) 
			{ 
				Body bd=lumps[ii];
				bd.ptCen().vis(6);
				double dX = bd.lengthInDirection(vecX);
				double dY = bd.lengthInDirection(vecY);
				double dZ = bd.lengthInDirection(vecZ);
				if (dX<=dMinBlockingLength || 
					dY <= .5* dYBlock || dZ <= .5* dZBlock ||
					ppElement.pointInProfile(bd.ptCen())!=_kPointInProfile)
					lumps.removeAt(ii);
//				else
//				{
//					bd.vis(ii);
//					bd.ptCen().vis(ii);
//				}
			}//next ii	
			
		// order lumps along vecX
			for (int ii=0;ii<lumps.length();ii++) 
				for (int b=0;b<lumps.length()-1;b++) 
				{
					double d1 = vecX.dotProduct(lumps[b].ptCen() - _Pt0);
					double d2 = vecX.dotProduct(lumps[b+1].ptCen() - _Pt0);	
					if (d1>d2)lumps.swap(b, b + 1);
				}
			for (int ii=0;ii<lumps.length();ii++)			
				lumps[ii].vis(ii);
			
			if (j==0)blockingsA.append(lumps);
			else if (j==1)blockingsB.append(lumps);
			
		}//next j
	//End loop staggered / unstaggered test bodies//endregion 		

	//region Collect staggered or unstaggered bodies		
		Body blockings[0];
		// unstaggered
		if (!bIsStaggered || (blockingsA.length()>0 && blockingsB.length()<1))blockings = blockingsA;
		else if (blockingsA.length()==0 && blockingsB.length()>0)blockings = blockingsB;
		//staggered bodies
		else
		{
			int num = blockingsA.length();
			num = num > blockingsA.length() ? num : blockingsB.length();
			
			int ab = blockingsA.length()<1?1:0;
			for (int ii = 0; ii < num; ii++)
			{
				Body _blockings[0];
				if (ab == 0)_blockings = blockingsA;
				else if (ab == 1)_blockings = blockingsB;
				
				// append next blocking along vecX
				if (blockings.length() > 0)
				{
					Point3d ptLast = blockings.last().ptCen() + vecX * .5 * blockings.last().lengthInDirection(vecX);
					for (int j = 0; j < _blockings.length(); j++)
					{
						if (vecX.dotProduct(_blockings[j].ptCen() - ptLast) > 0)
						{
							blockings.append(_blockings[j]);
							break;
						}
					}//next j
				}
				// take first as initial	
				else if (_blockings.length()>0)
					blockings.append(_blockings.first());
				ab = ab == 0 ? 1 : 0;
			}//next ii
		}					
	//End add staggered blockings//endregion 	

	//region Create blockings
		for (int ii=0;ii<blockings.length();ii++) 
		{ 
			Beam b;
//			b.dbCreate(blockings[ii], vecX, vecY, vecZ, true);
			b.dbCreate(blockings[ii], vecX, vecZ, -vecY, true);
//					if (bmTConnections.length() > 0)b.stretchDynamicTo(bmTConnections.first());
//					if (bmTConnections.length() > 1)b.stretchDynamicTo(bmTConnections.last());
//				
			if (!b.bIsValid()){ continue;}
			
			bmBlockings.append(b);
			if (!bIsNailable)b.setBeamCode("BLOCKING;;;;;;;;NO;");
			b.setMaterial(material);
			b.setGrade(grade);
//			b.setGrade(sGrade);
			b.setName(sName);
			b.setColor(nColor);
			b.setType(_kSFBlocking);
			b.assignToElementGroup(el, true, 0, 'Z');
				
			if (bDebug && b.bIsValid())
			{
				b.realBody().vis(41);
				//b.dbErase(); 
			}
		}//next ii			
	//End Create blockings//endregion 

	//region Split by blocking
		Beam splitResults[0];
		for (int ii=0;ii<splits.length();ii++) 
		{ 
			Beam splitA= splits[ii]; 
			splitA.realBody().vis(3);
			Vector3d vecXA = splitA.vecX();
			Point3d ptCenA = splitA.ptCenSolid();
			Line ln(ptCenA,vecXA );
			Beam _blockings[] = splitA.realBody().filterGenBeamsIntersect(bmBlockings);
			
			for (int j=0;j<_blockings.length();j++) 
			{ 
				Beam blocking = _blockings[j];
				Point3d ptCenB = blocking.ptCenSolid();
				double dD= .5 * blocking.dD(vecY);
				Point3d ptX, pts[0];
				
				if (ln.hasIntersection(Plane(ptCenB-vecY*dD, blocking.vecD(vecY)), ptX))
					pts.append(ptX); 
				if (ln.hasIntersection(Plane(ptCenB+vecY*dD, blocking.vecD(vecY)), ptX))
					pts.append(ptX);	
				pts = ln.orderPoints(pts);
				
				if (pts.length()>1)
				{ 
				// collect expected split lengths	
					double dLA = vecXA.dotProduct(ptCenA - pts.last())+.5*splitA.solidLength();
					double dLB = vecXA.dotProduct(pts.first()-ptCenA ) +.5*splitA.solidLength();
					int bHasValidSplitLength = dLA > dMinSplitResultLength && dLB > dMinSplitResultLength;
					
					if (bDebug)
					{ 
						pts.first().vis(bHasValidSplitLength?1:3);		
						pts.last().vis(bHasValidSplitLength?2:3);	
					}
					else
					{ 
					// split if both expected split lengths > minLength
						if (bHasValidSplitLength)
						{ 
							Beam splitB;
							splitB=splitA.dbSplit(pts.first(), pts.last());
							if (splitA.bIsValid())
							{
								if (splitA.solidLength() < dMinBlockingLength)	splitA.dbErase();
								else
								{
									splitA.stretchDynamicTo(blocking);	
									splitResults.append(splitA);
								}
							}			
							if (splitB.bIsValid())
							{
								if (splitB.solidLength() < dMinBlockingLength)	splitB.dbErase();
								else
								{
									beams.append(splitB);
									splitB.stretchDynamicTo(blocking);
									splitResults.append(splitB);
								}
							}
						}
					// stretch to blocking	
						else
						{
							splitA.stretchDynamicTo(blocking);
							splitResults.append(splitA);
						}
					}
				}
			}//next j			 
		}//next ii

	//End Split by blocking//endregion 
	
	//region Add beamcuts for partial intersections
		if (dGap>=0)
		{ 
		// create TSL
			TslInst tslNew;
			GenBeam gbsTsl[] = {};		Entity entsTsl[] = {el};			Point3d ptsTsl[] = {};
			int nProps[]={};			double dProps[]={dGap};			String sProps[]={T("|bySelection|")};
			Map mapTsl;	
				
			for (int ii=0;ii<bmBlockings.length();ii++) 
			{ 
				Beam b= bmBlockings[ii]; 
				Beam partials[] = b.envelopeBody(false, true).filterGenBeamsIntersect(beams);
				for (int p=0;p<partials.length();p++) 
				{ 
					Beam partial = partials[p];
				// ignore any splits
					if (splitResults.find(partial) >- 1){ continue;}
					
					gbsTsl.setLength(0);
					gbsTsl.append(partials[p]);
					gbsTsl.append(b);					
					if (integrations.find(partial) >- 1)
						gbsTsl.swap(0, 1);
						
				// debug graphics	
					if (bDebug)
					{ 
						Body bd = gbsTsl.first().realBody();
						bd.intersectWith(gbsTsl.last().realBody());
						gbsTsl.first().vecX().vis(bd.ptCen(), 1);
						bd.vis(1);
					}
				// create tool
					else
						tslNew.dbCreate("hsbBeamcutElement" , vecX ,vecY,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
				}//next p 
			}//next ii			
		}

		if (bDebug)
		{ 
			for (int ii=bmBlockings.length()-1; ii>=0 ; ii--) 
			{ 
				//bmBlockings[ii].realBody().vis(2);
				bmBlockings[ii].dbErase(); 
				
			}//next ii
			
			
		}
	
	//End Add beamcuts for partial intersections//endregion 
	
	
	
	
	
	
	
	
	}//next i of elevations
	
//End Distribution//endregion 	
	



	if (!bDebug)
	{ 
		eraseInstance();
		return;
	}












return;




















//
//
//
//
//
//
//
//
//// two modes: 0 = per group name, 1= element
//	
//
//	
//// get max dX
//	
//
//
//// element based
//	if (_Element.length()>0)
//	{ 
//		el = _Element[0];
//		cs = el.coordSys();
//		vecX= cs.vecX();
//		vecY = cs.vecY();
//		vecZ = cs.vecZ();
//		ptOrg= cs.ptOrg();
//		beams = el.beam();
//		Plane pnZ(ptOrg, vecZ);
//		
//	// wait state
//		if (beams.length()<1)
//		{ 
//			Display dp(-1);
//			dp.textHeight(U(50));
//			dp.draw(scriptName(), el.segmentMinMax().ptMid(), vecX, vecY,0,0, _kDevice);
//			return;
//		}
//
//		segMinMax = el.segmentMinMax();
//		double dXMax = abs(vecX.dotProduct(segMinMax.ptStart()-segMinMax.ptEnd()));
//		double dYMax = abs(vecY.dotProduct(segMinMax.ptStart()-segMinMax.ptEnd()));
//	
//	
//	// get planview shadow from beams
//		PlaneProfile pp(CoordSys(ptOrg, vecX, - vecZ, vecY));
//		Plane pn(ptOrg,vecY);
//		for (int i=0;i<beams.length();i++) 
//		{ 
//			PlaneProfile _pp=beams[i].realBody().shadowProfile(pn);
//			PLine plRings[] =_pp.allRings(true, false);
//			for (int r=0;r<plRings.length();r++) 
//				pp.joinRing(plRings[r],_kAdd);  
//		}//next i
//
//	// get additional beams of adjacent elements
//		ElementWall elw = (ElementWall)el;
//		if (elw.bIsValid())
//		{ 
//			Group gr(el.elementGroup().namePart(0));
//			
//		// get bounds of zone 0	
//			LineSeg seg;
//			if (pp.area()<pow(dEps,2))
//				seg =LineSeg (ptOrg-vecX*U(10), ptOrg + vecX * (dXMax+U(10)) - vecZ * el.dBeamWidth());	
//			else
//			{ 
//				seg = pp.extentInDir(vecX);
//				seg = LineSeg (seg.ptStart() - vecX * U(10), seg.ptEnd() + vecX * U(10));
//			}
//			//seg.vis(3);
//			
//			PLine plZone0; plZone0.createRectangle(seg, vecX, vecZ);
//	
//			Body bdTest(plZone0, vecY*dYMax, 1);//bdTest.vis(252); // //HSB-5765
//			
//		// collect elements of this group and find adjacent beams
//			segMinMax = seg;
//			Entity ents[]=gr.collectEntities(true, ElementWall(), _kModelSpace); 
//			for (int i=0;i<ents.length();i++) 
//			{ 
//				Element el2 = (Element)ents[i]; 
//				if (ents[i] == el || !el2.bIsValid())continue;
//				
//				//HSB-5765
//				Beam beams2[] = bdTest.filterGenBeamsIntersect(el2.beam());
//				for (int j=0;j<beams2.length();j++) 
//				{ 
//					Beam b = beams2[j];
//					
//				// extend the segmentMinMax to left and/or right if adjacent studs are found
//					if (b.vecX().isParallelTo(vecY))
//					{
//						double dX = vecX.dotProduct(b.ptCen() - seg.ptMid());
//						if (dX<0)
//							segMinMax = LineSeg(seg.ptStart() - vecX * U(10), seg.ptEnd());
//						else
//							segMinMax = LineSeg(seg.ptStart() , seg.ptEnd()+ vecX * U(10));
//						
//						//b.realBody().vis(4);
//						beams.append(b); 
//					}
//				}//next j
//			}
//			segMinMax.vis(6);
//		}	
//
//		//bDebug = true;
//	}
//	else if (_Beam.length()>0)
//	{ 
//		beams = _Beam;
//
//	// distinguish coordSys from parent element if available
//		for (int i=0;i<beams.length();i++) 
//		{ 
//			Element e= beams[i].element();
//			if(e.bIsValid())
//			{ 
//				cs = e.coordSys();
//				vecX = cs.vecX();
//				vecY = cs.vecY();
//				vecZ = cs.vecZ();
//				ptOrg = cs.ptOrg();
//				break;
//			}
//		}//next i
//		
//	// no element ref found
//		if (vecX.bIsZeroLength())
//		{ 
//
//		// rate vecX of each beam to evaluate main direction
//			Vector3d vecs[0];
//			int rates[0];
//			for (int i=0;i<beams.length();i++)
//			{ 
//				Vector3d vecX = beams[i].vecX();
//				int n = -1;
//				for (int j=0;j<vecs.length();j++)
//					if (vecs[j].isParallelTo(vecX))
//					{
//						n = j;
//						break;
//					}
//				if (n>-1)
//					rates[n]++;
//				else
//				{ 
//					vecs.append(vecX);
//					rates.append(1);
//				}
//			}
//			
//		// order by rate
//			for (int i=0;i<vecs.length();i++) 
//				for (int j=0;j<vecs.length()-1;j++) 
//					if (rates[j]<rates[j+1])
//					{
//						vecs.swap(j, j + 1);
//						rates.swap(j, j + 1);	
//					}
//			if (vecs.length()>0)
//				vecY = vecs.first();
//			
//		// swap main direction if orthogonal to world
//			if (vecY.isParallelTo(_XW))vecY = _XW;
//			else if (vecY.isParallelTo(_YW))vecY = _YW;
//			else if (vecY.isParallelTo(_ZW))vecY = _ZW;
//
//			Beam bmVerticals[0];
//			for (int i=0;i<beams.length();i++) 
//				if(beams[i].vecX().isParallelTo(vecY))
//					bmVerticals.append(beams[i]);
//					
//		// validate verticals				
//			if (bmVerticals.length()>1)
//			{
//				Beam& bmFirst = bmVerticals.first();
//				Beam& bmLast = bmVerticals.last();
//				
//				vecX = bmFirst.vecD(bmLast.ptCen() - bmFirst.ptCen());
//				vecZ = vecX.crossProduct(vecY);
//				
//			// check side
//				if (vecZ.isParallelTo(bmFirst.vecZ()))
//				{ 
//					vecZ = bmFirst.vecZ();
//					vecX = vecY.crossProduct(vecZ);
//				}
//				else if (vecZ.isParallelTo(bmFirst.vecY()))
//				{ 
//					vecZ = bmFirst.vecY();
//					vecX = vecY.crossProduct(vecZ);
//				}				
//				
//				_Pt0 =  bmFirst.ptCenSolid() + vecZ * .5 * bmFirst.dD(vecZ) - vecY * .5 * bmFirst.solidLength()- vecX*.5*bmFirst.dD(vecX);
//				ptOrg = _Pt0;
//				cs = CoordSys(_Pt0,vecX, vecY, vecZ);
//			}
//		}
//		
//		cs.vis(2);
//
//	}	
//	
//{ 
//	
//	
//	
//	
//// validate and declare element variables
//	if (_Element.length()<1 && _Beam.length()<1)
//	{
//		reportMessage(TN("|Element reference not found.|"));
//		eraseInstance();
//		return;	
//	}
//
//	vecX.vis(ptOrg, 1);
//	vecY.vis(ptOrg, 3);
//	vecZ.vis(ptOrg, 150);
//	//segMinMax.vis(2);
//	Plane pnZ(ptOrg, vecZ);
//
//// get alignment
//	int nAlignment = sAlignments.find(sAlignment, 0); // 0= Icon, 1=center, 2 = opposite icon
//
//	double dXMax = abs(vecX.dotProduct(segMinMax.ptStart()-segMinMax.ptEnd()));	
//
//// get base plate(s), vertical beams and non vertical beams
//	Beam bmHorizontals[] = vecY.filterBeamsPerpendicularSort(beams);
//	Beam bmVerticals[] = vecX.filterBeamsPerpendicularSort(beams);
//	Beam bmNonVerticals[0];
//	for (int i=0;i<beams.length();i++) 
//		if (!beams[i].vecX().isParallelTo(vecY))
//			bmNonVerticals.append(beams[i]); 
//
//// set blocking dimensions
//	double dYBlock = dHeight;
//	double dZBlock=dWidth, dXBlock = dXMax;
//	if(el.bIsValid())
//	{ 
//		if (dYBlock<=0)	dYBlock = el.dBeamHeight();
//		if (dZBlock<=0)	dZBlock = el.dBeamWidth();
//	}
//	else if (dYBlock<=0 || dZBlock<=0)
// 	{ 
//		Beam bm = bmVerticals.length() > 0 ? bmVerticals[0] : (beams.length()>0?beams[0]:Beam());
//		if (!bm.bIsValid())
//		{ 
//			reportMessage("\n" + scriptName() + ": " +T("|cannot automatically identify section|"));
//			eraseInstance();
//			return;
//			
//		}
//		if (dYBlock <= 0)		dYBlock = bm.dD(vecX);
//		if (dZBlock <= 0)		dZBlock = bm.dD(vecZ);
//	}
//
//// get base location	
//	Point3d ptBottom;
//	for (int i=0;i<bmHorizontals.length();i++) 
//	{ 
//		Beam& bm = bmHorizontals[i];
//		if (!bm.bIsValid())continue;
//		//bm.realBody().vis(6);
//		Point3d pt = bm.ptCenSolid() + vecY*.5*bm.dD(vecY);
//		if (i==0 || vecY.dotProduct(pt-ptBottom)<0)
//			ptBottom = pt;
//	}
//
//// get base location from extremes if no horizontals found
//	if (bmHorizontals.length()<1)
//	{ 
//		int bOk=true;
//		if (el.bIsValid())
//			ptBottom = ptOrg;
//		else
//		{ 
//			Point3d pts[0];
//			for (int i=0;i<bmVerticals.length();i++) 
//				pts.append(bmVerticals[i].envelopeBody(true,true).extremeVertices(vecY)); 
//			pts = Line(_Pt0,vecY).orderPoints(pts);
//			if (pts.length()>0)
//				ptBottom = pts.first();
//			else
//				bOk = false;
//		}
//		
//		if (!bOk)
//		{
//			reportMessage("\n" + scriptName() + ": " +T("|could not find reference location.|"));
//			if (!bDebug)eraseInstance();
//			return;
//		}
//	}		
//	ptBottom.vis(2);
//
//// get frame profile in element view
//	PlaneProfile ppElement(cs);
//	for (int i=0;i<beams.length();i++) 
//	{ 
//		PlaneProfile pp=beams[i].envelopeBody(false,true).shadowProfile(Plane(ptOrg, vecZ));
//		PLine rings[] = pp.allRings(true, false);
//		for (int r=0;r<rings.length();r++) 
//			ppElement.joinRing(rings[r], _kAdd);
//	}//next i
//	ppElement.shrink(-dEps);ppElement.shrink(dEps); 
//	ppElement.vis(2);
//	
//// get bounding elkement profile
//	PlaneProfile ppElementBound = ppElement;
//	ppElementBound.removeAllOpeningRings();
//	
//// get vertical distribution point
//	Point3d ptTop = ppElement.extentInDir(vecX).ptEnd();
//	{ 
//		PLine rings[] = ppElement.allRings(false, true);
//		if (rings.length()<1)
//			rings = ppElement.allRings(true, false);
//		Point3d pts[0];
//		for (int i=0;i<rings.length();i++) 
//			pts.append(rings[i].vertexPoints(true)); 
//		pts = Line(_Pt0, -vecY).orderPoints(pts);
//		if (pts.length() > 0)ptTop = pts.first();
//	}
//	ptTop.vis(4);
//	double dRange = vecY.dotProduct(ptTop - ptBottom);
//
//
//// get clearance values
//	double dValues[0];
//	int bIsAbsolutes[0]; // keep in sync with dValues
//	if (dRange>0)
//	{ 
//		String value = sClearance;
//		String values[] = value.tokenize(";");
//		
//	// atof the values
//		for (int i=0;i<values.length();i++) 
//		{ 
//			value = values[i].trimLeft().trimRight(); 
//			double dValue = value.atof();
//			int x = value.find("/",0);
//			if (x>-1)
//			{ 
//				double numerator = value.left(x).atof();
//				double denominator = value.right(value.length() - x-1).atof();
//				if (denominator>0)
//					dValue = numerator / denominator;	
//			}
//			if (dValue>0)
//			{
//				dValues.append(dValue);
//				bIsAbsolutes.append(x >- 1 ? false : true);
//			}
//		// check if the unlikely event happened that a user has inserted it with an catalog entry where the clearance has been a double instead of string 
//			else if (value.find("Unit",0,false)>-1)
//			{ 
//				value = value.right(value.length() - 5);
//				value = value.left(value.length() - 1);
//				dValue = value.atof();
//			}
//	
//		}//next i	
//	}
//
//// set values to absolute clearance value
//	{ 
//		int nNum = dValues.length();
//		if (nNum > 1) dRange -= nNum * dYBlock;
//		for (int i=0;i<dValues.length();i++) 
//		{ 
//			if (!bIsAbsolutes[i])
//				dValues[i]*=dRange;  
//		}//next i
//	}
//
//
//// get post filter criterias
//	String sFilters[] = sPostFilter.tokenize(";");
//	int nBeamTypeFilters[0];
//	int nColorFilters[0];
//	for (int i=0;i<sFilters.length();i++) 
//	{ 
//		String sFilter = sFilters[i];
//		int c = sFilter.atoi();
//		int n = _BeamTypes.find(sFilters[i]);
//		if ((String)c==sFilters[i])
//			nColorFilters.append(c);
//		else if (n>-1)
//			nBeamTypeFilters.append(n); 
//	}
//
//// get split filter criterias
//	String sSplitFilters[] = sSplitFilter.tokenize(";");
//	int nBeamTypeSplitFilters[0];
//	int nColorSplitFilters[0];
//	for (int i=0;i<sSplitFilters.length();i++) 
//	{ 
//		String sFilter = sSplitFilters[i];
//		int c = sFilter.atoi();
//		int n = _BeamTypes.find(sSplitFilters[i]);
//		if ((String)c==sSplitFilters[i])
//			nColorSplitFilters.append(c);
//		else if (n>-1)
//			nBeamTypeSplitFilters.append(n); 
//	}
//	int bHasBeamTypeFilter = nBeamTypeSplitFilters.length() > 0;
//	int bHasColorSplitFilter = nColorSplitFilters.length() > 0;
//	int bIsStaggered = sNoYes.find(sStaggered) == 1;
//	int bIsNailable = sNailings.find(sNailing) == 1;
//
//// any horizontal in same plane is considered to be a base plate
//	Beam bmBasePlates[0];
//	for (int i = 0; i < bmHorizontals.length(); i++)
//	{
//		Beam& bm = bmHorizontals[i];
//		if (!bm.bIsValid())continue;
//		Point3d pt = bm.ptCenSolid() + vecY * .5 * bm.dD(vecY);
//		if(abs(vecY.dotProduct(pt-ptBottom))<dEps)
//		{
//			bmBasePlates.append(bm);
//			int x = beams.find(bm);
//			if (x >- 1)beams.removeAt(x);
//		}
//	}
//	if (bDebug)	for (int i=0;i<bmBasePlates.length();i++) bmBasePlates[i].realBody().vis(3); 
//	
//// get separating posts
//	
//	Beam bmPosts[0];
//	if (el.bIsValid() && _Beam.length() > 1)
//	{
//		bmPosts.append(_Beam);
//	
//	// deprecated 1.5 HSB-5765
//	// get max dimensions, override segmentMinMax by total width including adjacent beams
//		{
////			PlaneProfile pp(cs);
////			for (int i=0;i<_Beam.length();i++) 
////			{ 
////				Body bd = _Beam[i].envelopeBody();
////				pp.unionWith(bd.shadowProfile(pnZ)); 
////			}
////			segMinMax = pp.extentInDir(vecX);
//			segMinMax.vis(2);
//			dXMax = abs(vecX.dotProduct(segMinMax.ptStart()-segMinMax.ptEnd()));
//		}	
//	}
//	else
//	{ 
//		for (int i=bmVerticals.length()-1; i>=0 ; i--) 
//		{ 
//			Beam& bm= bmVerticals[i]; 
//			if (!bm.bIsValid())continue;
//			int c = bm.color();
//			int n = bm.type();
//		
//			if (nColorFilters.find(c)>-1 || nBeamTypeFilters.find(n)>-1)
//			{ 
//				bmPosts.append(bm);
//				int x = beams.find(bm);
//				if (x >- 1)beams.removeAt(x);
//				bmVerticals.removeAt(i);
//			}
//		}		
//	}
//
//// get first and last as default
//	if (bmPosts.length() < 2 && bmVerticals.length()>1)
//	{ 
//		bmPosts.append(bmVerticals.first());
//		bmPosts.append(bmVerticals.last());	
//	}
//	
//	
//	
//	if (bmPosts.length() < 2)
//	{
//		reportMessage("\n" + scriptName() + ": " + T("|at least two posts required.|"));
//		if (!bDebug)eraseInstance();
//		return;
//	}
//	if (bDebug)	for (int i=0;i<bmPosts.length();i++) bmPosts[i].realBody().vis(54); 
//
//// stretch any intermediate stud to the base plates (if inserted a second time with a lower clearance this could be required)
//	if (nColorSplitFilters.length()==0 || nBeamTypeSplitFilters.length()==0)
//		for (int i=bmVerticals.length()-1; i>=0 ; i--) 
//		{ 
//			Beam& bm= bmVerticals[i];
//			if (!bm.bIsValid())continue;
//			Beam bmContacts[]=bm.filterBeamsTConnection(bmHorizontals,U(200), true );
//			if (bmContacts.length()>0)
//			{
//				bm.stretchDynamicTo(bmContacts[0]);	
//			}			
//		}
//
//// set alignment
//	double dZOffset;
//	if (nAlignment>0)
//	{ 
//		dZOffset = el.bIsValid() ? el.dBeamWidth() : 0;
//		dZOffset -= dZBlock;
//		if (nAlignment == 1)dZOffset *= .5;
//	}
//
//
////region loop blocking locations
//	Point3d ptRef = segMinMax.ptMid();
//	ptRef+=vecY * vecY.dotProduct(ptBottom - ptRef)+vecZ*vecZ.dotProduct(ptOrg-ptRef);
//	
//	for (int n=0;n<dValues.length();n++) 
//	{ 
//		double dClearance= dValues[n]; 
//		Beam _beams[0];_beams = beams;
//	
//	// location and location test
//		ptRef +=  vecY*dClearance;
//		if (ppElementBound.pointInProfile(ptRef) == _kPointOutsideProfile)
//		{
//			ptRef += vecY * dYBlock;
//			continue;
//		}
//		
//		
//	// find intersecting beams
//		//Body bdTest(ptRef+vecZ*dEps, vecX, vecY, vecZ, dXBlock, dYBlock, dZBlock+2*dEps, 0, 1 ,- 1); // HSB-5728 prior 1.4
//		Body bdTest(ptRef, vecX, vecY, vecZ, dXBlock, dYBlock, dZBlock, 0, 1 ,- 1);
//		ptRef.vis(4);
//		if (el.bIsValid())
//		{ 
//			Opening openings[] = el.opening();
//			for (int i=0;i<openings.length();i++) 
//				bdTest.subPart(Body(openings[i].plShape(), vecZ*U(10e4),0)); 		 	
//		}
//	
//	// plane of blocking
//		Plane pnBlock(ptRef + vecY * .5*dYBlock, vecY);	
//		
//	// set alignment
//		bdTest.transformBy(-vecZ * dZOffset);
//		//bdTest.vis(40);
//	
//		Beam bmIntersects[] = bdTest.filterGenBeamsIntersect(_beams);
//		Beam bmSplitters[0];bmSplitters = bmPosts;
//		for (int i=bmIntersects.length()-1; i>=0 ; i--) 
//		{ 
//			Beam& bm= bmIntersects[i]; 
//			if (!bm.bIsValid())continue;
//			
//		// collect splitter	
//			int bAddSplitter = !bHasBeamTypeFilter && !bHasColorSplitFilter; // add any beam if no beamtype or color filter has been set
//			
//		// set spliiter flag based on color filter	
//			if (bHasColorSplitFilter)
//			{
//				bAddSplitter = nColorSplitFilters.find(bm.color()) >- 1;
//				if (bAddSplitter && bHasBeamTypeFilter)
//					bAddSplitter = nBeamTypeSplitFilters.find(bm.type()) >- 1;
//			}
//			else if (bHasBeamTypeFilter)
//				bAddSplitter = nBeamTypeSplitFilters.find(bm.type()) >- 1;
//	
//		// collect diagonal
//			Vector3d vecXBm = bm.vecX();
//			if (!vecXBm.isParallelTo(vecX) && !vecXBm.isParallelTo(vecY))
//			{ 
//				Body bdX = bm.envelopeBody(true,true);
//				bdX.subPart(bdTest);
//				bdX.vis(53);
//				Body bodies[] = bdX.decomposeIntoLumps();
//			
//			// diagonal will not be spliited by blocking
//				if (bodies.length()<2)
//					bAddSplitter = false;
//				
//			}
//	
//			if (bAddSplitter && bmSplitters.find(bm)<0)
//			{ 
//				//bm.realBody().vis(6);
//				bmSplitters.append(bm);
//				int x = _beams.find(bm);
//				if (x >- 1)_beams.removeAt(x);
//				bmIntersects.removeAt(i);
//			}
//		}
//	
//	// create bodies from splitter intersection	
//		for (int i=0;i<bmSplitters.length();i++) 
//		{ 
//			Beam& bm= bmSplitters[i]; 
//			if (!bm.bIsValid())continue;
//			double dXB=bm.solidLength(), dYB =bm.dD(vecX), dZB= bm.dD(vecZ);
//			
//		// splitter is fully splitting	
//			if ((dZBlock-dZB)<dEps)
//				dZB *= 2;
//		// splitter is beamcutting the blocking
//			else
//			{
//				dZB += 2*dGap;
//				dYB += 2*dGap;
//			}
//			Body bd(bm.ptCenSolid(), bm.vecX(), bm.vecD(vecX), bm.vecD(vecZ), dXB, dYB, dZB, 0, 0, 0);
//			if(n>0)bd.vis(5);
//			bdTest.subPart(bd); 	 
//		}
//		
//	// get bodies ordered along vecX
//		Body bodies[] = bdTest.decomposeIntoLumps();
//		for (int i=0;i<bodies.length();i++) 
//			for (int j=0;j<bodies.length()-1;j++) 
//			{
//				double d1 = vecX.dotProduct(bodies[j].ptCen()-_Pt0);
//				double d2 = vecX.dotProduct(bodies[j+1].ptCen()-_Pt0);
//				if (d1>d2)
//					bodies.swap(j, j + 1);
//			}
//				
//			
//		for (int i=0;i<bodies.length();i++) 
//		{ 
//			Body& bd = bodies[i];
//
//		// skip very shorts	
//			if (bd.lengthInDirection(vecX) < dMinBlockingLength)continue;
//			
//			Beam bmBlocking;
//			bmBlocking.dbCreate(bd, vecX, vecY, vecZ, true);		
//			Beam bmTConnections[] = bmBlocking.filterBeamsTConnection(bmSplitters, dEps, true);
//			
//			if (bIsStaggered && i%2==1)
//				bmBlocking.transformBy(vecY * bmBlocking.dD(vecY));
//
//		
//		// subtract any beam above (i.e. if number clearances exceeds range)
//			Beam bmFrameIntersects[] = bmBlocking.filterBeamsCapsuleIntersect(bmNonVerticals);
//			for (int j=0;j<bmFrameIntersects.length();j++) 
//			{
//				Beam& b = bmFrameIntersects[j];
//				BeamCut bc(b.ptCen(), b.vecX(), b.vecY(), b.vecZ(), b.solidLength(), b.solidWidth(), b.solidHeight(), 0, 0, 0);
//				bmBlocking.addToolStatic(bc);
//				//bd.subPart(bmFrameIntersects[j].envelopeBody(false,true)); 
//			}
//			if (bmBlocking.solidLength()<=dMinBlockingLength)
//			{
//				bmBlocking.dbErase();
//				continue;
//			}
//
//
//			if (bDebug)	
//			{
//				bmBlocking.realBody().vis(n+1); 
//				if (bmBlocking.bIsValid())bmBlocking.dbErase();
//			}
//			else
//			{ 
//				if (bmTConnections.length() > 0)bmBlocking.stretchDynamicTo(bmTConnections.first());
//				if (bmTConnections.length() > 1)bmBlocking.stretchDynamicTo(bmTConnections.last());
//				
//				if (!bIsNailable)bmBlocking.setBeamCode("BLOCKING;;;;;;;;NO;");
//				bmBlocking.setMaterial(sMaterial);
//				bmBlocking.setGrade(sGrade);
//				bmBlocking.setName(sName);
//				bmBlocking.setColor(nColor);
//				bmBlocking.setType(nBlockingBeamType);
//				if (el.bIsValid())
//					bmBlocking.assignToElementGroup(el, true, 0, 'Z');
//				else if(_beams.length()>0)
//					bmBlocking.assignToGroups(_beams[0]);
//				bmIntersects.append(bmBlocking);	
//			}
//			
//		// test intersection
//			Beam bmStretchers[] = bd.filterGenBeamsIntersect(bmIntersects);
//			
//			for (int j=0;j<bmStretchers.length();j++) 
//			{ 
//				Beam& bm= bmStretchers[j];
//				Vector3d vecXBm = bm.vecX();
//				int bIsDiagonal = !vecXBm.isParallelTo(vecX) && !vecXBm.isParallelTo(vecY);
//				
//			// if it is a digonal search for a potential post in the given direction and stretch multiple
//				if (bIsDiagonal)
//				{
//					//bm.realBody().vis(3);pnBlock.vis(7);
//					Point3d ptX;
//					int nDir = 1;
//					if (Line(bm.ptCenSolid(), vecXBm).hasIntersection(pnBlock, ptX) == false) continue;
//					if (vecXBm.dotProduct(ptX - bm.ptCenSolid()) < 0)
//					{
//						vecXBm *= -1;
//						nDir *= -1;				 
//					}
//					
//					vecXBm.vis(ptX,1);
//					Beam bmContacts[]=bm.filterBeamsCapsuleIntersect(bmSplitters);
//					for (int k=bmContacts.length()-1; k>=0 ; k--) 
//					{
//						Beam& bmC= bmContacts[k];
//						if (!bmC.bIsValid())continue;
//						Point3d ptXC=ptX;
//						Line(ptX, vecXBm).hasIntersection(Plane(bmC.ptCenSolid(), vecX), ptXC);
//						ptXC.vis(4);
//						if (vecXBm.dotProduct(ptXC-bm.ptCenSolid())<0)
//						{
//							ptXC.vis(1);
//							bmContacts.removeAt(k);
//						}
//						else
//							ptXC.vis(3);
//					}
//	
//					
//					if(bmBlocking.bIsValid())
//					{
//						bm.addToolStatic(Cut(ptX, vecXBm), _kStretchOnInsert); // make sure it looses temp cuts
//						double d = bm.solidLength();
//						bmContacts.append(bmBlocking);
//						if (bmContacts.length()==1)bm.stretchDynamicTo(bmContacts[0]);
//						else if (bmContacts.length()>1)bm.stretchDynamicToMultiple(bmContacts[0],bmContacts[1]);
//					}
//					else 
//						vecXBm.vis(ptX,1);
//					//bmContacts[0].realBody().vis(3);
//				}
//			// if it is not a splitted blocking stretch the studs to the blocking
//				else if (bmBlocking.bIsValid() && bmSplitters.length()==bmPosts.length())
//				{ 
//					bm.stretchDynamicTo(bmBlocking);
//				} 
//			}
//		}
//		
//		//bdTest.vis(8);		
//		ptRef += vecY * dYBlock;
//	}//next n
//		
////End loop blocking locations//endregion 
//
//
//
//
//	
//	
//	
//	if (!bDebug)
//	{ 
//		eraseInstance();
//		return;
//	}
//	else
//		_Pt0.vis(1);
//
//
//
//}
//	
//
//







#End
#BeginThumbnail
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
AC4)/OB.(?[39_EFM_1M'.E^8S3"1I``0%P!BM6B@#__9
`





















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
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13467: expose sequence number, align blocking Coord so that width is aligned with wall width" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="11/4/2021 12:02:56 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13467: fix grade" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="11/3/2021 1:48:47 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13467: add sequenceNumber" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="11/2/2021 4:41:09 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-11517 accepting a gap &gt;=0 to integrate blocking, set gap &lt; 0 to exclude. Devualt beamtype changed to SFBlocking" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="5/17/2021 12:50:14 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End