#Version 8
#BeginDescription
#Versions:
1.6 27/06/2024 HSB-22319: Add distance to line check at cleanup function Marsel Nakuci
1.5 07/06/2024 HSB-22144: Update cornerCleanUp function Marsel Nakuci
1.4 24/05/2024 HSB-22085: When analysing plEnvelope, cleanup pline, remove possible points along a line Marsel Nakuci
1.3 02.06.2022 HSB-15648: distinguish sides for "custom drill" like hsbPanelDrill. Add double click command flip side Author: Marsel Nakuci
1.2 25.05.2022 HSB-15569: support side PLine of the realbody with tooling for the mode "Custom Single drill" Author: Marsel Nakuci
1.1 13.05.2022 HSB-15483: Add "Custom single drill" at insertion modes Author: Marsel Nakuci
version  value="1.0" date="04jul14" author="th@hsbCAD.de"
initial

DACH
Dieses TSL erzeugt eine oder mehrere Bohrungen an konkaven Bauteilecken.
Es stehen verschiedene Modi zur Anzahl und Verteilung zur Verfügung.

EN
This tsl creates cleanup drills at concave corners. One can select between different insertion modes.






#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 6
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// #Versions
// 1.6 27/06/2024 HSB-22319: Add distance to line check at cleanup function Marsel Nakuci
// 1.5 07/06/2024 HSB-22144: Update cornerCleanUp function Marsel Nakuci
// 1.4 24/05/2024 HSB-22085: When analysing plEnvelope, cleanup pline, remove possible points along a line Marsel Nakuci
// 1.3 02.06.2022 HSB-15648: distinguish sides for "custom drill" like hsbPanelDrill. Add double click command flip side Author: Marsel Nakuci
// 1.2 25.05.2022 HSB-15569: support side PLine of the realbody with tooling for the mode "Custom Single drill" Author: Marsel Nakuci
// 1.1 13.05.2022 HSB-15483: Add "Custom single drill" at insertion modes Author: Marsel Nakuci
/// Dieses TSL erzeugt eine oder mehrere Bohrungen an konkaven Bauteilecken.
/// Es stehen verschiedene Modi zur Anzahl und Verteilung zur Verfügung.
/// </summary>

/// <summary Lang=en>
/// This tsl creates cleanup drills at concave corners. One can select between different insertion modes.
/// </summary>

/// <insert Lang=de>
/// In Abhängigkeit des gewählten Modus können ein bzw. mehrere Panele gewählt werden. Es wird für jedes Panel eine Werkzeuginstanz eingefügt.
/// </insert>

/// <insert Lang=en>
/// In dependency ofthe selected mode one can select one or multiple panels. Each selected panel will receive one tooling instance.
/// </insert>
///<version  value="1.0" date="04jul14" author="th@hsbCAD.de"> initial </version>
	
// basics and props
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex;
	String sDoubleClick= "TslDoubleClick";
	String sOpmKeyName = "Insert";
	String sInsertModes[] = {T("|All Openings|"), T("|Opening|"),T("|Outer Contour|"), T("|Single drill|"), T("|All|"),T("|Custom Single drill|")};

	String sDiameterName= T("|Diameter|");
	PropDouble dDiameter(nDoubleIndex++, U(40),sDiameterName);
	dDiameter.setDescription(T("|Sets the diameter of the drill|"));		
	//dDiameter.setCategory(sCat1);
	
	String sInsertModeName=T("|Insert Mode|");
	PropString sInsertMode(nStringIndex++, sInsertModes, sInsertModeName);
	sInsertMode.setDescription(T("|Sets the insertion mode. Certain modes support multiple panel selection or require the input of a location.|"));
	
	// HSB-15483
	String sSideName=T("|Side|");
	String sSides[]={ T("|Reference|"),T("|Opposite|")};
	PropString sSide(nStringIndex++, sSides, sSideName);	
	sSide.setDescription(T("|Defines the Side of the drill|"));
//	sSide.setCategory(category);
	
	String sDepthName=T("|Depth|");	
	PropDouble dDepth(nDoubleIndex++, U(0), sDepthName);	
	dDepth.setDescription(T("|Defines the Depth of the drill|"));
