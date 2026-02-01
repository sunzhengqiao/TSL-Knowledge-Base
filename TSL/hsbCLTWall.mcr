#Version 8
#BeginDescription
#Versions:
1.7 09.11.2023 20231109 Holzius: get style by thicknesses only if found style doesnt match the SF zone thickness

allow "KEEPBEAM" for both ppShape and ppShapeSub
Contour of "KEEPBEAM" beams will be subtracted from CLT contour --> allows cutouts for header beams, for example
Beams with beamcode "KEEPBEAM" are kept as beams and won't be converted to panels
coordinate system adjusted to sip wall coordinate system. 
the reference side is now opposite of the icon side, X-Axis of CLT panel parallel to wall height

renamed (replaces hsbPanelCLTWall), element tsl's triggered before command ended
style detection enhanced, beamcuts on T-Connections enhanced


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 7
#KeyWords clt;element;wall;sf wall;SIP;panel;plugins (TSL)
#BeginContents
/// <summary Lang=de>
/// Konzept
/// Dieses TSL ereugt aus der Gesamtkontur der Zone 0 einer HRB-Wand CLT Panel(e), wenn folgende Bedingungen erfüllt sind
/// - der Materialname im Wandtyp, Stab 1 entspricht dem Namen des gewünschten Panelstils
/// - die Stärke der Zone entspricht der Stärke des Panelstils
/// 
/// Zusätzlich können Abzugskörper (z.B. für die Eckausprägung) definiert werden. Der Stabcode muss in diesem Fall '-' lauetn
/// Bauteile, welche den Stabcode 'ADD' haben und deren Materialname identisch mit einem CLT-STil ist werden als zusätzliche Bauteile 
/// generiert (z.B. zusätzliches Panel als Fenstersturz)
/// Stäbe mit dem Stabcode KEEPBEAM werden nicht in ein Panel umgewandelt, sondern bleiben im Element bestehen.
/// </summary>

/// <summary Lang=en>
/// This TSL generates pseudo log elements based on child stickframe walls
/// </summary>

/// <insert=de>
/// Es stehen zwei Methoden zur Verfügung:
/// 1. ergänzen Sie das TSL zu den Element-TSL's während das Element gezeichnet wird
/// 2. wenden Sie das TSL auf eine existierende Wand an
/// </insert>

/// History
/// #Versions:
// 1.7 09.11.2023 20231109 Holzius: get style by thicknesses only if found style doesnt match the SF zone thickness Author: Marsel Nakuci
///<version value="1.6" date="10apr19" author="marsel.nakuci@hsbcad.com"> allow "KEEPBEAM" for both ppShape and ppShapeSub</version>
///<version value="1.5" date="25oct17" author="florian.wuermseer@hsbcad.com"> Contour of "KEEPBEAM" beams will be subtracted from CLT contour --> allows cutouts for header beams, for example</version>
///<version value="1.4" date="24oct17" author="florian.wuermseer@hsbcad.com"> Beams with beamcode "KEEPBEAM" are kept as beams and won't be converted to panels</version>
///<version  value="1.3" date=03jun14" author="thorsten.huck@hsbcad.com"> coordinate system adjusted to sip wall coordinate system. the reference side is now opposite of the icon side, X-Axis of CLT panel parallel to wall height </version>
///<version  value="1.2" date=20mai14" author="thorsten.huck@hsbcad.com"> renamed (replaces hsbPanelCLTWall), element tsl's triggered before command ended </version>
///<version  value="1.1" date=14mar14" author="thorsten.huck@hsbcad.com"> style detection enhanced, beamcuts on T-Connections enhanced </version>
///<version  value="1.0" date=28feb14" author="thorsten.huck@hsbcad.com"> initial </version>

// basics and prop
	
	U(1,"mm");
	double dEps = U(0.1);
	int bDebug=_bOnDebug;
	// read a potential mapObject defined by hsbDebugController
	{ 
		MapObject mo("hsbTSLDev" ,"hsbTSLDebugController");
		if (mo.bIsValid()){Map m = mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug = true;	break;}}
		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());		
	}
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	
// on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
 	  	PrEntity ssE(T("|Select wall elements|"),ElementWallSF());
  	  	if (ssE.go()==_kOk)
			_Element=ssE.elementSet();	
		
	// remove those elements which do have already a tool attached
		for (int e=_Element.length()-1;e>=0;e--)
		{
			TslInst tsls[] = 	_Element[e].tslInstAttached();
			int bRemove;
			for (int t=tsls.length()-1;t>=0;t--)
				if (tsls[t].scriptName() == scriptName())
				{
					bRemove=true;
					break;		
				}			
			if (bRemove)
			{
				reportMessage("\n" + _Element[e].number() + " removed");
				_Element.removeAt(e);
			}
		}	
		
		if (_Element.length()<1)eraseInstance();
		return;
	}
