#Version 8
#BeginDescription
#Versions:
Version 1.18 27/06/2025 HSB-21424: Fix number of screwes , Author Marsel Nakuci
Version 1.17 26.06.2025 HSB-21424: ALU MIDI add H400 and H440 
1.16 29.08.2023 HSB-21656: ALU Mini extended
1.15 29.08.2023 HSB-19683: Add property for the Slot alignment 
Version 1.14 09.02.2023 HSB-17890 dimension alu maxi corrected

   This Tsl creates the Rothoblass ALU connector (AluMini, AluMidi, AluMaxi)
   It supports Aluminum alloy retractable junctions for outdoor and indoor use. Use for 90 degree and 
   vertically inclined joints

   Data sheets can be obtained at www.rothoblaas.com














#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 18
#KeyWords Connector;Hanger,Rothoblaas,ALU,Slot
#BeginContents
/// History
/// #Versions:
// 1.18 27/06/2025 HSB-21424: Fix number of screwes , Author Marsel Nakuci
// 1.17 26.06.2025 HSB-21424: ALU MIDI add H400 and H440 , Author: Marsel Nakuci
// 1.16 29.08.2023 HSB-21656: ALU Mini extended, RoS
// 1.15 29.08.2023 HSB-19683: Add property for the Slot alignment Author: Marsel Nakuci
// 1.14 09.02.2023 HSB-17890 dimension alu maxi corrected , Author Thorsten Huck
// 1.13 07.06.2022 HSB-15516: increase depth for full height slot Author: Marsel Nakuci
// 1.12 02.06.2022 HSB-15516: fix slot for rotated beams Author: Marsel Nakuci
// Version 1.11 13.09.2021 HSB-12982: add property "Depth" for the drill; add command "flip drill side" to flip drill side Author: Marsel Nakuci
// Version 1.10 13.09.2021 HSB-12984: fix bug when creating housing Author: Marsel Nakuci
///<version value="1.9" date="21jan2021" author="nils.gregor@hsbcad.com"> Bugfix vis cuttingBody </version>
///<version value="1.8" date="04oct2019" author="thorsten.huck@hsbcad.com"> HSB-5539 hardware output generalized </version>
///<version value="1.7" date="18sept2019" author="thorsten.huck@hsbcad.com"> HSB-5626 slot alignment fixed, properties categorized </version>
///<version  value="1.6" date="28jul15" author="florian.wuermseer@hsbcad.com"> vectors corrected</version>
///<version  value="1.5" date="18jul14" author="th@hsbCAD.de"> insertion more tolerant to potential inaccuracy: slightly non perpendicular connections are accepted</version>
///<version  value="1.4" date="03aug12" author="th@hsbCAD.de"> slot extends only slightly beam dimensions</version>
///<version  value="1.3" date="26jun12" author="th@hsbCAD.de"> house tools extend only slightly beam dimensions</version>
/// Version 1.2   th@hsbCAD.de   03.05.2010
/// new option 'full height' for housing
/// gap of housing fixed to all directions
/// slot depth on non perpendicular connections fixed
/// Version 1.1   th@hsbCAD.de   28.04.2010
/// bugfix invalid alignment
/// bugfix dwg unit text height description
/// Version 1.0   th@hsbCAD.de   01.04.2010
/// initial

/// <summary Lang=en>
/// This Tsl creates the Rothoblass ALU connector (AluMini, AluMidi, AluMaxi)
/// It supports Aluminum alloy retractable junctions for outdoor and indoor use. Use for 90 degree and
/// vertically inclined joints
/// Technical data sheets can be obtained at www.rothoblaas.com
/// </summary>

/// <insert=en>
/// The family preselection is done by a catalog entry which contains the family name as part of the 
/// catalog name. The catalog names 'MINI', 'MIDI' and 'MAXI' are reserved for the standard behaviour of
/// the hsbContent. If the TSL is called with a catalog entry other than the reserved ones no dialog will be shown.
/// Select one or multiple male beams and then a set of female beams
/// </insert>

/// <remark=en>
/// NOTE: If the family (AluMini, AluMidi, AluMaxi) is not preset by the usage of a catalog entry the tsl will use
/// the AluMidi as default. One can use the context command of other family names to change the family once the
/// bracket is inserted.
/// </remark>

/// <remark=en>
/// Sample command to insert a AluMini with dialog. Catalog entry must not be present.
///    ^C^C(hsb_scriptinsert "Rothoblass Alu" "Mini")
/// Sample command to insert a AluMidi with dialog. Catalog entry must not be present.
///    ^C^C(hsb_scriptinsert "Rothoblass Alu" "Midi")
/// Sample command to insert a AluMaxi with dialog. Catalog entry must not be present.
///    ^C^C(hsb_scriptinsert "Rothoblass Alu" "Maxi")
/// Sample command to insert a AluMini without dialog. Catalog entry must be present and should contain the 
/// appropriate settings for the type 185 with no shank holes etc.
///    ^C^C(hsb_scriptinsert "Rothoblass Alu" "Mini185 no holes")
/// </remark>

/// <property name="Type" Lang=en>
/// Sets the type of the bracket. If the type is set to 'auto detect' the tsl will detect the largest possible connector.
/// </property>

/// <property name="Shank Drills" Lang=en>
/// Distinguishes between brackets which have drills on the shank or not.
/// </property>

/// <property name="Connector Mode" Lang=en>
/// The different family types (AluMini, AluMidi, AluMaxi) are supporting various types of hardware which could be
/// attached to the bracket. The quantity and size of the attached hardware is dependent on the mounting scheme.
/// A connection to a pillar will receive a partial nailing, while other connections will receive a total nailing.
/// </property>

/// <command name="MINI" Lang=en>
/// This command will be available if the current family is not named as the command name.
/// This command will change the family type to the name of the command name. The type then used will be detected
/// automatically.
/// </command>

/// <command name="MIDI" Lang=en>
/// This command will be available if the current family is not named as the command name.
/// This command will change the family type to the name of the command name. The type then used will be detected
/// automatically.
/// </command>

/// <command name="MAXI" Lang=en>
/// This command will be available if the current family is not named as the command name.
/// This command will change the family type to the name of the command name. The type then used will be detected
/// automatically.
/// </command>

