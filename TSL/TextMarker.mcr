#Version 8
#BeginDescription
#Versions
Version 1.1    15.03.2021 
HSB-10890 strategy to filter outside beams more tolerant  , Author Thorsten Huck
Version 1.0    15.03.2021
HSB-10890 initial version of TextMarker , Author Thorsten Huck

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
//region Part #1
		
//region <History>
// #Versions
// 1.1 15.03.2021 HSB-10890 strategy to filter outside beams more tolerant  , Author Thorsten Huck
// 1.0 15.03.2021 HSB-10890 initial version of TextMarker , Author Thorsten Huck

/// <insert Lang=en>
/// Select elements or indivisual genbeams
/// </insert>

// <summary Lang=en>
// This tsl creates textmarkers on genbeams
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "TextMarker")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Create individual text markeres|") (_TM "|Select TextMarker|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add free location|") (_TM "|Select TextMarker|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Select free location|") (_TM "|Select TextMarker|"))) TSLCONTENT
//endregion

//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug = _bOnDebug || _kShiftKeyPressed;
	if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());		

	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	
	String sPainterCollection = "TextMarking\\";
	String sDisabled = T("<|Disabled|>");
	
	String sXParallel = T("|X-Parallel|");
	String sYParallel = T("|Y-Parallel|");
	String sNonOrthogonal = T("|Non Orthogonal|");
	String sPainterFrame = T("|Frame|");
	
	String sDefaultPainters[] ={ sPainterFrame,sXParallel,sYParallel,sNonOrthogonal};
	String sDefaultTypes[] ={  "Beam","Beam", "Beam", "Beam"};
	String sDefaultFilters[] =
	{
		"(Equals(IsDummy,'false'))and(Equals(ZoneIndex,0))",
		"(Equals(IsParallelToElementX,'true'))and(Equals(IsDummy,'false'))and(Equals(ZoneIndex,0))",
		"(Equals(IsParallelToElementY,'true'))and(Equals(IsDummy,'false'))and(Equals(ZoneIndex,0))",
		"(IsParallelToElementX != 'true')and(IsParallelToElementY != 'true')and(Equals(IsDummy,'false'))and(Equals(ZoneIndex,0))"
	};
	
	
//region View // version 23 and higher
	Vector3d vecZView = getViewDirection();
// distinguish if current background is light or dark	
	int bIsDark;{int n = getBackgroundTrueColor();bIsDark = ((rgbR(n) + rgbB(n) + rgbG(n)) / 3 < 127);}
	int nc = 3;
//End View//endregion	
	
//end Constants//endregion

//region Get Painters and/or create default painters
	String sAllPainters[] = PainterDefinition().getAllEntryNames().sorted();
	String sPainters[0];
	for (int i = 0; i < sAllPainters.length(); i++)
	{
		if (sAllPainters[i].find(sPainterCollection,0,false)!=0){ continue;}
		
		String sPainter = sAllPainters[i].right(sAllPainters[i].length() - sPainterCollection.length());
		if (sPainters.findNoCase(sPainter,-1)<0)
			sPainters.append(sPainter);
	}
	for (int i=0;i<sDefaultPainters.length();i++) 
	{ 
	// create default painter	
		String sPainter = sDefaultPainters[i];
		if (sPainters.findNoCase(sPainter,-1)<0)
		{ 
			PainterDefinition p(sPainterCollection+sPainter);
			p.dbCreate();
			p.setType(sDefaultTypes[i]);
			p.setFilter(sDefaultFilters[i]);
			
			if (p.bIsValid())sPainters.append(sPainter);
		}
	}//next i
//End Painter//endregion 

//region bOnJig
	int bJig = _bOnGripPointDrag && _kExecuteKey == "_PtG0";
	Point3d ptJig;
	if (bJig)
	{ 
		ptJig = _PtG[0];//_Map.getPoint3d("_PtJig"); // running point

		
	}
	
//endregion

//region Properties

category = T("|Content|");	
	String sFormatName=T("|Format|");	
	PropString sFormat(nStringIndex++, "@(ElementNumber)_@(ProjectName)_@(ProjectComment)", sFormatName);	
	sFormat.setDescription(T("|Defines the Format|"));
	sFormat.setCategory(category);
		
	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(60), sTextHeightName);	
	dTextHeight.setDescription(T("|Defines the text height|"));
	dTextHeight.setCategory(category);
	
