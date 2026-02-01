#Version 8
#BeginDescription
This TSL inserts an offsetted parallel house between male and female beams.

#Versions
Version 2.2 19.08.2023 HSB-19851 sharp edges on male beam when using relief option
Version 2.1 06.04.2023 HSB-18561 new option to swap the deirection of mortise extension, new grip to modify mortise depth 
Version 2.0 29.03.2023 HSB-17935 completely revised, new display, bugfix on vertical offset, freeprofile used for certain beveled operations


#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 2
#KeyWords 
#BeginContents
//region <History>
// #Versions
// 2.2 19.08.2023 HSB-19851 sharp edges on male beam when using relief option , Author Thorsten Huck
// 2.1 06.04.2023 HSB-18561 new option to swap the direction of mortise extension, new grips to modify mortise depth , Author Thorsten Huck
// 2.0 29.03.2023 HSB-17935 completely revised, new display, bugfix on vertical offset, freeprofile used for certain beveled operations , Author Thorsten Huck
/// 1.9 10.01.2023 HSB-17156: Add rounding house at male beams Author: Satoshi Sagami, Marsel Nakuci
/// <version value="1.8" date="07feb20" author="marsel.nakuci@hsbcad.com"> HSB-6129: delete tsl after distribution, remove _kRounded as not available for ParHouse, if sMortiseShape is normal, set round type to "not rounded", tool shape is passed at distribution tsl </version>
/// <version value="1.7" date="08nov17" author="florian.wuermseer@hsbcad.com"> added new props for left and right offsets, reorganized properties into categories</version>
/// <version value="1.6" date="06nov17" author="florian.wuermseer@hsbcad.com"> gaps left and right are separate options, negative gap values supported</version>
/// <version value="1.5" date="09jan17" author="florian.wuermseer@hsbcad.com"> added possibility to set offset vector and extended mortise direction</version>
/// <version value="1.4" date="18oct16" author="florian.wuermseer@hsbcad.com"> bugfix chamfered lap</version>
/// <version value="1.3" date="18oct16" author="florian.wuermseer@hsbcad.com"> bugfix extended mortise</version>
/// <version value="1.2" date="18jul16" author="florian.wuermseer@hsbcad.com"> added properties, to select round type of the house and set a gap in width</version>
/// <version value="1.1" date="09mar16" author="florian.wuermseer@hsbcad.com"> added property, to select different housing-shapes</version>
/// <version value="1.0" date="09mar16" author="florian.wuermseer@hsbcad.com"> initial version</version>

/// <insert Lang=en>
/// Select male and female beams
/// </insert>

// <summary Lang=en>
// This TSL inserts an offsetted parallel house between male and female beams.
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "Offsetted_Parallel_Housing")) TSLCONTENT
//endregion



//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;

	String tDefault =T("|_Default|");
	String tLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String tYes = T("|Yes|");
	String tNo = T("|No|");
	
//region Color and view	
	int bIsDark;if(!bDebug){int n = getBackgroundTrueColor();bIsDark = ((rgbR(n) + rgbB(n) + rgbG(n)) / 3 < 127);}
	int grey = bIsDark?rgb(199,200,202):rgb(99,100,102);
	int white = bIsDark?rgb(255,255,255):rgb(0,0,0);	
	
	int lightblue = rgb(204,204,255);
	int blue = rgb(69,84,185);	
	int darkblue = rgb(26,50,137);	
	int yellow = rgb(241,235,31);
	int darkyellow = rgb(254, 204, 102);
	int orange = rgb(242,103,34);
	int red = rgb(205,32,39);
	int purple = rgb(147,39,143);
	int petrol = rgb(16,86,137);
	int green = rgb(19,155,72);	

	Vector3d vecXView = getViewDirection(0);
	Vector3d vecYView = getViewDirection(1);
	Vector3d vecZView = getViewDirection(2);
	double dViewHeight = getViewHeight();	
//endregion 	
	
//end Constants//endregion