/// <command name="Extend length to be cut from rod" Lang=en>
/// This command will extend the list of available types to maximum length of the available rod. After using
/// this command you can select all incicions through the OPM.
/// </command>


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
//end Constants//endregion

// preselect family by execute key or map
	int bAllIncicions= _Map.getInt("allIncicions");
	String sArFamily[] = {"MINI","MIDI","MAXI"};
	String sFamily = _Map.getString("family").makeUpper();
	int nFamily = sArFamily.find(sFamily);

// if the family could not be distiguished and a catalog entry is send as exekuteKey store the family in the map
	if (nFamily <0 && (!_bOnRecalc && _kExecuteKey!=""))//sArFamily.find(sExecuteKey.makeUpper())>-1)
	{
		for (int i = 0; i < sArFamily.length(); i++)
			if (_kExecuteKey.makeUpper().find(sArFamily[i],0)>-1)
			{
				nFamily = i;
				_Map.setString("family",sFamily = sArFamily[i]);	
				break;		
			}
	}
	
// default midi if nothing found
	if (nFamily<0)
		nFamily = 1;
	sFamily = sArFamily[nFamily];
	
// set the opm name by family
	setOPMKey(sFamily);
	

// type properties Mini/Midi/Maxi
	double dArThickness1[] = {U(6),U(6),U(10)}; 			//Thickness s1 [mm]
	double dArThickness2[] = {U(6),U(6),U(12)}; 			//Thickness s2 [mm]
	double dArZ[] = {U(30),U(40),U(64)}; 					//Height H [mm]
//	double dArMinZ[] =  {U(65),U(120),U(384)};
	double dArMinZ[] =  {U(65),U(80),U(384)};// HSB-21424
	double dArDeltaZ[]=  {U(30),U(40),U(64)}; 
//	double dArMaxZ[] =  {U(215),U(360),U(896)};
	double dArMaxZ[] =  {U(215),U(440),U(896)};// HSB-21424
	double dArMaxZRod[] =  {U(215),U(2200),U(2176)}; 
	double dArLa[] =  {U(45),U(80),U(130)}; 					//Width LA [mm]
	double dArLb[] =  {U(109.9),U(109.4),U(172)}; 			//Steglange LB [mm]
	
	double dArDiam1[] =  {U(7),U(5),U(7.5)}; 					//Small Holes Diameter [mm]	
	double dArDiamNail1[] =  {U(5),U(4),U(6)}; 				//Small Holes Fixings Diameter [mm]
	String sArFixing1[] ={T("|HBS+ Screw|"),T("|Anker nail|"),T("|Anker nail|")};  
//	int nArFixing1BaseQty[]={7,12,24};							// the base qty of the nails, incremented by selected type
	int nArFixing1BaseQty[]={7,10,24};	// HSB-21424						// the base qty of the nails, incremented by selected type
	int nArFixing1IncrementQty[]={4,4,8};					// the increment per type	

	double dArDiam2[] =  {U(0),U(9),U(17)};					// big holes	
	double dArDiamNail2[] =  {U(0),U(8),U(16)}; 			// 
	double dArLengthNail2[] =  {U(0),U(110),U(150)};
	String sArFixing2[] ={"",T("|Chemical dowel|"),T("|Chemical dowel|")}; //dowel will be replaced with screw for mode 1 on a Midi
	int nArFixing2BaseQty[]={0,3,6};							// the base qty of the screws, incremented by selected type
	int nArFixing2IncrementQty[]={0,1,2};					// the increment per type		
	
	//Shank holes fastening 
	double dArDiam3[] =  {U(0),U(13),U(17)};					
	double dArDiamNail3[] =  {U(0),U(12),U(16)}; 			//Shank holes fastening Diameter [mm]	
	double dArXDr0[] = {0,U(23.4),U(33)};		
	String sArFixing3[] ={T("|Pin|"),T("|Pin|"),T("|Pin|")};
	int nArFixing3BaseQty[]={0,3,6};							// the base qty of the screws, incremented by selected type
	int nArFixing3IncrementQty[]={0,1,2};					// the increment per type	 
	
	//Shank fastening no drills			
	double dArDiamNail4[] =  {U(5),U(7),U(7)}; 			//Shank fastening no drills Diameter [mm]	
	String sArFixing4[] ={T("|Self-perforating pin|"),T("|Self-perforating pin|"),T("|Self-perforating pin|")};
//	int nArFixing4BaseQty[]={2,2,3};							// the base qty of the screws, incremented by selected type
	int nArFixing4BaseQty[]={2,3,3};	// HSB-21424						// the base qty of the screws, incremented by selected type
	int nArFixing4IncrementQty[]={1,1,1};					// the increment per type	 

	
// Wing width LA [mm] 80 130
// Bracket - External edge aL [mm] = 10 = 15
// Bracket - Bracket aM [mm] = 0 -
// 1 bracket - Minimum beam width (2) B,NT [mm] 100 (3) 160 (4)
// 2 brackets - Minimum beam width (2) B,NT [mm] 180 -

	String sArType[0];
	sArType.append(T("|Auto detect|"));	
	double dThisZ = dArMinZ[nFamily];
	double dThisMaxZ = dArMaxZ[nFamily];
	if (bAllIncicions) dThisMaxZ = dArMaxZRod[nFamily];
	while (dThisZ<=dThisMaxZ)
	{
		String s;
		s.formatUnit(dThisZ/U(1,"mm"),2,0);
		sArType.append(s);	
		dThisZ+=dArDeltaZ[nFamily];
	}

	PropString sType(1, sArType, T("|Type|"));
	sType.setDescription(T("|Sets the type of the bracket.|"));
	sType.setCategory(category);
	
	// HSB-12982
