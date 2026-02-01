#Version 8
#BeginDescription
/// This tsl defines a rabbet / tenon joint between T-connected panels
/// The tool stretches the closest edge(s) to the designated plane

version value="1.6" date="18oct17" author="thorsten.huck@hsbcad.com"
bugfix purging
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
/// This tsl defines a dove tail connection or a butterfly spline as T-Connection between at least two panels.
/// </summary>

/// <insert Lang=en>
/// Select a set of male panels and then a set of female panels.
/// </insert>

/// History
///<version value="1.6" date="18oct17" author="thorsten.huck@hsbcad.com"> bugfix purging </version>
///<version value="1.5" date="11Sep17" author="thorsten.huck@hsbcad.com"> copy and split behaviour enhanced </version>
///<version value="1.4" date="24may17" author="thorsten.huck@hsbcad.com"> article name of hardware changed to X-fix L </version>
///<version value="1.3" date="23may17" author="thorsten.huck@hsbcad.com"> article name of hardware changed to XFix-L </version>
///<version value="1.2" date="13jun16" author="thorsten.huck@hsbcad.com"> image updated </version>
///<version value="1.0" date="30may16" author="thorsten.huck@hsbcad.com"> initial </version>


// constants //region
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));	
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	//endregion


	
	
	
// categories
	String sCategoryAlignment = T("|Alignment|");
	String sCategoryGeometry = T("|Geometry|");


// geometry
	String sXWidthName="(A)   " + T("|Width|");
	PropDouble dXWidth(nDoubleIndex++, U(50),sXWidthName);
	dXWidth.setDescription(T("|Defines the depth of the lap joint seen from reference side|") + " " + T("|0 = 50% of thickness|"));
	dXWidth.setCategory(sCategoryGeometry);

	String sZDepthName="(B)   " + T("|Depth|");	
	PropDouble dZDepth(nDoubleIndex++, U(20), sZDepthName);
	dZDepth.setDescription(T("|Defines the depth|") );
	dZDepth.setCategory(sCategoryGeometry);

	String sNameAlfa="(C)  " + T("|Angle|");
	PropDouble dAlfa(nDoubleIndex++, U(0),sNameAlfa,_kAngle);
	dAlfa.setDescription(T("|Defines the angle dovetail.|"));
	dAlfa.setCategory(sCategoryGeometry);

	String sGapName="(D)   " + T("|Gap|");
	PropDouble dGap(nDoubleIndex++, 0,sGapName);
	dGap.setDescription(T("|Defines the gap in depth of the joint|"));
	dGap.setCategory(sCategoryGeometry);

// Alignment	
	String sNameAxisOffset="(E)  " + T("|Axis Offset|") + " X";
	PropDouble dAxisOffset(nDoubleIndex++,U(0), sNameAxisOffset);
	dAxisOffset.setDescription(T("|Defines horizontal offset of the tool.|"));
	dAxisOffset.setCategory(sCategoryAlignment);

	String sNameBottomOffset="(F)  " + T("|Bottom Offset|");
	PropDouble dBottomOffset(nDoubleIndex++,U(0), sNameBottomOffset);
	dBottomOffset.setDescription(T("|Defines bottom offset of the tool.|") + " " + T("|0 = complete through|"));
	dBottomOffset.setCategory(sCategoryAlignment);

	String sToolName = "(G)  " +T("|Open Tool Side|");
	String sTools[] = {T("|bottom|"), T("|top|"), T("|Both|")};
	PropString sTool(nStringIndex++, sTools, sToolName );
	sTool.setDescription(T("|Defines the extension of the tool if panels have different extents.|"));
	sTool.setCategory(sCategoryAlignment);

// general
	String sDoveModeName="(H)  " + T("|Connection Type|");	
	String sDoveModes[] = {T("|Dovetail|"), T("|Butterfly Spline|")};
	PropString sDoveMode(nStringIndex++, sDoveModes, sDoveModeName,0);	
	sDoveMode.setDescription(T("|Specifies if the dove is added to the male set or if two female doves are added"));

