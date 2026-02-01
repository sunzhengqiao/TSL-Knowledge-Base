#Version 8
#BeginDescription
#Versions
1.6 15.03.2022 HSB-14939: fix when investigating/counting door alike openings Author: Marsel Nakuci
1.5 02.11.2021 HSB-13701: add alignment options {"horizontal left","horizontal right","horizontal left right"} Author: Marsel Nakuci
1.4 21.06.2021 HSB-12343: add options at alignment "Vertical extended top" and "Vertical extended bottom top" Author: Marsel Nakuci
Version 1.3 16.06.2021 HSB-12238 mirror and copy added , Author Thorsten Huck
Version 1.2 15.06.2021 HSB-12238 new property alignment to control alignment and vertical tool extension  , Author Thorsten Huck
Version 1.1 06.05.2021 HSB-11799 new tool options and check on free directions, renamed from hsbCLT-OpeingRabbet , Author Thorsten Huck
Version 1.0    21.04.2021 
HSB-11618 new tool to create rabbets at straight opening segments , Author Thorsten Huck

This tool creates a rabbet at an edge of a opening with straight segments






#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 6
#KeyWords CLT;Rabbet;Opening
#BeginContents
//region <History>
// #Versions
// 1.6 15.03.2022 HSB-14939: fix when investigating/counting door alike openings Author: Marsel Nakuci
// Version 1.5 02.11.2021 HSB-13701: add alignment options {"horizontal left","horizontal right","horizontal left right"} Author: Marsel Nakuci
// Version 1.4 21.06.2021 HSB-12343: add options at alignment "Vertical extended top" and "Vertical extended bottom top" Author: Marsel Nakuci
// 1.3 16.06.2021 HSB-12238 mirror and copy added , Author Thorsten Huck
// 1.2 15.06.2021 HSB-12238 new property alignment to control alignment and vertical tool extension  , Author Thorsten Huck
// 1.1 06.05.2021 HSB-11799 new tool options and check on free directions, renamed from hsbCLT-OpeingRabbet , Author Thorsten Huck
// 1.0 21.04.2021 HSB-11618 new tool to create rabbets at straight opening segments , Author Thorsten Huck

/// <insert Lang=en>
/// Select panels and pick insert location
/// </insert>

// <summary Lang=en>
// This tsl creates a rabbet at an edge of a opening with straight segments
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCLT-OpeningEdgeTool")) TSLCONTENT
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

	int nc = 150;
	String sLineType = "DASHED";
	double dLineTypeScale = U(10);
	String sText;
	
// distinguish if current background is light or dark	
	int bIsDark;{int n = getBackgroundTrueColor();bIsDark = ((rgbR(n) + rgbB(n) + rgbG(n)) / 3 < 127);}
	
	int yellow = rgb(241,235,31);
	int orange = rgb(242,103,34);
	int red = rgb(205,32,39);
	int purple = rgb(147,39,143);
	int blue = rgb(69,84,185);
	int petrol = rgb(16,86,137);
	int green = rgb(19,155,72);	

	int darkyellow = rgb(254, 204, 102);	
	Vector3d vecZView = getViewDirection();
//end Constants//endregion

