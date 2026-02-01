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
#MinorVersion 2
#KeyWords 
#BeginContents
// basics and props
	U(1,"mm");
	double dEps(U(0.1));

// debug flags	
	int bReportConversionDetails=false;	
	int bDebugAbc = false;
	int bDebugCuts = false;

	String sArStyleName[0];
	//sArStyleName.append(T("|Auto|"));	
	sArStyleName.append(SipStyle().getAllEntryNames());
	// order style names
	for(int i=1;i<sArStyleName.length();i++)	
		for(int j=1;j<sArStyleName.length()-1;j++)
			if (sArStyleName[j]>sArStyleName[j+1])
				sArStyleName.swap(j,j+1);	
	PropString sStyleName(2, sArStyleName, T("|Panel Style|"));	
	sStyleName.setDescription("Der Panel-Stil wird in der Regel automatisch ermittelt. Mittels dieser Eigenschaft kann die Verwendung eines bestimmten Stils erzwungen werden");

	int nArGradeColor[] = {7,150,150,106};
	String sArGrade[] = {"NVI","VI-REF","VI-GEG","BVI"};
	String sArGradeProperty[] = {T("|None")};
	for(int i=0;i<sArGrade.length();i++)
		sArGradeProperty.append(sArGrade[i]);
	sArGradeProperty.append(T("|Auto|"));	
	PropString sGrade(8, sArGradeProperty, T("|Surface Quality|"));	
	sGrade.setDescription("Sets the surface quality");


// declare the tsl props
	TslInst tslNew;
	Vector3d vUcsX = _XW;
	Vector3d vUcsY = _YW;
	GenBeam gbAr[0];
	Entity entAr[0];
	Point3d ptAr[0];
	int nArProps[0];
	double dArProps[0];
	String sArProps[0];
	Map mapTsl;
	String sScriptname = scriptName();
	
// constants
	double dMaxDrillDiam = U(160);	
	
// on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		showDialog();
		_Entity.append(getEntity());
		if (_Entity[0].typeDxfName() == "3DSOLID")
		{
			Beam bm;
			bm.dbCreate(_Entity[0].realBody());	
			_Beam.append(bm);
			_Pt0 = bm.ptCen();
		}
		else
			eraseInstance();
			
		Vector3d vz = _Beam[0].vecZ();	
		PrPoint ssP(TN("|Specify normal of reference side|") ,_Entity[0].realBody().ptCen()); 
		Point3d pt;
		if (ssP.go()==_kOk)
			pt = ssP.value();	
		if (vz.dotProduct(pt-_Entity[0].realBody().ptCen())<0)
			_Map.setInt("flipDir",-1);
	// flag tools to be added			
		_Map.setInt("addTools",1);	
		return;	
	}	
// end on insert	
// ______________________________________________________________________________________________________________________________________


// append additional properties
	PropString sLabel(3, "", T("|Label|"));	

// get entities
	Entity ent;
	if (_Entity.length()<1 && _Entity[0].typeDxfName() != "3DSOLID")
	{
		eraseInstance();	
		return;			
	}
	else
		ent = _Entity[0];	
	Beam bm;
	if (_Beam.length()<1)
	{
			bm.dbCreate(_Entity[0].realBody());	
			_Beam.append(bm);			
	}
	else
		bm = _Beam[0];	
	
// assign the beam to a potential dummy group
	Group gr[] = Group().subGroups(FALSE);;	
	if (gr.length()>0)
	{
		for (int i=0;i<gr.length();i++)
		{
			Group grDummies(gr[i].namePart(0)+"\\Z_Dummies");
			if (grDummies.bExists())
				grDummies.addEntity(bm,true);	
		}
	}
	
// validate solid	
	Body bd = ent.realBody();
	if (bd.volume()<pow(dEps,U(10)))
	{
		reportMessage("\n******** "+scriptName() + ": " + T("|Conversion Error|")+" ********");
		reportNotice(TN("|Conversion failed as the selected body does not return a valid geometry.|"));//  +
		//	TN("|Source body will be shown in red.|"));
		eraseInstance();	
		return;
	}	

// standards
	Vector3d vx,vy,vz;
	vx = bm.vecX();
	vy = bm.vecY();
	vz = bm.vecZ();


// add triggers
	String sTrigger[] = {T("|Flip Reference Side|"),T("|Rotate X-Axis 90°|"),T("|Flip Reference Side|") + " + "+ T("|Rotate X-Axis 90°|"), T("|Set X-direction|"),"----------------------", 
							   T("|Select Import Number|"), T("|Accept Conversion|")};
	for (int i = 0; i < sTrigger.length(); i++)
		addRecalcTrigger(_kContext, sTrigger[i]);	

