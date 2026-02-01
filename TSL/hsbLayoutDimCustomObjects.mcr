#Version 8
#BeginDescription
/// Diese TSL erzeugt eine Elementbemassung im Papierbereich. Es werden aus den 
/// gewählten Zonen (Mehrfachauswahl möglich) die Masspunkte aller Bauteile und/oder
/// die Extremmaße der Zone(n) ermittelt.

version  value="1.7" date="31mar16" author="thorsten.huck@hsbcad.com"
tsl origin excluded if map based dimRequests are attached to the dimension instance
bugfix opening / element references, introduced 1.4

tsl's will be filtered by OPM name instead of scriptname
bugfix disappearing dimline solved when all dimension modes are set to parallel



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 7
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This TSL creates dimension lines in paperspace in dependency of an element viewport.
/// It collects tsl's and offers filter options for the referenced objects to limit the selection set.
/// The dimension lines may have additional points of certain references such as openings or intersecting walls.
/// </summary>



/// History
///<version  value="1.7" date="31mar16" author="thorsten.huck@hsbcad.com"> tsl origin excluded if map based dimRequests are attached to the dimension instance </version>
///<version  value="1.6" date="31mar16" author="thorsten.huck@hsbcad.com"> bugfix opening / element references, introduced 1.4 </version>
///<version  value="1.5" date="27nov15" author="th@hsbCAD.de"> bugfix tsl based dimrequests </version>
///<version  value="1.4" date="22apr15" author="th@hsbCAD.de"> tsl based dimrequests added, new property to set local vertical dimlines </version>
///<version  value="1.3" date="10oct13" author="th@hsbCAD.de"> tsl's will be filtered by OPM name instead of scriptname </version>
///<version  value="1.2" date="12jul13" author="th@hsbCAD.de"> bugfix disappearing dimline solved when all dimension modes are set to parallel</version>
///<version  value="1.0" date="14mar13" author="th@hsbCAD.de">initial</version>


// constants
	U(1,"mm");
	double dEps=U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;	
	String sLastEntry = T("|_LastInserted|");
	String sDoubleClick= "TslDoubleClick";	

// debug
	int nDebug = false;
	
	String sPropDesc = T("|Separate multiple entries by|")+ " ' ;'";
	String sArNY[]={T("|No|"), T("|Yes|")};
	
	int nDisplayModes[]={_kDimPar, _kDimPerp, _kDimNone};
	String sDisplayModes[] = {T("|Parallel|"),T("|Perpendicular|"),T("|none|")};


// Object
	String sCategoryObject = T("|Objects|");
	
	PropString sIncludeZone(2,"",T("|Include entities of Zone|"));	
	sIncludeZone.setDescription(sPropDesc);
	sIncludeZone.setCategory(sCategoryObject );
	
	PropString sIncludeTsl(5,"",T("|TSL byName|"));	
	sIncludeTsl.setDescription(sPropDesc);
	sIncludeTsl.setCategory(sCategoryObject );
	
	PropString sIncludeColor(6,"",T("|TSL byColor|"));	
	sIncludeColor.setDescription(sPropDesc);
	sIncludeColor.setCategory(sCategoryObject );

// Reference
	String sCategoryRef = T("|Reference|");
	
	PropString sIncludeZoneRef(3,"",T("|Filter Reference Zone|"));	
	sIncludeZoneRef.setDescription(T("|Enter Zone Indices to specify the Reference Zone(s)|") + " " + sPropDesc);
	sIncludeZoneRef.setCategory(sCategoryRef);
			
	String sRefModesHor[] = {T("|Element|"), T("|Reference Zone|"),T("|Opening|"),T("|Opening|") + "+" + T("|Walls|"),T("|Walls|")};
	PropString sRefModeHor(12,sRefModesHor,T("|Horizontal|"));
	sRefModeHor.setCategory(sCategoryRef );	
		
	String sRefModesVer[] = {T("|Element|"), T("|Reference Zone|"),T("|Opening|"),T("|Opening|") + "+" + T("|Element|")};
	PropString sRefModeVer(13,sRefModesVer,T("|Vertical|"));	
	sRefModeVer.setCategory(sCategoryRef);	
	

	PropString sIncludeColorRef(4,"",T("|Include|") + " " +  T("|byColor|"));	
	sIncludeColorRef.setDescription(sPropDesc);
	sIncludeColorRef.setCategory(sCategoryRef);	
		
	PropString sExcludeColorRef(11,"",T("|Exclude|") + " " +  T("|byColor|"));	
	sExcludeColorRef.setDescription(sPropDesc);
	sExcludeColorRef.setCategory(sCategoryRef);	
	
