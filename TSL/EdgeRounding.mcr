#Version 8
#BeginDescription
This tsl applies a rounding to the contour of a genbeam. It requires a special milling head on the machine and in export configuration

#Versions
Version 1.2 28.02.2023 HSB-16799 facetting of solid representation improved, CNC tool alignment fixed
Version 1.1 28.02.2023 HSB-16799 compatibel with hsbDesign 25
Version 1.0 23.02.2023 HSB-16799 initial beta version of genbeam edge rounding


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
//region <History>
// #Versions
// 1.2 28.02.2023 HSB-16799 facetting of solid representation improved, CNC tool alignment fixed  , Author Thorsten Huck
// 1.1 28.02.2023 HSB-16799 compatibel with hsbDesign 25, Author Thorsten Huck
// 1.0 23.02.2023 HSB-16799 initial beta version of genbeam edge rounding , Author Thorsten Huck

/// <insert Lang=en>
/// Select genbeams, when selecting a single genbeam one may select a partial path on the contour
/// </insert>

// <summary Lang=en>
// This tsl applies a rounding to the contour of a genbeam. It requires a special milling head on the machine and in export configuration
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "EdgeRounding")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Flip Side|") (_TM "|Select tool|"))) TSLCONTENT
//endregion

//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;

	String tDefault =T("|_Default|");
	String tLastInserted =T("|_LastInserted|");	
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
	int purple = rgb(147,39,143);
	int petrol = rgb(16,86,137);
	int green = rgb(19,155,72);	
	int lightgreen = rgb(0,255,0);	

	Vector3d vecXView = getViewDirection(0);
	Vector3d vecYView = getViewDirection(1);
	Vector3d vecZView = getViewDirection(2);
	double dViewHeight = getViewHeight();	

//endregion 	

	String kJigSelectPath = "SelectPathJig";
//end Constants//endregion

////region Functions #func
//	void drawPLine(PLine pl, double offset,  int color, int fillTransparent)
//	{ 
//		Display dp(color);
//		pl.transformBy(pl.coordSys().vecZ() * offset);
//		if (fillTransparent>0)
//			dp.draw(PlaneProfile(pl), _kDrawFilled, fillTransparent);
//		else
//			dp.draw(pl);
//	}
//	void drawPlaneProfile(PlaneProfile pp, double offset,  int color, int fillTransparent)
//	{ 
//		Display dp(color);
//		pp.transformBy(pp.coordSys().vecZ() * offset);
//		if (fillTransparent>0)
//			dp.draw(pp, _kDrawFilled, fillTransparent);
//		else
//			dp.draw(pp);
//	}	
////endregion 


//region JIG
	GenBeam gb;
	Point3d ptGrips[0];	
	int bJig, bShowPreview;
	if (_bOnJig && _kExecuteKey==kJigSelectPath)
	{ 
		Entity ent = _Map.getEntity("gb");
		
		if (_Map.hasMap("Properties"))
			_ThisInst.setPropValuesFromMap(_Map.getMap("Properties"));
		gb = (GenBeam)ent;
		if(!gb.bIsValid())
		{ 
			return;
		}

		bJig = true;
		bShowPreview = true;
	}
	else
	{
		ptGrips = _PtG;
	}
	
//endregion	