//region bOnJig
	String sJigAction = "Jig";
	if (_bOnJig && _kExecuteKey==sJigAction) 
	{
	//_ThisInst.setDebug(TRUE);
	    //Point3d ptBase = _Map.getPoint3d("_PtBase"); // set by second argument in PrPoint
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point
		double dLength = _Map.getDouble("Length");
		double dWidth = _Map.getDouble("Width");
		double dDepth = _Map.getDouble("Depth");
		double dOffset = _Map.getDouble("Offset");
		
		Display dp(1);
		dp.addViewDirection(vecZView);
		dp.textHeight(U(50));

		PLine plines[0];
		PlaneProfile pps[0],ppsZ[0];
		Vector3d vecDirs[0];
		Vector3d vecPerps[0];
		int nClosest=-1;
		Point3d ptRef;
		double dDist = U(10e6);
		Point3d ptJigProjected=ptJig; 
		Vector3d vecZRef;
		
		for (int i=0;i<_Map.length();i++) 
		{ 
			String key = _Map.keyAt(i);
			if (_Map.hasMap(i) && key == "Sip")
			{ 
				Map mapSip = _Map.getMap(i);
				Vector3d vecZ = mapSip.getVector3d("vecZ");			
				vecZ.normalize();
				
				Point3d ptCen = mapSip.getPoint3d("ptCen");
				Entity ent = mapSip.getEntity("EntDefine");
				Sip sip = (Sip)ent;
				double dZ = mapSip.getDouble("dZ");
				
				Plane pnZ(ptCen, vecZ);

				Point3d pt = ptJig;
				pt += vecZ * vecZ.dotProduct(ptCen - pt);
				
//				PLine plCirc;
//				plCirc.createCircle(ptCen, vecZ, Vector3d(ptCen - pt).length());
//				dp.draw(plCirc);							

				for (int j=0;j<mapSip.length();j++) 
				{ 
					if (mapSip.hasPLine(j))
					{
						PLine pl = mapSip.getPLine(j);
						PlaneProfile ppOpening = mapSip.getPlaneProfile("Opening");
					
						pl.transformBy(vecZ * vecZ.dotProduct(ptCen-pl.coordSys().ptOrg()));
						if (pl.length() < dEps)continue;
						
						Point3d pt1 = pl.ptStart() ;
						Point3d pt2 = pl.ptEnd();
						Point3d ptMid = pl.ptMid();
						Vector3d vecXS = pt2 - pt1; vecXS.normalize();
						Vector3d vecYS = vecXS.crossProduct(-vecZ);
						
						int nFlip=1;
						if (ppOpening.pointInProfile(ptMid+vecYS*dEps)==_kPointOutsideProfile)
						{
							vecYS *= -1;
							nFlip *= -1;
						}
						
						
						plines.append(pl); 
						vecDirs.append(vecXS);
						vecPerps.append(vecYS);
						
						PlaneProfile pp;
						pp.createRectangle(LineSeg(pt1- .5 * vecZ * dZ, pt2 + .5 * vecZ * dZ), vecXS, vecZ);
						pps.append(pp);
						
						PLine plZ(vecZ);
						plZ.addVertex(ptMid);
						plZ.addVertex(ptMid+vecXS*U(200));
						plZ.addVertex(ptMid, nFlip*tan(22.5));
						plZ.transformBy(vecXS *- U(100));
						dp.draw(plZ);
						ppsZ.append(PlaneProfile(plZ));
						dp.draw(pl);						

						double d = (pt - pl.closestPointTo(pt)).length();
						if (d<dDist)
						{ 
							ptRef = pl.closestPointTo(pt);
							dDist = d;
							nClosest = plines.length()-1;
							ptJigProjected = pt;
							vecZRef = vecZ;
						}
						//dp.draw((plines.length()-1)+ ": " +d + " dMin="+dDist , pl.ptMid(), _XW, _YW, 0, 0, _kDevice);
					}
					 
				}//next j
				
				dp.draw(" closest: " + nClosest + " offset " + dOffset, ptCen, _XW, _YW, 0, 0, _kDevice);
				//dp.draw(PLine (ptJig,pt,ptRef));
			}
			 
		}//next i
		
		
		
		for (int i=0;i<pps.length();i++) 
		{ 
			int n = nClosest;

			dp.trueColor((i==n?green:darkyellow),80);
			dp.draw(pps[i], _kDrawFilled);
			dp.draw(ppsZ[i], _kDrawFilled);


		// get length from start to jig
			if (dLength<dEps && _Map.hasPoint3d("ptStart"))
			{ 
				double d = vecDirs[n].dotProduct(ptJig - _Map.getPoint3d("ptStart"));
				if (d>0)
					dLength = d;
			}



			if (i==n && dLength>dEps && dWidth>dEps && dDepth>dEps)
			{
				PLine pl = plines[n];
				Point3d pt1 = pl.ptStart();
				Point3d pt2 = pl.ptEnd();

				Vector3d vecXT = vecDirs[n];
				Vector3d vecZT = -vecPerps[n];
				Vector3d vecYT = vecXT.crossProduct(-vecZT);

				PlaneProfile ppRange;
				ppRange.createRectangle(LineSeg(pt1,pt2+vecZT*dDepth), vecXT, vecZT);

				if (_Map.hasPoint3d("ptStart"))
					ptRef = pl.closestPointTo(_Map.getPoint3d("ptStart"));				
				else
					ptRef = pl.closestPointTo(ptJigProjected);
				ptRef.transformBy(vecZRef * dOffset);
				

				Body bd(ptRef, vecXT, vecYT, vecZT, dLength, dWidth, dDepth, 1, 0, 1);
				PlaneProfile ppBody = bd.shadowProfile(Plane(bd.ptCen(), vecZView));
				
				PlaneProfile ppTest = ppBody;
				ppTest.subtractProfile(ppRange);
				if (ppTest.area()>pow(dEps, 2))
				{ 
					dp.trueColor(rgb(255,0,0),80);
					dp.draw(ppTest,_kDrawFilled);
					
					dp.trueColor(darkyellow,80);
					ppBody.subtractProfile(ppTest);
					dp.draw(ppBody,_kDrawFilled);
					
				}
				else
				{ 
					dp.trueColor(darkyellow,80);
					dp.draw(ppBody,_kDrawFilled);
				}
				
				dp.draw(bd);
				//dp.draw(PLine(ptJig, pl.ptMid()));
			}
		}//next i
		




	    return;
	}		
