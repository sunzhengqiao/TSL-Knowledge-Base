#Version 8
#BeginDescription
/// Version 3.6   th@hsbCAD.de   07.10.2009
/// reference point of x-dimline corrected

Uses the following Stereotypes: Drill, SectionLeft, LeftInfo
































#End
#Type E
#NumBeamsReq 1
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 3
#MinorVersion 6
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// Consumes any tool of type analyzed drill
/// creates several dimrequests in dependency of tool subtype and viewing direction
/// </summary>

/// <insert Lang=en>
/// This tsl is only executed by the shopdraw engine and to use it one
/// needs to append it to the ruleset of a multipage style.
/// </insert>

/// <command name="showIndividualAxisOffset" Lang=en>
/// If the user appends the command name to the execution key of the tsl in the ruleset, 
/// the tsl will create an individual dimline of the axis offset of the drill 
/// </command>

/// <command name="suppressDepth" Lang=en>
/// If the user appends the command name to the execution key of the tsl in the ruleset, 
/// the tsl will not show the depth of any drill. The depth of a drill will only be shown 
/// if the drill is not a through drill or if it is a composite drill (with sinkholes)
/// </command>

/// <command name="showDiameter" Lang=en>
/// NOTE: this option is depreciated since version 2.3 and has been replaced by the option ShowAxisView
/// </command>

/// <command name="showJapaneseSymbols" Lang=en>
/// If the user appends the command name to the execution key of the tsl in the ruleset, 
/// the tsl will show symbols for each drill 
/// </command>

/// <command name="LengthInView" Lang=en>
/// NOTE: this option is depreciated since version 2.3 and has been replaced by the option ShowAxisView

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

/// <command name="showOffsetDrill" Lang=en>
/// If the user appends an execution map in the format <command name>;<index> the offset display can be influenced by the value given:
/// 'showOffsetDrill;0' will display an individual tool offset in the corresponding view
/// 'showOffsetDrill;1' will show the tool offset near to it's origin relative to the beam edges in two separate dimlines
/// 'showOffsetDrill;2' will display all tool offsets in a dimline at the start or the end of the beam.
/// 'showOffsetDrill;3' will not display any tool offset
/// The stereotypes used for this option are called SectionLeft, SectionRight
/// </command>

/// <command name="showDiameter" Lang=en>
/// NOTE: this option has changed from an execution key to a map format (Version 2.3)
/// If the user appends an execution map in the format <command name>;<index> the offset display can be influenced by the value given:
/// 'showDiameter;0' will display the diameter as an appendix to the dimpoint
/// 'showDiameter;1' will display the radius as an appendix to the dimpoint
/// 'showDiameter;2' will display the diameter as text closed to the drill
/// 'showDiameter;3' will display the radius as text closed to the drill
/// 'showDiameter;4' will display the radius as angular dimension
/// 'showDiameter;5' will not display radius or diameter
/// The stereotypes used for this option are called SectionLeft
/// </command>

/// <command name="showDiameterIfEqual" Lang=en>
/// If the user appends an execution map in the format <command name>;<index> the tool display can be influenced by the value given:
/// 'showDiameterIfEqual;0' displays the radius or diameter only if the previous drill does not have the same properties
/// (drills are ordered along the beam axis)
/// 'showDiameterIfEqual;1' displays the radius or diameter of all drills
/// </command>

/// <command name="hideDrillInSection" Lang=en>
/// If the user appends an execution map in the format <command name>;<index> the display can be influenced by the value given:
/// 'hideDrillInSection;0' displays the tool in the appropriate sectional view
/// 'hideDrillInSection;1' does not display the tool in the appropriate sectional view
/// The stereotypes used for this option are called SectionLeft, SectionRight
/// </command>

/// <command name="ShowDrillAxisView" Lang=en>
/// If the user appends an execution map in the format <command name>;<index> the offset display can be influenced by the value given:
/// 'showAxisView;0' will display the tool location if the drill axis is parallel to the viewing direction
/// 'showAxisView;1' will display the tool location if the drill axis is perpendicular to the viewing direction
/// 'showAxisView;2' will display the tool location from side view of the beam
/// 'showAxisView;3' will display the tool location from top view of the beam
/// 'showAxisView;4' will not display the tool location
/// </command>

/// <command name="ShowInfoSeparate" Lang=en>
/// If the user appends an execution map in the format <command name>;<index> the offset display can be influenced by the value given:
/// 'showInfoSeparate;0' will display any appendix text in the regular dimline
/// 'showInfoSeparate;1' will display any appendix text in a separate dimline
/// The stereotypes used for this option are called LeftInfo, RightInfo
/// </command>

/// <remark Lang=en>
/// Uses the following Stereotypes: Drill, DrillY,, SectionLeft, SectionRight, , optional LeftStart, LeftEnd, RightStart, RightEnd
/// </remark>

/// <remark Lang=en>
/// Perpendicular Drills on one face will be collected and sorted. If two neighbouring drills
/// appear to have the same radius it will only be shown once
/// </remark>

/// History
/// Version 3.6   th@hsbCAD.de   07.10.2009
/// reference point of x-dimline corrected
/// Version 3.5   th@hsbCAD.de   25.09.2009
/// mirrored Dimlines for drilling depth corrected (again ;-))
/// Version 3.4   th@hsbCAD.de   24.09.2009
/// mirrored Dimlines for drilling depth corrected
/// Version 3.3   th@hsbCAD.de   14.08.2009
/// compass mode enhanced
/// options showAllInOneLeft and showInOneRight use the same stereotype. it is mandatory to set the viewing direction relative
/// to offset direction
/// Version 3.2   th@hsbCAD.de   25.07.2009
/// Dialog driven setup enhanced, only values different from default will shown as _Map entry
/// display of the zero at ref point suppressed
/// Version 3.1   th@hsbCAD.de   26.06.2009
/// Version 3.0   th@hsbCAD.de   25.06.2009
/// supports Dialog driven setup of options
/// requires hsbCAD 2009+ or higher
/// Version 2.9   th@hsbCAD.de   01.06.2009
/// bugfix
/// Version 2.8   th@hsbCAD.de   17.03.2009
/// - Option showDiameterIfEqual works in conjunction with the option showDiameter when it is set to display
/// the radius or diameter as an appendix to the dimpoint
/// - the option showDiameter with value 0 or 1 (display radius or diameter as an appendix to the dimpoint) now
/// integrates composite drills (collection of drill and sinkholes) and displays the different radius's separated by a /
/// - the option showJapanesSymbols is set to ON if entity is consumed by sd_BmJP. If the entity is consumed by sd_BmDE it is
/// turned off. In conjunction either tsl it can now be turned ON(1) or OFF (0). 
/// Version 2.7   th@hsbCAD.de   06.03.2009
/// various enhancements for japanese shopdrawings
/// Version 2.2   th@hsbCAD.de   20.01.2009
/// Enhancements on diameter and depth display
/// bugfix length

