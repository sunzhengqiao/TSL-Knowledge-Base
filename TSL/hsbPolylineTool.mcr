#Version 8
#BeginDescription
detection of closing points of free profile enhanced, this tool is no longer available for sheets

tool type visualisation added 

/// This tsl creates beamcuts or freeprofiles on any genbeam. please note tool path limitations due to the used tool geometry

Version1.4 14-7-2021 Change creation of the freeProfile to use the int for the nSide.  , Author Ronald van Wijngaarden
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
/// <History>
/// <version value="1.3" date="24oct17" author="thorsten.huck@hsbcad.com"> detection of closing points of free profile enhanced, this tool is no longer available for sheets </version>
/// <version value="1.2" date="09jan17" author="thorsten.huck@hsbcad.com"> tool type visualisation added </version>
/// <version value="1.1" date="14dec16" author="thorsten.huck@hsbcad.com"> bugfix fingermill </version>
/// <version value="1.0" date="29july16" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <summary Lang=en>
/// This tsl creates beamcuts or freeprofiles on any genbeam. please note tool path limitations due to the used tool geometry
/// </summary>

/// <insert Lang=en>
/// Select one or multiple genbeams, select a polyline or create a new one by picking points. Alter properties or catalog entry and press OK
/// </insert>

// constants
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));	
	String sDefault =T("|_Default|");
		
// categories
	String sCategoryAlignment = T("|Alignment|");
	String sCategoryCatalogs = T("|Catalog Entries|");	
	String sCategoryDisplay = T("|Display|");	
	String sCategoryDrill = T("|Drill|");	
	String sCategoryGeneral = T("|General|");
	String sCategoryGeometry = T("|Geometry|");
	String sCategoryHatch = T("|Hatch|");
	String sCategoryModel = T("|Model|");	
	String sCategorySink = T("|Sinkhole|");	
	String sCategoryTooling = T("|Tooling|");

// Alignment	
	String sAlignmentName=T("|Alignment|");	
	String sAlignments[] = {T("|Reference Side|"), T("|Opposite Side|")};
	PropString sAlignment(nStringIndex++, sAlignments, sAlignmentName);
	sAlignment.setCategory(sCategoryAlignment );

	String sSideName=T("|Side|");	
	String sSides[] = {T("|Left|"),T("|Center|"),T("|Right|")};
	PropString sSide(nStringIndex++, sSides, sSideName, 1);
	sSide.setCategory(sCategoryAlignment );

// GEOMETRY
	String sDepthName=T("|Depth|");	
	PropDouble dDepth(nDoubleIndex++, U(20), sDepthName);	
	dDepth.setDescription(T("|Defines the Depth|"));
	dDepth.setCategory(sCategoryGeometry );

	String sWidthName=T("|Width|");	
	PropDouble dWidth(nDoubleIndex++, U(30), sWidthName);	
	dWidth.setDescription(T("|Defines the Width|"));
	dWidth.setCategory(sCategoryGeometry );	


