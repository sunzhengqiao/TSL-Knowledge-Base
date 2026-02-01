#Version 8
#BeginDescription

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This Tsl creates a lap joint for wall based panels.
/// </summary>

/// <insert=en>
/// The tsl can be inserted as a tsl split loaction or as an individual split location
/// - tsl split location
///      * make sure you have a valid catalog entry with the properties set
///      * use the catalog name as execute key to execute with the correspondent properties
///      * in order not to exceed potential limited dimensions use a negative gap which corresponds to the width being set
/// - individual split
///      * enter the desired properties
///      * potential limited dimensions might be exceeded and have to be validated by the user
/// in both cases the tsl will be inserted as a wall based split location if no panels can be found. If panels
/// are found it clones itself into a sip dependent tool
/// </insert>

/// <remark=en>
/// The location of the split can be moved at any time.
/// </insert>

/// <command name="Join + Erase" Lang=en>
/// This command will join the connected panels and erase the tool
/// </command>

/// History
/// Version 1.0   th@hsbCAD.de   19.05.2010
/// initial

//basics and props
	Unit(1,"mm"); // script uses mm
	double dEps=U(.1);
	PropDouble dWidth(0, U(50), T("|Width|"));
	PropDouble dDepth(1, U(30), T("|Depth|"));
	PropDouble dGapWidth1(2, U(0), T("|Gap|") + " " +T("|reference side|"));
	PropDouble dGapDepth(3, U(0), T("|Gap|") + " " + T("|Depth|"));
	PropDouble dGapWidth2(4, U(5), T("|Gap|") + " " +T("|opposite side|"));		

	String sArSide[] = {T("|reference side|"), T("|opposite side|")};
	PropString sSide(0, sArSide, T("|Side|"));

// declare the tsl props
	TslInst tslNew;
	Vector3d vUcsX = _XW;
	Vector3d vUcsY = _YW;
	GenBeam gbAr[0];
	Entity entAr[0];
	Point3d ptAr[0];
	int nArProps[0];
	double dArProps[0];
	String sArProps[0];
	Map mapTsl;
	String sScriptname = scriptName();	
		
// on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		// show the dialog if no catalog in use
		if (_kExecuteKey == "" )
		{
			showDialog();		
		}
		// set properties from catalog		
		else	
			setPropValuesFromCatalog(_kExecuteKey);	
		_Pt0 = getPoint();
		_Element.append(getElement());	
		return;		
	}

// validate
	if (_Element.length()<1)
	{
		eraseInstance();
		return;	
	}


// modes
	// 0 = element split mode
	// 1 = sip tool mode
	int nMode = _Map.getInt("mode");

// declare standards		
	Element el = _Element[0];
	Vector3d vx,vy,vz, vzT;	
	vx = el.vecX();
	vy = el.vecY();
	vz = el.vecZ();
	vzT = el.vecZ();

// ints
	int nSide = sArSide.find(sSide);	
	double dGaps[] = {dGapWidth1,dGapWidth2};
	if(nSide==1)
	{
		vzT*=-1;
		dGaps.swap(0,1);	
	}

// outline
	Point3d ptOL[] = el.plOutlineWall().vertexPoints(true);
	ptOL = Line(_Pt0,vz).orderPoints(ptOL);
	double dElementWidth = 	abs(vz.dotProduct(ptOL[0]-ptOL[ptOL.length()-1]));
	_Pt0 = _Pt0-vy*vy.dotProduct(el.ptOrg()-_Pt0)- vz * (vz.dotProduct(_Pt0-el.ptOrg())+.5 * dElementWidth);
	
	vx.vis(_Pt0, 1);
	vy.vis(_Pt0, 3);
	vz.vis(_Pt0, 150);	
	vzT.vis(_Pt0, 20);

// Display
	Display dp(3);
	PLine plRef(vy),plRef2(vy);
	
	Point3d ptSymbol[0];
	ptSymbol.append(_Pt0-vx*(.5*dWidth)-vzT*.5*dElementWidth);
	ptSymbol.append(ptSymbol[0]+vzT*dDepth);
	ptSymbol.append(ptSymbol[0]+vx*dWidth+vzT*dDepth);
	ptSymbol.append(ptSymbol[0]+vx*dWidth+vzT*dElementWidth);

	for (int i=0;i<ptSymbol.length();i++)
	{
		plRef.addVertex(ptSymbol[i]);
		//ptSymbol[i].vis(i);
	}
	dp.draw(plRef);

	Point3d ptSymbol2[0];
	ptSymbol2.append(ptSymbol[0]-vx*dGaps[0]);
	ptSymbol2.append(ptSymbol[1]-vx*dGaps[0]+vzT*dGapDepth);
	ptSymbol2.append(ptSymbol[2]-vx*dGaps[1]+vzT*dGapDepth);
	ptSymbol2.append(ptSymbol[3]-vx*dGaps[1]);

	for (int i=0;i<ptSymbol2.length();i++)
	{
		plRef2.addVertex(ptSymbol2[i]);		
		//ptSymbol2[i].vis(171);
	}
	dp.draw(plRef2);	




