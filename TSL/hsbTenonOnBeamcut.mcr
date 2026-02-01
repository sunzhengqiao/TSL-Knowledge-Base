#Version 8
#BeginDescription
version value="2.2" date=02oct2020" author="thorsten.huck@hsbcad.com"
HSB-9074 bugfix placement on horizonztal hip rafter cuts
#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 2
#MinorVersion 2
#KeyWords Beamcut;Tenon;Mortise;House
#BeginContents
/// <insert>
/// This tsl creates a tenon as t-connection. it uses the real body of the female beam for it's location
/// </insert>

/// History
///<version value="2.2" date=02oct2020" author="thorsten.huck@hsbcad.com"> HSB-9074 bugfix placement on horizonztal hip rafter cuts </version>
///<version value="2.1" date=20mar2019" author="thorsten.huck@hsbcad.com"> properties categorized </version>
///<version  value="2.0" date="14oct15" author="th@hsbCAD.de"> debug message removed </version>
///<version  value="1.9" date="28may13" author="th@hsbCAD.de"> minor bugfix</version>
///<version  value="1.8" date="26mar13" author="th@hsbCAD.de"> missing beams do not rise error message, but delete the tool</version>
///<version  value="1.7" date="20feb13" author="th@hsbCAD.de"> contact face detection enhanced</version>
///<version  value="1.6" date="20feb13" author="th@hsbCAD.de"> new options to align the tenon with the male beam</version>
/// Version 1.5   19.02.2010   th@hsbCAD.de
/// DE   Einfügeverhalten verbessert
/// neue Eigenschaften um die Absätze zu beeinflussen
/// EN   Insert mechanism enhanced
/// new properties to control the gap in length of the tenon
/// Version 1.4   24.07.2008   th@hsbCAD.de
/// DE   Zapfenloch verbessert
/// EN   Female Mortise enhanced
/// Version 1.3   14.07.2008   aj@hsb-cad.com
/// EN   Add Gap on Length Property
/// DE   Rückschnitt Zapfenlänge ergänzt
/// 
/// Version 1.2   02.06.2008   th@hsbCAD.de
/// EN   stretching on special tool intersections enhanced
/// DE   Streckverhalten bei Bearbeitungsüberschneidungen verbessert
/// 
/// Version 1.1   24.02.2008   th@hsbCAD.de
/// EN   bugFix complex contours
/// DE   bugFix bei aufwendigeren Stab-Formen
/// 
/// Version 1.0   08.01.2008   th@hsbCAD.de
/// EN   creates a tenon connection between two beams.
///    The plane to stretch is taken from the solid at the intersection. Useful on half logs
/// DE   erzeugt eine Zapfenverbindung zwischen zwei Stäben.
///    Die Streckebene wird vom Volumenkörper des durchlaufenden Balken abgleitet
///    u.a. hilfreich bei Verbindungen an halben Bohlen


//region constants 
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
//end constants//endregion

	//PropInt nXX(0, 0, T("Int"));

// Geometry
	category = T("|Geometry|");
	String sWidthName=T("|Width|");	
	PropDouble dWidth(0, U(40), sWidthName);	
	dWidth.setDescription(T("|Defines the Width|"));
	dWidth.setCategory(category);
	
	String sDepthName=T("|Depth|");	
	PropDouble dDepth(1, U(50), sDepthName);	
	dDepth.setDescription(T("|Defines the Depth|"));
	dDepth.setCategory(category);
	
	String sShapeName=T("|Shape|");
	int nShapes[]={_kNotRound,_kRound,_kRounded};
	String sShapes[] = {T("|Rectangular|"),T("|Round|"),T("|Rounded|")};
	PropString sShape(1, sShapes, sShapeName);	// !legacy index
	sShape.setDescription(T("|Defines the Shape|"));
	sShape.setCategory(category);

