#Version 8
#BeginDescription
consumes analysed cuts

/// Version 2.4   th@hsbCAD.de   08.04.2010
/// bugfix additional point on x-dim for log profiles






#End
#Type E
#NumBeamsReq 1
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 0
#FileState 0
#MajorVersion 2
#MinorVersion 4
#KeyWords 
#BeginContents
/// <summary>
/// Consumes any tool of type analyzed cut and
/// creates several dimrequests in dependency of tool subtype and viewing direction
/// </summary>

/// <insert>
/// This tsl is only executed by the shopdraw engine and to use it one
/// needs to append it to the ruleset of a multipage style.
/// </insert>

/// <command name="showIndividualSide">
/// NOTE: this option has been depreciated. It now will be performed by the option 'setPreferredViewXDim=3'


/// <command name="ShowAllInOneLeft" Lang=en>
/// If the user appends an execution map in the format <command name>;<Off/On> the dimpoints
/// will be collected to a stereotype called 'LeftStart'. i.e.  'ShowAllInOneLeft;1' will enable
/// this option, while 'ShowAllInOneLeft;0' will disable it.
/// As this option can be set on beam level (sd_BmXX)other tools might collect their dimpoints to
/// the same dimline. The result will be dimline which consists of all tooling dimpoints on the left viewing side of the beam.
/// If the option 'DimFromStartEndLength' is enabled two dimlines on the referenced side will be created. The stereotype
/// which is used for the second dimline is called 'EndLeft'.
/// </command>

/// <command name="ShowAllInOneRight" Lang=en>
/// If the user appends an execution map in the format <command name>;<Off/On> the dimpoints
/// will be collected to a stereotype called 'RightStart'. i.e.  ShowAllInOneRight;1' will enable
/// this option, while ShowAllInOneRight;0' will disable it.
/// As this option can be set on beam level (sd_BmXX)other tools might collect their dimpoints to
/// the same dimline. The result will be dimline which consists of all tooling dimpoints on the right viewing side of the beam.
/// If the option 'DimFromStartEndLength' is enabled two dimlines on the referenced side will be created. The stereotype
/// which is used for the second dimline is called 'RightStart'.
/// </command>

/// <command name="StereotypeOverride">
/// If the user appends an execution map in the format Stereotype;<Stereotype> the corresponding
/// dimpoints will be collected in the designated stereotype dimline. If no stereotype is given 
/// the dimpoints will be collected in any dimline (Stereotype "*") respectivly to the stereotypes
/// "SectionLeft", "SectionRight" for sectional dimlines
/// Note: You need to append the stereotype name to each layout override of the ruleset of the 
/// multipage if you like to use this option

/// <command name="JapaneseStyle" Lang=en>
/// If the user appends an execution map in the format <command name>;<Off/On> the dimpoints
/// will be collected in the japanese style. The Japanese style has the following properties:
/// A) A tool collection of mortise, house and dove will only dimenion the dove. If no dove is in the collection the tools
/// will be collected individually.
/// B) The points dimensioned vary from the alignment of the beam in modelspace. Typically a post will collect the upper point
/// of the tool while a horizontal or rising beam will collect the center point.
/// C) If the tool supports Japanese symbol display the display is enabled if the user does not suppress it by the appropriate
/// option
/// This option can also be set on beam level (sd_BmXX) to preset this option for all tools which support this option.
/// </command>

/// <command name="HideAnglesCut" Lang=en>
/// If the user appends an execution map in the format <command name>;<index> the offset display can be influenced by the value given:
/// 'hideAnglesMortise;0' displays the angle of the tool in the appropriate view
/// 'hideAnglesMortise;1' does not display  the angle of the tool in the appropriate view

/// <command name="setPreferredViewXDim" Lang=en>
/// If the user appends an execution map in the format <command name>;<index> the dimpoints of the tool seen along the
/// the axis of the beam will appear 
/// 'setPreferredViewXDim;0' default view, can vary from tool properties
/// 'setPreferredViewXDim;1' left in side view
/// 'setPreferredViewXDim;2' right in side view
/// 'setPreferredViewXDim;3' on the side most aligned with the tool
/// 'setPreferredViewXDim;4' left in top view
/// 'setPreferredViewXDim;5' right in top view
/// </command>

/// <remark Lang=en>
/// Uses the following Stereotypes: *, optional LeftStart, LeftEnd, RightStart, RightEnd
/// </remark>

/// <version  value="2.3" date="22September09"></version>

