#Version 8
#BeginDescription
/// Version 4.9   th@hsbCAD.de   26.05.2010
/// bugfix head dim of seat cuts















#End
#Type E
#NumBeamsReq 1
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 4
#MinorVersion 9
#KeyWords 
#BeginContents
/// <summary>
/// Consumes any tool of type analyzed beamcut,if existant in dependency of a valley cut
/// creates several dimrequests in dependency of tool subtype and viewing direction
/// </summary>

/// <insert>
/// This tsl is only executed by the shopdraw engine and to use it one
/// needs to append it to the ruleset of a multipage style.
/// </insert>

/// <command name="Name">
/// If the user appends the command name to the execution key of the tsl in the ruleset, 
/// the tsl will append the value of the corresponding property of the tooling beam to 
/// the appropriate dimpoint
/// </command>

/// <command name="Information">
/// If the user appends the command name to the execution key of the tsl in the ruleset, 
/// the tsl will append the value of the corresponding property of the tooling beam to 
/// the appropriate dimpoint
/// </command>

/// <command name="Label">
/// If the user appends the command name to the execution key of the tsl in the ruleset, 
/// the tsl will append the value of the corresponding property of the tooling beam to 
/// the appropriate dimpoint
/// </command>

/// <command name="Sublabel">
/// If the user appends the command name to the execution key of the tsl in the ruleset, 
/// the tsl will append the value of the corresponding property of the tooling beam to 
/// the appropriate dimpoint
/// </command>

/// <command name="Marking">
/// If the user appends the command name to the execution key of the tsl in the ruleset, 
/// the tsl will create a horizontal and vertical marking as well as the corresponding
/// description at the appropriate dimpoint
/// </command>

/// <command name="MarkingColor">
/// If the user appends appends a execution map in the format MarkingColor;<ACAD Color Index> the 
/// marking color can be set. If a beamcut results into multiple pline displays (i.e. as for
/// a rising birdsmouth) the color of the back side will be incremented with 1.
/// </command>

/// <command name="showOnlyOnePointAtSeat">
/// NOTE: the format of this option has changed to a map entry from version 3.4 on
/// If the user appends an execution map in the format <command name>;<index> 
/// the seatcut will be dimensioned with
/// 'showOnlyOnePointAtSeat;0' two points
/// 'showOnlyOnePointAtSeat;1' the last point in dimline direction and the width as an appendix to the dimpoint
/// 'showOnlyOnePointAtSeat;2' the center point and the width as an appendix to the dimpoint
/// 'showOnlyOnePointAtSeat;3' the first point in dimline direction and the width as an appendix to the dimpoint
/// 'showOnlyOnePointAtSeat;4' the last point in dimline direction
/// 'showOnlyOnePointAtSeat;5' the center point
/// 'showOnlyOnePointAtSeat;6' the first point in dimline direction
/// 'showOnlyOnePointAtSeat;7' the center point (horizontal or rising beams) or the last point in dimline
///                            direction (vertical beams) with the width as an appendix to the dimpoint (default japanese style)
/// 'showOnlyOnePointAtSeat;8' the center point (horizontal or rising beams) or the last point in dimline
///                            direction (vertical beams)(optional japanese style)
/// 'showOnlyOnePointAtSeat;9' no points
/// </command>

/// <command name="modeLapPoints">
/// NOTE: the format of this option has changed to a map entry from version 3.4 on
/// If the user appends an execution map in the format <command name>;<index> 
/// the seatcut will be dimensioned with
/// 'modeLapPoints;0' two points
/// 'modeLapPoints;1' the last point in dimline direction and the width as an appendix to the dimpoint
/// 'modeLapPoints;2' the center point and the width as an appendix to the dimpoint
/// 'modeLapPoints;3' the first point in dimline direction and the width as an appendix to the dimpoint
/// 'modeLapPoints;4' the last point in dimline direction
/// 'modeLapPoints;5' the center point
/// 'modeLapPoints;6' the first point in dimline direction
/// 'modeLapPoints;7' the center point (horizontal or rising beams) or the last point in dimline
///                            direction (vertical beams) with the width as an appendix to the dimpoint (default japanese style)
/// 'modeLapPoints;8' the center point (horizontal or rising beams) or the last point in dimline
///                            direction (vertical beams)(optional japanese style)
/// 'modeLapPoints;9' no points
/// </command>

/// <command name="hatchLapJoint" Lang=en>
/// If the user appends an execution map in the format <command name>;<index> the display can be influenced by the value given:
/// 'hatchLapJoint;0' does not hatch the lap joint in the perpendicular view to the PreferredViewXDim (default)
/// 'hatchLapJoint;1' hatches the lap joint in the perpendicular view to the PreferredViewXDim. The pattern and the color of the  hatch can 
/// be set in the hatch settings of the layout override.
/// </command>

/// <command name="showSeatDepth" Lang=en>
/// If the user appends an execution map in the format <command name>;<index> the display can be influenced by the value given:
/// 'showSeatDepth;0 = at beam end <Default
/// 'showSeatDepth;1 = closed to tool location'
/// 'showSeatDepth;2 = at beam end, only depth from edge
/// 'showSeatDepth;3 = closed to tool location, only depth from edge
/// 'showSeatDepth;4 = do not show
/// </command>

/// <command name="showObholz" Lang=en>
/// NOTE: the format of this map entry has changed into numbers from version 3.1 on
/// If the user appends an execution map in the format <command name>;<index> 
/// 'showObholz;0' the Obholz will not be dimensioned
/// 'showObholz;1' displays plump Obholz
/// 'showObholz;2' displays perpendicular Obholz
/// </command>

/// <command name="showObholz" Lang=de>
/// HINWEIS: das Format des Eintrages wurde von Version 3.1 auf Ganzzahlen umgestellt
/// F·t der Benutzer einen Map-Eintrag showObholz;<Index> dem Regelsatz der Multipage hinzu,
/// so wird das Obholz verma?t
/// 'showObholz;0' the Obholz will not be dimensioned
/// 'showObholz;1' das lotrechte Obholz wird verma?t
/// 'showObholz;2' das rechtwinklige Obholz wird verma?t
/// </command>

/// <command name="setPreferredViewXDim" Lang=en>
/// If the user appends an execution map in the format <command name>;<index> the dimpoints of the tool seen along the
/// the axis of the beam will appear 
/// 'setPreferredViewXDim;0' default,view, can vary from tool properties
/// 'setPreferredViewXDim;1' left in side view
/// 'setPreferredViewXDim;2' right in side view
/// 'setPreferredViewXDim;3' on the side most aligned with the tool
/// 'setPreferredViewXDim;4' left in top view
/// 'setPreferredViewXDim;5' right in top view
/// </command>


/// <command name="StereotypeDepthHouse" Lang=en>
/// If the user appends appends a execution map in the format StereotypeDepthHouse;<Stereotype> the 
/// corresponding dimpoints will be collected with the format set in the stereotype definition.
/// If no customized stereotype is given the dimline will use the stereotype 'Section Left'
/// Note: You need to append the stereotype name in the ruleset of the multipage and it's inherited
/// layout overrides
/// </command>

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

/// <command name="DimFromStartEndLength" Lang=en>
/// If the user appends an execution map in the format <command name>;<Length in drawing units> the dimpoints
/// will be collected to two dimlines if the beam length exceeds the value given. 
/// One dimline is collecting the dimension points from the start to the middle of the beam while the second 
/// dimline is collecting the points from the end of the beam to the middle
/// </command>

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

/// <command name="show6Sides">
/// If the user appends the command name to the execution key of the tsl in the ruleset, the collection of the
/// dimpoints will be done for each possible viewing direction. This option should be enabled if you want to show
/// dimensions in more than the default views (front, top, left)
/// If this option is enabled the reverse display of a dimension is turned off. I.e. a contacting beam will then 
/// only be shown if contacting the entity from viewing direction.
/// </command>

/// <command name="setCompassViews">
/// If the user appends the command name to the execution key of the tsl in the ruleset, the main viewing directions
/// will be replaced by the viewing direction which are most aligned with the corresponding side of the beam.
/// The substitution is done in the sequence East = -World X, North = -World Y, West = World X, 
/// South = World Y. If the flag show6Sides is disabled only East and North are displayed.
/// This option apllies only for a beam which axis is parallel to World Z.
/// The stereotypes for these viewing directions are all set to default (*)
/// </command>

/// <command name="hideAngles" Lang=en>
/// If the user appends an execution map in the format <command name>;<index> the offset display can be influenced by the value given:
/// 'hideAngles;0' displays the angle of the tool in the appropriate view
/// 'hideAngles;1' does not display  the angle of the tool in the appropriate view

/// <remark>
/// Uses the following Stereotypes unless customized entries exist in the ruleset: Birdsmouth, SectionLeft,
/// Section Right, Obholz
/// </remark>

/// <remark>
/// The localization translation map should contain the abbreviation of "height" and "width"
/// for the strings "Height (abbreviate)" and "Width (abbreviate)" 
/// </remark>

/// History
/// Version 4.9   th@hsbCAD.de   26.05.2010
/// bugfix head dim of seat cuts
/// Version 4.8   th@hsbCAD.de   27.07.2009
/// seat depth only for perp seats
/// enhancements for closed birdsmouth's
/// Version 4.7   th@hsbCAD.de   13.07.2009
/// new option 'hide tools' suppresses any tool where the selected property applies
/// option 'showSeatDepth' extended
/// Version 4.6   th@hsbCAD.de   29.06.2009
/// enhancements option dialog
/// japanese override for tool 'Neda'
/// Version 4.5   th@hsbCAD.de   26.06.2009
/// Enhancements on sectional dimension of seatcuts
/// Version 4.4   th@hsbCAD.de   25.06.2009
/// bugfix classic dimension on rafters
/// Version 4.3   th@hsbCAD.de   09.06.2009
/// bugfix
/// Version 4.2   th@hsbCAD.de   09.06.2009
/// dimensioning for rotated seatcuts at beam end suppressed
/// Version 4.1   th@hsbCAD.de   27.05.2009
/// supports also Japanese Hip Cuts
/// Version 4.0   th@hsbCAD.de   25.05.2009
/// supports Dialog driven setup of options
/// Version 3.9   th@hsbCAD.de   13.05.2009
/// spell correction
/// Version 3.8   th@hsbCAD.de   16.04.2009
/// new option to determine the points to dimension a lap joint (modeLapPoints)
/// Version 3.7   th@hsbCAD.de   08.04.2009
/// lap joint and optional hatching of it added
/// Version 3.6   th@hsbCAD.de   24.03.2009
/// bugfix viewing directions
/// Version 3.5   th@hsbCAD.de   19.03.2009
/// Direction of X-Dimline dependent from Entity settings. i.e. using the option swapXDirection;1 with the tsl sd_BmDE will
/// alter the direction of the dimline
/// Version 3.4   th@hsbCAD.de   18.03.2009
/// showOnePointAtSeat enhanced
/// new option showSeatDepth
/// Version 3.3   th@hsbCAD.de   17.03.2009
/// bugfix on OpenDiagonalSeatCut which are parallel to the x-axis of the beam
/// Version 3.2   th@hsbCAD.de   16.03.2009
/// seatcut supports japanese options
/// Version 3.1   th@hsbCAD.de   09.03.2009
/// preferred views added
/// Version 3.0   th@hsbCAD.de   15.01.2009
/// ReversedBirdsmouth added
/// Version 2.9   th@hsbCAD.de   13.01.2009
/// 5-Axis dimensioning improved
/// Version 2.8   th@hsbCAD.de   12.01.2009
/// 5-Axis dimensioning improved
/// Version 2.7   th@hsbCAD.de   09.01.2009
/// bugfix obholz display