// chamfer
	String sCategoryRef = T("|Reference Side|");
	String sChamferRefName="(I)  "+T("|Chamfer|");
	PropDouble dChamferRef(nDoubleIndex++, U(0), sChamferRefName);
	dChamferRef.setCategory(sCategoryRef);

	String sCategoryOpp = T("|opposite side|");
	String sChamferOppName="(J)  "+T("|Chamfer|");
	PropDouble dChamferOpp(nDoubleIndex++, U(0), sChamferOppName);
	dChamferOpp.setCategory(sCategoryOpp );

		
// on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }	

	// a potential catalog entry name and all available entries
		String sEntry = _kExecuteKey;
		String sEntryUpper = sEntry; sEntryUpper.makeUpper();
		String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
		for (int i=0;i<sEntries.length();i++)
			sEntries[i].makeUpper();
		int nEntry = sEntries.find(sEntryUpper);
		
							
	// silent/dialog
		if (nEntry>-1)
			setPropValuesFromCatalog(sEntry);	
		else
			showDialog();

	
	// loop male and female panel selection
		Sip males[0], females[0];	
		String sPrompt = 	T("|Select male panel(s)");
		for(int k=0;k<2;k++)
		{
			PrEntity ssE(sPrompt , Sip());
			Sip sips[0];
			Entity ents[0];
		  	if (ssE.go())ents=ssE.set();

			Vector3d vecZ;
			Point3d ptCen;
			double dH;
			for(int i=0;i<ents.length();i++)
			{
				Sip sip= (Sip)ents[i];
				if (sip.bIsValid())
				{
				// collect ref orientation	
					if (vecZ.bIsZeroLength())
					{
						vecZ=sip.vecZ();
						ptCen = sip.ptCenSolid();	
						dH = sip.dH();
					}
					
				// make sure no female is parallel to the males
					if (k==1 && males.length()>0 && vecZ.isParallelTo(males[0].vecZ()))	continue;
				
				// append only if normals are parallel and within thickness range	
					if (vecZ.isParallelTo(sip.vecZ()) && abs(vecZ.dotProduct(ptCen-sip.ptCen()))<.5*dH)
						sips.append(sip);
				}
			}
			if(bDebug)reportMessage("\n"+ sPrompt + " has found " + sips.length());

		// break if no panels found
			if (sips.length()<1)
			{
				reportMessage("\n"+ scriptName() + " " +T("|Invalid selection set.|"));
				eraseInstance();
				return;		
			}	
			if (k==0)males=sips;
			else if (k==1) females=sips;
			sPrompt =T("|Select female panel(s)");
	
		}// next k male/female

	// evaluate stretch direction by FirstOrDefaults
		Vector3d vecXM, vecYM, vecZM, vecZF;
		Point3d ptCenM=males[0].ptCenSolid(), ptCenF=females[0].ptCenSolid();
		vecXM = males[0].vecX();
		vecYM = males[0].vecY();
		vecZM = males[0].vecZ();
		vecZF = females[0].vecZ();		

		
	// prepare tsl cloning
		TslInst tslNew;
		Vector3d vecXTsl= vecXM ;
		Vector3d vecYTsl= vecYM;
		GenBeam gbsTsl[] = {};
		Entity entsTsl[] = {};
		Point3d ptsTsl[] = {ptCenM};
		int nProps[]={};
		double dProps[]={};
		String sProps[]={};
		Map mapTsl;	
		String sScriptname = scriptName();

		Map mapMales;
		for(int i=0;i<males.length();i++)
		{
			gbsTsl.append(males[i]);
			mapMales.appendEntity("male",males[i]);
		}
		mapTsl.setMap("Male[]", mapMales);
		for(int i=0;i<females.length();i++)gbsTsl.append(females[i]);

		tslNew.dbCreate(sScriptname , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
				nProps, dProps, sProps,_kModelSpace, mapTsl);	

		if (tslNew.bIsValid())
			tslNew.setPropValuesFromCatalog(T("|_LastInserted|"));			

		eraseInstance();
		return;
	}	
//end on insert________________________________________________________________________________						