//region Properties

	String sFaceName=T("|Face|");	
	String tTop = T("|Top Face|"), tBottom = T("|Bottom Face|"), tBoth = T("|Both Faces|");
	String sFaces[] = { tBottom,tTop};//, tBoth
	PropString sFace(nStringIndex++, sFaces, sFaceName,1);	
	sFace.setDescription(T("|Defines the face of the tool|"));
	sFace.setCategory(category);
	int nFace = sFace == tBottom ?- 1:1;
	
	String sEdgeName=T("|Edge Offset|");	
	PropDouble dEdge(nDoubleIndex++, U(40), sEdgeName);	
	dEdge.setDescription(T("|Defines the Edge|"));
	dEdge.setCategory(category);
	if (dEdge<dEps)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|invalid value for edge offset.|"));
		eraseInstance();
		return;
		
	}
	
	String sOvershootName=T("|Overshoot|");	
	PropString sOvershoot(nStringIndex++, sNoYes, sOvershootName);	
	sOvershoot.setDescription(T("|Defines if the total length of the milling contour is extended by an overshoot|"));
	sOvershoot.setCategory(category);


	category = T("|Tool|");
	String sToolIndexName=T("|Tool Index|");	
	PropInt nToolIndex(nIntIndex++, 50, sToolIndexName);	
	nToolIndex.setDescription(T("|The tool index is used to identify a tool for CNC exports. It must match the corresponding tool definitions in the configuration of your CNC-Export.|"));
	nToolIndex.setCategory(category);

	String sRadiusName=T("|Radius|");	
	PropDouble dRadius(nDoubleIndex++, U(80), sRadiusName);	
	dRadius.setDescription(T("|Defines the convex shape radius of the special milling head|"));
	dRadius.setCategory(category);
	if (dRadius<dEps)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|invalid value for tool radius.|"));
		eraseInstance();
		return;
		
	}

	if (dEdge > dRadius)dEdge.set(dRadius);


	
	PLine arc(_ZW);
	Point3d ptArcA = _Pt0 + _XW * dRadius;		ptArcA.vis(1);
	Point3d ptArcB = _Pt0 + _YW * dRadius;		ptArcB.vis(1);
	double dAB = (ptArcB - ptArcA).length();
	arc.addVertex(ptArcA);
	arc.addVertex(ptArcB, tan(22.5));
	Vector3d vec45 = -_XW - _YW; vec45.normalize();
	Vector3d vecY45 = vec45.crossProduct(-_ZW); 
	Point3d pt1 = _Pt0-vec45*dRadius;

	Point3d pt3,pt2 = pt1-_XW*dEdge;
	
	Point3d pts[] = arc.intersectPoints(Line(pt2, vec45));
	if (pts.length()>0)
	{ 
		pt3 = pts.first();
	}

	arc.vis(4);
	pt2.vis(2);pt3.vis(3);pt1.vis(2);
	Point3d ptRef1 = pt1;
	
	
	double dDepth = vec45.dotProduct(pt2 - pt3);
	arc.transformBy(vec45*dDepth);
	//arc.vis(2);
	Point3d pt0 = pt1 + vec45  * vec45.dotProduct(ptArcA-pt1);	
	PLine(ptArcA,ptArcB).vis(2);
	pt0.vis(6);
	
	Point3d pt2A = pt1 - _YW * dEdge; pt2A.vis(8);
	double dT = dDepth + abs(vec45.dotProduct(pt1-ptArcA))+U(2);//U(302);
	
	PLine plSolid(_ZW);
	plSolid.addVertex(pt2A);
	plSolid.addVertex(pt2,pt0);
	plSolid.addVertex(pt2+_YW*U(1));
	plSolid.addVertex(pt1+_YW*U(1)+_XW*U(1));
	plSolid.addVertex(pt2A+_XW*U(1));
	plSolid.close();
	
	
//	PLine plSolid=arc;
//	plSolid.addVertex(plSolid.ptEnd() - vec45 * dT);
//	plSolid.addVertex(plSolid.ptEnd() + vecY45 * dAB);//, plSolid.ptEnd() + vecY45 * .5*dAB+vec45*dDepth);
//	plSolid.close();
	plSolid.vis(2);

	Vector3d vecBase = ptArcB - pt0;
	double dXBase = _XW.dotProduct(vecBase);//);
	double dYBase = _YW.dotProduct(vecBase);
	
	arc.transformBy(vecBase);
	arc.vis(3);

	
	PLine rec;
	rec.createRectangle(LineSeg(pt1, pt1 - _XW * U(300) -_YW * U(100)), _XW, _YW);
	rec.vis(40);
	
//End Properties//endregion 