// Tool	
	String sToolName=T("|Tool|");	
	String sTools[] = {T("|Beamcut|"), T("|Finger Mill|"), T("|Universal Mill|"), T("|Vertical|") + "-" + T("|Finger Mill|")};
	PropString sTool(nStringIndex++, sTools, sToolName);
	sTool.setCategory(sCategoryTooling );


	int nColor = 3;
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

	// selection
		Entity entities[0];	
		PrEntity ssGb(T("|Select beam(s) or panel(s)|"), Beam());
		ssGb.addAllowedClass(Sip());
  		if (ssGb.go())
	    	entities= ssGb.set();		
		for (int i=0;i<entities.length();i++)
		{
			GenBeam gb = (GenBeam)entities[i];
			if (gb.bIsValid() && !gb.bIsDummy())
				_GenBeam.append(gb);
		}

		if (_GenBeam.length()<1)
		{
			eraseInstance();
			return;
		}

	// get most aligned vecZ
		GenBeam gb = _GenBeam[0];
		Quader qdr(gb.ptCenSolid(), gb.vecX(), gb.vecY(), gb.vecZ(), gb.solidLength(), gb.solidWidth(), gb.solidHeight(),0,0,0);
		Vector3d vecZ = qdr.vecD(_ZU);

	// optional polyline selection
		PrEntity ssE(T("|Select polyline(s) (<Enter> to pick points)|"), EntPLine());
  		if (ssE.go())
	    	entities= ssE.set();	
	
	// prepare tsl cloning
		TslInst tslNew;
		Vector3d vecXTsl= qdr.vecD(_XU);
		Vector3d vecYTsl= qdr.vecD(_YU);
		GenBeam gbsTsl[] = {};gbsTsl=_GenBeam;
		Entity entsTsl[] = {};
		Point3d ptsTsl[] = {};
		int nProps[]={};
		double dProps[]={dDepth,dWidth};
		String sProps[]={sAlignment,sSide,sTool};
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
	// point mode
		else
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
	Quader qdr(ptCen, vecX, vecY, vecZ, gb.solidLength(), gb.solidWidth(), gb.solidHeight(),0,0,0);

	

// ints
	int nAlignment = sAlignments.find(sAlignment);
	int nSide = sSides.find(sSide)-1;
	int nTool = sTools.find(sTool)-1;  // shift one index to keep _kFingerMill=0,_kUniversalMill=1,_kVerticalFingerMill=2;
	if (nTool<-1)
	{
		sTool.set(sTools[0]);
		setExecutionLoops(2);
	}
	nColor = (nAlignment==0?3:4);
	int bFreeProfile=nTool>-1;

// TriggerFlipSide
	String sTriggerFlipSide = T("|Flip Alignment|");
	addRecalcTrigger(_kContext, sTriggerFlipSide );
	if (_bOnRecalc && (_kExecuteKey==sTriggerFlipSide || _kExecuteKey==sDoubleClick))
	{
		if (sAlignment==sAlignments[0]) sAlignment.set(sAlignments[1]);
		else if (sAlignment==sAlignments[1]) sAlignment.set(sAlignments[0]);
	// flip side when alignment changes	
		nSide*=-1;
		if (abs(nSide)==1)
			sSide.set(sSides[nSide+1]);		
		setExecutionLoops(2);
		return;
	}


// on the event of changing the alignment
	if (_kNameLastChangedProp == sAlignmentName)
	{
	// flip side when alignment changes	
		nSide*=-1;
		if (abs(nSide)==1)
			sSide.set(sSides[nSide+1]);
		setExecutionLoops(2);
		return;
	}

	
	
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

// assigning and color
	assignToGroups(gb,'T');
	epl.assignToGroups(gb,'T');
	if (epl.color()!=nColor)epl.setColor(nColor);
	CoordSys csPLine = plDefining.coordSys();



// tool coordSys
	Vector3d vecXT, vecYT, vecZT;
	vecXT = qdr.vecD(csPLine.vecX());
	vecYT = qdr.vecD(csPLine.vecY());
	vecZT = qdr.vecD(csPLine.vecZ());

// override tool coordSys if sip or sheet in main plane
	if(!gb.bIsKindOf(Beam()) && vecZT.isParallelTo(vecZ))
	{
		vecXT = -vecX;
		vecYT = vecY;
		vecZT = -vecZ;		
	}

	
// adjust to alignmnet
	if (nAlignment==1)
	{
		vecXT*=-1;
		vecZT*=-1;	
	}	
	vecXT.vis(csPLine.ptOrg(),1);
	vecYT.vis(csPLine.ptOrg(),3);
	vecZT.vis(csPLine.ptOrg(),150);	

	double dToolDepth = (dDepth<=0?qdr.dD(vecZT):dDepth);
	if(bDebug)reportMessage("\n"+ scriptName() + " tool depth is " + dToolDepth);

