#Version 8
#BeginDescription
V1.17__01/06/2021__Fixed for non slopped panels 
--Will generate bottom and center blocking for roof panels
V1.16__11 Oct 2020__Updated to correctly get slopes and heights whether placed in the x-vector or y-vector of the truss entity.
V1.15__06 Sep 2020__More accurate slope calculation.
V1.14__28 Sep 2020__Fixed issue with edge-case roof panels not detecting slopes/correct beam orientation
V1.13__01 Sep 2020__Changed to work regardless slope direction
Added gap option
V1.12__08/19/2020__Added sploped trusses support
FIxed Only Element Joist option. FIxed Keep Cuts Square
V1.11__09/23/2019__Added Truss Support
V1.10__15May2018__Added nominal size lumber
V1.9__15March2018__Added lateral and vertical offset enhancements
V1.8__20Nov2017__Added Justification
V1.7__13Sept2017__Removed the explicite list of profiles
V1.6__04January2017__Several little updates
V1.5__28March2016__Can now be staggered
V1.4__7July2015__Blocking for to individual panels
V1.3__8July2014__List is now filtered, Loose items are in panel but tagged loose in cut list
V1.2__10 June 2014__Newly created blocking gets hsbId of 4113 and type of _kBlocking
V1.1__Jan 30 2014__Added sorting to profile list
















#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 17
#KeyWords 
#BeginContents
	Unit(1,"inch"); // script uses inch

	//__Only used these profiles, make it empty if not desired
	String arProfilesUsed[0];//={"11 7-8 BC RIM BOARD", "11 7-8 BCI 4500S 1.8","16 BC RIM BOARD","16 BCI 4500S 1.8", "11 7-8 BCI 4500s 1.8", "16 BCI 4500s 1.8"};

	int sProp=1,dProp=1,iProp=1;
	double dTH = U(1.5);

	String arDescriptionBlk[]={"**Like Joist"};
	double arDBlkW[]={U(0)};
	double arDBlkH[]={U(0)};

	arDescriptionBlk.append("2x4"); arDBlkH.append(U(1.5)); arDBlkW.append(U(3.5));
	arDescriptionBlk.append("2x6"); arDBlkH.append(U(1.5)); arDBlkW.append(U(5.5));
	arDescriptionBlk.append("2x8"); arDBlkH.append(U(1.5)); arDBlkW.append(U(7.25));
	arDescriptionBlk.append("2x10"); arDBlkH.append(U(1.5)); arDBlkW.append(U(9.25));
	arDescriptionBlk.append("2x12"); arDBlkH.append(U(1.5)); arDBlkW.append(U(11.25));

	ExtrProfile epList[]= ExtrProfile().getAllEntries();
	String epNameList[]= ExtrProfile().getAllEntryNames();

	if(arProfilesUsed.length() > 0)
	{
		for(int s=0;s<arProfilesUsed.length();s++)
		{
			int iF = epNameList.find(arProfilesUsed[s]);

			if(iF > -1)
			{
				ExtrProfile ep=epList[iF];
				String stName = epNameList[iF];

				PlaneProfile ppEp=ep.planeProfile();
				LineSeg lsW=ppEp.extentInDir(_XW);
				LineSeg lsH=ppEp.extentInDir(_YW);

				arDescriptionBlk.append(stName);
				arDBlkW.append(abs(_XW.dotProduct(lsW.ptStart()-lsW.ptEnd())));
				arDBlkH.append(abs(_YW.dotProduct(lsH.ptStart()-lsH.ptEnd())));
			}
		}
	}
	else
	{
		//Take all
		for(int i=0;i<epList.length();i++)
		{
			ExtrProfile ep=epList[i];
			String stName = epNameList[i];

			if(stName.makeUpper() == "RECTANGULAR" || stName.makeUpper() == "ROUND")continue;

			PlaneProfile ppEp=ep.planeProfile();
			LineSeg lsW=ppEp.extentInDir(_XW);
			LineSeg lsH=ppEp.extentInDir(_YW);
			ppEp.vis(1);
			lsW.vis(2);

			arDescriptionBlk.append(stName);
			arDBlkW.append(abs(_XW.dotProduct(lsW.ptStart()-lsW.ptEnd())));
			arDBlkH.append(abs(_YW.dotProduct(lsH.ptStart()-lsH.ptEnd())));
		}
	}