//	PropString sShankDrills(5, sNoYes, T("|Shank Drills|"));
//	sShankDrills.setCategory(category);
	if(_ThisInst.hasPropString(5))
	{ 
//		String sss = _ThisInst.propString(5);
		PropString sShankDrills(5, sNoYes, T("|Shank Drills|"));
		sShankDrills.set(sNoYes[1]);
		sShankDrills.setReadOnly(_kHidden);
	}
	
	category = T("|Shank Drills|");
	String sDepthName=T("|Depth|");	
	PropDouble dDepth(8, U(0), sDepthName);	
	dDepth.setDescription(T("|Defines the Depth of the drill. Negative value changes the side of the drilling|"));
	dDepth.setCategory(category);
	
	category = T("|General|");
	// family dependent connection modes
	String sArMiniMode[] = {T("|Wood/Wood|")};
	String sArMidiMode[] = {T("|Wood/Wood|"),T("|Wood/Concrete|") + " " + T("|with Screw|"),T("|Wood/Concrete|") + " " + T("|with chemical Dowel|")};
	String sArMaxiMode[] = {T("|Wood/Wood|"),T("|Wood/Concrete|") + " " + T("|with chemical Dowel|")};
	String sArMode[0];
	if (nFamily==0)sArMode=sArMiniMode;
	else if (nFamily==2)sArMode=sArMaxiMode;
	else sArMode=sArMidiMode;
	String sPropS0=T("|Connection Mode|");
	PropString sMode(3, sArMode,sPropS0 );
	sMode.setCategory(category);

	category = T("|Alignment|");
	String sGapBetweenName=T("|Gap between Beams|");	
	PropDouble dGapBetween(nDoubleIndex++, U(3), sGapBetweenName);	
	dGapBetween.setDescription(T("|Defines the GapBetween|"));
	dGapBetween.setCategory(category);

	String sZOffsetName=T("|Offset Z-Direction|");	
	PropDouble dZOffset(nDoubleIndex++, U(0), sZOffsetName);	
	dZOffset.setDescription(T("|Defines the Z-Offset|"));
	dZOffset.setCategory(category);

	category = T("|Housing|");
	String sArHousing[] = { T("|Bottom|"), T("|Centered|"), T("|Top|"), T("|Full Height|"), T("|None|")};	
	PropString sHousing(2,sArHousing, T("|Housing Type|"));
	sHousing.setCategory(category);
	
	String sGapHouseName=T("|Gap|");	
	PropDouble dGapHouse(nDoubleIndex++, U(0), sGapHouseName);	
	dGapHouse.setDescription(T("|Describes the gap around the metalpart of the housing|"));
	dGapHouse.setCategory(category);

	String sExtraHouseDepthName=T("|Extra depth|");	
	PropDouble dExtraHouseDepth(nDoubleIndex++, U(0), sExtraHouseDepthName);	
	dExtraHouseDepth.setDescription(T("|Describes the additional depth of the beamcut|"));
	dExtraHouseDepth.setCategory(category);

	category = T("|Slot|");
	String sArSlot[] = { T("|Top|"), T("|Bottom|"), T("|Full height|")};
	PropString sSlot(4,sArSlot,T("|Slot|"));
	sSlot.setDescription(T("|Describes the location of the slot|"));
	sSlot.setCategory(category);
	
	PropDouble dGapSlotX(5,U(20),T("|Gap|") + " (X)");
	dGapSlotX.setDescription(T("|Describes the additional length of the slot|"));
	dGapSlotX.setCategory(category);
	
	PropDouble dGapSlotY(6,U(2),T("|Gap|") + " (Y)");
	dGapSlotX.setDescription(T("|Describes the additional width of the slot|"));
	dGapSlotY.setCategory(category);
	
	PropDouble dGapSlotZ(7,U(20),T("|Gap|") + " (Z)");
	dGapSlotX.setDescription(T("|Describes the additional height of the slot|"));
	dGapSlotZ.setCategory(category);
	// HSB-19683
	String sAlignmentSlotName=T("|Alignment|");
	String sAlignmentSlots[]={T("|Female beam|"),T("|Male beam|")};
	PropString sAlignmentSlot(6,sAlignmentSlots,sAlignmentSlotName);	
	sAlignmentSlot.setDescription(T("|Defines the Slot alignment|"));
	sAlignmentSlot.setCategory(category);
	
	category=T("|Display|");					
	PropInt nColor(0,252, T("|Color|"));
	nColor.setCategory(category);
	
	PropString sDimStyle(0, _DimStyles, T("|Dimstyle|"));
	sDimStyle.setCategory(category);
	
	String sManufacturer = "Rothoblaas";

// on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }

		// show the dialog if no catalog in use
		if (_kExecuteKey == "" || sArFamily.find(_kExecuteKey.makeUpper())>-1)
		{
			showDialog();		
			//Map map = mapWithPropValues();
		}
		// set properties from catalog		
		else	
			setPropValuesFromCatalog(_kExecuteKey);	

	// collect the entities			
		PrEntity ssMale(T("|Select male beam(s)|"), Beam());
		Beam bmMale[0];
		if (ssMale.go())
			bmMale= ssMale.beamSet();

		PrEntity ssFemale(T("|Select female beam(s)|"), Beam());
		Beam bmFemale[0];
		if (ssFemale.go())
			bmFemale= ssFemale.beamSet();
		
		
	// declare the tsl props
		TslInst tslNew;
		Vector3d vUcsX = _XW;
		Vector3d vUcsY = _YW;
		Beam bmAr[0];
		Entity entAr[0];
		Point3d ptAr[0];
		int nArProps[0];
		double dArProps[0];
		String sArProps[0];
		Map mapTsl;
		String sScriptname = scriptName();		

		mapTsl.setString("family",_Map.getString("family"));

	// loop males and females
		for (int i = 0; i < bmMale.length(); i++)
		{
			bmAr.setLength(0);	
			bmAr.append(bmMale[i]);
			
			// filter females
			Beam bmFilter[0];
			bmFilter = bmMale[i].filterBeamsTConnection(bmFemale, U(500), true) ;
			for (int j = 0; j < bmFilter.length(); j++)
			{
				bmAr.setLength(2);
				bmAr[1]=bmFilter[j];	
				// create new instance	
							// create tsl
				tslNew.dbCreate(sScriptname, vUcsX,vUcsY,bmAr, entAr, ptAr, 
					nArProps, dArProps, sArProps,_kModelSpace, mapTsl); // create new instance	
				if (tslNew.bIsValid())
				{
					tslNew.setPropValuesFromCatalog(T("|_LastInserted|"));	
					reportMessage("\ncreated");	
				}
			}	
		}// next i			
			
		eraseInstance();
		return;
	}	
//end on insert________________________________________________________________________________

// declare standards
	Beam bm0, bm1;
	bm0 = _Beam[0];
	bm1 = _Beam[1]; 
	Point3d ptOrg = _Pt0;
	Vector3d vx,vy,vz,vz1;
	vx=_Z1;
	vy =_Y0;
	vz = vx.crossProduct(vy);
	vx.vis(ptOrg, 1);
	vy.vis(ptOrg, 3);
	vz.vis(ptOrg, 150);	