//region Properties
category =  T("|Tool shape|");
	String sMilToTops[] = {tNo, tYes};
	String sMillToTopName = "A - " + T("|Extend mortise|");	
	PropString sMillToTop (nStringIndex++, sMilToTops, sMillToTopName);
	sMillToTop.setCategory (category);
	sMillToTop.setDescription(T("|Extend mortise to the top edge of female beam|"));
	int bMillToTop = sMillToTop == tYes;

	String sMortiseTypes[] = {T("|Minimum|"), T("|Normal|"), T("|Maximum|")};
	String sMortiseTypeName = "B - " + T("|Mortise shape|");	
	PropString sMortiseType (nStringIndex++, sMortiseTypes, sMortiseTypeName);
	sMortiseType.setCategory(category);
	sMortiseType.setDescription(T("|Shape of the mortise tool|") + "\n\n" + 
									T("|Minimal = All four sides of the beam will be milled|") + "\n" + 
									T("|Normal = At the 'inner' side of the angled connection, the pocket will get a chamferd edge.|") + "\n" + 
									T("|Maximal = The pocket will get maximum size, so that no air gap results --> maximum two sides of the male beam will be milled.|"));
	int nMortiseType = sMortiseTypes.find(sMortiseType);

	String sToolShapeName = "C - " + T("|Round Type|");
	String sToolShapes[] = {T("|not rounded|"), T("|round|"), T("|relief|"), T("|rounded with small diameter|"), T("|relief with small diameter|")};
	int nRoundTypes[] = {_kNotRound,_kRound,_kRelief,_kRoundSmall,_kReliefSmall};
	
	PropString sToolShape(nStringIndex++,sToolShapes,sToolShapeName);
	sToolShape.setCategory(category);
 	sToolShape.setDescription(T("|Defines the rounding type of the mortise.|") + " (" + T("|Shape 'Normal' is always 'not rounded'|") + ")");
	int nToolShape = sToolShapes.find(sToolShape,4);
	int nRoundType = nRoundTypes[nToolShape];	

	String sDepthName = "D - " + T("|Mortise depth|");	
	PropDouble dDepth (1, U(20), sDepthName);
	dDepth.setCategory (category);
	dDepth.setDescription(T("|Defines the depth of the mortise.|"));	
	if (dDepth <= 0)
	{
		dDepth.set(U(1));
		reportMessage(T("|Only positive values possible|") + "   --->   " + T("|Value corrected to|" ) + " " + dDepth);
	}


category = T("|Tool offsets|");
	String sZOffName = "E - " + T("|Offset vertical|");	
	PropDouble dZOff (0, U(30), sZOffName);
	dZOff.setCategory (category);
	dZOff.setDescription(T("|Defines the vertical offset of the connection.|"));
	
	String sROffName = "F - " + T("|Offset right|");	
	PropDouble dROff (5, U(0), sROffName);
	dROff.setCategory (category);
	dROff.setDescription(T("|Defines the offset from the right side of the connection.|"));
	
	String sLOffName = "G - " + T("|Offset left|");	
	PropDouble dLOff (6, U(0), sLOffName);
	dLOff.setCategory (category);
	dLOff.setDescription(T("|Defines the offset from the left side of the connection.|"));



category = T("|Tool gaps|");
	String sAddDepthName = "H - " + T("|Gap in depth|");	
	PropDouble dAddDepth (2, U(5), sAddDepthName);
	dAddDepth.setCategory (category);
	dAddDepth.setDescription(T("|Defines the gap in depth of the mortise.|"));
	
	String sGapRightName = "I - " + T("|Gap right|");	
	PropDouble dGapRight (3, U(0), sGapRightName);
	dGapRight.setCategory (category);
	dGapRight.setDescription(T("|Defines the gap at the right side of the mortise.|"));
	
	String sGapLeftName = "J - " + T("|Gap left|");	
	PropDouble dGapLeft (4, U(0), sGapLeftName);
	dGapLeft.setCategory (category);
	dGapLeft.setDescription(T("|Defines the gap at the left side of the mortise.|"));

//End Properties//endregion 