//__Sort the list
	for ( int i = arDescriptionBlk.length() -1; i >=0  ; i-- ) {
		int iMax = i ;
		for ( int j = 0; j	<= i  ; j++ ) {
			if ( arDescriptionBlk[ iMax ] < arDescriptionBlk[j] ) {
				iMax = j ;
			}
		}
		arDescriptionBlk.swap(iMax, i ) ;
		arDBlkW.swap(iMax, i ) ;
		arDBlkH.swap(iMax, i ) ;
	}

	String arYN[]={"Yes","No"};

	PropString stBeam(sProp++,arDescriptionBlk,"Beam type");

	if(arDescriptionBlk.find(stBeam) == -1)stBeam.set(arDescriptionBlk[0]);

	PropString stLoose(sProp++,arYN, "All Material Loose",1);
	PropString stAddEnds(sProp++,arYN, "Do Ends",0);
	PropDouble dMinLength(dProp++,U(6),"Minimum Length");
	PropString stStagger(sProp++,arYN, "Staggered",1);

	String arJoistsFindOptions[]={"All Floor Joists","Only Element Joists"};
	PropString stJoistFind(sProp++, arJoistsFindOptions, "Joist to use",0);

	PropString stKeepSquare(sProp++, arYN, "Keep Cuts Square",0);

	PropString stDim(sProp++, _DimStyles, "DimStyle");

	String arVerticalJustification[]={ "Top", "Center" , "Bottom"};
	String arLateralJustification[]={ "Left", "Center" , "Right"};
	int arIJustification[]={ -1,0,1};

	PropString stVerticalJustification(sProp++, arVerticalJustification, "Vertical Justification",1);
	int iZOff = arIJustification[arVerticalJustification.find(stVerticalJustification) ];

	PropString stLateralJustification(sProp++, arLateralJustification, "Lateral Justification",1);
	int iYOff = arIJustification[arLateralJustification.find(stLateralJustification) ];

	PropDouble dBlockingGap(dProp++, U(0), "Blocking Gap");

	if (_bOnInsert ) {

		if(insertCycleCount()>1)eraseInstance();

		showDialog();

		_PtG.append(getPoint("\nSelect start point"));
		Point3d ptLast = _PtG[0];

		while (1) {
			PrPoint ssP2("\nSelect next point",ptLast);
			if (ssP2.go()==_kOk) { // do the actual query
				ptLast = ssP2.value(); // retrieve the selected point
				_PtG.append(ptLast); // append the selected points to the list of grippoints _PtG
				break;
			}
		}

		ElementRoof elR = getElementRoof("\nSelect a reference Element");

		double dElev=U(0);

		if(elR.bIsValid())
		{
			dElev = elR.ptOrg().Z();

			_Element.append(elR);
		}

		Plane pnW(Point3d(0,0,dElev),_ZW);
		_PtG= pnW.projectPoints(_PtG);
		_Pt0.setToAverage(_PtG);

		Vector3d vBm(_PtG[0]-_PtG[1]);
		vBm.normalize();

		Vector3d vOff=vBm.crossProduct(_ZW);
	}

//__Validation
	ElementRoof elR;

	if(_Element.length() > 0){
		ElementRoof entElR=(ElementRoof)_Element[0];
		if(entElR.bIsValid())elR=entElR;
		else
		{
			reportMessage("\nNo valid element for TSL '" + scriptName() + "'");
			eraseInstance();
			return;
		}
	}

	assignToElementGroup(elR,TRUE,0,'Z');

//__Set joist Type
	int ib = arDescriptionBlk.find(stBeam);
	arDescriptionBlk[0]=elR.beamExtrProfile();
	arDBlkW[0]=elR.dBeamHeight();
	arDBlkH[0]=elR.dBeamWidth();

//__Get proper group and elements
	Group gEl = elR.elementGroup();
	Group g(gEl.namePart(0) + "\\" + gEl.namePart(1));
	g.addEntity(_ThisInst);

