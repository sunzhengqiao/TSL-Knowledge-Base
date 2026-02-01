#Version 8
#BeginDescription
This tsl converts a given 3DSolid into an hsbPanel

version  value="1.1" date="28feb12" author="th">
conversion of curved beams supported, free aligned drills conversion supported

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl converts a given 3DSolid into an hsbPanel
/// When inserted the user flip, rotate and reassign the panel direction. Also the common text fields can be set
/// by selecting a Text in hsbCAD
/// </summary>

/// <insert Lang=en>
/// Select one or multiple 3DSolids
/// </insert>


///<version  value="1.1" date="28feb12" author="th">conversion of curved beams supported, free aligned drills conversion supported</version>
/// Version 1.0   th@hsbCAD.de   25.05.2011
/// initial


// basics and props
	U(1,"mm");
	double dEps(U(0.1));
	
// debug flags	
	int nDebug;		
	
// properties	
	String sPropS0 = T("|Conversion Strategy|");
	String sPropD0 = T("|max Segment Length|");
	String sArDescr[0];
	sArDescr.append(T("|Sets the conversion strategy which determines the main axis system of the solid.|"));	
	sArDescr.append(T("|Sets the style of the conversion.|") + " " + T("|The style must match the thickness of the solid.|") + " " + T("|If multiple styles match the thickness the automatic detection will not function and the TSL will prompt the user has to set the style.|"));
	sArDescr.append(T("|Sets the conversion tolerance of facettes to bulges.|") + " " + T("|Smaller values increase accuracy but might skip segments to be converted|"));
	
	
	String sArStrategy[] = {T("|Wall|") + " 3D", T("|Wall|") + " " + T("|WCS XY|"), T("|X-Axis|"), T("|Y-Axis|")};
	String sArStyle[0];
	double dArThickness[0];	
	sArStyle.append(T("|Auto|"));	
	dArThickness.append(0);
	sArStyle.append(SipStyle().getAllEntryNames());
	// order style names
	for(int i=1;i<sArStyle.length();i++)
		for(int j=1;j<sArStyle.length()-1;j++)
			if (sArStyle[j]>sArStyle[j+1])
				sArStyle.swap(j,j+1);	

	for(int i=1;i<sArStyle.length();i++)
	{
		SipStyle style (sArStyle[i]);
		dArThickness.append(style.dThickness());
	}			
				
	PropString sStyle(1, sArStyle, T("|Panel Style|"));	
	sStyle.setDescription(sArDescr[1]);

		
// declare the tsl props
	TslInst tslNew;
	Vector3d vUcsX = _XW;
	Vector3d vUcsY = _YW;
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
		PropString sStrategy(0, sArStrategy,sPropS0 );
		sStrategy.setDescription(sArDescr[0]);	
		PropDouble dSegmentToArcLength(0, U(50), sPropD0);
		dSegmentToArcLength.setDescription(sArDescr[2]);	
		showDialog();
		
	// get selection set
		PrEntity ssE(T("|Select solids|"), Entity());
		Entity ents[0];
		if (ssE.go())
			ents = ssE.set();

	// create single conversion instances based on the beam		
		mapTsl.setInt("addTools",1);// make sure the tools will be added
		
	// loop entities and assign or convert		
		for (int e=0;e<ents .length();e++)
		{
			Beam bm;
			if (ents[e].bIsKindOf(Beam()))
			{
				bm =(Beam)ents[e];
			}			
			else if (ents[e].realBody().volume() > pow(U(1),3))
				bm.dbCreate(ents[e].realBody());	
			if (bm.bIsValid())
			{
				gbAr[0]=bm;
				ptAr[0] = bm.ptCenSolid();
				vUcsX = bm.vecX();
				vUcsY = bm.vecY();
				tslNew.dbCreate(sScriptname, vUcsX,vUcsY,gbAr, entAr, ptAr, 
					nArProps, dArProps, sArProps,_kModelSpace, mapTsl); // create new instance		
				if (tslNew.bIsValid())
					tslNew.setPropValuesFromCatalog(T("|_LastInserted|"));				
			}
		}

		
	// erase the caller	
		eraseInstance();
		return;	
		
	}	
// end on insert	
// ______________________________________________________________________________________________________________________________________
		