//region Functions #func
//	void drawPLine(PLine pl, double offset,  int color, int fillTransparent)
//	{ 
//		Display dp(color);
//		pl.transformBy(pl.coordSys().vecZ() * offset);
//		if (fillTransparent>0)
//			dp.draw(PlaneProfile(pl), _kDrawFilled, fillTransparent);
//		else
//			dp.draw(pl);
//	}
//	void drawPlaneProfile(PlaneProfile pp, double offset,  int color, int fillTransparent)
//	{ 
//		Display dp(color);
//		pp.transformBy(pp.coordSys().vecZ() * offset);
//		if (fillTransparent>0)
//			dp.draw(pp, _kDrawFilled, fillTransparent);
//		else
//			dp.draw(pp);
//	}	
//endregion 

//region OnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		if (_kExecuteKey.length()>0 && TslInst().getListOfCatalogNames(scriptName()).findNoCase(_kExecuteKey,-1)>-1)
			setPropValuesFromCatalog(_kExecuteKey);						
	// standard dialog	
		else	
			showDialog();
		

	// select (multiple) beams to insert the connector
		Beam bmMales[0], bmFemales[0], beams[0];
		PrEntity ssMale(T("|Select male beams|"), Beam());
		if (ssMale.go())
			bmMales = ssMale.beamSet();
		
		PrEntity ssFemale(T("|Select female beams|"), Beam());
		if (ssFemale.go())
		{
		// avoid males to be added to females again
			beams = ssFemale.beamSet();
			for (int i=0;i<beams.length();i++)
				if(bmMales.find(beams[i])<0)
					bmFemales.append(beams[i]);	
		}	


	// create TSL
		TslInst tslNew;				Vector3d vecXsl= _XU;			Vector3d vecYsl= _YU;
		GenBeam gbsTsl[2];			Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
		int nProps[]={};			double dProps[]={};				String sProps[]={};
		Map mapTsl;	
		
		for (int i=0;i<bmMales.length();i++) 
		{ 
			Beam male = bmMales[i]; 
			gbsTsl[0]=male;
			Vector3d vecXM = male.vecX();

		// loop females
			for (int j=0;j<bmFemales.length();j++)
			{
				Beam female =bmFemales[j];	
				Vector3d vecXF = female.vecX();
				if (vecXM.isParallelTo(vecXF))continue;
				
				LineBeamIntersect lbi(male.ptCen(), vecXM, female);
				
				Point3d ptI = lbi.pt1();
				Point3d ptImin = female.ptCen();
				Point3d ptImax = female.ptCen();
				ptImin.transformBy(-vecXF * female.solidLength() * .5);
				ptImax.transformBy(vecXF * female.solidLength() * .5);
				double dInt = vecXF.dotProduct(ptI-female.ptCen());
				double dIntMin = vecXF.dotProduct(ptImin - female.ptCen());
				double dIntMax = vecXF.dotProduct(ptImax - female.ptCen());

				if (dInt <= dIntMin || dInt >= dIntMax)continue;
				if (!lbi.bHasContact())continue;
				
				gbsTsl[1] = female;
				tslNew.dbCreate(scriptName() , vecXsl ,vecYsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
				
			} // next j


		}//next i

		eraseInstance();
		return;
	}			
//endregion 


//region Standards
	Beam bm0 = _Beam[0];
	Beam bm1 = _Beam[1];
	
	Vector3d vecX0 = bm0.vecX();
	Vector3d vecY0 = bm0.vecY();
	Vector3d vecZ0 = bm0.vecZ();
	Vector3d vecX1 = bm1.vecX();
	Vector3d vecY1 = bm1.vecY();
	Vector3d vecZ1 = bm1.vecZ();
	
	Point3d ptCen0 = bm0.ptCen();
	Point3d ptCen1 = bm1.ptCen();
	
	double dY0 = bm0.dW();
	double dZ0 = bm0.dH();
	
	Body bd1 = bm1.envelopeBody(false, true);

	int bSwapMortiseExtension = _Map.getInt("SwapMortiseExtension");
	addRecalcTrigger(_kGripPointDrag, "_Grip");
	Point3d ptMid = _Pt0;
