#Version 8
#BeginDescription
#Versions
Version 14.1 30.09.2025 HSB-24510 catching solid of element if not used or present in display Thorsten Huck
Version 14.0 06.06.2025 HSB-24122 sequencing disabled , Author Thorsten Huck
Version 13.9 08.04.2025 HSB-23212 new type 'FastenerAssembly' supported
Version 13.8 12.03.2025 HSB-23688 tag plcament improved for tsl references. 'not on parent' placment improved
Version 13.7 31.01.2025 HSB-23435 supporting StackPacks and other entities which only provide a solid in model view
Version 13.6 09.01.2025 HSB-23183: Enable "text alignment" commands in block space
Version 13.5 16.10.2024 HSB-22810: remove debug display
Version 13.4 10.10.2024 HSB-22792 using a virtual body for roof elements
Version 13.3 08.08.2024 HSB-22503 alignment text and grain symbol adjusted
Version 13.2 22.07.2024 HSB-21294 isometric views of metalpart collection entities coerrected, nested genbeams of metalaprts contribute quantity if in group mode
Version 13.1 17.06.2024 HSB-22175 debug display removed
Version 13.0 05.06.2024 HSB-22175 'not on parent' modes improved especially for floorplans
Version 12.9 31.05.2024 HSB-22127 leader location improved for entities which are not intersecting the clipping profile
Version 12.8 31.05.2024 HSB-22167 catching invalid bodies from metalpart definitions
Version 12.7 10.05.2024 HSB-22038 tag placement improved
Version 12.6 08.05.2024 HSB-21973 accepting entities referenced by StackItems
Version 12.5 13.12.2023 HSB-20760 Z-projection corrected
Version 12.4 12.12.2023 HSB-20760 bugfix leader offset
Version 12.3 22.11.2023 HSB-20689 bugfix edit in place of element viewports
Version 12.2 14.11.2023 HSB-20497 painter selection in blockspace allows any type, leader projection on multipages improved
Version 12.1 31.10.2023 HSB-20497 supports nested entities in sections, new property to control grouping behaviour of painter groups, painter format used if format is empty and painter grouping has been set
Version 12.0 31.10.2023 HSB-20497 supports tagging of nested entities of metalPartCollectionEntities, NOTE: requires hsbDesign 26 or higher
Version 11.2 18.09.2023 HSB-18094 tsl selection now supports multiple seleection from list
Version 11.1 11.09.2023 HSB-18094 TSL selection now based on potential painter definition or on selected instances

Version 11.0 18.08.2023 HSB-19843 new context menu to number genbeams in case not numbered items are found
Version 10.9 28.06.2023 HSB-19385 collecting genbeams by zone and by painter improved
Version 10.8 07.06.2023 HSB-18668 grouped tags support glyph grips to reposition tags within range
Version 10.7 07.06.2023 HSB-19140 catching opnings with no solid
Version 10.6 12.05.2023 HSB-18926 removed dependency to clipbody on section viewTags to reduce save time
Version 10.5 10.05.2023 HSB-18943 insert in multipage blockspace corrected, painter definitions of type MetalPartCollectionEntity, Element, ElementRoof and Opening accepted
Version 10.4 19.04.2023 HSB-17988 bugfix when referring to windows within sections
Version 10.3 20.03.2023 HSB-18384 bugfix using font of selected dimstyle
Version 10.2 02.03.2023 HSB-18186 MetalParts improved within sections and viewports
Version 10.1 02.03.2023 HSB-17894 new optional selection of entities in viewport mode
Version 10.0 17.02.2023 HSB-18013 property values auto corrected when updating from version < 9.5
Version 9.9 08.02.2023 HSB-17894 pure Acad Viewports now auto collect entities of the selected type if nothing selected by the user
Version 9.8 13.01.2023 HSB-17528 tag overlapping corrected
Version 9.7 22.12.2022 HSB-16765 not numbered genbeams and tsls are highlighted if posnum is selected as format variable
Version 9.6 22.12.2022 HSB-15850 genbeam type considered when in multipages and metalpart collection entity
Version 9.5 22.12.2022 HSB-16765 new grouped styles added, tag layout more concise, tag background set to nearly white
Version 9.4 12.12.2022 HSB-17297 blockspace preview enhanced




































#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 14
#MinorVersion 1
#KeyWords Layout;Tag; Badge; Number;Description;Label;Painter;Grouping
#BeginContents
//region Part #1

		
//region History
// #Versions
// 14.1 30.09.2025 HSB-24510 catching solid of element if not used or present in display Thorsten Huck
// 14.0 06.06.2025 HSB-24122 sequencing disabled , Author Thorsten Huck
// 13.9 08.04.2025 HSB-23212 new type 'FastenerAssembly' supported , Author Thorsten Huck
// 13.8 12.03.2025 HSB-23688 tag placement improved for tsl references. 'not on parent' placment improved , Author Thorsten Huck
// 13.7 31.01.2025 HSB-23435 supporting StackPacks and other entities which only provide a solid in model view , Author Thorsten Huck
// 13.6 09.01.2025 HSB-23183: Enable "text alignment" commands in block space , Author: Marsel Nakuci
// 13.5 16.10.2024 HSB-22810: remove debug display , Author Marsel Nakuci
// 13.4 10.10.2024 HSB-22792 using a virtual body for roof elements , Author Thorsten Huck
// 13.3 08.08.2024 HSB-22503 alignment text and grain symbol adjusted , Author Thorsten Huck
// 13.2 22.07.2024 HSB-21294 isometric views of metalpart collection entities coerrected, nested genbeams of metalaprts contribute quantity if in group mode , Author Thorsten Huck
// 13.1 17.06.2024 HSB-22175 debug display removed , Author Thorsten Huck
// 13.0 05.06.2024 HSB-22175 'not on parent' modes improved especially for floorplans , Author Thorsten Huck
// 12.9 31.05.2024 HSB-22127 leader location improved for entities which are not intersecting the clipping profile , Author Thorsten Huck
// 12.8 31.05.2024 HSB-22167 catching invalid bodies from metalpart definitions , Author Thorsten Huck
// 12.7 10.05.2024 HSB-22038 tag placement improved , Author Thorsten Huck
// 12.6 08.05.2024 HSB-21973 accepting entities referenced by StackItems , Author Thorsten Huck
// 12.5 13.12.2023 HSB-20760 Z-projection corrected, Author Thorsten Huck , Author Thorsten Huck
// 12.4 12.12.2023 HSB-20760 bugfix leader offset , Author Thorsten Huck
// 12.3 22.11.2023 HSB-20689 bugfix edit in place of element viewports  , Author Thorsten Huck
// 12.2 14.11.2023 HSB-20497 painter selection in blockspace allows any type, leader projection on multipages improved , Author Thorsten Huck
// 12.1 31.10.2023 HSB-20497 supports nested entities in sections, new property to control grouping behaviour of painter groups, painter format used if format is empty and painter grouping has been set , Author Thorsten Huck
// 12.0 31.10.2023 HSB-20497 supports tagging of nested entities of metalPartCollectionEntities, NOTE: requires hsbDesign 26 or higher , Author Thorsten Huck
// 11.2 18.09.2023 HSB-18094 tsl selection now supports multiple seleection from list , Author Thorsten Huck
// 11.1 11.09.2023 HSB-18094 TSL selection now based on potential painter definition or on selected instances , Author Thorsten Huck
// 11.0 18.08.2023 HSB-19843 new context menu to number genbeams in case not numbered iitems are found , Author Thorsten Huck
// 10.9 28.06.2023 HSB-19385 collecting genbeams by zone and by painter improved , Author Thorsten Huck
// 10.8 07.06.2023 HSB-18668 grouped tags support glyph grips to reposition tags within range , Author Thorsten Huck
// 10.7 07.06.2023 HSB-19140 catching opnings with no solid , Author Thorsten Huck
// 10.6 12.05.2023 HSB-18926 removed dependency to clipbody on section viewTags to reduce save time , Author Thorsten Huck
// 10.5 10.05.2023 HSB-18943 insert in multipage blockspace corrected, painter definitions of type MetalPartCollectionEntity, Element, ElementRoof and Opening accepted , Author Thorsten Huck
// 10.4 19.04.2023 HSB-17988 bugfix when referring to windows within sections , Author Thorsten Huck
// 10.3 20.03.2023 HSB-18384 bugfix using font of selected dimstyle , Author Thorsten Huck
// 10.2 02.03.2023 HSB-18186 MetalParts improved within sections and viewports , Author Thorsten Huck
// 10.1 02.03.2023 HSB-17894 new optional selection of entities in viewport mode , Author Thorsten Huck
// 10.0 17.02.2023 HSB-18013 property values auto corrected when updating from version < 9.5 , Author Thorsten Huck
// 9.9 08.02.2023 HSB-17894 pure Acad Viewports now auto collect entities of the selected type if nothing selected by the user , Author Thorsten Huck
// 9.8 13.01.2023 HSB-17528 tag overlapping corrected , Author Thorsten Huck
// 9.7 22.12.2022 HSB-16765 not numbered genbeams and tsls are highlighted if posnum is selected as format variable , Author Thorsten Huck
// 9.6 22.12.2022 HSB-15850 genbeam type considered when in multipages and metalpart collection entity , Author Thorsten Huck
// 9.5 22.12.2022 HSB-16765 new grouped styles added, tag layout more concise, tag background set to nearly white , Author Thorsten Huck
// 9.4 12.12.2022 HSB-17297 blockspace preview enhanced , Author Thorsten Huck
// 9.3 18.11.2022 HSB-17097: make comparison of painter type case irrelevant Author: Marsel Nakuci
// 9.2 03.11.2022 HSB-16960 supports tsl mode when attached to a multipage based on a genbeam , Author Thorsten Huck
// 9.1 07.10.2022 HSB-15850 supports multiapges in modelspace and auto model creation from block space, metalpart collection entities improved, tag outline modified to rounded rectangle , Author Thorsten Huck
// 9.0 27.07.2022 HSB-16117 introducing new OPM control to set formatting, requires hsbDesign 24.1.11 or higher , Author Thorsten Huck
// 8.0 27.07.2022 HSB-16117 branching version hsbDesign 23 or newer , Author Thorsten Huck
// 7.9 06.07.2022 HSB-15902 entity collection based on viewport and zone indices improved, collision detection improved if set to vertical or horizontal , Author Thorsten Huck
// 7.8 04.07.2022 HSB-15902 bugfix if all zones are selected in hsbcad viewport settings , Author Thorsten Huck
// 7.7 13.06.2022 HSB-15730 MetalpartCollection entity in shopdraw and viewport mode enhanced , Author Thorsten Huck
// 7.6 08.06.2022 HSB-15624 new graphical definition of section depth and offset , Author Thorsten Huck
// 7.5 02.06.2022 HSB-15625 bugfix wall extents in section , Author Thorsten Huck
// 7.4 29.03.2022 HSB-14527 components of MetalPartCollectionEntities can be tagged. New functionality to set formatting property via OPM  , Author Thorsten Huck
// 7.3 18.03.2022 HSB-14657 bugfix byZone , Author Thorsten Huck
// 7.2 23.02.2022 HSB-14657 reading dire5ction of text improved, collision displacement imroved , Author Thorsten Huck
// 7.1 11.02.2022 HSB-14657 bugfix when using mode byZone (introduced HSB-13442)
// 7.0 19.11.2021 HSB-13442 supports painter groupBy definition, new context commands to modify settings, automatic painter creation when stored in catalog , Author Thorsten Huck
// 6.9 16.11.2021 HSB-13820 available formats are displayed for genbeam types in shopdraw blockmode , Author Thorsten Huck
// 6.8 20.10.2021 HSB-13443 openings support additional arguments in format variables , Author Thorsten Huck
// 6.7 11.10.2021 HSB-12241 view direction considered for sequencing , Author Thorsten Huck
// 6.6 06.09.2021 HSB-12678 new custom format 'Zone Alignment' to display the relative alignment of a beam within its zone , Author Thorsten Huck
// 6.5 06.07.2021 HSB-12493 format description corrected, Author Thorsten Huck
// 6.4 29.06.2021 HSB-12444 painter support enhanced , Author Thorsten Huck
// 6.3 23.06.2021 HSB-10713 switching to modelspace when adding entities now switches to the selected viewport if multiple viewports exist , Author Thorsten Huck
// 6.2 13.04.2021 HSB-11537 Masselements are added as new type , Author Thorsten Huck
// 6.1 06.04.2021 HSB-10500 Viewports of a floorplan accept genbeams of any zone. Context command enables any zone combination to be set , Author Thorsten Huck
// 6.0 06.04.2021 HSB-11293 Section depth and offset corrected for element viewports , Author Thorsten Huck
// 5.9 06.04.2021 HSB-11088 commands add or remove entities not available for sections and element viewports , Author Thorsten Huck
// 5.8 03.03.2021 HSB-10482 bugfix collecting non solid tsls , Author Thorsten Huck
// 5.7 11.02.2021 HSB-10724 new property 'Sequence' to control sequential exectution with other tagging and dimension tsls , Author Thorsten Huck
// 5.6 22.01.2021 HSB-10157 supports openings from multielements if elements are in the same drawing , Author Thorsten Huck
/// <version value="5.5" date="20oct2020" 703uthor="thorsten.huck@hsbcad.com"> HSB-9338 internal naming bugfix </version>
/// <version value="5.4" date="14oct2020" author="thorsten.huck@hsbcad.com"> HSB-9215 hsbViewTag now supports 2D-Sections which are placed in a host dwg but refer to entities in xRef dwg </version>
/// <version value="5.3" date="30sep2020" author="thorsten.huck@hsbcad.com"> HSB-7705 hsbViewTag will only collect rules and styles which are active definitions, default xml deployed to content general </version>
/// <version value="5.2" date="30sep2020" author="thorsten.huck@hsbcad.com"> HSB-9037 hsbViewTag now supports the xRef selection of ACA sections in modelspace. It also supports xRef entity selection when linked to an ACA viewport </version>
/// <version value="5.1" date="10sep2020" author="thorsten.huck@hsbcad.com"> HSB-7922 bugfix </version>
/// <version value="5.0" date="08sep2020" author="thorsten.huck@hsbcad.com"> HSB-7922 painter definitions can be selected as rule. NOTE version 23 or higher </version>
/// <version value="4.7" date="07sep2020" author="thorsten.huck@hsbcad.com"> HSB-8649 bugfix multiple blank spaces in format </version>
/// <version value="4.6" date="19may2020" author="thorsten.huck@hsbcad.com"> HSB-6159 new settings / override option to specify section depth, property 'descrSF' added to stickframe openings </version>
/// <version value="4.5" date="08may2020" author="thorsten.huck@hsbcad.com"> HSB-7518 empty tags will not be shown anymore </version>
/// <version value="4.4" date="03apr2020" author="thorsten.huck@hsbcad.com"> HSB-7195 added support to select non solid tsls to be displayed </version>
/// <version value="4.3" date="24mar2020" author="thorsten.huck@hsbcad.com"> HSB-7084 Subtype, Information and Code accessible with type element </version>
/// <version value="4.2" date="07feb2020" author="thorsten.huck@hsbcad.com"> HSB-6585 add leader color to settings </version>
/// <version value="4.1" date="30jan2020" author="thorsten.huck@hsbcad.com"> HSB-6472 remove entities fixed, HSB-6437 alignment byEntity fixed for hip/valley rafters </version>
/// <version value="4.0" date="12dec2019" author="thorsten.huck@hsbcad.com"> HSB-6176 Properties added Opening: OpeningDescription,HeightRough,WidthRough and OpeningSF: DescriptionPacking, DescriptionPlate  </version>
/// <version value="3.9" date="09dec2019" author="thorsten.huck@hsbcad.com"> HSB-6161 not resolving opening properties fixed </version>
/// <version value="3.8" date="09oct2019" author="thorsten.huck@hsbcad.com"> HSB-5719 static location text/preview fixed </version>
/// <version value="3.8" date="09oct2019" author="thorsten.huck@hsbcad.com"> HSB-5719 static location text/preview fixed </version>
/// <version value="3.7" date="24Sep2019" author="thorsten.huck@hsbcad.com"> HSB-5089 format variables modelDescription and materialDescription added for TSL's </version>
/// <version value="3.6" date="20Sep2019" author="thorsten.huck@hsbcad.com"> HSB-5634 format variables fixed for elements </version>
/// <version value="3.5" date="02Sep2019" author="thorsten.huck@hsbcad.com"> HSB-5548 byZone supports zone override </version>
/// <version value="3.4" date="02Sep2019" author="thorsten.huck@hsbcad.com"> HSB-4857 grain direction symbol location enhanced </version>
/// <version value="3.3" date="25jul2019" author="thorsten.huck@hsbcad.com"> @(Quantity) groups tsls at same projected location </version>
/// <version value="3.2" date="05jul2019" author="thorsten.huck@hsbcad.com"> Consumes protection range of other view tsls </version>
/// <version value="3.1" date="05jul2019" author="thorsten.huck@hsbcad.com"> HSB-5236 SipComponent.Material and SipComponent.Name supported, HSB-5226 additional drawing and filtering options expsoded through settings HSB-5169 Quantity format uses beampacks to group identical beams if adjacent, settings introduced</version>
/// <version value="3.0" date="26june2019" author="thorsten.huck@hsbcad.com"> HSB-5236 SipComponent.Material and SipComponent.Name supported </version>
/// <version value="2.9" date="26june2019" author="thorsten.huck@hsbcad.com"> Cosmetics </version>
/// <version value="2.8" date="25june2019" author="thorsten.huck@hsbcad.com"> HSB-5226 additional drawing and filtering options expsoded through settings </version>
/// <version value="2.7" date="21june2019" author="thorsten.huck@hsbcad.com"> HSB-5169 Quantity format uses beampacks to group identical beams if adjacent, settings introduced </version>
/// <version value="2.6" date="24may2019" author="thorsten.huck@hsbcad.com"> text alignment improved on static locations of shopdrawings </version>
/// <version value="2.5" date="13may2019" author="thorsten.huck@hsbcad.com"> HSB-4985 insert further improved, requires in layout improved, requires versions 21.4.42, 22.0.77, 23.0.3 or higher </version>
/// <version value="2.5" date="13may2019" author="thorsten.huck@hsbcad.com"> HSB-4985 insert further improved, requires in layout improved, requires versions 21.4.42, 22.0.77, 23.0.3 or higher </version>
/// <version value="2.4" date="30apr2019" author="thorsten.huck@hsbcad.com"> property texture of beam is now supported </version>
/// <version value="2.3" date="30apr2019" author="thorsten.huck@hsbcad.com"> static location aligns text based on top left corner </version>
/// <version value="2.2" date="29apr2019" author="thorsten.huck@hsbcad.com"> massgroups are supported </version>
/// <version value="2.1" date="29apr2019" author="thorsten.huck@hsbcad.com"> metalpart collection entities are supported, using clipBody() instead of combinedClippedBodyOfEntities()to improve performance and robustness on sections </version>
/// <version value="2.0" date="26apr2019" author="thorsten.huck@hsbcad.com"> tsl posnum supported </version>
/// <version value="1.9" date="15apr2019" author="thorsten.huck@hsbcad.com"> bugfix tsl tagging </version>
/// <version value="1.8" date="12apr2019" author="thorsten.huck@hsbcad.com"> bugfix display and calculate weight </version>
/// <version value="1.7" date="12apr2019" author="thorsten.huck@hsbcad.com"> Labeling of TSL's limited to instances with a solid representation' </version>
/// <version value="1.6" date="11apr2019" author="thorsten.huck@hsbcad.com"> ACA section placement corrected </version>
/// <version value="1.5" date="10apr2019" author="thorsten.huck@hsbcad.com"> HSB-4857 supports ACA sections and grain direction symbol </version>
/// <version value="1.4" date="29mar2019" author="thorsten.huck@hsbcad.com"> HSB-4780 quantity for shopdraw and tag mode differentiated </version>
/// <version value="1.3" date="27mar2019" author="thorsten.huck@hsbcad.com"> trusses are supported </version>
/// <version value="1.2" date="26mar2019" author="thorsten.huck@hsbcad.com"> preview of static location enhanced </version>
/// <version value="1.1" date="26mar2019" author="thorsten.huck@hsbcad.com"> execution order fixed if multiple instances operate on the same viewport </version>
/// <version value="1.0" date="22mar2019" author="thorsten.huck@hsbcad.com"> HSBCAD-537 supports hsbcad viewports, Autocad viewports and shopdraw viewports </version>
/// </History>

/// <insert Lang=en>
/// Select properties or catalog entry, then select viewport and pick a point outside of paperspace.
/// </insert>

/// <summary Lang=en>
/// This tsl creates posnum tags in paperspace. A clash detection resolves overlapping tags.
/// Types and formats can be typed in the appropriate properties, but the context menu supports adding and removing of sub entries
/// Various styles of the tag design are available.
/// Format instructions are written as @(<PROPERTY>), i.e. @(Length). If no format instruction is given the posnum will be displayed.
/// Properties of real numbers support rounding instructions, i.e. @(Length:0) will round the length to zero decimals
/// </summary>


/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbViewTag")) TSLCONTENT
// optional commands of this 
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Viewport|") (_TM "|Select tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add/Remove TSL definitions|") (_TM "|Select tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add/Remove Format|") (_TM "|Select tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add No-Tag Area|") (_TM "|Select tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Remove No-Tag Area|") (_TM "|Select tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Set preferred tag areas|") (_TM "|Select tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Remove preferred tag areas|") (_TM "|Select tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Remove preferred tag areas|") (_TM "|Select tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Edit in Place|") (_TM "|Select tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Disable Edit in Place|") (_TM "|Select tool|"))) TSLCONTENT
//endregion

//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug = _bOnDebug;
	if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());		

	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};


	String sKeyDimInfo = "Hsb_DimensionInfo";
	String sSubXKey = "ViewProtect";
	
	int nSequenceOffset = 1000; // a default offset to start all sequences, will be different i.e. for hsbViewDimension

	String sTypes[] = { T("|byZone|"),T("|Beam|"), T("|Sheet|"), T("|Panel|"), T("|GenBeam|"),
		T("|TSL|"),T("|Opening|"), T("|Door|"), T("|Window|"), T("|Window Assembly|"),
		T("|Truss|"), T("|Metalpart|"),T("|Massgroup|"), T("|Element|"),T("|Masselement|"), T("|Fastener Assembly|")};

	String sClassTypes[] = { "GenBeam","Beam", "Sheet", "Panel", "GenBeam",
		"TslInstance","Opening", "Opening", "Opening", "Opening",
		"ToolEnt", "MetalPartCollectionEntity","Entity", "Element","Entity", "FastenerAsssemblyEnt"};



	String sBeamPackDelimiter = "x";	

	String sPainters[] = PainterDefinition().getAllEntryNames().sorted();
	
	// painter groupings PG
	int nSeqColors[] = { 24, 154, 64, 214, 64};
	int ntPG = 80;
	int bHatchSolidPG = false;
	
	String kSectionDepth = "sectionDepth", kSectionOffset = "sectionOffset", kClipRange = "clipRange";
	String kMetalColEnt = "MetalColEnt";
	String kBlockCreationMode = "BlockCreationMode";

	String sDialogLibrary = _kPathHsbInstall + "\\Utilities\\DialogService\\TslUtilities.dll";
	String sClass = "TslUtilities.TslDialogService";	
	String listSelectorMethod = "SelectFromList";
	String optionsMethod = "SelectOption";
	String simpleTextMethod = "GetText";
	String askYesNoMethod = "AskYesNo";
	String showNoticeMethod = "ShowNotice";
	String showMultilineNotice = "ShowMultilineNotice";


//region Color and view	
	int bIsDark;{int n = getBackgroundTrueColor();bIsDark = ((rgbR(n) + rgbB(n) + rgbG(n)) / 3 < 127);}
	int grey = bIsDark?rgb(199,200,202):rgb(99,100,102);
	int white = bIsDark?rgb(255,255,255):rgb(0,0,0);	
	int black = bIsDark?rgb(0,0,0):rgb(255,255,255);
	
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

	Vector3d vecXViewDir = getViewDirection(0);
	Vector3d vecYViewDir = getViewDirection(1);
	Vector3d vecZViewDir = getViewDirection(2);
	double dViewHeight = getViewHeight();	
//endregion 	
	
	
//end Constants//endregion

//region Functions  #FU

//region Function Equals
	// returns true if two strings are equal ignoring any case sensitivity
	int Equals(String str1, String str2)
	{ 
		str1 = str1.makeUpper();
		str2 = str2.makeUpper();		
		return str1==str2;
	}//endregion
	

	//region Fastener Functions
	
//region Function ComponentDataToMap
	// returns a map with the components data
	Map ComponentDataToMap(FastenerComponentData fcd)
	{
		Map m;
	
		m.setString("Name", fcd.name());
		m.setString("Type", fcd.type());
		m.setString("SubType", fcd.subType());
		m.setString("Manufacturer", fcd.manufacturer());
		m.setString("Material", fcd.material());
		m.setString("Model", fcd.model());
		m.setString("Category", fcd.category());
		m.setString("Group", fcd.group());
		m.setString("Coating", fcd.coating());
		m.setString("Grade", fcd.grade());
		m.setString("Norm", fcd.norm());
		m.setString("StackThickness", fcd.stackThickness(),_kLength);
		m.setString("SinkDiameter", fcd.sinkDiameter(),_kLength);
		m.setString("MainDiameter", fcd.mainDiameter(),_kLength);

		return m;
	}//endregion

//region Function ArticleDataToMap
	// returns a map with the article data
	Map ArticleDataToMap(FastenerArticleData fad)
	{ 
		Map m = fad.map();
		//if (m.length() < 1 || !m.hasString("articleNumber"))
		{
			m.setString("ArticleNumber", fad.articleNumber());
			m.setString("Description", fad.description());
			m.setString("Notes", fad.notes());
			m.setDouble("FastenerLength", fad.fastenerLength(), _kLength);
			m.setDouble("ThreadLength", fad.threadLength(), _kLength);
			m.setDouble("MinProjectionLength", fad.minProjectionLength(), _kLength);
			m.setDouble("MaxProjectionLength", fad.maxProjectionLength(), _kLength);
			m.setInt("HasLengthInfo", fad.hasLengthInfo());
			m.setInt("IsBespoke", fad.isBespoke());
		}
		return m;
	}//endregion

//region Function SimpleComponentToMap
	// returns the map of a simple component such as main, head or tail component
	Map SimpleComponentToMap(FastenerSimpleComponent fsc)
	{ 
		Map m;
		
		FastenerArticleData fad = fsc.articleData();
		Map mapArticleData = ArticleDataToMap(fad);
		
		FastenerComponentData fcd = fsc.componentData();
		Map mapComponentData = ComponentDataToMap(fcd);
		
		m.setMap("ComponentData", mapComponentData);
		m.setMap("ArticleData", mapArticleData);
		m.setMapName(fad.articleNumber());
		return m;
	}//endregion	


//region Function GetFastenerDataMap
	// returns a combined map of component and article data
	Map GetFastenerDataMap(FastenerAssemblyEnt fae)
	{ 
		Map out;
		
		FastenerAssemblyDef fadef(fae.definition());
		FastenerListComponent flc = fadef.listComponent();
		Map mapComponentData = ComponentDataToMap(flc.componentData());
		out.copyMembersFrom(mapComponentData);
		
		Map mapArticleData;
		String articleNumber = fae.articleNumber();
		FastenerArticleData fad, fads[] = flc.articleDataSet();
		for (int f=0;f<fads.length();f++) 
		{ 
			String articleNumberF = fads[f].articleNumber(); 
			if (Equals(articleNumber,articleNumberF))
			{ 
				mapArticleData = ArticleDataToMap(fads[f]);
				break;
			}			 
		}//next i		
		out.copyMembersFrom(mapArticleData);
		return out;
	}//endregion

	//endregion 	
		
	//region Function AddProtectionProfile
	// modifies the argument with the given void rings
	void AddProtectionProfile(PlaneProfile& ppIn, PlaneProfile ppAdd)
	{ 
		CoordSys csi = ppIn.coordSys();
		ppAdd.removeAllOpeningRings();
		
		if (ppIn.allRings().length()<1)
		{
			ppIn= ppAdd;
			
		}
		
		PlaneProfile ppSub = ppAdd;
		ppSub.shrink(dEps);
		ppSub.subtractProfile(ppIn);
		
	// overlaps, no additional contribution	
		if (ppSub.allRings(true, false).length()<1)
		{
			// HSB-22810
//			Display dpx(1); dpx.draw(ppAdd,_kDrawFilled,10);;
			return;
		}
		else
		{ 
		// Catch triangle connected shapes by adding a tiny rectangle // HSB-20893
			PlaneProfile ppx = ppIn;
			PlaneProfile ppi(csi);
			if (ppx.intersectWith(ppAdd))
			{ 
				if (ppx.area()<U(1,2))
				{ 
					ppAdd.shrink(-dEps);
					ppx = ppIn;
					ppx.intersectWith(ppAdd);
					
					ppi = ppAdd;
					ppx.createRectangle(ppx.extentInDir(csi.vecX()), csi.vecX(), csi.vecY());
					ppx.shrink(-dEps);
					ppi.unionWith(ppx);
					//Display dpx(5); dpx.draw(ppx,_kDrawFilled,20);;
				}
	
				if (ppx.allRings(true, false).length()>0)
				{
					//Display dpx(3); dpx.draw(ppx,_kDrawFilled,10);
					PLine rings[] = ppi.allRings(true, false);
					for (int r=0;r<rings.length();r++) 
					{
						//rings[r].vis(r);
						
						ppIn.joinRing(rings[r], _kAdd);	
					}

					//ppIn.unionWith(ppi); 				
				}
				else
				{ 
				 	;//Display dpx(1); dpx.draw(ppIn,_kDrawFilled,10);;
				}
			}
			else
			{
				ppx = ppIn;
				ppx.unionWith(ppAdd);
				if (ppx.allRings(true, false).length()>0)
				{
					PLine rings[] = ppAdd.allRings(true, false);
					if (rings.length()>0)
					{
						rings[0].vis(0);
						ppIn.joinRing(rings[0], _kAdd);
						//Display dpx(3); dpx.draw(ppIn,_kDrawFilled,10);;	
					}
						
					//ppIn.unionWith(ppAdd);
					//Display dpx(3); dpx.draw(ppIn,_kDrawFilled,10);;	
				}
				else
				{ 
					ppAdd.shrink(dEps);
					PLine rings[] = ppAdd.allRings(true, false);
					if (rings.length()>0)
						ppIn.joinRing(rings[0], _kAdd);
						
					//Display dpx(41); dpx.draw(ppIn,_kDrawFilled,10);;
				}

					
						
			}
			
			//Display dpx(6); dpx.draw(ppIn,_kDrawFilled,90);;			
		}
		return;
		

		
		
//		ppAdd.project(Plane(_PtW, _ZW), _ZW, dEps);
//		//Display dp(4);		dp.draw(ppAdd, _kDrawFilled, 60);
//		double area0 = ppIn.area();
//		double area1 = ppAdd.area();
//		if (ppIn.allRings().length()<1)
//		{ 
//			out = ppAdd;
//		}
//		else
//		{ 
//			ppAdd.shrink(dEps);
//			PlaneProfile ppt = ppIn;
//			ppt.unionWith(ppAdd);
//			if (ppt.area()>area0)
//			{
//				out= ppt;
////				pp.unionWith(ppAdd);
//			}
//			else
//			{ 
//				ppAdd.shrink(dEps);
//				Display dp(40);		dp.draw(ppAdd, _kDrawFilled, 20);				
//				ppt = ppIn;
//				ppt.unionWith(ppAdd);
//				ppt.unionWith(ppIn);
//				out= ppt;
//			}
//		}
	

		//Display dp(4);		dp.draw(pp, _kDrawFilled, 60);

	}//endregion

	//region Function getMetalPartDefiningEnts
	// returns the beams and sheets of the definition
	// ce: the metalpart collection entity
	void getMetalPartDefiningEnts(MetalPartCollectionEnt ce, Beam& beams[], Sheet& sheets[], TslInst& tsls[])
	{ 
		String def = ce.definition();
		MetalPartCollectionDef cd(def);
	
		beams = cd.beam();
		sheets = cd.sheet();
		tsls = cd.tslInst();

		return;
	}//End getMetalPartDefiningEnts //endregion

	//region Function getMetalPartEntities
	// appends all entitities of a MetalPartCollectionEnt/Def 
	// ce: the metalpart collection entity
	Entity[] getMetalPartEntities(Entity refCE, Entity& ents[])
	{ 	
		MetalPartCollectionEnt ce = (MetalPartCollectionEnt)refCE;
		if (!ce.bIsValid())
		{ 
			return ents;
		}
		String def = ce.definition();
		MetalPartCollectionDef cd(def);
	
		Beam beams[] = cd.beam();
		Sheet sheets[] = cd.sheet();
		TslInst tsls[] = cd.tslInst();
		Entity entsMP[] = cd.entity();
		
		for (int i=0;i<beams.length();i++) 
			if (!beams[i].bIsDummy() && ents.find(beams[i])<0)
				ents.append(beams[i]);
		for (int i=0;i<sheets.length();i++) 
			if (!sheets[i].bIsDummy() && ents.find(sheets[i])<0)
				ents.append(sheets[i]);
		for (int i=0;i<entsMP.length();i++) 
			if (ents.find(entsMP[i])<0)
				ents.append(entsMP[i]);				
		return ents;
	}//End getMetalPartEntities //endregion
	
	//region Function getMetalPartCollectionEntitiesByReference
	// returns
	// t: the tslInstance to 
	MetalPartCollectionEnt[] getMetalPartCollectionEntitiesByReference(Entity entRef)
	{ 
		MetalPartCollectionEnt ces[0];
		
		MultiPage page = (MultiPage)entRef;
		Section2d section = (Section2d)entRef;
		Entity defineSet[0];
		if (page.bIsValid())
			defineSet = page.defineSet();
		else if (section.bIsValid())
		{			
			ClipVolume clipVolume= section.clipVolume();
			if (!clipVolume.bIsValid())
				return MetalPartCollectionEnt();
			defineSet = clipVolume.entitiesInClipVolume(true);//TODO allow multiple
		}
		
		for (int i=0;i<defineSet.length();i++) 
		{ 
			MetalPartCollectionEnt ce =(MetalPartCollectionEnt) defineSet[i]; 
			if (ce.bIsValid())
				ces.append(ce);
		}//next i

		return ces;
	}//End getMetalPartCollectionEntitiesByReference //endregion	

	//region Function IsStackItem
	// returns true or false if the passed entity is a vallid stack item
	int IsStackItem(TslInst t)
	{ 
		return (t.bIsValid() && t.scriptName().find("StackItem", 0, false) == 0);	
	}
	int IsStackPack(TslInst t)
	{ 
		return (t.bIsValid() && t.scriptName().find("StackPack", 0, false) == 0);	
	}
	int IsStackEntity(TslInst t)
	{ 
		return (t.bIsValid() && t.scriptName().find("StackEntity", 0, false) == 0);	
	}//endregion

	//region Function GetStackGenBeams
	// returns the genbeam of stackItem
	// t: the tslInstance to 
	GenBeam[] GetStackItemGenBeams(TslInst t)
	{ 
		Entity ents[] = t.entity();
		GenBeam gbs[] = t.genBeam();
		
		for (int i=0;i<ents.length();i++) 
		{ 
			GenBeam g= (GenBeam)ents[i];
			if (g.bIsValid() && gbs.find(g)<0)
				gbs.append(g);
		}//next i
		
		return gbs;
		
	}//endregion

//endregion 

//region bOnJig
//region Section Jig
	if (_bOnJig && _kExecuteKey=="JigSection") 
	{
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point

		Vector3d vecX = _Map.getVector3d("vecX");
		Vector3d vecY = _Map.getVector3d("vecY");
		Vector3d vecZ = _Map.getVector3d("vecZ");
		
		double dX = _Map.getDouble("dX");
		Point3d ptClip = _Map.getPoint3d("ptClip");
		int bGetOffset = _Map.getInt("getOffset"); // flag if jig shows offset selection
		double sectionDepth = _Map.getDouble(kSectionDepth);
		double sectionOffset = _Map.getDouble(kSectionOffset);
		PlaneProfile ppClipRange = _Map.getPlaneProfile(kClipRange);

		PlaneProfile ppSectionRange = ppClipRange;
		if (bGetOffset) 	
		{
			if (sectionDepth!=0)
				ppSectionRange.createRectangle(LineSeg(ptClip-vecX*dX, ptClip+vecX*dX-vecZ*sectionDepth), vecX, vecY);				
			sectionOffset = abs(vecZ.dotProduct(ptJig - ptClip));
			ppSectionRange.transformBy(-vecZ * sectionOffset);
		}
		else
		{
			Point3d pt = ptClip - vecZ * sectionOffset;
			sectionDepth = abs(vecZ.dotProduct(ptJig - pt));
			ppSectionRange.createRectangle(LineSeg(pt-vecX*dX, pt+vecX*dX-vecZ*sectionDepth), vecX, vecY);
		}

		ppSectionRange.intersectWith(ppClipRange);

	
		Display dpPlan(-1), dpSection(-1);
		dpPlan.trueColor(lightblue, 50);	
		
		if (sectionDepth!=0)
			dpPlan.draw(ppSectionRange, _kDrawFilled);
		else
		{ 
			LineSeg segs[] = ppClipRange.splitSegments(LineSeg(ptJig - vecX * U(10e5), ptJig + vecX * U(10e5)), true);
			dpPlan.trueColor(red, 0);
			dpPlan.draw(segs);
			dpPlan.trueColor(lightblue, 50);
		}
		dpPlan.draw(ppClipRange);
		
		dpSection.trueColor(darkyellow, 50);
		
	// draw intersecting entities
		dpPlan.trueColor(darkyellow, 50);
		Map mapY = _Map.getMap("ProfileY[]");
		Map mapZ = _Map.getMap("ProfileZ[]");
		for (int i=0;i<mapY.length();i++) 
		{ 
			PlaneProfile pp=mapY.getPlaneProfile(i);
			if (mapY.getPlaneProfile(i).intersectWith(ppSectionRange))
			{
				pp.intersectWith(ppClipRange);
				dpPlan.draw(pp, _kDrawFilled);
				
			// model view
				PlaneProfile pp2=mapZ.getPlaneProfile(i);
				pp2.intersectWith(ppClipRange);
				dpSection.draw(pp2, _kDrawFilled);
				
			}
			 
		}//next i
		

//	    _ThisInst.setDebug(TRUE); // sets the debug state on the jig only, if you want to see the effect of vis methods
//	    //ptJig.vis(1);
//	    
//	    double radius = Vector3d(ptJig - ptBase).length();
//
//	    Display dpJ(1);
//	    dpJ.textHeight(U(100));
//	    PLine plCir; 
//	    plCir.createCircle(ptBase, _ZU, radius);
//	    dpJ.draw(plCir);
//	    
	    return;
	}		
