#Version 8
#BeginDescription
version  value="1.3" date="11mar14" author="th@hsbCAD.de"
bugfix multiple openings


This TSL creates naillines on a sheeting zone in dependency of the sheeting in the zone below.



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This TSL creates naillines on a sheeting zone in dependency of the sheeting in the zone below.
/// </summary>

/// <insert Lang=en>
/// Enter properties and select oen or multiple elements
/// </insert>

/// History
///<version  value="1.3" date="11mar14" author="th@hsbCAD.de"> bugfix multiple openings </version>
///<version  value="1.2" date="29feb12" author="th@hsbCAD.de">color filter bugfix</version>
///<version  value="1.1" date="23feb12" author="th@hsbCAD.de">insert bugfix</version>
///<version  value="1.0" date="22feb12" author="th@hsbCAD.de">initial</version>


// basics and props
	U(1,"mm");
	double dEps = U(.1);
	int bDebug = false;
	String sPropDesc = T("|Separate multiple entries by|")+ " ' ;'";
	
	PropInt nToolingIndex(0,1,T("|Tool Index|") );
	int nArZone[] = {-5,-4,-3,-2,-1,1,2,3,4,5};
	PropInt nZone(1,nArZone,T("|Zone|") );
	PropDouble dSpacing(0,U(50), T("|Spacing|"));
	dSpacing.setDescription(T("|Defines the spacing of a nailline|"));
	PropDouble dEdgeOffset(1,U(20), T("|Edge Offset|"));//+ " " + T("|Default|"));
	dEdgeOffset.setDescription(T("|Defines the edge offset from the sheeting zone|"));
	//PropDouble dEdgeOffsetTop(5,U(0),"   " + T("|Edge Offset|") + " " + T("|Top|") + " " + T("|0=Default|"));	
	//PropDouble dEdgeOffsetSloped(6,U(0), "   " + T("|Edge Offset|") + " " + T("|Sloped|")+ " " + T("|0=Default|"));
	//PropDouble dEdgeOffsetVertical(7,U(0), "   " + T("|Edge Offset|") + " " + T("|Vertical|")+ " " + T("|0=Default|"));
	PropDouble dMerge(2,0, T("|Merge Gaps|") + " " + T("|0=do not merge|"));
	dMerge.setDescription(T("|If greater than 0 gaps between sheets will be merged|"));
	PropDouble dIgnoreArea(3,0, T("|Ignore Holes with length|") + " " + T("|0=do not ignore|"),_kArea);

	PropString sExcludeMaterial(0,"",T("|Exclude entities with|") + " " +  T("|Material|"));	
	sExcludeMaterial.setDescription(sPropDesc);
	PropString sExcludeColor(1,"","   " + T("|Exclude entities with|") + " " +  T("|Color|"));	
	sExcludeColor.setDescription(sPropDesc);
	
	PropString sIncludeMaterial(2,"",T("|Include entities with|") + " " +  T("|Material|"));	
	sIncludeMaterial.setDescription(sPropDesc);
	PropString sIncludeColor(3,"","   " + T("|Include entities with|") + " " +  T("|Color|"));	
	sIncludeMaterial.setDescription(sPropDesc);
			
	
	String sArOrientation[] = {T("|Horizontal|"),T("|Vertical|")};
	PropString sOrientation(4,sArOrientation, T("|Orientation|"),1);	
		sOrientation.setDescription(T("|The orientation of intermediate naillines|"));
	PropDouble dNailModule(4,U(410),"   " +  T("|Module|"));	
		dNailModule.setDescription(T("|The maximal offset of intermediate naillines|"));
	
// declare arrays for tsl cloning
	TslInst tslNew;
	Vector3d vUcsX = _X0;
	Vector3d vUcsY = _Y0;
	GenBeam gbAr[0];
	Entity entAr[1];
	Point3d ptAr[1];
	int nArProps[0];
	double dArProps[0];
	String sArProps[0];
	Map mapTsl;
	String sScriptname = scriptName().makeUpper();

