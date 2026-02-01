#Version 7
#BeginDescription







#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#MajorVersion 1
#MinorVersion 4
#KeyWords 
#BeginContents
// basics and props
	U(1,"mm");
	String sArNY[] = { T("No"), T("Yes")};
	//PropInt nXX(0, 0, T("Int"));
		
	PropString sPartStart(3, "", T("|Additional part|") + " " + T("|Start|"));	
	PropString sPartEnd(4, "", T("|Additional part|") + " " + T("|End|"));	
		
	PropString sGroup(1,"",T("|Auto group tsl|"));	
	sGroup.setDescription(T("|Determines the third level group of the tsl (seperate level by '\')|"));	
	PropString sAllowEdit(2, sArNY, T("|Grip edit|"));	
	PropString sDimStyle(0,_DimStyles,T("Dimstyle"));
	
	setExecutionLoops(1);	
// on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		showDialog();	
		//get roofelement sset	
		ERoofPlane er[0];
		PrEntity ssRP(T("|Select 2 roofplanes|"), ERoofPlane());
		while(1 && er.length() < 2)
  			if (ssRP.go())
			{
				Entity ents[] = ssRP.set();
				for (int i = 0; i < ents.length(); i++)
				{
					ERoofPlane erp = (ERoofPlane) ents[i];
					if (er.find(erp) < 0)
						er.append(erp);	
				}
			}
			else
				break;
				
		if (er.length() > 1)
		{
		// declare standards and collect plines
			CoordSys cs[0];
			Vector3d vx[0],vy[0],vz[0];
			Point3d ptOrg[0];
			PLine pl[0];

			for (int i = 0; i < er.length(); i++){
				cs.append(er[i].coordSys()); 
				ptOrg.append(cs[i].ptOrg());
				vx.append(cs[i].vecX());
				vy.append(cs[i].vecY());
				vz.append(cs[i].vecZ());
				pl.append(er[i].plEnvelope());
				_Entity.append(er[i]);
			}
			
		// analyze erp	
			LineSeg ls[0];
			//loop both planes
			for (int i = 0; i < 2; i++)
			{
				Point3d pts[] = pl[i].vertexPoints(FALSE);
				for (int p = 0; p < pts.length()-1; p++)
				{
					LineSeg lsTmp = LineSeg(pts[p], pts[p+1]);
				
					// the coordSys of the segment
					Vector3d vxRL = pts[p+1]-pts[p];
					vxRL.normalize();
					// swap if pointing downwards
					if (vxRL.dotProduct(_ZW) < 0)
						vxRL *=-1;	
					Vector3d  vyRL = vz[0].crossProduct(vxRL);
					Vector3d  vzRL = vxRL.crossProduct(vyRL);
								
					// check if segment is in same plane
					int e = 1;
					if (i == 1) e = 0;
					if ((abs(vz[e].dotProduct(ptOrg[e] - lsTmp.ptMid())) < U(0.1)))
					{	
						// build a tiny pp at segment and check intersection with pp of erp
						PlaneProfile ppTest(CoordSys(ptOrg[e], vx[e], vy[e], vz[e]));
						Vector3d vyE = vxRL.crossProduct(vz[e]);
						PLine plTest(vz[e]);
						plTest.createRectangle(LineSeg(lsTmp.ptStart() - vyE * U(1), lsTmp.ptEnd() + vyE * U(1)), vxRL, vyE);
						//	plTest.vis(i);
						if (ppTest.intersectWith(PlaneProfile(pl[i])))
						{
							ls.append(lsTmp);
							break;
						}
					}			
				}// next p	
				
						
			}// next i
			
			// use shortest common linseg
			if (ls.length() > 1)
			{
				Vector3d vxRL = ls[0].ptEnd()-ls[0].ptStart();
				vxRL.normalize();
				// swap if pointing downwards
				if (vxRL.dotProduct(_ZW) < 0)
					vxRL *=-1;
				Vector3d vyE = vxRL.crossProduct(vz[0]);
				PLine plRec(vz[0]);
				plRec.createRectangle(LineSeg(ls[0].ptStart() - vyE * U(1), ls[0].ptEnd() + vyE * U(1)), vxRL, vyE);
				PlaneProfile  ppLs0(CoordSys(ptOrg[0], vx[0], vy[0], vz[0]));
				ppLs0.joinRing(plRec,_kAdd);
				plRec = PLine(vz[0]);
				plRec.createRectangle(LineSeg(ls[1].ptStart() - vyE * U(1), ls[1].ptEnd() + vyE * U(1)), vxRL, vyE);
				PlaneProfile  ppLs1(CoordSys(ptOrg[0], vx[0], vy[0], vz[0]));
				ppLs1.joinRing(plRec,_kAdd);			
				ppLs0.intersectWith(ppLs1);
				
				LineSeg lsTmp = ppLs0.extentInDir(vxRL);
				double dLX = abs(vxRL.dotProduct(lsTmp.ptStart() - lsTmp.ptEnd()));
				
				_Pt0 = lsTmp.ptMid() - vxRL * 0.5 * dLX;
				_PtG.append(lsTmp.ptMid() + vxRL * 0.5 * dLX);
				_Map.setPoint3d("pt0", _Pt0,_kAbsolute);
				_Map.setPoint3d("pt1", _PtG[0],_kAbsolute);			
			}
		}// endif 2 erps
	
		// delete
		if (_PtG.length() <1)
			eraseInstance();

  		return;
	
	}	
