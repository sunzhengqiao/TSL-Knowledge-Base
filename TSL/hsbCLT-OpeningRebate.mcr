#Version 8
#BeginDescription
version value="1.3" date="11jul2017" author="thorsten.huck@hsbcad.com"
revised, new property and context commands to manipulate the tool shape

/// This tsl creates a single or double rebate around an opening. It can be attached to any opening or 
/// the minmal size can be filtered during insert
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
/// <History>//region
/// <version value="1.3" date="11jul2017" author="thorsten.huck@hsbcad.com"> revised, new property and context commands to manipulate the tool shape </version>
/// <version value="1.2" date="30aug2017" author="thorsten.huck@hsbcad.com"> new property 'Radius' specifies an override of the tool width if the radius is greater than the width </version>
/// <version value="1.1" date="28jul2017" author="thorsten.huck@hsbcad.com"> added flag not to modify the CNC section, rebates will result into single pockets </version>
/// <version value="1.0" date="21jul2017" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select panel(s), select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates a single or double rebate around an opening. It can be attached to any opening or 
/// the minmal size can be filtered during insert
/// </summary>//endregion


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


// Face	
	String sFaceName=T("|Face|");	
	String sFaces[] = {T("|Reference Side|"), T("|Opposite Side|")};
	PropString sFace(nStringIndex++, sFaces, sFaceName);
	sFace.setCategory(category );

	String sEdgeModeName=T("|Edge Mode|");	
	String sEdgeModes[] ={T("|all|"), 
		T("|not bottom|") + " (-Y)", 
		T("|not left|")+ " (-X)",
		T("|not top|")+ " (Y)",
		T("|not right|")+ " (X)",
		T("|bottom + top|") + " (-Y+Y)" ,T("|left + right|")+ " (-X+X)",
		T("|bottom|")+" (-Y)", T("|left|")+" (-X)",T("|top|")+" (Y)", T("|right|")+" (X)"};
	PropString sEdgeMode(nStringIndex++, sEdgeModes, sEdgeModeName);	
	sEdgeMode.setDescription(T("|Defines the EdgeMode|"));
	sEdgeMode.setCategory(category);

// GEOMETRY
	category = T("|Rebate|") + " 1";
	String sDepthName=T("|Depth|");	
	PropDouble dDepth(nDoubleIndex++, U(98), sDepthName);	
	dDepth.setDescription(T("|Defines the Depth|"));
	dDepth.setCategory(category );

	String sWidthName=T("|Width|");	
	PropDouble dWidth(nDoubleIndex++, U(44), sWidthName);	
	dWidth.setDescription(T("|Defines the Width|"));
	dWidth.setCategory(category );	
	

	category = T("|Rebate|") + " 2";
	String sDepth2Name=T("|Depth|") + " ";	
	PropDouble dDepth2(nDoubleIndex++, U(0), sDepth2Name);	
	dDepth2.setDescription(T("|Defines the Depth|"));
	dDepth2.setCategory(category );

	String sWidth2Name=T("|Width|") + " ";	
	PropDouble dWidth2(nDoubleIndex++, U(0), sWidth2Name);	
	dWidth2.setDescription(T("|Defines the Width|"));
	dWidth2.setCategory(category );


// stay consistent with previous versions: radii have been added in 1.2 
	String sRadiusName=T("|Tool Radius|");	
	PropDouble dRadius(nDoubleIndex++, U(0), sRadiusName);	
	dRadius.setDescription(T("|Defines the radius of the tool.|") + T("|This option will enlarge the tool regarding to the specified value.|") + " "+T("|0 = irrelevant|"));
	dRadius.setCategory(T("|Rebate|") + " 1");

	String sRadius2Name=T("|Tool Radius|") +" ";	
	PropDouble dRadius2(nDoubleIndex++, U(0), sRadius2Name);	
	dRadius2.setDescription(T("|Defines the radius of the tool.|") + T("|This option will enlarge the tool regarding to the specified value.|") + " "+T("|0 = irrelevant|"));
	dRadius2.setCategory(T("|Rebate|") + " 2");


// Filter
	category=T("|Filter|");
	String sMinAreaName=T("|Minimal Area|");	
	PropDouble dMinArea(nDoubleIndex++, U(0), sMinAreaName);	
	dMinArea.setDescription(T("|Defines the mininmal area of an opening to be processed|") + " " + T("|0 = all openings|") + 
		T("|A negative value filters any opening being greater, positive values filter smaller openings.|"));
	dMinArea.setCategory(category);