category = T("|Placement|");
	String sTextOrientations[] = {T("|Outside|"), T("|XZ-Plane|"), T("|XY-Plane|"),T("|YZ-Plane|"),
	T("|Negative XZ-Plane|"), T("|Negative XY-Plane|"), T("|Negative YZ-Plane|")};
	String sTextOrientationName=T("|Text Orientation|");	
	PropString sTextOrientation(nStringIndex++, sTextOrientations, sTextOrientationName);	
	sTextOrientation.setDescription(T("|Defines the text orientation| ")+ 
		T("|'Outside' is only available for beams associated to zone 0 of an element and applies the marking to the subset of the outer beams|"));	
	sTextOrientation.setCategory(category);

	String sTextAlignmentName=T("|Alignment|");	
	String sTextAlignments[] = {T("|Top-Left|"), T("|Top-Center|"), T("|Top-Right|"),
		T("|Center-Left|"), T("|Center-Center|"), T("|Center-Right|"),
		T("|Bottom-Left|"), T("|Bottom-Center|"), T("|Bottom-Right|")};
	PropString sTextAlignment(nStringIndex++, sTextAlignments, sTextAlignmentName);	
	sTextAlignment.setDescription(T("|Defines the TextAlignment|"));
	sTextAlignment.setCategory(category);
	
	String sAngleName=T("|Angle|");	
	PropDouble dAngle(nDoubleIndex++, U(0), sAngleName);	
	dAngle.setDescription(T("|Defines the rotation angle of the text|"));
	dAngle.setCategory(category);

