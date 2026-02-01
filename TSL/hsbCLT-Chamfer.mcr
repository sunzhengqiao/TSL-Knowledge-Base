#Version 8
#BeginDescription
version value="1.2" date="22jan2018" author="thorsten.huck@hsbcad.com"
new custom command and double click behaviour to toggle visibility of defining polyline

This tsl defines a polyline based tool for chamfers
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
/// <History>//region
/// <version value="1.2" date="22jan2018" author="thorsten.huck@hsbcad.com"> new custom command and double click behaviour to toggle visibility of defining polyline </version>
/// <version value="1.1" date="24may2017" author="thorsten.huck@hsbcad.com"> solid cleanup of  concave corners </version>
/// <version value="1.0" date="15nov2016" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select properties or catalog entry and press OK. Select one or multiple panels and then depending on the selected option polylines and/or reference points
/// </insert>

/// <summary Lang=de>
/// Dieses TSL definiert Fasen auf der Basis von Polylinien
/// </summary>//

/// <summary Lang=en>
/// This tsl defines a polyline based tool for chamfers
/// </summary>

/// <remark Lang=en>
/// These commands can be used to execute the command from ribbon, palette or tool button
/// Command to show the polyline:
/// 	^C^C(defun c:TSL_ShowChamferPolyline() (hsb_RecalcTslWithKey (_TM "|Show polyline|") (_TM "|Select chamfer tool(s)|"))) TSL_ShowChamferPolyline
/// Command to hide the polyline:
/// 	^C^C(defun c:TSL_HideChamferPolyline() (hsb_RecalcTslWithKey (_TM "|Hide polyline|") (_TM "|Select chamfer tool(s)|"))) TSL_HideChamferPolyline
/// </remark>//



//endregion

// constants //region
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));	
	String sDefault =T("|_Default|");
	//endregion


	String category;

// chamfer
	category = T("|General|");

	String sModeName="(A)   "+T("|Insertion Mode|");
	String sModes[] = {T("|Contour|"), T("|Openings|"), T("|Contour|") + " & " + T("|Openings|"), T("|Feed Direction|"), T("|Polyline|"), T("|Path|")};//
	PropString sMode(nStringIndex++, sModes, sModeName);	
	sMode.setDescription(T("|Defines the Mode|"));
	sMode.setCategory(category);

	String sAlignmentName="(B)   "+T("|Alignment|");	
	String sAlignments[] = {T("|Reference Side|"), T("|Opposite Side|"), T("|Both Sides|")};
	PropString sAlignment(nStringIndex++, sAlignments, sAlignmentName);	
	sAlignment.setDescription(T("|Defines the Alignment|"));
	sAlignment.setCategory(category);

	String sChamferName="(C)  "+ T("|Length|");
	PropDouble dChamfer(nDoubleIndex++, U(4), sChamferName);
	dChamfer.setCategory(category);


