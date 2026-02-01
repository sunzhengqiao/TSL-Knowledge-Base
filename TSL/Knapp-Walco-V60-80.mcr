#Version 8
#BeginDescription
EN
/// Select first beam, select second beam. If distribution quantity is set to value <= 1 the user will be prompted for the insertion point.

DE
/// Ersten Stab wählen, zweiten Stab wählen. Ist die Anzahl <= 1 gewählt wird der Benutzer aufgefordert den Einfügepunkt zu wählen.

Version 1.0   th@hsbCAD.de   17.08.2011
initial
#End
#Type E
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl defines a WALCO V Wall Connector with a KS screw. The user has to validate the engineering conditions.
/// </summary>

/// <insert Lang=en>
/// Select first beam, select second beam. If distribution quantity is set to value <= 1 the user will be prompted for the insertion point.
/// </insert>

/// <insert Lang=de>
/// Ersten Stab wählen, zweiten Stab wählen. Ist die Anzahl <= 1 gewählt wird der Benutzer aufgefordert den Einfügepunkt zu wählen.
/// </insert>

/// <remark Lang=de>
/// Die Bauteile müssen parallel zueinander angeordnet sein und dürfen keinen Zwischenabstand >15mm haben.
/// </remark>

/// <remark Lang=de>
/// WALCO V Wandverbinder wird für die statisch tragenden Verbindungen
/// von Hauswänden im Fertighausbau eingesetzt.Anschlüsse sind an Holz und darüber hinaus auch an Stahl,
/// Beton und Mauerwerk möglich.
/// </remark>

/// History

/// Version 1.1   th@hsbCAD.de   17.08.2011
/// supports type 60 and 80
/// Version 1.0   th@hsbCAD.de   17.08.2011
/// initial

//basics and props
	Unit(1,"mm"); // script uses mm
	double dEps=U(.1);
	int bInDebug = false;


// constants: screw and geometry data of both types
	String sArMainArticle[] = {"K102","K103"};

	String sArKSType[] = {"Walco V60","Walco V80"};
	String sArKSArticle[] = {"Z552","Z553"};
	String sArKSDesc[] = {"V60 KS 12x60","V60 KS 16x60"};
	double dArKSLength[]={U(60), U(60)};
	double dArKSDiamInner[]={U(6.8), U(9.3)};
	double dArKSDrillDiam[]={U(7), U(10)};
	double dArKSDiamOuter[]={U(12), U(16)};
	double dArKSDiamHead[]={U(21.5), U(29.5)};
	double dArKSWasher[]={U(2), U(2.5)};
	double dArKSConeHeight[]={U(9), U(11.5)};	
	
	String sArHexArticle[] = {"Z550","Z551"};
	String sArHexDesc[] = {"V60 "+T("|Hexagon Screw|") + "6x50","V80 "+T("|Hexagon Screw|") + "10x60"};
	double dArHexLength[]={U(50), U(60)};
	double dArHexDiamOuter[]={U(6), U(10)};


	String sPropNameS0 =  T("|Type|");
	PropString sKSType(0, sArKSType, sPropNameS0 );
	sKSType.setDescription(T("|Select Type 60 or 80|"));

	String sPropNameD0 = T("|Width|") + " " + T("|Gap|");
	PropDouble dGapWidth(0, U(0), sPropNameD0 );
	dGapWidth.setDescription(T("|Defines the gap in relation to the width of the connector|"));

	String sPropNameD1 = T("|Offset|") + " " + T("|dY|");
	PropDouble dYOffset(1, U(0), sPropNameD1 );
	dYOffset.setDescription(T("|Defines an offset in Y-Direction of the connection|"));

// declare arrays for tsl cloning
	TslInst tslNew;
	Vector3d vUcsX = _XW;
	Vector3d vUcsY = _YW;
	GenBeam gbAr[2];
	Entity entAr[0];
	Point3d ptAr[1];
	int nArProps[0];
	double dArProps[0];
	String sArProps[0];
	Map mapTsl;
	String sScriptname = scriptName();



	