//__Reset grips if needed
	if(_kNameLastChangedProp == "_Pt0")
	{
		_PtG[0] = Point3d(_Map.getDouble("mpPtG0\\dX"),_Map.getDouble("mpPtG0\\dY"),_Map.getDouble("mpPtG0\\dZ"));
		_PtG[1] = Point3d(_Map.getDouble("mpPtG1\\dX"),_Map.getDouble("mpPtG1\\dY"),_Map.getDouble("mpPtG1\\dZ"));

		Vector3d vOff(_Map.getDouble("mpVecY\\dX"),_Map.getDouble("mpVecY\\dY"),_Map.getDouble("mpVecY\\dZ"));
		vOff.normalize();

		Line ln0(_Pt0,vOff.crossProduct(_ZW));

		_PtG[0] = Line(_PtG[0],vOff).closestPointTo(ln0);
		_PtG[1] = Line(_PtG[1],vOff).closestPointTo(ln0);
	}

	_PtG = Plane(elR.ptOrg() - (elR.dBeamWidth()/2 + (elR.dBeamWidth()/2 * iZOff)) * elR.vecZ() , elR.vecZ()).projectPoints(_PtG);

//__Display

	Display dp(-1);
	dp.dimStyle(stDim);
	dp.textHeight(dTH);
	if(_PtG.length()!=2)eraseInstance();

	LineSeg ls(_PtG[0],_PtG[1]);
	dp.draw(ls);

//__Vectors

	Vector3d vBmX=(_PtG[0]-_PtG[1]); vBmX.normalize();
	Vector3d vBmY=_ZW.crossProduct(vBmX); //vBmY.normalize();
	Vector3d vBmZ=vBmY.crossProduct(vBmX); //vBmZ.normalize();

//__Store points to be used later one
	_Map.setDouble("mpPtG0\\dX",_PtG[0].X());
	_Map.setDouble("mpPtG0\\dY",_PtG[0].Y());
	_Map.setDouble("mpPtG0\\dZ",_PtG[0].Z());

	_Map.setDouble("mpPtG1\\dX",_PtG[1].X());
	_Map.setDouble("mpPtG1\\dY",_PtG[1].Y());
	_Map.setDouble("mpPtG1\\dZ",_PtG[1].Z());

	_Map.setDouble("mpVecY\\dX",vBmY.X());
	_Map.setDouble("mpVecY\\dY",vBmY.Y());
	_Map.setDouble("mpVecY\\dZ",vBmY.Z());

//__Reset _Pt0
	LineSeg lsPt0(_PtG[0] - vBmX*dTH,_PtG[1] + vBmX*dTH);
	_Pt0 = lsPt0.closestPointTo(_Pt0);

	Line lnCreate(_PtG[0], vBmX);

	int iSideFlag = 0;
	if(stStagger == arYN[0])iSideFlag = 1;

	double dLineOff = 0;
	lnCreate.transformBy((arDBlkW[ib]/2 + arDBlkW[ib]/2*iSideFlag)  * iYOff * vBmY);

	//__Do Plan view text
	Vector3d vTest(_YW-(_XW*0.8));

	Vector3d vxTxt=vBmX,vyTxt=-vBmY;
	double dAngleTest=vyTxt.angleTo(vTest);
	if(dAngleTest>90){
		vxTxt=-vBmX;
		vyTxt=vBmY;
	}
	vxTxt=vyTxt.crossProduct(_ZW);

	Point3d ptText = _Pt0+vyTxt*1.5*dTH;
	dp.draw("BLK RUN ("+arDescriptionBlk[ib]+")",ptText,vxTxt,vyTxt,0,0);