//endregion 



//region Contact
	CoordSys cs = CoordSys(_Pt0, vecX1, vecX1.crossProduct(-_Z1), _Z1);
	PlaneProfile pp0(cs);
	{
		Vector3d vec = .5 * (vecY0 * dY0 + vecZ0 * dZ0);
		pp0.createRectangle(LineSeg(ptCen0 - vec, ptCen0 + vec), vecY0, vecZ0);
	}
	pp0.project(_Plf, _X0, dEps);
	Point3d ptsC[] = pp0.getGripVertexPoints();
	
	
	PlaneProfile pp0Min = pp0;
	pp0Min.project(Plane(_Pt0 + _Z1 * (dDepth+dAddDepth), _Z1), _X0, dEps);
	pp0Min.intersectWith(pp0);
	

	PlaneProfile pp1(cs);
	pp1 = bd1.extractContactFaceInPlane(_Plf, dEps);
	//drawPlaneProfile(pp1,0, 4, 80);//#func
	
	PlaneProfile ppc = pp1;
	ppc.intersectWith(pp0);
	
	if (ppc.area()<pow(dEps,2) ||ptsC.length()!=4)
	{ 
		reportMessage(TN("|No tool contact found|"));		
		eraseInstance();
		return;
	}
//	ptsC[0].vis(1);
//	ptsC[1].vis(2);
//	ptsC[2].vis(3);
//	ptsC[3].vis(4);


	int bSwapYZ = bm0.vecD(_Y1).isParallelTo(vecY0);
	Point3d pt3 = ptsC[bSwapYZ?1:2];	pt3.vis(3);	
	Point3d pt2 = ptsC[bSwapYZ?0:1];	pt2.vis(2);	
	Vector3d vecX = pt3-pt2;
	double dX = vecX.length(); vecX.normalize();

	Point3d pt1 = ptsC[bSwapYZ?3:0];	pt1.vis(1);
	Vector3d vecY =pt2-pt1;
	double dY = vecY.length(); vecY.normalize();
	
// swap milling extension direction	//HSB-18561
	if (bMillToTop && bSwapMortiseExtension)
	{ 
		Vector3d vec = vecX;
		vecX = vecY;
		vecY = vec;
	}	

	
	if (!vecY.isPerpendicularTo(_ZW) && vecY.dotProduct(_ZW)<0)
	{
		vecY *= -1;
	}
	if (vecX.crossProduct(_Z1).dotProduct(vecY)<0)
		vecX *= -1;

	if (nMortiseType==0)
	{ 
		Point3d pt;
		Line(pp0Min.ptMid(), _Z1).hasIntersection(_Plf, pt);
		
		Vector3d vecXN = bm0.vecD(vecX).crossProduct(_Z1).crossProduct(-_Z1); vecXN.normalize();
		
		ptMid += vecXN * vecXN.dotProduct(pt - ptMid); // not excatly right if minimal shape is requested
		LineSeg segs[0];
		segs = pp0Min.splitSegments(LineSeg(ptMid - vecX * U(10e3), ptMid + vecX * U(10e3)), true);
		if (segs.length()>0)
			dX = segs.first().length();
//		segs = pp0Min.splitSegments(LineSeg(ptMid - vecY * U(10e3), ptMid + vecY * U(10e3)), true);
//		if (segs.length()>0)
//			dY = segs.first().length();	
		//drawPlaneProfile(pp0Min,0, 1, 90);//#func
	}
