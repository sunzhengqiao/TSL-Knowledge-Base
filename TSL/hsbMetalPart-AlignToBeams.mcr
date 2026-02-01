#Version 8
#BeginDescription

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
// basics and props
	U(1,"mm");
	double dEps = U(0.1);


// on insert
	if (_bOnInsert) 
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }


	// selection of beams to be processed
		Entity entsGb[0];	
		PrEntity ssBm(T("|Select Beam(s)|"), Beam());
  		if (ssBm.go())
	    	_Beam= ssBm.beamSet();

		_Entity.append(getMassGroup());
		

	}
	
// validate the entity
	MassGroup mgParent;
	if (_Entity.length()>0 && _Entity[0].bIsKindOf(MassGroup()))
	{ 
			mgParent= (MassGroup)_Entity[0]; // would be valid if added to a massGroup in the drawing
	}

	if (!mgParent.bIsValid() || _Beam.length()<1) {
		eraseInstance();
		return;
	}
	Beam bmAr[0];
	bmAr = _Beam;
	//setDependencyOnEntity(_Entity[0]);
	//setExecutionLoops(2);
	
// set origin on insert
	if (_bOnDbCreated || _bOnRecalc || _kNameLastChangedProp=="_Pt0")
		_Pt0 = mgParent.realBody().ptCen();	
		

// collect childs with ecs markers
	// collect the child entities and its markers
	Entity entArChild[] = mgParent.entity();
	MassGroup mgArChild[0];
	EcsMarker ecsAr[0];
	for (int e=0; e<entArChild.length();e++)
		if(entArChild[e].bIsKindOf(MassGroup()))
		{
			MassGroup mgChild =(MassGroup)entArChild[e];
			Entity entArGrandChild[] = mgChild.entity();
			for (int f=0; f<entArGrandChild.length();f++)
				if (entArGrandChild[f].bIsKindOf(EcsMarker()))
				{
					mgArChild.append(mgChild);
					ecsAr.append((EcsMarker)entArGrandChild[f]);
					break;
				}
		}
		
		
// declare arrays where the biggest overlapping and the referenced beam index is stored
// these arrays must have the same length as the childs
	int nArBeamIndex[0];	
	int nArChildIndex[0];	
	double dArMax[0];	
		
// find biggest overlapping		
	for (int e=0; e<mgArChild.length();e++)
	{	
	// initialize arrays	
		nArBeamIndex.append(-1);	
		dArMax.append(0);
		
		double dArea;
		Vector3d vx, vy,vz;
		Point3d ptOrg = ecsAr[e].coordSys().ptOrg();
		vx = ecsAr[e].coordSys().vecX();
		vy = ecsAr[e].coordSys().vecY();
		vz = ecsAr[e].coordSys().vecZ();
		Plane pn(ptOrg,vz);
		
	// shadow of the child, with the allowance that the origin maybe at the edge
		PlaneProfile ppChild = mgArChild[e].realBody().shadowProfile(pn);
		ppChild.shrink(-dEps);
		
		ppChild.vis(e);
		for (int b=0; b<bmAr.length();b++)
		{
		// shadow of the beam
			PlaneProfile ppBm = bmAr[b].envelopeBody().shadowProfile(pn);	
			PlaneProfile ppTest = ppChild;
			ppTest.intersectWith(ppBm);
			double dTestArea = ppTest.area();
			if (dArea<dTestArea)
			{
				dArea = dTestArea;
				nArBeamIndex[e] = b;
				dArMax[e] =dArea; 
			}
		}	
	}
	
// assign biggest overlapping
	int bErase;
	for (int e=0; e<mgArChild.length();e++)
	{
		
	// check if the beam index given to this child conatins the biggest overlapping
		int bOk=true;
		double dAreaThis = dArMax[e];	
		int nThisIndex = nArBeamIndex[e];

		for (int f=0; f<nArBeamIndex.length();f++)
		{
			if (f==e)continue;
				
			if (nThisIndex==nArBeamIndex[f] && dAreaThis <dArMax[f])
			{
				bOk=false;
				break;	
			}	
		}	
	
	// if ok align the child to the beam coordsys	
		//reportNotice("\nalign ok: " + bOk);
		if (bOk)
		{
			Beam bm=bmAr[nThisIndex];
			MassGroup mgChild = mgArChild[e];
			bm.envelopeBody().vis(e);
			Vector3d vxFrom, vyFrom,vzFrom;
			Point3d ptOrg = ecsAr[e].coordSys().ptOrg();
			vxFrom = ecsAr[e].coordSys().vecX();
			vyFrom = ecsAr[e].coordSys().vecY();
			vzFrom = ecsAr[e].coordSys().vecZ();
			
			Quader qdr = bm.quader();
			Vector3d vxTo,vyTo,vzTo;
			vxTo = bm.vecX();
			if (vxTo.dotProduct(vxFrom)<0)vxTo*=-1;
			vzTo = qdr.vecD(vzFrom);
			vyTo = vxTo.crossProduct(-vzTo);
			
			//reportNotice("\ncsTO: " + vxTo + "   " + vyTo + "   " + vzTo);
			
			vxTo.vis(ptOrg,e);
			vyTo.vis(ptOrg,3);
			vzTo.vis(ptOrg,150);
						
			CoordSys cs;
			cs.setToAlignCoordSys(ptOrg,vxFrom,vyFrom,vzFrom,ptOrg,vxTo,vyTo,vzTo);
			
			mgChild.transformBy(cs);
			
			//bErase=true;
		
		}
		
	}// next e child

	
	//if (_kExecutionLoopCount>0)	
		//eraseInstance();

#End
#BeginThumbnail

#End