// bOnInsert//region
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		String sKey = _kExecuteKey;
		sKey.makeUpper();

		if (sKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			for(int i=0;i<sEntries.length();i++)
				sEntries[i] = sEntries[i].makeUpper();	
			if (sEntries.find(sKey)>-1)
				setPropValuesFromCatalog(sKey);
			else
				setPropValuesFromCatalog(sLastInserted);					
		}	
		else	
			showDialog();

	// create TSL
		TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
		GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
		int nProps[]={};			
		double dProps[]={dDepth,dWidth,dDepth2,dWidth2, dRadius, dRadius2, dMinArea};				
		String sProps[]={sFace, sEdgeMode};
		Map mapTsl;	

	// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select panel(s)|"), Sip());
	  	if (ssE.go())
			ents.append(ssE.set());
		
	// get sip and  insert per opening
		for (int i=0;i<ents.length();i++) 
		{ 
			Sip sip = (Sip)ents[i]; 
			if(sip.bIsValid())
			{ 
				PLine plOpenings[]=sip.plOpenings();
				for (int j=0;j<plOpenings.length();j++) 
				{ 
					PLine pl = plOpenings[j]; 
				// the absolute of a negative value filter greater openings, positive values filter smaller openings
					if ((dMinArea<0 && pl.area()>abs(dMinArea)) || (dMinArea>0 && pl.area()<dMinArea))
					{ 
						continue;
					}
					ptsTsl.setLength(0);
					Point3d pt;
					pt.setToAverage(pl.vertexPoints(true));
					ptsTsl.append(pt);
					gbsTsl.setLength(0);
					gbsTsl.append(sip);
					
					tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);		
				}				
			}
		}

		eraseInstance();
		return;		
	}	
// end on insert__________________//endregion
	
	
// validate
	if (_Sip.length()<1)
	{
		eraseInstance();
		return;	
	}
	
// set standards
	Sip sip = _Sip[0];
	Vector3d vecX = sip.vecX();
	Vector3d vecY = sip.vecY();
	Vector3d vecZ = sip.vecZ();
	Point3d ptCen = sip.ptCenSolid();
	PLine plEnvelope = sip.plEnvelope();
	double dZ = sip.dH();
	Quader qdr(ptCen, vecX, vecY, vecZ, sip.solidLength(), sip.solidWidth(), sip.solidHeight(),0,0,0);

// get tool coordSys 
	Vector3d vecXT = vecX;
	Vector3d vecYT = vecY;
	Vector3d vecZT = vecZ;
	// in XY plane
	if(vecZ.isParallelTo(_ZW))
	{ 
		vecXT = qdr.vecD(_XW);
		vecYT = vecXT.crossProduct(-vecZT);
	}
	// as 3D wall
	else if(vecZ.isPerpendicularTo(_ZW))
	{ 
		vecYT = qdr.vecD(_ZW);
		vecXT = vecXT.crossProduct(-vecZT);
	}	
	Vector3d vecDirs[] ={ -vecYT, - vecXT, vecYT, vecXT};
	int bStretchs[] ={true,true,true,true};

// assigning and color
	assignToGroups(sip,'T');
	dMinArea.setReadOnly(true);	
		
// ints
	int nFace = sFaces.find(sFace)==1?1:-1;
	int nEdgeMode = sEdgeModes.find(sEdgeMode);
	if (nEdgeMode < 0)
	{
		nEdgeMode = 0;
		sEdgeMode.set(sEdgeModes[nEdgeMode]);
	}
	int bSingleEdge = nEdgeMode >= 7;	

// stretch to edge modes dependent from edge type
	// no bottom
	if (nEdgeMode==1 || nEdgeMode==6)bStretchs[0] = false;
	// no left
	if ((nEdgeMode==2 || nEdgeMode==5) && nEdgeMode!=8)bStretchs[1] = false;
	// no top	
	if ((nEdgeMode==3 || nEdgeMode==6) && nEdgeMode!=9)bStretchs[2] = false;
	// no right
	if ((nEdgeMode==4 || nEdgeMode==5) && nEdgeMode!=10)bStretchs[3] = false;
	// bSingleEdge
	if (bSingleEdge)
	{ 
		int b[] ={false,false, false, false};
		bStretchs = b;
	}
	if (nEdgeMode==7 || nEdgeMode==5)bStretchs[0] = true;
	if (nEdgeMode==8 || nEdgeMode==6)bStretchs[1] = true;
	if (nEdgeMode==9 || nEdgeMode==5)bStretchs[2] = true;
	if (nEdgeMode==10 || nEdgeMode==6)bStretchs[3] = true;