//__Generate beams
	String stReCreateBeams = "Generate Pieces";

	addRecalcTrigger(_kContext,stReCreateBeams);


	if(_bOnRecalc || _bOnInsert || _bOnDbCreated || _bOnElementConstructed || _kExecuteKey == stReCreateBeams || _kNameLastChangedProp == "_Pt0" || _kNameLastChangedProp == "_PtG0" || _kNameLastChangedProp == "_PtG1" || _kNameLastChangedProp == "Justification")
	{
		//Clear existing
		Map mpBm=_Map.getMap("mpBms");
		for(int b=0;b<mpBm.length();b++)
		{
			Entity ent=mpBm.getEntity(b);
			if(ent.bIsValid())
			{
				ent.dbErase();
			}
		}
		_Map.removeAt("mpBms",TRUE);
		mpBm=Map();

		//Body to decompose later
		Body bd(_PtG[0], _PtG[1], U(.25));
		bd.transformBy(elR.vecZ() * iZOff * U(2));

		Entity arBm[0];
		if(stJoistFind == arJoistsFindOptions[0])
		{
			Entity entsG[]=g.collectEntities(TRUE, Beam(), _kModelSpace);
			entsG.append(g.collectEntities(true, TrussEntity(), _kModelSpace));
			for(int i=0;i<entsG.length();i++)
			{
				Beam bm=(Beam)entsG[i];
				if(bm.bIsValid())arBm.append(entsG[i]);
				TrussEntity te = (TrussEntity) entsG[i];
				if (te.bIsValid()) arBm.append(entsG[i]);
			}
		}
		else
		{
			Group elG = elR.elementGroup();
			arBm.append(elG.collectEntities(true, Beam(), _kModelSpace));
			arBm.append(elG.collectEntities(true, TrussEntity(), _kModelSpace));
		}
	//__Collect all floor element
		Entity arEntEl[]=g.collectEntities(true,ElementRoof(),_kModelSpace);
	//__Do the work
		Entity arBmTouched[0];
		Quader qdTouched[0];
		Vector3d vcTopChords[0], vcTopChordsHz[0];
		Point3d ptTopChords[0];
		Body bdTopChordsHz[0];
		for(int i; i<arBm.length(); ++i)
		{
			Body bdReal;
			Quader qdI;
			if (arBm[i].bIsKindOf(Beam()))
			{
				Beam bmQ = (Beam) arBm[i];
				qdI = bmQ.quader();
				bdReal = bmQ.envelopeBody();
			}
			else if (arBm[i].bIsKindOf(TrussEntity()))
			{
				TrussEntity te = (TrussEntity) arBm[i];
				TrussDefinition td = te.definition();
				Map mp = td.subMapX("Content");
				double sizes[] = { mp.getVector3d("Length").length(), mp.getVector3d("Width").length(), mp.getVector3d("Height").length()};
				CoordSys csT = te.coordSys();
				Quader qdT(csT.ptOrg() + 0.5*sizes[0]*csT.vecX() + 0.5*sizes[2]*csT.vecZ(), csT.vecX(), csT.vecY(), csT.vecZ(), sizes[0], sizes[1], sizes[2], 0, 0, 0);
				qdI = qdT;
				bdReal = Body(qdT);
				if (bd.hasIntersection(Body(bdReal)))
				{
					if (csT.vecX().isParallelTo(elR.vecY()))
					{
						Beam bmTruss[] = td.beam();
						Body bdAngled[0], bdNonAngled[0];
						int bParapetFound = false;
						Vector3d vcAngled[0], vcNonAngled[0];
						Point3d ptsAll[0];
						for (int k = 0; k < bmTruss.length(); k++)
						{
							Body bdK = bmTruss[k].realBody();
							bdK.transformBy(csT);
							Vector3d vcX = bmTruss[k].vecX();
							vcX.transformBy(csT);
							if (vcX.isParallelTo(_ZW))
							{
								Point3d ptT = bdK.ptCen() + 0.5 * bmTruss[k].dL() * _ZW;
								Point3d ptQ = csT.ptOrg() + sizes[2] * csT.vecZ();
								if (abs((ptQ - ptT).dotProduct(_ZW)) < U(0.125)) bParapetFound = true;
							}
							else
							{
								if (abs(vcX.dotProduct(_ZW)) > 0)
								{
									bdAngled.append(bdK);
									vcAngled.append(vcX);
								}
								else
								{
									bdNonAngled.append(bdK);
									vcNonAngled.append(vcX);
								}
								ptsAll.append(bdK.allVertices());
							}
						}
						if (bParapetFound && stVerticalJustification == arVerticalJustification[0])
						{
							ptsAll = Line(_PtW, - _ZW).orderPoints(ptsAll);
							for (int m; m < bdAngled.length(); ++m)
							{
								Point3d ptsAngled[] = bdAngled[m].allVertices();
								if (ptsAngled.find(ptsAll[0]) >- 1)
								{
									vcTopChords.append(vcAngled[m]);
									ptTopChords.append(ptsAll[0]);
								}
							}
							for (int m; m < bdNonAngled.length(); ++m)
							{
								Point3d ptsNonAngled[] = bdNonAngled[m].allVertices();
								if (ptsNonAngled.find(ptsAll[0]) >- 1)
								{
									vcTopChordsHz.append(vcNonAngled[m]);
									bdTopChordsHz.append(bdNonAngled[m]);
								}
							}
						}
					}
					else if (csT.vecX().isParallelTo(elR.vecX()))
					{
						Beam bmTruss[] = td.beam();
						Body bdAngled[0], bdNonAngled[0];
						int bParapetFound = false;
						Vector3d vcAngled[0], vcNonAngled[0];
						Point3d ptsAll[0];
						for (int k = 0; k < bmTruss.length(); k++)
						{
							Body bdK = bmTruss[k].realBody();
							bdK.transformBy(csT);
							Vector3d vcY = bmTruss[k].vecX();
							vcY.transformBy(csT);
							if (vcY.isParallelTo(_ZW))
							{
								Point3d ptT = bdK.ptCen() + 0.5 * bmTruss[k].dL() * _ZW;
								Point3d ptQ = csT.ptOrg() + sizes[2] * csT.vecZ();
								if (abs((ptQ - ptT).dotProduct(_ZW)) < U(0.125)) bParapetFound = true;
							}
							else
							{
								if (abs(vcY.dotProduct(_ZW)) > 0)
								{
									bdAngled.append(bdK);
									vcAngled.append(vcY);
								}
								else
								{
									bdNonAngled.append(bdK);
									vcNonAngled.append(vcY);
								}
								ptsAll.append(bdK.allVertices());
							}
						}
						if (bParapetFound && stVerticalJustification ==arVerticalJustification[0])
						{
							ptsAll = Line(_PtW, - _ZW).orderPoints(ptsAll);
							for (int m; m < bdAngled.length(); ++m)
							{
								Point3d ptsAngled[] = bdAngled[m].allVertices();
								if (ptsAngled.find(ptsAll[0]) >- 1)
								{
									vcTopChords.append(vcAngled[m]);
									ptTopChords.append(ptsAll[0]);
								}
							}
							for (int m; m < bdNonAngled.length(); ++m)
							{
								Point3d ptsNonAngled[] = bdNonAngled[m].allVertices();
								if (ptsNonAngled.find(ptsAll[0]) >- 1)
								{
									vcTopChordsHz.append(vcNonAngled[m]);
									bdTopChordsHz.append(bdNonAngled[m]);
								}
							}
						}
					}
				}
			}

			if(bd.hasIntersection(Body(bdReal)))
			{
				arBmTouched.append(arBm[i]);
				qdTouched.append(qdI);
				Body bdSub = bdReal;
				Point3d testPoint = bdReal.ptCen();
				if(!qdI.vecX().isParallelTo(vBmX))
				{
					bdSub.transformBy(qdI.vecX() * 0.5*qdI.dD(qdI.vecX()));
					bd.subPart(bdSub);
					bdSub.transformBy(-1 *qdI.vecX() * qdI.dD(qdI.vecX()));
					bd.subPart(bdSub);
				}
				else
				{
					bd.subPart(bdSub);
				}
			}
		}
		//check if panel is slopped
			int bisSloped = false;
			Vector3d ax, ay, az, aStay;
			if (vcTopChords.length()>0)
			{
				bisSloped = true;
				ax = elR.vecX(); aStay = ax;
				ay = (vcTopChords[0].dotProduct(elR.vecY()) > 0 ? 1 : - 1) * vcTopChords[0];
				az = ay.crossProduct(elR.vecX());
				if (az.dotProduct(_ZW) < 0) az = - az;				
			}
			else
			{
				Body bdChordsY[0], bdChordsX[0];
				for (int n; n<bdTopChordsHz.length(); ++n)
				{
					if (vcTopChordsHz[n].isParallelTo(elR.vecY())) bdChordsY.append(bdTopChordsHz[n]);
					else bdChordsX.append(bdTopChordsHz[n]);
				}
				if (bdChordsY.length()>1)
				{
					Vector3d vcSort = elR.vecX();
					Point3d ptsAll[0];
					for (int n; n < bdChordsY.length(); ++n)
					{
						Body bdN = bdChordsY[n];
						ptsAll.append(bdN.ptCen() + 0.5 * bdN.lengthInDirection(_ZW) * _ZW - 0.5 * bdN.lengthInDirection(vcSort) * vcSort);
						ptsAll.append(bdN.ptCen() + 0.5 * bdN.lengthInDirection(_ZW) * _ZW + 0.5 * bdN.lengthInDirection(vcSort) * vcSort);
					}

					ptsAll = Line(_PtW, vcSort).orderPoints(ptsAll);
					double Zdiff = (ptsAll.last() - ptsAll.first()).dotProduct(_ZW);
					if (abs(Zdiff)>0)
					{

						ax = Zdiff > 0 ? (ptsAll[ptsAll.length() - 2] - ptsAll.first()) : (ptsAll.last() - ptsAll[1]);
						ax.normalize();
						if (ax.dotProduct(vcSort) < 0) ax = - ax;
						ay = elR.vecY(); aStay = ay;
						az = ax.crossProduct(ay);
						if (az.dotProduct(elR.vecZ()) < 0) az = - az;
						ptTopChords.append(Zdiff > 0 ? ptsAll[ptsAll.length() - 2] : ptsAll[1]);
						bisSloped = true;
						reportMessage("\n qty: " + ptsAll.length() + " ifound: " + ptsAll.find(ptTopChords[0])+" bds: "+bdChordsY.length());
					}
				}
				else
				{
					if (bdChordsX.length() > 1)
					{

						Vector3d vcSort = elR.vecY();
						Point3d ptsAll[0];
						for (int n; n < bdChordsX.length(); ++n)
						{
							Body bdN = bdChordsX[n];
							ptsAll.append(bdN.ptCen() + 0.5 * bdN.lengthInDirection(_ZW) * _ZW - 0.5 * bdN.lengthInDirection(vcSort) * vcSort);
							ptsAll.append(bdN.ptCen() + 0.5 * bdN.lengthInDirection(_ZW) * _ZW + 0.5 * bdN.lengthInDirection(vcSort) * vcSort);
						}

						ptsAll = Line(_PtW, vcSort).orderPoints(ptsAll);
						double Zdiff = (ptsAll.last() - ptsAll.first()).dotProduct(_ZW);
						if (abs(Zdiff) > 0)
						{
							ax = elR.vecX(); aStay = ax;
							ay = Zdiff > 0 ? (ptsAll[ptsAll.length() - 2] - ptsAll.first()) : (ptsAll.last() - ptsAll[1]);
							ay.normalize();
							if (ay.dotProduct(vcSort) < 0) ay = - ay;
							Vector3d az = ay.crossProduct(ax);
							if (az.dotProduct(elR.vecZ()) < 0) az = - az;
							ptTopChords.append(Zdiff > 0 ? ptsAll[ptsAll.length() - 2] : ptsAll[1]);
							bisSloped = true;
						}

					}
				}
			}
			
			if (!bisSloped) 
			{
				ax = lnCreate.vecX();
				az = _ZW;
				ay = ax.crossProduct(az);
			}
		Body bdAll[] = bd.decomposeIntoLumps();

		//sort them
		for ( int i = bdAll.length() -1; i >=0  ; i-- )
		{
			double d1=vBmX.dotProduct(bdAll[i].ptCen()-_Pt0);
			int iMax = i ;
			for ( int j = 0; j	<= i  ; j++ ) {
				double d2=vBmX.dotProduct(bdAll[j].ptCen()-_Pt0);
				if ( d1 < d2 ) {
					d1=d2;
					iMax = j ;
				}
			}
			bdAll.swap(iMax, i ) ;
		}




		int iStart=0,iStop=bdAll.length();
		if(stAddEnds == arYN[1])
		{
			iStart++;
			iStop--;
		}
		
		CoordSys testCoors1 = CoordSys(lnCreate.ptOrg(), lnCreate.vecX(), ay, lnCreate.vecX().crossProduct(ay));

		for(int i=iStart;i<iStop;i++)
		{
			Body bdThis = bdAll[i];

			double dL = bdThis.lengthInDirection(vBmX);
			if(dL<dMinLength)continue;

			//__Create the beam
			String stText=arDescriptionBlk[ib];
			double dW=arDBlkW[ib];
			double dH=arDBlkH[ib];

			Beam bm;
			Point3d extremes[] = bdThis.extremeVertices(lnCreate.vecX());
			Point3d bdCen = (extremes.first() + extremes.last()) / 2;
			bm.dbCreate(lnCreate.closestPointTo(bdCen),lnCreate.vecX(),ay,lnCreate.vecX().crossProduct(ay),dL,dW,dH,0,iSideFlag, iZOff*-1);
			bm.setHsbId("4113");
			bm.setType(_kBlocking);
			bm.setColor(213);
			bm.setExtrProfile(arDescriptionBlk[ib]);
			bm.setName(arDescriptionBlk[ib]);
			mpBm.appendEntity("bm",bm);
			
			if(dW>dH)
			{
				CoordSys csNew(bm.ptCen(), bm.vecX(), bm.vecZ(), bm.vecY());
				bm.setCoordSys(csNew);
				bm.setD(bm.vecY(), dH);
				bm.setD(bm.vecZ(), dW);
			}

			Point3d ptBmTop = bm.ptCen() + 0.5 * bm.dD(_ZW) * _ZW;
			
			bm.vecX().vis(ptBmTop, 3);
			Vector3d test1 = bm.vecX();
			Vector3d test2 = elR.vecX();
			
			if (bisSloped && ay.isParallelTo(elR.vecY()))
			{
				CoordSys csTry;
				csTry.setToRotation(az.angleTo(elR.vecZ(), aStay), -aStay, ptBmTop);
				bm.transformBy(csTry);
				bm.transformBy((Plane(ptTopChords[0], az).intersect(Plane(ptBmTop, aStay)).closestPointTo(ptBmTop) - ptBmTop).dotProduct(_ZW)*_ZW);
			}
			else if (ptTopChords.length() > 0)
			{
				bm.transformBy((Plane(ptTopChords[0], lnCreate.vecX().crossProduct(ay)).intersect(Plane(ptBmTop, aStay)).closestPointTo(ptBmTop) - ptBmTop).dotProduct(_ZW)*_ZW);
			}
			
			iSideFlag = iSideFlag * -1;

			//__See what element it belongs to.
			int iGotEl = false;
			for(int e=0;e<arEntEl.length();e++)
			{
				ElementRoof el = (ElementRoof)arEntEl[e];
				if(!el.bIsValid())continue;

				PlaneProfile ppEl(el.plEnvelope());
				if(ppEl.pointInProfile(bdThis.ptCen()) !=1)
				{
					iGotEl = true;
					bm.assignToElementGroup(el,true,0,'Z');
				}


			}

			if(!iGotEl )g.addEntity(bm);

			if(stLoose == arYN[0])
			{
				bm.setInformation("Loose");
			}


			if(stKeepSquare == arYN[1])
			{
				//__Get closest beams
				for (int nSide=0; nSide<2; nSide++) { // loop for positive and negative side
					Point3d ptBm = bm.ptCen();
					if (nSide==1) vBmX = -vBmX;
					String arFiltered[0];
					for (int q=0; q<arBmTouched.length(); q++)
					{
						Point3d ptsInter[] = Body(qdTouched[q]).intersectPoints(Line(ptBm, vBmX));
						if (ptsInter.length()>0)
						{
							ptsInter = Line(ptBm, vBmX).orderPoints(ptsInter);
							arFiltered.append(String().format("%09.4f", (ptsInter.first() - ptBm).dotProduct(vBmX)) + "@" + String(q));
						}
					}
					String arFilteredSorted[] = arFiltered.sorted();
					if (arFilteredSorted.length()>0) {
						Beam bmHit = (Beam) arBmTouched[arFilteredSorted.first().token(1, "@").atoi()]; // take first beam from filtered list because it is closest.
						if (bmHit.bIsValid()) bm.stretchStaticTo(bmHit, true);
						else
						{
							Beam bmTemp;
							bmTemp.dbCreate(Body(qdTouched[arFilteredSorted.first().token(1, "@").atoi()]));
							bm.stretchStaticTo(bmTemp, true);
							bmTemp.dbErase();
						}
					}
				}
			}
			if (dBlockingGap>0)
			{
				Cut cuts[] = bm.getToolsStaticOfTypeCut();
				bm.removeToolsStaticOfType(Cut());
				for (int n; n<cuts.length(); n++)
				{
					Cut ct = cuts[n];
					ct.transformBy(-dBlockingGap * ct.normal());
					bm.addToolStatic(ct);
				}
			}
		}

		_Map.setMap("mpBms",mpBm);
	}
#End
#BeginThumbnail
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
6[5`HHI78U3@G=(?11106%%%%`'__V69I
`




















#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="0.00155" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End