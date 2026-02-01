#Version 8
#BeginDescription
#Versions
Version 1.1    10.05.2021
HSB-11691 Face detection and performance improved. jig dimension added , Author Thorsten Huck

Version 1.0 27.04.2021 HSB-11691 inital version of a panel edge tool , Author Thorsten Huck

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords CLT;BSP;Edge;Kante;Tool
#BeginContents
//region <History>
// #Versions
// 1.1 10.05.2021 HSB-11691 Face detection and performance improved. jig dimension added , Author Thorsten Huck
// 1.0 27.04.2021 HSB-11691 inital version of a panel edge tool , Author Thorsten Huck

/// <insert Lang=en>
/// Select panel and pline (freeprofile) or circles (drill pattern)
/// </insert>

// <summary Lang=en>
// This tsl creates an edge tool of the selected type
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCLT-EdgeTool")) TSLCONTENT
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
	
// distinguish if current background is light or dark	
	int bIsDark;{int n = getBackgroundTrueColor();bIsDark = ((rgbR(n) + rgbB(n) + rgbG(n)) / 3 < 127);}
	
	int lightblue = rgb(204,204,255);
	int darkblue = rgb(26,50,137);	

	int green = rgb(88,186,72);//19, 155, 72  
	int red = rgb(205,32,39);
	int blue = rgb(39,118,187);
	int orange = rgb(255,63,0);//205,105,40
	int darkyellow = rgb(254, 204, 102);	
	Vector3d vecXView = getViewDirection(0);	
	Vector3d vecYView = getViewDirection(1);	
	Vector3d vecZView = getViewDirection(2);	
	String sDimStyle = _DimStyles.first();
	double dViewHeight = getViewHeight();
	
//end Constants//endregion


