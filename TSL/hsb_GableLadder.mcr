#Version 8
#BeginDescription
Last modified by: Alberto Jena (aj@hsb-cad.com)
07.03.2011  -  version 1.5
Version 1.4   2007-03-12   th@hsbCAD.de
   - first and last crossrail also receives dynamic stretching tool to
    inside/outside rail
Version 1.3   2007-02-22   th@hsbCAD.de
   - crossrails receive dynamic stretching tool to
    inside/outside rail
Version 1.2   2006-10-30   th@hsbCAD.de
   - new properties for inside rail
   - correct naming for fire stop
   - if any dimension is smaller or equal to zero the corresponding
     beam will not be created
Version 1.1   2006-04-07   mk@hsb-cad.com
   - sublabel2 now defines the ladder as a Manufactured element
Version 1.0   2005-11-16   th@hsbCAD.de
   - creates a gable ladder
   - if component name is given, gable ladder will be created as component
     (requires CH CreateComponent.mcr to be resident in the dwg)





#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 5
#KeyWords 
#BeginContents
//basics and props
	U(1,"mm");
	int nDebugMaster = false;

	PropString sCompName(1,"",T("Component Name"));	
	PropString sNotes(2,"",T("Notes"));	
	PropString sDimStyle(0,_DimStyles,T("Dimstyle"));
	
	String sTreated = T("Treated");
	String sWhite = T("White");
	String Types[] = {sWhite,sTreated};
	PropString sMat(3,Types,"Treated/White");

	PropInt nColor (0,171,T("Color"));	
	
	PropDouble dHeightFrontCut(17, U(100), T("Height") + " " + T("Frontcut"));
			
	PropDouble dDistTop(0, U(120), T("Distance from Top"));
	PropDouble dDistBot(1, U(500), T("Distance from Bottom"));

	PropDouble dWidth(2, U(75), T("Width Batten"));
	PropDouble dHeight(3, U(35), T("Height Batten"));

	PropDouble dWidthTiling(4, U(100), T("Width") + " " + T("Tiling Batten"));
	PropDouble dHeightTiling(5, U(22), T("Height") + " " + T("Tiling Batten"));
	PropDouble dWidthInsideRail(18, U(35), T("Width") + " " + T("Inside Rail"));
	PropDouble dHeightInsideRail(19, U(97), T("Height") + " " + T("Inside Rail"));
	PropDouble dWidthOutsideRail(6, U(35), T("Width") + " " + T("Outside Rail"));
	PropDouble dHeightOutsideRail(7, U(97), T("Height") + " " + T("Outside Rail"));
	PropDouble dWidthOutsideRailPacker(8, U(35), T("Width") + " " + T("Outside Rail Packer"));
	PropDouble dHeightOutsideRailPacker(9, U(44), T("Height") + " " + T("Outside Rail Packer"));
	PropDouble dWidthSoffitA(10, U(35), T("Width") + " " + T("Soffit Support Batten") + " A");
	PropDouble dHeightSoffitA(11, U(44), T("Height") + " " + T("Soffit Support Batten") + " A");
	PropDouble dWidthSoffitB(12, U(35), T("Width") + " " + T("Soffit Support Batten") + " B");
	PropDouble dHeightSoffitB(13, U(44), T("Height") + " " + T("Soffit Support Batten") + " B");
	PropDouble dExtLeafThick(16, U(106), T("External Leaf Thickness"));
	PropDouble dWidthFirestop(14, U(50), T("Width") + " " + T("Firestop"));
	PropDouble dHeightFirestop(15, U(35), T("Height") + " " + T("Firestop"));

	double dMyDistr = U(600);			
//on insert___________________________________________________________________
	if (_bOnInsert){
		_Beam.append(getBeam(T("Select bounding Beam")));
		
		// check if beam is assigned to eroofplanes
		Entity ents[] = _Beam[0].eToolsConnected();

		// find among the etools the ERoofPlane
		ERoofPlane er;
		for (int e=0; e<ents.length(); e++) {
  			if (ents[e].bIsKindOf(ERoofPlane())) {
				er = (ERoofPlane)ents[e];
   	 		_Entity.append(ents[e]);
    			break; // out of this for loop
  			}
		}

		if (!er.bIsValid()){
			 er  = getERoofPlane(T("Select Roofplane"));
  			_Entity.append(er);
		}
		
		_Element.append(getElement(T("Select Element")));
		showDialog();
		
		Group gr = _kCurrentGroup;
		// user wants to create a component
		if (sCompName != ""){
			if (sCompName != "" &&  (gr.namePart(0)=="") || (gr.namePart(1)=="") ) {
				reportMessage("\n" + T("Make a floor group current before inserting this TSL."));
				eraseInstance(); return;
			}
		}

		return;	
	}// end bOnInsert__________________________________________________________
	
	
