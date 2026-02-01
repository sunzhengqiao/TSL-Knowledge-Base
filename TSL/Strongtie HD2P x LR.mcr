#Version 8
#BeginDescription

#End
#Type E
#NumBeamsReq 1
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 0
#MinorVersion 1
#KeyWords 
#BeginContents

/// <remark Lang=de>
/// Zweiteiliger Zuganker, Ausführung links oder rechts, zur optimalen Wandtafelfertigung mit geringstem Fräsaufwand.
/// Diverse Fußteile für unterschiedliche Belastungen und Wandaufbauten. Verbindung der zwei Zugankerteile mit selbstbohrenden
/// E-JOT Blechschrauben im unteren Bereich Lastabhängige Ausnagelung durch optimierte Nagelbilder
/// </remark>


	
/// HD2P TIE RODS 2-PIECE


// basics and prop
	U(1,"mm");
	double dEps = U(0.1);


	String sArType[] = {"HD2P1L-B","HD2P1R-B","HD2P2L-B","HD2P2R-B"};
	int nArSide[] = {-1,1,-1,1};
	double dArA[] = {U(380),U(380),U(380),U(380)};
	double dArB[] = {U(220),U(220),U(163),U(163)};
	double dArC[] = {U(55),U(55),U(55),U(55)};
	double dArD[] = {U(54),U(54),U(40),U(40)};
	//double dArDiam[] = {U(),U(),U(),U()};
	int nArQtyScrew[] = {3,3,2,2};
	double dArWeight[] = {U(1.29),U(1.29),U(.16),U(.16)};// [kg]
	double dThickness = U(2);
	double dY1 = U(71.9706);
	double dZ0 = U(55);
	
	String sPropNameS0 = T("|Type|");
	PropString sType(0, sArType, sPropNameS0 );
	sType.setDescription(T("|Defines the gap in relation to the width of the connector|"));

	PropString sNoNailZones(1,"2;3",T("NoNail") + " (" + T("|Separate multiple entries by|")+ "' ;')");
	
	
// on insert
	if (_bOnInsert)
	{	
		if (insertCycleCount()>1) { eraseInstance(); return; }
		showDialog();
		
		Beam beams[0];
		PrEntity ssB(T("|Select studs|"), Beam());
		if (ssB.go())
			beams= ssB.beamSet(); 
		// filter studs
		Beam bmStuds[0];
		bmStuds = _XW.filterBeamsPerpendicularSort(beams);
			
		if (bmStuds.length()<1)
		{	
			reportNotice("\n" + T("|Invalid connection|"));
			eraseInstance();
			return;
		}

		_Pt0 = getPoint(T("|Pick point on desired side|"));	
		
	// declare the tsl props of the tls
		TslInst tslNew;
		String sScriptNameDim = scriptName(); // name of the script
		Vector3d vUcsX = _XW;
		Vector3d vUcsY = _YW;
		Beam bmAr[1];
		Entity entAr[0];
		Point3d ptAr[1];
		int nArProps[0];
		double dArProps[0];
		String sArProps[0];
		Map mapTsl;
		//dArProps.append(dGap);
		//dArProps.append(dMillInStud);		

		sArProps.append(sType);		
		sArProps.append(sNoNailZones);
		//nArProps.append(nColor);
		
		ptAr[0] = _Pt0;
								
		// create instances for each stud
		for (int i=0;i < bmStuds.length();i++)
		{
			bmAr[0] =bmStuds[i];	
			
		// with a valid element ref project this point to the element bottom	
			Element el = bmAr[0].element();
			if (el.bIsValid())
			{
				ptAr[0].transformBy(el.vecY()*el.vecY().dotProduct(el.ptOrg()-ptAr[0]));
				entAr.setLength(0);
				entAr.append(el);
				
				if (el.vecZ().dotProduct(_Pt0-el.ptOrg())<0)
					mapTsl.setInt("flip",true);
				
			}
			
			tslNew.dbCreate(sScriptNameDim , vUcsX,vUcsY,bmAr, entAr, ptAr, 
								nArProps, dArProps, sArProps, _kModelSpace,mapTsl); 
		}
		
		eraseInstance();
		return;		
	}// end on insert_______________________________________________________________________________________________

