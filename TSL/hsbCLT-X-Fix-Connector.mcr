#Version 8
#BeginDescription
This tsl creates X-Fix connectors between panels
Modell C70, C90 supported.

#Versions
1.6 05.12.2024 HSB-23003: save graphics in file for render in hsbView and make Author: Marsel Nakuci
version  value="1.5" date="24may17" author="thorsten.huck@hsbcad.com"
supplier name convention adjusted
bugfix tool assignment on edges with tongue/groove or lap connection 
supports hardware output

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 6
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl creates X-Fix connectors between panels
/// </summary>

/// <insert Lang=en>
/// Select a set of panels. The tsl will create multiple X-Fix connections for any two collinear edges of two panels. the selected surface needs to be coplanar.
/// </insert>


/// History
///#Versions:
// 1.6 05.12.2024 HSB-23003: save graphics in file for render in hsbView and make Author: Marsel Nakuci
///<version  value="1.5" date="24may17" author="thorsten.huck@hsbcad.com"> supplier name convention adjusted </version>
///<version  value="1.4" date="24may17" author="thorsten.huck@hsbcad.com"> bugfix tool assignment on edges with tongue/groove or lap connection </version>
///<version  value="1.3" date="03apr17" author="thorsten.huck@hsbcad.com"> supports hardware output </version>
///<version  value="1.2" date="15june16" author="florian.wuermseer@hsbcad.com"> chamfers added </version>
///<version  value="1.1" date="11april16" author="florian.wuermseer@hsbcad.com"> tool is a dove now, lengthwise connector is not longer included in this TSL, Pt0 can't be moved no more </version>
///<version  value="1.0" date="16mar16" author="florian.wuermseer@hsbcad.com"> initial </version>

// constants
	U(1,"mm");
	double dEps=U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;	
	String sLastEntry = T("|_LastInserted|");
	String sDoubleClick= "TslDoubleClick";	
	int bDebug;// =true;//_bOnDebug;
	
	
	int bPointReset = 0;

// Category 1: Type
	String sCatType = T("|Type|");
	
	String sTypes[] = {"X-fix C70", "X-fix C90"}; //, "X-Fix L"};
	String sTypeName="(A)   " +T("|Type|") ;	
	PropString sType (nStringIndex++, sTypes, sTypeName);
	sType.setCategory(sCatType);

	int nType = sTypes.find(sType);

// Category 2: Distribution	
	String sCatDist = T("|Distribution|");
	
	String sOffset1Name="(B)   " +T("|Offset 1|") ;	
	PropDouble dOffset1 (nDoubleIndex++, U(200), sOffset1Name);
	dOffset1.setCategory(sCatDist);

	String sOffset2Name="(C)   " +T("|Offset 2|") ;	
	PropDouble dOffset2 (nDoubleIndex++, U(200), sOffset2Name);
	dOffset2.setCategory(sCatDist);

	String sInterdist="(D)   " +T("|Interdistance|") ;	
	PropDouble dInterdist (nDoubleIndex++, U(1000), sInterdist);
	dInterdist.setCategory(sCatDist);


	if (dOffset1 < 0)
	{
		dOffset1.set(U(0));
		reportMessage("\n" + T("|Offset|") + " < 0 " + T("|not possible|") + " --> " + T("|value corrected to|") + " 0mm");
	}

	if (dOffset2 < 0)
	{
		dOffset2.set(U(0));
		reportMessage("\n" + T("|Offset|") + " < 0 " + T("|not possible|") + " --> " + T("|value corrected to|") + " 0mm");
	}

	if (dInterdist < 110)
	{
		dInterdist.set(U(1000));
		reportMessage("\n" + T("|Interdistance|") + " < 110mm " + T("|not possible|") + " --> " + T("|value corrected to|") + " " + T("|Default|") + " (1000mm)");
	}

// Category 3: General
	String sCatGeneral = T("|General|");
	
	String sAlignmentName="(E)   " +T("|Alignment|");	
	String sAlignments[] = {T("|Reference Side|"), T("|Opposite Side|")};
	PropString sAlignment(nStringIndex++, sAlignments, sAlignmentName);
	sAlignment.setCategory(sCatGeneral);
	
// chamfer
	String sCategoryRef = T("|Reference Side|");
	
	String sChamferRefName="(F)  "+T("|Chamfer|");
	PropDouble dChamferRef(nDoubleIndex++, U(0), sChamferRefName);
	dChamferRef.setCategory(sCategoryRef);


	String sCategoryOpp = T("|opposite side|");
	
	String sChamferOppName="(G)  "+T("|Chamfer|");
	PropDouble dChamferOpp(nDoubleIndex++, U(0), sChamferOppName);
	dChamferOpp.setCategory(sCategoryOpp );

	//String sAutoGroupName=T("|Auto Group|");
	//PropString sAutoGroup(nStringIndex++, T("|Joint Board|"), sAutoGroupName);
	//sAutoGroup.setDescription(T("|Specify Group Name to group joint boards in a 3rd level group, i.e. 'JointBoard'|"));
	//sAlignment.setCategory(sCatGeneral);

	double dWidth = U(10);
	double dRange = U(5);
	double dMinArea = pow(dRange,2);
	
	double dDepth;
	if (nType == 0)
		dDepth = U(70);
		
	else if (nType == 1 || nType == 2)
		dDepth = U(90);


	
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
		showDialog();
			
		
	// selection set
		Entity ents[0];
		PrEntity ssE(T("|Select panels|" + " " + T("|<Enter> to select a wall|")), Sip());
		if (ssE.go())
				ents= ssE.set();
			
	// add to global sip array
		for(int i = 0;i <ents.length();i++)
		{
			if(ents[i].bIsKindOf(Sip()))	
				_Sip.append((Sip)ents[i]);
		}
		
	// prompt for an element
		if (_Sip.length()<1)
		{
			_Element.append(getElement());
			_Pt0 = getPoint();
			return; // stop insert code here
		}	
	// split the selected clt	
		else if (_Sip.length()==1)
		{
			_Map.setInt("mode",1);
			Point3d pt1 = getPoint(T("|Select first point on split axis|"));
			PrPoint ssP(T("|Select second point on split axis|"),pt1);
			Point3d pt2;
			if (ssP.go()==_kOk) // do the actual query
				pt2 = ssP.value();

			Vector3d vec=pt2-pt1;
			vec.normalize();
			Vector3d vecNormal = vec.crossProduct(_Sip[0].vecZ());
			vecNormal.normalize();
			Plane pnSplit(pt1,vecNormal);
			Sip sips[0];
			sips=_Sip[0].dbSplit(pnSplit,0);
			if (sips.length()>0)
				_Sip.append(sips);
			else
			{
				reportMessage(TN("|Splitting was not successful.|") + " " + T("|Tool will be deleted.|"));
				eraseInstance();
				return;	
			}	
				
		}
		else if (_Sip.length()==2)
		{
			_Map.setInt("mode",2);
			
		}		
		
		//reportMessage("\nPanels: " + _Sip.length());
				
	/// validate parameteres
	// flag this instance to be a split instance		
		//_Map.setInt("mode",1);
		//_Pt0 = _Sip[0].ptCen();
		//if (bDebug)reportMessage("\nwidth = " + dWidth + " gap width = " + dGapWidth + " at #163");
		return;
	}	