//	dDepth.setCategory(category);
	
//region Functions
	//region cleanUpPline
	// this function will clean plines
	// it will remove points inside a line
	// it will leave only the corner points of a pline
	Map cleanUpPline(PLine plIn)
	{ 
		// HSB-22144
		Map _m;
		Point3d pts[]=plIn.vertexPoints(false);
		CoordSys csPl=plIn.coordSys();
		PLine plOut;
		
		if(pts.length()<3)
		{ 
			_m.setPLine("pl",plIn);
			return _m;
		}
		
		Point3d ptsAddition[0];  
		Point3d ptsFinal[0];  
		int nIndicesAdd[0];
		for (int p=0;p<pts.length()-2;p++) 
		{ 
			Point3d ptP=pts[p];
			ptP.vis(1);
			Vector3d vecDirP;
			Line lnp;
			for (int j=p+1;j<pts.length()-1;j++) 
			{ 
				Point3d ptJ=pts[j];
				lnp=Line(.5*(ptP+ptJ),vecDirP);
				if(j==p+1)
				{ 
					// first point
					vecDirP=ptJ-ptP;
					vecDirP.normalize();
				}
				else
				{ 
					Vector3d vecDirJ=ptJ-ptP;
					vecDirJ.normalize();
					Vector3d vecDirJ1=ptJ-pts[j-1];
					vecDirJ1.normalize();
					if(abs(abs(vecDirP.dotProduct(vecDirJ))-1.0)<.1*dEps
					&& abs(abs(vecDirP.dotProduct(vecDirJ1))-1.0)<.1*dEps)
					{
						// parallel
						// HSB-22319
						// do the distance from line check
						// the vector direction not very accurate
						Point3d ptAtLine=lnp.closestPointTo(pts[j-1]);
						if((ptAtLine-pts[j-1]).length()<U(1))
						{ 
							ptAtLine.vis(6);
							lnp.vis(2);
							// parallel
							ptsAddition.append(pts[j-1]);
							nIndicesAdd.append(j);
						}
					}
					else
					{ 
						// new direction
						break;
					}
				}
				
			}//next j
		}//next p
		
		for (int p=0;p<pts.length();p++) 
		{ 
			if(nIndicesAdd.find(p)<0)
			{
				ptsFinal.append(pts[p]); 
			}
		}//next p
		
		
//		// get all unique vectors/lines
//		Vector3d vecs[0];
//		Line lns[0];
//		for (int p=0;p<pts.length()-1;p++) 
//		{ 
//			Vector3d vec=pts[p+1]-pts[p];
//			if(vec.length()<U(1))
//			{ 
//				continue;
//			}
//			vec.normalize();
//			// middle point of segment
//			Point3d ptMidI=.5*(pts[p+1]+pts[p]);
//			Line lnI(ptMidI,vec);
//			
//			int bAdd=true;
//			for (int l=0;l<lns.length();l++) 
//			{ 
//				Line ln_i=lns[l];
//				// point in line
//				Point3d ptL=ln_i.closestPointTo(ptMidI);
//				if((ptL-ptMidI).length()<U(1))
//				{ 
//					Vector3d vec_i=lns[l].vecX();
//					if(abs(abs(vec_i.dotProduct(vec))-1.0)<dEps)
//					{ 
//						// parallel
//						bAdd=false;
//						break;
//					}
//				}
//			}//next l
//			if(bAdd)
//			{ 
//				lns.append(lnI);
//			}
//		}//next p
//		
//		// get for each line 2 extreme vertex points
//		Point3d ptsExtremes[0];
//		for (int i=0;i<lns.length();i++) 
//		{ 
//			Point3d ptsI[0];
//			for (int p=0;p<pts.length()-1;p++) 
//			{ 
//				Point3d ptP=pts[p];
//				Point3d ptPl=lns[i].closestPointTo(ptP);
//				if((ptPl-ptP).length()<U(1))
//				{ 
//					ptsI.append(ptP);
//				}
//			}//next p
//			Point3d ptsOrderI[]=lns[i].orderPoints(ptsI,dEps);
//			ptsExtremes.append(ptsOrderI.first());
//			ptsExtremes.append(ptsOrderI.last());
//		}//next i
//		
//		
//		Point3d ptsFinal[0];
//		Point3d ptsAddition[0]; // redundant, cleaned points
//		for (int p=0;p<pts.length()-1;p++) 
//		{ 
//			Point3d ptP=pts[p]; 
//			int bAdd;
//			for (int j=0;j<ptsExtremes.length();j++) 
//			{ 
//				if((ptsExtremes[j]-ptP).length()<dEps)
//				{ 
//					bAdd=true;
//					break;
//				}
//			}//next j
//			if(bAdd)
//			{ 
//				ptsFinal.append(ptP);
//			}
//			else
//			{ 
//				// points inside a line
//				ptsAddition.append(ptP);
//			}
//		}//next p
		
		for (int p=0;p<ptsFinal.length();p++) 
		{ 
			ptsFinal[p].vis(6); 
		}//next p
		
		if(ptsAddition.length()>0)
		{ 
			// addition points found
			plOut=PLine(csPl.vecZ());
			for (int p=0;p<ptsFinal.length();p++) 
			{ 
				plOut.addVertex(ptsFinal[p]);
			}//next p
			_m.setPoint3dArray("ptsAddition",ptsAddition);
		}
		else
		{ 
			plOut=plIn;
		}
		
		_m.setPLine("pl",plOut);
		return _m;
//		return plOut;
	}
	//End cleanUpPline//endregion