category = T("|Filter|");
	String sFilters[0];sFilters=sPainters.sorted();
	sFilters.insertAt(0, sDisabled);
	String sFilterName=T("|Filter|");	
	PropString sFilter(nStringIndex++, sFilters, sFilterName);	
	sFilter.setDescription(T("|Defines the Filter|"));
	sFilter.setCategory(category);
		
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
		
		
	// prompt for elements
		PrEntity ssE(T("|Select elements or individual genbeams|"), Element());
		ssE.addAllowedClass(GenBeam());
	  	if (ssE.go())
		{
			_Element.append(ssE.elementSet());
			if (_Element.length()<1)
			{ 
				Entity ents[] = ssE.set();
				for (int i=0;i<ents.length();i++) 
				{ 
					GenBeam gb = (GenBeam)ents[i]; 
					if (gb.bIsValid())
						_GenBeam.append(gb);
				}//next i
			}
		}
	
	// create TSL
		TslInst tslNew;				Map mapTsl;
		int bForceModelSpace = true;	
		String sExecuteKey,sCatalogName = sLastInserted;
		String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
		GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[1];
	
	// element based
		for (int i=0;i<_Element.length();i++) 
		{ 
			Element el = _Element[i]; 
			entsTsl.setLength(0);
			entsTsl.append(el);
			
			ptsTsl[0] = el.ptOrg();
			tslNew.dbCreate(scriptName() , el.vecX() ,el.vecY(),gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 
		}//next i
		
	// genbeam based
		if (_GenBeam.length()==1)
		{
			GenBeam gb = _GenBeam[0];
		// prompt for point input
			PrPoint ssP(TN("|Select point (optional)|")); 
			if (ssP.go()==_kOk) 
			{
				Vector3d vecL = gb.solidLength() * .5 * gb.vecX();
				PLine pl(gb.ptCen() - vecL, gb.ptCen() + vecL);	
				ptsTsl.append(pl.closestPointTo(ssP.value())); // append the selected points to the list of grippoints _PtG
			}
		}
		for (int i=0;i<_GenBeam.length();i++) 
		{ 
			GenBeam gb = _GenBeam[i];
			Element el = gb.element(); 
			entsTsl.setLength(0);
			gbsTsl.setLength(0);
			gbsTsl.append(gb);
			if (el.bIsValid())
				entsTsl.append(el);
			ptsTsl[0] = gb.ptCen();
			mapTsl.setInt("isSingle", true); // as soon as the free text is attached the _GenBeam carries the gb of the ft	
			tslNew.dbCreate(scriptName() , gb.vecX() ,gb.vecY(),gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 
		}//next i			

		eraseInstance();
		return;
	}	
// end on insert	__________________//endregion

//End Part #1
//endregion 

//region Part #2

//region References
	GenBeam gbs[0];
	Element el;
	CoordSys cs;
	
	int bIsSingle = _Map.getInt("isSingle") && _GenBeam.length() > 0;
	int bHasElement = _Element.length() > 0;
	if (_PtG.length()>0)addRecalcTrigger(_kGripPointDrag, "_PtG0");
	_ThisInst.setAllowGripAtPt0(false);
	
	double dZ;
	
	if (bIsSingle)
	{ 
		GenBeam gb = _GenBeam[0];
		dZ = gb.dH();
		gbs.append(gb);
		cs = gb.coordSys();
		if (!bHasElement)
		{ 
			el = gb.element();
			if (el.bIsValid())
			{ 
				_Element.append(el);
				setExecutionLoops(2);
				return;
			}
			else
				assignToGroups(gb, 'T');
		}
		else
			el = _Element[0];
	}
	else if (bHasElement)
	{ 
		el = _Element[0];
		gbs = el.genBeam();
	}
	else
	{ 
		reportMessage(TN("|Element reference not found.|"));
		eraseInstance();
		return;			
	}

	if (bHasElement)
	{ 
		cs = el.coordSys();
		dZ = el.dBeamWidth();
	}

	Vector3d vecX = cs.vecX();
	Vector3d vecY = cs.vecY();
	Vector3d vecZ = cs.vecZ();
	Point3d ptOrg = cs.ptOrg();
	if (el.bIsValid())
		assignToElementGroup(el,true, 0,'E');// assign to element tool sublayer
	//cs.vis(2);
	Plane pnZ(ptOrg, vecZ);
	

	
	//Get the text alignment
	int nTextAlignment = sTextAlignments.find(sTextAlignment); // Top-Left / ... / Center-Center / ... / Bottom-Right
	int xPos;
	if (nTextAlignment%3==0) xPos=-1; //If can be divided by 3 Then its Left Side -1
	else if ((nTextAlignment-2)%3==0) xPos=1; //If +2 can be divided by 3 then its Right Side 1
	int yPos;
	if (nTextAlignment<3) yPos=1; //If smaller then 3 then it's Top Side
	else if (nTextAlignment>5) yPos=-1; //If bigger then 5 then it's Bottom Side
	
	
	//Get the text orientation
	int nTextOrientation = sTextOrientations.find(sTextOrientation,0);
	int bOutside = 	nTextOrientation == 0 && bHasElement;
	
	Display dp(-1), dpText(1), dpErr(1);
	dp.trueColor(bJig?rgb(212,252,171):rgb(240, 240, 240));
	dp.textHeight(dTextHeight);
	dpText.textHeight(dTextHeight);
//End References//endregion

//region Get entities to be marked
	if (sAllPainters.findNoCase(sPainterCollection+sFilter,-1)>-1)
	{ 
		PainterDefinition pd(sPainterCollection + sFilter);
		if (pd.bIsValid())
			gbs = pd.filterAcceptedEntities(gbs);
	}
	
// get subset if outside
	PlaneProfile ppContour(cs);	
	if (bOutside)
	{ 	
		Beam beams[] = el.beam();
		
		if(el.bIsKindOf(ElementRoof()))
			ppContour.joinRing(el.plEnvelope(), _kAdd);
		else
		{ 
			for (int i=0;i<beams.length();i++) 
			{ 
				PlaneProfile pp = beams[i].envelopeBody(true, true).shadowProfile(pnZ);
				pp.shrink(-dEps);
				ppContour.unionWith(pp);
			}//next i
			ppContour.shrink(dEps);
			ppContour.removeAllOpeningRings();			
		}

	// test intersection
		GenBeam gbsOut[0];
		PLine rings[] = ppContour.allRings(true, false);
		for (int r=0;r<rings.length();r++) 
		{ 
			Point3d pts[] = rings[r].vertexPoints(false);
			
			for (int p=0;p<pts.length()-1;p++) 
			{ 
				Point3d pt1 = pts[p]; 
				Point3d pt2 = pts[p+1]; 
				Vector3d vecXS = pt2-pt1; 
				double dXS = vecXS.length();
				vecXS.normalize();
				Vector3d vecYS = vecXS.crossProduct(-vecZ);
				
				Body bd(pt1, vecXS, vecYS, vecZ, dXS, U(40), dZ, 1, 0 ,- 1 );
				bd.vis(p);
				
				Beam bmInts[] = bd.filterGenBeamsIntersect(beams);
				bmInts = vecXS.filterBeamsParallel(bmInts);
				
				for (int b=0;b<bmInts.length();b++) 
					if(gbsOut.find(bmInts[b])<0 && gbs.find(bmInts[b])>-1)
						gbsOut.append(bmInts[b]); 
			}//next p
			
			
			
//			PlaneProfile ppRing(cs);
//			ppRing.joinRing(rings[r],_kAdd);
//			PlaneProfile ppSub =ppRing;
//			ppSub.shrink(U(2));
//			ppRing.subtractProfile(ppSub);
//			
//			ppRing.vis(3);
			
//			for (int i=gbs.length()-1; i>=0 ; i--) 
//			{ 
//				if (beams.find(gbs[i])<0) // not a beam
//				{ 
//					gbs.removeAt(i);
//					continue;
//				}
//				
//				Body bd =gbs[i].envelopeBody(true, true);
//				PlaneProfile pp = bd.shadowProfile(pnZ);
//				pp.intersectWith(ppRing);
//				if (pp.area()<pow(dEps,2))
//					gbs.removeAt(i);
//				
//			}//next i
		}//next r
		ppContour.vis(4);
		
		gbs = gbsOut;
	}
	
// erase if no subset found
	if (gbs.length()<1)
	{ 
		reportMessage("\n"+ scriptName() + T("|No matching genbeam found to place text on.| ")$+T("|Tool will be deleted.|"));
		if(!bDebug)eraseInstance();
		return;
	}
	
//End Get entities to be marked//endregion 

//region Trigger
//Trigger CreateSingleMarkers
	String sTriggerCreateSingleMarker = T("|Create individual text markeres|");
	if (!bIsSingle)
		addRecalcTrigger(_kContextRoot, sTriggerCreateSingleMarker);
	int bCreateSingle;
	if (_bOnRecalc && _kExecuteKey==sTriggerCreateSingleMarker)
	{
		bCreateSingle = true;		
	}	
// Prerequisites to create single TSL
	TslInst tslNew;
	GenBeam gbsTsl[1];		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
	if (bHasElement)entsTsl.append(el);
	int nProps[]={};			
	double dProps[]={dTextHeight,dAngle};				
	String sProps[]={sFormat,sTextOrientation,sTextAlignment,sFilter};
	Map mapTsl; mapTsl.setInt("isSingle", true);	


//Trigger AddFreeLocation
	String sTriggerAddFreeLocation = T("|Add free location|");
	if (bIsSingle && _PtG.length()<1)
		addRecalcTrigger(_kContextRoot, sTriggerAddFreeLocation );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddFreeLocation)
	{
	// prompt for point input
		Point3d ptCen = gbs.first().ptCen();
		PrPoint ssP(TN("|Select free location|"),ptCen); 
		if (ssP.go()==_kOk) 
		{
			Vector3d vecL = gbs.first().solidLength() * .5 * gbs.first().vecX();
			PLine pl(ptCen - vecL,  ptCen+ vecL);	
			_PtG.append(pl.closestPointTo(ssP.value())); // append the selected points to the list of grippoints _PtG
		}					
		setExecutionLoops(2);
		return;
	}