// trigger 0||2: T("|Flip Reference Side|")
	if (_bOnRecalc && (_kExecuteKey==sTrigger[0] || _kExecuteKey==sTrigger[2]))
	{
		int nFlip = _Map.getInt("flipDir");
		if (nFlip==0) nFlip=1;
		nFlip*=-1;
		_Map.setInt("flipDir",nFlip);
		_Map.setInt("addTools",1);// make sure the tools will be added again
		if (_Sip.length()>0)
		{
			_Sip[0].dbErase();
			_Sip.setLength(0);
		}
	}
// trigger 1||2: Rotate X-Axis 90
	int bRotateByZ=_Map.getInt("rotateByZ");
	if (_bOnRecalc && (_kExecuteKey==sTrigger[1] || _kExecuteKey==sTrigger[2]))
	{
		if (bRotateByZ) bRotateByZ =false;
		else bRotateByZ =true;
		_Map.setInt("rotateByZ",bRotateByZ);
		_Map.setInt("addTools",1);// make sure the tools will be added again
		if (_Sip.length()>0)
		{
			_Sip[0].dbErase();
			_Sip.setLength(0);
		}		
	}
	
// trigger 3: Set X-Direction
	if (_bOnRecalc && _kExecuteKey==sTrigger[3])
	{
		// if a user direction has been set it will have priority
		Vector3d vxUser;
		PrPoint ssP("\n" + T("|Select next point in x-direction|"),_Pt0); 
		if (ssP.go()==_kOk) 
		{ // do the actual query
			Point3d ptLast = ssP.value(); // retrieve the selected point
			ptLast = ptLast - vz*vz.dotProduct(_Pt0-ptLast);
			vxUser= ptLast-_Pt0;
			if (!vxUser.bIsZeroLength())
			{
				vxUser.normalize();	
				_Map.setVector3d("vxUser",vxUser);
				_Map.setInt("addTools",1);// make sure the tools will be added again							
				if (_Sip.length()>0)
				{
					_Sip[0].dbErase();
					_Sip.setLength(0);
				}				
			}
		}
	}	
// trigger 4: Empty
	if (_bOnRecalc && _kExecuteKey==sTrigger[4])
	{
		//reportNotice("\n" + _kExecuteKey + " not implemented");
	}	
// trigger 5: Select import text
	if (_bOnRecalc && _kExecuteKey==sTrigger[5])
	{
		Entity ent = getEntity(T("|Select Text|"));
		if (ent.typeDxfName()=="TEXT")	
		{
			ent.attachPropSet("hsbText");
			Map mapEnt = ent.getAttachedPropSetMap("hsbText");
			_Map.setString("TEXT",mapEnt.getString("Text"));			
		}		
		else
		{
			reportNotice("\n" + T("|Entity must be of type TEXT and not of type|") + " " + ent.typeDxfName());	
		}
	}			
// trigger 6: accept conversion
	if (_bOnRecalc && _kExecuteKey==sTrigger[6])
	{
		if (bm.bIsValid())bm.dbErase();
		
		// fire labeling here------
		eraseInstance();
		return;
	}
	
// alter vectors depending on actions or settings
// user direction has been set
	if (_Map.hasVector3d("vxUser"))
	{
		vx = _Map.getVector3d("vxUser");	
		vy = vx.crossProduct(-vz);
	}

// repos vecs to make sure Z is smallest direction
	if (bm.dD(vy)<bm.dD(vz))
	{
		vy = bm.vecZ();	
		vz = vx.crossProduct(vy);
	}

// flip Z			
	if (_Map.getInt("flipDir")==-1)
	{
		vz*=-1;
		vx*=-1;		
	}
			
	vx.vis(_Pt0,1);
	vy.vis(_Pt0,3);
	vz.vis(_Pt0,150);		

// get the bounds of the body
	double dBounds[0];
	dBounds.append(bd.lengthInDirection(vx));
	dBounds.append(bd.lengthInDirection(vy));
	dBounds.append(bd.lengthInDirection(vz));