// on insert
	if (_bOnInsert){
		if (insertCycleCount()>1) { eraseInstance(); return; }
		
		// set properties from catalog
		if (_kExecuteKey!="")
			setPropValuesFromCatalog(_kExecuteKey);
		else		
			showDialog();
			
		// selection of element		
		PrEntity ssEl(T("Select Element"), Element());
		Element el[0];
  		if (ssEl.go())
    		el = ssEl.elementSet();


	// loop elements			
		for (int i = 0; i < el.length(); i++)
		{
			
			// check if this script is already attached to the element
			TslInst tslList[] = el[i].tslInst();
			int bOk = true;
			
			for (int t = 0; t < tslList.length(); t++)
			{
				if (tslList[t].scriptName().makeUpper()== sScriptname&& tslList[t].bIsValid())
					bOk = false;
			}// next t
			
			if (bOk)
			{
			// remove existing nail lines
				NailLine nlOld[] = el[i].nailLine(nZone);
				for (int n=0; n<nlOld.length(); n++) 
				{
					NailLine nl = nlOld[n];
					//int nCol = nl.color();
					//if (nl.color()==nToolIndex)
						nl.dbErase();
				}	
				
				entAr[0] = el[i];
				ptAr[0] = el[i].ptOrg();
				vUcsX=el[i].vecX();
				vUcsY=el[i].vecY();
				tslNew.dbCreate(sScriptname, vUcsX,vUcsY,gbAr, entAr, ptAr, 
					nArProps, dArProps, sArProps,_kModelSpace, mapTsl); // create new instance	
				if (tslNew.bIsValid())
				{
					tslNew.setPropValuesFromCatalog(T("|_LastInserted|"));
					reportMessage("\n" + T("Element")+ " " + el[i].number() + ": " + T("|data successfully appended.|"));
				}
			}		
			else
				reportMessage("\n" + T("Element")+ " " + el[i].number() + ": " + T("|has aleady data attached. no data appended.|"));
		}// next i		
	
	// erase the caller	
		eraseInstance();
		return;
	}	
//end on insert________________________________________________________________________________

// validate
	if (_Element.length() < 1)
	{
		eraseInstance();
		return;
	}

// standards
	Element el = _Element[0];
	CoordSys cs;
	Point3d ptOrg;
	Vector3d vx,vy,vz;

	cs = el.coordSys();
	ptOrg = cs.ptOrg();	
	vx=cs.vecX();
	vy=cs.vecY();
	vz=cs.vecZ();
	
	vx.vis(ptOrg, 1);
	vy.vis(ptOrg, 3);
	vz.vis(ptOrg, 150);

	assignToElementGroup(el, TRUE,nZone, 'E');		

// ints
	int nOrientation =sArOrientation.find(sOrientation,0);
	Vector3d vecArOrientation[]= {el.vecY(),el.vecX()};
	Vector3d vecO=vecArOrientation[nOrientation];
	vecO.vis(_Pt0,30);
	