//End Functions//endregion 
	
// bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }

	// silent/dialog
		String sKey = _kExecuteKey;
		if (sKey.length()>0)
			setPropValuesFromCatalog(sKey);	
		else
			showDialog();

	// get selected insert mode
		int nInsertMode = sInsertModes.find(sInsertMode);

			
	// declare arrays for tsl cloning
		TslInst tslNew;
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		GenBeam gbs[1];
		Entity ents[0];
		Point3d pts[0];
		int nProps[]={};
		double dProps[]={dDiameter,dDepth};
		String sProps[]={sInsertMode,sSide};
		Map mapTsl;
		String sScriptname = scriptName();
		
	// select one or multiple panels in dependency of the selected insert mode
		Entity entsSet[0];
		if (nInsertMode==0 || nInsertMode==2 || nInsertMode==4)
		{
			PrEntity ssE(T("|Select CLT panels|"), Sip());
			if (ssE.go()) 
				entsSet= ssE.set();
		}		
		else
			entsSet.append(getSip(T("|Select panel|")));
			
	// pick point for some insert modes		
		if (nInsertMode==1)
			_Pt0 = getPoint(T("|Pick point inside opening|"));
		else if(nInsertMode==3 || nInsertMode==5)
			_Pt0 = getPoint(T("|Pick point|"));	
						
	// loop sset and create instances per CLT
		for (int i=0;i<entsSet.length();i++)
		{
			GenBeam gb = (GenBeam) entsSet[i];
			if (gb.bIsValid())
			{
				pts.setLength(0);
				if (nInsertMode==1 || nInsertMode==3 || nInsertMode==5)
					pts.append(_Pt0);
				else
					pts.append(gb.ptCenSolid());
				gbs[0] = gb;
				tslNew.dbCreate(sScriptname, vecUcsX,vecUcsY,gbs, ents, pts, nProps, dProps, sProps,_kModelSpace, mapTsl); // create new instance
			}
		}			
		return;
	}
// end on insert
	
// validate
	if (_Sip.length()<1)
	{
		eraseInstance();
		return;	
	}

// standards	
	Sip sip = _Sip[0];
	Vector3d vecX = sip.vecX();
	Vector3d vecY = sip.vecY();
	Vector3d vecZ = sip.vecZ();
	assignToGroups(sip);
	double dZ = sip.dH();
	
// get selected insert mode
	int nInsertMode = sInsertModes.find(sInsertMode);

// get plines
	PLine plEnvelope = sip.plEnvelope();
	// HSB-22085: cleanup pline, remove possible points along a line
	Map mCleanUp=cleanUpPline(plEnvelope);
	Point3d ptsAddition[]=mCleanUp.getPoint3dArray("ptsAddition");
	if(ptsAddition.length()>0)
	{ 
		plEnvelope=mCleanUp.getPLine("pl");
	}
	PLine plOpenings[] = sip.plOpenings();
	_Pt0.transformBy(vecZ*vecZ.dotProduct(plEnvelope.ptStart()-_Pt0));
	