// get all openings	
	Point3d ptFace = sip.ptCenSolid()+nFace*vecZ*.5*dZ;
	Plane pnFace(ptFace, vecZ*nFace);
	PLine plDefining(vecZ);
	PLine plOpenings[]=sip.plOpenings();
	
// display
	int nColor = (nFace==1?4:3);
	Display dp(nColor);

	
	
//TRIGGER//region
// TriggerFlipSide
	String sFlipTrigger = T("|Flip Side|") + " (" + T("|Doubleclick|") + ")";
	addRecalcTrigger(_kContext, sFlipTrigger );//sTriggerFlipDirection
	if (_bOnRecalc && (_kExecuteKey==sFlipTrigger || _kExecuteKey==sDoubleClick)) 
	{
		if (nFace==1)
			sFace.set(sFaces[0]);
		else if (nFace==-1)
			sFace.set(sFaces[1]);
		
		setExecutionLoops(2);
		return;
	}	
	
// Trigger StretchTool//region
	Vector3d vecDirEdge;
	int bStretchToEdge = _Map.getInt("StretchToEdge");
	if (nEdgeMode!=0)
	{ 
		String sTrigger1 = T("|Stretch tool to panel edge|");
		String sTrigger2 = T("|Do not stretch Tool|");
		String sTriggerStretchTool = bStretchToEdge?sTrigger2:sTrigger1;
		addRecalcTrigger(_kContext, sTriggerStretchTool );
		if (_bOnRecalc && (_kExecuteKey==sTriggerStretchTool || _kExecuteKey==sDoubleClick))
		{
			bStretchToEdge = bStretchToEdge ? false : true;
			 _Map.setInt("StretchToEdge",bStretchToEdge);
			setExecutionLoops(2);
			return;
		}		
	}//endregion
	
	if (bStretchToEdge)
	{
		if (nEdgeMode==1 || nEdgeMode==8 || nEdgeMode==10)
			vecDirEdge = vecDirs[0];
		else if (nEdgeMode==2)
			vecDirEdge = vecDirs[1];
		else if (nEdgeMode==3)
			vecDirEdge = vecDirs[2];
		else if (nEdgeMode==4)
			vecDirEdge = vecDirs[3];
		else if (nEdgeMode==5)
			vecDirEdge = vecXT.dotProduct(ptCen-_Pt0)<0?vecDirs[3]:vecDirs[1];	
		else if (nEdgeMode==6)
			vecDirEdge = vecDirs[0];			
	}
	//vecDirEdge.vis(_Pt0, 131);
	
	//int bEditInPlace=_Map.getInt("directEdit");
//end trigger//endregion	
	
// identify opening shape by point in opening
	for (int j=0;j<plOpenings.length();j++) 
	{ 
		PlaneProfile pp(plOpenings[j]);
		if (pp.pointInProfile(_Pt0)==_kPointInProfile)
		{ 
			plDefining=plOpenings[j];
			_Pt0.setToAverage(plDefining.vertexPoints(true));
			break;
		}

	}
	plDefining.projectPointsToPlane(pnFace, vecZ);
	
// collect rebate values
	double dDepths[]={ dDepth, dDepth2};
	double dWidths[]={ dWidth, dWidth2};
	double dRadiuses[]={ dRadius, dRadius2};	

// the base profile
	PlaneProfile ppA(plDefining);	
	LineSeg segA = ppA.extentInDir(vecXT);
	double dXA = abs(vecXT.dotProduct(segA.ptStart()-segA.ptEnd()));
	double dYA = abs(vecYT.dotProduct(segA.ptStart()-segA.ptEnd()));
	
	Point3d ptMidA = segA.ptMid();
	
	Point3d ptsA[]=ppA.getGripVertexPoints();