// end on insert___________________________________________________________________________________________________________________-









// modes
	// 3 = element split location mode
	// 2 = recess mode, detect segments which can be joined
	// 1 = distribution mode
	// 0 = joint board mode
	int nMode = _Map.getInt("mode");
	//reportMessage("\n Mode: " + nMode);
	int nAlignment = sAlignments.find(sAlignment);

// the clt panels	
	Sip sips[0];
	sips = _Sip;
	
	
// set dependency
	for(int i=0;i<_Sip.length();i++)
	{
		_Entity.append(_Sip[i]);
		setDependencyOnEntity(_Sip[i]);
	}

// validate
	String sMsg1 = "\n"+ T("|This tool requires at least two connecting panels or a wall.|") + nMode + _bOnElementConstructed;
	Vector3d vecFace;
	Vector3d vecX; 
	Vector3d vecY;
	Vector3d vecZ;

// trigger double click
	if (_bOnRecalc && _kExecuteKey==sDoubleClick) 
	{
		nAlignment++;
		if (nAlignment>1) nAlignment=0;
		sAlignment.set(sAlignments[nAlignment]);
		setExecutionLoops(2);					
	}	

 ////add panel trigger
	//String sTriggerAddPanel = T("|Add Panel|");
	//addRecalcTrigger(_kContext,sTriggerAddPanel );	
	//if (_bOnRecalc && _kExecuteKey==sTriggerAddPanel)
	//{
		//_Sip.append(getSip());	
		//setExecutionLoops(2);
	//}
	