//end on insert________________________________________________________________________________

// Display 
	Display dpPlan(1), dp(1);
	dpPlan.dimStyle(sDimStyle);
	dpPlan.addViewDirection(_ZW);
	dp.addHideDirection(_ZW);
	//dpPlan.draw(scriptName(),_Pt0, _XW,_YW,0,0);
	double dTxtH = dpPlan.textHeightForStyle("O", sDimStyle);

// jig mode - will terminate after jig show
	if (_Map.getInt("isJig") == TRUE)
	{
		if (_Map.hasPLine("pl0"))
		{
			Hatch hatch("Net", U(10));
			dpPlan.draw(_Map.getPLine("pl0"));
			dpPlan.draw(PlaneProfile(_Map.getPLine("pl0")),hatch);		
		}
		else
			eraseInstance();
		return;
	}

// delete
	if (_PtG.length() <1)
	{
		eraseInstance();
		return;
	}
	
// Group
	if (sGroup != "")
	{
		Group gr();
		gr.setName(sGroup);
		String s3Group = gr.namePart(2);
		// make sure user has given 3rd level group
		if (s3Group != "")
		{
			s3Group = gr.namePart(0) + "\\" + gr.namePart(1) + "\\" + s3Group;
			gr.setName(s3Group);
			gr.addEntity(_ThisInst, TRUE);
		}
	}
	
// ints
	int nAllowEdit = sArNY.find(sAllowEdit);
	
// get erps
	ERoofPlane er[0];
	Entity ents[0];
	ents = _Entity;
	for (int i = 0; i < ents.length(); i++)
		if (ents[i].bIsKindOf(ERoofPlane()))
			er.append((ERoofPlane)ents[i]);	
	
// not enough erps
	if (er.length() < 2)
	{
		reportNotice("\n*****************************************************************\n" + 
			scriptName() + ": " + T("Incorrect user input.") + "\n" + 
			T("|This tsl needs 2 roofplanes|") + "\n" + 
		"*****************************************************************");
		eraseInstance();
		return;	
	}	

// location of roofline
	Point3d pt0[0];

	pt0.append(_Map.getPoint3d("pt0"));
	pt0.append(_Map.getPoint3d("pt1"));
	pt0[0].vis(1);
	pt0[1].vis(2);
	
// sort erps
	Point3d ptMid;
	ptMid.setToAverage(pt0);
	PlaneProfile ppTest(er[0].plEnvelope());
	if (ppTest.pointInProfile(ptMid + er[0].coordSys().vecX() * U(1)) != _kPointOutsideProfile)	// swap
		er.swap(0,1);
	
// declare standards and collect plines
	CoordSys cs[0];
	Vector3d vx[0],vy[0],vz[0];
	Point3d ptOrg[0];
	PLine pl[0];

	for (int i = 0; i < er.length(); i++){
		
		
		cs.append(er[i].coordSys()); 
		ptOrg.append(cs[i].ptOrg());
		pl.append(er[i].plEnvelope());
		Point3d ptM;
		ptM.setToAverage(pl[i].vertexPoints(TRUE));		
		
		vx.append(cs[i].vecX());
		vy.append(cs[i].vecY());								
		vz.append(cs[i].vecZ());								vz[i].vis(ptM,i);
		//vx[i].vis(_Pt0,1);
		//vy[i].vis(_Pt0,3);

		
	}
	