//End bOnJig//endregion 

//region Properties
	String sToolName=T("|Tool|");	
	String tools[] = { T("|Rabbet|"), T("|Rabbet + Overshoot|"), T("|Beamcut|"), T("|Slot|"), T("|Housing|"), T("|Mortise|")};//, T("|Housing|")
	String sTools[0];sTools = tools.sorted();
	PropString sTool(nStringIndex++,sTools, sToolName);	
	sTool.setDescription(T("|Defines the Tool|"));
	sTool.setCategory(category);
	int nTool = tools.find(sTool);
	if (nTool < 0){sTool.set(tools.first()); setExecutionLoops(2); return;}
	
	String sLengthName=T("|Length|");	
	PropDouble dLength(nDoubleIndex++, U(0), sLengthName);	
	dLength.setDescription(T("|Defines the Length|, ") + T("|0 = specify length by point|"));
	dLength.setCategory(category);
	
	String sWidthName=T("|Width|");	
	PropDouble dWidth(nDoubleIndex++, U(0), sWidthName);	
	dWidth.setDescription(T("|Defines the Width|"));
	dWidth.setCategory(category);
	
	String sDepthName=T("|Depth|");	
	PropDouble dDepth(nDoubleIndex++, U(0), sDepthName);	
	dDepth.setDescription(T("|Defines the Depth|"));
	dDepth.setCategory(category);
	
	String sAxisOffsetName=T("|Axis Offset|");	
	PropDouble dAxisOffset(nDoubleIndex++, U(0), sAxisOffsetName);	
	dAxisOffset.setDescription(T("|Defines the axis offset|"));
	dAxisOffset.setCategory(category);

	String sAlignmentName=T("|Alignment|");	
	String sAlignments[] = { T("|Horizontal|"), T("|Vertical|"), 
	 T("|Vertical extended bottom|"), T("|Vertical extended top|"), T("|Vertical extended bottom top|"),
	 T("|Horizontal extended left|"), T("|Horizontal extended right|"), T("|Horizontal extended left right|")};
	PropString sAlignment(nStringIndex++, sAlignments, sAlignmentName,1);	
	sAlignment.setDescription(T("|Defines if the rabbet is aligned vertical|"));
	sAlignment.setCategory(category);
	if (sAlignment==T("|Yes|"))
		sAlignment.set(sAlignments[1]);
	else if (sAlignment==T("|No|"))
		sAlignment.set(sAlignments[0]);

//End Properties//endregion 

