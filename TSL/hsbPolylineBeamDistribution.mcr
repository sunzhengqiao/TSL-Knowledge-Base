#Version 8
#BeginDescription
version value="1.0" date="15nov2017" author="thorsten.huck@hsbcad.com"
initial

This tsl creates a beam distribution between two polylines. The polylines may not be perpendicular. It can be used to created twisted beam distribution
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords Beam;Distribution
#BeginContents
/// <History>//region
/// <version value="1.0" date="15nov2017" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select 2 polylines and specify beam direction by two points, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates a beam distribution between two polylines. The polylines may not be perpendicular. It can be used to created twisted beam distributions
/// </summary>//endregion



// constants //region
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));	
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	
// beam properties	
	category = T("|Beam Properties|");
	String sWidthName=T("|Width|");	
	PropDouble dWidth(nDoubleIndex++, U(60), sWidthName);	
	dWidth.setDescription(T("|Defines the Width|"));
	dWidth.setCategory(category);
	
	String sHeightName=T("|Height|");	
	PropDouble dHeight(nDoubleIndex++, U(200), sHeightName);	
	dHeight.setDescription(T("|Defines the Height|"));
	dHeight.setCategory(category);
		
// distribution
	category = T("|Distribution|");
	String sInterdistanceName=T("|Interdistance|");	
	PropDouble dInterdistance(nDoubleIndex++, U(500), sInterdistanceName);	
	dInterdistance.setDescription(T("|Defines the Interdistance|"));
	dInterdistance.setCategory(category);
	
	String sDistributionModes[] = {T("|Even Distribution|"), T("|Fixed Distribution|")};
	String sDistributionModeName= T("|Mode|");
	PropString sDistributionMode(nStringIndex++, sDistributionModes,sDistributionModeName);
	sDistributionMode.setDescription(T("|Sets the mode of a distribution|"));		
	sDistributionMode.setCategory(category);

	




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
				setPropValuesFromCatalog(sLastInserted);					
		}	
		else	
			showDialog();
		
	// prompt for 2 polylines
		PrEntity ssEpl(T("|Select 2 polylines|"), EntPLine());	  	
	  	while(_Entity.length()<2)
	  	{
	  		if (ssEpl.go())
	  		{
	  			_Entity.append(ssEpl.set());
	  			int n = _Entity.length();
	  			if (n==1)
	  				ssEpl=PrEntity (T("|Select second polyline|"), EntPLine());
	  		}
	  		else 
	  			break;
	  	}
			
	// prompt for rafter direction
		_Pt0 = getPoint();
	// prompt for point input
		PrPoint ssP(TN("|Select point in rafter direction|"),_Pt0); 
		if (ssP.go()==_kOk) 
			_PtG.append(ssP.value()); // append the selected points to the list of grippoints _PtG
			
				
		return;
	}	
// end on insert	__________________


/// validate references
	PLine plines[0];
	for (int i=0;i<_Entity.length();i++) 
	{ 
		PLine pl =_Entity[i].getPLine();
		if (pl.length()>dEps)
		{
			plines.append(pl); 
			setDependencyOnEntity(_Entity[i]);
		}
	}	
	if (plines.length()<2)
	{
		reportMessage("\n"+ scriptName() + ": "+T("|Invalid set of polylines.|")+" " + T("|Tool will be deleted.|"));
		eraseInstance();
		return;	
	}
	if (_PtG.length()<1 || (_Pt0-_PtG[0]).length()<dEps)
	{ 
		reportMessage("\n"+ scriptName() + ": "+T("|Grip point invalid.|")+" " + T("|Tool will be deleted.|"));
		eraseInstance();
		return;		
	}

// check interdistance
	if (dInterdistance<=0)
	{ 
		reportMessage("\n"+ scriptName() + ": "+sInterdistanceName + " "+T("|may not be <= 0.|")+" " + T("|Tool will be deleted.|"));
		eraseInstance();
		return;			
	}


// ints
	int nDistributionMode = sDistributionModes.find(sDistributionMode, 0); // 0 = even, 1 = fixed

// get projected beam direction	
	Vector3d vecX, vecY, vecZ = _ZW;
	Point3d pt0 = _Pt0;
	pt0.setZ(0);
	Point3d pt1 = _PtG[0];
	pt1.setZ(0);
	vecY = pt1 - pt0;
	vecY.normalize();
	vecX = vecY.crossProduct(vecZ);
	
	vecX.vis(_Pt0, 1);
	vecY.vis(_Pt0, 3);
	vecZ.vis(_Pt0, 150);
	
// find distribution range
	PLine pl0 = plines[0];
	PLine pl1 = plines[1];

// set polyline directions
	if (vecX.dotProduct(pl0.ptEnd()-pl0.ptStart())<dEps)
		pl0.reverse();
	if (vecX.dotProduct(pl1.ptEnd()-pl1.ptStart())<dEps)
		pl1.reverse();	
	Point3d ptStart0 = pl0.ptStart();
	Point3d ptStart1 = pl1.ptStart();
	Point3d ptEnd0 = pl0.ptEnd();
	Point3d ptEnd1 = pl1.ptEnd();
	
// erase all existing beams
	for (int i=_Beam.length()-1; i>=0 ; i--) 
	{ 
		_Beam[i].dbErase(); 
		
	}