// check valley
	Vector3d vCheck = vz[0].crossProduct(vz[1]);
	vCheck.normalize();
	// check mitre type valley = -1, ridge = 0; hip = 1
	int nMitre;
	if (_ZW.isPerpendicularTo(vCheck))
		nMitre = 0;
	else if (_ZW.dotProduct(vCheck) < 0)
		nMitre = -1;
	else
		nMitre = 1;
	vCheck.vis(ptMid, nMitre + 2);	



// add triggers
	String sTrigger[] = {T("|Update|"), T("|append roof laths|"),T("|append roof elements|"), "_________________",
		T("|delete tiles|"),T("|add tiles|"),T("|modify tile|")};
	for (int i = 0; i < sTrigger.length(); i++)
		addRecalcTrigger(_kContext, sTrigger[i]);

// trigger0: update
	if (_bOnRecalc && _kExecuteKey==sTrigger[0]) 
	{
	 	reportMessage("\n" + T("|Updating|" + " " + scriptName() + "..."));
	}
// trigger1: append laths
	if (_bOnRecalc && _kExecuteKey==sTrigger[1]) 
	{
		PrEntity ssE(T("|Select a set of laths|"), Beam());
  		if (ssE.go()) 
		{
    		Beam bm[] = ssE.beamSet();
			for(int i = 0; i < bm.length();i++)
			{
				_Beam.append(bm[i]);
				_GenBeam.append((GenBeam)bm[i]);
			}
		}
	}
// trigger3: append elements
	if (_bOnRecalc && _kExecuteKey==sTrigger[2]) 
	{
		PrEntity ssE(T("|Select a set of element(s)|"), ElementRoof());
  		if (ssE.go()) 
    		_Element.append(ssE.elementSet());
	}

// get laths
	GenBeam gb[0];
	//... from element
	for (int i = 0; i < _Element.length(); i++)	
	{
		_Element[i].ptOrg().vis(i);
		gb.append(_Element[i].genBeam(5));	
		
	}

	//... from roof lathes
	for (int i = 0; i < _GenBeam.length(); i++)
		if (_GenBeam[i].type() == _kLath)
			gb.append(_GenBeam[i]);

// get elements
	Element el[0];
	el = _Element;			

// find intersection by planes of lathes
	int bTilePlaneFound = FALSE;
	Plane pnTile[0];
	
	for (int i = 0; i < 2; i++)
	{	
		PlaneProfile ppEr(CoordSys(ptOrg[i], vx[i], vy[i], vz[i]));
		ppEr.joinRing(pl[i],_kAdd);
		
		// ...from element
		for (int e = 0; e < el.length(); e++)
		{
			// check orientation
			Point3d ptOrgEl;
			Vector3d vxEl,vyEl,vzEl;
			ptOrgEl = el[e].ptOrg();	
			vxEl=el[e].vecX();
			vyEl=el[e].vecY();
			vzEl=el[e].vecZ();
			if (vx[i].isParallelTo(vxEl) && vy[i].isParallelTo(vyEl) && vz[i].isParallelTo(vzEl) &&
				ppEr.pointInProfile(el[e].plEnvelope().ptMid()) != _kPointOutsideProfile &&
				pnTile.length() < i+1)
			{
				Plane pn(el[e].zone(5).ptOrg() + el[e].vecZ() * el[e].zone(5).dH(), el[e].vecZ());
				pnTile.append(pn);
				break;
			}
		}// next e
		
	//... from lath
	// handle not used yet
		if (pnTile.length() < i+1)
			for (int b = 0; b < gb.length();b++)
			{
				if (vx[i].isParallelTo(gb[b].vecX()) && vy[i].isParallelTo(gb[b].vecD(vy[i])) && vz[i].isParallelTo(gb[b].vecD(vz[i])) &&
					ppEr.pointInProfile(gb[b].ptCen()) != _kPointOutsideProfile)
				{
					Plane pn(gb[b].ptCen() + 0.5 * vz[i]* gb[b].dD(vz[i]), vz[i]);
					pnTile.append(pn);
					break;
				}	
			}// next b
	}// next i
	