//region bOnInsert
	if (_bOnInsert)
	{
		if (insertCycleCount() > 1) { eraseInstance(); return; }
		
		// silent/dialog
		if (_kExecuteKey.length() > 0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			if (sEntries.findNoCase(_kExecuteKey ,- 1) >- 1)
				setPropValuesFromCatalog(_kExecuteKey);
			else
				setPropValuesFromCatalog(sLastInserted);
		}
		// standard dialog	
		else
			showDialog();
		int nHors[] ={ 0, 5, 6, 7};
		int nVers[] ={ 1, 2, 3, 4};
		int bOnlyVertical = nVers.find(sAlignments.find(sAlignment))>-1;
			
		
	// prompt for sips
		Entity ents[0];
		PrEntity ssE(T("|Select panels|"), Sip());
		if (ssE.go())
			ents.append(ssE.set());	
	
	// loop selection set and collect jig map data
		Map mapArgs;
		mapArgs.setDouble("Length", dLength);
		mapArgs.setDouble("Width", dWidth);
		mapArgs.setDouble("Depth", dDepth);
		mapArgs.setDouble("Offset", dAxisOffset);
		
		LineSeg segs[0];
		Sip sipsBySeg[0];
		for (int i = 0; i < ents.length(); i++)
		{
			Map mapSip;
			
			Sip sip = (Sip)ents[i];
			Vector3d vecX = sip.vecX();
			Vector3d vecY = sip.vecY();
			Vector3d vecZ = sip.vecZ();
			Point3d ptCen = sip.ptCen();
			PLine plEnvelope = sip.plEnvelope();
			
			Body bdEnv = sip.envelopeBody(false, true);
			Plane pnZ(ptCen, vecZ);
			PlaneProfile ppZ(sip.coordSys());
			ppZ.unionWith(bdEnv.shadowProfile(pnZ));		//ppZ.vis(1);			
			CoordSys cs = CoordSys(ptCen, vecX, vecY, vecZ);

		// the boxed shape of the panel	
			PlaneProfile ppSipBox(cs); 
			ppSipBox.joinRing(plEnvelope, _kAdd);
			LineSeg segBox = ppSipBox.extentInDir(vecX);
			ppSipBox.createRectangle(segBox, vecX, vecY); // box it

		// collect windows / openings	
			PLine plOpenings[] = sip.plOpenings();

			Vector3d vecYRef = vecY;
			if (vecZ.isPerpendicularTo(_ZW))// wall alike
				vecYRef = _ZW;
			else if (vecZ.isParallelTo(_ZW))// flattended or floor
			{
				if (vecX.isParallelTo(_XW))
					vecYRef = vecY;
				else if (vecX.isParallelTo(_YW))
					vecYRef = vecX;	
			}
			Vector3d vecXRef = vecYRef.crossProduct(vecZ);


		//region Append door alike openings	
			{ 
				PlaneProfile ppDoor= ppSipBox;
				PlaneProfile pp = ppZ;
				pp.removeAllOpeningRings();
				ppDoor.subtractProfile(pp);			//ppDoor.vis(1);
				
				PLine rings[] = ppDoor.allRings(true, false);
				
				for (int r=0;r<rings.length();r++) 
				{ 
					pp = PlaneProfile(cs);
					pp.joinRing(rings[r], _kAdd);
					Point3d pts[] = pp.getGripEdgeMidPoints();
					
					int cnt;
					for (int p=0;p<pts.length();p++) 
					{ 
						if(ppSipBox.pointInProfile(pts[p])==_kPointOnRing)
							cnt++; 			 
					}//next i
					// HSB-14939
//					if (cnt==1)
					if (cnt>=1)
					{ 
						plOpenings.append(rings[r]);
					}
					 
				}//next r
			}
		//End Append door alike openings//endregion 
		
		//region Collect valid openings / segments. An opening must contain straight segments
			PlaneProfile ppOpening(cs);
			for (int j=plOpenings.length()-1; j>=0 ; j--) 
			{ 
				PLine pl=plOpenings[j]; 
				pl.projectPointsToPlane(pnZ, vecZ);
				Point3d pts[] = pl.vertexPoints(false);
				
				int bOk;
				for (int p=0;p<pts.length()-1;p++) 
				{ 
					Point3d pt1= pts[p]; 
					Point3d pt2= pts[p+1];
					Point3d ptMid = (pt1 + pt2) * .5;
					
					Vector3d vecXS = pt2 - pt1; vecXS.normalize();
					Vector3d vecYS = vecXS.crossProduct(-vecZ);
					if (vecXS.isParallelTo(vecYRef) && !vecXS.isCodirectionalTo(vecYRef))
					{ 
						pt1= pts[p+1]; 
						pt2= pts[p];
						vecXS *= -1;
						vecYS *= -1;
					}
					
					int bIsVertical = vecXS.isParallelTo(vecYRef);
					int bAdd = (bIsVertical && bOnlyVertical) || ( ! bIsVertical && !bOnlyVertical);
					if (pl.isOn(ptMid) && ppSipBox.pointInProfile(ptMid)==_kPointInProfile && bAdd)
					{ 
						bOk = true;			
						LineSeg seg(pt1, pt2);
						segs.append(seg);
						sipsBySeg.append(sip);
						mapSip.appendPLine("Seg", PLine(pt1, pt2));
					}
		
				}//next p
				
				if (!bOk)
					plOpenings.removeAt(j);
				else
					ppOpening.joinRing(pl, _kAdd);
			}//next j
		//End Collect valid openings.//endregion 
		
			if (mapSip.length()>0)
			{ 
				mapSip.setVector3d("vecZ", vecZ);
				mapSip.setPoint3d("ptCen", ptCen);
				mapSip.setDouble("dZ", sip.dH());
				mapSip.setEntity("EntDefine", sip);
				mapSip.setPlaneProfile("Opening", ppOpening);
				mapArgs.appendMap("Sip", mapSip);
				
			}
		}// next i


	//region Jig 1
	// Prompt to pick a segment on an opening
		String prompt = T("|Pick start point|");
		PrPoint ssP(prompt);	
	
		int nGoJig = -1;
		Vector3d vecDir;
		while (nGoJig != _kNone && nGoJig != _kOk)
		{ 
			nGoJig = ssP.goJig("Jig", mapArgs); 
			
		//Jig: point picked
			if (nGoJig == _kOk)
			{
				Point3d ptPick = ssP.value();
				LineSeg segRef;
				Sip sipRef;
			// get closest segment
				double dDist = U(10e6);
				for (int i=0;i<segs.length();i++) 
				{ 
					Sip sip = sipsBySeg[i];
					Vector3d vecZ = sip.vecZ();
					Point3d ptCen = sip.ptCen();
					
					Point3d pt = ptPick+vecZ*vecZ.dotProduct(ptCen-ptPick);
					double d = Vector3d(segs[i].closestPointTo(pt)-pt).length();
					if (d<dDist)
					{ 
						dDist = d;
						segRef = segs[i];
						sipRef = sip;
					}
					 
				}//next i
				
				if (segRef.length()>0)
				{
					ptPick = segRef.closestPointTo(ptPick);
					_Sip.append(sipRef);
					vecDir = segRef.ptEnd() - segRef.ptStart();
					vecDir.normalize();
				}
				_Pt0 = ptPick;
				
			}
		// Jig: cancel
	        else if (nGoJig == _kCancel)
	        {
	        	break;	
	        	eraseInstance();
	        }
		}	
	//endregion 
		
	//region Jig 2: prompt second point to get length
		if (dLength<dEps)
		{ 
			mapArgs.setPoint3d("ptStart", _Pt0);
			prompt = T("|Pick end point|");
			ssP=PrPoint (prompt,_Pt0);
			nGoJig = -1;
			while (nGoJig != _kNone && nGoJig != _kOk)
			{ 
				nGoJig = ssP.goJig("Jig", mapArgs); 
				
			//Jig: point picked
				if (nGoJig == _kOk)
				{
					Point3d ptPick = ssP.value();
					double d = vecDir.dotProduct(ptPick - _Pt0);
					if (d>0)
					{
						dLength.set(d);
						_PtG.append(ptPick);
					}
					else
					{ 
						eraseInstance();
					}
				}
			// Jig: cancel
		        else if (nGoJig == _kCancel)
		        {
		        	break;	
		        	eraseInstance();
		        }
			}			
		}
		else
		{ 
			_PtG.append(_Pt0+vecDir*dLength);
		}
	//endregion 	
		
		if (dLength<dEps ||vecDir.bIsZeroLength())
			eraseInstance();
		
		_Map.setVector3d("vecDir", vecDir);
		return;
	}