// declare standards
	if (_Element.length() < 1)
	{
		eraseInstance();
		return;
	}

	Element el = _Element[0];
	if (!el.bIsValid()) return;

	CoordSys cs;
	Point3d ptOrg;
	Vector3d vx,vy,vz;

	cs = el.coordSys();
	ptOrg = cs.ptOrg();
	vx=cs.vecX();
	vy=cs.vecY();
	vz=cs.vecZ();
	
	//vx.vis(ptOrg,1);
	//vy.vis(ptOrg,3);
	//vz.vis(ptOrg,150);	
	
	LineSeg lsEl=el.segmentMinMax();
	Point3d ptCenterEl=lsEl.ptMid();
	
	_Pt0 = ptOrg;
	
// the rafter
	Beam bm = _Beam[0];
	if (!bm.bIsValid())
		return;
			
// get eroof
	ERoofPlane er;
	Entity ents[0];
	ents = _Entity;
	for (int e=0; e<ents.length(); e++) {
		er = (ERoofPlane)ents[e];
		if (er.bIsValid())
			break;
	}
	if (!er.bIsValid()) return;

	CoordSys csEr;
	Point3d ptOrgEr;
	Vector3d vxEr,vyEr,vzEr;
	csEr= er.coordSys();
	ptOrgEr= csEr.ptOrg();
	vxEr = csEr.vecX();
	vyEr = csEr.vecY();
	vzEr = csEr.vecZ();

	//vxEr.vis(ptOrgEr,1);
	//vyEr.vis(ptOrgEr,3);
	//vzEr.vis(ptOrgEr,150);
	
	PLine plEr = er.plEnvelope();
	plEr.vis(2);	
	Point3d ptEr[0];
	ptEr = plEr.vertexPoints(TRUE);
	ptEr = (Line(ptOrgEr,-vz)).orderPoints(ptEr);
	if (ptEr.length() < 1)
		return;
	//ptEr[0].vis(2);
	
// get overhang
	double dOverHang = vz.dotProduct(ptEr[0] - ptOrg);

// get eave point at rafter
	Plane pn(bm.ptCen() + vz * 0.5 * bm.dD(vz), vxEr);
	Point3d ptDistr[0];
	ptDistr = plEr.intersectPoints(pn);
	if (ptDistr.length() < 1)
		return;
	ptDistr= Line(ptEr[0], vyEr).orderPoints(ptDistr);
	
// Ladder PLine
	Point3d ptLadder[0];
	ptLadder.append(ptDistr[0]);
	ptLadder.append(ptDistr[1]);	
	ptLadder.append(ptDistr[1] + vz * vz.dotProduct(ptEr[0]-ptDistr[0]));	
	ptLadder.append(ptDistr[0] + vz * vz.dotProduct(ptEr[0]-ptDistr[0]));	

// define insertion point at eave
	Point3d ptEave = ptDistr[0];
	Point3d ptRidge = ptDistr[1];	
	ptDistr[0].transformBy(vyEr * (dDistBot + dWidth) -vzEr * dHeightTiling);	
	ptDistr[1].transformBy(-vyEr * (dDistTop+ dWidth) -vzEr * dHeightTiling);

//Display
	Display dp(nColor);
	dp.dimStyle(sDimStyle);

// define cuts
	Vector3d vxCut = vyEr.crossProduct(_ZW).crossProduct(_ZW);
	Cut ctEave(ptEave, vxCut);
	Cut ctRidge(ptRidge, -vxCut);
	Cut ctFrontCut(ptEave - _ZW * dHeightFrontCut , -_ZW);
	
//Find inside point of cuts to distribute battens
	Point3d ptUnderBatten=ptEave;
	ptUnderBatten.transformBy(-vzEr * (dHeightTiling+dHeight));
	Line lnUnderBatten(ptUnderBatten, vyEr);
	Plane plnEave(ptEave - _ZW * dHeightFrontCut, _ZW);
	Plane plnRidge(ptRidge, -vxCut);
	Plane plnZEr(ptRidge-vzEr * dHeightTiling, -vzEr);
	ptDistr[0]=lnUnderBatten.intersect(plnEave, 0);
	ptDistr[1]=lnUnderBatten.intersect(plnRidge, 0);
	ptDistr[0].transformBy(vyEr * (dDistBot+dWidth));
	ptDistr[1].transformBy(-vyEr * (dDistTop+dWidth));
	
	ptDistr=plnZEr.projectPoints(ptDistr);
	
	
	ptDistr[0].vis(1);
	ptDistr[1].vis(3);
