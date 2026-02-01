#Version 8
#BeginDescription
version value="1.3" date="21nov2018" author="thorsten.huck@hsbcad.com"
offset selection can be done at any segment of the system

bugfix radius 0
This tsl creates an offseted duct work system
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
//Part 1 //region
/// <History>//region
/// <version value="1.3" date="21nov2018" author="thorsten.huck@hsbcad.com"> offset selection can be done at any segment of the system </version>
/// <version value="1.2" date="08aug2018" author="thorsten.huck@hsbcad.com"> bugfix radius 0 </version>
/// <version value="1.1" date="19jul2018" author="thorsten.huck@hsbcad.com"> supports new HVAC-System </version>
/// <version value="1.0" date="18jul2018" author="thorsten.huck@hsbcad.com"> renamed </version>
/// <version value="1.0" date="18jul2018" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select a duct work instance, specify the offsetand and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates an offseted duct work system
/// </summary>//endregion

/// Command
/// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "mepDuct-Copy")) TSLCONTENT


// constants //region
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));
	// read a potential mapObject defined by hsbDebugController
	{ 
		MapObject mo("hsbTSLDev" ,"hsbTSLDebugController");
		if (mo.bIsValid()){Map m = mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug = true;	break;}}
		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());		
	}
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	//endregion

	String sSequenceKey = "DuctSequence";
	String sHVACScriptName = "HVAC";
	
// bOnInsert//region
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		
	// prompt for HVAC-System
		TslInst hvac;
		while (!hvac.bIsValid())
		{
		// prompt for tsls
			Entity ents[0];
			PrEntity ssE(T("|Select an HVAC system|"), TslInst());
		  	if (ssE.go())
				ents.append(ssE.set());
			
		// loop tsls
			for (int i=ents.length()-1; i>=0 ; i--) 
			{ 
				TslInst t=(TslInst)ents[i];
				if (t.bIsValid())
				{ 
					String sScriptName = t.scriptName();
					sScriptName.makeUpper();
					if (sScriptName==sHVACScriptName)
					{
						hvac = t;
						break;
					}
				}
			}			
		}
			
	// validate HVAC
		if (!hvac.bIsValid())
		{
			reportMessage("\n" + scriptName() + ": " +T("|no valid hvac found|"));
			eraseInstance();
			return;	
		}
		
	// get maps	
		Map map = hvac.map();
		Map mapCollection = map.getMap("HVAC Collection");
		Map mapTslRef = mapCollection.getMap("TSLRef[]");
		Map mapBeamRef = mapCollection.getMap("BeamRef[]");
	
	//region get stream plines		
	// get stream plines of duct beams 
		PLine plHvacs[0];	
		Beam bmRefs[0];	
		for (int i=0;i<mapBeamRef.length();i++) 
		{ 
			Entity ent= mapBeamRef.getEntity(i);
			Beam t = (Beam)ent;
			if (t.bIsValid())
			{ 
				PLine pl = t.subMapX("HVAC").getPLine("plHvac");
				if (pl.length() > dEps)
				{
					bmRefs.append(t);
					plHvacs.append(pl);
				}
			} 
		}//next i		
	//endregion End get stream plines	


	// the first beam is the reference beam
		Beam _beams[]=hvac.beam();
		if (_beams.length()<1)
		{ 
			reportMessage("\n" + scriptName() + ": " +T("|no defining beam found|"));
			eraseInstance();
			return;
		}
		Beam bmBase = _beams[0];
		Beam bmRef;


	// prompt for reference location
		Point3d ptRef = getPoint(T("|Pick reference location near the HVAC system|"));

	// find closest
		PLine plThis;
		double dMin = U(10e6);
		Point3d ptNext = bmBase.ptCen();
		int nIndex = - 1;
		for (int i=0;i<plHvacs.length();i++) 
		{ 
			PLine& pl = plHvacs[i]; 
			//if (pl.length() < dEps)continue;
			Point3d pt1 = ptRef;
			pt1+=_ZU * _ZU.dotProduct(pl.ptMid() - pt1);
			
			Point3d pt2 = pl.closestPointTo(pt1);pt1.vis(i);
			double d = Vector3d(pt1- pt2).length();
			if (d<dMin)
			{ 
				dMin = d;
				nIndex = i;
				ptNext = pt2;
				bmRef = bmRefs[i];
			}
		}//next i


	// get center as reference for the rubber band of side selection
		int bOk;
		_Entity.append(hvac);

	// prompt for point input
		PrPoint ssP(TN("|Select new location|"),ptNext); 
		if (ssP.go()==_kOk) 
		{
			_Pt0 = ssP.value();
			bOk = true;
		}

		if (!bOk)
		{ 
			reportMessage("\n" + scriptName() + ": " +T("|Invalid input|"));
			eraseInstance();
		}
		
	// transform to main beam and location
		CoordSys cs;
		cs.setToAlignCoordSys(bmRef.ptCenSolid(), bmRef.vecX(), bmRef.vecY(), bmRef.vecZ(), bmBase.ptCenSolid(), bmBase.vecX(), bmBase.vecY(), bmBase.vecZ());
		_Pt0.transformBy(cs);

		return;
	}	