// on mapIO ________________________  mapIO ________________________  mapIO ________________________  mapIO ________________________ 
	// convertes a given pline to a pline with bulges, derived from mapIO_GtArcedPLine
	if (_bOnMapIO)
	{
		double dMaxSegLength=U(50);
		int bReportDebug =0;
		PLine plEnvelope;

		bReportDebug  = _Map.getInt("reportDebug");
		plEnvelope = _Map.getPLine("pline");
		if (_Map.hasDouble("MaxSegLength"))
			dMaxSegLength=_Map.getDouble("MaxSegLength");

		if(bReportDebug)
		{
			reportMessage("\nConversion started...");	
			reportMessage("\n   max segment length	" + dMaxSegLength);	
			reportMessage("\n   vertices	" + plEnvelope.vertexPoints(true).length());
		}	
	
	// profile and vec	
		Vector3d vz = plEnvelope.coordSys().vecZ();
		PlaneProfile pp(plEnvelope);
		PLine plRecompose = plEnvelope;
		
	// the vertices
		Point3d ptEnv[] = plEnvelope.vertexPoints(true);	
		int nMax = ptEnv.length();
		
	// the display	
		Display dp(0);
	
	// potential recomposing the pline to retrieve arcs and straight segments
		int nAddMode[ptEnv.length()]; // 0 = not set, 1= straight, 2=start point , 3= on arc, 4=end point, 5 start and end point on alternating arcs
		int bArConcave[ptEnv.length()];
		int bAddArc;

	// conversion is only done for plines with at least 5 vertices
		int n;
		if (ptEnv.length()>4)
		{
		// flag if it has arcs
			int bHasArc;	
			
		// flag if circle
			int bIsCircle=true;		
			
		// flag if previous segment was an arc
			int bPreviousIsArc;
			
			
			for (int i=0;i<nMax;i++)			
			{
				
			// looking back three segments
				Point3d ptX[0], ptMid[0];
				Vector3d vxSeg[0];
				double dLSeg[0];
				
				Point3d pt0,pt1,pt2,pt3;
																ptX.append(ptEnv[i]);
				n = i-1;		if (n<0)	n = nMax+n;		ptX.append(ptEnv[n]);
				n = i-2;		if (n<0)	n = nMax+n;		ptX.append(ptEnv[n]);
				n = i-3;		if (n<0)	n = nMax+n;		ptX.append(ptEnv[n]);			
	
			// get segments vecs and length
				int bValidLength=true;
				for (int p=1;p<4;p++)
				{
					ptMid.append((ptX[p-1]+ptX[p])/2);
					//ptMid[p-1].vis(p);
					Vector3d vxTemp = ptX[p-1]-ptX[p];
					if (vxTemp.length()>dMaxSegLength) bValidLength=false ;
					vxTemp.normalize();
					vxSeg.append(vxTemp);	
				}
	
			// create a temp arc
				PLine plArcTest(vz);
				plArcTest.addVertex(ptX[0]);
				plArcTest.addVertex(ptX[3],ptX[2]);
				if (i==37)plArcTest.vis(4);			
				
				
			// test if all on arc
				double dClosest = (plArcTest.closestPointTo(ptX[1])-ptX[1]).length();
	
			// test middle segment: if distance of midpoints is a lot bigger than other mid distance it is convex hull of an eight
				int bDebugMid=1;
				double dMid1 = (plArcTest.closestPointTo(ptMid[0])-ptMid[0]).length();
				double dMid2 = (plArcTest.closestPointTo(ptMid[1])-ptMid[1]).length();
				double dMid3 = (plArcTest.closestPointTo(ptMid[2])-ptMid[2]).length();			
				double dMidAverage = (dMid1+dMid2+dMid3)/3 + dEps;
	
				//if (bDebugMid) reportNotice("\ni="+i+ " dMid1=" + dMid1+ " dMid2 " + dMid2+ " dMid3=" + dMid3 + " average="+dMidAverage);
				
					
			// test and store previous segment direction, convex/concave
				Vector3d vxMitre = vxSeg[1]-vxSeg[0];	vxMitre.normalize();
				vxMitre.vis(ptX[1],1);
					
				n = i-1;		if (n<0)	n = nMax+n;	
				bArConcave[n] = pp.pointInProfile(ptX[1]+vxMitre*dEps)==_kPointInProfile;
	
			// collect node types
				int bDebugTypes = 0;
			// arced	
				if(abs(dClosest)<dEps && bValidLength && dMid2<dMidAverage)
				{
					if (i==37)	PLine(ptEnv[i],ptEnv[i]+(_XW+_YW)*U(200)).vis(5);
					bHasArc=true;
				// start point
					if (!bPreviousIsArc)
					{
						n = i-3;
						if (n<0)	n = nMax+n;
						if (nAddMode[n]==4)
							nAddMode[n] = 5;
						else
							nAddMode[n] = 2;
						if (bDebugTypes) ptEnv[n].vis(nAddMode[n]);						
					}				
					
				// on arc
					n = i-2;
					if (n<0)	n = nMax+n;
					nAddMode[n] = 3;
					if (bDebugTypes) ptEnv[n].vis(nAddMode[n]);	
				
				// on arc
					n = i-1;
					if (n<0)	n = nMax+n;
					nAddMode[n] = 3;
					if (bDebugTypes) ptEnv[n].vis(nAddMode[n]);	
				
				// end point
					n = i;
					if (nAddMode[n]==2)
						nAddMode[n] = 5;
					else if (i==nMax-1 && nAddMode[0]==3)
						nAddMode[n] = 3;				
					else
						nAddMode[n] = 4;
														
					if (bDebugTypes) ptEnv[n].vis(nAddMode[n]);	
	
				
				
				// flag arc mode
					if(!bPreviousIsArc)
						bPreviousIsArc= true;
		
				}
				else if (bPreviousIsArc)
				{				
					bPreviousIsArc=false;				
				}
			//straight
				else
				{
					n = i-3;
					if (n<0)	n = nMax+n;
					if (nAddMode[n]==0)
						nAddMode[n] = 1;
					if (bDebugTypes) ptEnv[n].vis(nAddMode[n]);
				}	
				
				//if (bPreviousIsArc)			
				//	plArcTest.vis(bArConcave[n]);	
			}
		
		// override if last and first mode are of type 4
			if (nAddMode[nMax-1]==4 && nAddMode[0]==4)
				nAddMode[nMax-1]=3;
	
		
		// declare a map which stores potential center points and chord
			Map mapArcs;
		
		// if it has an arc start converting
			if (bHasArc)
			{
				if(bReportDebug)
				{
					reportMessage("\arc detected...");
				}			
				
				
				Map mapArc;
			// the pline could have multiple arcs and straight segments. need to find a start point of conversion to
			// make sure that one arc is not converted to two arcs ... or it is an circle
				int nStartIndex; 		
				for (int i=0;i<nMax;i++)			
				{	
				// not a circle
					if (nAddMode[i]==1 || nAddMode[i]==2)
						bIsCircle=false;	
					if (nAddMode[i]==2)
						nStartIndex=i;	
					//ptEnv[i].vis(nAddMode[i]);
				
				}// next i
		
				
			// circle
				if (bIsCircle)
				{
					dp.color(1);
					Point3d ptCen;
					ptCen.setToAverage(ptEnv);
					double dRadius = Vector3d (ptEnv[0]-ptCen).length();
					plRecompose.createCircle(ptCen, vz, dRadius);
	
					mapArc.setPoint3d("ptChord", ptEnv[0]);
					mapArc.setPoint3d("ptCenter", ptCen);
					mapArc.setPLine("arc",plRecompose);
					mapArcs.appendMap("arc", mapArc);
				}
			// not a circle
				else
				{
					dp.color(3);
					plRecompose = PLine(vz);
					Point3d ptStartArc;
					for (int i=nStartIndex;i<(nMax+nStartIndex);i++)
					{
						n = i;
						if (n<0)	
							n = nMax+n;
						else if (n>nMax-1)
							n = n-nMax;
	
						int m = i-1;
						if (m<0)	
							m = nMax+m;
						else if (m>nMax-1)
							m = m-nMax;
						
					// add first
						if (n==nStartIndex)
						{
							ptStartArc=ptEnv[n];
							plRecompose.addVertex(ptStartArc);
						}
					// add end point
						else if(nAddMode[n]==4 || nAddMode[n]==5)
						{
							Point3d ptEndArc=ptEnv[n];
							plRecompose.addVertex(ptEndArc,ptEnv[m]);	
							
						// get center of arc				
							PLine plArc(vz);
							plArc.addVertex(ptStartArc);
							plArc.addVertex(ptEndArc,ptEnv[m]);		
							//plArc.vis(i);
							
							double dLArc = plArc.length();
							Point3d pt1 = plArc.getPointAtDist(dEps);
							Point3d pt2 = plArc.getPointAtDist(dLArc-dEps);
							Vector3d vxC = pt1-ptStartArc;	vxC.normalize();
							Line ln((pt1+ptStartArc)/2, vxC.crossProduct(vz));
							vxC = pt2-ptEndArc;					vxC.normalize();
							Plane pn((pt2+ptEndArc)/2, vxC);
							if (ln.hasIntersection(pn))
							{
								Point3d ptCen = ln.intersect(pn,0);
								vxC = plArc.ptMid()-ptCen;			vxC.normalize();
								Point3d pt[] = plArc.intersectPoints(Plane(ptCen,vxC.crossProduct(vz)));
								Point3d ptOnArc = plArc.closestPointTo(plArc.ptMid());
								if (pt.length()>0)
									ptOnArc = pt[0];
								ptCen.vis(i); 
								ptOnArc.vis(222);	
				
							// append chord and center points to global arrays
								mapArc.setPoint3d("ptChord", ptOnArc);
								mapArc.setPoint3d("ptCenter", ptCen);
								mapArc.setPLine("arc",plArc);
								mapArcs.appendMap("arc", mapArc);
	
							}						
							
							// if start and end fall in one
							if(nAddMode[n]==5)
								ptStartArc=ptEndArc;
							
						}			
					// add straight point
						else if((nAddMode[n]==2 ) || nAddMode[n]==1)//&& nAddMode[m]==4
						{
							if(nAddMode[n]==2)ptStartArc=ptEnv[n];
							plRecompose.addVertex(ptEnv[n]);	
						}
						
						
					//plRecompose.vis(i);	
					}
				}// not a circle but with arcs	
				_Map.setMap("Arc[]",mapArcs);
			}// end converting
			
		}// endif has min 4 vertices	
		plRecompose.close();
		dp.draw(plRecompose);
		_Map.setPLine("pline",plRecompose);	
		return;			
		
	}		