// Alignment
	category = T("|Alignment|");
	String sOff1Name=T("|Offset| 1");	
	PropDouble dOff1(2, U(0), sOff1Name);	
	dOff1.setDescription(T("|Defines the Off1|"));
	dOff1.setCategory(category);
	
	String sOff2Name=T("|Offset| 2");	
	PropDouble dOff2(3, U(0), sOff2Name);	
	dOff2.setDescription(T("|Defines the Off2|"));
	dOff2.setCategory(category);

	String sOffsetAxisName=T("|Offset from axis|");	
	PropDouble dOffsetAxis(5, U(0), sOffsetAxisName);
	dOffsetAxis.setDescription(T("|Defines the OffsetAxis|"));
	dOffsetAxis.setCategory(category);
	
	String sOrientationName=T("|Orientation|");	
	String sOrientations[] = {T("|Parallel female beam|"),T("|Perpendicular female beam|"),T("|Parallel with projected Z-axis of tenon beam|"),T("|Perpedicular to projected Z-axis of tenon beam|")};
	PropString sOrientation(0, sOrientations, sOrientationName);	
	sOrientation.setDescription(T("|Defines the Orientation|"));
	sOrientation.setCategory(category);	
	

// tolerances
	category = T("|Tolerances|");
	String sToleranceLengthLeftName=T("|Tolerance length left|");	
	PropDouble dToleranceLengthLeft(7, U(0), sToleranceLengthLeftName);	
	dToleranceLengthLeft.setDescription(T("|Defines the Tolerance on left side|"));
	dToleranceLengthLeft.setCategory(category);
	
	String sToleranceLengthRightName=T("|Tolerance length right|");	
	PropDouble dToleranceLengthRight(8, U(0), sToleranceLengthRightName);	
	dToleranceLengthRight.setDescription(T("|Defines the Tolerance on right side|"));
	dToleranceLengthRight.setCategory(category);

	String sGapName=T("|Tolerance depth|");	
	PropDouble dGap(4, U(0), sGapName);	
	dGap.setDescription(T("|Defines the Gap|"));
	dGap.setCategory(category);

	nDoubleIndex++; // legacy index of dOffsetAxis
	String sGapLengthName=T("|Gap on Length|");	
	PropDouble dGapLength(6, U(0), sGapLengthName);	
	dGapLength.setDescription(T("|Defines the Gap on length|"));
	dGapLength.setCategory(category);
		

// on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }

		// show the dialog if no catalog in use
		if (_kExecuteKey == "")
			showDialog();		
		// set properties from catalog		
		else	
			setPropValuesFromCatalog(_kExecuteKey);	
			
		PrEntity ssE(T("|Select male beam(s)|"), Beam());
		Beam bm[0];
		if (ssE.go())
			bm= ssE.beamSet();


		PrEntity ssE2(T("|Select female beam(s)|"), Beam());
		Beam bmFemale[0];
		if (ssE2.go())
			bmFemale= ssE2.beamSet();
		
		// declare TSL Props
		TslInst tsl;
		Vector3d vUcsX = _XW;
		Vector3d vUcsY = _YW;
		Beam lstBeams[2];			// T-connection will be always made with 2 beams
		Element lstElements[0];
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];

		lstPropDouble.append(dWidth);
		lstPropDouble.append(dDepth);
		lstPropDouble.append(dOff1);
		lstPropDouble.append(dOff2);		
		lstPropDouble.append(dGap);		
		lstPropDouble.append(dOffsetAxis);
		lstPropDouble.append(dGapLength);
		lstPropDouble.append(dToleranceLengthLeft);
		lstPropDouble.append(dToleranceLengthRight);	
		
		lstPropString.append(sOrientation);
		lstPropString.append(sShape);
						
		for (int i = 0; i < bm.length(); i++)
		{
			//T connection 			
			lstBeams[0] = bm[i];
			
			// filter females
			Beam bmFilter[0];
			bmFilter = bm[i].filterBeamsTConnection(bmFemale, U(500), true) ;
			for (int j = 0; j < bmFilter.length(); j++)
			{
				lstBeams[1] = bmFilter[j];		
				// create new instance	
				tsl.dbCreate(scriptName(), vUcsX,vUcsY,lstBeams, lstElements, lstPoints, 
					lstPropInt, lstPropDouble, lstPropString ); 	
			}	
		}// next i
		
		eraseInstance();
		return;
	}	