//region bOnJig
	String sJigAction = "Jig";
	if (_bOnJig && _kExecuteKey==sJigAction) 
	{
	//_ThisInst.setDebug(TRUE);
		//Point3d ptBase = _Map.getPoint3d("_PtBase"); // set by second argument in PrPoint
		Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point
		
		Entity ent = _Map.getEntity("Sip");
		Entity ents[] = _Map.getEntityArray("Entity[]", "", "Entity");
		Sip sip = (Sip)ent;
		Vector3d vecX = sip.vecX();
		Vector3d vecY = sip.vecY();
		Vector3d vecZ = sip.vecZ();
		Point3d ptCen = sip.ptCenSolid();
		double dZ = sip.dH();		
		Plane pnRef(ptCen - vecZ * .5 * dZ ,- vecZ);
		Body bd = sip.envelopeBody(false, true);

		int nTool = _Map.getInt("tool");
		double dLength = _Map.getDouble("length");


	// get planes
		Plane planes[0];
		Map mapPlanes = _Map.getMap("Plane[]");
		for (int i=0;i<mapPlanes.length();i++) 
		{ 
			Map m =mapPlanes.getMap(i);
			Plane pn(m.getPoint3d("ptOrg"), m.getVector3d("normal"));
			planes.append(pn);
			 
		}//next i


	// get circle or freeprofile plines
		PLine plines[0];
		PlaneProfile ppW(CoordSys(_PtW, _XW, _YW, _ZW));
		for (int i=0;i<ents.length();i++) 
		{ 
			//if (ents[i].typeDxfName() != "CIRCLE")continue;
			PLine pl = ents[i].getPLine();
			pl.projectPointsToPlane(Plane(_PtW, _ZW), _ZW);
			if (pl.area()>pow(dEps,2))
			{
				plines.append(pl);
				ppW.joinRing(pl, _kAdd);
			}		 
		}//next i


		Display dp(1);
		dp.trueColor(bIsDark?darkblue:lightblue);
		dp.addViewDirection(vecZView);
		dp.textHeight(U(50));

	//region Model preview	
		Plane pnThis;
		Point3d ptX = ptJig;
		if (!vecZView.isParallelTo(vecZ))
		{ 
		// collect edge contact profiles
			PlaneProfile ppsIn[0], ppsOut[0];
			double dCenDists[0];
			for (int i=0;i<planes.length();i++) 
			{ 
				Plane pn=planes[i];//(e.ptMid(), vecNormal);
				PlaneProfile pp = bd.extractContactFaceInPlane(pn, dEps);
	
				Point3d pt;
				if (Line(ptJig, vecZView).hasIntersection(pn, pt))
				{ 
				// collect jig planeprofiles with the distance to the profile	
					if (pp.pointInProfile(pt)!=_kPointOutsideProfile)
					{
						ppsIn.append(pp);
						dCenDists.append(Vector3d(pt - pp.ptMid()).length());
					}
					else
						ppsOut.append(pp);	
				}
			}//next i
			
		// order descending bySize
			for (int i=0;i<ppsIn.length();i++) 
				for (int j=0;j<ppsIn.length()-1;j++) 
					if (dCenDists[j]<dCenDists[j+1])
						ppsIn.swap(j, j + 1);
						
		// the projection of ptJig could be inside multiple				
			for (int i=0;i<ppsIn.length();i++) 
			{ 
				if (i==0)
				{
					dp.trueColor(darkyellow);
					
					CoordSys csThis = ppsIn[i].coordSys();
					pnThis = Plane(csThis.ptOrg(), csThis.vecZ());
				}
				else // draw as not selected
					dp.trueColor(bIsDark?darkblue:lightblue); 
				dp.draw(ppsIn[i], _kDrawFilled, 50); 	
				
				if (i==0)
				{ 
					dp.color(1);
					dp.draw(ppsIn[i]); dp.draw(ppsIn[i]); 
					
				// get axis line
					if (ppW.area()>pow(dEps,2))
					{ 
						CoordSys cs = ppsIn[i].coordSys();
						Plane pn(cs.ptOrg(), cs.vecZ());
						Point3d pt;
						if (Line(ptJig, vecZView).hasIntersection(pn, pt))	
						{ 
							if (Line(pt, cs.vecY()).hasIntersection(Plane(ptCen, vecZ), pt))
							{ 
								CoordSys csAlign;
								csAlign.setToAlignCoordSys(ppW.ptMid(), _XW, _YW, _ZW, pt, cs.vecX(), cs.vecY(), cs.vecZ());
								for (int x=0;x<plines.length();x++) 
								{ 
									plines[x].transformBy(csAlign);
									dp.draw(plines[x]);
									dp.draw(PlaneProfile(plines[x]),_kDrawFilled);
									dp.draw(PlaneProfile(plines[x]),_kDrawFilled);

								}//next x
							}
						}							
					}

					
					
					
				}
				
			}//next i
			
			dp.trueColor(bIsDark?darkblue:lightblue); 
			for (int i=0;i<ppsOut.length();i++) 
				dp.draw(ppsOut[i], _kDrawFilled, 50); 			
		}
	//End model preview//endregion 
	
	//region Panel vecZ preview
		else
		{ 
			//dp.trueColor(darkyellow);
			PlaneProfile ppShadow = bd.shadowProfile(pnRef);
			Point3d pt;	
			
			if (Line(ptJig, vecZView).hasIntersection(pnRef, pt))
			{ 
				double dDist = U(10e6);

				PLine plEdge(vecZ);
				for (int i = 0; i < planes.length(); i++)
				{ 
					Plane pn=planes[i];//(e.ptMid(), vecNormal);
					PlaneProfile pp = bd.extractContactFaceInPlane(pn, dEps);

					Point3d pts[] = pp.intersectPoints(pnRef, true, false);
					if (pts.length()<1)
					{ 
						Line ln = pn.intersect(pnRef);	
						pts = ln.orderPoints(ln.projectPoints(pp.getGripVertexPoints()),dEps);
							
					}
					if (pts.length() < 1)continue;
					
					PLine pl(vecZ);
					pl.addVertex(pts.first());
					pl.addVertex(pts.last());
					double d = Vector3d(pt - pl.ptMid()).length();
					if (d<dDist)
					{ 
						dDist = d;
						plEdge = pl;
						pnThis = pn;
					}					
					
					
					dp.draw(pp, _kDrawFilled);
					
				}
				
//				if (plEdge.length()>0)
//				{ 
//					Vector3d vecPerp = plEdge.ptEnd() - plEdge.ptStart();
//					vecPerp.normalize();
//					
//					ptX = plEdge.closestPointTo(pt);
//					
//					Vector3d vecDir = ptX - pt;
//					double d1 = vecDir.length();
//					double d2 = getViewHeight() / 100;
//					
//					vecDir.normalize();
//					Point3d pt2 =pt+ (vecPerp+vecDir) * d2;
//					
//					dp.color(1);
//					dp.draw(plEdge);
//					dp.draw(PLine(pt, pt2,plEdge.closestPointTo(pt2)));
//				}
					
				
			}
			
		}
	//End Panel vecZ preview//endregion 


	//region Selected Edge
		PlaneProfile pp = bd.extractContactFaceInPlane(pnThis, dEps);
		Line ln = pnRef.intersect(pnThis);
		Point3d ptXExtremes[] = ln.orderPoints(pp.intersectPoints(pnRef, true, false),dEps);
		if (ptXExtremes.length()<1)
			ptXExtremes=ln.orderPoints(ln.projectPoints(pp.getGripVertexPoints()),dEps);
		
		if (ptXExtremes.length()>0 && !ln.vecX().isParallelTo(vecZView))
		{ 
			Vector3d vecDir = ln.vecX();
			double dTextHeight = dViewHeight / 150;
			
			Vector3d vecPerp = vecDir.crossProduct(-vecZ);	
			int nSide = vecPerp.dotProduct(pnThis.normal()) < 0 ?- 1 : 1;

		// declare dimline	
			DimLine dl(ptXExtremes.first()+nSide*vecPerp*U(100), ln.vecX(), vecPerp);
			Dim dim;
			{
				Point3d pts[0];
				dim = Dim(dl,  pts, "",  "", _kDimPar, _kDimPerp); 
			}		
		
		// Extremes
			Vector3d vecOrder = vecDir;
			if (vecOrder.isParallelTo(vecYView))vecOrder=vecYView;
			else if (vecDir.dotProduct(vecXView)<0)vecOrder*=-1;
			ptXExtremes = Line(ptX, vecOrder).orderPoints(ptXExtremes);
			
		// Drill / center
			ptXExtremes.append(ptX);
			
			if (nTool!=0 && nTool!=6 && nTool!=7 && dLength>0)
			{ 
				ptXExtremes.append(ptX-vecDir*.5*dLength);
				ptXExtremes.append(ptX+vecDir*.5*dLength);
				
			}
			
		// Freeprofile
//			else if (nTool==0 && plines.length()>0)
//			{ 
//				Point3d pts[] = plines.first().vertexPoints(true);
//				if (pts.length()>1)
//				{ 
//					ptXExtremes.append(pts.first());
//					ptXExtremes.append(pts.last());
//					
//				}	
//			}	
			for (int i=0;i<ptXExtremes.length();i++) 
			{ 
				Point3d& pt = ptXExtremes[i];
				dim.append(pt,"<>",(i==0?" ":"<>")); 
			}//next i

			dim.setDeltaOnTop(false);
			dim.setReadDirection(vecYView - vecXView);
			dp.draw(dim);			
		}
		
	//End Selected Edge//endregion 



	//region draw solids
		double depth = _Map.getDouble("depth");
		if (depth>dEps)
			for (int i=0;i<plines.length();i++) 
			{ 
				if (plines[i].area() < pow(dEps, 2))continue;
				Vector3d normal = plines[i].coordSys().vecZ();
				Body bd(plines[i], normal*depth, (normal.dotProduct(pnThis.normal())<0?1:-1));
				dp.draw(bd);
				 
			}//next i
			
	//End draw solids//endregion 




	    return;
	}		