//endregion

//region Viewport Selection Jig
	if (_bOnJig && _kExecuteKey == "SelectViewport")
	{
		Point3d ptJig = _Map.getPoint3d("_PtJig"); //running point
		Plane pnZ(_PtW, _ZW);
		Line(ptJig, vecZViewDir).hasIntersection(pnZ, ptJig);
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

//End bOnJig//endregion 

//region DialogMode
	// HSB-13442
	int nDialogMode = _Map.getInt("DialogMode");
	if (nDialogMode>0)
	{ 
		if (nDialogMode == 1) //specify index when triggered to get different dialogs
		{
			setOPMKey(_Map.hasString("opmKey")?_Map.getString("opmKey"):"Settings");

			category = T("|Painter|");
			String sPainterName = T("|Painter|");
			PropString sPainter(nStringIndex++, "", sPainterName);
			sPainter.setDescription(T("|The name of the painter to where these settings apply to.|"));
			sPainter.setCategory(category);
			sPainter.setReadOnly(true);
			
			category = T("|Display|");
			String sSolidHatchName = T("|Solid Hatch|");
			PropString sSolidHatch(nStringIndex++, sNoYes, sSolidHatchName, 1);
			sSolidHatch.setDescription(T("|Defines the if painter subgroups should draw a solid hatch on their visible geometry.|"));
			sSolidHatch.setCategory(category);
			
			String sColorName = T("|Color|");
			PropString sColor(nStringIndex++, "24;154;64;214;64", sColorName);
			sColor.setDescription(T("|Defines the color or sequential colors|") + T("|-1 = byEntity, semicolon separated list = sequential colors|"));
			sColor.setCategory(category);
			
			String sTransparencyName = T("|Transparency|");
			PropInt nTransparency(nIntIndex++, 80, sTransparencyName);
			nTransparency.setDescription(T("|Defines the transparency of the symbol|"));
			nTransparency.setCategory(category);
		}
		return;
	}
//End DialogMode//endregion

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sFileName ="hsbViewTag";
	Map mapSetting;

// find settings file
	String sFolders[]=getFoldersInFolder(sPath); 
	int bPathFound;
	if (_bOnInsert)
		bPathFound= sFolders.find(sFolder)>-1?true:makeFolder(sPath+"\\"+sFolder);	
	String sFullPath = sPath+"\\"+sFolder+"\\"+sFileName+".xml";
	String sFile=findFile(sFullPath); 

// read a potential mapObject
	MapObject mo(sDictionary ,sFileName);
	if (mo.bIsValid())
	{
		mapSetting=mo.map();
		setDependencyOnDictObject(mo);
	}
	// create a mapObject to make the settings persistent	
	else if ((_bOnInsert || _bOnDebug) && !mo.bIsValid() && sFile.length()>0)
	{
		mapSetting.readFromXmlFile(sFile);
		mo.dbCreate(mapSetting);
	}		
//End Settings//endregion

//region Read Settings
	Map mapFilterRules, mapFilterRule, mapPainterGroups;
	Map mapStyles, mapStyle;
	String sRules[0];
	String tBoxBorder = T(", |Frame|");
	String tByEntity = T("|byEntity|");
	String tByHorizontal = T("|Horizontal|");
	String tByVertical = T("|Vertical|");
	String tGrouped = T(", |grouped|");
	
	String sStyles[0],_sStyles[] = {tByEntity, tByHorizontal, tByVertical,
		tByEntity+ tBoxBorder, tByHorizontal+tBoxBorder, tByVertical+tBoxBorder,
		tByEntity+tGrouped, tByHorizontal+tGrouped, tByVertical+tGrouped,
		tByEntity+ tBoxBorder+tGrouped, tByHorizontal+tBoxBorder+tGrouped, tByVertical+tBoxBorder+tGrouped};


{
	String k;
	Map m;

//region Default style settings
	mapStyles= mapSetting.getMap("Style[]");
	if (mapStyles.length() < 1)
	{
		mapStyle.setString("Name", T("|byEntity|"));
		mapStyle.setString("BeamPackDelimiter", sBeamPackDelimiter);
		
		mapStyles.appendMap("Style[]",mapStyle);
	}
		
	for (int i=0;i<mapStyles.length();i++) 
	{ 
		m = mapStyles.getMap(i); 
		String name;
		int bIsActive = true;
		k="Name";		if (m.hasString(k))		name=T(m.getString(k));
		k = "isActive";	if (m.hasInt(k))		bIsActive = m.getInt(k);	// HSB-7705 accept only active style definitions
		if (sStyles.find(name)<0 && name.length()>0 && bIsActive)
			sStyles.append(name);	 
	}//next i
	
// append default styles	
	for (int i=0;i<_sStyles.length();i++) 
	{ 
		if (sStyles.findNoCase(_sStyles[i],-1)<0)
			sStyles.append(_sStyles[i]); 
		 
	}//next i	
	
//End Default rule settings//endregion 

//region Default rule settings
	mapFilterRules= mapSetting.getMap("FilterRule[]");	
	if(mapSetting.length()<1)
	{
		mapSetting.setMap("Style[]", mapStyles);
		mapSetting.setMap("FilterRule[]", mapFilterRules);		
		
		// Trigger ExportDefaultRule//region
			String sTriggerExportDefaultRule = T("|Export Default Settings|");
			addRecalcTrigger(_kContext, sTriggerExportDefaultRule );
			if (_bOnRecalc && _kExecuteKey==sTriggerExportDefaultRule)
			{
				mapSetting.writeToXmlFile(sFullPath);
				mo.dbCreate(mapSetting);
				setExecutionLoops(2);
				return;
			}//endregion				
	}
	
//End Default rule settings//endregion 	

//region Painter Group Settings PG
	mapPainterGroups= mapSetting.getMap("PainterGroup[]");
	
//endregion 

	
}
//End Read Settings//endregion 

//region Properties
// content
	category = T("|Content|");
	String sTypeName=T("|Type|");	
	PropString sType(0, sTypes, sTypeName);		// 0 	
	sType.setDescription(T("|Defines the type of entity which will be collected.|") + T(" |Empty = by current zone, else specify types.|") + T(" |Use context commands to select.|"));
	sType.setCategory(category);
	int nType = sTypes.find(sType, 0);
	int bIsTypeBeam = nType==1;// || nType==0; //HSB-14657 nType==0
	int bIsTypeSheet = nType == 2;//|| nType==0;
	int bIsTypeSip = nType == 3;//|| nType==0;
	int bIsTypeGenbeam = nType == 4  || nType==0; // HSB-14657, Take II // || bIsTypeBeam || bIsTypeSheet || bIsTypeSip
	int bIsTypeTsl = nType == 5;
	int bIsTypeOpening = nType == 6;
	int bIsTypeDoor = nType == 7;
	int bIsTypeWindow = nType == 8;
	int bIsTypeWindowAssembly = nType == 9;
	int bIsTypeTruss = nType == 10;
	int bIsTypeMetalpart = nType == 11;
	int bIsTypeMassgroup = nType == 12;
	int bIsTypeElement = nType == 13;
	int bIsTypeMasselement = nType == 14;
	int bIsTypeFastener = nType == 15;
	
	int bIsTypeAnyOpening = bIsTypeOpening || bIsTypeDoor || bIsTypeWindow || bIsTypeWindowAssembly;

	int bAutoSelectMode = _Map.getInt("AutoSelectMode"); // enables/disables auto selection for viewports

	String sAttributeName=T("|Format|");	// 1
	PropString sAttribute(1, "", sAttributeName);	
	sAttribute.setDescription(T("|Defines the text and/or attributes.|") + " " + T("|Multiple lines are separated by backslash + P|") + " '\P'" + " " + T("|Attributes can also be added or removed by context commands.|"));
	sAttribute.setCategory(category);

// filter
	category = T("|Filter|");	


//region References
	MultiPage page;
	Section2d section;ClipVolume clipVolume;
	
	int bHasSDV, bHasSection, bHasPage, bHasViewport=_Viewport.length()>0;
	
	//endregion 




//region append painter definitions matching the type.
// Painter definitions have priority over rule xml based definitions
	if (sPainters.length()>0)
	{ 
		
	//region Check MetalPart Content
		int bAddBeamPainters = bIsTypeBeam || bIsTypeGenbeam , 
			bAddSheetPainters= bIsTypeSheet || bIsTypeGenbeam,
			bAddGenBeamPainters= bIsTypeGenbeam, 
			bAddTslPainters = bIsTypeTsl;
		
		int bInBlockspace;
		if (_Entity.length()>0 && bIsTypeMetalpart)
		{ 
			
			MetalPartCollectionEnt ces[] = getMetalPartCollectionEntitiesByReference(_Entity[0]);
			
			bInBlockspace = _Entity[0].bIsKindOf(ShopDrawView());
			
			for (int i=0;i<ces.length();i++) 
			{ 
				MetalPartCollectionEnt ce = ces[i]; 
				
				Beam beams[0];
				Sheet sheets[0];
				TslInst tsls[0];
				getMetalPartDefiningEnts(ce, beams, sheets, tsls);
				if (bInBlockspace || beams.length() > 0) {bAddBeamPainters = true; bAddGenBeamPainters = true;}
				if (bInBlockspace || sheets.length() > 0) {bAddSheetPainters = true; bAddGenBeamPainters = true;}
				if (bInBlockspace || tsls.length() > 0) bAddTslPainters = true;				
				 
			}//next i
		}
	//endregion 	
		
		
		
	
		for (int i=0;i<sPainters.length();i++) 
		{ 
			String sPainter = sPainters[i];
			if (sRules.findNoCase(sPainter ,- 1) >- 1)continue;
			
			PainterDefinition painter(sPainter);
			if (painter.bIsValid())
			{ 
				int bAdd = _bOnInsert || bInBlockspace || _Map.getInt(kBlockCreationMode); // add any on bOnInsert or in blockspace
				
			// once inserted allow only those painters which match the selected type	
				if (!bAdd)
				{ 		
					// HSB-17097
					String type = painter.type().makeUpper();	
					if (type == "BEAM" && bAddBeamPainters)	bAdd = true;
					else if (type == "SHEET" && bAddSheetPainters)	bAdd = true;
					else if (type == "PANEL" && (bIsTypeSip || bIsTypeGenbeam))		bAdd = true;
					else if (type == "GENBEAM" && bAddGenBeamPainters)			bAdd = true;
					else if (type == "TSLINSTANCE" && bAddTslPainters)			bAdd = true;
					else if (type == "ENTITY" && bIsTypeMasselement)		bAdd = true;
					else if (type == "METALPARTCOLLECTIONENTITY" && (bIsTypeMetalpart || bAddBeamPainters || bAddSheetPainters || bAddGenBeamPainters))	bAdd = true; //HSB-18943
					else if (type == "ELEMENT" && bIsTypeElement)		bAdd = true;				//HSB-18943
					else if (type == "ELEMENTROOF" && bIsTypeElement)	bAdd = true;				//HSB-18943
					else if (type == "OPENING" && bIsTypeOpening)		bAdd = true;				//HSB-18943
					else if (type == "FastenerAssemblyEnt" && bIsTypeFastener)		bAdd = true;
				}
				if (bAdd)sRules.append(sPainter);
			}
			 
		}//next i


	}





		
//End append painter definitions matching the type//endregion 

// get applicable rules
	{ 
		String k; Map m;
		for (int i=0;i<mapFilterRules.length();i++) 
		{ 
			m = mapFilterRules.getMap(i); 
			String name;
			int _nType;
			int bIsActive = true;
			k = "isActive"; if (m.hasInt(k)) 		bIsActive = m.getInt(k);
			k="Name";		if (m.hasString(k))		name=T(m.getString(k));
			k="Type";		if (m.hasInt(k))		_nType=m.getInt(k);
			
			if (!bIsActive || name.length()<1 || sPainters.findNoCase(name,-1)>-1){ continue;}
			
			if (sRules.find(name)<0 && (nType==0 || nType==_nType))
				sRules.append(name);	 
		}//next i		
	}

	sRules = sRules.sorted();
	sRules.insertAt(0, T("|<Disabled>|"));


	String sRuleName=T("|Painter|") + T("/|Rule|");
// 2
	PropString sRule(2, sRules, sRuleName);	 // prev Index 8
	sRule.setDescription(T("|Specifies a filter rule.|"));
	sRule.setCategory(category);
	if (sRules.length() < 2)sRule.setReadOnly(true);
	if (sRules.find(sRule) < 0  && sRules.length()>0)sRule.set(sRules[0]);
	int nRule = sRules.find(sRule);
	int nPainter = sPainters.findNoCase(sRule ,- 1);
	
	String sPainterGroupingName=T("|PainterGrouping|");	
	PropString sPainterGrouping(8, sNoYes, sPainterGroupingName);	
	sPainterGrouping.setDescription(T("|Defines if the grouping parameters of the painter definition shall be used for groupng the tags|"));
	sPainterGrouping.setCategory(category);
		
//region Painter
	PainterDefinition painter;
	if (nPainter>-1)painter = PainterDefinition (sPainters[nPainter]);
	String sPainterType, sPainterFilter, sPainterFormat;
	if (painter.bIsValid())
	{ 
		sPainterType= painter.type();	
		sPainterFilter= painter.filter();
		sPainterFormat = painter.format();
	}
	int bIsGenBeamPainter = sPainterType == "Beam" || sPainterType == "Sheet" || sPainterType == "Panel" || sPainterType == "GenBeam";
	int bGroupByPainter = painter.bIsValid() && sPainterFormat.find("@(",0,-1)>-1 && sPainterGrouping==sNoYes[1];
//End Painter//endregion 	
	

// collect scriptNames	
	String sScriptNames[] = TslScript().getAllEntryNames();
	String sExcludeScripts[] ={scriptName()};// "bemassung", "dimension", "layout", "preview", "säge", "projektdaten", "hsb_d","ofgravity",
	for (int i=sScriptNames.length()-1; i>=0 ; i--) 
	{ 
		String s = sScriptNames[i];
		s.makeLower();
		if (s.left(3)=="sd_")
			sScriptNames.removeAt(i);	
		else
		{ 
			for (int j=0;j<sExcludeScripts.length();j++) 
			{ 
				if (s.find(sExcludeScripts[j],0)>-1)
				{ 
					sScriptNames.removeAt(i);	
					break;
				} 	 
			}	
		}
	}
	
// order alphabetically
	for (int i=0;i<sScriptNames.length();i++) 
		for (int j=0;j<sScriptNames.length()-1;j++) 
		{
			String s1 = sScriptNames[j];
			String s2 = sScriptNames[j+1];
			
			if (s1.makeUpper()>s2.makeUpper())
				sScriptNames.swap(j, j + 1);
		}

//Display
	category = T("|Display|");
	String sStyleName=T("|Style|");	
// 3
	PropString sStyle(3, "", sStyleName);
// legacy test
	int bSetLegacyTransparency;
	if (sStyles.findNoCase(sStyle,-1)<0)
	{
		String sLegacyStyles[] = {T("|byEntity|"), T("|Horizontal|"), T("|Vertical|"),T("|byEntity|")+ T("+ |Box with border|"), T("|Horizontal|")+ T("+ |Box with border|"), T("|Vertical|")+ T("+ |Box with border|")};
		String sNewStyles[]={tByEntity, tByHorizontal, tByVertical,
			tByEntity+ tBoxBorder, tByHorizontal+tBoxBorder, tByVertical+tBoxBorder,
			tByEntity+tGrouped, tByHorizontal+tGrouped, tByVertical+tGrouped,
			tByEntity+ tBoxBorder+tGrouped, tByHorizontal+tBoxBorder+tGrouped, tByVertical+tBoxBorder+tGrouped};
		int n = sLegacyStyles.findNoCase(sStyle,-1);
		
		//reportNotice("\nlegacy" + n);
		if (n>-1)
		{
			sStyle.set(sNewStyles[n]);
			bSetLegacyTransparency=true;
		}
	}
	sStyle=PropString(3, sStyles.sorted(), sStyleName);	
	sStyle.setDescription(T("|Defines the Style|"));
	sStyle.setCategory(category);
	if (sStyles.find(sStyle) < 0)sStyle.set(tByHorizontal);



	String sPlacementName=T("|Placement|");	
	String sPlacements[] = { T("|Viewport|"), T("|Viewport|") + T(", |not on parent|"),T("|Not on parent|"), T("|Custom|") + T("-> |specify|"), T("|Static Location|")};
	PropString sPlacement(4, sPlacements, sPlacementName);	
	sPlacement.setDescription(T("|Defines the Placement|"));
	sPlacement.setCategory(category);	
	
	String sColorName=T("|Color|");	
	PropInt nColor(nIntIndex++, -2, sColorName);	
	nColor.setDescription(T("|Defines the color.|") + T(" |-2 = byEntity, -1 = byLayer, 0 = byBlock, >0 = color index|"));
	nColor.setCategory(category);
	
	String sTransparencyName=T("|Transparency|");	
	PropInt nTransparency(nIntIndex++, 70, sTransparencyName);	
	nTransparency.setDescription(T("|Enter transparency value, a negative value will use given color, positive value will use white background. Enter value in range [-100, 100]|"));
	nTransparency.setCategory(category);
	if (bSetLegacyTransparency && nTransparency>0) // set to negative transparency if legacy instance (<V9.9) has been detected
	{
		nTransparency.set(nTransparency*-1);
	}
	
	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(0), sTextHeightName);	
	dTextHeight.setDescription(T("|Defines the Text Height|") + " " + T("|0 = byDimstyle|"));
	dTextHeight.setCategory(category);
		
	String sDimStyleName=T("|Dimstyle|");	
	PropString sDimStyle(5, _DimStyles.sorted(), sDimStyleName);	
	sDimStyle.setDescription(T("|Defines the Dimstyle|"));
	sDimStyle.setCategory(category);

	String sSequenceName=T("|Sequence|");
	PropInt nSequence(nIntIndex++, 0, sSequenceName);	
	nSequence.setDescription(T("|Defines the sequence how collisions with other dimlines and tags will be resolved.| ") + T("|-1 = Disabled, 0 = Automatic|"));
	nSequence.setCategory(category);
	// HSB-24122 preparation to remove / disable sequence functionality
	nSequence.setReadOnly(true);
	if (nSequence >- 1)nSequence.set(-1);

// Leader
	category = T("|Leader|");

	String sLineTypes[0]; sLineTypes=_LineTypes.sorted();
	sLineTypes.insertAt(0, T("< |Leader Disabled| >"));
	String sLeaderLineTypeName=T("|Linetype|");	
	PropString sLeaderLineType(6, sLineTypes, sLeaderLineTypeName);	
	sLeaderLineType.setDescription(T("|Defines the linetype of the leader or not to show any leader.|"));
	sLeaderLineType.setCategory(category);
	
	