// Display
	Display dpModel(nColor),dp(nColor),dpPlan(nColor);
	dp.textHeight(U(8));
	dp.addHideDirection(_ZW);
	dpPlan.textHeight(U(8));	
	dpPlan.addViewDirection(_ZW);
	
// validate
	Vector3d vxN = _X0.crossProduct(vz).crossProduct(-vz);
	vxN.vis(_Pt0,4);

	// tolerant test if _X0 and _Z1 are perpendicular)
	int bIsPerpendicular=vxN.isParallelTo(_Z1);
	if (!bIsPerpendicular)
	{
	// compare components
		double dNX1 = abs(_Z1.X()-vxN.X())*pow(10,3);
		double dNY1 = abs(_Z1.Y()-vxN.Y())*pow(10,3);
		double dNZ1 = abs(_Z1.Z()-vxN.Z())*pow(10,3);
		if (dNX1>dEps && dNX1<U(2))bIsPerpendicular=true;
		else if (dNZ1>dEps && dNZ1<U(2))bIsPerpendicular=true;	
	}
	if (!bIsPerpendicular)// ||(!_X0.isPerpendicularTo(bm1.vecX()) && (_ZW.isParallelTo(bm1.vecX()) && !bm1.vecD(vy).isParallelTo(vy))))
	{
		reportMessage("\n******** "+scriptName() + ": " + T("|Beam Connection|") + bm0.posnum()+"/"+bm1.posnum() + " ********");
		reportMessage("\n"+T("|The connection is not perpendicular in the XY-Plane|") + " " + T("|Tool will be deleted.|"));	
		reportMessage("\n***********************************");
		
		// add a static cut before erase Version 1.1
		bm0.addToolStatic(Cut(_Pt0,_Z1),1);
		eraseInstance();
		return;	
	}

// allow switch to other family
	String sArOtherFamilies[0];
	for (int i=0;i<sArFamily.length();i++)
	{
		if (i==nFamily) 
		{
			continue;
		}
		else 
			sArOtherFamilies.append(sArFamily[i]);
	}
	sArOtherFamilies.setLength(2);

// add triggers
	String sTrigger[0];
	sTrigger.append(sArOtherFamilies[0]);	
	sTrigger.append(sArOtherFamilies[1]);	
	sTrigger.append(T("|Extend length to be cut from rod|"));
	for (int i = 0; i < sTrigger.length(); i++)
		addRecalcTrigger(_kContext, sTrigger[i]);	

// trigger 0 change to other family 1
	if ((_bOnRecalc && _kExecuteKey==sTrigger[0]))
	{
		nFamily = sArFamily.find(sTrigger[0]);
		_Map.setString("family",sFamily = sArFamily[nFamily]);
		sType.set(sArType[0]); // set to auto select
	}
// trigger 1 change to other family 2
	else if ((_bOnRecalc && _kExecuteKey==sTrigger[1]))
	{
		nFamily = sArFamily.find(sTrigger[1]);
		_Map.setString("family",sFamily = sArFamily[nFamily]);
		sType.set(sArType[0]);	// set to auto select
	}
// trigger 2 extend to rod
	else if ((_bOnRecalc && _kExecuteKey==sTrigger[2]))
	{
		if (bAllIncicions)
			bAllIncicions=false;
		else
			bAllIncicions=true;		
		_Map.setInt("allIncicions",bAllIncicions);
		setExecutionLoops(2);
	}	

// ints
	int nType = sArType.find(sType); 
	int nHousing = sArHousing.find(sHousing);	
	int nSlot= sArSlot.find(sSlot);
	int bShankDrills;;
//	bShankDrills = sNoYes.find(sShankDrills);
	if (abs(dDepth) > 0)bShankDrills = true;
	int nMode= sArMode.find(sMode);
	
// collect available heights
	double dArHeight[0];
	for (int i =0; i< sArType.length()-1; i++)
		dArHeight.append(dArMinZ[nFamily]+ dArDeltaZ[nFamily]*i);
	
// find valid type for auto settings
	if (nType<1)
	{
		setExecutionLoops(2);
		PLine pl(_Pt1,_Pt2,_Pt3,_Pt4);
		pl.close();
		PlaneProfile pp(pl);
	// transform the pp as the connector might be transformed in Z
		pp.transformBy(vz*dZOffset);
		pp.intersectWith(PlaneProfile(pl));
		pp.vis(4);
		pp.intersectWith(bm1.realBody().shadowProfile(_Plf));
		LineSeg ls=pp.extentInDir(vz);
		Point3d ptX = _Pt0+vz*dZOffset;
		ptX.vis(1);
		ls.ptMid().vis(6);
		double dMaxH = abs(vz.dotProduct(ls.ptStart()-ls.ptEnd())) - vz.dotProduct(ls.ptMid()-ptX);
		
		int n;
		for (int j = dArHeight.length()-1; j >= 0; j--)
			if (dMaxH>=dArHeight[j])
			{
				nType=j+1;		
				sType.set(sArType[j+1]);
				break;
			}
		if (nType<1)
		{
			reportMessage("\n*** "+scriptName() + " " + sFamily + ": " + T("|Beam Connection|") + bm0.posnum()+"/"+bm1.posnum() + " ***");
			reportMessage("\n"+T("|No valid type detected|") + " " + T("|Type set to|") + " " + sArType[1]);	
			reportMessage("\n************************************************");
		
			sType.set(sArType[1]);
			nType=1;	
		}
	}


	
// TOOLING
// collect the geometry from selected type
	double dL0, dL1=U(45), dW0=U(6), dW1=U(6);
	double dHeight,dXDr0,dZDr0,dDeltaZ,dDiam1,dDiam2,dDiam3;
	dL0=dArLb[nFamily];
	dL1=dArLa[nFamily];
	dW0 = dArThickness1[nFamily];
	dW1 = dArThickness2[nFamily];
	dXDr0 = dArXDr0[nFamily];
	dDiam1 = dArDiam1[nFamily];
	dDiam2 = dArDiam2[nFamily];
	dDiam3 = dArDiam3[nFamily];
	dHeight = dArHeight[nType-1];
	dDeltaZ = dArDeltaZ[nFamily];
	