//End bOnJig//endregion 

//region Properties
category = T("|Tool|");
	String sTools[] = { T("|Free Profile|"), T("|Beamcut|"), T("|Rabbet|"), T("|Mortise|"), T("|Slot|"), T("|Housing|"), T("|Drill|"), T("|Drill Pattern|")};
	String sToolsSorted[0];sToolsSorted = sTools.sorted(); 
	String sToolName=T("|Tool|");	
	PropString sTool(nStringIndex++, sToolsSorted, sToolName);	
	sTool.setDescription(T("|Defines the Tool|"));
	sTool.setCategory(category);
	int nTool = sTools.find(sTool);	
	
	String sRadiusName=T("|Radius|");	
	PropDouble dRadius(nDoubleIndex++, U(0), sRadiusName);	
	dRadius.setDescription(T("|Defines the radius of a freeprofile, a mortise or a drill|"));
	dRadius.setCategory(category);

category = T("|Geometry|");
	String sLengthName= T("|Length|");	
	PropDouble dLength(nDoubleIndex++, U(0), sLengthName);	
	dLength.setDescription(T("|Defines the Length|"));
	dLength.setCategory(category);
	
	String sWidthName=T("|Width|");	
	PropDouble dWidth(nDoubleIndex++, U(0), sWidthName);	
	dWidth.setDescription(T("|Defines the Width|"));
	dWidth.setCategory(category);
	
	String sDepthName=T("|Depth|");	
	PropDouble dDepth(nDoubleIndex++, U(0), sDepthName);	
	dDepth.setDescription(T("|Defines the Depth|"));
	dDepth.setCategory(category);