//region Create Painter by Property
	// HSB-13442
	String sPainterStreamName=T("|Painter Definition|");	
	PropString sPainterStreamProp(7, "", sPainterStreamName);	
	sPainterStreamProp.setDescription(T("|Stores the data of the contact painter definition|"));
	sPainterStreamProp.setCategory(category);
	sPainterStreamProp.setReadOnly(bDebug?false:_kHidden);
	String sPainterStream = sPainterStreamProp;

	if (_bOnDbCreated)
	{
		String _stream = sPainterStreamProp;
		if (_stream.length() > 0)
		{
			// get painter definition from property string	
			Map m;
			m.setDxContent(_stream, true);
			String name = m.getString("Name");
			String type = m.getString("Type").makeUpper();
			String filter = m.getString("Filter");
			String format = m.getString("Format");
			
			// create definition if not present	
			if (m.hasString("Name") && m.hasString("Type") && sPainters.findNoCase(name ,- 1) < 0)//name.find(sPainterCollection, 0, false) >- 1 &&
			{
				PainterDefinition pd(name);
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

// Set hidden property
	if ((_kNameLastChangedProp==sRuleName || sPainterStreamProp.length()==0) && painter.bIsValid())
	{ 
		Map m;
		m.setString("Name", painter.name());
		m.setString("Type",painter.type());
		m.setString("Filter",painter.filter());	
		m.setString("Format",painter.format());	
		
		sPainterStreamProp.set(m.getDxContent(true));
	}	


//End Create Painter by Property//endregion 

	
//End Properties//endregion 

//End Part #1//endregion 


//region Part #1A
//region onInsert
// bOnInsert
	if(_bOnInsert)
	{
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
		{
			setPropValuesFromCatalog(sLastInserted);
			nType = sTypes.find(sType, 0);
			String sClass = sClassTypes[nType];
			sAttribute.setDefinesFormatting(sClass);
			showDialog();
		}
		
		int nPlacement = sPlacements.find(sPlacement);

		nType = sTypes.find(sType, 0);
		bIsTypeBeam = nType==1;// || nType==0; //HSB-14657 nType==0
		bIsTypeSheet = nType == 2;//|| nType==0;
		bIsTypeSip = nType == 3;//|| nType==0;
		bIsTypeGenbeam = nType == 4  || nType==0; // HSB-14657, Take II // || bIsTypeBeam || bIsTypeSheet || bIsTypeSip
		bIsTypeTsl = nType == 5;
		bIsTypeOpening = nType == 6;
		bIsTypeDoor = nType == 7;
		bIsTypeWindow = nType == 8;
		bIsTypeWindowAssembly = nType == 9;
		bIsTypeTruss = nType == 10;
		bIsTypeMetalpart = nType == 11;
		bIsTypeMassgroup = nType == 12;
		bIsTypeElement = nType == 13;
		bIsTypeMasselement = nType == 14;
		bIsTypeFastener = nType == 15;
		bIsTypeAnyOpening = bIsTypeOpening || bIsTypeDoor || bIsTypeWindow || bIsTypeWindowAssembly;


	//region Painter
		nPainter = sPainters.findNoCase(sRule ,- 1);
		if (nPainter>-1)painter = PainterDefinition (sPainters[nPainter]);
		if (painter.bIsValid())
		{ 
			sPainterType= painter.type();	
			sPainterFilter= painter.filter();
			sPainterFormat = painter.format();
		}	
	//endregion 

	// get current space
		int bInLayoutTab = Viewport().inLayoutTab();
		int bInPaperSpace = Viewport().inPaperSpace();
		int bInBlockSpace, bHasSDV;
	// find out if we are block space and have some shopdraw viewports
		Entity entsSDV[0];
		if (!bInLayoutTab)
		{
			entsSDV= Group().collectEntities(true, ShopDrawView(), _kModelSpace);
		
		// shopdraw viewports found and no genbeams or multipages are found
			if (entsSDV.length()>0)
			{ 
				bHasSDV = true;
				Entity ents[]= Group().collectEntities(true, GenBeam(), _kModelSpace);
				ents.append(Group().collectEntities(true, MultiPage(), _kModelSpace));
				if (ents.length()<1)
				{ 
					bInBlockSpace = true;
				}
			}
		}

		CoordSys ms2ps,ps2ms;
		double dScale = 1;
		Vector3d vecX=_XU, vecY=_YU, vecZ = _ZU;

	// distinguish selection mode bySpace
		if (bInBlockSpace)//HSB-18943
			_Entity.append(getShopDrawView(T("|Select shopdraw viewport|")));
			
	// switch to paperspace succeeded: paperspace with viewports
		Section2d sections[0];
		MultiPage pages[0];
		if (_Entity.length()<1)
		{ 
		// papaerspace get viewPort
			if (bInLayoutTab)
			{
				_Viewport.append(getViewport(T("|Select a viewport|")));
			}	
		// modelspace: get Section2d or ClipVolume
			else
			{ 
			// prompt for entities
				Entity ents[0];
				PrEntity ssE(T("|Select reference (Section, Multipage)|"), Section2d());
				ssE.addAllowedClass(MultiPage());
				ssE.allowNested(true);
				if (ssE.go())
					ents.append(ssE.set());
			
			
				for (int i=0;i<ents.length();i++) 
				{ 
					Entity ent = ents[i];
					Section2d section =(Section2d) ent; 
					MultiPage page =(MultiPage) ent; 
					if (section.bIsValid())
						sections.append(section);
					if (page.bIsValid())
					{
						page.regenerate();
						pages.append(page);					
					}
				}//next i
			}			
		}

	// create TSL
		TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
		GenBeam gbsTsl[] = {};		Entity entsTsl[1];			Point3d ptsTsl[] = {_Pt0};
		int nProps[]={nColor,nTransparency, nSequence};
		double dProps[]={dTextHeight};
		String sProps[]={sType,sAttribute,sRule, sStyle,sPlacement,sDimStyle,sLeaderLineType,sPainterStreamProp,sPainterGrouping};
							
		Map mapTsl;

	//region Create by section or page
	
		//region Multipage
		if (pages.length()>0)
		{ 
			CoordSys cs(_PtW, vecX, vecY, vecZ);
			CoordSys ms2ps,ps2ms;
			double dScale = 1;
			MultiPage page = pages.first();
			
			MultiPageView mpvs[] = page.views();
			PlaneProfile ppViewports[0];
			int nViewport = -1;
			
			Map mapArgs;
			Entity showSet[]= page.showSet();		
			
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

		//region  select viewport
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
		//endregion 

			if (nViewport >- 1)
			for (int i=0;i<pages.length();i++) 
			{ 
				MultiPage page = pages[i];
				
				MultiPageView mpv = mpvs[nViewport];
				ViewData vdata = mpv.viewData();//vdatas[nViewport];
				ms2ps = mpv.modelToView();
				ps2ms = ms2ps;
				ps2ms.invert();	

				Vector3d vecModelView = _ZW;
				vecModelView.transformBy(ps2ms);
				vecModelView.normalize();				
				
				mapTsl.setVector3d("ModelView", vecModelView);
				
				entsTsl[0] = page; 
				tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl); 
			}//next i
		}
		//endregion 

	
		for (int i=0;i<sections.length();i++) 
		{ 
			entsTsl[0] = sections[i]; 
			tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl); 
		}//next i



		if (sections.length()>0 || pages.length()>0)
		{ 
			eraseInstance();
			return;				
		}
	//endregion 

	// distinguish insertion point upon mode
		if (nPlacement == 4 || bInBlockSpace)
			_Pt0 = getPoint(T("|Insert point|"));
		else if (_Viewport.length()>0)
		{
			int bSuccess = Viewport().switchToModelSpace();
			bSuccess = _Viewport[0].setCurrent();
			
			String prompt2 = T(", |<Enter> for auto selection|");
			
			// HSB-17894 optional auto selction
			Entity _ents[0];
			if (bSuccess)
			{ 
			// prompt for entities
				PrEntity ssE;
				if (bIsTypeBeam)ssE = PrEntity(T("|Select beams|")+prompt2, Beam());
				else if (bIsTypeSheet)ssE = PrEntity(T("|Select sheets|")+prompt2, Sheet());
				else if (bIsTypeSip)ssE = PrEntity(T("|Select sips|")+prompt2, Sip());
				else if (bIsTypeGenbeam)ssE = PrEntity(T("|Select genbeams|")+prompt2, GenBeam());
				else if (bIsTypeTsl)ssE = PrEntity(T("|Select tsl(s)|")+prompt2, TslInst());
				else if (bIsTypeAnyOpening)ssE = PrEntity(T("|Select openings|")+prompt2, Opening());	
				else if (bIsTypeTruss)ssE = PrEntity(T("|Select trusses|")+prompt2, TrussEntity());
				else if (bIsTypeMetalpart)ssE = PrEntity(T("|Select metalparts|")+prompt2, MetalPartCollectionEnt());
				else if (bIsTypeMassgroup)ssE = PrEntity(T("|Select massgroups|")+prompt2, MassGroup());
				else if (bIsTypeElement)ssE = PrEntity(T("|Select elements|")+prompt2, Element());
				else if (bIsTypeMasselement)ssE = PrEntity(T("|Select elements|")+prompt2, MassElement());
				else if (bIsTypeFastener)ssE = PrEntity(T("|Select elements|")+prompt2, FastenerAssemblyEnt());
				ssE.allowNested(true);
				if (ssE.go())
				{
					_ents = ssE.set();
					
				// store the selected scripts
					if (bIsTypeTsl)
					{ 
						if (painter.bIsValid())
						{ 
							_ents = painter.filterAcceptedEntities(_ents);
						}
						else
						{ 
							Map mapExplicitTsls;
							String sScripts[0];
							for (int i=_ents.length()-1; i>=0 ; i--) 
							{ 
								TslInst t= (TslInst)_ents[i]; 
								if (!t.bIsValid()) 
								{
									_ents.removeAt(i);
									continue;
								}
								String name = t.scriptName();
								if (t.bIsValid() && sScripts.find(name)<0)
								{
									sScripts.append(name);
									mapExplicitTsls.appendString("Script", name);
								}
							}//next i
							_Map.setMap("ExplicitTsl[]",mapExplicitTsls);							
						}
					}

					_Entity.append(_ents);
				}
				bSuccess = Viewport().switchToPaperSpace();	
			}
			
			if (_ents.length()<1)
			{ 
				bAutoSelectMode = true;
				_Map.setInt("AutoSelectMode", bAutoSelectMode);
			}

			_Pt0 = getPoint(T("|Pick a point outside of paperspace|")); 
			
			
			
		}
		
		return;
	}	
	
//End onInsert//endregion 

//End Part #1A//endregion 

//region Part #2

//region Standards

	int nTick;
	if (bDebug)	nTick = getTickCount();// performance test
	_ThisInst.setDrawOrderToFront(true);
	if (_bOnDbCreated)setExecutionLoops(2);
	if (nSequence > 0)_ThisInst.setSequenceNumber(nSequence);
	
// some variables
	double dXVp, dYVp; // X/Y of viewport/shopdrawviewport
	Point3d ptCenVp=_Pt0;
	int nActiveZoneIndex, bEveryZone;
	
	Element el;
	ElementMulti em;
	int bIsElementViewport;	
	Point3d ptMidEl;
	LineSeg segEl;

	CoordSys ms2ps, ps2ms;		
	double scale = 1;
	
	int nPlacement = sPlacements.find(sPlacement);
	int nLineType = sLineTypes.find(sLeaderLineType);
	int bNotOnParent = nPlacement == 1 || nPlacement == 2;
	int bHasStaticLoc= nPlacement == 4;
	int nStyle = _sStyles.find(sStyle);

	
	int bIsGrouped = sStyle.find(tGrouped ,0,false) >- 1;
	int bByEntity = sStyle.find(tByEntity ,0,false) >- 1;
	int bByVertical= sStyle.find(tByVertical ,0,false) >- 1;
	int bByHorizontal= sStyle.find(tByHorizontal ,0,false) >- 1;
	int bDrawBorder = sStyle.find(tBoxBorder ,0,false) >- 1;
	int nOrientation = bByHorizontal ? 1 : (bByVertical ? 2 : 0);

	int bDrawLeader = nLineType>0;
	int nLeaderFactorX = bDrawLeader?2:0;
	int nLeaderFactorY = bDrawLeader?1:0;
	
// TSL Specials	
	int bAddScriptAll, bAddSolidScript = true;
	String sScripts[0];
	Map mapExplicitTsls = _Map.getMap("ExplicitTsl[]");
	if (bIsTypeTsl)
	{ 
		for (int i=0;i<mapExplicitTsls.length();i++) 
		{ 
			String script;
			if(mapExplicitTsls.hasString(i))  script=mapExplicitTsls.getString(i);
			if (sScripts.findNoCase(script ,- 1) < 0)sScripts.append(script); 
		}//next i		
	}





	int nc = nColor;
	if (nc == 0) nc = _ThisInst.color();
	int ncBorder=nc, ncBackground = nc, ncLeader=nc, ncText = nc;	
	int ntBackground = nTransparency;
	if (ncLeader < 1)ncLeader = nc;

	// section: filter items by location
	int bHasSectionDepth;	// true if a section depth (also 0!) is given
	double dSectionOffset;// specifies an offset of the section line, in conjunction with SectionDepth the entities can be filtered by location
	double dSectionDepth; // if the section depth is not given all entities will be shown, a value = 0 means only on section line, value >0 only entities which intersect within this range


// get contrast text color
	if (ntBackground>-20 && ntBackground<0)
	{ 
		int bIsDark;
		int nLightColors[] = { 2, 3,4, 9, 253, 254, 255};
		if (ncText>9 && ncText<250)
		{ 
			int x = String(ncText).right(1).atoi();
			if (x >3) bIsDark=true;
		}
		else if (nLightColors.find(ncText)<0)
			bIsDark = true;
		ncText = bIsDark ? 255 : 7;
		if (!bIsDark)
		{
			ncLeader = ncText;
			ncBorder = ncText;
		}
	}



	String sAutoAttribute = sAttribute;
	if (sAutoAttribute.length() == 0)
	{
		if (painter.bIsValid() && painter.formatToResolve().find("@(",0,false)>-1)
		{ 
			sAutoAttribute = painter.formatToResolve();
		}
		else if (nType<5)sAutoAttribute = "@(PosNum)";
		else if (bIsTypeTsl)sAutoAttribute = "@(Scriptname)";
		else if (bIsTypeMetalpart)sAutoAttribute = "@(Definition)";
		else if (bIsTypeMassgroup)sAutoAttribute = "@(PosNum)";
		else if (bIsTypeElement)sAutoAttribute = "@(ElementNumber)";
		else if (bIsTypeMasselement)sAutoAttribute = "@(Width) x @(Height)";
		else if (bIsTypeFastener)sAutoAttribute = "@(Definition)";
		else sAutoAttribute = "@(Width) x @(Height)";
	}
	
	int bEditInPlace=_Map.getInt("directEdit"); // the flag if tags are shown with grip points
//End some ints//endregion 

//region GetStyleMap
	nStyle = sStyles.find(sStyle);
	if (nStyle>-1)
	{ 
		for (int i=0;i<mapStyles.length();i++) 
		{ 
			Map m= mapStyles.getMap(i);
			if (T(m.getString("Name"))==sStyle)
			{ 
				mapStyle = m;
				break;
			}		 
		}//next i
	}
	
// if style map is found use overrides and set properties to read only
	if (mapStyle.length()>0)
	{ 
		String k; Map m,m2;
		m = mapStyle;
		
		k="BeamPackDelimiter";		if (m.hasString(k))		sBeamPackDelimiter=m.getString(k);
		k="Orientation";			if (m.hasInt(k))		nOrientation=m.getInt(k);
		
	// border
		m2 = Map();
		k="Border";					if (m.hasMap(k))		m2=m.getMap(k);		
		k="Color";					if (m2.hasInt(k))		{ncBorder=m2.getInt(k); bDrawBorder=true;}

	// background
		m2 = Map();
		k="Background";				if (m.hasMap(k))		m2=m.getMap(k);		
		k="Color";					if (m2.hasInt(k))		ncBackground=m2.getInt(k);	
		k="Transparency";		
		if (m2.hasInt(k))	// the property is overwritten on dbCreation or when the style is changed	
		{
			int _n=m2.getInt(k);
			if ((_bOnDbCreated || _kNameLastChangedProp==sStyleName) && _n != nTransparency)
			{
				nTransparency.set(_n);
				ntBackground = nTransparency;
			}
		}

	// text	
		m2 = Map();
		k="Text";					if (m.hasMap(k))		m2=m.getMap(k);		
		k="Color";
		if (m2.hasInt(k)) // the property is overwritten on dbCreation or when the style is changed
		{
			nc=m2.getInt(k);
			if ((_bOnDbCreated || _kNameLastChangedProp==sStyleName) && nc != nColor)
				nColor.set(nc);			
		}
		k="TextHeight";				
		if (m2.hasDouble(k))// the property is overwritten on dbCreation or when the style is changed
		{
			double _dTextHeight=m2.getDouble(k);
			if ((_bOnDbCreated || _kNameLastChangedProp==sStyleName) && _dTextHeight != dTextHeight)
				dTextHeight.set(_dTextHeight);
		}

	// Leader	
		k="Leader";					if (m.hasMap(k))	m2=m.getMap(k);	
		k="Color";					if (m2.hasInt(k))	ncLeader=m2.getInt(k);
		k="FactorX";				if (m2.hasInt(k))	nLeaderFactorX=m2.getInt(k);
		k="FactorY";				if (m2.hasInt(k))	nLeaderFactorY=m2.getInt(k);
	}


	Map mapFormats;
	if (nRule>0 && nPainter<0)
	{ 
		String k;
		for (int i=0;i<mapFilterRules.length();i++) 
		{ 
			Map m= mapFilterRules.getMap(i);
			if (T(m.getString("Name"))==sRule)
			{ 
				mapFilterRule = m;
				mapFormats = m.getMap("Format[]");

				k="SectionDepth";	if (m.hasDouble(k))	{bHasSectionDepth = true;dSectionDepth=m.getDouble(k);}
				k="SectionOffset";	if (m.hasDouble(k) && bHasSectionDepth)	dSectionOffset=m.getDouble(k);				
				break;
			}		 
		}//next i
	}

// Get PG PainterGroupSettings
	if (bGroupByPainter && mapPainterGroups.length()>0)
	{ 
		String k,sColorList,painterPG = sRule;
		painterPG.makeLower();
		for (int i=0;i<mapPainterGroups.length();i++) 
		{ 
			Map m= mapPainterGroups.getMap(i);
			if (m.getMapName().makeLower() ==painterPG )
			{ 
				k= "ColorList"; 	if(m.hasString(k))	sColorList = m.getString(k);
				k= "HatchSolid"; 	if(m.hasInt(k))		bHatchSolidPG = m.getInt(k);
				k= "Transparency"; 	if(m.hasInt(k))		ntPG = m.getInt(k);
				
				String tokens[] = sColorList.tokenize(";");
				if (tokens.length()>0)
				{ 
					nSeqColors.setLength(0);
					for (int j=0;j<tokens.length();j++) 
						nSeqColors.append(tokens[j].atoi()); 
				}				
			}			 
		}//next i		
	}



// use sectionDepth override if specified HSB-6159
	{ 
		String k;
		Map m = _Map;
		k=kSectionDepth;	
		if (m.hasDouble(k))	
		{
			dSectionDepth=m.getDouble(k);
			bHasSectionDepth = dSectionDepth!=0;
		}
		k=kSectionOffset;	if (m.hasDouble(k))	dSectionOffset=m.getDouble(k);	
	}

//End GetFilterRule//endregion 
		
//End Part #2//endregion 

//region Part #3

//region Get defining viewport entity

// other hsbViewXXX- Instances attached to the parent 
	Entity entTags[0];
	CoordSys csW(_PtW, _XW, _YW, _ZW);
	PlaneProfile ppProtect(csW);

//region Collect parent entities
	if (_Entity.length()<1 && _Map.getInt(kBlockCreationMode)) 
	{ 
		return;
	}
	else if (_Entity.length()>0 && _Map.hasInt(kBlockCreationMode)) 
		_Map.removeAt(kBlockCreationMode, true);

	ShopDrawView sdv;	
	Entity entsDefineSet[0],entsShowset[0];
	
	for (int i=0;i<_Entity.length();i++) 
	{ 
		sdv = (ShopDrawView)_Entity[i]; 
		if (sdv.bIsValid())
		{ 
		// interprete the list of ViewData in my _Map
			ViewData viewDatas[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets,0); // 2 means verbose
			int nIndex = ViewData().findDataForViewport(viewDatas, sdv);// find the viewData for my view
			if (nIndex>-1)
			{ 
				ViewData viewData = viewDatas[nIndex];
				double scale = viewData.dScale();
				dXVp = viewData.widthPS();//*scale;
				dYVp = viewData.heightPS();//*scale;
				ptCenVp= viewData.ptCenPS();
				
				ms2ps = viewData.coordSys();
				ps2ms = ms2ps; ps2ms.invert();
				
				entsDefineSet = viewData.showSetDefineEntities();
				entsShowset = viewData.showSetEntities();
				for (int j=0;j<entsDefineSet.length();j++) 
				{ 
					el= (Element)entsDefineSet[j]; 
					if (el.bIsValid())break;					 
				}//next j
			}
			bHasSDV = true;
			break;
		}
		section = (Section2d)_Entity[i]; 
		if (section.bIsValid())
		{
			bHasSection = true;
			clipVolume= section.clipVolume();
			if (!clipVolume.bIsValid())
			{ 
				eraseInstance();
				return;
			}

		// get transformation	
			_Entity.append(clipVolume);
			ms2ps = section.modelToSection();	
			//ms2ps.transformBy(_ZW*_ZW.dotProduct(section.coordSys().ptOrg()-ms2ps.ptOrg()));				
			ms2ps.vis(3);
			ps2ms = ms2ps; ps2ms.invert();
			
			entsShowset = clipVolume.entitiesInClipVolume(true); // HSB-9215 resolve entities from xrefs
			_ThisInst.setAllowGripAtPt0(false);
			setDependencyOnEntity(section);
			//setDependencyOnEntity(clipVolume);
		
		// get other tagging entities from section HSB-8276
			entTags= Group().collectEntities(true, TslInst(), _kMySpace);
			for (int j=entTags.length()-1; j>=0 ; j--) 
			{ 
				TslInst t=(TslInst)entTags[j]; 
				if (!t.bIsValid())
				{ 
					entTags.removeAt(j); 
					continue;
				}
				Entity ents[] = t.entity();
				if (ents.find(section) < 0)entTags.removeAt(j);		
			}//next j		
			
			break;
		}

	//region Multipage
		page = (MultiPage)_Entity[i];
		bHasPage = page.bIsValid();	
		if (bHasPage)
		{ 
			setDependencyOnEntity(page);
			assignToGroups(page, 'I');
			entsDefineSet = page.defineSet();

		// keep relative löocation to multipage 
			Point3d ptOrg = page.coordSys().ptOrg();
			if (_Map.hasVector3d("vecOrg") && _kNameLastChangedProp!="_Pt0")
				_Pt0 = ptOrg + _Map.getVector3d("vecOrg");	


			Vector3d vecModelView = _Map.getVector3d("ModelView");
			ppProtect = PlaneProfile(csW);
			Map mapArgs;
			MultiPageView mpvs[] = page.views();
			PlaneProfile ppViewports[0];		
	
			for (int v = 0; v < mpvs.length(); v++)
			{
				MultiPageView& mpv = mpvs[v];
				PlaneProfile pp(csW);
				PLine plShape = mpv.plShape();
				pp.joinRing(plShape, _kAdd);		//pp.vis(v);
				ppViewports.append(pp);
				mapArgs.appendPlaneProfile("pp", pp);
				
				Vector3d vecView = vecModelView;
				vecView.transformBy(mpv.modelToView());
				vecView.normalize();
				
				if (vecView.isCodirectionalTo(_ZW))
				{
					ptCenVp = pp.ptMid();
					vecView.vis(ptCenVp, i);
					
					//mpv.viewData().coordSys().vecZ().vis(pt + _XW * U(100), 4);
					ms2ps = mpv.modelToView();
					ps2ms = ms2ps; ps2ms.invert(); 
					ViewData vdata = mpv.viewData();//vdatas[nViewport];
					scale = vdata.dScale();

					entsShowset = mpv.showSet();
					dXVp = pp.dX();
					dYVp = pp.dY();
	//				ppView.joinRing(mpv.plShape(), _kAdd);
	//				pnView = mpv.snapPlaneInModel();
					
					//Add ruleset dimlines to protected range
					PlaneProfile pps[] = mpv.dimCollisionAreas(false);
					for (int x = 0; x < pps.length(); x++)
						ppProtect.unionWith(pps[x]);
						
					
					break;
				}
				
			}
			
	
		// store current location relative to mp location
			Vector3d vecOrg = Vector3d(_Pt0 - ptOrg);
			_Map.setVector3d("vecOrg", vecOrg);	
				
			//_Pt0.vis(1);
			//return;
		}
	//endregion 

	}//next i


//End Collect parent entities//endregion 

//region BlockSpace // HSB-15850
	if (bHasSDV)
	{ 
	// on generate shopdrawing	
		if (_bOnGenerateShopDrawing)
		{
		// Get multipage from _Map
			Entity entCollector = _Map.getEntity(_kOnGenerateShopDrawing +"\\entCollector");
			Map mapTslCreatedFlags = entCollector.subMapX("mpTslCreatedFlags");
			String uid = _Map.getString("UID"); // get the UID from map as instance does not exist onGenerateShopDrawing
			int bIsCreated = mapTslCreatedFlags.hasInt(uid);		
			
			ViewData viewDatas[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets, 0);
			int nIndFound = ViewData().findDataForViewport(viewDatas, sdv);//find the viewData for my view
			if (!bIsCreated && entCollector.bIsValid() && nIndFound>-1)
			{ 						
				ViewData viewData = viewDatas[nIndFound];
			
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
				int nProps[]={nColor,nTransparency,nSequence};			
				double dProps[]={dTextHeight};				
				String sProps[]={sType,sAttribute,sRule, sStyle,sPlacement,sDimStyle,sLeaderLineType,sPainterStreamProp,sPainterGrouping};
				Map mapTsl;	
				
				mapTsl.setVector3d("vecOrg", _Pt0 - _PtW); // relocate to multipage
				mapTsl.setVector3d("ModelView", vecAllowedView);// the offset from the viewpport
				// HSB-23183
				if(_Map.hasInt("TextAlignmentX"))
				{
					mapTsl.setInt("TextAlignmentX", _Map.getInt("TextAlignmentX"));	
				}
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
			return;
		}
		
		_Map.setString("UID", _ThisInst.uniqueId()); // store UID to have access during _kOnGenerateShopDrawing
			
	// set formatting
		String sClass = sClassTypes[nType];
		
		String vars[] = _ThisInst.formatObjectVariables(sClass);
		String sDoubleVars[] = { "Width", "Height", "Length", "SolidWidth", "SolidHeight", "SolidLength", "SizeX", "SizeY", "SizeZ", "GroupFloorHeight", "GroupHeight"};
		String sIntVars[] = { "ColorIndex", "Posnum"};
		
		Map mapAdd;
		for (int i=0;i<vars.length();i++) 
		{ 
			String key = vars[i];
			if (sDoubleVars.findNoCase(key,-1)>-1)
				mapAdd.appendDouble(key,U(500)+ i*U(1), _kLength); 
			else if (sIntVars.findNoCase(key,-1)>-1)
				mapAdd.appendDouble(key,i+1);
			else
				mapAdd.appendString(vars[i],vars[i]); 
			 
		}//next i
		
		
		Vector3d vecX = nOrientation==2?_YW:_XW;
		Vector3d vecY = nOrientation==2?-_XW:_YW;
		Vector3d vecZ = _ZW;
		
		sAttribute.setDefinesFormatting(sClass,mapAdd);
		String text = _ThisInst.formatObject(sAttribute, mapAdd);
		if (text.length()<1 && sdv.bIsValid()) // HSB-17297 blockspace preview enhanced
			text = sAttribute.length()<1?sAutoAttribute:sAttribute;
		
		
		
		Display dp(nc), dpLeader(ncLeader), dpBackground(-1);
		dpBackground.trueColor(rgb(255, 255, 254), abs(nTransparency));
		dp.dimStyle(sDimStyle);
		double dTextHeightStyle = dp.textHeightForStyle("O",sDimStyle);
		if (dTextHeight>0)
		{
			dTextHeightStyle=dTextHeight;
			dp.textHeight(dTextHeight);
		}

		Point3d ptTxt = _Pt0;

	// border
		double dXB = dp.textLengthForStyle(text, sDimStyle, dTextHeightStyle);
		double dYB = dp.textHeightForStyle(text, sDimStyle, dTextHeightStyle);
		PLine plBoundary(vecZ);
		Vector3d vec = .5 * (dXB * vecX + dYB * vecY);
		plBoundary.createRectangle(LineSeg(ptTxt-vec, ptTxt+vec),vecX, vecY);
		plBoundary.offset(-.125 * dTextHeightStyle, true);	
		if (bDrawBorder)
		{ 
			if (nTransparency>0 && nTransparency<100)
				dpBackground.draw(PlaneProfile(plBoundary), _kDrawFilled);	
			else if (nTransparency<0 && nTransparency>-100)	
				dp.draw(PlaneProfile(plBoundary), _kDrawFilled);
			dp.draw(plBoundary);			
		}
		if (bDrawLeader)
		{ 
			Point3d pts[] = sdv.gripPoints();
			pts = Line(_Pt0, _XW).orderPoints(pts);
			if (pts.length()>0)
				dXVp = _XW.dotProduct(pts.last() - pts.first());
			pts = Line(_Pt0, _YW).orderPoints(pts);
			if (pts.length()>0)
				dYVp = _YW.dotProduct(pts.last()-pts.first());
			ptCenVp.setToAverage(pts);	
			vec = .5 * (dXVp * _XW + dYVp * _YW);
			PLine rect; rect.createRectangle(LineSeg(ptCenVp-vec, ptCenVp+vec), _XW,_YW);			
			
			
			Point3d pt1 = rect.closestPointTo(ptTxt);
			pt1 = plBoundary.closestPointTo(pt1);	pt1.vis(3);
			

			Point3d pt2 = rect.closestPointTo(pt1);
			
			Vector3d vecA = pt2 - pt1; vecA.normalize();
			Vector3d vecB = vecA.crossProduct(-_ZW);
			double d = (pt2 - pt1).length()*.25;
			pt2 = rect.closestPointTo(pt1+(vecA*d+vecB*d));
			dp.draw(PLine (pt1, pt1+vecA*d, pt2));
		}
		
		// HSB-23183
		int nTextAlignmentX;// center is default
		if (bHasStaticLoc)
		{ 
			nTextAlignmentX = _Map.hasInt("TextAlignmentX") ? _Map.getInt("TextAlignmentX") : 1;
			
			int nAlignments[] ={ - 1, 0, 1};
			String sAlignments[] ={ T("|Text Alignemnt Left|"), T("|Text Alignemnt Center|"), T("|Text Alignemnt Right|")};
			int x = nAlignments.find(nTextAlignmentX);
			for (int i=0;i<nAlignments.length();i++) 
			{ 
				if (x == i)continue;
				
				addRecalcTrigger(_kContextRoot, sAlignments[i]);
				if (_bOnRecalc && _kExecuteKey==sAlignments[i])
				{
					nTextAlignmentX = nAlignments[i];
					_Map.setInt("TextAlignmentX", nTextAlignmentX);		
					setExecutionLoops(2);
					return;
				}
			}//next i
		}
		
	// text	
		ptTxt.vis(22);
		// HSB-23183
//		dp.draw(text, ptTxt, vecX, vecY, 0, 0);
		dp.draw(text, ptTxt, vecX, vecY, nTextAlignmentX, (bHasStaticLoc?-1:0));
		
		return;
	}
//endregion 

// it has no shopdraw viewport and no viewport
	if (!bHasPage && !bHasSDV && !bHasViewport && !bHasSection)// && Viewport().switchToPaperSpace()) 
	{
		reportMessage("\n" + scriptName() + ": " +T("|no reference found, tool will be purged.|"));
		eraseInstance();	
		return; // _Viewport array has some elParents
	}
	
// get viewport data
	Viewport vp;
	if (bHasViewport)
	{ 
		vp = _Viewport[_Viewport.length()-1]; // take last element of array
		_Map.setString("ViewHandle", vp);
		_Viewport[0] = vp; // make sure the connection to the first one is lost
		ms2ps = vp.coordSys();
		ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps
	
		dXVp = vp.widthPS();
		dYVp = vp.heightPS();
		ptCenVp= vp.ptCenPS();	
	
	// check if the viewport has hsb data
		el = vp.element();
		
		if (el.bIsValid())
			nActiveZoneIndex = vp.activeZoneIndex();
		else
			nActiveZoneIndex = 999;//HSB-10500 allow any zone
		bEveryZone = nActiveZoneIndex == 999 ? true : false; // HSB-15902
		entTags= Group().collectEntities(true, TslInst(), _kMySpace);	
	}





// element viewport/shopdraw viewport
	bIsElementViewport = el.bIsValid();
	Map mapParent, mapParents=_Map.getMap("Parent[]");//_ThisInst.subMapX("Parent[]"); // the map wich stores the grip relation
	if (bIsElementViewport)
	{ 
		em = (ElementMulti)el;	
		segEl = el.segmentMinMax();
		segEl.transformBy(ms2ps);
		ptMidEl = segEl.ptMid();ptMidEl.vis(2);
		
		if (mapParents.hasMap(el.handle()))
			mapParent = mapParents.getMap(el.handle());
	}
	else if (mapParents.hasMap("View"))
		mapParent = mapParents.getMap("View");
	//reportMessage("\nXXX is element viewport");

// scale	
	Vector3d vecScale(1, 0, 0);
	vecScale.transformBy(ps2ms);
	double dScale = vecScale.length();
	double dEpsPS = dScale<1?dEps * dScale:dEps;


// get viewdirection in model
	Vector3d vecXView = _XW;	vecXView.transformBy(ps2ms);	vecXView.normalize();
	Vector3d vecYView = _YW;	vecYView.transformBy(ps2ms);	vecYView.normalize();
	Vector3d vecZView = _ZW;	vecZView.transformBy(ps2ms);	vecZView.normalize();
	vecZView.vis(_Pt0, 4);//el.ptOrg()

	int bIsPlanView = vecZView.isParallelTo(Vector3d(0, 0, 1));
	

//region Order tagging entities by sequence number
// order by sequence number
	TslInst tslSeqs[0];
	int nSequences[0];
	for (int i=0;i<entTags.length();i++) 
	{ 
		TslInst t = (TslInst)entTags[i];
		if (!t.bIsValid() || t.sequenceNumber()<0 || t.subMapXKeys().find(sSubXKey)<0) {continue;}
		
		Map m = t.subMapX(sSubXKey);
		
		Vector3d _vecZView = m.getVector3d("vecZView");
		if(!_vecZView.bIsZeroLength() && !_vecZView.isParallelTo(vecZView))
		{
			continue;
		}
		else			
		{
			tslSeqs.append(t);
			nSequences.append(t.sequenceNumber());
		}		
//		if (t.bIsValid() && t.sequenceNumber()>=0 && 
//			t.subMapXKeys().find(sSubXKey) >-1)// sSubXKey qualifies tsls with protection area
//			{
//				tslSeqs.append(t);
//				nSequences.append(t.sequenceNumber());
//			}
	}
	for (int i=0;i<tslSeqs.length();i++) 
		for (int j=0;j<tslSeqs.length()-1;j++) 
			if (nSequences[j]>nSequences[j+1])
			{
				tslSeqs.swap(j, j + 1);
				nSequences.swap(j, j + 1);
			}
				
// set sequence number during relevant events
	if (nSequence==0)//(_bOnDbCreated || _kNameLastChangedProp==sSequenceName) && 
	{ 
		int nNext = nSequenceOffset;
		for (int i=0;i<nSequences.length();i++) 
			if (nSequences.find(nNext)>-1)
			{
				//reportMessage("\n" + _ThisInst.handle()+ ": "+ nNext + " found in " +nSequences);
				nNext++;
			}
		nSequence.set(nNext);
		if (bDebug)reportMessage("\n" + _ThisInst.handle() + " sequence number set to " + nSequence);
		setExecutionLoops(2);
		return;
	}

// add/remove dependency to any sequenced tsl with a lower sequence number
	int nThisIndex = tslSeqs.find(_ThisInst);
	
	//if (bDebug)reportNotice("\n" + scriptName() + " "+_ThisInst.handle() + " with sequence " + nSequence + " rank " + nThisIndex+ " depends on");
	for (int i=0;i<tslSeqs.length();i++) 
	{ 
		TslInst t = tslSeqs[i];
		int x = _Entity.find(t);
		if(i<nThisIndex)
		{ 
			_Entity.append(t);
			setDependencyOnEntity(t);
			if (bDebug)reportNotice("\n	" + t.handle() +" "+t.scriptName()+ " with sequence " + t.sequenceNumber());
		}
		else if (x>-1)
			_Entity.removeAt(x);		 
	}//next i
	
//End Order tagging entities by sequence number//endregion 	
	

// world plane in MS
	Plane pnZPS(_PtW, _ZW);
	
//region Viewport / Section profile
	String sTriggerSetSectionDepth = T("|Set Section Depth|");	
	String sTriggerSetSectionOffset = T("|Set Section Offset|");

	PlaneProfile ppVp, ppVpInverse, ppClip, ppParent;
	Body bdClip;
	Vector3d viewFromDir;
	double dZClip; // the dimension of the clip body in view direction	
	Point3d ptRefClip;
	if (bHasSection)
	{ 
	// register section depth/offset trigger
		addRecalcTrigger(_kContextRoot, sTriggerSetSectionDepth );
		addRecalcTrigger(_kContextRoot, sTriggerSetSectionOffset );		
		
		
		bdClip = clipVolume.clippingBody();		//bdClip.vis(32);		

	// get the front location of the clipbody
		viewFromDir = clipVolume.viewFromDir();
		ptRefClip = clipVolume.coordSys().ptOrg();
		Point3d pts[] = bdClip.extremeVertices(-viewFromDir);
		if (pts.length()>0)
		{
			dZClip = abs(viewFromDir.dotProduct(pts.first() - pts.last()));
			if (dSectionDepth <= 0)dSectionDepth = dZClip;
			ptRefClip+=viewFromDir * viewFromDir.dotProduct(pts.first() - ptRefClip);			
		}


	//region Get simplified profile of section
		Vector3d vecXC = clipVolume.coordSys().vecX();
		Vector3d vecYC = vecXC.crossProduct(-viewFromDir);
		
		PlaneProfile ppxClip(CoordSys(ptRefClip,vecXC, vecYC, viewFromDir));
		for (int i=0;i<entsShowset.length();i++) 
		{ 
			Entity e = entsShowset[i];
			GenBeam gb = (GenBeam)e;
			if (!gb.bIsValid()|| gb.bIsDummy())continue;
			Body bd = gb.envelopeBody();
			if (!bdClip.hasIntersection(bd))continue;
			bd.intersectWith(bdClip);
			//bd.vis(i);
			ppxClip.unionWith(bd.shadowProfile(Plane(ptRefClip, viewFromDir))); 
			//if (i>20)break; 
		}//next i
		//ppxClip.vis(6);	
		
		if (ppxClip.area()>pow(dEps,2))
			ppClip = ppxClip;
		else
			ppClip = bdClip.shadowProfile(Plane(ptRefClip, viewFromDir));
			
		//if (bDebug){Display dpx(4);dpx.draw(ppClip, _kDrawFilled,30);}	
			
			
		ppVp = ppClip;
		//ppVp.createRectangle(ppClip.extentInDir(vecXC), vecXC, vecYC);
		ppVp.transformBy(ms2ps);
		ppParent = ppVp;
		//ppParent.vis(3);			
			
	//endregion 

	// get extents of profile
		LineSeg seg = ppVp.extentInDir(_XW);
		ptCenVp = seg.ptMid();			//seg.vis(2);
		dXVp = 10*abs(_XW.dotProduct(seg.ptStart()-seg.ptEnd())); // XX 10*
		dYVp = 10*abs(_YW.dotProduct(seg.ptStart()-seg.ptEnd()));// XX 10*
		
		ppVp.createRectangle(seg, _XW, _YW);		
		ppVp.shrink(-U(2000));	//ppVp.vis(2);
		
		Point3d ptOrg =  section.coordSys().ptOrg();
		_Pt0 += _ZW * _ZW.dotProduct(ptOrg - _Pt0);//_Pt0.vis(4);
		//viewFromDir.vis(ptOrg, 2);
	
		pnZPS=Plane(ptOrg, _ZW);//ms2ps.ptOrg()
	}
	else
		ppVp.createRectangle(LineSeg(ptCenVp-.5*(_XW*dXVp+_YW*dYVp),ptCenVp+.5*(_XW*dXVp+_YW*dYVp)),_XW,_YW);
	
	
	Plane pnZMS = pnZPS;
	pnZMS.transformBy(ps2ms);
	//pnZMS = Plane(ptCenVp, pnZMS.vecZ() );

//endregion 	
	
// declare a section body to identify items in section depth or on section line	HSB-6159
	Body bdSection;
	if (dSectionOffset>0)
	{ 
		Point3d pt = ptCenVp - viewFromDir * dSectionOffset;
		pnZMS.transformBy(viewFromDir * viewFromDir.dotProduct(pt- pnZMS.ptOrg()));
	}	
	if (bHasSectionDepth && dSectionDepth>dEps)
	{
		ptCenVp.vis(3);
		Point3d pt = ptCenVp;			
		bdSection = Body(pt-_ZW*dSectionOffset/dScale, _XW, _YW, _ZW,dXVp, dYVp, dSectionDepth/dScale, 0, 0 ,- 1);
		bdSection.transformBy(ps2ms);
		bdSection.vis(6);
	}	
	pnZMS.vis(2);
	
	//ppVp.vis(2);

	
	
// get potential elements of multiwall (only if in same dwg) //HSB-10157
	Element elMultis[0];
	SingleElementRef srefs[0];
	if (em.bIsValid())
	{ 
		srefs = em.singleElementRefs();
		String numbers[0];
		for (int j=0;j<srefs.length();j++) 
			numbers.append(srefs[j].number()); 
	
		Entity _ents[] = Group().collectEntities(true, Element(), _kModelSpace);
		for (int i=0;i<_ents.length();i++) 
		{ 
			Element e = (Element)_ents[i];
			if (e.bIsValid() && numbers.findNoCase(e.number(),-1)>-1)	
				elMultis.append(e);	 
		}//next j				
	}
	

//End get defining viewport entity//endregion 

//region Protection area by sequence // HSB-8276 
	// collect protection areas of sequnced tagging tsl with a higher or equal sequence number
	
	for (int i=0;i<tslSeqs.length();i++) 
	{ 
		TslInst t = tslSeqs[i]; 
		if (!t.bIsValid() || t==_ThisInst) {continue;}// validate tsl
		String s = t.scriptName();
		int n = t.sequenceNumber();
		if (n<nSequence || (n==nSequence && t.handle()>_ThisInst.handle()))
		{ 
			Map m = t.subMapX(sSubXKey);
			PlaneProfile pp =m.getPlaneProfile("ppProtect");
			if (pp.area() < pow(dEpsPS, 2)) { continue;};
			
			if (ppProtect.area() < pow(dEpsPS, 2))	ppProtect = pp;
			else ppProtect.unionWith(pp);
		}
	}//next i
	if (ppProtect.area()>pow(dEpsPS,2))
		ppProtect.vis(bIsDark?4:1);		
//End Protection area by sequence//endregion 

//region collect zones
	int nZones[0];
	if (nType>=0 && nType<=4) // all genbeam types HSB-10500
	{ 
		Map map = _Map.getMap("Zone[]");
	// Trigger AddZoneIndex//region
		String sTriggerAddZoneIndex = T("|Add Zone Index|");
		addRecalcTrigger(_kContextRoot, sTriggerAddZoneIndex );
		if (_bOnRecalc && _kExecuteKey==sTriggerAddZoneIndex)
		{
			int nZone = getInt(T("|Enter zone index, 999 = all zones|"));
			if ((nZone >-6 && nZone<11) ||  nZone == 999)
			{
				map.setInt("Zone", nZone);
				_Map.setMap("Zone[]", map);
			}
			setExecutionLoops(2);
			return;
		}//endregion	

	// Trigger RemoveZoneOverride//region
		if (map.length()>0)
		{ 
			String sTriggerRemoveZoneOverride = T("|Remove Zone Index|");
			addRecalcTrigger(_kContextRoot, sTriggerRemoveZoneOverride );
			if (_bOnRecalc && _kExecuteKey==sTriggerRemoveZoneOverride)
			{
				_Map.removeAt("Zone[]", true);
				setExecutionLoops(2);
				return;
			}			
		}
		//endregion

	// read zone overrides
		for (int i=0;i<map.length();i++) 
		{ 
			int nZone = map.getInt("Zone");
		// all zones
			if (nZone==99 || nZone==999) // HSB-15902 99 = legacy support
			{ 
				bEveryZone = true;
				nZones.setLength(0);
				int n[] ={-5,-4,-3,-2,-1,0,1,2,3,4,5};
				nZones.append(n);
				break;
			}
	
		// support 1-10 syntax	
			if (nZone>5 && nZone<11)
				nZone = 5 - nZone;
			int bIsValid = nZone >- 6 && nZone < 6;
			if (nZones.find(nZone)<0 && bIsValid)
				nZones.append(nZone);

		}//next i
	}
	if (nType == 0  && nZones.length()<1)
	{
		bEveryZone = true;
	}
		
//End collect zones//endregion 

//region Trigger SelectEntity
	if (!bIsElementViewport && !bHasSection && !bHasPage) // HSB-11088 add remove entities not available for sections and element viewports
	{ 
		String sTriggerAddEntity = T("|Add entities| (") + sType + ")";
		
		if (bIsTypeTsl && sScripts.length()==1)
			sTriggerAddEntity = T("|Add instances of type| ") + sScripts.first() ;
		
		
		addRecalcTrigger(_kContextRoot, sTriggerAddEntity );

		if (_bOnRecalc && (_kExecuteKey==sTriggerAddEntity || _kExecuteKey==sDoubleClick))
		{
			int bSuccess = Viewport().switchToModelSpace();
			bSuccess = _Viewport[0].setCurrent();
			
			String prompt;
			
			for (int i=0;i<sScripts.length();i++) 
			{ 
				prompt += (prompt.length()<1? T("|Select instances of type| "):", ")+ sScripts[i]; 
				 
			}//next i
	
			if (bSuccess)
			{ 
			// prompt for entities
				PrEntity ssE;
				if (bIsTypeBeam)ssE = PrEntity(T("|Select beams|"), Beam());
				else if (bIsTypeSheet)ssE = PrEntity(T("|Select sheets|"), Sheet());
				else if (bIsTypeSip)ssE = PrEntity(T("|Select sips|"), Sip());
				else if (bIsTypeGenbeam)ssE = PrEntity(T("|Select genbeams|"), GenBeam());
				else if (bIsTypeTsl)ssE = PrEntity(prompt, TslInst());
				else if (bIsTypeAnyOpening)ssE = PrEntity(T("|Select openings|"), Opening());	
				else if (bIsTypeTruss)ssE = PrEntity(T("|Select trusses|"), TrussEntity());
				else if (bIsTypeMetalpart)ssE = PrEntity(T("|Select metalparts|"), MetalPartCollectionEnt());
				else if (bIsTypeMassgroup)ssE = PrEntity(T("|Select massgroups|"), MassGroup());
				else if (bIsTypeElement)ssE = PrEntity(T("|Select elements|"), Element());
				else if (bIsTypeMasselement)ssE = PrEntity(T("|Select elements|"), MassElement());
				else if (bIsTypeFastener)ssE = PrEntity(T("|Select fasteners|"), FastenerAssemblyEnt());
				ssE.allowNested(true);
				if (ssE.go())
				{
					Entity _ents[] = ssE.set();
					
					if(painter.bIsValid())
						_ents = painter.filterAcceptedEntities(_ents);
					
				// accept only tsls of the specified scriptName	
					else if (bIsTypeTsl && sScripts.length()>0)
					{ 
						for (int i=_ents.length()-1; i>=0 ; i--) 
						{ 
							TslInst t=(TslInst)_ents[i];
							if (!t.bIsValid() || sScripts.find(t.scriptName())<0)
								_ents.removeAt(i);
						}//next i	
					}
					
					reportMessage("\nents " + _ents.length() + " selected");
					_Entity.append(_ents);
				}
				bSuccess = Viewport().switchToPaperSpace();	
			}
			setExecutionLoops(2);
			return;		
		}	
		
		if (_Entity.length()>0)
		{ 
			String sTriggerRemoveEntity = T("|Remove entities|");
			addRecalcTrigger(_kContextRoot, sTriggerRemoveEntity );
	
			if (_bOnRecalc && _kExecuteKey==sTriggerRemoveEntity)
			{
				int bSuccess = Viewport().switchToModelSpace();
				bSuccess = _Viewport[0].setCurrent();
				if (bSuccess)
				{ 
				// prompt for entities
					PrEntity ssE(T("|Select entities|"), Entity());
					ssE.allowNested(true);
					Entity _ents[0];
					if (ssE.go())
						_ents.append(ssE.set());
					
					for (int i=_ents.length()-1; i>=0 ; i--) 
					{ 
						int n = _Entity.find(_ents[i]);
						if (n>-1)
						{
							_Entity.removeAt(n);
						}
						
					}//next i	
					bSuccess = Viewport().switchToPaperSpace();	
				}
				setExecutionLoops(2);
				return;		
			}				
		}

	// TODO add zone selection			
		
	}//endregion
	
//region get list of scriptnames


	String sSetupText2;
	if (bIsTypeTsl)
	{ 

	//region Trigger SetTSLDefinitions
		String sTriggerSetTSLDefinitions = T("|Set TSL definitions|");
		if (nPainter<0)
			addRecalcTrigger(_kContextRoot, sTriggerSetTSLDefinitions );
		if (_bOnRecalc && _kExecuteKey==sTriggerSetTSLDefinitions && findFile(sDialogLibrary)!="")
		{

			int nSelectedIndex = -1;

			Map mapIn,mapItems;
			mapIn.setString("Title", T("|TSL Definitions|"));
			mapIn.setString("Prompt", T("|Select TSL to be tagged.|"));
			mapIn.setString("Alignment", "Left");
			mapIn.setInt("EnableMultipleSelection", true);
			
			for (int i = 0; i < sScriptNames.length(); i++)
			{ 
				
				Map m;
				m.setString("Text", sScriptNames[i]);
				//m.setString("ToolTip", sScriptNames[i]);
				m.setInt("IsSelected", sScripts.find(sScriptNames[i])>-1?1:0);
				mapItems.appendMap("Item", m);	
			}				
			mapIn.setMap("Items[]", mapItems);
			
			Map mapOut = callDotNetFunction2(sDialogLibrary, sClass, listSelectorMethod, mapIn);// optionsMethod,listSelectorMethod				
			
			Map mapExplicits = mapOut.getMap("Selection[]");
			_Map.setMap("ExplicitTsl[]", mapExplicits);


			setExecutionLoops(2);
			return;
		}//endregion

	// Allow all solid tsls if nothing selected
		if (mapExplicitTsls.length()<1)
		{
			sScripts = sScriptNames;
			if (!bAddSolidScript)
			{
				bAddScriptAll = true;
				sSetupText2 = T(", |all scripts|");
			}
			else
				sSetupText2 = T(", |all scripts with solid|");
				
		}
		else
			sSetupText2 = sScripts;
	}	
//endregion 

//endregion Part #3

//region Part #4
		

//region collect entities by selected type
	Entity ents[0]; // to be of same length! needed to transform metalpart collection entity bodies to model
	Map mapRelations; // store additional information of a tagging entity (i.e. the parent metalpart collection of a beam)
	Beam beams[0];
	Sheet sheets[0];
	Sip sips[0];
	GenBeam genbeams[0];
	MassElement massElements[0];
	TslInst tsls[0];
	Opening openings[0];
	FastenerAssemblyEnt fasteners[0];
	TrussEntity trusses[0];
	MetalPartCollectionEnt metals[0];
	MassGroup massgroups[0];
	Element elements[0];
	Element elParents[0]; // the elements of which the outline is to be excluded from placement
	
	Entity entTemp;
	//reportMessage("\nHasSDV" + bHasSDV + " showSet " + entsShowset + " defSet " + entsDefineSet + " bIsElementViewport"+ bIsElementViewport + " _Entity "+ _Entity);

//region element viewport
	if (bIsElementViewport)
	{ 
	// reset _PtG if last element varies
		if (bEditInPlace && _Map.getString("CurrentElement")!= el.handle())
			_PtG.setLength(0);
		
		if (bNotOnParent)elParents.append(el);
		
	// Beam
		if (bIsTypeBeam)
		{	
			if (nPainter>-1 && sPainterType == "Beam") // HSB-12444
				beams = painter.filterAcceptedEntities(el.beam());
			else
				beams.append(el.beam());

			for (int j=beams.length()-1; j>=0 ; j--) 
			{ 
				Beam e = beams[j];
				int x = e.myZoneIndex();
				
				if (nPainter<0 && nZones.length()>0 && !e.bIsDummy())
				{ 
					ents.append(e);
					genbeams.append(e);					
				}				
				else if (nPainter<0 && (e.bIsDummy() || (nActiveZoneIndex <11 && x!=nActiveZoneIndex)))
				//(!bEveryZone && nZones.find(e.myZoneIndex())<0)))// HSB-12444
					beams.removeAt(j);	
				else
				{
					ents.append(e);
					genbeams.append(e);
				}
			}//next j	 
			
		}
	// sheet	
		if (bIsTypeSheet)
		{
		// append by painter	
			if (nPainter>-1)// HSB-12444
				sheets = painter.filterAcceptedEntities(el.sheet());
		// append by zone
			else if (nZones.length()>0 && nZones.find(999)<0)
			{ 
				for (int j=0;j<nZones.length();j++) 
					sheets.append(el.sheet(nZones[j]));	
			}
		// append by activeZoneindex	
			else if (nActiveZoneIndex>=-5 && nActiveZoneIndex<=5)
				sheets.append(el.sheet(nActiveZoneIndex));
		// append all
			else 
				sheets.append(el.sheet());
			
			for (int j=sheets.length()-1; j>=0 ; j--) 
			{ 
				Sheet e = sheets[j];
				if (e.bIsDummy())sheets.removeAt(j);			
				else {ents.append(e);genbeams.append(e);}	
			}//next j	
		}
	// Sip	
		if (bIsTypeSip)
		{
			if (nPainter>-1 && sPainterType == "Panel") // HSB-12444
				sips = painter.filterAcceptedEntities(el.sip());
			else
				sips.append(el.sip());

			for (int j=sips.length()-1; j>=0 ; j--) 
			{ 
				Sip e = sips[j];
				int x = e.myZoneIndex();
				
				if (nPainter<0 && nZones.length()>0 && !e.bIsDummy())
				{ 
					ents.append(e);
					genbeams.append(e);					
				}				
				else if (nPainter<0 && (e.bIsDummy() || (nActiveZoneIndex <11 && x!=nActiveZoneIndex)))
					sips.removeAt(j);	
				else
				{
					ents.append(e);
					genbeams.append(e);
				}
			}//next j			
		
//			if (nPainter>-1)// HSB-12444 // HSB-19385
//				sips = painter.filterAcceptedEntities(el.sip());			
//			else
//				sips.append(el.sip());
//			for (int j=sips.length()-1; j>=0 ; j--) 
//			{ 
//				Sip e = sips[j];
//				int x = e.myZoneIndex();
//				
//				
//				int bAccept = !e.bIsDummy();
//				if (bAccept && !bEveryZone && nZones.length() > 0 && nZones.find(x) < 0)
//					bAccept = false;
//				if (bAccept && (nActiveZoneIndex <11 && x!=nActiveZoneIndex))	
//					bAccept = false;
//				
//				if (bAccept){ents.append(e);}
//				else sips.removeAt(j);				
//
//			}//next j
		}
	// byZone or GenBeam	
		if (bIsTypeGenbeam)
		{
			if (nPainter>-1) // HSB-12444 // HSB-19385
				genbeams = painter.filterAcceptedEntities(el.genBeam());
			else
				genbeams.append(el.genBeam());

			for (int j=genbeams.length()-1; j>=0 ; j--) 
			{ 
				GenBeam e = genbeams[j];
				int x = e.myZoneIndex();
				if (e.bIsDummy())
				{ 
					genbeams.removeAt(j);
					continue;
				}
				
				if (nPainter<0)
				{ 
					if (nZones.length()>0)
					{ 
						if (nZones.find(x)>-1)
							ents.append(e);	
						else
							genbeams.removeAt(j);
					}			
					else if (nActiveZoneIndex <11 && x!=nActiveZoneIndex)
					{
						genbeams.removeAt(j);	
					}
					else
					{
						ents.append(e);
					}					
				}
				else
					ents.append(e);

			}//next j				
		}	
	// TSL	
		else if (bIsTypeTsl)
		{
			Entity _ents[] = el.elementGroup().collectEntities(true, TslInst(), _kModelSpace);
			if (nPainter>-1)// HSB-12444
				_ents=painter.filterAcceptedEntities(_ents);
			
			for (int j=0;j<_ents.length();j++) 
			{
				TslInst t = (TslInst)_ents[j];
				if (!t.bIsValid() || (bAddSolidScript && t.realBody().volume()<pow(dEps,3))){continue;}
				if(bAddScriptAll || sScripts.find(t.scriptName())>-1)
				{
					tsls.append(t);
					ents.append(t);	
					 
				}
			}
		}
	// opening	
		else if (bIsTypeOpening)
		{
			if (em.bIsValid())//HSB-10157
			{ 
				for (int j=0;j<elMultis.length();j++) 
					openings.append(elMultis[j].opening());
			}
			else
				openings.append(el.opening());
				
				
			if (nPainter>-1)// HSB-12444
				openings=painter.filterAcceptedEntities(openings);	
				
			for (int j=0;j<openings.length();j++) 
			{
				ents.append(openings[j]);	
				 
			}
		}
	// door, window or assembly
		else if (bIsTypeAnyOpening)
		{
			Opening _openings[0];
			if (em.bIsValid())//HSB-10157
			{ 
				for (int j=0;j<elMultis.length();j++) 
					_openings.append(elMultis[j].opening());
			}
			else
				_openings=el.opening();
				
			if (nPainter>-1)// HSB-12444
				_openings=painter.filterAcceptedEntities(_openings);	
				
				
			for (int j=0;j<_openings.length();j++) 
			{
				int nOpType = _openings[j].openingType();
				if ((bIsTypeDoor && nOpType == _kDoor) ||
					(bIsTypeWindow && nOpType == _kWindow) ||
					(bIsTypeWindowAssembly && nOpType == _kAssembly))
				
				{ 
					ents.append(_openings[j]);
					 
					openings.append(_openings[j]);
				}			
			}
		}
	// truss	
		else if (bIsTypeTruss)
		{
			Entity _ents[] = el.elementGroup().collectEntities(true, TrussEntity(), _kModelSpace);
			
			if (nPainter>-1)// HSB-12444
				_ents=painter.filterAcceptedEntities(_ents);
			
			
			for (int j=0;j<_ents.length();j++) 
			{
				TrussEntity t = (TrussEntity)_ents[j];
				if (t.bIsValid())
				{
					trusses.append(t);
					ents.append(t);	
					 
				}
			}			
		}		
	// metalparts	
		else if (bIsTypeMetalpart)
		{
			Entity _ents[] = el.elementGroup().collectEntities(true, MetalPartCollectionEnt(), _kModelSpace);
			
			if (nPainter>-1 && sPainterType == "Entity")// HSB-12444
				_ents=painter.filterAcceptedEntities(_ents);			
			
			for (int j=0;j<_ents.length();j++) 
			{
				MetalPartCollectionEnt t = (MetalPartCollectionEnt)_ents[j];
				if (t.bIsValid())
				{
					metals.append(t);
					ents.append(t);	
					 
				}
			}			
		}	
	// massgroups	
		else if (bIsTypeMassgroup)
		{
			Entity _ents[] = el.elementGroup().collectEntities(true, MassGroup(), _kModelSpace);
			
			if (nPainter>-1)// HSB-12444
				_ents=painter.filterAcceptedEntities(_ents);	
			
			for (int j=0;j<_ents.length();j++) 
			{
				MassGroup t = (MassGroup)_ents[j];
				if (t.bIsValid())
				{
					massgroups.append(t);
					ents.append(t);
					 
				}
			}			
		}			
	// element	
		else if (bIsTypeElement)
		{ 
			elements.append(el);
			ents.append(el);	
			 
		}
	// mass elements	
		else if (bIsTypeMasselement)
		{
			Entity _ents[] = el.elementGroup().collectEntities(true, MassElement(), _kModelSpace);
			
			if (nPainter>-1)// HSB-12444
				_ents=painter.filterAcceptedEntities(_ents);
			
			for (int j=0;j<_ents.length();j++) 
			{
				MassElement t = (MassElement)_ents[j];
				if (t.bIsValid())
				{
					massElements.append(t);
					ents.append(t);	
					 
				}
			}			
		}
	// fastener	
		else if (bIsTypeFastener)
		{ 
			Entity _ents[] = el.elementGroup().collectEntities(true, FastenerAssemblyEnt(), _kModelSpace);
			
			if (nPainter>-1)// HSB-12444
				_ents=painter.filterAcceptedEntities(_ents);	
			
			for (int j=0;j<_ents.length();j++) 
			{
				FastenerAssemblyEnt t = (FastenerAssemblyEnt)_ents[j];
				if (t.bIsValid())
				{
					fasteners.append(t);
					ents.append(t);
					 
				}
			}		 
		}		
	}
//End element viewport//endregion	

//region an ACA viewport or a shopdrawviewport with no element definition
	else
	{ 
		Entity entsVp[0];
		if (bHasSDV && entsDefineSet.length()>0)
			entsVp = entsDefineSet;
		else if (bHasSection)
			entsVp = entsShowset;
		else if (bHasPage)
		{
			entsVp = entsShowset;			
		}
	// the entity set	
		else 
		{
			entsVp = _Entity;
			
		// remove entities if not of specified type (maybe added by accident)
			for (int i=entsVp.length()-1; i>=0 ; i--) 
			{ 
				Entity e=entsVp[i];
				int bRemove;
				if (bIsTypeBeam && !e.bIsKindOf(Beam()))bRemove = true;
				else if (bIsTypeSheet && !e.bIsKindOf(Sheet()))bRemove = true;
				else if (bIsTypeSip && !e.bIsKindOf(Sip()))bRemove = true;
				else if (bIsTypeMetalpart && !e.bIsKindOf(CollectionEntity()))bRemove = true;
				else if (bIsTypeGenbeam && !e.bIsKindOf(GenBeam()))bRemove = true;
				else if (bIsTypeOpening && !e.bIsKindOf(Opening()))bRemove = true;
				else if (bIsTypeDoor && !e.bIsKindOf(Opening()))bRemove = true;
				else if (bIsTypeWindow && !e.bIsKindOf(Opening()))bRemove = true;
				else if (bIsTypeWindowAssembly && !e.bIsKindOf(Opening()))bRemove = true;
				else if (bIsTypeTruss && !e.bIsKindOf(TrussEntity()))bRemove = true;
				else if (bIsTypeMassgroup && !e.bIsKindOf(MassGroup()))bRemove = true;
				else if (bIsTypeMasselement && !e.bIsKindOf(MassElement()))bRemove = true;
				else if (bIsTypeAnyOpening && !e.bIsKindOf(Opening()))bRemove = true;
				if (bRemove)
					entsVp.removeAt(i);
			}//next i

		// auto append visible entities if nothing had been selected yet
			int bAutoCollect;
			if (entsVp.length()<4)
			{ 
				bAutoCollect = true;
				for (int i=0;i<entsVp.length();i++) 
				{ 
					String type = entsVp[i].typeDxfName().makeUpper();
					reportMessage("\ntype " + type);
					if (type != "VIEWPORT" && entsVp[i]!=_ThisInst)
					{
						bAutoCollect = false;
						break;
					}
				}//next i	
			}
			if (bAutoCollect && bAutoSelectMode)
			{ 
				//int numBefore = entsVp.length();
				Group groups[] = Group().subGroups(true);
				
//				{ 
//					Entity ents[]= Group().collectEntities(true, BlockRef(), _kModelSpace);
//					
//					for (int j=0;j<ents.length();j++) 
//					{ 
//						AcadDatabase db = ents[j].database();
//						Group groupsX[] = Group(db,"").subGroups(false);
//						groups.append(groupsX);
//					}//next j
//					
//					
//				}

			// append by groups	
				for (int i=0;i<groups.length();i++) 
				{ 
					Group group = groups[i];
					int bVisible = vp.groupVisibilityIsOn(group);
					if (!bVisible){ continue;}
					
					if (bDebug)reportNotice("\nadding entities of group " + group.name());
					
					Entity ents[0];
					if (bIsTypeGenbeam)
						ents = group.collectEntities(false, GenBeam(), _kModelSpace);
					else if (bIsTypeBeam)
						ents = group.collectEntities(false, Beam(), _kModelSpace);
					else if (bIsTypeSheet)
						ents = group.collectEntities(false, Sheet(), _kModelSpace);
					else if (bIsTypeSip)
						ents = group.collectEntities(false, Sip(), _kModelSpace);
					else if (bIsTypeTsl)
						ents = group.collectEntities(false, TslInst(), _kModelSpace);
					else if (bIsTypeElement)
						ents = group.collectEntities(false, Element(), _kModelSpace);	
					else if (bIsTypeMetalpart)
						ents = group.collectEntities(false, CollectionEntity(), _kModelSpace);
					else
						ents = group.collectEntities(false, Entity(), _kModelSpace);
					
					int n = entsVp.length();
					for (int j=0;j<ents.length();j++) 
					{ 
						if (entsVp.find(ents[j])<0)
							entsVp.append(ents[j]); 
						 
					}//next j
					
					if (bDebug)reportNotice(" +" +(entsVp.length()-n));
				}//next i	
			
			// append ungrouped but visible
				{ 
					Entity ents[0];
					if (bIsTypeGenbeam)
						ents = Group().collectEntities(true, GenBeam(), _kModelSpace);
					else if (bIsTypeBeam)
						ents = Group().collectEntities(true, Beam(), _kModelSpace);
					else if (bIsTypeSheet)
						ents = Group().collectEntities(true, Sheet(), _kModelSpace);
					else if (bIsTypeSip)
						ents = Group().collectEntities(true, Sip(), _kModelSpace);
					else if (bIsTypeTsl)
						ents = Group().collectEntities(true, TslInst(), _kModelSpace);
					else if (bIsTypeElement)
						ents = Group().collectEntities(true, Element(), _kModelSpace);	
					else if (bIsTypeMetalpart)
						ents = Group().collectEntities(true, CollectionEntity(), _kModelSpace);
					else
						ents = Group().collectEntities(true, Entity(), _kModelSpace);
					
					int n = entsVp.length();
					for (int j=0;j<ents.length();j++) 
					{ 
						Entity e = ents[j];
						
						if (e.groups().length()<1 && entsVp.find(e)<0 && e.isVisible())
						{
							entsVp.append(e); 
						}
						 
					}//next j	
					n =entsVp.length()-n; 
					if (n>0 && bDebug)reportNotice(" +" +n + " ungrouped");	
				}
			
				int numAfter = entsVp.length();
			}	
		}



		if (nPainter>-1 && !bIsTypeMetalpart)// HSB-12444
			entsVp=painter.filterAcceptedEntities(entsVp);
	
		for (int i=entsVp.length()-1; i>=0 ; i--) 
		{ 

		// sip entities not in zone if zone filter is selected
			int myZoneIndex = entsVp[i].myZoneIndex();
			if (nZones.length() > 0  && nZones.find(myZoneIndex) < 0)
			{
				entsVp.removeAt(i);
				continue;
			}
			//entsVp[i].realBody().vis(i);
			String type = entsVp[i].typeDxfName();
			GenBeam gb;
			Beam bm = (Beam)entsVp[i];
			if (bm.bIsValid() && !bm.bIsDummy())
			{ 
				if (bHasSection && nType != 1 && nType != 4)continue;
				beams.append(bm);	ents.append(bm);	genbeams.append(bm);	 
				gb = bm;
				Element e = bm.element(); 
				if (e.bIsValid() && bNotOnParent && elParents.find(e)<0)
					elParents.append(e);
			}
			Sheet sh = (Sheet)entsVp[i];
			if (sh.bIsValid() && !sh.bIsDummy())
			{ 
				if (bHasSection && nType!= 2 && nType!= 4)continue;
				sheets.append(sh);		ents.append(sh);	genbeams.append(sh);	 
				gb = sh;
				Element e = sh.element(); 
				if (e.bIsValid() && bNotOnParent && elParents.find(e)<0)
					elParents.append(e);					
			}	
			Sip sip = (Sip)entsVp[i];
			if (sip.bIsValid() && !sip.bIsDummy())
			{ 
				if (bHasSection && nType!= 3 && nType!= 4)continue;
				sips.append(sip);		ents.append(sip);	genbeams.append(sip);	 
				gb = sip;
				Element e = sip.element(); 
				if (e.bIsValid() && bNotOnParent && elParents.find(e)<0)
					elParents.append(e);				
				
			}
			
		//region Append tsls which are attached to a genbeam, i.e. when collected through showset of multipage
			if (gb.bIsValid()) // HSB-16960
			{ 	
				if (bIsTypeTsl)
				{ 
					Entity tents[] = gb.eToolsConnected();
					for (int j=0;j<tents.length();j++) 
					{ 
						TslInst t = (TslInst)tents[j];
						if (!t.bIsValid())continue;
						String script = t.scriptName();
						if (sScripts.findNoCase(script,-1)>-1)
						{ 
							 if (ents.find(t) < 0) ents.append(t);
							 if (tsls.find(t) < 0) tsls.append(t);							 
						}
						 
					}//next j						
				}
				continue;
			}				
		//endregion 	

			TslInst tsl = (TslInst)entsVp[i];
			if (tsl.bIsValid())//(sScriptNames.length()<1 || (sScriptNames.find(tsl.scriptName())>-1) ))
			{ 
				String scriptName = tsl.scriptName(); // HSB-10654 exclude non solid tsls
				double volume = tsl.realBody(_XW+_YW+_ZW).volume();
				if (scriptName=="__HSB__PREVIEW" || volume<pow(dEps,3))
				{
					continue;
				}


				if (bHasSection && nType!= 5)
				{
					continue;
				}

				if (tsls.find(tsl)<0)
				{ 
					tsls.append(tsl);		
					ents.append(tsl);
				}
				
				
				Element e = tsl.element(); 
				if (e.bIsValid() && bNotOnParent && elParents.find(e)<0)
					elParents.append(e);					
				continue;
			}

			Opening opening = (Opening)entsVp[i];
			if (opening.bIsValid())
			{ 
				if (bHasSection && (nType<6 || nType>9))continue;
				openings.append(opening);		ents.append(opening);	 
				
				Element e = opening.element(); 
				if (e.bIsValid() && bNotOnParent && elParents.find(e)<0)
					elParents.append(e);				
				continue;
			}
			
			TrussEntity truss = (TrussEntity)entsVp[i];
			if (truss.bIsValid())
			{ 
				if (bHasSection && (nType!=10))continue;
				trusses.append(truss);		ents.append(truss);	 ;
				
				Element e = truss.element(); 
				if (e.bIsValid() && bNotOnParent && elParents.find(e)<0)
					elParents.append(e);
				continue;
			}
			
			MetalPartCollectionEnt metal= (MetalPartCollectionEnt)entsVp[i];
			if (metal.bIsValid())//#CE
			{ 
				if (bHasSection && (!bIsTypeMetalpart))
				{
					continue;
				}
				if (bHasPage && (!bIsTypeMetalpart && !bIsTypeBeam && !bIsTypeGenbeam & !bIsTypeSheet && !bIsTypeSheet))
				{
					continue;
				}
				metals.append(metal);		ents.append(metal);  ;
				continue;
			}	
			
			MassGroup massgroup= (MassGroup)entsVp[i];
			if (massgroup.bIsValid())
			{ 
				if (bHasSection && (nType!=12))continue;
				massgroups.append(massgroup);		ents.append(massgroup);	  ;
				
				Element e = massgroup.element(); 
				if (e.bIsValid() && bNotOnParent && elParents.find(e)<0)
					elParents.append(e);
				continue;
			}

			Element element = (Element)entsVp[i];
			if (element.bIsValid())
			{ 
				if (bHasSection && (nType!=13))continue;
				elements.append(element);		ents.append(element);	  
				if (bNotOnParent && elParents.find(element)<0)
					elParents.append(element);				
				continue;
			}
					
			MassElement massElement= (MassElement)entsVp[i];
			if (massElement.bIsValid())
			{ 
				if (bHasSection && (nType!=14))continue;
				massElements.append(massElement);		ents.append(massElement);	  
				
				Element e = massElement.element(); 
				if (e.bIsValid() && bNotOnParent && elParents.find(e)<0)
					elParents.append(e);
				continue;
			}			
			
			FastenerAssemblyEnt fastener= (FastenerAssemblyEnt)entsVp[i];
			if (fastener.bIsValid())
			{ 
				if (bHasSection && (nType!=15))continue;
				fasteners.append(fastener);		ents.append(fastener);	  
				
				Element e = fastener.element(); 
				if (e.bIsValid() && bNotOnParent && elParents.find(e)<0)
					elParents.append(e);
				continue;
			}				
		}//next i
	}

	
//End ACA viewport//endregion	 

//End collect entities by selected type//endregion 

//region Get Quantities of all types except openings
	int nQuantities[0];
	String sUniqueKeys[0];
	int bGroupPosNum = sAttribute.find("@(Quantity)", 0, false) >- 1;	
	if (bGroupPosNum)
	{ 	
		for (int i=0;i<genbeams.length();i++) 
		{ 
			String key  = genbeams[i].posnum();
			//String key = p;
			int n = sUniqueKeys.find(key);
			if (n<0)
			{ 
				nQuantities.append(1);
				sUniqueKeys.append(key);
			}	
			else nQuantities[n]++; 
		}//next i	
		for (int i=0;i<tsls.length();i++) 
		{ 
			if (!tsls[i].bIsValid())continue;
			int p = tsls[i].posnum();
			String key = p;
			
		// consider location in view
			Point3d pt = tsls[i].ptOrg();
			pt.transformBy(ms2ps);
			pt.setZ(0);			
			
			if (IsStackItem(tsls[i]))
			{ 
				GenBeam gbs[] = GetStackItemGenBeams(tsls[i]);
				if (gbs.length()>0)
					key = gbs[0].posnum();
			}
			else
				key += pt;

			int n = sUniqueKeys.find(key);
			if (n<0)
			{ 
				nQuantities.append(1);
				sUniqueKeys.append(key);
			}	
			else nQuantities[n]++; 
		}//next i	
		for (int i=0;i<trusses.length();i++) 
		{ 
			if (!trusses[i].bIsValid())continue;
			String key = trusses[i].definition();
			int n = sUniqueKeys.find(key);
			if (n<0)
			{ 
				nQuantities.append(1);
				sUniqueKeys.append(key);
			}	
			else nQuantities[n]++; 
		}//next i
		for (int i=0;i<metals.length();i++) 
		{ 
			if (!metals[i].bIsValid())continue;
			String key = metals[i].definition();
			int n = sUniqueKeys.find(key);
			if (n<0)
			{ 
				nQuantities.append(1);
				sUniqueKeys.append(key);
			}	
			else nQuantities[n]++; 
		}//next i	
		for (int i=0;i<massgroups.length();i++) 
		{ 
			if (!massgroups[i].bIsValid())continue;
			String key = massgroups[i].posnum();
			int n = sUniqueKeys.find(key);
			if (n<0)
			{ 
				nQuantities.append(1);
				sUniqueKeys.append(key);
			}	
			else nQuantities[n]++; 
		}//next i
		for (int i=0;i<elements.length();i++) 
		{ 
			if (!elements[i].bIsValid())continue;
			String key = elements[i].number();
			int n = sUniqueKeys.find(key);
			if (n<0)
			{ 
				nQuantities.append(1);
				sUniqueKeys.append(key);
			}	
			else nQuantities[n]++; 
		}//next i
		for (int i=0;i<massElements.length();i++) 
		{ 
			if (!massElements[i].bIsValid())continue;
			String key = massElements[i].handle();
			int n = sUniqueKeys.find(key);
			if (n<0)
			{ 
				nQuantities.append(1);
				sUniqueKeys.append(key);
			}	
			else nQuantities[n]++; 
		}//next i
		for (int i=0;i<fasteners.length();i++) 
		{ 
			if (!fasteners[i].bIsValid())continue;
			String key = fasteners[i].definition() + fasteners[i].articleNumber();
			int n = sUniqueKeys.find(key);
			if (n<0)
			{ 
				nQuantities.append(1);
				sUniqueKeys.append(key);
			}	
			else nQuantities[n]++; 
		}//next i		
	}


//End Get Quantities of genbeam types//endregion 

//region get list of available object variables
	Map mapAdditional;
	String sObjectVariables[0];
	for (int i=0;i<ents.length();i++) 
	{ 
		Entity& e = ents[i];
		TslInst t;
		FastenerAssemblyEnt fae;
		String _sObjectVariables[0];
		int n;

		if (bIsTypeBeam){n = beams.find(ents[i]); 			if (n>-1)_sObjectVariables.append(beams[n].formatObjectVariables());}
		else if (bIsTypeSheet){n = sheets.find(ents[i]);	if (n>-1)_sObjectVariables.append(sheets[n].formatObjectVariables());}
		else if (bIsTypeSip){n = sips.find(ents[i]); 		if (n>-1)_sObjectVariables.append(sips[n].formatObjectVariables());}
		else if (nType==0 || bIsTypeGenbeam){n = genbeams.find(ents[i]); 	if (n>-1)_sObjectVariables.append(genbeams[n].formatObjectVariables());}
		else if (bIsTypeTsl)
		{
			n = tsls.find(ents[i]); 		
			if (n>-1)
			{
				t = tsls[n];
				_sObjectVariables.append(tsls[n].formatObjectVariables());
			}
		}
		else if (bIsTypeOpening){n = openings.find(ents[i]); 	if (n>-1)_sObjectVariables.append(openings[n].formatObjectVariables());}
		else if (bIsTypeDoor){n = openings.find(ents[i]); 	if (n>-1)_sObjectVariables.append(openings[n].formatObjectVariables());}
		else if (bIsTypeWindow){n = openings.find(ents[i]); 	if (n>-1)_sObjectVariables.append(openings[n].formatObjectVariables());}
		else if (bIsTypeWindowAssembly){n = openings.find(ents[i]); 	if (n>-1)_sObjectVariables.append(openings[n].formatObjectVariables());}
		else if (bIsTypeTruss){n = trusses.find(ents[i]); 	if (n>-1)_sObjectVariables.append(trusses[n].formatObjectVariables());}
		else if (bIsTypeMetalpart){n = metals.find(ents[i]); 	if (n>-1)_sObjectVariables.append(metals[n].formatObjectVariables());}
		else if (bIsTypeMassgroup){n = massgroups.find(ents[i]); 	if (n>-1)_sObjectVariables.append(massgroups[n].formatObjectVariables());}
		else if (bIsTypeElement){n = elements.find(ents[i]); 	if (n>-1)_sObjectVariables.append(elements[n].formatObjectVariables());}
		else if (bIsTypeMasselement){n = massElements.find(ents[i]); 	if (n>-1)_sObjectVariables.append(massElements[n].formatObjectVariables());}
		else if (bIsTypeFastener)
		{
			n = fasteners.find(ents[i]); 	
			if (n>-1)
			{				
				fae = fasteners[n];
				_sObjectVariables.append(fae.formatObjectVariables());
				FastenerAssemblyDef fadef(fasteners[n].definition());
				Map mapComponentData = ComponentDataToMap(fadef.listComponent().componentData());
				for (int j=0;j<mapComponentData.length();j++) 
				{ 
					_sObjectVariables.append("Component."+mapComponentData.keyAt(j)); 
					 
				}//next j
			}
		}

	// append all variables, they might vary by type as different property sets could be attached
		for (int j=0;j<_sObjectVariables.length();j++)  
		{
			String key = _sObjectVariables[j];
			if(sObjectVariables.find(_sObjectVariables[j])<0)
				sObjectVariables.append(_sObjectVariables[j]); 
			
			// HSB-16960 append tsl properties
			if (t.bIsValid() && !mapAdditional.hasString(key) && !mapAdditional.hasDouble(key) && !mapAdditional.hasInt(key))
			{ 
				if(t.hasPropDouble(key))
					mapAdditional.appendString(key, t.propDouble(key));
				else if(t.hasPropInt(key))
					mapAdditional.appendString(key, t.propInt(key));
				else if(t.hasPropString(key))
					mapAdditional.appendString(key, t.propString(key));	
				else
				{ 
					String value = e.formatObject("@(" + key + ":D)");
					mapAdditional.appendString(key, value);
				}	
			}
			
			// append fastener properties
			if (fae.bIsValid() && !mapAdditional.hasString(key) && !mapAdditional.hasDouble(key) && !mapAdditional.hasInt(key))
			{ 
				if(t.hasPropDouble(key))
					mapAdditional.appendString(key, t.propDouble(key));
				else if(t.hasPropInt(key))
					mapAdditional.appendString(key, t.propInt(key));
				else if(t.hasPropString(key))
					mapAdditional.appendString(key, t.propString(key));	
				else
				{ 
					String value = e.formatObject("@(" + key + ":D)");
					mapAdditional.appendString(key, value);
				}	
			}			
			
			
		}
				
	}//next
	
	if (entTemp.bIsValid())entTemp.dbErase();
	
//region add custom variables
	{ 
		String k;
		k = "Calculate Weight"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
		
		
	// add quantity as object variable
		if (nType != 6)
		{
			k = "Quantity"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);	
		}
		// Beam	
		if (bIsTypeBeam)
		{
			k = "Surface Quality"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "Zone Alignment"; if (el.bIsValid() && sObjectVariables.find(k) < 0)sObjectVariables.append(k);
		}
		// Sip	
		else if (nType == 3)
		{ 
			k = "GrainDirection"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "GrainDirectionText"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "GrainDirectionTextShort"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "SurfaceQuality"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "SurfaceQualityTop"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "SurfaceQualityBottom"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "SipComponent.Name"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "SipComponent.Material"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
		}
		//TSL
		else if (bIsTypeTsl)
		{ 
			k = "Posnum"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);	
			
			k = "ModelDescription"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			
//		// TODO Grouping of multiple entries not solved	
//			k = "Hardware.Name"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
//			k = "Hardware.ArticleNumber"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
//			k = "Hardware.Description"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
//			k = "Hardware.Manufacturer"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
//			k = "Hardware.Model"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
//			k = "Hardware.Material"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
//			k = "Hardware.Category"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
//			k = "Hardware.Group"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
//			k = "Hardware.Notes"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
//			k = "Hardware.Quantity"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
//			k = "Hardware.ScaleX"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
//			k = "Hardware.ScaleY"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
//			k = "Hardware.ScaleZ"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
		}
	// metalpart collection entity	
		else if (bIsTypeMetalpart)
		{ 
			k = "Definition"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);	
		}
		else if (nType>=6 && nType<=10)
		{ 
			//sObjectVariables = sObjectVariables.sorted();
			k = "Width"; 	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "Height"; 	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "Rise"; 	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "SillHeight";	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "HeadHeight";	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "OpeningDescription";	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "Description";	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "Type"; 	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "HeightRough"; 	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "WidthRough"; 	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			
			//if (ents[i].bIsKindOf(OpeningSF()))
			{ 
				k = "GapSide"; 	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
				k = "GapTop"; 	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
				k = "GapBottom"; 	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);			
				k = "StyleNameSF"; 	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
				k = "DescriptionPacking"; 	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
				k = "DescriptionPlate"; 	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
				k = "DescriptionSF"; 	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			}
		}	
	// element
		else if (bIsTypeElement)
		{ 
			k = "Code"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);		
			k = "Information"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);	
			k = "Subtype"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);	
		}
	// masselement
		else if (bIsTypeMasselement)
		{ 
			k = "Width"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);		
			k = "Height"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);	
			k = "Depth"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "Radius"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "Rise"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "ShapeType"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
		}

		
	}	
