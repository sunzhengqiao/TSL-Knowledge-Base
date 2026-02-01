#Version 8
#BeginDescription
A generic routine for removing a box volume from a beam, to be used in a CollectionEntity in combination with ApplyCustomAssembly TSL
V1.0 4/21/2022 Public Release cc

V0.72_21December2016_Changed BeamCut to Mortise and added Property for corner round type
V0.70__15September2016__Assigned display to "CE_Tools" if it exists
V0.65__14September2016__Improved graphics
V0.60_11September2016__Add Target Beams Property and function
V0.55__11September2016__Revised tool information storage format
V0.50__11September2016__Incepetion

V0.50_10September2016__Inception









V1.10 4/22/2022 Additional grips and associated display cc

V1.13 4/22/2022 Bugfix on Grip management cc

V1.15 4/22/2022 Bugfix on rotation dragging cc

V1.16 2/24/2023 Bugfix in showing graphics in special display rep cc

1.18 3/28/2024 Bugfix in insertion routine cc
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 18
#KeyWords 
#BeginContents
	/*
	
	<>--<>--<>--<>--<>--<>--<>--<>____ Craig Colomb _____<>--<>--<>--<>--<>--<>--<>--<>
	
	A generic routine for removing a box volume from a beam with the finger mill.
	Color alerts for dimensions exceeding common Hundegger capacity.
	Rotation along axis normal to face only, K1 K2 compatible.
	
	Email cc@craigcad.us
	© Craig Colomb 2006
	
	V0.0 __1JULY2006____ Initial concept and creation
	V0.5___5JULY2006____fix some bugs dealing with grip edits
	V0.7___4AUG2006_____fix bug with offset changing. streamlined execution
	V1.0___9MARCH2007__ Released for publication
	
	<>--<>--<>--<>--<>--<>--<>--<>_____  craigcad.us  _____<>--<>--<>--<>--<>--<>--<>--<>
	
	
	*/
	double dEqTol = U(.1, "mm");
	_ThisInst.setAllowGripAtPt0(false);
	
	//--------------------------------------------------Declare Properties-----------------------------
	PropDouble pdCutDepth ( 0, U(50), T( "Cut Depth @ Center" ) ) ;
	PropDouble pdCutLength( 1, U(50), T( "Cut Length" ) ) ;
	PropDouble pdCutWidth ( 2, U(12), T( "Cut Width" ) ) ;
	
	String stTargetBeams[] = {"Parent", "Children", "All"};
	PropString psTargetBeam(0, stTargetBeams, "Target Beams", 2);
	
	int iRoundTypes[] = { _kNotRound, _kRound, _kRelief, _kRoundSmall, _kReliefSmall, _kRounded};
	String stRoundTypes[] = { "Not Round", "Round", "Relief", "Round Small", "Relief Small", "Rounded"};
	PropString psRoundType (1, stRoundTypes, "Corner Rounding");
	int iRoundType = iRoundTypes[stRoundTypes.find(psRoundType)];
	
	String stToolTypes[] = { "BeamCut", "House", "Slot"};
	PropString psToolType(2, stToolTypes, "Tool Type");
	
	int bInDebug = projectSpecial() == "db";
	if (_bOnDebug) bInDebug = true;

	
	if(_bOnInsert)
	{
		if(insertCycleCount() > 1)
		{ 
			eraseInstance();
			return;
		}
		
		showDialogOnce();
		
		Point3d ptLocation = getPoint("Select Insertion Point");
		_Pt0 = ptLocation;
		PrPoint prp("Select Tool Insert Direction", ptLocation);
		Vector3d vCutDir, vWidth;
		if(prp.go() == _kOk)
		{ 
			Point3d pt = prp.value();
			vCutDir = pt - ptLocation;
			//vCutDir.normalize();
		}
		else
		{ 
			eraseInstance();
			return;
		}
		
		if (vCutDir.length() < U(.001, "inch"))
		{ 
			reportMessage("\nBad pick, could not determine directon");
			eraseInstance();
			return;
		}
		
		if(pdCutLength ==0)
		{ 
			pdCutLength.set(vCutDir.length());
		}
		
		vCutDir.normalize();
		
		PrPoint prpWidth("Select Width Direction", _Pt0);
		Map mpJig;
		mpJig.setVector3d("vCutDir", vCutDir);
		mpJig.setDouble("dDepth", pdCutDepth);
		mpJig.setDouble("dWidth", pdCutWidth);
		mpJig.setDouble("dLength", pdCutLength);
	
		if(prpWidth.goJig("", mpJig) == _kOk)
		{ 
			Point3d pt = prpWidth.value();
			vWidth = pt - _Pt0;
		}
		

		vWidth.normalize();
		Vector3d vLength = vWidth.crossProduct(-vCutDir);

		//----------------------------Initialize grip array
		Point3d ptCutCen = _Pt0 + vCutDir * pdCutDepth / 2;
		_PtG.append( _Pt0 + vCutDir * pdCutDepth);
		_PtG.append( ptCutCen + vWidth * pdCutWidth / 2);
		_PtG.append( ptCutCen - vWidth * pdCutWidth / 2);
		_PtG.append( ptCutCen + vLength * pdCutLength / 2);
		_PtG.append( ptCutCen - vLength * pdCutLength / 2);
		_PtG.append(_Pt0 + vLength * pdCutLength / 2);
		_PtG.append(_Pt0 + vWidth * pdCutWidth / 2);
		_PtG.append(_Pt0 + vCutDir * pdCutWidth / 2);
		
		_Map.setVector3d("vLastDir", vCutDir);
		_Map.setVector3d("vLastWidth", vWidth);
	
		vLength.normalize();
		_Map.setVector3d("vLastLength", vLength);
		
		
		return;
	}
	
	
	
	if(_bOnJig)
	{ 
		
		Point3d ptBase = _Map.getPoint3d("_PtBase");
		Vector3d vCutDir = _Map.getVector3d("vCutDir");
		double dDepth = _Map.getDouble("dDepth");
		double dWidth = _Map.getDouble("dWidth");
		double dLength = _Map.getDouble("dLength");
		Point3d ptJig = _Map.getPoint3d("_PtJig");
		
		Plane pnBase(ptBase, vCutDir);
		Vector3d vView = getViewDirection();
		Line lnProjectView (ptJig, vView);
		Point3d ptInt = lnProjectView.intersect(pnBase, 0);

		Vector3d vWidth = ptInt - ptBase;
		if (vWidth.length() < U(.0001, "inch")) return;
		vWidth.normalize();
		
		Vector3d vLength = vWidth.crossProduct(-vCutDir);
		if (vLength.length() < U(.001, "inch")) return;
		vLength.normalize();
		
		
		Body bdJig(ptBase, vLength, vWidth, vCutDir, dLength, dWidth, dDepth, 0, 0, 1);
		Display dpJig(3);
		dpJig.draw(bdJig);
		
		return;
	}

	//---------------------------------------------Create CoordSys for tool, gather information ----------
	Point3d& ptCutBase = _Pt0;
	Point3d& ptDepth = _PtG[0];
	Point3d& ptPosWidth = _PtG[1];
	Point3d& ptNegWidth = _PtG[2];
	Point3d& ptPosLength = _PtG[3];
	Point3d& ptNegLength = _PtG[4];
	Point3d& ptYRotate = _PtG[5];
	Point3d& ptZRotate = _PtG[6];
	Point3d& ptXRotate = _PtG[7];
	
	
	
	Vector3d vCutDir = _Map.getVector3d("vLastDir");
	Vector3d vWidth = _Map.getVector3d("vLastWidth");
	Vector3d vLength = _Map.getVector3d("vLastLength");	
	
	Point3d ptCutCen = ptCutBase + vCutDir * pdCutDepth / 2;
	
	Line lnX (ptCutCen, vLength);
	Line lnY (ptCutCen, vWidth);
	Line lnZ (ptCutCen, vCutDir);
	Line lnAxes[] = {lnZ, lnY, lnY,  lnX, lnX};