// END on mapIO ________________________  mapIO ________________________  mapIO ________________________  mapIO ____________________		
		


	if (_bOnDbCreated)setExecutionLoops(2);

// redefine property
	sArStrategy.append(T("|User defined|"));
	PropString sStrategy(0, sArStrategy,sPropS0 );
	sStrategy.setDescription(sArDescr[0]);	
	PropDouble dSegmentToArcLength(0, U(50), sPropD0);
	dSegmentToArcLength.setDescription(sArDescr[2]);	
		
// get basic ref beam
	if (_Beam.length()<1)
	{
		eraseInstance();
		return;					
	}		
	Beam bm = _Beam[0];
	Quader qdr = bm.quader();
	Body bd = bm.realBody();

	
	
	
// Standards
	Vector3d vx,vy, vz;
	vx = bm.vecX();
	vy = bm.vecY();
	vz = bm.vecZ();
		
	double dX = bm.solidLength();
	double dY = bm.solidWidth();
	double dZ = bm.solidHeight();	
			
	//vx.vis(_Pt0,1);
	//vy.vis(_Pt0,3);
	//vz.vis(_Pt0,150);			

// ints
	int nStrategy=sArStrategy.find(sStrategy);	
	// 0 - Wall 3D			: the source object is drawn in WCS 3D with wall alignment
	// 1 - Wall WCS XY	: the source object is drawn in WCS XY plGrainane where Y-World describes the height of the wall
	// 2 - Greatest equals X: the greatest dimension expresses the X-Axis. This is not unique to all cases, user will be alerted in case of X==Y
	// 3 - Greatest equals Y: the greatest dimension expresses the Y-Axis. This is not unique to all cases, user will be alerted in case of X==Y
	// 4 - user defined
	int nStyle = sArStyle.find(sStyle);
	int bAddTools = _Map.getInt("addTools");
	