//end on insert________________________________________________________________________________

// validation
	if (_Beam.length()<2)
	{
		reportMessage("\n" + T("|This tool requires at least two beams.|"));
		eraseInstance();
		return;	
	}	
	
// ints
	int nOrientation = sOrientations.find(sOrientation);
	int nShape = nShapes[sShapes.find(sShape)];
	setExecutionLoops(2);
	
// declare standards
	Beam bm0, bm1;
	bm0 = _Beam[0];
	bm0.vecZ().vis(_Pt0,40);
	bm1 = _Beam[1]; 
	Point3d ptOrg = _Pt0;
	Vector3d vx,vy,vz;
	vx=_Z1;
	vy=vx.crossProduct(_X1);
	
	if (vy.isParallelTo(_Y0) && !vy.isCodirectionalTo(_Y0))
		vy*=-1;	
	else if (vy.isParallelTo(_Z0) && !vy.isCodirectionalTo(_Z0))
		vy*=-1;
	
	vz=vx.crossProduct(-vy);
	
	if (nOrientation == 1)
	{
		Vector3d vt = vz;
		vz = vy;	
		vy = -vt;
	}	
	else if (nOrientation == 2)
	{
		Vector3d vt = vz;
		vz = bm0.vecD(vz);	
		vy = vx.crossProduct(-vz);
	}	
	else if (nOrientation == 3)
	{
		Vector3d vt = vz;
		vz = -bm0.vecD(vy);	
		vy = vx.crossProduct(-vz);
	}	
	vz=vx.crossProduct(vy);		
	vx.vis(ptOrg, 1);
	vy.vis(ptOrg, 3);
	vz.vis(ptOrg, 150);


// get intersecting body
	Body bd0Envelope(bm0.ptCen(), bm0.vecX(), bm0.vecY(), bm0.vecZ(), bm0.solidLength(), bm0.solidWidth(), bm0.solidHeight(),0,0,0);
	//Body bd0Envelope(bm0.ptCen(), bm0.vecX(), bm0.vecY(), bm0.vecZ(), bm0.solidLength(), bm0.solidWidth()+dEps, bm0.solidHeight()+dEps,0,0,0);
	bd0Envelope.subPart(bm1.envelopeBody());
	Body bdInt = bd0Envelope;
	Body bd1Real = bm1.realBody();
	bdInt.transformBy(_X0*bm1.dD(_X0));
	bdInt.intersectWith(bd1Real);
	bdInt.vis(6);
	
// get section
	CoordSys csPP(ptOrg, vx,vy,vz);
	PlaneProfile ppReal(csPP);	
	ppReal = bdInt.shadowProfile(Plane(ptOrg,_X1));//shadowProfile	//getSlice
	//ppReal.vis(3);	
	
// get biggest ring
	PLine pl[] = ppReal.allRings();
	PLine plMax;
	double dMax;
	for (int i = 0; i < pl.length(); i++)
	{
		if (pl[i].area() > dMax)	
		{
			dMax = pl[i].area();
			plMax = pl[i];	
		}
	}
	ppReal = PlaneProfile(plMax);	
	ppReal.vis(5);	
	
// get ref point from intersection
	LineSeg ls = ppReal.extentInDir(vx);
	Plane pn(ls.ptMid()-vx * 0.5 * abs(vx.dotProduct(ls.ptStart()-ls.ptEnd())), vx);
	Point3d ptRef = Line(_Pt0,vx).intersect(pn,0);