// properties by index
	int nTool=sTools.find(sTool);	
	int nDoveMode=sDoveModes.find(sDoveMode,0);
	// 0 = Dovetail
	// 1 = Butterfly Spline

// declare and set stretch value of male
	double dStretch = (nDoveMode==0)?dZDepth:0;
	
// set copy behavior
	setEraseAndCopyWithBeams(_kBeam01);
		
// collect males and females	
	Map mapMales = _Map.getMap("Male[]");
	if (mapMales.length()<1)
	{
		reportMessage(TN("|Invalid orientation data|"));
		eraseInstance();
		return;
	}
	Sip males[0], females[0];	
	
// collect males by map	
	Vector3d vecXM, vecYM, vecZM;
	Point3d ptCenM;
	double dHM;
	for(int i=mapMales.length()-1;i>=0;i--)
	{
		Entity ent = mapMales.getEntity(i);
		Sip sip = (Sip)ent;
		
		if (sip.bIsValid() && _Sip.find(sip)>-1)
		{
			Vector3d vecZ = sip.vecZ();
			Point3d ptCen=sip.ptCenSolid();
			double dH= sip.dH();						
			if (vecZM.bIsZeroLength())
			{
				vecXM=sip.vecX();
				vecYM=sip.vecY();
				vecZM=vecZ;	
				ptCenM= ptCen;	
				dHM=dH;			
			}
			if (vecZ.isParallelTo(vecZM) && abs(vecZM.dotProduct(ptCen-sip.ptCen()))<.5*dHM)
				males.append(sip);
			else
				mapMales.removeAt(i,true);	
		}
		else
			mapMales.removeAt(i,true);	
	}

// post collect males from _Sip to support split actions or linkTool command
	for(int i=0;i<_Sip.length();i++)
	{
		Sip sip = _Sip[i];
		setDependencyOnEntity(sip);
		Vector3d vecZ = sip.vecZ();
		Point3d ptCen=sip.ptCenSolid();
		double dH= sip.dH();		
		if (males.find(sip)<0 && vecZ.isParallelTo(vecZM) && abs(vecZM.dotProduct(ptCen-ptCenM))<.5*dHM)
		{
			males.append(sip);
			mapMales.appendEntity("Male", sip);
		}
	}		
	_Map.setMap("Male[]",mapMales);
	
	
// collect females by _Sip not being male
	Vector3d vecXF, vecYF, vecZF;
	Point3d ptCenF;
	double dHF;
		
	for(int i=0;i<_Sip.length();i++)
	{
		Sip sip = _Sip[i];
		Vector3d vecZ = sip.vecZ();
		Point3d ptCen=sip.ptCenSolid();
		double dH= sip.dH();		
		if (males.find(sip)<0)
		{
			if (vecZF.bIsZeroLength())
			{
				vecZF=vecZ;	
				ptCenF= ptCen;	
				dHF=dH;			
			}
			if (vecZ.isParallelTo(vecZF) && abs(vecZF.dotProduct(ptCen-ptCenF))<.5*dHF)		
				females.append(sip);
		}
	}

// display males and females
	if (bDebug)
	{
		for(int i=0;i<males.length();i++)
			males[i].plEnvelope().vis(1);
		for(int i=0;i<females.length();i++)
			females[i].plEnvelope().vis(2);
		
	}

// determine connection direction		
	Plane pnFemale(ptCenF, vecZF);pnFemale.vis(2);
	Point3d ptX, ptY, ptIntersect;
	double dX=U(10e10);
	double dY=U(10e10);
	{
		Line lnX(ptCenM, vecXM);
		Line lnY(ptCenM, vecYM);
		int bX = lnX.hasIntersection(pnFemale);
		int bY = lnY.hasIntersection(pnFemale);
	
		
		if (bX)
		{
			ptX = lnX.intersect(pnFemale,0);
			ptX.vis(1);
			double d=abs(vecXM.dotProduct(ptCenM-ptX));
			if (d<dX) dX=d;	
		}
		if (bY)
		{
			ptY = lnY.intersect(pnFemale,0);ptY.vis(3);
			double d=abs(vecYM.dotProduct(ptCenM-ptY));
			if (d<dY) dY=d;	
		}
	}