// distribution
	double dDist = abs(vyEr.dotProduct(ptDistr[0]-ptDistr[1]));
	double dNum = dDist / dMyDistr;
	int nNum =  dNum + 0.5;
	
	double dBattenLength = abs(vz.dotProduct(ptEr[0]-ptDistr[0])-(2*dWidthOutsideRail));//+dWidthInsideRail));
	//ptEr[0].vis(3);
	//ptDistr[0].vis(5);
// declare insertion points
	// firestop
	double dOutsideZones;
	for (int i = 1; i < 6; i++)
		dOutsideZones = dOutsideZones + el.zone(i).dH();
	Point3d ptFireStop = ptEave + vz * (vz.dotProduct(ptOrg - ptEave) + dOutsideZones) - 
		vzEr * (dHeight + dHeightTiling) ;	
	//ptFireStop.vis(2);
	
	// create Soffit
	Point3d ptSoffit = ptFireStop + vz * (dExtLeafThick + dWidthFirestop);
	//ptSoffit.vis(3);	
		
	// declare debugBody and beam collection
	Body bd;
	Beam bmComp[0], bm1, bmCR[0];	
	
// distribute debug bodies	or beams
	if (nDebugMaster){// first and last
		bd = Body(ptDistr[0] + vz * dWidthOutsideRail, vz, vyEr, vzEr, dBattenLength , dWidth, dHeight,1,-1,-1);
		dp.draw(bd);
		bd = Body(ptDistr[1] + vz * dWidthOutsideRail, vz, vyEr, vzEr, dBattenLength , dWidth, dHeight,1,1,-1);
		dp.draw(bd);
	}

// check valid input
	int bOk = FALSE;
	if (nDebugMaster || (dBattenLength > 0 && dWidth>0 && dHeight>0))
		bOk = TRUE;
	
// distribute bodies or beams
	if(nNum > 2 && bOk){  
		for (int i = 0; i < nNum; i++){
			Point3d ptIns = ptDistr[1] - vyEr * (i+1) * dMyDistr + vz * dWidthOutsideRail;
			if (vyEr.dotProduct(ptIns - ptDistr[0] ) > dWidth){
				if (nDebugMaster){
					bd = Body(ptIns , vz, vyEr, vzEr, dBattenLength , dWidth, dHeight,1,1,-1);
					dp.draw(bd);
				}
				else{
					bm1.dbCreate(ptIns , vz, vyEr, vzEr, dBattenLength , dWidth, dHeight,1,1,-1);
					bmComp.append(bm1);	
				}
			}
			else{
				if (nDebugMaster){
					bd = Body(ptDistr[0] + vz * dWidthOutsideRail , vz, vyEr, vzEr, dBattenLength , dWidth, dHeight,1,1,-1);
					dp.draw(bd);
				}					
				else{
					bm1.dbCreate(ptDistr[0] + vz * dWidthOutsideRail , vz, vyEr, vzEr, dBattenLength , dWidth, dHeight,1,1,-1);					
					bmComp.append(bm1);	
				}
			}
		}
	}
	else if(dDist < dMyDistr && bOk){
		if (nDebugMaster){
			bd = Body(ptDistr[1] + vz * dWidthOutsideRail , vz, vyEr, vzEr, dBattenLength , dWidth, dHeight,1,-1,-1);
			dp.draw(bd);
			bd = Body(ptDistr[0] + vz * dWidthOutsideRail , vz, vyEr, vzEr, dBattenLength , dWidth, dHeight,1,1,-1);
			dp.draw(bd);
		}
		else{
			bm1.dbCreate(ptDistr[1] + vz * dWidthOutsideRail , vz, vyEr, vzEr, dBattenLength , dWidth, dHeight,1,-1,-1);				
			bmComp.append(bm1);		
			bm1.dbCreate(ptDistr[0]  + vz * dWidthOutsideRail, vz, vyEr, vzEr, dBattenLength , dWidth, dHeight,1,1,-1);		
			bmComp.append(bm1);	
		}			
	}
	else{
		if (bOk){
			if (nDebugMaster){
				bd = Body(ptDistr[1] + vz * dWidthOutsideRail , vz, vyEr, vzEr, dBattenLength , dWidth, dHeight,1,-1,-1);
				bd.transformBy(-vyEr * dMyDistr);
				dp.draw(bd);
				bd = Body(ptDistr[0]  + vz * dWidthOutsideRail, vz, vyEr, vzEr, dBattenLength , dWidth, dHeight,1,1,-1);
				dp.draw(bd);
			}
			else{
				bm1.dbCreate(ptDistr[1] + vz * dWidthOutsideRail , vz, vyEr, vzEr, dBattenLength , dWidth, dHeight,1,-1,-1);
				bm1.transformBy(-vyEr * dMyDistr);			
				bmComp.append(bm1);			
				bm1.dbCreate(ptDistr[0] + vz * dWidthOutsideRail , vz, vyEr, vzEr, dBattenLength , dWidth, dHeight,1,1,-1);			
				bmComp.append(bm1);	
					
			}
		}			
	}	
	
	
	for (int i = 0; i < bmComp.length(); i++){
		bmComp[i].setColor(1);
		bmComp[i].setName("Crossrail");
		bmComp[i].setGrade(sMat);
		bmComp[i].setSubLabel2("Manufactured Element");			
	}
	// assign the beams to crossrail collection
	bmCR = bmComp;
		
		