// Dimlines
	String sCategoryDimHor = T("|Horizontal Dimension|");	
	
	// horizontal props
	PropString sDisplayModeHorDelta(7,sDisplayModes,T("|Delta|"));
	sDisplayModeHorDelta.setCategory(sCategoryDimHor );
	
	PropString sDisplayModeHorChain(8,sDisplayModes,T("|Chain|"));	
	sDisplayModeHorChain.setCategory(sCategoryDimHor);
	//PropString sDisplayHorOnTop(9,sArNY,"   " + T("|Swap Side of Delta and Chain|"));

	String sCategoryDimVer = T("|Vertical Dimension|");	
	// vertical props
	PropString sDisplayModeVerDelta(9,sDisplayModes,T("|Delta|")+" ");
	sDisplayModeVerDelta.setCategory(sCategoryDimVer);	
	PropString sDisplayModeVerChain(10,sDisplayModes,T("|Chain|")+" ");	
	sDisplayModeVerChain.setCategory(sCategoryDimVer);		

	PropString sTslByInstance(14,sArNY,T("|byTsl|"));	
	sTslByInstance.setCategory(sCategoryDimVer);	

// general
	PropString sDimStyle(0, _DimStyles, T("|Dimstyle|"));
	PropDouble dScaleFactor(0,1,T("|Scale Factor|"),_kNoUnit);
	dScaleFactor.setDescription(T("|Sets the scale factor of the dimension line.|"));
		
	PropString sDescAlias(1,"",T("|Description Alias|"));
	PropInt nColor (0,171,T("|Color|"));
	
// on insert	
	if (_bOnInsert) {
		if (insertCycleCount()>1) { eraseInstance(); return; }
		showDialog();		
		Viewport vp = getViewport(T("Select a viewport")); // select viewport
		_Pt0 = getPoint(T("insertion point")); // select point
  		_Viewport.append(vp);
  		return;
	}
// end on insert
	if (_bOnDebug)nDebug=true;

// set the diameter of the 3 circles, shown during dragging
	setMarbleDiameter(U(4));
	_Pt0.vis(1);
	
// do something for the last appended viewport only
	if (_Viewport.length()==0) return; // _Viewport array has some elements
	Viewport vp = _Viewport[_Viewport.length()-1]; // take last element of array
	_Viewport[0] = vp; // make sure the connection to the first one is lost

// check if the viewport has hsb data
	if (!vp.element().bIsValid()) return;

	CoordSys ms2ps = vp.coordSys();
	CoordSys ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps
	Element el = vp.element();	

	CoordSys cs;
	Point3d ptOrg;
	Vector3d vx,vy,vz;

	cs = el.coordSys();
	ptOrg = cs.ptOrg();
	vx=cs.vecX();
	vy=cs.vecY();
	vz=cs.vecZ();	
	
	Point3d ptCenElement;
	PLine plOutlineWall = el.plOutlineWall();
	ptCenElement.setToAverage(plOutlineWall.vertexPoints(true));
	
// Display
	Display dp(nColor);
	double dScale = ps2ms.scale();
	dp.dimStyle(sDimStyle,dScale);
	
	if (dScaleFactor>0)
		dScale = ps2ms.scale()*dScaleFactor;
	dp.dimStyle(sDimStyle,dScale);	
	
	
	
