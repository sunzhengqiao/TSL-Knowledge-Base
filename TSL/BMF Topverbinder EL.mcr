#Version 7
#BeginDescription
Version 1.3   27.10.2005   hs@hsbcad.de
   -Fr‰sungen am 'HT' in der Breite und in der L‰nge um ein Additionsmaﬂ erg‰nzt
Version 1.2   20.06.2005   th@hsbCAD.de
   - Fr‰sung bei Option 'im NT eingelassen' erg‰nzt
Version 1.1   20.06.2005   th@hsbCAD.de
   - auch nicht lotrechte Verbindungen der Stabachsen sind zul‰ssig
   - neue Option 'horizontaler Abstand' verschiebt den Verbinder entlang
     Stabachse des HT
Version 1.0   31.05.2005   th@hsbCAD.de
   - erzeugt einen BMF EL Topverbinder zwischen zwei St‰ben




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
//basics and props
	U(1,"mm");
	setExecutionLoops(2);
	
	String sArType0[] = {"30","40","60","80","100"};
	String sArType1[] = {"348030","348040","348060", "348080","348100"};
	String sArType[] = {sArType0[0] + "/" + T("BMF-Nr") + ":" + sArType1[0],
		sArType0[1] + "  " + T("BMF-Nr") + ":" + sArType1[1],
		sArType0[2] + "  " + T("BMF-Nr") + ":" + sArType1[2],
		sArType0[3] + "  " + T("BMF-Nr") + ":" + sArType1[3],
		sArType0[4] + " " + T("BMF-Nr") + ":" + sArType1[4]};
	PropString sType(0,sArType,T("BMF Topverbinder EL"));
	int nType = sArType.find(sType,0);
	
	String sArConType[] = {T("Milled in female beam"), T("Milled in male beam"), T("visible gap"), T("concrete"), T("Steel"), T("Element"), T("L-bearing")};
	PropString sConType(1,sArConType,T("Connection Type"));
	int nConType = sArConType.find(sConType,0);
	
	
	double dWidth[] = {U(30),U(40), U(60), U(80), U(100)};
	double dWidthOff[] = {U(15),U(20), U(10), U(10), U(10)};
	double dHeight = U(120); 
	double dHeight2 = U(55); 
	double dThick = U(10);
	
	double dBMin[] = {U(45), U(50), U(70), U(90), U(110)};
	double dHMin = U(160);

	int nNumDr5[] = {5,9,13,17,21};
	int nNumDr9[] = {0,1,1,1,1};

	PropString sHWType(2, T("Screw"), T("HW") + " " + T("Type"));
	PropString sHWDesc(3, T("ABC Spax"), T("HW") + " " + T("Description"));
	PropString sHWModel(4, T(""), T("HW") + " " + T("Model"));
	PropString sHWMaterial(5, T("Aluminium"), T("HW") + " " + T("Material"));
	PropString sHWNotes(6, T(""), T("HW") + " " + T("Notes"));
	PropDouble dHWLength(7, U(70), T("HW") + " " + T("Length"));
	PropDouble dHWDiam(8, U(5), T("HW") + " " + T("Diameter"));

	PropDouble dOffsetV(0,U(0), T("Vertical Offset") + " " + T("(only L-Bearing)"));
	PropDouble dOffsetH(1,U(0), T("Horizontal Offset"));
	
	PropDouble dAddWidth(2,U(2), T("Additional Width"));
	PropDouble dAddDepth(3,U(5), T("Additional Depth"));
	
// on insert
	if (_bOnInsert){

		_Beam.append(getBeam(T("Select first beam")));
		_Beam.append(getBeam(T("Select second beam")));
		Element el;
		el = _Beam[1].element();
		if (el.bIsValid())
			sConType.set(sArConType[5]);
		showDialog();
				
		return;
	}		
	
	if (_Beam.length() < 2)
		return;
	Beam bm0, bm1;
	bm0 = _Beam[0];
	bm1 = _Beam[1];
	

/* non perps
	if(!bm1.vecX().isPerpendicularTo(bm0.vecX()))	{
		reportNotice("\n" + T("X-Axes of Beams must be perpendicular"));
		eraseInstance();
		return;
	
	}*/
	
	
// Vectors of connection
	Vector3d vx,vy,vz, vxN, vyN, vzN;
	Point3d pt0, pt1;
	pt0 = bm0.ptCen();
	// find projected intersection to allign vector
		LineBeamIntersect lbi(pt0, bm0.vecX(), bm1);
		if (lbi.nNumPoints() > 0)
			pt0 = lbi.pt1();

	/* parallel
	if (nType == 0){
		pt1 = Line(bm1.ptCen(), bm1.vecX()).closestPointTo(pt0); 
		vx = pt1 - pt0;
		vx = bm0.vecD(vx);
	}

	// as T-connection
	else{
	*/
		vx = pt0 - bm0.ptCen();
		vx.normalize();
	//}

	vy = bm1.vecX().crossProduct(vx);
	vz = vx.crossProduct(vy);
	vxN = bm1.vecD(vx);
	vzN = bm1.vecX().crossProduct(vxN);
	vyN = bm1.vecX();

	pt0 = pt0 + vy * dOffsetV + vyN * dOffsetH;
	pt0.vis(6);
	_Pt0 = pt0;
	if (_ZW.dotProduct(_Pt0 - (_Pt0 - vzN * U(1))) < 0)
		vzN = -vzN;
	