/// History
/// Version 2.4   th@hsbCAD.de   08.04.2010
/// bugfix additional point on x-dim for log profiles
/// Version 2.3   th@hsbCAD.de   22.09.2009
/// The option 'showIndividualSide' has been depreciated. It now will be performed by the option 'setPreferredViewXDim=3'
/// Version 2.2   th@hsbCAD.de   13.07.2009
/// Dialog driven setup enhanced
/// half log cuts suppressed in sectional view
/// Version 2.1   th@hsbCAD.de   08.06.2009
/// supports Dialog driven setup of options
/// preferred View of X-Dimline introduced
/// Version 2.0   th@hsbCAD.de   30.03.2009
/// cummulative display standardized 
/// Version 1.8   th@hsbCAD.de   08.01.2009 
/// Version 1.8   th@hsbCAD.de   08.01.2009 
/// display of angles enhanced
/// Version 1.7   th@hsbCAD.de   08.01.2009
/// - StereotypeOverride added
/// - suppressAngles added
/// - showIndividualSide added
/// Version 1.6   th@hsbCAD.de   29.10.2008
/// Version 1.9   th@hsbCAD.de   16.03.2009
/// display of hip angle in sectional view enhanced

// basics and props
	U(1,"mm");
	double dEps = U(0.1);

	int nDebugViews = false;

// on insert
	if (_bOnInsert) {
		
		_Beam.append(getBeam());
		_Pt0 = getPoint("Select point near tool");
		return;
	}	
//end on insert________________________________________________________________________________


// declare the options to be set through the Map
	// NOTE: the CustomMapSettings and CustomMapTypes need to have the same length !
	String sCustomMapSettings[] = {"showAllInOneLeft","showAllInOneRight","hideAnglesCut", "dimFromStartEndLength","japaneseStyle",
		"showIndividualSide","setPreferredViewXDim"};
	String sCustomMapTypes[] = {"int","int","int","double","int","int","int"};

// on MapIO
	if (_bOnMapIO)
	{
		// define property
		String sArNY[] = {T("|No|"),T("|Yes|")};
		String sArPreferredViewXDim[] = {T("|Default|"),T("|left in side view|"),T("|right in side view|"),T("|on the side most aligned with the tool|"),T("|left in top view|"),T("|right in top view|")};		
		
		PropString showAllInOneLeft(0,sArNY,sCustomMapSettings[0]);
		PropString showAllInOneRight(1,sArNY,sCustomMapSettings[1]);
		PropString hideAnglesCut(2,sArNY,sCustomMapSettings[2]);
		PropString dimFromStartEndLength(3,"0",T("|Dimension from Start and End|"));
		PropString japaneseStyle(4,sArNY,sCustomMapSettings[4]);
		//PropString showIndividualSide(5,sArNY,sCustomMapSettings[5]);
		PropString setPreferredViewXDim(5,sArPreferredViewXDim,T("|Show dimpoints on x-axis|"));

		showAllInOneLeft.setDescription(T("|Will collect all dimpoints in one dimline with a certain stereotype.|") + " " + 
			T("|The stereotype name will be concatenated with the side prefix (Left/Right) and indicating if it is the Start or the End of the beam.|") + " " +
			T("|Default is <Side>Start, the separation in to Start/End will only apply if the 'Dimension from Start and End' matches the given length.|"));
		showAllInOneRight.setDescription(T("|Will collect all dimpoints in one dimline with a certain stereotype.|") + " " + 
			T("|The stereotype name will be concatenated with the side prefix (Left/Right) and indicating if it is the Start or the End of the beam.|") + " " +
			T("|Default is <Side>Start, the separation in to Start/End will only apply if the 'Dimension from Start and End' matches the given length.|"));
		
		hideAnglesCut.setDescription(T("|Disables the display of the angle of the tool in the appropriate view|"));
		dimFromStartEndLength.setDescription(T("|Beams which exceed the given value in length will be dimensioned with two dimlines.|") + " " +
			T("|The first dimline will all points from the start to the middle (Stereotype <Side>Start), while the other dimline will collect the remaining points into Stereotype <Side>Right|"));
		japaneseStyle.setDescription(T("|Sets japanes options to display dimlines|"));
		//showIndividualSide.setDescription(T("|Displays the tool location along the x-axis on the side where the tool applies (Default upper face))|"));				

									
	// find value in _Map, if found, change the property values
		showAllInOneLeft.set(sArNY[_Map.getString(sCustomMapSettings[0]).atoi()]);
		showAllInOneRight.set(sArNY[_Map.getString(sCustomMapSettings[1]).atoi()]);
		hideAnglesCut.set(sArNY[_Map.getString(sCustomMapSettings[2]).atoi()]);
		dimFromStartEndLength.set(_Map.getString(sCustomMapSettings[3]).atof());				
		japaneseStyle.set(sArNY[_Map.getString(sCustomMapSettings[4]).atoi()]);	
		//showIndividualSide.set(sArNY[_Map.getString(sCustomMapSettings[5]).atoi()]);	
		setPreferredViewXDim.set(sArPreferredViewXDim[_Map.getString(sCustomMapSettings[6]).atoi()]);	

	// show the dialog to the user
		showDialog("---"); // use "---" such that the set values are used, and not the last dialog values
		_Map = Map();

		int nInd;
		// interpret the properties, and fill _Map
		// by checking the index default values will not be written to _Map

		nInd = sArNY.find(showAllInOneLeft,0); 			if (nInd>0)  _Map.setString(sCustomMapSettings[0],nInd);
		nInd = sArNY.find(showAllInOneRight,0); 			if (nInd>0)  _Map.setString(sCustomMapSettings[1],nInd);
		nInd = sArNY.find(hideAnglesCut,0); 								if (nInd>0)  _Map.setString(sCustomMapSettings[2],nInd);
		if (dimFromStartEndLength.atof()>0)					  _Map.setString(sCustomMapSettings[3],dimFromStartEndLength);		
		nInd = sArNY.find(japaneseStyle,0);		if (nInd>0) _Map.setString(sCustomMapSettings[4],nInd);	
		//nInd = sArNY.find(showIndividualSide,0);		if (nInd>0) _Map.setString(sCustomMapSettings[5],nInd);	
		nInd = sArPreferredViewXDim.find(setPreferredViewXDim,0);	if (nInd>0) _Map.setString(sCustomMapSettings[6],nInd);

		return;
	}