//End add custom variables//endregion 

//// get translated list of variables
//	String sTranslatedVariables[0];
//	for (int i=0;i<sObjectVariables.length();i++) 
//	{
//		if (bHasSDV)mapAdditional.setString(sObjectVariables[i],"");
//		sTranslatedVariables.append(T("|"+sObjectVariables[i]+"|")); 
//	}

//region Append variables when in shopdraw setup mode
	if (bHasSDV)
	{
		String vars[0];
		if (bIsTypeBeam || bIsTypeMetalpart) vars.append(_ThisInst.formatObjectVariables("Beam"));
		if (bIsTypeSheet || bIsTypeMetalpart) vars.append(_ThisInst.formatObjectVariables("Sheet"));
		if (bIsTypeSip) vars.append(_ThisInst.formatObjectVariables("Sip"));
		if (bIsTypeElement) vars.append(_ThisInst.formatObjectVariables("Element"));
		if (bIsTypeMetalpart) vars.append(_ThisInst.formatObjectVariables("Entity"));
		if (bIsTypeTsl) vars.append(_ThisInst.formatObjectVariables("TslInstance"));
		if (bIsTypeFastener) vars.append(_ThisInst.formatObjectVariables("FastenerAssemblyEnt"));
		for (int i = 0; i < vars.length(); i++)
			mapAdditional.appendString(vars[i], "");
	}
//endregion 





// order alphabetically
//	for (int i=0;i<sTranslatedVariables.length();i++) 
//		for (int j=0;j<sTranslatedVariables.length()-1;j++) 
//			if (sTranslatedVariables[j]>sTranslatedVariables[j+1])
//			{
//				sObjectVariables.swap(j, j + 1);
//				sTranslatedVariables.swap(j, j + 1);
//			}
//End get list of available object variables//endregion 
	
//region Trigger AddTagProfiles
	Map mapTagProfile;
	if (!_Map.hasMap("NoTag[]") && !bHasStaticLoc)
	{ 
		String sAddTagProfile = T("|Set preferred tag areas|");
		addRecalcTrigger(_kContextRoot, sAddTagProfile);
		if (_bOnRecalc && _kExecuteKey==sAddTagProfile)
		{
		// prompt for polylines
			Entity _ents[0];
			PrEntity ssEpl(T("|Select polylines|"), EntPLine());
		  	if (ssEpl.go())
				_ents.append(ssEpl.set());
			
			PlaneProfile pp;
			for (int j=_ents.length()-1; j>=0 ; j--) 
			{ 
				EntPLine epl=(EntPLine)_ents[j]; 
				pp.joinRing(epl.getPLine(), _kAdd);
				epl.dbErase();
			}//next j

		// no polylines selected -> get the defining diagonal
			if (pp.area() < pow(dEps, 2))
			{
				Point3d pt = getPoint(T("|Pick first corner|"));
				// prompt for second point input
				Point3d pts[0];
				while (pts.length() < 1)
				{
					PrPoint ssP(TN("|Select opposite corner|"), pt);
					if (ssP.go() == _kOk)
						pts.append(ssP.value());
					else
						break;
				}
				if (pts.length() > 0)
					pp.createRectangle(LineSeg(pt, pts[0]), _XW, _YW);
			}
		
		// store
			if (pp.area() > pow(dEps, 2))
			{
				Map map = _Map.getMap("TagProfile[]");
				map.appendPlaneProfile("TagProfile", pp);
				_Map.setMap("TagProfile[]", map);
			}		

			setExecutionLoops(2);
			return;
		} 
	}

	Map mapTagProfiles = _Map.getMap("TagProfile[]");
	int bHasPreferred = mapTagProfiles.length() > 0;
	

	
	
	
	//endregion

//region Trigger RemovePreferredArea
	if (bHasPreferred)
	{ 
		String sTriggerRemovePreferredArea = T("|Remove preferred tag areas|");
		addRecalcTrigger(_kContext, sTriggerRemovePreferredArea );
		if (_bOnRecalc && _kExecuteKey==sTriggerRemovePreferredArea)
		{
			_Map.removeAt("TagProfile[]", true);
			setExecutionLoops(2);
			return;
		}		
	}
//endregion	

//region Trigger RemoveNoTagArea
	if (_Map.hasMap("NoTag[]"))
	{ 
		String sTriggerRemoveNoTagArea = T("|Remove No-Tag Area|");
		addRecalcTrigger(_kContext, sTriggerRemoveNoTagArea );
		if (_bOnRecalc && _kExecuteKey==sTriggerRemoveNoTagArea)
		{
			_Map.removeAt("NoTag[]", true);
			setExecutionLoops(2);
			return;
		}	
	}//endregion	

//region Display
// validate / automatic text height
	if (dTextHeight<=0)
		dTextHeight.set(U(100) * vp.dScale());


	Display dp(nc), dpLeader(ncLeader);
	dp.dimStyle(sDimStyle);
	double dTextHeightStyle = dp.textHeightForStyle("O",sDimStyle);
	if (dTextHeight>0)
	{
		dTextHeightStyle=dTextHeight;
		dp.textHeight(dTextHeight);
	}	

// setup / control display	
	int bDrawSetupInfo = true;
	if (bHasStaticLoc)
	{
		if (entsDefineSet.length()<1 && ents.length()<1)
		{
			String sLines[] = sAutoAttribute.tokenize("\\");
			double dYFlag = -1;
			for (int i=0;i<sLines.length();i++) 
			{ 
				dp.draw(sLines[i],  _Pt0, _XW, _YW, 1,dYFlag);
				dYFlag -= 3;
			}//next i			
		}
		bDrawSetupInfo=false ;
	}
	else if (bHasSDV && entsDefineSet.length() >0)
		bDrawSetupInfo=false ;
	else if (bHasPage)
	{ 
		if (entsShowset.length()>0)
		{
			bDrawSetupInfo=false ;
			_ThisInst.setAllowGripAtPt0(false);
		}
		else
			_ThisInst.setAllowGripAtPt0(true);
	}
	else if (bHasSection && ents.length() >0)
		bDrawSetupInfo=false ;
	if (bDrawSetupInfo)
	{ 
		String text = T(": |Zone| ") + (nZones.length() > 0 ? nZones : nActiveZoneIndex);
		dp.draw(scriptName()+text, _Pt0, _XW, _YW, 1, 1);
		dp.draw(sTypeName + ": " + sType + (bIsTypeTsl?sSetupText2:"") + " ("+ents.length()+"), " + sSequenceName+": "+nSequence,  _Pt0, _XW, _YW, 1, -2);
		dp.draw(T("|Format|") + ": " + sAutoAttribute,  _Pt0, _XW, _YW, 1, -5);	
		if (sPainterFilter.length()>0)
			dp.draw(T("|Filter by|") + ": " + sPainterFilter,  _Pt0, _XW, _YW, 1, -8);	
	}

//End Display//endregion 

//region Build inverse profile out of preferred profiles if in section mode

	if (nPlacement!=2 && !bHasStaticLoc && !bHasSection)// not on parent and not static
	{ 
		ppVpInverse = ppVp;
		ppVpInverse.shrink(-dTextHeightStyle*(nPlacement == 0?50:10));//(dXVp + dYVp) *- 3);
//		ppVpInverse.transformBy(_ZW * U(5));		
//		ppVpInverse.vis(41);
	}	


	if (bHasPreferred && bHasSection)
	{ 
		PlaneProfile pp;
		for (int i = 0; i < mapTagProfiles.length(); i++)
		{
			PlaneProfile _pp = mapTagProfiles.getPlaneProfile(i);
			if (pp.area()<pow(dEps,2))pp = _pp;
			else pp.unionWith(_pp);
		}
	// get extents of profile
		PlaneProfile pp1=pp;
		pp1.unionWith(ppParent);

		LineSeg seg = pp1.extentInDir(_XW);
		double dX = abs(_XW.dotProduct(seg.ptStart()-seg.ptEnd()))*.5+3*dTextHeightStyle;
		double dY = abs(_YW.dotProduct(seg.ptStart()-seg.ptEnd()))*.5+3*dTextHeightStyle;
		
		pp1.createRectangle(LineSeg(seg.ptMid() - (_XW * dX + _YW * dY), seg.ptMid() + (_XW * dX + _YW * dY)), _XW, _YW);
		pp1.subtractProfile(pp);		
		ppVpInverse = pp1;//pp1.vis(2);
	}

	
//endregion 

