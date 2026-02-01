#Version 8
#BeginDescription
version  value="1.0" date="04jul12" author="th@hsbCAD.de">
initial

This tsl creates a sphere at the end of a beam

Select beam(s) and an insertion point

There must be one revolution shape defined in the company folder. Ensure that the base point of the 
profile definition is located at the origin of world ucs at 0,0,0.
#End
#Type E
#NumBeamsReq 1
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
/// <summary>
/// This tsl creates a sphere at the end of a beam
/// </summary>

/// <insert>
/// Select beam(s) and an insertion point
/// </insert>


/// <remark>
/// There must be one revolution shape defined in the company folder. Ensure that the base point of the 
/// profile definition is located at the origin of world ucs at 0,0,0.
/// </remark>

///<version  value="1.0" date="04jul12" author="th@hsbCAD.de"> initial</version>


// basics and props
	U(1,"mm");
	double dEps = U(0.1);
	String sArNY[] = { T("|No|"), T("|Yes|")};

	String sArProfile[] = {T("|Shape|")+ " 1",T("|Shape|")+ " 2"};
	PropString sProfile(0,sArProfile,T("|Revolution Mill|"));
	sProfile.setDescription(T("|Specifies the tooling index, see hsbSetting->Hundegger 2|"));	
	int nIndex = sArProfile.find(sProfile);

	int nColor(3);
	//PropInt nColor(0,3,T("|Color|"));	

// declare arrays for tsl cloning
	TslInst tslNew;
	Vector3d vUcsX = _X0;
	Vector3d vUcsY = _Y0;
	GenBeam gbAr[1];
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
		showDialog();

		PrEntity ssBm(T("|Select Beam(s)|"), Beam());
		Beam beams[0]; 
		if (ssBm.go())
    		beams= ssBm.beamSet();
		ptAr[0] = getPoint();
		
		for (int i=0;i<beams.length();i++)
		{
			gbAr[0]=beams[i];
			tslNew.dbCreate(scriptName(), vUcsX,vUcsY,gbAr, entAr, ptAr, 
				nArProps, dArProps, sArProps,_kModelSpace, mapTsl); // create new instance	
			if (tslNew.bIsValid())
			{
				tslNew.setPropValuesFromCatalog(T("|_LastInserted|"));
			}	
		}
		eraseInstance();
		return;

	}

	
// define a special mill (revolution mill)
	RevolutionMill sm(_Pt0,_Y0,_Z0,_X0);
	sm.setToolIndex(nIndex);
	_Beam0.addTool(sm);
	
// stretch me
	_Beam[0].addTool(Cut(_Pt0,_X0),1);	


// Display
	Display dp(nColor);
		
// catch the 2d shape
	PlaneProfile pp = _Beam[0].realBody().shadowProfile(Plane(_Beam[0].ptCen(), _Y0+_Z0));
	PlaneProfile ppSub = _Beam[0].envelopeBody().shadowProfile(Plane(_Beam[0].ptCen(), _Y0+_Z0));
	ppSub.transformBy(_X0*U(1));
	ppSub.subtractProfile(pp);

// show a approx
	ppSub.transformBy(-_X0*dEps);
	pp.transformBy(_X0*dEps);
	pp.intersectWith(ppSub);
	dp.draw(pp);
	
// get the outer pline
	PLine pl[]= ppSub.allRings();
	PLine plOut;
	int bIsOp[] = ppSub.ringIsOpening();
	for (int r=0;r<pl.length();r++)
	{
		if (!bIsOp[r] && pl[r].area() > plOut.area())
			plOut=pl[r];
	}

// Beam and layer assignment
	assignToGroups(_Beam[0]);	


#End
#BeginThumbnail
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
61J%'Z5%:M4C9-_=_7^1=.G!ZK\3_V:UO
`

#End