// Compose a _Map from the beam, in case the Tsl is appended to the database.
// The contents of the Map should be equal to the _Map generated by the shopdraw machine.
	if (_ThisInst.handle()!="") { // if handle is not empty, then instance is database resident
		reportMessage("\nRecompose map from beam entity");
		Beam bm = _Beam0; // should always be valid for an E-type 
			
		// get a relevant tool, and store it inside the _Map->ToolList
		AnalysedTool tools[] = bm.analysedTools(_bOnDebug); // 1 means verbose reportMessage 
		AnalysedCut cuts[]= AnalysedCut().filterToolsOfToolType(tools);
		int nIndClosest = AnalysedCut().findClosest(cuts,_Pt0);	
		if (nIndClosest>=0)
		{
			// found a close tool. Compose _Map as if it was coming from the shopdraw machine
			Map mpToolList = AnalysedTool().convertToMap(cuts[nIndClosest]);
			_Map.setMap(_kAnalysedTools,mpToolList);
		}
		else 
		{
			reportMessage("\nNo tool found. Instance erased.");
			eraseInstance(); // no appropriate tool found
			return;
		}
	}
	
// get the tools from _Map
	AnalysedTool tools[] = AnalysedTool().convertFromSubMap(_Map,_kAnalysedTools,_bOnDebug); // 2 means verbose reportNotice 
	AnalysedCut cuts[]= AnalysedCut().filterToolsOfToolType(tools);
	int nIndClosest = AnalysedCut().findClosest(cuts,_Pt0);
	if (nIndClosest<0) {
		reportMessage("\n"+scriptName() +": No tool found. Instance erased.");
		eraseInstance(); // calling eraseInstance will notify that the tool is not consumed.
		return;
	}

// the tool	
	AnalysedCut cut = cuts[nIndClosest];	
	String sToolSubtype = cut.toolSubType();
		
// the manipulated genbeam
	GenBeam gb = cut.genBeam();
	Beam bm =(Beam)gb;

// extreme Points
	Point3d ptExtreme[0];

// declare the map of options
	Map mapOption;
	
// get multipage entity and it's possible data
	Map mapGenerator = _Map.getMap("Generation");
	Entity entCollector = mapGenerator.getEntity("entCollector");
	Map mapMultipage;
	if (entCollector.subMapKeys().find("mapMultipage")>=0) 
	{
		mapMultipage = entCollector.subMap("mapMultipage");
		if(mapMultipage.hasPoint3d("ptMin")) ptExtreme.append(mapMultipage.getPoint3d("ptMin"));
		if(mapMultipage.hasPoint3d("ptMax")) ptExtreme.append(mapMultipage.getPoint3d("ptMax"));
		
		// get options from the map of the multipage
		// settings might well be overwritten by the local execute string of this tsl
		mapOption = entCollector.subMap("Options");
	}	