//region  Grip Management
//######################################################################################		
//######################################################################################	
//
	addRecalcTrigger(_kGripPointDrag, "_Pt0");
	addRecalcTrigger(_kGripPointDrag, "_PtG5");
	addRecalcTrigger(_kGripPointDrag, "_PtG6");
	addRecalcTrigger(_kGripPointDrag, "_PtG7");
	
	
	//__Maintain centerlines
	for(int i=0; i<5; i++) 
	{
		_PtG[i] = lnAxes[i].closestPointTo(_PtG[i]);
	}
	
	int gripNumber = _kExecuteKey.right(1).atoi();
	int bIsRotateGrip = 5 <= gripNumber && gripNumber <=7;
	
	reportMessage("\n" + scriptName() + ", execute key: " + _kExecuteKey + ", GripPoint: " + gripNumber);
	
	
	if(_bOnGripPointDrag && bIsRotateGrip)
	{ 
		Body bdJig(ptCutBase, vLength, vWidth, vCutDir, pdCutLength, pdCutWidth, pdCutLength, 0, 0, 1);
		Display dpJig(3);
		Display dpHintGraphic(2);
		
		Vector3d vView = getViewDirection();		
		Point3d& ptJig = _PtG[gripNumber];
		Line lnPick(ptJig, vView);
		
		PLine plRange;
		Plane pnRotate;
		Vector3d vRotate;
		Vector3d vRef;
		Point3d ptProjected;
		
		
		//__Grip 5 rotates around Width
		if(gripNumber == 5)
		{ 
			vRotate = vWidth;			
			pnRotate = Plane(ptCutBase, vWidth);
			plRange.createCircle(ptCutBase, vWidth, pdCutLength/2);
			vRef = vLength;
		}
		
		//__Grip 6 rotates around CutDir
		if(gripNumber == 6)
		{ 
			vRotate = -vCutDir;			
			pnRotate = Plane(ptCutBase, -vCutDir);
			plRange.createCircle(ptCutBase, -vCutDir, pdCutWidth/2);	
			vRef = vWidth;
		}
		
		//__Grip 7 rotates around Length
		if(gripNumber == 7)
		{ 
			vRotate = vLength;			
			pnRotate = Plane(ptCutBase, vLength);
			plRange.createCircle(ptCutBase, vLength, pdCutWidth/2);
			vRef = vCutDir;
		}
		
		dpHintGraphic.draw(plRange);
		
		ptJig = lnPick.intersect(pnRotate, 0);
		ptJig = plRange.closestPointTo(ptJig);
		
		double dViewH = getViewHeight();
		double dPickH = dViewH / 85;
		PLine plHint;
		plHint.createCircle(ptJig, vRotate, dPickH);
		PlaneProfile ppHint(plHint);
		Display dpPicked(120);
		dpPicked.draw(ppHint, _kDrawFilled);
		
		Vector3d vPicked = ptJig - ptCutBase;
		double dRotate = vPicked.angleTo(vRef, -vRotate);
		CoordSys csRotate;
		csRotate.setToRotation(dRotate, vRotate, ptCutBase);
		bdJig.transformBy(csRotate);
		
		dpJig.draw(bdJig);
	}
	
	int iGripIndex = _kNameLastChangedProp.right(1).atoi();
	int bSetAllGrips;
	
	if(iGripIndex == 5 || iGripIndex == 6 || iGripIndex == 7)
	{ 
		Vector3d vRotateDirs[] = { vWidth, -vCutDir, vLength};
		Vector3d vRefDirs[] = { vLength, vWidth, vCutDir};
		Vector3d vRotate = vRotateDirs[iGripIndex - 5];
		Vector3d vRef = vRefDirs[iGripIndex - 5];
		Point3d ptPicked = _PtG[iGripIndex];
		
		
		Plane pnRot(ptCutBase, vRotate);
		Line lnProject (ptPicked, getViewDirection());
		ptPicked = lnProject.intersect(pnRot, 0);
		
		Vector3d vPicked = ptPicked - ptCutBase;
		
		
		double dRotate = vPicked.angleTo(vRef, -vRotate);
		CoordSys csRotate;
		csRotate.setToRotation(dRotate, vRotate, ptCutBase);
		vCutDir.transformBy(csRotate);
		vLength.transformBy(csRotate);
		vWidth.transformBy(csRotate);
		_Map.setVector3d("vLastDir", vCutDir);
		_Map.setVector3d("vLastLength", vLength);
		_Map.setVector3d("vLastWidth", vWidth);
		
		bSetAllGrips = true;
	}
	
	
	
	
	if(bSetAllGrips)
	{ 
		ptCutCen = ptCutBase + vCutDir * pdCutDepth/2;
		ptDepth = ptCutBase + vCutDir * pdCutDepth;
		ptPosWidth = ptCutCen + vWidth * pdCutWidth / 2;
		ptNegWidth = ptCutCen - vWidth * pdCutWidth / 2;
		ptPosLength = ptCutCen + vLength * pdCutLength / 2;
		ptNegLength = ptCutCen - vLength * pdCutLength / 2;
		
		ptYRotate = ptCutBase + vLength * pdCutLength / 2;
		ptZRotate = ptCutBase + vWidth * pdCutWidth / 2;
		ptXRotate = ptCutBase + vCutDir * pdCutWidth / 2;
	}
	
	//-------Depth Grip 
	if ( _kNameLastChangedProp == "_PtG0" ) 
	{		
		Vector3d vDepth = ptDepth - ptCutBase;
		double dNewDepth = vDepth.length();
		pdCutDepth.set(dNewDepth);
		
		ptCutCen = ptCutBase + vCutDir * pdCutDepth / 2;

		Plane pnMid (ptCutCen, -vCutDir);
		for(int i=1; i<5; i++) _PtG[i] = pnMid.closestPointTo(_PtG[i]);
	}
		
	
	//-------Width Direction
	if ( _kNameLastChangedProp == "_PtG1" ||  _kNameLastChangedProp == "_PtG2"  ) 
	{
		Vector3d vNewWidth = ptPosWidth - ptNegWidth;
		double dNewWidth = vNewWidth.length();
		pdCutWidth.set(dNewWidth);
		
		Point3d ptNewMid = ptNegWidth + vNewWidth / 2;		
		Plane pnMid (ptNewMid, vWidth);
		ptCutBase = pnMid.closestPointTo(ptCutBase);
		int updateIndexes[] = { 0, 3, 4, 5, 7};
		for(int i=0; i<updateIndexes.length(); i++)
		{
			int index = updateIndexes[i];
			_PtG[index] = pnMid.closestPointTo(_PtG[index]);
		}
		
		ptZRotate = ptCutBase + vWidth * pdCutWidth / 2;
	}
	
	
	
	//-------Length Direction
	if ( _kNameLastChangedProp == "_PtG4" ||  _kNameLastChangedProp == "_PtG3"  ) 
	{		
		Vector3d vNewLength = ptPosLength - ptNegLength;
		double dNewLength = vNewLength.length();
		pdCutLength.set(dNewLength);
		
		Point3d ptNewMid = ptNegLength + vNewLength / 2;
		Plane pnMid (ptNewMid, vLength);
		ptCutBase = pnMid.closestPointTo(ptCutBase);
		int updateIndexes[] = { 0, 1, 2, 5, 7};
		for(int i=0; i<updateIndexes.length(); i++)
		{
			int index = updateIndexes[i];
			_PtG[index] = pnMid.closestPointTo(_PtG[index]);
		}	
		
		ptYRotate = ptCutBase + vLength * pdCutLength / 2;
	}

	
	//------Reset grips in case of Property edits by user
	if(_kNameLastChangedProp == "Cut Length @ Center")
	{
		ptDepth =  ptCutBase + vCutDir * pdCutDepth ; //  PtG[0]
	}
	
	if(_kNameLastChangedProp == "Cut Width")
	{
		Vector3d vFullWidth = vWidth * pdCutWidth;
		Point3d ptNewMid = ptNegWidth + vFullWidth / 2;
		Plane pnNewMid(ptNewMid, vWidth);
		ptCutBase = pnNewMid.closestPointTo(ptCutBase);
		
		int updateIndices[] = { 0, 3, 4, 5, 7};
		for(int i=0; i<updateIndices.length(); i++)
		{
			int index = updateIndices[i];
			_PtG[index] = pnNewMid.closestPointTo(_PtG[index]);
		}
		
		ptCutCen = ptCutBase + vCutDir * pdCutDepth / 2;
		ptPosWidth = ptCutCen + vWidth * .5 * pdCutWidth ; //  PtG[2]
		ptNegWidth = ptCutCen - vWidth * .5 * pdCutWidth ; //  PtG[3]
		ptZRotate = ptCutBase + vWidth * pdCutWidth / 2;
	}
	
	if(_kNameLastChangedProp == "Cut Length")
	{
		Vector3d vFullLength = vLength * pdCutLength;
		Point3d ptNewMid = ptNegLength + vFullLength / 2;
		Plane pnNewMid(ptNewMid, vLength);
		ptCutBase = pnNewMid.closestPointTo(ptCutBase);
		
		int updateIndices[] = { 0, 1, 2, 6, 7};
		for(int i=0; i<updateIndices.length(); i++)
		{
			int index = updateIndices[i];
			_PtG[index] = pnNewMid.closestPointTo(_PtG[index]);
		}
		
		ptCutCen = ptCutBase + vCutDir * pdCutDepth / 2;
		ptPosLength = ptCutCen + vLength * .5 * pdCutLength ; //  PtG[4]
		ptNegLength = ptCutCen - vLength * .5 * pdCutLength ; //  PtG[5]
		ptYRotate = ptCutBase + vLength * pdCutLength / 2;
	}
	