// relocate 	
	double dOff[0];		
	Line ln(pt0[0],pt0[1] - pt0[0]);	
	if (pnTile.length() > 1)	
	{
		bTilePlaneFound = pnTile[0].hasIntersection(pnTile[1]);
		if (bTilePlaneFound)
		{
			ln = pnTile[0].intersect(pnTile[1]);
			_Pt0 = ln.closestPointTo(_Pt0);
			_PtG[0] = ln.closestPointTo(_PtG[0]);
			dOff.append(vz[0].dotProduct(_Pt0 - ptOrg[0]));
			dOff.append(vz[1].dotProduct(_PtG[0] - ptOrg[1]));
		}	
	}

// find adjacent plane at pt0
	int nIndex[] = {0,1};
	for (int i = 0; i < pt0.length(); i++)
	{
		int bIsGableEnd = TRUE;
		Vector3d vxLn = pt0[nIndex[1]] - pt0[nIndex[0]];		vxLn.normalize();	vxLn.vis(pt0[i],2);		
		Vector3d vyLn = vxLn.crossProduct(-_ZW);					vyLn.normalize();	vyLn.vis(pt0[i],3);	
		Vector3d vxAd, vzAd;
		for (int e = 0; e < er.length(); e++)
		{
			Point3d pts[] = pl[e].vertexPoints(FALSE);
			for (int p = 0; p < pts.length()-1; p++)
			{
				PLine plSeg(pts[p], pts[p+1]);	
				plSeg.transformBy(vxLn * U(5));
				plSeg.vis(e);
				plSeg.transformBy(-vxLn * U(5));
				if (plSeg.isOn(pt0[nIndex[0]]) && !plSeg.isOn(pt0[nIndex[1]]))
				{
					
					Vector3d vxTmp(pts[p+1] - pts[p]);		vxTmp.normalize();		
					if (vxTmp.dotProduct(_ZW) < 0)
						vxTmp*= -1;
					vxAd += vxTmp;							vxAd.normalize();
					bIsGableEnd = FALSE;	
				}
			}		
		}	
		vxAd.vis(pt0[i],i);
		vzAd = vxAd.crossProduct(vyLn);	vzAd.normalize();
		
		if (_ZW.dotProduct(vzAd)<0)
			vzAd *= -1;
		vzAd.vis(pt0[i],i);	
		
		// relocate grips
		/*if (bTilePlaneFound && !nAllowEdit)
		{
			if (bIsGableEnd)
			{
				if (i == 0) // _Pt0
					_Pt0 = ln.intersect(Plane(pt0[0], vxLn), 0);
				else if (i == 1) // _PtG[0]
					_PtG[0] = ln.intersect(Plane(pt0[1], vxLn), 0);						
			}
			else
			{
				if (i == 0) // _Pt0
					_Pt0 = ln.intersect(Plane(pt0[0], vzAd), dOff[0]);
				else if (i == 1) // _PtG[0]
				{
					ln.vis(3);
					_PtG[0] = ln.intersect(Plane(pt0[1], vzAd), dOff[0]);	
					
				}
			}
		}	*/	
		nIndex.swap(0,1);
	}
	
	


// draw warning 'no lath found'
	if (!bTilePlaneFound)
	{
		Vector3d vxW, vyW;
		vxW = _Pt0 - _PtG[0]; vxW.normalize();
		vyW = _ZW.crossProduct(vxW);
		LineSeg lsW (_PtG[0],_Pt0);
		String sWTxt = T("append laths or roof elements");
		dpPlan.color(20);
		dpPlan.draw(scriptName() , lsW.ptMid(),vxW, vyW,0,1.7,_kDevice);		
		dpPlan.draw(sWTxt , lsW.ptMid(),vxW, vyW,0,-1.7,_kDevice);
		double dWarningLength = dpPlan.textLengthForStyle(sWTxt, sDimStyle);
		double dWarningHeight = dpPlan.textHeightForStyle(sWTxt, sDimStyle);
		PLine plW;
		plW.createRectangle(LineSeg(lsW.ptStart() - vyW * 0.5 * dWarningHeight,lsW.ptEnd() + vyW * 0.5 * dWarningHeight) ,vxW, vyW);		
		PlaneProfile ppW(plW);
		plW.createRectangle(LineSeg(lsW.ptMid() - 0.6 * vxW * dWarningLength - vyW * dWarningHeight,
		 lsW.ptMid() + 0.6 * vxW * dWarningLength + vyW * dWarningHeight),vxW, vyW);
		ppW.joinRing(plW,_kSubtract);
		dpPlan.draw(ppW,_kDrawFilled);	
		return;
	}	