category = T("|Alignment|");	
	String sAxisOffsetName=T("|Axis Offset|");	
	PropDouble dAxisOffset(nDoubleIndex++, U(0), sAxisOffsetName);	
	dAxisOffset.setDescription(T("|Defines the axis offset|"));
	dAxisOffset.setCategory(category);
	
	String sAngleName=T("|Angle|");	
	PropDouble dAngle(nDoubleIndex++, U(0), sAngleName,_kAngle);	
	String sAngleDescription = T("|Defines the rotation angle of the tool relative to the angle of the detected edge.|") + T(", |must be in the range of -90° < value < 90°|");
	dAngle.setDescription(sAngleDescription);
	dAngle.setCategory(category);
	
	
	
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
		
		int nTool = sTools.find(sTool);
		if (abs(dAngle) >= 90)dAngle.set(0);
		
		Sip sip = getSip();
		Vector3d vecX = sip.vecX();
		Vector3d vecY = sip.vecY();
		Vector3d vecZ = sip.vecZ();
		Point3d ptCen = sip.ptCenSolid();
		double dZ = sip.dH();
		Plane pnRef(ptCen - vecZ * .5 * dZ ,- vecZ);
		Plane pnRefCen(ptCen,vecZ);
		Body bd = sip.envelopeBody(false, true);
		PlaneProfile ppShadow = bd.shadowProfile(pnRef);
		PLine plOpenings[] = sip.plOpenings();
		
		
		SipEdge edges[] = sip.sipEdges();
		AnalysedCut cuts[] =AnalysedCut().filterToolsOfToolType(sip.analysedTools());

	//region Freeprofile
		EntPLine epl;
		if (nTool == 0)
		{ 
			epl = getEntPLine(T("|Select defining tool pline|"));
			PLine pl = epl.getPLine();
			_Entity.append(epl);
			
		// validate polyline	
			if (pl.area()<pow(dEps,2))
			{ 
				reportMessage("\n"+ scriptName() + T("|Requires a closed polyline| ")+T("|Tool will be deleted.|"));
				eraseInstance();
				return;	
			}
			
		// test if pline makes contact to the body	
			CoordSys cs = pl.coordSys();
			Plane pn (cs.ptOrg(), cs.vecZ());
			PlaneProfile pp = bd.extractContactFaceInPlane(pn, dEps);
			if (pp.area() > pow(dEps, 2))
			{
				_Sip.append(sip);
				_Pt0 = pp.ptMid();			
				return;
			}
	
		// test if defining polyline is defined in world-XY	
			if (!cs.vecZ().isParallelTo(_ZW))
			{ 
				reportMessage("\n"+ scriptName() + T("|This tool requires a polyline touching the edge the panel or a polyline oriented in World-XY to be transformed to edges.| ")$+T("|Tool will be deleted.|"));
				eraseInstance();
				return;
			}			
			
		}
	//End Freeprofile//endregion 

	//region Drill Pattern
		else if (nTool == 7)
		{ 
		// prompt for entities
			Entity ents[0];
			PrEntity ssE(T("|Select defining circles|"), Entity());
			if (ssE.go())
				ents.append(ssE.set());
			for (int i=0;i<ents.length();i++) 
				if (ents[i].typeDxfName()=="CIRCLE")
					_Entity.append(ents[i]);
		}	
	//End Drill Pattern//endregion 

	//region Collect planes by edge and cu
		Plane planes[0];
		// Collect planes by edges
		for (int i = 0; i < edges.length(); i++)
		{
			SipEdge e = edges[i];
			Point3d ptMid = e.ptMid();
			Vector3d vecNormal = e.vecNormal();
			Plane pn(e.ptMid(), vecNormal);
			
		// test if on opening ring
			int bIsOpening;
			Line ln = pn.intersect(pnRef);
			Point3d ptMid2 = ln.closestPointTo(ptMid);
			for (int j=0;j<plOpenings.length();j++) 
			{ 
				if (plOpenings[j].isOn(ptMid2))
				{
					bIsOpening=true;
					break;
				}
					 
			}//next j
			if (bIsOpening)continue;	
			
			
			PlaneProfile pp = bd.extractContactFaceInPlane(pn, dEps);
			
			// the edge has contact to the body
			if (pp.area() > pow(dEps, 2))
			{
				planes.append(pn);
			}
		}
		// Collect planes by cuts
		for (int i = 0; i < cuts.length(); i++)
		{
			Point3d pts[] = cuts[i].bodyPointsInPlane();
			Vector3d normal = cuts[i].normal();
			
			Point3d pt = pts.first();
			Plane pn(pt, normal);
			PlaneProfile pp = bd.extractContactFaceInPlane(pn, dEps);
			if (pp.area() > pow(dEps, 2))
			{
				// avoid duplicates
				int bAdd = true;
				for (int j = 0; j < planes.length(); j++)
				{
					if (abs(normal.dotProduct(pt - planes[j].ptOrg())) < dEps && normal.isCodirectionalTo(planes[j].normal()))
					{
						bAdd = false;
						break;
					}	 
				}//next j
				if (bAdd)
					planes.append(pn);
			}			
		}			
	//End Collect planes by edge and cut//endregion 

//
//	// 
//		PlaneProfile ppEpl(CoordSys(cs.ptOrg(), _XW, _YW, _ZW));
//		ppEpl.joinRing(pl, _kAdd);
//		Point3d ptFrom = ppEpl.ptMid();
//

	//region Jig for multiple insertions
		Map mapArgs;
		mapArgs.setEntity("sip", sip);
		mapArgs.setInt("tool", nTool);
		mapArgs.setDouble("depth", dDepth);
		Map mapPlanes;
		for (int i=0;i<planes.length();i++) 
		{ 
			Map m;
			m.setPoint3d("ptOrg", planes[i].ptOrg());
			m.setVector3d("normal", planes[i].normal());
			mapPlanes.appendMap("Plane", m);			 
		}//next i		
		mapArgs.appendMap("Plane[]", mapPlanes);
		mapArgs.setEntityArray(_Entity, false, "Entity[]", "", "Entity");
		
		mapArgs.setDouble("Length", dLength);
		mapArgs.setDouble("Width", dWidth);
		mapArgs.setDouble("Depth", dDepth);
		mapArgs.setDouble("Radius", dRadius);
		
	// Prompt to pick a segment on an opening
		String prompt = T("|Pick point on edge|");
		PrPoint ssP(prompt);	
	
		int nGoJig = -1;
		while (nGoJig != _kNone)
		{ 
			nGoJig = ssP.goJig("Jig", mapArgs); 
			
		//Jig: point picked
			if (nGoJig == _kOk)	
			{
				Point3d ptLoc = ssP.value();
				
			// create TSL
				TslInst tslNew;					Map mapTsl; 
				int bForceModelSpace = true;	
				String sExecuteKey,sCatalogName = sLastInserted;
				String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
				GenBeam gbsTsl[] = {sip};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {ptLoc};
				entsTsl = _Entity;
				
				if (epl.bIsValid())
				{ 
					mapTsl.setInt("alignEntpline", true);
				}

			//Model
				int bOk;
				if (!vecZView.isParallelTo(vecZ))
				{ 
					bOk = Line(ptLoc, vecZView).hasIntersection(pnRefCen, ptsTsl[0]);
				}
			// Panel vecZ	
				else
				{ 
					bOk = Line(ptLoc, vecZ).hasIntersection(pnRef, ptsTsl[0]);
				}
				if (bOk)
					tslNew.dbCreate(scriptName() , vecX ,vecY,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 
		
			}
		// Jig: cancel
	        else if (nGoJig == _kCancel)
	        {
	        	break;	
	        }
		}	

		eraseInstance();
		return;
	}	