// closest distance sets main direction
	Vector3d vecDir = vecXM;
	if (dY<dX)vecDir = vecYM;
	ptIntersect =Line(ptCenM, vecDir).intersect(pnFemale,0); 
	if (vecDir.dotProduct(ptIntersect -ptCenM)<0) vecDir*=-1;	


// build connection coordSys
	Vector3d vecX, vecY, vecZ;
	vecZ = females[0].vecD(vecDir);
	vecX = vecZM;
	vecY=vecX.crossProduct(-vecZ);vecY.normalize();
	vecX=vecY.crossProduct(vecZ);vecX.normalize();
// if not parallel to world XY make sure the vecYC points upwards
	if (!vecY.isPerpendicularTo(_ZW) && vecY.dotProduct(_ZW)<0)
	{
		vecY*=-1;
		vecX*=-1;
	}

	
	Point3d ptRef = Line(ptCenM, vecDir).intersect(Plane(ptCenF, vecZ), -.5*dHF);
	ptRef.transformBy(vecX*dAxisOffset);
	ptRef.vis(6);
	_Pt0 = Line(_Pt0, vecDir).intersect(Plane(ptCenF, vecZ), -.5*dHF);
	vecX.vis(ptRef,1);vecY.vis(ptRef,3);vecZ .vis(ptRef,150);

// remove duplicates of this scriptinstance
	// by the flag setEraseAndCopyWithBeams the instance is copied every time a panel is splitted. 
	// if the split is done perpendicular to another instance it might result into multiple instances acting on the same edge
	if (!vecDir.bIsZeroLength())
	{
		//if(bDebug)reportMessage("\n"+ _ThisInst.additionalNotes() + " reports...");
		for (int i=0;i<_Sip.length();i++)
		{
			Sip sipThis = _Sip[i];
			Entity entTools[] = sipThis.eToolsConnected();
			//if(bDebug)reportMessage("\n	"+ sipThis.posnum() + " has tools " + entTools.length());
			for (int j=entTools.length()-1;j>=0; j--)
			{
				TslInst tsl = (TslInst)entTools[j];
				if (!tsl.bIsValid() ) continue;
				
				Map map = tsl.map();
				int bNameMatch = tsl.scriptName()==scriptName();
				int bDirMatch = vecDir.isCodirectionalTo(map.getVector3d("vecDir"));
				//version value="1.6" date="18oct17" author="thorsten.huck@hsbcad.com"> bugfix purging 
				int bOffsetMatch = abs(vecX.dotProduct(tsl.ptOrg()-_Pt0))<dXWidth;
				//if(bDebug)reportMessage("\n		j: " + j + " of i " +i+ " " + tsl.handle() + " " + tsl.additionalNotes() );	
				//if(bDebug)reportMessage("\n			bNameMatch  : " + bNameMatch);
				//if(bDebug)reportMessage("\n			same handle: " + (tsl== _ThisInst));
				//if(bDebug)reportMessage("\n			dir match: " + bDirMatch);
				
				if ( tsl!= _ThisInst && bNameMatch  && bDirMatch && bOffsetMatch)
				{
				// compare double properties
					int bMatch=true;
					for (int p=0;p<nDoubleIndex;p++)	if(tsl.propDouble(p)!=_ThisInst.propDouble(p)){bMatch=false;break;}
					if (!bMatch)
					{
						if(bDebug)reportMessage("\n			double properties don't match");
						continue;
					}
				// compare string properties
					for (int p=0;p<nStringIndex;p++)	if(tsl.propString(p)!=_ThisInst.propString(p)){bMatch=false;break;}
					if (!bMatch)
					{
						if(bDebug)reportMessage("\n			string properties don't match");
						continue;
					}					

				// test in line
					if (abs(vecZ.dotProduct(_Pt0-tsl.ptOrg()))>dEps) 
					{
						if(bDebug)reportMessage("\n			not in line" + abs(vecZ.dotProduct(_Pt0-tsl.ptOrg())));
						continue;
					}

				// collect panels of other tool
					GenBeam gbsOthers[] = tsl.genBeam();

				// append panels of the other tool				
					{
						
						for (int p=0;p<gbsOthers.length();p++)
						{
							if (!gbsOthers[p].bIsKindOf(Sip()))
								continue;
							if (_Sip.find(gbsOthers[p])<0)
							{ 
								_Sip.append((Sip)gbsOthers[p]);
							}
						}
								
								
					// erase the other instance
						if (bDebug)reportMessage("\n	" + tsl.handle() + " will be purged");
						tsl.dbErase();
					}
				}	
			}// next j
		}// next i
	}// END IF (!vecDir.bIsZeroLength())



	