// append user defined map settings to the options map
	for (int s = 0;s<sCustomMapSettings.length();s++)	
	{
		for (int i = 0;i<_Map.length();i++)
		{
			if (_Map.keyAt(i).makeUpper()==sCustomMapSettings[s].makeUpper() && _Map.hasString(i))
			{
				if (sCustomMapTypes.length() < s)
					;
				else if (sCustomMapTypes[s] == "int")
					mapOption.setInt(sCustomMapSettings[s],_Map.getString(i).atoi()); 	
				else if (sCustomMapTypes[s] == "double")
					mapOption.setDouble(sCustomMapSettings[s],_Map.getString(i).atof()); 						
				else
					mapOption.setString(sCustomMapSettings[s],_Map.getString(i)); 
			}
		}
	}	

// ints
	int nShowAllInOneLeft = mapOption.getInt("SHOWALLINONELEFT");	
	int nShowAllInOneRight = mapOption.getInt("SHOWALLINONERIGHT");
	//int nShowIndividualSide = mapOption.getInt("showIndividualSide");
	int nHideAnglesCut =mapOption.getInt("HIDEANGLESCUT");	
	int bJapaneseStyle = mapOption.getInt("japaneseStyle");
	int nJapaneseOrientation; // 0 = not defined, 1 = horizontal, 2 = vertical, 3 = rising
	int nSetPreferredViewXDim= mapOption.getInt("setPreferredViewXDim");	
	
	double dDimFromStartEndLength = mapOption.getDouble("DIMFROMSTARTENDLENGTH");


// flag if to be dimensioned in  two different dimlines
	int bDimFromStartEndLength;
	if(dDimFromStartEndLength > dEps && dDimFromStartEndLength <bm.solidLength())
		bDimFromStartEndLength = true;
		
// flag the japanese style, test dependencies
	if (bJapaneseStyle)
	{
		if (bm.vecX().isPerpendicularTo(_ZW))
			nJapaneseOrientation	= 1;		
		else if (bm.vecX().isParallelTo(_ZW))
			nJapaneseOrientation	= 2;
		else
			nJapaneseOrientation	= 3;
	}
// possible view directions in length
	Vector3d vArView[0];//	
	vArView.append(bm.vecY());	vArView[0].vis(_Pt0,0);
	vArView.append(bm.vecZ()); vArView[1].vis(_Pt0,1);
			
// declare view vecs
	Vector3d vxView, vyView, vzView;	
	
// the bm coordsys (aligned for hip and valley rafters for aligned projected views
	Vector3d vxBm,vyBm,vzBm;
	vxBm = bm.vecX();
	vyBm = bm.vecY();
	vzBm = bm.vecZ();	
	if (!vxBm.isPerpendicularTo(_ZW) && !vxBm.isPerpendicularTo(_XW) && vxBm.dotProduct(_ZW)<0 &&
	 (bm.type()==_kHipRafter || bm.type()==_kValleyRafter))
	{
		vxBm*=-1;
		vyBm*=-1;	
	}	
	
	//vxBm.vis(_Pt0,2);vyBm.vis(_Pt0,3);vzBm.vis(_Pt0,150);							
	Point3d ptCen = bm.ptCenSolid();
	Point3d ptOrg = cut.ptOrg();
	double dLenSolid = bm.solidLength();
		
// cut vectors	
	Vector3d vSide = cut.vecSide();
	Vector3d vNormal = cut.normal();
	vSide.vis(cut.ptOrg(),3);
	vNormal.vis(cut.ptOrg(),2);
	
//
	Vector3d vx,vy,vz;
	vx = bm.vecX();
	if (vNormal.dotProduct(vx)<0)
		vx*=-1;
	vx.vis(_Pt0,1);

// flag if cut near start or near end
	int nLocationNearStartEnd=-1;//-1=left, 1=right
	if (ptExtreme.length()>0 && abs(vxView.dotProduct(ptExtreme[0]-cut.ptOrg())) > .5*bm.solidLength() && 
		(!bm.vecX().isParallelTo(_ZW) && bJapaneseStyle))
		nLocationNearStartEnd=1;


// collect all cuts of the beam
	AnalysedTool toolsBm[] = bm.analysedTools(_bOnDebug); // 1 means verbose reportMessage 
	AnalysedCut cutOrdered[]= AnalysedCut().filterToolsOfToolType(toolsBm);
	AnalysedCut cutsOnThisSide[0];
	double dXLocation[0];
	int nQtyHips;
	for (int i=0; i<cutOrdered.length();i++)
	{
		// count the hips to limit the angular text offset
		if (cutOrdered[i].toolSubType() == _kACHip)
			nQtyHips++;	
		double dX = vx.dotProduct(cutOrdered[i].ptOrg()-bm.ptCen());
		if (dX>=0 && cutOrdered[i].toolSubType() != _kACPerpendicular)
			cutsOnThisSide.append(cutOrdered[i]);
	}
	