// create closing plines
	PLine plA(ptStart0, ptStart1);
	plA.vis(3);
	PLine plB(ptEnd0, ptEnd1);
	plB.vis(4);
	
	Point3d pts0[] = pl0.vertexPoints(true);
	Point3d pts1[] = pl1.vertexPoints(true);
	Point3d ptsAll[0];
	ptsAll.append(pts0);
	ptsAll.append(pts1);
	
	// hull of all plines
	PLine plHull;
	plHull.createConvexHull(Plane(pt0, vecZ), ptsAll);
	PlaneProfile ppHull(CoordSys(pt0, vecX, vecY, vecZ));
	ppHull.joinRing(plHull, _kAdd);
	
	// add arced areas if any
	for (int i=0;i<plines.length();i++) 
	{ 
		PLine pl = plines[i]; 
		pl.close();
		pl.projectPointsToPlane(Plane(_PtW, vecZ),vecZ);
		pl.vis(2);
		if (pl.area()>pow(dEps,2))
			ppHull.joinRing(pl, _kAdd);		 
	}
	//ppHull.vis(4);

	
// get extents of profile
	LineSeg seg = ppHull.extentInDir(vecX);
	seg.vis(2);
	double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()))-dWidth;
	double dY = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
	
// get distribution values
	int nNum = dX / dInterdistance+1;	
	double dDist = dInterdistance;
	if (nDistributionMode==0)
		dDist = dX / nNum;
	
// distribute
	Point3d ptStart = seg.ptMid() - vecX * .5 * dX;
	Point3d ptEnd = seg.ptMid() + vecX * .5 * dX;
	Point3d ptX=ptStart;
	
	for (int i=0;i<=nNum;i++) 
	{ 
		if (vecX.dotProduct(ptX - ptEnd) > dEps)continue;
		ptX.vis(i);
		
		
	// distinguish if the point is behind one of the end points
		int bIsRight = vecX.dotProduct(ptX - ptEnd0) > dEps || vecX.dotProduct(ptX - ptEnd1)>dEps;
		
		Plane pn(ptX, vecX);
		
	// try to find intersection with plines
		Point3d pts[0];
		Point3d ptsBeam[0];
		Cut cuts[0];
		for (int k=0;k<plines.length();k++) 
		{ 
			PLine pl= plines[k]; 
			Point3d pt;
			pts = pl.intersectPoints(pn);
			if (pts.length()>0)
				ptsBeam.append(pts[0]);
			else
			{ 
				if (!bIsRight)
					pl = plA;
				else
					pl = plB;
				pts = pl.intersectPoints(pn);	
				if (pts.length()>0)
					ptsBeam.append(pts[0]);
				else
					continue;
			}
			
		// calculate cut	
			pt = ptsBeam[ptsBeam.length()-1];
			Point3d ptNext = pl.getPointAtDist(pl.getDistAtPoint(pt) + dEps);
			
//		// continue if this pline appears to be an arc segment
//			if (!pl.isOn((pt+ptNext)/2))
//			{
//				continue;
//			}
			Vector3d vecXC = pt - ptNext;
			vecXC.normalize();
			Vector3d vecZC = vecXC.crossProduct(_ZW);
			if (ppHull.pointInProfile(pt+vecZC*.5*dWidth)!=_kPointOutsideProfile)
				vecZC *= -1;
			//vecXC.vis(pt,6);
			vecZC.vis(pt,6);
			Cut cut(pt, vecZC);
			cuts.append(cut);
			
		}
		
		ptsBeam = Line(_Pt0, vecY).orderPoints(ptsBeam);
		if (ptsBeam.length()<2)
			continue;
			

		ptsBeam[0].vis(i);
		ptsBeam[1].vis(i);
	
	// beam coordSys
		Vector3d vecXBm = ptsBeam[1] - ptsBeam[0];
		double dXBm = vecXBm.length();
		vecXBm.normalize();
		Vector3d vecYBm = -vecX;
		Vector3d vecZBm = vecXBm.crossProduct(vecYBm);

	// create beam
		Beam bm;
		if(dXBm>dEps &&  dWidth>dEps && dHeight>dEps)
		{
			bm.dbCreate(ptsBeam[0],vecXBm, vecYBm, vecZBm,dXBm,  dWidth, dHeight, 1,0,-1 );
			if (bm.bIsValid())
			{ 
				bm.setColor(32);
				for (int c=0;c<cuts.length();c++) 
				{ 
					bm.addTool(cuts[c],1); 
					 
				}
				_Beam.append(bm);
			}
			
		}
		PLine (ptsBeam[0],ptsBeam[1]).vis(i);
		ptX.transformBy(vecX * dDist);	 
	}
	
	
// draw outline
	Display dp(6);
	dp.draw(pl0);
	dp.draw(pl1);
	dp.draw(plA);
	dp.draw(plB);
	
// draw direction
	double dSize = U(200);
	PLine plDir(_Pt0, _Pt0 + vecY * dSize, _Pt0 + vecY * .8 * dSize + vecX * .2 * dSize , _Pt0 + vecY * dSize);
	plDir.addVertex(_Pt0 + vecY * .8 * dSize - vecX * .2 * dSize);
	dp.draw(plDir);
	

	



#End
#BeginThumbnail

#End