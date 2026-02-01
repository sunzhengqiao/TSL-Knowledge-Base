#Version 8
#BeginDescription
version value="1.1" date="17Apr2018" author="thorsten.huck@hsbcad.com"
translation issue fixed
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
/// <History>//region
/// <version value="1.1" date="17Apr2018" author="thorsten.huck@hsbcad.com"> translation issue fixed </version>
/// <version value="1.0" date="23Oct2017" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select properties or catalog entry, select polylines or circles or specify a set of points,  and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates CNC drills as masterpanel tools.
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
	//endregion

	int nColors[] ={ 3,4};

	category = T("|Geometry|");

	String sDiameterName="(A)  "+T("|Diameter|");	
	PropDouble dDiameter(nDoubleIndex++, U(10), sDiameterName);	
	dDiameter.setDescription(T("|Defines the Diameter of the drill(s)|") + " " + T("|0 = select circles|"));
	dDiameter.setCategory(category);


	String sDepthName="(B)  "+T("|Depth|");	
	PropDouble dDepth(nDoubleIndex++, U(10), sDepthName);	
	dDepth.setDescription(T("|Defines the Depth|") + " " + T("|0 = complete through|"));
	dDepth.setCategory(category);

	String sToolindexName="(C)  "+T("|Toolindex|");	
	PropInt nToolindex(nIntIndex++, 0, sToolindexName);	
	nToolindex.setDescription(T("|Defines the Toolindex|"));
	nToolindex.setCategory(category);


	// alignment
	category = T("|Alignment|");

	int nFaces[]={ 1, -1};
	String sFaces[]= {T("|Top|"),T("|Bottom|")};
	String sFaceName="(D)  "+T("|Alignment|");	
	PropString sFace(nStringIndex++, sFaces, sFaceName,1);	
	sFace.setDescription(T("|Defines the Face|"));
	sFace.setCategory(category);
	
	String sInterdistanceName="(E)  "+ T("|Interdistance|");
	PropDouble dInterdistance(nDoubleIndex++, U(0),sInterdistanceName);
	dInterdistance.setDescription(T("|Sets the Interdistance of a distribution|"));		
	dInterdistance.setCategory(category);
	
	String sDistributionModes[] = {T("|Disabled|"),T("|Even Distribution|"), T("|Fixed Distribution|")};
	String sDistributionModeName= "(F)  "+T("|Mode|");
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


	// ints
		int nDistributionMode = sDistributionModes.find(sDistributionMode, 0);

	// prepare tsl cloning
		TslInst tslNew;
		GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};		Point3d ptsTsl[] = {};
		int nProps[]={nToolindex};	double dProps[]={dDiameter,dDepth,dInterdistance};	String sProps[]={sFace,sDistributionMode};
		Map mapTsl;	
		String sScriptname = scriptName();


	// select master
		MasterPanel master = getMasterPanel();
		_Entity.append(master);

	// prompt for polylines and/or circles
		Entity ents[0];
		
		if (dDiameter<=0 || nDistributionMode!=0)
		{ 
			PrEntity ssEpl(T("|Select polyline(s) and/or circle(s)|") + " " + T("|<Enter> to pick points|"), Entity());
		  	if (ssEpl.go())
				ents.append(ssEpl.set());
			for (int i=0;i<ents.length();i++) 
			{ 
				Entity ent = ents[i]; 
				String s = ent.typeDxfName();
				if (s=="LWPOLYLINE" || s=="CIRCLE")
				{
					if (bDebug)reportMessage("\nappending " + s);
					_Entity.append(ent);
				}	
			}			
		}

	
	// point mode
		if (_Entity.length() < 2)
		{
			
		// wrong dialog input
			if (dDiameter<=0)
			{ 
				double d = getDouble(T("|Enter diameter|"));
				if (d<=0)
				{ 
					reportMessage("\n"+ scriptName() + ": "+ T("|invalid diameter|")+ " "+ T("|Tool will be deleted.|"));
					eraseInstance();
					return;	
				}
				else
				{
					dProps[0] = d;
					dDiameter.set(d);
				}
			}

			
			int nColor=3;
			Point3d ptRef = master.coordSys().ptOrg();
			Plane pnRef(ptRef, _ZW);
		
		// distribution mode	
			EntPLine eplJig;
			PLine pl;		
			int bDistribute = dInterdistance > 0 && nDistributionMode>0;
			
			Point3d pts[0];
			Point3d ptLast = getPoint(bDistribute?TN("|Select start point|"):TN("|Pick point|"));
			pts.append(ptLast);
		

			if (bDistribute)
				pl.addVertex(ptLast);
			else
			{ 
				ptsTsl.setLength(0);
				ptsTsl.append(ptLast);
				
				entsTsl.setLength(0);
				entsTsl.append(_Entity[0]);

				tslNew.dbCreate(sScriptname , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, 
					nProps, dProps, sProps,_kModelSpace, mapTsl);
			}
			
			while (1)
			{
				PrPoint ssP2(TN("|Select next point|"), ptLast);
				if (ssP2.go() == _kOk)
				{
					if (eplJig.bIsValid())
						eplJig.dbErase();
					
					ptLast = ssP2.value();
					pts.append(ptLast);
					
				// distribution
					if (bDistribute)
					{
						pl.addVertex(ptLast);
						pl.projectPointsToPlane(pnRef, _ZW);
					
						eplJig.dbCreate(pl);
						eplJig.setColor(nColor);
					}	
					
				// create a new instance
					else
					{ 
						ptsTsl[0] = ptLast;
						tslNew.dbCreate(sScriptname , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, 
							nProps, dProps, sProps,_kModelSpace, mapTsl);						
					}
				}
				else { //no proper selection
					if (eplJig.bIsValid())
						eplJig.dbErase();
					break; //out of infinite while
				}
			}
			
		// erase caller if not in distribution mode
			if (!bDistribute)
			{ 
				eraseInstance();
				return;
			}
			
			
		// create point based instance
			if (pts.length() > 1)
			{
				Point3d pt;
				pt.setToAverage(pts);
				_Pt0 = pt;
				_PtG.append(pts);
			}
		}
	// polyline / circle dependent, creates n  new instances and caller will be erased
		else
		{ 
		// loop plines or circles for one on one creation
			for (int i=1;i<_Entity.length();i++) 
			{ 
				Entity ent = _Entity[i];
				PLine pl = ent.getPLine();
				if (pl.length()<dEps || !pl.coordSys().vecZ().isParallelTo(_ZW))
				{
					if (bDebug)reportMessage("\n" + ent.handle() + " refused");
					continue;
				}
			
				Point3d pt;
				pt.setToAverage(pl.vertexPoints(true));
				
				ptsTsl.setLength(0);
				ptsTsl.append(pt);
				
				entsTsl.setLength(0);
				entsTsl.append(_Entity[0]);
				entsTsl.append(_Entity[i]);
	 
				tslNew.dbCreate(sScriptname , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, 
					nProps, dProps, sProps,_kModelSpace, mapTsl);	
	 
			}
			
		// erase caller	
			eraseInstance();
		}	
	
		return;
	}	