// validate chain/delta modes, ensure that settings are not all set to none
	if (sDisplayModeHorDelta==sDisplayModes[2] && sDisplayModeHorChain==sDisplayModes[2] && sDisplayModeVerDelta==sDisplayModes[2] && sDisplayModeVerChain==sDisplayModes[2])	
	{
		reportMessage("\n" +scriptName() + "\n" +T("|Current Properties would not display anything.|") + " " + T("|Properties set to default.|"));
		sDisplayModeHorDelta.set(sDisplayModes[0]);
		sDisplayModeVerDelta.set(sDisplayModes[1]);
	}
	
// ints
	int nDisplayModeHorDelta = nDisplayModes[sDisplayModes.find(sDisplayModeHorDelta)];
	int nDisplayModeHorChain = nDisplayModes[sDisplayModes.find(sDisplayModeHorChain)];
	int nDisplayModeVerDelta = nDisplayModes[sDisplayModes.find(sDisplayModeVerDelta)];
	int nDisplayModeVerChain = nDisplayModes[sDisplayModes.find(sDisplayModeVerChain)];

	int nRefModeHor = sRefModesHor.find(sRefModeHor);
	int nRefModeVer = sRefModesVer.find(sRefModeVer);
	
	int bTslByInstance =sArNY.find(sTslByInstance);
	
// collect openings if required
	Opening openings[0];
	if (nRefModeHor==2 || nRefModeHor==3)	
		openings.append(el.opening());

// collect connected elements if required
	Element elConnected[0];
	if (nRefModeHor==3 || nRefModeHor==4)	
	{
		ElementWall wall = (ElementWall)el;
		if (wall.bIsValid())
			elConnected.append(wall.getConnectedElements());
		elConnected.append(el);	
	}
	
	
// CODE SNIPPET to allow user defined grips with a layout dim________________________________________________________________	
// user defined points
	Map mapUserPoints = _Map.getMap("userPoints");
	Map mapGrips = mapUserPoints.getMap(el.number());
	
// add triggers
	String sTrigger[] = {T("|Add Point|"),T("|Delete Point|"),T("|Delete all Points|"),T("|Delete all Points of all Elements|")};
	for (int i = 0; i < sTrigger.length(); i++)
		addRecalcTrigger(_kContext, sTrigger[i]);	

// trigger0:Add Point						
	if (_bOnRecalc && _kExecuteKey==sTrigger[0]) 
	{	
		Point3d pt = getPoint();
		mapGrips.setPoint3d(mapGrips.length(),pt);
		mapUserPoints.setMap(el.number(),mapGrips);	
		_Map.setMap("userPoints",mapUserPoints);
	}	
	
// trigger1:Delete Point						
	else if (_bOnRecalc && _kExecuteKey==sTrigger[1]) 
	{	
		Point3d pt = getPoint();
		double dMin = U(1000000);
		int n=-1;
		for (int i = 0; i < _PtG.length(); i++)
		{
			double d = abs(_XW.dotProduct(pt-_PtG[i]));
			if (d<dMin)
			{
				dMin =d;
				n=i;	
			}
		}
		if (n>-1)
		{
			mapGrips.removeAt(n,true);
		}
	}
		
// trigger2:Delete all Points					
	else if (_bOnRecalc && _kExecuteKey==sTrigger[2]) 
	{	
		mapGrips = Map();
		mapUserPoints.removeAt(el.number(),true);
		_Map.setMap("userPoints",mapUserPoints);
	}	
	
// trigger3:Delete all Points of all Elements					
	else if (_bOnRecalc && _kExecuteKey==sTrigger[3]) 
	{	
		mapGrips = Map();
		mapUserPoints= Map();					
		_Map.removeAt("userPoints",true);
	}			
	
// grip moved
	for (int i = 0; i < _PtG.length(); i++)
	{
		if (_kNameLastChangedProp == "_PtG" + i)	
		{
			//reportNotice("\n"+i+" moved");
			mapGrips.setPoint3d(i,_PtG[i]);
			mapUserPoints.setMap(el.number(),mapGrips);	
			_Map.setMap("userPoints",mapUserPoints);
			break;					
		}
	}
		
