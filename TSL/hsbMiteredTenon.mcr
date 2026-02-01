#Version 8
#BeginDescription
<Version>
Version value="1.0" date="Date" author="david.delombaerde@hsbcad.com"

<Insert>
Select 1 or 2 beams they can be mitered or parallel. 
Define the geometric, alignment and tolerance properties 
of the tenon connection and press Ok.

<Summary>
This tsl creates a tenon connection on two beams. These beams can be mitred or they can be parallel.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
/// <History>//region
/// <version value="1.0" date="Date" author="david.delombaerde@hsbcad.com"> intial version </version>
/// </History>

/// <insert Lang=en>
/// Select 1 or 2 beams they can be mitred or parallel. 
/// Define the geometric, alignment and tolerance properties 
/// of the tenon connection and press Ok.
/// </insert>

/// <summary Lang=en>
/// This tsl creates a tenon connection on two beams. These beams can be mitred or they can be parallel.
/// </summary>

//endregion

//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
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
	Point3d tmPt = _Pt0;
//end constants//endregion

//region Properties

//region Properties Geometry

	category = T("|Geometry|");
		
	String sWidthName=T("|Width|");	
	PropDouble dWidth(nDoubleIndex++, U(0), sWidthName);	
	dWidth.setDescription(T("|Defines the Width|"));
	dWidth.setCategory(category);
	
	String sDepthName=T("|Depth|");	
	PropDouble dDepth(nDoubleIndex++, U(0), sDepthName);	
	dDepth.setDescription(T("|Defines the Depth|"));
	dDepth.setCategory(category);
	
	String sShapeName=T("|Shape|");
	int nShapes[] = { _kNotRound, _kRound, _kRounded};
	String sShapes[] = { T("|Rectangular|" ), T("|Round|"  ), T("|Rounded|" )};
	PropString sShape(1, sShapes, sShapeName);	
	sShape.setDescription(T("|Defines the Shape|"));
	sShape.setCategory(category);

//End Properties Geometry//endregion 

//region Properties Alignment
	
	category = T("|Alignment|");
	
	String sOff1Name=T("|Offset| 1");	
	PropDouble dOff1(nDoubleIndex++, U(0), sOff1Name);	
	dOff1.setDescription(T("|Defines the Off1|"));
	dOff1.setCategory(category);
	
	String sOff2Name=T("|Offset| 2");	
	PropDouble dOff2(nDoubleIndex++, U(0), sOff2Name);	
	dOff2.setDescription(T("|Defines the Off2|"));
	dOff2.setCategory(category);
	
	String sOffsetAxisName=T("|Offset from Axis|");	
	PropDouble dOffsetAxis(nDoubleIndex++, U(0), sOffsetAxisName);	
	dOffsetAxis.setDescription(T("|Defines the OffsetAxis|"));
	dOffsetAxis.setCategory(category);
	
	String sOrientationName=T("|Orientation|");	
	String sOrientations[] = { T("|Parellel to female beam|"), T("|Perpendicular to female beam|")};
	PropString sOrientation(nStringIndex++, sOrientations, sOrientationName);	
	sOrientation.setDescription(T("|Defines the Orientation|"));
	sOrientation.setCategory(category);


//End Properties Alignment//endregion 

//region Properties Tolerance

	category = T("|Tolerance|");
	
	String sToleranceLengthLeftName=T("|Left|");	
	PropDouble dToleranceLengthLeft(nDoubleIndex++, U(0), sToleranceLengthLeftName);	
	dToleranceLengthLeft.setDescription(T("|Defines the tolerance on the left side|"));
	dToleranceLengthLeft.setCategory(category);
	
	String sToleranceLengthRightName=T("|Right|");	
	PropDouble dToleranceLengthRight(nDoubleIndex++, U(0), sToleranceLengthRightName);	
	dToleranceLengthRight.setDescription(T("|Defines the tolerance on the right side|"));
	dToleranceLengthRight.setCategory(category);
	
	String sGapName=T("|Tolerance on depth|");	
	PropDouble dGap(nDoubleIndex++, U(0), sGapName);	
	dGap.setDescription(T("|Defines the tolerance in depth|"));
	dGap.setCategory(category);
	
	String sGapLengthName=T("|Gap on length|");	
	PropDouble dGapLength(nDoubleIndex++, U(0), sGapLengthName);	
	dGapLength.setDescription(T("|Defines the gap on length|"));
	dGapLength.setCategory(category);