// get tooling pline and project to face
	PLine plTool=plDefining;
	Plane pnFace(ptCen+vecZT*.5*qdr.dD(vecZT), vecZT);
	plTool.projectPointsToPlane(pnFace, vecZT);
	plTool.vis(2);

	PLine plFreeProfile = plTool;
	plTool.convertToLineApprox(dEps);
	Point3d pts[] = plTool.vertexPoints(false);
	if (pts.length()<2)
	{
		reportMessage("\n" + scriptName() + " " + T("|invalid polyline shape.|") + T("|Tool will be deleted.|"));
		eraseInstance();
		return;	
	}
	int bIsClosed = (pts[0]-pts[pts.length()-1]).length()<dEps;
	_Pt0 = pts[0];



	
// get the tool shadow	
	PlaneProfile ppShadow(CoordSys(_Pt0, vecXT, vecYT, vecZT));
	PLine plHull;
	plHull.createConvexHull( pnFace, pts);
	ppShadow.joinRing(plHull,_kAdd);
	ppShadow.shrink(-U(500));
	ppShadow.vis(2);	
// do not use any free profile if the defining line appears to be just a straight segment	
	if(ppShadow.area()< pow(dEps,2) && bFreeProfile) bFreeProfile=false;

// transform defining pline
	{
		double d = vecZT.dotProduct(_Pt0-csPLine.ptOrg());
		if (abs(d)>dEps)
		{
			epl.transformBy(vecZT*d);
			setExecutionLoops(2);	
		}
	}	
	


	
// now create a solid subtract for the free profile or apply beamcuts if in beamcut mode	
	Vector3d vecX1, vecSide;
	double dOffset = dWidth/2;
	double dOffset2 = dWidth/2*nSide;
// collect offseted points along contour	
	Point3d ptsA[0], ptsB[0];
	Vector3d vecsX[0],vecsY[0];
	for (int p=0;p<pts.length()-1;p++)
	{
		Vector3d vxSeg = pts[p+1]-pts[p];	
		vxSeg.normalize();
		Vector3d vecYSeg = vxSeg.crossProduct(-vecZT);
		vecsX.append(vxSeg);
		vecsY.append(vecYSeg);
		
		if (p==0)
		{
			vecSide = vecYSeg;
			if (nSide!=0) vecSide*=nSide;
			vecSide.vis(_Pt0,3);
			ptsA.append(pts[p]+vecYSeg*(dOffset+dOffset2));
			ptsB.append(pts[p]-vecYSeg*(dOffset-dOffset2));	
		}
		else
		{
			Vector3d vecMitre = vecX1-vxSeg;
			vecMitre.normalize();
			Vector3d vecMitreZ = vecMitre.crossProduct(vecZT);
			Plane pn(pts[p],vecMitreZ);
			//pn.vis(2);
			ptsA.append(Line(ptsA[ptsA.length()-1], vecX1).intersect(pn,0));
			ptsB.append(Line(ptsB[ptsB.length()-1], vecX1).intersect(pn,0));			
		}
		
		if (p==pts.length()-2)
		{
			ptsA.append(pts[p+1]+vecYSeg*(dOffset+dOffset2));
			ptsB.append(pts[p+1]-vecYSeg*(dOffset-dOffset2) );	
		}
		
		vecX1 = vxSeg;
	}

// set varias
	double dY = dWidth;
	double dZ = dToolDepth*2;

	
// a set of four points defines the outline of one segment
	PlaneProfile ppSegs[0], ppBoxes[0];
	for (int p=0;p<ptsA.length()-1;p++)
	{
		if (ptsB.length()-1<p)continue;
		
		//ptsA[p].vis(1);
		Point3d ptsC[0];
		ptsC.append(ptsA[p]);
		ptsC.append(ptsA[p+1]);
		ptsC.append(ptsB[p]);
		ptsC.append(ptsB[p+1]);
		PLine plC;
		plC.createConvexHull(pnFace, ptsC);
		//plC.vis(p);

		PlaneProfile pp(plC);
		ppSegs.append(pp);
		
		LineSeg seg=pp.extentInDir(vecsX[p]);
		PLine plRec;
		plRec.createRectangle(seg, vecsX[p],vecsY[p]);
		ppBoxes.append(PlaneProfile(plRec));
	}	