//	else if (nMortiseType==1 && bDebug)
//		drawPlaneProfile(pp0,0, 2, 90);//#func
//	else if (nMortiseType==2 && bDebug)
//		drawPlaneProfile(pp0,0, 3, 90);//#func
	
	
	ptMid.vis(4);
	
	Point3d ptTop = ptMid+ vecY * .5 * dY;//pp0.ptMid()
	Point3d ptBot = ptMid - vecY * .5 * dY;
	vecX.vis(ptMid,1);
	vecY.vis(ptMid,3);
	_X1.vis(_Pt0,40);
	_Y1.vis(_Pt0,40);

	Vector3d vecXA = vecX;
	Vector3d vecYA = _Z1.crossProduct(vecXA);	vecXA.vis(pt3,1); vecYA.vis(pt3,3);
	Vector3d vecXB = vecY;
	Vector3d vecYB = _Z1.crossProduct(vecXB);	vecXB.vis(pt1,1); vecYB.vis(pt1,3);


// max interscetion on top face of female beam
	Point3d ptTopF1, ptTopF2;
	Plane pnTopF(ptCen1 + bm1.vecD(vecY) * .5 * bm1.dD(vecY), bm1.vecD(vecY));
	Line(ptMid - vecX * (.5 * dX+dGapLeft), vecY).hasIntersection(pnTopF, ptTopF1);
	Line(ptMid + vecX * (.5 * dX+dGapRight), vecY).hasIntersection(pnTopF, ptTopF2);
	ptTopF1.vis(171);
	ptTopF2.vis(171);
	




//endregion 

//region Grip Management
	
	for (int i=0;i<_Grip.length();i++) 
	{ 
		
		Display dp(-1);
		dp.trueColor(darkyellow, 70);

		Grip& grip = _Grip[i]; 
	    Vector3d vecXG = vecXView;
		Point3d ptLoc = grip.ptLoc();
		int n = Grip().indexOfMovedGrip(_Grip);
		
		Point3d ptm = _Map.hasPoint3d("ptMid") ? _Map.getPoint3d("ptMid") : _Pt0;
	// depth grip
		if (i==0)
		{ 
			grip.setPtLoc(Line(ptm, _Z1).closestPointTo(grip.ptLoc()));
			vecXG= _Z1.crossProduct(vecZView).crossProduct(-vecZView);
			
			double d = _Z1.dotProduct(ptLoc - _Pt0);
			if (d>dEps)
			{ 
				if (_bOnGripPointDrag && _kExecuteKey == "_Grip"  && n==0)//
				{
					PlaneProfile pp = bm0.realBody().extractContactFaceInPlane(Plane(ptm, _Z1), dEps);
					Point3d pts[] = pp.getGripVertexPoints();
					Vector3d vec = _Z1 * _Z1.dotProduct(ptLoc - (_Pt0 + _Z1 * dDepth));
					pp.transformBy(vec);
					
					
					dp.draw(pp,_kDrawFilled);
					dp.transparency(0);
					for (int i=0;i<pts.length();i++) 
						dp.draw(PLine (pts[i], pts[i] + vec));
					
					dp.draw(pp);
					return;
				}
				
				if (_kNameLastChangedProp == "_Grip")
				{ 
					//reportMessage("\nchanging depth " +_kNameLastChangedProp);
					dDepth.set(d);
				}			
			}			
			
		}
	// Z-Offset grip
		else if (i == 1)
		{
			grip.setPtLoc(Line(ptBot, vecY).closestPointTo(ptLoc));
			vecXG= vecY.crossProduct(vecZView).crossProduct(-vecZView);
			
			double d = vecY.dotProduct(ptLoc - ptBot);
			if (d <= dEps) 
			{
				d = 0;
				ptLoc = ptBot;
			}
			else if (vecY.dotProduct(ptLoc-ptTop)>-U(20))
			{ 
				ptLoc = ptTop-vecY*U(20);
				d = vecY.dotProduct(ptLoc - ptBot);
				dp.trueColor(red, 50);					
			}
			{ 
				if (_bOnGripPointDrag && _kExecuteKey == "_Grip"  && n==1)//
				{
					PlaneProfile pp = bm0.realBody().extractContactFaceInPlane(Plane(ptBot+vecY*dZOff, vecY), dEps);
					Point3d pts[] = pp.getGripVertexPoints();
					Vector3d vec = vecY * vecY.dotProduct(ptLoc - (ptBot + vecY*dZOff));
					pp.transformBy(vec);

					dp.draw(pp,_kDrawFilled);
					dp.transparency(0);
					for (int i=0;i<pts.length();i++) 
						dp.draw(PLine (pts[i], pts[i] + vec));
					
					dp.draw(pp);
					return;
				}
				
				if (_kNameLastChangedProp == "_Grip")
				{ 
					dZOff.set(d);
					reportMessage("\nchanging dZOff " +dZOff);
				}			
			}


		}
		Vector3d vecYG = vecXG.crossProduct(-vecZView);	
	    grip.setVecX(vecXG);
	    grip.setVecY(vecYG);


	}//next i
	