// declare locations
	Point3d ptsLoc[0];
	
	if(nInsertMode!=5)
	{ 
		dDepth.setReadOnly(_kHidden);
		sSide.setReadOnly(_kHidden);
	}
	else if(nInsertMode==5)
	{ 
		if(dDepth<=0)
		{ 
			dDepth.set(dZ);
		}
		
	//region HSB-15648: Trigger FlipSide
		String sTriggerFlipSide = T("|Flip Side|");
		addRecalcTrigger(_kContextRoot, sTriggerFlipSide );
		if (_bOnRecalc && (_kExecuteKey==sTriggerFlipSide || _kExecuteKey==sDoubleClick))
		{
			sSide.set( sSides[!sSides.find(sSide)]);
			setExecutionLoops(2);
			return;
		}//endregion
	}
	int nSide = sSides.find(sSide);
	
// All Openings, Opening, All
	if (nInsertMode<2 || nInsertMode==4)
	{	
		PLine plOpening;
		
	// test Pt0 against openings
		int nOpeningIndex=-1;
		int bIsDoor;
		for(int i=0;i<plOpenings.length();i++)
		{
			PlaneProfile pp(plOpenings[i]);
			if (pp.area()<pow(dDiameter,2))continue;
			
			if (nInsertMode == 1 && pp.pointInProfile(_Pt0)!=_kPointInProfile)
			{
				continue;
			}	
			
			nOpeningIndex=i;
			plOpening=plOpenings[i];
			plOpening.convertToLineApprox(dDiameter);	


			Point3d pts[] = plOpening.vertexPoints(true);	
			
			int n = pts.length();
			for(int i=0;i<n;i++)
			{
				int a=i;
				int b=i+1;
				int c=i+2;
				if (b>n-1)b = b-n;
				if (c>n-1)c = c-n;
				
				Vector3d vec1 = pts[b]-pts[a];	vec1.normalize();
				Vector3d vec2 = pts[b]-pts[c];	vec2.normalize();
				Vector3d vecN = vec1+vec2;
				vecN.normalize();
				vecN.vis(pts[b],i);
				
				if(pp.pointInProfile(pts[b]+vecN*dEps)==_kPointOutsideProfile)
				{
					Point3d ptLoc = pts[b]-vecN*.5*dDiameter;
					ptsLoc.append(ptLoc);
				}
			}


			if (nInsertMode == 1)
			{
				setEraseAndCopyWithBeams(_kBeam0);
				break;
			}	
		}
	}// END IF nInsertMode==1
//return;
//Outer Contour or All	
	if (nInsertMode==2 || nInsertMode==4)
	{
		PlaneProfile pp(plEnvelope);
		plEnvelope.convertToLineApprox(dDiameter);
		Point3d pts[] = plEnvelope.vertexPoints(true);	
		
		int n = pts.length();
		for(int i=0;i<n;i++)
		{
			int a=i;
			int b=i+1;
			int c=i+2;
			if (b>n-1)b = b-n;
			if (c>n-1)c = c-n;
			
			Vector3d vec1 = pts[b]-pts[a];	vec1.normalize();
			Vector3d vec2 = pts[b]-pts[c];	vec2.normalize();
			Vector3d vecN = vec1+vec2;
			vecN.normalize();
			vecN.vis(pts[b],i);
			
			if(pp.pointInProfile(pts[b]+vecN*dEps)==_kPointInProfile)
			{
				Point3d ptLoc = pts[b]-vecN*.5*dDiameter;
				ptsLoc.append(ptLoc);
			}
		}
	}