// end on insert		


// validate sset or erase me on elementDeleted
	if (_Element.length()<1 || _bOnElementDeleted)
	{
		eraseInstance();
		return;	
	}
	
//	if ( ! bDebug)return;

// standards
	Element el = _Element[0];
	_Pt0 = el.ptOrg();
	Vector3d vecX,vecY,vecZ;
	vecX=el.vecX();
	vecY=el.vecY();
	vecZ=el.vecZ();
	Plane pn(_Pt0,vecZ);
	vecX.vis(_Pt0,1);
	vecY.vis(_Pt0,3);
	vecZ.vis(_Pt0,150);

	double dZ = el.dBeamWidth();
	
// get all style names
	String sStyles[] = SipStyle().getAllEntryNames();

// collect thicknesses of all styles
	double dThicknesses[0];
	for(int i=0;i<sStyles.length();i++)
	{
		SipStyle style (sStyles[i]);
		dThicknesses.append(style.dThickness());
	}

// declare style name, will be collected from first vertical beam with material name defined
	String sStyle;
	double dThicknessFound;
// collect contour and additional/subtract beams
	Beam beams[0], beamsDummy[0], beamsAdd[0], beamsRemove[0];
	beams = el.beam();// all beams
	if (beams.length()<1)
	{
//		Display dp(12);
//		dp.textHeight(U(30));
//		dp.draw(scriptName() + " " + T("|waiting for construction|"), _Pt0, vecX,vecY, 1,0,_kDevice);	
		return;
	}
	PlaneProfile ppShape(CoordSys(_Pt0, vecX, vecY, vecZ));
	PlaneProfile ppShapeSub(CoordSys(_Pt0, vecX, vecY, vecZ));
	
	for (int b=0;b<beams.length();b++)
	{
		Beam bm = beams[b];
		String sMaterial = bm.material();
		String sBeamCode = bm.name("beamcode").token(0).makeUpper(); 
		if (sBeamCode=="-")//beamsDummy
		{
			bm.setBIsDummy(true);
			beamsDummy.append(bm);
			continue;	
		}
		if (sBeamCode=="KEEPBEAM")
		{
		// collect to ppShapeSub
			PlaneProfile pp= bm.realBody().shadowProfile(pn);
			pp.shrink(-dEps);
			ppShapeSub.unionWith(pp);
//			continue;
			
		}
		// neither of the types, this beam considered for the total planeprofile
		PlaneProfile pp= bm.realBody().shadowProfile(pn);
		pp.shrink(-dEps);
		if (sBeamCode=="CLT" && sStyles.find(sMaterial)>-1)
		{
			beamsAdd.append(bm);//beamsAdd
			if(ppShapeSub.area()<pow(dEps,2))
				ppShapeSub=pp;
			else
				ppShapeSub.unionWith(pp);			
			continue;	
		}
				
	// get style name
		if (sStyle=="" && bm.vecX().isParallelTo(vecY) && sStyles.find(sMaterial)>-1)
		{
			sStyle = sMaterial;
			dThicknessFound=dThicknesses[sStyles.find(sMaterial)];
		}
		
		//pp.vis(b);
		
		if(ppShape.area()<pow(dEps,2))
			ppShape=pp;
		else
			ppShape.unionWith(pp);
		beamsRemove.append(bm);//beamsRemove
	}// next b
	ppShape.shrink(dEps); 
	ppShapeSub.shrink(dEps);


// if the style could not be detected compare style thicknesses with zone thickness
	int nCnt;
	int nMyStyle=-1;
	if(abs(dThicknessFound-dZ)>dEps)
	{ 
	// 20231109 Holzius:check thicknesses only if found style doesnt match the thickness
		for (int i=0;i<dThicknesses.length();i++)
		{
			if (abs(dThicknesses[i]-dZ)<=dEps)
			{
				nMyStyle=i;
				nCnt++;
			}	
		}
	}
	if (nCnt>0)sStyle = sStyles[nMyStyle]; // if multiple styles match the thickness the last one is considered to be the style

// alert user and do not continue;
	if (sStyles.find(sStyle)<0)
	{
		reportMessage("\n***** " + scriptName() + " " + el.number() + " *****");
		reportMessage("\n" + T("|No matching style could be detected.|") + "\n" + T("|Please validate the CLT styles and/or the material which is assigned to zone 0|"));
		reportMessage("\n" + T("|Tool will be deleted|"));
		eraseInstance();
		return;	
	}


// collect openings
	PLine plOpenings[0];
	Opening openings[] = el.opening();
	PlaneProfile ppOpening(CoordSys(_Pt0,vecX,vecY,vecZ));
	for (int o=0;o<openings.length();o++)
	{
		PLine pl = openings[o].plShape();
		plOpenings.append(pl);
		ppOpening.joinRing(pl,_kAdd);
	}
	//ppOpening.vis(2);
		