//endregion	

//region Panel standards
	setEraseAndCopyWithBeams(_kBeam0);
	if (_Sip.length()<1 ||_PtG.length()<1)
	{
		reportMessage("\n" + scriptName() + ": " +T("|Invalid reference.|") + " " + T("|Tool will be deleted|"));
		eraseInstance();
		return;
	}
	//reportNotice("\n\nExecuting " + _ThisInst.handle() + " in loop " + _kExecutionLoopCount);

	Sip sip = _Sip[0];
	Vector3d vecX = sip.vecX();
	Vector3d vecY = sip.vecY();
	Vector3d vecZ = sip.vecZ();
	Point3d ptCen = sip.ptCenSolid();
	double dZ = sip.dH();
	vecX.vis(ptCen,1);vecY.vis(ptCen,3);vecZ.vis(ptCen,150);

	_ThisInst.setDrawOrderToFront(true);

// declare a potential element ref
	Element el=sip.element();
	if (el.bIsValid())
	{
		assignToElementGroup(el,true,0,'T');
		_Element.append(el);	
	}
	else
		assignToGroups(sip, 'T');
	
	PLine plOpenings[] = sip.plOpenings();
	PLine plEnvelope = sip.plEnvelope();
	Body bdEnv = sip.envelopeBody(false, true);
	Plane pnZ(ptCen, vecZ);
	PlaneProfile ppZ(sip.coordSys());
	ppZ.unionWith(bdEnv.shadowProfile(pnZ));		//ppZ.vis(1);
	SipEdge edges[] = sip.sipEdges();
	SipStyle style(sip.style());
	
	CoordSys cs = CoordSys(ptCen, vecX, vecY, vecZ);
	PlaneProfile ppSipBox(cs); 
	ppSipBox.joinRing(plEnvelope, _kAdd);
	LineSeg segBox = ppSipBox.extentInDir(vecX);
	ppSipBox.createRectangle(segBox, vecX, vecY); // box it
	PLine plSipBox; plSipBox.createRectangle(segBox, vecX, vecY); 			//plSipBox.vis(254);

	if (dLength<dEps || dWidth <dEps || dDepth < dEps)
	{
		reportMessage("\n" + scriptName() + ": " +T("|Invalid tool geometry.|") + " " + T("|Tool will be deleted|"));
		//eraseInstance();
		return;
	}

	Vector3d vecDir = _Map.getVector3d("vecDir");
	//sAlignment.setReadOnly(_kHidden);
	int nAlignment = sAlignments.find(sAlignment);
	int nHors[] ={ 0, 5, 6, 7};
	int nVers[] ={ 1, 2, 3, 4};
	int bIsVertical = nVers.find(nAlignment)>-1;
	if (bIsVertical && nTool>3)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|The tool type| ")+ sTool + T(" |is not supported on vertical edges and will be set to 'Beamcut'|"));
		sTool.set(tools[2]);
		setExecutionLoops(2);
		return;
	}
	
//End Panel standards//endregion 