// TitleComment//region
// loop rebates
	for (int a = 0; a < dDepths.length(); a++)
	{
		double depth = dDepths[a];
		double width = dWidths[a];
		double radius = dRadiuses[a];

	// skip if invalid
		if (dDepth < dEps || width < dEps)continue;

	// adjust width to radius
		double dDeltaWidth;
		if (2*radius>width)
		{
			dDeltaWidth = 2*radius - width;
			width = 2*radius;
		}

// This approach does not work for arced contours//region
//	// grow profile	by relevant side
//		PlaneProfile ppB=ppA;
//		for (int i=0;i<vecDirs.length();i++) 
//		{ 
//			Vector3d& vecDir = vecDirs[i];
//			Point3d ptsB[] = ppB.getGripEdgeMidPoints();
//			if (bStretchs[i])
//			{ 
//				Point3d ptB = ptMidA + vecDir *( .5 * abs(vecDir.dotProduct(segA.ptEnd() - segA.ptStart()))+width);
//				ptB.vis(3);
//				
//			// get closest index
//				int nInd = - 1;double dDist = dXA + dYA;
//				for (int j=0;j<ptsB.length();j++) 
//				{ 
//					double d = Vector3d(ptsB[j] - ptB).length();
//					if (d<dDist)
//					{ 
//						dDist = d;
//						nInd = j;
//					}
//					 
//				}//next j
//
//				if (nInd>-1)
//				{
//				// do not stretch arcs
//					if ( !plDefining.isOn(ptsB[nInd]))continue;
//				// stretch	
//					Vector3d vecMove = vecDir * width;
//					if (!vecDirEdge.bIsZeroLength() && vecDir.isCodirectionalTo(vecDirEdge))
//						vecMove += vecDir * U(20000);
//					ppB.moveGripEdgeMidPointAt(nInd, vecMove);	
//				}
//			} 
//		}//next i	//endregion

	// grow profile	by relevant side
		PlaneProfile ppB=ppA;
		ppB.shrink(-width);
		
	// shrink edges with no offstes
		for (int i=0;i<vecDirs.length();i++) 
		{ 
			Vector3d& vecDir = vecDirs[i];
			Point3d ptsB[] = ppB.getGripEdgeMidPoints();
			int bStretch = bStretchs[i];
			Point3d ptB = ptMidA + vecDir *( .5 * abs(vecDir.dotProduct(segA.ptEnd() - segA.ptStart()))+width);				ptB.vis(3);
			if (!bStretch)
			{ 
				Vector3d vecPerp = vecDir.crossProduct(vecZ);
				
			// moving the edge fails sometimes if connected to arcs	
				PLine pl;
				pl.createRectangle(LineSeg(ptB - vecPerp * U(10e3), ptB + vecPerp * U(10e3) - vecDir * width), vecPerp, vecDir);
				//pl.vis(2);
				ppB.joinRing(pl, _kSubtract);
			} 

		// stretch to edge
			if (bStretchToEdge)
			{
				ptsB = ppB.getGripEdgeMidPoints();
			// get closest index
				int nInd = - 1;double dDist = dXA + dYA;
				for (int j=0;j<ptsB.length();j++) 
				{ 
					double d = Vector3d(ptsB[j] - ptB).length();
					if (d<dDist)
					{ 
						dDist = d;
						nInd = j;
					}
					 
				}//next j
				if (nInd >- 1)
				{
					if ( ! vecDirEdge.bIsZeroLength() && vecDir.isCodirectionalTo(vecDirEdge))
						ppB.moveGripEdgeMidPointAt(nInd, vecDir * U(20000));
				}			
			}

			
		}//next i
	
		if (!vecDirEdge.bIsZeroLength())
			ppB.intersectWith(PlaneProfile(plEnvelope));
		
		
	// get defining polyline of this profile
		PLine plDef(vecZ);
		PLine plRings[] = ppB.allRings();
		int bIsOp[] = ppB.ringIsOpening();
		for (int r=0;r<plRings.length();r++)
			if (!bIsOp[r] && plRings[r].area()>plDef.area())
				plDef=plRings[r];
		if (!plDef.coordSys().vecZ().isCodirectionalTo(nFace*vecZ))
			plDef.flipNormal();
		//plDef.vis(3);
		ppB.vis(131);
		
		Point3d ptsB[] = ppB.getGripVertexPoints();//plDef.vertexPoints(true);//
		
	// collect segments and vecs
		Vector3d vecXSegs[0], vecYSegs[0];
		LineSeg segs[0];
		double dBulges[0];
		int bHasBulge;
		int bHasOffsets[0];
		PLine  plArcs[0];
		for (int i = 0; i < ptsB.length(); i++)
		{
			Point3d pt1 = ptsB[i];
			Point3d pt2 = ptsB[(i == ptsB.length() - 1 ? 0 : i + 1)];
			LineSeg seg(pt1, pt2);
			Point3d ptMid = seg.ptMid();
			double dBulge;
		// ARC	
			if (!plDef.isOn(ptMid))
			{
				double d1 = plDef.getDistAtPoint(pt1);//pt1.vis(1);
				if (d1==plDef.length())	d1=0;// pt1 coincides with ptStart
				double d2 = plDef.getDistAtPoint(pt2);//pt2.vis(2);
	
				PLine pl(vecZ);
				double dDistAt = (d1+d2)/2;
				
			// circles: the last point coincides with the first	
				if (d2==0 && d1>0)// && bAtOpening)
					dDistAt = (plDef.length()+d1)/2;
				
				Point3d ptX =plDef.getPointAtDist(dDistAt);	ptX.vis(2);
				
			// get radius
				Point3d ptMid = (pt1+pt2)/2;
				Vector3d vecXS = pt2-pt1;
				double s = vecXS.length();
				vecXS.normalize();
				
				Vector3d vecYH = ptX-ptMid;
				PLine(ptX, ptMid).vis(5);
				double h = vecYH.length();
				vecYH.normalize();
				
				Vector3d vecYS = vecXS.crossProduct(-vecZ*nFace);
				double r = (4*pow(h,2)+pow(s,2))/(8*h);
				double a = 2 * acos(1-h/r);
				int lr = vecYS.dotProduct(vecYH)<0?1:-1;
				double bulge = tan(lr*a/4);
//	
				Point3d ptCen = ptX-vecYH*r;//ptCen.vis(5);vecYH.vis(ptCen, 5);			
				PLine plArc(nFace*vecZ);
				plArc.addVertex(pt1);
				plArc.addVertex(pt2, bulge);
//				plArc.vis(2);
				plArcs.append(plArc);
				dBulge = bulge;
				bHasBulge = true;
				
			// append free profile
				Point3d ptsClose[] ={ pt2 - vecYH * radius, _Pt0, pt1 - vecYH * radius};
				FreeProfile fp(plArc,ptsClose);//); (pt1+pt2)/2
				fp.setDepth(depth);
				sip.addTool(fp);

			}
			else
				plArcs.append(PLine());
				
			
			Vector3d vecXSeg = pt2 - pt1;
			vecXSeg.normalize();
			Vector3d vecYSeg = vecXSeg.crossProduct(-vecZ);
			if (ppB.pointInProfile(ptMid + vecYSeg * dEps) == _kPointInProfile)
			{
				vecYSeg *= -1;
			}
			
		// find best match
			int bHasOffset;
			if (dBulge==0)// not for arcs
				for (int j=0;j<vecDirs.length();j++) 
				{ 
					if (vecDirs[j].isCodirectionalTo(vecYSeg))
					{
						bHasOffset=bStretchs[j];
						break;
					}
					 
				}//next j
			
			bHasOffsets.append(bHasOffset);
//			vecXSeg.vis(ptMid, i);
//			vecYSeg.vis(ptMid, 3);
			vecXSegs.append(vecXSeg);
			vecYSegs.append(vecYSeg);
			segs.append(seg);
			
			dBulges.append(dBulge);

			
		}
		
	// get a potential rounded contour
		PLine plContour(nFace*vecZ);
		//Point3d ptDrills[0];
		for (int i = 0; i < vecXSegs.length(); i++)
		{ 
			int previous = (i == 0 ? vecXSegs.length()-1:i-1);
			int next=(i==vecXSegs.length()-1? 0 :i+1); 
			LineSeg seg = segs[i];//seg.vis(6);
			Vector3d vecXA = vecXSegs[previous];
			Vector3d vecXB = vecXSegs[i];
			Vector3d vecYB = vecYSegs[i];
			Vector3d vecXC = vecXSegs[next];
			Point3d pt1 = seg.ptStart(), pt2 = seg.ptEnd();
//			vecXA.vis(segs[previous].ptMid(), 2);
//			vecXB.vis(segs[i].ptMid(), i);			
//			vecXC.vis(segs[next].ptMid(), 4);

		// offset first point if this and the previous has an offset
			if (bHasOffsets[i]&& bHasOffsets[previous])
				pt1 += vecXB * radius;
			if (i==0)
			{ 	
				plContour.addVertex(pt1);
				pt1.vis(i);
			}						
			else if (bHasOffsets[i] && bHasOffsets[previous])
			{ 
				double a = vecXA.angleTo(vecXB);
				double bulge = tan(nFace*a/4);
				plContour.addVertex(pt1, bulge);	
			}
			
//		// collect center of corner drill	
//			if (bHasOffsets[i] && bHasOffsets[previous] && radius>0)
//			{ 
//				Point3d ptDrill;
//				Point3d ptX = segs[previous].ptEnd() - vecXA * radius;
//				int bOk = Line(pt1, vecXA).hasIntersection(Plane(ptX, vecXB.crossProduct(vecZ)), ptDrill);
//				
//				if (bOk)
//				{
//					ptDrills.append(ptDrill);
//					ptDrill.vis(6);	
//				}
//			}
		// offset second point
			if (bHasOffsets[i]&&bHasOffsets[next])
				pt2 -= vecXB * radius;	
			pt2.vis(i);	
			
		// add bulge or straight	
			if (dBulges[i]!=0)
				plContour.addVertex(pt2, dBulges[i]);
			else
				plContour.addVertex(pt2);
			
		// close with bulge or straight	
			if (i ==vecXSegs.length()-1)
			{ 
				if (bHasOffsets[i] && bHasOffsets[next])
				{
					Point3d pt = plContour.ptStart();//pt.vis(4);
					double a = vecXB.angleTo(vecXC);
					double bulge = tan(nFace*a/4);
					plContour.addVertex(pt, bulge);
					plContour.close();
				}
				else
					plContour.close();
			}
			
		}
		//plContour.vis(3);


	// add tools
		dp.draw(plContour);
		for (int i = 0; i < ptsB.length(); i++)
		{
			Point3d pt1 = ptsB[i];
			Point3d pt2 = ptsB[(i==ptsB.length()-1?0:i+1)];
			LineSeg seg(pt1, pt2);
			Point3d ptMid = seg.ptMid();

			Vector3d vecXSeg = pt2-pt1;
			vecXSeg.normalize();
			Vector3d vecYSeg = vecXSeg.crossProduct(-vecZ);
			if (ppB.pointInProfile(ptMid+vecYSeg*dEps)==_kPointInProfile)
			{ 
				vecXSeg*=-1;
				vecYSeg*=-1;
			}

		// try to match with direction
			Vector3d vecDir = vecYSeg;
			int bStretch;
			for (int j=0;j<vecDirs.length();j++)
				if (vecDirs[j].isCodirectionalTo(vecDir))	
				{
					bStretch = bStretchs[j];
					vecDir =vecDirs[j]; 
					vecXSeg = vecDir.crossProduct(vecZT);
					break;
				}


			vecXSeg.vis(ptMid, i);
			if (bStretch)vecDir.vis(ptMid, i);
			
			double length = seg.length();
			if (bStretch && seg.length()>dEps && width>dEps && depth>dEps)
			{
				if(radius>0)
				{ 
				// make sure the tool runs completely through
					if (bStretchToEdge && vecXSeg.isParallelTo(vecDirEdge))
					{ 
						ptMid += vecDirEdge * .5*radius;
						length += radius;
					}
					
					Mortise ms(ptMid,vecXSeg, vecDir, -nFace*vecZ, length, width, depth, 0,-1,1);
					ms.setRoundType(_kExplicitRadius);
					ms.setExplicitRadius(radius);
					ms.cuttingBody().vis(a);
					sip.addTool(ms);
				}
				else
				{ 
					BeamCut bc(ptMid,vecXSeg, vecDir, vecZ, length, width, depth, 0,-1,-nFace);
					bc.setModifySectionForCnC(false);	
					bc.cuttingBody().vis(a);	
					sip.addTool(bc);
				}
				//dp.draw(PLine(pt1-(vecXSeg)*width,pt1-(vecXSeg+.5*vecDir)*width,pt1,pt2));
									
			}
		}//next i			


	}//next a


//endregion	
	
	
	
	
	
	
	
#End
#BeginThumbnail
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
AJ;5N5144Y`+*`/RYKI+*%K:Q@@8@M'&%)'3@58HH`__9
`

#End
#BeginMapX

#End