// end on insert	__________________//endregion


// get HVAC from _Entity
	if (_Entity.length()<1)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|invalid reference|"));		
		eraseInstance();
		return;
	}
	
	TslInst hvac = (TslInst)_Entity[0];
	if (!hvac.bIsValid() || hvac.scriptName().makeUpper()!=sHVACScriptName)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|invalid tsl reference|"));		
		eraseInstance();
		return;
	}
	
// the first beam is the reference beam
	Beam _beams[]=hvac.beam();
	if (_beams.length()<1)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|no defining beam found|"));
		eraseInstance();
		return;
	}
	Beam bm = _beams[0];

// get base coordSys and grip offset	
	Vector3d vecMove, vecGrip;
	CoordSys csBase=bm.coordSys();
	vecMove = _Pt0 - bm.ptCen();
	vecMove = bm.vecD(vecMove) * bm.vecD(vecMove).dotProduct(vecMove);
		
	vecGrip = hvac.ptOrg() - bm.ptCen();
	vecGrip = bm.vecD(vecGrip) * bm.vecD(vecGrip).dotProduct(vecGrip);	
	
	
	
// End part1 //endregion
	
// get _Beam of the HVAC System
	Map mapRef = hvac.map().getMap("HVAC Collection");
	Entity entRefs[] = mapRef.getEntityArray("BeamRef[]", "", "BeamRef");
	Point3d ptDirs[] = mapRef.getPoint3dArray("PtDir[]");
		
	Beam beams[0];
	int nSequences[0];
	int nSequenceTail, nSequenceHead;
	for (int i = 0; i < entRefs.length(); i++)
	{
		Beam b = (Beam)entRefs[i];
		
		int x = ptDirs[i].X();
		int y = ptDirs[i].Y();
		
		int nSequence; // the first beam has sequence index 0
		if (y < 0)
		{
			nSequenceTail -= 1;
			nSequence = nSequenceTail;
		}
		else if (y >0)
		{
			nSequenceHead += 1;
			nSequence = nSequenceHead;	
		}

		beams.append(b);
		nSequences.append(nSequence);
	}


	
	
// order by sequence index
	for (int i=0;i<nSequences.length();i++) 
		for (int j=0;j<nSequences.length()-1;j++) 
			if (nSequences[j]>nSequences[j+1])
			{
				beams.swap(j, j + 1);
				nSequences.swap(j, j + 1);
			}
//			
//	for (int i=0;i<nSeqs.length();i++)		
//	{ 
//		Vector3d vecX = bmSeqs[i].vecX();
//		int nIndex = nSeqs[i];
//		int nFlow = nFlows[i];
//		
//		Point3d pt = bmSeqs[i].ptCenSolid();
//		vecX *= nFlow;
//		vecX.vis(pt, nIndex);
//	}		
//			
//	beams = bmSeqs;

	
	