//region OnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		if (_kExecuteKey.length()>0 && TslInst().getListOfCatalogNames(scriptName()).findNoCase(_kExecuteKey,-1)>-1)
			setPropValuesFromCatalog(_kExecuteKey);						
	// standard dialog	
		else	
			showDialog();
		
	// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select entities|"), GenBeam());
		if (ssE.go())
			ents.append(ssE.set());
		
	
	// GenBeams
		GenBeam gbs[0];
		for (int i=0;i<ents.length();i++) 
		{ 
			GenBeam gb = (GenBeam)ents[i];
			if (!gb.bIsDummy())
			{ 
				gbs.append(gb);
			}		 
		}//next i

		
		
		
		
	//region Allow apth selection if only one genbeam has been selected: Show Jig
		Point3d pts[0];
		if (gbs.length()==1)
		{ 
			String prompt = T("|Pick first point on contour|");
			int insertMode; // 0 = pick points, 1= contour
			PrPoint ssP("\n"+prompt+ T(" |[Contour/Face]|")); // second argument will set _PtBase in map
		    Map mapArgs;
		   	mapArgs.setInt("insertMode", insertMode);
		   	mapArgs.setInt("_Highlight", in3dGraphicsMode());
		   	mapArgs.setEntity("gb", gbs.first());
		    int nGoJig = -1;
		    while (nGoJig != _kNone && pts.length()<2)
		    {
		        nGoJig = ssP.goJig(kJigSelectPath, mapArgs); 
	     
		        if (nGoJig == _kOk)
		        {
		            Point3d ptPick = ssP.value(); //retrieve the selected point
		            pts.append(ptPick); //append the selected points to the list of grippoints _PtG
		            
		            
		            prompt = T("|Pick second point on contour|");
		        }
		        else if (nGoJig == _kKeyWord)
		        { 
		     
		            if (ssP.keywordIndex() == 0)
		            { 
		            	insertMode = insertMode == 0 ? 1 : 0;
		            	mapArgs.setInt("insertMode", insertMode);
		   
		            	if (insertMode==1)
		            		pts.setLength(0);
		            }		        	
		            else if (ssP.keywordIndex() == 1)
		            { 
		            	sFace.set(sFace == tBottom ? tTop : tBottom);
		            	Map mapProps = _ThisInst.mapWithPropValues();
		            	mapArgs.setMap("Properties", mapProps);
		            }
		            
		        }
		        else if (nGoJig == _kCancel)
		        { 
		            eraseInstance(); // do not insert this instance
		            return; 
		        }
		        mapArgs.setPoint3dArray("pts", pts);
		        ssP = PrPoint ("\n"+prompt+ " "+ (insertMode==0?T("|[Contour/Face]|"):T("|[Path/Face]|")));
		    }
		    
		    
//		    if (sFace==tBottom)
//		    	pts.swap(0, 1);
		}
			
	//End Show Jig//endregion 

		

	// Create single instances
	// create TSL
		TslInst tslNew;				Map mapTsl;
		int bForceModelSpace = true;	
		String sExecuteKey,sCatalogName = tLastInserted;
		String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
		Entity entsTsl[] = {};	
		
		for (int i=0;i<gbs.length();i++) 
		{ 
			Point3d ptsTsl[] = {gbs[i].ptCen()};
			ptsTsl.append(pts);
			GenBeam gbsTsl[] = {gbs[i]};
			tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent);  
		}//next i

		eraseInstance();
		return;
	}			
//endregion 



//region Validation

	

	
	if (!gb.bIsValid())
	{ 
		if (_GenBeam.length()<1)// || _PtG.length()<2)
		{ 
			String err = _GenBeam.length() < 1 ? T("|No genbeam found.|"):"";
			//err += _PtG.length() < 2 ? (err.length()>0?" ":"")+T("|Not enough grips found.|"):"";
			
			reportMessage("\n" + scriptName() + err);
			eraseInstance();
			return;
		}
		else
			gb = _GenBeam[0];		
	}


		
	Point3d ptCen = gb.ptCen();

// Curved
	int bIsCurved;
	Beam bm = (Beam)gb;
	PLine plContour, plTool, plBase, plTop, plMidCurve;
	CurvedStyle cstyle;
	if (bm.bIsValid())
	{ 
		cstyle=CurvedStyle(bm.curvedStyle());
		if (cstyle.entryName() != _kStraight)
		{
			bIsCurved = true;

		}
	}

	Vector3d vecX = gb.vecX();
	Vector3d vecY = gb.vecY();
	Vector3d vecZ = gb.vecZ();
	double dD = bIsCurved?gb.dW():gb.dH();
	Vector3d vecFace = nFace* (bIsCurved ? -vecY : vecZ);
	
	
	Point3d ptFace = ptCen + vecFace * .5 * dD;
	Vector3d vecYF = vecX.crossProduct(-vecFace);
	CoordSys cs(ptFace, vecX, vecYF, vecFace);
	Plane pnFace(ptFace, vecFace);
	vecFace.vis(ptFace, 150);
	Point3d ptMid = ptFace;
	