// loop all profiles and intersect with previous and next to obtain beamcut shortening
	if (nTool!=1)
	{ 
		Line lnLast;
		for (int p = 0; p < ppBoxes.length(); p++)
		{
			Vector3d vxSeg, vySeg;
			vxSeg = vecsX[p];
			vySeg = vecsY[p];
			
			
			
			PlaneProfile ppThis = ppBoxes[p];
			ppThis.vis(p);
			LineSeg seg = ppThis.extentInDir(vxSeg);
			Point3d ptMid = seg.ptMid();
			double dX = abs(vxSeg.dotProduct(seg.ptStart() - seg.ptEnd()));
			Line lnThis = Line(ptMid, vxSeg);
			Plane pnY(ptMid,vySeg);
			// get profiles and angle to previous/next segment
			double dAngleStart, dAngleEnd;
			PlaneProfile ppPrev, ppNext;
			if (p > 0)
			{
				ppPrev = ppSegs[p - 1];
				dAngleStart = vecsX[p - 1].angleTo(vecsX[p]);
			}
			if (p < ppSegs.length() - 1)
			{
				ppNext = ppSegs[p + 1];
				dAngleEnd = vecsX[p].angleTo(vecsX[p + 1]);
			}
			//dp.draw(dAngleStart+"/"+dAngleEnd,seg.ptMid(), vx,vy,0,0,_kDevice);
			//ppSegs[p].vis(p);
			
			ppThis.subtractProfile(ppSegs[p]);
			//if (p>35)ppThis.vis(p);
			ppThis.subtractProfile(ppPrev);
			ppThis.subtractProfile(ppNext);
			if (0 && p == 36)
			{
				ppPrev.vis(1);
				ppThis.vis(p + 1);
			}
			
			
			// the result of the intersection should have max 2 rings, shorten and offset the beamcut length
			PLine plRings[] = ppThis.allRings();
			int bIsOp[] = ppThis.ringIsOpening();
			int n;
			for (int r = 0; r < plRings.length(); r++)
			{
				if (bIsOp[r] || n > 1)continue;
				LineSeg segX = PlaneProfile(plRings[r]).extentInDir(vxSeg);//segX.vis(6);
				double dSub = abs(vxSeg.dotProduct(segX.ptStart() - segX.ptEnd()));
				
				if (dSub > dEps)
				{
					int nDir = 1;
					if (vxSeg.dotProduct(segX.ptMid() - ptMid) < 0)
					{
						nDir *= -1;
					}
					
					// perform shortening/offset only for angles >90°
					// this test is required for arced segments with the side not being centered. else it could lead into open triangles
					int bOk = true;
					if (nDir == -1 && dAngleStart <= 90) bOk = false;
					else if (nDir == 1 && dAngleEnd <= 90) bOk = false;
					
					if (bOk)
					{
						dX -= dSub;
						ptMid.transformBy(-vxSeg * nDir * .5 * dSub);
					}
				}
				n++;
			}
			
			// add beamcut
			if (dX > dEps && dY > dEps && dZ > dEps)
			{
				if (bFreeProfile)
				{
					Vector3d vecZ = vxSeg.crossProduct(vySeg);
					SolidSubtract sosu(Body(ptMid, vxSeg, vySeg, vecZ, dX, dY, dZ, 0, 0, 0), _kSubtract);
					sosu.cuttingBody().vis(4);
					
					sosu.addMeToGenBeamsIntersect(_GenBeam);
					
					// TODO add capsule
//					if (p > 0)
//					{
//						Point3d ptCapsule;
//						if (lnLast.hasIntersection(pnY, ptCapsule))
//						{
//							ptCapsule.vis(2);
//							Body bdCaps(ptCapsule - vecZ * .5 * dZ, ptCapsule + vecZ * .5 * dZ, dY * .5);
//							bdCaps.vis(40);;
//						}
//					}
					
				}
				else
				{
					BeamCut bc(ptMid, vxSeg, vySeg, vxSeg.crossProduct(vySeg), dX, dY, dZ, 0, 0, 0 );
					//bc.cuttingBody().vis(p);
					//gb.addTool(bc);
					bc.addMeToGenBeamsIntersect(_GenBeam);
				}
			}
			lnLast = lnThis;
		}
	}