//End Properties Tolerance//endregion 	

//End Properties//endregion 
				
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
		
		// Prompt user for selecting beams
		PrEntity ssE(T("|Select 1 or 2 beam(s)|"), Beam());
		if (ssE.go())
			_Beam.append(ssE.beamSet());	
		
		// Beam set only consist of 1 beam, ask the user for a point
		// on the single beam and the cut the beam in 2.
		if(_Beam.length() == 1)
		{ 
			_Pt0 = getPoint(T("|Select insertion point for the tenon connection.|"));			
		  	 _Beam.append(_Beam[0].dbSplit(_Pt0, _Pt0));
		}
		else
		{ 
			// Set the _Pt0 if beam count is 2, in the beginning the _Pt0 is located 
			// on the WUCS (0,0,0). You need to put it on the intersection
			// of the two beams.
			Point3d ptCen = _Beam[0].ptCen();
			Point3d ptMid = (ptCen+ _Beam[1].ptCen()) * .5;
			Vector3d vecX = _Beam[0].vecX();
			if (vecX.dotProduct(ptMid - ptCen) < 0)vecX *= -1;
			_Pt0 = ptCen + vecX * _Beam[0].dL() * .5;
		}
					
		return;
	}	
	
// end on insert	__________________//endregion

//region Check beamset and set first variables
	
	// Check if beam set has 2 beams otherwise send message and return.
	if (_Beam.length()<2)
	{ 
		reportMessage("\n"+ scriptName() + ": "  + T("|This tool requires at least two beams.|") +T("|Tool will be deleted.|"));
		eraseInstance();
		return;	
	}

	// Check if the 2 beams are parellel to each other
	Beam bm0 = _Beam[0];
	Beam bm1 = _Beam[1];
	Point3d ptCen0 = bm0.ptCen();
	Point3d ptCen1 = bm1.ptCen();	
	Vector3d vecX0 = bm0.vecX(); 		
	Vector3d vecX1 = bm1.vecX();		

	int bIsParallel = vecX0.isParallelTo(vecX1);
	Point3d pt = _Pt0;
	_Pt0.vis(1);	
	
	Vector3d vecX = bm0.vecX();
	if (vecX.dotProduct(ptCen1 - ptCen0) < 0)
	{
		vecX *= -1;
	}
	
	if (_kNameLastChangedProp=="_Pt0" && _Map.hasVector3d("vecPt0"))
	{ 
		Point3d ptMax0 = ptCen0 - vecX * .5 * bm0.dL();	
		double d0 = vecX.dotProduct(_Pt0-ptMax0);
		Point3d ptMax1 = ptCen1 + vecX * .5 * bm1.dL();	
		double d1 = vecX.dotProduct(ptMax1 - _Pt0);
		
		if (d0<0 || d1 < 0)
		{ 
			_Pt0 = _PtW+_Map.getVector3d("vecPt0");
		}
	}
	
	Point3d ptOld = _PtW + _Map.getVector3d("vecPt0");
	
	// Get intersection point of the two beams.
	// If the beams are parellel just get the closest point to _Pt0 through centerline of male beam.
	if (!bIsParallel)
	{ 
		int bOk = Line(ptCen0, vecX0).hasIntersection(Plane(ptCen1, bm1.vecD(vecX0)), pt);
		_Pt0 = pt;		
	}
	else
	{
		_Pt0 = _L0.closestPointTo(_Pt0);			
		pt = (ptCen0 + ptCen1) / 2;							
		if (vecX0.dotProduct(pt - ptCen0) < 0) vecX0 *= -1;
		//int bOkP = Line(ptCen0, vecX0).hasIntersection(Plane(ptCen1, bm1.vecD(vecX0)), pt);
	}

	// Check the direction of the X vector of male beam 
	// to the center point of male beam.
	if (vecX0.dotProduct(_Pt0 - ptCen0) < 0) vecX0 *= -1;
	
	// Check if the the X vector of female beam
	// to the center point of female beam
	if (vecX1.dotProduct(_Pt0 - ptCen1) < 0) vecX1 *= -1;
	
	// Visualize vectors
	vecX0.vis(ptCen0, 1);
	vecX1.vis(ptCen1, 2);
	
//End Check beamset and set first variables//endregion 