//region Collect shadow profiles
	PlaneProfile ppShadows[ents.length()], ppShadowsMP[0];
	Body bdAllShadows[ents.length()], bdAllShadowsMP[0]; //allShadows collects all, even if section depth or offset are given
	double dAreas[ents.length()],dAreasMP[0];
	Entity entsMP[0]; 
	MetalPartCollectionEnt cesRef[ents.length()], cesRefMP[0]; // invalid for all non metalpart based entities
	
	
	for (int i=ents.length()-1; i>=0 ; i--) 
	{ 
		PlaneProfile pp;
		int bAdd = ents[i].isVisible();		// HSB-15730
		
		GenBeam gb = (GenBeam)ents[i];
		Beam beam = (Beam)ents[i];
		Sheet sheet = (Sheet)ents[i];
		Sip sip= (Sip)ents[i];
		TslInst tsl = (TslInst)ents[i];
		Opening opening = (Opening)ents[i];
		TrussEntity truss = (TrussEntity)ents[i];
		MetalPartCollectionEnt ce = (MetalPartCollectionEnt)ents[i];
		MassGroup massgroup = (MassGroup)ents[i];
		Element element= (Element)ents[i];
		MassElement massElement= (MassElement)ents[i];
		FastenerAssemblyEnt fastener= (FastenerAssemblyEnt)ents[i];

		if (beam.bIsValid() && nType != 0 && !bIsTypeBeam && !bIsTypeGenbeam)
		{
			bAdd = false;
		}
		else if (sheet.bIsValid() && nType != 0 && nType != 2 && !bIsTypeGenbeam)bAdd = false;
		else if (sip.bIsValid() && nType != 0 && nType != 3 && !bIsTypeGenbeam)bAdd = false;
		else if (tsl.bIsValid() && nType != 5)bAdd = false;
		else if (opening.bIsValid() && (nType <6 || nType>9))bAdd = false;
		else if (truss.bIsValid() && !bIsTypeTruss)bAdd = false;
		else if (ce.bIsValid() && !bIsTypeMetalpart)bAdd = false;
		else if (massgroup.bIsValid() && !bIsTypeMassgroup)bAdd = false;
		else if (element.bIsValid() && !bIsTypeElement)bAdd = false;
		else if (massElement.bIsValid() && !bIsTypeMasselement)bAdd = false;
		else if (fastener.bIsValid() && !bIsTypeFastener)
		{
			bAdd = false;
		}

		Body bdEnt;
		int bSkip;
		if (gb.bIsValid() ) 
		{
			bdEnt = gb.envelopeBody(false, true);
			if (nType>4){ bSkip=true;}// HSB-15850 nType>4 to exclude genbeams of a metalpart collection entity
		}
		else if (opening.bIsValid())
		{ 
			Opening& o = opening;
			CoordSys cso = o.coordSys();
			Vector3d vecXO= cso.vecX(), vecYO =cso.vecY(), vecZO=cso.vecZ();
			
			PLine pl = o.plShape();pl.vis(3);
			Element e = o.element();
			Quader q = o.bodyExtents();
			Vector3d vecQ = q.pointAt(1, 1, 1) - q.pointAt(-1, -1, -1); // HSB-19140 catching opnings with no solid
			if (!vecQ.bIsZeroLength())
				bdEnt=Body(q.pointAt(0, 0, 0), vecXO, vecYO, vecZO, q.dD(vecXO), q.dD(vecYO), q.dD(vecZO), 0, 0, 0);
			else
				bdEnt = Body(pl, e.vecZ() * U(10), 0);			
			
			if (em.bIsValid())//HSB-10157
			{ 
				CoordSys csSingle;
				for (int j=0;j<srefs.length();j++) 
				{ 
					if (srefs[j].number().makeUpper()==e.number().makeUpper())
					{
						csSingle=srefs[j].coordSys(); 
						break;
					}
					 
				}//next j
				CoordSys cs2em;
				cs2em.setToAlignCoordSys(e.ptOrg(), e.vecX(), e.vecY(), e.vecZ(), csSingle.ptOrg(), csSingle.vecX(), csSingle.vecY(), csSingle.vecZ() );
				bdEnt.transformBy(cs2em);	
			}
			//bdEnt.vis(6);
		}
		else if (tsl.bIsValid())
		{ 
		//Enable visibility for stackItem relations	
			if (IsStackItem(tsl)) 
				bAdd = true;
			bdEnt = tsl.realBodyTry(_XW+_YW+_ZW);
			Point3d pt = bdEnt.ptCen();
		
		// if the tsl does not provide a solid create a dummy solid
			if (bdEnt.volume()<pow(dEps,2))
			{ 
				CoordSys cs=tsl.coordSys();
				Vector3d vecXT = cs.vecX();
				Vector3d vecYT = cs.vecY();
				Vector3d vecZT = cs.vecZ();
				if (!vecXT.isPerpendicularTo(vecYT))
				{ 
					vecXT = _XW;
					vecYT = _ZW;
				}
				vecZT = vecXT.crossProduct(vecYT);
				
				bdEnt = Body(tsl.ptOrg(),vecXT, vecYT, vecZT, U(100), U(100), U(100));
				pt = tsl.ptOrg();
			}
			//bdEnt.vis(6);
		}
		else if (ce.bIsValid() && bIsTypeMetalpart)//#CE
		{ 
			CoordSys cs2 = ce.coordSys();

		// Get content of definition		
			MetalPartCollectionDef cd = ce.definition();
			GenBeam gbsM[] = cd.genBeam();
			TslInst tslsM[] = cd.tslInst();
			Entity entsM[] = cd.entity();			
			
			Body bdX;
			for (int i = 0; i < gbsM.length(); i++)
			{
				GenBeam x = gbsM[i];
				if (x.bIsDummy()) { continue; }
				bdX.combine(x.envelopeBody(true, true));	
			}
			for (int i = 0; i < tslsM.length(); i++)
			{
				TslInst x = tslsM[i];
				Body bd = x.realBodyTry();
				if (bd.isNull()) { continue; }
				bdX.combine(bd);	
			}	
			for (int i = 0; i < entsM.length(); i++)
			{
				if (gbsM.find(entsM[i])>-1){ continue;}
				if (tslsM.find(entsM[i])>-1){ continue;}
				Body bd = entsM[i].realBodyTry();
				if (bd.isNull()) { continue; }
				bdX.combine(bd);		
			}				
			bdX.transformBy(cs2);
			bdX.vis(i+1);
			bdEnt = bdX;
		
		//do not add the metalpart itself if the painter refers to genbeams
			if (bIsGenBeamPainter)
			{
				bAdd = false; 
			}

		}			
		else if (truss.bIsValid() || massgroup.bIsValid() || massElement.bIsValid())
			bdEnt = ents[i].realBody();
		else if (element.bIsValid())
		{ 
			Vector3d vecZE = element.vecZ();
			Wall wall = (Wall)element;
			ElementRoof elr = (ElementRoof)element;
			PLine plEnvelope = element.plEnvelope();

			if (elr.bIsValid())//HSB-22792
			{ 
				LineSeg seg = element.segmentMinMax();
				plEnvelope.projectPointsToPlane(Plane(seg.ptMid(), vecZE), vecZE);
				double dZ = abs(vecZE.dotProduct(seg.ptEnd() - seg.ptStart()));
				dZ = dZ < dEps ? element.dBeamWidth() : dZ;
				dZ = dZ < dEps ? U(1) : dZ;
				bdEnt=Body(plEnvelope, vecZE * dZ ,0);
				//plEnvelope.vis(4);seg.vis(6);
			}
			else	
			{
				bdEnt = element.realBody();		//bdEnt.vis(3);
			}
			if (bdEnt.volume()<pow(dEps,3)) //HSB-24510 catching solid of element if not used or present in display
			{ 
				double dZ = element.dBeamWidth();
				if (dZ < dEps && wall.bIsValid())
					dZ = wall.instanceWidth(); // catch sip walls dZ = 0
	
				if (dZ>dEps)
					bdEnt=Body(plEnvelope, vecZE * dZ ,- 1);
				
				if (bdEnt.volume()>pow(dEps,3))
					pp =  bdEnt.shadowProfile(pnZMS);				
				else if (vecZView.isParallelTo(vecZE))
					pp = PlaneProfile(plEnvelope);
			}
			else 
				pp =  bdEnt.shadowProfile(pnZMS);// HSB-15625
		}
		else if (fastener.bIsValid())
		{ 
			bdEnt = ents[i].realBody();		
			//bdEnt.vis(6);
		}
	// find a potential metal part in the relations map to transform the body from definition to entity


	// skip any entity not in intersection if defined HSB-6159		
		PlaneProfile ppSlice; // HSB-9215 resolve secrtion depth = 0
		if (bdEnt.isNull()) // HSB-22167 catching null refs
			bSkip = true;
		else if (bHasSectionDepth && dSectionDepth>dEps)
			bSkip=!bdSection.hasIntersection(bdEnt);
		else if (!bHasSectionDepth && abs(dSectionDepth)<dEps && bHasSection)// get a slice if section depth is 0
		{
			ppSlice = bdEnt.getSlice(pnZMS);
			if(ppSlice.area() < pow(dEps, 2))
			{ 
				//bdEnt.vis(1);
				bSkip=true;				
			}
		}
		
		bdAllShadows[i]=bdEnt;
		if (bSkip)
		{ 
			if (bDebug)
			{ 
				pp = bdEnt.shadowProfile(pnZMS);
				pp.vis(1);
			}
			
			ents.removeAt(i);			 
			dAreas.removeAt(i);
			ppShadows.removeAt(i);
			cesRef.removeAt(i);
			continue;
		}
		
		if (bHasSectionDepth && abs(dSectionDepth)<dEps)
			pp = ppSlice;
		else if (gb.bIsValid())
		{
			if (bHasSectionDepth && dSectionDepth ==0)
				pp = ppSlice;
			else
			{
				//bdEnt.vis(4);
				pp = bdEnt.shadowProfile(pnZMS);
			}
			
		// clip profile to section		
			if (bHasSection)
			{
				// HSB-22127 accepting entities which are not interscting the clipping profile
				PlaneProfile ppInt = pp;
				if (ppInt.intersectWith(ppClip))
					pp = ppInt;
					
				//if (bDebug){Display dpx(i);dpx.draw(pp, _kDrawFilled,30);}	
			}
		}
		else if (!element.bIsValid())
		{
			if (bHasSectionDepth && dSectionDepth ==0)
			{
				pp = ppSlice;
			}
			else 
			{
				pp = bdEnt.shadowProfile(pnZMS);
			}
			
			
			
		}		
		pp.transformBy(ms2ps);	pp.vis(2);	
		pp.project(Plane(csW.ptOrg(), csW.vecZ()), csW.vecZ(), dEps );
		//if(bDebug){ Display dpx(6); dpx.draw(pp,_kDrawFilled, 10);}	
		
//pp.vis(i);
	// validate by painter
		if (nPainter>-1)
		{ 
			if (bAdd && sPainterFilter.length() > 0 && !ents[i].acceptObject(sPainterFilter)) 
				bAdd = false;
		}
	// check format rules
		else
		{ 
			for (int j=0;j<mapFormats.length();j++) 
			{ 
				Map m= mapFormats.getMap(j);
				int nEntityType = m.getInt("Type");
				if (nEntityType != 0 && nEntityType != 1) continue;
				
				int bBeamPackFormat = m.getInt("BeamPackFormat"); // flag if this format applies to beampacks
				if (bBeamPackFormat)continue;
				
				String format = m.getString("Format");
				String values[0];
				if (m.hasMap("Value[]"))
				{ 
					Map m2 = m.getMap("Value[]");
					for (int k=0;k<m2.length();k++) 
					{ 
						if(m2.hasString(k) && m2.keyAt(k).makeUpper()=="VALUE")
							values.append(m2.getString(k));
						 
					}//next k
					
				}
				else if (m.hasString("Value"))
					values.append(m.getString("Value"));
				String _value = ents[i].formatObject(format);
				int nOperation = m.getInt("Operation");
				
			// resolve unknown
				if (format.find("@(Color)",0,false)>-1)
					_value = ents[i].color();
				else if (format.find("@(Beamtype)",0,false)>-1 && gb.bIsValid())
					_value = _BeamTypes[gb.type()];
				else if (format.find("@(ModelDescription)",0,false)>-1 && tsl.bIsValid())
					_value = tsl.modelDescription();
				else if (format.find("@(MaterialDescription)",0,false)>-1 && tsl.bIsValid())
					_value = tsl.materialDescription();				
				_value.makeUpper();
	
				//reportMessage("\nformat " + format + " value " + value + " _value " + _value + " operation " + nOperation);
				
				int bMatch = values.findNoCase(_value, -1) >- 1;
				
			// exclude operation, values match	or include operation, values do not match
				if ((nOperation == 0 && bMatch) || (nOperation == 1 && !bMatch))
				{
					bAdd = false;
					break;
				}
			}//next j			
		}

	// add parent contour to protection area
		if (bIsTypeMetalpart && !bAdd && (nPlacement==2 || nPlacement ==1))
		{ 
			ppProtect.unionWith(pp);
			//if (bDebug){Display dpx(1);dpx.draw(pp, _kDrawFilled,30);}
		}
		else if (nPlacement ==2)
		{ 
			ppProtect.unionWith(pp);
			//if (bDebug){Display dpx(1);dpx.draw(pp, _kDrawFilled,30);}
		}

		if (!bAdd)
		{ 
			//if (bDebug){Display dpx(1);dpx.draw(pp, _kDrawFilled,80);}
			ents.removeAt(i); 
			dAreas.removeAt(i);
			ppShadows.removeAt(i);
			cesRef.removeAt(i);
		}
		else
		{ 
			dAreas[i]=pp.area();
			//pp.vis(3);
			ppShadows[i]=pp;
	
		}
	
	//region Append Entities of MetalPartCollectionEntity		
	// dive into the definition and collect nested of showset	HSB-20497				
		if (bIsTypeMetalpart && bIsGenBeamPainter)
		{ 
			bAdd = false; // do not add defining
			Entity entsNested[0];
			entsNested= getMetalPartEntities(ce, entsNested);						
			entsNested = painter.filterAcceptedEntities(entsNested);	
			CoordSys cse =ce.coordSys();

			for (int j=0;j<entsNested.length();j++) 
			{ 
				Entity e= entsNested[j]; 
				GenBeam gb = (GenBeam)e; 
				bdEnt = gb.envelopeBody(false, true);
				bdEnt.transformBy(cse);					//bdEnt.vis(40);	// HSB-21294
				pp = bdEnt.shadowProfile(pnZMS);
				pp.transformBy(ms2ps);

				if (bHasSection)
					pp.project(Plane(_Pt0, _ZW), _ZW, dEps);

//				if (bDebug){PlaneProfile ppx = pp; ppx.shrink(-U(30));Display dpx(4);dpx.draw(ppx, _kDrawFilled,20);}
//				PLine (pp.ptMid(), _PtW).vis(6);
				
				//if(bDebug){ Display dpx(6); dpx.draw(pp,_kDrawFilled, 10);}	
				
				
				entsMP.append(e);
				dAreasMP.append(pp.area());
				ppShadowsMP.append(pp);
				cesRefMP.append(ce); // keep MPCE ref
				
				
			// count for grouping	
				String key  = gb.posnum();
				int n = sUniqueKeys.find(key);
				if (n<0)
				{ 
					nQuantities.append(1);
					sUniqueKeys.append(key);
				}	
				else nQuantities[n]++; 
				
				
				
				
			}//next j
		}			
	//endregion 	

	}
	
	ents.append(entsMP);
	dAreas.append(dAreasMP);
	ppShadows.append(ppShadowsMP);
	cesRef.append(cesRefMP);
	
	if (nPlacement==2)
	{ 
		ppProtect.shrink(-dTextHeight);
		ppProtect.shrink(dTextHeight);		
	}

	
	
//endregion 

//endregion Part #4


//region Trigger SetSectionDepth/ SetSectionOffset
	int bTriggerSetSectionDepth = _bOnRecalc && _kExecuteKey == sTriggerSetSectionDepth;	
	int bTriggerSetSectionOffset = _bOnRecalc && _kExecuteKey == sTriggerSetSectionOffset;
	if (bTriggerSetSectionDepth || bTriggerSetSectionOffset)
	{
		
	// Get clip range
		CoordSys csClip = clipVolume.coordSys();
		PlaneProfile ppClipRange=bdClip.shadowProfile(Plane(csClip.ptOrg(), csClip.vecZ()));
		LineSeg segRange = ppClipRange.extentInDir(csClip.vecX());
		segRange.vis(40);

		double dX = abs(csClip.vecX().dotProduct(segRange.ptStart() - segRange.ptEnd()));
		double dY = abs(csClip.vecY().dotProduct(segRange.ptStart() - segRange.ptEnd()));
		
		Point3d ptClip = segRange.ptMid() + viewFromDir * .5 * dY;

	// Set section properties by values
		if (viewFromDir.isParallelTo(getViewDirection(2)))	
		{ 
			reportNotice(T("\n") + scriptName() +T(" |Tip|")+TN("|Set current view to model section view direction to have access to graphical definition.|"));
			if (bTriggerSetSectionDepth)
			{ 
				String prompt = T("|Enter section depth, 0 = slice|");
				if (_Map.hasDouble(kSectionDepth))prompt += T(", |enter a value < 0 to remove override|");
				double d = getDouble(prompt);
				if (d>=0)
					_Map.setDouble(kSectionDepth, d);
				else
					_Map.removeAt(kSectionDepth, true);				
			}
			else if (bTriggerSetSectionDepth)
			{ 
				String prompt = T("|Enter section offset|");
				double d = getDouble(prompt);
				if (d>0)
					_Map.setDouble(kSectionOffset, d);
				else
					_Map.removeAt(kSectionOffset, true);
			}				
		}
	//region Set section properties by jigging
		else
		{ 
			String prompt1 = T("|Pick point to set section depth [Depth/Offset/Slice/Reset]|");
			String prompt2 = T("|Pick point to set section offset [Depth/Offset/Slice/Reset]|");
			
			
			int bGetOffset = bTriggerSetSectionDepth?false:true;
			String prompt = bGetOffset?prompt2:prompt1;
			PrPoint ssP(prompt); // second argument will set _PtBase in map
		    Map mapArgs;
		    
		    mapArgs.setVector3d("vecX", csClip.vecX());
		    mapArgs.setVector3d("vecY", csClip.vecY());
		    mapArgs.setVector3d("vecZ", viewFromDir);
		    
		    mapArgs.setDouble(kSectionOffset, abs(dSectionOffset));
		    mapArgs.setDouble(kSectionDepth, dSectionDepth);		    
		    mapArgs.setDouble("dX", dX);
		    
		    mapArgs.setInt("getOffset", bGetOffset);
		    mapArgs.setPoint3d("ptClip", ptClip);
		    mapArgs.setPlaneProfile(kClipRange, ppClipRange);
	
		// Get interscting shadows
			Map mapY, mapZ;
			for (int i=0;i<bdAllShadows.length();i++) 
			{ 
				PlaneProfile pp =bdAllShadows[i].shadowProfile(pnZMS);
				pp.transformBy(ms2ps);
				mapZ.appendPlaneProfile("pp",pp);
			
				Vector3d vecYS = csClip.vecX().crossProduct(-viewFromDir);
				pp =bdAllShadows[i].shadowProfile(Plane(csClip.ptOrg(),vecYS));
				mapY.appendPlaneProfile("pp",pp);			 
			}//next i	
	
			mapArgs.setMap("ProfileY[]", mapY);
			mapArgs.setMap("ProfileZ[]", mapZ);
	
		   	// Show Jig
		    Point3d ptPick;
		    int nGoJig = -1;
		    int cnt;
			while (nGoJig != _kNone)//nGoJig != _kOk &&
			{
				nGoJig = ssP.goJig("JigSection", mapArgs);
				//if (bDebug)reportMessage("\ngoJig returned: " + nGoJig + " cnt " + cnt);
				
				if (nGoJig == _kOk)
				{
					ptPick = ssP.value(); //retrieve the selected point
					if (bGetOffset)
					{
						dSectionOffset = abs(viewFromDir.dotProduct(ptPick - ptClip));
						mapArgs.setDouble(kSectionOffset, dSectionOffset);
						_Map.setDouble(kSectionOffset, dSectionOffset);
						reportMessage(TN("|Section offset set to| ") + dSectionOffset);
						cnt++;
					}
					else
					{
						dSectionDepth = abs(viewFromDir.dotProduct(ptPick - (ptClip - viewFromDir * dSectionOffset)));
						mapArgs.setDouble(kSectionDepth, dSectionDepth);
						_Map.setDouble(kSectionDepth, dSectionDepth);
						reportMessage(TN("|Section depth set to| ") + dSectionDepth);
						cnt++;
					}
					
					if (cnt > 1)break;
					
					bGetOffset = ! bGetOffset;
					mapArgs.setInt("getOffset", bGetOffset);
					prompt = bGetOffset ? prompt2 : prompt1;
					ssP = PrPoint(prompt + T(" |<Enter> to accept current settings|"));
				}
				else if (nGoJig == _kKeyWord)
				{
					if (ssP.keywordIndex() == 0)
					{
						bGetOffset = false;
						mapArgs.setInt("getOffset", bGetOffset);
					}
					else if (ssP.keywordIndex() == 1)
					{
						bGetOffset = true;
						mapArgs.setInt("getOffset", bGetOffset);
					}
					else if (ssP.keywordIndex() == 2)
					{
						dSectionDepth = 0;
						mapArgs.setDouble(kSectionDepth, dSectionDepth);
						_Map.setDouble(kSectionDepth, dSectionDepth);
						reportMessage(TN("|Section depth set to| ") + dSectionDepth);
						bGetOffset = true;
						mapArgs.setInt("getOffset", bGetOffset);
						cnt++;
					}				
					else
					{
						dSectionDepth = - 1; // <0 means take defauklt clip dimension
						dSectionOffset = 0;
						_Map.removeAt(kSectionDepth, true);
						_Map.removeAt(kSectionOffset, true);
						break;
					}
				}
				else if (nGoJig == _kCancel)
				{
					setExecutionLoops(2);
					return;
				}
			}
			
			if (nGoJig == _kNone)
			{ 
				_Map.setDouble(kSectionOffset, dSectionOffset);
				_Map.setDouble(kSectionDepth, dSectionDepth);
				reportMessage(TN("|Section offset set to| ") + dSectionOffset);
				reportMessage(TN("|Section depth set to| ") + dSectionDepth);
			}			
		}
		
		
	//endregion 

		
		setExecutionLoops(2);
		return;				
	}
//endregion	

//region Group Filtered Painter Results PG
	if (bGroupByPainter)
	{ 
	// order byArea descending to place the tag near the greatest visible item of the group
		for (int i=0;i<ents.length();i++) 
			for (int j=0;j<ents.length()-1;j++) 
				if (dAreas[j]<dAreas[j+1])
				{
					ents.swap(j, j + 1);
					dAreas.swap(j, j + 1);
					ppShadows.swap(j, j + 1);
					cesRef.swap(j, j+1);
				}

	// collect groups	
		String sGroupFormats[0];
		Entity entsG[0];
		for (int i=0;i<ents.length();i++) 
		{ 
			Entity ent = ents[i]; 
			String sGroupFormat = ents[i].formatObject(sPainterFormat);
			if (sGroupFormats.findNoCase(sGroupFormat,-1)<0)
				sGroupFormats.append(sGroupFormat);
			 
		}//next i
	
	// combine shadows
		PlaneProfile ppGroupShadows[sGroupFormats.length()];
		Entity entRefs[sGroupFormats.length()];
		MetalPartCollectionEnt ceGroups[sGroupFormats.length()];
		
		for (int i=0;i<ents.length();i++) 
		{ 			
			String sGroupFormat = ents[i].formatObject(sPainterFormat);
			int n = sGroupFormats.find(sGroupFormat);
			if (n < 0)continue;
			
			PlaneProfile pp = ppShadows[i];
			pp.shrink(-dEps);	//pp.vis(2);
			PlaneProfile& ppG = ppGroupShadows[n];
			if (ppG.area()<pow(dEps,2))
			{
				ppG = pp;
				entRefs[n] = ents[i];
				ceGroups[n] = cesRef[i];
			}
			else
				ppG.unionWith(pp);
		}//next i
		
	// rebuild selection set
		Entity _ents[0];
		PlaneProfile pps[0];
		double areas[0];
		MetalPartCollectionEnt _ces[0];
		
		for (int i=0;i<entRefs.length();i++) 
		{ 
			Entity& ent = entRefs[i]; 
			PlaneProfile& pp = ppGroupShadows[i];
			if (ent.bIsValid() && pp.area()>pow(dEps,2))
			{ 
				pp.shrink(dEps);			
				_ents.append(ent);
				_ces.append(ceGroups[i]);
				pps.append(pp);
				areas.append(pp.area());
			}
		}//next i
		
		if (_ents.length()>0)
		{ 
			ents = _ents;
			ppShadows = pps;
			dAreas = areas;
			cesRef = _ces;
		}

	// order horizontal
		for (int i=0;i<ents.length();i++) 
			for (int j=0;j<ents.length()-1;j++) 
			{ 
				double d1 = vecXView.dotProduct(_Pt0 - ppShadows[j].ptMid());
				double d2 = vecXView.dotProduct(_Pt0 - ppShadows[j + 1].ptMid());
				if (d1>d2)
				{
					ents.swap(j, j + 1);
					dAreas.swap(j, j + 1);
					ppShadows.swap(j, j + 1);
					cesRef.swap(j, j+1);
				}				
			}

	// draw filled
		Display dp(-1), dpBackground(-1);dpBackground.trueColor(rgb(255, 255, 254), ntPG );
		dp.dimStyle(sDimStyle);
		
		if (bHatchSolidPG)
			for (int i=0;i<ppShadows.length();i++)
			{ 
				PlaneProfile& pp = ppShadows[i];
			// set the color
				int c = i;
				if (nSeqColors.length()>0)
				{
					int n=i;
					while(n>nSeqColors.length()-1)
						n-=nSeqColors.length();
					c=nSeqColors[n];
				}
				dp.color(c);
				if (ntPG>0 && ntPG<100)
					dpBackground.draw(pp, _kDrawFilled);	
				else if (ntPG<0 && ntPG>-100)	
					dp.draw(pp, _kDrawFilled);				
				//dp.draw(pp, _kDrawFilled, ntPG);
			}
	}
//endregion 

//region Get BeamPacks
	EntityCollection entCollections[0];
	if(bGroupPosNum)
	{ 
		Beam beams2Pack[0];
		String sDiffers[] ={};
		for (int i=0;i<ents.length();i++) 
		{ 
			Beam bm = (Beam)ents[i];
			if (!bm.bIsValid()){continue;}
			int posnum = bm.posnum();
			if (posnum < 1){continue;}
			
			String sDiffer = posnum;
			
		// check format rules
			for (int j=0;j<mapFormats.length();j++) 
			{ 
				Map m= mapFormats.getMap(j);
				int nEntityType = m.getInt("Type");
				if (nEntityType != 0 && nEntityType != 1) continue;
				
				int bBeamPackFormat = m.getInt("BeamPackFormat"); // flag if this format applies to beampacks
				if (!bBeamPackFormat)continue;
				
				String format = m.getString("Format");
				String value = m.getString("Value");
				String _value = bm.formatObject(format);
				int nOperation = m.getInt("Operation");
				
			// resolve unknown
				if (format.find("@(Color)",0,false)>-1)
					_value = bm.color();
				else if (format.find("@(Beamtype)",0,false)>-1)
					_value = _BeamTypes[bm.type()];

				value.makeUpper();
				_value.makeUpper();

				//reportMessage("\nformat " + format + " value " + value + " _value " + _value + " operation " + nOperation);
			// exclude operation, values match	
				if (nOperation == 0 && value==_value)
					sDiffer += bm.handle();
			// include operation, values match			
				else if (nOperation == 1 && value==_value)
					sDiffer += _value;	
			// include operation, values do not match			
				else if (nOperation == 1 && value!=_value)
					sDiffer += bm.handle();	
			}//next j
			
			sDiffers.append(sDiffer);
			beams2Pack.append(bm);
		}//next i		
		entCollections=Beam().composeBeamPacks(beams2Pack,sDiffers);

	// remove single packs
		for (int i=entCollections.length()-1; i>=0 ; i--) 
			if(entCollections[i].beam().length()<2)
				entCollections.removeAt(i); 
	}	
//End Get BeamPacks//endregion 

//region Merge profiles of packed beams
	for (int e=0;e<entCollections.length();e++) 
	{ 
		Beam packs[] = entCollections[e].beam();
		if (packs.length() < 2)continue;
		int first = ents.find(packs.first());
		PlaneProfile pp = ppShadows[first];
		
	// merge and remove
		for (int i=packs.length()-1; i>0 ; i--) 
		{ 
			int n2 = ents.find(packs[i]);
			pp.unionWith(ppShadows[n2]);
			
		// remove areas, profiles and entities
			dAreas.removeAt(n2);
			ppShadows.removeAt(n2);
			ents.removeAt(n2);
			cesRef.removeAt(n2);
		}//next i
		first = ents.find(packs.first());
		dAreas[first] = pp.area();
		ppShadows[first] = pp;
	}//next i		
//End merge profiles of packed beams//endregion 

//region Ordering
	if (bHasStaticLoc)
	{ 
	// order type, element and byPosNum
		for (int i=0;i<ents.length();i++) 
			for (int j=0;j<ents.length()-1;j++) 
			{
				String s1 = ents[j].typeDxfName();
				String s2 = ents[j+1].typeDxfName();
			// element
				Element e1 = ents[j].element();
				Element e2 = ents[j+1].element();
				if (e1.bIsValid())s1 += e1.number() + "_";
				if (e2.bIsValid())s2 += e2.number() + "_";
			// genbeam	
				GenBeam x1 = (GenBeam)ents[j], x2 = (GenBeam)ents[j + 1];
				if (x1.bIsValid() && x2.bIsValid())
				{ 
					s1 += x1.posnum();
					s2 += x2.posnum();
				}
			// tsl
				else
				{ 
					TslInst x1 = (TslInst)ents[j], x2 = (TslInst)ents[j + 1];
					if (x1.bIsValid() && x2.bIsValid())
					{ 
						s1 += x1.opmName() + "_"+x1.posnum();
						s2 += x2.opmName() + "_"+x2.posnum();	
					}					
				}
				if (s2>s1)
				{ 
					ents.swap(j, j+1);
					ppShadows.swap(j, j+1);
					dAreas.swap(j, j+1);
					cesRef.swap(j, j+1);
				}
			}
	}
	else
	{ 
	//order by size: the smaller the size the harder it gets to place a text on top of it
		for (int i=0;i<ents.length();i++) 
			for (int j=0;j<ents.length()-1;j++) 
			{ 
				if(dAreas[j]>dAreas[j+1])
				{ 
					ents.swap(j, j+1);
					ppShadows.swap(j, j+1);
					dAreas.swap(j, j+1);
					cesRef.swap(j, j+1);
				}
			}		
	}
//End Ordering//endregion 

//region declare the protected profile
// get papersize
	Vector3d vecZ = _ZW;

	PlaneProfile ppPreferred(csW);
	
	if (!bHasStaticLoc)
	{ 
		TslInst tslTags[0];// TODO
		PlaneProfile ppProtectPriority; // the protection area of a instance with higher priority
	
	// get protected profile of previous
		{ 
			int n = tslTags.find(_ThisInst);
			if (n>0)
			{
				ppProtectPriority = tslTags[n - 1].map().getPlaneProfile("ppProtect");
				//ppProtectPriority.vis(55);
			}
		}
		int bHasPriority = ppProtectPriority.area()>pow(dEps,2);
		
	// add inverse viewport to ensure tags are within viewport
		if (nPlacement!=1)//() && nPlacement!=1
		{ 	
			if (nPlacement<2 || !bHasPreferred)
				ppVpInverse.subtractProfile(ppVp);	

			if (ppProtect.area()<pow(dEps,2))	
				ppProtect= ppVpInverse;
			else								
				ppProtect.unionWith(ppVpInverse);		
			
			//ppVpInverse.extentInDir(_XW).vis(6);
		}
		
		
//{ 
//	PlaneProfile pp = ppProtect;
//	{Display dpx(4); dpx.draw(pp, _kDrawFilled,20);}
//}
	
	// Section
		if (bHasSection && (nPlacement==1 || nPlacement==2))
		{ 
		// close gaps
			PlaneProfile pp;
			pp = ppParent;
			pp.shrink(-2*dTextHeightStyle);
			pp.shrink(2*dTextHeightStyle);
			
		// add parent protection	
			if (ppProtect.area()<pow(dEps,2))	ppProtect= pp;
			else								ppProtect.unionWith(pp);			
		}
	// subtract preferred tag areas from protected areas		
		for (int i=0;i<mapTagProfiles.length();i++) 
		{ 
			if (mapTagProfiles.hasPlaneProfile(i))
			{
				PlaneProfile pp = mapTagProfiles.getPlaneProfile(i);
				pp.vis(7);
				
			// collect preferred profile	
				if (ppPreferred.area()<pow(dEps,2))
					ppPreferred = pp;
				else
					ppPreferred.unionWith(pp);
				//ppProtect.subtractProfile(pp);
				 
			}
		}//next i
	
	// merge priority and protection area of _ThisInst
		bHasPreferred = ppPreferred.area() > pow(dEps, 2);
		if (bHasPriority)
		{ 
		// make sure the prferred is not overlapping with the priority protection
			if (bHasPreferred)
			{ 
				ppPreferred.subtractProfile(ppProtectPriority); 
				bHasPreferred = ppPreferred.area() > pow(dEps, 2);
				ppProtect.subtractProfile(ppPreferred);			
			}
			if (ppProtect.area()>pow(dEps,2))
				ppProtect.unionWith(ppProtectPriority);		
		}
		else if (bHasPreferred)
		{ 
			ppProtect.subtractProfile(ppPreferred);		
		}		
	}
	
//	if (bDebug)
//	{ 
//		Display dpx(2);
//		dpx.draw(ppProtect, _kDrawFilled);
//		ppProtect.vis(6);		
//	}	
	
//End declare the protected profile//endregion 

//region Trigger AddNoTagArea
	if (!bHasPreferred && !bHasStaticLoc)
	{ 
		String sTriggerAddNoTagArea = T("|Add No-Tag Area|");
		addRecalcTrigger(_kContextRoot, sTriggerAddNoTagArea );
		if (_bOnRecalc && _kExecuteKey == sTriggerAddNoTagArea)
		{
		// prompt for polylines
			Entity _ents[0];
			PrEntity ssEpl(T("|Select polylines|"), EntPLine());
		  	if (ssEpl.go())
				_ents.append(ssEpl.set());
			
			PlaneProfile pp;
			for (int j=_ents.length()-1; j>=0 ; j--) 
			{ 
				EntPLine epl=(EntPLine)_ents[j]; 
				pp.joinRing(epl.getPLine(), _kAdd);
				epl.dbErase();
			}//next j
			
		// no polylines selected -> get the defining diagonal
			if (pp.area() < pow(dEps, 2))
			{
				Point3d pt = getPoint(T("|Pick first corner|"));
				// prompt for second point input
				Point3d pts[0];
				while (pts.length() < 1)
				{
					PrPoint ssP(TN("|Select opposite corner|"), pt);
					if (ssP.go() == _kOk)
						pts.append(ssP.value());
					else
						break;
				}
				if (pts.length() > 0)
					pp.createRectangle(LineSeg(pt, pts[0]), _XW, _YW);
			}
		
		// store
			if (pp.area() > pow(dEps, 2))
			{
				Map map = _Map.getMap("NoTag[]");
				map.appendPlaneProfile("NoTag", pp);
				_Map.setMap("NoTag[]", map);
			}		
	
			setExecutionLoops(2);
			return;
		}		
	}
	
//endregion

//region Add custom defined no tag areas
	if (_Map.hasMap("NoTag[]"))
	{ 
//		String sTriggerRemoveNoTagdArea = T("|Remove No-Tag Areas|");
//		addRecalcTrigger(_kContext, sTriggerRemoveNoTagdArea );
//		if (_bOnRecalc && _kExecuteKey==sTriggerRemoveNoTagdArea)
//		{
//			_Map.removeAt("NoTag[]", true);
//			setExecutionLoops(2);
//			return;
//		}			

		Map m = _Map.getMap("NoTag[]");
		for (int i=0;i<m.length();i++) 
		{ 
			PlaneProfile pp = m.getPlaneProfile(i);
//			if (bHasSDV)   // TODO if the scale is set to autoscale the profiles need to be transformed accordingly, probably needs a location from block space HSB-15730
//			{
//				PLine rings[]=pp.allRings(true, false);
//				if (rings.length() > 0) dp.draw(rings[0]);
//				pp.transformBy(ps2ms);
//				
//				dp.color(i + 1);
//				if (rings.length() > 0) dp.draw(rings[0]);
//			}
			//pp.vis(i);
			if (ppProtect.area()<pow(dEps,2))
			{
				ppProtect= pp;
			}
			else
			{
				ppProtect.unionWith(pp);	 
			}
		}//next i	
	}
			
//endregion 	





//region Add element outlines to protection area
	if (bNotOnParent)
	{ 
		PlaneProfile ppx(csW);
		for (int i=0;i<elParents.length();i++) 
		{ 
			Element& e = elParents[i];
			int n= ents.find(e);
			
			PlaneProfile ppe;
			if (n>-1)
				ppe = ppShadows[n];
			else
			{ 
				Vector3d vecZE = e.vecZ();
				LineSeg segE = e.segmentMinMax();
				double dZ = abs(vecZE.dotProduct(segE.ptStart() - segE.ptEnd()));
				PLine pl = e.plEnvelope();
				pl.projectPointsToPlane(Plane(segE.ptMid(), vecZE), vecZE);		
	
				if (pl.area()>pow(dEps,2) && dZ>dEps)
				{ 
					Body bd(pl, vecZE * dZ, 0);
					bd.transformBy(ms2ps);
					//bd.vis(20);	
					
					ppe = bd.shadowProfile(pnZPS);
	
		
				}
	
			}
			
			if (bIsPlanView)
			{ 
				CoordSys cse = ppe.coordSys();
				ppe.createRectangle(ppe.extentInDir(cse.vecX()), cse.vecX(), cse.vecY());
			}
			
			//{ Display dpx(3);		dpx.draw(ppe, _kDrawFilled,20);}	
			ppe.shrink(2*dEps);
			ppx.unionWith(ppe);

		}//next i
		//ppx.shrink(-(dEps));
		ppProtect.unionWith(ppx);
		//{ Display dpx(2);		dpx.draw(ppProtect, _kDrawFilled,20);}		
	}


//endregion 

//region Build protection area of parent collectionEntity
	if (bNotOnParent && (bIsTypeMetalpart))// ||mapRelations.length()>0))
	{ 
		for (int i=0;i<ents.length();i++) 
		{ 
			Entity ent = ents[i];
			MetalPartCollectionEnt ce = (MetalPartCollectionEnt)ent;
			if (!ce.bIsValid()){ continue;}
			
			PlaneProfile pp = ppShadows[i];
			PLine plines[] = pp.allRings(true, false);
				for (int jj=0;jj<plines.length();jj++) 
					ppProtect.joinRing(plines[jj], _kAdd);	

		}//next i
		
		ppProtect.vis(62);

	}
	else if (bNotOnParent && !bIsTypeTsl)
	{ 
		for (int i=0;i<ents.length();i++) 
		{ 
			
			TslInst t= (TslInst)ents[i];
			if (t.bIsValid() && !IsStackItem(t)){ continue;}
			else if (elParents.find(ents[i])>-1)
			{
				continue;
			}
			else
			{ 
				//Display dpx(30);		dpx.draw(ppProtect, _kDrawFilled,20);
				AddProtectionProfile(ppProtect, ppShadows[i]);
			}
		
			
			//{ Display dpx(i); dpx.draw( ppShadows[i],_kDrawFilled, 40);}

		}//next i
//		ppProtect.shrink(-.5 * dTextHeight);
//		ppProtect.shrink(.5 * dTextHeight);		
		ppProtect.vis(4);
	}
//
	//{ Display dpx(1); dpx.draw( ppProtect,_kDrawFilled, 20);}		
//endregion 

//region Trigger
// TriggerEditInPlacePanel
	String sTriggerEditInPlaces[] = {T("|Edit in Place|"),T("|Disable Edit in Place|")};
	String sTriggerEditInPlace = sTriggerEditInPlaces[bEditInPlace];
	if (!bHasStaticLoc)
		addRecalcTrigger(_kContextRoot, sTriggerEditInPlace);
	else if (_Map.hasInt("directEdit"))
		_Map.removeAt("directEdit", true);
	if (_bOnRecalc && (_kExecuteKey==sTriggerEditInPlace || (bHasPage && _kExecuteKey==sDoubleClick)   ) )
		{
		if (bEditInPlace)
		{
			bEditInPlace=false;
			_PtG.setLength(0);
			mapParent = Map();
			mapParents = Map();
			_Map.removeAt("Parent[]", true);
		}
		else
			bEditInPlace= true;
		_Map.setInt("directEdit",bEditInPlace);
		setExecutionLoops(2);
		//return;
	}
	
// Trigger AutoSelectMode
	String sTriggerAutoSelectMode =bAutoSelectMode?T("|Auto Selection off|"):T("|Auto Selection  on|");
	if (bHasViewport)addRecalcTrigger(_kContextRoot, sTriggerAutoSelectMode);
	if (_bOnRecalc && _kExecuteKey==sTriggerAutoSelectMode)
	{
		bAutoSelectMode = bAutoSelectMode ? false : true;
		_Map.setInt("AutoSelectMode", bAutoSelectMode);		
		setExecutionLoops(2);
		return;
	}