// order cuts on this side by x-location	
	for (int i=0; i<cutsOnThisSide.length();i++)
		for (int j=0; j<cutsOnThisSide.length()-1;j++)
			if (vx.dotProduct(cutsOnThisSide[j].ptOrg()-cutsOnThisSide[j+1].ptOrg())>0)
				cutsOnThisSide.swap(j,j+1);	

// varias	
	Point3d ptEdge, ptOtherEdge;
	double dAngle, dBevel;
	
// question cut
	cut.questionIsCompoundCut(vSide, ptEdge, ptOtherEdge, dAngle, dBevel);
		
	Point3d pt[0];
	pt.append(ptEdge);
	//pt.append(ptEdge + vxBm.dotProduct(ptOtherEdge-ptEdge)*bm.vecX());		
	pt.append(ptOtherEdge);


// points on plane	
	Point3d ptOnPlane[] = cut.bodyPointsInPlane();		

// bounds
	PlaneProfile ppBounds = bm.realBody().shadowProfile(Plane(cut.ptOrg(),vSide));

		
// subtype cases
	int bShowAngleY,bShowAngleZ;
	int bAddXLocation;
	int bAddYLocation;
	int bAddHip;
	if (cutsOnThisSide.length()>1)
		bAddXLocation=true;

	String sArType[] = {_kACHip, _kACPerpendicular, _kACSimpleAngled, _kACSimpleBeveled, _kACCompound};
	int nType = sArType.find(sToolSubtype);

	if (nType==0)//_kACHip
	{
		vx = bm.vecX();
		vxView = bm.vecY();	
		bAddHip=true;
		ppBounds = PlaneProfile (bm.realBody().shadowProfile(Plane(cut.ptOrg(),vx)));
		
		// for half logs make sure the envelope is only a half log envelope
		Vector3d vH,vW;
		vW =.5*bm.vecY()*bm.solidWidth();
		vH =.5*bm.vecZ()*bm.solidHeight();		
		LineSeg ls(ptCen-vW-vH,ptCen+vW+vH);
		PLine pl; pl.createRectangle(ls,bm.vecY(),bm.vecZ());
		ppBounds.intersectWith(PlaneProfile(pl));		
		ppBounds.vis(5);		
	}
	else if (nType==1)//kACPerpendicular)
	{
		vxView = vxBm;	
		bAddYLocation=true;				
		ppBounds = PlaneProfile (bm.realBody().shadowProfile(Plane(cut.ptOrg(),vSide)));
	}
	else if (nType==2)//kACSimpleAngled)
	{
		vxView =vxBm;	
		bShowAngleY=true;
		bAddYLocation=true;				
		ppBounds = PlaneProfile (bm.realBody().shadowProfile(Plane(cut.ptOrg(),vSide)));
	}
	else if (nType==3)//kACSimpleBeveled)
	{
		vxView =vxBm;	
		bShowAngleY=true;
		bAddYLocation=true;				
		ppBounds = PlaneProfile (bm.realBody().shadowProfile(Plane(cut.ptOrg(),vSide)));
	}	
	else if (nType==4)//kACCompound)
	{
		vxView = vxBm;
		bShowAngleY=true;
		bShowAngleZ=true;	
		ppBounds = PlaneProfile (bm.realBody().shadowProfile(Plane(cut.ptOrg(),vSide)));	
	}
	else
	{
		reportNotice("\n" + sToolSubtype + " not defined yet.");
		return;			
	}

// parent key and debug color
	String strParentKey = cut.normal() ; // unique key for the tool
	int nDebugColorCounter = 1;	

// set the tool default stereotype as stereotype  or uniform stereotype
	String sStereotype, sStereotypeDefault, sStereotypeUniform="Start";
	sStereotypeDefault = "*";
	sStereotype = sStereotypeDefault ;