//region Validate set and get standards
	
	// Get the CoordSys of the mitre
	Vector3d vecXM, vecYM, vecZM;
	
	// If beams are not parellel
	if (!bIsParallel)
	 { 
		vecXM= vecX0 + vecX1;
		vecXM.normalize();
		vecYM = vecX0.crossProduct(vecX1);
		vecYM.normalize();
		vecZM = vecXM.crossProduct(vecYM);	
	 }
	 else
	 { 
	 	vecZM = vecX0;
	 	vecZM.normalize();
	 	vecYM = bm0.vecZ();
	 	vecYM.normalize();
	 	vecXM = vecYM.crossProduct(vecZM);	
	 }
	
	vecXM.vis(_Pt0, 1);
	vecYM.vis(_Pt0, 3);
	vecZM.vis(_Pt0, 150);
		
	// Validate common range of two beams	
	// Create plane profile of male beam 
	PlaneProfile pp0 = bm0.envelopeBody().shadowProfile(Plane(ptCen0, vecX0));
	// Create plane profile of female beam 
	PlaneProfile pp1 = bm1.envelopeBody().shadowProfile(Plane(ptCen1, vecX1));
	
	pp0.vis(1);
	pp1.vis(2);
	
	// Create coordinate system on cut
	CoordSys cs(pt, vecXM, vecYM, vecZM);
	PlaneProfile ppCommon(cs);
	PLine plines[] = pp0.allRings(true, false);
	Plane pn(pt, vecZM);
	
	//Get the common area of male and female beams
	if (plines.length() > 0)
	{
		PLine pl = plines.first();
		pl.projectPointsToPlane(pn, vecX0);
		ppCommon.joinRing(pl, _kAdd);
	}
	
	plines = pp1.allRings(true, false);
	if (plines.length() > 0)
	{
		PLine pl = plines.first();	
		pl.projectPointsToPlane(pn, vecX1);
		ppCommon.intersectWith(PlaneProfile(pl));
	}	
	ppCommon.vis(3);
	
	// Check if common area is enough to add the mortise
	if(ppCommon.area() <pow(dEps,2))
	{ 
		reportMessage(TN("|There is no solution for creating a tenon on these two beams.|"));
		eraseInstance();
		return;
	}
	
	// Get orientation and shape of mortise
	int nShape = nShapes[sShapes.find(sShape)];
	int nOrientation = sOrientations.find(sOrientation);
	
	// Set CoordSys for mortise perpendicular to female beam
	if (nOrientation == 1)
	{ 
		Vector3d vt = vecXM;
		vecXM = vecYM;
		vecYM = - vt;
	}
		
	// Reset center point of _Pt0 taking the offset axis into consideration
	_Pt0.transformBy(vecXM * .5 * (dOff1 - dOff2) + vecXM * dOffsetAxis);
	
	// Set length property for mortise
	double dLength = bm0.dD(vecZM) - dOff1 - dOff2;
	
	// Create new plane profile of tenon on the cutting edge
	Point3d ptU = _Pt0;
	ptU.transformBy(vecYM * (dWidth / 2 ) + vecXM * (dLength / 2));
	Point3d ptB = _Pt0;
	ptB.transformBy(-vecYM * (dWidth / 2)- vecXM * (dLength / 2));		
	LineSeg segDiag(ptU, ptB);
	PLine pRect;
	pRect.createRectangle(segDiag, vecXM, vecYM);
	pRect.offset(1);
	pRect.vis();
	// Check if plane profile area is greater then the area of the cutting edge
	// if it's greater erase the instance.
	PlaneProfile pp = ppCommon;	
	pp.joinRing(pRect, _kAdd);	
	if (pp.area()  > ppCommon.area())
	{ 
		reportMessage(TN("|Tenon cannot be created on this cutting edge.|"));
		eraseInstance();
		return;
	}
		
//End Validate set//endregion 
	
//region Tools
	
	if(dLength > 0 && dWidth > 0 && dDepth > 0 )
	{ 	
		// Stretch male beam to add mortise
		//bm0.addTool(Cut(_Pt0 + vecZM * dDepth, vecZM), _kStretchOnToolChange);
		
		// Add Male Mortise
		Mortise msMale(_Pt0 - vecZM * (dGapLength) , vecYM, vecXM, vecZM, dWidth, dLength, dDepth + dGapLength, 0, 0, 1);
		msMale.setEndType(_kMaleEnd);
		msMale.setRoundType(nShape);
		bm0.addTool(msMale,_kStretchOnToolChange);
		
		// Add female mortise
		//bm1.addTool(Cut(_Pt0, -vecZM), _kStretchOnToolChange);
		Mortise msFemale(_Pt0, vecYM, vecXM, vecZM, dWidth, dLength + dToleranceLengthLeft + dToleranceLengthRight , dDepth + dGap + dGapLength , 0, 0, 1);
		msFemale.setEndType(_kFemaleEnd);
		msFemale.setRoundType(nShape);
		bm1.addTool(msFemale,_kStretchOnToolChange);		
		
	}
	else
	{		
		// Stretch beams to location
		bm0.addToolStatic(Cut(_Pt0, vecZM), _kStretchOnToolChange);
		bm1.addToolStatic(Cut(_Pt0, -vecZM), _kStretchOnToolChange);
		eraseInstance();
		return;
	}
	