// end on insert	__________________//endregion
		
//region Panel standards
	if (_Sip.length()<1)
	{
		reportMessage("\n" + scriptName() + ": " +T("|Invalid reference.|") + " " + T("|Tool will be deleted|"));
		eraseInstance();
		return;
	}

	Sip sip = _Sip[0];
	setEraseAndCopyWithBeams(_kBeam0);
	Vector3d vecX = sip.vecX();
	Vector3d vecY = sip.vecY();
	Vector3d vecZ = sip.vecZ();
	Point3d ptCen = sip.ptCenSolid();
	double dZ = sip.dH();
	
	Plane pnRefFace(ptCen - .5*vecZ * dZ, -vecZ);
	Plane pnRef(ptCen + vecZ * dAxisOffset , vecZ);
	Body bd = sip.envelopeBody(false, true);
	PlaneProfile ppShadow = bd.shadowProfile(pnRefFace);
	
	SipEdge edges[] = sip.sipEdges();
	AnalysedCut cuts[] =AnalysedCut().filterToolsOfToolType(sip.analysedTools());

			
	
	vecX.vis(ptCen,1);vecY.vis(ptCen,3);vecZ.vis(ptCen,150);
	
	assignToGroups(sip, 'T');
	
	PLine plOpenings[] = sip.plOpenings();
	PLine plEnvelope = sip.plEnvelope();
		
//End Panel standards//endregion 	



//region Tool specifics
	setOPMKey(sTool);
	if (dDepth<=0)
	{ 
		reportMessage("\n"+ scriptName() + T("|Depth may not be <= 0| ")+T("|Tool will be deleted.|"));
		eraseInstance();
		return;
		
	}
	if (dRadius <= 0 && nTool == 6) //drill
	{
		reportMessage("\n" + scriptName() + T("|The radius may not be <= 0| ") + T("|Tool will be deleted.|"));
		eraseInstance();
		return;
	}
	if (abs(dAngle) >= 90)dAngle.set(0);
	
	
	Body bdCutting;
	
	Point3d ptX = _Pt0;

//region Free Profile
	EntPLine epl;
	int bAlignEpl = _Map.getInt("alignEntpline");
	if (nTool==0)
	{ 
	// get EntPLine from entity
		for (int i=0;i<_Entity.length();i++) 
		{ 
			EntPLine x = (EntPLine)_Entity[i]; 
			if (x.bIsValid())
			{
				setDependencyOnEntity(x);
				epl = x;
				break;
			}
		}
		
	// validate roofplane
		if (!epl.bIsValid())
		{
			reportMessage("\n" + scriptName() + ": " +T("|could not find defining pline|"));
			eraseInstance();
			return;	
		}

	// set reference point if not in alignment mode
		if(!bAlignEpl)
		{ 
			PLine pl = epl.getPLine();
			ptX.setToAverage(pl.vertexPoints(true));	

			
		}
	}
	ptX.vis(6);
//End Free Profile//endregion 


//End Tool specifics//endregion 


//region Edge detection


//region Collect planes by edge and cu
	Plane planes[0];
	// Collect planes by edges
	for (int i = 0; i < edges.length(); i++)
	{
		SipEdge e = edges[i];
		Point3d ptMid = e.ptMid();
		Vector3d vecNormal = e.vecNormal();
		Plane pn(e.ptMid(), vecNormal);
		
	// test if on opening ring
		int bIsOpening;
		Line ln = pn.intersect(pnRefFace);
		Point3d ptMid2 = ln.closestPointTo(ptMid);
		for (int j=0;j<plOpenings.length();j++) 
		{ 
			if (plOpenings[j].isOn(ptMid2))
			{
				bIsOpening=true;
				break;
			}
				 
		}//next j
		if (bIsOpening)continue;

		PlaneProfile pp = bd.extractContactFaceInPlane(pn, dEps);
		
		// the edge has contact to the body
		if (pp.area() > pow(dEps, 2))
		{
			planes.append(pn);
		}
	}
	// Collect planes by cuts
	for (int i = 0; i < cuts.length(); i++)
	{
		Point3d pts[] = cuts[i].bodyPointsInPlane();
		Vector3d normal = cuts[i].normal();
		
		Point3d pt = pts.first();
		Plane pn(pt, normal);
		PlaneProfile pp = bd.extractContactFaceInPlane(pn, dEps);
		if (pp.area() > pow(dEps, 2))
		{
			// avoid duplicates
			int bAdd = true;
			for (int j = 0; j < planes.length(); j++)
			{
				if (abs(normal.dotProduct(pt - planes[j].ptOrg())) < dEps && normal.isCodirectionalTo(planes[j].normal()))
				{
					bAdd = false;
					break;
				}	 
			}//next j
			if (bAdd)
				planes.append(pn);
		}			
	}			
