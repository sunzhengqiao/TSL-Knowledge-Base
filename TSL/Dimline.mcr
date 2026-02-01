#Version 8
#BeginDescription
#Versions
Version 10.6 28.10.2025 HSB-24316 bugfix accepting default stereotype wildcard '*'
Version 10.5 18.06.2025 HSB-24186 blockspace detection improved
Version 10.4 10.06.2025 HSB-24114 performance improved working with metalpart painters, preview improved, new options to match visuals on insert
Version 10.3 06.06.2025 HSB-24123 page transformation bugfix
Version 10.2 05.06.2025 HSB-24080 viewport: dimpoints outside viewport are ignored
Version 10.1 03.06.2025 HSB-24123 custom grid can be dimensioned within paperspace, requires custom setting
Version 10.0 03.06.2025 HSB-23985 bugfix basepoint on insert and door window combination

Version 9.9 27.04.2025 HSB-23736 point selection during insert supports ortho mode
Version 9.8 07.04.2025 HSB-23737 bugfix extension line not showing
Version 9.7 19.02.2025 HSB-23539 catching hidden element geometry
Version 9.6 19.02.2025 HSB-23539 opening and element dimensioning in modelspace enhanced
Version 9.5 17.02.2025 HSB-23539 opening added for modelspace dimensions
Version 9.4 04.02.2025 HSB-23457 accepting Node[] and ProfShape requests of tsls
Version 9.3 21.01.2025 HSB-23162 Z-Elevation blockspace and model fixed
Version 9.2 10.01.2025 HSB-23162 collection of tsl driven dimrequests prepared
Version 9.1 10.01.2025 HSB-22867 offset dimensions made independent from base point location
Version 9.0 08.01.2025 HSB-21565 supporting individual coloring if dimstyle is set to byBlock
Version 8.9 07.01.2025 HSB-21565 new context command to realign dimlines, supporting MultipageController
Version 8.8 04.12.2024 HSB-23104 initial placement of assembled items improved if painters filter content of associated metalparts
Version 8.7 02.12.2024 HSB-23095 accepting polylines nested in sections of xRefs intersecting the section plane
Version 8.6 02.12.2024 HSB-23092 accepting metalparts of xref drawings
Version 8.5 18.10.2024 HSB-22669 openings considered when merging multiple profiles
Version 8.4 16.10.2024 HSB-22817 format supports over-/undersail definition for offset dimensions (ie Oversail <>) 

Version 8.3 23.07.2024 HSB-21731 new mode 'Dimension Offset' available in paperspace of hsbcad viewports
Version 8.2 15.07.2024 HSB-21966 bugfix
Version 8.1 11.07.2024 HSB-21966 supports static drills and beamcuts
Version 8.0 06.06.2024 HSB-22206 bugfix storing selected vieport of shopdrawings
Version 7.9 16.02.2024 HSB-21437 Metalpart Painter Filtering improved
Version 7.8 15.02.2024 HSB-21437 Metalparts and CurvedBeam improved
Version 7.7 08.02.2024 HSB-21361 Rabbetss and Dados added as tools
Version 7.6 26.01.2024 HSB-21223 catching tolerances on sheeting drills
Version 7.5 19.01.2024 HSB-21155 resolving references by painters on assemblies
Version 7.4 19.01.2024 HSB-21155 beamcuts improved
Version 7.3 19.01.2024 HSB-21155 new custom context command for global settings, new global setting to suppress group assignment
Version 7.2 19.01.2024 HSB-21155 bugfix causing file size
Version 7.1 18.01.2024 HSB-21155 beveled drills,improved, mortise with explicit radius gets crossmarks, slots enhanced
Version 7.0 22.12.2023 HSB-20292 all kinds of collection entities are supported (TrussEntity, MetalPartCollectionEntiy and CollectionEntity) 
Version 6.9 08.12.2023 HSB-20877 dimpoint collection and filtering of nested genbeams of metalparts enhanced
Version 6.8 07.12.2023 HSB-20687, 20853, 20855, 20861 bugfix
Version 6.7 07.12.2023 HSB-20687, 20853, 20855, 20861 dimline now supports the definition of individual tools based on the parent tool entity asnd/or of a custom set of tools specified by the subtype
Version 6.6 01.12.2023 HSB-20197 gable dimensions accepting tolerances of sheetings, setup graphics only visible if no dimensions drawn
Version 6.5 30.11.2023 HSB-20564 bugfix püurge dimlines
Version 6.4 29.11.2023 HSB-20564 performance improved especially when linked to a paperspace viewport, paperspace setup graphics drawn on non plotable T-Layer
Version 6.3 13.11.2023 HSB-20550 remote purging of redundant dimlines supported
Version 6.2 27.10.2023 HSB-19354 individual grip based dimensions of openings supported for paperspace dimensions
Version 6.1 14.09.2023 HSB-20005 shape mode and reference point modes further restriced when using diagonal or gable dimension
Version 6.0 13.09.2023 HSB-20045 Requires hsbDesign 26 or higher
   - accepts multiple blockreferences
   - metalpart entities, resolves marker lines if selected via stereotype
   - resolves stereotype requests of blockreferences and metalpart entities
Version 5.2 12.09.2023 HSB-20043 new command to alter options of painter filtering
Version 5.1 12.09.2023 HSB-20038 model support genbeams enhanced, shape modes renamed, classic dim added
Version 5.0 11.09.2023 HSB-20005 shape mode restriced to basic shape when using diagonal or gable dimension modes. Diagonal mode enhanced
Version 4.9 08.09.2023 HSB-20005 element viewports support multiple aligned dimlines (i.e. on gable walls)
Version 4.8 07.09.2023 HSB-19355 new property 'Dimension Point Mode' enables filtering of corresponding dimension points, basic automatic creation of element painter definitions added
Version 4.7 06.09.2023 HSB-19354 opening support added
Version 4.6 09.08.2023 HSB-19788 reference point will refer to outmost point
Version 4.5 09.08.2023 HSB-19788 new context command in hsbcad viewport mode to set the reference location

Version 4.4 26.06.2023 HSB-19358 accepting element painter definitions as reference in conjunction with other dim painters
Version 4.3 12.05.2023 HSB-18832 dimstyles which are associated to non linear dimensions are not shown anymore
Version 4.2 08.05.2023 HSB-18920 new property 'ScaleFactor' supports scaling to other units
Version 4.1 08.05.2023 HSB-18893 bugfix on insert diagonal dimension
Version 4.0 05.05.2023 HSB-18893 new option for diagonal control dimensions
Version 3.9 28.02.2023 HSB-18008 new command to purge redundant dimlines associated to a multipage
Version 3.8 27.02.2023 HSB- 18146 purging improved if multipage invalidates
Version 3.7 16.02.2023 HSB-16730 segmented contours will try to reconstruct into arc segments
Version 3.6 13.02.2023 HSB-17432 supports dimension requests which based on element tsls
Version 3.5 09.02.2023 HSB-17752 compatable with hsbDesign 25
Version 3.4 08.02.2023 HSB-17752 new option to copy a dimline, tool options enhanced
Version 3.3 07.02.2023 HSB-17752 new options to dimension drills


This tsl creates a dimline in dependency of the selected defining entities in modelspace or paperspace

























































































#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 10
#MinorVersion 6
#KeyWords 
#BeginContents

//region Part #0 History, Constants

//region History
// #Versions
// 10.6 28.10.2025 HSB-24316 bugfix accepting default stereotype wildcard '*' , Author Thorsten Huck
// 10.5 18.06.2025 HSB-24186 blockspace detection improved , Author Thorsten Huck
// 10.4 10.06.2025 HSB-24114 performance improved working with metalpart painters, preview improved, new options to match visuals on insert , Author Thorsten Huck
// 10.3 06.06.2025 HSB-24123 page transformation bugfix , Author Thorsten Huck
// 10.2 05.06.2025 HSB-24080 viewport: dimpoints outside viewport are ignored , Author Thorsten Huck
// 10.1 03.06.2025 HSB-24123 custom grid can be dimensioned within paperspace, requires custom setting , Author Thorsten Huck
// 10.0 03.06.2025 HSB-23985 bugfix basepoint on insert and door window combination , Author Thorsten Huck
// 9.9 27.04.2025 HSB-23736 point selection during insert supports ortho mode , Author Thorsten Huck
// 9.8 07.04.2025 HSB-23737 bugfix extension line not showing , Author Thorsten Huck
// 9.7 19.02.2025 HSB-23539 catching hidden element geometry , Author Thorsten Huck
// 9.6 19.02.2025 HSB-23539 opening and element dimensioning in modelspace enhanced , Author Thorsten Huck
// 9.5 17.02.2025 HSB-23539 opening added for modelspace dimensions , Author Thorsten Huck
// 9.4 04.02.2025 HSB-23457 accepting Node[] and ProfShape requests of tsls , Author Thorsten Huck
// 9.3 21.01.2025 HSB-23162 Z-Elevation blockspace and model fixed , Author Thorsten Huck
// 9.2 10.01.2025 HSB-23162 collection of tsl driven dimrequests prepared , Author Thorsten Huck
// 9.1 10.01.2025 HSB-22867 offset dimensions made independent from base point location , Author Thorsten Huck
// 9.0 08.01.2025 HSB-21565 supporting individual coloring if dimstyle is set to byBlock , Author Thorsten Huck
// 8.9 07.01.2025 HSB-21565 new context command to realign dimlines, supporting MultipageController , Author Thorsten Huck
// 8.8 04.12.2024 HSB-23104 initial placement of assembled items improved if painters filter content of associated metalparts , Author Thorsten Huck
// 8.7 02.12.2024 HSB-23095 accepting polylines nested in sections of xRefs intersecting the section plane , Author Thorsten Huck
// 8.6 02.12.2024 HSB-23092 accepting metalparts of xref drawings , Author Thorsten Huck
// 8.5 18.10.2024 HSB-22669 openings considered when merging multiple profiles , Author Thorsten Huck
// 8.4 16.10.2024 HSB-22817 format supports over-/undersail definition for offset dimensions (ie Oversail <>) , Author Thorsten Huck
// 8.3 23.07.2024 HSB-21731 new mode 'Dimension Offset' available in paperspace of hsbcad viewports , Author Thorsten Huck
// 8.2 15.07.2024 HSB-21966 bugfix , Author Thorsten Huck
// 8.1 11.07.2024 HSB-21966 supports static drills and beamcuts , Author Thorsten Huck
// 8.0 06.06.2024 HSB-22206 bugfix storing selected vieport of shopdrawings , Author Thorsten Huck
// 7.9 16.02.2024 HSB-21437 Metalpart Painter Filtering improved , Author Thorsten Huck
// 7.8 15.02.2024 HSB-21437 Metalparts and CurvedBeam improved , Author Thorsten Huck
// 7.7 08.02.2024 HSB-21361 Rabbetss and Dados added as tools , Author Thorsten Huck
// 7.6 26.01.2024 HSB-21223 catching tolerances on sheeting drills , Author Thorsten Huck
// 7.5 19.01.2024 HSB-21155 resolving references by painters on assemblies , Author Thorsten Huck
// 7.4 19.01.2024 HSB-21155 beamcuts improved , Author Thorsten Huck
// 7.3 19.01.2024 HSB-21155 new custom context command for global settings, new global setting to suppress group assignment , Author Thorsten Huck
// 7.2 19.01.2024 HSB-21155 bugfix causing file size , Author Thorsten Huck
// 7.1 18.01.2024 HSB-21155 beveled drills,improved, mortise with explicit radius gets crossmarks, slots enhanced , Author Thorsten Huck
// 7.0 22.12.2023 HSB-20292 all kinds of collection entities are supported (TrussEntity, MetalPartCollectionEntiy and CollectionEntity) , Author Thorsten Huck
// 6.9 08.12.2023 HSB-20877 dimpoint collection and filtering of nested genbeams of metalparts enhanced , Author Thorsten Huck
// 6.8 07.12.2023 HSB-20687, 20853, 20855, 20861 bugfix , Author Thorsten Huck
// 6.7 07.12.2023 HSB-20687, 20853, 20855, 20861 dimline now supports the definition of individual tools based on the parent tool entity asnd/or of a custom set of tools specified by the subtype , Author Thorsten Huck
// 6.6 01.12.2023 HSB-20197 gable dimensions accepting tolerances of sheetings, setup graphics only visible if no dimensions drawn , Author Thorsten Huck
// 6.5 30.11.2023 HSB-20564 bugfix püurge dimlines , Author Thorsten Huck
// 6.4 29.11.2023 HSB-20564 performance improved especially when linked to a paperspace viewport, paperspace setup graphics drawn on non plotable T-Layer , Author Thorsten Huck
// 6.3 13.11.2023 HSB-20550 remote purging of redundant dimlines supported , Author Thorsten Huck
// 6.2 27.10.2023 HSB-19354 individual grip based dimensions of openings supported for paperspace dimensions , Author Thorsten Huck
// 6.1 14.09.2023 HSB-20005 shape mode and reference point modes further restriced when using diagonal or gable dimension , Author Thorsten Huck
// 6.0 13.09.2023 HSB-20045 Requires hsbDesign 26 or higher, accepts multiple blockreferences, metalpart entities, resolves marker lines if selected via stereotype, resolves stereotype requests of blockreferences and metalpart entities , Author Thorsten Huck
// 5.2 12.09.2023 HSB-20043 new command to alter options of painter filtering , Author Thorsten Huck
// 5.1 12.09.2023 HSB-20038 model support genbeams enhanced, shape modes renamed, classic dim added , Author Thorsten Huck
// 5.0 11.09.2023 HSB-20005 shape mode restriced to basic shape when using diagonal or gable dimension modes. Diagonal mode enhanced , Author Thorsten Huck
// 4.9 08.09.2023 HSB-20005 element viewports support multiple aligned dimlines (i.e. on gable walls) , Author Thorsten Huck
// 4.8 07.09.2023 HSB-19355 new property 'Dimension Point Mode' enables filtering of corresponding dimension points, basic automatic creation of element painter definitions added , Author Thorsten Huck
// 4.7 07.09.2023 HSB-19354 opening support added , Author Thorsten Huck
// 4.6 09.08.2023 HSB-19788 reference point will refer to outmost point , Author Thorsten Huck
// 4.5 09.08.2023 HSB-19788 new context command in hsbcad viewport mode to set the reference location , Author Thorsten Huck
// 4.4 26.06.2023 HSB-19358 accepting element painter definitions as reference in conjunction with other dim painters , Author Thorsten Huck
// 4.3 12.05.2023 HSB-18832 dimstyles which are associated to non linear dimensions are not shown anymore , Author Thorsten Huck
// 4.2 08.05.2023 HSB-18920 new property 'Scaisdiagonal dimension , Author Thorsten Huck
// 4.0 05.05.2023 HSB-18893 new option for diagonal control dimensions , Author Thorsten Huck
// 3.9 28.02.2023 HSB-18008 new command to purge redundant dimlines associated to a multipage , Author Thorsten Huck
// 3.8 27.02.2023 HSB-18146 purging improved if multipage invalidates , Author Thorsten Huck
// 3.7 16.02.2023 HSB-16730 segmented contours will try to reconstruct into arc segments , Author Thorsten Huck
// 3.6 13.02.2023 HSB-17432 supports dimension requests which based on element tsls , Author Thorsten Huck
// 3.5 09.02.2023 HSB-17752 compatable with hsbDesign 25 , Author Thorsten Huck
// 3.4 08.02.2023 HSB-17752 new option to copy a dimline, tool options enhanced , Author Thorsten Huck
// 3.3 07.02.2023 HSB-17752 new options to dimension drills , Author Thorsten Huck
// 3.2 18.01.2023 HSB-17586 bugfix non request tsls , Author Thorsten Huck
// 3.1 18.01.2023 HSB-17586 new property to specify individual requests, new context commands to add or remove entries , Author Thorsten Huck
// 3.0 17.01.2023 HSB-16519 consumes linear dimrequests if defined within linked tsls of genbeams , Author Thorsten Huck
// 2.9 17.01.2023 HSB-15142 improving shadow contour of collection entities , Author Thorsten Huck
// 2.8 10.01.2023 HSB-17320 tsl instances of sections improved , Author Thorsten Huck
// 2.7 12.12.2022 HSB-17297 supports dimline alignment for auto scaled viewports , Author Thorsten Huck
// 2.6 25.11.2022 HSB-17175 assigning of element zone set by defining entity , Author Thorsten Huck
// 2.5 23.11.2022 HSB-17184 supports sections , Author Thorsten Huck
// 2.4 21.10.2022 HtB-16291 uniform preview improved , Author Thorsten Huck
// 2.3 20.10.2022 HSB-16291 uniform preview added , Author Thorsten Huck
// 2.2 17.10.2022 HSB-15772 ACA viewport dependencies improved , Author Thorsten Huck
// 2.1 06.10.2022 HSB-15850 bugfixes for metalpart collection entities , Author Thorsten Huck
// 2.0 15.09.2022 HSB-16507 supports element viewports, new mode 'envelope shape' uses outer contour based specified filter , Author Thorsten Huck
// 1.9 05.09.2022 HSB-16430 multiple genbeams of elementsho improved , Author Thorsten Huck
// 1.8 10.08.2022 HSB-14692 relative location to multipage stored , Author Thorsten Huck
// 1.7 15.03.2022 HSB-14692 selected element excluded from dimension when used as assignment in pick point mode , Author Thorsten Huck
// 1.6 14.03.2022 HSB-14692 group assignment extended when in point mode, user may select any entity as group reference without this being added to the dimension , Author Thorsten Huck
// 1.5 11.03.2022 HSB-14692 element assignment fixed when in point mode , Author Thorsten Huck
// 1.4 10.03.2022 HSB-14692 provides point mode on insert and exports to share and make , Author Thorsten Huck
// 1.3 16.12.2021 HSB-12398 accepting any painter definition if collection 'Dimension' is not found , Author Thorsten Huck
// 1.2 06.08.2021 CMP-32 metalpart collection support added (beta) , Author Thorsten Huck
// 1.1 05.08.2021 HSB-7777 first implementation of some tools (Cut, Slot, Beamcut) added , Author Thorsten Huck
// 1.0 04.08.2021 HSB-7777 initial version , Author Thorsten Huck

/// <insert Lang=en>
/// Select entities in modelspace or viewports in paperspace
/// </insert>

// <summary Lang=en>
// This tsl creates a dimline in dependency of the selected defining entities in modelspace or paperspace
// You can dimension beams, sheets, panels, sips, polylines and any entity which carries a polyline definition (circles, roofplanes etc)
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "Dimline")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Addgreenove Points|") (_TM "|Select dimline|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Entities|") (_TM "|Select dimline|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Remove Entities|") (_TM "|Select dimline|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Set Fixed Location|") (_TM "|Select dimline|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Rotate 90°|") (_TM "|Select dimline|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Swap Delta/Chain|") (_TM "|Select dimline|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add TSL/Stereotype Entry|") (_TM "|Select dimline|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Remove TSL/Stereotype Entry|") (_TM "|Select dimline|"))) TSLCONTENT
//endregion

//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;

	String sDefaultEntry =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};

	String sDisabled = T("<|Disabled|>");
	String sDefault = T("<|Default|>");
	int bDeltaOnTop = _Map.getInt("deltaOnTop");

	String sDialogLibrary = _kPathHsbInstall + "\\Utilities\\DialogService\\TslUtilities.dll";
	String sClass = "TslUtilities.TslDialogService";	
	String listSelectorMethod = "SelectFromList";
	String optionsMethod = "SelectOption";
	String simpleTextMethod = "GetText";
	String askYesNoMethod = "AskYesNo";
	String showNoticeMethod = "ShowNotice";
	String showMultilineNotice = "ShowMultilineNotice";	

//region Color and view	
	//int bIsDark;{int n = getBackgroundTrueColor();bIsDark = ((rgbR(n) + rgbB(n) + rgbG(n)) / 3 < 127);}
//	int grey = bIsDark?rgb(199,200,202):rgb(99,100,102);
//	int white = bIsDark?rgb(255,255,255):rgb(0,0,0);	
	int white = rgb(255,255,254);
	
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
	int brown = rgb(153, 77, 0);

	Vector3d vecXView = getViewDirection(0);
	Vector3d vecYView = getViewDirection(1);
	Vector3d vecZView = getViewDirection(2);
	double dViewHeight = getViewHeight();	//endregion 	

	int rgbToolColors[] = { red, blue, yellow, green, orange, purple};

	
	String kBlockSpaceMode = "isBlockSpaceMode", kJigSelectSegment = "SelectSegmentJig", kDimlineJig = "DimlineJig",
	tExtremePoint =T("|Extreme Points|"), tEnvelopeShape = T("|Low Detail|"),tRealShape=T("|High Detail|"),tBasicShape=T("|Medium Detail|"),
	tPMNone = T("|None|"), tPMFirstPoint = T("|First Point|"), tPMLastPoint = T("|Last Point|"), tPMExtremePoint = T("|Extreme Points|"), tPMClosestPoint = T("|Closest Point|");

	String tDisabled = T("<|Disabled|>"),tDefaultEntry = T("<|Default|>"), tNoGroupAssignment =T("|No group assigment|");
	String kBaselineOffset= "BaselineOffset", kIsLocal = "IsLocal",kVecSide = "vecSide", kDeltaOnTop = "deltaOnTop",
		kDimInfo = "Hsb_DimensionInfo", kRequests = "DimRequest[]", kAllowedView = "AllowedView",kCoords = "ptCoord[]", kNodes="Node[]",  kAlsoReverseDirection = "AlsoReverseDirection",
		kDimLineDir = "vecDimLineDir", kDimLinePerp = "vecPerpDimLineDir";
	
	
	
	String kAllowCrossMark = "AllowCrossMark";
	String sGroupings[] = { tDefaultEntry, tNoGroupAssignment};
	
	String sListExcludes[] ={ scriptName(), "DimAngular", "hsbCLT-MasterPanelManager", "_hsbReport", "ErectionSequence", 
			"hsbSolid2PanelConversion", "hsbTranslatedText", "hsbEntityTag", "hsb-OpeningHeightDimensionAuto", "hsbBOM", "hsbGrainDirection"};//TODO to be extended		
	
	
	String sVSDrills[] = { T("|Any view|"), T("|Perpendicular to View Direction|"), T("|Parallel to View Direction|")};
	int nVSSheet, nVSBeam, nVSPanel, nVSCollectionEtity=2;//defaults	
		
	
// ref locations options
	String tRefLocFixed = T("|Fixed Location|"), tRefLocDim = T("|Relative to Dimension Entities|"), tRefLocExtreme = T("|Relative to Extremes|"), kRefLocMode = "RefLocMode";
	
	int nRefLocMode = _Map.getInt(kRefLocMode);
	String kViewportGrip = "ViewportGrip[]", kGripBaseName = "BaseGrip";

//region Tool Types
	// both arrays need to be in synch as translated list will be presented to the user, but subTypes will be stored
	String sToolTypes[] ={ _kADPerpendicular, _kADRotated, _kADTilted, _kADHead, _kAD5Axis,									// Drill
	_kACPerpendicular,_kACHip,  _kACSimpleAngled, _kACSimpleBeveled, _kACCompound,											// Cut
	_kAMPerpendicular, _kAMRotated, _kAMTilted, _kAM5Axis, _kAMHeadPerpendicular,											// Mortise 
	_kAMHeadSimpleAngled, _kAMHeadSimpleAngledTwisted, _kAMHeadSimpleBeveled, _kAMHeadCompound,  _kAMTenonPerpendicular,	// Mortise 
	_kAMTenonSimpleAngled, _kAMTenonSimpleAngledTwisted, _kAMTenonSimpleBeveled, _kAMTenonCompound,							// Mortise 
	_kAChExposed,_kAChOthersExposed,																						// Chamfer 
	_kASlPerpendicular, _kASlRotated, _kASlTilted, _kASl5Axis,																// Slot
	_kABCSeatCut, _kABCRisingSeatCut, _kABCOpenSeatCut, _kABCLapJoint, _kABCBirdsmouth,
	_kABCReversedBirdsmouth, _kABCClosedBirdsmouth, _kABCDiagonalSeatCut, _kABCOpenDiagonalSeatCut, _kABCBlindBirdsmouth,
	_kABCHousing, _kABCHousingThroughout, _kABCHouseRotated, _kABCHouseTilted, _kABCJapaneseHipCut,
	_kABCHipBirdsmouth, _kABCValleyBirdsmouth, _kABCRisingBirdsmouth, _kABCHoused5Axis, _kABCSimpleHousing,
	_kABCRabbet, _kABCDado, _kABC5Axis, _kABC5AxisBirdsmouth, _kABC5AxisBlindBirdsmouth,									// Beamcut
	_kARPerpendicular, _kAR5Axis};																							// Rabbet/Dado
	
	String sToolTypesT[] ={ T("|Drill, perpendicular|"), T("|Drill, rotated|"), T("|Drill, tilted|"), T("|Drill, head side|"), T("|Drill, 5-Axis|"), 
	T("|Cut, perpendicular|"),T("|Cut, Hip|"),  T("|Cut, angled|"),  T("|Cut, beveled|"),  T("|Cut, compound|"),											// Cut
	T("|Mortise, perpendicular|"), T("|Mortise, rotated|"), T("|Mortise, tilted|"), T("|Mortise, 5-Axis|"), T("|Mortise, perpendicular beam end|"),											// Mortise 
	T("|Mortise, beam end simple angled|"), T("|Mortise, beam end simple angled and twisted|"), T("|Mortise, beam end simple beveled|"), _kAMHeadCompound,  T("|Tenon, perpendicular|"),	// Mortise 
	_kAMTenonSimpleAngled, _kAMTenonSimpleAngledTwisted, _kAMTenonSimpleBeveled, _kAMTenonCompound,							// Mortise 	
	T("|Chamfer|"), T("|Chamfer, others|"),																					// Chamfer
	T("|Slot, perpendicular|"), T("|Slot, rotated|"), T("|Slot, tilted|"), T("|Slot, 5-Axis|"),								// Slot
	_kABCSeatCut, _kABCRisingSeatCut, _kABCOpenSeatCut, _kABCLapJoint, _kABCBirdsmouth,
	_kABCReversedBirdsmouth, _kABCClosedBirdsmouth, _kABCDiagonalSeatCut, _kABCOpenDiagonalSeatCut, _kABCBlindBirdsmouth,
	_kABCHousing, _kABCHousingThroughout, _kABCHouseRotated, _kABCHouseTilted, _kABCJapaneseHipCut,
	_kABCHipBirdsmouth, _kABCValleyBirdsmouth, _kABCRisingBirdsmouth, _kABCHoused5Axis, _kABCSimpleHousing,
	_kABCRabbet, _kABCDado, _kABC5Axis, _kABC5AxisBirdsmouth, _kABC5AxisBlindBirdsmouth,									// Beamcut
	T("|Rabbet/Dado, perpendicular|"), T("|Rabbet/Dado, 5-Axis|")};															// Rabbet/Dado	
	{ 
		// auto translate missing
		String prefixes[] = { "_kAM", "_kABC"};
		for (int j=0;j<prefixes.length();j++) 
			for (int i=0;i<sToolTypesT.length();i++) 
			{ 
				String& s = sToolTypesT[i]; 
				if (s.find(prefixes[j],0, false)==0)
					s = T("|"+s.right(s.length() - prefixes[j].length())+"|");
			}//next i		
	}

	
//endregion 




	
//end Constants//endregion

	//int tick = getTickCount();

//region DialogMode
	int nDialogMode = _Map.getInt("DialogMode");
	if (nDialogMode > 0)
	{ 
		if (nDialogMode==1)
		{ 
			setOPMKey("DrillVisibility");	
			
			String sVSBeamName=T("|Beam|");	
			PropString sVSBeam(nStringIndex++, sVSDrills, sVSBeamName);	
			sVSBeam.setDescription(T("|Defines the Beam|"));
			sVSBeam.setCategory(category);
		
			String sVSSheetName=T("|Sheet|");	
			PropString sVSSheet(nStringIndex++, sVSDrills, sVSSheetName);	
			sVSSheet.setDescription(T("|Defines the Sheet|"));
			sVSSheet.setCategory(category);	
	
			String sVSPanelName=T("|Panel|");	
			PropString sVSPanel(nStringIndex++, sVSDrills, sVSPanelName);	
			sVSPanel.setDescription(T("|Defines the Panel|"));
			sVSPanel.setCategory(category);
			
			String sVSMetalPartName=T("|MetalPart|");	
			PropString sVSMetalPart(nStringIndex++, sVSDrills, sVSMetalPartName);	
			sVSMetalPart.setDescription(T("|Defines the MetalPart|"));
			sVSMetalPart.setCategory(category);				
		}
		else if (nDialogMode==2)
		{ 
			setOPMKey("GlobalSettings");	
			
			String sGroupAssignmentName=T("|Group Assignment|");	
			PropString sGroupAssignment(nStringIndex++, sGroupings, sGroupAssignmentName);	
			sGroupAssignment.setDescription(T("|Defines to layer to assign the instance|, ") + tDefaultEntry + T(" = |byEntity|"));
			sGroupAssignment.setCategory(category);			
		}	

		return;
	}		
//endregion


//END Part #0 History, Constants //endregion 

//region Functions #FU


	//region Global
		
//region ArrayToMapFunctions

	//region Function GetDoubleArray
	// returns an array of doubles stored in map
	double[] GetDoubleArray(Map mapIn, int bSorted)
	{ 
		double values[0];
		for (int i=0;i<mapIn.length();i++) 
			if (mapIn.hasDouble(i))
				values.append(mapIn.getDouble(i));
				
		if (bSorted)
			values.sorted();		
				
		return values;
	}//endregion

	//region Function SetDoubleArray
	// sets an array of doubles in map
	Map SetDoubleArray(double values[], String key)
	{ 
		key = key.length() < 1 ? "value" : key;
		Map mapOut;
		for (int i=0;i<values.length();i++) 
			mapOut.appendDouble(key, values[i]);	
		return mapOut;
	}//endregion

	//region Function GetStringArray
	// returns an array of doubles stored in map
	String[] GetStringArray(Map mapIn, int bSorted)
	{ 
		String values[0];
		for (int i=0;i<mapIn.length();i++) 
			if (mapIn.hasString(i))
				values.append(mapIn.getString(i));
				
		if (bSorted)
			values.sorted();		
				
		return values;
	}//endregion

	//region Function SetStringArray
	// sets an array of strings in map
	Map SetStringArray(String values[], String key)
	{ 
		key = key.length() < 1 ? "value" : key;
		Map mapOut;
		for (int i=0;i<values.length();i++) 
			mapOut.appendString(key, values[i]);	
		return mapOut;
	}//endregion

	//region Function GetIntArray
	// returns an array of doubles stored in map
	int[] GetIntArray(Map mapIn, int bSorted)
	{ 
		int values[0];
		for (int i=0;i<mapIn.length();i++) 
			if (mapIn.hasInt(i))
				values.append(mapIn.getInt(i));
				
		if (bSorted)
			values.sorted();		
				
		return values;
	}//endregion

	//region Function SetIntArray
	// sets an array of ints in map
	Map SetIntArray(int values[], String key)
	{ 
		key = key.length() < 1 ? "value" : key;
		Map mapOut;
		for (int i=0;i<values.length();i++) 
			mapOut.appendInt(key, values[i]);	
		return mapOut;
	}//endregion

	//region Function GetBodyArray
	// returns an array of bodies stored in map
	Body[] GetBodyArray(Map mapIn)
	{ 
		Body bodies[0];
		for (int i=0;i<mapIn.length();i++) 
			if (mapIn.hasBody(i))
				bodies.append(mapIn.getBody(i));
	
		return bodies;
	}//endregion

	//region Function SetBodyArray
	// sets an array of bodies in map
	Map SetBodyArray(Body bodies[])
	{ 
		Map mapOut;
		for (int i=0;i<bodies.length();i++) 
			mapOut.appendBody("bd", bodies[i]);	
		return mapOut;
	}//endregion

	//region Function GetPlaneProfileArray
	// returns an array of PlaneProfiles stored in map
	PlaneProfile[] GetPlaneProfileArray(Map mapIn)
	{ 
		PlaneProfile pps[0];
		for (int i=0;i<mapIn.length();i++) 
			if (mapIn.hasPlaneProfile(i))
				pps.append(mapIn.getPlaneProfile(i));
	
		return pps;
	}//endregion

	//region Function SetPlaneProfileArray
	// sets an array of PlaneProfiles in map
	Map SetPlaneProfileArray(PlaneProfile pps[])
	{ 
		Map mapOut;
		for (int i=0;i<pps.length();i++) 
			mapOut.appendPlaneProfile("pp", pps[i]);	
		return mapOut;
	}//endregion

	//region Function GetPLineArray
	// returns an array of PLines stored in map
	PLine[] GetPLineArray(Map mapIn)
	{ 
		PLine plines[0];
		for (int i=0;i<mapIn.length();i++) 
			if (mapIn.hasPLine(i))
				plines.append(mapIn.getPLine(i));	
		return plines;
	}//endregion

	//region Function SetPLineArray
	// sets an array of PLines in map
	Map SetPLineArray(PLine plines[])
	{ 
		Map mapOut;
		for (int i=0;i<plines.length();i++) 
			mapOut.appendPLine("pl", plines[i]);	
		return mapOut;
	}//endregion


//End ArrayToMapFunctions //endregion 	 	
 		
//region Function Equals
	// returns true if two strings are equal ignoring any case sensitivity
	int Equals(String str1, String str2)
	{ 
		str1 = str1.makeUpper();
		str2 = str2.makeUpper();		
		return str1==str2;
	}//endregion
		
	
	
	//endregion 


//region MultipageView Functions

//region Function GetViewPlaneProfiles
	// returns the planeprofiles of all views of a page
	PlaneProfile[] GetViewPlaneProfiles(MultiPage page)
	{ 
		PlaneProfile pps[0];
		MultiPageView views[]=page.views();

		for (int i=0;i<views.length();i++) 
		{ 
			PlaneProfile pp(CoordSys());
			pp.joinRing(views[i].plShape(),_kAdd); 
			pps.append(pp);
		}//next i
		
		return pps;
	}//endregion

//region Function FindClosestView
	// returns the view with the closest origin
	MultiPageView FindClosestView(Point3d ptRef, MultiPage page, PlaneProfile& ppView)
	{ 
		ptRef.setZ(0);
		MultiPageView view,views[]=page.views();
		
		double dist = U(10e10);
		for (int i=0;i<views.length();i++) 
		{ 
			PlaneProfile pp(CoordSys());
			pp.joinRing(views[i].plShape(),_kAdd); 
			Point3d pt = pp.ptMid()-.5*(_XW*pp.dX()+_YW*pp.dY()); 
			
			double d = (pt - ptRef).length();
			if (d<dist)
			{ 
				dist = d;
				view = views[i];
				ppView = pp;
			}
		}//next i
		
		return view;
	}//endregion


	//End MultipageView Functions //endregion

//region Filter Functions

//region Function FilterAcceptedEntity
	// returns true if the entity is accepted by the given filter
	int FilterAcceptedEntity(Entity ent, String filter)
	{ 
		Entity ents[] = { ent};
		ents = Entity().filterAcceptedEntities(ents, filter);
		int accepted = ents.find(ent)>-1;
		return accepted;
	}//endregion
	

//region Function FilterTslsByName
	// returns all tsl instances with the given scriptname
	// ents: the array to search, if empty all tsls in modelspace are taken
	// name: the name of the tsl to be returned, all if empty
	TslInst[] FilterTslsByName(Entity ents[], String name)
	{ 
		TslInst out[0];
		
		String names[0];
		if (name.length()>0)
			names.append(name);
			
		int bAll = names.length() < 1;
		
		if (ents.length()<1)
			ents = Group().collectEntities(true, TslInst(),  _kModelSpace);
		
		for (int i=0;i<ents.length();i++) 
		{ 
			TslInst t= (TslInst)ents[i]; 
			//reportNotice("\ngetTslsByName: " + t.scriptName() +" "+names);
			if (t.bIsValid())
			{
				if (!bAll && names.findNoCase(t.scriptName(),-1)>-1)
					out.append(t);	
				else if (bAll)
					out.append(t);									
			}
				
		}//next i

		return out;
	
	}//endregion

//region Function FilterMetalParts
	// returns the accepted entities based on a dummy painter
	MetalPartCollectionEnt[] FilterMetalParts(Entity ents[])
	{ 
		MetalPartCollectionEnt out[0];
		for (int i=0;i<ents.length();i++) 
		{ 
			MetalPartCollectionEnt mpce = (MetalPartCollectionEnt)ents[i]; 
			if (mpce.bIsValid())
				out.append(mpce);
			 
		}//next i
		
		return out;
	}//endregion


//region Function AppendEntities
	// appends entities to an array of entities avoiding duplicates
	void AppendEntities(Entity& ents[], Entity entsAdd[])
	{ 
		for (int i=0;i<entsAdd.length();i++) 
			if(ents.find(entsAdd[i])<0)
				ents.append(entsAdd[i]); 
		return;
	}//endregion

//region Function AppendGenBeams
	// appends entities to an array of entities avoiding duplicates
	void AppendGenBeams(Entity& ents[], GenBeam entsAdd[])
	{ 
		for (int i=0;i<entsAdd.length();i++) 
			if(ents.find(entsAdd[i])<0)
				ents.append(entsAdd[i]); 
		return;
	}//endregion

//region Function AppendTsls
	// appends entities to an array of entities avoiding duplicates
	void AppendTsls(Entity& ents[], TslInst entsAdd[])
	{ 
		for (int i=0;i<entsAdd.length();i++) 
			if(ents.find(entsAdd[i])<0)
				ents.append(entsAdd[i]); 
		return;
	}//endregion

//region Function AppendOpenings
	// appends entities to an array of entities avoiding duplicates
	void AppendOpenings(Entity& ents[], Opening entsAdd[])
	{ 
		for (int i=0;i<entsAdd.length();i++) 
			if(ents.find(entsAdd[i])<0)
				ents.append(entsAdd[i]); 
		return;
	}//endregion	


//region Function AppendXRefEntities
	// appends entities if belonging to an xref to an array of entities avoiding duplicates
	void AppendXRefEntities(Entity& ents[], Entity entsAdd[])
	{ 
		for (int i=0;i<entsAdd.length();i++) 
			if(ents.find(entsAdd[i])<0 && entsAdd[i].xrefName().length()>0)
				ents.append(entsAdd[i]); 
		return;
	}//endregion


//endregion 

//region Function GetBodyFromQuader
	// returns the body of a quader
	Body GetBodyFromQuader(Quader qdr)
	{ 
		Body bd;
		
		CoordSys cs = qdr.coordSys();
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();
		Vector3d vecZ = cs.vecZ();
		if (qdr.dX()>dEps && qdr.dY()>dEps  && qdr.dZ()>dEps )
		{ 
			bd=Body(qdr.pointAt(0, 0, 0), vecX, vecY, vecZ, qdr.dX(), qdr.dY(), qdr.dZ(), 0, 0, 0);	
		}
			
		return bd;
	}//endregion


//region Function GetDimPlaneProfile
	// modifies the profile passed in by adding text areas and dimline box with an additional margin
	void GetDimPlaneProfile(PlaneProfile& pp, Dim dim, Point3d nodes[], Display dp, double margin)
	{ 
		margin = margin < dEps ? dEps : margin;
		CoordSys cs = pp.coordSys();
		Point3d pt = cs.ptOrg();
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();
		
		Line ln(pt, vecX);
		nodes = ln.orderPoints(ln.projectPoints(nodes));
		PLine pl, plines[] = dim.getTextAreas(dp);
		if (nodes.length()>1)
		{
			pl.createRectangle(LineSeg(nodes.first()-vecY*.5*margin, nodes.last()+vecY*.5*margin), vecX, vecY);
			plines.append(pl);
		}
		for (int i=0;i<plines.length();i++) 
			pp.joinRing(plines[i], _kAdd);

		pp.shrink(-margin);

		return;
	}//endregion

//region Function DrawDim
	// draws a dim
	void DrawDim(Point3d nodes[], Point3d ptLoc, Vector3d vecDir, Vector3d vecPerp, Vector3d vecRead, Map mapParams, Display dp)
	{ 
		double textHeight = mapParams.getDouble("textHeight");
		int nDeltaMode = mapParams.getInt("deltaMode"); 
		int nChainMode = mapParams.getInt("chainMode"); 
		int bDeltaOnTop = mapParams.getInt("deltaOnTop");
		int nRefPointMode = mapParams.getInt("refPointMode");
		
		String sDeltaFormat= mapParams.hasString("deltaFormat")?mapParams.getString("deltaFormat"):"<>";
		
		DimLine dl(ptLoc, vecDir, vecPerp);
		dl.setUseDisplayTextHeight(textHeight>0);
		Point3d pts[0];
	
		Dim dim(dl,  pts, "",  "", nDeltaMode, nChainMode); 	
		dim.setDeltaOnTop(bDeltaOnTop);	
		dim.setReadDirection(vecRead);
		for (int i=0;i<nodes.length();i++) 
		{
			nodes[i].vis(i);
			dim.append(nodes[i],sDeltaFormat,(i==0 && nRefPointMode==1?" ":"<>")); // set first to blank if refpoint given 
		}

		if (nodes.length()>1)
		{ 
			dp.draw(dim);
			//dp.draw(text, ptLoc, vecDirText, vecPerpText, nDir, 0);			
		}		
					
		return;
	}//endregion

//region Functions Offset Mode #OM

//region Function CollectEdges
	// returns the edges as profiles 
	PlaneProfile[] CollectStraightEdges(PlaneProfile pp, int bIsOpening, Map mapParams)
	{ 
		double scale = mapParams.hasDouble("scale") ? mapParams.getDouble("scale") : 1;
		PlaneProfile pps[0];
		CoordSys cs = pp.coordSys();
		Vector3d vecY = cs.vecZ();
		
	// resolve into one ring profiles
		PLine rings[] = pp.allRings(true, false);
		for (int r=0;r<rings.length();r++) 
		{ 
			PlaneProfile ppr(cs);
			ppr.joinRing(rings[r],_kAdd);
			
			Point3d pts[] = ppr.getGripVertexPoints();
			for (int i=0;i<pts.length();i++) 
			{ 
				Point3d pt1 = pts[i];
				Point3d pt2 = pts[(i<pts.length()-1?i+1:0)];
				Point3d ptm = (pt1 + pt2) * .5;
				
				Vector3d vecX = pt2 - pt1;
				if(vecX.length()<dEps){ continue;}
				vecX.normalize();
				Vector3d vecZ = vecX.crossProduct(vecY);
				if (ppr.pointInProfile(ptm+vecZ*dEps)!=(bIsOpening?_kPointInProfile:_kPointOutsideProfile)) //TODO logic not working for openings
				{ 
					vecX *= -1;
					vecZ *= -1;
				}
				
				PlaneProfile ppOut; ppOut.createRectangle(LineSeg(pt1+vecY*U(10)*scale, pt2-vecY*U(10)*scale), vecX, vecY);
				ppOut.vis(6);
				pps.append(ppOut);
				vecZ.vis(ptm, 150);
				 
			}//next i			 
		}//next r

		return pps;
	}//endregion		

//region Function GetClosestIntersectionPoint
	// returns true or false if a intersection points are found, if found it modifies the the given point
	int GetClosestIntersectionPoint(PlaneProfile pp, Point3d& pt,Vector3d vecDir, int bIncludeOpenings)
	{ 
		CoordSys cs = pp.coordSys();
		Vector3d vecZ = cs.vecZ();
		Vector3d vecPerp = vecDir.crossProduct(vecZ);
		Line ln(pt, vecDir);
		Point3d pts[] = pp.intersectPoints(Plane(pt, vecPerp), true, bIncludeOpenings);
		pts = ln.orderPoints(pts, dEps);
		Point3d ptsP[0], ptsN[0];
		for (int i=0;i<pts.length();i++) 
		{ 
			double dd = vecDir.dotProduct(pts[i]-pt);
			if (dd>=0)
				ptsP.append(pts[i]);
			else
				ptsN.append(pts[i]);			
			 
		}//next i

	// if points in positive dir found take the first
		if (ptsP.length()>0)
			pt = ptsP[0];
	// if in negative dir found take the last
		else if (ptsN.length()>0)
			pt = ptsN[ptsN.length()-1];			

		return ptsP.length()>0 || ptsN.length()>0;	
	}//endregion
	
//region Function FindClosestProfileEdge
	// returns
	PlaneProfile FindClosestProfileEdge(PlaneProfile ppEdges[], Point3d ptLoc)
	{ 
		PlaneProfile out;
		double dMin = U(10e5);
		for (int i=0;i<ppEdges.length();i++) 
		{ 
			PlaneProfile pp = ppEdges[i]; 
			CoordSys cs = pp.coordSys();
			Vector3d vecZ = cs.vecZ(); 
			double dist = abs(vecZ.dotProduct(ptLoc-pp.ptMid())); 
			if (pp.pointInProfile(ptLoc)!=_kPointOutsideProfile && dist<dMin)
			{ 
				out = pp;
				dMin = dist;
			}
			
		}//next i
		return out;
	}//endregion
	
//endregion 

//region Function PlaneProfile
	
//region Function GetPlaneProfilesFromMap
	// returns the planeprofiles specified in map
	PlaneProfile[] GetPlaneProfilesFromMap(Map m)
	{ 
		PlaneProfile out[0];
		for (int i=0;i<m.length();i++)
		{ 
			PlaneProfile pp = m.getPlaneProfile(i);
			if (pp.area()>pow(dEps,2))
				out.append(pp);
		}
		
		return out;
	}//endregion	

//region Function SetPlaneProfilesToMap
	// returns a map with the the planeprofiles specified
	Map SetPlaneProfilesToMap(PlaneProfile pps[])
	{ 
		Map out;
		for (int i=0;i<pps.length();i++)
		{ 
			PlaneProfile pp =pps[i];
			if (pp.area()>pow(dEps,2))
				out.appendPlaneProfile("pp", pp);
		}	
		return out;
	}//endregion

//region Function GetShopdrawProfiles
	// returns the planeprofiles of the selected shopdrawviews
	PlaneProfile[] GetShopdrawProfiles(ShopDrawView sdvs[])
	{ 
		PlaneProfile pps[0];
		for (int i=0;i<sdvs.length();i++) 
		{ 
			ShopDrawView sdv= sdvs[i]; 

		//Get bounds of viewports		
			PlaneProfile pp(CoordSys());
			Point3d pts[] = sdv.gripPoints();
			Point3d ptCen= sdv.coordSys().ptOrg();
			double dX = U(1000), dY =dX; // something			
			for (int i=0;i<2;i++) 
			{ 
				Vector3d vec = i == 0 ? _XW : _YW;
				pts = Line(_Pt0, vec).orderPoints(pts);
				if (pts.length()>0)	
				{
					double dd = vec.dotProduct(pts.last() - pts.first());
					if (i == 0)dX = dd;
					else dY = dd;
				}
				 
			}//next i
			
			PLine pl;
			Vector3d vec = .5 * (_XW * dX + _YW * dY);
			pl.createRectangle(LineSeg(ptCen - vec, ptCen + vec), _XW, _YW);
			pp.joinRing(pl, _kAdd);		
			//pp.extentInDir(_XW).vis(1);	
			
			pps.append(pp);
				

		}//next i			
		return pps;
	}//endregion

//region Function GetDimensionProfile
	// returns a map with all transformed profiles and modifies the dimension profile
	Map GetDimensionProfile(Body bodies[], CoordSys csTrans, PlaneProfile& ppDim)
	{ 
		//reportNotice("\nGetDimensionProfile: bodies" +bodies.length());
		CoordSys cs = ppDim.coordSys();
		Plane pn(cs.ptOrg(), cs.vecZ());
		
		ppDim.shrink(-dEps);
		
		Map mapCE;
		for (int j=0;j<bodies.length();j++) 
		{ 
			Body bd = bodies[j]; 
			bd.transformBy(csTrans);							//bd.vis(6); 
			PlaneProfile pp = bd.shadowProfile(pn);
			mapCE.appendPlaneProfile("pp", pp);					//pp.vis(j);
			pp.shrink(-dEps);
			ppDim.unionWith(pp);
		}//next j
		ppDim.shrink(dEps);		//{Display dpx(2); dpx.draw(ppDim, _kDrawFilled,20);}
		return mapCE;
	}//endregion
	
//endregion 

//region DimRequest and AnalysedTool Functions


//region Function getBeamcutRequest
	// returns a map request of the boxed analysed tool based on the model vecView
	// vecView: the model view vector
	// vecDir: the direction of the idmline transformed to modelspace
	// HSB-21155 explicit slot request
	Map getBeamcutRequest(AnalysedBeamCut a, Vector3d vecDir, Vector3d vecPerp,Vector3d vecView, int vsStrategy)
	{ 
		Map out;
		Map m = a.mapInternal();
		Entity tent = a.toolEnt();
		Vector3d vecSide = a.vecSide();
		GenBeam gb = a.genBeam();			if (bDebug)gb.envelopeBody(true, true).vis(32);
		Quader q = a.quader();	
		String k;
		Point3d ptCen = gb.ptCen();		
		//_kNotRound;_kRound;_kRelief;_kRoundSmall;_kReliefSmall;_kRounded; kExplicitRadius;

		int nEndType=-1, roundType=-1;
		double dCornerRadius;
		k = "nEndType"; if (m.hasInt(k)) nEndType = m.getInt(k);
		k = "nRoundType"; if (m.hasInt(k)) roundType = m.getInt(k);
		k = "dCornerRadius"; if (m.hasDouble(k)) dCornerRadius = m.getDouble(k);


		String type = m.getMapKey();
		Vector3d vecX= m.getVector3d("vecX");
		Vector3d vecY= m.getVector3d("vecY");
		Vector3d vecZ= m.getVector3d("vecZ");
		Point3d ptOrg = m.getPoint3d("ptOrg");

		Point3d ptsIntersectPoints[] = a.genBeamQuaderIntersectPoints();
		Point3d pts[0];
		int bAllowCrossMark;

		Vector3d vecYN = vecX.crossProduct(-vecView);

		int bAtEnd = vecX.isParallelTo(vecPerp);		
		int bDimOnSide = vecPerp.dotProduct(ptOrg-ptCen)>-0 || vecSide.isCodirectionalTo(vecPerp);
		int bDimDepth = vecZ.isParallelTo(vecDir) && bAtEnd;
		int bDimWidth = vecYN.isParallelTo(vecY)&& vecZ.isParallelTo(vecView) && bAtEnd;
		int bDimLength = vecX.isParallelTo(vecDir) && vecY.isParallelTo(vecView) && vecSide.isCodirectionalTo(vecPerp);
		
		
		
		if (bDimOnSide || a.bIsFreeD(vecView))
			pts = Line(ptOrg, vecDir).orderPoints(ptsIntersectPoints, dEps);

		if (pts.length()>2)
		{ 
			pts.swap(1, pts.length() - 1);
			pts.setLength(2);
			vecX.vis(q.ptOrg(), bDimLength);
			vecY.vis(q.ptOrg(), 3);
			vecZ.vis(q.ptOrg(), 150);
		}
		
		
		

		int bOk;
//		if (bDimOnSide && bDimWidth  )
//		{ 
//			Plane pn(gb.ptCen() + vecSide * .5 * gb.dD(vecSide), vecSide);
//			pts = pn.filterClosePoints(ptsIntersectPoints, dEps);
//			if (bDebug)q.vis(161);
//			bOk = true;
//		}
//		else if (bDimOnSide && (bDimLength|| bDimDepth)) 
//		{
//			Vector3d vecy = vecX.crossProduct(vecView);
//			PLine pl(vecView);
//			pl.createConvexHull(Plane(ptOrg, vecView), ptsIntersectPoints);
//			PlaneProfile pp(CoordSys(ptOrg, vecX, vecy, vecView));
//			pp.joinRing(pl, _kAdd);
//			//pp.vis(3);
//			Vector3d vec = .5 * (vecX * pp.dX() + vecy * pp.dY());
//			pts.append(pp.ptMid()-vec);
//			pts.append(pp.ptMid()+vec);		
//			if (bDebug)q.vis(bDimLength?2:6);
//			bOk = true;
//		}
//		else 
//	// rounded mortise
//		if (roundType==1 && !vecView.isParallelTo(vecSide) && vsStrategy!=1)
//		{ 
//			if (bDebug)q.vis(12);
//			continue;
//		}
//		else if (vecSide.isParallelTo(gb.vecX())  )
//		{ 
//		// filter outside
//			pts.append(ptsIntersectPoints);
//			for (int i=pts.length()-1; i>=0 ; i--) 
//				if (vecSide.dotProduct(pts[i]-ptOrg)<0)
//					pts.removeAt(i); 
//
//			if (bDebug)
//			{
//				q.vis(6);
//				vecSide.vis(q.ptOrg(), 3);
//				vecView.vis(q.ptOrg(), 150);
//				vecZ.vis(q.ptOrg(), 2);				
//			}
//
//		}		
//		else if (vecSide.isPerpendicularTo(gb.vecX()) && bDimDepth)
//		{ 
//			Plane pn(gb.ptCen() + vecSide * .5 * gb.dD(vecSide), vecSide);
//			pts.append(ptsIntersectPoints);
//			pts = pn.filterClosePoints(pts, dEps);
//			if (bDebug)
//			{ 
//				q.vis(5);
//				vecSide.vis(q.ptOrg(), 1);
//				vecView.vis(q.ptOrg(), 150);
//				vecZ.vis(q.ptOrg(), 2);				
//				
//			}
//
//		}
//		else 
		if (bDebug)
		{ 
			q.vis(1);
		}
		pts = Line(_Pt0, vecDir).orderPoints(pts, dEps);
		if (bDebug)
			for (int i=0;i<pts.length();i++) 
				pts[i].vis(3); 
		
		if (pts.length()>0)
		{ 
			out.setInt(kAllowCrossMark,bAllowCrossMark);
			out.setPoint3dArray(kNodes,pts);
			out.setVector3d(kAllowedView,vecView);
			out.setEntity("originator", tent);			
		}
	
		return out;
	}//End getBeamcutRequest //endregion

//region Function getBoxedToolRequest
	// returns a map request of the boxed analysed tool based on the model vecView
	// q: the quader of the boxed tool
	// mapInternal: the internal map carrying most of the tool parameters
	// vecView: the model view vector
	// vecDir: the direction of the idmline transformed to modelspace
	// sStereotypes: a list of stereotypes to validate the tool against
	// originator: the toolEnt
	Map getBoxedToolRequest(Quader q, AnalysedTool a, Vector3d vecDir,Vector3d vecPerp, Vector3d vecSide, Vector3d vecView, Point3d genBeamQuaderIntersectPoints[], int vsStrategy)
	{ 
		Map out;
		Map m = a.mapInternal();
		GenBeam gb = a.genBeam();	if (bDebug)gb.envelopeBody(true, true).vis(4);
		Entity tent = a.toolEnt();
		Point3d ptCen = gb.ptCen();	
		String k;

		//_kNotRound;_kRound;_kRelief;_kRoundSmall;_kReliefSmall;_kRounded; kExplicitRadius;

		String type = m.getMapKey();
		Vector3d vecX= m.getVector3d("vecX");
		Vector3d vecY= m.getVector3d("vecY");
		Vector3d vecZ= m.getVector3d("vecZ");
		Point3d ptOrg = m.getPoint3d("ptOrg");
		int nEndType=-1, roundType=-1;
		double dCornerRadius;
		k = "nEndType"; if (m.hasInt(k)) nEndType = m.getInt(k);
		k = "nRoundType"; if (m.hasInt(k)) roundType = m.getInt(k);
		k = "dCornerRadius"; if (m.hasDouble(k)) dCornerRadius = m.getDouble(k);
		
		//reportNotice("\n"+type+" " +vecX + " roundType:" + roundType + " nEndType:"+ nEndType + "\ndCornerRadius:" + dCornerRadius + "\n"+ m);

		Point3d pts[0];
		int bAllowCrossMark;

		Vector3d vecYN = vecX.crossProduct(-vecView);
		int bAtEnd = vecX.isParallelTo(vecPerp);
		int bDimOnSide = vecPerp.dotProduct(ptOrg-ptCen)>-0 || vecSide.isCodirectionalTo(vecPerp);
		int bDimDepth = vecZ.isParallelTo(vecDir) && bAtEnd;
		int bDimWidth = vecYN.isParallelTo(vecY)&& vecZ.isParallelTo(vecView) && bAtEnd;
		int bDimLength = vecX.isParallelTo(vecDir) && vecY.isParallelTo(vecView) && vecSide.isCodirectionalTo(vecPerp);



	// rounded mortise
		if (vecView.isParallelTo(vecSide) && vecView.isParallelTo(vecZ) && dCornerRadius>0)
		{ 
			//vecZ.vis(ptOrg, 150);			
			double dx = q.dD(vecX);
			double dy = q.dD(vecY);

			double dw=.5*dy-dCornerRadius;

			if (dx>=2*dCornerRadius || dy>=2*dCornerRadius)
			{ 
				Vector3d vecx, vecy;
				if (dy<dx)
				{
					vecx= vecX * (.5 * dx - dCornerRadius);
					vecy= vecY * dw;
					if (bDebug)q.vis(1);
				}
				else
				{
					dw=.5*dx-dCornerRadius;
					vecx= vecY * (.5 * dy - dCornerRadius);
					vecy= vecX * dw;
					if (bDebug)q.vis(2);
				}
				if (!vecx.bIsZeroLength() || !vecy.bIsZeroLength())
				{ 
					pts.append(ptOrg - vecx-vecy);
					pts.append(ptOrg + vecx-vecy);
					if (abs(dw)>dEps)
					{ 
						pts.append(ptOrg - vecx+vecy);
						pts.append(ptOrg + vecx+vecy);					
					}
					if (bDebug)
						for (int i=0;i<pts.length();i++) 
							pts[i].vis(i); 

						
					bAllowCrossMark = true;
				}
			}
		}
		else if (roundType==1 && !vecView.isParallelTo(vecSide) && vsStrategy!=1)
		{ 
			if (bDebug)q.vis(12);
			continue;
		}
		else if (vecSide.isParallelTo(gb.vecX())  )
		{ 
		// filter outside
			pts.append(genBeamQuaderIntersectPoints);
			for (int i=pts.length()-1; i>=0 ; i--) 
				if (vecSide.dotProduct(pts[i]-ptOrg)<0)
					pts.removeAt(i); 

			if (bDebug)
			{
				q.vis(6);
				vecSide.vis(q.ptOrg(), 3);
				vecView.vis(q.ptOrg(), 150);
				vecZ.vis(q.ptOrg(), 2);				
			}

		}		
		else if (vecSide.isPerpendicularTo(gb.vecX()) && bDimDepth)
		{ 
			Plane pn(gb.ptCen() + vecSide * .5 * gb.dD(vecSide), vecSide);
			pts.append(genBeamQuaderIntersectPoints);
			pts = pn.filterClosePoints(pts, dEps);
			if (bDebug)
			{ 
				q.vis(5);
				vecSide.vis(q.ptOrg(), 1);
				vecView.vis(q.ptOrg(), 150);
				vecZ.vis(q.ptOrg(), 2);				
				
			}

		}
		else if (bDebug)
		{ 
			q.vis(1);
		}

			
		pts = Line(_Pt0, vecDir).orderPoints(pts, dEps);
	
		if (pts.length()>0)
		{ 
			out.setInt(kAllowCrossMark,bAllowCrossMark);
			out.setPoint3dArray(kNodes,pts);
			out.setVector3d(kAllowedView,vecView);
			if (tent.bIsValid())
				out.setEntity("originator", tent);	
			else// HSB-21966 support static drills
				out.setEntity("originator", gb);			
		}
	
		return out;
	}//End getBoxedToolRequest //endregion

//region Function getRabbetRequest
	// returns a map request of the boxed analysed tool based on the model vecView
	// vecView: the model view vector
	// vecDir: the direction of the idmline transformed to modelspace
	Map getRabbetRequest(AnalysedRabbet a, Vector3d vecDir, Vector3d vecPerp,Vector3d vecView)
	{ 
		Map out;
		Map m = a.mapInternal();
		GenBeam gb = a.genBeam();	//gb.envelopeBody(true, true).vis(4);
		Entity tent = a.toolEnt();
		Vector3d vecSide = a.vecSide();
		
		String k;
		Point3d ptCen = gb.ptCen();		
		//_kNotRound;_kRound;_kRelief;_kRoundSmall;_kReliefSmall;_kRounded; kExplicitRadius;

		String type = m.getMapKey();
		Vector3d vecX= m.getVector3d("vecX");
		Vector3d vecY= m.getVector3d("vecY");
		Vector3d vecZ= m.getVector3d("vecZ");
		Point3d ptOrg = m.getPoint3d("ptOrg");


		Quader q = Quader(ptOrg, vecX, vecY, vecZ, a.dX(), a.dY(), a.dZ(),0,0,0);

		Point3d ptsIntersectPoints[0];// = a.genBeamQuaderIntersectPoints();
		Point3d pts[0];
		int bAllowCrossMark;
		
		// rough beta collection
		pts.append(ptOrg - .5 * (vecX * a.dX() + vecY * a.dY() + vecZ * a.dZ()));
		pts.append(ptOrg + .5 * (vecX * a.dX() + vecY * a.dY() + vecZ * a.dZ()));
		
		
		
//
//		Vector3d vecYN = vecX.crossProduct(-vecView);
//
//		// dimension strategies
//		// slot width always in view direction
//		// length and depth always in corresponding side view
//
//		int bAtEnd = vecX.isParallelTo(vecPerp);		
//		int bDimOnSide = vecPerp.dotProduct(ptOrg-ptCen)>-0 || vecSide.isCodirectionalTo(vecPerp);
//		int bDimDepth = vecZ.isParallelTo(vecDir) && bAtEnd;
//		int bDimWidth = vecYN.isParallelTo(vecY)&& vecZ.isParallelTo(vecView) && bAtEnd;
//		int bDimLength = vecX.isParallelTo(vecDir) && vecY.isParallelTo(vecView) && vecSide.isCodirectionalTo(vecPerp);
//
//		int bOk;
//		if (bDimOnSide && bDimWidth  )
//		{ 
//			Plane pn(gb.ptCen() + vecSide * .5 * gb.dD(vecSide), vecSide);
//			pts = pn.filterClosePoints(ptsIntersectPoints, dEps);
//			if (bDebug)q.vis(161);
//			bOk = true;
//		}
//		else if (bDimOnSide && (bDimLength|| bDimDepth)) 
//		{
//			Vector3d vecy = vecX.crossProduct(vecView);
//			PLine pl(vecView);
//			pl.createConvexHull(Plane(ptOrg, vecView), ptsIntersectPoints);
//			PlaneProfile pp(CoordSys(ptOrg, vecX, vecy, vecView));
//			pp.joinRing(pl, _kAdd);
//			//pp.vis(3);
//			Vector3d vec = .5 * (vecX * pp.dX() + vecy * pp.dY());
//			pts.append(pp.ptMid()-vec);
//			pts.append(pp.ptMid()+vec);		
//			if (bDebug)q.vis(bDimLength?2:6);
//			bOk = true;
//		}
//		else if (bDebug)
//		{
//			vecPerp.vis(q.ptOrg(), 3);
//			vecY.vis(q.ptOrg(), bDimOnSide);
//			q.vis(252);
//		}

		pts = Line(_Pt0, vecDir).orderPoints(pts, dEps);
		if (bDebug)
			for (int i=0;i<pts.length();i++) 
				pts[i].vis(4); 
		
		if (pts.length()>0)
		{ 
			out.setInt(kAllowCrossMark,bAllowCrossMark);
			out.setPoint3dArray(kNodes,pts);
			out.setVector3d(kAllowedView,vecView);
			out.setEntity("originator", tent);			
		}
	
		return out;
	}//End getRabbetRequest //endregion

//region Function getSlotRequest
	// returns a map request of the boxed analysed tool based on the model vecView
	// vecView: the model view vector
	// vecDir: the direction of the idmline transformed to modelspace
	// HSB-21155 explicit slot request
	Map getSlotRequest(AnalysedSlot a, Vector3d vecDir, Vector3d vecPerp,Vector3d vecView)
	{ 
		Line lnDir(_Pt0, vecDir);
		
		Map out;
		Map m = a.mapInternal();
		GenBeam gb = a.genBeam();	//gb.envelopeBody(true, true).vis(4);
		Quader qdrGb = a.genBeamQuader();
		Entity tent = a.toolEnt();
		Vector3d vecSide = a.vecSide();
		Quader q = a.quader();
		String k;
		Point3d ptCen = qdrGb.pointAt(0,0,0);		//		ptCen.vis(2);
		//_kNotRound;_kRound;_kRelief;_kRoundSmall;_kReliefSmall;_kRounded; kExplicitRadius;

		String type = m.getMapKey();
		Vector3d vecX= m.getVector3d("vecX");
		Vector3d vecY= m.getVector3d("vecY");
		Vector3d vecZ= m.getVector3d("vecZ");
		Point3d ptOrg = m.getPoint3d("ptOrg");

		Vector3d vecXG = gb.vecX();
		if (vecXG.dotProduct(ptOrg - ptCen) < 0)vecXG *= -1;
		
		Line lnX(_Pt0, vecXG);
		Point3d ptsExtremes[] = { qdrGb.pointAt(-1, - 1 ,- 1), qdrGb.pointAt(1, 1, 1)};
		ptsExtremes = lnX.orderPoints(ptsExtremes);

		Point3d ptsIntersectPoints[] = a.genBeamQuaderIntersectPoints();
		Point3d pts[0];
		int bAllowCrossMark;

		Vector3d vecYN = vecX.crossProduct(-vecView);

		// dimension strategies
		// slot width always in view direction
		// length and depth always in corresponding side view

	// Identify beam end placement
		int bAtEnd = vecX.isParallelTo(vecPerp) ;//&& vecXG.isCodirectionalTo(vecPerp);

		q.vis(bAtEnd?3:1);
		int bDimOnSide = vecPerp.dotProduct(ptOrg-ptCen)>-0 || vecSide.isCodirectionalTo(vecPerp);
		int bDimDepth = vecZ.isParallelTo(vecDir) && bAtEnd;
		int bDimWidth = vecYN.isParallelTo(vecY)&& vecZ.isParallelTo(vecView) && bAtEnd;
		int bDimLength = vecX.isParallelTo(vecDir) && vecY.isParallelTo(vecView) && vecSide.isCodirectionalTo(vecPerp);

		//vecPerp.vis(q.ptOrg(), 6);
		

		int bOk;
		if (bAtEnd)
		{ 
		// check pos or neg beam end	
			if (ptsIntersectPoints.length()>0 )
			{ 
				// if the extreme of the genbeam quader is near the extrene of the slot it is treated as end slot
				Point3d ptsQ[] = lnX.orderPoints(ptsIntersectPoints, dEps);
				if (ptsQ.length()>0 && abs(vecXG.dotProduct(ptsQ.last()-ptsExtremes.last()))<dEps && vecXG.dotProduct(vecPerp)>0)
				{
					pts = lnDir.orderPoints(ptsIntersectPoints, dEps);
					bOk = true;	
					
				}
				if (bDebug)q.vis(bOk?3:1);
				//vecXG.vis(q.ptOrg(), 1);
			}			
		}
		else if (bDimOnSide && bDimWidth  )
		{ 
			Plane pn(gb.ptCen() + vecSide * .5 * gb.dD(vecSide), vecSide);
			pts = pn.filterClosePoints(ptsIntersectPoints, dEps);
			if (bDebug)q.vis(161);
			bOk = true;
		}
		else if (bDimOnSide && (bDimLength|| bDimDepth)) 
		{
			Vector3d vecy = vecX.crossProduct(vecView);
			PLine pl(vecView);
			pl.createConvexHull(Plane(ptOrg, vecView), ptsIntersectPoints);
			PlaneProfile pp(CoordSys(ptOrg, vecX, vecy, vecView));
			pp.joinRing(pl, _kAdd);
			//pp.vis(3);
			Vector3d vec = .5 * (vecX * pp.dX() + vecy * pp.dY());
			pts.append(pp.ptMid()-vec);
			pts.append(pp.ptMid()+vec);		
			if (bDebug)q.vis(bDimLength?2:6);
			bOk = true;
		}
		else if (bDebug)
		{
			vecPerp.vis(q.ptOrg(), 3);
			vecY.vis(q.ptOrg(), bDimOnSide);
			q.vis(252);
		}

		pts = Line(_Pt0, vecDir).orderPoints(pts, dEps);
		if (bDebug)
			for (int i=0;i<pts.length();i++) 
				pts[i].vis(4); 
		
		if (bOk && pts.length()>0)
		{ 
			out.setInt(kAllowCrossMark,bAllowCrossMark);
			out.setPoint3dArray(kNodes,pts);
			out.setVector3d(kAllowedView,vecView);
			out.setEntity("originator", tent);			
		}
	
		return out;
	}//End getSlotRequest //endregion

//region Function getChamferRequest
	// returns
	// t: the tslInstance to 
	Map getChamferRequest(AnalysedChamfer a, Vector3d vecView, Vector3d vecPerp)
	{ 
		Map out;
	
		//reportNotice("\ngetChamferRequest: " + a.toolSubType());
		GenBeam gb = a.genBeam();
		Point3d ptCen = gb.ptCen();
		Point3d pt1 = a.pt1();
		Point3d pt2 = a.pt2();
		
		Point3d pts[0];
		
		Vector3d vecSides[] = a.vecChamferEdges();
		for (int e = 0; e < vecSides.length(); e++)
		{
			Vector3d vecSide = vecSides[e];
 		// move the points to the beam edge
			 Vector3d vecOffset(0,0,0), vecOffsetDepth(0,0,0);
			 Vector3d vecB = 0.5*gb.vecZ()*gb.dH();
			 if (vecB.dotProduct(vecSide)>0)	
			 {
			 	vecOffset +=vecB;
			 	vecOffsetDepth +=gb.vecZ()* a.dDepth();			 	
			 }
			 else
			 { 
			 	vecOffset -=vecB;
			 	vecOffsetDepth -=gb.vecZ()* a.dDepth();			 	
			 }
			vecB = 0.5*gb.vecY()*gb.dW();
		 	if (vecB.dotProduct(vecSide)>0)
		 	{
		 		vecOffset +=vecB;
		 		vecOffsetDepth +=gb.vecY()* a.dDepth();	
		 	}
			else
			{
				vecOffset -=vecB;
				vecOffsetDepth -=gb.vecY()* a.dDepth();	
			}

 			Point3d pt1e = pt1 + vecOffset;
 			Point3d pt2e = pt2 + vecOffset;
			
		// append if parallel to X and on relevant side or if vecDir is perp to genbeam axis	
			if (vecPerp.dotProduct(pt1e-ptCen)>0 || vecPerp.isParallelTo(gb.vecX()))
			{ 
				pt2e -= vecOffsetDepth;
				pts.append(pt1e);
				pts.append(pt2e);
			}
		}

		if (pts.length()>0)
		{ 
			out.setPoint3dArray(kNodes,pts);
			out.setVector3d(kAllowedView,vecView);
			out.setEntity("originator", a.toolEnt());	
			
			//reportNotice("\ngetChamferRequest: " + a.toolSubType() + " " + pts.length() + "points");
		}


		return out;
	}//End getChamferRequest //endregion	

//region Function getCutRequest
	// returns
	// t: the tslInstance to 
	Map getCutRequest(AnalysedCut a, Vector3d vecView, Vector3d vecDir, Vector3d vecPerp)
	{ 
		Map out;

		Vector3d vecNormal  = a.normal();
		Point3d ptOrg  = a.ptOrg();
		Point3d pts[0];

		//vecPerp.vis(ptOrg, 3);	originator.realBody().vis(93);

	// Cut is on dim side and simple	
		if (vecNormal.isPerpendicularTo(vecView) && vecNormal.dotProduct(vecPerp)>0)
		{ 
			pts= a.bodyPointsInPlane();
			pts = Line(_Pt0, vecDir).orderPoints(pts, dEps);
			if (pts.length()>2)
			{ 
				pts.swap(1, pts.length() - 1);
				pts.setLength(2);
			}
			//if (bDebug)reportNotice("\ngetCutRequest: cut" + a.toolSubType() + " " + pts);

			out.setPoint3dArray(kNodes,pts);
			out.setVector3d(kAllowedView,vecView);
			out.setEntity("originator", a.genBeam());			
		}

		
		return out;		
	}//End getCutRequest //endregion

//region Function getDrillRequest
	// returns a single drill request
	Map getDrillRequest(AnalysedDrill a, Vector3d vecView, int vsStrategy)
	{ 
		// vsStrategy 0 = Any view 
		// vsStrategy 1 = Perpendicular to View Direction
		// vsStrategy 2 = Parallel to View Direction
		
		Map out;
		vecView.normalize();
		
		Point3d ptStartExtreme = a.ptStartExtreme();
		Point3d ptStart = a.ptStart();
		Point3d ptEndExtreme = a.ptEndExtreme();
		Vector3d vecFree  = a.vecFree();
		Vector3d vecFreeN = vecFree.isParallelTo(vecView)?vecFree:vecFree.crossProduct(vecView).crossProduct(-vecView);vecFreeN.normalize();
		Vector3d vecSide = a.vecSide();
		GenBeam gb = a.genBeam();
		ToolEnt tent = a.toolEnt();
		
		// HSB-21223 catching tolerances
		int bViewIsParallelFree = vecView.isParallelTo(vecFree) || abs(abs(vecView.dotProduct(vecFree))-1)<0.00001;
		int bViewIsPerpendicularFree = vecView.isPerpendicularTo(vecFree) || abs(1-abs(vecView.dotProduct(vecFree)))>0.99999;
		int bViewIsParallelSide = vecView.isParallelTo(vecSide) || abs(abs(vecView.dotProduct(vecSide))-1)<0.00001;
		int bViewIsPerpendicularSide = vecView.isPerpendicularTo(vecSide) || abs(1-abs(vecView.dotProduct(vecSide)))>0.99999;

		//reportNotice("\ngetDrillRequest: " + a.toolSubType() + " " +vsStrategy+ " view: "+bViewIsParallelFree + " " + bViewIsPerpendicularFree+" "+bViewIsParallelSide+" "+bViewIsPerpendicularSide);

		//if (bDebug){gb.realBody().vis(vsStrategy);		vecFree.vis(ptStart,3);}
		double radius = a.dRadius();
		double depth = a.dDepth();

		Point3d pts[0];
		//reportNotice("\nnVSStrategy"+vsStrategy);				
//		vecView.vis(ptStartExtreme,4);
//		vecSide.vis(ptStartExtreme,6);
//		vecFree.vis(ptStartExtreme,5);
		if (bViewIsParallelFree && vsStrategy!=1)
		{
			if (bDebug)vecFree.vis(ptStart,1);
			pts.append(ptStart);
			out.setInt(kAllowCrossMark,true);
		}
		else if (bViewIsPerpendicularFree &&  vsStrategy!=2)
		{
			//if (bDebug)vecFree.vis(ptStart,4);
			pts.append(ptStart);
		}
		else if (bViewIsParallelSide  &&  vsStrategy!=1)// tilted in view,HSB-21155 
		{			
		// HSB-21155 check if start point is on face in view direction 	
			Plane pnFace = a.genBeamQuader().plFaceD(vecSide);
			Point3d ptFace = ptStart;//ptFace.vis(2);
			if (Line(ptFace, vecView).hasIntersection(pnFace, ptFace) && abs(vecView.dotProduct(ptFace-ptStart))<dEps)
			{ 
				if (bDebug)vecSide.vis(ptStart,6);
				pts.append(ptStart);
				out.setInt(kAllowCrossMark,true);	
			}				
		}
		else if (bViewIsPerpendicularSide &&  vsStrategy!=2)// tilted in view,HSB-21155 
		{
				if (bDebug)vecSide.vis(ptStart,40);
				pts.append(ptStart);
		}	
		else
		{ 
			vecSide.vis(ptStart,211);
		}
		if (pts.length()>0)
		{ 
			out.setPoint3dArray(kNodes,pts);
			out.setVector3d(kAllowedView,vecView);
			
			
			if (tent.bIsValid())
				out.setEntity("originator", a.toolEnt());	
			else // HSB-21966 support static drills
				out.setEntity("originator", gb);
			
		}		
		//reportNotice("\ngetDrillRequest: " + out);
		return out;
	}//End getDrillRequest //endregion

//region Function getToolRequests
	// calls the methods to return the mapRequests for each tool type
	// vecView: the model view vector
	// vecDir: the direction of the idmline transformed to modelspace
	// ats: a list of analysed tools
	// t: the toolEnt
	Map[] getToolRequests(Vector3d vecView, AnalysedTool ats[], Vector3d vecDir, Vector3d vecPerp, int vsDrillStrategy, int vsBoxedStrategy)
	{ 
		Map out[0];
		
//	// report toolTypes
//		for (int i=0;i<ats.length();i++) 
//			reportNotice("\ngetToolRequests2: ats "+i + " " +ats[i].toolType() + " "+ats[i].toolSubType()); 

	//region Drills
		AnalysedDrill drills[] =AnalysedDrill().filterToolsOfToolType(ats);	
		//if (bDebug)reportNotice("\ngetToolReq: " + drills.length()+ " drills");
		for (int i=0;i<drills.length();i++) 
		{ 
			AnalysedDrill& a= drills[i];			
			Map m = getDrillRequest(a,vecView, vsDrillStrategy);
			if (m.length()>0)out.append(m); 				
		}//next i	//endregion 	

	//region Mortises
		AnalysedMortise mortises[] =AnalysedMortise().filterToolsOfToolType(ats);	
		//if (bDebug)reportNotice("\ngetToolReq: " + mortises.length()+ " mortises vsBoxedStrategy=" + vsBoxedStrategy);
		for (int i=0;i<mortises.length();i++) 
		{ 
			AnalysedTool& a= mortises[i];
			Map m =getBoxedToolRequest(a.quader(), a, vecDir,vecPerp, a.vecSide(), vecView, a.genBeamQuaderIntersectPoints(),vsBoxedStrategy);
			if (m.length()>0)out.append(m); 
		}//next i	//endregion 	

	//region BeamCuts
		AnalysedBeamCut beamcuts[] =AnalysedBeamCut().filterToolsOfToolType(ats);	
		//if (bDebug)reportNotice("\ngetToolReq: " + beamcuts.length()+ " beamcuts");
		for (int i=0;i<beamcuts.length();i++) 
		{ 
			AnalysedBeamCut& a= beamcuts[i];
			Map m=getBeamcutRequest(a, vecDir, vecPerp,vecView,vsBoxedStrategy);
			if (m.length()>0)out.append(m); 
		}//next i	//endregion 

	//region Houses
		AnalysedHouse houses[] =AnalysedHouse().filterToolsOfToolType(ats);	
		//if (bDebug)reportNotice("\ngetToolReq: " + houses.length()+ " houses");
		for (int i=0;i<houses.length();i++) 
		{ 
			AnalysedHouse& a= houses[i];
			Map m =getBoxedToolRequest(a.quader(), a, vecDir,vecPerp, a.vecSide(), vecView, a.genBeamQuaderIntersectPoints(),vsBoxedStrategy);
			if (m.length()>0)out.append(m); 
		}//next i	//endregion 

	//region Houses
		AnalysedRabbet rabbets[] =AnalysedRabbet().filterToolsOfToolType(ats);	
		//if (bDebug)reportNotice("\ngetToolReq: " + rabbets.length()+ " rabbets");
		for (int i=0;i<rabbets.length();i++) 
		{ 
			AnalysedRabbet& a= rabbets[i];
			Map m =getRabbetRequest(a, vecDir, vecPerp,vecView);
			if (m.length()>0)out.append(m); 
		}//next i	//endregion 

	//region Slots
		AnalysedSlot slots[] =AnalysedSlot().filterToolsOfToolType(ats);	
		//if (bDebug)reportNotice("\ngetToolReq: " + slots.length()+ " slots");
		for (int i=0;i<slots.length();i++) 
		{ 
			AnalysedSlot& a= slots[i];
			Map m =getSlotRequest(a, vecDir, vecPerp,vecView);
			if (m.length()>0)out.append(m); 
		}//next i	//endregion 

	//region Chamfers
		AnalysedChamfer chamfers[] =AnalysedChamfer().filterToolsOfToolType(ats);	
		//if (bDebug)reportNotice("\ngetToolRequests2: " + chamfers.length()+ " chamfers");
		for (int i=0;i<chamfers.length();i++) 
		{ 
			AnalysedChamfer& a= chamfers[i];
			Map m =getChamferRequest(a, vecView, vecPerp);
			if (m.length()>0)out.append(m);
		}//next i	//endregion 


	//region Cuts
		AnalysedCut cuts[] =AnalysedCut().filterToolsOfToolType(ats);		
		//if (bDebug)reportNotice("\ngetToolRequests2: " + cuts.length()+ " cuts");
		for (int i=0;i<cuts.length();i++) 
		{ 
			AnalysedCut& a= cuts[i];
			Map m =getCutRequest(a,vecView, vecDir, vecPerp);
			if (m.length()>0)out.append(m);
		}//next i	//endregion 



	//region MarkerLines
		AnalysedMarkerLine ams[] =AnalysedMarkerLine().filterToolsOfToolType(ats);
		if (ams.length()>0)
		{ 
			//reportNotice("\ngetToolReq: " + ams.length()) + " AnalysedMarkerLine "); 
			Point3d pts[0];
			for (int i=0;i<ams.length();i++) 
			{ 
				AnalysedTool& a= ams[i];
				
				Vector3d vecSide = vecDir.crossProduct(-vecView);
				String toolType = a.toolType();
				
				if (vecSide.isParallelTo(a.vecSide()))
				{ 
					pts.append(a.pt1());
					pts.append(a.pt2());			
				}
				//reportNotice("\n" + a.toolType() + " found " + vecSide + " vs " + a.vecSide() + " pts " + pts.length());
 
			}//next i
			pts = Line(_Pt0, vecDir).orderPoints(pts, dEps);
	
			Point3d nodes[0];
			if (pts.length() > 0)nodes.append(pts.first());
			if (pts.length() > 1)nodes.append(pts.last());
			//reportNotice("\n" + "ams nodes " + nodes.length());
			
			Map m;
			m.setPoint3dArray(kNodes,nodes);
			m.setVector3d(kAllowedView,vecView);
			m.setEntity("originator", ams.first().genBeam());
			out.append(m); 
			
		}			
	//endregion 


		return out;
	}
	//Function getToolRequests //endregion

//region Function getToolSubTypes
	// returns a list of toolSubtypes and the corresponding quantity
	// gbs: the genbeams to check
	// numToolSubTypes: the total quantity of each collected tool type
	String[] getToolSubTypes(GenBeam gbs[], int& numToolSubTypes[])
	{ 
		String toolSubTypes[0];
		numToolSubTypes.setLength(0);
		
		for (int i=0;i<gbs.length();i++)
		{ 
			GenBeam& gb = gbs[i];
			if (gb.bIsDummy()){ continue;}
			AnalysedTool ats[]=gb.analysedTools();
			for (int j=0;j<ats.length();j++) 
			{ 
				String toolSubType =ats[j].toolSubType(); 
				int n = toolSubTypes.findNoCase(toolSubType ,- 1);
				if (n<0)
				{
					toolSubTypes.append(toolSubType);
					numToolSubTypes.append(1);						
				}
				else
				{ 
					numToolSubTypes[n]++;
				}
			}//next j			
		}		
		
		return toolSubTypes;
	}//End getToolSubTypes //endregion

//region Function filterToolSubTypes
	// returns the analysed tools of the specified subtypes
	// ats: the analysed tools
	// toolSubTypes: a list of tool subtypes
	AnalysedTool[] filterToolSubTypes(AnalysedTool ats[], String toolSubTypes[])
	{ 
		AnalysedTool out[0];
		if (toolSubTypes.length()<1)
		{
			return ats;			
		}
		for (int i=0;i<ats.length();i++) 
		{ 
			AnalysedTool a = ats[i];
			//reportNotice("\n"+a.toolSubType());
			if (toolSubTypes.findNoCase(a.toolSubType(),-1)>-1)
			{
				//reportNotice("...accepted");
				out.append(ats[i]); 
			}
			 
		}//next i
		return out;
	}//End filterToolSubTypes //endregion

//region Function filterToolsByToolEnt
	// returns
	// t: the tslInstance to 
	AnalysedTool[] filterToolsByToolEnt(AnalysedTool ats[], Entity ent)
	{ 
		AnalysedTool out[0];
		//reportNotice("\nfilterToolsByToolEnt: ent= " + ent.formatObject("@(Handle) - @(scriptName:D)"));// @(typeName:D)"
		for (int i=0;i<ats.length();i++) 
		{ 
			AnalysedTool a = ats[i];
			//reportNotice("\nfilterToolsByToolEnt: filter " + a.toolType() + "--" +  a.toolEnt().formatObject("@(Handle) - @(scriptName:D)"));// @(typeName:D)"
			
			if (a.toolEnt()==ent)
			{
				out.append(ats[i]); 
				//reportNotice("...ok");
			}
		}//next i		
		
		return out;
	}//End filterToolsByToolEnt //endregion



	//endregion 

//region Mixed Functions

//region Function NumViewports
	// returns the amount of viewports within the designated space
	int NumViewports()
	{ 
		int out;
		Entity ents[] = Group().collectEntities(true, Entity(), _kMySpace);
		for (int i=0;i<ents.length();i++) 
			if (ents[i].typeDxfName().makeUpper()=="VIEWPORT")
				out++;

		return out;
	
	}//endregion

//region Function PurgeViewportMap
	// removes any entry which is stored against the specified entity
	void PurgeViewportMap(Map& mapVieportGrips, Entity ent)
	{ 
	// remove any entry of the stored map as it will be rewritten
		for (int i=mapVieportGrips.length()-1; i>=0 ; i--) 
		{ 
			if(!mapVieportGrips.hasMap(i)){ continue;}
			Map m= mapVieportGrips.getMap(i); 
			Entity e= m.getEntity("ent");
			if (e.bIsValid() && e==ent)
				mapVieportGrips.removeAt(i, true);			
		}//next i
		return;
	}//endregion

//region Function collectTslsByName
	// returns the amount of all tsl instances with a certain scriptname and modifis the input array
	// tsls: the array to search, if empty all tsls in modelspace are taken
	// names: the names of the tsls to be returned
	int getTslsByName(TslInst& tsls[], String names[])
	{ 
		int out;
		
		if (tsls.length()<1)
		{ 
			Entity ents[] = Group().collectEntities(true, TslInst(),  _kModelSpace);
			for (int i=0;i<ents.length();i++) 
			{ 
				TslInst t= (TslInst)ents[i]; 
				//reportNotice("\ngetTslsByName: " + t.scriptName() +" "+names);
				if (t.bIsValid() && names.findNoCase(t.scriptName(),-1)>-1)
					tsls.append(t);
			}//next i
		}
		else
		{ 
			for (int i=tsls.length()-1; i>=0 ; i--) 
			{ 
				TslInst t= (TslInst)tsls[i]; 
				if (t.bIsValid() && names.findNoCase(t.scriptName(),-1)<0)
					tsls.removeAt(i);
			}//next i			
		}
		
		out = tsls.length();
		return out;
	
	}//End collectTslsByName //endregion

//region Function getGenBeamTsls
	// returns a list of tsls which are attached to a genbeam
	// gb: the genbeam
	// names[]: a list of scriptNames, all if empty
	TslInst[] getGenBeamTsls(GenBeam gb, String names[])
	{ 
		TslInst tsls[0];
		Entity tents[] = gb.eToolsConnected();
		
		for (int i = 0; i < tents.length(); i++)
		{
			TslInst t = (TslInst)tents[i];
			if (!t.bIsValid()){ continue;}
			
			String name = t.scriptName();
			if (sListExcludes.findNoCase(name,-1)>-1){ continue;}
			if (names.length()==0 || names.findNoCase(name,-1)>-1 || names.first()=="*")
				tsls.append(t);
		}
		
		return tsls;
	}//Function getGenBeamTsls //endregion 

//region Function getTSLRequests
	// returns the profile of a collection definition in the given view
	// t: the tsl instance
	// vecZView the model vecZ view direction
	Map[] getTSLRequests(TslInst t, Vector3d vecView, String sStereotypes[])
	{ 		
		Map out[0];

		//reportNotice("\n" + t.scriptName() + " vecView " + vecView + " stereo " + sStereotypes);

	// get from tsl _Map or from hsbInfo subMapX HSB-23162
		Map requests = t.map().getMap(kRequests); 
		if (requests.length()<1)
			requests = t.subMapX(kDimInfo);

	// no requests found, append origin
		if (requests.length()<1)
		{ 
			if (sStereotypes.length()<1)
			{
				Point3d nodes[] ={t.ptOrg()} ;
				Map m;
				m.setPoint3dArray(kNodes,nodes);
				m.setEntity("originator", t);
				out.append(m); 
			}
		}	
	// append requests	
		else
		{ 
			vecView.vis(t.ptOrg(),4);
			//vecAllowed.vis(t.ptOrg(),vecAllowed.isParallelTo(vecView)?3:1);
			
			//if (bDebug)	reportNotice("\n" + requests.length() + " requests collected of  " +t.scriptName() + " " + t.handle());
			String msg = "\n"+scriptName() + " " + _ThisInst.handle()+"\n";
			for (int j=0;j<requests.length();j++) 
			{ 
				
				Map m= requests.getMap(j);
				// HSB-24316 accepting default or custom stereotype
				String stereotype = m.getString("Stereotype").trimLeft().trimRight();
				int bValidStereotype = stereotype=="*" || sStereotypes.findNoCase(stereotype ,- 1) >- 1;				
				if (stereotype.length()>0 && !bValidStereotype)
				{ 
					if (bDebug)
						reportNotice(msg + "   '" + m.getString("Stereotype")+ T("' |refused|") + m);//HSB-24316 
					msg = "\n";
					continue;					
				}

				
			// Read request content			
				Point3d ptsChoord[] = m.getPoint3dArray(kCoords);							
				Vector3d vecAllowed = m.getVector3d(kAllowedView);
				int bAlsoReverse = m.getInt(kAlsoReverseDirection);
				Point3d nodes[] = m.getPoint3dArray(kNodes);

			// get coordSys from point list to overcome collectionEntity/block editor issue
				if (ptsChoord.length()==4)
					vecAllowed = ptsChoord[3] - ptsChoord[0];
				vecAllowed.normalize();
				
			// invalid request
				if (nodes.length()<1 || !vecAllowed.isParallelTo(vecView) || 
					(!bAlsoReverse && !vecAllowed.isCodirectionalTo(vecView)))
				{ 
					//if (bDebug)reportNotice("\n" + m.getString("Stereotype")+ " invalid view? " +vecAllowed + " vs " +vecView);
					continue;
				}

				//Point3d ptx = nodes.last();
				//ptx.vis(j);
				//ptx = nodes.first();
				//vecAllowed.vis(ptx, bIsParallel);
				
				m.setEntity("originator", t);
				out.append(m); 	
			}						
		}	
	
		return out;
	}//endregion 

//region Function getNestedGenBeams
	// returns a list of genbeams which are nested or part of the set
	// t: the tslInstance to 
	GenBeam[] getNestedGenBeams(Entity ents[])
	{ 
		GenBeam gbs[0];
	
		for (int i=0;i<ents.length();i++) 
		{ 
			GenBeam gb = (GenBeam)ents[i]; 
			if (gb.bIsValid())
			{
				gbs.append(gb);
				continue;
			}
			
			MetalPartCollectionEnt mpce = (MetalPartCollectionEnt)ents[i];			
			if (mpce.bIsValid())
			{
				MetalPartCollectionDef cd= mpce.definitionObject();
				gbs.append(cd.genBeam());
				continue;
			}
			
			TrussEntity te = (TrussEntity)ents[i];
			if (te.bIsValid())
			{
				String def = te.definition();
				TrussDefinition cd(def);
				gbs.append(cd.genBeam());
				continue;
			}
			
			CollectionEntity ce = (CollectionEntity)ents[i];
			if (ce.bIsValid())
			{
				String def = ce.definition();
				CollectionDefinition cd(def);
				gbs.append(cd.genBeam());
				continue;
			}			
			
			BlockRef bref = (BlockRef)ents[i];
			if (ce.bIsValid())
			{
				String def = bref.definition();
				Block block(def);
				gbs.append(block.genBeam());
				continue;
			}			 
		}//next i	
		for (int i=gbs.length()-1; i>=0 ; i--) 
			if (gbs[i].bIsDummy())
				gbs.removeAt(i); 

	
		return gbs;
	}//End getNestedGenBeams //endregion

//region Function GetUniqueCollectionDefinitions
	// returns a list of unique collectionDefinitions being part of the sset 
	// ents: the selection set
	String[] GetUniqueCollectionDefinitions(Entity ents[], CollectionEntity& ces[])
	{
		String out[0];
		for (int i = 0; i < ents.length(); i++)
		{
			Entity e = ents[i];
			CollectionEntity ce = (CollectionEntity)e;
			MetalPartCollectionEnt mpce = (MetalPartCollectionEnt)e;
			TrussEntity te = (TrussEntity)e;
			if (mpce.bIsValid())
			{ 
				ces.append(mpce);
				String def = mpce.formatObject("@(Definition)");
				if (def.length()>0 && out.findNoCase(def,-1)<0)
					out.append(def);
			}							
			else if (te.bIsValid())
			{ 
				ces.append(te);
				String def = te.definition();
				if (out.findNoCase(def,-1)<0)
					out.append(def);
			}				
			else if (ce.bIsValid())
			{ 
				ces.append(ce);
				String def = ce.definition();
				if (out.findNoCase(def,-1)<0)
					out.append(def);
			}	
		}		
		return out;
	}//endregion 

//region Function getUniqueBlockDefinitions
	// returns a list of unique block definitions being part of the sset 
	// ents: the selection set
	String[] getUniqueBlockDefinitions(Entity ents[], BlockRef& brefs[])
	{
		String out[0];
		for (int i = 0; i < ents.length(); i++)
		{
			Entity e = ents[i];
			BlockRef bref = (BlockRef)e;
			if (bref.bIsValid())
			{ 
				brefs.append(bref);
				String def = bref.definition();
				if (out.findNoCase(def,-1)<0)
					out.append(def);
			}	
		}		
		return out;
	}//Function getUniqueBlockDefinitions //endregion 

//region Function GetGenbeamBodies
	// returns a list of bodies excluding dummies as specified shape type
	// gbs: the selection set
	// shapeMode: the shape mode 0=real, 1=basic, 2 = envelope
	Body[] GetGenbeamBodies(GenBeam& gbs[], int shapeMode)
	{
		//reportNotice("\nXX GetGenbeamBodies:");
		Body out[0];
		for (int i=gbs.length()-1; i>=0 ; i--) 		
		{ 
			GenBeam g = gbs[i];
			if (g.bIsDummy())
				gbs.removeAt(i);
			else
			{ 
				Body bd;
				if (shapeMode==0)
					bd = g.realBody();
				else if (shapeMode==1)
					bd = g.envelopeBody(true, true);
				else if (shapeMode==2)
					bd = g.envelopeBody();					
				if (!bd.isNull())
					out.append(bd);
				else
					gbs.removeAt(i);
			}	
		}

		
		return out;
	}//endregion 

//region Function GetEntitySolids
	// returns a list of bodies as specified shape type
	// solids: the selection set
	// shapeMode: the shape mode 0=real, 1=basic, 2 = envelope
	Body[] GetEntitySolids(Entity& solids[], int shapeMode)
	{ 
		Body out[0];
		for (int i=solids.length()-1; i>=0 ; i--) 
		{ 
			Entity e = solids[i];

			Body bd;
			if (shapeMode<2)
				bd = e.realBody();			
			else
			{
				Quader q = e.bodyExtents();			
				if (q.dX()>dEps && q.dY()>dEps && q.dZ()>dEps)
				{ 
					bd = Body(q.pointAt(0, 0, 0), q.vecX(), q.vecY(), q.vecZ(), q.dX(), q.dY(), q.dZ(), 0, 0, 0);
				}
			}
			if (!bd.isNull())
				out.append(bd);
			else
				solids.removeAt(i);				
			 
		}//next i		
		return out;
	}//endregion



//region Function drawPLine,DrawPlaneProfile
	void drawPLine(PLine pl, double offset,  int color, int fillTransparent)
	{ 
		Display dp(color);
		pl.transformBy(pl.coordSys().vecZ() * offset);
		if (fillTransparent>0)
			dp.draw(PlaneProfile(pl), _kDrawFilled, fillTransparent);
		else
			dp.draw(pl);
	}
	void DrawPlaneProfile(PlaneProfile pp, double offset,  int color, int fillTransparent)
	{ 
		Display dp(color);
		pp.transformBy(pp.coordSys().vecZ() * offset);
		if (fillTransparent>0)
			dp.draw(pp, _kDrawFilled, fillTransparent);
		else
			dp.draw(pp);
	}
	void DrawPlaneProfile2(PlaneProfile pp, double offset,  int color, int fillTransparent, Display dp)
	{ 
		dp.color(color);
		pp.transformBy(pp.coordSys().vecZ() * offset);
		if (fillTransparent>0)
			dp.draw(pp, _kDrawFilled, fillTransparent);
		else
			dp.draw(pp);
	}//endregion 	

//region Function GetInfiniteProfileInDir
	// returns an infinite profile in the specified direction
	PlaneProfile GetInfiniteProfileInDir(PlaneProfile pp, Vector3d vecInfiniteDir)
	{ 
		CoordSys cs = pp.coordSys();
		Vector3d vecZ = cs.vecZ();	vecZ.normalize();
	
		Vector3d vecX = vecInfiniteDir;
		Vector3d vecY = vecX.crossProduct(-vecZ);	

		LineSeg seg = pp.extentInDir(vecX);
		double dX = abs(vecX.dotProduct(seg.ptEnd() - seg.ptStart()));
		double dY = abs(vecY.dotProduct(seg.ptEnd() - seg.ptStart()));
		if (dY <= dEps)dY = 3*dEps; // arbitrary dimension to resolve empty input
		
		PlaneProfile ppOut(cs);
		Vector3d vec = .5 * vecY * dY + vecX *U(10e6);
		ppOut.createRectangle(LineSeg(seg.ptMid() - vec, seg.ptMid() + vec), vecX, vecY);
		return ppOut;
		
	} //endregion

//region Function createOpeningGripLocations
	// creates the grips based on openings and dimline direction 
	// ppPerp: a planeprofile carrying the coordSys of the dimline
	Point3d[] getOpeningGripLocations(PlaneProfile ppDir, Vector3d vecDir, PlaneProfile pps[])
	{ 
		CoordSys cs = ppDir.coordSys();
		Vector3d vecZ = cs.vecZ(); vecZ.normalize();
		Vector3d vecX = vecDir;
		Vector3d vecY = vecX.crossProduct(-vecZ);
		
		Line lnPerp(_Pt0, vecY);
		PlaneProfile ppPerp = GetInfiniteProfileInDir(ppDir, vecY);

	// collect opening shapes
		PlaneProfile ppx(cs);
		for (int i=0;i<pps.length();i++) 
		{ 
			PlaneProfile pp = GetInfiniteProfileInDir(pps[i], vecX);
			pp.intersectWith(ppPerp);	//pp.vis(i); 
			ppx.unionWith(pp);		 
		}//next i

	// collect points of unique common regions
		Point3d pts[0];
		PLine rings[] = ppx.allRings();	//reportNotice("\ncreateOpeningGripLocations: rings="  + rings.length());
		for (int r=0;r<rings.length();r++) 
		{ 
			PlaneProfile pp(rings[r]);
			Point3d pt = pp.ptMid(); //pt.vis(r + 1);
			pts.append(pt);		 
		}//next r
		pts = lnPerp.orderPoints(pts, dEps);
		//reportNotice("\ncreateOpeningGripLocations: pts="  + pts.length());
		//ppx.vis(5);

		return pts;
	}//End getOpeningGripLocations //endregion
	
	//region Function linkPointToOpenings
	// returns openings linked to the given point
	Opening[] linkPointToOpenings(Point3d pt, Vector3d vecDir,Opening openings[], PlaneProfile pps[])
	{ 
		Opening out[0];
	// get extended opening shape
		for (int i=0;i<pps.length();i++) 
		{ 
			Opening o = openings[i];
			PlaneProfile pp(o.element().coordSys());
			pp.joinRing(o.plShape(), _kAdd);
			pp = GetInfiniteProfileInDir(pps[i], vecDir);	//pp.vis(4);
			if (pp.pointInProfile(pt)!=_kPointOutsideProfile)
				out.append(o);
		}//next i
		
		return out;
	}//End linkPointToOpenings //endregion	

	//region Function getReferencePoints
	// returns refernce points based on an optionl snap area considering refpoint mode and related points
	// vecDir: the direction of the dimline
	// vecPerp: the perp direction of the dimline
	// vecSide: the side vector of the dimline
	// ptsRef: the refpoints to be filtered
	// ptsX: optional points used if snap mode is closest
	// nRefPointMode: different point modes like closest, first etc
	// ppSnap: an offsetted contour to attach guide lines to
	Point3d[] getReferencePoints(Vector3d vecDir, Vector3d vecPerp, Vector3d vecSide, Point3d ptsRef[],Point3d ptsX[], int nRefPointMode, PlaneProfile ppSnap)
	{ 
		Point3d out[0];
		Line lnDir(_Pt0, vecDir);
		
	// Get reference points
		ptsRef = lnDir.orderPoints(ptsRef);
		if (ptsRef.length()>0)
		{ 
			Point3d pts[0];
			if (nRefPointMode==0 || nRefPointMode==2 ||nRefPointMode==4) // first point
				pts.append(ptsRef.first());
			if (nRefPointMode==0 || nRefPointMode==3 ||nRefPointMode==4) // last point
				pts.append(ptsRef.last());
			if (nRefPointMode==5  && ptsX.length()>0)	//tPMClosestPoint
			{ 
				Point3d pt = ptsRef.first();
				double dMax = U(10e5);
				for (int i=0;i<ptsRef.length();i++) 
				{ 
					double d1 =abs(vecDir.dotProduct(ptsX.first()-ptsRef[i])); 
					double d2 =abs(vecDir.dotProduct(ptsX.last()-ptsRef[i]));
					
					if (d1 < dMax){pt = ptsRef[i]; dMax = d1;}
					if (d2 < dMax){pt = ptsRef[i]; dMax = d2;}
					
				}//next i
				
				//PLine (pt,_PtW).vis(3);
				pts.append(pt);
			}
			
			pts = lnDir.orderPoints(pts, dEps);	
			for (int i=0;i<pts.length();i++) 
			{ 
				Point3d& pt = pts[i];
				
				if (ppSnap.area()>pow(dEps,2) && !vecSide.bIsZeroLength())
				{ 
					Point3d _pts[] = Line(pt, -vecSide).orderPoints(ppSnap.intersectPoints(Plane(pt, vecDir), true, false));
					if (_pts.length()>0)
						pt = _pts.first();					
				}

				out.append(pt);		//pt.vis(1);

			}//next i	
		}

		return out;
	}//End getReferencePoints //endregion
			
	//endregion 	

//region Functions Grip Management
	
//region Function GetGripsFromMap
	// returns grips which are stored in map based on a reference to an entity
	Grip[] GetGripsFromMap(Map map, Entity ent)
	{ 
		Grip grips[0];
		for (int i=0;i<map.length();i++) 
		{ 
			if(!map.hasMap(i)){ continue;}
			Map m= map.getMap(i); 
			
			Entity e= m.getEntity("ent");
			if (!e.bIsValid() || e!=ent){ continue;}
			
			Point3d pt = m.getPoint3d("ptLoc");
			Vector3d vecx = m.hasVector3d("vecX")?m.getVector3d("vecX"):_XW;
			Vector3d vecy = m.hasVector3d("vecY")?m.getVector3d("vecY"):_ZW;
			String toolTip = m.getString("toolTip");
			String stream = m.getDxContent(true);					
			Grip g;
			g.setName(stream);
			g.setPtLoc(pt);
			g.setVecX(vecx); 
			g.setVecY(vecx.crossProduct(-_ZW));
			g.setColor(4);
			g.setShapeType(_kGSTCircle);
			g.setIsRelativeToEcs(false);//XX
			g.setToolTip(toolTip);
			grips.append(g);								
		}	
		return grips;
	}//endregion
	
//region Function CreateGrip
	// creates a grip based on map data.returns a grip
	Grip CreateGrip(Map mapStream, Point3d ptLoc, int color, int shapeType, String toolTip)
	{ 
		Vector3d vecX = mapStream.hasVector3d("vecX")?mapStream.getVector3d("vecX"):_XW;
		Vector3d vecY = mapStream.hasVector3d("vecY")?mapStream.getVector3d("vecY"):_YW;

		int bIsRelativeToEcs = mapStream.hasInt("IsRelativeToEcs")?mapStream.getInt("IsRelativeToEcs"):false;

		String name = mapStream.getDxContent(true);
		
		Grip g;
		g.setName(name);
		g.setPtLoc(ptLoc);
		g.setVecX(vecX);
		g.setVecY(vecY);
		g.setColor(color);
		g.setToolTip(toolTip);
		g.setIsRelativeToEcs(bIsRelativeToEcs);
		g.setShapeType(shapeType);
		
		return g;
	}//endregion	
	
	//endregion 

//region Functions Gable Combine Segments

	//region Function collectNonOrthoSegements
	// returns all outer segements which are not orthogonal to the parent coordSys
	// t: the tslInstance to 
	LineSeg[] collectNonOrthoSegements(PlaneProfile pp)
	{ 
		CoordSys cs = pp.coordSys();
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();
		Vector3d vecZ = cs.vecZ();
		
		LineSeg segs[0];

		PLine rings[]=pp.allRings(true, false);
		for (int r = 0; r < rings.length(); r++)
		{
			PLine pl = rings[r];
			pl.simplify();
			Point3d pts[] = pl.vertexPoints(false);
			for (int p = 0; p < pts.length() - 1; p++)
			{
				Point3d pt1 = pts[p];
				Point3d pt2 = pts[p + 1];
				
				Point3d ptm = (pt1 + pt2) * .5;
				Vector3d vecXP = pt2 - pt1;
				if (vecXP.length() < dEps) { continue; }
				vecXP.normalize();
				if (vecXP.isParallelTo(vecX) || vecXP.isParallelTo(vecY)) { continue; }

				LineSeg seg(pt1, pt2);
				seg.transformBy(vecZ * U(5));
				segs.append(seg);
				
			}// next p
		}// next r

//		for (int i=0;i<segs.length();i++)
//		{ 
//			LineSeg seg = segs[i];
//			seg.transformBy(vecZ * U(10));
//			seg.transformBy(vecZ * (U(12)+(i*U(1))));
//			seg.vis(i);
//		}

		return segs;	
	}//End collectNonOrthoSegements //endregion

	//region Function getSegmentDirections
	// returns a unique list of vecX of the segments passed in
	Vector3d[] getSegmentDirections(LineSeg segs[])
	{
		Vector3d out[0];
		
		for (int i=0;i<segs.length();i++) 
		{ 
			Vector3d vecDir = segs[i].ptEnd()-segs[i].ptStart();
			vecDir.normalize();
			//vecDir.vis(segs[i].ptMid(), i);
			
			vecDir.normalize();
			if (i==0)
				out.append(vecDir);
			else
			{ 
				int bFound;
				for (int j=0;j<out.length();j++) 
				{ 
					double d = out[j].dotProduct(vecDir);					
					if (out[j].isParallelTo(vecDir) || abs(d)>.99999)
					{
						bFound=true;
						break;
					}

					if (!bFound)
						out.append(vecDir);	
				}

			}
		}//next i
	
		return out;
	
	}//End getSegmentDirections //endregion

	//region Function combineSegments
	// tries to combine segments which are nearly parallel and also nearly connecting // sheet tolerance issue on gable walls
	// t: the tslInstance to 
	LineSeg[] combineSegments(LineSeg segs[], PlaneProfile pp, Vector3d vecDir)
	{ 
		
		CoordSys cs = pp.coordSys();
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();
		Vector3d vecZ = cs.vecZ();		
		
		LineSeg out[0];
		
		Vector3d vecPerp = vecDir.crossProduct(vecZ);
		
	// collect nearly parallels	
		LineSeg segsX[0];
		for (int i=0;i<segs.length();i++) 
		{ 
			LineSeg seg = segs[i];
			Vector3d vec = seg.ptEnd() - seg.ptStart(); vec.normalize();
			double d = vec.dotProduct(vecDir);					
			if (vec.isParallelTo(vecDir) || abs(d)>.99999)
				segsX.append(seg);
		}//next i
		
	// unify direction	
		for (int i = 0; i < segsX.length(); i++)
		{
			LineSeg& seg = segsX[i];
			Point3d pt2 = seg.ptEnd();
			Point3d pt1 = seg.ptStart();
			if ((pt2 - pt1).dotProduct(vecDir) < 0)
			{
				pt1 = pt2;
				pt2 = seg.ptStart();
				seg = LineSeg(pt1, pt2);
			}
		}
		
		
	// order byDir
		for (int i=0;i<segsX.length();i++) 
			for (int j=0;j<segsX.length()-1;j++) 
			{	
				double d1 = vecDir.dotProduct(segsX[j].ptStart() - _PtW);
				double d2 = vecDir.dotProduct(segsX[j+1].ptStart() - _PtW);

				if (d2<d1)
					segsX.swap(j, j + 1);
			}

	// try to combine
		LineSeg segsC[0];
		
		for (int i=0;i<segsX.length();i++)
		{ 
			LineSeg seg = segsX[i];
			Point3d pt2 = seg.ptEnd();
			Point3d pt1 = seg.ptStart();

			if(i==0)
			{
				segsC.append(seg);
				seg.transformBy(vecZ * U(10));
			}
			else
			{ 
				LineSeg& segC = segsC.last();//[last];
				Point3d ptC2 = segC.ptEnd();
				Point3d ptC1 = segC.ptStart();
			// not nearly colinear	
				if (abs(vecPerp.dotProduct(segC.ptMid()-seg.ptMid()))>dEps)
				{ 
					segsC.append(seg);					
				}
			// start and end nearly touching	
				else if (abs(vecDir.dotProduct(pt1-ptC2)<dEps))
				{ 
					ptC2 = ptC1 + vecDir * vecDir.dotProduct(pt2 - ptC1);	//ptC2.vis(32);
					segC = LineSeg(ptC1, ptC2);
				}
			// not touching	
				else
					segsC.append(seg);
			}	
		}
		
		
	// make sure pointing to the outside
		for (int i=0;i<segsC.length();i++)
		{ 
			LineSeg seg = segsC[i];
			Vector3d vecXC = seg.ptEnd() - seg.ptStart(); vecXC.normalize();
			Vector3d vecYC = vecDir.crossProduct(-vecZ);
			
			if (pp.pointInProfile(seg.ptMid()+vecYC*dEps)!=_kPointOutsideProfile)
			{ 
				seg = LineSeg(seg.ptEnd(), seg.ptStart());
			}
			out.append(seg);
		}
		return out;
	
	}//End combineSegments //endregion

			
	//endregion 

	
//region Function AppendElementSubSet
	// returns all entities of show and ref set and appends sub entities of the given element
	// activeZoneIndex: used for viewports else 999 = all
	Entity[] AppendElementSubSet(Element element, PainterDefinition pdShow, PainterDefinition pdRef,String typeDim, Opening& openingSet[], Entity& entsShowSet[], Entity& entsRefSet[], int activeZoneIndex)
	{ 
		Entity ents[] ={ element};

		AppendGenBeams(ents, element.genBeam());
		AppendTsls(ents, element.tslInst());
	
		if (typeDim== "TrussEntity")
		{ 
			AppendEntities(ents, element.elementGroup().collectEntities(true, TrussEntity(),_kModelSpace));
		}
		else if  (typeDim == "Opening" || typeDim == "OpeningSF")
		{ 
			openingSet.append(element.opening());
			AppendOpenings(ents, openingSet);
		}

		Entity entsAll[0];
		if (pdShow.bIsValid())
		{
			AppendEntities(entsShowSet, pdShow.filterAcceptedEntities(ents));
			if (entsShowSet.find(element)<0 && (typeDim == "Opening" || typeDim == "OpeningSF"))// might be removed when using painter
				entsShowSet.append(element); 
			entsAll = entsShowSet;
		}
		else
		{ 
			for (int i=0;i<ents.length();i++) 
				if ((ents[i].myZoneIndex()==activeZoneIndex || activeZoneIndex==999) && entsShowSet.find(ents[i])<0)
					entsShowSet.append(ents[i]);	
			entsAll = entsShowSet;		
		}
		if (pdRef.bIsValid())
		{
			AppendEntities(entsRefSet, pdRef.filterAcceptedEntities(ents));
			if (entsRefSet.find(element)<0 && (typeDim == "Opening" || typeDim == "OpeningSF"))// might be removed when using painter
				entsRefSet.append(element); 			
			entsAll.append(entsRefSet);
		}
		else
		{ 
			for (int i=0;i<ents.length();i++) 
				if ((ents[i].myZoneIndex()==activeZoneIndex || activeZoneIndex==999) && entsRefSet.find(ents[i])<0)
					entsRefSet.append(ents[i]);	
			entsAll.append(entsRefSet);			
		}
		if (!pdShow.bIsValid() || !pdRef.bIsValid())
		{
			for (int i=0;i<ents.length();i++) 
				if (entsAll.find(ents[i])<0 &&(ents[i].myZoneIndex()==activeZoneIndex || activeZoneIndex==999))
					entsAll.append(ents[i]);
		}

		return entsAll;
	}//endregion	
	

//END Functions //endregion 

//region Part #1 Jigs

//region JIG //#J

	String kJigSelectDiagonal = "JigSelectDiagonal",kJigSetTool="SetToolJig",kJigSetAlignment="SetAlignment"
	, kJigCopy = "CopyJig", kJigAddOffset = "AddOffset", kJigAddPoints="AddPoints";

//region Set Tool Jig
	if (_bOnJig && _kExecuteKey == kJigSetTool)
	{
		Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point
		
		Point3d ptRef = _Map.getPoint3d("ptRef");
		Point3d pts[] = _Map.getPoint3dArray("pts");
		pts.append(_PtG);

		Vector3d vecDir = _Map.getVector3d("vecDir");
		Vector3d vecX = _Map.getVector3d("vecX");
		Vector3d vecY = _Map.getVector3d("vecY");
		Vector3d vecZ = _Map.getVector3d("vecZ");
		String sDimStyle= _Map.getString("dimStyle");
		double scale =  _Map.getDouble("Scale");
		scale = scale > 0?scale : 1;
		double dTextHeight =  _Map.getDouble("textHeight");
		String text= _Map.getString("text");
		int nChainMode = _Map.getInt("chainMode");
		int nDeltaMode = _Map.getInt("deltaMode");
		Plane pnZ(ptRef, vecZ);
		Line(ptJig, vecZ).hasIntersection(pnZ, ptJig);

		Vector3d vecPerp = vecDir.crossProduct(-vecZ);		

		Display dp(-1);	
		PlaneProfile pps[0];
		int selects[0];
		Map mapDims[0];
		Map mapShapes = _Map.getMap("Shapes");
		
		for (int i=0;i<mapShapes.length();i++) 
		{ 
			if (mapShapes.hasPlaneProfile(i))
				pps.append(mapShapes.getPlaneProfile(i)); 
			else if (mapShapes.hasInt(i))
				selects.append(mapShapes.getInt(i)>0);
			else if (mapShapes.hasPoint3dArray(i))
			{
				Map m;
				m.setPoint3dArray("ptDims", mapShapes.getPoint3dArray(i));
				mapDims.append(m);					
			}
		}//next i
	
	// draw jig
		for (int i = 0; i < pps.length(); i++)
		{ 	
			int bSelected;
			if (selects.length() > i) bSelected = selects[i];

			PlaneProfile pp = pps[i];
			Point3d pt=ptJig;
			Line(pt, vecZView).hasIntersection(Plane(pp.coordSys().ptOrg(), pp.coordSys().vecZ()), pt);

			int bHover = pp.pointInProfile(pt) != _kPointOutsideProfile;
			
			// add dimpoints of tool
			if ((bHover || bSelected) && mapDims.length()>i)
			{ 
				pts.append(mapDims[i].getPoint3dArray("ptDims"));
			}

			if (bHover)
			{
				dp.trueColor(darkyellow, bSelected?40:60);
				dp.draw(pp,_kDrawFilled);
				
				if (bSelected)
				{ 
					dp.trueColor(red,0);
					dp.draw(pp);
				}
				
			}
			else
			{
				dp.trueColor(bSelected?darkyellow:lightblue,bSelected?40:60);
				dp.draw(pp,_kDrawFilled);
				if (bSelected)
				{ 
					dp.trueColor(white,0);
					dp.draw(pp);					
				}
			}

		}//next i		


		dp.trueColor(red);
		dp.dimStyle(sDimStyle, 1/scale);
		double textHeight = dTextHeight>0?dTextHeight:dp.textHeightForStyle("O", sDimStyle)*scale;
		dp.textHeight(textHeight);


		DimLine dl(ptRef, vecDir, vecPerp);
		dl.setUseDisplayTextHeight(true);
		Dim dim(dl,  pts, "<>",  "<>", nDeltaMode, nChainMode); 
		dim.setReadDirection(5*vecYView - vecXView);
		dim.setDeltaOnTop(_Map.getInt(kDeltaOnTop));
		dp.draw(dim);
		return;
	}//endregion	
 
//region JigCopy
	else if (_bOnJig && _kExecuteKey ==kJigCopy)
	{
		Point3d ptJig = _Map.getPoint3d("_PtJig");

		Point3d pts[] = _Map.getPoint3dArray("pts");
		pts.append(_PtG);

		Vector3d vecDir = _Map.getVector3d("vecDir");
		Vector3d vecX = _Map.getVector3d("vecX");
		Vector3d vecY = _Map.getVector3d("vecY");
		Vector3d vecZ = _Map.getVector3d("vecZ");
		String sDimStyle= _Map.getString("dimStyle");
		double scale =  _Map.getDouble("Scale");
		scale = scale > 0?scale : 1;
		double dTextHeight =  _Map.getDouble("textHeight");
		String text= _Map.getString("text");
		int nChainMode = _Map.getInt("chainMode");
		int nDeltaMode = _Map.getInt("deltaMode");

		Point3d ptRef = ptJig;
		Plane pnZ(ptRef, vecZ);
		Line(ptJig, vecZ).hasIntersection(pnZ, ptRef);
		
		
		Vector3d vecPerp = vecDir.crossProduct(-vecZ);		

		Display dp(-1);

		dp.dimStyle(sDimStyle, scale);
		double textHeight = dTextHeight>0?dTextHeight:dp.textHeightForStyle("O", sDimStyle)*scale;
		dp.textHeight(textHeight);


		DimLine dl(ptRef, vecDir, vecPerp);
		dl.setUseDisplayTextHeight(true);
		Dim dim(dl,  pts, "<>",  "<>", nDeltaMode, nChainMode); 
		dim.setReadDirection(5*vecYView - vecXView);
		dim.setDeltaOnTop(_Map.getInt(kDeltaOnTop));
		dp.draw(dim);
		return;


		return;
	}//endregion
	
//region Viewport Selection Jig
	else if (_bOnJig && _kExecuteKey == "SelectViewport")
	{
		Point3d ptJig = _Map.getPoint3d("_PtJig"); //running point
		Plane pnZ(_PtW, _ZW);
		Line(ptJig, vecZView).hasIntersection(pnZ, ptJig);
		Map mapViewports = _Map.getMap("Viewport[]");
		PlaneProfile pps[0];
		for (int i = 0; i < _Map.length(); i++)
		{
			PlaneProfile pp = _Map.getPlaneProfile(i);
			pps.append(pp);
		}			
		Display dp(-1);

	// get closest view
		int n = -1;
		double dDist = U(10e6);
		
		for (int i = 0; i < pps.length(); i++)
		{
			double d = Vector3d(ptJig - pps[i].closestPointTo(ptJig)).length();
			if (d < dDist)
			{
				dDist = d;
				n = i;
			}
		}		
		
	// draw jig
		for (int i = 0; i < pps.length(); i++)
		{ 	
			PlaneProfile pp = pps[i];
			if (i==n)
			{ 
				PlaneProfile pp2 = pp;
				pp2.shrink(dViewHeight / 200);

				dp.trueColor(darkyellow, 50);
				dp.draw(pp2,_kDrawFilled);

				dp.color(1);
				dp.draw(pp);				
				pp.subtractProfile(pp2);
				dp.draw(pp,_kDrawFilled);
			}
			else
			{ 
				dp.trueColor(lightblue, 50);
				dp.draw(pp,_kDrawFilled);
			}
 
		}//next i				
		return;
	}		
//endregion 

//region Set Alignment Jig
	else if (_bOnJig && _kExecuteKey == kJigSetAlignment)
	{		
		//reportNotice("\nAli Jig");//TODO XX
		Point3d ptJig = _Map.getPoint3d("_PtJig");
		Point3d ptRef = _Map.getPoint3d("ptRef");
		Point3d pt1 = _Map.getPoint3d("pt1");
		Point3d pts[] = _Map.getPoint3dArray("pts");
		Vector3d vecDir = _Map.getVector3d("vecDir");
		Vector3d vecX = _Map.getVector3d("vecX");
		Vector3d vecY = _Map.getVector3d("vecY");
		Vector3d vecZ = _Map.getVector3d("vecZ");
		String sDimStyle= _Map.getString("dimStyle");
		double scale =  _Map.getDouble("Scale");
		scale = scale > 0?scale : 1;
		double dTextHeight =  _Map.getDouble("textHeight");
		String text= _Map.getString("text");
		int nChainMode = _Map.getInt("chainMode");
		int nDeltaMode = _Map.getInt("deltaMode");
		int bDeltaOnTop = _Map.getInt(kDeltaOnTop);
		PlaneProfile pp = _Map.getPlaneProfile("Shadow");
		LineSeg seg = pp.extentInDir(vecX);
		
		Plane pnZ(ptRef, vecZ);
		Line(ptJig, vecZ).hasIntersection(pnZ, ptJig);
		//text += scale + " txtH: " + dTextHeight;
		
		if (vecDir.bIsZeroLength()) // setting new alignment
		{ 
			vecDir =ptJig - pt1;
			vecDir.normalize();	
			
//			if (!_Map.hasPoint3d("ptRef")) // setting new location
//				ptRef = pt1;

		// show only extents, TODO get relevant points in perp direction	
			if (pp.area()>pow(dEps,2))
			{ 
				LineSeg seg = pp.extentInDir(vecDir);
				pts.append(seg.ptStart());
				pts.append(seg.ptEnd());				
			}
			else
				pts.append(ptJig);
		}
		else if (!_Map.hasPoint3d("ptRef")) // setting new location
			ptRef = ptJig;
		else
			pts.append(ptJig);
			
			
		Vector3d vecPerp = vecDir.crossProduct(-vecZ);
		
		int bDimOnTop = vecPerp.dotProduct(ptJig- seg.ptMid())>0?false: true; // HSB-24114
		int deltaOnTop = bDeltaOnTop;
		if (!bDimOnTop)deltaOnTop =!deltaOnTop;
		
		Display dp(-1);
		dp.dimStyle(sDimStyle, 1/scale);
		double textHeight = dTextHeight>0?dTextHeight:dp.textHeightForStyle("O", sDimStyle)*scale;
		dp.textHeight(textHeight);



		dp.trueColor(lightblue, 50);
		dp.draw(pp, _kDrawFilled);
		
		dp.color(-1);
		dp.transparency(0);
		
		Line lnDir(ptRef, vecDir);
		pts = lnDir.orderPoints(pts, dEps);
		
		if (pts.length()>1)
		{ 
			DimLine dl(ptRef, vecDir, vecPerp);
			dl.setUseDisplayTextHeight(textHeight!=0);
			
			Dim dim(dl,  pts, "<>",  "<>", nDeltaMode, nChainMode); 
			dim.setReadDirection(5*vecYView - vecXView);
			dim.setDeltaOnTop(deltaOnTop);
			dp.draw(dim);			
		}

		
		int nDir = 1;
		Vector3d vecDirText = vecDir*(vecDir.dotProduct(vecXView)<0?-1:1);
		Vector3d vecPerpText = vecDirText.crossProduct(-vecZ);
		if (pts.length()>0)
		{ 
			Point3d pt;pt.setToAverage(pts);
			if (vecDirText.dotProduct(ptRef - pt) < 0)nDir *= -1;
		}
		dp.draw(text, ptRef, vecDirText, vecPerpText, nDir, 0);			

		return;
	}		
//endregion 

//region Add Points Jig
	else if (_bOnJig && _kExecuteKey ==kJigAddPoints)
	{
		reportNotice("\nAdd");//TODO XX
		Point3d ptJig = _Map.getPoint3d("_PtJig");
		Point3d ptRef = _Map.getPoint3d("ptRef");
		Point3d pts[] = _Map.getPoint3dArray("pts");
		pts.append(_PtG);

		Vector3d vecDir = _Map.getVector3d("vecDir");
		Vector3d vecX = _Map.getVector3d("vecX");
		Vector3d vecY = _Map.getVector3d("vecY");
		Vector3d vecZ = _Map.getVector3d("vecZ");
		String sDimStyle= _Map.getString("dimStyle");
		double scale =  _Map.getDouble("Scale");
		scale = scale > 0?scale : 1;
		double dTextHeight =  _Map.getDouble("textHeight");
		String text= _Map.getString("text");
		int nChainMode = _Map.getInt("chainMode");
		int nDeltaMode = _Map.getInt("deltaMode");
		Plane pnZ(ptRef, vecZ);
		Line(ptJig, vecZ).hasIntersection(pnZ, ptJig);

		Vector3d vecPerp = vecDir.crossProduct(-vecZ);
		
		Display dp(3);
		dp.trueColor(red);
		dp.dimStyle(sDimStyle, 1/scale);
		double textHeight = dTextHeight>0?dTextHeight:dp.textHeightForStyle("O", sDimStyle)*scale;
		dp.textHeight(textHeight);

		pts.append(ptJig);
		Line lnDir(ptRef, vecDir);
		pts = lnDir.orderPoints(pts, dEps);
		
		
		PLine pl(ptJig, lnDir.closestPointTo(ptJig));
		dp.draw(pl);
		
		DimLine dl(ptRef, vecDir, vecPerp);
		dl.setUseDisplayTextHeight(true);
		Dim dim(dl,  pts, "<>",  "<>", nDeltaMode, nChainMode); 
		dim.setReadDirection(5*vecYView - vecXView);
		dim.setDeltaOnTop(_Map.getInt(kDeltaOnTop));
		dp.draw(dim);
		
		int nDir = 1;
		Vector3d vecDirText = vecDir*(vecDir.dotProduct(vecXView)<0?-1:1);
		Vector3d vecPerpText = vecDirText.crossProduct(-vecZ);
		if (pts.length()>0)
		{ 
			Point3d pt;pt.setToAverage(pts);
			if (vecDirText.dotProduct(ptRef - pt) < 0)nDir *= -1;
		}
		dp.draw(text, ptRef, vecDirText, vecPerpText, nDir, 0);			

		return;
	}		
//endregion 

//region Remove Points Jig
	else if (_bOnJig && _kExecuteKey == "RemovePoints")
	{
		Point3d ptJig = _Map.getPoint3d("_PtJig");
		Point3d ptRef = _Map.getPoint3d("ptRef");
		Point3d pts[] = _Map.getPoint3dArray("pts");
		Point3d ptsRemovals[] = _Map.getPoint3dArray("ptsRemovals");
		Vector3d vecDir = _Map.getVector3d("vecDir");
		Vector3d vecZ = _Map.getVector3d("vecZ");
		String sDimStyle= _Map.getString("dimStyle");
		double scale =  _Map.getDouble("Scale");
		scale = scale > 0?scale : 1;		
		double dTextHeight =  _Map.getDouble("textHeight");
		double maxDiam = _Map.getDouble("maxDiam");

		Plane pnZ(ptRef, vecZ);
		Line(ptJig, vecZ).hasIntersection(pnZ, ptJig);
		
		Line lnDir(ptRef, vecDir);
		
		Display dp(-1);
		dp.dimStyle(sDimStyle, 1/scale);
		double textHeight = dTextHeight>0?dTextHeight:dp.textHeightForStyle("O", sDimStyle)*scale;
		dp.textHeight(textHeight);

		double diam = dViewHeight / 40;
		diam = diam > maxDiam ? maxDiam : diam;
		for (int i=0;i<pts.length();i++) 
		{ 
			Point3d ptX = pts[i];
			PLine circle;
			circle.createCircle(ptX, vecZ,diam) ; 
			circle.convertToLineApprox(dEps);
			
			PLine pl(ptX, lnDir.closestPointTo(ptX));
			
			PlaneProfile pp(circle);
			int bRemove = pp.pointInProfile(ptJig) != _kPointOutsideProfile;
			for (int j=0;j<ptsRemovals.length();j++) 
			{ 
				if (Vector3d(ptsRemovals[j]-ptX).length()<dEps)
				{
					bRemove=true;
					break;;
				}	 
			}//next j

			dp.trueColor(bRemove?red:lightblue, 50);
			dp.draw(PlaneProfile(circle), _kDrawFilled); 
			if (bRemove)
			{ 			
				dp.transparency(0);
				dp.draw(circle); 
			}
			dp.draw(pl);
 
		}//next i
		
//		dp.color(1);
//		dp.transparency(0);
//		
//		for (int i=0;i<ptsRemovals.length();i++) 
//		{ 
//			PLine pl(ptsRemovals[i], lnDir.closestPointTo(ptsRemovals[i]));
//			dp.draw(pl);
//		}
		return;
	}		
//endregion 

//region Tool Selection Jig
	else if (_bOnJig && _kExecuteKey == "SelectTool")
	{ 
		
		Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point
		Point3d ptRef = _Map.getPoint3d("ptRef");
		Vector3d vecZ = _Map.getVector3d("vecZ");
		String sDimStyle= _Map.getString("dimStyle");
		double scale =  _Map.getDouble("Scale");
		scale = scale > 0?scale : 1;
		double dTextHeight =  _Map.getDouble("textHeight");
		
		Plane pnZ(ptRef, vecZ);
		Line(ptJig, vecZ).hasIntersection(pnZ, ptJig);
		
		Plane pnView(ptJig, vecZView);

		Display dp(-1);		
		dp.dimStyle(sDimStyle, 1/scale);
		double textHeight = dTextHeight>0?dTextHeight:dp.textHeightForStyle("O", sDimStyle)*scale;
		dp.textHeight(textHeight);
//
//		double textHeight = getViewHeight() / 75;
//		if (textHeight > U(100))textHeight = U(100); // paperspace
//		dp.textHeight(textHeight);
		
		PlaneProfile pps[0];
		Body bodies[0];
		String types[0],subTypes[0], texts[0];

		for (int i=0;i<_Map.length();i++) 
		{ 
			Map m = _Map.getMap(i);
			
			PlaneProfile pp(CoordSys(ptJig, vecXView, vecYView, vecZView));
			if (m.hasPlaneProfile("ppTool")) 
				pp=m.getPlaneProfile("ppTool");
			else if (m.hasBody("bdTool")) 
				pp.unionWith(m.getBody("bdTool").shadowProfile(pnView));
			else continue;
			pps.append(pp);
			texts.append(m.getString("text"));
			types.append(m.getString("toolType"));
		}//next i
		

	// get closest tool
		int n = -1;
		double dDist = U(10e6);
		
		for (int i = 0; i < pps.length(); i++)
		{
			double d = Vector3d(ptJig - pps[i].closestPointTo(ptJig)).length();
			if (d < dDist)
			{
				dDist = d;
				n = i;
			}
		}		
	// draw jig
		for (int i = 0; i < pps.length(); i++)
		{ 	
			PlaneProfile pp = pps[i];
				
			if (i==n)
			{ 		
				int x = i%rgbToolColors.length();
				dp.trueColor((x >- 1 ? rgbToolColors[x] : red),50);
				dp.draw(pp,_kDrawFilled);
				dp.draw(pp);	
	
				double dX = dp.textLengthForStyle(texts[i], sDimStyle, textHeight);
				double dY = dp.textHeightForStyle(texts[i], sDimStyle, textHeight);
				
				Point3d pt = ptJig + vecXView * 2 * textHeight;
//				PlaneProfile ppBox; ppBox.createRectangle(LineSeg(pt-vecYView*.5*dY,pt+vecYView*.5*dY+vecXView*dX), vecXView, vecYView);
//				ppBox.shrink(-.5 * textHeight);
//				dp.trueColor(grey, 50);
//				dp.draw(ppBox,_kDrawFilled);
				dp.trueColor(white);
				dp.transparency(0);
				dp.draw(texts[i], pt, vecXView, vecYView, 1, 0);
				dp.draw(texts[i], pt, vecXView, vecYView, 1, 0);
				dp.draw(PLine(pt, ptJig, pp.closestPointTo(ptJig)));

			}
			else
			{ 
				dp.trueColor(lightblue, 50);
				//dp.draw(ppShadows[i],_kDrawFilled);
				dp.draw(pp,_kDrawFilled);
			}
 
		}//next i	
		
		return;
	} 		
//endregion

//region SelectSegmentJig //#vd
	else if (_bOnJig && _kExecuteKey == kJigSelectSegment)
	{ 	
		reportNotice("\nSeg");//TODO XX
		Point3d ptJig = _Map.getPoint3d("_PtJig");
		Vector3d vecZ = _Map.getVector3d("vecZ");
		Map mapSegments = _Map.getMap("Segment[]");
		PLine plines[0];
		
		for (int i=0;i<mapSegments.length();i++) 
			if (mapSegments.hasPLine(i))
				plines.append(mapSegments.getPLine(i)); 

		if (plines.length()>0)
			ptJig += vecZ * vecZ.dotProduct(plines.first().coordSys().ptOrg() - ptJig);

		
		int nSelected;
		double dDist = U(10e6);
		for (int i=0;i<plines.length();i++) 
		{ 
			double d  = (plines[i].closestPointTo(ptJig)-ptJig).length(); 
			if (d<dDist)
			{ 
				dDist = d;
				nSelected = i;
			}
		}//next i
		
		Display dp(-1);
		double gap = dViewHeight/150;
		for (int i=0;i<plines.length();i++) 
		{ 
			PLine pl = plines[i];
			if (i==nSelected)
			{ 
				Point3d pt1 = pl.ptStart();
				Point3d pt2 = pl.ptEnd();
				Vector3d vecXS = pt2 - pt1;vecXS.normalize();
				Vector3d vecYS = vecXS.crossProduct(vecZ);	
				Point3d ptm = (pt1+pt2) * .5;
				int bIsArc = !pl.isOn(ptm);

				int r = 255,g = 255;
				double d = gap / 20;
				PLine pl1,pl2;
				pl1 = pl;
				//pl1.offset(-gap*.5);
				pl2 = pl1;
				dp.draw(pl);
				for (int j=0;j<10;j++) 
				{ 
					dp.trueColor(rgb(r, g, 255));
					dp.draw(pl1);
					dp.draw(pl2);					
					if (bIsArc)
					{ 
						pl1.offset(d);
						pl2.offset(-d);							
					}
					else
					{ 
						pl1.transformBy(-vecYS*d);
						pl2.transformBy(vecYS*d);					
					}				
					r -= 30;
					g -= 10;
				}//next j				
			}
			else
			{ 
				dp.trueColor(darkyellow, 0);
				dp.draw(pl);
			}
		}	
		return;
	}			
		
//endregion 

//region SelectSegmentJig
	else if (_bOnJig && _kExecuteKey == kDimlineJig)
	{ 	
		Point3d ptJig = _Map.getPoint3d("_PtJig");
		Point3d ptRef = _Map.getPoint3d("ptRef");
		Point3d pts[] = _Map.getPoint3dArray("pts");

		Vector3d vecX = _Map.getVector3d("vecX");
		Vector3d vecY = _Map.getVector3d("vecY");
		Vector3d vecZ = _Map.getVector3d("vecZ");
		String sDimStyle= _Map.getString("dimStyle");
		double scale =  _Map.getDouble("Scale");
		scale = scale > 0?scale : 1;
		double dTextHeight =  _Map.getDouble("textHeight");
		String text= _Map.getString("text");
		int nChainMode = _Map.getInt("chainMode");
		int nDeltaMode = _Map.getInt("deltaMode");
		int bDeltaOnTop = _Map.getInt(kDeltaOnTop);
		PlaneProfile pp = _Map.getPlaneProfile("Shadow");

		Plane pnZ(ptRef, vecZ);
		Line(ptJig, vecZ).hasIntersection(pnZ, ptJig);

		Vector3d vecDir = _Map.getVector3d("vecDir");
		Vector3d vecPerp = vecDir.crossProduct(-vecZ);
		
		Display dp(-1);
		dp.dimStyle(sDimStyle, 1/scale);
		double textHeight = dTextHeight>0?dTextHeight:dp.textHeightForStyle("O", sDimStyle)*scale;
		dp.textHeight(textHeight);

		dp.trueColor(lightblue, 50);
		dp.draw(pp, _kDrawFilled);
		
		dp.color(-1);
		dp.transparency(0);
		
		Line lnDir(ptRef, vecDir);
		pts = lnDir.orderPoints(pts, dEps);
		
		if (pts.length()>1)
		{ 
			DimLine dl(ptJig, vecDir, vecPerp);
			dl.setUseDisplayTextHeight(true);
			
			Dim dim(dl,  pts, "<>",  "<>", nDeltaMode, nChainMode); 
			dim.setReadDirection(5*vecYView - vecXView);
			dim.setDeltaOnTop(bDeltaOnTop);
			dp.draw(dim);
					
		}

		int nDir = 1;
		Vector3d vecDirText = vecDir*(vecDir.dotProduct(vecXView)<0?-1:1);
		Vector3d vecPerpText = vecDirText.crossProduct(-vecZ);
		if (pts.length()>0)
		{ 
			Point3d pt;pt.setToAverage(pts);
			if (vecDirText.dotProduct(ptRef - pt) < 0)nDir *= -1;
		}
		dp.draw(text, ptRef, vecDirText, vecPerpText, nDir, 0);	

		return;
	}			
		
//endregion 

//region AddOffsetJig
	else if (_bOnJig && _kExecuteKey == kJigAddOffset)
	{ 	
		Point3d ptJig = _Map.getPoint3d("_PtJig");
		PlaneProfile ppEdges[] = GetPlaneProfilesFromMap(_Map.getMap("ppEdge[]"));
		PlaneProfile ppVisible = _Map.getPlaneProfile("ppVisible");
		PlaneProfile ppRef = _Map.getPlaneProfile("ppRef");
		Map mapDimParameter = _Map.getMap("mapDimParameter");
		Point3d ptLocs[] = _Map.getPoint3dArray("ptLocs");
		
//		Plane pnZ(ptRef, vecZ);
//		Line(ptJig, vecZ).hasIntersection(pnZ, ptJig);
//
	//region Display
		String dimStyle= mapDimParameter.getString("dimStyle");
		double scale =  mapDimParameter.getDouble("Scale");
		scale = scale > 0?scale : 1;
		double dTextHeight =  mapDimParameter.getDouble("textHeight");	
	
		Display dp(-1);
		dp.dimStyle(dimStyle, 1/scale);
		double textHeight = dTextHeight>0?dTextHeight:dp.textHeightForStyle("O", dimStyle)*scale;
		dp.textHeight(textHeight);				
	//endregion 

		ptLocs.append(ptJig);
		for (int i=0;i<ptLocs.length();i++) 
		{ 
			Point3d ptLoc  = ptLocs[i]; 

			PlaneProfile pp = FindClosestProfileEdge(ppEdges, ptLoc);
			if (pp.area()<pow(dEps,2)){ continue;}

			//pp.vis(6);		
			CoordSys csi = pp.coordSys();
			Vector3d vecDir = csi.vecZ();
			Vector3d vecPerp = vecDir.crossProduct(-ppVisible.coordSys().vecZ());
			
			Point3d pt1=ptLoc, pt2=ptLoc;
			int bOk1 = GetClosestIntersectionPoint(ppVisible, pt1, vecDir, false);
			int bOk2 = GetClosestIntersectionPoint(ppRef, pt2, vecDir, true);
			
			double offset = vecDir.dotProduct(pt2 - pt1)/scale;
	
	
	
			if (bOk1 && bOk2 && abs(offset)>dEps*scale)
			{ 
				Point3d ptsDim[] ={ pt1, pt2};
				//pt1.vis(1);					pt2.vis(5);						
				DrawDim(ptsDim, ptLoc, vecDir, vecPerp, 5 * _YW - _XW, mapDimParameter, dp);
		
			}				


		}//next i




		return;
	}//endregion
	
 //END JIG //endregion 

//END Part #1 Functions, Dialogs, Jigs //endregion 

//region Part #2 Settings, Properties onInsert

//region Grip Management #GM

//int tick = getTickCount();
//reportNotice("\nstart " + _ThisInst.handle());//TODO XXXX

	Grip gripMoved;
	int indexOfMovedGrip = Grip().indexOfMovedGrip(_Grip);
	Vector3d vecOffsetApplied;
	int bDrag, bOnDragEnd,bDragTag;
	int bIsLocationGrip; // indicating if the grip is a location grip
	if (indexOfMovedGrip>-1)
	{ 
		bDrag = _bOnGripPointDrag && _kExecuteKey=="_Grip";
		bOnDragEnd = !_bOnGripPointDrag;
		
		gripMoved = _Grip[indexOfMovedGrip];
		vecOffsetApplied = gripMoved.vecOffsetApplied();
		
		String name = gripMoved.name();
//		if (name.find(kGripTagPlan,0,false)>-1)
//			bDragTag = true;
//		else if (name.find(kDirKeys[0],0,false)>-1 || name.find(kDirKeys[1],0,false)>-1 || name.find(kDirKeys[2],0,false)>-1)
//			bIsLocationGrip = true;
//
//		if (bOnDragEnd && bIsLocationGrip)
//			_Pt0 += vecOffsetApplied;
	//	reportNotice("\ndragging  _kExecuteKey " + _kExecuteKey +"\n  bDrag:" + bDrag+ "\n  bOnDragEnd:" + bOnDragEnd);//+ "\n  bDragTag:" + bDragTag+ "\n  bIsLocationGrip:" + bIsLocationGrip);	
	}//endregion 

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="Dimension";
	Map mapSetting;

// compose settings file location
	String sFullPath = sPath+"\\"+sFolder+"\\"+sFileName+".xml";

// read a potential mapObject
	MapObject mo(sDictionary ,sFileName);
	if (mo.bIsValid())
	{
		mapSetting=mo.map();
		setDependencyOnDictObject(mo);
	}
	// create a mapObject to make the settings persistent	
	else if ((_bOnInsert || _bOnDebug) && !mo.bIsValid() )
	{
		String sFile=findFile(sFullPath); 
	// if no settings file could be found in company try to find it in the installation path
		if (sFile.length()<1) sFile=findFile(sPathGeneral+sFileName+".xml");	
		if (sFile.length()>0)
		{ 
			mapSetting.readFromXmlFile(sFile);
			mo.dbCreate(mapSetting);			
		}
	}
	// validate version when creating a new instance
	if(_bOnDbCreated)
	{ 
		int nVersion = mapSetting.getInt("GeneralMapObject\\Version");
		String sFile = findFile(sPathGeneral + sFileName + ".xml");		// set default xml path
		if (sFile.length()<1) sFile=findFile(sFullPath);				// set custom xml path if no default found
		Map mapSettingInstall; mapSettingInstall.readFromXmlFile(sFile);	// read the xml from installation directory
		int nVersionInstall = mapSettingInstall.getMap("GeneralMapObject").getInt("Version");		
		if(sFile.length()>0 && nVersion!=nVersionInstall)
			reportNotice(TN("|A different Version of the settings has been found for|") + scriptName()+
			TN("|Current Version| ")+nVersion + "	" + _kPathDwg + TN("|Other Version| ") +nVersionInstall + "	" + sFile);
	}
	
//region View Strategies to show drill dimensioning

	{ 
		Map map = mapSetting.getMap("ViewStrategyDrill");
		String  k = "ViewStrategy";

		{Map m = map.getMap("Beam");				if (m.hasInt(k))nVSBeam = m.getInt(k);}
		{Map m = map.getMap("Sheet");				if (m.hasInt(k))nVSSheet = m.getInt(k);}
		{Map m = map.getMap("Panel");				if (m.hasInt(k))nVSPanel = m.getInt(k);}
		{Map m = map.getMap("CollectionEtity");		if (m.hasInt(k))nVSCollectionEtity = m.getInt(k);}	
	}
	int nVSStrategies[] ={ nVSBeam, nVSSheet, nVSPanel, nVSCollectionEtity }; //all strategies in one array to be passed through the functions
//endregion 	

	
//Configurations
	Map mapConfigs = mapSetting.getMap("Configuration[]");
	String sConfigurations[0];
	for (int i=0;i<mapConfigs.length();i++) 
	{ 
		Map m = mapConfigs.getMap(i);
		String name = m.getMapName();
		if (name.length()>0 && sConfigurations.findNoCase(name,-1)<0)
			sConfigurations.append(name);
	}//next i	

// painter creation mode
	String kPainterManagementMode = "PainterManagementMode";
	int nPainterManagementMode = mapSetting.getInt(kPainterManagementMode);
	if (_Map.hasInt(kPainterManagementMode))
		nPainterManagementMode = _Map.getInt(kPainterManagementMode);

// Global Settings
	String sTriggerGlobalSetting = T("|Global Settings|");
	String kGlobalSettings = "GlobalSettings", kGroupAssignment= "GroupAssignment";
	int nGroupAssignment;
	Map mapGlobalSettings = mapSetting.getMap(kGlobalSettings);
	if (mapGlobalSettings.hasInt(kGroupAssignment))
		nGroupAssignment = mapGlobalSettings.getInt(kGroupAssignment);	
	



	
//End Settings//endregion

//region Variables and flags
	int nNumViewport = _Viewport.length();
	int bIsViewport = nNumViewport>0;
	int bIsHsbViewport;	
	PlaneProfile ppViewport;
	if (bIsViewport)
	{ 
		Viewport vp= _Viewport[_Viewport.length()-1];
		bIsHsbViewport = vp.element().bIsValid();
		_Pt0.setZ(0);
	}
	int bArcCenterOnXY = true;
	int bInLayoutTab, bInPaperSpace, bInBlockSpace;
	if (_bOnInsert)
	{ 
	// determine the current space
		bInLayoutTab = Viewport().inLayoutTab();
		bInPaperSpace = Viewport().inPaperSpace();
		bInBlockSpace = (getVarInt("BLOCKEDITOR") == 1) || (getVarString("REFEDITNAME") != "");
		if (bInLayoutTab && bInPaperSpace)
			nNumViewport = NumViewports();
	}
//endregion 

//region Properties #PR

//region Painters
	String tElementFolder = T("|Element|\\");
	String sPainterCollection = "Dimension\\";
	String sPainters[0],sAllPainters[] = PainterDefinition().getAllEntryNames().sorted();

	for (int i=0;i<sAllPainters.length();i++) 
	{ 
		int bAdd = nPainterManagementMode>0 || sAllPainters[i].find(sPainterCollection,0,false)==0;
		
		if (bAdd)
		{
			PainterDefinition pd(sAllPainters[i]);
			if (!pd.bIsValid())
			{ 
				continue;
			}
			
		// add painter name	
			String name = sAllPainters[i];
			if(nPainterManagementMode==0)
				name = name.right(name.length() - sPainterCollection.length());
			if (sPainters.findNoCase(name,-1)<0)
			{
				sPainters.append(name);
			}		
		}		 
	}//next i

	// add default openings painter if not existant
	String tPainterOpening = tElementFolder+T("|Openings|");
	{ 
		String name = tPainterOpening;
		if(nPainterManagementMode>0)
			name = sPainterCollection + name;
				
		if (sPainters.findNoCase(name,-1)<0)
		{ 
			Entity ents[] = Group().collectEntities(true, Opening(), _kModelSpace);
			String painter = (nPainterManagementMode==0?sPainterCollection :"")+ name;
			PainterDefinition pd(painter);	
			if (!pd.bIsValid() && ents.length()>0)
			{ 
				pd.dbCreate();
				if (pd.bIsValid())
				{ 
					pd.setType("Opening");
					pd.setFormat("@(ElementNumber) @(Width) @(Height)");
				}
			}	

			if (sPainters.findNoCase(name,-1)<0 && pd.bIsValid())
			{
				sPainters.append(name);		
			}
		}		
	}

	// add default element beam painters if not existant
	String tPainterVerticalBeams = tElementFolder+T("|Beams Vertical|");
	String tPainterHorizontalBeams= tElementFolder+T("|Beams Horizontal|");
	String tPainterZone0= tElementFolder+T("|Zone 0|");
	{ 
		String tElementPainters[] ={tPainterVerticalBeams,tPainterHorizontalBeams,tPainterZone0};
		String tFilters[] ={"IsParallelToElementY = 'true'","IsParallelToElementX = 'true'" ,"ZoneIndex = 0"};
	
		for (int i=0;i<tElementPainters.length();i++) 
		{ 
			String name = tElementPainters[i];
			if(nPainterManagementMode>0)
				name = sPainterCollection + name;				
			if (sPainters.findNoCase(name,-1)<0)
			{ 
				Entity ents[] = Group().collectEntities(true, ElementWallSF(), _kModelSpace);
				String painter = (nPainterManagementMode==0?sPainterCollection :"")+ name;
				PainterDefinition pd(painter);	
				if (!pd.bIsValid() && ents.length()>0)
				{ 
					pd.dbCreate();
					if (pd.bIsValid())
					{ 
						pd.setType("Beam");
						pd.setFilter(tFilters[i]);
						pd.setFormat("@(SolidWidth:RL0) x @(SolidHeight:RL0)");
					}
				}				
				if (sPainters.findNoCase(name,-1)<0 && pd.bIsValid())
				{
					sPainters.append(name);		
				}
			}		
		}			
	}
	

	int bFullPainterPath = sPainters.length() < 1 || nPainterManagementMode>0;
	if (bFullPainterPath)
	{ 
		for (int i=0;i<sAllPainters.length();i++) 
		{ 
			String s = sAllPainters[i];
			if (sPainters.findNoCase(s,-1)<0)
				sPainters.append(s);
		}//next i		
	}
	sPainters.insertAt(0, sDefault);		
//endregion 

//region DimStyles
// Find DimStyle Overrides, order and add Linear only
	String sDimStyles[0], sSourceDimStyles[0];
	{ 
	// append potential linear overrides	
		String sOverrides[0];
		for (int i=0;i<_DimStyles.length();i++) 
		{ 
			String dimStyle = _DimStyles[i]; 
			int n = dimStyle.find("$0", 0, false);	// indicating it is a linear override of the dimstyle
			if (n>-1 && sSourceDimStyles.find(dimStyle,-1)<0)
			{
				sDimStyles.append(dimStyle.left(n));
				sSourceDimStyles.append(dimStyle);
			}
		}//next i
		
	// append all non overrides	
		for (int i = 0; i < _DimStyles.length(); i++)
		{
			String dimStyle = _DimStyles[i]; 
			int nx = dimStyle.find("$", 0, false);	// <0 it is not any override of the dimstyle
			if (nx<0 && sDimStyles.findNoCase(dimStyle)<0)
			{ 
				sDimStyles.append(dimStyle);
				sSourceDimStyles.append(dimStyle);				
			}
		}

	// order alphabetically
		for (int i=0;i<sDimStyles.length();i++) 
			for (int j=0;j<sDimStyles.length()-1;j++) 
				if (sDimStyles[j]>sDimStyles[j+1])
				{
					sDimStyles.swap(j, j + 1);
					sSourceDimStyles.swap(j, j + 1);
				}
	}	
//endregion 

category = T("|Dimension|");
	String tPMMidPoint = T("|Mid Point|"), tPMFirstPointMerged = T("|First Point (Merged)|"),  tPMMidPointMerged = T("|Mid Point (Merged)|"),tPMLastPointMerged = T("|Last Point (Merged)|"), tPMExtremePointMerged = T("|Extreme Points (Merged)|");
	String tPMDimensionOffset = T("|Offset Dimension|");
	String sDimPointModeName=T("|Dimension Point Mode|");
	String sDimPointModes[] = { sDefault, tPMFirstPoint, tPMLastPoint,tPMMidPoint, tPMExtremePoint,tPMFirstPointMerged,tPMLastPointMerged,tPMMidPointMerged,tPMExtremePointMerged};
	if (bIsHsbViewport || (_bOnInsert && nNumViewport>0))
		sDimPointModes.append(tPMDimensionOffset);
	PropString sDimPointMode(8, sDimPointModes, sDimPointModeName,0);	
	sDimPointMode.setDescription(T("|Defines the which points of the reference are taken.|"));
	sDimPointMode.setCategory(category);
	int nDimPointMode = sDimPointModes.find(sDimPointMode);
	if (nDimPointMode < 0)
	{
		sDimPointMode.set(sDimPointModes.first()); 
		setExecutionLoops(2); 
		return;
	}
	int bDimMerged = sDimPointMode == tPMFirstPointMerged || sDimPointMode == tPMLastPointMerged || sDimPointMode == tPMExtremePointMerged || sDimPointMode == tPMMidPointMerged;
	int bIsOffsetMode = sDimPointMode == tPMDimensionOffset;
	
	String sDisplayModeName=T("|Delta/Chain Mode|");
	String sSingleDisplayModes[] = { T("|parallel|"), T("|perpendicular|"), "---"};
	int nSingleDisplayModes[] ={ _kDimPar, _kDimPerp, _kDimNone};
	String sDisplayModes[0];
	int nDeltaModes[0],nPerpModes[0];
	for (int i=0;i<sSingleDisplayModes.length();i++) 
	{
		for (int j=0;j<sSingleDisplayModes.length();j++) 
		{ 
			if (i == 2 && j == 2)continue;
			sDisplayModes.append(sSingleDisplayModes[i] + " / " + sSingleDisplayModes[j]);
			nDeltaModes.append(nSingleDisplayModes[i]);
			nPerpModes.append(nSingleDisplayModes[j]);			
		}	
		

	}
	// add classic for parallel only
	{ 
		sDisplayModes.append(T("|classic Acad|"));
		nDeltaModes.append(_kDimClassic);
		nPerpModes.append(_kDimNone);
	}

	PropString sDisplayMode(2, sDisplayModes, sDisplayModeName,0);	
	sDisplayMode.setDescription(T("|Defines the Display Mode|"));
	sDisplayMode.setCategory(category);
	int nDisplayMode = sDisplayModes.find(sDisplayMode, 0);
	int nDeltaMode = nDeltaModes[nDisplayMode];
	int nChainMode = nPerpModes[nDisplayMode];

	String sRefPointModeName=T("|Reference Point Mode|");
	String sRefPointModes[] = { sDefault, tPMNone, tPMFirstPoint, tPMLastPoint, tPMExtremePoint, tPMClosestPoint};//, T("|First Point (Merged)|"), T("|Last Point (Merged)|"), T("|First + Last (Merged)|")};
	PropString sRefPointMode(4, sRefPointModes, sRefPointModeName,0);	
	sRefPointMode.setDescription(T("|Defines the which points of the reference are taken.|"));
	sRefPointMode.setCategory(category);
	sRefPointMode.setReadOnly(bIsOffsetMode ? _kHidden: false);
	int nRefPointMode = sRefPointModes.find(sRefPointMode);
	if (nRefPointMode < 0)
	{
		sRefPointMode.set(sRefPointModes.first());
		setExecutionLoops(2); 
		return;
	}	

	//region ShapeMode
	String sShapeModeName=T("|Shape Mode|");
	String sShapeModes[] = {sDefault,tEnvelopeShape,tBasicShape, tRealShape,tExtremePoint};//

	PropString sShapeMode(1, "", sShapeModeName);
	
	// legacy conversion to new shape mode entries
	if (sShapeModes.findNoCase(sShapeMode,-1) < 0 && sShapeMode!="")
	{ 
		int n = 0;
		if (sShapeMode == T("|Envelope Shape|"))n = 1;
		else if (sShapeMode == T("|Basic Shape|"))n = 2;
		else if (sShapeMode == T("|Real Shape|"))n = 3;
		sShapeMode.set(sShapeModes[n]); 
	}	
	sShapeMode=PropString(1, sShapeModes, sShapeModeName);	
	sShapeMode.setDescription(T("|Specifies how the shape of the items are interpreted to collect dimension points.|") + 
		"\n" + tEnvelopeShape + ": " + T("|only the bounding box is considered (genbeams)|") + 
		"\n" + tBasicShape + ": " + T("|the bounding contour including cuts (genbeams) and openings (sheet, panel) is considered|") + 
		"\n" + tRealShape + ": " + T("|the real body of the item is taken (less performant)|") 
		);
	sShapeMode.setCategory(category);

	int bShapeReal = sShapeMode==tRealShape;
	int bShapeEnvelope= sShapeMode==tEnvelopeShape || sShapeMode==tExtremePoint;
	int bShapeBasic = !bShapeReal && !bShapeEnvelope;
	int nShapeMode = bShapeEnvelope ? 2 : (bShapeBasic ? 1 : 0);			
	//endregion 


	String sStereotypeName=T("|TSL / Stereotype|");	 // HSB-17586
	PropString sStereotype(7, "", sStereotypeName);	
	sStereotype.setDescription(T("|Specifies a semicolon ';' separated list of tsl names or stereotypes to append additional dimpoints.|") + 
		T("|Consumes and displays dimpoints published by the corresponding tsl.|")+
		T("|If a tls does not publish any explicit dimpoints the origin of the tsl will be taken.|")+
		T("|Use context commands to add or remove tsl names which are loaded in the drawing.|"));
	sStereotype.setCategory(category);
	sStereotype.setReadOnly(bDebug?false:_kHidden);
	String sStereotypes[] = sStereotype.tokenize(";");

	String sToolSetName=T("|Tool Set|");	
	PropString sToolSet(9, "", sToolSetName);	
	sToolSet.setDescription(T("|Defines the ToolSet|"));
	sToolSet.setCategory(category);
	sToolSet.setReadOnly(bDebug?false:_kHidden);
	String sToolSets[] = sToolSet.tokenize(";");

category = T("|Filter|");
	String sPainterName=T("|Dimension|");	
	String sPainterDesc = T(" |If a painter collection named 'Dimension' is found only painters of this collection are considered.|");
	PropString sPainter(0, sPainters, sPainterName);	
	sPainter.setDescription(T("|Defines the painter definition to filter entities|") +sPainterDesc );
	sPainter.setCategory(category);
	int nPainter = sPainters.find(sPainter);
	if (nPainter<0){ nPainter=0;sPainter.set(sPainters[nPainter]);}

	String sRefPainters[0]; sRefPainters = sPainters;	
	String sRefPainterName=T("|Reference|");	
	PropString sRefPainter(3, sRefPainters, sRefPainterName,1);
	sRefPainter.setDescription(T("|Defines the reference of the dimension.|")+sPainterDesc);
	sRefPainter.setCategory(category);
	int nRefPainter = sPainters.find(sRefPainter);
	if (nRefPainter<0){ nRefPainter=0;sRefPainter.set(sPainters[nRefPainter]);}

category = T("|Display|");
	String sDimStyleName=T("|DimStyle|");	
	PropString sDimStyle(5, sDimStyles, sDimStyleName);	
	sDimStyle.setDescription(T("|Defines the Dimstyle|"));
	sDimStyle.setCategory(category);
	String dimStyle = sSourceDimStyles[sDimStyles.find(sDimStyle,0)];
	if (_DimStyles.findNoCase(dimStyle ,- 1) < 0)dimStyle = _DimStyles.first();


	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(0), sTextHeightName);	
	dTextHeight.setDescription(T("|Defines the text height of the dimension|") + T(", |0 = byDimstyle|"));
	dTextHeight.setCategory(category);

	String sScaleFactorName=T("|Scale Factor|");	
	PropDouble dScaleFactor(nDoubleIndex++, 1, sScaleFactorName,_kNoUnit);	
	dScaleFactor.setDescription(T("|Defines a scale factor of the dimension, value must be > 0|"));
	dScaleFactor.setCategory(category);
	if (dScaleFactor <= 0)dScaleFactor.set(1);
	
	String sFormatName=T("|Format|");	
	PropString sFormat(6, "", sFormatName);	
	sFormat.setDescription(T("|Defines the format variable and/or any static text.|") + 
		T("|i.e. this argument would display the area in [m²], rounded to 3 decimal digits|: ")+"@(Area:CU;m:RL3)m²");
	sFormat.setCategory(category);
	//sFormat.setReadOnly(bIsOffsetMode ? _kHidden: false);
	
	String sSequenceName=T("|Sequence|");
	PropInt nSequence(nIntIndex++, 0, sSequenceName);	
	nSequence.setDescription(T("|Defines the sequence how collisions with other dimlines and tags will be resolved.| ") + T("|-1 = Disabled, 0 = Automatic|"));
	nSequence.setCategory(category);
	nSequence.setReadOnly(bDebug?false:_kHidden); // HSB-20564 disabled
	if (nSequence>-1)nSequence.set(-1);
//endregion 

//region bOnInsert
	int bLogger = true;
	if(_bOnInsert)
	{
		
	//region Part #1 Insert
		if (insertCycleCount()>1) { eraseInstance(); return; }

			
	// silent/dialog
		if (_kExecuteKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());	
			if (sEntries.findNoCase(_kExecuteKey,-1)>-1)
				setPropValuesFromCatalog(_kExecuteKey);
			else
				setPropValuesFromCatalog(sLastInserted);					
		}	
	// standard dialog	
		else	
			showDialog();

		dimStyle = sSourceDimStyles[sDimStyles.find(sDimStyle,0)];
		if (_DimStyles.findNoCase(dimStyle ,- 1) < 0)dimStyle = _DimStyles.first();
		
		bIsOffsetMode = sDimPointMode == tPMDimensionOffset;
		nDisplayMode = sDisplayModes.find(sDisplayMode, 0);
		nDeltaMode = nDeltaModes[nDisplayMode];
		nChainMode = nPerpModes[nDisplayMode];

		if (sShapeModes.findNoCase(sShapeMode,-1) < 0){sShapeMode.set(sShapeModes.first()); setExecutionLoops(2); return;}
		bShapeReal = sShapeMode==tRealShape;
		bShapeEnvelope= sShapeMode==tEnvelopeShape || sShapeMode==tExtremePoint;
		bShapeBasic = !bShapeReal && !bShapeEnvelope;

	// find out if we have some shopdraw viewports
		int bHasSDV= Group().collectEntities(true, ShopDrawView(), _kModelSpace).length()>0;

		CoordSys ms2ps,ps2ms;
		double dScale = 1;
		Vector3d vecX=_XU, vecY=_YU, vecZ = _ZU;
	//endregion 
	
	//region Prompt for references
		Entity ents[0], showSet[0];
		MultiPage page;
		Section2d section; ClipVolume clipVolume;
		int bHasPage, bIsViewport, bIsHsbViewport, bHasSection;
		Element el;
		TslInst tslDimlines[] = FilterTslsByName(ents, scriptName());

		if (bInLayoutTab && bInPaperSpace)
		{
			Viewport vp;
			_Viewport.append(getViewport(T("|Select a viewport|")));
			vp = _Viewport[_Viewport.length()-1]; 
			dScale = vp.dScale();
			el = vp.element();
			ms2ps = vp.coordSys();
			vecX = _XW; vecY = _YW; vecZ = _ZW;
			
			GenBeam genbeams[] = el.genBeam();
			for (int i=0;i<genbeams.length();i++) 
			{ 
				ents.append(genbeams[i]); 
				 
			}//next i
			
			String sPainterDef = bFullPainterPath ? sPainter : sPainterCollection + sPainter;
			PainterDefinition pd(sPainterDef);
			if (pd.bIsValid())
				showSet = pd.filterAcceptedEntities(ents);
			else
				showSet = ents;
			bIsViewport=true;	
			bIsHsbViewport = el.bIsValid();
			
			
			if (bIsOffsetMode)
			{ 
			// auto adjust textheight if very large
				if (dTextHeight>vp.heightPS()*.1)
				{
					reportMessage(TN("|The selected text height appears to be very large and has been adjusted.|"));					
					dTextHeight.set(U(100)*dScale);
				}
		
				if (bIsHsbViewport)
					_Pt0 = getPoint();
				else
				{ 
					reportNotice("\n" + tPMDimensionOffset + T("|only supported for hsbcad viewports|"));
					eraseInstance();
				}
				return;
			}
			
			
		}
		else
		{ 	
		// prompt for entities
			PrEntity ssE;
			if (bInBlockSpace)
			{ 
				if (bHasSDV)
					ssE = PrEntity(T("|Select shopdraw viewport|"), ShopDrawView());
				else
				{ 
					reportNotice("\n" + scriptName() + T("|this tool requires at least one shopwdraw viewport if inserted in blockspace|"));
					eraseInstance();
					return;
				}
			}	
			else if (bHasSDV)
			{ 
				ssE = PrEntity(T("|Select reference (genbeams, elements, multipages, sections or shopdraw viewports|"), ShopDrawView());
				ssE.addAllowedClass(MultiPage());
			}			
			else
			{
				ssE = PrEntity(T("|Select references|"), MultiPage());				
			}
			
			if (!bInBlockSpace)
			{ 
				ssE.addAllowedClass(GenBeam());
				ssE.addAllowedClass(Element());
				ssE.addAllowedClass(Opening());
				ssE.addAllowedClass(ChildPanel());	
				ssE.addAllowedClass(EntPLine());
				ssE.addAllowedClass(CollectionEntity());
				ssE.addAllowedClass(MetalPartCollectionEnt());
				ssE.addAllowedClass(TrussEntity());
				ssE.addAllowedClass(Section2d());			
				ssE.addAllowedClass(BlockRef());				
			}

			//ssE.allowNested(true);	
			if (ssE.go())
				ents.append(ssE.set());			


		// set to block space
			if (bInBlockSpace || bHasSDV)
			{ 
				_Entity.setLength(0);
				//_Entity = ents;
				ShopDrawView sdvs[0];
				for (int i=0;i<ents.length();i++) 
				{ 
					ShopDrawView sdv= (ShopDrawView)ents[i]; 
					if (sdv.bIsValid())
					{
						_Entity.append(sdv);
						_Pt0 = getPoint();			
						_Map.setInt(kBlockSpaceMode,true);
						return;
					}	 
				}//next i
			}	
		}
	// if a multipage or a section has been selected, ignore the rest of the sset			
		for (int i=0;i<ents.length();i++) 
		{ 
			page = (MultiPage)ents[i]; 
			section = (Section2d)ents[i]; 
			if (page.bIsValid())
			{
				bHasPage = true;
				vecX = _XW; vecY = _YW; vecZ = _ZW;
				break;
			}
			else if (section.bIsValid())
			{
				bHasSection = true;
				vecX = _XW; vecY = _YW; vecZ = _ZW;				
				break;
			}			
			//el = (Element)ents[i]; 
		}//next i			
	
		
	//endregion 
	
		
		CoordSys cs(_PtW, vecX, vecY, vecZ);	
	
	//region View Selection of multipage
		MultiPageView mpvs[0]; 
		PlaneProfile ppViewports[0];
		int nViewport = -1;
			
		if (bHasPage)
		{ 
			Map mapArgs;
			mpvs = page.views();
			showSet = page.showSet();
			
		// get outline of viewports
			PlaneProfile ppViewport;
			for (int i = 0; i < mpvs.length(); i++)
			{
				MultiPageView& mpv = mpvs[i];
				PlaneProfile pp(cs);
				pp.joinRing(mpv.plShape(), _kAdd);
				ppViewports.append(pp);
				mapArgs.appendPlaneProfile("pp", pp);
			}	
			if (mpvs.length() == 1)nViewport = 0;

		// select viewport
			String prompt = T("|Select view|");
			PrPoint ssP(prompt);
			ssP.setSnapMode(TRUE, 0); // turn off all snaps
			int nGoJig = - 1;
			while (nViewport<0 && nGoJig != _kNone && nGoJig != _kOk)
			{
				nGoJig = ssP.goJig("SelectViewport", mapArgs);				
				if (nGoJig == _kOk)//Jig: point picked
				{
					Point3d pt = ssP.value();
					double dDist = U(10e6);
					for (int i = 0; i < ppViewports.length(); i++)
					{
						double d = Vector3d(pt - ppViewports[i].closestPointTo(pt)).length();
						if (d < dDist)
						{
							dDist = d;
							nViewport = i;
							ppViewport = ppViewports[i];
						}
					}
				}
				// Jig: cancel
				else if (nGoJig == _kCancel)
				{
					break;
				}
			}
			ssP.setSnapMode(false, 0); // turn on all snaps
			
			
			if (nViewport >- 1)
			{
				MultiPageView mpv = mpvs[nViewport];
				ViewData vdata = mpv.viewData();//vdatas[nViewport];
				ms2ps = mpv.modelToView();
				ps2ms = ms2ps;
				ps2ms.invert();	
				
				showSet = mpv.showSet();
				ppViewport = ppViewports[nViewport];
				
				Vector3d vecModelView = _ZW;
				vecModelView.transformBy(ps2ms);
				vecModelView.normalize();
				_Map.setVector3d("ModelView", vecModelView);
			}			

			
			if (nViewport < 0)
			{ 
				reportMessage(TN("|Unexpected error|"));				
				eraseInstance();
				return;
			}

			_Entity.append(page);
		}
	//endregion 
		else if (bHasSection)
		{
			_Entity.append(section);
			ms2ps = section.modelToSection();
			ps2ms = ms2ps; 	ps2ms.invert();	
			vecX = _XW; vecY = _YW; vecZ = _ZW;			
	
		// clip volume		
			clipVolume= section.clipVolume();
			if (!clipVolume.bIsValid())
			{ 
				eraseInstance();
				return;
			}
			_Entity.append(clipVolume);			
			setDependencyOnEntity(clipVolume);
		
			showSet = clipVolume.entitiesInClipVolume(true);				
				 	
		}
	//region Assembly
		else 
		{ 
			String sPainterDef = bFullPainterPath ? sPainter : sPainterCollection + sPainter;
			PainterDefinition pd(sPainterDef);
			if (pd.bIsValid())
				showSet = pd.filterAcceptedEntities(ents);
			else 
				showSet = ents;
			_Entity.append(ents);
		}
	//endregion 
	
	//region Get Shadow of showSet
		Plane pnView(_PtW, vecZ);
		PlaneProfile ppVisible(cs);
		Point3d ptsZ[0];

		
		for (int i=0;i<showSet.length();i++) 
		{ 
			GenBeam gb = (GenBeam)showSet[i];
			Body bd;
			if (gb.bIsValid())
			{
				if (bShapeBasic)bd = gb.envelopeBody(true, true);
				else if (bShapeEnvelope)bd = gb.envelopeBody();
				else bd= showSet[i].realBody();
			}
			else
			{
				//reportNotice("\nXX realBody " + showSet[i].formatObject("@(TypeName) @(scriptName:D)"));
				bd= showSet[i].realBody();
			}
			bd.transformBy(ms2ps);
			ptsZ.append(bd.extremeVertices(vecZ)); // collect extreme Z
			PlaneProfile pp = bd.shadowProfile(pnView);
			if (pp.area()>pow(dEps,2))
			{					
				pp.removeAllOpeningRings();
				pp.shrink(-dEps);

				ppVisible.unionWith(pp);
				continue;
			}
			
			PLine pl = showSet[i].getPLine();
			if (pl.length()>0)
			{ 
				pp = PlaneProfile(cs);
				pp.joinRing(pl, _kAdd);
				pp.shrink(-dEps);
				ppVisible.unionWith(pp);
				ptsZ.append(pp.ptMid());
			}
			
		}//next i
		ppVisible.shrink(dEps);
		ptsZ = Line(_PtW, - vecZ).orderPoints(ptsZ, dEps);
	//endregion 
			
		
		Point3d pts[0];// = ppVisible.getGripVertexPoints();
		LineSeg seg = ppVisible.extentInDir(vecX);
		if (pts.length()<1 && ppVisible.area()>pow(dEps,2))
		{ 
			pts.append(seg.ptStart());
			pts.append(seg.ptEnd());			
		}
		
		Vector3d vecDir = vecX;
		Map mapArgs;
		
		mapArgs.setVector3d("vecZ", vecZ);
		if (_Entity.length()>0)
		{
			mapArgs.setVector3d("vecDir", vecDir);
			mapArgs.setPoint3dArray("pts", pts);
		}
		mapArgs.setString("dimStyle", dimStyle);
		mapArgs.setDouble("Scale", ps2ms.scale()*dScaleFactor);
		mapArgs.setDouble("textHeight", dTextHeight);
		mapArgs.setInt("chainMode", nChainMode);
		mapArgs.setInt("deltaMode", nDeltaMode);
		mapArgs.setInt(kDeltaOnTop, bDeltaOnTop);
		mapArgs.setPlaneProfile("shadow", ppVisible);
		mapArgs.setString("text", sFormat);

	// segments
		Map mapSegments,mapDiagonals;
		{ 
			
			PLine rings[] = ppVisible.allRings(true, bIsHsbViewport?false:true);
			//reportNotice("\nrings = " + rings.length());
			for (int r = 0; r < rings.length(); r++)
			{
				PLine pl = rings[r];
				pl.reconstructArcs(dEps, 70);//HSB-16730 segmented contours will try to reconstruct into arc segments
				PlaneProfile ppRing(pl);
				Vector3d vecZP = pl.coordSys().vecZ();
				Point3d pts[] = pl.vertexPoints(false);
				//reportNotice("\nvertices = " + pts.length());
				// loop vertices
				for (int p = 0; p < pts.length() - 1; p++)
				{
					Point3d pt1 = pts[p];
					Point3d pt2 = pts[p + 1];	//pt1.vis(p); pt2.vis(p + 1);
					PLine plSeg(pt1, pt2);
					Point3d ptm = (pt1 + pt2) * .5;
					int bIsArc = ! pl.isOn(ptm);
					
					if (bIsArc)
					{
						// the arc
						plSeg = PLine(vecZP);
						plSeg.addVertex(pt1);
						plSeg.addVertex(pt2, pl.getPointAtDist(pl.getDistAtPoint(pt1) + dEps));
					}
					if (plSeg.length()>dEps)
						mapSegments.appendPLine("pl", plSeg);
				}			
			}
		}
	
	// segments diagonal (copy of Diagonal Dimension #vd, see below )
		{ 
			Point3d ptGripVertices[] = ppVisible.getGripVertexPoints();
			PLine rings[] = ppVisible.allRings(true, false);
			if (rings.length()==1)
			{ 
				rings[0].simplify();
				ptGripVertices = rings[0].vertexPoints(true);
			}
			
		// Simplify / purge vertices which are very closed to the previous
			for (int i=ptGripVertices.length()-1; i>=0 ; i--) 
			{ 
				Point3d pt1=ptGripVertices[i];
				int b = i - 1;
				if (b<0)b=ptGripVertices.length() - 1;
				Point3d pt2=ptGripVertices[b];
				double d =(pt2 - pt1).length();
				if (d<10*dEps) // catch tolerances HSB-18893, Element D024
					ptGripVertices.removeAt(i);
				
			}//next i

		// collect all potential diagonal connctions		
			for (int i=0;i<ptGripVertices.length()-1;i++) 
			{ 
				Point3d pt1 = ptGripVertices[i];	//pt1.vis(2);
				for (int j=i+1;j<ptGripVertices.length();j++) 
				{ 
					if (j-1==i || (i==0 && j==ptGripVertices.length()-1))
					{
						continue;
					} 
					else
					{ 
					// only diagonals
						Point3d pt2 = ptGripVertices[j];;
						PLine pl(vecZ);
						pl.addVertex(pt1);
						pl.addVertex(pt2);
						if (pl.length()>U(20))
						{ 
							mapDiagonals.appendPLine("pl", pl);
							pl.transformBy(vecZ * U(20));
							//pl.vis(j+2);
						}					
					}
	
	
				} 		
			}//next i	
			//mapArgs.setMap("DiagonalSegment[]", mapDiagonals);
		}


		Map mapCustomPoints;

		Point3d pt1,pt2;
		int bHasEntity = _Entity.length() >0;
		int nAlign = bHasEntity?0:4; // 0 = X , 1 = Y , 2 =align, 3=snap, 4 = pick points, 5 = segments, 6 = diagonal
		String promptA = bHasEntity?T("|Pick location|"):T("|Pick first point| ");
		String promptB = T("|[X-Direction/Y-Direction/AlignDirection/swapText/addPoints/Segments/Diagonal/textHeight]|");
		if (tslDimlines.length()>0)promptB = T("|[X-Direction/Y-Direction/AlignDirection/swapText/addPoints/Segments/Diagonal/textHeight/Match visuals]|");
		String promptC = T("|[X-Direction/Y-Direction/AlignDirection/swapText/addPoints]|");
		String prompt = promptA+(bHasEntity?promptB:"");
		PrPoint ssP(prompt);
		
		int nGoJig = -1;
		while (nGoJig != _kOk)//nGoJig != _kNone
		{
			//reportNotice("\n alignMode " + nAlign);
			if (nAlign==5 || nAlign ==6)
			{
				nGoJig = ssP.goJig(kJigSelectSegment, mapArgs);				
			}
			else
			{
				nGoJig = ssP.goJig(kJigSetAlignment, mapArgs);
			}

			if (nGoJig == _kOk)
			{
				Point3d ptPick = ssP.value();
				
			// set alignment	
				if (nAlign == 2) 
				{ 
					if (!mapArgs.hasPoint3d("pt1"))
					{
						pt1 = ptPick;
						mapArgs.setPoint3d("ptRef", pt1);
						mapArgs.setPoint3d("pt1", pt1);
						mapArgs.removeAt("vecDir", true); // get vecDir from jigging
						promptA = T("|Pick second point| ");
					}
					else
					{
						pt2 = ptPick;
						vecDir = pt2 - pt1; vecDir.normalize();
						vecDir = vecDir.crossProduct(-vecZ).crossProduct(vecZ); vecDir.normalize();
						mapArgs.setVector3d("vecDir", vecDir);
						mapArgs.removeAt("pt1", true); 
						mapArgs.removeAt("ptRef", true); 
						nAlign = - 1;
						promptA = T("|Pick location| ");
						
					}					
					nGoJig = - 1;					
					ssP = PrPoint (promptA+promptB,pts.length()>0?pts.first():pt1);
					ssP.setSnapMode(false, 0); // turn on all snaps
				}
			// pick points 	
				else if (nAlign == 4) 
				{ 
					mapArgs.removeAt("shadow", true);
					mapCustomPoints = _Map.getMap("CustomPoint[]");
					//if (!mapArgs.hasPoint3d("pt1"))
					if (pts.length()<1)
					{
						//pts.setLength(0);
						pt1 = ptPick;
						mapArgs.setPoint3d("ptRef", pt1);
						mapArgs.setPoint3d("pt1", pt1);
						pts.append(pt1);
						mapArgs.setPoint3dArray("pts", pts);	
						mapArgs.removeAt("vecDir", true); // get vecDir from jigging
						promptA = T("|Pick second point| ");
						_Pt0 = pt1;
					}
					else
					{
						pt1 = pts.first();
						pt2 = ptPick;
						pt2 += vecZ * vecZ.dotProduct(pt1 - pt2);
						
						//use second point for alignment
						if (pts.length()==1)
						{ 
							vecDir = pt2 - pt1;
							vecDir = vecDir.crossProduct(-vecZ).crossProduct(vecZ); vecDir.normalize();
							mapArgs.setVector3d("vecDir", vecDir);
							nAlign = - 1;
							promptA = T("|Pick location| ");
							mapArgs.removeAt("ptRef", true);
						}
						else
							promptA = T("|Pick next point| ");

						mapArgs.removeAt("pt1", true); 
						 
						//pts = mapArgs.getPoint3dArray("pts");
						pts.append(pt2);
						mapArgs.setPoint3dArray("pts", pts);	
						//nAlign = - 1;
						
						
					}	
					
					Vector3d vecOrg = ptPick - _PtW;
					Map m;
					m.setVector3d("vecOrg", vecOrg);
					mapCustomPoints.appendMap("Point", m);	 
					_Map.setMap("CustomPoint[]",mapCustomPoints );
					
					//if (bInLayoutTab && bInPaperSpace) // flag this instance not to collect genbeams from element
					_Map.setInt("isPointMode", true);

					nGoJig = - 1;	
					
					if (pts.length()==1)
						ssP = PrPoint (promptA+(pts.length()>1?promptB:""), pt1);
					else if (showSet.length()<1)
						ssP = PrPoint (promptA+(pts.length()>1?promptC:""));
//					else
//						ssP = PrPoint (promptA+(pts.length()>1?promptB:""));						
					ssP.setSnapMode(false, 0); // turn on all snaps
				}				
			// select segment
				else if (nAlign == 5)
				{ 
					mapArgs.setMap("Segment[]", mapSegments);
					PLine plines[0];
					for (int i=0;i<mapSegments.length();i++) 
						if (mapSegments.hasPLine(i))
							plines.append(mapSegments.getPLine(i)); 
					
					if (plines.length()>0)
						ptPick += vecZ * vecZ.dotProduct(plines.first().coordSys().ptOrg() - ptPick);
		
			
					int nSelected=-1;
					double dDist = U(10e6);
					for (int i=0;i<plines.length();i++) 
					{ 
						double d  = (plines[i].closestPointTo(ptPick)-ptPick).length(); 
						if (d<dDist)
						{ 
							dDist = d;
							nSelected = i;
						}
					}//next i	
					
					if (nSelected>0)
					{ 
						PLine pl = plines[nSelected];
						Point3d pt1 = pl.ptStart();
						Point3d pt2 = pl.ptEnd();
						Point3d ptm = (pt1 + pt2) * .5;
						Vector3d vecXS = pt2 - pt1;vecXS.normalize();
						Vector3d vecYS = vecXS.crossProduct(vecZ);

						vecDir = vecXS;
						_Map.setVector3d("vecPerpAlign", vecYS);
						_Map.removeAt("vecDiag", true);
	            		_Pt0 = ptPick;
					}
				}
			// select diagonal
				else if (nAlign == 6)
				{ 
					mapArgs.setMap("Segment[]", mapDiagonals);
					PLine plines[0];
					for (int i=0;i<mapDiagonals.length();i++) 
						if (mapDiagonals.hasPLine(i))
							plines.append(mapDiagonals.getPLine(i)); 
					
					if (plines.length()>0)
						ptPick += vecZ * vecZ.dotProduct(plines.first().coordSys().ptOrg() - ptPick);
		
					int nSelected=-1;
					double dDist = U(10e6);
					for (int i=0;i<plines.length();i++) 
					{ 
						double d  = (plines[i].closestPointTo(ptPick)-ptPick).length(); 
						if (d<dDist)
						{ 
							dDist = d;
							nSelected = i;
						}
					}//next i	
					
					if (nSelected>-1)
					{ 
						PLine pl = plines[nSelected];
						Point3d pt1 = pl.ptStart();
						Point3d pt2 = pl.ptEnd();
						Vector3d vecDiag = pt2 - pt1;vecDiag.normalize();
						_Map.setVector3d("vecDiag", vecDiag);
						_Map.removeAt("vecPerpAlign", true);
	            		_Pt0 = ptPick;
					}					
				}
			// Location
				else
				{ 
					_Pt0 = ptPick;
				}

			}
	        else if (nGoJig == _kKeyWord)
	        { 
	        	int key = ssP.keywordIndex();
	        	
	            if (key == 0)
	            {	
	            	nAlign = key;
	            	vecDir = vecX;
	            	mapArgs.setVector3d("vecDir", vecDir);
	            }
				else if (key == 1)
				{
					vecDir = vecY;
					nAlign = key;
					mapArgs.setVector3d("vecDir", vecDir);
				}				
				else if(key == 2)
	            {
	            	nAlign = key;
	            	promptA = T("|Pick first point of alignmemt| ");
					ssP = PrPoint (promptA+promptB);
					ssP.setSnapMode(false, 0); // turn on all snaps
	            }	            
	          	else if (key == 3)
	            {
	            	mapArgs.setInt(kDeltaOnTop, !mapArgs.getInt(kDeltaOnTop)); 
	            }
	        	else if(key == 4)
	            {
	            	nAlign = key;
	            	promptA = pts.length()>0?T("|Pick next point, <Enter> to set location| "):T("|Pick first point| ");
					ssP = PrPoint (promptA+promptB);
					ssP.setSnapMode(false, 0); // turn on all snaps
	            }
	        	else if(key == 5)
	            {
	            	nAlign = key;
	            	promptA = T("|Select segment| ");
					ssP = PrPoint (promptA+promptB);
					ssP.setSnapMode(TRUE, 0); // turn off all snaps
					mapArgs.setMap("Segment[]", mapSegments);
	            } 
	        	else if(key == 6)
	            {
	            	nAlign = key;
	            	promptA = T("|Select Diagonal| ");
					ssP = PrPoint (promptA+promptB);
					ssP.setSnapMode(TRUE, 0); // turn off all snaps
					mapArgs.setMap("Segment[]", mapDiagonals);
	            } 	
	        	else if(key == 7)
	            {
	       			double textHeight = dTextHeight;
	       			double newTextHeight = getDouble(TN("|New text height| (") + textHeight+ ")");
	       			
	       			if (newTextHeight==0)
	       			{ 
	       				Display dp(0); 
	       				textHeight=dp.textHeightForStyle("G", sDimStyle);
	       				dTextHeight.set(newTextHeight);
	       				mapArgs.setDouble("textHeight", textHeight);
	       			}
	       			else if (newTextHeight>=0)
	       			{ 
	       				textHeight = newTextHeight;
	       				dTextHeight.set(newTextHeight);		       				
	       				mapArgs.setDouble("textHeight", textHeight);
	       			}
	            } 	            
	        	else if(key == 8)
	            {
	            	TslInst t = getTslInst(T(" | Pick a dimline to replicate its style|"));
	            	if (Equals(t.scriptName(), scriptName()))
	            	{ 
	            		sDimStyle.set(t.propString(sDimStyleName));
	            		dTextHeight.set(t.propDouble(sTextHeightName));
	            		dScaleFactor.set(t.propDouble(sScaleFactorName));
	            		sFormat.set(t.propString(sFormatName));

						dimStyle = sSourceDimStyles[sDimStyles.find(sDimStyle,0)];
						if (_DimStyles.findNoCase(dimStyle ,- 1) < 0)dimStyle = _DimStyles.first();
	            		mapArgs.setString("dimStyle", dimStyle);
						mapArgs.setDouble("Scale", ps2ms.scale()*dScaleFactor);
						mapArgs.setDouble("textHeight", dTextHeight);		
	            		
	            	}
	            } 	            
	            
	            
	            
	        } 			
			else if (nGoJig == _kNone)
	        { 
	        	if (nAlign==4)
	        	{ 
	        		nAlign = -1;

	            	promptA = T("|Pick location| ");
					ssP = PrPoint (promptA+promptB);
					ssP.setSnapMode(TRUE, 0); // turn off all snaps	        		
	        	}
	        	else
	        		break;
	        }
		// Jig: cancel
			else if (nGoJig == _kCancel)
			{
				eraseInstance();
				break;
			}
		}
		ssP.setSnapMode(false, 0); // turn on all snaps
	
	//region Adjust default Z-Location and Get point outside paperspace to show setup graphics in viewport mode
		if (!bHasPage && !bIsViewport && !bHasSection && ptsZ.length()>0)
			_Pt0 += vecZ * vecZ.dotProduct(ptsZ.first() - _Pt0);
		
		_Map.setVector3d("vecDir", vecDir);
		//reportNotice("vecDir on insert " + vecDir + " num ptsZ " + ptsZ.length());
		if (nAlign==5)_Map.setInt("SegmentMode", true);
		
	 	//Get point outside paperspace to show setup graphics in viewport mode
		if (bIsViewport && !bIsOffsetMode)	
		{ 
			_PtG.append(getPoint(T("|Pick point outside paperspace to place setup information|")));
		}
	//endregion 	
		
		
		
		
		
		return;
	}	
// end on insert	__________________//endregion

		
//Part #2 //endregion 

//region Part #3 Main

// Store ThisInst in _Map to enable debugging with subMapX until HSB-22564 is implemented
	TslInst this = _ThisInst;
	if (bDebug && _Map.hasEntity("thisInst"))
	{
		Entity ent = _Map.getEntity("thisInst");	
		this = (TslInst)ent;
	}
	else if (!bDebug && (_bOnDbCreated || !_Map.hasEntity("thisInst")))
		_Map.setEntity("thisInst", this);


//region Get Entities and refs all modes
	Map mapCustomPoints = _Map.getMap("CustomPoint[]");
	Entity ents[0], showSet[0], refSet[0], elemSet[0]; // the showset (dimension set), refSet  the ents of the reference, elemSet = the set of the corresponding element if any 
	ents = _Entity;
	
	int bCreatedByBlockspace = _Map.getInt("createdByBlockSpace");
	if (ents.length()<1 && bCreatedByBlockspace) 
	{ 
		//reportNotice("\nnow :   + createdByBlockSpace");
		return;
	}
	else if (bIsViewport)
		;
	else if (ents.length()<1 && mapCustomPoints.length()<1)
	{ 
		reportMessage(TN("|Nothing in selection set.|"));
		eraseInstance();
		return;
	}
	else if (ents.length()>0 && _Map.hasInt("createdByBlockSpace")) 
	{
		//reportNotice("\nnow valid: "  + _ThisInst.handle());
		_Map.removeAt("createdByBlockSpace", true);
	}
	else if (_Entity.length()==0 && _Map.hasEntity("entDef")) // purge if multipage has been deleted or invalid but grips added
	{ 
		eraseInstance();
		return;
	}

	Entity entDefine = ents.length()>0 && !bIsHsbViewport?ents.first():Entity();
	
	MultiPage page = (MultiPage)entDefine;	
	Element el = (Element)entDefine;
	ChildPanel child;
	Opening op=(Opening)entDefine,openings[0];
	Element elements[0];
	ShopDrawView sdvs[0];
	Section2d section= (Section2d) entDefine;
	ClipVolume clipVolume;
	Body bdClip;
	ShopDrawView sdv = (ShopDrawView)entDefine;

	double scale = 1;
	CoordSys cs(),ms2ps, ps2ms;
	Vector3d vecX=_XU, vecY=_YU, vecZ = _ZU;

	if (_bOnDbCreated)setExecutionLoops(2);
	if (nSequence > 0)this.setSequenceNumber(nSequence);
	
	//reportNotice("\nDimline " + this.handle()+ " seq "+nSequence);
	
	addRecalcTrigger(_kGripPointDrag, "_Pt0");
	int bDragPt0 = _bOnGripPointDrag && _kExecuteKey == "_Pt0";
	
	int bHasPage = page.bIsValid();
	int bIsElement= el.bIsValid();
	int bIsOpening= op.bIsValid();
	int bIsPointMode = _Map.getInt("isPointMode");
	int bIsBlockSpaceMode = _Map.getInt(kBlockSpaceMode);
	int bHasSection = section.bIsValid();
	int bIsModelMode; // flag indicating that the instance is assigned to a set model entities excluding sections, multipages etc
	Point3d ptsX[0], ptsRef[0];
	Point3d ptsReq[0]; int bReqCrossMarks[0];// request points, must be same length

	PainterDefinition pdDim(bFullPainterPath ? sPainter : sPainterCollection + sPainter);
	PainterDefinition pdRef(bFullPainterPath ? sRefPainter : sPainterCollection + sRefPainter);
	
	String sTypeDim, sTypeRef, sFilterDim, sFilterRef;
	int bIsValidPDdim, bIsValidPDRef;
	if (pdDim.bIsValid())
	{ 
		sTypeDim = pdDim.type();
		sFilterDim = pdDim.filter();
		bIsValidPDdim = true;
		setDependencyOnDictObject(pdDim);
		
	}
	if (pdRef.bIsValid())
	{ 
		sTypeRef = pdRef.type();
		bIsValidPDRef = true;
		sFilterRef = pdRef.filter();
		setDependencyOnDictObject(pdRef);		
	}

	int bIsTrussPD = bIsValidPDdim && sTypeDim== "TrussEntity";
	int bIsGenBeamPD = bIsValidPDdim && (sTypeDim== "GenBeam" || sTypeDim == "Beam"  || sTypeDim == "Sheet"  || sTypeDim == "Panel");
	int bIsTSLPD = bIsValidPDdim && (sTypeDim== "TslInstance");
	int bIsOpeningPD = bIsValidPDdim && (sTypeDim == "Opening" || sTypeDim == "OpeningSF");
	int bIsElementPD = bIsValidPDdim && (sTypeRef == "Element" || sTypeRef== "ElementWallSF"|| sTypeRef== "ElementRoof");
	
	int bIsOpeningRefPD = bIsValidPDRef && (sTypeRef == "Opening" || sTypeRef== "OpeningSF");
	int bIsElementRefPD = bIsValidPDRef && (sTypeRef == "Element" || sTypeRef== "ElementWallSF"|| sTypeRef== "ElementRoof");

	int bIsSegmentMode = _Map.getInt("SegmentMode");

	
//region Modes: Blockspace, Section, Viewport, Element, MultiElement
	Vector3d vecZM;
	if (bIsBlockSpaceMode)
	{ 
	// Get Shopdraw View	
		
		for (int i=0;i<_Entity.length();i++) 
		{ 
			ShopDrawView _sdv= (ShopDrawView)_Entity[i]; 
			if (_sdv.bIsValid())
			{
				sdvs.append(_sdv);	
				//sdv = _sdv;
			}
		}//next i	
		if (sdvs.length()<1)
		{ 
			eraseInstance();
			return;
		}

	//region On Generate ShopDrawing
		if (_bOnGenerateShopDrawing)
		{
			//reportNotice("\n" + scriptName() + " set to sequence "+_ThisInst.sequenceNumber() );

		// Get multipage from _Map
			Entity entCollector = _Map.getEntity(_kOnGenerateShopDrawing +"\\entCollector");
			Map mapTslCreatedFlags = entCollector.subMapX("mpTslCreatedFlags");
			String uid = _Map.getString("UID"); // get the UID from map as instance does not exist onGenerateShopDrawing
			int bIsCreated = mapTslCreatedFlags.hasInt(uid);

			if (!bIsCreated && entCollector.bIsValid())
			{ 							
				for (int i = 0; i < sdvs.length(); i++)
				{
					// shopdraw view and its view data	
					ShopDrawView sdv = sdvs[i];
					
					ViewData viewDatas[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets, 0);
					int nIndFound = ViewData().findDataForViewport(viewDatas, sdv);//find the viewData for my view
					if (nIndFound < 0) { continue; }
					ViewData viewData = viewDatas[nIndFound];
					
					// Get defining genbeam
					Entity entDefine;
					Entity ents[] = viewData.showSetDefineEntities();
					if (ents.length() > 0)// && ents.first().bIsKindOf(GenBeam()))
						entDefine = ents.first();
					if (!entDefine.bIsValid()) { continue; }
					
//					// Get all drills	
//					if ( ! gb.bIsValid() || (gb.bIsValid() && gb != entDefine))
//					{
//						gb = (GenBeam)entDefine;
//						if ( ! gb.bIsValid()) { continue; }
//						//ads = AnalysedDrill().filterToolsOfToolType(gb.analysedTools(0));						
//					}
					
				// Transformations
					CoordSys ms2ps = viewData.coordSys();
					CoordSys ps2ms = ms2ps;
					ps2ms.invert();
					
					Vector3d vecAllowedView = _ZW;
					vecAllowedView.transformBy(ps2ms);
					vecAllowedView.normalize();
					
					Vector3d vecDir = _Map.getVector3d("vecDir");
					if (vecDir.bIsZeroLength())vecDir = _XW;

				// create TSL
					TslInst tslNew;
					GenBeam gbsTsl[] = {};		Entity entsTsl[] = {entCollector};			Point3d ptsTsl[] = {_Pt0};
					int nProps[]={nSequence};			
					double dProps[]={dTextHeight,dScaleFactor};				
					String sProps[]={sPainter,sShapeMode,sDisplayMode,sRefPainter,sRefPointMode,sDimStyle,sFormat, sStereotype,sDimPointMode,sToolSet};
					Map mapTsl;	
					
					mapTsl.setVector3d("vecOrg",  _Pt0 - _PtW); // relocate to multipage
					mapTsl.setVector3d("vecDir", vecDir);
					mapTsl.setVector3d("ModelView", vecAllowedView);// the offset from the viewpport
					mapTsl.setInt("createdByBlockSpace", true);
					mapTsl.setDouble(kBaselineOffset, _Map.getDouble(kBaselineOffset));
					mapTsl.setInt(kDeltaOnTop, _Map.getInt(kDeltaOnTop)); 
					
					String addDrill = tDisabled;
					{
						String s = _Map.getString("subTypeDrill");
						if (s!=tDisabled && s!="")
							addDrill = s;
					}
					mapTsl.setString("addDrill", addDrill); 
					_Map.setInt(kDeltaOnTop,!bDeltaOnTop);
					
					tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			

					if (tslNew.bIsValid())
					{
						tslNew.setColor(_Map.getInt("color"));
						tslNew.transformBy(Vector3d(0, 0, 0));
						
					// flag entCollector such that on regenaration no additional instances will be created	
						if (!bIsCreated)
						{
							bIsCreated=true;
							mapTslCreatedFlags.setInt(uid, true);
							entCollector.setSubMapX("mpTslCreatedFlags",mapTslCreatedFlags);
						}
					}	
				}
			}					
		}
	//endregion

	//region Draw Setup of Blockspace
		else
		{ 
			
			Entity viewEnts[]= Group().collectEntities(true, ShopDrawView(), _kMySpace, false);	
			_Map.setInt("viewIndex", viewEnts.find(sdv));
			_Map.setInt("color", this.color());
			
			setDependencyOnEntity(sdv);
			_Map.setString("UID", _ThisInst.uniqueId()); // store UID to have access during _kOnGenerateShopDrawing
			addRecalcTrigger(_kGripPointDrag, "_Pt0");
			double scale = 1;
			Display dp(-1);
			double textHeight = dTextHeight;
			dp.dimStyle(dimStyle, scale);
			if (textHeight>0)
				dp.textHeight(textHeight);
			else	
				textHeight = dp.textHeightForStyle("O", dimStyle);	

			ShopDrawView sdvs[] ={ sdv};
			PlaneProfile pps[] = GetShopdrawProfiles(sdvs);
			PlaneProfile pp= pps.length()>0?pps.first():PlaneProfile(CoordSys());
			
			double dX = pp.dX();
			double dY = pp.dY();
			
			Vector3d vec = .5 * (_XW * dX + _YW * dY);
			
			//pp.extentInDir(_XW).vis(1);	
			_Map.setPlaneProfile("ppViewport", pp); // store for baseline offset calculation
			_Map.setPlaneProfile("ppAll", pp); // store for baseline offset calculation
			//{Display dpx(1); dpx.draw(pp, _kDrawFilled,20);}
		//endregion 


		//region Create preview graphics
			PlaneProfile ppPreviewShape(cs);
			
			if (dX >5*textHeight && dY >5*textHeight)
			{
				dX -= textHeight;
				dY -= textHeight;
			}
			
			vec = .5 * (_XW * dX + _YW * dY);
			Point3d pt = pp.ptMid() - vec;
			
			// get potential planeprofile
			Map m = sdv.subMapX("Preview");
			Entity originator = m.getEntity("originator");
			if (!bDebug && m.hasPlaneProfile("pp") && originator.bIsValid() && originator!=_ThisInst)
			{ 
				ppPreviewShape = m.getPlaneProfile("pp");
				ppPreviewShape.extentInDir(_XW+_YW).vis(3);
			}
			else
			{ 
				PLine pl(_ZW);
				double dA = (dX > dY ? dX : dY)/3;
				double dB = (dX > dY ? dY: dX);
				double r = .5 * dB;

				pl.addVertex(pt);
				pl.addVertex(pt+_YW*.5*dB);
				pl.addVertex(pt+_YW*dB+_XW*dA);
				pl.addVertex(pt+_YW*dB+_XW*(3*dA-r));
				pl.addVertex(pt+_XW*(3*dA-r), pt+_YW*.5*dB+_XW*3*dA);
				pl.close();
				
				if (dY>dX)
				{ 
					CoordSys rot; rot.setToRotation(90, _ZW,pt);
					rot.transformBy(_XW * dX);
					pl.transformBy(rot);
				}
				//pl.vis(3);
				ppPreviewShape=PlaneProfile(cs);
				ppPreviewShape.joinRing(pl,_kAdd);
				PlaneProfile ppSub = ppPreviewShape;
				ppSub.shrink(dB*.2);
				ppPreviewShape.subtractProfile(ppSub);
	
			
			// Drill loctaions
				pl.offset(-dB * .1);		//pl.vis(1);
				Point3d pts[0];
				pts.append(pl.getPointAtDist(0));
				pts.append(pl.getPointAtDist(pl.length()/4));

			// store against parent sdv
				originator = _ThisInst;
				m.setEntity("originator", originator);
				m.setPlaneProfile("pp", ppPreviewShape);
				m.setPoint3dArray("ptDrills", pts);
				sdv.setSubMapX("Preview", m);
			}
			
			if (originator == _ThisInst)
			{ 
				dp.trueColor(brown);
				dp.draw(ppPreviewShape);
			}

			LineSeg seg = ppPreviewShape.extentInDir(_XW);
			PLine rings[] = ppPreviewShape.allRings(true, false);
			PLine plOpenings[] = ppPreviewShape.allRings(false, true);
	
			if (sShapeMode == sDefault)
				ptsX.append(ppPreviewShape.getGripVertexPoints());
			else if (bShapeReal || bShapeBasic)	
			{ 
				for (int i=0;i<rings.length();i++) 
					ptsX.append(rings[i].vertexPoints(true)); 
			}
			else
			{ 
				ptsX.append(seg.ptStart());
				ptsX.append(seg.ptEnd());	
			}
		
			int bAddDrill = _Map.getString("addDrill") != tDisabled && _Map.getString("addDrill") != "";
		
			if (m.hasPoint3dArray("ptDrills"))//#B
			{ 
				Point3d pts[] = m.getPoint3dArray("ptDrills");
				for (int i=0;i<pts.length();i++) 
				{ 
					PLine c;
					c.createCircle(pts[i], _ZW, U(10));
					dp.draw(c);
					 
				}//next pts
				
				if (bAddDrill)
					ptsX.append(pts);
			}
			
			
			ptsRef.append(seg.ptStart());
			ptsRef.append(seg.ptEnd());
			

		//endregion 
		}
		
	}
	else if (bHasSection)
	{ 
//		bHasSection = true;
		setDependencyOnEntity(section);
		if (nGroupAssignment==0) assignToGroups(section, 'D');
//		entDefine = ent;
		
		ms2ps = section.modelToSection();
		ps2ms = ms2ps; 	ps2ms.invert();	
		vecX = _XW; vecY = _YW; vecZ = _ZW;			

//		vecZM = _ZW;
//		vecZM.transformBy(ps2ms);	vecZM.normalize();
//			
	// clip volume		
		clipVolume= section.clipVolume();
		if (!clipVolume.bIsValid())
		{ 
			eraseInstance();
			return;
		}
		bdClip = clipVolume.clippingBody();
		_Entity.append(clipVolume);			
		setDependencyOnEntity(clipVolume);

		showSet = clipVolume.entitiesInClipVolume(true);

	// Search potential non solid entities like polylines etc HSB-23095
		Entity includedEntities[] = clipVolume.includedEntities();
		for (int i=0;i<includedEntities.length();i++) 
		{ 
			BlockRef bref = (BlockRef)includedEntities[i];		
			if (bref.bIsValid())
			{
				Block block(bref.definition());
				AppendXRefEntities(showSet,block.entity());
			}
		}//next i

		refSet = showSet;
	}
	else if (bHasPage)
	{ 
		if (nGroupAssignment==0)assignToGroups(page, 'D');
		showSet= page.showSet();
		refSet = showSet;
			
		setDependencyOnEntity(page);
		
		if (!bCreatedByBlockspace)
			_Map.setEntity("entDef", page);
		_Pt0.setZ(0);
	}
	else if (bIsViewport)
	{ 
		Viewport vp= _Viewport[_Viewport.length()-1]; 
		ms2ps = vp.coordSys();
		ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps
		scale = vp.dScale();
		int nActiveZoneIndex = vp.activeZoneIndex();
		el = vp.element();
		bIsElement = el.bIsValid();
		bIsHsbViewport = bIsElement;
		vecX = _XW; vecY = _YW; vecZ = _ZW;
		vecZM = vecZ;
		vecZM.transformBy(ps2ms);
		vecZM.normalize();
		
		Point3d ptCenPS = vp.ptCenPS();
		Vector3d vecVP = .5 * (_XW * vp.widthPS() + _YW * vp.heightPS());
		ppViewport.createRectangle(LineSeg(ptCenPS - vecVP, ptCenPS + vecVP),_XW,_YW);
		
		
	// reset entity array on setting viewport layout
		if (bIsElement &&  _bOnViewportsSetInLayout)
		{ 
			for (int i=_Entity.length()-1; i>=0 ; i--) 
			{  
				Entity e = _Entity[i];
				if (e.typeDxfName()=="VIEWPORT"){continue;}
				else	_Entity.removeAt(i);
			}//next i
			ents.setLength(0);	
		}
		
	// append entities to showSet if in ACA viewport mode
		if (bIsViewport && !bIsHsbViewport)
		{ 
			for (int i=ents.length()-1; i>=0 ; i--) 
			{  
				Entity e = _Entity[i];
				if (e.typeDxfName()=="VIEWPORT"){continue;}
				showSet.append(ents[i]);
			}//next i	
			refSet = showSet;
		}
		

		if (!bIsPointMode)
		{ 
			AppendElementSubSet(el, pdDim, pdRef, sTypeDim, openings, showSet, refSet, nActiveZoneIndex);
//			
//			GenBeam genbeams[] = el.genBeam();
//			for (int i=0;i<genbeams.length();i++) 
//				ents.append(genbeams[i]);
//
//		// do not append if not explictly specified by painter // HSB-20564	
//			if (bIsOpeningPD || bIsOpeningRefPD)
//			{ 
//				openings = el.opening();
//				for (int i=0;i<openings.length();i++) 
//				{
//					ents.append(openings[i]);	
//				}				
//			}
//
//		// do not append if not explictly specified by painter // HSB-20564
//			if (bIsValidPDdim || bIsValidPDRef)
//			{ 
//				TslInst tsls[] = el.tslInst();
//				for (int i=0;i<tsls.length();i++) 
//					ents.append(tsls[i]);				
//			}
//			
//		// append trussEntities of this elemenmt
//			if (bIsTrussPD)
//			{ 
//				ents.append(el.elementGroup().collectEntities(true, TrussEntity(),_kModelSpace));
//			}
//
//			if (bIsValidPDdim)
//			{ 
//				Entity _ents[] = pdDim.filterAcceptedEntities(ents);
//				showSet.append(_ents);
//			}
//			else
//			{ 
//				for (int i=0;i<ents.length();i++) 
//					if (ents[i].myZoneIndex()==nActiveZoneIndex || nActiveZoneIndex==999)
//						showSet.append(ents[i]);
//			}
//			
//		// get ref set
//			if (!bIsValidPDRef)
//			{ 
//				for (int i=0;i<ents.length();i++) 
//					if (ents[i].myZoneIndex()==0 && nActiveZoneIndex!=999)
//						refSet.append(ents[i]);				
//			}
//			else	
//			{
//				refSet = ents;			
//			}
//			refSet.append(el); // might be removed when using painter for the reference set
		}

	}	
	else if (bIsElement)
	{ 
		int n = 0;// HSB-17175 assign to zone of defining entity
		if (entDefine.bIsKindOf(GenBeam())) 
			n = entDefine.myZoneIndex();
		if (nGroupAssignment==0)
			assignToElementGroup(el, true, 0, 'D');
	
		if (!bIsPointMode)
		{	
			AppendElementSubSet(el, pdDim, pdRef, sTypeDim, openings, showSet, refSet, 999);// 999 emulates the active zoneindex = all
			
			for (int i=0;i<ents.length();i++) 
			{ 
				Element _el = (Element)ents[i];			
				if (_el.bIsValid() && showSet.find(_el)<0)
				{ 
					AppendElementSubSet(_el, pdDim, pdRef, sTypeDim, openings, showSet, refSet, 999);
				} 
			}//next i
			
		// append other entities
			if (!pdDim.bIsValid())
				AppendEntities(showSet, ents);
			if (!pdRef.bIsValid())
				AppendEntities(refSet, ents);
		}			
	}
	else if (bIsOpening)
	{
		Element e = op.element();
		if (nGroupAssignment==0)
			assignToElementGroup(e, true, 0, 'D');
	
	// append other entities
		if (!pdDim.bIsValid())
			AppendEntities(showSet, ents);
		if (!pdRef.bIsValid())
			AppendEntities(refSet, ents);
		else
		{ 
			Entity _ents[0];
			_ents =ents;
			for (int i=0;i<ents.length();i++) 
			{ 
				Opening o= (Opening)ents[i]; 
				if (o.bIsValid())
					_ents.append(o.element());				 
			}//next i
			
			refSet.append(pdRef.filterAcceptedEntities(_ents));
		}
		
	}
	else
	{ 
		Element e = entDefine.element();
		int n;// HSB-17175 assign to zone of defining entity
		if (entDefine.bIsKindOf(GenBeam()))
			n = entDefine.myZoneIndex();
		if (nGroupAssignment==0)	
		{ 
			if (e.bIsValid())
				assignToElementGroup(e, true, n, 'D');
			else
				assignToGroups(entDefine, 'D' );			
		}

		cs = CoordSys(_Pt0, vecX, vecY, vecZ);// TODO checck conversion from vecX vecY
		if (!bIsPointMode)
		{
			showSet = ents;
			refSet = showSet;
		}
		bIsModelMode=true;	
	}
//endregion	

//region Special Group Assignment
	// set layer on creation or on global settings change
	if (nGroupAssignment==1)
	{ 
		int bSetLayer = _Map.getInt("setLayer");
		
		if ((_bOnDbCreated || _kNameLastChangedProp==sTriggerGlobalSetting) || bSetLayer)
		{ 
			//reportNotice("\nflag =" +  bSetLayer);
			assignToLayer("0");	
			_Map.removeAt("setLayer", true);
		}

			
			
;
//			String layer = _ThisInst.layerName();
//			if (layer.find("~",0,false)>-1) // assuming a layer consisting a tilde is an hsb group layer previously assigned
//			{ 
//				assignToLayer("0");	
//			}


	}			
//endregion 	

//region MultiElement: collecting elements of multi if in same dwg
	Element elMultis[0];
	SingleElementRef srefs[0];				
	ElementMulti em = (ElementMulti)el;
	
	if (em.bIsValid())
	{ 
		srefs = em.singleElementRefs();
		String numbers[0];
		for (int j=0;j<srefs.length();j++) 
			numbers.append(srefs[j].number()); 
	
	// get model elements in same sequence as srefs
		elMultis.setLength(srefs.length());
		Entity _ents[] = Group().collectEntities(true, Element(), _kModelSpace);
		for (int i=0;i<_ents.length();i++) 
		{ 
			Element e = (Element)_ents[i];
			if (!e.bIsValid()) continue;
			int n = numbers.findNoCase(e.number() ,- 1);		
			if (n < 0)continue;
			elMultis[n] = e;
		}			
	}	
//End MultiElement//endregion 

//endregion 

//region CoordSys
	Vector3d vecDir = _Map.getVector3d("vecDir");
	if (vecDir.bIsZeroLength() || vecDir.isParallelTo(vecZ))
	{
		vecDir = vecX;
	}

	Vector3d vecPerp = vecDir.crossProduct(-vecZ);vecPerp.normalize();
	vecDir = vecPerp.crossProduct(vecZ);
	
	if (entDefine.bIsKindOf(Element()))
		cs = CoordSys(_Pt0, vecDir, vecPerp, vecDir.crossProduct(vecPerp));// TODO checck conversion from vecX vecY
	int bIsOrtho =  vecDir.isParallelTo(vecX) ||  vecDir.isPerpendicularTo(vecX) || (abs(vecDir.dotProduct(vecX)) + 0.001 >1); // catch toleances 

	//region Diagonal Dim
	Vector3d vecDiag = _Map.getVector3d("vecDiag");
	int bDiagonalFound,bIsDiagonalDim = !vecDiag.bIsZeroLength();
	if (bIsDiagonalDim)
	{ 
		if (nSequence>-1)
			nSequence.set(-1);		
		
		_Grip.setLength(0);
		if (bDebug)vecDiag.vis(_Pt0, 2);
		if (sShapeMode==tEnvelopeShape || sShapeMode==tExtremePoint)
		{ 
			reportMessage("\n" + sShapeMode + T("|cannot be used in for diagonal dimensions.| ") + sShapeModeName + T("|has been set to |") + tBasicShape);
			sShapeMode.set(tBasicShape);
			setExecutionLoops(2);
			return;
		}
		
		if (sRefPointMode!=tPMNone)
			sRefPointMode.set(tPMNone);
		sRefPointMode.setReadOnly(true);	
	}		
	else
		sRefPointMode.setReadOnly(false);	
	//endregion 

	//region Gable Mode
	int bIsGableMode = !bIsOrtho && !bIsDiagonalDim && bIsElement && (bIsViewport || bHasPage || bHasSection);
	if (bIsGableMode)
	{ 

		if (nSequence>-1)
			nSequence.set(-1);		
		
		if (sShapeMode==tEnvelopeShape || sShapeMode==tExtremePoint)
		{ 
			reportMessage("\n" + sShapeMode + T("|cannot be used in for aligned gable dimensions.| ") + sShapeModeName + T("|has been set to |") + tBasicShape);			
			sShapeMode.set(tBasicShape);
			setExecutionLoops(2);
			return;			
		}
	}			
	//endregion 

	Plane pnView(_Pt0, vecZ);
	Plane pnViewModel(_Pt0, vecZ); // the viewing plane refers to the view in model
	PlaneProfile ppView;
	PlaneProfile ppProtect;
	PlaneProfile ppVisible(cs),ppRef(cs), ppAll(cs);

	Map mapTools = _Map.getMap("Tool[]");

// events
	if (_kNameLastChangedProp==sRefPainterName)
	{ 
		_Map.removeAt("ppRef", true); // remove potential ref profiles
	}		
//endregion 	
	
//region Draw grip point guide lines and add drag trigger. not available in hsb viewport mode
	if (!bIsHsbViewport)
	{ 
		for (int i=0;i<_PtG.length();i++) 
		{ 
			addRecalcTrigger(_kGripPointDrag, "_PtG"+i);
			
			if (_bOnGripPointDrag && _kExecuteKey == "_PtG"+i)
			{ 
				PLine pl(_PtG[i], Line(_Pt0, vecDir).closestPointTo(_PtG[i]));
				Display dp(1);
				dp.draw(pl);
			}
			
			
			if (_kNameLastChangedProp=="_PtG"+i)
			{ 
				Vector3d vecOrg = _PtG[i] - _PtW;
				Map m;
				m.setVector3d("vecOrg", vecOrg);
				
				Map mapTemp;
				for (int j=0;j<mapCustomPoints.length();j++) 
				{ 
					Map mx = mapCustomPoints.getMap(j);
					if (i==j)
						mx = m;
					mapTemp.appendMap("Point", mx);	 
				}//next j
				
				mapCustomPoints = mapTemp;
				_Map.setMap("CustomPoint[]",mapCustomPoints );
	
				break;
			} 
		}//next i		
	}
			
//endregion 	

//End Part #2 //endregion 

//region Multipage
	String viewUserId;	
	if (bHasPage)
	{
		
	// get the defining entity	
		Entity defineSet[] = page.defineSet();
		if (defineSet.length()>0)
			entDefine = defineSet.first();
		
		// keep relative location to multipage 
		Point3d ptOrg = page.coordSys().ptOrg();
		if (_Map.hasVector3d("vecOrg") && _kNameLastChangedProp!="_Pt0" && !bDebug)
			_Pt0 = ptOrg + _Map.getVector3d("vecOrg");		
		if(abs(_Pt0.Z())>dEps)_Pt0.setZ(0);
		
		Vector3d vecModelView = _Map.getVector3d("ModelView");
		ppProtect = PlaneProfile(cs);
		
		MultiPageView mpvs[] = page.views();
		PlaneProfile ppViewports[] = GetViewPlaneProfiles(page);
		Map mapArgs = SetPlaneProfileArray(ppViewports);

		// HSB-22206 store view index on creation
		int nDefaultView=-1;
		if (_Map.hasInt("ViewIndex"))
		{ 
			int viewIndex = _Map.getInt("ViewIndex");
			if (mpvs.length()>viewIndex)
				nDefaultView = viewIndex;
		}

		// HSB-22206 find view by index or model view vector
		for (int i = nDefaultView<0?0:nDefaultView; i < mpvs.length(); i++)
		{
			MultiPageView& mpv = mpvs[i];
			
			Point3d pt;
			pt.setToAverage(mpv.plShape().vertexPoints(true));			
			
			Vector3d vecView = vecModelView;
			vecView.transformBy(mpv.modelToView());
			vecView.normalize();		if (bDebug)vecView.vis(pt, i);

			if (vecView.isCodirectionalTo(_ZW) || nDefaultView==i)
			{
				if (!_Map.hasInt("ViewIndex"))
					_Map.setInt("ViewIndex", i);
				
				
				ViewData vdata = mpv.viewData();
				if (bDebug)vdata.coordSys().vecZ().vis(pt + _XW * U(100), 4);
				ms2ps = mpv.modelToView();
				//vdatas[nViewport];
				scale = vdata.dScale();
				showSet = mpv.showSet();

				ppView = PlaneProfile(CoordSys());
				ppView.joinRing(mpv.plShape(), _kAdd);
				pnViewModel = mpv.snapPlaneInModel();	
				
				viewUserId = vdata.viewUserId();
			}
			
		//Add ruleset dimlines to protected range
			PlaneProfile pps[] = mpv.dimCollisionAreas(false);
			for (int i = 0; i < pps.length(); i++)
				ppProtect.unionWith(pps[i]);
				
		// store current location relative to page location
			Vector3d vecOrg = Vector3d(_Pt0 - ptOrg);
			_Map.setVector3d("vecOrg", vecOrg);	
			
			if (nDefaultView >- 1)break;
		}
		refSet = showSet;

	// CoordSys	
		ps2ms = ms2ps;
		ps2ms.invert();
		vecZ = _ZW;
		//ppView.vis(12);
		
	//region Trigger SetView 
		String sTriggerSetView = T("|Set View|");
		addRecalcTrigger(_kContextRoot, sTriggerSetView );
		if (_bOnRecalc && _kExecuteKey==sTriggerSetView)
		{
		// select viewport
			int nViewport = -1;
			String prompt = T("|Select view|");
			PrPoint ssP(prompt);	
			ssP.setSnapMode(true, 0);
			int nGoJig = -1;
			while (nGoJig != _kNone && nGoJig != _kOk)
			{
				nGoJig = ssP.goJig("SelectViewport", mapArgs);		
				if (nGoJig == _kOk)//Jig: point picked
				{
					Point3d pt = ssP.value();	
					double dDist = U(10e6);	
					for (int i = 0; i < ppViewports.length(); i++)
					{
						double d = Vector3d(pt - ppViewports[i].closestPointTo(pt)).length();
						if (d < dDist)
						{
							dDist = d;
							nViewport = i;
						}
					}		
					
					if (nViewport>-1)
					{ 
						MultiPageView mpv = mpvs[nViewport];
						ViewData vdata = mpv.viewData();//vdatas[nViewport];
						CoordSys ps2ms = mpv.modelToView();
						ps2ms.invert();
						vecModelView = _ZW;
						vecModelView.transformBy(ps2ms);vecModelView.normalize();
						_Map.setVector3d("ModelView", vecModelView);
						_Map.setInt("ViewIndex", nViewport);
						PlaneProfile pp = ppViewports[nViewport];
						//_Pt0 = pp.ptMid() - _XW * .5 * pp.dX() - _YW * .5 * pp.dY();
						
						_Pt0 = getPoint();
						Vector3d vecOrg = Vector3d(_Pt0 - ptOrg);
						_Map.setVector3d("vecOrg", vecOrg);	
					}
				}
			// Jig: cancel
				else if (nGoJig == _kCancel)
				{
					break;
				}
			}

			setExecutionLoops(2);
			return;
		}			
		//endregion					
	}
//endregion 

//region Get type of defining entity
	TslInst tslDefine = (TslInst)entDefine;
	int bIsAssemblyDefinition, bIsTslDefined;
	if (tslDefine.bIsValid())
	{ 
		bIsTslDefined = true;
		bIsAssemblyDefinition = tslDefine.scriptName().find("AssemblyDefinition", 0) == 0;
	}
	Map mapPSRequests[0];
//endregion 

//region Display
	Display dpDrag(-1),dp(this.color());
	dp.showInDxa(true); // HSB-14692
	dp.dimStyle(dimStyle, ps2ms.scale()*dScaleFactor);
	double textHeight = dTextHeight>0?dTextHeight:dp.textHeightForStyle("O", dimStyle);
	dp.textHeight(textHeight);

	dp.addHideDirection(vecDir);	dp.addHideDirection(-vecDir);
	dp.addHideDirection(vecPerp);	dp.addHideDirection(-vecPerp); 

//End Display//endregion 

//region Store dim parameters in map
	Map mapDimParameter;
	mapDimParameter.setString("dimStyle",dimStyle);
	mapDimParameter.setDouble("textHeight",textHeight);
	mapDimParameter.setDouble("scale",scale);
	mapDimParameter.setInt("deltaMode",nDeltaMode); 
	mapDimParameter.setInt("chainMode",nChainMode); 
	mapDimParameter.setInt("deltaOnTop",bDeltaOnTop);
	mapDimParameter.setInt("refPointMode",nRefPointMode);
	
//endregion 


//region Collect tool based dimensions from genbeam driven show set entitiies
//	GenBeam gbMetalparts[0];
//	CoordSys csMetalparts[0];
	
	if (sStereotypes.length()>0 || sToolSets.length()>0)
	{ 
		for (int i=0;i<showSet.length();i++) 
		{ 
			Entity ent = showSet[i]; 
			GenBeam gb = (GenBeam)ent;
	
			Map requests[0];
			if (gb.bIsValid() && !gb.bIsDummy())
			{ 	
				int nVSGenBeam = gb.bIsKindOf(Beam()) ? nVSBeam : (gb.bIsKindOf(Sheet()) ? nVSSheet : nVSPanel);
				Vector3d vecView = vecZ;		vecView.transformBy(ps2ms);
				Vector3d vecDirMS = vecDir;		vecDirMS.transformBy(ps2ms);
				Vector3d vecPerpMS=vecPerp;		vecPerpMS.transformBy(ps2ms);vecPerpMS.normalize();			
				Point3d pt0 = _Pt0;	pt0.transformBy(ps2ms);
				if (vecPerpMS.dotProduct(pt0-gb.ptCen())<0)
					vecPerpMS *= -1;
	
				// get connected tools
				Entity tents[] = gb.eToolsConnected();
				AnalysedTool ats[] = gb.analysedTools();
				if (sToolSets.length()>0)
					ats = filterToolSubTypes(ats, sToolSets);
					
				// collect relevant tools of genbeam
				if(sStereotypes.length()>0)
					for (int j = 0; j < tents.length(); j++)
					{
						Entity& tent = tents[j];
						AnalysedTool atsT[] = filterToolsByToolEnt(ats, tent);
						
						if (bDebug)reportNotice("\ngetGenBeamToolRequests: typeDxfName "+i + " " +tents[j].formatObject("@(ScriptName:D) @(DxfName)")); 
						TslInst t = (TslInst)tent;
						int bIsTsl = t.bIsValid() && sStereotypes.findNoCase(t.scriptName() ,- 1) >- 1;
						int bIsToolEnt = sStereotypes.findNoCase(tent.typeDxfName() ,- 1) >- 1;
						
					// try to collect from dimrequest	// HSB-23162
						Map _requests[0];
						if (bIsTsl)
							_requests.append(getTSLRequests(t, vecView, sStereotypes));												
					// if no request found collect from tool							
						if (_requests.length()<1 && (bIsTsl || bIsToolEnt))
							_requests.append(getToolRequests(vecView, atsT, vecDirMS,vecPerpMS, nVSGenBeam, 0)); // 0 = any for boxed
						requests.append(_requests);
						
					}				
				else if(sToolSets.length()>0)
					requests.append(getToolRequests(vecView, ats, vecDirMS,vecPerpMS,nVSGenBeam,0));
			}
			for (int r=0;r<requests.length();r++) 
			{ 
				requests[r].transformBy(ms2ps); 
				mapPSRequests.append(requests[r]); 
			}//next r
		}//next i		
	}
	
//End Gather collection entities and append to showset //endregion 

//region Prerequisites Collections

	// remove this inst from set
	{ 
		int n = showSet.find(this);
		if (n>-1)
			showSet.removeAt(n);
		n = refSet.find(this);
		if (n>-1)
			refSet.removeAt(n);	
	}

	CollectionEntity ces[0]; // the collection of all CollectionEntityities in the showset
	PlaneProfile ppCEs[0], ppCERefs[0], ppCEVisibles[0];
	Map mapCEs[0]; // a map containing for each CE a list of each visible nested profile
	String sCollectionDefs[0]; 
	sCollectionDefs = GetUniqueCollectionDefinitions(showSet, ces);

	BlockRef brefs[0]; // the collection of all blockreferences in the showset
	PlaneProfile ppBREFs[0];
	String sBrefDefs[0]; 
	sBrefDefs = getUniqueBlockDefinitions(showSet, brefs);

	// precollect MetalPartCollectionEnts
	MetalPartCollectionEnt mpces[] = FilterMetalParts(showSet);

// get a collection containing all sets
	Entity allSet[0];
	allSet = showSet;
	for (int i=0;i<refSet.length();i++) 
		if (allSet.find(refSet[i])<0)
			allSet.append(refSet[i]); 
	int numAll = allSet.length();

	if (!bIsElement && !bIsOpening)// TODO validate this filtering
	{ 
		showSet= bIsValidPDdim?pdDim.filterAcceptedEntities(showSet):showSet;
		
		if (bIsValidPDRef)
		{ 
			refSet = pdRef.filterAcceptedEntities(refSet);
			if (bIsElement && refSet.find(el)<0)
				refSet.append(el);
		}		
	}

	//for (int i=0;i<showSet.length();i++) 		reportNotice("\n showSet i"+i +" "+showSet[i].typeDxfName()); 
//End Prerequisites Collections //endregion 

//region Collections and BlockRefs

	//region Function GetMetalPartTslRequests
	// NOTE: uses variables, do not move to beginning of script
	// appends potential PS requests
	void GetMetalPartTslRequests( Map& mapPSRequests, GenBeam gbs[], CoordSys csmp)
	{ 
		
		CoordSys csInv = csmp;
		csInv.invert();
		
//	// Get potential tsl dim requests		
//		if ((sStereotypes.length()>0 || sToolSets.length()>0 ) 
//			&& ((showSet.find(mpce)>-1 || showSet.find(te)>-1 || showSet.find(ce)>-1)))//HSB-21437
//		{  
		
		Map requests[0];
		for (int j=0;j<gbs.length();j++) 
		{ 
			GenBeam& gb = gbs[j];	//gb.realBody().vis(j);
			if (gb.bIsDummy()){ continue;}
			
			Vector3d vecView = vecZ;		vecView.transformBy(csInv);
			Vector3d vecDirMS = vecDir;		vecDirMS.transformBy(csInv);
			Vector3d vecPerpMS=vecPerp;		vecPerpMS.transformBy(csInv);vecPerpMS.normalize();			
			Point3d pt0 = _Pt0;	pt0.transformBy(csInv);
			if (vecPerpMS.dotProduct(pt0-gb.ptCen())<0)
				vecPerpMS *= -1;					

			Entity tents[] = gb.eToolsConnected();
			AnalysedTool ats[] = gb.analysedTools();
			if (sToolSets.length()>0)
				ats = filterToolSubTypes(ats, sToolSets);
				
			if (sStereotypes.length()>0)
				for (int jt = 0; jt < tents.length(); jt++)
				{
					AnalysedTool atsT[] = filterToolsByToolEnt(ats, tents[jt]);
					
					
					TslInst t = (TslInst)tents[jt];
					int bIsTsl = t.bIsValid() && sStereotypes.findNoCase(t.scriptName() ,- 1) >- 1;
					int bIsToolEnt = sStereotypes.findNoCase(tents[jt].typeDxfName() ,- 1) >- 1;
					if (bIsTsl || bIsToolEnt)
						requests.append(getToolRequests(vecView, atsT, vecDirMS, vecPerpMS, nVSCollectionEtity,nVSCollectionEtity)); // nVSCollectionEtity,nVSCollectionEtity: TODO add global strategies for boxed tools
				}
			else if (sToolSets.length()>0)
			{ 
				requests.append(getToolRequests(vecView, ats, vecDirMS, vecPerpMS, nVSCollectionEtity,nVSCollectionEtity));
			}

	//region Cuts: Get non entity based tools
		if (sStereotypes.findNoCase(_kACSimpleAngled,-1)>-1)
		{ 		
			AnalysedCut cuts[] =AnalysedCut().filterToolsOfToolType(ats);					
			for (int c=0;c<cuts.length();c++) 
			{ 
				AnalysedCut& a= cuts[c];
				Map m = getCutRequest(a,vecView, vecDirMS, vecPerpMS);
				if (m.length()>0)
					requests.append(m);				 
			}//next c cut							
		}//endregion 
			
		}
		for (int r=0;r<requests.length();r++) 
		{ 
			requests[r].transformBy(csmp); 
			mapPSRequests.append(requests[r]); 
		}//next r					
	
		
		return;
	}//endregion

	//region Collect profiles of MetalPartCollectionEntities which are inside an xRef // HSB-23092
	// when referring to an xRef MetalPartCollectionEnt.definition() does not return a valid MetalPartCollectionDef -> collect by entity and definitionObject
	for (int i=0;i<mpces.length();i++) 
	{ 
		if (mpces[i].definition().length()>0){ continue;}
		MetalPartCollectionEnt& ce = mpces[i];
		MetalPartCollectionDef cd = ce.definitionObject();
		
		
		GenBeam gbsRef[0],gbsDim[0], gbsAll[0];		
		if (cd.bIsValid())			gbsAll=cd.genBeam(); 

		Body bodiesAll[] = GetGenbeamBodies(gbsAll, nShapeMode);
		
		if (bIsGenBeamPD)			gbsDim = pdDim.filterAcceptedEntities(gbsAll);
			else					gbsDim = gbsAll;			
		if (bIsValidPDRef)			gbsRef = pdRef.filterAcceptedEntities(gbsAll);	
			else					gbsRef = gbsDim;
			
		// remove dim ents from ref	
		for (int j=gbsRef.length()-1; j>=0 ; j--) 
			if (gbsDim.find(gbsRef[j])>-1)
				gbsRef.removeAt(j); 

		Body bodiesDim[0], bodiesRef[0];
		for (int j=0;j<gbsAll.length();j++) 
		{ 
			GenBeam gb = gbsAll[j];
			Body bd = bodiesAll[j]; 
			if (gbsDim.find(gb) >- 1) bodiesDim.append(bd);
			if (gbsRef.find(gb) >- 1) bodiesRef.append(bd);			
		}//next j
		

		CoordSys csmp =ce.coordSys();
		csmp.transformBy(ms2ps);
		CoordSys csInv = csmp;
		csInv.invert();

		Entity entities[0]; // optional solids 

	// Get dim profile
		PlaneProfile ppx(cs);
		Map mapCE = GetDimensionProfile(bodiesDim, csmp, ppx);
		ppCEs.append(ppx);
		mapCEs.append(mapCE);

	// Get Ref Profile
		PlaneProfile ppxRef(cs);
		Map mapCEx = GetDimensionProfile(bodiesRef, csmp, ppxRef);
		ppCERefs.append(ppxRef);

	// Get visible profile
		PlaneProfile ppxAll(cs);
		Map mapCEAll = GetDimensionProfile(bodiesAll, csmp, ppxAll);			
		ppCEVisibles.append(ppxAll);

		if ((sStereotypes.length()>0 || sToolSets.length()>0 ) && showSet.find(ce)>-1)//HSB-21437 // HSB-23092
			GetMetalPartTslRequests(mapPSRequests, gbsDim, csmp);

	}//next i

//endregion 

	//region Collect profiles of CollectionEntities	
	for (int d=0;d<sCollectionDefs.length();d++) 
	{ 
		String def = sCollectionDefs[d];
		TrussDefinition td(def);
		MetalPartCollectionDef mpcd(def);
		CollectionDefinition cd(def);
		GenBeam gbsRef[0],gbsDim[0], gbsAll[0];
		
		if (mpcd.bIsValid())		gbsAll=mpcd.genBeam(); 
		else if (td.bIsValid())		gbsAll=td.genBeam(); 
		else if (cd.bIsValid())		gbsAll=cd.genBeam(); 			
			
		Entity entities[0]; // optional solids 
		Body bodiesAll[] = GetGenbeamBodies(gbsAll, nShapeMode);


		if (bIsGenBeamPD)			gbsDim = pdDim.filterAcceptedEntities(gbsAll);
			else					gbsDim = gbsAll;			
		if (bIsValidPDRef)			gbsRef = pdRef.filterAcceptedEntities(gbsAll);	
			else					gbsRef = gbsDim;
			
		// remove dim ents from ref	
		for (int j=gbsRef.length()-1; j>=0 ; j--) 
			if (gbsDim.find(gbsRef[j])>-1)
				gbsRef.removeAt(j); 

		Body bodiesDim[0], bodiesRef[0];
		for (int j=0;j<gbsAll.length();j++) 
		{ 
			GenBeam gb = gbsAll[j];
			Body bd = bodiesAll[j]; 
			if (gbsDim.find(gb) >- 1) bodiesDim.append(bd);
			if (gbsRef.find(gb) >- 1) bodiesRef.append(bd);			
		}//next j


	// find corresponding collectionEntity
		for (int i=0;i<ces.length();i++) 
		{ 
			PlaneProfile ppx(cs),ppxRef(cs), ppxAll(cs);
			
			MetalPartCollectionEnt mpce= (MetalPartCollectionEnt)ces[i];
			TrussEntity te= (TrussEntity)ces[i];
			CollectionEntity ce= ces[i];
			if (mpce.formatObject("@(Definition)")!=def && te.definition()!=def && ce.definition()!=def)
			{
				continue;
			}

			CoordSys csmp =ce.coordSys();
			csmp.transformBy(ms2ps);
			CoordSys csInv = csmp;
			csInv.invert();

		// Get dim profile	
			Map mapCE = GetDimensionProfile(bodiesDim, csmp, ppx);
			//{Display dpx(1); dpx.draw(ppx, _kDrawFilled,20);}
			ppCEs.append(ppx);
			mapCEs.append(mapCE);

		// Get ref profile	
			Map mapCEx = GetDimensionProfile(bodiesRef, csmp, ppxRef);			
			ppCERefs.append(ppxRef);

		// Get visible profile	
			Map mapCEAll = GetDimensionProfile(bodiesAll, csmp, ppxAll);			
			ppCEVisibles.append(ppxAll);


		// re-add collection entity if it contributes
			if (showSet.find(ce)<0 && bIsGenBeamPD)
			{ 
				showSet.append(ce);
				//reportNotice("\nreadded ce " +def);
			}
		

		// Get potential tsl dim requests		
			if ((sStereotypes.length()>0 || sToolSets.length()>0 ) 
				&& ((showSet.find(mpce)>-1 || showSet.find(te)>-1 || showSet.find(ce)>-1)))//HSB-21437
			{  
				
				GetMetalPartTslRequests(mapPSRequests, gbsDim, csmp);
				
			}

		}//next i
	}//next d
//END Collect profiles of MetalPartCollectionEntities //endregion 

	//region Collect profiles of BlockRefs	

	for (int d=0;d<sBrefDefs.length();d++) 
	{ 
		String def = sBrefDefs[d];
		Block block(def);
		GenBeam gbs[]=block.genBeam(); 
		Entity entities[]=block.entity(); 
		Body bodies[] = GetGenbeamBodies(gbs, nShapeMode);
		bodies.append(GetEntitySolids(entities, nShapeMode));
	
		for (int i=0;i<brefs.length();i++) 
		{ 
			PlaneProfile ppx(cs);
			BlockRef& bref= brefs[i];
			if (bref.definition()!=def){ continue;}

			CoordSys csmp =bref.coordSys();
			csmp.transformBy(ms2ps);
			CoordSys csInv = csmp;
			csInv.invert();
			Vector3d vecView = vecZ;
			vecView.transformBy(csInv);
			
		// Get profile	
			for (int j=0;j<bodies.length();j++) 
			{ 
				Body bd = bodies[j]; 
				bd.transformBy(csmp);
				if (bDebug)bd.vis(6); 
				PlaneProfile pp = bd.shadowProfile(pnView);
				pp.shrink(-dEps);
				if (ppx.area()<pow(dEps,2))ppx=pp;
				else	ppx.unionWith(pp);
			}//next j
			ppx.shrink(dEps);	//if (bDebug)ppx.vis(2);
			ppBREFs.append(ppx);
		
		// Get potential tsl dim requests
			if (sStereotypes.length()>0)
			{
				TslInst tsls[0];
				for (int j=0;j<gbs.length();j++) 
					tsls.append(getGenBeamTsls(gbs[j], sStereotypes));

			// Get stereotype requests and transform to dim
				for (int j=0;j<tsls.length();j++) 	
				{
					Map requests[0];		
					requests.append(getTSLRequests(tsls[j], vecView,sStereotypes));
					for (int r=0;r<requests.length();r++) 
					{ 
						requests[r].transformBy(csmp); 
						mapPSRequests.append(requests[r]); 
					}//next r
				}//next j
			}
			
			
			
		}//next i
	}//next d
//END Collect profiles of MetalPartCollectionEntities //endregion 



//End Collections and BlockRefs //endregion 

//region Collect items #All	___________________________________________________________________

///TODO
	Entity entSelectedRequestors[] = _Map.getEntityArray("ToolRequest[]", "", "ToolRequest");
	Entity entSelectedTools[] = _Map.getEntityArray("SelectedTool[]", "", "SelectedTool");

	GenBeam genbeams[0];
	TslInst tsls[0];
	Body bodies[numAll];
	PlaneProfile profiles[numAll];

//	if (bDebug)
//		reportNotice("\n\nallSet ("+ allSet.length()+")\nshowSet ("+ showSet.length()+")\nrefSet (" + refSet.length() + ")");
	
	
	for (int i = 0; i < numAll; i++)
	{

		Entity ent = allSet[i];
		if (!bIsHsbViewport && _Entity.find(ent)>-1)
			setDependencyOnEntity(allSet[i]);

		//reportNotice("\nXX numAll" + ent.formatObject(" @(TypeName) @(scriptName:D) Zone = @(ZoneIndex:D;-)"));
		GenBeam gb = (GenBeam)ent;
		Sheet sh = (Sheet)ent;
		Sip sip = (Sip)ent;
		TslInst t= (TslInst)ent;
		MetalPartCollectionEnt mpce =(MetalPartCollectionEnt)ent;
		CollectionEntity ce =(CollectionEntity)ent;
		TrussEntity te = (TrussEntity)ent;
		BlockRef bref = (BlockRef)ent;
		Opening op = (Opening)ent;
		Element _el= (Element)ent;
		//
		
		PlaneProfile pp(cs); //profile in paperspace
		PlaneProfile ppVis(cs); //profile in paperspace

		if (sh.bIsValid() && !vecZM.bIsZeroLength() && vecZM.isParallelTo(sh.vecZ()))
		{ 
			PlaneProfile _pp = sh.profShape();
			if (bHasPage || bIsViewport || bHasSection)
				_pp.transformBy(ms2ps); 
			pp.unionWith(_pp);	
		}
		else if (sip.bIsValid() && !vecZM.bIsZeroLength() && vecZM.isParallelTo(sip.vecZ()))
		{ 
			PLine pl = sip.plShadow();
			if (bHasPage || bIsViewport || bHasSection)
				pl.transformBy(ms2ps);			
			pp.joinRing(pl, _kAdd);
		}		
		else if (gb.bIsValid())
		{
			if (gb.bIsDummy()){ continue;}
			genbeams.append(gb);
			
			if (bShapeReal)	
			{
				bodies[i] = gb.realBody();
			}
			else if (bShapeBasic)
			{
				bodies[i] = gb.envelopeBody(true, true);
			}
			else 
			{
				bodies[i] = gb.envelopeBody();		
			}
		
			if (bDebug)bodies[i].vis(i);
		}
		else if (ce.bIsValid())
		{ 
			int n = ces.find(ce);
			if (bHasSection)
				bodies[i] = ce.realBody();
			else if (n>-1)
			{
				// append shape even if filtered by painters
				ppVis = ppCEVisibles[n];
				ppVis.shrink(-dEps);
				ppAll.unionWith(ppVis);
				//{Display dpx(4); dpx.draw(ppVis, _kDrawFilled,20);}
				PlaneProfile _pp = ppCERefs[n];				
				if (_pp.area()<pow(dEps,2))
					_pp  = ppCEs[n];
				pp.unionWith(_pp);
			}
		}
		else if (bref.bIsValid())
		{ 
			int n = brefs.find(bref);
//			if (bHasSection) // TODO
//				bodies[i] = ce.realBody();
			if (n>-1)
			{
				pp = ppBREFs[n];
			}
			

		}		
		else if (t.bIsValid() && t.subMapKeys().findNoCase("Sequencing" ,- 1) < 0)
		{
			if (bIsTSLPD && !FilterAcceptedEntity(t, sFilterDim))
			{ 
				//if (bDebug)reportNotice("\n" + t.scriptName() + " has been refused by filter "+sFilterDim);
				continue;
			}
			//if (bDebug)reportNotice("\nScript " + t.scriptName()); 

			tsls.append(t);
			bodies[i] = t.realBodyTry(_XW+_YW+_ZW);
			
		//region HSB-23457 collect potential requests
			Map mapRequests = t.subMapX(kDimInfo);
			
			// accept shape definition by request
			if (mapRequests.length()>0)
			{ 
				PlaneProfile ppr(CoordSys(_Pt0, vecDir, vecPerp, vecZ));
				for (int i=0;i<mapRequests.length();i++) 
				{ 
					Map m= mapRequests.getMap(i); 
					
				// PlaneProfile
					if (m.hasPlaneProfile("profShape"))
					{ 
						PlaneProfile ppi = m.getPlaneProfile("profShape");
						ppi.transformBy(ms2ps);
		
						if (ppi.coordSys().vecZ().isParallelTo(vecZ))
						{
							//{Display dpx(211); dpx.draw(ppi, _kDrawFilled,20);}
							ppr.unionWith(ppi);
						}						
					}
									
				}//next i
				
				//{Display dpx(1); dpx.draw(ppr, _kDrawFilled,20);}
				
				if (ppr.area()>pow(dEps,2))
					pp = ppr;
	
			// Accept potential requests
				Vector3d vecView = vecZ;		vecView.transformBy(ps2ms);	vecView.normalize();	
				String sStereotypes[0];
				Map maps[] = getTSLRequests(t, vecView, sStereotypes);
				for (int i=0;i<maps.length();i++) 
				{ 
					maps[i].transformBy(ms2ps); 
					mapPSRequests.append(maps[i]); 
				}//next i						
			}				
		//endregion 	

		}
		else if (op.bIsValid()) // HSB-19354
		{ 
			Element e = op.element();
			
			Vector3d vec = e.vecZ();
			if (vec.isParallelTo(vecDir))// ignore dim in z-direction: TODO frame width to be detected
			{ 
				continue;
			}
			 
			Quader qdr=op.bodyExtents();
			double dz = qdr.dZ();		 
			 
		// get frame width from potential child openings nested into an assembly
			Opening opcs[0];
			Entity _ents[] = e.elementGroup().collectEntities(true, Opening(), _kModelSpace);
			for (int j=0;j<_ents.length();j++) 
			{ 
				if (_ents[j]==e){ continue;}
				Opening opc= (Opening)_ents[j]; 
				if (opc.parentEntity() == op)
				{ 
					qdr=opc.bodyExtents();
					if (qdr.dZ()>dEps)
					{ 
						dz = qdr.dZ();
						break;
					}
				}
			}//next j	
		
		// on plain openings use element Z
			if (dz < dEps)
			{
				LineSeg seg = e.segmentMinMax();
				dz = abs(vec.dotProduct(seg.ptStart()-seg.ptEnd()));
			}
			
			Body bd;
			if (dz > dEps && op.plShape().area()>pow(dEps,2))
				bd=Body(op.plShape(),vec*dz,0);

			//bd.vis(2);
			bodies[i]=bd;	
			
		}	
		else if (_el.bIsValid())
		{
			Body bd = _el.realBodyTry(_XW+_YW+_ZW);
			Vector3d vecZE = _el.vecZ();
			if (bd.isNull())
			{ 
				PLine plEnvelope = _el.plEnvelope();	//plEnvelope.vis(2);
				Quader qdr=_el.bodyExtents();
				
				LineSeg seg = _el.segmentMinMax();
				double dZ= abs(vecZE.dotProduct(seg.ptEnd() - seg.ptStart()));
				plEnvelope.projectPointsToPlane(Plane(seg.ptMid(), vecZE), vecZE);
				if (dZ<dEps)
					dZ= qdr.dZ();

				if (plEnvelope.area()>pow(dEps,2) && dZ>dEps) //HSB-23539 -3
					bd = Body(plEnvelope, vecZE * dZ, 0);
				if (bd.isNull())
					bd = GetBodyFromQuader(qdr);					
			}

			if (!bd.isNull())
				bodies[i] = bd;
			//bd.vis(4);
		}
		else
		{ 
			PLine pl = ent.getPLine();
			if (pl.length() < dEps)continue;
			if (bHasPage || bIsViewport || bHasSection)
				pl.transformBy(ms2ps);
			//pl.vis(3);
			pp.joinRing(pl, _kAdd);
			if (bShapeEnvelope)
				pp.createRectangle(pp.extentInDir(vecX), vecX, vecY);
		}
		
		if (!bodies[i].isNull())
		{ 
			//int tick = getTickCount();
			if (bHasPage || bIsViewport || bHasSection)
			{
				if (!bdClip.isNull()) // HSB-17320
					bodies[i].intersectWith(bdClip);
				//bodies[i].vis(3);
				bodies[i].transformBy(ms2ps);
				//bodies[i].vis(252);
			}	
			if(bHasSection)// HSB-17320
				pp.unionWith(bodies[i].getSlice(pnView));
			else
			{
				pp.unionWith(bodies[i].shadowProfile(pnView));			
			}
			//reportNotice("\nXX tick "+(getTickCount()-tick) + ent.formatObject(" @(TypeName) @(scriptName:D) Zone = @(ZoneIndex:D;-)"));
		}

		
		if (pp.area() < pow(dEps, 2)){continue;}
		
		//{Display dpx(1); dpx.draw(pp, _kDrawFilled,20);}
		//pp.vis(3);
		
		profiles[i] = pp;
		
		ppAll.unionWith(pp);
		pp.shrink(-dEps);
		if (showSet.find(ent)>-1)
		{
			//pp.vis(2);
			ppVisible.unionWith(pp);
		}
		if (refSet.find(ent)>-1)
		{
			ppRef.unionWith(pp);	
			//ent.getPLine().vis(2);
		}
	}	
	ppVisible.shrink(dEps);	//ppVisible.extentInDir(vecDir).vis(3);
	ppRef.shrink(dEps);		//if (bDebug)ppRef.vis(1);
	ppAll.shrink(dEps);		//{Display dpx(2); dpx.draw(ppAll, _kDrawFilled,50);}
	
	
	
//region Merge profiles // HSB-19355
	if(bDimMerged)
	{ 
		PLine rings[] = ppVisible.allRings(true, false);
		PLine plOpenings[] = ppVisible.allRings(false, true);
		CoordSys csr = ppVisible.coordSys();

	// merge visible rings with intersecting profiles
		for (int r=0;r<rings.length();r++) 
		{ 
			PlaneProfile ppr(csr);
			ppr.joinRing(rings[r],_kAdd);
			for (int o=0;o<plOpenings.length();o++) //HSB-22669
				ppr.joinRing(plOpenings[o],_kSubtract); 

			
		// modify only profiles of the showset	
			for (int i=0;i<showSet.length();i++) 
			{ 
				int n = allSet.find(showSet[i]);
				if (n>-1)
				{ 
					PlaneProfile& pp = profiles[n];
					if (pp.area()<pow(dEps,2))
					{ 
						continue;
					}
					
					PlaneProfile ppi = ppr;				
					if (ppi.intersectWith(pp))
						pp.unionWith(ppr);	
				}
			}//next i			
		}//next r
		
//		if (bDebug)
//		{ 
//			for (int i=0;i<showSet.length();i++) 
//			{ 
//				int n = allSet.find(showSet[i]);
//				if (n>-1)
//				{ 
//					Display dp(i % 5 + 1);
//					dp.draw(profiles[n],_kDrawFilled, 70);					
//				}
//			}			
//		}

	}
//END Merge profiles //endregion 	
	
	
	if (sdv.bIsValid())
	{
		Map m = sdv.subMapX("Preview");
		if (m.hasPlaneProfile("pp"))
			ppVisible = m.getPlaneProfile("pp");
		else
			ppVisible = _Map.getPlaneProfile("ppViewport");
		ppAll = ppVisible;	
	}
	
	if (bShapeEnvelope)
	{
		ppVisible.removeAllOpeningRings();
		ppRef.removeAllOpeningRings();		
	}
		
//	ppVisible.extentInDir(vecX).vis(5);	
//	{Display dp(4); dp.draw(ppVisible, _kDrawFilled,30);}
	
	
	
//region Collect element based requests HSB-17432
	if (bIsElement && sStereotypes.length()>0)
	{ 
		//#st
		TslInst tsls[] = el.tslInst();
		for (int ii=0;ii<tsls.length();ii++) 
		{ 
			TslInst t = (TslInst)tsls[ii];
			if (!t.bIsValid()){ continue;}
			String scriptName = t.scriptName();
			if (sListExcludes.findNoCase(scriptName,-1)>-1){ continue;}
			int bValidStereotype = sStereotypes.findNoCase("*" ,- 1) >- 1 || sStereotypes.findNoCase(scriptName ,- 1) >- 1;
			
		// get from tsl _Map or from hsbInfo subMapX 
			Map requests = t.map().getMap(kRequests); 
			if (requests.length()<1)
				requests = t.subMapX("Hsb_DimensionInfo");

		// no requests found, append origin
			if (requests.length()<1)
			{ 
				if (bValidStereotype)
				{
					Point3d pt = t.ptOrg();
					pt.transformBy(ms2ps);
					ptsReq.append(pt);
					bReqCrossMarks.append(false);
					//if (bDebug)reportNotice("\nOrigin collected of  " +scriptName + " " + t.handle() + "!");
				}
				else{ continue;}
			}							
		// append requests	
			else
			{ 
				//if (bDebug)reportNotice("\n" + requests.length() + " requests collected of  " +scriptName + " " + t.handle());
				for (int j=0;j<requests.length();j++) 
				{ 
					Map m= requests.getMap(j);
					int validStereotype = bValidStereotype;
					String stereotype = m.getString("Stereotype");
					if (stereotype.length()>0)
						validStereotype = sStereotypes.findNoCase(stereotype ,- 1) >- 1;
					if (!validStereotype)	
					{ 
						continue;
					}
		
					m.transformBy(ms2ps);
					
				// Read request content
				
					Point3d ptsChoord[] = m.getPoint3dArray(kCoords);							
					Vector3d vecAllowed = m.getVector3d(kAllowedView);
					int bAlsoReverse = m.getInt(kAlsoReverseDirection);
					Point3d nodes[] = m.getPoint3dArray(kNodes);

				// get coordSys from point list to overcome collectionEntity/block editor issue
					if (ptsChoord.length()==4)
						vecAllowed = ptsChoord[3] - ptsChoord[0];
					vecAllowed.normalize();

				// invalid request
					if (nodes.length()<1 || !vecAllowed.isParallelTo(vecZ) || 
						(!bAlsoReverse && !vecAllowed.isCodirectionalTo(vecZ)))
					{ 
						continue;
					}

					Point3d ptx = nodes.last();
					//ptx.vis(j);
					ptx = nodes.first();
					//vecAllowed.vis(ptx, 40);
					
					m.setEntity("originator", t);
					mapPSRequests.append(m); 	
				}						
			}			
		}//next j
	}
//endregion 	

	
//End Collect items//endregion


//region Diagonal Dimension #vd
	Point3d ptGripVertices[] = ppVisible.getGripVertexPoints();
	
	String sTriggerSetDiagonal = T("|Set Diagonal|");
	PLine plDiag,plDiags[0];
	if (bIsDiagonalDim || ((_bOnRecalc && _kExecuteKey==sTriggerSetDiagonal) ))//|| bDebug))
	{ 
		//reportNotice("\nreading diagonal direction vec = " +vecDiag);
		
		PLine rings[] = ppVisible.allRings(true, false);
		if (rings.length()==1)
		{ 
			rings[0].simplify();
			ptGripVertices = rings[0].vertexPoints(true);
		}
		
	// Simplify / purge vertices which are very closed to the previous
		for (int i=ptGripVertices.length()-1; i>=0 ; i--) 
		{ 
			Point3d pt1=ptGripVertices[i];
			int b = i - 1;
			if (b<0)b=ptGripVertices.length() - 1;
			Point3d pt2=ptGripVertices[b];
			double d =(pt2 - pt1).length();
			if (d<10*dEps) // catch tolerances HSB-18893, Element D024
				ptGripVertices.removeAt(i);
			
		}//next i
	
	// collect all potential diagonal connections		
		for (int i=0;i<ptGripVertices.length()-1;i++) 
		{ 
			Point3d pt1 = ptGripVertices[i];	//pt1.vis(2);
			for (int j=i+1;j<ptGripVertices.length();j++) 
			{ 
				if (j-1==i || (i==0 && j==ptGripVertices.length()-1))
				{
					continue;
				} 
				else
				{ 
				// only diagonals
					Point3d pt2 = ptGripVertices[j];
					PLine pl(vecZ);
					pl.addVertex(pt1);
					pl.addVertex(pt2);
					if (vecY.dotProduct(pt2 - pt1) < 0)pl.reverse();
					if (pl.length()>U(20))
					{ 
						plDiags.append(pl);
						pl.transformBy(vecZ * U(20));
						//pl.vis(j+2);
					}					
				}
			} 		
		}//next i	

	
	//region Order byLength descending
		for (int i=0;i<plDiags.length();i++) 
			for (int j=i+1;j<plDiags.length()-1;j++) 
				if (plDiags[j].length()<plDiags[j+1].length())
					plDiags.swap(j, j + 1);
	//endregion 	
		
	// Get max most aligned with vecDiag
		double dMax;
		for (int i=0;i<plDiags.length();i++) 
		{ 
			PLine& pl = plDiags[i]; 
			Point3d pt2 = pl.ptEnd();
			Point3d pt1 = pl.ptStart();
			
			Vector3d vec = pt2 - pt1; vec.normalize();
			double d = vec.dotProduct(vecDiag);
			//vec.vis(pl.ptMid(), 2);
			double d1 = vecX.dotProduct(vec);
			double d2 = vecX.dotProduct(vecDiag);
			
			int sgn1 = d1!=0?abs(d1) / d1:1;
			int sgn2 = d2!=0?abs(d2) / d2:1;
			
			//if (vec.dotProduct(vecDiag)>0 && d>dMax)
			if (sgn1==sgn2 && d>dMax)
			{ 
				dMax = d;
				plDiag = pl;			
				bDiagonalFound = true;
			}	
			
		}//next index		
		if (bDiagonalFound && bDebug)plDiag.vis(30);
		
	// Get most aligned with -vecDiag
		if (!bDiagonalFound)
			for (int i=0;i<plDiags.length();i++) 
			{ 
				PLine& pl = plDiags[i]; 
				Point3d pt2 = pl.ptEnd();
				Point3d pt1 = pl.ptStart();
				
				Vector3d vec = pt2 - pt1; vec.normalize();
				double d = vec.dotProduct(-vecDiag);
		
				double d1 = vecX.dotProduct(vec);
				double d2 = vecX.dotProduct(-vecDiag);
				
				int sgn1 = d1!=0?abs(d1) / d1:1;
				int sgn2 = d2!=0?abs(d2) / d2:1;
		
				if (sgn1==sgn2 && d>dMax)
				{ 
					dMax = d;
					plDiag = pl;
					bDiagonalFound = true;
					//plDiag.vis(3);
				}	
			}//next index
		//plDiag.transformBy(vecZ * U(20));plDiag.vis(1);

	// fall back to first
		if (!bDiagonalFound && plDiags.length()>0)
		{ 
			plDiag = plDiags[0];
			bDiagonalFound = true;
		}			

		if (bDiagonalFound) // override stored vecDir
		{ 
			Vector3d vec=plDiag.ptEnd()-plDiag.ptStart();
			vec.normalize();
			
			vecDir = vec;
			vecPerp = vecDir.crossProduct(-vecZ);
			
		}
		
	}
//endregion 

//region Distinguish side
	Line lnDir(_Pt0, vecDir);
	Point3d ptLoc = _Pt0;
	Vector3d vecSide = vecPerp;
	
	
// if location is within extents we assume a local dimline if in ortho mode
	int bIsLocal;
	LineSeg segVisible = ppAll.extentInDir(vecDir);		segVisible.vis(161);// ppVisible ppAll
	double dPerpVisible = abs(vecPerp.dotProduct(segVisible.ptStart() - segVisible.ptEnd()));
	
	if (abs(vecPerp.dotProduct(_Pt0-segVisible.ptMid()))<.5*dPerpVisible && bIsOrtho) 
		bIsLocal = true;
	else	
	{ 
		PlaneProfile pp = ppVisible;
		double offset =-.5*textHeight*scale; 		
		pp.shrink(offset);
		// limit triangular shapes from being too much extended
		{
			PlaneProfile rect;rect.createRectangle(ppVisible.extentInDir(vecX), vecX, vecY);
			rect.shrink(offset);//rect.vis(4);
			pp.intersectWith(rect);
		}
		
		if (ppProtect.area()<pow(dEps,2))		ppProtect = pp;
		else									pp = ppProtect;
	}
	if (vecSide.dotProduct(ptLoc - segVisible.ptMid()) < 0)	
		vecSide*=-1;
	
// set base offset when in blockspace
	if (sdv.bIsValid())
	{ 
		_Pt0.setZ(0);
		LineSeg seg = ppVisible.extentInDir(_XW); //seg.vis(5);vecSide.vis(seg.ptMid(), 3);
		double dPerp = abs(vecSide.dotProduct(seg.ptEnd() - seg.ptStart()));
		double d = abs(vecSide.dotProduct(_Pt0 - ppVisible.ptMid())) - .5 * dPerp; // HSB-21565 made abs
		_Map.setDouble(kBaselineOffset, d);
		_Map.setInt(kIsLocal, bIsLocal);
		_Map.setVector3d(kVecSide, vecSide);
		
	}
	else if (bHasPage && (bCreatedByBlockspace || bDebug))// || bDebug))
	{ 
		double baseLineOffset = _Map.getDouble(kBaselineOffset);
		if (_Map.hasVector3d(kVecSide))
			vecSide = _Map.getVector3d(kVecSide);
		bIsLocal = _Map.getInt(kIsLocal);
		if (!bIsLocal)
		{ 	
			PlaneProfile pp = ppAll;	// HSB-23104, previous ppVisible
			LineSeg seg = pp.extentInDir(_XW); seg.vis(3);
			double dPerp = abs(vecSide.dotProduct(seg.ptEnd() - seg.ptStart()));
		
			ptLoc += vecSide * (vecSide.dotProduct(pp.ptMid() - ptLoc) + .5 * dPerp +baseLineOffset);
			_Pt0 += vecSide * vecSide.dotProduct(ptLoc - _Pt0);
			if (_Map.hasVector3d("vecOrg") && _kNameLastChangedProp!="_Pt0")
			{
				Point3d ptOrg = page.coordSys().ptOrg();
				_Map.setVector3d("vecOrg",_Pt0-ptOrg);
			}			
		}
	}

	if (bDebug)vecSide.vis(ptLoc, 1);
	Line lnSide(ptLoc, vecSide);

//endregion	

//region Viewport Specials
	if (bIsViewport)
	{ 
		Viewport vp= _Viewport[_Viewport.length()-1];
		
		// flags to indicate poitive / negative alignment of vecSide with main coordSys
		int bSideOnXP = vecX.dotProduct(vecSide)>0;
		int bSideOnYP = vecY.dotProduct(vecSide)>0;
		
	//Get/Set Baseline Offset for global dimlines linked to an element viewport
		if (bIsHsbViewport && !bDragPt0) // && !bIsLocal
		{ 
		
		//region Adjust vecDir of sloped dimensions on setLayout
			if (!bIsOrtho && _bOnViewportsSetInLayout && !bIsDiagonalDim)
			{ 
				PlaneProfile ppEnvelope = ppVisible;
				Point3d pts[] = ppEnvelope.getGripVertexPoints();
				double dMax;
				Vector3d vecNewDir = vecDir;
				for (int p = 0; p < pts.length(); p++)
				{ 
					int q = p < pts.length() - 2 ? p + 1 : 0;
					Point3d pt1 = pts[p];
					Point3d pt2 = pts[q];	//pt1.vis(p); pt2.vis(q);	
					Point3d ptm = (pt1 + pt2) * .5;
					Vector3d vecDirSeg = pt2 - pt1; vecDirSeg.normalize();
					Vector3d vecSideSeg = vecDirSeg.crossProduct(-vecZ);
					if (ppEnvelope.pointInProfile(ptm+vecSideSeg*dEps)==_kPointInProfile)
					{
						vecDirSeg *= -1;
						vecSideSeg *= -1;
					}
		
					int _bIsOrtho =  vecSideSeg.isParallelTo(vecX) ||  vecSideSeg.isPerpendicularTo(vecX) || (abs(vecSideSeg.dotProduct(vecX)) + 0.001 >1); // catch toleances 
					if (_bIsOrtho){continue;}
					
					int bSegOnXP = vecX.dotProduct(vecSideSeg)>0;
					int bSegOnYP = vecY.dotProduct(vecSideSeg)>0;
					
					if (bSideOnXP==bSegOnXP && bSideOnYP==bSegOnYP)
					{
						//vecSideSeg.vis(ptm, 3);
						PLine plSeg(pt1, pt2);
						if (dMax<plSeg.length())
						{ 
							dMax = plSeg.length();
							vecNewDir = vecDirSeg;
						}
						//plSeg.vis(5);
					}
				}
			
			// set new dir
				int bNewIsOrtho =  vecNewDir.isParallelTo(vecX) ||  vecNewDir.isPerpendicularTo(vecX) || (abs(vecNewDir.dotProduct(vecX)) + 0.001 >1); 
				if (!bNewIsOrtho && !vecNewDir.isParallelTo(vecDir))
				{ 
					vecDir = vecNewDir;
					_Map.setVector3d("vecDir", vecDir);
					setExecutionLoops(2);
					return;
				}
			}
		//endregion 	
	
		// Get/Set Baseline Offset for global dimlines	// HSB-19788: different location can be selected from RMC
		// the base point location will be moved on setLayout if not set to fixed mode
			if (nRefLocMode>0)
			{ 
				PlaneProfile pp = nRefLocMode == 1 ? ppVisible : ppAll;
				Point3d pts[] = pp.getGripVertexPoints();
				pts = Line(_Pt0, vecSide).orderPoints(pts);
				if (pts.length()>0 && showSet.length()>0)
				{ 
					Point3d ptCurRef = bDiagonalFound?plDiag.ptMid():pts.last();
					double currentOffset = vecSide.dotProduct(_Pt0 - ptCurRef);
					double baseLineOffset = _Map.getDouble(kBaselineOffset);
					
					if (!_Map.hasDouble(kBaselineOffset) || _kNameLastChangedProp=="_Pt0" || _bOnDbCreated)
					{
						_Map.setDouble(kBaselineOffset, currentOffset);
						//if (bDebug)reportNotice(("\nbaseline offset set to") + currentOffset);
					}
					else if (abs(baseLineOffset-currentOffset)>dEps)
					{ 
						double d = baseLineOffset - currentOffset;
						if (_bOnViewportsSetInLayout)
						{
							_Pt0 += vecSide * d;
							setExecutionLoops(2);
							if (bDebug)reportNotice(("\nbaseline offset adjusted by ") + d);
						}
					}
				}				
			}
		}

	}

//endregion 

//region Get other sequencing instances linked to the same define set and a lower sequence index
	TslInst tslSeqs[0];
	int nSequences[0];

	if (nSequence>-1)
	{ 
		TslInst tslUpdates[0];
		int nUpdateSequences[0];
		int nextSequence = 1;
	// collect all tsls to be sequenced	
		String k = "Sequencing";
		Entity entTsls[] = Group().collectEntities(true, TslInst(), _kMySpace);	
		for (int i=0;i<entTsls.length();i++) 
		{ 
			Entity e= entTsls[i]; 
			if (e == _ThisInst)continue;
			if (e.subMapXKeys().findNoCase(k,-1)>-1)
			{ 
				Map m = e.subMapX(k);			
				Vector3d side = m.getVector3d("vecSide");
				int sequence = m.getInt("Sequence");

// TODO consider vecSide
				PlaneProfile ppT = m.getPlaneProfile("TextArea");
				if (side.dotProduct(vecSide)<=0) continue;// consider any dim on same side
				
				Entity myEnts[] = m.getEntityArray("Entity[]", "", "Entity"); 
				if (myEnts.find(entDefine)>-1)
				{ 
					TslInst t = (TslInst)e;
					if (t.bIsValid() && tslSeqs.find(t)<0)// && (bDebug && sequence!=nSequence))
					{
						tslSeqs.append(t);
						nSequences.append(sequence);
						//ppT.vis(sequence<nSequence?3:1);
						
						if (sequence<nSequence)
							ppProtect.unionWith(ppT);
						else // update higher sequence
						{ 
							tslUpdates.append(t);
							nUpdateSequences.append(sequence);
							//t.transformBy(Vector3d(0, 0, 0));
						}
							
					}	
					if (nextSequence <= sequence)nextSequence = sequence + 1;
				}
			}		 
		}//next i
		
	// set sequence when set to auto assignment
		if (nSequence==0 && nextSequence>0)
			nSequence.set(nextSequence);

	// order alphabetically
		for (int i=0;i<tslUpdates.length();i++) 
			for (int j=0;j<tslUpdates.length()-1;j++) 
				if (nUpdateSequences[j] > nUpdateSequences[j + 1])
				{
					tslUpdates.swap(j, j + 1);
					nUpdateSequences.swap(j, j + 1);
				}
		
	// trigger higher sequences to be executed	}
		for (int i=0;i<tslUpdates.length();i++) 
		{
			//reportMessage("\n" + _ThisInst.handle() +" updating " + nUpdateSequences[i] + " " + tslUpdates[i].handle());
			tslUpdates[i].transformBy(Vector3d(0, 0, 0));
		}
		
		
		
		//ppProtect.vis(40);
	
	}
//endregion 

//region References
	int bHasReference = (el.bIsValid() || ppRef.area()>pow(dEps,2)) && !bIsPointMode; // HSB-14692 

	
	// restore refprofile at previous location
	if (bDragPt0 && _Map.hasPlaneProfile("ppRef"))
	{
		ppRef = _Map.getPlaneProfile("ppRef");
		Point3d ptLocRef = _Map.getVector3d("vecLocRef");
		ppRef.transformBy(ptLocRef-_Pt0); 
	}
	
	if (bHasReference && showSet.length()>0) // do not add reference points if no showset is present
	{ 
		LineSeg segMinMax = el.bIsValid() ?el.segmentMinMax():LineSeg();
		segMinMax.transformBy(ms2ps);

	//region Modify multiwall segment (typically flat)
		if (em.bIsValid())
		{ 
			Vector3d vecZE = el.vecZ();	
			Point3d ptsZ[0];
			for (int i=0;i<elMultis.length();i++) 
			{ 
				Element e = elMultis[i];
				if (!e.bIsValid())continue;
				LineSeg seg = elMultis[i].segmentMinMax();
				
				CoordSys cs2em = srefs[i].coordSys();
				cs2em.setToAlignCoordSys(e.ptOrg(), e.vecX(), e.vecY(), e.vecZ(), cs2em.ptOrg(), cs2em.vecX(), cs2em.vecY(), cs2em.vecZ() );
				cs2em.transformBy(ms2ps);
				
				seg.transformBy(cs2em);
				ptsZ.append(seg.ptStart());
				ptsZ.append(seg.ptEnd()); 
			}//next i
			ptsZ = Line(el.ptOrg(), vecZE).orderPoints(ptsZ, dEps);
			if (ptsZ.length()>1)
			{ 
				Point3d pt1 = segMinMax.ptStart();
				Point3d pt2 = segMinMax.ptEnd();
				pt1 += vecZE * vecZE.dotProduct(ptsZ.first() - pt1);
				pt2 += vecZE * vecZE.dotProduct(ptsZ.last() - pt2);
				segMinMax = LineSeg(pt1, pt2);				
			}
		}
		//segMinMax.vis(4);			
	//endregion 	

//	//region Collect reference entities / points
//		Entity entRefs[0];	
//		
//		String sPainterRefDef = bFullPainterPath ? sRefPainter : sPainterCollection + sRefPainter;
//		PainterDefinition pd(sPainterRefDef);
//		String sPainterRefType = pd.type();
//		
//		if (pd.bIsValid() && !bDragPt0) // do not collect ref entities during dragging
//			entRefs = pd.filterAcceptedEntities(ents);
//		else 
//			entRefs = ents;
		
	// HSB-19358 allow element reference	
//		int bGetElementContour = sPainter != sDefault && sRefPainter != sDefault && 
//			sPainter != sRefPainter && sPainterRefType.find("Element",0,false)>-1;	
		if (bIsElementRefPD) // bIsTrussPD,bIsGenBeamPD,bIsOpeningPD,bIsElementPD,bIsOpeningRefPD
			ppRef.createRectangle(segMinMax, vecX, vecY);		

		//ppRef.vis(40);
		

		if (bIsLocal)
		{ 
			if (!bDragPt0)
			{ 
				PlaneProfile _ppRef=ppRef;
				_ppRef.shrink(dEps);
				_Map.setPlaneProfile("ppRef", _ppRef);
				_Map.setVector3d("vecLocRef", _Pt0 - _PtW); // store previous location
			}
			else if (bDebug)
			{
				dp.draw(ppRef, _kDrawFilled);
			}
			LineSeg segs[] = ppRef.splitSegments(LineSeg(_Pt0 - vecDir * U(10e5), _Pt0 + vecDir * U(10e5)), true);
			if (segs.length() > 0)ptsRef.setLength(0);
			for (int i=0;i<segs.length();i++) 
			{ 
				ptsRef.append(segs[i].ptStart());
				ptsRef.append(segs[i].ptEnd());	 
			}//next i
		}			
		else if (nRefPointMode == 0) // default
		{ 
			LineSeg seg = ppRef.area() > pow(dEps, 2) ? ppRef.extentInDir(vecDir) : segMinMax;
			//seg.vis(2);
			ptsRef.append(seg.ptStart());
			ptsRef.append(seg.ptEnd());			
		}
		else if (ppRef.area()>pow(dEps,2))
		{ 
			//ppRef.vis(1);
			LineSeg seg = ppRef.extentInDir(vecDir);
			ptsRef.append(seg.ptStart());
			ptsRef.append(seg.ptEnd());			
		}
	//endregion 	
	}
//endregion 

//region Diagonal Dim or Loop items, in case of extremePoints break after first item and use overall (ppVisible) shape
	int numRuleToolFound;

	if (bIsDiagonalDim)
	{ 
		if (bDiagonalFound)
		{
			ptsX.append(plDiag.vertexPoints(true));
		}
	}
	else
	{ 
		Point3d ptPLines[0]; // a collector for points of polylines intersecting with a section plane or not being closed // HSB-23095

		for (int i=0;i<showSet.length();i++) 
		{ 
			Entity ent= showSet[i]; 
			CollectionEntity ce = (CollectionEntity)ent;
			
			Element  element= (Element)ent;
			BlockRef bref = (BlockRef)ent;
			GenBeam gb = (GenBeam)ent;
			TslInst t = (TslInst)ent;
			Opening op = (Opening)ent;
			Body bd;
			PlaneProfile pp(cs), ppParent(cs);
			int bHasParent;
			
			PLine rings[0];
			int _bIsLocal = bIsLocal;

			int n =allSet.find(ent);
			if (n<0){ continue;}
			
			String s = ent.typeDxfName();

		// extreme Points
			if (sShapeMode==tExtremePoint)		
			{ 
				pp = ppVisible;
				rings = pp.allRings(true, false);
			  	if (!_bIsLocal)	
			  	{
			  		LineSeg seg = pp.extentInDir(vecDir);		  		
			  		if (!bHasReference) // ref points by entity
			  		{ 
				  		ptsRef.append(seg.ptStart());
				  		ptsRef.append(seg.ptEnd());		  			
			  		}
			  	}				
			}
		// genbeam
			else if (gb.bIsValid())
			{
				bd = bodies[n];
			  	pp = profiles[n];
			  	if (_bIsLocal)
			  	{ 
			  		LineSeg segs[] = pp.splitSegments(LineSeg(_Pt0-vecDir*U(10e4),_Pt0+vecDir*U(10e4)), true);
			  		Point3d pts[0];
			  		for (int j=0;j<segs.length();j++) 
			  		{ 
			  			pts.append(segs[j].ptStart());
			  			pts.append(segs[j].ptEnd()); 
			  		}//next j
			  		ptsX.append(pts);
			  		_bIsLocal= pts.length() >0;
			  	}
			  	
			  // global dim	
			  	if (!_bIsLocal)	
			  	{
			  		LineSeg seg = pp.extentInDir(vecDir);		  		
			  		if (!bHasReference && seg.length()>dEps) // ref points by entity
			  		{ 
				  		ptsRef.append(seg.ptStart());
				  		ptsRef.append(seg.ptEnd());		  			
			  		}
			  		rings.append(pp.allRings(true, (bShapeReal || bShapeBasic) ));
			  		
			  	}
			}
		// tsl
			else if (t.bIsValid())
			{
				//reportNotice("\nT:" + t.scriptName());
			  	bd = bodies[n];
			  	pp = profiles[n];
			  	if (_bIsLocal)
			  	{ 
			  		LineSeg segs[] = pp.splitSegments(LineSeg(_Pt0-vecDir*U(10e4),_Pt0+vecDir*U(10e4)), true);
			  		Point3d pts[0];
			  		for (int j=0;j<segs.length();j++) 
			  		{ 
			  			pts.append(segs[j].ptStart());
			  			pts.append(segs[j].ptEnd()); 
			  		}//next j
			  		ptsX.append(pts);
			  		_bIsLocal= pts.length() >0;
			  	}
			  	if (!_bIsLocal)	
			  	{
			  		LineSeg seg = pp.extentInDir(vecDir);		  		
			  		if (!bHasReference && seg.length()>dEps) // ref points by entity
			  		{ 
				  		ptsRef.append(seg.ptStart());
				  		ptsRef.append(seg.ptEnd());		  			
			  		}	
			  		rings.append(pp.allRings(true, (bShapeReal || bShapeBasic) ));
			  		
			  	}
	
			}		
			else if (ce.bIsValid())
			{ 			
				int n = ces.find(ce);
				if (n>-1 && !bDimMerged && sDimPointMode!=tExtremePoint)
				{ 
					Map mapCE = mapCEs[n];
					for (int j=0;j<mapCE.length();j++) 
					{ 
						if (mapCE.hasPlaneProfile(j))
						{ 
							PlaneProfile ppj = mapCE.getPlaneProfile(j);
							if (bDebug)ppj.vis(j);
							rings.append(ppj.allRings(true, (bShapeReal || bShapeBasic)?true:false));
						}
							 						 
					}//next j
					
					pp = ppCERefs[n]; // set for ref
					//pp.vis(4);
					ppParent= ppCEs[n]; // the overall outline to identify valid segments in global mode
					bHasParent = true;
					if (pp.area()>pow(dEps,2))
						bHasReference = true;
				}
				else if (n>-1)
				{
					pp = ppCEs[n];
					rings = pp.allRings(true, (bShapeReal || bShapeBasic)?true:false);
				}
				else
					rings = pp.allRings(true, (bShapeReal || bShapeBasic)?true:false);
			}
			else if (bref.bIsValid())
			{ 			
				int n = brefs.find(bref);
				if (n>-1)
					pp = ppBREFs[n];

				rings = pp.allRings(true, (bShapeReal || bShapeBasic)?true:false);
			}			
			else if (op.bIsValid() && bIsOrtho)
			{ 
				n =allSet.find(op);
				if (n<0)
				{
					continue;
				}			
//			  	bd = bodies[n];
			  	pp = profiles[n];
			  	//{Display dpx(1); dpx.draw(pp, _kDrawFilled,20);}
				rings.append(pp.allRings(true, true));

			}
			else if (element.bIsValid())
			{ 
				n =allSet.find(element);
				if (n<0)
				{
					continue;
				}			
			  	bd = bodies[n];
			  	pp = profiles[n];	
			  	rings.append(pp.allRings(true, true));
			  	//{Display dpx(1); dpx.draw(pp, _kDrawFilled,20);}
			}
		// any entity which carries a polyline	
			else
			{ 
				PLine pline = ent.getPLine();	
				pline.transformBy(ms2ps);
				
				
				Vector3d vecZP = pline.coordSys().vecZ();
	
				// ignore zero length
				if (pline.length()<dEps) 
				{
					continue;
				}
				// collect potential section intersections
				else if (bHasSection && vecZP.isPerpendicularTo(vecZ))
				{
					Point3d pts[] = pline.intersectPoints(Plane(_PtW, _ZW));
					for (int p=0;p<pts.length();p++) 
					{ 
						//pts[p].vis(40); 
						ptPLines.append(pts[p]);
					}//next p	
					pline.vis(40);
					continue;
				}
				// collect not closed pline
				else if (!bHasSection && vecZP.isParallelTo(vecZ) && !pline.isClosed())
				{ 
					Point3d vertices[] = pline.vertexPoints(true);

					Point3d ptStart = pline.ptStart();
					Vector3d vecStart= -pline.getTangentAtPoint(ptStart);		vecStart.vis(ptStart, 2);
					
					Point3d ptEnd = pline.ptEnd();
					Vector3d vecEnd = pline.getTangentAtPoint(ptEnd);			vecEnd.vis(ptEnd, 3);

				//end point towards dimline	
					if (vertices.length()<3 && vecStart.isParallelTo(vecDir))
					{ 
						ptPLines.append(vecStart.dotProduct(vecPerp)<0?ptStart:ptEnd);
					}
				// collect all vertices
					else
					{
						ptPLines.append(vertices);
					}
				}
				// ignore if pline is not perpendicular
				else if (vecZP.isPerpendicularTo(vecZ))
				{
					continue;
				}	

//				vecZP.vis(pline.ptMid(), 2);
//				vecZ.vis(pline.ptMid(), 150);
//				vecPerp.vis(pline.ptMid(), 3);
				pline.vis(5);
				
				if (bShapeEnvelope)
				{ 
					PlaneProfile ppi(pline);
					pline.createRectangle(ppi.extentInDir(vecX), vecX, vecY);
				}
	
			// local
				if (_bIsLocal)
				{
					Point3d pts[]=pline.intersectPoints(Plane(_Pt0, vecPerp));
					ptsX.append(pts);
					_bIsLocal= pts.length() >0;
				}
				if (!_bIsLocal)
				{
					rings.append(pline);
					pp.joinRing(pline, _kAdd);
				}
			}
	
		// collect dimpoints of segments
			for (int r=0;r<rings.length();r++) 
			{ 
				PLine pl = rings[r]; 			pl.transformBy(vecZ*U(50));pl.vis(6);
				pl.reconstructArcs(dEps, 70);
				PlaneProfile ppRing(pl);
				Vector3d vecZP = pl.coordSys().vecZ();
				Point3d pts[] = pl.vertexPoints(false);

				Point3d _ptsX[0];
				
			// local
				if (_bIsLocal)
				{
					Point3d pts[]=pl.intersectPoints(Plane(_Pt0, vecPerp));
					_ptsX.append(pts);
					_bIsLocal= pts.length() >0;
				}

			// loop vertices
				if (!_bIsLocal)
				for (int p=0;p<pts.length()-1;p++) 
				{ 
					Point3d pt1 = pts[p];	
					Point3d pt2= pts[p+1];	//pt1.vis(p); pt2.vis(p+1);
					PLine plSeg(pt1, pt2);
					Point3d ptm = (pt1 + pt2) * .5;
					int bIsArc = (pl.closestPointTo(ptm)-ptm).length()>dEps;//!pl.isOn(ptm);
					Vector3d vecXS = pt2 - pt1;
					if (vecXS.length()<dEps){ continue;} // ignore very short segments
					vecXS.normalize();

					Vector3d vecYS = vecXS.crossProduct(-vecZ);vecYS.normalize();
					if (ppRing.pointInProfile(ptm+vecYS*dEps)==_kPointInProfile)
						vecYS *= -1;

				// skip segments which are nested and part of a parent and not on the overall outline
					if (bHasParent && !_bIsLocal && ppParent.pointInProfile(ptm)==_kPointInProfile)
					{ 
						//vecYS.vis(ptm,1);
						continue;
					}


					Point3d _pts[] ={pt1,pt2};
					
					// vecXS.vis(pt1, 1);				vecYS.vis(pt1, 252);
				// Arc
					if (bIsArc)
					{ 
					// the arc
						plSeg=PLine(vecZP);
						plSeg.addVertex(pt1);
						double d1 = pl.getDistAtPoint(pt1);
						if (abs(d1 - pl.length()) < dEps)d1 = 0;
						plSeg.addVertex(pt2, pl.getPointAtDist(d1+dEps));
									
						Point3d ptmx = plSeg.ptMid();// midpoint on arc
						//vecYS.vis(ptmx, 252);
					// calculate radius from circular segment
						Vector3d vecCen = ptm - ptmx;
						double h = (ptm - ptmx).length();
						if (h < dEps)continue;
						double s = (pt2 - pt1).length();
						double radius = (4 * pow(h,2) + pow(s, 2)) / (8 * h);
						
					//	get center and circle
						vecCen.normalize();
						if (pp.pointInProfile(ptmx+vecYS*dEps)==_kPointInProfile)	vecYS *= -1;	
						//vecYS.vis(ptCen, 72);
						Point3d ptCen = ptmx + vecCen* radius;
						PLine circle; circle.createCircle(ptCen, vecZ, radius);		
					
//						if (bArcCenterOnXY && bIsOrtho && vecYS.dotProduct(vecSide)>0)
//						{ 
//							//circle.vis(p);
//							ptsX.append(ptCen);
//							dp.draw(PLine (ptCen - vecX * .25 * textHeight, ptCen + vecX * .25 * textHeight));
//							dp.draw(PLine (ptCen - vecY * .25 * textHeight, ptCen + vecY * .25 * textHeight));	
//						}
					
					}
					
				// Straight
					else
					{
						if (0 && bDebug)
						{ 
							Display dpx(3);
							dpx.textHeight(U(1));
							dpx.draw(vecXS.dotProduct(vecDir), ptm, _XW, _YW, 0, 0, _kDevice);						
						}
						
						double ddx = abs(vecXS.dotProduct(vecDir));
						int bIsPar = abs(vecXS.dotProduct(vecDir))>.999;
						int bOnSide = vecYS.dotProduct(vecSide)>.01;
						if (!bIsOrtho && !bIsPar)
						{ 
//							vecDir.vis(ptm, 2);
//							vecXS.vis(ptm, 12);
//							vecYS.vis(ptm, 94);
							continue;
						}
						if (!bOnSide)
						{ 
//							vecYS.vis(ptm, 11);
							continue;
						}	
						
						if (!bIsPar && sShapeMode==tEnvelopeShape)// TODO bIsSegmentMode
						{ 
//							vecYS.vis(ptm, 42);
							continue;
						}						
						if (bDebug)PLine(pt1+vecZ*(p+1)*U(5), pt2+vecZ*(p+1)*U(50)).vis(p);
						//vecYS.vis(ptm, 3);
	
						//vecYS.vis(pt1, 32);
						for (int px = 0; px < _pts.length(); px++)
						{
							Point3d& pt = _pts[px];
							
							PlaneProfile ppTest = ppRing;
							if (bIsElement && ppVisible.area()>pow(dEps,2))
								ppTest = ppVisible;
								
							Point3d ptsi[] = lnSide.orderPoints(ppTest.intersectPoints(Plane(pt, vecDir), true, false), true);
							int bFree = ptsi.length() > 0 && vecSide.dotProduct(ptsi.last() - pt) < dEps;
							
						// the vertex points to in free direction	
							if (bFree || ppTest.pointInProfile(pt)==_kPointInProfile) // second condition window assembly HSB-23985
							{
								//pt.vis(_bIsLocal?6:72);
								if (_bIsLocal)
									ptsRef.append(pt);
								else	
								{
									_ptsX.append(pt);
								//	vecYS.vis(pt1, 4);
								}
							}						
						}
					}
	
				}//next p
				
			// append dimpoints
				if (_ptsX.length()>0)
				{ 
					_ptsX = Line(_Pt0, vecDir).orderPoints(_ptsX, dEps);
					
					if (sDimPointMode==tPMFirstPoint || sDimPointMode==tPMFirstPointMerged)
						ptsX.append(_ptsX.first());
					else if (sDimPointMode==tPMLastPoint || sDimPointMode==tPMLastPointMerged)
						ptsX.append(_ptsX.last());	
					else if (sDimPointMode==tPMMidPoint || sDimPointMode==tPMMidPointMerged)
						ptsX.append((_ptsX.first()+_ptsX.last())*.5);							
					else if (sShapeMode==tExtremePoint || sShapeMode == tEnvelopeShape)
					{ 
						ptsX.append(_ptsX.first());
						ptsX.append(_ptsX.last());	
					}
					
					else
						ptsX.append(_ptsX);	
				}
				
				
				
			}//next r	
			
			if (!bIsLocal && ptsRef.length()<1 && bHasReference)
			{ 
				LineSeg seg = pp.extentInDir(vecDir);		//seg.vis(6);
				ptsRef.append(seg.ptStart());
				ptsRef.append(seg.ptEnd());			
			}
			
		// break if in extremePoint mode	
			if (sShapeMode==tExtremePoint)	
			{
				break;
			}
		}//next i	
		
	//region Append potential points collected from polyline / section interscetion
		if (ptPLines.length()>0)
		{ 

			ptPLines = Line(_Pt0, vecDir).orderPoints(ptPLines, dEps);
			
			if (sDimPointMode==tPMFirstPoint || sDimPointMode==tPMFirstPointMerged)
				ptsX.append(ptPLines.first());
			else if (sDimPointMode==tPMLastPoint || sDimPointMode==tPMLastPointMerged)
				ptsX.append(ptPLines.last());				
			else if (sDimPointMode==tPMMidPoint || sDimPointMode==tPMMidPointMerged)
				ptsX.append((ptPLines.first()+ptPLines.last())*.5);							
			else if (sShapeMode==tPMExtremePoint || sShapeMode == tEnvelopeShape)
			{ 
				ptsX.append(ptPLines.first());
				ptsX.append(ptPLines.last());	
			}
			else
				ptsX.append(ptPLines);	
		}
	//endregion 	
	
	}
		

//endregion 		



//region Function DrawInvalidSymbol
	// draws the invalid / delete cross
	void DrawInvalidSymbol(PlaneProfile pp)
	{ 
		CoordSys cs = pp.coordSys();
		Point3d pt = pp.ptMid();
		double size = getViewHeight() / 30;
		Vector3d vec = cs.vecX() * size + cs.vecY() * .1 * size;
		PlaneProfile ppx; ppx.createRectangle(LineSeg(pt - vec, pt + vec), cs.vecX(), cs.vecY());
		vec = cs.vecY() * size + cs.vecX() * .1 * size;
		PlaneProfile ppy; ppy.createRectangle(LineSeg(pt - vec, pt + vec), cs.vecX(), cs.vecY());
		ppx.unionWith(ppy);
		CoordSys rot; rot.setToRotation(45, vecZ, pt);
		ppx.transformBy(rot);
	
		Display dp(-1);
		dp.trueColor(red);
		dp.draw(ppx, _kDrawFilled, 30);
		dp.draw(ppx);
		
		return;
	}//endregion


//region Offset Mode #OM
	if (bIsOffsetMode)
	{ 
		String kGripKey = "OffsetMode";
		String toolTip = T("|Controls location of offset dimension, move far out to delete|");
		_PtG.setLength(0);
		addRecalcTrigger(_kGripPointDrag, "_Grip");	
	
	
	//region Make sure setup location is outside of paperspace
		Layout layout(Layout().currentLayout());
		PlaneProfile ppPaperSpace;
		Point3d ptPaper = layout.paperLowerLeft();
		ppPaperSpace.createRectangle(LineSeg(ptPaper, ptPaper + _XW * layout.paperSizeX() + _YW * layout.paperSizeY()), _XW, _YW );
		Point3d ptMidPaper = ppPaperSpace.ptMid();
		if (ppPaperSpace.pointInProfile(_Pt0)!=_kPointOutsideProfile)
		{ 
			ppPaperSpace.vis(1);
			Point3d pt = ppPaperSpace.closestPointTo(_Pt0);pt.vis(5);
			double dx = _XW.dotProduct(pt - _Pt0);
			double dy = _YW.dotProduct(pt - _Pt0);
			
			if (abs(dx)>abs(dy))
			{
				int sgn = abs(dx)>0?abs(dx) / dx : 1;
				_Pt0 += _XW * (dx + sgn * textHeight);
			}
			else
			{ 
				int sgn = abs(dy)>0?abs(dy) / dy : 1;
				_Pt0 += _YW * (dy + sgn * textHeight);				
			}
			
		}			
	//endregion 

	//region Get stored grips of current element
		Map mapVieportGrips = this.subMapX(kViewportGrip);
		//if (bDebug && _bOnRecalc){_Grip.setLength(0);this.removeSubMapX(kViewportGrip);}
		if (_bOnViewportsSetInLayout)
			_Grip = GetGripsFromMap(mapVieportGrips, el);
		int bHasGrips = _Grip.length() < 1;
		int nPurgeIndices[0];
		Point3d ptLocs[0];
		if (!bDrag && _kNameLastChangedProp!="_Pt0")//  && !bDebug)
		{
			//reportNotice("\npurge grip viewport map");
			PurgeViewportMap(mapVieportGrips, el);// remove any entry of the stored map as it will be rewritten		
		}
	
		for (int i=0;i<_Grip.length();i++) 
		{
			Point3d ptLoc = _Grip[i].ptLoc();
			ptLocs.append(ptLoc); 
		}			
	//endregion 	

	// Find common range
		PlaneProfile ppEdges[0];
		
//		// TODO openings should be supported
//		for (int j=0;j<2;j++) 
//		{ 
//			PLine rings[]=ppVisible.allRings(j==0, j==1); 
//			PlaneProfile ppCommon(ppVisible.coordSys());
//			for (int r=0;r<rings.length();r++) 
//				ppCommon.joinRing(rings[r], _kAdd); 
//
//			if (ppCommon.intersectWith(ppRef))
//			{ 
//				ppCommon.removeAllOpeningRings();
//				ppCommon.vis(j + 5);
//				ppEdges.append(CollectStraightEdges(ppCommon, j==1, mapDimParameter));
//			}
//			
//		}//next j
		// TODO meanwhile only go for voids
		PlaneProfile ppCommon = ppVisible;
		if (ppCommon.intersectWith(ppRef))
		{
			ppCommon.removeAllOpeningRings();
			ppEdges = CollectStraightEdges(ppCommon, false, mapDimParameter);
		}


		
		
		if (ptLocs.length()<1)
		{ 
			for (int i=0;i<ppEdges.length();i++) 
			{
				PlaneProfile& pp = ppEdges[i];
				Point3d ptLoc = pp.ptMid();				
				CoordSys csi = pp.coordSys();
				Vector3d vecDir = csi.vecZ();
				
				ptLocs.append(ptLoc);	
				Map m;
				m.setEntity("Element", el);	//		m.setEntityArray(opLinks, true, "ent[]", "", "ent");
				m.setVector3d("vecX", vecDir);
				m.setVector3d("vecY", vecDir.crossProduct(-vecZ));
				m.setInt("IsRelativeToEcs", false);
				Grip grip = CreateGrip(m, ptLoc, 4, _kGSTCircle, toolTip);
				_Grip.append(grip);
			}
		}

	// find edge per grip			
		for (int i=0;i<ptLocs.length();i++) 
		{ 
			Point3d ptLoc = ptLocs[i];
			PlaneProfile pp = FindClosestProfileEdge(ppEdges, ptLoc);
			if (pp.area()<pow(dEps,2))
			{ 
				if (indexOfMovedGrip>-1)
				{ 
					PlaneProfile pp(CoordSys(_Grip[indexOfMovedGrip].ptLoc(), vecX, vecY, vecZ));
					DrawInvalidSymbol(pp);	
					nPurgeIndices.append(i);
				}
				continue;
			}
			//pp.vis(6);		
			CoordSys csi = pp.coordSys();
			Vector3d vecDir = csi.vecZ();
			Vector3d vecPerp = vecDir.crossProduct(-ppVisible.coordSys().vecZ());

			Point3d pt1=ptLoc, pt2=ptLoc;
			int bOk1 = GetClosestIntersectionPoint(ppVisible, pt1, vecDir, false);
			int bOk2 = GetClosestIntersectionPoint(ppRef, pt2, vecDir, true);
			
			double offset = vecDir.dotProduct(pt2 - pt1)/scale;
			double gripOffset = vecDir.dotProduct(ptLoc - pt1);
			
			Map params = mapDimParameter;
			if (sFormat.find("Oversail",0,false)>-1)
			{ 
				String arg = offset > 0 ? T("|Undersail|") : T("|Oversail|");
				if (sFormat.find("<>",0,false)>0)
					arg += " <>";
				params.setString("deltaFormat", arg);	
			}
			
		// Relocate grip or mark to be removed
			if (i<_Grip.length())
			{ 
				if (gripOffset>10*textHeight || abs(offset)<dEps)
				{ 
					if (indexOfMovedGrip==i)
					{ 
						PlaneProfile pp(CoordSys(ptLoc, vecX, vecY, vecZ));
						DrawInvalidSymbol(pp);							
					}
					nPurgeIndices.append(i);
					//ptLoc.vis(1);
					continue;
				}
				else
				{
					_Grip[i].setPtLoc(pt1);
					ptLoc.vis(3);					
				}
			}


			if (bOk1 && bOk2 && abs(offset)>dEps*scale)
			{ 
				Point3d ptsDim[] ={ pt1, pt2};
				//pt1.vis(1);					pt2.vis(5);	
				// TODO this could be used to reference to any stud if the grip is not relocated respectivly relocated to the closest location
				DrawDim(ptsDim, ptLoc, vecDir, vecPerp, 5 * _YW - _XW, params, dp);
			}
			
		}//next i
		//{ Display dpx(3); dpx.draw(ppCommon, _kDrawFilled, 50);}


		if (bDrag)
		{ 
			//DrawPlaneProfile2(ppAll, 0, darkyellow, 20, dpDrag);
			DrawPlaneProfile2(ppVisible, 0, darkyellow, 70, dpDrag);
			DrawPlaneProfile2(ppRef, 0, lightblue, 70, dpDrag);
			
			{Display dpx(1); dpDrag.draw(ppVisible, _kDrawFilled,70);}
		}
		
//		{ Display dpx(5); dpx.draw(ppVisible, _kDrawFilled, 80);}
//		{ Display dpx(32); dpx.draw(ppRef, _kDrawFilled, 60);}

		
	// Store grips in map	
		for (int i=_Grip.length()-1; i>=0 ; i--) 
		{ 
			Point3d ptLoc = _Grip[i].ptLoc();
			
			if (bOnDragEnd && nPurgeIndices.find(i)>-1)
			{ 
				_Grip.removeAt(i);
				continue;
			}
			
			Map mapStream;
			mapStream.setString("toolTip", toolTip);
			mapStream.setEntity("ent", el);
			mapStream.setVector3d("vecX", _XW);
			mapStream.setVector3d("vecX", _YW);						
			mapStream.setPoint3d("ptLoc", ptLoc);
			mapStream.setInt("IsRelativeToEcs", false);
			
			mapVieportGrips.appendMap(kGripKey, mapStream);
		}

		if (!bDrag)this.setSubMapX(kViewportGrip,mapVieportGrips);
		
	//region Trigger AddDimension
		String sTriggerAddDimension = T("|Add Dimension|");
		addRecalcTrigger(_kContextRoot, sTriggerAddDimension );
		if (_bOnRecalc && _kExecuteKey==sTriggerAddDimension)
		{

			PrPoint ssP(T("|Pick location|"));
		    Map mapArgs, mapEdges;
		    mapArgs.appendMap("ppEdge[]", SetPlaneProfilesToMap(ppEdges));
			mapArgs.setPlaneProfile("ppVisible", ppVisible);
			mapArgs.setPlaneProfile("ppRef", ppRef);
			mapArgs.setMap("mapDimParameter", mapDimParameter);
			Point3d ptLocs[0];
		    int nGoJig = -1;
		    while (nGoJig != _kNone) //nGoJig != _kOk && 
		    {
		        nGoJig = ssP.goJig(kJigAddOffset, mapArgs); 
		        if (bDebug)reportMessage("\n" +kJigAddOffset + " goJig returned: " + nGoJig);
		        
		        if (nGoJig == _kOk)
		        {
		            Point3d ptLoc = ssP.value(); //retrieve the selected point
		            
		            
					PlaneProfile pp = FindClosestProfileEdge(ppEdges, ptLoc);
					if (pp.area()>pow(dEps,2))
					{ 
						//pp.vis(6);		
						CoordSys csi = pp.coordSys();
						Vector3d vecDir = csi.vecZ();
						Vector3d vecPerp = vecDir.crossProduct(-ppVisible.coordSys().vecZ());
						
						Point3d pt1=ptLoc, pt2=ptLoc;
						int bOk1 = GetClosestIntersectionPoint(ppVisible, pt1, vecDir, false);
						int bOk2 = GetClosestIntersectionPoint(ppRef, pt2, vecDir, true);
						
						double offset = vecDir.dotProduct(pt2 - pt1)/scale;

						if (bOk1 && bOk2 && abs(offset)>dEps*scale)
						{ 
							ptLocs.append(pt1);
							mapArgs.setPoint3dArray("ptLocs", ptLocs);
						}				
					}		              
		        }
//		        else if (nGoJig == _kKeyWord)
//		        { 
//		            if (ssP.keywordIndex() == 0)
//		                mapArgs.setInt("isLeft", TRUE);
//		            else 
//		                mapArgs.setInt("isLeft", FALSE);
//		        }
		        else if (nGoJig == _kCancel)
		        { 
		            break;
		        }
		        
		    //region Append Grips
		    	for (int i=0;i<ptLocs.length();i++) 
		    	{ 
		    		Point3d ptLoc= ptLocs[i]; 
		    		
					Map m;
					m.setEntity("Element", el);	//		m.setEntityArray(opLinks, true, "ent[]", "", "ent");
					m.setVector3d("vecX", vecDir);
					m.setVector3d("vecY", vecDir.crossProduct(-vecZ));
					Grip grip = CreateGrip(m, ptLoc, 4, _kGSTCircle, toolTip);
					_Grip.append(grip);			    		 
		    	}//next i	    		
		    //endregion 
  
		    }			

			
			setExecutionLoops(2);
			return;
		}//endregion	
	
	
	//region Draw Setup Info
		String text = scriptName() + "\n" + 	sDimPointMode + "("+_Grip.length()+")";
		double xFlag = _XW.dotProduct(_Pt0 - ptMidPaper) < 0 ?- 1 : 1;
		double yFlag = _YW.dotProduct(_Pt0 - ptMidPaper) < 0 ?- 1 : 1;	
		dp.draw(text, _Pt0, _XW, _YW, xFlag, yFlag);
	//endregion 
	
	


	//region Trigger DeltaOnTop
		String sTriggerDeltaOnTop = T("|Swap Delta/Chain|");
		if (nDeltaMode!=_kDimClassic)
			addRecalcTrigger(_kContextRoot, sTriggerDeltaOnTop );
		if (_bOnRecalc && _kExecuteKey==sTriggerDeltaOnTop)
		{
			_Map.setInt(kDeltaOnTop,!bDeltaOnTop);		
			setExecutionLoops(2);
			return;
		}//endregion



	
		// update screen
		if (bOnDragEnd)setExecutionLoops(2);
		
		return;
	}
//endregion 




//Part #3 //endregion 

//region Formatting
	String sVariables[]=_ThisInst.formatObjectVariables();
	Map mapAdditionals;	
	{ 
		String k;
// TODO		
//		k = "Area";
//		if (sVariables.findNoCase(k,-1)<0)
//		{
//			mapAdditionals.setDouble(k, ppShapeOpening.area(), _kArea);
//			sVariables.append(k);
//		}
	}		
//endregion	

//region Collect request dimpoints
	int nNumToolRequest;
	
	Entity entValidRequestors[0];
	for (int i=0;i<mapPSRequests.length();i++) 
	{ 
		Map m= mapPSRequests[i]; 
		
		Point3d ptsChoord[] = m.getPoint3dArray(kCoords);							
		Vector3d vecAllowed = m.getVector3d(kAllowedView);
		Vector3d vecDimLineDir = m.getVector3d(kDimLineDir);
		Vector3d vecPerpDimLineDir = m.getVector3d(kDimLinePerp);
		int bAlsoReverse = m.hasInt(kAlsoReverseDirection)?m.getInt(kAlsoReverseDirection):true;
		Point3d nodes[] = m.getPoint3dArray(kNodes);
		Entity originator = m.getEntity("originator");
		int bAllowCrossMark = m.getInt(kAllowCrossMark);
		
		
	// get coordSys from point list to overcome collectionEntity/block editor issue
		if (ptsChoord.length()==4)
		{
			vecDimLineDir = ptsChoord[1] - ptsChoord[0];		vecDimLineDir.normalize();
			vecPerpDimLineDir = ptsChoord[2] - ptsChoord[0];	vecPerpDimLineDir.normalize();
			vecAllowed = ptsChoord[3] - ptsChoord[0];			vecAllowed.normalize();
		}

	// invalid request
		if (nodes.length()<1 || !vecAllowed.isParallelTo(vecZ) || !originator.bIsValid() || 
			(!bAlsoReverse && !vecAllowed.isCodirectionalTo(vecZ)))
		{ 
			continue;
		}		
		nNumToolRequest++;

	// exclude if toolRequesters are defined and originator is not in list
		if (entSelectedRequestors.length()>0 && entSelectedRequestors.find(originator)<0)
		{ 
			continue;
		}
		
		if (entValidRequestors.find(originator)<0)
			entValidRequestors.append(originator);
			
		if (nodes.length()>0) // && vecAllowed.isParallelTo(vecZ))	
		{
			vecAllowed.vis(nodes.first(), m.getInt("Color"));
			if (bDebug)vecPerpDimLineDir.vis(nodes.first(), 3);
		}
		// 
		if (vecAllowed.isParallelTo(vecZ) && (vecPerpDimLineDir.bIsZeroLength() || vecPerpDimLineDir.isParallelTo(vecSide)))
		{
			//reportNotice("\nAligned Request found in " +originator.formatObject("@(ScriptName:D) @(TypeName:D) @(Handle)"));
			Point3d nodes[] = m.getPoint3dArray(kNodes);
			if (m.hasPoint3d("ptRef") && nodes.length()<1)
				nodes.append(m.getPoint3d("ptRef"));						
			ptsReq.append(nodes);
			for (int p=0;p<nodes.length();p++) 
				bReqCrossMarks.append(bAllowCrossMark); 

		// show corresponding tool shape		
			if ((bDragPt0 || _bOnJig) && m.hasPlaneProfile("Shape"))
			{ 
				dpDrag.trueColor(lightblue, 70);
				dpDrag.draw(m.getPlaneProfile("Shape"), _kDrawFilled);
			}				
		}		 
	}//next i
//End  Part #3 Output //endregion 

//region Dimension
	PlaneProfile ppSnap = ppVisible;//ppAll;//
	ppSnap.unionWith(ppRef);
	ppSnap.removeAllOpeningRings();
	ppSnap.shrink(-.1 * textHeight);

	Point3d ptsDim[0];
	int deltaOnTop = vecSide.dotProduct(vecPerp)<0?bDeltaOnTop:!bDeltaOnTop;

	sFormat.setDefinesFormatting(_ThisInst, mapAdditionals);
	String text = bDebug ? scriptName() + "\\P" : _ThisInst.formatObject(sFormat, mapAdditionals);
	

//endregion 

//region AddRubGrid // HSB-24123 Custom Grid Dimensioning
	int bAllowRubGrid = mapSetting.getMap("CustomSettings\PaperSpace").getInt("RUB-Grid") && bIsHsbViewport;
	TslInst tslRubGrid;
	if (bAllowRubGrid)
	{
		Entity ent = _Map.getEntity("rubGrid");
		tslRubGrid = (TslInst)ent;
	}
	
//endregion 

//region Multiple Dimlines
	Vector3d vecYElemPS;
	if (el.bIsValid())
	{
		vecYElemPS = el.vecY();
		vecYElemPS.transformBy(ms2ps);
	}

	//region GableMode	
	if (bIsGableMode)
	{ 
		String kGripKey = "GableLayout";
		String toolTip = T("|Moves dimline location for element| ") + el.number();
		//_Pt0.vis(6);
		//dp.draw(ppVisible,_kDrawFilled,70);

	//region Grip Management #GM1		
		Map mapVieportGrips = this.subMapX(kViewportGrip);
		//reportNotice("\nreading " + mapVieportGrips.length() + " of element " +el.number());//XX
		//_ThisInst.setAllowGripAtPt0(!bHasGableDim);
		
		if (bDebug && _bOnRecalc){_Grip.setLength(0);this.removeSubMapX(kViewportGrip);}

	// remove all grips on set layout and restore from map
		if (_bOnViewportsSetInLayout)
		{
			_Grip = GetGripsFromMap(mapVieportGrips, el);
		}
		
	// remove any entry of the stored map as it will be rewritten
		for (int i=mapVieportGrips.length()-1; i>=0 ; i--) 
		{ 
			if(!mapVieportGrips.hasMap(i)){ continue;}
			Map m= mapVieportGrips.getMap(i); 
			Entity e= m.getEntity("ent");
			if (e.bIsValid() && e==el)
				mapVieportGrips.removeAt(i, true);			
		}//next i
	
	// flag each grip indicating if dimension points are associated, default false
		int bHasGripPoints[_Grip.length()]; 
	//End Grip Management #GM1 //endregion 

	//region Collect non orthogonal segments from voids
		LineSeg segs[] = collectNonOrthoSegements(ppVisible);
		Vector3d vecSegDirs[] = getSegmentDirections(segs);
		for (int i=0;i<vecSegDirs.length();i++) 
		{ 
			Vector3d vecDir = vecSegDirs[i];
			vecPerp = vecDir.crossProduct(-_ZW);
			LineSeg segsC[] = combineSegments(segs, ppVisible, vecDir);
			
			Point3d pts[0];
			for (int j=0;j<segsC.length();j++) 
			{ 
				if (j==0 && ppVisible.pointInProfile(segsC[j].ptMid()+vecPerp*dEps)!=_kPointOutsideProfile)
				{
					vecDir *= -1;
					vecPerp *= -1;
				}
				
				
				pts.append(segsC[j].ptStart());
				pts.append(segsC[j].ptEnd());	
			}//next j
			
			if (pts.length()<2) { continue;}
			Line lnDir(pts.first(), vecDir);
			
			pts = lnDir.orderPoints(pts, dEps * scale);
			if (sDimPointMode == tPMFirstPoint)pts.setLength(1);
			else if (sDimPointMode == tPMLastPoint){pts.reverse();pts.setLength(1);}
			else if (sDimPointMode ==tPMExtremePoint && pts.length()>2)
			{ 
				pts.swap(1, pts.length() - 1);
				pts.setLength(2);
			}
			ptsDim = pts;
			
		// find matching grip by grip.vecX
			int nGrip=-1; //grip index found
			Point3d ptLoc = pts[0]- vecPerp * 2*textHeight;
			
			Map m;
			m.setString("toolTip", toolTip);
			m.setEntity("ent", el);
			m.setPoint3d("vecX", vecDir);
			m.setPoint3d("ptLoc", ptLoc);
			
			for (int j=0;j<_Grip.length();j++) 
			{ 
				Vector3d vecXG= _Grip[j].vecX();
				if (vecXG.isParallelTo(vecDir))
				{ 
					nGrip = j;
					bHasGripPoints[j] = true;
					ptLoc = _Grip[j].ptLoc();
					
					Map mapDX;
					mapDX.setDxContent(_Grip[j].name() , true);
					m=mapDX.hasMap(0)?mapDX.getMap(0):mapDX;
					m.setPoint3d("ptLoc", ptLoc);
					break;
				}			 
			}//next j
			
		// add grip if nothing found
			if (nGrip<0)
			{ 
				String stream = m.getDxContent(true);					
				
				Grip grip;
				grip.setName(stream);
				grip.setPtLoc(ptLoc);
				grip.setVecX(vecDir); 
				grip.setVecY(vecPerp);
				grip.setColor(4);
				grip.setShapeType(_kGSTCircle);
				grip.setToolTip(toolTip);
				_Grip.append(grip);	
				bHasGripPoints.append(true);
				nGrip = _Grip.length() - 1;
				
				//reportNotice("\n	grip appended " + _Grip.length() + " of " +el.number());//XX
			}
			
			if (nGrip>-1)
				mapVieportGrips.appendMap(kGripKey, m);

			DimLine dl(ptLoc, vecDir, vecPerp);	//vecPerp.vis(ptLoc, 40);
			dl.setUseDisplayTextHeight(textHeight!=0);
			Dim dim;
			{
				Point3d _pts[0];
				dim = Dim(dl,  _pts, "",  "", nDeltaMode, nChainMode); 		
			}

			dim.setDeltaOnTop(deltaOnTop);	
			Vector3d vecRead = 5*_YW - _XW;
			dim.setReadDirection(vecRead);


		// Append all dimpoints to the dim itself
			for (int i=0;i<ptsDim.length();i++) 
			{ 
				dim.append(ptsDim[i],"<>",(i==0 && nRefPointMode==1?" ":"<>")); // set first to blank if refpoint given 
			}//next i
			
			if (ptsDim.length()>1)
			{ 
				dp.draw(dim);
				//dp.draw(text, ptLoc, vecDirText, vecPerpText, nDir, 0);			
			}			
			
			
		}//next i

		//reportNotice("\nmapVieportGrips:"+mapVieportGrips.length()+ " stored " + " of element " +el.number());//XX
		this.setSubMapX(kViewportGrip,mapVieportGrips);
		
	//Purge unused grips
		for (int i=_Grip.length()-1; i>=0 ; i--) 
			if (!bHasGripPoints[i])
				_Grip.removeAt(i); 
	//endregion 
		
	}//End GableMode //endregion 

	//region Opening Mode
	else if ((bIsOpeningPD || bIsOpeningRefPD) && openings.length()<1)
	{ 
		_Grip.setLength(0);
	}
	else if (el.bIsValid() && (bIsOpeningPD || bIsOpeningRefPD) && vecDir.isParallelTo(vecYElemPS))
	{ 
		addRecalcTrigger(_kGripPointDrag, "_Grip");	
		if (bDebug && _bOnRecalc)_Grip.setLength(0);
		//reportNotice("\nstarting with grips" +_Grip.length());
		//vecDir.vis(_Pt0, 6);vecPerp.vis(_Pt0, 6);
		
		PlaneProfile ppDir(CoordSys(_Pt0, vecDir, vecPerp, vecDir.crossProduct(vecPerp)));
		
	// collect opening shapes
		PlaneProfile pps[0], ppx(cs);
		for (int i=0;i<openings.length();i++) 
		{ 
			if (i==0)
				sFormat.setDefinesFormatting(openings[i]);

			PlaneProfile pp(el.coordSys());
			pp.joinRing(openings[i].plShape(), _kAdd);
			pp.transformBy(ms2ps);			//pp.vis(i);
			pps.append(pp);	 
		}//next i		
		Point3d ptsG[] = getOpeningGripLocations(ppDir, vecDir, pps);

	//region Restore grips of element on setLayout
		Map mapVieportGrips = this.subMapX(kViewportGrip);
		String sHandle = el.handle();
		String toolTip = T("|Moves dimline location for element| ") + el.number();

		
		if (_bOnViewportsSetInLayout || _bOnDbCreated || (_bOnRecalc && _kExecuteKey==T("|Rotate 90°|")) ||bDebug)// 
		{
		// remove all base grips
			for (int i = _Grip.length() - 1; i >= 0; i--)
			{
				String name = _Grip[i].name();
				if (name.find("BaseLocation",0,false)<0)
				{
					_Grip.removeAt(i);
					//reportNotice("\ngrip removed " + i + " " + name);
				}
			}

		// restore grips fom map
			int cnt;
			for (int i=0;i<mapVieportGrips.length();i++) 
			{ 
			// limit to max required grips	
				if (cnt>ptsG.length()-1)
				{ 
					//reportNotice("\nmax grips reached at" + cnt);
					break;
				}					
				
				//reportNotice("\nviewport grip " + mapVieportGrips.keyAt(i));
				Map m = mapVieportGrips.getMap(i);
				
				Entity e= m.getEntity("Element");
				Element elg = (Element)e;
				Entity links[] = m.getEntityArray("ent[]", "", "ent");
				Vector3d vecx = m.getVector3d("vecDir");
				int bContainsLink;
				for (int j=0;j<links.length();j++) 
				{ 
					if (openings.find(links[j])>-1)
					{
						bContainsLink = true;
						break; 
					}				 
				}//next j
				//reportNotice("\nstored grip " +i+ " contains link " + bContainsLink + " elementmatch " + (el==elg)+elg.bIsValid() + " isParallel " +(vecx.isParallelTo(vecDir)));
				
				
				// make sure the stored grip matches the alignment of the dimline
				if (elg.bIsValid() && elg==el && bContainsLink && vecx.isParallelTo(vecDir))
				{ 
					Point3d pt = m.getPoint3d("ptLoc");

					String stream = m.getDxContent(true);					
					Grip grip;
					grip.setName(stream);
					grip.setPtLoc(pt);
					grip.setVecX(vecDir); 
					grip.setVecY(vecPerp);
					grip.setColor(4);
					grip.setShapeType(_kGSTCircle);
					grip.setToolTip(toolTip);
					_Grip.append(grip);
					
					//reportNotice("\ngrip restored by map" + m);

					cnt++;

				}	
			}//next i

			//reportNotice("\n" +_ThisInst.handle() + " "+ ptsG.length() + " created by createOpeningGripLocations: _kExecuteKey" + _kExecuteKey + "loopCout"+_kExecutionLoopCount);
		}//endregion
		
	//region Loop potential locations
		//reportNotice("\n" + _ThisInst.handle() + " _Grips "+_Grip.length());
		for (int i=0;i<ptsG.length();i++)
		{ 
		//region Identify corresponding grip by the index stored in map content
			// collect openings which refer to this location
			Point3d pt = ptsG[i];
			Opening opLinks[] = linkPointToOpenings(pt, vecDir, openings, pps);
			if (opLinks.length()<1)
			{
				//reportNotice("\nlinkPointToOpenings failed"); 
				continue;
			}
			

			Grip g;
			int n = -1;
			for (int j=0;j<_Grip.length();j++)
			{ 
				Map mapDX;
				mapDX.setDxContent(_Grip[j].name() , true);
				Map m=mapDX.hasMap(0)?mapDX.getMap(0):mapDX;

				Entity e = m.getEntity("Element");

				Vector3d vecx = m.getVector3d("vecDir");
				Entity links[] = m.getEntityArray("ent[]", "", "ent");
				
				int bContainsLink;
				for (int j=0;j<links.length();j++) 
				{ 
					if (opLinks.find(links[j])>-1)
					{
						bContainsLink = true;
						break; 
					}				 
				}//next j


				//reportNotice("\nexisting grip " +i+ " contains link " + bContainsLink + " elemMatch " + (el==e)+e.bIsValid() + " isParallel " +(vecx.isParallelTo(vecDir)));


				if (bContainsLink && e.bIsValid() && e==el)
				{ 					
					n = j;
					//reportNotice("\ngetExistingElementGripBy: " + " Element " + ((Element)e).number() + " detected grip index "+n);
					break;
				}
			}//endregion
					
		//region Get/Set Grip location
			// get identified grip
			Map m;
			if (n>-1)// && _Grip.length()>n)
			{ 
				g=_Grip[n];
				//reportNotice("\n" + _ThisInst.handle() + " grip taken: " + n);
			}
			// append a new grip
			else if (opLinks.length()>0)
			{ 
				//reportNotice("\n" + _ThisInst.handle() + " creating new grip for : " + i + " opLinks" + opLinks.length());
				m.setEntity("Element", el);
				m.setEntityArray(opLinks, true, "ent[]", "", "ent");
				m.setVector3d("vecDir", vecDir);
				m.setVector3d("vecPerp", vecPerp);
				String name = m.getDxContent(true);
				
				Grip grip;
				g.setName(name);
				g.setPtLoc(pt);
				g.setVecX(vecDir);
				g.setVecY(vecPerp);
				g.setColor(4);
				grip.setToolTip(toolTip);
				g.setShapeType(_kGSTDiamond);
				_Grip.append(g);	
				n = _Grip.length()-1;
			}
			
			
			//if (n<0)				reportNotice("\n" + _ThisInst.handle() + " grip not found for i " + i);
			this.setAllowGripAtPt0(_Grip.length() > 0);
			//endregion
	
		//region Build description by grip and get infinite opening range
			String text;
			PlaneProfile ppx(cs), ppOp(cs);
			for (int j=0;j<opLinks.length();j++) 
			{ 
				Entity& e = opLinks[j];
				int ind = openings.find(e);
				if (ind>-1)
				{ 
					PlaneProfile pp = pps[ind];	
					ppOp.unionWith(pp);	
					pp = GetInfiniteProfileInDir(pp, vecDir);
					ppx.unionWith(pp);		
					
					text +=(text.length()>0?"\n":"")+openings[ind].formatObject(sFormat);// 
	
				}	
			}//next j				
		//endregion 

		//region Get the visible intersection profiles
			PlaneProfile ppDims[0];
			{ 
				PlaneProfile ppd = ppVisible;			//dp.color(i);//dp.draw(ppd, _kDrawFilled, 50);
				if (ppd.intersectWith(ppx))
				{
					for (int j=0;j<showSet.length();j++) 
					{ 
						int x = allSet.find(showSet[j]);
						if (x>-1)
						{ 
							PlaneProfile pp=profiles[x];
							if (pp.intersectWith(ppd))
							{
								ppDims.append(profiles[x]);	
								//dp.draw(profiles[x], _kDrawFilled, 50);
							}
						}
					}//next j
				}					
			}			
			
		// draw while dragging a grip	
			if (indexOfMovedGrip == n)
			{ 
				dp.trueColor(green, 50);
				for (int j=0;j<ppDims.length();j++) 
					dp.draw(ppDims[j], _kDrawFilled); 
				dp.trueColor(lightblue, 50);
				dp.draw(ppOp, _kDrawFilled);
			}

		// draw text
			if (text.length()>0)
				dp.draw(text, g.ptLoc(), el.vecX(), el.vecX().crossProduct(-vecZ), 0, 0);			
		//endregion 
	
		//region Declare Dimline
		
		// dimline
			ptsDim.setLength(0); // local
			DimLine dl(g.ptLoc(), vecDir, vecPerp);	//vecPerp.vis(ptLoc, 40);
			dl.setUseDisplayTextHeight(textHeight!=0);
			Dim dim;
			{
				Point3d pts[0];
				dim = Dim(dl,  pts, "",  "", nDeltaMode, nChainMode); 		
			}
		
			dim.setDeltaOnTop(deltaOnTop);	
			Vector3d vecRead = 5*vecYView - vecXView;
			dim.setReadDirection(vecRead);
			
		//endregion 

		// Get reference points
			Point3d ptsX[0];
			PlaneProfile ppSnapLocal(CoordSys(g.ptLoc(), vecDir, vecPerp, vecDir.crossProduct(-vecDir)));
			ppSnapLocal = GetInfiniteProfileInDir(ppSnapLocal, vecDir);	ppSnapLocal.vis(6);
			ptsDim.append(getReferencePoints(vecDir, vecPerp, vecSide, ptsRef, ptsX, nRefPointMode, ppSnapLocal)); // no side vector given to suppress snap offset (local)


		//region Collect dim nodes
			Point3d nodes[0];
			for (int j=0;j<ppDims.length();j++) 
			{
				LineSeg segs[0];
				segs.append(ppDims[j].splitSegments(LineSeg(g.ptLoc() - vecDir * U(10e5), g.ptLoc() + vecDir * U(10e5)), true));
				for (int s=0;s<segs.length();s++) 
				{ 
					//segs[s].vis(1);
					nodes.append(segs[s].ptStart());
					nodes.append(segs[s].ptEnd()); 
				}//next s
				
			}
			nodes = Line(_Pt0, vecDir).orderPoints(nodes, dEps);				
			ptsDim.append(nodes);
		//endregion 
			
		//region Draw dim
		
		// Append all dimpoints to the dim itself
			for (int j=0;j<ptsDim.length();j++) 
				dim.append(ptsDim[j],"<>",(j==0 && nRefPointMode==1?" ":"<>")); // set first to blank if refpoint given 
			if (ptsDim.length()>1)
				dp.draw(dim);
							
			if (bOnDragEnd) setExecutionLoops(2);
			if (bDrag && indexOfMovedGrip == n)return;	
			
			
		//endregion 

		//region Store grip in map to be retrieved on change layout
			String entry = sHandle + "_" + i;
			Map mapVG = mapVieportGrips.getMap(entry);
			mapVG.setPoint3d("ptLoc", g.ptLoc());
			mapVG.setVector3d("vecDir", vecDir);
			mapVG.setVector3d("vecPerp", vecPerp);
			mapVG.setEntity("Element", el);
			mapVG.setEntityArray(opLinks, true, "ent[]", "", "ent");
			mapVieportGrips.setMap(entry, mapVG);		
			//reportNotice("\nstoring i "+i +" of " + _ThisInst.handle() + "+ entry " + entry);				
		//endregion 

		
		}// next i of opening locations


		//reportNotice("\n" +_ThisInst.handle() +" storing entries " + mapVieportGrips.length() + " drg"+bDrag+bOnDragEnd);// + " links " + opLinks + " vecDir " + vecDir);
		if (bDebug && _bOnRecalc){mapVieportGrips=Map();this.removeSubMapX(kViewportGrip);}
		//_Map.setMap(kViewportGrip,mapVieportGrips);
		this.setSubMapX(kViewportGrip,mapVieportGrips);
	}
	//endregion 


//END Multiple Dimline //endregion 

//End Multiple Dimlines //endregion 

//region Single Dimline
	else
	{ 
		_ThisInst.setAllowGripAtPt0(true);
		
		DimLine dl(ptLoc, vecDir, vecPerp);	//vecPerp.vis(ptLoc, 40);
		dl.setUseDisplayTextHeight(textHeight!=0);
		Dim dim;
		{
			Point3d pts[0];
			dim = Dim(dl,  pts, "",  "", nDeltaMode, nChainMode); 		
		}
		
		dim.setDeltaOnTop(deltaOnTop);	
		Vector3d vecRead = 5*vecYView - vecXView;
		dim.setReadDirection(vecRead);	





	
//region Function GetExtremeIntersectPoints
	// returns
	Point3d[] GetExtremeIntersectPoints(PlaneProfile pp, PLine pl, Vector3d vecSide)
	{ 
		Point3d ptExtremes[0];
		
	// Collect segmented intersections			
		Point3d pts[] = pl.vertexPoints(false);
		for (int p=0;p<pts.length()-1;p++) 
		{ 
			Vector3d vecSeg = pts[p + 1] - pts[p]; vecSeg.normalize();
			if (vecSeg.isPerpendicularTo(vecSide)){ continue;}
			LineSeg seg(pts[p], pts[p+1]);
			
			if (seg.length()>dEps)
			{ 
				LineSeg segs[]=pp.splitSegments(seg, true);
				for (int i=0;i<segs.length();i++) 
				{ 
					Point3d pt = segs[i].ptStart();
					if (pp.pointInProfile(pt)==_kPointOnRing)
						ptExtremes.append(pt);
					pt = segs[i].ptEnd();
					if (pp.pointInProfile(pt)==_kPointOnRing)
						ptExtremes.append(pt); 
				}//next i
			}
		}//next p	

		ptExtremes = Line(_Pt0, vecSide).orderPoints(ptExtremes, dEps);
		if (ptExtremes.length()>2)
		{ 
			ptExtremes.swap(ptExtremes.length() - 1, 1);
			ptExtremes.setLength(2);
		}

		return ptExtremes;
	}//endregion

	//region Trigger Add RubGrid // HSB-24123 Custom Grid Dimensioning
		if (bAllowRubGrid && tslRubGrid.bIsValid())
		{ 
			Map m = tslRubGrid.map();
		
			PLine plines[] = GetPLineArray(m.getMap("Grid1"));
			plines.append( GetPLineArray(m.getMap("Grid2")));

			Point3d ptGrids[0];	
			
			for (int i=0;i<plines.length();i++) 
			{ 
				Point3d pts[0];
				for (int j=0;j<showSet.length();j++)
				{ 
					int n = allSet.find(showSet[j]);
					if (n<0){ continue;}
					PlaneProfile pp = profiles[n];
					
					pts.append(GetExtremeIntersectPoints(pp, plines[i], vecSide));
				}
				pts = Line(_Pt0, vecSide).orderPoints(pts, dEps);
				if (pts.length()>0)
				{ 
					ptGrids.append(pts.first());
					ptGrids.append(pts.last());
					
				}				
				
			}
			ptsX.append(ptGrids);
			//for (int i=0;i<ptGrids.length();i++) ptGrids[i].vis(5); 
			
		}
	//endregion 

	// Get default points
		ptsX.append(ptsReq);
		ptsX = lnDir.orderPoints(ptsX, dEps);		
		for (int i=0;i<ptsX.length();i++) 
		{ 
			Point3d& pt = ptsX[i];
			if (!bIsLocal)
			{ 
				Point3d pts[] = Line(pt, -vecSide).orderPoints(ppSnap.intersectPoints(Plane(pt, vecDir), true, false));
				if (pts.length()>0)
					pt = pts.first();				
			}
			ptsDim.append(pt);		//pt.vis(4);
		}//next i
	

	// Get reference points
		ptsDim.append(getReferencePoints(vecDir, vecPerp, vecSide, ptsRef, ptsX, nRefPointMode, ppSnap));

	
	// Get custom points (not in hsb viewport mode)
		// set gripPoints
		int bSetGrip = mapCustomPoints.length() != _PtG.length() && !bIsHsbViewport;
		if (bSetGrip)_PtG.setLength(0);
		for (int i = 0; i < mapCustomPoints.length(); i++)
		{
			Map m = mapCustomPoints.getMap(i);
			Vector3d vecOrg = m.getVector3d("vecOrg");
			Point3d pt = _PtW + vecOrg;		//pt.vis(40);
			ptsDim.append(pt);
			
			if (bSetGrip)_PtG.append(pt);
			else (_PtG[i] = pt);
		}

		

		
	
	// Draw cross at drill locations
		if (bArcCenterOnXY)
		{ 
			for (int p=0;p<ptsReq.length();p++) 
			{ 
				if (bReqCrossMarks.length()>p && bReqCrossMarks[p]) 
				{ 
					Point3d pt = ptsReq[p];
					pt.setZ(_Pt0.Z());
			
					dp.draw(PLine (pt - vecX * .25 * textHeight, pt + vecX * .25 * textHeight));
					dp.draw(PLine (pt - vecY * .25 * textHeight, pt + vecY * .25 * textHeight));					
				}
	
		
		
			}//next p		
		}
	
	// Exclude dimpoints not within viewport
		if (bIsHsbViewport)
		{ 
			
			//{Display dpx(1); dpx.draw(ppViewport, _kDrawFilled,20);}
			for (int i=ptsDim.length()-1; i>=0 ; i--) 
				if (ppViewport.pointInProfile(ptsDim[i])==_kPointOutsideProfile)
					ptsDim.removeAt(i); 
	
		}
	
	// Append all dimpoints to the dim itself
		ptsDim = lnDir.orderPoints(ptsDim, dEps); //HSB-23737 ext line fixed
		for (int i=0;i<ptsDim.length();i++) 
		{ 
			//ptsDim[i].vis(6);
			dim.append(ptsDim[i],"<>",(i==0 && nRefPointMode==1?" ":"<>")); // set first to blank if refpoint given 
		}//next i
		
		

	//region Description

		PLine plBoxLine;
		
		int nDir = 1;
		Vector3d vecDirText = vecDir;
		if (vecDir.dotProduct(vecXView) < 0 ||vecDir.isCodirectionalTo(-vecYView))
			vecDirText *=-1;
		Vector3d vecPerpText = vecDirText.crossProduct(-vecZ);
		
		if (ptsDim.length()>0)
		{ 
			Point3d pt;pt.setToAverage(ptsDim);
			if (vecDirText.dotProduct(_Pt0 - pt) < 0)nDir *= -1;
			
			Point3d pt1 = ptsDim.first();
			pt1+= vecPerp * (vecPerp.dotProduct(_Pt0 - pt1)+dEps);
			Point3d pt2 = ptsDim.last();
			pt2+= vecPerp * (vecPerp.dotProduct(_Pt0 - pt2)-dEps);
						
			plBoxLine.createRectangle(LineSeg(pt1,pt2), vecDir, vecPerp);
			
		}
	
	
	//endregion 
	
	//region Publish sequence data and finaly draw dim
	
	{ 
		Map mapSeq;
		mapSeq.setVector3d("vecSide", vecSide);
		mapSeq.setPlaneProfile("ppView", ppView);
		mapSeq.setPoint3dArray("ptsDim", ptsDim);
		// TODO shoould be removed
		if (nSequence>-1)
		{ 
			mapSeq.setVector3d("vecZ", vecZ);
			mapSeq.setString("userID", viewUserId);
			mapSeq.setInt("Sequence", nSequence);			
			mapSeq.setEntityArray(ents, false, "Entity[]", "", "Entity");
			
			PlaneProfile ppT(cs);
			PLine plines[] = dim.getTextAreas(dp);
			for (int i=0;i<plines.length();i++) 
				ppT.joinRing(plines[i],_kAdd); 
			ppT.joinRing(plBoxLine,_kAdd);	
			ppT.shrink(-textHeight*.25);
			//ppT.vis(2);
		 	mapSeq.setPlaneProfile("TextArea", ppT);	
 	
			PlaneProfile ppx = ppProtect;			
			int bOk;
			
			if (ppx.intersectWith(ppT))
			{ 
				Vector3d vec = vecSide * .25 * textHeight;
				for (int i=0;i<40;i++) 
				{ 
					ppx = ppProtect;
					ptLoc += vec;
					ppT.transformBy(vec);//ppT.vis(i);
					if (!ppx.intersectWith(ppT))
					{
						bOk = true;
						break; 			 
					}
				}//next i
				//ppT.vis(5);			ptLoc.vis(3);
				dim.transformBy(vecSide * vecSide.dotProduct(ptLoc - _Pt0));
				if (!bDragPt0)_Pt0 = ptLoc;
				setExecutionLoops(2);
			}		 	
		 	
		}

		this.setSubMapX("Sequencing", mapSeq);	

	
		if (bDebug || bDragPt0)
		{ 
			dpDrag.textHeight(dViewHeight / 60);
			
			for (int i=0;i<showSet.length();i++) 
			{ 
				int n = allSet.find(showSet[i]);
				if (n>-1)
				{ 
					dpDrag.color(i % 5 + 1);
					dpDrag.draw(profiles[n],_kDrawFilled, 90);					
				}
			}
			dpDrag.color(252); // HSB-23104
			dpDrag.draw(ppAll,_kDrawFilled, (sdv.bIsValid()?50:90));				
			
		// Stereotype/ToolSet Info
			String text;
			if (sStereotype.length()>0)
			{
				text+=T("|Stereotypes|\n")+ sStereotype + "\n";// + "\n"+ sToolSet;
			}
		
		// translate and append tool names
			if (sToolSets.length()>0)
				text += T("|Tool Sets|\n");
			for (int j = 0; j < sToolSets.length(); j++)
			{
				String& entry = sToolSets[j];
				int n = sToolTypes.findNoCase(entry,-1);
				if (n>-1)
					text+=(j>0?"\n":"")+sToolTypesT[n];
			}

			dpDrag.trueColor(white);
			dpDrag.draw(text, _Pt0, _XW, _YW, nDir*1.2, 0, _kDeviceX);	
		}
	
	
	

		if (ptsDim.length()>1)
		{ 
			dp.draw(dim);
			dp.draw(text, ptLoc, vecDirText, vecPerpText, nDir, 0);	
			
		// store dim boundings for relocation actions	
			if (!bDrag)
			{ 
				PlaneProfile ppDim(CoordSys(ptLoc, vecDir, vecPerp, vecDir.crossProduct(vecPerp)));
				GetDimPlaneProfile(ppDim, dim, ptsDim, dp, .3*textHeight);
				_Map.setPlaneProfile("DimBounding", ppDim);
				if (bDebug)ppDim.vis(2);
				//{Display dpx(1); dpx.draw(ppDim, _kDrawFilled,90);}
			}			
		}

	}
	//endregion 
	
		
	}	
//END Single Dimline //endregion 

_Map.setVector3d("vecPerp", vecPerp);
if (!sdv.bIsValid())_Map.setPlaneProfile("ppAll", ppAll);
if (bIsLocal)_Map.setInt(kIsLocal, bIsLocal);
else _Map.removeAt(kIsLocal, true);

//region Viewport Setup Display
	if (bIsViewport && ptsDim.length()<2)
	{ 
		Viewport vp= _Viewport[_Viewport.length()-1];
	
		int bSideOnXP = vecX.dotProduct(vecSide)>0;
		int bSideOnYP = vecY.dotProduct(vecSide)>0;



	//region Text Location
		Point3d pt;
		if (_PtG.length()<1)
		{ 
			pt = vp.ptCenPS()+ .5*(_XW*(vp.widthPS() + 2* dTextHeight) - _YW*vp.heightPS());
			_PtG.append(pt);	//pt.vis(3);
		}
		else
		{ 
			if (_kNameLastChangedProp=="_Pt0")
				_PtG[0] = _PtW + _Map.getVector3d("vecText");
			pt = _PtG[0];	
			_Map.setVector3d("vecText", _PtG[0] - _PtW);
		}	
	//endregion 

	//region Setup Display
		int c = _ThisInst.color();
		Display dp(-1), dpText(c);
		dp.trueColor(lightblue, 50);
		dp.dimStyle(dimStyle, ps2ms.scale()*dScaleFactor);
		dp.elemZone(el, 0, 'T'); 
		dpText.dimStyle(dimStyle, 1/scale);
		dpText.elemZone(el, 0, 'T'); 
		double textHeight = dTextHeight>0?dTextHeight:dpText.textHeightForStyle("O", dimStyle);
		dpText.textHeight(textHeight);	
		
		double dX = textHeight * 2;
		double dY = textHeight;
		double dThickness = textHeight * .2;
		PLine pl(vecZ);
		PlaneProfile ppX, ppX2;
		{ 
			Vector3d vecXP = _XW * (bSideOnXP?1:-1);
			Vector3d vecYP = _YW * (bSideOnYP?1:-1);
			if (bIsDiagonalDim)
			{ 
				vecXP = _XW;// * (vecDiag.dotProduct(_XW) > 0?1:-1);
				vecYP = _YW;//vecXP.crossProduct(-_ZW);
				bSideOnYP = 1;
			}
			
			Point3d ptX = pt-(vecXP*(bSideOnXP?0:dX)+vecYP*(bSideOnYP?0:dY));
			pl.addVertex(ptX);
			pl.addVertex(ptX+vecXP*dX);
			if (bIsOrtho && !bIsDiagonalDim)
			{
				pl.addVertex(ptX+vecXP*dX+vecYP*dY);
				
				Vector3d vecA = abs(vecSide.dotProduct(_XW)) > abs(vecSide.dotProduct(_YW))? vecXP : vecYP;
				Vector3d vecB = vecA.crossProduct(-_ZW);
				Point3d pt1 = ptX + .5 * (vecXP * dX + vecYP * dY);
				pt1 += vecA * .5 * ((vecA.isParallelTo(_XW) ? dX : dY)-dThickness);
				
				ppX.createRectangle(LineSeg(pt1-.5*vecA*dThickness-vecB*dX,pt1+.5*vecA*dThickness+vecB*dX), vecA, vecB);
				
				if (bDebug)
				{ 
					vecXP.vis(ptX, 1);
					vecA.vis(ptX, 1);
					vecB.vis(pt1, 3);					
				}

			}
			else if (bIsDiagonalDim)
			{ 
				Point3d pt1 = ptX + vecXP * dX;	pt1.vis(1);
				Point3d pt2 = ptX+vecXP*.5*dX+vecYP*dY;pt2.vis(3);
				Vector3d vecA = pt2 - pt1; vecA.normalize();
				Vector3d vecB = vecA.crossProduct(-_ZW);
				pl.addVertex(pt1);
				pl.addVertex(pt2);
				
				ppX.createRectangle(LineSeg(pt1-vecA*dY-vecB*dThickness, pt2+vecB*dThickness+vecA*dY), vecA, vecB);
				
				pt1 = ptX;//pt1.vis(1);
				vecA = pt2 - pt1; vecA.normalize();
				vecB = vecA.crossProduct(-_ZW);
				ppX2.createRectangle(LineSeg(pt1-vecA*dY-vecB*.5*dThickness, pt2+vecB*.5*dThickness+vecA*dY), vecA, vecB);
			}
			else
			{ 
				Point3d pt1 = ptX + vecXP * dX + vecYP * .5 * dY;
				Point3d pt2 = ptX+vecXP*.5*dX+vecYP*dY;
				Vector3d vecA = pt2 - pt1; vecA.normalize();
				Vector3d vecB = vecA.crossProduct(-_ZW);
				pl.addVertex(pt1);
				pl.addVertex(pt2);
				
				ppX.createRectangle(LineSeg(pt1-vecA*dY-vecB*dThickness, pt2+vecB*dThickness+vecA*dY), vecA, vecB);
			}			
			pl.addVertex(ptX+vecYP*dY);
			pl.close();
			//pl.vis(5);	
		}
		PlaneProfile pp(cs);
		pp.joinRing(pl, _kAdd);
		ppX2.intersectWith(pp);
		PlaneProfile pp2 = pp;
		pp2.shrink(dThickness);
		pp.subtractProfile(pp2);
		ppX.intersectWith(pp);
		
		if(bIsDiagonalDim)
			pp.subtractProfile(ppX2);
		else
			pp.subtractProfile(ppX);	
		dp.draw(pp, _kDrawFilled);
	
		if (c>0)
			dp.color(c);			
		else
			dp.trueColor(darkyellow,0);
		
		if(bIsDiagonalDim)
		{		
			dp.draw(ppX2, _kDrawFilled);		
		}
		else
			dp.draw(ppX, _kDrawFilled);
		
		
		
		
	//endregion 

	//region Setup Text
		String text = scriptName() + "("+showSet.length()+")";//, mapAdditionals);
		dpText.draw(text,pt+_XW*(dX+textHeight), _XW,_YW,1,1);			
	//endregion			
	
	
	
}
	
		
//endregion 

//region Part #5 Triggers #TR
{	
	// declare for TSL cloning
	TslInst tslDialog;			Map mapTsl;
	GenBeam gbsTsl[] = { };		Entity entsTsl[] = { };			Point3d ptsTsl[] = { _Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };

//region Trigger AddPoints
	String sTriggerAddPoints = T("|Add Points|");
	if (!bIsBlockSpaceMode && !bIsHsbViewport)addRecalcTrigger(_kContextRoot, sTriggerAddPoints );
	if (_bOnRecalc && _kExecuteKey ==sTriggerAddPoints)
	{
		Map mapArgs;
		mapArgs.setPoint3dArray("pts", ptsX);
		mapArgs.setPoint3d("ptRef", _Pt0);
		mapArgs.setVector3d("vecDir", vecDir);
		mapArgs.setVector3d("vecZ", vecZ);
		mapArgs.setString("dimStyle", dimStyle);
		mapArgs.setDouble("textHeight", dTextHeight);
		mapArgs.setDouble("Scale", ps2ms.scale()*dScaleFactor);
		mapArgs.setInt("chainMode", nChainMode);
		mapArgs.setInt("deltaMode", nDeltaMode);
		mapArgs.setInt(kDeltaOnTop, deltaOnTop);
		//mapArgs.setString("text", text);			
					
		String prompt = T("|Pick points|");
		PrPoint ssP(prompt);	
		int nGoJig = -1;
		while (nGoJig != _kNone)// && nGoJig != _kOk
		{
			nGoJig = ssP.goJig(kJigAddPoints, mapArgs);
		
			if (nGoJig == _kOk)//Jig: point picked
			{
				Point3d pt = ssP.value();
				Line(pt, vecZ).hasIntersection(pnView, pt);
				Vector3d vecOrg = pt - _PtW;

				mapCustomPoints = _Map.getMap("CustomPoint[]");
				int bAdd = true;					
				for (int i=0;i<mapCustomPoints.length();i++) 
				{ 
					Map m= mapCustomPoints.getMap(i);					
					Vector3d vecA = m.getVector3d("vecOrg");
					Point3d ptA = _PtW + vecA;
					bAdd = Vector3d(ptA - pt).length() > dEps;
					if (!bAdd)break; // do not add existing point
					ptsX.append(pt);
					mapArgs.setPoint3dArray("pts", ptsX);
				}//next i
				
				if (bAdd)
				{ 
					Map m;
					m.setVector3d("vecOrg", vecOrg);
					mapCustomPoints.appendMap("Point", m);
					_Map.setMap("CustomPoint[]", mapCustomPoints);
				}				 		
			} 			
		// Jig: cancel
			else if (nGoJig == _kCancel)
			{
				break;
			}
		}		

		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger RemovePoints
	String sTriggerRemovePoints = T("|Remove Points|");
	if (!bIsBlockSpaceMode && _PtG.length() > 0 && !bIsHsbViewport)	addRecalcTrigger(_kContextRoot, sTriggerRemovePoints );
	if (_bOnRecalc && _kExecuteKey ==sTriggerRemovePoints)
	{
		double dMaxJigDiam = U(1000);
		for (int i=0;i<_PtG.length()-1;i++) 
		{ 
			Point3d ptA = _PtG[i];
			ptA+=vecZ * vecZ.dotProduct(_Pt0 - ptA);
			for (int j=1;j<_PtG.length();j++) 
			{ 
				if (i == j)continue;
				Point3d ptB = _PtG[j];
				ptB+=vecZ * vecZ.dotProduct(_Pt0 - ptB);
				
				double d = Vector3d(ptA - ptB).length();
				if (d>0 && d<dMaxJigDiam)
					dMaxJigDiam = d;
			}//next i
		}//next i
		dMaxJigDiam *= .5;

		Map mapArgs;
		mapArgs.setPoint3dArray("pts", _PtG);
		mapArgs.setPoint3d("ptRef", _Pt0);
		mapArgs.setVector3d("vecDir", vecDir);
		mapArgs.setVector3d("vecZ", vecZ);
		mapArgs.setString("dimStyle", dimStyle);
		mapArgs.setDouble("maxDiam", dMaxJigDiam);	
		
		Point3d ptsRemovals[0]; // a list of points which will be removed 
		
		String prompt = T("|Pick points|");
		PrPoint ssP(prompt);	
		int nGoJig = -1;
		
		Map mapBuffer =  _Map.getMap("CustomPoint[]");
		while (nGoJig != _kNone)
		{
			nGoJig = ssP.goJig("RemovePoints", mapArgs);
		
			if (nGoJig == _kOk)//Jig: point picked
			{
				Point3d pt = ssP.value();
				Line(pt, vecZ).hasIntersection(pnView, pt);
				Vector3d vecOrg = pt - _PtW;

				double diam = dViewHeight / 40;
				diam = diam > dMaxJigDiam ? dMaxJigDiam : diam;
				

				int index = -1;
				for (int i=0;i<_PtG.length();i++) 
				{ 
					PLine circle;
					circle.createCircle(_PtG[i], vecZ,diam) ; 
					circle.convertToLineApprox(dEps);					

					PlaneProfile pp(circle);		
					if (pp.pointInProfile(pt) != _kPointOutsideProfile)
					{ 	
						ptsRemovals.append(_PtG[i]);
						mapArgs.setPoint3dArray("ptsRemovals", ptsRemovals);
						index=i;
						break;
					}
				}//next i

				mapCustomPoints = _Map.getMap("CustomPoint[]");
				Map mapTemp;
				for (int i=0;i<mapCustomPoints.length();i++) 
				{ 
					Map m= mapCustomPoints.getMap(i);					
					if (i!=index) mapTemp.appendMap("Point", m);
				}//next i	
				mapCustomPoints = mapTemp;
				_Map.setMap("CustomPoint[]", mapCustomPoints);
				 		
			} 			
		// Jig: cancel
			else if (nGoJig == _kCancel)
			{
				_Map.setMap("CustomPoint[]", mapBuffer);	
				break;
			}
		}		

		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger AddEntities
	if (!bHasPage && !bIsBlockSpaceMode && !bIsHsbViewport && !bHasSection)
	{ 
		String sTriggerAddEntities = T("|Add Entities|");
		addRecalcTrigger(_kContextRoot, sTriggerAddEntities );
		if (_bOnRecalc && _kExecuteKey==sTriggerAddEntities)
		{
			int bInModel;
			if (bIsViewport && !bIsHsbViewport)
				bInModel=Viewport().switchToModelSpace();	

		// prompt for entities
			Entity _ents[0];
			PrEntity ssE(T("|Select entities|"), Entity());
			//ssE.allowNested(true);
			if (ssE.go())
				_ents.append(ssE.set());
			
			if (bIsValidPDdim)
				_ents = pdDim.filterAcceptedEntities(_ents);
			
			for (int i=0;i<_ents.length();i++) 
			{ 
				int n = _Entity.find(_ents[i]);
				if (n<0 && !_ents[i].bIsKindOf(MultiPage()))
					_Entity.append(_ents[i]);
			}//next i
	
			if (bInModel)
				bInModel=Viewport().switchToPaperSpace();
	
			setExecutionLoops(2);
			return;
		}			
	}//endregion	

//region Trigger RemoveEntities
	if (!bHasPage && showSet.length()>1 && !bIsBlockSpaceMode && !bIsHsbViewport && !bHasSection)
	{ 
		String sTriggerRemoveEntities = T("|Remove Entities|");
		addRecalcTrigger(_kContextRoot, sTriggerRemoveEntities );
		if (_bOnRecalc && _kExecuteKey==sTriggerRemoveEntities)
		{
		// prompt for entities
			Entity removals[0];
			PrEntity ssE(T("|Select entities|"), Entity());
			//ssE.allowNested(true);
			if (ssE.go())
				removals.append(ssE.set());
			
			for (int i=0;i<removals.length();i++) 
			{ 
				int n1 = showSet.find(removals[i]);
				int n2 = _Entity.find(removals[i]);
				if (n1>-1 && n2 >-1)
				{
					showSet.removeAt(n1);
					_Entity.removeAt(n2);
				}
				if (showSet.length() < 2)break; // do not remove until empty
			}//next i
	
			setExecutionLoops(2);
			return;
		}			
	}//endregion

//region Trigger SetAlignment
	String sTriggerSetAlignment = T("|Set Alignment|");
	addRecalcTrigger(_kContextRoot, sTriggerSetAlignment);
	if (_bOnRecalc && _kExecuteKey==sTriggerSetAlignment)
	{
		_Map.removeAt("vecDiag", true);
		Point3d pts[0];
		pts.append(_PtG);
		
		Point3d pt1 = getPoint(T("|Pick first point|"));
		pt1 += vecZ * vecZ.dotProduct(_Pt0 - pt1);			
		
		Map mapArgs;
		mapArgs.setPoint3dArray("pts", pts);
		mapArgs.setPlaneProfile("Shadow", ppVisible);
		mapArgs.setPoint3d("ptRef", _Pt0);
		mapArgs.setPoint3d("pt1", pt1);
		//mapArgs.setVector3d("vecDir", vecDir);
		mapArgs.setVector3d("vecZ", vecZ);
		mapArgs.setString("dimStyle", dimStyle);
		mapArgs.setDouble("textHeight", dTextHeight);
		mapArgs.setDouble("Scale", ps2ms.scale()*dScaleFactor);		
		mapArgs.setInt("chainMode", nChainMode);
		mapArgs.setInt("deltaMode", nDeltaMode);
		mapArgs.setInt(kDeltaOnTop, deltaOnTop);
		mapArgs.setString("text", text);
		
		String prompt = T("|Select alignment|") + T("|[swapSide]|");
		PrPoint ssP(prompt, pt1);	
		int nGoJig = -1;
		while (nGoJig != _kNone && nGoJig != _kOk)
		{
			nGoJig = ssP.goJig("SetAlignment", mapArgs);
		//Jig: point picked
			if (nGoJig == _kOk)
			{
				Point3d pt2 = ssP.value();
				pt2 += vecZ * vecZ.dotProduct(_Pt0 - pt2);	
				vecDir = pt2 - pt1; vecDir.normalize();
				_Map.setVector3d("vecDir", vecDir);
				_Map.removeAt("SegmentMode", true);
				mapArgs.setVector3d("vecDir", vecDir);
			}
	        else if (nGoJig == _kKeyWord)
	        { 
	            if (ssP.keywordIndex() == 0)
	            	mapArgs.setInt(kDeltaOnTop, !mapArgs.getInt(kDeltaOnTop));
   
	        } 			
		// Jig: cancel
			else if (nGoJig == _kCancel)
			{
				break;
			}
		}

	// select location
		segVisible = ppVisible.extentInDir(vecDir);
		pts.append(segVisible.ptStart());
		pts.append(segVisible.ptEnd());				
		mapArgs.setPoint3dArray("pts", pts);
		mapArgs.removeAt("ptRef", true);
		prompt = T("|Select location|");
		ssP=PrPoint (prompt, _Pt0);	
		nGoJig = -1;
		while (nGoJig != _kNone && nGoJig != _kOk)
		{
			nGoJig = ssP.goJig("SetAlignment", mapArgs);
			if (nGoJig == _kOk)
				_Pt0 = ssP.value();
		// Jig: cancel
			else if (nGoJig == _kCancel)
			{
				break;
			}
		}

		_Grip.setLength(0);
		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger SelectSegment
	String sTriggerSelectSegment = T("|Select Segment|");
	addRecalcTrigger(_kContextRoot, sTriggerSelectSegment );
	if (_bOnRecalc && _kExecuteKey==sTriggerSelectSegment)
	{
		_Map.removeAt("vecDiag", true);
		Map mapArgs;
		mapArgs.setVector3d("vecDir", vecDir);
		
		mapArgs.setVector3d("vecX", vecX);
		mapArgs.setVector3d("vecY", vecY);
		mapArgs.setVector3d("vecZ", vecZ);
		mapArgs.setString("dimStyle", dimStyle);
		mapArgs.setInt("chainMode", nChainMode);
		mapArgs.setInt("deltaMode", nDeltaMode);
		mapArgs.setInt(kDeltaOnTop, deltaOnTop);

	// segments
		Map mapSegments;
		PLine plSegs[0];
		PLine rings[] = ppVisible.allRings();
		for (int r = 0; r < rings.length(); r++)
		{
			PLine pl = rings[r];
			PlaneProfile ppRing(pl);
			Vector3d vecZP = pl.coordSys().vecZ();
			Point3d pts[] = pl.vertexPoints(false);
			
			// loop vertices
			for (int p = 0; p < pts.length() - 1; p++)
			{
				Point3d pt1 = pts[p];
				Point3d pt2 = pts[p + 1];	//pt1.vis(p); pt2.vis(p + 1);
				PLine plSeg(pt1, pt2);
				Point3d ptm = (pt1 + pt2) * .5;
				int bIsArc = ! pl.isOn(ptm);
				
				if (bIsArc)// the arc
				{
					plSeg = PLine(vecZP);
					plSeg.addVertex(pt1);
					plSeg.addVertex(pt2, pl.getPointAtDist(pl.getDistAtPoint(pt1) + dEps));
				}
				if (plSeg.length()>dEps)
				{
					plSegs.append(plSeg);
					mapSegments.appendPLine("pl", plSeg);
				}
			}			
		}
		mapArgs.setMap("Segment[]", mapSegments);


	// select segment
		Point3d ptPick;
		int bSelected;
		String prompt = T("|Select segment|");
		PrPoint ssP(prompt);	
		ssP.setSnapMode(TRUE, 0); // turn off all snaps
		int nGoJig = -1;
		while (nGoJig != _kNone && nGoJig != _kOk)
		{
			nGoJig = ssP.goJig(kJigSelectSegment, mapArgs);
			if (nGoJig == _kOk)
			{
				ptPick = ssP.value();
				bSelected = true;
			}
			else if (nGoJig == _kCancel)
				break;
		}	
		ssP.setSnapMode(false, 0); // turn off all snaps
	
	// Selected
		if (!bSelected)
		{ 
			setExecutionLoops(2);
			return;
		}
		else
		{ 	 
			PLine plSeg;
			double dDist = U(10e6);
			for (int i=0;i<plSegs.length();i++) 
			{ 
				double d  = (plSegs[i].closestPointTo(ptPick)-ptPick).length(); 
				if (d<dDist)
				{ 
					dDist = d;
					plSeg=plSegs[i];
				}
			}//next i}//next i
	
		
			Point3d pt1 = plSeg.ptStart();
			Point3d pt2 = plSeg.ptEnd();
			Point3d ptm = (pt1 + pt2) * .5;
			int bArc = !plSeg.isOn(ptm);
			Vector3d vecXS = pt2 - pt1;
			if (vecXS.length()>dEps)
			{ 
				vecXS.normalize();
				Vector3d vecYS = vecXS.crossProduct(-vecZ);
				if(ppVisible.pointInProfile(plSeg.ptMid()+vecYS*dEps)==_kPointInProfile)
					vecYS *= -1;
				
				mapArgs.setVector3d("vecDir",vecXS);
				mapArgs.setPoint3dArray("pts", plSeg.vertexPoints(true));			
			}
			
			prompt = T("|Select location|");
			ssP=PrPoint (prompt);	
			ssP.setSnapMode(TRUE, 0); // turn off all snaps
			int nGoJig = -1;
			while (nGoJig != _kNone && nGoJig != _kOk)
			{
				nGoJig = ssP.goJig(kDimlineJig, mapArgs);
				if (nGoJig == _kOk)
				{
					_Map.setVector3d("vecDir", vecXS);
					_Map.setInt("SegmentMode", true); // flag to dimension segments exclusvly
					_Pt0 = ssP.value();
				}
				else if (nGoJig == _kCancel)
					break;
			}	
			ssP.setSnapMode(false, 0); // turn off all snaps			
		}
	
		_Grip.setLength(0);
		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger SetDiagonal // #vd
	if (ptGripVertices.length()>3)
		addRecalcTrigger(_kContextRoot, sTriggerSetDiagonal );
	if ((_bOnRecalc && _kExecuteKey==sTriggerSetDiagonal) || bDebug)
	{
		if (sShapeMode == tEnvelopeShape)
		{
			reportMessage(TN("|The point mode for diagonal dimensions has been adjusted to| ") + tBasicShape);
			sShapeMode.set(tBasicShape);
		}

		Map mapArgs,mapSegments;

	// collect all potential diagonal connctions
		for (int i=0;i<plDiags.length();i++) 
		{
			mapSegments.setPLine("pl"+i, plDiags[i]);
		}
		mapArgs.setMap("Segment[]",mapSegments);
		mapArgs.setVector3d("vecZ", vecZ);

	// at least one diagonal required
		if(plDiags.length()<1)
		{ 
			_Map.removeAt("vecDiag", true);
			setExecutionLoops(2);
			return;
		}
		int nSelected;
		

	//region Show Jig
		PrPoint ssP(T("|Select Diagonal|")); // second argument will set _PtBase in map	   
	    int nGoJig = -1;
	    while (nGoJig != _kOk && nGoJig != _kNone)
	    {
	        nGoJig = ssP.goJig(kJigSelectSegment, mapArgs); 

	        if (nGoJig == _kOk)
	        {
	            Point3d ptPick = ssP.value(); //retrieve the selected point
	            Line(ptPick, vecZ).hasIntersection(Plane(_Pt0, vecZ));

				double dDist = U(10e6);
				for (int i=0;i<plDiags.length();i++) 
				{ 
					double d  = (plDiags[i].closestPointTo(ptPick)-ptPick).length(); 
					if (d<dDist)
					{ 
						dDist = d;
						nSelected = i;
					}
				}//next i            
	        }
//	        else if (nGoJig == _kKeyWord)
//	        { 
//	            if (ssP.keywordIndex() == 0)
//	                mapArgs.setInt("isLeft", TRUE);
//	            else 
//	                mapArgs.setInt("isLeft", FALSE);
//	        }
	        else if (nGoJig == _kCancel)
	        { 
	            return; 
	        }
	    }			
	//End Show Jig//endregion 
	
	
		if (nSelected>-1)
		{ 
			PLine pl = plDiags[nSelected];
			Point3d pts[] = pl.vertexPoints(true);
			if (pts.length()>1)
			{ 
				Point3d pt1 = pts.first();
				Point3d pt2 = pts.last();
				
				Vector3d vecDiag = pt2 - pt1;
				vecDiag.normalize();
				_Map.setVector3d("vecDiag", vecDiag);
				_Pt0 = pt1 - vecDiag * textHeight;
				_Map.setDouble("baseLineOffset", 0);
				
			}	
		}		
		else
			_Map.removeAt("vecDiag", true);

		_Grip.setLength(0);
		if (!bDebug)
		{ 
			setExecutionLoops(2);
			return;			
		}

	}//endregion	

//region Trigger Rotate90
	String sTriggerRotateAlignment = T("|Rotate 90°|");
	addRecalcTrigger(_kContextRoot, sTriggerRotateAlignment);
	if (_bOnRecalc && _kExecuteKey==sTriggerRotateAlignment)
	{
		_Map.setVector3d("vecDir", vecPerp);
		_Grip.setLength(0);
		setExecutionLoops(2);
		return;
	}//endregion

//region Trigger DeltaOnTop
	String sTriggerDeltaOnTop = T("|Swap Delta/Chain|");
	if (nDeltaMode!=_kDimClassic)
		addRecalcTrigger(_kContextRoot, sTriggerDeltaOnTop );
	if (_bOnRecalc && _kExecuteKey==sTriggerDeltaOnTop)
	{
		_Map.setInt(kDeltaOnTop,!bDeltaOnTop);		
		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger Copy
	String sTriggerCopy = T("|Copy Dimline|");
	if (!bIsViewport)addRecalcTrigger(_kContextRoot, sTriggerCopy );
	if (_bOnRecalc && _kExecuteKey==sTriggerCopy)
	{
		Vector3d vecDirNew = vecDir;
		Vector3d vecPerpNew = vecPerp;
	
	//region Show Jig
		PrPoint ssP(T("|Pick point [Rotate 90°]|"), _Pt0);
	    Map mapArgs;
		mapArgs.setPoint3dArray("pts", ptsX);
		mapArgs.setPlaneProfile("Shadow", ppVisible);
		mapArgs.setPoint3d("ptRef", _Pt0);
		//mapArgs.setPoint3d("pt1", pt1);
		mapArgs.setVector3d("vecDir", vecDir);
		mapArgs.setVector3d("vecZ", vecZ);
		mapArgs.setString("dimStyle", dimStyle);
		mapArgs.setDouble("textHeight", dTextHeight);
		mapArgs.setDouble("Scale", ps2ms.scale()*dScaleFactor);		
		mapArgs.setInt("chainMode", nChainMode);
		mapArgs.setInt("deltaMode", nDeltaMode);
		mapArgs.setInt(kDeltaOnTop, deltaOnTop);
		mapArgs.setString("text", text);

	    int nGoJig = -1;
	    while (nGoJig != _kOk && nGoJig != _kNone)
	    {
	        nGoJig = ssP.goJig(kJigCopy, mapArgs); 

	        if (nGoJig == _kOk)
	        {
	            Point3d ptPick = ssP.value(); //retrieve the selected point
	            
            // create TSL
            	TslInst tslNew;
            	Point3d ptsTsl[] = {ptPick};
         
            	int nProps[]={nSequence};
            	double dProps[]={dTextHeight,dScaleFactor};
            	String sProps[]={sPainter,sShapeMode,sDisplayMode,sRefPainter,sRefPointMode,sDimStyle,sFormat,sStereotype,sDimPointMode,sToolSet};
            	Map mapTsl = _Map;	
            	mapTsl.setVector3d("vecDir", vecDirNew);
            	mapTsl.removeAt("vecOrg", true);
            	tslNew.dbCreate(scriptName() , vecDirNew ,vecPerpNew,_GenBeam, _Entity, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			       
	        }
	        else if (nGoJig == _kKeyWord)
	        { 
	            if (ssP.keywordIndex() == 0)
	            { 
	            	vecDirNew = vecPerpNew;
	            	vecPerpNew = vecDirNew.crossProduct(-vecZ);
	            	mapArgs.setVector3d("vecDir", vecDirNew);
	            }
	        }
	        else if (nGoJig == _kCancel)
	        { 
	            break;
	        }
	    }			
	//End Show Jig//endregion 

		setExecutionLoops(2);
		return;
	}//endregion	

	
//region Trigger DefineToolSets
	String sTriggerDefineToolSets = T("|Define Tool Sets|");
	addRecalcTrigger(_kContextRoot, sTriggerDefineToolSets );
	if (_bOnRecalc && _kExecuteKey==sTriggerDefineToolSets)
	{
		GenBeam gbs[]= getNestedGenBeams(showSet);
		int numToolSubTypes[0];
		String toolSubTypes[] = getToolSubTypes(gbs, numToolSubTypes);
		
		Map mapIn,mapItems;
		mapIn.setString("Title", T("|Tool Set Definition|"));
		mapIn.setString("Prompt", T("|Select tools which can contribute to the dimensioning|") + TN("|The number in brackets indictaes the appearance of the tool of the current object|"));
		mapIn.setInt("EnableMultipleSelection", true);
		mapIn.setInt("ShowSelectAll", true);

	// Append selected entries first
		String sEntries[0], sSelectedEntries[0];
		sSelectedEntries= sToolSets;
		for (int i = 0; i < sSelectedEntries.length(); i++)
		{
			String& entry = sSelectedEntries[i];
			String& entryT = sToolTypesT[i];
			int n = sToolTypes.findNoCase(entry,-1);
			if (n>-1 && sEntries.findNoCase(entryT,-1)<0)
				sEntries.append(entryT);
		}

	// Append remaining entries	
		for (int i = 0; i < sToolTypes.length(); i++)
		{ 
			String& entryT = sToolTypesT[i];
			if (sEntries.findNoCase(entryT,-1)<0)
				sEntries.append(entryT);
		}

	// append to list
		for (int i = 0; i < sEntries.length(); i++)
		{ 
			String entryT = sEntries[i];
			int n = sToolTypesT.findNoCase(entryT,-1);
			String entry = n>-1?sToolTypes[n]:"";
			
			int x = toolSubTypes.findNoCase(entry ,- 1);
			if (x>-1)
				entryT += " (" + numToolSubTypes[x]+")";
		
			Map m;
			m.setString("Text", entryT);
			//m.setString("ToolTip", toolTips[i]);
			m.setInt("IsSelected", sToolSets.find(entry)>-1?1:0);
			mapItems.appendMap("Item", m);	
		}				
		mapIn.setMap("Items[]", mapItems);

//reportNotice("\nin" + mapIn + " \nitems: " +mapItems );
		Map mapOut = callDotNetFunction2(sDialogLibrary, sClass, listSelectorMethod, mapIn);// optionsMethod,listSelectorMethod				
		int bCancel = mapOut.getInt("WasCancelled");
//reportNotice("\nout("+mapOut.length()+")" + mapOut + " \n" +mapOut.getMap("Selection[]") );		
		if (mapOut.length()>0)
		//if (!bCancel)
		{ 
			//reportNotice("\nout" + mapOut + " \n" +mapOut.getMap("Selection[]") );
			Map mapSelections = mapOut.getMap("Selection[]");
			String out;
			sToolSets.setLength(0);
			for (int i=0;i<mapSelections.length();i++) 
			{ 
				String entryT = mapSelections.getString(i);
				int x = entryT.find(" (",0, false);
				if (x>-1)
					entryT = entryT.left(x);

				int n = sToolTypesT.findNoCase(entryT,-1);
				String entry = n>-1?sToolTypes[n]:"";
				if (n>-1 && sToolTypes.findNoCase(entry,-1)>-1)
				{ 
					sToolSets.append(entry);
					out += (out.length()>0?";":"") + entry;
				}
				 
			}//next i
			sToolSet.set(out);		
		}

		setExecutionLoops(2);
		return;
	}//endregion	



//region Trigger SetStereotypes
	String sTriggerSetStereotypes = T("|Define Parent Tool Filter|");
	addRecalcTrigger(_kContextRoot, sTriggerSetStereotypes );
	if (_bOnRecalc && _kExecuteKey==sTriggerSetStereotypes)
	{
		String sExcludeScriptStarts[] = {"sd_", "hsbView", "dim","_hsbRe", "AssemblyShop", "BatchShop","Stack", "hsbTslSettings", "Metaldata", "multipage","AssemblyDef" , 
		"hsbCenterOfGravity", "hsbEntityTag", "hsbBOM", "hsbScheduleTable", "hsbLayout", "HSB_D-", "HSB_G-", "hsbAcis", 
		"mapIO","hsb_MultiW", "Layout"}; // TODO to be extended

		Map mapIn,mapItems;
		mapIn.setString("Title", T("|Parent Tool Selection|"));
		mapIn.setString("Prompt", T("|Select entries of which you want to collect tool dimensioning|") + 
			TN("|After you have chosen a minimum of one entry, only dimpoints corresponding\nto the selected tools will be appended to the dimline.|")+
			TN("|This feature can function in conjunction with the option to filter specific types of tools.|"));
		mapIn.setInt("EnableMultipleSelection", true);
		//if (nSelected>-1)mapIn.setInt("IsSelected", nSelected);
		
	// Get all selected entries
		String sEntries[0], sSelectedEntries[0];
		sSelectedEntries= sStereotypes;
		sEntries = sSelectedEntries;

	// Append all tsl scripts available in model	
		String scriptNames[] = TslScript().getAllEntryNames().sorted();
		for (int i = 0; i < scriptNames.length(); i++)
		{ 
			String& entry = scriptNames[i];
			if (sEntries.findNoCase(entry,-1)>-1){ continue;}
			int bSkip;
			for (int j = 0; j < sExcludeScriptStarts.length(); j++)
			{
				if (entry.find(sExcludeScriptStarts[j],0,false)==0)
				{ 
					bSkip = true;
					break;
				}
			}
			if (bSkip)continue;
			sEntries.append(entry);
		}
	
	
//	//region Append all eTools attached to the showSet
//		for (int i = 0; i < showSet.length(); i++)
//		{ 
//			GenBeam gb = (GenBeam)showSet[i];
//			if (gb.bIsValid())
//			{ 
//				Entity tents[] = gb.eToolsConnected();
//				for (int j=0;j<tents.length();j++) 
//				{ 
//					Entity e = tents[j]; 
//					String entry = e.typeDxfName();
//					if (sEntries.findNoCase(entry,-1)>-1){ continue;}
//					int bSkip;
//					for (int j = 0; j < sExcludeScriptStarts.length(); j++)
//					{
//						if (entry.find(sExcludeScriptStarts[j],0,false)==0)
//						{ 
//							bSkip = true;
//							break;
//						}
//					}
//					if (bSkip)continue;
//					sEntries.append(entry);					
//					
//				}//next j
//				
//			}
//		}//endregion 	
	
	
		
	// Append a predefined list of eTools which are supported
		String sETools[] ={ "hsb_EBeamcut", "hsb_EFree_Drill", "hsb_ESurfaceDrill", "hsb_ESlot", "hsb_EZapf", "_kACSimpleAngled"};
		String sEToolTips[] ={ T("|A generic tool which describes a quader tool|"), T("|A generic drill tool|"), T("|A generic drill tool assigned to one of the main faces|"), 
			T("|A generic slot tool|"), T("|A generic tenon tool|"),T("|A simple cut|")	};
		for (int i=0;i<sETools.length();i++) 
		{ 
			String& entry = sETools[i]; 
			if (sEntries.findNoCase(entry,-1)<0)
				sEntries.append(entry);
		}//next i

	// Add ToolTip data
		String toolTips[sEntries.length()];
		for (int i = 0; i < sEntries.length(); i++)
		{ 
			String& entry = sEntries[i];
			int n = sETools.findNoCase(entry ,- 1);
			if (n>-1)
				toolTips[i] = sEToolTips[n];
			else
				toolTips[i] = T("|Collects points of all tooling operations which this tool defines.|") + T("|Note, some tools do not contribute tool data.|");
		}
		




	// append to list
		for (int i = 0; i < sEntries.length(); i++)
		{ 
			String& entry = sEntries[i];
			Map m;
			m.setString("Text", entry);
			m.setString("ToolTip", toolTips[i]);
			m.setInt("IsSelected", sSelectedEntries.find(entry)>-1?1:0);
			mapItems.appendMap("Item", m);	
		}				
		mapIn.setMap("Items[]", mapItems);


		Map mapOut = callDotNetFunction2(sDialogLibrary, sClass, listSelectorMethod, mapIn);// optionsMethod,listSelectorMethod				
		//if (mapOut.length()>0)
		{ 
			Map mapSelections = mapOut.getMap("Selection[]");
			String out;
			sSelectedEntries.setLength(0);
			for (int i=0;i<mapSelections.length();i++) 
			{ 
				String entry = mapSelections.getString(i); 
				if (entry.length()>0 && sSelectedEntries.findNoCase(entry)<0)
				{ 
					sSelectedEntries.append(entry);
					out += (out.length()>0?";":"") + entry;
				}
				 
			}//next i
			sStereotype.set(out);
//			nSelected = mapOut.getInt("SelectedIndex");
//			
//			if (nSelected>-1)
//			{ 
//				sReport.set(reports[nSelected]);
//				sSubReport.set(sections[nSelected]);
//			}
//	
//			Map mapReport = getReportMap(sReport).getMap("ReportDefinition");
//			_Map.setMap("ReportDefinition", mapReport);			
		}	
	
	
	
		setExecutionLoops(2);
		return;
	}//endregion	


//region Trigger SetReferenceLocationMode HSB-19788 #SRL
	String sTriggerSetReferenceLocationMode = T("|Set Viewport Reference Mode|");
	if (bIsHsbViewport)addRecalcTrigger(_kContextRoot, sTriggerSetReferenceLocationMode );
	if (_bOnRecalc && _kExecuteKey==sTriggerSetReferenceLocationMode)
	{
		String sRefLocModes[] = { tRefLocFixed, tRefLocDim, tRefLocExtreme};
		String sRefLocToolTips[] = { T("|Dimline is fixed to current location|"), 
			T("|The Dimline will be adjusted to a location near the dimension object.|"),
			T("|The dimline will be adjusted to the boundaries of the dimension objects.|")};

		String stText;
		if (findFile(sDialogLibrary)!="")
		{ 

			Map mapItems;
			for (int i=0;i<sRefLocModes.length();i++) 
			{
				Map m;
				m.setString("Text", sRefLocModes[i]);
				m.setString("ToolTip", sRefLocToolTips[i]);
				mapItems.appendMap("Item", m);
				//mapItems.appendString("st"+i, sRefLocModes[i]); 
				//mapItems.appendInt(sRefLocModes[i],0);

			}

			Map mapIn;
			mapIn.setString("Title", T("|Reference Location|"));
			mapIn.setString("Prompt", T("|Select the preferred reference location.|"));
			mapIn.setString("Alignment", "Right");
			mapIn.setMap("Items[]", mapItems);
			if (nRefLocMode>-1 && nRefLocMode<3)
				mapIn.setInt("SelectedIndex", nRefLocMode);//__when selected index is present, it is used over initial selection set by int in items list

			Map mapOut = callDotNetFunction2(sDialogLibrary, sClass, optionsMethod, mapIn);	
		
			nRefLocMode = mapOut.getInt("SelectedIndex");
			String value = mapOut.getString("Selection");
		
			if (nRefLocMode>-1)
				_Map.setInt(kRefLocMode, nRefLocMode);
		
		}


		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger RegenerateShopdrawing	
	if (bHasPage)
	{ 
	
		String sTriggerRegenerateShopdrawing = T("|Regenerate Shopdrawing|");
		addRecalcTrigger(_kContextRoot, sTriggerRegenerateShopdrawing );
		if (_bOnRecalc && _kExecuteKey==sTriggerRegenerateShopdrawing)
		{
			page.regenerate();		
			setExecutionLoops(2);
			return;
		}	
		
	}//endregion

//region Function CollectDimlinesOfPage
	// returns
	TslInst[] CollectDimlinesOfPage(MultiPage page)
	{ 
		TslInst tslDims[0];
		Entity ents[]= Group().collectEntities(true, TslInst(), _kModelSpace);
		for (int i=0;i<ents.length();i++) 
		{ 
			TslInst t= (TslInst)ents[i];
			if (t.bIsValid() && t.scriptName().makeLower() == (bDebug?"dimline":scriptName().makeLower()) && t.entity().find(page)>-1)
			{				
				tslDims.append(t);
			}
		}//next i		
		return tslDims;
	}//endregion
	//region Collect dimlines attached to this multipage
	
	//endregion 


//region Function AlignDimlines
	// aligns all dimlines of a multipage
	void AlignDimlines(MultiPage page, double baseOffset)
	{ 
		int bSetBaseLine = baseOffset > 0;
		TslInst tslDims[] = CollectDimlinesOfPage(page);
		//reportMessage("\n" + tslDims.length() + " dimlines found");
	
		MultiPageView views[] = page.views();
	
	//region Collect all groups of dimlines in a map
		Map maps;
		for (int i=0;i<tslDims.length();i++) 
		{ 
			TslInst& t = tslDims[i];
			Map m = t.map();
			int viewIndex = m.getInt("ViewIndex");
			Vector3d vecSide = m.getVector3d("vecPerp");
			if (m.getInt(kIsLocal)) // ignore local dimensions
			{ 
				continue;
			}
			
			PlaneProfile pp = m.getPlaneProfile("ppAll");
			if (vecSide.dotProduct(pp.ptMid()-t.ptOrg())<0)
				vecSide *= -1;
					
			String key = viewIndex + "_" + vecSide;
			if (maps.hasMap(key))
			{ 
				Map m = maps.getMap(key);
				Entity ents[] =m.getEntityArray("ent[]", " ", "ent");
				ents.append(t);
				m.setEntityArray(ents, true, "ent[]", " ", "ent");
				maps.setMap(key, m);
			}
			else
			{ 
				m.setVector3d("vecSide", vecSide);
				Entity ents[] = { t};
				m.setEntityArray(ents, true, "ent[]", " ", "ent");	
				maps.appendMap(key, m);
			}			
			//reportMessage("\ni" + i + " view index " +viewIndex + " " + vecSide);
		}//next i			
	//endregion 

		
		for (int i=0;i<maps.length();i++) 
		{ 
			Map m = maps.getMap(i);
			Entity ents[] =m.getEntityArray("ent[]", " ", "ent");
			
		// skip first if no baseLineOffset specified	
			if (ents.length()<(bSetBaseLine?1:2)){ continue;}
			
			TslInst tsls[] = FilterTslsByName(ents,"DimLine");// (bDebug?"DimLine".scriptName());
			
			Vector3d vecSide = m.getVector3d("vecSide");
			
		// order bySide
			for (int ii=0;ii<tsls.length();ii++) 
				for (int j=0;j<tsls.length()-1-ii;j++) 
				{	
					double d1 = vecSide.dotProduct(_Pt0 - tsls[j].ptOrg());
					double d2 =vecSide.dotProduct( _Pt0 - tsls[j+1].ptOrg());
					
					if (d1>d2)
						tsls.swap(j, j + 1);
				}
						
			PlaneProfile pps[0];
			for (int i=0;i<tsls.length();i++) 
				pps.append(tsls[i].map().getPlaneProfile("DimBounding"));

		// Align first dimline by baseline offset	
			if (bSetBaseLine && tsls.length()>0)
			{ 
				TslInst& t1 = tsls[0];
				PlaneProfile pp1 = t1.map().getPlaneProfile("ppAll");
				PlaneProfile& pp2 = pps[0];
				
				LineSeg seg =pp1.extentInDir(vecSide);	
				double d1 = abs(vecSide.dotProduct(seg.ptEnd()-seg.ptStart()));			
				
				Point3d pt1 = pp1.ptMid()-vecSide*.5*d1;
				Point3d pt2 = pp2.ptMid()+vecSide*.5*pp2.dY();
				
				double dMove = vecSide.dotProduct(pt1 - pt2);
				
				if (abs(dMove)>dEps)
				{ 
					dMove -= baseOffset;
					Map m = t1==_ThisInst?_Map:t1.map();
					if (m.hasVector3d("vecOrg"))
					{ 
						Vector3d vecOrg = m.getVector3d("vecOrg");
						vecOrg += vecSide * dMove;
						m.setVector3d("vecOrg", vecOrg);
						if (t1==_ThisInst)
							_Map = m;
						else
							t1.setMap(m);
					}
					t1.transformBy(vecSide * dMove);
					pp2.transformBy(vecSide * dMove);				
				}				
			}

		// Align any following dimline to the closest dist
			for (int i=0;i<tsls.length()-1;i++) 
			{ 
				
				TslInst& t2 = tsls[i+1];
				
				PlaneProfile pp1 = pps[i];
				PlaneProfile& pp2 = pps[i+1];				
				
				Point3d pt1 = pp1.ptMid()-vecSide*.5*pp1.dY();
				Point3d pt2 = pp2.ptMid()+vecSide*.5*pp2.dY();				

				double dMove = vecSide.dotProduct(pt1 - pt2);
				
				if (abs(dMove)>dEps)
				{ 
					Map m = t2==_ThisInst?_Map:t2.map();
					if (m.hasVector3d("vecOrg"))
					{ 
						Vector3d vecOrg = m.getVector3d("vecOrg");
						vecOrg += vecSide * dMove;
						m.setVector3d("vecOrg", vecOrg);
						if (t2==_ThisInst)
							_Map = m;
						else
							t2.setMap(m);
					}
					t2.transformBy(vecSide * dMove);
					pp2.transformBy(vecSide * dMove);				
				}	
			}
			//reportNotice("\ni" + i + " key " +maps.keyAt(i) + "  reports " + ents.length());
		}
		
		
	
		//return;
	}//endregion	
	
	
//region TriggerReallignDimlines
	String sTriggerAlignDimlines = T("|Align Dimlines|");
	if (page.bIsValid())addRecalcTrigger(_kContextRoot, sTriggerAlignDimlines );
	if (_bOnRecalc && _kExecuteKey==sTriggerAlignDimlines)
	{
		AlignDimlines(page, U(120));		
		setExecutionLoops(2);
		return;
	}//endregion	

//region TriggerReallignDimlines
	String sTriggerAlignDimlines2 = T("|Align Dimlines2|");
	//if (page.bIsValid())addRecalcTrigger(_kContextRoot, sTriggerAlignDimlines2 );
	if (_bOnRecalc && _kExecuteKey==sTriggerAlignDimlines2)
	{
		Entity ents[] ={page};
		
	// create TSL
		TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
		GenBeam gbsTsl[] = {};		Entity entsTsl[] = {page};		Point3d ptsTsl[] = {_Pt0};
		int nProps[]={};			double dProps[]={};				String sProps[]={};
		Map mapTsl;	
		mapTsl.setInt("isDummy",true);			
		tslNew.dbCreate("MultipageController" , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			
	
		int bOk = tslNew.showDialog(sLastInserted);
		if (bOk)
		{ 

			Map mapIO;	
			mapIO.setMap("properties", tslNew.mapWithPropValues());
			mapIO.setEntityArray(ents, true,"ent[]", "", "ent");
			TslInst().callMapIO("MultipageController", mapIO);	

		}
		tslNew.dbErase();

		//setExecutionLoops(2);
		return;
	}//endregion	



//region Trigger PurgeDimlines #PD
	String sTriggerPurgeDimlines = T("|Purge Dimlines|");
	if (page.bIsValid())addRecalcTrigger(_kContextRoot, sTriggerPurgeDimlines );
	
	int bPurgeDimlines = _Map.getInt("RemotePurge") || (_bOnRecalc && _kExecuteKey == sTriggerPurgeDimlines);
	if (bPurgeDimlines)
	{
		TslInst tslDims[] = CollectDimlinesOfPage(page);
	
	//region Collect variations of vecSide
		Vector3d vecSides[0];
		for (int i=0;i<tslDims.length();i++) 
		{ 
			TslInst& t= tslDims[i];
			Map m = t.subMapX("Sequencing");	
			Vector3d vecSide = m.getVector3d("vecSide");

			int n=-1;
			for (int j=0;j<vecSides.length();j++) 
			{ 
				if (vecSide.isParallelTo(vecSides[j]))
				{
					n = j;
					break;; 
				}	 
			}//next j
			if (n<0)
			{
				vecSides.append(vecSide);
				n = vecSides.length() - 1;
			}
		}//next i		
	//endregion 	
		
	//region Collect duplicates of dimlines per side
		if (bDebug)reportNotice("\n" + _ThisInst.handle() +" runs a test against duplicates ("+ tslDims.length() +") directions ("+vecSides.length()+")");

		TslInst duplicates[0];
		for (int v=0;v<vecSides.length();v++) 
		{ 
			Vector3d vecRead = vecSides[v];
			if (vecRead.isParallelTo(_XW))vecRead = -_XW;
			else if (vecRead.isParallelTo(_YW))vecRead = _YW;
			else if (vecRead.dotProduct(_YW))vecRead *=-1;

		//region Collect dimlines per read direction
			TslInst tsls[0];
			String tags[0];
			for (int i = 0; i < tslDims.length(); i++)
			{
				TslInst& t = tslDims[i];
				Map m = t.subMapX("Sequencing");
				Vector3d vecSide = m.getVector3d("vecSide");
				Point3d ptMid =  m.getPlaneProfile("ppView").ptMid();
				//PlaneProfile pp = 
				if (vecSide.isParallelTo(vecRead))
				{				
					double d = vecRead.dotProduct(tslDims[i].ptOrg() - ptMid);
					m.setString("isPos", d > dEps ? "A" : "B"); // prioritize positive values
					m.setDouble("midDist", abs(d));
					
					String tag = _ThisInst.formatObject("@(userID)_@(isPos)_@(midDist:RL0:PL10;0)", m);
					tags.append(tag);
					tsls.append(t);
				}
			}
			
			if (bDebug)reportNotice("\ntesting " + tslDims.length() + " against side " + vecRead);
			
			
		// order by vecRead
			for (int i=0;i<tsls.length();i++) 
				for (int j=0;j<tsls.length()-1;j++) 
				{
					double d1 = vecRead.dotProduct(tsls[j].ptOrg() - _PtW);
					double d2 = vecRead.dotProduct(tsls[j+1].ptOrg() - _PtW);
					
					if (tags[j]>tags[j+1])
					{
						tsls.swap(j, j + 1);
						tags.swap(j, j + 1);
					}
				}
			

			if (bDebug)
			{ 
				for (int i=0;i<tsls.length();i++) 
					vecRead.vis(tsls[i].ptOrg(),i+1); 
				reportNotice("\n	" + tsls.length() +" parallel to " + vecRead);				
			}				
		//endregion 	
			
		//region Find duplicates
			int cnt, nMax = tsls.length() - 1;
			while(tsls.length()>1 && cnt<nMax)
			{ 
				Vector3d vecXRead = vecRead.crossProduct(-vecZ);
				TslInst tsl0 = tsls.first();
				if (bDebug)reportNotice("\n	searching duplicates of " + tsl0.handle());
				
				Line ln(tsl0.ptOrg(), vecXRead);
				Point3d ptsRef[] = tsls.first().subMapX("Sequencing").getPoint3dArray("ptsDim");
				ptsRef = ln.projectPoints(ln.orderPoints(ptsRef, dEps));

				int numRef = ptsRef.length();

				for (int i=tsls.length()-1; i>0 ; i--) 
				{ 
					TslInst& t = tsls[i];
					Point3d ptsD[] = t.subMapX("Sequencing").getPoint3dArray("ptsDim");
					ptsD = ln.projectPoints(ln.orderPoints(ptsD, dEps));

					int numD = ptsD.length();
					if (numD>0 && numD==numRef)
					{ 
						int bOk;
						for (int p=0;p<ptsRef.length();p++) 
						{ 
							
							if ((ptsRef[p]-ptsD[p]).length()>dEps)
							{
								bOk = true;
								break;
							}							
						}
						if (!bOk)
						{ 
							if (bDebug)reportNotice("\n		 duplicate " + t.handle());
							
						// remove from list of all tsls of this page	
							int n = tslDims.find(t);							
							if (n>-1)
								tslDims.removeAt(n);
							
							PLine pl (ptsD.first(), ptsD.last());
							pl.transformBy(vecRead * vecRead.dotProduct(t.ptOrg() - ptsD.first()));
							//pl.vis(1);
							duplicates.append(t); 
							vecRead.vis(pl.ptStart() ,1);
							tsls.removeAt(i);	
						}
					}	
				}
				
				//reportNotice("\n	duplicates " + duplicates.length());


			// remove from list of all tsls of this page	
				int n = tslDims.find(tsl0);							
				if (n>-1)
					tslDims.removeAt(n);

				n = tsls.find(tsl0);							
				if (n>-1)
					tsls.removeAt(n);
					
				
				if (bDebug && ptsRef.length()>0)
				{ 
					PLine(ptsRef.first(), ptsRef.last()).vis(3);
					vecRead.vis(ptsRef.first(),3);					
				}

		
				cnt++;
			}//next x				
		//endregion 

		}//next v
			
	//endregion 	

	//region Remove Duplicates
		if(duplicates.length()>0 && !_Map.getInt("RemotePurge")) // don't show message on remote purges
			reportMessage("\n" + page.handle() + ": "+ T("|Purging redundant dimlines| (") + duplicates.length()+ ")");

		for (int i=duplicates.length()-1; i>=0 ; i--) 
		{ 
			TslInst& t = duplicates[i];
			if (t==_ThisInst)// wait killing myself
			{ 
				continue;
			}
			if (t.bIsValid())
				t.dbErase();
		}//next i
		if (duplicates.find(_ThisInst)>-1)
		{ 
			eraseInstance();
			return;
		}
	
	//endregion 

		_Map.removeAt("RemotePurge", true);
		setExecutionLoops(2);
		return;
	}//endregion	

//region Dialog Trigger
{ 
	// create TSL
	TslInst tslDialog;			Map mapTsl;						
	GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };
	
	String sFolders[]=getFoldersInFolder(sPath); 

//region Trigger GlobalSettings
	addRecalcTrigger(_kContext, sTriggerGlobalSetting);
	if (_bOnRecalc && _kExecuteKey==sTriggerGlobalSetting)	
	{ 
		mapTsl.setInt("DialogMode",2);
		
		String groupAssignment = sGroupings.length()>nGroupAssignment?sGroupings[nGroupAssignment]:tDefaultEntry;
		sProps.append(groupAssignment);

		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{ 
				groupAssignment = tslDialog.propString(0);
				nGroupAssignment = sGroupings.findNoCase(groupAssignment, 0);
				
				Map m = mapSetting.getMap(kGlobalSettings);
				m.setInt(kGroupAssignment, nGroupAssignment);								
				mapSetting.setMap(kGlobalSettings, m);
				
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);				
			}
			tslDialog.dbErase();
		}
		
	// trigger other instances	to update their layer assignment
		if (nGroupAssignment == 1)
		{
			assignToLayer("0");	
			Entity ents[] = Group().collectEntities(true, TslInst(), _kModelSpace);
			
			TslInst tsls[0];
			String names[] ={ scriptName()};
			int n = getTslsByName(tsls, names);
			for (int i = 0; i < n; i++)
			{
				TslInst tsl = tsls[i];
				Map m = tsl.map();
				m.setInt("setLayer", true);
				tsl.setMap(m);
				tsl.recalc();
			}//next i
		}
		
		setExecutionLoops(2);
		return;	
	}
	//endregion	

//region Trigger DisplaySettings
	String sTriggerVSSetting = T("|Drill Dimension Visibilty Settings|");
	addRecalcTrigger(_kContext, sTriggerVSSetting);
	if (_bOnRecalc && _kExecuteKey==sTriggerVSSetting)	
	{ 
		String sVSBeam = nVSBeam>-1?sVSDrills[nVSBeam]:"";
		String sVSSheet = nVSSheet>-1?sVSDrills[nVSSheet]:"";
		String sVSPanel = nVSPanel>-1?sVSDrills[nVSPanel]:"";
		String sVSMetalPart = nVSCollectionEtity>-1?sVSDrills[nVSCollectionEtity]:"";

		mapTsl.setInt("DialogMode",1);
		sProps.append(sVSBeam);
		sProps.append(sVSSheet);
		sProps.append(sVSPanel);
		sProps.append(sVSMetalPart);
			
		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{ 
				nVSBeam = sVSDrills.findNoCase(tslDialog.propString(0),-1);
				nVSSheet = sVSDrills.findNoCase(tslDialog.propString(1),-1);
				nVSPanel = sVSDrills.findNoCase(tslDialog.propString(2),-1);
				nVSCollectionEtity = sVSDrills.findNoCase(tslDialog.propString(3),-1);
				
				Map map = mapSetting.getMap("ViewStrategyDrill");
				
				if (nVSBeam>-1)
				{
					Map m; m.setInt("ViewStrategy", nVSBeam);
					map.setMap("Beam", m);
				}
				if (nVSSheet >- 1)
				{
					Map m; m.setInt("ViewStrategy", nVSSheet);
					map.setMap("Sheet", m);
				}
				if (nVSPanel>-1)
				{
					Map m; m.setInt("ViewStrategy", nVSPanel);
					map.setMap("Panel", m);
				}
				if (nVSCollectionEtity>-1)
				{
					Map m; m.setInt("ViewStrategy", nVSCollectionEtity);
					map.setMap("CollectionEtity", m);
				}					

				mapSetting.setMap("ViewStrategyDrill", map);
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);				
			}
			tslDialog.dbErase();
		}
		setExecutionLoops(2);
		return;	
	}
	//endregion	

//region Trigger AddRubGrid // HSB-24123 Custom Grid Dimensioning
	if (bAllowRubGrid)
	{ 
		String sTriggerAddRemoveRubGrid = tslRubGrid.bIsValid()?T("|Remove RUB-Grid|"):T("|Add RUB-Grid|");
		addRecalcTrigger(_kContext, sTriggerAddRemoveRubGrid );
		if (_bOnRecalc && _kExecuteKey==sTriggerAddRemoveRubGrid)
		{
		
		// Remove
			if (tslRubGrid.bIsValid())
			{ 
				_Map.removeAt("rubGrid", true);
			}
		// Add
			else
			{ 
				tslRubGrid = getTslInst(T("|Select instance|"));	
				if (tslRubGrid.bIsValid() && Equals(tslRubGrid.scriptName(), "RUB-Grid"))
				{ 
					_Map.setEntity("rubGrid", tslRubGrid);		
				}				
			}
			setExecutionLoops(2);
			return;
		}		
		
	}//endregion



//region Trigger Import/Export Settings
	if (findFile(sFullPath).length()>0)
	{ 
		String sTriggerImportSettings = T("|Import Settings|");
		addRecalcTrigger(_kContext, sTriggerImportSettings );
		if (_bOnRecalc && _kExecuteKey==sTriggerImportSettings)
		{
			mapSetting.readFromXmlFile(sFullPath);	
			if (mapSetting.length()>0)
			{ 
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);	
				reportMessage(TN("|Settings successfully imported from| ") + sFullPath);	
			}
			setExecutionLoops(2);
			return;
		}			
	}

// Trigger ExportSettings
	if (mapSetting.length() > 0)
	{
		String sTriggerExportSettings = T("|Export Settings|");
		addRecalcTrigger(_kContext, sTriggerExportSettings );
		if (_bOnRecalc && _kExecuteKey == sTriggerExportSettings)
		{
			int bWrite;
			if (findFile(sFullPath).length()>0)
			{ 
				String sInput = getString(T("|Are you sure to overwrite existing settings?|") + " [" + T("|No|") +"/"+T("|Yes|")+"]").left(1);
				bWrite = sInput.makeUpper() == T("|Yes|").makeUpper().left(1);
			}
			else bWrite = true;
				
			if (bWrite && mapSetting.length() > 0)
			{ 
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);
				
			// make sure the path exists	//HSB-10750
				int bPathFound= sFolders.find(sFolder)>-1?true:makeFolder(sPath+"\\"+sFolder);	
				
			// write file	
				mapSetting.writeToXmlFile(sFullPath);
				
			// report rsult of writing	
				if (findFile(sFullPath).length()>0)		reportMessage(TN("|Settings successfully exported to| ") + sFullPath);
				else									reportMessage(TN("|Failed to write to| ") + sFullPath);		
			}
			
			setExecutionLoops(2);
			return;
		}
	}
	//endregion 

//region Trigger PainterManagement
	String sTriggerPainterManagement = T("|Painter Management|");
	addRecalcTrigger(_kContext, sTriggerPainterManagement );
	if (_bOnRecalc && _kExecuteKey==sTriggerPainterManagement)
	{

		Map mapIn,mapItems;
		mapIn.setString("Title", T("|Painter Management|"));
		mapIn.setString("Prompt", T("|Select an option to specify automatic painter creation and usage.|"));
		mapIn.setString("Alignment", "Left");
		
		String tPMDefault = T("|Only Painter Definitions inside folder| (")+sPainterCollection+")", tPMInstanceOff = T("|All Painter Definitions for this dimline|"),
			tPMAllOff = T("|All Painter Definitions for any dimline|");
		String sPMOptions[] = { tPMDefault,tPMInstanceOff,tPMAllOff };
		String sPMTips[0];
		sPMTips.append(T("|A folder with certain painter definitions will be created.| (") +sPainterCollection + T(") |Any painter outside of the folder will be ignored.|"));
		sPMTips.append(T("|A folder with certain painter definitions will be created.| (") +sPainterCollection + T(") |This dimline will allow any painter definition.|"));
		sPMTips.append(T("|A folder with certain painter definitions will not be created.|") + " " + T("|Any painter definition will be accepted.|"));

		for (int i = 0; i < sPMOptions.length(); i++)
		{ 		
			Map m;
			m.setString("Text", sPMOptions[i]);
			m.setString("ToolTip", sPMTips[i]);
			mapItems.appendMap("Item", m);	
		}				
		mapIn.setMap("Items[]", mapItems);
		
		if (nPainterManagementMode>-1)
			mapIn.setInt("SelectedIndex", nPainterManagementMode);//__when selected index is present, it is used over initial selection set by int in items list

		Map mapOut = callDotNetFunction2(sDialogLibrary, sClass, optionsMethod, mapIn);// optionsMethod,listSelectorMethod				
		String value = mapOut.getString("Selection");
		
		nPainterManagementMode = sPMOptions.findNoCase(value ,- 1);		
		if (nPainterManagementMode<0)
			nPainterManagementMode = 0;		
		if (nPainterManagementMode==1)
			_Map.setInt(kPainterManagementMode,nPainterManagementMode );	
		else
		{ 
			_Map.removeAt(kPainterManagementMode, true);
			mapSetting.setInt(kPainterManagementMode,nPainterManagementMode );			
			if (mo.bIsValid())mo.setMap(mapSetting);
			else mo.dbCreate(mapSetting);			
		}
	
		
		setExecutionLoops(2);
		return;
	}//endregion	

}
//End Dialog Trigger//endregion 	
	
//region Trigger Import/Export Settings
	if (findFile(sFullPath).length()>0)
	{ 
		String sTriggerImportSettings = T("|Import Settings|");
		addRecalcTrigger(_kContext, sTriggerImportSettings );
		if (_bOnRecalc && _kExecuteKey==sTriggerImportSettings)
		{
			mapSetting.readFromXmlFile(sFullPath);	
			if (mapSetting.length()>0)
			{ 
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);	
				reportMessage(TN("|Settings successfully imported from| ") + sFullPath);	
			}
			setExecutionLoops(2);
			return;
		}			
	}

// Trigger ExportSettings
	if (mapSetting.length() > 0)
	{
		String sTriggerExportSettings = T("|Export Settings|");
		addRecalcTrigger(_kContext, sTriggerExportSettings );
		if (_bOnRecalc && _kExecuteKey == sTriggerExportSettings)
		{
			int bWrite;
			if (findFile(sFullPath).length()>0)
			{ 
				String sInput = getString(T("|Are you sure to overwrite existing settings?|") + " [" + T("|No|") +"/"+T("|Yes|")+"]").left(1);
				bWrite = sInput.makeUpper() == T("|Yes|").makeUpper().left(1);
			}
			else bWrite = true;
				
			if (bWrite && mapSetting.length() > 0)
			{ 
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);
				
			// make sure the path exists	//HSB-10750
				String sFolders[]=getFoldersInFolder(sPath); 
				int bPathFound= sFolders.find(sFolder)>-1?true:makeFolder(sPath+"\\"+sFolder);	
				
			// write file	
				mapSetting.writeToXmlFile(sFullPath);
				
			// report rsult of writing	
				if (findFile(sFullPath).length()>0)		reportMessage(TN("|Settings successfully exported to| ") + sFullPath);
				else									reportMessage(TN("|Failed to write to| ") + sFullPath);		
			}
			
			setExecutionLoops(2);
			return;
		}
	}
	//endregion 

	
}//endregion


//if (!bDrag)reportNotice("\n" + scriptName() + " " + _ThisInst.handle() + " grips ("+_Grip.length()+") ended " + (getTickCount()-tick)+"ms");//(getTickCount()-tick));// TODO XXXX








































#End
#BeginThumbnail

#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="2862" />
        <int nm="BreakPoint" vl="1596" />
        <int nm="BreakPoint" vl="1640" />
        <int nm="BreakPoint" vl="1777" />
        <int nm="BreakPoint" vl="5121" />
        <int nm="BreakPoint" vl="5490" />
        <int nm="BreakPoint" vl="5111" />
        <int nm="BreakPoint" vl="4965" />
        <int nm="BreakPoint" vl="6021" />
        <int nm="BreakPoint" vl="3145" />
        <int nm="BreakPoint" vl="4469" />
        <int nm="BreakPoint" vl="4088" />
        <int nm="BreakPoint" vl="3622" />
        <int nm="BreakPoint" vl="6511" />
        <int nm="BreakPoint" vl="2862" />
        <int nm="BreakPoint" vl="1596" />
        <int nm="BreakPoint" vl="1640" />
        <int nm="BreakPoint" vl="1777" />
        <int nm="BreakPoint" vl="5121" />
        <int nm="BreakPoint" vl="5490" />
        <int nm="BreakPoint" vl="5111" />
        <int nm="BreakPoint" vl="4965" />
        <int nm="BreakPoint" vl="6021" />
        <int nm="BreakPoint" vl="3145" />
        <int nm="BreakPoint" vl="4469" />
        <int nm="BreakPoint" vl="4088" />
        <int nm="BreakPoint" vl="3622" />
        <int nm="BreakPoint" vl="6511" />
        <int nm="BreakPoint" vl="6403" />
        <int nm="BreakPoint" vl="6423" />
        <int nm="BreakPoint" vl="5303" />
        <int nm="BreakPoint" vl="7846" />
        <int nm="BreakPoint" vl="7828" />
        <int nm="BreakPoint" vl="6074" />
        <int nm="BreakPoint" vl="5949" />
        <int nm="BreakPoint" vl="4848" />
        <int nm="BreakPoint" vl="4433" />
        <int nm="BreakPoint" vl="5964" />
        <int nm="BreakPoint" vl="5998" />
        <int nm="BreakPoint" vl="5678" />
        <int nm="BreakPoint" vl="6466" />
        <int nm="BreakPoint" vl="4391" />
        <int nm="BreakPoint" vl="4396" />
        <int nm="BreakPoint" vl="4187" />
        <int nm="BreakPoint" vl="6530" />
        <int nm="BreakPoint" vl="6750" />
        <int nm="BreakPoint" vl="6567" />
        <int nm="BreakPoint" vl="4322" />
        <int nm="BreakPoint" vl="4345" />
        <int nm="BreakPoint" vl="4783" />
        <int nm="BreakPoint" vl="7532" />
        <int nm="BreakPoint" vl="398" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21155 beveled drills,improved, mortise with explicit radius gets crossmarks, slots enhanced" />
      <int nm="MajorVersion" vl="7" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="1/18/2024 3:31:08 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20292 all kinds of collection entities are supported (TrussEntity, MetalPartCollectionEntiy and CollectionEntity)" />
      <int nm="MajorVersion" vl="7" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="12/22/2023 12:35:54 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20877 dimpoint collecrtion and filtering of nested genbeams of metalparts enhanced" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="12/8/2023 2:05:42 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20687, 20853, 20855, 20861 bugfix" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="12/7/2023 3:03:46 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20687, 20853, 20855, 20861 dimline now supports the definition of individual tools based on the parent tool entity asnd/or of a custom set of tools specified by the subtype" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="12/7/2023 2:02:49 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20197 gable dimensions accepting tolerances of sheetings, setup graphics only visible if no dimensions drawn" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="12/1/2023 9:41:30 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20564 bugfix püurge dimlines" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="11/30/2023 10:03:11 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20564 performance improved especially when linked to a paperspace viewport" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="11/29/2023 3:03:01 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20550 remote purging of redundant dimlines supported" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="11/13/2023 5:49:00 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19354 individual grip based dimensions of openings supported for paperspace dimensions" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="10/27/2023 3:59:58 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20005 shape mode and reference point modes further restriced when using diagonal or gable dimension" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="9/14/2023 9:39:27 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20045 Requires hsbDesign 26 or higher, accepts multiple blockreferences, metalpart entities, resolves marker lines if selected via stereotype, resolves stereotype requests of blockreferences and metalpart entities" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="9/13/2023 5:13:29 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20043 new command to alter options of painter filtering" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="9/12/2023 2:12:55 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20038 model support genbeams enhanced, shape modes renamed, classic dim added" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="9/12/2023 12:10:58 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20005 shape mode restriced to basic shape when using diagonal or gable dimension modes. Diagonal mode enhanced" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="9/11/2023 12:41:12 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20005 element viewports support multiple aligned dimlines (i.e. on gable walls)" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="9/8/2023 3:27:14 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19355 new property 'Dimension Point Mode' enables filtering of corresponding dimension points, basic automatic creation of element painter definitions added" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="9/7/2023 3:15:55 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19354 opening support added" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="9/7/2023 10:16:13 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19788 reference point will refer to outmost point" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="8/9/2023 5:34:57 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19788 new context command in hsbcad viewport mode to set the reference location" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="8/9/2023 2:33:32 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19358 accepting element painter definitions as reference in conjunction with other dim painters" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="6/26/2023 3:15:19 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18832 dimstyles which are associated to non linear dimensions are not shown anymore" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="5/12/2023 4:25:04 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18920 new property 'ScaleFactor' supports scaling to other units" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="5/8/2023 1:00:11 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18893 bugfix on insert diagonal dimension" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="5/8/2023 10:14:45 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18893 new option for diagonal control dimensions" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="5/5/2023 9:11:26 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18008 new command to purge redundant dimlines associated to a multipage" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="2/28/2023 4:00:58 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB- 18146 purging improved if multipage invalidates" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="2/27/2023 4:06:11 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16730 segmented contours will try to reconstruct into arc segments" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="2/16/2023 8:48:14 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17432 supports dimension requests which based on element tsls" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="2/13/2023 10:58:29 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17752 compatable with hsbDesign 25" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="2/9/2023 8:56:51 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17752 new option to copy a dimline, tool options enhanced" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="2/8/2023 12:31:16 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17752 new options to dimension drills" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="2/7/2023 6:07:20 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17586 bugfix non request tsls" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="1/18/2023 4:08:05 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17586 new property to specify individual requests, new context commands to add or remove entries" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="1/18/2023 2:47:47 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16519 consumes linear dimrequests if defined within linked tsls of genbeams" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="1/17/2023 4:04:57 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15142 improving shadow contour of collection entities" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="1/17/2023 1:16:31 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17320 tsl instances of sections improved" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="1/10/2023 9:20:38 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17297 supports dimline alignment for auto scaled viewports" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="12/12/2022 1:42:40 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17175 assigning of element zone set by defining entity" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="11/25/2022 12:40:17 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17184 supports sections" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="11/23/2022 12:07:46 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16291 uniform preview improved" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="10/21/2022 4:15:41 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16291 uniform preview added" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="10/20/2022 4:05:17 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15772 ACA viewport dependencies improved" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="10/17/2022 5:09:36 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15850 bugfix collection entity reference points" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="10/6/2022 4:57:05 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16507 supports element viewports, new mode 'envelope shape' uses outer contour based specified filter" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="9/15/2022 3:19:22 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16430 multiple genbeams of element improved" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="9/5/2022 4:58:59 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14692 relative location to multipage stored" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="8/10/2022 9:11:05 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14692 selected element excluded from dimension when used as assignment in pick point mode" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="3/15/2022 9:07:56 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14692 group assignment extended when in point mode, user may select any entity as group reference without this being added to the dimension" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="3/14/2022 11:23:51 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14692 element assignment fixed when in point mode" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="3/11/2022 3:33:04 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14692 provides point mode on insert and exports to share and make" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="3/10/2022 5:09:06 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12398 accepting any painter definition if collection 'Dimension' is not found" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="12/16/2021 12:44:38 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="CMP-32 metalpart collection support added (beta)" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="8/6/2021 12:13:24 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-7777 first implementation of some tools (Cut, Drill, Beamcut) added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="8/5/2021 5:09:21 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-7777 initial version" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="8/4/2021 4:32:19 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>



































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
        <int nm="BreakPoint" vl="4071" />
        <int nm="BreakPoint" vl="2668" />
        <int nm="BreakPoint" vl="2712" />
        <int nm="BreakPoint" vl="4357" />
        <int nm="BreakPoint" vl="4071" />
        <int nm="BreakPoint" vl="2668" />
        <int nm="BreakPoint" vl="2712" />
        <int nm="BreakPoint" vl="4357" />
        <int nm="BreakPoint" vl="8205" />
        <int nm="BreakPoint" vl="8225" />
        <int nm="BreakPoint" vl="9756" />
        <int nm="BreakPoint" vl="8642" />
        <int nm="BreakPoint" vl="10165" />
        <int nm="BreakPoint" vl="1301" />
        <int nm="BreakPoint" vl="1631" />
        <int nm="BreakPoint" vl="8033" />
        <int nm="BreakPoint" vl="7642" />
        <int nm="BreakPoint" vl="4160" />
        <int nm="BreakPoint" vl="4071" />
        <int nm="BreakPoint" vl="2668" />
        <int nm="BreakPoint" vl="2712" />
        <int nm="BreakPoint" vl="4357" />
        <int nm="BreakPoint" vl="8221" />
        <int nm="BreakPoint" vl="4071" />
        <int nm="BreakPoint" vl="2668" />
        <int nm="BreakPoint" vl="2712" />
        <int nm="BreakPoint" vl="4357" />
        <int nm="BreakPoint" vl="8221" />
        <int nm="BreakPoint" vl="8113" />
        <int nm="BreakPoint" vl="8133" />
        <int nm="BreakPoint" vl="9664" />
        <int nm="BreakPoint" vl="8176" />
        <int nm="BreakPoint" vl="10073" />
        <int nm="BreakPoint" vl="1301" />
        <int nm="BreakPoint" vl="1631" />
        <int nm="BreakPoint" vl="6923" />
        <int nm="BreakPoint" vl="8242" />
        <int nm="BreakPoint" vl="4160" />
        <int nm="BreakPoint" vl="4071" />
        <int nm="BreakPoint" vl="2668" />
        <int nm="BreakPoint" vl="2712" />
        <int nm="BreakPoint" vl="4357" />
        <int nm="BreakPoint" vl="8221" />
        <int nm="BreakPoint" vl="4071" />
        <int nm="BreakPoint" vl="2668" />
        <int nm="BreakPoint" vl="2712" />
        <int nm="BreakPoint" vl="4357" />
        <int nm="BreakPoint" vl="8221" />
        <int nm="BreakPoint" vl="8113" />
        <int nm="BreakPoint" vl="8133" />
        <int nm="BreakPoint" vl="9664" />
        <int nm="BreakPoint" vl="8176" />
        <int nm="BreakPoint" vl="10073" />
        <int nm="BreakPoint" vl="1301" />
        <int nm="BreakPoint" vl="1631" />
        <int nm="BreakPoint" vl="6923" />
        <int nm="BreakPoint" vl="8242" />
        <int nm="BreakPoint" vl="4160" />
        <int nm="BreakPoint" vl="7621" />
        <int nm="BreakPoint" vl="7534" />
        <int nm="BreakPoint" vl="9431" />
        <int nm="BreakPoint" vl="7611" />
        <int nm="BreakPoint" vl="4140" />
        <int nm="BreakPoint" vl="9885" />
        <int nm="BreakPoint" vl="8665" />
        <int nm="BreakPoint" vl="8110" />
        <int nm="BreakPoint" vl="8402" />
        <int nm="BreakPoint" vl="8088" />
        <int nm="BreakPoint" vl="6692" />
        <int nm="BreakPoint" vl="7575" />
        <int nm="BreakPoint" vl="7561" />
        <int nm="BreakPoint" vl="7681" />
        <int nm="BreakPoint" vl="7091" />
        <int nm="BreakPoint" vl="6414" />
        <int nm="BreakPoint" vl="5143" />
        <int nm="BreakPoint" vl="6150" />
        <int nm="BreakPoint" vl="6274" />
        <int nm="BreakPoint" vl="7483" />
        <int nm="BreakPoint" vl="8101" />
        <int nm="BreakPoint" vl="8717" />
        <int nm="BreakPoint" vl="8575" />
        <int nm="BreakPoint" vl="8356" />
        <int nm="BreakPoint" vl="8355" />
        <int nm="BreakPoint" vl="7052" />
        <int nm="BreakPoint" vl="7084" />
        <int nm="BreakPoint" vl="7024" />
        <int nm="BreakPoint" vl="6307" />
        <int nm="BreakPoint" vl="4048" />
        <int nm="BreakPoint" vl="6249" />
        <int nm="BreakPoint" vl="7161" />
        <int nm="BreakPoint" vl="6204" />
        <int nm="BreakPoint" vl="7149" />
        <int nm="BreakPoint" vl="5218" />
        <int nm="BreakPoint" vl="6256" />
        <int nm="BreakPoint" vl="5868" />
        <int nm="BreakPoint" vl="5874" />
        <int nm="BreakPoint" vl="5879" />
        <int nm="BreakPoint" vl="5829" />
        <int nm="BreakPoint" vl="5972" />
        <int nm="BreakPoint" vl="4685" />
        <int nm="BreakPoint" vl="8690" />
        <int nm="BreakPoint" vl="8680" />
        <int nm="BreakPoint" vl="3537" />
        <int nm="BreakPoint" vl="5687" />
        <int nm="BreakPoint" vl="5690" />
        <int nm="BreakPoint" vl="1963" />
        <int nm="BreakPoint" vl="1985" />
        <int nm="BreakPoint" vl="1957" />
        <int nm="BreakPoint" vl="1949" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24316 bugfix accepting default stereotype wildcard '*'" />
      <int nm="MajorVersion" vl="10" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="10/28/2025 1:37:50 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24186 blockspace detection improved" />
      <int nm="MajorVersion" vl="10" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="6/18/2025 9:03:38 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24114 performance improved working with metalpart painters, preview improved, new options to match visuals on insert" />
      <int nm="MajorVersion" vl="10" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="6/10/2025 9:28:41 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24123 page transformation bugfix" />
      <int nm="MajorVersion" vl="10" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="6/6/2025 4:41:40 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24080 viewport: dimpoints outside viewport are ignored" />
      <int nm="MajorVersion" vl="10" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="6/5/2025 1:48:33 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24123 custom grid can be dimensioned within paperspace, requires custom setting" />
      <int nm="MajorVersion" vl="10" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="6/3/2025 3:06:03 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23985 bugfix basepoint on insert and door window combination" />
      <int nm="MajorVersion" vl="10" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="6/3/2025 12:04:45 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23736 point selection during insert supports ortho mode" />
      <int nm="MajorVersion" vl="9" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="4/27/2025 8:55:18 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23737 bugfix extension line not showing" />
      <int nm="MajorVersion" vl="9" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="4/7/2025 3:53:35 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23539 catching hidden element geometry" />
      <int nm="MajorVersion" vl="9" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="2/19/2025 2:42:16 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23539 opening and element dimensioning in modelspace enhanced" />
      <int nm="MajorVersion" vl="9" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="2/19/2025 2:26:06 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23539 opening added for modelspace dimensions" />
      <int nm="MajorVersion" vl="9" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="2/17/2025 11:34:48 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23457 accepting Node[] and ProfShape requests of tsls" />
      <int nm="MajorVersion" vl="9" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="2/4/2025 9:22:55 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23162 Z-Elevation blockspace and model fixed" />
      <int nm="MajorVersion" vl="9" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="1/21/2025 5:04:24 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23162 collection of tsl driven dimrequests prepared" />
      <int nm="MajorVersion" vl="9" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="1/10/2025 5:11:28 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22867 offset dimensions made independent from base point location" />
      <int nm="MajorVersion" vl="9" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="1/10/2025 3:53:47 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21565 supporting individual coloring if dimstyle is set to byBlock" />
      <int nm="MajorVersion" vl="9" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="1/8/2025 4:42:00 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21565 new context command to realign dimlines, supporting MultipageController" />
      <int nm="MajorVersion" vl="8" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="1/7/2025 4:56:13 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23104 initial placement of assembled items improved if painters filter content of associated metalparts" />
      <int nm="MajorVersion" vl="8" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="12/4/2024 12:52:53 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23095 accepting polylines nested in sections of xRefs intersecting the section plane" />
      <int nm="MajorVersion" vl="8" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="12/2/2024 3:22:41 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23092 accepting metalparts of xref drawings" />
      <int nm="MajorVersion" vl="8" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="12/2/2024 10:49:57 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22669 openings considered when merging multiple profiles" />
      <int nm="MajorVersion" vl="8" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="10/18/2024 5:41:44 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22817 format supports over-/undersail definition for offset dimensions (ie Oversail &lt;&gt;)" />
      <int nm="MajorVersion" vl="8" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="10/16/2024 3:29:08 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21731 new mode 'Dimension Offset' available in paperspace of hsbcad viewports" />
      <int nm="MajorVersion" vl="8" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="7/23/2024 4:25:18 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21966 bugfix" />
      <int nm="MajorVersion" vl="8" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="7/15/2024 9:35:27 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21966 supports static drills and beamcuts" />
      <int nm="MajorVersion" vl="8" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="7/11/2024 3:41:25 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22206 bugfix storing selected vieport of shopdrawings" />
      <int nm="MajorVersion" vl="8" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="6/6/2024 4:52:42 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21437 Metalpart Painter Filtering improved" />
      <int nm="MajorVersion" vl="7" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="2/16/2024 8:22:28 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21437 Metalparts and CurvedBeam improved" />
      <int nm="MajorVersion" vl="7" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="2/15/2024 9:04:21 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21361 Rabbetss and Dados added as tools" />
      <int nm="MajorVersion" vl="7" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="2/8/2024 1:04:38 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21223 catching tolerances on sheeting drills" />
      <int nm="MajorVersion" vl="7" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="1/26/2024 3:47:54 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21155 resolving references by painters on assemblies" />
      <int nm="MajorVersion" vl="7" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="1/19/2024 4:13:01 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21155 beamcuts improved" />
      <int nm="MajorVersion" vl="7" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="1/19/2024 3:24:46 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21155 new custom context command for global settings, new global setting to suppress group assignment" />
      <int nm="MajorVersion" vl="7" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="1/19/2024 2:01:34 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21155 bugfix causing file size" />
      <int nm="MajorVersion" vl="7" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="1/19/2024 10:02:34 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21155 beveled drills,improved, mortise with explicit radius gets crossmarks, slots enhanced" />
      <int nm="MajorVersion" vl="7" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="1/18/2024 3:31:08 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20292 all kinds of collection entities are supported (TrussEntity, MetalPartCollectionEntiy and CollectionEntity)" />
      <int nm="MajorVersion" vl="7" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="12/22/2023 12:35:54 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20877 dimpoint collecrtion and filtering of nested genbeams of metalparts enhanced" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="12/8/2023 2:05:42 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20687, 20853, 20855, 20861 bugfix" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="12/7/2023 3:03:46 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20687, 20853, 20855, 20861 dimline now supports the definition of individual tools based on the parent tool entity asnd/or of a custom set of tools specified by the subtype" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="12/7/2023 2:02:49 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20197 gable dimensions accepting tolerances of sheetings, setup graphics only visible if no dimensions drawn" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="12/1/2023 9:41:30 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20564 bugfix püurge dimlines" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="11/30/2023 10:03:11 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20564 performance improved especially when linked to a paperspace viewport" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="11/29/2023 3:03:01 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20550 remote purging of redundant dimlines supported" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="11/13/2023 5:49:00 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19354 individual grip based dimensions of openings supported for paperspace dimensions" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="10/27/2023 3:59:58 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20005 shape mode and reference point modes further restriced when using diagonal or gable dimension" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="9/14/2023 9:39:27 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20045 Requires hsbDesign 26 or higher, accepts multiple blockreferences, metalpart entities, resolves marker lines if selected via stereotype, resolves stereotype requests of blockreferences and metalpart entities" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="9/13/2023 5:13:29 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20043 new command to alter options of painter filtering" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="9/12/2023 2:12:55 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20038 model support genbeams enhanced, shape modes renamed, classic dim added" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="9/12/2023 12:10:58 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20005 shape mode restriced to basic shape when using diagonal or gable dimension modes. Diagonal mode enhanced" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="9/11/2023 12:41:12 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20005 element viewports support multiple aligned dimlines (i.e. on gable walls)" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="9/8/2023 3:27:14 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19355 new property 'Dimension Point Mode' enables filtering of corresponding dimension points, basic automatic creation of element painter definitions added" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="9/7/2023 3:15:55 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19354 opening support added" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="9/7/2023 10:16:13 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19788 reference point will refer to outmost point" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="8/9/2023 5:34:57 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19788 new context command in hsbcad viewport mode to set the reference location" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="8/9/2023 2:33:32 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19358 accepting element painter definitions as reference in conjunction with other dim painters" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="6/26/2023 3:15:19 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18832 dimstyles which are associated to non linear dimensions are not shown anymore" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="5/12/2023 4:25:04 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18920 new property 'ScaleFactor' supports scaling to other units" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="5/8/2023 1:00:11 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18893 bugfix on insert diagonal dimension" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="5/8/2023 10:14:45 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18893 new option for diagonal control dimensions" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="5/5/2023 9:11:26 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18008 new command to purge redundant dimlines associated to a multipage" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="2/28/2023 4:00:58 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB- 18146 purging improved if multipage invalidates" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="2/27/2023 4:06:11 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16730 segmented contours will try to reconstruct into arc segments" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="2/16/2023 8:48:14 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17432 supports dimension requests which based on element tsls" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="2/13/2023 10:58:29 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17752 compatable with hsbDesign 25" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="2/9/2023 8:56:51 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17752 new option to copy a dimline, tool options enhanced" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="2/8/2023 12:31:16 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17752 new options to dimension drills" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="2/7/2023 6:07:20 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17586 bugfix non request tsls" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="1/18/2023 4:08:05 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17586 new property to specify individual requests, new context commands to add or remove entries" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="1/18/2023 2:47:47 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16519 consumes linear dimrequests if defined within linked tsls of genbeams" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="1/17/2023 4:04:57 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15142 improving shadow contour of collection entities" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="1/17/2023 1:16:31 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17320 tsl instances of sections improved" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="1/10/2023 9:20:38 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17297 supports dimline alignment for auto scaled viewports" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="12/12/2022 1:42:40 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17175 assigning of element zone set by defining entity" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="11/25/2022 12:40:17 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17184 supports sections" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="11/23/2022 12:07:46 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16291 uniform preview improved" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="10/21/2022 4:15:41 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16291 uniform preview added" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="10/20/2022 4:05:17 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15772 ACA viewport dependencies improved" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="10/17/2022 5:09:36 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15850 bugfix collection entity reference points" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="10/6/2022 4:57:05 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16507 supports element viewports, new mode 'envelope shape' uses outer contour based specified filter" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="9/15/2022 3:19:22 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16430 multiple genbeams of element improved" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="9/5/2022 4:58:59 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14692 relative location to multipage stored" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="8/10/2022 9:11:05 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14692 selected element excluded from dimension when used as assignment in pick point mode" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="3/15/2022 9:07:56 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14692 group assignment extended when in point mode, user may select any entity as group reference without this being added to the dimension" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="3/14/2022 11:23:51 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14692 element assignment fixed when in point mode" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="3/11/2022 3:33:04 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14692 provides point mode on insert and exports to share and make" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="3/10/2022 5:09:06 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12398 accepting any painter definition if collection 'Dimension' is not found" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="12/16/2021 12:44:38 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="CMP-32 metalpart collection support added (beta)" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="8/6/2021 12:13:24 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-7777 first implementation of some tools (Cut, Drill, Beamcut) added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="8/5/2021 5:09:21 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-7777 initial version" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="8/4/2021 4:32:19 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End