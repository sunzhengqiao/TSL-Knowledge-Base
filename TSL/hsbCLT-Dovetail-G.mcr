#Version 8
#BeginDescription
version value="1.3" date="24may17" author="thorsten.huck@hsbcad.com"
article name of hardware changed to X-fix L

This tsl defines a dove tail connection or a butterfly spline as G-Connection (Mitre) between at least two panels.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords CLT;Dove
#BeginContents
/// <summary Lang=en>
/// This tsl defines a dove tail connection or a butterfly spline as G-Connection (Mitre) between at least two panels.
/// </summary>

/// <insert Lang=en>
/// Select a set of male panels and then a set of female panels.
/// </insert>

/// History
///<version value="1.3" date="24may17" author="thorsten.huck@hsbcad.com"> article name of hardware changed to X-fix L </version>
///<version value="1.2" date="23may17" author="thorsten.huck@hsbcad.com"> article name of hardware changed to XFix-L </version>
///<version value="1.1" date="13jun16" author="thorsten.huck@hsbcad.com"> bugfix, image updated </version>
///<version value="1.0" date="30may16" author="thorsten.huck@hsbcad.com"> initial </version>


// constants
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=projectSpecial().find("debugTsl",0)>-1 || _bOnDebug;
	
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

//// chamfer
	//String sCategoryRef = T("|Reference Side|");
	//String sChamferRefName="(H)  "+T("|Chamfer|");
	//PropDouble dChamferRef(nDoubleIndex++, U(0), sChamferRefName);
	//dChamferRef.setCategory(sCategoryRef);

	//String sCategoryOpp = T("|opposite side|");
	//String sChamferOppName="(I)  "+T("|Chamfer|");
	//PropDouble dChamferOpp(nDoubleIndex++, U(0), sChamferOppName);
	//dChamferOpp.setCategory(sCategoryOpp );

		
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
	

// TriggerFlipDirection
	String sTriggerFlipDirection = T("|Flip Direction|");
	if (nDoveMode==0) // dovetail mode
		addRecalcTrigger(_kContext, sTriggerFlipDirection);	
	
	int bFlipDirection;
	if (_bOnRecalc && (_kExecuteKey==sTriggerFlipDirection || _kExecuteKey==sDoubleClick) )
	{
		if (bDebug)reportMessage("\n" + scriptName() + ": " +T("|executing|") + " " + sTriggerFlipDirection + " loop " + _kExecutionLoopCount);
		dStretch = 0;
		setExecutionLoops(2);
		bFlipDirection=true;
	}

	
// set copy behavior
	setEraseAndCopyWithBeams(_kBeam0);
		