// Jig or Drag
	int bDrag = _bOnGripPointDrag && (_kExecuteKey == "_PtG0" || _kExecuteKey == "_PtG1");
	if(!bDrag)_ThisInst.setAllowGripAtPt0(false);
	else bShowPreview = true;

	if (bJig)
	{ 
		Point3d ptJig = _Map.getPoint3d("_PtJig");
		Point3d pts[] = _Map.getPoint3dArray("pts");
		
		
		if(Line(ptJig, vecFace).hasIntersection(pnFace, ptJig) && pts.length()==1)
		{ 
			ptGrips.append(pts.first());
			ptGrips.append(ptJig);
			
		}
	}
//endregion 

//region Overshoot
	int bOvershoot = sOvershoot == sNoYes[1];
	double dOvershoot = -2.9*log(dEdge-U(27.5))+U(52);	
	
	setEraseAndCopyWithBeams(_kBeam0);
	assignToGroups(gb, 'T');
	if (_kNameLastChangedProp==sFaceName)
	{ 
		_PtG.swap(0, 1);
		setExecutionLoops(2);
		return;
	}

// TriggerFlipSide
	String sTriggerFlipSide = T("|Flip Side|");
	addRecalcTrigger(_kContextRoot, sTriggerFlipSide );
	if (_bOnRecalc && (_kExecuteKey==sTriggerFlipSide || _kExecuteKey==sDoubleClick))
	{
		sFace.set(sFace == tBottom ? tTop : tBottom);
		_PtG.swap(0, 1);
		setExecutionLoops(2);
		return;
	}


//region Trigger FullContour
	String sTriggerFullContour = T("|Full Contour|");
	if (_PtG.length()>1)
		addRecalcTrigger(_kContextRoot, sTriggerFullContour );
	if (_bOnRecalc && _kExecuteKey==sTriggerFullContour)
	{
		_PtG.setLength(0);		
		setExecutionLoops(2);
		return;
	}//endregion	

	



//endregion 




//region Get Shape
	PlaneProfile ppShape(cs);
//	if (bIsCurved) // Causing trouble when on bottom face
//	{ 
//
//		plContour = cstyle.closedCurve();
//		
//		plContour.vis(2);
//		
//		
////		plBase = cstyle.baseCurve();
////		plTop = cstyle.topCurve();
////		plMidCurve= cstyle.midCurve();
//		
//		plContour.transformBy(CoordSys(ptFace, vecX, nFace*vecYF, nFace*vecFace));//
////		plBase.transformBy(cs);
////		plTop.transformBy(cs);
////		plMidCurve.transformBy(cs);
//		
//		ppShape.joinRing(plContour, _kAdd);
//		
//		//ptMid = plMidCurve.ptMid();
//		
//		//plContour.coordSys().vecZ().vis(ptMid, 1);
//	}
//	else
	{ 
		Body bd = gb.envelopeBody(false, true);
		
		ppShape = bd.extractContactFaceInPlane(pnFace, dEps);
		PLine rings[] = ppShape.allRings(true, false);
		if (rings.length()>0)
			plContour = rings.first();
		plContour.reconstructArcs(dEps,70);	
	}

	if (!plContour.coordSys().vecZ().isCodirectionalTo(vecFace))
	{ 
		plContour.flipNormal();
	}

	//drawPLine(plContour, 0, 6, 60); // #func
//endregion 


//region Get subtracing contour ring body
	Body bdRing;
//	{ 
//		PLine plX = plContour;
//		plX.offset(-U(10e3));
//		bdRing=Body(plX, vecFace * dD, -1);
//		plX = plContour;
//		plX.convertToLineApprox(dEps);
//		bdRing.subPart(Body(plX, vecFace * dD, -1));	
//		
//		//bdRing.vis(150);
//	}
		
//endregion 


//region Collect sgement plines and arcs
	Point3d ptsC[] = plContour.vertexPoints(false);
	PLine plines[0]; int bArcs[0];
	double dLengthContour = plContour.length();
	for (int i=0;i<ptsC.length()-1;i++) 
	{ 
		Point3d pt1 = ptsC[i];
		Point3d pt2 = ptsC[i+1];
		Point3d ptm = (pt1 + pt2) * .5;
		
		PLine pl(vecFace);
		int bIsArc;
		pl.addVertex(pt1);
		if (plContour.isOn(ptm))
			pl.addVertex(pt2);
		else
		{ 
			double d = plContour.getDistAtPoint(pt1);
			if (abs(d - dLengthContour) < dEps)d = 0;
			
			pl.addVertex(pt2, plContour.getPointAtDist(d+dEps));		
			bIsArc = true;
		}
		//pl.vis(i);
		plines.append(pl);
		bArcs.append(bIsArc);
	}//next i
	
	plTool = plContour;
	plTool.ptStart().vis(2);
	double dL = plTool.length();