// Vectors of the tile line
	Vector3d vxLn = _PtG[0] - _Pt0; 				vxLn.normalize();		vxLn.vis((_Pt0+_PtG[0])/2,1);
	Vector3d vyLn = vxLn.crossProduct(-_ZW); 	vyLn.normalize();		vyLn.vis((_Pt0+_PtG[0])/2,3);	
	Vector3d vzLn = vxLn.crossProduct(vyLn);	vzLn.normalize();		vzLn.vis((_Pt0+_PtG[0])/2,150);		

// swap dir
	if (vxLn.dotProduct(_ZW)<0)
	{
		Point3d ptTemp[0];
		ptTemp.append(_Pt0);	
		ptTemp.append(_PtG[0]);
		vxLn *= -1;
		vyLn *= -1;
		ptTemp.swap(0,1);		
		_Pt0 = ptTemp[0];
		_PtG[0] = ptTemp[1];				
	}


// draw preview
	dpPlan.color((151 + nMitre));
	dpPlan.draw(PLine(_Pt0, _PtG[0]));	
	PLine plC(_ZW);
	plC.createCircle(_Pt0, _ZW, 0.5 * dTxtH);
	PlaneProfile ppC(plC);
	plC.createCircle(_Pt0, _ZW, 0.4 * dTxtH);
	ppC.subtractProfile(PlaneProfile(plC));
	dpPlan.draw(ppC,_kDrawFilled);	

	plC = PLine(_PtG[0] - vxLn * 3 * dTxtH - vxLn.crossProduct(_ZW) * .5 * dTxtH , _PtG[0], _PtG[0] - vxLn * 3 * dTxtH + vxLn.crossProduct(_ZW) * .5 * dTxtH , _PtG[0] - vxLn * 2 * dTxtH);
	plC.close();
	dpPlan.draw(PlaneProfile(plC),_kDrawFilled);	


// initialize
	Point3d pt[0];
		// pt[] is the matrix of all tiles 
		// x=columnindex, y=[empty], z= type
		// types
		// -1 = deleted
		// 10001 = standard
	pt = _Map.getPoint3dArray("pt");

	// set to absolute
	for (int p = 0; p < pt.length(); p++)
		pt[p] = pt[p]- (_Pt0-pt0[0]);
		
// get map
	Map mapTile = _Map.getMap("Tile");
	double dLMin = mapTile.getMap("0").getDouble("LMin");
	double dLMax = mapTile.getMap("0").getDouble("LMax");	
	double dY = (mapTile.getMap("0").getDouble("WMin")+mapTile.getMap("0").getDouble("WMax"))/2;
	double dZ = mapTile.getMap("0").getDouble("H");
	
// calculate tile distribution	
	double dW = Vector3d(_PtG[0]-_Pt0).length(), dDistrMin, dDistrMax, dDistr;	
	// net width
	double dWNet = dW;	
	int nCol;// qty of cols
	
	// subtract non standards
	for (int p = 0; p < pt.length(); p++)
	{
		if (pt[p].Z() > 0)
		{
			String s = pt[p].Z();	
			if (!mapTile.hasMap(s))
				s = "0";
			if (mapTile.hasMap(s))
			{
				Map mapTileSub = mapTile.getMap(s);
				dWNet -= (mapTileSub.getDouble("LMin")+mapTileSub.getDouble("LMax"))/2;
				nCol++;
			}	
		}	
	}
	
// calc qty of tile columns
	int nMin, nMax, nColStandard;
	double dDiv;

	dDiv = dWNet / dLMax +.99;	
	nMin = (dDiv >0) ? dDiv +0.499999 : dDiv -0.499999;
	
	dDiv = dWNet / dLMax +.99;			
	nMax = (dDiv >0) ? dDiv +0.499999 : dDiv -0.499999;
	if (nMin <= 0 || nMax <=0 )
		return;
			
	double dMin = dWNet / nMax;		
	double dMax = dWNet / nMin;	
	
	nColStandard = (nMin+nMax)/2;

	dDistr = dWNet / nColStandard;
	if (dDistr < dLMin)
		dDistr = dLMin;	
	if (dDistr > dLMax)
		dDistr = dLMax;
		

	nCol += nColStandard;
	