//Cut
	Cut ct;

	vxN.vis(_Pt0,1);
	vyN.vis(_Pt0,3);
	vzN.vis(_Pt0,150);	

// check allignment: if XY-Planes varie set L-Bearing
	if (!vzN.isParallelTo(bm0.vecD(vzN)) && sConType !=sArConType[6]){
		reportMessage("\n" + T("I-Beam is not in same plane with -Beam.") + " " + T("The Connection Type will be changed to:")  + "\n"+ sArConType[6]);
		sConType.set(sArConType[6]);				
	}
	
// Error Display
	Display dpErr(1);
	
//MetalPart
	Body bd(_Pt0, vyN, vzN, vxN, dWidth[nType], dHeight, dThick, 0,0,-1);
	Body bd1(_Pt0 - vxN * dThick + 0.5 * vzN * dHeight, vyN, vxN, vzN, dWidth[nType], dHeight2, dThick, 0,1,-1);	
	bd.addPart(bd1);

//drill Body
	Point3d ptDr = _Pt0 - vyN * 0.5 * nType * U(15) - (vxN + vzN) * U(15); 
	for (int i = 0; i < nType+1; i++){
		//PLine plScrew(vyN);
		Drill dr(ptDr,ptDr + (vxN + vzN) * dHWLength, U(2.7));
		//plScrew.addVertex(ptDr);
		ptDr.vis(4);
		//plScrew.addVertex(ptDr + (vxN + vzN) * dHWLength);
		//plScrew.vis(3);		
		bd.addTool(dr);
		dr.transformBy(-vzN * U(20));		
		bd.addTool(dr);
		dr.transformBy(-vzN * U(20));
		bd.addTool(dr);
		ptDr.transformBy(vyN * U(15));
	}
		