//endregion 

//region Indicate direction on insert
	if (bJig)// || bDebug)
	{ 
		Display dp(-1);
		dp.trueColor(red);
		
		//double scale = 
		double d1 = dViewHeight /20;//U(50)*scale;
		int num = dL / (d1*6);
		if (num<1)
			num = 1;
		double di = dL / num;
		for (int i=0;i<num;i++) 
		{ 
			Point3d pt1 = plTool.getPointAtDist(i * di);
			Point3d pt2 = plTool.getPointAtDist(i * di + d1); 
			
			Vector3d vecXI = pt2 - pt1; vecXI.normalize();
			if (vecXI.isParallelTo(vecZView)){break;}
			Vector3d vecYI = vecXI.crossProduct(vecZView);
			
			PLine pl(vecZView);
			pl.addVertex(pt2);
			pl.addVertex(pt2-.5*d1*(vecXI+.75*vecYI));
			pl.addVertex(pt2-.375*d1*vecXI-vecYI*.125*d1);
			pl.addVertex(pt2 - vecXI * d1 - vecYI * .125 * d1);
			pl.addVertex(pt2 - vecXI * d1 + vecYI * .125 * d1);
			pl.addVertex(pt2-.375*d1*vecXI+vecYI*.125*d1);
			pl.addVertex(pt2-.5*d1*(vecXI-.75*vecYI));
			pl.close();
			pl.vis(4);
			
			dp.draw(PlaneProfile(pl), _kDrawFilled, 50);
			dp.draw(PlaneProfile(pl));
		}//next i
		
		
	}	
//endregion 




//region Manipulate tooling pline from start to end grip
// reset to contour mode by removing grips
	if (_PtG.length()>1 && (_PtG[0]-_PtG[1]).length()<dEps)
	{ 
		_PtG.setLength(0);
	}