// limiting global pp
	PlaneProfile ppMaxBounds(CoordSys(_Pt0,vxLn,vyLn,vzLn));	
	PLine plMaxBounds(_Pt0, _Pt0 + vyLn * dY, _PtG[0] + vyLn * dY, _PtG[0]);
	ppMaxBounds.joinRing(plMaxBounds,_kAdd);
	ppMaxBounds.transformBy(-0.5 * vyLn * dY);
	//ppMaxBounds.vis(2);	

// collect planeprofile
	PlaneProfile pp[0];
	Point3d ptTile = _Pt0;
	for (int i = 0; i < nCol;i++)
	{
		double dX = dDistr;
		// find non standard length
		for (int p = 0; p < pt.length(); p++)
		{
			int x,z;// column,type
			x= pt[p].X();
			z= pt[p].Z();	
			if (x == i)
			{
				String s = z;	
				if (!mapTile.hasMap(s))
					s = "0";
				if (mapTile.hasMap(s))
				{
					Map mapTileSub = mapTile.getMap(s);
					dX = (mapTileSub.getDouble("LMin")+mapTileSub.getDouble("LMax"))/2;
					break;
				}	
			}
		}// next p
		PlaneProfile ppTile(CoordSys(ptTile,vxLn,vyLn,vzLn));	
		ppTile.joinRing(PLine(ptTile - 0.5*vyLn*dY, ptTile + vxLn*dX - 0.5*vyLn*dY, ptTile + vxLn*dX + 0.5*vyLn*dY,ptTile + 0.5*vyLn*dY), _kAdd);
		if (nMitre > -1)
		{
			PlaneProfile ppNet = ppTile;
			ppNet.intersectWith(ppMaxBounds);
			pp.append(ppNet);	
		}
		
		//ppTile.vis(1);
			
		ptTile.transformBy(vxLn * dX);
	}// next i


// trigger5/6/7: delete / add / modify tiles
	if (_bOnRecalc && (_kExecuteKey==sTrigger[4]||_kExecuteKey==sTrigger[5]||_kExecuteKey==sTrigger[6])) 
	{
		Point3d ptTileOrg = _Pt0;
		int nMode = _kAdd;
		int nModifiedType;
		if (_kExecuteKey==sTrigger[4]){
			nMode = _kSubtract;
			nModifiedType = -1;
		}
		else if (_kExecuteKey==sTrigger[6])
		{
			nMode = 2;
			nModifiedType	 = getInt(T("|Enter new type index (0=default)|"));
			
		}
		Point3d ptPick[0];
		ptPick.append(getPoint("\n" + T("|Select a point inside a tile|")));
		// project to tile plane
		ptPick[ptPick.length()-1] = Line(ptPick[ptPick.length()-1], _ZW).intersect(Plane(ptTileOrg,vzLn),0);
		TslInst tsl;
		while (1) 
		{
			PrPoint ssP("\n" + T("|Select next point to select multiple tiles|"),ptPick[ptPick.length()-1]); 
			if (ssP.go()==_kOk)
			{
				ptPick.append(ssP.value());
				// project to tile plane
				ptPick[ptPick.length()-1] = Line(ptPick[ptPick.length()-1], _ZW).intersect(Plane(ptTileOrg,vzLn),0);	
			
			// show jig
				if (ptPick.length() > 2)
				{
					// erase the previous jig
					if (tsl.bIsValid())
						tsl.dbErase();

					Map mapTsl;
					mapTsl.setInt("isJig", TRUE);
					Vector3d vecUcsX = _XW;
					Vector3d vecUcsY = _YW;
					Beam lstBeams[0];
					Entity lstEnts[0];
					int lstPropInt[0];
					double lstPropDouble[0];
					String lstPropString[0];
					Point3d lstPoints[0];
		
					lstPoints.append(ptPick[0]);
					PLine pl0(vzLn);
					for (int p = 0; p < ptPick.length(); p++)
						pl0.addVertex(ptPick[p]);
					mapTsl.setPLine("pl0", pl0);	
					tsl.dbCreate(scriptName(), vecUcsX,vecUcsY,lstBeams, lstEnts, lstPoints, 
						lstPropInt, lstPropDouble, lstPropString,TRUE, mapTsl ); // create new instance	
				}// END jig	
			}// END ssP.go()==_kOk)
			else
				break;
			
 		}// do...

		// erase the last jig
		if (tsl.bIsValid())
			tsl.dbErase();
	
		
		// single tile
		if (ptPick.length() == 1)
		{
			for (int t = 0; t < pp.length(); t++)
			{
				if (pp[t].pointInProfile(ptPick[0]) != _kPointOutsideProfile)
				{
					// find pt
					int nPt = -1;
					for (int p = 0; p < pt.length(); p++)
					{
						if (pt[p].X() == t)
						{
							nPt = t;
							pt[p].setZ(nModifiedType);
							break;	
						}
					}
					if (nPt == -1)
						pt.append(Point3d(t,0,nModifiedType));

				}// end if _kPointOutsideProfile
			}//next t
		}
		// multiple tiles
		else if (ptPick.length() >1)
		{
			PLine plPick(vzLn);
			if (ptPick.length() == 2)
			{
				// build a tiny pp along the line
				Vector3d vxPick, vyPick;
				vxPick = ptPick[1] - ptPick[0];	vxPick.normalize();
				vyPick = vxPick.crossProduct(vzLn);
				plPick.createRectangle(LineSeg(ptPick[0] - vyPick * U(1),ptPick[1] + vyPick * U(1)),vxPick,vyPick);
			}
			else
				for (int p = 0; p < ptPick.length(); p++)
					plPick.addVertex(ptPick[p]);

			for (int t = 0; t < pp.length(); t++)
			{
				PlaneProfile ppPick(plPick);
				ppPick.intersectWith(pp[t]);
				
				if (ppPick.area() > U(1)*U(1))
				{
					// find pt
					int nPt = -1;
					for (int p = 0; p < pt.length(); p++)
					{
						if (pt[p].X() == t)
						{
							nPt = t;
							pt[p].setZ(nModifiedType);
							break;	
						}
					}// next p
					if (nPt == -1)
						pt.append(Point3d(t,0,nModifiedType));
				}
			}// next t
		}// end multiple	
		setExecutionLoops(2);	
	}