// on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		
		PropInt nQty(0, 1, T("|Quantity|"));	
		nQty.setDescription(T("|Defines quantity of connectors to be distributed.|") + " " + T("|A value <=1 prompts the user for the insertion point.|"));
		
		PropDouble dOffsetBottom(2, U(0), T("|Offset|") + " " + T("|Bottom|"));
		dOffsetBottom.setDescription(T("|Defines offset from the lower edge|"));
		PropDouble dOffsetTop(3, U(0), T("|Offset|") + " " + T("|Top|"));
		dOffsetTop.setDescription(T("|Defines offset from the upper edge|"));
			
		// show the dialog if no catalog in use
		if (_kExecuteKey == "")
		{
			showDialog();		
		}
		// set properties from catalog		
		else	
			setPropValuesFromCatalog(_kExecuteKey);	
		
		_Beam.append(getBeam());
		_Beam.append(getBeam(T("|Select second beam|")));
		
		
	// validate orientation
		if (!_Beam[0].vecX().isParallelTo(_Beam[1].vecX()) || !_Beam[0].vecX().isParallelTo(_ZW))	
		{
			reportMessage("\n" + T("|Beams must be parallel to each other and to world-Z|"));
			eraseInstance();	
		}
		
	// distribution
		if (nQty>1)
		{	
			_Map.setInt("Qty", nQty);	
			_Map.setDouble("OffsetBottom", dOffsetBottom);			
			_Map.setDouble("OffsetTop", dOffsetTop);	
		}
	//single insert	
		else
		{
			_Pt0 =getPoint();	
			dArProps.setLength(0);
			dArProps.append(dGapWidth);
			dArProps.append(dYOffset);
			sArProps.append(sKSType);
			ptAr[0] =_Pt0;
			
			mapTsl = Map();				

			gbAr[0] = _Beam[0];
			gbAr[1] = _Beam[1];
			tslNew.dbCreate(sScriptname, vUcsX,vUcsY,gbAr, entAr, ptAr, 
				nArProps, dArProps, sArProps,_kModelSpace, mapTsl); 
			eraseInstance();

		}
		return;		
	}	
//  end on insert


// standards
	if (_Beam.length()<2)
	{
		reportMessage("\n" + T("|Tool requires at least two beams|"));
		eraseInstance();	
	}
// validate orientation
	if (!_Beam[0].vecX().isParallelTo(_Beam[1].vecX()) || !_Beam[0].vecX().isParallelTo(_ZW))	
	{
		reportMessage("\n" + T("|Beams must be parallel to each other and to world-Z|"));
		eraseInstance();	
	}
			
	Beam bm[0];
	bm.append(_Beam[0]);
	bm.append(_Beam[1]);
	
	Vector3d vx,vy,vz;
	vx = _ZW;
	vy = bm[0].vecY();
	vz = bm[0].vecZ();
	//vy.vis(_Pt0,3);
	vx.vis(_Pt0,1);
	//vz.vis(_Pt0,150);

// the basic dimensions of the connector
	int nType = sArKSType.find(sKSType,1);
	double dArX[]={U(60), U(80)};
	double dArY[]={U(60), U(80)};
	double dArZ[]={U(15), U(15)};	


	String sMainArticle = sArMainArticle [nType];
	double dX =dArX[nType];
	double dY =dArY[nType];
	double dZ =dArZ[nType];


	String sKSArticle = sArKSArticle[nType];
	String sKSDesc =sArKSDesc[nType];
	double dKSLength=dArKSLength[nType];
	double dKSDiamInner=dArKSDiamInner[nType];
	double dKSDiamOuter = dArKSDiamOuter[nType];
	double dKSDiamHead=dArKSDiamHead[nType];
	double dKSWasher=dArKSWasher[nType];
	double dKSConeHeight=dArKSConeHeight[nType];
	double dKSDrillDiam=dArKSDrillDiam[nType];

	String sHexArticle=sArHexArticle[nType];
	String sHexDesc=sArHexDesc[nType];
	double dHexLength=dArHexLength[nType];
	double dHexDiamOuter= dArHexDiamOuter[nType];