// bOnInsert
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
				setPropValuesFromCatalog(T("|_LastInserted|"));					
		}	
		else	
			showDialog();

		int nAlignment = sAlignments.find(sAlignment,0);
		int nColor = (nAlignment==1?4:3);
		int nMode = sModes.find(sMode);
		
	// selection
		Entity entities[0];	
		PrEntity ssGb(T("|Select panel(s)|"), Sip());
  		if (ssGb.go())
	    	entities= ssGb.set();	
	    	
		for (int i=entities.length()-1;i>=0;i--)
		{
			Sip sip= (Sip)entities[i];
			if (sip.bIsValid() && !sip.bIsDummy())
			{
				_Sip.append(sip);
				_GenBeam.append(sip);
				entities.removeAt(i);
			}
		}

		if (_GenBeam.length()<1)
		{
			eraseInstance();
			return;
		}

	// get most aligned vecZ
		Sip sip= _Sip[0];
		Vector3d vecX = sip.vecX();	
		Vector3d vecY = sip.vecY();
		Vector3d vecZ = sip.vecZ();
		Point3d ptCen = sip.ptCenSolid();
		CoordSys cs(ptCen-vecZ*.5*sip.dH(), vecX, vecY, vecZ);
		
	// the overall contour and the openings
		PlaneProfile ppAll(cs);
		PLine plOpenings[0];
		for (int i=0;i<_Sip.length();i++) 
		{ 
			Sip sip = _Sip[i]; 
			ppAll.joinRing(sip.plEnvelope(),_kAdd);
			plOpenings.append(sip.plOpenings());
		}		
		
	// contours selection
		if(nMode==0 || nMode==2)
		{
			for (int i=0;i<_Sip.length();i++) 
			{ 
				Sip sip = _Sip[i]; 
				EntPLine epl;
				epl.dbCreate(_Sip[i].plEnvelope());
				epl.setColor(nColor);
				if (!epl.bIsValid())continue;
				entities.append(epl);
			}
		}
	// openings selection
		if(nMode==1 || nMode==2)
		{		
		// pick points in openings	
			String sPrompt = T("|Pick point in opening|");
			PrPoint ssP("\n" + sPrompt + ", " + T("|<Enter> = all openings|")); 
			EntPLine epls[plOpenings.length()]; // the array of jigs corresponds to all openings 
			int nCnt;
			while(1)
			{ 
				
				if (ssP.go()==_kOk) 
				{
				// do the actual query
					Point3d pt = ssP.value(); // retrieve the selected point
					pt.transformBy(vecZ*vecZ.dotProduct(ptCen-pt));
					
				// test point if in any opening	
					for (int o=0;o<plOpenings.length();o++)
					{
						PlaneProfile pp(cs);
						pp.joinRing(plOpenings[o],_kAdd);
					// point is valid
						if (pp.pointInProfile(pt)!=_kPointOutsideProfile)
						{
						// already selected -> deselect
							if (epls[o].bIsValid())
							{
								epls[o].dbErase();
								nCnt--;
							}
							else
							{
								LineSeg seg = pp.extentInDir(vecX);
								PLine pl = plOpenings[o];//(seg.ptStart(), seg.ptEnd());
								EntPLine epl;
								epl.dbCreate(pl);
								epl.setColor(nColor);
								epls[o]=epl;
								nCnt++;
							}	
						}						
					}
					ssP=PrPoint("\n" + sPrompt + ", " + T("|deselect by picking again|")); 
				}
				// no proper selection
				else 
				{ 	
				// all openings
					if (nCnt<1)
					{		
						for (int o=0;o<plOpenings.length();o++)
						{
							EntPLine epl;
							epl.dbCreate(plOpenings[o]);
							epl.setColor(nColor);
							epls[o]=epl;
						}
					}
					break; // out of infinite while
				}	
			}// end do while			
			
		// store openings
			for (int i=epls.length()-1; i>=0 ; i--) 
			{ 
				EntPLine epl=epls[i]; 
				if (!epl.bIsValid())continue;
				entities.append(epl);
			}
		}
	// feed direction
		else if(nMode==3)
		{
		// get potential feeding direction
			Vector3d vecDir = vecY;
			if (sip.subMapXKeys().find("CncData")>-1)
			{
				Map map = sip.subMapX("CncData");
				Vector3d vecRefFeed = map.getVector3d("vecRefFeed");
				if (!vecRefFeed.bIsZeroLength())
				{
					vecDir=	vecRefFeed.crossProduct(-vecZ);
					if (vecDir.isParallelTo(vecX))// swap dX and dY
					{
						vecX = vecY;
						vecY = vecDir;
					}
				}	
			}	

		// get extents of profile
			LineSeg seg = ppAll.extentInDir(vecX);
			double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
			double dY = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));	
			
			reportMessage("\ndX" + dX + " dY" +dY);
			
		// test both sides
			for (int i=0;i<2;i++) 
			{ 
				Point3d pt = seg.ptMid()+vecDir *.5*dY;
			// test profile
				PLine plRec(vecZ);
				LineSeg segRec(pt-vecX*.5*dX-vecY*dEps,pt+vecX*.5*dX+vecY*dEps);
				plRec.createRectangle(segRec, vecX, vecY);
				
				PlaneProfile ppTest(cs);
				ppTest.joinRing(plRec,_kAdd);
				ppTest.intersectWith(ppAll);
				if (ppTest.area() > pow(U(10),2))
				{
					EntPLine epl;
					PLine pl(pt-vecX*.5*dX,pt+vecX*.5*dX);
					epl.dbCreate(pl);
					epl.setColor(nColor);
					if (!epl.bIsValid())continue;
					entities.append(epl);
				}
			// next side
				vecDir*=-1;  
			}
		}
	// pline selection
		else if(nMode==4)
		{
			PrEntity ssE(T("|Select polyline(s) (<Enter> to pick points)|"), EntPLine());
	  		if (ssE.go())
		    	entities= ssE.set();	
		}
	// path mode
		else if(nMode==5)
		{
		// get all rings of multiple panels
			ppAll.shrink(-dEps);
			ppAll.shrink(dEps);
			for (int o=0;o<plOpenings.length();o++) 
			{ 
				PLine plOpening = plOpenings[o]; 
				ppAll.joinRing(plOpening,_kSubtract); 
			}
			PLine plRings[] = ppAll.allRings();
			int bIsOp[] = ppAll.ringIsOpening();

			_Pt0 = getPoint(T("Pick start point"));
			_Pt0.transformBy(vecZ*vecZ.dotProduct(ptCen-_Pt0));
		
		// snap to closest
			double dMin = U(10e4);
			PLine plRing;
			for (int r=0;r<plRings.length();r++)
			{
				Point3d pt = plRings[r].closestPointTo(_Pt0);
				double d = Vector3d(_Pt0-pt).length();
				if(d<dMin)
				{
					dMin=d;
					plRing = plRings[r];
				}
			}
			if (plRing.length()>0)
				_Pt0 = plRing.closestPointTo(_Pt0);
			else
			{
				reportMessage("\n" + scriptName() + ": " +T("|Unexpected error.|"));
				eraseInstance();
				return;
			}
			Point3d ptLast = _Pt0;	
			PrPoint ssP("\n" + T("|Select next point on same ring|"),_Pt0); 
			if (ssP.go()==_kOk) 
			{
			// do the actual query
				ptLast = ssP.value(); // retrieve the selected point
				ptLast.transformBy(vecZ*vecZ.dotProduct(_Pt0-ptLast));
				ptLast = plRing.closestPointTo(ptLast);				
				_PtG.append(ptLast); // append the selected points to the list of grippoints _PtG			
			}
			else
			{
				eraseInstance();
				return;				
			}
				
		// get distAts
			Point3d ptsPick[]={ _Pt0,_PtG[0]};
			double dDists[] = { plRing.getDistAtPoint(_Pt0),plRing.getDistAtPoint(_PtG[0])};
			if (dDists[0]>dDists[1])
			{
				dDists.swap(0,1);
				ptsPick.swap(0,1);
			}				
			double dLength = plRing.length();

		// get vertices of ring
			Point3d pts[] = plRing.vertexPoints(true);	
			
		// collect two plines: clockwise and counter clockwise contour tracking
			PLine plTracks[0];
		// track clockwise
			Point3d ptsTrack[]={ptsPick[0]};
			for (int i=0;i<pts.length();i++) 
			{ 
				Point3d pt = pts[i]; 
				double dDistAt = plRing.getDistAtPoint(pt);
				if (dDistAt<dDists[1] && dDistAt>dDists[0])
					ptsTrack.append(pt);
				else if (dDistAt>=dDists[1] && dDistAt>dDists[0])
				{
					ptsTrack.append(ptsPick[1]);
					break;
				}
			}
			PLine pl(vecZ);
			for (int i=0;i<ptsTrack.length();i++)
				pl.addVertex(ptsTrack[i]);
			plTracks.append(pl);	

		// track counter clockwise
			ptsTrack.setLength(0);
			ptsTrack.append(ptsPick[1]);
		// add points until end of pline	
			for (int i=0;i<pts.length();i++) 
			{ 
				double dDistAt = plRing.getDistAtPoint(pts[i]);
				if (dDistAt>dDists[1] && dDistAt<dLength)
					ptsTrack.append(pts[i]);
			}
		// add points until start	
			for (int i=0;i<pts.length();i++) 
			{ 
				double dDistAt = plRing.getDistAtPoint(pts[i]);
				if (dDistAt<dDists[0] && dDists[0]>dEps)
					ptsTrack.append(pts[i]);
				else if (dDistAt>=dDists[0] || dDists[0]<dEps)
				{
					ptsTrack.append(ptsPick[0]);
					break;
				}	
			}
			pl=PLine(vecZ);
			for (int i=0;i<ptsTrack.length();i++)
				pl.addVertex(ptsTrack[i]);
			plTracks.append(pl);
			
		// start and end point coincide
			EntPLine epl;
			if (Vector3d(ptsPick[0]-ptsPick[1]).length()<dEps)
			{
				epl.dbCreate(plRing);
				epl.setColor(nColor);
			}
		// prompt to swap direction of tracked path	
			else
			{ 
				int bSwap = true;
				while(bSwap)
				{
					if (epl.bIsValid())
						epl.dbErase();
					epl.dbCreate(plTracks[0]);
					epl.setColor(nColor);
					String sInput = getString(T("|Enter to insert accept path or|")+ " " +"[" + T("|SwapDirection|")+"/" +  "]").makeUpper();
					if (sInput.length()>0 && sInput.left(1)==T("|SwapDirection|").makeUpper().left(1))
						plTracks.swap(0,1);
					else
						bSwap=false;
					
				}
			}
			if (epl.bIsValid())
				entities.append(epl);
		}			
	
	// prepare tsl cloning
		TslInst tslNew;
		Vector3d vecXTsl= vecX;
		Vector3d vecYTsl= vecY;
		GenBeam gbsTsl[] = {};gbsTsl=_GenBeam;
		Entity entsTsl[] = {};
		Point3d ptsTsl[] = {};
		int nProps[]={};
		double dProps[]={dChamfer};
		String sProps[]={T("|Polyline|"),sAlignment}; // model is always polyline mode
		Map mapTsl;	
		String sScriptname = scriptName();
			
	// pline mode	
		if (entities.length()>0)
		{
		// insert per selected tool, create one instance per pline
			for (int i=entities.length()-1;i>=0;i--)
			{
				ptsTsl.setLength(0);
				entsTsl.setLength(0);
				Entity ent=entities[i];
				if (!ent.bIsKindOf(EntPLine()))continue;
				EntPLine epl = (EntPLine)ent;
				PLine plDefining = epl.getPLine();
				Point3d pts[] = plDefining.vertexPoints(true);
				if (pts.length()<2)continue;
				
				ptsTsl.append(pts[0]);
				entsTsl.append(ent);	
				tslNew.dbCreate(sScriptname, vecXTsl,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
						nProps, dProps, sProps,_kModelSpace, mapTsl); // create new instance					
			}		
		}
	// pline/point mode
		else if (nMode==4)
		{
			EntPLine epl;
			_Pt0 = getPoint(T("Pick start point"));
			Point3d ptLast = _Pt0;	
			while (1) 
			{
				PrPoint ssP("\n" + T("|Select next point|"),ptLast); 
				if (ssP.go()==_kOk) 
				{
				// delete a potential jig	
					if (epl.bIsValid())epl.dbErase(); 
				// do the actual query
					ptLast = ssP.value(); // retrieve the selected point
					ptLast.transformBy(vecZ*vecZ.dotProduct(_Pt0-ptLast));
					_PtG.append(ptLast); // append the selected points to the list of grippoints _PtG
					
					PLine pl(vecZ);
					pl.addVertex(_Pt0);
					for (int i=0;i<_PtG.length();i++)
						pl.addVertex(_PtG[i]);
					epl.dbCreate(pl);
					epl.setColor(nColor);
				}
				// no proper selection
				else 
				{ 		
					break; // out of infinite while
				}
			}
			ptsTsl.append(_Pt0);
			entsTsl.append(epl);	
			tslNew.dbCreate(sScriptname, vecXTsl,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
					nProps, dProps, sProps,_kModelSpace, mapTsl); // create new instance	
		}		
		eraseInstance();
		return;
	}