// apply freeprofile
	if(bFreeProfile)
	{
	// get vecs at extremes to collect closing points
		Point3d ptsClose[0];
		
		if (!bIsClosed)
		{
			Vector3d vecs[0], vecPerp, vecDir;
			Point3d ptsX[] = {plFreeProfile.ptStart(),plFreeProfile.ptEnd()};
			for(int i=0;i<ptsX.length();i++)
			{
				Point3d ptEnd = ptsX[i];
				Point3d ptNext2End = plFreeProfile.getPointAtDist(dEps);
				if (i==1)
					ptNext2End = plFreeProfile.getPointAtDist(plFreeProfile.length()-dEps);
				vecPerp = ptsX[i]-ptNext2End; vecPerp.normalize();
				vecPerp.vis(ptEnd ,i);
				vecDir = vecPerp.crossProduct(-vecZT);
				if (i==0) vecDir*=-1;
				if (nSide<0)vecDir*=-1;
				vecDir.vis(ptEnd ,i);
	
				LineSeg segs[] = ppShadow.splitSegments(LineSeg(ptEnd +vecDir*U(10e4),ptEnd -vecDir*U(10e4)), true);
				Point3d pts[0];
				for(int j=0;j<segs.length();j++)
				{
					segs[j].vis(6+j);
					pts.append(segs[j].ptStart());
					pts.append(segs[j].ptEnd());
				}

				Line ln(ptEnd ,- vecDir);
				pts=ln.orderPoints(pts);
				
			// test if self intersecting
				Point3d ptsSelf[] = ln.orderPoints(plFreeProfile.intersectPoints(Plane(ptEnd, vecPerp)));
				if (ptsSelf.length()>0)
				{ 
					double d1 = vecDir.dotProduct(ptsSelf[0] - ptEnd);
					if (d1>dEps)
						for(int j=0;j<pts.length();j++)
						{
							double d2 = vecDir.dotProduct(pts[j] - ptEnd);
							if (d2<d1)
							{ 
								ptsClose.append(pts[j]);
								pts[j].vis(4);
								break;
							}		
						}
					else
						ptsClose.append(pts[0]);
				}
				else if (pts.length()>0)
				{ 
					ptsClose.append(pts[0]);	
				}
				
//				for(int j=0;j<ptsSelf.length();j++)
//					ptsSelf[j].vis(j);
//
//				for(int j=0;j<pts.length();j++)
//					pts[j].vis(6);
				
			}
		// swap if first is closer to end
			if (ptsClose.length()==2 && (ptsClose[0]-ptsX[1]).length()>(ptsClose[1]-ptsX[1]).length())	
				ptsClose.swap(0,1);
		}
		else	
			ptsClose.append(plFreeProfile.ptEnd());



	
		for(int i=0;i<ptsClose.length();i++)
			ptsClose[i].vis(i);
		
		FreeProfile fp(plFreeProfile ,_kCenter);//);
		fp.setDepth(dToolDepth );
	// do solid for universal mill	
		if (nTool!=1)	
			fp.setDoSolid(false);
		for (int i=0;i<_GenBeam.length();i++) 
		{ 
			_GenBeam[i].addTool(fp); 
			 
		}
		
		
		//fp.addMeToGenBeamsIntersect(_GenBeam);	
	}