// extract data from a potential import text
	if(_Map.getString("TEXT").length()>0)
	{
	// the token is: <main number>;<sub number>;<Grade>	
		String sToken;
		String sText =	_Map.getString("TEXT");

	// delete potential substring 'Teil '
		sText.makeUpper();
		int i = sText .find("TEIL ",0);
		if (i>-1)
			sText.delete(i,5);
			
	// tokenize the importnumber
		String sTrunc = sText;
		int n = sTrunc.find("-",0);	
		
	// main number
		if (n>-1)
		{
			sToken = sTrunc.left(n).atoi();
			sTrunc.delete(0,n+2);	
			sToken=sToken+";";
		}					
		// sub number
		n = sTrunc.find("-",0);	
		if (n>-1)
		{
			String s = sTrunc.left(n);
			// remove leading zeros
			for (int i = 0; i < s.length(); i++)
			{
				if (s.left(1)=="0")
					s = s.right(s.length()-1);
				else
					break;		
			}
			sToken = sToken+s;
			sTrunc.delete(0,n+1);
			// the remaining trunc could be 'VI O', 'VI U' or similar, purge if it starts with VI
			if (sTrunc.left(2)=="VI") sTrunc ="VI";
			sTrunc.trimLeft().trimRight();
			// Grade	
			sToken=sToken+";"+sTrunc.makeUpper();
		}
		sToken.trimLeft().trimRight();
		sLabel.set(sToken);
		
	// clear the content of the text string in map to avoid repetitive data extraction	
		_Map.setString("Text","");			
	}// END extract data from a potential import text


// get tools from dummy beam
	AnalysedTool tools[] = bm.analysedTools();
	AnalysedBeamCut abc[] = AnalysedBeamCut().filterToolsOfToolType(tools);
	AnalysedCut cuts[] = AnalysedCut().filterToolsOfToolType(tools);
	int bCutAdded[cuts.length()];// flag if a cut has been added
	if (bDebugAbc)
		for(int i=0;i<abc.length();i++)
			;//abc[i].quader().vis(i);
	if (bDebugCuts)
		for(int i=0;i<cuts.length();i++)
		{
			String s = cuts[i].toolSubType();
			if (s==_kACPerpendicular)
			{
				cuts[i].normal().vis(cuts[i].ptOrg(),i);
				//reportNotice("\ni"+i + " skipped");
				//continue;
			}
			
		}


// the ref plane
	Plane pn(_Pt0 - vz*.5*bm.dD(vz),vz);
	
// get a shadow and pp's of every side 
	PlaneProfile ppEnvelope,ppEnvelopeOpp, ppShadow ; 
	ppEnvelope =  bd.extractContactFaceInPlane(pn,dEps);
	ppEnvelopeOpp=  bd.extractContactFaceInPlane(Plane(_Pt0 + vz*.5*bm.dD(vz),vz),dEps);
	ppShadow = ppEnvelope;
	ppShadow.unionWith(ppEnvelopeOpp);
	//ppEnvelope.transformBy(vy*bm.dD(vy)*3);
	//ppEnvelope.vis(0);
	ppEnvelopeOpp.transformBy(vy*bm.dD(vy)*3);
	ppEnvelopeOpp.vis(1);
	ppShadow .transformBy(vy*bm.dD(vy)*2);
	ppShadow.vis(3);

// get the hull
	PLine plEnvelope(vz);
	PLine plRings[]=ppEnvelope.allRings();
	int bIsOp[] = ppEnvelope.ringIsOpening();
	for(int r=0;r<plRings.length();r++)
		if (!bIsOp[r] && plEnvelope.area()<plRings[r].area())
			plEnvelope=plRings[r];	
	ppEnvelope = PlaneProfile(plEnvelope);		
	//plEnvelope.vis(4);


// get boxed hull
	// avoids multiple vertices (tolerance issue)
	LineSeg lsHull = ppEnvelope.extentInDir(vx);
	PLine plHull(vz);
	plHull.createRectangle(lsHull,vx,vy);
	PlaneProfile ppHull(plHull);
	//ppHull.vis(3);