// end on insert
//_________________		
	
	
// add entity trigger	
	String sAddTrigger = T("|Add entities|");
	addRecalcTrigger(_kContext, sAddTrigger );
	if (_bOnRecalc && _kExecuteKey==sAddTrigger )
	{
		Entity ents[0] ;
	// declare a prompt	
		PrEntity ssE(T("|Select entities|"), GenBeam());		
		if (ssE.go())
			ents= ssE.set();
		for (int e=0; e<ents.length();e++)
		{
			int n = _GenBeam.find(ents[e]);
			if (n<0) _GenBeam.append((GenBeam)ents[e]);	
		}
	}


// remove entity trigger	
	String sRemoveTrigger = T("|Remove entities|");
	addRecalcTrigger(_kContext, sRemoveTrigger );
	if (_bOnRecalc && _kExecuteKey==sRemoveTrigger )
	{
		Entity ents[0] ;		
	// declare a prompt	
		PrEntity ssE(T("|Select entities|"), GenBeam());
		
		if (ssE.go())
			ents= ssE.set();
		for (int e=0; e<ents.length();e++)
		{
			int n = _GenBeam.find(ents[e]);
			if (n>-1)
				_GenBeam.removeAt(n);	
		}
	}


	
// validate
	if (_GenBeam.length()<1)
	{
		eraseInstance();
		return;	
	}