// build sip coordSys, default is beam coordSys
	Vector3d vxSip=vx, vySip=vy, vzSip=vz;


// property change event
	if (_kNameLastChangedProp== sPropS0 && nStrategy==4 && !_Map.hasVector3d("vxSip"))
		reportNotice("\n" + T("|Please specify the X-Axis by using the context command|"));
	if (_kNameLastChangedProp== sPropD0)
	{
		bAddTools =true;
		_Map.setInt("addTools", bAddTools);
		if (_Sip.length()>0)
		{
			_Sip[0].dbErase();		
		}
			
	}
		
// add triggers
	String sTrigger[] = {T("|Flip Reference Side|"),
								T("|Rotate X-Axis 90°|"),
								T("|Flip Reference Side|") + " + "+ T("|Rotate X-Axis 90°|"), 
								T("|Set X-direction|"),
								"----------------------", 
							   T("|Set Name by Text|"),
								T("|Set Label by Text|"),
								T("|Set Sublabel by Text|"),
								T("|Set Information by Text|")};
	for (int i = 0; i < sTrigger.length(); i++)
		addRecalcTrigger(_kContext, sTrigger[i]);	

// trigger 0||2: T("|Flip Reference Side|")
	if (_bOnRecalc && (_kExecuteKey==sTrigger[0] || _kExecuteKey==sTrigger[2]))
	{
		int nFlip = _Map.getInt("flipDir");
		if (nFlip==0) nFlip=1;
		nFlip*=-1;
		_Map.setInt("flipDir",nFlip);
		for (int i=_Sip.length()-1;i>=0;i--)
			_Sip[i].dbErase();
		_Sip.setLength(0);
		_Map.setInt("addTools",1);// flag the tools to be added again
	}
