#Version 8
#BeginDescription
#Versions
V0.81 10/24/2024 Aded property to draw and dimension floating members on bottom and top views
V0.80 7/10/2023 Added property to specify formats for opening tags
V0.79 4/24/2023 Added property to use posnum during sorting and labeling
V0.78 10/28/2022 Added property for maximum blockig positions displayed in a cutlist before transfering them on a new line, if 0 will keep all at same line
V0.77 5/5/2022 Added PLY to actual size grades
V0.76 5/2/2022 Added PSL to actual sizes grades
V0.75 4/9/2022 Corrected text direction of dimlines for reversed elevation viewport
V0.74 4/6/2022 Corrected left right elevation dims and sheathing overhangs for reverse elevation viewport
V0.73 4/5/2022 Corrected broken vtp dimension for reversed elevation viewport
V0.72 3/23/2022 Changed top and bottom view coordsys to respect elevation viewport coordsys
V0.71 2/8/2022 Added option to add vertical dimension of beams that are not touching bottom or top plates
V0.70 10/18/2021 Allow angled headers
V0.69 10/12/2021 Fixed bug with back hatch pattern scale
V0.68 10/4/2021 Added option to show full tag at opening center (default: No)
--Added option to show opening assembly number (default: No)
--Added option to scale hatching legend (default: 1.0)
V0.67 9/21/2021 Added option not to draw sheathing on other zones
V0.66 9/17/2021 Added properties for front and back face hatch patterns
--Added options for how to measure blocking positions and options to draw dimensions for blockings
V0.65 8/5/2021 Set flat beams distinction method to hatching, removed other options.
--Added hatching legend control point and r-click trigger.
--Made initial penetration list control point relative to legend.
--Added settings to adjust top and bottom view dimension lines
V0.64__01/06/2021__Will dimension broken VTP or TP
V0.63__12/18/2020__Changed how blcoking position is drawin
--will draw second framing cutlist from top of the page
V0.62__11/16/2020__Comented v22 feature
V0.61__10/29/2020__Corrected VTP and BTP detection algorithm order of points
V0.60__10/28/2020__Restructured Sheathing list logic
--will draw non zone 1 labels italic
--will move sheathingand hardaware list of overlaps with top or elevation views
V0.59__10/27/2020__Structured tsl region grouping by catagories
V0.58__10/26/2020__cleanup TP and BP profiles, order points in detection algorithm
V0.57__10/20/2020__record hardware schedule info into "moEntityInfo" mapobject or corresponding subMapX
V0.56__10/16/2020__record beam labels and type overrides into "moEntityInfo" mapobject or corresponding subMapX
V0.55__10/12/2020__Changed penetration label sign ø --> o
V0.54__10/06/2020__Added hatching legend
V0.53__10/05/2020__Refactored bottom plate recognition to work with multiple BP and VBP and various geometric configurations
--Will draw left elevation dim line only if no angled TPs or more then 2 points to dim
V0.52__10/02/2020__Added hatching of flat studs, labels will be staggered in beam direction in case of not full overlapping
--Refactored top plate recognition to work with multiple TP and VTP and various geometric configurations
--Refactored beam cutlist to sort alphabeticaly
--Changed penetrations list column name Item(s) --> No.
V0.51__10/01/2020__Corrected blocking labeling and sorted by position height
--Will display blocking label according to its height position
V0.50__09/20/2020__Will move Sheathing and hardare list to the right
and opening tag to the left border of layout if wall length> 17feet
V0.49__09/20/2020__Moved blocking to the end of cutlist
--Refactored cutlist to be drawn separately from data operations
--Refactored blocking staggering
V0.48__09/19/2020__Added 3 different blocking display options
--Corrected blocking list overflow and devider lines
V0.47__09/16/2020__Finished penetration schedule
V0.46__09/15/2020__Added option to override grip position
--Refactored grip memory
--Changed top view penetration label offset
V0.45__09/15/2020__Added penetrations schedule
V0.44__09/14/2020__Changed to dimmension all bottom plates
--Set bottomview section line relative to all bottom plates
--Simplified grip points map save
V0.43__08/31/2020__Change to draw top and bottom views without viewports
V0.42__06/12/2020__Added support for KT_WALL_NO_STUD_AREA_BLOCKING
V0.41__05/26/2020__Corrected labels for ATS
V0.40__05/15/2020__Will name MASA blockings
V0.39__05/05/2020__Added window weights if shop installed
V0.38__05/05/2020__Added ATS support
V0.37__02/12/2020__Hardware bugfix
V0.36__02/11/2020__Hardware list breakdown
V0.35__01/09/2020__Added support for ATS
V0.34__12/24/2019__Added dimensions for beam pockets (----Needs editional attension---going to bed)
V0.33__11/22/2019__Corrected box opening dimensions in Xrefs
V0.32__11/21/2019__Corrected kings post display
V0.31__10/14/2019__Will label beams for export
V0.30__10/02/2019__Fixed not showing plumbing labels
V0.29__09/24/2019__Dimension bugfix
V0.28__09/23/2019__Will autodetect fillers
V0.27__09/20/2019__Bugfix
V0.26__09/20/2019__Cleaner trimmer representation
V0.25__09/19/2019
--Will display actual size of beam for GLB
--Added control properties for Show Trimmers and Show Non Touching Vt Beams
V0.24__09/17/2019__Will autodetect trimmers
V0.23__09/17/2019__Bugfix
V0.22__09/17/2019__HDU note temporary disabled
V0.21__09/16/2019
//--Changed HDU warning to Shop Installed
--Will correctly work with top plates broken into multiple items
--Will display vertical beams which are not touching top and bottom plates
--Will display headers
--Will draw horizontal fillers with angled hatch
V0.20__09/13/2019__Will display dimensions for box openings
V0.19__09/13/2019__Will display actual size of beam for LVL
V0.18_Sept_06_2019__Nested header labels will not overlap
V0.17_Sept_05_2019__Will display warining if holddown is placed less then 10.5inch stud bay
V0.16_Aug_27_2019__Will display actual size of beam for OSB, ZIP, GYP, LSL
V0.15_Aug_21_2019__Opening dimensions will not rely on coordinate system of opening
V0.14_Aug_14_2019__Will display hsbcad Material for sheathing in Sheathing list
V0.13_Aug_07_2019__Will correctly dimension openings if packers are present
V0.12_Aug_02_2019__Will not display nails as separate item
V0.11_Aug_01_2019__Sorts openings left to right , up to down. Added production notes for plumbing.
V0.10_May_2019__Minor fixes
V0.9_Apr_09_2019__Dimensions opening by framing
V0.8_Apr_09_2019__Will adjust grip points if cutlist been split. Added dimension for electrical boxes, which are not attached to vertical members. Added window KPNs support for Xrefs
V0.7_Apr_08_2019__Cleaned vertical beam labels display
V0.6_Feb_28_2019__Added Field installed note to corresponding windows
V0.5_Feb_20_2019__Smallfix for sheathing material column width
V0.4_Feb_08_2019__Added blocking height to framing cut list and changed blocking labels correspondingly
V0.3_Feb_07_2019__Displays beam type Stud instead of Left /Right stud, displays Cripple instead of Cripple stud , Jack under opening, jack over opening. Will recognize very top plates and display their names as VTP
V0.2_Feb_06_2019__If sill height is less than 3inches do not count for it
v0.1_Dec_11_2018__TSL wich replaces most of TSLs for wall shop drawings.
Draws Bottom and Top views.
Dimensions beams and anchors in bottom view.
Creates wall size dimensions, hold downs and sheeting overhangs in elevation view.
Creates beam cutlist and labels beams.
Creates opening tags and opening info.
Creates sheathing list and sheathing tags.
Creates hardware list and hardware tags.
Creates electrical list and electrical tags.
Creates plumbing list and plumbing tags.