// collect males and females	
	Map mapMales = _Map.getMap("Male[]");
	if (mapMales.length()<1)
	{
		if(bDebug)reportMessage("\n"+ scriptName() + " Invalid orientation data");
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
		
		if (vecZM.bIsZeroLength())
		{
			vecXM=sip.vecX();
			vecYM=sip.vecY();
			vecZM=vecZ;	
			ptCenM= ptCen;	
			dHM=dH;			
		}		
	
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
	if (Line(ptCenM, vecDir).hasIntersection(pnFemale))
		ptIntersect =Line(ptCenM, vecDir).intersect(pnFemale,0); 
	else
	{
		if(bDebug)reportMessage("\n"+ scriptName() + " no inter " + _kExecutionLoopCount);

	}

	if (vecDir.dotProduct(ptIntersect -ptCenM)<0) vecDir*=-1;	
	vecDir.vis(ptIntersect,6);

// get female connection (direction) vector
	//Quader qdrFemale(females[0].ptCenSolid(), females[0].vecX(),females[0].vecY(),females[0].vecZ(),females[0].solidLength(), females[0].solidWidth(), females[0].solidHeight(),0,0,0); 
	{
		vecXF = females[0].vecX();
		vecYF = females[0].vecY();

		if (abs(vecYF.dotProduct(vecZM))> abs(vecXF.dotProduct(vecZM)))
		{
			vecYF = females[0].vecX();
			vecXF = females[0].vecY();			
		}
		if (vecXF.dotProduct(ptIntersect-ptCenF)<0)
			vecXF*=-1;
		vecYF = vecXF.crossProduct(-vecZF);
		vecXF .vis(ptIntersect,1);	
		vecYF .vis(ptIntersect,3);			
	}
	
	
	Vector3d vecDirFemale = vecXF;//-vecDir.crossProduct(vecZF).crossProduct(-vecZF);
	vecDirFemale.normalize();
	vecDirFemale.vis(ptIntersect,4);

// build connection coordSys
	Vector3d vecX, vecY, vecZ;
	vecY=vecDir.crossProduct(-vecZM);vecY.normalize();	
// if not parallel to world XY make sure the vecYC points upwards
	if (!vecY.isPerpendicularTo(_ZW) && vecY.dotProduct(_ZW)<0)
	{
		vecY*=-1;
		vecX*=-1;
	}
	vecX = vecDir+vecDirFemale;
	vecX.normalize();
	vecZ = vecX.crossProduct(vecY);
	vecX.vis(ptIntersect,1);vecY.vis(ptIntersect,3);vecZ .vis(ptIntersect,150);
	
	if (vecZ.dotProduct(vecDir)<0)
	{
		vecX*=-1;
		vecZ*=-1;	
	}
	
// make sure that connection is not twisted
	if (!vecZF.isPerpendicularTo(vecY))
	{
		reportMessage(TN("|Twisted connections are not supported.|"));
		eraseInstance();
		return;
	
	}

	
	Point3d ptRef = ptIntersect ;
	ptRef.transformBy(vecX*dAxisOffset);
	ptRef.vis(6);
	
	Line lnRef(ptRef, vecY);
	_Pt0 = Line(lnRef.closestPointTo(_Pt0), vecDir).intersect(Plane(ptRef, vecZ), 0);
	

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
				//if(bDebug)reportMessage("\n		j: " + j + " of i " +i+ " " + tsl.handle() + " " + tsl.additionalNotes() );	
				//if(bDebug)reportMessage("\n			bNameMatch  : " + bNameMatch);
				//if(bDebug)reportMessage("\n			same handle: " + (tsl== _ThisInst));
				//if(bDebug)reportMessage("\n			dir match: " + bDirMatch);
				
				if ( tsl!= _ThisInst && bNameMatch  && bDirMatch)
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

				// append panels of the other tool				
					{
						GenBeam gbsOthers[] = tsl.genBeam();
						for (int p=0;p<gbsOthers.length();p++)
							if (_Sip.find(gbsOthers[p])<0 && gbsOthers[p].bIsKindOf(Sip()))
								_Sip.append((Sip)gbsOthers[p]);
								
					// erase the other instance
						if (bDebug)reportMessage("\n	" + tsl.handle() + " will be purged");
						tsl.dbErase();
					}
				}	
			}// next j
		}// next i
	}// END IF (!vecDir.bIsZeroLength())
	
	
// collect potential stretch edges
	SipEdge maleEdges[0],femaleEdges[0];
	Sip sips[0];
	Vector3d vecDirTest = vecZ;	