//End Tools//endregion 

//region Add Display

	Point3d pnt1 = ptU;
	Point3d pnt2 = ptB;
	pnt2.transformBy(vecZM * dDepth);
		
	Point3d pnt3 = pnt1;
	Point3d pnt4 = pnt2;
		
	if(nOrientation == 1)
	{ 
		pnt3.transformBy(-vecYM * dWidth);
		pnt4.transformBy(vecYM * dWidth);
	}
	else
	{
		pnt3.transformBy(-vecYM * dWidth - vecXM * dLength);
		pnt4.transformBy(vecYM * dWidth + vecXM * dLength);
	}	
	
	PLine pl1(vecZM);
	pl1.addVertex(pnt1);
	pl1.addVertex(pnt2);
	PLine pl2(vecZM);
	pl2.addVertex(pnt3);
	pl2.addVertex(pnt4);
	
	Display dpSymbol(3);
	dpSymbol.draw(pl1);
	dpSymbol.draw(pl2);
	
//End Add Plane Profile//endregion 

//region Triggers

	String sTriggerFlipSide = T("|Flip Side|");
	addRecalcTrigger(_kContext, sTriggerFlipSide );
	if (_bOnRecalc && (_kExecuteKey==sTriggerFlipSide || _kExecuteKey==sDoubleClick))
	{
		_Beam.swap(0, 1);
		_PtG.setLength(0);
		setExecutionLoops(2);
		return;
	}	

//End Triggers//endregion 

//region Add grips

////	// index 0 = depth // index 1 = center position
////	if (_PtG.length() < 1)
////	{ 
////		_PtG.append(_Pt0 + vecZM *dDepth);
////	}
////	else 
////	{ 	
////		_PtG[0] = Line(_Pt0, vecZM).closestPointTo(_PtG[0]);
////	}
////		
////		
////	if (_kNameLastChangedProp=="_PtG0")
////	{ 	
////		dDepth.set(vecZM.dotProduct(_PtG[0] - _Pt0));
////		setExecutionLoops(2);
////		return;
////	}
////	else if (_kNameLastChangedProp==sDepthName && _PtG.length()>0)
////	{ 
////		_PtG[0] = _Pt0 + vecZM * dDepth;
////		setExecutionLoops(2);
////		return;		
////	}		
////	
//	reportMessage(("\n_Pt0 at the end of the script:") + _Pt0);
	_Map.setVector3d("vecPt0", _Pt0-_PtW);	
	