// build include/exclude lists
	String sList;
	int nArExcludeColor[0];
	sList = sExcludeColor;
	for (int i = 0; i < 3; i++)
	{
		while (sList.length()>0 || sList.find(";",0)>-1)
		{
			String sToken = sList.token(0);	
			sToken.trimLeft().trimRight().makeUpper();	
			int nToken = sToken.atoi();
			nArExcludeColor.append(nToken);
			
			int x = sList.find(";",0);
			sList.delete(0,x+1);
			sList.trimLeft();	
			if (x==-1)
				sList = "";	
		}
	}

	int nArIncludeColor[0];
	sList = sIncludeColor;
	for (int i = 0; i < 3; i++)
	{
		while (sList.length()>0 || sList.find(";",0)>-1)
		{
			String sToken = sList.token(0);	
			sToken.trimLeft().trimRight().makeUpper();	
			int nToken = sToken.atoi();
			nArIncludeColor.append(nToken);
			
			int x = sList.find(";",0);
			sList.delete(0,x+1);
			sList.trimLeft();	
			if (x==-1)
				sList = "";	
		}
	}

	String sArExcludeMaterial[0];
	sList = sExcludeMaterial;
	for (int i = 0; i < 3; i++)
	{
		while (sList.length()>0 || sList.find(";",0)>-1)
		{
			String sToken = sList.token(0);	
			sToken.trimLeft().trimRight().makeUpper();	
			sArExcludeMaterial.append(sToken);
			
			int x = sList.find(";",0);
			sList.delete(0,x+1);
			sList.trimLeft();	
			if (x==-1)
				sList = "";	
		}
	}	
	String sArIncludeMaterial[0];
	sList = sIncludeMaterial;
	for (int i = 0; i < 3; i++)
	{
		while (sList.length()>0 || sList.find(";",0)>-1)
		{
			String sToken = sList.token(0);	
			sToken.trimLeft().trimRight().makeUpper();	
			sArIncludeMaterial.append(sToken);
			
			int x = sList.find(";",0);
			sList.delete(0,x+1);
			sList.trimLeft();	
			if (x==-1)
				sList = "";	
		}
	}	

		
// debug
	Display dp(nToolingIndex);
	if (bDebug)dp.draw(scriptName(),ptOrg,vx,vy,1,0,_kDevice);
	
// collect relevant entities
	GenBeam gbAll[0], gbOther[0], gbThis[0];
	gbAll = el.genBeam();
	int nSgn = -(nZone/-nZone);
	for (int g=0 ; g<gbAll.length();g++)
	{
		GenBeam gb = gbAll[g];
		int z = gb.myZoneIndex();
		if (z!=nZone && z!=nZone-nSgn)continue;
		
		String m = gb.material();
		int c = gb.color();

	// this zone
		if (nZone==z)
		{
		// validate include lists
			if (sArIncludeMaterial.length()>0 || nArIncludeColor.length()>0)
			{
				if (sArIncludeMaterial.length()>0 && sArIncludeMaterial.find(m)<0)
					continue;
				if (nArIncludeColor.length()>0 && nArIncludeColor.find(c)<0)
					continue;
			}
		// validate exclude lists		
			if (m!="" && sArExcludeMaterial.find(m)>-1) continue;
			if (nArExcludeColor.find(c)>-1) continue;
			
			gbThis.append(gb);
		}
	// other zone is not filtered	
		else if (nZone-nSgn==z)gbOther.append(gb);
	}	
	
// create pp's
	PlaneProfile ppThis[0], ppOther, ppX;
	// loop both zones
	GenBeam gbX[0];
	gbX =gbOther ;
	Plane pn(el.zone(nZone-nSgn).ptOrg(), el.zone(nZone-nSgn).vecZ());
	double dMergeX= dEps*5;
	for (int i=0 ; i<2;i++)
	{
	// loop genbeams	
		for (int g=0 ; g<gbX.length();g++)
		{
			Body bd = gbX[g].realBody();
			PlaneProfile pp = bd.shadowProfile(pn);
		// merge other zone, merge this only if selected
			if (i==0 || dMergeX>dEps*5)
			{
				pp.shrink(-dMergeX);
				if (ppX.area()<pow(dEps,2))
					ppX=pp;
				else
					ppX.unionWith(pp);
			}
		// append this if not merged
			else
				ppThis.append(pp);		
		}
		
	// shrink to merge
		if (i==0 || dMergeX>dEps*5) 
		{
			if (i==1) ppThis.append(ppX);
			ppX.shrink(dMergeX);
		}
		if (i==0) ppOther =ppX;

	// merge factor	
		if (dMerge>dEps)dMergeX=dMerge;
	// next zone	
		gbX = gbThis;
		pn=Plane(el.zone(nZone).ptOrg(), el.zone(nZone).vecZ());	
	}