// element mode
if (nMode==0)
{
// on creation
	setExecutionLoops(2);

	if (_bOnDbCreated && _kExecuteKey!="")
	{
		setPropValuesFromCatalog(_kExecuteKey);
	}			


	Sip sip[] = el.sip();
	
// on element creation
	if (_bOnElementConstructed || _bOnDbCreated)
	{
		mapTsl.setInt("mode",1);// sip tool mode
		// splitting plane
		Plane pn(_Pt0,vx);
		
	// find sip at split location
		Body bdTest(_Pt0,vx,vy,vz,U(1),U(10000),U(1000),0,0,0);
		int bOk;
		ptAr.setLength(0);
		ptAr.append(_Pt0);
		for (int i=0;i<sip.length();i++)
		{
			if (bdTest.hasIntersection(sip[i].realBody()))
			{
				gbAr.setLength(0);
				entAr.setLength(0);
				entAr.append(el);
				Sip sipSplit[0];
				sipSplit = sip[i].dbSplit(pn,-dWidth);
				gbAr.append((GenBeam)sip[i]);
				for (int s=0;s<sipSplit.length();s++)	
				{
					gbAr.append((GenBeam)sipSplit[s]);
					entAr.append(sipSplit[s]);	
				}

				tslNew.dbCreate(sScriptname, vUcsX,vUcsY,gbAr, entAr, ptAr, 
					nArProps, dArProps, sArProps,_kModelSpace, mapTsl); // create new instance	
				if (tslNew.bIsValid())
				{
					setCatalogFromPropValues(T("|_LastInserted|")); 
					tslNew.setPropValuesFromCatalog(T("|_LastInserted|"));	
				}						
				bOk=true;		
			}
		}
		if(bOk) eraseInstance();
	}
	return;
}
// end element mode


// sip tool mode
else if(nMode==1)
{
	Entity ents[0];
	ents = _Entity;
	for (int e=0;e<ents.length();e++)	
		if (_Sip.find(ents[e])<0 && ents[e].bIsKindOf(Sip()))
			_Sip.append((Sip)ents[e]);

	Sip sip[0];
	sip = _Sip;
	
	if (sip.length()<2)
		return;
	

// add triggers
	String sTrigger[] = {T("|Join|") + " + " + T("|Erase|")};
	for (int i = 0; i < sTrigger.length(); i++)
		addRecalcTrigger(_kContext, sTrigger[i]);	

// event 0
	if ((_bOnRecalc && _kExecuteKey==sTrigger[0]))
	{
		sip[0].dbJoin(sip[1]);
		eraseInstance();
		return;
	}
	
// store the origin ( for potential _Pt0 based stretching)
	if (_bOnDbCreated)
		_Map.setVector3d("vRef",_Pt0-_PtW);	
		
	sip[0].ptCen().vis(0);
	sip[1].ptCen().vis(1);

// beamcut ref points
	Point3d ptRefBc[0];
	ptRefBc.append(ptSymbol2[1]);
	ptRefBc.append(ptSymbol[2]);
	
		
// validate vx
	Vector3d vxT = vx;
	if(vx.dotProduct(sip[1].ptCen()-sip[0].ptCen())<0)
	{
		vxT*=-1;
		ptRefBc.swap(0,1);
	}
	vxT.vis(sip[0].ptCen(),2);	
	
	Point3d ptX = _PtW+_Map.getVector3d("vRef");
	ptX.vis(2);
	
// stretch edges
	if (_kNameLastChangedProp=="_Pt0")
	{
		setExecutionLoops(2);
		Point3d ptMove = _PtW+_Map.getVector3d("vRef");
		Vector3d vxMove = _Pt0-ptMove;
		vxMove.normalize();

		ptMove = sip[0].plEnvelope().closestPointTo(ptMove+vy*.5*sip[0].dD(vy));
		sip[0].stretchEdgeTo(ptMove ,Plane(_Pt0+vxT*.5*dWidth,vxT));

		ptMove = sip[1].plEnvelope().closestPointTo(ptMove+vy*.5*sip[1].dD(vy));		
		sip[1].stretchEdgeTo(ptMove,Plane(_Pt0-vxT*.5*dWidth,-vxT));
		
		// subtract the rest
		PLine pl(vz);
		pl.createRectangle(LineSeg(_Pt0-vxMove*.5*dWidth,_Pt0-vxMove*U(10000)+vy*U(10000)),vxMove,vy);
		if (vxMove.isCodirectionalTo(vxT))
			sip[1].addOpening(pl,false);
		else			
			sip[0].addOpening(pl,false);		
		_Map.setVector3d("vRef",_Pt0-_PtW);	
	}	
		
// beamcut first
	BeamCut bc1(ptRefBc[0],vy,vxT,vzT, U(10000),U(1000),U(1000),0,1,1);
	//bc1.cuttingBody().vis(1);
	sip[0].addTool(bc1);
	
	
// beamcut second
	BeamCut bc2(ptRefBc[1],vy,-vxT,-vzT, U(10000),U(1000),U(1000),0,1,1);
	//bc2.cuttingBody().vis(2);	
	sip[1].addTool(bc2);
	sip[1].addTool(Cut(ptSymbol2[3],-vxT),0);

		
	_Pt0.vis(1);
	
}
// END sip tool mode		
#End
#BeginThumbnail
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
=BB@`HHHH`****`"BBB@`HHHH`****`"BBB@#_]F*
`

#End