//endregion 



//region Tools
	double dYT;
	if (bMillToTop)
	{ 
		double d;
		d= vecY.dotProduct(ptTopF1 - ptMid);
		if (d > dYT)dYT = d;
		d= vecY.dotProduct(ptTopF2 - ptMid);
		if (d > dYT)dYT = d;
	}	



//region Female Tools
	if (dY-dZOff>dEps)
	{ 
		double dXTool = dX + dGapLeft + dGapRight-dLOff-dROff;
		double dYTool = (dYT+dY)-abs(dZOff);

	//Minimal or maxmal: ParHouse
		if (nMortiseType!=1)
		{ 
			Point3d pt = ptMid+vecY*.5*(dYT+dZOff)+vecX*.5*(dGapRight-dGapLeft);		pt.vis(4);
			ParHouse ph(pt,vecX,vecY,_Z1,dXTool,dYTool,dDepth+dAddDepth,0,0,1);
			ph.setRoundType(nRoundType);
			bm1.addTool(ph);		
			
		}
	//Normal: Chamfered Lap
		else if (nMortiseType==1)
		{ 
			Point3d pt = ptMid+vecY*.5*(dYT+dZOff)+vecX*.5*(dGapRight-dGapLeft);		//pt.vis(4);
			ChamferedLap cl(pt,vecX,vecY,_Z1,dXTool,dYTool,dDepth+dAddDepth,0,0,1,_X0);
			//cl.cuttingBody().vis(2);
			bm1.addTool(cl);			
		}
	}	
	
	
// Get resulting female tool shape	
	PlaneProfile ppToolShapeF = pp1;
	ppToolShapeF.subtractProfile(bm1.realBody().extractContactFaceInPlane(_Plf, dEps));
	//ppToolShapeF.intersectWith(pp0);
	PLine rings[] = ppToolShapeF.allRings(true, false);
	PLine plToolShapeF;
	for (int r=0;r<rings.length();r++) 
	{ 
		PlaneProfile pp(rings[r]);
		if (pp.pointInProfile(ptMid)==_kPointInProfile)
		{ 
			ppToolShapeF = pp;
			plToolShapeF = rings[r];
			break;
		}	 
	}//next r	
	//drawPLine(plToolShapeF,0, 4, 80);//#func
	
	
	
//endregion 