// ignore holes and openings
	if (dIgnoreArea>dEps)
	{
		ppOther.shrink(-dIgnoreArea/2);
		//ppOther.vis(6);
		ppOther.shrink(dIgnoreArea/2);
	}

// declare nailing segments
	LineSeg lsNails[0];
	
// loop ths profiles and nail on intersection
	for (int i=0 ; i<ppThis.length();i++)
	{
		ppThis[i].vis(i);
		PlaneProfile pp = ppThis[i];
		
	// get all rings
		PLine plRings[0];
		int bIsOp[0];
		pp.vis(3);
	// ignore holes and openings
		if (dIgnoreArea>dEps)
		{
			pp.shrink(-dIgnoreArea/2);
			pp.shrink(dIgnoreArea/2);
		}	
		
		pp.intersectWith(ppOther);
		pp.shrink(dEdgeOffset);

		pp.vis(1);
		
	// get all rings
		plRings=pp.allRings();
		bIsOp=pp.ringIsOpening();
		
	// convert to straight segments
		for (int r=0; r<plRings.length(); r++)
		{
			
			PLine pl = plRings[r];
			pl.convertToLineApprox(U(dSpacing/2));
			Point3d pts[0];
			pts = pl.vertexPoints(false);
			for (int p=0; p<pts .length()-1; p++)
				lsNails.append(LineSeg(pts[p],pts[p+1]));
			if (bIsOp[r])continue;//plRings[r].vis(4);	
			
			// collect distributed nail segments by module
			LineSeg ls=pp.extentInDir(vx);
			double dRange = abs(vecO.dotProduct(ls.ptStart()-ls.ptEnd()));	
			if (dRange>dNailModule)
			{
			// distribute
				int n=dRange/dNailModule;
				double d=dRange/(n+1);
				//ls.vis(2);	
				Point3d pt = ls.ptMid()-.5*vecO*dRange;
				for (int p=0; p<n; p++)
				{
					pt.transformBy(vecO*d);
					pt.vis(p);	
				// get intersecting points
					Point3d ptInt[0];
					for (int q=0; q<plRings.length(); q++)
						ptInt.append(plRings[q].intersectPoints(Plane(pt,vecO )));
					ptInt=Line(pt,vecO.crossProduct(vz)).orderPoints(ptInt);
					
					for (int q=0; q<ptInt.length()/2; q++)
					{
						//lsNails.append(LineSeg(ptInt[q],ptInt[q+1]));
						int x = q*2;
						LineSeg seg(ptInt[x],ptInt[x+1]);
						lsNails.append(seg);
					}
				}	
			}			
				
		}
	
			
	}
	
	if (bDebug)dp.draw(lsNails);
	//ppOther.vis(2);

// add triggers
	String sTrigger[] = {T("|Release Naillines|")};		// 0

	
	for (int i = 0; i < sTrigger.length(); i++)
		addRecalcTrigger(_kContext, sTrigger[i]);	
	

// flag to create individual nail lines
	int bCreate;
	if (_bOnRecalc && _kExecuteKey==sTrigger[0])
		bCreate=true;

// loop segments
	for (int i=0 ; i<lsNails.length();i++)
	{
		ElemNail elemNail(nZone, lsNails[i].ptStart(), lsNails[i].ptEnd(), dSpacing, nToolingIndex);
		lsNails[i].vis(211);
		if(bCreate)
		{
			NailLine nl;		
			nl.dbCreate(el, elemNail);
		}
		else
			el.addTool(elemNail);
	}

// erase when individual where created
	if (bCreate || lsNails.length()<1 && !_bOnDbCreated)
	{
		eraseInstance();
		return;	
	}






#End
#BeginThumbnail
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
.&R;^[^O\BZ=.#V_$_]FU
`




#End