// basics and props
	U(1,"mm");
	double dEps = U(0.1);
	
	int bReportViews = false;
	int bReportOptions = false;

// on insert
	if (_bOnInsert) {
		
		_Beam.append(getBeam());
		_Pt0 = getPoint("Select point near tool");
		return;
	}	
//end on insert________________________________________________________________________________

// declaration of options 
	// NOTE: the CustomMapSettings and CustomMapTypes need to have the same length !
	String sCustomMapSettings[] = {"showOnlyOnePointAtSeat","modeLapPoints","hatchLapJoint","showSeatDepth","showObholz",
		"setPreferredViewXDim","StereotypeDepthHouse","ShowAllInOneLeft","ShowAllInOneRight","DimFromStartEndLength",
		"JapaneseStyle","show6Sides","setCompassViews", "markingColor","hideAngles","hideBeamcut"};
	String sCustomMapTypes[] = {"int","int","int","int","int",	"int","int","int","string","double", 	"int","int","int","int","int",     "int"};
	
// on MapIO
	if (_bOnMapIO)
	{
		// define property
		String sArNY[] = {T("|No|"),T("|Yes|")};

		String sArOnePointAtSeat[] = {T("|two points|"),T("|last point|") + " ," + T("|width appended|"),
			T("|center point|") + " ," + T("|width appended|"),T("|first point|") + " ," + T("|width appended|"),
			T("|last point|"),T("|center point|") ,T("|first point|"), T("|Japanese Style|") + " ," + T("|width appended|"),
			T("|Japanese Style|"), T("|Do not show|")};
		String sArObholz[] = {T("|Do not show|"),T("|plump|"),T("|perpendicular|")};
		String sArPreferredViewXDim[] = {T("|Default, can vary from tool properties|"), T("|Side View|") + " " + T("|left|"),T("|Side View|")+" " + T("|right|"),
			T("|Most aligned with tool|"),T("|Top View|")+" "+ T("|left|"),T("|Top View|")+" " + T("|right|")};
		String sArIndividualDepth[] = {T("|at beam head|"),T("|at tool|"),T("|at beam head|") + " " + T("|(depth only)|"),T("|at tool|") + " " + T("|(depth only)|"),T("|do not show|")};
		String sArHideTool[] = {T("|none|"),T("|complete through|"),T("|not complete through|")};
				
		PropString setPreferredViewXDim(5,sArPreferredViewXDim,T("|Preferred Viewing Direction of X-Dimline|"));
		PropString showObholz(4,sArObholz,T("|Show Obholz|"));	
		PropString ShowAllInOneLeft(7,sArNY,T("|Show all in one dimline on left side|"));
		PropString ShowAllInOneRight(8,sArNY,T("|Show all in one dimline on right side|"));
		PropString DimFromStartEndLength(9,"",T("|Add dimensions from Start and End|"));		
			
		PropString showOnlyOnePointAtSeat(0,sArOnePointAtSeat,T("|X-Dimline Seat Cuts|"));
		PropString showSeatDepth(3,sArIndividualDepth,T("|Show Seat depth|"));
		PropString hideTool(15,sArHideTool,T("|Hide Tools|"));		
		PropString modeLapPoints(1,sArOnePointAtSeat,T("|X-Dimline Lap Joints|"));
		PropString hatchLapJoint(2,sArNY,T("|Hatch Lap Joint|"));

		PropString StereotypeDepthHouse(6,"",T("|Stereotype Depth Housings|"));
		PropString JapaneseStyle(10,sArNY,T("|Set Japanese Style|"));
		PropString show6Sides(11,sArNY,T("|Show 6 Sides|"));
		PropString setCompassViews(12,sArNY,T("|Show Compass Views|"));		
		PropString markingColor(13,"16",T("|Color of Markings|"));		
		PropString hideAngles(14,sArNY,T("|Hide Angular Dimensions|"));				

								
		showOnlyOnePointAtSeat.setDescription(T("|Influences the dimpoints on a potential seat cut.|"));
		modeLapPoints.setDescription(T("|Influences the dimpoints on a potential lap joint.|"));		
		hatchLapJoint.setDescription(T("|Hatches a lap joint in the perpendicular view to the viewing direction|") + " " + 
			T("|The pattern and the color of the  hatch can be set in the hatch settings of the layout override.|"));
		showSeatDepth.setDescription(T("|Displays the depth of any seat in the appropriate view|"));
		setPreferredViewXDim.setDescription(T("|Sets the preferred side of the dimension in X-Direction of the beam|"));
		StereotypeDepthHouse.setDescription(T("|Defines the Name of Stereotype for any Housing|"));	
		String sAllInOne = T("|As this option can be set on beam level (sd_BmXX)other tools might collect their dimpoints to the same dimline.|") + " " + 
			T("|The result will be dimline which consists of all tooling dimpoints on this side of the beam.|") + " " +
			T("|If the option 'DimFromStartEndLength' is enabled two dimlines on the referenced side will be created.|") + " " + 
			T("|The stereotype which is used for the second dimline is called 'EndLeft' or 'EndRight'|");
		ShowAllInOneLeft.setDescription(T("|The dimpoints will be collected to a stereotype called|") + " LeftStart" +" "+sAllInOne);
		ShowAllInOneRight.setDescription(T("|The dimpoints will be collected to a stereotype called|") + " RightStart"+" "+sAllInOne);
		DimFromStartEndLength.setDescription(T("|One dimline is collecting the dimension points from the start to the middle of the beam while the second 
		 dimline is collecting the points from the end of the beam to the middle|"));
		JapaneseStyle.setDescription(T("|Sets various japanese dimensioning and symbol settings.|"));
		show6Sides.setDescription(T("|The collection of the dimpoints will be done for each possible viewing direction|"));
		setCompassViews.setDescription(T("|The main viewing directions will be replaced by the viewing direction which are most aligned with the corresponding side of the beam.|") + " " + 
			T("|The substitution is done in the sequence East = -World X, North = -World Y, West = World X, South = World Y.|") + " " + 
			T("|If the flag show6Sides is disabled only East and North are displayed. This option applies only for a beam which axis is parallel to World Z.|"));

				
	// find value in _Map, if found, change the property values
		showOnlyOnePointAtSeat.set(sArOnePointAtSeat[_Map.getString(sCustomMapSettings[0]).atoi()]);
		modeLapPoints.set(sArOnePointAtSeat[_Map.getString(sCustomMapSettings[1]).atoi()]);
		hatchLapJoint.set(sArNY[_Map.getString(sCustomMapSettings[2]).atoi()]);
		showSeatDepth.set(sArIndividualDepth[_Map.getString(sCustomMapSettings[3]).atoi()]);
		showObholz.set(sArObholz[_Map.getString(sCustomMapSettings[4]).atoi()]);		
		setPreferredViewXDim.set(sArPreferredViewXDim[_Map.getString(sCustomMapSettings[5]).atoi()]);		
		StereotypeDepthHouse.set(_Map.getString(sCustomMapSettings[6]));		
		ShowAllInOneLeft.set(sArNY[_Map.getString(sCustomMapSettings[7]).atoi()]);		
		ShowAllInOneRight.set(sArNY[_Map.getString(sCustomMapSettings[8]).atoi()]);			
		DimFromStartEndLength.set(_Map.getString(sCustomMapSettings[9]).atof());	
		JapaneseStyle.set(sArNY[_Map.getString(sCustomMapSettings[10]).atoi()]);	
		show6Sides.set(sArNY[_Map.getString(sCustomMapSettings[11]).atoi()]);	
		setCompassViews.set(sArNY[_Map.getString(sCustomMapSettings[12]).atoi()]);			
		if (_Map.hasString(sCustomMapSettings[13]))
			markingColor.set(_Map.getString(sCustomMapSettings[13]).atoi());			
		hideAngles.set(sArNY[_Map.getString(sCustomMapSettings[14]).atoi()]);			
		hideTool.set(sArHideTool[_Map.getString(sCustomMapSettings[15]).atoi()]);
										
		// show the dialog to the user
		showDialog("---"); // use "---" such that the set values are used, and not the last dialog values
		_Map = Map();
		
		// interpret the properties, and fill _Map. don't fill default options to keep ability to control settings by global options 		
		int nInd;
		nInd = sArOnePointAtSeat.find(showOnlyOnePointAtSeat,0); 	if (nInd>0)  _Map.setString(sCustomMapSettings[0],nInd);
		nInd = sArOnePointAtSeat.find(modeLapPoints,0); 				if (nInd>0)  _Map.setString(sCustomMapSettings[1],nInd);
		nInd = sArNY.find(hatchLapJoint,0); 								if (nInd>0)  _Map.setString(sCustomMapSettings[2],nInd);
		nInd = sArIndividualDepth.find(showSeatDepth,0); 				if (nInd>0)  _Map.setString(sCustomMapSettings[3],nInd);
		nInd = sArObholz.find(showObholz,0); 							if (nInd>0)  _Map.setString(sCustomMapSettings[4],nInd);
		nInd = sArPreferredViewXDim.find(setPreferredViewXDim,0);	if (nInd>0) _Map.setString(sCustomMapSettings[5],nInd);
			
		if (StereotypeDepthHouse!="")		_Map.setString(sCustomMapSettings[6],StereotypeDepthHouse);
		
		nInd = sArNY.find(ShowAllInOneLeft,0); 		if (nInd>0)  _Map.setString(sCustomMapSettings[7],nInd);
		nInd = sArNY.find(ShowAllInOneRight,0); 		if (nInd>0)  _Map.setString(sCustomMapSettings[8],nInd);
		if (DimFromStartEndLength.atof()>0)			  			_Map.setString(sCustomMapSettings[9],DimFromStartEndLength);	
		nInd = sArNY.find(JapaneseStyle,0); 			if (nInd>0)  _Map.setString(sCustomMapSettings[10],nInd);
		nInd = sArNY.find(show6Sides,0); 				if (nInd>0)  _Map.setString(sCustomMapSettings[11],nInd);
		nInd = sArNY.find(setCompassViews,0); 		if (nInd>0)  _Map.setString(sCustomMapSettings[12],nInd);
		nInd = markingColor.atoi();					if (nInd!=16)  _Map.setString(sCustomMapSettings[13],nInd);
		nInd = sArNY.find(hideAngles,0); 				if (nInd>0)  _Map.setString(sCustomMapSettings[14],nInd);		
		nInd = sArHideTool.find(hideTool,0); 		if (nInd>0)  _Map.setString(sCustomMapSettings[15],nInd);
		return;
	}





// Compose a _Map from the beam, in case the Tsl is appended to the database.
// The contents of the Map should be equal to the _Map generated by the shopdraw machine.
	if (_ThisInst.handle()!="") { // if handle is not empty, then instance is database resident
		reportMessage("\nRecompose map from beam entity");
		Beam bm = _Beam0; // should always be valid for an E-type 
			
		// get a relevant tool, and store it inside the _Map->ToolList
		AnalysedTool tools[] = bm.analysedTools(_bOnDebug); // 1 means verbose reportMessage 
		AnalysedBeamCut beamcuts[]= AnalysedBeamCut().filterToolsOfToolType(tools);
		int nIndClosest = AnalysedBeamCut().findClosest(beamcuts,_Pt0);	
		if (nIndClosest>=0)
		{
			// found a close tool. Compose _Map as if it was coming from the shopdraw machine
			Map mpToolList = AnalysedTool().convertToMap(beamcuts[nIndClosest]);
			_Map.setMap(_kAnalysedTools,mpToolList);
		}
		else 
		{
			reportMessage("\nNo tool found. Instance erased.");
			eraseInstance(); // no appropriate tool found
			return;
		}
		
		// for debug
		_kExecuteKey = "Marking;POS";
		_Map.setInt("setPreferredViewXDim",1);
		
	}
	
// get the tools from _Map
	AnalysedTool tools[] = AnalysedTool().convertFromSubMap(_Map,_kAnalysedTools,_bOnDebug); // 2 means verbose reportNotice 
	AnalysedBeamCut beamcuts[]= AnalysedBeamCut().filterToolsOfToolType(tools);
	int nIndClosest = AnalysedBeamCut().findClosest(beamcuts,_Pt0);
	if (nIndClosest<0) {
		reportMessage("\n"+scriptName() +": No tool found. Instance erased.");
		eraseInstance(); // calling eraseInstance will notify that the tool is not consumed.
		return;
	}

// the tool	
	AnalysedBeamCut beamcut = beamcuts[nIndClosest];	
	String sToolSubtype = beamcut.toolSubType();
	String sArToolSubtype[] = {_kABCSeatCut, _kABCRisingSeatCut, _kABCOpenSeatCut, _kABCLapJoint, _kABCBirdsmouth, 
		_kABCReversedBirdsmouth,_kABCClosedBirdsmouth, _kABCDiagonalSeatCut, _kABCOpenDiagonalSeatCut, _kABCBlindBirdsmouth,
		 _kABCHousing, _kABCHousingThroughout,_kABCHouseRotated, _kABCHouseTilted, _kABCJapaneseHipCut, 
		_kABCHipBirdsmouth, _kABCValleyBirdsmouth, _kABCRisingBirdsmouth, _kABCHoused5Axis, _kABCSimpleHousing, 
		_kABC5Axis};
	int nToolSubtype = sArToolSubtype.find(sToolSubtype);
	String sToolEntName = beamcut.toolEntTypeName().makeUpper();
	String strParentKey = String(beamcut.ptOrg()) + sToolSubtype ; // unique key for the tool
	GenBeam gb = beamcut.genBeam();
	Beam bm =(Beam)gb; 	
	Point3d ptOrg = beamcut.ptOrg();

	Vector3d  vxTool, vyTool, vzTool;
	vxTool = beamcut.coordSys().vecX();	vxTool.vis(ptOrg,1);
	vyTool = beamcut.coordSys().vecY();
	vzTool = beamcut.coordSys().vecZ();	vzTool.vis(ptOrg,150);

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


// check if the tsl will be executed in debug mode within the framework execution
	_kExecuteKey.makeUpper();	
	int n;	
	String sArToken[] = {"POS", "Name", "Information", "Label", "Sublabel","Marking"};
	String sArTokenUpper[0];
	for (int i=0;i<sArToken.length();i++) 
		sArTokenUpper.append(String(sArToken[i]).makeUpper());
		
	while (_kExecuteKey.token(n)!="")
	{
		String sToken = _kExecuteKey.token(n);
		sToken.trimLeft();
		sToken.trimRight();
		sToken.makeUpper();
		if (sToken .find("DEBUG",0)>-1)
			mapOption.setInt("debug",true);
		// determines the view direction for the length dimension. valid entries are TOP and SIDE
			
		else if (sArTokenUpper.find(sToken)>-1 && sArTokenUpper[sArTokenUpper.find(sToken)].length() == sToken.length())
			mapOption.setInt(sArToken[sArTokenUpper.find(sToken)],n+1);	
		n++;	
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

	
// report all options set
	if (bReportOptions)
	{
		reportNotice("\nOptions of "+scriptName() + ":");
		for (int i=0;i<mapOption.length();i++)
		{
			if (mapOption.hasDouble(i)) reportNotice("\n   "+mapOption.keyAt(i) +": " + mapOption.getDouble(i));
			else if (mapOption.hasInt(i)) reportNotice("\n   "+mapOption.keyAt(i) +": " + mapOption.getInt(i));
			else if (mapOption.hasString(i)) reportNotice("\n   "+mapOption.keyAt(i) +": " + mapOption.getString(i));		
		}	
		reportNotice("\n");
	}	


// ints
	int nShowAllInOneLeft = mapOption.getInt("SHOWALLINONELEFT");	
	int nShowAllInOneRight = mapOption.getInt("SHOWALLINONERIGHT");
	int nShow6Sides = mapOption.getInt("show6Sides");	
	int bJapaneseStyle = mapOption.getInt("japaneseStyle");
	int nJapaneseOrientation; // 0 = not defined, 1 = horizontal, 2 = vertical, 3 = rising
	int nCompassView=mapOption.getInt("setCompassView");
	int nShowObholz=mapOption.getInt("SHOWOBHOLZ");
	int mMarkingColor = mapOption.getInt("markingColor");
	int nShowOnlyOnePointAtSeat = mapOption.getInt("showOnlyOnePointAtSeat");
	int nModeLapPoints = mapOption.getInt("modeLapPoints");
	int nSetPreferredViewXDim= mapOption.getInt("setPreferredViewXDim");
	int nShowSeatDepth= mapOption.getInt("showSeatDepth");
	int nHatchLapJoint= mapOption.getInt("hatchLapJoint");	
	int bHideAngles= mapOption.getInt(sCustomMapSettings[14]);
	int nHideTool= mapOption.getInt(sCustomMapSettings[15]);
			
	double dDimFromStartEndLength = mapOption.getDouble("DIMFROMSTARTENDLENGTH");	
	
	String sStereotypeDepthHouse = mapOption.getDouble("STEREOTYPEDEPTHHOUSE");

// flag the japanese style, test dependencies
	if (bJapaneseStyle)
	{
		// override the ShowOnlyOnePointAtSeat
		int n=1;//with appendix
		if (nShowOnlyOnePointAtSeat==8)n=4;//without appendix
		else if (nShowOnlyOnePointAtSeat==9)n=8;//none
		nShowOnlyOnePointAtSeat=n+1;

		// override the modeLapPoints 
		//n=1;//with appendix
		//if (nModeLapPoints ==8)n=4;//without appendix
		//else if (nModeLapPoints ==9)n=8;//none
		//nModeLapPoints =n+1;
		//if (bReportOptions) reportNotice("\n   modeLapPoints override:" + nModeLapPoints);
				
		if (bm.vecX().isPerpendicularTo(_ZW))
			nJapaneseOrientation	= 1;	
		else if (bm.vecX().isParallelTo(_ZW))
		{
			nJapaneseOrientation	= 2;
			nShowOnlyOnePointAtSeat=n;//the last point in dimline direction
		}
		else
			nJapaneseOrientation	= 3;					
	}


// the beamcut defines a Quader, and the beam defines a Quader used in the analysis
	Quader qdrBeam = beamcut.genBeamQuader();
	Quader qdr = beamcut.quader();
	qdr .vis(3);	

	Vector3d vx,vy,vz;
	vx = bm.vecD(vxTool);

// collect some properties (name, type etc) of the 'tool'-beam
	String sTxtPostFix;
	//int bAddMarking;
	_kExecuteKey.makeUpper();		
	ToolEnt tent = beamcut.toolEnt();
	GenBeam gbTools[] = tent.genBeam();
	GenBeam gbTool;
	// collect the beamname of the tooling beam to show in dim
	for (int p=0; p<gbTools.length(); p++)
		if (gbTools.find(gb) !=p && 
			 gbTools[p].realBody().hasIntersection(beamcut.cuttingBody()) && 
			!bm.vecX().isParallelTo(gbTools[p].vecX())
			&& !bm.bIsDummy())
		{
			for (int q =0; q<mapOption.length();q++)
			{
				if (mapOption.keyAt(q) == "POS") sTxtPostFix = sTxtPostFix+ " " + gbTools[p].posnum();
				else if (mapOption.keyAt(q) == "Name") sTxtPostFix = sTxtPostFix+ " " + gbTools[p].name();
				else if (mapOption.keyAt(q) == "Information") sTxtPostFix = sTxtPostFix+ " " + gbTools[p].information();
				else if (mapOption.keyAt(q) == "Label") sTxtPostFix = sTxtPostFix+ " " + gbTools[p].label();
				else if (mapOption.keyAt(q) == "Sublabel") sTxtPostFix = sTxtPostFix+ " " + gbTools[p].subLabel();
			}
			gbTool = gbTools[p];
			break;
		}
	if (bReportOptions) reportNotice("\nThe postfix derived of the tooling beam is "+sTxtPostFix);
		
// subtype cases
	if (bReportViews) reportNotice("\n" +scriptName()+ "has detected tool subtype" + nToolSubtype);
	int bShowPLines;		// flag if ursenkel and waageri? to be shown
	int bShowBlindDepth;	// falg if blind depth to be shown
	int bShowClosed;
	int bShowMultiviewLine;
	int bShowDisplacement;
	int bShow5Axis;
	int bShowSeatHouseXLocation;
	int nShowSeatHouseDepth;
	int bShowSimpleHouse;
	int bShowXYAngle;
	int bAddSecondUS;
	int bShowObholz;
	int bHatchLap;
	int bShowFrontBackPLines;// flag if a certain type needs to show the plines for front and back (kABCRisingBirdsmouth)
	int bShowWidthHead;

	int nModeSeatLapPoints = nShowOnlyOnePointAtSeat;

	if (nToolSubtype==0 && nHideTool!=1)//_kABCSeatCut
	{
		bShowSeatHouseXLocation=true;
		nShowSeatHouseDepth=true;		
	}	
	else if (nToolSubtype==1 && nHideTool!=1)//_kABCRisingSeatCut	
	{
		reportNotice("\n" + sToolSubtype + " not defined yet.");
		eraseInstance();
		return;	
	}						
	else if (nToolSubtype==2 && nHideTool!=2)//kABCOpenSeatCut)
	{
		bShowSeatHouseXLocation=true;
		nShowSeatHouseDepth=true;
	}
	else if (nToolSubtype==3  && nHideTool!=2)//_kABCLapJoint	
	{
		bShowSeatHouseXLocation 	=true;	
		bHatchLap						=true;	
		nModeSeatLapPoints = nModeLapPoints;
	}
	else if (nToolSubtype==4  && nHideTool!=1)//ABCBirdsmouth)
	{
		bShowPLines=true;
		bShowObholz=true;
		bShowXYAngle=true;		
	}
	else if (nToolSubtype==5  && nHideTool!=1)//_kABCReversedBirdsmouth	
	{
		bShowPLines=true;		
		bShowMultiviewLine=true;
		bShowDisplacement =true;
		bAddSecondUS=true;
		bShowObholz=true;		
	}
	else if (nToolSubtype==6  && nHideTool!=1)//_kABCClosedBirdsmouth)
	{
		bShowPLines=true;
		bShowClosed=true;
		bShowObholz=true;
	}
	else if (nToolSubtype==7 && nHideTool!=2)//_kABCDiagonalSeatCut)
	{
		nShowSeatHouseDepth=true;	
		bShowSeatHouseXLocation=true;	
		bShowXYAngle=true;	
	}
	else if (nToolSubtype==8  && nHideTool!=1)//_kABCOpenDiagonalSeatCut)
	{
		nShowSeatHouseDepth=true;	
		bShowSeatHouseXLocation 	=true;	
		bShowXYAngle=true;	
	}		
	else if (nToolSubtype==9)//_kABCBlindBirdsmouth)
	{
		bShowPLines=true;
		bShowBlindDepth=true;
	}
	else if (nToolSubtype==10 && nHideTool!=2)//_kABCHousing)
	{
		nShowSeatHouseDepth=true;	
		bShowSeatHouseXLocation 	=true;		
		bShowXYAngle=true;			
	}	
	else if (nToolSubtype==11)//_kABCHousingThroughout	
	{
		bShowSeatHouseXLocation 	=true;
		bShowSimpleHouse=true;
					
		// show angle only for != 90?
		if (!vyTool.isParallelTo(qdrBeam.vecD(vyTool)))
			bShowXYAngle=true;	
	}		
	else if (nToolSubtype==12)//_kABCHouseRotated
	{
		reportNotice("\n" + sToolSubtype + " not defined yet.");
		eraseInstance();
		return;	
		
	}
	else if (nToolSubtype==13)//_kABCHouseTilted
	{
		reportNotice("\n" + sToolSubtype + " not defined yet.");
		eraseInstance();
		return;	
		
	}
	else if (nToolSubtype==14)//_kABCJapaneseHipCut	
	{
		bShowWidthHead=true;			
	}
	else if (nToolSubtype==15 && !nHideTool)//_kABCHipBirdsmouth = Herzkerve
	{
		bShowPLines=true;
		bShowMultiviewLine=true;
		bShowDisplacement =true;	
	}		
	else if (nToolSubtype==16)// _kABCValleyBirdsmouth)
	{
		bShowPLines=true;
		bShowMultiviewLine=true;
		bShowDisplacement =true;
	}
	else if (nToolSubtype==17)//_kABCRisingBirdsmouth
	{
		bShowPLines=true;
		bShowMultiviewLine=true;
		bShowDisplacement =true;
		bShowFrontBackPLines =true;
		bShowObholz=true;		
	}	
	else if (nToolSubtype==18)//_kABCHoused5Axis
	{
		bShowPLines=true;		
	}
	else if (nToolSubtype==19 && nHideTool!=2)// _kABCSimpleHousing)
	{
		bShowSeatHouseXLocation=true;
		bShowSimpleHouse=true;
		nShowSeatHouseDepth=true;		
	}		
	else if(nToolSubtype==20)// _kABC5Axis)
	{
//		bShow5Axis=true;
		bShowPLines=true;		
		bShowMultiviewLine=true;
		bShowDisplacement =true;
		bAddSecondUS=true;
		bShowObholz=true;		
		bShowFrontBackPLines =true;
	}	
	else
	{
		eraseInstance();
		return;
	}


// overrides
	if (bHideAngles)bShowXYAngle=false;

// collect all beamcuts at same spot with same orientation for listed subtypes
	AnalysedBeamCut abcOrdered[0];
	int nArOrderType[] = {0,7, 10};//_SeatCut,DiagonalSeatCut
	if (nArOrderType.find(nToolSubtype)>-1)//
	{
		double dXRef = vx.dotProduct(bm.ptCen()-beamcut.ptOrg());
		AnalysedTool toolsBm[] = bm.analysedTools(_bOnDebug); // 1 means verbose reportMessage 
		AnalysedBeamCut abcTmp[0];
		for (int i=0; i<nArOrderType.length();i++)
			abcTmp.append(AnalysedBeamCut().filterToolsOfToolType(toolsBm,sArToolSubtype[nArOrderType[i]]));
		
		// filter same beamcuts which are at same x-position and with alignment
		for (int i=0; i<abcTmp.length();i++)
		{
			double dXThis = vx.dotProduct(bm.ptCen()-abcTmp[i].ptOrg());
			if (beamcut.toolSubType() == abcTmp[i].toolSubType() &&
				abs(dXRef-dXThis)<dEps && vxTool.isParallelTo(abcTmp[i].coordSys().vecX()))
				abcOrdered.append(abcTmp[i]);
		}
	}
	else
		abcOrdered.append(beamcut);
	

// collect some specific tools of this beam
	AnalysedTool at[] = bm.analysedTools(_bOnDebug); // 2 means verbose reportNotice 
	// find a potential valley line
	AnalysedDoubleCut adc[] = AnalysedDoubleCut ().filterToolsOfToolType(at,_kADCValley);	
	// find potential hip cuts
	AnalysedCut ac[] = AnalysedCut ().filterToolsOfToolType(at,_kACHip);

// vector of the relevant face and detect a potential hip/valley line
	Point3d ptHipValley[0];
	int nHasHipValley;//1=valley, 2=hip	
	int nHasDissimilarPitches; // if dissimilar pitches are detected 2 projections are needed
	Vector3d vSide = -beamcut.vecSide();
	if (adc.length()>0)
	{
		// ignore valley cuts which are parallel to the beam faces
		for (int i=0; i<adc.length(); i++)
			if (!adc[i].vecN1().isParallelTo(bm.vecD(adc[i].vecN1())))
			{
				vSide = adc[i].vecSide();
				ptHipValley=adc[i].bodyPointsAlongLine();
				nHasHipValley=1;
				if (abs(adc[i].dAngle1()-adc[i].dAngle2())>dEps)
					nHasDissimilarPitches=true;				
			}
	}
	else if(ac.length()>1)
	{
		vSide = ac[0].vecSide();
		Point3d pt1[0], pt2[0];
		pt1 = ac[0].bodyPointsInPlane();
		pt2 = ac[1].bodyPointsInPlane();	
		for (int p=0; p<pt1.length(); p++)
			for (int q=0; q<pt2.length(); q++)
				if (Vector3d(pt1[p]-pt2[q]).length() <= dEps)
				{
					ptHipValley.append(pt1[p]);	
				}	
		ptHipValley= Line(bm.ptCen(),vxBm).orderPoints(ptHipValley);	
		nHasHipValley=2;	
		if (abs(ac[0].dAngle()-ac[1].dAngle())>dEps)
			nHasDissimilarPitches=true;					
	}	
	//vSide.vis(_Pt0,33);

// set references US (Ursenkel)
	Vector3d vFace = vSide.crossProduct(vxBm);
	Vector3d vProj = qdr.vecD(vFace);
	Point3d ptUS[0];
	if (ptHipValley.length()>0)
	{
		PlaneProfile ppShadowBox = bm.realBody().shadowProfile(Plane(ptHipValley[0],vFace));			//pp.vis(2);			
		Point3d pt[0];
		pt.append(qdr.pointAt(-1,-1,-1));
		// append a second Ursenkel for certain types
		if (bAddSecondUS)
			pt.append(qdr.pointAt(1,1,1));
			
		for(int p=0;p<pt.length();p++)
		{	
			// calc one corner at hip/valley side 
			pt[p] = Line(pt[p], qdr.vecD(vSide)).intersect(qdr.plFaceD(vSide),0);
			// test if qdr aligned vFace is free			
			if(gbTool.bIsValid())
				vProj = qdr.vecD(gbTool.vecX());
			// the US is the intersetion with the perp hip/valley plane...
			Point3d ptThisUS = Line(pt[p],vProj).intersect(Plane(ptHipValley[0],vFace),0);
			
			// add only those which are within the beam
			if (ppShadowBox.pointInProfile(ptThisUS)!=_kPointOutsideProfile)
				ptUS.append(ptThisUS);
			//ptUS[p].vis(6);
		}	
	}
	// if is not a hip or valley the reference ptUS will be defined view dependent


// this part needs to be cleaned up from version before 2.2
	Point3d ptRef;
	Point3d ptX = qdr.pointAt(1,-1,-1);
	Plane pnRef;
	// make sure the x is on a plane thrugh the hip/valley
	if (ptHipValley.length()>0)
	{
		pnRef = Plane(ptHipValley[0],vFace);
		ptX = Line(ptX,vFace).intersect(pnRef,0);
	}
// this part needs to be cleaned up from version before 2.2	

// debug color
	int nDebugColorCounter = 1;

// possible view directions in length
	Vector3d vArView[] = {-vyBm, vzBm};//	
	//vArView.append(-bm.vecY());	
	//vArView.append(bm.vecZ());
	int bAlsoReverseDirection = true;

// CoordSys for sectional display
	CoordSys csSection[0];
	csSection.append(CoordSys(bm.ptCen(),vxBm.crossProduct(vzBm),vzBm,-vxBm));
	
// show 6 sides	
	if (nShow6Sides>0)
	{
		vArView.append(vyBm);
		vArView.append(-vzBm);	
		csSection.append(CoordSys(bm.ptCen(),-vxBm.crossProduct(vzBm),vzBm,vxBm));
		bAlsoReverseDirection = false;
	}	
	
// show WCS related = compass
	if (nCompassView>0 && vxBm.isParallelTo(_ZW))
	{
		Vector3d  vAr[] = {-_XW,-_YW,_XW,_YW};
		for (int i=0;i<vArView.length();i++)
			if (i<vAr.length())
				vArView[i] = bm.vecD(vAr[i]);			
	}
	
// set the tool default stereotype as stereotype  or uniform stereotype
	String sStereotype, sStereotypeDefault, sStereotypeUniform="Start";
	sStereotype = "Birdsmouth";
	sStereotypeDefault = "Birdsmouth";

// if the length exceeds the length given in the option SHOWREVERSEDFROMLENGTH 2 separate dimlines 
// starting from start and end will be created
// the stereotypes which are used are formed with <Side><Direction> Side=Left/Right, Direction=Start/End
	int nLocationNearStartEnd=-1;//-1=left, 1=right
	if (ptExtreme.length()>0 && abs(vxBm.dotProduct(ptExtreme[0]-ptOrg)) > .5*bm.solidLength() && 
		(!bm.vecX().isParallelTo(_ZW)))
		nLocationNearStartEnd=1;
	
	int bDimFromStartEndLength;
	if(dDimFromStartEndLength > dEps && dDimFromStartEndLength <bm.solidLength())
		bDimFromStartEndLength = true;
	
	if(bDimFromStartEndLength  && ptExtreme.length()>0 && nShowAllInOneLeft)
	{
		if (nLocationNearStartEnd==1) //&& dDimFromStartEndLength>0
			sStereotypeUniform="End";				
		else
			sStereotypeUniform="Start";		
	}	

	String sStereotypes[]={"Birdsmouth","*"};
	int nSwapSide = 1;


		
// LOOP TOP AND SIDE VIEWS	
	Vector3d vxView,vyView,vzView;
	vxView = vxBm;
	
// loop view directions
	for (int v=0; v<vArView.length(); v++) 
	{
		vzView = vArView[v];
		vyView = vxView.crossProduct(-vzView);

	//	declare an array of preferred vecs for x dim
		Vector3d vPrefViewXDim[] = {vyView,vzBm,-vzBm,bm.vecD(vzTool),vyBm,-vyBm};
		
	// preset the dim orientation		
		Vector3d  vxDimline, vyDimline, vzDimline;
		vxDimline = vxView;
		vyDimline = vPrefViewXDim[nSetPreferredViewXDim];	//vyDimline.vis(ptOrg,3);
		vzDimline = vxDimline.crossProduct(vyDimline);

	// identify placement side of tool dim
		int nToolDimSide = -1;// -1 = left, 1 = right
		if (vyView.dotProduct(ptOrg-ptCen)<0)
			nToolDimSide *= -1;	
							
	// for rising beams and with te japanes style set avoid the back view
		if(nJapaneseOrientation==3)
		{
			vzDimline *=-1;
			bAlsoReverseDirection =false;
		}		
		
	// build the stereotype name per side and per start/end
		// override the default stereotype if all dimensions are supposed to show in one dimline
		// RIGHT
		if (!bm.vecD(vyDimline).isCodirectionalTo(bm.vecD(vyView)) && nShowAllInOneRight)// && bDimFromStartEndLength
			sStereotype =	"Right"+sStereotypeUniform;
		// LEFT	
		else if(nShowAllInOneLeft)		
			sStereotype =	"Left"+sStereotypeUniform;			


		if (bReportViews) reportNotice("\n"+scriptName()+ " with Stereotype: "+ sStereotype+ " in view " + v);	
		// define reference view dependent if not hip/valley
		if (ptHipValley.length()<1 && vSide.isParallelTo(vyView) && !vxBm.isParallelTo(vxTool) && nToolSubtype!=14)
		{
			// get the point of ursenkel
			Point3d ptRefUS = qdr.pointAt(-1,-1,-1);
			if (!beamcut.bIsFreeD(vyTool))
			{ 
				// if it is a closed birdsmouth get the deeper one
				ptRefUS = qdr.pointAt(1,-1,-1);
				if (vyView.dotProduct(ptRefUS -qdr.pointAt(-1,1,-1))<0)
					ptRefUS = qdr.pointAt(-1,1,-1);
			}
			ptRefUS.vis(211);
			Plane pnBm(bm.ptCen(),vzView);
			
			ptUS.append(Line(ptRefUS , vxTool).intersect(pnBm,.5*bm.dD(vzView)));
			ptUS[ptUS.length()-1].vis(211);
			// append the back side for some cases
			if (bShowFrontBackPLines)
			{
				ptUS.append(Line(ptRefUS , vxTool).intersect(pnBm,-.5*bm.dD(vzView)));
				ptUS[ptUS.length()-1].vis(20);
			}	
		}// end if no hip/valley
		
	// try to find valley line
		Vector3d vyN = vxView;
		if (!vxView.isParallelTo(_ZW))
			vyN = vxView.crossProduct(_ZW).crossProduct(-_ZW);
		vy = qdr.vecD(vyN);	
		vz = vx.crossProduct(vy);		vz.normalize();
		vy = vx.crossProduct(-vz);		vy.normalize();
		
	// collect the valley from the beam
		AnalysedTool atGenBeam[] = gb.analysedTools(_bOnDebug);
		AnalysedDoubleCut adcValleys[] = AnalysedDoubleCut ().filterToolsOfToolType(atGenBeam,_kADCValley);			

		
	// show 5 Axis___________________________________________________________________________show 5 Axis_____________________
		if (bShow5Axis)
		{
			if (bReportViews) reportNotice("\nshow 5 Axis in view " + v);	
// to be revised !!!			
			Point3d ptQdrIntersect[0];
			
			// get outer plane of genbeam vx side
			Plane pnOut1 = qdr.plFaceD(vx);
			ptQdrIntersect= pnOut1.filterClosePoints(beamcut.genBeamQuaderIntersectPoints(),U(1));			
			if (ptQdrIntersect.length()>0) // redefine plane normal to vx
				pnOut1 = Plane(ptQdrIntersect[0],vx);
			ptQdrIntersect= pnOut1.filterClosePoints(beamcut.genBeamQuaderIntersectPoints(),U(1));		
			// filter points to 'not on edge'
			Point3d ptNotEdge[0];	
			PlaneProfile pp = bm.envelopeBody().shadowProfile(pnOut1);			//pp.vis(2);	
			for (int p=0; p< ptQdrIntersect.length();p++)
				if (pp.pointInProfile(ptQdrIntersect[p]) == _kPointInProfile)
					ptNotEdge.append(ptQdrIntersect[p]);

			// get outer plane of genbeam -vx side
			Plane pnOut2 = qdr.plFaceD(-vx);	
			ptQdrIntersect= pnOut2.filterClosePoints(beamcut.genBeamQuaderIntersectPoints(),U(1));
			if (ptQdrIntersect.length()>0)			// redefine plane normal to vx
				pnOut2 = Plane(ptQdrIntersect[0],vx);
			ptQdrIntersect= pnOut2.filterClosePoints(beamcut.genBeamQuaderIntersectPoints(),U(1));	
			
			// filter points to 'not on edge'
			Point3d ptNotEdge2[0];	
			PlaneProfile pp2 = bm.envelopeBody().shadowProfile(pnOut2);			//pp2.vis(3);	
			for (int p=0; p< ptQdrIntersect.length();p++)
				if (pp2.pointInProfile(ptQdrIntersect[p]) == _kPointInProfile)
					ptNotEdge2.append(ptQdrIntersect[p]);

			// relocate ptX
			if (ptNotEdge.length()>0 && ptNotEdge2.length()>0)
			{
				Vector3d vxProj = ptNotEdge2[0]-ptNotEdge[0];
				vxProj.normalize();
				ptX = Line(ptNotEdge[0],vxProj).intersect(pnRef,0);	
			}
			//ptX.vis(2);
			
			if(vx.isPerpendicularTo(vzView))
			{
				DimRequestText drTxt;
				String sTxt,s;
				if (abs(beamcut.dAngle()) > 0.5)
				{				
					sTxt.formatUnit(beamcut.dAngle(),2,1);
					sTxt += "?";
				}
				if (abs(beamcut.dTwist()) > 0.5)
				{
					s.formatUnit(beamcut.dTwist(),2,1);
					if (sTxt.length()> 0) sTxt += " / ";
					sTxt += s+ "?";
				}

				if (abs(beamcut.dBevel()) > 0.5)
				{
					s.formatUnit(beamcut.dBevel(),2,1);
					if (sTxt.length()> 0) sTxt += " / ";
					sTxt += s+ "?";
				}
				if (sTxt.length()>0)
				{
					drTxt = DimRequestText (strParentKey, sTxt, ptX, vy, vx);
					drTxt.addAllowedView(vz, TRUE); 
					addDimRequest(drTxt);
				}
			}
		}		


	// show PLines___________________________________________________________________________show PLines_____________________
		if (bShowPLines && vFace.isParallelTo(vzView))// )
		{
			if (bReportViews) reportNotice("\nshow PLines " + v);
			// the angle between the ursenkel and the waageriss. store this value to find out if
			// optional second pline display needs also second angle (if different)
			double dAngleUsWr;
			
			//calculate dimpoints for each ursenkel ptUS
			for (int p=0; p<ptUS.length(); p++)
			{
			// declare a shadow to detect invalid qdr intersect points
				PlaneProfile ppShadow = bm.realBody().shadowProfile(Plane(ptUS[p],vFace));
			
				Point3d pt[0];
				Point3d ptDim[0],ptDimPreferredView[0];
				Point3d ptInt[] = beamcut.genBeamQuaderIntersectPoints() ;
				Plane pnUpper(bm.ptCen()+.5*vSide*bm.dD(vSide),vSide);				
				ptInt = Plane(ptUS[p],vzView).filterClosePoints(ptInt,dEps);
				

			// remove ptUS from list and disregard points which do not touch the body
				Point3d ptTmp[0];
				for (int q=0; q<ptInt.length(); q++)
				{
					if (Vector3d(ptInt[q]-ptUS[p]).length()< dEps){continue}
					
					if (ppShadow.pointInProfile(ptInt[q]) == _kPointOutsideProfile)
					{
						ptDimPreferredView.append(ppShadow.closestPointTo(ptInt[q]));
						continue;
					}
					else
					{
						ptDimPreferredView.append(ptInt[q]);
						ptTmp.append(ptInt[q]);
					}
				}// next q
				ptInt=ptTmp;
											
			// valley and hip
				if (ptHipValley.length()>0 && vSide.isParallelTo(bm.vecD(_ZW)))
				{
					Vector3d vxN = qdr.vecD(vxBm);
					CoordSys cs;
					cs.setToProjection(Plane(ptHipValley[0],vFace),qdr.vecD(vFace));
					vxN.transformBy(cs);	
					pt.append(Line(ptUS[p],_ZW).intersect(Plane(ptHipValley[0],vSide),0)); 
					pt.append(ptUS[p]);	
					pt.append(Line(ptUS[p],vxN).intersect(Plane(ptHipValley[0],vSide),0));		
				}
			// others
				else
				{
					// at least 2 points are needed to derive directions
					if (ptInt.length()>1)
					{
						/*
						//if (ptInt.length()>2)
						//{
						//	ptInt.setLength(2);
						//	ptInt[0] = qdr.pointAt(-1,-1,-1);
						//	ptInt[1] = qdr.pointAt(-1,1,-1);
						//}
						
						// get intersecting points to upper plane
						for (int q=0; q<ptInt.length(); q++)
						{
							Vector3d vProj = ptUS[p]-ptInt[q];
							vProj=qdr.vecD(vProj);
							vProj.normalize();
							vProj.vis(ptInt[q],1);
							ptInt[q] = Line(ptInt[q],vProj).intersect(pnUpper,0);
							ptInt[q].vis(1);
							
						}
						
						
							
						ptInt[0].vis(0);
						ptInt[1].vis(1);
						
						*/
						
						ptInt.setLength(2);
						Vector3d vDir = vyTool;
						if (vDir.dotProduct(ptUS[p]-ptOrg)<0)
							vDir*=-1;
						ptInt[0]=ptUS[p]+vDir*qdr.dD(vDir);
						ptInt[0] = Line(ptInt[0],vDir).intersect(pnUpper,0);
						
						vDir = vzTool;
						if (vDir.dotProduct(ptUS[p]-ptOrg)<0)
							vDir*=-1;
						ptInt[1]=ptUS[p]+vDir*qdr.dD(vDir);
						ptInt[1] = Line(ptInt[1],vDir).intersect(pnUpper,0);
						
						// eventually swap ursenkel and waageriss
						if (vxBm.dotProduct(ptInt[0]-ptInt[1])<dEps)
							ptInt.swap(0,1);
						//append them all to the collection
						pt.append(ptInt[0]);	
						pt.append(ptUS[p]);	
						pt.append(ptInt[1]);
					}
					else
					{				
						Vector3d vxN, vzN;
						vxN = qdr.vecD(vxBm.crossProduct(_ZW).crossProduct(-_ZW));//
						vzN = qdr.vecD(vxN.crossProduct(vFace));					
						pt.append(Line(ptUS[p],qdr.vecD(vzN)).intersect(pnUpper,0)); 
						pt.append(ptUS[p]);//pt.append(Line(ptUS[p],qdr.vecD(vSide)).intersect(Plane(bm.ptCen(),bm.vecD(-vSide)),.5*bm.dD(vSide)));
						pt.append(Line(ptUS[p],qdr.vecD(vxN)).intersect(pnUpper,0));	
					}
				}// end else others

			// collect dim points and pline's verteces for hip/valley
				PLine pl;
				for (int q=0; q<pt.length(); q++)
				{	
					pt[q] =pt[q].projectPoint(Plane(bm.ptCen(),vFace),.5*bm.dD(vFace));
					//pt[q].vis(p);
					pl.addVertex(pt[q]);
					// append first and last to be dimensioned
					if (q==0|| q == pt.length()-1)
						ptDim.append(pt[q]);
				}
			
			// append extremes for non hip/valley, top view and other beamtypes
				if (v==1 && ptHipValley.length()<1)	
					ptDim.append(ptExtreme);
					
			// declare marking text	and marking color
				String sDimTxt[] = {T("|Ursenkel|"),T("|Waageriss|")};
				int nColor = 16;
				if (mapOption	.hasInt(sCustomMapSettings[13]))
					nColor = mapOption.getInt(sCustomMapSettings[13]);

			// add marking side to the string array
				if (nHasHipValley<1 && vzView.dotProduct(ptUS[p]-bm.ptCen())<dEps && ptUS.length()>1)
				{
					sDimTxt[0] += " " + T("|back side|");
					sDimTxt[1] += " " + T("|back side|");
					nColor ++;
				}
			
			// compose and add the classic beamcut dim if no particualr side has been set
				if(nSetPreferredViewXDim==0)
				{ 	
					if (bReportViews) reportNotice("...classic dims ");		
				// compose dimrequest point		
					for (int q=0; q<ptDim.length(); q++)
					{
						DimRequestPoint dr(strParentKey, ptDim[q], vxView, nSwapSide*vyView);
						dr.setStereotype(sStereotypes[v]);//
						if (q==0)
							dr.setNodeTextCumm("<>" + ": " + sDimTxt[q] + " " + sTxtPostFix);
						else if (q<2)
							dr.setNodeTextCumm("<>" + ": " + sDimTxt[q]);	
						dr.addAllowedView(vzView, TRUE);
						addDimRequest(dr);	
					}
	
				// show the guide lines by composing a dimrequest pline
					if (mapOption.getInt("Marking")>0)//v==0 && 
					{
						DimRequestPLine drpl(strParentKey, pl, nColor);
						drpl.addAllowedView(vzView, TRUE);  
						addDimRequest(drpl); // append to shop draw engine collector
						pl.vis(nColor);
						
					// test if plump and horizontal marking are perpendicular
						if (pt.length()>2)
						{
							Vector3d v1,v2;
							v1 = pt[0]-pt[1];v1.normalize();
							v2 = pt[2]-pt[1];v2.normalize();
							int bOk = true;
							if (v1.isPerpendicularTo(v2)) bOk = false;
							if (p>0 && 180-(dAngleUsWr+v1.angleTo(v2))<dEps) bOk = false;
							if (p>0 && abs(dAngleUsWr)-abs(v1.angleTo(v2))<dEps) bOk = false;
							if (abs(v1.angleTo(v2))<dEps) bOk = false;
							// do in case of non perpendicularity
							if (bOk)
							{
								Point3d ptCen,pt1,pt2,ptTxt ;
								ptCen = pt[1];
								pt1 = ptCen + v1*U(1);
								v2 = vxBm;
								if (v1.dotProduct(v2)<0)	v2*=-1;
								pt2 = ptCen + v2*U(1);							
	
								// store the angle for possible second
								dAngleUsWr = v1.angleTo(v2);
								double dAngularOffset = Vector3d(pt[0]-pt[1]).length();
								if (dAngularOffset > bm.dD(vyView))
									dAngularOffset = bm.dD(vyView);
								if (dAngularOffset < U(100))
									dAngularOffset = U(100);	
								ptTxt = (pt1+pt2)/2;
								Vector3d vTxt = ptTxt-ptCen;	vTxt.normalize();
								ptTxt = ptCen+vTxt*dAngularOffset;	 
	
								DimRequestAngular dr(strParentKey , ptCen, pt1, pt2, ptTxt);
								dr.addAllowedView(vzView,TRUE);//vView
								addDimRequest(dr);
							}// end if bOk
						}// end test if plump/perp	
					}// end if option marking
				}
				else if(vyView.isParallelTo(vPrefViewXDim[nSetPreferredViewXDim]))
				{
					ptDim = ptExtreme;
					ptDim.append(ptDimPreferredView);
					if (bReportViews) reportNotice("...preferred view dims");
					for (int p=0;p<ptDim.length();p++)
					{
						DimRequestPoint dr(strParentKey, ptDim[p], vxDimline ,vyDimline);
						dr.setNodeTextCumm("<>");				
						if (Vector3d(ptDim[p]-ptExtreme[0]).length()<dEps)//bJapaneseStyle && 
							dr.setIsChainDimReferencePoint(true);
							
						dr.setStereotype(sStereotype);//"Birdsmouth"	
						dr.addAllowedView(vzDimline, bAlsoReverseDirection);
						addDimRequest(dr);			
					}					
				}// end classic dim
			}// next ptUS								
		}
	// show obholz________________________________________________________________________show obholz_______________________
		if (bShowObholz && vFace.isParallelTo(vzView) && nShowObholz>0)
		{
			if (bReportViews) reportNotice("\nbShowObholz  " + v);
			// preset plump obholz
			Vector3d vObholz = qdr.vecD(vSide);
			Vector3d vViewObholz = qdr.vecD(vyView);
			if (nShowObholz==1)// perpendicular
			{
				vObholz = bm.vecD(vSide);
				vViewObholz = bm.vecD(vyView);
			}
			for (int p=0; p<ptUS.length(); p++)
			{
				// avoid multiple dimlines if display is the same
				if (p>0 && abs(vObholz.dotProduct(ptUS[0]-ptUS[p]))< dEps)
					continue;
					
				Point3d ptDim[0];
				ptDim.append(Line(ptUS[p],vObholz).intersect(Plane(bm.ptCen(),bm.vecD(-vSide)),.5*bm.dD(vSide)));
				ptDim.append(ptUS[p]);
				ptDim.append(Line(ptUS[p],vObholz).intersect(Plane(bm.ptCen(),bm.vecD(vSide)),.5*bm.dD(vSide)));
				
				DimRequestChain dr(strParentKey, vViewObholz , -vViewObholz .crossProduct(vzView), _kDimPar, _kDimNone); 
				dr.setMinimumOffsetFromDimLine(0);					
				dr.setStereotype("Obholz");
				dr.setDeltaOnTop(true);				
				dr.addNode(ptDim[0]);
				dr.addNode(ptDim[1]);
				dr.addNode(ptDim[2]);	

				dr.addAllowedView(vzView, true); 
				addDimRequest(dr);
			}
		}
	// show blind depth_________________________________________________________________________show blind depth_______________________
		if (bShowBlindDepth  && vxTool.isPerpendicularTo(vzView))
		{
			if (bReportViews) reportNotice("\nbShowBlindDepth in view " + v);
			
			DimRequestLinear dr(strParentKey, qdr.pointAt(1,0,0), qdr.pointAt(-1,0,0), vxView); 
			dr.addAllowedView(bm.vecD(vzView), TRUE); //vecView			
		
			dr = DimRequestLinear(strParentKey, qdr.pointAt(1,0,0), qdr.pointAt(-1,0,0), vzTool); 
			dr.addAllowedView(vzView, TRUE); //vecView
			//dr.vis(nDebugColorCounter++); // visualize for debugging 
			
			addDimRequest(dr); // append to shop draw engine collector
		}
		
	// show multiview line________________________________________________________________________show multiview line_______________________
		if (bShowMultiviewLine  )//&& vx.isParallelTo(vzView) && !vxView.isParallelTo(_ZW)
		{	
			if (bReportViews) reportNotice("\nbShowMultiviewLine  in view " + v);
			//show multiviewlines for each ursenkel ptUS
			for (int p=0; p<ptUS.length(); p++)
			{
				Point3d ptMulti =ptUS[p];
				//if (ptHipValley.length()>0 && vSide.isParallelTo(bm.vecD(_ZW)))
				//	ptMulti =Line(ptUS[p],_ZW).intersect(Plane(ptHipValley[0],vSide),0); 
					
				DimRequestMultiViewLine drMulti(strParentKey,ptMulti); 
				drMulti.addToView(vzView,true);
				drMulti.addFromView(bm.vecD(_ZW),true);
				drMulti.addFromView(_ZW,true);
				drMulti.vis(3);
				addDimRequest(drMulti);
			}
		}	
		
	// show displacement________________________________________________________________________show displacement_______________________
		// add verstichma? to top view
		if (bShowDisplacement  && bm.vecD(_ZW).isParallelTo(vSide) && v==0)
		{
			if (bReportViews) reportNotice("\nbShowDisplacement in view " + v);
			//show displacements for each ursenkel ptUS
			for (int p=0; p<ptUS.length(); p++)
			{
				Vector3d vDisplace[0];
				vDisplace.append(-vProj);
				// case hipbirdsmouth/herzkerve: find the projected point on tool y axis
				if(nToolSubtype==15) 
				{
					vDisplace.append(vProj.crossProduct(qdr.vecD(_ZW)));
					// make sure displacement is on correct side
					if (vDisplace[vDisplace.length()-1].dotProduct(qdr.ptOrg()-ptUS[0])<0)
						vDisplace[vDisplace.length()-1] *=-1;
				}
				
				// show displacements
				for (int i=0; i<vDisplace.length(); i++)
				{
					//vDisplace[i].vis(_Pt0,i);
					Point3d pt1 = ptUS[p];
					Point3d pt2 = Line(ptUS[p],vDisplace[i]).intersect(Plane(ptCen,bm.vecD(vDisplace[i])),.5*bm.dD(vDisplace[i]));
					DimRequestLinear dr(strParentKey,pt1,pt2 ,bm.vecD(vDisplace[i]));
					dr.addAllowedView(_ZW, TRUE); 
					dr.vis(2);
					// do not add displacements smaller dEps
					if (abs(qdr.vecD(bm.vecX()).dotProduct(pt1-pt2))>dEps)
						addDimRequest(dr);
				}// next i	
			}// next p
		}	
	// show blind depth_________________________________________________________________________show closed_______________________
		if (bShowClosed && vx.isParallelTo(vzView))
		{
			if (bReportViews) reportNotice("\nbShowClosed in view " + v);
			Point3d pt1 = ptX + vyTool * qdr.dD(vyTool );
			Point3d pt2 = ptX + vzTool * qdr.dD(vzTool );
		pt1.vis(2);
		pt2.vis(2);
			Vector3d vDirChain[0];
			vDirChain.append(vyTool);
			if (vyTool.dotProduct(vyView)>0)
				vDirChain[0] *=-1;
			vDirChain.append(vyTool.crossProduct(-vzView));
			DimRequestChain drChain(strParentKey, vDirChain[0],vDirChain[1],_kDimPar, _kDimPar);
			drChain.addNode(ptX);
			drChain.addNode(pt1);
			drChain.setStereotype("SectionLeft"); 
			drChain.addAllowedView(vzView, TRUE);
			drChain.setMinimumOffsetFromDimLine(0);//-qdr.dD(vDirChain[1])); 

			drChain.vis(8);
			addDimRequest(drChain);	

			vDirChain.swap(0,1);
			DimRequestChain drChain2(strParentKey, vDirChain[0],-vDirChain[1],_kDimPar, _kDimPar);
			drChain2.addNode(ptX);
			drChain2.addNode(pt2);
			drChain2.setStereotype("SectionLeft"); 
			drChain2.addAllowedView(vzView, TRUE);
			drChain2.setMinimumOffsetFromDimLine(-qdr.dD(vDirChain[1])); 
			drChain2.vis(8);
			addDimRequest(drChain2);	

								
		}		
	// hatch a lapJoint
		if (bHatchLap && vyView.isPerpendicularTo(vPrefViewXDim[nSetPreferredViewXDim]) && nHatchLapJoint==1)
		{
			PlaneProfile ppBm = bm.envelopeBody().shadowProfile(Plane(qdr.ptOrg(),vzView));
			Vector3d vxQdr = qdr.vecX()*qdr.dD(qdr.vecX());
			Vector3d vyQdr = qdr.vecY()*qdr.dD(qdr.vecY());
			Vector3d vzQdr = qdr.vecZ()*qdr.dD(qdr.vecZ());
			Body bd(qdr.ptOrg(), vxQdr,vyQdr,vzQdr);
			PlaneProfile ppQdr = bd.shadowProfile(Plane(qdr.ptOrg(),vzView));
			PlaneProfile pp = ppBm;
			pp.subtractProfile(ppQdr);
			ppBm.subtractProfile(pp);
			DimRequestHatch dr(strParentKey, ppBm);
			dr.addAllowedView(vzView, TRUE); 
			addDimRequest(dr);
		}

	// show seat X_________________________________________________________________________show seat X_______________________
		if (nModeSeatLapPoints!=9 && ((bShowSeatHouseXLocation  && nToolSubtype !=11) || 	//&& vzTool.isPerpendicularTo(vzView)
			(bShowSeatHouseXLocation && nToolSubtype==11 && v==0)) &&			
			vyView.isParallelTo(vPrefViewXDim[nSetPreferredViewXDim]))
		{
			if (bReportViews) reportNotice("\nshow seat X to stereotype " +sStereotype+"  in view " + v + " at origin " + ptOrg + " with mode: " + nModeSeatLapPoints);
			Vector3d  vxRef = qdr.vecD(vzView);
			if (vxRef.isParallelTo(vxTool))
				vxRef = vxTool;
			Plane pnRef(bm.ptCen(),bm.vecD(vxRef));


			String sArNodeText[0];
			Point3d pt[0],ptDim[0];
			if (!pnRef.normal().isPerpendicularTo(vzView))
			{
				pt.append(Line(qdr.pointAt(-1,-1,-1),vxRef ).intersect(pnRef,0.5*bm.dD(vxRef)));	
				pt.append(Line(qdr.pointAt(1,1,1),vxRef ).intersect(pnRef,.5*bm.dD(vxRef)));
				pt = Line(_Pt0,vxView).orderPoints(pt);
				String sNodeTxt = T("|Width (abbreviate)|") + " " + qdr.dD(vxView);
				
				if (pt.length()<1); 
			// modeSeatLapPoints;1/4 the last point in dimline direction and (1) the width as an appendix to the dimpoint				
				else if (nModeSeatLapPoints==1 || nModeSeatLapPoints==4)
				{
					ptDim.append(pt[1]);
					if (nModeSeatLapPoints==1)	sArNodeText.append(sNodeTxt);
					
				}
			// modeSeatLapPoints;2/5 the center point and (2) the width as an appendix to the dimpoint	
				else if (nModeSeatLapPoints==2 || nModeSeatLapPoints==5)
				{
					ptDim.append(qdr.pointAt(0,0,0));
					if (nModeSeatLapPoints==2) 	sArNodeText.append(sNodeTxt);
				}
			// modeSeatLapPoints;3/6 the first point in dimline direction and (3) the width as an appendix to the dimpoint	
				else if (nModeSeatLapPoints==3 || nModeSeatLapPoints==6)
				{
					ptDim.append(pt[0]);
					if (nModeSeatLapPoints==3) 	sArNodeText.append(sNodeTxt);
				}
			// modeSeatLapPoints;7/8 the center point (horizontal or rising beams) or the last point in dimline
			// direction (vertical beams) and (7) the width as an appendix to the dimpoint
				else if (nModeSeatLapPoints==7 || nModeSeatLapPoints==8)
				{
					if (nJapaneseOrientation == 2)
						ptDim.append(pt[1]);
					else
						ptDim.append(qdr.pointAt(0,0,0));
						
					if (nModeSeatLapPoints==7) 	sArNodeText.append(sNodeTxt);
				}
			// modeSeatLapPoints;0' two points
				else
				{
					ptDim.append(pt);	
					sArNodeText.setLength(pt.length());
				}
				
				// append the postfix coming from the tooling beam to the node text
				if (sTxtPostFix.length()>0 && sArNodeText.length()>0)	
					sArNodeText[sArNodeText.length()-1] = sTxtPostFix + " " + sArNodeText[sArNodeText.length()-1];		
			}
			
			// reset points for NEDA
			if (bJapaneseStyle && sToolEntName == "HSB_ENEDA")	
				ptDim.setLength(0);
				
			int n=ptDim.length();
			if (ptExtreme.length()<1)
				;
			else if (sStereotype == sStereotypeDefault)
				ptDim.append(ptExtreme);
			else if (nLocationNearStartEnd==-1)// near start
				ptDim.append(ptExtreme[0]);				
			else if (nLocationNearStartEnd==1 && bDimFromStartEndLength) // near end
				ptDim.append(ptExtreme[1]);			
			else
				ptDim.append(ptExtreme);
			
			for (int p=0;p<ptDim.length()-n;p++)sArNodeText.append("");
			
		// make sure seatcuts will always go to side view	if in default mode
			if(nArOrderType.find(nToolSubtype)>-1 && nSetPreferredViewXDim==0)
			{
				vzDimline = vArView[0];
				vyDimline = vxView.crossProduct(vzDimline);
			}
			
			for (int p=0;p<ptDim.length();p++)
			{
				DimRequestPoint dr(strParentKey, ptDim[p], vxDimline ,vyDimline);				
				
				// initialize dimpoints without brackets, test if dim point equals one of the extremes
				{
					Line ln(_Pt0,vxDimline);
					Point3d ptTest[0];
					ptTest = ptExtreme;
					ptTest.append(ptDim[p]);
					ptTest = ln.orderPoints(ptTest, dEps);	
					if (ptExtreme.length()>0 && ptTest.length()>ptExtreme.length())
						dr.setNodeTextCumm("<>");
				}
				
				
				

				
				if (sArNodeText.length()>p && sArNodeText[p]!="" && !bJapaneseStyle)
					dr.setNodeTextCumm("<>" + ": " + sArNodeText[p]);
				if (sArNodeText.length()>p && sArNodeText[p]!="" && bJapaneseStyle)
				{
					int nSwapSides=1;
					String sStereotypeInfo = "LeftInfo";
					if (sStereotype=="RightStart")
					{
						nSwapSides*=-1;
						sStereotypeInfo = "RightInfo";
					}
					if (bReportViews)reportNotice("\n   Postfix send to "+sStereotypeInfo );
					DimRequestPoint drInfo(strParentKey , ptDim[p], vxDimline, -vzDimline*nSwapSides);//nSwapSide*vyView
					drInfo.setStereotype(sStereotypeInfo );//
					drInfo.setNodeTextCumm(sArNodeText[p]);	
					drInfo.addAllowedView(vyDimline,bAlsoReverseDirection);//bAlsoReverseDirection);
					addDimRequest(drInfo);

					DimRequestPoint drInfo2(strParentKey , ptDim[p]+vxBm*U(.1), vxDimline, -vzDimline*nSwapSides);//nSwapSide*vyView
					drInfo2.setStereotype(sStereotypeInfo);//
					drInfo2.setNodeTextCumm(" ");	
					drInfo2.addAllowedView(vyDimline,bAlsoReverseDirection);//bAlsoReverseDirection);+
					addDimRequest(drInfo2);	
					
					dr.setNodeTextCumm("<>");						
				}
		// Version 4.7: depreciated due to initial test
		//		else if (p==0)
		//			dr.setNodeTextCumm("");	
		//		else
		//			dr.setNodeTextCumm("<>");				
				if (bJapaneseStyle && Vector3d(ptDim[p]-ptExtreme[0]).length()<dEps)
					dr.setIsChainDimReferencePoint(true);
					
				dr.setStereotype(sStereotype);//"Birdsmouth"	
				dr.addAllowedView(vzDimline, bAlsoReverseDirection);
				addDimRequest(dr);			
			}
				
		}			
	// show house offset_______________________________________________________________________show house offsset______________________
		if (bShowSimpleHouse && vyTool.isPerpendicularTo(vzView))
		{
			if (bReportViews) reportNotice("\nshow house offset in view " + v +" at origin " + ptOrg);			

			Line ln(qdr.pointAt(-1,-1,-1),qdr.vecD(vyView));
			Point3d ptDim[0];
			ptDim.append(qdr.pointAt(1,1,1));
			ptDim.append(qdr.pointAt(-1,-1,-1));
			ptDim.append(ln.intersect(Plane(bm.ptCen(),bm.vecD(vyTool)),.5*bm.dD(vyTool)));
			ptDim.append(ln.intersect(Plane(bm.ptCen(),bm.vecD(vyTool)),-.5*bm.dD(vyTool)));
			DimRequestChain drChain(strParentKey, vyTool, -vyTool.crossProduct(vzView), _kDimPar, _kDimNone); 
			for(int p=0;p<ptDim.length();p++)
			{
				drChain.addNode(ptDim[p]);
				//ptDim[p].vis(3);
			}
			//drChain.addNode(bm.ptCen()+.5*bm.vecD(vyTool)*bm.dD(vyTool));
			drChain.addAllowedView(vzView, TRUE); 
			//drChain.vis(nDebugColorCounter++); // visualize for debugging 
			if (mapOption.hasString("StereotypeDepthHouse"))
				drChain.setStereotype(mapOption.getString("StereotypeDepthHouse"));
			else
				drChain.setStereotype("SectionLeft");
			drChain.setMinimumOffsetFromDimLine(0);	
			addDimRequest(drChain);								
		}
	
	// show seat or housing depth_________________________________________________ seat or housing depth_____
		// create the dimrequest only if it is first in the list of tools to avoid double chain placement
		if (nShowSeatDepth<4 && vzTool.isPerpendicularTo(vzView) &&
			abcOrdered.length()>0 &&
			Vector3d(abcOrdered[0].ptOrg()-beamcut.ptOrg()).length()<dEps && 
			vzTool.isCodirectionalTo(abcOrdered[0].coordSys().vecZ())&&
			qdr.vecD(vyView).isParallelTo(vyView))// added 4.8	
		{
			Point3d ptDim[0];
			// identify placement side of tool dim
			int nToolDimSide = 1;// -1 = left, 1 = right
			if (vxView.dotProduct(ptOrg-ptCen)<0)
				nToolDimSide *= -1;			
			
			Vector3d vxDimline, vyDimline,vzDimline;
			vyDimline = vxView * nToolDimSide;
			vxDimline = vyDimline.crossProduct(vzView);
			vzDimline = vzView;

			if (bReportViews) reportNotice("\nshow seat or housing depth in view " + v +" at origin " + ptOrg);
			DimRequestChain drChain(strParentKey, vxDimline, vyDimline, _kDimPar, _kDimNone);
			
			Line ln(qdr.pointAt(0,0,0)-vyDimline*qdr.dD(vyDimline),vyView); 
		// append all abc's
			Point3d pt;
			for(int i=0;i<abcOrdered.length();i++)
			{
				pt = ln.closestPointTo(abcOrdered[i].quader().pointAt(0,0,-1));
				drChain.addNode(pt);
				ptDim.append(pt);			
				pt = ln.closestPointTo(abcOrdered[i].quader().pointAt(0,0,1));
				drChain.addNode(pt);
				ptDim.append(pt);	
				pt.vis(3);				
			}	
			// append also opposite edge dimpoint
			if (nShowSeatDepth<2)
			{
				pt = ln.closestPointTo(bm.ptCen()-.5*vzTool*bm.dD(vzTool));	
				drChain.addNode(pt);
				ptDim.append(pt);
				pt.vis(3);
			}	
			drChain.addAllowedView(vzView, TRUE); 
			//drChain.vis(nDebugColorCounter++); // visualize for debugging 
			if (mapOption.hasString("StereotypeDepthHouse"))
				drChain.setStereotype(mapOption.getString("StereotypeDepthHouse"));
			else
				drChain.setStereotype("SectionLeft");
			drChain.setMinimumOffsetFromDimLine(0);	
			
			if (nHasHipValley<1 &&
				!vxBm.isParallelTo(vzTool) && !(vxTool.isParallelTo(vyView) || vyTool.isParallelTo(vyView)))
			{
				if (nShowSeatDepth == 1 || nShowSeatDepth == 3)
					addDimRequest(drChain);
				else if (nShowSeatDepth == 0 || nShowSeatDepth == 2)
					for (int p = 0; p < ptDim.length();p++)
					{
						DimRequestPoint dr(strParentKey , ptDim[p], vxDimline, vyDimline);
						dr.setStereotype("SectionLeft");//
						dr.setNodeTextCumm("<>");	
						dr.addAllowedView(vzView, TRUE); //vecView
					//	dr.vis(nDebugColorCounter++); // visualize for debugging 		
						addDimRequest(dr); // append to shop draw engine collector		
					}					
			}	
		}

	// show bShowWidthHead_____________________________________________________ show bShowWidthHead____
		if(bShowWidthHead && bm.vecD(vyTool).isParallelTo(vyView))
		{
reportNotice("\nbShowWidthHead ");			
			vxDimline = vyView;
			vyDimline = vxBm;
			if (vxBm.dotProduct(ptOrg-ptCen)<0) vyDimline*=-1;
			
			double dWH = bm.solidWidth();
			if (bm.vecD(vyView).isParallelTo(bm.vecZ()))
				dWH = bm.solidHeight();
			
			Point3d ptDim[0];
			ptDim.append(qdr.pointAt(1,1,1));
			ptDim.append(qdr.pointAt(-1,-1,-1));		
			ptDim.append(ptCen-.5*bm.vecD(vyView)*dWH);
			ptDim.append(ptCen+.5*bm.vecD(vyView)*dWH);
		
			for (int p = 0; p < ptDim.length();p++)
			{
				DimRequestPoint dr(strParentKey , ptDim[p], vxDimline, vyDimline);
				dr.setStereotype("SectionLeft");//
				dr.setNodeTextCumm("<>");	
				dr.addAllowedView(vzView, TRUE); //vecView
				dr.vis(nDebugColorCounter++); // visualize for debugging 		
				addDimRequest(dr); // append to shop draw engine collector		
			}
			
			vxDimline = vxView;
			vyDimline = vyView;
		// find the vertices of the bc with the realbody
			// this is implemented for an L-shaped beam , but should alos work for any other shape
			Point3d ptAllVertices[] = bm.realBody().allVertices();
			double dX, dY, dZ;
			dX = qdr.dD(qdr.vecX())/2;
			dY = qdr.dD(qdr.vecY())/2;
			dZ = qdr.dD(qdr.vecZ())/2;						

			for (int p = 0; p < ptAllVertices.length();p++)			
			{
				double dXFlag = qdr.vecX().dotProduct(ptAllVertices[p]-qdr.ptOrg())/dX;
				double dYFlag = qdr.vecY().dotProduct(ptAllVertices[p]-qdr.ptOrg())/dY;
				double dZFlag = qdr.vecZ().dotProduct(ptAllVertices[p]-qdr.ptOrg())/dZ;
				
				if (abs(dXFlag)-dEps<1 && abs(dYFlag)-dEps<1 && abs(dZFlag)-dEps<1)
				{
					//ptDim.append(ptAllVertices[p]);
					DimRequestPoint dr(strParentKey , ptAllVertices[p], vxDimline, vyDimline);
					dr.setStereotype(sStereotype);//
					dr.setNodeTextCumm("<>");	
					dr.addAllowedView(vzView, TRUE); //vecView
					dr.vis(nDebugColorCounter++); // visualize for debugging 		
					addDimRequest(dr); // append to shop draw engine collector						
				}
			}
			
			
		}

		
	// show angle XY_____________________________________________________ show angle XY_____
		// create the dimrequest only if it is first in the list of tools to avoid double chain placement
		if (bShowXYAngle&& vzTool.isParallelTo(vzView) &&
			abcOrdered.length()>0 &&
			Vector3d(abcOrdered[0].ptOrg()-beamcut.ptOrg()).length()<dEps && 
			vzTool.isCodirectionalTo(abcOrdered[0].coordSys().vecZ()))
		{
			if (bReportViews) reportNotice("\nshow angle XY in view " + v +" at origin " + ptOrg);
			Point3d ptCen, pt1,pt2, ptTxt;
			Vector3d  vxRef = qdr.vecD(vyView);
			if (vxRef.isParallelTo(vxTool))
				vxRef = vxTool;
			Plane pnRef(bm.ptCen(),bm.vecD(vxRef));
							
			// set minimal angular offset
			double dAngularOffset =.5*bm.dD(vxRef);
			if (dAngularOffset <U(100))
				dAngularOffset =U(100);
			
			ptCen = Line(qdr.pointAt(-1,-1,-1),vxRef ).intersect(pnRef,0.5*bm.dD(vyTool));
			pt1 = ptCen - vxRef*U(1);		//pt1.vis(1);	
			pt2 = ptCen + vxView*U(1);		//pt2.vis(2);	
			double dAngle = vxRef.angleTo(vxView);

			ptTxt = (pt1+pt2)/2;
			Vector3d vTxt = ptTxt-ptCen;	vTxt.normalize();
			ptTxt = ptCen+vTxt*dAngularOffset;	 
			
			if (dAngle!=90)
			{
				DimRequestAngular dr(strParentKey , ptCen, pt1, pt2, ptTxt);
				dr.addAllowedView(vzView,TRUE);//vView
				addDimRequest(dr);
			}
		}	
		nSwapSide =-1;
	}// next v viewing dir


// show type on debug
	if (_bOnDebug)
	{
		Display dp(1);
		dp.draw("No:" + nToolSubtype + " " + sToolSubtype, _Pt0,_XW,_YW,0,0,_kDeviceX);	
		
	}









































#End
#BeginThumbnail
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
FZ7M7>J/UDFF]:!G\;?RWL_\/`R=S\U?907D`````245.1*Y"8((`
`















#End
