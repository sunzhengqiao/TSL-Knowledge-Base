#Version 8
#BeginDescription
/// This tsl sets a relation between a beam and a set of entities. when the beam is rotated all entities will be rotated
/// in the same relation withe the selected point as center point.
/// When the tsl is inserted with an executekey 'copyerase' or an integer map entry 'copyerase=1' translations are also
/// supported. Beware that this prevents a correct behaviour when copying the beam

version  value="1.0" date="20oct11" author="th@hsbCAD.de"> initial

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
/// This tsl sets a relation between a beam and a set of entities. when the beam is rotated all entities will be rotated
/// in the same relation withe the selected point as center point.
/// When the tsl is inserted with an executekey 'copyerase' or an integer map entry 'copyerase=1' translations are also
/// supported. Beware that this prevents a correct behaviour when copying the beam
/// </summary>

/// <insert Lang=en>
/// Select a beam and all entities which should keep their alignment to the beam. Select center point of the rotation.
/// </insert>

/// History
///<version  value="1.0" date="20oct11" author="th@hsbCAD.de"> initial </version>


// standards
	U(1,"mm");
	double dEps = U(.1);
	
// on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		
		
	// get execute key
		String sKey = _kExecuteKey.makeUpper();
		// set the script to use the copyAndErase method to allow translation of the beam, beware that this prevents a correct behaviour when copying the beam
		if (sKey=="COPYERASE")
		{
			_Map.setInt("copyerase",true);
		}
	
		
		_Beam.append(getBeam());
		
	// selection of entities	
		Entity ents[0];
		PrEntity ssE(T("|Select Entities|"), Entity());
  		if (ssE.go())
	    	ents = ssE.set();
		for (int e=0;e<ents.length();e++)
			if (_Beam[0]!=ents[e])
				_Entity.append(ents[e]);

	// the ref point
		_Pt0 = getPoint();

	// store the beam coordsys
		Vector3d vx,vy,vz;
		vx = _Beam[0].vecX();
		vy = _Beam[0].vecY();
		vz = _Beam[0].vecZ();
		
	// set dependency coordsys per ME
		Map mapAlignDependencies;
		for (int e=0;e<_Entity.length();e++)	
		{
			Map mapDependency;
			mapDependency.appendEntity("ent", _Entity[e]); 		
			mapDependency.setPoint3d("ptX",_Pt0+vx*U(1),_kAbsolute);	
			mapDependency.setPoint3d("ptY",_Pt0+vy*U(1),_kAbsolute);
			mapDependency.setPoint3d("ptZ",_Pt0+vz*U(1),_kAbsolute);	
			mapAlignDependencies.appendMap("Dependency",mapDependency);		
		}// next e
		_Map.setPoint3d("ptOrg",_Pt0,_kAbsolute);	
		_Map.setMap("AlignmentDependency[]",mapAlignDependencies);	
		return;		
	}
// end on insert	

// validate entities
	if (_Beam.length()<1 || _Entity.length()<1)
	{
		reportNotice("\n" + scriptName() + ": " + T("|invalid selection set.|") + "\n" + T("|Tool will be deleted|"));
		eraseInstance();
		return;	
	}	

// the beam and its coordsys
	Beam bm = _Beam[0];
	Vector3d vx,vy,vz;
	vx = _Beam[0].vecX();
	vy = _Beam[0].vecY();
	vz = _Beam[0].vecZ();

	vx.vis(_Pt0,1);
	vy.vis(_Pt0,3);
	vz.vis(_Pt0,150);	

	//bm.realBody().vis(2);
	
// Display
	Display dp(42);
	dp.textHeight(U(20));
	//dp.draw(scriptName(),_Pt0,_XW,_YW,1,0,_kDevice);	
	