// trigger 1||2: T("|Rotate X-Axis 90°|")
	if (_bOnRecalc && (_kExecuteKey==sTrigger[1] || _kExecuteKey==sTrigger[2]))
	{
		int bRotate = _Map.getInt("rotate");
		if (bRotate)
			bRotate =false;
		else
			bRotate = true;
		_Map.setInt("rotate",bRotate );
		if (_Sip.length()>0)
		{
			_Sip[0].dbErase();
			_Sip.setLength(0);
			_Map.setInt("addTools",1);// flag the tools to be added again
		}
	}
// trigger 3: Set X-Direction

	if (_bOnRecalc && _kExecuteKey==sTrigger[3])
	{
		Vector3d vxUser, vzTmp;
		vzTmp= _Map.getVector3d("vzSip");
		PrPoint ssPBase("\n" + T("|Select base point in x-direction|")); 
		Point3d ptBase = _Pt0;
		if (ssPBase.go()==_kOk) 
			ptBase = ssPBase.value();
		
		
		ptBase.transformBy(vzTmp*vzTmp.dotProduct(_Pt0-ptBase));
				
		PrPoint ssP("\n" + T("|Select next point in x-direction|"),ptBase); 
		if (ssP.go()==_kOk) 
		{ // do the actual query
			Point3d ptLast = ssP.value(); // retrieve the selected point
			ptLast .transformBy(vzTmp*vzTmp.dotProduct(_Pt0-ptLast));
			vxUser= ptLast-ptBase;
			if (!vxUser.bIsZeroLength())
			{
				vxUser.normalize();	
				_Map.setVector3d("vxSip",vxUser);
				nStrategy=4;
				sStrategy.set(sArStrategy[nStrategy]);	
									
				if (_Sip.length()>0)
				{
					_Sip[0].dbErase();
					_Sip.setLength(0);
					_Map.setInt("addTools",1);// flag the tools to be added again
				}				
			}
		}		
	}
// trigger 4: Empty
	if (_bOnRecalc && _kExecuteKey==sTrigger[4])
	{
		//reportNotice("\n" + _kExecuteKey + " not implemented");
	}	
	
	


// Display Grain 
	Display dp(1);
	dp.textHeight(U(40));


// validate if derived from a curved style
	int bFromCurvedStyle;
	CurvedStyle curvedStyle(bm.curvedStyle());
	if (curvedStyle.entryName()!=_kStraight)bFromCurvedStyle=true;
	if (bFromCurvedStyle)
	{
		vxSip = vx;
		vySip = vz;		
		vzSip = -vy;	
	}
	
// case wall 3d
	else if (nStrategy==0)
	{
		vxSip = 	qdr.vecD(_ZW);
		double dA = qdr.dD(_XW);
		double dB = qdr.dD(_YW);
		if (dB<dA)	vzSip = qdr.vecD(_YW);
		else			vzSip = qdr.vecD(_XW);
		
	}
// case Wall WCS XY
	else if (nStrategy==1)
	{
		vxSip = 	_YW;
		vzSip = 	_ZW;
	}
// case Wall WCS XY
	else if (nStrategy==1)
	{
		vxSip = 	_XW;
		vzSip = 	_ZW;
	}
// case Greatest equals X
	else if (nStrategy==2)
	{
		vxSip = vx;
		if (dY>dZ)	vzSip = vz;
		else vzSip = vy;
	}
// case Greatest equals Y
	else if (nStrategy==3)
	{
		vySip = vx;
		if (dY>=dZ)	vxSip = vy;
		else if (dZ>=dY)	vxSip = vz;
		vzSip = vxSip.crossProduct(vySip);
	}		

// case user defined
	else if (nStrategy==4)
	{
		vxSip = 	_Map.getVector3d("vxSip");
		vzSip = 	_Map.getVector3d("vzSip");
	}
	
// rotate X
	if (_Map.getInt("rotate"))
	{
		CoordSys cs;
		cs.setToRotation(90,vzSip,_Pt0);
		vxSip.transformBy(cs);
	}
// flip Z			
	if (_Map.getInt("flipDir")==-1)
		vzSip*=-1;
		
	vySip = vxSip.crossProduct(-vzSip);
	vxSip.vis(_Pt0+ _ZW * U(100),1);
	vySip.vis(_Pt0+ _ZW * U(100),3);
	vzSip.vis(_Pt0+ _ZW * U(100),150);			

// box dimensions
	double dXSip = qdr.dD(vxSip);
	double dYSip = qdr.dD(vySip);
	double dZSip = qdr.dD(vzSip);		