// Manipulate Tool Path
	PLine plOvershoots[0];
	if (ptGrips.length()>1)	
	{ 
		for (int i=0;i<_PtG.length();i++) 
		{ 
			if (!bDrag)_PtG[i] = plContour.closestPointTo(_PtG[i]);
			addRecalcTrigger(_kGripPointDrag, "_PtG"+i);
			//vecFace.vis(_PtG[i],150); 
		}//next 		
		
		
		Point3d ptA = plContour.closestPointTo(ptGrips[0]);
		Point3d ptB =plContour.closestPointTo(ptGrips[1]);	
		
		double distA = plContour.getDistAtPoint(ptA);
		double distB = plContour.getDistAtPoint(ptB);	
	
		// closing definition, offset grip B slightly
		if ((ptA-ptB).length()<dEps)
		{ 
			if (distB<dL-dEps)
				distB += dEps;
			else
				distB = dEps;
			ptB = plContour.getPointAtDist(distB);
		}
	
	
		double trimA = distA<dL?distA:0;
		if (distB>distA)
		{ 
			double trimB = dL-distB;			
			plTool.trim(trimA, false);
			plTool.trim(trimB, true);			
		}
		else
		{ 
			PLine pl1 = plTool;
			pl1.trim(trimA, false);
			PLine pl2 = plTool;
			pl2.trim(dL-distB, true);
			pl2.vis(6);
			pl1.append(pl2);
			plTool = pl1;
		}
		
	// extent plTool by overshoot
		if (bOvershoot && plTool.length()>2*dOvershoot)
		{ 
			ptA = plTool.ptStart();
			ptB = plTool.ptEnd();
			
		// Get new point at start	
			double dA2 = plContour.getDistAtPoint(ptA);
			if (dA2>dOvershoot)
				dA2 -= dOvershoot;
			else
				dA2 = dLengthContour - dA2;		
			Point3d ptA2 = plContour.getPointAtDist(dA2);
			
		//Get new point at end
			double dB2 = plContour.getDistAtPoint(ptB);
			if (dB2<dLengthContour-dOvershoot)
				dB2 += dOvershoot;
			else
				dB2 = dLengthContour - dB2;		
			Point3d ptB2 = plContour.getPointAtDist(dB2);
	
			
		// find segment pline of start
			int bIsModifiedA, bIsModifiedB;
			for (int i=0;i<plines.length();i++) 
			{ 
				PLine& pl = plines[i];	
				int bIsArc = bArcs[i];
				
				Point3d pt1 = pl.ptStart();
				Point3d pt2 = pl.ptEnd();
				Point3d ptmx = pl.ptMid();
				Point3d ptm = (pt1 + pt2) * .5;
				
				
			// calculate radius from circular segment
				PLine circle;
				if (bIsArc)
				{ 
					Vector3d vecCen = ptm - ptmx;
					double h = (ptm - ptmx).length();
					if (h < dEps)continue;
					double s = (pt2 - pt1).length();
					double r = (4 * pow(h,2) + pow(s, 2)) / (8 * h);

					vecCen.normalize();
					Point3d ptCen = ptmx + vecCen* r;
					circle.createCircle(ptCen, vecFace, r);				
				}
	
				
			// extend on start	
				if (pl.isOn(ptA) && (pt2-ptA).length()>dEps && !bIsModifiedA) // point must be on pline but not on last vertex and not modified yet
				{
					Vector3d vecXE = pl.getTangentAtPoint(ptA);
					
				// the extended location is on the same segment	
					if (pl.isOn(ptA2))
					{ 
						ptA2.vis(1);
					}
				// the extended location would be on another arc segment
//					else if (bIsArc)	//TODO the circle appears to have a slight tolerances which causes tiny slices not to be soliudsubtracted
//					{ 	
//						pl.vis(6);
//						circle.vis(4);
//						double d1 = circle.getDistAtPoint(ptA);
//						d1 += d1 > dOvershoot ? dOvershoot : circle.length() - d1;
//						
//						ptA2 = circle.getPointAtDist(d1);				
//						ptA2.vis(2);pt2.vis(2);
//	
//					}
					else if (bIsArc)
					{ 
						Point3d ptOnArc = pl.getPointAtDist(dEps);
						vecXE = pl.getTangentAtPoint(ptOnArc);
						ptA2 = ptA - vecXE * dOvershoot;	vecXE.vis(ptA2,2);
					}
					else
					{	
						ptA2 = ptA - vecXE * dOvershoot;
						vecXE.vis(ptA2,3);
					}
					
				//region Add fade out
					{ 
						Vector3d vecZE = vecFace;
						Vector3d vecYE = vecXE.crossProduct(-vecZE);

						CoordSys cs2;
						cs2.setToAlignCoordSys(ptRef1, _XW, _YW, _ZW, ptA, -vecYE, vecZE, -vecXE);
						//vecXE.vis(ptA, 1);	vecYE.vis(ptA, 3);	vecZE.vis(ptA, 150);						
						CoordSys rot; rot.setToRotation(45, vecXE, ptA);
						vecZE.transformBy(rot);
						vecYE = vecXE.crossProduct(-vecZE);
						Point3d ptE = ptA2 + vecZE * dOvershoot;

	
						PLine plPath(vecYE);
						plPath.addVertex(ptA);
						plPath.addVertex(ptE, tan(22.5));
						plPath.vis(3);
	
						PLine plShape = plSolid;
						
						plShape.transformBy(cs2);
						plShape.vis(3);
						Body bdT(plShape, plPath, 32 );
						//bdT.vis(i);
	
						SolidSubtract sosu(bdT, _kSubtract);
						gb.addTool(sosu);
						
						rot.setToRotation(-90, vecYE, ptA+vecZE*dOvershoot);
						bdT.transformBy(rot);
						//bdT.vis(6);
						sosu=SolidSubtract(bdT, _kSubtract);
						gb.addTool(sosu);						
					}
						
				//endregion 	

					PLine plNew(vecFace);
					plNew.addVertex(ptA2);
					plNew.addVertex(ptA);					
					plNew.append(plTool);
					plTool = plNew;
					bIsModifiedA = true;
					
	
				}
			
			// extend on end	
				if (pl.isOn(ptB) && !bIsModifiedB)
				{ 
					Vector3d vecXE = pl.getTangentAtPoint(ptB);
					
				// the extended location is on the same segment	
					if (pl.isOn(ptB2))
					{ 
						ptB2.vis(93);
					}
//					else if (bIsArc)	//TODO the circle appears to have a slight tolerances which causes tiny slices not to be soliudsubtracted
//					{ 	
//						//circle.vis(32);
//						double d1 = circle.getDistAtPoint(ptB);
//						d1 -= d1 > dOvershoot ? dOvershoot : circle.length() - d1;				
//						ptB2 = circle.getPointAtDist(d1);	ptB2.vis(2);							
//					}
					else if (bIsArc)
					{ 
						Point3d ptOnArc = pl.getPointAtDist(pl.length()-dEps);
						vecXE = pl.getTangentAtPoint(ptOnArc);
						ptB2 = ptB + vecXE * dOvershoot;	vecXE.vis(ptB2,2);
					}					
					else
					{ 
						vecXE = pl.getTangentAtPoint(ptB);
						ptB2 = ptB + vecXE * dOvershoot;
					}
					
				//region Add fade out
					{ 
						Vector3d vecZE = vecFace;
						Vector3d vecYE = vecXE.crossProduct(-vecZE);

						CoordSys cs2;
						cs2.setToAlignCoordSys(ptRef1, _XW, _YW, _ZW, ptB, -vecYE, vecZE, -vecXE);
						vecXE.vis(ptB, 1);	vecYE.vis(ptB, 3);	vecZE.vis(ptB, 150);						
						CoordSys rot; rot.setToRotation(45, vecXE, ptB);
						vecZE.transformBy(rot);
						vecYE = vecXE.crossProduct(-vecZE);
						Point3d ptE = ptB2 + vecZE * dOvershoot;

	
						PLine plPath(vecYE);
						plPath.addVertex(ptB);
						plPath.addVertex(ptE, tan(-22.5));
						plPath.vis(3);
	
						PLine plShape = plSolid;
						
						plShape.transformBy(cs2);
						plShape.vis(3);
						Body bdT(plShape, plPath, 32 );
						//bdT.vis(i);
	
						SolidSubtract sosu(bdT, _kSubtract);
						gb.addTool(sosu);
						
						rot.setToRotation(90, vecYE, ptB+vecZE*dOvershoot);
						bdT.transformBy(rot);
						//bdT.vis(6);
						sosu=SolidSubtract(bdT, _kSubtract);
						gb.addTool(sosu);						
					}
						
				//endregion 	
	
					
					
					
					
					plTool.addVertex(ptB2);
					bIsModifiedB=true;	
				}
			
			}//next i
			
			
			plTool.simplify();
			
		}

		
		
		
		
		
	}

	else
	{ 
		sOvershoot.set(sNoYes[0]);
		sOvershoot.setReadOnly(true);
	}