// set standards
	GenBeam gb = _GenBeam[0];
	Vector3d vecX = gb.vecX();
	Vector3d vecY = gb.vecY();
	Vector3d vecZ = gb.vecZ();
	Point3d ptCen = gb.ptCenSolid();
	double dZ = gb.dH();
	Quader qdr(ptCen, vecX, vecY, vecZ, gb.solidLength(), gb.solidWidth(), gb.solidHeight(),0,0,0);
	

// ints
	int nAlignment = sAlignments.find(sAlignment);	
	int nColor = (nAlignment==1?4:3);
	int nSide = nAlignment==1?1:-1;
	
	sMode.setReadOnly(true);
	
// get the adjacent and opposite side of the right angled chamfer triangle
	double dA = sqrt(pow((dChamfer),2)/2);	

// get defining pline
	EntPLine epl;
	PLine plDefining;
	for (int i=0;i<_Entity.length();i++)
	{
		Entity ent = _Entity[i];
		if (ent.bIsKindOf(EntPLine()))
		{
			epl =(EntPLine)ent;
			plDefining = epl.getPLine();
			setDependencyOnEntity(ent);
			break;
		}	
	}

// auto eraseEntity
	if (plDefining.length()<dEps)
	{
		reportMessage("\n" + scriptName() + ": " +T("|auto erasing|"));
		eraseInstance();
		return;
	}
	