// stretch
	Point3d ptCut=_Pt0-vx*dGapBetween;
	if (nHousing==4) ptCut.transformBy(-vx*dArThickness1[nFamily]);
	bm0.addTool(Cut(ptCut,vx),1);	

// ref points
	Point3d ptRef=_Pt0+vz*dZOffset;	
	Point3d ptRefDr0=ptRef+vz*.5*(dHeight-dDeltaZ)-vx*(dL0-dXDr0);
	//ptRefDr0.vis(20);	

//	Plane pnZ(bm0.ptCenSolid(),vz);
	Plane pnZ(bm0.ptCenSolid(),bm0.vecD(vz));
	
// build the body
	Body bd0(ptRef,vx,vy,vz,dL0,dW0,dHeight,-1,0,0);
	Body bd1(ptRef,vx,vy,vz,dW1,dL1,dHeight,-1,0,0);	
	// tooling on male
	Point3d ptDrillMale[0];
	int iSide = 1;
	if (dDepth < 0)iSide=-1;
	if (dDiam3>0 && nFamily!=0 && bShankDrills)// TODO && sType.right(1)=="L")
	{
		// the upper half hole
		PLine pl(vy);
		pl.addVertex(ptRefDr0+vx*dDiam3/2);
		pl.addVertex(ptRefDr0+vx*.7*dDiam3+vz*.5*dDeltaZ );// 0.7 approx
		pl.addVertex(ptRefDr0-vx*.7*dDiam3+vz*.5*dDeltaZ );
		pl.addVertex(ptRefDr0-vx*dDiam3/2);
		pl.close();
		SolidSubtract sosu(Body(pl,vy*dW0*2,0),_kSubtract);
		bd0.addTool(sosu);		
		//pl.vis(3);
		
		// loop holes
		int n=dHeight/dDeltaZ;
		for (int i=0; i<n; i++)
		{
			
			Drill dr(ptRefDr0-vy*bm0.dD(vy),ptRefDr0+vy*bm0.dD(vy),dDiam3/2);
			bd0.addTool(dr);
			// HSB-12982
//			Drill drBm(ptRefDr0-iSide*vy*bm0.dD(vy),ptRefDr0+iSide*vy*bm0.dD(vy),dArDiamNail3[nFamily]/2);
			Point3d ptDrillStart=ptRefDr0-(iSide*vy)*(.5*bm0.dD(vy)+dEps);
			Point3d ptDrillEnd=ptDrillStart+(iSide*vy)*(abs(dDepth)+dEps);
			Drill drBm(ptDrillStart,ptDrillEnd,dArDiamNail3[nFamily]/2);
			bm0.addTool(drBm);			
			ptDrillMale.append(ptRefDr0);
			ptRefDr0.transformBy(-vz*dDeltaZ);
		}
	}
	
//region Trigger FlipDrillSide
	String sTriggerFlipDrillSide = T("|Flip Drill Side|");
	addRecalcTrigger(_kContextRoot, sTriggerFlipDrillSide );
	if (_bOnRecalc && _kExecuteKey==sTriggerFlipDrillSide)
	{
		dDepth.set(-dDepth);
		setExecutionLoops(2);
		return;
	}//endregion	
	
// Slot
	// HSB-15516
	Vector3d vecXslot=vx;
	if (vecXslot.dotProduct(_X0)<0)vecXslot*=-1;
	vecXslot.normalize();
	Vector3d vecZslot=vecXslot.crossProduct(vy);
	Vector3d vecZslotMeasure=vecXslot.crossProduct(vy);
//
	int nSlotDir=1;
	if (nSlot== 1)// bottom
		nSlotDir*=-1;
		
	if(vecZslot.dotProduct(bm0.vecD(-nSlotDir*vz))<0)
	{ 
		vecZslot*=-1;
	}
	if(vecZslotMeasure.dotProduct(bm0.vecD(vz))<0)
	{ 
		vecZslotMeasure*=-1;
	}
	vecZslot.vis(_Pt0);
	Point3d ptRefSlot=_Pt0+nSlotDir*vz*.5*bm0.dD(vz)/abs((bm0.vecD(vz).dotProduct(vz)));	
	ptRefSlot.vis(2);
	
	// calc slot length
	double dSlotLength = dL0 + dGapSlotX;
//	PlaneProfile ppBody = bd0.shadowProfile(Plane(_Pt0,_Z0));
	PlaneProfile ppBody = bd0.shadowProfile(Plane(_Pt0,vz));
	LineSeg ls = ppBody.extentInDir(_X0);
	Point3d ptMinMax[0];
	ptMinMax.append(ls.ptStart());
	ptMinMax.append(ls.ptEnd());
	ptMinMax = _L0.orderPoints(ptMinMax);
	
	if (ptMinMax.length()>0)
	{
//		dSlotLength= abs(_X0.dotProduct(ptRefSlot -ptMinMax[0]))+dGapSlotX;	
		dSlotLength= abs(vecXslot.dotProduct(ptRefSlot -ptMinMax[0]))+dGapSlotX;	
		ptMinMax[0].vis(5);
		ppBody.vis(5);		
	}
	bd0.vis(6);
	ppBody = bd0.shadowProfile(Plane(_Pt0,vy));
	ls = ppBody.extentInDir(vx);
	PLine plBody(vy);
	plBody.createRectangle(ls,vx,vz);
	plBody.vis(4);
	ptMinMax.setLength(0);
	ptMinMax = plBody.vertexPoints(true);
	ptMinMax = Line(_Pt0,nSlotDir*bm0.vecD(vz)).orderPoints(ptMinMax);
	double dSlotDepth;
	if (ptMinMax.length() > 0)
	{
		ptMinMax[0].vis(5);
		//		dSlotDepth = nSlotDir * bm0.vecD(vz).dotProduct(ptRefSlot-ptMinMax[0]) + dGapSlotZ;
		dSlotDepth=nSlotDir*vecZslotMeasure.dotProduct(ptRefSlot-ptMinMax[0])+dGapSlotZ;
	}
	else
	{
//		dSlotDepth = nSlotDir * vz.dotProduct(ptRefSlot-ptRef) + 0.5 * dHeight + dGapSlotZ;	
		dSlotDepth=nSlotDir*vecZslotMeasure.dotProduct(ptRefSlot-ptRef)+0.5*dHeight+dGapSlotZ;	
	}
	