// END trigger5/6/7: delete / add / modify tiles




// draw and count tiles
	int nQty[0];
	int nTileType[0];
	
	// the vector perp to the hip/ridge
	Vector3d vyTile[0];
	vyTile.append(vxLn.crossProduct(vz[0]));
	vyTile.append(vxLn.crossProduct(-vz[1]));
	if (vxLn.isPerpendicularTo(_ZW))
	{
		vyTile[0] = vy[0];
		vyTile[1] = vy[1];
	}	
		
	for (int t = 0; t < nCol; t++)
	{
		int n = 0;
		// find non standard type
		for (int p = 0; p < pt.length(); p++)
		{
			int x,z;// column,type
			x= pt[p].X();
			z= pt[p].Z();	
			if (x == t)
			{
				n = z;
				break;
			}
		}
		
		if (n > -1 && t < pp.length())
		{
			// get pp dimensions
			Point3d ptPP = pp[t].coordSys().ptOrg();
			LineSeg ls = pp[t].extentInDir(vxLn);
			double dX = abs(vxLn.dotProduct(ls.ptStart()-ls.ptEnd()));
			
			// find tyle type
			int nT = nTileType.find(n);
			if (nT<0)
			{
				nTileType.append(n);
				nQty.append(1);	
			}
			else
				nQty[nT]++;

			Display dp1(n+151);
			dp1.addViewDirection(_ZW);
			// draw angle tile shape
			PLine plTile(ptPP, ptPP - vyTile[0]*0.5*dY, ptPP + vxLn*dX - vyTile[0]*0.5*dY, ptPP + vxLn*dX);
			dp1.draw(plTile);
			plTile = PLine(ptPP, ptPP - vyTile[1]*0.5*dY, ptPP + vxLn*dX - vyTile[1]*0.5*dY , ptPP + vxLn*dX);
			dp1.draw(plTile);
			
			//dp1.draw(pp[t]);	
			// mark special tiles
			if (n > 0)
			{
				LineSeg lsSpec = pp[t].extentInDir(vxLn);
				lsSpec.transformBy(-vzLn * dZ);
				dp1.draw(lsSpec);
			}
		}
	}	
	