// restore grips
	_PtG.setLength(0);
	Point3d ptUserGrips[0];
	for (int i = 0; i < mapGrips.length(); i++)
	{
		if (mapGrips.hasPoint3d(i))
		{
			Point3d pt = mapGrips.getPoint3d(i);
			_PtG.append(pt);
			pt.transformBy(ps2ms);
			ptUserGrips.append(pt);
		}
	}
// END CODE SNIPPET to allow user defined grips with a layout dim______________________________________END CODE SNIPPET 



// build include/exclude lists
	String sList;
	
	
// color and zone lists
	int nIncludeZones[0];
	int nIncludeColors[0];
	int nIncludeColorsRef[0];
	int nExcludeColorsRef[0];	
	int nIncludeZonesRef[0];		
	
	for (int j=0;j<5;j++)
	{
		if (j==0)sList = sIncludeZone;
		else if (j==1)sList = sIncludeColor;
		else if (j==2)sList = sIncludeColorRef;
		else if (j==3)sList = sExcludeColorRef;
		else if (j==4)sList = sIncludeZoneRef;
		
		for (int i = 0; i < 3; i++)
		{
			while (sList.length()>0 || sList.find(";",0)>-1)
			{
				String sToken = sList.token(0);	
				sToken.trimLeft().trimRight().makeUpper();	
				int nToken = sToken.atoi();
				
				if (j==0) nIncludeZones.append(nToken);
				else if (j==1) nIncludeColors.append(nToken);
				else if (j==2) nIncludeColorsRef.append(nToken);
				else if (j==3) nExcludeColorsRef.append(nToken);
				else if (j==4) nIncludeZonesRef.append(nToken);
				
				int x = sList.find(";",0);
				sList.delete(0,x+1);
				sList.trimLeft();	
				if (x==-1)
					sList = "";	
			}
		}
	}	
		
// set zones if none were selected	
	if (nIncludeZones.length()<1)
	{
		int n[] = {-5,-4,-3,-2,-1,0,1,2,3,4,5};
		nIncludeZones=n;
		sIncludeZone.set("0;1;2;3;4;5;-1;-2;-3;-4;-5");	
		setExecutionLoops(2);
	}
	
	String sIncludeTsls[0];
	sList = sIncludeTsl;
	for (int i = 0; i < 3; i++)
	{
		while (sList.length()>0 || sList.find(";",0)>-1)
		{
			String sToken = sList.token(0);	
			sToken.trimLeft().trimRight();
			sToken.makeUpper();	
			sIncludeTsls.append(sToken);
			
			int x = sList.find(";",0);
			sList.delete(0,x+1);
			sList.trimLeft();	
			if (x==-1)
				sList = "";	
		}
	}	


// model vectors
	Vector3d vxM, vyM, vzM;
	vxM = _XW;
	vyM = _YW;
	vzM = _ZW;
	
	vxM.transformBy(ps2ms);
	vyM.transformBy(ps2ms);
	vzM.transformBy(ps2ms);

// get location
	Point3d ptOrgPS = ptOrg;
	ptOrgPS.transformBy(ms2ps);
	ptOrgPS.vis(3);
	//ptOrgPS.transformBy(ps2ms);
	
// collect relevant entities
	TslInst tslAll[0], tsls[0];

// collect tsls
	int nDebugTsl=false;
	tslAll = el.tslInstAttached();
	for (int i=0 ; i<tslAll.length();i++)
	{
		TslInst tsl = tslAll[i];
		String s = tsl.opmName();
		s.makeUpper();
		int c = tsl.color();
		int z = tsl.myZoneIndex();
		
	// validate include lists
		if (sIncludeTsls.length()>0 && sIncludeTsls.find(s)<0)
		{
			if (nDebugTsl)reportMessage("\n skip  "+s + " tsl name  " + s);	
			continue;
		}
		if (nIncludeColors.length()>0 && nIncludeColors.find(c)<0)
		{
			if (nDebugTsl)reportMessage("\n skip  "+s + " color " + c);	
			continue;
		}
		if (nIncludeZones.length()>0 && nIncludeZones.find(z)<0)
		{
			if (nDebugTsl)reportMessage("\n skip "+s + " zone " + z);	
			continue;
		}
		if (nDebugTsl)reportMessage("\n collecting "+s);	
		tsls.append(tsl);			
	}// next i of tslAll		
	if (nDebugTsl)reportMessage("\n" +tsls.length()+" collected");	