// HSB-15516
	if (nSlot== 2)// full height
		dSlotDepth = bm0.dD(vz)*10.1;
	ptRefSlot.vis(2);
	ptRef.vis(1);
	
	
//	vecXslot.vis(ptRefSlot,1);
//	vy.vis(ptRefSlot,5);
//	vecZslot.vis(ptRefSlot,3);
	// HSB-19683
	int nAlignmentSlot=sAlignmentSlots.find(sAlignmentSlot);
	if (nAlignmentSlot==0)
	{ 
		// alignment with female beam
	//	Slot sl(ptRefSlot,_X0,vy,bm0.vecD(-nSlotDir*vz),dSlotLength,dW0+2*dGapSlotY,dSlotDepth,-1,0,1);
		Slot sl(ptRefSlot,vecXslot,vy,vecZslot,dSlotLength,dW0+2*dGapSlotY,dSlotDepth,-1,0,1);
		bm0.addTool(sl);
	}
	else
	{ 
		// alignment with male beam
		Vector3d _vecZslot=bm0.vecD(_ZW);
		if(_vecZslot.dotProduct(vecZslot)<0)
		{ 
			_vecZslot*=-1;
		}
		Vector3d _vecXslot=vy.crossProduct(_vecZslot);
		_vecXslot.normalize();
		if(_vecXslot.dotProduct(vecXslot)<0)
			_vecXslot*=-1;
		
		_vecXslot.vis(ptRefSlot,1);
		vy.vis(ptRefSlot,5);
		_vecZslot.vis(ptRefSlot,3);
		
		PlaneProfile pp=bd0.shadowProfile(Plane(ptRefSlot,_vecZslot));
		
		LineSeg lSeg=pp.extentInDir(_vecXslot);
		double _dSlotLength=abs(_vecXslot.dotProduct(ptRefSlot-lSeg.ptStart()));
		_dSlotLength+=dGapSlotX;
		
		Slot sl(ptRefSlot,_vecXslot,vy,_vecZslot,_dSlotLength,dW0+2*dGapSlotY,dSlotDepth,-1,0,1);
		bm0.addTool(sl);
	}
	
// housing
	if (nHousing<4)
	{
		double dReliefOffset=U(10);
		double dX,dY,dZ;
		dX=dW1;
		dY=dL1;
		dZ=dHeight;
		Point3d ptHs=ptRef;
		House hs;
		if (nHousing==0)// bottom
		{
			Point3d ptFace = Line(ptRef,vz).intersect(pnZ,-.5*bm0.dD(vz));
			ptFace.vis(3);
			
			dZ = dHeight*.5-vz.dotProduct(ptFace-ptRef);
			ptHs = (ptRef+ptFace)/2+vz*(.25*dHeight);
			dZ+=dReliefOffset+dGapHouse;
			hs=House (ptHs , vy, vz, -vx, dY + dGapHouse*2, dZ , dX+dExtraHouseDepth,0,0,1);//+dGapHouse*2
			hs.transformBy(vz*.5*(dGapHouse-dReliefOffset));			
		}
		else if (nHousing==2)//top
		{
			Point3d ptFace = Line(ptRef,vz).intersect(pnZ,.5*bm0.dD(vz));
//			pnZ.vis(2);
			ptFace.vis(3);
			
			dZ = dHeight*.5+vz.dotProduct(ptFace-ptRef);
			ptHs = (ptRef+ptFace)/2-vz*(.25*dHeight);
			dZ+=dReliefOffset+dGapHouse;
			hs=House (ptHs , vy, vz, -vx, dY + dGapHouse*2, dZ , dX+dExtraHouseDepth,0,0,1);//+dGapHouse*2
			hs.transformBy(-vz*.5*(dGapHouse-dReliefOffset));
		}
		else if (nHousing==3)//full height
		{
			dZ = bm0.dD(vz)+2*dReliefOffset;2;
			hs=House (ptHs , vy, vz, -vx, dY+dGapHouse*2, dZ , dX+dExtraHouseDepth,0,0,1);
		}
		else
		{
			dZ = dHeight+2*dGapHouse;
			hs=House (ptHs , vy, vz, -vx, dY+dGapHouse*2, dZ , dX+dExtraHouseDepth,0,0,1);			
		}
		ptHs.vis(3);
		
		hs.setEndType(_kFemaleEnd);
		hs.setRoundType(_kReliefSmall);	
		if(hs.cuttingBody().volume() > dEps)
			hs.cuttingBody().vis(1);	
		bm0.addTool(hs);
		
	}
	
// draw
	Body bd = bd0;
	bd.addPart(bd1);	
	dpModel.draw(bd);		
	
// Hardware//region
	
// hardware collection
	if (_bOnDebug)dp.color(1);
	String sModel,sCompareKey;
	sModel.formatUnit(dHeight /U(1,"mm"),2,0);
	sModel = "Alu"+sFamily + " " + sModel;
	
	sCompareKey=sModel+bShankDrills;
	
	// H = ALU bracket height
	// BNT = Minimum width of secondary beam
	// HT = Beam minimum height
	// Ø4 = 4x60 Anker nails (1)
	// Ø12 = 12x120 Smooth pins (2) DIN 1052:1988 EN 1995:2004
	
	// HT HT H
	// Table 1: ALU MIDI - Partial nailing Main beam - Pillar
	// H		BNT		HT		Ø4	Ø12	V		R
	// mm		mm		mm		pc	pc	KN		KN
	// 120		120		160		12	3	7,1		12,8
	// 160		120		200		16	4	10,0	20,0
	// 200		120		240		20	5	12,9	26,7
	// 240		120		280		24	6	15,7	33,9
	// 280		120		320		28	7	16,8	41,1
	// 320		120		360		32	8	18,2	47,2
	// 360		120		400		36	9	20,0	55,0
	
	// Table 2: ALU MIDI - Total nailing Main beam - Secondary beam
	// H		BNT		HT		Ø4	Ø12	V		R
	// mm		mm		mm		pc	pc	KN		KN
	// 120 		120		160		22	3	10,7	23,0
	// 160		120		200		30	4	18,2	36,2
	// 200		120		240		38	5	23,2	47,6
	// 240		120		280		46	6	30,1	61,0
	// 280		120		320		54	7	33,9	74,0
	// 320		120		360		62	8	35,8	85,1
	// 360		120		400		70	9	37,6	99,0
	
	