// stretch the envelope to the extents if a codirectional perp cut is found
	// this is required on some situations where beamcuts are manipulating at the edge of a panel (like rabbets)
	//analyze segments and stretch to edge (AnalysedCuts) 
	// sample dwg: Goeller, panel 10
	{
		for(int c=0;c<cuts.length();c++)
		{
			if(cuts[c].toolSubType()!=_kACPerpendicular) continue;
			
			Point3d ptEnvelope[] = plEnvelope.vertexPoints(false);
			for(int p=0;p<ptEnvelope.length()-1;p++)
			{
				Vector3d vxSeg,vySeg;
				LineSeg ls(ptEnvelope[p],ptEnvelope[p+1]);
				vxSeg = ptEnvelope[p+1]-ptEnvelope[p];
				vxSeg.normalize();	
				vySeg = vxSeg.crossProduct(vz);
				if (!ppEnvelope.pointInProfile(ls.ptMid()+vySeg*U(1))==_kPointOutsideProfile)
					vySeg*=-1;	
				
				if (vySeg.isParallelTo(cuts[c].normal()))
				{				
					Point3d pt[] = ppEnvelope.getGripEdgeMidPoints();

				// determine which point is closest to _PtG[0]
					int nInd = -1;
					double dDistMin = 0;
					for (int q=0;q<pt.length();q++)
					{
						double dDist = Vector3d(ls.ptMid()-pt[q]).length();
						if (q==0 || dDist<dDistMin) 
						{
							dDistMin = dDist;
							nInd = q;
						}
					}
				
					if (nInd>=0 && Vector3d(pt[nInd]-ppHull.closestPointTo(pt[nInd])).length()<dEps && 
						vySeg.dotProduct(cuts[c].ptOrg()-pt[nInd])>U(1)) 
					{
						double dMove = vySeg.dotProduct(cuts[c].ptOrg()-pt[nInd]);
						Point3d ptStretch = pt[nInd] + vySeg*dMove;
						//ptStretch.vis(2);vySeg.vis(pt[nInd],3);
						ppEnvelope.moveGripEdgeMidPointAt(nInd, ptStretch -pt[nInd]);
					}
				}
			}// next p
		}// next c
		
		PLine pl[] = ppEnvelope.allRings();
		if (pl.length()>0) plEnvelope = pl[0];
		//plEnvelope.vis(4);
		
		// redefine the shadow
		ppShadow = ppEnvelope;
		ppShadow.unionWith(ppEnvelopeOpp);
	}

	
// collect projected opening shapes of all abc's
	PLine plOpeningsAbc[0];
	for(int i=0;i<abc.length();i++)
	{
		PlaneProfile pp=abc[i].cuttingBody().getSlice(pn);
		//pp.vis(1);

	}	

// create the sip and set XY plane and graindirection
	Sip sip;
	if (_Sip.length()<1)
	{
		sip.dbCreate(plEnvelope,sStyleName,1);
		_Sip.append(sip);
	}
	else
		sip = _Sip[0];	
	
// exit if sip is not valid
	if (!sip.bIsValid())	
	{
		reportNotice("\n" + scriptName() + ": " + T("|conversion is invalid.|")	);
		eraseInstance();
		return;		
	}
		
// realign vecs for wall like conversions
	if (vz.isPerpendicularTo(_ZW) && vx.isPerpendicularTo(_ZW))
	{
		sip.setXAxisDirectionInXYPlane(_ZW);
	}
// set x-axis to longest panel edge	
	else if (!_Map.hasVector3d("vxUser"))
	{
		sip.setXAxisDirectionInXYPlane(vx);
		if (sip.dL()<sip.dW())
			sip.setXAxisDirectionInXYPlane(vy);				
	}
	else
		sip.setXAxisDirectionInXYPlane(vx);				
			
// rotate by z
	if(bRotateByZ)
	{
		sip.setXAxisDirectionInXYPlane(sip.vecY());		
	}

// set properties
	sip.setLabel(sLabel);
	if (sArGrade.find(sGrade)>-1) 
		sip.setGrade(sGrade);
	else if (sGrade == T("Auto") && sLabel.token(2)!="")
	{	
		if (sArGrade.find(sLabel.token(2))>-1) 
			sip.setGrade(sLabel.token(2));			
		else if (sLabel.token(2)=="VI") 
			sip.setGrade(sArGrade[1]);// set to VI-Ref
		else
		{
			sip.setGrade(sArGrade[0]);
		}		
		sGrade.set(sip.grade());		
	}
	else
		sip.setGrade("");

// preview data
	String sPreviewTxt[0],sPreviewKey[0];
	sPreviewKey.append("#");
	if (sLabel.length()>0)
		sPreviewTxt.append(sLabel);
	else
		sPreviewTxt.append("?");
		
	// style
	sPreviewKey.append(T("|Style|"));
	//if(!sipStyleThis.bIsValid())
	//	sPreviewTxt.append("?");
	//else
		sPreviewTxt.append(sStyleName);	

	// surface Grade
	sPreviewKey.append("OQ");
	if(sip.grade()=="")
		sPreviewTxt.append("?");
	else
		sPreviewTxt.append(sip.grade());	
	

	// geometry
	sPreviewKey.append("XYZ");	
	sPreviewTxt.append(sip.dL() +"x" + sip.dW() +"x" +sip.dH());	


// Display
	Display dp(6);
	Vector3d vxSip=vx,vySip=vy;
	if (_Sip.length()>0 && !_Sip[0].vecX().isParallelTo(vx))
	{
		vxSip=_Sip[0].vecX();
		vySip=_Sip[0].vecX().crossProduct(-vz);
	}
	