// Trigger TextAlignment
	int nTextAlignmentX;// center is default
	if (bHasStaticLoc)
	{ 
		nTextAlignmentX = _Map.hasInt("TextAlignmentX") ? _Map.getInt("TextAlignmentX") : 1;
		
		int nAlignments[] ={ - 1, 0, 1};
		String sAlignments[] ={ T("|Text Alignemnt Left|"), T("|Text Alignemnt Center|"), T("|Text Alignemnt Right|")};
		int x = nAlignments.find(nTextAlignmentX);
		for (int i=0;i<nAlignments.length();i++) 
		{ 
			if (x == i)continue;
			
			addRecalcTrigger(_kContextRoot, sAlignments[i]);
			if (_bOnRecalc && _kExecuteKey==sAlignments[i])
			{
				nTextAlignmentX = nAlignments[i];
				_Map.setInt("TextAlignmentX", nTextAlignmentX);		
				setExecutionLoops(2);
				return;
			}
		}//next i
	}
		
//endregion 

	//if (bDebug)ppProtect.vis(6);

// declare a map where the leader start points of identical posnums can be stored
	Map mapMultiGuide;
	
// the potential static location (placement = 4)
	Point3d ptStaticLoc = _Pt0;




//region Collect tag contents
	String sTags[ents.length()];
	CoordSys css[ents.length()]; // the collection of coordSys transformed to paperspace
	for (int i=0;i<ents.length();i++)
	{ 
	//region Cast Type
		Map m;
		Entity& e = ents[i];
		String handle = e.handle();
		Entity entTag = e;

		Beam b = (Beam)e;
		GenBeam g= (GenBeam)e;
		Sip p = (Sip)e;
		Sheet sheet= (Sheet)e;
		TslInst t= (TslInst)e;
		Opening o = (Opening)e;
		OpeningSF openingSF = (OpeningSF)e;
		TrussEntity truss= (TrussEntity)e;
		MetalPartCollectionEnt mce= (MetalPartCollectionEnt)e;
		MassGroup massgroup= (MassGroup)e;
		Element element = (Element)e;
		MassElement massElement= (MassElement)e;
		FastenerAssemblyEnt fastener= (FastenerAssemblyEnt)e;
		
	// assign stack reference as target	
		int bIsStackItem = IsStackItem(t);
		if (bIsStackItem)
		{ 
			Entity ents2[] = t.entity();
			if (ents2.length()>0)
				entTag = ents2.first();
		}

		CoordSys csE; // TODO validate this approach
		if (g.bIsValid())
			csE = g.coordSys();
	//endregion 	

	//region Common properties
		if (sAutoAttribute.find("@(CALCULATE WEIGHT",0,false)>-1)
		{
			Map mapIO,mapEntities;
			mapEntities.appendEntity("Entity", e);
			mapIO.setMap("Entity[]",mapEntities);
			TslInst().callMapIO("hsbCenterOfGravity", mapIO);
			double dWeight = mapIO.getDouble("Weight");// / dConversionFactor;			
			m.setDouble("Weight", dWeight, _kNoUnit);
		}		
	//endregion 

	//region Beam
		if (b.bIsValid())
		{ 
			m.setString("Surface Quality", b.texture());
			if (sAutoAttribute.find("@(Zone Alignment",0,false)>-1 && el.bIsValid())//HSB-12678
			{ 
				ElemZone zone = el.zone(b.myZoneIndex());
				Point3d pt = zone.ptOrg();
				double dZ = zone.dH();
				
				Vector3d vecZZone = zone.vecZ();
				double dZB = b.dD(vecZZone)*.5;
				
				double dA = abs(vecZZone.dotProduct(pt - b.ptCen()))-dZB;
				double dB = abs(vecZZone.dotProduct((pt+vecZZone*dZ) - b.ptCen()))-dZB;
				
				String text;
				if (dA<dEps && dB<dEps)
					text = T("|All Faces|");
				else if (dA<dEps)
					text = T("|Back|");
				else if (dB<dEps)
					text = T("|Front|");									
				else
					text = T("|No Face|");		
				m.setString("Zone Alignment", text);
			}			
		}			
	//endregion 

//	//region Sheet
//		else if (sheet.bIsValid())
//		{ 
//			m.setString("Material",sheet.material());
//
//		}
//	//endregion 

	//region Panel
		else if (p.bIsValid())
		{ 
			Vector3d vecGrain = p.woodGrainDirection();
			vecGrain.transformBy(ms2ps);		
			String quality;
			{ 
				String sQualities[] ={p.formatObject("@(surfaceQualityBottom)"), p.formatObject("@(surfaceQualityTop)")};
				if (p.vecZ().isCodirectionalTo(vecZView))sQualities.swap(0, 1);
				quality = sQualities[0] + " (" + sQualities[1] + ")";
			}
			SipComponent component = SipStyle(p.style()).sipComponentAt(0);
			
			m.setString("GrainDirectionText",vecGrain.isParallelTo(_XW) ? T("|Lengthwise|") : T("|Crosswise|"));
			m.setString("GrainDirectionTextShort",vecGrain.isParallelTo(_XW) ? T("|Grain LW|") : T("|Grain CW|"));
			m.setString("SurfaceQuality",quality);
			m.setString("Graindirection","  ");//  2 blanks
			m.setString("SipComponentName",component.name());
			m.setString("SipComponentMaterial",component.material());
		}
	//endregion 

	//region Element
		else if (element.bIsValid())
		{ 
			csE = element.coordSys();
			m.setString("Code",element.code());
			m.setString("Information",element.information());
			m.setString("Subtype",element.subType());
		}
	//endregion 
	
	//region MassElement
		else if (massElement.bIsValid())
		{ 
			csE = element.coordSys();
			m.setDouble("Height",massElement.height());
			m.setDouble("Width",massElement.width());
			m.setDouble("Radius",massElement.radius());
			m.setDouble("Rise",massElement.rise());
			m.setString("ShapeType",MassElement().shapeType2String(massElement.shapeType()));
		}
	//endregion 
	
	//region MetalPartCollectionEntity
		else if (mce.bIsValid())
		{ 
			csE = mce.coordSys();
			m.setString("Definition",mce.definition());
			m.setInt("ColorIndex",mce.color());

		}
	//endregion 
	
	//region Opening
		else if (o.bIsValid())
		{ 
			csE = o.coordSys();
			m.appendString("OpeningDescription",o.openingDescr() );
			m.appendString("Description",o.description() );		
			m.appendDouble("HeightRough",o.heightRough() );
			m.appendDouble("WidthRough",o.widthRough() );			
			if (openingSF.bIsValid())
			{ 
				m.appendString("StyleNameSF",openingSF.styleNameSF() );
				m.appendString("DescriptionPacking",openingSF.descrPacking() );
				m.appendString("DescriptionPlate",openingSF.descrPlate() );
				m.appendString("DescriptionSF",openingSF.descrSF() );				
				
				m.appendDouble("GapSide",openingSF.dGapSide() );
				m.appendDouble("GapTop",openingSF.dGapTop() );
				m.appendDouble("GapBottom",openingSF.dGapBottom() );
			}
	
		}
	//endregion 		
	
	//region TslInstance
		else if (t.bIsValid())
		{ 
			csE = t.coordSys();
			
			if (!bIsStackItem)
			{ 
				m.setInt("PosNum",t.posnum());
				m.setString("ModelDescription",t.modelDescription());
				m.setString("MaterialDescription",t.materialDescription());					
			}
		
		}
	//endregion
	
	//region FastenerAssembly
		else if (fastener.bIsValid())
		{ 	
			csE = fastener.coordSys();			
			Map data = GetFastenerDataMap(fastener);
			m.copyMembersFrom(data);			
		}
	//endregion			
			
		csE.transformBy(ms2ps);//
		css[i] =ppShadows[i].coordSys();// csE; // TODO validate this approach ;/
		sTags[i] =entTag.formatObject(sAutoAttribute,m);
	}// next i of ents
//endregion 

//region Grouped Display
	int bSetParentMap;

	if (bIsGrouped)
	{ 
	//region Set Display and collect unique tags
		Display dpBackground(-1), dpx(nc);
		dpx.dimStyle(sDimStyle);
		if (nTransparency<0)
		{ 
			dpBackground.color(nc);
			dpBackground.transparency(abs(nTransparency));
		}	
		else
			dpBackground.trueColor(rgb(255, 255, 254), nTransparency);
		if (dTextHeight>0)
		{
			dTextHeightStyle=dTextHeight;
			dpx.textHeight(dTextHeight);
		}			
	
	// Collect unique tags	
		String uniqueTags[0];
		for (int i=0;i<sTags.length();i++) 
			if (sTags[i].length()>0 && uniqueTags.findNoCase(sTags[i],-1)<0)
				uniqueTags.append(sTags[i]);
	//endregion 
	
	//region Collect items per group
		int nRemovals[0];

		
		for (int j=0;j<uniqueTags.length();j++) 
		{ 
			
		// Entities of this unique tag group	
			Entity entsG[0];
			int nTagRemovals[0]; // index list to remove entries
			String tag = uniqueTags[j]; 
			for (int i=0;i<sTags.length();i++) 
				if (tag == sTags[i])
					entsG.append(ents[i]);

		// Draw while entities in array
			while (entsG.length()>1)
			{ 
				int n = ents.find(entsG.first());
				if (n < 0)
				{
					entsG.removeAt(0);
					continue;
				}
				nTagRemovals.append(n);
				
			//region Highlight tag if 'posnum' in use but no posnum assigned
				int bRed;
				if (sAutoAttribute.find("(PosNum",0, false)>-1)
				{ 
					GenBeam gb = (GenBeam)ents[n];
					if (gb.bIsValid() && gb.posnum() < 0)bRed = true;
					
					TslInst t= (TslInst)ents[n];
					if (t.bIsValid() && t.posnum() < 0 && t.scriptName().find("Stack",0,false)!=0)bRed = true;		//HSB-23435			
				}				
				//dpBackground.trueColor(bRed?rgb(255,0,0):rgb(255, 255, 254), nTransparency);					
			//endregion 	

			//region Set Background
				if (nTransparency<0)
				{ 
					dpBackground.color(nc);
					dpBackground.transparency(abs(nTransparency));
				}	
				else
					dpBackground.trueColor(rgb(255, 255, 254), nTransparency);					
			//endregion 

				Vector3d vecXR = css[n].vecX();vecXR.normalize();
				Vector3d vecYR = css[n].vecY();vecYR.normalize();
				Vector3d vecZR = css[n].vecZ();vecZR.normalize();

				if (vecXR.isParallelTo(vecZView))
				{ 
					vecZR = vecXR;
					vecXR = vecYR.crossProduct(vecZR);
				}
				PlaneProfile ppRef = ppShadows[n];	
				vecXR.vis(ppRef.ptMid(), 1);vecYR.vis(ppRef.ptMid(), 3);vecZR.vis(ppRef.ptMid(), 150);				

			//region Collect aligned: entities of group must be parallel
				int numAligned; // counter of aligned ents
				for (int i=entsG.length()-1; i>0 ; i--) 
				{ 
					int n2 = ents.find(entsG[i]);
					if (n2>-1)
					{ 
						
						Vector3d vecXR2 = css[n2].vecX();vecXR2.normalize();
						Vector3d vecYR2 = css[n2].vecY();vecYR2.normalize();
						Vector3d vecZR2 = css[n2].vecZ();vecZR2.normalize();
						if (vecXR2.isParallelTo(vecZView))
						{ 
							vecZR2 = vecXR2;
							vecXR2 = vecYR2.crossProduct(vecZR2);
						}

						PlaneProfile ppi = ppShadows[n2];
						//vecXR2.vis(ppi.ptMid(), 1);						
						if (vecXR2.isParallelTo(vecXR) && ppi.intersectPoints(Plane(ppRef.ptMid(), vecXR), true,false).length()>0)
						{ 
							ppRef.unionWith(ppi);
							ppi.vis(j);
							entsG.removeAt(i);							
							nTagRemovals.append(n2);
							numAligned++;
						}
					}	 
				}//next i				
				if (numAligned<1) // HSB-18186
				{ 
					entsG.removeAt(0);
					continue;
				}					
			//endregion 


			// Create an range rectangle to identify intersections/multiple
				Point3d ptm = ppRef.ptMid();
				LineSeg segR = ppRef.extentInDir(vecXR);//segR.vis(40);
//				LineSeg segVerticalRange = segR;

				{ 
					double y = abs(vecYR.dotProduct(segR.ptEnd() - segR.ptStart()));
					double x = dTextHeightStyle;
					segR = LineSeg(ptm - .5 * (vecXR * x + vecYR * y), ptm + .5 * (vecXR * x + vecYR * y));
				}
				
				PlaneProfile ppRect; ppRect.createRectangle(segR, vecXR, vecYR);
				LineSeg segDiag = ppRect.extentInDir(vecYR);//ppRect.vis(5);segDiag.vis(5);
			
			// Subtract shadows which are not this tag group
				for (int i=0;i<ents.length();i++) 
				{ 
					if (nTagRemovals.find(i)>-1)continue;
					ppRect.subtractProfile(ppShadows[i]);				 
				}//next i
				
			//region Get Tag Orientation
				Vector3d vecXTag = bByVertical?_YW:_XW;
				if (bByEntity)
				{ 
					vecXTag=vecXR;
					if (vecXTag.dotProduct(_XW) < 0 && !vecXTag.isCodirectionalTo(_YW))vecXTag *= -1;
					if (vecXTag.dotProduct(_YW) < 0 && !vecXTag.isCodirectionalTo(_XW))vecXTag *= -1;
				}			
				Vector3d vecYTag = vecXTag.crossProduct(-_ZW);		
//				
//				{ 
//					PlaneProfile pp;
//					pp.createRectangle(segVerticalRange, vecXTag, vecYTag);
//					segVerticalRange = LineSeg(pp.ptMid() - vecXTag * .5 * pp.dX(), pp.ptMid() + vecXTag * .5 * pp.dX());
//				}
				
				
				
			//endregion 

				
			//region place on each which intersects with ppRef
				//LineSeg splits[] = ppRect.splitSegments(LineSeg(ptm - vecYR * U(10e5), ptm + vecYR * U(10e5)), true);
				LineSeg splits[] = ppRect.splitSegments(segDiag, true);
				for (int i=0;i<splits.length();i++) 
				{ 
					LineSeg segs[] = ppRef.splitSegments(splits[i], true);
					splits[i].vis(i);

					if (segs.length()>0)
					{ 
						Point3d pt,pts[0];
						for (int ii=0;ii<segs.length();ii++) 
						{
							//segs[ii].vis(5);
							pts.append(segs[ii].ptMid()); 
							
//							PLine c; c.createCircle(pts.last(), _ZW, .1 * dTextHeightStyle);
//							dpx.draw(PlaneProfile(c), _kDrawFilled,50);
//							ppProtect.joinRing(c, _kAdd);
						}
						pt.setToAverage(pts);

					//region The guide diagonal HSB-18668
						LineSeg segGuide = segDiag;
						if (pts.length()>1)
							segGuide = LineSeg(pts.first(), pts.last());	
							
						{ 
							Vector3d vecOff = segGuide.ptEnd() - segGuide.ptStart();
							vecOff = vecOff.crossProduct(vecZView).crossProduct(-vecZView); vecOff.normalize();
							Point3d ptBase = segGuide.ptStart()-.5*vecOff*dTextHeightStyle;
							Point3d ptRefBase = ptBase;
							
							LineSeg segXRange;
							{
								Point3d ptsX[] = ppRef.getGripVertexPoints();
								Line ln(ptBase, vecXTag);
								ptsX = ln.projectPoints(ln.orderPoints(ptsX, dEps));
								if (ptsX.length() > 0)
									segXRange=LineSeg (ptsX.first() , ptsX.last()-vecXTag*dTextHeightStyle);

							}							

							//ptRefBase.vis(93);
							String name = entsG.first().handle()+ "_"+i + "_Y";
							int nGripBase = -1;
							for (int v=0;v<_Grip.length();v++) 
							{ 
								if (name ==_Grip[v].name())
								{
									Grip& grip = _Grip[v];
									nGripBase = v;
									
									grip.setPtLoc(segXRange.closestPointTo(grip.ptLoc()));
									ptBase = grip.ptLoc();
									break;
								}			 
							}//next v	
							if (nGripBase<0)
							{ 
								Grip grip;
								grip.setPtLoc(ptBase);
								grip.setName(name);
								grip.setColor(4);
								grip.setVecX(vecXTag);
								grip.setVecY(vecYTag);
								grip.setShapeType(_kGSTDiamond);
								_Grip.append(grip);
							}

							//ptBase.vis(6);
							Vector3d vecMove = vecXTag * vecXTag.dotProduct(ptBase - ptRefBase);
							segGuide.transformBy(vecMove);
							pt.transformBy(vecMove);
							
							for (int p=0;p<pts.length();p++) 
							{ 
								Point3d ptc = pts[p] + vecMove;
								PLine c; c.createCircle(ptc, _ZW, .1 * dTextHeightStyle);
								dpx.draw(PlaneProfile(c), _kDrawFilled,50);
								ppProtect.joinRing(c, _kAdd);
							}//next p
							
							
							
							
						}	
							
							
							
					//endregion 	
						



					//region identify if a grip named after the tag can be found
						String name = entsG.first().handle()+ "_"+i + "_X";
						int nGrip = -1;
						for (int v=0;v<_Grip.length();v++) 
						{ 
							if (name ==_Grip[v].name())
							{
								Grip& grip = _Grip[v];
								nGrip = v;
								pt = segGuide.closestPointTo(grip.ptLoc());
								grip.setPtLoc(pt);
								break;
							}			 
						}//next v	
						if (nGrip<0)
						{ 
							Grip grip;
							grip.setPtLoc(pt);
							grip.setName(name);
							grip.setColor(4);
							grip.setShapeType(_kGSTCircle);
							_Grip.append(grip);
						}
						
						Point3d ptTag = pt + vecXTag * dTextHeightStyle;
					//endregion 


						
					// boundary
						
						PLine plBoundary;
						double dY = dp.textHeightForStyle(tag, sDimStyle, dTextHeightStyle);
						double dX =  dp.textLengthForStyle(tag, sDimStyle, dTextHeightStyle);
						plBoundary.createRectangle(LineSeg(ptTag-vecYTag * .5*dY, ptTag + vecYTag *.5*dY + vecXTag*dX), vecXTag, vecYTag);
						plBoundary.offset(-.25 * dTextHeightStyle, true);
						PlaneProfile ppTag(plBoundary);
						
					//region Run collision test
						Vector3d vecXGuide = segGuide.ptEnd() - segGuide.ptStart(); vecXGuide.normalize();
						Vector3d vecYGuide = vecXGuide.crossProduct(-vecZ);
					
						PLine plPath(vecZ);
						{ 
							double y = dTextHeightStyle * .2;
							plPath.addVertex(pt+vecYGuide*y);
							plPath.addVertex(pt+vecXGuide*.5*segGuide.length()+vecYGuide*y);
							plPath.addVertex(pt+vecXGuide*.5*segGuide.length()-vecYGuide * 2*y);
							plPath.addVertex(pt-vecXGuide*.5*segGuide.length()-vecYGuide * 2*y);
							plPath.addVertex(pt-vecXGuide*.5*segGuide.length()+vecYGuide * y);
							plPath.close();
							//ppProtect.joinRing(plPath, _kAdd);
						}
						
						PlaneProfile ppTest = ppProtect;
						int max;
						
						Point3d pt0 = ppTag.coordSys().ptOrg();
						while(ppTest.intersectWith(ppTag) && max <10)	//
						{ 
							//plPath.vis(max);
							
							int num = plPath.length() / dTextHeightStyle;
							for (int t=0;t<num;t++) 
							{ 
								ppTest = ppProtect;
								Point3d ptt = plPath.getPointAtDist(t * dTextHeightStyle);
								ppTag.transformBy(ptt - ppTag.coordSys().ptOrg());
								ppTag.vis(t);
								
								if (!ppTest.intersectWith(ppTag))
								{ 
									Vector3d vec = ppTag.coordSys().ptOrg() - pt0;
									ptTag +=vec;
									plBoundary.transformBy(vec);
									break;
								}		 
							}//next t
							plPath.offset(.5 *dY , true);//dTextHeightStyle
							ppTest = ppProtect;
							max++;
						}
					//endregion 	




					//region Draw
						if (bDrawBorder)
						{ 
							dpBackground.draw(ppTag, _kDrawFilled, bDebug?50:0);
							dpx.draw(ppTag);							
						}
						{
							PLine p = plBoundary;
							p.offset(-.2 * dTextHeightStyle, false);
							p.vis(40);
							ppProtect.joinRing(p,_kAdd);
							//ppProtect.joinRing(plBoundary, _kAdd);
						}
						dpx.draw(tag, ptTag, vecXTag, vecYTag, 1,0); 
						
						if (pts.length()>1)
						{ 
						// the default snappoint on the guide line	
							Point3d pt1 = nGrip>-1?_Grip[nGrip].ptLoc():segGuide.closestPointTo(ptTag);
							Point3d pt2 = ppTag.closestPointTo(pt1);

							dpx.draw(PLine (pt1, pt2));
							dpx.draw(segGuide);
						}							
					//endregion 


					}//next ii 
				}//next i

				//ppRect.vis(4);					
			//endregion 				


				
				nRemovals.append(nTagRemovals);
				//ppRef.vis(6);
				entsG.removeAt(0);				

			}
		}//next j
	
	//endregion 	
	
	//region Order descending and remove from arrays
		for (int a=0;a<nRemovals.length();a++) 
			for (int b=0;b<nRemovals.length()-1;b++) 
				if (nRemovals[b]<nRemovals[b+1])
					nRemovals.swap(b, b + 1);		

	// remove from lists
		for (int i=0;i<nRemovals.length();i++) 
		{ 
			int n = nRemovals[i]; 
			ents.removeAt(n);
			ppShadows.removeAt(n);
			dAreas.removeAt(n);
			cesRef.removeAt(n);
			 
		}//next i		
	//endregion 
			
	}
	else if (bHasPage && ents.length()<1) // purge if page does not return any content // added HSB-20689
	{ 
		if(!bDebug)eraseInstance();
		return;
	}
	else // reset all glyph grips
	{
		_Grip.setLength(0);
	}
//endregion 

	if (bDebug)
	{ 
		int n1 = ents.length();
		int n2 = ppShadows.length();
		int n3 = dAreas.length();
		int n4 = cesRef.length();
		if (n1!=n2 || n2!=n3 || n3!=n4)
		{ 
			reportNotice("unexpected error in array length");
		}
	}
	

		