// flag if other connectors need a remote update
	int bRemote;
	if (_kNameLastChangedProp == sPropNameD0 || _kNameLastChangedProp == sPropNameD1)
		bRemote=true;



// add triggers
	String sTrigger[] = {T("|Flip Side|")};
	for (int i = 0; i < sTrigger.length(); i++)
		addRecalcTrigger(_kContext, sTrigger[i]);	

// trigger 0: flip side
	int bFlip = _Map.getInt("flip");
	if (_bOnRecalc && _kExecuteKey==sTrigger[0])
	{
		if (bFlip )
		{
			bFlip =false;
		}
		else
			bFlip = true;
		_Map.setInt("flip",bFlip );
		bRemote=true;			
		setExecutionLoops(2);
	}
	
// flip	
	if (bFlip)
		bm.swap(0,1);	


// the display
	Display dp(252), dp1(252);

// assignment
	Element el0=bm[0].element(), el1=bm[1].element();
	if (el0.bIsValid() && el1.bIsValid())
	{
		assignToElementGroup(el0,false,0,'E');
		assignToElementGroup(el1,false,0,'E');
		dp.elemZone(el0,0,'Z');	
		dp1.elemZone(el1,0,'Z');
		
	}
	else
		assignToGroups(bm[0]);

// the bodies
	Body bd0=bm[0].realBody(),bd1=bm[1].realBody();
	bd0.vis(1);
	
// test dir
	Vector3d vzT = vz;
	Plane pn(_Pt0,vz);
	PlaneProfile ppInter = bd0.shadowProfile(pn);
	ppInter .intersectWith(bd1.shadowProfile(pn));
	// if it does not return any intersection try in the other main direction
	if (ppInter .area()<pow(dEps,2))
	{
		vzT = vy;	
		pn=Plane(_Pt0,vzT);
		ppInter = bd0.shadowProfile(pn);
		ppInter.intersectWith(bd1.shadowProfile(pn));
	// no contact in Z
		if (ppInter .area()<pow(dEps,2))
		{
			reportMessage("\n" + T("|Beams do not have a common intersection area|"));
			eraseInstance();
			return;
		}
	}
	if (vzT.dotProduct(bm[1].ptCen()-bm[0].ptCen())<0)
		vzT*=-1;
	
	Vector3d vyT = vzT.crossProduct(vx);	
	vyT.vis(_Pt0,3);	
	vzT.vis(_Pt0,150);		
	
// the width of the intersection
	LineSeg ls = ppInter.extentInDir(vyT);
	double dXInter = abs(vx.dotProduct(ls.ptStart()-ls.ptEnd()));
	double dYInter = abs(vyT.dotProduct(ls.ptStart()-ls.ptEnd()));		
	Line ln(ls.ptMid()+vzT*.5*bm[0].dD(vzT)+vyT*dYOffset,vx);
	
// validate contact width
	if (dYInter<dY)
	{
		eraseInstance();
		return;	
	}

// if qty is set in map treat the instance as distributor
	if (_Map.getInt("Qty")>1)
	{
		if (_kExecutionLoopCount==1)
		{
			eraseInstance();
			return;	
		}
		int nQty = _Map.getInt("Qty")	;	
		double dOffsetBottom = _Map.getDouble("OffsetBottom");
		double dOffsetTop= _Map.getDouble("OffsetTop");
		dArProps.setLength(0);
		dArProps.append(dGapWidth);
		dArProps.append(dYOffset);
		sArProps.append(sKSType);
		mapTsl = Map();	
	
		
		// distribute
		double dDist = dXInter-dOffsetBottom-dOffsetTop-dX;
		ls.vis(2);
			
		// get start point
	
		Point3d pt[] = {ln.closestPointTo(ls.ptStart()),ln.closestPointTo(ls.ptEnd())};
		pt = Line(_Pt0,vx).orderPoints(pt);
		Point3d ptIns= ls.ptMid();
		if (pt.length()>0)
			ptIns = pt[0]+vx*(.5*dX+dOffsetBottom);
		
		double dOffset = dDist / (nQty-1);
		
		for (int i=0;i<nQty;i++)
		{
			gbAr[0] = bm[0];
			gbAr[1] = bm[1];
			ptAr[0] = ptIns;

			if(!bInDebug)
			{
				tslNew.dbCreate(sScriptname, vUcsX,vUcsY,gbAr, entAr, ptAr, 
								nArProps, dArProps, sArProps,_kModelSpace, mapTsl); 
			}
											
			ptIns .vis(i);
			ptIns.transformBy(vx*dOffset);	
		}
		//_Map.setInt("erase",true);
		if(!bInDebug)
		{
			eraseInstance();
			return;	
		}	
	}
	
