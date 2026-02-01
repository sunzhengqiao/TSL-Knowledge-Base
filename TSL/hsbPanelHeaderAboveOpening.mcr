#Version 8
#BeginDescription
/// Version 1.0   th@hsbCAD.de   20.08.2009
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
/// This tsl creates a header above an opening and beamcuts any intersecting sip of the same element
/// </summary>

/// <insert Lang=en>
/// Select an opening
/// </insert>

// basics and props
	U(1,"mm");
	double dEps = U(0.01);
	PropDouble dHeight(0, U(100), T("|Height|"));
	PropDouble dWidth(1, U(100), T("|Width|"));	
	PropDouble dXL(2, U(100), T("|Extension|") + " " + T("|Left|"));
	PropDouble dXR(3, U(100), T("|Extension|") + " " + T("|Right|"));
	PropDouble dOffsetZ(4, U(0), T("|Offset|") + " " + "Z");		
			
// on insert
	if (_bOnInsert)
	{	
		if (insertCycleCount()>1) { eraseInstance(); return; }
		showDialog();			
		_Opening.append(getOpening("|Select opening|"));
		
		return;
	}

		
// get the element from the opening
	if (_Opening.length()<1)
	{
		eraseInstance();
		return;	
	}
	
	Element el = _Opening[0].element();
	if (!el.bIsValid())
	{
		eraseInstance();
		return;	
	}
	CoordSys cs = el.coordSys();
	Point3d ptOrg= cs.ptOrg();
	Vector3d vx,vy,vz;
	vx = cs.vecX();
	vy = cs.vecY();
	vz = cs.vecZ();	
	
// get center location of opening
	Point3d ptOp[] = _Opening[0].plShape().vertexPoints(true);
	ptOp = Line(ptOrg,vx).orderPoints(ptOp);
	Point3d ptMid = (ptOp[0]+ptOp[ptOp.length()-1])/2;
	ptMid = ptMid-vy*vy.dotProduct(ptMid-ptOrg)-vz*vz.dotProduct(ptMid-ptOrg);
	_Pt0 = ptMid;	
	ptMid = _Pt0 + vy * _Opening[0].headHeight();
	ptMid.vis(3);


		
// create the beam if not existant
	Point3d ptRef = ptMid+vz * dOffsetZ+vx*.5*(dXR-dXL);
	Beam bm;
	if (_Beam.length()<1 || !_Beam[0].bIsValid())
	{
		bm.dbCreate(ptRef,vx,vy,vz,_Opening[0].width() +dXL +dXR,dHeight,dWidth,0,1,-1);
		bm.assignToElementGroup(el,true,0,'Z');
		_Beam.append(bm);
		
	}
	else
		bm = _Beam[0];


	setDependencyOnBeamLength(_Beam[0]);
		
// collect sips	
	Sip sips[] = el.sip();
	BeamCut bc(bm.ptCenSolid(),vx,vy,vz,bm.solidLength(),bm.dW(),bm.dH(),0,0,0);	
	bc.addMeToGenBeamsIntersect(sips);
	
// display
	Display dp(3);
	dp.draw(PLine(bm.ptCenSolid()-.5*bm.vecX()*bm.solidLength(),bm.ptCenSolid()+.5*bm.vecX()*bm.solidLength()));	
#End
#BeginThumbnail
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
.HS!:88$'"-_\5291_]E,
`

#End