// visualize tool along the path of the pline
	PLine pl(vecZT);
	pl.createCircle(_Pt0, vecZT,U(10));
	PlaneProfile pp(pl);
	pl.createCircle(_Pt0, vecZT,U(8));
	pp.joinRing(pl,_kSubtract);
	Display dp(nColor);
	dp.addHideDirection(vecXT);
	dp.addHideDirection(-vecXT);
	dp.addHideDirection(vecYT);
	dp.addHideDirection(-vecYT);

	Display dpTool(nTool+2);
	PlaneProfile ppT(pl);
	pl.createCircle(_Pt0, vecZT,U(6));
	ppT.joinRing(pl,_kSubtract);
	
	dpTool.addHideDirection(vecXT);
	dpTool.addHideDirection(-vecXT);
	dpTool.addHideDirection(vecYT);
	dpTool.addHideDirection(-vecYT);

	double dL = plDefining.length();
	int nNum = dL/U(200);
	if (nNum<3)nNum=3;
	else if (nNum>20)nNum=nNum*4/5;
	double dDist = dL/nNum;
	Point3d pt1=_Pt0;
	for(int i=0;i<=nNum ;i++)
	{
		Point3d pt2 = plDefining.getPointAtDist(i*dDist);
		pp.transformBy(pt2-pt1);
		ppT.transformBy(pt2-pt1);
		pt1=pt2;
		dp.draw(pp, _kDrawFilled);	
		dpTool.draw(ppT, _kDrawFilled);	
		dp.draw(plTool);	
		dpTool.draw(plTool);	
	}// next i
	
	


#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`$L`9`#`2(``A$!`Q$!_\0`
M'P```04!`0$!`0$```````````$"`P0%!@<("0H+_\0`M1```@$#`P($`P4%
M!`0```%]`0(#``01!1(A,4$&$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*
M%A<8&1HE)B<H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&EJ<W1U
M=G=X>7J#A(6&AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&
MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ>KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!
M`0$!`0````````$"`P0%!@<("0H+_\0`M1$``@$"!`0#!`<%!`0``0)W``$"
M`Q$$!2$Q!A)!40=A<1,B,H$(%$*1H;'!"2,S4O`58G+1"A8D-.$E\1<8&1HF
M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@H.$
MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#W^BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BJDVI65O?VUA-<QI=W6[R82WS/M
M!)('H`.M6Z`"BBB@`HHHH`***J6.I66II,]C<QW"0RF&1HSD!QC(S[9%`%NB
MBB@`HHHH`****`"BBB@`HHHH`**:S*B%G8*H&22<`4D<B2QK)&=R,,J?44`/
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHKC/''BK^RK8Z?92?Z;*/G8?\LE/]3V_/TK*M6C1@YR-\/AYXBHJ<-V
M0Z]\0X]-U&2SL;9+GR^'D+X&[N!ZXKGKWXIZI#`T@MK.-1T^5B?YURMI:SWM
MU';6T;232-A5'4US6L_:(]3GM+A#&]O(T90]B#@UX4,5B:TF[V7]:'UU/+,'
M32@XIR\_S/H;P1X@?Q+X8@OY]GVC>\<P08`8'C_QTJ?QK4UNZELM`U&[@(6:
M"UED0D9`95)'\J\H^"^K^5J%_H[M\LR">('^\O##\01_WS7J/B;_`)%36/\`
MKQF_]`->[AY<\$SY;,:'L,1**VW7S/GSX7:C>:K\7-/O+^YDN;F03%Y)&R3^
MZ?\`3VKZ8KY&\!^(+7PMXOL]8O(II8(%D#)"`6.Y&48R0.I'>O3;G]H)!,1:
M^'6:+LTMWM8_@%./SKMJP<I:(\BC4C&/O,]LHKA_!'Q.TKQI,UFD,EEJ"KO^
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
G`<G<6.NZIM6Y5%13D`E0!^7-=+9PM;6,$#D%HXPI(Z<"IZ*`/__9
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
    <lst nm="Version">
      <str nm="Comment" vl="Change creation of the freeProfile to use the int for the nSide. " />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="7/14/2021 2:21:42 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End