// declare a shadow pp
	PlaneProfile ppShadow, ppZoneShadow[11];
	
// collect genbeams
	GenBeam gbAll[0], gbThis[0];
	gbAll = el.genBeam();
	
	for (int g=0 ; g<gbAll.length();g++)
	{
		GenBeam gb = gbAll[g];
		if (gb.bIsDummy())continue;
		int z = gb.myZoneIndex();
		String m = gb.material();
		int c = gb.color();
		//if(nDebug>0)reportNotice("\nZ:" + z + "  c: " + c + " m: " +m);

	// validate include lists
		if (nIncludeZonesRef.length()>0 && nIncludeZonesRef.find(z)<0)
		{
			if (nDebugTsl)reportMessage("\nZone " + z + " excluded");	
			continue;
		}
		if (nIncludeColorsRef.length()>0 && nIncludeColorsRef.find(c)<0)
			continue;
	// validate exclude lists		
		//if (m!="" && sArExcludeMaterial.find(m)>-1) continue;
		if (nExcludeColorsRef.find(c)>-1) continue;

		
	// get shadow
		PlaneProfile pp = gb.envelopeBody(false,true).shadowProfile(Plane(ptOrg,vzM));
		//gb.realBody().vis(g);
		pp.shrink(-dEps);
		//pp.vis(g);
	
	// add to shadow	
		if (ppShadow.area()<pow(dEps,2))
			ppShadow = pp;
		else
			ppShadow.unionWith(pp);	
	
	// add to zone shadow
		int x=z+5;
		if (ppZoneShadow[x].area()<pow(dEps,2))
			ppZoneShadow[x]= pp;
		else
			ppZoneShadow[x].unionWith(pp);	
								
		if (nIncludeZonesRef.find(z)<0)continue;
		

	
		gbThis.append(gb);
	}	
	if (nDebugTsl)reportMessage("\n" +gbThis.length()+" genbeams collected");	
		
// adjust shadow	
	ppShadow.shrink(dEps);
	for (int z=0;z<ppZoneShadow.length();z++)
		if (ppZoneShadow[z].area()>pow(dEps,2))
		{
			ppZoneShadow[z].shrink(dEps);
		}
		else if (nDebugTsl)reportMessage("\n Zone PP = 0 " +(z-5));

	//ppShadow.shrink(-U(100));
	
// get envelope
	// get all rings
	PLine plRings[0];
	int bIsOp[0];
// get all rings
	plRings=ppShadow.allRings();
	bIsOp=ppShadow.ringIsOpening();
	PLine plContour(vzM);
	for (int r=0; r<plRings.length(); r++)
	{
		if (!bIsOp[r] && plContour.area()<plRings[r].area())
			plContour=plRings[r];
	}

// the dimline vectors
	Vector3d vxDimline=_XW, vyDimline=_YW;
	int nFlip=1;
	if (_YW.dotProduct(ptOrgPS-_Pt0)<0)nFlip*=-1;
	
// declare hor and vertical dimlines to collect points
	Point3d ptsHor[0],ptsVer[0];
	
	
// ADD POINTS
// add tsls	
	Point3d ptsTslOrg[0];
	for (int i=0 ; i<tsls.length();i++)
	{
		TslInst tsl = tsls[i];
		int bHasDimRequest = tsl.map().getMap("DimRequest[]").length()>0;
		Point3d pt = tsl.ptOrg();
		if(!bHasDimRequest && nDisplayModeHorDelta != _kDimNone || nDisplayModeHorChain != _kDimNone)	ptsHor.append(pt);
		if(!bHasDimRequest && nDisplayModeVerDelta != _kDimNone || nDisplayModeVerChain != _kDimNone)	ptsVer.append(pt);
		if (bTslByInstance)
			ptsTslOrg.append(pt);
	}