//region Male Tools
	int bHasRelief = nRoundType != 2 || nRoundType != 4;
	if (nMortiseType!=1 && !bHasRelief )
	{ 
		
		if (vecY.isParallelTo(bm1.vecD(vecY)))
		{ 
			Point3d pt = ptMid + vecY * .5 * (dYT + dZOff) + vecX * .5 * (dGapRight - dGapLeft); pt.vis(40);
			
			double dXTool = dX -dLOff-dROff;// dGapLeft - dGapRight;//-dLOff-dROff;//
			double dYTool = (dYT+dY)-abs(dZOff);		
	
			Vector3d vecYN = vecY;
			Vector3d vecXN = vecYN.crossProduct(_Z1);
			
			House hs(pt, vecXN, vecYN, _Z1, dXTool, dYTool, dDepth, 0,0,1);
			if (nRoundType!=2 && nRoundType!=4)
				hs.setRoundType(nRoundType);
			hs.setEndType(_kMaleEnd);
			//hs.cuttingBody().vis(252);	
			Body bd(pt, vecXN, vecYN, _Z1, dXTool, dYTool, dDepth, 0,0,1);
			bd.vis(3);
			
			bm0.addTool(hs, bDebug ? 0 : _kStretchOnToolChange);			
		}
		else if (plToolShapeF.length()>dEps)
		{ 
			if (plToolShapeF.coordSys().vecZ().dotProduct(_Z1)<0)
				plToolShapeF.flipNormal();	

			bm0.addTool(Cut(ptMid+_Z1*dDepth,_Z1), bDebug ? 0 : _kStretchOnToolChange);
			
		// a closed plolyline seems not be accepted as endtool definition	
			Point3d ptStart =plToolShapeF.ptStart();
			plToolShapeF.trim(dEps, false);
			
			//plToolShapeF.reverse();
			plToolShapeF.addVertex(ptStart + plToolShapeF.getTangentAtPoint(ptStart) * U(50));
			//plToolShapeF.reverse();
			

			plToolShapeF.transformBy(_Z1 * dDepth);
			plToolShapeF.vis(2);

			FreeProfile fp(plToolShapeF,_kRight);
			fp.setDepth(dDepth);
			fp.setMachinePathOnly(true);
			fp.setCncMode(_kUniversalMill);
			//fp.cuttingBody().vis(3);
			bm0.addTool(fp);

		}
		
		

	}
// stretch male
	else
	{ 
		bm0.addTool(Cut(ptMid+_Z1*dDepth,_Z1), bDebug ? 0 : _kStretchOnToolChange);
		
		if (_X0.dotProduct(vecY)>0)
		{
			Vector3d vec = bm0.vecD(vecY).crossProduct(_Z1).crossProduct(-_Z1);	vec.normalize();
			vec.vis(ptTop,2);
			bm0.addTool(Cut(ptTop,vec), 0);
		}			
		
	}

//	else if (_X0.dotProduct(vecY)<0)
//	{
//		Vector3d vec = bm0.vecD(vecY).crossProduct(_Z1).crossProduct(-_Z1);	vec.normalize();
//		vec.vis(ptBot,2);
//		bm0.addTool(Cut(ptBot,-vec), 0);		
//	}
	
// Beamcut Bottom	
	if (dZOff>0 || bHasRelief)
	{ 
		Point3d pt = ptMid - vecY * (.5 * dY - dZOff);
		BeamCut bc(pt, vecXA, vecYA, _Z1, U(2000), U(2000), dDepth, 0,1,1);//dZOff*2
		bc.cuttingBody().vis(252);
		bm0.addTool(bc);
	}	
// Beamcut Top	
	if (dZOff<0 || bHasRelief)
	{ 
		Point3d pt = ptMid+vecY*(.5*dY+dZOff);
		BeamCut bc(pt, vecXA, vecYA, _Z1, U(2000), U(2000), dDepth, 0,-1,1);//abs(dZOff)*2
		bc.cuttingBody().vis(7);
		bm0.addTool(bc);
	}
	
// Beamcut Left
	if (dLOff>0 || bHasRelief)
	{ 
		Point3d pt = ptMid-vecX*.5*dX+vecXA*dLOff;			
		BeamCut bc(pt, vecXB, vecYB, _Z1, U(2000), U(2000), dDepth*2, 0,-1,1);
		bc.cuttingBody().vis(2);
		bm0.addTool(bc);
	}
	// Cut left
	else if (_X0.crossProduct(_Z1).dotProduct(vecY)<0)
	{ 
		Point3d pt = ptMid-vecX*.5*dX; // +vecXA*dLOff;
		Vector3d vec = bm0.vecD(vecX).crossProduct(_Z1).crossProduct(-_Z1);	vec.normalize();
		if (!vec.isParallelTo(bm0.vecD(vec)))
		{
			(-vec).vis(pt,4);
			bm0.addTool(Cut(pt,-vec), 0);
		}
	}
	