// show bodies in debug mode
	if (nDebugMaster){
		//reportNotice("\n" + dBattenLength + " " + dWidthTiling + " / " + dHeightTiling);
	// create Tiling Batten
		//bd = Body(ptEave + vz * dBattenLength/2 , vyEr, vxEr, vzEr, U(10000) , dWidthTiling, dHeightTiling,0,0,-1);
		Point3d ptNewTiling=Line(ptEave, vxEr).closestPointTo(ptCenterEl);
		bd = Body(ptNewTiling, vyEr, vxEr, vzEr, U(10000) , dWidthTiling, dHeightTiling,0,0,-1);
		
		bd.addTool(ctEave,1);
		bd.addTool(ctRidge,1);
		bd.addTool(ctFrontCut,0);	
		dp.color(255);	
		dp.draw(bd);

	// create Inside Rail
		bd = Body(ptEave, vyEr, vxEr, vzEr, U(10000) , dWidthOutsideRail, dHeightOutsideRail,0,1,-1);
		bd.addTool(ctEave,1);
		bd.addTool(ctRidge,1);
		bd.addTool(ctFrontCut,0);	
		dp.color(1);		
		dp.draw(bd);

			
	// create Outside Rail
		bd = Body(ptEave + vz * (dBattenLength + dWidthOutsideRail), vyEr, vxEr, vzEr, U(10000) , dWidthOutsideRail, dHeightOutsideRail,0,1,-1);
		bd.addTool(ctEave,1);
		bd.addTool(ctRidge,1);
		bd.addTool(ctFrontCut,0);	
		dp.color(1);		
		dp.draw(bd);
	
	// create Outside Rail Packer
		bd = Body(ptEave + vz * (dBattenLength + dWidthOutsideRail) - vyEr * dHeightOutsideRail, vyEr, vxEr, vzEr, 
					U(10000) , dWidthOutsideRailPacker, dHeightOutsideRailPacker,0,1,-1);
		bd.addTool(ctEave,1);
		bd.addTool(ctRidge,1);
		bd.addTool(ctFrontCut,0);	
		dp.draw(bd);
	
	// create FireStop
		bd = Body(ptFireStop, vyEr, vxEr, vzEr, 
					U(10000) , dWidthFirestop, dHeightFirestop,0,1,-1);		
		bd.addTool(ctEave,1);
		bd.addTool(ctRidge,1);
		bd.addTool(ctFrontCut,0);			
		dp.color(5);
		dp.draw(bd);
	

		bd = Body(ptSoffit , vyEr, vxEr, vzEr, 
					U(10000) , dWidthSoffitA, dHeightSoffitA,0,1,-1);		
		bd.addTool(ctEave,1);
		bd.addTool(ctRidge,1);
		bd.addTool(ctFrontCut,0);			
		dp.color(2);
		dp.draw(bd);
		
		bd = Body(ptSoffit , vyEr, vxEr, vzEr, 
					U(10000) , dWidthSoffitB, dHeightSoffitB,0,1,-1);		
		bd.transformBy(-vzEr * dHeightSoffitA);
		bd.addTool(ctEave,1);
		bd.addTool(ctRidge,1);
		bd.addTool(ctFrontCut,0);			
		dp.color(3);
		dp.draw(bd);		
	}// end if debugMaster	

		