// collect potential stretch edges
	Vector3d vecDirTest = vecZ;
	SipEdge edges[0];
	Sip edgeSips[0];
	for(int i=0;i<males.length();i++)
	{
		Sip male = males[i];
		SipEdge maleEdges[]=males[i].sipEdges();
		
	// run second attempt if no edges could be found (this could happen if female panels are rotated after insert)
		for(int k=0;k<2;k++)
		{
			for(int j=0;j<maleEdges.length();j++)
			{
				SipEdge edge = maleEdges[j];
				Vector3d vecNormal = edge.vecNormal();
			// allow any beveled edge as second attempt
				if (k>0)vecNormal=vecNormal.crossProduct(male.vecZ()).crossProduct(-male.vecZ());
				if (vecNormal.isCodirectionalTo(vecDirTest ))
				{
					edges.append(edge);
					edgeSips.append(male);
				}
			}// next j	
			if (edges.length()>0){break;}
			else{vecDirTest=vecDir;}	
		}// next k	
	}
	//vecDirTest.vis(_Pt0,20);
		
// use only extreme edges
	for(int i=0;i<edges.length();i++)
		for(int j=0;j<edges.length()-1;j++)
		{
			double d1=vecDirTest.dotProduct(ptRef-edges[j].ptMid());
			double d2=vecDirTest.dotProduct(ptRef-edges[j+1].ptMid());
			if (d1<d2)
			{
				edges.swap(j,j+1);
				edgeSips.swap(j,j+1);				
			}
		}
	double dMin = U(10e10);
	for(int i=edges.length()-1;i>=0;i--)
	{
		SipEdge edge = edges[i];	
		double d1=vecDirTest.dotProduct(ptRef-edges[i].ptMid());
		if (d1>dMin+dEps)
		{
			edges.removeAt(i);
			edgeSips.removeAt(i);
			continue;	
		}
		else
			dMin = d1;
		//edge.vecNormal().vis(edge.ptMid(),i);
	}	

// set ptStretch and stretch edges
	Point3d ptStretch = ptRef+vecZ*dStretch;
	ptStretch .vis(4);	
	for (int e=0; e<edges.length();e++)
	{
		SipEdge edge = edges[e];
		edge.vecNormal().vis(edge.ptMid(),e);
		if (edgeSips.length()>e)	
			edgeSips[e].stretchEdgeTo(edge.ptMid(),Plane(ptStretch , vecZ));
	}	

// get male envelope body
	Body bdMale;
	for (int i=0; i<males.length();i++)
	{
		bdMale.addPart(males[i].envelopeBody(false,true));
	}
	//bdMale.vis(250);
	
// get female envelope body
	Body bdFemale;
	for (int i=0; i<females.length();i++)
	{
		bdFemale.addPart(females[i].envelopeBody(false,true));
	}		
	//bdFemale.vis(250);