// the single instance
	Point3d ptRef = ln.closestPointTo(_Pt0);

	
// calculate the gap between the two beams
	double dGapBetween = vzT.dotProduct(bm[1].ptCenSolid()-bm[0].ptCenSolid())-.5*bm[0].dD(vzT)-.5*bm[1].dD(vzT);
	if (dGapBetween>dZ || dGapBetween<0)
	{
		reportMessage("\n" + T("|Connection not possible|"));
		eraseInstance();
		return;
	}
	ptRef.transformBy(vzT*(vzT.dotProduct(bm[1].ptCenSolid()-ptRef)-.5*bm[1].dD(vzT)));
	ptRef.vis(6);
	
// the beamcut
	double dBcX = bm[0].solidLength()*2, dBcY = dY+ dGapWidth*2, dBcZ = dZ;
	if (dBcX>0 && dBcY>0 && dBcZ>0)
	{
		BeamCut bc(ptRef,vx,vyT,vzT, dBcX,dBcY,dBcZ*2,0,0,0);
		bm[0].addTool(bc);
	}



// main screw
	Body bdScrew(ptRef, ptRef+vzT*(dKSLength-dKSWasher-dKSConeHeight),dKSDiamOuter/2);
	Point3d pt = ptRef-vzT*dKSWasher; pt.vis(1);
	bdScrew.addPart(Body(ptRef, pt,dKSDiamHead/2));
	
	Body bdCone(pt, pt-vzT*(dKSConeHeight-U(2)),dKSDiamInner/2,dKSDiamHead/2);	
	bdScrew.addPart(bdCone);
	pt.transformBy(-vzT*(dKSConeHeight-U(2)));
	bdScrew.addPart(Body(pt,pt-vzT*U(2),dKSDiamHead/2));
	dp1.draw(bdScrew);

// connector
	Body bd(ptRef-vzT*dBcZ ,vx,vyT,vzT, dX,dY,dZ-dKSWasher,0,0,1);
	bd.subPart(bdScrew);
	bd.subPart(Body(pt,pt-vzT*dX,dKSDiamHead/2));;

	int nDir=1;
	for (int i=0;i<2;i++)
	{
		PLine plSub(vx);
		plSub.addVertex(ptRef+vyT*nDir*dKSDrillDiam/2);
		plSub.addVertex(ptRef-vyT*nDir*dKSDrillDiam/2+vzT*dEps);
		plSub.addVertex(ptRef-vyT*nDir*dKSDiamHead/2-vzT*(dKSConeHeight-U(2)));
		plSub.addVertex(ptRef-vyT*nDir*dKSDiamHead/2-vzT*(dZ));
		plSub.addVertex(ptRef+vyT*nDir*dKSDrillDiam/2-vzT*(dZ));
		plSub.close();
		Body bdSub(plSub,vx*dX,1);
		bd.subPart(bdSub);
		//plSub.vis(i);
		bdSub.transformBy(vx*.25*dX);
		CoordSys cs;
		cs.setToRotation(nDir*45,-vzT,ptRef+vx*.25*dX-vyT*nDir*dKSDiamHead/2);
		bdSub.transformBy(cs);	
		bdSub.transformBy((-vx+nDir*vyT)*U(5));
		bd.subPart(bdSub);	
		//bdSub.vis(i);		
		nDir*=-1;	
	}
	
	dp.draw(bd);	
	
// drill the second beam
	double dDrillDepth = dKSLength-dKSWasher-dKSConeHeight + U(5);
	Drill dr(ptRef, ptRef+vzT*dDrillDepth, dKSDrillDiam/2);
	bm[1].addTool(dr);

			