// split location mode
	if (_Element.length()>0)
	{
		nMode=3;
		Element el = _Element[0];
		Vector3d vecX = el.vecX();
		Vector3d vecY = el.vecY();
		Vector3d vecZ = el.vecZ();
		Point3d ptOrg = el.ptOrg();
		assignToElementGroup(el,true,0,'E');
		
	// get thickness of panelzone	
		double dZ0 = el.dBeamWidth();
		if (dZ0<=0)
		{
			LineSeg seg = PlaneProfile(el.plOutlineWall()).extentInDir(vecX);
			dZ0= abs(vecZ.dotProduct(seg.ptStart()-seg.ptEnd()));	
		}
		
	// declare the tsl props
		TslInst tslNew;
		Vector3d vUcsX = vecX;
		Vector3d vUcsY = vecZ;
		GenBeam gbAr[1];
		Entity entAr[0];
		Point3d ptAr[1];
		int nArProps[0];
		double dArProps[] = {dOffset1, dOffset2, dInterdist, dChamferRef, dChamferOpp};
		String sArProps[] = {sType, sAlignment};
		Map mapTsl;
		String sScriptname = scriptName();		
	
		mapTsl.setInt("mode",2);

	// the face
		vecFace=-vecZ;
		if (nAlignment==1)vecFace*=-1;
		
	// set location on insert or if _Pt0 is dragged
		if ( _kNameLastChangedProp=="_Pt0")
		{
			//double d = vecFace.dotProduct(_Pt0-ptOrg);
			double d=vecZ.dotProduct(ptOrg-_Pt0);
			reportMessage("\nd: " + d);
			if (d<.333*dZ0)
				nAlignment=1;
			else if (d<.666*dZ0)
				nAlignment=0;
			else
				nAlignment=-1;
			sAlignment.set(sAlignments[nAlignment+1]);
			//reportMessage("\nd: " + d + " align: " + nAlignment + " " + sAlignment + " dZ0:" + 2/3*dZ0);
			setExecutionLoops(2);		
		}

	// grid location
		Point3d ptGrid = ptOrg;
		if (nAlignment==0)ptGrid.transformBy(-vecZ*.5*dZ0);
		else if (nAlignment==-1)ptGrid.transformBy(-vecZ*dZ0);
		ptGrid.vis(5);


	// realign _Pt0	
		_Pt0.transformBy(vecZ*vecZ.dotProduct(ptGrid-_Pt0)+vecY*vecY.dotProduct(ptOrg-_Pt0));
		Point3d ptRef = _Pt0;		
		_Pt0.vis(1);ptOrg.vis(4);

	// plan display
		double dX = U(4);
		double dZ = dDepth;
		
		PLine pl;
		Point3d pt=ptRef;
		pt.transformBy(-.5*vecX*dX);		pl.addVertex(pt);
		pt.transformBy(-vecFace*dZ);	pl.addVertex(pt);
		pt.transformBy(vecX*dX);			pl.addVertex(pt);
		pt.transformBy(vecFace*dZ);	pl.addVertex(pt);
		vecFace.vis(pt,150);
		double dD = U(1);
		dX-=(2*dD);
		dZ-=dD;
		pt.transformBy(-vecX*dD);			pl.addVertex(pt);
		pt.transformBy(-vecFace*dZ);	pl.addVertex(pt);		
		pt.transformBy(-vecX*dX);			pl.addVertex(pt);
		pt.transformBy(vecFace*dZ);	pl.addVertex(pt);
		pl.close();	
		if (nAlignment==0)pl.transformBy(-vecZ*.5*dZ);
		pl.vis(2);			
		PlaneProfile pp(pl);
		pp.vis(2);
	
	// if construction is not present display, stay invisible
		GenBeam genBeams[] = el.genBeam();	
		Sip sipsAll[0];
		for (int i=genBeams.length()-1;i>=0;i--)
			if (!genBeams[i].bIsKindOf(Sip()))
				genBeams.removeAt(i);
			else
				sipsAll.append((Sip)genBeams[i]);
				
		int bShow = genBeams.length()<1;
		Display dpPlan(-1);
		dpPlan.showInDxa(true);// HSB-23003
		if (bShow)
		{
			dpPlan.draw(pp,_kDrawFilled);	
			dpPlan.draw(PLine(_Pt0, _Pt0-vecFace*el.dBeamWidth()));
			dpPlan.draw(sType, _Pt0, el.vecX(), -el.vecZ(), 1.2,3,_kModel);
		}
	// on element test split condition of existing panels, split the sip(s) if required and create a connector
		
		if ((_bOnDbCreated ||_bOnElementConstructed || _bOnDebug) && sipsAll.length()>0)
		{
		// find panels at the location 	
			PLine plRec;
			Point3d ptX =_Pt0;
			Sip sipsLeft[0], sipsRight[0];
			int nDir=1;
			for (int x=0;x<2;x++)
			{	
				plRec.createRectangle(LineSeg(ptX+.5*(vecY*U(10e4)),ptX-.5*(nDir*vecX*dWidth+vecY*U(10e4))),vecX, vecY);
				plRec.vis(x);
				for (int i=0;i<sipsAll.length();i++)
				{
					Sip sip = sipsAll[i];
					PlaneProfile pp(sip.plEnvelope());
					double dArea=pp.area();
					pp.joinRing(plRec,_kSubtract);
					if (dArea-pp.area()>pow(.5*dWidth,2))
					{
						if (x==0)sipsLeft.append(sip);
						else sipsRight.append(sip);	
					}	
				}
				nDir*=-1;
			}// next x
		
		// collect panels to be splitted. This is the case if left and right is the same panel
			Sip sipsSplit[0];
			for (int i=sipsLeft.length()-1;i>=0;i--)
				for (int j=sipsRight.length()-1;j>=0;j--)
					if (sipsLeft[i]==sipsRight[j] && sipsSplit.find(sipsLeft[i])<0)
					{
						sipsSplit.append(sipsLeft[i]);						
						sipsLeft.removeAt(i);
						sipsRight.removeAt(j);	
					}
			
		// split and create joint board in recess mode
			for (int i=0;i<sipsSplit.length();i++)
			{
				Sip sip = sipsSplit[i];
				gbAr.setLength(0);
				gbAr.append(sip);
				Sip sips[0];
				sips=sip.dbSplit(Plane(ptRef,vecX),0);
				for (int j=0;j<sips.length();j++)
				{
					sips[j].assignToElementGroup(el,true,0, 'Z');
					gbAr.append(sips[j]);	
				}
				if (!_bOnDebug)tslNew.dbCreate(sScriptname, vUcsX,vUcsY,gbAr, entAr, ptAr, 
						nArProps, dArProps, sArProps,_kModelSpace, mapTsl);
				if (tslNew.bIsValid())
					tslNew.setColor(_ThisInst.color());						
			}
		
		// collect potential joints
			for (int i=sipsLeft.length()-1;i>=0;i--)
				for (int j=sipsRight.length()-1;j>=0;j--)
				{
					Sip sipL=sipsLeft[i];
					Sip sipR=sipsRight[j];
					
					PlaneProfile ppL(sipL.plEnvelope()); ppL.vis(2);
					PlaneProfile ppR(sipR.plEnvelope()); ppR.vis(3);
					ppL.transformBy(vecX*dEps);
					ppL.intersectWith(ppR);
					if (ppL.area()>pow(dEps,2))
					{
						gbAr.setLength(0);
						gbAr.append(sipL);
						gbAr.append(sipR);

						if (!_bOnDebug)tslNew.dbCreate(sScriptname, vUcsX,vUcsY,gbAr, entAr, ptAr, 
								nArProps, dArProps, sArProps,_kModelSpace, mapTsl);
						if (tslNew.bIsValid())
							tslNew.setColor(_ThisInst.color());	
						
						sipsLeft.removeAt(i);
						sipsRight.removeAt(j);
					}						
				}
		}


		return;	
	}

 //validate	
	if (sips.length()<2)
	{
		if (!_bOnElementConstructed)reportMessage(sMsg1);
		{
			eraseInstance();
			return;	
		}
	}

// the normal vector oif the ref face, center will use the same face as reference side
	vecFace = -sips[0].vecZ();
	if (nAlignment==1 || nType == 2)
		vecFace = sips[0].vecZ();

// declare ref point on face
	Point3d ptRef = sips[0].ptCenSolid();
	if (nType != 2)
		ptRef.transformBy(vecFace*.5*sips[0].dH());	
	vecFace.vis(ptRef,1);
	Plane pnRef(ptRef,vecFace);
	
	
	
	