// get min/max female dimensions at connection
	Body bdTest(ptRef, vecX,vecY, vecZ, dXWidth+2*dEps, U(10e3), dZDepth*2,0,0,0);bdTest.vis(1);
	Body bdFemaleTest = bdTest;
	bdFemaleTest.intersectWith(bdFemale);
	//if (nDoveMode==1)
	{
		Body bd=bdFemaleTest;
		bd.transformBy(-vecZ*(bdFemaleTest.lengthInDirection(vecZ)-dEps));
		bdFemaleTest.addPart(bd);	
	}
	bdFemaleTest.vis(3);
	Point3d ptsExtrFemales[] = bdFemaleTest .extremeVertices(vecY);	

	Body bdMaleTest = bdTest;
	bdMaleTest.intersectWith(bdMale);
	//if (nDoveMode==1)
	{
		Body bd=bdMaleTest ;
		bd.transformBy(vecZ*(bdMaleTest .lengthInDirection(vecZ)-dEps));
		bdMaleTest .addPart(bd);	
	}
	bdMaleTest.vis(2);	
	Point3d ptsExtrMales[] = bdMaleTest.extremeVertices(vecY);
	if (ptsExtrMales.length()<1)
	{
		PLine plCirc;
		plCirc.createCircle(_Pt0, vecY, U(50));
		Display dpErr(1);
		dpErr.draw(PlaneProfile(plCirc), _kDrawFilled);
		reportMessage("\n" + scriptName() + ": " +T("|Could not stretch male panel(s)|"));
		return;	
	}
	
	
	
	Body bdCommon = bdFemaleTest;
	bdCommon .intersectWith(bdMaleTest);
	Point3d ptsExtrCommon[] = bdCommon.extremeVertices(vecY);	
	//bdCommon.vis(211);
		
	Point3d ptsExtremes[0];
	ptsExtremes.append(ptsExtrFemales);
	ptsExtremes.append(ptsExtrMales);
	Line lnY(_Pt0, vecY);
	ptsExtremes=lnY.orderPoints(lnY.projectPoints(ptsExtremes));
	Point3d ptMid = _Pt0;
	if (ptsExtremes.length()>0)ptMid=(ptsExtremes[0]+ptsExtremes[ptsExtremes.length()-1])/2;


// test if extremes match
	int bBottomMatch, bTopMatch;
	if (ptsExtrMales.length()>1 && ptsExtrFemales.length()>1)
	{
		bBottomMatch = abs(vecY.dotProduct(ptsExtrMales[0]-ptsExtrFemales[0]))<dEps;
		bTopMatch = abs(vecY.dotProduct(ptsExtrMales[ptsExtrMales.length()-1]-ptsExtrFemales[ptsExtrFemales.length()-1]))<dEps;
	}
		
	
// dove prerequisites
	Vector3d vecXDv = vecX;
	Vector3d vecYDv = vecY;
	Vector3d vecZDv = vecZ;
	double dYHeight = abs(vecYDv.dotProduct(ptsExtremes[0]-ptsExtremes[ptsExtremes.length()-1]));		

	int bIsContinuousMortise = (dAlfa<dEps && dBottomOffset<dEps)?true:false;
	Point3d ptTool = ptRef;

	double dTotalToolLength; // collector for the total tool length to quantify the butterfly spline

// the tool range points
	Point3d ptsTool[0];
	if (nTool==0)
	{
		ptsTool.append(ptsExtremes[0]);
		ptsTool.append(ptsExtrCommon[ptsExtrCommon.length()-1]);
		vecXDv *=-1;
		vecYDv *=-1;
		if (!bTopMatch)bIsContinuousMortise=false;
	}
	else if (nTool==1)
	{		
		ptsTool.append(ptsExtremes[ptsExtremes.length()-1]);ptsTool[0].vis(1);
		ptsTool.append(ptsExtrCommon[0]);
		if (!bBottomMatch)bIsContinuousMortise=false;
	}	
	else if (nTool==2)
	{		
		ptsTool.append(ptsExtremes[ptsExtremes.length()-1]);ptsTool[0].vis(1);
		ptsTool.append(ptsExtremes[0]);
	}	
	dYHeight = abs(vecY.dotProduct(ptsTool[0]-ptsTool[1]));
	ptTool.transformBy(vecYDv*vecYDv.dotProduct(ptsTool[0]-ptRef));	
	ptTool.vis(6);	
	