// opening and/or element ref, collect closest
// x: 0=horizontal, 1= vertical
	int nRefMode = nRefModeHor;
	Vector3d vecRef = vxM;
	Point3d ptsRef[0], ptsRefVer[0], ptsRefHor[0];
	ptsRef = ptsHor;
	for (int x=0 ; x<2;x++)
	{	
	// add zone ref
		if (nRefMode<2)
		{
			PlaneProfile pps[0];
		// element ref, combine all selected zones
			if (nRefMode==0 && nIncludeZonesRef.length()>0)pps.append(ppShadow);
		// element ref, no selected zones, take contour	
			else if (nRefMode==0 && nIncludeZonesRef.length()==0)pps.append(PlaneProfile(el.plEnvelope()));	
		// refernce zone take all zones	
			else pps = ppZoneShadow;
			
			for (int z=0;z<pps.length();z++)
			{
				if (pps[z].area()<pow(dEps,2)) continue;
				
				pps[z].vis(z);
				LineSeg seg = pps[z].extentInDir(vecRef);			
			// horizontal			
				if(x==0)
				{
						ptsRefHor.append(seg.ptStart());
						ptsRefHor.append(seg.ptEnd());
				}
			// vertical	
				else if( x==1)
				{
					seg.vis(z);
					ptsRefVer.append(seg.ptStart());
					ptsRefVer.append(seg.ptEnd());
				}
			}	
		}		
		
	
		else if (nRefMode>=2 && nRefMode<=4)
		{
			Point3d ptsNew[0];
			for (int p=0 ; p<ptsRef.length();p++)
			{
				double dMin = U(200000);
				Point3d pt=ptsRef[p];
	
			// find closest to opening	
				if(nRefModeHor==2 || nRefModeHor==3)
				{	
					for (int o=0 ; o<openings.length();o++)
					{
						LineSeg seg = PlaneProfile(openings[o].plShape()).extentInDir(vecRef);
						Point3d pts[] = {seg.ptStart(),seg.ptEnd()};
						for (int i=0 ; i<pts.length();i++)
						{
							double d1 = abs(vecRef.dotProduct(ptsRef[p]-pts[i]));
							if (d1<dMin)
							{
								dMin = d1;
								pt = pts[i];	
							}
					 	}// next i	
					}// next o	
				}
						
			// horizontal: connected elements		
				if(x==0 && (nRefModeHor==3 || nRefModeHor==4))
				{	
				// detect side of relevant point
					int nSide =1;
					if (vz.dotProduct(ptsRef[p]-ptCenElement)<0)nSide*=-1;	
					
				// find closest to connected wall	
					for (int e=0 ; e<elConnected.length();e++)
					{
						PLine plConnected = elConnected[e].plOutlineWall();
						Point3d pts[]= plConnected.vertexPoints(true);
						Point3d ptCenConnected;
						ptCenConnected.setToAverage(pts);
						
						int nSideConnected =1;
						if (vz.dotProduct(ptCenConnected-ptCenElement)<0)nSideConnected*=-1;
						
						if (nSide == nSideConnected)
						{
							for (int i=0 ; i<pts.length();i++)
							{
								double d1 = abs(vecRef.dotProduct(ptsRef[p]-pts[i]));
								if (plOutlineWall.isOn(pts[i]) && d1<dMin)
								{
									dMin = d1;
									pt = pts[i];							
								}	
							}
						}			
					}
				}
			// vertical: connected elements		
				else if(x==1 && (nRefModeHor==3 || nRefModeHor==4))
				{	
					Point3d pts[]= plContour.vertexPoints(true);
					for (int i=0 ; i<pts.length();i++)
					{
						double d1 = abs(vecRef.dotProduct(ptsRef[p]-pts[i]));
						if (d1<dMin)
						{
							dMin = d1;
							pt = pts[i];							
						}	
					}					
				}				
				
				if(abs(vecRef.dotProduct(ptsRef[p]-pt))>dEps)
					ptsNew.append(pt);
					
			}// next p point
			if (x==0) ptsRefHor.append(ptsNew);	
			else if (x==1) ptsRefVer.append(ptsNew);			
		}
		nRefMode = nRefModeVer;
		vecRef = vyM;
	}