// Loop entities with values
	PlaneProfile ppTagProtect(csW); // on floorplans the protection profile might become quite complex which causes trouble on the union of profiles. to get around this two separate protection profiles are used
	GenBeam gbNoPosNums[0];
	for (int i=0;i<ents.length();i++) 
	{ 
		
	//region Part #1
		
	//region Cast Type
		if(bDebug)reportMessage("\n"+ scriptName() + " resolving i "+i +" " + ents[i].typeDxfName() + " " +ents[i].handle() +" area: "+ ppShadows[i].area());	
		Beam b = (Beam)ents[i];
		GenBeam g = (GenBeam)ents[i];
		GenBeam gbTag = g;
		Sip sip = (Sip)ents[i];
		Sheet sheet= (Sheet)ents[i];
		TslInst t= (TslInst)ents[i];
		Opening o = (Opening)ents[i];
		OpeningSF openingSF = (OpeningSF)ents[i];
		TrussEntity truss= (TrussEntity)ents[i];
		MetalPartCollectionEnt ce= (MetalPartCollectionEnt)ents[i];
		MassGroup massgroup= (MassGroup)ents[i];
		Element element = (Element)ents[i];
		MassElement massElement= (MassElement)ents[i];
		FastenerAssemblyEnt fastener= (FastenerAssemblyEnt)ents[i];
		String sUniqueKey;
		int nPackQuantity; // the quantity of potentially packed beams
		
		int bIsStackItem = IsStackItem(t);
		int bIsPackItem = IsStackPack(t); // HSB-23435
		
		String k;
		
		PlaneProfile& ppShadow = ppShadows[i];
		//ppShadow.vis(i);
		//PLine (ppShadow.ptMid(), _PtW).vis(4);		
	// find a potential metal part in the relations map to transform the body from definition to entity
		MetalPartCollectionEnt ceRef;
		if (cesRef[i].bIsValid())
			ceRef = cesRef[i];


		Map mapAdditionalVariables; // HSB-12678
		String vars[0];
	//endregion 
		
	//region Get CoordSys and Unique Key by type
		CoordSys cs, cs2ps;
		Vector3d vecX= _XW, vecY=_YW,vecZ= _ZW;	// default CoordSys and dimension in modelspace
		if (g.bIsValid())
		{ 
			 
			cs = g.coordSys();
			
		// Beam
			if (b.bIsValid())
			{ 
				vars= b.formatObjectVariables(); 
				
			// get packed quantity	
				for (int j=0;j<entCollections.length();j++) 
				{ 
					Beam packs[] = entCollections[j].beam(); 
					if (g==packs.first())
					{
						nPackQuantity = packs.length();
						break;
					}
				}//next j
				
				k = "Surface Quality"; if (!mapAdditionalVariables.hasString(k))mapAdditionalVariables.setString(k, b.texture() );
				
				if (sAutoAttribute.find("@(Zone Alignment",0,false)>-1 && el.bIsValid())//HSB-12678
				{ 
					ElemZone zone = el.zone(b.myZoneIndex());
					Point3d pt = zone.ptOrg();
					double dZ = zone.dH();
					
					Vector3d vecZZone = zone.vecZ();
					double dZB = b.dD(vecZZone)*.5;
					
					double dA = abs(vecZZone.dotProduct(pt - b.ptCen()))-dZB;
					double dB = abs(vecZZone.dotProduct((pt+vecZZone*dZ) - b.ptCen()))-dZB;
					
					String text;
					if (dA<dEps && dB<dEps)
						text = T("|All Faces|");
					else if (dA<dEps)
						text = T("|Back|");
					else if (dB<dEps)
						text = T("|Front|");									
					else
						text = T("|No Face|");		
					k = "Zone Alignment"; if (!mapAdditionalVariables.hasString(k))mapAdditionalVariables.setString(k, text);
				}
			}
		// Sheet	
			else if (sheet.bIsValid())
			{ 
				vars= sheet.formatObjectVariables();
			}
		// Panel	
			else if (sip.bIsValid())
			{ 
				vars= sip.formatObjectVariables();
				cs = CoordSys(g.ptCen(), vecX, vecY, vecZ);
			}			
			
			if(ceRef.bIsValid())// transform by parent metalCollectionEntity
			{ 
				cs2ps=ceRef.coordSys();
				cs2ps.transformBy(ms2ps);
			}
			else
				cs2ps=ms2ps;
			cs.transformBy(cs2ps);	
			vecX=cs.vecX(); vecY=cs.vecY(); vecZ=cs.vecZ();
			
			cs.vis(2);
			
			int posnum = g.posnum();
			if (sAutoAttribute.find("@(posnum",0,false)>-1 && posnum<1)
				gbNoPosNums.append(g);			
			sUniqueKey = posnum>-1?posnum:g.handle();

			
//		// if X is perp to view take the vector of the biggest dimension	//TODO check it
//			if (vecX.isParallelTo(vecZView))
//			{
//				if (nOrientation==0)
//					vecX =g.dD(vecXView)>g.dD(vecYView)?g.vecD(vecXView):g.vecD(vecYView);
//				
//				
//			}
//
//			vecX.normalize();
			

		}
		else if (t.bIsValid())
		{ 
			String script = t.scriptName();
		// skip undefined	
			if (sScripts.length()>0 && sScripts.find(script)<0)
			{ 
				continue;
			}
			
			vars= _ThisInst.formatObjectVariables("TslInst"); 
			sUniqueKey = t.posnum();			
			
		// consider location in view
			Point3d pt = t.ptOrg();
			pt.transformBy(ms2ps);
			pt.setZ(0);			
			
		// Collect not numbered genbeams if any	
			if (bIsStackItem && sAutoAttribute.find("@(posnum",0,false)>-1)
			{ 
				GenBeam gbs[] = GetStackItemGenBeams(t);
				for (int j=0;j<gbs.length();j++) 
					if (gbs[j].posnum()<1)
						gbNoPosNums.append(gbs[j]);
	
				if (gbs.length() > 0)
				{
					gbTag = gbs[0];
					sUniqueKey = gbTag.posnum();
				}
			}
			else
				sUniqueKey += pt;			

			cs = t.coordSys();
			
		// transform by parent metalCollectionEntity
			if(ceRef.bIsValid())
				cs.transformBy(ceRef.coordSys());

			vecX=cs.vecX(); vecY=cs.vecY(); vecZ=cs.vecZ();
			if (bIsPlanView || bHasSection)
			{ 
				vecX = nOrientation==2?vecYView:vecXView;
				vecZ = vecZView;
				vecY = vecX.crossProduct(-vecZ);
			}
		}	
		else if (o.bIsValid())
		{ 
			vars= _ThisInst.formatObjectVariables("Opening"); 
			cs = o.coordSys();

		// transform by parent metalCollectionEntity
			if(ceRef.bIsValid())
				cs.transformBy(ceRef.coordSys());

			vecX=cs.vecX(); vecY=cs.vecY(); vecZ=cs.vecZ();
			
			if (bIsPlanView || bHasSection)
			{ 
				vecX = nOrientation==2?vecXView:vecX;		//vecX.vis(o.coordSys().ptOrg(), 1);
				vecZ = vecZView;				
				vecY = vecX.crossProduct(-vecZ);			//vecY.vis(o.coordSys().ptOrg(), 3);				
			}
			else if (em.bIsValid())//HSB-10157
			{ 
				Element e = o.element();
				CoordSys csSingle;
				for (int j=0;j<srefs.length();j++) 
				{ 
					if (srefs[j].number().makeUpper()==e.number().makeUpper())
					{
						csSingle=srefs[j].coordSys(); 
						break;
					}
					 
				}//next j
				CoordSys cs2em;
				cs2em.setToAlignCoordSys(e.ptOrg(), e.vecX(), e.vecY(), e.vecZ(), csSingle.ptOrg(), csSingle.vecX(), csSingle.vecY(), csSingle.vecZ() );
				
				vecX.transformBy(cs2em);
				vecY.transformBy(cs2em);
				vecZ.transformBy(cs2em);
				
			}


			// HSB-13443
			k = "OpeningDescription"; if (!mapAdditionalVariables.hasString(k))mapAdditionalVariables.setString(k,o.openingDescr() );
			k = "Description"; if (!mapAdditionalVariables.hasString(k))mapAdditionalVariables.setString(k,o.description() );
			
			k = "HeightRough"; if (!mapAdditionalVariables.hasDouble(k))mapAdditionalVariables.setDouble(k,o.heightRough() );
			k = "WidthRough"; if (!mapAdditionalVariables.hasDouble(k))mapAdditionalVariables.setDouble(k,o.widthRough() );
			
			
		
			if (openingSF.bIsValid())
			{ 
				k = "StyleNameSF"; if (!mapAdditionalVariables.hasString(k))mapAdditionalVariables.setString(k,openingSF.styleNameSF() );
				k = "DescriptionPacking"; if (!mapAdditionalVariables.hasString(k))mapAdditionalVariables.setString(k,openingSF.descrPacking() );
				k = "DescriptionPlate"; if (!mapAdditionalVariables.hasString(k))mapAdditionalVariables.setString(k,openingSF.descrPlate() );
				k = "DescriptionSF"; if (!mapAdditionalVariables.hasString(k))mapAdditionalVariables.setString(k,openingSF.descrSF() );

				k = "GapSide"; if (!mapAdditionalVariables.hasDouble(k))mapAdditionalVariables.setDouble(k,openingSF.dGapSide() );
				k = "GapTop"; if (!mapAdditionalVariables.hasDouble(k))mapAdditionalVariables.setDouble(k,openingSF.dGapSide() );
				k = "GapBottom"; if (!mapAdditionalVariables.hasDouble(k))mapAdditionalVariables.setDouble(k,openingSF.dGapBottom() );
			}

			
			
//			dX = o.width(); dY = o.height(); dZ = el.dBeamWidth();
		}
		else if (truss.bIsValid())
		{ 
			vars= _ThisInst.formatObjectVariables("Truss"); 
			sUniqueKey = truss.definition();
			cs = truss.coordSys();
			vecX=cs.vecX(); vecY=cs.vecY(); vecZ=cs.vecZ();
			if (bIsPlanView || bHasSection)
			{ 
				vecX = nOrientation==2?vecYView:vecXView;
				vecZ = vecZView;
				vecY = vecX.crossProduct(-vecZ);
			}
			
		}
		else if (ce.bIsValid())
		{ 
			if (!bIsTypeMetalpart)
			{
				continue;
			}
			vars= _ThisInst.formatObjectVariables("Entity"); 
			sUniqueKey = ce.definition();
			cs = ce.coordSys();
			vecX=cs.vecX(); vecY=cs.vecY(); vecZ=cs.vecZ();
			if (bIsPlanView || bHasSection)
			{ 
				vecX = nOrientation==2?vecYView:vecXView;
				vecZ = vecZView;
				vecY = vecX.crossProduct(-vecZ);
			}
		}
		else if (massgroup.bIsValid())
		{ 
			sUniqueKey = massgroup.posnum();
			cs = massgroup.coordSys();
			vecX=cs.vecX(); vecY=cs.vecY(); vecZ=cs.vecZ();
			if (bIsPlanView || bHasSection)
			{ 
				vecX = nOrientation==2?vecYView:vecXView;
				vecZ = vecZView;
				vecY = vecX.crossProduct(-vecZ);
			}
		}
		else if (element.bIsValid())
		{ 
			vars= _ThisInst.formatObjectVariables("Element"); 
			sUniqueKey = element.handle();
			cs = element.coordSys();
			vecX=cs.vecX(); vecY=cs.vecY(); vecZ=cs.vecZ();
			if ((bIsPlanView && ! bByEntity) || bHasSection) // HSB-22175
			{ 
				vecX = nOrientation==2?vecYView:vecXView;
				vecZ = vecZView;
				vecY = vecX.crossProduct(-vecZ);
			}
		}		
		else if (massElement.bIsValid())
		{ 
			sUniqueKey = massElement.handle();
			cs = massElement.coordSys();
			vecX=cs.vecX(); vecY=cs.vecY(); vecZ=cs.vecZ();
			if (bIsPlanView || bHasSection)
			{ 
				vecX = nOrientation==2?vecYView:vecXView;
				vecZ = vecZView;
				vecY = vecX.crossProduct(-vecZ);
			}
		}
		else if (fastener.bIsValid())
		{ 
			sUniqueKey = fastener.handle();
			cs = fastener.coordSys();
			vecX=cs.vecX(); vecY=cs.vecY(); vecZ=cs.vecZ();
		
			Map data = GetFastenerDataMap(fastener);
			mapAdditionalVariables.copyMembersFrom(data);			
		}
		vecX.normalize(); vecY.normalize();vecZ.normalize();
		//vecX.vis(ppShadow.ptMid(), 1);			vecY.vis(ppShadow.ptMid(), 3);			vecZ.vis(ppShadow.ptMid(), 150);
	//endregion 

	//region Set Define Formatting	
		for (int i=0;i<mapAdditionalVariables.length();i++) 
		{ 
			String key = mapAdditionalVariables.keyAt(i);
			int nx = mapAdditionalVariables.hasInt(key) ? 1 : (mapAdditionalVariables.hasDouble(key) ? 2 : 0);
			if (nx ==0 && !mapAdditional.hasString(key)) 
				mapAdditional.setString(key, mapAdditionalVariables.getString(key));
			else if (nx ==1 && !mapAdditional.hasDouble(key)) 
				mapAdditional.setDouble(key, mapAdditionalVariables.getDouble(key));
			else if (nx ==2 && !mapAdditional.hasInt(key)) 
				mapAdditional.setInt(key, mapAdditionalVariables.getInt(key));				
		}//next i

		for (int i=0;i<vars.length();i++) 
			if (!mapAdditional.hasString(vars[i]))
				mapAdditional.appendString(vars[i], ""); 

	//endregion 

	//region Get Display Text Content
		String sValues[0];
		{
			String s=  ents[i].formatObject(sAutoAttribute,mapAdditionalVariables);//.tokenize("\P");
			
			if (bIsStackItem && sTags.length()>i)
				s = sTags[i];
			
			
		// append potential pack quantity
			if (nPackQuantity>0)
				s = nPackQuantity + sBeamPackDelimiter + s;

			int left= s.find("\\P",0);
			while(left>-1)
			{
				sValues.append(s.left(left));
				s = s.right(s.length() - 2-left);
				left= s.find("\\P",0);
			}
			sValues.append(s);
		}		
	//endregion

	//region Sip & tsl specifics	
		Vector3d vecGrain;
		String sqTop,sqBottom; 
		SipComponent components[0];
		HardWrComp hwcs[0];
		//String sHardwareFormats[0]; TODO
	// sip specifics		
		if (sip.bIsValid())
		{
			vecGrain = sip.woodGrainDirection();
			vecGrain.transformBy(ms2ps);
		
			SipStyle style(sip.style());
			sqTop = sip.surfaceQualityOverrideTop();
			if (sqTop.length() < 1)sqTop = style.surfaceQualityTop();
			if (sqTop.length() < 1)sqTop = "?";
			int nQualityTop = SurfaceQualityStyle(sqTop).quality();
			
			sqBottom = sip.surfaceQualityOverrideBottom();
			if (sqBottom.length() < 1)sqBottom = style.surfaceQualityBottom();
			if (sqBottom.length() < 1)sqBottom = "?";
			int nQualityBottom = SurfaceQualityStyle(sqBottom).quality();
			
			components = style.sipComponents();
			
			if (nOrientation ==0)// byEntity
				vecX = vecGrain;
			
		}
	// tsl specifics	
		else if (t.bIsValid())
		{ 
			hwcs = t.hardWrComps();
		}			
	//endregion 

	//region Distinguish orientation style
	// byEntity
		if (nOrientation==0 && !vecX.isPerpendicularTo(_ZW))
		{
			vecX = vecX.crossProduct(-_ZW).crossProduct(_ZW);
			vecX.normalize();
		}		
	// horizontal	
		else if (nOrientation==1)
			vecX=_XW; 	
	// vertical
		else if (nOrientation==2)
			vecX=_YW; 
		else if (!vecX.isPerpendicularTo(_ZW))
			vecX = _XW;


	//	ensure readability
		if (vecX.dotProduct(_XW)<-dEps || vecX.isCodirectionalTo(-_YW))
		{ 
			vecX *= -1;
			//vecY *= -1;
		}
		vecY = vecX.crossProduct(-_ZW);			
	//endregion 

	//region Color
		if (nColor==-2)nc=ents[i].color();
		dp.color(nc);

		Display dpBackgroundX(-1), dpx(nc);
		dpx.dimStyle(sDimStyle);
		dpBackgroundX.trueColor(rgb(255, 255, 254), nTransparency);
		if (dTextHeight>0)
		{
			dTextHeightStyle=dTextHeight;
			dpx.textHeight(dTextHeight);
		}		
	//endregion 

	//Part #1 //endregion 	
		

	// get extents of profile
		//if (bDebug){ Display dp(4); dp.draw(ppShadow, _kDrawFilled,80);}
		if (bHasSection)
		{
			if (!ppShadow.coordSys().vecZ().isParallelTo(_ZW))
			{
				reportMessage("\nwrong alignment profile i " + i);
				//PLine (ppShadow.ptMid(), ppShadow.ptMid()+ppShadow.coordSys().vecZ()*U(200)).vis(1);
			}
			else
				ppShadow.project(Plane(_Pt0, _ZW), _ZW, dEps);
		}
		else
			ppShadow.project(Plane(_Pt0, _ZW), _ZW, dEps);		
//		if (bDebug)
//		{
//			{Display dpx(i); dpx.draw(ppShadow, _kDrawFilled,60);}
//			
//		}
		
		
		
		
		LineSeg seg = ppShadow.extentInDir(vecX);
		double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
		double dY = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));	
		//seg.vis(1); vecX.vis(seg.ptMid(), 1);

	//region Resolve unknown and draw
		String sLines[0];
		//reportMessage("\n"+ scriptName() + " values i "+i +" " + sValues);
		for (int v= 0; v < sValues.length(); v++)
		{
			String& value = sValues[v];
			int left = value.find("@(", 0);
			
		// get formatVariables and prefixes
			if (left>-1)
			{ 
				//String sVariables[] = sLines[i].tokenize("@(*)");
				// tokenize does not work for strings like '(@(KEY))'
				String sTokens[0];
				while (value.length() > 0)
				{
					left = value.find("@(", 0);
					int right = value.find(")", left);
					
				// any prefix
					if (left>0 && right>left)
					{ 
						sTokens.append(value.left(left));
						value = value.right(value.length() - left);
						left = value.find("@(", 0);
						right = value.find(")", left);
					}
					
					
					
				// key found at first location	
					if (left == 0 && right > 0)
					{
						String sVariable = value.left(right + 1).makeUpper();

						if (sVariable=="@(CALCULATE WEIGHT)")
						{
							Map mapIO,mapEntities;
							mapEntities.appendEntity("Entity", ents[i]);
							mapIO.setMap("Entity[]",mapEntities);
							TslInst().callMapIO("hsbCenterOfGravity", mapIO);
							double dWeight = mapIO.getDouble("Weight");// / dConversionFactor;
							
							String sTxt;
							if (dWeight<10)
								sTxt.formatUnit(dWeight, 2,1);			
							else
								sTxt.formatUnit(dWeight, 2,0);
							sTxt = sTxt + " kg";						
							sTokens.append(sTxt);
						}
						else if (sVariable=="@(QUANTITY)")
						{
							int n=-1;
							if (gbTag.bIsValid())
								n= sUniqueKeys.find(String(gbTag.posnum()));
							else if (t.bIsValid())
							{
								String key = t.posnum();
							// consider location in view
								Point3d pt = t.ptOrg();
								pt.transformBy(ms2ps);
								pt.setZ(0);
								key += pt;
								n= sUniqueKeys.find(key);
							}
							if (n>-1)
							{ 
								int nQuantity = nQuantities[n];
							// as tag show only quantity > 1, as header (static) show any value	// beams are packed if possible
								if ((bHasStaticLoc && nQuantity>0) || (!bHasStaticLoc && nQuantity>1 && (!b.bIsValid() || bGroupByPainter) ))
								{
									sTokens.append(nQuantity);	
								}
							}	
						}
								
					// tslInstance unsupported by formatObject
						else if (t.bIsValid())
						{ 
							String s=  t.formatObject(sAutoAttribute);

							if (sVariable=="@(POSNUM)") sTokens.append(t.posnum());
							else if (sVariable=="@(MODELDESCRIPTION)") sTokens.append(t.modelDescription());
							else if (sVariable=="@(MATERIALDESCRIPTION)") sTokens.append(t.materialDescription());

						}						
						//region Sip unsupported by formatObject
						else if (sip.bIsValid())
						{ 
							if (sVariable=="@(GRAINDIRECTIONTEXT)")
								sTokens.append(vecGrain.isParallelTo(_XW) ? T("|Lengthwise|") : T("|Crosswise|"));
							else if (sVariable=="@(GRAINDIRECTIONTEXTSHORT")
								sTokens.append(vecGrain.isParallelTo(_XW) ? T("|Grain LW|") : T("|Grain CW|"));
							else if (sVariable=="@(surfaceQualityBottom)".makeUpper())
								sTokens.append(sqBottom);	
							else if (sVariable=="@(surfaceQualityTop)".makeUpper())
								sTokens.append(sqTop);	
							else if (sVariable=="@(SURFACEQUALITY)")
							{
								String sQualities[] ={sqBottom, sqTop};
								if (sip.vecZ().isCodirectionalTo(vecZView))sQualities.swap(0, 1);
								String sQuality = sQualities[0] + " (" + sQualities[1] + ")";
								sTokens.append(sQuality);	
							}
							else if (sVariable=="@(Graindirection)".makeUpper())
							{
								
								sTokens.append("  ");//  2 blanks
							}
							else if (sVariable=="@(SipComponent.Name)".makeUpper())
							{
								SipComponent component = SipStyle(sip.style()).sipComponentAt(0);
								sTokens.append(component.name());								
							}
							else if (sVariable=="@(SipComponent.Material)".makeUpper())
							{
								SipComponent component = SipStyle(sip.style()).sipComponentAt(0);
								sTokens.append(component.material());								
							}																
						}
					// metalpart collection entity
						else if (ce.bIsValid())
						{ 
							if (sVariable=="@(DEFINITION)") sTokens.append(ce.definition());
							if (sVariable=="@(COLORINDEX)") 
								sTokens.append(ce.color());
						}
						
					// element
						else if (element.bIsValid())
						{ 
							if (sVariable=="@(CODE)") sTokens.append(element.code());
							else if (sVariable=="@(INFOMATION)") sTokens.append(element.information());
							else if (sVariable=="@(SUBTYPE)") sTokens.append(element.subType());
						}
						
					// element
						else if (massElement.bIsValid())
						{ 
							if (sVariable=="@(HEIGHT)") sTokens.append(massElement.height());
							else if (sVariable=="@(DEPTH)") sTokens.append(massElement.depth());
							else if (sVariable=="@(WIDTH)") sTokens.append(massElement.width());
							else if (sVariable=="@(RADIUS)") sTokens.append(massElement.radius());
							else if (sVariable=="@(RISE)") sTokens.append(massElement.rise());
							else if (sVariable=="@(SHAPETYPE)") sTokens.append(MassElement().shapeType2String(massElement.shapeType()));
							
						}						
						
						
						//End Sip unsupported by formatObject//endregion 						
						value = value.right(value.length() - right - 1);
					}
				// any text inbetween two variables	
					else if (left > 0 && right > 0)
					{
						sTokens.append(value.left(left));
						value = value.right(value.length() - left);
					}
				// any postfix text
					else
					{
						sTokens.append(value);
						value = "";
					}
				}

				for (int j=0;j<sTokens.length();j++) 
					value+= sTokens[j]; 
			}
			sLines.append(value);
		}		
					
	//endregion 
	
	//region Location
	// default location and posnum
		int nPosNum=-1;
		Point3d ptLoc;
		int bGetLocation = true;

		if (g.bIsValid())
		{ 
			if (bHasSection)
			{ 
				Body bd = g.envelopeBody();
				Body bdTest = bd;
				if (ceRef.bIsValid())		
				{
					bdTest.transformBy(ceRef.coordSys());	
					bdTest.intersectWith(bdClip);	
				}
				
				if (bdTest.isNull())
				{ 
					if (bDebug)bd.vis(1);
					continue;
				}
				else
				{ 
					if (bDebug)bd.vis(3);
				}
				//bd.intersectWith(bdClip);		
				ptLoc = bd.ptCen();
			}
			else if (bHasPage)
			{ 
				Body bd = g.envelopeBody();
				if (bDebug)bd.vis(3);
				ptLoc = bd.ptCen();
			}			
			else
			{
				ptLoc = g.ptCenSolid();
			}
			
				
			ptLoc.transformBy(cs2ps);
			nPosNum = g.posnum();
		}
		else if (o.bIsValid())
		{ 
			ptLoc.setToAverage(o.plShape().vertexPoints(true));	
			if (em.bIsValid())//HSB-10157
			{ 
				Element e = o.element();
				CoordSys csSingle;
				for (int j=0;j<srefs.length();j++) 
				{ 
					if (srefs[j].number().makeUpper()==e.number().makeUpper())
					{
						csSingle=srefs[j].coordSys(); 
						break;
					}	 
				}//next j
				CoordSys cs2em;
				cs2em.setToAlignCoordSys(e.ptOrg(), e.vecX(), e.vecY(), e.vecZ(), csSingle.ptOrg(), csSingle.vecX(), csSingle.vecY(), csSingle.vecZ() );
				ptLoc.transformBy(cs2em);
			}
			ptLoc.transformBy(ms2ps);
			
		}
		else if (t.bIsValid())
		{
			ptLoc = t.ptOrg();
			if (ceRef.bIsValid())		
				ptLoc.transformBy(ceRef.coordSys());
			ptLoc.transformBy(ms2ps);
			nPosNum = t.posnum();
			
		// Collect posnum of stacked item instead
			if (bIsStackItem)
			{ 
				GenBeam gbs[] = GetStackItemGenBeams(t);
				if (gbs.length()>0)
					nPosNum = gbs.first().posnum();
			}
		}
		else if (truss.bIsValid())
		{
			ptLoc = seg.ptMid();
			//ptLoc.transformBy(ms2ps);
		}		
		else if (ce.bIsValid())
		{
			ptLoc = seg.ptMid();ptLoc.vis(44);
		}
		else if (massgroup.bIsValid())
		{
			ptLoc = seg.ptMid();
		}
		else if (element.bIsValid())
		{
			ptLoc = seg.ptMid();	ptLoc.vis(6);
		}
		else if (massElement.bIsValid())
		{
			ptLoc = seg.ptMid();
		}	
		else if (fastener.bIsValid())
		{
			//seg.vis(6);
			ptLoc = seg.ptMid();
		}			
		else
		{
			continue;
		}
	
		if (bHasSection)
		{
			ptLoc.setZ(ptCenVp.Z());
		}
		else if (bHasPage)
			ptLoc.setZ(0);
		
		
		//ptLoc.vis(2);
		
		
	// multiline text	
		int nNumLine = sLines.length();
	
	// rebuild string to be displayed
		String sText;
		int nNumLineGrain = -1; // the index of the line where a potential grain pline will be drawn
		double dGrainXOffset;
		for (int j=0;j<nNumLine;j++) 
		{
			String sLine = sLines[j];
			int x = sLine.find("  ",0);
			if (x>-1 && sip.bIsValid()) // HSB-8649
			{
				nNumLineGrain = j;
				String left = sLine.left(x);
				String right= sLine.right(sLine.length()-x-3);
				dGrainXOffset = dp.textLengthForStyle(left, sDimStyle, dTextHeightStyle);
				if (vecGrain.isParallelTo(_ZW) || x>0)
					dGrainXOffset += .5 * dTextHeightStyle;					
				else if(!vecGrain.isParallelTo(_XW))
				{	
					sLine = left + right;	
				}
				
				if (left.length()<1 && right.length()>0)
					dGrainXOffset -= .25 * dTextHeightStyle;	

			}
			
			sText+= (j>0?"\\P":"")+sLine; 
		}
				
		double dXMax = dp.textLengthForStyle(sText, sDimStyle, dTextHeightStyle);
		double dYMax = dp.textHeightForStyle(sText, sDimStyle, dTextHeightStyle);
		double dTextHeightDisplay = dYMax;
		dXMax += .3*dTextHeightStyle;
		dYMax += .4*dTextHeightStyle;	

		double dXOffset = dTextHeightStyle*nLeaderFactorX;
		double dYOffset = dTextHeightStyle*nLeaderFactorY;
		Vector3d vecLeaderOffset;
		
		
	// add the leader offset to the location
		int bHasEntVector = mapParent.hasVector3d(ents[i].handle());
		int bHasGripLocation=bEditInPlace && bHasEntVector &&  _PtG.length()>i;//HSB-20689
		if (!bHasGripLocation && bDrawLeader && !bHasStaticLoc)
		{ 	
		// align default leader offset direction in depedency of element center		
			Vector3d vecYL = vecY;
			if (!vecX.isParallelTo(_XW) && _XW.dotProduct(ptMidEl-ptLoc)<0)
				vecYL *= -1;				
			else if (vecX.isParallelTo(_XW) && _YW.dotProduct(ptMidEl-ptLoc)>0)
				vecYL *= -1;	
			//ptLoc.vis(4);	
			vecLeaderOffset= vecX * (dXOffset+.5*dXMax)+vecYL * dYOffset;	

		}

	// no content
		if (sText.length()<1)
		{ 
			continue;// do nothing if no content
		}
	// static location		
		if (bHasStaticLoc)
		{
			ptLoc = ptStaticLoc;
			//ptLoc.vis(3);
			ptStaticLoc -= vecY * dYMax;
			bGetLocation = false;
		}
	// edit in place, grip not found	
		else if (bEditInPlace && (!bHasEntVector || _PtG.length()<i+1))
		{ 
			if (bHasPage)
				ptLoc += vecLeaderOffset;
			_PtG.append(ptLoc);
			bSetParentMap = true;
			
			if (bHasPage)
				mapParent.setVector3d(ents[i].handle(), ptLoc-page.coordSys().ptOrg());
			else
				mapParent.setVector3d(ents[i].handle(), ptLoc-_PtW);			
			
		}
		else if (bHasGripLocation)
		{ 
			bGetLocation = false;
			if (bHasPage)
				ptLoc = page.coordSys().ptOrg()+mapParent.getVector3d(ents[i].handle());
			else
				ptLoc = mapParent.getVector3d(ents[i].handle());
			
//			if (_PtG.length()<i+1)
//			{ 
//				_PtG.append(ptLoc);
//				
//			}
//			else 
			if (_kNameLastChangedProp=="_PtG"+i)
			{ 
				ptLoc = _PtG[i];
				if (bHasPage)
					mapParent.setVector3d(ents[i].handle(), ptLoc-page.coordSys().ptOrg());
				else
					mapParent.setVector3d(ents[i].handle(), ptLoc-_PtW);					
				bSetParentMap = true; // write new location to map
			}
			else
			{
				_PtG[i] = ptLoc;
			}
		}			
	// ignore invisible items
		else if (!bHasPage && !bHasSection && ppVp.pointInProfile(ptLoc) == _kPointOutsideProfile)
		{
			if (bDebug)reportMessage("\location outside viewport!");
			continue;			
		}
	//End Location//endregion 		

	//region Leader
	// add the leader offset to the location	
		if (!vecLeaderOffset.bIsZeroLength())
		{ 	
			ptLoc.transformBy(vecLeaderOffset);		
			if (_Viewport.length()>0)
				ptLoc.setZ(0);			
			ptLoc.vis(4);	
		}
	

	// get axis where to snap the leader to
		Vector3d _vecX = vecX;
		if (b.bIsValid())
		{ 
			_vecX = b.vecX();
			_vecX.transformBy(ms2ps);
			_vecX.normalize();
			if (!_vecX.isPerpendicularTo(_ZW))
				_vecX = vecX;
		}
		else if (bIsPlanView && element.bIsValid())//HSB-22175
		{
			_vecX =element.vecX();
			_vecX.transformBy(ms2ps);
			_vecX.normalize();
		}
			
			
		LineSeg segs[] = ppShadow.splitSegments(LineSeg(seg.ptMid()-_vecX*U(10e3),seg.ptMid()+_vecX*U(10e3)), true);
		Point3d pts[0];
		for (int j=0;j<segs.length();j++) 
		{ 
			pts.append(segs[j].ptStart());
			pts.append(segs[j].ptEnd());
		}//next j
		pts = Line(seg.ptMid(), vecX).orderPoints(pts);
		
		// get axis from shadow
		LineSeg segAxis;
		if (bIsPackItem || bIsStackItem)
		{ 
			Vector3d vecXP = t.coordSys().vecX();
			vecXP.transformBy(ms2ps);
			Point3d ptm = ppShadow.ptMid();
			LineSeg segs[] = ppShadow.splitSegments(LineSeg(ptm - vecXP * U(10e4), ptm + vecXP * U(10e4)), true);
			if (segs.length()>0)
				segAxis = segs[0];	
		}
		if (pts.length()>1 && segAxis.length()<dEps)
			segAxis = LineSeg(pts.first(), pts.last());
		else if (segAxis.length()<dEps)
			segAxis = ppShadow.extentInDir(vecX);	
		//if (bDebug)segAxis.vis(6);
		//PLine (segAxis.ptMid(), _PtW).vis(3);
		
		
		
		
		
	//endregion 

	//region specify bounding softened box
		PLine plBoundary(_ZW);
		double dRadius = dXMax>dYMax?dXMax*.5:dYMax*.5;
		{ 
			double dYB = dp.textHeightForStyle(sText, sDimStyle, dTextHeightStyle);
			double dXB = dp.textLengthForStyle(sText, sDimStyle, dTextHeightStyle);
			Vector3d vec = .5 * (vecX * dXB + vecY * dYB);
			plBoundary.createRectangle(LineSeg(ptLoc-vec, ptLoc + vec), vecX, vecY);			
		}

		plBoundary.offset(-.25 * dTextHeightStyle, true);
		//if (bDebug)plBoundary.vis(5);

	//End specify bounding box/circle pline//endregion  

	//if (bDebug){ Display dp(1); dp.draw(ppProtect, _kDrawFilled,80);}


	// get/store multiGuideLineLocation
		int bHasMultiGuideLine = sUniqueKey.length()>0 && mapMultiGuide.hasPLine(sUniqueKey) && !b.bIsValid();

	//region location check
		if (bGetLocation)
		{ 
			PLine plBase = plBoundary;	//plBase.vis(4);
			Point3d ptBase = ptLoc;
			PlaneProfile pp(csW);
			pp.joinRing(plBoundary,_kAdd);
			pp.vis(2);
			
			int nCnt=1;	
				
			//if (bDebug){ Display dp(nCnt); dp.draw(pp,_kDrawFilled,60);}
			//if (bDebug){ Display dp(1); dp.draw(ppProtect, _kDrawFilled,20);}
		// check intersection
			PlaneProfile ppt = pp;
			int bIntersect = ppt.intersectWith(ppProtect);
			ppt = pp;
			int bIntersectTag = ppt.intersectWith(ppTagProtect);
			if (!bIntersect && !bIntersectTag)
			{ 
				PLine p = plBoundary;
				p.offset(-.2 * dTextHeightStyle, false);
				//if (bDebug){ Display dp(3); dp.draw(PlaneProfile(p),_kDrawFilled,60);}
				
//				pp=PlaneProfile (csW);
//				pp.joinRing(plBoundary,_kAdd);
//
				//AddProtectionProfile(ppProtect, pp);
//				
				ppTagProtect.joinRing(p,_kAdd);
				//if (bDebug){ Display dp(6); dp.draw(ppTagProtect, _kDrawFilled,20);}
				
			}

		//region try to resolve intersection
			PlaneProfile pps = ppShadows[i];
			if (nPlacement==1)
				pps.unionWith(ppParent);

		// first attempt is to align along axis
			if (bIntersect || bIntersectTag)
			{ 
				Vector3d vecXAxis = segAxis.ptEnd() - segAxis.ptStart(); vecXAxis.normalize();//HSB-15902
				double step = dRadius *.5;
				double range = segAxis.length() * .5;
				int num = range / step;
				num = num < 2 ? 2 : num;	//XX
				Point3d pt;
				for (int ii=0;ii<num;ii++) 
				{ 
					pt = ptLoc + vecXAxis*(ii+1)*step;
					//pt.vis(ii);
					
					pp= PlaneProfile(plBoundary);
					pp.transformBy(pt - ptLoc);
					ppt = pp;//pp.vis(ii);
					bIntersect = ppt.intersectWith(ppProtect);
					ppt = pp;
					bIntersectTag = ppt.intersectWith(ppTagProtect);				
					if (!bIntersect && !bIntersectTag)//!pp.intersectWith(ppProtect))
					{ 
						plBoundary.transformBy(pt - ptLoc);
						ptLoc = pt;
						//bIntersect = false;
						break;
					}
					pt = ptLoc - vecXAxis*(ii+1)*step;
					//pt.vis(4);
					
					pp= PlaneProfile(plBoundary);
					pp.transformBy(pt - ptLoc);				
					ppt = pp;
					bIntersect = ppt.intersectWith(ppProtect);
					ppt = pp;
					bIntersectTag = ppt.intersectWith(ppTagProtect);					
					if (!bIntersect && !bIntersectTag)//!pp.intersectWith(ppProtect))				
					//if (!pp.intersectWith(ppProtect))
					{ 
						plBoundary.transformBy(pt - ptLoc);
						ptLoc = pt;
						//bIntersect = false;
						break;
					}		
				}//next ii	
				
				if (!bIntersect && !bIntersectTag)
				{
					PLine p = plBoundary;
					p.offset(-.2 * dTextHeightStyle, false);
					//p.vis(6);
					ppTagProtect.joinRing(p,_kAdd);		
				}
				
				
			}
		// second attempt blow up and go in circles
			int bOk;
			
			
			while((bIntersect || bIntersectTag) && nCnt<200 && dYMax>0 && !bHasMultiGuideLine)
			{ 
				double dShrink = .5*dYMax;// * dScale;
			// grow the first attempt such that it is closed to the preferred area if specified
				if (bHasPreferred && nCnt==1)
				{ 
					Point3d ptA = ppPreferred.closestPointTo(pps.extentInDir(vecX).ptMid());
					Point3d ptB = pps.closestPointTo(ptA);
					dShrink += Vector3d(ptA - ptB).length()*dScale;
				}
				pps.shrink(-dShrink);
				//pps.vis(3);
				LineSeg seg = pps.extentInDir(vecX);
				double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
				double dY = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
				
				CoordSys csx, csy;
				csx.setToMirroring(Plane(seg.ptMid(), vecX));
				csy.setToMirroring(Plane(seg.ptMid(), vecY));
							
			// location will be searched along pline divided by max height interdistance				
				PLine pl(_ZW);	

			// beams will be tested by up to 4 plines starting from the center to achieve a posnum near the center
				int nNumSubTest;
				Point3d ptA, ptB;
				if (ents[i].bIsKindOf(Beam()) ||ents[i].bIsKindOf(Opening()))
				{ 
					nNumSubTest = 4;
					ptA = seg.ptMid() + .5 * (vecY * .5 * dY);
					pl.addVertex(ptA);
					pl.addVertex(seg.ptMid() + .5*(vecY*.5*dY+vecX*dX));
					ptB = seg.ptMid() + .5 * (vecX * dX);
					pl.addVertex(ptB);	
					//pl.vis(20);
				}
			// all others go for outer contour	
				else
				{ 
					PLine plRings[] = pps.allRings(true, false);
					if (plRings.length()>0)
					{
						nNumSubTest = 1;
						pl = plRings[0];
						ptA = pl.ptStart();
						ptB = pl.getPointAtDist(pl.length() / 2);
						//ptA.vis(5); ptB.vis(5);
					}
				}

			// loop subtests
				for (int j=0;j<nNumSubTest;j++) 
				{ 
					//pl.vis(j+1);
					// start testing at a location near to the base point // HSB-15950
					double d;
					double dStartOffset = pl.getDistAtPoint(pl.closestPointTo(ptBase));
					double dMaxL = pl.length();
					while (d<dMaxL)
					{ 
						double dist = d + dStartOffset;
						if (dist > dMaxL)dist -= dMaxL;
						Point3d pt = pl.getPointAtDist(dist);	
						//pt = pps.closestPointTo(pt);
						//pt.vis(nCnt);
					
					// first test: point within protected area?
						if (ppProtect.pointInProfile(pt)!=_kPointOutsideProfile)
						{ 
							d += dTextHeightStyle;
							continue;
						}
					// first test: point within protected area?
						else if (ppTagProtect.pointInProfile(pt)!=_kPointOutsideProfile)
						{ 
							d += dTextHeightStyle;
							continue;
						}
						
					// second test outside preferred
						else if (bHasPreferred && ppPreferred.pointInProfile(pt)!=_kPointInProfile)
						{
							d += dTextHeightStyle;
							continue;
						}
					// third test intersection after transformation
						plBoundary.transformBy(pt-ptLoc);				
						pp=PlaneProfile(plBoundary);
						
						ppt = pp;			
						bIntersect=ppt.intersectWith(ppProtect);
						ppt = pp;			
						bIntersectTag=ppt.intersectWith(ppTagProtect);
						//bIntersect = pp.area()>pow(dEps,2);
						
						
						
						
						if (!bIntersect && !bIntersectTag)
						{ 
							ptLoc.transformBy(pt-ptLoc);
							
							PLine p = plBoundary;
							p.offset(-.2 * dTextHeightStyle, false);
							//if (bDebug){ Display dp(61); dp.draw(PlaneProfile(p),_kDrawFilled,60);}
							ppTagProtect.joinRing(p,_kAdd);
							bOk = true;
							break;
						}
						else
						{
							plBoundary.transformBy(ptLoc-pt);
						}
						d += dTextHeightStyle;
					} 
					if (bOk || nNumSubTest==1)break;
					if (j==0 || j==2)pl.transformBy(csx);
					if (j==1 || j==3)pl.transformBy(csy);
				}//next j
				
				if (bOk)break;
				//pps.vis(nCnt);seg.vis(1);
				nCnt++;
			}

		
		//End try to resolve intersection	mode A//endregion 
		
		
			if(!bHasMultiGuideLine && sUniqueKey.length()>0 && sUniqueKeys.find(sUniqueKey)>-1)
			{ 
				mapMultiGuide.setPLine(sUniqueKey, plBoundary);	
				Vector3d vecXL = vecX.dotProduct(ptLoc+vecX*.5*dXMax-segAxis.ptMid())<0?vecX:- vecX;
				mapMultiGuide.setPoint3d("pt_"+sUniqueKey, plBoundary.closestPointTo(ptLoc + vecXL * .5 * dXMax));	
			}
			else if (bHasMultiGuideLine)
				bDrawLeader = true;	
		}//endregion
	// static location
		else if (bHasStaticLoc)
		{	
			plBoundary.transformBy(.5 * (nTextAlignmentX*vecX * dXMax-vecY*(dYMax-.6*dTextHeightStyle)));
			plBoundary.vis(6);
		}

	// leader, do not draw if on axis
//  || abs(vecY.dotProduct(ptLoc-segAxis.closestPointTo(ptLoc)))>.5*dYMax	
		if (bDrawLeader)
		{ 
			PLine _plBoundary = bHasMultiGuideLine?mapMultiGuide.getPLine(sUniqueKey):plBoundary;
			Vector3d vecXL = vecX.dotProduct(ptLoc+vecX*.5*dXMax-segAxis.ptMid())<0?vecX:- vecX;
			Point3d pt1 = _plBoundary.closestPointTo(ptLoc + vecXL * (bHasStaticLoc?1:.5) * dXMax);
	
			//_plBoundary.vis(5);
			//vecXL.vis(pt1,6);
			if (bHasMultiGuideLine && mapMultiGuide.hasPoint3d("pt_"+sUniqueKey))
			{ 
				Point3d pt1B = mapMultiGuide.getPoint3d("pt_"+sUniqueKey);
				double dist = Vector3d(pt1B - pt1).length();
				//pt1B.vis(i);pt1.vis(i);
				if (dist<3*dTextHeightStyle)
					pt1 = pt1B;
			}
			//segAxis.vis(6);
			Point3d pt2 = pt1 + vecXL *.5 * dTextHeightStyle;
			Point3d pt3 = segAxis.closestPointTo(pt2 + vecXL*(dXOffset-.5*dTextHeightStyle));
			if (bHasPage)
				pt3 += _ZW * _ZW.dotProduct(pt1 - pt3);
			
			if (bGroupByPainter)
				pt3 = ppShadows[i].closestPointTo(pt2);
			else if(nPlacement ==1)//HSB-22175
				pt3 = segAxis.closestPointTo(pt2);
			
			//if (metalParent.bIsValid())	
//			pt1.vis(6);
//			pt2.vis(6);
//			pt3.vis(6);
//			segAxis.vis(5);
			//dpLeader.draw(segAxis);
			
		// do not draw leader if reference point is within plBoundary
			if (PlaneProfile(_plBoundary).pointInProfile(pt3)!=_kPointInProfile)
			{ 
				//_plBoundary.vis(40);
				if (vecXL.dotProduct(pt3-pt1)<0)
				{ 
					pt1 = _plBoundary.closestPointTo(pt3);
					pt2 = pt1;
					
				}
	
			// draw circle 
				PLine plCirc(_ZW);
				plCirc.createCircle(pt3, _ZW, dTextHeightStyle * .1);
				dpLeader.draw(PlaneProfile(plCirc), _kDrawFilled, 70);
				
				if (Vector3d(pt3-pt2).length()>.5*dTextHeightStyle)
				{
					PLine pl(pt1, pt2, pt3);
					dpLeader.lineType(sLeaderLineType, 1/dScale);
					dpLeader.draw(pl);	
					
					// HSB-22038
					pl.offset(-U(1) / dScale, true);
					PLine pl2 = pl;
					pl2.offset(U(2) / dScale, true);
					pl2.reverse();
					pl.append(pl2);
					pl.close();
					//pl.vis(3);
					ppProtect.joinRing(pl, _kAdd);
				}
			}
		}

	// add grip point if not found
		if (bEditInPlace && bGetLocation)
		{ 
// TODO			
			if (bHasPage)
				mapParent.setVector3d(ents[i].handle(), ptLoc - page.coordSys().ptOrg());			
			else
			mapParent.setVector3d(ents[i].handle(), ptLoc - _PtW);
			bSetParentMap = true;
		}

		ptLoc.vis(2);
		dpx.color(ncText);
		dpx.draw(sText, ptLoc, vecX, vecY, nTextAlignmentX, (bHasStaticLoc?-1:0));	

		if (!bHasMultiGuideLine)
		{ 
		// change display color if not numbered and not in automode	// HSB-23435
			int bIsNotNumbered = nPosNum < 0 && (g.bIsValid() || (t.bIsValid() && !bIsStackItem && !bIsPackItem)) && sAutoAttribute.find("@(posnum",0,false)>-1;
			if (bDrawBorder && bIsNotNumbered)
			{
				dp.color(nc==1?5:1);
				dp.draw(plBoundary);
			}				
		// filled frame	
			if (bDrawBorder && bIsNotNumbered)// && !bHasStaticLoc
			{
				dpBackgroundX.trueColor(rgb(255, 0, 0), nTransparency);
				dpBackgroundX.draw(PlaneProfile(plBoundary), _kDrawFilled);	
			}
		// filled by textcolor frame	
			else if (bDrawBorder && nTransparency<0)
			{
				//dp.color(ncBackground);
				dp.draw(PlaneProfile(plBoundary), _kDrawFilled, abs(nTransparency));
			}
		// solid filled frame	
			else if (bDrawBorder && nTransparency>0 && nTransparency<100)
			{
				//dp.color(ncBackground);
				dpBackgroundX.draw(PlaneProfile(plBoundary), _kDrawFilled);
			}			
		// box with frame
			if (bDrawBorder)
			{
				//dp.color(ncBorder);
				dp.draw(plBoundary);	
			}
			
		// text
		
						
		}
		
	// draw grain direction if applicable
		if (nNumLineGrain>-1)
		{ 
			Vector3d vecXGrain = sip.woodGrainDirection();
			vecXGrain.transformBy(ms2ps);vecXGrain.normalize();
			Vector3d vecYGrain = vecXGrain.crossProduct(-_ZW);
			
			// HSB-22503 alignment
			if (vecXGrain.isParallelTo(_ZW))
			{ 
				vecYGrain = sip.vecZ();
				vecYGrain.transformBy(ms2ps);
				vecYGrain.normalize();
			}


	 		double dXG = .5*dp.textLengthForStyle("O", sDimStyle, dTextHeightStyle);
	 		double dYG = .25*dp.textLengthForStyle("O", sDimStyle, dTextHeightStyle);
	 		
			double dHeightLine = dTextHeightDisplay / nNumLine;	
			Point3d ptX = ptLoc + vecYGrain * (.5 * dTextHeightDisplay - (nNumLineGrain+.5) * dHeightLine);
			
//		// transform location in x if grainsymbol appears to be in line with text
//			if (abs(dGrainXOffset)>dEps)
//			{ 
//				double d = dGrainXOffset - .5 * dXMax+.5* dHeightLine;
//				ptX+=vecXGrain*d;
//			}
			ptX.vis(2);
			vecZ.vis(ptX,2);
			vecXGrain.vis(ptX,2);
			
			PLine plGrainSymbol(_ZW);
			
			dp.color(1);
			if (vecXGrain.isParallelTo(_ZW))
			{ 
				dHeightLine *=.5;
				plGrainSymbol.addVertex(ptX - (vecX + vecY) * .5*dHeightLine);
				plGrainSymbol.addVertex(ptX + (vecX + vecY) * .5*dHeightLine);
				plGrainSymbol.addVertex(ptX);
				plGrainSymbol.addVertex(ptX - (vecX - vecY) * .5*dHeightLine);
				plGrainSymbol.addVertex(ptX + (vecX - vecY) * .5*dHeightLine);
				plGrainSymbol.addVertex(ptX - (vecX - vecY) * .5*dHeightLine, tan(45));
				plGrainSymbol.addVertex(ptX + (vecX - vecY) * .5*dHeightLine, tan(45));
			}
			else
			{ 	
//				Quader qdr(ptX, vecX, vecY, vecZ, 2 * dHeightLine, .5*dHeightLine, dHeightLine, 0, 0, 0);
//				qdr.vis(6);
//				double dXG = qdr.dD(vecXGrain);
//				
				plGrainSymbol.addVertex(ptX + (vecXGrain * .5*dXG - vecYGrain * dYG*.5));
				plGrainSymbol.addVertex(ptX + (vecXGrain * dXG));
				plGrainSymbol.addVertex(ptX + (-vecXGrain * dXG));
				plGrainSymbol.addVertex(ptX + (-vecXGrain * .5*dXG + vecYGrain * dYG*.5));				
			}

			dp.draw(plGrainSymbol);	
			dp.color(nc);
		}		
		
		
	}
	
	
//	if (bDebug){ Display dp(171); dp.draw(ppProtect, _kDrawFilled,20);}
	if (bDebug){ Display dp(1); dp.draw(ppTagProtect, _kDrawFilled,20);}
	
	// HSB-16117 branching version hsbDesign 23 or newer: setDefinesFormatting is only supported hsbDesign 24.1.1 or higher
	sAttribute.setDefinesFormatting(_ThisInst, mapAdditional);
	
	if (bSetParentMap)
	{
		String parentID = bIsElementViewport?el.handle():"View";
		mapParents.setMap(parentID, mapParent);
		//_ThisInst.setSubMapX("Parent[]", mapParents);
		_Map.setMap("Parent[]", mapParents);
	}


// publish protection area
	_Map.setPlaneProfile("ppProtect", ppProtect);	
	{ 
		//ppProtect.vis(0);
		Map mapX;
		mapX.setPlaneProfile("ppProtect", ppProtect);
		mapX.setInt("Priority", nSequence);//HSB-8276
		mapX.setVector3d("vecZView", vecZView); // HSB-12241 storing the view direction filters only parallel view directions
		_ThisInst.setSubMapX(sSubXKey, mapX);
	}	
	
	
	
//region Draw something if no tags could be drawn
	if (bHasSection)
	{ 
		String sLayerT;
		if (ppShadows.length()<1)
		{ 
			dp.color(1);
			Point3d pts[] = section.gripPoints();
			if (pts.length() < 1)pts.append( section.coordSys().ptOrg());
			String text = T("|Section| ") + scriptName() + T(" |no intersections found.|");
			dp.draw(text,pts.first() , _XW,_YW,1,-1.5);
			
			_ThisInst.assignToGroups(section, 'T'); // do not print
			
		}	
		else
		{			
			_ThisInst.assignToGroups(section, 'I'); // printable
			
			String s = _ThisInst.layerName();
			int n = s.find("+I0~", 0, false);
			if (n>-1)
			{ 
				sLayerT = s.left(n)+"+T0~";
			}
			
			Display dpInfo(nc);
			dpInfo.layer(sLayerT);
			
			PlaneProfile ppRange = bdClip.shadowProfile(Plane(ptRefClip, clipVolume.coordSys().vecZ()));
			
			Vector3d vecXC = clipVolume.coordSys().vecX();
			Vector3d vecYC = clipVolume.coordSys().vecY();
			Vector3d vecZC = clipVolume.coordSys().vecZ();
			LineSeg seg = ppRange.extentInDir(vecXC);seg.vis(4);
			double dX = abs(vecXC.dotProduct(seg.ptStart() - seg.ptEnd()));
			
			Point3d pt = seg.ptMid(); pt += viewFromDir*viewFromDir.dotProduct(ptRefClip - pt)-viewFromDir*dSectionOffset;
			if (dSectionDepth==0 && dSectionOffset>0)
			{ 
				PLine pl(pt,pt- vecXC * 2 * dTextHeightStyle);
				pl.transformBy(-vecXC * .5 * dX);
				dpInfo.draw(pl);
				pl.transformBy(vecXC * (dX+2 * dTextHeightStyle));
				dpInfo.draw(pl);
			}
			else if (dSectionOffset>0)
			{ 
				
				PlaneProfile pp;
				pp.createRectangle(LineSeg(pt, pt- vecXC * 2*dTextHeightStyle - viewFromDir * dSectionDepth), vecXC, viewFromDir);
				pp.intersectWith(ppRange);
				
				pp.transformBy(-vecXC * .5 * dX);
				dpInfo.draw(pp, _kDrawFilled, 80);
				
				pp.transformBy(vecXC * (dX+2 * dTextHeightStyle));
				dpInfo.draw(pp, _kDrawFilled, 80);
			}			
			
		// on horizontal sections show something in 3D section view	
			if (viewFromDir.isParallelTo(_ZW))
			{
				dpInfo.addViewDirection(vecZC);
				dpInfo.addViewDirection(-vecZC);				
				dpInfo.draw(scriptName(), ptRefClip, vecXC, vecYC, 1, 1,_kDevice);
			}
			
			//dpInfo.draw(scriptName(), _Pt0, _XW, _YW, 1, 0);
			
			
		}
	}

