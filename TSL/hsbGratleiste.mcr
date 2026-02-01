#Version 8
#BeginDescription
version value="1.2" date="15may15" author="th@hsbCAD.de"
catalog based insertion enabled

/// This tsl creates a horizontal dove tool connection between touching sub beams
/// The beams must be assigned to an element.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl creates a horizontal dove tool connection between touching sub beams
/// THe beams must be assigned to an element.
/// </summary>

/// <insert Lang=de>
/// Select a set of beams and input the desired options
/// </insert>

/// History
///<version value="1.2" date="15may15" author="th@hsbCAD.de"> catalog based insertion enabled </version>
/// Version 1.1   th@hsbCAD.de   08.07.2010
/// bugfix
/// Version 1.0   th@hsbCAD.de   19.07.2010
/// initial


// basics and props
	U(1,"mm");
	double dEps = U(.1);

	double dDoveA = 0;
	PropDouble dDoveD(0, U(14),T("|Dovetail Depth|"));
	PropDouble dDoveW(1, U(8.7),T("|Dovetail Width|"));
	PropInt nColor(0, 167,T("|Color|"));

	
// on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }

	// if the insertion is don with a fixed execute key don't show a dialog
		if (_kExecuteKey!="")
			setPropValuesFromCatalog(_kExecuteKey);
		else
			showDialog();


		PrEntity ssE(T("|Select Beams|"), Beam());
		if (ssE.go())
			_Beam = ssE.beamSet(); 		

		_Pt0 = getPoint(T("|Select Insertion Point|"));
		return;
	}	
//end on insert________________________________________________________________________________

// validate element
	Element el;
	for (int b = 0; b< _Beam.length(); b++)
	{
		Element elBm = _Beam[b].element();
		if (elBm.bIsValid())
		{
			el = elBm;
			break;	
		}	
		
	}
	
// standards
	if (_Beam.length()<1 || !el.bIsValid())
	{
		eraseInstance();
		return;				
	}	
	Vector3d vx,vy,vz;
	vx = el.vecX();
	vy = el.vecY();
	vz = el.vecZ();
	
	Beam bm[0];
	bm = _Beam;
	
// find start and end
	bm = vx.filterBeamsPerpendicularSort(bm);	
	int n;
	Point3d ptStart = bm[n].ptCenSolid()-vx*.5*bm[n].dD(vx);
	n=bm.length()-1;
	Point3d ptEnd = bm[n].ptCenSolid()+vx*.5*bm[n].dD(vx);
	ptStart.vis(0); ptEnd.vis(1);
	double dYHeight = vx.dotProduct(ptEnd-ptStart);
	
// reposition _Pt0 to the surface of the first layer of beams
	bm = (-vz).filterBeamsPerpendicularSort(bm);
	if (bm.length()<1)
	{
		eraseInstance();
		return;				
	}	
	_Pt0 = _Pt0 -vz*(vz.dotProduct(_Pt0 - bm[0].ptCenSolid())+.5*bm[0].dD(vz)) - vx*vx.dotProduct(_Pt0-ptStart);
	
// toolings	
	Dove dv0 (_Pt0, vy, -vx, vz, dDoveW, dYHeight*2, dDoveD, dDoveA, _kFemaleSide);		
	Dove dv1 (_Pt0, vy, -vx, -vz, dDoveW, dYHeight*2, dDoveD, dDoveA, _kFemaleSide);	
	for (int b = 0; b< bm.length(); b++)
	{
		if (vz.dotProduct(_Pt0-bm[b].ptCenSolid())>dEps)
			bm[b].addTool(dv1);	
		else
			bm[b].addTool(dv0);				
	}
	

// tool display	
	// a male dove body cannot be created straight away as a _kMaleSide is not avalailable and limited to YHeight of 750
	double dL = dYHeight;
	int x;
	if (dL>U(750))
	{
		x = dYHeight/U(750);	
		dL = U(750);
	}
	Body bd(_Pt0, vx,vy,vz,dL,dDoveW*2, dDoveD*2,1,0,0);
	Dove dvBd0 (_Pt0, vy, -vx, vz, dDoveW, dYHeight, dDoveD, dDoveA, _kMaleEnd);		
	Dove dvBd1 (_Pt0, vy, -vx, -vz, dDoveW, dYHeight, dDoveD, dDoveA, _kMaleEnd);
		bd.addTool(dvBd0);	
		bd.addTool(dvBd1);

	Body bdCopy = bd;
	for (int i=0;i<x;i++)
	{
		bdCopy.transformBy(vx*dL);
		bd.addPart(bdCopy);
	}
	if (x>0)
		bd.addTool(Cut(ptEnd,vx),0);
		
// collect openings
	Opening op[] = el.opening();
	for (int o=0;o<op.length();o++)
	{
		bd.subPart(Body(op[o].plShape(),vz*U(1000),0));
	}	

// Display
	Display dp(nColor);	
	dp.draw(bd);
	
// assignment
	assignToElementGroup(el,true,0,'T');	
			
	
	
	
	
		

#End
#BeginThumbnail
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
A#.H2??$<0_VFS_+-;VC:.=+\PM,)&D`!`7`&*UJ*`/_9
`

#End