// remove all opening rings not being an opening
	PLine plRings[] = ppShape.allRings();
	int bIsOp[] = ppShape.ringIsOpening();
	ppShape.removeAllRings();
	for (int r=0;r<plRings.length();r++)
		if(!bIsOp[r])
			ppShape.joinRing(plRings[r],_kAdd);

	// validate opening
	for (int r=0;r<plRings.length();r++)
	{
		PLine pl = plRings[r];
		PlaneProfile pp(pl);
		pp.intersectWith(ppOpening); 
		if(bIsOp[r] && pp.area()>pow(dEps,2))
			ppShape.joinRing(pl,_kSubtract);
	}	
	ppShape.subtractProfile(ppShapeSub);
	ppShape.vis(3);			
	ppShapeSub.vis(6);	

//		if (bDebug)return;
// create the sips
	if (_Sip.length()<1 && sStyles.find(sStyle)>-1)
	{
		plRings = ppShape.allRings();
		bIsOp = ppShape.ringIsOpening();		
		for (int r=0;r<plRings.length();r++)
		{
			if (!bIsOp[r])
			{
				Sip sip;
				PLine pl = plRings[r];
				pl.setNormal(vecZ);
//				if (!bDebug)
//				{
					sip.dbCreate(pl, sStyle,-1);				
					if(sip.bIsValid())
					{
						sip.setXAxisDirectionInXYPlane(vecY);
						sip.assignToElementGroup(el,true,0,'Z');
						_Sip.append(sip);
						for (int s=0;s<plRings.length();s++)
							if (bIsOp[s])
								sip.addOpening(plRings[s],false);
					}
//				}
//				else
//					pl.vis(1);
			}	
		}// next r
	}


// append dummy tools static
	for (int i=0;i<beamsDummy.length();i++)
	{
		Beam bm = beamsDummy[i];
		Body bd =bm.envelopeBody();
		Point3d ptBc = bm.ptCen();
		double dX, dY, dZ;
		Vector3d vecXBm, vecYBm, vecZBm;
		dX = bm.solidLength();
		dY = bm.solidWidth();
		dZ = bm.solidHeight();

		vecXBm = bm.vecX();
		vecYBm = bm.vecY();
		vecZBm = bm.vecZ();
				
		int nType = bm.type();
		//if (nType == _kSFStudLeft || nType == _kSFStudRight)
		{
			dX+= U(10000);	
		}
		
		if (dX>dEps && dY>dEps && dZ>dEps)
		{
			BeamCut bc(ptBc,vecXBm,vecYBm,vecZBm,dX,dY,dZ,0,0,0);
			for (int s=0;s<_Sip.length();s++)
			{
				if (bd.intersectWith(_Sip[s].envelopeBody()))
					_Sip[s].addToolStatic(bc);
			}
		}
	}	

// create addional sips
	for (int i=0;i<beamsAdd.length();i++)
	{
		Beam bm = beamsAdd[i];
		String sMaterial = bm.material();
		if (sStyles.find(sMaterial)<0) continue;
		
		PlaneProfile pp= bm.realBody().shadowProfile(pn);
		plRings = pp.allRings();
		bIsOp = pp.ringIsOpening();		
		for (int r=0;r<plRings.length();r++)
		{
			if (!bIsOp[r])
			{
				PLine pl = plRings[r];
				pl.setNormal(vecZ);
//				if (!bDebug)
//				{
					Sip sip;
					sip.dbCreate(pl, sStyle,-1);
					if (!bm.vecX().isParallelTo(sip.vecZ()))
						sip.setXAxisDirectionInXYPlane(bm.vecX());
					sip.assignToElementGroup(el,true,0,'Z');		
//				}	
//				else
//					pl.vis(4);	
			}			
		}	
	}	
	
//	if(!bDebug)
//	{
		for (int i=beams.length()-1;i>=0;i--)
		{ 
			String sBeamCode = beams[i].name("beamcode").token(0).makeUpper(); 
			if (sBeamCode=="KEEPBEAM")
				continue;
			
			beams[i].dbErase();
		}
			
		
	// trigger element tsl's to be executed
		TslInst tsls[] = el.tslInst();
		for (int i=0; i<tsls.length();i++)
			if (tsls[i]!=_ThisInst)
				tsls[i].recalcNow();	
		
		eraseInstance();
//	}
	return;
	




#End
#BeginThumbnail
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
A3:MRJ*BG(!*@#\N:Z2SA:WLH(&(+1QA21TX%6**`/__9
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
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="118" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="20231109 Holzius: get style by thicknesses only if found style doesnt match the SF zone thickness" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="11/9/2023 9:58:34 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End