// conversion log
	String sArLog[0];

// find matching style(s)
	if (nStyle==0)
	{
		int nCnt;
		int nMyStyle=-1;
		for (int i=1;i<dArThickness.length();i++)
		{
			if (abs(dArThickness[i]-dZSip)<=dEps)
			{
				nMyStyle=i;
				nCnt++;
			}	
		}
		if (nCnt>1)
			sArLog.append(nCnt + " " + T("|ambiguos styles detected|"));
		else if (nMyStyle>-1 && nCnt>0)
			sStyle.set(sArStyle[nMyStyle]);		
	}


// ref side
	Point3d ptRef = bm.ptCenSolid()-vzSip*.5*dZSip;
	ptRef.vis(1);
	Plane pn(ptRef,vzSip);

// get tools from dummy beam
	AnalysedTool tools[] = bm.analysedTools();
	AnalysedBeamCut abc[] = AnalysedBeamCut().filterToolsOfToolType(tools);
	AnalysedCut cuts[] = AnalysedCut().filterToolsOfToolType(tools);
	AnalysedDrill drills[] = AnalysedDrill().filterToolsOfToolType(tools);
	
	
// get a shadow and pp's of every side 
	PlaneProfile ppEnvelope,ppEnvelopeOpp, ppShadow ; 
	ppEnvelope =  bd.extractContactFaceInPlane(pn,dEps);
	ppEnvelopeOpp= bd.extractContactFaceInPlane(Plane(ptRef+vzSip*dZSip,-vzSip),dEps);
	
	
	ppShadow = ppEnvelope;
	ppShadow.unionWith(ppEnvelopeOpp);
	//ppEnvelope.vis(0);
	//ppEnvelopeOpp.vis(1);
	ppShadow.vis(2);

	
// display the grain direction	
	PLine plGrain(vzSip);
	double dLL = U(200);
	plGrain.addVertex(ptRef + (vxSip*.5*dLL - vySip*dLL/5));
	plGrain.addVertex(ptRef + (vxSip*dLL));	
	plGrain.addVertex(ptRef + (-vxSip*dLL));	
	plGrain.addVertex(ptRef + (-vxSip*.5*dLL + vySip*dLL/5));	
	dp.draw(plGrain);	

// declare the sip and determine if the tsl execution is silent = only display grain direction character
	Sip sip;
	if (_Sip.length()>0)
		sip = _Sip[0];
	else
		 _Map.setInt("silent",false);
	int bSilent;
	bSilent = _Map.getInt("silent");


// trigger 5-8: xxx by Text
	int nByText = sTrigger.find(_kExecuteKey);
	if (_bOnRecalc && (nByText >=5 && nByText <=8))
	{
		PrEntity ssTxt("Text wählen", Entity());
		String sTxt;
		while (sTxt=="" && ssTxt.go())
		{
			Entity entsTxt[] = ssTxt.set();
			for (int t=0;t<entsTxt.length();t++)
			{
				if (entsTxt[t].typeDxfName()=="TEXT")	
				{
					entsTxt[t].attachPropSet("hsbText");
					Map map = entsTxt[t].getAttachedPropSetMap("hsbText");	
					sTxt = map.getString("Text");
					
					break;
				}
			}
			if (nByText==5)sip.setName(sTxt);
			else if (nByText==6)sip.setLabel(sTxt);
			else if (nByText==7)sip.setSubLabel(sTxt);
			else if (nByText==8)sip.setInformation(sTxt);
			
			if (ssTxt.set().length()<1)break;
		}
	}	


// enhance performance, stopp here if no geometry changes apply
	//if (bSilent)return;
	
// decalre ring arrays
	PLine plRings[0];
	int bIsOp[0];