// Start distribution mode ____________________________________________________________________________________________________________________________________________________
	if (nMode ==1)
	{	
	// declare the tsl props
		TslInst tslNew;
		Vector3d vUcsX = _XW;
		Vector3d vUcsY = _YW;
		GenBeam gbAr[2];
		Entity entAr[0];
		Point3d ptAr[1];
		int nArProps[0];
		double dArProps[] = {dOffset1, dOffset2, dInterdist, dChamferRef, dChamferOpp};
		String sArProps[] = {sType, sAlignment};
		Map mapTsl;
		String sScriptname = scriptName();		
	
		mapTsl.setInt("mode",2);
		
	// remove all non parallel and non planar
		for (int i=sips.length()-1;i>=0;i--)
		{
			Point3d ptRef2 = sips[i].ptCen()+vecFace*.5*sips[i].dH();	
			if (nType != 2)
			{
				if (!sips[i].vecZ().isParallelTo(vecFace) || abs(vecFace.dotProduct(ptRef-ptRef2))>dEps)
				{
					sips[i].plEnvelope().vis(1);
					sips.removeAt(i);			
				}
				else
					sips[i].plEnvelope().vis(3);
			}
		}
	
	 //validate	
		if (sips.length()<2)
		{
			reportMessage(sMsg1);
			eraseInstance();
			return;	
		}
		
	// collect profiles
		PlaneProfile ppShadows[0], ppShadowsJoint[0];
		for (int i=0;i<sips.length();i++)
		{ 
			PlaneProfile pp (sips[i].plEnvelope());
			ppShadows.append(pp);
			pp.shrink(-dRange);
			ppShadowsJoint.append(pp);	
			pp.vis(i);		
		}
		
	// compare 1 by 1, valid intersections will create the tool		
		for (int i=0;i<sips.length();i++)				
			for (int j=i+1;j<sips.length();j++)
			{
				PlaneProfile pp = ppShadowsJoint[i];
				pp.intersectWith(ppShadowsJoint[j]);
				if (pp.area()>dMinArea)
				{
				// display detected overlapping
					if (0)
					{
						Display dp(i+j);
						dp.draw(pp,_kDrawFilled);
					}
				// create individual jointBoard instance	
					else
					{
						gbAr[0]=sips[i];
						gbAr[1]=sips[j];
						ptAr[0] = pp.extentInDir(_XW).ptMid();
						tslNew.dbCreate(sScriptname, vUcsX,vUcsY,gbAr, entAr, ptAr, 
							nArProps, dArProps, sArProps,_kModelSpace, mapTsl);	
					}
				}	
			}	
			
	// erase caller
		if(!bDebug)
		{
			eraseInstance();
			return;
		}		
	}
// END distribution mode