// draw 3d tile body
	PLine plBd(vzLn);
	plBd.addVertex(_Pt0);
	plBd.addVertex(_Pt0 - vyTile[0] * 0.5 * dY);	
	plBd.addVertex(_Pt0 -vyTile[0] * 0.5 * dY + vz[0] * dZ);
	plBd.addVertex(Line(_Pt0 - vyTile[0] * 0.5 * dY + vz[0] * dZ, vyTile[0]).intersect(Plane(_Pt0,vz[1]),dZ));	
	plBd.addVertex(_Pt0 - vyTile[1] * 0.5 * dY + vz[1] * dZ);	
	plBd.addVertex(_Pt0 - vyTile[1] * 0.5 * dY);		
	plBd.close();
	Body bd3D(plBd,vxLn * Vector3d(_Pt0-_PtG[0]).length(),1 );	
	dp.draw(bd3D);
	
// draw start/end part
	if (mapTile.hasMap(sPartStart) && sPartStart != "") //
	{
		double dXBd, dYBd, dZBd;
		dXBd = (mapTile.getMap(sPartStart).getDouble("LMin")+mapTile.getMap(sPartStart).getDouble("LMax")/2);
		dYBd = (mapTile.getMap(sPartStart).getDouble("WMin")+mapTile.getMap(sPartStart).getDouble("WMax")/2);
		dZBd = mapTile.getMap(sPartStart).getDouble("H");		
		Body bd(_Pt0,vxLn, vyLn, vzLn, dXBd, dYBd, dZBd,1,0,-1);	
		for (int i = 0; i < 2; i++)
			bd.addTool(Cut(_Pt0, vz[i]),0);
		
		dpPlan.color(sPartStart.atoi()+151);
		dpPlan.draw(bd);	
		
		// find tyle type
		int n = sPartStart.atoi();
		int nT = nTileType.find(n);
		if (nT<0)
		{
			nTileType.append(n);
			nQty.append(1);	
		}
		else
			nQty[nT]++;
	}	
	if (mapTile.hasMap(sPartEnd) && sPartEnd != "")
	{
		double dXBd, dYBd, dZBd;
		dXBd = (mapTile.getMap(sPartEnd).getDouble("LMin")+mapTile.getMap(sPartEnd).getDouble("LMax")/2);
		dYBd = (mapTile.getMap(sPartEnd).getDouble("WMin")+mapTile.getMap(sPartEnd).getDouble("WMax")/2);
		dZBd = mapTile.getMap(sPartEnd).getDouble("H");		
		Body bd(_PtG[0],vxLn, vyLn, vzLn, dXBd, dYBd, dZBd,-1,0,-1);	
		for (int i = 0; i < 2; i++)
			bd.addTool(Cut(_PtG[0], vz[i]),0);		
		dpPlan.color(sPartEnd.atoi()+151);
		dpPlan.draw(bd);
		// find tyle type
		int n = sPartEnd.atoi();
		int nT = nTileType.find(n);
		if (nT<0)
		{
			nTileType.append(n);
			nQty.append(1);	
		}
		else
			nQty[nT]++;			
	}		

// publish tile data
	Map mapTileData;

// order data by type
	for (int i = 0; i < nQty.length(); i++)
		for (int j = 0; j < nQty.length()-1; j++)
			if(nTileType[j]>nTileType[j+1])
			{
				int nTmp = nTileType[j];
				nTileType[j] = nTileType[j+1];
				nTileType[j+1] = nTmp;
				
				nTmp = nQty[j];
				nQty[j] = nQty[j+1];
				nQty[j+1] = nTmp;				
			}
		

// draw and collect qty
	for (int i = 0; i < nQty.length(); i++)
	{
		//Point3d ptTxt = _Pt0 - _YW * (i+1) * dpPlan.textHeightForStyle("O", sDimStyle) * 1.2;
		//dpPlan.color(nTileType[i]+1);
		//dpPlan.draw("Type " + nTileType[i] + ": " + nQty[i], ptTxt, _XW, _YW, 1, -1);	
		mapTileData.setInt(nTileType[i], nQty[i]);
	}
	_Map.setMap("TileData", mapTileData);
	
		
// transform relative to pt0
	for (int p = 0; p < pt.length(); p++)
		pt[p] = pt[p]- (pt0[0]-_Pt0);
	_Map.setPoint3dArray("pt",pt);			






#End
#BeginThumbnail
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
&Y#[>1__9
`






#End