// Tooling and transformation
	
	CoordSys cs, csToTop;
	cs.setToTranslation(vxN * dThick);
	csToTop.setToTranslation(vzN * (0.5 * (bm1.dD(vzN) - dHeight) + vzN.dotProduct(bm1.ptCen() - bm0.ptCen())));	
	if (nConType == 0){
		ct = Cut(_Pt0, vxN);
		bd.transformBy(cs);
		bd.transformBy(csToTop);	
		House hs(_Pt0 + 0.5 * vzN * dHeight, vyN, vxN, -vzN, dWidth[nType]+dAddWidth, 2 * (dHeight2+dAddDepth), dThick, 0,0,1);	
		hs.transformBy(-vxN * dThick);
		hs.transformBy(cs);
		hs.transformBy(csToTop);
		hs.setEndType(_kFemaleSide);
		hs.setRoundType(_kReliefSmall);
		bm1.addTool(hs);
	}
	else if (nConType == 1){
		ct = Cut(_Pt0, vxN);
		bd.transformBy(csToTop);
		double dOnSameHeight, dHouseEnlarge;
		dOnSameHeight = (bm0.ptCen().Z() + 0.5 * bm0.dD(vzN)) - (bm1.ptCen().Z()+ 0.5 * bm1.dD(vzN));
		if (dOnSameHeight==0)
			dHouseEnlarge = U(20);
		House hs1(_Pt0 + 0.5 * vzN * dHeight, vyN, vxN, -vzN, dWidth[nType]+dAddWidth, 2 * (dHeight2+dAddDepth), dThick, 0,0,1);	
		hs1.transformBy(-vxN * dThick);
		hs1.transformBy(csToTop);
		hs1.setEndType(_kFemaleSide);
		hs1.setRoundType(_kReliefSmall);
		bm1.addTool(hs1);			
			
			
		House hs0(_Pt0, vyN, vzN, -vxN, dWidth[nType], dHeight + dHouseEnlarge , dThick, 0,0,1);
		hs0.transformBy(vzN * dHouseEnlarge *0.5);		
		hs0.transformBy(csToTop);
		hs0.setEndType(_kFemaleEnd);
		hs0.setRoundType(_kReliefSmall);
		bm0.addTool(hs0);	
	}
	else if (nConType == 2 || nConType == 3 || nConType == 4){
		ct = Cut(_Pt0 - vxN * dThick, vxN);
		bd.transformBy(vzN * dThick);
		bd.transformBy(csToTop);
		if (nConType == 4){
			Point3d  ptBd = _Pt0;
			ptBd.transformBy(vzN * dThick);
			ptBd.transformBy(csToTop);
			ptBd.vis(2);
			double dLowerDistance = vzN.dotProduct((ptBd - vzN * 0.5 * dHeight)- (bm0.ptCen() - vzN * 0.5 * bm0.dD(vzN)));
			if (dLowerDistance  < U(40)){
				PLine plErr(vxN);
				plErr.addVertex(ptBd - vyN * 0.5 * dWidth[nType] - vzN * 0.5 * dHeight);
				plErr.addVertex(ptBd - vyN * 0.5 * dWidth[nType] - vzN * (0.5 * dHeight + dLowerDistance));
				plErr.addVertex(ptBd + vyN * 0.5 * dWidth[nType] - vzN * (0.5 * dHeight + dLowerDistance));											
				plErr.addVertex(ptBd + vyN * 0.5 * dWidth[nType] - vzN * 0.5 * dHeight);
				plErr.close();
				dpErr.draw(plErr);
				reportMessage("\n" + T("Warning") + " " + scriptName() + ": " + T("Beam") + " " + bm0.posnum() +"/" + bm1.posnum() + "\n" + T("Distance to lower egdge invalid!"));			
			}	
		}
	}
	//Element
	else if (nConType == 5){
		bd.transformBy(csToTop);		
		House hs(_Pt0 + 0.5 * vzN * dHeight, vyN, vxN, -vzN, dWidth[nType]+dAddWidth,dHeight2+dAddDepth, dThick, 0,1,1);
		hs.transformBy(csToTop);
		hs.setEndType(_kFemaleSide);
		hs.setRoundType(_kReliefSmall);
	
		// element tools
		Element el;
		el = _Beam[1].element();
		if (el.bIsValid()){
			CoordSys csEl;
			Point3d ptOrg;
			Vector3d vxEl,vyEl,vzEl;

			csEl = el.coordSys();
			ptOrg = csEl.ptOrg();
			vxEl = csEl.vecX();
			vyEl = csEl.vecY();
			vzEl = csEl.vecZ();
			
			Point3d ptOnOL;
			ptOnOL = el.plOutlineWall().closestPointTo(_Pt0);
			int nIconSide = 1;
			double dOffsetZones = vzEl.dotProduct(ptOnOL - ptOrg);
			if (dOffsetZones  < 0){
				nIconSide = -1;
				dOffsetZones = abs(dOffsetZones) - el.zone(0).dH();
			}
			BeamCut bc(_Pt0 + 0.5 * vzN * dHeight, vyN, vxN, -vzN, dWidth[nType], 2 * dHeight2, dThick, 0,0,1);
			bc.transformBy(csToTop);
			bc.transformBy(-vxN * dOffsetZones);						
			hs.transformBy(-vxN * dOffsetZones);	
			bd.transformBy(-vxN * dOffsetZones);
			ct = Cut(_Pt0 - vxN * (dOffsetZones + dThick), vxN);
			for (int i = 1; i < 6; i++){
				Sheet sh[0];
				sh = el.sheet(nIconSide * i);	
				bc.addMeToGenBeamsIntersect(sh);
				
			}
		bm1.addTool(hs);	
		}
		else{
			reportMessage("\n" + T("I-Beam is not a beam of an element.") + " " + T("The Connection Type will be chnaged to:")  + "\n"+ sArConType[0]);
			sConType.set(sArConType[0]);				
		}
	}	
	//L-bearing
	else if (nConType == 6){
		ct = Cut(_Pt0 - vxN * dThick, vxN);
		bd.transformBy(cs);
		CoordSys csRot;
		csRot.setToRotation(180, vxN,_Pt0 );
		bd.transformBy(csRot);	
		csRot.setToRotation(180, vzN,_Pt0 );
		bd.transformBy(csRot);
		bd.transformBy(-vzN * 0.5 * (bm0.dD(vzN) - dHeight));
		BeamCut bc0(_Pt0 + vxN * dThick - vzN * (0.5 * bm0.dD(vzN) - dThick), vyN, vxN, vzN, U(1000), dHeight2 + dThick, U(1000), 0,-1,-1);
		bc0.transformBy(vzN * dOffsetV);
		bd.transformBy(vzN * dOffsetV);		
		bm0.addTool(bc0); 
	}
	
	//if (nConType != 1)
		bm0.addTool(ct,1);	
		
// Display
	Display dp(253), dpPlan(9);
	dpPlan.addViewDirection(_ZW);
	dpPlan.textHeight(U(1));
	/*if (bm0.dD(vzN) < dBMin[nType] || 
	    bm0.dD(vzN) < dHMin || 
	    (!bm0.vecD(vzN).isPerpendicularTo(bm1.vecD(vzN)) && nConType != 6))
		dp.color(1);*/
	dp.draw(bd);
	dpPlan.draw(T("BMF Topverbinder"), _Pt0, _YW, -_XW, 0,2,_kDevice);
	dpPlan.draw(sArType[nType], _Pt0, _YW, -_XW, 0,-2,_kDevice);
	
	
// Hardware
	String sCompare;
	sCompare= scriptName() + sHWType+ sHWDesc + sHWModel + sHWMaterial + sHWNotes;// 
	setCompareKey(sCompare);
	Hardware( sHWType , sHWDesc, sHWModel, dHWLength, dHWDiam, nNumDr5[nType], sHWMaterial, sHWNotes);
	if (nNumDr9[nType] > 0)
		Hardware( sHWType , sHWDesc, sHWModel, dHWLength, dHWDiam, nNumDr9[nType], sHWMaterial, sHWNotes);





#End
#BeginThumbnail


#End