#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 0
#MinorVersion 81
#KeyWords 
#BeginContents
//region TSL MANAGEMENT
//--------------- <TSL MANAGEMENT> --- start
//---------------

	//region TSL PROPERIES
	//--------------- <TSL PROPERIES> --- start
	//---------------

	U(1, "inch");
	String arCategories[] = { "Front Face Hatch", "Back Face Hatch", "Blocking", "Sheathing", "Openings", "Legend"};
	
	PropDouble pdBottomViewOffset(0, U(1.5), "Section line offset Bottom view");
	PropDouble pdTopViewOffset(1, U(1.5), "Section line offset Top view");

	PropInt piColor(2, 8, "Dash line color");
	piColor.setCategory(arCategories[3]);
	String arZoneChoice[] = {"Front and Back", "Use zone index", "All zones"};
	PropString prZoneChoice(0, arZoneChoice, "Filter sheets by: ", 0);
	prZoneChoice.setCategory(arCategories[3]);
	int arSheetingZones[] = {1, 2, 3, 4, 5, -1, -2, -3, -4, -5 };
	PropInt piSheetingZone(0, arSheetingZones, "Zone index", 0);
	piSheetingZone.setCategory(arCategories[3]);

	String arYN[] = { "Yes", "No"};
	String& sYes = arYN[0]; String& sNo = arYN[1];
	PropString prMoveElectrical(1, arYN, "Adjust Electrical list position", 0);
	PropInt piCutlistRows(1, 19, "Max Cut List rows");
	if (piCutlistRows < 14) piCutlistRows.set(14);
	PropInt piMaxBlockingPositions(2, 2, "Max blocking positions until new line");
	PropString psShowTrimmers(2, arYN, "Show Trimmers", 0);
	PropString psShowNonTouching(3, arYN, "Show Vt Non-Touching Beams", 0);
	PropDouble pdTopVPoffset(2, U(1.25), "Top view offset");
	PropDouble pdTopVPdimOffset(3, U(0.2), "Top view dim offset");
	PropDouble pdBottomVPoffset(4, U(1), "Bottom view offset");
	PropDouble pdBottomVPdimOffset(5, U(0.2), "Bottom view dim offset");

	int arHatchDefaults[] = { _HatchPatterns.find("ANSI31"), _HatchPatterns.find("ANSI31")};//-c//_HatchPatterns.find("AR-B816")};
	if (arHatchDefaults[0] < 0) arHatchDefaults[0] = 0;
	if (arHatchDefaults[1] < 0) arHatchDefaults[1] = 1;

	double arAngleDefaults[] = { 180, 90};//-c//0};
	double arScaleDefaults[] = { 0.25, 0.25};//-c//0.005};

	PropString psFrontHatch(4, _HatchPatterns, "Pattern", arHatchDefaults[0]);
	psFrontHatch.setCategory(arCategories[0]);
	PropDouble pdFrontAngle(6, arAngleDefaults[0], "Angle");
	pdFrontAngle.setCategory(arCategories[0]);
	PropDouble pdFrontScale(7, arScaleDefaults[0], "Scale");
	pdFrontScale.setCategory(arCategories[0]);
	pdFrontScale.setFormat(_kNoUnit);

	PropString psBackHatch(5, _HatchPatterns, "Pattern", arHatchDefaults[1]);
	psBackHatch.setCategory(arCategories[1]);
	PropDouble pdBackAngle(8, arAngleDefaults[1], "Angle");
	pdBackAngle.setCategory(arCategories[1]);
	PropDouble pdBackScale(9, arScaleDefaults[1], "Scale");
	pdBackScale.setCategory(arCategories[1]);
	pdBackScale.setFormat(_kNoUnit);

	String arMeasureBlocking[] = { "Bottom", "Center", "Top"};
	PropString psBlockingMeasure(6, arMeasureBlocking, T("Measure up to"), 1);//-c//0);
	psBlockingMeasure.setCategory(arCategories[2]);
	PropString psBlockingDoDimension(7, arYN, T("Do domensions"), 1);//-c//0);
	psBlockingDoDimension.setCategory(arCategories[2]);
	PropString psBlockingLineToDim(8, arYN, T("Do horizontal dimline"), 1);//-c//0);
	psBlockingLineToDim.setCategory(arCategories[2]);

	PropString psDrawOtherSheets(9, arYN, T("Draw other sheet zones"), 0);
	psDrawOtherSheets.setCategory(arCategories[3]);
	if (prZoneChoice==arZoneChoice[2])
		psDrawOtherSheets.setReadOnly(_kHidden);

	PropString psShowFullTagAtOpening(10, arYN, T("Show full tag at opening"), 1);//-c -//0;
	psShowFullTagAtOpening.setCategory(arCategories[4]);
	PropString psShowKPN(11, arYN, T("Show assembly number"), 1);
	psShowKPN.setCategory(arCategories[4]);
	PropString psOpeningLabelFormat(14, "", T("Tag label format"));
	psOpeningLabelFormat.setCategory(arCategories[4]);
	psOpeningLabelFormat.setDefinesFormatting("Opening");
	psOpeningLabelFormat.setDescription(T("Coma separated list of formats.\nIf empty will automatically assign labels based on location in the wall."));
	
	PropDouble pdHatchLegendScale(10, 1.0, T("Hatch scale overall"));//-c//1.15);
	pdHatchLegendScale.setCategory(arCategories[5]);
	pdHatchLegendScale.setFormat(_kNoUnit);

	String arPainterDefs[] = { "#None"};
	arPainterDefs.append(PainterDefinition().getAllEntryNames());
	PropString psFloatingVtDef(12, arPainterDefs, T("Floating Verticals Definition"), 0); PropString psDimFloatVt(15, arYN, T("Dimension Floating Verticals at Top & Bottom Views"), 1);

	PropString userUsePosnum(13, arYN, T("Use Posnum"), 1);
	
	

	//---------------
	//--------------- <TSL PROPERIES> --- end
	//endregion

	//region INSERT ROUTINE
	//--------------- <INSERT ROUTINE> --- start
	//---------------

	if (_bOnInsert)
	{
		_Pt0 = getPoint("\n Select top left corner of a drawing");
		Viewport vp0 = getViewport("\n Select elavation viewport");
		_Viewport.append(vp0);
		Point3d pntLegend = getPoint("\n Select grip point for hatching legend");
		_Map.setPoint3d("pntLegend", pntLegend);
		return;
	}
	setMarbleDiameter(U(2));
	if (_bOnRecalc) _PtG.setLength(0);

	//---------------
	//--------------- <INSERT ROUTINE> --- end
	//endregion

	//region GENERAL STATIC DATA
	//--------------- <GENERAL STATIC DATA> --- start
	//---------------
	int i_hsbversion;
	{
		String ar_st_hsbVersion[] = hsbOEVersion().tokenize(" ");
		for (int n; n<ar_st_hsbVersion.length(); ++n)
		{
			String st_token = ar_st_hsbVersion[n];
			int i_found = st_token.find("hsbCAD", 0);
			if (i_found >- 1)
			{
				st_token.trimLeft("hsbCAD");
				i_hsbversion = st_token.atoi();
				break;
			}
		}
	}
	String stDimStyle = _DimStyles[_DimStyles.find("Wall Shopdrawing")];
	String st_dimStyleItalic = "Wall Shopdrawing Italic";
	int i_foundItalicStyle = _DimStyles.find(st_dimStyleItalic);
	Display dpS(-1);
	dpS.dimStyle(stDimStyle);
	Vector3d paperX = _XW;
	Vector3d paperY = _YW;
	_Pt0.vis(1);

	Viewport vpElevation = _Viewport[_Viewport.length() - (_Viewport.length()==3 ? 3 : 1)];
	CoordSys csVpElevation = vpElevation.coordSys();
	CoordSys csVpElevationInvert = csVpElevation;
	csVpElevationInvert.invert();
	double dScaleElevation = csVpElevationInvert.scale();
	CoordSys csVpTop, csVpTopInvert, csVpBottom, csVpBottomInvert;

	Display dpElevation(-1);
	dpElevation.dimStyle(stDimStyle, dScaleElevation);
	Display dpBottom(-1);
	dpBottom.dimStyle(stDimStyle, dScaleElevation);
	Display dpTop(-1);
	dpTop.dimStyle(stDimStyle, dScaleElevation);
	Element el = vpElevation.element();
	if ( ! el.bIsValid()) return;

	ElementWallSF wSF=(ElementWallSF)el;
	Point3d ptElCen = (wSF.ptStartOutline() + wSF.ptEndOutline()) * 0.5;
	{
		csVpTopInvert = CoordSys(csVpElevationInvert.ptOrg()+(1.5*vpElevation.heightPS()+pdTopVPoffset)*csVpElevationInvert.vecZ(), csVpElevationInvert.vecX(), -csVpElevationInvert.vecZ(), csVpElevationInvert.vecY());
		csVpTop = csVpTopInvert;
		csVpTop.invert();

		csVpBottomInvert = CoordSys(csVpElevationInvert.ptOrg()-(0.5*vpElevation.heightPS()-pdBottomVPoffset)*csVpElevationInvert.vecZ(), csVpElevationInvert.vecX(), csVpElevationInvert.vecZ(), csVpElevationInvert.vecY());
		csVpBottom = csVpBottomInvert;
		csVpBottom.invert();
	}
	String elHandle = el.handle();

	Beam bmAll[] = el.beam();
	Vector3d elX = el.vecX();
	Vector3d elY = el.vecY();
	Vector3d elZ = el.vecZ();

	Vector3d elXpaper = elX;
	elXpaper.transformBy(csVpElevation);
	int iReverseX = sign(elXpaper.dotProduct(paperX));

	Plane plFrontFace(el.ptOrg(), elZ);
	String arAlphabet[] = { "A", "B", "C", "D", "E", "F", "G", "H", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"};

	//---------------
	//--------------- <GENERAL STATIC DATA> --- end
	//endregion

	//region MANAGE GRIP POINTS
	//--------------- <MANAGE GRIP POINTS> --- start
	//---------------

	String cnst_st_overrideName = "mpOverride";
	String cnst_st_gripPrefix = "Ptg";
	String cnst_st_gripPrefixProp = "_PtG";
	String cnst_st_overrideOn = "Set grip override for all walls:";
	String cnst_st_overrideOff = "Remove grip override for all walls:";
	String cnst_st_delimiter =   "___________________________________";
	String ar_st_gripNames[] = { "Opening Tags", "Sheathing List", "Hardware List", "Electrical List", "Plumbing List", "Penetrations List"};
	for (int n; n < ar_st_gripNames.length(); ++n) addRecalcTrigger(_kContextRoot, cnst_st_overrideOn + ar_st_gripNames[n]);
	addRecalcTrigger(_kContextRoot, cnst_st_delimiter);
	for (int n; n < ar_st_gripNames.length(); ++n) addRecalcTrigger(_kContextRoot, cnst_st_overrideOff + ar_st_gripNames[n]);
	for(int n; n<ar_st_gripNames.length(); ++n) _PtG.append(_Pt0);
	addRecalcTrigger(_kContextRoot, cnst_st_delimiter+"_");
	String cnst_st_legend = "Move Hatching Legend";
	addRecalcTrigger(_kContextRoot, cnst_st_legend);
	if (_kExecuteKey == cnst_st_legend){
		Point3d pntLegend = _Map.getPoint3d("pntLegend");
		Point3d pntChoice = pntLegend;
		PrPoint prpnt("\n Select point for hatching legend", pntLegend);
		if (prpnt.go()) pntChoice = prpnt.value();
		_Map.setPoint3d("pntLegend", pntChoice);
	}

	Map mp_grips;
	if (_Map.hasMap(elHandle)) mp_grips = _Map.getMap(elHandle);
	//remember user changed grips
	{
		if (_kNameLastChangedProp.find(cnst_st_gripPrefixProp, 0)>-1)
		{
			int i_index = _kNameLastChangedProp.trimLeft(cnst_st_gripPrefixProp).atoi();
			if (i_index < _PtG.length()) {
				mp_grips.setPoint3d(cnst_st_gripPrefix + i_index, _PtG[i_index]);
				_Map.setMap(elHandle, mp_grips);
			}
		}
	}

	int b_memoryGrip[ar_st_gripNames.length()];
	if (mp_grips.length()>0)
	{
		if (_bOnRecalc && !_bOnViewportListModified && _kNameLastChangedProp.length() == 0 && _kExecuteKey.find(":", 0) < 0 && _kExecuteKey.find("__",0) < 0 && _kExecuteKey!=cnst_st_legend) _Map.removeAt(elHandle, false);
		else
		{
			for (int n; n<mp_grips.length(); ++n)
			{
				int i_index = mp_grips.keyAt(n).trimLeft(cnst_st_gripPrefix).atoi();
				_PtG[i_index] = mp_grips.getPoint3d(n);
				b_memoryGrip[i_index] = true;
			}
		}
	}

	//set grips for entire drawing
	{
		if (_kExecuteKey.find(":", 0)>-1)
		{
			int i_foundKey = ar_st_gripNames.find(_kExecuteKey.token(1, ":"));
			if (i_foundKey>-1)
			{
				Map mp_override;
				if (_Map.hasMap(cnst_st_overrideName)) mp_override = _Map.getMap(cnst_st_overrideName);
				if (_kExecuteKey.find(cnst_st_overrideOn, 0) >- 1) mp_override.setPoint3d(cnst_st_gripPrefix + i_foundKey, _PtG[i_foundKey]);
				else if (_kExecuteKey.find(cnst_st_overrideOff, 0) >- 1) mp_override.removeAt(cnst_st_gripPrefix + i_foundKey, false);
				if (mp_override.length() > 0)_Map.setMap(cnst_st_overrideName, mp_override);
				else _Map.removeAt(cnst_st_overrideName, false);
			}
		}
	}
	int b_overrideGrips[ar_st_gripNames.length()];
	if (_Map.hasMap(cnst_st_overrideName))
	{
		Map mp_override = _Map.getMap(cnst_st_overrideName);
		for (int n; n < b_overrideGrips.length(); ++n)
		{
			if (mp_override.hasPoint3d(cnst_st_gripPrefix+n))
			{
				_PtG[n] = mp_override.getPoint3d(cnst_st_gripPrefix + n);
				b_overrideGrips[n] = true;
				b_memoryGrip[n] = false;
			}
		}
	}

	//---------------
	//--------------- <MANAGE GRIP POINTS> --- end
	//endregion

	//region ENTITY INFO MAPOBJECT
	//--------------- <ENTITY INFO MAPOBJECT> --- start
	//---------------

	String st_elementXrefHandle;
	{
		Entity ent_Xref = el.blockRef();
		BlockRef block_Xref = (BlockRef) ent_Xref;
		String st_XrefName = block_Xref.definition();
		if (block_Xref.bIsValid() && st_XrefName != "") st_elementXrefHandle = block_Xref.handle();
	}

	MapObject mo_EntityInfo("moEntityInfo", "mpEntityInfo");
	Map mp_EntityInfo;
	if (mo_EntityInfo.bIsValid()) mp_EntityInfo = mo_EntityInfo.map();
	else mo_EntityInfo.dbCreate(mp_EntityInfo);

	//---------------
	//--------------- <ENTITY INFO MAPOBJECT> --- end
	//endregion

//---------------
//--------------- <TSL MANAGEMENT> --- end
//endregion


//region FRAMING PART 1
//--------------- <FRAMING PART 1> --- start
//---------------

	//region FILLER GRADES , ACTUAL SIZE GRADES, VERTICAL AND HORIZONTAL BEAM ARRAYS
	//--------------- <FILLER GRADES , ACTUAL SIZE GRADES, VERTICAL AND HORIZONTAL BEAM ARRAYS> --- start
	//---------------

	String stCheckType = _BeamTypes[bmAll[0].type()];
	if (stCheckType.find("SF ", 0) >- 1) stCheckType = stCheckType.right(stCheckType.length()-3);
	double dCheckType = dpS.textLengthForStyle(stCheckType, stDimStyle);
	String stCheckLength;
	stCheckLength.formatUnit(bmAll[0].solidLength(), stDimStyle);
	double dCheckLength = dpS.textLengthForStyle(stCheckLength, stDimStyle);
	double dChWidth = bmAll[0].dW();
	double dChHeight = bmAll[0].dH();
	int iFillerTypes[] = { 20, 37, 125, 126};
	String arActualSizeGrades[] = {  "OSB", "ZIP", "PLY", "GYP", "LSL", "LVL", "GLB", "PSL"};
	String arFillerGrades[] = { "OSB", "ZIP", "GYP"};
	int iFillerCheck = iFillerTypes.find(bmAll[0].type());
	for (int i=0; i<arActualSizeGrades.length(); i++)
	{
		if (bmAll.first().grade().find(arActualSizeGrades[i], 0 , false)>-1 || bmAll.first().material().find(arActualSizeGrades[i], 0 , false)>-1 || bmAll.first().name().find(arActualSizeGrades[i], 0 , false)>-1) iFillerCheck = 0;
	}
	if (iFillerCheck==-1)
	{
		if (ceil(dChWidth) - dChWidth > 0){dChWidth = ceil(dChWidth);}
		if (ceil(dChHeight) - dChHeight > 0){	dChHeight = ceil(dChHeight);}
	}
	double dChS[] = { dChWidth, dChHeight};
	if (dChWidth > dChHeight) dChS.swap(0, 1);
	String stChSize = dChS[0] + "x" + dChS[1]+" "+bmAll.first().grade();
	if (iFillerCheck>-1)
	{
		String stWidthFormated;
		stWidthFormated.formatUnit(dChS[0], stDimStyle);
		String stHeightFormated;
		stHeightFormated.formatUnit(dChS[1], stDimStyle);
		stChSize = stWidthFormated + "x" + stHeightFormated + " " + bmAll.first().grade();
	}
	double dCheckSize = dpS.textLengthForStyle(stChSize, stDimStyle);

	Beam bmVt[] = elX.filterBeamsPerpendicularSort(bmAll);
	Beam bmHz[] = elY.filterBeamsPerpendicularSort(bmAll);
	for (int i=0;i<bmAll.length();i++)
	{
		Beam bm = bmAll[i];
		if (bmVt.find(bm) == -1 && bmHz.find(bm) == -1) bmHz.append(bm);
	}

	//---------------
	//--------------- <FILLER GRADES , ACTUAL SIZE GRADES, VERTICAL AND HORIZONTAL BEAM ARRAYS> --- end
	//endregion

	//region BEAM TYPES
	//--------------- <BEAM TYPES> --- start
	//---------------

	Beam ar_bm_blocking[0], ar_bm_TP[0], ar_bm_BP[0], bmStuds[0];
	int ar_i_blockingTypes[] = {10, 12, 26, 69, 71, 108, 119, 120};
	int arTopPlatesTypes[] = { 1, 24, 32, 54, 55, 100, 101, 105};
	int arBottomPlatesTypes[] = { 25, 34, 41, 102, 103, 104};
	int arStudTypes[] = { 27, 30, 6, 49, 52, 53, _kKingPost};
	int arHeaderTypes[] = { 18, 94, 95, 106};
	int arSillTypes[] = { 28, 107};

	//---------------
	//--------------- <BEAM TYPES> --- end
	//endregion

	//region PREPARE VALUE FOR HORIZONTAL BEAMS LABELS STAGGERING
	//--------------- <PREPARE VALUE FOR HORIZONTAL BEAMS LABELS STAGGERING> --- start
	//---------------

	Point3d ptBmsProjectedHz[0];
	ptBmsProjectedHz.setLength(bmHz.length());
	String arHeaderPack[0];
	int bIsInHeaderPack[bmHz.length()];
	Beam bmHzTemp[0];
	bmHzTemp.append(bmHz);
	Vector3d vcInside = (ptElCen - plFrontFace.closestPointTo(ptElCen)).normal();
	int iHzTqty = bmHzTemp.length() - 1;
	while (iHzTqty>-1)
	{
		Beam bm = bmHzTemp[iHzTqty];
		bmHzTemp.removeAt(iHzTqty);
		if (arHeaderTypes.find(bm.type())>-1 || iFillerTypes.find(bm.type())>-1)
		{
			Beam bmInPack[] = Beam().filterBeamsHalfLineIntersectSort(bmHzTemp, plFrontFace.closestPointTo(bm.ptCen())-U(1)*vcInside, vcInside);
			if (bmInPack.length()>0)
			{
				bIsInHeaderPack[bmHz.find(bm)] = true;
				String stPack(bmHz.find(bm));
				for (int k=bmInPack.length()-1; k>-1; k--)
				{
					stPack += "@"+bmHz.find(bmInPack[k]);
					bIsInHeaderPack[bmHz.find(bmInPack[k])] = true;
					bmHzTemp.removeAt(bmHzTemp.find(bmInPack[k]));
				}
				arHeaderPack.append(stPack);
			}
			else bIsInHeaderPack[bmHz.find(bm)] = false;
		}
		else bIsInHeaderPack[bmHz.find(bm)] = false;
		iHzTqty = bmHzTemp.length() - 1;
	}
	double iLabelStagger[0];
	for (int i=0; i<bmHz.length(); i++)
	{
		Point3d ptProjected = plFrontFace.closestPointTo(bmHz[i].ptCen());
		ptBmsProjectedHz.append(Line(el.ptOrg(), elY).closestPointTo(ptProjected));
		int iStagger = (0.5 * (i + 1)) - ceil(0.5 * (i + 1)) != 0 ? - 1.25 : 1.25;
		if (bIsInHeaderPack[i])
		{
			for (int k=0; k<arHeaderPack.length(); k++)
			{
				String packed[] = arHeaderPack[k].tokenize("@");
				int iFound = packed.find(String(i));
				if (iFound >- 1) iStagger = packed.length() - ((2 * iFound) + 1);
			}
		}
		iLabelStagger.append(iStagger);
	}

	//---------------
	//--------------- <PREPARE VALUE FOR HORIZONTAL BEAMS LABELS STAGGERING> --- end
	//endregion

	//region SORT BEAMS BY BEAM TYPE
	//--------------- <SORT BEAMS BY BEAM TYPE> --- start
	//---------------

	for (int n; n<bmAll.length(); ++n)
	{
		Beam bm_this = bmAll[n];
		int i_typeThis = bm_this.type();
		if (arTopPlatesTypes.find(i_typeThis) >- 1) ar_bm_TP.append(bm_this);
		else if (arBottomPlatesTypes.find(i_typeThis) >- 1) ar_bm_BP.append(bm_this);
		else if (arStudTypes.find(i_typeThis) >- 1) bmStuds.append(bm_this);
		else if (ar_i_blockingTypes.find(i_typeThis) >- 1) ar_bm_blocking.append(bm_this);
	}

	//---------------
	//--------------- <SORT BEAMS BY BEAM TYPE> --- end
	//endregion

	//region TEXT DIMENSIONS
	//--------------- <TEXT DIMENSIONS> --- start
	//---------------

	double dRowH = dpS.textHeightForStyle("(/)", stDimStyle);
	double dCharL = dpS.textLengthForStyle("A", stDimStyle);

	//---------------
	//--------------- <TEXT DIMENSIONS> --- end
	//endregion

	//region GET ALL TOP PLATES
	//--------------- <GET ALL TOP PLATES> --- start
	//---------------
	int b_angledTP = false;
	Beam ar_bm_VTP[0];
	PlaneProfile pp_TPall;
	for (int n; n<ar_bm_TP.length(); ++n)
	{
		PlaneProfile pp_this = ar_bm_TP[n].realBody().shadowProfile(plFrontFace);
		pp_this.removeAllOpeningRings();
		if (n == 0) pp_TPall = pp_this;
		else pp_TPall.unionWith(pp_this);
		if ( ! ar_bm_TP[n].vecX().isPerpendicularTo(elY)) b_angledTP = true;
	}
	if (ar_bm_TP.length()>1)
	{
		pp_TPall.shrink(-1*String("1/32").atof(_kLength));
		pp_TPall.shrink(String("1/32").atof(_kLength));
	}
	PlaneProfile pp_TPlow;
	Point3d ar_pt_TP[0];
	{
		Point3d ar_pt_big[0];

		//clean extra points and order

			Point3d ar_pt_bigUnsorted[] = pp_TPall.getGripVertexPoints();
			Point3d ar_pt_bigMids[] = pp_TPall.getGripEdgeMidPoints();
			PLine pl_bigMids(elZ);
			for (int n; n < ar_pt_bigMids.length(); ++n) pl_bigMids.addVertex(ar_pt_bigMids[n]);
			pl_bigMids.close();
			Point3d ar_pt_bigFiltered[0];
			double ar_d_diff[0];
			for (int n; n < ar_pt_bigUnsorted.length(); ++n)
			{
				double d_dist = LineSeg(ar_pt_bigUnsorted[n], pl_bigMids.closestPointTo(ar_pt_bigUnsorted[n])).length();
				if (d_dist >= 0.01) ar_pt_bigFiltered.append(ar_pt_bigUnsorted[n]);
				ar_d_diff.append(d_dist);
			}
			Point3d ar_pt_bigXmost[] = Line(el.ptOrg(), elX).orderPoints(ar_pt_bigFiltered);
			int i_bigXmost = ar_pt_bigFiltered.find(ar_pt_bigXmost.first());
			for (int n = i_bigXmost; n < ar_pt_bigFiltered.length(); ++n) ar_pt_big.append(ar_pt_bigFiltered[n]);
			for (int n; n < i_bigXmost; ++n) ar_pt_big.append(ar_pt_bigFiltered[n]);


		PlaneProfile pp_small(pp_TPall);
		pp_small.shrink(String("1/32").atof(_kLength));
		Point3d ar_pt_small[0];
		//clean extra points and order

			Point3d ar_pt_smallUnsorted[] = pp_small.getGripVertexPoints();
			Point3d ar_pt_smallMids[] = pp_small.getGripEdgeMidPoints();
			PLine pl_smallMids(elZ);
			for (int n; n < ar_pt_smallMids.length(); ++n) pl_smallMids.addVertex(ar_pt_smallMids[n]);
			pl_smallMids.close();
			Point3d ar_pt_smallFiltered[0];
			for (int n; n < ar_pt_smallUnsorted.length(); ++n)
			{
				if (LineSeg(ar_pt_smallUnsorted[n], pl_smallMids.closestPointTo(ar_pt_smallUnsorted[n])).length() >= 0.01) ar_pt_smallFiltered.append(ar_pt_smallUnsorted[n]);
			}
			Point3d ar_pt_smallXmost[] = Line(el.ptOrg(), elX).orderPoints(ar_pt_smallFiltered);
			int i_smallXmost = i_bigXmost;
			for (int n = i_smallXmost; n < ar_pt_smallFiltered.length(); ++n) ar_pt_small.append(ar_pt_smallFiltered[n]);
			for (int n; n < i_smallXmost; ++n) ar_pt_small.append(ar_pt_smallFiltered[n]);


		if (ar_pt_big.length() != ar_pt_small.length()) reportMessage("\n " + el.number() + " TP points do not coinside");
		Point3d ar_pt_bigLow[0], ar_pt_smallLow[0], ar_pt_bigHeigh[0];
		for (int n; n<ar_pt_big.length(); ++n)
		{
			Point3d pt_big = ar_pt_big[n];
			Point3d pt_small = ar_pt_small[n];
			if ((pt_small-pt_big).dotProduct(elY) > 0)
			{
				ar_pt_bigLow.append(pt_big);
				ar_pt_smallLow.append(pt_small);
			}
			else ar_pt_bigHeigh.append(pt_big);
		}

		PLine pl_low(elZ);
		for (int n; n < ar_pt_bigLow.length(); ++n) pl_low.addVertex(ar_pt_bigLow[n]);
		for (int n = ar_pt_smallLow.length() - 1; n >- 1; --n) pl_low.addVertex(ar_pt_smallLow[n]);
		pl_low.close();
		pp_TPlow = PlaneProfile(pl_low);

		for (int n; n<ar_bm_TP.length(); ++n)
		{
			Beam bm_this = ar_bm_TP[n];
			PlaneProfile pp_this = bm_this.realBody().shadowProfile(plFrontFace);
			if (!PlaneProfile(pp_this).intersectWith(PlaneProfile(pp_TPlow))) ar_bm_VTP.append(bm_this);
		}

		Point3d ar_pt_bigHeighX[] = Line(el.ptOrg(), elX).orderPoints(ar_pt_bigHeigh);
		Plane pl_wallCenter(ptElCen, elZ);
		ar_pt_TP.append(pl_wallCenter.closestPointTo(ar_pt_bigHeighX.first()));
		ar_pt_TP.append(pl_wallCenter.closestPointTo(ar_pt_bigHeighX.last()));		
		Point3d ar_pt_bigLowX[] = Line(el.ptOrg(), elX).orderPoints(ar_pt_bigLow);
		Point3d ar_pt_section[] = { ar_pt_bigLowX.first(), ar_pt_bigLowX.last()};
		for (int n; n<ar_pt_section.length(); ++n)
		{
			Point3d pt_this = ar_pt_section[n];
			Point3d pt_other = ar_pt_bigLowX[(n == 0 ? 1 : ar_pt_bigLowX.length() - 2)];
			Vector3d vc_move = pt_this - pt_other;
			Vector3d vc_arrow = vc_move.crossProduct(elZ);
			if (vc_arrow.dotProduct(elY) > 0) vc_arrow *= -1;
			vc_arrow.transformBy(csVpElevation);
			vc_move.transformBy(csVpElevation);
			vc_arrow.normalize();
			vc_move.normalize();
			pt_this.transformBy(-pdTopViewOffset * elY);
			pt_this.transformBy(csVpElevation);
			pt_this.transformBy(0.5 * dCharL * (n == 0 ? - 1 : 1) * paperX);
			LineSeg ls_base(pt_this, pt_this + 2 * dCharL * vc_move);
			dpS.draw(ls_base);
			LineSeg ls_arrow(ls_base.ptMid(), ls_base.ptMid() - 1.75 * dCharL * vc_arrow);
			dpS.draw(ls_arrow);
			LineSeg ls_arrow1(ls_base.ptMid(), ls_base.ptMid() - 1 * dCharL * vc_arrow + 0.25 * dCharL * vc_move);
			dpS.draw(ls_arrow1);
			LineSeg ls_arrow2(ls_base.ptMid(), ls_base.ptMid() - 1 * dCharL * vc_arrow - 0.25 * dCharL * vc_move);
			dpS.draw(ls_arrow2);
		}
	}
	Point3d& ptTPleftmost = ar_pt_TP[0];
	Point3d& ptTPrightmost = ar_pt_TP[1];
	//---------------
	//--------------- <GET ALL TOP PLATES> --- end
	//endregion

	//region GET ALL BOTTOM PLATES
	//--------------- <GET ALL BOTTOM PLATES> --- start
	//---------------
	Beam ar_bm_BPSorted[] = elY.filterBeamsPerpendicularSort(ar_bm_BP);
	Vector3d vcWallin = elZ;
	if ((ptElCen - el.ptOrg()).dotProduct(elZ) < 0) vcWallin = - vcWallin;
	Plane plBackFace(el.ptOrg() + ar_bm_BPSorted.first().dD(elZ) * vcWallin, vcWallin);

	Beam ar_bm_VBP[0];
	PlaneProfile pp_BPall;
	for (int n; n<ar_bm_BP.length(); ++n)
	{
		PlaneProfile pp_this = ar_bm_BP[n].realBody().shadowProfile(plFrontFace);
		pp_this.removeAllOpeningRings();
		if (n == 0) pp_BPall = pp_this;
		else pp_BPall.unionWith(pp_this);
	}
	if (ar_bm_BP.length()>1)
	{
		pp_BPall.shrink(-1*String("1/32").atof(_kLength));
		pp_BPall.shrink(String("1/32").atof(_kLength));
	}
	PlaneProfile pp_BPlow;
	Point3d ar_pt_BP[0], ar_pt_BPsectionView[0];
	{
		Point3d ar_pt_big[0];
		//clean extra points and order

			Point3d ar_pt_bigUnsorted[] = pp_BPall.getGripVertexPoints();
			Point3d ar_pt_bigMids[] = pp_BPall.getGripEdgeMidPoints();
			PLine pl_bigMids(elZ);
			for (int n; n < ar_pt_bigMids.length(); ++n) pl_bigMids.addVertex(ar_pt_bigMids[n]);
			pl_bigMids.close();
			Point3d ar_pt_bigFiltered[0];
			for (int n; n < ar_pt_bigUnsorted.length(); ++n)
			{
				if (LineSeg(ar_pt_bigUnsorted[n], pl_bigMids.closestPointTo(ar_pt_bigUnsorted[n])).length() >= 0.01) ar_pt_bigFiltered.append(ar_pt_bigUnsorted[n]);
			}
			Point3d ar_pt_bigXmost[] = Line(el.ptOrg(), elX).orderPoints(ar_pt_bigFiltered);
			int i_bigXmost = ar_pt_bigFiltered.find(ar_pt_bigXmost.first());
			for (int n = i_bigXmost; n < ar_pt_bigFiltered.length(); ++n) ar_pt_big.append(ar_pt_bigFiltered[n]);
			for (int n; n < i_bigXmost; ++n) ar_pt_big.append(ar_pt_bigFiltered[n]);


		PlaneProfile pp_small(pp_BPall);
		pp_small.shrink(String("1/32").atof(_kLength));
		Point3d ar_pt_small[0];
		//clean extra points and order

			Point3d ar_pt_smallUnsorted[] = pp_small.getGripVertexPoints();
			Point3d ar_pt_smallMids[] = pp_small.getGripEdgeMidPoints();
			PLine pl_smallMids(elZ);
			for (int n; n < ar_pt_smallMids.length(); ++n) pl_smallMids.addVertex(ar_pt_smallMids[n]);
			pl_smallMids.close();
			Point3d ar_pt_smallFiltered[0];
			for (int n; n < ar_pt_smallUnsorted.length(); ++n)
			{
				if (LineSeg(ar_pt_smallUnsorted[n], pl_smallMids.closestPointTo(ar_pt_smallUnsorted[n])).length() >= 0.01) ar_pt_smallFiltered.append(ar_pt_smallUnsorted[n]);
			}
			Point3d ar_pt_smallXmost[] = Line(el.ptOrg(), elX).orderPoints(ar_pt_smallFiltered);
			int i_smallXmost = i_bigXmost;
			for (int n = i_smallXmost; n < ar_pt_smallFiltered.length(); ++n) ar_pt_small.append(ar_pt_smallFiltered[n]);
			for (int n; n < i_smallXmost; ++n) ar_pt_small.append(ar_pt_smallFiltered[n]);


		if (ar_pt_big.length() != ar_pt_small.length()) reportMessage("\n " + el.number() + " BP points do not coinside");
		Point3d ar_pt_bigHeigh[0], ar_pt_smallHeigh[0], ar_pt_bigLow[0];
		for (int n; n<ar_pt_big.length(); ++n)
		{
			Point3d pt_big = ar_pt_big[n];
			Point3d pt_small = ar_pt_small[n];
			if ((pt_small-pt_big).dotProduct(elY) < 0)
			{
				ar_pt_bigHeigh.append(pt_big);
				ar_pt_smallHeigh.append(pt_small);
			}
			else ar_pt_bigLow.append(pt_big);
		}

		PLine pl_heigh(elZ);
		for (int n; n < ar_pt_bigHeigh.length(); ++n) pl_heigh.addVertex(ar_pt_bigHeigh[n]);
		for (int n = ar_pt_smallHeigh.length() - 1; n >- 1; --n) pl_heigh.addVertex(ar_pt_smallHeigh[n]);
		pl_heigh.close();
		pp_BPlow = PlaneProfile(pl_heigh);

		for (int n; n<ar_bm_BP.length(); ++n)
		{
			Beam bm_this = ar_bm_BP[n];
			PlaneProfile pp_this = bm_this.realBody().shadowProfile(plFrontFace);
			if (!PlaneProfile(pp_this).intersectWith(PlaneProfile(pp_BPlow))) ar_bm_VBP.append(bm_this);
		}

		Point3d ar_pt_bigLowX[] = Line(el.ptOrg(), elX).orderPoints(ar_pt_bigLow);
		Plane pl_wallCenter(ptElCen, elZ);
		ar_pt_BP.append(pl_wallCenter.closestPointTo(ar_pt_bigLowX.first()));
		ar_pt_BP.append(pl_wallCenter.closestPointTo(ar_pt_bigLowX.last()));
		Point3d ar_pt_bigHeighX[] = Line(el.ptOrg(), elX).orderPoints(ar_pt_bigHeigh);
		Point3d ar_pt_section[] = { ar_pt_bigHeighX.first(), ar_pt_bigHeighX.last()};
		for (int n; n<ar_pt_section.length(); ++n)
		{
			Point3d pt_this = ar_pt_section[n];
			Point3d pt_other = ar_pt_bigHeighX[(n == 0 ? 1 : ar_pt_bigHeighX.length() - 2)];
			Vector3d vc_move = pt_this - pt_other;
			Vector3d vc_arrow = vc_move.crossProduct(elZ);
			if (vc_arrow.dotProduct(elY) < 0) vc_arrow *= -1;
			vc_arrow.transformBy(csVpElevation);
			vc_move.transformBy(csVpElevation);
			vc_arrow.normalize();
			vc_move.normalize();
			pt_this.transformBy(pdTopViewOffset * elY);
			ar_pt_BPsectionView.append(pt_this);
			pt_this.transformBy(csVpElevation);
			pt_this.transformBy(0.5 * dCharL * (n == 0 ? - 1 : 1) * paperX);
			LineSeg ls_base(pt_this, pt_this + 2 * dCharL * vc_move);
			dpS.draw(ls_base);
			LineSeg ls_arrow(ls_base.ptMid(), ls_base.ptMid() - 1.75 * dCharL * vc_arrow);
			dpS.draw(ls_arrow);
			LineSeg ls_arrow1(ls_base.ptMid(), ls_base.ptMid() - 1 * dCharL * vc_arrow + 0.25 * dCharL * vc_move);
			dpS.draw(ls_arrow1);
			LineSeg ls_arrow2(ls_base.ptMid(), ls_base.ptMid() - 1 * dCharL * vc_arrow - 0.25 * dCharL * vc_move);
			dpS.draw(ls_arrow2);
		}

	}
	Point3d& ptBPleftmost = ar_pt_BP[0];
	Point3d& ptBPrightmost = ar_pt_BP[1];
	//---------------
	//--------------- <GET ALL BOTTOM PLATES> --- end
	//endregion

	//region DRAW HATCHES, GET BLOCKING AND VT BEAMS POSITIONS(FRONT, BACK, CENTER)
	//--------------- <DRAW HATCHES, GET BLOCKING AND VT BEAMS POSITIONS(FRONT, BACK, CENTER)> --- start
	//---------------

	Beam ar_bm_blockingFront[0], ar_bm_blockingBack[0], ar_bm_CUfront[0], ar_bm_CUback[0], ar_bm_TPcenter[0], ar_bm_TPfront[0], ar_bm_TPback[0], ar_bm_BPcenter[0], ar_bm_BPfront[0], ar_bm_BPback[0];
	{
		PlaneProfile ar_pp_blocking[2], ar_pp_check[2], pp_shadow;
		Beam ar_bm_plates[0];
		ar_bm_plates.append(ar_bm_BP);
		ar_bm_plates.append(ar_bm_TP);
		Plane plane_LeftSide(el.ptOrg(), elX);
		Point3d ar_pt_platesIn[0], ar_pt_platesUp[0];
		for (int n; n<ar_bm_plates.length(); ++n)
		{
			ar_pt_platesIn.append(plane_LeftSide.projectPoints(ar_bm_plates[n].realBody().extremeVertices(vcInside)));
			ar_pt_platesUp.append(plane_LeftSide.projectPoints(ar_bm_plates[n].realBody().extremeVertices(elY)));
		}
		ar_pt_platesIn = Line(el.ptOrg(), vcInside).orderPoints(ar_pt_platesIn);
		ar_pt_platesUp = Line(el.ptOrg(), elY).orderPoints(ar_pt_platesUp);

		ar_pp_check[0].createRectangle(LineSeg(Line(ar_pt_platesUp.first(), vcInside).closestPointTo(ar_pt_platesIn.first())
		, Line(ar_pt_platesUp.last(), vcInside).closestPointTo(ar_pt_platesIn.first() + U(0.5) * vcInside)), elY, vcInside);
		ar_pp_check[1].createRectangle(LineSeg(Line(ar_pt_platesUp.first(), vcInside).closestPointTo(ar_pt_platesIn.last())
		, Line(ar_pt_platesUp.last(), vcInside).closestPointTo(ar_pt_platesIn.last() - U(0.5) * vcInside)), elY, vcInside);

		Hatch ar_hatchFB[2];
		//DRAW HATCHING LEGEND
		{
			double dTextH = dpS.textHeightForStyle("(^!`_)", stDimStyle);
			dpS.textHeight(dTextH * pdHatchLegendScale);
			double dMemory[] = { dRowH, dCharL};
			dRowH *= pdHatchLegendScale;
			dCharL *= pdHatchLegendScale;

			Point3d pt_legendOrigin = _Map.getPoint3d("pntLegend");
			String ar_st_legend[] = { "- front face", "- back face"};
			double d_recH = dRowH + dCharL;
			double d_legendH = d_recH + dCharL;

			pt_legendOrigin += 2.5 * d_legendH * paperY;
			PlaneProfile pp_rec;
			pp_rec.createRectangle(LineSeg(pt_legendOrigin - 0.5 * d_recH * paperY, pt_legendOrigin + 0.5 * d_recH * paperY + 2 * d_recH * paperX), paperX, paperY);
			dpS.draw(pp_rec);
			dpS.color(253);
			Hatch hatch_front(psFrontHatch, pdFrontScale);
			hatch_front.setAngle(pdFrontAngle);
			dpS.draw(pp_rec, hatch_front);
			ar_hatchFB[0] = Hatch(psFrontHatch, pdFrontScale * dScaleElevation);
			ar_hatchFB[0].setAngle(pdFrontAngle);
			dpS.color(-1);
			dpS.draw(ar_st_legend[0], pt_legendOrigin + (2 * d_recH + dCharL) * paperX, paperX, paperY, 1, 0);
			dpS.draw("BA", pp_rec.extentInDir(paperX).ptMid(), paperX, paperY, 0, 0);

			pt_legendOrigin -= 1.5 * d_legendH * paperY;
			pp_rec.transformBy(-1.5 * d_legendH * paperY);
			dpS.draw(pp_rec);
			dpS.color(253);
			Hatch hatch_back(psBackHatch, pdBackScale);
			hatch_back.setAngle(pdBackAngle);
			dpS.draw(pp_rec, hatch_back);
			ar_hatchFB[1] = Hatch(psBackHatch, pdBackScale * dScaleElevation);
			ar_hatchFB[1].setAngle(pdBackAngle);
			dpS.color(-1);
			dpS.draw(ar_st_legend[1], pt_legendOrigin + (2 * d_recH + dCharL) * paperX, paperX, paperY, 1, 0);
			dpS.dimStyle(st_dimStyleItalic);
			dpS.textHeight(dTextH * pdHatchLegendScale);
			dpS.draw("BA", pp_rec.extentInDir(paperX).ptMid(), paperX, paperY, 0, 0);
			dpS.dimStyle(stDimStyle);

			dpS.textHeight(dTextH);
			dRowH = dMemory[0];
			dCharL = dMemory[1];
		}




		int ar_b_blockingFound[3];
		for (int n; n<ar_bm_blocking.length(); ++n)
		{
			Beam bm_n = ar_bm_blocking[n];
			if (bm_n.vecX().isPerpendicularTo(elX)) continue;
			PlaneProfile pp_left = bm_n.envelopeBody().shadowProfile(plane_LeftSide);
			int i_intersect[] = { PlaneProfile(pp_left).intersectWith(ar_pp_check[0]), PlaneProfile(pp_left).intersectWith(ar_pp_check[1])};
			if (i_intersect[0] && i_intersect[1]) continue;
			for (int m; m<i_intersect.length(); ++m)
			{
				if (i_intersect[m])
				{
					Body bd_n = bm_n.envelopeBody();
					PlaneProfile pp_n = bd_n.shadowProfile(plFrontFace);

					if (ar_b_blockingFound[m]) ar_pp_blocking[m].unionWith(pp_n);
					else
					{
						ar_pp_blocking[m] = pp_n;
						ar_b_blockingFound[m] = true;
					}
					(m == 0 ? ar_bm_blockingFront : ar_bm_blockingBack).append(bm_n);
				}
			}
		}
		int ar_i_color[] = { 2, 4};
		for (int n; n<ar_pp_blocking.length(); ++n)
		{
			if (ar_b_blockingFound[n])
			{
				dpS.color(253);
				ar_pp_blocking[n].transformBy(csVpElevation);
				dpS.draw(ar_pp_blocking[n], ar_hatchFB[n]);
				dpS.color(ar_i_color[n]);
				dpS.draw(ar_pp_blocking[n]);
				dpS.color(-1);
			}
		}
		if (ar_b_blockingFound[2])
		{
			pp_shadow.transformBy(csVpElevation);
			dpS.color(piColor);
			dpS.draw(pp_shadow, _kDrawFilled);
			dpS.color(-1);
		}

		Beam ar_bm_VT[] = el.vecX().filterBeamsPerpendicularSort(bmAll);
		int ar_b_CUfound[3];
		PlaneProfile ar_pp_CU[2];
		for (int n; n<ar_bm_VT.length(); ++n)
		{
			Beam bm_n = ar_bm_VT[n];
			PlaneProfile pp_left = bm_n.envelopeBody().shadowProfile(plane_LeftSide);
			int i_intersect[] = { PlaneProfile(pp_left).intersectWith(ar_pp_check[0]), PlaneProfile(pp_left).intersectWith(ar_pp_check[1])};
			Body bd_n = bm_n.envelopeBody();
			PlaneProfile pp_n = bd_n.shadowProfile(plFrontFace);
			PlaneProfile pp_grown(pp_n);
			pp_grown.shrink(-1*String("1/16").atof(_kLength));
			int b_intersectTB[] = { PlaneProfile(pp_TPall).intersectWith(pp_grown), PlaneProfile(pp_BPall).intersectWith(pp_grown)};
			if ((i_intersect[0] && i_intersect[1]) || (!i_intersect[0] && !i_intersect[1]))
			{
				if (b_intersectTB[0]) ar_bm_TPcenter.append(bm_n);
				if (b_intersectTB[1]) ar_bm_BPcenter.append(bm_n);
				continue;
			}
			for (int m; m<i_intersect.length(); ++m)
			{
				if (i_intersect[m])
				{
					if (ar_b_CUfound[m]) ar_pp_CU[m].unionWith(pp_n);
					else
					{
						ar_pp_CU[m] = pp_n;
						ar_b_CUfound[m] = true;
					}
					(m == 0 ? ar_bm_CUfront : ar_bm_CUback).append(bm_n);
					if (b_intersectTB[0]) (m == 0 ? ar_bm_TPfront : ar_bm_TPback).append(bm_n);
					if (b_intersectTB[1]) (m == 0 ? ar_bm_BPfront : ar_bm_BPback).append(bm_n);
				}
			}
		}
		for (int n; n<ar_pp_CU.length(); ++n)
		{
			if (ar_b_CUfound[n])
			{
				dpS.color(253);
				ar_pp_CU[n].transformBy(csVpElevation);
				dpS.draw(ar_pp_CU[n], ar_hatchFB[n]);
			}
			dpS.color(-1);
		}
	}

	//---------------
	//--------------- <DRAW HATCHES, GET BLOCKING AND VT BEAMS POSITIONS(FRONT, BACK, CENTER)> --- end
	//endregion

	//region SORT BEAMS ALPHABETICALY AND FILL INFO ARRAY
	//--------------- <SORT BEAMS ALPHABETICALY AND FILL INFO ARRAY> --- start
	//---------------
	String ar_st_beamInfoAll[0];
	{
		String ar_st_beamInfo[0], ar_st_blockingInfo[0];
		for (int n; n<bmAll.length(); ++n)
		{
			//region TYPES
			//--------------- <TYPES> --- start
			//---------------

			Beam bm_this = bmAll[n];
			int i_typeThis = bm_this.type();
			String st_typeThis = _BeamTypes[i_typeThis];
			if (st_typeThis.find("SF ", 0) >- 1) st_typeThis = st_typeThis.right(st_typeThis.length()-3);
			if (st_typeThis == "Left stud" || st_typeThis == "Right stud") st_typeThis = "Stud";
			if (st_typeThis.find("Cripple", 0) >- 1) st_typeThis = "Cripple";
			if (st_typeThis == "Jack over opening" || st_typeThis == "Jack under opening") st_typeThis = "Cripple";
			if (bm_this.hsbId().find("MASA", 0) >- 1) st_typeThis = "MASA " + st_typeThis;
			if (ar_bm_VTP.find(bm_this) >- 1) st_typeThis = "VTP";
			if (ar_bm_VBP.find(bm_this) >- 1) st_typeThis = "VBP";
			int b_isFiller = iFillerTypes.find(i_typeThis) >- 1;
			for (int j; j<arFillerGrades.length(); ++j)
			{
				if (bm_this.grade().find(arFillerGrades[j], 0, false)>-1
				|| bm_this.material().find(arFillerGrades[j], 0, false)>-1
				|| bm_this.name().find(arFillerGrades[j], 0, false)>-1) b_isFiller = true;
			}
			if (b_isFiller) st_typeThis = "Filler";

			double d_typeLength = dpS.textLengthForStyle(st_typeThis, stDimStyle);
			if (d_typeLength > dCheckType) dCheckType = d_typeLength;

			String st_info = st_typeThis;

			//---------------
			//--------------- <TYPES> --- end
			//endregion

			//region SIZES
			//--------------- <SIZES> --- start
			//---------------

			double ar_d_beamSizes[] = { bm_this.dW(), bm_this.dH()};
			if (ar_d_beamSizes[0] > ar_d_beamSizes[1]) ar_d_beamSizes.swap(0, 1);
			int b_isActualSize = false;
			for (int j; j<arActualSizeGrades.length(); ++j)
			{
				if (bm_this.grade().find(arActualSizeGrades[j], 0 , false)>-1
				|| bm_this.material().find(arActualSizeGrades[j], 0 , false)>-1
				|| bm_this.name().find(arActualSizeGrades[j], 0 , false)>-1) b_isActualSize = true;
			}
			if (b_isFiller) b_isActualSize = true;
			if (!b_isActualSize)
			{
				if (ceil(ar_d_beamSizes[0]) - ar_d_beamSizes[0] > 0) ar_d_beamSizes[0] = ceil(ar_d_beamSizes[0]);
				if (ceil(ar_d_beamSizes[1]) - ar_d_beamSizes[1] > 0) ar_d_beamSizes[1] = ceil(ar_d_beamSizes[1]);
			}
			String st_sizeThis = ar_d_beamSizes[0] + "x" + ar_d_beamSizes[1]+" "+bm_this.grade();
			if (b_isActualSize) st_sizeThis = String().formatUnit(ar_d_beamSizes[0], stDimStyle) + "x" + String().formatUnit(ar_d_beamSizes[1], stDimStyle) + " " + bm_this.grade();

			double d_sizeLength = dpS.textLengthForStyle(st_sizeThis, stDimStyle);
			if (d_sizeLength > dCheckSize) dCheckSize = d_sizeLength;

			st_info += "@" + st_sizeThis;

			//---------------
			//--------------- <SIZES> --- end
			//endregion
			st_info += "@" + (userUsePosnum == sYes ? bm_this.posnum() : "");
			//region LENGTH
			//--------------- <LENGTH> --- start
			//---------------

			String st_lengthThis = String().formatUnit(bm_this.solidLength(), stDimStyle);
			double d_lengthThis = dpS.textLengthForStyle(st_lengthThis, stDimStyle);
			if (d_lengthThis > dCheckLength) dCheckLength = d_lengthThis;

			st_info += "@" + st_lengthThis;

			//---------------
			//--------------- <LENGTH> --- end
			//endregion

			st_info += "$" + n;
			if (ar_bm_blocking.find(bm_this) >- 1) ar_st_blockingInfo.append(st_info);
			else ar_st_beamInfo.append(st_info);
		}

		Beam ar_bm_alphaSorted[0];
		String ar_st_blockingInfoSorted[] = ar_st_blockingInfo.sorted();
		for (int n=ar_st_blockingInfoSorted.length()-1; n>-1; --n)
		{
			String ar_st_tokenizedThis[] = ar_st_blockingInfoSorted[n].tokenize("$");
			ar_st_beamInfoAll.append(ar_st_tokenizedThis[0]);
			ar_bm_alphaSorted.append(bmAll[ar_st_tokenizedThis[1].atoi()]);
		}
		String ar_st_beamInfoSorted[] = ar_st_beamInfo.sorted();
		for (int n=ar_st_beamInfoSorted.length()-1; n>-1; --n)
		{
			String ar_st_tokenizedThis[] = ar_st_beamInfoSorted[n].tokenize("$");
			ar_st_beamInfoAll.append(ar_st_tokenizedThis[0]);
			ar_bm_alphaSorted.append(bmAll[ar_st_tokenizedThis[1].atoi()]);
		}
		bmAll.setLength(0);
		bmAll.append(ar_bm_alphaSorted);
	}


	//---------------
	//--------------- <SORT BEAMS ALPHABETICALY AND FILL INFO ARRAY> --- end
	//endregion

	//region STUFF TO USE LATER
	//--------------- <STUFF TO USE LATER> --- start
	//---------------

	String stCutListHeader = "Framing Cut List";
	double dLabelLength = dpS.textLengthForStyle("Lab.", stDimStyle);
	double dQtyLength = dpS.textLengthForStyle("Qty", stDimStyle);
	double dPosNumLength = 4 * dCharL;

	Beam bmOverOpening[0];
	Plane plBottomWall(ptBPleftmost, elY);
	Point3d ptOpeningDim[0];
	ptOpeningDim.append(plFrontFace.closestPointTo(ptBPleftmost));

	//---------------
	//--------------- <STUFF TO USE LATER> --- end
	//endregion

//---------------
//--------------- <FRAMING PART 1> --- end
//endregion


//region GET PLANEPROFILES OF VIEW FOR OVERLAPING DETECTION
//--------------- <GET PLANEPROFILES OF VIEW FOR OVERLAPING DETECTION> --- start
//---------------

PlaneProfile pp_elevationAll, pp_topAll, pp_bottomAll;
{
	GenBeam ar_gb_all[] = el.genBeam();
	for (int n; n<ar_gb_all.length(); ++n)
	{
		GenBeam gb_this = ar_gb_all[n];
		PlaneProfile pp_front = gb_this.realBody().shadowProfile(plFrontFace);
		PlaneProfile pp_bott = gb_this.realBody().shadowProfile(plBottomWall);
		if (n==0)
		{
			pp_elevationAll = pp_front;
			pp_bottomAll = pp_bott;
		}
		else
		{
			pp_elevationAll.unionWith(pp_front);
			pp_bottomAll.unionWith(pp_bott);
		}
	}
	pp_topAll = pp_bottomAll;
	pp_elevationAll.transformBy(csVpElevation);
	pp_topAll.transformBy(csVpTop);
	pp_bottomAll.transformBy(csVpBottom);
}

//---------------
//--------------- <GET PLANEPROFILES OF VIEW FOR OVERLAPING DETECTION> --- end
//endregion


//region OPENINGS
//--------------- <OPENINGS> --- start
//---------------

	//region SET GRIP POINT FOR OPENING TAGS
	//--------------- <SET GRIP POINT FOR OPENING TAGS> --- start
	//---------------

	Point3d ptVpElevationTopLeft = vpElevation.ptCenPS() - 0.5 * vpElevation.widthPS()*paperX + 0.5 * vpElevation.heightPS() * paperY;
	if (!b_overrideGrips[0] && !b_memoryGrip[0])
	{
		_PtG[0] = ptVpElevationTopLeft;
		if ((ar_pt_BP.last()-ar_pt_BP.first()).dotProduct(elX)>12*17)
		{
			_PtG[0] = Line(_Pt0+2.5*dCharL*paperX, paperY).closestPointTo(ptVpElevationTopLeft);
		}
	}

	//---------------
	//--------------- <SET GRIP POINT FOR OPENING TAGS> --- end
	//endregion

	//region GET OPENING INFO FROM ENTITY AND TSL
	//--------------- <GET OPENING INFO FROM ENTITY AND TSL> --- start
	//---------------

	Point3d ptOpTagCorner = _PtG[0];
	Opening arOp[] = el.opening();
	if (arOp.length()>1)
	{
		Opening opTemp[0];
		opTemp.append(arOp);
		String arTemp[0];
		for (int i=0; i<opTemp.length(); i++)
		{
			CoordSys csOp = opTemp[i].coordSys();
			Point3d ptCen = PlaneProfile(opTemp[i].plShape()).extentInDir(elX).ptMid();
			double dXY[] ={(ptCen-(_PtW-U(5000)*el.vecX())).dotProduct(el.vecX()) ,(ptCen-el.ptOrg()).dotProduct(el.vecY())};
			arTemp.append(String(ceil(abs(dXY[0])) + "@" + ceil(5000 - dXY[1]) + "@" + i ));
		}
		String arTempSorted[] = arTemp.sorted();
		arOp.setLength(0);
		for (int i = 0; i < arTempSorted.length(); i++) arOp.append(opTemp[arTempSorted[i].token(2, "@").atoi()]);
	}
	Entity entXref = el.blockRef();
	BlockRef bkXref = (BlockRef) entXref;
	String stXrefDefinition = bkXref.definition();
	TslInst arTSL[] = el.tslInst();
	arTSL.append(el.tslInstAttached());
	TslInst arTslWindowKpn[0];
	if (arOp.length() > 0)
	{
		if (stXrefDefinition != "" && bkXref.bIsValid())
		{
			Group gpEl("Window_KPNs", stXrefDefinition, el.elementGroup().namePart(2));
			Entity entWKPN[] = gpEl.collectEntities(TRUE, TslInst(), _kModelSpace);
			for (int i = 0; i < entWKPN.length(); i++)
			{
				TslInst tsl = (TslInst) entWKPN[i];
				if (tsl.bIsValid()) arTslWindowKpn.append(tsl);
			}
		}
		else
		{
			for (int i = 0; i < arTSL.length(); i++)
			{
				TslInst tsl = arTSL[i];
				if (tsl.scriptName() == "KT_PRJ_ASSIGN_WINDOW_KPN") arTslWindowKpn.append(tsl);
			}
		}
	}

	//---------------
	//--------------- <GET OPENING INFO FROM ENTITY AND TSL> --- end
	//endregion

	//region DRAW OPENING TAGS, GET POINTS FOR DIMENSIONS
	//--------------- <DRAW OPENING TAGS, GET POINTS FOR DIMENSIONS> --- start
	//---------------

	Beam bmTrimmers[0], bmCripples[0];
	for (int i=0;i<arOp.length();i++)
	{
		Opening op = arOp[i];
		op.plShape().vis(1);
		CoordSys csOp = op.coordSys();
		double opRoughWidth = op.widthRough();
		double opRoughHeight = op.heightRough();
		PlaneProfile ppOp(op.plShape());
		Point3d ptSortBeams = Plane(ptElCen, elZ).closestPointTo(ppOp.extentInDir(elX).ptMid());
		Beam BeamsUnder[] = Beam().filterBeamsHalfLineIntersectSort(bmHz, ptSortBeams, - elY);
		BeamsUnder.append(Beam().filterBeamsHalfLineIntersectSort(bmHz, ptSortBeams + (0.5 * el.dBeamWidth() - U(0.5)) * el.vecZ(), - elY));
		BeamsUnder.append(Beam().filterBeamsHalfLineIntersectSort(bmHz, ptSortBeams - (0.5 * el.dBeamWidth() - U(0.5)) * el.vecZ(), - elY));
		Vector3d minusY = - elY;
		BeamsUnder = minusY.filterBeamsPerpendicularSort(BeamsUnder);
		Point3d ptUnder = plFrontFace.closestPointTo(BeamsUnder[0].ptCen()) + 0.5 * BeamsUnder[0].dD(elY) * elY; ptUnder.vis(230);
		Point3d ptLow = plFrontFace.closestPointTo(ptBPleftmost); ptLow.vis(230);
		Plane plOpOrg(csOp.ptOrg(), elX);
		double distUnder = abs((plOpOrg.closestPointTo(ptUnder) - plOpOrg.closestPointTo(ptLow)).length());
		double opSillHeight = distUnder;
		if (opSillHeight < U(3.01)) opSillHeight = 0;
		Beam BeamsOver[] = Beam().filterBeamsHalfLineIntersectSort(bmHz, ptSortBeams, elY);
		BeamsOver.append(Beam().filterBeamsHalfLineIntersectSort(bmHz, ptSortBeams + (0.5 * el.dBeamWidth() - U(0.5)) * el.vecZ(), elY));
		BeamsOver.append(Beam().filterBeamsHalfLineIntersectSort(bmHz, ptSortBeams - (0.5 * el.dBeamWidth() - U(0.5)) * el.vecZ(), elY));
		//BeamsOver = elY.filterBeamsPerpendicularSort(BeamsOver);
		if (BeamsOver.length() > 1)
		{
			for (int m = 1; m < BeamsOver.length(); m++)
			{
				Point3d ptbm = BeamsOver[m].ptCen();
				Point3d ptbmMinus = BeamsOver[m - 1].ptCen();
				double diff = (ptbm - ptbmMinus).dotProduct(elX);
				if (diff < U(0.25))
				{
					Beam bmPlus[] = Beam().filterBeamsHalfLineIntersectSort(bmHz, plFrontFace.closestPointTo(ptbm), - elZ);
					for (int n = 0; n < bmPlus.length(); n++)
					{
						Beam bmNew = bmPlus[n];
						if (BeamsOver.find(bmNew) == -1) BeamsOver.append(bmNew);
					}
				}
			}
		}
		PlaneProfile ppOver;
		if (BeamsOver.length()>0)
		{
			if (opSillHeight == 0)
				opRoughHeight = (BeamsOver[0].ptCen() - ptBPleftmost).dotProduct(elY) - 0.5 * BeamsOver[0].dD(elY);
			else if (BeamsUnder.length() > 0)
				opRoughHeight = (BeamsOver[0].ptCen() - BeamsUnder[0].ptCen()).dotProduct(elY) - 0.5 * (BeamsOver[0].dD(elY) + BeamsUnder[0].dD(elY));

			bmOverOpening.append(BeamsOver);
			Beam bmHeadersX[0];
			for (int k=0; k<BeamsOver.length(); k++)
				if (arSillTypes.find(BeamsOver[k].type())<0 && arTopPlatesTypes.find(BeamsOver[k].type())<0)
					bmHeadersX.append(BeamsOver[k]);

			if (bmHeadersX.length()>0)
			{
				ppOver = bmHeadersX.first().envelopeBody().extractContactFaceInPlane(Plane(bmHeadersX.first().ptCen(), elZ), 1.1 * 0.5 * bmHeadersX.first().dD(elZ));
				if (bmHeadersX.length()>1) {
					for (int k=1; k<bmHeadersX.length(); k++) {
						ppOver.unionWith(bmHeadersX[k].envelopeBody().extractContactFaceInPlane(Plane(bmHeadersX[k].envelopeBody().ptCen(), elZ), 1.1*0.5*bmHeadersX[k].dD(elZ)));
					}
					ppOver.shrink(-U(0.25));
					ppOver.shrink(U(0.25));
				}
			}
		}
		Beam BeamsSideLeft[] = Beam().filterBeamsHalfLineIntersectSort(bmVt, ptSortBeams, -elX);
		BeamsSideLeft.append(Beam().filterBeamsHalfLineIntersectSort(bmVt, ptSortBeams + (0.5 * el.dBeamWidth() - U(0.5)) * el.vecZ(), - elX));
		BeamsSideLeft.append(Beam().filterBeamsHalfLineIntersectSort(bmVt, ptSortBeams - (0.5 * el.dBeamWidth() - U(0.5)) * el.vecZ(), - elX));
		Vector3d minusX = -elX;
		BeamsSideLeft = minusX.filterBeamsPerpendicularSort(BeamsSideLeft);
		Beam BeamsSideRight[] = Beam().filterBeamsHalfLineIntersectSort(bmVt, ptSortBeams, elX);
		BeamsSideRight.append(Beam().filterBeamsHalfLineIntersectSort(bmVt, ptSortBeams + (0.5 * el.dBeamWidth() - U(0.5)) * el.vecZ(), elX));
		BeamsSideRight.append(Beam().filterBeamsHalfLineIntersectSort(bmVt, ptSortBeams - (0.5 * el.dBeamWidth() - U(0.5)) * el.vecZ(), elX));
		BeamsSideRight = elX.filterBeamsPerpendicularSort(BeamsSideRight);
		Point3d ptOpeningOrg = plBottomWall.closestPointTo(csOp.ptOrg());
		if (BeamsSideLeft.length() > 0 && BeamsSideRight.length() > 0) {
			opRoughWidth = (BeamsSideRight[0].ptCen() - BeamsSideLeft[0].ptCen()).dotProduct(elX) - 0.5 * (BeamsSideLeft[0].dD(elX) + BeamsSideRight[0].dD(elX));
			ptOpeningOrg = plBottomWall.closestPointTo(BeamsSideLeft[0].ptCen() + 0.5 * BeamsSideLeft[0].dD(elX) * elX);
			if (ppOver.area()>0) {
				for (int k=0; k<BeamsSideLeft.length(); k++)
					if( (BeamsSideLeft[k].ptCen()-ppOver.extentInDir(elX).ptStart()).dotProduct(elX)*(BeamsSideLeft[k].ptCen()-ppOver.extentInDir(elX).ptEnd()).dotProduct(elX) <0)
						bmTrimmers.append(BeamsSideLeft[k]);
				for (int k=0; k<BeamsSideRight.length(); k++)
					if( (BeamsSideRight[k].ptCen()-ppOver.extentInDir(elX).ptStart()).dotProduct(elX)*(BeamsSideRight[k].ptCen()-ppOver.extentInDir(elX).ptEnd()).dotProduct(elX) <0)
						bmTrimmers.append(BeamsSideRight[k]);
				for (int k=0; k<bmVt.length(); k++)
					if (bmTrimmers.find(bmVt[k])<0 && (bmVt[k].ptCen()-ppOver.extentInDir(elX).ptStart()).dotProduct(elX)*(bmVt[k].ptCen()-ppOver.extentInDir(elX).ptEnd()).dotProduct(elX) <0)
						bmCripples.append(bmVt[k]);
			}
		}
		Point3d ptOver = plFrontFace.closestPointTo(BeamsOver[0].ptCen() - 0.5 * BeamsOver[0].dD(elY) * elY);
		double distOver = abs((plOpOrg.closestPointTo(ptOver) - plOpOrg.closestPointTo(ptLow)).length());
		double opHeadHight = distOver;
		opRoughHeight = opHeadHight - opSillHeight;
		ptOpeningDim.append(plFrontFace.closestPointTo(ptSortBeams-0.5*opRoughWidth*elX));
		ptOpeningDim.append(plFrontFace.closestPointTo(ptSortBeams+0.5*opRoughWidth*elX));
		
		String stTagLabel;
		if (psOpeningLabelFormat != "") {
			String formats[] = String(psOpeningLabelFormat).tokenize(",");
			for (int k=0; k<formats.length(); k++) {
				String stFormat = formats[k];
				String stValue = op.formatObject(stFormat);
				if (stValue != stFormat) {
					stTagLabel = stValue;
					break;
				}
			}
			if (stTagLabel == "") stTagLabel = "N/A";
		}
		else stTagLabel = arAlphabet[i];
		
		Point3d ptTagCen = ptSortBeams;
		ptTagCen.transformBy(csVpElevation);
		if (psShowFullTagAtOpening==sYes)
			ptOpTagCorner = ptTagCen;
		Point3d ptFirst = ptTagCen + 2.25*dCharL * paperX;
		PLine plTag;
		plTag.addVertex(ptFirst);
		CoordSys csRotate;
		csRotate.setToRotation(-60, _ZW, ptTagCen);
		ptFirst.transformBy(csRotate);
		plTag.addVertex(ptFirst);
		ptFirst.transformBy(csRotate);
		plTag.addVertex(ptFirst);
		ptFirst.transformBy(csRotate);
		plTag.addVertex(ptFirst);
		ptFirst.transformBy(csRotate);
		plTag.addVertex(ptFirst);
		ptFirst.transformBy(csRotate);
		plTag.addVertex(ptFirst);
		plTag.close();
		dpS.draw(plTag);
		dpS.draw(stTagLabel, ptTagCen, paperX, paperY, 0, 0);
		if (psShowFullTagAtOpening==sNo) {
			Vector3d vcCopyTag = ptOpTagCorner - ptTagCen;
			PLine plTagCopy = plTag;
			plTagCopy.transformBy(vcCopyTag);
			dpS.draw(plTagCopy);
			dpS.draw(stTagLabel, ptOpTagCorner, paperX, paperY, 0, 0);
		}
		Point3d ptTextOp = ptOpTagCorner + 3 * dCharL * paperX;
		String stRO = "RO: " + String().formatUnit(opRoughWidth, stDimStyle) + "x" + String().formatUnit(opRoughHeight, stDimStyle);
		if (psShowFullTagAtOpening==sYes)
			ptTextOp = ptOpTagCorner - paperX * dpS.textLengthForStyle(stRO, stDimStyle) / 2 - paperY * 4 * dCharL;
		dpS.draw(stRO, ptTextOp, paperX, paperY, 1, 1);
		ptTextOp -= 1.5 *dRowH * paperY;
		dpS.draw("Head: " + String().formatUnit(opHeadHight, stDimStyle), ptTextOp, paperX, paperY, 1, 1);
		ptTextOp -= 1.5 * dRowH * paperY;
		dpS.draw("Sill: " + String().formatUnit(opSillHeight, stDimStyle), ptTextOp, paperX, paperY, 1, 1);
		ptTextOp -= 1.5 * dRowH * paperY;
		String stKPN, stWeight;
		if (arTslWindowKpn.length() > 0)
		{
			for (int j=0; j<arTslWindowKpn.length(); j++)
			{
				Entity entWindow[] = arTslWindowKpn[j].entity();
				Opening opJ = (Opening) entWindow[0];
				if (opJ == op)
				{
					Map mpJ = arTslWindowKpn[j].map();
					String stAssign = mpJ.getString("stWindowKpn");
					stKPN = "Assembly # " + stAssign;
					int iShopInstalled = mpJ.getInt("iShopInstalled");
					if (iShopInstalled == FALSE) stKPN += " - FIELD INSTALLED";
					else
					{
						double dWeight = mpJ.getDouble("dWeight");
						if (dWeight) stWeight = "Weight: "+String().format("%.2f", dWeight) + " lbs";
					}
				}
			}
		}
		else
		{
			stKPN = "Assembly # " + op.description();
			Map mpInstall = op.subMapX("mpInstall");
			if (mpInstall.hasInt("ShopInstalled"))
			{
				if (mpInstall.getInt("ShopInstalled") == FALSE) stKPN += " - FIELD INSTALLED";
			}
		}
		if (psShowKPN == sYes)
			dpS.draw(stKPN, ptTextOp, paperX, paperY, 1, 1);
		double dTotalMove = 6.75;
		if (stWeight != "")
		{
			if (psShowKPN == sYes)
				ptTextOp -= 1.5 * dRowH * paperY;
			dpS.draw(stWeight, ptTextOp, paperX, paperY, 1, 1);
			dTotalMove += 2.25;
		}
		ptOpTagCorner -= dTotalMove*dRowH * paperY;

	}
	ptOpeningDim.append(plFrontFace.closestPointTo(ptBPrightmost));

	//---------------
	//--------------- <DRAW OPENING TAGS, GET POINTS FOR DIMENSIONS> --- end
	//endregion

//---------------
//--------------- <OPENINGS> --- end
//endregion


//region FRAMING PART 2
//--------------- <FRAMING PART 2> --- start
//---------------

	//region PREPARE BEAM INFO FOR SCHEDULE, DRAW OR STORE LABELS, DRAW BEAMS IN VIEWS
	//--------------- <PREPARE BEAM INFO FOR SCHEDULE, DRAW OR STORE LABELS, DRAW BEAMS IN VIEWS> --- start
	//---------------

	Point3d arptBlockingDim[0];
	int iDrawAngleHatch = _HatchPatterns.find("ANSI31");
	PlaneProfile ppWall = el.profBrutto(0);
	Beam bmTemp[0], bmCrippleDimTop[0], bmCrippleDimBot[0];
	bmTemp.append(bmAll);
	int bmQty = bmTemp.length() - 1;
	int iLabel = -1;
	int iOverAlphabet = -1;
	int iExcedsLimits = 1;
	String arStDrawExcedsLimits[0], ar_st_drawCutListMain[0], arStVertlabelsElevation[0], arStVertlabelsTop[0], ar_st_beamHandles[0], ar_st_beamLabels[0];
	Point3d arPtVertLabelsElevation[0], arPtVertLabelsTop[0];
	double dBlockListLength[2];
	Map mp_elementContent;
	Beam bmDrawnBottom[0], bmDrawnTop[0];
	while (bmQty>-1)
	{
		iLabel++;
		Beam bm = bmTemp[bmQty];
		bmTemp.removeAt(bmQty);
		String stCombined = ar_st_beamInfoAll[bmQty];
		ar_st_beamInfoAll.removeAt(bmQty);
		String stDispType = stCombined.token(0, "@");
		String stDispSize = stCombined.token(1, "@");
		String stDispPosNum = userUsePosnum == sYes ? stCombined.token(2, "@") : bm.posnum();
		String stDispLength = stCombined.token(3, "@");
		Map mp_beamOverride;
		mp_beamOverride.setString("Type", stDispType);
		mp_beamOverride.setMapName("Override");

		int bIsFiller = iFillerTypes.find(bm.type()) < 0 ? false : true;
		for (int i=0; i<arFillerGrades.length(); i++) { if (stDispSize.find(arFillerGrades[i], 0)>-1) bIsFiller = true;}
		PlaneProfile ppBm = bm.envelopeBody().getSlice(Plane(bm.ptCen(), elZ));

		String stDispLabel;
		if (iLabel<arAlphabet.length()) stDispLabel= arAlphabet[iLabel];
		else
		{
			iOverAlphabet++;
			stDispLabel = arAlphabet[iOverAlphabet] + arAlphabet[arAlphabet.length() - (iOverAlphabet+1)];
		}
		ar_st_beamHandles.append(bm.handle());
		ar_st_beamLabels.append(stDispLabel);
		int bmToLabelHz = FALSE;
		double dBmZ = bm.dD(elZ);
		double dBmX = bm.dD(elX);
		if (bm.vecX().dotProduct(elY)==0) dBmX = bm.dL();
		LineSeg lsOutline(bm.ptCen() + 0.5 * dBmX * elX + 0.5 * dBmZ * elZ, bm.ptCen() - 0.5 * dBmX * elX - 0.5 * dBmZ * elZ);
		LineSeg lsOutline2(bm.ptCen() - 0.5 * dBmX * elX + 0.5 * dBmZ * elZ, bm.ptCen() + 0.5 * dBmX * elX - 0.5 * dBmZ * elZ);
		Point3d arPtBlockingLabels[0];
		String arStBlockingInfo[0], arStBlockingHeight[0];
		Beam ar_bm_blockingToLabel[0];
		if (bmHz.find(bm)>-1 && ar_bm_blocking.find(bm)==-1)
		{
			Point3d ptLabel = bm.ptCen();
			ptLabel = plFrontFace.closestPointTo(ptLabel);
			ptLabel.transformBy(csVpElevation);
			ptLabel +=  iLabelStagger[bmHz.find(bm)]* dCharL*paperX;
			dpS.draw(stDispLabel, ptLabel, paperX, paperY, 0, 0);
			bmToLabelHz = TRUE;
			if (ar_bm_BP.find(bm)>-1)
			{
				Body bdToDraw = bm.realBody();
				bdToDraw.transformBy(csVpBottom);
				PlaneProfile ppPlate = bdToDraw.shadowProfile(Plane(_Pt0, _ZW));
				dpS.draw(ppPlate);
			}
			else if (ar_bm_TP.find(bm)>-1)
			{
				Body bdToDraw = bm.realBody();
				bdToDraw.transformBy(csVpTop);
				PlaneProfile ppPlate = bdToDraw.shadowProfile(Plane(_Pt0, _ZW));
				dpS.draw(ppPlate);
			}
			else if (bmOverOpening.find(bm)>-1)
			{
				if (!bIsFiller)
				{
					LineSeg lsOutTop = lsOutline;
					if (dBmZ >= ar_bm_BP[0].dD(elZ)) { lsOutTop = lsOutline2;}
					lsOutTop.transformBy(csVpTop);
					PLine plOutline;
					plOutline.createRectangle(lsOutTop, paperX, paperY);
					dpTop.draw(plOutline);
				}
				else
				{
					LineSeg lsOutTop = lsOutline;
					if (abs(dBmZ-ar_bm_BP.first().dD(elZ)) < U(0.5)) { lsOutTop = lsOutline2;}
					lsOutTop.transformBy(csVpTop);
					PLine plOutline;
					plOutline.createRectangle(lsOutTop, paperX, paperY);
					dpTop.color(piColor);
					if (iDrawAngleHatch<0) {dpTop.draw(PlaneProfile(plOutline), _kDrawFilled);}
					else { dpTop.draw(PlaneProfile(plOutline), Hatch(_HatchPatterns[iDrawAngleHatch], 0.25));}
					dpTop.color(-1);
				}
			}
		}
		if (bmVt.find(bm)>-1)
		{
			ppWall.subtractProfile(ppBm);
			int b_touchingBottom = false;
			if (ar_bm_BPfront.find(bm)>-1 || ar_bm_BPback.find(bm)>-1 || ar_bm_BPcenter.find(bm)>-1)
			{
				b_touchingBottom = true;
				if (ar_bm_CUback.find(bm)<0 && ar_bm_CUfront.find(bm)<0)
				{
					arPtVertLabelsElevation.append(bm.ptCen());
					arStVertlabelsElevation.append(stDispLabel);
				}
				else
				{
					Beam bm_this = bm;
					PlaneProfile pp_this = bm_this.envelopeBody().shadowProfile(plFrontFace);
					Beam ar_bm_other[0];
					ar_bm_other.append(ar_bm_CUfront.find(bm_this) >- 1 ? ar_bm_CUback : ar_bm_CUfront);
					Point3d pt_labelDraw = bm_this.ptCen();
					pt_labelDraw.transformBy(csVpElevation);
					for (int y; y<ar_bm_other.length(); ++y)
					{
						Beam bm_other = ar_bm_other[y];
						PlaneProfile pp_other = bm_other.envelopeBody().shadowProfile(plFrontFace);
						if (PlaneProfile(pp_this).intersectWith(PlaneProfile(pp_other)) || pp_this.pointInProfile(bm_other.ptCen()) == _kPointInProfile)
						{
							int i_moveDirectionY = ar_bm_CUfront.find(bm_this) >- 1 ? 1 : - 1;
							LineSeg ls_between(plFrontFace.closestPointTo(bm_this.ptCen()), plFrontFace.closestPointTo(bm_other.ptCen()));
							ls_between.transformBy(csVpElevation);
							double d_between = (ls_between.ptStart() - ls_between.ptEnd()).dotProduct(paperX);
							if (abs(d_between) <= dCharL) pt_labelDraw = ls_between.ptMid() + 0.5 * (dRowH + 0.25 * dCharL) * paperY * i_moveDirectionY + 0.5 * dCharL * paperX * (sign(d_between) == 0 ? -i_moveDirectionY : sign(d_between));
							else pt_labelDraw += 0.5 * (dRowH + 0.25 * dCharL) * paperY * i_moveDirectionY;
							break;
						}
					}
					if (i_foundItalicStyle >- 1 && ar_bm_CUback.find(bm_this) >- 1) dpS.dimStyle(st_dimStyleItalic);
					dpS.draw(stDispLabel, pt_labelDraw, paperX, paperY, 0, 0);
					dpS.dimStyle(stDimStyle);
				}
				bmDrawnBottom.append(bm);
				LineSeg lsOutBottom = lsOutline;
				lsOutBottom.transformBy(csVpBottom);
				PLine plOutline;
				plOutline.createRectangle(lsOutBottom, paperX, paperY);
				dpBottom.draw(plOutline);
				dpBottom.color(1);
				dpBottom.draw(lsOutBottom);
				if (bmStuds.find(bm)>-1)
				{
					LineSeg lsOutBottom2 = lsOutline2;
					lsOutBottom2.transformBy(csVpBottom);
					dpBottom.draw(lsOutBottom2);
				}
				dpBottom.color(-1);
			}
			if (ar_bm_TPfront.find(bm)>-1 || ar_bm_TPback.find(bm)>-1 || ar_bm_TPcenter.find(bm)>-1)
			{
				arPtVertLabelsTop.append(bm.ptCen());
				arStVertlabelsTop.append(stDispLabel);
				if (!b_touchingBottom && (ar_bm_CUback.find(bm)>-1 || ar_bm_CUfront.find(bm)>-1))
				{
					Beam bm_this = bm;
					PlaneProfile pp_this = bm_this.envelopeBody().shadowProfile(plFrontFace);
					Beam ar_bm_other[0];
					ar_bm_other.append(ar_bm_CUfront.find(bm_this) >- 1 ? ar_bm_CUback : ar_bm_CUfront);
					Point3d pt_labelDraw = bm_this.ptCen();
					pt_labelDraw.transformBy(csVpElevation);
					for (int y; y<ar_bm_other.length(); ++y)
					{
						Beam bm_other = ar_bm_other[y];
						PlaneProfile pp_other = bm_other.envelopeBody().shadowProfile(plFrontFace);
						if (PlaneProfile(pp_this).intersectWith(PlaneProfile(pp_other)) || pp_this.pointInProfile(bm_other.ptCen()) == _kPointInProfile)
						{
							int i_moveDirectionY = ar_bm_CUfront.find(bm_this) >- 1 ? 1 : - 1;
							LineSeg ls_between(plFrontFace.closestPointTo(bm_this.ptCen()), plFrontFace.closestPointTo(bm_other.ptCen()));
							ls_between.transformBy(csVpElevation);
							double d_between = (ls_between.ptStart() - ls_between.ptEnd()).dotProduct(paperX);
							if (abs(d_between) <= dCharL) pt_labelDraw = ls_between.ptMid() + 0.5 * (dRowH + 0.25 * dCharL) * paperY * i_moveDirectionY + 0.5 * dCharL * paperX * (sign(d_between) == 0 ? -i_moveDirectionY : sign(d_between));
							else pt_labelDraw += 0.5 * (dRowH + 0.25 * dCharL) * paperY * i_moveDirectionY;
							break;
						}
					}
					if (i_foundItalicStyle >- 1 && ar_bm_CUback.find(bm_this) >- 1) dpS.dimStyle(st_dimStyleItalic);
					dpS.draw(stDispLabel, pt_labelDraw, paperX, paperY, 0, 0);
					dpS.dimStyle(stDimStyle);
				}
				bmDrawnTop.append(bm);
				LineSeg lsOutTop = lsOutline;
				lsOutTop.transformBy(csVpTop);
				PLine plOutline;
				plOutline.createRectangle(lsOutTop, paperX, paperY);
				dpTop.draw(plOutline);
				dpTop.color(1);
				dpTop.draw(lsOutTop);
				if (bmStuds.find(bm)>-1)
				{
					LineSeg lsOutTop2 = lsOutline2;
					lsOutTop2.transformBy(csVpTop);
					dpTop.draw(lsOutTop2);
				}
				dpTop.color(-1);
			}
			if (bmTrimmers.find(bm)>-1)
			{
				int bShow = psShowTrimmers == sYes ? true : false;
				for (int q=0; q<bmVt.length(); q++) { 
					if (bmVt.find(bm) != q && (bmVt[q].ptCen()-bm.ptCen()).dotProduct(elY)>0 && abs((bmVt[q].ptCen()-bm.ptCen()).dotProduct(elX))<U(0.2))
						bShow = false;
				}
				if (bShow)
				{
					bmDrawnTop.append(bm);
					arPtVertLabelsTop.append(bm.ptCen());
					arStVertlabelsTop.append(stDispLabel);
					LineSeg lsOut = lsOutline;
					lsOut.transformBy(csVpTop);
					PlaneProfile ppOutline;
					ppOutline.createRectangle(lsOut, paperX, paperY);
					dpTop.draw(ppOutline);
					dpTop.color(1);
					Point3d ptsPpX[] = Line(el.ptOrg(), elX).orderPoints(ppOutline.getGripEdgeMidPoints());
					Point3d ptsPpZ[] = Line(el.ptOrg(), elZ).orderPoints(ppOutline.getGripEdgeMidPoints());
					dpTop.draw(LineSeg(ptsPpX.first(), ptsPpX.last()));
					dpTop.draw(LineSeg(ptsPpZ.first(), ptsPpZ.last()));
					dpTop.color(-1);
				}
			}
			if (ar_bm_BPfront.find(bm)<0 && ar_bm_BPback.find(bm)<0 && ar_bm_BPcenter.find(bm)<0 && ar_bm_TPfront.find(bm)<0 && ar_bm_TPback.find(bm)<0 && ar_bm_TPcenter.find(bm)<0)
			{
				Point3d ptLabel = bm.ptCen();
				//reportMessage("\n " + bm + " not touching plates");
				ptLabel.transformBy(csVpElevation);
				dpElevation.draw(stDispLabel, ptLabel, paperX, paperY, 0, 0);
				int bShow = psShowNonTouching == sYes ? true : stDispType == "Cripple" ? true : bmCripples.find(bm)>-1 ? true : false;
				if (bShow)
				{
					CoordSys csChoice[] = { csVpBottom, csVpTop};
					Display dpChoice[] = { dpBottom, dpTop};
					int doChoice[] ={ true, true};
					double distToCen = (LineSeg(ptBPleftmost, ptTPrightmost).closestPointTo(LineSeg(ptBPrightmost, ptTPleftmost)) - bm.ptCen()).dotProduct(elY);
					if (abs(distToCen)>U(0.2))
					{
						doChoice[distToCen < 0 ? 0 : 1] = false;
					}
					for (int q=0; q<csChoice.length(); q++)
					{
						if ( ! doChoice[q]) continue;
						if (q == 0) bmDrawnBottom.append(bm);
						else bmDrawnTop.append(bm);
						LineSeg lsOut = lsOutline;
						lsOut.transformBy(csChoice[q]);
						PlaneProfile ppOutline;
						ppOutline.createRectangle(lsOut, paperX, paperY);
						dpChoice[q].draw(ppOutline);
						dpChoice[q].color(1);
						Point3d ptsPpX[] = Line(el.ptOrg(), elX).orderPoints(ppOutline.getGripEdgeMidPoints());
						Point3d ptsPpZ[] = Line(el.ptOrg(), elZ).orderPoints(ppOutline.getGripEdgeMidPoints());
						dpChoice[q].draw(LineSeg(ptsPpX.first(), ptsPpX.last()));
						dpChoice[q].draw(LineSeg(ptsPpZ.first(), ptsPpZ.last()));
						dpChoice[q].color(-1);
						PlaneProfile pp_this = bm.realBody().shadowProfile(plFrontFace);
						pp_this.shrink(-1*String("1/16").atof(_kLength));
						if (PlaneProfile(pp_BPlow).intersectWith(PlaneProfile(pp_this)))
						{
							arPtVertLabelsElevation.append(bm.ptCen());
							arStVertlabelsElevation.append(stDispLabel);
						}

						if (PlaneProfile(pp_TPlow).intersectWith(PlaneProfile(pp_this)) || (bmCripples.find(bm)>-1 && distToCen<0))
						{
							arPtVertLabelsTop.append(bm.ptCen());
							arStVertlabelsTop.append(stDispLabel);
						}
					}
					if (bmCripples.find(bm)>-1) { (distToCen < 0 ? bmCrippleDimTop : bmCrippleDimBot).append(bm);}

				}

			}
		}
		if (ar_bm_blocking.find(bm)>-1)
		{
			if (bm.vecX().dotProduct(elX) == 0) ppWall.subtractProfile(ppBm);
			Point3d ptLabel = bm.ptCen();
			ptLabel = plFrontFace.closestPointTo(ptLabel);
			ptLabel.transformBy(csVpElevation);
			Point3d ptBlockingRef = Plane(bm.ptCen(), elX).closestPointTo(ptBPleftmost);
			ptBlockingRef = Plane(bm.ptCen(), elZ).closestPointTo(ptBlockingRef);
			Point3d arPtMeasure[] = bm.envelopeBody().intersectPoints(Line(ptBlockingRef, elY));
			Point3d ptMeasure = LineSeg(arPtMeasure.first(), arPtMeasure.last()).ptMid();
			if (psBlockingMeasure == arMeasureBlocking[0]) ptMeasure = arPtMeasure.first();
			if (psBlockingMeasure == arMeasureBlocking[2]) ptMeasure = arPtMeasure.last();
			if (psBlockingDoDimension == sYes) arptBlockingDim.append(ptMeasure);
			String stMeasure = String().format("%09.4f",(ptMeasure - ptBlockingRef).dotProduct(elY));
			arStBlockingHeight.append(String().formatUnit(stMeasure.atof(), stDimStyle));
			arStBlockingInfo.append(stMeasure + "#" + stDispLabel + "#" + ptLabel.X() + ";" + ptLabel.Y() + "#"+bm.handle());
			LineSeg lsBlocking1B = lsOutline2;
			if (dBmZ >= ar_bm_BP[0].dD(elZ)) { lsBlocking1B = lsOutline;}
			lsBlocking1B.transformBy(csVpBottom);
			dpBottom.color(2);
			PLine plOutlineB;
			plOutlineB.createRectangle(lsBlocking1B, paperX, paperY);
			dpBottom.draw(plOutlineB);
			dpBottom.color(1);
			dpBottom.draw(lsBlocking1B);
			dpBottom.color(-1);
			LineSeg lsBlocking1T = lsOutline2;
			if (dBmZ >= ar_bm_BP[0].dD(elZ)) { lsBlocking1T = lsOutline;}
			lsBlocking1T.transformBy(csVpTop);
			dpTop.color(2);
			PLine plOutlineT;
			plOutlineT.createRectangle(lsBlocking1T, paperX, paperY);
			dpTop.draw(plOutlineT);
			dpTop.color(1);
			dpTop.draw(lsBlocking1T);
			dpTop.color(-1);
		}
		else
		{
			if (st_elementXrefHandle != "")
			{
				Map mp_XrefContent;
				mp_XrefContent.setEntity("XRefEntity",bm);
				Map mp_EntityProperties;
				mp_EntityProperties.setString("Label", stDispLabel);
				mp_XrefContent.setMap("EntityProperties", mp_EntityProperties);
				Map mp_mapXs;
				mp_mapXs.setMap("MapX", mp_beamOverride);
				mp_XrefContent.setMap("MapX[]", mp_mapXs);
				mp_elementContent.appendMap("XRefContent", mp_XrefContent);
			}
			else
			{
				bm.setLabel(stDispLabel);
				bm.setSubMapX("Override", mp_beamOverride);
			}
		}
		int iDisplayBlockingNested = FALSE;
		int Uniq = 1;
		int iFoundCombined;

		do
		{
			iFoundCombined = ar_st_beamInfoAll.find(stCombined);
			if (iFoundCombined>-1)
			{
				Beam bmSame = bmTemp[iFoundCombined];
				PlaneProfile ppBmSame = bmSame.envelopeBody().getSlice(Plane(bmSame.ptCen(), elZ));
				ar_st_beamHandles.append(bmSame.handle());
				ar_st_beamLabels.append(stDispLabel);
				double dBmZ = bmSame.dD(elZ);
				double dBmX = bmSame.dD(elX);
				if (bm.vecX().dotProduct(elY)==0) dBmX = bmSame.dL();
				LineSeg lsOutline(bmSame.ptCen() + 0.5 * dBmX * elX + 0.5 * dBmZ * elZ, bmSame.ptCen() - 0.5 * dBmX * elX - 0.5 * dBmZ * elZ);
				LineSeg lsOutline2(bmSame.ptCen() - 0.5 * dBmX * elX + 0.5 * dBmZ * elZ, bmSame.ptCen() + 0.5 * dBmX * elX - 0.5 * dBmZ * elZ);
				if (bmToLabelHz == TRUE && ar_bm_blocking.find(bmSame)==-1)
				{
					Point3d ptLabel = bmSame.ptCen();
					ptLabel = plFrontFace.closestPointTo(ptLabel);
					ptLabel.transformBy(csVpElevation);
					ptLabel += iLabelStagger[bmHz.find(bmSame)] * dCharL*paperX;
					dpS.draw(stDispLabel, ptLabel, paperX, paperY, 0, 0);
					if (ar_bm_BP.find(bmSame)>-1)
					{
						Body bdToDraw = bmSame.realBody();
						bdToDraw.transformBy(csVpBottom);
						PlaneProfile ppPlate = bdToDraw.shadowProfile(Plane(_Pt0, _ZW));
						dpS.draw(ppPlate);
					}
					else if (ar_bm_TP.find(bmSame)>-1)
					{
						Body bdToDraw = bmSame.realBody();
						bdToDraw.transformBy(csVpTop);
						PlaneProfile ppPlate = bdToDraw.shadowProfile(Plane(_Pt0, _ZW));
						dpS.draw(ppPlate);
					}
					else if (bmOverOpening.find(bmSame)>-1)
					{
						if (!bIsFiller)
						{
							LineSeg lsOutTop = lsOutline;
							if (dBmZ >= ar_bm_BP[0].dD(elZ)) { lsOutTop = lsOutline2;}
							lsOutTop.transformBy(csVpTop);
							PLine plOutline;
							plOutline.createRectangle(lsOutTop, paperX, paperY);
							dpTop.draw(plOutline);
						}
						else
						{
							LineSeg lsOutTop = lsOutline;
							if (abs(dBmZ-ar_bm_BP.first().dD(elZ)) < U(0.5)) { lsOutTop = lsOutline2;}
							lsOutTop.transformBy(csVpTop);
							PLine plOutline;
							plOutline.createRectangle(lsOutTop, paperX, paperY);
							dpTop.color(piColor);
							if (iDrawAngleHatch<0) {dpTop.draw(PlaneProfile(plOutline), _kDrawFilled);}
							else { dpTop.draw(PlaneProfile(plOutline), Hatch(_HatchPatterns[iDrawAngleHatch], 0.25));}
							dpTop.color(-1);
						}
					}
				}

				if (bmVt.find(bmSame)>-1)
				{
					ppWall.subtractProfile(ppBmSame);
					int b_touchingBottom = false;
					if (ar_bm_BPfront.find(bmSame)>-1 || ar_bm_BPback.find(bmSame)>-1 || ar_bm_BPcenter.find(bmSame)>-1)
					{
						b_touchingBottom = true;
						if (ar_bm_CUback.find(bmSame)<0 && ar_bm_CUfront.find(bmSame)<0)
						{
							arPtVertLabelsElevation.append(bmSame.ptCen());
							arStVertlabelsElevation.append(stDispLabel);
						}
						else
						{
							Beam bm_this = bmSame;
							PlaneProfile pp_this = bm_this.envelopeBody().shadowProfile(plFrontFace);
							Beam ar_bm_other[0];
							ar_bm_other.append(ar_bm_CUfront.find(bm_this) >- 1 ? ar_bm_CUback : ar_bm_CUfront);
							Point3d pt_labelDraw = bm_this.ptCen();
							pt_labelDraw.transformBy(csVpElevation);
							for (int y; y<ar_bm_other.length(); ++y)
							{
								Beam bm_other = ar_bm_other[y];
								PlaneProfile pp_other = bm_other.envelopeBody().shadowProfile(plFrontFace);
								if (PlaneProfile(pp_this).intersectWith(PlaneProfile(pp_other)) || pp_this.pointInProfile(bm_other.ptCen()) == _kPointInProfile)
								{
									int i_moveDirectionY = ar_bm_CUfront.find(bm_this) >- 1 ? 1 : - 1;
									LineSeg ls_between(plFrontFace.closestPointTo(bm_this.ptCen()), plFrontFace.closestPointTo(bm_other.ptCen()));
									ls_between.transformBy(csVpElevation);
									double d_between = (ls_between.ptStart() - ls_between.ptEnd()).dotProduct(paperX);
									if (abs(d_between) <= dCharL) pt_labelDraw = ls_between.ptMid() + 0.5 * (dRowH + 0.25 * dCharL) * paperY * i_moveDirectionY + 0.5 * dCharL * paperX * (sign(d_between) == 0 ? -i_moveDirectionY : sign(d_between));
									else pt_labelDraw += 0.5 * (dRowH + 0.25 * dCharL) * paperY * i_moveDirectionY;
									break;
								}
							}
							if (i_foundItalicStyle >- 1 && ar_bm_CUback.find(bm_this) >- 1) dpS.dimStyle(st_dimStyleItalic);
							dpS.draw(stDispLabel, pt_labelDraw, paperX, paperY, 0, 0);
							dpS.dimStyle(stDimStyle);
						}
						bmDrawnBottom.append(bmSame);
						LineSeg lsOutBottom = lsOutline;
						lsOutBottom.transformBy(csVpBottom);
						PLine plOutline;
						plOutline.createRectangle(lsOutBottom, paperX, paperY);
						dpBottom.draw(plOutline);
						dpBottom.color(1);
						dpBottom.draw(lsOutBottom);
						if (bmStuds.find(bmSame)>-1)
						{
							LineSeg lsOutBottom2 = lsOutline2;
							lsOutBottom2.transformBy(csVpBottom);
							dpBottom.draw(lsOutBottom2);
						}
						dpBottom.color(-1);
					}
					if (ar_bm_TPfront.find(bmSame)>-1 || ar_bm_TPback.find(bmSame)>-1 || ar_bm_TPcenter.find(bmSame)>-1)
					{
						arPtVertLabelsTop.append(bmSame.ptCen());
						arStVertlabelsTop.append(stDispLabel);
						if (!b_touchingBottom && (ar_bm_CUback.find(bmSame)>-1 || ar_bm_CUfront.find(bmSame)>-1))
						{
							Beam bm_this = bmSame;
							PlaneProfile pp_this = bm_this.envelopeBody().shadowProfile(plFrontFace);
							Beam ar_bm_other[0];
							ar_bm_other.append(ar_bm_CUfront.find(bm_this) >- 1 ? ar_bm_CUback : ar_bm_CUfront);
							Point3d pt_labelDraw = bm_this.ptCen();
							pt_labelDraw.transformBy(csVpElevation);
							for (int y; y<ar_bm_other.length(); ++y)
							{
								Beam bm_other = ar_bm_other[y];
								PlaneProfile pp_other = bm_other.envelopeBody().shadowProfile(plFrontFace);
								if (PlaneProfile(pp_this).intersectWith(PlaneProfile(pp_other)) || pp_this.pointInProfile(bm_other.ptCen()) == _kPointInProfile)
								{
									int i_moveDirectionY = ar_bm_CUfront.find(bm_this) >- 1 ? 1 : - 1;
									LineSeg ls_between(plFrontFace.closestPointTo(bm_this.ptCen()), plFrontFace.closestPointTo(bm_other.ptCen()));
									ls_between.transformBy(csVpElevation);
									double d_between = (ls_between.ptStart() - ls_between.ptEnd()).dotProduct(paperX);
									if (abs(d_between) <= dCharL) pt_labelDraw = ls_between.ptMid() + 0.5 * (dRowH + 0.25 * dCharL) * paperY * i_moveDirectionY + 0.5 * dCharL * paperX * (sign(d_between) == 0 ? -i_moveDirectionY : sign(d_between));
									else pt_labelDraw += 0.5 * (dRowH + 0.25 * dCharL) * paperY * i_moveDirectionY;
									break;
								}
							}
							if (i_foundItalicStyle >- 1 && ar_bm_CUback.find(bm_this) >- 1) dpS.dimStyle(st_dimStyleItalic);
							dpS.draw(stDispLabel, pt_labelDraw, paperX, paperY, 0, 0);
							dpS.dimStyle(stDimStyle);
						}
						bmDrawnTop.append(bmSame);
						LineSeg lsOutTop = lsOutline;
						lsOutTop.transformBy(csVpTop);
						PLine plOutline;
						plOutline.createRectangle(lsOutTop, paperX, paperY);
						dpTop.draw(plOutline);
						dpTop.color(1);
						dpTop.draw(lsOutTop);
						if (bmStuds.find(bmSame)>-1)
						{
							LineSeg lsOutTop2 = lsOutline2;
							lsOutTop2.transformBy(csVpTop);
							dpTop.draw(lsOutTop2);
						}
						dpTop.color(-1);
					}
					if (bmTrimmers.find(bmSame)>-1)
					{
						int bShow = psShowTrimmers == sYes ? true : false;
						for (int q=0; q<bmVt.length(); q++) { if (bmVt.find(bmSame) != q && (bmVt[q].ptCen()-bmSame.ptCen()).dotProduct(elY)>0 && abs((bmVt[q].ptCen()-bmSame.ptCen()).dotProduct(elX))<U(0.2)) bShow = false;}
						if (bShow)
						{
							bmDrawnTop.append(bmSame);
							arPtVertLabelsTop.append(bmSame.ptCen());
							arStVertlabelsTop.append(stDispLabel);
							LineSeg lsOut = lsOutline;
							lsOut.transformBy(csVpTop);
							PlaneProfile ppOutline;
							ppOutline.createRectangle(lsOut, paperX, paperY);
							dpTop.draw(ppOutline);
							dpTop.color(1);
							Point3d ptsPpX[] = Line(el.ptOrg(), elX).orderPoints(ppOutline.getGripEdgeMidPoints());
							Point3d ptsPpZ[] = Line(el.ptOrg(), elZ).orderPoints(ppOutline.getGripEdgeMidPoints());
							dpTop.draw(LineSeg(ptsPpX.first(), ptsPpX.last()));
							dpTop.draw(LineSeg(ptsPpZ.first(), ptsPpZ.last()));
							dpTop.color(-1);
						}
					}
					if (ar_bm_BPfront.find(bmSame)<0 && ar_bm_BPback.find(bmSame)<0 && ar_bm_BPcenter.find(bmSame)<0 && ar_bm_TPfront.find(bmSame)<0 && ar_bm_TPback.find(bmSame)<0 && ar_bm_TPcenter.find(bmSame)<0)
					{
						Point3d ptLabel = bmSame.ptCen();
						//reportMessage("\n " + bmSame + " not touching plates");
						ptLabel.transformBy(csVpElevation);
						dpElevation.draw(stDispLabel, ptLabel, paperX, paperY, 0, 0);
						int bShow = psShowNonTouching == sYes ? true : stDispType == "Cripple" ? true : bmCripples.find(bmSame)>-1 ? true : false;
						if (bShow)
						{
							CoordSys csChoice[] = { csVpBottom, csVpTop};
							Display dpChoice[] = { dpBottom, dpTop};
							int doChoice[] ={ true, true};
							double distToCen = (LineSeg(ptBPleftmost, ptTPrightmost).closestPointTo(LineSeg(ptBPrightmost, ptTPleftmost)) - bmSame.ptCen()).dotProduct(elY);
							if (abs(distToCen)>U(0.2))
							{
								doChoice[distToCen < 0 ? 0 : 1] = false;
							}
							for (int q=0; q<csChoice.length(); q++)
							{
								if ( ! doChoice[q]) continue;
								if (q == 0) bmDrawnBottom.append(bmSame);
								else bmDrawnTop.append(bmSame);
								LineSeg lsOut = lsOutline;
								lsOut.transformBy(csChoice[q]);
								PlaneProfile ppOutline;
								ppOutline.createRectangle(lsOut, paperX, paperY);
								dpChoice[q].draw(ppOutline);
								dpChoice[q].color(1);
								Point3d ptsPpX[] = Line(el.ptOrg(), elX).orderPoints(ppOutline.getGripEdgeMidPoints());
								Point3d ptsPpZ[] = Line(el.ptOrg(), elZ).orderPoints(ppOutline.getGripEdgeMidPoints());
								dpChoice[q].draw(LineSeg(ptsPpX.first(), ptsPpX.last()));
								dpChoice[q].draw(LineSeg(ptsPpZ.first(), ptsPpZ.last()));
								dpChoice[q].color(-1);
								PlaneProfile pp_this = bmSame.realBody().shadowProfile(plFrontFace);
								pp_this.shrink(-1*String("1/16").atof(_kLength));
								if (PlaneProfile(pp_BPlow).intersectWith(PlaneProfile(pp_this)))
								{
									arPtVertLabelsElevation.append(bmSame.ptCen());
									arStVertlabelsElevation.append(stDispLabel);
								}

								if (PlaneProfile(pp_TPlow).intersectWith(PlaneProfile(pp_this)) || (bmCripples.find(bmSame)>-1 && distToCen<0))
								{
									arPtVertLabelsTop.append(bmSame.ptCen());
									arStVertlabelsTop.append(stDispLabel);
								}
							}
							if (bmCripples.find(bmSame)>-1) { (distToCen < 0 ? bmCrippleDimTop : bmCrippleDimBot).append(bmSame);}

						}

					}
				}
				if (ar_bm_blocking.find(bmSame)>-1)
				{
					if (bmSame.vecX().dotProduct(elX) == 0) ppWall.subtractProfile(ppBmSame);
					Point3d ptLabelSame = bmSame.ptCen();
					ptLabelSame = plFrontFace.closestPointTo(ptLabelSame);
					ptLabelSame.transformBy(csVpElevation);
					Point3d ptBlockingRefSame = Plane(bmSame.ptCen(), elX).closestPointTo(ptBPleftmost);
					ptBlockingRefSame = Plane(bmSame.ptCen(), elZ).closestPointTo(ptBlockingRefSame);
					Point3d arPtMeasureSame[] = bmSame.envelopeBody().intersectPoints(Line(ptBlockingRefSame, elY));
					Point3d ptMeasureSame = LineSeg(arPtMeasureSame.first(), arPtMeasureSame.last()).ptMid();
					if (psBlockingMeasure == arMeasureBlocking[0]) ptMeasureSame = arPtMeasureSame.first();
					if (psBlockingMeasure == arMeasureBlocking[2]) ptMeasureSame = arPtMeasureSame.last();
					if (psBlockingDoDimension == sYes) arptBlockingDim.append(ptMeasureSame);
					String stMeasureSame = String().format("%09.4f",(ptMeasureSame - ptBlockingRefSame).dotProduct(elY));
					if (arStBlockingHeight.find(String().formatUnit(stMeasureSame.atof(), stDimStyle)) <0) iDisplayBlockingNested = TRUE;
					arStBlockingHeight.append(String().formatUnit(stMeasureSame.atof(), stDimStyle));
					arStBlockingInfo.append(stMeasureSame + "#" + stDispLabel + "#" + ptLabelSame.X() + ";" + ptLabelSame.Y() + "#"+bmSame.handle());

					LineSeg lsBlocking1B = lsOutline2;
					if (dBmZ >= ar_bm_BP[0].dD(elZ)) { lsBlocking1B = lsOutline;}
					lsBlocking1B.transformBy(csVpBottom);
					dpBottom.color(2);
					PLine plOutlineB;
					plOutlineB.createRectangle(lsBlocking1B, paperX, paperY);
					dpBottom.draw(plOutlineB);
					dpBottom.color(1);
					dpBottom.draw(lsBlocking1B);
					dpBottom.color(-1);
					LineSeg lsBlocking1T = lsOutline2;
					if (dBmZ >= ar_bm_BP[0].dD(elZ)) { lsBlocking1T = lsOutline;}
					lsBlocking1T.transformBy(csVpTop);
					dpTop.color(2);
					PLine plOutlineT;
					plOutlineT.createRectangle(lsBlocking1T, paperX, paperY);
					dpTop.draw(plOutlineT);
					dpTop.color(1);
					dpTop.draw(lsBlocking1T);
					dpTop.color(-1);
				}
				else
				{
					if (st_elementXrefHandle != "")
					{
						Map mp_XrefContent;
						mp_XrefContent.setEntity("XRefEntity", bmSame);
						Map mp_EntityProperties;
						mp_EntityProperties.setString("Label", stDispLabel);
						mp_XrefContent.setMap("EntityProperties", mp_EntityProperties);
						Map mp_mapXs;
						mp_mapXs.setMap("MapX", mp_beamOverride);
						mp_XrefContent.setMap("MapX[]", mp_mapXs);
						mp_elementContent.appendMap("XRefContent", mp_XrefContent);
					}
					else
					{
						bmSame.setLabel(stDispLabel);
						bmSame.setSubMapX("Override", mp_beamOverride);
					}
				}
				bmTemp.removeAt(iFoundCombined);
				ar_st_beamInfoAll.removeAt(iFoundCombined);
				Uniq++;
			}
		}
		while (iFoundCombined>-1);

		String st_cutlistInfo = stDispType + "@" + stDispSize + "@" + stDispLabel + "@" + String(Uniq) + "@" + stDispPosNum + "@" + stDispLength;
		if (arStBlockingInfo.length()>0)
		{

			String stToDisplay;
			if (iDisplayBlockingNested == TRUE)
			{
				String arStBlockingInfoSorted[] = arStBlockingInfo.sorted();
				arStBlockingInfo.setLength(0);
				for (int y = arStBlockingInfoSorted.length() - 1; y >- 1; y--) arStBlockingInfo.append(arStBlockingInfoSorted[y]);
				arStBlockingHeight.setLength(0);
				for (int y; y<arStBlockingInfo.length(); y++) { arStBlockingHeight.append(String().formatUnit(arStBlockingInfo[y].token(0, "#").atof(), stDimStyle));}


				int iBlockQty = arStBlockingInfo.length() - 1;
				int iBLabelCount = 0;
				while (iBlockQty>-1)
				{
					String ar_st_blockingInfo[] = arStBlockingInfo[iBlockQty].tokenize("#");
					String stHeightFirst = arStBlockingHeight[iBlockQty];
					String stBLabel = ar_st_blockingInfo[1]+String(arAlphabet[iBLabelCount]).makeLower();
					Point3d ptFirst(ar_st_blockingInfo[2].token(0, ";").atof(), ar_st_blockingInfo[2].token(1, ";").atof(), 0);
					Entity ent_first;
					ent_first.setFromHandle(ar_st_blockingInfo[3]);
					Beam bm_first = (Beam) ent_first;
					arStBlockingInfo.removeAt(iBlockQty);
					arStBlockingHeight.removeAt(iBlockQty);
					{
						if (st_elementXrefHandle != "")
						{
							Map mp_XrefContent;
							mp_XrefContent.setEntity("XRefEntity", bm_first);
							Map mp_EntityProperties;
							mp_EntityProperties.setString("Label", stBLabel);
							mp_XrefContent.setMap("EntityProperties", mp_EntityProperties);
							Map mp_mapXs;
							mp_mapXs.setMap("MapX", mp_beamOverride);
							mp_XrefContent.setMap("MapX[]", mp_mapXs);
							mp_elementContent.appendMap("XRefContent", mp_XrefContent);
						}
						else
						{
							bm_first.setLabel(stBLabel);
							bm_first.setSubMapX("Override", mp_beamOverride);
						}
					}

					int i_isFromtBackFirst[] = { ar_bm_blockingFront.find(bm_first), ar_bm_blockingBack.find(bm_first)};
					int b_setItalicFirst = false;
					if (i_isFromtBackFirst[0]*i_isFromtBackFirst[1] <1)
					{
						PlaneProfile pp_this = bm_first.envelopeBody().shadowProfile(plFrontFace);
						Beam ar_bm_other[0];
						ar_bm_other.append(i_isFromtBackFirst[0] >- 1 ? ar_bm_blockingBack : ar_bm_blockingFront);
						for (int y; y<ar_bm_other.length(); ++y)
						{
							Beam bm_other = ar_bm_other[y];
							PlaneProfile pp_other = bm_other.envelopeBody().shadowProfile(plFrontFace);
							if (pp_other.intersectWith(PlaneProfile(pp_this)) || pp_this.pointInProfile(bm_other.ptCen())==_kPointInProfile || pp_other.pointInProfile(bm_first.ptCen())==_kPointInProfile)
							{
								int i_moveDirectionX = i_isFromtBackFirst[0] >- 1 ? 1 : - 1;
								int i_moveDirectionY = i_isFromtBackFirst[0] >- 1 ? 1 : - 1;
								double d_heightDiff = (bm_first.ptCen() - bm_other.ptCen()).dotProduct(elY);
								if (abs(d_heightDiff)< String("1/16").atof(_kLength))
								{
									i_moveDirectionY = 0;
									i_moveDirectionX *= 2;
								}
								else
								{
									i_moveDirectionY = sign(d_heightDiff);
								}
								Point3d pt_between = LineSeg(bm_first.ptCen() , bm_other.ptCen()).ptMid();
								pt_between.transformBy(csVpElevation);
								ptFirst = pt_between + 0.5 * (dRowH + 0.25 * dCharL) * paperY * i_moveDirectionY - 0.5 * dCharL * paperX * i_moveDirectionX;
								break;
							}
						}
						if (i_isFromtBackFirst[1] >- 1 && i_foundItalicStyle >- 1)
						{
							b_setItalicFirst = true;
							dpS.dimStyle(st_dimStyleItalic);
						}

					}
					dpS.draw(stBLabel, ptFirst, paperX, paperY, 0, 0);
					if (b_setItalicFirst) dpS.dimStyle(stDimStyle);

					int iFoundBlocking;
					do
					{
						iFoundBlocking = arStBlockingHeight.find(stHeightFirst);
						if (iFoundBlocking>-1)
						{
							String ar_st_blockingInfoSame[] = arStBlockingInfo[iFoundBlocking].tokenize("#");
							Point3d ptSame(ar_st_blockingInfoSame[2].token(0, ";").atof(), ar_st_blockingInfoSame[2].token(1, ";").atof(), 0);
							Entity ent_same;
							ent_same.setFromHandle(ar_st_blockingInfoSame[3]);
							Beam bm_same = (Beam) ent_same;
							arStBlockingInfo.removeAt(iFoundBlocking);
							arStBlockingHeight.removeAt(iFoundBlocking);
							{
								if (st_elementXrefHandle != "")
								{
									Map mp_XrefContent;
									mp_XrefContent.setEntity("XRefEntity", bm_same);
									Map mp_EntityProperties;
									mp_EntityProperties.setString("Label", stBLabel);
									mp_XrefContent.setMap("EntityProperties", mp_EntityProperties);
									Map mp_mapXs;
									mp_mapXs.setMap("MapX", mp_beamOverride);
									mp_XrefContent.setMap("MapX[]", mp_mapXs);
									mp_elementContent.appendMap("XRefContent", mp_XrefContent);
								}
								else
								{
									bm_same.setLabel(stBLabel);
									bm_same.setSubMapX("Override", mp_beamOverride);
								}
							}

							int i_isFromtBacksame[] = { ar_bm_blockingFront.find(bm_same), ar_bm_blockingBack.find(bm_same)};
							int b_setItalicSame = false;
							if (i_isFromtBacksame[0]*i_isFromtBacksame[1]<1)
							{
								PlaneProfile pp_this = bm_same.envelopeBody().shadowProfile(plFrontFace);
								Beam ar_bm_other[0];
								ar_bm_other.append(i_isFromtBacksame[0] >- 1 ? ar_bm_blockingBack : ar_bm_blockingFront);
								for (int y; y<ar_bm_other.length(); ++y)
								{
									Beam bm_other = ar_bm_other[y];
									PlaneProfile pp_other = bm_other.envelopeBody().shadowProfile(plFrontFace);
									if (pp_other.intersectWith(PlaneProfile(pp_this)) || pp_this.pointInProfile(bm_other.ptCen())==_kPointInProfile || pp_other.pointInProfile(bm_same.ptCen())==_kPointInProfile)
									{
										int i_moveDirectionX = i_isFromtBacksame[0] >- 1 ? 1 : - 1;
										int i_moveDirectionY = i_isFromtBacksame[0] >- 1 ? 1 : - 1;
										double d_heightDiff = (bm_same.ptCen() - bm_other.ptCen()).dotProduct(elY);
										if (abs(d_heightDiff)< String("1/16").atof(_kLength))
										{
											i_moveDirectionY = 0;
											i_moveDirectionX *= 2;
										}
										else
										{
											i_moveDirectionY = sign(d_heightDiff);
										}
										Point3d pt_between = LineSeg(bm_same.ptCen() , bm_other.ptCen()).ptMid();
										pt_between.transformBy(csVpElevation);
										ptSame = pt_between + 0.5 * (dRowH + 0.25 * dCharL) * paperY * i_moveDirectionY - 0.5 * dCharL * paperX * i_moveDirectionX;
										break;
									}
								}
								if (i_isFromtBacksame[1] >- 1 && i_foundItalicStyle >- 1)
								{
									b_setItalicSame = true;
									dpS.dimStyle(st_dimStyleItalic);
								}
							}
							dpS.draw(stBLabel, ptSame, paperX, paperY, 0, 0);
							if (b_setItalicSame) dpS.dimStyle(stDimStyle);
						}
					}
					while (iFoundBlocking >- 1);
					if (iBLabelCount>0) stToDisplay += (piMaxBlockingPositions>0 && iBLabelCount == piMaxBlockingPositions) ? "|" : ", ";
					stToDisplay += String(arAlphabet[iBLabelCount]).makeLower() + ") " + stHeightFirst;
					iBLabelCount++;
					iBlockQty = arStBlockingInfo.length() - 1;
				}
			}
			else
			{
				stToDisplay = arStBlockingHeight.first();
				for (int k=0; k<arStBlockingInfo.length(); k++)
				{
					String ar_st_blockingInfo[] = arStBlockingInfo[k].tokenize("#");
					String stBLabel = ar_st_blockingInfo[1];
					Point3d pt_this(ar_st_blockingInfo[2].token(0, ";").atof(), ar_st_blockingInfo[2].token(1, ";").atof(), 0);
					Entity ent_this;
					ent_this.setFromHandle(ar_st_blockingInfo[3]);
					Beam bm_this = (Beam) ent_this;
					{
						if (st_elementXrefHandle != "")
						{
							Map mp_XrefContent;
							mp_XrefContent.setEntity("XRefEntity", bm_this);
							Map mp_EntityProperties;
							mp_EntityProperties.setString("Label", stBLabel);
							mp_XrefContent.setMap("EntityProperties", mp_EntityProperties);
							Map mp_mapXs;
							mp_mapXs.setMap("MapX", mp_beamOverride);
							mp_XrefContent.setMap("MapX[]", mp_mapXs);
							mp_elementContent.appendMap("XRefContent", mp_XrefContent);
						}
						else
						{
							bm_this.setLabel(stBLabel);
							bm_this.setSubMapX("Override", mp_beamOverride);
						}
					}

					int i_isFromtBackthis[] = { ar_bm_blockingFront.find(bm_this), ar_bm_blockingBack.find(bm_this)};
					int b_setItalicthis = false;
					if (i_isFromtBackthis[0]*i_isFromtBackthis[1] <1)
					{
						PlaneProfile pp_this = bm_this.envelopeBody().shadowProfile(plFrontFace);
						Beam ar_bm_other[0];
						ar_bm_other.append(i_isFromtBackthis[0] >- 1 ? ar_bm_blockingBack : ar_bm_blockingFront);
						for (int y; y<ar_bm_other.length(); ++y)
						{
							Beam bm_other = ar_bm_other[y];
							PlaneProfile pp_other = bm_other.envelopeBody().shadowProfile(plFrontFace);
							if (pp_other.intersectWith(PlaneProfile(pp_this)) || pp_this.pointInProfile(bm_other.ptCen())==_kPointInProfile || pp_other.pointInProfile(bm_this.ptCen())==_kPointInProfile)
							{
								int i_moveDirection = i_isFromtBackthis[0] >- 1 ? 1 : - 1;
								Point3d pt_between = LineSeg(bm_this.ptCen() , bm_other.ptCen()).ptMid();
								pt_between.transformBy(csVpElevation);
								pt_this = pt_between + 0.5 * (dRowH + 0.25 * dCharL) * paperY * i_moveDirection - 0.5 * dCharL * paperX * i_moveDirection;
								break;
							}
						}
						if (i_isFromtBackthis[1] >- 1 && i_foundItalicStyle >- 1)
						{
							b_setItalicthis = true;
							dpS.dimStyle(st_dimStyleItalic);
						}

					}
					dpS.draw(stBLabel, pt_this, paperX, paperY, 0, 0);
					if (b_setItalicthis) dpS.dimStyle(stDimStyle);

				}
			}
			String ar_st_to_display[] = stToDisplay.tokenize("|");
			if (ar_st_to_display.length() > 1) iExcedsLimits++;
			if (dBlockListLength[iExcedsLimits >= piCutlistRows] == 0) dBlockListLength[iExcedsLimits >= piCutlistRows] = dpS.textLengthForStyle("Blocking Pos.", stDimStyle) + 2 * dCharL;
			double blockingposlength = dpS.textLengthForStyle(ar_st_to_display[0], stDimStyle)+2*dCharL;
			if (blockingposlength > dBlockListLength[iExcedsLimits >= piCutlistRows]) dBlockListLength[iExcedsLimits >= piCutlistRows] = blockingposlength;
			st_cutlistInfo += "@" + stToDisplay;
		}
		bmQty = bmTemp.length() - 1;
		if (iExcedsLimits >= piCutlistRows) arStDrawExcedsLimits.append(st_cutlistInfo);
		else ar_st_drawCutListMain.append(st_cutlistInfo);
		iExcedsLimits++;

	}

	//---------------
	//--------------- <PREPARE BEAM INFO FOR SCHEDULE, DRAW OR STORE LABELS, DRAW BEAMS IN VIEWS> --- end
	//endregion

	//region DRAW VERTICAL BEAMS LABELS ON ELEVATION VIEW
	//--------------- <DRAW VERTICAL BEAMS LABELS ON ELEVATION VIEW> --- start
	//---------------

	Point3d arPtVertLabelsElevationProjected[] = Line(ar_pt_BPsectionView.first(), elX).projectPoints(arPtVertLabelsElevation);
	Point3d arPtVertLabelsElevationSorted[] = Line(ar_pt_BPsectionView.first(), elX).orderPoints(arPtVertLabelsElevationProjected);
	int iVertLabelsElevationQty = arPtVertLabelsElevationSorted.length() - 1;
	while (iVertLabelsElevationQty >-1)
	{
		Point3d ptNow = arPtVertLabelsElevationSorted[iVertLabelsElevationQty];
		String stNow = arStVertlabelsElevation[arPtVertLabelsElevationProjected.find(ptNow)];
		arPtVertLabelsElevationSorted.removeAt(iVertLabelsElevationQty);
		arPtVertLabelsElevationProjected.removeAt(arPtVertLabelsElevationProjected.find(ptNow));
		arStVertlabelsElevation.removeAt(arStVertlabelsElevation.find(stNow));
		Point3d ptDrawTop[] = { ptNow};
		String stTemp[0];
		stTemp.append(arStVertlabelsElevation);
		Point3d ptTempProjected[0];
		ptTempProjected.append(arPtVertLabelsElevationProjected);
		Point3d ptTempSorted[0];
		ptTempSorted.append(arPtVertLabelsElevationSorted);
		int iFound;
		do
		{
			iFound = stTemp.find(stNow);
			if (iFound > -1)
			{
				Point3d ptNext = ptTempProjected[iFound];
				if (abs((ptNext-ptDrawTop[ptDrawTop.length()-1]).dotProduct(elX)) <= U(1.51))
				{
					ptDrawTop.append(ptNext);
					arStVertlabelsElevation.removeAt(arPtVertLabelsElevationProjected.find(ptNext));
					arPtVertLabelsElevationProjected.removeAt(arPtVertLabelsElevationProjected.find(ptNext));
					arPtVertLabelsElevationSorted.removeAt(arPtVertLabelsElevationSorted.find(ptNext));
				}
				ptTempSorted.removeAt(ptTempSorted.find(ptNext));
				ptTempProjected.removeAt(iFound);
				stTemp.removeAt(iFound);
			}
		}
		while (iFound > - 1);

		Point3d ptLow = Plane(ptBPleftmost, elY).closestPointTo(LineSeg(ptDrawTop[0], ptDrawTop[ptDrawTop.length() - 1]).ptMid());
		ptLow.transformBy(csVpElevation);
		ptLow -= dCharL * paperY;
		for (int i=0; i<ptDrawTop.length(); i++)
		{
			Point3d pt = ptDrawTop[i];
			pt.transformBy(csVpElevation);
			dpS.draw(LineSeg(pt, ptLow));
		}
		dpS.draw(stNow, ptLow - dCharL * paperY, paperX, paperY, 0, 0);

		iVertLabelsElevationQty = arPtVertLabelsElevationSorted.length() - 1;
	}

	//---------------
	//--------------- <DRAW VERTICAL BEAMS LABELS ON ELEVATION VIEW> --- end
	//endregion

	//region DRAW VERTICAL BEAMS LABELS ON TOP VIEW
	//--------------- <DRAW VERTICAL BEAMS LABELS ON TOP VIEW> --- start
	//---------------

	Point3d arPtVertLabelsTopProjected[] = Line(ar_pt_BPsectionView.first(), elX).projectPoints(arPtVertLabelsTop);
	Point3d arPtVertLabelsTopSorted[] = Line(ar_pt_BPsectionView.first(), elX).orderPoints(arPtVertLabelsTopProjected);
	int iVertLabelsTopQty = arPtVertLabelsTopSorted.length() - 1;
	while (iVertLabelsTopQty >-1)
	{
		Point3d ptNow = arPtVertLabelsTopSorted[iVertLabelsTopQty];
		String stNow = arStVertlabelsTop[arPtVertLabelsTopProjected.find(ptNow)];
		arPtVertLabelsTopSorted.removeAt(iVertLabelsTopQty);
		arPtVertLabelsTopProjected.removeAt(arPtVertLabelsTopProjected.find(ptNow));
		arStVertlabelsTop.removeAt(arStVertlabelsTop.find(stNow));
		Point3d ptDrawTop[] = { ptNow};
		String stTemp[0];
		stTemp.append(arStVertlabelsTop);
		Point3d ptTempProjected[0];
		ptTempProjected.append(arPtVertLabelsTopProjected);
		Point3d ptTempSorted[0];
		ptTempSorted.append(arPtVertLabelsTopSorted);
		int iFound;
		do
		{
			iFound = stTemp.find(stNow);
			if (iFound > -1)
			{
				Point3d ptNext = ptTempProjected[iFound];
				if (abs((ptNext-ptDrawTop[ptDrawTop.length()-1]).dotProduct(elX)) <= U(1.51))
				{
					ptDrawTop.append(ptNext);
					arStVertlabelsTop.removeAt(arPtVertLabelsTopProjected.find(ptNext));
					arPtVertLabelsTopProjected.removeAt(arPtVertLabelsTopProjected.find(ptNext));
					arPtVertLabelsTopSorted.removeAt(arPtVertLabelsTopSorted.find(ptNext));
				}
				ptTempSorted.removeAt(ptTempSorted.find(ptNext));
				ptTempProjected.removeAt(iFound);
				stTemp.removeAt(iFound);
			}
		}
		while (iFound > - 1);

		Point3d ptLow = plBackFace.closestPointTo(LineSeg(ptDrawTop[0], ptDrawTop[ptDrawTop.length() - 1]).ptMid());
		ptLow.transformBy(csVpTop);
		ptLow += 1.5 * dCharL * paperY;
		for (int i=0; i<ptDrawTop.length(); i++)
		{
			Point3d pt = ptDrawTop[i];
			pt.transformBy(csVpTop);
			dpS.draw(LineSeg(pt, ptLow));
		}
		dpS.draw(stNow, ptLow + dCharL * paperY, paperX, paperY, 0, 0);

		iVertLabelsTopQty = arPtVertLabelsTopSorted.length() - 1;
	}

	//---------------
	//--------------- <DRAW VERTICAL BEAMS LABELS ON TOP VIEW> --- end
	//endregion

	//region DRAW FRAMING SCHEDULE
	//--------------- <DRAW FRAMING SCHEDULE> --- start
	//---------------

	Point3d ptHzCutList[] = { _Pt0, _Pt0};
	double dCutListTableLength[2];
	for (int q; q<dCutListTableLength.length(); ++q)
	{
		String ar_st_drawInfo[0];
		ar_st_drawInfo.append(q == 0 ? ar_st_drawCutListMain : arStDrawExcedsLimits);
		if (ar_st_drawInfo.length() == 0) continue;
		Point3d pt_scheduleOrigin = _Pt0- (q==0 ? (dRowH + 1.5*dCharL) : 0) * paperY;
		if (q > 0) pt_scheduleOrigin += paperX * (dCutListTableLength[0] + dCharL);
		Point3d pt_cutlistY = pt_scheduleOrigin;
		double ar_d_columnLength[] = { dCheckType, dCheckSize, dLabelLength, dQtyLength, dPosNumLength, dCheckLength};
		String ar_st_columnNames[] = { "Timber", "Size", "Lab.", "Qty", "No", "Length"};
		if (dBlockListLength[q]>0)
		{
			ar_d_columnLength.append(dBlockListLength[q]);
			ar_st_columnNames.append("Blocking Pos.");
		}
		Point3d pt_columnNames = pt_cutlistY;
		for (int n; n<ar_d_columnLength.length(); ++n)
		{
			dCutListTableLength[q] += 2 * dCharL + ar_d_columnLength[n];
			LineSeg ls_column(pt_columnNames - (dRowH + dCharL) * paperY, pt_columnNames + (2 * dCharL + ar_d_columnLength[n]) * paperX);
			dpS.draw(ar_st_columnNames[n], ls_column.ptMid(), paperX, paperY, 0, 0);
			pt_columnNames = ls_column.ptEnd();
		}
		if (q==0)
		{
			LineSeg ls_cutlistHeader(_Pt0, pt_cutlistY + dCutListTableLength[q]*paperX);
			dpS.draw(stCutListHeader, ls_cutlistHeader.ptMid(), paperX, paperY, 0, 0);
			PLine pl_cutlistHeader;
			pl_cutlistHeader.createRectangle(ls_cutlistHeader, paperX, paperY);
			dpS.draw(pl_cutlistHeader);
		}
		pt_cutlistY -= (dRowH + dCharL) * paperY;
		dpS.draw(LineSeg(pt_cutlistY, pt_cutlistY + dCutListTableLength[q] * paperX));
		int b_splitDevider = false;
		PlaneProfile ppSplit;
		for (int i=0; i<ar_st_drawInfo.length(); i++)
		{
			String arStDraw[] = ar_st_drawInfo[i].tokenize("@");
			pt_cutlistY -= (dRowH + dCharL) * paperY;

			Point3d ptText0 = pt_cutlistY + 0.5*(dRowH + dCharL) * paperY + dCharL*paperX;
			Point3d ptLine = _Pt0 + paperX * (dCutListTableLength[0] + dCharL) - 2 * (dRowH + 1.25 * dCharL) * paperY;
			for (int j=0; j<arStDraw.length(); j++)
			{
				String ar_st_multi[] = arStDraw[j].tokenize("|");
				for (int y; y<ar_st_multi.length(); ++y)
				{
					Point3d ptText = ptText0 - y * (dRowH + dCharL) * paperY;
					if (y > 0) ptText = Line(pt_scheduleOrigin + dCharL * paperX, paperY).closestPointTo(ptText);
					dpS.draw(ar_st_multi[y], ptText, paperX, paperY, 1, 0);
					if (y>0)
					{
						dpS.draw(LineSeg(pt_cutlistY, pt_cutlistY + dCutListTableLength[q] * paperX)); //--- DEVIDER
						PlaneProfile ppGap;
						ppGap.createRectangle(LineSeg(pt_cutlistY - 2 * dCharL * paperX, pt_cutlistY - (dRowH + dCharL) * paperY + 2 * dCharL * paperX), paperX, paperY);
						if ( ! b_splitDevider) ppSplit = ppGap;
						else ppSplit.unionWith(ppGap);
						b_splitDevider = true;
						pt_cutlistY -= (dRowH + dCharL) * paperY;
					}
				}
				ptLine += (ar_d_columnLength[j] + 2 * dCharL) * paperX;
				ptText0 += (ar_d_columnLength[j] + 2 * dCharL) * paperX;

			}
			dpS.draw(LineSeg(pt_cutlistY, pt_cutlistY + dCutListTableLength[q] * paperX));
		}
		PLine pl_cutlistOutline;
		pl_cutlistOutline.createRectangle(LineSeg(pt_cutlistY, pt_scheduleOrigin + paperX * dCutListTableLength[q]), paperX, paperY);
		dpS.draw(pl_cutlistOutline);
		LineSeg ls_devider[0];
		if (b_splitDevider) ls_devider.append(ppSplit.splitSegments(LineSeg(pt_cutlistY, pt_scheduleOrigin), false));
		else ls_devider.append(LineSeg(pt_cutlistY, pt_scheduleOrigin));
		for (int y; y < ls_devider.length(); ++y)
		{
			LineSeg lsdraw = ls_devider[y];
			for (int n; n < ar_d_columnLength.length() - 1; ++n)
			{
				lsdraw.transformBy((ar_d_columnLength[n] + 2 * dCharL) * paperX);
				dpS.draw(lsdraw);
			}
		}
		ptHzCutList[q] = pt_cutlistY;
	}

	//---------------
	//--------------- <DRAW FRAMING SCHEDULE> --- end
	//endregion

	//region DRAW BEAM DIMENSIONS ON VIEWS
	//--------------- <DRAW BEAM DIMENSIONS ON VIEWS> --- start
	//---------------

	Beam bmTConnect[0];
	bmTConnect.append(ar_bm_BPcenter);
	bmTConnect.append(ar_bm_BPfront);
	bmTConnect.append(ar_bm_BPback);
	bmTConnect.append(bmCrippleDimBot);
	Point3d ptDimBottomView = ptBPleftmost;
	ptDimBottomView.transformBy(csVpBottom);
	ptDimBottomView -= (pdBottomVPdimOffset > 0 ? pdBottomVPdimOffset : 2 * dRowH) * paperY + 2 * dCharL * paperX;
	DimLine dlBottomViewBeams(ptDimBottomView, paperX, paperY);
	dlBottomViewBeams.transformBy(csVpBottomInvert);
	Point3d ptTConnect[] = dlBottomViewBeams.collectDimPoints(bmTConnect, _kLeft);
	ptTConnect = Line(dlBottomViewBeams.ptOrg(), dlBottomViewBeams.vecX()).projectPoints(ptTConnect);
	Point3d ptDimBottomBeams[0];
	ptDimBottomBeams.append(Line(dlBottomViewBeams.ptOrg(), dlBottomViewBeams.vecX()).projectPoints(ar_pt_BP));
	for (int i=1; i<bmTConnect.length(); i++)
	{
		double dBmX = bmTConnect[i - 1].dD(elX);
		double dist = abs( (ptTConnect[i] - ptTConnect[i - 1]).length());
		dist -= U(0.01);
		if (dist > dBmX) ptDimBottomBeams.append(ptTConnect[i]);
	}
	ptDimBottomBeams = Line(dlBottomViewBeams.ptOrg(), dlBottomViewBeams.vecX()).orderPoints(ptDimBottomBeams);
	Dim dmBottomBeams(dlBottomViewBeams, ptDimBottomBeams, "", "<>", _kDimNone, _kDimCumm);
	dmBottomBeams.transformBy(csVpBottom);
	dpBottom.draw(dmBottomBeams);
	if (i_hsbversion >= 22)
	{
		PLine ar_pl_dmBottomBeamsText[] = dmBottomBeams.getTextAreas(dpBottom);
		for (int n; n < ar_pl_dmBottomBeamsText.length(); ++n) pp_bottomAll.joinRing(ar_pl_dmBottomBeamsText[n], false);
	}
	Beam bmTopTconnect[0];
	bmTopTconnect.append(ar_bm_TPcenter);
	bmTopTconnect.append(ar_bm_TPfront);
	bmTopTconnect.append(ar_bm_TPback);
	bmTopTconnect.append(bmCrippleDimTop);
	Point3d ptDimTopView = ptBPleftmost;
	ptDimTopView.transformBy(csVpTop);
	ptDimTopView -= (pdTopVPdimOffset > 0 ? pdTopVPdimOffset : 2 * dRowH) * paperY + 2 * dCharL * paperX;
	DimLine dlTopViewBeams(ptDimTopView, paperX, paperY);
	dlTopViewBeams.transformBy(csVpTopInvert);
	Point3d ptTopTconnect[] = dlTopViewBeams.collectDimPoints(bmTopTconnect, _kLeft);
	ptTopTconnect = Line(dlTopViewBeams.ptOrg(), dlTopViewBeams.vecX()).projectPoints(ptTopTconnect);
	Point3d ptDimTopBeams[0];
	ptDimTopBeams.append(Line(dlTopViewBeams.ptOrg(), dlTopViewBeams.vecX()).projectPoints(ar_pt_BP));
	for (int i=1; i<bmTopTconnect.length(); i++)
	{
		double dBmX = bmTopTconnect[i - 1].dD(elX);
		double dist = abs((ptTopTconnect[i] - ptTopTconnect[i - 1]).length());
		dist -= U(0.01);
		if (dist > dBmX) ptDimTopBeams.append(ptTopTconnect[i]);
	}
	ptDimTopBeams = Line(dlTopViewBeams.ptOrg(), dlTopViewBeams.vecX()).orderPoints(ptDimTopBeams);
	Dim dmTopBeams(dlTopViewBeams, ptDimTopBeams, "", "<>", _kDimNone, _kDimCumm);
	dmTopBeams.transformBy(csVpTop);
	dpTop.draw(dmTopBeams);
	if (i_hsbversion >= 22)
	{
		PLine ar_pl_dmTopBeamsText[] = dmTopBeams.getTextAreas(dpTop);
		for (int n; n < ar_pl_dmTopBeamsText.length(); ++n) pp_topAll.joinRing(ar_pl_dmTopBeamsText[n], false);
	}

	//---------------
	//--------------- <DRAW BEAM DIMENSIONS ON VIEWS> --- end
	//endregion

//---------------
//--------------- <FRAMING PART 2> --- end
//endregion


//region SHEATHING
//--------------- <SHEATHING> --- start
//---------------

	//region PREPARE SHEATHING INFO AND DRAW LABELS
	//--------------- <PREPARE SHEATHING INFO AND DRAW LABELS> --- start
	//---------------

	Sheet ar_sh_all[] = el.sheet();
	Sheet ar_sh_display[0];
	int ZoneIndexVpElevation = vpElevation.activeZoneIndex();
	int FrontBackZones[] = { 1, - 1};
	int SheetsOnOtherZones;
	double d_sheathingScheduleHeight , d_sheathingScheduleLength;
	String ar_st_sheathingCompare[0];


	for (int n; n<ar_sh_all.length(); ++n)
	{
		Sheet sh_this = ar_sh_all[n];
		Entity ent_this = (Entity) sh_this;
		int i_zoneIndex = ent_this.myZoneIndex();
		int bIsOtherZone = (prZoneChoice == arZoneChoice[0] && FrontBackZones.find(i_zoneIndex) == -1)
		 || (prZoneChoice == arZoneChoice[1] && i_zoneIndex != piSheetingZone);
		int bDrawThis = !((i_zoneIndex == 0)
						|| (prZoneChoice!=arZoneChoice[2]
							&& psDrawOtherSheets==sNo
							&& bIsOtherZone));
		if (bDrawThis)
		{
			PlaneProfile pp_sheet = sh_this.realBody().shadowProfile(plBottomWall);
			PlaneProfile pp_shTop(pp_sheet);
			pp_shTop.transformBy(csVpTop);
			dpTop.color(sh_this.color());
			dpTop.draw(pp_shTop);
			dpTop.color(-1);
			PlaneProfile pp_shBottom(pp_sheet);
			pp_shBottom.transformBy(csVpBottom);
			dpBottom.color(sh_this.color());
			dpBottom.draw(pp_shBottom);
			dpBottom.color(-1);
		}

		if (bIsOtherZone)
		{
			SheetsOnOtherZones++;
			continue;
		}

		ar_sh_display.append(sh_this);
		String stMaterial = sh_this.material();
		if (stMaterial == "") stMaterial = sh_this.grade();
		String stWidth = String().formatUnit(sh_this.solidWidth(), stDimStyle);
		String stHeight = String().formatUnit(sh_this.solidLength(), stDimStyle);
		ar_st_sheathingCompare.append(stMaterial + "@" + "-" + "@" + stWidth + "@" + stHeight + "@" + sh_this.posnum());
	}

	String ar_st_sheathingColumnNames[] = { "Material", "Qty", "Width", "Height", "Num"};
	double ar_d_sheathingColumnLength[0];
	for (int n; n<ar_st_sheathingColumnNames.length(); ++n)
	{
		String st_columnName = ar_st_sheathingColumnNames[n];
		double d_columnLength = 2 * dCharL + dpS.textLengthForStyle(st_columnName, stDimStyle);
		ar_d_sheathingColumnLength.append(d_columnLength);
	}

	Sheet ar_sh_dimension[0];
	String ar_st_sheathingInfo[0];
	int i_sheathingQty = ar_sh_display.length() - 1;
	while (i_sheathingQty>-1)
	{
		Sheet sh_this = ar_sh_display[i_sheathingQty];
		ar_sh_display.removeAt(i_sheathingQty);
		String st_info = ar_st_sheathingCompare[i_sheathingQty];
		ar_st_sheathingCompare.removeAt(i_sheathingQty);
		String ar_st_info[] = st_info.tokenize("@");
		String st_posnum = ar_st_info[4];
		Point3d ar_pt_label[] = { sh_this.ptCenSolid() + 0.5 * sh_this.solidLength() * elY + 0.5 * sh_this.solidWidth() * elX};
		Sheet ar_sh_label[] = { sh_this};

		int i_itemQty = 1;
		int i_found;
		do
		{
			i_found = ar_st_sheathingCompare.find(st_info);
			if (i_found>-1)
			{
				Sheet sh_same = ar_sh_display[i_found];
				ar_sh_display.removeAt(i_found);
				ar_st_sheathingCompare.removeAt(i_found);
				i_itemQty++;
				ar_pt_label.append(sh_same.ptCenSolid() + 0.5 * sh_same.solidLength() * elY + 0.5 * sh_same.solidWidth() * elX);
				ar_sh_label.append(sh_same);
			}
		}
		while (i_found >- 1);

		ar_st_info[1] = i_itemQty;
		String st_drawInfo;
		for (int n; n < ar_st_info.length(); ++n)
		{
			String st_value = ar_st_info[n];
			st_drawInfo += (n == 0 ? "" : "@") + st_value;
			double d_valueLength = 2 * dCharL + dpS.textLengthForStyle(st_value, stDimStyle);
			if (ar_d_sheathingColumnLength[n] < d_valueLength) ar_d_sheathingColumnLength[n] = d_valueLength;
		}
		ar_st_sheathingInfo.append(st_drawInfo);

		double d_labelDiam = dpS.textLengthForStyle(st_posnum, stDimStyle) + dCharL;
		for (int n; n<ar_pt_label.length(); ++n)
		{
			Point3d pt_this = ar_pt_label[n];
			pt_this.transformBy(csVpElevation);
			pt_this -= (dRowH + 0.5 * d_labelDiam) * paperY + (dRowH + 0.5 * d_labelDiam) * paperX;
			Sheet sh_label = ar_sh_label[n];
			Entity ent_label = (Entity) sh_label;
			int i_zoneIndex = ent_label.myZoneIndex();
			if (i_zoneIndex == 1)
			{
				dpS.color(1);
				ar_sh_dimension.append(sh_label);
			}
			else
			{
				dpS.color(4);
				if (i_foundItalicStyle) dpS.dimStyle(st_dimStyleItalic);
			}
			dpS.draw(st_posnum, pt_this, paperX, paperY, 0, 0);
			PLine pl_label;
			pl_label.createCircle(pt_this, _ZW, 0.5 * d_labelDiam);
			dpS.draw(pl_label);
			dpS.color(-1);
			dpS.dimStyle(stDimStyle);
		}

		i_sheathingQty = ar_sh_display.length() - 1;
	}

	d_sheathingScheduleHeight = (dRowH + dCharL) * ar_st_sheathingInfo.length();
	for (int n; n < ar_d_sheathingColumnLength.length(); ++n) d_sheathingScheduleLength += ar_d_sheathingColumnLength[n];

	//---------------
	//--------------- <PREPARE SHEATHING INFO AND DRAW LABELS> --- end
	//endregion

	//region SET GRIP POINT FOR SHEATHING SCHEDULE
	//--------------- <SET GRIP POINT FOR SHEATHING SCHEDULE> --- start
	//---------------
	int b_sheathingNhardwareOverrun = false;
	if (!b_overrideGrips[1] && !b_memoryGrip[1] || _kNameLastChangedProp == "Max Cut List rows")
	{
		_PtG[1] = ptHzCutList[0] -0.5*dRowH*paperY;
		if (d_sheathingScheduleHeight>0)
		{
			double d_headerHight = (dRowH + 1.5 * dCharL) * (SheetsOnOtherZones == 0 ? 1 : 2);
			double d_columnHeight = dRowH + dCharL;
			PlaneProfile pp_sheathingShedule;
			pp_sheathingShedule.createRectangle(LineSeg(_PtG[1], _PtG[1] + d_sheathingScheduleLength * paperX - (d_columnHeight + d_headerHight + d_sheathingScheduleHeight) * paperY), paperX, paperY);
			if (PlaneProfile(pp_sheathingShedule).intersectWith(PlaneProfile(pp_topAll)) || PlaneProfile(pp_sheathingShedule).intersectWith(PlaneProfile(pp_elevationAll))) b_sheathingNhardwareOverrun = true;
		}
		if ((ar_pt_BP.last()-ar_pt_BP.first()).dotProduct(elX)>12*17 || b_sheathingNhardwareOverrun)
		{
			if (dCutListTableLength[1] > 0) _PtG[1] = ptHzCutList[1] - 0.5 * dRowH * paperY;
			else _PtG[1] = _Pt0 + paperX * (dCutListTableLength[0] + dCharL);
		}
	}

	//---------------
	//--------------- <SET GRIP POINT FOR SHEATHING SCHEDULE> --- end
	//endregion

	//region DRAW SHEATHING SCHEDULE AND DIMENSION OVERHANGS
	//--------------- <DRAW SHEATHING SCHEDULE AND DIMENSION OVERHANGS> --- start
	//---------------

	if (ar_st_sheathingInfo.length()>0)
	{
		double d_headerHight = (dRowH + 1.5 * dCharL) * (SheetsOnOtherZones == 0 ? 1 : 2);
		Point3d pt_scheduleOrigin = _PtG[1]- d_headerHight * paperY;
		double d_columnHeight = dRowH + dCharL;
		Point3d pt_column = pt_scheduleOrigin;
		for (int n; n<ar_d_sheathingColumnLength.length(); ++n)
		{
			String st_columnName = ar_st_sheathingColumnNames[n];
			LineSeg ls_column(pt_column - d_columnHeight * paperY, pt_column + ar_d_sheathingColumnLength[n] * paperX);
			dpS.draw(st_columnName, ls_column.ptMid(), paperX, paperY, 0, 0);
			Point3d pt_value = ls_column.ptStart();
			for (int m; m<ar_st_sheathingInfo.length(); ++m)
			{
				String st_value = ar_st_sheathingInfo[m].token(n, "@");
				dpS.draw(st_value, pt_value + dCharL * paperX - 0.5 * d_columnHeight * paperY, paperX, paperY, 1, 0);
				if (n == 0) dpS.draw(LineSeg(pt_value, pt_value + d_sheathingScheduleLength * paperX));
				pt_value -= d_columnHeight * paperY;
			}
			pt_column = ls_column.ptEnd();
			ls_column = LineSeg(pt_column, pt_column - (d_columnHeight + d_sheathingScheduleHeight) * paperY);
			dpS.draw(ls_column);
		}
		PLine pl_schedule;
		pl_schedule.createRectangle(LineSeg(pt_scheduleOrigin, pt_scheduleOrigin - (d_columnHeight + d_sheathingScheduleHeight) * paperY + d_sheathingScheduleLength * paperX), paperX, paperY);
		dpS.draw(pl_schedule);
		d_sheathingScheduleHeight += d_headerHight +d_columnHeight;
		PLine pl_header;
		pl_header.createRectangle(LineSeg(pt_scheduleOrigin, _PtG[1] + d_sheathingScheduleLength * paperX), paperX, paperY);
		dpS.draw(pl_header);
		dpS.draw(ar_st_gripNames[1], _PtG[1] + 0.5 * d_sheathingScheduleLength * paperX - (SheetsOnOtherZones == 0 ? 0.5 : 0.25) * d_headerHight * paperY, paperX, paperY, 0, 0);
		if (SheetsOnOtherZones>0)
		{
			dpS.color(1);
			dpS.draw(String(SheetsOnOtherZones+" sheets not at selected zone"), pt_scheduleOrigin + dCharL * paperX + 0.25 * d_headerHight * paperY, paperX, paperY, 1, 0);
			dpS.color(2);
		}
	}
	int iSheetDimTop, iSheetDimSide;
	if (ar_sh_dimension.length()>0)
	{
		Point3d ptTopDim = ptTPleftmost;
		ptTopDim.transformBy(csVpElevation);
		ptTopDim += 2 * dRowH * paperY;
		DimLine dlElevationTop(ptTopDim, paperX, paperY);
		dlElevationTop.transformBy(csVpElevationInvert);
		Point3d arPtSheeting[] = dlElevationTop.collectDimPoints(ar_sh_dimension, _kLeftAndRight);
		arPtSheeting = Line(dlElevationTop.ptOrg(), dlElevationTop.vecX()).projectPoints(arPtSheeting);
		arPtSheeting = Line(dlElevationTop.ptOrg(), dlElevationTop.vecX()).orderPoints(arPtSheeting);
		Point3d arPtLimits[] = { ptBPleftmost, ptBPrightmost};
		arPtLimits = Line(dlElevationTop.ptOrg(), dlElevationTop.vecX()).projectPoints(arPtLimits);
		arPtLimits = Line(dlElevationTop.ptOrg(), dlElevationTop.vecX()).orderPoints(arPtLimits);
		if (abs((arPtSheeting[0] -arPtLimits[0]).dotProduct(elX)) > 0.1)
		{
			Dim dmOverhangLeft(dlElevationTop, arPtSheeting[0], arPtLimits[0], _kDimDelta);
			dmOverhangLeft.transformBy(csVpElevation);
			dpElevation.draw(dmOverhangLeft);
			iSheetDimTop = TRUE;
		}
		if (abs((arPtSheeting[arPtSheeting.length()-1] -arPtLimits[1]).dotProduct(elX)) > 0.1)
		{
			Dim dmOverhangRight(dlElevationTop, arPtLimits[1], arPtSheeting[arPtSheeting.length() - 1], _kDimDelta);
			dmOverhangRight.transformBy(csVpElevation);
			dpElevation.draw(dmOverhangRight);
			iSheetDimTop = TRUE;
		}
		Point3d ptSideDim = ptBPleftmost;
		ptSideDim.transformBy(csVpElevation);
		ptSideDim -= iReverseX * 3 * dCharL * paperX + U(3) * paperY;
		DimLine dlElevationSide(ptSideDim, paperY*iReverseX, -paperX*iReverseX);
		dlElevationSide.transformBy(csVpElevationInvert);
		Point3d arPtSideOverhang[] = dlElevationSide.collectDimPoints(ar_sh_dimension, _kLeftAndRight);
		arPtSideOverhang = Line(dlElevationSide.ptOrg(), dlElevationSide.vecX()).projectPoints(arPtSideOverhang);
		arPtSideOverhang = Line(dlElevationSide.ptOrg(), dlElevationSide.vecX()).orderPoints(arPtSideOverhang);
		Point3d arPtSideLimits[] = { ptBPleftmost, ptTPleftmost};
		if (iReverseX < 0) arPtSideLimits.reverse();
		arPtSideLimits = Line(dlElevationSide.ptOrg(), dlElevationSide.vecX()).projectPoints(arPtSideLimits);
		arPtSideLimits = Line(dlElevationSide.ptOrg(), dlElevationSide.vecX()).projectPoints(arPtSideLimits);
		if ( abs((arPtSideOverhang[0]-arPtSideLimits[0]).dotProduct(elY)) >0.1  )
		{
			Dim dmOverhangBottom(dlElevationSide, arPtSideOverhang[0], arPtSideLimits[0], _kDimDelta);
			dmOverhangBottom.transformBy(csVpElevation);
			dpElevation.draw(dmOverhangBottom);
			iSheetDimSide = TRUE;
		}
		if (abs((arPtSideOverhang[arPtSideOverhang.length()-1]-arPtSideLimits[1]).dotProduct(elY)) >0.1)
		{
			Dim dmOverhangTop(dlElevationSide, arPtSideLimits[1], arPtSideOverhang[arPtSideOverhang.length() - 1], _kDimDelta);
			dmOverhangTop.transformBy(csVpElevation);
			dpElevation.draw(dmOverhangTop);
			iSheetDimSide = TRUE;
		}

	}

	//---------------
	//--------------- <DRAW SHEATHING SCHEDULE AND DIMENSION OVERHANGS> --- end
	//endregion

//---------------
//--------------- <SHEATHING> --- end
//endregion


//region DIMENSION BROKEN VTPS OR TPS
//--------------- <DIMENSION BROKEN VTPS OR TPS> --- start
//---------------

Beam ar_bm_brokenTP[0];
if (ar_bm_VTP.length() > 1) ar_bm_brokenTP.append(ar_bm_VTP);
else if (ar_bm_VTP.length() == 0 && ar_bm_TP.length() > 1) ar_bm_brokenTP.append(ar_bm_TP);
if (ar_bm_brokenTP.length()>1)
{
	Point3d ptsTopOrdered[] = Line(el.ptOrg(), elY).orderPoints(ar_pt_TP);
	Point3d ptTopDimX = Plane(ptElCen, elZ).closestPointTo(ptsTopOrdered.last());
	ptTopDimX.transformBy(csVpElevation);
	ptTopDimX += 2 * dRowH * paperY;
	//ptTopDimX.transformBy(csVpElevationInvert);

	DimLine dlElevationBrokenTP(ptTopDimX,paperX, paperY);// elX, elY);
	dlElevationBrokenTP.transformBy(csVpElevationInvert);
	PLine plBeams[0];
	for (int n; n<ar_bm_brokenTP.length(); ++n)
	{
		PlaneProfile ppBm = ar_bm_brokenTP[n].realBody().shadowProfile(Plane(ptElCen, elZ));
		plBeams.append(ppBm.allRings(true, false));
	}
	Point3d ar_pt_brokenTP[0];
	ar_pt_brokenTP.append(dlElevationBrokenTP.collectDimPoints(plBeams, _kLeftAndRight));
	Dim dmElevationTop(dlElevationBrokenTP, ar_pt_brokenTP,"<>", "", _kDimDelta);
	dmElevationTop.transformBy(csVpElevation);
	dpElevation.draw(dmElevationTop);
}

//---------------
//--------------- <DIMENSION BROKEN VTPS OR TPS> --- end
//endregion


//region HARDWARE AND BEAMPOCKETS
//--------------- <HARDWARE AND BEAMPOCKETS> --- start
//---------------

	//region SET GRIP POINT FOR HARDWARE SCHEDULE
	//--------------- <SET GRIP POINT FOR HARDWARE SCHEDULE> --- start
	//---------------

	if (!b_overrideGrips[2] && !b_memoryGrip[2] || _kNameLastChangedProp == "Max Cut List rows")
	{
		_PtG[2] = _PtG[1] - d_sheathingScheduleHeight * paperY - 0.5*dRowH*paperY;
		if ((ar_pt_BP.last()-ar_pt_BP.first()).dotProduct(elX)>12*17 || b_sheathingNhardwareOverrun)
		{
			_PtG[2] = _PtG[1] + (d_sheathingScheduleLength + dCharL) * paperX;
		}
	}

	//---------------
	//--------------- <SET GRIP POINT FOR HARDWARE SCHEDULE> --- end
	//endregion

	//region PREPARE FOR DIMENSIONING
	//--------------- <PREPARE FOR DIMENSIONING> --- start
	//---------------

	double dWallLength = (ptBPrightmost - ptBPleftmost).dotProduct(elX);
	double dWallHeightMin = (ptTPleftmost - ptBPleftmost).dotProduct(elY);
	double dWallHRight = (ptTPrightmost - ptBPrightmost).dotProduct(elY);
	double dWallHeightMax = dWallHeightMin;
	if (dWallHRight < dWallHeightMin) dWallHeightMin = dWallHRight;
	if (dWallHRight > dWallHeightMax) dWallHeightMax = dWallHRight;
	Point3d ptWallCen = ptBPleftmost + 0.5 * dWallLength * elX + 0.5 * dWallHeightMin * elY;
	Point3d ptDimElevationLeft[] = { ptBPleftmost, ptTPleftmost};
	Point3d ptDimElevationRight[] = { ptBPrightmost, ptTPrightmost};
	Point3d ptElevationDimLeft = ptBPleftmost;
	ptElevationDimLeft.transformBy(csVpElevation);
	ptElevationDimLeft -= iReverseX * 4 * dCharL * paperX + U(3) * paperY;
	if (iSheetDimSide == TRUE) ptElevationDimLeft -= iReverseX * 3 * dCharL * paperX;
	Point3d ptElevationDimRight = ptBPrightmost;
	ptElevationDimRight.transformBy(csVpElevation);
	ptElevationDimRight += iReverseX * 4 * dCharL * paperX - U(3) * paperY;

	//---------------
	//--------------- <PREPARE FOR DIMENSIONING> --- end
	//endregion

	//region GET TSL INFO
	//--------------- <GET TSL INFO> --- start
	//---------------

	Beam bmPocket[0];
	int iPocket[0];
	Point3d ptAnchors[0], ptHrdwr[0];
	String arModel[0];
	int arHdwrQty[0];
	TslInst arTSLTemp[0];
	for (int i=0;i<arTSL.length();i++)
	{
		TslInst tsl = arTSL[i];
		if ( ! tsl.bIsValid()) continue;
		if (arTSLTemp.find(tsl) >- 1) continue;
		arTSLTemp.append(tsl);
		String tslName = tsl.scriptName();

		if (tsl.map().hasMap("mpOpening"))
		{
			Map mpBoxOp = tsl.map().getMap("mpOpening");
			if (mpBoxOp.hasPLine("plShape"))
			{
				PLine plBoxOp = mpBoxOp.getPLine("plShape");
				Point3d ptBoxOp[] = plBoxOp.vertexPoints(true);
				for (int k=0; k<ptBoxOp.length(); k++)
				{
					Entity entOp = tsl.blockRef();
					BlockRef brOp = (BlockRef)entOp;
					if (brOp.bIsValid())
					{
						CoordSys csOp = brOp.coordSys();
						ptBoxOp[k].transformBy(csOp);
					}
				}
				Point3d ptX[] = Line(ar_pt_BP.first(), elX).projectPoints(Line(ar_pt_BP.first(), elX).orderPoints(ptBoxOp));
				ptOpeningDim.append(ptX);
				if ((PlaneProfile(plBoxOp).extentInDir(elX).ptMid()-ptWallCen).dotProduct(elX) < 0)
				{
					ptDimElevationLeft.append(Line(ar_pt_BP.first(), elY).projectPoints(Line(ar_pt_BP.first(), elY).orderPoints(ptBoxOp)));
				}
				else
				{
					ptDimElevationRight.append(Line(ptBPrightmost, elY).projectPoints(Line(ptBPrightmost, elY).orderPoints(ptBoxOp)));
				}
			}
		}
		if (tslName == "GE_HDWR_WALL_HOLD_DOWN")
		{
			Point3d ptHoldDown = tsl.ptOrg();
			if ( (ptHoldDown - ptWallCen).dotProduct(elX) < 0 ) ptDimElevationLeft.append(ptHoldDown);
			else ptDimElevationRight.append(ptHoldDown);
		}
		if (tslName == "KT_WALL_NO_STUD_AREA_BLOCKING")
		{
			dpTop.color(1);
			dpBottom.color(1);

			// get display info from _Map
			Map mapDisplay = tsl.map().getMap("TopViewDisplay");

			// Get transform coordSys from XRef
			Entity entXref = tsl.blockRef();
			BlockRef bkXref = (BlockRef) entXref;
			String stXrefDefinition = bkXref.definition();
			if (stXrefDefinition != "" && bkXref.bIsValid())
			{
				mapDisplay.transformBy(bkXref.coordSys());
			}

			// display hatch and PLines
			String strHatchPattern = mapDisplay.getString("strHatchPattern");
			double dHatchScale = mapDisplay.getDouble("dHatchScale") / dScaleElevation;
			double dHatchAngle = mapDisplay.getDouble("dHatchAngle");
			Hatch hatch (strHatchPattern, dHatchScale);
			hatch.setAngle(dHatchAngle);

			for (int m = 0; m < mapDisplay.length(); m++)
			{
				// top VP
				PLine plTop = mapDisplay.getPLine(m);
				plTop.transformBy(csVpTop);
				dpTop.draw(plTop);
				// bottom VP
				PLine plBottom = mapDisplay.getPLine(m);
				plBottom.transformBy(csVpBottom);
				dpBottom.draw(plBottom);

				// hatch
				if (mapDisplay.keyAt(m).makeUpper().find("HATCH", -1) > -1)
				{
					PlaneProfile ppHatchTop = plTop;
					dpTop.draw(ppHatchTop, hatch);

					PlaneProfile ppHatchBottom = plBottom;
					dpBottom.draw(ppHatchBottom, hatch);
				}
			}//next m

			// display text
			String strText = mapDisplay.getString("strText");
			double dTextHeight = mapDisplay.getDouble("dTextHeight") / dScaleElevation;
			Vector3d vecXText =	mapDisplay.getVector3d("vecXText");
			Vector3d vecYText = mapDisplay.getVector3d("vecYText");
			// top VP
			Point3d ptTextTop = tsl.ptOrg();
			ptTextTop.transformBy(csVpTop);
			Vector3d vecXTextTop = vecXText;
			vecXTextTop.transformBy(csVpTop);
			Vector3d vecYTextTop = vecYText;
			vecYTextTop.transformBy(csVpTop);
			dpTop.draw(strText, ptTextTop, vecXTextTop, vecYTextTop, 0, 0, _kDevice);

			// bottom VP
			Point3d ptTextBottom = tsl.ptOrg();
			ptTextBottom.transformBy(csVpBottom);
			Vector3d vecXTextBottom = vecXText;
			vecXTextBottom.transformBy(csVpBottom);
			Vector3d vecYTextBottom = vecYText;
			vecYTextBottom.transformBy(csVpBottom);
			dpBottom.draw(strText, ptTextBottom, vecXTextBottom, vecYTextBottom, 0, 0, _kDevice);

			dpTop.color(-1);
			dpBottom.color(-1);
		}
		if (tslName.makeUpper().find("HANGER", 0) >- 1) continue;

		Map mpTSL = tsl.map();
		if (mpTSL.hasPoint3d("mpAnchorDim\\ptDim"))
		{
			Point3d ptA = mpTSL.getPoint3d("mpAnchorDim\\ptDim");
			Entity entAnchor = tsl.blockRef();
			BlockRef brAnchor = (BlockRef)entAnchor;
			if (brAnchor.bIsValid())
			{
				CoordSys csAnchor = brAnchor.coordSys();
				ptA.transformBy(csAnchor);
			}
			if ( (ptA - ptWallCen).dotProduct(elY) < 0) ptAnchors.append(ptA);
			if (!mpTSL.hasPoint3d("mpSchedule\\ptDim")) continue;
		}
		HardWrComp arHdwrComps[] = tsl.hardWrComps();
		for (int j=0;j<arHdwrComps.length();j++)
		{
			HardWrComp comp = arHdwrComps[j];
			String stModel = comp.model();
			if (stModel.find("Fitting", 0) >-1 || stModel.find("Electrical", 0) >-1 || stModel.find("Nail", 0)>-1) continue;
			if (comp.name().find("Nail", 0) >- 1) continue;
			if (stModel.makeUpper().find("ROD", 0) >- 1 && !mpTSL.hasPoint3d("mpSchedule\\ptDim")) continue;
			int CompQty = comp.quantity();
			String stNotes = comp.notes();
			String stOut = comp.model();
			if(stNotes.length() > 0)stOut += String(" " + stNotes);
			arModel.append(stOut);
			arHdwrQty.append(CompQty);
			if (mpTSL.hasPoint3d("mpSchedule\\ptDim"))
			{
				Point3d ptTSLschedule = mpTSL.getPoint3d("mpSchedule\\ptDim");
				Entity entAnchor = tsl.blockRef();
				BlockRef brAnchor = (BlockRef)entAnchor;
				if (brAnchor.bIsValid())
				{
					CoordSys csAnchor = brAnchor.coordSys();
					ptTSLschedule.transformBy(csAnchor);
				}
				ptHrdwr.append(ptTSLschedule);
			}
			else ptHrdwr.append(tsl.ptOrg());
		}
		if (tslName == "GE_WALL_POCKET")
		{
			if (mpTSL.hasMap("mpBm"))
			{
				Map mpBm = mpTSL.getMap("mpBm");
				int iBms = -1;
				for (int m=0; m<mpBm.length(); m++)
				{
					Entity entBm = mpBm.getEntity(m);
					Beam bmM = (Beam) entBm;
					if (bmM.bIsValid())
					{
						iBms++;
						bmPocket.append(bmM);
					}
				}
				if (iBms >- 1) iPocket.append(iBms);
			}
		}
	}

	//---------------
	//--------------- <GET TSL INFO> --- end
	//endregion

	//region COLLECT DIMENSIONS FROM BEAM POCKETS
	//--------------- <COLLECT DIMENSIONS FROM BEAM POCKETS> --- start
	//---------------

	for (int m=0; m<iPocket.length(); m++)
	{
		Beam bmPockets[0];
		for (int n=(m>0 ? iPocket[m-1]+1 : 0); n<=iPocket[m]; n++){ bmPockets.append(bmPocket[n]);}
		bmPockets = el.vecX().filterBeamsPerpendicularSort(bmPockets);
		if (bmPockets.length() < 2) continue;
		PlaneProfile ppReal;
		for (int n=0; n<bmPockets.length(); n++)
		{
			PlaneProfile ppR = bmPockets[n].realBody().extractContactFaceInPlane(Plane(bmPockets[n].ptCen(), el.vecZ()), 1.1 * 0.5 * bmPockets[n].dD(el.vecZ()));
			ppR.shrink(-1*U(0.1969));
			if (n==0) ppReal = ppR;
			else ppReal.unionWith(ppR);
		}
		ppReal.shrink(U(0.1969));
		PlaneProfile ppExt;
		ppExt.createRectangle(ppReal.extentInDir(el.vecX()), el.vecX(), el.vecY());
		ppExt.subtractProfile(ppReal);
		PLine plPockets[] = ppExt.allRings(true, false);
		for (int n=0; n<plPockets.length(); n++)
		{
			PlaneProfile ppPocket(plPockets[n]);
			LineSeg lsPocket = ppPocket.extentInDir(el.vecX());
			Point3d ptX = lsPocket.ptMid();
			ptX.transformBy(csVpElevation);
			DimLine dlX(ptX, paperX, paperY);
			dlX.transformBy(csVpElevationInvert);
			Dim dmX(dlX, Line(lsPocket.ptMid(), el.vecX()).closestPointTo(lsPocket.ptStart()), Line(lsPocket.ptMid(), el.vecX()).closestPointTo(lsPocket.ptEnd()), "<>");
			dmX.transformBy(csVpElevation);
			dpElevation.draw(dmX);
			LineSeg lsT = lsPocket;
			lsT.transformBy(csVpElevation);
			Point3d ptY = ptX + (2.5 * dCharL + 0.5 * lsT.length()) * paperX;
			DimLine dlY(ptY, paperY, - paperX);
			dlY.transformBy(csVpElevationInvert);
			ptY.transformBy(csVpElevationInvert);
			Dim dmY(dlY, lsPocket.ptStart(), lsPocket.ptEnd(), "<>");
			dmY.transformBy(csVpElevation);
			dpElevation.draw(dmY);

		}
	}

	//DIMENSION STUBBED POSTS
	if (arPainterDefs.find(psFloatingVtDef)>0){
		PainterDefinition pdef(psFloatingVtDef);
		Beam arbmStubbed[] = pdef.filterAcceptedEntities(bmAll); Beam bmUsed[0];
		PlaneProfile ppStubbed; int ppInit = false;
		for (int i=0; i<arbmStubbed.length(); i++) {
			Beam& bmS = arbmStubbed[i];
			if (bmPocket.find(bmS) >= 0) continue;			
			PlaneProfile ppS = bmS.envelopeBody().shadowProfile(plFrontFace);
			PlaneProfile ppGrow(ppS);
			ppGrow.shrink(-1*String("1/16").atof(_kLength));
			if (!ppInit) 
			{
				ppStubbed = ppGrow;
				ppInit = true;
			}
			else 
			{
				ppStubbed.unionWith(ppGrow);
			}
			bmUsed.append(bmS);
		}		
		ppStubbed.simplify();
		PLine rings[] = ppStubbed.allRings( /* bIncludeNoneOpenings */ true, /* bIncludeOpenings */ false);
		for (int i = 0; i < rings.length(); i++)
		{ 
			PlaneProfile ppRing(rings[i]);
			int intersectTestResults[] = 
			{
				PlaneProfile(pp_TPall).intersectWith(ppRing), 
				PlaneProfile(pp_BPall).intersectWith(ppRing)
			};
			ppRing.shrink(String("1/16").atof(_kLength));
			ppRing.simplify();
			Point3d verticies[] = ppRing.getGripVertexPoints();
			verticies.append(verticies[0]);
			Point3d ptRM = ppRing.ptMid();
			
			if (!intersectTestResults[0]){				
				Point3d pointsToDim[0]; 
				for (int n = 1; n < verticies.length(); n++) 
				{
					Point3d& pt2 = verticies[n];
					Point3d& pt1 = verticies[n - 1];
					if (el.vecY().isParallelTo(pt2 - pt1)) continue;
					Point3d ptM = LineSeg(pt2, pt1).ptMid();
					if (el.vecY().dotProduct(ptM - ptRM) < 0) continue;					
					pointsToDim.append(ptM);
				}
				Point3d dimPointsX[] = Line(el.ptOrg(), el.vecX()).orderPoints(pointsToDim);
				Point3d ptL = dimPointsX[0];
				Point3d& ptTP = ptTPleftmost;
				if (abs(el.vecX().dotProduct(ptTP-ptL)) < abs(el.vecX().dotProduct(ptTPrightmost-ptL)))
					ptTP = ptTPrightmost;				
				
				ptL.transformBy(csVpElevation);
				DimLine dlY(ptL, paperY, - paperX);
				dlY.transformBy(csVpElevationInvert);
				
				pointsToDim.append(ptTP);
				Point3d dimPointsY[] = Line(el.ptOrg(), el.vecY()).orderPoints(pointsToDim);
				Dim dmY(dlY, pointsToDim, /*textDelta*/ "<>", /*textChain*/ "", /*dimTypeFlag*/ _kDimDelta);
				dmY.transformBy(csVpElevation);
				dpElevation.draw(dmY);
			}
			if (!intersectTestResults[1]){				
				Point3d pointsToDim[0]; 
				for (int n = 1; n < verticies.length(); n++) 
				{
					Point3d& pt2 = verticies[n];
					Point3d& pt1 = verticies[n - 1];
					if (el.vecY().isParallelTo(pt2 - pt1)) continue;
					Point3d ptM = LineSeg(pt2, pt1).ptMid();
					if (el.vecY().dotProduct(ptM - ptRM) > 0) continue;					
					pointsToDim.append(ptM);
				}
				Point3d dimPointsX[] = Line(el.ptOrg(), el.vecX()).orderPoints(pointsToDim);
				Point3d ptL = dimPointsX[0];
				Point3d& ptBP = ptBPleftmost;
				if (abs(el.vecX().dotProduct(ptBP-ptL)) < abs(el.vecX().dotProduct(ptBPrightmost-ptL)))
					ptBP = ptBPrightmost;				
				
				ptL.transformBy(csVpElevation);
				DimLine dlY(ptL, paperY, - paperX);
				dlY.transformBy(csVpElevationInvert);
				
				pointsToDim.append(ptBP);
				Point3d dimPointsY[] = Line(el.ptOrg(), el.vecY()).orderPoints(pointsToDim);
				Dim dmY(dlY, pointsToDim, /*textDelta*/ "<>", /*textChain*/ "", /*dimTypeFlag*/ _kDimDelta);
				dmY.transformBy(csVpElevation);
				dpElevation.draw(dmY);
			}
			if (psDimFloatVt == sYes) { 
				//check if they are outside and dimension them on bottom view
				Point3d dimPointsX[] = Line(dlBottomViewBeams.ptOrg(), dlBottomViewBeams.vecX()).orderPoints(verticies);
				if (dlBottomViewBeams.vecX().dotProduct(dimPointsX.first()-ptDimBottomBeams.first()) < 0) {
					DimLine dlBottomViewBeams2(dlBottomViewBeams.ptOrg(), - dlBottomViewBeams.vecX(), dlBottomViewBeams.vecY());
					Point3d ptsDim[] = { ptDimBottomBeams.first(), dimPointsX.first()};
					Dim dmBottomBeams(dlBottomViewBeams2, ptsDim, /*textCenter*/ "", /*textEnds*/ "<>", /*flagCenter*/ _kDimNone, /*flagEnds*/ _kDimCumm);
					dmBottomBeams.transformBy(csVpBottom);
					dmBottomBeams.correctTextNormalForViewDirection(csVpBottom.vecZ());
					dpBottom.draw(dmBottomBeams);
				}
				else if (dlBottomViewBeams.vecX().dotProduct(ptDimBottomBeams.last()-dimPointsX.last()) < 0) {
					Point3d ptsDim[] = { ptDimBottomBeams.first(), dimPointsX.last()};
					Dim dmBottomBeams(dlBottomViewBeams, ptsDim, /*textCenter*/ "", /*textEnds*/ "<>", /*flagCenter*/ _kDimNone, /*flagEnds*/ _kDimCumm);
					dmBottomBeams.transformBy(csVpBottom);
					dpBottom.draw(dmBottomBeams);	
				}
				//check if they are outside and dimension them on top view
				dimPointsX = Line(dlTopViewBeams.ptOrg(), dlTopViewBeams.vecX()).orderPoints(verticies);
				if (dlTopViewBeams.vecX().dotProduct(dimPointsX.first()-ptDimTopBeams.first()) < 0) {
					DimLine dlTopViewBeams2(dlTopViewBeams.ptOrg(), - dlTopViewBeams.vecX(), dlTopViewBeams.vecY());
					Point3d ptsDim[] = { ptDimTopBeams.first(), dimPointsX.first()};
					Dim dmTopBeams(dlTopViewBeams2, ptsDim, /*textCenter*/ "", /*textEnds*/ "<>", /*flagCenter*/ _kDimNone, /*flagEnds*/ _kDimCumm);
					dmTopBeams.transformBy(csVpTop);
					dmTopBeams.correctTextNormalForViewDirection(csVpTop.vecZ());
					dpTop.draw(dmTopBeams);
				}
				else if (dlTopViewBeams.vecX().dotProduct(ptDimTopBeams.last()-dimPointsX.last()) < 0) {
					Point3d ptsDim[] = { ptDimTopBeams.first(), dimPointsX.last()};
					Dim dmTopBeams(dlTopViewBeams, ptsDim, /*textCenter*/ "", /*textEnds*/ "<>", /*flagCenter*/ _kDimNone, /*flagEnds*/ _kDimCumm);
					dmTopBeams.transformBy(csVpTop);
					dpTop.draw(dmTopBeams);	
				}
				//draw outlines
				dpBottom.lineType("HIDDEN", 4/dScaleElevation);
				dpTop.lineType("HIDDEN", 4/dScaleElevation);				
				for (int n = 0; n < bmUsed.length(); n++) 
				{
					Beam& bm = bmUsed[n];					
					if (ppRing.pointInProfile(bm.ptCen()) != _kPointInProfile) continue;
					double dBmZ = bm.dD(elZ);
					double dBmX = bm.dD(elX);
					if (bm.vecX().dotProduct(elY)==0) dBmX = bm.dL();
					LineSeg lsOutline(bm.ptCen() + 0.5 * dBmX * elX + 0.5 * dBmZ * elZ, bm.ptCen() - 0.5 * dBmX * elX - 0.5 * dBmZ * elZ);
					if (bmDrawnBottom.find(bm)<0) { 
						LineSeg lsOutBottom = lsOutline;
						lsOutBottom.transformBy(csVpBottom);
						PlaneProfile ppOutline;
						ppOutline.createRectangle(lsOutBottom, paperX, paperY);
						Point3d ptsPpX[] = Line(el.ptOrg(), elX).orderPoints(ppOutline.getGripEdgeMidPoints());
						Point3d ptsPpZ[] = Line(el.ptOrg(), elZ).orderPoints(ppOutline.getGripEdgeMidPoints());						
						dpBottom.draw(ppOutline);
						dpBottom.color(1);
						dpBottom.draw(LineSeg(ptsPpX.first(), ptsPpX.last()));
						dpBottom.draw(LineSeg(ptsPpZ.first(), ptsPpZ.last()));
						dpBottom.color(-1);
					}
					if (bmDrawnTop.find(bm)<0) { 
						LineSeg lsOutTop = lsOutline;
						lsOutTop.transformBy(csVpTop);
						PlaneProfile ppOutline;
						ppOutline.createRectangle(lsOutTop, paperX, paperY);
						Point3d ptsPpX[] = Line(el.ptOrg(), elX).orderPoints(ppOutline.getGripEdgeMidPoints());
						Point3d ptsPpZ[] = Line(el.ptOrg(), elZ).orderPoints(ppOutline.getGripEdgeMidPoints());						
						dpTop.draw(ppOutline);
						dpTop.color(1);
						dpTop.draw(LineSeg(ptsPpX.first(), ptsPpX.last()));
						dpTop.draw(LineSeg(ptsPpZ.first(), ptsPpZ.last()));
						dpTop.color(-1);
					}
				}
				dpBottom.lineType("CONTINIOUS");
				dpTop.lineType("CONTINIOUS");
			}			
		}
	}

	//---------------
	//--------------- <COLLECT DIMENSIONS FROM BEAM POCKETS> --- end
	//endregion

//region DRAW LEFT AND RIGHT ELEVATION DIMENSIONS
//--------------- <DRAW LEFT AND RIGHT ELEVATION DIMENSIONS> --- start
//---------------
if (arptBlockingDim.length()>0 && psBlockingDoDimension==sYes){
	if (psBlockingLineToDim==sYes) {
		dpS.color(253);
		dpS.lineType("DASHED", 0.025);
	}
	for (int k=0; k<arptBlockingDim.length(); k++) {
		Point3d ptK = arptBlockingDim[k];
		int bIsOnLeft = elX.dotProduct(ptK - ptWallCen) < 0;
		(bIsOnLeft ? ptDimElevationLeft : ptDimElevationRight).append(ptK);
		if (psBlockingLineToDim == sYes) {
			ptK.transformBy(csVpElevation);
			dpS.draw(LineSeg(ptK, Line((bIsOnLeft ? ptElevationDimLeft : ptElevationDimRight), paperY).closestPointTo(ptK)));
		}
	}
	if (psBlockingLineToDim == sYes) {
		dpS.color(-1);
		dpS.lineType("ByLayer", 1);
	}
}
DimLine dlElevationLeft(ptElevationDimLeft, -paperY*iReverseX, iReverseX*paperX);
dlElevationLeft.transformBy(csVpElevationInvert);
ptDimElevationLeft = Line(dlElevationLeft.ptOrg(), dlElevationLeft.vecX()).projectPoints(ptDimElevationLeft);
ptDimElevationLeft = Line(dlElevationLeft.ptOrg(), -dlElevationLeft.vecX()*iReverseX).orderPoints(ptDimElevationLeft);
Dim dmElevationLeft(dlElevationLeft, ptDimElevationLeft, "", "<>", _kDimNone, _kDimCumm);
dmElevationLeft.transformBy(csVpElevation);
dmElevationLeft.setReadDirection(paperY);
if (ptDimElevationLeft.length()>2 || b_angledTP) dpElevation.draw(dmElevationLeft);

DimLine dlElevationRight(ptElevationDimRight, paperY*iReverseX, -iReverseX*paperX);
dlElevationRight.transformBy(csVpElevationInvert);
ptDimElevationRight = Line(dlElevationRight.ptOrg(), dlElevationRight.vecX()).projectPoints(ptDimElevationRight);
ptDimElevationRight = Line(dlElevationRight.ptOrg(), dlElevationRight.vecX()*iReverseX).orderPoints(ptDimElevationRight);
Dim dmElevationRight(dlElevationRight, ptDimElevationRight, "", "<>", _kDimNone, _kDimCumm);
dmElevationRight.transformBy(csVpElevation);
dmElevationRight.setReadDirection(paperY);
dpElevation.draw(dmElevationRight);

//---------------
//--------------- <DRAW LEFT AND RIGHT ELEVATION DIMENSIONS> --- end
//endregion

//region DRAW HARDWARE SCHEDULE, STORE INFO IN A MAP
//--------------- <DRAW HARDWARE SCHEDULE, STORE INFO IN A MAP> --- start
//---------------

Map mp_elementHardware;
mp_elementHardware.setMapName("Hardware");
double dHdwrListWidth;
if (arModel.length()>0)
{
	double dModelCheck = dpS.textLengthForStyle(arModel[0], stDimStyle);
	String stMCH = arModel[0];
	stMCH.makeUpper();
	String arWordsBreakUp[] = { "FASTENER", "TOPROD"};
	for (int k = 0; k < arWordsBreakUp.length(); k++)
	{
		int iMCH = stMCH.find(arWordsBreakUp[k], 0);
		if (iMCH >- 1)
		{
			dModelCheck = dpS.textLengthForStyle(stMCH.left(iMCH), stDimStyle);
			double dpMCH = dpS.textLengthForStyle(stMCH.right(stMCH.length() - iMCH), stDimStyle);
			if (k == 1)
			{
				String arRods[] = stMCH.right(stMCH.length() - iMCH).tokenize(",");
				for (int m=0; m<arRods.length(); m++)
				{
					dpMCH = dpS.textLengthForStyle(arRods[m], stDimStyle);
					if (dpMCH > dModelCheck) dModelCheck = dpMCH;
				}
			}
			if (dpMCH > dModelCheck) dModelCheck = dpMCH;
			break;
		}
	}
	for (int i=0; i<arModel.length(); i++)
	{
		double dModelLength = dpS.textLengthForStyle(arModel[i], stDimStyle);
		String stModelH = arModel[i];
		stModelH.makeUpper();
		for (int k = 0; k < arWordsBreakUp.length(); k++)
		{
			int iCheckH = stModelH.find(arWordsBreakUp[k], 0);
			if (iCheckH >- 1)
			{
				dModelLength = dpS.textLengthForStyle(stModelH.left(iCheckH), stDimStyle);
				double dPart = dpS.textLengthForStyle(stModelH.right(stModelH.length() - iCheckH), stDimStyle);
				if (k == 1)
				{
					String arRods[] = stModelH.right(stModelH.length() - iCheckH).tokenize(",");
					for (int m=0; m<arRods.length(); m++)
					{
						dPart = dpS.textLengthForStyle(arRods[m], stDimStyle);
						if (dPart > dModelLength) dModelLength = dPart;
					}
				}

				if (dPart > dModelLength) dModelLength = dPart;
				break;
			}
		}
		if (dModelLength > dModelCheck) dModelCheck = dModelLength;
	}
	double dHdwrListLength = 6 * dCharL + dLabelLength + dQtyLength + dModelCheck;
	dpS.draw(ar_st_gripNames[2], _PtG[2] - (0.75 * dCharL + 0.5*dRowH) * paperY + 0.5 * dHdwrListLength * paperX, paperX, paperY, 0, 0);
	Point3d ptHdwrHzLine = _PtG[2] - (1.5 * dCharL + dRowH) * paperY;
	PLine plHdwrHeaderRec;
	plHdwrHeaderRec.createRectangle(LineSeg(_PtG[2], ptHdwrHzLine + dHdwrListLength * paperX), paperX, paperY);
	dpS.draw(plHdwrHeaderRec);
	Point3d ptTxtY = ptHdwrHzLine - 0.5 * (dCharL + dRowH) * paperY;
	Point3d ptTxtX = ptTxtY;
	dpS.draw("Lab.", ptTxtX+ (dCharL + 0.5 * dLabelLength) * paperX, paperX, paperY, 0, 0);
	ptTxtX += (2 * dCharL + dLabelLength) * paperX;
	dpS.draw("Qty", ptTxtX + (dCharL + 0.5 * dQtyLength) * paperX, paperX, paperY, 0, 0);
	ptTxtX += (2 * dCharL + dQtyLength) * paperX;
	dpS.draw("Model", ptTxtX + (dCharL + 0.5 * dModelCheck) * paperX, paperX, paperY, 0, 0);

	int iLabelHdwr, iRowsH = 0;
	int iHdwrCount = arModel.length() - 1;
	while (iHdwrCount >-1)
	{
		ptTxtY -= (dCharL + dRowH) * paperY;
		Point3d ptHzLine = ptTxtY + 0.5 * (dCharL + dRowH) * paperY;
		dpS.draw(LineSeg(ptHzLine, ptHzLine + dHdwrListLength*paperX));
		Point3d ptHX = ptTxtY + dCharL * paperX;
		String stModelNew = arModel[iHdwrCount];
		arModel.removeAt(iHdwrCount);
		int iHardwareQty = arHdwrQty[iHdwrCount];
		arHdwrQty.removeAt(iHdwrCount);
		Point3d ptLabelNew = ptHrdwr[iHdwrCount];
		ptHrdwr.removeAt(iHdwrCount);
		ptLabelNew.transformBy(csVpElevation);
		iLabelHdwr++;
		iRowsH++;
		String stLabel = "H" + iLabelHdwr;
		dpS.draw(LineSeg(ptLabelNew, ptLabelNew + dRowH * paperX + 1.5 * dRowH * paperY));
		dpS.draw(stLabel, ptLabelNew + 1.5 * dRowH * paperY + 1.25 * dRowH * paperX, paperX, paperY, 1, 1);

		int iFound;
		do
		{
			iFound = arModel.find(stModelNew);
			if (iFound >-1)
			{
				arModel.removeAt(iFound);
				iHardwareQty += arHdwrQty[iFound];
				arHdwrQty.removeAt(iFound);
				Point3d ptLabelSame = ptHrdwr[iFound];
				ptHrdwr.removeAt(iFound);
				ptLabelSame.transformBy(csVpElevation);
				dpS.draw(LineSeg(ptLabelSame, ptLabelSame + dRowH * paperX + 1.5 * dRowH * paperY));
				dpS.draw(stLabel, ptLabelSame + 1.5 * dRowH * paperY + 1.25 * dRowH * paperX, paperX, paperY, 1, 1);
			}
		}
		while (iFound >- 1);

		Map mp_hardwareItem;
		mp_hardwareItem.setString("Label", stLabel);
		mp_hardwareItem.setInt("Qty", iHardwareQty);

		dpS.draw(stLabel, ptHX, paperX, paperY, 1, 0);
		ptHX += (2 * dCharL + dLabelLength) * paperX;
		dpS.draw(String(iHardwareQty), ptHX, paperX, paperY, 1, 0);
		ptHX += (2 * dCharL + dQtyLength) * paperX;
		String stCheckH = stModelNew;
		stCheckH.makeUpper();
		String arWordsBreakUp[] = { "FASTENER", "TOPROD"};
		int iBroken = false;
		for (int k = 0; k < arWordsBreakUp.length(); k++)
		{
			int iCheckH = stCheckH.find(arWordsBreakUp[k], 0);
			if (iCheckH >- 1)
			{
				if (k==1)
				{
					iRowsH++;
					mp_hardwareItem.appendString("Model", stModelNew.left(iCheckH));
					dpS.draw(stModelNew.left(iCheckH), ptHX, paperX, paperY, 1, 0);
					String arRods[] = stModelNew.right(stModelNew.length() - iCheckH).tokenize(",");
					for (int m=0; m<arRods.length(); m++)
					{
						iRowsH++;
						ptHX -= (dCharL + dRowH) * paperY;
						mp_hardwareItem.appendString("Model", arRods[m].trimLeft());
						dpS.draw(arRods[m].trimLeft(), ptHX, paperX, paperY, 1, 0);
						ptTxtY -= (dCharL + dRowH) * paperY;
					}

				}
				else
				{
					iRowsH++;
					mp_hardwareItem.appendString("Model", stModelNew.left(iCheckH));
					dpS.draw(stModelNew.left(iCheckH), ptHX, paperX, paperY, 1, 0);
					ptHX -= (dCharL + dRowH) * paperY;
					mp_hardwareItem.appendString("Model", stModelNew.right(stModelNew.length() - iCheckH));
					dpS.draw(stModelNew.right(stModelNew.length() - iCheckH), ptHX, paperX, paperY, 1, 0);
					ptTxtY -= (dCharL + dRowH) * paperY;
				}
				iBroken = true;
				break;
			}
		}
		if (!iBroken)
		{
			mp_hardwareItem.setString("Model", stModelNew);
			dpS.draw(stModelNew, ptHX, paperX, paperY, 1, 0);
		}
		mp_elementHardware.appendMap("Item", mp_hardwareItem);
		iHdwrCount = arModel.length() - 1;
	}
	PLine plHdwrListRec;
	plHdwrListRec.createRectangle(LineSeg(ptHdwrHzLine, ptHdwrHzLine - (iRowsH + 1) * (dCharL + dRowH) * paperY + dHdwrListLength * paperX), paperX, paperY);
	dpS.draw(plHdwrListRec);
	Point3d ptVtHLine = ptHdwrHzLine + (2 * dCharL + dLabelLength) * paperX;
	dpS.draw(LineSeg(ptVtHLine, ptVtHLine - (iRowsH + 1) * (dCharL + dRowH) * paperY));
	ptVtHLine += (2 * dCharL + dQtyLength) * paperX;
	dpS.draw(LineSeg(ptVtHLine, ptVtHLine - (iRowsH + 1) * (dCharL + dRowH) * paperY));
	dHdwrListWidth = (iRowsH + 2) * (dCharL + dRowH) + 0.5 * dCharL;
}

//---------------
//--------------- <DRAW HARDWARE SCHEDULE, STORE INFO IN A MAP> --- end
//endregion

//---------------
//--------------- <HARDWARE AND BEAMPOCKETS> --- end
//endregion


//region ELECTRICAL
//--------------- <ELECTRICAL> --- start
//---------------

	//region SET GRIP POINT FOR ELECTRICAL SCHEDULE
	//--------------- <SET GRIP POINT FOR ELECTRICAL SCHEDULE> --- start
	//---------------

	 if (arStDrawExcedsLimits.length() > 0) prMoveElectrical.set("No");
	 if (!b_overrideGrips[3] && !b_memoryGrip[3] || _kNameLastChangedProp == "Max Cut List rows")
	 {
	 	if (prMoveElectrical == "No") _PtG[3] = _PtG[2] - dHdwrListWidth * paperY - 0.5 * dRowH * paperY;
		 	else _PtG[3] = _Pt0 + dCutListTableLength[0] * paperX + 0.5 * dRowH * paperX;
	 }

	//---------------
	//--------------- <SET GRIP POINT FOR ELECTRICAL SCHEDULE> --- end
	//endregion

	//region DRAW ELECTRICAL SHEDULE
	//--------------- <DRAW ELECTRICAL SHEDULE> --- start
	//---------------

	MapObject mo("ElectricalItems", "ElectricalItems");
	Map mpMapElectrical = mo.map();
	String stHand = "EL-" + el.handle();
	Map mpBoxes = mpMapElectrical.getMap(stHand);
	TslInst arElectricalTsl[0];
	int arElectricalQty[0];
	Point3d arElectricalPoints[0];
	Point3d arElectricalPointsHzCheck[0];
	String arElectricalHeight[0];
	String arElectricalModels[0];
	for (int i=0;i<mpBoxes.length();i++)
	{
		Entity ent = mpBoxes.getEntity(i);
		TslInst tsl = (TslInst)ent;
		if(!tsl.bIsValid()) continue;
		if (arElectricalTsl.find(tsl) >- 1) continue;
		Map map = tsl.map();
		Entity entEl =map.getEntity("entWall");
		if (!entEl.bIsValid())continue;
		Element elBox = (Element)entEl;
		if (elBox != el)continue;
		if(map.hasString("stName")>0)
		{
			arElectricalTsl.append(tsl);
			arElectricalQty.append(1);
			String stBoxKPN = map.getString("stKPNBox");
			String stName = map.getString("stName").token(0, '.');
			String stModel = tsl.propString(T("|Wall Face|")) + " > ";
			if (stBoxKPN != "") stName += " - " + stBoxKPN;
			stModel += stName;
			arElectricalModels.append(stModel);
			Point3d ptE = tsl.ptOrg();
			double dHeight = (ptE - ptBPleftmost).dotProduct(elY);
			String stHeight;
			stHeight.formatUnit(dHeight, stDimStyle);
			arElectricalHeight.append(stHeight);
			Map mpD = map.getMap("mpDisplay");
			Point3d ptVertex[] = mpD.getPLine(0).vertexPoints(TRUE);
			Point3d ptVertexHz[] = Line(ptE, elX).orderPoints(Line(ptE, elX).projectPoints(ptVertex));
			arElectricalPointsHzCheck.append(ptVertexHz[0]);
			arElectricalPointsHzCheck.append(ptVertexHz[ptVertexHz.length()-1]);
			ptVertex = Line(ptE, elY).projectPoints(ptVertex);
			ptVertex = Line(ptE, elY).orderPoints(ptVertex);
			ptE = ptVertex[ptVertex.length() - 1];
			ptE.transformBy(csVpElevation);
			arElectricalPoints.append(ptE);
			for (int j=0;j<mpD.length();j++)
			{
				PLine plToDraw = mpD.getPLine(j);
				plToDraw.transformBy(csVpElevation);
				dpS.draw(plToDraw);
			}

		}
	}

	if (arElectricalPointsHzCheck.length()>1)
	{
		for (int i=1; i<arElectricalPointsHzCheck.length(); i++)
		{
			Point3d ptCheck[] = { arElectricalPointsHzCheck[i], arElectricalPointsHzCheck[i - 1]};
			if (ppWall.pointInProfile(ptCheck[0]) != _kPointOnRing && ppWall.pointInProfile(ptCheck[1]) != _kPointOnRing)
			{
				ptOpeningDim.append(plFrontFace.closestPointTo(LineSeg(ptCheck[0], ptCheck[1]).ptMid()));
			}
			if (i+2<arElectricalPointsHzCheck.length()) i++;
		}
	}

	double dElectricalListWidth;
	if (arElectricalModels.length() > 0)
	{
		Point3d ptEtextY = _PtG[3] - (2.5 * dRowH + 3 * dCharL) * paperY;
		int iElectricalQty = arElectricalModels.length() - 1;
		int iElectricalLabel = 0;
		double dElectricalCheck = dpS.textLengthForStyle(arElectricalModels[iElectricalQty], stDimStyle);
		double dEScheduleCheck = dpS.textHeightForStyle(arElectricalHeight[iElectricalQty], stDimStyle);
		int iERows = 0;
		while (iElectricalQty >- 1)
		{
			String stModelE = arElectricalModels[iElectricalQty];
			arElectricalModels.removeAt(iElectricalQty);
			double dModelLengthNew = dpS.textLengthForStyle(stModelE, stDimStyle);
			if (dModelLengthNew > dElectricalCheck) dElectricalCheck = dModelLengthNew;
			Point3d ptNew = arElectricalPoints[iElectricalQty];
			arElectricalPoints.removeAt(iElectricalQty);
			String stHeightNew = arElectricalHeight[iElectricalQty];
			arElectricalHeight.removeAt(iElectricalQty);
			iElectricalLabel++;
			String stLabelNew = "E" + iElectricalLabel;
			Point3d ptEtextX = ptEtextY + dCharL * paperX;
			dpS.draw(stLabelNew, ptEtextX, paperX, paperY, 1, 0);
			int iEQty = arElectricalQty[iElectricalQty];
			arElectricalQty.removeAt(iElectricalQty);
			String stLetterNew = arAlphabet[iEQty - 1].makeLower();
			stLabelNew += stLetterNew;
			dpElevation.draw(stLabelNew, ptNew + U(0.01)*paperY, paperX, paperY, 0, 1);
			String stHeights = stLetterNew + ") " + stHeightNew;


			int iFound;
			do
			{
				iFound = arElectricalModels.find(stModelE);
				if (iFound >- 1)
				{
					arElectricalModels.removeAt(iFound);
					iEQty += arElectricalQty[iFound];
					arElectricalQty.removeAt(iFound);
					String stLabelSame = "E" + iElectricalLabel;
					String stLetterSame = arAlphabet[iEQty - 1].makeLower();
					stLabelSame += stLetterSame;
					String stHeightSame = arElectricalHeight[iFound];
					arElectricalHeight.removeAt(iFound);
					stHeights += ", " + stLetterSame + ") " + stHeightSame;
					Point3d ptSame = arElectricalPoints[iFound];
					arElectricalPoints.removeAt(iFound);
					dpElevation.draw(stLabelSame, ptSame+ U(0.01)*paperY, paperX, paperY, 0, 1);

				}
			}
			while (iFound >- 1);
			iElectricalQty = arElectricalModels.length() - 1;
			double dEHeightsLength = dpS.textLengthForStyle(stHeights, stDimStyle);
			if (dEHeightsLength > dEScheduleCheck) dEScheduleCheck = dEHeightsLength;
			iERows++;
			ptEtextX += (2 * dCharL + dLabelLength) * paperX;
			dpS.draw(String(iEQty), ptEtextX, paperX, paperY, 1, 0);
			ptEtextX += (2 * dCharL + dQtyLength) * paperX;
			dpS.draw(stModelE, ptEtextX, paperX, paperY, 1, 0);
			ptEtextY -= (dCharL + dRowH) * paperY;
			dpS.draw(stHeights, ptEtextY + dCharL * paperX, paperX, paperY, 1, 0);
			ptEtextY -= (dCharL + dRowH) * paperY;
		}
		double dScheduleLength = 6 * dCharL + dLabelLength + dQtyLength + dElectricalCheck;
		double dScheduleLengthH = 2 * dCharL + dEScheduleCheck;
		if (dScheduleLengthH > dScheduleLength) dScheduleLength = dScheduleLengthH;
		dpS.draw(ar_st_gripNames[3], _PtG[3] - (0.75 * dCharL + 0.5 * dRowH) * paperY + 0.5 * dScheduleLength * paperX, paperX, paperY, 0, 0);
		PLine plEHeader;
		plEHeader.createRectangle(LineSeg(_PtG[3], _PtG[3] - (1.5 * dCharL + dRowH) * paperY + dScheduleLength * paperX), paperX, paperY);
		dpS.draw(plEHeader);
		Point3d ptEtxtX = _PtG[3] - (2 * dCharL + 1.5 * dRowH) * paperY + dCharL * paperX;
		dpS.draw("Lab.", ptEtxtX+0.5*dLabelLength*paperX, paperX, paperY, 0, 0);
		ptEtxtX += (2 * dCharL + dLabelLength) * paperX;
		dpS.draw("Qty", ptEtxtX+0.5*dQtyLength*paperX, paperX, paperY, 0, 0);
		ptEtxtX += (2 * dCharL + dQtyLength) * paperX;
		dpS.draw("Model", ptEtxtX + 0.5 * dElectricalCheck * paperX, paperX, paperY, 0, 0);
		Point3d ptHzLine = _PtG[3] - (2.5* dCharL + 2 * dRowH) * paperY;
		for (int j=1; j<iERows+1; j++)
		{
			dpS.draw(LineSeg(ptHzLine, ptHzLine + dScheduleLength * paperX));
			Point3d ptVtLine = ptHzLine + (2*dCharL + dLabelLength) * paperX;
			dpS.draw(LineSeg(ptVtLine, ptVtLine - (dCharL + dRowH) * paperY));
			ptVtLine += (2 * dCharL + dQtyLength) * paperX;
			dpS.draw(LineSeg(ptVtLine, ptVtLine - (dCharL + dRowH) * paperY));
			ptHzLine -= (dCharL + dRowH) * paperY;
			dpS.draw(LineSeg(ptHzLine, ptHzLine + dScheduleLength * paperX));
			ptHzLine -= (dCharL + dRowH) * paperY;
		}
		PLine plESchedule;
		plESchedule.createRectangle(LineSeg(_PtG[3] - (1.5 * dCharL + dRowH) * paperY, _PtG[3] - (1.5 * dCharL + dRowH) * paperY - ((iERows * 2) + 1) * (dCharL + dRowH) * paperY + dScheduleLength * paperX), paperX, paperY);
		dpS.draw(plESchedule);
		dElectricalListWidth = dScheduleLength;
	}

	//---------------
	//--------------- <DRAW ELECTRICAL SHEDULE> --- end
	//endregion

	//region DRAW ELEVATION VIEW BOTTOM DIMENSIONS
	//--------------- <DRAW ELEVATION VIEW BOTTOM DIMENSIONS> --- start
	//---------------

	ptOpeningDim = Line(el.ptOrg() - U(6) * elX, elX).orderPoints(ptOpeningDim);
	Point3d ptDimLineOverAll = ptBPleftmost;
	ptDimLineOverAll.transformBy(csVpElevation);
	ptDimLineOverAll = Line(_PtG[0], - paperY).closestPointTo(ptDimLineOverAll - (dCharL + 5.5*dRowH) * paperY);
	if (ptOpeningDim.length()>2)
	{
		DimLine dlOpening(ptDimLineOverAll, paperX, paperY);
		dlOpening.transformBy(csVpElevationInvert);
		ptOpeningDim = Line(dlOpening.ptOrg(), dlOpening.vecX()).projectPoints(ptOpeningDim);
		Dim dmOpening(dlOpening, ptOpeningDim, "<>", "", _kDimDelta);
		dmOpening.transformBy(csVpElevation);
		dpElevation.draw(dmOpening);
		ptDimLineOverAll -= 2.5 * dRowH * paperY;
	}
	DimLine dlElevationBottom(ptDimLineOverAll, paperX, paperY);
	dlElevationBottom.transformBy(csVpElevationInvert);
	Point3d ptElevetaionBottom[] = { ptOpeningDim[0], ptOpeningDim[ptOpeningDim.length()-1]};
	ptElevetaionBottom = Line(dlElevationBottom.ptOrg(), dlElevationBottom.vecX()).projectPoints(ptElevetaionBottom);
	Dim dmElevationBottom(dlElevationBottom, ptElevetaionBottom, "<>", "", _kDimDelta);
	dmElevationBottom.transformBy(csVpElevation);
	dpElevation.draw(dmElevationBottom);

	//---------------
	//--------------- <DRAW ELEVATION VIEW BOTTOM DIMENSIONS> --- end
	//endregion

//---------------
//--------------- <ELECTRICAL> --- end
//endregion


//region PLUMBING
//--------------- <PLUMBING> --- start
//---------------

	//region SET GRIP POINT FOR PLUMBING SCHEDULE
	//--------------- <SET GRIP POINT FOR PLUMBING SCHEDULE> --- start
	//---------------

	if (!b_overrideGrips[4] && !b_memoryGrip[4] || _kNameLastChangedProp == "Max Cut List rows")
	{
		if (prMoveElectrical == "No")
		{
			_PtG[4] = _Pt0+ dCutListTableLength[0] * paperX + 0.5*dRowH*paperX;
			if (arStDrawExcedsLimits.length() > 0)
			{
				_PtG[4] += (dCutListTableLength[1] + dCharL)*paperX;
			}
		}
		else _PtG[4] = _PtG[3] + dElectricalListWidth * paperX + 0.5*dRowH*paperX;
	}

	//---------------
	//--------------- <SET GRIP POINT FOR PLUMBING SCHEDULE> --- end
	//endregion

	//region DRAW PLUMBING SHEDULE
	//--------------- <DRAW PLUMBING SHEDULE> --- start
	//---------------

	MapObject moP("PlumbingItems", "PlumbingItems");
	Map mpPObject = moP.map();
	Map mpPlumbing = mpPObject.getMap("EL-" + el.handle());
	String arPlumbingModels[0];
	String arPlumbingTypes[0];
	String arPlumbingDiameters[0];
	String arPlumbingLength[0];
	Point3d arPlumbingPoints[0];
	String arPlumbingCombined[0];
	int iPlumbingColor = 1;
	TslInst arPlTsls[0];
	Point3d ptPlumbingEnds[0];
	for (int i=0;i<mpPlumbing.length();i++)
	{
		Entity entPlumbing = mpPlumbing.getEntity(i);
		TslInst tsl = (TslInst)entPlumbing;
		if ( ! tsl.bIsValid()) continue;
		Element elPlumbing = (Element)entPlumbing;
		//if (elPlumbing != el) continue;
		if (arPlTsls.find(tsl) >- 1) continue;
		Map mpTSL = tsl.map();
		Point3d ptP = plFrontFace.closestPointTo(tsl.ptOrg());
		if (mpTSL.hasMap("mpPipe"))
		{
			arPlTsls.append(tsl);
			String stModel = mpTSL.getString("stName");
			arPlumbingModels.append(stModel);
			arPlumbingTypes.append("Pipe");
			String stDiameter = mpTSL.getDouble("dDiameter") + "\"";
			arPlumbingDiameters.append(stDiameter);
			String stLength;
			stLength.formatUnit(mpTSL.getDouble("dLength"), stDimStyle);
			arPlumbingLength.append(stLength);
			arPlumbingPoints.append(ptP);
			arPlumbingCombined.append(String("Pipe"+"@"+stModel+"@"+stDiameter+"@"+stLength));
			Map mpPlines = mpTSL.getMap("mpPipe");
			Point3d endPoints[] = { plFrontFace.closestPointTo(mpPlines.getPLine(0).ptMid()), plFrontFace.closestPointTo(mpPlines.getPLine(mpPlines.length() - 1).ptMid())};
			ptPlumbingEnds.append(Line(ptBPleftmost, elY).orderPoints(endPoints));
			for (int j=0;j<mpPlines.length();j++)
			{
				PLine plPipe = mpPlines.getPLine(j);
				plPipe.transformBy(csVpElevation);
				dpS.color(iPlumbingColor);
				dpS.draw(plPipe);
			}
			iPlumbingColor++;
		}
		if (mpTSL.hasMap("mpFittings"))
		{
			arPlTsls.append(tsl);
			String stModel;
			String stKPN;
			if (mpTSL.hasString("stKPN")) stKPN= mpTSL.getString("stKPN");
			if (stKPN == "") stModel = mpTSL.getString("stName");
			arPlumbingModels.append(stModel);
			arPlumbingTypes.append("Fitting");
			String stDiameter = mpTSL.getDouble("dDiameter") + "\"";
			arPlumbingDiameters.append(stDiameter);
			arPlumbingLength.append(" ");
			arPlumbingPoints.append(ptP);
			arPlumbingCombined.append(String("Fitting" + "@" + stModel + "@" + stDiameter));
		}
	}
	dpS.color(-1);

	if (arPlumbingModels.length() > 0)
	{
		bmStuds = elX.filterBeamsPerpendicularSort(bmStuds);
		Beam bmStudbay[0];
		for (int n=0; n<ptPlumbingEnds.length(); n++)
		{
			Point3d ptN = ptPlumbingEnds[n];
			for (int m=1; m<bmStuds.length(); m++)
			{
				Beam bmR = bmStuds[m];
				Beam bmL = bmStuds[m - 1];
				if ( (ptN-bmL.ptCen()).dotProduct(elX)*(ptN-bmR.ptCen()).dotProduct(elX)<0)//edit here
				{
					if (bmStudbay.find(bmL) == -1) bmStudbay.append(bmL);
					if (bmStudbay.find(bmR) == -1) bmStudbay.append(bmR);
				}
			}
		}
		bmStudbay = elX.filterBeamsPerpendicularSort(bmStudbay);
		Point3d ptPlumbingMids[0];
		Point3d ptPlumbingLimitsLeft[0];
		Point3d ptPlumbingLimitsRight[0];
		for (int n=1; n<bmStudbay.length(); n++)
		{
			Beam bmR = bmStudbay[n];
			Beam bmL = bmStudbay[n - 1];
			Point3d ptInStudBay[0];
			for (int m=0; m<ptPlumbingEnds.length(); m++)
			{
				Point3d ptM = ptPlumbingEnds[m];
				if ( (ptM-bmL.ptCen()).dotProduct(elX)*(ptM-bmR.ptCen()).dotProduct(elX)<0)//edit here
				{
					ptInStudBay.append(ptM);
					//ptPlumbingEnds.removeAt(m);
				}
			}
			if (ptInStudBay.length() > 0)
			{
				Point3d ptByHight[] = Line(ptBPleftmost, elY).projectPoints(ptInStudBay);
				ptByHight = Line(ptBPleftmost, elY).orderPoints(ptByHight);
				Point3d ptProjected[] = Line(ptBPleftmost, elX).projectPoints(ptInStudBay);
				ptProjected = Line(ptBPleftmost, elX).orderPoints(ptProjected);
				Point3d ptMidHight;
				ptMidHight.setToAverage(ptByHight);
				Point3d ptMidAvarage;
				ptMidAvarage.setToAverage(ptProjected);
				ptMidAvarage = Line(ptByHight.length()>2 ? ptByHight[1] : ptByHight[0], elX).closestPointTo(ptMidAvarage);//edit here
				ptMidAvarage.transformBy(U(1.5) * elY);
				Point3d ptDown[0];
				for (int h = 0; h < ptInStudBay.length(); h++)
				{
					Point3d ptH = ptInStudBay[h];
					if ( (ptMidAvarage - ptH).dotProduct(elY) > 0 ) { ptDown.append(ptH); }
				}
				ptDown = Line(ptBPleftmost, elX).projectPoints(ptDown);
				ptDown = Line(ptBPleftmost, elX).orderPoints(ptDown);
				ptMidAvarage.setToAverage(ptDown);
				ptPlumbingMids.append(ptMidAvarage);
				ptPlumbingLimitsLeft.append(plFrontFace.closestPointTo(bmL.ptCen()));
				ptPlumbingLimitsRight.append(plFrontFace.closestPointTo(bmR.ptCen()));
			}
		}
		ptPlumbingMids = plFrontFace.projectPoints(ptPlumbingMids);
		double dPlumbingModelCheck = dpS.textLengthForStyle(arPlumbingModels[0], stDimStyle);
		double dPlumbingLengthCheck = dpS.textLengthForStyle(arPlumbingLength[0], stDimStyle);
		for (int i=0;i<arPlumbingModels.length();i++)
		{
			double dPlumbingModelLength = dpS.textLengthForStyle(arPlumbingModels[i], stDimStyle);
			double dPlumbingLength = dpS.textLengthForStyle(arPlumbingLength[i], stDimStyle);
			if (dPlumbingModelLength > dPlumbingModelCheck) dPlumbingModelCheck = dPlumbingModelLength;
			if (dPlumbingLength > dPlumbingLengthCheck) dPlumbingLengthCheck = dPlumbingLength;
		}
		double dFittingLength = dpS.textLengthForStyle("Fitting", stDimStyle);
		double dSizeLength = dpS.textLengthForStyle("Diam.", stDimStyle);
		double dPlumbingScheduleLength = 12 * dCharL + dFittingLength + dPlumbingModelCheck + dLabelLength + dQtyLength + dSizeLength + dPlumbingLengthCheck;
		dpS.draw(ar_st_gripNames[4], _PtG[4] - (0.75 * dCharL + 0.5 * dRowH) * paperY + 0.5 * dPlumbingScheduleLength * paperX, paperX, paperY, 0, 0);


		dpS.draw(LineSeg(_PtG[4] - (1.5 * dCharL + dRowH) * paperY, _PtG[4] - (1.5 * dCharL + dRowH) * paperY + dPlumbingScheduleLength * paperX));
		String stPlumbingNote1 = " *Install plumbing with 12\" between item and top\\bottom plates";
		dpS.draw(stPlumbingNote1, _PtG[4] - (2 * dCharL + dRowH) * paperY + dCharL * paperX, paperX, paperY, 1, -1);
		String stPlumbingNote2 = " *Support spacing NOT to exceed 3' per clamp";
		dpS.draw(stPlumbingNote2, _PtG[4] - (3 * dCharL + 2*dRowH) * paperY + dCharL * paperX, paperX, paperY, 1, -1);


		PLine plPlumbingHeader;
		plPlumbingHeader.createRectangle(LineSeg(_PtG[4], _PtG[4] - (3.5 * dCharL + 3*dRowH) * paperY + dPlumbingScheduleLength * paperX), paperX, paperY);
		dpS.draw(plPlumbingHeader);
		Point3d ptTitleY = _PtG[4] - (3.5 * dCharL + 4 * dRowH) * paperY + dCharL * paperX;
		dpS.draw("Type", ptTitleY + 0.5 * dFittingLength*paperX, paperX, paperY, 0, 0);
		Point3d ptTitleX = ptTitleY + (2 * dCharL + dFittingLength) * paperX;
		dpS.draw("Description", ptTitleX + 0.5 * dPlumbingModelCheck * paperX, paperX, paperY, 0, 0);
		ptTitleX += (2 * dCharL + dPlumbingModelCheck) * paperX;
		dpS.draw("Lab.", ptTitleX + 0.5 * dLabelLength * paperX, paperX, paperY, 0, 0);
		ptTitleX += (2 * dCharL + dLabelLength) * paperX;
		dpS.draw("Qty", ptTitleX + 0.5 * dQtyLength * paperX, paperX, paperY, 0, 0);
		ptTitleX += (2 * dCharL + dQtyLength) * paperX;
		dpS.draw("Diam.", ptTitleX + 0.5 * dSizeLength * paperX, paperX, paperY, 0, 0);
		ptTitleX += (2 * dCharL + dSizeLength) * paperX;
		dpS.draw("Length", ptTitleX + 0.5 * dPlumbingLengthCheck * paperX, paperX, paperY, 0, 0);
		Point3d ptHzLine = _PtG[4] - (4.5 * dCharL + 4 * dRowH) * paperY;
		arPlumbingPoints = plFrontFace.projectPoints(arPlumbingPoints);
		int PlumbingStacks[0];
		Point3d ptPlumbingToLabel[0];
		String stPlumbingLabels[0];

		int iPRows = 0;
		int iPLabel = 0;
		int iPQty = arPlumbingCombined.length() - 1;
		while (iPQty>-1)
		{
			String stCombined = arPlumbingCombined[iPQty];
			arPlumbingCombined.removeAt(iPQty);
			iPLabel++;
			iPRows++;
			Point3d ptLabelNew = arPlumbingPoints[iPQty];
			arPlumbingPoints.removeAt(iPQty);
			String stType = arPlumbingTypes[iPQty];
			arPlumbingTypes.removeAt(iPQty);
			String stModel = arPlumbingModels[iPQty];
			arPlumbingModels.removeAt(iPQty);
			String stDiam = arPlumbingDiameters[iPQty];
			arPlumbingDiameters.removeAt(iPQty);
			String stLength = arPlumbingLength[iPQty];
			arPlumbingLength.removeAt(iPQty);
			String stLabel = iPLabel;
			int iSameQty = 1;
			int iFound;
			Point3d ptsLabelSort[0];
			ptsLabelSort.append(ptLabelNew);
			do
			{
				iFound = arPlumbingCombined.find(stCombined);
				if (iFound>-1)
				{
					arPlumbingCombined.removeAt(iFound);
					Point3d ptLabelSame = arPlumbingPoints[iFound];
					arPlumbingPoints.removeAt(iFound);
					arPlumbingTypes.removeAt(iFound);
					arPlumbingModels.removeAt(iFound);
					arPlumbingDiameters.removeAt(iFound);
					arPlumbingLength.removeAt(iFound);
					ptsLabelSort.append(ptLabelSame);
					iSameQty++;
				}
			}
			while (iFound >- 1);
			int iPtsSorted = ptsLabelSort.length()-1;

			while (iPtsSorted>-1)
			{
				Point3d ptNew = ptsLabelSort[iPtsSorted];
				ptsLabelSort.removeAt(iPtsSorted);
				int iSorted = 1;
				int iFoundSorted;
				do
				{
					iFoundSorted = ptsLabelSort.find(ptNew);
					if (iFoundSorted >-1)
					{
						ptsLabelSort.removeAt(iFoundSorted);
						iSorted++;
					}
				}
				while (iFoundSorted >- 1);

				String stLabelSame = stLabel;
				if (iSorted > 1) stLabelSame += String("(x" + iSorted + ")");
				ptPlumbingToLabel.append(ptNew);
				stPlumbingLabels.append(stLabelSame);
				for (int k=0; k<ptPlumbingLimitsLeft.length(); k++)
				{
					Point3d ptLeft = ptPlumbingLimitsLeft[k];
					Point3d ptRight = ptPlumbingLimitsRight[k];
					if ( (ptNew-ptLeft).dotProduct(elX)*(ptNew-ptRight).dotProduct(elX)<0 ) PlumbingStacks.append(k);//edit here
				}
				iPtsSorted = ptsLabelSort.length() - 1;
			}


			dpS.draw(LineSeg(ptHzLine, ptHzLine + dPlumbingScheduleLength*paperX));
			Point3d ptPlumbingText = ptHzLine - 0.5 * (dCharL + dRowH) * paperY + dCharL * paperX;
			dpS.draw(stType, ptPlumbingText, paperX, paperY, 1, 0);
			ptPlumbingText += (2 * dCharL + dFittingLength) * paperX;
			dpS.draw(stModel, ptPlumbingText, paperX, paperY, 1, 0);
			ptPlumbingText += (2 * dCharL + dPlumbingModelCheck) * paperX;
			dpS.draw(stLabel, ptPlumbingText, paperX, paperY, 1, 0);
			ptPlumbingText += (2 * dCharL + dLabelLength) * paperX;
			dpS.draw(String(iSameQty), ptPlumbingText, paperX, paperY, 1, 0);
			ptPlumbingText += (2 * dCharL + dQtyLength) * paperX;
			dpS.draw(stDiam, ptPlumbingText, paperX, paperY, 1, 0);
			ptPlumbingText += (2 * dCharL + dSizeLength) * paperX;
			dpS.draw(stLength, ptPlumbingText, paperX, paperY, 1, 0);

			iPQty = arPlumbingCombined.length() - 1;
			ptHzLine -= (dCharL + dRowH) * paperY;
		}
		Point3d ptVt = _PtG[4] - (3.5 * dCharL + 3*dRowH) * paperY;
		PLine plPlumbingSchedule;
		plPlumbingSchedule.createRectangle(LineSeg(ptVt, ptVt - (iPRows + 1) * (dCharL + dRowH) * paperY + dPlumbingScheduleLength * paperX), paperX, paperY);
		dpS.draw(plPlumbingSchedule);
		ptVt += (2 * dCharL + dFittingLength) * paperX;
		dpS.draw(LineSeg(ptVt, ptVt - (iPRows + 1) * (dCharL + dRowH) * paperY));
		ptVt += (2 * dCharL + dPlumbingModelCheck) * paperX;
		dpS.draw(LineSeg(ptVt, ptVt - (iPRows + 1) * (dCharL + dRowH) * paperY));
		ptVt += (2 * dCharL + dLabelLength) * paperX;
		dpS.draw(LineSeg(ptVt, ptVt - (iPRows + 1) * (dCharL + dRowH) * paperY));
		ptVt += (2 * dCharL + dQtyLength) * paperX;
		dpS.draw(LineSeg(ptVt, ptVt - (iPRows + 1) * (dCharL + dRowH) * paperY));
		ptVt += (2 * dCharL + dSizeLength) * paperX;
		dpS.draw(LineSeg(ptVt, ptVt - (iPRows + 1) * (dCharL + dRowH) * paperY));

		double dStaggerVt = 1.5*dpS.textHeightForStyle("(", stDimStyle);
		for (int m=0; m<ptPlumbingMids.length(); m++)
		{
			Point3d ptToLabelLeft[0];
			Point3d ptToLabelRight[0];
			String stLabelsLeft[0];
			String stLabelsRight[0];
			for(int n=0; n<PlumbingStacks.length(); n++)
			{
				if (PlumbingStacks[n] == m)
				{
					Point3d ptN = ptPlumbingToLabel[n];
					if ((ptPlumbingMids[m]-ptN).dotProduct(elX)>=0)
					{
						ptToLabelLeft.append(ptN);
						stLabelsLeft.append(stPlumbingLabels[n]);
					}
					if ((ptPlumbingMids[m]-ptN).dotProduct(elX)<0)
					{
						ptToLabelRight.append(ptN);
						stLabelsRight.append(stPlumbingLabels[n]);
					}
				}
			}
			Point3d ptTempLeft[] = Line(ptBPleftmost, elY).orderPoints(ptToLabelLeft);
			double distLeft[0];
			distLeft.append(U(0));
			if (ptTempLeft.length() > 0)
			{
				for (int h = 1; h < ptTempLeft.length(); h++)
				{
					Point3d ptUp = ptTempLeft[h];
					Point3d ptDown = ptTempLeft[h - 1];
					int Found = ptToLabelLeft.find(ptUp);
					String stLabel = stLabelsLeft[Found];
					ptUp.transformBy(csVpElevation);
					ptDown.transformBy(csVpElevation);
					double diff = (ptUp - ptDown).dotProduct(paperY) - distLeft[h - 1];
					Point3d ptLabel = ptUp - 2 * dCharL * paperX;
					if (diff < dStaggerVt)
					{
						if ( abs((ptUp - ptDown).dotProduct(elX)) < dCharL)
						{
							distLeft.append(dStaggerVt - diff);
							ptLabel.transformBy((dStaggerVt - diff) * paperY);
						}
						else
						{
							distLeft.append(0.5 * dRowH);
							ptLabel.transformBy(0.5 * dRowH * paperY);
						}
					}
						else distLeft.append(U(0));
						dpS.draw(LineSeg(ptUp, ptLabel));
						dpS.draw(stLabel, ptLabel - 0.5 * dCharL * paperX, paperX, paperY, - 1, 0);
					}

				Point3d ptFirstLeft = ptTempLeft[0];
				ptFirstLeft.transformBy(csVpElevation);
				dpS.draw(LineSeg(ptFirstLeft, ptFirstLeft - 2 * dCharL * paperX));
				dpS.draw(stLabelsLeft[ptToLabelLeft.find(ptTempLeft[0])], ptFirstLeft - 2.5 * dCharL * paperX, paperX, paperY, - 1, 0);
			}
			Point3d ptTempRight[] = Line(ptBPleftmost, elY).orderPoints(ptToLabelRight);
			double distRight[0];
			distRight.append(U(0));
			if (ptTempRight.length() > 0)
			{
				for (int h = 1; h < ptTempRight.length(); h++)
				{
					Point3d ptUp = ptTempRight[h];
					Point3d ptDown = ptTempRight[h - 1];
					int Found = ptToLabelRight.find(ptUp);
					String stLabel = stLabelsRight[Found];
					ptUp.transformBy(csVpElevation);
					ptDown.transformBy(csVpElevation);
					double diff = (ptUp - ptDown).dotProduct(paperY) - distRight[h - 1];
					Point3d ptLabel = ptUp + 2 * dCharL * paperX;
					if (diff < dStaggerVt)
					{
						if ( abs((ptUp - ptDown).dotProduct(elX)) < dCharL)
						{
							distRight.append(dStaggerVt - diff);
							ptLabel.transformBy((dStaggerVt - diff) * paperY);
						}
						else
						{
							distRight.append(0.5 * dRowH);
							ptLabel.transformBy(0.5 * dRowH * paperY);
						}
					}
						else distRight.append(U(0));
						dpS.draw(LineSeg(ptUp, ptLabel));
						dpS.draw(stLabel, ptLabel + 0.5 * dCharL * paperX, paperX, paperY, 1, 0);
				}
				Point3d ptFirstRight = ptTempRight[0];
				ptFirstRight.transformBy(csVpElevation);
				dpS.draw(LineSeg(ptFirstRight, ptFirstRight + 2 * dCharL * paperX));
				dpS.draw(stLabelsRight[ptToLabelRight.find(ptTempRight[0])], ptFirstRight + 2.5 * dCharL * paperX, paperX, paperY, 1, 0);
			}
		}
	}

	//---------------
	//--------------- <DRAW PLUMBING SHEDULE> --- end
	//endregion

//---------------
//--------------- <PLUMBING> --- end
//endregion


//region PENETRATIONS
//--------------- <PENETRATIONS> --- start
//---------------

	//region PENETRATIONS SCHEDULE
	//--------------- <PENETRATIONS SCHEDULE> --- start
	//---------------

	{
		if (!b_overrideGrips[5] && !b_memoryGrip[5]) _PtG[5] = _Map.getPoint3d("pntLegend") + (U(18) - 0.25 * dCharL) * paperX;
		Point3d pt_scheduleOrigin = _PtG[5];
		String ar_st_columnNames[] = { "Lab.", "Diam.", "No.", "Ordinal pos."};
		double ar_d_columnWidth[0];
		for (int n; n < ar_st_columnNames.length(); ++n) ar_d_columnWidth.append(2*dCharL+dpS.textLengthForStyle(ar_st_columnNames[n], stDimStyle));
		String ar_st_scheduleInfo[0];
		String st_penetrationSymbol = "o";//"ø"
		////BP
		{
			Point3d ar_pt_drill[0];
			String ar_st_drillInfo[0];
			String ar_st_beamInfo[0];
			for (int n; n < ar_bm_BP.length(); ++n)
			{
				AnalysedDrill ar_drill[] = AnalysedDrill().filterToolsOfToolType(ar_bm_BP[n].analysedTools());
				for (int m; m<ar_drill.length(); ++m)
				{
					String st_info = String().formatUnit(ar_drill[m].dDiameter(), stDimStyle) + "@" + "H: " + String().formatUnit((ar_drill[m].ptStart() - ar_pt_BP.first()).dotProduct(elX), stDimStyle);
					String st_beamLabel = ar_st_beamLabels[ar_st_beamHandles.find(ar_bm_BP[n].handle())];
					int i_find = ar_st_drillInfo.find(st_info);
					if (i_find<0)
					{
						ar_pt_drill.append(ar_drill[m].ptStart());
						ar_st_drillInfo.append(st_info);
						ar_st_beamInfo.append(st_beamLabel);
					}
					else
					{
						String ar_st_recordedLabels[] = ar_st_beamInfo[i_find].tokenize(",");
						if (ar_st_recordedLabels.find(st_beamLabel) < 0) ar_st_beamInfo[i_find] = ar_st_beamInfo[i_find] + "," + st_beamLabel;
					}
				}
			}
			for (int n; n<ar_st_drillInfo.length(); ++n) ar_st_drillInfo[n] = ar_st_drillInfo[n].token(0, "@") + "@" + ar_st_beamInfo[n] + "@" + ar_st_drillInfo[n].token(1, "@");
			Point3d ar_pt_drillSorted[] = Line(ar_pt_BP.first(), elX).orderPoints(ar_pt_drill);
			for (int n; n<ar_pt_drillSorted.length(); ++n)
			{
				LineSeg ls_draw(Plane(ar_pt_BP.first(), elY).closestPointTo(ar_pt_drillSorted[n]), Plane(ar_pt_BP.first(), elY).closestPointTo(ar_pt_drillSorted[n])+0.5*el.dBeamWidth()*elZ);
				ls_draw.transformBy(csVpBottom);
				ls_draw = LineSeg(ls_draw.ptStart(), ls_draw.ptEnd() + 0.5 * dRowH*paperY);
				dpBottom.draw(ls_draw);
				String st_label = st_penetrationSymbol+(n+1);
				dpBottom.draw(st_label, ls_draw.ptEnd()+0.25*dRowH*paperY, paperY, -paperX, 1, 0);
				ar_st_scheduleInfo.append(st_label + "@" + ar_st_drillInfo[ar_pt_drill.find(ar_pt_drillSorted[n])]);
			}
		}
		//TP
		{
			Point3d ar_pt_drill[0];
			String ar_st_drillInfo[0];
			String ar_st_beamInfo[0];
			for (int n; n < ar_bm_TP.length(); ++n)
			{
				AnalysedDrill ar_drill[] = AnalysedDrill().filterToolsOfToolType(ar_bm_TP[n].analysedTools());
				for (int m; m<ar_drill.length(); ++m)
				{
					String st_info = String().formatUnit(ar_drill[m].dDiameter(), stDimStyle) + "@" + "H: " + String().formatUnit((ar_drill[m].ptStart() - ar_pt_BP.first()).dotProduct(elX), stDimStyle);
					String st_beamLabel = ar_st_beamLabels[ar_st_beamHandles.find(ar_bm_TP[n].handle())];
					int i_find = ar_st_drillInfo.find(st_info);
					if (i_find<0)
					{
						ar_pt_drill.append(ar_drill[m].ptStart());
						ar_st_drillInfo.append(st_info);
						ar_st_beamInfo.append(st_beamLabel);
					}
					else
					{
						String ar_st_recordedLabels[] = ar_st_beamInfo[i_find].tokenize(",");
						if (ar_st_recordedLabels.find(st_beamLabel) < 0) ar_st_beamInfo[i_find] = ar_st_beamInfo[i_find] + "," + st_beamLabel;
					}
				}
			}
			for (int n; n<ar_st_drillInfo.length(); ++n) ar_st_drillInfo[n] = ar_st_drillInfo[n].token(0, "@") + "@" + ar_st_beamInfo[n] + "@" + ar_st_drillInfo[n].token(1, "@");
			Point3d ar_pt_drillSorted[] = Line(ar_pt_BP.first(), elX).orderPoints(ar_pt_drill);
			int i_scheduleCount = ar_st_scheduleInfo.length()>0 ? ar_st_scheduleInfo.last().token(0, "@").token(1, st_penetrationSymbol).atoi() : 0;
			for (int n; n<ar_pt_drillSorted.length(); ++n)
			{
				LineSeg ls_draw(Plane(ar_pt_BP.first(), elY).closestPointTo(ar_pt_drillSorted[n]), Plane(ar_pt_BP.first(), elY).closestPointTo(ar_pt_drillSorted[n])-0.5*el.dBeamWidth()*elZ);
				ls_draw.transformBy(csVpTop);
				ls_draw = LineSeg(ls_draw.ptStart(), ls_draw.ptEnd() + (2.5*dCharL+0.5 * dRowH)*paperY);
				dpTop.draw(ls_draw);
				String st_label = st_penetrationSymbol+(i_scheduleCount+n+1);
				dpTop.draw(st_label, ls_draw.ptEnd()+0.25*dRowH*paperY, paperY, -paperX, 1, 0);
				ar_st_scheduleInfo.append(st_label + "@" + ar_st_drillInfo[ar_pt_drill.find(ar_pt_drillSorted[n])]);
			}
		}
		//VT
		{
			Point3d ar_pt_drill[0];
			String ar_st_drillInfo[0];
			String ar_st_beamInfo[0];
			Beam ar_bm_VTcheck[] = elX.filterBeamsPerpendicularSort(el.beam());
			for (int n; n<ar_bm_VTcheck.length(); ++n)
			{
				if (ar_bm_VTcheck[n].bIsDummy() || ar_bm_VTcheck[n].type() == _kDummyBeam) continue;
				AnalysedDrill ar_drill[] = AnalysedDrill().filterToolsOfToolType(ar_bm_VTcheck[n].analysedTools());
				for (int m; m<ar_drill.length(); ++m)
				{
					String st_info = String().formatUnit(ar_drill[m].dDiameter(), stDimStyle) + "@" + "V: " + String().formatUnit((ar_drill[m].ptStart() - ar_pt_BP.first()).dotProduct(elY), stDimStyle);
					String st_beamLabel = ar_st_beamLabels[ar_st_beamHandles.find(ar_bm_VTcheck[n].handle())];
					int i_find = ar_st_drillInfo.find(st_info);
					if (i_find<0)
					{
						ar_pt_drill.append(ar_drill[m].ptStart());
						ar_st_drillInfo.append(st_info);
						ar_st_beamInfo.append(st_beamLabel);
					}
					else
					{
						String ar_st_recordedLabels[] = ar_st_beamInfo[i_find].tokenize(",");
						if (ar_st_recordedLabels.find(st_beamLabel) < 0) ar_st_beamInfo[i_find] = ar_st_beamInfo[i_find] + "," + st_beamLabel;
					}
				}
			}
			for (int n; n<ar_st_drillInfo.length(); ++n) ar_st_drillInfo[n] = ar_st_drillInfo[n].token(0, "@") + "@" + ar_st_beamInfo[n] + "@" + ar_st_drillInfo[n].token(1, "@");
			Point3d ar_pt_drillSorted[] = Line(ar_pt_BP.first(), elY).orderPoints(ar_pt_drill);
			int i_scheduleCount = ar_st_scheduleInfo.length() > 0 ? ar_st_scheduleInfo.last().token(0, "@").token(1, st_penetrationSymbol).atoi() : 0;
			for (int n; n<ar_pt_drillSorted.length(); ++n)
			{
				LineSeg ls_draw(Plane(ar_pt_BP.first(), elX).closestPointTo(ar_pt_drillSorted[n]), Plane(ar_pt_BP.first(), elX).closestPointTo(ar_pt_drillSorted[n])-0.5*el.dBeamWidth()*elX);
				ls_draw.transformBy(csVpElevation);
				ls_draw = LineSeg(ls_draw.ptStart(), ls_draw.ptEnd() - 0.5 * dRowH*paperX);
				dpElevation.draw(ls_draw);
				String st_label = st_penetrationSymbol+(i_scheduleCount+n+1);
				dpElevation.draw(st_label, ls_draw.ptEnd()-0.25*dRowH*paperX, paperX, paperY, -1, 0);
				ar_st_scheduleInfo.append(st_label + "@" + ar_st_drillInfo[ar_pt_drill.find(ar_pt_drillSorted[n])]);
			}
		}
		////OTHER
		{
			Point3d ar_pt_drillVT[0], ar_pt_drillOther[0];
			String ar_st_drillInfoVT[0], ar_st_drillInfoOther[0];
			String ar_st_genbeamInfoVT[0], ar_st_genbeamInfoOther[0];

			GenBeam ar_gbm_all[] = el.genBeam();
			//reportMessage("\n genbeams: " + ar_gbm_all.length());
			for (int n; n < ar_gbm_all.length(); ++n)
			{
				GenBeam gbm_n = ar_gbm_all[n];
				if (gbm_n.bIsKindOf(Sheet())) { if (gbm_n.myZoneIndex() == 0) continue;	}
				else { if (gbm_n.vecX().isPerpendicularTo(elX) || ar_bm_BP.find(gbm_n)>-1 || ar_bm_TP.find(gbm_n)>-1) continue;}
				AnalysedDrill ar_drill[] = AnalysedDrill().filterToolsOfToolType(gbm_n.analysedTools());
				String st_genbeamLabel = gbm_n.bIsKindOf(Beam()) ? ar_st_beamLabels[ar_st_beamHandles.find(gbm_n.handle())] : gbm_n.posnum();
				for (int m; m<ar_drill.length(); ++m)
				{
					Point3d pt_drill = LineSeg(ar_drill[m].ptStartExtreme(), ar_drill[m].ptEndExtreme()).ptMid();
					int b_VTdrill = ar_drill[m].vecZ().isParallelTo(elY);
					String st_info = String().formatUnit(ar_drill[m].dDiameter(), stDimStyle) + "@" +
					"H: " + String().formatUnit((pt_drill - ar_pt_BP.first()).dotProduct(elX), stDimStyle) +
					(b_VTdrill ? "" : " V: " + String().formatUnit((pt_drill - ar_pt_BP.first()).dotProduct(elY), stDimStyle));

					int i_find = (b_VTdrill ? ar_st_drillInfoVT : ar_st_drillInfoOther).find(st_info);
					if (i_find<0)
					{
						(b_VTdrill ? ar_pt_drillVT : ar_pt_drillOther).append(pt_drill);
						(b_VTdrill ? ar_st_drillInfoVT : ar_st_drillInfoOther).append(st_info);
						(b_VTdrill ? ar_st_genbeamInfoVT : ar_st_genbeamInfoOther).append(st_genbeamLabel);
					}
					else
					{
						String ar_st_recordedLabels[] = (b_VTdrill ? ar_st_genbeamInfoVT : ar_st_genbeamInfoOther)[i_find].tokenize(",");
						if (ar_st_recordedLabels.find(st_genbeamLabel) < 0) (b_VTdrill ? ar_st_genbeamInfoVT : ar_st_genbeamInfoOther)[i_find] += "," + st_genbeamLabel;
					}
				}
			}
			for (int n; n<ar_st_drillInfoVT.length(); ++n) ar_st_drillInfoVT[n] = ar_st_drillInfoVT[n].token(0, "@") + "@" + ar_st_genbeamInfoVT[n] + "@" + ar_st_drillInfoVT[n].token(1, "@");
			Point3d ar_pt_drillSortedVT[] = Line(ar_pt_BP.first(), elX).orderPoints(ar_pt_drillVT);
			int i_scheduleCount = ar_st_scheduleInfo.length() > 0 ? ar_st_scheduleInfo.last().token(0, "@").token(1, st_penetrationSymbol).atoi() : 0;
			for (int n; n<ar_pt_drillSortedVT.length(); ++n)
			{
				LineSeg ls_draw(ar_pt_drillSortedVT[n], ar_pt_drillSortedVT[n]+U(1)*elY);
				ls_draw.transformBy(csVpElevation);
				ls_draw = LineSeg(ls_draw.ptStart(), ls_draw.ptEnd() + 0.5 * dRowH*paperY);
				dpElevation.draw(ls_draw);
				String st_label = st_penetrationSymbol + (i_scheduleCount + n + 1);
				dpElevation.draw(st_label, ls_draw.ptEnd() + 0.25 * dRowH * paperY, paperX, paperY, 0, 1);
				ar_st_scheduleInfo.append(st_label + "@" + ar_st_drillInfoVT[ar_pt_drillVT.find(ar_pt_drillSortedVT[n])]);
			}
			for (int n; n<ar_st_drillInfoOther.length(); ++n) ar_st_drillInfoOther[n] = ar_st_drillInfoOther[n].token(0, "@") + "@" + ar_st_genbeamInfoOther[n] + "@" + ar_st_drillInfoOther[n].token(1, "@");
			Point3d ar_pt_drillSortedOther[] = Line(ar_pt_BP.first(), elX).orderPoints(ar_pt_drillOther);
			i_scheduleCount = ar_st_scheduleInfo.length() > 0 ? ar_st_scheduleInfo.last().token(0, "@").token(1, st_penetrationSymbol).atoi() : 0;
			for (int n; n<ar_pt_drillSortedOther.length(); ++n)
			{
				LineSeg ls_draw(Plane(el.ptOrg(), el.vecZ()).closestPointTo(ar_pt_drillSortedOther[n]), Plane(el.ptOrg(), el.vecZ()).closestPointTo(ar_pt_drillSortedOther[n])+U(0.01)*elY);
				ls_draw.transformBy(csVpElevation);
				ls_draw = LineSeg(ls_draw.ptStart(), ls_draw.ptEnd() + 0.5 * dRowH*(-paperY-paperX));
				dpElevation.draw(ls_draw);
				String st_label = st_penetrationSymbol + (i_scheduleCount + n + 1);
				dpElevation.draw(st_label, ls_draw.ptEnd() + 0.125 * dRowH * (-paperY-paperX), paperX, paperY, -1, -1);
				ar_st_scheduleInfo.append(st_label + "@" + ar_st_drillInfoOther[ar_pt_drillOther.find(ar_pt_drillSortedOther[n])]);
			}

		}

		//schedule
		{
			if (ar_st_scheduleInfo.length()>0)
			{
				dRowH *= 1.85;
				double ar_d_scheduleSizes[] = { 0, (1.25 + ar_st_scheduleInfo.length() + 1) * dRowH};
				for (int n; n < ar_d_columnWidth.length(); ++n)
				{
					for (int m; m<ar_st_scheduleInfo.length(); ++m)
					{
						double d_columnWidth = 2*dCharL+dpS.textLengthForStyle(ar_st_scheduleInfo[m].token(n, "@"), stDimStyle);
						if (d_columnWidth > ar_d_columnWidth[n]) ar_d_columnWidth[n] = d_columnWidth;
					}
					ar_d_scheduleSizes[0] += ar_d_columnWidth[n];
				}
				Point3d pt_txtDrawY = pt_scheduleOrigin - ar_d_scheduleSizes[0] * paperX + ar_d_scheduleSizes[1] * paperY;
				PLine pline_outline;
				pline_outline.createRectangle(LineSeg(pt_scheduleOrigin, pt_txtDrawY), paperX, paperY);
				dpS.draw(pline_outline);
				pt_txtDrawY -= 0.5 * 1.25 * dRowH * paperY;
				dpS.draw(ar_st_gripNames[5], pt_txtDrawY + 0.5 * ar_d_scheduleSizes[0] * paperX, paperX, paperY, 0, 0);
				pt_txtDrawY -= 0.5 * 1.25 * dRowH * paperY;
				dpS.draw(LineSeg(pt_txtDrawY, pt_txtDrawY + ar_d_scheduleSizes[0] * paperX));
				Point3d pt_txtDrawX = pt_txtDrawY;
				for (int n; n<ar_st_columnNames.length(); ++n)
				{
					if (n > 0) dpS.draw(LineSeg(pt_txtDrawX, pt_txtDrawX - (ar_d_scheduleSizes[1] - 1.25 * dRowH) * paperY));
					pt_txtDrawX += 0.5 * ar_d_columnWidth[n] * paperX;
					dpS.draw(ar_st_columnNames[n], pt_txtDrawX - 0.5 * dRowH * paperY, paperX, paperY, 0, 0);
					pt_txtDrawX += 0.5 * ar_d_columnWidth[n] * paperX;
				}
				pt_txtDrawY -= (1 + 0.5) * dRowH * paperY;

				for (int n; n < ar_st_scheduleInfo.length(); ++n)
				{
					pt_txtDrawX = pt_txtDrawY;
					dpS.draw(LineSeg(pt_txtDrawX + 0.5 * dRowH * paperY, pt_txtDrawX + ar_d_scheduleSizes[0] * paperX + 0.5 * dRowH * paperY));
					String ar_st_draw[] = ar_st_scheduleInfo[n].tokenize("@");
					for (int m; m<ar_st_draw.length(); ++m)
					{
						dpS.draw(ar_st_draw[m], pt_txtDrawX+dCharL*paperX, paperX, paperY, 1, 0);
						pt_txtDrawX += ar_d_columnWidth[m]*paperX;
					}
					pt_txtDrawY -= dRowH * paperY;
				}
			}

		}

	}

	//---------------
	//--------------- <PENETRATIONS SCHEDULE> --- end
	//endregion

//---------------
//--------------- <PENETRATIONS> --- end
//endregion


//region RECORD XREF CONTENT
//--------------- <RECORD XREF CONTENT> --- start
//---------------

if (st_elementXrefHandle != "" && mp_elementContent.length()>0)
{
	Map mp_Xref;
	if (mp_EntityInfo.hasMap(st_elementXrefHandle)) mp_Xref = mp_EntityInfo.getMap(st_elementXrefHandle);
	mp_Xref.setMap(el.handle(), mp_elementContent);
	if (mp_elementHardware.length() > 0) mp_Xref.setMap(el.handle() + "Hardware", mp_elementHardware);
	mp_EntityInfo.setMap(st_elementXrefHandle, mp_Xref);
	mo_EntityInfo.setMap(mp_EntityInfo);

}
else
{
	if (mp_elementHardware.length() > 0) el.setSubMapX("Hardware", mp_elementHardware);
}
//---------------
//--------------- <RECORD XREF CONTENT> --- end
//endregion





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
      <str nm="Comment" vl="Aded property to draw and dimension floating members on bottom and top views" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="81" />
      <str nm="Date" vl="10/24/2024 12:21:06 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Added property to specify formats for opening tags" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="80" />
      <str nm="Date" vl="7/10/2023 11:35:39 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Added property to use posnum during sorting and labeling" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="79" />
      <str nm="Date" vl="4/24/2023 12:19:18 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Added PLY to actual size grades" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="77" />
      <str nm="Date" vl="5/5/2022 9:43:07 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Added PSL to actual sizes grades" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="76" />
      <str nm="Date" vl="5/2/2022 2:09:18 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Corrected text direction of dimlines for reversed elevation viewport" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="75" />
      <str nm="Date" vl="4/9/2022 3:56:46 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Corrected left right elevation dims and sheathing overhangs for reverse elevation viewport" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="74" />
      <str nm="Date" vl="4/6/2022 2:31:43 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Corrected broken vtp dimension for reversed elevation viewport" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="73" />
      <str nm="Date" vl="4/5/2022 4:04:12 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Changed top and bottom view coordsys to respect elevation viewport coordsys" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="72" />
      <str nm="Date" vl="3/23/2022 9:19:51 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Added option to add vertical dimension of beams that are not touching bottom or top plates" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="71" />
      <str nm="Date" vl="2/8/2022 11:44:13 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Fixed bug with back hatch pattern scale" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="69" />
      <str nm="Date" vl="10/12/2021 9:52:05 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Added option to show full tag at opening center (default: No) --Added option to show opening assembly number (default: No) --Added option to scale hatching legend (default: 1.0)" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="68" />
      <str nm="Date" vl="10/4/2021 11:13:26 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Set flat beams distinction method to hatching, removed other options. Added hatching legend control point and r-click trigger. Made initial penetration list control point relative to legend. Added settings to adjust top and bottom view dimension lines" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="65" />
      <str nm="Date" vl="8/5/2021 10:19:01 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End