// view angle
	// show the angle in Y
	if (bShowAngleY && pt.length()>1)
	{

		Vector3d  vzView =vSide;
		//vzView .vis(_Pt0,150);
		Vector3d vyCut = vNormal.crossProduct(vzView);		vyCut.normalize();	vyCut .vis(_Pt0,3);
		Point3d ptCen, pt1,pt2, ptTxt;

		// find extreme point
		ptOnPlane = Line(_Pt0,-vx).orderPoints(ptOnPlane);
		if (ptOnPlane.length()>0)
			ptCen = ptOnPlane[0];	
		if (vyCut.dotProduct(ptCen-bm.ptCen())<0)
			vyCut*=-1;
			
		// set minimal angular offset
		double dAngularOffset =.5*bm.dD(vyCut);
		if (dAngularOffset <U(100))
			dAngularOffset =U(100);
			
		pt1 = ptCen-vyCut*U(1);		//pt1.vis(1);
		pt2 = ptCen-vx*U(1) ;		//pt2.vis(2);
		ptTxt = (pt1+pt2)/2;
		Vector3d vTxt = ptTxt-ptCen;	vTxt.normalize();
		ptTxt = ptCen+vTxt*dAngularOffset;	

		// avoid angular dimensions outside of the beam
		if (ppBounds.pointInProfile(pt1)!=_kPointOutsideProfile && ppBounds.pointInProfile(pt2)!=_kPointOutsideProfile && !nHideAnglesCut)
		{
			DimRequestAngular dr(strParentKey , ptCen, pt1, pt2, ptTxt);
			dr.addAllowedView(vzView,TRUE);//vView
			addDimRequest(dr);	
		}
			
	}
	// show the angle in Z	
	if (bShowAngleZ && pt.length()>0 && !nHideAnglesCut)
	{
		Point3d ptCen, pt1,pt2, ptTxt;
		Vector3d  vzView = 	_ZW;//vNormal.crossProduct(vSide);						vzView.normalize();
		//vzView .vis(_Pt0,150);
		Vector3d vyCut = vNormal.crossProduct(-vzView);								vyCut .vis(_Pt0,3);
		Vector3d vxN = vx.crossProduct(vzView ).crossProduct(-vzView);		vxN.normalize();		//vxN .vis(_Pt0,20);
		
		// set minimal angular offset
		double dAngularOffset =.5*bm.dD(vyCut);
		if (dAngularOffset <U(100))
			dAngularOffset =U(100);
			
		ptCen = Line(pt[0],vyCut).intersect(Plane(bm.ptCen(),bm.vecD(vyCut)),.5*bm.dD(vyCut));
		
		// find extreme point
		ptOnPlane = Line(_Pt0,-vx).orderPoints(ptOnPlane);
		if (ptOnPlane.length()>0)
			ptCen = ptOnPlane[0];	
		//ptCen.vis(6);
		
		// test if point would be valid
		PlaneProfile ppShadow(bm.realBody().shadowProfile(Plane(cut.ptOrg(),vzView)));
		pt1 = ptCen - vyCut*U(1);			
		if (ppShadow.pointInProfile(pt1)== _kPointOutsideProfile)
			pt1 = ptCen + vyCut*U(1);		
		pt2 = ptCen-vxN*U(10);			pt2.vis(2);
		pt1.vis(1);
		ptTxt = (pt1+pt2)/2;
		Vector3d vTxt = ptTxt-ptCen;	vTxt.normalize();
		ptTxt = ptCen+vTxt*dAngularOffset;	 
		
		DimRequestAngular dr(strParentKey , ptCen, pt1, pt2, ptTxt);
		dr.addAllowedView(vzView,TRUE);//vView
		addDimRequest(dr);			
	}

// add hip dim
	if (bAddHip && !nHideAnglesCut && !vNormal.isParallelTo(bm.vecD(vNormal)))
	{	
		Point3d ptCen, pt1,pt2, ptTxt;			
		vzView = vx;										//vzView .vis(_Pt0,150);	
		vyView = vxView.crossProduct(-vzView);		vyView.vis(_Pt0,3);	
	
		Vector3d vyCut = vNormal.crossProduct(-vzView);
		Vector3d vySide = vNormal.crossProduct(vyView).crossProduct(-vyView);vySide .normalize();
		vySide .vis(_Pt0,3);

		// set minimal angular offset
		double dAngularOffset =bm.dD(vySide);
		if (dAngularOffset <U(100) && nQtyHips<2)
			dAngularOffset =U(100);
					
		// find extreme point
		ptOnPlane = Line(_Pt0,-vySide ).orderPoints(ptOnPlane);
		if (ptOnPlane.length()>0)
			ptCen = ptOnPlane[0];	

		// test vyCut
		
		Point3d ptTest = ptCen+vyCut*U(1);
		if(ppBounds.pointInProfile(ptTest)==_kPointOutsideProfile)
			vyCut*=-1;
			
	// find the hip line if the hip is formed by two cuts
		// find the adjacent cut which forms the hip
		AnalysedCut cutOther;
		for (int i=0;i<cutOrdered.length();i++)
		{
			// if two points of both cuts are identic we consider these cuts to be the hip cuts
			Point3d ptOnPlane2[] = cutOrdered[i].bodyPointsInPlane();
			int nCommonPoints;
			for (int j=0;j<ptOnPlane.length();j++)
			{
				for (int k=0;k<ptOnPlane2.length();k++)
					if (Vector3d(ptOnPlane[j]-ptOnPlane[j]).length()<dEps)
					{
						nCommonPoints++;
						if (nCommonPoints>1 && !cut.normal().isParallelTo(cutOrdered[i].normal())) 
						{
							cutOther = cutOrdered[i];
							break;
						}
					}
				if (nCommonPoints>1) break;	
			}
		}		
		
		// reassign ptCen if applicable
		Line lnHip;
		if (cutOther.bIsValid())
		{
			cutOther.normal().vis(cutOther.ptOrg(),4);
			cut.normal().vis(cutOther.ptOrg(),5);			
			lnHip = Plane(cutOther.ptOrg(),cutOther.normal()).intersect(Plane(cut.ptOrg(),cut.normal()));	
			ptCen = lnHip.ptOrg();
		}	
		vyCut .vis(ptCen,3);					
		ptCen.vis(6);
			
	
		pt1 = ptCen +vyCut*U(1);		pt1.vis(1);	
		pt2 = ptCen-vySide*U(1);			pt2.vis(2);
		ptTxt = (pt1+pt2)/2;
		Vector3d vTxt = ptTxt-ptCen;	vTxt.normalize();
		ptTxt = ptCen+vTxt*dAngularOffset;	

		DimRequestAngular dr(strParentKey , ptCen, pt1, pt2, ptTxt);
		dr.addAllowedView(vzView,TRUE);//vView
		addDimRequest(dr);	
		
		if (nDebugViews) reportNotice("\nHip dim added");
	}