// on creation and changing the type set the hardWrComps
	HardWrComp hwList[0];
	if (_bOnDbCreated || _kNameLastChangedProp==sPropNameS0)	
	{
	// main screw hardware
		String s = dKSDiamOuter+" x 80";				
		HardWrComp hwc("",1);
		hwc.setBVisualize(false);
		hwc.setName("Knapp" + " " + sKSDesc );
		hwc.setDescription(sKSDesc);
		hwc.setArticleNumber(sKSArticle);
		hwc.setManufacturer("Knapp");
		hwc.setModel(s);
		hwc.setMaterial(T("|Steel|"));
		hwc.setCountType(_kCTAmount);
		hwc.setDScaleX(dKSLength);
		hwc.setDScaleY(dKSDiamOuter);		
		hwc.setDScaleZ(0);	
		hwc.setQuantity(1);
		hwList.append(hwc);			

	// hexagon screw fixture
		String s2 = dHexDiamOuter+" x " +dHexLength;				
		HardWrComp hwc2("",3);
		hwc2.setBVisualize(false);
		hwc2.setName("Knapp" +" "+ sHexDesc);
		hwc2.setDescription(sHexDesc);
		hwc2.setArticleNumber(sHexArticle);		
		hwc2.setManufacturer("Knapp");
		hwc2.setModel(s2);
		hwc2.setMaterial(T("|Steel|"));
		hwc2.setCountType(_kCTAmount);
		hwc2.setDScaleX(dHexLength);
		hwc2.setDScaleY(dHexDiamOuter);		
		hwc2.setDScaleZ(0);	
		hwc2.setQuantity(3);
		hwList.append(hwc2);

		_ThisInst.setHardWrComps(hwList);					
	}
	else
		hwList = _ThisInst.hardWrComps();
	
// extended properties for the tsl
	setCompareKey(scriptName() + sKSType);
	dxaout("ArticleNumber", sMainArticle);				
	dxaout("Description", dY + "x" +dX);		
	_ThisInst.setModelDescription(sKSType);
	_ThisInst.setMaterialDescription(T("|Steel|"));
	
	
// remote control of potential other connectors
	if (bRemote && _kExecutionLoopCount==0)//bRemote)
	{
		Entity ents[0];
		TslInst tsl0[0], tsl1[0];

	// collect connectors of first beam
		ents = bm[0].eToolsConnected();
		for (int i=0;i<ents.length();i++)
			if (ents[i].bIsKindOf(TslInst()))
			{
				TslInst tsl = (TslInst)ents[i];
				Beam bmTsl[] = tsl.beam();
				if (tsl.scriptName()==scriptName() && bmTsl.find(bm[0])>-1  && bmTsl.find(bm[1])>-1 && tsl!=_ThisInst)
					tsl0.append(tsl);		
			}
	// collect connectors of second beam
		ents = bm[1].eToolsConnected();
		for (int i=0;i<ents.length();i++)
			if (ents[i].bIsKindOf(TslInst()))
			{
				TslInst tsl = (TslInst)ents[i];
				Beam bmTsl[] = tsl.beam();
				if (tsl.scriptName()==scriptName() && bmTsl.find(bm[0])>-1  && bmTsl.find(bm[1])>-1 && tsl!=_ThisInst)
					tsl1.append(tsl);		
			}
	// remote update of identical tsl's and the changed opm value/flag		
		for (int i=0;i<tsl0.length();i++)	
			if (tsl1.find(tsl0[i])>-1)
			{
				if (_bOnRecalc && _kExecuteKey==sTrigger[0])
				{
					Map map = tsl0[i].map();
					map.setInt("flip", bFlip);
					tsl0[i].setMap(map);
				}
				else if (abs(dGapWidth-tsl0[i].propDouble(0))>dEps)
					tsl0[i].setPropDouble(0,dGapWidth);
				else if (abs(dYOffset-tsl0[i].propDouble(1))>dEps)
						tsl0[i].setPropDouble(1,dYOffset);
			}
		
	}
	
	
		
#End
#BeginThumbnail
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
,%`!1110`4444`?_9
`

#End