//region Distinguish Panel Alignment/Type
	Vector3d vecYRef = vecY;
	if (vecZ.isPerpendicularTo(_ZW))// wall alike
		vecYRef = _ZW;
	else if (vecZ.isParallelTo(_ZW))// flattended or floor
	{
		if (vecX.isParallelTo(_XW))
			vecYRef = vecY;
		else if (vecX.isParallelTo(_YW))
			vecYRef = vecX;	
	}
	Vector3d vecXRef = vecYRef.crossProduct(vecZ);
		
//End Distinguish Panel Alignment/Type//endregion 

//region Get segments
//region Append door alike openings	
	{ 
		PlaneProfile ppDoor= ppSipBox;
		PlaneProfile pp = ppZ;
		pp.removeAllOpeningRings();
		ppDoor.subtractProfile(pp);			//ppDoor.vis(1);
		
		PLine rings[] = ppDoor.allRings(true, false);
		
		for (int r=0;r<rings.length();r++) 
		{ 
			pp = PlaneProfile(cs);
			pp.joinRing(rings[r], _kAdd);
			Point3d pts[] = pp.getGripEdgeMidPoints();
			
			int cnt;
			for (int i=0;i<pts.length();i++) 
			{ 
				if(ppSipBox.pointInProfile(pts[i])==_kPointOnRing)
					cnt++; 			 
			}//next i
			// HSB-14939
//			if (cnt==1)
			if (cnt>=1)
			{ 
				plOpenings.append(rings[r]);
			}
			 
		}//next r
	}
//End Append door alike openings//endregion 

//region Collect valid openings / segments. An opening must contain straight segments
	LineSeg segs[0];
	for (int i=plOpenings.length()-1; i>=0 ; i--) 
	{ 
		PLine pl=plOpenings[i]; 
		pl.projectPointsToPlane(pnZ, vecZ);
		Point3d pts[] = pl.vertexPoints(false);
		
		int bOk;
		for (int p=0;p<pts.length()-1;p++) 
		{ 
			Point3d pt1= pts[p]; 
			Point3d pt2= pts[p+1];
			Point3d ptMid = (pt1 + pt2) * .5;
			
			Vector3d vecXS = pt2 - pt1; vecXS.normalize();
			Vector3d vecYS = vecXS.crossProduct(-vecZ);
			if (vecXS.isParallelTo(vecYRef) && !vecXS.isCodirectionalTo(vecYRef))
			{ 
				pt1= pts[p+1]; 
				pt2= pts[p];
				vecXS *= -1;
				vecYS *= -1;
			}
			
			
		// accept only segmemnts within panel, on opening ring and with parallel alignment	
			if (pl.isOn(ptMid) && ppSipBox.pointInProfile(ptMid)==_kPointInProfile && vecDir.isParallelTo(vecXS))
			{ 
				bOk = true;
				vecYS.vis(ptMid, 3);			
				LineSeg seg(pt1, pt2);
				
				segs.append(seg);
			}
		}//next p
		
		if (!bOk)
			plOpenings.removeAt(i);
		else
			pl.vis(3);
	}//next i
//End Collect valid openings.//endregion 		
	

//End Get segments (copy of IO)//endregion 

//region Tool
	_Pt0 +=vecZ*vecZ.dotProduct(ptCen-_Pt0);
	Point3d ptMid = (_Pt0 + _PtG[0]) * .5;
	ptMid +=vecZ*vecZ.dotProduct(ptCen-ptMid);
// closest segment
	double dDist = U(10e5);
	LineSeg seg;
	for (int i=0;i<segs.length();i++) 
	{ 
		double d = (segs[i].closestPointTo(ptMid)-ptMid).length(); 
		if (d<dDist)
		{ 
			seg = segs[i];
			dDist = d;
		}
	}//next i
	
	_Pt0 =seg.closestPointTo(_Pt0);
	Point3d ptA = _Pt0+vecZ*dAxisOffset;
	Vector3d vecXT = seg.ptEnd() - seg.ptStart();vecXT.normalize();
	Vector3d vecZT = vecXT.crossProduct(-vecZ);
	if (ppZ.pointInProfile(seg.ptMid()+vecZT*dEps)==_kPointOutsideProfile)
		vecZT *= -1;
	Vector3d vecYT = vecXT.crossProduct(-vecZT);
	vecXT.vis(ptA, 1);
	vecYT.vis(ptA, 3);
	vecZT.vis(ptA, 150);
	
// add grip	
	if (_PtG.length()<1)
		_PtG.append(ptA + vecXT * dLength);
	_PtG[0]+=vecZ*vecZ.dotProduct(ptCen-_PtG[0])+vecZT*vecZT.dotProduct(ptA-_PtG[0]);
	Point3d ptB = _PtG[0];