// do dependent requests__________________________________________________________________________________________
	int nSwapSide=1;	
	
	for (int v = 0; v < vArView.length();v++)
	{	
		vzView = -vArView[v];
		vyView = vxView.crossProduct(-vzView);	
		
	// create two dimlines: one for each side if there is a cut
		Vector3d vyDefault = vyView;
		/*if (nShowIndividualSide >0) // removed with 2.3 since this does the same as preferredXDim
		{
			if (nDebugViews) reportNotice("\non individual side...");
			vyDefault = bm.vecD(vNormal);
			pt.append(ptExtreme);
		}	*/	
		if (nSetPreferredViewXDim==3)
			vyDefault = bm.vecD(vNormal);	
				
	//	declare an array of preferred vecs for x dim
		Vector3d vPrefViewXDim[] = {vyView,vzBm,-vzBm,vyDefault,vyBm,-vyBm};
		
	// preset the dim orientation		
		Vector3d  vxDimline, vyDimline, vzDimline;
		vxDimline = vxView;
		vyDimline = vPrefViewXDim[nSetPreferredViewXDim];	vyDimline.vis(ptOrg,3);
		vzDimline = vxDimline.crossProduct(vyDimline);		
		if (nDebugViews) reportNotice("\npreferred x dir = " + nSetPreferredViewXDim);
	// identify placement side of tool dim
		int nToolDimSide = -1;// -1 = left, 1 = right
		if (vyView.dotProduct(ptOrg-ptCen)<0)
			nToolDimSide *= -1;	
		
	//Stereotype composer
		if (nShowAllInOneLeft || nShowAllInOneRight && ptExtreme.length()>0)
		{	
			if (bDimFromStartEndLength && vNormal.dotProduct(vxBm)>0)
			{
				sStereotype = "LeftEnd";
			}
			else
			{			
				sStereotype = "LeftStart";	
			}	
		}
		if (nDebugViews) reportNotice("\n Stereotype = " + sStereotype);
		
		if (bShowAngleZ && vzView.isPerpendicularTo(vSide))
		{
			String sTxt;
			if (abs(cut.dAngle()) > 0.5)
			{				
				sTxt.formatUnit(cut.dAngle(),2,1);
				sTxt += "°";
			}
			if (abs(cut.dBevel()) > 0.5)
			{
				String s;
				s.formatUnit(cut.dBevel(),2,1);
				if (sTxt.length()> 0) sTxt += " / ";
				sTxt += s+ "°";
			}

			DimRequestText dr(strParentKey, sTxt, cut.ptOrg()+vSide*bm.dD(vSide), vx, vSide); 
			dr.addAllowedView(vzDimline,TRUE);//vView
			addDimRequest(dr);	
		}
		
		// find extreme point
		ptOnPlane = Line(_Pt0,-vx).orderPoints(ptOnPlane);	
		// multiple cuts on this side
		if (cutsOnThisSide.length()>1)
		{
			if (nDebugViews) reportNotice("\n Multiple cuts on this side...");
			// check if it is on bounding box
			if (ptOnPlane.length()>0 && ppBounds.pointInProfile(ptOnPlane[0])==_kPointInProfile)
			{
				if (nDebugViews) reportNotice("request send");
				DimRequestPoint dr(strParentKey, ptOnPlane[0], vxView, vyView);//
				dr.addAllowedView(vzDimline, false); 
				dr.setNodeTextCumm("<>");
				dr.setStereotype("*");			
				dr.vis(v);		
				addDimRequest(dr);
			}
		}
		// just one cut on this side
		else
		{	
			// version 2.2
			// !vyDimline.isParallelTo(vNormal) is excluding cuts with it's normal parallel to the dim perp	
			if (ptOnPlane.length()>1  && vzView.isPerpendicularTo(vSide) && !vyDimline.isParallelTo(vNormal))
			{
				if (nDebugViews) reportNotice("\n just one cut on this side..." + vNormal + "//" + vyDimline );
				if (abs(vxView.dotProduct(ptOnPlane[0]-ptOnPlane[1]))>dEps)
				{
					if (nDebugViews) reportNotice("linear request send");
					DimRequestLinear dr(strParentKey,ptOnPlane[0], ptOnPlane[1],-cut.vecSide());
					dr.addAllowedView(vzDimline, TRUE); 
					addDimRequest(dr);
				}
				
			}
		}// end only one cut
		
		// append y chain dimension only for the closest of multiple cuts
		if (bAddYLocation && vzView.isParallelTo(vSide))
		{
			Vector3d  vzDimline = vzView;
			int bAlsoReverseDirection=true;
			if (nJapaneseOrientation==3)
			{
				bAlsoReverseDirection=false;
				vzDimline *=-1;
			}	
			
			
			if (nDebugViews) reportNotice("\n append y chain dimension only for the closest of multiple cuts...");
			Point3d ptRef = ppBounds.closestPointTo(cut.ptOrg());
			Point3d ptDim[0];
			ptDim.append(bm.ptCen()-.5*vyView*bm.dD(vyView));
				for(int i=0;i<cutsOnThisSide.length();i++)
				{
					Point3d ptOnPlane[] = cutsOnThisSide[i].bodyPointsInPlane();
					ptOnPlane = Line(ptRef,vx).orderPoints(ptOnPlane);
					if (ptOnPlane.length()>1)
					{
						//ptDim.append(ptOnPlane[0]);
						ptDim.append(ptOnPlane[ptOnPlane.length()-1]);						
					}
				}
			ptDim.append(bm.ptCen()+.5*vyView*bm.dD(vyView));
			
			// project and order points to filter duplicates
			ptDim = Line(ptRef,vyView).projectPoints(ptDim);
			ptDim = Line(ptRef,vyView).orderPoints(ptDim);
			
			if (nDebugViews) reportNotice("send for point qty " + ptDim.length());
			// create dimline only for chains with more than 2 points as section dim is also done in section view
			if (ptDim.length()>2)
				for(int p=0;p<ptDim.length();p++)
				{
					if (nDebugViews) reportNotice("\nrequest send for point " + ptDim[p]);
					ptDim[p].vis(4);
					DimRequestPoint dr(strParentKey, ptDim[p], vyView, vx);//
					dr.addAllowedView(vzDimline, bAlsoReverseDirection); 
					dr.setNodeTextCumm("<>");
					dr.setStereotype("SectionLeft");			
					addDimRequest(dr);
				}
			
		}
		
		if (vzView.isParallelTo(vSide) && nType ==2)// type 2 =  _kACSimpleAngled
		{
			if (nDebugViews)
				reportNotice("\n case _kACSimpleAngled\n   stereotype: "+ sStereotype +"\n   vz is parallel to view z");
			
			//Vector3d  vzDimline = vzView;
			int bAlsoReverseDirection=true;
			if (nJapaneseOrientation==3)
			{
				bAlsoReverseDirection=false;
				vzDimline *=-1;
			}	

		

			for(int p=0;p<pt.length();p++)
			{
				ppBounds.vis(3);
				if (ppBounds.pointInProfile(pt[p])==_kPointOutsideProfile) continue;
				if (nDebugViews) reportNotice("request send ");
				DimRequestPoint dr(strParentKey, pt[p], vxView, vPrefViewXDim[nSetPreferredViewXDim]);//
				dr.addAllowedView(vzDimline, bAlsoReverseDirection); 
				dr.setNodeTextCumm("<>");
				dr.setStereotype(sStereotype);			
				dr.vis(1);		
				addDimRequest(dr);	
			}	
		}
		nSwapSide *=-1;

		
	}

// show type on debug
	if (_bOnDebug)
	{
		Display dp(1);
		dp.draw("No:" + nType + " " + sToolSubtype, _Pt0,_XW,_YW,0,0,_kDeviceX);	
		
	}












#End
#BeginThumbnail
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
!V3,/
`






#End