// basics and props
	U(1,"mm");
	double dEps = U(0.1);

// on insert
	if (_bOnInsert) {
		
		_Beam.append(getBeam());
		_Pt0 = getPoint("Select point near tool");
		return;
	}	
//end on insert________________________________________________________________________________

// NOTE: the CustomMapSettings and CustomMapTypes need to have the same length !
	String sCustomMapSettings[] = {"ShowAllInOneLeft","ShowAllInOneRight", "DimFromStartEndLength","show6Sides","showDrillAxisView",
		"showOffsetDrill","showDiameter", "showInfoSeparate","hideDrillInSection","showDiameterIfEqual",
		"showJapaneseSymbols", "suppressDepth"};//,"showIndividualAxisOffset"
	String sCustomMapTypes[] = {"int","int","double","int","int",
		"int","int","int","int","int","int","int"};

// on MapIO
	if (_bOnMapIO)
	{
		// define property
		String sArNY[] = {T("|No|"),T("|Yes|")};
		String sArDrillAxisView[] = {T("|parallel to view|"),T("|perpendicular to view|"), T("|Side View|"), T("|Top View|"), T("|do not display|")};
		String sArShowDiameter[] = {T("|Diameter|") + " " + T("|as appendix to the dimpoint|"),
										 T("|Radius|") + " " + T("|as appendix to the dimpoint|"), 
										 T("|Diameter|") + " " + T("|as text closed to the drill|"),
										 T("|Radius|") + " " + T("|as text closed to the drill|"),
										 T("|Radius|") + " " + T("|as angular dimension|"), 
										 T("|do not display|")};
		String sAllInOne = T("|As this option can be set on beam level (sd_BmXX)other tools might collect their dimpoints to the same dimline.|") + " " + 
			T("|The result will be dimline which consists of all tooling dimpoints on this side of the beam.|") + " " +
			T("|If the option 'DimFromStartEndLength' is enabled two dimlines on the referenced side will be created.|") + " " + 
			T("|The stereotype which is used for the second dimline is called 'EndLeft' or 'EndRight'|");


		PropString ShowAllInOneLeft(0,sArNY,T("|Show all in one dimline on left side|"));
		PropString ShowAllInOneRight(1,sArNY,T("|Show all in one dimline on right side|"));
		PropString DimFromStartEndLength(2,"",T("|Add dimensions from Start and End|"));		
		PropString show6Sides(3,sArNY,T("|Show 6 Sides|"));	
		PropString showDrillAxisView(4,sArDrillAxisView,T("|Show Drill Axis View|"));	
		PropString showOffsetDrill(5,sArNY,T("|Show Offset of Drill Axis|"));
		PropString showDiameter(6,sArShowDiameter,T("|Show Drill Diameter|"));	
		PropString showInfoSeparate(7,sArNY,T("|Show Info Separate|"));						
		PropString hideDrillInSection(8,sArNY,T("|Hide Drill in Section|"));	
		PropString showDiameterIfEqual(9,sArNY,T("|Show Diameter if equal|"));			
		PropString showJapaneseSymbols(10,sArNY,T("|Show Japanese Symbols|"));	
		//PropString showIndividualAxisOffset(11,sArNY,T("|Show individual Offset|"));	
		PropString suppressDepth(11,sArNY,T("|Suppress Depth Display|"));	
	
		ShowAllInOneLeft.setDescription(T("|The dimpoints will be collected to a stereotype called|") + " LeftStart" +" "+sAllInOne);
		ShowAllInOneRight.setDescription(T("|The dimpoints will be collected to a stereotype called|") + " RightStart"+" "+sAllInOne);
		DimFromStartEndLength.setDescription(T("|One dimline is collecting the dimension points from the start to the middle of the beam while the second 
		 dimline is collecting the points from the end of the beam to the middle|"));
		showJapaneseSymbols.setDescription(T("|Sets various japanese dimensioning and symbol settings.|"));
		show6Sides.setDescription(T("|The collection of the dimpoints will be done for each possible viewing direction|"));	
		
	// find value in _Map, if found, change the property values
		ShowAllInOneLeft.set(sArNY[_Map.getString(sCustomMapSettings[0]).atoi()]);		
		ShowAllInOneRight.set(sArNY[_Map.getString(sCustomMapSettings[1]).atoi()]);			
		DimFromStartEndLength.set(_Map.getString(sCustomMapSettings[2]).atof());	
		show6Sides.set(sArNY[_Map.getString(sCustomMapSettings[3]).atoi()]);		
		showDrillAxisView.set(sArDrillAxisView[_Map.getString(sCustomMapSettings[4]).atoi()]);					
		showOffsetDrill.set(sArNY[_Map.getString(sCustomMapSettings[5]).atoi()]);		
		showDiameter.set(sArShowDiameter[_Map.getString(sCustomMapSettings[6]).atoi()]);	
		showInfoSeparate.set(sArNY[_Map.getString(sCustomMapSettings[7]).atoi()]);				
		hideDrillInSection.set(sArNY[_Map.getString(sCustomMapSettings[8]).atoi()]);	
		showDiameterIfEqual.set(sArNY[_Map.getString(sCustomMapSettings[9]).atoi()]);	
		showJapaneseSymbols.set(sArNY[_Map.getString(sCustomMapSettings[10]).atoi()]);	
		//showIndividualAxisOffset.set(sArNY[_Map.getString(sCustomMapSettings[11]).atoi()]);	
		suppressDepth.set(sArNY[_Map.getString(sCustomMapSettings[11]).atoi()]);	

		
		// show the dialog to the user
		showDialog("---"); // use "---" such that the set values are used, and not the last dialog values
		_Map = Map();
		
		// interpret the properties, and fill _Map. don't fill default options to keep ability to control settings by global options 		
		int nInd;

		nInd = sArNY.find(ShowAllInOneLeft,0); 				if (nInd>0)  _Map.setString(sCustomMapSettings[0],nInd);
		nInd = sArNY.find(ShowAllInOneRight,0); 				if (nInd>0)  _Map.setString(sCustomMapSettings[1],nInd);
		if (DimFromStartEndLength.atof()>0)					  			_Map.setString(sCustomMapSettings[2],DimFromStartEndLength);	
		nInd = sArNY.find(show6Sides,0); 						if (nInd>0)  _Map.setString(sCustomMapSettings[3],nInd);	
		nInd = sArDrillAxisView.find(showDrillAxisView,0);if (nInd>0)  _Map.setString(sCustomMapSettings[4],nInd);
		nInd = sArNY.find(showOffsetDrill,0);				if (nInd>0)  _Map.setString(sCustomMapSettings[5],nInd);
		nInd = sArShowDiameter.find(showDiameter,0);		if (nInd>0)  _Map.setString(sCustomMapSettings[6],nInd);
		nInd = sArNY.find(showInfoSeparate,0);				if (nInd>0)  _Map.setString(sCustomMapSettings[7],nInd);
		nInd = sArNY.find(hideDrillInSection,0);				if (nInd>0)  _Map.setString(sCustomMapSettings[8],nInd);
		nInd = sArNY.find(showDiameterIfEqual,0);			if (nInd>0)  _Map.setString(sCustomMapSettings[9],nInd);
		nInd = sArNY.find(showJapaneseSymbols,0);			if (nInd>0)  _Map.setString(sCustomMapSettings[10],nInd);
		//nInd = sArNY.find(showIndividualAxisOffset,0);		if (nInd>0)  _Map.setString(sCustomMapSettings[11],nInd);
		nInd = sArNY.find(suppressDepth,0);					if (nInd>0)  _Map.setString(sCustomMapSettings[11],nInd);
								
		return;
	}


// Compose a _Map from the beam, in case the Tsl is appended to the database.
// The contents of the Map should be equal to the _Map generated by the shopdraw machine.
	if (_ThisInst.handle()!="") { // if handle is not empty, then instance is database resident
		reportMessage("\nRecompose map from beam entity");
		Beam bm = _Beam0; // should always be valid for an E-type 
			
		// get a relevant tool, and store it inside the _Map->ToolList
		AnalysedTool tools[] = bm.analysedTools(_bOnDebug); // 1 means verbose reportMessage 
		AnalysedDrill drills[]= AnalysedDrill().filterToolsOfToolType(tools);
		int nIndClosest = AnalysedDrill().findClosest(drills,_Pt0);	
		if (nIndClosest>=0)
		{
			// found a close tool. Compose _Map as if it was coming from the shopdraw machine
			Map mpToolList = AnalysedTool().convertToMap(drills[nIndClosest]);
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
	AnalysedDrill drills[]= AnalysedDrill().filterToolsOfToolType(tools);
	int nIndClosest = AnalysedDrill().findClosest(drills,_Pt0);
	if (nIndClosest<0) {
		reportMessage("\n"+scriptName() +": No tool found. Instance erased.");
		eraseInstance(); // calling eraseInstance will notify that the tool is not consumed.
		return;
	}

// the tool	
	AnalysedDrill drill = drills[nIndClosest];	
	String sToolSubtype = drill.toolSubType();
		
// the manipulated genbeam
	GenBeam gb = drill.genBeam();
	Beam bm =(Beam)gb;
	Point3d ptOrg = drill.ptStart();	
	
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
	vxBm.vis(_Pt0,2);vyBm.vis(_Pt0,3);vzBm.vis(_Pt0,150);							
	Point3d ptCen = bm.ptCenSolid();
	double dLenSolid = bm.solidLength();


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

// flag the japanese style, test dependencies
	int bJapaneseStyle = mapOption.getInt("japaneseStyle");
	int nJapaneseOrientation; // 0 = not defined, 1 = horizontal, 2 = vertical, 3 = rising
	if (bJapaneseStyle)
	{
		if (bm.vecX().isPerpendicularTo(_ZW))
			nJapaneseOrientation	= 1;		
		else if (bm.vecX().isParallelTo(_ZW))
			nJapaneseOrientation	= 2;
		else
			nJapaneseOrientation	= 3;		
		mapOption.setInt("showJapaneseSymbols",true);	
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
					mapOption.setString(sCustomMapSettings[s],_Map.getString(i).makeUpper()); 
			}
		}
	}			
	
	
// ints + doubles
	int nShowAllInOneLeft = mapOption.getInt("showAllInOneLeft");	
	int nShowAllInOneRight = mapOption.getInt("showAllInOneRight");
	int nShowDiameter = mapOption.getInt("showDiamter");	
	int nShowDrillAxisView = mapOption.getInt("showDrillAxisView");	
	int nShow6Sides = mapOption.getInt("show6Sides");
	int nShowOffsetDrill = mapOption.getInt("showOffsetDrill");	
	int nSuppressDepth = mapOption.getInt("suppressDepth");	
	int nShowInfoSeparate =mapOption.getInt("showInfoSeparate");
	int nShowJapaneseSymbols= mapOption.getInt("showJapaneseSymbols");
	int nHideDrillInSection= mapOption.getInt("hideDrillInSection");
	int nShowDiameterIfEqual= mapOption.getInt("showDiameterIfEqual");		
	
	double dDimFromStartEndLength = mapOption.getDouble("DIMFROMSTARTENDLENGTH");	

// report all options set
	int nDebug = false;
	if (nDebug)
		for (int i=0;i<mapOption.length();i++)
		{
			if (mapOption.hasDouble(i)) reportNotice("\n"+scriptName() + ": "+ mapOption.keyAt(i) +": " + mapOption.getDouble(i));
			else if (mapOption.hasInt(i)) reportNotice("\n"+scriptName() + ": "+mapOption.keyAt(i) +": " + mapOption.getInt(i));
			else if (mapOption.hasString(i)) reportNotice("\n"+scriptName() + ": "+mapOption.keyAt(i) +": " + mapOption.getString(i));		
		}

				
// declare vecs
	Vector3d vx,vy,vz;
	vx = bm.vecX();
	if (vx.isParallelTo(drill.vecFree()))
		vz=drill.vecFree().crossProduct(bm.vecY());
	else
		vz = drill.vecFree().crossProduct(vx);
	//vz.vis(_Pt0,150);


drill.vecFree().vis(drill.ptStart(),1);	
	
// subtype cases
	int bShowLength;
	int bShowAxisOffset;
	int bShowRadius;	
	int bShowDepth;
	int bShowDepthTxt;
	int bIsParallelX;	
	
	String sArType[] = {_kADPerpendicular, _kADRotated, _kADTilted, _kADHead, _kAD5Axis};
	int nType = sArType.find(sToolSubtype);	
	if (nType ==0)//_kADPerpendicular)
	{	
		bShowRadius = true;	
		bShowDepth = true;			
		bShowLength=true;
		bShowAxisOffset = true;		
		if (drill.vecFree().isParallelTo(vx))
			bIsParallelX=true;		
	}
	else if (nType ==1)//_kADRotated)
	{	
		bShowRadius=true;	
		bShowLength=true;
		bShowAxisOffset = true;	
		bShowDepthTxt= true;		
	}
	else if (nType ==2)//_kADTilted)
	{	
		bShowRadius=true;	
		bShowLength=true;
		bShowAxisOffset = true;	
		bShowDepthTxt= true;					
	}
	else if (nType ==3)//_kADHead)
	{	
		bShowRadius=true;	
		bShowLength=true;
		bShowAxisOffset = true;	
		bShowDepthTxt= true;	
		bIsParallelX=true;					
	}
	else if (nType ==4)//_kAD5Axis)
	{	
		bShowRadius=true;	
		bShowLength=true;	
		bShowAxisOffset = true;	
		bShowDepthTxt= true;		
	}



	// overwrite showDepth
	if (mapOption.getInt("suppressDepth")>0)
		bShowDepth = false;
	if (mapOption.getInt(sCustomMapSettings[5])==3)// no section dimension is required
		bShowAxisOffset = false;	
	if (nShowDrillAxisView==4)							// no x dimension is required
		bShowLength= false;	
	if (nSuppressDepth>0)								// suppress the depth
		bShowDepth= false;	
	//if (nHideDrillInSection)							// suppress in section
	//	bIsParallelX= false;	



// parent key and debug color
	String strParentKey = String(drill.ptStart()) + sToolSubtype ; // unique key for the tool
	int nDebugColorCounter = 1;	
	
// add the extrems if not taken from the mapMultipage
	if(ptExtreme.length()<2)
	{	
		ptExtreme.setLength(0);
		ptExtreme.append(ptCen-bm.vecX()*.5*bm.solidLength());
		ptExtreme.append(ptCen+bm.vecX()*.5*bm.solidLength());
	}
	
// get all drills, order and flag them
	AnalysedTool toolsBm[] = bm.analysedTools(_bOnDebug); // 1 means verbose reportMessage 
	AnalysedDrill adOrdered[]= AnalysedDrill().filterToolsOfToolType(toolsBm,_kADPerpendicular);
	AnalysedDrill adSameSide[0], adSameSideOthers[0];
	double dXLocation[0];
	int bAddThisRadius[0];
	if (nType ==0)
	{
		for (int i=0; i<adOrdered.length();i++)
			dXLocation.append(vx.dotProduct(bm.ptCen()-adOrdered[i].ptStart()));
		// order by diameter		
		for (int i=0; i<adOrdered.length();i++)
			for (int j=0; j<adOrdered.length()-1;j++)
			{
				if (adOrdered[j].dDiameter()>adOrdered[j+1].dDiameter())
				{
					adOrdered.swap(j,j+1);
					dXLocation.swap(j,j+1);				
				}	
			}	
		// order by x-position		
		for (int i=0; i<adOrdered.length();i++)
			for (int j=0; j<adOrdered.length()-1;j++)
			{
				if (dXLocation[j]>dXLocation[j+1])
				{
					adOrdered.swap(j,j+1);
					dXLocation.swap(j,j+1);				
				}	
			}
		// flag if it is a multiple to previous at x-location
		int nColumn[0];
		int nColCounter;
		for (int i=0; i<adOrdered.length();i++)
		{
			
			if (i==0)
				;			
			else if (abs(dXLocation[i]-dXLocation[i-1])>dEps)	
				nColCounter++;
			else if(i==adOrdered.length()-1 && abs(dXLocation[i]-dXLocation[i-1])>dEps)
				nColCounter++;
			nColumn.append(nColCounter);		
		}		
		// flag radius to be shown if next position has different radius
		for (int i=0; i<adOrdered.length();i++)
		{
			if (i==0)
				bAddThisRadius.append(true);
			else if (nColumn[i]!=nColumn[i-1])
				if(i<adOrdered.length()-1)
				{
					if(adOrdered[i].dDiameter() == adOrdered[i-1].dDiameter() &&
						adOrdered[i].dDiameter() == adOrdered[i+1].dDiameter())
						bAddThisRadius.append(false);
					else
						bAddThisRadius.append(true);
				}
				else
				{
					if(adOrdered[i].dDiameter() == adOrdered[i-1].dDiameter())
						bAddThisRadius.append(false);
					else
						bAddThisRadius.append(true);					
				}
			else if (nColumn[i]==nColumn[i-1] && adOrdered[i].dDiameter() != adOrdered[i-1].dDiameter())	
				bAddThisRadius.append(true);		
			else if(adOrdered[i].dDiameter() != adOrdered[i-1].dDiameter())	
				bAddThisRadius.append(true);
			else
				bAddThisRadius.append(false);
			adOrdered[i].ptStart().vis(bAddThisRadius[bAddThisRadius.length()-1]);								
		}	
		// collect all orderd drills on same side
		for (int i=0; i<adOrdered.length();i++)
			if (adOrdered[i].vecSide().isCodirectionalTo(drill.vecSide()))
				adSameSide.append(adOrdered[i]);
				
		// find this drill in the ordered drills
		for (int i=0; i<adSameSide.length();i++)
			if (abs(vx.dotProduct(drill.ptStart()-adSameSide[i].ptStart()))<dEps &&
				abs(vz.dotProduct(drill.ptStart()-adSameSide[i].ptStart()))<dEps &&	
				drill.dDiameter()==adSameSide[i].dDiameter() &&
				drill.dDepth()==adSameSide[i].dDepth())
				{
					bShowRadius  = bAddThisRadius[i];
					break;	
				}
			else
				adSameSideOthers.append(adSameSide[i]);
	}
	
// override show radius in case all diameters are requested to be visualized
	if (nShowDiameterIfEqual) bShowRadius  =true;	
	
// test for sinkholes and collect in compositeDrill
	AnalysedDrill adComposite[0];
	double dMaxDepth;
	// collect the composition
	for (int i=0; i<adOrdered.length();i++)
	{
		if (abs(vx.dotProduct(drill.ptStart()-adOrdered[i].ptStart()))<dEps &&
			 abs(vy.dotProduct(drill.ptStart()-adOrdered[i].ptStart()))<dEps && 
			 drill.vecZ().isParallelTo(adOrdered[i].vecZ()))
		{
			// filter this drill
			if(drill.dDiameter()!=adOrdered[i].dDiameter() && 
				drill.dDepth()!=adOrdered[i].dDepth())
					adComposite.append(adOrdered[i]);
			if (adOrdered[i].dDepth()>dMaxDepth)	
				dMaxDepth=adOrdered[i].dDepth();
		}
	}

// test if this drill is the main one of a composite	
	int bIsMain;
	if (dMaxDepth == drill.dDepth() || drill.bThrough())
		bIsMain=true;
	if (!bIsMain)return;
		
// dimine vectors
	Vector3d  vDimLineDir,vPerpDimLineDir;
		
// possible view directions in length
	Vector3d vArView[] = {-vyBm, vzBm};//
	//String sStereotypes[]={"*","*"};
	int bAlsoReverseDirection = true;

// CoordSys for sectional display
	CoordSys csSection[0];
	csSection.append(CoordSys(bm.ptCen(),vxBm.crossProduct(vzBm),vzBm,-vxBm));

// show 6 sides	
	if (nShow6Sides>0)
	{
		vArView.append(-vyBm);
		vArView.append(vzBm);	
		csSection.append(CoordSys(bm.ptCen(),-vxBm.crossProduct(vzBm),vzBm,vxBm));
		bAlsoReverseDirection = false;	
	}


// show WCS related = compass
	if (mapOption.getInt("setCompassViews")>0 && vxBm.isParallelTo(_ZW))
	{
		vArView.setLength(4);
		Vector3d  vAr[] = {_XW,_YW,-_XW,-_YW};
		for (int i=0;i<vArView.length();i++)
			if (i<vAr.length())
				vArView[i] = bm.vecD(vAr[i]);
	}	

	Vector3d vxView,vyView,vzView;
	vxView = vxBm;
	
// show radius for drills at head of beam	always show the radius on x-parallel drills
	if (bIsParallelX && !nHideDrillInSection)
	{
		Vector3d vxRad = bm.vecZ()-bm.vecY();	vxRad.normalize();
		DimRequestRadial drRad(strParentKey,drill.ptStart(),drill.ptStart()+vxRad*drill.dDiameter()/2 );
		drRad.addAllowedView(vxView, bAlsoReverseDirection);
		addDimRequest(drRad);
	}	

// set the tool default stereotype as stereotype, declare uniform stereotype
	String sStereotype, sStereotypeUniform="Start";
	sStereotype = "Drill";
	
	// japanese option
	// if the length exceeds the length given in the option SHOWREVERSEDFROMLENGTH 2 separate dimlines 
	// starting from start and end will be created
	// the stereotypes which are used are formed with <Side><Direction> Side=Left/Right, Direction=Start/End
	int nLocationNearStartEnd=-1;//-1=left, 1=right
 
	if (ptExtreme.length()>0 && abs(vxView.dotProduct(ptExtreme[0]-ptOrg)) > .5*bm.solidLength() && 
		(!bm.vecX().isParallelTo(_ZW) && bJapaneseStyle))
		nLocationNearStartEnd=1;

	
	int bDimFromStartEndLength;
	if(dDimFromStartEndLength > dEps && dDimFromStartEndLength <bm.solidLength())
		bDimFromStartEndLength = true;
	
	if(bDimFromStartEndLength  && ptExtreme.length()>0 && nShowAllInOneLeft)
	{
		if (nLocationNearStartEnd==1 && dDimFromStartEndLength>0)
			sStereotypeUniform="End";				
		else
			sStereotypeUniform="Start";		
	}

	//reportNotice("\n" + scriptName() + " Uniform Stereotype: " + sStereotypeUniform);

// declare vectors to determine viewing direction of specific dimlines
	// 'showAxisView;0' will display the tool location if the drill axis is parallel to the viewing direction
	// 'showAxisView;1' will display the tool location if the drill axis is perpendicular to the viewing direction
	// 'showAxisView;2' will display the tool location from side view of the beam
	// 'showAxisView;3' will display the tool location from top view of the beam
	// 'showAxisView;4' will not display the tool location

	Vector3d vzViewDrillAxis = bm.vecD(drill.vecFree());
	if(nShowDrillAxisView==1)			vzViewDrillAxis = vxView.crossProduct(bm.vecD(drill.vecFree()));
	else if(nShowDrillAxisView==2)	vzViewDrillAxis = vyBm;
	else if(nShowDrillAxisView==3)	vzViewDrillAxis = vzBm;

	
	String sStereotypeOffset = "SectionLeft";
// depreciated with aligned with view
//	if (nLocationNearStartEnd==1 && nJapaneseOrientation!=2)
//		sStereotypeOffset = "SectionRight";
	
// loop view directions
	int nSwapSide=1;
	for (int v=0; v<vArView.length(); v++) 
	{
		Vector3d vzView = vArView[v];
		Vector3d vyView = vxView.crossProduct(-vzView);
		
		//default Vectors for the dimrequest
		Vector3d  vxDimline,vyDimline, vzDimline;
		vxDimline=vxView;
		vyDimline=vyView;			
		vzDimline=vzView;
			
		// override the default stereotype if all dimensions are supposed to show in one dimline
		// RIGHT
		if (bm.quader().vecD(drill.vecSide()).isCodirectionalTo(bm.vecD(vyDimline)) && bDimFromStartEndLength)
		{
			if (nShowAllInOneRight)
			{
				sStereotype =	"Left"+sStereotypeUniform;
				//sStereotype =	"Right"+sStereotypeUniform;
				vyDimline*=-1;				
			}
		}
		// LEFT	
		else
		{
			if(nShowAllInOneLeft)
			{
				sStereotype =	"Left"+sStereotypeUniform;
			}
		}
	
		// show japanese symbols
		if (nShowJapaneseSymbols>0 && !drill.vecFree().isParallelTo(vzView))
		{
			Vector3d  vxSym = drill.vecFree();
			Vector3d  vySym = drill.vecFree().crossProduct(-vzView);
			Plane pnRef2; // a ref plane of a potential secondary beam
			int bMetalConnection, bMaleBeam, bCompositeInOther, nEndCaps;//nEndCaps: 1 = Arrow, 2 = Angle, 3 = Circle, 4 = angle+circle
			// test if drill comes from tsl / metalpart
			ToolEnt tent = drill.toolEnt();
			TslInst tsl = (TslInst)tent;
		// metal connection
			if (tsl.bIsValid() && tsl.realBody().volume()>pow(dEps,3))
			{
				bMetalConnection=true;
				if (vxSym.dotProduct(-tsl.coordSys().vecX())<0)
					vxSym*=-1;
				vySym = drill.vecFree().crossProduct(-vzView);
				vySym.normalize();
				
				// test sink on this side
				//for (int i=0; i<adComposite.length();i++)
				//	if (adComposite[i].vecFree().isCodirectionalTo(vxSym))
				//		nEndCaps=2;
		
				// test the offset
				double dOffset = vySym.dotProduct(drill.ptStart()-tsl.coordSys().ptOrg());
				if(abs(dOffset)>dEps)
					nEndCaps= 2;
				else 
					nEndCaps= 1;		

				if(dOffset>0)
					vySym*=-1;

				// check if this beam is the male beam
				Beam bmTsl[] = tsl.beam();
				if (bmTsl.length()>1 && bmTsl[0].vecX().isParallelTo(vxBm))
				{
					bMaleBeam=true;
				// query all drills in a potential secondary beam
					AnalysedDrill adSec[0];
					AnalysedTool toolsBm[] = bmTsl[1].analysedTools(_bOnDebug); // 1 means verbose reportMessage 
					AnalysedDrill adBmTsl[]= AnalysedDrill().filterToolsOfToolType(toolsBm);
					for (int i=0; i<adBmTsl.length();i++)
					{
						// if the drill is dependent from the same toolentity it is a drill which is added by the tsl
						ToolEnt tentSec = adBmTsl[i].toolEnt();
						if (tent == tentSec)
							adSec.append(adBmTsl[i]);
					}
				// check if we find a composite drill in the list of potential drills
					Vector3d vxDSec = bmTsl[1].vecD(bmTsl[0].vecX());
					Vector3d vyDSec = vxDSec.crossProduct(bmTsl[1].vecX());
					Vector3d vzDSec = vxDSec.crossProduct(vyDSec);
					int bIsComposite[adSec.length()];
					for (int i=0; i<adSec.length();i++)
						for (int j=0; j<adSec.length();j++)
						{
							if (i==j) continue;
							if (abs(vyDSec .dotProduct(adSec[j].ptStart()-adSec[i].ptStart()))>dEps) continue;
							if (abs(vzDSec .dotProduct(adSec[j].ptStart()-adSec[i].ptStart()))>dEps) continue;
							bIsComposite[i] = true;
						}
				// if one of the flags is true we consider it to be a combination. this will do endcaps = 4 if endcaps was set to 2 before
					for (int i=0; i<bIsComposite.length();i++)
						if (bIsComposite[i])// && nEndCaps==2)
						{
							nEndCaps=4;
							pnRef2 = Plane(bmTsl[1].ptCen(), vxDSec);
							break;
						}
				}	
			}
		// tool connection
			else
			{
				// get connected beams
				Beam bmTent[] = tent.beam();
				for (int b=0; b<bmTent.length();b++)
				{
				// don't do anything for this beam
					if (bmTent[b] == bm) continue;

				//get drills from connected beam
					AnalysedDrill adCompositeTent[0],adTent[0];
					AnalysedTool toolsBmTent[] = bmTent[b].analysedTools(_bOnDebug); 
					adTent = AnalysedDrill().filterToolsOfToolType(toolsBmTent);
					
				// collect a possible composition
					for (int i=0; i<adTent.length();i++) 
					{
						if (!adTent[i].vecFree().isParallelTo(drill.vecFree())) continue;
						if (abs(vx.dotProduct(drill.ptStart()-adTent[i].ptStart()))<dEps) continue;
						if (abs(vy.dotProduct(drill.ptStart()-adTent[i].ptStart()))<dEps) continue;
					// if we come to this point it is part of a composite
						adCompositeTent.append(adTent[i]);
					}// next i	
					if (adCompositeTent.length()>1)
						bCompositeInOther=true;	
					else
					{
						if (vxSym.dotProduct(bmTent[b].ptCen()-bm.ptCen())<0)
						{
							vxSym*=-1;
							vySym*=-1;	
						}
						nEndCaps= 1;	
					}		
				}// next b
			}
			vxSym.vis(_Pt0,20);
			if (!bMaleBeam || nEndCaps==4)
			{
				
				double d1 = bm.dD(drill.vecFree())+U(50);
				double d2 = U(20);
				Point3d ptRef;
				if (!drill.vecFree().isParallelTo(bm.vecX()))
					ptRef = Line(drill.ptStart(),drill.vecFree()).intersect(Plane(bm.ptCen(),bm.vecD(drill.vecFree())),0);
	
				//PLines
				PLine pl[0];
				for (int i=0; i<adComposite.length();i++)
				{
					PLine plCirc(vzView);
					plCirc.createCircle(ptRef+ adComposite[i].vecFree()*(d1+d2),vzView,d2);
					pl.append(plCirc);
				}
				
				// the main pline
				pl.append(PLine(ptRef- vxSym*d1, ptRef+ vxSym*d1));	
				if (nEndCaps==1)// arrow
				{
					pl[pl.length()-1].addVertex(ptRef+vxSym*(d1-2*d2)+vySym*d2);	
					pl[pl.length()-1].addVertex(ptRef+vxSym*d1);	
					pl[pl.length()-1].addVertex(ptRef+vxSym*(d1-2*d2)-vySym*d2);											
				}
				else if (nEndCaps==2) // offset
					pl[pl.length()-1].addVertex(ptRef+vxSym*d1+vySym*d2);	
				else if (nEndCaps==4 && !vySym.isPerpendicularTo(pnRef2.normal())) // offset
				{
					Point3d ptRef2 = Line(ptRef+vxSym*d1,vySym).intersect(pnRef2,0);
					pl[pl.length()-1].addVertex(ptRef2);	
					PLine plCirc(vzView);
					plCirc.createCircle(ptRef2+vySym*d2,vzView,d2);
					pl.append(plCirc);
					
				}					
				for (int i=0; i<pl.length();i++)
				{
					pl[i].vis(1);
					DimRequestPLine dr(strParentKey, pl[i], 16);
					dr.addAllowedView(vzView, bAlsoReverseDirection );  
					addDimRequest(dr);
				}
			}
			
		}
	
		
		// append location to YZ dim in section if head like drill
		if (bIsParallelX)	// hide section if toggled
		{
			Point3d ptDim[0];
			ptDim.append(bm.ptCen()-.5*(bm.dW()*bm.vecY()+bm.dH()*bm.vecZ()));
			ptDim.append(bm.ptCen()+.5*(bm.dW()*bm.vecY()+bm.dH()*bm.vecZ()));
			ptDim.append(drill.ptStart());
			for (int p = 0; p < ptDim.length();p++)
			{
				// vecs need to be checked: th 14.08.2009
				DimRequestPoint dr(strParentKey , ptDim[p], vyView, -vzView);
				dr.setStereotype("SectionLeft");//
				//dr.setNodeTextCumm("<>" + ": " + sTxt[p]);	
				dr.addAllowedView(vxView, bAlsoReverseDirection ); //vecView
				dr.vis(6);//nDebugColorCounter++); // visualize for debugging 
				addDimRequest(dr); // append to shop draw engine collector	
			}
		}

		// show X-Position
		if (bShowLength && vzView.isParallelTo(vzViewDrillAxis) )  // Codirectional if you want to dimension on its side	
		{
			vxView.vis((drill.ptStartExtreme()+drill.ptEndExtreme())/2,1);
			vzView.vis((drill.ptStartExtreme()+drill.ptEndExtreme())/2,v);
			vyDimline.vis((drill.ptStartExtreme()+drill.ptEndExtreme())/2,v);
			
			Point3d ptDim[0];
			if (ptExtreme.length()<1)
				;
			else if (nLocationNearStartEnd==-1 && bDimFromStartEndLength)// near start
				ptDim.append(ptExtreme[0]);				
			else if (nLocationNearStartEnd==1 && bDimFromStartEndLength) // near end
				ptDim.append(ptExtreme[1]);	
			else
				ptDim.append(ptExtreme);	
			
			
			ptDim.append(drill.ptStartExtreme());

			for (int p = 0; p < ptDim.length();p++)
			{
				DimRequestPoint dr(strParentKey , ptDim[p], vxDimline, vyDimline);
				dr.setStereotype(sStereotype);//
				if (p==0)
				{
					// the '0' of the dimline should not be shown
					dr.setNodeTextCumm("");	
					dr.setIsChainDimReferencePoint(true);
				}
				else
					dr.setNodeTextCumm("<>");	
												
				String sTxtPostFix;
				
				// append postfixes
				if (p == ptDim.length()-1)
				{
					// append the diameter to the postfix
					if (nShowDiameter==0)
						sTxtPostFix = " " + T("|Ø|") + drill.dDiameter();
					// append the diameter to the postfix
					else if (nShowDiameter==1)
						sTxtPostFix = " " + T("|Radius Abbreviation|") + drill.dDiameter()/2;	
					
					// the postfix could be dependent from a potential composite drill
					for (int i=0; i<adComposite.length();i++)
					{
						//display the diameter as an appendix to the dimpoint
						if (nShowDiameter==0)
							sTxtPostFix = sTxtPostFix +"/"+adComposite[i].dDiameter();
						//display the radius as an appendix to the dimpoint	
						else if (nShowDiameter==1)
							sTxtPostFix = sTxtPostFix +"/"+adComposite[i].dDiameter()/2;					
					}

					// append bevel and angle					
					if (abs(drill.dBevel())> dEps && abs(drill.dBevel())<90)
					{
						sTxtPostFix =sTxtPostFix + " <" + String().formatUnit(drill.dBevel(),2,0)+ "°";
						if (nType==4)
							sTxtPostFix = sTxtPostFix+"/" + String().formatUnit(drill.dAngle(),2,0)+ "°";
					}					
				}
				if (nShowInfoSeparate)
				{
					//dr.setNodeTextCumm("<>");
					// draw an extra info	
					if (sTxtPostFix.length()>0 && bShowRadius)
					{
						//reportNotice("\n"+p+"psotfix:"+ sTxtPostFix+".");
						DimRequestPoint drInfo(strParentKey , ptDim[p], vxDimline, vyDimline);//nSwapSide*vyView
						drInfo.setStereotype("LeftInfo");//
						drInfo.setNodeTextCumm(sTxtPostFix);	
						drInfo.addAllowedView(vzView, bAlsoReverseDirection);
						addDimRequest(drInfo);
					}
				}
				else	
				{	
					//debug: sTxtPostFix = sStereotype.left(1);		
					dr.setNodeTextCumm("<>" + sTxtPostFix);	
				}
									


				
				dr.addAllowedView(vzView, bAlsoReverseDirection); //vecView
				dr.vis(nDebugColorCounter++); // visualize for debugging 
				addDimRequest(dr); // append to shop draw engine collector
//}
/*			
reportNotice("\nStereotype is set to " + sStereotype + " in Direction v" + v + ": "  + vyDimline);

if(p==0)
{
DimRequestPLine dpl(strParentKey, PLine(drill.ptStartExtreme(),drill.ptStartExtreme()+vyDimline*U(300),drill.ptStartExtreme()+vyDimline*U(200)+vxView*U(50)), v);
dpl.addAllowedView(vzView, bAlsoReverseDirection );
dpl.vis(v);  
addDimRequest(dpl);

dpl =DimRequestPLine (strParentKey, PLine(drill.ptStartExtreme(),drill.ptStartExtreme()+vzDimline*U(300),drill.ptStartExtreme()+vzDimline*U(200)+vxView*U(50)), 4);
dpl.addAllowedView(vzView, bAlsoReverseDirection );
dpl.vis(3);  
addDimRequest(dpl);
}
*/

				
			}		
		}


		if (bShowRadius)
		{
			// show in side view
			if (nShowDiameter == 2 || nShowDiameter == 3)
			{
				Vector3d vzViewText;				
				// form a diameter string coming from the composite
				String sTxt;
				if (nShowDiameter==2) sTxt = T("|Ø|") +drill.dDiameter();
				else if (nShowDiameter==3) sTxt = T("|Radius Abbreviation|") +drill.dDiameter()/2;
				
				for (int i=0; i<adComposite.length();i++)
				{
					if (nShowDiameter==2)
						sTxt = sTxt+"/"+adComposite[i].dDiameter();
					else if (nShowDiameter==3)
						sTxt = sTxt+"/"+adComposite[i].dDiameter()/2;					
				}
				DimRequestText dr(strParentKey,sTxt ,drill.ptStart(), vxView, vyView);
				dr.addAllowedView(drill.vecSide(), bAlsoReverseDirection); //vecView
				addDimRequest(dr);				 
			}			
			// show the radius drill plan view
			else if(nShowDiameter==4 && vyView.isPerpendicularTo(drill.vecSide()))
			{
				Vector3d vxRad = vxView-vyView;	vxRad.normalize();
				DimRequestRadial drRad(strParentKey,drill.ptStart(),drill.ptStart()+vxRad*drill.dDiameter()/2 );
				drRad.addAllowedView(vzView, bAlsoReverseDirection); //vecView
				addDimRequest(drRad);
				
				// append potential composite drills
				for (int i=0;i<adComposite.length();i++)
				{
					DimRequestRadial drRad(strParentKey,adComposite[i].ptStart(),adComposite[i].ptStart()+vxRad*adComposite[i].dDiameter()/2 );
					drRad.addAllowedView(vzView, bAlsoReverseDirection); //vecView
					addDimRequest(drRad);					
				}
				
			}
		}

		// depth for non x-aligned drills
		if (bShowDepth && (!drill.bThrough() || adComposite.length()>0) && !bIsParallelX && 
			vzView.isParallelTo(vz) || vzView.isParallelTo(bm.vecX().crossProduct(_ZW).crossProduct(-_ZW)))
		{	
			Vector3d vxDimline,vyDimline,vzDimline;
			vxDimline = drill.vecFree();
			vyDimline = vxDimline.crossProduct(-vzView);
			//vyDimline = vxDimline.crossProduct(-vzDimline);
			vxDimline.vis(drill.ptStart(),1);	
			DimRequestChain dr(strParentKey, vxDimline, vyDimline, _kDimPar, _kDimNone); //-nSwapSide*vyView
			dr.addNode(drill.ptStart());
			dr.addNode(drill.ptEndExtreme());
			dr.addNode(drill.ptStart()-drill.vecZ()*drill.dDepth());	
			
			// append potential composite drills
			for (int i=0;i<adComposite.length();i++)
				dr.addNode(adComposite[i].ptEndExtreme());

			dr.addAllowedView(vzView, bAlsoReverseDirection); 
			dr.setStereotype("SectionLeft");			
			dr.setMinimumOffsetFromDimLine(0);	
			addDimRequest(dr);
		}	
		// depth for x-aligned drills
		if (bShowDepth && !drill.bThrough() && bIsParallelX && vzView.isPerpendicularTo(vz))
		{
			// order by radius		
			for (int i=0; i<adSameSide.length();i++)
				for (int j=0; j<adSameSide.length()-1;j++)
					if (adSameSide[j].dRadius() > adSameSide[j+1].dRadius())
						adSameSide.swap(j,j+1);		
			
			// create dimrequest only if drill is first in list of drills
			if (adSameSide.length()>0 && 
				adSameSide[0].dRadius() == drill.dRadius() && 
				adSameSide[0].dDepth() == drill.dDepth())
			{
				DimRequestChain dr(strParentKey, drill.vecFree(), drill.vecFree().crossProduct(vyView), _kDimPar, _kDimNone); 			
				for (int i=0; i<adSameSide.length();i++)
				{
					dr.addNode(adSameSide[i].ptStartExtreme());
					dr.addNode(adSameSide[i].ptEndExtreme());
				}
				dr.addAllowedView(vyView, bAlsoReverseDirection ); 
				dr.setStereotype("Drill");
				dr.setMinimumOffsetFromDimLine(0);	
				addDimRequest(dr);
			}
		}
	
		if (bShowAxisOffset && vyView.isPerpendicularTo(drill.vecSide()) )//nShowOffsetDrill!=3
		{
			Vector3d  vxDimline,vyDimline;
			vxDimline= -vyView;
			vyDimline= vxView;
			if (nLocationNearStartEnd==1)
			{
				vxDimline*=-1;
				vyDimline*=-1;	
			}
			if (nShowOffsetDrill!=0)
			{
				vxDimline*=-1;
				vyDimline*=-1;	
			}	
			if (nJapaneseOrientation== 2)
			{
				
				vxDimline = -vxBm.crossProduct(vzView);
				vyDimline = vxBm;				
				
			}
			Point3d ptDim[] = {bm.ptCen()-vyView*.5*bm.dD(vyView),drill.ptStart(),bm.ptCen()+vyView*.5*bm.dD(vyView)};
			if (abs(vyView.dotProduct(ptDim[0]-ptDim[1]))>dEps &&
				abs(vyView.dotProduct(ptDim[2]-ptDim[1]))>dEps)
			{
		
				Line ln(drill.ptStart(),vyView);//1.5*qdr.dD(vzMortise),vyView);
				DimRequestChain drChain(strParentKey,vxDimline, vyDimline, _kDimPar, _kDimNone);// -nSwapSide *
				drChain.setMinimumOffsetFromDimLine(0);
				drChain.addAllowedView(vzView, bAlsoReverseDirection); 
				drChain.setStereotype(sStereotypeOffset);			
	
				for (int p=0;p<ptDim.length();p++)
				{
				// show the depth of the drill on face
					if (p==1 && bShowDepthTxt && !drill.bThrough())
					{
						DimRequestText dr(strParentKey, drill.dDepth(), drill.ptStartExtreme(), vxView, vyView);
						dr.addAllowedView(vzView,bAlsoReverseDirection );
						addDimRequest(dr);	
					}
				// append nodes to individual dimline
					if (nShowOffsetDrill==0)	
						drChain.addNode(ln.closestPointTo(ptDim[p]));
				// append nodes to one chain		
					else
					{
						DimRequestPoint dr(strParentKey ,ptDim[p], vxDimline, vyDimline);
						dr.setNodeTextCumm("<>");
						dr.addAllowedView(vzView, bAlsoReverseDirection ); 
						dr.setStereotype(sStereotypeOffset);
						addDimRequest(dr);
					}					
				}
	
				// collect other same drills at this spot and add individual request
				if (nShowOffsetDrill==0)
				{
					// collect all drills at this x-location
					AnalysedDrill adChainY[0];
					for (int i=0; i<adOrdered.length();i++)
						if (abs(vxBm.dotProduct(adOrdered[i].ptStart()-drill.ptStart()))<dEps &&
							adOrdered[i].vecFree().isCodirectionalTo(drill.vecFree()))
							adChainY.append(adOrdered[i]);
							
					// test if this drill is first in list		
					if (adChainY.length()>0 && Vector3d(adChainY[0].ptStart()-drill.ptStart()).length()<dEps)
					{
						for (int i=1; i<adChainY.length();i++)
							drChain.addNode(ln.closestPointTo(adChainY[i].ptStart()));
						addDimRequest(drChain);	
					}	
				}// emd if option showIndividualAxisOffset
			}
		}
		nSwapSide *=-1;	
	}	



























#End
#BeginThumbnail
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
!V3,/
`










#End