// add user grips
	ptsHor.append(ptUserGrips);
	ptsVer.append(ptUserGrips);

// add ref to points
	ptsHor.append(ptsRefHor);	
	if(bTslByInstance)
	{	
	// reset standard vertical dimpoints
		ptsVer.setLength(0);
	
	// order tsls along _XW to alternate left and right location	
		for (int i=0; i<tsls.length();i++)
			for (int j=0; j<tsls.length()-1;j++)
			{
				Point3d pt1=tsls[j].ptOrg(); pt1.transformBy(ms2ps);
				Point3d pt2=tsls[j+1].ptOrg(); pt2.transformBy(ms2ps);
				if (_XW.dotProduct(pt1-pt2)>0)
					tsls.swap(j,j+1);
			}
		
	// create local dimlines
		int bOnTop=true;
		for (int i=0; i<tsls.length();i++)
		{
			Point3d ptOrg = tsls[i].ptOrg();
			double dOffsetY;
			Point3d ptsDim[0]; ptsDim= ptsRefVer;
		// get potential dimRequest map
			Map mapRequests = tsls[i].map().getMap("DimRequest[]");
			if (mapRequests.length()>1)
			{
				for (int m=0;m<mapRequests.length();m++)
				{
					Map mapRequest = mapRequests.getMap(m);
					Vector3d vecZView = mapRequest.getVector3d("AllowedView");
					vecZView.transformBy(ms2ps);
				// only requests with this view direction
					if (vecZView.isParallelTo(_ZW))
					{
						Vector3d vecXDim = mapRequest.getVector3d("vecX");	vecXDim .transformBy(ms2ps);
						if (!vecXDim.isParallelTo(_YW))continue;
						Vector3d vecYDim = mapRequest.getVector3d("vecY");	vecYDim .transformBy(ms2ps);			
						ptsDim.append(mapRequest.getPoint3dArray("ptDim[]"));
						dOffsetY=mapRequest.getDouble("offsetY")/ps2ms.scale();
						
					}
				}// next m	
			}
			else
				ptsDim.append(ptOrg);
			
		// transform to paperspace
			for (int p=0; p<ptsDim.length();p++)
				ptsDim[p].transformBy(ms2ps);	
			ptOrg.transformBy(ms2ps);	
			
		/// order in dim direction	
			Line lnY(ptOrg,_YW);
			ptsDim= lnY.orderPoints(lnY.projectPoints(ptsDim));
			//for (int p=0; p<ptsDim.length();p++)ptsDim[p].vis(5);
		
		// transform dimline location alternating
			if(bOnTop)dOffsetY*=-1;
			ptOrg.transformBy(_XW*dOffsetY);
			
		// declare dim and draw
			DimLine dl(ptOrg ,_YW,-_XW);	
			Dim dim(dl,ptsDim, "<>","{<>}",nDisplayModeVerDelta,nDisplayModeVerChain);
			dim.setDeltaOnTop(bOnTop);
			dim.setReadDirection(-_XW+_YW);
			dp.draw(dim);	
			
		// swap on top
			if (bOnTop)bOnTop=false;
			else bOnTop=true;			
		}	
	}
// vertical dimline not by tsl reference (DimRequestChain) but as dimRequestPoint	
	else
	{
		ptsVer.append(ptsRefVer);	
	}
	