// recreate a shadow body
	PLine plShadow;
	PLine plEnvelope;
	if (!bFromCurvedStyle)
	{
		plRings=ppShadow.allRings();
		bIsOp= ppShadow.ringIsOpening();
		for(int r=0;r<plRings.length();r++)
			if (!bIsOp[r] && plShadow.area()<plRings[r].area())
				plShadow=plRings[r];	
				
				
				
				
		Body bdShadow(plShadow, vzSip*dZSip,1);
		bdShadow.vis(4);	
		
	// merge shadows of intersecting beamcut bodies
		for(int i=0;i<abc.length();i++)
		{	
			Body bdMerge = abc[i].cuttingBody();
			//bdMerge.vis(2);
			bdMerge.intersectWith(bdShadow);
			PlaneProfile ppMerge =  bdMerge.extractContactFaceInPlane(pn,dEps);
			//ppMerge.vis(1);
			ppEnvelope.unionWith(ppMerge);
		}		
	
	
	// extract the biggest ring
	
		plRings=ppEnvelope.allRings();
		bIsOp= ppEnvelope.ringIsOpening();
		for(int r=0;r<plRings.length();r++)
			if (!bIsOp[r] && plEnvelope.area()<plRings[r].area())
				plEnvelope=plRings[r];				
				
				
				
		Map mapIO;
		mapIO.setPLine("pline",plEnvelope);				
		mapIO.setDouble("MaxSegLength",dSegmentToArcLength); 		
		TslInst().callMapIO(scriptName(), mapIO);
		plEnvelope = mapIO.getPLine("pline");					
				
				
				
	}
	else
	{
		plShadow = curvedStyle.closedCurve();
		CoordSys cs;
		cs.setToAlignCoordSys(_PtW,_XW,_YW,_ZW,bm.ptCen()-vzSip*0.5*bm.dD(vzSip),vxSip,vySip,vzSip);
		//_PtW.vis(3);
		//plShadow.vis(2);
		plShadow.transformBy(cs);
		plShadow.vis(1);
		plEnvelope= plShadow;
	}
		

	plEnvelope.vis(222);	

// panel creation or assignment
	if (plEnvelope.area()>pow(dEps,2) && nStyle>0 && _Sip.length()<1)
	{
		plEnvelope.setNormal(vzSip);
		
		sip.dbCreate(plEnvelope,sStyle,1);	
		sip.setXAxisDirectionInXYPlane(vxSip);
		sip.setWoodGrainDirection(vxSip);
		_Sip.append(sip);
	}	
	if (_Sip.length()<1)
	{
	// write log 
		dp.textHeight(dLL/5);
		for (int i=0;i<sArLog.length();i++)
		{
			dp.draw(sArLog[i],_Pt0,vxSip,vySip,0,-3*i,_kDevice);	
			
		}
		return;	
	}
	else
		sip = _Sip[0];




// compare tool locations with segments of dummy Envelope
	PLine plContour[0];
	plContour.append(plEnvelope);

	for (int i=0;i<plContour.length();i++)
	{
		PLine pl = plContour[i];
		Point3d pts[] = pl.vertexPoints(false);
		
	// find a non perp cut which touches me
		for (int c=0;c<cuts.length();c++)
		{
			reportNotice("\nreporting cuts: " + cuts.length());
			AnalysedCut cut;
			Point3d ptOnCut[0];	
		// ignore any cut which is parallel to vzSip		
			if (cuts[c].normal().isParallelTo(vzSip)) continue;
			
		// ignore any cut which is perpendicular to vzSip	if contour touches the cutting plane		
			if (cuts[c].toolSubType() == _kACPerpendicular || cuts[c].normal().isPerpendicularTo(vzSip))
			{
				cuts[c].normal().vis(cuts[c].ptOrg(),c);
				
				Point3d ptInt[] =pl.intersectPoints( Plane(cuts[c].ptOrg(),cuts[c].normal()));
				pts = Line(_Pt0,-cuts[c].normal()).orderPoints(pts);
				if (ptInt.length()<1 && pts.length()>0)
				;//	sip.stretchEdgeTo(pts[0],Plane(cut.ptOrg(),cut.normal()));
				continue;
			}
		
		// apply any cut on opposite side as static cut
			if(cuts[c].normal().dotProduct(vzSip)>0)
			{
				sip.addToolStatic(Cut(cuts[c].ptOrg(),cuts[c].normal()),0);	
				continue;
			}	
			
		// find points on cuttting plane, allo wfurther processing if cutting points match pl points	
			Plane pn(cuts[c].ptOrg(),cuts[c].normal());
			ptOnCut = pn.filterClosePoints(pts,dEps);
			for (int p=0;p<ptOnCut.length();p++)
			{
				for (int q=0;q<pts.length();q++)
					if (Vector3d(ptOnCut[p]-pts[q]).length()<dEps && ptOnCut.length()>1)
					{
						cut = cuts[c];
						break;
					}
				//pn.vis(p);	
				if (cut.bIsValid())break; // break p loop	
			}


		// find matching segment to this cut and modify edge
			for (int p=0;p<pts.length()-1;p++)
			{
				Vector3d vxSeg,vySeg;
				LineSeg ls(pts[p],pts[p+1]);
				vxSeg = pts[p+1]-pts[p];
				vxSeg.normalize();	
				vySeg = vxSeg.crossProduct(vzSip);		
			
				int bOk=true;
			// requires at least 2 points	
				ptOnCut = Line(ls.ptMid(),vxSeg).orderPoints(ptOnCut);
				if (ptOnCut.length()<2)continue;
			
			// normal of cut is opposite of segemnt
				if (cut.normal().dotProduct(vySeg)<0) continue;
			// this point is not cutting plane
				if (cut.normal().dotProduct(cut.ptOrg()-pts[p])>dEps) continue;
				//vxSegCut.vis(ls.ptMid(),160);
			// points on cut not closed to segment	
				for (int q=0;q<ptOnCut.length();q++)
					if (vySeg.dotProduct(ls.ptMid()-ptOnCut[q])>dEps )
						bOk = false;	
				if(bOk)		
					sip.stretchEdgeTo(ls.ptMid(),Plane(cut.ptOrg(),cut.normal()));
			
				
			}// next p	point of contour




		}// next c cut				


		
	}// next i contour
	