//create beams and erase instance
	else{
	// check valid input
		bOk = FALSE;
		if (dBattenLength > 0 &&dWidth>0 && dHeight>0)
			bOk = TRUE;		
		
		if(bOk){
		// first and last
			bm1.dbCreate(ptDistr[0]+ vz * dWidthOutsideRail, vz, vyEr, vzEr, dBattenLength , dWidth, dHeight,1,-1,-1);
			bm1.addTool(ctEave,1);
			bm1.addTool(ctRidge,1);
			bm1.addTool(ctFrontCut,0);	
			bm1.setColor(1);	
			bm1.setName("Crossrail");
			bm1.setSubLabel2("Manufactured Element");
			bm1.setGrade(sMat);						
			bmComp.append(bm1);
			bmCR.append(bm1);
			
			bm1.dbCreate(ptDistr[1]+ vz * dWidthOutsideRail, vz, vyEr, vzEr, dBattenLength , dWidth, dHeight,1,1,-1);
			bm1.addTool(ctEave,1);
			bm1.addTool(ctRidge,1);
			bm1.addTool(ctFrontCut,0);		
			bm1.setColor(1);
			bm1.setName("Crossrail");
			bm1.setSubLabel2("Manufactured Element");
			bm1.setGrade(sMat);								
			bmComp.append(bm1);
			bmCR.append(bm1);			
		}
		
		
		// create Tiling Batten
		bOk = FALSE;
		if (bm.dL() > 0 &&dWidthTiling>0 && dHeightTiling>0)
			bOk = TRUE;		

		if(bOk){	
			//bm1.dbCreate(ptEave + vz * dBattenLength/2 , vyEr, vz, vzEr, bm.dL()*2 , dWidthTiling, dHeightTiling,0,0,-1);
			Point3d ptNewTiling=Line(ptEave, vxEr).closestPointTo(ptCenterEl);
			bm1.dbCreate(ptNewTiling, vyEr, vz, vzEr, bm.dL()*2 , dWidthTiling, dHeightTiling,0,0,-1);
			
			bm1.addToolStatic(ctEave,1);
			bm1.addToolStatic(ctRidge,1);
			bm1.addToolStatic(ctFrontCut,0);	
			bm1.setColor(2);
			bm1.setName("Tiling Batten");
			bm1.setSubLabel2("Manufactured Element");
			bm1.setGrade(sMat);					
			bmComp.append(bm1);	
		}
		
		// create Inside Rail
		bOk = FALSE;
		if (bm.dL() > 0 && dWidthInsideRail>0 && dHeightInsideRail>0)
			bOk = TRUE;

		if(bOk){
			bm1.dbCreate(ptEave , vyEr, vz, vzEr, bm.dL()*2 , dWidthInsideRail, dHeightInsideRail,0,1,-1);
			bm1.addToolStatic(ctEave,1);
			bm1.addToolStatic(ctRidge,1);
			bm1.addToolStatic(ctFrontCut,0);
			bm1.setColor(2);
			bm1.setName("Inside Rail");
			bm1.setSubLabel2("Manufactured Element");
			bm1.setGrade(sMat);							
			bmComp.append(bm1);
			for (int i = 0; i < bmCR.length();i++)
				bmCR[i].stretchDynamicTo(bm1);
		}	
		
		// create Outside Rail
		bOk = FALSE;
		if (bm.dL() > 0 && dWidthOutsideRail>0 && dHeightOutsideRail>0)
			bOk = TRUE;			

		if(bOk){		
			bm1.dbCreate(ptEave + vz * (dBattenLength + dWidthOutsideRail) , vyEr, vz, vzEr, bm.dL()*2 , dWidthOutsideRail, dHeightOutsideRail,0,1,-1);
			bm1.addToolStatic(ctEave,1);
			bm1.addToolStatic(ctRidge,1);
			bm1.addToolStatic(ctFrontCut,0);
			bm1.setColor(2);
			bm1.setName("Outside Rail");
			bm1.setSubLabel2("Manufactured Element");
			bm1.setGrade(sMat);
			bmComp.append(bm1);
			for (int i = 0; i < bmCR.length();i++)
				bmCR[i].stretchDynamicTo(bm1);
		}
		
		
	// create Outside Rail Packer
		bOk = FALSE;
		if (bm.dL() > 0 && dWidthOutsideRailPacker>0 && dHeightOutsideRailPacker>0)
			bOk = TRUE;		
	
		if (bOk){
			bm1.dbCreate(ptEave + vz * (dBattenLength + dWidthOutsideRail) - vyEr * dHeightOutsideRail, vyEr, vz, vzEr, 
					bm.dL()*2 , dWidthOutsideRailPacker, dHeightOutsideRailPacker,0,1,-1);
			bm1.transformBy(-vzEr * dHeightOutsideRail);
			bm1.addToolStatic(ctEave,1);
			bm1.addToolStatic(ctRidge,1);
			bm1.addToolStatic(ctFrontCut,0);	
			bm1.setColor(2);	
			bm1.setName("Outside Rail Packer");
			bm1.setSubLabel2("Manufactured Element");
			bm1.setGrade(sMat);			
			bmComp.append(bm1);	
		}
		
	// create FireStop
		bOk = FALSE;
		if (bm.dL() > 0 && dWidthFirestop>0 && dHeightFirestop>0)
			bOk = TRUE;	
			
		if (bOk){
			bm1.dbCreate(ptFireStop, vyEr, vz, vzEr, 
					bm.dL()*2 , dWidthFirestop, dHeightFirestop,0,1,-1);		
			bm1.addToolStatic(ctEave,1);
			bm1.addToolStatic(ctRidge,1);
			bm1.addToolStatic(ctFrontCut,0);	
			bm1.setColor(2);	
			bm1.setName("Firestop");
			bm1.setSubLabel2("Manufactured Element");
			bm1.setGrade(sMat);						
			bmComp.append(bm1);	
		}


	// create soffit A
		bOk = FALSE;
		if (bm.dL() > 0 && dWidthSoffitA>0 && dHeightSoffitA>0)
			bOk = TRUE;	
		
		if (bOk){		
			bm1.dbCreate(ptSoffit , vyEr, vz, vzEr, 
					bm.dL()*2 , dWidthSoffitA, dHeightSoffitA,0,1,-1);		
			bm1.addToolStatic(ctEave,1);
			bm1.addToolStatic(ctRidge,1);
			bm1.addToolStatic(ctFrontCut,0);	
			bm1.setColor(2);
			bm1.setName("Soffit");
			bm1.setSubLabel2("Manufactured Element");
			bm1.setGrade(sMat);						
			bmComp.append(bm1);
		}
		
	// create soffit B
		bOk = FALSE;
		if (bm.dL() > 0 && dWidthSoffitB>0 && dHeightSoffitB>0)
			bOk = TRUE;
			
		if (bOk){							
			bm1.dbCreate(ptSoffit , vyEr, vz, vzEr, 
					bm.dL()*2 , dWidthSoffitB, dHeightSoffitB,0,1,-1);		
			bm1.transformBy(-vzEr * dHeightSoffitA);
			bm1.addToolStatic(ctEave,1);
			bm1.addToolStatic(ctRidge,1);
			bm1.addToolStatic(ctFrontCut,0);	
			bm1.setColor(2);	
			bm1.setName("Soffit");
			bm1.setSubLabel2("Manufactured Element");
			bm1.setGrade(sMat);				
			bmComp.append(bm1);			
		}		

		// user wants to create component
		if (sCompName != ""){
			Group gr = _kCurrentGroup;
			
			// declare tsl props
			TslInst tsl;
			Vector3d vecUcsX = vxEr;
			Vector3d vecUcsY = vyEr;

			Entity lstEnts[0];
			Beam lstBeams[0];
			lstBeams = bmComp;
			Point3d lstPoints[0];
			int lstPropInt[0];
			double lstPropDouble[0];
			String lstPropString[0];
			
			Point3d ptLadderMid;
			ptLadderMid.setToAverage(ptLadder);
			lstPoints.append(ptLadderMid);
			for (int i = 0; i < ptLadder.length();i++)
				lstPoints.append(ptLadder[i]);
			lstPropString.append(sDimStyle);
			lstPropString.append(sCompName);
			lstPropString.append(sNotes);
			lstPropInt.append(nColor);				
			tsl.dbCreate("hsb_CreateElement", vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints, lstPropInt, lstPropDouble,lstPropString );
			//Map map;
			//map.setPLine("ComponentOutline", plLadder);
			//tsl.setMap(map);
		}
		eraseInstance();
	}	

#End
#BeginThumbnail
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
?`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`__V2B@
`

#End