//End Add grips//endregion 
#End
#BeginThumbnail
M_]C_X``02D9)1@`!`@``9`!D``#_[``11'5C:WD``0`$````9```_^X`#D%D
M;V)E`&3``````?_;`(0``0$!`0$!`0$!`0$!`0$!`0$!`0$!`0$!`0$!`0$!
M`0$!`0$!`0$!`0$!`0("`@("`@("`@("`P,#`P,#`P,#`P$!`0$!`0$"`0$"
M`@(!`@(#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#
M`P,#`P,#`P,#_\``$0@!+`&0`P$1``(1`0,1`?_$`,\``0`#``(#`0$`````
M```````'"`D&"@,$!0(!`0$``@(#`0$`````````````!@<$!0(#"`$)$```
M!@(!`@,""`H'!@0'`````0(#!`4&!P@1$B$3%!4W,2(6MG>W.`E!,B.S5G87
ME]=X84)S)#2T)5%Q,W0U&+)3=29R0]-$-I97$0`"`0("!@0&#@D#`P4!````
M`0(#!!$%(3%!81(&47&!$[$B,A1T-9&AP=%"4G(C,W.S-`<(\.%B@L)#)+05
MDK(W4W6%\:+28Q8E_]H`#`,!``(1`Q$`/P#O\```````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M`````/C9%>1,9Q^]R2>W(>@X]36EY-:B(;<ENQ*F$_/DMQ6WGH[*Y"V8YD@E
MN(2:C+JHB\2[[6WG>75.TI-*I5J1@F]6,FHK'!-X8O3@GU'1=7$+2UJ7=1-T
MZ5.4VEKPBFWABTL<%HQ:ZR']#\F=*<D\=+(=1YO6Y`;+#3MOCSRO9V6XZMU+
M?5F^QN6:+*$E+KGEID$AR&^M)^0\ZDNX;[F7E#F#E*Z\USRWG2Q;49KQJ53?
M"HO%>C3PXJ27E13T&BY;YMY?YLM?.LDN(5<$G*#\6I#'9.F_&71Q:8M^3)D\
MB-$D````````````````````````````````````````````````````````
M``````````````````````"/=N>ZC9WT>YI\V[(;3(_75GZ52^TB:O._4MYZ
M+5^SD=835V'1)."ZNS"BLKK",^I\5HW*7/<,L7Z'**]Q$-GM0J=$-)6,)1)[
M5QY*765MF:>TB,Q[)SB\DLPN[&ZA3N,MJ5I\=&K%3IRTO8_)?1*.#3TGC/*;
M;"SM;ZUG4M\QITHN-6E)PJ+0MJUKI4L4UH-'M1?>);#UGZ>@Y2T!YGB31I99
MWIKFF65E6Q4)(O5['UW!2ZZE*4I4X].IB6TVDDI]*M9FH5'GWX499FV-UR;5
M[B]>EV=>7BR?10KOV%"KI;Q?&EH+?Y?_`!9S'+,+7G&GWUHM"NZ,?&BNFO17
MLN=+0M7`WI-;L#V#@^T,:@9CKO+*'-,7LB/T=WCME&LX"W$$DWHSCL9Q9QIT
M8UDEYATD/,J^*M*5>`HW,LKS')[N5AFM"K;WD-<)Q<9;GIUI[)+%-:4VB\\M
MS/+LXM(W^5UJ=Q9SU3A)26]:-36U/!K4TCF(P#.`````````````````````
M``````````````````````````````````````````````````````(]VY[J
M-G?1[FGS;LAM,C]=6?I5+[2)J\[]2WGHM7[.1ULM-^ZG7OZI4O\`DFAZ]SSU
MQ<_72\)X\R?U5;_51\!)8U)LCC./5^6:PR9_/-$9K9ZDS&2:%VB*9IF9A>7)
M:-TT1<SPB62J*Y0?GN$E_P`I$IA3AN(7YA),LF\=AG5HLMYDMX7MBO)XFU5I
M8[:55>/'4M&+B\,&L#A8SS#)+MYCR[<3L[U^5PX.E4PV5:3\26MX/#B6.*>)
MI%I7[R?'I$JNPSE%C\33N5R740X&PJQV78:8RB2I1);4FYD>;88'+>[O\/;*
M4PE*34<LNY*"J#F+\([NG"=_R?5E?V26+HR2C=4U\E81K)?&IX2V<&C$N/ES
M\7+.M*%AS=3C8WS>"K1;=K4?RGBZ+?14QCMX].!I_"FP[*)&L*Z7&GP)K#4J
M'-A/M2HDN,^@G&),:2PM;+[#S:B4A:%&E23ZD?04[4IU*4W2JQ<:D6TTTTTU
MK33TIK:F7%3J4ZL%5I24J<EBFFFFGJ::T-/I1[(X',``````````````````
M`````````````````````````````````````````````````````"/=N>ZC
M9WT>YI\V[(;3(_75GZ52^TB:O._4MYZ+5^SD=;+3?NIU[^J5+_DFAZ]SSUQ<
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
MB_>ZDM"W%LQDG0`````````````$?[9]U>R_H_S+YN60`C_B;]ECC1_+_IKZ
MNL<`%@````````````````````````````````````!1;1FIKW7C6Q<MV#<0
MLHW%N78=YL79N1P&W4UK+CGDT6"X!C7J4(E-87JK7E3645<E1(5+7$?L7D%,
MGRUKJG.;V=]?SG+13BW&*Z$GX6]++"RRTC:6D8+RY+B;Z6_>U(G<:HV`````
M```````%-N5>R"@U\;754_TEV:6;#(UMJZ&S7(63D"N4:3ZDN<^WYKA>!DTV
MDO%+AC6W];!=S'6]?49=K3Q?>/4M10P:HS@``````)5X(:C/D#R'M>0-_#;D
MZ?XN7F18)J%J0RI<7,^2,FL?Q_9VQ(Y.H\B56:2QBUE8C6/M*4@\BM\B:=2F
M14Q5IM?DG)_-K5YI77S]980W0Z?WGIZDNEE?\T9EW]=6-)_-4WC+?+H_=7MM
M]!NR)V10```````````````C_;/NKV7]'^9?-RR`$?\`$W[+'&C^7_37U=8X
M`+`````````````````````````````````````"$Y7^)D?V[OYQ0INY^\U/
MER\++-H?0P^2O`>$=!V@`````````'&,RRJNPG&;?)[17]UJHJGB9)1)<ER5
M&34.$R:O#SIDE:6T]?`C5U/H1&8X5*BI0<Y:D<H1<Y**ULR$R*_LLHO+3(;=
MWSK&VF.S)*R(R0E3A]$,LI,S[&([1);;3U/M0DB_`(].<JDG.7E-FUC%1BHK
M4CXHX'(`````CK/'<YOYN$Z;U"MI.ZMZY,C7>N9K\#VM`PQ+T&5:YKMW(ZXW
MHS4C%-/83`G7TEEYZ,W:2XL2H:>3-LXB7-WR_E,LXS&%N\?-X^-4?1%;.N3T
M+KQV,U>;YA'+K*59?3/1!?M/;U+6_8VG8ATEIW!>/NI=?Z5UK7OUV$ZWQFNQ
MBC1.DG/MYR(;9JG7V16SB$2+W*\ELW7K&VL7^LFRLI3\IY2G75J.]8QC"*A!
M)02P26I):D53*3E)RD\9-XMDI#D?```````````````"/]L^ZO9?T?YE\W+(
M`1_Q-^RQQH_E_P!-?5UC@`L`````````````````````````````````````
M(3E?XF1_;N_G%"F[G[S4^7+PLLVA]##Y*\!X1T':``````````9X\H]D_*#(
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
MR?8M72\%M,._O*=A:3N:GP5H72]B[7[6DW@XF\=JCBWHG#-1P;4\HR""BQR3
M9.?/Q#@V&RML9A82,CV1L"?%5(FN0$Y)E5A(<A0">=8IZQ,6NC&F)#CMHORW
MMZ5K0A;4%PT8144MR]WI>UZ2I:U:I<595ZKQJ2;;>]ECQW'4````````````
M````````````````````````````````````````````````0G*_Q,C^W=_.
M*%-W/WFI\N7A99M#Z&'R5X#PCH.T`````I#RMV3_`(;6U4^?_P!O9Y0MLS+\
M"7ZJI4?7Q+\64Z73_P`GH?XQ#67];^3'K?N+W?8,RUI_S'V%(1JS-```````
MG'[NS4:=U[CR#EUD<(I&N]/R\PU!QD0\HG8M[G!.S<3W_O"&V1FTI,"1&?U_
M02#2E]AJ)DKB%.1+9E0M_DW)_,;'SZLL+JNDUTQAK2_>\I[N'H*ZYES+SJZ\
MUI/YBD].^6U]FI=O2;>B9D9`````````````````````````````````````
M`````````````````````````A.5_B9']N[^<4*;N?O-3Y<O"RS:'T,/DKP'
MA'0=H```>%_S_(>]-Y7J?*<]/Y_?Y'G]A^5YWE_E/*\SIW=OCT^#Q!XX:-8Z
M]1C7EWMWY49!\I_,^4/M>?[8\W\;VAZESU'9_5\GO_X?;\3R^G;\7H(W4X^-
M\?EXZ3;PX>%</DX''1P.0````!$6_/EU^QG9'[-O;7RS^2UC[)^2_H?ECY/:
MGVQ\@_:W^B_M"]A^I^3_`*__`$_VUZ7U7]W\P9N6^:^?T?/ONG>1X^K';NZ=
MN&.&DQ;WSCS2IYK]XX'P]>'AZ-YV'^-G[&/^WO27_;G[+_8)^RO!/V.^Q?6>
MSOV;_)NN^2'D>TO]5\SV)Y/F^L_OGG=WJ/RW>/0D>'A7#APX:,-6!3[QQTZR
M;!]/@```````````````````````````````````````````````````````
'``````'_V0``

#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End