// collect existing hardware
	HardWrComp hwcs[]=_ThisInst.hardWrComps();
	
// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
	// legacy: count tsl types, if none are found remove also user types
	int nNumRTSL;
	for (int i=hwcs.length()-1; i>=0 ; i--) 
		if (hwcs[i].repType() == _kRTTsl)
		{
			nNumRTSL++;
			hwcs.removeAt(i);
		}
	if (nNumRTSL<1)	
		for (int i=hwcs.length()-1; i>=0 ; i--) 
			if (hwcs[i].repType() == _kRTUser)
				hwcs.removeAt(i); 
	
// declare the groupname of the hardware components
	String sHWGroupName;
	// set group name
	{ 
	// element
		// try to catch the element from the parent entity
		Element elHW =bm0.element(); 
		// check if the parent entity is an element
		if (!elHW.bIsValid())	elHW = (Element)bm0;
		if (elHW.bIsValid()) 	sHWGroupName=elHW.elementGroup().name();
	// loose
		else
		{
			Group groups[] = _ThisInst.groups();
			if (groups.length()>0)	sHWGroupName=groups[0].name();
		}		
	}
	
// add main componnent
	{ 
		HardWrComp hwc(sModel, 1); // the articleNumber and the quantity is mandatory
		
		hwc.setManufacturer(sManufacturer);
		
		hwc.setModel(sModel);
		hwc.setName(sManufacturer+" "+sModel);
		hwc.setDescription(_ThisInst.materialDescription());
		hwc.setMaterial(T("|Aluminium|"));
		hwc.setNotes(_ThisInst.notes());
		
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(bm0);	
		hwc.setCategory(T("|Connector|"));
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		
		hwc.setDScaleX(dL0);
		hwc.setDScaleY(dL1);
		hwc.setDScaleZ(dHeight);
		
	// apppend component to the list of components
		hwcs.append(hwc);
	}

// shank fixing
	if (bShankDrills && nFamily>0)
	{
	// calculate the length of the pegs  iterate steps
		double dL  = bm0.dD(vy);
		// allow length in full 10mm steps
		int n = dL/U(10);	
		if (n*U(10)<dL )
			dL = (n)*U(10);
		String sThisModel,sDiam;
		sThisModel.formatUnit(dL /U(1,"mm"),2,0);
		sThisModel= sArFixing3[nFamily] + " 12x" + sThisModel;
		sDiam.formatUnit(dArDiamNail3[nFamily]/U(1,"mm"),2,0);
		int nQty = nArFixing3IncrementQty[nFamily]*(nType-1)+nArFixing3BaseQty[nFamily];
	
		//Hardware( sArFixing3[nFamily], sArFixing3[nFamily], sThisModel, dL, dArDiamNail3[nFamily], nQty, T("|Steel, zincated|"), "");		

	// add sub componnent
		{ 
			HardWrComp hwc(sArFixing3[nFamily], nQty); // the articleNumber and the quantity is mandatory
			
			hwc.setManufacturer(sManufacturer);
			
			hwc.setModel(sThisModel);
			hwc.setName(hwc.name());
			//hwc.setDescription(sHWDescription);
			hwc.setMaterial(T("|Steel, zincated|"));
			hwc.setNotes(_ThisInst.notes());
			
			hwc.setGroup(sHWGroupName);
			hwc.setLinkedEntity(bm0);	
			hwc.setCategory(T("|Connector|"));
			hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
			
			hwc.setDScaleX(dArDiamNail3[nFamily]);
			//hwc.setDScaleY(dHWWidth);
			hwc.setDScaleZ(dL);
			
		// apppend component to the list of components
			hwcs.append(hwc);
		}

		sCompareKey = sCompareKey + sArFixing3[nFamily] + "qty" + nQty + "dL"+dL;;
		if (_bOnDebug) dp.draw(nQty + " " + sThisModel,_Pt0,_XW,_YW,1,0,_kDeviceX);
	}
	else
	{
	// calculate the length of the self-perforating pins and iterate steps
		double dL  = bm0.dD(vy);
		// allow length in full 10mm steps
		int n = dL/U(10);	
		if (n*U(10)<dL )
			dL = (n)*U(10);
		dL-=U(7);			
		String sThisModel,sDiam;
		sThisModel.formatUnit(dL /U(1,"mm"),2,0);
		sDiam.formatUnit(dArDiamNail4[nFamily]/U(1,"mm"),2,0);
		sThisModel= sArFixing4[nFamily] + " " + sDiam+"x" + sThisModel;
		int nQty = nArFixing4IncrementQty[nFamily]*(nType-1)+nArFixing4BaseQty[nFamily];
	
		//Hardware( sArFixing4[nFamily], sArFixing4[nFamily], sThisModel, dL, dArDiamNail4[nFamily], nQty, T("|Steel, zincated|"), "");		
		
		
	// add sub componnent
		{ 
			HardWrComp hwc(sArFixing4[nFamily], nQty); // the articleNumber and the quantity is mandatory
			
			hwc.setManufacturer(sManufacturer);
			
			hwc.setModel(sThisModel);
			hwc.setName(sArFixing4[nFamily]);
			hwc.setDescription(hwc.name());
			hwc.setMaterial(T("|Steel, zincated|"));
			hwc.setNotes(_ThisInst.notes());
			
			hwc.setGroup(sHWGroupName);
			hwc.setLinkedEntity(bm0);	
			hwc.setCategory(T("|Connector|"));
			hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
			
			hwc.setDScaleX(dArDiamNail4[nFamily]);
			//hwc.setDScaleY(dHWWidth);
			hwc.setDScaleZ(dL);
			
		// apppend component to the list of components
			hwcs.append(hwc);
		}		
		
		
		
		sCompareKey = sCompareKey + sArFixing4[nFamily] + "qty" + nQty + "dL"+dL;
		if (_bOnDebug) dp.draw(nQty + " " + sThisModel,_Pt0,_XW,_YW,1,0,_kDeviceX);
	}