// assigning and color
	assignToGroups(gb,'T');
	epl.assignToGroups(gb,'T');
	if (epl.color()!=nColor)epl.setColor(nColor);


// epl visibility trigger	
	String sKeyVisible = "isVisible";
	int bIsVisible = _Map.hasInt(sKeyVisible)?_Map.getInt(sKeyVisible):true;
	String sVisibilityTrigger = bIsVisible?T("|Hide polyline|"):T("|Show polyline|");
	addRecalcTrigger(_kContext, sVisibilityTrigger);
	if (_bOnRecalc && (_kExecuteKey == sVisibilityTrigger || _kExecuteKey == sDoubleClick) )
	{

	// toggle visibility
		bIsVisible = bIsVisible ? false : true;
		_Map.setInt(sKeyVisible, bIsVisible);

		epl.setIsVisible(bIsVisible);
		setExecutionLoops(2);
		return;
	}	


// filter panels with same normal and collect all edges
	Sip sips[0];
	Body bdEnvelope;
	PLine plOpenings[0];
	//SipEdge edges[0];
	for (int i=0;i<_GenBeam.length();i++) 
	{ 
		Sip sip= (Sip)_GenBeam[i]; 
		if (sip.vecZ().isParallelTo(vecZ))
		{
			sips.append(sip);
			plOpenings.append(sip.plOpenings());
			bdEnvelope.addPart(sip.envelopeBody());
			//edges.append(sip.sipEdges());
		}
	}

	
// specify faces
	Plane pnFaces[0];
	if (nAlignment!=1)
		pnFaces.append(Plane(ptCen-vecZ*.5*dZ, -vecZ));	
	if (nAlignment!=0)
		pnFaces.append(Plane(ptCen+vecZ*.5*dZ, vecZ));