//region Test if connection is specified on a cut perp to _X0 HSB-9074
	Vector3d vecXC=vx, vecYC=vy, vecZC=vz;
	AnalysedTool tools[] = bm1.analysedTools();
	AnalysedCut cuts[] = AnalysedCut().filterToolsOfToolType(tools);
	for (int i=cuts.length()-1; i>=0 ; i--) 
	{ 
		//cuts[i].normal().vis(cuts[i].ptOrg(), 2);
		if (!cuts[i].normal().isParallelTo(_X0))
			cuts.removeAt(i); 
		
	}//next i
	
	int bByCut;
	if (cuts.length()>0)
	{
		Point3d pt = ptRef;
		pt.transformBy(vz * 0.5 * (dOff1-dOff2) + vy * dOffsetAxis);	
		Body bdMort(pt, vy, vz, vx, dWidth+dEps, bm0.dD(vz)-dOff1-dOff2+dEps, 2*dDepth + dGapLength, 0, 0, 1);
		bdMort.intersectWith(bdInt);
		
	// get potential contact face aligned with cut
		AnalysedCut cut = cuts.first();
		Point3d pts[] = bdMort.extremeVertices(_X0);
		if (pts.length()>0 && abs(_X0.dotProduct(cut.ptOrg()-pts.first()))<dEps)
		{ 
			Plane pnContact(pts.first(), _X0);
			PlaneProfile pp = bd1Real.extractContactFaceInPlane(pnContact, dEps);	//pp.vis(1);			pts.first().vis(1);
			
			vecXC = -cut.normal();
			vecYC = _X1.crossProduct(vecXC).crossProduct(-vecXC);
			vecYC.normalize();
			if (vy.dotProduct(vecYC) < 0)vecYC *= -1;								//vecXC.vis(pt, 1);vecYC.vis(pt, 3);
			vecZC = vecYC.crossProduct(vecZC);
			
			ptRef = Line(ptRef, vecXC).intersect(pnContact, 0);
			bByCut = true;
		}
		
		
		//bdMort.vis(2);
	}
//End Get interction location by body test//endregion 

	if (!bByCut)
	{ 
	// if no intersection area could be found set ref to upper intersection body
		if (ppReal.area() < pow(dEps,2))
			ptRef= bdInt.ptCen() - _X0 * bdInt.lengthInDirection(_X0);	
		ptRef.vis(2);	
		
	// offset
		ptRef.transformBy(vz * 0.5 * (dOff1-dOff2) + vy * dOffsetAxis);			
	}

	
	
// the distance between _Pt0 and the ref pppoint
// declare the display pp
	PlaneProfile ppTool;
	double dToolOffset = vx.dotProduct(ptRef-_Pt0);	
	
	double dLength =bm0.dD(vz)-dOff1-dOff2;	
	
// limit
	if (dLength > 0 && dWidth > 0 && dDepth > 0)
	{
	// stretch
		bm0.addTool(Cut(ptRef+vx*dDepth,vx),1);	
	// add mortise
		Mortise ms(ptRef-vecXC*(dGapLength), vecYC,vecZC,vecXC, dWidth, dLength,dDepth+dGapLength, 0,0,1);//AJ+dGapLength
		ms.setEndType(_kMaleEnd);
		ms.setRoundType(nShape);
		bm0.addTool(ms);	
	
	// add house
		Point3d ptMs = ptRef;
		ptMs.transformBy(vecZC*.5*(dToleranceLengthLeft-dToleranceLengthRight));
		ptMs.vis(4);
		Mortise msFemale(ptMs, vecYC, vecZC,vecXC, dWidth, dLength+dToleranceLengthLeft+dToleranceLengthRight,dDepth+dGap+dGapLength, 0,0,1);
		msFemale.setEndType(_kFemaleSide);
		msFemale.setRoundType(nShape);
		bm1.addTool(msFemale);	
	
	// display pp
		ppTool= bm0.realBody().getSlice(Plane(ptRef + vx * .5 * dDepth,vx));
		ppTool .transformBy(vx *.5 * dDepth);
	}
	else
	{
	// stretch
		bm0.addTool(Cut(ptRef,vecXC),1);	
		ppTool= bm0.realBody().shadowProfile(Plane(_Pt0,vx));
	}

// display
	Display dp(3);
	dp.draw(ppTool );			
/*






	



	


	

	
	


*/






#End
#BeginThumbnail
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
:64`?ES7264+6UC!`Q!:.,*2.G`JQ10!__]G_
`



#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="0.001" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="340" />
      </lst>
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="meter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End