// wing fixing
	if (nMode==0) // wood/wood
	{
	// 	partial nailing for pillar connections
		if (nFamily==1 && bm1.vecX().isParallelTo(_ZW))
		{
			nArFixing1BaseQty[nFamily]=12;	
			nArFixing1IncrementQty[nFamily]/=2;				
		}
		else if (nFamily==2 && bm1.vecX().isParallelTo(_ZW))
		{
			nArFixing1BaseQty[nFamily]=24;			
			nArFixing1IncrementQty[nFamily]/=2;				
		}		
	// calculate the length of the self-perforating pins and iterate steps
		double dL  = U(60);
		
		String sThisModel,sDiam;
		sThisModel.formatUnit(dL /U(1,"mm"),2,0);
		sDiam.formatUnit(dArDiamNail1[nFamily]/U(1,"mm"),2,0);
		sThisModel= sArFixing1[nFamily] + " " + sDiam+"x" + sThisModel;
		int nQty = nArFixing1IncrementQty[nFamily]*(nType-1)+nArFixing1BaseQty[nFamily];
	
		//Hardware( sArFixing1[nFamily], sArFixing1[nFamily], sThisModel, dL, dArDiamNail1[nFamily], nQty, T("|Steel, zincated|"), "");		

	// add sub componnent
		{ 
			HardWrComp hwc(sArFixing1[nFamily], nQty); // the articleNumber and the quantity is mandatory
			
			hwc.setManufacturer(sManufacturer);
			
			hwc.setModel(sThisModel);
			hwc.setName(sArFixing1[nFamily]);
			hwc.setDescription(hwc.name());
			hwc.setMaterial(T("|Steel, zincated|"));
			hwc.setNotes(_ThisInst.notes());
			
			hwc.setGroup(sHWGroupName);
			hwc.setLinkedEntity(bm0);	
			hwc.setCategory(T("|Connector|"));
			hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
			
			hwc.setDScaleX(dArDiamNail1[nFamily]);
			//hwc.setDScaleY(dHWWidth);
			hwc.setDScaleZ(dL);
			
		// apppend component to the list of components
			hwcs.append(hwc);
		}	


		sCompareKey = sCompareKey + sArFixing1[nFamily] + "qty" + nQty + "dL"+dL;
		if (_bOnDebug) dp.draw(nQty + " " + sThisModel,_Pt0,_XW,_YW,1,3,_kDeviceX);			
	}
	else  // wood/concrete, default with chemical dowels
	{
	// get the length
		double dL  = dArLengthNail2[nFamily];
		double dDiameter = 	dArDiamNail2[nFamily];	
	// replace dowel by screw for midi in mode 1
		String sConnector = sArFixing2[nFamily];
		if (nFamily==1 && nMode==1)
		{
			sConnector = T("|Screw-in anchor|");
			dL = U(80);
			dDiameter =U(10);
		}

		String sThisModel,sDiam;
		sThisModel.formatUnit(dL /U(1,"mm"),2,0);
		sDiam.formatUnit(dDiameter /U(1,"mm"),2,0);
		sThisModel= sConnector  + " " + sDiam+"x" + sThisModel;
		int nQty = nArFixing2IncrementQty[nFamily]*(nType-1)+nArFixing2BaseQty[nFamily];
	
		//Hardware( sConnector , sConnector , sThisModel, dL, dArDiamNail2[nFamily], nQty, T("|Steel, zincated|"), "");		
		// add sub componnent
		{ 
			HardWrComp hwc(sConnector, nQty); // the articleNumber and the quantity is mandatory
			
			hwc.setManufacturer(sManufacturer);
			
			hwc.setModel(sThisModel);
			hwc.setName(sConnector);
			hwc.setDescription(hwc.name());
			hwc.setMaterial(T("|Steel, zincated|"));
			hwc.setNotes(_ThisInst.notes());
			
			hwc.setGroup(sHWGroupName);
			hwc.setLinkedEntity(bm0);	
			hwc.setCategory(T("|Connector|"));
			hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
			
			hwc.setDScaleX(dDiameter);
			//hwc.setDScaleY(dHWWidth);
			hwc.setDScaleZ(dL);
			
		// apppend component to the list of components
			hwcs.append(hwc);
		}
		
		sCompareKey = sCompareKey + sConnector  + "qty" + nQty + "dL"+dL;
		if (_bOnDebug) dp.draw(nQty + " " + sThisModel,_Pt0,_XW,_YW,1,3,_kDeviceX);	
		
	}
// draw the model name to the wing
	dp.draw(sModel,_Pt0+vy*.25*dArLa[nFamily],vz,vy,0,0);
	dpPlan.draw(sModel,_Pt0-vx*.5*dArThickness2[nFamily],vy,vx,0,0,_kDevice);
	
// set compare key
	setCompareKey(sCompareKey);
	model(sModel);
	material(T("Aluminum"));


// make sure the hardware is updated
	if (_bOnDbCreated)	setExecutionLoops(2);				
	_ThisInst.setHardWrComps(hwcs);	
	//endregion

		



	




		

	







	



	














#End
#BeginThumbnail
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
HB@`I&^[110`D?4U,GWA1102R&'_6O5JBB@!PZ4=Z**`'"EHHH`__V8HH
`


















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
        <int nm="BreakPoint" vl="205" />
        <int nm="BreakPoint" vl="860" />
        <int nm="BreakPoint" vl="924" />
        <int nm="BreakPoint" vl="464" />
        <int nm="BreakPoint" vl="974" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21424: Fix number of screwes" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="18" />
      <str nm="Date" vl="6/27/2025 11:26:00 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21424: ALU MIDI add H400 and H440" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="17" />
      <str nm="Date" vl="6/26/2025 11:53:41 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19683: Add property for the Slot alignment" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="15" />
      <str nm="Date" vl="8/29/2023 8:21:50 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17890 dimension alu maxi corrected" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="14" />
      <str nm="Date" vl="2/9/2023 12:25:57 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15516: increase depth for full height slot" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="13" />
      <str nm="Date" vl="6/7/2022 1:12:07 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15516: fix slot for rotated beams" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="12" />
      <str nm="Date" vl="6/2/2022 2:17:15 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12982: add property &quot;Depth&quot; for the drill; add command &quot;flip drill side&quot; to flip drill side" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="11" />
      <str nm="Date" vl="9/13/2021 1:49:31 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12984: fix bug when creating housing" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="10" />
      <str nm="Date" vl="9/13/2021 11:10:05 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End