// loop twice to collect male and female edges
	sips = males;
	for(int x=0;x<2;x++)
	{
		Sip edgeSips[0];
		SipEdge edges[0];
		
		for(int i=0;i<sips .length();i++)
		{
			Sip sip = sips [i];
			SipEdge thisEdges[]=sip.sipEdges();
			
		// run second attempt if no edges could be found (this could happen if female panels are rotated after insert)
			for(int k=0;k<2;k++)
			{
				for(int j=0;j<thisEdges.length();j++)
				{
					SipEdge edge = thisEdges[j];
					Vector3d vecNormal = edge.vecNormal();
				// allow any beveled edge as second attempt
					if (k>0)vecNormal=vecNormal.crossProduct(sip.vecZ()).crossProduct(-sip.vecZ());
					if (vecNormal.isCodirectionalTo(vecDirTest))
					{
						edges.append(edge);
						edgeSips.append(sip);
					}
				}// next j	
				if (edges.length()>0){break;}
				else if(x==0){vecDirTest=vecDir;}
				else if(x==1){vecDirTest=vecDirFemale;}	
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
			edge.vecNormal().vis(edge.ptMid(),i);
		}
		
	// set ptStretch and stretch edges
		Point3d ptStretch = ptRef;
		if (x==0 && nDoveMode == 0)ptStretch.transformBy(vecZ*dStretch);
		ptStretch .vis(4);	
		for (int e=0; e<edges.length();e++)
		{
			SipEdge edge = edges[e];
			edge.vecNormal().vis(edge.ptMid(),e);
			if (edgeSips.length()>e)	
				edgeSips[e].stretchEdgeTo(edge.ptMid(),Plane(ptStretch , vecZ));
		}			

		sips = females;
		vecDirTest = -vecZ;	
	}// next x male/female	

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
	//bdFemaleTest.vis(3);
	Point3d ptsExtrFemales[] = bdFemaleTest .extremeVertices(vecY);	

	Body bdMaleTest = bdTest;
	bdMaleTest.intersectWith(bdMale);
	//if (nDoveMode==1)
	{
		Body bd=bdMaleTest ;
		bd.transformBy(vecZ*(bdMaleTest .lengthInDirection(vecZ)-dEps));
		bdMaleTest .addPart(bd);	
	}
	//bdMaleTest.vis(2);	
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

//// chamfers
	//Plane pnMitre(ptRef, vecZ);
	//int nDir=-1;
	//double dChamfers[] = {dChamferRef,dChamferOpp};
	//Vector3d vecDirChamf = vecZ;
	//Vector3d vecXBc= vecY;
	//Vector3d vecYBc= vecY.crossProduct(-vecDir);
	//Vector3d vecZBc= vecDir;

	//for (int i=0; i<dChamfers.length(); i++)
	//{
		//double dChamfer = dChamfers[i];
		////double dGap = dGaps[i];
		//if (dChamfer<=dEps)
		//{
			////ptTool.transformBy(-vecDirChamf*dOverlap);
			//nDir*=-1;
			//continue;
		//}
		
		//Point3d pt = Line(ptMid+nDir*.5*vecZM*dHM, vecDir).intersect(pnMitre,0);
		//double dA = sqrt(pow((dChamfer),2)/2);
		////+.5*dGap
		////pt.transformBy(vecDir*-dA);
		////pt.transformBy(vecDirChamf*-nDir*.5* dGap);
		//pt.vis(7);
		//CoordSys csRot;
		//csRot.setToRotation(45*nDir,vecY ,pt);
		
		//BeamCut bc(pt ,vecY,vecX, vecZ, U(10e4), dChamfer , dChamfer ,0,-nDir,-1);
		//bc.transformBy(csRot);
		//bc.cuttingBody().vis(0);
		//bc.addMeToGenBeamsIntersect(males);		

		//nDir*=-1;
	//}// next i

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
	//ppSymbol.transformBy(vecX*dAxisOffset);
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

// if direction is flipped switch panels and vecDir
	if (bFlipDirection)
	{
		vecDir*=-1;	
		mapMales=Map();
		for(int i=0;i<females.length();i++)
			mapMales.appendEntity("male",females[i]);
		if (bDebug)reportMessage("\n" + scriptName() + ": females stored as males (" + mapMales.length()+") vecDir: " +vecDir);

		_Map.setMap("Male[]", mapMales);
	}

// store connection vector
	_Map.setVector3d("vecDir", vecDir);



	
#End
#BeginThumbnail
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
B;)Y4-W&T8X!:NCHH`YR#0KY]1BO+V[5VC.<`5T=%%`'_V1VR
`



#End