// dimlines of tsl reference as dimRequestPoint			
	for (int i=0; i<tsls.length();i++)
	{
		Point3d ptOrg = tsls[i].ptOrg();
	// get potential dimRequest map
		Map mapRequests = tsls[i].map().getMap("DimRequest[]");
		if (mapRequests.length()>0)
		{
			for (int m=0;m<mapRequests.length();m++)
			{
				Map mapRequest = mapRequests.getMap(m);
				Vector3d vecZView = mapRequest.getVector3d("AllowedView");
				vecZView.transformBy(ms2ps);
			// only requests with this view direction
				if (vecZView.isParallelTo(_ZW))
				{
					Vector3d vecXDim = mapRequest.getVector3d("vecX");	vecXDim .transformBy(ms2ps);			
					if (vecXDim.isParallelTo(_XW))ptsHor.append(mapRequest.getPoint3dArray("ptDim[]"));
					if (vecXDim.isParallelTo(_YW) && !bTslByInstance)ptsVer.append(mapRequest.getPoint3dArray("ptDim[]"));
				}
			}// next m	
		}
		else
		{
			ptsHor.append(ptOrg);
			if (!bTslByInstance)ptsVer.append(ptOrg);
		}		
	}		

	

// flag to draw alias
	int bDrawAlias=sDescAlias.length()>0;
	if (sIncludeTsls.length()>0 && tsls.length()<1)
	{
		return;
		//bDrawAlias=false;
	}

	
// order points	
	ptsHor = Line(ptOrg,vxM).orderPoints(Line(ptOrg,vxM).projectPoints(ptsHor));	
	ptsVer = Line(ptOrg,vyM).orderPoints(Line(ptOrg,vyM).projectPoints(ptsVer));	

	plContour.transformBy(ms2ps);
	plContour.vis(1);

// horizontal / vertical dims
	int nDisplayModeDelta=nDisplayModeHorDelta;
	int nDisplayModeChain=nDisplayModeHorChain;	

// initially start with horizontal points
	Point3d ptsDim[0];
	ptsDim = ptsHor;
	// loop hor and ver
	for (int xy=0;xy<2;xy++)	
	{
		for (int i=0;i<ptsDim.length();i++)
		{
			ptsDim[i].transformBy(ms2ps);
			ptsDim[i].transformBy(_ZW*_ZW.dotProduct(_Pt0-ptsDim[i]));
			
		// snap to outline contour
			Point3d pt = ptsDim[i];
			Point3d ptNext[] = plContour.intersectPoints(Plane(pt,vxDimline));
			ptNext = Line(pt,nFlip*vyDimline).orderPoints(ptNext);
			if (ptNext.length()>0)	pt=ptNext[0];			
			
			pt.vis(i);
			ptsDim[i]=pt;
		}
	
	// continue if no dim points found
		if (ptsDim.length()>1 && (nDisplayModeDelta!=_kDimNone || nDisplayModeChain!=_kDimNone))
		{	
		// create dimline
			DimLine dl(_Pt0,vxDimline,vyDimline);
			Dim dim(dl,ptsDim, "<>","{<>}",nDisplayModeDelta,nDisplayModeChain);
			if (nFlip==1)
				dim.setDeltaOnTop(false);
			else
				dim.setDeltaOnTop(true);		
			dim.setReadDirection(-_XW+_YW);
	
			dp.draw(dim);
		}
			
	// vertical points		
		ptsDim=ptsVer;
		vxDimline=_YW;
		vyDimline=-_XW;
		nFlip=1;
		nDisplayModeChain=nDisplayModeVerChain;//nDisplayModes[nDisplayModeVerChain];	
		nDisplayModeDelta=nDisplayModeVerDelta;//nDisplayModes[nDisplayModeVerDelta];
		if (_XW.dotProduct(ptOrgPS-_Pt0)>0)nFlip*=-1;
		
	}// next xy


// draw alias	
	if (bDrawAlias)
	{
		Point3d ptMid;
		ptMid.setToAverage(plContour.vertexPoints(true));
		double dXFlag=-1;
		if (_XW.dotProduct(_Pt0-ptMid)>0)dXFlag*=-1;	
		dp.draw(sDescAlias,_Pt0,_XW,_YW, dXFlag, 0);
	}
	
			



#End
#BeginThumbnail
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
A6L%O`D%O$D,0'"1J%'Z5-:M4C9-_=_7^1=.G![?B?__9
`








#End