#Version 8
#BeginDescription
#Versions:
Version 2.90 18.06.2025 HSB-24107: Add support for fastenerEntities , Author: Marsel Nakuci
Version 2.89 02.06.2025 HSB-24107: add property to include entities in xRef , Author: Marsel Nakuci
Version 2.88 02.06.2025 HSB-24107: avoid duplicated instances , Author: Marsel Nakuci
Version 2.87 02.06.2025 HSB-24107: cleanup level instance when hatch instance is deleted and vice versa , Author: Marsel Nakuci
Version 2.86 24/04/2025 HSB-23455: For sections in model split the hatching tsl and the level/depth tsl so they can be assigned indipendently , Author Marsel Nakuci
Version 2.85 24/04/2025 HSB-23455: Add support for blocks , Author Marsel Nakuci
Version 2.84 20.12.2024 HSB-22914: Fix error message of failing solid generation , Author Marsel Nakuci
2.83 05.12.2024 HSB-22914: remove dependency to clipVolume Author: Marsel Nakuci
Version 2.82 20.11.2024 HSB-22901: Handle when tsl realbody fails , Author Marsel Nakuci
Version 2.81 11.10.2024 HSB-22263: fix when saving SIP components , Author Marsel Nakuci
Version 2.80 09.10.2024 HSB-22263: Some refactoring , Author Marsel Nakuci
Version 2.79 08.10.2024 HSB-22263: Improve performance on jigging at command "Modify/Add hatch" , Author Marsel Nakuci
2.78 18/06/2024 20240617: Fix typo when getting hatch patterns Marsel Nakuci
2.77 18/06/2024 HSB-21749: fix solid hatch with insulation Marsel Nakuci
2.76 25.04.2024 HSB-21749: Increase limit for insulation hatching Author: Marsel Nakuci
2.75 25.04.2024 HSB-21749: Fix solif hatch at beams Author: Marsel Nakuci
2.74 25.04.2024 HSB-21945: Fix for painter with groups Author: Marsel Nakuci
2.73 04.04.2024 HSB-21749: Fix insulation drawing in layout Author: Marsel Nakuci
2.72 04.04.2024 HSB-21655: Improve operation in planeProfile intersection Author: Marsel Nakuci
2.71 22.03.2024 HSB-20381: For zero transparency subtract planeprofiles in z order Author: Marsel Nakuci
2.70 22.03.2024 HSB-20381: Fix orientation when "Modify hatch" Author: Marsel Nakuci
2.69 19/03/2024 HSB-21596: Add command to influence group assignment behaviour 
2.68 20.12.2023 HSB-20972: Fix textheight in blockspace 
2.67 20.12.2023 HSB-20377: dont create painter definition if not requested on insert 
2.66 14.11.2023 HSB-20634: Wrong message on sections. 
2.65 13.10.2023 HSB-20184: Extent pattern detection by painter grouping 
2.64 11.10.2023 HSB-20184: Fix when fail tsl body intersect
2.63 27.09.2023 2023.09.27: Inlcude tsls when geting box of bodies 
2.62 26.09.2023 HSB-20048: 
2.61 15.09.2023 HSB-20048: For AssemblyDefinition tsl it is the only entity in showset; Include entities of the tsl 
2.60 25.04.2023 HSB-18779: Fix transformation at slabs

version value="2.9" date="15feb2021

requires 23.0.47 or higher


This TSL creates creates hatch area and can be used at
1- ACA sections in model space
2- Viewports in Layout space
3- Viewports in multipage shopdrawings
    TSL can be inserted directly in model space 
    or be defined inside the blockspace definition of the shopdrawing

The hatch definitions are defined in the xml
They are then mapped to entities in 2 ways
1- By material
    In this case the material name of entity must match the material that the hatch definition supports
2- By painter
    In this case the hatch name is used to the entities belonging to the selected painter filter






























































#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 90
#KeyWords hatch, viewport, layout, shopdrawing, section, 2d, Multipage,View
#BeginContents
/// <History>//region
// #Versions:
// 2.90 18.06.2025 HSB-24107: Add support for fastenerEntities , Author: Marsel Nakuci
// 2.89 02.06.2025 HSB-24107: add property to include entities in xRef , Author: Marsel Nakuci
// 2.88 02.06.2025 HSB-24107: avoid duplicated instances , Author: Marsel Nakuci
// 2.87 02.06.2025 HSB-24107: cleanup level instance when hatch instance is deleted and vice versa , Author: Marsel Nakuci
// 2.86 24/04/2025 HSB-23455: For sections in model split the hatching tsl and the level/depth tsl so they can be assigned indipendently , Author Marsel Nakuci
// 2.85 24/04/2025 HSB-23455: Add support for blocks , Author Marsel Nakuci
// 2.84 20.12.2024 HSB-22914: Fix error message of failing solid generation , Author Marsel Nakuci
// 2.83 05.12.2024 HSB-22914: remove dependency to clipVolume Author: Marsel Nakuci
// 2.82 20.11.2024 HSB-22901: Handle when tsl realbody fails , Author Marsel Nakuci
// 2.81 11.10.2024 HSB-22263: fix when saving SIP components , Author Marsel Nakuci
// 2.80 09.10.2024 HSB-22263: Some refactoring , Author Marsel Nakuci
// 2.79 08.10.2024 HSB-22263: Improve performance on jigging at command "Modify/Add hatch" , Author Marsel Nakuci
// 2.78 18/06/2024 20240617: Fix typo when getting hatch patterns Marsel Nakuci
// 2.77 18/06/2024 HSB-21749: fix solid hatch with insulation Marsel Nakuci
// 2.76 25.04.2024 HSB-21749: Increase limit for insulation hatching Author: Marsel Nakuci
// 2.75 25.04.2024 HSB-21749: Fix solid hatch at beams Author: Marsel Nakuci
// 2.74 25.04.2024 HSB-21945: Fix for painter with groups Author: Marsel Nakuci
// 2.73 04.04.2024 HSB-21749: Fix insulation drawing in layout Author: Marsel Nakuci
// 2.72 04.04.2024 HSB-21655: Improve operation in planeProfile intersection Author: Marsel Nakuci
// 2.71 22.03.2024 HSB-20381: For zero transparency subtract planeprofiles in z order Author: Marsel Nakuci
// 2.70 22.03.2024 HSB-20381: Fix orientation when "Modify hatch" Author: Marsel Nakuci
// 2.69 19/03/2024 HSB-21596: Add command to influence group assignment behaviour Marsel Nakuci
// 2.68 20.12.2023 HSB-20972: Fix textheight in blockspace Author: Marsel Nakuci
// 2.67 20.12.2023 HSB-20377: dont create painter definition if not requested on insert Author: Marsel Nakuci
// 2.66 14.11.2023 HSB-20634: Wrong message on sections. Author Nils Gregor
// 2.65 13.10.2023 HSB-20184: Extent pattern detection by painter grouping Author: Marsel Nakuci
// 2.64 11.10.2023 HSB-20184: Fix when fail tsl body intersect Author: Marsel Nakuci
// 2.63 27.09.2023 2023.09.27: Inlcude tsls when geting box of bodies Author: Marsel Nakuci
// 2.62 26.09.2023 HSB-20048: Author: Marsel Nakuci
// 2.61 15.09.2023 HSB-20048: For AssemblyDefinition tsl it is the only entity in showset; Include entities of the tsl Author: Marsel Nakuci
// 2.60 25.04.2023 HSB-18779: Fix transformation at slabs Author: Marsel Nakuci
// 2.59 21.03.2023 HSB-18391: Remove case sensitivity when  getting painter type Author: Marsel Nakuci
// 2.58 08.03.2023 HSB-16893: Use pline for drawing the insulation Author: Marsel Nakuci
// 2.57 16.02.2023 20220216: Dont let fixed pt0 in viewports in layout space Author: Marsel Nakuci
// 2.56 08.12.2022 HSB-16741: Exclude "dummy" genbeams Author: Marsel Nakuci
// 2.55 07.12.2022 HSB-16741: for one layer panel withempty material, make use of the panel material; dont prompt jig selection when only one section/multipage view port selected Author: Marsel Nakuci
// 2.54 08.11.2022 HSB-16991: Improve horizontal sections and appearance of setup graphics; update globals (getview) on point click Author: Marsel Nakuci
// 2.53 04.11.2022 HSB-16740: Add Multipage model support Author: Marsel Nakuci
// 2.52 03.11.2022 HSB-16802: Fix drawing of dynamic hatching Author: Marsel Nakuci
// 2.51 28.10.2022 HSB-16802: Capture when TSL is moved with the section and make sure the grip points that define section depth are not changed Author: Marsel Nakuci
// 2.50 28.10.2022 HSB-16802: Make table smaller Author: Marsel Nakuci
// 2.49 28.10.2022 HSB-16802: Fix dynamic hatching Author: Marsel Nakuci
// 2.48 26.10.2022 HSB-16802: Improve graphical display in jigging Author: Marsel Nakuci
// 2.47 26.10.2022 HSB-16802: Support changing multiple hatches at ones. Different properties are shown as *VARIES* Author: Marsel Nakuci
// 2.46 24.10.2022 HSB-16741: add jig interface for "Modify hatch" and "Add hatch" Author: Marsel Nakuci
// 2.45 14.10.2022 HSB-16741: add support for collection entities Author: Marsel Nakuci
// 2.44 07.10.2022 HSB-16727: Add property "Hatch Mapping" {by Material; by Painter} Author: Marsel Nakuci
// 2.43 23.09.2022 HSB-12334: improvement for insulation Author: Marsel Nakuci
// 2.42 16.09.2022 HSB-12334: support insulation snake (curly) shape Author: Marsel Nakuci
// 2.41 12.09.2022 HSB-15941: set the map to mapSetting after doing migration; migration only done at insertion.remove command to do migration. Author: Marsel Nakuci
// 2.40 02.09.2022 HSB-16233: For dynamic scale make scale equal to ACA scale for a size of 1000mm Author: Marsel Nakuci
// 2.39 01.09.2022 HSB-15895: fix transparency and orientation angle of the hatch for panels Author: Marsel Nakuci
// 2.38 08.07.2022 HSB-15943: use only painters of collection when defined Author: Marsel Nakuci
// 2.37 08.07.2022 HSB-15941: when inconsistent setting version do migration from installation directory;add {import settings,Export settings, migrate setting} Author: Marsel Nakuci
// 2.36 28.06.2022 HSB-12339: fix index when modifying hatch Author: Marsel Nakuci
// 2.35 10.06.2022 HSB-12339: add cross symbol flag in xml for beams Author: Marsel Nakuci
// 2.34 09.06.2022 HSB-15528: fix bug: when entities not assigned to any group, they must be hatched Author: Marsel Nakuci
// 2.33 02.06.2022 HSB-15528: hatch only entities that are visible Author: Marsel Nakuci
// 2.32 04.05.2022 HSB-15364 section references drawn on T-Layer (non plotable) if section is assigned to a group  , Author Thorsten Huck
// Version 2.31 27.01.2022 HSB-14474: hatching for Y and Z at beams must be aligned with the direction of beam X Author: Marsel Nakuci
// Version 2.30 25.01.2022 HSB-14361: get sip realbody from analysed tools Author: Marsel Nakuci
// Version 2.29 24.01.2022 HSB-14361: Improve investigation of planeprofile and visible segments Author: Marsel Nakuci
// Version 2.28 10.01.2022 HSB-13341: Define Scaling and Transparency as unitless properties Author: Marsel Nakuci
// Version 2.27 16.12.2021 HSB-13956: improve sectional cut investigation Author: Marsel Nakuci
// Version 2.26 15.12.2021 HSB-13603: fix when reading flag "Static" for the hatch scale Author: Marsel Nakuci
// Version 2.25 15.12.2021 HSB-13605: fix rotation between the sectional normal and the most aligned vector Author: Marsel Nakuci
// Version 2.24 14.12.2021 HSB-13602: fix bug when modifying hatch; make sure NoYes properties use 0 or 1 Author: Marsel Nakuci
// Version 2.23 14.07.2021 HSB-11492: update the hatch default values if smth missing in xml Author: Marsel Nakuci
// Version 2.22 09.07.2021 HSB-11492: add command "delete hatch" Author: Marsel Nakuci
// Version 2.21 08.07.2021 HSB-11492: when modifying hatch prompt only properties for the orientation of selected property Author: Marsel Nakuci
// Version 2.20 06.07.2021 HSB-11492: fix bug when initializing grip points for 2d section Author: Marsel Nakuci
// Version 2.19 06.07.2021 HSB-11492: add trigger "modify hatch" and "add hatch" Author: Marsel Nakuci
// Version 2.18 24.06.2021 HSB-12297: improve calc of transparency so that all hatches reach 100 when user inputs 100 Author: Marsel Nakuci
// Version 2.17 24.06.2021 HSB-12297: kosmetik properties Author: Marsel Nakuci
// Version 2.16 24.06.2021 HSB-12297: kosmetik Author: Marsel Nakuci
// Version 2.15 24.06.2021 HSB-12297: add outline contour and property to scale transparency Author: Marsel Nakuci
// Version 2.14 22.06.2021 HSB-12235: Support walls, maselements, 3d vols(entities with 3d) Author: Marsel Nakuci
// Version 2.13 14.05.2021 Ticket ID #9984823: recreate planeprofile Author: Marsel Nakuci
// Version 2.12 09.04.2021 HSB-11469: calculate planeprofile of intersection from body and clipping body using 2 slices Author: Marsel Nakuci
// Version 2.11 30.03.2021 HSB-11408: include panel as a type in the painter definition for SIPs Author: Marsel Nakuci
// Version 2.10 24.03.2021 HSB-11326: fix hatch representation Author: Marsel Nakuci
/// <version value="2.9" date="15feb2021" author="marsel.nakuci@hsbcad.com"> HSB-10752: when body intersection is not successful it is replaced by intersection of plane profiles </version>
/// <version value="2.8" date="11jan2021" author="marsel.nakuci@hsbcad.com"> HSB-10159: save used hatches in TSL _Map to be used by hsbViewLegend and write mapX in entcollector for sdv, use default hatch for TSL instances </version>
/// <version value="2.7" date="12nov2020" author="marsel.nakuci@hsbcad.com"> HSB-7605: use trigger to set level and depth from active zone </version>
/// <version value="2.6" date="06nov2020" author="marsel.nakuci@hsbcad.com"> HSB-7605: when in element viewport with active zone, set level and depth at that particular zone </version>
/// <version value="2.5" date="26oct2020" author="marsel.nakuci@hsbcad.com"> HSB-9437: hsbViewHatching now supports 2D-Sections which are placed in a host dwg but refer to entities in xRef dwg </version>
/// <version value="2.4" date="02oct2020" author="marsel.nakuci@hsbcad.com"> HSB-7706: add default xml in content general and add flag isActive to indicate if map is to be read </version>
/// <version value="2.3" date="16jul2020" author="thorsten.huck@hsbcad.com"> HSB-7965: filtering through settings definition deprecated and replaced by painter definitions, requires 23.0.47 or higher </version>
/// <version value="2.2" date="19may2020" author="thorsten.huck@hsbcad.com"> HSB-7657: default scale factor beams corrected </version>
/// <version value="2.1" date="02apr2020" author="marsel.nakuci@hsbcad.com"> HSB-6959: collect entities when in layout viewport </version>
/// <version value="2.0" date="22mar2020" author="marsel.nakuci@hsbcad.com"> HSB-6959: apply filters </version>
/// <version value="1.23" date="02mar2020" author="marsel.nakuci@hsbcad.com"> HSB-5131: stop when material is found </version>
/// <version value="1.22" date="09jan2020" author="marsel.nakuci@hsbcad.com"> HSB-5131 fix bug from Roman at transformation of sheets </version>
/// <version value="1.21" date="20.09.2019" author="marsel.nakuci@hsbcad.com"> HSB-5131 fix bug from Rene. the first hatch found with the material is used </version>
/// <version value="1.21" date="20.09.2019" author="marsel.nakuci@hsbcad.com"> HSB-5131 fix bug from Rene. the first hatch found with the material is used </version>
/// <version value="1.20" date="16jul2019" author="marsel.nakuci@hsbcad.com"> HSB-5131 use a solid hatch with transparency </version>
/// <version value="1.19" date="16jul2019" author="marsel.nakuci@hsbcad.com"> HSB-5131 Section depth should be always positive. Use as Section level from _PtG the one that gives Section depth positive.If enteres Section depth<0, then make it 0 </version>
/// <version value="1.18" date="15jul2019" author="marsel.nakuci@hsbcad.com"> HSB-5131 change scale from 50 to 0.1 and remove the factor 500 + add command "Remove entity" for non element viewport </version>
/// <version value="1.17" date="15jul2019" author="marsel.nakuci@hsbcad.com"> HSB-5131 workaround when operation intersect at realBody fails </version>
/// <version value="1.16" date="12jul2019" author="marsel.nakuci@hsbcad.com"> HSB-5131 bug fix at transformation ms2ps and ps2ms </version>
/// <version value="1.15" date="12jul2019" author="marsel.nakuci@hsbcad.com"> HSB-5131 _PtG[0] and _PtG[1] define a rectangle </version>
/// <version value="1.14" date="12jul2019" author="marsel.nakuci@hsbcad.com"> HSB-5131 assignToGroups(section, 'E') change layer of dpCut to Tooling layer </version>
/// <version value="1.13" date="10jul2019" author="marsel.nakuci@hsbcad.com"> HSB-5131 add grip points to controll dSectionLevel and dSectionDepth </version>
/// <version value="1.12" date="10jul2019" author="marsel.nakuci@hsbcad.com"> HSB-5131 change default scalemin </version>
/// <version value="1.11" date="10jul2019" author="marsel.nakuci@hsbcad.com"> HSB-5131 rename+fix default xml orientation </version>
/// <version value="1.10" date="09jul2019" author="marsel.nakuci@hsbcad.com"> HSB-5131 pass on the properties when creating new TSL </version>
/// <version value="1.9" date="09jul2019" author="marsel.nakuci@hsbcad.com"> HSB-5131 add new properties section level and section depth for the determination of entities to be hached, see comment in youtrack from 09.07.2019 </version>
/// <version value="1.8" date="04jul2019" author="marsel.nakuci@hsbcad.com"> HSB-5131 fix calculation of the orientation of the local axis needed for the hatching </version>
/// <version value="1.7" date="04jul2019" author="marsel.nakuci@hsbcad.com"> HSB-5131 support a default map if no xml or map object available </version>
/// <version value="1.6" date="01jul2019" author="marsel.nakuci@hsbcad.com"> HSB-5131 properties height 1 and height 2 that define the clipping body at viewport are wrt model space </version>
/// <version value="1.5" date="01jul2019" author="marsel.nakuci@hsbcad.com"> HSB-5131 change format of xml+improve dynamic adaptive scaling </version>
/// <version value="1.4" date="25jun2019" author="marsel.nakuci@hsbcad.com"> HSB-5131 add properties "section height 1", "section height 2" to controll te clipping body for element viewports and shopdrawing </version>
/// <version value="1.3" date="23jun2019" author="marsel.nakuci@hsbcad.com"> HSB-5131 support element viewport, shopdrawViewport </version>
/// <version value="1.2" date="18jun2019" author="marsel.nakuci@hsbcad.com"> HSB-5131 support massGroups, TSL, Sheets </version>
/// <version value="1.1" date="17jun2019" author="marsel.nakuci@hsbcad.com"> HSB-5131 support xml and panels with many components </version>
/// <version value="1.0" date="29may2019" author="thorsten.huck@hsbcad.com"> HSB-5131 initial </version>
/// </History>

/// <insert Lang=en>
/// Select a 2D section, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl applies hatchings to selected entities of a 2D section, layout or shop drawing
/// 1- For 2d sections
/// User can select a 2d section and the hatch will be generated
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbViewHatching")) TSLCONTENT
//endregion
	
//region constants 
	U(1,"mm");	
	double dEps = U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug = _bOnDebug;
	// read a potential mapObject defined by hsbDebugController
	{ 
		MapObject mo("hsbTSLDev" ,"hsbTSLDebugController");
		if (mo.bIsValid()){Map m = mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug = true;	break;}}
		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());		
	}
	String sDefault = T("|_Default|");
	String sLastInserted = T("|_LastInserted|");
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	String sVaries="*"+T("|VARIES|")+"*";
	String sHatchModes[]={ T("|by Hatch Pattern|"),T("|Dynamic|")};
	double dHview = getViewHeight();
	double dViewScale=.0006*dHview;
	Vector3d vecXview = getViewDirection(0);
	Vector3d vecYview = getViewDirection(1);
	Vector3d vecZview = getViewDirection(2);
	vecXview.normalize();
	vecYview.normalize();
	vecZview.normalize();
	Point3d ptViewCenter = getViewCenter();
	double dMarginEnt=4*dViewScale;
	double dTableSpace=U(20)*dHview*0.001;
	// HSB-12334: parameters for insulation
	int nArch[] ={ 0,         0,      1,     0,     1,       0};
	double dXs[]={ U(31.7451),U(0)   ,U(127),U(63.5),U(190.5),U(158.7549)};
	double dYs[] ={ U(0), U(63.5), U(63.5) ,- U(63.5) ,- U(63.5), U(0)};
	double dWidthModule = U(254);
	double dDiameterModule = U(127);
	int nInrLimit = 400;// limit for insulation
//end constants//endregion
	
//region Color and view	
	int bIsDark;{int n = getBackgroundTrueColor();bIsDark = ((rgbR(n) + rgbB(n) + rgbG(n))/3<127);}
	int grey = bIsDark?rgb(199,200,202):rgb(99,100,102);
	int white = bIsDark?rgb(255,255,255):rgb(0,0,0);
	int black = bIsDark?rgb(0,0,0):rgb(255,255,255);
	
	int lightblue = rgb(204,204,255);
	int blue = rgb(69,84,185);	
	int darkblue = rgb(26,50,137);	
	
	int yellow = rgb(241,235,31);
	int darkyellow = rgb(254, 204, 102);
	int mellowyellow = rgb(249,209,78);
	int orange = rgb(242,103,34);
	
	int red = rgb(205,32,39);
	int purple = rgb(147,39,143);
	int petrol = rgb(16,86,137);
	
	int green = rgb(19,155,72);
	int brown = rgb(153, 77, 0);
	
	int nColors[]={mellowyellow,red,green,
		blue,darkyellow,purple,brown,
		darkblue,yellow,petrol,orange};
		
	String kJigViewport="JigViewport", kJigModifyAdd="JigModifyAdd",
	kViewportOrg="vecViewportOrg",kBlockCreationMode = "BlockCreationMode";
	String tDisabled = T("<|Disabled|>"),tDefaultEntry = T("<|Default|>"), tNoGroupAssignment =T("|No group assigment|");
	String sGroupings[] = { tDefaultEntry, tNoGroupAssignment};
//endregion 	

int nMode=_Map.getInt("mode");

//region functions #FU

//region visPp
//
void visPp(PlaneProfile _pp,Vector3d _vec)
{
	_pp.transformBy(_vec);
	_pp.vis(6);
	_pp.transformBy(-_vec);
	return;
}
//End visPp//endregion

//region visBd
//
void visBd(Body _bd,Vector3d _vec)
{
	_bd.transformBy(_vec);
	_bd.vis(6);
	_bd.transformBy(-_vec);
	return;
}
//End visPp//endregion


//region Function getTslsByName
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
	}
//End getTslsByName //endregion
	
//region calcEnvBody
// HSB-22263
// it returns the cube envelope body of the body in _XW,_YW,_ZW
	Body calcEnvBody(Body _bd)
	{ 
		Body _bdEnv;
		PlaneProfile _ppX=_bd.shadowProfile(Plane(_bd.ptCen(),_XW));
		PlaneProfile _ppY=_bd.shadowProfile(Plane(_bd.ptCen(),_YW));
		
	// get extents of profile
		LineSeg segX = _ppX.extentInDir(_YW);
		double _dZ = abs(_ZW.dotProduct(segX.ptStart()-segX.ptEnd()));
		double _dY = abs(_YW.dotProduct(segX.ptStart()-segX.ptEnd()));
		
		LineSeg segY = _ppY.extentInDir(_XW);
		double _dX = abs(_XW.dotProduct(segY.ptStart()-segY.ptEnd()));
		
		Point3d _ptMid=segX.ptMid();
		Point3d _ptMidY=segY.ptMid();
		_ptMid+=_XW*_XW.dotProduct(_ptMidY-_ptMid);
		if(_dX<dEps || _dY<dEps || _dZ<dEps)
		{ 
			return _bdEnv;
		}
		else
		{
			_bdEnv=Body(_ptMid,_XW,_YW,_ZW,_dX,_dY,_dZ,0,0,0);
		}
		return _bdEnv;
	}
//End calcEnvBody//endregion

//region getHatchDefinition
// 
	Map getHatchDefinition(Map _mIn, int& _nHatchesUsed, Map &_mapEntityI)
	{ 
		// in
		Map _mapHatches=_mIn.getMap("mapHatches");
		int _nHatchMapping=_mIn.getInt("nHatchMapping");
		int _bPainterGroup=_mIn.getInt("bPainterGroup");
		String _sMaterial=_mIn.getString("sMaterial");
		int _j=_mIn.getInt("indexJ");
		int _bHasIndexJ=_mIn.hasInt("indexJ");
		String _sOrientation=_mIn.getString("sOrientation");
		Map _mapHatchDefaultPainter=_mIn.getMap("mapHatchDefaultPainter");
		int _nHatchDefaultPainterIndex=_mIn.getInt("nHatchDefaultPainterIndex");
		String _sRule=_mIn.getString("sRule");
		Entity _ent=_mIn.getEntity("ent");
		String _sPainterFormat=_mIn.getString("sPainterFormat");
		
		// out
		Map _mOut;
		int _bOrientationFound,_bMaterialFound;
		Map _mapHatchFound, _mapOrientationFound;
		
		String _sEntityType=_ent.typeName();
		
		if(_nHatchMapping==0)
		for (int k=0;k<_mapHatches.length();k++)
		{ 
			_bMaterialFound = false;
			Map mapHatchK = _mapHatches.getMap(k);
			if (mapHatchK.hasString("Name") && _mapHatches.keyAt(k).makeLower() == "hatch")
			{
				// HSB-7706
				if (!mapHatchK.getInt("isActive"))continue;
				// the anisotropic condition
				int bAnisotropic = mapHatchK.getInt("Anisotropic");
				// get all materials for which this hatch pattern is appli
				Map mapMaterials = mapHatchK.getMap("Material[]");
				mapMaterials = mapHatchK.getMap("Material[]");
				if (mapMaterials.length() < 1)
				{
					// no orientation map defined for this material 
					reportMessage("\n"+scriptName()+" "+T("|no map of materials found for the material of the|")+" "+_sEntityType);
					eraseInstance();
					return;
				}
				// find if the material is included in this hatch definition
				for (int l = 0; l < mapMaterials.length(); l++)
				{
					Map mapMaterialL = mapMaterials.getMap(l);
					if (mapMaterialL.hasString("Name") && mapMaterials.keyAt(l).makeLower() == "material")
					{
						String sMaterialMap = mapMaterialL.getString("Name");
						if (sMaterialMap.makeUpper() == _sMaterial.makeUpper())
						{ 
							// material found
							_bMaterialFound = true;
							// break "l" loop for materials
							_mapHatchFound = mapHatchK;
							if (_nHatchesUsed.find(k) < 0)_nHatchesUsed.append(k);
							
							if(_bHasIndexJ)
							{ 
								if(_j==0)
									_mapEntityI.setInt("hatch0",k);
								else if(_j==1)
									_mapEntityI.setInt("hatch1",k);
								else if(_j==2)
									_mapEntityI.setInt("hatch2",k);
								else if(_j==3)
									_mapEntityI.setInt("hatch3",k);
								else if(_j==4)
									_mapEntityI.setInt("hatch4",k);
							}
							else if(!_bHasIndexJ)
							{ 
								_mapEntityI.setInt("hatch0",k);
							}
							
							break;
						}
					}
				}//next l
				if (!_bMaterialFound)
				{ 
					// material not found at the mapMaterials of this mapHatch, keep looking
					// continue lop k
					continue;
				}
				// material is found, find the orientation
				Map mapOrientations = mapHatchK.getMap("Orientation[]");
				if (mapOrientations.length() < 1)
				{ 
					// no orientation map defined for this material 
					reportMessage("\n"+scriptName()+" "+T("|no map of orientation found for the material of the|")+" "+_sEntityType);
					eraseInstance();
					return;
				}
				// find the orientation for this component, initialize with false
				_bOrientationFound = false;
				// distinguish between isotropic and anisotropic materials
				if (!bAnisotropic)
				{ 
					// isotropic material, simply get the first definition
					for (int l = 0; l < mapOrientations.length(); l++)
					{ 
						Map mapOrientationL = mapOrientations.getMap(l);
						if (mapOrientationL.hasString("Name") && mapOrientations.keyAt(l).makeLower() == "orientation")
						{ 
							_mapOrientationFound = mapOrientationL;
							_bOrientationFound = true;
							break;
						}
					}//next l
				}
				else
				{ 
					// anisotropic material, find the right one
					for (int l = 0; l < mapOrientations.length(); l++)
					{ 
						Map mapOrientationL = mapOrientations.getMap(l);
						if (mapOrientationL.hasString("Name") && mapOrientations.keyAt(l).makeLower() == "orientation")
						{ 
							String sOrientationMap = mapOrientationL.getString("Name");
							if (sOrientationMap.makeUpper() != _sOrientation.makeUpper())
							{ 
								// not this orientation
								continue;
							}
							_mapOrientationFound = mapOrientationL;
							_bOrientationFound = true;
							break;
						}
					}//next l
				}
			}
			if (_bMaterialFound && _bOrientationFound)break;
		}//next k
		if(_nHatchMapping==1 && !_bPainterGroup)
		{ 
			_mapHatchFound=_mapHatchDefaultPainter;
			if (_nHatchesUsed.find(_nHatchDefaultPainterIndex) < 0)_nHatchesUsed.append(_nHatchDefaultPainterIndex);
			_bMaterialFound=true;
			
			if(_bHasIndexJ)
			{ 
				if(_j==0)
					_mapEntityI.setInt("hatch0",_nHatchDefaultPainterIndex);
				else if(_j==1)
					_mapEntityI.setInt("hatch1",_nHatchDefaultPainterIndex);
				else if(_j==2)
					_mapEntityI.setInt("hatch2",_nHatchDefaultPainterIndex);
				else if(_j==3)
					_mapEntityI.setInt("hatch3",_nHatchDefaultPainterIndex);
				else if(_j==4)
					_mapEntityI.setInt("hatch4",_nHatchDefaultPainterIndex);
			}
			else if(!_bHasIndexJ)
			{ 
				_mapEntityI.setInt("hatch0",_nHatchDefaultPainterIndex);
			}
			
			Map mapOrientations=_mapHatchFound.getMap("Orientation[]");
			if (mapOrientations.length()<1)
			{ 
				// no orientation map defined for this material 
				reportMessage("\n"+scriptName()+" "+T("|no map of orientation found for the material of the|")+" "+_sEntityType);
				eraseInstance();
				return;
			}
			// find the orientation for this component, initialize with false
			_bOrientationFound=false;
			int bAnisotropic=_mapHatchFound.getInt("Anisotropic");
			if(!bAnisotropic)
			{ 
				if(_bHasIndexJ)
				{ 
					if(_j==0)
						_mapEntityI.setString("orientation0","X");
					else if(_j==1)
						_mapEntityI.setString("orientation1","X");
					else if(_j==2)
						_mapEntityI.setString("orientation2","X");
					else if(_j==3)
						_mapEntityI.setString("orientation3","X");
					else if(_j==4)
						_mapEntityI.setString("orientation4","X");
				}
				else if(!_bHasIndexJ)
				{ 
					_mapEntityI.setString("orientation0","X");
				}
			}
			// distinguish between isotropic and anisotropic materials
			if (!bAnisotropic)
			{ 
				// isotropic material, simply get the first definition
				for (int l=0;l<mapOrientations.length(); l++)
				{ 
					Map mapOrientationL = mapOrientations.getMap(l);
					if (mapOrientationL.hasString("Name") && mapOrientations.keyAt(l).makeLower() == "orientation")
					{ 
						_mapOrientationFound = mapOrientationL;
						_bOrientationFound = true;
						break;
					}
				}//next l
			}
			else
			{ 
				// anisotropic material, find the right one
				for (int l = 0; l < mapOrientations.length(); l++)
				{ 
					Map mapOrientationL = mapOrientations.getMap(l);
					if (mapOrientationL.hasString("Name") && mapOrientations.keyAt(l).makeLower() == "orientation")
					{ 
						String sOrientationMap = mapOrientationL.getString("Name");
						if (sOrientationMap.makeUpper() != _sOrientation.makeUpper())
						{ 
							// not this orientation
							continue;
						}
						_mapOrientationFound = mapOrientationL;
						_bOrientationFound = true;
						break;
					}
				}//next l
			}
		}
		else if(_nHatchMapping && _bPainterGroup)
		{ 
			for (int k = 0; k < _mapHatches.length(); k++)
			{
				Map mapHatchK = _mapHatches.getMap(k);
				if (mapHatchK.hasString("Name") && _mapHatches.keyAt(k).makeLower() == "hatch")
				{
					// HSB-7706
					if ( ! mapHatchK.getInt("isActive"))continue;
					if ( ! mapHatchK.hasString("PainterGroup"))continue;
					// 
					if (!mapHatchK.hasString("Painter"))continue;
					if(mapHatchK.getString("Painter")!=_sRule)continue;
					String sPainterGroupMap = mapHatchK.getString("PainterGroup");
//					String sFormatI = sip.formatObject(sPainterFormat);
					String sFormatI = _ent.formatObject(_sPainterFormat);
					if (sPainterGroupMap.makeUpper() == sFormatI.makeUpper())
					{
						_mapHatchFound = mapHatchK;
						if (_nHatchesUsed.find(k) < 0)_nHatchesUsed.append(k);
						_bMaterialFound = true;
						if(_bHasIndexJ)
						{ 
							if(_j==0)
								_mapEntityI.setInt("hatch0",k);
							else if(_j==1)
								_mapEntityI.setInt("hatch1",k);
							else if(_j==2)
								_mapEntityI.setInt("hatch2",k);
							else if(_j==3)
								_mapEntityI.setInt("hatch3",k);
							else if(_j==4)
								_mapEntityI.setInt("hatch4",k);
						}
						else if(!_bHasIndexJ)
						{ 
							_mapEntityI.setInt("hatch0",k);
						}
						break;
					}
				}
			}
		}
		
		_mOut.setInt("bOrientationFound",_bOrientationFound);
		_mOut.setInt("bMaterialFound",_bMaterialFound);
		_mOut.setMap("mapHatchFound",_mapHatchFound);
		_mOut.setMap("mapOrientationFound",_mapOrientationFound);
		
		return _mOut;
	}
//End getHatchDefinition//endregion

//region calcInsulation
// returns a list of lines that represent insulation
	PLine[] calcInsulation(Map _mIn)
	{ 
		PLine _plInsulationsFinal[0];
		PLine _plInsulations[0];
		
		PlaneProfile _pp=_mIn.getPlaneProfile("pp");
		Vector3d _vecDir=_mIn.getVector3d("vecDir");
		Vector3d _vecWidth=_mIn.getVector3d("vecWidth");
		double _dScaleLongitudinal=_mIn.getDouble("dScaleLongitudinal");
		double _dScaleTransversal=_mIn.getDouble("dScaleTransversal");
		double _dScale=_mIn.getDouble("dScale");
		double _dWidthModule=_mIn.getDouble("dWidthModule");
		double _dDiameterModule=_mIn.getDouble("dDiameterModule");
		// 
		PlaneProfile _ppInsulation(_pp.coordSys());
		PlaneProfile _ppInsulations[0];
		
		PLine _plInsulation(_pp.coordSys().vecZ());
		
		PLine _plRings[]=_pp.allRings(true, false);
		
		for (int ipl=0;ipl<_plRings.length();ipl++) 
		{ 
			PlaneProfile ppI = _pp.coordSys();
			ppI.joinRing(_plRings[ipl], _kAdd);
			int nNr;
			{ 
				// get extents of profile
//						Vector3d _vecDir=vecZPanel.crossProduct(_ZW);
//						Vector3d vecWidth=vecZPanel;
//						if(sOrientation=="Z")
//						{ 
//							_vecDir = vecWoodGrainDirection;
//							vecWidth=vecZPanel.crossProduct(_vecDir);
//						}
//						_vecDir.normalize();
//						vecWidth.normalize();
				LineSeg segPp=ppI.extentInDir(_vecDir);
				double dWidthPp=abs(_vecWidth.dotProduct(segPp.ptStart()-segPp.ptEnd()));
				dWidthPp = dWidthPp-U(1);
//				dWidthPp -= U(1);
				// enforced scaling
	//			double dScaleY=(dWidthPp-dDiameter)/(.5*dWidthModule);
	//			double dScaleX=dDiameter/dDiameterModule;
				// ratio between 2 scales
				if(_dScaleLongitudinal==0)_dScaleLongitudinal=1;
				if(_dScaleTransversal==0)_dScaleTransversal=1;
				if(_dScaleTransversal==0)_dScaleTransversal=1;
				if(_dScale>=0)_dScaleLongitudinal=_dScaleTransversal*_dScale;
				double dFactorXy=_dScaleLongitudinal/_dScaleTransversal;
				double dScaleY=(dWidthPp/(0.5*_dWidthModule))/
					(1+(dFactorXy*_dDiameterModule/(0.5*_dWidthModule)));
				double dScaleX=dScaleY*dFactorXy;
				double dDiameter=_dDiameterModule*dScaleX;
				
				double dXsscale[0],dYsscale[0];
				for (int ii=0;ii<dXs.length();ii++) 
				{ 
					dXsscale.append(dScaleX*dXs[ii]);
					dYsscale.append(dScaleY*dYs[ii]);
				}//next ii
				
			// vector in paperspace
				Point3d _pt1,_pt2;
				_pt1=_pp.extentInDir(_vecDir).ptStart();
				_pt1+=_vecWidth*_vecWidth
					.dotProduct(ppI.extentInDir(_vecDir).ptMid()-_pt1);
				_pt2=_pp.extentInDir(_vecDir).ptEnd();
				_pt2+=_vecWidth*_vecWidth
					.dotProduct(ppI.extentInDir(_vecDir).ptMid()-_pt2);
				_pt1.vis(3);
				_pt2.vis(3);
				
				double dLengthI=(_pt2-_pt1).length();
				_plInsulation.addVertex(_pt1);
				PLine plInsulationStart(ppI.coordSys().vecZ());
				PLine plInsulationEnd(ppI.coordSys().vecZ());
				plInsulationStart.addVertex(_pt1);
				
				// last curly point
				Point3d ptLastCurly;
				if(dLengthI-dScaleX*2*dXs[0]>=dDiameter)
				{ 
					nNr = (dLengthI-dScaleX*2*dXs[0])/dDiameter;
					double dLengthDiameters=nNr*dDiameter;
					double dStartEnd=dLengthI-dScaleX*2*dXs[0]-dLengthDiameters;dStartEnd/=2.0;
					
					Point3d ptsI[0];
					Point3d ptStartI=_pt1+_vecDir*dStartEnd;
					ptStartI.vis(6);
					
				// try the fisrt iteration
					PLine plI(ppI.coordSys().vecZ());
					plInsulationStart.addVertex(ptStartI);
					plInsulationStart.addVertex(ptStartI+_vecDir*dXsscale[0]+_vecWidth*dYsscale[0]);
					_plInsulation.addVertex(ptStartI);
					for (int ii=0;ii<dXs.length();ii++) 
					{ 
						Point3d pt1I=ptStartI+_vecDir*dXsscale[ii]+_vecWidth*dYsscale[ii];
						pt1I.vis(6);
						ptsI.append(pt1I);
					}//next ii
					if(nNr<nInrLimit)
					for (int iCount=0;iCount<nNr;iCount++) 
					{ 
						PLine plInsulationI(ppI.coordSys().vecZ());
						Vector3d vecTransform=_vecDir*iCount*dDiameter;
						for (int ii=0;ii<ptsI.length();ii++) 
						{ 
							Point3d ptIi=ptsI[ii];
							ptIi.transformBy(vecTransform);
							if(nArch[ii] && ii==2)
							{ 
								_plInsulation.addVertex(ptIi,.5*dDiameter,1);
								plInsulationI.addVertex(ptIi,.5*dDiameter,1);
								ptLastCurly=ptIi;
							}
							else if(nArch[ii] && ii==4)
							{ 
								_plInsulation.addVertex(ptIi,.5*dDiameter,0);
								plInsulationI.addVertex(ptIi,.5*dDiameter,0);
								ptLastCurly=ptIi;
							}
							else
							{ 
								_plInsulation.addVertex(ptIi);
								plInsulationI.addVertex(ptIi);
								ptLastCurly=ptIi;
							}
						}//next ii
					// HSB-16893: Use pline for drawing the insulation
						_plInsulations.append(plInsulationI);
//								PLine plInsulationIoffset = plInsulationI;
//								plInsulationIoffset.offset(3*dEps);
//								plInsulationIoffset.reverse();
//								plInsulationI.append(plInsulationIoffset);
//								plInsulationI.close();
//								PlaneProfile ppInsulationI(ppI.coordSys());
//								ppInsulationI.joinRing(plInsulationI, _kAdd);
//								ppInsulationI.intersectWith(ppI);
//								ppInsulation.unionWith(ppInsulationI);
//								ppInsulation.shrink(.1*dEps);
//								ppInsulation.shrink(-.1*dEps);
//								ppInsulation.shrink(-.1*dEps);
//								ppInsulation.shrink(.1*dEps);
//								ppInsulations.append(ppInsulationI);
					}//next iCount
				}
				else
				{
					_plInsulation.addVertex(_pt2);
					ptLastCurly.vis(2);
					plInsulationEnd.addVertex(ptLastCurly);
					plInsulationEnd.addVertex(_pt2);
				}
				_plInsulation.addVertex(_pt2);
				plInsulationEnd.addVertex(ptLastCurly);
				plInsulationEnd.addVertex(_pt2);
				if(nNr>0 && nNr<nInrLimit)
				{ 
				// start
					PLine plInsulationStartoffset = plInsulationStart;
				// HSB-16893: Use pline for drawing the insulation
					_plInsulations.append(plInsulationStartoffset);
//							plInsulationStartoffset.offset(3*dEps);
//							plInsulationStartoffset.reverse();
//							plInsulationStart.append(plInsulationStartoffset);
//							plInsulationStart.close();
//							PlaneProfile ppInsulationI(ppI.coordSys());
//							ppInsulationI.joinRing(plInsulationStart, _kAdd);
//							ppInsulationI.intersectWith(pp);
//							ppInsulationI.vis(2);
//							ppInsulation.unionWith(ppInsulationI);
//							ppInsulation.shrink(.1*dEps);
//							ppInsulation.shrink(-.1*dEps);
//							ppInsulation.shrink(-.1*dEps);
//							ppInsulation.shrink(.1*dEps);
//							ppInsulations.append(ppInsulationI);
					
				// end
					PLine plInsulationEndoffset = plInsulationEnd;
				// HSB-16893: Use pline for drawing the insulation	
					_plInsulations.append(plInsulationEndoffset);
//							plInsulationEndoffset.offset(3*dEps);
//							plInsulationEndoffset.reverse();
//							plInsulationEnd.append(plInsulationEndoffset);
//							plInsulationEnd.close();
//							ppInsulationI=PlaneProfile (ppI.coordSys());
//							ppInsulationI.joinRing(plInsulationEnd, _kAdd);
//							ppInsulationI.intersectWith(pp);
//							ppInsulation.unionWith(ppInsulationI);
//							ppInsulation.shrink(.1*dEps);
//							ppInsulation.shrink(-.1*dEps);
//							ppInsulation.shrink(-.1*dEps);
//							ppInsulation.shrink(.1*dEps);
//							ppInsulations.append(ppInsulationI);
				}
			}
			if(nNr>0 && nNr<nInrLimit)
			{ 
//				dp.transparency(nTransparency);
//				dp.color(nColor);
	//			dp.draw(plInsulation);
//						for (int ipp=0;ipp<ppInsulations.length();ipp++) 
//						{ 
//							dp.draw(ppInsulations[ipp],_kDrawFilled);; 
//						}//next ipp
			// HSB-16893: Use pline for drawing the insulation
				for (int ipp=0;ipp<_plInsulations.length();ipp++) 
				{ 
					PLine plSplit=_plInsulations[ipp];
					PLine plSplits[]=_pp.splitPLine(plSplit,true,true);
//						dp.draw(plInsulations[ipp]);
					for (int jpp=0;jpp<plSplits.length();jpp++) 
					{ 
						_plInsulationsFinal.append(plSplits[jpp]);
//						dp.draw(plSplits[jpp]);
					}//next jpp
				}//next ipp
			}
		}//next ipl
		
		
		return _plInsulationsFinal;
	}
//End calcInsulation//endregion

//region getFastenerGuidline
// returns the guidline corresponding to the FastenerAssemblyEnt fae
// HSB-24107
	FastenerGuideline getFastenerGuidline(FastenerAssemblyEnt fae)
	{ 
		FastenerGuideline fg;
		
		ToolEnt toolEnt=fae.guidelineToolEnt();
		FastenerGuideline fGuidelines[]=toolEnt.fastenerGuidelines();
		
		Point3d ptCf=fae.realBody().ptCen();
		
		fg=fGuidelines[0];
		Point3d ptMfg=.5*(fg.ptStart()+fg.ptEnd());
		double dDistMin=(ptCf-ptMfg).length();
		for (int i=1;i<fGuidelines.length();i++) 
		{ 
			FastenerGuideline fgI=fGuidelines[i]; 
			ptMfg=.5*(fgI.ptStart()+fgI.ptEnd());
			double dDistMinI=(ptCf-ptMfg).length();
			if(dDistMinI<dDistMin)
			{ 
				dDistMin=dDistMinI;
				fg=fgI;
			}
		}//next i
		
		return fg;
	}
//endregion getFastenerGuidline

//End functions #FU//endregion 

//region Properties
// display color
	int nc = 31;
//End Properties//endregion 
	
//region HSB-11492 DialogMode
	String sInsulation=T("|Insulation|");
	int nDialogMode = _Map.getInt("DialogMode");
	if(nDialogMode==1 || nDialogMode==2)
	{ 
		String sOpmKey = "HatchModify";
		if (nDialogMode == 2)sOpmKey = "HatchAdd";
		setOPMKey(sOpmKey);
	// hatch general properties
		category=T("|Hatch|");
		String sHatchNameName=T("|Name|");
		//0
		PropString sHatchName(nStringIndex++, "", sHatchNameName);
		sHatchName.setDescription(T("|Defines the Hatch Name|"));
		sHatchName.setCategory(category);
		if(nDialogMode==1)
		{ 
		// modify
			int nHatchMapping=_Map.getInt("nHatchMapping");
			// readonly when by painter, we dont want to change the name of the hatch in map
			if(nHatchMapping)
				sHatchName.setReadOnly(_kReadOnly);
		}
		// isactive
		//1
		String sHatchActiveName=T("|Active|");	
		PropString sHatchActive(nStringIndex++, sNoYes, sHatchActiveName);	
		sHatchActive.setDescription(T("|Defines the Flag Active for the Hatch|"));
		sHatchActive.setCategory(category);
		
		// anisotropy
		//2
		String sHatchAnisotropyName=T("|Anisotropy|");
		PropString sHatchAnisotropy(nStringIndex++, sNoYes, sHatchAnisotropyName);
		sHatchAnisotropy.setDescription(T("|Defines the Flag Anisotropy for the Hatch|"));
		sHatchAnisotropy.setCategory(category);
		// materials
		//3
		String sHatchMaterialsName=T("|Material|");
		PropString sHatchMaterials(nStringIndex++, "", sHatchMaterialsName);
		sHatchMaterials.setDescription(T("|Defines the Materials where the Hatch can be applied to|"));
		sHatchMaterials.setCategory(category);
	// contour
		// flag for the contour
		category=T("|Contour|");
		//4
		String sContourName=T("|Contour|");	
		String sContours[]={ sNoYes[0],sNoYes[1]};
		String ssVaries[] ={ sVaries, sNoYes[0], sNoYes[1]};
		if(_Map.getInt("Contour"))
		{
			sContours.setLength(0);
			sContours.append(ssVaries);
		}
		PropString sContour(nStringIndex++, sContours, sContourName);	
		sContour.setDescription(T("|Defines the Flag for the Contour|"));
		sContour.setCategory(category);
		
		// 5 color of the contour
		String sContourColorName=T("|Color|");
		PropString sContourColor(nStringIndex++, "-2", sContourColorName);	
		sContourColor.setDescription(T("|Defines the Contour Color. -2 by entity; -1 by layer|"));
		sContourColor.setCategory(category);
		
//		String sContourColorName=T("|Color|");
//		int nContourColors[]={1,2,3};
//		//0
//		PropInt nContourColor(nIntIndex++, -2, sContourColorName);
//		nContourColor.setDescription(T("|Defines the Contour Color. -2 by entity; -1 by layer|"));
//		nContourColor.setCategory(category);
		// 6 thickness of the contour
		String sContourThicknessName=T("|Thickness|");	
		PropString sContourThickness(nStringIndex++, "0", sContourThicknessName);	
		sContourThickness.setDescription(T("|Defines the Contour Thickness|"));
		sContourThickness.setCategory(category);
		//0
//		String sContourThicknessName=T("|Thickness|");
//		PropDouble dContourThickness(nDoubleIndex++, U(0), sContourThicknessName);	
//		dContourThickness.setDescription(T("|Defines the Contour Thickness|"));
//		dContourThickness.setCategory(category);
		//5 HSB-12339
		//7
		String sSupressBeamCrosss[]={ sNoYes[0],sNoYes[1]};
		if(_Map.getInt("SupressBeamCross"))
		{
			sSupressBeamCrosss.setLength(0);
			sSupressBeamCrosss.append(ssVaries);
		}
		String sSupressBeamCrossName=T("|Supress Beam Cross|");	
		PropString sSupressBeamCross(nStringIndex++, sSupressBeamCrosss, sSupressBeamCrossName);	
		sSupressBeamCross.setDescription(T("|Flag to supress the Beam Cross Symbol|"));
		sSupressBeamCross.setCategory(category);
		
	// solid hatch
		// flag for the solid hatch
		category=T("|Solid Hatch|");
		//8
		String sSolidHatchs[]={ sNoYes[0],sNoYes[1]};
		if(_Map.getInt("SolidHatch"))
		{
			sSolidHatchs.setLength(0);
			sSolidHatchs.append(ssVaries);
		}
		String sSolidHatchName=T("|Hatch|");
		PropString sSolidHatch(nStringIndex++, sSolidHatchs, sSolidHatchName);
		sSolidHatch.setDescription(T("|Defines the Flag for the Solid Hatch|"));
		sSolidHatch.setCategory(category);
		// 9 transparency for the solid hatch
		String sSolidTransparencyName=T("|Transparency|");	
		PropString sSolidTransparency(nStringIndex++, "0", sSolidTransparencyName);	
		sSolidTransparency.setDescription(T("|Defines Transparency for the Solid Hatch|"));
		sSolidTransparency.setCategory(category);
		
//		String sSolidTransparencyName=T("|Transparency|");
//		int nSolidTransparencys[]={1,2,3};
//		//1
//		PropInt nSolidTransparency(nIntIndex++, 0, sSolidTransparencyName);	
//		nSolidTransparency.setDescription(T("|Defines Transparency for the Solid Hatch|"));
//		nSolidTransparency.setCategory(category);
		// 10 color for the solid hatch
		String sSolidColorName=T("|Color|");	
		PropString sSolidColor(nStringIndex++, "-2", sSolidColorName);	
		sSolidColor.setDescription(T("|Defines the Color for the Solid Hatch. -2 by entity; -1 by layer|"));
		sSolidColor.setCategory(category);
		
//		String sSolidColorName=T("|Color|");	
//		int nSolidColors[]={1,2,3};
//		//2
//		PropInt nSolidColor(nIntIndex++, -2, sSolidColorName);	
//		nSolidColor.setDescription(T("|Defines the Color for the Solid Hatch. -2 by entity; -1 by layer|"));
//		nSolidColor.setCategory(category);
		
	// orientation X
		//
		category=T("|Orientation|");
		//11
		String sOrientationXName=T("|Orientation|");	
		PropString sOrientationX(nStringIndex++, "", sOrientationXName);	
		sOrientationX.setDescription(T("|Defines the Orientation|"));
		sOrientationX.setCategory(category);
		sOrientationX.setReadOnly(true);
		// pattern for orientation X
		String sPatterns[0];
		sPatterns.append(_HatchPatterns);
		sPatterns.append(sInsulation);
		sPatterns.sorted();
		//12
		String sOrientationXpatternName=T("|Pattern|");
		PropString sOrientationXpattern(nStringIndex++, sPatterns, sOrientationXpatternName);
		sOrientationXpattern.setDescription(T("|Defines the pattern for the Orientation in|")+" "+sOrientationX);
		sOrientationXpattern.setCategory(category);
		// 13 color
		String sOrientationXcolorName=T("|Color|");	
		PropString sOrientationXcolor(nStringIndex++, "-2", sOrientationXcolorName);	
		sOrientationXcolor.setDescription(T("|Defines the color for the Orientation in|")+
		+" "+sOrientationX+" "+ T("|-2 by entity; -1 by layer|"));
		sOrientationXcolor.setCategory(category);
		
//		String sOrientationXcolorName=T("|Color|");
//		int nOrientationXcolors[]={1,2,3};
//		//3
//		PropInt nOrientationXcolor(nIntIndex++, -2, sOrientationXcolorName);
//		nOrientationXcolor.setDescription(T("|Defines the color for the Orientation in|")+
//		+" "+sOrientationX+" "+ T("|-2 by entity; -1 by layer|"));
//		nOrientationXcolor.setCategory(category);
		// 14 transparency
		String sOrientationXtransparencyName=T("|Transparency|");	
		PropString sOrientationXtransparency(nStringIndex++, "0", sOrientationXtransparencyName);	
		sOrientationXtransparency.setDescription(T("|Defines the transparency for the Orientation in|")+" "+sOrientationX);
		sOrientationXtransparency.setCategory(category);
		
//		String sOrientationXtransparencyName=T("|Transparency|");	
//		int nOrientationXtransparencys[]={1,2,3};
//		//4
//		PropInt nOrientationXtransparency(nIntIndex++, 0, sOrientationXtransparencyName);	
//		nOrientationXtransparency.setDescription(T("|Defines the transparency for the Orientation in|")+" "+sOrientationX);
//		nOrientationXtransparency.setCategory(category);
		// 15 angle
		String sOrientationXangleName=T("|Angle|");	
		PropString sOrientationXangle(nStringIndex++, "0", sOrientationXangleName);	
		sOrientationXangle.setDescription(T("|Defines the Angle for the Orientation in|")+" "+sOrientationX);
		sOrientationXangle.setCategory(category);
		//1
//		String sOrientationXangleName=T("|Angle|");	
//		PropDouble dOrientationXangle(nDoubleIndex++, U(0), sOrientationXangleName);	
//		dOrientationXangle.setDescription(T("|Defines the Angle for the Orientation in|")+" "+sOrientationX);
//		dOrientationXangle.setCategory(category);
		// 16 scale
		String sOrientationXscaleName=T("|Scale|");	
		PropString sOrientationXscale(nStringIndex++, "0", sOrientationXscaleName);	
		sOrientationXscale.setDescription(T("|Defines the Scale for the Orientation in|")+" "+sOrientationX+" "+
		T("|When Insulation is selected this represents the scaling of the Insulation pattern.|"));
		sOrientationXscale.setCategory(category);
		
		//2
//		String sOrientationXscaleName=T("|Scale|");	
//		PropDouble dOrientationXscale(nDoubleIndex++, U(0), sOrientationXscaleName);
//		dOrientationXscale.setDescription(T("|Defines the Scale for the Orientation in|")+" "+sOrientationX+" "+
//		T("|When Insulation is selected this represents the scaling of the Insulation pattern.|"));
//		dOrientationXscale.setCategory(category);
		// scalemin
		//17
		String sOrientationXscaleMinName=T("|Scale Min.|");	
		PropString sOrientationXscaleMin(nStringIndex++, "0", sOrientationXscaleMinName);	
		sOrientationXscaleMin.setDescription(T("|Defines the min. Scale for the Orientation in|")+" "+sOrientationX);
		sOrientationXscaleMin.setCategory(category);
		
//		String sOrientationXscaleMinName=T("|Scale Min.|");	
//		PropDouble dOrientationXscaleMin(nDoubleIndex++, U(0), sOrientationXscaleMinName);	
//		dOrientationXscaleMin.setDescription(T("|Defines the min. Scale for the Orientation in|")+" "+sOrientationX);
//		dOrientationXscaleMin.setCategory(category);
		// static flag
		//18
		String sOrientationXstatics[0];
		sOrientationXstatics.append(sHatchModes);
		if(_Map.getInt("StaticX"))
		{
			sOrientationXstatics.setLength(0);
			sOrientationXstatics.append(sVaries);
			sOrientationXstatics.append(sHatchModes);
		}
		String sOrientationXstaticName=T("|Scaling mode|");
		PropString sOrientationXstatic(nStringIndex++, sOrientationXstatics, sOrientationXstaticName);
		sOrientationXstatic.setDescription(T("|Defines the hatch scaling mode for the Orientation in|")+" "+sOrientationX+" "+
		T("|by Hatch Pattern|")+" "+T("|means that the hatch scaling factor is not adapted to the size of the hatching area|")+" "+
		T("|Dynamic|")+" "+T("|means that the hatch scaling factor is adapted to the size of the hatched area|")+" "+
		T("|The larges hatch area the hatch factor is applied unchanged.|")+" "+T("|For all other smaller areas the hatch scaling factor is scaled down proportionally to the minimal area length.|"));
		sOrientationXstatic.setCategory(category);
		// 10
//		category=T("|Insulation|");
//		String sInsulationXName=T("|Insulation|");	
//		PropString sInsulationX(nStringIndex++, sNoYes, sInsulationXName,0);	
//		sInsulationX.setDescription(T("|Defines the Insulation|"));
//		sInsulationX.setCategory(category);
//		
//		// HSB-12334: insulation 
//		String sScaleLongitudinalXName=T("|Scale Longitudinal|");	
//		PropDouble dScaleLongitudinalX(nDoubleIndex++, U(0), sScaleLongitudinalXName);	
//		dScaleLongitudinalX.setDescription(T("|Defines the Longitudinal Scale|"));
//		dScaleLongitudinalX.setCategory(category);
//		
//		String sScaleTransversalXName=T("|Scale Transversal|");
//		PropDouble dScaleTransversalX(nDoubleIndex++, U(0), sScaleTransversalXName);
//		dScaleTransversalX.setDescription(T("|Defines the Transversal Scale|"));
//		dScaleTransversalX.setCategory(category);
		if(nDialogMode==2)
		{ 
		// extra properties when adding hatch
		// orientation Y
			category=T("|Orientation Y|");
			// 19
			String sOrientationYName=T("|Orientation|");	
			PropString sOrientationY(nStringIndex++, "", sOrientationYName);	
			sOrientationY.setDescription(T("|Defines the Orientation|"));
			sOrientationY.setCategory(category);
			sOrientationY.setReadOnly(true);
			// 20
			String sOrientationYpatternName=T("|Pattern|");
			PropString sOrientationYpattern(nStringIndex++, sPatterns, sOrientationYpatternName);
			sOrientationYpattern.setDescription(T("|Defines the pattern for the Orientation in Y|"));
			sOrientationYpattern.setCategory(category);
			// 21 color
			String sOrientationYcolorName=T("|Color|");	
			PropString sOrientationYcolor(nStringIndex++, "-2", sOrientationYcolorName);	
			sOrientationYcolor.setDescription(T("|Defines the color for the Orientation in Y. -2 by entity; -1 by layer|"));
			sOrientationYcolor.setCategory(category);
			
//			String sOrientationYcolorName=T("|Color|");
//			int nOrientationYcolors[]={1,2,3};
//			//5
//			PropInt nOrientationYcolor(nIntIndex++, -2, sOrientationYcolorName);
//			nOrientationYcolor.setDescription(T("|Defines the color for the Orientation in Y. -2 by entity; -1 by layer|"));
//			nOrientationYcolor.setCategory(category);
			// 22 transparency
			String sOrientationYtransparencyName=T("|Transparency|");	
			PropString sOrientationYtransparency(nStringIndex++, "0", sOrientationYtransparencyName);	
			sOrientationYtransparency.setDescription(T("|Defines the transparency for the Orientation in Y|"));
			sOrientationYtransparency.setCategory(category);
			
//			String sOrientationYtransparencyName=T("|Transparency|");	
//			int nOrientationYtransparencys[]={1,2,3};
//			//6
//			PropInt nOrientationYtransparency(nIntIndex++, 0, sOrientationYtransparencyName);
//			nOrientationYtransparency.setDescription(T("|Defines the transparency for the Orientation in Y|"));
//			nOrientationYtransparency.setCategory(category);
			// 23 angle 
			String sOrientationYangleName=T("|Angle|");	
			PropString sOrientationYangle(nStringIndex++, "0", sOrientationYangleName);	
			sOrientationYangle.setDescription(T("|Defines the Angle for the Orientation in Y|"));
			sOrientationYangle.setCategory(category);
			
//			String sOrientationYangleName=T("|Angle|");	
//			PropDouble dOrientationYangle(nDoubleIndex++, U(0), sOrientationYangleName);
//			dOrientationYangle.setDescription(T("|Defines the Angle for the Orientation in Y|"));
//			dOrientationYangle.setCategory(category);
			// 24 scale 
			String sOrientationYscaleName=T("|Scale|");	
			PropString sOrientationYscale(nStringIndex++, "0", sOrientationYscaleName);	
			sOrientationYscale.setDescription(T("|Defines the Scale for the Orientation in  Y|"));
			sOrientationYscale.setCategory(category);
			
//			String sOrientationYscaleName=T("|Scale|");	
//			PropDouble dOrientationYscale(nDoubleIndex++, U(0), sOrientationYscaleName);
//			dOrientationYscale.setDescription(T("|Defines the Scale for the Orientation in  Y|"));
//			dOrientationYscale.setCategory(category);
			// 25 scalemin 
			String sOrientationYscaleMinName=T("|Scale Min.|");	
			PropString sOrientationYscaleMin(nStringIndex++, "0", sOrientationYscaleMinName);	
			sOrientationYscaleMin.setDescription(T("|Defines the min. Scale for the Orientation in Y|"));
			sOrientationYscaleMin.setCategory(category);
			
//			String sOrientationYscaleMinName=T("|Scale Min.|");	
//			PropDouble dOrientationYscaleMin(nDoubleIndex++, U(0), sOrientationYscaleMinName);
//			dOrientationYscaleMin.setDescription(T("|Defines the min. Scale for the Orientation in Y|"));
//			dOrientationYscaleMin.setCategory(category);
			// 26 static flag 13
			String sOrientationYstatics[0];
			sOrientationYstatics.append(sHatchModes);
			if(_Map.getInt("StaticY"))
			{
				sOrientationYstatics.setLength(0);
				sOrientationYstatics.append(sVaries);
				sOrientationYstatics.append(sHatchModes);
			}
			String sOrientationYstaticName=T("|Scaling mode|");
			PropString sOrientationYstatic(nStringIndex++, sOrientationYstatics, sOrientationYstaticName);
			sOrientationYstatic.setDescription(T("|Defines the hatch scaling mode for the Orientation in Y|")+" "+
		T("|by Hatch Pattern|")+" "+T("|means that the hatch scaling factor is not adapted to the size of the hatching area|")+" "+
		T("|Dynamic|")+" "+T("|means that the hatch scaling factor is adapted to the size of the hatched area|")+" "+
		T("|The larges hatch area the hatch factor is applied unchanged.|")+" "+T("|For all other smaller areas the hatch scaling factor is scaled down proportionally to the minimal area length.|"));
			sOrientationYstatic.setCategory(category);
			// 14
//			String sInsulationYName=T("|Insulation|");	
//			PropString sInsulationY(nStringIndex++, sNoYes, sInsulationYName,0);	
//			sInsulationY.setDescription(T("|Defines the Insulation|"));
//			sInsulationY.setCategory(category);
//			
//			String sScaleLongitudinalYName=T("|Scale Longitudinal|");	
//			PropDouble dScaleLongitudinalY(nDoubleIndex++, U(0), sScaleLongitudinalYName);	
//			dScaleLongitudinalY.setDescription(T("|Defines the Longitudinal Scale|"));
//			dScaleLongitudinalY.setCategory(category);
//			
//			String sScaleTransversalYName=T("|Scale Transversal|");
//			PropDouble dScaleTransversalY(nDoubleIndex++, U(0), sScaleTransversalYName);
//			dScaleTransversalY.setDescription(T("|Defines the Transversal Scale|"));
//			dScaleTransversalY.setCategory(category);
			
		// orientation Z
			category=T("|Orientation Z|");
			// 27
			String sOrientationZName=T("|Orientation|");	
			PropString sOrientationZ(nStringIndex++, "", sOrientationZName);	
			sOrientationZ.setDescription(T("|Defines the Orientation|"));
			sOrientationZ.setCategory(category);
			sOrientationZ.setReadOnly(true);
			// 28
			String sOrientationZpatternName=T("|Pattern|");
			PropString sOrientationZpattern(nStringIndex++, sPatterns, sOrientationZpatternName);
			sOrientationZpattern.setDescription(T("|Defines the pattern for the Orientation in Z|"));
			sOrientationZpattern.setCategory(category);
			// 29 color
			String sOrientationZcolorName=T("|Color|");	
			PropString sOrientationZcolor(nStringIndex++, "-2", sOrientationZcolorName);	
			sOrientationZcolor.setDescription(T("|Defines the color for the Orientation in Z. -2 by entity; -1 by layer|"));
			sOrientationZcolor.setCategory(category);
			
//			String sOrientationZcolorName=T("|Color|");
//			int nOrientationZcolors[]={1,2,3};
//			// 
//			PropInt nOrientationZcolor(nIntIndex++, -2, sOrientationZcolorName);
//			nOrientationZcolor.setDescription(T("|Defines the color for the Orientation in Z. -2 by entity; -1 by layer|"));
//			nOrientationZcolor.setCategory(category);
			// 30 transparency
			String sOrientationZtransparencyName=T("|Transparency|");	
			PropString sOrientationZtransparency(nStringIndex++, "0", sOrientationZtransparencyName);	
			sOrientationZtransparency.setDescription(T("|Defines the transparency for the Orientation in Z|"));
			sOrientationZtransparency.setCategory(category);
			
//			String sOrientationZtransparencyName=T("|Transparency|");
//			int nOrientationZtransparencys[]={1,2,3};
//			// 
//			PropInt nOrientationZtransparency(nIntIndex++, 0, sOrientationZtransparencyName);
//			nOrientationZtransparency.setDescription(T("|Defines the transparency for the Orientation in Z|"));
//			nOrientationZtransparency.setCategory(category);
			// 31 angle
			String sOrientationZangleName=T("|Angle|");	
			PropString sOrientationZangle(nStringIndex++, "0", sOrientationZangleName);	
			sOrientationZangle.setDescription(T("|Defines the Angle for the Orientation in Z|"));
			sOrientationZangle.setCategory(category);
			
//			String sOrientationZangleName=T("|Angle|");	
//			PropDouble dOrientationZangle(nDoubleIndex++, U(0), sOrientationZangleName);
//			dOrientationZangle.setDescription(T("|Defines the Angle for the Orientation in Z|"));
//			dOrientationZangle.setCategory(category);
			// 32 scale
			String sOrientationZscaleName=T("|Scale|");	
			PropString sOrientationZscale(nStringIndex++, "0", sOrientationZscaleName);	
			sOrientationZscale.setDescription(T("|Defines the Scale for the Orientation in  Z|"));
			sOrientationZscale.setCategory(category);
			
//			String sOrientationZscaleName=T("|Scale|");	
//			PropDouble dOrientationZscale(nDoubleIndex++, U(0), sOrientationZscaleName);
//			dOrientationZscale.setDescription(T("|Defines the Scale for the Orientation in  Z|"));
//			dOrientationZscale.setCategory(category);
			// 33 scalemin
			String sOrientationZscaleMinName=T("|Scale Min.|");	
			PropString sOrientationZscaleMin(nStringIndex++, "0", sOrientationZscaleMinName);	
			sOrientationZscaleMin.setDescription(T("|Defines the min. Scale for the Orientation in Z|"));
			sOrientationZscaleMin.setCategory(category);
			
//			String sOrientationZscaleMinName=T("|Scale Min.|");	
//			PropDouble dOrientationZscaleMin(nDoubleIndex++, U(0), sOrientationZscaleMinName);
//			dOrientationZscaleMin.setDescription(T("|Defines the min. Scale for the Orientation in Z|"));
//			dOrientationZscaleMin.setCategory(category);
			// 34 static flag
			String sOrientationZstatics[0];
			sOrientationZstatics.append(sHatchModes);
			if(_Map.getInt("StaticZ"))
			{
				sOrientationZstatics.setLength(0);
				sOrientationZstatics.append(sVaries);
				sOrientationZstatics.append(sHatchModes);
			}
			String sOrientationZstaticName=T("|Scaling mode|");
			PropString sOrientationZstatic(nStringIndex++, sOrientationZstatics, sOrientationZstaticName);
			sOrientationZstatic.setDescription(T("|Defines the hatch scaling mode for the Orientation in Z|")+" "+
		T("|by Hatch Pattern|")+" "+T("|means that the hatch scaling factor is not adapted to the size of the hatching area|")+" "+
		T("|Dynamic|")+" "+T("|means that the hatch scaling factor is adapted to the size of the hatched area|")+" "+
		T("|The larges hatch area the hatch factor is applied unchanged.|")+" "+T("|For all other smaller areas the hatch scaling factor is scaled down proportionally to the minimal area length.|"));
			sOrientationZstatic.setCategory(category);
			// 
//			String sInsulationZName=T("|Insulation|");	
//			PropString sInsulationZ(nStringIndex++, sNoYes, sInsulationZName,0);	
//			sInsulationZ.setDescription(T("|Defines the Insulation|"));
//			sInsulationZ.setCategory(category);
//			
//			String sScaleLongitudinalZName=T("|Scale Longitudinal|");	
//			PropDouble dScaleLongitudinalZ(nDoubleIndex++, U(0), sScaleLongitudinalZName);	
//			dScaleLongitudinalZ.setDescription(T("|Defines the Longitudinal Scale|"));
//			dScaleLongitudinalZ.setCategory(category);
//			
//			String sScaleTransversalZName=T("|Scale Transversal|");
//			PropDouble dScaleTransversalZ(nDoubleIndex++, U(0), sScaleTransversalZName);
//			dScaleTransversalZ.setDescription(T("|Defines the Transversal Scale|"));
//			dScaleTransversalZ.setCategory(category);
		}
		return;
	}
	
	if(nDialogMode==3)
	{ 
		// delete mode
		setOPMKey("HatchDelete");
		category=T("|Hatch to be deleted|");
		String sHatchNotUsedName=T("|Hatch|");
		Map mapHatchNotUseds = _Map.getMap("HatchNotUsed");
		int nNrHatchNotUsed = _Map.getInt("NrHatchNotUsed");
		String sHatchNotUseds[0];
		for (int iH=0;iH<nNrHatchNotUsed;iH++) 
		{ 
			String sKeyI = "Hatch" + iH;
			sHatchNotUseds.append(mapHatchNotUseds.getString(sKeyI));
		}//next iH
		
		PropString sHatchNotUsed(nStringIndex++, sHatchNotUseds, sHatchNotUsedName);	
		sHatchNotUsed.setDescription(T("|Defines the Hatch to be deleted. List will show all unused hatches|"));
		sHatchNotUsed.setCategory(category);
		return;
	}
	
	if (nDialogMode==4)
	{ 
		setOPMKey("GlobalSettings");	
		
		String sGroupAssignmentName=T("|Group Assignment|");	
		PropString sGroupAssignment(nStringIndex++, sGroupings, sGroupAssignmentName);	
		sGroupAssignment.setDescription(T("|Defines to layer to assign the instance|, ") + tDefaultEntry + T(" = |byEntity|"));
		sGroupAssignment.setCategory(category);
		return;
	}	
//End DialogMode//endregion 	
	
//region properties
	category = T("|Section|");
	// section level and section depth will define two levels of sections
	// The body within the two sections will be hatched 
	String sSectionLevelName=T("|Level|");	
	PropDouble dSectionLevel(nDoubleIndex++, U(0), sSectionLevelName);	
	dSectionLevel.setDescription(T("|Defines the section level|"));
	dSectionLevel.setCategory(category);
	// end of the clipping body by default is 0 meaning veriy large i.e. take everything
	String sSectionDepthName=T("|Depth|");	
	PropDouble dSectionDepth(nDoubleIndex++, U(0), sSectionDepthName);	
	dSectionDepth.setDescription(T("|Defines the section depth|"));
	dSectionDepth.setCategory(category);
	
	category = T("|Hatch global factors|");
	// global scaling factor by default is 1
	String sGlobalScalingName = T("|Scaling|");
	PropDouble dGlobalScaling(nDoubleIndex++, U(1), sGlobalScalingName);	
	dGlobalScaling.setDescription(T("|Defines the global scaling factor of the hatching|"));
	dGlobalScaling.setCategory(category);
	// HSB-13341
	dGlobalScaling.setFormat(_kNoUnit);
	
	// transparency
	String sGlobalTransparencyName=T("|Transparency|");
	PropDouble dGlobalTransparency(nDoubleIndex++, U(1), sGlobalTransparencyName);
	String sGlobalTransparencyDescription = T("|multiplication factor for transparency|");
	dGlobalTransparency.setDescription(sGlobalTransparencyDescription);
	dGlobalTransparency.setCategory(category);
	// HSB-13341
	dGlobalTransparency.setFormat(_kNoUnit);
	
	// Hatch mapping of XML hatches
	String sHatchMappingName=T("|Hatch Mapping|");
	String sHatchMappings[]={ T("|by Material|"),T("|by Painter|")};
	PropString sHatchMapping(2, sHatchMappings, sHatchMappingName);
	sHatchMapping.setDescription(T("|Defines how the the Hatch in the XML is mapped to an entity|")
	+" "+T("|by Material means that the hatch in XML is found from the material of the entits|")
	+" "+T("|by Painter means that the hatch in XML is found by the name of selected painter|")
	+" "+T("|by Painter means that all entities contained in the painter will have the same hatch|"));
	sHatchMapping.setCategory(category);
//End properties//endregion 
	
//region Jigging
if (_bOnJig && _kExecuteKey == kJigModifyAdd)
{
//	Vector3d vecView = getViewDirection();
	PlaneProfile ppAll = _Map.getPlaneProfile("ppAll");
	
//	dpJig.draw(ppAll, _kDrawFilled);
	Point3d ptJig = _Map.getPoint3d("_PtJig");
	Display dpBackground(255);
	dpBackground.trueColor(grey);
//	dpBackground.transparency(70);
	Display dpTile(252);
	dpTile.trueColor(grey);
//	dpTile.trueColor(grey,70);
	Display dpHighlight(3);
	dpHighlight.trueColor(mellowyellow);
	Display dpBody(1);
	dpBody.trueColor(lightblue);
	Display dpHighlights[0];
	for (int ic=0;ic<nColors.length();ic++) 
	{ 
		Display dpH(nColors[ic]);
		dpH.trueColor(nColors[ic]);
		dpHighlights.append(dpH);
	}//next ic
	
	Display dpTxt(5);
	dpTxt.trueColor(rgb(0,0,0));
	Map mapPropsCoord=_Map.getMap("mapPropsCoord");
	Vector3d vecXgraph = mapPropsCoord.getVector3d("vecXgraph");
	Vector3d vecYgraph = mapPropsCoord.getVector3d("vecYgraph");
	Vector3d vecZgraph = mapPropsCoord.getVector3d("vecZgraph");
	Point3d ptStartGraph=mapPropsCoord.getPoint3d("ptStartGraph");
	Point3d ptStartGraphView = ptStartGraph;
	
	double dXtable=_Map.getDouble("dXtable")*dViewScale;
	double dYtable=_Map.getDouble("dYtable")*dViewScale;
	// set the point outside of genbeam
	{ 
		Body bdAll = _Map.getBody("bdAll");
		PlaneProfile ppGb = bdAll.shadowProfile(Plane(ptStartGraph, vecZview));
		ppGb.shrink(-dTableSpace);
		// get extents of profile
		LineSeg seg = ppGb.extentInDir(vecXview);
		ptStartGraphView = seg.ptEnd();
		
		if(abs(vecXview.dotProduct(seg.ptStart()-ptViewCenter))<
			abs(vecXview.dotProduct(seg.ptEnd()-ptViewCenter)))
		{ 
			ptStartGraphView=seg.ptStart()-vecXview*dXtable;
		}
		ptStartGraphView+=vecYview*vecYview.dotProduct(ptViewCenter-ptStartGraphView);
		ptStartGraphView+=.5*vecYview*dYtable;
	}
//	dpTxt.textHeight(dHview*.02);
	dpTxt.dimStyle(_DimStyles[0]);
	dpTxt.textHeight(dViewScale*30);
	
//	dpp.textHeight(dHview*.01);
// transform to the jig view
	CoordSys csGraphTransform;
	csGraphTransform.setToAlignCoordSys(ptStartGraph,vecXgraph,vecYgraph,vecZgraph,
				ptStartGraphView, vecXview*dViewScale, vecYview*dViewScale, vecZview*dViewScale);
	
// draw image
	String image =  TslScript(scriptName()).subMapX("Resource[]\\Image[]\\hsbgrey").getString("Encoding");
//	String image =  TslScript(scriptName()).subMapX("Resource[]\\Image[]\\hsbred").getString("Encoding");
	
	
	Point3d ptTable=_Map.getPoint3d("ptTable");
	PlaneProfile ppTable=_Map.getPlaneProfile("ppTable");
	
	ptTable.transformBy(csGraphTransform);
//	ppTable.transformBy(csGraphTransform);
	
	dpBackground.drawImage(image,ptTable,vecXview,vecYview, 
		0, 0, 1.1*dXtable, 1.1*dYtable);
	int nMatSelected=-1;
	String sMatSelected;
	Map mapPropsGraph = _Map.getMap("mapProps");
	for (int i=0; i<mapPropsGraph.length(); i++)
	{
		Map mapI = mapPropsGraph.getMap(i);
		PlaneProfile ppProp = mapI.getPlaneProfile("pp");
		ppProp.transformBy(csGraphTransform);
//		ppProp.transformBy(vecZview*(U(100)+vecZview.dotProduct(ptTable-ppProp.coordSys().ptOrg())));
//		dpTile.draw(ppProp, _kDrawFilled);
		if(ppProp.pointInProfile(ptJig)==_kPointInProfile)
		{
//			dpTile.draw(ppProp, _kDrawFilled);
			PlaneProfile ppFrame=mapI.getPlaneProfile("ppFrame");
			ppFrame.transformBy(csGraphTransform);
			dpHighlight.draw(ppFrame,_kDrawFilled);
			dpHighlight.draw(ppProp);
			dpHighlight.draw(ppFrame);
			
			nMatSelected=i;
			sMatSelected=mapI.getString("txt");
			break;
		}
		
		String sTxtProp = mapI.getString("txt");
		Point3d ptTxtProp = mapI.getPoint3d("ptTxtProp");
		ptTxtProp.transformBy(csGraphTransform);
		dpTxt.draw(sTxtProp, ptTxtProp, vecXview, vecYview, 0, 0);
	}
	
	CoordSys ms2ps(_Map.getPoint3d("ms2psPtOrg"),
		_Map.getVector3d("ms2psVecX"),_Map.getVector3d("ms2psVecY"),
		_Map.getVector3d("ms2psVecZ"));
	
	Map mapHatchesAllUsed=_Map.getMap("mapHatchesAllUsed");
	Map mapEntitiesUsedPp=_Map.getMap("mapEntitiesUsedPp");
	if(nMatSelected>-1)
	{ 
	// material is selected, get corresponding entities
		
		// hatch entities
		Map mapSelected=mapHatchesAllUsed.getMap(sMatSelected);
		
	// get the corresponding entities with this material
		Map mapIndices=mapSelected.getMap("mapIndices");
		for (int ient=0;ient<mapIndices.length();ient++) 
		{ 
			Map mapI= mapIndices.getMap(ient); 
			int nIndex = mapI.getInt("index");
			Map mapEnt = mapEntitiesUsedPp.getMap(nIndex);
			
			Entity entI=mapEnt.getEntity("ent");
			
//			Body bdI = entI.realBody();
//			if(mapEnt.hasPoint3d("ptOrgTransform"))
//			{ 
//				CoordSys csCollectionTransform(mapEnt.getPoint3d("ptOrgTransform"),
//				mapEnt.getVector3d("vecXTransform"),mapEnt.getVector3d("vecYTransform"),mapEnt.getVector3d("vecZTransform"));
//				bdI.transformBy(csCollectionTransform);
//			}
//			bdI.transformBy(ms2ps);
			// HSB-22263 get from map
			Body bdI=mapEnt.getBody("bdTransformed");
			
//			bdI.transformBy(Vector3d(U(10),U(10),U(10)));
			dpTile.draw(bdI);
			PlaneProfile ppBdI=bdI.shadowProfile(Plane(ptStartGraphView,vecZview));
			dpTile.draw(ppBdI,_kDrawFilled);
			PlaneProfile ppBdIframe = ppBdI;
			ppBdIframe.shrink(-dMarginEnt);
			ppBdIframe.subtractProfile(ppBdI);
			dpHighlight.draw(ppBdIframe,_kDrawFilled);
			dpHighlight.draw(ppBdI);
			dpHighlight.draw(ppBdIframe);
//			bdI.transformBy(ms2ps);
		}//next ient
	}
	else
	{ 
	// see if entity is selected
		int nEntsSelected[0];
		Map mapEntitiesUsedPp=_Map.getMap("mapEntitiesUsedPp");
		String sHatchesThisEnt[0];
		int nEntCount;
		for (int i=0;i<mapEntitiesUsedPp.length();i++) 
		{ 
			Map mapEnt=mapEntitiesUsedPp.getMap(i);
			Entity entI=mapEnt.getEntity("ent");
			
//			Body bdI = entI.realBody();
//			if(mapEnt.hasPoint3d("ptOrgTransform"))
//			{ 
//				CoordSys csCollectionTransform(mapEnt.getPoint3d("ptOrgTransform"),
//				mapEnt.getVector3d("vecXTransform"),mapEnt.getVector3d("vecYTransform"),mapEnt.getVector3d("vecZTransform"));
//				bdI.transformBy(csCollectionTransform);
//			}
//			bdI.transformBy(ms2ps);
			
			// HSB-22263 get from map
			Body bdI=mapEnt.getBody("bdTransformed");
			
			PlaneProfile ppI=bdI.shadowProfile(Plane(ptStartGraphView,vecZview));
			if(ppI.pointInProfile(ptJig)==_kPointInProfile)
			{ 
				nEntsSelected.append(i);
				dpTile.draw(bdI);
				PlaneProfile ppBdI=bdI.shadowProfile(Plane(ptStartGraphView,vecZview));
				dpTile.draw(ppBdI,_kDrawFilled);
				PlaneProfile ppBdIframe = ppBdI;
				ppBdIframe.shrink(-dMarginEnt);
				ppBdIframe.subtractProfile(ppBdI);
				dpHighlights[nEntCount].draw(ppBdIframe,_kDrawFilled);
				dpHighlights[nEntCount].draw(ppBdI);
				dpHighlights[nEntCount].draw(ppBdIframe);
				nEntCount++;
			}
		}//next i
		if(nEntsSelected.length()>0)
		{
			String sHatchKeys[]={"hatch0","hatch1","hatch2","hatch3","hatch4"};
			String sOrientationKeys[]={"orientation0","orientation1","orientation2","orientation3","orientation4"};
			for (int ient=0;ient<nEntsSelected.length();ient++)
			{ 
				int nEntSelected=nEntsSelected[ient];
			// Entity is selected
				String sHatches[0];
				Map mapEnt=mapEntitiesUsedPp.getMap(nEntSelected);
				Map mapHatches=_Map.getMap("mapHatches");
				for (int ii=0;ii<sHatchKeys.length();ii++) 
				{
					if(mapEnt.hasInt(sHatchKeys[ii]))//1,2,3,4
					{
						int nIndexH=mapEnt.getInt(sHatchKeys[ii]);
						
						Map mapHatchI=mapHatches.getMap(nIndexH);
						String sOrientationI=mapEnt.getString(sOrientationKeys[ii]);
						// 
						if(!mapHatchI.getInt("Anisotropic"))sOrientationI="X";
						String sHatchName=nIndexH+"-"+mapHatchI.getString("Name")+"-"+sOrientationI;
						if(mapHatchesAllUsed.hasMap(sHatchName))
						{ 
							sHatches.append(sHatchName);
						}
					}
				}
				if(sHatches.length()>0)
				{ 
					for (int i=0;i<sHatches.length();i++) 
					{ 
						int nIndex=mapHatchesAllUsed.indexAt(sHatches[i]);
						
						Map mapI = mapPropsGraph.getMap(nIndex);
						PlaneProfile ppProp = mapI.getPlaneProfile("pp");
						ppProp.transformBy(csGraphTransform);
//						dpTile.draw(ppProp, _kDrawFilled);
						PlaneProfile ppFrame=mapI.getPlaneProfile("ppFrame");
						ppFrame.transformBy(csGraphTransform);
						dpHighlights[ient].draw(ppFrame,_kDrawFilled);
						dpHighlights[ient].draw(ppProp);
						dpHighlights[ient].draw(ppFrame);
						sMatSelected=mapI.getString("txt");
						
						String sTxtProp = mapI.getString("txt");
						Point3d ptTxtProp = mapI.getPoint3d("ptTxtProp");
						ptTxtProp.transformBy(csGraphTransform);
						dpTxt.draw(sTxtProp, ptTxtProp, vecXview, vecYview, 0, 0);
					}//next i
				}
			}//next ient
		}
	}
	
// show all bodies
	for (int i=0;i<mapEntitiesUsedPp.length();i++) 
	{ 
		Map mapEnt=mapEntitiesUsedPp.getMap(i);
		Entity entI=mapEnt.getEntity("ent");
		
//		Body bdI = entI.realBody();
//		if(mapEnt.hasPoint3d("ptOrgTransform"))
//		{ 
//			CoordSys csCollectionTransform(mapEnt.getPoint3d("ptOrgTransform"),
//			mapEnt.getVector3d("vecXTransform"),mapEnt.getVector3d("vecYTransform"),mapEnt.getVector3d("vecZTransform"));
//			bdI.transformBy(csCollectionTransform);
//		}
//		bdI.transformBy(ms2ps);
		
		// HSB-22263 get from map
		Body bdI=mapEnt.getBody("bdTransformed");
		dpBody.draw(bdI);
	}
	return;	
}

if (_bOnJig && _kExecuteKey==kJigViewport) 
{
    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point		
	
    PlaneProfile pps[0];
    Map mapsVPsSections=_Map.getMap("mapsVPsSections");
    for (int i=0;i<_Map.length();i++) 
    	if (_Map.hasPlaneProfile(i))
    		pps.append(_Map.getPlaneProfile(i));
    for (int i=0;i<mapsVPsSections.length();i++) 
    {
    	Map map = mapsVPsSections.getMap(i);
    	if (map.hasPlaneProfile("pp"))
    		pps.append(map.getPlaneProfile("pp"));
     }
	if (pps.length()>0)
		ptJig.setZ(pps[0].coordSys().ptOrg().Z());
	
    Display dp(-1);
    dp.trueColor(lightblue, 50);
	
    double dMin = U(10e6);
    int n;
    for (int i=0;i<pps.length();i++) 
    { 
    	double d = (pps[i].closestPointTo(ptJig)-ptJig).length();
    	if (d<dMin)
    	{ 
    		dMin = d;
    		n = i;
    	}	    	 
    }//next i
    for (int i=0;i<pps.length();i++)
    { 
    	dp.trueColor(n==i?darkyellow:lightblue, n==i?0:50);
    	dp.draw(pps[i], _kDrawFilled);
    }
    return;
}
//End Jigging//endregion 

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";
	
	String sFileName ="hsbViewHatching";
	Map mapSetting;

// compose settings file location
	String sFolders[]=getFoldersInFolder(sPath); 
	int bPathFound = _bOnInsert ? sFolders.find(sFolder) >- 1 ? true : makeFolder(sPath + "\\" + sFolder) : false;
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
	if(_bOnDbCreated)
	{ 
		int nVersion = mapSetting.getInt("GeneralMapObject\\Version");
		String sFile = findFile(sPathGeneral + sFileName + ".xml");
	// read the xml from installation directory
		Map mapSettingInstall; mapSettingInstall.readFromXmlFile(sFile);
		int nVersionInstall = mapSettingInstall.getMap("GeneralMapObject").getInt("Version");
		
		if(sFile.length()>0 && nVersion!=nVersionInstall)
			reportNotice(TN("|A different Version of the settings has been found for|")+" " + scriptName()+
			TN("|Current Version| ")+nVersion + "	" + _kPathDwg + TN("|Other Version| ") +nVersionInstall + "	" + sFile);
	// HSB-15941 do the migration
		if(sFile.length()>0 && nVersion!=nVersionInstall)
		{ 
		// migrate the settings
			String sFile=findFile(sPathGeneral+sFileName+".xml");
			Map mapHatches = mapSetting.getMap("Hatch[]");
			Map mapSettingInstall; mapSettingInstall.readFromXmlFile(sFile);
			// new hatches after migration
			Map mapHatchesNew;
			mapHatchesNew.setMapKey("Hatch[]");
			// get the default map, make sure to import the missing properties
			Map mapHatchInstall, mapContourInstall,mapOrientationsInstall;// muster hatch
			{ 
				Map mapHatchesInstall = mapSettingInstall.getMap("Hatch[]");
				if(mapHatchesInstall.length()==0)
				{ 
					reportMessage("\n"+scriptName()+" "+T("|Unexpected: No Hatch deginition in installation directory|"));
					reportMessage("\n"+scriptName()+" "+T("|Please report hsbcad|"));
				}
				mapHatchInstall = mapHatchesInstall.getMap(0);
				mapContourInstall=mapHatchInstall.getMap("Contour");
				mapOrientationsInstall=mapHatchInstall.getMap("Orientation[]");
			}
			Map mapGeneral = mapSettingInstall.getMap("GeneralMapObject");
			// hatch 
			String sHatchDoubleNames[]={ };
			String sHatchStringNames[]={"Name"};
			String sHatchIntNames[]={"isActive","Anisotropic","SolidHatch",
				"SolidTransparency","SolidColor"};
			// contour
			String sContourDoubleNames[]={"Thickness"};
			String sContourStringNames[]={ };
			String sContourIntNames[]={"Contour","Color","SupressBeamCross"};
			// orientation
//			String sOrientationDoubleNames[]={"Angle","Scale","ScaleMin","ScaleLongitudinal","ScaleTransversal"};
			String sOrientationDoubleNames[]={"Angle","Scale","ScaleMin"};
			String sOrientationStringNames[]={"Name","Pattern"};
			String sOrientationIntNames[]={"Color","Transparency","Static"};
			for (int iH=0;iH<mapHatches.length();iH++)
			{ 
				Map mapHi=mapHatches.getMap(iH);
				Map mapHiNew,mapContouriNew,mapOrientationsiNew;
				
				mapHiNew.setMapKey("Hatch");
				for (int ii=0;ii<sHatchDoubleNames.length();ii++) 
				{ 
					String sii = sHatchDoubleNames[ii];
					if(mapHi.hasDouble(sii))
					{ 
						mapHiNew.setDouble(sii,mapHi.getDouble(sii));
					}
					else
					{ 
						mapHiNew.setDouble(sii,mapHatchInstall.getDouble(sii));
					}
				}//next ii
				for (int ii=0;ii<sHatchStringNames.length();ii++) 
				{ 
					String sii = sHatchStringNames[ii];
					if(mapHi.hasString(sii))
					{ 
						mapHiNew.setString(sii,mapHi.getString(sii));
					}
					else
					{ 
						mapHiNew.setString(sii,mapHatchInstall.getString(sii));
					}
				}//next ii
				for (int ii=0;ii<sHatchIntNames.length();ii++) 
				{ 
					String sii = sHatchIntNames[ii];
					if(mapHi.hasInt(sii))
					{ 
						mapHiNew.setInt(sii,mapHi.getInt(sii));
					}
					else
					{ 
						mapHiNew.setInt(sii,mapHatchInstall.getInt(sii));
					}
				}//next ii
				
				Map mapMaterialsI=mapHi.getMap("Material[]");
				mapHiNew.appendMap("Material[]", mapMaterialsI);
				Map mapContourI=mapHi.getMap("Contour");
				
				mapContouriNew.setMapKey("Contour");
				for (int ii=0;ii<sContourDoubleNames.length();ii++) 
				{ 
					String sii = sContourDoubleNames[ii];
					if(mapContourI.hasDouble(sii))
					{ 
						mapContouriNew.setDouble(sii,mapContourI.getDouble(sii));
					}
					else
					{ 
						mapContouriNew.setDouble(sii,mapContourInstall.getDouble(sii));
					}
				}//next ii
				for (int ii=0;ii<sContourStringNames.length();ii++) 
				{ 
					String sii = sContourStringNames[ii];
					if(mapContourI.hasString(sii))
					{ 
						mapContouriNew.setString(sii,mapContourI.getString(sii));
					}
					else
					{ 
						mapContouriNew.setString(sii,mapContourInstall.getString(sii));
					}
				}//next ii
				for (int ii=0;ii<sContourIntNames.length();ii++) 
				{ 
					String sii = sContourIntNames[ii];
					if(mapContourI.hasInt(sii))
					{ 
						mapContouriNew.setInt(sii,mapContourI.getInt(sii));
					}
					else
					{ 
						mapContouriNew.setInt(sii,mapContourInstall.getInt(sii));
					}
				}//next ii
				
				mapHiNew.appendMap("Contour", mapContouriNew);
				
				Map mapOrientationsI=mapHi.getMap("Orientation[]");
				mapOrientationsiNew.setMapKey("Orientation[]");
				for (int io=0;io<mapOrientationsInstall.length();io++) 
				{ 
					Map mapOrientationiNew;
					mapOrientationiNew.setMapKey("Orientation");
					Map mapOrientationInstall = mapOrientationsInstall.getMap(io);
					Map mapOrientationI = mapOrientationsI.getMap(io);
					for (int ii=0;ii<sOrientationDoubleNames.length();ii++) 
					{ 
						String sii = sOrientationDoubleNames[ii];
						if(mapOrientationI.hasDouble(sii))
						{ 
							mapOrientationiNew.setDouble(sii,mapOrientationI.getDouble(sii));
						}
						else
						{ 
							mapOrientationiNew.setDouble(sii,mapOrientationInstall.getDouble(sii));
						}
					}//next ii
					for (int ii=0;ii<sOrientationStringNames.length();ii++) 
					{ 
						String sii = sOrientationStringNames[ii];
						if(mapOrientationI.hasString(sii))
						{ 
							mapOrientationiNew.setString(sii,mapOrientationI.getString(sii));
						}
						else
						{ 
							mapOrientationiNew.setString(sii,mapOrientationInstall.getString(sii));
						}
					}//next ii
					for (int ii=0;ii<sOrientationIntNames.length();ii++) 
					{ 
						String sii = sOrientationIntNames[ii];
						if(mapOrientationI.hasInt(sii))
						{ 
							mapOrientationiNew.setInt(sii,mapOrientationI.getInt(sii));
						}
						else
						{ 
							mapOrientationiNew.setInt(sii,mapOrientationInstall.getInt(sii));
						}
					}//next ii
					
					mapOrientationsiNew.appendMap("Orientation",mapOrientationiNew);
				}//next io
				mapHiNew.appendMap("Orientation[]", mapOrientationsiNew);
				mapHatchesNew.appendMap("Hatch", mapHiNew);
			}//next iH
			Map mapSettingNew;
			mapSettingNew.setMapKey("root");
			mapSettingNew.appendMap("Hatch[]", mapHatchesNew);
			mapSettingNew.appendMap("GeneralMapObject", mapGeneral);
			if(mo.bIsValid())
				mo.setMap(mapSettingNew);
			else 
				mo.dbCreate(mapSettingNew);
			
			mapSetting=mo.map();
			reportNotice(TN("|Migration of new parameters done.|")+" "+
			TN("|Settings were updated successfuly from|")+" "+sPathGeneral);
			
			reportNotice(TN("|Please use the command|")+" "+T("|Export Settings|")+
			" "+T("|to export settings in the company folder|"));
		}
//		if(sFile.length()>0 && nVersion!=nVersionInstall)
//			reportNotice("\n"+scriptName()+" "+T("|Newer version of xml settings is available from the installation directory|"));
	}
//End Settings//endregion

		
//region Global Settings
	String sTriggerGlobalSetting = T("|Global Settings|");
	String kGlobalSettings = "GlobalSettings", kGroupAssignment= "GroupAssignment";
	int nGroupAssignment;
	Map mapGlobalSettings = mapSetting.getMap(kGlobalSettings);
	if (mapGlobalSettings.hasInt(kGroupAssignment))
		nGroupAssignment = mapGlobalSettings.getInt(kGroupAssignment);	
//End Global Settings//endregion

//region Painter rules
// rules
	category = T("|Filter|");
	String sRules[0];
	String sPainters[] = PainterDefinition().getAllEntryNames().sorted();
	String sPainterCollection = "hsbViewHatching";
	
	for (int i=sPainters.length()-1; i>=0 ; i--) 
		if (sPainters[i].length()<1)
			sPainters.removeAt(i);
// HSB-20184: allow all painter rules
	int bPainterCollectionFound;
//	for (int i=0;i<sPainters.length();i++) 
//	{ 
//		if (sPainters[0].find(sPainterCollection,0,false)==0)
//		{ 
//			bPainterCollectionFound = true;
//			break;
//		}
//	}

	if(bPainterCollectionFound)
	for (int i=sPainters.length()-1; i>=0 ; i--) 
	{ 
		// keep only those of collection if at least one found
		String sPainter = sPainters[i];
		if (sPainter.find(sPainterCollection,0,false)<0)
		{ 
			sPainters.removeAt(i);
			continue;
		}
	}//next i
	
	String sPainterStreamName=T("|PainterStream|");	
	PropString sPainterStream(1, "", sPainterStreamName);	
	sPainterStream.setDescription(T("|Defines the PainterStream|"));
	sPainterStream.setCategory(category);
	sPainterStream.setReadOnly(bDebug?0:_kHidden);

	// on insert read catalogs to copy / create painters based on catalog entries
//	if (_bOnInsert || _bOnElementConstructed || _bOnDbCreated)
//	{
//		// HSB-15906: collect streams	
//		String streams[0];
//		String sScriptOpmName = bDebug ? "hsbViewHatching" : scriptName();
//		String entries[] = TslInst().getListOfCatalogNames(sScriptOpmName);
//		int nStreamIndices[] ={ 1};//index 1 of the stream property
//		for (int i = 0; i < entries.length(); i++)
//		{
//			String& entry = entries[i];
//			Map map = TslInst().mapWithPropValuesFromCatalog(sScriptOpmName, entry);
//			Map mapProp = map.getMap("PropString[]");
//			
//			for (int j = 0; j < mapProp.length(); j++)
//			{
//				Map m = mapProp.getMap(j);
//				int index = m.getInt("nIndex");
//				String stream = m.getString("strValue");
//				if (nStreamIndices.find(index) >- 1 && streams.findNoCase(stream ,- 1) < 0)
//				{
//					streams.append(stream);
//				}
//			}//next j
//		}//next i
//		
//		for (int i = 0; i < streams.length(); i++)
//		{
//			String& stream = streams[i];
//			String _painters[0];
//			_painters = sPainters;
//			if (stream.length() > 0)
//			{
//				// get painter definition from property string	
//				Map m;
//				m.setDxContent(stream , true);
//				String name = m.getString("Name");
//				Strin		g type = m.getString("Type").makeUpper();
//				String filter = m.getString("Filter");
//				String format = m.getString("Format");
//				// create definition if not present	
//				//				if (m.hasString("Name") && m.hasString("Type") && name.find(sPainterCollection,0,false)>-1 &&
//				//					_painters.findNoCase(name,-1)<0)
//				if (m.hasString("Name") && m.hasString("Type") && _painters.findNoCase(name,- 1) < 0)
//				{
//					PainterDefinition pd(name);
//					if (!pd.bIsValid() && 0)
//					{
//						reportMessage("\n"+scriptName()+" "+T("|create painter|"));
//						
//						pd.dbCreate();
//						pd.setType(type);
//						pd.setFilter(filter);
//						pd.setFormat(format);
//						
//						if (pd.bIsValid())
//						{
//							sPainters.append(name);
//						}
//					}
//				}
//			}
//		}
//	}
	
	sRules = sPainters;
	sRules.insertAt(0, T("|<Disabled>|"));
	
	String sRuleName=T("|Painter Rule|");	
	PropString sRule(nStringIndex++, sRules, sRuleName);	
	sRule.setDescription(T("|Defines the painter definition to filter entities.|"));
	sRule.setCategory(category);
	// HSB-24107:
	String sAllowEntitiesXrefName=T("|Allow entities in XRef|");	
	PropString sAllowEntitiesXref(3, sNoYes, sAllowEntitiesXrefName);	
	sAllowEntitiesXref.setDescription(T("|Defines the AllowEntitiesXref|"));
	sAllowEntitiesXref.setCategory(category);
	
	
	
//End Painter rules//endregion 
	int bInBlockSpace;

// bOnInsert//region
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
	// silent/dialog
		String sKey = _kExecuteKey;
		sKey.makeUpper();
		
		if (sKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			for(int i=0;i<sEntries.length();i++)
				sEntries[i] = sEntries[i].makeUpper();
			if (sEntries.find(sKey)>-1)
				setPropValuesFromCatalog(sKey);
			else
				setPropValuesFromCatalog(sLastInserted);
		}
		else
			showDialog();
		
	// save stream of painter
		int nPainter = sPainters.findNoCase(sRule,-1);
		{ 
			PainterDefinition painter;
			if (nPainter>-1)
			{
				painter = PainterDefinition(sPainters[nPainter]);
			}
			if (painter.bIsValid())
			{ 
				Map m;
				m.setString("Name", painter.name());
				m.setString("Type",painter.type());
				m.setString("Filter",painter.filter());
				m.setString("Format",painter.format());
				sPainterStream.set(m.getDxContent(true));
			}
			_ThisInst.setCatalogFromPropValues(sLastInserted);
		}
	// get current space
		int bInLayoutTab = Viewport().inLayoutTab();// layout not model
		int bInPaperSpace = Viewport().inPaperSpace();// layout not inside a viewport
		int hasSDV; 
	// find out if we are block space and have some shopdraw viewports
		Entity entsSDV[0];
		if (!bInLayoutTab)
		{
			// not in layout tab, collect shopdrawView entities
			entsSDV = Group().collectEntities(true, ShopDrawView(), _kMySpace);
			if (entsSDV.length()>0)
			{ 
				hasSDV = true;
				Entity ents[]=Group().collectEntities(true, MultiPage(), _kAllSpaces);
				if (ents.length()<1)
				{ 
					bInBlockSpace = true;
				}
			}
		}
		
	// distinguish selection mode bySpace
		if (entsSDV.length() > 0)
		{ 
			// we are inside the block definition of
			// shop draw with shopdraw views. Prompt for selecting shopdraw views shows up
			// prompt selection of a shop draw view
			_Entity.append(getShopDrawView());
			// prompt selection of an insertion point
			_Pt0 = getPoint(T("|Pick insertion point|"));
			return;
		}
		
	// switch to paperspace succeeded: paperspace with viewports
		if (_Entity.length() < 1)
		{ 
			// no shopdrawview was found -> we are in layout or model space
			if (bInLayoutTab && bInPaperSpace)
			{
				// in layout tab, select viewport
				_Viewport.append(getViewport(T("|Select a viewport|")));				
				// prompt selection of an insertion point
				Point3d pt=getPoint(T("|Pick insertion point|"));
				_Pt0=pt;
				_Map.setVector3d(kViewportOrg, pt-_PtW);
				return;
			}
			else
			{ 
				// Section2d or MultiPage
			// make the properties readonly beacause they are not relevant here
			// we are in model space not in layout space
			// not in layout tab, we are in model space
			// prompt for section2s
				Entity ents[0];
				PrEntity ssE(T("|Select Section2d or MultiPage|"), Section2d());
				ssE.addAllowedClass(MultiPage());
				if (ssE.go())
					ents.append(ssE.set());
				
				_Entity.append(ents);
				
				Map mapArgs;
				PlaneProfile ppVPsSections[0];
				int nIndexViews[0];
				Entity entsJig[0];
				Map mapsVPsSections;
				Plane pn(_PtW, _ZW);
				for (int i=0;i<_Entity.length();i++) 
				{ 
					Entity ent = _Entity[i];
					MultiPage _page = (MultiPage) ent;
					MultiPage page;
					CoordSys ms2ps, ps2ms;
					if (_page.bIsValid())
					{
						page = _page;
						MultiPageView mpvs[] = page.views();
						for (int j = 0; j < mpvs.length(); j++)
						{
							MultiPageView& mpv = mpvs[j];
							ms2ps = mpv.modelToView();
							ps2ms = ms2ps;
							ps2ms.invert();						
						// HSB-20184: allow all views including isometric
							// skip isometric views
//							if (!ps2ms.vecX().isParallelTo(_ZW) && 
//								!ps2ms.vecY().isParallelTo(_ZW) && !ps2ms.vecZ().isParallelTo(_ZW))
//							{ 
//								continue;
//							}
//							PlaneProfile pp(mpv.plShape().coordSys());
							PlaneProfile pp(pn);
							pp.joinRing(mpv.plShape(), _kAdd);
							ppVPsSections.append(pp);
							nIndexViews.append(j);
							Map map;
							map.setPlaneProfile("pp", pp);
							map.setEntity("ent", ent);
							map.setInt("nIndexView",j);
							mapsVPsSections.appendMap("map", map);
						}
					}
					Section2d _section=(Section2d)ent;
					Section2d section;
					if(_section.bIsValid())
					{ 
						section = _section;
						ClipVolume clipVolume=section.clipVolume();
						Body bdClip=clipVolume.clippingBody();
						ms2ps=section.modelToSection();
						ps2ms=ms2ps; ps2ms.invert();
						bdClip.transformBy(ms2ps);
						Plane pnPaper=Plane(section.coordSys().ptOrg(),_ZW);
						PlaneProfile pp=bdClip.shadowProfile(pn);
					// get extents of profile
						LineSeg seg = pp.extentInDir(_XW);
						double dX = abs(_XW.dotProduct(seg.ptStart()-seg.ptEnd()));
						double dY = abs(_YW.dotProduct(seg.ptStart()-seg.ptEnd()));
						if(dY>2*dX)
						{ 
							PlaneProfile ppNew(pp.coordSys());
							LineSeg lSegNew(section.coordSys().ptOrg(),
								section.coordSys().ptOrg()+dX*_XW+_YW*4*dX);
							ppNew.createRectangle(lSegNew,_XW,_YW);
							pp=ppNew;
						}
						
						ppVPsSections.append(pp);
						nIndexViews.append(-1);
						Map map;
						map.setPlaneProfile("pp", pp);
						map.setEntity("ent", ent);
						map.setInt("nIndexView",-1);
						mapsVPsSections.appendMap("map", map);
					}
				}//next i
				mapArgs.setMap("mapsVPsSections",mapsVPsSections);
				if(ppVPsSections.length()>0)
				{ 
				// create TSL
					TslInst tslNew;	Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
					GenBeam gbsTsl[] = { };	Entity entsTsl[1]; Point3d ptsTsl[] ={_Pt0};
					int nProps[]={};double dProps[]={};
					String sProps[]={sRule,sPainterStream,sHatchMapping,sAllowEntitiesXref};
					Map mapTsl;	
					
					dProps.setLength(0);
					dProps.append(dSectionLevel);
					dProps.append(dSectionDepth);
					dProps.append(dGlobalScaling);
					dProps.append(dGlobalTransparency);
					MultiPage pageSelected;
					if(ppVPsSections.length()>1)
					{ 
					
						Point3d pt;
						PrPoint ssP(T("|Select viewport or section|")); //second argument will set _PtBase in map
						int nGoJig = - 1;
						while (nGoJig != _kOk && nGoJig != _kNone)
						{
							nGoJig = ssP.goJig(kJigViewport, mapArgs);
							if (nGoJig == _kOk)
							{
								pt = ssP.value(); //retrieve the selected point
								pt.setZ(0);
								
								// get the inde of the closest viewport
								double dMin = U(10e6);
								int nSelected;
								for (int i = 0; i < ppVPsSections.length(); i++)
								{
									double d = (ppVPsSections[i].closestPointTo(pt) - pt).length();
									if (d < dMin)
									{
										dMin=d;
										nSelected=i;
		
	//										MultiPageView view = mpvs[i];
	//										ms2ps = view.modelToView();
	//										ps2ms = ms2ps;
	//										ps2ms.invert();
										
										
										// insert Tsl Instance
									}
								}//next i
								Map mapSelected=mapsVPsSections.getMap(nSelected);
								Entity entSelected=mapSelected.getEntity("ent");
								int nIndexViewSelected = nIndexViews[nSelected];
								
								if(nIndexViewSelected>-1)
								{ 
									pageSelected=(MultiPage)entSelected;
									MultiPageView mpvs[] = pageSelected.views();
									MultiPageView& mpv = mpvs[nIndexViewSelected];
									CoordSys ms2ps = mpv.modelToView();
									CoordSys ps2ms = ms2ps;
									ps2ms.invert();
									Vector3d vecModelView = _ZW;
									vecModelView.transformBy(ps2ms);
									vecModelView.normalize();
									mapTsl.setVector3d("ModelView", vecModelView);
									pageSelected.regenerate();
									ptsTsl[0]=ppVPsSections[nSelected].ptMid();
								}
								
								entsTsl[0] = entSelected; 
								
								tslNew.dbCreate(scriptName(),vecXTsl,vecYTsl,gbsTsl, entsTsl, 
									ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
								
								ppVPsSections.removeAt(nSelected);
								nIndexViews.removeAt(nSelected);
								mapsVPsSections.removeAt(nSelected,false);
								mapArgs.setMap("mapsVPsSections",mapsVPsSections);
								if(ppVPsSections.length()>0)
								{ 
								// continue;
									nGoJig = - 1;
								}
								else if(ppVPsSections.length()==0)
								{ 
									eraseInstance(); //do not insert this instance
									return;
								}
							}
							else if (nGoJig == _kCancel)
							{
								eraseInstance(); //do not insert this instance
								return;
							}
						}
					}
					else if(ppVPsSections.length()==1)
					{ 
					// only one section/viewport
					// no need for selection, just insert the tsl
						int nSelected= 0;
						Map mapSelected=mapsVPsSections.getMap(nSelected);
						Entity entSelected=mapSelected.getEntity("ent");
						int nIndexViewSelected = nIndexViews[nSelected];
						
						if(nIndexViewSelected>-1)
						{ 
							pageSelected=(MultiPage)entSelected;
							MultiPageView mpvs[] = pageSelected.views();
							MultiPageView& mpv = mpvs[nIndexViewSelected];
							CoordSys ms2ps = mpv.modelToView();
							CoordSys ps2ms = ms2ps;
							ps2ms.invert();
							Vector3d vecModelView = _ZW;
							vecModelView.transformBy(ps2ms);
							vecModelView.normalize();
							mapTsl.setVector3d("ModelView", vecModelView);
							pageSelected.regenerate();
						}
						
						entsTsl[0] = entSelected; 
						tslNew.dbCreate(scriptName(),vecXTsl,vecYTsl,gbsTsl, entsTsl, 
							ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
								
					}
					if(pageSelected.bIsValid())
					{
						pageSelected.regenerate();
					}
					eraseInstance(); //do not insert this instance
					return;
				}
				
//			// create TSL
//				TslInst tslNew;	Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
//				GenBeam gbsTsl[] = { };	Entity entsTsl[1]; Point3d ptsTsl[] ={_Pt0};
//				int nProps[]={};double dProps[]={}; 
//				String sProps[]={sRule,sPainterStream,sHatchMapping};
//				Map mapTsl;	
//				
//				dProps.setLength(0);
//				dProps.append(dSectionLevel);
//				dProps.append(dSectionDepth);
//				dProps.append(dGlobalScaling);
//				dProps.append(dGlobalTransparency);			
//				
//			// create per section
//				for (int i=0;i<ents.length();i++) 
//				{ 
//					entsTsl[0] = ents[i]; 
//					tslNew.dbCreate(scriptName(),vecXTsl,vecYTsl,gbsTsl, entsTsl, 
//						ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	 
//				}//next i
//				
//				eraseInstance();
//				return;
			}
		}
	}
// end on insert	__________________//endregion
	
	if (_bOnInsert || _bOnElementConstructed || _bOnDbCreated)
	{
		// HSB-15906: collect streams	
		String streams[0];
		String sScriptOpmName = bDebug ? "hsbViewHatching" : scriptName();
		String entries[] = TslInst().getListOfCatalogNames(sScriptOpmName);
		int nStreamIndices[] ={ 1};//index 1 of the stream property
		for (int i = 0; i < entries.length(); i++)
		{
			String& entry = entries[i];
			Map map = TslInst().mapWithPropValuesFromCatalog(sScriptOpmName, entry);
			Map mapProp = map.getMap("PropString[]");
			
			for (int j = 0; j < mapProp.length(); j++)
			{
				Map m = mapProp.getMap(j);
				int index = m.getInt("nIndex");
				String stream = m.getString("strValue");
				if (nStreamIndices.find(index) >- 1 && streams.findNoCase(stream ,- 1) < 0)
				{
					streams.append(stream);
				}
			}//next j
		}//next i
		// disabled or a painter rule
		int nRule = sRules.find(sRule);
		// by material or painter
		int nHatchMapping=sHatchMappings.find(sHatchMapping);
		for (int i = 0; i < streams.length(); i++)
		{
			String& stream = streams[i];
			String _painters[0];
			_painters = sPainters;
			if (stream.length() > 0)
			{
				// get painter definition from property string	
				Map m;
				m.setDxContent(stream , true);
				String name = m.getString("Name");
				String type = m.getString("Type").makeUpper();
				String filter = m.getString("Filter");
				String format = m.getString("Format");
				// create definition if not present	
				//				if (m.hasString("Name") && m.hasString("Type") && name.find(sPainterCollection,0,false)>-1 &&
				//					_painters.findNoCase(name,-1)<0)
				if (m.hasString("Name") && m.hasString("Type") && _painters.findNoCase(name,- 1) < 0)
				{
					PainterDefinition pd(name);
					// HSB-20377: dont create painter definition if not requested on insert
					// HSB-20377: no disabled and no by material selected
					if(nRule!=0 && nHatchMapping!=0)
					if (!pd.bIsValid())
					{
						pd.dbCreate();
						pd.setType(type);
						pd.setFilter(filter);
						pd.setFormat(format);
						
						if (pd.bIsValid())
						{
							sPainters.append(name);
						}
					}
				}
			}
		}
	}
	// HSB-24107:
	int bAllowEntitiesXref=sNoYes.find(sAllowEntitiesXref);
	if(sRule==T("|<Disabled>|"))
	{ 
	// set to by material and hide it
		if(sHatchMapping==sHatchMappings[1])
		{
			sHatchMapping.set(sHatchMappings[0]);
			reportMessage("\n"+scriptName()+" "+T("|Option|")+" '"+sHatchMappings[1]+
			+"' "+T("|is not supported when|")+" '"+T("|<Disabled>|") +"' "+
			T("|is selected as a painter filter|"));
		}
//		sHatchMapping.setReadOnly(_kHidden);
	}
	else if(sRule!=T("|<Disabled>|"))
	{ 
	// painter is selected
		sHatchMapping.setReadOnly(false);
	}
	int nHatchMapping=sHatchMappings.find(sHatchMapping);
	
	
//region display object, default hatch parameters
	Display dp(nc);
	double dTextHeight = U(100);
	dp.textHeight(dTextHeight);
	
	// solid variables
	int nSolidHatch;
	int nSolidTransparency;
	int nSolidColor;
	int bHasSolidColor;
	// default orientation hatch parameters
	String sPattern = "ANSI31";// hatch pattern
	int nColor = 1;// color index
	int nTransparency = 0;// transparency
	int dAngle = 0;// hatch angle
	double dScale = 10.0;// hatch scale
	double dScaleMin = 25;// dScaleMin
	int bStatic = 0;// by default make dynamic
	// contour parameters
	int bContour;
	int nColorContour;
	double dContourThickness;
	// HSB-12339
	int bSupressBeamCross=false;
	// HSB-12334: relevant for insulation
	int bInsulation;
	double dScaleLongitudinal=1;
	double dScaleTransversal=1;
	
//End display object//endregion	

//region PainterDefinition active
	int nRule = sRules.find(sRule);
	if (nRule<0)
	{ 
		sRule.set(sRules.first());
		setExecutionLoops(2);
		return;
	}
	int nPainter = sPainters.findNoCase(sRule,-1);
	PainterDefinition painter;
	if (nPainter>-1)
	{
		painter = PainterDefinition(sPainters[nPainter]);
		if (!painter.bIsValid())nPainter = -1;
	}
	
	if (painter.bIsValid())
	{ 
		Map m;
		m.setString("Name",painter.name());
		m.setString("Type",painter.type());
		m.setString("Filter",painter.filter());
		m.setString("Format",painter.format());
		sPainterStream.set(m.getDxContent(true));
	}
// HSB-20184: flag if painter groups are defined
	int bPainterGroup;
	String sPainterFormat;
	if(nHatchMapping)
	{ 
	// painter 
		sPainterFormat=painter.format();
		if(sPainterFormat.find("@",-1,0)>-1)
			bPainterGroup=true;
	}
	int bByPainter=nPainter>-1;
// HSB-18391: remove case sensitivity
	int bIsBeamPainter=bByPainter && (painter.type().makeLower()=="beam" || painter.type().makeLower()=="genbeam");
	int bIsSheetPainter=bByPainter && (painter.type().makeLower()=="sheet"|| painter.type().makeLower()=="genbeam");
	// HSB-11408 include panel as a type in the painter definition for SIPs
	int bIsSipPainter=bByPainter && (painter.type().makeLower()=="sip"|| painter.type().makeLower()=="panel" || painter.type().makeLower()=="genbeam");
//	int bIsTslPainter=bByPainter && painter.type().makeLower()=="tslinst";
	int bIsTslPainter=bByPainter && painter.type().makeLower()=="tslinstance";
	//
	int bIsElementPainter=bByPainter && (painter.type().makeLower()=="element"|| painter.type()=="elementwall" || painter.type()=="elementwallstickframe");
	// slab
	int bIsSlabPainter=bByPainter && (painter.type().makeLower()=="entity");
	// 3d volume
	int bIsSolidPainter=bByPainter && (painter.type().makeLower()=="entity");
	// masselement
	int bIsMassElementPainter=bByPainter && (painter.type().makeLower()=="entity");
	// FastenerAssembly
	int bIsFastenerAssemblyPainter=bByPainter && (painter.type().makeLower()=="fastenerassembly");
//End PainterDefinition active//endregion 
	
//region Collect section2d, ShopDrawView, Viewport is contained in _Viewport
	// all instances
	Entity ents[0];
	MassGroup massGroups[0];
	Element elements[0];
	Opening openings[0];
	// instances 
	Beam beams[0];int nBeamsCollection[0];
	Sip sips[0];int nSipsCollection[0];
	Sheet sheets[0];int nSheetsCollection[0];
	TslInst tsls[0];int nTslsCollection[0];
	// collection entities
	TrussEntity trusses[0];int nTrussesCollection[0];
	MetalPartCollectionEnt metals[0];int nMetalsCollection[0];
	CoordSys csCollections[0];
//	CollectionEntity entCollections[0];
	// entities that have volume
	Entity entVolumes[0];int nEntVolumesCollection[0];
	MassElement massElements[0];int nMassElementsCollection[0];
	Slab slabs[0];int nSlabsCollection[0];
	Wall walls[0];int nWallsCollection[0];
	FastenerAssemblyEnt fastenerAssemblyEnts[0];int nFastenersCollection[0];
	
// from bOnInsert we can have 3 scenarios
// 1- section 2d selected in model space
// 2- viewport selected in layout
// 3- shopdraw viewport selected in block definition of shopdraw
	
	ShopDrawView sdv;
	Section2d section;
	MultiPage page;
	ClipVolume clipVolume;
	Entity entsDefineSet[0], entsShowset[0];
	
	int bHasSDV;// hasShopDrawView
	int bHasSection;// has section 
	int bHasPage;//has Multipage
	
	double dXVp, dYVp; // X/Y of viewport/shopdrawviewport
	Point3d ptCenVp = _Pt0;
	Element el;
	CoordSys ms2ps, ps2ms;
	// plane in paper space
	int nPaperPlane;
	Plane pnPaper;
	Point3d ptOrgPaper;
	// viewport or shopdraw scale
	double dScaleVP = 1.0;
	// for viewport
	ViewData viewData;
	int bViewData;
	Entity entDefine;
	
	Vector3d vecZM = _ZU;
	// loop in entities to get shopDrawView or section2s
	for (int i = 0; i < _Entity.length(); i++)
	{
		// check if it is a shopDrawView
		sdv = (ShopDrawView)_Entity[i];
		if (sdv.bIsValid())
		{
			// interprete the list of ViewData in my _Map
			ViewData viewDatas[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets, 0); //2 means verbose
			// get the viewdata object for the shopDrawView sdv
			int nIndex = ViewData().findDataForViewport(viewDatas, sdv);//find the viewData for my view
			
			if (nIndex >- 1)
			{
				viewData = viewDatas[nIndex];
				bViewData = true;
				dXVp = viewData.widthPS();
				dYVp = viewData.heightPS();
				ptCenVp = viewData.ptCenPS();
				
				ms2ps = viewData.coordSys();
				ps2ms = ms2ps; ps2ms.invert();
				dScaleVP = viewData.dScale();
				// entities in the viewData
				entsDefineSet = viewData.showSetDefineEntities();
				// HSB-16740: dont collect entities
//				entsShowset = viewData.showSetEntities();
				ptOrgPaper = sdv.coordSys().ptOrg();
	//			ptOrgPaper.transformBy(ms2ps);
				pnPaper = Plane(ptOrgPaper, _ZW);
				nPaperPlane = true;
				for (int j = 0; j < entsDefineSet.length(); j++)
				{
					// an element is found in the entities of the viewData
					el = (Element)entsDefineSet[j];
					if (el.bIsValid())break;
				}//next j
			}
			// it has shopDrawView
			bHasSDV = true;
			break;
		}
		
		// check if it is a section2d
		section = (Section2d)_Entity[i];
		if (section.bIsValid())
		{
			clipVolume = section.clipVolume();
			if (!clipVolume.bIsValid())
			{
				eraseInstance();
				return;
			}
			_Entity.append(clipVolume);
			ms2ps = section.modelToSection();
			ps2ms = ms2ps; ps2ms.invert();
			ptOrgPaper = section.coordSys().ptOrg();
//			ptOrgPaper.transformBy(ms2ps);
			pnPaper = Plane(ptOrgPaper, _ZW);
			nPaperPlane = true;
			// HSB-9437: if bExplodeXrefBlocks is TRUE then return the entities inside the xrefs, instead of the BlockRef entities itself.
//			entsShowset = clipVolume.entitiesInClipVolume(true);
			entsShowset = clipVolume.entitiesInClipVolume(bAllowEntitiesXref);
			_ThisInst.setAllowGripAtPt0(false);
			setDependencyOnEntity(section);
			// HSB-22914
//			setDependencyOnEntity(clipVolume);
			
			vecZM = _ZW;
			vecZM.transformBy(ps2ms); vecZM.normalize();
			
			bHasSection = true;
			// section found, break;
			break;
		}
		
		// Multipage
		MultiPage _page = (MultiPage) _Entity[i];
		if (_page.bIsValid())
		{
			page = _page;
			bHasPage = true;
			setDependencyOnEntity(_Entity[i]);
			if(nGroupAssignment==0)
			{
				// by default, assign by entity
				assignToGroups(_Entity[i], 'D');
			}
			entDefine = _Entity[i];
			entsShowset= page.showSet();
			if (entsShowset.length()<1)
			{
				reportMessage(TN("|No show set found for multipage| ") + page.handle());
				break;
			}			
		
		// keep relative loocation to multipage 
			Point3d ptOrg = page.coordSys().ptOrg();
			ptOrgPaper = page.coordSys().ptOrg();
			pnPaper = Plane(ptOrgPaper, _ZW);
			nPaperPlane = true;
			
			if (_Map.hasVector3d("vecOrg") && !_bOnDbCreated && !bDebug)
			{
				Point3d ptX = _Pt0;
				if(_kNameLastChangedProp!="_Pt0")
					_Pt0 = ptOrg + _Map.getVector3d("vecOrg");
				for (int g=0;g<_PtG.length();g++) 
					if(_kNameLastChangedProp!="_PtG"+g)
						_PtG[g].transformBy(_Pt0-ptX);
			}
			else if(!_Map.hasVector3d("vecOrg"))
			{ 
			// HSB-20184: initialize
				_Map.setVector3d("vecOrg",_Pt0-ptOrg);
			}
			
			
			//region Get selected view of multipage
			Vector3d vecModelView = _Map.getVector3d("ModelView");
			vecZM = _ZW;
			MultiPageView mpv, views[] = page.views();
			for (int i=0;i<views.length();i++) 
			{ 
				
				ms2ps = views[i].modelToView();
				ps2ms = ms2ps; ps2ms.invert();
				vecZM = _ZW;
				vecZM.transformBy(ps2ms);
				viewData = views[i].viewData();
				bViewData = true;
				dXVp = viewData.widthPS();
				dYVp = viewData.heightPS();
				Plane pn(_PtW, _ZW);
				PlaneProfile pp(pn);
				pp.joinRing(views[i].plShape(), _kAdd);
				ptCenVp = pp.ptMid();
//				ptCenVp = viewData.ptCenPS();

				if (vecModelView.isCodirectionalTo(vecZM))
				{ 
				// HSB-20184: Get showset from views of SD
					entsShowset= views[i].showSet();
					views[i].plShape().vis(1);
					break;
				}
			}//next i				
		//endregion 
		}
	}
	if(_bOnDbCreated && bHasSection)
	{ 
		if(nMode!=1)
		{ 
			// avoid multipla instances
			TslInst tslViewHatches[0];
			String names[] ={ scriptName()};
			int nOut=getTslsByName(tslViewHatches,names);
			_Map.setEntity("section",section);
			for (int t=tslViewHatches.length()-1; t>=0 ; t--) 
			{ 
				TslInst tsl=tslViewHatches[t]; 
				if(tsl==_ThisInst)continue;
				if(tsl.map().getInt("mode")==1)continue;
				Entity entsTsl[]=tsl.entity();
				Entity entSectionTsl=tsl.map().getEntity("section");
				Section2d sectionTsl=(Section2d)entSectionTsl;
				if(sectionTsl==section)
				{ 
					if(tsl.propString(2)==sHatchMapping)
					{ 
						if(nHatchMapping==0 || 
						(nHatchMapping==1 && sRule==tsl.propString(0)))
						{ 
							reportMessage("\n" + scriptName() + ": " +T("|deleting duplicated instance|"));
							eraseInstance();
							return;
						}
					}
				}
			}//next t

			setExecutionLoops(2);
		}
	}
	
	// HSB-24107
	if(bHasSection)
	{ 
		if(nMode!=1)
		{ 
			if(_Map.hasEntity("entLevelDepth"))
			{ 
				Entity entLevelDepth=_Map.getEntity("entLevelDepth");
				if(!entLevelDepth.bIsValid())
				{ 
					eraseInstance();
					return;
				}
				TslInst tslLevelDepth=(TslInst)entLevelDepth;
				tslLevelDepth.recalc();
			}
			if (_kNameLastChangedProp == sAllowEntitiesXrefName) 
			{ 
				Entity entLevelDepth=_Map.getEntity("entLevelDepth");
				TslInst tslLevelDepth=(TslInst)entLevelDepth;
				tslLevelDepth.setPropString(3,sAllowEntitiesXref);
			}
		}
		else if(nMode==1)
		{ 
			
			// section mode
			if(_Map.hasEntity("entSectionHatch"))
			{ 
				Entity entSectionHatch=_Map.getEntity("entSectionHatch");
				if(!entSectionHatch.bIsValid())
				{ 
					eraseInstance();
					return;
				}
			}
			for (int e=0;e<_Entity.length();e++) 
			{ 
				setDependencyOnEntity( _Entity[e]); 
			}//next e
			
			
		}
	}
	
	// at section in model split the tsl into two 
	// for the hatch and for the level and depth
	TslInst tslLevelDepth;
	if(bHasSection && nMode!=1)
	{ 
		// get the tsl for level and depth
		if(_Map.hasEntity("entLevelDepth"))
		{ 
			Entity entLevelDepth=_Map.getEntity("entLevelDepth");
			TslInst _tslLevelDepth=(TslInst)entLevelDepth;
			if(_tslLevelDepth.bIsValid())
			{ 
				tslLevelDepth=_tslLevelDepth;
			}
		}
		if(tslLevelDepth.bIsValid())
		{ 
			_Entity.append(tslLevelDepth);
			setDependencyOnEntity(tslLevelDepth);
		}
		else
		{ 
			// create level depth tsl
			// create TSL
			TslInst tslNew;	Vector3d vecXTsl=_XW; Vector3d vecYTsl=_YW;
			GenBeam gbsTsl[]={}; Entity entsTsl[]=_Entity; Point3d ptsTsl[]={_Pt0};
			int nProps[]={}; 
			double dProps[]={dSectionLevel,dSectionDepth,dGlobalScaling,dGlobalTransparency};
			String sProps[]={sRule,sPainterStream,sHatchMapping,sAllowEntitiesXref};
			Map mapTsl;
			entsTsl.append(_ThisInst);
			mapTsl.setInt("mode",1);
			mapTsl.setEntity("entSectionHatch",_ThisInst);
						
			tslNew.dbCreate(_bOnDebug?"hsbViewHatching":scriptName(),vecXTsl,vecYTsl,gbsTsl,entsTsl,
				ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);
				
			_Entity.append(tslNew);
			_Map.setEntity("entLevelDepth", tslNew);
		}
	}
	if(_bOnDbErase)
	{ 
		
	}
	if (_Entity.length()<1 && _Map.getInt(kBlockCreationMode)) // Blockspace creation
	{ 
		return;
	}
	PlaneProfile ppShape,ppPreviewShape;
	CoordSys cs;
	if(bHasSDV)
	{ 
		ViewData viewDatas[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets, 0);
		int nIndFound = ViewData().findDataForViewport(viewDatas, sdv);//find the viewData for my view
		
		if (_bOnGenerateShopDrawing && nIndFound>-1)
		{ 
		// Get multipage from _Map
			Entity entCollector=_Map.getEntity(_kOnGenerateShopDrawing+"\\entCollector");
			Map mapTslCreatedFlags=entCollector.subMapX("mpTslCreatedFlags");
			String uid=_Map.getString("UID"); // get the UID from map as instance does not exist onGenerateShopDrawing
			int bIsCreated=mapTslCreatedFlags.hasInt(uid);
			// Create modelspace instance if not tagged as being created
			if (!bIsCreated && entCollector.bIsValid())
			{
				ViewData viewData=viewDatas[nIndFound];
			// Get defining genbeam
				Entity entDefine;
				Entity ents[]=viewData.showSetDefineEntities();
				if (ents.length() > 0)// && ents.first().bIsKindOf(GenBeam()))
					entDefine=ents.first();
					
			// the viewdirection of this shopdrawview in modelspace
				Vector3d vecAllowedView=_ZW;
				vecAllowedView.transformBy(ps2ms);
				vecAllowedView.normalize();
				
			// create TSL
				TslInst tslNew;
				GenBeam gbsTsl[] = {}; Entity entsTsl[]={entCollector};Point3d ptsTsl[]={_Pt0};
				int nProps[]={};
				double dProps[]={dSectionLevel,dSectionDepth,dGlobalScaling,dGlobalTransparency};
				String sProps[]={sRule,sPainterStream,sHatchMapping,sAllowEntitiesXref};
				Map mapTsl;
				
				mapTsl.setVector3d("vecOrg", _Pt0-_PtW); // relocate to multipage
				mapTsl.setVector3d("ModelView", vecAllowedView);// the offset from the viewpport
				mapTsl.setInt(kBlockCreationMode, true);
				
				tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			
	
				if (tslNew.bIsValid())
				{
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
		else
		{ 
		// blockspace setup
			bInBlockSpace = true;
			setDependencyOnEntity(sdv);
			_Map.setString("UID", _ThisInst.uniqueId()); // store UID to have access during _kOnGenerateShopDrawing
			
			//region Get bounds of viewports
//			PlaneProfile pp(cs);
			PlaneProfile pp(cs);
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
			pp.extentInDir(_XW).vis(1);
			
		//endregion 

		//region Display
			int bUseTextHeight;
			Display dp(-1);
			dp.trueColor(brown);
			String sDimStyle=_DimStyles[0];
			dp.dimStyle(sDimStyle, dScaleVP);
			double textHeight=dTextHeight*dScaleVP*.1;
			double textHeightForStyle=dp.textHeightForStyle("O", sDimStyle)*dScaleVP;
//			double dDimScale=(dGlobalScale>0?dGlobalScale:1)*dScale;
			if (dTextHeight<=0) 
				textHeight=textHeightForStyle;
			else 
			{
				bUseTextHeight=true;
				dp.textHeight(textHeight);
			}				
		//endregion 

		//region Create preview graphics
			dX -= textHeight;
			dY -= textHeight;
			vec = .5 * (_XW * dX + _YW * dY);
			pl = PLine(_ZW);
			Point3d pt = ptCen - vec;
			
			// get potential planeprofile
			Map m = sdv.subMapX("Preview");
			Entity originator = m.getEntity("originator");
			if (m.hasPlaneProfile("pp") && originator.bIsValid())
			{ 
				ppPreviewShape = m.getPlaneProfile("pp");
				//ppPreviewShape.extentInDir(_XW+_YW).vis(3);
			}
			else
			{ 
				pl.addVertex(pt);
				pl.addVertex(pt+_YW*.5*dY);
				pl.addVertex(pt+_XW*(dX-.5*dY)+_YW*dY);
				pl.addVertex(pt+_XW*(dX-.5*dY), pt+_XW*dX+.5*_YW*dY);
				pl.close();
				
				ppPreviewShape=PlaneProfile(cs);
				ppPreviewShape.joinRing(pl,_kAdd);
				PlaneProfile ppSub = ppPreviewShape;
				double dShrink = (dX < dY ? dX : dY) *.25;
				dShrink = textHeight < dShrink ? 2*textHeight:dShrink;
				ppSub.shrink(dShrink);
				ppPreviewShape.subtractProfile(ppSub);

			// store against parent sdv
				originator = _ThisInst;
				m.setEntity("originator", originator);
				m.setPlaneProfile("pp", ppPreviewShape);
				sdv.setSubMapX("Preview", m);
			}
			
		// only the originator draws the preview	
			if (originator == _ThisInst)
			{ 
				dp.trueColor(brown);
				dp.draw(ppPreviewShape);
			}
		 	
			ppShape = ppPreviewShape;
			if (_bOnDbCreated && !bInBlockSpace)
			{ 
				_Pt0 = pt+_YW*.5*dY;
				Vector3d vec = _YW - _XW; vec.normalize(); 
				_PtG.append(_Pt0 + vec * 4 * textHeight);
				_PtG.append(_Pt0 - _XW * 4 * textHeight);
			}
		//endregion 
		}
	}
	
	if(_Entity.length()==0)
	{ 
		reportMessage("\n"+scriptName()+" "+T("|No view entity found|"));
		eraseInstance();
		return;
	}
	//region Special Group Assignment
	// set layer on creation or on global settings change
	if (nGroupAssignment==1)
	{ 
		int bSetLayer = _Map.getInt("setLayer");
		
		if ((_bOnDbCreated || _kNameLastChangedProp==sTriggerGlobalSetting) || bSetLayer)
		{ 
//			reportNotice("\nflag =" +  bSetLayer);
			assignToLayer("0");	
			_Map.removeAt("setLayer", true);
		}
//			String layer = _ThisInst.layerName();
//			if (layer.find("~",0,false)>-1) // assuming a layer consisting a tilde is an hsb group layer previously assigned
//			{ 
//				assignToLayer("0");	
//			}
	}			
//endregion
// 16.02.2023
	if(!bHasSDV && _Viewport.length()==0)
	{ 
		if(!bHasPage)
		{ 
		// HSB-20184: not for multipage
			Point3d ptsGrips[] = _Entity[0].gripPoints();
			if(ptsGrips.length()>0)
				_Pt0.setToAverage(ptsGrips);
		}
	}
	
//region check if tsl instance is moved
	int bMoved;
	if ( ! _Map.hasPoint3d("Position"))
	{
		_Map.setPoint3d("Position",_Pt0,_kAbsolute);
	}
	else if(_Map.hasPoint3d("Position"))
	{ 
		if((_Pt0-_Map.getPoint3d("Position")).length()>dEps)
		{ 
			bMoved = true;
		}
		if(bMoved)
		{ 
			_Map.setPoint3d("Position", _Pt0, _kAbsolute);
			if(bMoved)
			{ 
				if(_Map.hasPoint3d("PtG0") && _PtG.length()>0)
				{
					_PtG[0]=_Map.getPoint3d("PtG0");
				}
				if(_Map.hasPoint3d("PtG1") && _PtG.length()>1)
				{
					_PtG[1]=_Map.getPoint3d("PtG1");
				}
			}
		}
	}
//End check if tsl instance is moved//endregion 	
	
//region No shopdraw viewport, no viewport or no section and it is in paperspace 
	if (!bHasSDV && _Viewport.length() == 0 && !bHasSection && !bHasPage && Viewport().switchToPaperSpace())
	{
	// it is in paperSpace, prompt to add a viewport
		dp.color(1);
		dp.draw(scriptName() + T(": |please add a viewport|"), _Pt0, _XW, _YW, 1, 0);
		
	// Trigger AddViewPort
		String sTriggerAddViewPort = T("|Add Viewport|");
		addRecalcTrigger(_kContext, sTriggerAddViewPort );
		if (_bOnRecalc && (_kExecuteKey == sTriggerAddViewPort || _kExecuteKey == sDoubleClick))
		{
			_Viewport.append(getViewport(T("|Select a viewport|")));
			setExecutionLoops(2);
			return;
		}
		return; // _Viewport array has some elements
	}
//endregion 

//region Viewport
	Viewport vp;
	int nActiveZoneIndex;
	int bIsElementViewport;
	int bIsAcaViewport,bIsHsbViewport;
	if (_Viewport.length() > 0)
	{ 
		vp = _Viewport[_Viewport.length()-1]; // take last element of array
		_Map.setString("ViewHandle", vp);
		_Viewport[0] = vp; // make sure the connection to the first one is lost
		ms2ps = vp.coordSys();
		ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps
		dScaleVP = vp.dScale();
		
		dXVp = vp.widthPS();
		dYVp = vp.heightPS();
		ptCenVp= vp.ptCenPS();	
		
	// check if the viewport has hsb data
		el = vp.element();
		nActiveZoneIndex = vp.activeZoneIndex();

		if (el.bIsValid())
		{ 
			bIsHsbViewport = true;
		// elements	
			elements.append(el);
			if(ents.find(el)<0)ents.append(el);
		// get all element entities
		//beams
			beams = el.beam();
			for (int i=0;i<beams.length();i++) 
			{ 
				nBeamsCollection.append(-1); 
			}//next i
			for (int ib=0;ib<beams.length();ib++) 
				if(ents.find(beams[ib])<0)ents.append(beams[ib]);
		// sheets	
			sheets = el.sheet();
			for (int i=0;i<sheets.length();i++) 
			{ 
				nSheetsCollection.append(-1); 
			}//next i
			for (int ib=0;ib<sheets.length();ib++) 
				if(ents.find(sheets[ib])<0)ents.append(sheets[ib]);
		// sips	
			sips = el.sip();
			for (int i=0;i<sips.length();i++) 
			{ 
				nSipsCollection.append(-1); 
			}//next i
			for (int ib=0;ib<sips.length();ib++) 
				if(ents.find(sips[ib])<0)ents.append(sips[ib]);
		// tsls	
			tsls= el.tslInstAttached();
			for (int t=0;t<tsls.length();t++) 
			{ 
				nTslsCollection.append(-1);
			}//next t
			
			for (int ib=0;ib<tsls.length();ib++) 
				if(ents.find(tsls[ib])<0)ents.append(tsls[ib]);
		// openings	
			openings=el.opening();
			for (int ib=0;ib<openings.length();ib++) 
				if(ents.find(openings[ib])<0)ents.append(openings[ib]);
		}
	// ACA Viewport	
		else
		{
			entsShowset = _Entity;
			bIsAcaViewport = true;
//			ViewData viewData=vp.viewData();
////			entsShowset=viewData.showSetEntities();
//			entsShowset=viewData.showSetDefineEntities();
		}

	// make sure it is assigned to layer 0 on creation
		if (_bOnDbCreated) assignToLayer("0");		
	
	// element viewport/shopdraw viewport
		bIsElementViewport = el.bIsValid();	
	}
	
//End Viewport
// Get scale if not viewport
	else	
	{ 
		Vector3d vecScale(1, 0, 0);
		vecScale.transformBy(ps2ms);
		dScale = vecScale.length();	
	}
//endregion 
//End ollect section2d, ShopDrawView, Viewport is contained in _Viewport//endregion
		
//region Display a text in case of the shopdrawings that shows the positioning of the TSL
	int bDrawSetupInfo = true;
	if (bHasSection || (bHasSDV && entsDefineSet.length() > 0)
		|| (bHasPage && entsShowset.length()>0))
		bDrawSetupInfo = false;
	if (bDrawSetupInfo)
	{ 
		Display dp(7);
		dp.textHeight(dTextHeight*dScaleVP);
		if(bInBlockSpace)
		{ 
			dp.textHeight(dTextHeight*dScaleVP*.1);
		}
		dp.draw(scriptName(), _Pt0, _XW, _YW, 1, 0);
	}
//End Display in case of the shopdrawings//endregion 
		
//region add entities in modelspace if no element viewport
// if in layout space and not an element viewport then it is
// the option to select entites and the model space will be activated
	int bInLayoutTab = Viewport().inLayoutTab();
	if (_Viewport.length() > 0 && !bIsElementViewport)
	{ 
	// add to _Entity all from entsShowset
		for (int i = 0; i < entsShowset.length(); i++)
		{ 
			if (_Entity.find(entsShowset[i]) < 0)
			{ 
				_Entity.append(entsShowset[i]);
			}
		}//next i
		
	// we are in layout space and a viewport has already been selected
	// and it is not an element viewport
	// Trigger AddEntity//region
		String sTriggerAddEntity = T("|Add Entity(s)|");
		addRecalcTrigger(_kContext, sTriggerAddEntity );
		if (_bOnRecalc && (_kExecuteKey == sTriggerAddEntity))
		{
		// go to model space
			int bIsModelSpace = Viewport().switchToModelSpace();
			if (bIsModelSpace)
			{ 
			// prompt selection of entities
				Entity _ents[0];
				PrEntity ssE(T("|Select entity(s)|"), Entity());
				if (ssE.go())
				{ 
					_ents.append(ssE.set());
				}
			// switch back to paper space
				int bIsPaperSpace = Viewport().switchToPaperSpace();
				// save to _Entity the newly selected _ents
				for (int i=0;i<_ents.length();i++) 
				{ 
					if (_Entity.find(_ents[i]) < 0)
					{ 
					// its a new selection, append it
						_Entity.append(_ents[i]);
					}
				}//next i
			}
			setExecutionLoops(2);
			return;
		}//endregion
		
	// Trigger RemoveEntity//region
		String sTriggerRemoveEntity = T("|Remove Entity(s)|");
		addRecalcTrigger(_kContext, sTriggerRemoveEntity );
		if (_bOnRecalc && (_kExecuteKey == sTriggerRemoveEntity || _kExecuteKey == sDoubleClick))
		{
		// go to model space
			int bIsModelSpace = Viewport().switchToModelSpace();
			if (bIsModelSpace)
			{ 
			// prompt selection of entities
				Entity _ents[0];
				PrEntity ssE(T("|Select entity(s)|"), Entity());
				if (ssE.go())
				{ 
					_ents.append(ssE.set());
				}
			// switch back to paper space
				int bIsPaperSpace = Viewport().switchToPaperSpace();
				// remove from entity the newly selected _ents
				for (int i = _ents.length() - 1; i >= 0; i--)
				{ 
					if (_Entity.find(_ents[i]) >- 1);
					{ 
						_Entity.removeAt(_Entity.find(_ents[i]));
					}
				}//next i
			}
			setExecutionLoops(2);
			return;
		}//endregion
	
	// entsShowset will take the entities in _Entity
		entsShowset.setLength(0);
		entsShowset.append(_Entity);
	}
	if(bHasPage)
	{ 
		for (int i = 0; i < entsShowset.length(); i++)
		{ 
			if (_Entity.find(entsShowset[i]) < 0)
			{ 
				_Entity.append(entsShowset[i]);
			}
		}//next i
	}
//End add entities in modelspace if no element viewport//endregion 
		
//region Make the properties readonly as they are not relevant for 2dsections
// for 2dsections dSectionLevel and dSectionDepth are defined by the clipping body 	
	
//	if (bHasSection)
//	{
//		;
//		dSectionLevel.setReadOnly(true);
//		dSectionDepth.setReadOnly(true);
//	}
//	else
//	{ 
//		;
		// element viewport of shopdraw viewport
//		if (dSectionLevel > dSectionDepth)
//		{ 
//			// dSectionLevel cant be higher than dSectionDepth 
//			dSectionLevel = dSectionDepth;
//		}
//	}
//End make the properties readonly as they are not relevant for 2dsections//endregion 
	
//region Transformations
//	CoordSys ms2ps = section.modelToSection();
//	CoordSys ps2ms = ms2ps; ps2ms.invert();
	Vector3d vecX = _XW, vecY = _YW, vecZ = _ZW;
//	Point3d ptOrg = ms2ps.ptOrg();
//	Vector3d vecX1 = ms2ps.vecX();
//	Vector3d vecY1 = ms2ps.vecY();
//	Vector3d vecZ1 = ms2ps.vecZ();
//End transformations//endregion
	
	
//region Get all entities from the clipVolume and collect beams, sips, sheets, elements, Massgroups	
	// collect from the entsShowset all beams, elements, sips (panels), sheets, massGroups, TSL
	// entsShowset from viewport or section
	int nCollectionEntityCounter=0;
	for (int j=0;j<entsShowset.length();j++) 
	{ 
		int bAssemblyTsl;
		{ 
			TslInst tslJ=(TslInst)entsShowset[j];
			if(tslJ.bIsValid() && tslJ.scriptName()=="AssemblyDefinition")bAssemblyTsl=true;
			if(tslJ.bIsValid() && tslJ.scriptName()=="TruckDefinition")bAssemblyTsl=true;
//			if(tslJ.bIsValid() && tslJ.scriptName()=="ShipmentItem")bAssemblyTsl=true;
		}
		if (bByPainter && !entsShowset[j].acceptObject(painter.filter()) && !bAssemblyTsl){ continue;}
		// collect beams
		Beam beam = (Beam)entsShowset[j];
		if (beam.bIsValid() && beams.find(beam) < 0 && (!bByPainter || bIsBeamPainter))
		{
			beams.append(beam);
			nBeamsCollection.append(-1);// not part of any collection
			if (ents.find(beam) < 0)ents.append(beam);
			continue;
		}
		// collect sips
		Sip sip = (Sip)entsShowset[j];
		if (sip.bIsValid() && sips.find(sip) < 0 && (!bByPainter || bIsSipPainter))
		{
			sips.append(sip);
			nSipsCollection.append(-1);
			if (ents.find(sip) < 0)ents.append(sip);
			continue;
		}
		// collect sheets
		Sheet sheet = (Sheet)entsShowset[j];
		if (sheet.bIsValid() && sheets.find(sheet) < 0 && (!bByPainter || bIsSheetPainter))
		{
			sheets.append(sheet);
			nSheetsCollection.append(-1);
			if (ents.find(sheet) < 0)ents.append(sheet);
			continue;
		}
		// collect elements
		Element element = (Element)entsShowset[j];
		if (element.bIsValid() && elements.find(element) < 0)
		{
			elements.append(element);
			if (ents.find(element) < 0)ents.append(element);
			continue;
		}
		// TSL instances
		TslInst tsl = (TslInst) entsShowset[j];
		if (tsl.bIsValid() && tsls.find(tsl) < 0 &&  (!bByPainter || bIsTslPainter || bAssemblyTsl))
		{ 
			tsls.append(tsl);
			nTslsCollection.append(-1);
			if (ents.find(tsl) < 0)ents.append(tsl);
//			String sN = tsl.scriptName();
//			GenBeam gbsTsl[]=tsl.genBeam();
			// HSB-20048: for assembly efinitions and assembly SD 
			// showset consists of one tsl assemblyDefinition
			Entity entsTsl[]=tsl.entity();
			
			for (int ient=0;ient<entsTsl.length();ient++) 
			{ 
				Beam bmI=(Beam)entsTsl[ient];
				if(bmI.bIsValid())
				{ 
					if (bByPainter && !bmI.acceptObject(painter.filter())){ continue;}
					if (beams.find(bmI)<0)
					{
						beams.append(bmI);
						nBeamsCollection.append(-1);// not part of any collection
						if (ents.find(bmI) < 0)ents.append(bmI);
					}
					continue;
				}
				Sheet shI=(Sheet)entsTsl[ient];
				if(shI.bIsValid())
				{ 
					if (bByPainter && !shI.acceptObject(painter.filter())){ continue;}
					if (sheets.find(shI)<0)
					{
						sheets.append(shI);
						nSheetsCollection.append(-1);
						if (ents.find(shI) < 0)ents.append(shI);
					}
					continue;
				}
				Sip sipI=(Sip)entsTsl[ient];
				if(sipI.bIsValid())
				{ 
					if (sips.find(sipI)<0)
					{
						if (bByPainter && !sipI.acceptObject(painter.filter())){ continue;}
						sips.append(sipI);
						nSipsCollection.append(-1);
						if (ents.find(sipI) < 0)ents.append(sipI);
					}
					continue;
				}
				TslInst tslI=(TslInst)entsTsl[ient];
				if(tslI.bIsValid())
				{ 
					if (tsls.find(tslI)<0)
					{
						if (bByPainter && !tslI.acceptObject(painter.filter())){ continue;}
						tsls.append(tslI);
						nTslsCollection.append(-1);
						if (ents.find(tslI) < 0)ents.append(tslI);
					}
					continue;
				}
				if(entsTsl[ient].realBody().volume()>pow(dEps,3))
				{ 	if(entVolumes.find(entsTsl[ient])<0)
					{ 
						entVolumes.append(entsTsl[ient]);
						if (ents.find(entsTsl[ient]) < 0)ents.append(entsTsl[ient]);
					}
				}
			}//next ient
			
			continue;
		}
		// mass groups
		MassGroup massGroup = (MassGroup) entsShowset[j];
		if (massGroup.bIsValid() && massGroups.find(massGroup) < 0)
		{ 
			massGroups.append(massGroup);
			if (ents.find(massGroup) < 0)ents.append(massGroup);
			continue;
		}
		// mass element
		MassElement massElement = (MassElement) entsShowset[j];
		if (massElement.bIsValid() && massElements.find(massElement) < 0)
		{ 
			massElements.append(massElement);
			if (ents.find(massElement) < 0)ents.append(massElement);
			continue;
		}
		// slabs
		Slab slab = (Slab) entsShowset[j];
		if (slab.bIsValid() && slabs.find(slab) < 0)
		{ 
			slabs.append(slab);
			if (ents.find(slab) < 0)ents.append(slab);
			continue;
		}
		// wall
		Wall wall = (Wall) entsShowset[j];
		if (wall.bIsValid() && walls.find(wall) < 0)
		{ 
			walls.append(wall);
			if (ents.find(wall) < 0)ents.append(wall);
			continue;
		}
		// fastenerassembly entities
		// HSB-24107
		FastenerAssemblyEnt fastenerAssemblyEnt=(FastenerAssemblyEnt)entsShowset[j];
		if(fastenerAssemblyEnt.bIsValid() && fastenerAssemblyEnts.find(fastenerAssemblyEnt)<0)
		{ 
			fastenerAssemblyEnts.append(fastenerAssemblyEnt);
		}
		MetalPartCollectionEnt  metal=(MetalPartCollectionEnt )entsShowset[j];
		if(metal.bIsValid() && metals.find(metal)<0)
		{ 
			metals.append(metal);
			if (metals.find(metal)<0)metals.append(metal);
			
			String sCollectionDefinition=metal.definition();
			MetalPartCollectionDef collectionDefinition(sCollectionDefinition);
			
			Beam beamsCollection[]=collectionDefinition.beam();
			for (int ii=0;ii<beamsCollection.length();ii++) 
			{ 
				beams.append(beamsCollection[ii]);
				if (ents.find(beamsCollection[ii]) < 0)ents.append(beamsCollection[ii]);
				nBeamsCollection.append(nCollectionEntityCounter);
			}//next ii
			Sheet sheetsCollection[]=collectionDefinition.sheet();
			for (int ii=0;ii<sheetsCollection.length();ii++) 
			{ 
				sheets.append(sheetsCollection[ii]);
				if (ents.find(sheetsCollection[ii]) < 0)ents.append(sheetsCollection[ii]);
				nSheetsCollection.append(nCollectionEntityCounter);
			}//next ii
			Sip sipsCollection[]=collectionDefinition.sip();
			for (int ii=0;ii<sipsCollection.length();ii++) 
			{ 
				sips.append(sipsCollection[ii]);
				if (ents.find(sipsCollection[ii]) < 0)ents.append(sipsCollection[ii]);
				nSipsCollection.append(nCollectionEntityCounter);
			}//next ii
//			Entity entsCollection[]=collectionDefinition.entity();
		// save coordsystem of collections
			CoordSys csCollection=metal.coordSys();
			csCollections.append(csCollection);
			nCollectionEntityCounter+=1;
			continue;
		}
		TrussEntity truss=(TrussEntity )entsShowset[j];
		if(truss.bIsValid() && trusses.find(truss)<0)
		{ 
			trusses.append(truss);
			if (trusses.find(truss)<0)trusses.append(truss);
			
			String sCollectionDefinition=truss.definition();
			TrussDefinition collectionDefinition(sCollectionDefinition);
			
			Beam beamsCollection[]=collectionDefinition.beam();
			for (int ii=0;ii<beamsCollection.length();ii++) 
			{ 
				beams.append(beamsCollection[ii]);
				nBeamsCollection.append(nCollectionEntityCounter);
			}//next ii
			Sheet sheetsCollection[]=collectionDefinition.sheet();
			for (int ii=0;ii<sheetsCollection.length();ii++) 
			{ 
				sheets.append(sheetsCollection[ii]);
				nSheetsCollection.append(nCollectionEntityCounter);
			}//next ii
			Sip sipsCollection[]=collectionDefinition.sip();
			for (int ii=0;ii<sipsCollection.length();ii++) 
			{ 
				sips.append(sipsCollection[ii]);
				nSipsCollection.append(nCollectionEntityCounter);
			}//next ii
//			Entity entsCollection[]=collectionDefinition.entity();
		// save coordsystem of collections
			CoordSys csCollection=metal.coordSys();
			csCollections.append(csCollection);
			nCollectionEntityCounter+=1;
			continue;
		}
//		TrussEntity truss=(TrussEntity) entsShowset[j];
//		if (truss.bIsValid() && trusses.find(truss) < 0)
//		{ 
//			trusses.append(truss);
//			if (ents.find(truss) < 0)ents.append(truss);
//			continue;
//		}
//		MetalPartCollectionEnt metal=(MetalPartCollectionEnt) entsShowset[j];
//		if (metal.bIsValid() && metals.find(metal) < 0)
//		{ 
//			metals.append(metal);
//			if (ents.find(metal) < 0)ents.append(metal);
//			continue;
//		}
		// HSB-23455: Support blocks
		BlockRef blockRef=(BlockRef)entsShowset[j];
		{ 
			if(blockRef.bIsValid())
			{ 
				String sBlockDef=blockRef.definition();
				Block block(blockRef.definition());
				
				TslInst tslsBlock[]=block.tslInst();
//				Beam beamsCollection[] = block.beam();
				
				
				Beam beamsCollection[]=block.beam();
				for (int ii=0;ii<beamsCollection.length();ii++) 
				{ 
					String sXrefNameii=beamsCollection[ii].xrefName();
					if(!bAllowEntitiesXref && sXrefNameii==sBlockDef)
					{ 
						continue;
						// block is coming from xref
					}
					beams.append(beamsCollection[ii]);
					nBeamsCollection.append(nCollectionEntityCounter);
				}//next ii
				Sheet sheetsCollection[]=block.sheet();
				for (int ii=0;ii<sheetsCollection.length();ii++) 
				{ 
					String sXrefNameii=sheetsCollection[ii].xrefName();
					if(!bAllowEntitiesXref && sXrefNameii==sBlockDef)
					{ 
						continue;
						// block is coming from xref
					}
					sheets.append(sheetsCollection[ii]);
					nSheetsCollection.append(nCollectionEntityCounter);
				}//next ii
				Sip sipsCollection[]=block.sip();
				for (int ii=0;ii<sipsCollection.length();ii++) 
				{ 
					String sXrefNameii=sipsCollection[ii].xrefName();
					if(!bAllowEntitiesXref && sXrefNameii==sBlockDef)
					{ 
						continue;
						// block is coming from xref
					}
					sips.append(sipsCollection[ii]);
					nSipsCollection.append(nCollectionEntityCounter);
				}//next ii
				CoordSys csCollection=blockRef.coordSysScaled();
				csCollections.append(csCollection);
				nCollectionEntityCounter+=1;
				continue;
			}
		}
		
		Body bd = entsShowset[j].realBody();
		if(bd.volume()>pow(dEps,3) && entVolumes.find(entsShowset[j])<0)
		{ 
			entVolumes.append(entsShowset[j]);
			if (ents.find(entsShowset[j]) < 0)ents.append(entsShowset[j]);
			continue;
		}
	}//next j
	
// collect the entities beams, sips, sheets, TSLs from the MassGroup and append to the array of 
// beams, sips, sheets, TSLs
	Entity entsMG[0];
	for (int i = 0; i < massGroups.length(); i++)
	{ 
		MassGroup mg = massGroups[i];
		Entity ents[] = mg.entity();
		for (int j = 0; j < ents.length(); j++)
		{ 
			Entity entJ = ents[j];
			if (entsMG.find(entJ) < 0 && entsShowset.find(entJ) < 0)
			{ 
				entsMG.append(entJ);
				if (ents.find(entJ) < 0)ents.append(entJ);
			}
		}//next j
	}//next i
	for (int i = 0; i < entsMG.length(); i++)
	{ 
		if (bByPainter && !entsMG[i].acceptObject(painter.filter())){ continue;}
	// collect beams
		Beam beam = (Beam)entsMG[i];
		if (beam.bIsValid() && beams.find(beam) < 0)
		{
			beams.append(beam);
			nBeamsCollection.append(-1);// not part of any collection
			if (ents.find(beam) < 0)ents.append(beam);
			continue;
		}
	// collect sips
		Sip sip = (Sip)entsMG[i];
		if (sip.bIsValid() && sips.find(sip) < 0)
		{
			sips.append(sip);
			nSipsCollection.append(-1);
			if (ents.find(sip) < 0)ents.append(sip);
			continue;
		}
	// collect elements
		Element element = (Element)entsMG[i];
		if (element.bIsValid() && elements.find(element) < 0)
		{
			elements.append(element);
			if (ents.find(element) < 0)ents.append(element);
			continue;
		}
	// collect sheets
		Sheet sheet = (Sheet)entsMG[i];
		if (sheet.bIsValid() && sheets.find(sheet) < 0)
		{
			sheets.append(sheet);
			nSheetsCollection.append(-1);
			if (ents.find(sheet) < 0)ents.append(sheet);
			continue;
		}
	// TSL instances
		TslInst tsl = (TslInst) entsMG[i];
		if (tsl.bIsValid() && tsls.find(tsl) < 0)
		{ 
			tsls.append(tsl);
			if (ents.find(tsl) < 0)ents.append(tsl);
			continue;
		} 
	// Slabs
		Slab slab = (Slab) entsMG[i];
		if (slab.bIsValid() && slabs.find(slab) < 0)
		{ 
			slabs.append(slab);
			if (ents.find(slab) < 0)ents.append(slab);
			continue;
		}
	// Walls
		Wall wall = (Wall) entsMG[i];
		if (wall.bIsValid() && walls.find(wall) < 0)
		{ 
			walls.append(wall);
			if (ents.find(wall) < 0)ents.append(wall);
			continue;
		} 
	// Masselement
		MassElement massElement = (MassElement) entsMG[i];
		if (massElement.bIsValid() && massElements.find(massElement) < 0)
		{ 
			massElements.append(massElement);
			if (ents.find(massElement) < 0)ents.append(massElement);
			continue;
		}
	}//next i
//region for element viewports and shopdrawing viewports, get the bottom and top point wrt _ZW
	double dZmin = U(10e10);
	double dZmax = - U(10e10);
	Point3d ptMin;
	ptMin.setZ(10e10);
	Point3d ptMax;
	ptMax.setZ(-10e10);
	// lower left point in model space
	Point3d ptMinModel;
	// upper right point in model space
	Point3d ptMaxModel;
	double dZHeight;
	// vecZ in model space
	Vector3d vecZModel;
	
	if (!bHasSection)
	{
		sAllowEntitiesXref.setReadOnly(_kHidden);
	// not in model space, we are in layout or shop draw viewport
	// panels
		if (!bByPainter || bIsSipPainter)
		for (int i = 0; i < sips.length(); i++)
		{ 
			Sip sip = sips[i];
			if (bByPainter && !sip.acceptObject(painter.filter())){ continue;}
			Body bd = sip.realBody();
			CoordSys csCollectionTransform;
			if(nSipsCollection[i]>-1)
			{ 
				csCollectionTransform=csCollections[nSipsCollection[i]];
				bd.transformBy(csCollectionTransform);
			}
			bd.transformBy(ms2ps);
			PlaneProfile pp = bd.shadowProfile(Plane(_Pt0, _XW));
		// get extents of profile
			LineSeg seg = pp.extentInDir(_XW);
			if (seg.ptStart().Z() < dZmin) 
			{
				dZmin = seg.ptStart().Z();
				ptMin = seg.ptStart();
			}
			if (seg.ptEnd().Z() < dZmin) 
			{
				dZmin = seg.ptEnd().Z();
				ptMin = seg.ptEnd();
			}
			
			if (seg.ptStart().Z() > dZmax) 
			{
				dZmax = seg.ptStart().Z();
				ptMax = seg.ptStart();
			}
			if (seg.ptEnd().Z() > dZmax) 
			{
				dZmax = seg.ptEnd().Z();
				ptMax = seg.ptEnd();
			}
		}//next i
	// beams
		if (!bByPainter || bIsBeamPainter)
		for (int i = 0; i < beams.length(); i++)
		{ 
			Beam bm = beams[i];
			if (bByPainter && !bm.acceptObject(painter.filter())){ continue;}
			Body bd = bm.realBody();
			CoordSys csCollectionTransform;
			if(nBeamsCollection[i]>-1)
			{ 
				csCollectionTransform=csCollections[nBeamsCollection[i]];
				bd.transformBy(csCollectionTransform);
			}
			bd.transformBy(ms2ps);
			PlaneProfile pp = bd.shadowProfile(Plane(_Pt0, _XW));
		// get extents of profile
			LineSeg seg = pp.extentInDir(_XW);
			if (seg.ptStart().Z() < dZmin) 
			{
				dZmin = seg.ptStart().Z();
				ptMin = seg.ptStart();
			}
			if (seg.ptEnd().Z() < dZmin) 
			{
				dZmin = seg.ptEnd().Z();
				ptMin = seg.ptEnd();
			}
			
			if (seg.ptStart().Z() > dZmax) 
			{
				dZmax = seg.ptStart().Z();
				ptMax = seg.ptStart();
			}
			if (seg.ptEnd().Z() > dZmax) 
			{
				dZmax = seg.ptEnd().Z();
				ptMax = seg.ptEnd();
			}
		}//next i
	// sheets
		if (!bByPainter || bIsSheetPainter)
		for (int i = 0; i < sheets.length(); i++)
		{ 
			Sheet sh = sheets[i];
			if (bByPainter && !sh.acceptObject(painter.filter())){ continue;}
			Body bd = sh.realBody();
			CoordSys csCollectionTransform;
			if(nSheetsCollection[i]>-1)
			{ 
				csCollectionTransform=csCollections[nSheetsCollection[i]];
				bd.transformBy(csCollectionTransform);
			}
			bd.transformBy(ms2ps);
			PlaneProfile pp = bd.shadowProfile(Plane(_Pt0, _XW));
		// get extents of profile
			LineSeg seg = pp.extentInDir(_XW);
			if (seg.ptStart().Z() < dZmin) 
			{
				dZmin = seg.ptStart().Z();
				ptMin = seg.ptStart();
			}
			if (seg.ptEnd().Z() < dZmin)
			{
				dZmin = seg.ptEnd().Z();
				ptMin = seg.ptEnd();
			}
			
			if (seg.ptStart().Z() > dZmax) 
			{
				dZmax = seg.ptStart().Z();
				ptMax = seg.ptStart();
			}
			if (seg.ptEnd().Z() > dZmax)
			{
				dZmax = seg.ptEnd().Z();
				ptMax = seg.ptEnd();
			}
		}//next i
	// tsls
		if (!bByPainter || bIsTslPainter)
		for (int i = 0; i < tsls.length(); i++)
		{ 
			TslInst tsl = tsls[i];
			if (bByPainter && !tsl.acceptObject(painter.filter())){ continue;}
			Body bd = tsl.realBody();
//			String sTslName=tsl.scriptName();
			double dVolBd = bd.volume();
			if(dVolBd<pow(U(1),3))
			{ 
				Quader qd=tsl.bodyExtents();
				// HSB-22914: Check if the quader has volume before creating the body
				if(qd.dX()<U(1) || qd.dY()<U(1) || qd.dZ()<U(1))
				{ 
					continue;
				}
				// HSB-22901
				bd=Body(tsl.bodyExtents());
//				bd.vis(3);
//				dVolBd = bd.volume();
//				visBd(bd,_ZW*U(300));
			}
			CoordSys csCollectionTransform;
			if(nTslsCollection[i]>-1)
			{ 
				csCollectionTransform=csCollections[nTslsCollection[i]];
				bd.transformBy(csCollectionTransform);
			}
			bd.transformBy(ms2ps);
			PlaneProfile pp = bd.shadowProfile(Plane(_Pt0, _XW));
		// get extents of profile
			LineSeg seg = pp.extentInDir(_XW);
			if (seg.ptStart().Z() < dZmin) 
			{
				dZmin = seg.ptStart().Z();
				ptMin = seg.ptStart();
			}
			if (seg.ptEnd().Z() < dZmin)
			{
				dZmin = seg.ptEnd().Z();
				ptMin = seg.ptEnd();
			}
			
			if (seg.ptStart().Z() > dZmax) 
			{
				dZmax = seg.ptStart().Z();
				ptMax = seg.ptStart();
			}
			if (seg.ptEnd().Z() > dZmax)
			{
				dZmax = seg.ptEnd().Z();
				ptMax = seg.ptEnd();
			}
		}//next i
		
//		Point3d ptMin = ptCenVp;
//		ptMin.setZ(dZmin);
//		Point3d ptMax = ptCenVp;
//		ptMax.setZ(dZmax);
		ptMinModel = ptMin;
		ptMaxModel = ptMax;
		ptMinModel.transformBy(ps2ms);
		ptMaxModel.transformBy(ps2ms);
		// vector _ZW in model space
		vecZModel = _ZW;
		vecZModel.transformBy(ps2ms);
		vecZModel.normalize();
		// maximal height in model space of the object 
		dZHeight = (ptMaxModel - ptMinModel).dotProduct(vecZModel);
		// dZmax and dZmin in model space
		dZmin = 0;
		dZmax = dZHeight;
		// check if the limits are out of the boundaries
		// this way nothing will be shown
	}
	if(!bHasSection && abs(ptMin.Z()-10e10)<dEps && abs(ptMax.Z()-(-10e10))<dEps)
	{ 
		if(!bHasSDV)
		{ 
			reportMessage("\n"+scriptName()+" "+T("|Unexpected, no entities found for hatching|"));
			// draw text
			dp.draw("No entities found\Pcheck the painter/filter selection", _Pt0, vecX, vecY, 0, 0, _kDeviceX);
	//		eraseInstance();
			return;
		}
	}
	
//End for element viewports and shopdrawing viewports, get the bottom and top point wrt _ZW//endregion
	
//region HSB-7605: set the level and depth when viewport of a particular elemZone
// set the level and depth when bIsElementViewport
	if(bIsElementViewport)
	{ 
	// trigger to set level and depth to the active zone
	// Trigger SetLvlDepthActiveZone//region
		String sTriggerSetLvlDepthActiveZone = T("|Set Level and Depth to Active Zone|");
		addRecalcTrigger(_kContextRoot, sTriggerSetLvlDepthActiveZone );
		if (_bOnRecalc && _kExecuteKey==sTriggerSetLvlDepthActiveZone)
		{
			// set the level and the depth of the zone
			Point3d ptZoneOrg = el.zone(nActiveZoneIndex).ptOrg();
	//		double dddd = el.zone(nActiveZoneIndex).dH();
			Point3d ptZoneEnd = ptZoneOrg + el.zone(nActiveZoneIndex).vecZ() * el.zone(nActiveZoneIndex).dH();
			Point3d ptLevel = ptZoneOrg;
			Point3d ptDepth = ptZoneEnd;
			if (vecZModel.dotProduct(ptZoneEnd - ptZoneOrg) > 0)
			{
				ptLevel = ptZoneEnd;
				ptDepth = ptZoneOrg;
			}
			dSectionLevel.set(-vecZModel.dotProduct(ptLevel - (ptMaxModel) + dEps * (-vecZModel)));
			dSectionDepth.set(-vecZModel.dotProduct(ptDepth - (ptLevel) - dEps * (-vecZModel)));
			
			setExecutionLoops(2);
			return;
		}//endregion
//		dSectionLevel.setReadOnly(true);
//		dSectionDepth.setReadOnly(true);
	}
//End set the level and depth when viewport of a particular elemZone//endregion 
	
//region get the clip volume from the section
	CoordSys csSection;
	Body bdClip;
	if(bHasSection)
	{
		bdClip = clipVolume.clippingBody();
//		bdClip.vis(4);
		csSection = section.coordSys();
		csSection.transformBy(ps2ms);
		// origin of the coordinate system
//		csSection.ptOrg().vis(8);
//		csSection.vecX().vis(csSection.ptOrg(), 1);
//		csSection.vecY().vis(csSection.ptOrg(), 150);
//		csSection.vecZ().vis(csSection.ptOrg(), 3);
		
		// plane at the dSectionLevel and dSectionDepth
		Point3d ptLevel = csSection.ptOrg() - csSection.vecZ() * dSectionLevel;
		Point3d ptDepth = ptLevel - csSection.vecZ() * dSectionDepth;
		ptLevel.vis(10);
		ptDepth.vis(10);
		Plane pnLevel(ptLevel, csSection.vecZ());
		Plane pnDepth(ptDepth, csSection.vecZ());
		
		// project clipping body to pnLevel
		PlaneProfile ppLevel=bdClip.shadowProfile(pnLevel);
		
		Vector3d vecExtrusion=(ptDepth-ptLevel);
		if (vecExtrusion.length()<dEps)
		{ 
			vecExtrusion=-dEps*csSection.vecZ();
		}
		// polylines of the plane profile
		PLine pl[] = ppLevel.allRings();
		if (pl.length() < 1)return;
		Body bd(pl[0], vecExtrusion);
		bdClip = bd;
//		bdClip.vis(3);
		// group assignment at the element layer
		if(nGroupAssignment==0)
		{
			// by defailt, assign by entity
			assignToGroups(section, 'E');
		}
	}
	else if(!bInBlockSpace)
	{
		_ThisInst.setAllowGripAtPt0(false);
		PlaneProfile ppVp;
		ptCenVp.vis(3);
		ppVp.createRectangle(LineSeg(ptCenVp-.5*(_XW*dXVp+_YW*dYVp),
									ptCenVp+.5*(_XW*dXVp+_YW*dYVp)),_XW,_YW);
	// calculate Height1 and Height2 in paper space
		double dSectionLevelPaper;
		double dSectionDepthPaper;
		{ 
			// top point
			Point3d pt1=ptMaxModel-vecZModel*dSectionLevel;
			// bottom point
			Point3d pt2=pt1-vecZModel*dSectionDepth;
			if (dSectionDepth < dEps)
			{ 
				pt2 = pt1 - vecZModel * 1*dEps;
			}
			// in paper space
			pt1.transformBy(ms2ps);
			pt2.transformBy(ms2ps);
			dSectionLevelPaper = (pt1 - _Pt0).dotProduct(_ZW);
			dSectionDepthPaper = (pt2 - pt1).dotProduct(_ZW);
		}
		if(dSectionLevel<dEps && dSectionDepth<dEps)
		{ 
			Point3d pt1=ptMaxModel;
			Point3d pt2=ptMinModel;
			pt1.transformBy(ms2ps);
			pt2.transformBy(ms2ps);
			dSectionLevelPaper = (pt1-_Pt0).dotProduct(_ZW);
			dSectionDepthPaper = (pt2-pt1).dotProduct(_ZW);
//			dSectionDepthPaper*=3;
		}
		// move the plane profile to the dSectionLevel
		ppVp.transformBy(dSectionLevelPaper * _ZW);
//		ppVp.transformBy((U(10)) * _ZW);
		// extrusion vector with dSectionDepth
		Vector3d vecExtrusion = (dSectionDepthPaper) * _ZW;
		PLine pl[] = ppVp.allRings();
		if (pl.length() < 1)return;
		//
		Body bd(pl[0], vecExtrusion);
		bdClip = bd;
		bdClip.vis(2);
	}
//	ptCenVp.vis(2);
//End get the clip volume from the section//endregion
	
//region data needed for later, to avoid calculation inside the loop
	// for section
	Vector3d vecNormal;
	Plane pn0;
	Plane pn1;
	PlaneProfile ppBdClipShadow;
	// top point in the model
	Point3d pt1;
	// bottom point in the model
	Point3d pt2;
	if(bHasSection)
	{ 
		if(nMode==1 || !tslLevelDepth.bIsValid() )
		{ 
			Plane pnXY(csSection.ptOrg(), csSection.vecZ());
			PlaneProfile ppClivVolume = bdClip.shadowProfile(pnXY);
			
			LineSeg seg = ppClivVolume.extentInDir(csSection.vecX());
			double dLength = abs(csSection.vecX().dotProduct(seg.ptStart() - seg.ptEnd()));
			if (_PtG.length() == 0)
			{ 
				// initially the grip points will be placed at the properties dSectionLevel and dSectionDepth
				_PtG.append(csSection.ptOrg() - dSectionLevel * csSection.vecZ() + (.5 * dLength - U(150)) * csSection.vecX());
				_PtG.append(_PtG[0] - dSectionDepth * csSection.vecZ()
								 + U(300) * csSection.vecX());
			}
			
			vecNormal = csSection.vecZ();
			pn0 = Plane (_PtG[0], vecNormal);
			pn1 = Plane (_PtG[1], vecNormal);
			ppBdClipShadow = bdClip.shadowProfile(pn0);
			pt1 = _PtG[0];
			pt2 = _PtG[1];
		}
		else if(tslLevelDepth.bIsValid())
		{ 
			vecNormal = csSection.vecZ();
			
			pt1=tslLevelDepth.gripPoint(0);
			pt2=tslLevelDepth.gripPoint(1);
			
			pn0 = Plane (pt1, vecNormal);
			pn1 = Plane (pt2, vecNormal);
			ppBdClipShadow = bdClip.shadowProfile(pn0);
			
			_PtG.setLength(0);
			if(abs(tslLevelDepth.propDouble(0)-dSectionLevel)>dEps)
			{ 
				dSectionLevel.set(tslLevelDepth.propDouble(0));
			}
			if(abs(tslLevelDepth.propDouble(1)-dSectionDepth)>dEps)
			{ 
				dSectionDepth.set(tslLevelDepth.propDouble(1));
			}
		}
	}
	else if(!bHasSDV)
	{ 
		
		pt1 = ptMaxModel - vecZModel * dSectionLevel;
		pt2 = pt1 - vecZModel * dSectionDepth;
		if (dSectionDepth < dEps)
		{ 
			pt2 = pt1 - vecZModel * dEps;
		}
		pt1.transformBy(ms2ps);
		pt2.transformBy(ms2ps);
		pn0 = Plane (pt1, _ZW);
		pn1 = Plane (pt2, _ZW);
		ppBdClipShadow = bdClip.shadowProfile(pn0);
		vecNormal = _ZW;
	}
	// for layout viewport
	
//End data needed for later, to avoid calculation inside the loop//endregion 
	
//region add grip points for section2d and clipvolume
// the 2 grip points will control the dSectionLevel and dSectionDepth
// for the representation of the hatching
	if (bHasSection)
	{ 
		// no grip points, initialize
//		CoordSys csSection = section.coordSys();
//		csSection.transformBy(ps2ms);
		// boundaries of the clipVolume
//		Plane pnXY(csSection.ptOrg(), csSection.vecZ());
//		PlaneProfile ppClivVolume = bdClip.shadowProfile(pnXY);
//	// get extents of profile
//		LineSeg seg = ppClivVolume.extentInDir(csSection.vecX());
//		double dLength = abs(csSection.vecX().dotProduct(seg.ptStart() - seg.ptEnd()));
//		
//		if (_PtG.length() == 0)
//		{ 
//			// initially the grip points will be placed at the properties dSectionLevel and dSectionDepth
//			_PtG.append(csSection.ptOrg() - dSectionLevel * csSection.vecZ() + (.5 * dLength - U(150)) * csSection.vecX());
//			_PtG.append(_PtG[0] - dSectionDepth * csSection.vecZ()
//							 + U(300) * csSection.vecX());
//		}
		if(nMode==1)
		{ 
			if ((_kNameLastChangedProp == sSectionLevelName) || (_kNameLastChangedProp == sSectionDepthName))
			{ 
				// guard against negative SectionDepth values
				if (dSectionDepth < 0)
				{ 
					// set it back to 0
					dSectionDepth.set(0.0);
				}
				// property is modified, fix the grip points
				_PtG[0]=_PtG[0]-((_PtG[0]-csSection.ptOrg()).dotProduct(csSection.vecZ()))*csSection.vecZ()
								-dSectionLevel*csSection.vecZ();
				_PtG[0]=_PtG[0]-((_PtG[0]-csSection.ptOrg()).dotProduct(csSection.vecY()))*csSection.vecY()
								+dSectionLevel*csSection.vecY();
				_PtG[1]=_PtG[1]-((_PtG[1]-_PtG[0]).dotProduct(csSection.vecZ()))*csSection.vecZ() 
								-dSectionDepth*csSection.vecZ();
			// project ptg1 to the diagonal plane
				Vector3d vecDiagonal=csSection.vecY()+csSection.vecZ();vecDiagonal.normalize();
				Plane pnDiagonal(_PtG[0],vecDiagonal);
				Line(_PtG[1],csSection.vecY()).hasIntersection(pnDiagonal,_PtG[1]);
				
				_Map.setPoint3d("PtG0",_PtG[0],_kAbsolute);
				_Map.setPoint3d("PtG1",_PtG[1],_kAbsolute);
				// trigger realculation
				setExecutionLoops(2);
			}
			
			if ((_kNameLastChangedProp == "_PtG0") || (_kNameLastChangedProp == "_PtG1"))
			{ 
				// don't allow both grip points at the same location
				if ((_PtG[1]-_PtG[0]).length() < dEps)
				{ 
				// place _PtG[1] with a distance from _PtG[0]
					_PtG[1]=_PtG[0]+U(300)*csSection.vecX();
				}
				if (_kNameLastChangedProp == "_PtG0")
				{ 
				// project ptg1 to diagonal plane
					Vector3d vecDiagonal=csSection.vecY()+csSection.vecZ();vecDiagonal.normalize();
					Plane pnDiagonal(_PtG[1],vecDiagonal);
					Line(_PtG[0],csSection.vecZ()).hasIntersection(pnDiagonal,_PtG[0]);
				}
				else if(_kNameLastChangedProp == "_PtG1")
				{ 
				// project ptg0 to diagonal plane
					Vector3d vecDiagonal=csSection.vecY()+csSection.vecZ();vecDiagonal.normalize();
					Plane pnDiagonal(_PtG[0],vecDiagonal);
					Line(_PtG[1],csSection.vecZ()).hasIntersection(pnDiagonal,_PtG[1]);
				}
				
				// calculate from _PtG[0] and _PtG[1] the dSectionLevel and dSectionDepth
				// as dSectionLevel should serve the one that has dSectionDepth positive
				Point3d ptLev = _PtG[0];
				Point3d ptDepth = _PtG[1];
				
				if ((_PtG[1]-_PtG[0]).dotProduct(-csSection.vecZ()) < 0)
				{ 
					ptLev=_PtG[1];
					ptDepth=_PtG[0];
				}
				
				dSectionLevel.set((ptLev - csSection.ptOrg()).dotProduct(-csSection.vecZ()));
				dSectionDepth.set((ptDepth - ptLev).dotProduct(-csSection.vecZ()));
				_Map.setPoint3d("PtG0",_PtG[0],_kAbsolute);
				_Map.setPoint3d("PtG1",_PtG[1],_kAbsolute);
				// trigger recalculation
				setExecutionLoops(2);
			}
			if (_kNameLastChangedProp == sAllowEntitiesXrefName) 
			{ 
				Entity entSectionHatch=_Map.getEntity("entSectionHatch");
				TslInst tslSectionHatch=(TslInst)entSectionHatch;
				tslSectionHatch.setPropString(3,sAllowEntitiesXref);
			}
			Display dpg0(6),dpg1(4);
			if ((_PtG[1]-_PtG[0]).dotProduct(-csSection.vecZ()) < 0)
			{ 
				dpg0.color(4);
				dpg1.color(6);
			}
	//		clipVolume.clippingBody().vis(1);
			// display lines where the boundaries are located
			double dClipVolumeA=clipVolume.lengthA();
			double dClipVolumeB=clipVolume.lengthB();
			double dClipVolumeHeight=clipVolume.height();
	//		clipVolume.setLengthA(U(5200));
			// draw lines only if there is a depth
			if (abs(dSectionDepth) > dEps || 1)
			{ 
				LineSeg lSeg(_PtG[0],_PtG[0]+(_PtG[1]-_PtG[0]).dotProduct(csSection.vecX())*csSection.vecX());
				LineSeg lSeg2(_PtG[1],_PtG[1]+(_PtG[0]-_PtG[1]).dotProduct(csSection.vecX())*csSection.vecX());
	//			Display dpCut(7);
	
				// get all the groups to which section is assigned to
				Group groups[]=section.groups();
				if (groups.length() > 0)
				{
					String sLayer=section.layerName();
					String sLayerTooling=sLayer;
					String sRight=sLayerTooling.right(3);
					// remove the last 3 characters C0~
					sLayerTooling.trimRight(sRight);
					// change the last 3 characters to T0~
					sLayerTooling+="T0~";
	//				dpCut.layer(sLayerTooling);
					dpg0.layer(sLayerTooling);
					dpg1.layer(sLayerTooling);
				}
				dpg0.draw(lSeg);
				PLine plCirc;
				plCirc.createCircle(_PtG[0],csSection.vecZ(),U(20));
				PlaneProfile ppCirc(Plane(_PtG[0],csSection.vecZ()));
				ppCirc.joinRing(plCirc,_kAdd);
				
				dpg0.draw(ppCirc);
				dpg0.draw(ppCirc,_kDrawFilled,30);
				ppCirc.transformBy(_PtG[1]-_PtG[0]);
				dpg1.draw(lSeg2);
				dpg1.draw(ppCirc);
				dpg1.draw(ppCirc,_kDrawFilled,30);
			}
		}
	}
	
	if(!_Map.hasPoint3d("PtG0"))
	{ 
		if(_PtG.length()>0)
		{
			_Map.setPoint3d("PtG0",_PtG[0],_kAbsolute);
		}
	}
	if(!_Map.hasPoint3d("PtG1"))
	{ 
		if(_PtG.length()>1)
		{
			_Map.setPoint3d("PtG1",_PtG[1],_kAbsolute);
		}
	}
	
//End add grip points for section2d and clipvolume//endregion 
	if(nMode==1)
	{ 
		// section line and depth mode
		
		return;
	}
	
//region get from mapSetting all maps of materials
	Map mapHatches=mapSetting.getMap("Hatch[]");
	if (mapHatches.length() < 1)
	{ 
		reportMessage("\n"+scriptName()+" "+T("|wrong definition of the maps for hatches 1002|"));
		eraseInstance();
		return;
	}
	
// HSB-20184: make sure all painter group hatches are there
	// get all groups from all entities
	String sPainterGroups[0];
	if(bPainterGroup)
	{ 
		
		for (int i=0;i<ents.length();i++) 
		{ 
			String sFormatI=ents[i].formatObject(sPainterFormat);
			if(sPainterGroups.findNoCase(sFormatI,-1)<0)
				sPainterGroups.append(sFormatI);
			
		}//next i
	}
	
// first hatch will serve as a default hatch
//	Map mapHatchDefault = mapHatches.getMap(0);
	// by material and by painter
	Map mapHatchDefault,mapHatchDefaultPainter;
	int bMapHatchDefaultFound = false;
	int bMapHatchDefaultPainterFound = false;
	// HSB-20184: if any of the groups has no hatch definition
	int bMapPainterGroupsFoundAll=true;
	int nHatchDefaultIndex = -1;// index for by material
	int nHatchDefaultPainterIndex = -1;// index for by painter
	for (int i = 0; i < mapHatches.length(); i++)
	{ 
		Map mapHatchI = mapHatches.getMap(i);
		if (mapHatchI.hasString("Name") && mapHatches.keyAt(i).makeLower() == "hatch")
		{
			// HSB-7706
			if (!mapHatchI.getInt("isActive"))continue;
			
//			if(nHatchMapping==0)
			{ 
			// by material is selected as mapper
				Map mapMaterials = mapHatchI.getMap("Material[]");
//				if (mapMaterials.length() < 1)
//				{
//					// no orientation map defined for this material 
//					reportMessage("\n"+scriptName()+" "+T("|no map of materials found for the material of the beam|"));
//					eraseInstance();
//					return;
//				}
				if(mapMaterials.length()>0)
				{ 
					// find if the material is included in this hatch definition
					for (int j = 0; j < mapMaterials.length(); j++)
					{
						Map mapMaterialJ = mapMaterials.getMap(j);
						if (mapMaterialJ.hasString("Name") && mapMaterials.keyAt(j).makeLower() == "material")
						{
							String sMaterialMap = mapMaterialJ.getString("Name");
							if (sMaterialMap == "*")
							{ 
							// material found
								bMapHatchDefaultFound = true;
								mapHatchDefault = mapHatchI;
								nHatchDefaultIndex = i;
								// break "j" loop for materials
								break;
							}
						}
					}//next l
				}
			}
//			else if(nHatchMapping==1)
			if(nHatchMapping==1)
			{ 
			// by Painter
				if (!mapHatchI.hasString("Painter"))continue;
				String sPainterMap=mapHatchI.getString("Painter");
				if(sPainterMap==sRule)
				{ 
				// material found
					bMapHatchDefaultPainterFound = true;
					mapHatchDefaultPainter = mapHatchI;
					nHatchDefaultPainterIndex = i;
				}
			}
			
			if (bMapHatchDefaultFound && nHatchMapping==0)
			{ 
				// default hatch found, breake "i" loop
				break;;
			}
			if (bMapHatchDefaultFound && (nHatchMapping==1 && bMapHatchDefaultPainterFound))
			{ 
				// default hatch found, breake "i" loop
				break;;
			}
		}
	}//next i
	
	
	String sPainterGroupsMissing[0];
	sPainterGroupsMissing.append(sPainterGroups);
	if(bPainterGroup)
	for (int i = 0; i < mapHatches.length(); i++)
	{
		Map mapHatchI = mapHatches.getMap(i);
		if (mapHatchI.hasString("Name") && mapHatches.keyAt(i).makeLower() == "hatch")
		{
			// HSB-7706
			if ( ! mapHatchI.getInt("isActive"))continue;
			if (!mapHatchI.hasString("Painter"))continue;
			String sPainterMap=mapHatchI.getString("Painter");
			if (sPainterMap != sRule)
			{
				// HSB-21945
				continue;
			}
			if ( ! mapHatchI.hasString("PainterGroup"))continue;
			String sPainterGroupMap = mapHatchI.getString("PainterGroup");
			int nIndex = sPainterGroupsMissing.findNoCase(sPainterGroupMap ,- 1);
			if (nIndex >- 1)
			{
				sPainterGroupsMissing.removeAt(nIndex);
			}
		}
	}
	if(sPainterGroupsMissing.length()>0)
		bMapPainterGroupsFoundAll=false;
////	if(nHatchMapping==1 && bMapHatchDefaultFound==1 && bMapHatchDefaultPainterFound==0)
	if(nHatchMapping==1 && bMapHatchDefaultFound==1 
	&& (bMapHatchDefaultPainterFound==0 || bMapPainterGroupsFoundAll==0))
	{ 
	// no hatch found for the painter
	// get the default and insert it in the mapio
		Map mapHatchesNew=mapHatches;
		mapHatchesNew.setMapKey("Hatch[]");
		
		if(!bMapHatchDefaultPainterFound)
		{ 
		// Hatch for the painter
		
			Map _mapHatchDefaultPainter=mapHatchDefault;
			_mapHatchDefaultPainter.setString("Painter",sRule);
			_mapHatchDefaultPainter.setString("Name","Hatch-"+sRule);
			mapHatchesNew.appendMap("Hatch", _mapHatchDefaultPainter);
		}
		if(bPainterGroup && !bMapPainterGroupsFoundAll)
		{ 
			// HSB-20184: initialize Hatch for painter groups
			for (int im=0;im<sPainterGroupsMissing.length();im++) 
			{ 
				Map _mapHatchDefaultPainter=mapHatchDefault;
				_mapHatchDefaultPainter.setString("PainterGroup",sPainterGroupsMissing[im]);
				_mapHatchDefaultPainter.setString("Name","Hatch-"+sPainterGroupsMissing[im]);
				mapHatchesNew.appendMap("Hatch", _mapHatchDefaultPainter);
			}//next im
		}
		Map mapSettingNew=mapSetting;
		mapSettingNew.setMapKey("root");
		mapSettingNew.setMap("Hatch[]", mapHatchesNew);
		if(mo.bIsValid())
			mo.setMap(mapSettingNew);
		else 
			mo.dbCreate(mapSettingNew);
	// 
		setExecutionLoops(2);
		return;
	}
//End get from mapSetting all maps of materials//endregion  
	
	Map mapHatchesAllUsed;
	Map _mapEntitiesUsed=_Map.getMap("mapEntitiesUsed");
	Map mapEntitiesUsedPp;
	// calc planeprofile of all entities
	PlaneProfile ppAll(Plane(_Pt0,_ZW));
	Body bdAll;
	Display dpTxt(5);
//		dpTxt.textHeight(dHview*.01);
	String sHatchKeys[]={"hatch0","hatch1","hatch2","hatch3","hatch4"};
	String sOrientationKeys[]={"orientation0","orientation1","orientation2","orientation3","orientation4"};
	dpTxt.textHeight(U(100));
	double dTextLengthMax, dTextHeightMax;
	{ 
		// contains in addition the planeprofiles
		for (int im=0;im<_mapEntitiesUsed.length();im++) 
		{ 
			Map mapI=_mapEntitiesUsed.getMap(im);
			Entity entI=mapI.getEntity("ent");
			
			Body bdI;
			if(!mapI.hasBody("bdComp"))
			{
				bdI=entI.realBody();
			}
			else if(mapI.hasBody("bdComp"))
			{ 
				bdI=mapI.getBody("bdComp");
			}
			if(mapI.hasPoint3d("ptOrgTransform"))
			{ 
				CoordSys csCollectionTransform(mapI.getPoint3d("ptOrgTransform"),
				mapI.getVector3d("vecXTransform"),mapI.getVector3d("vecYTransform"),mapI.getVector3d("vecZTransform"));
				bdI.transformBy(csCollectionTransform);
			}
			
			bdI.transformBy(ms2ps);
			bdAll.addPart(bdI);
			PlaneProfile ppI=bdI.shadowProfile(Plane(_Pt0,_ZW));
			mapI.setPlaneProfile("pp",ppI);
			// HSB-22263: save the transformed body and use the cube envelope body
			Body bdIEnv=calcEnvBody(bdI);
//			mapI.setBody("bdTransformed",bdI);
			mapI.setBody("bdTransformed",bdIEnv);
			ppI.vis(1);
			mapEntitiesUsedPp.appendMap("mapEntity",mapI);
			ppI.shrink(-U(10));
			ppAll.unionWith(ppI);
			for (int ii=0;ii<sHatchKeys.length();ii++) 
			{ 
				if(!mapI.hasInt(sHatchKeys[ii]))
				{ 
				// next entity	
					break;
				}
				int nIndexH=mapI.getInt(sHatchKeys[ii]);
				Map mapHatchI=mapHatches.getMap(nIndexH);
				String sOrientationI=mapI.getString(sOrientationKeys[ii]);
				String sHatchName=nIndexH+"-"+mapHatchI.getString("Name")+"-"+sOrientationI;
				
				if(mapHatchesAllUsed.hasMap(sHatchName))
				{ 
					Map mapExist=mapHatchesAllUsed.getMap(sHatchName);
					Entity entsExist[] =mapExist.getEntityArray("ents","ents","ents");
					// dont do this text bc for 2 different panel layers it is the same entity
//					if(entsExist.find(entI)<0)
//						entsExist.append(entI);
//					else
//						continue;
					
					mapExist.setEntityArray(entsExist,true,"ents","ents","ents");
					
					String sIndexEnt="ent"+im;
					Map mapIndicesExis=mapExist.getMap("mapIndices");
					if(!mapIndicesExis.hasMap(sIndexEnt))
					{ 
						Map mapIndex;mapIndex.setInt("index",im);
						mapIndicesExis.appendMap(sIndexEnt,mapIndex);
						
						mapExist.setMap("mapIndices",mapIndicesExis);
					}
					
	//				if(!mapExist.hasInt(sIndexEnt))
	//					mapExist.setInt(sIndexEnt,im);
					
					mapHatchesAllUsed.setMap(sHatchName,mapExist);
					double dTextLengthI=dpTxt.textLengthForStyle(sHatchName,_DimStyles[0],U(100));
					double dTextHeightI=dpTxt.textHeightForStyle(sHatchName,_DimStyles[0],U(100));
					if(dTextLengthI>dTextLengthMax)
					{
						dTextLengthMax=dTextLengthI;
						dTextHeightMax=dTextHeightI;
					}
				}
				else
				{ 
					Map mapNew;
					Entity entsNew[] ={entI};
					mapNew.setEntityArray(entsNew,true,"ents","ents","ents");
					String sIndexEnt="ent"+im;
					
					Map mapIndices;
					Map mapIndex;mapIndex.setInt("index",im);
					mapIndices.appendMap(sIndexEnt,mapIndex);
					
					mapNew.setInt("indexHatch",nIndexH);
					
	//				if(!mapNew.hasInt(sIndexEnt))
	//					mapNew.setInt(sIndexEnt,im);
	//				mapNew.setInt("index",nIndexH); // hatch index
					
					mapNew.setMap("mapIndices",mapIndices);
				// check if name contains \ this is problem for map.
				// it will be interpreted as a submap
					{ 
						String sTokens[]=sHatchName.tokenize("\\");
						String sHatchNameNew=sTokens[0];
						if(sTokens.length()>1)
						for (int itoken=0;itoken<sTokens.length()-1;itoken++) 
						{ 
							sHatchNameNew+="/"+sTokens[itoken+1];
						}//next itoken
						sHatchName=sHatchNameNew;
					}
					mapHatchesAllUsed.setMap(sHatchName,mapNew);
					double dTextLengthI=dpTxt.textLengthForStyle(sHatchName,_DimStyles[0],U(100));
					double dTextHeightI=dpTxt.textHeightForStyle(sHatchName,_DimStyles[0],U(100));
					if(dTextLengthI>dTextLengthMax)
					{	
						dTextLengthMax=dTextLengthI;
						dTextHeightMax=dTextHeightI;
					}
				}
			}//next ii
		}//next im
	}
	
//	bdAll.vis(6);
	// create a cube envelope 
	Body bdAllQuader=calcEnvBody(bdAll);
//	bdAllQuader.vis(4);
//region HSB-11492 triggers to control hatch
//region Trigger HatchModify
	String sTriggerHatchModify = T("|Modify Hatch|");
	addRecalcTrigger(_kContextRoot, sTriggerHatchModify );
	String sTriggerHatchAdd = T("|Add Hatch|");
	addRecalcTrigger(_kContextRoot, sTriggerHatchAdd );
	if (_bOnRecalc && 
		(_kExecuteKey==sTriggerHatchModify || _kExecuteKey==sTriggerHatchAdd))
	{
		int bModify = (_kExecuteKey == sTriggerHatchModify);
		int bAdd = (_kExecuteKey == sTriggerHatchAdd);
		Entity entSelect;
	// select entity
		int nMapSelected = false;
		Map mapHatchesSelected;
		Map mapHatchSelected;
		String sOrientation="X";
		String sOrientations[0];
		int nHatchesSelectedIndex[0];
		int nHatchSelectedIndex = -1;
		if(mapHatchesAllUsed.length()>1)
		{ 
			String sStringStart = "|Select hatch or Entity|";
			String sStringPrompt = T(sStringStart);
			
			PrPoint ssP(sStringPrompt); 
			Map mapArgs;
			int nGoJig = -1;
			
		// maps of hatches and entities
			mapArgs.setMap("mapHatchesAllUsed",mapHatchesAllUsed);
			mapArgs.setMap("mapEntitiesUsedPp",mapEntitiesUsedPp);
			mapArgs.setMap("mapHatches",mapHatches);
			
			mapArgs.setPlaneProfile("ppAll", ppAll);
//			mapArgs.setBody("bdAll", bdAll);
			mapArgs.setBody("bdAll", bdAllQuader);
			
		// save ms2ps
			mapArgs.setPoint3d("ms2psPtOrg",ms2ps.ptOrg());
			mapArgs.setVector3d("ms2psVecX",ms2ps.vecX());
			mapArgs.setVector3d("ms2psVecY",ms2ps.vecY());
			mapArgs.setVector3d("ms2psVecZ",ms2ps.vecZ());
			
			// materials list graphically
			PlaneProfile ppStart, ppEnd, ppBetween;
			Vector3d vecXgraph;
			Vector3d vecYgraph;
			Vector3d vecZgraph;
			Point3d ptStartGraph;
			double dXtable;
			double dYtable;
			Map mapPropsGraph;
			{ 
				vecXgraph=_XW;
				vecYgraph=_YW;
				vecZgraph=_ZW;
//				ptStartGraph = bdAll.ptCen();
				ptStartGraph = bdAllQuader.ptCen();
				
				Map mapPropsCoord;
				mapPropsCoord.setPoint3d("ptStartGraph",ptStartGraph,_kAbsolute);
				mapPropsCoord.setVector3d("vecXgraph",vecXgraph,_kAbsolute);
				mapPropsCoord.setVector3d("vecYgraph",vecYgraph,_kAbsolute);
				mapPropsCoord.setVector3d("vecZgraph",vecZgraph,_kAbsolute);
				
//				double dLengthBox=U(100);
				double dLengthBox = .4*(dTextLengthMax+dTextHeightMax);
//				dLengthBox = dTextLengthMax*+(U(44)-dTextHeightMax);
//				double dWidthBox=U(44);
				double dWidthBox=.4*(dTextHeightMax*2);
				double dGapBox=U(20);
				Point3d pt=ptStartGraph;
				
				PlaneProfile ppBox(Plane(ptStartGraph,vecZgraph));
				{ 
					PLine pl;
					pl.createRectangle(LineSeg(pt, 
						pt+vecXgraph*dLengthBox-vecYgraph*dWidthBox),vecXgraph,vecYgraph);
					ppBox.joinRing(pl,_kAdd);
				}
				PlaneProfile ppTable(Plane(ptStartGraph,vecZgraph));
				for (int im=0;im<mapHatchesAllUsed.length();im++) 
				{ 
					Map mapHi=mapHatchesAllUsed.getMap(im);
					String sHatchName=mapHatchesAllUsed.keyAt(im);
					PlaneProfile pp=ppBox;
					pp.transformBy(pt-ptStartGraph);
					ppTable.unionWith(pp);
					
					PlaneProfile ppFrame = pp;
					ppFrame.shrink(-U(5));
					ppFrame.subtractProfile(pp);
					Map mapGraphI;
					mapGraphI.setPlaneProfile("pp", pp);
					mapGraphI.setPlaneProfile("ppFrame", ppFrame);
					mapGraphI.setString("txt", sHatchName);
					Point3d ptTxtProp = pt+.5*dLengthBox*vecXgraph-.5*dWidthBox*vecYgraph;
					mapGraphI.setPoint3d("ptTxtProp",ptTxtProp,_kAbsolute);
					
					pt+=-vecYgraph*(dWidthBox+dGapBox);
					
					mapPropsGraph.appendMap("mapProp", mapGraphI);
				}//next im
				ppTable.shrink(-2*dGapBox);
				ppTable.shrink(2*dGapBox);
				mapArgs.setPlaneProfile("ppTable",ppTable);
				
				// get extents of profile
				LineSeg segTable = ppTable.extentInDir(vecXgraph);
				dXtable = abs(vecXgraph.dotProduct(segTable.ptStart()-segTable.ptEnd()));
				dYtable = abs(vecYgraph.dotProduct(segTable.ptStart()-segTable.ptEnd()));
				mapArgs.setPoint3d("ptTable",ppTable.ptMid(),_kAbsolute);
				mapArgs.setDouble("dXtable",dXtable);
				mapArgs.setDouble("dYtable",dYtable);
				
				mapArgs.setMap("mapProps",mapPropsGraph);
				mapArgs.setMap("mapPropsCoord",mapPropsCoord);
			}
			
			
			sOrientation="X";
			
			nMapSelected = false;
			dXtable=dXtable*dViewScale;
			dYtable=dYtable*dViewScale;
			while (nGoJig != _kNone)
			{
				nGoJig = ssP.goJig(kJigModifyAdd, mapArgs);
				if (nGoJig == _kOk)
				{ 
				// update the globals
					dHview = getViewHeight();
					dViewScale=.0006*dHview;
					vecXview = getViewDirection(0);
					vecYview = getViewDirection(1);
					vecZview = getViewDirection(2);
					vecXview.normalize();
					vecYview.normalize();
					vecZview.normalize();
					ptViewCenter = getViewCenter();
					dMarginEnt=4*dViewScale;
					dTableSpace=U(20)*dHview*0.001;
				// point is clicked
					Display dpp(252);
					Display dpHighlight(3);
					Display dpTxt(5);
					Point3d ptStartGraphView = ptStartGraph;
					Point3d ptJig=ssP.value();
					{
						PlaneProfile ppGb=bdAll.shadowProfile(Plane(ptStartGraph,vecZview));
						ppGb.shrink(-dTableSpace);
						// get extents of profile
						LineSeg seg = ppGb.extentInDir(vecXview);
						ptStartGraphView = seg.ptEnd();
						
						if(abs(vecXview.dotProduct(seg.ptStart()-ptViewCenter))<
							abs(vecXview.dotProduct(seg.ptEnd()-ptViewCenter)))
						{ 
							ptStartGraphView=seg.ptStart()-vecXview*dXtable;
						}
						ptStartGraphView+=vecYview*vecYview.dotProduct(ptViewCenter-ptStartGraphView);
						ptStartGraphView+=.5*vecYview*dYtable;
					}
					dpTxt.textHeight(dHview*.02);
	//				dpp.textHeight(dHview*.01);
				// transform to the jig view
					CoordSys csGraphTransform;
					csGraphTransform.setToAlignCoordSys(ptStartGraph,vecXgraph,vecYgraph,vecZgraph,
							ptStartGraphView,vecXview*dViewScale,vecYview*dViewScale,vecZview*dViewScale);
					
					int nMatSelected=-1;
					String sMatSelected;
					for (int i = 0; i < mapPropsGraph.length(); i++)
					{
						Map mapI = mapPropsGraph.getMap(i);
						PlaneProfile ppProp = mapI.getPlaneProfile("pp");
						ppProp.transformBy(csGraphTransform);
						dpp.color(252);
						dpp.draw(ppProp, _kDrawFilled);
						if(ppProp.pointInProfile(ptJig)==_kPointInProfile)
						{
							dpHighlight.draw(ppProp, _kDrawFilled, 60);
							nMatSelected=i;
							sMatSelected=mapI.getString("txt");
						}
						
						String sTxtProp = mapI.getString("txt");
						Point3d ptTxtProp = mapI.getPoint3d("ptTxtProp");
						ptTxtProp.transformBy(csGraphTransform);
						dpTxt.draw(sTxtProp, ptTxtProp, vecXview, vecYview, 0, 0);
					}
					
					if(nMatSelected>-1)
					{ 
						Map mapSelected=mapHatchesAllUsed.getMap(sMatSelected);
						String ss[]=sMatSelected.tokenize('-');
	//					for (int ii=0;ii<ss.length();ii++) 
						{ 
							nHatchSelectedIndex=mapSelected.getInt("indexHatch");
							nHatchesSelectedIndex.append(nHatchSelectedIndex);
							mapHatchSelected=mapHatches.getMap(nHatchSelectedIndex);
							mapHatchesSelected.appendMap(nHatchSelectedIndex,mapHatchSelected);
							
							if(ss.length()==3)sOrientation=ss[2];
							sOrientations.append(sOrientation);
							nMapSelected=true;
							nGoJig=_kNone;
						}//next ii
					}
					else if(nMatSelected<0)
					{ 
						// see if entity is selected
						int nEntsSelected[0];
						for (int i=0;i<mapEntitiesUsedPp.length();i++) 
						{ 
							Map mapEnt=mapEntitiesUsedPp.getMap(i);
							Entity entI=mapEnt.getEntity("ent");
							Body bdI = entI.realBody();
							if(mapEnt.hasPoint3d("ptOrgTransform"))
							{ 
								CoordSys csCollectionTransform(mapEnt.getPoint3d("ptOrgTransform"),
								mapEnt.getVector3d("vecXTransform"),mapEnt.getVector3d("vecYTransform"),mapEnt.getVector3d("vecZTransform"));
								bdI.transformBy(csCollectionTransform);
							}
							bdI.transformBy(ms2ps);
							
							PlaneProfile ppI=bdI.shadowProfile(Plane(ptStartGraphView,vecZview));
							if(ppI.pointInProfile(ptJig)==_kPointInProfile)
							{ 
								nEntsSelected.append(i);
	//							dpJig.color(2);
	//							dpJig.draw(bdI);
	//							PlaneProfile ppBdI=bdI.shadowProfile(Plane(ptStartGraphView,vecZgraph));
	//							dpJig.draw(ppBdI,_kDrawFilled,30);
							}
						}//next i
						
						if(nEntsSelected.length()>0)
						{
							String sHatchesAll[0];
							for (int ient=0;ient<nEntsSelected.length();ient++) 
							{ 
								int nEntSelected= nEntsSelected[ient];
							// Entity is selected
								String sHatches[0];
								Map mapEnt=mapEntitiesUsedPp.getMap(nEntSelected);
								String sHatchKeys[]={"hatch0","hatch1","hatch2","hatch3","hatch4"};
								String sOrientationKeys[]={"orientation0","orientation1","orientation2","orientation3","orientation4"};
								for (int ii=0;ii<sHatchKeys.length();ii++) 
								{
									if(mapEnt.hasInt(sHatchKeys[ii]))//1,2,3,4
									{
										int nIndexH=mapEnt.getInt(sHatchKeys[ii]);
										Map mapHatchI=mapHatches.getMap(nIndexH);
										
										String sOrientationI=mapEnt.getString(sOrientationKeys[ii]);
										
										String sHatchName=nIndexH+"-"+mapHatchI.getString("Name")+"-"+sOrientationI;
										if(mapHatchesAllUsed.hasMap(sHatchName))
										{ 
											if(sHatchesAll.findNoCase(sHatchName,-1)<0)
											{ 
	//											Map mapSelected=mapHatchesAllUsed.getMap(sHatchName);
												mapHatchesSelected.appendMap(nIndexH,mapHatchI);
												nHatchesSelectedIndex.append(nIndexH);
												sOrientations.append(sOrientationI);
												sHatchesAll.append(sHatchName);
												sHatches.append(sHatchName);
												nGoJig=_kNone;
											}
											
										}
									}
								}
	//							if(sHatches.length()>0)
	//							{ 
	//								for (int i=0;i<sHatches.length();i++) 
	//								{ 
	//									int nIndex=mapHatchesAllUsed.indexAt(sHatches[i]);
	//									Map mapI = mapPropsGraph.getMap(nIndex);
	//									PlaneProfile ppProp = mapI.getPlaneProfile("pp");
	//									ppProp.transformBy(csGraphTransform);
	//									dpp.color(252);
	//									dpp.draw(ppProp, _kDrawFilled);
	//									dpHighlight.draw(ppProp, _kDrawFilled, 60);
	//									sMatSelected=mapI.getString("txt");
	//										
	//									String sTxtProp = mapI.getString("txt");
	//									Point3d ptTxtProp = mapI.getPoint3d("ptTxtProp");
	//									ptTxtProp.transformBy(csGraphTransform);
	//									
	//									dpTxt.draw(sTxtProp, ptTxtProp, vecXview, vecYview, 0, 0);
	//									 
	//								}//next i
	//							}
							}//next ient
						}
	//					reportMessage("\n"+scriptName()+" "+T("|Please select a material from the table of materials|"));
					}
				}
				else if(nGoJig==_kNone)
				{ 
					nGoJig=_kNone;
				}
				else if(nGoJig==_kCancel)
				{ 
					nGoJig=_kNone;
				}
			}
		}
		else if(mapHatchesAllUsed.length()==1)
		{ 
		// only one hatch no need to pick
			Map mapSelected=mapHatchesAllUsed.getMap(0);
			String sMatSelected = mapHatchesAllUsed.keyAt(0);
			String ss[]=sMatSelected.tokenize('-');
			
			nHatchSelectedIndex=mapSelected.getInt("indexHatch");
			
			nHatchesSelectedIndex.append(nHatchSelectedIndex);
			mapHatchSelected=mapHatches.getMap(nHatchSelectedIndex);
			mapHatchesSelected.appendMap(nHatchSelectedIndex,mapHatchSelected);
			
			if(ss.length()==3)sOrientation=ss[2];
			sOrientations.append(sOrientation);
			nMapSelected=true;
		}
		if(nMapSelected || mapHatchesSelected.length()>0)
		{ 
			Map mapHatchesNew;
			String sMaterialProp;
			Map mapOrientationSelected;
			Map mapOrientationX, mapOrientationY, mapOrientationZ;
			Map mapContour;
			//
			String sMaterialProps[0];
			Map mapOrientationSelecteds;
			Map mapOrientationXs, mapOrientationYs, mapOrientationZs;
			Map mapContours;
			if(nMapSelected || mapHatchesSelected.length()==1)
			{ 
			// one material is selected
				mapHatchSelected = mapHatchesSelected.getMap(0);
				{ 
					Map mapMaterials=mapHatchSelected.getMap("Material[]");
					for (int l = 0; l<mapMaterials.length(); l++)
					{
						Map mapMaterialL=mapMaterials.getMap(l);
						if (mapMaterialL.hasString("Name") && mapMaterials.keyAt(l).makeLower() == "material")
						{
							String sMaterialMap=mapMaterialL.getString("Name");
							sMaterialProp+=sMaterialMap + ";";
						}
					}//next l
					sMaterialProps.append(sMaterialProp);
				}
				// for isotropic hatches use always the one in X
//				if (!mapHatchSelected.getInt("Anisotropic"))sOrientation="X";
				if(sOrientations.length()>0)
					sOrientation=sOrientations[0];
				
				if (!mapHatchSelected.getInt("Anisotropic"))sOrientation="X";
				Map mapOrientations=mapHatchSelected.getMap("Orientation[]");
				for (int im=0;im<mapOrientations.length();im++) 
				{ 
					Map mapOrientationI = mapOrientations.getMap(im);
					
					if (mapOrientationI.hasString("Name")&&
						 mapOrientationI.getString("Name")==sOrientation)
					{ 
						mapOrientationSelected = mapOrientationI;
					}
					if (mapOrientationI.hasString("Name")&&
						 mapOrientationI.getString("Name")=="X")
					{ 
						mapOrientationX = mapOrientationI;
						continue;
					}
					if (mapOrientationI.hasString("Name")&&
						 mapOrientationI.getString("Name")=="Y")
					{ 
						mapOrientationY = mapOrientationI;
						continue;
					}
					if (mapOrientationI.hasString("Name")&&
						 mapOrientationI.getString("Name")=="Z")
					{ 
						mapOrientationZ = mapOrientationI;
						continue;
					}
				}//next im
				
				mapOrientationSelecteds.appendMap("mapOrientationSelected",mapOrientationSelected);
				mapOrientationXs.appendMap("mapOrientationX",mapOrientationX);
				mapOrientationYs.appendMap("mapOrientationY",mapOrientationY);
				mapOrientationZs.appendMap("mapOrientationZ",mapOrientationZ);
				mapContour=mapHatchSelected.getMap("Contour");
				mapContours.appendMap("mapContour",mapContour);
			}
			else if(mapHatchesSelected.length()>1)
			{ 
				for (int is=0;is<mapHatchesSelected.length();is++) 
				{ 
					Map mapHatchSelectedI=mapHatchesSelected.getMap(is); 
					{ 
						sMaterialProp="";
						Map mapMaterials=mapHatchSelectedI.getMap("Material[]");
						for (int l = 0; l<mapMaterials.length(); l++)
						{
							Map mapMaterialL=mapMaterials.getMap(l);
							if (mapMaterialL.hasString("Name") && mapMaterials.keyAt(l).makeLower() == "material")
							{
								String sMaterialMap=mapMaterialL.getString("Name");
								sMaterialProp+=sMaterialMap + ";";
							}
						}//next l
						sMaterialProps.append(sMaterialProp);
					}
					if ( !mapHatchSelectedI.getInt("Anisotropic"))
					{
						sOrientation = "X";
					}
					else
					{ 
						sOrientation = sOrientations[is];
					}
					Map mapOrientations=mapHatchSelectedI.getMap("Orientation[]");
					for (int im=0;im<mapOrientations.length();im++) 
					{ 
						Map mapOrientationI = mapOrientations.getMap(im);
						
						if (mapOrientationI.hasString("Name")&&
							 mapOrientationI.getString("Name")==sOrientation)
						{ 
							mapOrientationSelected = mapOrientationI;
						}
						if (mapOrientationI.hasString("Name")&&
							 mapOrientationI.getString("Name")=="X")
						{ 
							mapOrientationX = mapOrientationI;
							continue;
						}
						if (mapOrientationI.hasString("Name")&&
							 mapOrientationI.getString("Name")=="Y")
						{ 
							mapOrientationY = mapOrientationI;
							continue;
						}
						if (mapOrientationI.hasString("Name")&&
							 mapOrientationI.getString("Name")=="Z")
						{ 
							mapOrientationZ = mapOrientationI;
							continue;
						}
					}//next im
					mapOrientationSelecteds.appendMap("mapOrientationSelected",mapOrientationSelected);
					mapOrientationXs.appendMap("mapOrientationX",mapOrientationX);
					mapOrientationYs.appendMap("mapOrientationY",mapOrientationY);
					mapOrientationZs.appendMap("mapOrientationZ",mapOrientationZ);
					
					mapContour=mapHatchSelectedI.getMap("Contour");
					mapContours.appendMap("mapContour",mapContour);
				}//next is
			}
			// entSelect is part of ents
		// create TSL
			TslInst tslDialog; Vector3d vecXTsl=_XW; Vector3d vecYTsl=_YW;
			GenBeam gbsTsl[]={}; Entity entsTsl[]={}; Point3d ptsTsl[]={_Pt0};
			int nProps[0]; 
			double dProps[0]; 
			String sProps[0];
			
			Map mapTsl;
			if(bModify)
			{
				if(nHatchMapping==1)
				{
				// when by painter and groups of painter, name will be readonly
					mapTsl.setInt("nHatchMapping",nHatchMapping);
				}
				mapTsl.setInt("DialogMode", 1);
//				nProps.setLength(5);
//				dProps.setLength(4);
//				sProps.setLength(10);
				sProps.setLength(19);
			}
			else if(bAdd)
			{
				mapTsl.setInt("DialogMode", 2);
//				nProps.setLength(9);
//				dProps.setLength(10);
//				sProps.setLength(16);
				sProps.setLength(35);
			}
			
		// set properties
			for (int ii=0;ii<mapHatchesSelected.length();ii++) 
			{ 
				Map mapHatchSelectedI=mapHatchesSelected.getMap(ii);
				Map mapContourI=mapContours.getMap(ii);
				Map mapOrientationSelectedI=mapOrientationSelecteds.getMap(ii);
				Map mapOrientationXI=mapOrientationXs.getMap(ii);
				Map mapOrientationYI=mapOrientationYs.getMap(ii);
				Map mapOrientationZI=mapOrientationZs.getMap(ii);
				int nIndexProp;
				String ss;
//				Map m = mapHatchSelected;
				String sMaterialPropI=sMaterialProps[ii];
				Map m = mapHatchSelectedI;
				//0
				ss = "Name"; if(m.hasString(ss))
				{
					if(ii>0)
					{ 
						if(sProps[nIndexProp]!=sVaries)
						{
							if(sProps[nIndexProp]!=m.getString(ss))
							{ 
								sProps[nIndexProp]=sVaries;
							}
						}
					}
					else
					{
						sProps[nIndexProp] = m.getString(ss);
					}
					nIndexProp++;
				}
				// 1
				ss = "isActive"; if(m.hasInt(ss)) 
				{
					int _iActive; _iActive = m.getInt(ss); 
					if(_iActive<=0)
						_iActive = 0;
					else
						_iActive = 1;
					
					if(ii>0)
					{ 
						if(sProps[nIndexProp]!=sVaries)
						{
							if(sProps[nIndexProp]!=sNoYes[_iActive])
							{ 
								sProps[nIndexProp]=sVaries;
								mapTsl.setInt("isActive", true);
							}
						}
					}
					else
					{
						sProps[nIndexProp] = sNoYes[_iActive];
					}
					nIndexProp++;
				}
				//2
				ss = "Anisotropic"; if(m.hasInt(ss)) 
				{
					int _bAnisotropic; _bAnisotropic = m.getInt(ss); 
					if(_bAnisotropic<=0)
						_bAnisotropic = 0;
					else
						_bAnisotropic = 1;
					
					if(ii>0)
					{ 
						if(sProps[nIndexProp]!=sVaries)
						{
							if(sProps[nIndexProp]!=sNoYes[_bAnisotropic])
							{ 
								sProps[nIndexProp]=sVaries;
								mapTsl.setInt("Anisotropic", true);
							}
						}
					}
					else
					{
						sProps[nIndexProp]=sNoYes[_bAnisotropic];
					}
					nIndexProp++;
				}
				//3
				// sMaterialProp
				{ 
					if(ii>0)
					{ 
						if(sProps[nIndexProp]!=sVaries)
						{
							if(sProps[nIndexProp]!=sMaterialPropI)
							{ 
								sProps[nIndexProp]=sVaries;
							}
						}
					}
					else
					{
						sProps[nIndexProp]=sMaterialPropI;
					}
					nIndexProp++;
				}
				m = mapContourI;
				//4
				ss = "Contour"; if(m.hasInt(ss)) 
				{
					int _iContour;
					_iContour= m.getInt(ss);
					if(_iContour<=0)
						_iContour = 0;
					else
						_iContour = 1;
				 	
				 	if(ii>0)
					{ 
						if(sProps[nIndexProp]!=sVaries)
						{
							if(sProps[nIndexProp]!=sNoYes[_iContour])
							{ 
								sProps[nIndexProp]=sVaries;
								mapTsl.setInt("Contour", true);
							}
						}
					}
					else
					{
						sProps[nIndexProp]=sNoYes[_iContour];
					}
					nIndexProp++;
				}
				//5
				ss = "Color"; if(m.hasInt(ss)) 
				{
					if(ii>0)
					{ 
						if(sProps[nIndexProp]!=sVaries)
						{
							String s=m.getInt(ss);
							if(sProps[nIndexProp]!=s)
							{ 
								sProps[nIndexProp]=sVaries;
							}
						}
					}
					else
					{
						sProps[nIndexProp]=m.getInt(ss);
					}
					nIndexProp++;
//					nProps[0] = m.getInt(ss);
				}
				//6
				ss = "Thickness"; if(m.hasDouble(ss)) 
				{
					if(ii>0)
					{ 
						if(sProps[nIndexProp]!=sVaries)
						{
							String s=m.getDouble(ss);
							if(sProps[nIndexProp]!=s)
							{ 
								sProps[nIndexProp]=sVaries;
							}
						}
					}
					else
					{
						sProps[nIndexProp]=m.getDouble(ss);
					}
					nIndexProp++;
//					dProps[0]=m.getDouble(ss);
				}
				m = mapContourI;
				//7
//				sProps[nIndexProp] = sNoYes[0];
				ss = "SupressBeamCross"; if(m.hasInt(ss)) 
				{
					int _iSupressBeamCross;  _iSupressBeamCross= m.getInt(ss); 
					if(_iSupressBeamCross<=0)
						_iSupressBeamCross = 0;
					else
						_iSupressBeamCross = 1;
					
					if(ii>0)
					{ 
						if(sProps[nIndexProp]!=sVaries)
						{
							if(sProps[nIndexProp]!=sNoYes[_iSupressBeamCross])
							{ 
								sProps[nIndexProp]=sVaries;
								mapTsl.setInt("SupressBeamCross", true);
							}
						}
					}
					else
					{
						sProps[nIndexProp]=sNoYes[_iSupressBeamCross];
					}
					nIndexProp++;
				}
				m = mapHatchSelectedI;
				//8
				ss = "SolidHatch"; if(m.hasInt(ss)) 
				{
					int _iSolidHatch;  _iSolidHatch= m.getInt(ss); 
					if(_iSolidHatch<=0)
						_iSolidHatch = 0;
					else
						_iSolidHatch = 1;
					
					if(ii>0)
					{ 
						if(sProps[nIndexProp]!=sVaries)
						{
							if(sProps[nIndexProp]!=sNoYes[_iSolidHatch])
							{ 
								sProps[nIndexProp]=sVaries;
								mapTsl.setInt("SolidHatch", true);
							}
						}
					}
					else
					{
						sProps[nIndexProp]=sNoYes[_iSolidHatch];
					}
					nIndexProp++;
				}
				//9
				ss = "SolidTransparency"; if(m.hasInt(ss)) 
				{
					if(ii>0)
					{ 
						if(sProps[nIndexProp]!=sVaries)
						{
							String s=m.getInt(ss);
							if(sProps[nIndexProp]!=s)
							{ 
								sProps[nIndexProp]=sVaries;
							}
						}
					}
					else
					{
						sProps[nIndexProp]=m.getInt(ss);
					}
					nIndexProp++;
//					nProps[1] = m.getInt(ss);
				}
				//10
				ss = "SolidColor"; if(m.hasInt(ss)) 
				{
					if(ii>0)
					{ 
						if(sProps[nIndexProp]!=sVaries)
						{
							String s=m.getInt(ss);
							if(sProps[nIndexProp]!=s)
							{ 
								sProps[nIndexProp]=sVaries;
							}
						}
					}
					else
					{
						sProps[nIndexProp]=m.getInt(ss);
					}
					nIndexProp++;
//					nProps[2]=m.getInt(ss);
				}
				// 
			// orientation Selected
				if(bModify)
				{ 
					String ss;
					//
					m = mapHatchSelectedI;
					Map m = mapOrientationSelectedI;
					//11
					ss = "Name"; if(m.hasString(ss)) 
					{
						if(ii>0)
						{ 
							if(sProps[nIndexProp]!=sVaries)
							{
								String s=m.getString(ss);
								if(sProps[nIndexProp]!=s)
								{ 
									sProps[nIndexProp]=sVaries;
								}
							}
						}
						else
						{
							sProps[nIndexProp]=m.getString(ss);
						}
						nIndexProp++;
	//					sProps[7]=m.getString(ss);
					}
					//12
					ss = "Pattern"; if(m.hasString(ss)) 
					{
						if(ii>0)
						{ 
							if(sProps[nIndexProp]!=sVaries)
							{
								String s=m.getString(ss);
								if(sProps[nIndexProp]!=s)
								{ 
									sProps[nIndexProp]=sVaries;
								}
							}
						}
						else
						{
							sProps[nIndexProp]=m.getString(ss);
						}
						nIndexProp++;
	//					sProps[8] = m.getString(ss);
					}
					//13
					ss = "Color"; if(m.hasInt(ss)) 
					{
						if(ii>0)
						{ 
							if(sProps[nIndexProp]!=sVaries)
							{
								String s=m.getInt(ss);
								if(sProps[nIndexProp]!=s)
								{ 
									sProps[nIndexProp]=sVaries;
								}
							}
						}
						else
						{
							sProps[nIndexProp]=m.getInt(ss);
						}
						nIndexProp++;
//						nProps[3]=m.getInt(ss);
					}
					//14
					ss = "Transparency"; if(m.hasInt(ss)) 
					{
						if(ii>0)
						{ 
							if(sProps[nIndexProp]!=sVaries)
							{
								String s=m.getInt(ss);
								if(sProps[nIndexProp]!=s)
								{ 
									sProps[nIndexProp]=sVaries;
								}
							}
						}
						else
						{
							sProps[nIndexProp]=m.getInt(ss);
						}
						nIndexProp++;
//						nProps[4] = m.getInt(ss);
					}
					
	//				sProps[10] = sNoYes[0];
	//				ss = "Insulation"; if(m.hasInt(ss)) sProps[10] = sNoYes[m.getInt(ss)];
					//15
					ss = "Angle"; if(m.hasDouble(ss)) 
					{
						if(ii>0)
						{ 
							if(sProps[nIndexProp]!=sVaries)
							{
								String s=m.getDouble(ss);
								if(sProps[nIndexProp]!=s)
								{ 
									sProps[nIndexProp]=sVaries;
								}
							}
						}
						else
						{
							sProps[nIndexProp]=m.getDouble(ss);
						}
						nIndexProp++;
//						dProps[1] = m.getDouble(ss);
					}
					//16
					ss = "Scale"; if(m.hasDouble(ss)) 
					{
						if(ii>0)
						{ 
							if(sProps[nIndexProp]!=sVaries)
							{
								String s=m.getDouble(ss);
								if(sProps[nIndexProp]!=s)
								{ 
									sProps[nIndexProp]=sVaries;
								}
							}
						}
						else
						{
							sProps[nIndexProp]=m.getDouble(ss);
						}
						nIndexProp++;
//						dProps[2] = m.getDouble(ss);
					}
					//17
					ss = "ScaleMin"; if(m.hasDouble(ss)) 
					{
						if(ii>0)
						{ 
							if(sProps[nIndexProp]!=sVaries)
							{
								String s=m.getDouble(ss);
								if(sProps[nIndexProp]!=s)
								{ 
									sProps[nIndexProp]=sVaries;
								}
							}
						}
						else
						{
							sProps[nIndexProp]=m.getDouble(ss);
						}
						nIndexProp++;
//						dProps[3] = m.getDouble(ss);
					}
					//18
					ss = "Static"; if(m.hasInt(ss)) 
					{
						int _iStatic; _iStatic = m.getInt(ss); 
						if(_iStatic<=0)
							_iStatic = 0;
						else
							_iStatic = 1;
						
						if(ii>0)
						{ 
							if(sProps[nIndexProp]!=sVaries)
							{
								String s=sHatchModes[!_iStatic];
								if(sProps[nIndexProp]!=s)
								{ 
									sProps[nIndexProp]=sVaries;
									mapTsl.setInt("StaticX", true);
								}
							}
						}
						else
						{
							sProps[nIndexProp]=sHatchModes[!_iStatic];
						}
						nIndexProp++;
	//					sProps[9] = sNoYes[_iStatic];
					}
				// HSB-12334: insulation
	//				ss = "ScaleLongitudinal"; if(m.hasDouble(ss)) dProps[4]=m.getDouble(ss);
	//				ss = "ScaleTransversal"; if(m.hasDouble(ss)) dProps[5]=m.getDouble(ss);
				}
				else if(bAdd)
				{ 
			//		 orientation X
					{ 
						String ss;
						Map m = mapOrientationXI;
						//11
						ss = "Name"; if(m.hasString(ss)) 
						{
							if(ii>0)
							{ 
								if(sProps[nIndexProp]!=sVaries)
								{
									String s=m.getString(ss);
									if(sProps[nIndexProp]!=s)
									{ 
										sProps[nIndexProp]=sVaries;
									}
								}
							}
							else
							{
								sProps[nIndexProp]=m.getString(ss);
							}
							nIndexProp++;
//							sProps[7] = m.getString(ss);
						}
						//12
						ss = "Pattern"; if(m.hasString(ss)) 
						{
							if(ii>0)
							{ 
								if(sProps[nIndexProp]!=sVaries)
								{
									String s=m.getString(ss);
									if(sProps[nIndexProp]!=s)
									{ 
										sProps[nIndexProp]=sVaries;
									}
								}
							}
							else
							{
								sProps[nIndexProp]=m.getString(ss);
							}
							nIndexProp++;
//							sProps[8] = m.getString(ss);
						}
						//13
						ss = "Color"; if(m.hasInt(ss)) 
						{
							if(ii>0)
							{ 
								if(sProps[nIndexProp]!=sVaries)
								{
									String s=m.getInt(ss);
									if(sProps[nIndexProp]!=s)
									{ 
										sProps[nIndexProp]=sVaries;
									}
								}
							}
							else
							{
								sProps[nIndexProp]=m.getInt(ss);
							}
							nIndexProp++;
//							nProps[3] = m.getInt(ss);
						}
						//14
						ss = "Transparency"; if(m.hasInt(ss)) 
						{
							if(ii>0)
							{ 
								if(sProps[nIndexProp]!=sVaries)
								{
									String s=m.getInt(ss);
									if(sProps[nIndexProp]!=s)
									{ 
										sProps[nIndexProp]=sVaries;
									}
								}
							}
							else
							{
								sProps[nIndexProp]=m.getInt(ss);
							}
							nIndexProp++;
//							nProps[4] = m.getInt(ss);
						}
						
	//					sProps[10] = sNoYes[0];
	//					ss = "Insulation"; if(m.hasInt(ss)) sProps[10] = sNoYes[m.getInt(ss)];
						//15
						ss = "Angle"; if(m.hasDouble(ss)) 
						{
							if(ii>0)
							{ 
								if(sProps[nIndexProp]!=sVaries)
								{
									String s=m.getDouble(ss);
									if(sProps[nIndexProp]!=s)
									{ 
										sProps[nIndexProp]=sVaries;
									}
								}
							}
							else
							{
								sProps[nIndexProp]=m.getDouble(ss);
							}
							nIndexProp++;
//							dProps[1]=m.getDouble(ss);
						}
						//16
						ss = "Scale"; if(m.hasDouble(ss)) 
						{
							if(ii>0)
							{ 
								if(sProps[nIndexProp]!=sVaries)
								{
									String s=m.getDouble(ss);
									if(sProps[nIndexProp]!=s)
									{ 
										sProps[nIndexProp]=sVaries;
									}
								}
							}
							else
							{
								sProps[nIndexProp]=m.getDouble(ss);
							}
							nIndexProp++;
//							dProps[2] = m.getDouble(ss);
						}
						//17
						ss = "ScaleMin"; if(m.hasDouble(ss)) 
						{
							if(ii>0)
							{ 
								if(sProps[nIndexProp]!=sVaries)
								{
									String s=m.getDouble(ss);
									if(sProps[nIndexProp]!=s)
									{ 
										sProps[nIndexProp]=sVaries;
									}
								}
							}
							else
							{
								sProps[nIndexProp]=m.getDouble(ss);
							}
							nIndexProp++;
//							dProps[3] = m.getDouble(ss);
						}
						//18
						ss = "Static"; if(m.hasInt(ss)) 
						{
							int _iStatic; _iStatic = m.getInt(ss); 
							if(_iStatic<=0)
								_iStatic = 0;
							else
								_iStatic = 1;
							
							if(ii>0)
							{ 
								if(sProps[nIndexProp]!=sVaries)
								{
									String s=sHatchModes[!_iStatic];
									if(sProps[nIndexProp]!=s)
									{ 
										sProps[nIndexProp]=sVaries;
										mapTsl.setInt("StaticX", true);
									}
								}
							}
							else
							{
								sProps[nIndexProp]=sHatchModes[!_iStatic];
							}
							nIndexProp++;
//							sProps[9] = sNoYes[_iStatic];
						}
	//					ss = "ScaleLongitudinal"; if(m.hasDouble(ss)) dProps[4]=m.getDouble(ss);
	//					ss = "ScaleTransversal"; if(m.hasDouble(ss)) dProps[5]=m.getDouble(ss);
						
						//
					}
		//		 orientation Y
					{ 
						String ss;
						Map m = mapOrientationYI;
						//19
						ss = "Name"; if(m.hasString(ss)) 
						{
							if(ii>0)
							{ 
								if(sProps[nIndexProp]!=sVaries)
								{
									String s=m.getString(ss);
									if(sProps[nIndexProp]!=s)
									{ 
										sProps[nIndexProp]=sVaries;
									}
								}
							}
							else
							{
								sProps[nIndexProp]=m.getString(ss);
							}
							nIndexProp++;
//							sProps[10] = m.getString(ss);
						}
						//20
						ss = "Pattern"; if(m.hasString(ss)) 
						{
							if(ii>0)
							{ 
								if(sProps[nIndexProp]!=sVaries)
								{
									String s=m.getString(ss);
									if(sProps[nIndexProp]!=s)
									{ 
										sProps[nIndexProp]=sVaries;
									}
								}
							}
							else
							{
								sProps[nIndexProp]=m.getString(ss);
							}
							nIndexProp++;
//							sProps[11] = m.getString(ss);
						}
						//21
						ss = "Color"; if(m.hasInt(ss)) 
						{
							if(ii>0)
							{ 
								if(sProps[nIndexProp]!=sVaries)
								{
									String s=m.getInt(ss);
									if(sProps[nIndexProp]!=s)
									{ 
										sProps[nIndexProp]=sVaries;
									}
								}
							}
							else
							{
								sProps[nIndexProp]=m.getInt(ss);
							}
							nIndexProp++;
//							nProps[5] = m.getInt(ss);
						}
						//22
						ss = "Transparency"; if(m.hasInt(ss)) 
						{
							if(ii>0)
							{ 
								if(sProps[nIndexProp]!=sVaries)
								{
									String s=m.getInt(ss);
									if(sProps[nIndexProp]!=s)
									{ 
										sProps[nIndexProp]=sVaries;
									}
								}
							}
							else
							{
								sProps[nIndexProp]=m.getInt(ss);
							}
							nIndexProp++;
//							nProps[6] = m.getInt(ss);
						}
						
	//					sProps[14] = sNoYes[0];
	//					ss = "Insulation"; if(m.hasInt(ss)) sProps[14] = sNoYes[m.getInt(ss)];
						
						//23
						ss = "Angle"; if(m.hasDouble(ss)) 
						{
							if(ii>0)
							{ 
								if(sProps[nIndexProp]!=sVaries)
								{
									String s=m.getDouble(ss);
									if(sProps[nIndexProp]!=s)
									{ 
										sProps[nIndexProp]=sVaries;
									}
								}
							}
							else
							{
								sProps[nIndexProp]=m.getDouble(ss);
							}
							nIndexProp++;
//							dProps[4] = m.getDouble(ss);
						}
						//24
						ss = "Scale"; if(m.hasDouble(ss)) 
						{
							if(ii>0)
							{ 
								if(sProps[nIndexProp]!=sVaries)
								{
									String s=m.getDouble(ss);
									if(sProps[nIndexProp]!=s)
									{ 
										sProps[nIndexProp]=sVaries;
									}
								}
							}
							else
							{
								sProps[nIndexProp]=m.getDouble(ss);
							}
							nIndexProp++;
//							dProps[5] = m.getDouble(ss);
						}
						//25
						ss = "ScaleMin"; if(m.hasDouble(ss)) 
						{
							if(ii>0)
							{ 
								if(sProps[nIndexProp]!=sVaries)
								{
									String s=m.getDouble(ss);
									if(sProps[nIndexProp]!=s)
									{ 
										sProps[nIndexProp]=sVaries;
									}
								}
							}
							else
							{
								sProps[nIndexProp]=m.getDouble(ss);
							}
							nIndexProp++;
//							dProps[6] = m.getDouble(ss);
						}
						//26
						ss = "Static"; if(m.hasInt(ss)) 
						{
							int _iStatic; _iStatic = m.getInt(ss); 
							if(_iStatic<=0)
								_iStatic = 0;
							else
								_iStatic = 1;
							
							if(ii>0)
							{ 
								if(sProps[nIndexProp]!=sVaries)
								{
									String s=sHatchModes[!_iStatic];
									if(sProps[nIndexProp]!=s)
									{ 
										sProps[nIndexProp]=sVaries;
										mapTsl.setInt("StaticY", true);
									}
								}
							}
							else
							{
								sProps[nIndexProp]=sHatchModes[!_iStatic];
							}
							nIndexProp++;
//							sProps[12] = sNoYes[_iStatic];
						}
	//					ss = "ScaleLongitudinal"; if(m.hasDouble(ss)) dProps[9]=m.getDouble(ss);
	//					ss = "ScaleTransversal"; if(m.hasDouble(ss)) dProps[10]=m.getDouble(ss);
						//
					}
		//		 orientation Z
					{ 
						String ss;
						Map m = mapOrientationZ;
						//27
						ss = "Name"; if(m.hasString(ss)) 
						{
							if(ii>0)
							{ 
								if(sProps[nIndexProp]!=sVaries)
								{
									String s=m.getString(ss);
									if(sProps[nIndexProp]!=s)
									{ 
										sProps[nIndexProp]=sVaries;
									}
								}
							}
							else
							{
								sProps[nIndexProp]=m.getString(ss);
							}
							nIndexProp++;
//							sProps[13] = m.getString(ss);
						}
						//28
						ss = "Pattern"; if(m.hasString(ss)) 
						{
							if(ii>0)
							{ 
								if(sProps[nIndexProp]!=sVaries)
								{
									String s=m.getString(ss);
									if(sProps[nIndexProp]!=s)
									{ 
										sProps[nIndexProp]=sVaries;
									}
								}
							}
							else
							{
								sProps[nIndexProp]=m.getString(ss);
							}
							nIndexProp++;
//							sProps[14] = m.getString(ss);
						}
						//29
						ss = "Color"; if(m.hasInt(ss)) 
						{
							if(ii>0)
							{ 
								if(sProps[nIndexProp]!=sVaries)
								{
									String s=m.getInt(ss);
									if(sProps[nIndexProp]!=s)
									{ 
										sProps[nIndexProp]=sVaries;
									}
								}
							}
							else
							{
								sProps[nIndexProp]=m.getInt(ss);
							}
							nIndexProp++;
//							nProps[7] = m.getInt(ss);
						}
						//30
						ss = "Transparency"; if(m.hasInt(ss)) 
						{
							if(ii>0)
							{ 
								if(sProps[nIndexProp]!=sVaries)
								{
									String s=m.getInt(ss);
									if(sProps[nIndexProp]!=s)
									{ 
										sProps[nIndexProp]=sVaries;
									}
								}
							}
							else
							{
								sProps[nIndexProp]=m.getInt(ss);
							}
							nIndexProp++;
//							nProps[8] = m.getInt(ss);
						}
	//					sProps[18] = sNoYes[0];
	//					ss = "Insulation"; if(m.hasInt(ss)) sProps[18] = sNoYes[m.getInt(ss)];
						//31
						ss = "Angle"; if(m.hasDouble(ss)) 
						{
							if(ii>0)
							{ 
								if(sProps[nIndexProp]!=sVaries)
								{
									String s=m.getDouble(ss);
									if(sProps[nIndexProp]!=s)
									{ 
										sProps[nIndexProp]=sVaries;
									}
								}
							}
							else
							{
								sProps[nIndexProp]=m.getDouble(ss);
							}
							nIndexProp++;
//							dProps[7] = m.getDouble(ss);
						}
						//32
						ss = "Scale"; if(m.hasDouble(ss)) 
						{
							if(ii>0)
							{ 
								if(sProps[nIndexProp]!=sVaries)
								{
									String s=m.getDouble(ss);
									if(sProps[nIndexProp]!=s)
									{ 
										sProps[nIndexProp]=sVaries;
									}
								}
							}
							else
							{
								sProps[nIndexProp]=m.getDouble(ss);
							}
							nIndexProp++;
//							dProps[8] = m.getDouble(ss);
						}
						//33
						ss = "ScaleMin"; if(m.hasDouble(ss)) 
						{
							if(ii>0)
							{ 
								if(sProps[nIndexProp]!=sVaries)
								{
									String s=m.getDouble(ss);
									if(sProps[nIndexProp]!=s)
									{ 
										sProps[nIndexProp]=sVaries;
									}
								}
							}
							else
							{
								sProps[nIndexProp]=m.getDouble(ss);
							}
							nIndexProp++;
//							dProps[9] = m.getDouble(ss);
						}
						//34
						ss = "Static"; if(m.hasInt(ss)) 
						{
							int _iStatic; _iStatic = m.getInt(ss); 
							if(_iStatic<=0)
								_iStatic = 0;
							else
								_iStatic = 1;
							
							if(ii>0)
							{ 
								if(sProps[nIndexProp]!=sVaries)
								{
									String s=sHatchModes[!_iStatic];
									if(sProps[nIndexProp]!=s)
									{ 
										sProps[nIndexProp]=sVaries;
										mapTsl.setInt("StaticZ", true);
									}
								}
							}
							else
							{
								sProps[nIndexProp]=sHatchModes[!_iStatic];
							}
							nIndexProp++;
//							sProps[15] = sNoYes[_iStatic];
						}
	//					ss = "ScaleLongitudinal"; if(m.hasDouble(ss)) dProps[14]=m.getDouble(ss);
	//					ss = "ScaleTransversal"; if(m.hasDouble(ss)) dProps[15]=m.getDouble(ss);
						//
					}
				}
			}// mapHatchesSelected.length()
			
			tslDialog.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, 
				ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
			
			if(tslDialog.bIsValid())
			{ 
				int bOk=tslDialog.showDialog();
				if(bOk)
				{ 
					Map mapHatchesExist=mapHatches;
					if(bModify)
					for (int iHatchIndex=0;iHatchIndex<nHatchesSelectedIndex.length();iHatchIndex++) 
					{ 
						Map mapHatchesNewThis;
					// do for each selected hatch
						nHatchesSelectedIndex[iHatchIndex];
						Map mapHatchExist=mapHatchesExist.getMap(nHatchesSelectedIndex[iHatchIndex]);
						Map mapContourExist=mapHatchExist.getMap("Contour");
						Map mapOrientationsExist=mapHatchExist.getMap("Orientation[]");
						
						Map mapOrientationXExist=mapOrientationsExist.getMap(0);
						Map mapOrientationYExist=mapOrientationsExist.getMap(1);
						Map mapOrientationZExist=mapOrientationsExist.getMap(2);
						Map mapMaterialsExist=mapHatchExist.getMap("Material[]");
						
						sOrientation=sOrientations[iHatchIndex];
						Map mapOrientationSelectedExist = mapOrientationXExist;
						if(sOrientation=="Y")
							mapOrientationSelectedExist = mapOrientationYExist;
						if(sOrientation=="Z")
							mapOrientationSelectedExist = mapOrientationZExist;
						
						Map mapHatchNew, mapContourNew, mapOrientationsNew, 
						mapOrientationXnew, mapOrientationYnew, mapOrientationZnew,
						mapOrientationSelectedNew,
						mapMaterialsNew;
						
					// materials
						{ 
							String sMatProp = tslDialog.propString(3);
							if(sMatProp!=sVaries)
							{
								sMatProp.trimLeft();
								sMatProp.trimRight();
								String sMatProps[] = sMatProp.tokenize(";");
								for (int iMat=0;iMat<sMatProps.length();iMat++) 
								{ 
									String sMatI = sMatProps[iMat];
									Map mapMatI;
									mapMatI.setMapKey("Material");
									mapMatI.setString("Name", sMatI);
									mapMaterialsNew.appendMap("Material", mapMatI);
								}//next iMat
							}
							else
							{ 
								mapMaterialsNew=mapMaterialsExist;
							}
						}
					// contour
						{ 
							mapContourNew.setMapKey("Contour");
							if(tslDialog.propString(4)!=sVaries)
								mapContourNew.setInt("Contour", sNoYes.find(tslDialog.propString(4)));
							else
								mapContourNew.setInt("Contour", mapContourExist.getInt("Contour"));
							String sColor = tslDialog.propString(5);
							if(sColor!=sVaries)
							{ 
								int nColor=sColor.atoi();
								mapContourNew.setInt("Color",nColor);
							}
							else
							{ 
								mapContourNew.setInt("Color", mapContourExist.getInt("Color"));
							}
							String sThick=tslDialog.propString(6);
							if(sThick!=sVaries)
							{ 
								double dThick=sThick.atof();
								mapContourNew.setDouble("Thickness",dThick);
							}
							else
							{
								mapContourNew.setDouble("Thickness", mapContourExist.getDouble("Thickness"));
							}
							if(tslDialog.propString(7)!=sVaries)
							{
								mapContourNew.setInt("SupressBeamCross", sNoYes.find(tslDialog.propString(7)));
							}
							else
							{ 
								mapContourNew.setInt("SupressBeamCross", mapContourExist.getInt("SupressBeamCross"));
							}
						}
					// 	mapOrientationSelectednew
						if(bModify)
						{ 
							mapOrientationSelectedNew.setMapKey("Orientation");
							mapOrientationSelectedNew.setString("Name", sOrientation);
							if(tslDialog.propString(12)!=sVaries)
							{
								mapOrientationSelectedNew.setString("Pattern", tslDialog.propString(12));
							}
							else
							{ 
								mapOrientationSelectedNew.setString("Pattern", mapOrientationSelectedExist.getString("Pattern"));
							}
							String sColor=tslDialog.propString(13);
							if(sColor!=sVaries)
							{ 
								int nColor=sColor.atoi();
								mapOrientationSelectedNew.setInt("Color", nColor);
							}
							else
							{ 
								mapOrientationSelectedNew.setInt("Color", mapOrientationSelectedExist.getInt("Color"));
							}
							
							String sTransparency=tslDialog.propString(14);
							if(sTransparency!=sVaries)
							{ 
								int nTransparency=sTransparency.atoi();
								mapOrientationSelectedNew.setInt("Transparency", nTransparency);
							}
							else
							{ 
								mapOrientationSelectedNew.setInt("Transparency", mapOrientationSelectedExist.getInt("Transparency"));
							}
							String sAngle=tslDialog.propString(15);
							if(sAngle!=sVaries)
							{ 
								double dAngle=sAngle.atof();
								mapOrientationSelectedNew.setDouble("Angle", dAngle);
							}
							else
							{ 
								mapOrientationSelectedNew.setDouble("Angle", mapOrientationSelectedExist.getDouble("Angle"));
							}
							
							String sScale=tslDialog.propString(16);
							if(sScale!=sVaries)
							{ 
								double dScale=sScale.atof();
								mapOrientationSelectedNew.setDouble("Scale", dScale);
							}
							else
							{ 
								mapOrientationSelectedNew.setDouble("Scale", mapOrientationSelectedExist.getDouble("Scale"));
							}
							String sScaleMin=tslDialog.propString(17);
							if(sScaleMin!=sVaries)
							{ 
								double dScaleMin=sScaleMin.atof();
								mapOrientationSelectedNew.setDouble("ScaleMin",dScaleMin);
							}
							else
							{ 
								mapOrientationSelectedNew.setDouble("ScaleMin",mapOrientationSelectedExist.getDouble("ScaleMin"));
							}
							if(tslDialog.propString(18)!=sVaries)
							{
								mapOrientationSelectedNew.setInt("Static", !sHatchModes.find(tslDialog.propString(18)));
							}
							else
							{ 
								mapOrientationSelectedNew.setInt("Static", mapOrientationSelectedExist.getInt("Static"));
							}
	//						mapOrientationSelectedNew.setInt("Insulation", sNoYes.find(tslDialog.propString(10)));
						//  HSB-12334: insulation
	//						mapOrientationSelectedNew.setDouble("ScaleLongitudinal", tslDialog.propDouble(4));
	//						mapOrientationSelectedNew.setDouble("ScaleTransversal", tslDialog.propDouble(5));
						}
						
					// save the hatches
						mapHatchNew.setMapKey("Hatch");
						if(bPainterGroup)
						{ 
							mapHatchNew.setString("PainterGroup",mapHatchExist.getString("PainterGroup"));
						}
						if(tslDialog.propString(1)!=sVaries)
						{
							mapHatchNew.setInt("isActive", sNoYes.find(tslDialog.propString(1)));
						}
						else
						{ 
							mapHatchNew.setInt("isActive", mapHatchExist.getInt("isActive"));
						}
						if(tslDialog.propString(0)!=sVaries)
						{
							mapHatchNew.setString("Name", tslDialog.propString(0));
						}
						else
						{ 
							mapHatchNew.setString("Name", mapHatchExist.getString("Name"));
						}
						if(nHatchMapping==1)
							mapHatchNew.setString("Painter", sRule);
						if(tslDialog.propString(2)!=sVaries)
						{
							mapHatchNew.setInt("Anisotropic", sNoYes.find(tslDialog.propString(2)));
						}
						else
						{ 
							mapHatchNew.setInt("Anisotropic", mapHatchExist.getInt("Anisotropic"));
						}
						
						mapHatchNew.appendMap("Material[]", mapMaterialsNew);
						mapHatchNew.appendMap("Contour", mapContourNew);
						mapHatchNew.setInt("SolidHatch", sNoYes.find(tslDialog.propString(8)));
						String sTransparency=tslDialog.propString(9);
						if(sTransparency!=sVaries)
						{
							int nTransparency=sTransparency.atoi();
							mapHatchNew.setInt("SolidTransparency", nTransparency);
						}
						else
						{ 
							mapHatchNew.setInt("SolidTransparency", mapHatchExist.getInt("SolidTransparency"));
						}
						String sColor=tslDialog.propString(10);
						if(sColor!=sVaries)
						{
							int nColor=sColor.atoi();
							mapHatchNew.setInt("SolidColor", nColor);
						}
						else
						{ 
							mapHatchNew.setInt("SolidColor", mapHatchExist.getInt("SolidColor"));
						}
						
						if(bModify)
						{ 
						// hatch modify
							if(sOrientation=="X")
								mapOrientationsNew.appendMap("Orientation", mapOrientationSelectedNew);
							else
								mapOrientationsNew.appendMap("Orientation", mapOrientationXExist);
							
							if(sOrientation=="Y")
								mapOrientationsNew.appendMap("Orientation", mapOrientationSelectedNew);
							else
								mapOrientationsNew.appendMap("Orientation", mapOrientationYExist);
								
							if(sOrientation=="Z")
								mapOrientationsNew.appendMap("Orientation", mapOrientationSelectedNew);
							else
								mapOrientationsNew.appendMap("Orientation", mapOrientationZExist);
						}
						mapHatchNew.appendMap("Orientation[]", mapOrientationsNew);
						mapHatchesNewThis.setMapKey("Hatch[]");
					
						if(bModify)
						{ 
							for (int iH=0;iH<mapHatchesExist.length();iH++) 
							{ 
								if(nHatchesSelectedIndex[iHatchIndex]!=iH)
								{ 
									Map mapHi = mapHatchesExist.getMap(iH);
									mapHatchesNewThis.appendMap("Hatch", mapHi);
								}
								else if(nHatchesSelectedIndex[iHatchIndex]==iH) 
								{ 
									mapHatchesNewThis.appendMap("Hatch", mapHatchNew);
								}
							}//next iH
							mapHatchesExist = mapHatchesNewThis;
							mapHatchesNew = mapHatchesNewThis;
						}
					}//next iHatchIndex
//					if(bModify)
//					{ 
//						for (bModifyH=0;iH<mapHatches.length();iH++) 
//						{ 
//							if(nHatchesSelectedIndex.find(iH)<0)
//							{ 
//								Map mapHi = mapHatches.getMap(iH);
//								mapHatchesNew.appendMap("Hatch", mapHi);
//							}
//							else if(nHatchesSelectedIndex.find(iH)>-1) 
//							{ 
//								mapHatchesNew.appendMap("Hatch", mapHatchNew);
//							}
//						}//next iH
//					}
//					else if(bAdd)
//					{ 
//						for (bModifyH=0;iH<mapHatches.length();iH++) 
//						{ 
//							Map mapHi = mapHatches.getMap(iH);
//							mapHatchesNew.appendMap("Hatch", mapHi);
//						}//next iH
//						// add the new hatch
//						mapHatchesNew.appendMap("Hatch", mapHatchNew);
//					}
					
					if(bAdd)
					{ 
						Map mapHatchNew, mapContourNew, mapOrientationsNew, 
						mapOrientationXnew, mapOrientationYnew, mapOrientationZnew,
						mapOrientationSelectedNew,
						mapMaterialsNew;
						String sErrorAdd0=T("|All properties must be uniqely defined for adding a hatch|");
						String sErrorAdd1=T("|No|")+" "+sVaries+" "+T("|Properties must be shown|");
					
						for (int iprop=0;iprop<30;iprop++) 
						{ 
							if(tslDialog.propString(iprop)==sVaries) 
							{ 
								reportMessage("\n"+scriptName()+" "+sErrorAdd0);
								reportMessage("\n"+scriptName()+" "+sErrorAdd1);
								setExecutionLoops(2);
								return;
							}
						}//next iprop
						
					
					// materials
						{ 
							String sMatProp = tslDialog.propString(3);
							sMatProp.trimLeft();
							sMatProp.trimRight();
							String sMatProps[] = sMatProp.tokenize(";");
							for (int iMat=0;iMat<sMatProps.length();iMat++) 
							{ 
								String sMatI = sMatProps[iMat];
								Map mapMatI;
								mapMatI.setMapKey("Material");
								mapMatI.setString("Name", sMatI);
								mapMaterialsNew.appendMap("Material", mapMatI);
							}//next iMat
						}
					// contour
						{ 
							mapContourNew.setMapKey("Contour");
							mapContourNew.setInt("Contour", sNoYes.find(tslDialog.propString(4)));
							
							String sColor = tslDialog.propString(5);
							int nColor=sColor.atoi();
							mapContourNew.setInt("Color",nColor);
							
							String sThick=tslDialog.propString(6);
							double dThick=sThick.atof();
							mapContourNew.setDouble("Thickness",dThick);
							
							mapContourNew.setInt("SupressBeamCross", sNoYes.find(tslDialog.propString(7)));
						}
						
	//				 	mapOrientationXnew
						{ 
							mapOrientationXnew.setMapKey("Orientation");
							mapOrientationXnew.setString("Name", "X");
							mapOrientationXnew.setString("Pattern", tslDialog.propString(12));
							
							String sColor=tslDialog.propString(13);
							int nColor=sColor.atoi();
							mapOrientationXnew.setInt("Color", nColor);
							
							String sTransparency=tslDialog.propString(14);
							int nTransparency=sTransparency.atoi();
							mapOrientationXnew.setInt("Transparency", nTransparency);
							String sAngle=tslDialog.propString(15);
							double dAngle=sAngle.atof();
							mapOrientationXnew.setDouble("Angle", dAngle);
							String sScale=tslDialog.propString(16);
							double dScale=sScale.atof();
							mapOrientationXnew.setDouble("Scale", dScale);
							String sScaleMin=tslDialog.propString(17);
							double dScaleMin=sScaleMin.atof();
							mapOrientationXnew.setDouble("ScaleMin",dScaleMin);
							mapOrientationXnew.setInt("Static", !sHatchModes.find(tslDialog.propString(18)));
//							mapOrientationSelectedNew.setInt("Insulation", sNoYes.find(tslDialog.propString(10)));
						}
	//				 	mapOrientationYnew
						{ 
							mapOrientationYnew.setMapKey("Orientation");
							mapOrientationYnew.setString("Name", "Y");
							mapOrientationYnew.setString("Pattern", tslDialog.propString(20));
							String sColor=tslDialog.propString(21);
							int nColor=sColor.atoi();
							mapOrientationYnew.setInt("Color",nColor);
							String sTransparency=tslDialog.propString(22);
							int nTransparency=sTransparency.atoi();
							mapOrientationYnew.setInt("Transparency",nTransparency);
							String sAngle=tslDialog.propString(23);
							double dAngle=sAngle.atof();
							mapOrientationYnew.setDouble("Angle",dAngle);
							String sScale=tslDialog.propString(24);
							double dScale=sScale.atof();
							mapOrientationYnew.setDouble("Scale", dScale);
							String sScaleMin=tslDialog.propString(25);
							double dScaleMin=sScaleMin.atof();
							mapOrientationYnew.setDouble("ScaleMin", dScaleMin);
							mapOrientationYnew.setInt("Static", !sHatchModes.find(tslDialog.propString(26)));
//							mapOrientationSelectedNew.setInt("Insulation", sNoYes.find(tslDialog.propString(14)));
						}
//				 	mapOrientationZnew
						{ 
							mapOrientationZnew.setMapKey("Orientation");
							mapOrientationZnew.setString("Name", "Z");
							mapOrientationZnew.setString("Pattern", tslDialog.propString(28));
							String sColor=tslDialog.propString(29);
							int nColor=sColor.atoi();
							mapOrientationZnew.setInt("Color", nColor);
							String sTransparency=tslDialog.propString(30);
							int nTransparency=sTransparency.atoi();
							mapOrientationZnew.setInt("Transparency", nTransparency);
							String sAngle=tslDialog.propString(31);
							double dAngle=sAngle.atof();
							mapOrientationZnew.setDouble("Angle", dAngle);
							String sScale=tslDialog.propString(32);
							double dScale=sScale.atof();
							mapOrientationZnew.setDouble("Scale", dScale);
							String sScaleMin=tslDialog.propString(33);
							double dScaleMin=sScaleMin.atof();
							mapOrientationZnew.setDouble("ScaleMin", dScaleMin);
							mapOrientationZnew.setInt("Static", !sHatchModes.find(tslDialog.propString(34)));
//							mapOrientationSelectedNew.setInt("Insulation", sNoYes.find(tslDialog.propString(18)));
						}
						
					// hatch add
						mapOrientationsNew.appendMap("Orientation", mapOrientationXnew);
						mapOrientationsNew.appendMap("Orientation", mapOrientationYnew);
						mapOrientationsNew.appendMap("Orientation", mapOrientationZnew);
						
						mapHatchesNew.setMapKey("Hatch[]");
						
						mapHatchNew.setMapKey("Hatch");
						if(bPainterGroup)
						{ 
							String sName=tslDialog.propString(0);
							String sNames[]=sName.tokenize("-");
							if(sNames.length()>1)
								mapHatchNew.setString("PainterGroup",sNames[1]);
						}
						mapHatchNew.setInt("isActive", sNoYes.find(tslDialog.propString(1)));
						mapHatchNew.setString("Name", tslDialog.propString(0));
						if(nHatchMapping==1)
							mapHatchNew.setString("Painter", sRule);
						mapHatchNew.setInt("Anisotropic", sNoYes.find(tslDialog.propString(2)));
						
						mapHatchNew.appendMap("Material[]", mapMaterialsNew);
						mapHatchNew.appendMap("Contour", mapContourNew);
						mapHatchNew.setInt("SolidHatch", sNoYes.find(tslDialog.propString(8)));
						String sTransparency=tslDialog.propString(9);
						int nTransparency=sTransparency.atoi();
						mapHatchNew.setInt("SolidTransparency", nTransparency);
						String sColor=tslDialog.propString(10);
						int nColor=sColor.atoi();
						mapHatchNew.setInt("SolidColor", nColor);
						mapHatchNew.appendMap("Orientation[]", mapOrientationsNew);
						for (int iH=0;iH<mapHatches.length();iH++) 
						{ 
							Map mapHi = mapHatches.getMap(iH);
							mapHatchesNew.appendMap("Hatch", mapHi);
						}//next iH
						// add the new hatch
						mapHatchesNew.appendMap("Hatch", mapHatchNew);
					}
					
					Map mapGeneral = mapSetting.getMap("GeneralMapObject");
					Map mapSettingNew;
					mapSettingNew.setMapKey("root");
					mapSettingNew.appendMap("Hatch[]", mapHatchesNew);
					mapSettingNew.appendMap("GeneralMapObject", mapGeneral);
					if(mo.bIsValid())
						mo.setMap(mapSettingNew);
					else 
						mo.dbCreate(mapSettingNew);
				}// bok
				tslDialog.dbErase();
			}// tsl.bisvalid
		}// if(nMapSelected || mapHatchesSelected.length()>0)
		
		setExecutionLoops(2);
		return;
	}//endregion
	
//region Trigger ImportSettings
// HSB-15941
if (findFile(sFullPath).length()>0)
{ 
	String sTriggerImportSettings = T("|Import Settings|");
	addRecalcTrigger(_kContext, sTriggerImportSettings );
	if (_bOnRecalc && _kExecuteKey==sTriggerImportSettings)
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
		
		setExecutionLoops(2);
		return;
	}//endregion	
}
// Trigger ExportSettings
// HSB-15941
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
				if (findFile(sFullPath).length()>0) reportMessage(TN("|Settings successfully exported to| ") + sFullPath);
				else reportMessage(TN("|Failed to write to| ") + sFullPath);
			}
			
			setExecutionLoops(2);
			return;
		}
	}
	//endregion 
// HSB-15941
	//region Trigger MigrateSettings
//		String sTriggerMigrateSettings = T("|Migrate Settings|");
//		addRecalcTrigger(_kContext, sTriggerMigrateSettings );
//		if (_bOnRecalc && _kExecuteKey==sTriggerMigrateSettings)
//		{
//			String sFile = findFile(sPathGeneral + sFileName + ".xml");
//			if(sFile.length()>0)
//			{ 
//				String sFile=findFile(sPathGeneral+sFileName+".xml");
//				Map mapHatches = mapSetting.getMap("Hatch[]");
//				Map mapSettingInstall; mapSettingInstall.readFromXmlFile(sFile);
//				// new hatches after migration
//				Map mapHatchesNew;
//				mapHatchesNew.setMapKey("Hatch[]");
//				// get the default map, make sure to import the missing properties
//				Map mapHatchInstall, mapContourInstall,mapOrientationsInstall;// muster hatch
//				{ 
//					Map mapHatchesInstall = mapSettingInstall.getMap("Hatch[]");
//					if(mapHatchesInstall.length()==0)
//					{ 
//						reportMessage("\n"+scriptName()+" "+T("|Unexpected: No Hatch definition in installation directory|"));
//						reportMessage("\n"+scriptName()+" "+T("|Please report hsbcad|"));
//						
//					}
//					mapHatchInstall = mapHatchesInstall.getMap(0);
//					mapContourInstall=mapHatchInstall.getMap("Contour");
//					mapOrientationsInstall=mapHatchInstall.getMap("Orientation[]");
//				}
//				Map mapGeneral = mapSettingInstall.getMap("GeneralMapObject");
//				// hatch 
//				String sHatchDoubleNames[]={ };
//				String sHatchStringNames[]={"Name"};
//				String sHatchIntNames[]={"isActive","Anisotropic","SolidHatch",
//					"SolidTransparency","SolidColor"};
//				// contour
//				String sContourDoubleNames[]={"Thickness"};
//				String sContourStringNames[]={ };
//				String sContourIntNames[]={"Contour","Color","SupressBeamCross"};
//				// orientation
//				String sOrientationDoubleNames[]={"Angle","Scale","ScaleMin"};
//				String sOrientationStringNames[]={"Name","Pattern"};
//				String sOrientationIntNames[]={"Color","Transparency","Static"};
//				for (int iH=0;iH<mapHatches.length();iH++)
//				{ 
//					Map mapHi=mapHatches.getMap(iH);
//					Map mapHiNew,mapContouriNew,mapOrientationsiNew;
//					
//					mapHiNew.setMapKey("Hatch");
//					for (int ii=0;ii<sHatchDoubleNames.length();ii++) 
//					{ 
//						String sii = sHatchDoubleNames[ii];
//						if(mapHi.hasDouble(sii))
//						{ 
//							mapHiNew.setDouble(sii,mapHi.getDouble(sii));
//						}
//						else
//						{ 
//							mapHiNew.setDouble(sii,mapHatchInstall.getDouble(sii));
//						}
//					}//next ii
//					for (int ii=0;ii<sHatchStringNames.length();ii++) 
//					{ 
//						String sii = sHatchStringNames[ii];
//						if(mapHi.hasString(sii))
//						{ 
//							mapHiNew.setString(sii,mapHi.getString(sii));
//						}
//						else
//						{ 
//							mapHiNew.setString(sii,mapHatchInstall.getString(sii));
//						}
//					}//next ii
//					for (int ii=0;ii<sHatchIntNames.length();ii++) 
//					{ 
//						String sii = sHatchIntNames[ii];
//						if(mapHi.hasInt(sii))
//						{ 
//							mapHiNew.setInt(sii,mapHi.getInt(sii));
//						}
//						else
//						{ 
//							mapHiNew.setInt(sii,mapHatchInstall.getInt(sii));
//						}
//					}//next ii
//					
//					Map mapMaterialsI=mapHi.getMap("Material[]");
//					mapHiNew.appendMap("Material[]", mapMaterialsI);
//					Map mapContourI=mapHi.getMap("Contour");
//					
//					mapContouriNew.setMapKey("Contour");
//					for (int ii=0;ii<sContourDoubleNames.length();ii++) 
//					{ 
//						String sii = sContourDoubleNames[ii];
//						if(mapContourI.hasDouble(sii))
//						{ 
//							mapContouriNew.setDouble(sii,mapContourI.getDouble(sii));
//						}
//						else
//						{ 
//							mapContouriNew.setDouble(sii,mapContourInstall.getDouble(sii));
//						}
//					}//next ii
//					for (int ii=0;ii<sContourStringNames.length();ii++) 
//					{ 
//						String sii = sContourStringNames[ii];
//						if(mapContourI.hasString(sii))
//						{ 
//							mapContouriNew.setString(sii,mapContourI.getString(sii));
//						}
//						else
//						{ 
//							mapContouriNew.setString(sii,mapContourInstall.getString(sii));
//						}
//					}//next ii
//					for (int ii=0;ii<sContourIntNames.length();ii++) 
//					{ 
//						String sii = sContourIntNames[ii];
//						if(mapContourI.hasInt(sii))
//						{ 
//							mapContouriNew.setInt(sii,mapContourI.getInt(sii));
//						}
//						else
//						{ 
//							mapContouriNew.setInt(sii,mapContourInstall.getInt(sii));
//						}
//					}//next ii
//					
//					mapHiNew.appendMap("Contour", mapContouriNew);
//					
//					Map mapOrientationsI=mapHi.getMap("Orientation[]");
//					mapOrientationsiNew.setMapKey("Orientation[]");
//					for (int io=0;io<mapOrientationsInstall.length();io++) 
//					{ 
//						Map mapOrientationiNew;
//						mapOrientationiNew.setMapKey("Orientation");
//						Map mapOrientationInstall = mapOrientationsInstall.getMap(io);
//						Map mapOrientationI = mapOrientationsI.getMap(io);
//						for (int ii=0;ii<sOrientationDoubleNames.length();ii++) 
//						{ 
//							String sii = sOrientationDoubleNames[ii];
//							if(mapOrientationI.hasDouble(sii))
//							{ 
//								mapOrientationiNew.setDouble(sii,mapOrientationI.getDouble(sii));
//							}
//							else
//							{ 
//								mapOrientationiNew.setDouble(sii,mapOrientationInstall.getDouble(sii));
//							}
//						}//next ii
//						for (int ii=0;ii<sOrientationStringNames.length();ii++) 
//						{ 
//							String sii = sOrientationStringNames[ii];
//							if(mapOrientationI.hasString(sii))
//							{ 
//								mapOrientationiNew.setString(sii,mapOrientationI.getString(sii));
//							}
//							else
//							{ 
//								mapOrientationiNew.setString(sii,mapOrientationInstall.getString(sii));
//							}
//						}//next ii
//						for (int ii=0;ii<sOrientationIntNames.length();ii++) 
//						{ 
//							String sii = sOrientationIntNames[ii];
//							if(mapOrientationI.hasInt(sii))
//							{ 
//								mapOrientationiNew.setInt(sii,mapOrientationI.getInt(sii));
//							}
//							else
//							{ 
//								mapOrientationiNew.setInt(sii,mapOrientationInstall.getInt(sii));
//							}
//						}//next ii
//						
//						mapOrientationsiNew.appendMap("Orientation",mapOrientationiNew);
//					}//next io
//					mapHiNew.appendMap("Orientation[]", mapOrientationsiNew);
//					mapHatchesNew.appendMap("Hatch", mapHiNew);
//				}//next iH
//				Map mapSettingNew;
//				mapSettingNew.setMapKey("root");
//				mapSettingNew.appendMap("Hatch[]", mapHatchesNew);
//				mapSettingNew.appendMap("GeneralMapObject", mapGeneral);
//				if(mo.bIsValid())
//					mo.setMap(mapSettingNew);
//				else 
//					mo.dbCreate(mapSettingNew);
//					
//				reportNotice(TN("|Migration of new parameters done.|")+" "+
//				TN("|Settings were updated successfuly from|")+" "+sPathGeneral);
//			}
//			setExecutionLoops(2);
//			return;
//		}//endregion

{ 
	
	// create TSL
	TslInst tslDialog; 			Map mapTsl;						
	GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };
	
//	String sFolders[]=getFoldersInFolder(sPath); 

//region Trigger GlobalSettings
	addRecalcTrigger(_kContext, sTriggerGlobalSetting);
	if (_bOnRecalc && _kExecuteKey==sTriggerGlobalSetting)	
	{ 
		mapTsl.setInt("DialogMode",4);
		
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
}

//End Dialog Trigger//endregion 
	

//region Maps for collecting all entities and their hatches
	// and also all hatches and their entities
	// HSB-16741
	String sOrientations[]={"X","Y","Z"};
	Map mapEntitiesUsed;
	// mapEntitiesUsed keeps all maps for all entities
	// one map keeps entity, orientation, index of hatch
	// one entity can be connected up to 5 hatches (SIP 5 layers)
//End Maps for collecting all entities and their hatches//endregion 
	
//region collect entities to be hatched and save in _Map
	// HSB-10159
	
	Entity entsHatch[0];
	Map mapHatchesUsed;
	String sHatchIdentifiers[0];
// HSB-16741
	// one entity can have up to 5 hatches (SIP with 5 layers)
//	// index at the mapHatches
//	int nIndexHatchesUsed0[0],nIndexHatchesUsed1[0],nIndexHatchesUsed2[0],
//		nIndexHatchesUsed3[0],nIndexHatchesUsed4[0];
//	//index of orientation 0->X; 1->Y; 2->Z
//	int nOrientationUsed0[0],nOrientationUsed1[0],nOrientationUsed2[0],
//		nOrientationUsed3[0],nOrientationUsed4[0];
	
//End collect entities to be hatched and save in _Map//endregion 

//region Initialize data for drawing hatch in a sorted way when transparency 0
	int bTransparency0=dGlobalTransparency==0;
	// extreme top point of body
	Point3d ptTops[0];
	// body center points
	Point3d ptCensT[0];
	// planeprofiles
	PlaneProfile ppsStaticT[0];
	int nColorsT[0];
	int nTransparencysT[0];
	String sHatchPatternsT[0];
	double dAnglesT[0];
	double dScaleFacsT[0];
	double dScaleMinsT[0];
	// 
	Body bdsT[0];
	// contour planeprofiles
	Map mapContoursT;
	int nColorContoursT[0];
	// solid properties
	int bHasSolidColorsT[0];
	int nSolidColorsT[0];
	int _nSolidTransparencysT[0];

	int nHatchesUsed[0];
//	int nInrLimit = 200;
	
	
// get dMin from all hatches
// dMin will be taken as the largest dMin of all hatches
	double dMinAll;
	PlaneProfile ppsDynamic[0],ppsDynamicT[0];
	double dMinsDynamic[0],dMinsDynamicT[0];
	Display dpsDynamic[0],dpsDynamicT[0];
	int nColorsDynamic[0],nColorsDynamicT[0];
	int nTransparencysDynamic[0],nTransparencysDynamicT[0];
	double dScaleFacsDynamic[0],dScaleFacsDynamicT[0];
	double dScaleMinsDynamic[0],dScaleMinsDynamicT[0];
	String sHatchPatternsDynamic[0],sHatchPatternsDynamicT[0];
	double dAnglesDynamic[0],dAnglesDynamicT[0];
//End Initialize data for drawing hatch in a sorted way when transparency 0//endregion 

//region hatch panels/SIPS
	if (!bByPainter || bIsSipPainter)
	for (int i = 0; i < sips.length(); i++)
	{ 
		Sip& sip = sips[i];
		if (bByPainter && !sip.acceptObject(painter.filter())){ continue;}
		// HSB-15528
		if ( ! sip.isVisible())continue;
		Group grps[] = sip.groups();
		int bOff=true;
		for (int igrp=0;igrp<grps.length();igrp++) 
		{ 
			if(grps[igrp].groupVisibility(false)==_kIsOn)
			{ 
				bOff = false;
				break;
			}
		}//next igrp
		if (grps.length() == 0)bOff = false;
		if (bOff)continue;
		if (sip.bIsDummy())continue;
	// HSB-14361 get all analysed tools
		AnalysedTool tools[] = sip.analysedTools();
		AnalysedBeamCut beamcuts[] = AnalysedBeamCut().filterToolsOfToolType(tools);
		AnalysedDoubleCut doubleCuts[] = AnalysedDoubleCut().filterToolsOfToolType(tools);
		AnalysedMortise mortises[] = AnalysedMortise().filterToolsOfToolType(tools);
		AnalysedRabbet rabbets[] = AnalysedRabbet().filterToolsOfToolType(tools);
		AnalysedSlot slots[] = AnalysedSlot().filterToolsOfToolType(tools);
		AnalysedHouse houses[] = AnalysedHouse().filterToolsOfToolType(tools);
		AnalysedDrill drills[] = AnalysedDrill().filterToolsOfToolType(tools);
		AnalysedCut cuts[] = AnalysedCut().filterToolsOfToolType(tools);
		AnalysedFreeProfile freeProfiles[] = AnalysedFreeProfile().filterToolsOfToolType(tools);
		AnalysedPropellerSurface propellerSurfaces[] = AnalysedPropellerSurface().filterToolsOfToolType(tools);
		Vector3d vecView = csSection.vecZ();
		Body bdSipModel = sip.envelopeBody();
		Body bdSip = bdSipModel;
		CoordSys csCollectionTransform;
		int nCollectionTransform = false;
		if(nSipsCollection[i]>-1)
		{ 
			csCollectionTransform=csCollections[nSipsCollection[i]];
			nCollectionTransform=true;
		}
		if (nCollectionTransform)
		{
			bdSip.transformBy(csCollectionTransform);
		}
		bdSip.intersectWith(bdClip);
		Body bdSipReal = sip.realBody();
		if (nCollectionTransform)
		{
			bdSipReal.transformBy(csCollectionTransform);
		}
		bdSipReal.intersectWith(bdClip);
		Body bdTools = bdSip;
		PlaneProfile ppOverride(pn0);
		for (int t = 0; t < drills.length(); t++)
		{
			AnalysedDrill b = drills[t];
			Vector3d vecDrill = b.vecFree();
			int bThrough = b.bThrough();
			Point3d ptDr1 = b.ptStartExtreme();
			Point3d ptDr2 = b.ptEndExtreme();
			if (bThrough)
			{
				// HSB-13697
				Vector3d vecDr = ptDr2 - ptDr1;
				vecDr.normalize();
				ptDr1 -= vecDr * U(100);
				ptDr2 += vecDr * U(100);
			}
			Drill dr(ptDr1, ptDr2, b.dRadius());
			bdTools.addTool(dr);
		}
		for (int t = 0; t < beamcuts.length(); t++)
		{
			AnalysedBeamCut b = beamcuts[t];
			bdTools.subPart(b.cuttingBody());
		}
		for (int t = 0; t < houses.length(); t++)
		{
			AnalysedHouse b = houses[t];
			bdTools.subPart(b.cuttingBody());
		}
		bdTools.vis(3);
		LineSeg segsSip[0];
		{ 
			int bShowHiddenLines = false;
			int bShowOnlyHiddenLines = false;
			int bShowApproximatingEdges = false;
			CoordSys csView = csSection;
			segsSip= bdTools.hideDisplay(csView, bShowHiddenLines, bShowOnlyHiddenLines, bShowApproximatingEdges);
			segsSip= pn0.projectLineSegs(segsSip);
			if(bdSipReal.volume()>pow(dEps,3))
			{
				LineSeg segs[]=bdSipReal.hideDisplay(csView, bShowHiddenLines, bShowOnlyHiddenLines, bShowApproximatingEdges);
				segs= pn0.projectLineSegs(segs);
//				for (int iseg=0;iseg<segs.length();iseg++) 
//				{ 
//					segs[iseg].vis(1);
//				}//next iseg
				
				segsSip.append(segs);
			}
		}
		for (int iseg=0;iseg<segsSip.length();iseg++) 
		{ 
			segsSip[iseg].transformBy(ms2ps);
			if (nCollectionTransform)
			{ 
				segsSip[iseg].transformBy(csCollectionTransform);
			}
		}//next iseg
//		sip.envelopeBody().vis(2);
		// get the sip style
		SipStyle ss = sip.style();
		int nNumComp = ss.numSipComponents();
		SipComponent sComps[] = ss.sipComponents();
		Vector3d vecWoodGrainDirection = sip.woodGrainDirection();
		
		if (vecWoodGrainDirection.length() < 1)
		{ 
			// woodGrainDirection is not set
			// set as grain direction the vecX of the panel
			vecWoodGrainDirection = sip.vecX();
		}
		
		Vector3d vecNormalWoodGrainDirection = sip.vecZ().crossProduct(vecWoodGrainDirection);
		Vector3d vecZPanel = sip.vecZ();
		
		vecWoodGrainDirection.vis(sip.ptCen(), 1);
		vecNormalWoodGrainDirection.vis(sip.ptCen(), 3);
		vecZPanel.vis(sip.ptCen(), 150);
		
		// transform to the section coordinate system
		if (nCollectionTransform)
		{ 
			vecWoodGrainDirection.transformBy(csCollectionTransform);
			vecNormalWoodGrainDirection.transformBy(csCollectionTransform);
			vecZPanel.transformBy(csCollectionTransform);
		}
		vecWoodGrainDirection.transformBy(ms2ps);
		vecNormalWoodGrainDirection.transformBy(ms2ps);
		vecZPanel.transformBy(ms2ps);
		
		vecWoodGrainDirection.vis(sip.ptCen() + _XW * U(4000), 1);
		vecNormalWoodGrainDirection.vis(sip.ptCen() + _XW * U(4000), 3);
		vecZPanel.vis(sip.ptCen() + _XW * U(4000), 150);
		
		// we will accept that vecWoodGrainDirection is defined by the direction of external components
		// get the material and find the corresponding hatch for each component
		int bHasWoodDir = false;
		
		Map mapEntityI;mapEntityI.setEntity("ent", sip);
		
		String sMaterialSip=sip.material();
		
		// loop panel components
		Point3d ptComp=sip.ptCen()+sip.vecZ()*.5*sip.dH();
		for (int j = 0; j < sComps.length(); j++)
		{ 
//			if (j != 1)continue;
			// component 0,2,4,6 have woodGrainDirection as the Panel graindirecrion
			// components 1,3,5 have the normal to it
			bHasWoodDir =! bHasWoodDir;
			Vector3d vecWoodGrainDirectionJ = vecWoodGrainDirection;
			Vector3d vecNormalWoodGrainDirectionJ = vecNormalWoodGrainDirection;
			if ( ! bHasWoodDir)
			{ 
				vecWoodGrainDirectionJ = vecNormalWoodGrainDirection;
				vecNormalWoodGrainDirectionJ = vecWoodGrainDirection;
			}
//			vecWoodGrainDirectionJ.vis(sip.ptCen(), 1);
//			vecNormalWoodGrainDirectionJ.vis(sip.ptCen(), 2);
//			vecZPanel.vis(sip.ptCen(), 2);
			
			// find the mos aligned vector with the _ZW
			String sOrientation = "X";
			if (abs(_ZW.dotProduct(vecNormalWoodGrainDirectionJ)) > abs(_ZW.dotProduct(vecWoodGrainDirectionJ))
			 && abs(_ZW.dotProduct(vecNormalWoodGrainDirectionJ)) > abs(_ZW.dotProduct(vecZPanel)))
			{ 
				// most aligned with the normal vector 
				sOrientation = "Y";
			}
			else if (abs(_ZW.dotProduct(vecZPanel)) > abs(_ZW.dotProduct(vecWoodGrainDirectionJ))
			 	  && abs(_ZW.dotProduct(vecZPanel)) > abs(_ZW.dotProduct(vecNormalWoodGrainDirectionJ)))
			{ 
				// most aligned with the normal vector 
				sOrientation = "Z";
			}
			// find the vector that gives the direction of panel and project to _XY plane
			Vector3d vecDir;
			if (sOrientation == "X")
			{ 
				// vecWoodGrainDirectionJ most aligned with _ZW
//				vecDir = _ZW.crossProduct(vecNormalWoodGrainDirectionJ);
//				vecDir.normalize();
//				vecDir = _ZW.crossProduct(vecDir);
//				if (vecDir.length() < dEps)
//				{ 
//					reportMessage(TN("|unexpected error 1010|"));
//					eraseInstance();
//					return;
//				}
//				vecDir.normalize();
				vecDir = vecWoodGrainDirection;
			}
			else if (sOrientation == "Y" || sOrientation == "Z")
			{ 
				// vecNormalWoodGrainDirectionJ most aligned with _ZW
//				vecDir = _ZW.crossProduct(vecWoodGrainDirectionJ);
//				vecDir.normalize();
//				vecDir = _ZW.crossProduct(vecDir);
				if(sOrientation=="Y")
					vecDir = vecNormalWoodGrainDirection;
				else if(sOrientation=="Z")
					vecDir = vecZPanel;
			}
//			vecDir.vis(sip.ptCen() + _XW * U(4000), 150);
			
			// store orientation
			mapEntityI.setString("orientation0",sOrientation);
//			if(j==0)
//				mapEntityI.setString("orientation0",sOrientation);
//			else if(j==1)
//				mapEntityI.setString("orientation1",sOrientation);
//			else if(j==2)
//				mapEntityI.setString("orientation2",sOrientation);
//			else if(j==3)
//				mapEntityI.setString("orientation3",sOrientation);
//			else if(j==4)
//				mapEntityI.setString("orientation4",sOrientation);
			if(nCollectionTransform)
			{ 
				mapEntityI.setPoint3d("ptOrgTransform",csCollectionTransform.ptOrg());
				mapEntityI.setVector3d("vecXTransform",csCollectionTransform.vecX());
				mapEntityI.setVector3d("vecYTransform",csCollectionTransform.vecY());
				mapEntityI.setVector3d("vecZTransform",csCollectionTransform.vecZ());
			}
			// rotation wrt local axis
			double dRotation;
//			dRotation= _XW.angleTo(vecDir, _ZW);
			// angle between _ZW and vecDir
			Vector3d vecDirZw = vecDir.crossProduct(_ZW);
			vecDirZw.normalize();
			dRotation = vecDir.angleTo(_ZW, vecDirZw);
			
			SipComponent sComp = sComps[j];
			String sMaterial = sComp.material();
			if(sComps.length()==1 && sMaterial=="")
				sMaterial=sMaterialSip;
			Body bd = sip.realBodyOfComponentAt(j);
			
			
			
//			Body bdEnv=Body(bd.ptCen(), sip.vecX(), sip.vecY(), sip.vecZ(), 
//				bd.lengthInDirection(sip.vecX()), bd.lengthInDirection(sip.vecY()), bd.lengthInDirection(sip.vecZ()));
			
//			bdClip.vis(3);
//			bd.vis(2);
//			bdClip.vis(3);
			Body bdIntersect = bd;
			int bIntersect=bdIntersect.intersectWith(bdClip);
			
			bdIntersect.vis(4);
			// find out if the realbody intersection operation fails
			// bdClip is usually cuboid
			if (bd.volume() < pow(dEps,3))
			{ 
				// no body could be generated, continue next component j
				continue;
			}
			// for panels provide the component body
			// calc bdComp from bdSipModel
			double dHcomp=sComp.dThickness();
			Body bdComp;
			{ 
				Body bdCompLarge(ptComp,sip.vecX(),sip.vecY(),sip.vecZ(),U(10e7),U(10e7),dHcomp,
				0,0,-1);
				bdComp=bdSipModel;
				bdComp.intersectWith(bdCompLarge);
			}
			ptComp-=sip.vecZ()*dHcomp;
			mapEntityI.setBody("bdComp", bdComp);
			// check the intersection operation, if it hasintersection,
			// the intersection should appear on all sides xy,yz, zx
			int bHasIntersection = false;
			PlaneProfile ppIntersect;
//			LineSeg segsVis[0];
			if (bHasSection)
			{ 
				if(bIntersect && bdIntersect.volume()>pow(dEps,3))
				{ 
					ppIntersect = bdIntersect.shadowProfile(pn0);
//					ppIntersect = bdIntersect.extractContactFaceInPlane(pn0,dSectionDepth);
//					int bShowHiddenLines = false;
//					int bShowOnlyHiddenLines = false;
//					int bShowApproximatingEdges = false;
//					CoordSys csView = csSection;
//					csView=CoordSys(csSection.ptOrg()-csSection.vecZ()*dSectionDepth, 
//						csSection.vecX(), csSection.vecY(), csSection.vecZ());
					// HSB-14361:
//					segsVis= bdIntersect.hideDisplay(csView, bShowHiddenLines, bShowOnlyHiddenLines, bShowApproximatingEdges);
//					for (int iseg=0;iseg<segsVis.length();iseg++) 
//					{ 
//						segsVis[iseg].vis(1); 
//					}//next iseg
//					segsVis= pn0.projectLineSegs(segsVis);
					ppIntersect.vis(4);
				}
				else
				{ 
					// for section in model space
	//				CoordSys csSection = section.coordSys();
	//				csSection.transformBy(ps2ms);
					// vector normal with the viewport
	//				Vector3d vecNormal = csSection.vecZ();
	//				vecNormal.vis(_PtG[0], 6);
	//				Plane pn0(_PtG[0], vecNormal);
	//				Plane pn1(_PtG[1], vecNormal);
	//				bd.vis(3);
	//				PlaneProfile pptest = bd.extractContactFaceInPlane(pn0,U(1));
	//				pn0.vis(4);
					double dvolbd = bd.volume();
	//				double dAreatt = pptest.area();
					PlaneProfile ppBd0 = bd.getSlice(pn0);
					PlaneProfile ppBd1 = bd.getSlice(pn1);
					
					// sometimes the body intersection between entity and the clipping fails
					// 1. the body intersects with one of the bounding sections
					// 2. the body is all inside the the clipping volume
					// 3. the body is outside the clipping volume, no section to hatch
					
	//				if (ppBd0.area() < dEps && ppBd1.area() < dEps)
	//				{ 
	//					// no intersection, go to next component
	//					continue;
	//				}
					// HSB-13956:
					int nScenario=-1;
					if(ppBd0.area()>pow(dEps,2) || ppBd1.area()>pow(dEps,2))
					{ 
						// 1.
						nScenario = 1;
					}
					else
					{ 
						// 2. or 3.
						// create sections between pn0 and pn1 and check whether it cuts the body
						Point3d ptCenBd = bd.ptCen();
						ptCenBd.vis(6);
						// point ptCenBd inside 2 points pt1 and pt2
						int bInside=true;
						{ 
							Vector3d vecDir = vecNormal;
							vecDir.normalize();
							double dLengthPtI=abs(vecDir.dotProduct(ptCenBd-pt1))
								 + abs(vecDir.dotProduct(ptCenBd - pt2));
							double dLengthSeg = abs(vecDir.dotProduct(pt1 - pt2));
							if (abs(dLengthPtI - dLengthSeg) > dEps)bInside=false;
						}
						if(bInside)
						{
							Plane pnCen(ptCenBd, vecNormal);
							PlaneProfile ppCen = bd.getSlice(pnCen);
							if (ppCen.area() > pow(dEps, 2))
							{
								ppBd0 = ppCen;
								nScenario = 2;
							}
						}
					}
					if(nScenario==-1)
						continue;
					// there is an intersection
					bHasIntersection = true;
					
					PlaneProfile ppBdShadow = bd.shadowProfile(pn0);
					ppBdShadow.vis(3);
					
	//				PlaneProfile ppBdClipShadow = bdClip.shadowProfile(pn0);
	//				ppBdClipShadow.vis(3);
					
					// intersection of ppBdShadow and ppBdClipShadow
					ppIntersect = ppBdShadow;
					ppIntersect.intersectWith(ppBdClipShadow);
					// HSB-11469
					PlaneProfile ppBdUnion = ppBd0; ppBdUnion.unionWith(ppBd1);
					ppIntersect.intersectWith(ppBdUnion);
				}
				// transform from clip to section
				ppIntersect.transformBy(ms2ps);
//				for (int iseg=0;iseg<segsVis.length();iseg++) 
//				{ 
//					segsVis[iseg].transformBy(ms2ps); 
//				}//next iseg
			}
			else
			{ 
				// viewport in layout or viewport in shopdraw
				// transfor from model to layout
				bd.transformBy(ms2ps);
				bdIntersect = bd;
				
				bdIntersect.vis(1);
				bdClip.vis(2);
				
				bIntersect=bdIntersect.intersectWith(bdClip);
				if(bIntersect && bdIntersect.volume()>pow(dEps,3))
				{ 
					ppIntersect = bdIntersect.shadowProfile(pn0);
	//					ppIntersect = bdIntersect.extractContactFaceInPlane(pn0,dSectionDepth);
					int bShowHiddenLines = false;
					int bShowOnlyHiddenLines = false;
					int bShowApproximatingEdges = false;
					CoordSys csView = csSection;
	//					csView=CoordSys(csSection.ptOrg()-csSection.vecZ()*dSectionDepth, 
	//						csSection.vecX(), csSection.vecY(), csSection.vecZ());
	//					csView.vis(1);
					segsSip= bdIntersect.hideDisplay(csView, bShowHiddenLines, bShowOnlyHiddenLines, bShowApproximatingEdges);
	//					for (int iseg=0;iseg<segsVis.length();iseg++) 
	//					{ 
	//						segsVis[iseg].vis(1); 
	//					}//next iseg
					segsSip= pn0.projectLineSegs(segsSip);
					ppIntersect.vis(3);
				}
				else
				{ 
					double dSectionLevelPaper;
					double dSectionDepthPaper;
					{ 
	//					// top point in the model
	//					Point3d pt1 = ptMaxModel - vecZModel * dSectionLevel;
	//					// bottom point in the model
	//					Point3d pt2 = pt1 - vecZModel * dSectionDepth;
	//					if (dSectionDepth < dEps)
	//					{ 
	//						pt2 = pt1 - vecZModel * dEps;
	//					}
	//					pt1.transformBy(ms2ps);
	//					pt2.transformBy(ms2ps);
						
	//					Plane pn0(pt1, _ZW);
	//					Plane pn1(pt2, _ZW);
						PlaneProfile ppBd0 = bd.getSlice(pn0);
						PlaneProfile ppBd1 = bd.getSlice(pn1);
						int nScenario=-1;
						if(ppBd0.area()>pow(dEps,2) || ppBd1.area()>pow(dEps,2))
						{ 
							// 1.
							nScenario = 1;
						}
						else
						{ 
							// 2. or 3.
							// create sections between pn0 and pn1 and check whether it cuts the body
							Point3d ptCenBd = bd.ptCen();
							// point ptCenBd inside 2 points pt1 and pt2
							int bInside=true;
							{ 
								Vector3d vecDir = vecNormal;
								vecDir.normalize();
								double dLengthPtI=abs(vecDir.dotProduct(ptCenBd-pt1))
									 + abs(vecDir.dotProduct(ptCenBd - pt2));
								double dLengthSeg = abs(vecDir.dotProduct(pt1 - pt2));
								if (abs(dLengthPtI - dLengthSeg) > dEps)bInside=false;
							}
							if(bInside)
							{
								Plane pnCen(ptCenBd, vecNormal);
								PlaneProfile ppCen = bd.getSlice(pnCen);
								if (ppCen.area() > pow(dEps, 2))
								{
									ppBd0 = ppCen;
									nScenario = 2;
								}
							}
						}
						if(nScenario==-1)
							continue;
						
						double dArea0 = ppBd0.area();
						double dArea1 = ppBd1.area();
						if (ppBd0.area() < pow(dEps, 2) && ppBd1.area() < pow(dEps, 2))
						{ 
							// no intersection, go to next component
							continue;
						}
						// there is an intersection
						bHasIntersection = true;
						
						PlaneProfile ppBdShadow = bd.shadowProfile(pn0);
						ppBdShadow.vis(3);
	//					PlaneProfile ppBdClipShadow = bdClip.shadowProfile(pn0);
						ppBdClipShadow.vis(3);
						
						// intersection of ppBdShadow and ppBdClipShadow
						// HSB-21655
						ppIntersect = ppBdShadow;
						PlaneProfile ppInter=ppIntersect;
						ppInter.shrink(U(1));
						ppInter.shrink(-U(1));
						ppInter.shrink(-U(1));
						ppInter.shrink(U(1));
						if(ppInter.intersectWith(ppBdClipShadow))
						{ 
							ppIntersect=ppInter;
						}
						else
						{ 
							PlaneProfile ppBdClipShadowExtend=ppBdClipShadow;
							ppBdClipShadowExtend.shrink(-U(5));
							ppInter=ppIntersect;
							if(ppInter.intersectWith(ppBdClipShadowExtend))
							{ 
								ppIntersect=ppInter;
							}
							
						}
//						ppIntersect.intersectWith(ppBdClipShadow);
						// HSB-11469
						PlaneProfile ppBdUnion = ppBd0; ppBdUnion.unionWith(ppBd1);
						ppIntersect.intersectWith(ppBdUnion);
						//
						ppIntersect.vis(5);
						// transform back to model
						bd.transformBy(ps2ms);
					}
				}
			}
			
//			if ( ! bHasSection)
//			{ 
//				// paperspace layout or block space shopdrawing
//				bd.transformBy(ms2ps);
//			}
//			double dVol = bd.volume();
//			bd.vis(1);
//			bd.intersectWith(bdClip);
//			bd.vis(5);
//			double dVolBd = bd.volume();
//			if (bHasSection)
//			{
//				// transform where the section is
//				bd.transformBy(ms2ps);
//			}
//			
//			PlaneProfile pp = bd.shadowProfile(Plane(_Pt0, vecZ));
//			double dAreaPp = pp.area();
			// HSB-10752:
			PlaneProfile pp = ppIntersect;
			if (pp.area() < pow(dEps, 2) && bHasIntersection)
			{ 
				// HSB-10752
//				reportMessage(TN("|3D body intersection not successful, it is replaced by intersection of planeprofiles|"));
				// get the planeprofile calculated from the planeprofiles
				pp = ppIntersect;
			}
			else if (pp.area() < dEps && !bHasIntersection)
			{ 
				// nothing to hatch, skip this "j" component
				continue;
			}
			pp.vis(3);
			int bMaterialFound = false;
		// get the map of the hatch for this material
			int bOrientationFound = false;
			Map mapHatchFound, mapOrientationFound;
			
			{ 
				Map mInHatchFind;
				mInHatchFind.setMap("mapHatches",mapHatches);
				mInHatchFind.setInt("nHatchMapping",nHatchMapping);
				mInHatchFind.setInt("bPainterGroup",bPainterGroup);
				mInHatchFind.setString("sMaterial",sMaterial);
//				mInHatchFind.setInt("indexJ",j);
				mInHatchFind.setString("sOrientation",sOrientation);
				mInHatchFind.setMap("mapHatchDefaultPainter",mapHatchDefaultPainter);
				mInHatchFind.setInt("nHatchDefaultPainterIndex",nHatchDefaultPainterIndex);
				mInHatchFind.setString("sRule",sRule);
				mInHatchFind.setEntity("ent",sip);
				mInHatchFind.setString("sPainterFormat",sPainterFormat);
				
				Map mOutHatchFind=getHatchDefinition(mInHatchFind,nHatchesUsed,mapEntityI);
				
				bMaterialFound=mOutHatchFind.getInt("bMaterialFound");
				bOrientationFound=mOutHatchFind.getInt("bOrientationFound");
				mapHatchFound=mOutHatchFind.getMap("mapHatchFound");
				mapOrientationFound=mOutHatchFind.getMap("mapOrientationFound");
				
			}
			
			// if material is found but orientation not found, skip the hatching
			if ( bMaterialFound && ! bOrientationFound)
			{ 
				// dont do the hatching, go to the next component
				// hatch for this material is not defined correctly
				continue;
			}
			
			if ( ! bMaterialFound && bMapHatchDefaultFound)
			{ 
				if (nHatchesUsed.find(nHatchDefaultIndex) < 0)nHatchesUsed.append(nHatchDefaultIndex);
				mapHatchFound = mapHatchDefault;
				bMaterialFound = true;
				if (nHatchesUsed.find(nHatchDefaultIndex) < 0)nHatchesUsed.append(nHatchDefaultIndex);
				mapEntityI.setInt("hatch0",nHatchDefaultIndex);
//				if(j==0)
//					mapEntityI.setInt("hatch0",nHatchDefaultIndex);
//				else if(j==1)
//					mapEntityI.setInt("hatch1",nHatchDefaultIndex);
//				else if(j==2)
//					mapEntityI.setInt("hatch2",nHatchDefaultIndex);
//				else if(j==3)
//					mapEntityI.setInt("hatch3",nHatchDefaultIndex);
//				else if(j==4)
//					mapEntityI.setInt("hatch4",nHatchDefaultIndex);
				
				int bAnisotropic = mapHatchFound.getInt("Anisotropic");
				
				// if the material is not found and a default hatch exists, use the default hatch
				Map mapOrientations = mapHatchDefault.getMap("Orientation[]");
				if (mapOrientations.length() < 1)
				{ 
					// no orientation map defined for this material 
					reportMessage("\n"+scriptName()+" "+T("|no map of orientation found for the material of the beam|"));
					eraseInstance();
					return;
				}
				bOrientationFound = false;
				if ( ! bAnisotropic)
				{
					for (int l = 0; l < mapOrientations.length(); l++)
					{ 
						Map mapOrientationL = mapOrientations.getMap(l);
						if (mapOrientationL.hasString("Name") && mapOrientations.keyAt(l).makeLower() == "orientation")
						{ 
							mapOrientationFound = mapOrientationL;
							bOrientationFound = true;
							break;
						}
					}//next l
				}
				else
				{ 
					// find the orientation for this component
					for (int l = 0; l < mapOrientations.length(); l++)
					{ 
						Map mapOrientationL = mapOrientations.getMap(l);
						if (mapOrientationL.hasString("Name") && mapOrientations.keyAt(l).makeLower() == "orientation")
						{ 
							String sOrientationMap = mapOrientationL.getString("Name");
							if (sOrientationMap.makeUpper() != sOrientation.makeUpper())
							{ 
								// not this orientation
								continue;
							}
							bOrientationFound = true;
							mapOrientationFound = mapOrientationL;
							break;
						}
					}//next l
				}
			}
			
			// if no material found and no default material
			if ( ! bMaterialFound || !bOrientationFound)
			{ 
				// go to next entity (panel component)
				continue;
			}
			// default values
			{ 
				nSolidHatch=0;
				nSolidTransparency = 0;
				nSolidColor = 0;
				bHasSolidColor = 0;
				// default orientation hatch parameters
				sPattern = "ANSI31";// hatch pattern
				nColor = 1;// color index
				nTransparency = 0;// transparency
				dAngle = 0;// hatch angle
				dScale = 10.0;// hatch scale
				dScaleMin = 25;// dScaleMin
				bStatic = 0;// by default make dynamic
				// contour parameters
				bContour = 0;
				nColorContour = 0;
				dContourThickness = 0;
			}
			// properties in hatch map
			{ 
				String ss;
				Map m = mapHatchFound;
				ss = "SolidHatch"; if(m.hasInt(ss)) 
				{
					nSolidHatch = m.getInt(ss);
					if(nSolidHatch<=0)
						nSolidHatch = 0;
					else
						nSolidHatch = 1;
				}
				ss = "SolidTransparency"; if(m.hasInt(ss)) nSolidTransparency = m.getInt(ss);
				ss = "SolidColor"; if(m.hasInt(ss)) nSolidColor = m.getInt(ss);
				ss = "SolidColor"; bHasSolidColor= m.hasInt(ss);
			}
			// properties in orientation map
			{ 
				String ss;
				Map m = mapOrientationFound;
				ss = "Pattern"; if(m.hasString(ss)) sPattern = m.getString(ss);
				ss = "Color"; if(m.hasInt(ss)) nColor = m.getInt(ss);
				ss = "Transparency"; if(m.hasInt(ss)) nTransparency = m.getInt(ss);
				ss = "Angle"; if(m.hasDouble(ss)) dAngle = m.getDouble(ss);
				ss = "Scale"; if(m.hasDouble(ss)) dScale = m.getDouble(ss);
				ss = "ScaleMin"; if(m.hasDouble(ss)) dScaleMin = m.getDouble(ss);
				ss = "Static"; if(m.hasInt(ss)) 
				{
					bStatic = m.getInt(ss);
					if(bStatic<=0)
						bStatic = 0;
					else
						bStatic = 1;
				}
				// insulation
				bInsulation = false;
				if (sPattern == sInsulation)bInsulation = true;
			}
			// properties in contour map
			Map mapContour = mapHatchFound.getMap("Contour");
			{ 
				String ss;
				Map m = mapContour;
				ss = "Contour"; if(m.hasInt(ss))
				{
					bContour = m.getInt(ss);
					if(bContour<=0)
						bContour = 0;
					else
						bContour = 1;
				}
				ss = "Color"; if(m.hasInt(ss)) nColorContour = m.getInt(ss);
				ss = "Thickness"; if(m.hasDouble(ss)) dContourThickness = m.getDouble(ss);
			}
			
		// adapt dScale and dScaleMin with the scale of viewport or shopdraw
//			dScale *= dScaleVP;
//			dScaleMin *= dScaleVP;
		// get extents of profile
			if(nPaperPlane)
			{ 
				PlaneProfile ppPaper(pnPaper);
				ppPaper.unionWith(pp);
				pp=PlaneProfile (pnPaper);
				pp.unionWith(ppPaper);
			}
			double dMin = U(10e7);
		// calculate min width rotating 0-180 by 10 degrees
			Vector3d vecXrotI = vecX;
			Vector3d vecYrotI = vecY;
			for (int irot=0;irot<17;irot++) 
			{ 
				LineSeg segI = pp.extentInDir(vecXrotI);
				double dXI=abs(vecXrotI.dotProduct(segI.ptStart()-segI.ptEnd()));
				if(dXI<dMin)dMin=dXI;
				vecXrotI=vecXrotI.rotateBy(U(10),vecZ);
			}//next irot
//			
			
//			LineSeg seg = pp.extentInDir(vecX);
//			double dX=abs(vecX.dotProduct(seg.ptStart() - seg.ptEnd()));
//			double dY=abs(vecY.dotProduct(seg.ptStart() - seg.ptEnd()));
//			double dMin=dX<dY?dX:dY;
			double dScaleFac = dScale;
			if (dScaleFac < 0.01)dScaleFac = 1;
	//		dp.color(b.color());
			double dScale0 = dScaleMin;
			if (bStatic)
			{
				// static, not adapted to the size, get the factor defined in dScale
				dScale0 = dScaleFac;
				if (dScale0 < dScaleMin)
				{ 
					dScale0 = dScaleMin;
				}
			}
			else
			{ 
				// dynamic, adapted to the minimum dimension
				// should not be smaller then dScaleMin
				dScale0=dScaleFac*dMin;
				if (dScale0<dScaleMin)
				{ 
					dScale0=dScaleMin;
				}
			}
			// multiply dScale0 with the global scaling factor
			dScale0 *= dGlobalScaling;
			// check the color
			// by layer and by block will set the color of the attached layer at the TSL
			if (nColor < 1)
			{ 
				// -2 by entity, -1 by layer, 0 by entity
				if (nColor == -2)
				{ 
					// get color from entity (beam) and use this for the hatch
					nColor = sip.color();
				}
				else if (nColor <- 2)
				{ 
					//nColor <- 2; -3,-4,-5 etc then take by entity
					nColor = - 2;
				}
			}
			if (nColorContour < 1)
			{ 
				// -2 by entity, -1 by layer, 0 by entity
				if (nColorContour == -2)
				{ 
					// get color from entity (beam) and use this for the hatch
					nColorContour = sip.color();
				}
				else if (nColorContour <- 2)
				{ 
					//nColor <- 2; -3,-4,-5 etc then take by entity
					nColorContour = - 2;
				}
			}
			if (nSolidColor < 1)
			{ 
				// -2 by entity, -1 by layer, 0 by entity
				if (nSolidColor == -2)
				{ 
					// get color from entity (beam) and use this for the hatch
					nSolidColor = sip.color();
				}
				else if (nSolidColor <- 2)
				{ 
					//nColor <- 2; -3,-4,-5 etc then take by entity
					nSolidColor = - 2;
				}
			}
			
			// draw the hatch for each component
			int nPattern = _HatchPatterns.findNoCase(sPattern, 0);
			sPattern = nPattern >- 1 ? _HatchPatterns[nPattern] : _HatchPatterns[0];
			// hatch object
			Hatch hatch(sPattern, dScale0);
			double dRotationTotal = dAngle + dRotation;
			
			//HSB - 11326 : transform to - 90;90; HSB-15895
			if(dRotationTotal>=0 && dRotationTotal<=90)
				dRotationTotal = dRotationTotal;
			else if(dRotationTotal>90 && dRotationTotal<=180)
				dRotationTotal = dRotationTotal - 180;
			else if(dRotationTotal>180 && dRotationTotal<=270)
				dRotationTotal = dRotationTotal - 180;
			else if(dRotationTotal>270 && dRotationTotal<=360)
				dRotationTotal = dRotationTotal - 360;
			hatch.setAngle(dRotationTotal);
			dp.color(nColor);
			// Ticket ID #9984823
			// in xref the planeprofile is sometimes not created OK
			// or the hatching is not done Ok???
			// here do it again
			PLine plsNoOp[] = pp.allRings(true,false);
			PLine plsOp[] = pp.allRings(false, true);
			pp = PlaneProfile(pp.coordSys());
			for (int iN=0;iN<plsNoOp.length();iN++) 
			{ 
				pp.joinRing(plsNoOp[iN], _kAdd);
			}//next iN
			for (int iO=0;iO<plsOp.length();iO++) 
			{ 
				pp.joinRing(plsOp[iO], _kSubtract);
			}//next iO
			int _iTransparency=nTransparency;
			int _iSolidTransparency=nSolidTransparency;
			if(dGlobalTransparency<=0)
			{ 
				_iTransparency = 0;
				_iSolidTransparency = 0;
			}
			else if(dGlobalTransparency>0 && dGlobalTransparency<1)
			{ 
				_iTransparency = nTransparency * dGlobalTransparency;
				_iSolidTransparency=nSolidTransparency* dGlobalTransparency;
			}
			else if(dGlobalTransparency>1 && dGlobalTransparency<100)
			{ 
//				_iTransparency = 100 - ((100 - nTransparency) / dGlobalTransparency);
//				_iSolidTransparency = 100 - ((100 - nSolidTransparency) / dGlobalTransparency);
				// HSB-15895:
				_iTransparency = nTransparency+dGlobalTransparency*((100.0 - nTransparency) / 99.0);
				_iSolidTransparency = nSolidTransparency+dGlobalTransparency*((100.0 - nSolidTransparency) / 99.0);
			}
			else if(dGlobalTransparency>=100)
			{ 
				_iTransparency = 100;
				_iSolidTransparency = 100;
			}
			dp.transparency(_iTransparency);
//			if(!bInsulation)
			{
				if(bStatic && !bTransparency0)
				{
//					dp.draw(pp, hatch);
					if(!bInsulation)
						dp.draw(pp, hatch);
				}
				else if(bStatic && bTransparency0)
				{ 
					ppsStaticT.append(pp);
					nColorsT.append(nColor);
					nTransparencysT.append(_iTransparency);
//					sHatchPatternsT.append(sPattern);
					if(!bInsulation)
						sHatchPatternsT.append(sPattern);
					else
						sHatchPatternsT.append("");
					dAnglesT.append(dRotationTotal);
					dScaleFacsT.append(dScaleFac);
					dScaleMinsT.append(dScaleMin);
				}
				else
				{
					// empty planeprofile
					ppsStaticT.append(PlaneProfile());
					nColorsT.append(10e5);
					nTransparencysT.append(10e5);
					sHatchPatternsT.append("");
					dAnglesT.append(10e5);
					dScaleFacsT.append(10e5);
					dScaleMinsT.append(10e5);
				}
				if(!bStatic && !bTransparency0)
				{ 
					ppsDynamic.append(pp);
					nColorsDynamic.append(nColor);
					nTransparencysDynamic.append(_iTransparency);
					dScaleFacsDynamic.append(dScaleFac);
					dScaleMinsDynamic.append(dScaleMin);
//					sHatchPatternsDynamic.append(sPattern);
					if(!bInsulation)
						sHatchPatternsDynamic.append(sPattern);
					else
						sHatchPatternsDynamic.append("");
					dAnglesDynamic.append(dRotationTotal);
					if (dMin>dMinAll)dMinAll=dMin;
					dMinsDynamic.append(dMin);
				}
				else if(!bStatic && bTransparency0)
				{ 
				// 
		//		pp.vis(3);
					ppsDynamicT.append(pp);
					nColorsDynamicT.append(nColor);
					nTransparencysDynamicT.append(_iTransparency);
					dScaleFacsDynamicT.append(dScaleFac);
					dScaleMinsDynamicT.append(dScaleMin);
					sHatchPatternsDynamicT.append(sPattern);
					if(!bInsulation)
						sHatchPatternsDynamic.append(sPattern);
					else
						sHatchPatternsDynamic.append("");
					dAnglesDynamicT.append(dRotationTotal);
					if (dMin>dMinAll)dMinAll=dMin;
					dMinsDynamicT.append(dMin);
				}
				else
				{ 
					ppsDynamicT.append(PlaneProfile());
					nColorsDynamicT.append(10e5);
					nTransparencysDynamicT.append(10e5);
					dScaleFacsDynamicT.append(10e5);
					dScaleMinsDynamicT.append(10e5);
					sHatchPatternsDynamicT.append("");
					dAnglesDynamicT.append(10e5);
					if (dMin>dMinAll)dMinAll=dMin;
					dMinsDynamicT.append(10e5);
				}
			}
			// save for each body the center point
			if(bTransparency0)
			{ 
				bdsT.append(bd);
				Point3d ptCenI=bd.ptCen();
				ptCenI.vis(6+i);
				bd.vis(6+i);
				ptCensT.append(bd.ptCen());
			}
//			if(segsVis.length()>0 )
//			{ 
//				for (int iseg=0;iseg<segsVis.length();iseg++) 
//				{ 
//					dp.draw(segsVis[iseg]); 
//				}//next iseg
//			}

			if(nPaperPlane)
			{ 
				LineSeg _segsSip[0];
				_segsSip.append(segsSip);
				segsSip.setLength(0);
				for (int iseg=0;iseg<_segsSip.length();iseg++) 
				{ 
					Point3d pt1Paper=_segsSip[iseg].ptStart();
					Point3d pt2Paper=_segsSip[iseg].ptEnd();
					pt1Paper=pnPaper.closestPointTo(pt1Paper);
					pt2Paper=pnPaper.closestPointTo(pt2Paper);
					LineSeg lSegPaper(pt1Paper,pt2Paper);
					segsSip.append(lSegPaper);
				}//next iseg
			}
			if(segsSip.length()>0 )
			{ 
				for (int iseg=0;iseg<segsSip.length();iseg++) 
				{ 
					// HSB-21655
					if(segsSip[iseg].length()<dEps)continue;
					dp.draw(segsSip[iseg]); 
				}//next iseg
			}
			// solid hatch
			if (nSolidHatch && !bTransparency0)
			{ 
				if(bHasSolidColor)
					dp.color(nSolidColor);
				// plot the solid hatch with transparency
				dp.transparency(_iSolidTransparency);
				dp.draw(pp, _kDrawFilled, _iSolidTransparency);
			}
			else if(nSolidHatch && bTransparency0)
			{ 
				bHasSolidColorsT.append(bHasSolidColor);
				// 0 transparency
				nSolidColorsT.append(nSolidColor);
				// plot the solid hatch with transparency
				_nSolidTransparencysT.append(_iSolidTransparency);
			}
			else
			{ 
				bHasSolidColorsT.append(false);
				nSolidColorsT.append(10e4);
				// plot the solid hatch with transparency
				_nSolidTransparencysT.append(10e4);
			}
			// contour
			if (bContour && !bTransparency0)
			{
				dp.transparency(0);
				PLine pls[] = pp.allRings();
				dp.color(nColorContour);
				for (int iPl = 0; iPl < pls.length(); iPl++)
				{
					PlaneProfile ppI(pp.coordSys());
					ppI.joinRing(pls[iPl], _kAdd);
					
					if (dContourThickness > 0)
					{
						ppI.shrink(-.5 * dContourThickness);
						PlaneProfile ppContour = ppI;
						ppI.shrink(dContourThickness);
						ppContour.subtractProfile(ppI);
						dp.draw(ppContour, _kDrawFilled);
					}
					else
					{
						dp.draw(ppI);
					}
				}//next iPl
			}
			else if(bContour && bTransparency0)
			{ 
				Map m;
				nColorContoursT.append(nColorContour);
				PLine pls[]=pp.allRings();
				for (int iPl=0;iPl<pls.length();iPl++)
				{
					PlaneProfile ppI(pp.coordSys());
					ppI.joinRing(pls[iPl], _kAdd);
					PlaneProfile ppContour;
					if (dContourThickness>0)
					{
						ppI.shrink(-.5*dContourThickness);
						ppContour=ppI;
						ppI.shrink(dContourThickness);
						ppContour.subtractProfile(ppI);
					}
	//				ppContour.transformBy(_ZW*2000);
	//				ppContour.vis(6);
	//				ppContour.transformBy(-_ZW*2000);
					
					m.appendPlaneProfile("pp",ppContour);
	//				m.appendPlaneProfile("pp",ppI);
				}//next iPl
				mapContoursT.appendMap("m",m);
			}
			else
			{ 
				// HSB-21945
				nColorContoursT.append(10e5);
				mapContoursT.appendMap("m",Map());
			}
			// insulation
			if(bInsulation)
			{ 
			// do the insulation
				// insulation pline
				PLine plInsulation(pp.coordSys().vecZ());
				PLine plInsulations[0];
				PlaneProfile ppInsulation(pp.coordSys());
				PlaneProfile ppInsulations[0];
				
				PLine plRings[] = pp.allRings(true, false);
				pp.vis(3);
			// calculate the insulation
			
				Vector3d vecDird=vecZPanel.crossProduct(_ZW);
				Vector3d vecWidth=vecZPanel;
				if(sOrientation=="Z")
				{ 
					vecDird = vecWoodGrainDirection;
					vecWidth=vecZPanel.crossProduct(vecDird);
				}
				vecDird.normalize();
				vecWidth.normalize();
				PLine plInsulationsFinal[0];
				{ 
					Map mInInsulation;
					mInInsulation.setPlaneProfile("pp",pp);
					mInInsulation.setVector3d("vecDir",vecDird);
					mInInsulation.setVector3d("vecWidth",vecWidth);
					mInInsulation.setDouble("dScaleLongitudinal",dScaleLongitudinal);
					mInInsulation.setDouble("dScaleTransversal",dScaleTransversal);
					mInInsulation.setDouble("dScale",dScale);
					mInInsulation.setDouble("dWidthModule",dWidthModule);
					mInInsulation.setDouble("dDiameterModule",dDiameterModule);
					
					PLine plInsulationsFinal_[]=calcInsulation(mInInsulation);
					plInsulationsFinal.append(plInsulationsFinal_);
				}
				dp.transparency(nTransparency);
				dp.color(nColor);
				for (int ipl=0;ipl<plInsulationsFinal.length();ipl++) 
				{ 
					dp.draw(plInsulationsFinal[ipl]);
				}//next ipl
			}
			mapEntitiesUsed.appendMap("mapEntity",mapEntityI);
			// HSB-10159 save entity to be hatched and the hatch
			{ 
				entsHatch.append(sip);
				String sAngle = dRotationTotal; sAngle.format("%.2f", dRotationTotal);
				String sScale0 = dScale0; sScale0.format("%.4f", dScale0);
				String sHatchIdentifier = sMaterial + sPattern + sAngle + sScale0 + nColor + nSolidTransparency;
				if (sHatchIdentifiers.find(sHatchIdentifier) > - 1)
				{
					// hatch already saved
					continue;
				}
				
				sHatchIdentifiers.append(sHatchIdentifier);
				Map mapHatch;
				// material to which it is been used
				mapHatch.setString("sMaterial", sMaterial);
				// pattern
				mapHatch.setString("sPattern", sPattern);
				mapHatch.setDouble("dAngle", dRotationTotal);
				mapHatch.setDouble("dScale", dScale0);
				// solid hatch
				mapHatch.setInt("nColor", nColor);
				mapHatch.setInt("nSolidTransparency", nSolidTransparency);
				mapHatchesUsed.appendMap("mapHatch", mapHatch);
			}
		}//next j
	}//next i
//End hatch panels//endregion
//	return;
//region hatch beams
	if (!bByPainter || bIsBeamPainter)
	for (int i = 0; i < beams.length(); i++)
	{ 
		Beam& b = beams[i];
		if (bByPainter && !b.acceptObject(painter.filter()))
		{
			continue;
		}
		if ( ! b.isVisible())continue;
		Group grps[] = b.groups();
		int bOff=true;
		for (int igrp=0;igrp<grps.length();igrp++) 
		{ 
			if(grps[igrp].groupVisibility(false)==_kIsOn)
			{ 
				bOff = false;
				break;
			}
		}//next igrp
		if (grps.length() == 0)bOff = false;
		if (bOff)continue;
		
		if (b.bIsDummy())continue;
		Vector3d vecXBeam = b.vecX();
		Vector3d vecYBeam = b.vecY();
		Vector3d vecZBeam = b.vecZ();
		Point3d ptCen = b.ptCen();
		CoordSys csCollectionTransform;
		int nCollectionTransform = false;
		Map mapEntityI;
		if(nBeamsCollection[i]>-1)
		{ 
			csCollectionTransform=csCollections[nBeamsCollection[i]];
			nCollectionTransform=true;
		}
		
		if(nCollectionTransform)
		{ 
			vecXBeam.transformBy(csCollectionTransform);
			vecYBeam.transformBy(csCollectionTransform);
			vecZBeam.transformBy(csCollectionTransform);
			mapEntityI.setPoint3d("ptOrgTransform",csCollectionTransform.ptOrg());
			mapEntityI.setVector3d("vecXTransform",csCollectionTransform.vecX());
			mapEntityI.setVector3d("vecYTransform",csCollectionTransform.vecY());
			mapEntityI.setVector3d("vecZTransform",csCollectionTransform.vecZ());
		}
		
		// transform vectors to the section coordinate system
		vecXBeam.transformBy(ms2ps);
		vecYBeam.transformBy(ms2ps);
		vecZBeam.transformBy(ms2ps);
		
//		vecXBeam.vis(ptCen, 1);
//		vecYBeam.vis(ptCen, 3);
//		vecZBeam.vis(ptCen, 150);
		
		// find the most aligned vector with the vecX1 of the section cut
		String sOrientation = "X";
		if (abs(vecYBeam.dotProduct(_ZW)) > abs(vecXBeam.dotProduct(_ZW))
		  && abs(vecYBeam.dotProduct(_ZW)) > abs(vecZBeam.dotProduct(_ZW)))
		{
			sOrientation = "Y";
		}
		else if (abs(vecZBeam.dotProduct(_ZW)) > abs(vecXBeam.dotProduct(_ZW))
		 && abs(vecZBeam.dotProduct(_ZW)) > abs(vecYBeam.dotProduct(_ZW)))
		{ 
			sOrientation = "Z";
		}
		
	// find the vector that gives the direction of panel and project to _XY plane
		Vector3d vecDir;
		if (sOrientation == "X")
		{ 
			// vecWoodGrainDirectionJ most aligned with _ZW
			vecDir = _ZW.crossProduct(vecYBeam);
			vecDir.normalize();
			vecDir = _ZW.crossProduct(vecDir);
			if (vecDir.length() < dEps)
			{ 
			// vecDir in the same direction with the _ZW
				reportMessage("\n"+scriptName()+" "+T("|unexpected error 1010|"));
				eraseInstance();
				return;
			}
			vecDir.normalize();
			
//			vecDir = vecXBeam;
		}
		else if (sOrientation == "Y" || sOrientation == "Z")
		{ 
			// vecNormalWoodGrainDirectionJ most aligned with _ZW
			vecDir = _ZW.crossProduct(vecXBeam);
			vecDir.normalize();
			vecDir = _ZW.crossProduct(vecDir);
			
//			if(sOrientation=="Y")
//				vecDir = vecYBeam;
//			else if(sOrientation=="Z")
//				vecDir = vecZBeam;
		}
//		vecDir.vis(ptCen, 3);
		mapEntityI.setEntity("ent", b);
		mapEntityI.setString("orientation0",sOrientation);
		// rotation wrt local axis
		double dRotation;
		dRotation= _XW.angleTo(vecDir, _ZW);
		// angle between _ZW and vecDir
//		Vector3d vecDirZw = vecDir.crossProduct(_ZW);
//		vecDirZw.normalize();
//		dRotation = vecDir.angleTo(_ZW, vecDirZw);
		
		// get the material of the beam
		String sMaterial = b.material();
		Body bd = b.realBody();
		if (nCollectionTransform)
		{ 
			bd.transformBy(csCollectionTransform);
		}
		// Ticket ID #9984823
		// body intersect not reliable, use pp intersect
		int bHasIntersection = false;
		PlaneProfile ppIntersect;
		Body bdIntersect = bd;
		int bIntersect=bdIntersect.intersectWith(bdClip);
		LineSeg segsVis[0];
		// plines for the cross at the beam section
		PLine plCorssSegs[0];
		LineSeg lCrossSegs[0];
		// cross at the beam section
		{ 
			Point3d ptCross=b.ptCen();
//			ptCross.vis(3);
//			ptCross+=b.vecX()*b.vecX().dotProduct(pn0.ptOrg()-ptCross);
			int bIntersect=Line(ptCross,b.vecX()).hasIntersection(pn0,ptCross);
//			ptCross.vis(1);
			PLine pl;
			pl.addVertex(ptCross+b.vecY()*.5*b.dD(b.vecY())+b.vecZ()*.5*b.dD(b.vecZ()));
			
			Point3d pt1=ptCross+b.vecY()*.5*b.dD(b.vecY())+b.vecZ()*.5*b.dD(b.vecZ());
			Line(pt1,b.vecX()).hasIntersection(pn0,pt1);
			Point3d pt2=ptCross-b.vecY()*.5*b.dD(b.vecY())-b.vecZ()*.5*b.dD(b.vecZ());
			Line(pt2,b.vecX()).hasIntersection(pn0,pt2);
			
			LineSeg lSeg(pt1, pt2);
			lSeg.transformBy(ms2ps);
			
			if(nCollectionTransform)
			{ 
				lSeg.transformBy(csCollectionTransform);
			}
			if(nPaperPlane)
			{
				Point3d pt1Paper=lSeg.ptStart();
				Point3d pt2Paper=lSeg.ptEnd();
				pt1Paper=pnPaper.closestPointTo(pt1Paper);
				pt2Paper=pnPaper.closestPointTo(pt2Paper);
				lSeg=LineSeg(pt1Paper,pt2Paper);
			}
			lCrossSegs.append(lSeg);
			
			pt1=ptCross-b.vecY()*.5*b.dD(b.vecY())+b.vecZ()*.5*b.dD(b.vecZ());
			Line(pt1,b.vecX()).hasIntersection(pn0,pt1);
			pt2=ptCross+b.vecY()*.5*b.dD(b.vecY())-b.vecZ()*.5*b.dD(b.vecZ());
			Line(pt2,b.vecX()).hasIntersection(pn0,pt2);
			lSeg=LineSeg (pt1, pt2);
			lSeg.transformBy(ms2ps);
			if(nCollectionTransform)
			{ 
				lSeg.transformBy(csCollectionTransform);
			}
			if(nPaperPlane)
			{
				Point3d pt1Paper=lSeg.ptStart();
				Point3d pt2Paper=lSeg.ptEnd();
				pt1Paper=pnPaper.closestPointTo(pt1Paper);
				pt2Paper=pnPaper.closestPointTo(pt2Paper);
				lSeg=LineSeg(pt1Paper,pt2Paper);
			}
			lCrossSegs.append(lSeg);
		}
		if (bHasSection)
		{ 
			// for section in model space
//			CoordSys csSection = section.coordSys();
//			csSection.transformBy(ps2ms);
//			// vector normal with the viewport
//			Vector3d vecNormal = csSection.vecZ();
//			vecNormal.vis(_PtG[0], 6);
//			Plane pn0(_PtG[0], vecNormal);
//			Plane pn1(_PtG[1], vecNormal);
//			bd.vis(3);
//				PlaneProfile pptest = bd.extractContactFaceInPlane(pn0,U(1));
			
			if(bIntersect && bdIntersect.volume()>pow(dEps,3))
			{ 
				ppIntersect = bdIntersect.shadowProfile(pn0);
//					ppIntersect = bdIntersect.extractContactFaceInPlane(pn0,dSectionDepth);
				int bShowHiddenLines = false;
				int bShowOnlyHiddenLines = false;
				int bShowApproximatingEdges = false;
				CoordSys csView = csSection;
//					csView=CoordSys(csSection.ptOrg()-csSection.vecZ()*dSectionDepth, 
//						csSection.vecX(), csSection.vecY(), csSection.vecZ());
//					csView.vis(1);
				segsVis= bdIntersect.hideDisplay(csView, bShowHiddenLines, bShowOnlyHiddenLines, bShowApproximatingEdges);
//					for (int iseg=0;iseg<segsVis.length();iseg++) 
//					{ 
//						segsVis[iseg].vis(1); 
//					}//next iseg
				segsVis= pn0.projectLineSegs(segsVis);
				ppIntersect.vis(4);
			}
			else
			{ 
				pn0.vis(4);
				double dvolbd = bd.volume();
	//				double dAreatt = pptest.area();
				PlaneProfile ppBd0 = bd.getSlice(pn0);
				PlaneProfile ppBd1 = bd.getSlice(pn1);
				
				int nScenario=-1;
				if(ppBd0.area()>pow(dEps,2) || ppBd1.area()>pow(dEps,2))
				{ 
					// 1.
					nScenario = 1;
				}
				else
				{ 
					// 2. or 3.
					// create sections between pn0 and pn1 and check whether it cuts the body
					Point3d ptCenBd = bd.ptCen();
					// point ptCenBd inside 2 points pt1 and pt2
					int bInside=true;
					{ 
						Vector3d vecDir = vecNormal;
						vecDir.normalize();
						double dLengthPtI=abs(vecDir.dotProduct(ptCenBd-pt1))
							 + abs(vecDir.dotProduct(ptCenBd - pt2));
						double dLengthSeg = abs(vecDir.dotProduct(pt1 - pt2));
						if (abs(dLengthPtI - dLengthSeg) > dEps)bInside=false;
					}
					if(bInside)
					{
						Plane pnCen(ptCenBd, vecNormal);
						PlaneProfile ppCen = bd.getSlice(pnCen);
						if (ppCen.area() > pow(dEps, 2))
						{
							ppBd0 = ppCen;
							nScenario = 2;
						}
					}
				}
				if(nScenario==-1)
					continue;
				
				if (ppBd0.area() < dEps && ppBd1.area() < dEps)
				{ 
					// no intersection, go to next component
					continue;
				}
				// there is an intersection
				bHasIntersection = true;
				
				PlaneProfile ppBdShadow = bd.shadowProfile(pn0);
				ppBdShadow.vis(3);
	//			PlaneProfile ppBdClipShadow = bdClip.shadowProfile(pn0);
	//			ppBdClipShadow.vis(3);
				// intersection of ppBdShadow and ppBdClipShadow
				ppIntersect = ppBdShadow;
				ppIntersect.intersectWith(ppBdClipShadow);
				// HSB-11469
				PlaneProfile ppBdUnion = ppBd0; ppBdUnion.unionWith(ppBd1);
				ppIntersect.intersectWith(ppBdUnion);
			}
			// transform from clip to section
			ppIntersect.transformBy(ms2ps);
//			ppIntersect.vis(5);
			for (int iseg=0;iseg<segsVis.length();iseg++)
			{ 
				segsVis[iseg].transformBy(ms2ps);
			}//next iseg
		}
		else
		{ 
//			if(nCollectionTransform)
//			{ 
//				bd.transformBy(csCollectionTransform);
//			}
			// viewport in layout or viewport in shopdraw
			// transfor from model to layout
			bd.transformBy(ms2ps);
			bdIntersect = bd;
			
			bIntersect=bdIntersect.intersectWith(bdClip);
			if(bIntersect && bdIntersect.volume()>pow(dEps,3))
			{ 
				ppIntersect = bdIntersect.shadowProfile(pn0);
//					ppIntersect = bdIntersect.extractContactFaceInPlane(pn0,dSectionDepth);
				int bShowHiddenLines = false;
				int bShowOnlyHiddenLines = false;
				int bShowApproximatingEdges = false;
				CoordSys csView = csSection;
//					csView=CoordSys(csSection.ptOrg()-csSection.vecZ()*dSectionDepth, 
//						csSection.vecX(), csSection.vecY(), csSection.vecZ());
//					csView.vis(1);
				segsVis= bdIntersect.hideDisplay(csView, bShowHiddenLines, bShowOnlyHiddenLines, bShowApproximatingEdges);
//					for (int iseg=0;iseg<segsVis.length();iseg++) 
//					{ 
//						segsVis[iseg].vis(1); 
//					}//next iseg
				segsVis= pn0.projectLineSegs(segsVis);
				ppIntersect.vis(3);
			}
			else
			{ 
	//			bdIntersect.vis(3);
				double dSectionLevelPaper;
				double dSectionDepthPaper;
				{ 
	//				// top point in the model
	//				Point3d pt1 = ptMaxModel - vecZModel * dSectionLevel;
	//				// bottom point in the model
	//				Point3d pt2 = pt1 - vecZModel * dSectionDepth;
	//				if (dSectionDepth < dEps)
	//				{ 
	//					pt2 = pt1 - vecZModel * dEps;
	//				}
	//				pt1.transformBy(ms2ps);
	//				pt2.transformBy(ms2ps);
	//				
	//				pt1.vis(4);
	//				pt2.vis(4);
	//				
	//				Plane pn0(pt1, _ZW);
	//				Plane pn1(pt2, _ZW);
					PlaneProfile ppBd0 = bd.getSlice(pn0);
					PlaneProfile ppBd1 = bd.getSlice(pn1);
					int nScenario=-1;
					if(ppBd0.area()>pow(dEps,2) || ppBd1.area()>pow(dEps,2))
					{ 
						// 1.
						nScenario = 1;
					}
					else
					{ 
						// 2. or 3.
						// create sections between pn0 and pn1 and check whether it cuts the body
						Point3d ptCenBd = bd.ptCen();
						// point ptCenBd inside 2 points pt1 and pt2
						int bInside=true;
						{ 
							Vector3d vecDir = vecNormal;
							vecDir.normalize();
							double dLengthPtI=abs(vecDir.dotProduct(ptCenBd-pt1))
								 + abs(vecDir.dotProduct(ptCenBd - pt2));
							double dLengthSeg = abs(vecDir.dotProduct(pt1 - pt2));
							if (abs(dLengthPtI - dLengthSeg) > dEps)bInside=false;
						}
						if(bInside)
						{
							Plane pnCen(ptCenBd, vecNormal);
							PlaneProfile ppCen = bd.getSlice(pnCen);
							if (ppCen.area() > pow(dEps, 2))
							{
								ppBd0 = ppCen;
								nScenario = 2;
							}
						}
					}
					if(nScenario==-1)
						continue;
					
					double dArea0 = ppBd0.area();
					double dArea1 = ppBd1.area();
					if (ppBd0.area() < pow(dEps, 2) && ppBd1.area() < pow(dEps, 2))
					{ 
						// no intersection, go to next component
						continue;
					}
					// there is an intersection
					bHasIntersection = true;
					
					PlaneProfile ppBdShadow = bd.shadowProfile(pn0);
					ppBdShadow.vis(3);
	//				PlaneProfile ppBdClipShadow = bdClip.shadowProfile(pn0);
	//				ppBdClipShadow.vis(3);
					
					// intersection of ppBdShadow and ppBdClipShadow
					ppIntersect = ppBdShadow;
					ppIntersect.intersectWith(ppBdClipShadow);
					// HSB-11469
					PlaneProfile ppBdUnion = ppBd0; ppBdUnion.unionWith(ppBd1);
					ppIntersect.intersectWith(ppBdUnion);
					//
	//				ppIntersect.vis(5);
					// transform back to model
					bd.transformBy(ps2ms);
				}
			}
		}
		// Ticket ID #9984823
		// body intersect not reliable, use pp intersect
//		if ( ! bHasSection)
//		{ 
//			// paperspace layout or block space shopdrawing
//			bd.transformBy(ms2ps);
//		}
////		bd.vis(3);
////		bdClip.vis(1);
//		if (!bd.hasIntersection(bdClip))continue;
//		bd.intersectWith(bdClip);
//		bd.vis(2);
//		if (bHasSection)
//		{
//			// transform where the section is
//			bd.transformBy(ms2ps);
//		}
////		bd.vis(3);
////		PlaneProfile pp = bd.extractContactFaceInPlane(Plane(_Pt0, vecZ), dEps);
//		PlaneProfile pp = bd.shadowProfile(Plane(_Pt0, vecZ));
//		double dAreaPp = pp.area();
		
		PlaneProfile pp = ppIntersect;
		if (pp.area() < dEps)
		{ 
			// nothing to hatch, skip this "j" beam
			continue;
		}
//		pp.vis(2);
	// get the map of the hatch for this material
		int bMaterialFound = false;
		// get the map of the hatch for this material
		int bOrientationFound = false;
		Map mapHatchFound, mapOrientationFound;
		
		{ 
			Map mInHatchFind;
			mInHatchFind.setMap("mapHatches",mapHatches);
			mInHatchFind.setInt("nHatchMapping",nHatchMapping);
			mInHatchFind.setInt("bPainterGroup",bPainterGroup);
			mInHatchFind.setString("sMaterial",sMaterial);
//				mInHatchFind.setInt("indexJ",j);
			mInHatchFind.setString("sOrientation",sOrientation);
			mInHatchFind.setMap("mapHatchDefaultPainter",mapHatchDefaultPainter);
			mInHatchFind.setInt("nHatchDefaultPainterIndex",nHatchDefaultPainterIndex);
			mInHatchFind.setString("sRule",sRule);
			mInHatchFind.setEntity("ent",b);
			mInHatchFind.setString("sPainterFormat",sPainterFormat);
			
			Map mOutHatchFind=getHatchDefinition(mInHatchFind,nHatchesUsed,mapEntityI);
			
			bMaterialFound=mOutHatchFind.getInt("bMaterialFound");
			bOrientationFound=mOutHatchFind.getInt("bOrientationFound");
			mapHatchFound=mOutHatchFind.getMap("mapHatchFound");
			mapOrientationFound=mOutHatchFind.getMap("mapOrientationFound");
		}
		
		// if material is found but orientation not found, skip the hatching
		if (bMaterialFound && !bOrientationFound)
		{ 
			// dont do the hatching, go to the next component
			// hatch for this material is not defined correctly
			continue;
		}
		
		if (!bMaterialFound && bMapHatchDefaultFound)
		{ 
			if (nHatchesUsed.find(nHatchDefaultIndex) < 0)nHatchesUsed.append(nHatchDefaultIndex);
			mapHatchFound = mapHatchDefault;
			bMaterialFound = true;
			if (nHatchesUsed.find(nHatchDefaultIndex) < 0)nHatchesUsed.append(nHatchDefaultIndex);
			mapEntityI.setInt("hatch0",nHatchDefaultIndex);
			int bAnisotropic = mapHatchFound.getInt("Anisotropic");
			if(!bAnisotropic)mapEntityI.setString("orientation0","X");
			
			// if the material is not found and a default hatch exists, use the default hatch
			Map mapOrientations = mapHatchDefault.getMap("Orientation[]");
			if (mapOrientations.length() < 1)
			{ 
				// no orientation map defined for this material 
				reportMessage("\n"+scriptName()+" "+T("|no map of orientation found for the material of the beam|"));
				eraseInstance();
				return;
			}
			bOrientationFound = false;
			if (!bAnisotropic)
			{
				for (int l = 0; l < mapOrientations.length(); l++)
				{ 
					Map mapOrientationL = mapOrientations.getMap(l);
					if (mapOrientationL.hasString("Name") && mapOrientations.keyAt(l).makeLower() == "orientation")
					{ 
						mapOrientationFound=mapOrientationL;
						bOrientationFound=true;
						break;
					}
				}//next l
			}
			else
			{ 
				// find the orientation for this component
				for (int l = 0; l < mapOrientations.length(); l++)
				{ 
					Map mapOrientationL = mapOrientations.getMap(l);
					if (mapOrientationL.hasString("Name") && mapOrientations.keyAt(l).makeLower() == "orientation")
					{ 
						String sOrientationMap = mapOrientationL.getString("Name");
						if (sOrientationMap.makeUpper() != sOrientation.makeUpper())
						{ 
							// not this orientation
							continue;
						}
						bOrientationFound = true;
						mapOrientationFound = mapOrientationL;
						break;
					}
				}//next l
			}
		}
		
		// if no material found and no default material
		if ( ! bMaterialFound || !bOrientationFound)
		{ 
			// go to next entity (panel component)
			continue;
		}
		// default values
		{ 
			nSolidHatch=0;
			nSolidTransparency = 0;
			nSolidColor = 0;
			bHasSolidColor = 0;
			// default orientation hatch parameters
			sPattern = "ANSI31";// hatch pattern
			nColor = 1;// color index
			nTransparency = 0;// transparency
			dAngle = 0;// hatch angle
			dScale = 10.0;// hatch scale
			dScaleMin = 25;// dScaleMin
			bStatic = 0;// by default make dynamic
			// contour parameters
			bContour = 0;
			nColorContour = 0;
			dContourThickness = 0;
		}
		// properties in hatch map
		{ 
			String ss;
			Map m = mapHatchFound;
			ss = "SolidHatch"; if(m.hasInt(ss)) nSolidHatch=m.getInt(ss);
			ss = "SolidTransparency"; if(m.hasInt(ss)) nSolidTransparency=m.getInt(ss);
			ss = "SolidColor"; if(m.hasInt(ss)) nSolidColor=m.getInt(ss);
			ss = "SolidColor"; bHasSolidColor=m.hasInt(ss);
			
		}
		// properties in orientation map
		{ 
			String ss;
			Map m = mapOrientationFound;
			ss = "Pattern"; if(m.hasString(ss)) sPattern = m.getString(ss);
			ss = "Color"; if(m.hasInt(ss)) nColor = m.getInt(ss);
			ss = "Transparency"; if(m.hasInt(ss)) nTransparency = m.getInt(ss);
			ss = "Angle"; if(m.hasDouble(ss)) dAngle = m.getDouble(ss);
			ss = "Scale"; if(m.hasDouble(ss)) dScale = m.getDouble(ss);
			ss = "ScaleMin"; if(m.hasDouble(ss)) dScaleMin = m.getDouble(ss);
			ss = "Static"; if(m.hasInt(ss)) bStatic = m.getInt(ss);
			// insulation
			bInsulation = false;
			if (sPattern == sInsulation)bInsulation = true;
//			ss = "Insulation"; if(m.hasInt(ss)) bInsulation=m.getInt(ss);
//			ss = "ScaleLongitudinal"; if(m.hasDouble(ss)) dScaleLongitudinal=m.getDouble(ss);
//			ss = "ScaleTransversal"; if(m.hasDouble(ss)) dScaleTransversal=m.getDouble(ss);
		}
		// properties in contour map
		Map mapContour = mapHatchFound.getMap("Contour");
		{ 
			String ss;
			Map m = mapContour;
			ss = "Contour"; if(m.hasInt(ss)) bContour = m.getInt(ss);
			ss = "Color"; if(m.hasInt(ss)) nColorContour = m.getInt(ss);
			ss = "Thickness"; if(m.hasDouble(ss)) dContourThickness = m.getDouble(ss);
			ss = "SupressBeamCross"; if(m.hasInt(ss)) bSupressBeamCross=m.getInt(ss);
		}
	// HSB-12339
		int bDrawCross=(!bSupressBeamCross);
	// adapt dScale and dScaleMin with the scale of viewport or shopdraw
//		dScale *= dScaleVP;//!!!
//		dScaleMin *= dScaleVP;
	// get extents of profile
		if(nPaperPlane)
		{ 
			PlaneProfile ppPaper(pnPaper);
			ppPaper.unionWith(pp);
			pp=PlaneProfile (pnPaper);
			pp.unionWith(ppPaper);
		}
		double dMin = U(10e7);
	// calculate min width rotating 0-180 by 10 degrees
		Vector3d vecXrotI = vecX;
		Vector3d vecYrotI = vecY;
		for (int irot=0;irot<17;irot++) 
		{ 
			LineSeg segI = pp.extentInDir(vecXrotI);
			double dXI=abs(vecXrotI.dotProduct(segI.ptStart()-segI.ptEnd()));
			if(dXI<dMin)dMin=dXI;
			vecXrotI=vecXrotI.rotateBy(U(10),vecZ);
		}//next irot
		pp.vis(3);
		LineSeg seg = pp.extentInDir(vecX);
		seg.vis(4);
//		double dX = abs(vecX.dotProduct(seg.ptStart() - seg.ptEnd()));
//		double dY = abs(vecY.dotProduct(seg.ptStart() - seg.ptEnd()));
//		double dMin = dX<dY?dX:dY;
	// 
		double dScaleFac = dScale;
		if (dScaleFac < 0.01)dScaleFac = 1;
		double dScale0 = dScaleMin;
		if (bStatic)
		{
			// static, not adapted to the size, get the factor defined in dScale
			dScale0 = dScaleFac;
			if (dScale0 < dScaleMin)
			{ 
				dScale0 = dScaleMin;
			}
		}
		else
		{ 
			// dynamic, adapted to the minimum dimension
			// should not be smaller then dScaleMin
			dScale0=dScaleFac*dMin;
			if (dScale0<dScaleMin)
			{ 
				dScale0=dScaleMin;
			}
		}
		// multiply dScale0 with the global scaling factor
		dScale0*=dGlobalScaling;
		// check the color
		// by layer and by block will set the color of the attached layer at the TSL
		if (nColor<1)
		{ 
			// -2 by entity, -1 by layer, 0 by entity
			if (nColor==-2)
			{ 
				// get color from entity (beam) and use this for the hatch
				nColor=b.color();
			}
			else if (nColor<-2)
			{ 
				//nColor <- 2; -3,-4,-5 etc then take by entity
				nColor=-2;
			}
		}
		if (nColorContour<1)
		{ 
			// -2 by entity, -1 by layer, 0 by entity
			if (nColorContour==-2)
			{ 
				// get color from entity (beam) and use this for the hatch
				nColorContour=b.color();
			}
			else if (nColorContour<-2)
			{ 
				//nColor <- 2; -3,-4,-5 etc then take by entity
				nColorContour=-2;
			}
		}
		if (nSolidColor<1)
		{ 
			// -2 by entity, -1 by layer, 0 by entity
			if (nSolidColor==-2)
			{ 
				// get color from entity (beam) and use this for the hatch
				nSolidColor=b.color();
			}
			else if (nSolidColor<-2)
			{ 
				//nColor <- 2; -3,-4,-5 etc then take by entity
				nSolidColor=- 2;
			}
		}
		// draw the hatch for the beam
		int nPattern=_HatchPatterns.findNoCase(sPattern,0);
		sPattern=nPattern>-1?_HatchPatterns[nPattern]:_HatchPatterns[0];
		// hatch object
		Hatch hatch(sPattern, dScale0);
		double dRotationTotal=dAngle+dRotation;
		//HSB-11326:transform to - 90;90
//		if(dRotationTotal>=0 && dRotationTotal<=90)
//			dRotationTotal = dRotationTotal;
//		else if(dRotationTotal>90 && dRotationTotal<=180)
//			dRotationTotal = dRotationTotal - 180;
//		else if(dRotationTotal>180 && dRotationTotal<=270)
//			dRotationTotal = 270-dRotationTotal;
//		else if(dRotationTotal>270 && dRotationTotal<=360)
//			dRotationTotal = dRotationTotal - 360;
		//
		hatch.setAngle(dRotationTotal);
		dp.color(nColor);
		int _iTransparency=nTransparency;
		int _iSolidTransparency=nSolidTransparency;
		if(dGlobalTransparency<=0)
		{ 
			_iTransparency=0;
			_iSolidTransparency=0;
		}
		else if(dGlobalTransparency>0 && dGlobalTransparency<1)
		{ 
			_iTransparency=nTransparency*dGlobalTransparency;
			_iSolidTransparency=nSolidTransparency*dGlobalTransparency;
		}
		else if(dGlobalTransparency>1 && dGlobalTransparency<100)
		{ 
			_iTransparency=nTransparency+dGlobalTransparency*((100.0-nTransparency)/99.0);
			_iSolidTransparency=nSolidTransparency+dGlobalTransparency*((100.0-nSolidTransparency)/99.0);
		}
		else if(dGlobalTransparency>=100)
		{ 
			_iTransparency=100;
			_iSolidTransparency=100;
		}
//		String sGlobalTransparencyDescriptionSolid = T("|Calculated solid transparency is|"+" "+_iSolidTransparency);
//		String sGlobalTransparencyDescriptionPattern = T("|Calculated patern transparency is|"+" "+_iTransparency);
		dp.transparency(_iTransparency);
//		if(!bInsulation)
		{
			if(bStatic && !bTransparency0)
			{
//				dp.draw(pp, hatch);
				if(!bInsulation)
					dp.draw(pp, hatch);
			}
			else if(bStatic && bTransparency0)
			{ 
				ppsStaticT.append(pp);
				nColorsT.append(nColor);
				nTransparencysT.append(_iTransparency);
//				sHatchPatternsT.append(sPattern);
				if(!bInsulation)
					sHatchPatternsT.append(sPattern);
				else
					sHatchPatternsT.append("");
				dAnglesT.append(dRotationTotal);
				dScaleFacsT.append(dScaleFac);
				dScaleMinsT.append(dScaleMin);
			}
			else
			{
				// empty planeprofile
				ppsStaticT.append(PlaneProfile());
				nColorsT.append(10e5);
				nTransparencysT.append(10e5);
				sHatchPatternsT.append("");
				dAnglesT.append(10e5);
				dScaleFacsT.append(10e5);
				dScaleMinsT.append(10e5);
			}
			if(!bStatic && !bTransparency0)
			{ 
				ppsDynamic.append(pp);
				nColorsDynamic.append(nColor);
				nTransparencysDynamic.append(_iTransparency);
				dScaleFacsDynamic.append(dScaleFac);
				dScaleMinsDynamic.append(dScaleMin);
//				sHatchPatternsDynamic.append(sPattern);
				if(!bInsulation)
					sHatchPatternsDynamic.append(sPattern);
				else
					sHatchPatternsDynamic.append("");
				dAnglesDynamic.append(dRotationTotal);
				if (dMin>dMinAll)dMinAll=dMin;
				dMinsDynamic.append(dMin);
			}
			else if(!bStatic && bTransparency0)
			{ 
			// 
	//		pp.vis(3);
				ppsDynamicT.append(pp);
				nColorsDynamicT.append(nColor);
				nTransparencysDynamicT.append(_iTransparency);
				dScaleFacsDynamicT.append(dScaleFac);
				dScaleMinsDynamicT.append(dScaleMin);
				sHatchPatternsDynamicT.append(sPattern);
				dAnglesDynamicT.append(dRotationTotal);
				if (dMin>dMinAll)dMinAll=dMin;
				dMinsDynamicT.append(dMin);
			}
			else
			{ 
				ppsDynamicT.append(PlaneProfile());
				nColorsDynamicT.append(10e5);
				nTransparencysDynamicT.append(10e5);
				dScaleFacsDynamicT.append(10e5);
				dScaleMinsDynamicT.append(10e5);
				sHatchPatternsDynamicT.append(10e5);
				dAnglesDynamicT.append(10e5);
				if (dMin>dMinAll)dMinAll=dMin;
				dMinsDynamicT.append(10e5);
			}
		}
		if(bTransparency0)
		{ 
			bdsT.append(bd);
			Point3d ptCenI=bd.ptCen();
			ptCenI.vis(6+i);
			bd.vis(6+i);
			ptCensT.append(bd.ptCen());
		}
		if(nPaperPlane)
		{ 
			LineSeg _segsVis[0];
			_segsVis.append(segsVis);
			segsVis.setLength(0);
			for (int iseg=0;iseg<_segsVis.length();iseg++) 
			{ 
				Point3d pt1Paper=_segsVis[iseg].ptStart();
				Point3d pt2Paper=_segsVis[iseg].ptEnd();
				pt1Paper=pnPaper.closestPointTo(pt1Paper);
				pt2Paper=pnPaper.closestPointTo(pt2Paper);
				LineSeg lSegPaper(pt1Paper,pt2Paper);
				segsVis.append(lSegPaper);
			}//next iseg
		}
		if(segsVis.length()>0 )
		{ 
			for (int iseg=0;iseg<segsVis.length();iseg++)
			{ 
				dp.draw(segsVis[iseg]);
			}//next iseg
		}
		// HSB-21749: Fix solid hatch at beams
		if (nSolidHatch && !bTransparency0)
		{ 
			if(bHasSolidColor)
				dp.color(nSolidColor);
			// plot the solid hatch with transparency
			dp.transparency(_iSolidTransparency);
			dp.draw(pp, _kDrawFilled, _iSolidTransparency);
		}
		else if(nSolidHatch && bTransparency0)
		{ 
			bHasSolidColorsT.append(bHasSolidColor);
			// 0 transparency
			nSolidColorsT.append(nSolidColor);
			// plot the solid hatch with transparency
			_nSolidTransparencysT.append(_iSolidTransparency);
		}
		else
		{ 
			bHasSolidColorsT.append(false);
			nSolidColorsT.append(10e4);
			// plot the solid hatch with transparency
			_nSolidTransparencysT.append(10e4);
		}
		// contour
		if (bContour && !bTransparency0)
		{
			dp.transparency(0);
			PLine pls[] = pp.allRings();
			dp.color(nColorContour);
			for (int iPl = 0; iPl < pls.length(); iPl++)
			{
				PlaneProfile ppI(pp.coordSys());
				ppI.joinRing(pls[iPl], _kAdd);
				
				if (dContourThickness > 0)
				{
					ppI.shrink(-.5 * dContourThickness);
					PlaneProfile ppContour = ppI;
					ppI.shrink(dContourThickness);
					ppContour.subtractProfile(ppI);
					dp.draw(ppContour, _kDrawFilled);
				}
				else
				{
					dp.draw(ppI);
				}
			}//next iPl
		}
		else if(bContour && bTransparency0)
		{ 
			Map m;
			nColorContoursT.append(nColorContour);
			PLine pls[]=pp.allRings();
			for (int iPl=0;iPl<pls.length();iPl++)
			{
				PlaneProfile ppI(pp.coordSys());
				ppI.joinRing(pls[iPl], _kAdd);
				PlaneProfile ppContour;
				if (dContourThickness>0)
				{
					ppI.shrink(-.5*dContourThickness);
					ppContour=ppI;
					ppI.shrink(dContourThickness);
					ppContour.subtractProfile(ppI);
				}
//				ppContour.transformBy(_ZW*2000);
//				ppContour.vis(6);
//				ppContour.transformBy(-_ZW*2000);
				
				m.appendPlaneProfile("pp",ppContour);
//				m.appendPlaneProfile("pp",ppI);
			}//next iPl
			mapContoursT.appendMap("m",m);
		}
		else
		{ 
			nColorContoursT.append(10e5);
			mapContoursT.appendMap("m",Map());
		}
		if(bDrawCross && abs(vecXBeam.dotProduct(_ZW))>dEps )
		{ 
			dp.transparency(0);
			dp.color(nColorContour);
			lCrossSegs=pp.splitSegments(lCrossSegs,true);
			
			dp.draw(lCrossSegs);
		}
		if(bInsulation)
		{ 
		// do the insulation
			// insulation pline
			PLine plInsulation(pp.coordSys().vecZ());
			PLine plInsulations[0];
			PlaneProfile ppInsulation(pp.coordSys());
			PlaneProfile ppInsulations[0];
			
			PLine plRings[] = pp.allRings(true, false);
			pp.vis(3);
		// calculate the insulation
		
		// get extents of profile
			Vector3d vecDird=vecZBeam.crossProduct(_ZW);
			Vector3d vecWidth=vecZBeam;
			if(sOrientation=="Z" || sOrientation=="Y")
			{ 
				vecDird = vecXBeam;
				vecWidth=pp.coordSys().vecZ().crossProduct(vecDird);
			}
			else
			{ 
				vecDird = vecYBeam;
				vecWidth=pp.coordSys().vecZ().crossProduct(vecDird);
			}
			// HSB-21749
			vecDird.normalize();
			vecWidth.normalize();
			
			PLine plInsulationsFinal[0];
			{ 
				Map mInInsulation;
				mInInsulation.setPlaneProfile("pp",pp);
				mInInsulation.setVector3d("vecDir",vecDird);
				mInInsulation.setVector3d("vecWidth",vecWidth);
				mInInsulation.setDouble("dScaleLongitudinal",dScaleLongitudinal);
				mInInsulation.setDouble("dScaleTransversal",dScaleTransversal);
				mInInsulation.setDouble("dScale",dScale);
				mInInsulation.setDouble("dWidthModule",dWidthModule);
				mInInsulation.setDouble("dDiameterModule",dDiameterModule);
				
				PLine plInsulationsFinal_[]=calcInsulation(mInInsulation);
				plInsulationsFinal.append(plInsulationsFinal_);
			}
			dp.transparency(nTransparency);
			dp.color(nColor);
			for (int ipl=0;ipl<plInsulationsFinal.length();ipl++) 
			{ 
				dp.draw(plInsulationsFinal[ipl]);
			}//next ipl
		}
		mapEntitiesUsed.appendMap("mapEntity",mapEntityI);
		// HSB-10159 save entity to be hatched and the hatch
		{ 
			entsHatch.append(b);
			String sAngle=dRotationTotal; sAngle.format("%.2f", dRotationTotal);
			String sScale0=dScale0; sScale0.format("%.4f", dScale0);
			String sHatchIdentifier=sMaterial+sPattern+sAngle+sScale0+nColor+nSolidTransparency;
			if (sHatchIdentifiers.find(sHatchIdentifier)>-1)
			{
				// hatch already saved
				continue;
			}
			
			sHatchIdentifiers.append(sHatchIdentifier);
			Map mapHatch;
			// material to which it is been used
			mapHatch.setString("sMaterial", sMaterial);
			// pattern
			mapHatch.setString("sPattern", sPattern);
			mapHatch.setDouble("dAngle", dRotationTotal);
			mapHatch.setDouble("dScale", dScale0);
			// solid hatch
			mapHatch.setInt("nColor", nColor);
			mapHatch.setInt("nSolidTransparency", nSolidTransparency);
			mapHatchesUsed.appendMap("mapHatch", mapHatch);
		}
	}//next i
//End hatch beams//endregion

//region hatch sheets
	if (!bByPainter || bIsSheetPainter)
	for (int i = 0; i < sheets.length(); i++)
	{ 
		Sheet& sh = sheets[i];
		if (bByPainter && !sh.acceptObject(painter.filter())){ continue;}
		if ( ! sh.isVisible())continue;
		Group grps[] = sh.groups();
		int bOff=true;
		for (int igrp=0;igrp<grps.length();igrp++) 
		{ 
			if(grps[igrp].groupVisibility(false)==_kIsOn)
			{ 
				bOff = false;
				break;
			}
		}//next igrp
		if (grps.length() == 0)bOff = false;
		if (bOff)continue;
		if(sh.bIsDummy())continue;
		Vector3d vecXSheet = sh.vecX();
		Vector3d vecYSheet = sh.vecY();
		Vector3d vecZSheet = sh.vecZ();
		Point3d ptCen = sh.ptCen();
		CoordSys csCollectionTransform;
		int nCollectionTransform = false;
		if(nSheetsCollection[i]>-1)
		{ 
			csCollectionTransform=csCollections[nSheetsCollection[i]];
			nCollectionTransform=true;
		}
		
		// transform vectors to the section coordinate system
		vecXSheet.transformBy(csCollectionTransform);
		vecYSheet.transformBy(csCollectionTransform);
		vecZSheet.transformBy(csCollectionTransform);
		// transform vectors to the section coordinate system
		vecXSheet.transformBy(ms2ps);
		vecYSheet.transformBy(ms2ps);
		vecZSheet.transformBy(ms2ps);
		
		// find the most aligned vector with the vecX1 of the section cut
		String sOrientation = "X";
		if (abs(vecYSheet.dotProduct(_ZW))> abs(vecXSheet.dotProduct(_ZW))
		 && abs(vecYSheet.dotProduct(_ZW))> abs(vecZSheet.dotProduct(_ZW)))
		{
			sOrientation = "Y";
		}
		else if(abs(vecZSheet.dotProduct(_ZW))> abs(vecXSheet.dotProduct(_ZW))
		&& abs(vecZSheet.dotProduct(_ZW))> abs(vecYSheet.dotProduct(_ZW)))
		{ 
			sOrientation = "Z";
		}
		
		// find the vector that gives the direction of panel and project to _XY plane
		Vector3d vecDir;
		if (sOrientation == "X")
		{ 
			// vecWoodGrainDirectionJ most aligned with _ZW
//			vecDir = _ZW.crossProduct(vecYSheet);
//			vecDir.normalize();
//			vecDir = _ZW.crossProduct(vecDir);
//			if (vecDir.length() < dEps)
//			{ 
//				reportMessage(TN("|unexpected error 1010|"));
//				eraseInstance();
//				return;
//			}
//			vecDir.normalize();
			
			vecDir = vecXSheet;
		}
		else if (sOrientation == "Y" || sOrientation == "Z")
		{ 
			// vecNormalWoodGrainDirectionJ most aligned with _ZW
//			vecDir = _ZW.crossProduct(vecXSheet);
//			vecDir.normalize();
//			vecDir = _ZW.crossProduct(vecDir);

			if(sOrientation=="Y")
				vecDir = vecYSheet;
			else if(sOrientation=="Z")
				vecDir = vecZSheet;
		}
		Map mapEntityI;mapEntityI.setEntity("ent", sh);
		mapEntityI.setString("orientation0",sOrientation);
		if(nCollectionTransform)
		{ 
			mapEntityI.setPoint3d("ptOrgTransform",csCollectionTransform.ptOrg());
			mapEntityI.setVector3d("vecXTransform",csCollectionTransform.vecX());
			mapEntityI.setVector3d("vecYTransform",csCollectionTransform.vecY());
			mapEntityI.setVector3d("vecZTransform",csCollectionTransform.vecZ());
		}
//		vecDir.vis(ptCen, 3);
		// rotation wrt local axis
		double dRotation;
//		dRotation= _XW.angleTo(vecDir, _ZW);
		// angle between _ZW and vecDir
		Vector3d vecDirZw = vecDir.crossProduct(_ZW);
		vecDirZw.normalize();
		dRotation = vecDir.angleTo(_ZW, vecDirZw);
		
		// get the material of the beam
		String sMaterial = sh.material();
		Body bd = sh.realBody();
		if (nCollectionTransform)
		{ 
			bd.transformBy(csCollectionTransform);
		}
		if ( ! bHasSection)
		{ 
			// paperspace layout or block space shopdrawing
			bd.transformBy(ms2ps);
		}
		
		bd.intersectWith(bdClip);
		bd.vis(2);
		LineSeg segsVis[0];
		
		bd.vis(2);
//		bd.transformBy(ms2ps);
		if (bHasSection)
		{
			CoordSys csView = csSection;
			int bShowHiddenLines = false;
			int bShowOnlyHiddenLines = false;
			int bShowApproximatingEdges = false;
			segsVis= bd.hideDisplay(csView, bShowHiddenLines, bShowOnlyHiddenLines, bShowApproximatingEdges);
			segsVis= pn0.projectLineSegs(segsVis);
			// transform where the section is
			bd.transformBy(ms2ps);
			bd.vis(2);
			for (int iseg=0;iseg<segsVis.length();iseg++) 
			{ 
				segsVis[iseg].transformBy(ms2ps); 
			}//next iseg
		}
//		PlaneProfile pp = bd.extractContactFaceInPlane(Plane(_Pt0, vecZ), dEps);
		PlaneProfile pp = bd.shadowProfile(Plane(_Pt0, vecZ));
		pp.vis(1);
		if (pp.area() < dEps)
		{ 
			// nothing to hatch, skip this "i" sheet
			continue;
		}
		
		pp.vis(4);
		int bMaterialFound = false;
		// get the map of the hatch for this material
		int bOrientationFound = false;
		Map mapHatchFound, mapOrientationFound;
		
		{ 
			Map mInHatchFind;
			mInHatchFind.setMap("mapHatches",mapHatches);
			mInHatchFind.setInt("nHatchMapping",nHatchMapping);
			mInHatchFind.setInt("bPainterGroup",bPainterGroup);
			mInHatchFind.setString("sMaterial",sMaterial);
//				mInHatchFind.setInt("indexJ",j);
			mInHatchFind.setString("sOrientation",sOrientation);
			mInHatchFind.setMap("mapHatchDefaultPainter",mapHatchDefaultPainter);
			mInHatchFind.setInt("nHatchDefaultPainterIndex",nHatchDefaultPainterIndex);
			mInHatchFind.setString("sRule",sRule);
			mInHatchFind.setEntity("ent",sh);
			mInHatchFind.setString("sPainterFormat",sPainterFormat);
			
			Map mOutHatchFind=getHatchDefinition(mInHatchFind,nHatchesUsed,mapEntityI);
			
			bMaterialFound=mOutHatchFind.getInt("bMaterialFound");
			bOrientationFound=mOutHatchFind.getInt("bOrientationFound");
			mapHatchFound=mOutHatchFind.getMap("mapHatchFound");
			mapOrientationFound=mOutHatchFind.getMap("mapOrientationFound");
		}
		
		// if material is found but orientation not found, skip the hatching
		if ( bMaterialFound && ! bOrientationFound)
		{ 
			// dont do the hatching, go to the next component
			// hatch for this material is not defined correctly
			continue;
		}
		
		if ( ! bMaterialFound && bMapHatchDefaultFound)
		{ 
			if (nHatchesUsed.find(nHatchDefaultIndex) < 0)nHatchesUsed.append(nHatchDefaultIndex);
			mapHatchFound = mapHatchDefault;
			bMaterialFound = true;
			if (nHatchesUsed.find(nHatchDefaultIndex) < 0)nHatchesUsed.append(nHatchDefaultIndex);
			mapEntityI.setInt("hatch0",nHatchDefaultIndex);
			int bAnisotropic = mapHatchFound.getInt("Anisotropic");
			if(!bAnisotropic)mapEntityI.setString("orientation0","X");
			
			// if the material is not found and a default hatch exists, use the default hatch
			Map mapOrientations = mapHatchDefault.getMap("Orientation[]");
			if (mapOrientations.length() < 1)
			{ 
				// no orientation map defined for this material 
				reportMessage("\n"+scriptName()+" "+T("|no map of orientation found for the material of the beam|"));
				eraseInstance();
				return;
			}
			bOrientationFound = false;
			if ( ! bAnisotropic)
			{
				for (int l = 0; l < mapOrientations.length(); l++)
				{ 
					Map mapOrientationL = mapOrientations.getMap(l);
					if (mapOrientationL.hasString("Name") && mapOrientations.keyAt(l).makeLower() == "orientation")
					{ 
						mapOrientationFound = mapOrientationL;
						bOrientationFound = true;
						break;
					}
				}//next l
			}
			else
			{ 
				// find the orientation for this component
				for (int l = 0; l < mapOrientations.length(); l++)
				{ 
					Map mapOrientationL = mapOrientations.getMap(l);
					if (mapOrientationL.hasString("Name") && mapOrientations.keyAt(l).makeLower() == "orientation")
					{ 
						String sOrientationMap = mapOrientationL.getString("Name");
						if (sOrientationMap.makeUpper() != sOrientation.makeUpper())
						{ 
							// not this orientation
							continue;
						}
						bOrientationFound = true;
						mapOrientationFound = mapOrientationL;
						break;
					}
				}//next l
			}
		}
		
		// if no material found and no default material
		if ( ! bMaterialFound || !bOrientationFound)
		{ 
			// go to next entity (panel component)
			continue;
		}
		// default values
		{ 
			nSolidHatch=0;
			nSolidTransparency = 0;
			nSolidColor = 0;
			bHasSolidColor = 0;
			// default orientation hatch parameters
			sPattern = "ANSI31";// hatch pattern
			nColor = 1;// color index
			nTransparency = 0;// transparency
			dAngle = 0;// hatch angle
			dScale = 10.0;// hatch scale
			dScaleMin = 25;// dScaleMin
			bStatic = 0;// by default make dynamic
			// contour parameters
			bContour = 0;
			nColorContour = 0;
			dContourThickness = 0;
		}
		// properties in hatch map
		{ 
			String ss;
			Map m = mapHatchFound;
			ss = "SolidHatch"; if(m.hasInt(ss)) nSolidHatch = m.getInt(ss);
			ss = "SolidTransparency"; if(m.hasInt(ss)) nSolidTransparency = m.getInt(ss);
			ss = "SolidColor"; if(m.hasInt(ss)) nSolidColor = m.getInt(ss);
			ss = "SolidColor"; bHasSolidColor= m.hasInt(ss);
		}
		// properties in orientation map
		{ 
			String ss;
			Map m = mapOrientationFound;
			ss = "Pattern"; if(m.hasString(ss)) sPattern = m.getString(ss);
			ss = "Color"; if(m.hasInt(ss)) nColor = m.getInt(ss);
			ss = "Transparency"; if(m.hasInt(ss)) nTransparency = m.getInt(ss);
			ss = "Angle"; if(m.hasDouble(ss)) dAngle = m.getDouble(ss);
			ss = "Scale"; if(m.hasDouble(ss)) dScale = m.getDouble(ss);
			ss = "ScaleMin"; if(m.hasDouble(ss)) dScaleMin = m.getDouble(ss);
			ss = "Static"; if(m.hasInt(ss)) bStatic = m.getInt(ss);
			// insulation
			bInsulation = false;
			if (sPattern == sInsulation)bInsulation = true;
//			ss = "Insulation"; if(m.hasInt(ss)) bInsulation=m.getInt(ss);
//			ss = "ScaleLongitudinal"; if(m.hasDouble(ss)) dScaleLongitudinal=m.getDouble(ss);
//			ss = "ScaleTransversal"; if(m.hasDouble(ss)) dScaleTransversal=m.getDouble(ss);
		}
		// properties in contour map
		Map mapContour = mapHatchFound.getMap("Contour");
		{ 
			String ss;
			Map m = mapContour;
			ss = "Contour"; if(m.hasInt(ss)) bContour = m.getInt(ss);
			ss = "Color"; if(m.hasInt(ss)) nColorContour = m.getInt(ss);
			ss = "Thickness"; if(m.hasDouble(ss)) dContourThickness = m.getDouble(ss);
		}
		
	// adapt dScale and dScaleMin with the scale of viewport or shopdraw
//		dScale *= dScaleVP;
//		dScaleMin *= dScaleVP;
	// get extents of profile
		if(nPaperPlane)
		{ 
			PlaneProfile ppPaper(pnPaper);
			ppPaper.unionWith(pp);
			pp=PlaneProfile (pnPaper);
			pp.unionWith(ppPaper);
		}
		double dMin = U(10e7);
	// calculate min width rotating 0-180 by 10 degrees
		Vector3d vecXrotI = vecX;
		Vector3d vecYrotI = vecY;
		for (int irot=0;irot<17;irot++) 
		{ 
			LineSeg segI = pp.extentInDir(vecXrotI);
			double dXI=abs(vecXrotI.dotProduct(segI.ptStart()-segI.ptEnd()));
			if(dXI<dMin)dMin=dXI;
			vecXrotI=vecXrotI.rotateBy(U(10),vecZ);
		}//next irot
//		LineSeg seg = pp.extentInDir(vecX);
//		double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
//		double dY = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
//		double dMin = dX<dY?dX:dY;
		
	// 
		double dScaleFac=dScale;
		if (dScaleFac<0.01)dScaleFac=1;
		double dScale0=dScaleMin;
		if (bStatic)
		{
			// static, not adapted to the size, get the factor defined in dScale
			dScale0=dScaleFac;
			if (dScale0<dScaleMin)
			{ 
				dScale0=dScaleMin;
			}
		}
		else
		{ 
			// HSB-16233
			// dynamic, adapted to the minimum dimension
			// should not be smaller then dScaleMin
			dScale0=dScaleFac*(dMin/dScaleVP)/U(1000);
			if (dScale0<dScaleMin)
			{ 
				dScale0=dScaleMin;
			}
		}
		// multiply dScale0 with the global scaling factor
		dScale0*=dGlobalScaling;
		// check the color
		// by layer and by block will set the color of the attached layer at the TSL
		if (nColor<1)
		{ 
			// -2 by entity, -1 by layer, 0 by entity
			if (nColor==-2)
			{ 
				// get color from entity (sheet) and use this for the hatch
				nColor=sh.color();
			}
			else if (nColor<-2)
			{ 
				//nColor <- 2; -3,-4,-5 etc then take by entity
				nColor=- 2;
			}
		}
		if (nColorContour<1)
		{ 
			// -2 by entity, -1 by layer, 0 by entity
			if (nColorContour==-2)
			{ 
				// get color from entity (beam) and use this for the hatch
				nColorContour=sh.color();
			}
			else if (nColorContour<-2)
			{ 
				//nColor <- 2; -3,-4,-5 etc then take by entity
				nColorContour=-2;
			}
		}
		if (nSolidColor<1)
		{ 
			// -2 by entity, -1 by layer, 0 by entity
			if (nSolidColor==-2)
			{ 
				// get color from entity (beam) and use this for the hatch
				nSolidColor=sh.color();
			}
			else if (nSolidColor<-2)
			{ 
				//nColor <- 2; -3,-4,-5 etc then take by entity
				nSolidColor=- 2;
			}
		}
		// draw the hatch for the beam
		int nPattern=_HatchPatterns.findNoCase(sPattern,0);
		sPattern=nPattern>-1?_HatchPatterns[nPattern]:_HatchPatterns[0];
		// hatch object
		Hatch hatch(sPattern, dScale0);
		double dRotationTotal=dAngle+dRotation;
		//HSB-11326: transform to - 90;90
		if(dRotationTotal>=0 && dRotationTotal<=90)
			dRotationTotal=dRotationTotal;
		else if(dRotationTotal>90 && dRotationTotal<=180)
			dRotationTotal=dRotationTotal - 180;
		else if(dRotationTotal>180 && dRotationTotal<=270)
			dRotationTotal=dRotationTotal - 180;
		else if(dRotationTotal>270 && dRotationTotal<=360)
			dRotationTotal=dRotationTotal - 360;
		hatch.setAngle(dRotationTotal);
		dp.color(nColor);
		int _iTransparency=nTransparency;
		int _iSolidTransparency=nSolidTransparency;
		if(dGlobalTransparency<=0)
		{ 
			_iTransparency=0;
			_iSolidTransparency=0;
		}
		else if(dGlobalTransparency>0 && dGlobalTransparency<1)
		{ 
			_iTransparency=nTransparency*dGlobalTransparency;
			_iSolidTransparency=nSolidTransparency*dGlobalTransparency;
		}
		else if(dGlobalTransparency>1 && dGlobalTransparency<100)
		{ 
			_iTransparency=nTransparency+dGlobalTransparency*((100.0-nTransparency)/99.0);
			_iSolidTransparency=nSolidTransparency+dGlobalTransparency*((100.0-nSolidTransparency)/99.0);
		}
		else if(dGlobalTransparency>=100)
		{ 
			_iTransparency=100;
			_iSolidTransparency=100;
		}
		dp.transparency(_iTransparency);
//		if(!bInsulation)
		{
			if(bStatic && !bTransparency0)
			{
				if(!bInsulation)
					dp.draw(pp, hatch);
			}
			else if(bStatic && bTransparency0)
			{ 
				ppsStaticT.append(pp);
				nColorsT.append(nColor);
				nTransparencysT.append(_iTransparency);
//				sHatchPatternsT.append(sPattern);
				if(!bInsulation)
					sHatchPatternsT.append(sPattern);
				else
					sHatchPatternsT.append("");
//				sHatchPatternsT.append(sPattern);
				dAnglesT.append(dRotationTotal);
				dScaleFacsT.append(dScaleFac);
				dScaleMinsT.append(dScaleMin);
			}
			else
			{
				// empty planeprofile
				ppsStaticT.append(PlaneProfile());
				nColorsT.append(10e5);
				nTransparencysT.append(10e5);
				sHatchPatternsT.append("");
				dAnglesT.append(10e5);
				dScaleFacsT.append(10e5);
				dScaleMinsT.append(10e5);
			}
			if(!bStatic && !bTransparency0)
			{ 
				ppsDynamic.append(pp);
				nColorsDynamic.append(nColor);
				nTransparencysDynamic.append(_iTransparency);
				dScaleFacsDynamic.append(dScaleFac);
				dScaleMinsDynamic.append(dScaleMin);
				if(!bInsulation)
					sHatchPatternsDynamic.append(sPattern);
				else
					sHatchPatternsDynamic.append("");
				dAnglesDynamic.append(dRotationTotal);
				if (dMin>dMinAll)dMinAll=dMin;
				dMinsDynamic.append(dMin);
			}
			else if(!bStatic && bTransparency0)
			{ 
			// 
	//		pp.vis(3);
				ppsDynamicT.append(pp);
				nColorsDynamicT.append(nColor);
				nTransparencysDynamicT.append(_iTransparency);
				dScaleFacsDynamicT.append(dScaleFac);
				dScaleMinsDynamicT.append(dScaleMin);
				sHatchPatternsDynamicT.append(sPattern);
				dAnglesDynamicT.append(dRotationTotal);
				if (dMin>dMinAll)dMinAll=dMin;
				dMinsDynamicT.append(dMin);
			}
			else
			{ 
				ppsDynamicT.append(PlaneProfile());
				nColorsDynamicT.append(10e5);
				nTransparencysDynamicT.append(10e5);
				dScaleFacsDynamicT.append(10e5);
				dScaleMinsDynamicT.append(10e5);
				sHatchPatternsDynamicT.append("");
				dAnglesDynamicT.append(10e5);
				if (dMin>dMinAll)dMinAll=dMin;
				dMinsDynamicT.append(10e5);
			}
		}
		if(bTransparency0)
		{ 
			bdsT.append(bd);
			Point3d ptCenI=bd.ptCen();
			ptCenI.vis(6+i);
			bd.vis(6+i);
			ptCensT.append(bd.ptCen());
		}
		if(nPaperPlane)
		{ 
			LineSeg _segsVis[0];
			_segsVis.append(segsVis);
			segsVis.setLength(0);
			for (int iseg=0;iseg<_segsVis.length();iseg++) 
			{ 
				Point3d pt1Paper=_segsVis[iseg].ptStart();
				Point3d pt2Paper=_segsVis[iseg].ptEnd();
				pt1Paper=pnPaper.closestPointTo(pt1Paper);
				pt2Paper=pnPaper.closestPointTo(pt2Paper);
				LineSeg lSegPaper(pt1Paper,pt2Paper);
				segsVis.append(lSegPaper);
			}//next iseg
		}
		if(segsVis.length()>0 )
		{ 
			for (int iseg=0;iseg<segsVis.length();iseg++) 
			{ 
				dp.draw(segsVis[iseg]); 
			}//next iseg
		}
		if (nSolidHatch && !bTransparency0)
		{ 
			if(bHasSolidColor)
				dp.color(nSolidColor);
			// plot the solid hatch with transparency
			dp.transparency(_iSolidTransparency);
			dp.draw(pp, _kDrawFilled, _iSolidTransparency);
		}
		else if(nSolidHatch && bTransparency0)
		{ 
			bHasSolidColorsT.append(bHasSolidColor);
			// 0 transparency
			nSolidColorsT.append(nSolidColor);
			// plot the solid hatch with transparency
			_nSolidTransparencysT.append(_iSolidTransparency);
		}
		else
		{ 
			bHasSolidColorsT.append(false);
			nSolidColorsT.append(10e4);
			// plot the solid hatch with transparency
			_nSolidTransparencysT.append(10e4);
		}
		// contour
		if (bContour && !bTransparency0)
		{
			dp.transparency(0);
			PLine pls[]=pp.allRings();
			dp.color(nColorContour);
			for (int iPl = 0; iPl<pls.length(); iPl++)
			{
				PlaneProfile ppI(pp.coordSys());
				ppI.joinRing(pls[iPl], _kAdd);
				
				if (dContourThickness > 0)
				{
					ppI.shrink(-.5*dContourThickness);
					PlaneProfile ppContour=ppI;
					ppI.shrink(dContourThickness);
					ppContour.subtractProfile(ppI);
					dp.draw(ppContour,_kDrawFilled);
				}
				else
				{
					dp.draw(ppI);
				}
			}//next iPl
		}
		else if(bContour && bTransparency0)
		{ 
			Map m;
			nColorContoursT.append(nColorContour);
			PLine pls[]=pp.allRings();
			for (int iPl=0;iPl<pls.length();iPl++)
			{
				PlaneProfile ppI(pp.coordSys());
				ppI.joinRing(pls[iPl], _kAdd);
				PlaneProfile ppContour;
				if (dContourThickness>0)
				{
					ppI.shrink(-.5*dContourThickness);
					ppContour=ppI;
					ppI.shrink(dContourThickness);
					ppContour.subtractProfile(ppI);
				}
//				ppContour.transformBy(_ZW*2000);
//				ppContour.vis(6);
//				ppContour.transformBy(-_ZW*2000);
				
				m.appendPlaneProfile("pp",ppContour);
//				m.appendPlaneProfile("pp",ppI);
			}//next iPl
			mapContoursT.appendMap("m",m);
		}
		else
		{ 
			nColorContoursT.append(10e5);
			mapContoursT.appendMap("m",Map());
		}
		// insulation
		if(bInsulation)
		{ 
		// do the insulation
			// insulation pline
			PLine plInsulation(pp.coordSys().vecZ());
			PLine plInsulations[0];
			PlaneProfile ppInsulation(pp.coordSys());
			PlaneProfile ppInsulations[0];
			
			PLine plRings[] = pp.allRings(true, false);
			pp.vis(3);
		// calculate the insulation
	// get extents of profile
			Vector3d vecDird=vecZSheet.crossProduct(_ZW);
			Vector3d vecWidth=vecZSheet;
			if(sOrientation=="Z")
			{ 
				vecDird = vecXSheet;
				vecWidth=vecZSheet.crossProduct(vecDird);
			}
			vecDird.normalize();
			vecWidth.normalize();
			PLine plInsulationsFinal[0];
			{ 
				Map mInInsulation;
				mInInsulation.setPlaneProfile("pp",pp);
				mInInsulation.setVector3d("vecDir",vecDird);
				mInInsulation.setVector3d("vecWidth",vecWidth);
				mInInsulation.setDouble("dScaleLongitudinal",dScaleLongitudinal);
				mInInsulation.setDouble("dScaleTransversal",dScaleTransversal);
				mInInsulation.setDouble("dScale",dScale);
				mInInsulation.setDouble("dWidthModule",dWidthModule);
				mInInsulation.setDouble("dDiameterModule",dDiameterModule);
				
				PLine plInsulationsFinal_[]=calcInsulation(mInInsulation);
				plInsulationsFinal.append(plInsulationsFinal_);
			}
			dp.transparency(nTransparency);
			dp.color(nColor);
			for (int ipl=0;ipl<plInsulationsFinal.length();ipl++) 
			{ 
				dp.draw(plInsulationsFinal[ipl]);
			}//next ipl
//			dp.draw(ppInsulation,_kDrawFilled);
		}
		mapEntitiesUsed.appendMap("mapEntity",mapEntityI);
		// HSB-10159 save entity to be hatched and the hatch
		{ 
			entsHatch.append(sh);
			String sAngle=dRotationTotal; sAngle.format("%.2f", dRotationTotal);
			String sScale0=dScale0; sScale0.format("%.4f", dScale0);
			String sHatchIdentifier=sMaterial+sPattern+sAngle+sScale0+nColor+nSolidTransparency;
			if (sHatchIdentifiers.find(sHatchIdentifier) > - 1)
			{
				// hatch already saved
				continue;
			}
			
			sHatchIdentifiers.append(sHatchIdentifier);
			Map mapHatch;
			// material to which it is been used
			mapHatch.setString("sMaterial", sMaterial);
			// pattern
			mapHatch.setString("sPattern", sPattern);
			mapHatch.setDouble("dAngle", dRotationTotal);
			mapHatch.setDouble("dScale", dScale0);
			// solid hatch
			mapHatch.setInt("nColor", nColor);
			mapHatch.setInt("nSolidTransparency", nSolidTransparency);
			mapHatchesUsed.appendMap("mapHatch", mapHatch);
		}
	}//next i
//End hatch sheets//endregion
	
//region hatch slabs
	if (!bByPainter || bIsSlabPainter)
	for (int i = 0; i < slabs.length(); i++)
	{ 
		Slab& s = slabs[i];
		if (bByPainter && !s.acceptObject(painter.filter())){ continue;}
		if ( ! s.isVisible())continue;
		Group grps[] = s.groups();
		int bOff=true;
		for (int igrp=0;igrp<grps.length();igrp++) 
		{ 
			if(grps[igrp].groupVisibility(false)==_kIsOn)
			{ 
				bOff = false;
				break;
			}
		}//next igrp
		if (grps.length() == 0)bOff = false;
		if (bOff)continue;
		CoordSys csSlab = s.coordSys();
		Vector3d vecXSlab = csSlab.vecX();
		Vector3d vecYSlab = csSlab.vecY();
		Vector3d vecZSlab = csSlab.vecZ();
		Point3d ptOrg = csSlab.ptOrg();
		
		// transform vectors to the section coordinate system
		vecXSlab.transformBy(ms2ps);
		vecYSlab.transformBy(ms2ps);
		vecZSlab.transformBy(ms2ps);
		
//		vecXSlab.vis(ptCen, 1);
//		vecYSlab.vis(ptCen, 3);
//		vecZSlab.vis(ptCen, 150);
		
		// find the most aligned vector with the vecX1 of the section cut
		String sOrientation = "X";
		if (abs(vecYSlab.dotProduct(_ZW)) > abs(vecXSlab.dotProduct(_ZW))
		  && abs(vecYSlab.dotProduct(_ZW)) > abs(vecZSlab.dotProduct(_ZW)))
		{
			sOrientation = "Y";
		}
		else if (abs(vecZSlab.dotProduct(_ZW)) > abs(vecXSlab.dotProduct(_ZW))
		 && abs(vecZSlab.dotProduct(_ZW)) > abs(vecYSlab.dotProduct(_ZW)))
		{ 
			sOrientation = "Z";
		}
		
	// find the vector that gives the direction of panel and project to _XY plane
		Vector3d vecDir;
		if (sOrientation == "X")
		{ 
			// vecWoodGrainDirectionJ most aligned with _ZW
//			vecDir = _ZW.crossProduct(vecYSlab);
//			vecDir.normalize();
//			vecDir = _ZW.crossProduct(vecDir);
//			if (vecDir.length() < dEps)
//			{ 
//			// vecDir in the same direction with the _ZW
//				reportMessage(TN("|unexpected error 1010|"));
//				eraseInstance();
//				return;
//			}
//			vecDir.normalize();
			vecDir = vecXSlab;
		}
		else if (sOrientation == "Y" || sOrientation == "Z")
		{ 
			// vecNormalWoodGrainDirectionJ most aligned with _ZW
//			vecDir = _ZW.crossProduct(vecXSlab);
//			vecDir.normalize();
//			vecDir = _ZW.crossProduct(vecDir);
			vecDir = vecYSlab;
		}
		Map mapEntityI;mapEntityI.setEntity("ent", s);
		mapEntityI.setString("orientation0",sOrientation);
		// rotation wrt local axis
		double dRotation;
//		dRotation= _XW.angleTo(vecDir, _ZW);
		// angle between _ZW and vecDir
		Vector3d vecDirZw = vecDir.crossProduct(_ZW);
		vecDirZw.normalize();
		dRotation = vecDir.angleTo(_ZW, vecDirZw);
		
		// get the material of the slab
//		String sMaterial = s.material();
		String sMaterial;
		Body bd=s.realBody();
		Body bdIntersect=bd;
		int bIntersect=bdIntersect.intersectWith(bdClip);
		// Ticket ID #9984823
		// body intersect not reliable, use pp intersect
		int bHasIntersection=false;
		PlaneProfile ppIntersect;
		LineSeg segsVis[0];
		if (bHasSection)
		{ 
			if(bIntersect && bdIntersect.volume()>pow(dEps,3))
			{ 
				ppIntersect=bdIntersect.shadowProfile(pn0);
//					ppIntersect = bdIntersect.extractContactFaceInPlane(pn0,dSectionDepth);
				int bShowHiddenLines=false;
				int bShowOnlyHiddenLines=false;
				int bShowApproximatingEdges=false;
				CoordSys csView=csSection;
//					csView=CoordSys(csSection.ptOrg()-csSection.vecZ()*dSectionDepth, 
//						csSection.vecX(), csSection.vecY(), csSection.vecZ());
//					csView.vis(1);
				segsVis=bdIntersect.hideDisplay(csView,bShowHiddenLines,bShowOnlyHiddenLines,bShowApproximatingEdges);
//					for (int iseg=0;iseg<segsVis.length();iseg++) 
//					{ 
//						segsVis[iseg].vis(1); 
//					}//next iseg
				segsVis=pn0.projectLineSegs(segsVis);
				ppIntersect.vis(4);
			}
			else
			{ 
				// for section in model space
	//			CoordSys csSection = section.coordSys();
	//			csSection.transformBy(ps2ms);
	//			// vector normal with the viewport
	//			Vector3d vecNormal = csSection.vecZ();
	//			vecNormal.vis(_PtG[0], 6);
	//			Plane pn0(_PtG[0], vecNormal);
	//			Plane pn1(_PtG[1], vecNormal);
				bd.vis(3);
	//				PlaneProfile pptest = bd.extractContactFaceInPlane(pn0,U(1));
				pn0.vis(4);
				double dvolbd=bd.volume();
	//				double dAreatt = pptest.area();
				PlaneProfile ppBd0=bd.getSlice(pn0);
				PlaneProfile ppBd1=bd.getSlice(pn1);
				
				int nScenario=-1;
				if(ppBd0.area()>pow(dEps,2) || ppBd1.area()>pow(dEps,2))
				{ 
					// 1.
					nScenario=1;
				}
				else
				{ 
					// 2. or 3.
					// create sections between pn0 and pn1 and check whether it cuts the body
					Point3d ptCenBd=bd.ptCen();
					// point ptCenBd inside 2 points pt1 and pt2
					int bInside=true;
					{ 
						Vector3d vecDir=vecNormal;
						vecDir.normalize();
						double dLengthPtI=abs(vecDir.dotProduct(ptCenBd-pt1))
							 + abs(vecDir.dotProduct(ptCenBd-pt2));
						double dLengthSeg=abs(vecDir.dotProduct(pt1-pt2));
						if (abs(dLengthPtI-dLengthSeg)>dEps)bInside=false;
					}
					if(bInside)
					{
						Plane pnCen(ptCenBd, vecNormal);
						PlaneProfile ppCen=bd.getSlice(pnCen);
						if (ppCen.area()>pow(dEps, 2))
						{
							ppBd0=ppCen;
							nScenario=2;
						}
					}
				}
				if(nScenario==-1)
					continue;
				
	//			ppBd0.vis(4);
	//			ppBd1.vis(4);
				if (ppBd0.area()<dEps && ppBd1.area() < dEps)
				{ 
					// no intersection, go to next component
					continue;
				}
				// there is an intersection
				bHasIntersection=true;
				
				PlaneProfile ppBdShadow=bd.shadowProfile(pn0);
				ppBdShadow.vis(3);
				
	//			PlaneProfile ppBdClipShadow = bdClip.shadowProfile(pn0);
	//			ppBdClipShadow.vis(5);
				
				// intersection of ppBdShadow and ppBdClipShadow
				ppIntersect=ppBdShadow;
				ppIntersect.intersectWith(ppBdClipShadow);
				// HSB-11469
				PlaneProfile ppBdUnion=ppBd0; ppBdUnion.unionWith(ppBd1);
				ppIntersect.intersectWith(ppBdUnion);
				// HSB-18779:
				// transform from clip to section
//				ppIntersect.vis(5);
//				ppIntersect.transformBy(ms2ps);
//				ppIntersect.vis(5);
			}
			// transform from clip to section
			ppIntersect.transformBy(ms2ps);
			for (int iseg=0;iseg<segsVis.length();iseg++) 
			{ 
				segsVis[iseg].transformBy(ms2ps); 
			}//next iseg
		}
		else
		{ 
			// viewport in layout or viewport in shopdraw
			// transfor from model to layout
			bd.transformBy(ms2ps);
			bdIntersect = bd;
			bIntersect=bdIntersect.intersectWith(bdClip);
			if(bIntersect && bdIntersect.volume()>pow(dEps,3))
			{ 
				ppIntersect = bdIntersect.shadowProfile(pn0);
//					ppIntersect = bdIntersect.extractContactFaceInPlane(pn0,dSectionDepth);
				int bShowHiddenLines = false;
				int bShowOnlyHiddenLines = false;
				int bShowApproximatingEdges = false;
				CoordSys csView = csSection;
//					csView=CoordSys(csSection.ptOrg()-csSection.vecZ()*dSectionDepth, 
//						csSection.vecX(), csSection.vecY(), csSection.vecZ());
//					csView.vis(1);
				segsVis= bdIntersect.hideDisplay(csView, bShowHiddenLines, bShowOnlyHiddenLines, bShowApproximatingEdges);
//					for (int iseg=0;iseg<segsVis.length();iseg++) 
//					{ 
//						segsVis[iseg].vis(1); 
//					}//next iseg
				segsVis= pn0.projectLineSegs(segsVis);
				ppIntersect.vis(3);
			}
			else
			{ 
				double dSectionLevelPaper;
				double dSectionDepthPaper;
				{ 
	//				// top point in the model
	//				Point3d pt1 = ptMaxModel - vecZModel * dSectionLevel;
	//				// bottom point in the model
	//				Point3d pt2 = pt1 - vecZModel * dSectionDepth;
	//				if (dSectionDepth < dEps)
	//				{ 
	//					pt2 = pt1 - vecZModel * dEps;
	//				}
	//				pt1.transformBy(ms2ps);
	//				pt2.transformBy(ms2ps);
	//				
	//				pt1.vis(4);
	//				pt2.vis(4);
	//				
	//				Plane pn0(pt1, _ZW);
	//				Plane pn1(pt2, _ZW);
					PlaneProfile ppBd0=bd.getSlice(pn0);
					PlaneProfile ppBd1=bd.getSlice(pn1);
					int nScenario=-1;
					if(ppBd0.area()>pow(dEps,2) || ppBd1.area()>pow(dEps,2))
					{ 
						// 1.
						nScenario=1;
					}
					else
					{ 
						// 2. or 3.
						// create sections between pn0 and pn1 and check whether it cuts the body
						Point3d ptCenBd=bd.ptCen();
						// point ptCenBd inside 2 points pt1 and pt2
						int bInside=true;
						{ 
							Vector3d vecDir=vecNormal;
							vecDir.normalize();
							double dLengthPtI=abs(vecDir.dotProduct(ptCenBd-pt1))
								 + abs(vecDir.dotProduct(ptCenBd-pt2));
							double dLengthSeg=abs(vecDir.dotProduct(pt1-pt2));
							if (abs(dLengthPtI-dLengthSeg)>dEps)bInside=false;
						}
						if(bInside)
						{
							Plane pnCen(ptCenBd, vecNormal);
							PlaneProfile ppCen=bd.getSlice(pnCen);
							if (ppCen.area()>pow(dEps, 2))
							{
								ppBd0=ppCen;
								nScenario=2;
							}
						}
					}
					if(nScenario==-1)
						continue;
					
					double dArea0=ppBd0.area();
					double dArea1=ppBd1.area();
					if (ppBd0.area()<pow(dEps, 2) && ppBd1.area()<pow(dEps, 2))
					{ 
						// no intersection, go to next component
						continue;
					}
					// there is an intersection
					bHasIntersection=true;
					
					PlaneProfile ppBdShadow=bd.shadowProfile(pn0);
					ppBdShadow.vis(3);
	//				PlaneProfile ppBdClipShadow = bdClip.shadowProfile(pn0);
	//				ppBdClipShadow.vis(3);
					
					// intersection of ppBdShadow and ppBdClipShadow
					ppIntersect=ppBdShadow;
					ppIntersect.intersectWith(ppBdClipShadow);
					// HSB-11469
					PlaneProfile ppBdUnion=ppBd0; ppBdUnion.unionWith(ppBd1);
					ppIntersect.intersectWith(ppBdUnion);
					//
					ppIntersect.vis(5);
					// transform back to model
					bd.transformBy(ps2ms);
				}
			}
		}
		// Ticket ID #9984823
		// body intersect not reliable, use pp intersect
//		if ( ! bHasSection)
//		{ 
//			// paperspace layout or block space shopdrawing
//			bd.transformBy(ms2ps);
//		}
////		bd.vis(3);
////		bdClip.vis(1);
//		if (!bd.hasIntersection(bdClip))continue;
//		bd.intersectWith(bdClip);
//		bd.vis(2);
//		if (bHasSection)
//		{
//			// transform where the section is
//			bd.transformBy(ms2ps);
//		}
////		bd.vis(3);
////		PlaneProfile pp = bd.extractContactFaceInPlane(Plane(_Pt0, vecZ), dEps);
//		PlaneProfile pp = bd.shadowProfile(Plane(_Pt0, vecZ));
//		double dAreaPp = pp.area();
		
		PlaneProfile pp = ppIntersect;
		if (pp.area() < dEps)
		{ 
			// nothing to hatch, skip this "j" beam
			continue;
		}
		pp.vis(2);
	// get the map of the hatch for this material
		int bMaterialFound = false;
		int bOrientationFound = false;
		Map mapHatchFound, mapOrientationFound;
//		int bOrientationFound = false;
//		for (int k = 0; k < mapHatches.length(); k++)
//		{ 
//			Map mapHatchK = mapHatches.getMap(k);
//			if (mapHatchK.hasString("Name") && mapHatches.keyAt(k).makeLower() == "hatch")
//			{
//				// HSB-7706
//				if ( ! mapHatchK.getInt("isActive"))continue;
//				// the anisotropic condition
//				int bAnisotropic = mapHatchK.getInt("Anisotropic");
//				// get all materials for which this hatch pattern is applied
//				Map mapMaterials = mapHatchK.getMap("Material[]");
//				mapMaterials = mapHatchK.getMap("Material[]");
//				if (mapMaterials.length() < 1)
//				{
//					// no orientation map defined for this material 
//					reportMessage(TN("|no map of materials found for the material of the beam|"));
//					eraseInstance();
//					return;
//				}
//				nSolidHatch = mapHatchK.getInt("SolidHatch");
//				nSolidTransparency = mapHatchK.getInt("SolidTransparency");
//				
//				// find if the material is included in this hatch definition
//				for (int l = 0; l < mapMaterials.length(); l++)
//				{
//					Map mapMaterialL = mapMaterials.getMap(l);
//					if (mapMaterialL.hasString("Name") && mapMaterials.keyAt(l).makeLower() == "material")
//					{
//						String sMaterialMap = mapMaterialL.getString("Name");
//						if (sMaterialMap.makeUpper() == sMaterial.makeUpper())
//						{ 
//							// material found
//							bMaterialFound = true;
//							// break "l" loop for materials
//							break;
//						}
//					}
//				}//next l
//				if ( ! bMaterialFound)
//				{ 
//					// material not found at the mapMaterials of this mapHatch, keep looking
//					// continue lop k
//					continue;
//				}
//				// material is found, find the orientation
//				Map mapOrientations = mapHatchK.getMap("Orientation[]");
//				if (mapOrientations.length() < 1)
//				{ 
//					// no orientation map defined for this material 
//					reportMessage(TN("|no map of orientation found for the material of the beam|"));
//					eraseInstance();
//					return;
//				}
//			// find the orientation for this component, initialize with false
//				bOrientationFound = false;
//				// distinguish between isotropic and anisotropic materials
//				if ( ! bAnisotropic)
//				{ 
//					// isotropic material, simply get the first definition
//					for (int l = 0; l < mapOrientations.length(); l++)
//					{ 
//						Map mapOrientationL = mapOrientations.getMap(l);
//						if (mapOrientationL.hasString("Name") && mapOrientations.keyAt(l).makeLower() == "orientation")
//						{ 
//							// the right map found, get the hatch parameters
//							{ 
//								String ss;
//								Map m = mapOrientationL;
//								ss = "Pattern"; if(m.hasString(ss)) sPattern = m.getString(ss);
//								ss = "Color"; if(m.hasInt(ss)) nColor = m.getInt(ss);
//								ss = "Transparency"; if(m.hasInt(ss)) nTransparency = m.getInt(ss);
//								ss = "Angle"; if(m.hasDouble(ss)) dAngle = m.getDouble(ss);
//								ss = "Scale"; if(m.hasDouble(ss)) dScale = m.getDouble(ss);
//								ss = "ScaleMin"; if(m.hasDouble(ss)) dScaleMin = m.getDouble(ss);
//								ss = "Static"; if(m.hasDouble(ss)) bStatic = m.getDouble(ss);
//							}
//							bOrientationFound = true;
//							break;
//						}
//					}//next l
//				}
//				else
//				{ 
//					// anisotropic material, find the right one
//					for (int l = 0; l < mapOrientations.length(); l++)
//					{ 
//						Map mapOrientationL = mapOrientations.getMap(l);
//						if (mapOrientationL.hasString("Name") && mapOrientations.keyAt(l).makeLower() == "orientation")
//						{ 
//							String sOrientationMap = mapOrientationL.getString("Name");
//							if (sOrientationMap.makeUpper() != sOrientation.makeUpper())
//							{ 
//								// not this orientation
//								continue;
//							}
//							// the right map found, get the hatch parameters
//							{ 
//								String ss;
//								Map m = mapOrientationL;
//								ss = "Pattern"; if(m.hasString(ss)) sPattern = m.getString(ss);
//								ss = "Color"; if(m.hasInt(ss)) nColor = m.getInt(ss);
//								ss = "Transparency"; if(m.hasInt(ss)) nTransparency = m.getInt(ss);
//								ss = "Angle"; if(m.hasDouble(ss)) dAngle = m.getDouble(ss);
//								ss = "Scale"; if(m.hasDouble(ss)) dScale = m.getDouble(ss);
//								ss = "ScaleMin"; if(m.hasDouble(ss)) dScaleMin = m.getDouble(ss);
//								ss = "Static"; if(m.hasDouble(ss)) bStatic = m.getDouble(ss);
//							}
//							bOrientationFound = true;
//							break;
//						}
//					}//next l
//				}
//			}
//			if (bMaterialFound)
//			{ 
//				// first hatch that is found with this material will be used
//				// it will not look anymore
//				break;
//			}
//		}//next k
//		
//		// if material is found but orientation not found, skip the hatching
//		if ( bMaterialFound && ! bOrientationFound)
//		{ 
//			// dont do the hatching, go to the next component
//			continue;
//		}
		
		if ( (!bMaterialFound && bMapHatchDefaultFound && nHatchMapping==0) || 
			(!bMaterialFound && bMapHatchDefaultPainterFound && nHatchMapping==1) )
		{ 
			if(nHatchMapping==0)
			{ 
			// by material
				if (nHatchesUsed.find(nHatchDefaultIndex) < 0)nHatchesUsed.append(nHatchDefaultIndex);
				mapHatchFound = mapHatchDefault;
				bMaterialFound = true;
				mapEntityI.setInt("hatch0",nHatchDefaultIndex);
			}
			else if(nHatchMapping==1 && !bPainterGroup)
			{ 
			// by painter
				if (nHatchesUsed.find(nHatchDefaultPainterIndex) < 0)nHatchesUsed.append(nHatchDefaultPainterIndex);
				mapHatchFound = mapHatchDefaultPainter;
				bMaterialFound = true;
				mapEntityI.setInt("hatch0",nHatchDefaultPainterIndex);
			}
			else if(nHatchMapping && bPainterGroup)
			{ 
				for (int k = 0; k < mapHatches.length(); k++)
				{ 
					Map mapHatchK = mapHatches.getMap(k);
					if (mapHatchK.hasString("Name") && mapHatches.keyAt(k).makeLower() == "hatch")
					{
						// HSB-7706
						if ( ! mapHatchK.getInt("isActive"))continue;
						if ( ! mapHatchK.hasString("PainterGroup"))continue;
						// 
						if (!mapHatchK.hasString("Painter"))continue;
						if(mapHatchK.getString("Painter")!=sRule)continue;
						String sPainterGroupMap = mapHatchK.getString("PainterGroup");
						String sFormatI=s.formatObject(sPainterFormat);
						if(sPainterGroupMap.makeUpper()==sFormatI.makeUpper())
						{ 
							mapHatchFound = mapHatchK;
							if (nHatchesUsed.find(k) < 0)nHatchesUsed.append(k);
							bMaterialFound = true;
							mapEntityI.setInt("hatch0",k);
							break;
						}
					}
				}
			}
			int bAnisotropic = mapHatchFound.getInt("Anisotropic");
			if(!bAnisotropic)mapEntityI.setString("orientation0","X");
			// if the material is not found, use the default hatch
			Map mapOrientations = mapHatchFound.getMap("Orientation[]");
			if (mapOrientations.length() < 1)
			{ 
				// no orientation map defined for this material 
				reportMessage("\n"+scriptName()+" "+T("|no map of orientation found for the material of the beam|"));
				eraseInstance();
				return;
			}
			bOrientationFound = false;
			if ( ! bAnisotropic)
			{
				for (int l = 0; l < mapOrientations.length(); l++)
				{ 
					Map mapOrientationL = mapOrientations.getMap(l);
					if (mapOrientationL.hasString("Name") && mapOrientations.keyAt(l).makeLower() == "orientation")
					{ 
						mapOrientationFound = mapOrientationL;
						bOrientationFound = true;
						break;
					}
				}//next l
			}
			else
			{ 
				// find the orientation for this component
				for (int l = 0; l < mapOrientations.length(); l++)
				{ 
					Map mapOrientationL = mapOrientations.getMap(l);
					if (mapOrientationL.hasString("Name") && mapOrientations.keyAt(l).makeLower() == "orientation")
					{ 
						String sOrientationMap = mapOrientationL.getString("Name");
						if (sOrientationMap.makeUpper() != sOrientation.makeUpper())
						{ 
							// not this orientation
							continue;
						}
						bOrientationFound = true;
						mapOrientationFound = mapOrientationL;
						break;
					}
				}//next l
			}
		}
		
		// if no material found and no default material
		if ( (!bMaterialFound && !bMapHatchDefaultFound && nHatchMapping==0) ||
			  (!bMaterialFound && !bMapHatchDefaultPainterFound && nHatchMapping==1) ||
			  (!bMaterialFound && bMapPainterGroupsFoundAll && nHatchMapping && bPainterGroup))
		{ 
			// go to next entity (panel component)
			continue;
		}
		// default values
		{ 
			nSolidHatch=0;
			nSolidTransparency = 0;
			nSolidColor = 0;
			bHasSolidColor = 0;
			// default orientation hatch parameters
			sPattern = "ANSI31";// hatch pattern
			nColor = 1;// color index
			nTransparency = 0;// transparency
			dAngle = 0;// hatch angle
			dScale = 10.0;// hatch scale
			dScaleMin = 25;// dScaleMin
			bStatic = 0;// by default make dynamic
			// contour parameters
			bContour = 0;
			nColorContour = 0;
			dContourThickness = 0;
		}
		{ 
			String ss;
			Map m = mapHatchFound;
			ss = "SolidHatch"; if(m.hasInt(ss)) nSolidHatch = m.getInt(ss);
			ss = "SolidTransparency"; if(m.hasInt(ss)) nSolidTransparency = m.getInt(ss);
			ss = "SolidColor"; if(m.hasInt(ss)) nSolidColor = m.getInt(ss);
			ss = "SolidColor"; bHasSolidColor= m.hasInt(ss);
		}
		// properties in orientation map
		{ 
			String ss;
			Map m = mapOrientationFound;
			ss = "Pattern"; if(m.hasString(ss)) sPattern = m.getString(ss);
			ss = "Color"; if(m.hasInt(ss)) nColor = m.getInt(ss);
			ss = "Transparency"; if(m.hasInt(ss)) nTransparency = m.getInt(ss);
			ss = "Angle"; if(m.hasDouble(ss)) dAngle = m.getDouble(ss);
			ss = "Scale"; if(m.hasDouble(ss)) dScale = m.getDouble(ss);
			ss = "ScaleMin"; if(m.hasDouble(ss)) dScaleMin = m.getDouble(ss);
			ss = "Static"; if(m.hasInt(ss)) bStatic = m.getInt(ss);
		}
		// properties in contour map
		Map mapContour = mapHatchFound.getMap("Contour");
		{ 
			String ss;
			Map m = mapContour;
			ss = "Contour"; if(m.hasInt(ss)) bContour = m.getInt(ss);
			ss = "Color"; if(m.hasInt(ss)) nColorContour = m.getInt(ss);
			ss = "Thickness"; if(m.hasDouble(ss)) dContourThickness = m.getDouble(ss);
		}
		
	// adapt dScale and dScaleMin with the scale of viewport or shopdraw
//		dScale *= dScaleVP;//!!!
//		dScaleMin *= dScaleVP;
	// get extents of profile
		if(nPaperPlane)
		{ 
			PlaneProfile ppPaper(pnPaper);
			ppPaper.unionWith(pp);
			pp=PlaneProfile (pnPaper);
			pp.unionWith(ppPaper);
		}
		double dMin = U(10e7);
	// calculate min width rotating 0-180 by 10 degrees
		Vector3d vecXrotI = vecX;
		Vector3d vecYrotI = vecY;
		for (int irot=0;irot<17;irot++) 
		{ 
			LineSeg segI = pp.extentInDir(vecXrotI);
			double dXI=abs(vecXrotI.dotProduct(segI.ptStart()-segI.ptEnd()));
			if(dXI<dMin)dMin=dXI;
			vecXrotI=vecXrotI.rotateBy(U(10),vecZ);
		}//next irot
//		LineSeg seg = pp.extentInDir(vecX);
//		seg.vis(4);
//		double dX = abs(vecX.dotProduct(seg.ptStart() - seg.ptEnd()));
//		double dY = abs(vecY.dotProduct(seg.ptStart() - seg.ptEnd()));
//		double dMin = dX<dY ? dX : dY;
		
	// 
		double dScaleFac = dScale;
		if (dScaleFac < 0.01)dScaleFac = 1;
		double dScale0 = dScaleMin;
		if (bStatic)
		{
			// static, not adapted to the size, get the factor defined in dScale
			dScale0 = dScaleFac;
			if (dScale0 < dScaleMin)
			{ 
				dScale0 = dScaleMin;
			}
		}
		else
		{ 
			// dynamic, adapted to the minimum dimension
			// should not be smaller then dScaleMin
			dScale0=dScaleFac*(dMin/dScaleVP)/U(1000);
			if (dScale0 < dScaleMin)
			{ 
				dScale0 = dScaleMin;
			}
		}
		// multiply dScale0 with the global scaling factor
		dScale0 *= dGlobalScaling;
		// check the color
		// by layer and by block will set the color of the attached layer at the TSL
		if (nColor < 1)
		{ 
			// -2 by entity, -1 by layer, 0 by entity
			if (nColor == -2)
			{ 
				// get color from entity (beam) and use this for the hatch
				nColor = s.color();
			}
			else if (nColor <- 2)
			{ 
				//nColor <- 2; -3,-4,-5 etc then take by entity
				nColor = - 2;
			}
		}
		if (nColorContour < 1)
		{ 
			// -2 by entity, -1 by layer, 0 by entity
			if (nColorContour == -2)
			{ 
				// get color from entity (beam) and use this for the hatch
				nColorContour = s.color();
			}
			else if (nColorContour <- 2)
			{ 
				//nColor <- 2; -3,-4,-5 etc then take by entity
				nColorContour = - 2;
			}
		}
		if (nSolidColor < 1)
		{ 
			// -2 by entity, -1 by layer, 0 by entity
			if (nSolidColor == -2)
			{ 
				// get color from entity (beam) and use this for the hatch
				nSolidColor = s.color();
			}
			else if (nSolidColor <- 2)
			{ 
				//nColor <- 2; -3,-4,-5 etc then take by entity
				nSolidColor = - 2;
			}
		}
		// draw the hatch for the beam
		int nPattern = _HatchPatterns.findNoCase(sPattern, 0);
		sPattern = nPattern >- 1 ? _HatchPatterns[nPattern] : _HatchPatterns[0];
		// hatch object
		Hatch hatch(sPattern, dScale0);
		double dRotationTotal = dAngle + dRotation;
		//HSB-11326:transform to - 90;90
		if(dRotationTotal>=0 && dRotationTotal<=90)
			dRotationTotal = dRotationTotal;
		else if(dRotationTotal>90 && dRotationTotal<=180)
			dRotationTotal = dRotationTotal - 180;
		else if(dRotationTotal>180 && dRotationTotal<=270)
			dRotationTotal = dRotationTotal - 180;
		else if(dRotationTotal>270 && dRotationTotal<=360)
			dRotationTotal = dRotationTotal - 360;
		//
		hatch.setAngle(dRotationTotal);
		dp.color(nColor);
		int _iTransparency=nTransparency;
		int _iSolidTransparency=nSolidTransparency;
		if(dGlobalTransparency<=0)
		{ 
			_iTransparency = 0;
			_iSolidTransparency = 0;
		}
		else if(dGlobalTransparency>0 && dGlobalTransparency<1)
		{ 
			_iTransparency = nTransparency * dGlobalTransparency;
			_iSolidTransparency=nSolidTransparency* dGlobalTransparency;
		}
		else if(dGlobalTransparency>1 && dGlobalTransparency<100)
		{ 
			_iTransparency = nTransparency+dGlobalTransparency*((100.0 - nTransparency) / 99.0);
			_iSolidTransparency = nSolidTransparency+dGlobalTransparency*((100.0 - nSolidTransparency) / 99.0);
		}
		else if(dGlobalTransparency>=100)
		{ 
			_iTransparency = 100;
			_iSolidTransparency = 100;
		}
		dp.transparency(_iTransparency);
		if(bStatic && !bTransparency0)
		{
			dp.draw(pp, hatch);
		}
		else if(bStatic && bTransparency0)
		{ 
			ppsStaticT.append(pp);
			nColorsT.append(nColor);
			nTransparencysT.append(_iTransparency);
			sHatchPatternsT.append(sPattern);
			dAnglesT.append(dRotationTotal);
			dScaleFacsT.append(dScaleFac);
			dScaleMinsT.append(dScaleMin);
		}
		else
		{
			// empty planeprofile
			ppsStaticT.append(PlaneProfile());
			nColorsT.append(10e5);
			nTransparencysT.append(10e5);
			sHatchPatternsT.append(10e5);
			dAnglesT.append(10e5);
			dScaleFacsT.append(10e5);
			dScaleMinsT.append(10e5);
		}
	//
		if(!bStatic && !bTransparency0)
		{ 
			ppsDynamic.append(pp);
			nColorsDynamic.append(nColor);
			nTransparencysDynamic.append(_iTransparency);
			dScaleFacsDynamic.append(dScaleFac);
			dScaleMinsDynamic.append(dScaleMin);
			sHatchPatternsDynamic.append(sPattern);
			dAnglesDynamic.append(dRotationTotal);
			if (dMin>dMinAll)dMinAll=dMin;
			dMinsDynamic.append(dMin);
		}
		else if(!bStatic && bTransparency0)
		{ 
		// 
//		pp.vis(3);
			ppsDynamicT.append(pp);
			nColorsDynamicT.append(nColor);
			nTransparencysDynamicT.append(_iTransparency);
			dScaleFacsDynamicT.append(dScaleFac);
			dScaleMinsDynamicT.append(dScaleMin);
			sHatchPatternsDynamicT.append(sPattern);
			dAnglesDynamicT.append(dRotationTotal);
			if (dMin>dMinAll)dMinAll=dMin;
			dMinsDynamicT.append(dMin);
		}
		else
		{ 
			ppsDynamicT.append(PlaneProfile());
			nColorsDynamicT.append(10e5);
			nTransparencysDynamicT.append(10e5);
			dScaleFacsDynamicT.append(10e5);
			dScaleMinsDynamicT.append(10e5);
			sHatchPatternsDynamicT.append(10e5);
			dAnglesDynamicT.append(10e5);
			if (dMin>dMinAll)dMinAll=dMin;
			dMinsDynamicT.append(10e5);
		}
		if(bTransparency0)
		{ 
			bdsT.append(bd);
			Point3d ptCenI=bd.ptCen();
			ptCenI.vis(6+i);
			bd.vis(6+i);
			ptCensT.append(bd.ptCen());
		}
		if(nPaperPlane)
		{ 
			LineSeg _segsVis[0];
			_segsVis.append(segsVis);
			segsVis.setLength(0);
			for (int iseg=0;iseg<_segsVis.length();iseg++) 
			{ 
				Point3d pt1Paper=_segsVis[iseg].ptStart();
				Point3d pt2Paper=_segsVis[iseg].ptEnd();
				pt1Paper=pnPaper.closestPointTo(pt1Paper);
				pt2Paper=pnPaper.closestPointTo(pt2Paper);
				LineSeg lSegPaper(pt1Paper,pt2Paper);
				segsVis.append(lSegPaper);
			}//next iseg
		}
		if(segsVis.length()>0 )
		{ 
			for (int iseg=0;iseg<segsVis.length();iseg++) 
			{ 
				dp.draw(segsVis[iseg]); 
			}//next iseg
		}
		if (nSolidHatch && !bTransparency0)
		{ 
			if(bHasSolidColor)
				dp.color(nSolidColor);
			// plot the solid hatch with transparency
			dp.transparency(_iSolidTransparency);
			dp.draw(pp, _kDrawFilled, _iSolidTransparency);
		}
		else if(nSolidHatch && bTransparency0)
		{ 
			bHasSolidColorsT.append(bHasSolidColor);
			// 0 transparency
			nSolidColorsT.append(nSolidColor);
			// plot the solid hatch with transparency
			_nSolidTransparencysT.append(_iSolidTransparency);
		}
		else
		{ 
			bHasSolidColorsT.append(false);
			nSolidColorsT.append(10e4);
			// plot the solid hatch with transparency
			_nSolidTransparencysT.append(10e4);
		}
		// contour
		if (bContour && !bTransparency0)
		{
			dp.transparency(0);
			PLine pls[] = pp.allRings();
			dp.color(nColorContour);
			for (int iPl = 0; iPl < pls.length(); iPl++)
			{
				PlaneProfile ppI(pp.coordSys());
				ppI.joinRing(pls[iPl], _kAdd);
				
				if (dContourThickness > 0)
				{
					ppI.shrink(-.5 * dContourThickness);
					PlaneProfile ppContour = ppI;
					ppI.shrink(dContourThickness);
					ppContour.subtractProfile(ppI);
					dp.draw(ppContour, _kDrawFilled);
				}
				else
				{
					dp.draw(ppI);
				}
			}//next iPl
		}
		else if(bContour && bTransparency0)
		{ 
			Map m;
			nColorContoursT.append(nColorContour);
			PLine pls[]=pp.allRings();
			for (int iPl=0;iPl<pls.length();iPl++)
			{
				PlaneProfile ppI(pp.coordSys());
				ppI.joinRing(pls[iPl], _kAdd);
				PlaneProfile ppContour;
				if (dContourThickness>0)
				{
					ppI.shrink(-.5*dContourThickness);
					ppContour=ppI;
					ppI.shrink(dContourThickness);
					ppContour.subtractProfile(ppI);
				}
//				ppContour.transformBy(_ZW*2000);
//				ppContour.vis(6);
//				ppContour.transformBy(-_ZW*2000);
				
				m.appendPlaneProfile("pp",ppContour);
//				m.appendPlaneProfile("pp",ppI);
			}//next iPl
			mapContoursT.appendMap("m",m);
		}
		else
		{ 
			nColorContoursT.append(10e5);
			mapContoursT.appendMap("m",Map());
		}
		mapEntitiesUsed.appendMap("mapEntity",mapEntityI);
		// HSB-10159 save entity to be hatched and the hatch
		{ 
			entsHatch.append(s);
			String sAngle = dRotationTotal; sAngle.format("%.2f", dRotationTotal);
			String sScale0 = dScale0; sScale0.format("%.4f", dScale0);
			String sHatchIdentifier = sMaterial + sPattern + sAngle + sScale0 + nColor + nSolidTransparency;
			if (sHatchIdentifiers.find(sHatchIdentifier) > - 1)
			{
				// hatch already saved
				continue;
			}
			
			sHatchIdentifiers.append(sHatchIdentifier);
			Map mapHatch;
			// material to which it is been used
			mapHatch.setString("sMaterial", sMaterial);
			// pattern
			mapHatch.setString("sPattern", sPattern);
			mapHatch.setDouble("dAngle", dRotationTotal);
			mapHatch.setDouble("dScale", dScale0);
			// solid hatch
			mapHatch.setInt("nColor", nColor);
			mapHatch.setInt("nSolidTransparency", nSolidTransparency);
			mapHatchesUsed.appendMap("mapHatch", mapHatch);
		}
	}//next i
//End hatch slabs//endregion

//region hatch walls
//	if (!bByPainter || bIsWallPainter)
	for (int i = 0; i < walls.length(); i++)
	{ 
		Wall& w = walls[i];
		if (bByPainter && !w.acceptObject(painter.filter())){ continue;}
		if ( ! w.isVisible())continue;
		Group grps[] = w.groups();
		int bOff=true;
		for (int igrp=0;igrp<grps.length();igrp++) 
		{ 
			if(grps[igrp].groupVisibility(false)==_kIsOn)
			{ 
				bOff = false;
				break;
			}
		}//next igrp
		if (grps.length() == 0)bOff = false;
		if (bOff)continue;
		CoordSys csWall = w.coordSys();
		Vector3d vecXWall = csWall.vecX();
		Vector3d vecYWall = csWall.vecY();
		Vector3d vecZWall = csWall.vecZ();
		Point3d ptOrg = csWall.ptOrg();
		
		// transform vectors to the section coordinate system
		vecXWall.transformBy(ms2ps);
		vecYWall.transformBy(ms2ps);
		vecZWall.transformBy(ms2ps);
		
//		vecXSlab.vis(ptCen, 1);
//		vecYSlab.vis(ptCen, 3);
//		vecZSlab.vis(ptCen, 150);
		
		// find the most aligned vector with the vecX1 of the section cut
		String sOrientation = "X";
		if (abs(vecYWall.dotProduct(_ZW)) > abs(vecXWall.dotProduct(_ZW))
		  && abs(vecYWall.dotProduct(_ZW)) > abs(vecZWall.dotProduct(_ZW)))
		{
			sOrientation = "Y";
		}
		else if (abs(vecZWall.dotProduct(_ZW)) > abs(vecXWall.dotProduct(_ZW))
		 && abs(vecZWall.dotProduct(_ZW)) > abs(vecYWall.dotProduct(_ZW)))
		{ 
			sOrientation = "Z";
		}
		
	// find the vector that gives the direction of panel and project to _XY plane
		Vector3d vecDir;
		if (sOrientation == "X")
		{ 
			// vecWoodGrainDirectionJ most aligned with _ZW
//			vecDir = _ZW.crossProduct(vecYWall);
//			vecDir.normalize();
//			vecDir = _ZW.crossProduct(vecDir);
//			if (vecDir.length() < dEps)
//			{ 
//			// vecDir in the same direction with the _ZW
//				reportMessage(TN("|unexpected error 1010|"));
//				eraseInstance();
//				return;
//			}
//			vecDir.normalize();
			vecDir = vecXWall;
		}
		else if (sOrientation == "Y" || sOrientation == "Z")
		{ 
			// vecNormalWoodGrainDirectionJ most aligned with _ZW
//			vecDir = _ZW.crossProduct(vecXWall);
//			vecDir.normalize();
//			vecDir = _ZW.crossProduct(vecDir);
			if(sOrientation=="Y")
				vecDir = vecYWall;
			else if(sOrientation=="Z")
				vecDir = vecZWall;
		}
		vecDir.vis(ptOrg, 3);
		Map mapEntityI;mapEntityI.setEntity("ent", w);
		mapEntityI.setString("orientation0",sOrientation);
		// rotation wrt local axis
		double dRotation;
//		dRotation= _XW.angleTo(vecDir, _ZW);
		// angle between _ZW and vecDir
		Vector3d vecDirZw = vecDir.crossProduct(_ZW);
		vecDirZw.normalize();
		dRotation = vecDir.angleTo(_ZW, vecDirZw);
		
		// get the material of the wall
//		String sMaterial = s.material();
		String sMaterial;
		Body bd = w.realBody();
		Body bdIntersect=bd;
		int bIntersect=bdIntersect.intersectWith(bdClip);
		// Ticket ID #9984823
		// body intersect not reliable, use pp intersect
		int bHasIntersection = false;
		PlaneProfile ppIntersect;
		LineSeg segsVis[0];
		if (bHasSection)
		{ 
			if(bIntersect && bdIntersect.volume()>pow(dEps,3))
			{ 
				ppIntersect=bdIntersect.shadowProfile(pn0);
//					ppIntersect = bdIntersect.extractContactFaceInPlane(pn0,dSectionDepth);
				int bShowHiddenLines=false;
				int bShowOnlyHiddenLines=false;
				int bShowApproximatingEdges=false;
				CoordSys csView=csSection;
//					csView=CoordSys(csSection.ptOrg()-csSection.vecZ()*dSectionDepth, 
//						csSection.vecX(), csSection.vecY(), csSection.vecZ());
//					csView.vis(1);
				segsVis=bdIntersect.hideDisplay(csView,bShowHiddenLines,bShowOnlyHiddenLines,bShowApproximatingEdges);
//					for (int iseg=0;iseg<segsVis.length();iseg++) 
//					{ 
//						segsVis[iseg].vis(1); 
//					}//next iseg
				segsVis=pn0.projectLineSegs(segsVis);
				ppIntersect.vis(4);
			}
			else
			{ 
	//			// for section in model space
	//			CoordSys csSection = section.coordSys();
	//			csSection.transformBy(ps2ms);
	//			// vector normal with the viewport
	//			Vector3d vecNormal = csSection.vecZ();
	//			vecNormal.vis(_PtG[0], 6);
	//			Plane pn0(_PtG[0], vecNormal);
	//			Plane pn1(_PtG[1], vecNormal);
				bd.vis(3);
	//				PlaneProfile pptest = bd.extractContactFaceInPlane(pn0,U(1));
				pn0.vis(4);
				double dvolbd = bd.volume();
	//				double dAreatt = pptest.area();
				PlaneProfile ppBd0 = bd.getSlice(pn0);
				PlaneProfile ppBd1 = bd.getSlice(pn1);
				
				int nScenario=-1;
				if(ppBd0.area()>pow(dEps,2) || ppBd1.area()>pow(dEps,2))
				{ 
					// 1.
					nScenario = 1;
				}
				else
				{ 
					// 2. or 3.
					// create sections between pn0 and pn1 and check whether it cuts the body
					Point3d ptCenBd = bd.ptCen();
					// point ptCenBd inside 2 points pt1 and pt2
					int bInside=true;
					{ 
						Vector3d vecDir = vecNormal;
						vecDir.normalize();
						double dLengthPtI=abs(vecDir.dotProduct(ptCenBd-pt1))
							 + abs(vecDir.dotProduct(ptCenBd - pt2));
						double dLengthSeg = abs(vecDir.dotProduct(pt1 - pt2));
						if (abs(dLengthPtI - dLengthSeg) > dEps)bInside=false;
					}
					if(bInside)
					{
						Plane pnCen(ptCenBd, vecNormal);
						PlaneProfile ppCen = bd.getSlice(pnCen);
						if (ppCen.area() > pow(dEps, 2))
						{
							ppBd0 = ppCen;
							nScenario = 2;
						}
					}
				}
				if(nScenario==-1)
					continue;
				
	//			ppBd0.vis(4);
	//			ppBd1.vis(4);
				if (ppBd0.area() < dEps && ppBd1.area() < dEps)
				{ 
					// no intersection, go to next component
					continue;
				}
				// there is an intersection
				bHasIntersection = true;
				
				PlaneProfile ppBdShadow = bd.shadowProfile(pn0);
				ppBdShadow.vis(3);
				
	//			PlaneProfile ppBdClipShadow = bdClip.shadowProfile(pn0);
	//			ppBdClipShadow.vis(3);
				
				// intersection of ppBdShadow and ppBdClipShadow
				ppIntersect = ppBdShadow;
				ppIntersect.intersectWith(ppBdClipShadow);
				// HSB-11469
				PlaneProfile ppBdUnion = ppBd0; ppBdUnion.unionWith(ppBd1);
				ppIntersect.intersectWith(ppBdUnion);
				// HSB-18779:
				// transform from clip to section
//				ppIntersect.transformBy(ms2ps);
//				ppIntersect.vis(5);
			}
		// transform from clip to section
			ppIntersect.transformBy(ms2ps);
			for (int iseg=0;iseg<segsVis.length();iseg++) 
			{ 
				segsVis[iseg].transformBy(ms2ps); 
			}//next iseg
		}
		else
		{ 
			// viewport in layout or viewport in shopdraw
			// transfor from model to layout
			bd.transformBy(ms2ps);
			bdIntersect = bd;
			bIntersect=bdIntersect.intersectWith(bdClip);
			if(bIntersect && bdIntersect.volume()>pow(dEps,3))
			{ 
				ppIntersect = bdIntersect.shadowProfile(pn0);
//					ppIntersect = bdIntersect.extractContactFaceInPlane(pn0,dSectionDepth);
				int bShowHiddenLines = false;
				int bShowOnlyHiddenLines = false;
				int bShowApproximatingEdges = false;
				CoordSys csView = csSection;
//					csView=CoordSys(csSection.ptOrg()-csSection.vecZ()*dSectionDepth, 
//						csSection.vecX(), csSection.vecY(), csSection.vecZ());
//					csView.vis(1);
				segsVis= bdIntersect.hideDisplay(csView, bShowHiddenLines, bShowOnlyHiddenLines, bShowApproximatingEdges);
//					for (int iseg=0;iseg<segsVis.length();iseg++) 
//					{ 
//						segsVis[iseg].vis(1); 
//					}//next iseg
				segsVis= pn0.projectLineSegs(segsVis);
				ppIntersect.vis(3);
			}
			else
			{ 
				double dSectionLevelPaper;
				double dSectionDepthPaper;
				{ 
	//				// top point in the model
	//				Point3d pt1 = ptMaxModel - vecZModel * dSectionLevel;
	//				// bottom point in the model
	//				Point3d pt2 = pt1 - vecZModel * dSectionDepth;
	//				if (dSectionDepth < dEps)
	//				{ 
	//					pt2 = pt1 - vecZModel * dEps;
	//				}
	//				pt1.transformBy(ms2ps);
	//				pt2.transformBy(ms2ps);
	//				
	//				pt1.vis(4);
	//				pt2.vis(4);
	//				
	//				Plane pn0(pt1, _ZW);
	//				Plane pn1(pt2, _ZW);
					PlaneProfile ppBd0 = bd.getSlice(pn0);
					PlaneProfile ppBd1 = bd.getSlice(pn1);
					int nScenario=-1;
					if(ppBd0.area()>pow(dEps,2) || ppBd1.area()>pow(dEps,2))
					{ 
						// 1.
						nScenario = 1;
					}
					else
					{ 
						// 2. or 3.
						// create sections between pn0 and pn1 and check whether it cuts the body
						Point3d ptCenBd = bd.ptCen();
						// point ptCenBd inside 2 points pt1 and pt2
						int bInside=true;
						{ 
							Vector3d vecDir = vecNormal;
							vecDir.normalize();
							double dLengthPtI=abs(vecDir.dotProduct(ptCenBd-pt1))
								 + abs(vecDir.dotProduct(ptCenBd - pt2));
							double dLengthSeg = abs(vecDir.dotProduct(pt1 - pt2));
							if (abs(dLengthPtI - dLengthSeg) > dEps)bInside=false;
						}
						if(bInside)
						{
							Plane pnCen(ptCenBd, vecNormal);
							PlaneProfile ppCen = bd.getSlice(pnCen);
							if (ppCen.area() > pow(dEps, 2))
							{
								ppBd0 = ppCen;
								nScenario = 2;
							}
						}
					}
					if(nScenario==-1)
						continue;
					
					double dArea0 = ppBd0.area();
					double dArea1 = ppBd1.area();
					if (ppBd0.area() < pow(dEps, 2) && ppBd1.area() < pow(dEps, 2))
					{ 
						// no intersection, go to next component
						continue;
					}
					// there is an intersection
					bHasIntersection = true;
					
					PlaneProfile ppBdShadow = bd.shadowProfile(pn0);
					ppBdShadow.vis(3);
	//				PlaneProfile ppBdClipShadow = bdClip.shadowProfile(pn0);
	//				ppBdClipShadow.vis(3);
					
					// intersection of ppBdShadow and ppBdClipShadow
					ppIntersect = ppBdShadow;
					ppIntersect.intersectWith(ppBdClipShadow);
					// HSB-11469
					PlaneProfile ppBdUnion = ppBd0; ppBdUnion.unionWith(ppBd1);
					ppIntersect.intersectWith(ppBdUnion);
					//
					ppIntersect.vis(5);
					// transform back to model
					bd.transformBy(ps2ms);
				}
			}
		}
		// Ticket ID #9984823
		// body intersect not reliable, use pp intersect
//		if ( ! bHasSection)
//		{ 
//			// paperspace layout or block space shopdrawing
//			bd.transformBy(ms2ps);
//		}
////		bd.vis(3);
////		bdClip.vis(1);
//		if (!bd.hasIntersection(bdClip))continue;
//		bd.intersectWith(bdClip);
//		bd.vis(2);
//		if (bHasSection)
//		{
//			// transform where the section is
//			bd.transformBy(ms2ps);
//		}
////		bd.vis(3);
////		PlaneProfile pp = bd.extractContactFaceInPlane(Plane(_Pt0, vecZ), dEps);
//		PlaneProfile pp = bd.shadowProfile(Plane(_Pt0, vecZ));
//		double dAreaPp = pp.area();
		
		PlaneProfile pp = ppIntersect;
		if (pp.area() < dEps)
		{ 
			// nothing to hatch, skip this "j" beam
			continue;
		}
		pp.vis(2);
	// get the map of the hatch for this material
		int bMaterialFound = false;
		int bOrientationFound = false;
		Map mapHatchFound, mapOrientationFound;
//		int bOrientationFound = false;
//		for (int k = 0; k < mapHatches.length(); k++)
//		{ 
//			Map mapHatchK = mapHatches.getMap(k);
//			if (mapHatchK.hasString("Name") && mapHatches.keyAt(k).makeLower() == "hatch")
//			{
//				// HSB-7706
//				if ( ! mapHatchK.getInt("isActive"))continue;
//				// the anisotropic condition
//				int bAnisotropic = mapHatchK.getInt("Anisotropic");
//				// get all materials for which this hatch pattern is applied
//				Map mapMaterials = mapHatchK.getMap("Material[]");
//				mapMaterials = mapHatchK.getMap("Material[]");
//				if (mapMaterials.length() < 1)
//				{
//					// no orientation map defined for this material 
//					reportMessage(TN("|no map of materials found for the material of the beam|"));
//					eraseInstance();
//					return;
//				}
//				nSolidHatch = mapHatchK.getInt("SolidHatch");
//				nSolidTransparency = mapHatchK.getInt("SolidTransparency");
//				
//				// find if the material is included in this hatch definition
//				for (int l = 0; l < mapMaterials.length(); l++)
//				{
//					Map mapMaterialL = mapMaterials.getMap(l);
//					if (mapMaterialL.hasString("Name") && mapMaterials.keyAt(l).makeLower() == "material")
//					{
//						String sMaterialMap = mapMaterialL.getString("Name");
//						if (sMaterialMap.makeUpper() == sMaterial.makeUpper())
//						{ 
//							// material found
//							bMaterialFound = true;
//							// break "l" loop for materials
//							break;
//						}
//					}
//				}//next l
//				if ( ! bMaterialFound)
//				{ 
//					// material not found at the mapMaterials of this mapHatch, keep looking
//					// continue lop k
//					continue;
//				}
//				// material is found, find the orientation
//				Map mapOrientations = mapHatchK.getMap("Orientation[]");
//				if (mapOrientations.length() < 1)
//				{ 
//					// no orientation map defined for this material 
//					reportMessage(TN("|no map of orientation found for the material of the beam|"));
//					eraseInstance();
//					return;
//				}
//			// find the orientation for this component, initialize with false
//				bOrientationFound = false;
//				// distinguish between isotropic and anisotropic materials
//				if ( ! bAnisotropic)
//				{ 
//					// isotropic material, simply get the first definition
//					for (int l = 0; l < mapOrientations.length(); l++)
//					{ 
//						Map mapOrientationL = mapOrientations.getMap(l);
//						if (mapOrientationL.hasString("Name") && mapOrientations.keyAt(l).makeLower() == "orientation")
//						{ 
//							// the right map found, get the hatch parameters
//							{ 
//								String ss;
//								Map m = mapOrientationL;
//								ss = "Pattern"; if(m.hasString(ss)) sPattern = m.getString(ss);
//								ss = "Color"; if(m.hasInt(ss)) nColor = m.getInt(ss);
//								ss = "Transparency"; if(m.hasInt(ss)) nTransparency = m.getInt(ss);
//								ss = "Angle"; if(m.hasDouble(ss)) dAngle = m.getDouble(ss);
//								ss = "Scale"; if(m.hasDouble(ss)) dScale = m.getDouble(ss);
//								ss = "ScaleMin"; if(m.hasDouble(ss)) dScaleMin = m.getDouble(ss);
//								ss = "Static"; if(m.hasDouble(ss)) bStatic = m.getDouble(ss);
//							}
//							bOrientationFound = true;
//							break;
//						}
//					}//next l
//				}
//				else
//				{ 
//					// anisotropic material, find the right one
//					for (int l = 0; l < mapOrientations.length(); l++)
//					{ 
//						Map mapOrientationL = mapOrientations.getMap(l);
//						if (mapOrientationL.hasString("Name") && mapOrientations.keyAt(l).makeLower() == "orientation")
//						{ 
//							String sOrientationMap = mapOrientationL.getString("Name");
//							if (sOrientationMap.makeUpper() != sOrientation.makeUpper())
//							{ 
//								// not this orientation
//								continue;
//							}
//							// the right map found, get the hatch parameters
//							{ 
//								String ss;
//								Map m = mapOrientationL;
//								ss = "Pattern"; if(m.hasString(ss)) sPattern = m.getString(ss);
//								ss = "Color"; if(m.hasInt(ss)) nColor = m.getInt(ss);
//								ss = "Transparency"; if(m.hasInt(ss)) nTransparency = m.getInt(ss);
//								ss = "Angle"; if(m.hasDouble(ss)) dAngle = m.getDouble(ss);
//								ss = "Scale"; if(m.hasDouble(ss)) dScale = m.getDouble(ss);
//								ss = "ScaleMin"; if(m.hasDouble(ss)) dScaleMin = m.getDouble(ss);
//								ss = "Static"; if(m.hasDouble(ss)) bStatic = m.getDouble(ss);
//							}
//							bOrientationFound = true;
//							break;
//						}
//					}//next l
//				}
//			}
//			if (bMaterialFound)
//			{ 
//				// first hatch that is found with this material will be used
//				// it will not look anymore
//				break;
//			}
//		}//next k
//		
//		// if material is found but orientation not found, skip the hatching
//		if ( bMaterialFound && ! bOrientationFound)
//		{ 
//			// dont do the hatching, go to the next component
//			continue;
//		}
		
		if ( (!bMaterialFound && bMapHatchDefaultFound && nHatchMapping==0) || 
			(!bMaterialFound && bMapHatchDefaultPainterFound && nHatchMapping==1) )
		{ 
			if(nHatchMapping==0)
			{ 
				// by material
				if (nHatchesUsed.find(nHatchDefaultIndex) < 0)nHatchesUsed.append(nHatchDefaultIndex);
				mapHatchFound = mapHatchDefault;
				bMaterialFound = true;
				mapEntityI.setInt("hatch0",nHatchDefaultIndex);
			}
			else if(nHatchMapping==1 && !bPainterGroup)
			{ 
				// by painter
				if (nHatchesUsed.find(nHatchDefaultPainterIndex) < 0)nHatchesUsed.append(nHatchDefaultPainterIndex);
				mapHatchFound = mapHatchDefaultPainter;
				bMaterialFound = true;
				mapEntityI.setInt("hatch0",nHatchDefaultPainterIndex);
			}
			else if(nHatchMapping && bPainterGroup)
			{ 
				for (int k = 0; k < mapHatches.length(); k++)
				{ 
					Map mapHatchK = mapHatches.getMap(k);
					if (mapHatchK.hasString("Name") && mapHatches.keyAt(k).makeLower() == "hatch")
					{
						// HSB-7706
						if ( ! mapHatchK.getInt("isActive"))continue;
						if ( ! mapHatchK.hasString("PainterGroup"))continue;
						// 
						if (!mapHatchK.hasString("Painter"))continue;
						if(mapHatchK.getString("Painter")!=sRule)continue;
						String sPainterGroupMap = mapHatchK.getString("PainterGroup");
						String sFormatI=w.formatObject(sPainterFormat);
						if(sPainterGroupMap.makeUpper()==sFormatI.makeUpper())
						{ 
							mapHatchFound = mapHatchK;
							if (nHatchesUsed.find(k) < 0)nHatchesUsed.append(k);
							bMaterialFound = true;
							mapEntityI.setInt("hatch0",k);
							break;
						}
					}
				}
			}
			int bAnisotropic = mapHatchFound.getInt("Anisotropic");
			if(!bAnisotropic)mapEntityI.setString("orientation0","X");
			// if the material is not found, use the default hatch
			Map mapOrientations = mapHatchDefault.getMap("Orientation[]");
			if (mapOrientations.length() < 1)
			{ 
				// no orientation map defined for this material 
				reportMessage("\n"+scriptName()+" "+T("|no map of orientation found for the material of the beam|"));
				eraseInstance();
				return;
			}
			bOrientationFound = false;
			if ( ! bAnisotropic)
			{
				for (int l = 0; l < mapOrientations.length(); l++)
				{ 
					Map mapOrientationL = mapOrientations.getMap(l);
					if (mapOrientationL.hasString("Name") && mapOrientations.keyAt(l).makeLower() == "orientation")
					{ 
						mapOrientationFound = mapOrientationL;
						bOrientationFound = true;
						break;
					}
				}//next l
			}
			else
			{ 
				// find the orientation for this component
				for (int l = 0; l < mapOrientations.length(); l++)
				{ 
					Map mapOrientationL = mapOrientations.getMap(l);
					if (mapOrientationL.hasString("Name") && mapOrientations.keyAt(l).makeLower() == "orientation")
					{ 
						String sOrientationMap = mapOrientationL.getString("Name");
						if (sOrientationMap.makeUpper() != sOrientation.makeUpper())
						{ 
							// not this orientation
							continue;
						}
						bOrientationFound = true;
						mapOrientationFound = mapOrientationL;
						break;
					}
				}//next l
			}
		}
		
		// if no material found and no default material
		if ( ! bMaterialFound && !bMapHatchDefaultFound)
		{ 
			// go to next entity (panel component)
			continue;
		}
		// default values
		{ 
			nSolidHatch=0;
			nSolidTransparency = 0;
			nSolidColor = 0;
			bHasSolidColor = 0;
			// default orientation hatch parameters
			sPattern = "ANSI31";// hatch pattern
			nColor = 1;// color index
			nTransparency = 0;// transparency
			dAngle = 0;// hatch angle
			dScale = 10.0;// hatch scale
			dScaleMin = 25;// dScaleMin
			bStatic = 0;// by default make dynamic
			// contour parameters
			bContour = 0;
			nColorContour = 0;
			dContourThickness = 0;
		}
		{ 
			String ss;
			Map m = mapHatchFound;
			ss = "SolidHatch"; if(m.hasInt(ss)) nSolidHatch = m.getInt(ss);
			ss = "SolidTransparency"; if(m.hasInt(ss)) nSolidTransparency = m.getInt(ss);
			ss = "SolidColor"; if(m.hasInt(ss)) nSolidColor = m.getInt(ss);
			ss = "SolidColor"; bHasSolidColor= m.hasInt(ss);
		}
		// properties in orientation map
		{ 
			String ss;
			Map m = mapOrientationFound;
			ss = "Pattern"; if(m.hasString(ss)) sPattern = m.getString(ss);
			ss = "Color"; if(m.hasInt(ss)) nColor = m.getInt(ss);
			ss = "Transparency"; if(m.hasInt(ss)) nTransparency = m.getInt(ss);
			ss = "Angle"; if(m.hasDouble(ss)) dAngle = m.getDouble(ss);
			ss = "Scale"; if(m.hasDouble(ss)) dScale = m.getDouble(ss);
			ss = "ScaleMin"; if(m.hasDouble(ss)) dScaleMin = m.getDouble(ss);
			ss = "Static"; if(m.hasInt(ss)) bStatic = m.getInt(ss);
		}
		// properties in contour map
		Map mapContour = mapHatchFound.getMap("Contour");
		{ 
			String ss;
			Map m = mapContour;
			ss = "Contour"; if(m.hasInt(ss)) bContour = m.getInt(ss);
			ss = "Color"; if(m.hasInt(ss)) nColorContour = m.getInt(ss);
			ss = "Thickness"; if(m.hasDouble(ss)) dContourThickness = m.getDouble(ss);
		}
	// adapt dScale and dScaleMin with the scale of viewport or shopdraw
//		dScale *= dScaleVP;//!!!
//		dScaleMin *= dScaleVP;
	// get extents of profile
		if(nPaperPlane)
		{ 
			PlaneProfile ppPaper(pnPaper);
			ppPaper.unionWith(pp);
			pp=PlaneProfile (pnPaper);
			pp.unionWith(ppPaper);
		}
		double dMin = U(10e7);
	// calculate min width rotating 0-180 by 10 degrees
		Vector3d vecXrotI = vecX;
		Vector3d vecYrotI = vecY;
		for (int irot=0;irot<17;irot++) 
		{ 
			LineSeg segI = pp.extentInDir(vecXrotI);
			double dXI=abs(vecXrotI.dotProduct(segI.ptStart()-segI.ptEnd()));
			if(dXI<dMin)dMin=dXI;
			vecXrotI=vecXrotI.rotateBy(U(10),vecZ);
		}//next irot
//		LineSeg seg = pp.extentInDir(vecX);
//		seg.vis(4);
//		double dX = abs(vecX.dotProduct(seg.ptStart() - seg.ptEnd()));
//		double dY = abs(vecY.dotProduct(seg.ptStart() - seg.ptEnd()));
//		double dMin = dX<dY ? dX : dY;
		
	// 
		double dScaleFac = dScale;
		if (dScaleFac < 0.01)dScaleFac = 1;
		double dScale0 = dScaleMin;
		if (bStatic)
		{
			// static, not adapted to the size, get the factor defined in dScale
			dScale0 = dScaleFac;
			if (dScale0 < dScaleMin)
			{ 
				dScale0 = dScaleMin;
			}
		}
		else
		{ 
			// dynamic, adapted to the minimum dimension
			// should not be smaller then dScaleMin
			dScale0=dScaleFac*(dMin/dScaleVP)/U(1000);
			if (dScale0 < dScaleMin)
			{ 
				dScale0 = dScaleMin;
			}
		}
		// multiply dScale0 with the global scaling factor
		dScale0 *= dGlobalScaling;
		// check the color
		// by layer and by block will set the color of the attached layer at the TSL
		if (nColor < 1)
		{ 
			// -2 by entity, -1 by layer, 0 by entity
			if (nColor == -2)
			{ 
				// get color from entity (beam) and use this for the hatch
				nColor = w.color();
			}
			else if (nColor <- 2)
			{ 
				//nColor <- 2; -3,-4,-5 etc then take by entity
				nColor = - 2;
			}
		}
		if (nColorContour < 1)
		{ 
			// -2 by entity, -1 by layer, 0 by entity
			if (nColorContour == -2)
			{ 
				// get color from entity (beam) and use this for the hatch
				nColorContour = w.color();
			}
			else if (nColorContour <- 2)
			{ 
				//nColor <- 2; -3,-4,-5 etc then take by entity
				nColorContour = - 2;
			}
		}
		if (nSolidColor < 1)
		{ 
			// -2 by entity, -1 by layer, 0 by entity
			if (nSolidColor == -2)
			{ 
				// get color from entity (beam) and use this for the hatch
				nSolidColor = w.color();
			}
			else if (nSolidColor <- 2)
			{ 
				//nColor <- 2; -3,-4,-5 etc then take by entity
				nSolidColor = - 2;
			}
		}
		// draw the hatch for the beam
		int nPattern = _HatchPatterns.findNoCase(sPattern, 0);
		sPattern = nPattern >- 1 ? _HatchPatterns[nPattern] : _HatchPatterns[0];
		// hatch object
		Hatch hatch(sPattern, dScale0);
		double dRotationTotal = dAngle + dRotation;
		//HSB-11326:transform to - 90;90
		if(dRotationTotal>=0 && dRotationTotal<=90)
			dRotationTotal = dRotationTotal;
		else if(dRotationTotal>90 && dRotationTotal<=180)
			dRotationTotal = dRotationTotal - 180;
		else if(dRotationTotal>180 && dRotationTotal<=270)
			dRotationTotal = dRotationTotal - 180;
		else if(dRotationTotal>270 && dRotationTotal<=360)
			dRotationTotal = dRotationTotal - 360;
		//
		hatch.setAngle(dRotationTotal);
		dp.color(nColor);
		int _iTransparency=nTransparency;
		int _iSolidTransparency=nSolidTransparency;
		if(dGlobalTransparency<=0)
		{ 
			_iTransparency = 0;
			_iSolidTransparency = 0;
		}
		else if(dGlobalTransparency>0 && dGlobalTransparency<1)
		{ 
			_iTransparency = nTransparency * dGlobalTransparency;
			_iSolidTransparency=nSolidTransparency* dGlobalTransparency;
		}
		else if(dGlobalTransparency>1 && dGlobalTransparency<100)
		{ 
			_iTransparency = nTransparency+dGlobalTransparency*((100.0 - nTransparency) / 99.0);
			_iSolidTransparency = nSolidTransparency+dGlobalTransparency*((100.0 - nSolidTransparency) / 99.0);
		}
		else if(dGlobalTransparency>=100)
		{ 
			_iTransparency = 100;
			_iSolidTransparency = 100;
		}
		dp.transparency(_iTransparency);
		if(bStatic && !bTransparency0)
		{
			dp.draw(pp, hatch);
		}
		else if(bStatic && bTransparency0)
		{ 
			ppsStaticT.append(pp);
			nColorsT.append(nColor);
			nTransparencysT.append(_iTransparency);
			sHatchPatternsT.append(sPattern);
			dAnglesT.append(dRotationTotal);
			dScaleFacsT.append(dScaleFac);
			dScaleMinsT.append(dScaleMin);
		}
		else
		{
			// empty planeprofile
			ppsStaticT.append(PlaneProfile());
			nColorsT.append(10e5);
			nTransparencysT.append(10e5);
			sHatchPatternsT.append(10e5);
			dAnglesT.append(10e5);
			dScaleFacsT.append(10e5);
			dScaleMinsT.append(10e5);
		}
		if(!bStatic && !bTransparency0)
		{ 
			ppsDynamic.append(pp);
			nColorsDynamic.append(nColor);
			nTransparencysDynamic.append(_iTransparency);
			dScaleFacsDynamic.append(dScaleFac);
			dScaleMinsDynamic.append(dScaleMin);
			sHatchPatternsDynamic.append(sPattern);
			dAnglesDynamic.append(dRotationTotal);
			if (dMin>dMinAll)dMinAll=dMin;
			dMinsDynamic.append(dMin);
		}
		else if(!bStatic && bTransparency0)
		{ 
		// 
//		pp.vis(3);
			ppsDynamicT.append(pp);
			nColorsDynamicT.append(nColor);
			nTransparencysDynamicT.append(_iTransparency);
			dScaleFacsDynamicT.append(dScaleFac);
			dScaleMinsDynamicT.append(dScaleMin);
			sHatchPatternsDynamicT.append(sPattern);
			dAnglesDynamicT.append(dRotationTotal);
			if (dMin>dMinAll)dMinAll=dMin;
			dMinsDynamicT.append(dMin);
		}
		else
		{ 
			ppsDynamicT.append(PlaneProfile());
			nColorsDynamicT.append(10e5);
			nTransparencysDynamicT.append(10e5);
			dScaleFacsDynamicT.append(10e5);
			dScaleMinsDynamicT.append(10e5);
			sHatchPatternsDynamicT.append(10e5);
			dAnglesDynamicT.append(10e5);
			if (dMin>dMinAll)dMinAll=dMin;
			dMinsDynamicT.append(10e5);
		}
		if (nSolidHatch && !bTransparency0)
		{ 
			if(bHasSolidColor)
				dp.color(nSolidColor);
			// plot the solid hatch with transparency
			dp.transparency(_iSolidTransparency);
			dp.draw(pp, _kDrawFilled, _iSolidTransparency);
		}
		else if(nSolidHatch && bTransparency0)
		{ 
			bHasSolidColorsT.append(bHasSolidColor);
			// 0 transparency
			nSolidColorsT.append(nSolidColor);
			// plot the solid hatch with transparency
			_nSolidTransparencysT.append(_iSolidTransparency);
		}
		else
		{ 
			bHasSolidColorsT.append(false);
			nSolidColorsT.append(10e4);
			// plot the solid hatch with transparency
			_nSolidTransparencysT.append(10e4);
		}
		// contour
		if (bContour && !bTransparency0)
		{
			dp.transparency(0);
			PLine pls[] = pp.allRings();
			dp.color(nColorContour);
			for (int iPl = 0; iPl < pls.length(); iPl++)
			{
				PlaneProfile ppI(pp.coordSys());
				ppI.joinRing(pls[iPl], _kAdd);
				
				if (dContourThickness > 0)
				{
					ppI.shrink(-.5*dContourThickness);
					PlaneProfile ppContour = ppI;
					ppI.shrink(dContourThickness);
					ppContour.subtractProfile(ppI);
					dp.draw(ppContour, _kDrawFilled);
				}
				else
				{
					dp.draw(ppI);
				}
			}//next iPl
		}
		else if(bContour && bTransparency0)
		{ 
			Map m;
			nColorContoursT.append(nColorContour);
			PLine pls[]=pp.allRings();
			for (int iPl=0;iPl<pls.length();iPl++)
			{
				PlaneProfile ppI(pp.coordSys());
				ppI.joinRing(pls[iPl], _kAdd);
				PlaneProfile ppContour;
				if (dContourThickness>0)
				{
					ppI.shrink(-.5*dContourThickness);
					ppContour=ppI;
					ppI.shrink(dContourThickness);
					ppContour.subtractProfile(ppI);
				}
//				ppContour.transformBy(_ZW*2000);
//				ppContour.vis(6);
//				ppContour.transformBy(-_ZW*2000);
				
				m.appendPlaneProfile("pp",ppContour);
//				m.appendPlaneProfile("pp",ppI);
			}//next iPl
			mapContoursT.appendMap("m",m);
		}
		else
		{ 
			nColorContoursT.append(10e5);
			mapContoursT.appendMap("m",Map());
		}
		mapEntitiesUsed.appendMap("mapEntity",mapEntityI);
		// HSB-10159 save entity to be hatched and the hatch
		{ 
			entsHatch.append(w);
			String sAngle = dRotationTotal; sAngle.format("%.2f", dRotationTotal);
			String sScale0 = dScale0; sScale0.format("%.4f", dScale0);
			String sHatchIdentifier = sMaterial + sPattern + sAngle + sScale0 + nColor + nSolidTransparency;
			if (sHatchIdentifiers.find(sHatchIdentifier) > - 1)
			{
				// hatch already saved
				continue;
			}
			
			sHatchIdentifiers.append(sHatchIdentifier);
			Map mapHatch;
			// material to which it is been used
			mapHatch.setString("sMaterial", sMaterial);
			// pattern
			mapHatch.setString("sPattern", sPattern);
			mapHatch.setDouble("dAngle", dRotationTotal);
			mapHatch.setDouble("dScale", dScale0);
			// solid hatch
			mapHatch.setInt("nColor", nColor);
			mapHatch.setInt("nSolidTransparency", nSolidTransparency);
			mapHatchesUsed.appendMap("mapHatch", mapHatch);
		}
	}//next i
//End hatch walls//endregion
//	return;
//region hatch tsl
	{ 
//		// first set the values to default
//		sPattern = "ANSI31";
//		// color index
//		nColor = 1;
//		// transparency
//		nTransparency = 0;
//		// hatch angle
		dAngle = 0;
//		// hatch scale
//		dScale = 10.0;
//		// dScaleMin
//		dScaleMin = 25;
//		// by default make dynamic
//		bStatic = 0;
	}
	if (!bByPainter || bIsTslPainter)
	for (int i = 0; i < tsls.length(); i++)
	{ 
		TslInst tsl = tsls[i];
		if ( ! tsl.isVisible())continue;
		if (bByPainter && !tsl.acceptObject(painter.filter())){ continue;}
		Group grps[] = tsl.groups();
		int bOff=true;
		for (int igrp=0;igrp<grps.length();igrp++) 
		{ 
			if(grps[igrp].groupVisibility(false)==_kIsOn)
			{ 
				bOff = false;
				break;
			}
		}//next igrp
		if (grps.length() == 0)bOff = false;
		if (bOff)continue;
		String sTslName = tsl.scriptName();
		// body of the TSL, all that is drawn from a Display object
		Body bd = tsl.realBody();
		if (bd.volume() < dEps)
		{ 
			// HSB-22901: try body extent
			Quader qd=tsl.bodyExtents();
			// HSB-22914: Check if the quader has volume before creating the body
			if(qd.dX()<U(1) || qd.dY()<U(1) || qd.dZ()<U(1))
			{ 
				continue;
			}
			
			bd=Body(tsl.bodyExtents());
			if (bd.volume() < dEps)
			{ 
				// body has a small volume
				continue;
			}
		}
		
		if ( ! bHasSection)
		{ 
			// paperspace layout or block space shopdrawing
			bd.transformBy(ms2ps);
		}
		
	// HSB-20184: not very reliable, do intersection for each lump
//		bd.intersectWith(bdClip);
		
		Body bdLumps[]=bd.decomposeIntoLumps();
		Body bdIntersect;
		for (int il=0;il<bdLumps.length();il++) 
		{ 
			Body bdIl=bdLumps[il];
			bdIl.intersectWith(bdClip);
			bdIntersect.addPart(bdIl);
		}//next il
		bd=bdIntersect;
		
		if (bHasSection)
		{
			// transform where the section is
			bd.transformBy(ms2ps);
		}
//		PlaneProfile pp = bd.extractContactFaceInPlane(Plane(_Pt0, vecZ), dEps);
		PlaneProfile pp = bd.shadowProfile(Plane(_Pt0, vecZ));
		if (pp.area() < dEps)
		{ 
			// nothing to hatch, skip this "i" TSL
			continue;
		}
		Vector3d vecXTsl = tsl.coordSys().vecX();
		Vector3d vecYTsl = tsl.coordSys().vecY();
		Vector3d vecZTsl = tsl.coordSys().vecZ();
		vecXTsl.transformBy(ms2ps);
		vecYTsl.transformBy(ms2ps);
		vecZTsl.transformBy(ms2ps);
		String sOrientation = "X";
		if (abs(vecYTsl.dotProduct(_ZW)) > abs(vecXTsl.dotProduct(_ZW))
		  && abs(vecYTsl.dotProduct(_ZW)) > abs(vecZTsl.dotProduct(_ZW)))
		{
			sOrientation = "Y";
		}
		else if (abs(vecZTsl.dotProduct(_ZW)) > abs(vecXTsl.dotProduct(_ZW))
		 && abs(vecZTsl.dotProduct(_ZW)) > abs(vecYTsl.dotProduct(_ZW)))
		{ 
			sOrientation = "Z";
		}
		Vector3d vecDir;
		if (sOrientation == "X")
		{ 
			// vecWoodGrainDirectionJ most aligned with _ZW
//			vecDir = _ZW.crossProduct(vecYTsl);
//			vecDir.normalize();
//			vecDir = _ZW.crossProduct(vecDir);
//			if (vecDir.length() < dEps)
//			{ 
//			// vecDir in the same direction with the _ZW
//				reportMessage(TN("|unexpected error 1010|"));
//				eraseInstance();
//				return;
//			}
//			vecDir.normalize();
			vecDir = vecXTsl;
		}
		else if (sOrientation == "Y" || sOrientation == "Z")
		{ 
			// vecNormalWoodGrainDirectionJ most aligned with _ZW
//			vecDir = _ZW.crossProduct(vecXTsl);
//			vecDir.normalize();
//			vecDir = _ZW.crossProduct(vecDir);
			if(sOrientation=="Y")
				vecDir = vecYTsl;
			else if(sOrientation=="Z")
				vecDir = vecZTsl;
		}
		Map mapEntityI;mapEntityI.setEntity("ent", tsl);
		mapEntityI.setString("orientation0",sOrientation);
		String sMaterial = "*";
		double dRotation;
//		dRotation= _XW.angleTo(vecDir, _ZW);
		// angle between _ZW and vecDir
		Vector3d vecDirZw = vecDir.crossProduct(_ZW);
		vecDirZw.normalize();
		dRotation = vecDir.angleTo(_ZW, vecDirZw);
		
		int bMaterialFound = false;
		int bOrientationFound = false;
		Map mapHatchFound, mapOrientationFound;

		if ( (!bMaterialFound && bMapHatchDefaultFound && nHatchMapping==0) || 
			(!bMaterialFound && bMapHatchDefaultPainterFound && nHatchMapping==1) ||
			(!bMaterialFound && bMapPainterGroupsFoundAll && nHatchMapping && bPainterGroup) )
		{ 
			if(nHatchMapping==0)
			{ 
			// by material
				if (nHatchesUsed.find(nHatchDefaultIndex) < 0)nHatchesUsed.append(nHatchDefaultIndex);
				mapHatchFound = mapHatchDefault;
				bMaterialFound = true;
				mapEntityI.setInt("hatch0",nHatchDefaultIndex);
			}
			else if(nHatchMapping==1 && !bPainterGroup)
			{ 
			// by painter
				if (nHatchesUsed.find(nHatchDefaultPainterIndex) < 0)nHatchesUsed.append(nHatchDefaultPainterIndex);
				mapHatchFound = mapHatchDefaultPainter;
				bMaterialFound = true;
				mapEntityI.setInt("hatch0",nHatchDefaultPainterIndex);
			}
			else if(nHatchMapping && bPainterGroup)
			{ 
				for (int k = 0; k < mapHatches.length(); k++)
				{ 
					Map mapHatchK = mapHatches.getMap(k);
					if (mapHatchK.hasString("Name") && mapHatches.keyAt(k).makeLower() == "hatch")
					{
						// HSB-7706
						if ( ! mapHatchK.getInt("isActive"))continue;
						if ( ! mapHatchK.hasString("PainterGroup"))continue;
						// 
						if (!mapHatchK.hasString("Painter"))continue;
						if(mapHatchK.getString("Painter")!=sRule)continue;
						String sPainterGroupMap = mapHatchK.getString("PainterGroup");
						String sFormatI=tsl.formatObject(sPainterFormat);
						if(sPainterGroupMap.makeUpper()==sFormatI.makeUpper())
						{ 
							mapHatchFound = mapHatchK;
							if (nHatchesUsed.find(k) < 0)nHatchesUsed.append(k);
							bMaterialFound = true;
							mapEntityI.setInt("hatch0",k);
							break;
						}
					}
				}
			}
			int bAnisotropic = mapHatchFound.getInt("Anisotropic");
			if(!bAnisotropic)mapEntityI.setString("orientation0","X");
			// if the material is not found, use the default hatch
//			Map mapOrientations = mapHatchDefault.getMap("Orientation[]");
			Map mapOrientations = mapHatchFound.getMap("Orientation[]");
			if (mapOrientations.length() < 1)
			{ 
				// no orientation map defined for this material 
				reportMessage("\n"+scriptName()+" "+T("|no map of orientation found for the material of the beam|"));
				eraseInstance();
				return;
			}
			bOrientationFound = false;
			if (!bAnisotropic)
			{
				for (int l=0; l<mapOrientations.length(); l++)
				{ 
					Map mapOrientationL = mapOrientations.getMap(l);
					if (mapOrientationL.hasString("Name") && mapOrientations.keyAt(l).makeLower() == "orientation")
					{ 
						mapOrientationFound = mapOrientationL;
						bOrientationFound = true;
						break;
					}
				}//next l
			}
			else
			{ 
				// find the orientation for this component
				for (int l = 0; l < mapOrientations.length(); l++)
				{ 
					Map mapOrientationL = mapOrientations.getMap(l);
					if (mapOrientationL.hasString("Name") && mapOrientations.keyAt(l).makeLower() == "orientation")
					{ 
						String sOrientationMap = mapOrientationL.getString("Name");
						if (sOrientationMap.makeUpper() != sOrientation.makeUpper())
						{ 
							// not this orientation
							continue;
						}
						bOrientationFound = true;
						mapOrientationFound = mapOrientationL;
						break;
					}
				}//next l
			}
		}
		
		// if no material found and no default material
		if ( ! bMaterialFound && !bMapHatchDefaultFound)
		{ 
			// go to next entity (panel component)
			continue;
		}
		// default values
		{ 
			nSolidHatch=0;
			nSolidTransparency = 0;
			nSolidColor = 0;
			bHasSolidColor = 0;
			// default orientation hatch parameters
			sPattern = "ANSI31";// hatch pattern
			nColor = 1;// color index
			nTransparency = 0;// transparency
			dAngle = 0;// hatch angle
			dScale = 10.0;// hatch scale
			dScaleMin = 25;// dScaleMin
			bStatic = 0;// by default make dynamic
			// contour parameters
			bContour = 0;
			nColorContour = 0;
			dContourThickness = 0;
		}
		{ 
			String ss;
			Map m = mapHatchFound;
			ss = "SolidHatch"; if(m.hasInt(ss)) nSolidHatch = m.getInt(ss);
			ss = "SolidTransparency"; if(m.hasInt(ss)) nSolidTransparency = m.getInt(ss);
			ss = "SolidColor"; if(m.hasInt(ss)) nSolidColor = m.getInt(ss);
			ss = "SolidColor"; bHasSolidColor= m.hasInt(ss);
		}
		// properties in orientation map
		{ 
			String ss;
			Map m = mapOrientationFound;
			ss = "Pattern"; if(m.hasString(ss)) sPattern = m.getString(ss);
			ss = "Color"; if(m.hasInt(ss)) nColor = m.getInt(ss);
			ss = "Transparency"; if(m.hasInt(ss)) nTransparency = m.getInt(ss);
			ss = "Angle"; if(m.hasDouble(ss)) dAngle = m.getDouble(ss);
			ss = "Scale"; if(m.hasDouble(ss)) dScale = m.getDouble(ss);
			ss = "ScaleMin"; if(m.hasDouble(ss)) dScaleMin = m.getDouble(ss);
			ss = "Static"; if(m.hasInt(ss)) bStatic = m.getInt(ss);
		}
		// properties in contour map
		Map mapContour = mapHatchFound.getMap("Contour");
		{ 
			String ss;
			Map m = mapContour;
			ss = "Contour"; if(m.hasInt(ss)) bContour = m.getInt(ss);
			ss = "Color"; if(m.hasInt(ss)) nColorContour = m.getInt(ss);
			ss = "Thickness"; if(m.hasDouble(ss)) dContourThickness = m.getDouble(ss);
		}
		if(nPaperPlane)
		{ 
			PlaneProfile ppPaper(pnPaper);
			ppPaper.unionWith(pp);
			pp=PlaneProfile (pnPaper);
			pp.unionWith(ppPaper);
		}
		double dMin = U(10e7);
	// calculate min width rotating 0-180 by 10 degrees
		Vector3d vecXrotI = vecX;
		Vector3d vecYrotI = vecY;
		for (int irot=0;irot<17;irot++) 
		{ 
			LineSeg segI = pp.extentInDir(vecXrotI);
			double dXI=abs(vecXrotI.dotProduct(segI.ptStart()-segI.ptEnd()));
			if(dXI<dMin)dMin=dXI;
			vecXrotI=vecXrotI.rotateBy(U(10),vecZ);
		}//next irot
//		LineSeg seg = pp.extentInDir(vecX);
//		seg.vis(4);
//		double dX = abs(vecX.dotProduct(seg.ptStart() - seg.ptEnd()));
//		double dY = abs(vecY.dotProduct(seg.ptStart() - seg.ptEnd()));
//		double dMin = dX<dY ? dX : dY;
		double dScaleFac = dScale;
		if (dScaleFac < 0.01)dScaleFac = 1;
		double dScale0 = dScaleMin;
		if (bStatic)
		{
			// static, not adapted to the size, get the factor defined in dScale
			dScale0 = dScaleFac;
			if (dScale0 < dScaleMin)
			{ 
				dScale0 = dScaleMin;
			}
		}
		else
		{ 
			// dynamic, adapted to the minimum dimension
			// should not be smaller then dScaleMin
			dScale0=dScaleFac*(dMin/dScaleVP)/U(1000);
			if (dScale0 < dScaleMin)
			{ 
				dScale0 = dScaleMin;
			}
		}
		// multiply dScale0 with the global scaling factor
		dScale0 *= dGlobalScaling;
		if (nColor < 1)
		{ 
			// -2 by entity, -1 by layer, 0 by entity
			if (nColor == -2)
			{ 
				// get color from entity (beam) and use this for the hatch
				nColor = tsl.color();
			}
			else if (nColor <- 2)
			{ 
				//nColor <- 2; -3,-4,-5 etc then take by entity
				nColor = - 2;
			}
		}
		if (nColorContour < 1)
		{ 
			// -2 by entity, -1 by layer, 0 by entity
			if (nColorContour == -2)
			{ 
				// get color from entity (beam) and use this for the hatch
				nColorContour = tsl.color();
			}
			else if (nColorContour <- 2)
			{ 
				//nColor <- 2; -3,-4,-5 etc then take by entity
				nColorContour = - 2;
			}
		}
		if (nSolidColor < 1)
		{ 
			// -2 by entity, -1 by layer, 0 by entity
			if (nSolidColor == -2)
			{ 
				// get color from entity (beam) and use this for the hatch
				nSolidColor = tsl.color();
			}
			else if (nSolidColor <- 2)
			{ 
				//nColor <- 2; -3,-4,-5 etc then take by entity
				nSolidColor = - 2;
			}
		}
		// draw the hatch for the beam
		int nPattern = _HatchPatterns.findNoCase(sPattern, 0);
		sPattern = nPattern >- 1 ? _HatchPatterns[nPattern] : _HatchPatterns[0];
		// hatch object
		Hatch hatch(sPattern, dScale0);
		double dRotationTotal = dAngle + dRotation;
		//HSB-11326: transform to - 90;90
		if(dRotationTotal>=0 && dRotationTotal<=90)
			dRotationTotal = dRotationTotal;
		else if(dRotationTotal>90 && dRotationTotal<=180)
			dRotationTotal = dRotationTotal - 180;
		else if(dRotationTotal>180 && dRotationTotal<=270)
			dRotationTotal = dRotationTotal - 180;
		else if(dRotationTotal>270 && dRotationTotal<=360)
			dRotationTotal = dRotationTotal - 360;
			
		hatch.setAngle(dRotationTotal);
		dp.color(nColor);
		int _iTransparency=nTransparency;
		int _iSolidTransparency=nSolidTransparency;
		if(dGlobalTransparency<=0)
		{ 
			_iTransparency = 0;
			_iSolidTransparency = 0;
		}
		else if(dGlobalTransparency>0 && dGlobalTransparency<1)
		{ 
			_iTransparency = nTransparency * dGlobalTransparency;
			_iSolidTransparency=nSolidTransparency* dGlobalTransparency;
		}
		else if(dGlobalTransparency>1 && dGlobalTransparency<100)
		{ 
			_iTransparency = nTransparency+dGlobalTransparency*((100.0 - nTransparency) / 99.0);
			_iSolidTransparency = nSolidTransparency+dGlobalTransparency*((100.0 - nSolidTransparency) / 99.0);
		}
		else if(dGlobalTransparency>=100)
		{ 
			_iTransparency = 100;
			_iSolidTransparency = 100;
		}
		dp.transparency(_iTransparency);
//		if(bStatic)
		if(bStatic && !bTransparency0)
		{
			dp.draw(pp, hatch);
		}
		else if(bStatic && bTransparency0)
		{ 
			ppsStaticT.append(pp);
			nColorsT.append(nColor);
			nTransparencysT.append(_iTransparency);
			sHatchPatternsT.append(sPattern);
			dAnglesT.append(dRotationTotal);
			dScaleFacsT.append(dScaleFac);
			dScaleMinsT.append(dScaleMin);
		}
		else
		{
			// empty planeprofile
			ppsStaticT.append(PlaneProfile());
			nColorsT.append(10e5);
			nTransparencysT.append(10e5);
			sHatchPatternsT.append(10e5);
			dAnglesT.append(10e5);
			dScaleFacsT.append(10e5);
			dScaleMinsT.append(10e5);
		}
	// 
		if(!bStatic && !bTransparency0)
		{ 
			ppsDynamic.append(pp);
			nColorsDynamic.append(nColor);
			nTransparencysDynamic.append(_iTransparency);
			dScaleFacsDynamic.append(dScaleFac);
			dScaleMinsDynamic.append(dScaleMin);
			sHatchPatternsDynamic.append(sPattern);
			dAnglesDynamic.append(dRotationTotal);
			if (dMin>dMinAll)dMinAll=dMin;
			dMinsDynamic.append(dMin);
		}
		else if(!bStatic && bTransparency0)
		{ 
		// 
//		pp.vis(3);
			ppsDynamicT.append(pp);
			nColorsDynamicT.append(nColor);
			nTransparencysDynamicT.append(_iTransparency);
			dScaleFacsDynamicT.append(dScaleFac);
			dScaleMinsDynamicT.append(dScaleMin);
			sHatchPatternsDynamicT.append(sPattern);
			dAnglesDynamicT.append(dRotationTotal);
			if (dMin>dMinAll)dMinAll=dMin;
			dMinsDynamicT.append(dMin);
		}
		else
		{ 
			ppsDynamicT.append(PlaneProfile());
			nColorsDynamicT.append(10e5);
			nTransparencysDynamicT.append(10e5);
			dScaleFacsDynamicT.append(10e5);
			dScaleMinsDynamicT.append(10e5);
			sHatchPatternsDynamicT.append(10e5);
			dAnglesDynamicT.append(10e5);
			if (dMin>dMinAll)dMinAll=dMin;
			dMinsDynamicT.append(10e5);
		}
		// save for each body the center point
		if(bTransparency0)
		{ 
			bdsT.append(bd);
			Point3d ptCenI=bd.ptCen();
			ptCenI.vis(6+i);
			bd.vis(6+i);
			ptCensT.append(bd.ptCen());
		}
		// 
		if (nSolidHatch && !bTransparency0)
		{ 
			if(bHasSolidColor)
				dp.color(nSolidColor);
			// plot the solid hatch with transparency
			dp.transparency(_iSolidTransparency);
			dp.draw(pp,_kDrawFilled,_iSolidTransparency);
		}
		else if(nSolidHatch && bTransparency0)
		{ 
			bHasSolidColorsT.append(bHasSolidColor);
			// 0 transparency
			nSolidColorsT.append(nSolidColor);
			// plot the solid hatch with transparency
			_nSolidTransparencysT.append(_iSolidTransparency);
		}
		else
		{ 
			bHasSolidColorsT.append(false);
			nSolidColorsT.append(10e4);
			// plot the solid hatch with transparency
			_nSolidTransparencysT.append(10e4);
		}
		//
		// contour
		if (bContour && !bTransparency0)
		{
			dp.transparency(0);
			PLine pls[]=pp.allRings();
			dp.color(nColorContour);
			for (int iPl=0;iPl<pls.length();iPl++)
			{
				PlaneProfile ppI(pp.coordSys());
				ppI.joinRing(pls[iPl], _kAdd);
				
				if (dContourThickness>0)
				{
					ppI.shrink(-.5*dContourThickness);
					PlaneProfile ppContour=ppI;
					ppI.shrink(dContourThickness);
					ppContour.subtractProfile(ppI);
					dp.draw(ppContour, _kDrawFilled);
				}
				else
				{
					dp.draw(ppI);
				}
			}//next iPl
		}
		else if(bContour && bTransparency0)
		{ 
			Map m;
			nColorContoursT.append(nColorContour);
			PLine pls[]=pp.allRings();
			for (int iPl=0;iPl<pls.length();iPl++)
			{
				PlaneProfile ppI(pp.coordSys());
				ppI.joinRing(pls[iPl], _kAdd);
				PlaneProfile ppContour;
				if (dContourThickness>0)
				{
					ppI.shrink(-.5*dContourThickness);
					ppContour=ppI;
					ppI.shrink(dContourThickness);
					ppContour.subtractProfile(ppI);
				}
//				ppContour.transformBy(_ZW*2000);
//				ppContour.vis(6);
//				ppContour.transformBy(-_ZW*2000);
				
				m.appendPlaneProfile("pp",ppContour);
//				m.appendPlaneProfile("pp",ppI);
			}//next iPl
			mapContoursT.appendMap("m",m);
		}
		else
		{ 
			nColorContoursT.append(10e5);
			mapContoursT.appendMap("m",Map());
		}
//		if (bContour)
//		{
//			dp.transparency(0);
//			PLine pls[] = pp.allRings();
//			dp.color(nColorContour);
//			for (int iPl = 0; iPl < pls.length(); iPl++)
//			{
//				PlaneProfile ppI(pp.coordSys());
//				ppI.joinRing(pls[iPl], _kAdd);
//				
//				if (dContourThickness > 0)
//				{
//					ppI.shrink(-.5 * dContourThickness);
//					PlaneProfile ppContour = ppI;
//					ppI.shrink(dContourThickness);
//					ppContour.subtractProfile(ppI);
//					dp.draw(ppContour, _kDrawFilled);
//				}
//				else
//				{
//					dp.draw(ppI);
//				}
//			}//next iPl
//		}
		mapEntitiesUsed.appendMap("mapEntity",mapEntityI);
		// HSB-10159 save entity to be hatched and the hatch
		{ 
			entsHatch.append(tsl);
			String sAngle = dRotationTotal; sAngle.format("%.2f", dRotationTotal);
			String sScale0 = dScale0; sScale0.format("%.4f", dScale0);
			String sHatchIdentifier = sMaterial + sPattern + sAngle + sScale0 + nColor + nSolidTransparency;
			if (sHatchIdentifiers.find(sHatchIdentifier) > - 1)
			{
				// hatch already saved
				continue;
			}
			
			sHatchIdentifiers.append(sHatchIdentifier);
			Map mapHatch;
			// material to which it is been used
//			mapHatch.setString("sMaterial", sMaterial);
			mapHatch.setString("sMaterial", sMaterial);
			// pattern
			mapHatch.setString("sPattern", sPattern);
			mapHatch.setDouble("dAngle", dRotationTotal);
			mapHatch.setDouble("dScale", dScale0);
			// solid hatch
			mapHatch.setInt("nColor", nColor);
			mapHatch.setInt("nSolidTransparency", nSolidTransparency);
			mapHatchesUsed.appendMap("mapHatch", mapHatch);
		}
	}//next i
//End hatch tsl//endregion 

//region hatch masselement
	{ 
//		// first set the values to default
//		sPattern = "ANSI31";
//		// color index
//		nColor = 1;
//		// transparency
//		nTransparency = 0;
//		// hatch angle
		dAngle = 0;
//		// hatch scale
//		dScale = 10.0;
//		// dScaleMin
//		dScaleMin = 25;
//		// by default make dynamic
//		bStatic = 0;
	}
	if (!bByPainter || bIsMassElementPainter)
	for (int i = 0; i < massElements.length(); i++)
	{ 
		MassElement massElement = massElements[i];
		if ( ! massElement.isVisible())continue;
		if (bByPainter && !massElement.acceptObject(painter.filter())){ continue;}
		Group grps[] = massElement.groups();
		int bOff=true;
		for (int igrp=0;igrp<grps.length();igrp++) 
		{ 
			if(grps[igrp].groupVisibility(false)==_kIsOn)
			{ 
				bOff = false;
				break;
			}
		}//next igrp
		if (grps.length() == 0)bOff = false;
		if (bOff)continue;
//		String sTslName = tsl.scriptName();
		// body of the TSL, all that is drawn from a Display object
		Body bd = massElement.realBody();
		if (bd.volume() < dEps)
		{ 
			// body has a small volume
			continue;
		}
		
		if ( ! bHasSection)
		{ 
			// paperspace layout or block space shopdrawing
			bd.transformBy(ms2ps);
		}
		
		bd.vis(7);
		bd.intersectWith(bdClip);
		bd.vis(9);
		if (bHasSection)
		{
			// transform where the section is
			bd.transformBy(ms2ps);
		}
//		PlaneProfile pp = bd.extractContactFaceInPlane(Plane(_Pt0, vecZ), dEps);
		PlaneProfile pp = bd.shadowProfile(Plane(_Pt0, vecZ));
		if (pp.area() < dEps)
		{ 
			// nothing to hatch, skip this "i" massElement
			continue;
		}
		CoordSys csMassElement = massElement.coordSys();
		Vector3d vecXMassElement = csMassElement.vecX();
		Vector3d vecYMassElement = csMassElement.vecY();
		Vector3d vecZMassElement = csMassElement.vecZ();
		vecXMassElement.transformBy(ms2ps);
		vecYMassElement.transformBy(ms2ps);
		vecZMassElement.transformBy(ms2ps);
		String sOrientation = "X";
		if (abs(vecYMassElement.dotProduct(_ZW)) > abs(vecXMassElement.dotProduct(_ZW))
		  && abs(vecYMassElement.dotProduct(_ZW)) > abs(vecZMassElement.dotProduct(_ZW)))
		{
			sOrientation = "Y";
		}
		else if (abs(vecZMassElement.dotProduct(_ZW)) > abs(vecXMassElement.dotProduct(_ZW))
		 && abs(vecZMassElement.dotProduct(_ZW)) > abs(vecYMassElement.dotProduct(_ZW)))
		{ 
			sOrientation = "Z";
		}
		Vector3d vecDir;
		if (sOrientation == "X")
		{ 
			// vecWoodGrainDirectionJ most aligned with _ZW
//			vecDir = _ZW.crossProduct(vecYMassElement);
//			vecDir.normalize();
//			vecDir = _ZW.crossProduct(vecDir);
//			if (vecDir.length() < dEps)
//			{ 
//			// vecDir in the same direction with the _ZW
//				reportMessage(TN("|unexpected error 1010|"));
//				eraseInstance();
//				return;
//			}
//			vecDir.normalize();
			vecDir = vecXMassElement;
		}
		else if (sOrientation == "Y" || sOrientation == "Z")
		{ 
			// vecNormalWoodGrainDirectionJ most aligned with _ZW
//			vecDir = _ZW.crossProduct(vecXMassElement);
//			vecDir.normalize();
//			vecDir = _ZW.crossProduct(vecDir);
			if(sOrientation=="Y")
				vecDir = vecYMassElement;
			else if(sOrientation=="Z")
				vecDir = vecZMassElement;
		}
		Map mapEntityI;mapEntityI.setEntity("ent", massElement);
		mapEntityI.setString("orientation0",sOrientation);
		String sMaterial = "*";
		double dRotation;
//		dRotation= _XW.angleTo(vecDir, _ZW);
		// angle between _ZW and vecDir
		Vector3d vecDirZw = vecDir.crossProduct(_ZW);
		vecDirZw.normalize();
		dRotation = vecDir.angleTo(_ZW, vecDirZw);
		
		int bMaterialFound = false;
		int bOrientationFound = false;
		Map mapHatchFound, mapOrientationFound;

		if ( (!bMaterialFound && bMapHatchDefaultFound && nHatchMapping==0) || 
			(!bMaterialFound && bMapHatchDefaultPainterFound && nHatchMapping==1) ||
			(!bMaterialFound && bMapPainterGroupsFoundAll && nHatchMapping && bPainterGroup))
		{ 
			if(nHatchMapping==0)
			{ 
				if (nHatchesUsed.find(nHatchDefaultIndex) < 0)nHatchesUsed.append(nHatchDefaultIndex);
				mapHatchFound = mapHatchDefault;
				bMaterialFound = true;
				mapEntityI.setInt("hatch0",nHatchDefaultIndex);
			}
			else if(nHatchMapping==1 && !bPainterGroup)
			{ 
				if (nHatchesUsed.find(nHatchDefaultPainterIndex) < 0)nHatchesUsed.append(nHatchDefaultPainterIndex);
				mapHatchFound = mapHatchDefaultPainter;
				bMaterialFound = true;
				mapEntityI.setInt("hatch0",nHatchDefaultPainterIndex);
			}
			else if(nHatchMapping && bPainterGroup)
			{ 
				for (int k = 0; k < mapHatches.length(); k++)
				{ 
					Map mapHatchK = mapHatches.getMap(k);
					if (mapHatchK.hasString("Name") && mapHatches.keyAt(k).makeLower() == "hatch")
					{
						// HSB-7706
						if ( ! mapHatchK.getInt("isActive"))continue;
						if ( ! mapHatchK.hasString("PainterGroup"))continue;
						//
						if (!mapHatchK.hasString("Painter"))continue;
						if(mapHatchK.getString("Painter")!=sRule)continue;
						String sPainterGroupMap = mapHatchK.getString("PainterGroup");
						String sFormatI=massElement.formatObject(sPainterFormat);
						if(sPainterGroupMap.makeUpper()==sFormatI.makeUpper())
						{ 
							mapHatchFound = mapHatchK;
							if (nHatchesUsed.find(k) < 0)nHatchesUsed.append(k);
							bMaterialFound = true;
							mapEntityI.setInt("hatch0",k);
							break;
						}
					}
				}
			}
			int bAnisotropic = mapHatchFound.getInt("Anisotropic");
			if(!bAnisotropic)mapEntityI.setString("orientation0","X");
			// if the material is not found, use the default hatch
			Map mapOrientations = mapHatchDefault.getMap("Orientation[]");
			if (mapOrientations.length() < 1)
			{ 
				// no orientation map defined for this material 
				reportMessage("\n"+scriptName()+" "+T("|no map of orientation found for the material of the beam|"));
				eraseInstance();
				return;
			}
			bOrientationFound = false;
			if ( ! bAnisotropic)
			{
				for (int l = 0; l < mapOrientations.length(); l++)
				{ 
					Map mapOrientationL = mapOrientations.getMap(l);
					if (mapOrientationL.hasString("Name") && mapOrientations.keyAt(l).makeLower() == "orientation")
					{ 
						mapOrientationFound = mapOrientationL;
						bOrientationFound = true;
						break;
					}
				}//next l
			}
			else
			{ 
				// find the orientation for this component
				for (int l = 0; l < mapOrientations.length(); l++)
				{ 
					Map mapOrientationL = mapOrientations.getMap(l);
					if (mapOrientationL.hasString("Name") && mapOrientations.keyAt(l).makeLower() == "orientation")
					{ 
						String sOrientationMap = mapOrientationL.getString("Name");
						if (sOrientationMap.makeUpper() != sOrientation.makeUpper())
						{ 
							// not this orientation
							continue;
						}
						bOrientationFound = true;
						mapOrientationFound = mapOrientationL;
						break;
					}
				}//next l
			}
		}
		
		// if no material found and no default material
		if ( ! bMaterialFound && !bMapHatchDefaultFound)
		{ 
			// go to next entity (panel component)
			continue;
		}
		// default values
		{ 
			nSolidHatch=0;
			nSolidTransparency = 0;
			nSolidColor = 0;
			bHasSolidColor = 0;
			// default orientation hatch parameters
			sPattern = "ANSI31";// hatch pattern
			nColor = 1;// color index
			nTransparency = 0;// transparency
			dAngle = 0;// hatch angle
			dScale = 10.0;// hatch scale
			dScaleMin = 25;// dScaleMin
			bStatic = 0;// by default make dynamic
			// contour parameters
			bContour = 0;
			nColorContour = 0;
			dContourThickness = 0;
		}
		{ 
			String ss;
			Map m = mapHatchFound;
			ss = "SolidHatch"; if(m.hasInt(ss)) nSolidHatch = m.getInt(ss);
			ss = "SolidTransparency"; if(m.hasInt(ss)) nSolidTransparency = m.getInt(ss);
			ss = "SolidColor"; if(m.hasInt(ss)) nSolidColor = m.getInt(ss);
			ss = "SolidColor"; bHasSolidColor= m.hasInt(ss);
		}
		// properties in orientation map
		{ 
			String ss;
			Map m = mapOrientationFound;
			ss = "Pattern"; if(m.hasString(ss)) sPattern = m.getString(ss);
			ss = "Color"; if(m.hasInt(ss)) nColor = m.getInt(ss);
			ss = "Transparency"; if(m.hasInt(ss)) nTransparency = m.getInt(ss);
			ss = "Angle"; if(m.hasDouble(ss)) dAngle = m.getDouble(ss);
			ss = "Scale"; if(m.hasDouble(ss)) dScale = m.getDouble(ss);
			ss = "ScaleMin"; if(m.hasDouble(ss)) dScaleMin = m.getDouble(ss);
			ss = "Static"; if(m.hasInt(ss)) bStatic = m.getInt(ss);
		}
		// properties in contour map
		Map mapContour = mapHatchFound.getMap("Contour");
		{ 
			String ss;
			Map m = mapContour;
			ss = "Contour"; if(m.hasInt(ss)) bContour = m.getInt(ss);
			ss = "Color"; if(m.hasInt(ss)) nColorContour = m.getInt(ss);
			ss = "Thickness"; if(m.hasDouble(ss)) dContourThickness = m.getDouble(ss);
		}
		
		if(nPaperPlane)
		{ 
			PlaneProfile ppPaper(pnPaper);
			ppPaper.unionWith(pp);
			pp=PlaneProfile (pnPaper);
			pp.unionWith(ppPaper);
		}
		double dMin = U(10e7);
	// calculate min width rotating 0-180 by 10 degrees
		Vector3d vecXrotI = vecX;
		Vector3d vecYrotI = vecY;
		for (int irot=0;irot<17;irot++) 
		{ 
			LineSeg segI = pp.extentInDir(vecXrotI);
			double dXI=abs(vecXrotI.dotProduct(segI.ptStart()-segI.ptEnd()));
			if(dXI<dMin)dMin=dXI;
			vecXrotI=vecXrotI.rotateBy(U(10),vecZ);
		}//next irot
//		LineSeg seg = pp.extentInDir(vecX);
//		seg.vis(4);
//		double dX = abs(vecX.dotProduct(seg.ptStart() - seg.ptEnd()));
//		double dY = abs(vecY.dotProduct(seg.ptStart() - seg.ptEnd()));
//		double dMin = dX<dY ? dX : dY;
		double dScaleFac = dScale;
		if (dScaleFac < 0.01)dScaleFac = 1;
		double dScale0 = dScaleMin;
		if (bStatic)
		{
			// static, not adapted to the size, get the factor defined in dScale
			dScale0=dScaleFac;
			if (dScale0<dScaleMin)
			{ 
				dScale0=dScaleMin;
			}
		}
		else
		{ 
			// dynamic, adapted to the minimum dimension
			// should not be smaller then dScaleMin
			dScale0=dScaleFac*(dMin/dScaleVP)/U(1000);
			if (dScale0<dScaleMin)
			{ 
				dScale0=dScaleMin;
			}
		}
		// multiply dScale0 with the global scaling factor
		dScale0 *= dGlobalScaling;
		if (nColor < 1)
		{ 
			// -2 by entity, -1 by layer, 0 by entity
			if (nColor == -2)
			{ 
				// get color from entity (beam) and use this for the hatch
				nColor = massElement.color();
			}
			else if (nColor <- 2)
			{ 
				//nColor <- 2; -3,-4,-5 etc then take by entity
				nColor = - 2;
			}
		}
		if (nColorContour < 1)
		{ 
			// -2 by entity, -1 by layer, 0 by entity
			if (nColorContour == -2)
			{ 
				// get color from entity (beam) and use this for the hatch
				nColorContour = massElement.color();
			}
			else if (nColorContour <- 2)
			{ 
				//nColor <- 2; -3,-4,-5 etc then take by entity
				nColorContour = - 2;
			}
		}
		if (nSolidColor < 1)
		{ 
			// -2 by entity, -1 by layer, 0 by entity
			if (nSolidColor == -2)
			{ 
				// get color from entity (beam) and use this for the hatch
				nSolidColor = massElement.color();
			}
			else if (nSolidColor <- 2)
			{ 
				//nColor <- 2; -3,-4,-5 etc then take by entity
				nSolidColor = - 2;
			}
		}
		// draw the hatch for the beam
		int nPattern = _HatchPatterns.findNoCase(sPattern, 0);
		sPattern = nPattern >- 1 ? _HatchPatterns[nPattern] : _HatchPatterns[0];
		// hatch object
		Hatch hatch(sPattern, dScale0);
		double dRotationTotal = dAngle + dRotation;
		//HSB-11326: transform to - 90;90
		if(dRotationTotal>=0 && dRotationTotal<=90)
			dRotationTotal = dRotationTotal;
		else if(dRotationTotal>90 && dRotationTotal<=180)
			dRotationTotal = dRotationTotal - 180;
		else if(dRotationTotal>180 && dRotationTotal<=270)
			dRotationTotal = dRotationTotal - 180;
		else if(dRotationTotal>270 && dRotationTotal<=360)
			dRotationTotal = dRotationTotal - 360;
			
		hatch.setAngle(dRotationTotal);
		dp.color(nColor);
		int _iTransparency=nTransparency;
		int _iSolidTransparency=nSolidTransparency;
		if(dGlobalTransparency<=0)
		{ 
			_iTransparency = 0;
			_iSolidTransparency = 0;
		}
		else if(dGlobalTransparency>0 && dGlobalTransparency<1)
		{ 
			_iTransparency = nTransparency * dGlobalTransparency;
			_iSolidTransparency=nSolidTransparency* dGlobalTransparency;
		}
		else if(dGlobalTransparency>1 && dGlobalTransparency<100)
		{ 
			_iTransparency = nTransparency+dGlobalTransparency*((100.0 - nTransparency) / 99.0);
			_iSolidTransparency = nSolidTransparency+dGlobalTransparency*((100.0 - nSolidTransparency) / 99.0);
		}
		else if(dGlobalTransparency>=100)
		{ 
			_iTransparency = 100;
			_iSolidTransparency = 100;
		}
		dp.transparency(_iTransparency);
		if(bStatic && !bTransparency0)
		{
			dp.draw(pp, hatch);
		}
		else if(bStatic && bTransparency0)
		{ 
			ppsStaticT.append(pp);
			nColorsT.append(nColor);
			nTransparencysT.append(_iTransparency);
			sHatchPatternsT.append(sPattern);
			dAnglesT.append(dRotationTotal);
			dScaleFacsT.append(dScaleFac);
			dScaleMinsT.append(dScaleMin);
		}
		else
		{
			// empty planeprofile
			ppsStaticT.append(PlaneProfile());
			nColorsT.append(10e5);
			nTransparencysT.append(10e5);
			sHatchPatternsT.append(10e5);
			dAnglesT.append(10e5);
			dScaleFacsT.append(10e5);
			dScaleMinsT.append(10e5);
		}
		if(!bStatic && !bTransparency0)
		{ 
			ppsDynamic.append(pp);
			nColorsDynamic.append(nColor);
			nTransparencysDynamic.append(_iTransparency);
			dScaleFacsDynamic.append(dScaleFac);
			dScaleMinsDynamic.append(dScaleMin);
			sHatchPatternsDynamic.append(sPattern);
			dAnglesDynamic.append(dRotationTotal);
			if (dMin>dMinAll)dMinAll=dMin;
			dMinsDynamic.append(dMin);
		}
		else if(!bStatic && bTransparency0)
		{ 
		// 
//		pp.vis(3);
			ppsDynamicT.append(pp);
			nColorsDynamicT.append(nColor);
			nTransparencysDynamicT.append(_iTransparency);
			dScaleFacsDynamicT.append(dScaleFac);
			dScaleMinsDynamicT.append(dScaleMin);
			sHatchPatternsDynamicT.append(sPattern);
			dAnglesDynamicT.append(dRotationTotal);
			if (dMin>dMinAll)dMinAll=dMin;
			dMinsDynamicT.append(dMin);
		}
		else
		{ 
			ppsDynamicT.append(PlaneProfile());
			nColorsDynamicT.append(10e5);
			nTransparencysDynamicT.append(10e5);
			dScaleFacsDynamicT.append(10e5);
			dScaleMinsDynamicT.append(10e5);
			sHatchPatternsDynamicT.append(10e5);
			dAnglesDynamicT.append(10e5);
			if (dMin>dMinAll)dMinAll=dMin;
			dMinsDynamicT.append(10e5);
		}
		if(bTransparency0)
		{ 
			bdsT.append(bd);
			Point3d ptCenI=bd.ptCen();
			ptCenI.vis(6+i);
			bd.vis(6+i);
			ptCensT.append(bd.ptCen());
		}
		if (nSolidHatch && !bTransparency0)
		{ 
			if(bHasSolidColor)
				dp.color(nSolidColor);
			// plot the solid hatch with transparency
			dp.transparency(_iSolidTransparency);
			dp.draw(pp, _kDrawFilled, _iSolidTransparency);
		}
		else if(nSolidHatch && bTransparency0)
		{ 
			bHasSolidColorsT.append(bHasSolidColor);
			// 0 transparency
			nSolidColorsT.append(nSolidColor);
			// plot the solid hatch with transparency
			_nSolidTransparencysT.append(_iSolidTransparency);
		}
		else
		{ 
			bHasSolidColorsT.append(false);
			nSolidColorsT.append(10e4);
			// plot the solid hatch with transparency
			_nSolidTransparencysT.append(10e4);
		}
		// contour
		if (bContour && !bTransparency0)
		{
			dp.transparency(0);
			PLine pls[] = pp.allRings();
			dp.color(nColorContour);
			for (int iPl = 0; iPl < pls.length(); iPl++)
			{
				PlaneProfile ppI(pp.coordSys());
				ppI.joinRing(pls[iPl], _kAdd);
				
				if (dContourThickness > 0)
				{
					ppI.shrink(-.5 * dContourThickness);
					PlaneProfile ppContour = ppI;
					ppI.shrink(dContourThickness);
					ppContour.subtractProfile(ppI);
					dp.draw(ppContour, _kDrawFilled);
				}
				else
				{
					dp.draw(ppI);
				}
			}//next iPl
		}
		else if(bContour && bTransparency0)
		{ 
			Map m;
			nColorContoursT.append(nColorContour);
			PLine pls[]=pp.allRings();
			for (int iPl=0;iPl<pls.length();iPl++)
			{
				PlaneProfile ppI(pp.coordSys());
				ppI.joinRing(pls[iPl], _kAdd);
				PlaneProfile ppContour;
				if (dContourThickness>0)
				{
					ppI.shrink(-.5*dContourThickness);
					ppContour=ppI;
					ppI.shrink(dContourThickness);
					ppContour.subtractProfile(ppI);
				}
//				ppContour.transformBy(_ZW*2000);
//				ppContour.vis(6);
//				ppContour.transformBy(-_ZW*2000);
				
				m.appendPlaneProfile("pp",ppContour);
//				m.appendPlaneProfile("pp",ppI);
			}//next iPl
			mapContoursT.appendMap("m",m);
		}
		else
		{ 
			nColorContoursT.append(10e5);
			mapContoursT.appendMap("m",Map());
		}
		mapEntitiesUsed.appendMap("mapEntity",mapEntityI);
		// HSB-10159 save entity to be hatched and the hatch
		{ 
			entsHatch.append(massElement);
			String sAngle = dRotationTotal; sAngle.format("%.2f", dRotationTotal);
			String sScale0 = dScale0; sScale0.format("%.4f", dScale0);
			String sHatchIdentifier = sMaterial + sPattern + sAngle + sScale0 + nColor + nSolidTransparency;
			if (sHatchIdentifiers.find(sHatchIdentifier) > - 1)
			{
				// hatch already saved
				continue;
			}
			
			sHatchIdentifiers.append(sHatchIdentifier);
			Map mapHatch;
			// material to which it is been used
//			mapHatch.setString("sMaterial", sMaterial);
			mapHatch.setString("sMaterial", sMaterial);
			// pattern
			mapHatch.setString("sPattern", sPattern);
			mapHatch.setDouble("dAngle", dRotationTotal);
			mapHatch.setDouble("dScale", dScale0);
			// solid hatch
			mapHatch.setInt("nColor", nColor);
			mapHatch.setInt("nSolidTransparency", nSolidTransparency);
			mapHatchesUsed.appendMap("mapHatch", mapHatch);
		}
	}//next i
//End hatch masselement//endregion 
	
//region hatch entVolumes
	{ 
//		// first set the values to default
//		sPattern = "ANSI31";
//		// color index
//		nColor = 1;
//		// transparency
//		nTransparency = 0;
//		// hatch angle
		dAngle = 0;
//		// hatch scale
//		dScale = 10.0;
//		// dScaleMin
//		dScaleMin = 25;
//		// by default make dynamic
//		bStatic = 0;
	}
//	if (!bByPainter || bIsTslPainter)
	for (int i = 0; i < entVolumes.length(); i++)
	{ 
		Entity ent = entVolumes[i];
		if ( ! ent.isVisible())continue;
		if (bByPainter && !ent.acceptObject(painter.filter())){ continue;}
		Group grps[] = ent.groups();
		int bOff=true;
		for (int igrp=0;igrp<grps.length();igrp++) 
		{ 
			if(grps[igrp].groupVisibility(false)==_kIsOn)
			{ 
				bOff = false;
				break;
			}
		}//next igrp
		if (grps.length() == 0)bOff = false;
		if (bOff)continue;
//		String sTslName = tsl.scriptName();
		// body of the TSL, all that is drawn from a Display object
		Body bd = ent.realBody();
		if (bd.volume() < dEps)
		{ 
			// body has a small volume
			continue;
		}
		
		if ( ! bHasSection)
		{ 
			// paperspace layout or block space shopdrawing
			bd.transformBy(ms2ps);
		}
		
//		bd.vis(7);
		bd.intersectWith(bdClip);
		bd.vis(9);
		if (bHasSection)
		{
			// transform where the section is
			bd.transformBy(ms2ps);
		}
//		PlaneProfile pp = bd.extractContactFaceInPlane(Plane(_Pt0, vecZ), dEps);
		PlaneProfile pp = bd.shadowProfile(Plane(_Pt0, vecZ));
		if (pp.area() < dEps)
		{ 
			// nothing to hatch, skip this "i" TSL
			continue;
		}
//		Vector3d vecXTsl = tsl.coordSys().vecX();
//		Vector3d vecYTsl = tsl.coordSys().vecY();
//		Vector3d vecZTsl = tsl.coordSys().vecZ();
//		vecXTsl.transformBy(ms2ps);
//		vecYTsl.transformBy(ms2ps);
//		vecZTsl.transformBy(ms2ps);
//		String sOrientation = "X";
//		if (abs(vecYTsl.dotProduct(_ZW)) > abs(vecXTsl.dotProduct(_ZW))
//		  && abs(vecYTsl.dotProduct(_ZW)) > abs(vecZTsl.dotProduct(_ZW)))
//		{
//			sOrientation = "Y";
//		}
//		else if (abs(vecZTsl.dotProduct(_ZW)) > abs(vecXTsl.dotProduct(_ZW))
//		 && abs(vecZTsl.dotProduct(_ZW)) > abs(vecYTsl.dotProduct(_ZW)))
//		{ 
//			sOrientation = "Z";
//		}
//		Vector3d vecDir;
//		if (sOrientation == "X")
//		{ 
//			// vecWoodGrainDirectionJ most aligned with _ZW
//			vecDir = _ZW.crossProduct(vecYTsl);
//			vecDir.normalize();
//			vecDir = _ZW.crossProduct(vecDir);
//			if (vecDir.length() < dEps)
//			{ 
//			// vecDir in the same direction with the _ZW
//				reportMessage(TN("|unexpected error 1010|"));
//				eraseInstance();
//				return;
//			}
//			vecDir.normalize();
//		}
//		else if (sOrientation == "Y" || sOrientation == "Z")
//		{ 
//			// vecNormalWoodGrainDirectionJ most aligned with _ZW
//			vecDir = _ZW.crossProduct(vecXTsl);
//			vecDir.normalize();
//			vecDir = _ZW.crossProduct(vecDir);
//		}
		Map mapEntityI;mapEntityI.setEntity("ent", ent);
		mapEntityI.setString("orientation0","X");
		String sMaterial = "*";
//		double dRotation = _XW.angleTo(vecDir, _ZW);
		double dRotation = 0;
		int bMaterialFound = false;
		int bOrientationFound = false;
		Map mapHatchFound, mapOrientationFound;

		if ( (!bMaterialFound && bMapHatchDefaultFound && nHatchMapping==0) || 
			(!bMaterialFound && bMapHatchDefaultPainterFound && nHatchMapping==1) ||
			(!bMaterialFound && bMapPainterGroupsFoundAll && nHatchMapping && bPainterGroup) )
		{ 
			if(nHatchMapping==0)
			{ 
				if (nHatchesUsed.find(nHatchDefaultIndex) < 0)nHatchesUsed.append(nHatchDefaultIndex);
				mapHatchFound = mapHatchDefault;
				bMaterialFound = true;
				mapEntityI.setInt("hatch0",nHatchDefaultIndex);
			}
			else if(nHatchMapping==1 && !bPainterGroup)
			{ 
				if (nHatchesUsed.find(nHatchDefaultPainterIndex) < 0)nHatchesUsed.append(nHatchDefaultPainterIndex);
				mapHatchFound = mapHatchDefaultPainter;
				bMaterialFound = true;
				mapEntityI.setInt("hatch0",nHatchDefaultPainterIndex);
			}
			else if(nHatchMapping && bPainterGroup)
			{ 
				for (int k = 0; k < mapHatches.length(); k++)
				{ 
					Map mapHatchK = mapHatches.getMap(k);
					if (mapHatchK.hasString("Name") && mapHatches.keyAt(k).makeLower() == "hatch")
					{
						// HSB-7706
						if ( ! mapHatchK.getInt("isActive"))continue;
						if ( ! mapHatchK.hasString("PainterGroup"))continue;
						// 
						if (!mapHatchK.hasString("Painter"))continue;
						if(mapHatchK.getString("Painter")!=sRule)continue;
						String sPainterGroupMap = mapHatchK.getString("PainterGroup");
						String sFormatI=ent.formatObject(sPainterFormat);
						if(sPainterGroupMap.makeUpper()==sFormatI.makeUpper())
						{ 
							mapHatchFound = mapHatchK;
							if (nHatchesUsed.find(k) < 0)nHatchesUsed.append(k);
							bMaterialFound = true;
							mapEntityI.setInt("hatch0",k);
							break;
						}
					}
				}
			}
			int bAnisotropic = mapHatchFound.getInt("Anisotropic");
			if(!bAnisotropic)mapEntityI.setString("orientation0","X");
			// if the material is not found, use the default hatch
			Map mapOrientations = mapHatchDefault.getMap("Orientation[]");
			if (mapOrientations.length() < 1)
			{ 
				// no orientation map defined for this material 
				reportMessage("\n"+scriptName()+" "+T("|no map of orientation found for the material of the beam|"));
				eraseInstance();
				return;
			}
			bOrientationFound = false;
//			if ( ! bAnisotropic)
			{
				for (int l = 0; l<mapOrientations.length(); l++)
				{ 
					Map mapOrientationL=mapOrientations.getMap(l);
					if (mapOrientationL.hasString("Name") && mapOrientations.keyAt(l).makeLower()=="orientation")
					{ 
						mapOrientationFound=mapOrientationL;
						bOrientationFound=true;
						break;
					}
				}//next l
			}
		}
		
		// if no material found and no default material
		if ( ! bMaterialFound && !bMapHatchDefaultFound)
		{ 
			// go to next entity (panel component)
			continue;
		}
		// default values
		{ 
			nSolidHatch=0;
			nSolidTransparency = 0;
			nSolidColor = 0;
			bHasSolidColor = 0;
			// default orientation hatch parameters
			sPattern = "ANSI31";// hatch pattern
			nColor = 1;// color index
			nTransparency = 0;// transparency
			dAngle = 0;// hatch angle
			dScale = 10.0;// hatch scale
			dScaleMin = 25;// dScaleMin
			bStatic = 0;// by default make dynamic
			// contour parameters
			bContour = 0;
			nColorContour = 0;
			dContourThickness = 0;
		}
		{ 
			String ss;
			Map m = mapHatchFound;
			ss = "SolidHatch"; if(m.hasInt(ss)) nSolidHatch = m.getInt(ss);
			ss = "SolidTransparency"; if(m.hasInt(ss)) nSolidTransparency = m.getInt(ss);
			ss = "SolidColor"; if(m.hasInt(ss)) nSolidColor = m.getInt(ss);
			ss = "SolidColor"; bHasSolidColor= m.hasInt(ss);
		}
		// properties in orientation map
		{ 
			String ss;
			Map m = mapOrientationFound;
			ss = "Pattern"; if(m.hasString(ss)) sPattern = m.getString(ss);
			ss = "Color"; if(m.hasInt(ss)) nColor = m.getInt(ss);
			ss = "Transparency"; if(m.hasInt(ss)) nTransparency = m.getInt(ss);
			ss = "Angle"; if(m.hasDouble(ss)) dAngle = m.getDouble(ss);
			ss = "Scale"; if(m.hasDouble(ss)) dScale = m.getDouble(ss);
			ss = "ScaleMin"; if(m.hasDouble(ss)) dScaleMin = m.getDouble(ss);
			ss = "Static"; if(m.hasInt(ss)) bStatic = m.getInt(ss);
		}
		// properties in contour map
		Map mapContour = mapHatchFound.getMap("Contour");
		{ 
			String ss;
			Map m = mapContour;
			ss = "Contour"; if(m.hasInt(ss)) bContour = m.getInt(ss);
			ss = "Color"; if(m.hasInt(ss)) nColorContour = m.getInt(ss);
			ss = "Thickness"; if(m.hasDouble(ss)) dContourThickness = m.getDouble(ss);
		}
		if(nPaperPlane)
		{ 
			PlaneProfile ppPaper(pnPaper);
			ppPaper.unionWith(pp);
			pp=PlaneProfile (pnPaper);
			pp.unionWith(ppPaper);
		}
		double dMin = U(10e7);
	// calculate min width rotating 0-180 by 10 degrees
		Vector3d vecXrotI = vecX;
		Vector3d vecYrotI = vecY;
		for (int irot=0;irot<17;irot++) 
		{ 
			LineSeg segI = pp.extentInDir(vecXrotI);
			double dXI=abs(vecXrotI.dotProduct(segI.ptStart()-segI.ptEnd()));
			if(dXI<dMin)dMin=dXI;
			vecXrotI=vecXrotI.rotateBy(U(10),vecZ);
		}//next irot
//		LineSeg seg = pp.extentInDir(vecX);
//		seg.vis(4);
//		double dX = abs(vecX.dotProduct(seg.ptStart() - seg.ptEnd()));
//		double dY = abs(vecY.dotProduct(seg.ptStart() - seg.ptEnd()));
//		double dMin = dX<dY ? dX : dY;
		double dScaleFac = dScale;
		if (dScaleFac < 0.01)dScaleFac = 1;
		double dScale0 = dScaleMin;
		if (bStatic)
		{
			// static, not adapted to the size, get the factor defined in dScale
			dScale0 = dScaleFac;
			if (dScale0 < dScaleMin)
			{ 
				dScale0 = dScaleMin;
			}
		}
		else
		{ 
			// dynamic, adapted to the minimum dimension
			// should not be smaller then dScaleMin
			dScale0=dScaleFac*(dMin/dScaleVP)/U(1000);
			if (dScale0 < dScaleMin)
			{ 
				dScale0 = dScaleMin;
			}
		}
		// multiply dScale0 with the global scaling factor
		dScale0 *= dGlobalScaling;
		if (nColor < 1)
		{ 
			// -2 by entity, -1 by layer, 0 by entity
			if (nColor == -2)
			{ 
				// get color from entity (beam) and use this for the hatch
				nColor = ent.color();
			}
			else if (nColor <- 2)
			{ 
				//nColor <- 2; -3,-4,-5 etc then take by entity
				nColor = - 2;
			}
		}
		if (nColorContour < 1)
		{ 
			// -2 by entity, -1 by layer, 0 by entity
			if (nColorContour == -2)
			{ 
				// get color from entity (beam) and use this for the hatch
				nColorContour = ent.color();
			}
			else if (nColorContour <- 2)
			{ 
				//nColor <- 2; -3,-4,-5 etc then take by entity
				nColorContour = - 2;
			}
		}
		if (nSolidColor < 1)
		{ 
			// -2 by entity, -1 by layer, 0 by entity
			if (nSolidColor == -2)
			{ 
				// get color from entity (beam) and use this for the hatch
				nSolidColor = ent.color();
			}
			else if (nSolidColor <- 2)
			{ 
				//nColor <- 2; -3,-4,-5 etc then take by entity
				nSolidColor = - 2;
			}
		}
		// draw the hatch for the beam
		int nPattern = _HatchPatterns.findNoCase(sPattern, 0);
		sPattern = nPattern >- 1 ? _HatchPatterns[nPattern] : _HatchPatterns[0];
		// hatch object
		Hatch hatch(sPattern, dScale0);
		double dRotationTotal = dAngle + dRotation;
		//HSB-11326: transform to - 90;90
		if(dRotationTotal>=0 && dRotationTotal<=90)
			dRotationTotal = dRotationTotal;
		else if(dRotationTotal>90 && dRotationTotal<=180)
			dRotationTotal = dRotationTotal - 180;
		else if(dRotationTotal>180 && dRotationTotal<=270)
			dRotationTotal = dRotationTotal - 180;
		else if(dRotationTotal>270 && dRotationTotal<=360)
			dRotationTotal = dRotationTotal - 360;
			
		hatch.setAngle(dRotationTotal);
		dp.color(nColor);
		int _iTransparency=nTransparency;
		int _iSolidTransparency=nSolidTransparency;
		if(dGlobalTransparency<=0)
		{ 
			_iTransparency = 0;
			_iSolidTransparency = 0;
		}
		else if(dGlobalTransparency>0 && dGlobalTransparency<1)
		{ 
			_iTransparency = nTransparency * dGlobalTransparency;
			_iSolidTransparency=nSolidTransparency* dGlobalTransparency;
		}
		else if(dGlobalTransparency>1 && dGlobalTransparency<100)
		{ 
			_iTransparency = nTransparency+dGlobalTransparency*((100.0 - nTransparency) / 99.0);
			_iSolidTransparency = nSolidTransparency+dGlobalTransparency*((100.0 - nSolidTransparency) / 99.0);
		}
		else if(dGlobalTransparency>=100)
		{ 
			_iTransparency = 100;
			_iSolidTransparency = 100;
		}
		dp.transparency(_iTransparency);
		if(bStatic)
			dp.draw(pp, hatch);
		if(!bStatic)
		{ 
			ppsDynamic.append(pp);
			nColorsDynamic.append(nColor);
			nTransparencysDynamic.append(_iTransparency);
			dScaleFacsDynamic.append(dScaleFac);
			dScaleMinsDynamic.append(dScaleMin);
			sHatchPatternsDynamic.append(sPattern);
			dAnglesDynamic.append(dRotationTotal);
			if (dMin>dMinAll)dMinAll=dMin;
			dMinsDynamic.append(dMin);
		}
		if (nSolidHatch)
		{ 
			if(bHasSolidColor)
				dp.color(nSolidColor);
			// plot the solid hatch with transparency
			dp.transparency(_iSolidTransparency);
			dp.draw(pp, _kDrawFilled, _iSolidTransparency);
		}
		// contour
		if (bContour)
		{
			dp.transparency(0);
			PLine pls[] = pp.allRings();
			dp.color(nColorContour);
			for (int iPl = 0; iPl < pls.length(); iPl++)
			{
				PlaneProfile ppI(pp.coordSys());
				ppI.joinRing(pls[iPl], _kAdd);
				
				if (dContourThickness > 0)
				{
					ppI.shrink(-.5 * dContourThickness);
					PlaneProfile ppContour = ppI;
					ppI.shrink(dContourThickness);
					ppContour.subtractProfile(ppI);
					dp.draw(ppContour, _kDrawFilled);
				}
				else
				{
					dp.draw(ppI);
				}
			}//next iPl
		}
		mapEntitiesUsed.appendMap("mapEntity",mapEntityI);
		// HSB-10159 save entity to be hatched and the hatch
		{ 
			entsHatch.append(ent);
			String sAngle = dRotationTotal; sAngle.format("%.2f", dRotationTotal);
			String sScale0 = dScale0; sScale0.format("%.4f", dScale0);
			String sHatchIdentifier = sMaterial + sPattern + sAngle + sScale0 + nColor + nSolidTransparency;
			if (sHatchIdentifiers.find(sHatchIdentifier) > - 1)
			{
				// hatch already saved
				continue;
			}
			
			sHatchIdentifiers.append(sHatchIdentifier);
			Map mapHatch;
			// material to which it is been used
//			mapHatch.setString("sMaterial", sMaterial);
			mapHatch.setString("sMaterial", sMaterial);
			// pattern
			mapHatch.setString("sPattern", sPattern);
			mapHatch.setDouble("dAngle", dRotationTotal);
			mapHatch.setDouble("dScale", dScale0);
			// solid hatch
			mapHatch.setInt("nColor", nColor);
			mapHatch.setInt("nSolidTransparency", nSolidTransparency);
			mapHatchesUsed.appendMap("mapHatch", mapHatch);
		}
	}//next i
//End hatch entVolumes//endregion 

//region hatch fastenerAssemblyEnts
	if (!bByPainter || bIsFastenerAssemblyPainter)
	for (int i = 0; i < fastenerAssemblyEnts.length(); i++)
	{ 
		FastenerAssemblyEnt& f=fastenerAssemblyEnts[i];
		
		if (bByPainter && !f.acceptObject(painter.filter()))
		{
			continue;
		}
		if ( !f.isVisible())continue;
		Group grps[] = f.groups();
		int bOff=true;
		for (int igrp=0;igrp<grps.length();igrp++) 
		{ 
			if(grps[igrp].groupVisibility(false)==_kIsOn)
			{ 
				bOff = false;
				break;
			}
		}//next igrp
		if (grps.length() == 0)bOff = false;
		if (bOff)continue;
		
		Body bdf=f.realBody();
		String sDef=f.definition();
		FastenerAssemblyDef faDef(sDef);
		
		Entity entRefs[] = faDef.getReferencesToMe();
		
		FastenerListComponent flc=faDef.listComponent();
		
		// TSL that guides the fastener
		ToolEnt toolEnt=f.guidelineToolEnt();
		FastenerGuideline fGuidelines[]=toolEnt.fastenerGuidelines();
		FastenerAssemblyEnt fAEnts[]=toolEnt.getAttachedFasteners();
		
		// get the guidline corresponding to this FastenerAssemblyEnt
		FastenerGuideline fGuideline=getFastenerGuidline(f);
		fGuideline.ptStart().vis(3);
		
		// get material
		String sMaterial=faDef.listComponent().componentData().material();
		
		Vector3d vecXFastener=fGuideline.ptEnd()-fGuideline.ptStart();vecXFastener.normalize();
		Vector3d vecYFastener=_YW.isParallelTo(vecXFastener)?_ZW:_YW;
		vecYFastener=vecXFastener.crossProduct(vecYFastener.crossProduct(vecXFastener));
		Vector3d vecZFastener=vecXFastener.crossProduct(vecYFastener);vecZFastener.normalize();
		
		Point3d ptCen = f.realBody().ptCen();
		CoordSys csCollectionTransform;
		int nCollectionTransform = false;
		Map mapEntityI;
//		if(nFastenersCollection[i]>-1)
//		{ 
//			csCollectionTransform=csCollections[nFastenersCollection[i]];
//			nCollectionTransform=true;
//		}
		
		if(nCollectionTransform)
		{ 
			vecXFastener.transformBy(csCollectionTransform);
			vecYFastener.transformBy(csCollectionTransform);
			vecZFastener.transformBy(csCollectionTransform);
			mapEntityI.setPoint3d("ptOrgTransform",csCollectionTransform.ptOrg());
			mapEntityI.setVector3d("vecXTransform",csCollectionTransform.vecX());
			mapEntityI.setVector3d("vecYTransform",csCollectionTransform.vecY());
			mapEntityI.setVector3d("vecZTransform",csCollectionTransform.vecZ());
		}
		
		// transform vectors to the section coordinate system
		vecXFastener.transformBy(ms2ps);
		vecYFastener.transformBy(ms2ps);
		vecZFastener.transformBy(ms2ps);
		
		// find the most aligned vector with the vecX1 of the section cut
		String sOrientation = "X";
		if (abs(vecYFastener.dotProduct(_ZW)) > abs(vecXFastener.dotProduct(_ZW))
		  && abs(vecYFastener.dotProduct(_ZW)) > abs(vecZFastener.dotProduct(_ZW)))
		{
			sOrientation = "Y";
		}
		else if (abs(vecZFastener.dotProduct(_ZW)) > abs(vecXFastener.dotProduct(_ZW))
		 && abs(vecZFastener.dotProduct(_ZW)) > abs(vecYFastener.dotProduct(_ZW)))
		{ 
			sOrientation = "Z";
		}
	// find the vector that gives the direction of panel and project to _XY plane
		Vector3d vecDir;
		if (sOrientation == "X")
		{ 
			// vecWoodGrainDirectionJ most aligned with _ZW
			vecDir = _ZW.crossProduct(vecYFastener);
			vecDir.normalize();
			vecDir = _ZW.crossProduct(vecDir);
			if (vecDir.length() < dEps)
			{ 
			// vecDir in the same direction with the _ZW
				reportMessage("\n"+scriptName()+" "+T("|unexpected error 1010|"));
				eraseInstance();
				return;
			}
			vecDir.normalize();
			
//			vecDir = vecXFastener;
		}
		else if (sOrientation == "Y" || sOrientation == "Z")
		{ 
			// vecNormalWoodGrainDirectionJ most aligned with _ZW
			vecDir = _ZW.crossProduct(vecXFastener);
			vecDir.normalize();
			vecDir = _ZW.crossProduct(vecDir);
			
//			if(sOrientation=="Y")
//				vecDir = vecYBeam;
//			else if(sOrientation=="Z")
//				vecDir = vecZBeam;
		}
		
		mapEntityI.setEntity("ent", f);
		mapEntityI.setString("orientation0",sOrientation);
		// rotation wrt local axis
		double dRotation;
		dRotation= _XW.angleTo(vecDir, _ZW);
		// angle between _ZW and vecDir
//		Vector3d vecDirZw = vecDir.crossProduct(_ZW);
//		vecDirZw.normalize();
//		dRotation = vecDir.angleTo(_ZW, vecDirZw);
		
		// get the material of the fastener
//		String sMaterial = f.material();
		Body bd = f.realBody();
		if (nCollectionTransform)
		{ 
			bd.transformBy(csCollectionTransform);
		}
		// Ticket ID #9984823
		// body intersect not reliable, use pp intersect
		int bHasIntersection = false;
		PlaneProfile ppIntersect;
		Body bdIntersect = bd;
		int bIntersect=bdIntersect.intersectWith(bdClip);
		LineSeg segsVis[0];
		if (bHasSection)
		{ 
			// for section in model space
//			CoordSys csSection = section.coordSys();
//			csSection.transformBy(ps2ms);
//			// vector normal with the viewport
//			Vector3d vecNormal = csSection.vecZ();
//			vecNormal.vis(_PtG[0], 6);
//			Plane pn0(_PtG[0], vecNormal);
//			Plane pn1(_PtG[1], vecNormal);
//			bd.vis(3);
//				PlaneProfile pptest = bd.extractContactFaceInPlane(pn0,U(1));
			
			if(bIntersect && bdIntersect.volume()>pow(dEps,3))
			{ 
				ppIntersect = bdIntersect.shadowProfile(pn0);
//					ppIntersect = bdIntersect.extractContactFaceInPlane(pn0,dSectionDepth);
				int bShowHiddenLines = false;
				int bShowOnlyHiddenLines = false;
				int bShowApproximatingEdges = false;
				CoordSys csView = csSection;
//					csView=CoordSys(csSection.ptOrg()-csSection.vecZ()*dSectionDepth, 
//						csSection.vecX(), csSection.vecY(), csSection.vecZ());
//					csView.vis(1);
				segsVis= bdIntersect.hideDisplay(csView, bShowHiddenLines, bShowOnlyHiddenLines, bShowApproximatingEdges);
//					for (int iseg=0;iseg<segsVis.length();iseg++) 
//					{ 
//						segsVis[iseg].vis(1); 
//					}//next iseg
				segsVis= pn0.projectLineSegs(segsVis);
				ppIntersect.vis(4);
			}
			else
			{ 
				pn0.vis(4);
				double dvolbd = bd.volume();
	//				double dAreatt = pptest.area();
				PlaneProfile ppBd0 = bd.getSlice(pn0);
				PlaneProfile ppBd1 = bd.getSlice(pn1);
				
				int nScenario=-1;
				if(ppBd0.area()>pow(dEps,2) || ppBd1.area()>pow(dEps,2))
				{ 
					// 1.
					nScenario = 1;
				}
				else
				{ 
					// 2. or 3.
					// create sections between pn0 and pn1 and check whether it cuts the body
					Point3d ptCenBd = bd.ptCen();
					// point ptCenBd inside 2 points pt1 and pt2
					int bInside=true;
					{ 
						Vector3d vecDir = vecNormal;
						vecDir.normalize();
						double dLengthPtI=abs(vecDir.dotProduct(ptCenBd-pt1))
							 + abs(vecDir.dotProduct(ptCenBd - pt2));
						double dLengthSeg = abs(vecDir.dotProduct(pt1 - pt2));
						if (abs(dLengthPtI - dLengthSeg) > dEps)bInside=false;
					}
					if(bInside)
					{
						Plane pnCen(ptCenBd, vecNormal);
						PlaneProfile ppCen = bd.getSlice(pnCen);
						if (ppCen.area() > pow(dEps, 2))
						{
							ppBd0 = ppCen;
							nScenario = 2;
						}
					}
				}
				if(nScenario==-1)
					continue;
				
				if (ppBd0.area() < dEps && ppBd1.area() < dEps)
				{ 
					// no intersection, go to next component
					continue;
				}
				// there is an intersection
				bHasIntersection = true;
				
				PlaneProfile ppBdShadow = bd.shadowProfile(pn0);
				ppBdShadow.vis(3);
	//			PlaneProfile ppBdClipShadow = bdClip.shadowProfile(pn0);
	//			ppBdClipShadow.vis(3);
				// intersection of ppBdShadow and ppBdClipShadow
				ppIntersect = ppBdShadow;
				ppIntersect.intersectWith(ppBdClipShadow);
				// HSB-11469
				PlaneProfile ppBdUnion = ppBd0; ppBdUnion.unionWith(ppBd1);
				ppIntersect.intersectWith(ppBdUnion);
			}
			// transform from clip to section
			ppIntersect.transformBy(ms2ps);
//			ppIntersect.vis(5);
			for (int iseg=0;iseg<segsVis.length();iseg++)
			{ 
				segsVis[iseg].transformBy(ms2ps);
			}//next iseg
		}
		else
		{ 
//			if(nCollectionTransform)
//			{ 
//				bd.transformBy(csCollectionTransform);
//			}
			// viewport in layout or viewport in shopdraw
			// transfor from model to layout
			bd.transformBy(ms2ps);
			bdIntersect = bd;
			
			bIntersect=bdIntersect.intersectWith(bdClip);
			if(bIntersect && bdIntersect.volume()>pow(dEps,3))
			{ 
				ppIntersect = bdIntersect.shadowProfile(pn0);
//					ppIntersect = bdIntersect.extractContactFaceInPlane(pn0,dSectionDepth);
				int bShowHiddenLines = false;
				int bShowOnlyHiddenLines = false;
				int bShowApproximatingEdges = false;
				CoordSys csView = csSection;
//					csView=CoordSys(csSection.ptOrg()-csSection.vecZ()*dSectionDepth, 
//						csSection.vecX(), csSection.vecY(), csSection.vecZ());
//					csView.vis(1);
				segsVis= bdIntersect.hideDisplay(csView, bShowHiddenLines, bShowOnlyHiddenLines, bShowApproximatingEdges);
//					for (int iseg=0;iseg<segsVis.length();iseg++) 
//					{ 
//						segsVis[iseg].vis(1); 
//					}//next iseg
				segsVis= pn0.projectLineSegs(segsVis);
				ppIntersect.vis(3);
			}
			else
			{ 
	//			bdIntersect.vis(3);
				double dSectionLevelPaper;
				double dSectionDepthPaper;
				{ 
	//				// top point in the model
	//				Point3d pt1 = ptMaxModel - vecZModel * dSectionLevel;
	//				// bottom point in the model
	//				Point3d pt2 = pt1 - vecZModel * dSectionDepth;
	//				if (dSectionDepth < dEps)
	//				{ 
	//					pt2 = pt1 - vecZModel * dEps;
	//				}
	//				pt1.transformBy(ms2ps);
	//				pt2.transformBy(ms2ps);
	//				
	//				pt1.vis(4);
	//				pt2.vis(4);
	//				
	//				Plane pn0(pt1, _ZW);
	//				Plane pn1(pt2, _ZW);
					PlaneProfile ppBd0 = bd.getSlice(pn0);
					PlaneProfile ppBd1 = bd.getSlice(pn1);
					int nScenario=-1;
					if(ppBd0.area()>pow(dEps,2) || ppBd1.area()>pow(dEps,2))
					{ 
						// 1.
						nScenario = 1;
					}
					else
					{ 
						// 2. or 3.
						// create sections between pn0 and pn1 and check whether it cuts the body
						Point3d ptCenBd = bd.ptCen();
						// point ptCenBd inside 2 points pt1 and pt2
						int bInside=true;
						{ 
							Vector3d vecDir = vecNormal;
							vecDir.normalize();
							double dLengthPtI=abs(vecDir.dotProduct(ptCenBd-pt1))
								 + abs(vecDir.dotProduct(ptCenBd - pt2));
							double dLengthSeg = abs(vecDir.dotProduct(pt1 - pt2));
							if (abs(dLengthPtI - dLengthSeg) > dEps)bInside=false;
						}
						if(bInside)
						{
							Plane pnCen(ptCenBd, vecNormal);
							PlaneProfile ppCen = bd.getSlice(pnCen);
							if (ppCen.area() > pow(dEps, 2))
							{
								ppBd0 = ppCen;
								nScenario = 2;
							}
						}
					}
					if(nScenario==-1)
						continue;
					
					double dArea0 = ppBd0.area();
					double dArea1 = ppBd1.area();
					if (ppBd0.area() < pow(dEps, 2) && ppBd1.area() < pow(dEps, 2))
					{ 
						// no intersection, go to next component
						continue;
					}
					// there is an intersection
					bHasIntersection = true;
					
					PlaneProfile ppBdShadow = bd.shadowProfile(pn0);
					ppBdShadow.vis(3);
	//				PlaneProfile ppBdClipShadow = bdClip.shadowProfile(pn0);
	//				ppBdClipShadow.vis(3);
					
					// intersection of ppBdShadow and ppBdClipShadow
					ppIntersect = ppBdShadow;
					ppIntersect.intersectWith(ppBdClipShadow);
					// HSB-11469
					PlaneProfile ppBdUnion = ppBd0; ppBdUnion.unionWith(ppBd1);
					ppIntersect.intersectWith(ppBdUnion);
					//
	//				ppIntersect.vis(5);
					// transform back to model
					bd.transformBy(ps2ms);
				}
			}
		}
		
		
		PlaneProfile pp = ppIntersect;
		if (pp.area() < dEps)
		{ 
			// nothing to hatch, skip this "j" beam
			continue;
		}
//		pp.vis(2);
	// get the map of the hatch for this material
		int bMaterialFound = false;
		// get the map of the hatch for this material
		int bOrientationFound = false;
		Map mapHatchFound, mapOrientationFound;
		
		{ 
			Map mInHatchFind;
			mInHatchFind.setMap("mapHatches",mapHatches);
			mInHatchFind.setInt("nHatchMapping",nHatchMapping);
			mInHatchFind.setInt("bPainterGroup",bPainterGroup);
			mInHatchFind.setString("sMaterial",sMaterial);
//				mInHatchFind.setInt("indexJ",j);
			mInHatchFind.setString("sOrientation",sOrientation);
			mInHatchFind.setMap("mapHatchDefaultPainter",mapHatchDefaultPainter);
			mInHatchFind.setInt("nHatchDefaultPainterIndex",nHatchDefaultPainterIndex);
			mInHatchFind.setString("sRule",sRule);
			mInHatchFind.setEntity("ent",f);
			mInHatchFind.setString("sPainterFormat",sPainterFormat);
			
			Map mOutHatchFind=getHatchDefinition(mInHatchFind,nHatchesUsed,mapEntityI);
			
			bMaterialFound=mOutHatchFind.getInt("bMaterialFound");
			bOrientationFound=mOutHatchFind.getInt("bOrientationFound");
			mapHatchFound=mOutHatchFind.getMap("mapHatchFound");
			mapOrientationFound=mOutHatchFind.getMap("mapOrientationFound");
		}
		
		// if material is found but orientation not found, skip the hatching
		if (bMaterialFound && !bOrientationFound)
		{ 
			// dont do the hatching, go to the next component
			// hatch for this material is not defined correctly
			continue;
		}
		
		if (!bMaterialFound && bMapHatchDefaultFound)
		{ 
			if (nHatchesUsed.find(nHatchDefaultIndex) < 0)nHatchesUsed.append(nHatchDefaultIndex);
			mapHatchFound = mapHatchDefault;
			bMaterialFound = true;
			if (nHatchesUsed.find(nHatchDefaultIndex) < 0)nHatchesUsed.append(nHatchDefaultIndex);
			mapEntityI.setInt("hatch0",nHatchDefaultIndex);
			int bAnisotropic = mapHatchFound.getInt("Anisotropic");
			if(!bAnisotropic)mapEntityI.setString("orientation0","X");
			
			// if the material is not found and a default hatch exists, use the default hatch
			Map mapOrientations = mapHatchDefault.getMap("Orientation[]");
			if (mapOrientations.length() < 1)
			{ 
				// no orientation map defined for this material 
				reportMessage("\n"+scriptName()+" "+T("|no map of orientation found for the material of the beam|"));
				eraseInstance();
				return;
			}
			bOrientationFound = false;
			if (!bAnisotropic)
			{
				for (int l = 0; l < mapOrientations.length(); l++)
				{ 
					Map mapOrientationL = mapOrientations.getMap(l);
					if (mapOrientationL.hasString("Name") && mapOrientations.keyAt(l).makeLower() == "orientation")
					{ 
						mapOrientationFound=mapOrientationL;
						bOrientationFound=true;
						break;
					}
				}//next l
			}
			else
			{ 
				// find the orientation for this component
				for (int l = 0; l < mapOrientations.length(); l++)
				{ 
					Map mapOrientationL = mapOrientations.getMap(l);
					if (mapOrientationL.hasString("Name") && mapOrientations.keyAt(l).makeLower() == "orientation")
					{ 
						String sOrientationMap = mapOrientationL.getString("Name");
						if (sOrientationMap.makeUpper() != sOrientation.makeUpper())
						{ 
							// not this orientation
							continue;
						}
						bOrientationFound = true;
						mapOrientationFound = mapOrientationL;
						break;
					}
				}//next l
			}
		}
		
		// if no material found and no default material
		if ( ! bMaterialFound || !bOrientationFound)
		{ 
			// go to next entity (panel component)
			continue;
		}
		// default values
		{ 
			nSolidHatch=0;
			nSolidTransparency = 0;
			nSolidColor = 0;
			bHasSolidColor = 0;
			// default orientation hatch parameters
			sPattern = "ANSI31";// hatch pattern
			nColor = 1;// color index
			nTransparency = 0;// transparency
			dAngle = 0;// hatch angle
			dScale = 10.0;// hatch scale
			dScaleMin = 25;// dScaleMin
			bStatic = 0;// by default make dynamic
			// contour parameters
			bContour = 0;
			nColorContour = 0;
			dContourThickness = 0;
		}
		// properties in hatch map
		{ 
			String ss;
			Map m = mapHatchFound;
			ss = "SolidHatch"; if(m.hasInt(ss)) nSolidHatch=m.getInt(ss);
			ss = "SolidTransparency"; if(m.hasInt(ss)) nSolidTransparency=m.getInt(ss);
			ss = "SolidColor"; if(m.hasInt(ss)) nSolidColor=m.getInt(ss);
			ss = "SolidColor"; bHasSolidColor=m.hasInt(ss);
			
		}
		// properties in orientation map
		{ 
			String ss;
			Map m = mapOrientationFound;
			ss = "Pattern"; if(m.hasString(ss)) sPattern = m.getString(ss);
			ss = "Color"; if(m.hasInt(ss)) nColor = m.getInt(ss);
			ss = "Transparency"; if(m.hasInt(ss)) nTransparency = m.getInt(ss);
			ss = "Angle"; if(m.hasDouble(ss)) dAngle = m.getDouble(ss);
			ss = "Scale"; if(m.hasDouble(ss)) dScale = m.getDouble(ss);
			ss = "ScaleMin"; if(m.hasDouble(ss)) dScaleMin = m.getDouble(ss);
			ss = "Static"; if(m.hasInt(ss)) bStatic = m.getInt(ss);
			// insulation
			bInsulation = false;
			if (sPattern == sInsulation)bInsulation = true;
//			ss = "Insulation"; if(m.hasInt(ss)) bInsulation=m.getInt(ss);
//			ss = "ScaleLongitudinal"; if(m.hasDouble(ss)) dScaleLongitudinal=m.getDouble(ss);
//			ss = "ScaleTransversal"; if(m.hasDouble(ss)) dScaleTransversal=m.getDouble(ss);
		}
		// properties in contour map
		Map mapContour = mapHatchFound.getMap("Contour");
		{ 
			String ss;
			Map m = mapContour;
			ss = "Contour"; if(m.hasInt(ss)) bContour = m.getInt(ss);
			ss = "Color"; if(m.hasInt(ss)) nColorContour = m.getInt(ss);
			ss = "Thickness"; if(m.hasDouble(ss)) dContourThickness = m.getDouble(ss);
			ss = "SupressBeamCross"; if(m.hasInt(ss)) bSupressBeamCross=m.getInt(ss);
		}
	// HSB-12339
		int bDrawCross=(!bSupressBeamCross);
	// adapt dScale and dScaleMin with the scale of viewport or shopdraw
//		dScale *= dScaleVP;//!!!
//		dScaleMin *= dScaleVP;
	// get extents of profile
		if(nPaperPlane)
		{ 
			PlaneProfile ppPaper(pnPaper);
			ppPaper.unionWith(pp);
			pp=PlaneProfile (pnPaper);
			pp.unionWith(ppPaper);
		}
		double dMin = U(10e7);
	// calculate min width rotating 0-180 by 10 degrees
		Vector3d vecXrotI = vecX;
		Vector3d vecYrotI = vecY;
		for (int irot=0;irot<17;irot++) 
		{ 
			LineSeg segI = pp.extentInDir(vecXrotI);
			double dXI=abs(vecXrotI.dotProduct(segI.ptStart()-segI.ptEnd()));
			if(dXI<dMin)dMin=dXI;
			vecXrotI=vecXrotI.rotateBy(U(10),vecZ);
		}//next irot
		pp.vis(3);
		LineSeg seg = pp.extentInDir(vecX);
		seg.vis(4);
//		double dX = abs(vecX.dotProduct(seg.ptStart() - seg.ptEnd()));
//		double dY = abs(vecY.dotProduct(seg.ptStart() - seg.ptEnd()));
//		double dMin = dX<dY?dX:dY;
	// 
		double dScaleFac = dScale;
		if (dScaleFac < 0.01)dScaleFac = 1;
		double dScale0 = dScaleMin;
		if (bStatic)
		{
			// static, not adapted to the size, get the factor defined in dScale
			dScale0 = dScaleFac;
			if (dScale0 < dScaleMin)
			{ 
				dScale0 = dScaleMin;
			}
		}
		else
		{ 
			// dynamic, adapted to the minimum dimension
			// should not be smaller then dScaleMin
			dScale0=dScaleFac*dMin;
			if (dScale0<dScaleMin)
			{ 
				dScale0=dScaleMin;
			}
		}
		// multiply dScale0 with the global scaling factor
		dScale0*=dGlobalScaling;
		// check the color
		// by layer and by block will set the color of the attached layer at the TSL
		if (nColor<1)
		{ 
			// -2 by entity, -1 by layer, 0 by entity
			if (nColor==-2)
			{ 
				// get color from entity (beam) and use this for the hatch
				nColor=f.color();
			}
			else if (nColor<-2)
			{ 
				//nColor <- 2; -3,-4,-5 etc then take by entity
				nColor=-2;
			}
		}
		if (nColorContour<1)
		{ 
			// -2 by entity, -1 by layer, 0 by entity
			if (nColorContour==-2)
			{ 
				// get color from entity (beam) and use this for the hatch
				nColorContour=f.color();
			}
			else if (nColorContour<-2)
			{ 
				//nColor <- 2; -3,-4,-5 etc then take by entity
				nColorContour=-2;
			}
		}
		if (nSolidColor<1)
		{ 
			// -2 by entity, -1 by layer, 0 by entity
			if (nSolidColor==-2)
			{ 
				// get color from entity (beam) and use this for the hatch
				nSolidColor=f.color();
			}
			else if (nSolidColor<-2)
			{ 
				//nColor <- 2; -3,-4,-5 etc then take by entity
				nSolidColor=- 2;
			}
		}
		// draw the hatch for the beam
		int nPattern=_HatchPatterns.findNoCase(sPattern,0);
		sPattern=nPattern>-1?_HatchPatterns[nPattern]:_HatchPatterns[0];
		// hatch object
		Hatch hatch(sPattern, dScale0);
		double dRotationTotal=dAngle+dRotation;
		//HSB-11326:transform to - 90;90
//		if(dRotationTotal>=0 && dRotationTotal<=90)
//			dRotationTotal = dRotationTotal;
//		else if(dRotationTotal>90 && dRotationTotal<=180)
//			dRotationTotal = dRotationTotal - 180;
//		else if(dRotationTotal>180 && dRotationTotal<=270)
//			dRotationTotal = 270-dRotationTotal;
//		else if(dRotationTotal>270 && dRotationTotal<=360)
//			dRotationTotal = dRotationTotal - 360;
		//
		hatch.setAngle(dRotationTotal);
		dp.color(nColor);
		int _iTransparency=nTransparency;
		int _iSolidTransparency=nSolidTransparency;
		if(dGlobalTransparency<=0)
		{ 
			_iTransparency=0;
			_iSolidTransparency=0;
		}
		else if(dGlobalTransparency>0 && dGlobalTransparency<1)
		{ 
			_iTransparency=nTransparency*dGlobalTransparency;
			_iSolidTransparency=nSolidTransparency*dGlobalTransparency;
		}
		else if(dGlobalTransparency>1 && dGlobalTransparency<100)
		{ 
			_iTransparency=nTransparency+dGlobalTransparency*((100.0-nTransparency)/99.0);
			_iSolidTransparency=nSolidTransparency+dGlobalTransparency*((100.0-nSolidTransparency)/99.0);
		}
		else if(dGlobalTransparency>=100)
		{ 
			_iTransparency=100;
			_iSolidTransparency=100;
		}
//		String sGlobalTransparencyDescriptionSolid = T("|Calculated solid transparency is|"+" "+_iSolidTransparency);
//		String sGlobalTransparencyDescriptionPattern = T("|Calculated patern transparency is|"+" "+_iTransparency);
		dp.transparency(_iTransparency);
//		if(!bInsulation)
		{
			if(bStatic && !bTransparency0)
			{
//				dp.draw(pp, hatch);
				if(!bInsulation)
					dp.draw(pp, hatch);
			}
			else if(bStatic && bTransparency0)
			{ 
				ppsStaticT.append(pp);
				nColorsT.append(nColor);
				nTransparencysT.append(_iTransparency);
//				sHatchPatternsT.append(sPattern);
				if(!bInsulation)
					sHatchPatternsT.append(sPattern);
				else
					sHatchPatternsT.append("");
				dAnglesT.append(dRotationTotal);
				dScaleFacsT.append(dScaleFac);
				dScaleMinsT.append(dScaleMin);
			}
			else
			{
				// empty planeprofile
				ppsStaticT.append(PlaneProfile());
				nColorsT.append(10e5);
				nTransparencysT.append(10e5);
				sHatchPatternsT.append("");
				dAnglesT.append(10e5);
				dScaleFacsT.append(10e5);
				dScaleMinsT.append(10e5);
			}
			if(!bStatic && !bTransparency0)
			{ 
				ppsDynamic.append(pp);
				nColorsDynamic.append(nColor);
				nTransparencysDynamic.append(_iTransparency);
				dScaleFacsDynamic.append(dScaleFac);
				dScaleMinsDynamic.append(dScaleMin);
//				sHatchPatternsDynamic.append(sPattern);
				if(!bInsulation)
					sHatchPatternsDynamic.append(sPattern);
				else
					sHatchPatternsDynamic.append("");
				dAnglesDynamic.append(dRotationTotal);
				if (dMin>dMinAll)dMinAll=dMin;
				dMinsDynamic.append(dMin);
			}
			else if(!bStatic && bTransparency0)
			{ 
			// 
	//		pp.vis(3);
				ppsDynamicT.append(pp);
				nColorsDynamicT.append(nColor);
				nTransparencysDynamicT.append(_iTransparency);
				dScaleFacsDynamicT.append(dScaleFac);
				dScaleMinsDynamicT.append(dScaleMin);
				sHatchPatternsDynamicT.append(sPattern);
				dAnglesDynamicT.append(dRotationTotal);
				if (dMin>dMinAll)dMinAll=dMin;
				dMinsDynamicT.append(dMin);
			}
			else
			{ 
				ppsDynamicT.append(PlaneProfile());
				nColorsDynamicT.append(10e5);
				nTransparencysDynamicT.append(10e5);
				dScaleFacsDynamicT.append(10e5);
				dScaleMinsDynamicT.append(10e5);
				sHatchPatternsDynamicT.append(10e5);
				dAnglesDynamicT.append(10e5);
				if (dMin>dMinAll)dMinAll=dMin;
				dMinsDynamicT.append(10e5);
			}
		}
		if(bTransparency0)
		{ 
			bdsT.append(bd);
			Point3d ptCenI=bd.ptCen();
			ptCenI.vis(6+i);
			bd.vis(6+i);
			ptCensT.append(bd.ptCen());
		}
		if(nPaperPlane)
		{ 
			LineSeg _segsVis[0];
			_segsVis.append(segsVis);
			segsVis.setLength(0);
			for (int iseg=0;iseg<_segsVis.length();iseg++) 
			{ 
				Point3d pt1Paper=_segsVis[iseg].ptStart();
				Point3d pt2Paper=_segsVis[iseg].ptEnd();
				pt1Paper=pnPaper.closestPointTo(pt1Paper);
				pt2Paper=pnPaper.closestPointTo(pt2Paper);
				LineSeg lSegPaper(pt1Paper,pt2Paper);
				segsVis.append(lSegPaper);
			}//next iseg
		}
		if(segsVis.length()>0 )
		{ 
			for (int iseg=0;iseg<segsVis.length();iseg++)
			{ 
				dp.draw(segsVis[iseg]);
			}//next iseg
		}
		// HSB-21749: Fix solid hatch at beams
		if (nSolidHatch && !bTransparency0)
		{ 
			if(bHasSolidColor)
				dp.color(nSolidColor);
			// plot the solid hatch with transparency
			dp.transparency(_iSolidTransparency);
			dp.draw(pp, _kDrawFilled, _iSolidTransparency);
		}
		else if(nSolidHatch && bTransparency0)
		{ 
			bHasSolidColorsT.append(bHasSolidColor);
			// 0 transparency
			nSolidColorsT.append(nSolidColor);
			// plot the solid hatch with transparency
			_nSolidTransparencysT.append(_iSolidTransparency);
		}
		else
		{ 
			bHasSolidColorsT.append(false);
			nSolidColorsT.append(10e4);
			// plot the solid hatch with transparency
			_nSolidTransparencysT.append(10e4);
		}
		// contour
		if (bContour && !bTransparency0)
		{
			dp.transparency(0);
			PLine pls[] = pp.allRings();
			dp.color(nColorContour);
			for (int iPl = 0; iPl < pls.length(); iPl++)
			{
				PlaneProfile ppI(pp.coordSys());
				ppI.joinRing(pls[iPl], _kAdd);
				
				if (dContourThickness > 0)
				{
					ppI.shrink(-.5 * dContourThickness);
					PlaneProfile ppContour = ppI;
					ppI.shrink(dContourThickness);
					ppContour.subtractProfile(ppI);
					dp.draw(ppContour, _kDrawFilled);
				}
				else
				{
					dp.draw(ppI);
				}
			}//next iPl
		}
		else if(bContour && bTransparency0)
		{ 
			Map m;
			nColorContoursT.append(nColorContour);
			PLine pls[]=pp.allRings();
			for (int iPl=0;iPl<pls.length();iPl++)
			{
				PlaneProfile ppI(pp.coordSys());
				ppI.joinRing(pls[iPl], _kAdd);
				PlaneProfile ppContour;
				if (dContourThickness>0)
				{
					ppI.shrink(-.5*dContourThickness);
					ppContour=ppI;
					ppI.shrink(dContourThickness);
					ppContour.subtractProfile(ppI);
				}
//				ppContour.transformBy(_ZW*2000);
//				ppContour.vis(6);
//				ppContour.transformBy(-_ZW*2000);
				
				m.appendPlaneProfile("pp",ppContour);
//				m.appendPlaneProfile("pp",ppI);
			}//next iPl
			mapContoursT.appendMap("m",m);
		}
		else
		{ 
			nColorContoursT.append(10e5);
			mapContoursT.appendMap("m",Map());
		}
		if(bDrawCross && abs(vecXFastener.dotProduct(_ZW))>dEps )
		{ 
			dp.transparency(0);
			dp.color(nColorContour);
//			lCrossSegs=pp.splitSegments(lCrossSegs,true);
			
//			dp.draw(lCrossSegs);
		}
		
		mapEntitiesUsed.appendMap("mapEntity",mapEntityI);
		// HSB-10159 save entity to be hatched and the hatch
		{ 
			entsHatch.append(f);
			String sAngle=dRotationTotal; sAngle.format("%.2f", dRotationTotal);
			String sScale0=dScale0; sScale0.format("%.4f", dScale0);
			String sHatchIdentifier=sMaterial+sPattern+sAngle+sScale0+nColor+nSolidTransparency;
			if (sHatchIdentifiers.find(sHatchIdentifier)>-1)
			{
				// hatch already saved
				continue;
			}
			
			sHatchIdentifiers.append(sHatchIdentifier);
			Map mapHatch;
			// material to which it is been used
			mapHatch.setString("sMaterial", sMaterial);
			// pattern
			mapHatch.setString("sPattern", sPattern);
			mapHatch.setDouble("dAngle", dRotationTotal);
			mapHatch.setDouble("dScale", dScale0);
			// solid hatch
			mapHatch.setInt("nColor", nColor);
			mapHatch.setInt("nSolidTransparency", nSolidTransparency);
			mapHatchesUsed.appendMap("mapHatch", mapHatch);
		}
	}
//endregion hatch fastenerAssemblyEnts

//region Delete hatch
//region Trigger HatchDelete
	String sTriggerHatchDelete = T("|Delete Hatch|");
	addRecalcTrigger(_kContextRoot, sTriggerHatchDelete );
	if (_bOnRecalc && _kExecuteKey==sTriggerHatchDelete)
	{
		int nHatchesUnused[0];
		for (int iH=0;iH<mapHatches.length();iH++) 
		{ 
			if(nHatchesUsed.find(iH)<0)
			{ 
				if(nHatchesUnused.find(iH)<0)
					nHatchesUnused.append(iH);
			}
		}//next iH
		
		if(nHatchesUnused.length()==0)
		{ 
			reportMessage("\n"+scriptName()+" "+T("|All Hatches are used|"));
			setExecutionLoops(2);
			return;
		}
	// 
	// create TSL
		TslInst tslDialog; Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
		GenBeam gbsTsl[] = {}; Entity entsTsl[] = {}; Point3d ptsTsl[] = {_Pt0};
		int nProps[]={}; double dProps[]={}; String sProps[]={};
		Map mapTsl;	
		//
		Map _mapHatchNotUseds;
		String sHatchDelProps[0];
//			for (int i=0;i<mapHatches.length();i++) 
		for (int i=0;i<nHatchesUnused.length();i++) 
		{ 
//				if (nHatchesUnused.find(i) <0)continue;
			Map mapHatchI = mapHatches.getMap(nHatchesUnused[i]);
			String ss = mapHatchI.getString("Name");
			ss += " [";
			Map mapMaterials = mapHatchI.getMap("Material[]");
			for (int j = 0; j < mapMaterials.length(); j++)
			{ 
				Map mapMaterialJ = mapMaterials.getMap(j);
				ss+=mapMaterialJ.getString("Name");
				ss += ";";
			}
			ss += "]";
			String sKeyI = "Hatch" + i;
			sHatchDelProps.append(ss);
			_mapHatchNotUseds.setString(sKeyI, ss);
		}//next iH
		mapTsl.setMap("HatchNotUsed", _mapHatchNotUseds);
		mapTsl.setInt("NrHatchNotUsed", nHatchesUnused.length());
		
		mapTsl.setInt("DialogMode", 3);
		//
		tslDialog.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, 
			ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
		tslDialog.recalcNow();
		//
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{
				String sSelected = tslDialog.propString(0);
				int nIndexLoc = sHatchDelProps.find(sSelected);
				int nIndexGlog = nHatchesUnused[nIndexLoc];
				Map mapHatchesNew;
				mapHatchesNew.setMapKey("Hatch[]");
				for (int iH=0;iH<mapHatches.length();iH++) 
				{ 
					if (iH == nIndexGlog)continue;
					Map mapHi = mapHatches.getMap(iH);
					mapHatchesNew.appendMap("Hatch", mapHi);
				}//next iH
				Map mapGeneral = mapSetting.getMap("GeneralMapObject");
				Map mapSettingNew;
				mapSettingNew.setMapKey("root");
				mapSettingNew.appendMap("Hatch[]", mapHatchesNew);
				mapSettingNew.appendMap("GeneralMapObject", mapGeneral);
				if(mo.bIsValid())
					mo.setMap(mapSettingNew);
				else 
					mo.dbCreate(mapSettingNew);
			}
			tslDialog.dbErase();
		}
		setExecutionLoops(2);
		return;
	}//endregion
//End Delete hatch//endregion 
	
//region save in _Map the hatched entities and the maps of used hatches
	_Map.setMap("mapEntitiesUsed",mapEntitiesUsed);
	// HSB-10159
	_Map.setEntityArray(entsHatch, false, "entsHatch", "entsHatch", "entsHatch");
	_Map.setMap("mapHatchesUsed", mapHatchesUsed);
	if(sdv.bIsValid())
	{ 
		// get Multipage entity being created or regenerated
 		Entity entCollector;
 		entCollector = _Map.getEntity("Generation\\entCollector");
		if (!entCollector.bIsValid())
			entCollector = _Map.getEntity(_kOnGenerateShopDrawing +"\\entCollector");
//		if (!entCollector.bIsValid()) 
//		{
//			reportMessage("\n"+scriptName() +": entCollector not found");
//		}
//		else
//		{ 
//			reportMessage("\n"+scriptName() +": entCollector found");
//		}
		// get viewHatching TSL 
		TslInst tslHsbViewHatchings[0];
		{ 
			TslInst tslAttached[] = sdv.tslInstAttached();
			for (int i=0;i<tslAttached.length();i++) 
			{ 
				if(tslAttached[i].scriptName()=="hsbViewHatching")
				{ 
					if (tslHsbViewHatchings.find(tslAttached[i]) < 0)
					{
						tslHsbViewHatchings.append(tslAttached[i]);
					}
				}
			}//next i
		}
		
		if(bViewData)
		{ 
			int nTslHandle;
			// get existing mapX
			Map mapXexisting = entCollector.subMapX("hsbViewHatching");
			
			int nNrMaps;
			Map mapXexistingViewData;
			if(mapXexisting.hasMap(viewData.viewHandle()))
			{ 
				mapXexistingViewData = mapXexisting.getMap(viewData.viewHandle());
			}
			if(mapXexisting.hasMap(viewData.viewHandle()))
			{
				nNrMaps=mapXexisting.getMap(viewData.viewHandle()).length();
			}
			else 
			{ 
				nNrMaps = 0;
			}
			
			if (nNrMaps >= tslHsbViewHatchings.length())
			{ 
				// new map
				mapXexistingViewData = Map();
				nTslHandle = 0;
			}
			else
			{ 
				nTslHandle = nNrMaps;
			}
			
			Map mapXexistingTsl;
			mapXexistingTsl.setEntityArray(entsHatch, false, "entsHatch", "entsHatch", "entsHatch");
			mapXexistingTsl.setMap("mapHatchesUsed", mapHatchesUsed);
			//
			mapXexistingViewData.setMap(nTslHandle, mapXexistingTsl);
			//
			mapXexisting.setMap(viewData.viewHandle(), mapXexistingViewData);
			entCollector.setSubMapX("hsbViewHatching", mapXexisting);
			
//			entCollector.removeSubMapX("hsbViewHatching");
		}
	}
//End save in _Map the hatched entities and the maps of used hatches//endregion 
	
//region hatch mass groups
	
//	for (int i = 0; i < massGroups.length(); i++)
//	{
//		MassGroup& mg = massGroups[i];
//		
//		// coordinate system of the massgroup
//		Point3d ptOrgMass;
//		Vector3d vecXMass;
//		Vector3d vecYMass;
//		Vector3d vecZMass;
//		
//		Entity ents[] = mg.entity();
//		// get the ECS symbol of the massengroup
//		int iECSfound = false;
//		for (int j=0;j<ents.length();j++) 
//		{ 
//			EcsMarker ecs = (EcsMarker) ents[j];
//			if(ecs.bIsValid())
//			{ 
//				// ecsMarker found
//				CoordSys cs = ecs.coordSys();
//				vecXMass = cs.vecX();
//				vecYMass = cs.vecY();
//				vecZMass = cs.vecZ();
//				ptOrgMass = cs.ptOrg();
//				iECSfound = true;
//				break;
//			}
//		}//next j
//		if(!iECSfound)
//		{ 
//			CoordSys cs = mg.coordSys();
//			vecXMass = cs.vecX();
//			vecYMass = cs.vecY();
//			vecZMass = cs.vecZ();
//			ptOrgMass = cs.ptOrg();
//		}
//		
//		// 
//		vecXMass.vis(ptOrgMass, 1);
//		vecYMass.vis(ptOrgMass, 3);
//		vecZMass.vis(ptOrgMass, 150);
//		
//	// do hatching for each entity in the massgroup
//		
//		// Body of the massgroup
//		Body bd = mg.realBody();
//		if (bd.volume() < dEps)
//		{ 
//			// body neglectable
//			continue;
//		}
//		bd.intersectWith(bdClip);
//		bd.transformBy(ms2ps);
//		PlaneProfile pp = bd.extractContactFaceInPlane(Plane(_Pt0, vecZ), dEps);
//		
//		
//	// get extents of profile
//		LineSeg seg = pp.extentInDir(vecX);
//		double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
//		double dY = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
//		double dMin = dX<dY ? dX : dY;
//		
//	// 
//		double dScaleFac = dScale;
//		if (dScaleFac < 0.01)dScaleFac = 1;
//		double dScale0 = dScaleMin;
//		if (bStatic)
//		{
//			// static, not adapted to the size, get the factor defined in dScale
//			dScale0 = dScaleFac;
//			if (dScale0 < dScaleMin)
//			{ 
//				dScale0 = dScaleMin;
//			}
//		}
//		else
//		{ 
//			// dynamic, adapted to the minimum dimension
//			// should not be smaller then dScaleMin
//			dScale0 = dScaleFac * dMin;
//			if (dScale0 < dScaleMin)
//			{ 
//				dScale0 = dScaleMin;
//			}
//		}
//		
//		// draw the hatch for the beam
//		int nPattern = _HatchPatterns.findNoCase(sPattern, 0);
//		sPattern = nPattern >- 1 ? _HatchPatterns[nPattern] : _HatchPatterns[0];
//		// hatch object
//		Hatch hatch(sPattern, dScale0);
//		hatch.setAngle(dAngle);
//		dp.color(nColor);
//		dp.draw(pp, hatch);
//	}
//End hatch mass groups//endregion
	
// hatch dynamic hatches
if(!bTransparency0)
{ 
	for (int i=0;i<ppsDynamic.length();i++) 
	{ 
		double dScaleI=dScaleFacsDynamic[i];
		double dMinI=dMinsDynamic[i];
		dScaleI*= dMinI/dMinAll;
		if (dScaleI<dScaleMinsDynamic[i])
		{ 
			dScaleI=dScaleMinsDynamic[i];
		}
		dScaleI*=dGlobalScaling;
		Hatch hatch(sHatchPatternsDynamic[i], dScaleI);
		hatch.setAngle(dAnglesDynamic[i]);
		
		dp.color(nColorsDynamic[i]);
		dp.transparency(nTransparencysDynamic[i]);
		dp.draw(ppsDynamic[i], hatch);
	}//next i
}

// 
if(bTransparency0)
{ 
// no transparency
	// static planeprofiles
	for (int p=0;p<ppsStaticT.length();p++) 
	{ 
		PlaneProfile pp=ppsStaticT[p];
		if(pp.area()<pow(dEps,2))continue;
		Point3d ptCenThis=ptCensT[p];
		if(pp.area()<pow(dEps,2))continue;
		for (int p1=0;p1<ppsStaticT.length();p1++) 
		{ 
			if(p1==p)continue;
			Point3d ptp1=ptCensT[p1];
			if(_ZW.dotProduct(ptp1-ptCenThis)<dEps)continue;
			// subtract those that are above this planeprofile
			pp.subtractProfile(ppsDynamicT[p1]);
		}//next pp
		if(pp.area()<pow(dEps,2))continue;
		//
		double dScaleI=dScaleFacsT[p];
		double dMinI=dScaleMinsT[p];
		
		if (dScaleI < dMinI)
		{ 
			dScaleI = dMinI;
		}
		//20240617: Fix typo when getting hatch patterns
		Hatch hatch(sHatchPatternsDynamicT[p], dScaleI);
		hatch.setAngle(dAnglesT[p]);
		
		dp.color(nColorsT[p]);
		dp.transparency(nTransparencysT[p]);
//		dp.draw(ppsStaticT[p], hatch);
		pp.shrink(U(1));
		pp.shrink(-U(1));
		pp.shrink(-U(1));
		pp.shrink(U(1));
		dp.draw(pp, hatch);
		if(bHasSolidColorsT[p])
		{
			dp.color(nSolidColorsT[p]);
			dp.transparency(_nSolidTransparencysT[p]);
			dp.draw(pp,_kDrawFilled,_nSolidTransparencysT[p]);
		}
		
	}//next p
	for (int p=0;p<ppsDynamicT.length();p++) 
	{ 
		PlaneProfile pp=ppsDynamicT[p];
		if(pp.area()<pow(dEps,2))continue;
		Point3d ptCenThis=ptCensT[p];
		for (int p1=0;p1<ppsDynamicT.length();p1++) 
		{ 
			if(p1==p)continue;
			Point3d ptp1=ptCensT[p1];
			if(_ZW.dotProduct(ptp1-ptCenThis)<dEps)
			{
				continue;
			}
			
			pp.subtractProfile(ppsDynamicT[p1]);
			 
		}//next pp
		if(pp.area()<pow(dEps,2))continue;
		
		double dScaleI=dScaleFacsDynamicT[p];
		double dMinI=dMinsDynamicT[p];
		dScaleI*= dMinI/dMinAll;
		if (dScaleI<dScaleMinsDynamicT[p])
		{ 
			dScaleI=dScaleMinsDynamicT[p];
		}
		dScaleI*=dGlobalScaling;
		Hatch hatch(sHatchPatternsDynamicT[p], dScaleI);
		hatch.setAngle(dAnglesDynamicT[p]);
		
		dp.color(nColorsDynamicT[p]);
		dp.transparency(nTransparencysDynamicT[p]);
//		dp.draw(ppsDynamicT[p], hatch);
		pp.shrink(U(1));
		pp.shrink(-U(1));
		pp.shrink(-U(1));
		pp.shrink(U(1));
		dp.draw(pp, hatch);
//		pp.transformBy(_ZW*2000);
//		pp.vis(6);
//		pp.transformBy(-_ZW*2000);
		if(bHasSolidColorsT[p])
		{ 
			dp.color(nSolidColorsT[p]);
			dp.transparency(_nSolidTransparencysT[p]);
			dp.draw(pp,_kDrawFilled,_nSolidTransparencysT[p]);
		}
//		dp.draw(pp);
	}//next p
	for (int m=0;m<mapContoursT.length();m++)
	{
	// 
		Map mm=mapContoursT.getMap(m);
		if(nColorContoursT[m]==10e5)
		{ 
			// HSB-21945
			continue;
		}
		Point3d ptCenThis=ptCensT[m];
		dp.color(nColorContoursT[m]);
		
		PlaneProfile ppSubtract;
		PlaneProfile ppSubtracts[0];
		for (int p1=0;p1<ppsDynamicT.length();p1++) 
		{ 
			if(p1==m)continue;
			Point3d ptp1=ptCensT[p1];
			if(_ZW.dotProduct(ptp1-ptCenThis)<10*dEps)
			{
				continue;
			}
			ppSubtract.unionWith(ppsDynamicT[p1]);
			ppSubtracts.append(ppsDynamicT[p1]);
		}//next pp
		for (int p1=0;p1<ppsStaticT.length();p1++) 
		{ 
			if(p1==m)continue;
			Point3d ptp1=ptCensT[p1];
			if(_ZW.dotProduct(ptp1-ptCenThis)<10*dEps)
			{
				continue;
			}
			ppSubtract.unionWith(ppsStaticT[p1]);
			ppSubtracts.append(ppsStaticT[p1]);
		}//next pp
		
		ppSubtract.shrink(U(1));
		ppSubtract.shrink(-U(1));
		ppSubtract.shrink(-U(1));
		ppSubtract.shrink(U(1));
		for (int p=0;p<mm.length();p++) 
		{ 
			PlaneProfile ppM=mm.getPlaneProfile("pp");
			if(ppM.area()<pow(dEps,2))continue;
			
			ppM.subtractProfile(ppSubtract);
			for (int p1=0;p1<ppSubtracts.length();p1++) 
			{ 
				ppM.subtractProfile(ppSubtracts[p1]);
			}//next p1
			
			dp.draw(ppM, _kDrawFilled);
			dp.draw(ppM);
		}//next p
	}
}


if(bInBlockSpace)
{ 
	// Draw ppPreviewShape
	Map mapHatchFound=mapHatchDefault;
	Map mapOrientations=mapHatchDefault.getMap("Orientation[]");
	Map mapOrientationFound=mapOrientations.getMap(0);
	{ 
		nSolidHatch=0;
		nSolidTransparency = 0;
		nSolidColor = 0;
		bHasSolidColor = 0;
		// default orientation hatch parameters
		sPattern = "ANSI31";// hatch pattern
		nColor = 1;// color index
		nTransparency = 0;// transparency
		dAngle = 0;// hatch angle
		dScale = 10.0;// hatch scale
		dScaleMin = 25;// dScaleMin
		bStatic = 0;// by default make dynamic
		// contour parameters
		bContour = 0;
		nColorContour = 0;
		dContourThickness = 0;
	}
	{ 
		String ss;
		Map m = mapHatchFound;
		ss = "SolidHatch"; if(m.hasInt(ss)) nSolidHatch = m.getInt(ss);
		ss = "SolidTransparency"; if(m.hasInt(ss)) nSolidTransparency = m.getInt(ss);
		ss = "SolidColor"; if(m.hasInt(ss)) nSolidColor = m.getInt(ss);
		ss = "SolidColor"; bHasSolidColor= m.hasInt(ss);
	}
	// properties in orientation map
	{ 
		String ss;
		Map m = mapOrientationFound;
		ss = "Pattern"; if(m.hasString(ss)) sPattern = m.getString(ss);
		ss = "Color"; if(m.hasInt(ss)) nColor = m.getInt(ss);
		ss = "Transparency"; if(m.hasInt(ss)) nTransparency = m.getInt(ss);
		ss = "Angle"; if(m.hasDouble(ss)) dAngle = m.getDouble(ss);
		ss = "Scale"; if(m.hasDouble(ss)) dScale = m.getDouble(ss);
		ss = "ScaleMin"; if(m.hasDouble(ss)) dScaleMin = m.getDouble(ss);
		ss = "Static"; if(m.hasInt(ss)) bStatic = m.getInt(ss);
	}
	// properties in contour map
	Map mapContour = mapHatchFound.getMap("Contour");
	{ 
		String ss;
		Map m = mapContour;
		ss = "Contour"; if(m.hasInt(ss)) bContour = m.getInt(ss);
		ss = "Color"; if(m.hasInt(ss)) nColorContour = m.getInt(ss);
		ss = "Thickness"; if(m.hasDouble(ss)) dContourThickness = m.getDouble(ss);
	}
	double dMin = U(10e7);
// calculate min width rotating 0-180 by 10 degrees
	Vector3d vecXrotI = vecX;
	Vector3d vecYrotI = vecY;
	PlaneProfile pp = ppPreviewShape;
	for (int irot=0;irot<17;irot++) 
	{ 
		LineSeg segI = pp.extentInDir(vecXrotI);
		double dXI=abs(vecXrotI.dotProduct(segI.ptStart()-segI.ptEnd()));
		if(dXI<dMin)dMin=dXI;
		vecXrotI=vecXrotI.rotateBy(U(10),vecZ);
	}//next irot
	double dScaleFac = dScale;
	if (dScaleFac < 0.01)dScaleFac = 1;
	double dScale0 = dScaleMin;
	if (bStatic)
	{
		// static, not adapted to the size, get the factor defined in dScale
		dScale0 = dScaleFac;
		if (dScale0 < dScaleMin)
		{ 
			dScale0 = dScaleMin;
		}
	}
	else
	{ 
		// dynamic, adapted to the minimum dimension
		// should not be smaller then dScaleMin
		dScale0=dScaleFac*(dMin/dScaleVP)/U(1000);
		if (dScale0 < dScaleMin)
		{ 
			dScale0 = dScaleMin;
		}
	}
	// multiply dScale0 with the global scaling factor
	dScale0 *= dGlobalScaling;
	if (nColor < 1)
	{ 
		// -2 by entity, -1 by layer, 0 by entity
		if (nColor == -2)
		{ 
			// get color from entity (beam) and use this for the hatch
			nColor = _ThisInst.color();
		}
		else if (nColor <- 2)
		{ 
			//nColor <- 2; -3,-4,-5 etc then take by entity
			nColor = - 2;
		}
	}
	if (nColorContour < 1)
	{ 
		// -2 by entity, -1 by layer, 0 by entity
		if (nColorContour == -2)
		{ 
			// get color from entity (beam) and use this for the hatch
			nColorContour = _ThisInst.color();
		}
		else if (nColorContour <- 2)
		{ 
			//nColor <- 2; -3,-4,-5 etc then take by entity
			nColorContour = - 2;
		}
	}
	if (nSolidColor < 1)
	{ 
		// -2 by entity, -1 by layer, 0 by entity
		if (nSolidColor == -2)
		{ 
			// get color from entity (beam) and use this for the hatch
			nSolidColor = _ThisInst.color();
		}
		else if (nSolidColor <- 2)
		{ 
			//nColor <- 2; -3,-4,-5 etc then take by entity
			nSolidColor = - 2;
		}
	}
	int nPattern = _HatchPatterns.findNoCase(sPattern, 0);
	sPattern = nPattern >- 1 ? _HatchPatterns[nPattern] : _HatchPatterns[0];
	// hatch object
	Hatch hatch(sPattern, dScale0);
	double dRotationTotal = dAngle;
	hatch.setAngle(dRotationTotal);
	dp.color(nColor);
	int _iTransparency=nTransparency;
	int _iSolidTransparency=nSolidTransparency;
	if(dGlobalTransparency<=0)
	{ 
		_iTransparency = 0;
		_iSolidTransparency = 0;
	}
	else if(dGlobalTransparency>0 && dGlobalTransparency<1)
	{ 
		_iTransparency = nTransparency * dGlobalTransparency;
		_iSolidTransparency=nSolidTransparency* dGlobalTransparency;
	}
	else if(dGlobalTransparency>1 && dGlobalTransparency<100)
	{ 
		_iTransparency = nTransparency+dGlobalTransparency*((100.0 - nTransparency) / 99.0);
		_iSolidTransparency = nSolidTransparency+dGlobalTransparency*((100.0 - nSolidTransparency) / 99.0);
	}
	else if(dGlobalTransparency>=100)
	{ 
		_iTransparency = 100;
		_iSolidTransparency = 100;
	}
	dp.transparency(_iTransparency);
	if(bStatic)
		dp.draw(pp, hatch);
	if (nSolidHatch)
	{ 
		if(bHasSolidColor)
			dp.color(nSolidColor);
		// plot the solid hatch with transparency
		dp.transparency(_iSolidTransparency);
		dp.draw(pp, _kDrawFilled, _iSolidTransparency);
	}
// contour
	if (bContour)
	{
		dp.transparency(0);
		PLine pls[] = pp.allRings();
		dp.color(nColorContour);
		for (int iPl = 0; iPl < pls.length(); iPl++)
		{
			PlaneProfile ppI(pp.coordSys());
			ppI.joinRing(pls[iPl], _kAdd);
			
			if (dContourThickness > 0)
			{
				ppI.shrink(-.5 * dContourThickness);
				PlaneProfile ppContour = ppI;
				ppI.shrink(dContourThickness);
				ppContour.subtractProfile(ppI);
				dp.draw(ppContour, _kDrawFilled);
			}
			else
			{
				dp.draw(ppI);
			}
		}//next iPl
	}
}
	
// no need of base point
//	_ThisInst.setAllowGripAtPt0(false);

































#End
#BeginThumbnail
MB5!.1PT*&@H````-24A$4@```9````$L"`(```!BU7*5````"7!(67,```[$
M```.Q`&5*PX;```@`$E$051XG.W=>9Q==7W_\??G\_V>>^],,ME#$@@D+`$D
M`80**()4"XK6I=6B]F>+MEJ7VM:J[4]K:Z5:N]BJM=6V=E'<6K5J77Y60$44
M5Y`E`0(A+(%DDLDDL\]DYM[S_7X^OS_N."1AEH!A.?;]_(/'P\P]RTV\K[GG
MG._Y'G%W$!%5@3[6.T!$=*@8+"*J#`:+B"J#P2*BRF"PB*@R&"PBJ@P&BX@J
M@\$BHLI@L(BH,A@L(JH,!HN(*H/!(J+*8+"(J#(8+"*J#`:+B"J#P2*BRF"P
MB*@R&"PBJ@P&BX@J@\$BHLI@L(BH,A@L(JH,!HN(*H/!(J+*8+"(J#(8+"*J
M#`:+B"J#P2*BRF"PB*@R&"PBJ@P&BX@J@\$BHLI@L(BH,A@L(JH,!HN(*H/!
M(J+*8+"(J#(8+"*J#`:+B"J#P2*BRF"PB*@R&"PBJ@P&BX@J@\$BHLI@L(BH
M,A@L(JH,!HN(*H/!(J+*8+"(J#(8+"*J#`:+B"J#P2*BRF"PB*@R&"PBJ@P&
MBX@J@\$BHLI@L(BH,A@L(JH,!HN(*H/!(J+*8+"(J#(8+"*J#`:+B"J#P2*B
MRF"PB*@R&"PBJ@P&BX@J@\$BHLI@L(BH,A@L(JH,!HN(*H/!(J+*8+"(J#(8
M+"*J#`:+B"J#P2*BRF"PB*@R&"PBJ@P&BX@J@\$BHLI@L(BH,A@L(JH,!HN(
M*H/!(J+*8+"(J#(8+"*J#`:+B"J#P2*BRF"PB*@R&"PBJ@P&BX@J@\$BHLI@
ML(BH,A@L(JH,!HN(*H/!(J+*8+"(J#(8+"*J#`:+B"J#P2*BRF"PB*@R&"PB
MJ@P&BX@J@\$BHLI@L(BH,A@L(JH,!HN(*H/!(J+*8+"(J#(8+"*J#`:+B"J#
MP2*BRF"PB*@R&"PBJ@P&BX@J@\$BHLI@L(BH,A@L(JH,!HN(*H/!(J+*8+"(
MJ#(8+"*J#`:+B"J#P2*BRF"PB*@R&"PBJ@P&BX@J@\$BHLI@L(BH,A@L(JH,
M!HN(*H/!(J+*8+"(J#(8+"*J#`:+B"J#P2*BRF"PB*@R&"PBJ@P&BX@J@\$B
MHLI@L(BH,A@L(JH,!HN(*H/!(J+*8+"(J#(8+"*J#`:+B"J#P2*BRF"PB*@R
M&"PBJ@P&BX@J@\$BHLI@L(BH,A@L(JH,!HN(*H/!(J+*8+"(J#(8+"*J#`:+
MB"J#P2*BRF"PB*@R&"PBJ@P&BX@J@\$BHLI@L(BH,A@L(JH,!HN(*H/!(J+*
M8+"(J#(8+"*J#`:+B"J#P2*BRF"PB*@R&"PBJ@P&BX@J@\$BHLI@L(BH,A@L
M(JH,!HN(*H/!(J+*8+"(J#(8+"*J#`:+B"J#P2*BRF"PB*@R&"PBJ@P&BX@J
M@\$BHLI@L(BH,A@L(JH,!HN(*H/!(J+*8+"(J#(8+"*J#`:+B"J#P2*BRF"P
MB*@R&"PBJ@P&BX@J@\$BHLI@L(BH,A@L(JH,!HN(*H/!(J+*8+"(J#(8+"*J
M#`:+B"J#P2*BRF"PB*@R&"PBJ@P&BX@J@\$BHLI@L(BH,A@L(JH,!HN(*H/!
M(J+*8+"(J#(8+"*J#`:+B"J#P2*BRF"PB*@R&"PBJ@P&BX@J@\$BHLI@L(BH
M,A@L(JH,!HN(*H/!(J+*8+"(J#(8+"*J#`:+B"J#P2*BRF"PB*@R&"PBJ@P&
MBX@J@\$BHLI@L(BH,A@L(JH,!HN(*H/!(J+*8+"(J#(8+"*J#`:+B"J#P2*B
MRF"PB*@R&"PBJ@P&BX@J@\$BHLI@L(BH,A@L(JH,!HN(*H/!(J+*8+"(J#(8
M+/J9M>6^[2_]H_<\UGLQHYMOW?;*=[__L=Z+QZF;;]XT[9\S6/2SZ>/_\ZW3
M7O2J:V^XX;'>D>F]_^-?.OOEK[YS:_=CO2./.T-#0]^X^NO;[Y_^;R8^RGM#
M]$C;UMWS6^_\FVM^N,FCUAY_OY)OOV?')7_PKMONO@5:F.7'>G<>7S9NO&7[
M?3O@,F9#T[Z`P:*?*1_YXE5O^KN_'QZ84(>6T%`\UGMT@`]^^BMO?_^'AR;V
M`0$N0>2QWJ/'D>[N[NW;MSO$S52F3Q.#18]'>;0/N^XO>[?FGJUYU9,6G/NL
M0UGJG7__T<L^^DFD[*%FV;SF.;4>Z5T]=!>_X4^O_.:W"\10*U(R@<(9K`.8
MF2!($+4P[0L8+'ILV,A`WG&G#>ZRP1UI>#`.[&P-[,%0?]F_TX=WY[%F$71"
M6@-[._:MONCL0PO6MV[>+*XJ;G#$`#/3QU$1OGW=)FBMU!Q3"7ZW>A#5&$)(
MI8F(^O3'\@P6/0;RZ,#@GUSDVS:+!`/$?4(]E8:0%4&TT*A9=+0O;KM;L?O:
M0UQM$*AKUB#9K)[1<K''41>R9A'W#`L!R.YNXH_U3CV.F%G.643=768(^N/N
ME"3];S#XSZ]-VVXQ%*65K=0T'\_)BQ"BAD*#HV66AL?LKKNB:-2A<O#[/SB4
MU9:.+*(IF[AD!PS3'U@\-L35/6L0,\ST@?S?+(0@"&8&0&?XEV.PZ-$V\OF_
M+K_W54<TY`):#U%"`Y"$#"DR'#F4+O=LA8A8RA[1_ZVK#F7-.4IP2+3@)JX*
MB-LC_78.G2'7$<T48HH"KLS6_LQ,U$7$Q42F3Q.#18^J?,U_[?O499Y-`B)0
M(AFTE5.,L1!5R]D35.^Z+>2FMGR\%@KW\N[/?/)05EYOCKDB6X1$@[L]KGH%
MN#9%HAJ0U`50@,%ZP&2^U0&H3G^VBL&B1]'.[NY_?XWE7`C4(4BB]4)"EW9,
MY)%F-L\6)-ZU)8RV-,&[L'C$]V2WYM[=@S?,?53HL9[3B")G6#"XBLWPB_HQ
M$:(`9?90TWFE#8J6'(=U,%=%**1FWISVYX^C?T[ZF=?_UY>$@5&(E$@`LM84
MP2QG48E!@^40[MY6'QBRD()FF;"Q:/40@IGMNN(KA[0-"5E:JIJ#`!8?;^,&
M1!QP-VB'9^CC;?<>4^[NR.Z.F:]%,%CT*!G\FY?8CLV%0%V#J`/P9$A9D)%#
M-D%M;Y_OW8WLYMG***8AQ`Z8B,C.+WSA4+8B#IBZN[KA<18$=P<@ZAD97I?0
MR/S\'<#:1X4IS_C%D\,:Z-$P^/$_+:_]LB%HJ*MG-W-UB"C<!<E:`3(XI-NV
M!8A$"7"/4$>&HQ`MU??U].RY[GO+SW[J'%O2&CQ'%Q=X>Q#!@09&1GO[![.I
M6>J:W[EFQ;*'\78VWGGOCMZ]P\.#X\WD&LS2XHX%"Q9U';ETT89U:^9<W-WA
MR<6#'K![>P=&>X?Z`!&1)5T+5BQ9^##V;7^#@X-C8V/M4+:OOC4:G:JZ;-F2
MV1<<&!@8&QN;F)A(*:64VLO&&(NBF#]_?D?'O$6+%OR4^_9@[FYFHB*`S_`=
MB\&B1USSIBO]B^]/D"+"30PJ0=PE0&%6^GC0^KY]'5OO$*AXAFOAL26>(4$=
M+:0H1:M,?=_XGSF#Y<BJ,<-@2;0A,0#8?,]]/[Y]Z_=NW/2-ZVZX=T>/N\`\
M!,F.^1T+7G#!&;_Q_.?^PKEGS/E&+O_RU9_[YG>O_NZUXZTLH7!D6!9W%U'`
M31!4`LX\^<1GG_?D\Y]TZD5G'[A.$Y@@`+`(9"NR&X#;[KK_,U^]^B-77M6]
MO5?<0BC,W(`CEBYXX;.>]J)GG'_A.7/OVY3AT9&=.W?NZNX9'Q]/*;4/J"TC
M1#$SN*JJ>1*15:M6/>E)9^Z_[)8M6W?NW#DT-"0B.>=:T7#WJ5%1(M(NE[LW
M.NMKUJPY^:1UA[A7>_?V[]FSI[>W=WAX>&HE`(JB6+QX\=*E2Y<O7SJU+9\I
M5\!L/R/ZZ:4=VX;?<G8Y.@(/$EQ<U<5A64P1'1-`E%7';\?)W5^\0EU5M82I
MNB*:P=VA2;UAFFI+ESUKX]99MO6,5[[IFNMO$TR(:U8+D(Q:K0BMB8E8:Z34
M$G$`;JHA6,X:Q%*K"%K"GO&4I_S'._]@Q1'3?^&Z^H:;?^.RO[U_1X_`W0+4
M(1:2.+(6DDJ)'K(;@KJ4:I`0LI4O?=9%__F>/YE:2?W<%[1&1U75D`%3A)/7
MK7W*^O7__H6O1D7*.7B118`D"O<DH1"'`F=LV/!O?_8'IQU_].Q_U2,C8YLW
M;^[9O5M$Q!5BYN[NB@`(%.Y97-&^'B=6J]6>]:R+]E_#%5=<U6PV536G]O`"
M4;%V1-K:N7#/C@@@!-FP8</:-;/MV.[=>S9OWCP\/.R`JKJ[`&[M\:'>'GBE
M`>Y>%$7.[7-8`O?G/_^Y#UX;CZ'ID37RGE\I]PT#)@++)<2R>G;`5-PDQ-QH
M+/R_'SOZM_[01!VY=$0-,,UN$LP1/`M4))6MWIZ]UW]_]LV)&F*118&8#8T`
MGY@(FLU,1**J`H"YNZB*2)1&@HCYM3_<^(Q7OV7:=?[KEZ]XSJO^<-?=/2$K
M+(@Z4BEE*2*6U4J'2@HF-0T0U<*@R!HE3GM@8\CP#'%'OOVN^S_Z^:\%;:32
M1%6B04I158\!#4\.(+O?<.OFBW[]S=^\\;99WOCV[=W?^<YW>G;U`IHA@%B&
MBA0Q_B0V$'6%MKLS]75I?]G,`3,+4;);"(JL@@!7N%J&F[@))(@H(&69;[GE
MEGONV3;37MU^^Y8?_>A'(Z.C00O=[PO:9$S%``DA9H-H;!][^D^^?$V+AX3T
M"!KXXXN;]]]2:(=[UEQ.J-2MECV52%`7U:`=*][S73WFE.7'8N4O/*/O6]>*
M2?MB?\Q%Z1,U;Y22F];2J+6L?5=>N>RL<V?;I`>8B^4@ZC5-N42H96]&53.X
MF9N(NUL+T;-8AW28!1%->73SO7>]XK+W7G[9F_=?W]=^N.D-[WIOTW.MANRM
MFLYOE2.A5EC6Y"8QF`A\7*73+!5:>$Y!D',I[@<5X2?=<(@7/B]KM@P)`FNB
M"$#(:4QTGGO**`%`U`P!FO/$T+Z1Y_[.FZ_\QP\\[8DG/?A-WW???3?=O$D1
M1$14'2X&$5FPH&OITJ4=C7DA!$=.5J9Q'V^.CXWO&QSLGZSW@42DLZ-CT:)%
M2Y<MJ]4:C2+&&%W,S)K-<G1T=/>>GKZ^OGKL:+9:,48SN_766Q<N7+ATZ>*#
M5G7==3_>O7LWV@74`%=!=O>%"Q9T='1(P.B^?6G<6JU6"#'G%!2J.MFJ&9K%
M8-$C9>@_+[/;KHT:O$Q9"ZNA$YT#TEO76BQKZF6)8MEE7])C3FF_?NUK?GOO
MMZXU-1A@(6M91WU?T1]RO28USY[A>Z^]\B3\V4Q;K$G#T`]O0$-2:*I!HDL2
MKR<,UJR643?10JV$BQ5%JH^'(0G1%2%W9N2/?>'*-[WLDM/6'3.USG=_^./-
M"8-F\Z)#YH^7_=".7+8*[2AAL:C%0M":-YYWP>>U/+>/GPIX*58_\/X2!UP,
MT!H6M#"@92,B9'6#P)**:5A8RA[%0D=6J[FI:2E(]=J"9KD78XW?^?/W;?K<
MAP]ZUWU]?3??="M<I0@YYY"D,S96G[3\E)/7/]1_LC//.&/5JA6SO^;$$T\8
MZ1_]]HW?1`*LKE!`[KSSSJ<\Y9S]7[9ER];=/7M<5(!:#!/ER/*E1YQXXHDK
M5DRS_IZ>GIT[=^[8L7/R\-/;1\W38+#H$3%RXU>:G_O;[,U@48HHGA5:^KX`
M!-,@:+H=\=9/Z/KSIQ99<=Y%\TX\;O3V>QPMA8H&=]/<$4(P*X,@B_?=>L?H
MMBWSUT[S+0-`AD%K2`H'1$43+!EBM&AEYU/./>N29YQ[U,H5]2+V[M[S]Y_\
MXJ:[MD$:<!-WLP05$7SU.]_?/U@_OOD6\P2#J^6<@'IG9^=[WO#:IYV]_M3C
MCYMZV>#X8$_?Z+W=W??>L_/J&V[]\K>^%UIE2]*T^^GND.`:,I*;26B<=-R:
M9YW[I&.6K^Q8(/O&RNMOW?J9*ZX!RD)#1I24H0U`-V_=\LFO7/5KSWOF_FN[
M^>:;0PAE65I*(6!>1^,9%U[P\/[5YJQ56]>2^4\^Z]SO?^<Z@0@\>^[M[3GH
M-??<O0UB@#IRSEB_?OU)ZTZ>:84K5ZY<N7+E$4>LO.&&&T0DY:PSW`3*8-$C
M8.NFL0^\&BTOM&8>W)*(N+HG;:`.BRVQ)9?^53S[!0<M=]+OO>7'KW^E0K.E
M*%9F#4%S\A!JD"1FT7'_)SY^RMO?/>UFVS,A1-0@4+,,,PT!=NFO7/3[O_JB
M4T\XX-SPRW_YXM?_Q8?_Z=-?@)@G=['@P3U_Z9KO_=$K7]I^S0\VW=%,)8("
MR*(N68J.;_W;>\[></"7ET4=BQ:M7G3RZM4X![_]J[\,X*IKK]LY.'#@[CG:
MU]I@L$(#%LU?^([7_N8O_L+9QZT\N!1_];J7O^1M[[[NULTB7HH#444S\N5?
M/B!8NWIZ]XVUS$Q5(19C/.N<,_'(6[9P^>K5Q^RX?P?</)@#_?W]2Y9,CI:X
M]]Y[R[*$N(JXR$DGK3MQW0ESKE-$'!"1$&<\C<63[G28E4,#N][_8A\8%C5H
MX5JB/7-(:0C97,SRHDO>U'C1FQZ\[*I?>E%]?I=[$!'S:*+M4\7FR5(9K&8:
M=G_C:S-MVN`Q-))X5LMJV:41BH_]Q=O__>V_?U"MVC[TMM<<L7PA-+@$J)A`
M16[<O&7J!7V#(Q`7!%&%!`O^A+5'/;A6TWKF^6>_XGD'3^,E#L`<)@$Y^X;C
M5__NRY[WX%H!6+OFR"^\_]VU>D?(=0EUU4)A$O3:FV[9_V7;MW>[0T1%-&AQ
M\LFG='5U'<KN_?06+5HD`E'U#(7D_49[=G?O"E'<)%O9U=5UXHESUPJ`B*C(
MY(7"&3!8=)B-O?=7==>V&"`BL#*+JAM<RV9M[]ZP>W=MZ)B+.U[VKID67_'"
M%[JZ6H!KH>)0<0LY0X.%;"A'MMPU?.OF:9=U]U1Z%*@CNT?1Y4NZ7O;LV8Z/
MGG3&*>X.E?9X>@?,,#@P.KE";8\_"N*`N3AV]_7]%'\W4_N9`85Z<]9!14<=
ML>@YYYT#%3&!F+M[RJTR;;KKGJG7[-G=VQYQ*0*!'7OLW,-6#Q>5;/#LKA)%
MPO[!&N@?,K,0@JJN7+GR(:UV]ADL&"PZG%I?>E_SUFLMZ[YQ&1X,W7N*;7?7
M-FYN7'=][<9-=O?6L+.[%BXX^$AP?^M>_\:@FA7PTEP$)A)$HWDAG@!$T>[/
M73[MLNY>B`K@[A(TP5*8X__A7?6H$+B'4!@<`"Q-M"8G5EZZJ`,`8(#"LY@,
M#P__YCL?_K.Y)@=5B+D)LH899BZ?\JPGGY.1'+!<AA!BJ,&QK;MWZ@792E$/
M41QYZHCL\!H:'NT;Z!\8&AP>'MW_S\T,L!BCN(CK5$P&!X<=V3+:_UVX\"%\
MXVL/MGCP_0E3>`Z+#J<?O.W=K68LFXV<<_"4@WA602NXN[BJ-I8L/.'%+Y]E
M#9VKUY[\W#.'-]X8DF5)WH*KFZ=LZIZC!ZMKL?>>:9<UL?;-@QK@Y@:=<S:$
M8`'9BA`L&\01@IF5/[FV?NZ&]4':WVU<Q`VNJ?C8YZ_\U)>O.&[ERJ*A;B$X
M$J"06JU8N6SIAA-7_=KSGKWAN&-GVJ*[`QY4#69SW>OXU#.?``">!:',#F15
MW;6WO_W3WMZ]BF">LYFJ+EEV\,""AV=G=V]W=_?@4/^^B3'-!12N":XP`>!B
M)M95[X*VAZ:;"T0]A,GW,C$QT1XC"AC$5JU:=8C;;1\)JBK4,<.\0`P6'4YC
M_1F0%$8;TM7TTK-`FA`1+T(N$L967/3+<Z[$1H=J/BZ%BN:ZUK-F<<UP($+*
MN.R((R_[VVD7=,]1ZJ6-F1I"\%:JSS4A5BW.BR%8!L0T!'/W(*8/+'7J$T[:
M=-M=+AD0!)=0LS31*G7+SMV>2JC#,Q!KJ+704HE7?+?\N\L_?^$%3_GP6]]X
MU,JE![\U3$Z!Y5ZX[YOSK^*HI4O=!=**.L_@`G=@='QRP;)LP@4(,6I*K:*H
MS[G"V?7U]=URRVU#@R/M4_@``D)&AJN9J481*7-RI-RTIC55U;,97.%3AX1E
M6;J+(04I5!_"A&2J*B+F;CG/]-V3AX1T..GRI<E"\,:0#[A8+7AP`:1I233-
MP\+&17-?P_*1456%^T)?,!I&LP`J5E-1DSAO[9]_IG/9VFD7[(A=31_+GCPK
M3"#!IAL;N;]Q-%NPK.91)W_#6RS2`Q?5W_AK+T!,(B(6(CK+<J](;G^P)"@`
ME49=.ULR+'!8RTU:%KYVS8_._?7?O7M'[_[;*F*4$,5BR'5#/Q!TKCG=ERR>
M#TE%G)=LT"5G;\'+\=;D4C6OC]I@UA*>523&G^KCW->WY_H?W3@T-"0!KLE-
M:C)O.`\D;[;O$P"04HH>.\/"X=QGR.)!113B+E-3[I6YI:JB,>?L#VVZ##-+
M`C3"O)E>P6]8=#@M.>/,GJ]?45@L/$"]=&@,2#D(W+UK>1K]X!_=_:5_ZERV
MMEAY=''\2?4UZQLG_]S!:VF.Y"11Z^.^KZ9%(469)F)31.+RU[V]MN&LF;9N
M,QU(_!0N?>[%5_YHXW_\]U=<ZU%*H"ZND_-(""#!74H8O-$>\FB61=6!^_?V
MO.P/W_G#__S@U*I2SF8&.()`%"YS3I&\:V`H0#R5"#7/9=`B6YY?F_QIRSQZ
MD/8]>:XY_U3W!5]__4W-5BD2S5M!"@G(N5R\8.'\^0OJ1</=LUE*:6)?<V*B
M&47CY'&TF)G(`R?+%>+9)+0G@'[(N^0/ND-@?PP6'4[+SCYWU]>O2@B*J%X3
M\5R6(JC59<6*W*A9V3_:[.O=IS\*"(*8HNWN7[#\:<]9<<E+5UYP87LE$T,#
M,5@*^PH4\)#%ZZB5FA<^YZ5+_L_OS[+U64[6_C0^]:ZWG+;FN`]\\K,]`WT0
ML7:JH&X&`>!`%KB;N83@00Q9M$"X[K:[O[?ICJ>>-CE@TLS@&1+<2T#E$#[,
MVW9V!XDM&$SAJ?T]LZNSL_W3HE&/6K2?U^#NS>;TLW0>BHVW;"I;N1T=A:CX
MNG7K3CSQQ%D6N?WV+7??=6_[&JO(`R.GVA<'X3#WAQ$L$9GQ#!:#18?7O)/7
MBTG24B6ZEX(H(HL6R9)E+I[@$M7%55`DSQ&I:(760-[VWY_N_OSG.H]9<\)O
M_\[2"RZH*<ILA<U+&!<MD%JE:#SM[%5O^Y?9M_[(33WREE==\I9777+Y5Z[Z
M]HV;!@:&AH='4W;3X)Y=3>$[=P_?=_\N\8PH&7!+.;B(?>7J[TX%"P`<$M12
M"95#V>&-F[>V+$LLQ-R#FQNLM7S)Y)0214U%@KNWO^",CH[.OK99].[>:YYB
MJ)=I(F@X\\PGKEIUU.R+-!J-G[P%VW\*]GJ]/OGD&U5S&Q@86+SXD*X&N+M(
M.[XSOH;!HL.IOFZ=6BFB[:&8&FWE$=)9:ZD)-!A,)``BT.B6S<<G%*E4!-,\
MT7W?QC]^<V-Q?=5"DQ`E37B,:BZB6+EB[3L_->?6'^FYDE[QO&>^XL#;8O;W
MMG_^Q%_^TR<D"\2#!LVE06_>\L`%S<F)I=P5,"D<-N?N?N>F.U3AUI[C01P9
MT../6=W^Z>)%\S4$=\^65+6_O_]AO[7Q??M$)%E6U46+%LU9J[;LID&#._8[
MCFLT&AK:]SM!$$9&Q@XQ6,#D$PE]AAL)P9/N='@M.N;86E=70@>0YLWSHU:7
M]7JK/15)SBVX!`DF^I-9_&QP.#M*500+K90@ZJ,M<0&0(]1R].Q!U[[KOXIE
M<U\=?X0."0_17[SVUU<O6R1J07)VE!(,>O_.75,O4%5ICP10EQF>;'R0;W[_
M!EAR-Q&!BZK6:K7UQSU0DZZNKO:'7%6;S>;#:];@X&#[*@*0(6'^_/F'N*"(
MN.>I";/:?[A@P8*I&6Q$'EI&?[*2&0\)&2PZS&K'K9,PONK(^A%'I$(]M*\N
MN4%J9N;NT<7=X6*Q,[6*Y(4CMKP]@935:A$B`2$[()(=*]_RP<83#NG^N#SS
M;^9'Q[(ER\TE.50AJL$MYP,^>U/_0V3.*X1XY[]\LF_O@(F*YF`J(<#DO"=N
MV/\UQZXYOEWI]F126[;,-L'AC-0M3\Y^,\L)[X/DG-LWT[3M/UG-RI4K)^\?
M`';MVC7S.@X@(NWY6&>YM,A@T6&V[.S3CEM==C5:T4/[%Z:Y:Q!(*05"KKE+
M,"V]-;[/4H)*3MIJ.-RE+(/6LAG,2W5,R,2RE_[NXN=<>HB;MH=^BG=.?6,3
M;WS?O]TZ\QQU4^[:L>N.^[9I,&CAUH)GR[K_L,GDUOY4>_O$MD)GODKX=Q_[
MS#O^\7*/4(N.%%!XSF9X\7-^?O^7K5E[9!$*10BJ(M+7U[=]^_:'^AX7+5BL
M&D3:CZ3VT9&Y!X@!*%O9LP$0AYGM_^2(%2M6M-^IP5ME><--/SZD_7`%KQ+2
MHVS#NS_4?/:+MO[SZ_S^>Y$:H3UJR8,;`CJ&TU`]-@*\)K7^417))MJ)^F#<
MU[`ZQ&M9@\*``"Q_XB\N^[V_.O1-SY/Y+BV$"$A[6/:<"9O((U#W!$TF09'-
MQ#O"`R,P<RO_P^6?_N!'_VOM,4==</KI1YVP\/Q3SSQ][;'+EQ]PQ\FGOO'_
MWO;>3U@S!P\F!@V>I8CQS-,?N.DZNEI&<)'02-X/K5^W<=,9+W[=Z2>=L';5
M$<<=>>2"CGE[T7?/7;NN^,[U-VVY&R8N+C'697[3>Z-VK3ERQ6M>^+R#WL(Q
MQZ_:=L]VRQ)KM5:KN?'FV^JU^4>L>&BCWG,81XI!"G<?'![8V[]GV9+EL[S^
MNS_^=M^N`4$-[??KMG]ZCS[ZJ$T;;VVE,L9HIKMW#MRU<,L)QTT_*=`41W9D
MN-:U<SP-3_L:!HL.O_IYS]APWI8]5WUF[+,?&KWCQ^XF\,+AGCN*NF@05\'$
M>%.!++!FRG5$>!DDA(9D02%1CUVW^A^^])"V:\$4=628`"K!$.=ZD%9#.B0[
M1$T%\"`BXJ.6IS[N$>YH>2CNO6_[O3MWYC06XB?%`F+L[.P(JF9I?'R\E4;$
M:VJ2X9`H'EU:2?Q%3W]@PB]Q@WJ67)A".Y&EY7+S'7=NNO-.4<^EB=8<356U
MK!IJKN:6Q,MFSI".$#L_\,=O>+<\I)H```83241!5/!;.'7]:7M[!T:&Q\S*
MH@AEF:Z[[KH5JY:?</SQBQ?/]MR=/7OV+%\^6:65*X_<W;W'W=N/J/CA#Z\[
M=?V&-6L.N)5Z:&AD>'AX=\^>/7OVC+1&.F+#VP^%$'/D@TX\'7O<FGONO3>E
M4B3F[)LWWSD^EDX]=;:)+H:'A]T=D.PVTP@U!HL>*<N?^9+ESWS)V#5?W'GY
M7S:W;"I517)[='=V2TF]S")BXBJB,)$:<C+SX)YKQ3%_^HF'NL4DV21K$5$F
M;Y^CKA=S+./J`H4$#\E3$HBCD`<^>[E]QCMG-4GFT)H9W$UR&AL=]52JJ@D4
M\Q26U54+%4E6"L)3SCC]J>M/FUJ5!3>TCWK:]U,+W$6RN2&+AN@.:&A?.[3<
M4@7:#SQS#ZA?]OI7_.)YTP^:??K3+[CRRBO'FQ,`1*+!>W;MVMG=7:_7%R]>
MW-G9612%F7G&>&N\U6P.#0WEG&/4BR^^N+V&4TXZI7_W]RS#++MX3KCYYDV;
M-FZNU6.M%E.)\?%Q%Q,)EB5$B5HW@\#;S]?1>'!?3CGEY+Z!O?U]@PJ(2"[E
MWGONN_^^'<N7+U^Z;'&]7KB[)4]6CHV-[=G3-S$Q4293#0X7%;7I9_!CL.B1
M->_G?VG=S__2GL^^;_RS'QGLN5L](&<1&=K7/FDK:K7D^Z(VD*$BHBV3VM'O
M^%CC^%,>ZK8\(^38'N_='G2>6^7LBP@,YBZ>%>V'M;B@E`.7TEJ`*G+T,K6?
M'&-9-.94:@@)I8B(A%RFH$7*&2&)Z/%''OGQO_R_!^R>"6`0("180(9H$*A;
M"1&(`H@9[8&864H#Q&H"T4+?^7NO?NLK9KL-\ZRSSKKQQAOW[=O7/J7DT*"Q
MU4P[NWM"G'Q(5UF6L2C@KJHII1@;4XLOF-^U?OT3;KGEMA`EFYA!-92MTMW'
MQ\=5HKN+!D#:<X$6*HL6+AP?'V\VFT$+2_;@$^+G/_6\:[_WW<&^$;/4?EY.
MSKFGIZ=W3X]/WC<M[2?JAA!2:1HFG^@S=2?0@_&D.ST:EK_X3<=\[M:C7_V.
MN&@IS,RL57:Z>\[B*!6J2"BR:2AJ8>FE;^YZVC2/>)I3*6+:4K1OCHGPF.<Z
MA^6((L%1FI6>39``N#WPN0@1141&;GF90A:/@"(&L]1^_HRX>O;"I0BU)!(%
M:O'YYSWY1Y_ZQX-FYG-K(2-*T;Z1.,38GH<BJ`81LP2DA.#NR9.Z!JN)ZCFG
MGW#-O[[W;;/6"L"2)4LNO/#"M6O7UFHU1PX1YB7$:O7H)G"U+#'4%4$04IHL
MR/YK6+-FS<_]W!DQ*B9SXK5:S06BT042(`[/&9[F=W:>?MJ&\\]_ZBFGG`S`
MVF/EIANH<?Y3SUM]])&B!K')NZE#F'STCFO[D1,IYY1S]C0UZ9@"M5KMP6L#
MOV'1HVGQI6]=?.E;^[_TD=X/O6/XWJ$0ZT`K('@JX)*L51=?]+Q+5_S6G\R]
MKNDTK`R0I%`)GLTB9*[9`D1+SPX)$M6S00IDV_\*_9(%7:WKO_Z-']SP_8UW
M7'W]QAMNWSH^/I8]BPA$LCE$@-#,%J)O6'?\BYY^_LLNOG#=VB,?O*U\W94W
M;MFZ;<>N;3U[MG7OON?^[=M[^K;W[!T8&04`*=V3AIID6;5\V3FGGW+A64]\
M]GEG'W?TH4[/`N"TTTX[[;33=NS8N;>W;V=/=WOV3E'_R0@P$RE2;FD(\^?-
M>_#$+ZM6K5JU:E5O[][>WM[>WMZQL3&S'$*A"@VR>.&25:M6+5VZ>&I2T]6K
M5_?T].[NV9-S%IW^=\,99YQ^QAFG;[G]CAT[N\?&QK,9@/:(=A%Q\_:C7NOU
M^H*NKL6+%W=U=2U<N'"F)TOS0:KTV&CV[S5W>&X_'4L`%]-6CJM6/^QU[AUL
M-EMC:F80"]",6"M6+)GMH>K]0Q/CS8D8D')6J&O.KD<OGVTFO-[^H=U]?0/#
M8R/C$ZV4:C%V%/&(18N..7+E@JZ.A[WS>_8.Y9Q1CRL/ZU/@!P8&<I[\QB2J
M,839S\0_TH:&AEJM5OL^;8T2M2B*<.C3.C-81%09/(=%1)7!8!%193!81%09
;#!815<;_![_:$K#EXM1B`````$E%3D2N0F""



























































































#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="Resource[]">
    <lst nm="IMAGE[]">
      <lst nm="HSBCAD">
        <str nm="DESCRIPTION" vl="" />
        <str nm="ENCODING" vl="M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&amp;!@&lt;&amp;!0@'!P&lt;)&quot;0@*#!0-#`L+&#xD;&#xA;M#!D2$P\4'1H?'AT:'!P@)&quot;XG(&quot;(L(QP&lt;*#&lt;I+#`Q-#0T'R&lt;Y/3@R/&quot;XS-#+_&#xD;&#xA;MVP!#`0D)&quot;0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R&#xD;&#xA;M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1&quot;`&quot;/`KP#`2(``A$!`Q$!_\0`&#xD;&#xA;M'P```04!`0$!`0$```````````$&quot;`P0%!@&lt;(&quot;0H+_\0`M1```@$#`P($`P4%&#xD;&#xA;M!`0```%]`0(#``01!1(A,4$&amp;$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*&#xD;&#xA;M%A&lt;8&amp;1HE)B&lt;H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&amp;EJ&lt;W1U&#xD;&#xA;M=G=X&gt;7J#A(6&amp;AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&amp;&#xD;&#xA;MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ&gt;KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!&#xD;&#xA;M`0$!`0````````$&quot;`P0%!@&lt;(&quot;0H+_\0`M1$``@$&quot;!`0#!`&lt;%!`0``0)W``$&quot;&#xD;&#xA;M`Q$$!2$Q!A)!40=A&lt;1,B,H$(%$*1H;'!&quot;2,S4O`58G+1&quot;A8D-.$E\1&lt;8&amp;1HF&#xD;&#xA;M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&amp;5F9VAI:G-T=79W&gt;'EZ@H.$&#xD;&#xA;MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q&lt;;'R,G*TM/4&#xD;&#xA;MU=;7V-G:XN/DY&gt;;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#W^BBB@`HH&#xD;&#xA;MHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@!**@FFBMX'FFD2.&#xD;&#xA;M-!EF=L`#U)KQKQK\90HDT[PPV6R5&gt;^8&lt;#_&lt;!_F?_`*]5&amp;+D]&quot;)SC!79Z!XE\&#xD;&#xA;M&gt;:1X6,=O&lt;RB6^E($=K&amp;?F.3@$_W1]:ZOWKXTM[F&gt;\UJ&amp;XN97EFDG5G=V)+'&lt;&#xD;&#xA;M.IK[+'2JJ04+$4JCFV.HHHK,V&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BB&#xD;&#xA;MB@`HHHH`2BJE_?VFF6&lt;EW&gt;W$&lt;%O&amp;-SR2-@`5X9XW^,=SJ(DT_P`-E[:U.0]T&#xD;&#xA;M1B20?[/]T?K]*J,'+8B=2,%J&gt;IZEXZT?3_$%GH*R_:-1N9EB,41_U6&gt;['M].&#xD;&#xA;MM=77R3X$=G^(&amp;BN[%F:[4DDY).:^MNU54@HV1%*HYIMBT445F;!1110`4444&#xD;&#xA;M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`&#xD;&#xA;M4444`%%%%`!1110`4444`%9USJ=O;W45MNWS2.J;0?NY/4UCZKXB=BT%GE!T&#xD;&#xA;M,AZGZ5C:&lt;2VK6I8DDS)DGZB@#T*BBB@`HHHH`****`&quot;BBB@`HHHH`***0D`9&#xD;&#xA;M-`$,DJ0H7D=44=2QP*H2^(-*A_UE];KC_IH*\X\9&gt;)3JER;*U;_18FY8'[[&gt;&#xD;&#xA;MOTKDZ\&gt;OF?)-Q@KVZGOX7)'5IJ=25F^A[-+XST&amp;$?-&gt;AO]Q&amp;;^0K/G^(VCQ?&#xD;&#xA;M&lt;6YF_P!Q`/YD5Y317++-:SV21W1R*BMVW\_^`&gt;D2?$RW`_=6$K?[S@?XU3F^&#xD;&#xA;M)5Q_RRT^,&gt;[.37!UE:G?8S;Q'_?8?RJ8XW$5)64OP1NLIPL?L_BSUWP=XZ?Q&#xD;&#xA;M'J]S8SQQ(T:!XS'GYL'#=3[C]:[W'&gt;OF[P5J0TKQ9I]PS;8VD\J0_P&quot;RW']:&#xD;&#xA;M^DAR*]O#3&lt;H6;NT?.YIAHT*RY%9-#Z***Z3S0HHHH`^;/BUXHU:\\5WVB/&lt;E&#xD;&#xA;M+&amp;T&lt;*D,?`;*@Y;U/-&gt;;5U_Q0_P&quot;2DZU_UU7_`-`6N0KN@K11YM1MR=RSIW_(&#xD;&#xA;M2M?^NR?S%?:(Z&quot;OB[3O^0E:_]=D_F*^T1]T5A7Z&amp;^&amp;ZCJ***P.L****`&quot;BBB&#xD;&#xA;M@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBCM0!\J?$+Q+JVM^*+ZVO;IFMK6=XX&#xD;&#xA;M8%X10&quot;1G'&lt;^YKCJV_%G_`&quot;.&amp;L?\`7Y+_`.A&amp;L2NZ*LCS)-N3N='X`_Y'W1/^&#xD;&#xA;MOM/YU]&lt;=Z^1_`'_(^Z)_U]I_.OKCO6%?='5AOA8M%%%8'2%%%%`!1110`444&#xD;&#xA;M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110&#xD;&#xA;M`4444`%%%%`!1110!YM&lt;?\?#_6IM,_Y&quot;EI_UV3^8J&amp;X_X^'^M3:9_P`A2T_Z&#xD;&#xA;M[)_,4Q'H=%%%(84444`%%%%`!1110`4444`1$XQQ7G_C;Q-L1M+LW^9AB9P?&#xD;&#xA;MNCT^OK6QXL\2IHUH886!NY@1&amp;/[@_O'^E&gt;2R2/+(TDC%G8Y9B&gt;2:\C,,9RKV&#xD;&#xA;M&lt;-^I[V49=[1^VJ+1;&gt;8VBBBO&quot;/JPHHJK?7@M8N,&amp;1ONC^M.,7)V0F[$.HWWD&#xD;&#xA;M+Y49_&gt;'J?[HK#I69G8LQ)8\DFDKTZ5-4XV1FW&lt;`&lt;'-?2_A/5/[8\,V%VS;I'&#xD;&#xA;MB`D/^T.#^HKYHKUSX/ZH9(+S29&amp;YB831_0\,/S`_,UW86=IV[GB9S1YZ7.OL&#xD;&#xA;MGK-%%%&gt;D?+!1110!\I?%#_DI.M?]=5_]`6N0KK_BA_R4G6O^NJ_^@+7(5W1^&#xD;&#xA;M%'F3^)EG3O\`D)6O_79/YBOM$?=%?%VG?\A*U_Z[)_,5]HCH*PK]#HPW4=11&#xD;&#xA;M16!UA1110`4444`%%%%`!1110`4444`%%%%`!1110`4=J*.U`'Q[XN_Y'#6/&#xD;&#xA;M^OR7_P!&quot;-8M;7B[_`)'#6/\`K\E_]&quot;-8M=ZV/+ENSH_`'_(^Z)_U]I_.OKCO&#xD;&#xA;M7R/X`_Y'W1/^OM/YU]&lt;=ZYZ^Z.O#?&quot;Q:***P.D****`&quot;BBB@`HHHH`****`&quot;&#xD;&#xA;MBBB@`HHHH`****`&quot;BBB@`HHHH`***3(]:`%HHHH`****`&quot;BBB@`HHHH`****&#xD;&#xA;M`&quot;BBB@`HHHH`\VN/^/A_K4VF?\A2T_Z[)_,5#&lt;?\?#_6IM,_Y&quot;EI_P!=D_F*&#xD;&#xA;M8CT.BBBD,****`&quot;BBB@`HHHH`965KNM0:'IS7,I!;HB=W;TJY&gt;W&lt;5A:274SA&#xD;&#xA;M(8UW,QKQK7];GUO46F&lt;E84.(H_[J_P&quot;-&lt;6-Q2H0LOB&gt;QZ66X!XJI=_&quot;M_P#(&#xD;&#xA;MH7]]/J%W)=7+EW&lt;Y/H/8&gt;U5J**^8DW)W9]K3@H1Y5L%%%7M*TNYU&gt;^2UMD)9&#xD;&#xA;MN6;L@[DTXQ&lt;G9;A4G&amp;$7*3LD4VBG^Q7%U%`\D=NNZ0J.%&amp;&lt;&lt;URLTKSRM(YRQ&#xD;&#xA;MKZ3L?#=C9Z')I83?',A64GJY(P37SQK&gt;ERZ+K-UITW+02%0V/O#L?Q%&gt;NL&amp;Z&#xD;&#xA;M,4WNSR\)F,,5.45I;;S1GT444'H!72^!=6_LCQ992LVV*5O(D/;#&lt;9_`X-&lt;U&#xD;&#xA;M2JQ5@PZ@Y%5&quot;3BTT88BFJE)P?4^L1TS2\8K%\,:K_;'ARRO&lt;Y:2(;S_M#AOU&#xD;&#xA;M!K9KV4[JZ/A9Q&lt;9.+W0^BBBF2?*7Q0_Y*3K7_75?_0%KD*Z_XH?\E)UK_KJO&#xD;&#xA;M_H&quot;UR%=T?A1YD_B9/92+%?6\CG&quot;K(I)]`#7T/J7QJ\+V2D6K7=\_811;5_-L&#xD;&#xA;M?R-?.-%*4%+&lt;&lt;*DH;'L.H_'O49&quot;1IVD6\*]C-(7/Z8KG+GXQ&gt;-)R=FH0P`]H&#xD;&#xA;MK9/_`&amp;8&amp;N!HH5.*Z`ZLWU.WC^+7C&gt;-L_VR6]FMXC_P&quot;RUN:;\&lt;_$5LZB_MK.&#xD;&#xA;M\3OA#&amp;WYCC]*\LHH&lt;(OH&quot;JS74^I/&quot;GQ*T+Q65MXI&amp;M+\_P#+M.0&quot;Q_V3T;^?&#xD;&#xA;MM7;U\4Q2R)*LL3LDB$,K*&lt;$$=Q7TC\*_&amp;Y\4:2]G?R!M4LP-Y/65.@?Z]C^'&#xD;&#xA;MK6%2ERZHZ:-;F?++&lt;]&amp;HHJ&quot;69((7ED&lt;*B*69CT`'4UB=(RZNH+*UDN+J9(88&#xD;&#xA;MQN=W;`4&gt;YKR[Q'\&lt;-,L)&amp;M]%M&amp;OY%X,\AV1Y]NY_2O-_B%X]N_%VIR002/'I&#xD;&#xA;M,+XAA!^_C^-O4GMZ5P]=$**WD&lt;E2N[VB&gt;@ZA\9?&amp;%X6$%U!9H&gt;T,&quot;D_FV:YZ&#xD;&#xA;MX\=&gt;++HDR&gt;(=2&amp;&gt;R7#(/R7%&lt;]16RC%=#G&lt;Y/=FR/%GB0'(\0:KG_`*_)/\:N&#xD;&#xA;MVWC_`,76I!C\0WYQ_P`])3(/_'LUS-%'*@YI=ST6R^,_B^U8&gt;?/;7:CKYL&quot;@&#xD;&#xA;M_FN*ZS2OCY&quot;S*FKZ.Z*&gt;LEJ^['_`6Q_.O#J*3IQ?0I5IKJ?9&amp;B:Q9Z]I%OJ=&#xD;&#xA;M@[/:W`)0LI4\$@\'W!K3KB_A5_R371_]R3_T8U=I7&amp;U9V.^+O%,^/O%W_(X:&#xD;&#xA;MQ_U^2_\`H1K%%;7B[_D&lt;-8_Z_)?_`$(UBUW+8\V6[.C\&quot;$+X\T5F(`%TA)/:&#xD;&#xA;MO;_$_P`8=`T-FM[(MJ=VO!$)Q&amp;I]W_PS7S;14RIJ3NRH57!61Z;J/QN\47+'&#xD;&#xA;M[&amp;EG9IVVQ;R/Q;C]*QV^+'C=GW?VVP]A;Q8_]!KBJ*?)'L#J3?4]&quot;M?C-XRM&#xD;&#xA;MV!EN[:Y`ZB6W4?\`H.*Z_0OCM!).D&gt;N:&lt;85/!GMCN`]RIYQ]#^%&gt;'44G3B^@&#xD;&#xA;MU6FNI]D:3K.GZW9+&gt;:;=Q7,#?Q1G.#Z$=0?8UIU\@&gt;%_%&amp;I^$]46]TZ8@$@2&#xD;&#xA;MPD_)*OH1_7M7U+X:\167B?0X-4LVRD@PZ'K&amp;XZJ?&lt;5S5*;B==*JIZ=3;HHHK&#xD;&#xA;M,V&quot;HIIXK&gt;,R2NJ*.Y-5]1U&quot;+3[&lt;R2&lt;L&gt;$7U-&lt;3&gt;W\]]-YDSD^B]A0!T5WXIA&#xD;&#xA;MC)6VB,A'\3&lt;&quot;LN7Q)J$F=CI&amp;/]E1_6L&gt;I8;:&gt;Y;;#$[G_9&amp;:8BP^KW[];N4?&#xD;&#xA;M1R*C_M&amp;]S_Q^3_\`?PU;3P_J+C/D;?9F`IW_``C&gt;I?\`/-/^^Q0!736-03I=&#xD;&#xA;M2G_&gt;;/\`.K4?B344QN=)/]Y1_2HV\/:BH_U.?HPJO+I=]&quot;,O:R@&gt;H7(H`[+2&#xD;&#xA;MKQ[^Q6=U&quot;L21@5?K)\.C&amp;DJ#V8UK4AF)J^MMITZP)&quot;&amp;9DW;B&gt;.I_PK#E\1:C&#xD;&#xA;M)PLBQC_945/XI!.J1X&amp;?W0_F:SX=)OYP&quot;EK)@]R,#]:8B-]0O)&quot;2]S*V?5S4&#xD;&#xA;M)ED)R9&amp;_.M9/#-^WW@B_5JE'A6]_YZP_F?\`&quot;@#%6&gt;53D2,/QJQ%JE]&quot;&lt;I=2&#xD;&#xA;M_0MD?E6@WA&gt;]`X&gt;)OH35*YT&gt;^M5+20,5'5EY`H`T+;Q1&lt;H0)XTD7N1P:Z&quot;QU&#xD;&#xA;M2UU!,PO\V.4;@BN`J2&amp;:2WE66)BKJ&lt;@B@#TFBL[2=074;,2&lt;&quot;1&gt;''OZUHTAA&#xD;&#xA;M117-:WKC1.UK:-AAP\@[&gt;PH`UKS5[.QR)9,N/X%Y-8L_BJ0G$%NH'JQS7.$E&#xD;&#xA;MB2223U)I,$]*8C8;Q+J+='1?H@_K31XBU+/,P/\`P!?\*J1:9&gt;S#,=M*1V.T&#xD;&#xA;MXJ3^Q=1_Y])*`+L?BF]4_.D;CZ8K3M?%%M*0L\;1'U'(KF)K&amp;Z@&amp;9;&gt;1!ZLI&#xD;&#xA;M`JOTZT`23$-,Y!R&quot;:FTS_D*6G_79/YBJM6M,_P&quot;0I:?]=D_F*`/0Z***0PHH&#xD;&#xA;MHH`****`(^PXI&amp;95!).`.I-._&amp;O._'/B?AM+LG^8\3.#T_V?\:QQ%&gt;-&amp;#DSH&#xD;&#xA;MPN&amp;GB*JA'_AC&amp;\8^)#J]W]EMG_T2$]1_RT;U^GI7+445\M5JRJS&lt;Y;L^XPV'&#xD;&#xA;MA0IJG#9!136DC3[SJ/J:B^V6Y=460,['`5022:A0D]D=%TC0LK*XU&quot;\CM;:,&#xD;&#xA;MO)(&lt;`#M[GVKV'P[H$&amp;@V`C3#SOS+)W8_X5!X5\-1:)9[G`:ZE`,C^GL/:ND[&#xD;&#xA;M5]!@&lt;$J2YY_%^1\?FF9/$2]G#X5^(=J\A^+N@`2V^MPK][]Q/C_QT_S'X&quot;O7&#xD;&#xA;M&gt;U9.O:3%K&gt;C7&gt;G2G`FC(5O[K=C^!Q7=5ASP:.#!5_85XSZ=?0^8Z*FNK:6SN&#xD;&#xA;MY;:9=LL3E''H0:AKR#[F+YM4%%%%(9Z_\'M5WV-[I3MDQ.)8P&gt;P/!_4#\Z]3&#xD;&#xA;MKYQ\&quot;ZL=(\66&lt;I;$4S&gt;3)_NMQG\#@_A7T&lt;/YUZ&gt;%GS0MV/C\VH^SQ',MI:CZ&#xD;&#xA;M***Z3S#Y2^*'_)2=:_ZZK_Z`M&lt;A77_%#_DI.M?\`75?_`$!:Y&quot;NZ/PH\R?Q,&#xD;&#xA;M6K%C87FI726MC;2W,[G&quot;QQ(6)_*H[:(3W44).`[A&lt;^F3BOK/PUX1TKPKIZVV&#xD;&#xA;MG6ZJY'[R=AF20^I/].E34GR(JE2&lt;V&gt;/:/\#=&lt;O(UDU2\M[`$9\L?O7'UQQ^M&#xD;&#xA;M=$/@%I_E8.N71?U\E&lt;?EG^M&gt;PTM&lt;[JS9UJA!=#YP\4_!S5]!LY;VPN%U&amp;VB&amp;&#xD;&#xA;MYU1&quot;LBKW.WG/X&amp;O,Z^VL&lt;5\I?$;28]$\&gt;:G:P($A9Q-&amp;HZ`.`V/S)K6E4&lt;M&amp;&#xD;&#xA;M85Z2CK$Y*NK^'.LMHOCO3+C=MCEE$$GNK\?SP?PKE*?%(T4R2(&lt;,C!@?0BMF&#xD;&#xA;MKJQA%V=S[8KS_P&quot;+^L2:5X!N4A8K+&gt;NML&quot;.H4\M^@(_&amp;NZMY1-:PRC_EH@;\&#xD;&#xA;MQFO*_CSG_A&amp;M-QT^U'/_`'R:XX+WD&gt;A5=H-GS]110.M=IYIZ#X+^%VI&gt;+;9=&#xD;&#xA;M0GG%CI[-A9&amp;7&lt;\F.NU?3W-&gt;G6?P1\*V\8%P;ZZ;N7FVC\E`KJ?`SP2&gt;&quot;=%&gt;W&#xD;&#xA;MV^7]DC'R^H&amp;#^N:Z*N25239WPI0LM#@C\&amp;_!9&amp;/[.F'TNI/\:HW/P/\`&quot;DZG&#xD;&#xA;MRI-0MSVV3@C_`,&gt;4UZ914&lt;\NYI[*'8\1U#X!'YFT[7,^B7$/]5/]*XG6OA7X&#xD;&#xA;MLT9&amp;E-A]L@7J]HWF'_OG[WZ5]28HQ5JM)&amp;&lt;L/!['&amp;_&quot;R-XOAQI&quot;2(R.JR`JP&#xD;&#xA;MP1^\:NR[4T`#H,4ZLV[NYM%621\?&gt;+O^1PUC_K\E_P#0C6+6UXN_Y'#6/^OR&#xD;&#xA;M7_T(UBUW+8\R6[%`)(`!)/0&quot;NOT/X:^*=?198=.:WMSTENCY8/T!Y/X&quot;J7@(&#xD;&#xA;M!O'FBA@&quot;#=)D'ZU]&lt;#I6=2HXZ(VHTE/5G@UI\!-1=0;O6;:,^D&lt;3/C\\58?X&#xD;&#xA;M`RA#Y&gt;OJS]@UL0/_`$*O&lt;:*P]K,Z/80['RAXJ^'VN^%!YUW&quot;LUF3@7,'S(#Z&#xD;&#xA;M-W7\:Y.OM&amp;]LK?4+.6TNHDEMY5*21N,A@:^3/&amp;'A\^&amp;?%5]I628XGS$S=2AY&#xD;&#xA;M7]*WIU.;1G-6I&lt;NJV,&amp;O3_@QXE?2O%!TB9_]$U$;5!/W91RI_$9'Y5YA5S3;&#xD;&#xA;MV33=4M;V(D/;RK(,&gt;QS535U8SA+EDF?:%-8A5+$X`&amp;344,R7%O'/&amp;&lt;I(@=3Z&#xD;&#xA;M@C(JCKMP;?2I&lt;'#/\@_'K7$&gt;F&lt;KJM\U_&gt;O(3\@.$'H*HT5?TBS%[J4&lt;;#*#Y&#xD;&#xA;MF^@IB-/1M`$RK&lt;W8/EGE8_7W-=/'%'&quot;@2-%11V`Q3P`!@&lt;`4M(84444`%%%%&#xD;&#xA;M`!1110!$8HS)YA1=^,;L&lt;XJ6BB@`HHHH`****`.7\0Z5&amp;D?VR!0N#B11T^M&lt;&#xD;&#xA;MU7?ZP`=)N&lt;_W*X&quot;F(W/#$Y346BS\LBG\QS78UPOA\XUNW_X%_P&quot;@FNZI#,O6&#xD;&#xA;M;[[#I[,IQ(_RI_C7#$DG)ZFM[Q1.7OTASQ&amp;GZFL&amp;F(M6%A+J%R(8ACNS'H!7&#xD;&#xA;M8V.E6EB@V1AI.[L,G/\`2HM&quot;LUM=.1R/WDOS,?Y&quot;M&gt;D,****`&quot;J-SI5E=@^9&#xD;&#xA;M`H8_Q*,&amp;KU%`'FLJA)64=`&lt;5/IG_`&quot;%+3_KLG\Q4-Q_Q\/\`6IM,_P&quot;0I:?]&#xD;&#xA;M=D_F*8CT.BBBD,****`&quot;BBB@#E?'.M2:%X9EN[&gt;(O(76,$'&amp;S=GYO\^M&gt;$RZ&#xD;&#xA;MY+([-Y8W$Y)9B2:]Y\=6GVWP=J4&gt;,D0[Q]5.[^E?.-&gt;7CJ:E)&lt;Q]-D?+[.5M&#xD;&#xA;M[EUM4NFZ.%^BU7&gt;YGD^_,Y_X%45%&lt;JA%;(]V[&quot;NN^'&amp;D?VKXMMG==T5K^_;(&#xD;&#xA;MXR/N_KBN1`).`,UZ7\.M;TGPW97'VXR+=7#C+!,@(!P/S)K:DX*:YG9''CG4&#xD;&#xA;M5&quot;7LU=O30]GY]:*YV#QMH%QPNH1(?20%/YBM6#4[&quot;[&amp;;&gt;\@E'^Q(#_(UZD:D&#xD;&#xA;M)?&quot;TSXV=&amp;K#XHM?(T**3(]:6M#(\'^)&gt;D01&gt;+Y986VF&gt;)99%QQNR0?SP#7('&#xD;&#xA;M3_27_P`=KNOB-+YGBZ5?^&gt;&lt;2+^F?ZUR5?/8BI)59)=S[K+U_LT+]D4?[//\`&#xD;&#xA;MST'_`'S2?V&gt;W_/0?E5^BL?:S.SE14M],N)+F)+=MTS,`@`.2&lt;\5]*Z=YS:9:&#xD;&#xA;M_:P!&lt;&gt;4OF!3P&amp;P,_K7%^`O&quot;?V.,:K?QC[0XS&quot;A'^K4]_J:]!_AKVL%3G&amp;/-+&#xD;&#xA;MJ?(9OBX5JBA#[/4?1117:&gt;0?*7Q0_P&quot;2DZU_UU7_`-`6N0KK_BA_R4G6O^NJ&#xD;&#xA;M_P#H&quot;UR%=T?A1YD_B99T[_D)6O\`UV3^8K[1'05\7:=_R$K7_KLG\Q7VB/NB&#xD;&#xA;ML*_0Z,-U'4445@=85\T_&amp;S_DH&lt;G_`%[1?R-?2U?-/QL_Y*')_P!&gt;T7\C6M'X&#xD;&#xA;MC#$?`&gt;&lt;THZTE*.M=9P'V=I'.BV)_Z=X__017!?&amp;O3GO?`C7$8)-G&lt;)*V/[IR&#xD;&#xA;MI_\`0A7&gt;Z/\`\@2P_P&quot;O&gt;/\`]!%&amp;HV,&amp;IZ=&lt;V-PNZ&amp;XC:)Q[$8KA3M*YZ&lt;H\&#xD;&#xA;MT;'QCBDK&lt;\4&gt;'+[PKKDVG7D9PIS%)CY94[,/\\5B&amp;NU.^IYK33LSLO&quot;'Q'UO&#xD;&#xA;MP?`;6W,5S9%MPMY\X4GKM(Y'\J[0?'^ZP,^'H2&gt;^+H__`!-&gt;,45+IQ;NT7&amp;K&#xD;&#xA;M.*LF&gt;T?\-`W/_0NQ?^!9_P#B*='\?Y,CS?#BE&gt;^V\P?_`$&quot;O%:*7LH=A^WGW&#xD;&#xA;M/HS3/C?X;O65+R&amp;\L'/=T#I^:G/Z5W^FZK8ZQ:+=Z==PW,#='B8$?0^AKXU-&#xD;&#xA;M;/ASQ/JGA?4EO--N&amp;3D&gt;9$3\DH]&amp;%1*BNAK#$/[1]@T=JPO&quot;WB2U\5:%;ZG:&#xD;&#xA;M9&quot;R##QD\QN.JFMWM7,U;0ZTTU='Q]XN_Y'#6/^OR7_T(UBUM&gt;+O^1PUC_K\E&#xD;&#xA;M_P#0C6+7&gt;MCS);LZ/P!_R/NB?]?:?SKZX[U\C^`/^1]T3_K[3^=?7'&gt;N&gt;ONC&#xD;&#xA;MKPWPL6BBBL#I$KY^^/%B(O$VFWH&amp;#&lt;6Q1O&lt;HQ_HPKZ!KPWX_L/M6@KW&quot;3D_F&#xD;&#xA;ME:4OC,:_P,\6H'6B@=:[#SSZY\#SFY\#:'*QRQL8@3ZD*!_2CQ2Q%K`F&gt;KDU&#xD;&#xA;M!\.@1\/=#S_SZK_6I?%G^KMOJW]*X9;L]2/PHY&gt;NF\*Q#-Q+WX4?Y_*N9KJ_&#xD;&#xA;M&quot;?\`Q[7'^^/Y4AG14444AA1110`4444`%%%,9@BEF(&quot;@9)/:@!20H))``ZDU&#xD;&#xA;ME7?B*QMB51C,X[)T_.L'5]7DO96BB8K;@\`?Q&gt;YK'H`Z&amp;3Q7.3^[MT4&gt;Y)J!&#xD;&#xA;MO$]^&gt;GEC_@-8P!/0$U,ME=,,K;RL/]E&quot;:8C2'B?4!U,9_P&quot;`U(OBJ\'6.(_@&#xD;&#xA;M:ROL%YWM9A]8S4;V\T?WXV'U%`&amp;U&lt;^)'N;.2![=09%QD-TK!I2K#J&quot;/J*2@#&#xD;&#xA;M2T#_`)#=O]3_`.@FN[KA-`_Y#=O]3_Z&quot;:[ND,X+6W\S6+@^C;?RX_I5&amp;-2TB&#xD;&#xA;MJ.I-6M4_Y&quot;MU_P!=6_F:AM/^/N+/]X4Q'H&lt;:&quot;.-47HH`%2444AA1110`4444&#xD;&#xA;M`&gt;;7'_'P_P!:FTS_`)&quot;EI_UV3^8J&amp;X_X^'^M3:9_R%+3_KLG\Q3$&gt;AT444AA&#xD;&#xA;M1110`4444`4KR!9[*&gt;%_NR1E#]&quot;,5\N7$+VUS+!(,/&amp;Y1AZ$'!KZM/(Q7S?X&#xD;&#xA;MYL_L7C/4H@,*\QE'_`OF_F:XL9'1,]S(ZEJDH=]3G:DBA&gt;9L*/J&gt;PJ&gt;&quot;S9_F&#xD;&#xA;MD^5?3N:OJJHH50`!7ESJI:(^H2(H;=(1GJWJ:FHHKE;;=V6%1W$IB@9@Q!Z#&#xD;&#xA;M!J2J5^_W$_&amp;JIZR1+BK&amp;UH?C[7]$952Z-S`.##&lt;?,/P/4?G7H^B?%71]1VQ:&#xD;&#xA;M@KV,Q_B;YHR?J.GXBO$**].%&gt;&lt;.IYF(R[#UM6K/NCNO&amp;5U%&gt;&gt;*;V&gt;&amp;19(F*[&#xD;&#xA;M71L@@*!P:P*C@&amp;((Q_LU)7F5)&lt;TW+NST:4%3IQ@NB2&quot;NZ\!&gt;$CJ$ZZI?19M8&#xD;&#xA;MS^Z1OXV'?Z#]:Q_&quot;?AF7Q!?@NK+9PG,KCO\`[(]S7MT%O%:VZ00JJ1HH5548&#xD;&#xA;M``KOP6%YG[2&gt;QXF;YAR1]C3&gt;KW\O^&quot;60,&quot;EHHKVCY&lt;****`/E+XH?\E)UK_K&#xD;&#xA;MJO\`Z`M&lt;A77_`!0_Y*3K7_75?_0%KD*[H_&quot;CS)_$RSIW_(2M?^NR?S%?:(^Z&#xD;&#xA;M*^+M._Y&quot;5K_UV3^8K[1'W16%?H=&amp;&amp;ZCJ***P.L*^:?C9_P`E#D_Z]HOY&amp;OI:&#xD;&#xA;MOFGXV?\`)0Y/^O:+^1K6C\1AB/@/.:4=:2E'6NLX#[-T?_D&quot;6/\`U[Q_^@BK&#xD;&#xA;MO:J6C_\`($L?^O&gt;/_P!!%7&gt;U&gt;&gt;SU5L8GB'PQI7B&gt;P-IJEJLJ_P`#CAXSZJ&gt;U&#xD;&#xA;M&gt;0ZO\&quot;+^.1FT?5(9H_X4N04;\P&quot;#^E&gt;]4E7&amp;&lt;H[$3I1GN?,$OPA\;1-A=+CE&#xD;&#xA;M'JEU'C]6%1?\*D\&lt;?]`7_P`F8?\`XJOJ2BK]O(S^KP/EO_A4GCC_`*`O_DS#&#xD;&#xA;M_P#%5@ZUX5USPZ1_:VF3VRL&lt;!V&amp;4)_WAD?K7V#^-9FM:5;:YI%UIMV@:&amp;XC*&#xD;&#xA;M'(^Z2.&quot;/&lt;'FFJ[OJ)X&gt;-M&amp;?'%%.==CLI['%-KI.(]?\`@/K3PZS?Z*['RIX?&#xD;&#xA;M/C![.I`/Y@_^.U[YVKY?^$4C)\2M.VG[RRJ?IL-?4%&lt;E96D=]!W@?'WB[_D&lt;&#xD;&#xA;M-8_Z_)?_`$(UBUM&gt;+O\`D&lt;-8_P&quot;OR7_T(UBUU+8XI;LZ/P!_R/NB?]?:?SKZ&#xD;&#xA;MX[U\C^`/^1]T3_K[3^=?7'&gt;N&gt;ONCKPWPL6BBBL#I$KYW^.E^+CQC:6:G(MK1&#xD;&#xA;M=WLS,3_+;7O]W=06-I+=7,JQ0Q(7D=CPH'4U\C^*M;;Q'XHO]5((6&gt;4F-3U&quot;&#xD;&#xA;M#A1^0%;45[USFQ$K1L8M`ZTIJ_H6G-J^O6.GH&quot;3&lt;3I'QZ$\_I74&lt;:U/JWP?:&#xD;&#xA;MM9&gt;#M%MV&amp;&amp;2RB##T.P9_6F^*E)LX6'9R#^5;J*J($4`*HP`.PK.UVW^T:5-@&#xD;&#xA;M99/G'X=?TK@;NSU$K*QP]=+X3E&amp;ZXB/4@,/Z_P`Q7-5H:-=BTU.-V.$;Y6^A&#xD;&#xA;MH`[VBBBD,****`&quot;BBB@`K'\17)M],*J&lt;-*VW\.];%&lt;QXN8_Z(O;YC_*@#F:N&#xD;&#xA;MZ9ISZC=&quot;(':@Y=O052KJO&quot;BCR;AN^0/YTQ&amp;Q:Z?:V:A885!'\1&amp;2?QJW112&amp;&#xD;&#xA;M%%%%`&amp;=JT,7]EW+&gt;6FX(2#M&amp;:X.O0-6_Y!-U_N&amp;O/Z8&amp;EH'_`&quot;&amp;[?ZG_`-!-&#xD;&#xA;M=W7&quot;:!_R&amp;[?ZG_T$UW=(#@M;39K%R/5L_GS_`%JBA(=2#@YK:\30E-1$G9T'&#xD;&#xA;MZ&lt;5ATQ'I,;B2-7'1@&quot;*DK-T2Z%UI&lt;1S\R#8WX5I4AA1110`4444`&gt;;7'_'P_&#xD;&#xA;MUJ;3/^0I:?\`79/YBH;C_CX?ZU-IG_(4M/\`KLG\Q3$&gt;AT444AA1110`4444&#xD;&#xA;M`)7G?C+P')K.H'5+)E^T;`K1R#`;'0@^OUKT2D/UK.I3C4CRR-J&amp;(G0GST]S&#xD;&#xA;MYRO].O--N#!&gt;V\D+CLXZCU'J*J5]%7VF6&gt;IP&amp;&amp;[@2:,]F&amp;&lt;?X5Y[KOPR8%I]&#xD;&#xA;M(ER.OD2G^3?X_G7D5L!.&amp;L-5^)]+A&lt;ZIU/=J^Z_P/-Z*GO+*ZL9VANX'AD4\&#xD;&#xA;MAEQ4%&gt;&gt;TT[,]N%2,U&gt;(5E7+[YV/8'`K2E?RXF;T%8];T%NQ2&quot;BBBN@DV8^(D&#xD;&#xA;M'L*T]$T&gt;YUO4X[.W4\\N^.$7N35.SM)KRYAM;&gt;-I)I&quot;%51W-&gt;X^%/#D/A[35&#xD;&#xA;MCX&gt;YD`::3U/H/85.%P[K3UV1Y^8XY8&gt;G9?$]O\R_I&amp;E6VC:?':6J[8T')/5C&#xD;&#xA;MW)]ZT0&lt;G':GTTU[L4HJR/C92&lt;FY2U;'T444Q!1110!\I?%#_`)*3K7_75?\`&#xD;&#xA;MT!:Y&quot;NO^*'_)2=:_ZZK_`.@+7(5W1^%'F3^)EG3O^0E:_P#79/YBOM$?=%?%&#xD;&#xA;MVG?\A*U_Z[)_,5]HCH*PK]#HPW4=1116!UA7S3\;/^2AR?\`7M%_(U]+5\T_&#xD;&#xA;M&amp;S_DH&lt;G_`%[1?R-:T?B,,1\!YS2CK24HZUUG`?9NC_\`($L?^O&gt;/_P!!%7&gt;U&#xD;&#xA;M4M'_`.0)8_\`7O'_`.@BKIZ5Y[W/57PG@@^-&amp;LZ-KM]:7UI!?6L5S(B_\LW&quot;&#xD;&#xA;MAB!R,C]*Z_3_`(V&gt;%[Q%%T+NRD/421[@/Q7/\J\#\1_\C-JG_7W+_P&quot;AFLVN&#xD;&#xA;MOV46CA]O.+/K2U^(7A&amp;\`\OQ!8KGM+*(_P#T+%:D6O:/.,PZK8R#_8N$/\C7&#xD;&#xA;MQOQ1DU/L%W+6)?5'V1-K6E6\9&gt;?4[2)!U9YU`_4UY]XV^*VCZ=I&lt;]MHMZM[J&#xD;&#xA;M$B%$&gt;$Y2+/\`%NZ$CMBOGC-.S[4*BD]298B35DAE%%.1&amp;D=412S,&lt;``9)-;G&#xD;&#xA;M.&gt;D_!33WNO'?VO;^[L[9W9NP+?*!^I_*OI&quot;O/_A9X1D\*^'2]X@74+TB69&gt;Z&#xD;&#xA;M+CY5/N,G/N:[_P#@KCJRYI'HTHN,-3X_\7?\CAK'_7Y+_P&quot;A&amp;L6MKQ=_R.&amp;L&#xD;&#xA;M?]?DO_H1K%KK6QP2W9I^'M571/$-AJ;Q&amp;5;:99&quot;@;!;';-&gt;_6'QK\*72+]H-&#xD;&#xA;MW:.1R)(MP'XJ37S=14R@I;E0JRAL?5*?%'P9(,_VY&quot;OLR./Z57N_BOX.LXBP&#xD;&#xA;MU3[0P'W8(F8G]`*^7J*CV$33ZS,]#\=_%&quot;]\6(UA91M9Z7G)0GYY&lt;=-Q'0&gt;P&#xD;&#xA;M_6O/***U44E9&amp;,I.3NQ:]8^&quot;7AAKW6IM&gt;N$/V&gt;S!2'(^]*1U_`9_,5P_A+PC&#xD;&#xA;MJ7B_5UL[*,K$IS/&lt;,/EB7W]_05]2Z%HEGH&amp;CV^F6,&gt;R&quot;%&lt;&gt;['NQ]R&gt;:QJSLK&#xD;&#xA;M(WH4VWS/8UJ8RAE*D9!&amp;#3Z*YCM//M2LVL;Z2%@=N&lt;J?453KNM7TM=1ML#&quot;S&#xD;&#xA;M)RC?TKB9H)+&gt;5HI4*NIP013$=-H6M)+$MK&lt;OMD7A&amp;)X8&gt;GUKHZ\RK2M=&lt;OK0&#xD;&#xA;M!1)O0?PN,T#.[HKF(_%G'[RUY]5:I/\`A*XO^?9_^^J0'1T5S+^+./DM,_5_&#xD;&#xA;M_K56E\4WC&lt;1QQ(/H2:`.OKGO%41:TAF`^XQ4_C_^JM#1;F6[T\2S-N&lt;L&gt;&lt;8J&#xD;&#xA;M&gt;^M5O+.2!N-PX/H&gt;U`'GE;OAJ]2WN7@D8*)&lt;;2?6L:&gt;&quot;2VG:&amp;5=KJ&lt;$5'G!R&#xD;&#xA;M*8CTVBN'M_$%]`H0LLJC^^,U=_X2R;'_`![1_F:0SJZ8S*BEF(&quot;CDDGI7'R^&#xD;&#xA;M)[UP0@BC]&quot;J\_K6=&lt;7]U=G]],[CT)XH`Z#6==MVMY+6#]X7&amp;UF[#_&amp;N6I0&quot;3&#xD;&#xA;M@#)-)3$:6@?\ANW^I_\`037=UPF@?\ANW^I_]!-=W2&amp;8OB.S^T6`F49&gt;$Y_#&#xD;&#xA;MO7&amp;5Z4RAU*L`5(P0:XC6=+?3[DE03`YRC&gt;GM3`70]3_L^ZQ)GR9.&amp;]O&gt;NV1U&#xD;&#xA;MD171@RL,@CO7FM7K'5KJP.(GS'W1N10([^BN&lt;B\5Q$#S;=E/&lt;JV14W_&quot;4V&gt;/&#xD;&#xA;M]7)^5(9NT5SC^*X1]RV&lt;_5L51N/$]Y*,1*D0]ADT`8]Q_P`?#_6IM,_Y&quot;EI_&#xD;&#xA;MUV3^8JLS%F))R35G3/\`D*6G_79/YBF(]#HHHI#&quot;BBB@`HHHH`****`&quot;BBB@&#xD;&#xA;M#,U'2;/5K&lt;PWMLDJD=QR/H&gt;HKSO7OAK/#NGTE_-4&lt;^3(&lt;-^!Z'\&lt;5ZKCBC%8&#xD;&#xA;M5&lt;/3JKWD=6'QM?#OW'IVZ'S)J]K&lt;VA^SW$,D&lt;F&gt;5=2#63Y;_`-UORKZM,&lt;;&lt;&#xD;&#xA;M[%/U%)]FB_YY)_WR*YHX'E5DSUEGKZP_$^4_+?\`NM^5.2)VD50C9)`Z5]5_&#xD;&#xA;M9X_^&gt;2?]\BC[/'_SR3_OD57U+^\5_;S_`)/Q_P&quot;`&lt;7X$\)C28!?WB?Z7,O&quot;D&#xD;&#xA;M?ZI3V^I[UW/&gt;DHS752IQIQ48GAUZ\Z]1SGNQU%%%:&amp;(4444`%%%%`'RM\3HI&#xD;&#xA;M&amp;^(^M%8V(\U&gt;0/\`86N1\B;_`)Y/_P!\FOM,QHQR54GU(I/)C_YYK_WR*W5:&#xD;&#xA;MRM8Y98&gt;[O&lt;^-=/AE&amp;I6N8W_UJ?PGU%?9HZ4SRH_^&gt;:_]\BG=ZB&lt;^&lt;UI4N2^H&#xD;&#xA;M^BBBLS4*^;/C1%(_Q&quot;D*HQ'V:+D#V-?251F-'.2H)]Q50ERNYG4ASQL?%GD3&#xD;&#xA;M?\\G_P&quot;^32B&quot;7/\`JG_[Y-?:7DQ_\\U_[Y%'DQ_\\U_[Y%;&gt;W\C#ZMYE?2/^&#xD;&#xA;M0+8?]&gt;\?_H(J[117.=9\_P#BKX-&gt;('U&amp;\O\`3)[&gt;]2:5Y?*W&gt;7(,DG'/!Z^M&#xD;&#xA;M&lt;!?&gt;#O$NF$B[T2]CQW$18?F,BOKZDP*U5:2W.&gt;5&quot;+V/BF2&quot;6%MLL;HWHRD4S&#xD;&#xA;MBOM*6UMKE?WEO%*/1T!_G5&quot;3POH$AS)H&gt;FN?5K2,_P!*OV_D9O#/N?'G%/B@&#xD;&#xA;MFG?9#$\C&gt;B*2?TKZ]3PIX&gt;C.4T'3%/JMG&amp;/Z5H06=M:KL@MH8E](XPH_2CVZ&#xD;&#xA;M[`L,^K/EO1?AMXJUR5!!I&lt;L$3'F:Y_=H!Z\\G\`:]G\%_&quot;K3/&quot;TJ7]VPO]27&#xD;&#xA;M[KLN$B/^R/7W/Z5Z-2UG*K*1M&quot;C&amp;.HM%%%9FQX'XH^#?B*\UF^U&amp;QN+&amp;=+B=&#xD;&#xA;MY5C,C(XR&lt;XY&amp;/UKCKGX8^,[0G?H4[@=XG23/_?)-?5E%:JK)&amp;#P\6?'L_A/Q&#xD;&#xA;M#;?Z[1;],&gt;MNW^%4'TR_C_UEE&lt;I_O1,/Z5]HX]J:54]0#^%5[=]B/JR[GQ6;&#xD;&#xA;M&gt;&lt;=89!_P$TZ.QNY3B.VF&lt;^BH37VCY4?_`#S7\A0(T'15'T%/V_D+ZMYGR1I_&#xD;&#xA;M@;Q/JC`6FB7CY_B:/8OYM@5Z)X&lt;^!=R[1S^(+Y8DZFWMCN;Z%N@_#-&gt;ZT5#K&#xD;&#xA;M2&gt;Q&lt;&lt;/%;ZF=I&amp;C:?H=@EEIMK';VZ=%0=?&lt;GJ3[FM*BEK(Z`HHHH`*I7VFVVH&#xD;&#xA;M1[9D^8=''45=HH`X^\\-74/S6[&quot;9/3H:R9;.YA.)()%^JUZ-28!ZB@#S/!]*&#xD;&#xA;M*]&amp;&gt;UMW^_!$WU0&amp;H_L5G_P`^EO\`]^Q_A3`\]P?2IH[6&gt;4@)&quot;[9]%KT!((!]&#xD;&#xA;MR&quot;-?H@%38`Z&quot;D!F:'#+!IBI*A1LDX(K4HHH`S-1TFWU%,N-D@Z.!S^-&lt;W=&gt;'&#xD;&#xA;MKZW8[$\Y.S)_A7;T4`&gt;&lt;/:SH&lt;-&quot;XQZK4?EOG&amp;P_E7I6!1M7T'Y4`&gt;=QV5U*&lt;&#xD;&#xA;M);R-]%-:=KX;O)CF;;&quot;OOR?RKLJ*`,RPT:UL/F1-\G]]NOX&gt;E87B+3#!=?:8&#xD;&#xA;ME_=RGG'9J[&quot;DP#U%`'#Z&quot;K#6K&lt;D$&lt;G_T$UW-)@#H!2T`%13017$313('1NH-&#xD;&#xA;M2T4`&lt;G?&gt;&amp;94)&gt;S;&gt;O]PG!%8DUI&lt;0'$L+ICU%&gt;CTA`(P0#0!YG@^E&amp;#Z5Z(]E&#xD;&#xA;M:L&lt;M;0D^\8-`L+0=+6`?]LQ3`\[P?2I%MYG^Y$[9]%KT1;&gt;%/NPQK]%`J3`'&#xD;&#xA;M0&quot;D!P46C:A-]VV&lt;?[W'\ZU;'PY/#&lt;PSS2HOEN'VKR&gt;#FNIHH`****`&quot;BBB@#&#xD;&#xA;&quot;_]D`&#xD;&#xA;" />
      </lst>
      <lst nm="GREY">
        <str nm="DESCRIPTION" vl="" />
        <str nm="ENCODING" vl="M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&amp;!@&lt;&amp;!0@'!P&lt;)&quot;0@*#!0-#`L+&#xD;&#xA;M#!D2$P\4'1H?'AT:'!P@)&quot;XG(&quot;(L(QP&lt;*#&lt;I+#`Q-#0T'R&lt;Y/3@R/&quot;XS-#+_&#xD;&#xA;MVP!#`0D)&quot;0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R&#xD;&#xA;M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1&quot;`$L`9`#`2(``A$!`Q$!_\0`&#xD;&#xA;M'P```04!`0$!`0$```````````$&quot;`P0%!@&lt;(&quot;0H+_\0`M1```@$#`P($`P4%&#xD;&#xA;M!`0```%]`0(#``01!1(A,4$&amp;$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*&#xD;&#xA;M%A&lt;8&amp;1HE)B&lt;H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&amp;EJ&lt;W1U&#xD;&#xA;M=G=X&gt;7J#A(6&amp;AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&amp;&#xD;&#xA;MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ&gt;KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!&#xD;&#xA;M`0$!`0````````$&quot;`P0%!@&lt;(&quot;0H+_\0`M1$``@$&quot;!`0#!`&lt;%!`0``0)W``$&quot;&#xD;&#xA;M`Q$$!2$Q!A)!40=A&lt;1,B,H$(%$*1H;'!&quot;2,S4O`58G+1&quot;A8D-.$E\1&lt;8&amp;1HF&#xD;&#xA;M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&amp;5F9VAI:G-T=79W&gt;'EZ@H.$&#xD;&#xA;MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q&lt;;'R,G*TM/4&#xD;&#xA;MU=;7V-G:XN/DY&gt;;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P`HHHH`****&#xD;&#xA;M`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`&#xD;&#xA;M****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`H&#xD;&#xA;MHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BB&#xD;&#xA;MB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****&#xD;&#xA;M`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`&#xD;&#xA;M****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`H&#xD;&#xA;MHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BB&#xD;&#xA;MB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****&#xD;&#xA;M`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`&#xD;&#xA;M****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`H&#xD;&#xA;MHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BB&#xD;&#xA;MB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****&#xD;&#xA;M`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`&#xD;&#xA;M****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`H&#xD;&#xA;MHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BB&#xD;&#xA;MB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****&#xD;&#xA;M`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`&#xD;&#xA;M****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`H&#xD;&#xA;MHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BB&#xD;&#xA;MB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****&#xD;&#xA;M`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`&#xD;&#xA;M****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`H&#xD;&#xA;MHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BB&#xD;&#xA;MB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****&#xD;&#xA;M`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`&#xD;&#xA;M****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`H&#xD;&#xA;MHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BB&#xD;&#xA;MB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****&#xD;&#xA;M`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`&#xD;&#xA;M****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`H&#xD;&#xA;MHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BB&#xD;&#xA;MB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****&#xD;&#xA;M`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`&#xD;&#xA;M****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`H&#xD;&#xA;MHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BB&#xD;&#xA;MB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****&#xD;&#xA;M`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`&#xD;&#xA;M****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`H&#xD;&#xA;MHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BB&#xD;&#xA;MB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****&#xD;&#xA;M`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`&#xD;&#xA;M****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`H&#xD;&#xA;%HHH`_]D`&#xD;&#xA;" />
      </lst>
      <lst nm="HSBRED">
        <str nm="DESCRIPTION" vl="" />
        <str nm="ENCODING" vl="M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&amp;!@&lt;&amp;!0@'!P&lt;)&quot;0@*#!0-#`L+&#xD;&#xA;M#!D2$P\4'1H?'AT:'!P@)&quot;XG(&quot;(L(QP&lt;*#&lt;I+#`Q-#0T'R&lt;Y/3@R/&quot;XS-#+_&#xD;&#xA;MVP!#`0D)&quot;0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R&#xD;&#xA;M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1&quot;`!``$`#`2(``A$!`Q$!_\0`&#xD;&#xA;M'P```04!`0$!`0$```````````$&quot;`P0%!@&lt;(&quot;0H+_\0`M1```@$#`P($`P4%&#xD;&#xA;M!`0```%]`0(#``01!1(A,4$&amp;$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*&#xD;&#xA;M%A&lt;8&amp;1HE)B&lt;H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&amp;EJ&lt;W1U&#xD;&#xA;M=G=X&gt;7J#A(6&amp;AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&amp;&#xD;&#xA;MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ&gt;KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!&#xD;&#xA;M`0$!`0````````$&quot;`P0%!@&lt;(&quot;0H+_\0`M1$``@$&quot;!`0#!`&lt;%!`0``0)W``$&quot;&#xD;&#xA;M`Q$$!2$Q!A)!40=A&lt;1,B,H$(%$*1H;'!&quot;2,S4O`58G+1&quot;A8D-.$E\1&lt;8&amp;1HF&#xD;&#xA;M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&amp;5F9VAI:G-T=79W&gt;'EZ@H.$&#xD;&#xA;MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q&lt;;'R,G*TM/4&#xD;&#xA;MU=;7V-G:XN/DY&gt;;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#A****\,_1&#xD;&#xA;M@HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;&#xD;&#xA;2BBB@`HHHH`****`&quot;BBB@#__9&#xD;&#xA;" />
      </lst>
      <lst nm="HSBORANGE">
        <str nm="DESCRIPTION" vl="" />
        <str nm="ENCODING" vl="M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&amp;!@&lt;&amp;!0@'!P&lt;)&quot;0@*#!0-#`L+&#xD;&#xA;M#!D2$P\4'1H?'AT:'!P@)&quot;XG(&quot;(L(QP&lt;*#&lt;I+#`Q-#0T'R&lt;Y/3@R/&quot;XS-#+_&#xD;&#xA;MVP!#`0D)&quot;0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R&#xD;&#xA;M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1&quot;`!``$`#`2(``A$!`Q$!_\0`&#xD;&#xA;M'P```04!`0$!`0$```````````$&quot;`P0%!@&lt;(&quot;0H+_\0`M1```@$#`P($`P4%&#xD;&#xA;M!`0```%]`0(#``01!1(A,4$&amp;$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*&#xD;&#xA;M%A&lt;8&amp;1HE)B&lt;H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&amp;EJ&lt;W1U&#xD;&#xA;M=G=X&gt;7J#A(6&amp;AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&amp;&#xD;&#xA;MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ&gt;KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!&#xD;&#xA;M`0$!`0````````$&quot;`P0%!@&lt;(&quot;0H+_\0`M1$``@$&quot;!`0#!`&lt;%!`0``0)W``$&quot;&#xD;&#xA;M`Q$$!2$Q!A)!40=A&lt;1,B,H$(%$*1H;'!&quot;2,S4O`58G+1&quot;A8D-.$E\1&lt;8&amp;1HF&#xD;&#xA;M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&amp;5F9VAI:G-T=79W&gt;'EZ@H.$&#xD;&#xA;MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q&lt;;'R,G*TM/4&#xD;&#xA;MU=;7V-G:XN/DY&gt;;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P&quot;I1117Q)^E&#xD;&#xA;M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%&#xD;&#xA;2%%%`!1110`4444`%%%%`'__9&#xD;&#xA;" />
      </lst>
      <lst nm="HSBGREY">
        <str nm="DESCRIPTION" vl="" />
        <str nm="ENCODING" vl="M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&amp;!@&lt;&amp;!0@'!P&lt;)&quot;0@*#!0-#`L+&#xD;&#xA;M#!D2$P\4'1H?'AT:'!P@)&quot;XG(&quot;(L(QP&lt;*#&lt;I+#`Q-#0T'R&lt;Y/3@R/&quot;XS-#+_&#xD;&#xA;MVP!#`0D)&quot;0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R&#xD;&#xA;M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1&quot;`!``$`#`2(``A$!`Q$!_\0`&#xD;&#xA;M'P```04!`0$!`0$```````````$&quot;`P0%!@&lt;(&quot;0H+_\0`M1```@$#`P($`P4%&#xD;&#xA;M!`0```%]`0(#``01!1(A,4$&amp;$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*&#xD;&#xA;M%A&lt;8&amp;1HE)B&lt;H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&amp;EJ&lt;W1U&#xD;&#xA;M=G=X&gt;7J#A(6&amp;AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&amp;&#xD;&#xA;MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ&gt;KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!&#xD;&#xA;M`0$!`0````````$&quot;`P0%!@&lt;(&quot;0H+_\0`M1$``@$&quot;!`0#!`&lt;%!`0``0)W``$&quot;&#xD;&#xA;M`Q$$!2$Q!A)!40=A&lt;1,B,H$(%$*1H;'!&quot;2,S4O`58G+1&quot;A8D-.$E\1&lt;8&amp;1HF&#xD;&#xA;M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&amp;5F9VAI:G-T=79W&gt;'EZ@H.$&#xD;&#xA;MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q&lt;;'R,G*TM/4&#xD;&#xA;MU=;7V-G:XN/DY&gt;;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#L****H`HH&#xD;&#xA;MHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB&#xD;&#xA;0@`HHHH`****`&quot;BBB@#__V0``&#xD;&#xA;" />
      </lst>
      <lst nm="HSBBLUE">
        <str nm="DESCRIPTION" vl="" />
        <str nm="ENCODING" vl="M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&amp;!@&lt;&amp;!0@'!P&lt;)&quot;0@*#!0-#`L+&#xD;&#xA;M#!D2$P\4'1H?'AT:'!P@)&quot;XG(&quot;(L(QP&lt;*#&lt;I+#`Q-#0T'R&lt;Y/3@R/&quot;XS-#+_&#xD;&#xA;MVP!#`0D)&quot;0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R&#xD;&#xA;M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1&quot;`!``$`#`2(``A$!`Q$!_\0`&#xD;&#xA;M'P```04!`0$!`0$```````````$&quot;`P0%!@&lt;(&quot;0H+_\0`M1```@$#`P($`P4%&#xD;&#xA;M!`0```%]`0(#``01!1(A,4$&amp;$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*&#xD;&#xA;M%A&lt;8&amp;1HE)B&lt;H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&amp;EJ&lt;W1U&#xD;&#xA;M=G=X&gt;7J#A(6&amp;AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&amp;&#xD;&#xA;MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ&gt;KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!&#xD;&#xA;M`0$!`0````````$&quot;`P0%!@&lt;(&quot;0H+_\0`M1$``@$&quot;!`0#!`&lt;%!`0``0)W``$&quot;&#xD;&#xA;M`Q$$!2$Q!A)!40=A&lt;1,B,H$(%$*1H;'!&quot;2,S4O`58G+1&quot;A8D-.$E\1&lt;8&amp;1HF&#xD;&#xA;M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&amp;5F9VAI:G-T=79W&gt;'EZ@H.$&#xD;&#xA;MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q&lt;;'R,G*TM/4&#xD;&#xA;MU=;7V-G:XN/DY&gt;;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#R*BBBO1/+&#xD;&#xA;M&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@`HHHH`*&#xD;&#xA;2***`&quot;BBB@`HHHH`****`/__9&#xD;&#xA;" />
      </lst>
    </lst>
  </lst>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="11242" />
        <int nm="BreakPoint" vl="11204" />
        <int nm="BreakPoint" vl="9735" />
        <int nm="BreakPoint" vl="11204" />
        <int nm="BreakPoint" vl="9735" />
        <int nm="BreakPoint" vl="11204" />
        <int nm="BreakPoint" vl="11242" />
        <int nm="BreakPoint" vl="9735" />
        <int nm="BreakPoint" vl="11204" />
        <int nm="BreakPoint" vl="9735" />
        <int nm="BreakPoint" vl="11204" />
        <int nm="BreakPoint" vl="8086" />
        <int nm="BreakPoint" vl="9735" />
        <int nm="BreakPoint" vl="11204" />
        <int nm="BreakPoint" vl="2121" />
        <int nm="BreakPoint" vl="3043" />
        <int nm="BreakPoint" vl="7513" />
        <int nm="BreakPoint" vl="7427" />
        <int nm="BreakPoint" vl="14812" />
        <int nm="BreakPoint" vl="12056" />
        <int nm="BreakPoint" vl="12035" />
        <int nm="BreakPoint" vl="9128" />
        <int nm="BreakPoint" vl="9031" />
        <int nm="BreakPoint" vl="9104" />
        <int nm="BreakPoint" vl="8842" />
        <int nm="BreakPoint" vl="9971" />
        <int nm="BreakPoint" vl="8841" />
        <int nm="BreakPoint" vl="9557" />
        <int nm="BreakPoint" vl="9895" />
        <int nm="BreakPoint" vl="7678" />
        <int nm="BreakPoint" vl="8086" />
        <int nm="BreakPoint" vl="1484" />
        <int nm="BreakPoint" vl="7179" />
        <int nm="BreakPoint" vl="7247" />
        <int nm="BreakPoint" vl="7376" />
        <int nm="BreakPoint" vl="8245" />
        <int nm="BreakPoint" vl="3938" />
        <int nm="BreakPoint" vl="3934" />
        <int nm="BreakPoint" vl="6532" />
        <int nm="BreakPoint" vl="4354" />
        <int nm="BreakPoint" vl="4333" />
        <int nm="BreakPoint" vl="4320" />
        <int nm="BreakPoint" vl="202" />
        <int nm="BreakPoint" vl="11219" />
        <int nm="BreakPoint" vl="11181" />
        <int nm="BreakPoint" vl="9712" />
        <int nm="BreakPoint" vl="11181" />
        <int nm="BreakPoint" vl="9712" />
        <int nm="BreakPoint" vl="11181" />
        <int nm="BreakPoint" vl="11219" />
        <int nm="BreakPoint" vl="9712" />
        <int nm="BreakPoint" vl="11181" />
        <int nm="BreakPoint" vl="9712" />
        <int nm="BreakPoint" vl="11181" />
        <int nm="BreakPoint" vl="8063" />
        <int nm="BreakPoint" vl="9712" />
        <int nm="BreakPoint" vl="11181" />
        <int nm="BreakPoint" vl="2119" />
        <int nm="BreakPoint" vl="3037" />
        <int nm="BreakPoint" vl="7490" />
        <int nm="BreakPoint" vl="7404" />
        <int nm="BreakPoint" vl="14789" />
        <int nm="BreakPoint" vl="12033" />
        <int nm="BreakPoint" vl="12012" />
        <int nm="BreakPoint" vl="9105" />
        <int nm="BreakPoint" vl="9008" />
        <int nm="BreakPoint" vl="9081" />
        <int nm="BreakPoint" vl="8819" />
        <int nm="BreakPoint" vl="9948" />
        <int nm="BreakPoint" vl="8818" />
        <int nm="BreakPoint" vl="9534" />
        <int nm="BreakPoint" vl="9872" />
        <int nm="BreakPoint" vl="7655" />
        <int nm="BreakPoint" vl="8063" />
        <int nm="BreakPoint" vl="1484" />
        <int nm="BreakPoint" vl="7156" />
        <int nm="BreakPoint" vl="7224" />
        <int nm="BreakPoint" vl="7353" />
        <int nm="BreakPoint" vl="8222" />
        <int nm="BreakPoint" vl="4123" />
        <int nm="BreakPoint" vl="4124" />
        <int nm="BreakPoint" vl="3932" />
        <int nm="BreakPoint" vl="3928" />
        <int nm="BreakPoint" vl="4129" />
        <int nm="BreakPoint" vl="6509" />
        <int nm="BreakPoint" vl="3131" />
        <int nm="BreakPoint" vl="4338" />
        <int nm="BreakPoint" vl="4311" />
        <int nm="BreakPoint" vl="4298" />
        <int nm="BreakPoint" vl="202" />
        <int nm="BreakPoint" vl="11192" />
        <int nm="BreakPoint" vl="11154" />
        <int nm="BreakPoint" vl="9685" />
        <int nm="BreakPoint" vl="11154" />
        <int nm="BreakPoint" vl="9685" />
        <int nm="BreakPoint" vl="11154" />
        <int nm="BreakPoint" vl="11192" />
        <int nm="BreakPoint" vl="9685" />
        <int nm="BreakPoint" vl="11154" />
        <int nm="BreakPoint" vl="9685" />
        <int nm="BreakPoint" vl="11154" />
        <int nm="BreakPoint" vl="8036" />
        <int nm="BreakPoint" vl="9685" />
        <int nm="BreakPoint" vl="11154" />
        <int nm="BreakPoint" vl="2121" />
        <int nm="BreakPoint" vl="2993" />
        <int nm="BreakPoint" vl="3004" />
        <int nm="BreakPoint" vl="7463" />
        <int nm="BreakPoint" vl="7377" />
        <int nm="BreakPoint" vl="14762" />
        <int nm="BreakPoint" vl="12006" />
        <int nm="BreakPoint" vl="11985" />
        <int nm="BreakPoint" vl="9078" />
        <int nm="BreakPoint" vl="8981" />
        <int nm="BreakPoint" vl="9054" />
        <int nm="BreakPoint" vl="8792" />
        <int nm="BreakPoint" vl="9921" />
        <int nm="BreakPoint" vl="8791" />
        <int nm="BreakPoint" vl="9507" />
        <int nm="BreakPoint" vl="9845" />
        <int nm="BreakPoint" vl="7628" />
        <int nm="BreakPoint" vl="8036" />
        <int nm="BreakPoint" vl="1484" />
        <int nm="BreakPoint" vl="7129" />
        <int nm="BreakPoint" vl="7197" />
        <int nm="BreakPoint" vl="7326" />
        <int nm="BreakPoint" vl="8195" />
        <int nm="BreakPoint" vl="3888" />
        <int nm="BreakPoint" vl="3884" />
        <int nm="BreakPoint" vl="6482" />
        <int nm="BreakPoint" vl="4298" />
        <int nm="BreakPoint" vl="4277" />
        <int nm="BreakPoint" vl="4264" />
        <int nm="BreakPoint" vl="202" />
        <int nm="BreakPoint" vl="11169" />
        <int nm="BreakPoint" vl="11131" />
        <int nm="BreakPoint" vl="9662" />
        <int nm="BreakPoint" vl="11131" />
        <int nm="BreakPoint" vl="9662" />
        <int nm="BreakPoint" vl="11131" />
        <int nm="BreakPoint" vl="11169" />
        <int nm="BreakPoint" vl="9662" />
        <int nm="BreakPoint" vl="11131" />
        <int nm="BreakPoint" vl="9662" />
        <int nm="BreakPoint" vl="11131" />
        <int nm="BreakPoint" vl="8013" />
        <int nm="BreakPoint" vl="9662" />
        <int nm="BreakPoint" vl="11131" />
        <int nm="BreakPoint" vl="2119" />
        <int nm="BreakPoint" vl="2987" />
        <int nm="BreakPoint" vl="2998" />
        <int nm="BreakPoint" vl="7440" />
        <int nm="BreakPoint" vl="7354" />
        <int nm="BreakPoint" vl="14739" />
        <int nm="BreakPoint" vl="11983" />
        <int nm="BreakPoint" vl="11962" />
        <int nm="BreakPoint" vl="9055" />
        <int nm="BreakPoint" vl="8958" />
        <int nm="BreakPoint" vl="9031" />
        <int nm="BreakPoint" vl="8769" />
        <int nm="BreakPoint" vl="9898" />
        <int nm="BreakPoint" vl="8768" />
        <int nm="BreakPoint" vl="9484" />
        <int nm="BreakPoint" vl="9822" />
        <int nm="BreakPoint" vl="7605" />
        <int nm="BreakPoint" vl="8013" />
        <int nm="BreakPoint" vl="1484" />
        <int nm="BreakPoint" vl="7022" />
        <int nm="BreakPoint" vl="7174" />
        <int nm="BreakPoint" vl="7303" />
        <int nm="BreakPoint" vl="8172" />
        <int nm="BreakPoint" vl="4558" />
        <int nm="BreakPoint" vl="4551" />
        <int nm="BreakPoint" vl="3882" />
        <int nm="BreakPoint" vl="3878" />
        <int nm="BreakPoint" vl="7026" />
        <int nm="BreakPoint" vl="3343" />
        <int nm="BreakPoint" vl="6459" />
        <int nm="BreakPoint" vl="4282" />
        <int nm="BreakPoint" vl="4261" />
        <int nm="BreakPoint" vl="4248" />
        <int nm="BreakPoint" vl="2806" />
        <int nm="BreakPoint" vl="202" />
        <int nm="BreakPoint" vl="2806" />
        <int nm="BreakPoint" vl="4320" />
        <int nm="BreakPoint" vl="8230" />
        <int nm="BreakPoint" vl="2808" />
        <int nm="BreakPoint" vl="259" />
        <int nm="BreakPoint" vl="8282" />
        <int nm="BreakPoint" vl="8283" />
        <int nm="BreakPoint" vl="8731" />
        <int nm="BreakPoint" vl="4528" />
        <int nm="BreakPoint" vl="4529" />
        <int nm="BreakPoint" vl="2463" />
        <int nm="BreakPoint" vl="8280" />
        <int nm="BreakPoint" vl="8281" />
        <int nm="BreakPoint" vl="2686" />
        <int nm="BreakPoint" vl="3466" />
        <int nm="BreakPoint" vl="3561" />
        <int nm="BreakPoint" vl="3598" />
        <int nm="BreakPoint" vl="3644" />
        <int nm="BreakPoint" vl="3646" />
        <int nm="BreakPoint" vl="3658" />
        <int nm="BreakPoint" vl="3649" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24107: Add support for fastenerEntities" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="90" />
      <str nm="Date" vl="6/18/2025 4:42:15 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24107: add property to include entities in xRef" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="89" />
      <str nm="Date" vl="6/2/2025 4:37:52 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24107: avoid duplicated instances" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="88" />
      <str nm="Date" vl="6/2/2025 1:38:53 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24107: cleanup level instance when hatch instance is deleted and vice versa" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="87" />
      <str nm="Date" vl="6/2/2025 10:30:23 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23455: For sections in model split the hatching tsl and the level/depth tsl so they can be assigned indipendently" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="86" />
      <str nm="Date" vl="4/24/2025 3:51:53 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23455: Add support for blocks" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="85" />
      <str nm="Date" vl="4/24/2025 11:19:37 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22914: Fix error message of failing solid generation" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="84" />
      <str nm="Date" vl="12/20/2024 10:57:44 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22914: remove dependency to clipVolume" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="83" />
      <str nm="Date" vl="12/5/2024 4:26:38 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22901: Handle when tsl realbody fails" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="82" />
      <str nm="Date" vl="11/20/2024 2:02:56 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22263: fix when saving SIP components" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="81" />
      <str nm="Date" vl="10/11/2024 11:03:01 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22263: Some refactoring" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="80" />
      <str nm="Date" vl="10/9/2024 10:33:02 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22263: Improve performance on jigging at command &quot;Modify/Add hatch&quot;" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="79" />
      <str nm="Date" vl="10/8/2024 2:06:25 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="20240617: Fix typo when getting hatch patterns" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="78" />
      <str nm="Date" vl="6/18/2024 10:34:35 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21749: fix solid hatch with insulation" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="77" />
      <str nm="Date" vl="6/18/2024 10:30:13 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21749: Increase limit for insulation hatching" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="76" />
      <str nm="Date" vl="4/25/2024 6:42:42 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21749: Fix solif hatch at beams" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="75" />
      <str nm="Date" vl="4/25/2024 4:13:40 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21945: Fix for painter with groups" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="74" />
      <str nm="Date" vl="4/25/2024 1:17:00 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21749: Fix insulation drawing in layout" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="73" />
      <str nm="Date" vl="4/4/2024 4:41:45 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21655: Improve operation in planeProfile intersection" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="72" />
      <str nm="Date" vl="4/4/2024 2:27:04 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20381: For zero transparency subtract planeprofiles in z order" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="71" />
      <str nm="Date" vl="3/22/2024 2:23:38 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20381: Fix orientation when &quot;Modify hatch&quot;" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="70" />
      <str nm="Date" vl="3/22/2024 11:05:43 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21596: Add command to influence group assignment behaviour" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="69" />
      <str nm="Date" vl="3/19/2024 3:36:11 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20972: Fix textheight in blockspace" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="68" />
      <str nm="Date" vl="12/20/2023 4:07:22 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20377: dont create painter definition if not requested on insert" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="67" />
      <str nm="Date" vl="12/20/2023 1:14:43 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20634: Wrong message on sections." />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="66" />
      <str nm="Date" vl="11/14/2023 2:18:17 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20184: Extent pattern detection by painter grouping" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="65" />
      <str nm="Date" vl="10/13/2023 1:37:48 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20184: Fix when fail tsl body intersect" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="64" />
      <str nm="Date" vl="10/11/2023 9:52:12 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="2023.09.27: Inlcude tsls when geting box of bodies" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="63" />
      <str nm="Date" vl="9/27/2023 2:11:14 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20048:" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="62" />
      <str nm="Date" vl="9/26/2023 1:56:06 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20048: For AssemblyDefinition tsl it is the only entity in showset; Include entities of the tsl" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="61" />
      <str nm="Date" vl="9/15/2023 2:13:35 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18779: Fix transformation at slabs" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="60" />
      <str nm="Date" vl="4/25/2023 11:54:56 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18391: Remove case sensitivity when  getting painter type" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="59" />
      <str nm="Date" vl="3/21/2023 2:56:36 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16893: Use pline for drawing the insulation" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="58" />
      <str nm="Date" vl="3/8/2023 9:37:17 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="20220216: Dont let fixed pt0 in viewports in layout space" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="57" />
      <str nm="Date" vl="2/16/2023 11:06:07 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16741: Exclude &quot;dummy&quot; genbeams" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="56" />
      <str nm="Date" vl="12/8/2022 10:34:50 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16741: for one layer panel withempty material, make use of the panel material; dont prompt jig selection when only one section/multipage view port selected" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="55" />
      <str nm="Date" vl="12/7/2022 2:49:14 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16991: Improve horizontal sections and appearance of setup graphics; update globals (getview) on point click" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="54" />
      <str nm="Date" vl="11/8/2022 3:27:19 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16740: Add Multipage model support" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="53" />
      <str nm="Date" vl="11/4/2022 1:47:24 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16802: Fix drawing of dynamic hatching" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="52" />
      <str nm="Date" vl="11/3/2022 10:50:25 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16802: Capture when TSL is moved with the section and make sure the grip points that define section depth are not changed" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="51" />
      <str nm="Date" vl="10/28/2022 4:32:07 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16802: Make table smaller" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="50" />
      <str nm="Date" vl="10/28/2022 2:48:36 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16802: Fix dynamic hatching" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="49" />
      <str nm="Date" vl="10/28/2022 12:51:12 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16802: Improve graphical display in jigging" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="48" />
      <str nm="Date" vl="10/26/2022 3:49:05 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16802: Support changing multiple hatches at ones. Different properties are shown as *VARIES*" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="47" />
      <str nm="Date" vl="10/26/2022 12:48:31 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16741: add jig interface for &quot;Modify hatch&quot; and &quot;Add hatch&quot;" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="46" />
      <str nm="Date" vl="10/24/2022 2:02:19 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16741: add support for collection entities" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="45" />
      <str nm="Date" vl="10/14/2022 11:42:35 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16727: Add property &quot;Hatch Mapping&quot; {by Material; by Painter}" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="44" />
      <str nm="Date" vl="10/7/2022 4:13:28 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12334: improvement for insulation" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="43" />
      <str nm="Date" vl="9/23/2022 5:01:58 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12334: support insulation snake (curly) shape" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="42" />
      <str nm="Date" vl="9/16/2022 2:16:02 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15941: set the map to mapSetting after doing migration; migration only done at insertion.remove command to do migration." />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="41" />
      <str nm="Date" vl="9/12/2022 10:01:50 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16233: For dynamic scale make scale equal to ACA scale for a size of 1000mm" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="40" />
      <str nm="Date" vl="9/2/2022 11:07:22 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15895: fix transparency and orientation angle of the hatch for panels" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="39" />
      <str nm="Date" vl="9/1/2022 11:59:34 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15943: use only painters of collection when defined" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="38" />
      <str nm="Date" vl="7/8/2022 11:54:54 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15941: when inconsistent setting version do migration from installation directory;add {import settings,Export settings, migrate setting}" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="37" />
      <str nm="Date" vl="7/8/2022 11:25:07 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12339: fix index when modifying hatch" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="36" />
      <str nm="Date" vl="6/28/2022 3:21:21 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12339: add cross symbol flag in xml for beams" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="35" />
      <str nm="Date" vl="6/10/2022 5:12:42 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15528: fix bug: when entities not assigned to any group, they must be hatched" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="34" />
      <str nm="Date" vl="6/9/2022 4:31:12 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15528: hatch only entities that are visible" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="33" />
      <str nm="Date" vl="6/2/2022 8:40:35 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15364 section references drawn on T-Layer (non plotable) if section is assigned to a group " />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="32" />
      <str nm="Date" vl="5/4/2022 8:46:28 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14361: Improve investigation of planeprofile and visible segments" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="29" />
      <str nm="Date" vl="1/24/2022 4:41:59 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13341: Define Scaling and Transparency as unitless properties" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="28" />
      <str nm="Date" vl="1/10/2022 9:39:35 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13956: improve sectional cut investigation" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="27" />
      <str nm="Date" vl="12/16/2021 9:33:49 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13603: fix when reading flag &quot;Static&quot; for the hatch scale" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="26" />
      <str nm="Date" vl="12/15/2021 10:50:58 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13605: fix rotation between the sectional normal and the most aligned vector" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="25" />
      <str nm="Date" vl="12/15/2021 9:58:54 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13602: fix bug when modifying hatch; make sure NoYes properties use 0 or 1" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="24" />
      <str nm="Date" vl="12/14/2021 5:05:53 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11492: update the hatch default values if smth missing in xml" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="23" />
      <str nm="Date" vl="7/14/2021 1:40:37 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11492: add command &quot;delete hatch&quot;" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="22" />
      <str nm="Date" vl="7/9/2021 11:24:24 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11492: when modifying hatch prompt only properties for the orientation of selected property" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="21" />
      <str nm="Date" vl="7/8/2021 9:46:00 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11492: fix bug when initializing grip points for 2d section" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="20" />
      <str nm="Date" vl="7/6/2021 5:31:08 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11492: add trigger &quot;modify hatch&quot; and &quot;add hatch&quot;" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="19" />
      <str nm="Date" vl="7/6/2021 3:50:24 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12297: improve calc of transparency so that all hatches reach 100 when user inputs 100" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="18" />
      <str nm="Date" vl="6/24/2021 4:44:54 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12297: kosmetik properties" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="17" />
      <str nm="Date" vl="6/24/2021 12:55:18 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12297: kosmetik" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="16" />
      <str nm="Date" vl="6/24/2021 11:10:55 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12297: add outline contour and property to scale transparency" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="15" />
      <str nm="Date" vl="6/24/2021 9:07:43 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12235: Support walls, maselements, 3d vols(entities with 3d)" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="14" />
      <str nm="Date" vl="6/22/2021 4:59:03 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Ticket ID #9984823: recreate planeprofile" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="13" />
      <str nm="Date" vl="5/14/2021 4:18:13 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11469: calculate planeprofile of intersection from body and clipping body using 2 slices" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="12" />
      <str nm="Date" vl="4/9/2021 12:43:24 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11408: include panel as a type in the painter definition for SIPs" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="11" />
      <str nm="Date" vl="3/30/2021 9:40:20 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11326: fix hatch representation" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="10" />
      <str nm="Date" vl="3/24/2021 9:00:12 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End