_PtG[0].vis(3);
// On dragging PtG
	if (_kNameLastChangedProp=="_PtG0")
	{ 
		double d = vecXT.dotProduct(_PtG[0] - ptA);
		if (d>0)
			dLength.set(d);
		else
			_PtG[0] = ptA + vecXT * dLength;
					setExecutionLoops(2);
		return;	
	}
	
// on changing length
	else if (_kNameLastChangedProp==sLengthName)
	{ 
		_PtG[0] = ptA + vecXT * dLength;	
				setExecutionLoops(2);
		return;	
	}
// on changing alignment
	else if (_kNameLastChangedProp==sAlignmentName)
	{ 
		String sHors[]={ T("|Horizontal|"), 
	 T("|Horizontal extended bottom|"), T("|Horizontal extended top|"), T("|Horizontal extended bottom top|")};
	 	String sVers[]={ T("|Vertical|"), 
	 T("|Vertical extended bottom|"), T("|Vertical extended top|"), T("|Vertical extended bottom top|")};
		String last = _Map.getString("lastAlignment");
		String new;
		String sTry = sAlignment;
		// HSB-13701
		if((sHors.find(last)>-1 && sVers.find(sAlignment)>-1)||
			(sVers.find(last)>-1 && sHors.find(sAlignment)>-1))
		{
			// changing from horizontal to vertical and vice versa
			new = last;
		}
		
//		if (last == sAlignments[0] && nAlignment>0)
//		{
//			// horizontal to vertical or any of it options
//			new = sAlignments[0];
//		}
//		else if (last == sAlignments[1] && nAlignment==0)
//			new = sAlignments[1];
//		else if (last == sAlignments[2] && nAlignment==0)
//			new = sAlignments[2];	
			
		if (new.length()>0)
		{ 
//			reportMessage(TN("|Orientation cannot be changed from| ") + last + " -> " + new);
			reportMessage(TN("|Orientation cannot be changed from| ") + last + " -> " + sTry);
			sAlignment.set(new);
		}
		setExecutionLoops(2);
		return;
	}
	
	if ( vecXT.dotProduct( _PtG[0]-seg.ptEnd())>0)
	{ 
		_PtG[0] = seg.ptEnd();
		dLength.set( vecXT.dotProduct(_PtG[0] - ptA));
		reportMessage("\n" + scriptName() + ": " +T("|tool length corrected to| ") + dLength);
	}
	

// get tool length
	double dToolLength = dLength;
	// HSB-13701
	if (nAlignment==2 || nAlignment==3 || nAlignment==4 
	||  nAlignment==5 || nAlignment==6 || nAlignment==7)
	{ 
		// vertical extended bottom, top or bottom top
		if((nAlignment==2 || nAlignment==4) || (nAlignment==5 || nAlignment==7))
		{ 
			LineSeg segs[] = ppSipBox.splitSegments(LineSeg(ptA, ptA - vecXT * U(10e4)), true);
			Point3d pts[0];
			for (int i=0;i<segs.length();i++) 
			{ 
				pts.append(segs[i].ptStart());
				pts.append(segs[i].ptEnd()); 
			}//next i
			pts = Line(_Pt0, vecXT).orderPoints(pts);
			
			if (pts.length()>0)
			{ 
				double d = vecXT.dotProduct(ptA - pts.first());
				if (d>0)
				{ 
					dToolLength += d;
					ptA -= vecXT * d;
				}
			}
		}
		// HSB-12343
		if((nAlignment==3 || nAlignment==4) || (nAlignment==6 || nAlignment==7))
		{ 
			LineSeg segs[] = ppSipBox.splitSegments(LineSeg(_PtG[0], _PtG[0] + vecXT * U(10e4)), true);
			Point3d pts[0];
			for (int i=0;i<segs.length();i++) 
			{ 
				pts.append(segs[i].ptStart());
				pts.append(segs[i].ptEnd()); 
			}//next i
			pts = Line(_Pt0, -vecXT).orderPoints(pts);
			if (pts.length()>0)
			{ 
				double d = -vecXT.dotProduct(_PtG[0] - pts.first());
				if (d>0)
				{ 
					dToolLength += d;
//					ptA -= vecXT * d;
				}
			}
		}
	}