//endregion 



//region Tooling
	Body bdTool;
	if (plTool.length()>3*dOvershoot)
	{ 
//		if (bDrag)
//		{ 
//			Display dp(2);
//			dp.draw(plTool);
//		}
		
		plTool.vis(3);
		Point3d ptStart = plTool.ptStart();
		Vector3d vecYP = vecFace;
		Vector3d vecZP = -plTool.getTangentAtPoint(ptStart);
		vecZP.vis(ptStart, 6);
		Vector3d vecXP = vecZP.crossProduct(-vecYP);
		
		PLine pl1 = plTool;
		pl1.offset(dEdge);
		pl1.vis(1);
		
		PLine pl2 = plTool;
		pl2.transformBy(-vecFace * dEdge); //XX nFace*
		pl2.vis(1);
		
		CoordSys cs2;
		cs2.setToAlignCoordSys(pt1, _XW, _YW, _ZW, ptStart, vecXP, vecFace, vecZP);
		
		plSolid.transformBy(cs2);
		plSolid.ptStart().vis(4);
		vecBase.transformBy(cs2);
		plSolid.vis(1);
		if (plSolid.area()>pow(dEps,2))
		{ 
			PLine plPath = plTool;	
			
			if (bOvershoot && ptGrips.length()>1)
			{ 
				plPath.trim(dOvershoot, false);
				plPath.trim(dOvershoot, true);				
			}

			
		// resolve into segments
			Point3d ptsT[] = plPath.vertexPoints(true);
			for (int i=0;i<ptsT.length()-1;i++) 
			{ 
				Point3d pt1 = ptsT[i];		pt1.vis(i);
				Point3d pt2 = ptsT[i+1];	pt2.vis(i);
				Point3d ptm = (pt1 + pt2) * .5;

				PLine pl(vecFace);
				pl.addVertex(pt1);
				if (plTool.isOn(ptm))
					pl.addVertex(pt2);
				else
				{ 
					double d = plPath.getDistAtPoint(pt1);
					if (abs(d - plPath.length()) < dEps)d = 0;
					
					pl.addVertex(pt2, plPath.getPointAtDist(d+dEps));	
					pl.convertToLineApprox(.01*dEps);
				}

				Vector3d vecZT= -pl.getTangentAtPoint(pt1);
				Vector3d vecXT = vecZT.crossProduct(-vecFace);
				Vector3d vecYT = vecXT.crossProduct(-vecZT);
				
				CoordSys csp = plSolid.coordSys();
				CoordSys csT;csT.setToAlignCoordSys(ptStart, vecXP, vecYP,vecZP, pt1, vecXT, vecYT, vecZT);
				plSolid.transformBy(csT);	
				plSolid.vis(2);

				Body bdT(plSolid, pl, 32 );
				bdT.vis(i);
				SolidSubtract sosu(bdT, _kSubtract);
				gb.addTool(sosu);
				
//				bdT.addTool(Cut(ptFace, vecFace));
//				bdT.addTool(SolidSubtract(bdRing), _kSubtract);
//				bdTool.combine(bdT);				
				//bdT.vis(i);
//
				ptStart.transformBy(csT);
				vecXP.transformBy(csT);
				vecYP.transformBy(csT);
				vecZP.transformBy(csT);
				
				//bArcs.append(bIsArc);
			}//next i			
			
			if (!bDrag && !bJig)
			{ 
				//pl1.transformBy(vecBase);
				pl1.offset(-dXBase, false);
				pl1.transformBy(vecFace*dYBase);
				pl1.vis(161);
				//pl2.transformBy(vecBase);
				pl2.offset(dXBase, false);
				pl2.transformBy(-dYBase*vecFace);
				pl2.vis(150);
				PropellerSurfaceTool tt(pl1, pl2, dRadius*2, dEps);
				tt.setMillSide(_kRight);
				tt.setCncMode(nToolIndex);
//				if (bDebug)
//					tt.cuttingBody().vis(4);	
//				else
					tt.setDoSolid(false);
				gb.addTool(tt);					
			}
		
		}
		
		

	}