// male and female dove	
	if (nDoveMode==0 && dXWidth>dEps && dYHeight>dEps && dZDepth>dEps)
	{				
		if (bIsContinuousMortise)	dYHeight*=2;
		Dove dvMale(ptTool,vecXDv,vecYDv,vecZDv,dXWidth,dYHeight-dBottomOffset,dZDepth, dAlfa,_kMaleEnd);
		dvMale.setContinuousMortise(bIsContinuousMortise );
		for (int s=0;s<males.length();s++)
			males[s].addTool(dvMale);

		Dove dvFemale(ptTool,vecXDv,vecYDv,vecZDv,dXWidth,dYHeight-dBottomOffset,dZDepth+dGap, dAlfa,_kFemaleSide);
		dvFemale.setContinuousMortise(bIsContinuousMortise );
		for (int s=0;s<females.length();s++)
			females[s].addTool(dvFemale);				
	}	
	
// butterfly dove
	else if (nDoveMode==1 && dXWidth>dEps && dYHeight>dEps && dZDepth>dEps)
	{
		dTotalToolLength=dYHeight-dBottomOffset; // collector for the total tool length to quantify the butterfly spline
		
		Dove dvMale(ptTool,vecXDv,vecYDv,-vecZDv,dXWidth,dYHeight-dBottomOffset,dZDepth+dGap, dAlfa,_kFemaleEnd);
		dvMale.setContinuousMortise(bIsContinuousMortise);
		for (int s=0;s<males.length();s++)
			males[s].addTool(dvMale);

		Dove dvFemale(ptTool,vecXDv,vecYDv,vecZDv,dXWidth,dYHeight-dBottomOffset,dZDepth+dGap, dAlfa,_kFemaleSide);
		dvFemale.setContinuousMortise(bIsContinuousMortise);
		for (int s=0;s<females.length();s++)
			females[s].addTool(dvFemale);		
	}			

// chamfers
	int nDir=-1;
	double dChamfers[] = {dChamferRef,dChamferOpp};
	Vector3d vecDirChamf = vecZ;
	Vector3d vecXBc= vecY;
	Vector3d vecYBc= vecZM;
	Vector3d vecZBc= vecXBc.crossProduct(vecYBc);

	for (int i=0; i<dChamfers.length(); i++)
	{
		double dChamfer = dChamfers[i];
		//double dGap = dGaps[i];
		if (dChamfer<=dEps)
		{
			//ptTool.transformBy(-vecDirChamf*dOverlap);
			nDir*=-1;
			continue;
		}
		
		Point3d pt = Line(ptMid+nDir*.5*vecZM*dHM, vecDir).intersect(pnFemale,-.5*dHF);
		double dA = sqrt(pow((dChamfer),2)/2);//+.5*dGap
		pt.transformBy(vecDir*-dA);
		//pt.transformBy(vecDirChamf*-nDir*.5* dGap);
		pt.vis(7);
		CoordSys csRot;
		csRot.setToRotation(45*nDir,vecY ,pt);
		
		BeamCut bc(pt ,vecY ,-vecX, vecZ, U(10e4), dChamfer*2 , dChamfer*2 ,0,nDir,1);
		bc.transformBy(csRot);
		bc.cuttingBody().vis(0);
		bc.addMeToGenBeamsIntersect(males);		

		nDir*=-1;
	}// next i

// set hardware when butterfly spline is selected
	if (nDoveMode==1)
	{		
		HardWrComp hwComps[0];
		String sArticle=T("|X-fix L|");

		HardWrComp hw(sArticle, 1);	
		hw.setCategory(T("|Connector|"));
		hw.setManufacturer("Greenethic");
		hw.setModel(sArticle + dZDepth + " x " + dXWidth);
		hw.setMaterial("");
		hw.setDescription(sArticle);
		hw.setDScaleX(dTotalToolLength);
		hw.setDScaleY(dXWidth);
		hw.setDScaleZ(dZDepth*2);	
		hwComps.append(hw);

		_ThisInst.setHardWrComps(hwComps);		
	}
// reset any hardware entry for regular dovetails
	else if (_ThisInst.hardWrComps().length()>0)
	{
		HardWrComp hwComps[0];
		_ThisInst.setHardWrComps(hwComps);
	}




	
// display
	Display dpModel(_ThisInst.color()), dpPanel(_ThisInst.color());
	//dpModel.addHideDirection(vecZ);
	//dpModel.addHideDirection(-vecZ);
	//dpPanel.addViewDirection(vecZ);
	//dpPanel.addViewDirection(-vecZ);