// draw preview texts
	double dFlag = 3.0 * (sPreviewTxt.length()-1)/2;
	dp.color(6);
	for(int i=0;i<sPreviewTxt.length();i++)
	{
		dp.draw(sPreviewKey[i] + ": ",_Pt0,vxSip,vySip,-1.1,dFlag,_kDevice);	
		dp.draw(sPreviewTxt[i],_Pt0,vxSip,vySip,1.1,dFlag,_kDevice);	
		dFlag-=3.0;
	}	

	
// ***************************************************************************************************************************	
// after this line only tooling operations ***********************************************************************************	
// ***************************************************************************************************************************


if (_Map.getInt("addTools") || _bOnDebug) // this flag is altered by some context commands to execute again
{

// append openings
	Map mapAbcPoints;
	for(int r=0;r<plRings.length();r++)
	{
	// circle approximation test	
		LineSeg ls =PlaneProfile(plRings[r]).extentInDir(vx);
		Point3d ptStart = ls.ptMid();//+vz*nDir*U(1);
		PLine plCirc(vz);
		double dRadius = abs(vx.dotProduct(ls.ptStart()-ls.ptEnd()))/2;
		plCirc.createCircle(ptStart,vz,dRadius);
		
		double a = abs(plCirc.area()-plRings[r].area());

	// it is an opening in a valid sip which is most likely NOT a circle or a circle with a diameter greater than the max diam
		if (bIsOp[r] && _Sip.length()>0 && (a>pow(U(2),2) || dRadius*2>dMaxDrillDiam))
		{
			_Sip[0].addOpening(plRings[r],false);
			mapAbcPoints.appendPoint3dArray("points",plRings[r].vertexPoints(false));
		}
	}
	
// analyze segments of opening (AnalysedBeamCuts) 
	for(int m=0;m<mapAbcPoints.length();m++)
	{
		Point3d ptArAbc[0];
		ptArAbc = mapAbcPoints.getPoint3dArray(m);

		for(int p=0;p<ptArAbc.length()-1;p++)
		{
			Vector3d vxSeg,vySeg;
			LineSeg ls(ptArAbc[p],ptArAbc[p+1]);
			vxSeg = ptArAbc[p+1]-ptArAbc[p];
			vxSeg.normalize();	
			vySeg = vxSeg.crossProduct(vz);
			if (ppEnvelope.pointInProfile(ls.ptMid()+vySeg*U(1))==_kPointOutsideProfile)
				vySeg*=-1;		
						
		// find the matching abc to this segment
			for(int i=0;i<abc.length();i++)
			{
				//abc[i].quader().vis(i);
				PlaneProfile pp=abc[i].cuttingBody().getSlice(pn);
				if (pp.area()<pow(dEps,2))
					pp = abc[i].cuttingBody().extractContactFaceInPlane(pn,dEps);
				pp.vis(i);
				plRings=pp.allRings();
				PLine plAbc;
				if(plRings.length()<1) {continue;} 
				else 
					plAbc= plRings[0];
				Point3d ptAbc[] = plAbc.vertexPoints(false);
				for(int q=0;q<ptAbc.length()-1;q++)
				{
					Vector3d vxSegTool,vySegTool;
					LineSeg lsTool(ptAbc[q],ptAbc[q+1]);
					vxSegTool = ptAbc[q+1]-ptAbc[q];
					vxSegTool .normalize();	
					vySegTool = vxSegTool.crossProduct(vz);
					if (pp.pointInProfile(lsTool.ptMid()+vySegTool*U(1))!=_kPointOutsideProfile)
						vySegTool*=-1;
						
				// compare with envelope segment
					if (vxSeg.isParallelTo(vxSegTool) && vySeg.isCodirectionalTo(vySegTool) && abs(vySeg.dotProduct(ls.ptMid()-lsTool.ptMid()))<U(1) && _Sip.length()>0)	// 		
					{
						//vySegTool.vis(lsTool.ptMid(),i);
						// the desired normal to stretch the edge to is the most aligned vec to the quader
						Vector3d vzStretch = abc[i].quader().vecD(vySegTool);
						//vzStretch.vis(lsTool.ptMid(),p);
						_Sip[0].stretchEdgeTo(lsTool.ptMid(),Plane(lsTool.ptMid(),vzStretch));
					}			
				}// next q
			}// next i	
		// END find the matching abc to this segment				
		}//next p
	}// next m		
// END analyze segments and stretch to edge	

// analyze segments and stretch to edge (AnalysedBeamCuts and AnalysedCuts) 
	Point3d ptEnvelope[] = plEnvelope.vertexPoints(false);
	for(int p=0;p<ptEnvelope.length()-1;p++)
	{
		Vector3d vxSeg,vySeg;
		LineSeg ls(ptEnvelope[p],ptEnvelope[p+1]);
		vxSeg = ptEnvelope[p+1]-ptEnvelope[p];
		vxSeg.normalize();	
		vySeg = vxSeg.crossProduct(vz);
		if (!ppEnvelope.pointInProfile(ls.ptMid()+vySeg*U(1))==_kPointOutsideProfile)
			vySeg*=-1;	
					
	// find the matching abc to this segment
		for(int i=0;i<abc.length();i++)
		{
			PlaneProfile pp=abc[i].cuttingBody().getSlice(pn);
			if (pp.area()<pow(dEps,2))
				pp = abc[i].cuttingBody().extractContactFaceInPlane(pn,dEps);
			pp.vis(i);
			plRings=pp.allRings();
			PLine plAbc;
			if(plRings.length()<1) {continue;} 
			else 
				plAbc= plRings[0];
			Point3d ptAbc[] = plAbc.vertexPoints(false);
			for(int q=0;q<ptAbc.length()-1;q++)
			{
				Vector3d vxSegTool,vySegTool;
				LineSeg lsTool(ptAbc[q],ptAbc[q+1]);
				vxSegTool = ptAbc[q+1]-ptAbc[q];
				vxSegTool .normalize();	
				vySegTool = vxSegTool.crossProduct(vz);
				if (!pp.pointInProfile(lsTool.ptMid()+vySegTool*U(1))!=_kPointOutsideProfile)
					vySegTool*=-1;
					
			// compare with envelope segment
				if (vxSeg.isParallelTo(vxSegTool) && vySeg.isCodirectionalTo(vySegTool) && abs(vySeg.dotProduct(ls.ptMid()-lsTool.ptMid()))<U(1) && _Sip.length()>0)	// 		
				{
					//vySegTool.vis(lsTool.ptMid(),i);
					// the desired normal to stretch the edge to is the most aligned vec to the quader
					Vector3d vzStretch = abc[i].quader().vecD(vySegTool);
					//vzStretch.vis(lsTool.ptMid(),p);
					_Sip[0].stretchEdgeTo(lsTool.ptMid(),Plane(lsTool.ptMid(),vzStretch));
				}			
			}// next q
		}// next i	
	// END find the matching abc to this segment					
			
				
	// find the matching cut to this segment	
		for(int i=0;i<cuts.length();i++)
		{
		// ignore perp cuts or cuts which have already been added
			if(cuts[i].toolSubType()==_kACPerpendicular || bCutAdded[i])	
				continue;
			
		// question compound cut
			Point3d ptEdge, ptOtherEdge;
			double dAngle, dBevel;		
			int bIsCompound = cuts[i].questionIsCompoundCut(cuts[i].normal(), ptEdge, ptOtherEdge, dAngle, dBevel);
			int bSegFound;
			Vector3d vxSegTool,vySegTool,vzSegTool;
			LineSeg lsTool(ptEdge,ptOtherEdge);
			if (bIsCompound)
			{
				vxSegTool = ptOtherEdge-ptEdge;	
			}
		// locate cut at envelope segment		
			else
			{
				vxSegTool = cuts[i].normal().crossProduct(-vz);vxSegTool .normalize();
				vySegTool = vxSegTool.crossProduct(vz);
				vzSegTool = vxSegTool.crossProduct(cuts[i].normal());
			// extracting the contact face gives a set of potential rings where the ptOrg could be in	
				PlaneProfile ppCut = bd.extractContactFaceInPlane(Plane(cuts[i].ptOrg(),cuts[i].normal()),dEps);
				ppCut.shrink(-dEps);
				plRings=ppCut.allRings();
				bIsOp = ppCut.ringIsOpening();
			// use the ring where the org is in
				PLine plCut;
				for(int r=0;r<plRings.length();r++)
					if (!bIsOp[r] && PlaneProfile(plRings[r]).pointInProfile(cuts[i].ptOrg())==_kPointInProfile)
						plCut=plRings[r];	
			// redefine the pp			
				ppCut =PlaneProfile(plCut);
			// project the midpoint of the pp to the ref plane	
				ptEdge = ppCut.extentInDir(vxSegTool).ptMid();
				Line ln(ptEdge,vzSegTool);
				int bHasInter = ln.hasIntersection(pn, ptEdge ) ;
				if (bHasInter && ppCut.pointInProfile(ptEdge)==_kPointInProfile && plCut.area()>pow(dEps,2))
				{
					//plCut.vis(i);		
					lsTool = LineSeg(ptEdge-vxSegTool*dEps,ptEdge+vxSegTool*dEps);
					bSegFound=true;
					ptOtherEdge = cuts[i].ptOrg();
				}
				if (!bSegFound)continue;
			}
			
			vxSegTool .normalize();	
			vySegTool = vxSegTool.crossProduct(vz);
			if (!ppEnvelope.pointInProfile(lsTool.ptMid()+vySegTool*U(1))==_kPointOutsideProfile)
				vySegTool*=-1;
				
			// compare with envelope segment
			if (bIsCompound && vxSeg.isParallelTo(vxSegTool) && vySeg.isCodirectionalTo(vySegTool) && abs(vySeg.dotProduct(ls.ptMid()-lsTool.ptMid()))<U(1)  && _Sip.length()>0)
			{
			// get stretch distance
				Point3d pt[] = cuts[i].bodyPointsInPlane();
				pt = Line(ptEdge,-vySegTool).orderPoints(pt);
				double dY= vySegTool.dotProduct(pt[0]-lsTool.ptMid());
				Point3d ptStretchTo = ls.ptMid()+vySegTool*dY;
				//ptStretchTo.vis(2);
				_Sip[0].stretchEdgeTo(ptStretchTo,Plane(ptStretchTo,vySegTool));
				_Sip[0].addToolStatic(Cut(cuts[i].ptOrg(),cuts[i].normal()),0);
				bCutAdded[i]=true;
				
			}

			else if (bSegFound && vxSeg.isParallelTo(vxSegTool) && vySeg.isCodirectionalTo(vySegTool) && abs(vySeg.dotProduct(ls.ptMid()-lsTool.ptMid()))<U(1)  && _Sip.length()>0)//
			{
				//vySegTool.vis(lsTool.ptMid(),3);	
				//vySeg.vis(lsTool.ptMid(),1);	
				//reportMessage("\nloop:   try cut " + i + " at p: " + p);
				//cuts[i].normal().vis(lsTool.ptMid(),i);
				_Sip[0].stretchEdgeTo(lsTool.ptMid() ,Plane(lsTool.ptMid() ,cuts[i].normal()));	
				bCutAdded[i]=true;
				//reportMessage("... succesful at i ( "+ i + ")" );
			}	
		}
				
	}//next p		
// END analyze segments and stretch to edge

		
// collect all non z-free beamcuts and apply them as static beamcuts
	for(int i=0;i<abc.length();i++)	
	{
		if (!abc[i].bIsFreeD(vz))
		{
			//abc[i].quader().vis(1);	
			Point3d pt = abc[i].ptOrg();
			double dX, dY, dZ;
			Vector3d vxBc=abc[i].coordSys().vecX(),vyBc=abc[i].coordSys().vecY(),vzBc=abc[i].coordSys().vecZ();
			dX = abc[i].quader().dD(vxBc);
			dY = abc[i].quader().dD(vyBc);
			dZ = abc[i].quader().dD(vzBc);

			// enlarge if free
			int nIsPerp;
			double dAr[] = {dX,dY,dZ};
			Vector3d vAr[] = {vxBc,vyBc,vzBc};
			for (int j=0;j<vAr.length();j++)
			{
				
				int nDir=1;
				for (int k=0;k<2;k++)
				{
					if (abc[i].bIsFreeD(nDir*vAr[j]))
					{	
						if (vAr[j].isParallelTo(vz))
							nIsPerp++;
						pt.transformBy(nDir*vAr[j]*dAr[j]/2);
						dAr[j]*=2;
					}	
					nDir*=-1;
				}				
			}// next j
			BeamCut bc(pt,vxBc,vyBc,vzBc,dAr[0],dAr[1],dAr[2],0,0,0);
			//bc.cuttingBody().vis(3);			
			if (_bOnDebug && _Sip.length()>0) _Sip[0].addTool(bc);
			else if(_Sip.length()>0)
			{
				_Sip[0].addToolStatic(bc);
			}			
		}		
	}	
	
	
// find some obvious conversion differences in the coordSys
	// sample dwg: Goeller, panel 10
	if (_Sip.length()>0)
	{
		Vector3d vxAr[] = {vx,vy,vz}, vyAr[] = {vy,vz,-vx};
		for (int v=0;v<vxAr.length();v++)
		{
			Vector3d vxView=vxAr[v],vyView=vyAr[v];
			Vector3d vzView = vxAr[v].crossProduct(vyAr[v]);
			PlaneProfile ppShadow = bd.shadowProfile(Plane(_Pt0,vzView));
	 		//ppShadow .vis(v);
			PlaneProfile ppThis = _Sip[0].realBody().shadowProfile(Plane(_Pt0,vzView));
			ppThis.subtractProfile(ppShadow);
			PLine plRings[]=ppThis.allRings();
			int bIsOp[] = ppThis.ringIsOpening();
			for(int r=0;r<plRings.length();r++)
			{
				if (!bIsOp[r])
				{
					// test if it is squared and does'nt vary much
					PlaneProfile ppRec(plRings[r]);
					LineSeg lsHull = ppRec.extentInDir(vxView);
					PLine plHull(vy);
					plHull.createRectangle(lsHull,vxView,vyView);
					ppRec= PlaneProfile(plHull);
					//plRings[r].vis(3);
					
					if (abs(plRings[r].area()-ppRec.area())<dEps)
					{
						
						//ppRec.vis(1);
						Point3d pt = lsHull.ptMid();
						double dX, dY, dZ;
						dX = abs(vxView.dotProduct(lsHull.ptStart()-lsHull.ptEnd()));
						dY = abs(vyView.dotProduct(lsHull.ptStart()-lsHull.ptEnd()));
						dZ = U(20000);
						//vyView.vis(pt,1);
						if (dX<=0 || dY<=0 ||dZ<=0) continue;
						BeamCut bc(pt,vxView,vyView,vzView,dX,dY,dZ,0,0,0);
						bc.cuttingBody().vis(v);					
						if (_bOnDebug && _Sip.length()>0) _Sip[0].addTool(bc);
						else if(_Sip.length()>0)
						{
							_Sip[0].addToolStatic(bc);
						}
					}
				}
			}// next r
		}	// next v
	}
		
// the slice test will search circular openings on each side of the panel to insert a drill instance to the panel
{
	Sip sip = _Sip[0];
	Point3d ptExtrZ[] = bd.extremeVertices(vz);
	if (bReportConversionDetails) reportNotice("\n   Testing faces...");
	
	String sArSide[] = {T("|Reference Side|"),T("|Opposite Side|")};
	sScriptname = "hsbPanelDrill";
	entAr.setLength(0);
	entAr.append(sip);

// loop sides
	int nDir=-1;
	for (int p=0;p<ptExtrZ.length();p++)
	{
		PlaneProfile ppZ = bd.getSlice(Plane(ptExtrZ[p],vz*nDir));

		// collect circle alike openings
		PLine plRings[] = ppZ.allRings();
		int bIsOp[] = ppZ.ringIsOpening();
		for (int r=0;r<plRings.length();r++)
			if (bIsOp[r])
			{
				//plRings[r].vis(r);
			// test approx circle
				LineSeg ls =PlaneProfile(plRings[r]).extentInDir(vx);
				Point3d ptStart = ls.ptMid();//+vz*nDir*U(1);
				PLine plCirc(vz);
				double dRadius = abs(vx.dotProduct(ls.ptStart()-ls.ptEnd()))/2;
				plCirc.createCircle(ptStart,vz,dRadius);
				
				double a = abs(plCirc.area()-plRings[r].area());
				if (a<pow(U(2),2))
				{
				// detect depth
					Point3d ptIntDepth[0];
					Body bdCyl (ptStart ,ls.ptMid()-vz*nDir*dBounds[2],U(1));
					bdCyl.intersectWith(bd);										
					ptIntDepth= bdCyl.extremeVertices(-nDir*vz);
		
					double dDepth;
				// if it does not return intersection points it is a through	
					if (ptIntDepth.length()<1 && p>0)
					{
						if (bReportConversionDetails) reportNotice("\n      ignored through drill R=" +dRadius);
						continue;
					}
					else if (ptIntDepth.length()<2)
					{
						if (bReportConversionDetails) reportNotice("\n      through drill R=" +dRadius);
						dDepth = dBounds[2]*2;
					}
				// not a through		
					else
					{
						dDepth = abs(vz.dotProduct(ptIntDepth[0]-ptStart));
						if (bReportConversionDetails) reportNotice("\n      drill R=" +dRadius + " depth= " +dDepth);	
					}
					
				// add tsl
					ptAr.setLength(0);
					ptAr.append(ptStart);
					dArProps.setLength(0);
					dArProps.append(dRadius*2);
					dArProps.append(dDepth);
					
					sArProps.setLength(0);
					sArProps.append(sArSide[p]);
					tslNew.dbCreate(sScriptname, vUcsX,vUcsY,gbAr, entAr, ptAr, 
						nArProps, dArProps, sArProps,_kModelSpace, mapTsl); // create new instance		
				}
			}	
		nDir*=-1;
	}				
}// end slice test	
_Map.setInt("addTools",0);

}// end add tools		
	//bm.dbErase();
	//eraseInstance();
	return;
	
	
	
		

#End
#BeginThumbnail


#End