// loop faces
	for (int f=0;f<pnFaces.length();f++) 
	{ 
			
	
		Plane  pn = pnFaces[f]; 
	// get outer profile
		vecX = pn.vecX();
		vecY = pn.vecY();
		vecZ = pn.vecZ();
		
		int bIsReferenceFace =gb.vecZ().isCodirectionalTo(-vecZ);
		
		CoordSys cs(pn.ptOrg(), vecX, vecY, vecZ);
		PlaneProfile ppFace(cs);
		for (int i=0;i<sips.length();i++) 
		{ 
		   ppFace.joinRing(sips[i].plEnvelope(),_kAdd);     
		}
		ppFace.shrink(-dEps);
		ppFace.shrink(dEps);
		int nFace = f==0?1:-1;
		//ppFace.vis(f); 

	// get tooling pline and project to face
		PLine plTool=plDefining;
		plTool.projectPointsToPlane(pn, vecZ);
		//plTool.setNormal(vecZ);
		//plTool.transformBy(vecZ*U(10));
		plTool.vis(2);
	// 
		Point3d pts[] = plTool.vertexPoints(false);
		if (pts.length()<2)continue;
		int bIsClosed = Vector3d(pts[0]-pts[pts.length()-1]).length()<dEps;
		
	// decalre display	
		Display dp(vecZ.isCodirectionalTo(gb.vecZ())?4:3);


	// first segment sets toolside
		int nSide = 1;
		{
		   Point3d pt1= pts[0]; 
		   Point3d pt2= pts[1];
		   Point3d ptMid = (pt1+pt2)/2;
		   Vector3d vecXS = pt2-pt1;
		   vecXS.normalize();
		   Vector3d vecYS = vecXS.crossProduct(-vecZ);
		  
		 // mid point out of outer profile
		 	PlaneProfile ppTest = ppFace;
		 	if(ppTest.pointInProfile(ptMid)==_kPointOutsideProfile)
		 	{
		 		PLine pl;
		 		pl.createConvexHull(pn,ppFace.getGripVertexPoints());
		 		ppTest = PlaneProfile(cs);
		 		ppTest.joinRing(pl, _kAdd);
		 		ptMid=ppTest.closestPointTo(ptMid);
		 		ptMid.vis(1);
		 	}
		 	else
		 		ptMid.vis(3);
		 	if(ppTest.pointInProfile(ptMid+vecYS*dEps)==_kPointInProfile)
		 	{
		 		nSide=-1;	
		 		vecYS*=-1;
		 	}

		 	vecYS.vis(ptMid,nSide);	
		}

		
	// get arcs and and straight segments
		double dBulges[0];
		PLine plArcs[0];
		LineSeg segs[0];
		

		for (int i=0;i<pts.length()-1;i++) 
		{ 
			Point3d pt1 = pts[i]; 
			Point3d pt2 = pts[i+1];
			Point3d ptMid = (pt1+pt2)/2;
			//ptMid.vis(3);

		// test if at opening	
			int bAtOpening;
			for (int o=0;o<plOpenings.length();o++)
			{
				PlaneProfile pp(cs);
				pp.joinRing(plOpenings[o],_kAdd);
				if (pp.pointInProfile(ptMid)==_kPointInProfile)
				{
					bAtOpening=true;
					break;
				}
			}


		// collect straight segments
			PLine pl(pt1,pt2);
			if (plTool.isOn(ptMid))
			{
				segs.append(LineSeg(pt1,pt2));	  	
			}
			
			else
			{
				double d1 = plTool.getDistAtPoint(pt1);pt1.vis(1);
			// pt1 coincides with ptStart
				if (d1==plTool.length())
					d1=0;
				double d2 = plTool.getDistAtPoint(pt2);pt2.vis(2);

				PLine pl(vecZ);
				pl.addVertex(pt1);
				double dDistAt = (d1+d2)/2;
				
			// circles: the last point coincides with the first	
				if (d2==0 && d1>0 && bAtOpening)
					dDistAt = (plTool.length()+d1)/2;
				
				Point3d ptX =plTool.getPointAtDist(dDistAt);	ptX.vis(2);
				
			// get radius
				Point3d ptMid = (pt1+pt2)/2;
				Vector3d vecXS = pt2-pt1;
				double s = vecXS.length();
				vecXS.normalize();
				
				Vector3d vecYH = ptX-ptMid;
				PLine(ptX, ptMid).vis(5);
				double h = vecYH.length();
				vecYH.normalize();
				
				Vector3d vecYS = vecXS.crossProduct(-vecZ);
				int nDir = vecYS.dotProduct(vecYH)<0?1:-1;
				//if (bIsReferenceFace)nDir*=-1;
				
				double r = (4*pow(h,2)+pow(s,2))/(8*h);
				double a = 2 * acos(1-h/r);
				double bulge = tan(nDir*a/4);
				dBulges.append(bulge);
				pl.addVertex(pt1);
				pl.addVertex(pt2,bulge);
				
				if (0 && _bOnDebug)
				{
					Display dp(40);
					dp.draw(PlaneProfile(pl),_kDrawFilled);					
				}

				
				plArcs.append(pl);
			}	
		}

	// get shadow
		PlaneProfile ppShadow=bdEnvelope.shadowProfile(Plane(_Pt0, vecZ));


	// add chamfers as beamcuts
		Vector3d vecXPrev, vecYPrev, vecZPrev, vecXFirst;
		Body bdFirstSegment;
		for (int i=0;i<segs.length();i++) 
		{ 
			LineSeg seg = segs[i];
			Point3d pt1= seg.ptStart(); 
			Point3d pt2= seg.ptEnd();
			Point3d ptMid = seg.ptMid();
			Vector3d vecXT = pt2-pt1;
			vecXT.normalize();
			if (i==0)
				vecXFirst=vecXT;
			Vector3d vecYT = nSide*vecXT.crossProduct(-vecZ);
			vecYT.vis(pt1,nSide); 
			
			double dX = vecXT.dotProduct(pt2-pt1);
			double dY = dChamfer;
			double dZ = dChamfer;	   
			
		// declare symbol 
			PLine plSym(vecXT);
			plSym.addVertex(pt1);
			plSym.addVertex(pt1-vecYT*dA);	
			plSym.addVertex(pt1-vecZ*dA);
			plSym.close();
			
			Vector3d vecZT=vecXT.crossProduct(vecYT);
			CoordSys csRot;
			csRot.setToRotation(-45,vecXT, pt1);
			vecYT.transformBy(csRot);
			vecZT.transformBy(csRot);
		
		// add beamcut
		   if (dX>dEps && dY>dEps && dZ>dEps)
		   {
				vecYT.vis(pt1,3);
				vecZT.vis(pt1,150);
				
				BeamCut bc(pt1,vecXT, vecYT, vecZT,dX, dY,dZ,1,0,0);
				Body bdBc = bc.cuttingBody();
			// store first body for closed contours
				if (i==0 && bIsClosed)
					bdFirstSegment=bdBc;
				//bdBc.vis(i);
				bc.addMeToGenBeamsIntersect(sips); 
				
			// get symbol from slice	
				bdBc.intersectWith(bdEnvelope);
				PlaneProfile ppSym= bdBc.getSlice(Plane(ptMid, vecXT));
				ppSym.transformBy(pt1-ptMid);
				if (ppSym.area()<pow(dEps,2))
			   		ppSym = PlaneProfile(plSym);
			   
			// distribute symbol
				int nNum = dX/U(200);
				if (nNum<3)nNum=3;
				else if (nNum>20)nNum=nNum*4/5;
				double dDist = dX/nNum;
				Point3d ptX=pt1;
				for(int i=0;i<=nNum ;i++)
				{
					Point3d ptX2 = pt1+vecXT*i*dDist;
					ppSym.transformBy(ptX2-ptX);
					ptX=ptX2;
					dp.draw(ppSym, _kDrawFilled);	
				}// next i	  
		   }
		   
		// add mitre solid subtract for inner corners	
			if (!vecXPrev.bIsZeroLength())
			{
				Vector3d vecXMitre = vecXPrev-vecXT;
				vecXMitre.normalize();
				vecXMitre.vis(pt1,6);
				
			// test inner corner
				if (ppShadow.pointInProfile(pt1+vecXMitre*dEps)==_kPointInProfile)
				{
				
					Vector3d vecZMitre = vecXMitre.crossProduct(-gb.vecZ());
					vecZMitre.vis(pt1,f);
				// this segment	
					Body bd1(pt1-vecXT*dA,vecXT, vecYT, vecZT,dX, dY,dZ,1,0,0);
					bd1.addTool(Cut(pt1, vecZMitre),0);
					bd1.vis(f+1);
					SolidSubtract sosu(bd1, _kSubtract);
					sosu.addMeToGenBeamsIntersect(sips); 
				
				// previous segment
					Body bd2(pt1+vecXPrev*dA,vecXPrev, vecYPrev, vecZPrev,dX, dY,dZ,-1,0,0);
					bd2.addTool(Cut(pt1, -vecZMitre),0);
					bd2.vis(f+1);
					SolidSubtract sosu2(bd2, _kSubtract);
					sosu2.addMeToGenBeamsIntersect(sips);				
					
				}
				
			}
		   	vecXPrev = vecXT;
		   	vecYPrev = vecYT;
		   	vecZPrev = vecZT;
		   	
		// add last mitre if closed and applicable   	
			if (i==segs.length()-1 && bIsClosed)
			{
				Vector3d vecXMitre = vecXPrev-vecXFirst;
				vecXMitre.normalize();
				
			// test inner corner
				if (ppShadow.pointInProfile(pt1+vecXMitre*dEps)==_kPointInProfile)
				{
				
					Vector3d vecZMitre = vecXMitre.crossProduct(-gb.vecZ());
					
				// this segment	
					Body bd1(pt2+vecXPrev*dA,vecXPrev, vecYPrev, vecZPrev,dX, dY,dZ,-1,0,0);
					bd1.addTool(Cut(pt2, -vecZMitre),0);
					bd1.vis(2);
					SolidSubtract sosu(bd1, _kSubtract);
					sosu.addMeToGenBeamsIntersect(sips); 
				
				// very first segment
					Body bd2=bdFirstSegment;
					bd2.transformBy(-vecXFirst*dA);
					bd2.addTool(Cut(pt2, vecZMitre),0);
					bd2.vis(2);
					SolidSubtract sosu2(bd2, _kSubtract);
					sosu2.addMeToGenBeamsIntersect(sips);				
					
				}
			}
		   	
		}	

	// add arced chamfers as propeller surfaces
		double dMaximumDeviation = 10*dEps;

//		// get inner profile
		PlaneProfile ppInner=ppFace;
		for (int o=0;o<plOpenings.length();o++) 
		{ 
			ppInner.joinRing(plOpenings[o],_kSubtract); 
			 
		}
		ppInner.shrink(dA);

		for (int a=0;a<plArcs.length();a++) 
		{ 
			PLine arc2 = plArcs[a]; 
			arc2.vis(a);
			Point3d ptsA[] =arc2.vertexPoints(true);
			arc2.transformBy(-vecZ*dA);
			PLine arc1(vecZ);
			
			Point3d pt1= ptsA[0]; 
			Point3d pt2= ptsA[1];
			
			Point3d ptMid = (pt1+pt2)/2;
			Vector3d vecXT = pt2-pt1;
			vecXT.normalize();
			Vector3d vecYT = nSide*vecXT.crossProduct(-vecZ);
			
			arc1.addVertex(ppInner.closestPointTo(pt1));
			arc1.addVertex(ppInner.closestPointTo(pt2),dBulges[a]);
			arc1.vis(2);
			
		// test if at opening	
			int bAtOpening;
			for (int o=0;o<plOpenings.length();o++)
			{
				PlaneProfile pp(cs);
				pp.joinRing(plOpenings[o],_kAdd);
				if (pp.pointInProfile(ptMid)==_kPointInProfile)
				{
					bAtOpening=true;
					break;
				}
			}
			
			
			for (int i=0;i<sips.length();i++) 
			{
				Sip sip = sips[i];
				PropellerSurface ps(arc1, arc2, dMaximumDeviation);
				ps.vis(6);
			// find intersecting plines with beam faces
				PLine pl1=arc2, pl2=arc1;
				if(0)
				{
					Plane pn2(pn.ptOrg()-vecZ*dZ, -vecZ); 
					pn2.vis(4);
					PLine pls[] = ps.intersectWithPlane(pn2, true);
					if (pls.length()!=1) 
					{
					   ; //reportMessage(T("|Intersection with beam face cannot be used. Intersection curves found:| ")+pls.length());
					       //return;
					}
					else
					{
					   pl1 = pls[0];
					   pl1.vis(171);				       	 
					}
				}
				if(0)
				{			
					PLine pls[] = ps.intersectWithPlane(pn, TRUE);
					if (pls.length()!=1) { 			
					    ;//reportMessage(T("|Intersection with beam face cannot be used. Intersection curves found:| ")+pls.length());			
						//return;
					}
					else
					{
						pl2 = pls[0];
											
					}
				}
				//pl1.transformBy(nSide*vecYT*.1*dEps);
				pl1.vis(4);	
				pl2.vis(222);
				dp.draw(pl2);
				PropellerSurfaceTool tt(pl1, pl2, U(40), dMaximumDeviation);
				
				if (!bAtOpening)
				{
					if (bIsReferenceFace)
						tt.setMillSide(_kRight);
					else
						tt.setMillSide(_kLeft);					
				}
				else
				{
					if (bIsReferenceFace)
						tt.setMillSide(_kLeft);					
					else
						tt.setMillSide(_kRight);					
				}
				
				

				//int arNCncMode[] = {_kFingerMill, _kUniversalMill, _kVerticalFingerMill, 3, 4, 5, 6, 7, 8, 9, 10 };
				tt.setCncMode(_kFingerMill);
				sip.addTool(tt); 					
			}	
		}
	}// next f

#End
#BeginThumbnail
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
$H`__V1:R
`



#End