//endregion 	
	
	
	
	
//	if (bDebug)
//	{
//		Display dp(3);
//		dp.draw(ppProtect, _kDrawFilled);//.vis(3);
//	}

// publish element being set in layout
	if (bIsElementViewport)
		_Map.setString("CurrentElement", el.handle());


// performance 
	if (bDebug)
	{ 
		//reportMessage("\n" + scriptName() + _ThisInst.handle() +" done in "+ (getTickCount() - nTick) + "ms with priority "+nPriority + " time " + time );
		reportMessage("\n" + scriptName() + _ThisInst.handle() +" done in "+ (getTickCount() - nTick) + "ms with priority "+nSequence);
	}



//region Dialog Trigger
//HSB-13442
{ 
	// create TSL
	TslInst tslDialog;			Map mapTsl;						
	GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };
	
//region Trigger AssignPosnums HSB-19843
	String sTriggerAssignPosnums = T("|Assign Posnums|");
	if (gbNoPosNums.length()>-1)addRecalcTrigger(_kContextRoot, sTriggerAssignPosnums );
	if (_bOnRecalc && _kExecuteKey==sTriggerAssignPosnums)
	{
		for (int i=0;i<gbNoPosNums.length();i++) 
			gbNoPosNums[i].assignPosnum(1, true); 
		
		setExecutionLoops(2);
		return;
	}//endregion	
	
	
	
//region Trigger DisplaySettings
	String sTriggerPGSetting = T("|Painter Group Settings|");
	if (bGroupByPainter)addRecalcTrigger(_kContextRoot, sTriggerPGSetting );
	if (_bOnRecalc && _kExecuteKey==sTriggerPGSetting)	
	{ 
		mapTsl.setInt("DialogMode",1);
		mapTsl.setString("opmKey","PainterGroup");
		
		String sSeqColor;
		for (int i=0;i<nSeqColors.length();i++) 
			sSeqColor+= (sSeqColor.length()>0?";":"")+nSeqColors[i]; 
	
		String painterPG = sRule;
		sProps.append(painterPG);		
		sProps.append(sNoYes[bHatchSolidPG]);
		sProps.append(sSeqColor);

		nProps.append(ntPG);
			
		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{ 
				
			// keep user infromed about potential delay
				reportNotice("\n*** " + scriptName() + " ***" + TN("|The drawing contains| ") + 
					tslSeqs.length() + T(" |entities which are dependent from the changed properties.|") +
					TN("|Please be patient until entities have been recalculated.|"));

			// get properties	
				painterPG = tslDialog.propString(0);
				bHatchSolidPG = sNoYes.find(tslDialog.propString(1),1);
				sSeqColor= tslDialog.propString(2); 
				ntPG = tslDialog.propInt(0);

			// rewrite parent map without current entry
				String subKey = "PainterGroup";			
				Map mapTemp;
				for (int i=0;i<mapPainterGroups.length();i++) 
				{ 
					Map m = mapPainterGroups.getMap(i);
					if (m.getMapName().makeLower() != painterPG.makeLower())
						mapTemp.appendMap(subKey, m);					 
				}//next i
				mapPainterGroups = mapTemp;
			
			// append this entry
				Map m;
				m.setInt("HatchSolid",bHatchSolidPG);
				m.setString("ColorList",sSeqColor);
				m.setInt("Transparency",ntPG);
				m.setMapName(painterPG);
				mapPainterGroups.appendMap("subKey", m);

			// write to settings and store in mo
				mapSetting.setMap(subKey+"[]", mapPainterGroups);
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);				
			}
			tslDialog.dbErase();
		}
		setExecutionLoops(2);
		return;	
	}
	//endregion	

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
}
//End Dialog Trigger//endregion 








#End
#BeginThumbnail
MB5!.1PT*&@H````-24A$4@```9````$L"`(```!BU7*5````"7!(67,```[$
M```.Q`&5*PX;```7?DE$051XG.W=76R;UWW'\3^S>E[BDD&3P%;(,$-4+Y6"
M-+)F6U+2NTK@W`A98MTT-N*;"=H,0?!T$6`70F$:A08,\(5F")I1U5<VK/1&
M=I8I#5@Y5TM"2_%DI9ZI!"Z-A2%-N^Y+R-FNZS7<!47J/.3#%TE\^S/?#XJ"
M$<F'AR;YXWGY/X>.5"HE`*#!0_5N``"4B\`"H`:!!4`-`@N`&@06`#4(+`!J
M$%@`U""P`*A!8`%0@\`"H`:!!4`-`@N`&@06`#4(+`!J$%@`U""P`*A!8`%0
M@\`"H`:!!4`-`@N`&@06`#4(+`!J$%@`U""P`*A!8`%0@\`"H`:!!4`-`@N`
M&@06`#4(+`!J$%@`U""P`*A!8`%0@\`"H`:!!4`-`@N`&@06`#4(+`!J$%@`
MU""P`*A!8`%0XQOU;@``>R.C_U2E(__5SM9_'/F'*AV\J@@LH$']U^5/ZMV$
MAD-@`0WML<<>>^Q;WZK4T:*QV+U[]RIUM-HCL("&MG?OGK_Q^2IUM*FI?[OV
MJU]5ZFBUQZ0[`#4(+`!J$%B`;M=OW[\26YV6NI5\<"5V[\[]K^K;I.HAL`#=
M?OK!K\?.1]*79Q9_,W8^<N>/?ZIODZJ'P`)TNW[[#\\\L35]^5;R_T1DNW-+
M75M41006H-B=^U_=N?]5-J&N1.]FPZLI4=8`J'3]]OT[?_SJ^NT_B,BVK0]=
MB=V[<W]U)'@E=N^9Q[=NV]J$W1$""U#IIQ_\^DKT;OKR^RN)]U<2Z<O7;]\?
M.Q\9?\W[O/OA^K6N6IHP@P$T*WI8@$KCKSXE(O_Z?OS]E<39P9W;MC[TSB>_
M^^E__KI9^U9I!!9075<^_S)Q[T&5#IY>%DQ/5Z7+K[;]>3,/FP@LH+I^]-8G
M'WYZ>P-W_'89M[F5>)!=%OQE[)Z(L$H(8+.>?_I1U\/K*X^Z6>`DY2NQ>]GI
M]EO)!]MERUN+OQ&16XD'(I*^G/;]-E>3U6016$`M_/CU%U[ZSA/KNLM+[]K_
M_4KT[HR12K>2#\S_-"\_[WF$P`)03]N=6Y[W/"(B=^[_Z?KM^]N=6[:[MJ0O
M;]OZT#-/_$7VELTWGT5@`<I\O\WU_3:7B%R\_K___/-8;YOK];V/7XG=&SL?
M^=L7OO7ZWL?KW<`J:K8`!KX^KM^^+R+IWM;7!($%-(/T-'QS+Q$*@07HM5K'
M\/A:2&W;^F?U:TXM$%B`;NFJT71X;7<V^:QTDS\]H(GU/+/MNYFS<'J_X_JN
M^^$F*V+(1V`!6KWRPMK/?Z77#9L>0T(`:M##`AK:;W_[NU]5[I<$5?^*JA!8
M0(-;7%Q<7%RL=RL:!4-"`&K0PP(:U.3$OU3IR,YO?K-*1ZXV`@MH4'^]ZX5Z
M-Z'A,"0$H`:!!4`-`@N`&@06`#4(+`!J$%@`U""P`*A!8`%0@\`"H`:!!4`-
M3LT!*NQ';_WRRN>_%Y$3?[?;^X3E)VU^\HMK/U^Z(2(_?OV%YY]^M#[MTXP>
M%E!AWL<?_O#3VQ]^>ONM#_XGYZKC_[[RX:>W_SOR)6FU,0064&$_Z'2G+_SL
MP\_-O[_UP>=?WGT@(C_\WE_6H5E-@<`"*LS[Q",_Z'Q21"*W[Z8'@&G3\]?2
M%_Z^[]OU:9E^!!90>=D^U,\RH\(KG__^RN=?BLA+WWDB9V(+Y2.P@,K[0>>3
MCSZR141^OG0C\IN[(O*3^=5]V1D/;@:!!51%-I@BM^]F___11[:\_KVGZ]DL
MY0@LH"I^^))-,-&]VB0""ZB*YY]^-+]VP3;%4#X""ZB6G'BRC3"L"X$%5$O.
M`'"H;V>]6M(T""R@6LPI]D<?V9(NSL)F.#[YC^/U;@/0S/IF6],7Y@?"]6U)
M$Z"'!517.J=(JXH@L("J(ZTJA<`"H`:!!4`-`@N`&@06`#4(+`!J$%@`U""P
M`*A!8`%0@\`"H`:!!4`-`@N`&@06`#4(+`!J$%@`U""P`*A!8`%0@\`"H`:!
M!4`-`@N`&@06`#4(+`!J$%@`U""P`*A!8`%0@\`"H`:!!4`-`@N`&@06`#4(
M+`!J$%@`U""P`*A!8`%0@\`"H`:!!4`-`@N`&@06`#4(+`!J$%@`U""P`*A!
M8`%0@\`"H,8W?A>]6N\V`$!9Z&$!4(/``J`&@05`#0(+@!H$%@`U""P`:A!8
M`-0@L`"H06`!4(/``J`&@05`#0(+@!H$%@`U'*E4JMYM`("RT,,"H`:!!4`-
M`@N`&@06`#4(+`!J$%@`U""P`*A!8`%0@\`"H`:!!4`-`@N`&@06`#4(+`!J
M$%@`U""P`*A!8`%0@\`"H`:!!4`-`@N`&@06`#4(+`!J$%@`U""P`*A!8`%0
M@\`"H`:!!4`-`@N`&@06`#4(+`!J$%@`U""P`*CQC;H\:F#ZW*&@B$A*/&=.
M=?F,J\)S%UZ<38A(2ES^\=[AEKHT<'/BR<"EZ+NQZ-6H+$<2YC4I<>WRRG,>
MS[-[//LZG:T;?(#DE'_^6$1$)-73?6O(O>D6VQ^\I`ZO2SS.U]Q/[>MW;_2Y
MH,$L+>R8C(K=9[,1U"6PDM>BF8M>UT[K5>\M9C_ASIW*TBH9F`L=GXTN%[Z%
M0Q++$5F.)"08.B;2X?6\>;C+M\ZG&9Y;6$TK\9RI<%JMSW(D(9'$LD2/S4I'
M3_?)(6)+O\[VH][HL8@X)/J&?R7H;VNHU[0N0\+D9]DO<(^KM=!5N5G6T,)+
M"[[!^4-%TRK?<B1Z:.R<;WHE7/Y]XBN'9U<S?==`>^-\`2X'+_9,Q^K="A5B
MHX/G=F3^YYM+UKL].9S#A]L[1$3$$0D=;K#FU:.'M?3%3.;B+K?3<E4\<35[
MU5Y/0T5[839CJ)2X=O5X7MOCV?>DM+9DGV,R'$]>N_3%NXO1&>/VR\%03S!:
MWO@W.74RM+SZ$)XW^YTE;KYI'0-]@0*/$HXGKUVR]"@=P8L^=\';0XV6MC=[
M0NE)F\NSH4!_`PT,Z]##"L?6,ONYG,"ZD5@N=%5CBL=&!RUIE?)ZCH[TW3K5
M&QAJ&^YT&FDE(L[6%K>OOVO"O__F>-_I'E?V"H<D_&,71I=*/=Q2*/M8=>]>
MM;8X??U=@?'5;^.TR[.A0-U:A(KQO9+I9$GTC4;J.-<AL*[%5D<T*?&\W&FY
M*IME*7$]^V2-V[5^\17?V,5L;S$EK@,C?;?\7<.=941MB],WU'MSO/V`=_4/
M#DF<G;PP%2]RG]CH9#3S6!7H7H7CL5'_!9^_^(.6TM)V<L!,WNB[)6,7U9)^
M01>FEC8]CFOQO)9Y9THPM*EW2$75/K":9L8]-CH6RO8'4^(Y,]X[44Y4F5K:
M)OQ]1XW,\I\L.)\5G@MEPU%ZGMI$]RH9F%OP#9Y[<>SB3"1QN;P%P2):=WO,
M3M;56&/->GR]1!++D>BQR?GM@Q=\T['PQH/&.?RJ)WW)(0G_.XW2R:K-'%9L
M='"M)Y+EB(1>'`S9WL$AT4.#YT0DY6UOM'4*$1%)3OG-OE7>`G`\-O5.Z'QP
M;82;\KH.[FT_8K/\[QSV=W^6^?=Q1$*'YSQVTT!FFLO!/1M:'(S'IMX)'0LF
M2M]R75I<SXG8KC9DBU1D]5^I7>9"QQ>CRYF4/#"R?\+:RY9X;.K2%^>-VXA(
MRNO:Y?&\^8K'UU+@*R&S&"^9@IA]-U9.O!V=,<I*,@=I*[TL&T\&+EG:64X;
M2C_9'L],,)ISK^79^1VS(JO3A4GSDU*D9L7Z6#8%0`Y)+`<OOAB4E-?C?[6]
MK%Y_CLZG#DATM3'!T-0K[D:H,:I/'585V&=B21NK]LH6%F2.8*95,C"]<"@O
M%!R1Q$SDXME9U\$>F0F:;^LNG[@GQMNO9OIK]M.<QNQ5_E"ZE&1X*73X;<O'
M+]OX@P/M^S;Y1C262HHWX[A_/K\-Y@VFIA=L\]0122Q'$H>"H937<Z94(8A#
M$L?&SATK?)`B*PF%7K[UMJ&,)VO+?63`-9-)(@E^$1ARVW6E+=]>XO5D7D'W
MD1'/5>L+[8A$CTU&_>(Z.&#[?5FL,2_WR$Q01,0AB?.7DL,-L)Q"I?L&Q$[,
M&IV=$3/ODE/^>=NW>YI#$C/FM=F174O;FSW9V]A,`P4^CMK<JZ1X;&KZPH[!
M^1<G<].JP^LY/=YWZU3O1*UJ/M,U:(7%1OWS)7M_CDCTC;'-3;J)+,_.^^PG
MDDN\?.6WH=23+<@<7Q><$(Q'SQL'-]?36SN[`O[]-\>[CQI+.NGVS,Q>?''P
MG,^_$(B7.V;W[?%D+U]>C*ZC^*9J:M/#<D^<VC\A(DU1XV[.):5ZNLT136`Z
M9\6P_<SA-E^+2#P9OF'3QS&K.GROM'<$5SM99S^.372:8P%CXJ^\\6!X:>7$
MVZ&9`EVJ=7[3EA!XQYS+<[VVN]CW<$I<!T>ZCG0Z6T7"\63KZJN<G/)?G+$N
MMOI?;=^W>K/8>\9(UB$)_]C"SC**L(V#),-+H<.3:Q48R\&+HWMR1J.YY2GF
M8"H<CYTX&<H.,,ML0]Z3=4X,2<YH(+>[U^)YS1O*OD_RW@DB(N%+47/RU&;Y
MI<4]/.0>'K+I62]'HH?&HN6^#9YT=4CFL2+1]^)M=?]4UGA(6+T9][5,K+*U
M=J;$Y7]E[<T4GKN0SN(TRQNQQ=G:TA7HM'PD<C_;YDQ0-!$6X\UD?*.66#^-
M)P/O+!PWYL[6VN/UO'FXO>`<T$:%EQ;,9VT,3VRDQ'-F?&TPE:WY,(?8(I+J
MZ0X:1?.M+>[A(?<^]]JL37JMO?@Y2=;*>V=K9U=@/#9JK.J>?7OE2*<Q/6H,
MNB4O1UI;W!-^]Y&Y=;2AT),MQ;EOK^M8I,BHT#H>+-;==K9V=@4Z;>8NTQVN
MF5GIZ&DO-JEGO"<;9%18XR&A_AIWLS?>TVY\X5C&B:F>;KM9DK4:XO1_6G/9
M_7)F5"B1Q#7SFAMF`!5*\^24_]R.L?E#UK1*B>O`0/='I_8'_%V53*MX,KRT
M,NJ_\.*D91;YX*L%5TA6)_ML&F_Y!*:\[4&[4WQ:^WM/]QC_772M/=73'<@_
M2(O[B%&!(9'H>VM'2$Z]O?9$4M[VDW:?S/+;4/C)EM;:WWX@<]EF5&@=#Y:U
M_-+B'A[JO7FJ[Z,13X?7<LUR,'1H[-QV_T+`_HD8[TF1RPVP_EO;'I;^&G>S
M-VZ^5P+3UD7#0HL[QMW+SV6SU+;PO8S$%Y$*=:FR:UCE.##2E[OD9U$@:G,^
M@84CSQPU%_G"S^GYFEK[VP_,9A9DS2-LM`V?W1"Q3Z7-U.6LS79+7D\P9SRX
MGN67@ATNB22OB92>&,WI^-=#37M89EUH[DR'DAIWH^K5')K%WC6&145JT+-W
ME_7DLGFOQI3R>DZ/[U]W&9J(Y'X"BPYXS6K&#7[A.Y^U/8+Q]BN1`M8VG/VX
M*@5*YFQW3D_0[(W6X&R'G6ZS3VKM^-=#37M8Q@<O]_M'28V[.?EM/`6CYUBT
M!MV2:V7GLF7&/6\HO=:>9[TB&YY>7;_5K7+V>E[>749E4YF*3H&).'=ZC.>X
MD2]\^R.8?=AL#6!9JM3I,&J@"O4$2ZYOY"E8W2)>9^-.PEC5,K"*S+@7R[+R
MU+0.2\3R%"PU!T4&>L:PU^YKO-B_3QF<P_[]PWF3[FO3JQL:(18M6:J,1N@_
M-D(;K"P%69<7H^'^MM;<*87BX6XH7#!<8M)=I-7M%&F@?YRJ!Y99DIM53HV[
MV)9!UUGN/%'ZCV8/J-A`SYP[MXDDVX.O4XO3-]3K&[(I:ZAVAPN5U;K;TS&;
ML)846,]V*#S1EE&B8%CCVZ!I*MT5L'3$\D=VYHJ$)?6LHYCRM':V372V3119
MSZY.E<,&['2[ZOX=;K:A4<X&,PJR5D>%N\WQ8-&)MB)=JH9YW3>F:0*K-G58
MN?-$ZV&9P,I?C3;CK&++#I4J(*PFRZ`CDK@F4K@Q94[G%6%_A/6TH68L!5F7
M%Z,!,<:#!<JOPDL+E>U2A1N@E,%4]<!J[>^]V2_2%#7N%NM\6UOJX_,7%N(K
MQS-QEO*V'[%^>5KZ(!N::2Y20'AV-O3L[KJ>UVJ44Z?+CGR%^@XYIZ1L(-8+
M%3&5WX8:LA1A1$*'2I=?Q4Y,YNYYN_&3GT4D9W:O`0HD:U;6T!R[RCAWKBTW
M)Z_%\_]8:*W=4E::]S0M.]7DSTVTFI_,S2PM9PH(3P]8-H2ILYQ"@;<+;K"S
MKG.`;!4LH2B[#3D;')?><W%3+'6;6?E?:3:W$5='3_='X_O+W:"M'!OITE98
MK0++_&936N,N(D99RFK1H/6/(G;5S_'8J-^Z@FD^3>NU]N_%)UU&OF2#<L.<
MOOZNP*G]'XUW'_"Z=GE+WZ'*G/OV&EL`1D(]T['\O,@Y\\EZFH&%0Q+^DW:E
MV\9V^'E'6-O^J4@;)*]">)W;9JR;I2`KH]C"CM?5L;;GK;MULU__U@+#!BB0
MK%5@&0MD2FO<T\R3Z;/?P]9S*=*;':?[6<G`W()O[&+N2<CI7E(\&9B^8%Z;
M$L\9V^E>X_O?#,K-/I<6]X2_-^"O_QB\M;_KJ)&;CN#%'O_"U%(R_<\;CL>F
MIBUKS25_+BB]H8)O>B6S,T'ZA;!NN)ASA,XN\[0;1_!BS^"%T4P;1-*G(IVS
MAN;&ME&T%J_.A@J<%I-NU5,'K'\HVK5,OZ"5ZU)9"G$VTJ6MN!I-NC=!C?LJ
M<^TF$CJQU#;1*2+NB1'/3.:L.H<D9B;GBQ2%V98FIKR>,_Y"9_];%@IMS^!7
MSCGL[_[,V+`AO8M3_IY68K,!F3V')):#B4-!F^J9]"8*^4?P#?4=C:Z=G5[\
M=4R?\UBJ%;8LKZ9#HH?&SDG!WP&T[I`EZRF_VCQ+(4X-'[>P&O6P]->X9UG&
M#F<G%U9_<Z&SZZ,!5X&[I'^9HN"T44I<'0/=P8)I)9(S-`A^T8P_].">\/?E
M[.*4+^7UG-G<LDS*Z_&/]Q:H[W,.^_M.%WX=LSIZNC=3^F`[T"LD9P?J,LJO
M*L9<N6Z0T4]M`JLY9MPS.MN-7=BC;_BS`\/>],9IYMLKY74=&.D+^KN&.[L"
MX]T'C+%`2EP=7L_1@>[@J=Y`R?5FZX,VZ0\].(>'>F^.=Q\=R-U4(.5U=?2T
MGQ[ON^4OO05"2EQ'1_I.#W@ZO);H24_N!/U=1?/.Z>M?79<XX,U-K@ZO9W7K
MBTW^9&QGU\WQ]MSC%YI,;'$]E[E8@UDSP]H$5H.,!T7$D4JEZMT&A>(KE@F1
MFI0:6K;QKOPOU"N7MZ=[W2?F*L9\:K5\W>OUN$6Q1?*&M+0%C"&>(Q+J&;Q0
M@=]6*LJ<VF_242'RK6W4563;G"9ZW!((K(WJ[+)DEB2.3<YOK\A/PA7DGAC)
M_O)2]'B#_88XJL&R%VLMI[T+;E199P36)N1-2SDBT6.3\SL&S_G\"U-SL4`\
M&<[=\#\9CB?#2['`W,*H_\*.P7/;U_6SNL9,%K^QW.R2`>O&`36=;L_4Z):L
M(*DQYK`V+QF8"QV?S3TEHGSKVY3"F#ZKP=XO:C31'%;V)#9336>1&O@]1@]K
M\]*%XS8;9I<CY?4\*^L9W!D_#4\GZVLBY:UE-R<Y=3+3O2JPMWT=-<UN#767
M.<%8DN&EY'L??_%9-'E59#F2N\5'RNO:)<[G/*Z7]WA\&ZI(;NWO.KHX?RQ2
MUH_'0+64N';UM)_<9!7%NF1^/:C@>1=UQ9`0@!H,"0&H06`!4(/``J`&@05`
M#0(+@!H$%@`U""P`:A!8`-0@L`"H06`!4(/``J`&@05`#0(+@!H$%@`U""P`
M:A!8`-0@L`"H06`!4(/``J`&@05`#0(+@!H$%@`U""P`:A!8`-0@L`"H06`!
M4(/``J`&@05`#0(+@!H$%@`U""P`:A!8`-0@L`"H06`!4(/``J`&@05`#0(+
M@!H$%@`U""P`:A!8`-0@L`"H06`!4(/``J`&@05`#0(+@!H$%@`U""P`:A!8
M`-0@L`"H06`!4(/``J`&@05`#0(+@!H$%@`U""P`:A!8`-0@L`"H06`!4(/`
M`J`&@05`#0(+@!H$%@`U""P`:A!8`-0@L`"H06`!4(/``J`&@05`#0(+@!H$
M%@`U""P`:A!8`-0@L`"H06`!4(/``J`&@05`#0(+@!H$%@`U""P`:OP_2>O6
1CDU<I9H`````245.1*Y"8((`










































































































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
        <int nm="BreakPoint" vl="5684" />
        <int nm="BreakPoint" vl="5674" />
        <int nm="BreakPoint" vl="2754" />
        <int nm="BreakPoint" vl="1280" />
        <int nm="BreakPoint" vl="5754" />
        <int nm="BreakPoint" vl="5524" />
        <int nm="BreakPoint" vl="2541" />
        <int nm="BreakPoint" vl="5705" />
        <int nm="BreakPoint" vl="7351" />
        <int nm="BreakPoint" vl="6344" />
        <int nm="BreakPoint" vl="5505" />
        <int nm="BreakPoint" vl="4581" />
        <int nm="BreakPoint" vl="4527" />
        <int nm="BreakPoint" vl="7030" />
        <int nm="BreakPoint" vl="6826" />
        <int nm="BreakPoint" vl="6874" />
        <int nm="BreakPoint" vl="6811" />
        <int nm="BreakPoint" vl="357" />
        <int nm="BreakPoint" vl="374" />
        <int nm="BreakPoint" vl="346" />
        <int nm="BreakPoint" vl="4599" />
        <int nm="BreakPoint" vl="4565" />
        <int nm="BreakPoint" vl="4555" />
        <int nm="BreakPoint" vl="5513" />
        <int nm="BreakPoint" vl="7208" />
        <int nm="BreakPoint" vl="5717" />
        <int nm="BreakPoint" vl="5729" />
        <int nm="BreakPoint" vl="7255" />
        <int nm="BreakPoint" vl="725" />
        <int nm="BreakPoint" vl="2142" />
        <int nm="BreakPoint" vl="1366" />
        <int nm="BreakPoint" vl="5134" />
        <int nm="BreakPoint" vl="3042" />
        <int nm="BreakPoint" vl="5423" />
        <int nm="BreakPoint" vl="4265" />
        <int nm="BreakPoint" vl="7057" />
        <int nm="BreakPoint" vl="1952" />
        <int nm="BreakPoint" vl="3968" />
        <int nm="BreakPoint" vl="4206" />
        <int nm="BreakPoint" vl="5365" />
        <int nm="BreakPoint" vl="5830" />
        <int nm="BreakPoint" vl="7122" />
        <int nm="BreakPoint" vl="6586" />
        <int nm="BreakPoint" vl="6277" />
        <int nm="BreakPoint" vl="6801" />
        <int nm="BreakPoint" vl="6571" />
        <int nm="BreakPoint" vl="5357" />
        <int nm="BreakPoint" vl="3726" />
        <int nm="BreakPoint" vl="7233" />
        <int nm="BreakPoint" vl="6159" />
        <int nm="BreakPoint" vl="5392" />
        <int nm="BreakPoint" vl="5405" />
        <int nm="BreakPoint" vl="6161" />
        <int nm="BreakPoint" vl="4133" />
        <int nm="BreakPoint" vl="4108" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-24510 catching solid of element if not used or present in display" />
      <int nm="MAJORVERSION" vl="14" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="9/30/2025 4:27:55 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-24122 sequencing disabled" />
      <int nm="MAJORVERSION" vl="14" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="6/6/2025 9:32:34 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23212 new type 'FastenerAssembly' supported" />
      <int nm="MAJORVERSION" vl="13" />
      <int nm="MINORVERSION" vl="9" />
      <str nm="DATE" vl="4/8/2025 11:49:57 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23688 tag plcament improved for tsl references. 'not on parent' placment improved" />
      <int nm="MAJORVERSION" vl="13" />
      <int nm="MINORVERSION" vl="8" />
      <str nm="DATE" vl="3/12/2025 2:32:20 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23435 supporting StackPacks and other entities which only provide a solid in model view" />
      <int nm="MAJORVERSION" vl="13" />
      <int nm="MINORVERSION" vl="7" />
      <str nm="DATE" vl="1/31/2025 2:55:04 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23183: Enable &quot;text alignment&quot; commands in block space" />
      <int nm="MAJORVERSION" vl="13" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="1/9/2025 8:52:14 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-22810: remove debug display" />
      <int nm="MAJORVERSION" vl="13" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="10/16/2024 3:00:21 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-22792 using a virtual body for roof elements" />
      <int nm="MAJORVERSION" vl="13" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="10/10/2024 9:05:57 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-22503 alignment text and grain symbol adjusted" />
      <int nm="MAJORVERSION" vl="13" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="8/8/2024 10:12:45 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-21294 isometric views of metalpart collection entities coerrected, nested genbeams of metalaprts contribute quantity if in group mode" />
      <int nm="MAJORVERSION" vl="13" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="7/22/2024 11:20:40 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-22175 debug display removed" />
      <int nm="MAJORVERSION" vl="13" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="6/17/2024 9:22:54 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-22175 'not on parent' modes improved especially for floorplans" />
      <int nm="MAJORVERSION" vl="13" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="6/5/2024 3:37:24 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-22127 leader location improved for entities which are not intersecting the clipping profile" />
      <int nm="MAJORVERSION" vl="12" />
      <int nm="MINORVERSION" vl="9" />
      <str nm="DATE" vl="5/31/2024 3:38:02 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-22167 catching invalid bodies from metalpart definitions" />
      <int nm="MAJORVERSION" vl="12" />
      <int nm="MINORVERSION" vl="8" />
      <str nm="DATE" vl="5/31/2024 2:03:13 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-22038 tag placement improved" />
      <int nm="MAJORVERSION" vl="12" />
      <int nm="MINORVERSION" vl="7" />
      <str nm="DATE" vl="5/10/2024 9:48:08 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-21973 accepting entities referenced by StackItems" />
      <int nm="MAJORVERSION" vl="12" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="5/8/2024 3:14:54 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-20760 Z-projection corrected, Author Thorsten Huck" />
      <int nm="MAJORVERSION" vl="12" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="12/13/2023 4:17:22 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-20760 bugfix leader offset" />
      <int nm="MAJORVERSION" vl="12" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="12/12/2023 12:59:09 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-20689 bugfix edit in place of element viewports " />
      <int nm="MAJORVERSION" vl="12" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="11/22/2023 8:42:04 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-20497 painter selection in blockspace allows any type, leader projection on multipages improved" />
      <int nm="MAJORVERSION" vl="12" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="11/14/2023 4:53:44 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-20497 supports nested entities in sections, new property to control grouping behaviour of painter groups, painter format used if format is empty and painter grouping has been set" />
      <int nm="MAJORVERSION" vl="12" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="10/31/2023 5:35:37 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-20497 supports tagging of nested entities of metalPartCollectionEntities, NOTE: requires hsbDesign 26 or higher" />
      <int nm="MAJORVERSION" vl="12" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="10/31/2023 9:52:15 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18094 tsl selection now supports multiple seleection from list" />
      <int nm="MAJORVERSION" vl="11" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="9/18/2023 9:30:45 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18094 TSL selection now based on potential painter definition or on selected instances" />
      <int nm="MAJORVERSION" vl="11" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="9/11/2023 10:06:18 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-19843 new context menu to number genbeams in case not numbered iitems are found" />
      <int nm="MAJORVERSION" vl="11" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="8/18/2023 4:22:02 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-19385 collecting genbeams by zone and by painter improved" />
      <int nm="MAJORVERSION" vl="10" />
      <int nm="MINORVERSION" vl="9" />
      <str nm="DATE" vl="6/28/2023 10:04:47 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18668 grouped tags support glyph grips to reposition tags within range" />
      <int nm="MAJORVERSION" vl="10" />
      <int nm="MINORVERSION" vl="8" />
      <str nm="DATE" vl="6/7/2023 5:33:50 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-19140 catching opnings with no solid" />
      <int nm="MAJORVERSION" vl="10" />
      <int nm="MINORVERSION" vl="7" />
      <str nm="DATE" vl="6/7/2023 9:26:01 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18926 removed dependency to clipbody on section viewTags to reduce save time" />
      <int nm="MAJORVERSION" vl="10" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="5/12/2023 3:01:33 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18943 insert in multipage blockspace corrected, painter definitions of type MetalPartCollectionEntity, Element, ElementRoof and Opening accepted" />
      <int nm="MAJORVERSION" vl="10" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="5/10/2023 11:57:24 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-17988 bugfix when referring to windows within sections" />
      <int nm="MAJORVERSION" vl="10" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="4/19/2023 11:34:19 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18384 bugfix using font of selected dimstyle" />
      <int nm="MAJORVERSION" vl="10" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="3/20/2023 12:56:22 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18186 MetalParts improved within sections and viewports" />
      <int nm="MAJORVERSION" vl="10" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="3/2/2023 9:51:13 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-17894 new optional selection of entities in viewport mode" />
      <int nm="MAJORVERSION" vl="10" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="3/2/2023 2:36:18 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18013 property values auto corrected when updating from version &lt; 9.5" />
      <int nm="MAJORVERSION" vl="10" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="2/17/2023 12:07:52 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-17894 pure Acad Viewports now auto collect entities of the selected type if nothing selected by the user" />
      <int nm="MAJORVERSION" vl="9" />
      <int nm="MINORVERSION" vl="9" />
      <str nm="DATE" vl="2/8/2023 2:48:37 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-17528 tag overlapping corrected" />
      <int nm="MAJORVERSION" vl="9" />
      <int nm="MINORVERSION" vl="8" />
      <str nm="DATE" vl="1/13/2023 2:31:42 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-16765 not numbered genbeams and tsls are highlighted if posnum is selected as format variable" />
      <int nm="MAJORVERSION" vl="9" />
      <int nm="MINORVERSION" vl="7" />
      <str nm="DATE" vl="12/22/2022 12:31:06 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15850 genbeam type considered when in multipages and metalpart collection entity" />
      <int nm="MAJORVERSION" vl="9" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="12/22/2022 12:02:14 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-16765 new grouped styles added, tag layout more concise, tag background set to nearly white" />
      <int nm="MAJORVERSION" vl="9" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="12/22/2022 11:40:26 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-17297 blockspace preview enhanced" />
      <int nm="MAJORVERSION" vl="9" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="12/12/2022 1:24:17 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-17097: make comparison of painter type case irrelevant" />
      <int nm="MAJORVERSION" vl="9" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="11/18/2022 9:44:41 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-16960 supports tsl mode when attached to a multipage based on a genbeam" />
      <int nm="MAJORVERSION" vl="9" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="11/3/2022 12:55:49 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15850 supports multiapges in modelspace and auto model creation from block space, metalpart collection entities improved, tag outline modified to rounded rectangle" />
      <int nm="MAJORVERSION" vl="9" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="10/7/2022 11:01:02 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-16117 introducing new OPM control to set formatting, requires hsbDesign 24.1.11 or higher" />
      <int nm="MAJORVERSION" vl="9" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="7/27/2022 9:06:13 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-16117 branching version hsbDesign 23 or newer" />
      <int nm="MAJORVERSION" vl="8" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="7/27/2022 9:01:25 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15902 entity collection based on viewport and zone indices improved, collision detection improved if set to vertical or horizontal" />
      <int nm="MAJORVERSION" vl="7" />
      <int nm="MINORVERSION" vl="9" />
      <str nm="DATE" vl="7/6/2022 2:01:54 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15902 bugfix if all zones are selected in hsbcad viewport settings" />
      <int nm="MAJORVERSION" vl="7" />
      <int nm="MINORVERSION" vl="8" />
      <str nm="DATE" vl="7/4/2022 9:23:38 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15730 MetalpartCollection entity in shopdraw and viewport mode enhanced" />
      <int nm="MAJORVERSION" vl="7" />
      <int nm="MINORVERSION" vl="7" />
      <str nm="DATE" vl="6/13/2022 5:00:13 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15624 new graphical definition of section depth and offset" />
      <int nm="MAJORVERSION" vl="7" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="6/8/2022 9:19:19 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15625 bugfix wall extents in section" />
      <int nm="MAJORVERSION" vl="7" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="6/2/2022 8:52:10 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-14527 components of MetalPartCollectionEntities can be tagged. New functionality to set formatting property via OPM " />
      <int nm="MAJORVERSION" vl="7" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="3/29/2022 4:31:42 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-14657 bugfix byZone" />
      <int nm="MAJORVERSION" vl="7" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="3/18/2022 10:31:27 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-14657 reading direction of text improved, collision displacement imroved" />
      <int nm="MAJORVERSION" vl="7" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="2/23/2022 3:16:40 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-14657 bugfix when using mode byZone (introduced HSB-13442)" />
      <int nm="MAJORVERSION" vl="7" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="2/11/2022 12:37:42 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13442 supports painter groupBy definition, new context commands to modify settings, automatic painter creation when stored in catalog" />
      <int nm="MAJORVERSION" vl="7" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="11/19/2021 5:18:31 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13820 available formats are displayed for genbeam types in shopdraw blockmode" />
      <int nm="MAJORVERSION" vl="6" />
      <int nm="MINORVERSION" vl="9" />
      <str nm="DATE" vl="11/16/2021 11:09:52 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13443 openings support additional arguments in format variables" />
      <int nm="MAJORVERSION" vl="6" />
      <int nm="MINORVERSION" vl="8" />
      <str nm="DATE" vl="10/20/2021 11:27:05 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-12241 view direction considered for sequencing" />
      <int nm="MAJORVERSION" vl="6" />
      <int nm="MINORVERSION" vl="7" />
      <str nm="DATE" vl="10/11/2021 1:57:32 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-12678 new custom format 'Zone Alignment' to display the relative alignment of a beam within its zone" />
      <int nm="MAJORVERSION" vl="6" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="9/6/2021 1:10:43 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-12493 format description corrected" />
      <int nm="MAJORVERSION" vl="6" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="7/6/2021 8:44:21 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-12444 painter support enhanced" />
      <int nm="MAJORVERSION" vl="6" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="6/29/2021 3:55:21 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-10713 switching to modelspace when adding entities now switches to the selected viewport if multiple viewports exist" />
      <int nm="MAJORVERSION" vl="6" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="6/23/2021 5:05:53 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-11537 Masselements are added as new type" />
      <int nm="MAJORVERSION" vl="6" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="4/13/2021 11:42:32 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End