// Single location	
	else if (nInsertMode==3 || nInsertMode==5)
	{
	// declare return value of this statement
		int bOk;
		setEraseAndCopyWithBeams(_kBeam0);
		
	// collect test plines
		PLine plines[] = {plEnvelope};
		plines.append(plOpenings);
		
	// remember closed rings not opening
		int iClosedRings[plines.length()];
		iClosedRings[0]=true;
		
	// for custom drill collect also the reference or the opposite Plines
	// from the real body
		if(nInsertMode==5)
		{ 
//			Body bdReal=sip.realBody();
			Body bdSipTools = sip.envelopeBody(true, true);
			AnalysedTool tools[] = sip.analysedTools();
			AnalysedBeamCut beamcuts[]=AnalysedBeamCut().filterToolsOfToolType(tools);
			AnalysedMortise mortises[]=AnalysedMortise().filterToolsOfToolType(tools);
			AnalysedCut cuts[]=AnalysedCut().filterToolsOfToolType(tools);
			for (int i=0;i<cuts.length();i++) 
			{ 
				AnalysedCut aC = cuts[i];
				Cut cut(aC.ptOrg(), aC.normal());
				bdSipTools.addTool(cut);
			}//next i
			for (int i = 0; i < beamcuts.length(); i++)
			{
				AnalysedBeamCut aBc = beamcuts[i];
				Quader qdBc = aBc.quader();
				
				BeamCut bc(qdBc.ptOrg(), qdBc.vecX(), qdBc.vecY(), qdBc.vecZ(),
				qdBc.dD(qdBc.vecX()), qdBc.dD(qdBc.vecY()), qdBc.dD(qdBc.vecZ()),
				0, 0, 0);
				bdSipTools.addTool(bc);
			}
			for (int i = 0; i < mortises.length(); i++)
			{
				AnalysedMortise msI = mortises[i];
				Quader qdMortise = msI.quader();
				CoordSys csMortise = msI.coordSys();
				double dDepthMortise = msI.dDepth();
				Body bdI(qdMortise);
				bdSipTools.subPart(bdI);
			}
			
			Plane pnSide;
			if(nSide==0)
			{ 
				// reference side
				pnSide=Plane(sip.ptCen()-vecZ*.5*dZ,vecZ);
			}
			else if(nSide==1)
			{ 
				// opposite side
				pnSide=Plane(sip.ptCen()+vecZ*.5*dZ,vecZ);
			}
			PlaneProfile ppSide = bdSipTools.extractContactFaceInPlane(pnSide, dEps);
			
			ppSide.transformBy(vecZ*vecZ.dotProduct(plEnvelope.ptStart()-ppSide.coordSys().ptOrg()));
			ppSide.vis(6);
			PLine plsSide[]=ppSide.allRings(true,true);
			PLine plsSideClosed[]=ppSide.allRings(true,false);
			PLine plsSideOpenings[]=ppSide.allRings(false,true);
			plines.append(plsSide);
			
			for (int ipl=0;ipl<plsSideClosed.length();ipl++) 
			{ 
				iClosedRings.append(true);
			}//next ipl
			for (int ipl=0;ipl<plsSideOpenings.length();ipl++) 
			{ 
				iClosedRings.append(false);
			}//next ipl
		}
		
	// collect the vertices of all openings and the envelope. the closest vertex is the one to be used
		Point3d pts[0];
		int iPlinesIndex[0];
		int iLastPoint = 0;
		for(int i=0;i<plines.length();i++)
		{
			PLine pline=plines[i];		
			if (i>0 && pline.area()<pow(dDiameter,2))continue;
			pline.convertToLineApprox(dDiameter);
			Point3d ptsI[] = pline.vertexPoints(true);
			pts.append(ptsI);// onlyOnce
			for (int ii=-1;ii<ptsI.length()-1;ii++) 
			{ 
				iPlinesIndex.append(i);
			}//next ii
			iLastPoint += ptsI.length();
		}
		_Pt0.vis(6);
	// order by distance to _Pt0
		double dMin = U(10000000);
		Point3d pt;
		int nInd = -1;
		for(int i=0;i<pts.length();i++)
		{
			pts[i].vis(6);
			double d = (pts[i]-_Pt0).length();
			if (d<dMin)
			{
				dMin = d;
				pt=pts[i];
				nInd = iPlinesIndex[i];
			}	
		}
		pt.vis(2);
	// find pline where this point is on
//		int nInd=-1;
//		for(int i=0;i<plines.length();i++)
//			if (plines[i].isOn(pt))
//			{
//				nInd=i;
//				break;
//			}	
//		return;
		if (dMin<U(10000000) && nInd>-1)
		{
			PLine pline = plines[nInd];
			PlaneProfile pp(pline);
			pts = pline.vertexPoints(true);	
			
			int n = pts.length();
			for(int i=0;i<n;i++)
			{
				int a=i;
				int b=i+1;
				int c=i+2;
				if (b>n-1)b = b-n;
				if (c>n-1)c = c-n;
				
			// compare with the selected point
				if ((pts[b]-pt).length()>dEps)continue;
				
				Vector3d vec1 = pts[b]-pts[a];	vec1.normalize();
				Vector3d vec2 = pts[b]-pts[c];	vec2.normalize();
				Vector3d vecN = vec1+vec2;
				vecN.normalize();
				vecN.vis(pts[b], 1);
//				if(nInd==0 && pp.pointInProfile(pts[b]+vecN*dEps)==_kPointInProfile)
				if(iClosedRings[nInd] && pp.pointInProfile(pts[b]+vecN*dEps)==_kPointInProfile)
					bOk=true;
				else if(!iClosedRings[nInd] && pp.pointInProfile(pts[b]+vecN*dEps)==_kPointOutsideProfile)
					bOk=true;
				if (bOk)	
				{
					Point3d ptLoc = pts[b]-vecN*.5*dDiameter;
					ptsLoc.append(ptLoc);
					vecN.vis(ptLoc,3);				
					break;
				}
			}// next i
		}// END IF (dMin<U(10000000) && nInd>-1)
		
	// erase me if no valid point found
		if (!bOk)
		{
			eraseInstance();
			return;
		}		
	}// END IF (nInsertMode==3)
	