// end on insert	__________________


// get master and potential defining entity
	MasterPanel master;
	PLine plDefining;
	int bIsCircle;
	for (int i=0;i<_Entity.length();i++) 
	{ 
		Entity ent= _Entity[i]; 
		if (ent.bIsKindOf(MasterPanel()) && !master.bIsValid())
		{ 
			master = (MasterPanel)ent;
		}
		else if (plDefining.length()<dEps)
		{ 
			PLine pl = ent.getPLine();
			if(pl.length()>dEps)
			{
				plDefining = pl;
				setDependencyOnEntity(ent);
				bIsCircle = ent.typeDxfName()=="CIRCLE";
			}
		}
		
	}

// get ints
	int _nFace = sFaces.find(sFace, 0);
	int nFace = nFaces[_nFace];
	int nDistributionMode = sDistributionModes.find(sDistributionMode, 0);
	int bFlipNormal;
	int bDistribute = dInterdistance > 0 && nDistributionMode>0;
	
	if (nDistributionMode==0)
	{ 
		dInterdistance.set(0);
		dInterdistance.setReadOnly(true);
	}
	
// TriggerFlipSide
	String sTriggerFlipFace= T("|Flip Face|");
	addRecalcTrigger(_kContext, sTriggerFlipFace );
	if (_bOnRecalc && (_kExecuteKey==sTriggerFlipFace || _kExecuteKey==sDoubleClick))
	{
		nFace *= -1;
		_nFace = nFaces.find(nFace, 0);
		sFace.set(sFaces[_nFace]);

		setExecutionLoops(2);
		return;
	}




// set the color
	_ThisInst.setColor(nColors[_nFace]);

// coordSys
	CoordSys csMP = master.coordSys();
	Point3d ptSurface = csMP.ptOrg(); // coordSys of MasterPanel is on surface
	Vector3d vecX = csMP.vecX();
	Vector3d vecY = csMP.vecX();
	Vector3d vecZ = csMP.vecZ();	

	double dOffset = 0;
	if (nFace < 0)
	{ 
		vecX *= -1;
		vecZ *= -1;
		dOffset = -master.dThickness();
		bFlipNormal = true;
	}
	
// make sure that the normal of the circle matches the masterpanel coordSys
	if (bIsCircle)
	{
		plDefining.setNormal(vecZ);
		vecZ.vis(_Pt0, 150);
	}
	

// assign drill depth
	double dDrillDepth = dDepth<=0?master.dThickness():dDepth;
	PLine plPath(vecZ); 
	