// standards
	if (_Beam.length()<0)
	{
		eraseInstance();
		return;
	}
	Beam bm = _Beam[0];	

// collect other beams from entity array
	GenBeam gbOthers[0];
	for (int i=0;i<_Beam.length();i++)
	{
		Beam bmOther =_Beam[i];
		if (bmOther.bIsValid() && !bmOther.vecX().isParallelTo(_X0))
			gbOthers.append(bmOther);
		
	}


// ints
	int nType = sArType.find(sType);
	int nSide = nArSide[nType];
	int bFlip =_Map.getInt("flip");
// element related
	Element el;
	if (_Element.length()>0)
		el = _Element[0];

// Display
	Display dp(252);	
	
// assignment
	if (el.bIsValid())
	{
		assignToElementGroup(el,true,0,'E');
		dp.elemZone(el,0,'I');	
	}	
	
// vecs
	Vector3d vx,vy,vz;
	vy = -_X0;
	vz = _Z0;
	if (bFlip ) vz*=-1;
	vx = vy.crossProduct(vz);

	vx.vis(_Pt0,1);	
	vy.vis(_Pt0,3);
	vz.vis(_Pt0,150);

	
		

// the ref point
	Point3d ptRef = _Pt0+nSide*vx*.5*bm.dD(vx)+vz*(.5*bm.dD(vz));
	ptRef.vis(6);	

// beamcut depth
	double dXBc = U(60), dYBc = U(70), dZBc = U(4);		
	BeamCut bc(ptRef, vx,vy,vz,dXBc,dYBc,dZBc*2,nSide,1,0);
	//bc.cuttingBody().vis(2);
	bc.addMeToGenBeamsIntersect(gbOthers);	