//End Collect planes by edge and cut//endregion 	
			
	
	SipEdge edge;
	Plane pnTool;
	LineSeg segToolAxis;
	double dDist = U(10e6);
	Vector3d vecXT, vecYT, vecZT;
	for (int i=0;i<planes.length();i++) 
	{ 
		//edges[i].plEdge().vis(i+1);
		planes[i].normal().vis(planes[i].ptOrg(), i + 1);
		Line ln = pnRef.intersect(planes[i]);//ln.vis(6);
		
		Vector3d vecZS = -planes[i].normal();
		Vector3d vecXS = ln.vecX();
		Vector3d vecYS = vecXS.crossProduct(-vecZS);
		if (vecZ.dotProduct(vecYS)<0)
		{ 
			vecXS *= -1;
			vecYS *= -1;
		}
		
		PlaneProfile pp = bd.extractContactFaceInPlane(planes[i], dEps);pp.vis(i + 1);
		Point3d pts[] = pp.intersectPoints(pnRef, true, false);
		
		PLine pl(vecZS);
		if (pts.length()>0)
		{ 
			pl.addVertex(pts.first());
			pl.addVertex(pts.last());
			
		}
	// the contacting plane does not intersect the reference plane	
		else
		{ 
			pl.createConvexHull(planes[i],pp.getGripVertexPoints());
			pl.projectPointsToPlane(pnRef, vecYS);
		}
		//pl.vis(i + 1);
		
		double d = Vector3d(_Pt0 - pl.closestPointTo(ptX)).length();
		if (d<dDist)
		{ 
			dDist = d;
			pnTool = planes[i];
			//edge = edges[i];
			segToolAxis = LineSeg(pl.ptStart(), pl.ptEnd());
			
			vecXT = vecXS;
			vecYT = vecYS;
			vecZT = vecZS;
			
		}
	}//next i
	
	if (segToolAxis.length()>dEps)
	{ 
		_Pt0 = segToolAxis.closestPointTo(ptX);
		pnTool.normal().vis(pnTool.ptOrg(), 150);
		segToolAxis.vis(2);
	}
//End Edge detection//endregion 

if (bDebug)
{ 
	//region Selected Edge
		Plane pnThis = pnTool;
		PlaneProfile pp = bd.extractContactFaceInPlane(pnThis, dEps);
		Line ln = pnRef.intersect(pnThis);
		Point3d ptXExtremes[] = ln.orderPoints(pp.intersectPoints(pnRef, true, false),dEps);
		if (ptXExtremes.length()<1)
			ptXExtremes=ln.orderPoints(ln.projectPoints(pp.getGripVertexPoints()),dEps);
		
		if (ptXExtremes.length()>0 && !ln.vecX().isParallelTo(vecZView))
		{ 
			Vector3d vecDir = ln.vecX();
			double dTextHeight = dViewHeight / 150;
			
			Vector3d vecPerp = vecDir.crossProduct(-vecZ);	
			int nSide = vecPerp.dotProduct(pnThis.normal()) < 0 ?- 1 : 1;
			//if (vecPerp.dotProduct(pnThis.normal()) < 0)vecPerp *= -1;
			vecPerp.vis(_Pt0, 5);
			
			
		// declare dimline	
			DimLine dl(ptX+nSide*vecPerp*U(100), ln.vecX(), vecPerp);
			Dim dim;
			{
				Point3d pts[0];
				dim = Dim(dl,  pts, "",  "", _kDimPar, _kDimPar); 
			}		
		
		// Extremes
			Vector3d vecOrder = vecDir;
			if (vecOrder.isParallelTo(vecYView))vecOrder=vecYView;
			else if (vecDir.dotProduct(vecXView)<0)vecOrder*=-1;

			ptXExtremes = Line(_Pt0, vecOrder).orderPoints(ptXExtremes);
			ptXExtremes.append(_Pt0);
			for (int i=0;i<ptXExtremes.length();i++) 
			{ 
				Point3d& pt = ptXExtremes[i];
				dim.append(pt,"<>",(i==0?" ":"<>")); 
			}//next i


			Display dp(4);
			dim.setReadDirection(vecYView - vecXView);
			dp.draw(dim);			
		}

	//End Selected Edge//endregion 	
}