// display	
	Display dp (nInsertMode);
	if (_bOnDebug)
		dp.draw(scriptName()+ " " + sInsertModes[nInsertMode],_Pt0,_XW,_YW,0,0,_kDeviceX);
	
		
// drill at locations	
	for(int i=0;i<ptsLoc.length();i++)
	{
		Point3d ptLoc = ptsLoc[i];
		ptLoc.vis(1);
		PLine plCirc;
		plCirc.createCircle(ptLoc, vecZ, dDiameter/2);
		
		if(nInsertMode!=5)
		{ 
			dp.draw(plCirc);
			Drill drill(ptLoc, ptLoc+vecZ*dZ,dDiameter/2 );
			sip.addTool(drill);
		}
		else if(nInsertMode==5)
		{ 
			
			Vector3d vecDrill = vecZ;
			dp.color(6);
			if(nSide==1)
			{ 
				plCirc.transformBy(vecZ * dZ);
				ptLoc+=vecZ*dZ;
				vecDrill *= -1;
				dp.color(3);
			}
			
			dp.draw(plCirc);
			Drill drill(ptLoc, ptLoc+vecDrill*dDepth,dDiameter/2 );
			sip.addTool(drill);
		}
	}
	
// erase if no locations found
	if (ptsLoc.length()<1)
	{
		reportMessage("\n" + scriptName() + " " + T("|could not find any cleanup locations in panel|") + " " + sip.posnum() );	
		reportMessage(TN("|Tool will be deleted.|"));
		eraseInstance();
		return;
	}






#End
#BeginThumbnail
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
G'/YFO3;&U@MX$@MXDAB`X2-0H_2HK5JD;)O[OZ_R*ITX/5?B?__9
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
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22319: Add distance to line check at cleanup function" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="6/27/2024 1:20:06 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22144: Update cornerCleanUp function" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="6/7/2024 8:36:19 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22085: When analysing plEnvelope, cleanup pline, remove possible points along a line" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="5/24/2024 8:49:24 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15648: distinguish sides for &quot;custom drill&quot; like hsbPanelDrill. Add double click command flip side" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="6/2/2022 11:35:18 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15569: support side PLine of the realbody with tooling for the mode &quot;Custom Single drill&quot;" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="5/25/2022 1:11:25 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15483: Add &quot;Custom single drill&quot; at insertion modes" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="5/13/2022 1:53:45 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End