// assignment and behaviour
	// set the script to use the copyAndErase method (like an E-Type tool) to allow translation of the beam
	// !! beware that this prevents a correct behaviour when copying the beam
	if (_Map.getInt("copyerase"))
	{
		setEraseAndCopyWithBeams(_kBeam0);
		dp.color(230);	
	}
	assignToGroups(bm);	
	
// get stored data		
	Map mapAlignDependencies = _Map.getMap("AlignmentDependency[]");	
	Point3d ptOrg = _Map.getPoint3d("ptOrg");




// trigger
	String sTrigger[] = {T("|Add|") + " " +T("|Dependency|"),T("|Remove|") + " " +T("|Dependency|")};
	for (int i = 0; i < sTrigger.length(); i++)
		addRecalcTrigger(_kContext, sTrigger[i]);

// trigger 0: Add Dependency
	if (_bOnRecalc && _kExecuteKey==sTrigger[0])
	{	
		PrEntity ssEnts(T("|Select Entities|"), Entity());
		Entity ents[0];
		if (ssEnts.go())
			ents = ssEnts.set();

		for (int i=0;i<ents.length();i++)
			if (_Entity.find(ents[i])<0 && ents[i]!= bm)
			{
				_Entity.append(ents[i]);
				
				Map mapDependency;
				mapDependency.appendEntity("ent", _Entity[i]); 	
				mapDependency.setPoint3d("ptOrg",_Pt0,_kAbsolute);			
				mapDependency.setPoint3d("ptX",_Pt0+vx*U(1),_kAbsolute);	
				mapDependency.setPoint3d("ptY",_Pt0+vy*U(1),_kAbsolute);
				mapDependency.setPoint3d("ptZ",_Pt0+vz*U(1),_kAbsolute);	
				mapAlignDependencies.appendMap("Dependency",mapDependency);			
			}
		setExecutionLoops(2);
		_Map.setMap("AlignmentDependency[]",mapAlignDependencies);			
	}
// END trigger 0: Add Dependency


// trigger 1: remove Dependency
	if (_bOnRecalc && _kExecuteKey==sTrigger[1])
	{	
		PrEntity ssEnts(T("|Select Entities|"), Entity());
		Entity ents[0];
		if (ssEnts.go())
			ents = ssEnts.set();

		for (int i=0;i<ents.length();i++)
		{
			int n = _Entity.find(ents[i]);
			if (n>-1)
			{
				_Entity.removeAt(n);
				for (int m=0;m<mapAlignDependencies.length();m++)
				{
					Map mapDependency=mapAlignDependencies.getMap(m);
					Entity ent = mapDependency.getEntity("ent"); 	
					if (ent == ents[i])
					{
						mapAlignDependencies.removeAt(m,true);
						break;
					}
				}// next m dependency
			}// end if found
		}// next i entity
		setExecutionLoops(2);	
		_Map.setMap("AlignmentDependency[]",mapAlignDependencies);		
	}