//######################################################################################
//######################################################################################	
//endregion End Grip Management 			


	
	//-----------------Draw Display
	
	Display dp ( 1 ) ;
	String stDisplayReps[] = TslInst().dispRepNames();
	if (stDisplayReps.find("CE_Tools") >=0) dp.showInDispRep("CE_Tools");
	
	Body bdCut (ptCutBase, vLength, vWidth, -vCutDir, pdCutLength, pdCutWidth, pdCutDepth, 0, 0, -1);
	dp.draw(bdCut);
	
	Point3d ptArrowEnd = ptDepth;
	PLine plArrow(ptCutBase, ptArrowEnd, ptArrowEnd - vCutDir * U(4) + vLength * U(2), ptArrowEnd);
	plArrow.addVertex(ptArrowEnd - vCutDir * U(4) - vLength * U(2), ptArrowEnd);
	dp.draw(plArrow);
	CoordSys csRotate;
	csRotate.setToRotation(90, -vCutDir, ptCutBase );
	plArrow.transformBy(csRotate);
	dp.draw(plArrow);
	plArrow.createCircle(ptArrowEnd - vCutDir * U(4), - vCutDir, U(2));
	dp.draw(plArrow);
	
	Display dpHint(8);
	if (stDisplayReps.find("CE_Tools") >= 0) dpHint.showInDispRep("CE_Tools");
	double dCircleSize = pdCutWidth / 6;
	if (pdCutLength < pdCutWidth) dCircleSize = pdCutLength / 6;
	double dArrowScale =  dCircleSize / 3;
	double dCircleHeight = dCircleSize/2;
	
	PLine plWidth;
	plWidth.addVertex(ptPosWidth - vWidth * dArrowScale + vLength * dArrowScale);
	plWidth.addVertex(ptPosWidth);
	plWidth.addVertex(ptPosWidth - vWidth * dArrowScale - vLength * dArrowScale);
	plWidth.addVertex(ptPosWidth);
	plWidth.addVertex(ptNegWidth);
	
	plWidth.addVertex(ptNegWidth + vWidth * dArrowScale + vLength * dArrowScale);
	plWidth.addVertex(ptNegWidth);
	plWidth.addVertex(ptNegWidth + vWidth * dArrowScale - vLength * dArrowScale);
	plWidth.addVertex(ptNegWidth);
	dpHint.draw(plWidth);
	
	PLine plLength;
	plLength.addVertex(ptPosLength - vLength * dArrowScale + vWidth * dArrowScale);
	plLength.addVertex(ptPosLength);
	plLength.addVertex(ptPosLength - vLength * dArrowScale - vWidth * dArrowScale);
	plLength.addVertex(ptPosLength);
	
	plLength.addVertex(ptNegLength);
	plLength.addVertex(ptNegLength + vLength * dArrowScale + vWidth * dArrowScale);
	plLength.addVertex(ptNegLength);
	plLength.addVertex(ptNegLength + vLength * dArrowScale - vWidth * dArrowScale);
	plLength.addVertex(ptNegLength);
	dpHint.draw(plLength);
	
	PLine plZRotate(vCutDir);
	plZRotate.addVertex(ptZRotate - vWidth * dCircleHeight + vLength * dCircleSize);
	plZRotate.addVertex(ptZRotate - vWidth * dCircleHeight - vLength * dCircleSize, ptZRotate);
	dpHint.draw(plZRotate);
	
	PLine plYRotate(vWidth);
	plYRotate.addVertex(ptYRotate - vLength * dCircleHeight + vCutDir * dCircleSize);
	plYRotate.addVertex(ptYRotate - vLength * dCircleHeight - vCutDir * dCircleSize, ptYRotate);
	dpHint.draw(plYRotate);
	
	PLine plXRotate(vLength);
	plXRotate.addVertex(ptXRotate - vCutDir * dCircleHeight + vWidth * dCircleSize);
	plXRotate.addVertex(ptXRotate - vCutDir * dCircleHeight - vWidth * dCircleSize, ptXRotate);
	dpHint.draw(plXRotate);
	
	//-------------------Publish tool information
	Map mpBeamCut;
	mpBeamCut.setPoint3d("ptOrg", ptCutBase);
	mpBeamCut.setVector3d("vX", vLength);
	mpBeamCut.setVector3d("vY", vWidth);
	mpBeamCut.setVector3d("vZ", -vCutDir);
	
	mpBeamCut.setDouble("dX", pdCutLength);
	mpBeamCut.setDouble("dY", pdCutWidth);
	mpBeamCut.setDouble("dZ", pdCutDepth);
	mpBeamCut.setInt("iRoundType", iRoundType);
	mpBeamCut.setString("stToolType", psToolType);
	
	mpBeamCut.setString("stTargetBeams", psTargetBeam);
	_Map.setMap("mpBeamCut", mpBeamCut);
	
	
	
	

	
	
	
	
	
	
	
	
	
#End
#BeginThumbnail

















#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="0.03937008" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Bugfix in insertion routine" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="18" />
      <str nm="Date" vl="3/28/2024 2:08:07 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Bugfix in showing graphics in special display rep" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="16" />
      <str nm="Date" vl="2/24/2023 10:11:01 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Bugfix on rotation dragging" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="15" />
      <str nm="Date" vl="4/22/2022 5:25:52 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Bugfix on Grip management" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="13" />
      <str nm="Date" vl="4/22/2022 3:48:24 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Additional grips and associated display" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="10" />
      <str nm="Date" vl="4/22/2022 2:36:43 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Public Release" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="4/21/2022 1:30:30 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End