//region rotation
	Vector3d vecNormal = -vecZT; 
	double dEdgeAngle = vecNormal.angleTo(vecZ)-90;
	dAngle.setDescription(sAngleDescription+ T(", |current edge angle = | ") + String().formatUnit(dEdgeAngle,2,1) + "°");
	
	if (abs(dAngle) <90)
	{	
		CoordSys csRot;
		
	// Freeprofile	
		if (epl.bIsValid())
		{ 
			PLine pl = epl.getPLine();
			CoordSys cs = pl.coordSys();
			Vector3d vecZEpl = cs.vecZ();
			if (vecZEpl.dotProduct(vecNormal)<0)
				vecZEpl *= -1;
			double dCurrentAngle = vecZEpl.angleTo(vecZ)-90;	
//	
//			Display dpp(3);
//			dpp.draw(dEdgeAngle + " vs " + dCurrentAngle, _Pt0, _XW, _YW, 1, 0, _kDeviceX);
//			
			double angle = dAngle-dCurrentAngle+dEdgeAngle;

			
			if (_kNameLastChangedProp==sAngleName && abs(angle)>dEps)
			{ 
				csRot.setToRotation(angle, -vecXT, _Pt0);
				epl.transformBy(csRot);
				setExecutionLoops(2);
				return;
			}				
			
			
		}
	
	// other tools
		else
		{ 
			csRot.setToRotation(dAngle, -vecXT, _Pt0);
			vecYT.transformBy(csRot);
			vecZT.transformBy(csRot);			
		}
	


			
	
	}
//End rotation//endregion 


//region Align EPL
	if (bAlignEpl)
	{ 
		PLine pl = epl.getPLine();
		CoordSys cs = pl.coordSys();
		CoordSys csW(CoordSys(cs.ptOrg(), _XW, _YW, _ZW));
		PlaneProfile ppEpl(csW);
		ppEpl.joinRing(pl, _kAdd);
		
		Point3d ptFrom = ppEpl.ptMid();		
		CoordSys csAlign;
		csAlign.setToAlignCoordSys(ptFrom, _XW, _YW, _ZW, _Pt0, vecXT, vecYT, vecZT);
		pl.transformBy(csAlign);
		
		EntPLine eplNew;
		eplNew.dbCreate(pl);
		eplNew.setColor(epl.color());
		eplNew.assignToGroups(epl, 'T');
		
		int n = _Entity.find(epl);
		if (n>-1)
			_Entity[n] = eplNew;
		else
			_Entity.append(eplNew); // should not happen
		
		_Map.removeAt("alignEntpline", true);
		setExecutionLoops(2);
		return;
	}

	
//End Align EPL//endregion 

//region Free Profile
	if (nTool==0 && epl.bIsValid())
	{ 
		dAxisOffset.setReadOnly(_kHidden);
		dLength.setReadOnly(_kHidden);
		dWidth.setReadOnly(_kHidden);		
		
		PLine pl = epl.getPLine();
		if (pl.coordSys().vecZ().dotProduct(vecZT)>0)
			pl.flipNormal();
		
	// setting length and width in case user alters tool type
		PlaneProfile pp(CoordSys(_Pt0, vecXT, vecYT, vecZT));
		pp.joinRing(pl, _kAdd);
		if (abs(dLength - pp.dX()) > dEps)dLength.set(pp.dX());
		if (abs(dWidth - pp.dY()) > dEps)dWidth.set(pp.dY());
		
//	// dragging TODO not working yet
//		if (_kNameLastChangedProp=="_Pt0")
//		{ 
//			Point3d ptX2; ptX2.setToAverage(pl.vertexPoints(true));
//			double d = vecXT.dotProduct(_Pt0 - ptX2);
//			if (abs(d)>dEps)
//			{ 
//				epl.transformBy(vecXT * d);
//				setExecutionLoops(2);
//				return;
//			}
//		}

		PLine plTool = pl;
		plTool.convertToLineApprox(U(1));
		
		FreeProfile fp(plTool, plTool.vertexPoints(true));
		fp.setDepth(dDepth);
		fp.setMachinePathOnly(false);
		fp.setSolidMillDiameter(dRadius);
		sip.addTool(fp);
		
		bdCutting = Body(pl, vecZT * dDepth * 2, 0);
	}
//End Free Profile//endregion 

//region Beamcut
	else if (nTool == 1)
	{
		BeamCut tool(_Pt0+vecZT*dDepth, vecXT, vecYT, vecZT, dLength, dWidth, U(10e3), 0, 0, -1);
		sip.addTool(tool);
		bdCutting = tool.cuttingBody();
	}
//End Beamcut//endregion 

//region Rabbet
	else if (nTool == 2)
	{
		Rabbet tool(_Pt0, vecXT, vecYT, vecZT, dLength, dWidth, dDepth * 2, 0, 0, 0);
		sip.addTool(tool);
		bdCutting = tool.cuttingBody();
	}
//End Rabbet//endregion 

//region Mortise
	else if (nTool == 3)
	{
		Mortise tool(_Pt0, vecXT, vecYT, vecZT, dLength, dWidth, dDepth * 2, 0, 0, 0);
		tool.setEndType(_kFemaleSide);		
		if (dRadius==0)
			tool.setRoundType(_kNotRound);
		else if (dRadius>0)
		{
			tool.setRoundType(_kExplicitRadius);
			tool.setExplicitRadius(dRadius);
		}

		sip.addTool(tool);
		bdCutting = tool.cuttingBody();
	}