// END trigger 1: remove Dependency

	
// rewrite dependency map if _Pt0 has been moved
	if ("_Pt0" == _kNameLastChangedProp)
	{
		reportMessage("\nrewriting _Pt0");
		mapAlignDependencies = Map();
		for (int i=0;i<_Entity.length();i++)
		{
			Map mapDependency;
			mapDependency.appendEntity("ent", _Entity[i]); 			
			mapDependency.setPoint3d("ptX",_Pt0+vx*U(1),_kAbsolute);	
			mapDependency.setPoint3d("ptY",_Pt0+vy*U(1),_kAbsolute);
			mapDependency.setPoint3d("ptZ",_Pt0+vz*U(1),_kAbsolute);	
			mapAlignDependencies.appendMap("Dependency",mapDependency);			
		}	
		_Map.setMap("AlignmentDependency[]",mapAlignDependencies);	
		_Map.setPoint3d("ptOrg",_Pt0,_kAbsolute);	
	}

	else
	{
	// caches the dependencies
		Map mapTmp; 
	
	
	// control location alignment dependencies
		for (int m=0;m<mapAlignDependencies.length();m++)	
		{
			Map mapDependency= mapAlignDependencies.getMap(m);	
			Vector3d vxEnt, vyEnt, vzEnt, vRefOrg;
			vRefOrg = ptOrg-_Pt0;//mapDependency.getPoint3d("ptOrg");
			Point3d ptOrgTo= _Pt0+vRefOrg;
			vRefOrg.vis(ptOrgTo,2);
			//break;
		// get stored points and vecs. since the map gets transformed by the t- or e-type behaviour we need to
		// recompose the vecs from absolute points
			vxEnt = mapDependency.getPoint3d("ptX")-ptOrg;		vxEnt.normalize();
			vyEnt = mapDependency.getPoint3d("ptY")-ptOrg;		vyEnt.normalize();
			vzEnt = mapDependency.getPoint3d("ptZ")-ptOrg;		vzEnt.normalize();
			vxEnt.vis(_Pt0+vxEnt*U(100),1);
			vyEnt.vis(_Pt0+vxEnt*U(100),3);
			vzEnt.vis(_Pt0+vxEnt*U(100),150);
									
		// transform if one of the vecs or the origin has changed
			if (Vector3d(ptOrg-_Pt0).length()>dEps ||
				!vxEnt.isCodirectionalTo(vx) ||
				!vyEnt.isCodirectionalTo(vy) ||
				!vzEnt.isCodirectionalTo(vz))
			{
				CoordSys cs;
				cs.setToAlignCoordSys(ptOrg, vxEnt,vyEnt,vzEnt,_Pt0, vx,vy,vz);
				for (int e=0;e<mapDependency.length();e++)
				{				
					Entity ent = mapDependency.getEntity(e);
					ent.transformBy(cs);
				}		
				mapDependency.setPoint3d("ptX",_Pt0+vx*U(1),_kAbsolute);	
				mapDependency.setPoint3d("ptY",_Pt0+vy*U(1),_kAbsolute);
				mapDependency.setPoint3d("ptZ",_Pt0+vz*U(1),_kAbsolute);
			// add to cache
				mapTmp.appendMap("Dependency",mapDependency);				
			}				
		}
	
	// rewrite from cache
		if (mapTmp.length()>0)
		{
			reportMessage("\nrewriting cached dependencies");
			mapAlignDependencies = mapTmp;
			_Map.setMap("AlignmentDependency[]",mapAlignDependencies);
			_Map.setPoint3d("ptOrg",_Pt0,_kAbsolute);	
		}
	}


// symbol display
	PLine plCirc();
	double dDiameter = U(40);
	plCirc.createCircle(_Pt0,_ZE,dDiameter/2);
	dp.draw(plCirc);
	
	// guideline
	PLine plAxis(bm.ptCenSolid()-vx*.5*bm.solidLength(),bm.ptCenSolid()+vx*.5*bm.solidLength());
	Point3d ptGuide[0];
	ptGuide.append((bm.ptCenSolid()+plAxis.closestPointTo(_Pt0))/2);
	ptGuide.append(plAxis.closestPointTo(_Pt0));
	ptGuide.append((ptGuide[0]+_L0.closestPointTo(_Pt0))/2);
	//ptGuide.append(_L0.closestPointTo(_Pt0));
	ptGuide.append(_Pt0);
	dp.draw(PLine (ptGuide[0],ptGuide[1],ptGuide[2],ptGuide[3]));
	dp.color(1);
	
	dp.draw(PLine (_Pt0,_Pt0+vx*.6*dDiameter));
	dp.color(3);
	dp.draw(PLine (_Pt0,_Pt0+vy*.6*dDiameter));	
	dp.color(150);
	dp.draw(PLine (_Pt0,_Pt0+vz*.6*dDiameter));

#End
#BeginThumbnail
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
K\SIPG\9?UT/,J***\(]D****`"NOT_\`Y!MK_P!<4_D***VH[LSJ;'__V9?+
`

#End