// Beamcut Right
	if (dROff>0 || bHasRelief)
	{ 
		Point3d pt = ptMid+vecX*.5*dX-vecXA*dROff;			
		BeamCut bc(pt, vecXB, vecYB, _Z1, U(2000), U(2000), dDepth*2, 0,1,1);
		bc.cuttingBody().vis(3);
		bm0.addTool(bc);
	}		
	// Cut right
	else if (_X0.crossProduct(_Z1).dotProduct(vecY)>0)
	{ 
		Point3d pt = ptMid+vecX*.5*dX; // +vecXA*dLOff;
		Vector3d vec = bm0.vecD(vecX).crossProduct(_Z1).crossProduct(-_Z1);	vec.normalize();
		if (!vec.isParallelTo(bm0.vecD(vec)))
		{
			(vec).vis(pt,4);
			bm0.addTool(Cut(pt,vec), 0);
		}
	}	
	
//endregion 

//END Tools //endregion 

//region Display
	Display dp(-1);
	double d = bm0.solidLength();;
	PlaneProfile pp = bm0.realBody().extractContactFaceInPlane(Plane(_Pt0+_Z1*dDepth, _Z1), dEps);
	dp.draw(pp,_kDrawFilled, 95);
	dp.draw(pp);
	dp.draw(PLine(ptMid, ptMid+ _Z1 * dDepth));
	if (dZOff>0)
		dp.draw(PLine(ptBot, ptBot+ vecY* dZOff));
	PLine circle;
	circle.createCircle(ptMid+ _Z1 * dDepth, _Z1, pp.extentInDir(vecX).length() * .01);
	dp.draw(circle);
	_Map.setPoint3d("ptMid", ptMid+ _Z1 * dDepth);
//endregion 

//region Add Grips
	if (_Grip.length()<1)
	{ 
	    Grip grip(ptMid+ _Z1 * dDepth);
	    grip.setShapeType(_kGSTDiamond);
	    grip.setName("Depth");
	    grip.setToolTip(T("|Move to adjust the tool depth|"));
	    grip.setVecX(_Z1);
	    //grip.setVecY();
	    grip.setColor(4);
	 	grip.setIsStretchPoint(false);
	 	grip.addHideDirection(_Z1);
	 	grip.addHideDirection(-_Z1);	 	
	 	_Grip.append(grip);
	}
	if (_Grip.length()<2)
	{ 
		Point3d pt = ptBot + vecY * dZOff;
		pt.vis(2);
	    Grip grip(ptBot + vecY * dZOff);
	    grip.setShapeType(_kGSTDiamond);
	    grip.setName("OffsetY");
	    grip.setToolTip(T("|Move to adjust the vertical offset|"));
	    grip.setVecX(vecY);
	    //grip.setVecY();
	    grip.setColor(4);
	 	grip.setIsStretchPoint(false);
	 	grip.addHideDirection(vecY);
	 	grip.addHideDirection(-vecY);	 	
	 	_Grip.append(grip);
	}	
//endregion 



//region Trigger SwapMortiseExtension
	String sTriggerSwapMortiseExtension = T("|Swap Mortise Extension|");
	if (bMillToTop)addRecalcTrigger(_kContextRoot, sTriggerSwapMortiseExtension );
	if (_bOnRecalc && _kExecuteKey==sTriggerSwapMortiseExtension)
	{
		bSwapMortiseExtension =! bSwapMortiseExtension;
		_Map.setInt("SwapMortiseExtension", bSwapMortiseExtension);
		setExecutionLoops(2);
		return;
	}//endregion	


#End
#BeginThumbnail
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
*5.1FMRBB@#__V=DM
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
        <int nm="BreakPoint" vl="588" />
        <int nm="BreakPoint" vl="549" />
        <int nm="BreakPoint" vl="625" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19851 sharp edges on male beam when using relief option" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="8/19/2023 9:04:00 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18561 new option to swap the deirection of mortise extension, new grip to modify mortise depth" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="4/6/2023 3:52:35 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17935 completely revised, new display, bugfix on vertical offset, freeprofile used for certain beveled operations" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="3/29/2023 3:31:26 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End