// ref plane
	_Pt0 -= (dOffset + vecZ.dotProduct(_Pt0 - ptSurface)) * vecZ;
	for (int i=0;i<_PtG.length();i++) 
	{ 
		_PtG[i]-= (dOffset + vecZ.dotProduct(_PtG[i] - ptSurface)) * vecZ; 
		 
	}

	Plane pn(_Pt0, vecZ);
	if (plDefining.length() > 0)
		plDefining.projectPointsToPlane(pn, vecZ);


// recalc _Pt0 in grip mode
	if (_kNameLastChangedProp.find("_PtG",0)>-1)
		_Pt0.setToAverage(_PtG);


// collector of all drill locations
	Point3d ptsLocs[0];

// Circle: get diameter and location from defining entity
	if (plDefining.length() > 0 && bIsCircle)
	{
		CoordSys cs = plDefining.coordSys();
		PlaneProfile pp(cs);
		pp.joinRing(plDefining, _kAdd);
		
		// get extents of profile
		LineSeg seg = pp.extentInDir(vecX);
		double dX = abs(vecX.dotProduct(seg.ptStart() - seg.ptEnd()));
		double dY = abs(vecY.dotProduct(seg.ptStart() - seg.ptEnd()));
		
		// just a line
		if (dX <= dEps)
		{
			_Pt0 = plDefining.ptMid();
			dX = plDefining.length();
		}
		else
			_Pt0 = seg.ptMid();
		ptsLocs.append(_Pt0);
		dDiameter.set(dX);
		dDiameter.setReadOnly(true);
	
		dInterdistance.set(0);
		dInterdistance.setReadOnly(true);
		sDistributionMode.setReadOnly(true);	
	}
// Circle: get diameter and location from defining entity
	else if (plDefining.length() > 0 && !bIsCircle)
		plPath = plDefining;
// get locations from grip points
	else if (!bDistribute && _PtG.length()>0)
		ptsLocs = _PtG;
// get locations as distribution
	else if (_PtG.length()>1)
	{ 
	// get path specified by grip points
		for (int i=0;i<_PtG.length();i++) 
			plPath.addVertex(_PtG[i]);
	}
// single drill	
	else
	{
		dInterdistance.set(0);
		dInterdistance.setReadOnly(true);
		sDistributionMode.setReadOnly(true);
		ptsLocs.append(_Pt0);
	}
	
	
// get locations from path
	if (plPath.length()>0 && dInterdistance>0)
	{ 
		double dPathLength = plPath.length();
		int nNumDrill = dPathLength / dInterdistance;			
			
			
	// visualize the path
		Display dp(_ThisInst.color());
		dp.draw(plPath);
			
		double dOffset = nDistributionMode==2?dInterdistance:dPathLength/ nNumDrill;
		
	// distribute
		for (int i=0;i<=nNumDrill;i++) 
		{ 
			Point3d ptLoc = plPath.getPointAtDist(i * dOffset);
			//ptLoc.vis(i);
			ptsLocs.append(ptLoc);
		}		
	}
// get locations from path vertices
	else if (plPath.length()>0)
		ptsLocs.append(plPath.vertexPoints(true));
	
// Trigger release
	String sTriggerRelease= T("|Release dependency|");
	if(ptsLocs.length()>1 || (ptsLocs.length()>0 && plPath.length()<dEps ))
		addRecalcTrigger(_kContext, sTriggerRelease );
	if (_bOnRecalc && _kExecuteKey==sTriggerRelease)
	{
		if (plDefining.length()>0 && ptsLocs.length()==1)
		{
			Entity ents[] = { master};
			_Entity = ents;
		}
		else
		{ 
			TslInst tslNew;
			GenBeam gbsTsl[] = {};		Entity entsTsl[] = {master};		Point3d ptsTsl[1];// = {};
			int nProps[]={nToolindex};	
			double dProps[]={dDiameter,dDepth,0};	// interdistance = 0)
			String sProps[]={sFace,sDistributionMode};
			Map mapTsl;	
			String sScriptname = scriptName(); 
			
			for (int i=0;i<ptsLocs.length();i++) 
			{ 
				ptsTsl[0] = ptsLocs[i]; 
				tslNew.dbCreate(sScriptname , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, 
					nProps, dProps, sProps,_kModelSpace, mapTsl);
			}
		// erase caller	
			eraseInstance();
			return;
		}
		setExecutionLoops(2);
		return;
	}	
	

// add tool at locations
	Vector3d vecDrill = -vecZ;
	for (int i=0;i<ptsLocs.length();i++) 
	{ 
		ElemDrill tool(0, ptsLocs[i], vecDrill, dDrillDepth, dDiameter, nToolindex);
		master.addTool(tool); 
	}
	
			
		
#End
#BeginThumbnail
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
?`****`"BBB@`HHHH`****`"BBB@`HHHH`****`/_V8HH
`


#End
#BeginMapX

#End