// Metalpart
	Body bd1(ptRef+vy*dY1,vx,vy,vz,dThickness, dArA[nType]-dY1,dZ0,nSide,1,-1 );
	PLine plTriang(vz);
	
	double dXRef, dYRef;
	dXRef = U(4.5);	dYRef = U(7);
	plTriang.addVertex(ptRef+nSide*vx*dXRef + vy*dYRef);
	dXRef = U(4.5);	dYRef = dY1;
	plTriang.addVertex(ptRef+nSide*vx*dXRef + vy*dYRef);
	dXRef = dThickness;	dYRef = dY1;	
	plTriang.addVertex(ptRef+nSide*vx*dXRef + vy*dYRef);
	dXRef = dThickness;	dYRef = U(256);	
	plTriang.addVertex(ptRef+nSide*vx*dXRef + vy*dYRef);
	dXRef = U(57.5);	dYRef = U(131);	
	plTriang.addVertex(ptRef+nSide*vx*dXRef + vy*dYRef);
	dXRef = U(57.5);	dYRef = U(7);	
	plTriang.addVertex(ptRef+nSide*vx*dXRef + vy*dYRef);
	plTriang.close();
	Body bd2(plTriang,-vz*dThickness,1);
	
	// shoe
	PLine plShoe(vz);
	dXRef = U(64);
	dYRef = U(45);
	double dRadius = U(8);
	int nWise = _kCWise;
	if (nSide>0)nWise = _kCCWise;
	plShoe.addVertex(ptRef);
	plShoe.addVertex(ptRef-vy*(dYRef-dRadius ));
	plShoe.addVertex(ptRef-vy*(dYRef)+nSide*vx*dRadius ,dRadius , nWise );		
	plShoe.addVertex(ptRef-vy*(dYRef)+nSide*vx*(dXRef-dRadius));
	plShoe.addVertex(ptRef-vy*(dYRef-dRadius)+nSide*vx*(dXRef),dRadius , nWise);
	plShoe.addVertex(ptRef+nSide*vx*(dXRef));
	
	nWise = _kCCWise;
	if (nSide>0)nWise = _kCWise;
		
	plShoe.addVertex(ptRef+nSide*vx*(dXRef-U(3)));
	plShoe.addVertex(ptRef-vy*(dYRef-dRadius)+nSide*vx*(dXRef-U(3)));
	plShoe.addVertex(ptRef-vy*(dYRef-U(3))+nSide*vx*(dXRef-dRadius),U(6) , nWise);
	plShoe.addVertex(ptRef-vy*(dYRef-U(3))+nSide*vx*dRadius);
	plShoe.addVertex(ptRef-vy*(dYRef-dRadius)+nSide*vx*U(3),U(6) , nWise);
	plShoe.addVertex(ptRef+nSide*vx*(U(3)));	
	plShoe.close();
	Body bd3(plShoe, vz*dArB[nType],1);
	Point3d ptShoe = ptRef+vz*dArB[nType]-vy*U(25);
	Vector3d vzShoe = vz;
	vzShoe=vzShoe.rotateBy(75,-vx);
	// cut front end
	bd3.addTool(Cut(ptShoe,vzShoe),0);
	// cut base end	
	ptShoe = ptRef+vz*U(10);
	vzShoe = vz;
	vzShoe=vzShoe.rotateBy(171.33,-vx);	
	bd3.addTool(Cut(ptShoe,vzShoe),0);
		
	bd3.transformBy(vy*dYRef+vx*nSide*U(.9133));
	Point3d ptDr = ptRef+nSide*vx*.5*dXRef;
	Drill dr3;
	if (nType<2)
	{
		ptDr.transformBy(vz*U(55));
		dr3=Drill (ptDr-vy*U(10),ptDr+vy*U(10), U(9));	
	}
	else
	{
		ptDr.transformBy(vz*U(50));	
		dr3=Drill(ptDr-vy*U(10),ptDr+vy*U(10), U(6.5));			
	}
	bd3.addTool(dr3);
	vzShoe.vis(ptShoe,4);	
	//bd3.vis(2);	

	// head plate
	Body bd4(ptRef, vx,vy,vz, dArD[nType], U(65),U(3),0,1,1);
	bd4.transformBy(nSide*vx*U(32.133));
	//bd4.vis(3);

	Body bdMain = bd1;
	bdMain.addPart(bd2);
	bdMain.addPart(bd3);
	bdMain.addPart(bd4);
	bdMain.transformBy(-vz*(dZBc-dThickness));
	dp.draw(bdMain);	


// collect nonail zones
	int nArNoNailZone[0];
	for (int i = 0; i < 11; i++)
	{
		String sToken = sNoNailZones.token(i, ";")	;
		if (sToken != "")
		{
			sToken.trimLeft();
			sToken.trimRight();					
			int nZn = sToken.atoi();
			if (nZn > -6 && nZn < 6 && nZn!=0)
				nArNoNailZone.append(nZn);
		}
	}
	
// no nails
	PLine plNN(vz);
	plNN.createRectangle(LineSeg(ptRef, ptRef+nSide*vx*U(60)+vy*U(260)),vx,vy);//dArA[nType]),vx,vy);
	plNN.vis(1);	
	
	int nNNDir =1;
	if (!bFlip) nNNDir*=-1;
	
	// Place no nailing zone on elementzone
	for (int i=0;i<nArNoNailZone.length();i++)
	{
		if (el.zone(nArNoNailZone[i]).dH()<dEps)continue;
		
		plNN.setNormal(el.zone(nArNoNailZone[i]).vecZ());
		ElemNoNail noNail(nNNDir*nArNoNailZone[i], plNN);
		el.addTool(noNail);
	}	
#End
#BeginThumbnail

#End