//endregion 

//region Display 
	Display dpTool(-1), dpJig(40);
	dpTool.trueColor(bShowPreview?lightgreen:grey,bShowPreview?0:40);
	dpJig.trueColor(grey,0);

	if (bJig || bDrag)
	{ 
		dpJig.trueColor(darkyellow,0);
		dpJig.draw(plContour);
		
// shadow gets flickery on complex shapes		
//		Point3d pts[] = bdTool.extremeVertices(vecZView);
//		Point3d pt = pts.length() > 0 ? pts.last() : _Pt0;
//		PlaneProfile pp = bdTool.shadowProfile(Plane(pt, vecZView));
//		dpJig.draw(pp, _kDrawFilled);
//		dpTool.draw(plTool);
	}
	//else
	{ 
		PLine pl = plTool;
		
		pl.transformBy(-vecFace * dEdge);//XX nFace*
		dpTool.draw(pl);
		plTool.offset(dEdge);
		dpTool.draw(plTool);
	}
	
// erase invalids
	if (plTool.length()<dOvershoot && !bShowPreview)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|invalid tooling contour.|"));
		eraseInstance();
		return;
		
	}



//endregion 





#End
#BeginThumbnail
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
%1*Y"8((`

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
        <int nm="BreakPoint" vl="539" />
        <int nm="BreakPoint" vl="888" />
        <int nm="BreakPoint" vl="539" />
        <int nm="BreakPoint" vl="887" />
        <int nm="BreakPoint" vl="718" />
        <int nm="BreakPoint" vl="188" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16799 facetting of solid representation improved, CNC tool alignment fixed " />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="2/28/2023 10:11:52 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16799 facetting of solid representation improved, CNC tool alignment fixed" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="2/28/2023 8:53:08 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16799 initial beta version of genbeam edge rounding" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="2/23/2023 11:24:35 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End