// adding the tool
	Body bdTool;
	int color = darkyellow;
	if (dLength>dEps && dWidth>dEps && dDepth>dEps)
	{ 
	// tool		
		// { T("|Rabbet|"), T("|Rabbet + Overshoot|"), T("|Beamcut|"), T("|Slot|"), T("|Mortise|"), T("|Housing|")};

	// check free direction
		Point3d pt = ptA + vecXT * .5 * dLength;
		int numFree;
		if (ppZ.splitSegments(LineSeg(pt, pt - vecXT * U(10e4)), true).length()<1)
			numFree++;
		if (ppZ.splitSegments(LineSeg(pt, pt + vecXT * U(10e4)), true).length()<1)
			numFree++;	
		if (ppZ.splitSegments(LineSeg(pt, pt - vecZT * U(10e4)), true).length()<1)
			numFree++;
		if (ppZ.splitSegments(LineSeg(pt, pt + vecZT * U(10e4)), true).length()<1)
			numFree++;		

	// rabbet
		if (nTool <=1)
		{ 
			Rabbet t(ptA, vecXT, vecYT, vecZT, dToolLength, dWidth, dDepth, 1, 0, 1);
			t.setOverShoot(nTool==1?_kOverShoot:_kNoOverShoot);	
			t.excludeMachineForCNC(_kAnyMachine);
			sip.addTool(t);
			bdTool = t.cuttingBody();	
			color =nTool==1?blue:petrol;			
		}
	// beamcut
		else if (nTool ==2)
		{ 
			BeamCut t(ptA, vecXT, vecYT, vecZT, dToolLength, dWidth, dDepth, 1, 0, 1);	
			if (numFree<1)t.excludeMachineForCNC(_kAnyMachine);
			sip.addTool(t);
			bdTool = t.cuttingBody();
			color =red;
		}		
	// SLot
		else if (nTool ==3)
		{ 
			Slot t(ptA, vecXT, vecYT, vecZT, dToolLength, dWidth, dDepth, 1, 0, 1);	
			if (numFree<1)t.excludeMachineForCNC(_kAnyMachine);
			sip.addTool(t);
			bdTool = t.cuttingBody();
			color =green;
		
		}
	// Housing
		else if (nTool ==4)
		{ 
			if (numFree<1)
			{ 
				reportMessage("\n" + scriptName() + ": " +T("|The tool type| ")+ sTool + T(" |is not supported because it has no free direction at its location and will be set to 'Beamcut'|"));
				sTool.set(tools[2]);
				setExecutionLoops(2);
				return;
			}	
			
			House t(ptA, vecXT, vecYT, vecZT, dToolLength, dWidth, dDepth, 1, 0, 1);	
			if (numFree<1)t.excludeMachineForCNC(_kAnyMachine);
			sip.addTool(t);
			bdTool = t.cuttingBody();	
			color =orange;	
		}		
	// Mortise
		if (nTool ==5)
		{ 
			if (numFree<1)
			{ 
				reportMessage("\n" + scriptName() + ": " +T("|The tool type| ")+ sTool + T(" |is not supported because it has no free direction at its location and will be set to 'Beamcut'|"));
				sTool.set(tools[2]);
				setExecutionLoops(2);
				return;
			}	

			Mortise t(ptA, vecXT, vecYT, vecZT, dToolLength, dWidth, dDepth, 1, 0, 1);	
			if (numFree<1)t.excludeMachineForCNC(_kAnyMachine);
			sip.addTool(t);
			bdTool = t.cuttingBody();	
			color =purple;
		}		
		
		bdTool.vis(2);
		

	}
//End Tool //endregion 

//region Display and publish	
// Display
	Display dp(-1);
	dp.trueColor(color);
	PlaneProfile ppTool = bdTool.extractContactFaceInPlane(Plane(ptA, vecZT), dEps);
	if (ppTool.area() < pow(dEps, 2))ppTool=bdTool.getSlice(Plane(ptA, vecZT));
	dp.draw(ppTool.extentInDir(vecXT));
	dp.draw(PLine(ppTool.ptMid(), ppTool.ptMid() + vecZT * dDepth));
	dp.draw(ppTool);
	dp.trueColor(color, 90);
	dp.draw(ppTool, _kDrawFilled);	
	
	PlaneProfile ppShape = bdTool.shadowProfile(pnZ);
	ppShape.transformBy(vecZ * dAxisOffset);
	_Map.setPlaneProfile("ppToolShapeZ", ppShape);
	_Map.setDouble("dZ", dWidth);
	_Map.setString("lastAlignment", sAlignment);
//End Display and publish//endregion 










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
        <int nm="BreakPoint" vl="868" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14939: fix when investigating/counting door alike openings" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="3/15/2022 9:37:41 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13701: add alignment options {&quot;horizontal left&quot;,&quot;horizontal right&quot;,&quot;horizontal left right&quot;}" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="11/2/2021 8:21:37 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12343: add options at alignment &quot;Vertical extended top&quot; and &quot;Vertical extended bottom top&quot;" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="6/21/2021 7:13:34 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12238 mirror and copy added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="6/16/2021 8:26:50 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12238 new property alignment to control alignment and vertical tool extension " />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="6/15/2021 5:02:58 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11799 new tool options and check on free directions, renamed from hsbCLT-OpeingRabbet" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="5/6/2021 11:56:18 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End