// START recess mode	 ____________________________________________________________________________________________________________________________________________________
	else if (nMode==2)
	{
	 //validate	
		if (sips.length()<2)
		{
			reportMessage(sMsg1);
			eraseInstance();
			return;	
		}
		
	// use the first as default	
		Vector3d vecX = sips[0].vecX();
		Vector3d vecY = sips[0].vecY();
		Vector3d vecZ = sips[0].vecZ();		

	// declare the tsl props
		TslInst tslNew;
		Vector3d vUcsX = _XW;
		Vector3d vUcsY = _YW;
		GenBeam gbAr[0];
		Entity entAr[0];
		Point3d ptAr[1];
		int nArProps[0];
		double dArProps[] = {dOffset1, dOffset2, dInterdist, dChamferRef, dChamferOpp};
		String sArProps[] = {sType, sAlignment};
		Map mapTsl;
		String sScriptname = scriptName();		
		
		mapTsl.setInt("mode",0);		

	// collect profiles
		PlaneProfile ppShadows[0], ppShadowsJoint[0];
		for (int i=0;i<sips.length();i++)
		{ 
			PLine pl = sips[i].plEnvelope();
			pl.projectPointsToPlane(pnRef,vecFace);
			PlaneProfile pp (pl);
			ppShadows.append(pp);
			pp.shrink(-dRange);
			ppShadowsJoint.append(pp);	
			pp.vis(i);	
			
			//gbAr.append(sips[i]);	
		}		

	// compare 1 by 1, valid intersections are defining the tool
		PlaneProfile ppTool;
		for (int i=0;i<sips.length();i++)				
			for (int j=i+1;j<sips.length();j++)
			{
				PlaneProfile pp = ppShadowsJoint[i];
				pp.intersectWith(ppShadowsJoint[j]);
				if (pp.area()>dMinArea)
				{
				// display detected overlapping
					if (bDebug)
					{
						//Display dp(i+j);
						//dp.draw(pp,_kDrawFilled);
					}
				// create individual jointBoard instance	
					if (ppTool.area()<pow(dEps,2))
						ppTool= pp;
					else
						ppTool.unionWith(pp);
				}	
			}

	// truncate ppTool to shadow extents
		{
			PlaneProfile ppTmp=ppTool;
			ppTool.removeAllRings();
			for (int i=0;i<ppShadows.length();i++)	
			{
				PlaneProfile pp = ppShadows[i];
				pp.intersectWith(ppTmp);
				if (ppTool.area()<pow(dEps,2))
				{
					ppTool =pp;
				}
				else
					ppTool.unionWith(pp);				
			}
		// merge
			ppTool.shrink(-dRange);
			ppTool.shrink(dRange);
		}		

	// display on debug
		//if (_bOnDebug)
		//{
			//Display dp(3);	
			//ppTool.transformBy(vecZ*U(300));
			//dp.draw(ppTool,_kDrawFilled);		
			//ppTool.transformBy(-vecZ*U(300));
		//}
		
	// collect multiple locations, potentially on the same edges (joint board at window location)	
		PLine plRings[] = ppTool.allRings();
		int bIsOp[] = ppTool.ringIsOpening();

	// declare a collector for all created joint boards
		Beam bmJointBoards[0];
							
	// loop tool areas 
		for (int r=0;r<plRings.length();r++)
		{		
			if (bIsOp[r] ||plRings[r].area()<pow(dEps,2))continue;
			PlaneProfile ppThis(plRings[r]);
			ppThis.vis(6);
			
			Point3d ptMid = ppThis.extentInDir(vecX).ptMid();
			SipEdge edgesCommon[0];
			gbAr.setLength(0);
			
		// find panels intersecting this area and collect intersecting edges
			for (int s=0;s<sips.length();s++)
			{
				PlaneProfile ppTest=ppThis;
				ppTest.intersectWith(PlaneProfile(sips[s].plEnvelope()));
				if (ppTest.area()<pow(dEps,2)) continue;	
				ppTest.vis(62);
				SipEdge edges[] = sips[s].sipEdges();
				
				for (int i=0;i<edges.length();i++)
				{
					Vector3d vecYE=edges[i].vecNormal();
					Vector3d vecXE=vecYE.crossProduct(vecZ);
					
					PLine pl = edges[i].plEdge();
					LineSeg seg (pl.ptStart()-vecYE*dRange,pl.ptEnd()+vecYE*dRange);
					pl.createRectangle(seg,vecXE,vecYE);
					
					
					pl.vis(i);
					ppTest=PlaneProfile(pl);
					ppTest.intersectWith(ppThis);
					
					if (ppTest.area()<pow(dRange*1.1,2))
					{
					// redo with a slightly offseted test profile
					// version  value="1.5" date="23jun15" author="thorsten.huck@hsbcad.com"> toelrance issue fixed by double checking edge interferences
						ppTest=PlaneProfile(pl);
						ppTest.shrink(-dEps);
						ppTest.intersectWith(ppThis);
						if (ppTest.area()<pow(dRange*1.1,2))
							continue;//ppThis.area()*.1) continue;
					}
					//seg.vis(2);pl.vis(2);
					edgesCommon.append(edges[i]);
					if (gbAr.find(sips[s])<0)
						gbAr.append(sips[s]);	
				}
			}
			
		// find edges intersecting this area and being parallel
		// get coordSys of common edges and the common length;
			double dX, dY;
			dY=dWidth;//-2*dGapWidth;

		// increment the gbAr array for the board itself
			gbAr.setLength(gbAr.length()+1);

		// loop common edges and find parallel but not codirectional
			for (int e=edgesCommon.length()-1;e>=0;e--)
			{
				for (int f=edgesCommon.length()-1;f>=0;f--)
				{
					if (e==f) continue;
					Vector3d vecNormalE = edgesCommon[e].vecNormal();
					Vector3d vecNormalF = edgesCommon[f].vecNormal();
					if (!vecNormalE.isParallelTo(vecNormalF) || vecNormalE.isCodirectionalTo(vecNormalF)) continue;	
				
				// parallel segemnts found, test for intersection
				// build coordSys
					Vector3d vecZ = vecFace;
					Vector3d vecY = vecNormalE ;
					Vector3d vecX = vecY.crossProduct(vecZ);	
					Point3d ptThis = edgesCommon[e].ptMid();
					//vecX.vis(ptThis,1);vecY.vis(ptThis,3);vecZ.vis(ptThis,150);
					//ptThis.vis(3);		
					
					PLine plE = edgesCommon[e].plEdge();
					LineSeg segE (plE.ptStart()-vecY*.5*dWidth,plE.ptEnd()+vecY*.5*dWidth);
					//segE.vis(2);
					plE.createRectangle(segE,vecX,vecY);

					PLine plF= edgesCommon[f].plEdge();
					LineSeg segF (plF.ptStart()-vecY*.5*dWidth,plF.ptEnd()+vecY*.5*dWidth);
					//segF.vis(3);
					plF.createRectangle(segF,vecX,vecY);

				// get common area
					PlaneProfile ppCommon(plE);
					ppCommon.intersectWith(PlaneProfile(plF));
					if (ppCommon.area()<pow(dWidth*.5,2))continue;
					
					if (_bOnDebug)
					{
						ppCommon.transformBy(vecZ*U(400)*(r+1));
						ppCommon.vis(r+1);
						ppCommon.transformBy(-vecZ*U(400)*(r+1));
					}
					
					LineSeg segCommon = ppCommon.extentInDir(vecX);segCommon.vis(221);
					dX = abs(vecX.dotProduct(segCommon .ptStart()-segCommon.ptEnd()));
					// create beam(s)
					if (dX>dEps)
					{
						if (bDebug)
						{
							segCommon.ptMid().vis(e);
							Body bd(segCommon.ptMid(),vecX, vecY, vecZ, dX, dY, U(50),0,0,-1);
							bd.vis(e+1);
						}
						
						else
						{
							ptAr.setLength(3);
							ptAr[0] = segCommon.ptMid();
							
						// make sure, the point sequence is in vector direction
							Vector3d vecSip = gbAr[0].vecD(vecX);
							if (vecSip.isParallelTo(gbAr[0].vecX()))
								vecSip = gbAr[0].vecX();
							else
								vecSip = gbAr[0].vecY();
							
							if (vecSip.dotProduct(vecX) < 0)
							{						
								ptAr[1] = segCommon.ptMid() + vecX*.5*dX;
								ptAr[2] = segCommon.ptMid() - vecX*.5*dX;
							}
							else
							{
								ptAr[1] = segCommon.ptMid() - vecX*.5*dX;
								ptAr[2] = segCommon.ptMid() + vecX*.5*dX;
							}

							tslNew.dbCreate(sScriptname, vecX,vecY,gbAr, entAr, ptAr, 
								nArProps, dArProps, sArProps,_kModelSpace, mapTsl);	
						}
						edgesCommon.removeAt(f);
						edgesCommon.removeAt(e);
						break;// breaking f	
					}
				}// next f
			}//next e		
		}// next r ring
	
	// erase caller
		if(!bDebug)
		{
			eraseInstance();
			return;
		}
	}
// END recess mode		