// SYMBOL draw plan view symbol
	Vector3d vecXS = vecX, vecYS=vecZ;
	double dD = U(2);
	Point3d ptRefSym = _Pt0;
	//if (nDoveMode==0)ptRefSym .transformBy(-vecDir*dZDepth);
	if (bDebug)reportMessage("\n" + scriptName() + " vecY" + vecY+ " vecZC: " +vecZ);
// some more vecs
	CoordSys csRot;
	csRot.setToRotation(-14.99, vecY, ptRefSym);
	Vector3d vecAlfa1=vecZ;
	vecAlfa1.transformBy(csRot);	//vecAlfa1.vis(ptRefSym,4);
	csRot.setToRotation(14.99, vecY, ptRefSym);
	Vector3d vecAlfa2=vecZ;
	vecAlfa2.transformBy(csRot);	//vecAlfa2.vis(ptRefSym,4);	

	Plane pnZ(ptRefSym,vecZ);
	PLine plSymbol;
	Point3d ptXS;

	ptXS = ptRefSym-vecXS*.5*dXWidth;						plSymbol.addVertex(ptXS);
	if (Line(ptXS, vecAlfa1).hasIntersection(pnZ))	plSymbol.addVertex(Line(ptXS, vecAlfa1).intersect(pnZ, dZDepth));
	ptXS = ptRefSym+vecXS*.5*dXWidth;
	if (Line(ptXS, vecAlfa2).hasIntersection(pnZ))	plSymbol.addVertex(Line(ptXS, vecAlfa2).intersect(pnZ, dZDepth));
	ptXS = ptRefSym+vecXS*.5*dXWidth;						plSymbol.addVertex(ptXS);

	// offseted symbol
	ptXS = ptRefSym+vecXS*(.5*dXWidth-dD);				plSymbol.addVertex(ptXS);//plSymbol.vis(3);
	plSymbol.addVertex(Line(ptXS, vecAlfa2).intersect(pnZ, dZDepth-dD));
	ptXS = ptRefSym-vecXS*(.5*dXWidth-dD);				plSymbol.addVertex(Line(ptXS, vecAlfa1).intersect(pnZ, dZDepth-dD));
	plSymbol.addVertex(ptXS);
	plSymbol.close();

	PlaneProfile ppSymbol(plSymbol);		
	if (nDoveMode==1)
	{
		CoordSys	csMirr;
		csMirr.setToMirroring(pnZ);	
		PlaneProfile pp = ppSymbol;
		pp.transformBy(csMirr);
		ppSymbol.unionWith(pp);
		ppSymbol.shrink(-dEps);
		ppSymbol.shrink(dEps);
		
	// rebuild from vertices to get filled symbol
		PLine plRings[] = ppSymbol.allRings();
		int bIsOp[] = ppSymbol.ringIsOpening();
		for (int r=0;r<plRings.length();r++)
			if(!bIsOp[r])
			{
				ppSymbol=PlaneProfile(plRings[r]);
				break;	
			}	
		
	// subtract inner
		PlaneProfile ppSub = ppSymbol;
		ppSub.shrink(dD);
		ppSymbol.subtractProfile(ppSub);	
			
	}
	ppSymbol.transformBy(vecZ*dAxisOffset);
	dpModel.draw(ppSymbol,_kDrawFilled);	

// draw a line over tool length
	{
		Point3d pt1 = lnY.closestPointTo(ptsTool[0]);
		Point3d pt2 = lnY.closestPointTo(ptsTool[ptsTool.length()-1]);
		PLine pl(pt1,pt2);
		
		Point3d ptNext = pl.closestPointTo(_Pt0);
		if ((ptNext-_Pt0).length()>dEps)
		{
			_Pt0 = pl.closestPointTo(_Pt0);
			setExecutionLoops(2);	
		}
		dpModel.draw(pl);
			
	}



// store connection vector
	_Map.setVector3d("vecDir", vecDir);
#End
#BeginThumbnail
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
5,&U\.&*\CNI[MY9$.1D5O444`?_9
`





#End