// apply tools 
	
	// apply all analysed drills
	if (bAddTools || _bOnDebug)
	{
		//reportNotice("\nadd Tools..."+drills.length());
	// drills
		sScriptname = "hsbPanelDrill";
		String sArSide[] = {T("|Reference Side|"),T("|Opposite Side|")};
		
		gbAr.setLength(0);
		gbAr.append(sip);
		nArProps.setLength(0);
		dArProps.setLength(2);
		sArProps.setLength(1);
		mapTsl = Map();

		for(int i=0;i<drills.length();i++)
		{
			//if (!drills[i].vecFree().isParallelTo(vzSip))reportNotice("\skip"+i);
		// ignore drills where the center point is outside of the contour
			Point3d pt1=drills[i].ptStartExtreme();
			
		// skip drills which are outside of the envelope and perp to the panel plane	
			if (drills[i].vecFree().isParallelTo(vzSip) &&
				PlaneProfile(plEnvelope).pointInProfile(pt1)==_kPointOutsideProfile)continue;
			pt1.vis(2);
			
		// declare an instance per loop to avoid wrong refs
			TslInst tslNew;
			
		// if the orientation is perpendicular to the xy plane of the panel try to insert a drill tsl to keep the drills editable		
			if (drills[i].vecFree().isParallelTo(vzSip))
			{
				ptAr.setLength(0);
				ptAr.append(pt1);
				dArProps[0] = drills[i].dDiameter();
				dArProps[1] = drills[i].dDepth();
				int nSide;
				if (vzSip.dotProduct(drills[i].vecZ())>0) nSide=1;
				sArProps[0] = sArSide[nSide];
				
				tslNew.dbCreate(sScriptname, vUcsX,vUcsY,gbAr, entAr, ptAr, 
					nArProps, dArProps, sArProps,_kModelSpace, mapTsl); // create new instance	
			}
			if (!tslNew.bIsValid())
			{				
				Point3d pt2 = drills[i].ptEndExtreme();
				Drill dr(pt1,pt2, drills[i].dRadius());
				sip.addToolStatic(dr);	
			}
		}
	// beamcuts
		for(int i=0;i<abc.length();i++)
		{
			Vector3d vxBc = abc[i].coordSys().vecX();
			Vector3d vyBc = abc[i].coordSys().vecY();
			Vector3d vzBc = abc[i].coordSys().vecZ();
			Quader qdrAbc = abc[i].quader();
			double dXYZ[] = {qdrAbc.dD(vxBc),qdrAbc.dD(vyBc),qdrAbc.dD(vzBc)};
			Vector3d vXYZ[]={vxBc,vyBc,vzBc};
			Point3d ptOrg = abc[i].coordSys().ptOrg();
		//enlarge free directions
			for(int j=0;j<vXYZ.length();j++)
			{
				if (abc[i].bIsFreeD(vXYZ[j]))
				{
					ptOrg.transformBy(vXYZ[j]*.5*dXYZ[j]);
					dXYZ[j]*=2;	
				}	
				if (abc[i].bIsFreeD(-vXYZ[j]))
				{
					ptOrg.transformBy(-vXYZ[j]*.5*dXYZ[j]);
					dXYZ[j]*=2;	
				}					
			}
			
			BeamCut bc(ptOrg, vxBc,vyBc,vzBc,dXYZ[0],dXYZ[1],dXYZ[2],0,0,0);
			Body bdTest = bc.cuttingBody();
			bdTest.intersectWith(sip.realBody());
			if (bdTest.volume()>pow(U(1),3))
				sip.addToolStatic(bc);
		}				
		bAddTools=false;
		_Map.setInt("addTools",bAddTools);
	}
			
	_Map.setVector3d("vzSip",vzSip);		
	_Map.setInt("silent",true);
		
		
	
		
		
		
		
		
		
		
		
		



#End
#BeginThumbnail
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
5M&:2B@!<TE%%`!1110`4444`?__9
`


#End