// START connector mode ____________________________________________________________________________________________________________________________________________________
	else if(nMode==0)
	{		

	// recalc edge trigger
		String sTriggerRecalcEdge = T("|Recalc edge|");
		addRecalcTrigger(_kContext,sTriggerRecalcEdge );	
		if (_bOnRecalc && _kExecuteKey==sTriggerRecalcEdge)
		{
			_Map.setInt("mode", 2);
			setExecutionLoops(2);
			eraseInstance();
			return;
		}

	// the sips
		Sip sip0=sips[0];
		Sip sip1=sips[1];
		

		Point3d ptStart = _Map.getPoint3d("ptStart");
		Point3d ptEnd = _Map.getPoint3d("ptEnd");
		
		double dOffset1Prev = _Map.getDouble("dOffset1");
		double dOffset2Prev = _Map.getDouble("dOffset2");
		
		if (_bOnDbCreated)
		{
			ptStart = _PtG[0];
			ptEnd = _PtG[1];
			dOffset1Prev = dOffset1;
			dOffset2Prev = dOffset2;
		}
		
	// map points
		_Map.setPoint3d("ptStart", ptStart, _kAbsolute);
		_Map.setPoint3d("ptEnd", ptEnd, _kAbsolute);
		
		_Pt0 = _Pt0.projectPoint(pnRef,0);
		ptStart = ptStart.projectPoint(pnRef,0);
		ptEnd = ptEnd.projectPoint(pnRef,0);		
		
		
		vecX = (ptEnd - ptStart);	
		vecZ = sip0.vecZ();
		vecY = vecZ.crossProduct(vecX);
		vecX.normalize();
		vecY.normalize();
		vecZ.normalize();
	
	// get common contour for cutting lengthwise connector body afterwards
		PlaneProfile ppCommon,ppTool;
		for(int i=0;i<sips.length();i++)
		{
			PlaneProfile pp(sips[i].plEnvelope());
			if (ppCommon.area()<pow(dEps,2))
				ppCommon=pp;
			else
				ppCommon.unionWith(pp);

		// intersectional tool area
			pp.shrink(-dRange);
			if (ppTool.area()<pow(dEps,2))
				ppTool=pp;
			else
				ppTool.intersectWith(pp);
		}
		ppCommon.shrink(-dRange);
		ppCommon.shrink(dRange);
	
		
	// reset grips
		if ((nType == 2 && _bOnDbCreated) || (nType == 2 && _kNameLastChangedProp == sTypeName))
		{
			dOffset1.set(U(0));
			dOffset2.set(U(0));
			bPointReset = 1;			
		}
		
		
		//reportMessage("\n" + _kNameLastChangedProp);
		if (_bOnDbCreated || _kNameLastChangedProp == sOffset1Name || _kNameLastChangedProp == sOffset2Name || bPointReset == 1 || dOffset1Prev != dOffset1 || dOffset2Prev != dOffset2)
		{
			_PtG.setLength(0);
			_PtG.append(ptStart + vecX*dOffset1);
			_PtG.append(ptEnd - vecX*dOffset2);	
			
			_PtG[0].vis(1);
			_PtG[1].vis(2);
		}
	
	// set offset property, if grips were moved	
		if (_kNameLastChangedProp == "_PtG1")
		{	
			if (ppCommon.pointInProfile(_PtG[1]) == 1)
				_PtG[1] = ptEnd;
			dOffset2.set(vecX.dotProduct(ptEnd - _PtG[1]));
			//reportMessage("\n" + "Offset 2 set");
		}
		
		if (_kNameLastChangedProp == "_PtG0")
		{
			if (ppCommon.pointInProfile(_PtG[0]) == 1)
				_PtG[0] = ptStart;
			dOffset1.set(vecX.dotProduct(_PtG[0] - ptStart));
			//reportMessage("\n" + "Offset 1 set");
		}
	
	//	project grips to reference plane
		_PtG[0] = _PtG[0].projectPoint(pnRef,0);
		_PtG[1] = _PtG[1].projectPoint(pnRef,0);
	
	// dependency and group assignment	
		assignToGroups(sips[0]);
		double dH = sips[0].dH();




		Point3d pt0Prev = _Map.getPoint3d("Pt0");
		Vector3d vecMove;
		int nHasMoved = 0;
		
		//if (!_bOnDbCreated && pt0Prev != _Pt0)
		//{
			//reportMessage("\n" + "hasMoved");
			//vecMove = (_Pt0 - pt0Prev);
			//nHasMoved = 1;
			//_Pt0 = pt0Prev;
			//for (int i=0; i<_PtG.length(); i++)
				//_PtG[i].transformBy(-vecMove);
			
		//}
	
	//// show me the vectors	
		//vecX.vis(_Pt0,1);
		//vecY.vis(_Pt0,3);
		//vecZ.vis(_Pt0,5);	
		//vecMove.vis(_Pt0, 30);
		

	// during some events compute common area and get the segment location
		if (_bOnDbCreated || _bOnRecalc || _bOnDebug || _kNameLastChangedProp=="_Pt0" || _kNameLastChangedProp=="_PtG0" || _kNameLastChangedProp=="_PtG1" || nHasMoved == 1)
		{
			ppTool.transformBy(vecZ*U(100));
			ppTool.vis(3);
			ppTool.transformBy(-vecZ*U(100));
	
		// collect edges of tool area
			SipEdge edges[] = sip0.sipEdges();
			for (int i=edges.length()-1;i>=0;i--)
				if (ppTool.pointInProfile(edges[i].ptMid()) !=_kPointInProfile)		
					edges.removeAt(i);
		
		// snap _Pt0 and _PtGs to the closest segment axis of the intersection
			double dMin = U(10e10);
			SipEdge edge;
			for (int i=edges.length()-1;i>=0;i--)	
			{
				double d = (edges[i].plEdge().closestPointTo(_Pt0)-_Pt0).length();
				if (d<dMin)
				{
					dMin=d;
					edge=edges[i];
				}
			}

			if(ppTool.area()>pow(dEps,2) && (edge.ptStart()-edge.ptEnd()).length()>dEps)
			{
				Line ln(edge.ptMid(),edge.ptEnd()-edge.ptStart());
				Point3d pt = ln.closestPointTo(_Pt0);
				Point3d ptG0 = ln.closestPointTo(_PtG[0]);
				Point3d ptG1 = ln.closestPointTo(_PtG[1]);
				pt.vis(8);
				_Pt0=pt;	
				_PtG[0] = ptG0;
				_PtG[1] = ptG1;
				
				_Pt0 = _Pt0.projectPoint(pnRef,0);
				_PtG[0] = _PtG[0].projectPoint(pnRef,0);
				_PtG[1] = _PtG[1].projectPoint(pnRef,0);
			}
		}// end if get location
	

	// avoid multiple instances attached to the same edges
		if (_bOnDbCreated || _bOnRecalc || _bOnDebug || _kNameLastChangedProp == sAlignmentName || _kNameLastChangedProp == sTypeName)
		{
			Entity ents[] = Group().collectEntities(true, TslInst(),_kModel);
			for (int e=0;e<ents.length();e++)
			{
				TslInst tsl =(TslInst) ents[e];
				Point3d ptOrg = tsl.ptOrg();
				Map map = tsl.map();
				Vector3d vecXEdge = map.getVector3d("vecX");
				Vector3d vecFaceOther = map.getVector3d("vecFace");
				
				GenBeam gbs[] = tsl.genBeam();
				int bSipsFound=true;
				for (int i=0;i<sips.length();i++)
					if (gbs.find(sips[i])<0)
					{
						bSipsFound=false;
						break;	
					}
				
			// erase if there is a tsl which is linked to the same edge
				if (tsl.bIsValid() && 
					tsl.scriptName()==scriptName() && 
					_ThisInst!=tsl && 
					tsl.genBeam().find(sips[0])>-1 && 
					bSipsFound &&
					abs(vecXEdge.dotProduct(_ThisInst.ptOrg()-tsl.ptOrg()))<dRange && 
					vecFace.isCodirectionalTo(vecFaceOther) && vecXEdge.isParallelTo(vecX) && abs(vecFace.dotProduct(_Pt0-ptOrg))<dEps)
				{
					reportMessage("\n" + T("|Another X-Fix connector was found for this edge.|")+" " + T("|Tool will be deleted|"));
					eraseInstance();
					return;	
				}	
			}
		}

	//// remove panel trigger
		//String sTriggerRemovePanel = T("|Remove Panel|");
		//addRecalcTrigger(_kContext,sTriggerRemovePanel );	
		//if (_bOnRecalc && _kExecuteKey==sTriggerRemovePanel )
		//{
			//Sip sip = getSip();	
			//int n =_Sip.find(sip);
			//if (n>-1)
				//_Sip.removeAt(n);
			//setExecutionLoops(2);		
		//}




	// tools
		PlaneProfile ppDrawFronts[0];
		PlaneProfile ppDrawTops[0];
		Body bdDraws[0];
		double dDistLength = vecX.dotProduct(_PtG[1] - _PtG[0]);
		double dEdgeLength = abs(vecX.dotProduct(ptEnd - ptStart));
	
	// X-shaped connector in the top/bottom surface of the panel
		Point3d ptToolRef = _PtG[0];
		int nQty = dDistLength/dInterdist;
		double dQty = dDistLength/dInterdist;
		
		if (dQty-nQty > 0)
			nQty = nQty+1;
		
		double dInter;
		dInter = dDistLength/nQty;
		int nTooShort;	
		if (dEdgeLength <= (dOffset1 + dOffset2)+U(110))
		{
			nQty = 1;
			dInter = 0;
			nTooShort = 1;
		}
			
	// create tools at each distribution point
		int nDir = 1;
		Body bdTest (_Pt0, nDir*vecX, vecFace, vecY, dEdgeLength, dDepth, U(100), 0, -1, 0);
		bdTest.vis(1);
		Sip sipAddTools[] = bdTest.filterGenBeamsIntersect(sips);	
		
		
		for (int i=0; i<nQty+1; i++)
		{
			ptToolRef = _PtG[0] + vecX*i*dInter;
			if (nTooShort)
				ptToolRef = (ptStart + ptEnd)/2;
				
			ptToolRef.vis(30);
			
			int nDir = 1;
			PlaneProfile ppDrawFront(pnRef);
			
		// dovetail
			for(int j=0; j<2; j++)
			{
				
				Vector3d vecZTool = vecX.crossProduct(vecFace)*nDir;

				Dove dv (ptToolRef, nDir*vecX, vecFace, vecZTool, U(33.2), dDepth, U(65.6), U(0), _kFemaleSide);
				BeamCut bc (ptToolRef, nDir*vecX, vecFace, vecZTool, U(33.2), dDepth, U(65.6));
				dv.setDoSolid(0);
				
				for (int k=0; k<sipAddTools.length(); k++)
				{
				// filter panels of this side
					Point3d pt = sipAddTools[k].ptCenSolid();
					if (vecZTool.dotProduct(pt-ptToolRef)<0)continue;
					
					sipAddTools[k].addTool(bc);
					sipAddTools[k].addTool(dv);
				}
					
				nDir *= -1;
			}

		// simplified tool contour for solid subtract	
			PLine plSolid (vecZ);
			plSolid.addVertex(ptToolRef - vecX * U(19.3) - vecY * U(3));
			plSolid.addVertex(ptToolRef  - vecX * U(19.3) + vecY * U(4.66));
			plSolid.addVertex(ptToolRef  - vecX * U(54.51) + vecY * U(65.63));
			plSolid.addVertex(ptToolRef  + vecX * U(54.51) + vecY * U(65.63));
			plSolid.addVertex(ptToolRef  + vecX * U(19.3) + vecY * U(4.66));
			plSolid.addVertex(ptToolRef  + vecX * U(19.3) - vecY * U(3));
			plSolid.addVertex(ptToolRef  + vecX * U(19.3) - vecY * U(4.66));
			plSolid.addVertex(ptToolRef  + vecX * U(54.51) - vecY * U(65.63));
			plSolid.addVertex(ptToolRef  - vecX * U(54.51) - vecY * U(65.63));
			plSolid.addVertex(ptToolRef  - vecX * U(19.3) - vecY * U(4.66));
			plSolid.close();
			plSolid.vis(5);
			
			ppDrawFront.joinRing(plSolid, 0);
			
			Body bdSolid (plSolid, -vecFace * dDepth);
			bdDraws.append(bdSolid);
			bdSolid.vis(5);
			
			SolidSubtract ssSolid (bdSolid, _kSubtract);
			for (int k=0; k<sipAddTools.length(); k++)
			{
				sipAddTools[k].addTool(ssSolid);
			}
			
				
			//ppDrawFront.vis(30);
			ppDrawFronts.append(ppDrawFront);
		}
		
	// add chamfers
		double dZ = _Sip[0].dH();
		nDir=-1;
		Vector3d vecDirChamf = vecY;
		Vector3d vecXBc= vecX;
		vecXBc.vis(_Pt0, 30);
		vecDirChamf.vis(_Pt0, 30);	
		for (int i=0; i<2; i++)
		{
			double dChamfer;
			if (i==0)
				dChamfer = dChamferRef;
			else
				dChamfer = dChamferOpp;
			
			if (dChamfer<=dEps)
			{
				nDir*=-1;
				continue;
			}
			
			Point3d pt = _Pt0;// ptTool;
			pt.vis(30);
			pt.transformBy(vecZ * (vecZ.dotProduct(_Sip[0].ptCen()-pt)+nDir*.5*dZ));
			double dA = sqrt(pow(dChamfer,2)/2);
			
			CoordSys csRot;
			csRot.setToRotation(-45,vecXBc ,pt);
			
			double dXBc = vecX.dotProduct(ptEnd-ptStart)+2*dA;
			
			BeamCut bc(pt ,vecXBc ,vecDirChamf, vecZ, dXBc, dChamfer , dChamfer ,0,0,0);
			bc.transformBy(csRot);
			bc.cuttingBody().vis(0);
			bc.addMeToGenBeamsIntersect(_Sip);
			
			//ptTool.transformBy(-vecDirChamf*dOverlap);
			nDir*=-1;
		}// next i		

	
	// Display _____________________________________________________________________________________
		Display dpFront(-1), dp(-1), dpTop(-1);
		dpFront.addViewDirection(vecZ);
		dpFront.addViewDirection(-vecZ);
		dpFront.showInDxa(true);// HSB-23003
		
		dpTop.addViewDirection(vecX);
		dpTop.addViewDirection(-vecX);
		dpTop.showInDxa(true);// HSB-23003

	// display	frontal view
		CoordSys csAlign;
		csAlign.setToRotation(90,vecY,_Pt0);	
			
		dpFront.color(5);
		for (int i=0; i<ppDrawFronts.length(); i++)
		{
			PlaneProfile ppSub = ppDrawFronts[i];
			ppSub.shrink(3);
			ppDrawFronts[i].subtractProfile(ppSub);
			
			dpFront.draw(ppDrawFronts[i], _kDrawFilled);
		}
		
		for (int i=0; i<ppDrawTops.length(); i++)
		{
			ppDrawTops[i].transformBy(csAlign);
		
			PlaneProfile ppSub = ppDrawTops[i];
			ppSub.shrink(3);
			ppDrawTops[i].subtractProfile(ppSub);
			
			dpFront.draw(ppDrawTops[i], _kDrawFilled);
		}

		dpFront.textHeight(U(60));
		if (nType == 0 || nType == 1)
			dpFront.draw(sType, _Pt0, vecX, vecY, 0,4,_kDevice);
		if (nType == 2)
			dpFront.draw(sType, _Pt0, vecX, vecY, 0,3,_kDevice);
			
		
	// display top
		dpTop.color(5);
		for (int i=0; i<ppDrawTops.length(); i++)
		{
			PlaneProfile ppSub = ppDrawTops[i];
			ppSub.shrink(3);
			ppDrawTops[i].subtractProfile(ppSub);
			
			dpTop.draw(ppDrawTops[i], _kDrawFilled);
		}	
		
		if (nAlignment == 0)
			dpTop.draw(sType, _Pt0, vecX, vecFace, 0,dH/60,_kDevice);
		else
			if (nType != 2)
				dpTop.draw(sType, _Pt0, vecX, vecFace, 0,-dH/60,_kDevice);
			else
				dpTop.draw(sType, _Pt0, vecX, vecFace, 0,2*dH/60,_kDevice);
			
	// display other directions	
		dp.color(30);
		for (int i=0; i<bdDraws.length(); i++)
		{
			dp.draw(bdDraws[i]);
		}	
	
	// declare hardware components
		HardWrComp hwComps[0];
		HardWrComp hw(sType , nQty+1);	
		hw.setCategory("Connector");
		hw.setManufacturer("Greenethic");
		hw.setDScaleX(U(65.6));
		hw.setDScaleY(U(33.2));
		hw.setDScaleZ(dDepth);
		
		hw.setModel(sType);	
		hwComps.append(hw);
		_ThisInst.setHardWrComps(hwComps);

	
	// publish alignment to allow tests against duplicates
		_Map.setVector3d("vecX",vecX);	
		_Map.setVector3d("vecFace",vecFace);	
		
		_Map.setPoint3d("Pt0", _Pt0, _kAbsolute);
		_Map.setDouble("dOffset1",dOffset1);	
		_Map.setDouble("dOffset2",dOffset2);	
	}
// END jointBoard mode			

#End
#BeginThumbnail
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
9^$5O44`8D7AJ%9EDFN9964Y&:VZ**`/_V=DM
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
      <str nm="Comment" vl="HSB-23003: save graphics in file for render in hsbView and make" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="12/5/2024 9:47:24 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End