// copy all beams and create connection
	Beam beamsNew[0];
	TslInst tslConnectors[0];
	Vector3d vecXP;
	Beam bmP;// the previous new beam
	Point3d ptCenP;
	for (int i=0;i<beams.length();i++) 
	{ 
		Vector3d vec = vecMove;
		Beam bm=beams[i];
		Vector3d vecX = bm.vecX();
		Vector3d vecY = bm.vecY();
		Vector3d vecZ = bm.vecZ();
		Point3d ptCen = bm.ptCenSolid();
		
		CoordSys cs;
		cs.setToAlignCoordSys(csBase.ptOrg(), csBase.vecX(), csBase.vecY(), csBase.vecZ(),ptCen, vecX, vecY, vecZ);
		vec.transformBy(cs);
		
	// get flag if this is G-connected to previous
		int bIsGConnected=i>0 && !vecX.isParallelTo(beams[i-1].vecX());
		Point3d pt= ptCen + vecGrip;

		
		if (bDebug)
		{ 
			Body bd = bm.envelopeBody();
			bd.vis(252);
			bd.transformBy(vec);
			bd.vis(i);
			
		// base location
			if (i==0)
			{ 
				pt= bd.ptCen() + vecGrip;
				pt.vis(6);
				ptCen = pt;
			}
			
		// G-connected
			if (bIsGConnected)
			{ 
				int bOk = Line(ptCenP, vecXP).hasIntersection(Plane(bd.ptCen(), bm.vecD(vecXP)), pt);
				pt.vis(3);
			}
			
		}
		else
		{
			Beam bmNew;
			bmNew = beams[i].dbCopy();
			bmNew.transformBy(vec);
			ptCen = bmNew.ptCenSolid();
			beamsNew.append(bmNew);
			
			// create G-Connection
			if (bmNew.bIsValid() && bmP.bIsValid() && bIsGConnected)
			{
				
				int bOk = Line(ptCenP, vecXP).hasIntersection(Plane(ptCen, bmNew.vecD(vecXP)), pt);
				
				
				Vector3d vecX1 = bmNew.vecX();
				if (vecX1.dotProduct(pt - bmNew.ptCen()) < 0)vecX1 *= -1;
				//bmNew.addToolStatic(Cut(pt, vecX1), 1);
				
				Vector3d vecX0 = bmP.vecX();
				if (vecX0.dotProduct(pt - bmP.ptCen()) < 0)vecX0 *= -1;
				//bmP.addToolStatic(Cut(pt, vecX0), 1);
				
				Vector3d vecZM = vecX0 + vecX1;
				vecZM.normalize();
				Vector3d vecYM = vecX0.crossProduct(vecZM);
				Vector3d vecXM = vecYM.crossProduct(vecZM);
				
				TslInst tslNew;
				GenBeam gbsTsl[] = { bmP, bmNew};
				Entity entsTsl[] = { };		Point3d ptsTsl[] = {pt};
				int nProps[] ={ };			double dProps[] ={ };				String sProps[] ={ };
				Map mapTsl;
				
				tslNew.dbCreate("HVAC-G" , vecXM , vecYM, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
				if (tslNew.bIsValid())
					tslConnectors.append(tslNew);
			}
			
			// collect beam as previous beam for next step in loop
			bmP = bmNew;
			bmP.setColor(i);
		}
	// collect location and direction as previous for next step in loop	
		vecXP = vecX;
		ptCenP = ptCen;
	}//next i

// now create a new duct work
	if (beamsNew.length()>0)
	{ 
		TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
		GenBeam gbsTsl[] = {};		
		Entity entsTsl[] = {};		Point3d ptsTsl[] = {beamsNew[0].ptCenSolid()+vecGrip};
		int nProps[]={};			double dProps[]={};				String sProps[]={hvac.propString(0),hvac.propString(1)};
		Map mapTsl = hvac.map();
		
		for (int i=0;i<beamsNew.length();i++) 
			gbsTsl.append(beamsNew[i]); 
		for (int i=0;i<tslConnectors.length();i++) 
			entsTsl.append(tslConnectors[i]);
		
		tslNew.dbCreate(sHVACScriptName , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);		
	}



// erase after copy
	if (!bDebug)
	{ 
		eraseInstance();
		return;
	}
#End
#BeginThumbnail
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
I444`<E<6&N:GM6Y1513D`E0!^7-=)9Q-;64$#$%HT"DCIP*LT4`?_]GZ
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
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End