//End Mortise//endregion 

//region Slot
	else if (nTool == 4)
	{
		Slot tool(_Pt0, vecXT, vecYT, vecZT, dLength, dWidth, dDepth * 2, 0, 0, 0);
		sip.addTool(tool);
		bdCutting = tool.cuttingBody();
	}
//End Slot//endregion 

//region House
	else if (nTool == 5)
	{
		House tool(_Pt0, vecXT, vecYT, vecZT, dLength, dWidth, dDepth * 2, 0, 0, 0);
		tool.setEndType(_kFemaleSide);
		if (dRadius==0)
			tool.setRoundType(_kNotRound);
		else if (dRadius>0)
			tool.setRoundType(_kRounded);
		else if (dRadius<0)
			tool.setRoundType(_kRoundSmall);
		
		sip.addTool(tool);
		bdCutting = tool.cuttingBody();
	}
//End House//endregion 

//region Drill
	else if (nTool == 6)
	{
		dWidth.setReadOnly(_kHidden);
		dLength.setReadOnly(_kHidden);
		sTool.setReadOnly(true);
		
		Body tube(_Pt0, _Pt0-vecZT * U(10e4) ,dRadius);
		Vector3d vecFace = vecZ;
		if (vecFace.dotProduct(-vecZT) < 0)vecFace *= -1;
		Cut ct(ptCen + vecFace * .5 * dZ, vecFace);
		tube.addTool(ct, 0);//tube.vis(4);
		Point3d pts[] = tube.extremeVertices(vecZT);
		
		double d=dEps;
		if (pts.length() > 0) d += abs(vecZT.dotProduct(pts.first() - pts.last()));
		
		Drill tool(_Pt0-vecZT*d, _Pt0+vecZT*dDepth, dRadius);
		sip.addTool(tool);
		bdCutting = tool.cuttingBody();
	}
//End Drill//endregion 

//region Drill pattern
	else if (nTool == 7)
	{
		PlaneProfile pp(CoordSys(_PtW, _XW, _YW, _ZW));
		PLine plines[0];
		for (int i=0;i<_Entity.length();i++) 
		{ 
			Entity& ent = _Entity[i];
			if (ent.typeDxfName()!="CIRCLE") {continue; }
			
			PLine pl = ent.getPLine();
			plines.append(pl);
			pp.joinRing(pl, _kAdd);
		}//next i
		
	// get bounds of pattern
		Point3d ptFrom = pp.ptMid();
		CoordSys csAlign;
		csAlign.setToAlignCoordSys(ptFrom, _XW, _YW, _ZW, _Pt0, vecXT, vecYT, vecZT);		
		
		pp.transformBy(csAlign);
		for (int i=0;i<plines.length();i++) 
		{ 
			PLine& pl = plines[i];
			pl.transformBy(csAlign);
			Point3d pts[] = pl.vertexPoints(true);
			if (pts.length() != 2)continue;
			
			Point3d ptLoc; ptLoc.setToAverage(pts);
			double axisOffset = vecZ.dotProduct(ptLoc - ptCen);
			double radius = Vector3d(pts.first()-pts.last()).length();
			
		// create TSL
			TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
			GenBeam gbsTsl[] = {sip};	Entity entsTsl[] = {};			Point3d ptsTsl[] = {ptLoc};
			int nProps[]={};			
			double dProps[]={radius, dLength, dWidth, dDepth, axisOffset, dAngle};				
			String sProps[]={sTools[6]};
			Map mapTsl;	
						
			tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);				
			
		}//next i
		
		if (!bDebug)eraseInstance();
		else pp.vis(3);
		return;
	}
//End Drill Pattern//endregion 


//region Invalid tool
	else
	{ 
		reportMessage("\n"+ scriptName() + T("|Invalid tool definition| ")+T("|Tool will be deleted.|"));
		eraseInstance();
		return;	
	}
//End Invalid tool//endregion 



//region Display
	Display dp(nTool+1);
	if (bdCutting.volume()>pow(dEps,3))
	{ 
		bdCutting.vis(6);
		
		Plane pn(_Pt0, vecNormal);
		PlaneProfile pp = bdCutting.getSlice(pn);
		pp.intersectWith(bd.extractContactFaceInPlane(pn, dEps));
		
		if (pp.area()<pow(dEps, 2))
		{ 
			reportMessage("\n"+ scriptName() + T("|Tool does not intersect panel| ")+T("|Tool will be deleted.|"));
			if (!bDebug)eraseInstance();
			return;
		}
		
		dp.draw(pp,_kDrawFilled,95);
		dp.draw(pp);
		dp.draw(PLine(pp.ptMid(), pp.ptMid()+vecZT*dDepth));
	}
	
//End Display//endregion 

#End
#BeginThumbnail


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
        <int nm="BreakPoint" vl="1082" />
        <int nm="BreakPoint" vl="832" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11691 Face detection and performance improved. jig dimension added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="5/10/2021 3:52:54 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11691 inital version of a panel edge tool" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="4/27/2021 5:14:18 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End