//Trigger RemoveGripLocation
	String sTriggerRemoveGripLocation = T("|Remove free location|");
	if (bIsSingle && _PtG.length()>0)
		addRecalcTrigger(_kContextRoot, sTriggerRemoveGripLocation );
	if (_bOnRecalc && _kExecuteKey==sTriggerRemoveGripLocation)
	{
		_PtG.setLength(0);		
		setExecutionLoops(2);
		return;
	}	
		
//End Trigger//endregion 

//End Part #2
//endregion 

//region Part #3
//region AddText
	for (int i=0;i<gbs.length();i++) 
	{ 
		GenBeam gb = gbs[i];
		Beam bm = (Beam)gb;
		Sheet sheet= (Sheet)gb;
		Sip sip = (Sip)gb;
		
		Body bd = gb.envelopeBody(true, true);		//bd.vis(i);
		Point3d ptCen = gb.ptCen();
		
		Vector3d vecXB = gb.vecX();
		Vector3d vecYB = gb.vecY();
		Vector3d vecZB = gb.vecZ();		
		
	// override coordSys with element aligned coordSys	
		Quader qdr(ptCen, gb.vecX(), gb.vecY(), gb.vecZ(), gb.solidLength(), gb.solidWidth(), gb.solidHeight(), 0, 0, 0); 	
		if (bHasElement && !bOutside && !vecXB.isParallelTo(vecZ))
		{ 
			vecZB= qdr.vecD(vecZ);
		 	vecYB = vecXB.crossProduct(-vecZB);
		}

		Point3d ptTxt=ptCen;
		Vector3d vecDir, vecPerp= vecZB, vecNormal=vecYB;
		if (bOutside && bm.bIsValid())
		{ 
			vecPerp = vecZ;
			vecNormal = vecXB.crossProduct(-vecZ);
			if (ppContour.pointInProfile(ptTxt+vecNormal*(bm.dD(vecNormal)+dEps))==_kPointInProfile)
				vecNormal *= -1;
		}
		else
		{ 
			if (nTextOrientation == 1)	{vecPerp = vecZB;	vecNormal = -vecYB;}
			else if (nTextOrientation == 2)	{vecPerp = vecYB;	vecNormal = -vecZB;}
			else if (nTextOrientation == 3)	{vecPerp = vecZB;	vecNormal = -vecXB;}
			else if (nTextOrientation == 4)	{vecPerp = vecZB;	vecNormal = vecYB;}
			else if (nTextOrientation == 5)	{vecPerp = vecYB;	vecNormal = vecZB;}
			else if (nTextOrientation == 6)	{vecPerp = vecZB;	vecNormal = vecXB;}

		}
		vecDir = vecPerp.crossProduct(vecNormal);
		PlaneProfile slice = bd.getSlice(Plane(ptCen, vecPerp));
		Point3d pts[] = Line(ptCen, -vecNormal).orderPoints(slice.intersectPoints(Plane(ptCen, vecDir), true, false));		
		if (pts.length()>0)
			ptTxt = pts.first();
	
	// find cuts for beams
		if ((nTextOrientation == 3 ||nTextOrientation == 6) || bm.bIsValid())
		{ 
			AnalysedTool tools[] = bm.analysedTools(2);
			AnalysedCut cuts[] = AnalysedCut().filterToolsOfToolType(tools);
			for (int j=0;j<cuts.length();j++) 
			{ 
				AnalysedCut cut= cuts[j]; 
				Vector3d vecN = cut.normal();
				Plane pnC (cut.ptOrg(), vecN);
				if (abs(vecN.dotProduct(cut.ptOrg()-ptTxt))<dEps)
				{ 
					PLine pl;
					pl.createConvexHull(pnC,cut.bodyPointsInPlane());
					pl.vis(6);
					if (PlaneProfile(pl).pointInProfile(ptTxt)!=_kPointOutsideProfile)
					{ 
						vecNormal = vecN;
						vecDir = vecPerp.crossProduct(vecNormal);
						break;
					}
				}			 
			}//next j	
		}
		
	// contact face
		PlaneProfile ppContact(CoordSys(ptTxt, vecDir, vecPerp, vecNormal));
		ppContact.unionWith(bd.extractContactFaceInPlane(Plane(ptTxt, vecNormal), dEps));


	// horizontal placement
		ptTxt += vecDir * xPos * .5 *(qdr.dD(vecDir)-dTextHeight);
		
	// vertical placement
		ptTxt += vecPerp * yPos * .5 *(ppContact.dY()-dTextHeight);
			
	// free grip placement
		if (_PtG.length()>0)
		{
			_PtG[0]+=vecNormal*vecNormal.dotProduct(ptTxt-_PtG[0]);
			ptTxt += vecDir * vecDir.dotProduct(_PtG[0] - ptTxt) + vecPerp * vecPerp.dotProduct(_PtG[0] - ptTxt);
		}
		
	// create single
		if (bCreateSingle)
		{
			gbsTsl[0] = gb;
			ptsTsl[0]=ptTxt;	
			tslNew.dbCreate(scriptName() , vecDir ,vecPerp,gbsTsl, 
				entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			

			continue;
		}
	
		CoordSys csOrient(ptTxt, vecDir, vecPerp, -vecNormal);
		if (abs(dAngle)>0)
		{ 
			CoordSys rot;
			rot.setToRotation(dAngle, vecNormal, ptTxt);
			csOrient.transformBy(rot);	
			
			vecDir.transformBy(rot);	
			vecPerp.transformBy(rot);	
		}
	
		//vecDir.vis(ptTxt, 1);		vecPerp.vis(ptTxt, 3);		vecNormal.vis(ptTxt, 150);
	
	//region Get content and split multiline content for multiple tools
		String text = gb.formatObject(sFormat);
		if (text.length()<1){continue;}	
	
		String textX = text;
		String texts[0];
		int x = textX.find("\\P", 0, false);
		if (x>-1)
		{ 
			int max = textX.length();
			int cnt;
			while (x>-1 && cnt<max)
			{ 
				String left = textX.left(x);
				if (left.length()>0)
					texts.append(left);	
				textX = textX.right(textX.length() - x - 2);			
				x = textX.find("\\P", 0, false);
				cnt++;	
			}		
		}
		texts.append(textX);			
	//End split multiline content for multiple tools//endregion 

	// create a box as border
		double dXTxt = dp.textLengthForStyle(text, _DimStyles.first(), dTextHeight)+dTextHeight;
		double dYTxt = dp.textHeightForStyle(text, _DimStyles.first(), dTextHeight)+dTextHeight;
		PlaneProfile ppTxt;
		ppTxt.createRectangle(LineSeg(ptTxt - .5 * (vecDir * dXTxt + vecPerp * dYTxt),
			ptTxt + .5 * (vecDir * dXTxt + vecPerp * dYTxt)), vecDir, vecPerp);
		ppTxt.transformBy(-vecDir * xPos * .5*(ppTxt.dX()-dTextHeight));	
		//ppTxt.transformBy(-vecPerp * yPos * .5*dTextHeight);
		ppTxt.transformBy(-vecPerp * yPos *.5*(ppTxt.dY()-dTextHeight));
		//ppTxt.transformBy(-vecPerp * yPos * .5*dTextHeight*(texts.length()-.5));
		
		
		
		
		
		
		
		
ptTxt.vis(6);		
	// get contact border and potential error range	
		PlaneProfile ppErr = ppTxt;
		ppTxt.intersectWith(ppContact);
		ppErr.subtractProfile(ppTxt);
		
	// draw border	
		if (bHasElement)	dp.elemZone(el, gb.myZoneIndex(), 'T');
		dp.draw(ppTxt, _kDrawFilled, 80);
		dp.draw(ppTxt);
		
	// draw error range
		if (ppErr.area()>pow(dEps,2))
		{ 
			dpErr.draw(ppErr, _kDrawFilled, 50);
			dpErr.draw(ppErr);
		}
		
	// draw text (sheet does not have a marker display)	
		if(sheet.bIsValid() || bJig)	
		{
			if (bHasElement) dpText.elemZone(el, sheet.myZoneIndex(), 'I');
			dpText.draw(text, ptTxt, vecDir, vecPerp, -xPos, -yPos);
		}
		


	// add the tool
		if (!bJig)
		{ 
			if (texts.length()>1)
			{ 
				if (yPos!=0)csOrient.transformBy(vecPerp * (.5 * (texts.length())+.5) * dTextHeight);//
				else csOrient.transformBy(vecPerp * (.5 * (texts.length())) * dTextHeight);//
				
				csOrient.transformBy(-vecPerp *yPos *.5*(texts.length()+1) *dTextHeight);
			}
			for (int j=0;j<texts.length();j++) 
			{ 
				csOrient.ptOrg().vis(j);
				FreeText ft(texts[j], csOrient, dTextHeight, xPos, yPos);
				gb.addTool(ft);
				csOrient.transformBy(-vecPerp * dTextHeight*1.5);
			}//next j			
		}

		
		
	}//next i
		
//End AddText//endregion 


// erase parent
	if (bCreateSingle)
	{ 
		eraseInstance();
		return;
	}
//End Part #3
//endregion 

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
      <str nm="COMMENT" vl="HSB-10890 strategy to filter outside beams more tolerant " />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="3/15/2021 8:58:22 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End