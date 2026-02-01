#Version 8
#BeginDescription
#Versions:
Version 6.70 03.11.2025 HSB-24830: Store transformation for each layer separately in case multiple layers at one row , Author: Marsel Nakuci
6.69 23.09.2025 Adjustment to the creation point of hsbPivotSchedule and PlotViewports Susanne Müller
Version 6.68 22.09.2025 HSB-24602: Fix transformation for vertical stacking (nType==1 && nDesign==2) , Author: Marsel Nakuci
Version 6.67 08/09/2025 HSB-24486: Change position of hsbPivotSchedule , Author Marsel Nakuci
Version 6.66 08/09/2025 HSB-24486: Update Layer2Truck transformation for KLH (fix) , Author Marsel Nakuci
Version 6.65 03.09.2025 HSB-24485: Update Layer2Truck transformation for KLH , Author: Marsel Nakuci
Version 6.64 03.09.2025 HSB-24485: Fix when saving "mapsCombi" , Author: Marsel Nakuci
Version 6.63 03.09.2025 HSB-24485: for KLH, fix dimension orientation; fix starting point of dimension , Author: Marsel Nakuci
Version 6.62 25/08/2025 HSB-24432: Fix transformation for KLH , Author Marsel Nakuci
Version 6.61 25/08/2025 HSB-24432: Fix translation , Author Marsel Nakuci
6.60 21.08.2025 Adjustment to the creation point of hsbPivotSchedule, Susanne Müller Susanne Müller
Version 6.59 11/08/2025 HSB-24401: For KLH: Clean/update variable "Package wrapped" in mapX; show command "Apply Layer Separation" , Author Marsel Nakuci
Version 6.58 08/07/2025 HSB-24278: For panels get weight from extended data if provided in xml , Author Marsel Nakuci
Version 6.57 07.07.2025 HSB-24277: Dbcreate klhStackMatrix on dbCreated , Author: Marsel Nakuci
Version 6.56 07.07.2025 HSB-24277: Differentiate FrontDistance with truck name; "SubDesign[]" in XML , Author: Marsel Nakuci
6.55 30.06.2025 Change plot viewport distances for sections, Susanne Müller Susanne Müller
Version 6.54 30/06/2025 HSB-24206: Display block for the front of truck in Grid; extend xml , Author Marsel Nakuci
Version 6.53 23.06.2025 HSB-24205: Missing transformation for KLH , Author: Marsel Nakuci
Version 6.52 16.06.2025 HSB-24148: for KLH: save body volume for combi truck , Author: Marsel Nakuci
Version 6.51 16.06.2025 HSB-24148: Fix shadow at horizontal stacking for KLH , Author: Marsel Nakuci
Version 6.50 28.05.2025 HSB-24097 new commands to generate plot viewports (default only)
Version 6.49 26.05.2025 HSB-24086: Fix section projections for horizontal stacking for KLH 
Version 6.48 21.05.2025 HSB-24008: Fix: Transformation for KLH mode 1 (truck gride mode) for vertical stacking 
Version 6.47 19.05.2025 HSB-24008: Transformation for KLH mode 1 (truck gride mode) for vertical stacking 
Version 6.46 19.05.2025 HSB-24008: Transformation for KLH mode 0 (truck mode) fro vertical stacking 
Version 6.45 12/05/2025 HSB-24007: Transformation for KLH
Version 6.44 24.02.2025 HSB-23527: Save single bodies in an array 
Version 6.43 10.02.2025 HSB-23446: KLH: save each grid in separate map for the Combi 
Version 6.42 04.02.2025 HSB-23445: Provide weight and cog of combiTruck 
Version 6.41 20.01.2025 HSB-23341: For KLH distinguish items generated from CombiTruck from the rest 
Version 6.40 09.12.2024 HSB-23131: Write in _Map body, planeprofile, weight and cog 
Version 6.39 31.10.2024 HSB-22893: Set dim positions relative to the truck sections
Version 6.38 28.10.2024 HSB-22875: Add package dimensions for KLH
Version 6.37 07.10.2024 HSB-22771: show text for min weight only when truck is loaded, at least 5000kg.
6.36 09/09/2024 HSB-22608: new equation for the min axial weight 
6.35 05/08/2024 HSB-22499: For KLH show each item in grid 
6.34 11/07/2024 20240711: Fix when assigning the Bottom/Top panel flag from layers 
6.33 04/07/2024 HSB-22361: cleanup mapx when not top/bottom plate 
6.32 02.07.2024 HSB-22320: Write in mapx top/bottom plate at layer Author: 
6.31 29/04/2024 HSB-21968: Consider the min axl load in the calculation 
6.30 27.11.2023 HSB-20735: Avoid dublicated instances of "hsbPivotSchedule" 
6.29 20.11.2023 HSB-20616: create hsbPivotSchedule with weight for each package on "Generate Plot viewport" 
6.28 12.09.2023 HSB-19939: Apply contour thickness on the inside 
6.27 05.09.2023 HSB-19937: KLH: Show Weight also if no axle definition found 
6.26 05.09.2023 HSB-19937: Fix "readOnly" properties 
6.25 26.07.2023 HSB-19487: Only take the relevant properties when changing the "Stacking" extended properties 
6.24 10.07.2023 HSB-19483: Apply thickness to the outter contour for Truck and Grid 
6.23 28.06.2023 HSB-19334: Use "PropertyReadOnly" flag from the xml 
6.22 27.06.2023 HSB-19334: set properties "ReadOnly" for KLH 
6.21 12.06.2023 HSB-19191: remove display for KLH 
6.20 26.05.2023 HSB-18964: Set "BeddingRequested" flag for f_Item 
6.19 03.05.2023 HSB-18847: Change RowOffset for KLH; It is the distance top to top  
6.18 03.05.2023 HSB-18847: Add command "Generate Plot ViewPort" 
6.17 30.03.2023 HSB-18371: Design "Individuell" will contain multiple axle definitions
6.16 23.03.2023 HSB-18371: For KLH get the net weight from the property set
6.15 17.03.2023 HSB-18360: fix weight calculation for mass elements 
6.14 20.02.2023 HSB-18017: fix flag "L" for layer separation in "StackingData" 
6.13 17.02.2023 HSB-18012: Command add layer separation should be applied to f_Item instances
6.12 03.02.2023 HSB-17789: Fix translation for load calculation
6.11 22.01.2023 HSB-7512: for KLH: Distribution of loads for each axle
6.10 19.01.2023 HSB-7512: for KLH: Set Properties readOnly; Workaround when hideDisplay fails; Extend options in property Design
6.9 11.05.2022 HSB-15456: after projection, remove segments with zero length
6.8 28.04.2022 HSB-15355: fix when writing "StackingData" mapX

HSB-9858 bugfix stacking data also written to child entities if stacked item is of type element
bugfix package data 
new feature settings 'SourceEntity\Propsetname' = 'subMapX' writes stacking data more performant to submapX instead to a property set

HSB-9303 body combining improved if complex solids (high resolution) are stacked
HSB-8965 new design 'Package' added to support lorry stacking
HSB-9292 bugfix layer transformation

layer stacking calls nester if _LastInserted entry of f_layer is set to any nester
package number validation: requires manual recalc of truck 






































































#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 6
#MinorVersion 70
#KeyWords Stacking;Truck;Delivery;Nesting
#BeginContents
//region Part 1
//region History
/// <History>
/// #Versions:
// 6.70 03.11.2025 HSB-24830: Store transformation for each layer separately in case multiple layers at one row , Author: Marsel Nakuci
//6.69 23.09.2025 Adjustment to the creation point of hsbPivotSchedule and PlotViewports Susanne Müller
// 6.68 22.09.2025 HSB-24602: Fix transformation for vertical stacking (nType==1 && nDesign==2) , Author: Marsel Nakuci
// 6.67 08/09/2025 HSB-24486: Change position of hsbPivotSchedule , Author Marsel Nakuci
// 6.66 08/09/2025 HSB-24486: Update Layer2Truck transformation for KLH (fix) , Author Marsel Nakuci
// 6.65 03.09.2025 HSB-24485: Update Layer2Truck transformation for KLH , Author: Marsel Nakuci
// 6.64 03.09.2025 HSB-24485: Fix when saving "mapsCombi" , Author: Marsel Nakuci
// 6.63 03.09.2025 HSB-24485: for KLH, fix dimension orientation; fix starting point of dimension , Author: Marsel Nakuci
// 6.62 25/08/2025 HSB-24432: Fix transformation for KLH , Author Marsel Nakuci
// 6.61 25/08/2025 HSB-24432: Fix translation , Author Marsel Nakuci
//6.60 21.08.2025 Adjustment to the creation point of hsbPivotSchedule, Susanne Müller Susanne Müller
// 6.59 11/08/2025 HSB-24401: For KLH: Clean/update variable "Package wrapped" in mapX; show command "Apply Layer Separation" , Author Marsel Nakuci
// 6.58 08/07/2025 HSB-24278: For panels get weight from extended data if provided in xml , Author Marsel Nakuci
// 6.57 07.07.2025 HSB-24277: Dbcreate klhStackMatrix on dbCreated , Author: Marsel Nakuci
// 6.56 07.07.2025 HSB-24277: Differentiate FrontDistance with truck name; "SubDesign[]" in XML , Author: Marsel Nakuci
//6.55 30.06.2025 Change plot viewport distances for sections, Susanne Müller Susanne Müller
// 6.54 30/06/2025 HSB-24206: Display block for the front of truck in Grid; extend xml , Author Marsel Nakuci
// 6.53 23.06.2025 HSB-24205: Missing transformation for KLH , Author: Marsel Nakuci
// 6.52 16.06.2025 HSB-24148: for KLH: save body volume for combi truck , Author: Marsel Nakuci
// 6.51 16.06.2025 HSB-24148: Fix shadow at horizontal stacking for KLH , Author: Marsel Nakuci
// 6.50 28.05.2025 HSB-24097 new commands to generate plot viewports (default only) , Author Thorsten Huck
// 6.49 26.05.2025 HSB-24086: Fix section projections for horizontal stacking for KLH , Author: Marsel Nakuci
// 6.48 21.05.2025 HSB-24008: Fix: Transformation for KLH mode 1 (truck gride mode) for vertical stacking , Author: Marsel Nakuci
// 6.47 19.05.2025 HSB-24008: Transformation for KLH mode 1 (truck gride mode) for vertical stacking , Author: Marsel Nakuci
// 6.46 19.05.2025 HSB-24008: Transformation for KLH mode 0 (truck mode) fro vertical stacking , Author: Marsel Nakuci
// 6.45 12/05/2025 HSB-24007: Transformation for KLH , Author Marsel Nakuci
// 6.44 24.02.2025 HSB-23527: Save single bodies in an array , Author: Marsel Nakuci
// 6.43 10.02.2025 HSB-23446: KLH: save each grid in separate map for the Combi , Author: Marsel Nakuci
// 6.42 04.02.2025 HSB-23445: Provide weight and cog of combiTruck , Author: Marsel Nakuci
// 6.41 20.01.2025 HSB-23341: For KLH distinguish items generated from CombiTruck from the rest , Author: Marsel Nakuci
// 6.40 09.12.2024 HSB-23131: Write in _Map body, planeprofile, weight and cog  Author: Marsel Nakuci
// 6.39 31.10.2024 HSB-22893: Set dim positions relative to the truck sections , Author Marsel Nakuci
// 6.38 28.10.2024 HSB-22875: Add package dimensions for KLH , Author Marsel Nakuci
// 6.37 07.10.2024 HSB-22771: show text for min weight only when truck is loaded, at least 5000kg. , Author Marsel Nakuci
// 6.36 09/09/2024 HSB-22608: new equation for the min axial weight Marsel Nakuci
// 6.35 05/08/2024 HSB-22499: For KLH show each item in grid Marsel Nakuci
// 6.34 11/07/2024 20240711: Fix when assigning the Bottom/Top panel flag from layers Marsel Nakuci
// 6.33 04/07/2024 HSB-22361: cleanup mapx when not top/bottom plate Marsel Nakuci
// 6.32 02.07.2024 HSB-22320: Write in mapx top/bottom plate at layer Author: Marsel Nakuci
// 6.31 29/04/2024 HSB-21968: Consider the min axl load in the calculation Marsel Nakuci
// 6.30 27.11.2023 HSB-20735: Avoid dublicated instances of "hsbPivotSchedule" Author: Marsel Nakuci
// 6.29 20.11.2023 HSB-20616: create hsbPivotSchedule with weight for each package on "Generate Plot viewport" Author: Marsel Nakuci
// 6.28 12.09.2023 HSB-19939: Apply contour thickness on the inside Author: Marsel Nakuci
// 6.27 05.09.2023 HSB-19937: KLH: Show Weight also if no axle definition found Author: Marsel Nakuci
// 6.26 05.09.2023 HSB-19937: Fix "readOnly" properties Author: Marsel Nakuci
// 6.25 26.07.2023 HSB-19487: Only take the relevant properties when changing the "Stacking" extended properties Author: Marsel Nakuci
// 6.24 10.07.2023 HSB-19483: Apply thickness to the outter contour for Truck and Grid Author: Marsel Nakuci
// 6.23 28.06.2023 HSB-19334: Use "PropertyReadOnly" flag from the xml Author: Marsel Nakuci
// 6.22 27.06.2023 HSB-19334: set properties "ReadOnly" for KLH Author: Marsel Nakuci
// 6.21 12.06.2023 HSB-19191: remove display for KLH Author: Marsel Nakuci
// 6.20 26.05.2023 HSB-18964: Set "BeddingRequested" flag for f_Item Author: Marsel Nakuci
// 6.19 03.05.2023 HSB-18847: Change RowOffset for KLH; It is the distance top to top  Author: Marsel Nakuci
// 6.18 03.05.2023 HSB-18847: Add command "Generate Plot ViewPort" Author: Marsel Nakuci
// 6.17 30.03.2023 HSB-18371: Design "Individuell" will contain multiple axle definitions Author: Marsel Nakuci
// 6.16 23.03.2023 HSB-18371: For KLH get the net weight from the property set Author: Marsel Nakuci
// 6.15 17.03.2023 HSB-18360: fix weight calculation for mass elements Author: Marsel Nakuci
// 6.14 20.02.2023 HSB-18017: fix flag "L" for layer separation in "StackingData" Author: Marsel Nakuci
// 6.13 17.02.2023 HSB-18012: Command add layer separation should be applied to f_Item instances Author: Marsel Nakuci
// 6.12 03.02.2023 HSB-17789: Fix translation for load calculation Author: Marsel Nakuci
// 6.11 22.01.2023 HSB-7512: for KLH: Distribution of loads for each axle Author: Marsel Nakuci
// 6.10 19.01.2023 HSB-7512, HSB-17592: for KLH: Set Properties readOnly; Workaround when hideDisplay fails; Extend options in property Design Author: Marsel Nakuci
// 6.9 11.05.2022 HSB-15456: after projection, remove segments with zero length  Author: Marsel Nakuci
// 6.8 28.04.2022 HSB-15355: fix when writing "StackingData" mapX Author: Marsel Nakuci
/// <version value="6.7" date="24nov2020" author="thorsten.huck@hsbcad.com"> HSB-9858 take II, bugfix stacking data also written to child entities if stacked item is of type element </version>
/// <version value="6.6" date="24nov2020" author="thorsten.huck@hsbcad.com"> HSB-9858 bugfix stacking data also written to child entities if stacked item is of type element </version>
/// <version value="6.5" date="24nov2020" author="thorsten.huck@hsbcad.com"> HSB-9858 bugfix package data </version>
/// <version value="6.4" date="23nov2020" author="thorsten.huck@hsbcad.com"> HSB-9858 new feature settings 'SourceEntity\Propsetname' = 'subMapX' writes stacking data more performant to submapX instead to a property set </version>
/// <version value="6.3" date="20oct2020" author="thorsten.huck@hsbcad.com"> HSB-9303 body combining improved if complex solids (high resolution) are stacked</version>
/// <version value="6.2" date="19oct2020" author="thorsten.huck@hsbcad.com"> HSB-8965 new design 'Package' added to support lorry stacking </version>
/// <version value="6.1" date="16oct2020" author="thorsten.huck@hsbcad.com"> HSB-9292 bugfix layer transformation </version>
/// <version value="6.0" date="23sep2020" author="thorsten.huck@hsbcad.com"> HSB-8915 weight published </version>
/// <version value="5.9" date="18aug2020" author="thorsten.huck@hsbcad.com"> HSB-8560 data for truck packages published </version>
/// <version value="5.8" date="12aug2020" author="thorsten.huck@hsbcad.com"> HSB-8456 center of gravity calculated and 2D projections published </version>
///	<version value="5.7" date="17apr2020" author="thorsten.huck@hsbcad.com"> HSB-5796 grip location to reflect bedding height or vertical alignment fixed </version>
/// <version value="5.6" date="31jan2020" author="thorsten.huck@hsbcad.com"> HSB-6527 Package Wrapping added as property to the default stacking property set. To update existing stackings one need to remove the stacking property set once from each entity</version>
/// <version value="5.5" date="24oct2019" author="thorsten.huck@hsbcad.com"> HSB-5804 bugfix property set definition layer index fixed </version>
/// <version value="5.4" date="04oct2019" author="thorsten.huck@hsbcad.com"> layer stacking calls nester if _LastInserted entry of f_layer is set to any nester </version>
/// <version value="5.3" date="28may2019" author="thorsten.huck@hsbcad.com"> package number validation: requires manual recalc of truck </version>
/// <version value="5.2" date="02apr2019" author="thorsten.huck@hsbcad.com"> truck number bugfix </version>
/// <version value="5.1" date="08mar2019" author="thorsten.huck@hsbcad.com"> package number validation prepared	</version>
/// <version value="5.0" date="07mar2019" author="thorsten.huck@hsbcad.com"> parent UID set to referenced source entity of stacking	</version>
/// <version value="4.9" date="06mar2019" author="thorsten.huck@hsbcad.com"> add item bugfix </version>
/// <version value="4.8" date="07feb2019" author="thorsten.huck@hsbcad.com"> NOTE: do not update existing entities, tag location of containers fixed </version>
/// <version value="4.7" date="07feb2019" author="thorsten.huck@hsbcad.com"> truck number always written (4.5),parent/child naming changed, NOTE: do not update existing entities </version>
/// <version value="4.6" date="13aug2018" author="thorsten.huck@hsbcad.com"> stancions can be deactivated by width / height = 0 </version>
/// <version value="4.5" date="13jul2018" author="thorsten.huck@hsbcad.com"> truck number not written if special contains 'KLH' </version>
/// <version value="4.4" date="22mar2018" author="thorsten.huck@hsbcad.com"> vertical truck alignment fixed</version>
/// <version value="4.3" date="22mar2018" author="thorsten.huck@hsbcad.com"> container alignment fixed, hidden display projected </version>
/// <version value="4.2" date="20mar2018" author="thorsten.huck@hsbcad.com"> export settings enhanced, stacking properties not translated for special=0 </version>
/// <version value="4.1" date="31jan2018" author="thorsten.huck@hsbcad.com"> new property number to identify delivery sequence, optional property set updated </version>
/// <version value="4.0" date="30jan2018" author="thorsten.huck@hsbcad.com"> container stacking enhanced, bugfix of layer grip positioning </version>
/// <version value="3.9" date="11oct2017" author="thorsten.huck@hsbcad.com"> items of type element will export also its genbeams with an exporter call </version>
/// <version value="3.8" date="23aug2017" author="thorsten.huck@hsbcad.com"> packages and property set of source entity supported </version>
/// <version value="3.7" date="04aug2017" author="thorsten.huck@hsbcad.com"> additional row considers oversized layers, remote laayer adding supported </version>
/// <version value="3.6" date="03aug2017" author="thorsten.huck@hsbcad.com"> new context command to create child panels from items </version>
/// <version value="3.5" date="10jul2017" author="thorsten.huck@hsbcad.com"> layer row published to mapX to avoid extrenal casting (f_tag)</version>
/// <version value="3.4" date="06jul2017" author="thorsten.huck@hsbcad.com"> bugfix sequential coloring, type 'Container' shifted to a new property 'Design' which also distinguishes the designs 'open truck' and 'closed truck', head board displays with every grid cell, new display for closed truck, new text display for vertical stackings </version>
/// <version value="3.3" date="28jun2017" author="thorsten.huck@hsbcad.com"> tagging added </version>
/// <version value="3.2" date="27jun2017" author="thorsten.huck@hsbcad.com"> stacked items published to other tsl's </version>
/// <version value="3.1" date="26jun2017" author="thorsten.huck@hsbcad.com"> settings import supports file selection by index </version>
/// <version value="3.0" date="22jun2017" author="thorsten.huck@hsbcad.com"> contact areas are not drawn if new/last row is hidden </version>
/// <version value="2.9" date="26may2017" author="thorsten.huck@hsbcad.com"> new context command to run exporter against exporter group specified in settings file </version>
/// <version value="2.8" date="17may2017" author="thorsten.huck@hsbcad.com"> missing block references do not break script execution </version>
/// <version value="2.7" date="12may2017" author="thorsten.huck@hsbcad.com"> new context command to create bedding grid on horizontal stackings </version>
/// <version value="2.6" date="12may2017" author="thorsten.huck@hsbcad.com"> display of truck height corrected </version>
/// <version value="2.5" date="11may2017" author="thorsten.huck@hsbcad.com"> new context commands to toggle interferences and contact faces, both disabled on default to enhance performance </version>
/// <version value="2.4" date="07apr2017" author="thorsten.huck@hsbcad.com"> dependecies modified to enhance performance </version>
/// <version value="2.3" date="07apr2017" author="thorsten.huck@hsbcad.com"> horizontal stacking: bedding height overrides are stored per row, default values are assigned per index, if index increases last entry is suggested </version>
/// <version value="2.2" date="07apr2017" author="thorsten.huck@hsbcad.com"> horizontal stacking: bugfix location of layer grip </version>
/// <version value="2.1" date="06apr2017" author="thorsten.huck@hsbcad.com"> revised and new dependencies to individual truck grid instances, settings extended </version>
/// <version value="2.0" date="20mar2017" author="thorsten.huck@hsbcad.com"> requires versions equal or higher than hsbCAD 21.0.108 or hsbCAD 22.0.15: new settings (transparency) and truck alignment adjusted </version>
/// <version value="1.9" date="13mar2017" author="thorsten.huck@hsbcad.com"> stancion support with or without transparent block definition, new display and offset parameters </version>
/// <version value="1.8" date="07mar2017" author="thorsten.huck@hsbcad.com"> the previously called term 'Stack' is now called 'Layer'</version>
/// <version value="1.7" date="03mar2017" author="thorsten.huck@hsbcad.com"> vertical stacking enhanced </version>
/// <version value="1.6" date="20feb2017" author="thorsten.huck@hsbcad.com"> bugfixes </version>
/// <version value="1.5" date="15feb2017" author="thorsten.huck@hsbcad.com"> external settings added </version>
/// <version value="1.4" date="13feb2017" author="thorsten.huck@hsbcad.com"> bugfixes </version>
/// <version value="1.3" date="03feb2017" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates a truck and a dynamic stacking grid.
/// Horizontal Stacking displays one column of stacking grids, while vertical stacking
/// shows two columns to differntiate left and right side of the truck.
/// (double click) and the selecting stackable items creates a new stack and may result
/// in an additional row of stacking grids.
/// </summary>//endregion

//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;

	String tDefault =T("|_Default|");
	String tLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};

	String sDialogLibrary = _kPathHsbInstall + "\\Utilities\\DialogService\\TslUtilities.dll";
	String sClass = "TslUtilities.TslDialogService";	
	String listSelectorMethod = "SelectFromList";
	String optionsMethod = "SelectOption";
	String simpleTextMethod = "GetText";
	String askYesNoMethod = "AskYesNo";
	String showNoticeMethod = "ShowNotice";
	String showMultilineNotice = "ShowMultilineNotice";
	String showDynamic = "ShowDynamicDialog";
	
//region Color and view	
	int bIsDark;{int n = getBackgroundTrueColor();bIsDark = ((rgbR(n) + rgbB(n) + rgbG(n)) / 3 < 127);}
	int grey = bIsDark?rgb(199,200,202):rgb(99,100,102);
	int white = bIsDark?rgb(255,255,255):rgb(0,0,0);	
	
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

	Vector3d vecXView = getViewDirection(0);
	Vector3d vecYView = getViewDirection(1);
	Vector3d vecZView = getViewDirection(2);
	double dViewHeight = getViewHeight();	
//endregion 	
	
	String kDataLink = "DataLink", kData="Data",kScript="f_Truck";
	String tDisabled = T("<|Disabled|>");
	//
	String sBlockPath = _kPathHsbCompany + "\\Block";
	// 
	String sTypes[] = { T("|Horizontal|"), T("|Vertical|")};
//end Constants//endregion
	
//region Functions #FU

	//region Global

//region Function Equals
	// returns true if two strings are equal ignoring any case sensitivity
	int Equals(String str1, String str2)
	{ 
		str1 = str1.makeUpper();
		str2 = str2.makeUpper();		
		return str1==str2;
	}//endregion
	
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

//End ArrayToMapFunctions //endregion 	 	
			
	//endregion 

	//region Collectionws

//region Function CollectPlotViewPorts
	// returns the plotviewports out of the entity array, if layoutname is given only plotviewports with matching layoutname are returned
	PlotViewport[] CollectPlotViewports(Entity ents[], String optLayoutName)
	{ 
		PlotViewport pvs[0];
		for (int i=0;i<ents.length();i++) 
		{ 
			PlotViewport pv= (PlotViewport)ents[i]; 
			if (pv.bIsValid() && pvs.find(pv)<0)
			{
				String layoutName = pv.layout();
				if (optLayoutName=="" || Equals(layoutName,optLayoutName))
					pvs.append(pv);
			}
			 
		}//next i
		
		return pvs;
	}//endregion

	//endregion 

	//region Miscelaaneous

//region visPp
//
	void visPp(PlaneProfile _pp,Vector3d _vec)		
	{ 
		_pp.transformBy(_vec);
		_pp.vis(6);
		_pp.transformBy(-_vec);
		return;
	}
//endregion//visPp

//region isCombiItem
// returns whether an item is
// derived from klhCombiTruck
	int isCombiItem(TslInst _item)
	{ 
		int _bIsCombiItem;
		
		if(!_item.bIsValid())
		{ 
			return _bIsCombiItem;
		}
		if(_item.scriptName()!="f_Item")
		{ 
			return _bIsCombiItem;
		}
		Entity _ents[]=_item.entity();
		if(_ents.length()<1)
		{ 
			return _bIsCombiItem;
		}
		TslInst _tsl=(TslInst)_ents[0];
		if(!_tsl.bIsValid())
		{ 
			return _bIsCombiItem;
		}
		
		if(_tsl.scriptName()=="klhCombiTruck")
		{ 
			_bIsCombiItem=true;
			return _bIsCombiItem;
		}
		
		return _bIsCombiItem;
	}
//endregion//isCombiItem

//region visBd
//		
	void visBd(Body _bd, Vector3d _vec)
	{ 
		_bd.transformBy(_vec);
		_bd.vis(6);
		_bd.transformBy(-_vec);
		return;
	}
//endregion//visBd


//region getMapForDesign
// From a list of maps in _mIn
// returns the map that corresponds to the design _sDesign
	Map getMapForDesign(Map _mIn, String _sDesign,
		int _nType,String _sTruck)
	{ 
		Map _mOut;
		
		int bMapFound;
		String sDesignCap=_sDesign;
		for (int im=0;im<_mIn.length();im++) 
		{ 
			Map mapI=_mIn.getMap(im);
			String sDesignMap=mapI.getString("Design");
			sDesignMap.trimLeft();
			sDesignMap.trimRight();
			String sDesignMaps[]=sDesignMap.tokenize(";");
			for (int is=0;is<sDesignMaps.length();is++) 
			{ 
				String sDesignMapI= sDesignMaps[is]; 
				sDesignMapI.trimLeft();
				sDesignMapI.trimRight();
				// HSB-17789
				sDesignMapI=T("|"+sDesignMapI+"|");
				sDesignMapI.makeUpper();
				if(sDesignMapI==sDesignCap.makeUpper())
				{ 
					// design was found
					if(mapI.hasString("Type"))
					{ 
						// HSB-24432: Fix translation
						if(T("|"+mapI.getString("Type")+"|")==sTypes[_nType])
						{ 
							// HSB-24277
							_mOut=mapI;
							bMapFound=true;
							break;
						}
					}
					else
					{ 
						_mOut=mapI;
						bMapFound=true;
						break;
					}
				}
			}//next is 
			if (bMapFound)break;
		}//next im
		// HSB-24277
		if(_mOut.hasMap("Subdesign[]"))
		{ 
			Map mapSubdesign;
			int bSubdesignFound;
			Map mapSubDesigns=_mOut.getMap("Subdesign[]");
			for (int i=0;i<mapSubDesigns.length();i++) 
			{ 
				Map mi=mapSubDesigns.getMap(i);
				if(mi.getString("Name")==_sTruck)
				{ 
					mapSubdesign=mi;
					bSubdesignFound=true;
				}
			}//next i
			if(bSubdesignFound)
			{ 
				_mOut=mapSubdesign;
			}
		}
		
		return _mOut;
	}
//End getMapForDesign//endregion
//endregion 

//End Functions #FU//endregion 



//region JIG
	
// Jig Insert
	String kJigPV = "JigPlotViewPort";
	if (_bOnJig && _kExecuteKey==kJigPV) 
	{
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point		
		Point3d ptRef = _Map.getPoint3d("ptRef");
	    
	    PlaneProfile pps[]= GetPlaneProfileArray(_Map);
		if (pps.length()>0)
			ptJig.setZ(pps[0].coordSys().ptOrg().Z());
  
	    Display dp(-1);
	    dp.trueColor(lightblue, 80);

		Vector3d vecMove = ptJig-ptRef;

	    for (int i=0;i<pps.length();i++)
	    { 
	    	PlaneProfile pp=pps[i];
	    	//pp.transformBy(vecMove);
	    	dp.trueColor(lightblue,50);
	    	dp.draw(pp, _kDrawFilled);

			pp.transformBy(vecMove);
	    	dp.trueColor(darkyellow,0);
	    	dp.draw(pp,_kDrawFilled,50);
	    	dp.draw(pp);
	    	
//	    	PLine pl(pp.coordSys().ptOrg(), _PtW, _Pt0);
//	    	dp.draw(pl);
	    }
	    
	    
	    return;
	}
//endregion 	
	
//endregion 

//region truck constants 
	int nStartTick;
	if (bDebug)nStartTick=getTickCount();
	
// get special
	String sSpecials[]={"KLH"};
	int nSpecial;
	for (int i=0;i<sSpecials.length();i++) 
	{ 
		if (projectSpecial().find(sSpecials[i],0)>-1)
		{
			nSpecial=i;
			break; 
		} 
	}
	
// stacking family key words
	String sItemX="Hsb_Item";
	String sItemParent="Hsb_ItemParent";
	String sTruckKey="Hsb_TruckParent";
	String sGridKey="Hsb_GridParent";
	String sLayerX="Hsb_LayerParent";
	String sPropsetName="Stacking";
	String sPropsetProperties[]={"Number","Name","Type","Design","Layer Index","Package Number","Package Wrapping"};
	int nPropsetPropertyTypes[]={1,0,0,0,1,1,0};// 0 = string, 1 = int, 2 = double
	int bStoreInSubmap; // flag if stacking data will be stored as submapx or as property set with the source entity
	
// translate property names. note this could cause issues when using alternating languages	
	if (nSpecial<0)
		for (int i=0;i<sPropsetProperties.length();i++) 
			sPropsetProperties[i] = T("|"+sPropsetProperties[i]+"|"); 
	
	String sScriptLayer = "f_Layer"; // creating instances by double click action
	String sScriptItem = "f_Item"; // creating instances by double click action
	String sNesterTypes[] = { T("|Disabled|"), T("|Autonester|"), T("|Rectangular Nester|")};
	
	String sLengthName=T("|Length|");	String sLengthDesc = T("|Defines the Length|");
	String sWidthName=T("|Width|");		String sWidthDesc = T("|Defines the Width|");	
	String sHeightName=T("|Height|");	String sHeightDesc = T("|Defines the Height|");
	String sTruckName=T("|Name|");		String sTruckDesc = T("|Defines the name of the truck|");
	String sTypeName=T("|Type|");		String sTypeDesc = T("|Defines the type of the stacking|");
	String sDesignName=T("|Design|");	String sDesignDesc = T("|Defines the design of the truck|");
	String sNumberName = T("|Number|");	String sNumberDesc = T("|Defines the number of the delivery.|") + T(" |0 = automatic numbering|");
//	
//String sConfigName=T("|Configuration|");		String sConfigDesc = T("|Defines the configuration file of of this project|");
//	String sConfigDefault = T("|Default|");
//	String sTypes[] = { T("|Horizontal|"), T("|Vertical|")};
	String sDesigns[] = { T("|Open Truck|"), T("|Closed Truck|"), T("|Container|"), T("|Package|")};
	String sDesignKeys[] = { "LayoutOpen","LayoutClosed","LayoutContainer"};// should be of same length as sDesigns, key is used to identify layouts
	String sProjectSpecial=projectSpecial();
	sProjectSpecial.makeUpper();
// HSB-7512:
	int bIsKlh=sProjectSpecial=="KLH";
	if(bIsKlh)
	{ 
	// HSB-18371:
//		sDesigns.append("WAB-trailer");
		sDesigns.append("Laaprs woodrailer");
		sDesigns.append("Individuell");
	}
	// grid
	int nColorTruck = 252;
	int nColorGrid = 250;
	String sLineType = "Dashed";
	double dLineTypeScale = U(10);
	double dRowOffsetTruck = U(500);
	double dRowOffset = U(1000);
	double dColumnOffset = U(1000);
	// HSB-19483 map containing contour properties like thickness
	Map mapContour;
	Map mapContourGrid;
	Map mapContourItem;
	
	//LayerContact
	int nColorContact = 76; // the color of the contact face of the previous grid row
	Hatch hatchContact("ANSI31", U(40));
	int nTransparencyContact=80;
	String sLineTypeContact = "CONTINUOUS";
	double dLineTypeScaleContact = U(1);
	
	//LayerInterference
	int nColorInterfere = 242; 	
	int nTransparencyInterfere=50;	
	String sLineTypeInterfere = "CONTINUOUS";
	double dLineTypeScaleInterfere = U(1);
	
	//LayerShadow
	int nColorShadow = 78; // the stack shadow displays the cummulated shadow of all previous rows	
	int nTransparencyShadow=100;
	String sLineTypeShadow = "DOTS";
	double dLineTypeScaleShadow = U(1);
	
	//Design
	int nColorDesign = 242; 	
	int nTransparencyDesign=50;	
	String sLineTypeDesign = "CONTINUOUS";
	double dLineTypeScaleDesign = U(1);
	double dDimOffsetDesign = U(100);
	double dTextHeightDesign = U(100);
	double dSymbolOffsetDesign;
	String sDimStyleDesign, sTextDesign;
	
	// head board
	int nColorHeadBoard = 6; // the head board is used to display the front of the truck. it can be displayed in all rows or only in one specific row
	int nTransparencyHeadBoard = 0;
	String sLineTypeHeadBoard = "CONTINUOUS";
	double dLineTypeScaleHeadBoard = U(1);	
	double dThicknessHeadBoard = U(100);
	int nRowHeadBoard = 1;
	
	// stancion	
	double dStancionWidth = U(400);
	double dStancionHeight = U(2000);//dHeight>U(2000)?U(2000):dHeight*.8;
	int nColorStancion = 40;
	double dTxtH = U(70);
	int nTransparencyStancion=70;
	
	int nSeqColors[0];
	
	double dBeddingHeights[0];
	Map mapStancions, mapDesigns, mapDesign, mapVerticalType;
	Map mapLayouts, mapLayout, mapLayoutGrid;
	Map mapExporterGroups;
	
	double dBG_EdgeOffset;
	String sScriptBeddingGrid = "f_Grid";
	
	String sWeightProperty;// the path to the property of which the weight value should be taken
	
	// 
	Map mapAxleDefinitions,mapFrontDistances;
//endregion
	
//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sFileName ="f_Stacking";
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
	int nPropertyReadOnly=mapSetting.getInt("PropertyReadOnly");
//End Settings//endregion
	
//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) {eraseInstance(); return;}
		
	// properties//region
		category = T("|Geometry|");
		PropDouble dLength(nDoubleIndex++, U(13600), sLengthName);
		dLength.setDescription(sLengthDesc);
		dLength.setCategory(category);
		
		PropDouble dWidth(nDoubleIndex++, U(2500), sWidthName);
		dWidth.setDescription(sWidthDesc);
		dWidth.setCategory(category);
		
		PropDouble dHeight(nDoubleIndex++, U(2700), sHeightName);
		dHeight.setDescription(sHeightDesc);
		dHeight.setCategory(category);
		
	// truck ID
		category=T("|Truck|");
		
		PropInt nNumber(nIntIndex++, 0, sNumberName);
		nNumber.setDescription(sNumberDesc);
		nNumber.setCategory(category);
		
		PropString sTruck(nStringIndex++, "Truck 1", sTruckName);
		sTruck.setDescription(sTruckDesc);
		sTruck.setCategory(category);
		
		PropString sType(nStringIndex++, sTypes, sTypeName);
		sType.setDescription(sTypeDesc);
		sType.setCategory(category);
		
		PropString sDesign(nStringIndex++, sDesigns, sDesignName);
		sDesign.setDescription(sDesignDesc);
		sDesign.setCategory(category);
		// HSB-19334
		if(bIsKlh || nPropertyReadOnly)
		{ 
		// HSB-19334: set properties as readOnly
			dLength.setReadOnly(_kReadOnly);
			dWidth.setReadOnly(_kReadOnly);
			dHeight.setReadOnly(_kReadOnly);
			sTruck.setReadOnly(_kReadOnly);
			sType.setReadOnly(_kReadOnly);
			sDesign.setReadOnly(_kReadOnly);
			_Map.setInt("readOnly",true);
		}
		
//	// get config
//	// prompt if multiple settings files are found and no mapObject found
//		String sDictEntry = sDictEntries[0];
//		String sConfigs[0];
//		MapObject mo(sDictionary ,sDictEntry);
//		if (!mo.bIsValid()) 
//			sConfigs =getFilesInFolder(sSettingsPath, sDictEntry +"*.xml");	
//		PropString sConfig(nStringIndex++, sConfigs, sConfigName);	
//		sConfig.setDescription(sConfigDesc);
//		sConfig.setCategory(category);		
//		if (sConfigs.find(sConfig)<0)
//		{ 
//			sConfig.set(sConfigDefault);
//			sConfig.setReadOnly(true);
//		}
	//endregion
		
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
				setPropValuesFromCatalog(T("|_LastInserted|"));
		}
		else
			showDialog();
		
		_Pt0 = getPoint();
		
		return;
	}
//End bOnInsert__________________	//endregion 

//region Read Settings
// settings are stored in external files but they are only updated upon request or if no settings are found in the dictionary of the dwg
	if (mapSetting.length()>0)
	{
	// TRUCK
		Map m = mapSetting.getMap("Truck");
		String k;
	// general
		k="Color";				if (m.hasInt(k))	nColorTruck = m.getInt(k);
		k="TextHeight";			if (m.hasDouble(k))	dTxtH = m.getDouble(k);
		k="RowOffsetTruck";		if (m.hasDouble(k))	dRowOffsetTruck = m.getDouble(k);
		// HSB-19483
		k="Contour"; if (m.hasMap(k)) mapContour=m.getMap(k);
		
		mapContourItem=mapSetting.getMap("Item\\Contour");
		
	// grid
		Map g = m.getMap("Grid");
		k="Color";				if (g.hasInt(k))	nColorGrid = g.getInt(k);
		k="Linetype";			if (g.hasString(k))	sLineType = g.getString(k);		
		k="LinetypeScale";		if (g.hasDouble(k))	dLineTypeScale = g.getDouble(k);	
		k="RowOffset";			if (g.hasDouble(k))	dRowOffset = g.getDouble(k);	
		k="ColumnOffset";		if (g.hasDouble(k))	dColumnOffset = g.getDouble(k);	
		// HSB-19483
		k="Contour"; if (g.hasMap(k)) mapContourGrid=g.getMap(k);
		
	//LayerContact
		g = m.getMap("LayerContact");
		k="Color";				if (g.hasInt(k))	nColorContact = g.getInt(k);
		k="Linetype";			if (g.hasString(k))	sLineTypeContact = g.getString(k);		
		k="LinetypeScale";		if (g.hasDouble(k))	dLineTypeScaleContact = g.getDouble(k);	
		k="Transparency";			if (g.hasInt(k))	nTransparencyContact = g.getInt(k);	
		
	//LayerInterference
		g = m.getMap("LayerInterference");
		k="Color";				if (g.hasInt(k))	nColorInterfere = g.getInt(k);
		k="Linetype";			if (g.hasString(k))	sLineTypeInterfere = g.getString(k);		
		k="LinetypeScale";		if (g.hasDouble(k))	dLineTypeScaleInterfere = g.getDouble(k);	
		k="Transparency";		if (g.hasInt(k))	nTransparencyInterfere = g.getInt(k);
		
	//LayerShadow
		g = m.getMap("LayerShadow");
		k="Color";				if (g.hasInt(k))	nColorShadow = g.getInt(k);
		k="Linetype";			if (g.hasString(k))	sLineTypeShadow = g.getString(k);		
		k="LinetypeScale";		if (g.hasDouble(k))	dLineTypeScaleShadow = g.getDouble(k);	
		k="Transparency";			if (g.hasInt(k))	nTransparencyShadow = g.getInt(k);
		
	//HeadBoard
		g = m.getMap("HeadBoard");
		k="Color";				if (g.hasInt(k))	nColorHeadBoard = g.getInt(k);
		k="Linetype";			if (g.hasString(k))	sLineTypeHeadBoard = g.getString(k);		
		k="LinetypeScale";		if (g.hasDouble(k))	dLineTypeScaleHeadBoard = g.getDouble(k);	
		k="Transparency";		if (g.hasInt(k))	nTransparencyHeadBoard = g.getInt(k);	
		k="Thickness";			if (g.hasDouble(k))	dThicknessHeadBoard = g.getDouble(k);
		k="Row";				if (g.hasInt(k))	nRowHeadBoard = g.getInt(k);	
		
	// stancions
		mapStancions = m.getMap("Stancion[]");
		g=mapStancions;
		k="Width";				if (g.hasDouble(k))	dStancionWidth = g.getDouble(k);
		k="Height";				if (g.hasDouble(k))	dStancionHeight = g.getDouble(k);		
		k="Color";				if (g.hasInt(k))	nColorStancion = g.getInt(k);
		k="Transparency";		if (g.hasInt(k))	nTransparencyStancion = g.getInt(k);	
		
	// bedding grid
		g = m.getMap("BeddingGrid");
		k="EdgeOffset";				if (g.hasDouble(k))	dBG_EdgeOffset = g.getDouble(k);
		
	// designs
		mapDesigns = m.getMap("Design[]");	
		
	// sequential colors
		// these colors are used to replace the index colors by the given value.
		Map mapColors = m.getMap("SequentialColor[]");		
		for (int i=0;i<mapColors.length();i++) 
		{ 
			nSeqColors.append(mapColors.getInt(i)); 
		}
		
	// vertical type properties
		mapVerticalType = m.getMap("VerticalType");
		
	// Layouts
		mapLayouts = m.getMap("Layout[]");
		
	// get bedding heights of layer
		g = mapSetting.getMap("Layer").getMap("Bedding[]");	
		for (int i=0;i<g.length();i++) 
			dBeddingHeights.append(g.getDouble(i)); 
		
		mapExporterGroups = m.getMap("ExporterGroup[]");	
		
	// weight property path 
		sWeightProperty = m.getString("WeightProperty");
		
	// get propertyset name
		m = mapSetting.getMap("SourceEntity");
		k="PropsetName";		if (m.hasString(k))	sPropsetName= m.getString(k);
		bStoreInSubmap = sPropsetName.find("subMapX", 0, false) >- 1; // HSB-9858
	// get axle loads
		mapAxleDefinitions=mapSetting.getMap("Truck\\AxleLoadCalculation[]");
	// HSB-24206: get front display in truck grid
		mapFrontDistances=mapSetting.getMap("Truck\\FrontDistance[]");
	}
// create default settings map and mapObject 
	else if (!mo.bIsValid())
	{ 
		String k;
		Map m;

	// general
		k="Color";				m.setInt(k,nColorTruck);
		k="TextHeight";			m.setDouble(k,dTxtH);
		k="RowOffsetTruck";		m.setDouble(k,dRowOffsetTruck);
		mapSetting.appendMap("Truck", m);
		
	// grid
		m = Map();
		k="Color";				m.setInt(k,nColorGrid);
		k="Linetype";			m.setString(k,sLineType);
		k="LinetypeScale";		m.setDouble(k,dLineTypeScale);
		k="RowOffset";			m.setDouble(k,dRowOffset);
		k="ColumnOffset";		m.setDouble(k,dColumnOffset);
		mapSetting.appendMap("Grid", m);
		
	// LayerContact
		m = Map();
		k="Color";				m.setInt(k,nColorContact);
		k="Linetype";			m.setString(k,sLineTypeContact);
		k="LinetypeScale";		m.setDouble(k,dLineTypeScaleContact);
		k="Transparency";		m.setInt(k,nTransparencyContact);
		mapSetting.appendMap("LayerContact", m);

	// LayerInterference
		m = Map();
		k="Color";				m.setInt(k,nColorInterfere);
		k="Linetype";			m.setString(k,sLineTypeInterfere);
		k="LinetypeScale";		m.setDouble(k,dLineTypeScaleInterfere);
		k="Transparency";		m.setInt(k,nTransparencyInterfere);
		mapSetting.appendMap("LayerInterference", m);

	// LayerShadow
		m = Map();
		k="Color";				m.setInt(k,nColorShadow);
		k="Linetype";			m.setString(k,sLineTypeShadow);
		k="LinetypeScale";		m.setDouble(k,dLineTypeScaleShadow);
		k="Transparency";		m.setInt(k,nTransparencyShadow);
		mapSetting.appendMap("LayerShadow", m);
		
	//HeadBoard
		m = Map();
		k="Color";				m.setInt(k,nColorHeadBoard);
		k="Linetype";			m.setString(k,sLineTypeHeadBoard);
		k="LinetypeScale";		m.setDouble(k,dLineTypeScaleHeadBoard);
		k="Transparency";		m.setInt(k,nTransparencyHeadBoard);
		k="Thickness";			m.setDouble(k,dThicknessHeadBoard);
		k="Row";				m.setInt(k,nRowHeadBoard);
		mapSetting.appendMap("HeadBoard", m);		

	//stancions
		m = Map();
		k="Width";				m.setDouble(k,dStancionWidth);
		k="Height";				m.setDouble(k,dStancionHeight);
		k="Color";				m.setInt(k,nColorStancion);
		k="Transparency";		m.setInt(k,nTransparencyStancion);
		mapSetting.appendMap("Stancion[]", m);

	//bedding grid
		m = Map();
		k="EdgeOffset";			m.setDouble(k,dBG_EdgeOffset);
		mapSetting.appendMap("BeddingGrid", m);
	
	// designs
	// sequential colors
		m = Map();
		int _nSeqColors[] ={14,144,94,134,174,214,24,64,104,154};
		for (int i=0;i<_nSeqColors.length();i++) 
			m.appendInt(i+1,_nSeqColors[i]); 
		mapSetting.appendMap("SequentialColor[]", m);

	//BeddingHeight
		m = Map();
		k="Bedding";			m.appendDouble(k,U(80));
		k="Bedding";			m.appendDouble(k,U(30));
		Map mapBeddings;
		mapBeddings.setMap("Bedding[]",m);
		mapSetting.appendMap("Layer", mapBeddings);		

		mo.dbCreate(mapSetting);
	}	
//endregion
	String sWeightPropertyTokens[]=sWeightProperty.tokenize(".");
//region Standards
// get mode
	int nMode=_Map.getInt("mode");
	// 0 = truck
	// 1 = grid

// set myUID
	String sMyUID = _ThisInst.handle();
	_ThisInst.setDrawOrderToFront(false);

// coordSys	
	Vector3d vecX=_XW, vecY=_YW, vecZ=_ZW;
	_XE=vecX; 	_YE=vecY;	_ZE=vecZ; // do not allow any rotation on a truck
	_Pt0.setZ(0);
	_XE.vis(_Pt0,1);	_YE.vis(_Pt0,3);	_ZE.vis(_Pt0,150);
	
	
	
	
	CoordSys csW(_Pt0, vecX,vecY,vecZ);
	Plane pnZ(_PtW,vecZ);

	Line lnX(_Pt0,vecX);
	Line lnY(_Pt0,vecY);
	PLine pl(vecZ);
	
// Displays
	Display dpTruck(nColorTruck), dpGrid(nColorGrid), dpContact(nColorContact), dpSide(250), dpShadow(nColorShadow), dpLayer(-1), 
	dpInterfere(nColorInterfere), dpStancion(nColorStancion), dpLoad(20);
	dpTruck.textHeight(dTxtH);
	dpGrid.lineType(sLineType, dLineTypeScale);
	dpGrid.textHeight(dTxtH);
	dpLoad.textHeight(dTxtH);
	dpContact.lineType(sLineTypeContact, dLineTypeScaleContact);
	dpShadow.lineType(sLineTypeShadow, dLineTypeScaleShadow);
	dpInterfere.lineType(sLineTypeInterfere, dLineTypeScaleInterfere);	
	
	if (bDebug)	dpTruck.draw(sMyUID,_Pt0, vecX, vecY,1,0);
	
	Display dpLayerSeparation(6);
	dpLayerSeparation.textHeight(dTxtH);
//End Standards//endregion 
//End Part 1//endregion 
	
//region Truck mode
	int nPackageWrapped;
	int nApplyLayerSeparation;
	if (nMode==0)
	{
		_Map.setInt("isTruck", true);
		
	//region //properties #PR
		category = T("|Geometry|");
		PropDouble dLength(nDoubleIndex++, U(13600), sLengthName);	
		dLength.setDescription(sLengthDesc);
		dLength.setCategory(category);	
		
		PropDouble dWidth(nDoubleIndex++, U(2500), sWidthName);
		dWidth.setDescription(sWidthDesc);
		dWidth.setCategory(category);
					
		PropDouble dHeight(nDoubleIndex++, U(2700), sHeightName);	
		dHeight.setDescription(sHeightDesc);
		dHeight.setCategory(category);
		
	// truck ID
		category=T("|Truck|");	
		
		PropInt nNumber(nIntIndex++, 0, sNumberName);	
		nNumber.setDescription(sNumberDesc);
		nNumber.setCategory(category);	
		
		PropString sTruck(nStringIndex++, "Truck 1", sTruckName);	
		sTruck.setDescription(sTruckDesc);
		sTruck.setCategory(category);
		
		PropString sType(nStringIndex++, sTypes, sTypeName);	
		sType.setDescription(sTypeDesc);
		sType.setCategory(category);
		sType.setReadOnly(true); // only during creation
		
		PropString sDesign(nStringIndex++, sDesigns, sDesignName);	
		sDesign.setDescription(sDesignDesc);
		sDesign.setCategory(category);	
		
		String sKeyPlotViews = _ThisInst.formatObject("@("+sDesignName+")_@("+sTypeName+")_L@("+sLengthName+":RL0)_W@("+sWidthName+":RL0)_H@("+sHeightName+":RL0)");

		//endregion
		
	// get type of truck loading: horizontal,vertical or Sea-Container
		int nType = sTypes.find(sType,0);
		_Map.setInt("type", nType);// publish for layers
		
//		Map mapAxleDefinitions=mapSetting.getMap("Truck\\AxleLoadCalculation[]");
		
	//region HSB-24007 KLH

		Point3d _pt0=_Pt0;
		int bKLHvertTransform;
		CoordSys csKLHvertRot;
		if(bIsKlh)
		{ 
			// transformation for KLH
			CoordSys csKLH;
			csKLH.setToAlignCoordSys(_Pt0,vecX,vecY,vecZ,
				_Pt0+vecX*(dWidth+dColumnOffset+dLength),-vecX,vecY,-vecZ);
			
			_pt0.transformBy(csKLH);
			vecX.transformBy(csKLH);
			vecY.transformBy(csKLH);
			vecZ.transformBy(csKLH);
			
			bKLHvertTransform= nType==1;
			
			if(bKLHvertTransform)
			{ 
				csKLHvertRot.setToTranslation(_XW*(dLength+2*U(2200)));
			}
			
			if(nPropertyReadOnly)
			{ 
			// HSB-7512; HSB-19334:
	//			int nReadOnly=!_Map.getInt("readOnly");
				// HSB-19937
				int nReadOnly=_Map.getInt("readOnly");
				if(nReadOnly)
				{ 
					dLength.setReadOnly(_kReadOnly);
					dWidth.setReadOnly(_kReadOnly);
					dHeight.setReadOnly(_kReadOnly);
					
					sType.setReadOnly(_kReadOnly);
					sDesign.setReadOnly(_kReadOnly);
				}
				else
				{ 
					dLength.setReadOnly(false);
					dWidth.setReadOnly(false);
					dHeight.setReadOnly(false);
					
					sType.setReadOnly(false);
					sDesign.setReadOnly(false);
				}
			// trigger to unblock/block
			//region Trigger blockProperties
				String sTriggerblockProperties = T("|Unblock Properties|");
				if(!nReadOnly)
					sTriggerblockProperties = T("|Block Properties|");
				addRecalcTrigger(_kContextRoot, sTriggerblockProperties);
				if (_bOnRecalc && _kExecuteKey==sTriggerblockProperties)
				{
					// HSB-19937
					_Map.setInt("readOnly",!nReadOnly);
					setExecutionLoops(2);
					return;
				}//endregion
			}
			if(nType==0)
			{ 
			// layer separation should only be allowed for horizontal stacking
			//region Trigger applyLayerSeparation
				String sTriggerapplyLayerSeparation=T("|Apply Layer Separation|");
				String sTriggerdontApplyLayerSeparation=T("|Don't Apply Layer Separation|");
				addRecalcTrigger(_kContextRoot,sTriggerapplyLayerSeparation);
				addRecalcTrigger(_kContextRoot,sTriggerdontApplyLayerSeparation);
				if (_bOnRecalc && (_kExecuteKey==sTriggerapplyLayerSeparation
					|| _kExecuteKey==sTriggerdontApplyLayerSeparation))
				{
					
				// prompt f_Item selection
				// prompt for tsls
					Entity entsItem[0];
					PrEntity ssE(T("|Select f_Item tsls|"), TslInst());
				  	if (ssE.go())
						entsItem.append(ssE.set());
					
				// loop tsls
//					String sLayerTxt="Lagentrennung\PLayer seperation\P";
					TslInst tslItems[0];
					for (int i=entsItem.length()-1; i>=0 ; i--) 
					{ 
						TslInst tsl=(TslInst)entsItem[i];
						if (tsl.bIsValid() && tsl.scriptName()=="f_Item")
						{ 
//							String sPropOverride=tsl.propString(2);
//							String sPropOverrideNew;
							Map mapTSl=tsl.map();
							if(_kExecuteKey==sTriggerapplyLayerSeparation)
							{ 
//								sPropOverrideNew=sLayerTxt+sPropOverride;
//								int nFirst=sPropOverride.find(sLayerTxt,-1,false);
//								if(nFirst>-1)
//								{ 
//									sPropOverrideNew=sPropOverride;
//								}
								// HSB-18964: set te flag for f_item
								mapTSl.setInt("BeddingRequested",true);
							}
							else
							{ 
//								int nFirst=sPropOverride.find(sLayerTxt,-1,false);
//								sPropOverrideNew=sPropOverride;
//								if(nFirst>-1)
//								{ 
//									sPropOverrideNew=sPropOverride;
//									sPropOverrideNew.delete(nFirst,sLayerTxt.length());
//								}
								// HSB-18964: set te flag for f_item
								mapTSl.setInt("BeddingRequested",false);
							}
							tsl.setMap(mapTSl);
							tsl.recalcNow();
//							tsl.setPropString(2,sPropOverrideNew);
							tslItems.append(tsl);
						}
					}
					
					_Map.setInt("LayerTriggered",1);
					setExecutionLoops(2);
					return;
				}//endregion
			}
			
			// HSB-19191: 
			if(_bOnDbCreated)
			{ 
			// on creation insert klhStackMatrix
			// create TSL
				TslInst tslNew;	Vector3d vecXTsl=_XW; Vector3d vecYTsl=_YW;
				GenBeam gbsTsl[]={}; 
				Entity entsTsl[]={_ThisInst}; 
				Point3d ptsTsl[]={_Pt0};
				int nProps[]={}; double dProps[]={}; String sProps[]={};
				Map mapTsl;
				
				tslNew.dbCreate("klhStackMatrix",vecXTsl,vecYTsl,gbsTsl,entsTsl,
					ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);
			}
		}//endregion 		
	
	//region Nesting and Layout data
	
	// set mapX
		Map m;
		m.setString("MyUid",sMyUID);
		m.setPoint3d("ptOrg",_Pt0,_kRelative);
		m.setVector3d("vecX",vecX*dLength,_kScalable); // coordsys could carry size
		m.setVector3d("vecY",vecY*dWidth,_kScalable);
		m.setVector3d("vecZ",vecZ*dHeight,_kScalable);
		m.setDouble("dOneUnit",1); // add the lenght of 1 inch,mm,m whatever units the drawing is in, to allow to make the vecX, vecY and vecZ unitless 
		_ThisInst.setSubMapX("Hsb_TruckParent",m);
		
	// Layout by design (block definition) 
		int nDesign = sDesigns.find(sDesign,0);
	
		for (int i=0;i<mapLayouts.length();i++) 
		{ 
			Map m = mapLayouts.getMap(i);
			int _type = m.hasInt("type")?m.getInt("type"):-1;
			int _design = m.hasInt("design")?m.getInt("design"):-1; 
			
			if (_type>-1 && _type!=nType){ continue;}
			if (_design>-1 && _design!=nDesign){ continue;}
			
			mapLayout=m;
			break;// take first appearance
		}
		
	// get design map
		Map mapDesign;
		for (int i=0;i<mapDesigns.length();i++) 
		{ 
			Map m= mapDesigns.getMap(i); 
			String name = m.getString("Name");
			name.makeLower();
			if (name=="Closed Truck".makeLower() && nDesign==1)
				mapDesign = m;	 
			else if (name=="Container".makeLower() && nDesign==2)
				mapDesign = m;	 
			else if (name=="Package".makeLower() && nDesign==3)
				mapDesign = m;	
		}
					
	//endregion 

	//region truck numbering
		int bSetNumber = nNumber <= 0 || _bOnDbCreated || _kNameLastChangedProp==sNumberName || bDebug;
		_Map.setInt("PrevNumber", nNumber);
		if (bSetNumber)
		{ 
		//collect numbers of all trucks in dwg
			Entity ents[] = Group().collectEntities(true, TslInst(), _kModelSpace);
			int nNumbers[0];
			for (int i=ents.length()-1; i>=0 ; i--) 
			{ 
				if (ents[i].subMapXKeys().find("Hsb_TruckParent")<0 || ents[i]==_ThisInst)
				{
					ents.removeAt(i);
					continue;
				}
				TslInst t = (TslInst)ents[i];
				if (t.bIsValid() && ((!bDebug && t.scriptName()==scriptName()) || (bDebug && t.scriptName()=="f_Truck")))
					nNumbers.append(((TslInst)ents[i]).propInt(0));
			}
		
		// order ascending
			for (int i=0;i<nNumbers.length();i++)
				for (int j=0;j<nNumbers.length()-1;j++)
					if (nNumbers[j]>nNumbers[j+1])
						nNumbers.swap(j,j+1);	
			
		// get next free number
			int nFreeNumber = nNumber<1?1:nNumber;
			for (int i=0;i<nNumbers.length();i++) 
				if (nNumbers[i]==nFreeNumber)
					nFreeNumber++; 

		// set number if in auto mode
			if (nNumber <= 0)
			{
				reportMessage("\n" + _ThisInst.handle() + " automatic numbered to " + nFreeNumber);
				nNumber.set(nFreeNumber);
			}
			
		// on creation or renumbering validate new number request
			else if(_bOnDbCreated || _kNameLastChangedProp==sNumberName)// || bDebug)
			{ 
				if (nNumber!=nFreeNumber)
				{ 
					reportMessage("\n" + T("|Number| ")+ nFreeNumber + T(" |used instead of occupied number| ") + nNumber);
					nNumber.set(nFreeNumber);
				}

			}
			_Map.setInt("PrevNumber", nNumber);
		}
					
	//endregion 

	// set cell width and height based on truck type
		double dCellHeight = nType==0?dWidth:dHeight;
		double dVisibleHeight= nType==0?dHeight:dWidth;
	
	//HSB-18847: Change RowOffset for KLH; it is the distance top to top
		if(bIsKlh)
		{ 
			dRowOffset=dRowOffset-dCellHeight;
		}
		
	// ref point of truck 
		Point3d ptTruck = _pt0 + vecX*(dWidth+dColumnOffset);
		Point3d ptSectionRef;
		//Point3d ptSectionRef =
		//nType==0?_pt0+vecX*.5*(dWidth)
		//:_pt0+vecX*.5*(dWidth+dColumnOffset+dLength);
		if (nType==0 && nDesign!=3)
		{
			ptSectionRef=_pt0+vecX*.5*(dWidth);
			ptSectionRef.vis(1);
		}
		else if (nDesign==3)
		{
			ptSectionRef=_pt0;
			ptSectionRef.vis(2);
		}
		else
		{
			ptSectionRef=_pt0+vecX*.5*(dWidth+dColumnOffset+dLength);
			ptSectionRef.vis(4);
		}
		
		//ptSectionRef.vis(2);
	
	// create grids in dependency of selected type
		if (_bOnDbCreated)
		{
			//_ThisInst.transformBy(Vector3d(0,0,0));
			int nColumns = (nType==0 || nDesign==3)?1:2;
			int nDir=1;
			
		// prepare tsl cloning
			TslInst tslNew;
			Vector3d vecXTsl= _XW;
			Vector3d vecYTsl= _YW;
			GenBeam gbsTsl[] = {};		Entity entsTsl[] = {_ThisInst};		Point3d ptsTsl[1];// = {};
			int nProps[]={};			double dProps[]={};			String sProps[]={};//
			Map mapTsl;					mapTsl.setInt("mode",1);
			String sScriptname = scriptName();
			
			for (int i=0;i<nColumns;i++) 
			{
				mapTsl.setInt("alignment",nDir);
				ptsTsl[0]=ptSectionRef+nDir*vecX*(.5*dWidth+dColumnOffset);
				tslNew.dbCreate(sScriptname , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
					nProps, dProps, sProps,_kModelSpace, mapTsl);
				
				if (tslNew.bIsValid())
				{
					_Entity.append(tslNew);	
					tslNew.transformBy(Vector3d(0,0,0));
				}

				nDir*=-1;
			}		
		}// end _bOnDbCreated
	
	// draw truck outline
		pl.createRectangle(LineSeg(ptTruck, ptTruck+vecX*dLength+vecY*dVisibleHeight), vecX, vecY);
		dpTruck.draw(pl);
		PLine plTruck=pl;
		
	//region Plotviewports
		PlotViewport plots[] = CollectPlotViewports(_Entity, "");
		for (int i=0;i<plots.length();i++)
			setDependencyOnEntity(plots[i]);
		int bHasPlotViewport=plots.length()>0;// HSB-19483

		//region draw outline contour
		if(bHasPlotViewport && mapContour.length()>0)
		{ 
			if(mapContour.getDouble("Thickness")>0)
			{ 
				double dThicknessContour=mapContour.getDouble("Thickness");
				PlaneProfile ppOutter(pl);
				PlaneProfile ppInner(pl);
				if(!bIsKlh)
				{ 
					ppOutter.shrink(-.5*dThicknessContour);
					ppInner.shrink(.5*dThicknessContour);
				}
				// HSB-19939: Apply contour thickness on the inside
				if(bIsKlh)
					ppInner.shrink(dThicknessContour);
				ppOutter.subtractProfile(ppInner);
				dpTruck.draw(ppOutter,_kDrawFilled);
			}
		}				
		//endregion 			
	//endregion 

	
		if(bIsKlh)
		{ 
		// draw measures needed for the position of stacking
			Point3d ptStart=ptTruck+vecY*(dVisibleHeight+U(105));
			for (int im=0;im<4;im++)
			{ 
				ptStart+=U(1000)*vecX;
				LineSeg lSeg(ptStart, ptStart+vecY*U(215));
//				if(bIsKlh)
//				{ 
//					lSeg.transformBy(csKLH);
//				}
				dpTruck.draw(lSeg);
				String sTxt=im+1+"m";
				//HSB-24432: 
//				if(bKLHvertTransform)
				if(bIsKlh)// HSB-24485
				{ 
					dpTruck.draw(sTxt,ptStart,-vecX,vecY,-1.5,1.5);
				}
//				else
//				{
//					dpTruck.draw(sTxt,ptStart,vecX,vecY,-1.5,1.5);
//				}
			}//next im
		}
	
	// set grid display to headboard properties
		dpTruck.lineType(sLineTypeHeadBoard, dLineTypeScaleHeadBoard);
		dpGrid.color(nColorHeadBoard);

	// declare headboard outline
		PLine plHeadBoard(vecZ);
		plHeadBoard.addVertex(ptTruck);
		if (nType==0)
		{
			plHeadBoard.addVertex(ptTruck+vecX*dLength);
			plHeadBoard.addVertex(ptTruck+vecX*dLength-vecY*dThicknessHeadBoard);
			plHeadBoard.addVertex(ptTruck-(vecX+vecY)*dThicknessHeadBoard);	
			plHeadBoard.addVertex(ptTruck-vecX*dThicknessHeadBoard+vecY*dHeight);
			plHeadBoard.addVertex(ptTruck+vecY*dHeight);
			plHeadBoard.close();//plHeadBoard.vis(2);
		}
		else
			plHeadBoard.createRectangle(LineSeg(ptTruck, ptTruck-vecX*dThicknessHeadBoard+vecY*dWidth), vecX, vecY);
		PlaneProfile ppHeadBoard(plHeadBoard);

		dpGrid.draw(ppHeadBoard,_kDrawFilled,nTransparencyHeadBoard);
//		dpGrid.draw(PlaneProfile(plHeadBoard),_kDrawFilled,nTransparencyHeadBoard);
		
	// get horizontal edge offset of containers
		double dHorizontalEdgeOffset;
		if (nDesign == 2)
		{
			String key; 
			key="HorizontalEdgeOffset"; dHorizontalEdgeOffset=mapDesign.hasDouble(key)?mapDesign.getDouble(key):U(150);
		}
	
	// draw truck section view
		pl.createRectangle(LineSeg(_pt0, _pt0+vecX*dWidth+vecY*dHeight), vecX, vecY);
		dpTruck.draw(pl);
		PLine plTruckSec=pl;
		// HSB-19483
		if(mapContour.length()>0)
		{ 
			if(mapContour.getDouble("Thickness")>0)
			{ 
				double dThicknessContour=mapContour.getDouble("Thickness");
				PlaneProfile ppOutter(pl);
				PlaneProfile ppInner(pl);
				ppOutter.shrink(-.5*dThicknessContour);
				ppInner.shrink(.5*dThicknessContour);
				ppOutter.subtractProfile(ppInner);
				dpTruck.draw(ppOutter,_kDrawFilled);
			}
		}
		
	// set dependency to grids and get max rows
		int nMaxRows;
		TslInst grids[0];
		for (int i=0;i<_Entity.length();i++) 
		{ 
			TslInst grid=(TslInst)_Entity[i]; 
			if (grid.bIsValid())
			{
				//setDependencyOnEntity(grid);
				Map map = grid.map();
				int nNum = map.getInt("numRows");
				if (nNum>nMaxRows)
					nMaxRows=nNum;
				grids.append(grid);	
				//
			}
		}
		
		if(bIsKlh)
		{ 
			// HSB-22875: show dimensions of all packages
			if(grids.length()>0)
			{ 
				TslInst grid=grids.first();
				// HSB-23131
				Map mapGrid=grid.map();
				PlaneProfile ppItemsAll=grid.map().getPlaneProfile("ppItemsAll");
//				Body bdItemsAll=grid.map().getBody("bdItemsAll");
				Body bdItemsAll=mapGrid.getBody("bdItemsAll");
				Body bdItemsAlls[0];
				double dv=bdItemsAll.volume();
				// HSB-23527: save bodies as array
				{ 
					Map mapBdItemsAlls=mapGrid.getMap("mapBdItemsAlls");
					Body bdItemsAlls0[]=GetBodyArray(mapBdItemsAlls);
					for (int b=0;b<bdItemsAlls0.length();b++) 
					{ 
						bdItemsAlls.append(bdItemsAlls0[b]);
						if(dv<pow(U(1),3))
						{ 
							bdItemsAll.addPart(bdItemsAlls0[b]);
						}
					}//next b
				}
				// HSB-23527:
				for (int g=1;g<grids.length();g++) 
				{ 
					PlaneProfile ppg=grids[g].map().getPlaneProfile("ppItemsAll");
					ppItemsAll.unionWith(ppg);
					Body bdg=grids[g].map().getBody("bdItemsAll");
					bdItemsAll.addPart(bdg);
					
					Map mapBdItemsAlls=grids[g].map().getMap("mapBdItemsAlls");
					Body bdItemsAllsG[]=GetBodyArray(mapBdItemsAlls);
					for (int b=0;b<bdItemsAllsG.length();b++) 
					{ 
						bdItemsAlls.append(bdItemsAllsG[b]);
					}//next b
				}//next g
				
				// HSB-23446
				Map maps;
				//HSB-23341
				PlaneProfile ppItemsAllCombi=grid.map().getPlaneProfile("ppItemsAllCombi");
				Body bdItemsAllCombi=grid.map().getBody("bdItemsAllCombi");
				// HSB-24148
				double bdItemsAllVolTot;
				for (int g=0;g<grids.length();g++) 
				{ 
//					Map mg=grids[g].map();
					PlaneProfile ppg=grids[g].map().getPlaneProfile("ppItemsAllCombi");
					ppItemsAllCombi.unionWith(ppg);
					Body bdg=grids[g].map().getBody("bdItemsAllCombi");
					bdItemsAllCombi.addPart(bdg);
					// HSB-23446
					Map mi;
					mi.setBody("bdItemsAllCombi",grids[g].map().getBody("bdItemsAllCombi"));
					mi.setBody("bdItemsAll",grids[g].map().getBody("bdItemsAll"));
					mi.setDouble("bdItemsAllVol",grids[g].map().getBody("bdItemsAll").volume());
					mi.setPlaneProfile("ppItemsAllCombi",grids[g].map().getPlaneProfile("ppItemsAllCombi"));
					mi.setPlaneProfile("ppItemsAll",grids[g].map().getPlaneProfile("ppItemsAll"));
					mi.setDouble("WeightCombi",grids[g].map().getDouble("WeightCombi"));
					mi.setPoint3d("ptCogCombi", grids[g].map().getPoint3d("ptCogCombi"));
					// HSB-24148
					bdItemsAllVolTot+=grids[g].map().getDouble("bdItemsAllVol");
					maps.appendMap("m", mi);// HSB-24485 
				}//next g
				
//				visPp(ppItemsAll,_ZW*U(500));
				PlaneProfile ppItemsAllSection=grid.map().getPlaneProfile("ppItemsAllSection");
				int bSupressTruckDims=_Map.getInt("SupressTruckDims");
				// HSB-23131
				_Map.setPlaneProfile("ppItemsAll",ppItemsAll);
				_Map.setBody("bdItemsAll",bdItemsAll);
				_Map.setDouble("bdItemsAllVol",bdItemsAllVolTot);// HSB-24148
				// HSB-23527:
				Map mapBdItemsAlls=SetBodyArray(bdItemsAlls);
				_Map.setMap("mapBdItemsAlls",mapBdItemsAlls);
				//HSB-23341
				_Map.setPlaneProfile("ppItemsAllCombi",ppItemsAllCombi);
				_Map.setBody("bdItemsAllCombi",bdItemsAllCombi);
				// HSB-23446
				_Map.setMap("mapsCombi",maps);
			//region Trigger HideShowTruckDims
				String sTriggerHideShowTruckDims = T("|Hide truck dimensions|");
				if(bSupressTruckDims)sTriggerHideShowTruckDims = T("|Show truck dimensions|");
				addRecalcTrigger(_kContext, sTriggerHideShowTruckDims );
				if (_bOnRecalc && _kExecuteKey==sTriggerHideShowTruckDims)
				{
					_Map.setInt("SupressTruckDims",!_Map.getInt("SupressTruckDims"));
					setExecutionLoops(2);
					return;
				}//endregion
				
				if(!bSupressTruckDims)
				{ 
					// HSB-22875
					// show truck dimensions
//					visPp(ppItemsAll,vecZ*U(300));
//					visPp(ppItemsAllSection,vecZ*U(600));
					PlaneProfile pPtruck(plTruck);
					PlaneProfile pPtruckSec(plTruckSec);
				// get extents of profile
					LineSeg segTruck=pPtruck.extentInDir(vecX);
					double dXtruck=abs(vecX.dotProduct(segTruck.ptStart()-segTruck.ptEnd()));
					double dYtruck=abs(vecX.dotProduct(segTruck.ptStart()-segTruck.ptEnd()));
					
					LineSeg segTruckSec=pPtruckSec.extentInDir(vecX);
					double dXtruckSec=abs(vecX.dotProduct(segTruckSec.ptStart()-segTruckSec.ptEnd()));
					double dYtruckSec=abs(vecY.dotProduct(segTruckSec.ptStart()-segTruckSec.ptEnd()));
					
					LineSeg segItems=ppItemsAll.extentInDir(vecX);
					double dXItems=abs(vecX.dotProduct(segItems.ptStart()-segItems.ptEnd()));
					double dYItems=abs(vecY.dotProduct(segItems.ptStart()-segItems.ptEnd()));
					
					Display dpDim(0);
					if(_DimStyles.find("KLH-50")>-1)
					{
						dpDim.dimStyle("KLH-50");
					}
					dpDim.color(0);
					dpDim.textHeight(U(100));
					// HSB-24485
					int bStartDim=(vecX.dotProduct(segItems.ptStart()-ptTruck)>=U(200));
//					int bStartDim=(vecX.dotProduct(segItems.ptStart()-ptTruck)>=U(100));
					if(bStartDim)
					{ 
					// starting horizontal dimension at truck
						Point3d ptDims[0];
						ptDims.append(ptTruck);
						ptDims.append(segItems.ptStart());
						Point3d ptDim = ptTruck+vecY*(dYtruckSec+U(160));
//						DimLine dl(ptDim,vecX,vecY);
						DimLine dl(ptDim,_XW,_YW);
						dl.setUseDisplayTextHeight(true);
						Dim dim(dl,ptDims,"","",true,false);
						dpDim.draw(dim);
					}
					//Horizontal truck
					{ 
						// second horizontal dimension at truck
						Point3d ptDims[0];
						ptDims.append(ptTruck);
						ptDims.append(segItems.ptEnd());
						Point3d ptDim = ptTruck+vecY*(dYtruckSec+U(320));
//						DimLine dl(ptDim,vecX,vecY);
						DimLine dl(ptDim,_XW,_YW);
						dl.setUseDisplayTextHeight(true);
						Dim dim(dl,ptDims,"","",true,false);
						dpDim.draw(dim);
					}
					// do for each grid at section
					for (int g=0;g<grids.length();g++) 
					{ 
						TslInst gridg=grids[g];
						PlaneProfile ppItemsAllSection=gridg.map().getPlaneProfile("ppItemsAllSection");
						// truck section
						LineSeg segItemsSec=ppItemsAllSection.extentInDir(vecX);
						double dXItemsSec=abs(vecX.dotProduct(segItemsSec.ptStart()-segItemsSec.ptEnd()));
						double dYItemsSec=abs(vecY.dotProduct(segItemsSec.ptStart()-segItemsSec.ptEnd()));
						
						// section
						{ 
							// horizontal
							Point3d ptDims[0];
							ptDims.append(segItemsSec.ptStart());
							ptDims.append(segItemsSec.ptEnd());
							Point3d ptDim =_pt0+vecY*(dYtruckSec+U(320));
//							DimLine dl(ptDim,vecX,vecY);
							DimLine dl(ptDim,_XW,_YW);
							dl.setUseDisplayTextHeight(true);
							
							Dim dim(dl,ptDims,"","",true,false);
							dpDim.draw(dim);
							double dDimOffsetSection=U(120);
							double dDimOffsetSectionR=U(200);
							// vertical 1
							if(vecY.dotProduct(segItemsSec.ptStart()-_pt0)>dEps)
							{ 
								// 
								ptDims.setLength(0);
								ptDims.append(_pt0);
								ptDims.append(segItemsSec.ptStart());
								// HSB-22893
//								ptDim =_pt0+vecX*(dXItemsSec+U(500));
								ptDim =_pt0+vecX*(dXtruckSec+U(400));
								// vertical
								if(nType==1)
								{ 
									// vertical stacking usually 2 grids
									if(g==0)
									{ 
										// vertical stacking has 2 grids left and right
										ptDim =_pt0-vecX*(dDimOffsetSection);
										ptDim.vis(1);
									}
									else if(g==1)
									{ 
										ptDim =segTruckSec.ptEnd()+vecX*(dDimOffsetSectionR);
									}
								}
//								dl=DimLine (ptDim,vecY,-vecX);
								dl=DimLine (ptDim,_YW,-_XW);
								dl.setUseDisplayTextHeight(true);
								
								dim=Dim (dl,ptDims,"","",true,false);
								dpDim.draw(dim);
							}
							// vertical2
							ptDims.setLength(0);
							ptDims.append(_pt0);
							ptDims.append(segItemsSec.ptEnd());
							// HSB-22893
//							ptDim =_pt0+vecX*(dXItemsSec+U(700));
							ptDim =_pt0+vecX*(dXtruckSec+U(600));
							if(nType==1)
							{ 
								// vertical stacking usually 2 grids
								if(g==0)
								{ 
									// vertical stacking has 2 grids left and right
									ptDim =_pt0-vecX*(dDimOffsetSection);
								}
								else if(g==1)
								{ 
									ptDim =segTruckSec.ptEnd()+vecX*(dDimOffsetSectionR);
								}
							}
//							dl=DimLine (ptDim,vecY,-vecX);
							dl=DimLine (ptDim,_YW,-_XW);
							dl.setUseDisplayTextHeight(true);
							dim=Dim (dl,ptDims,"","",true,false);
	//						dim.setDeltaOnTop(false);
							dpDim.draw(dim);
						}
					}//next g
				}
			}
		}

	// declare stancion pline
		PLine plStancion(vecZ);
		if (nType==1 && nDesign!=2 && nDesign!=3 && dStancionWidth>0 && dStancionHeight>0) // vertical loading but no container
		{
			Point3d pt = _pt0+vecX*.5*dWidth;
			plStancion.addVertex(pt);
			plStancion.addVertex(pt-vecX*.5*dStancionWidth);
			plStancion.addVertex(pt-vecX*.3*dStancionWidth+vecY*dStancionHeight);
			plStancion.addVertex(pt+vecX*.3*dStancionWidth+vecY*dStancionHeight);
			plStancion.addVertex(pt+vecX*.5*dStancionWidth);	
			plStancion.close();	
			dpTruck.draw(plStancion);
			plStancion.transformBy(ptSectionRef-plStancion.ptStart());
		}
		
	// declare container blocking pline
		PLine plContainerBlocking(vecZ);
		if (nType==1 && nDesign==2) // vertical container loading
		{
			Point3d pt=_pt0;
			plContainerBlocking.addVertex(pt);
			plContainerBlocking.addVertex(pt+vecX*dHorizontalEdgeOffset);
			plContainerBlocking.addVertex(pt+(vecX+vecY)*dHorizontalEdgeOffset);
			plContainerBlocking.addVertex(pt+vecY*dHorizontalEdgeOffset);
			plContainerBlocking.addVertex(pt);
			plContainerBlocking.addVertex(pt+(vecX+vecY)*dHorizontalEdgeOffset);
			plContainerBlocking.addVertex(pt+vecY*dHorizontalEdgeOffset);
			plContainerBlocking.addVertex(pt+vecX*dHorizontalEdgeOffset);
			plContainerBlocking.close();
			
			dpTruck.draw(plContainerBlocking);
			plContainerBlocking.transformBy(vecX*(dWidth-dHorizontalEdgeOffset));
			dpTruck.draw(plContainerBlocking);
			plContainerBlocking.transformBy(-vecX*(dWidth-dHorizontalEdgeOffset));
			plContainerBlocking.transformBy((ptSectionRef-.5*vecX*dWidth)-_pt0);
		}
	
	// get planeprofile for all trucks
		PlaneProfile ppSectionAll;
	// draw section cells 
		if (nDesign==3)
			pl.createRectangle(LineSeg(ptSectionRef,ptSectionRef+vecX*dWidth+vecY*dHeight), vecX, vecY);		
		else
			pl.createRectangle(LineSeg(ptSectionRef-.5*vecX*dWidth,ptSectionRef+.5*vecX*dWidth+vecY*dHeight), vecX, vecY);
		
		for (int i=0;i<nMaxRows;i++) 
		{ 
			pl.transformBy(-vecY*(dCellHeight+dRowOffset));
			if (i==0)pl.transformBy(-vecY*(dRowOffsetTruck-dRowOffset));
			PLine plOrig=pl;
			if(bKLHvertTransform)
			{ 
				pl.transformBy(csKLHvertRot);
			}
			dpTruck.draw(pl);
			pl=plOrig;
			// HSB-19483
			if(mapContour.length()>0)
			{ 
				if(mapContour.getDouble("Thickness")>0)
				{ 
					double dThicknessContour=mapContour.getDouble("Thickness");
					PlaneProfile ppOutter(pl);
					PlaneProfile ppInner(pl);
					ppOutter.shrink(-.5*dThicknessContour);
					ppInner.shrink(.5*dThicknessContour);
					ppOutter.subtractProfile(ppInner);
					dpTruck.draw(ppOutter,_kDrawFilled);
				}
			}
			
		// pp of all sections
			ppSectionAll.joinRing(pl,_kAdd);
		// draw stancion pline
			if (nType==1 && nDesign!=2 && nDesign!=3)  // vertical loading but no container
			{
				plStancion.transformBy(-vecY*(dCellHeight+dRowOffset));
				if (i==0)plStancion.transformBy(-vecY*(dRowOffsetTruck-dRowOffset));
				PLine plStancionOrig=plStancion;
				if(bKLHvertTransform)
				{ 
					plStancion.transformBy(csKLHvertRot);
				}
				dpTruck.draw(plStancion);
				plStancion=plStancionOrig;
			}	
		// draw container blocking
			else if (nType==1 && nDesign==2)
			{ 
				if (i==0)plContainerBlocking.transformBy(-vecY*(dRowOffsetTruck-dRowOffset));
				plContainerBlocking.transformBy(-vecY*(dCellHeight+dRowOffset));
				
				if(bKLHvertTransform && i==0)// HSB-24486
				{ 
					// HSB-24205
					plContainerBlocking.transformBy(csKLHvertRot);
				}
				dpTruck.draw(plContainerBlocking);
				plContainerBlocking.transformBy(vecX*(dWidth-dHorizontalEdgeOffset));
				dpTruck.draw(plContainerBlocking);
				plContainerBlocking.transformBy(-vecX*(dWidth-dHorizontalEdgeOffset));				
			}
		}
		_Map.setPoint3d("ptSectionRef", ptSectionRef);
		_Map.setInt("Design", nDesign);
	
	//region collect referenced item entities
		Entity ents[0];
		Entity items[0];
		CoordSys coords[0]; // need to be same length as ents
		{ 
		// collect layers from grids
			TslInst layers[0];
			for (int i=0;i<grids.length();i++) 
			{ 
				Entity ents[] = grids[i].entity();
				for (int e=0;e<ents.length();e++) 
				{ 
					TslInst layer = (TslInst)ents[e]; 
					if (!layer.bIsValid())continue;
					Map mapLayer = layer.map();
				// validate layer
					if (mapLayer.getInt("isLayer") && grids[i].handle() == layer.subMapX(sGridKey).getString("MyUid") )
					{
						layers.append(layer);
					}
				}	 
			}
	
		// collect items from layers
			String sLayerTxt="Lagentrennung\PLayer seperation\P";
			for (int i=0;i<layers.length();i++) 
			{ 
				items.append(layers[i].entity());
				TslInst layer=layers[i];
			}
			
		// collect export entities from items
			for (int i=0;i<items.length();i++)
			{
				TslInst item = (TslInst)items[i];
				if (!item.bIsValid())continue;
				Entity _ents[]=item.entity();
			
			// append anything unique but child panels
				for (int j=0;j<_ents.length();j++) 
				{ 
					Entity ent = _ents[j];
					if (ents.find(ent)<0 && !ent.bIsKindOf(ChildPanel()))
					{
						ents.append(ent); 
						
					// if the entity is of type element append also its entities
						Element el = (Element)ent;
						if (el.bIsValid())
						{ 
							GenBeam genbeams[] = el.genBeam();
							for (int k=0;k<genbeams.length();k++) 
								if (ents.find(genbeams[k])<0)
								{
									ents.append(genbeams[k]); 
								}
						}
					}
				}
			}
			
 		}//endregion	
	
	//region EXPORTER

	// register potentially defined exporter groups
		String sExporterGroupEvents[0];
		String sExporterEventPrefix =  T("|Run Export|") + " ";
		for(int i=0;i<mapExporterGroups.length();i++)
		{
			Map e = mapExporterGroups.getMap(i);
			if (e.hasString("Name"))
			{
				String s= sExporterEventPrefix + e.getString("Name");
				if(sExporterGroupEvents.find(s)<0)
				{
					addRecalcTrigger(_kContextRoot,s);
					sExporterGroupEvents.append(s);
				}
			}
		}// next i
		
	// run exporter	
		int nExporterGroupEvent=sExporterGroupEvents.find(_kExecuteKey);
		if (_bOnRecalc && nExporterGroupEvent>-1)				
		{ 
			String sExporterGroup = _kExecuteKey.right(_kExecuteKey.length()-sExporterEventPrefix.length());
			reportMessage("\n" + scriptName() + ": " +T("|searching|") + " " + sExporterGroup + " " + T("|in exporter groups.|"));
	
			String sExporterGroups[] = ModelMap().exporterGroups();
			if (sExporterGroups.find(sExporterGroup)<0)
			{
				String sMsg = T("|The exporter group|") + " " + sExporterGroup + " " + T("|could not be found.|");
				reportMessage("\n" + sMsg);
				reportNotice("\n******** " + scriptName() + ": " +_kExecuteKey + " ********\n\n" + sMsg + 
				TN("|Please review your exporter configurations and/or adjust settings.|") +"\n\n************************************************************************************" );
				setExecutionLoops(2);
				return;
			}

		// export
		// set some export flags
			ModelMapComposeSettings mmFlags;
			mmFlags.addSolidInfo(TRUE); // default FALSE
			mmFlags.addAnalysedToolInfo(TRUE); // default FALSE
			mmFlags.addElemToolInfo(TRUE); // default FALSE
			mmFlags.addConstructionToolInfo(TRUE); // default FALSE
			mmFlags.addHardwareInfo(TRUE); // default FALSE
			mmFlags.addRoofplanesAboveWallsAndRoofSectionsForRoofs(TRUE); // default FALSE
			mmFlags.addCollectionDefinitions(TRUE); // default FALSE
			String strDestinationFolder = _kPathDwg;
	
		// Map that contains the keys that need to be overwritten in the ProjectInfo 
			Map mapProjectInfoOverwrite;
			//mapProjectInfoOverwrite.appendString("ProjectInfo\\ProjectRevision","10.11.12");
			//mapProjectInfoOverwrite.appendString("ProjectInfo\\PathDwg","aa");

		// compose ModelMap
			ModelMap mm;
			mm.setEntities(ents);
			mm.dbComposeMap(mmFlags);
		
			if (bDebug)	mm.writeToDxxFile(_kPathDwg+"\\debugOut.dxx");			
		
		// call the exporter				
			int bOk = ModelMap().callExporter(mmFlags, mapProjectInfoOverwrite, ents, sExporterGroup, strDestinationFolder);
			if (!bOk)reportNotice("\n***** " + scriptName() + " *****" + TN("|We are sorry, but the call of the export failed|"));			
		}
	//EXPORTER //endregion 		
	
	// create child panels
		String sTriggerCreateChildPanels = T("|Create Child Panels|");
		addRecalcTrigger(_kContextRoot,sTriggerCreateChildPanels);
		if (_bOnRecalc && _kExecuteKey == sTriggerCreateChildPanels)	
		{ 
		// prompt for items
			Entity _items[0];
			PrEntity ssE(T("|Select item(s)|") + ", " + T("|<Enter> to select all|"), TslInst());
		  	if (ssE.go())
				_items.append(ssE.set());
			
		// use the new selection set instead of all items
			if (_items.length()>0)
				items = _items;

		// get target point, create and transform childs
			Point3d ptBase;
			if (items.length()>0)
			{
				PrPoint ssP(TN("|Select base point|"), _pt0); 
				if (ssP.go()==_kOk) 
					ptBase=ssP.value();
				ptBase.setZ(0);	
				
			// get relative transformation
				Vector3d vecTrans = ptBase - _pt0;	
					
			// collect panels from items, create child and transform
				Sip sips[0];
				for (int i=0;i<items.length();i++)
				{
					TslInst item = (TslInst)items[i];
					if (!item.bIsValid())continue;
					
					Entity _ents[]=item.entity();
				// append anything unique but child panels
					for (int j=0;j<_ents.length();j++) 
					{ 
						Sip sip = (Sip)_ents[j];
						if (sip.bIsValid())
						{ 
							ChildPanel child;
							CoordSys cs = item.coordSys();

							Vector3d _vecX = cs.vecX();
							cs.setToAlignCoordSys(sip.ptCen(), sip.vecX(), sip.vecY(), sip.vecZ(),cs.ptOrg(), cs.vecX(), cs.vecY(), cs.vecZ());
							_vecX.transformBy(cs);
							
							child.dbCreate(sip,item.ptOrg()+vecTrans, _vecX);//CoordSys(sip.ptCenSolid(), sip.vecX(), sip.vecY(), sip.vecZ()));
						}
					}	
				}					
			}
		}
		
		
		Entity entPackages[0];
	// Store data in subMapX or in Property set of source entities
		if (bStoreInSubmap)
		{ 
			for (int i = 0; i < ents.length(); i++)
			{
				Entity ent = ents[i];
				if (bDebug)
				reportMessage("\n	attaching subMapX to: " + ent.typeDxfName() + " " + ent);
				
			//region Write truck ref to source entity
				Map mapX;
				mapX.setString("ParentUid",_ThisInst.handle());
				mapX.setPoint3d("ptRelOrg",_pt0,_kAbsolute);
				mapX.setPoint3d("ptVecX",_pt0+vecX,_kAbsolute);
				mapX.setPoint3d("ptVecY",_pt0+vecY,_kAbsolute);
				mapX.setPoint3d("ptVecZ",_pt0+vecZ,_kAbsolute);
				ent.setSubMapX("Hsb_TruckChild",mapX);
			//End Write truck ref to source entity//endregion 
				
			// get item and package
				Element el=ent.element();
				Entity item; 
				item.setFromHandle(ent.subMapX("Hsb_ItemParent").getString("MyUid"));				
				if (el.bIsValid() && !ent.bIsKindOf(Element()))
				{ 
					Entity itemEl; 
					itemEl.setFromHandle(el.subMapX("Hsb_ItemParent").getString("MyUid"));
					if (itemEl.bIsValid())
						item=itemEl;
				}

				Entity entLayer,entPackage;
				if (item.bIsValid())
				{
					entLayer.setFromHandle(item.subMapX(sLayerX).getString("MyUid"));
					entPackage.setFromHandle(item.subMapX("Hsb_PackageParent").getString("ParentUid"));
				}
				TslInst package=(TslInst)entPackage;
				TslInst layer=(TslInst)entLayer;
		
			//region Write stacking data
				Map m=ent.subMapX("StackingData");
				m.setInt("Number",nNumber);
				m.setString("Name", sTruck);
				m.setString("Type", sType);
				m.setString("Design", sDesign);
				m.setString("Type", sType);
				m.setInt("Package Number",(package.bIsValid()?package.propInt(0):-1));
				// HSB-24401
				m.setString("Package Wrapping",(package.bIsValid()?package.propString(3):""));
				m.setInt("Layer Index",(layer.bIsValid()?layer.map().getInt("row")+1:-1));
				if(bIsKlh)
				{ 
				// HSB-18017
//					String sLayerTxt="Lagentrennung\PLayer seperation\P";
					String sLayerTxt="Lagentrennung";
					int nApplyLayerSeparationI=false;
					if (item.bIsValid())
					{ 
					// check the layer separation
						TslInst tslInt=(TslInst)item;
						if(tslInt.propString(2).find(sLayerTxt,-1,false)>-1)
						{ 
							nApplyLayerSeparationI=true;
							nApplyLayerSeparation=true;
						}
					}
					if(nApplyLayerSeparationI)
					{ 
						m.setString("LayerSeparation","L");
					}
					else if(!nApplyLayerSeparationI)
					{ 
						m.setString("LayerSeparation","");
					}
					if(package.bIsValid())
					{ 
					// check the package foliert
						String s3=package.propString(3);
						if(package.propString(3)==sNoYes[1])
						{
							nPackageWrapped=true;
							m.setString("PackageWrapped","F");
						}
						else
						{ 
							m.setString("PackageWrapped","");
						}
						if(entPackages.find(package)<0)
						{ 
							entPackages.append(package);
						}
					}
					else
					{ 
						m.setString("PackageWrapped","");
					}
				}
				
				// HSB-15355
				Map mm = m;
				ent.setSubMapX("StackingData", mm);
			//End Write stacking data//endregion
			}
		}
	//region PropertySet
		else
		{ 
		// get available propertysets
			String sAvailableSets[] = Entity().availablePropSetNames();	
			if (bDebug)reportMessage("\n	availablePropSetNames: "+sAvailableSets);
		// create if not existant
			if (sAvailableSets.find(sPropsetName)<0 || _ThisInst.color()==1)
			{ 
				Map m;
				for (int i=0;i<sPropsetProperties.length();i++)
				{ 
					int n = nPropsetPropertyTypes[i];
					if (n==0)
						m.setString(sPropsetProperties[i],"");
					else if (n==1)
						m.setInt(sPropsetProperties[i],-1);
					else if (n==2)
						m.setInt(sPropsetProperties[i],0);				
				}	
				int bOk =  Entity().createPropSetDefinition(sPropsetName, m, true); 
		
			}	
		
		// attach / assign and fill with data	
			for (int i = 0; i < ents.length(); i++)
			{
				Entity ent = ents[i];
				if (bDebug)reportMessage("\n	attaching to: " +ent.typeDxfName() + " "+ent);
						
			// writing truck ref to source entity
				Map mapX;	
				mapX.setString("ParentUid", _ThisInst.handle());
				mapX.setPoint3d("ptRelOrg", _pt0, _kAbsolute);
				mapX.setPoint3d("ptVecX", _pt0 + vecX, _kAbsolute);
				mapX.setPoint3d("ptVecY", _pt0 + vecY, _kAbsolute);
				mapX.setPoint3d("ptVecZ", _pt0 + vecZ, _kAbsolute);			
				ent.setSubMapX("Hsb_TruckChild",mapX);
	
			// check if it is attached
				String sAttachedSets[] = ent.attachedPropSetNames();
				int bIsAttached = sAttachedSets.find(sPropsetName) >- 1;
				if ( ! bIsAttached)
					bIsAttached = ent.attachPropSet(sPropsetName);
				
			// update property set
				if (bIsAttached)
				{
//					Map mapPropSet = ent.getAttachedPropSetMap(sPropsetName);
					// HSB-19487: Only take the relevant properties
					Map mapPropSet = ent.getAttachedPropSetMap(sPropsetName,sPropsetProperties);
					// check if update of property set is required
					int bUpdate;
					for (int i = 0; i < sPropsetProperties.length(); i++)
					{
						String k = mapPropSet.keyAt(i);
						int n = nPropsetPropertyTypes[i];
						if (n == 0 && !mapPropSet.hasString(sPropsetProperties[i]))
						{
							bUpdate = true;
							if (bDebug)reportMessage("\n" + k + " not in " + mapPropSet);
							break;
						}
						else if (n == 1 && !mapPropSet.hasInt(sPropsetProperties[i]))
						{
							bUpdate = true;
							if (bDebug)reportMessage("\n" + k + " not in " + mapPropSet);
							break;
						}
						else if (n == 2 && !mapPropSet.hasDouble(sPropsetProperties[i]))
						{
							bUpdate = true;
							if (bDebug)reportMessage("\n" + k + " not in " + mapPropSet);
							break;
						}	
					}
				// amount of properties has changed
					int nNumProperties = sPropsetProperties.length();
					if (mapPropSet.length() != nNumProperties)bUpdate = true;
					
					if (bDebug)reportMessage("\n	is attached an update is " +(bUpdate?"":"not ")+ "required");
					
				// write properties
					int bWrite, nInd;
					String k, s;
					
					//{T("|Number|"),T("|Name|"), T("|Type|"),T("|Design|"), T("|Layer Index|"),T("|Package Number|")};
				
				// number
					if (nNumProperties>0)
					{ 
						k = sPropsetProperties[0];
						if (nNumber!= mapPropSet.getInt(k))bWrite = true;
						mapPropSet.setInt(k, nNumber);
					}
					
				// name (truck ID)
					if (nNumProperties>1)
					{
						s = sTruck;//truck.bIsValid() ? truck.propString(0) : "";
						k = sPropsetProperties[1];
						if (s != mapPropSet.getString(k))bWrite = true;
						mapPropSet.setString(k, s);
					}
						
				// truck type
					if (nNumProperties > 2)
					{
						s = sType;//truck.bIsValid() ? truck.propString(1) : "";
						k = sPropsetProperties[2];
						if (s != mapPropSet.getString(k))
							bWrite = true;
						mapPropSet.setString(k, s);
					}
					
				// truck Design
					if (nNumProperties > 3)
					{
						s = sDesign;//truck.bIsValid() ? truck.propString(1) : "";
						k = sPropsetProperties[3];
						if (s != mapPropSet.getString(k))
							bWrite = true;
						mapPropSet.setString(k, s);
					}
	
				// get item
					Entity item; 
					item.setFromHandle(ent.subMapX("Hsb_ItemParent").getString("MyUid"));
				
				// package number // TODO implement package number validation if 
					if (nNumProperties > 5 && item.bIsValid())
					{
					// try to get package
						Entity entPackage;entPackage.setFromHandle(item.subMapX("Hsb_PackageParent").getString("MyUid"));
						TslInst package = (TslInst)entPackage;
						
						int packageNumber = -1;
						
						String handle = item.subMapX("Hsb_PackageParent").getString("MyUid");
						
						if (package.bIsValid())
						{ 
							packageNumber = package.propInt(0);
							Entity refs[] = package.map().getEntityArray("EntityRef", "", "Handle");
							if (refs.find(ent)>-1)
							{ 
								;//TODO
							}
						}
						
	//					s = sDesign;//truck.bIsValid() ? truck.propString(1) : "";
						//s = packageNumber;
						k = sPropsetProperties[5];
						if (packageNumber != mapPropSet.getInt(k))
							bWrite = true;
						mapPropSet.setInt(k, packageNumber);
					}
					
				// get layer	
					Entity entLayer; 
					if (item.bIsValid())
						entLayer.setFromHandle(item.subMapX(sLayerX).getString("MyUid"));
					TslInst layer;
					if (entLayer.bIsValid()) layer = (TslInst)entLayer;
	 
				// Layer
					if (nNumProperties > 4 && layer.bIsValid())
					{
						int nRow=layer.map().getInt("row")+1;
						
						k = sPropsetProperties[4];
						if (nRow != mapPropSet.getInt(k))
							bWrite = true;
						mapPropSet.setInt(k, nRow);						
					}
	
					//update property set
					if (bUpdate)
					{
						int bOk = ent.createPropSetDefinition(sPropsetName, mapPropSet, true);
						if (bDebug)reportMessage("\n" + scriptName() + ": " + T("|Property Set|") + " " + sPropsetName + " " + (bOk ? T("|succesfully created.|") : T("|creation failed.|")));
						
					}
					
					// set map
					if (bWrite)
					{
						ent.removePropSet(sPropsetName);
						ent.attachPropSet(sPropsetName);
						if (bDebug)reportMessage("\n" + scriptName() + ": writing " + sPropsetName + " to " + ent.handle() + " map: " + mapPropSet);
						for (int ii=0;ii<mapPropSet.length();ii++) 
						{ 
							reportMessage("\n	"+ mapPropSet.keyAt(ii)+ " " + (mapPropSet.hasInt(ii)?mapPropSet.getInt(ii):(mapPropSet.hasString(ii)?mapPropSet.getString(ii):mapPropSet.getDouble(ii)))); 
							 
						}//next ii
						
						ent.setAttachedPropSetFromMap(sPropsetName, mapPropSet);
					}
				}
			}
		}		
	//End PropertySet//endregion

	// publish entities to be queried from _hsbReport or other tsls
		_Map.setEntityArray(ents,false,"EntityRef[]","","Handle");
		
	//region Axle Load calculation + Display
		if(bIsKlh)
		{
		// calculation for KLH
			if(grids.length()>0)
			{ 
			// grids are available
				Point3d ptCOG,ptCOGcombi;
				double dWeight,dWeightCombi;
				Point3d ptWeightCog,ptWeightCogCombi;
				for (int ig=0;ig<grids.length();ig++) 
				{ 
					Map mapI=grids[ig].map();
					ptWeightCog+=mapI.getPoint3d("ptCog")*mapI.getDouble("Weight");
					ptWeightCogCombi+=mapI.getPoint3d("ptCogCombi")*mapI.getDouble("WeightCombi");
					dWeight+=mapI.getDouble("Weight");
					dWeightCombi+=mapI.getDouble("WeightCombi");
				}//next ig
				if(dWeight>dEps)
					ptCOG=ptWeightCog/dWeight;
				else ptCOG=ptTruck+dLength*vecX;
				if(dWeightCombi>dEps)
					ptCOGcombi=ptWeightCogCombi/dWeightCombi;
				else ptCOGcombi=ptTruck+dLength*vecX;
				//HSB-23131
				_Map.setPoint3d("ptCOG",ptCOG);
				_Map.setPoint3d("ptCOGcombi",ptCOGcombi);
				_Map.setDouble("WeightCombi",dWeightCombi);
				int nShowAxleLoad=!_Map.getInt("ShowAxelLoad");
			//region Trigger ShowAxelLoad
				String sTriggerShowAxleLoad=T("|Show axle load calculation|");
				if(nShowAxleLoad)
					sTriggerShowAxleLoad=T("|Hide axle load calculation|");
				addRecalcTrigger(_kContextRoot, sTriggerShowAxleLoad);
				if (_bOnRecalc && _kExecuteKey==sTriggerShowAxleLoad)
				{
					_Map.setInt("ShowAxelLoad",nShowAxleLoad);
					setExecutionLoops(2);
					return;
				}//endregion
				
				if(nShowAxleLoad)
				{ 
					if(abs((ptCOG-_PtW).length())<=0)
					{ 
						ptCOG=ptTruck+.5*dLength*vecX;
					}
					if(mapAxleDefinitions.length()>0)
					{ 
					// find mapAxleDefinition that corresponds to selected design
						Map mapAxleDefinition=getMapForDesign(mapAxleDefinitions,sDesign,nType,sTruck);
						int bMapAxleDefinitionFound=(mapAxleDefinition.length()>0);
//					// find mapAxleDefinition that corresponds to selected design
//						int bMapAxleDefinitionFound;
//						String sDesignCap=sDesign;
//						Map mapAxleDefinition;
//						for (int im=0;im<mapAxleDefinitions.length();im++) 
//						{ 
//							Map mapI=mapAxleDefinitions.getMap(im);
//							String sDesignMap=mapI.getString("Design");
//							sDesignMap.trimLeft();
//							sDesignMap.trimRight();
//							String sDesignMaps[]=sDesignMap.tokenize(";");
//							for (int is=0;is<sDesignMaps.length();is++) 
//							{ 
//								String sDesignMapI= sDesignMaps[is]; 
//								sDesignMapI.trimLeft();
//								sDesignMapI.trimRight();
//								// HSB-17789
//								sDesignMapI=T("|"+sDesignMapI+"|");
//								sDesignMapI.makeUpper();
//								if(sDesignMapI==sDesignCap.makeUpper())
//								{ 
//									mapAxleDefinition=mapI;
//									bMapAxleDefinitionFound=true;
//									break;
//								}
//							}//next is 
//							if (bMapAxleDefinitionFound)break;
//						}//next im
						if(bMapAxleDefinitionFound)
						{ 
							String sDesignMap=mapAxleDefinition.getString("Design");
							Map mapAxles;
							int nDefinitionOk;
							if(sDesignMap=="Individuell" && bIsKlh)
							{ 
							// HSB-18371: contain multiple maps as submapX
								Map _mapAxleDefinition=mapAxleDefinition;
								Map mapSubDesigns=_mapAxleDefinition.getMap("Subdesign[]");
								for (int im=0;im<mapSubDesigns.length();im++)
								{ 
									Map mapIm=mapSubDesigns.getMap(im);
									if(mapIm.getString("Name")==sTruck)
									{ 
									// found
										mapAxleDefinition=mapIm;
										mapAxles=mapIm.getMap("Axle[]");
										nDefinitionOk=true;
										break;
									}
								}//next im
							}
							else
							{
								mapAxles=mapAxleDefinition.getMap("Axle[]");
								nDefinitionOk=true;
							}
							if(nDefinitionOk)
							{ 
								int nrAxles=mapAxles.length();
								double dTotWeightMax=mapAxleDefinition.getDouble("TotWeightMax");
								double dSuma, dSumaSquared;
								double das[0], dWeightsMax[0],dWeightIs[0],dWeightsMin[0];
								for (int ia=0;ia<mapAxles.length();ia++) 
								{ 
									Map mapAxle = mapAxles.getMap(ia);
									double dXaxle=mapAxle.getDouble("X");
									das.append(mapAxle.getDouble("X"));
									double dWeightMaxI=mapAxle.getDouble("WeightMax");
									dWeightsMax.append(dWeightMaxI);
									{ 
										// HSB-21968
										double dWeightMinI=0;
										if(mapAxle.hasString("WeightMin"))
										{ 
											String sWeightMin=mapAxle.getString("WeightMin");
											String sLastLetter=sWeightMin.right(1);
											if(sLastLetter=="%")
											{ 
												String sWeightMinNr=sWeightMin.left(sWeightMin.length()-1);
//												dWeightMinI=((sWeightMinNr.atof())/100.0)*dWeightMaxI;
												// HSB-22608: new equation for the min axial weight
												// (15t+Ladegewicht(=gesamtlast vom Zug))*coeff(0.25)<=(3t+Ladegewicht der Triebachse)
												double dCoeff=((sWeightMinNr.atof())/100.0);
												dWeightMinI=dCoeff*(15000+dWeight)-3000;
											}
											else
											{ 
												dWeightMinI=sWeightMin.atof();
											}
										}
										dWeightsMin.append(dWeightMinI);
									}
									dSuma+=dXaxle;
									dSumaSquared+=(dXaxle*dXaxle);
								}//next ia
								// x for COG of all panels
								double dXcog=vecX.dotProduct(ptCOG-ptTruck);
								
								if(abs(dSuma-dXcog*nrAxles)>dEps)
								{ 
								// there is a rotation point
								// calc center of rotation
									double dXrot=(dXcog*dSuma-dSumaSquared)/(dSuma-dXcog*nrAxles);
									double dRot=dWeight/(nrAxles*dXrot+dSuma);
									for (int ia=0;ia<mapAxles.length();ia++) 
									{ 
										double dFi=(dXrot+das[ia])*dRot;
										dWeightIs.append(dFi);
									}//next ia
								}
								else
								{ 
								// transversal uniform displacement
									double dFi=dWeight/nrAxles;
									for (int ia=0;ia<mapAxles.length();ia++) 
									{ 
										dWeightIs.append(dFi);
									}//next ia
								}
								
								Point3d ptTxt=ptTruck+dXcog*vecX;
								ptTxt.vis(1);
								String sWeightFormat;
					 			sWeightFormat.format("%.0f",dWeight);
					 			String sTotWeightMax;
					 			sTotWeightMax.format("%.0f",dTotWeightMax);
					 			String sWeightTxt=sWeightFormat+">"+sTotWeightMax;
					 			if(dWeight>dTotWeightMax)
					 				dpLoad.color(1);
					 			else
					 			{
					 				dpLoad.color(3);
					 				sWeightTxt=sWeightFormat+"<"+sTotWeightMax;
					 			}
					 			double dDisplaceText=-12;
					 			PLine plRecTxt;
					 			PlaneProfile ppRecTxt;
					 			double dFrameThick=U(4);
					 			{ 
//									dpLoad.draw(sWeightTxt,ptTxt,vecX,vecY,0,dDisplaceText);
									dpLoad.draw(sWeightTxt,ptTxt,_XW,_YW,0,dDisplaceText);
									
									double _dTxtH=dpLoad.textHeightForStyle(sWeightTxt,"Standard",dTxtH);
									double _dTxtL=dpLoad.textLengthForStyle(sWeightTxt,"Standard",dTxtH);
									double dRectH=1.5*_dTxtH, dRectL=.5*_dTxtH+_dTxtL;
									
									plRecTxt.createRectangle(LineSeg(ptTxt-vecX*.5*dRectL-vecY*.5*dRectH,
										ptTxt+vecX*.5*dRectL+vecY*.5*dRectH),vecX,vecY);
									plRecTxt.transformBy(vecY*_dTxtH*dDisplaceText*.5);
									ppRecTxt=PlaneProfile(plRecTxt);
									PlaneProfile ppRecTxtSub=ppRecTxt;
									ppRecTxt.shrink(-0.5*dFrameThick);
									ppRecTxtSub.shrink(0.5*dFrameThick);
									ppRecTxt.subtractProfile(ppRecTxtSub);
								}
								dpLoad.draw(plRecTxt);
								dpLoad.draw(ppRecTxt,_kDrawFilled);
								Point3d ptDims[0];
								ptDims.append(ptTruck);
								ptDims.append(ptTruck+dLength*vecX);
								for (int ia=0;ia<mapAxles.length();ia++) 
								{ 
									ptTxt=ptTruck+das[ia]*vecX;
									ptDims.append(ptTxt);
									String sWeightFormat;
					 				sWeightFormat.format("%.0f", dWeightIs[ia]);
					 				String sWeightMaxI;
					 				sWeightMaxI.format("%.0f", dWeightsMax[ia]);
					 				String sWeightMinI;
					 				sWeightMinI.format("%.0f", dWeightsMin[ia]);
					 				String sWeightTxtI=sWeightFormat+">"+sWeightMaxI;
					 				
					 				int bWeightMinOk=true;
					 				int bWeightMaxOk=true;
					 				if(dWeightIs[ia]>dWeightsMax[ia])
					 				{
					 					dpLoad.color(1);
					 					bWeightMaxOk=false;
					 				}
					 				if(dWeightIs[ia]<dWeightsMin[ia])
					 				{ 
					 					// HSB-21968
//					 					dpLoad.color(1);
					 					dpLoad.color(7);
					 					sWeightTxtI=sWeightFormat+"<"+sWeightMinI+" (min.)";
					 					bWeightMinOk=false;
					 				}
					 				if(bWeightMaxOk)
					 				{
					 					// max weight ok
					 					dpLoad.color(3);
					 					sWeightTxtI=sWeightFormat+"<"+sWeightMaxI;
					 				}
//					 				dpLoad.draw(sWeightTxtI,ptTxt,vecX,vecY,0,-8);
					 				dpLoad.draw(sWeightTxtI,ptTxt,_XW,_YW,0,-8);
					 				
					 				// min weight
					 				double dOffsetY=-11;
					 				if(!bWeightMinOk)
									{
										//min weight not ok
										dpLoad.color(7);
					 					sWeightTxtI=sWeightFormat+"<"+sWeightMinI+" (min.)";
										
									}
									else if(bWeightMinOk)
									{ 
										dpLoad.color(3);
										sWeightTxtI=sWeightFormat+">"+sWeightMinI+" (min.)";
									}
									// 
									if(dWeightsMin[ia]>0 && dWeight>5000)
									{
										// show text only if there is a definition for min weight and 
										// weight total > 5000
//										dpLoad.draw(sWeightTxtI,ptTxt,vecX,vecY,0,dOffsetY);
										dpLoad.draw(sWeightTxtI,ptTxt,_XW,_YW,0,dOffsetY);
									}
								}//next ia
								
								Point3d ptDim=ptTruck-vecY*U(250);
//								DimLine dl(ptDim,vecX,vecY);
								DimLine dl(ptDim,_XW,_YW);
								Dim dim(dl,ptDims,"","",true,false);
								dpLoad.draw(dim);
							}
							else
							{ 
								Point3d ptTxt=ptTruck;
								ptTxt+=vecX*vecX.dotProduct(ptCOG-ptTxt);
//								dpLoad.draw("Truck Name was not found in the xml definition",ptTxt,vecX,vecY,0,-8);
								dpLoad.draw("Truck Name was not found in the xml definition",ptTxt,_XW,_YW,0,-8);
							}
						}
						else
						{ 
							// display only the weight
							double dXcog=vecX.dotProduct(ptCOG-ptTruck);
							Point3d ptTxt=ptTruck+dXcog*vecX;
							ptTxt.vis(1);
							String sWeightFormat;
						 	sWeightFormat.format("%.0f",dWeight);
						 	String sWeightTxt=sWeightFormat;
						 	dpLoad.color(3);
						 	double dDisplaceText=-12;
						 	PLine plRecTxt;
				 			PlaneProfile ppRecTxt;
				 			double dFrameThick=U(4);
				 			{ 
//								dpLoad.draw(sWeightTxt,ptTxt,vecX,vecY,0,dDisplaceText);
								dpLoad.draw(sWeightTxt,ptTxt,_XW,_YW,0,dDisplaceText);
								double _dTxtH=dpLoad.textHeightForStyle(sWeightTxt,"Standard",dTxtH);
								double _dTxtL=dpLoad.textLengthForStyle(sWeightTxt,"Standard",dTxtH);
								double dRectH=1.5*_dTxtH, dRectL=.5*_dTxtH+_dTxtL;
								
								plRecTxt.createRectangle(LineSeg(ptTxt-vecX*.5*dRectL-vecY*.5*dRectH,
									ptTxt+vecX*.5*dRectL+vecY*.5*dRectH),vecX,vecY);
								plRecTxt.transformBy(vecY*_dTxtH*dDisplaceText*.5);
								ppRecTxt=PlaneProfile(plRecTxt);
								PlaneProfile ppRecTxtSub=ppRecTxt;
								ppRecTxt.shrink(-0.5*dFrameThick);
								ppRecTxtSub.shrink(0.5*dFrameThick);
								ppRecTxt.subtractProfile(ppRecTxtSub);
							}
							dpLoad.draw(plRecTxt);
							dpLoad.draw(ppRecTxt,_kDrawFilled);
//						 	dpLoad.draw(sWeightTxt,ptTxt,vecX,vecY,0,dDisplaceText);
						 	dpLoad.draw(sWeightTxt,ptTxt,_XW,_YW,0,dDisplaceText);
						}
					}
					else
					{ 
					// display only the weight
						double dXcog=vecX.dotProduct(ptCOG-ptTruck);
						Point3d ptTxt=ptTruck+dXcog*vecX;
						ptTxt.vis(1);
						String sWeightFormat;
					 	sWeightFormat.format("%.0f",dWeight);
					 	String sWeightTxt=sWeightFormat;
					 	dpLoad.color(3);
					 	double dDisplaceText=-12;
					 	PLine plRecTxt;
			 			PlaneProfile ppRecTxt;
			 			double dFrameThick=U(4);
			 			{ 
//							dpLoad.draw(sWeightTxt,ptTxt,vecX,vecY,0,dDisplaceText);
							dpLoad.draw(sWeightTxt,ptTxt,_XW,_YW,0,dDisplaceText);
							double _dTxtH=dpLoad.textHeightForStyle(sWeightTxt,"Standard",dTxtH);
							double _dTxtL=dpLoad.textLengthForStyle(sWeightTxt,"Standard",dTxtH);
							double dRectH=1.5*_dTxtH, dRectL=.5*_dTxtH+_dTxtL;
							
							plRecTxt.createRectangle(LineSeg(ptTxt-vecX*.5*dRectL-vecY*.5*dRectH,
								ptTxt+vecX*.5*dRectL+vecY*.5*dRectH),vecX,vecY);
							plRecTxt.transformBy(vecY*_dTxtH*dDisplaceText*.5);
							ppRecTxt=PlaneProfile(plRecTxt);
							PlaneProfile ppRecTxtSub=ppRecTxt;
							ppRecTxt.shrink(-0.5*dFrameThick);
							ppRecTxtSub.shrink(0.5*dFrameThick);
							ppRecTxt.subtractProfile(ppRecTxtSub);
						}
						dpLoad.draw(plRecTxt);
						dpLoad.draw(ppRecTxt,_kDrawFilled);
//					 	dpLoad.draw(sWeightTxt,ptTxt,vecX,vecY,0,dDisplaceText);
					 	dpLoad.draw(sWeightTxt,ptTxt,_XW,_YW,0,dDisplaceText);
					}
				}
			}
		}
	//End Axle Load calculation + Display//endregion

	//region PlotViewport Management

	//plot viewport for KLH HSB-18847: 
		if(bIsKlh)
		{ 
			String sTriggerGeneratePlotViewPort=T("|Generate Plot ViewPort|");
			if(true)
				addRecalcTrigger(_kContextRoot,sTriggerGeneratePlotViewPort);
			if (_bOnRecalc && (_kExecuteKey==sTriggerGeneratePlotViewPort) || bDebug)
			{ 
			// cleanup the existing plotviewports
				for (int ipl=plots.length()-1;ipl>=0;ipl--)
				{ 
					plots[ipl].dbErase();
				}//next ipl
//				sType
				ppSectionAll.vis(1);
//				if(!plot.bIsValid())
				{ 
					String entryNames[]=Layout().getAllEntryNames();
					String layoutNames[0];
					double lengths[0];
			
					for (int i=0;i<entryNames.length();i++) 
					{ 
						String s1=entryNames[i].left(1);
						String s2=entryNames[i].right(2);
						double d2=s2.atof()*1000; // convert to mm
						if (s1.makeLower()=="f")
						{
							layoutNames.append(entryNames[i]);
							lengths.append(d2);
						}
					}//next i
				// order by length
					for (int i=0;i<layoutNames.length();i++) 
						for (int j=0;j<layoutNames.length()-1;j++)
							if (lengths[j]>lengths[j+1])
							{
								layoutNames.swap(j,j+1);
								lengths.swap(j,j+1);
							}
					Layout layout;
					layout=Layout(layoutNames[0]);
					if (layout.bIsValid())
					{
						Point3d ptPV=_Pt0-vecX*U(-3755)-vecY*U(1550);
						if(nType==1)ptPV=_Pt0-vecX*U(-3755)-vecY*U(1550);
						PlotViewport plot;
						if (!bDebug)plot.dbCreate(layout.entryName(),ptPV);
						if (plot.bIsValid())
						{
//							plot.setName(master.formatObject(sFormatPlot));
							String sNamePlotViewport;
							sNamePlotViewport.format("%02i",nNumber);
							plot.setName(sNamePlotViewport);
//							plot.transformBy(vecY*plot.dY());
							if(_Entity.find(plot)<0)
							{
								_Entity.append(plot);
								setDependencyOnEntity(plot);
							}
						}
					}
				}
			// create plotviewports for the sections
				String sLayoutName="f2";// horizontal stacking
				Point3d ptPVsections=_Pt0-vecX*U(-4198)-vecY*U(1550);
				if(nType==1)
				{
					sLayoutName="f3";
					ptPVsections=_Pt0-vecX*U(-7900)-vecY*U(1830);
				}
				ptPVsections-=vecY*(U(100));
				Layout layout;
				layout=Layout(sLayoutName);
				
			// get extents of profile
				LineSeg segSections=ppSectionAll.extentInDir(vecX);
				Point3d ptSectionsBottom=segSections.ptStart();
				if(vecY.dotProduct(segSections.ptStart()-segSections.ptEnd())>0)ptSectionsBottom=segSections.ptEnd();
				int nCount=1;
				for (int iplot=0;iplot<200;iplot++)
				{ 
					PlotViewport plot;
					if (!bDebug)plot.dbCreate(layout.entryName(),ptPVsections);
					plot.transformBy(-vecY*plot.dY());
					String sNamePlotViewport;
					sNamePlotViewport.format("%02i",nNumber);
					String sCount=nCount;
//					sCount.format("%02i",nCount);
					sNamePlotViewport+="_"+sCount;
					plot.setName(sNamePlotViewport);
					if(_Entity.find(plot)<0)
					{
						_Entity.append(plot);
						setDependencyOnEntity(plot);
					}
					ptPVsections-=vecY*(plot.dY()+U(100));
					nCount++;
					if(vecY.dotProduct(ptSectionsBottom-ptPVsections)>0)
						break;
				}//next isec
				
			// update f_items
				if(mapContourItem.getDouble("Thickness")>0)
				{ 
					reportMessage("\n"+scriptName()+" "+T("|Updating items|")+"...");
					for (int item=0;item<items.length();item++) 
					{ 
						TslInst tslItem=(TslInst)items[item];
						if(tslItem.bIsValid())
						{
							tslItem.recalc();
						}
					}//next item
				}
				// HSB-20735: cleanup existing pivots if found
				if(_Map.hasEntity("Pivot"))
				{ 
					Entity entPivot=_Map.getEntity("Pivot");
					entPivot.dbErase();
				}
			// HSB-20616: Create hsbPivotSchedule
			// create TSL
			// HSB-24486
//				Point3d ptPivot=_pt0+vecY*U(6000+5050)+vecX*U(18800);
				Point3d ptPivot=_Pt0-_XW*U(1688)+vecY*U(6000+6550);
				TslInst tslNew;	Vector3d vecXTsl=_XW; Vector3d vecYTsl=_YW;
				GenBeam gbsTsl[]={}; Entity entsTsl[0]; Point3d ptsTsl[]={ptPivot};
				int nProps[]={5,0,252}; 
				double dProps[]={U(150)}; 
				
				String sProps[]={T("|TslInstance|"),T("|as Collection|"),
				T("|<Disabled>|"),T("|Package weight|"),"P @(|Number|)","@(MapWeight.Weight:rl0) kg",""};
				Map mapTsl;
				for (int ii=0;ii<entPackages.length();ii++) 
				{ 
					TslInst tslI=(TslInst)entPackages[ii];
					if(tslI.bIsValid())
						entsTsl.append(tslI);
				}//next ii
				
				tslNew.dbCreate("hsbPivotSchedule",vecXTsl,vecYTsl,gbsTsl,entsTsl,
					ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);
				// HSB-20735
				_Map.setEntity("Pivot",tslNew);
			}
		}
	//End KLH plot viewport

	//General PlotViewports
		else
		{ 
			
			Map mapPlotViewports = mapSetting.getMap("PlotViewport[]");
			String sPlotLayoutName, sPlotViewFormat;
			double dXOffsetLayout, dYOffsetLayout;
			if (mapPlotViewports.hasMap(sKeyPlotViews))
			{ 
				Map m = mapPlotViewports.getMap(sKeyPlotViews);
				sPlotLayoutName = m.getString("plotLayoutName");
				sPlotViewFormat = m.getString("plotViewFormat");
				dXOffsetLayout = m.getDouble("XOffset");	
				dYOffsetLayout = m.getDouble("YOffset");			
				
				if (sPlotViewFormat.length()<1)
					sPlotViewFormat = sTruck;
			}
			
			
			int bCreatePV;
			
		//region Trigger DefinePlotViewport
			String sTriggerDefinePlotViewport = T("|Define Plot Viewport|");
			addRecalcTrigger(_kContext, sTriggerDefinePlotViewport );
			if (_bOnRecalc && _kExecuteKey==sTriggerDefinePlotViewport)
			{
				
				String entries[] = Layout().getAllEntryNames().sorted();
				if (entries.findNoCase(sPlotLayoutName,-1)<0)
					sPlotLayoutName = tDisabled;
				entries.insertAt(0, tDisabled);
				
				Map items;
				for (int i=0;i<entries.length();i++) 
				{
					String layoutName = entries[i];
					Layout layout(layoutName);
					
					Map item;
					
					item.setString("Text", entries[i]);
					if (layoutName!=tDisabled)
					{ 
						item.setString("ToolTip", T("|Size| ")+ layout.paperSizeX() +" x " + layout.paperSizeY() );						
					}

					item.setInt("IsSelected", Equals(layoutName, sPlotLayoutName));//__"Selected" key defines whether Map entries are initially selected. 0 = not selected, 1 = selected										
					items.appendMap("item", item);

				}
				
				int bCancel;
				Map mapIn;
				mapIn.setString("Prompt", T("|Select the layout to be used for automatic plot viewport generation.|"));
				mapIn.setString("Title", T("|Plot Viewport Generation|"));
				mapIn.setMap("Items[]", items);	
				Map mapOut = callDotNetFunction2(sDialogLibrary, sClass, listSelectorMethod, mapIn);

				if (mapOut.hasInt("SelectedIndex"))
				{ 
					int seletedIndex = mapOut.getInt("SelectedIndex");
					if (seletedIndex>-1)
					{ 
						sPlotLayoutName = entries[seletedIndex];

					}	
				}
				else
					bCancel = true;

	
				// copy from here ##--## 
				if (sPlotLayoutName!=tDisabled && !bCancel)
				{ 
					bCreatePV = true;
					PlotViewport pv;
					pv.dbCreate(sPlotLayoutName, _Pt0);
					double dXPlot = pv.dX();
					double dYPlot = pv.dY();	
					
					
					Layout layout(sPlotLayoutName);
					Point3d pt = layout.paperLowerLeft();
					
					double dXOffsetLayout = U(1000);
					double dYOffsetLayout = dRowOffset;
	
					// transform to model
					pt.transformBy((_Pt0-_XW*dXOffsetLayout-_YW*dYOffsetLayout)-_PtW);
					
					PlaneProfile pps[0];
					PlaneProfile pp;
					pp.createRectangle(LineSeg(pt, pt + _XW * dXPlot + _YW * dYPlot), _XW, _YW);
					pps.append(pp);
					if(bDebug){ Display dpx(1); dpx.draw(pp, _kDrawFilled, 20);}
					
					double dYOffsetLayoutRow = dCellHeight + dRowOffset;
					if (dYOffsetLayoutRow>0)
					{ 		
						int nRowsPerLayout = (dYPlot+dCellHeight)/(dCellHeight + dRowOffset);
						int nRowsLayouts = (double)nMaxRows / (double)nRowsPerLayout+.99;
	
						double dYRow0 = dRowOffsetTruck-2*dRowOffset;
						dYRow0+= + nRowsPerLayout * dYOffsetLayoutRow;
						dYRow0+=(dYPlot-(nRowsPerLayout*dRowOffset+(nRowsPerLayout-1)*dCellHeight))*.5;
						
						pp.transformBy(-_YW * dYRow0);
						pps.append(pp);
						if(bDebug){ Display dpx(20); dpx.draw(pp, _kDrawFilled, 20);}					
						
						for (int i=0;i<nRowsLayouts-1;i++) 
						{ 		
							pp.transformBy(-_YW * (nRowsPerLayout*dYOffsetLayoutRow));
							pps.append(pp);
							//if(bDebug)
							{ Display dpx(20); dpx.draw(pp, _kDrawFilled, 20);} 
						}//next i
		
					}
	
					pv.dbErase();
					
				//region PrPoint with Jig
					PrPoint ssP(T("|Select base point, <Enter> to use default location|"), pt); // second argument will set _PtBase in map

				    Map mapArgs = SetPlaneProfileArray(pps);
				   	mapArgs.setPoint3d("ptRef", pt);
				    int nGoJig = -1;
				    while (nGoJig != _kOk && nGoJig != _kNone)
				    {
				        nGoJig = ssP.goJig(kJigPV, mapArgs); 
				        if (bDebug)reportMessage("\ngoJig returned: " + nGoJig);
				        
				        if (nGoJig == _kOk)
				        {
				            pt = ssP.value(); //retrieve the selected point
							pt.setZ(0);
							
				        }
				        else if (nGoJig == _kCancel)
				        { 
				        	setExecutionLoops(2);
				            return;
				        }
				    }			
				//endregion 
	
				//Store Setup
					if (sPlotLayoutName!=tDisabled)
					{
						Map m;
						
						dXOffsetLayout = _XW.dotProduct(pt-_Pt0);
						dYOffsetLayout = _YW.dotProduct(pt-_Pt0);					
						
						m.setString("plotLayoutName", sPlotLayoutName);
						m.setString("plotViewFormat", "@("+sTruckName+")");
						m.setDouble("XOffset", dXOffsetLayout);
						m.setDouble("YOffset", dYOffsetLayout);
						mapPlotViewports.setMap(sKeyPlotViews, m);
						
						if (mo.bIsValid())
						{ 
							mapSetting.setMap("PlotViewport[]", mapPlotViewports);
							mo.setMap(mapSetting);
						}
					}	
				}
			}	

		// Debug: paste here ##--## 
		//endregion

		//region Trigger DefinePlotViewportFormat
			String sTriggerDefinePlotViewportFormat = T("|Define Plot Viewport Format|");
			if (sPlotLayoutName!="" && sPlotLayoutName!=tDisabled)
				addRecalcTrigger(_kContext, sTriggerDefinePlotViewportFormat );
			if (_bOnRecalc && _kExecuteKey==sTriggerDefinePlotViewportFormat)
			{


				Map mapIn;
				mapIn.setString("Prompt", T("|Specify format for viewports.|"));
				mapIn.setString("Title", T("|Plot Viewport Format|"));
				mapIn.setString("Alignment", "Left");//__"Left", "Center", "Right" supported. 
			 	mapIn.setString("PrefillText", sPlotViewFormat);//__optional, default is empty string
				//mapIn.setInt("PrefillIsSelected", 1);//__optional, default is false				
				Map mapOut = callDotNetFunction2(sDialogLibrary, sClass, simpleTextMethod, mapIn);
			
				sPlotViewFormat = mapOut.getString("Text");				

				Map m;
				m.setString("plotLayoutName", sPlotLayoutName);
				m.setString("plotViewFormat", sPlotViewFormat);
				m.setDouble("XOffset", dXOffsetLayout);
				m.setDouble("YOffset", dYOffsetLayout);
				mapPlotViewports.setMap(sKeyPlotViews, m);
				
				if (mo.bIsValid())
				{ 
					mapSetting.setMap("PlotViewport[]", mapPlotViewports);
					mo.setMap(mapSetting);
				}

				String sName = _ThisInst.formatObject(sPlotViewFormat);
				for (int i=0;i<plots.length();i++) 
				{ 
					String name = sName;
					if (i>0)
						name += "_" + (i + 1);
					plots[i].setName(name); 
					 
				}//next i


				setExecutionLoops(2);
				return;
			}//endregion	
		



		//region Trigger CreatePlotViewports
			String sTriggerCreatePlotViewports = T("|Create Plot Viewports|");
			if (sPlotLayoutName!="" && sPlotLayoutName!=tDisabled)
				addRecalcTrigger(_kContextRoot, sTriggerCreatePlotViewports );
			if (_bOnRecalc && _kExecuteKey==sTriggerCreatePlotViewports)
			{
				bCreatePV=true;		
			}
			if (bCreatePV)
			{ 
				String entries[] = Layout().getAllEntryNames();
				if (entries.findNoCase(sPlotLayoutName,-1)<0)
				{
					bCreatePV = false;
					reportMessage(TN("|Could not find specified layout:| ") + sPlotLayoutName);
					
				}
			}
		
		
				
		
		
		
			
			if (bCreatePV)	
			{ 
			//Erase any existing plotview ports
				for (int i=plots.length()-1; i>=0 ; i--) 
				{ 
					if (plots[i].bIsValid())
						plots[i].dbErase(); 
					
				}//next i	
				
			// Create plot viewports
				PlotViewport pv;
				Point3d ptPV = _Pt0+ _XW * dXOffsetLayout + _YW * dYOffsetLayout;
				pv.dbCreate(sPlotLayoutName, ptPV);
				double dXPlot = pv.dX();
				double dYPlot = pv.dY();	
				
				Layout layout(sPlotLayoutName);

				double dXOffsetLayout = -U(1000);
				double dYOffsetLayout = -dRowOffset;

				String sName = _ThisInst.formatObject(sPlotViewFormat);
				pv.setName(sName);
				_Entity.append(pv);
				
				double dYOffsetLayoutRow = dCellHeight + dRowOffset;
				if (dYOffsetLayoutRow>0)
				{ 		
					int nRowsPerLayout = (dYPlot+dCellHeight)/(dCellHeight + dRowOffset);
					int nRowsLayouts = (double)nMaxRows / (double)nRowsPerLayout+.99;

					double dYRow0 = dRowOffsetTruck-2*dRowOffset;
					dYRow0+= + nRowsPerLayout * dYOffsetLayoutRow;
					dYRow0+=(dYPlot-(nRowsPerLayout*dRowOffset+(nRowsPerLayout-1)*dCellHeight))*.5;
					
					ptPV.transformBy(-_YW * dYRow0);
					pv.dbCreate(sPlotLayoutName, ptPV);
					pv.setName(sName+ "_1");
					_Entity.append(pv);
					
					for (int i=0;i<nRowsLayouts-1;i++) 
					{ 		
						ptPV.transformBy(-_YW * (nRowsPerLayout*dYOffsetLayoutRow));
						pv.dbCreate(sPlotLayoutName, ptPV);
						pv.setName(sName+ "_"+(i+2));
						_Entity.append(pv);
					}//next i
				}


				setExecutionLoops(2);
				return;				
			}
			else if (_bOnRecalc && _kExecuteKey==sTriggerDefinePlotViewport)
			{ 
				setExecutionLoops(2);
				return;					
			}
			
		//endregion	
		
	
		}

	//end PlotViewport Management //endregion 


	}
// END TRUCK MODE//endregion

//region Grid Mode
//#1 START GRID MODE ____________________________________________________________________________________________________
else if (nMode==1)
{
//region Validation
	_Map.setInt("isGrid",true);
	// get parent truck
	if (_Entity.length()<1)
	{
		if(bDebug)reportMessage("\n"+ scriptName()+" invalid entity reference");
		eraseInstance();
		return;
	}
	
// collect truck from entity
	TslInst truck;
	Map mapTruck;

// get the potential link to the truck entity
	for (int i=0;i<_Entity.length();i++) 
	{ 
		Entity e=_Entity[i]; 
		if (e.subMapXKeys().find(sTruckKey)>-1)
		{
			truck=(TslInst)e;
			mapTruck=truck.map();
			setDependencyOnEntity(truck);
			break;
		}
	}
	if (!truck.bIsValid())
	{
		if(bDebug)	reportMessage("\n"+ scriptName() + " invalid reference" + " " + _kExecutionLoopCount);
		eraseInstance();
		return;
	}	
//End Validation//endregion 	

//region Truck Data
// get truck data
	Map mapXTruck = truck.subMapX(sTruckKey);
	double dLength= mapXTruck.getVector3d("vecX").length();
	double dWidth= mapXTruck.getVector3d("vecY").length();
	double dHeight= mapXTruck.getVector3d("vecZ").length();	
		
// get truck type
	int nType = sTypes.find(truck.propString(1),0);
	_Map.setInt("type", nType);// publish for layers
	int nAlignment = _Map.getInt("Alignment");
	if (nAlignment==0)nAlignment=1;
	
// design properties	
	int nDesign = sDesigns.find(truck.propString(2),0);	
	
// get design map
	Map mapDesign;
	for (int i=0;i<mapDesigns.length();i++) 
	{ 
		Map m= mapDesigns.getMap(i); 
		String name = m.getString("Name");
		name.makeLower();
		if (name=="Closed Truck".makeLower() && nDesign==1)
			mapDesign = m;	 
		else if (name=="Container".makeLower() && nDesign==2)
			mapDesign = m;	
		else if (name=="Package".makeLower() && nDesign==3)
			mapDesign = m;				
	}
	
	if (mapDesign.length()>0)
	{ 
		String k;
		k="Color";			if(mapDesign.hasInt(k))		nColorDesign=mapDesign.getInt(k);
		k="Linetype";		if(mapDesign.hasString(k))	sLineTypeDesign=mapDesign.getString(k);
		k="LinetypeScale";	if(mapDesign.hasDouble(k))	dLineTypeScaleDesign=mapDesign.getDouble(k);
		k="DimStyle";		if(mapDesign.hasString(k))	sDimStyleDesign=mapDesign.getString(k);
		k="TextHeight";		if(mapDesign.hasDouble(k))	dTextHeightDesign=mapDesign.getDouble(k);
		k="DimOffset";		if(mapDesign.hasDouble(k))	dDimOffsetDesign=mapDesign.getDouble(k);
		k="SymbolOffset";	if(mapDesign.hasDouble(k))	dSymbolOffsetDesign=mapDesign.getDouble(k);
		k="Text";			if(mapDesign.hasString(k))	sTextDesign=mapDesign.getString(k);
	}	

// get horizontal edge offset of containers
	double dHorizontalEdgeOffset;
	if (nDesign == 2)
	{
		String k; 
		k="HorizontalEdgeOffset"; 	dHorizontalEdgeOffset=mapDesign.hasDouble(k)?mapDesign.getDouble(k):U(150);
	}

	Point3d ptSectionRef = mapTruck.getPoint3d("ptSectionRef");//?mapTruck.getPoint3d("ptSectionRef"):_Pt0;
	ptSectionRef.vis(2);
	Point3d _pt0=truck.ptOrg();
	CoordSys csKLHvertRot,csKLHvertSec;
	int bKLHhorTransform=(bIsKlh && nType==0);
	int bKLHverTransform=(bIsKlh && nType==1 && nAlignment==1);
	int bKLHver=(bIsKlh && nType==1);
	if(bKLHhorTransform)
	{ 
		// 
		CoordSys csKLH;
		csKLH.setToAlignCoordSys(truck.ptOrg(),vecX,vecY,vecZ,
			truck.ptOrg()+vecX*(dWidth+dColumnOffset+dLength),-vecX,vecY,-vecZ);
		
		_pt0.transformBy(csKLH);
		vecX.transformBy(csKLH);
		vecY.transformBy(csKLH);
		vecZ.transformBy(csKLH);
	}
	if (nDesign==3)
		_Pt0 = ptSectionRef + vecX * (dWidth + dColumnOffset);
	else
		_Pt0 = ptSectionRef+nAlignment*vecX*(.5*dWidth+dColumnOffset);
	Point3d ptRef = _Pt0;
	Point3d ptTruck = _pt0+vecX*(dColumnOffset+dWidth);
//	Point3d ptTruck = truck.ptOrg()+vecX*(dColumnOffset+dWidth);
	if(bKLHver)
	{ 
		ptTruck = truck.ptOrg();
	}
	ptTruck.vis(2);	
	
	// set cell width and height based on truck type
	double dCellHeight = nType==0?dWidth:dHeight;
	double dVisibleHeight= nType==0?dHeight:dWidth;
//HSB-18847: Change RowOffset for KLH; it is the distance top to top
	if(bIsKlh)
	{ 
		dRowOffset=dRowOffset-dCellHeight;
	}
	// set opmKey
	String sOpmKey = "Grid";
	setOPMKey(sOpmKey);
	
// bool the truck styles	
	int bIsHorizontalOpen = nType==0 && nDesign==0;
	int bIsHorizontalClosed= nType==0 && nDesign==1;
	int bIsHorizontalContainer= nType==0 && nDesign==2;
	int bIsVerticalOpen= nType==1 && nDesign==0;
	int bIsVerticalClosed= nType==1 && nDesign==1;
	int bIsVerticalContainer= nType==1 && nDesign==2;
	int bIsVerticalPackage= nType==1 && nDesign==3;
	int bIsHorizontalPackage= nType==0 && nDesign==3;
	
//End Truck Data//endregion 	

//region Trigger AddLayer
	// Trigger AddLayer
	String sTriggerAddLayer = T("|Add Layer|");
	addRecalcTrigger(_kContext, sTriggerAddLayer );
	if (_bOnRecalc && (_kExecuteKey==sTriggerAddLayer || _kExecuteKey==sDoubleClick))
	{	
	// get items
		Entity ents[0];
		PrEntity ssE(T("|Select item(s)|"), TslInst());
		if (ssE.go())
			ents.append(ssE.set());
		
	// validate items, remove invalid
		for (int i=ents.length()-1; i>=0 ; i--) 	
		{ 
			Entity ent = ents[i];
			Map m = ent.subMapX(sItemX);
			Entity entRef;
			entRef.setFromHandle(m.getString("MyUid"));
			if (!entRef.bIsValid())
				ents.removeAt(i);
		}

	// get bounds of items, lower left(or right) will be insertion point of the stacking layer
		PlaneProfile ppContour(csW);
		for (int i=0;i<ents.length();i++) 
		{ 
			PlaneProfile pp = ents[i].realBody().shadowProfile(pnZ); 
			PLine plRings[] = pp.allRings();
			int bIsOp[] = pp.ringIsOpening();
			for (int r=0;r<plRings.length();r++)
				if (!bIsOp[r])
					ppContour.joinRing(plRings[r],_kAdd);
		}
		
	// get extents of profile
		LineSeg seg = ppContour.extentInDir(vecX);
		double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
		double dY = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
		
	// set insertion point
		Point3d ptInsert=seg.ptMid()-.5*(nAlignment*vecX*dX+vecY*dY);
	// identify row by insert offset
		double d1 = vecY.dotProduct(_Pt0-ptInsert)-(dRowOffsetTruck-dRowOffset)-dEps;
		int nCurrentRow=-1;
		if (dCellHeight>0)nCurrentRow = d1/(dCellHeight+dRowOffset);
		
	// preset bedding height //region
		double dBeddingHeight;
		
	// request bedding height override for horizontal stacking
		if (nType==0)
		{
		// logger
			int bLogger;//=true;
			
		// get bedding heights which are already set with this instance
			Map m = _Map.getMap("RowBeddings");
			if(bLogger)reportMessage("\n\n*****Row Bedding of row " + nCurrentRow+" ****\n"+m + "\n");
		// preset bedding height
			if (nCurrentRow>-1)
			{
			// current height
				if (m.hasDouble(nCurrentRow))
				{
					dBeddingHeight = m.getDouble(nCurrentRow);
					if(bLogger)reportMessage("\ncurrent height "+dBeddingHeight);
				}
					
			// default height: take indexed entry or last available
				else if (nCurrentRow>-1 && dBeddingHeights.length()>0)
				{
					dBeddingHeight=dBeddingHeights[nCurrentRow<dBeddingHeights.length()?nCurrentRow:dBeddingHeights.length()-1];
					if(bLogger)reportMessage("\ncurrent default height "+dBeddingHeight);
				}
			}
			
		// prompt for bedding height
			String sInput=getString(T("|<Enter> to insert with bedding height|")+ " " +" [" + dBeddingHeight+"]");
			double dNewElevation= sInput.atof();	
			String sCheckInput = dNewElevation;
			if(sInput==sCheckInput) 
			{
				dBeddingHeight=dNewElevation;
				if(bLogger)	reportMessage("\nvalid input bedding height " +dBeddingHeight);
			}
			
		// setAdd bedding of current row
			m.setDouble(nCurrentRow, dBeddingHeight);
			if(bLogger)reportMessage("\n\nrow " + nCurrentRow+" = " + dBeddingHeight+"\n*************\n");
			_Map.setMap("RowBeddings",m);	
		}
		//endregion
		
	// create stacking layer
		if (ents.length()>0)
		{
			// debug logging
			if(bDebug)reportMessage("\n"+ scriptName() + " " + ents.length() + " items collected to create a new layer.");
			
			// prepare tsl cloning
			TslInst tslNew;
			Vector3d vecXTsl= _XW;
			Vector3d vecYTsl= _YW;
			GenBeam gbsTsl[] = {};
			Entity entsTsl[] = {};
			Point3d ptsTsl[] = {};
			int nProps[]={};
			double dProps[]={};
			String sProps[]={sNesterTypes[0]}; // insert with no nesting, optional nesting to be triggered remotly
			Map mapTsl;	
			String sScriptname = sScriptLayer;
			
			ptsTsl.append(ptInsert);
			entsTsl = ents;
			
			tslNew.dbCreate(sScriptname , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
				nProps, dProps, sProps,_kModelSpace, mapTsl);
				
			// set parent relation
			if(tslNew.bIsValid())
			{ 
				tslNew.setPropValuesFromCatalog(tLastInserted);
				tslNew.setPropDouble(0,dBeddingHeight);
				Map m;
				m.setString("MyUid", sMyUID);//truck.handle());//
				m.setPoint3d("ptOrg", _Pt0, _kRelative);
				m.setVector3d("vecX", vecX*dLength, _kScalable); // coordsys could carry size
				m.setVector3d("vecY", vecY*dWidth, _kScalable);
				m.setVector3d("vecZ", vecZ*dHeight, _kScalable);
				//m.setMap("PackageData", mapData);
				tslNew.setSubMapX(sGridKey,m);// (over)write submapX
				
			// force to be nested
				if (tslNew.propString(0)!=sNesterTypes[0])
				{ 
					Map map = tslNew.map();
					map.setInt("callNester", true);
					tslNew.setMap(map);
				}
				
				_Entity.append(tslNew);
				//if(bDebug)
					reportMessage("\n"+ scriptName() + ": " + tslNew.scriptName() + " created wih key " + sGridKey + ": " + m);	
					
			// set parent key to items
				{ 
					Map m;
					m.setString("MyUid", tslNew.handle());//layer.handle());//
					m.setPoint3d("ptOrg", tslNew.ptOrg(), _kRelative);
					m.setVector3d("vecX", vecX*dLength, _kScalable); // coordsys could carry size
					m.setVector3d("vecY", vecY*dWidth, _kScalable);
					m.setVector3d("vecZ", vecZ*dHeight, _kScalable);					
					for (int i=0;i<ents.length();i++) 
					{ 
						ents[i].setSubMapX("Hsb_LayerParent", m); 
						ents[i].transformBy(Vector3d(0,0,0)); 
					}//next i
				}	
			}		
		}
		
		if (truck.bIsValid())
			truck.recalc();
			
		setExecutionLoops(2);
		return;
	}	

//End Trigger AddLayer//endregion 

// add remote new layer when layer was dragged into me
	if (_Map.hasEntity("newLayer"))
	{ 
		_Entity.append(_Map.getEntity("newLayer"));
		_Map.removeAt("newLayer", true);
		if (truck.bIsValid())
			truck.recalc();
	}
	
// collect layers
	TslInst layers[0];
	Map mapLayers[0];
	PlaneProfile ppLayers[0];
	for (int i=_Entity.length()-1; i>=0 ; i--) 
	{ 
		TslInst layer = (TslInst)_Entity[i]; 
		if (!layer.bIsValid())continue;
		Map mapLayer = layer.map();
		// validate layer
		if (mapLayer.getInt("isLayer") && (_ThisInst.handle() == layer.subMapX(sGridKey).getString("MyUid") || bDebug))
		{
			setDependencyOnEntity(layer);
			layers.append(layer);
			mapLayers.append(mapLayer);
			ppLayers.append(PlaneProfile(layer.map().getPLine("plContour")));
		}
	}
	
	// collect layer origins
	Point3d ptsLayers[0];
	for (int i=0;i<layers.length();i++)
		ptsLayers.append(layers[i].ptOrg());	
	
	// calculate grid size
	double dYRow = dRowOffset+(nType==0?dWidth:dHeight);
	ptsLayers = lnY.orderPoints(ptsLayers);
	int nNumRows=1, nNumColumns=1;//nType+1;
	if (ptsLayers.length()>0) // get total height to get num of rows
	{
		double dDist = vecY.dotProduct(_Pt0-ptsLayers[0])-dEps -(1.5*dRowOffsetTruck-dRowOffset);
		if(dYRow>0) nNumRows=dDist/dYRow+2;	
	}	

//region Trigger
// Trigger ShowHideInterferenceTest
	int bShowInterference = _Map.getInt("ShowInterference");
	String sTriggerShowInterference= bShowInterference?T("|Hide interferences|") + " (" + T("|Default|") + ", " + T("|faster|") + ")":T("|Show interferences|");
	addRecalcTrigger(_kContext, sTriggerShowInterference );
	if (_bOnRecalc && _kExecuteKey==sTriggerShowInterference)
	{
		if (bShowInterference)
			bShowInterference=false;
		else
			bShowInterference=true;
		_Map.setInt("ShowInterference",bShowInterference);	
		//truck.transformBy(Vector3d(0,0,0));
	}

// Trigger ShowHideContactPlanes
	int bShowContact = _Map.getInt("ShowContact");
	String sTriggerShowContact= bShowContact?T("|Hide contact faces|") + " (" + T("|Default|") + ", " + T("|faster|") + ")":T("|Show contact faces|");
	addRecalcTrigger(_kContext, sTriggerShowContact );
	if (_bOnRecalc && _kExecuteKey==sTriggerShowContact)
	{
		if (bShowContact)
			bShowContact=false;
		else
			bShowContact=true;
		_Map.setInt("ShowContact",bShowContact);	
		//truck.transformBy(Vector3d(0,0,0));
	}
	
// Trigger HideRow
	int bHideExtraRow = _Map.getInt("HideExtraRow");
	String sTriggerHideRow= bHideExtraRow?T("|Show additional row|"):T("|Hide additional row|");
	
	if(bIsKlh)addRecalcTrigger(_kContextRoot, sTriggerHideRow );
	else addRecalcTrigger(_kContext, sTriggerHideRow );
	if (_bOnRecalc && _kExecuteKey==sTriggerHideRow)
	{
		if (bHideExtraRow)
			bHideExtraRow=false;
		else
			bHideExtraRow=true;
		_Map.setInt("HideExtraRow",bHideExtraRow);	
		truck.transformBy(Vector3d(0,0,0));
	}
	if (bHideExtraRow)
	{
		nNumRows--;
	}
	
// Trigger AddBeddingGrid
	if (nType==0)
	{ 
		String sTriggerAddBeddingGrid=T("|Add Bedding Grid|");	
		addRecalcTrigger(_kContext, sTriggerAddBeddingGrid);
		if (_bOnRecalc && _kExecuteKey==sTriggerAddBeddingGrid)
		{
		// prepare tsl cloning
			TslInst tslNew;
			Vector3d vecXTsl=_XW;
			Vector3d vecYTsl=_YW;
			GenBeam gbsTsl[]={}; Entity entsTsl[]={_ThisInst}; Point3d ptsTsl[]={_Pt0};
			int nProps[]={}; double dProps[]={}; String sProps[]={};//
			Map mapTsl;
			String sScriptname=sScriptBeddingGrid;
			
			mapTsl.setInt("GridSpaces", getInt(T("|Specify grid spaces (4...14)|")));
			
			if (dBG_EdgeOffset>0)
				dProps.append(dBG_EdgeOffset);
				
			tslNew.dbCreate(sScriptname,vecXTsl,vecYTsl,gbsTsl,entsTsl,ptsTsl, 
				nProps,dProps,sProps,_kModelSpace,mapTsl);
		}
	}
	
//End Trigger//endregion 
		
// create additional symbol closed truck
	PLine plClosedSymbol(vecZ);
	if (nDesign==1)
	{ 
		String key;
		key="MinLengthTopCover"; double dMinLengthTopCover=mapDesign.hasDouble(key)?mapDesign.getDouble(key):U(2500);
		key="NumArcsTopCover"; 	 int nNumArcsTopCover=mapDesign.hasInt(key)?mapDesign.getInt(key):20;
		double dX = dMinLengthTopCover/nNumArcsTopCover;
		plClosedSymbol.addVertex(_Pt0);
		for (int i=0;i<nNumArcsTopCover;i++) 
		{ 
			plClosedSymbol.addVertex(_Pt0+nAlignment*vecX*(i+1)*dX,.6*(i%2==1?1:-1));
		}
	}
	
// create layering grid, default is one additional empty cell to be attached
	Map mapCells, mapCell;
	PlaneProfile ppGrid(csW), ppHead(csW);
	Point3d ptsGrid[0], ptGrid = _Pt0-vecY*(dRowOffsetTruck+dCellHeight);
	if(bKLHverTransform)
	{ 
		csKLHvertRot.setToRotation(180,_YW,ptGrid+_XW*.5*dLength);
	}
	if(bKLHverTransform || bKLHver)
	{ 
		csKLHvertSec.setToTranslation(_XW*(dLength+2*U(2200)));
	}
	// HSB-24206
	String sDesign=truck.propString(sDesignName);
	String sTruck=truck.propString(sTruckName);
	Map mapFrontDistance;
	int bMapFrontDistance;
	if(mapFrontDistances.length()>0)
	{ 
		// HSB-24206: find map
		mapFrontDistance=getMapForDesign(mapFrontDistances,sDesign,nType,sTruck);
		bMapFrontDistance=(mapFrontDistance.length()>0);
	}
	for (int i=0;i<nNumRows;i++) 
	{ 
		ptsGrid.append(ptGrid);
		pl.createRectangle(LineSeg(ptGrid,ptGrid+nAlignment*vecX*dLength+vecY*dCellHeight),vecX,vecY);
		ppGrid.joinRing(pl,_kAdd);//ptGridRef.vis(4);
		
		PLine plHead(vecZ);
		plHead.createRectangle(LineSeg(ptGrid,ptGrid-nAlignment*vecX*dThicknessHeadBoard+vecY*dCellHeight),vecX,vecY);
		ppHead.joinRing(plHead,_kAdd);//ptGridRef.vis(4);
		
		if(bMapFrontDistance)
		{
			// HSB-24206
			Point3d ptBlock=ptGrid+.5*vecY*dCellHeight;
			ptBlock.vis(2);
			if(bKLHverTransform)
			{ 
				// HSB-24277
				ptBlock.transformBy(csKLHvertRot);
			}
			String sBlockName=mapFrontDistance.getString("BlockName");
			
			int bBlockFound=true;
			int nBlockIndex=_BlockNames.findNoCase(sBlockName ,- 1);
			if( nBlockIndex< 0)
			{
				bBlockFound=false;
				String files[]=getFilesInFolder(sBlockPath);
				String fileName=sBlockName;
				if (files.findNoCase(fileName+".dwg",-1)>-1)
				{
					sBlockName=sBlockPath+"\\" + fileName + ".dwg";
					bBlockFound=true;
				}
			}
			else
			{ 
				// 
				sBlockName=_BlockNames[nBlockIndex];
			}
			if(bBlockFound)
			{ 
				Block block(sBlockName);
				Display dpBlock(7);
				dpBlock.draw(block,ptBlock,_XW,_YW,_ZW);
			}
		}

	// draw vertical texts if defined
		if (nType==1 && nDesign!=3 && mapVerticalType.length()>0)
		{ 
			String sTxt = nAlignment<0?T(mapVerticalType.getString("LeftText")):T(mapVerticalType.getString("RightText"));
			Point3d ptTxt=ptGrid-vecX*nAlignment*(dThicknessHeadBoard);
			if (mapVerticalType.getInt("IsVertical"))
				ptTxt=ptGrid-vecX*nAlignment*(dThicknessHeadBoard);
			else
				ptTxt=ptGrid-vecX*nAlignment*(dThicknessHeadBoard);
			if(bKLHverTransform)
			{ 
				// HSB-24432: Fix text position
				ptTxt.transformBy(csKLHvertRot);
			}
//			dpGrid.draw(sTxt,ptTxt,vecY,-vecX,1,nAlignment*1.2);
			if (mapVerticalType.getInt("IsVertical"))
			{
				if(bKLHverTransform)
				{ 
					dpGrid.draw(sTxt,ptTxt,vecY,-vecX,1,-nAlignment*1.2);
				}
				else
				{
					dpGrid.draw(sTxt,ptTxt,vecY,-vecX,1,nAlignment*1.2);
				}
			}
			else
			{
				dpGrid.draw(sTxt,ptTxt,vecX,vecY,-nAlignment*1.2,1);
			}
//			if (mapVerticalType.getInt("IsVertical"))
//				dpGrid.draw(sTxt,ptGrid-vecX*nAlignment*(dThicknessHeadBoard),vecY,-vecX,1,nAlignment*1.2);
//			else
//				dpGrid.draw(sTxt,ptGrid-vecX*nAlignment*(dThicknessHeadBoard),vecX,vecY,-nAlignment*1.2,1);
		}
		
		// store cell
		mapCell.setPoint3d("ptOrg", ptGrid);
		mapCell.setPLine("plContour", pl);
		mapCell.setInt("row", i);
		mapCell.setInt("column", 0);// redundant, but kept from previous versions
		mapCells.appendMap("Cell", mapCell);
		
		// draw stancion contact areas in first row
		if (nType==1 && mapStancions.length()>0 && i==0 && !bIsVerticalContainer && !bIsVerticalPackage)//nDesign!=2)
		{
			double dH=mapStancions.getDouble("Height");
			for (int k=0;k<mapStancions.length();k++) 
			{ 
				Map m=mapStancions.getMap(k);
				if (m.length()>0)
				{
					Point3d ptLoc=ptGrid+nAlignment*vecX*m.getDouble("Location");
					double dL=m.getDouble("Length");
					
					pl.createRectangle(LineSeg(ptLoc,ptLoc+nAlignment*vecX*dL+vecY*dH),vecX,vecY);
					if(bKLHverTransform)
					{ 
						// HSB-24432: Fix text position
						pl.transformBy(csKLHvertRot);
					}
					dpStancion.draw(PlaneProfile(pl),_kDrawFilled,nTransparencyStancion);
				}
			}	
		}
		
	// draw  graphics for any closed truck (if defined)
		if (nDesign==1 && plClosedSymbol.length()>0)
		{ 
			Point3d pt = ptGrid+vecY*(dCellHeight+dSymbolOffsetDesign);
			plClosedSymbol.transformBy(pt-plClosedSymbol.ptStart());
			PLine plClosedSymbolOrig=plClosedSymbol;
			if(bKLHverTransform)
			{ 
				plClosedSymbol.transformBy(csKLHvertRot);
			}
			Display dp(nColorDesign);
			dp.dimStyle(sDimStyleDesign);
			dp.textHeight(dTextHeightDesign);
			dp.draw(plClosedSymbol);
			
			Point3d pts[]={plClosedSymbol.ptStart(),plClosedSymbol.ptEnd()};
			plClosedSymbol=plClosedSymbolOrig;
			DimLine dl(pts[0]+vecY*dDimOffsetDesign, vecX, vecY);
			if(bIsKlh)
			{ 
				dl=DimLine (pts[0]+vecY*dDimOffsetDesign, _XW, _YW);
			}
			Point3d ptsDim[]={pts[0],pts[1]};
			Dim dimA(dl,ptsDim, T(sTextDesign)+" <>", "<>", _kDimClassic, _kDimNone);
			dp.draw(dimA);
	
		}
		ptGrid.transformBy(-vecY*dYRow);
	} 

// draw truck head boards, set grid display first
	dpGrid.color(nColorHeadBoard);
	dpGrid.lineType(sLineTypeHeadBoard, dLineTypeScaleHeadBoard);
	if(bKLHverTransform)
	{ 
		ppHead.transformBy(csKLHvertRot);
	}
	dpGrid.draw(ppHead,_kDrawFilled,nTransparencyHeadBoard);
	
// draw truck layering grids, set grid display first
	dpGrid.color(nColorGrid);
	dpGrid.lineType(sLineType, dLineTypeScale);
	if(bKLHverTransform)
	{ 
		ppGrid.transformBy(csKLHvertRot);
	}
	dpGrid.draw(ppGrid);	
	
// remove any layer not intersecting the grid
	int bPurged;
	for (int i=ppLayers.length()-1; i>=0 ; i--) 
	{ 
		PlaneProfile pp=ppLayers[i];
		pp.intersectWith(ppGrid);
		if (pp.area()<pow(dEps,2))
		{
			bPurged=true;
			int n=_Entity.find(layers[i]);
			layers[i].removeSubMapX(sGridKey);
			_Entity.removeAt(n);
		}
	}
	if (bPurged)
	{
		setExecutionLoops(2);
		return;
	}	
	
// assign layers to grid cells
	for (int i=0;i<layers.length();i++)	
	{
		TslInst layer = layers[i];
		Map mapLayer = layer.map();
		Point3d ptLayer = layer.ptOrg(); //ptLayer.vis(i);
		
		// default allocation
		int bInGrid =ppGrid.pointInProfile(ptLayer)!=_kPointOutsideProfile; 
		//if(bDebug)reportMessage("\n"+ scriptName() + " layer " + i + " bInGrid "+bInGrid  + " " + mapCells.length() + " cells");
		
	// loop cells
		for (int c=0;c<mapCells.length();c++) 
		{ 
			Map m = mapCells.getMap(c);
			int row = m.getInt("row");
			int column = m.getInt("column");
			PlaneProfile ppCell(csW);
			ppCell.joinRing(m.getPLine("plContour"),_kAdd);
			//ppCell.vis(2);ptLayer.vis(3);
			int bFound;
			// default find by origin
			if (bInGrid && ppCell.pointInProfile(ptLayer)!=_kPointOutsideProfile)
				bFound=true;
				// find by intersection
			else
			{
				ppCell.intersectWith(PlaneProfile(mapLayer.getPLine("plContour")));
				bFound = ppCell.area()>pow(dEps,2);
			}
			
			// store row and column against layer
			if (bFound)
			{
				int nLayerRow = mapLayer.hasInt("row")?mapLayer.getInt("row"):-1;
				int nLayerCol = mapLayer.hasInt("column")?mapLayer.getInt("column"):-1;	
				
				//if (nLayerRow!=row || nLayerCol!=column || bAddCellOrg==true);
				{
					//					if(bDebug)reportMessage("\n"+ scriptName() + " updating cell information of Layer " + layer.handle() +
					//						"\n		row " + nLayerRow+"/"+row+
					//						"\n		column " + nLayerCol+"/"+column);
					mapLayer.setInt("row", row);
					mapLayer.setInt("column", column);
					mapLayer.setVector3d("vecCellOrg", m.getPoint3d("ptOrg")-_PtW);
					layer.setMap(mapLayer);
				}	
				break;
			}			
		}// next c
	}// next i	
	
	if(bIsKlh)
	{ 
		// HSB-22320
		Map mapXtsl;// contains handle for top and bottom panel
		mapXtsl.setString("BottomPanel","!_Unterste Verlade-Ebene_!");
		mapXtsl.setString("TopPanel","-Oberste Verlade-Ebene-");
		_ThisInst.setSubMapX("InternalMapX",mapXtsl);
	}
	// HSB-22320
	if(bIsKlh)
	{ 
		// get smallest, largest layer number
		int nLayerSmallest=10e6;// bottom
		int nLayerLargest=-10e6;// top
		for (int l=0;l<layers.length();l++) 
		{ 
			TslInst layer = layers[l];
			if (!layer.bIsValid())continue;
			Map mapLayer = layer.map();
			int rowLayer = mapLayer.getInt("row");
			if(rowLayer<nLayerSmallest)
			{ 
				nLayerSmallest=rowLayer;
			}
			if(rowLayer>nLayerLargest)
			{ 
				nLayerLargest=rowLayer;
			}
		}
		for (int l=0;l<layers.length();l++) 
		{ 
			TslInst layer = layers[l];
			if (!layer.bIsValid())continue;
			Map mapLayer = layer.map();
			int rowLayer = mapLayer.getInt("row");
			int colLayer = mapLayer.getInt("column");
			Entity entItems[] = layer.entity();
			//
			// HSB-22361: 
//			if(rowLayer!=0 && rowLayer!=layers.length()-1)
//			{ 
//				// not bottom, not top
//				continue;
//			}
			for (int e = 0; e < entItems.length(); e++)
			{
				// 
				TslInst item = (TslInst)entItems[e];
				
				// get sip from item
				Entity entsItem[]=item.entity();
				for (int ee=0;ee<entsItem.length();ee++) 
				{ 
					Entity entEe=entsItem[ee];
					Sip sE=(Sip)entEe;
					if(sE.bIsValid())
					{ 
						// skip if package information is available 
						// package has priority
						Map mxStacking=sE.subMapX("StackingData");
						if(mxStacking.hasInt("PACKAGE NUMBER"))
						{ 
							if(mxStacking.getInt("PACKAGE NUMBER")>-1)
							{ 
								continue;
							}
						}
						// sip
//						if(rowLayer==0)
						if(rowLayer==nLayerSmallest)
						{ 
							// first, Bottom
							// attach the tsl
							Map mapXdata;
							mapXdata.setEntity(kScript,_ThisInst);
							sE.setSubMapX("BOTTOMPANEL",mapXdata);
						}
						else
						{ 
							sE.removeSubMapX("BOTTOMPANEL");
						}
//						if(rowLayer==layers.length()-1)
						if(rowLayer==nLayerLargest)
						{ 
							// last, top
							Map mapXdata;
							mapXdata.setEntity(kScript,_ThisInst);
							sE.setSubMapX("TOPPANEL",mapXdata);
						}
						else
						{ 
							sE.removeSubMapX("TOPPANEL");
						}
					}
				}//next ee
			}
		}//next l
	}
	// HSB-22499
	Map mapCellBodies;
	Map mapCellBodiesCombi;
	Body bdCells[mapCells.length()];
	Vector3d vecItem2Layers[mapCells.length()]; // transformation vectors from item 2 layer for KLH
	// HSB-24830: store transformation for each layer separately. in one row can be multiple layers with different bedding thickness
	Vector3d vecItem2LayersAll[layers.length()]; // transformation vectors from item 2 layer for KLH
	Body bdCellsCombi[mapCells.length()];// HSB-23341
	Body bdCumulatedCells[mapCells.length()];
	Point3d ptsCells[0];
	Map mapCells2;
	
	Vector3d vecXc=vecX,vecYc=vecY,vecZc=vecZ;
	if(bKLHhorTransform)
	{ 
		vecX=_XW;
		vecY=_YW;
		vecZ=_ZW;
	}
	for (int j=0;j<mapCells.length();j++) 
	{ 
		Map cell = mapCells.getMap(j);
		int row = cell.getInt("row");
		int col = cell.getInt("column");
		Point3d ptOrg = cell.getPoint3d("ptOrg");//ptOrg.vis(6);
		
		ptsCells.append(ptOrg);
		
		ptOrg.transformBy(vecX*vecX.dotProduct(_Pt0-ptOrg));//ptOrg.vis(222);
		Body bdCell;
		Body bdCellCombi;// HSB-23341
		if(bDebug)reportMessage("\n	"+ " searching layers in row "+ row +  ", column "+ col);
		
		Entity entCellItems[0]; // collector of all items of this cell
		Entity entCellItemsCombi[0]; // collector of all combi items of this cell
		
		Map mCellBodyI;
		Map mCellBodyICombi;// HSB-23341
		Vector3d vecItem2Layer;
		for (int i=0;i<layers.length();i++)	
		{
			Point3d ptCell = cell.getPoint3d("ptOrg");
			TslInst layer = layers[i];
			if (!layer.bIsValid())continue;
			Map mapLayer = layer.map();
			int rowLayer = mapLayer.getInt("row");
			int colLayer = mapLayer.getInt("column");
			//HSB-22499
			Body bdsI[0];
			Body bdsICombi[0];// HSB-23341
			if (row==rowLayer && col == colLayer)
			{
				//layer.ptOrg().vis(j);
				if(bDebug)reportMessage("\n		layer found "+ layer.handle());

			// collect items by Layer
				Body bdLayer;
				//HSB-23341
				Body bdLayerCombi;
				Entity entItems[] = layer.entity();
				for (int e=0;e<entItems.length();e++)
				{
					TslInst item = (TslInst)entItems[e];
					int bIsCombiItem;
					if(bIsKlh)
					{
						bIsCombiItem=isCombiItem(item);
					}
					Body bd = entItems[e].realBody();//	bd.vis(e);
					bdsI.append(bd);
					if(bIsCombiItem)
					{ 
						bdsICombi.append(bd);
					}
					
					if (bd.volume()>pow(dEps,3))
					{
						if (bdLayer.volume()<pow(dEps,3))
							bdLayer = bd;
						else
							bdLayer.combine(bd);// 5.7 until 5.6 combine() -> since 6.3 combine
						
						if(bIsKlh && bIsCombiItem)
						{ 
							if (bdLayerCombi.volume()<pow(dEps,3))
								bdLayerCombi = bd;
							else
								bdLayerCombi.combine(bd);// 5.7 until 5.6 combine() -> since 6.3 combine
						}
				//bdLayer.vis(2);	
					// collect items of cell
						if (entCellItems.find(item)<0)
						{
							entCellItems.append(item);			
						}
						// HSB-23341
						if(bIsKlh && bIsCombiItem)
						{ 
							if (entCellItemsCombi.find(item)<0)
							{
								entCellItemsCombi.append(item);			
							}
						}
					}
				}
				//bdLayer.vis(4);

			// evaluate/get layer grip location
				Point3d ptLGrip;
				if (row>0)
				{ 
					
				// horizontal package stacking		
					if (bIsHorizontalPackage)
						ptLGrip=ptOrg-vecX*dColumnOffset;
				// any other horizontal	
					else  if (nType==0)
						ptLGrip=ptOrg-vecX*dColumnOffset;//+vecX*(vecX.dotProduct(_Pt0-ptOrg)+.5*dWidth);
				// vertical container stacking		
					else if (bIsVerticalContainer)
						ptLGrip=ptOrg+vecX*(vecX.dotProduct(ptSectionRef-ptOrg)+nAlignment*(.5*dWidth-dHorizontalEdgeOffset));						
				// vertical package		
					else if (bIsVerticalPackage)
						ptLGrip=ptOrg+vecX*(vecX.dotProduct(ptSectionRef-ptOrg));//+(dWidth));	
				// vertical open or closed truck	
					else if (nType==1)
						ptLGrip=ptOrg+vecX*(vecX.dotProduct(ptSectionRef-ptOrg)+nAlignment*.5*dStancionWidth);
						
					ptLGrip.vis(2);		
//				// get offset defined by cumulated
					if (bDebug)
					{	
						Body bdInt(mapLayer.getPLine("plContour"),vecZ*U(2e4),0);
						Body bdCum= bdCumulatedCells[j-1];
						bdCum.transformBy(-vecY*(dRowOffset+dCellHeight));				
//bdCum.vis(j+i);			
						Point3d pts[0]; 	
						Body lumps[] = bdCum.decomposeIntoLumps();	
						Vector3d vecStack = (nDesign==3 || nType == 0) ?vecZ :nAlignment*vecX;
						for (int ii=0;ii<lumps.length();ii++) 
						{ 
							lumps[ii].intersectWith(bdInt);
//							lumps[ii].vis(4);  
							pts.append(lumps[ii].extremeVertices(vecZ));
						}//next ii
						
						pts = Line(_Pt0, vecZ).orderPoints(pts, dEps);
						if (pts.length()>0)
						{ 
						// horizontal package stacking		
							if (bIsHorizontalPackage)	
							{
								vecStack.vis(pts.last(),40);
								ptLGrip.transformBy(vecY*vecZ.dotProduct(pts.last()-ptLGrip));	
							}							
						// horizontal stacking	
							else if (nType==0)
							{
								vecStack.vis(pts.last(),40);
								ptLGrip.transformBy(vecY*vecZ.dotProduct(pts.last()-ptLGrip));	
							}
							else if (bIsVerticalContainer)
							{
								Point3d ptX = ptLGrip + vecZ * (.5 * dWidth - dHorizontalEdgeOffset);
								ptLGrip.transformBy(vecStack*vecZ.dotProduct(pts.first()-ptX));		
							}	
							else if (bIsVerticalPackage)
							{
								//pts.last().vis(6);
								Point3d ptX = ptLGrip;// + vecZ * (dWidth);
								ptLGrip.transformBy(vecStack*vecZ.dotProduct(pts.last()-ptX));		
							}							
						// vertical stacking in a closed truck	
							else if (nType==1 && !bIsVerticalContainer)
							{
								pts.last().vis(1);
								double d = vecZ.dotProduct(pts.last() - ptOrg);
								ptLGrip.transformBy(vecStack*d);
								vecStack.vis(ptLGrip,30);
							}	
						}
					}				
//					ptLGrip.vis(4);					
				}

			//get
				if (layer.gripPoints().length()>1) // !bDebug &&
				{
					ptLGrip=layer.gripPoint(0);
					if(bDebug)reportMessage(" with grip at " +ptLGrip);
				}
			//set
				else
				{
				// horizontal package stacking		
					if (bIsHorizontalPackage)	
						ptLGrip=ptOrg-vecX*dColumnOffset;
				// any other horizontal stacking
					else if (nType==0)
						ptLGrip=ptOrg-vecX*dColumnOffset;//+vecX*(vecX.dotProduct(_Pt0-ptOrg)+.5*dWidth);
					else if (bIsVerticalContainer)
						ptLGrip=ptOrg+vecX*(vecX.dotProduct(ptSectionRef-ptOrg)+nAlignment*(.5*dWidth-dHorizontalEdgeOffset));
					else if (bIsVerticalPackage)
						ptLGrip=ptOrg+vecX*(vecX.dotProduct(ptSectionRef-ptOrg));	
				// vertical open or closed truck stacking
					else if (nType==1 && !bIsVerticalContainer)
						ptLGrip=ptOrg+vecX*(vecX.dotProduct(ptSectionRef-ptOrg)+nAlignment*.5*dStancionWidth);	

					//ptLGrip.vis(2);
				// get offset defined by cumulated
					if (row>0)
					{
						Body bdInt(mapLayer.getPLine("plContour"),vecZ*U(2e4),0);
						Body bdCum= bdCumulatedCells[j-1];
						bdCum.transformBy(-vecY*(dRowOffset+dCellHeight));
//bdCum.vis(j);
					// to avoid accuracy issues decompose and test intersction one by one	
						Point3d pts[0]; 	
						Body lumps[] = bdCum.decomposeIntoLumps();	
						Vector3d vecStack = nType == 0 ?vecZ :nAlignment*vecX;
						for (int ii=0;ii<lumps.length();ii++) 
						{ 
							lumps[ii].intersectWith(bdInt);
							pts.append(lumps[ii].extremeVertices(vecZ));
						}//next ii						
						pts = Line(_Pt0, vecZ).orderPoints(pts, dEps);	
						if (pts.length()>0)
						{ 
						// horizontal package stacking		
							if (bIsHorizontalPackage)	
								ptLGrip.transformBy(vecY*vecZ.dotProduct(pts.last()-ptLGrip));							
						// horizontal stacking	
							else if (nType==0)
								ptLGrip.transformBy(vecY*vecZ.dotProduct(pts.last()-ptLGrip));
						// vertical container stacking
							else if (bIsVerticalContainer)
							{
								Point3d ptX = ptLGrip + vecZ * (.5 * dWidth - dHorizontalEdgeOffset);
								ptLGrip.transformBy(vecStack*vecZ.dotProduct(pts.first()-ptX));		
							}	
						// vertical package
							else if (bIsVerticalPackage)
							{
								Point3d ptX = ptLGrip;// + vecZ * (dWidth);
								ptLGrip.transformBy(vecStack*vecZ.dotProduct(pts.last()-ptX));		
							}	
						// vertical stacking in a closed truck	
							else if (nType==1 && !bIsVerticalContainer)
								ptLGrip.transformBy(vecStack*vecZ.dotProduct(pts.last() - ptOrg));
						}
					}
					
				// set grip of layer by map
					int bSetGrip=true;
					Vector3d vecGrip = ptLGrip-_PtW;
					if (mapLayer.hasVector3d("vec0"))
					{
						Vector3d vec = mapLayer.getVector3d("vec0");
						if (vec.isCodirectionalTo(vecGrip) && abs(vecGrip.length()-vec.length())<dEps)
						{
							if(bDebug)reportMessage("\n	vec of " +layer.handle()+ " "+  vec + " vs " + vecGrip);
							bSetGrip=false;							
						}
					}
					if (bSetGrip)
					{
						if(bDebug)reportMessage("\n	setting grip vec of " +layer.handle());
						if(bKLHver || bKLHverTransform)
						{ 
							vecGrip+=_XW*(dLength+2*U(2200));
						}
						else if(bKLHhorTransform)
						{ 
							// HSB-24086
							vecGrip+=_XW*(2*dColumnOffset);
						}
						mapLayer.setVector3d("vec0", vecGrip);
						layer.setMap(mapLayer);
					}
				}
				ptLGrip.vis(3);
				if(bKLHver)
				{ 
					ptLGrip-=_XW*(dLength+2*U(2200));
				}
				else if(bKLHhorTransform)
				{ 
					// HSB-24086
					ptLGrip-=_XW*(2*dColumnOffset);
				}
			// transform to Reference-Location
				double dZM;
				Vector3d vecZM;
				if (nType==0)
				{
					double d = abs(vecY.dotProduct(ptLGrip-ptOrg));
					dZM=d+layer.propDouble(0);
				}
				else if (bIsVerticalPackage)
				{
					double d = vecX.dotProduct(ptLGrip-ptSectionRef); // distance from grip to section ref
					dZM = d;//+bdLayer.lengthInDirection(vecZ);
				}				
				else if (nType==1 && nDesign!=2)
				{
					double d = abs(vecX.dotProduct(ptLGrip-ptSectionRef));
					dZM = d-.5*dStancionWidth;
				}
				else if (nType==1 && nDesign==2)
				{
					double d = abs(vecX.dotProduct(ptLGrip-ptSectionRef)); // distance from center to edge batten
					dZM = d-bdLayer.lengthInDirection(vecZ);
				}
				else
				{
					double d = abs(vecX.dotProduct(ptLGrip-ptSectionRef))-.5*dWidth;
					dZM = d-.5*dStancionWidth;
				}

				bdLayer.transformBy(vecZ*dZM);
				vecItem2Layer=vecZ*dZM;
				// HSB-24830
				vecItem2LayersAll[i]=vecItem2Layer;
				// HSB-22499
				for (int ii=0;ii<bdsI.length();ii++) 
				{ 
					Body bdIi=bdsI[ii];
					bdIi.transformBy(vecZ*dZM);
					mCellBodyI.appendBody("bd",bdIi);
				}//next ii
				for (int ii=0;ii<bdsICombi.length();ii++) 
				{ 
					Body bdIi=bdsICombi[ii];
					bdIi.transformBy(vecZ*dZM);
					mCellBodyICombi.appendBody("bd",bdIi);
				}
				
				//ptCell.vis(i);
				//bdLayer.vis(2);
				if (bdCell.volume()<pow(dEps,3))
					bdCell=bdLayer;
				else
				{
					bdCell.combine(bdLayer);
				}
				// HSB-23341
				if(bIsKlh && bdLayerCombi.volume()>pow(U(1),3))
				{ 
					if (bdCellCombi.volume()<pow(dEps,3))
						bdCellCombi=bdLayerCombi;
					else
					{
						bdCellCombi.combine(bdLayerCombi);
					}
				}
				//bdCell.vis(3+j);
	
			// transformation from layer to truck
				CoordSys csLayer2Truck;
				csLayer2Truck.setToAlignCoordSys(ptCell,vecX, vecY, vecZ, ptTruck, vecX, vecY, vecZ);				
				if (nType==0)
					csLayer2Truck.setToAlignCoordSys(ptCell, vecX, vecZ, -vecY, ptTruck+vecY*dZM, vecX, vecY, vecZ);//
				else if (bIsVerticalContainer)
				{
					Point3d ptTo = ptTruck + vecY * (.5 * dWidth + nAlignment * dZM);
					if (nAlignment==-1)ptTo.transformBy(bdLayer.lengthInDirection(vecZ) *- vecY);
					//ptTo.vis(6);
					csLayer2Truck.setToAlignCoordSys(ptCell, vecX,vecY,vecZ,ptTo , nAlignment*vecX, vecZ, vecY);	//+vecY*-.5*(dWidth-nAlignment*(2*dZM))	
				}
				else if (bIsVerticalPackage)
				{
					Point3d ptTo = ptTruck + vecY * (dWidth + dZM);
					//ptTo.vis(6);
					csLayer2Truck.setToAlignCoordSys(ptCell, vecX,vecY,vecZ,ptTo , -vecX, vecZ, vecY);	//+vecY*-.5*(dWidth-nAlignment*(2*dZM))	
				}				
				else if (nType==1 && !bIsVerticalContainer)
					csLayer2Truck.setToAlignCoordSys(ptCell, vecX,vecY,vecZ, ptTruck+vecY*(.5*dWidth+nAlignment*(.5*dStancionWidth+dZM)), nAlignment*vecX, vecZ, nAlignment*vecY);	// -nAlignment*(dStancionWidth+2*dZM)

				else if (col==1)
					csLayer2Truck.setToAlignCoordSys(ptCell, vecX, vecZ, vecY, ptTruck+vecY*.5*(dWidth+dStancionWidth), vecX, vecY, vecZ);	

			// store transformation of layer to truck in mapX of the layer
				{ 
					Map m;
					m.setPoint3d("ptOrg", csLayer2Truck.ptOrg(), _kRelative);
					m.setVector3d("vecX", csLayer2Truck.vecX(), _kScalable); // coordsys carries size
					m.setVector3d("vecY", csLayer2Truck.vecY(), _kScalable);
					m.setVector3d("vecZ", csLayer2Truck.vecZ(), _kScalable);
					m.setInt("row", row);
					layer.setSubMapX("Hsb_Layer2Truck",m);			
				}				
//				bdLayer.vis(i);
			}
		}// next i
		bdCells[j]=bdCell;
		vecItem2Layers[j]=vecItem2Layer;
		// HSB-22499
		mapCellBodies.appendMap("mBody",mCellBodyI);
		// HSB-23341
		if(bIsKlh)
		{ 
//			if(bdCellCombi.volume()>pow(U(1),3))
			{ 
				bdCellsCombi[j]=bdCellCombi;
				mapCellBodiesCombi.appendMap("mBody",mCellBodyICombi);
			}
		}
		
		//bdCell.vis(row);
		
	// build cumulated cell body
		if(row>0)
		{
			//bdCell.vis(20);	
			Body bd=bdCumulatedCells[j-1];
			Point3d pt=ptsCells[j-1];
			bd.transformBy(vecY*vecY.dotProduct(ptOrg-pt));
			bd.combine(bdCell); // since 6.3 combine instead of addPart
			bdCumulatedCells[j]=bd;
			//bd.vis(row+1);
		}
		else
		{
			//bdCell.vis(1);
			bdCumulatedCells[j]=bdCell;
		}
		//bdCumulatedCells[j].vis(j);
		
		cell.setEntityArray(entCellItems, true, "Item[]","", "Item" );
		mapCells2.appendMap("Cell",cell);
		
	}// for (int j=0;j<mapCells.length();j++)
	
	if(bKLHhorTransform)
	{ 
		vecX=vecXc;
		vecY=vecYc;
		vecZ=vecZc;
	}
	
	mapCells=mapCells2;
	
// draw shadow, extract and draw contact surfaces per cell
	PlaneProfile ppContacts[bdCumulatedCells.length()];
	
	for (int j=0;j<bdCumulatedCells.length();j++)
	{
	// show all or only last two rows
		if (!bShowContact && j<bdCumulatedCells.length()-2)
			continue;
		
		Body bd = bdCumulatedCells[j];
		//bd.vis(j);
	// draw cumulated shadow, do not draw contact when last row is hidden
		if (!bHideExtraRow)
		{
			dpShadow.draw(bd.shadowProfile(pnZ),_kDrawFilled, nTransparencyShadow);
		}
		
		Point3d pts[] = bd.extremeVertices(vecZ);
		if (pts.length()>0)
		{
			Vector3d _vecZ=vecZ;
			if(bKLHhorTransform)
			{ 
				// HSB-24148
				vecZ=_ZW;
			}
			double dZ = abs(vecZ.dotProduct(pts[0]-pts[pts.length()-1]));
			Point3d pt; pt.setToAverage(pts);
			Plane pn(pt+vecZ*.5*dZ, vecZ);
			pn.vis();
			PlaneProfile pp = bd.extractContactFaceInPlane(pn, dEps);
			pp.shrink(-U(10));
			pp.shrink(U(10));
			ppContacts[j]=pp;
		// do not draw contact when last row is hidden
			if (bHideExtraRow)
				continue;
			//pp.vis(221);
			pp.transformBy(vecZ*vecZ.dotProduct(_Pt0-pn.ptOrg()));
			
			dpContact.draw(pp,_kDrawFilled, nTransparencyContact);
			if(bKLHhorTransform)
			{ 
				// HSB-24148
				vecZ=_ZW;
			}
		}	
	}
	
	
// extract and draw interferences, draw section
	PlaneProfile ppInterferenceX[0], ppInterferenceZ[0];
	CoordSys csSection(_Pt0, -vecY, vecZ, -vecX);
	if(bKLHhorTransform)
	{ 
		// HSB-24086
		csSection=CoordSys(_Pt0, -_YW, _ZW, -_XW);
	}
	
	for (int j=0;j<bdCumulatedCells.length();j++)
	{
		ptsGrid[j].vis(2);
		int nTick = getTickCount();
		Map cell = mapCells.getMap(j);
		int row = cell.getInt("row");
		int col = cell.getInt("column");
		
		Point3d ptSection=ptsGrid[j];
		ptSection.transformBy(vecX*vecX.dotProduct(ptSectionRef-ptsGrid[j]));
		if (nType==1 && nDesign!=2 &&  nDesign!=3)
			ptSection.transformBy(vecX*nAlignment*.5*dStancionWidth);	
		ptSection.vis(1);
		
		CoordSys cs2Section;
		if (bIsHorizontalPackage)
		{
			if(!bKLHhorTransform)
			{ 
				cs2Section.setToAlignCoordSys(ptsGrid[j], -vecY, vecZ, -vecX, ptSection+vecX*dWidth, vecX, vecY, vecZ);
			}
			else if(bKLHhorTransform)
			{
				cs2Section.setToAlignCoordSys(ptsGrid[j],-_YW,_ZW,-_XW, ptSection+_XW*dWidth, _XW,_YW,_ZW);
			}
		}
		else if (nType==0)
		{
			if(!bKLHhorTransform )
			{ 
				cs2Section.setToAlignCoordSys(ptsGrid[j], -vecY, vecZ, -vecX, ptSection+vecX*.5*dWidth, vecX, vecY, vecZ);
			}
			else if(bKLHhorTransform)
			{
				cs2Section.setToAlignCoordSys(ptsGrid[j],-_YW,_ZW,-_XW, ptSection+_XW*.5*dWidth,_XW,_YW,_ZW);
			}
		}
		else if (bIsVerticalPackage)
		{
			if(!bKLHhorTransform )
			{ 
				cs2Section.setToAlignCoordSys(ptsGrid[j], vecZ,vecY, -vecX, ptSection, vecX, vecY, vecZ);
			//cs2Section.setToAlignCoordSys(ptsGrid[j], -vecY,vecZ, -vecX, ptSection, -vecY, vecX, vecZ);
			}
			else if(bKLHhorTransform)
			{
				cs2Section.setToAlignCoordSys(ptsGrid[j],_ZW,_YW,-_XW, ptSection,_XW,_YW,_ZW);
				//cs2Section.setToAlignCoordSys(ptsGrid[j], -vecY,vecZ, -vecX, ptSection, -vecY, vecX, vecZ);
			}
			
		}
		else
		{
			if(!bKLHhorTransform)
			{ 
				cs2Section.setToAlignCoordSys(ptsGrid[j], nAlignment*vecZ,vecY, -nAlignment*vecX, ptSection, vecX, vecY, vecZ);
			//cs2Section.setToAlignCoordSys(ptsGrid[j], -vecY,vecZ, -vecX, ptSection, -vecY, vecX, vecZ);
			}
			else if(bKLHhorTransform)
			{
				cs2Section.setToAlignCoordSys(ptsGrid[j], nAlignment*_ZW,_YW, -nAlignment*_XW, ptSection, _XW, _YW, _ZW);
//				cs2Section.setToAlignCoordSys(ptsGrid[j], -vecY,vecZ, -vecX, ptSection, -vecY, vecX, vecZ);
			}
		}
		Body bd = bdCumulatedCells[j];
//		bd.vis(3);
	// decompose into lumps as the intersectWith of complex combined bodies often fails
		if(bShowInterference)
		{
			Body bodies[] = bd.decomposeIntoLumps();
			for (int b=0;b<bodies.length();b++)
			{
				for (int c=0;c<bodies.length()-1;c++)
				{
					if (c==b)continue;
					Body bd2 = bodies[c];
					if (!bd2.hasIntersection(bodies[b]))continue;
					
					bd2.intersectWith(bodies[b]);
					PlaneProfile pp = bd2.shadowProfile(pnZ);
					PLine plRings[] = pp.allRings();
					int bIsOp[] = pp.ringIsOpening();
					pp.removeAllRings();
					for (int r=0;r<plRings.length();r++)
						if (!bIsOp[r])
							pp.joinRing(plRings[r],_kAdd);
						if (pp.area()>pow(dEps,2))
						{
							ppInterferenceZ.append(pp);
							if(bKLHverTransform || bKLHver)
							{ 
								pp.transformBy(csKLHvertSec);
							}
							dpInterfere.draw(pp,_kDrawFilled,nTransparencyInterfere);//,_kDrawFilled);
						}
					
					pp = bd2.shadowProfile(Plane(_Pt0, vecX));
					plRings = pp.allRings();
					bIsOp = pp.ringIsOpening();
					pp.removeAllRings();
					for (int r=0;r<plRings.length();r++)
						if (!bIsOp[r])
							pp.joinRing(plRings[r],_kAdd);
						if (pp.area()>pow(dEps,2))
						{
							pp.transformBy(cs2Section);
							ppInterferenceX.append(pp);
							dpInterfere.draw(pp,_kDrawFilled,nTransparencyInterfere);
						}
				}
			}
		}

		Body bdSection = bd;
		dpSide.color(nColorShadow);
		for (int i=0;i<2;i++) 
		{ 
			LineSeg segs[] = bdSection.hideDisplay(csSection, false, false, true);
			
			for (int s=0;s<segs.length();s++) 
			{
				//segs[s].transformBy(vecX*vecX.dotProduct(ptGridRef-segs[s].ptMid()));
				
				segs[s].transformBy(cs2Section);
				segs[s].transformBy(vecZ*vecZ.dotProduct(ptRef-segs[s].ptMid()));
				if(bKLHverTransform || bKLHver)
				{ 
					segs[s].transformBy(csKLHvertSec);
				}
			}
			segs = pnZ.projectLineSegs(segs);
			LineSeg segsModif[0];
			// HSB-15456
			for (int iseg=0;iseg<segs.length();iseg++) 
			{ 
				Point3d pt1= segs[iseg].ptStart(); 
				Point3d pt2= segs[iseg].ptEnd(); 
				if((pt1-pt2).length()>dEps)segsModif.append(segs[iseg]);
			}//next iseg
			

			dpSide.draw(segsModif);
			// HSB-19483
			if(mapContourGrid.length()>0)
			{ 
				if(mapContourGrid.getDouble("Thickness")>0)
				{ 
					double dThicknessContour=mapContourGrid.getDouble("Thickness");
					for (int iseg=0;iseg<segsModif.length();iseg++) 
					{ 
						
						Vector3d vecDir=segsModif[iseg].ptStart()-segsModif[iseg].ptEnd();
						vecDir.normalize();
//						Vector3d vecNormal=vecDir.crossProduct(_ZW);
						Vector3d vecNormal=vecDir.crossProduct(vecZ);
						vecNormal.normalize();
						PlaneProfile ppContour;
						ppContour.createRectangle(LineSeg(
							segsModif[iseg].ptStart()-vecNormal*.5*dThicknessContour,
							segsModif[iseg].ptEnd()+vecNormal*.5*dThicknessContour),vecX,vecY);
//							segsModif[iseg].ptEnd()+vecNormal*.5*dThicknessContour),_XW,_YW);
						dpSide.draw(ppContour,_kDrawFilled);
					}//next iseg
					
//					PlaneProfile ppOutter(pl);
//					PlaneProfile ppInner(pl);
//					ppOutter.shrink(-.5*dThicknessContour);
//					ppInner.shrink(.5*dThicknessContour);
//					ppOutter.subtractProfile(ppInner);
//					dpTruck.draw(ppOutter,_kDrawFilled);
				}
			}
			bdSection=bdCells[j];
			
		// set the color
			int c = j;
			if (nSeqColors.length()>0)
			{
				int n=j;
				while(n>nSeqColors.length()-1)
					n-=nSeqColors.length();
				c=nSeqColors[n];
				//reportNotice("\n n " + n + " c " + c);
			}
			dpSide.color(c);
		}
	}// next j
	
	
// purge openings of contact rings and publish in _Map
	Map mapContacts;
	for (int i=0;i<ppContacts.length();i++) 
	{ 
		PLine plRings[] = ppContacts[i].allRings();
		int bIsOp[] = ppContacts[i].ringIsOpening();
		for (int r=0;r<plRings.length();r++)
			if (!bIsOp[r])
				mapContacts.appendPLine("Contact",plRings[r]);
	}
	
// declare COG and weight
	Point3d ptCOG, ptXExtremes[0];
	double dWeight;
	// HSB-23445
	Point3d ptCOGcombi;
	double dWeightCombi;
	
	CoordSys csGrid2Truck;
	
// draw truck load
	CoordSys cs2Section;
	if(!bIsKlh)
	{ 
		if (nType==0)	
			cs2Section.setToAlignCoordSys(ptTruck, vecZ, vecY, -vecX,ptTruck-vecX*(dColumnOffset),vecX,vecY,vecZ);
		else if (bIsVerticalPackage)	
			cs2Section.setToAlignCoordSys(ptTruck, -vecY, vecZ, -vecX,ptTruck-vecX*(dColumnOffset),vecX,vecY,vecZ);
		else			
			cs2Section.setToAlignCoordSys(ptTruck, -vecY, vecZ, -vecX,ptTruck-vecX*(dColumnOffset),vecX,vecY,vecZ);
	}
	else if(bIsKlh )
	{ 
		if (nType==0)	
			cs2Section.setToAlignCoordSys(ptTruck, _ZW, _YW, -_XW,ptTruck+_XW*(dWidth+dColumnOffset),_XW,_YW,_ZW);
		else if (bIsVerticalPackage)	
			cs2Section.setToAlignCoordSys(ptTruck, -_YW, _ZW, -_XW,ptTruck+_XW*(dWidth+dColumnOffset),_XW,_YW,_ZW);
		else			
			cs2Section.setToAlignCoordSys(ptTruck, -_YW, _ZW, -_XW,ptTruck+_XW*(dWidth+dColumnOffset),_XW,_YW,_ZW);
		if(bKLHver)
		{ 
			cs2Section.setToAlignCoordSys(ptTruck, -vecY, vecZ, -vecX,ptTruck+vecX*(dLength+dColumnOffset+dWidth),vecX,vecY,vecZ);
		}
	}
	PlaneProfile ppItemsAll(csW),ppItemsAllCombi(csW);
	PlaneProfile ppItemsAllSection(csW),ppItemsAllSectionCombi(csW);
	// HSB-23131
	Body bdItemsAll,bdItemsAlls[0];// HSB-23527
	double bdItemsAllsVol;// bdItemsAllsVol
	Body bdItemsAllCombi;// HSB-23341
	CoordSys csKLHverTransformTruck;
	if(bKLHverTransform)
	{ 
		csKLHverTransformTruck.setToRotation(180,_YW,ptTruck+vecX*.5*dLength);
	}
	for (int j=0;j<bdCells.length();j++)
	{
		Map cell = mapCells.getMap(j);
		Map mapCellBodiesJ=mapCellBodies.getMap(j);
		Map mapCellBodiesJCombi;
		if(bIsKlh)
		{
			mapCellBodiesJCombi=mapCellBodiesCombi.getMap(j);
		}
		int row = cell.getInt("row");
		int col = cell.getInt("column");
		Point3d ptOrg = cell.getPoint3d("ptOrg");
		CoordSys cs;
		
		if(!bKLHhorTransform && !bKLHver )
		{ 
			if (nType==0)
				cs.setToAlignCoordSys(ptOrg, vecX, vecZ, -vecY, ptTruck, vecX, vecY, vecZ);
			else if (bIsVerticalPackage)
				cs.setToAlignCoordSys(ptOrg, vecX,-vecZ,vecY, ptTruck+vecY*(dWidth), vecX, vecY, vecZ);				
			else if (nType==1 && nDesign!=2)
				cs.setToAlignCoordSys(ptOrg, vecX,vecY,vecZ, ptTruck+vecY*.5*(dWidth+nAlignment*dStancionWidth), nAlignment*vecX, vecZ, nAlignment*vecY);
			else if (nType==1 && nDesign==2)
				cs.setToAlignCoordSys(ptOrg, vecX,vecY,vecZ, ptTruck+vecY*.5*(dWidth), nAlignment*vecX, vecZ, nAlignment*vecY);
			else if (col==1)
				cs.setToAlignCoordSys(ptOrg, vecX, vecZ, vecY, ptTruck+vecY*.5*(dWidth+dStancionWidth), vecX, vecY, vecZ);
		}
		else if(bKLHhorTransform)
		{ 
			if (nType==0)
				cs.setToAlignCoordSys(ptOrg,_XW,_ZW,-_YW,ptTruck,_XW,_YW,_ZW);
			else if (bIsVerticalPackage)
				cs.setToAlignCoordSys(ptOrg,_XW,-_ZW,_YW,ptTruck+_YW*(dWidth),_XW,_YW,_ZW);				
			else if (nType==1 && nDesign!=2)
				cs.setToAlignCoordSys(ptOrg,_XW,_YW,_ZW,ptTruck+_YW*.5*(dWidth+nAlignment*dStancionWidth),nAlignment*_XW,_ZW,nAlignment*_YW);
			else if (nType==1 && nDesign==2)
				cs.setToAlignCoordSys(ptOrg,_XW,_YW,_ZW,ptTruck+_YW*.5*(dWidth),nAlignment*_XW,_ZW,nAlignment*_YW);
			else if (col==1)
				cs.setToAlignCoordSys(ptOrg,_XW,_ZW,_YW,ptTruck+_YW*.5*(dWidth+dStancionWidth),_XW,_YW,_ZW);
			
		}
		else if(bKLHver)
		{ 
			Point3d ptOrgKLH=ptOrg;
//			if(nAlignment==1 && !(nType==1 && nDesign==2))
			if(nAlignment==1)// HSB-24602
			{ 
				// HSB-24486: for (nType==1 && nDesign==2) alignment is taken into account in transformation
				ptOrgKLH=ptOrg+vecX*dLength;
			}
			
			if (nType==0)
				cs.setToAlignCoordSys(ptOrgKLH,vecX,vecZ,-vecY,ptTruck,vecX,vecY,vecZ);
			else if (bIsVerticalPackage)
				cs.setToAlignCoordSys(ptOrgKLH,vecX,-vecZ,vecY,ptTruck+vecY*(dWidth),vecX,vecY,vecZ);				
			else if (nType==1 && nDesign!=2)
			{
				// HSB-24602
//				cs.setToAlignCoordSys(ptOrg, -vecX,vecY,-vecZ, ptTruck+vecX*dLength+vecY*.5*(dWidth+(-nAlignment)*dStancionWidth), nAlignment*vecX, vecZ, nAlignment*vecY);
				cs.setToAlignCoordSys(ptOrgKLH,-vecX,vecY,-vecZ, ptTruck+vecX*dLength+vecY*.5*(dWidth+(-nAlignment)*dStancionWidth),-1*vecX,vecZ,nAlignment*vecY);
			}
			else if (nType==1 && nDesign==2)
			{
//				cs.setToAlignCoordSys(ptOrgKLH, vecX,vecY,vecZ, ptTruck+vecY*.5*(dWidth), nAlignment*vecX, vecZ, nAlignment*vecY);
				cs.setToAlignCoordSys(ptOrgKLH,-vecX,vecY,-vecZ,ptTruck+vecX*dLength+vecY*.5*(dWidth),1*(-vecX),vecZ,nAlignment*vecY);
			}
			else if (col==1)
			{
				cs.setToAlignCoordSys(ptOrgKLH,vecX,vecZ,vecY,ptTruck+vecY*.5*(dWidth+dStancionWidth),vecX,vecY,-vecZ);
			}
		}
		
		if (j==0)
			csGrid2Truck = cs;
		
		Body bd = bdCells[j];
		//HSB-23341
		Body bdCombi;
		if(bIsKlh)
		{
			bdCombi= bdCellsCombi[j];
		}
		
		// transformation to the stack
		Vector3d vecZStack;
		{ 
			Point3d pts[] = bd.extremeVertices(vecZ);
			if (pts.length()>0)vecZStack = vecZ * vecZ.dotProduct(pts.first() - ptOrg);
		}
		ptXExtremes.append(bd.extremeVertices(vecX));
		bd.transformBy(cs);
		if(bIsKlh)
		{ 
			// HSB-24485: save Layer2Truck transformation
			for (int i=0;i<layers.length();i++)	
			{ 
				TslInst layer = layers[i];
				if (!layer.bIsValid())
				{
					continue;
				}
				
				Map mapLayer = layer.map();
				int rowLayer = mapLayer.getInt("row");
				int colLayer = mapLayer.getInt("column");
				
				if (row==rowLayer && col == colLayer)
				{ 
					// HSB-24486: consider displacement vecItem2Layer
					CoordSys csFrom=cs;
//					CoordSys csTo=cs;csTo.transformBy(vecItem2Layers[j]);csTo.transformBy(cs);
					// HSB-24830
					CoordSys csTo=cs;csTo.transformBy(vecItem2LayersAll[i]);csTo.transformBy(cs);
					CoordSys csLayer2Truck;csLayer2Truck.setToAlignCoordSys(csFrom.ptOrg(),csFrom.vecX(),csFrom.vecY(),csFrom.vecZ(),
						csTo.ptOrg(),csTo.vecX(),csTo.vecY(),csTo.vecZ());
					// store transformation of layer to truck in mapX of the layer
					{ 
						Map m;
						m.setPoint3d("ptOrg", csLayer2Truck.ptOrg(), _kRelative);
						m.setVector3d("vecX", csLayer2Truck.vecX(), _kScalable); // coordsys carries size
						m.setVector3d("vecY", csLayer2Truck.vecY(), _kScalable);
						m.setVector3d("vecZ", csLayer2Truck.vecZ(), _kScalable);
						m.setInt("row", row);
						layer.setSubMapX("Hsb_Layer2Truck",m);			
					}		
				}
			}
		}
		//HSB-23341
		if(bIsKlh)
		{
			bdCombi.transformBy(cs);
		}
		
	// set the color
		int c = j;
		if (nSeqColors.length()>0)
		{
			int n=j;
			while(n>=nSeqColors.length())
				n-=nSeqColors.length();
			c=nSeqColors[n];
			//reportNotice("\n n " + n + " c " + c);
		}
		dpTruck.color(c);
		//dpTruck.draw(bd);
		// int bShowHiddenLines, int bShowOnlyHiddenLines, int bShowApproximatingEdges
		LineSeg segs[]=bd.hideDisplay(csW,false,false,true);
		LineSeg segsModif[0];
//		if(segs.length()<4)
		{ 
		// HSB-17512: this method not very reliable, if this happenes use shadowprofile
			PlaneProfile ppShadow=bd.shadowProfile(Plane(csW.ptOrg(),csW.vecZ()));
			PlaneProfile ppShadowCombi;
			//HSB-23341
			if(bIsKlh)
			{
				ppShadowCombi=bdCombi.shadowProfile(Plane(csW.ptOrg(),csW.vecZ()));
			}
//			dpTruck.draw(ppShadow);
			PlaneProfile ppShadowOutter(csW);
			PLine plsOutter[]=ppShadow.allRings(true,false);
			for (int ipl=0;ipl<plsOutter.length();ipl++) 
			{ 
				ppShadowOutter.joinRing(plsOutter[ipl],_kAdd);
			}//next ipl
			PlaneProfile ppShadowOutterCombi(csW);
			//HSB-23341
			if(bIsKlh)
			{ 
				PLine plsOutterCombi[]=ppShadowCombi.allRings(true,false);
				for (int ipl=0;ipl<plsOutterCombi.length();ipl++) 
				{ 
					ppShadowOutterCombi.joinRing(plsOutterCombi[ipl],_kAdd);
				}//next ipl
			}
			if(bIsKlh)
			{ 
			//
				for (int ii=0;ii<mapCellBodiesJ.length();ii++) 
				{ 
					Body bdIi=mapCellBodiesJ.getBody(ii);
					bdIi.transformBy(cs);
					// HSB-23131
					bdItemsAll.addPart(bdIi);
					// HSB-23527
					bdItemsAlls.append(bdIi);
					// bdItemsAllsVol
					bdItemsAllsVol+=bdIi.volume();
					PlaneProfile ppIi=bdIi.shadowProfile(Plane(csW.ptOrg(),csW.vecZ()));
//					if(bKLHverTransform)
//					{ 
////						ppIi.transformBy(csKLHverTransformTruck);
//					}
					dpTruck.draw(ppIi);
				}//next ii
				for (int ii=0;ii<mapCellBodiesJCombi.length();ii++) 
				{ 
					Body bdIi=mapCellBodiesJCombi.getBody(ii);
					bdIi.transformBy(cs);
					// HSB-23131
					bdItemsAllCombi.addPart(bdIi);
				}
				// HSB-22875
				ppItemsAll.unionWith(ppShadowOutter);
				ppItemsAllCombi.unionWith(ppShadowOutterCombi);
			}
//			if(bKLHverTransform)
//			{ 
////				ppShadowOutter.transformBy(csKLHverTransformTruck);
//			}
			dpTruck.draw(ppShadowOutter);
		}
//		else
//		{ 
//		// 
//			for (int s=0;s<segs.length();s++) 
//			{
//				segs[s].transformBy(vecZ*vecZ.dotProduct(ptRef-segs[s].ptMid()));
//			}
//			segs = pnZ.projectLineSegs(segs);
//			
//			// HSB-15456
//			for (int iseg=0;iseg<segs.length();iseg++) 
//			{ 
//				Point3d pt1= segs[iseg].ptStart(); 
//				Point3d pt2= segs[iseg].ptEnd(); 
//				if((pt1-pt2).length()>dEps)
//					segsModif.append(segs[iseg]);
//			}//next iseg
//	//		dpTruck.draw(segs);
//			dpTruck.draw(segsModif);
//		}
	// section
		bd.transformBy(cs2Section);
		bdCombi.transformBy(cs2Section);//HSB-23341
		//dpTruck.draw(bd);
		//bd.vis(j);
		segs = bd.hideDisplay(csW, false, false, true);
//		if(segs.length()<4)
		{ 
		// HSB-17512: this method not very reliable, if this happenes use shadowprofile
			PlaneProfile ppShadow=bd.shadowProfile(pnZ);
//			dpTruck.draw(ppShadow);
			PlaneProfile ppShadowOutter(pnZ);
			PLine plsOutter[]=ppShadow.allRings(true,false);
			for (int ipl=0;ipl<plsOutter.length();ipl++) 
			{ 
				ppShadowOutter.joinRing(plsOutter[ipl],_kAdd);
			}//next ipl
			dpTruck.draw(ppShadowOutter);
			if(bIsKlh)
			{ 
				// HSB-22875
				ppItemsAllSection.unionWith(ppShadowOutter);
			}
		}
//		else
//		{ 
//			for (int s=0;s<segs.length();s++) 
//				segs[s].transformBy(vecZ*vecZ.dotProduct(ptRef-segs[s].ptMid()));	
//			segs = pnZ.projectLineSegs(segs);
//			segsModif.setLength(0);
//			// HSB-15456
//			for (int iseg=0;iseg<segs.length();iseg++) 
//			{ 
//				Point3d pt1= segs[iseg].ptStart(); 
//				Point3d pt2= segs[iseg].ptEnd(); 
//				if((pt1-pt2).length()>dEps)
//					segsModif.append(segs[iseg]);
//			}//next iseg
//	//		dpTruck.draw(segs); 
//			dpTruck.draw(segsModif);
//		}

	//region Get cell items and calc COG
		Entity entCellItems[] = cell.getEntityArray("Item[]", "", "Item");
		for (int i=0;i<entCellItems.length();i++) 
		{ 
			Entity item = entCellItems[i];
			Map mapX = item.subMapX("Hsb_item");
			Entity ref;
			ref.setFromHandle(mapX.getString("MYUID"));
			if (ref.bIsValid())
			{ 
				Map m = ref.subMapX("Hsb_ItemParent");
				CoordSys csItem(m.getPoint3d("ptOrg"), m.getVector3d("vecX"), m.getVector3d("vecY"),m.getVector3d("vecZ"));
			// transformation to the stack
				// transform to base of grouped cell
				{ 
					Body bd = ref.realBody();
					bd.transformBy(csItem);//	bd.vis(4);
					Point3d pts[] = bd.extremeVertices(vecZ);
					if (pts.length()>0)	csItem.transformBy(vecZ * vecZ.dotProduct(ptOrg - pts.first()));
				}
				csItem.transformBy(vecZStack);
				csItem.transformBy(cs);
				
			//region Store transfomation from entity to truck
			// store transformation of layer to truck in mapX of the referenced (stacked) entity
				{ 
					Map m;
					m.setPoint3d("ptOrg", csItem.ptOrg(), _kRelative);
					m.setVector3d("vecX", csItem.vecX(), _kScalable); // coordsys carries size
					m.setVector3d("vecY", csItem.vecY(), _kScalable);
					m.setVector3d("vecZ", csItem.vecZ(), _kScalable);
					ref.setSubMapX("Hsb_Item2Truck",m);			
				}					
			//End Store transfomation from entity to truck//endregion 

			//region Calculate COG
				// cases
				Element element;
				Sip sip;
				GenBeam genBeam;
//				TslInst tslInst;
				MassElement massElement;
				MassGroup massGroup;
				ChildPanel child;
				Entity entRef=ref;
//				String sPropertySetName, sPropertyName;
				String sPropertySetNames[0];
				Entity ents[0];
				int nElement;// flag if it is an element
				int nMass; // flag if it is a massElement or massGroup
				if (entRef.bIsKindOf(Element()))
				{
					sPropertySetNames = Element().availablePropSetNames();
					element = (Element)entRef;
					nElement=true;
					GenBeam genbeams[] = element.genBeam();
//					nSubQty += genbeams.length();
//					nQty++;
					for (int g=0;g<genbeams.length();g++) 
					{ 
						ents.append(genbeams[g]); 
					}
				}
				else if (entRef.bIsKindOf(ChildPanel()))
				{
					child = (ChildPanel)entRef;
					sip = child.sipEntity();
					sPropertySetNames = Sip().availablePropSetNames();
					entRef = sip;
					ents.append(entRef);
				}
				else if (entRef.bIsKindOf(Sip()))
				{
					sPropertySetNames = Sip().availablePropSetNames();
					sip = (Sip)entRef;	
					ents.append(entRef);
				}
				else if (entRef.bIsKindOf(GenBeam()))
				{
					sPropertySetNames = GenBeam().availablePropSetNames();
					genBeam = (GenBeam)entRef;
					ents.append(entRef);
				}
				else if (entRef.bIsKindOf(MassElement()))
				{ 
					sPropertySetNames = MassElement().availablePropSetNames();
					massElement = (MassElement)entRef;
					nMass=true;
				}
				else if (entRef.bIsKindOf(MassGroup()))
				{
					sPropertySetNames = MassGroup().availablePropSetNames();
					massGroup = (MassGroup)entRef;
					ents.append(entRef);
					nMass=true;
				}
				Point3d ptCen;
				Point3d ptCenCombi;
				double dWeight2;
				double dWeight2Combi;
				
			// HSB-18360:
				if(nMass && bIsKlh)
				{ 
				// massElement or massGroup
//					if (sWeightPropertyTokens.length()>0)
					{ 
//						int n = sPropertySetNames.find(sWeightPropertyTokens[0]);
						int n=sPropertySetNames.find("MassElement");
						if (n>-1)
						{
							String sPropertySetName=sPropertySetNames[n];
							Map map=entRef.getAttachedPropSetMap(sPropertySetName);
							
//							String sPropertyName = sWeightPropertyTokens[1];
							String sPropertyName="Weight";
							if (map.hasDouble(sPropertyName))
								dWeight2=map.getDouble(sPropertyName);
							else if (map.hasString(sPropertyName))
								dWeight2=map.getString(sPropertyName).atof();
							//reportMessage("\nWeight found in " + sPropertySetName + " " + dWeight);
							ptCen=entRef.realBody().ptCen();
							ptCen.transformBy(csItem);
							ptCen.vis(1);
							ptCenCombi=ptCen;
							dWeight2Combi=dWeight2;
						}
					}
				}
				else if (entRef.bIsKindOf(Sip()) && bIsKlh)
				{ 
				// HSB-18371: get the weight from net weight
					if (sWeightPropertyTokens.length()>0)
					{ 
						int n=sPropertySetNames.find(sWeightPropertyTokens[0]);
						if (n>-1)
						{
							String sPropertySetName=sPropertySetNames[n];
							Map map=entRef.getAttachedPropSetMap(sPropertySetName);
							
							String sPropertyName=sWeightPropertyTokens[1];
							if (map.hasDouble(sPropertyName))
								dWeight2=map.getDouble(sPropertyName);
							else if (map.hasString(sPropertyName))
								dWeight2=map.getString(sPropertyName).atof();
							//reportMessage("\nWeight found in " + sPropertySetName + " " + dWeight);
							ptCen=entRef.realBody().ptCen();
							ptCen.transformBy(csItem);
							if(bIsKlh)
							{ 
								ptCenCombi=ptCen;
								dWeight2Combi=dWeight2;
							}
						}
					}
				}
				else if (entRef.bIsKindOf(Sip()) && sWeightPropertyTokens.length()==2)
				{ 
					// HSB-24278: 
					int n=sPropertySetNames.find(sWeightPropertyTokens[0]);
					if (n>-1)
					{
						String sPropertySetName=sPropertySetNames[n];
						Map map=entRef.getAttachedPropSetMap(sPropertySetName);
						
						String sPropertyName=sWeightPropertyTokens[1];
						if (map.hasDouble(sPropertyName))
							dWeight2=map.getDouble(sPropertyName);
						else if (map.hasString(sPropertyName))
							dWeight2=map.getString(sPropertyName).atof();
						//reportMessage("\nWeight found in " + sPropertySetName + " " + dWeight);
						ptCen=entRef.realBody().ptCen();
						ptCen.transformBy(csItem);
					}
				}
				else
				{ 
					Map mapIO;
					Map mapEntities;
					if(nElement)
					{ 
						for (int ie=0;ie<ents.length();ie++)
						{ 
							mapEntities.appendEntity("Entity", ents[ie]); 
						}//next ie
					}
					else
					{ 
						mapEntities.appendEntity("Entity", ref);
					}
					mapIO.setMap("Entity[]",mapEntities);
					TslInst().callMapIO("hsbCenterOfGravity", mapIO);
					ptCen=mapIO.getPoint3d("ptCen");// returning the center of gravity
					dWeight2=mapIO.getDouble("Weight");// returning the weight		
					ptCen.transformBy(csItem);
					if(bIsKlh)
					{ 
						TslInst tslRef=(TslInst)ref;
						int bCombiTruck;
						if(tslRef.bIsValid())
						{ 
							String ss=tslRef.scriptName();
							if(tslRef.scriptName()=="klhCombiTruck")
							{ 
								bCombiTruck=true;
							}
						}
						if(!bCombiTruck)
						{ 
							ptCenCombi=ptCen;
							dWeight2Combi=dWeight2;
						}
					}
				}
				if (dWeight<=0)
				{
					dWeight=dWeight2;
					ptCOG=ptCen;
				}
				else
				{ 
					Vector3d vec=ptCen-ptCOG;
					double c=vec.length();
					vec.normalize();
					double b=(dWeight*c)/(dWeight+dWeight2);
					ptCOG.transformBy(vec*(c-b));
					dWeight+=dWeight2;
				}
				if(bIsKlh)
				{ 
					if (dWeightCombi<=0)
					{
						dWeightCombi=dWeight2Combi;
						ptCOGcombi=ptCenCombi;
					}
					else
					{ 
						Vector3d vec=ptCenCombi-ptCOGcombi;
						double c=vec.length();
						vec.normalize();
						double b=(dWeightCombi*c)/(dWeightCombi+dWeight2Combi);
						ptCOGcombi.transformBy(vec*(c-b));
						dWeightCombi+=dWeight2Combi;
					}
				}
			//End Calculate COG//endregion 
						
				if (bDebug)
				{ 
					Body bd=ref.realBody();
					bd.transformBy(csItem);
					bd.vis(51);//i+j+4);
					ptCen.vis(2);
				}	
			}
		}//next i of entCellItems		
	//End Get cell items and calc COG//endregion 

	}// next j
	
	if(bIsKlh)
	{ 
		// HSB-23131
		// HSB-22875: needed for dimensioning
		_Map.setPlaneProfile("ppItemsAll",ppItemsAll);
		_Map.setPlaneProfile("ppItemsAllSection",ppItemsAllSection);
		_Map.setBody("bdItemsAll", bdItemsAll);
		// HSB-23527:
		Map mapBdItemsAlls=SetBodyArray(bdItemsAlls);
		_Map.setMap("mapBdItemsAlls",mapBdItemsAlls);
		_Map.setDouble("bdItemsAllVol",bdItemsAllsVol);// bdItemsAllsVol
		// HSB-23341
		_Map.setPlaneProfile("ppItemsAllCombi",ppItemsAllCombi);
		_Map.setPlaneProfile("ppItemsAllSectionCombi",ppItemsAllSectionCombi);
		_Map.setBody("bdItemsAllCombi", bdItemsAllCombi);
		// HSB-23445
		_Map.setPoint3d("ptCogCombi", ptCOGcombi);
		_Map.setDouble("WeightCombi", dWeightCombi);
	}
//region COG
	ptCOG.vis(40);	 // COG in model
	// transform COG to grid
	Point3d ptCogGrids[0];
	for (int j=0;j<bdCells.length();j++)
	{ 
		Map cell = mapCells.getMap(j);
		int row = cell.getInt("row");
		int col = cell.getInt("column");		
		Point3d ptOrg = cell.getPoint3d("ptOrg");
		CoordSys cs;
		if (nType==0)
			cs.setToAlignCoordSys(ptOrg, vecX, vecZ, -vecY, ptTruck, vecX, vecY, vecZ);
		else if (nType==1 && nDesign!=2)
			cs.setToAlignCoordSys(ptOrg, vecX,vecY,vecZ, ptTruck+vecY*.5*(dWidth+nAlignment*dStancionWidth), nAlignment*vecX, vecZ, nAlignment*vecY);		
		else if (nType==1 && nDesign==2)
			cs.setToAlignCoordSys(ptOrg, vecX,vecY,vecZ, ptTruck+vecY*.5*(dWidth), nAlignment*vecX, vecZ, nAlignment*vecY);		
		else if (nType==1 && nDesign==3)
			cs.setToAlignCoordSys(ptOrg, vecX,vecY,vecZ, ptTruck+vecY*dWidth, vecX, vecZ, vecY);	
		else if (col==1)
			cs.setToAlignCoordSys(ptOrg, vecX, vecZ, vecY, ptTruck+vecY*.5*(dWidth+dStancionWidth), vecX, vecY, vecZ);
			
		CoordSys csInv=cs;
		csInv.invert();
		
		Point3d pt = ptCOG;
		pt.transformBy(csInv);
		pt+=vecZ * vecZ.dotProduct(ptTruck - pt);//pt.vis(40);	
		ptCogGrids.append(pt);
	}
//End COG//endregion 
	
//region Publish
	{ 
	// write child data to this (parent), (over)write submapX
		Map m;
		m.setString("MyUid", truck.handle());
		m.setPoint3d("ptOrg", csGrid2Truck.ptOrg(), _kRelative);
		m.setVector3d("vecX", csGrid2Truck.vecX(), _kScalable); // coordsys carries size
		m.setVector3d("vecY", csGrid2Truck.vecY(), _kScalable);
		m.setVector3d("vecZ", csGrid2Truck.vecZ(), _kScalable);
		//mapParent.setMap("PackageData", mapData);
		_ThisInst.setSubMapX("Hsb_Grid2Truck",m);			
	}
	
	if (ptCogGrids.length()>0)						_Map.setPoint3dArray("CogGrid[]", ptCogGrids);
	else if (_Map.hasPoint3dArray("CogGrid[]"))		_Map.removeAt("CogGrid[]",true);	

	if (ptXExtremes.length()>0)						_Map.setPoint3dArray("ptXExtreme[]", ptXExtremes);
	else if (_Map.hasPoint3dArray("ptXExtreme[]"))	_Map.removeAt("ptXExtreme[]",true);	
	_Map.setMap("Cell[]", mapCells);	
	_Map.setInt("Design", nDesign);	
	_Map.setMap("Contact[]",mapContacts);	
	_Map.setInt("numRows",nNumRows);
	_Map.setPlaneProfile("Grid", ppGrid);
	_Map.setPoint3d("ptCog", ptCOG);
	_Map.setDouble("Weight", dWeight);
	
	//_Map.setMap("Cells[]", mapCells);
	_ThisInst.setDrawOrderToFront(false);		
//End Publish//endregion 	

}//end GRID MODE_____________________________________________________________________________
		
//End Grid Mode//endregion 

//region Layout Block
// draw layout block
	if (mapLayout.length()>0)
	{
		Map m=mapLayout;
		String key;
		key = "Dimstyle";	if (m.hasString(key))	dpTruck.dimStyle(m.getString(key));
		key = "TextHeight"; if (m.hasDouble(key))
		{
			dpTruck.textHeight(m.getDouble(key));
			dpLayerSeparation.textHeight(m.getDouble(key));
		}
		key = "Color";		if (m.hasInt(key))		dpTruck.color(m.getInt(key));
		String sBlockName;
		double dX, dY;
		key = "Blockname";	if (m.hasString(key))	sBlockName = m.getString(key);

	// draw block
		if (sBlockName.length()>0 && _BlockNames.find(sBlockName)>0)
		{
			Block block(sBlockName);
			if(!bIsKlh)
			{
				dpTruck.draw(block, _Pt0, vecX, vecY, vecZ);
			}
			else if(bIsKlh)
			{
				dpTruck.draw(block, _Pt0, _XW, _YW, _ZW);
			}
		}
		
	// get and draw tags
		Map mapTags = m.getMap("Tag[]");
		for (int i=0;i<mapTags.length();i++) 
		{ 
			Map m = mapTags.getMap(i); 
			String sPropertyName = T(m.getString(0)).makeUpper();
			if (sPropertyName.length()<1)continue;
			
			double dX = m.getDouble("X");
			double dY = m.getDouble("Y");
		
			String sValue;
			int bPropertyFound;		

			Entity entThis = _ThisInst;
			
		// collect tsl or project properties 
			if (sPropertyName==String(sTruckName).makeUpper()) {sValue=_ThisInst.propString(0);bPropertyFound=true;}
			else if (sPropertyName==T("|Number|").makeUpper()) {sValue=_ThisInst.propInt(0);bPropertyFound=true;}
			else if (sPropertyName==T("|Projectname|").makeUpper()) {sValue=projectName();bPropertyFound=true;}
			else if (sPropertyName==T("|ProjectComment|").makeUpper()) {sValue=projectComment();bPropertyFound=true;}
			else if (sPropertyName==T("|ProjectNumber|").makeUpper()) {sValue=projectNumber();bPropertyFound=true;}
			else if (sPropertyName==T("|ProjectStreet|").makeUpper()) {sValue=projectStreet();bPropertyFound=true;}
			else if (sPropertyName==T("|ProjectCity|").makeUpper()) {sValue=projectCity();bPropertyFound=true;}
			
			String sPropSetNames[0];
			sPropSetNames.append("AutoProperties");
			sPropSetNames.append(entThis.attachedPropSetNames());

			if (!bPropertyFound)
			for (int s=0;s<sPropSetNames.length();s++)
			{
				String sPropSetName = sPropSetNames[s];
				Map mapSet;
				if (sPropSetName =="AutoProperties")
					mapSet = entThis.getAutoPropertyMap();
				else
					mapSet = entThis.getAttachedPropSetMap(sPropSetName);
				
				String sPropertyNames[0];
				for (int i=0; i<mapSet.length(); i++)
					sPropertyNames.append(mapSet.keyAt(i).makeUpper());
				
				//if (bDebugIO) reportMessage("\n"+ entThis.handle() + " has the following propSets attached " + sPropertyNames );				
				
				int nIndex = sPropertyNames.find(sPropertyName);
				//if (bDebug) reportMessage("\n	property "+  sPropertyName + " found at " + nIndex);
				if (nIndex>-1)
				{
					if (mapSet.hasInt(nIndex))sValue=mapSet.getInt(nIndex);
					else if (mapSet.hasDouble(nIndex))
					{
						double dValue = mapSet.getDouble(nIndex);
						sValue.formatUnit(dValue ,2,3);
					}
					else
						sValue=mapSet.getString(nIndex);
					bPropertyFound=true;
				}
				
				if (bPropertyFound)
				{
					if (bDebug) reportMessage("\n	" + sValue + " found in propertysets");
					break;
				}
			}// next s propSetName
			if (bDebug && !bPropertyFound) reportMessage("\n	not found in propertysets");	
			
			_Pt0.vis(2);
			if (bPropertyFound)
			{
				Point3d pt;
				if(!bIsKlh)
				{
					pt=_Pt0+vecX*dX+vecY*dY;
					dpTruck.draw(sValue,pt,vecX,vecY,1,1);
					
				}
				else if(bIsKlh)
				{
					// HSB-24086
					pt=_Pt0+_XW*dX+_YW*dY;
					dpTruck.draw(sValue,pt,_XW,_YW,1,1);
				}
//				Display dpLayerSeparation(6);
				// HSB-19191
//				if(bIsKlh)
//				{ 
//				// Show the text for the Layer Separation
//					if (sPropertyName==T("|Number|").makeUpper())
//					{ 
//						dpLayerSeparation.color(6);
//						pt+=vecX*U(10700);
//						String sTxt="Lagentrennung / Layer separation";
//						if(nApplyLayerSeparation)
//							dpLayerSeparation.draw(sTxt,pt,vecX,vecY,1,1);
//					}
//					if(sPropertyName==String(sTruckName).makeUpper())
//					{ 
//						dpLayerSeparation.color(5);
//						pt+=vecX*U(10900);
//						String sTxt="Paket foliert / Package wrapped";
//						if(nPackageWrapped)
//							dpLayerSeparation.draw(sTxt,pt,vecX,vecY,1,1);
//					}
//				}
			}
		}
	}
//End Layout Block//endregion

// performance
	if(bDebug)reportMessage("\n"+ _ThisInst.opmName()+ " " + sMyUID + " ended " + (getTickCount()-nStartTick) + "ms");












#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`$L`9`#`2(``A$!`Q$!_\0`
M'P```04!`0$!`0$```````````$"`P0%!@<("0H+_\0`M1```@$#`P($`P4%
M!`0```%]`0(#``01!1(A,4$&$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*
M%A<8&1HE)B<H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&EJ<W1U
M=G=X>7J#A(6&AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&
MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ>KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!
M`0$!`0````````$"`P0%!@<("0H+_\0`M1$``@$"!`0#!`<%!`0``0)W``$"
M`Q$$!2$Q!A)!40=A<1,B,H$(%$*1H;'!"2,S4O`58G+1"A8D-.$E\1<8&1HF
M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@H.$
MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#W^BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BJDVI65O?VUA-<QI=W6[R82WS/M
M!)('H`.M6Z`"BBB@`HHHH`***J6.I66II,]C<QW"0RF&1HSD!QC(S[9%`%NB
MBB@`HHHH`****`"BBB@`HHHH`**:S*B%G8*H&22<`4D<B2QK)&=R,,J?44`/
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHKC/''BK^RK8Z?92?Z;*/G8?\LE/]3V_/TK*M6C1@YR-\/AYXBHJ<-V
M0Z]\0X]-U&2SL;9+GR^'D+X&[N!ZXKGKWXIZI#`T@MK.-1T^5B?YURMI:SWM
MU';6T;232-A5'4US6L_:(]3GM+A#&]O(T90]B#@UX4,5B:TF[V7]:'UU/+,'
M32@XIR\_S/H;P1X@?Q+X8@OY]GVC>\<P08`8'C_QTJ?QK4UNZELM`U&[@(6:
M"UED0D9`95)'\J\H^"^K^5J%_H[M\LR">('^\O##\01_WS7J/B;_`)%36/\`
MKQF_]`->[AY<\$SY;,:'L,1**VW7S/GSX7:C>:K\7-/O+^YDN;F03%Y)&R3^
MZ?\`3VKZ8KY&\!^(+7PMXOL]8O(II8(%D#)"`6.Y&48R0.I'>O3;G]H)!,1:
M^'6:+LTMWM8_@%./SKMJP<I:(\BC4C&/O,]LHKA_!'Q.TKQI,UFD,EEJ"KO^
MSR,&#@==K<9QZ8!K5\7>-=)\&6"7&HNS2RY$-O$,O)CK]`.Y-8\KO8Z>>-N:
M^AT=%>%S_M!7!E/V?P]$L>>/,N23^BBK^D?'N&YNXH-0T*2(2,%$EO.'Y)Q]
MT@?SJO93[$>WAW+'QVUS4M,TS2K&RNY((+XS"X$?!<+LP,]<?,<CO6C\"_\`
MD0)?^OZ3_P!!2N>_:$^[X=^MS_[2K"\#?%&Q\%>#6T_[!->7SW3R[`P1%4A0
M,MR<\'H*M1;II(R<U&LVSZ*HKQ?3_P!H&VDN%34=!DAA/62"X$A'_`2H_G7K
M>EZK9:UIL.H:?<+/:S+E'7^1]".XK*4)1W-XU(RV9=HK.U'6+73<+(2\I&1&
MO7\?2LH>)[F3F'3RR^NXG^E26=-161I6M-J%R\$EL865-V=V>X'3'O46HZ])
M:7SVD-F973&3N]1GH![T`;E%<RWB._C&Z73BJ>I##]:U-,UFWU/**#'*HR48
M_P`O6@#2HJM>WUO80>;.^`>@'5OI6&WBS+$16+,H]7P?Y&@"7Q8Q%A"`3@R<
MC/7BM72_^039_P#7%?Y5RVKZU'J=K'&(6C='W$$Y'2NITO\`Y!5I_P!<5_E0
M!;HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@#"\6>(X?#&A/?2??=Q%"""07()&?;`)_"O![SQ#'<7,EQ*\DTTC%F;'
M4U[#\4['[9X#NV5=SV\D<R@#_:"G]&->$V]AC#3?@M>/F*3FN=Z=CZO(H05%
MS2UO9GO?@/P_%IVC0:C+'_IMW$'.[K&AY"C\,$__`%JX'XO>'S!K]OJEL@VW
MJ;9`#_&F!G\05_(UD#QSXCTN%?(U25L855EPXQZ?,#2ZUXTN_%UK9K>6T44M
MH7R\1.'W;>QZ8V^O>AUZ7U;E@K6'1P6*AC?;3DFG>_IT_0R?"4]YI/BS3;N*
M%V*SJK*@R65OE8`=S@FOH3Q-QX4UC_KQF_\`0#7)?#SPA]BB36K^/%S(O^CQ
ML/\`5J?XC[D?D/K76^)O^14UC_KQF_\`0#7;@8S4+SZGDYUB*=6M:'V5:_\`
M78^7/`6@6WB;QG8:3>/(EO,7:0QG#$*A;&>V<8KZ)?X7^#6TUK(:)`JE=HE4
MGS1[[R<YKPSX._\`)3M+_P!V;_T4]?45>E6DU+0^?P\8N-VCY(\(22Z5\1M(
M$+G='J,<)/JI?8WY@FNK^._G?\)U;;\^7]@3R_3[[Y_6N2T3_DI&G?\`87C_
M`/1PKZ1\8^#-$\90P6NI,8KJ,,UO+$X$BCC/!ZKTR,?E5SDHR39G3BY0:1Y_
MX3UKX46?AJPCO8+`7HA47/VRQ:5_,Q\WS%3QG.,'I6]::5\+/%MTD6F1Z=]K
M1MZ+;9MWR.<A>-WY&L(_L^VF?E\0S`=@;4'_`-FKRGQ-HL_@OQ=<:=#>^9-9
MNCQW$7R'D!E/7@C([U*49/W64Y2@O>BK'J'[0GW?#OUN?_:5-^$/@7P[KOAJ
M35=4T\7=R+IXE\QVVA0%/W0<=SUJG\:[Q]0T#P;>R#:]Q;RS,,="RPG^M=?\
M"_\`D0)/^OZ3_P!!2AMJD-).L[F#\6_AYHFF>&3K>CV2V<UO*BS+$3L=&.WI
MV()'(]Z;\`=3D\G6M-=R88_+N(U_NDY#?GA?RK?^-VM6]EX).EF5?M5_*@6+
M/S;%;<6QZ94#\:YGX`V+O)KMV01'LBA4^I.XG\N/SI*[I:C:2K+E/0='MQJV
ML2W%R-RC]X5/0G/`^G^%=B`%4```#H!7(^&I!:ZI-;2_*S*5`/\`>!Z?SKKZ
MP.H2JMSJ%G9']_,B,W..I/X#FK1.%)]!7%Z1;+K&J327;,W&\@'&>?Y4`=!_
MPD6EG@W!Q[QM_A6#8M#_`,)2K6I_<L[;<<#!!KH?[!TS;C[(N/\`>;_&N?M8
M([;Q8L,0VQI(0HSGM3`EU!?[2\4I:N3Y:$+@>@&X_P!:ZJ**."(1Q(J(.BJ,
M5RLS"S\8B20@*SC!/3#+BNMI`<YXLC06L$@1=YDP6QSC'K6QI?\`R"K3_KBO
M\JRO%G_'C!_UT_H:U=+_`.05:?\`7%?Y4`6Z***`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`0@,""`01@@UQNO?#C2M4#
M36(%A<GG]VO[MC[KV_"NSHK.I2A45IJYM1Q%6A+FINS/`=5^&WBL7'E0:<L\
M:=)(YT"M]-Q!_2NA\!_#>^MKXW7B"U$,4+!HX"ZOYC=B<$C`].]>NT5A'!4H
MV/0J9SB:D'#17ZK?\PK/UVWEN_#VI6UNF^::TECC7(&YBA`'/O6A176>2SP/
MX:_#WQ3H7CRPU'4]):"TB$H>0S1MC,;`<!B>I%>^4454Y.3NR(04%9'SEI7P
MT\86WC>QU"71F6UCU*.9I//BX02`DXW9Z5Z'\6/!.M^+/[*N-%:'S+'S=RO+
ML8[MF-IQC^$]2*]*HJG4;:9*HQ47'N?-R^&?BY9KY,;ZTJ#@+'J65'TP^*M>
M'_@OXBU74EN/$++9VQ??-NF$DTG<XP2,GU)_`U]#T4_;2Z$_5X]3S3XI^`=3
M\6VNCQZ-]E1;`2J8Y7*<,$VA>".-IZX[5Y>GPN^(FF.?L5G*O^U;7T:Y_P#'
MP:^FZ*4:KBK#E1C)W/F^Q^#?C/6+P2:LT=H"?GFN;@2OCV"DY/L2*]W\,>&[
M'PIH4.E6`/EI\SR-]Z1SU8^Y_D`*V:*4JCEHRH4HPU1A:MH!NI_M5HXCFZD'
M@$COGL:JJ_B6$;-GF`="=I_6NGHJ#0R-*_MAKEVU#`AV?*OR]<CT_&LZ?0KZ
MRO&N-+<8)X7(!'MSP17444`<R(/$ES\DDHA7UW*/_0>:2UT&YL=8MI0?-A'+
MOD#!P>U=/10!DZSHPU)%>-@EP@PI/0CT-9T1\1VB"(1"55X4MM;CZY_G73T4
G`<G<6.NZIM6Y5%13D`E0!^7-=+9PM;6,$#D%HXPI(Z<"IZ*`/__9
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
        <int nm="BreakPoint" vl="2280" />
        <int nm="BreakPoint" vl="2280" />
        <int nm="BreakPoint" vl="1359" />
        <int nm="BreakPoint" vl="2283" />
        <int nm="BreakPoint" vl="2283" />
        <int nm="BreakPoint" vl="1359" />
        <int nm="BreakPoint" vl="2283" />
        <int nm="BreakPoint" vl="2283" />
        <int nm="BreakPoint" vl="3410" />
        <int nm="BreakPoint" vl="4978" />
        <int nm="BreakPoint" vl="4962" />
        <int nm="BreakPoint" vl="4596" />
        <int nm="BreakPoint" vl="3024" />
        <int nm="BreakPoint" vl="2876" />
        <int nm="BreakPoint" vl="450" />
        <int nm="BreakPoint" vl="5113" />
        <int nm="BreakPoint" vl="5117" />
        <int nm="BreakPoint" vl="429" />
        <int nm="BreakPoint" vl="455" />
        <int nm="BreakPoint" vl="1924" />
        <int nm="BreakPoint" vl="1989" />
        <int nm="BreakPoint" vl="2353" />
        <int nm="BreakPoint" vl="1801" />
        <int nm="BreakPoint" vl="1773" />
        <int nm="BreakPoint" vl="2725" />
        <int nm="BreakPoint" vl="4841" />
        <int nm="BreakPoint" vl="4014" />
        <int nm="BreakPoint" vl="5313" />
        <int nm="BreakPoint" vl="4903" />
        <int nm="BreakPoint" vl="4050" />
        <int nm="BreakPoint" vl="4059" />
        <int nm="BreakPoint" vl="4847" />
      </lst>
    </lst>
  </lst>
  <lst nm="TslInfo">
    <lst nm="TSLINFO">
      <lst nm="TSLINFO" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24830: Store transformation for each layer separately in case multiple layers at one row" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="70" />
      <str nm="Date" vl="11/3/2025 10:16:09 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Adjustment to the creation point of hsbPivotSchedule and PlotViewports" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="69" />
      <str nm="Date" vl="9/23/2025 2:59:26 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24602: Fix transformation for vertical stacking (nType==1 &amp;&amp; nDesign==2)" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="68" />
      <str nm="Date" vl="9/22/2025 2:11:09 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24486: Change position of hsbPivotSchedule" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="67" />
      <str nm="Date" vl="9/8/2025 10:17:54 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24486: Update Layer2Truck transformation for KLH (fix)" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="66" />
      <str nm="Date" vl="9/8/2025 9:03:17 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24485: Update Layer2Truck transformation for KLH" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="65" />
      <str nm="Date" vl="9/3/2025 10:48:09 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24485: Fix when saving &quot;mapsCombi&quot;" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="64" />
      <str nm="Date" vl="9/3/2025 8:56:30 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24485: for KLH, fix dimension orientation; fix starting point of dimension" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="63" />
      <str nm="Date" vl="9/3/2025 8:22:21 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24432: Fix transformation for KLH" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="62" />
      <str nm="Date" vl="8/25/2025 3:09:11 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24432: Fix translation" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="61" />
      <str nm="Date" vl="8/25/2025 2:03:38 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Adjustment to the creation point of hsbPivotSchedule, Susanne Müller" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="60" />
      <str nm="Date" vl="8/21/2025 7:23:39 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24401: For KLH: Clean/update variable &quot;Package wrapped&quot; in mapX; show command &quot;Apply Layer Separation&quot;" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="59" />
      <str nm="Date" vl="8/11/2025 3:37:11 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24278: For panels get weight from extended data if provided in xml" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="58" />
      <str nm="Date" vl="7/8/2025 10:57:07 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24277: Dbcreate klhStackMatrix on dbCreated" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="57" />
      <str nm="Date" vl="7/7/2025 1:17:44 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24277: Differentiate FrontDistance with truck name; &quot;SubDesign[]&quot; in XML" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="56" />
      <str nm="Date" vl="7/7/2025 11:41:01 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Change plot viewport distances for sections, Susanne Müller" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="55" />
      <str nm="Date" vl="6/30/2025 2:59:48 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24206: Display block for the front of truck in Grid; extend xml" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="54" />
      <str nm="Date" vl="6/30/2025 10:51:11 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24205: Missing transformation for KLH" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="53" />
      <str nm="Date" vl="6/23/2025 5:46:21 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24148: for KLH: save body volume for combi truck" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="52" />
      <str nm="Date" vl="6/16/2025 2:38:26 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24148: Fix shadow at horizontal stacking for KLH" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="51" />
      <str nm="Date" vl="6/16/2025 11:48:02 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24097 new commands to generate plot viewports (default only)" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="50" />
      <str nm="Date" vl="5/28/2025 9:08:28 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24086: Fix section projections for horizontal stacking for KLH" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="49" />
      <str nm="Date" vl="5/26/2025 1:28:03 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24008: Fix: Transformation for KLH mode 1 (truck gride mode) for vertical stacking" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="48" />
      <str nm="Date" vl="5/21/2025 6:52:52 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24008: Transformation for KLH mode 1 (truck gride mode) for vertical stacking" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="47" />
      <str nm="Date" vl="5/19/2025 2:00:34 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24008: Transformation for KLH mode 0 (truck mode) fro vertical stacking" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="46" />
      <str nm="Date" vl="5/19/2025 1:57:03 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24007: Transformation for KLH" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="45" />
      <str nm="Date" vl="5/12/2025 1:18:16 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23527: Save single bodies in an array" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="44" />
      <str nm="Date" vl="2/24/2025 1:19:38 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23446: KLH: save each grid in separate map for the Combi" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="43" />
      <str nm="Date" vl="2/10/2025 4:24:22 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23445: Provide weight and cog of combiTruck" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="42" />
      <str nm="Date" vl="2/4/2025 8:58:33 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23341: For KLH distinguish items generated from CombiTruck from the rest" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="41" />
      <str nm="Date" vl="1/20/2025 10:01:22 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23131: Write in _Map body, planeprofile, weight and cog " />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="40" />
      <str nm="Date" vl="12/9/2024 10:58:29 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22893: Set dim positions relative to the truck sections" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="39" />
      <str nm="Date" vl="10/31/2024 8:07:19 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22875: Add package dimensions for KLH" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="38" />
      <str nm="Date" vl="10/28/2024 2:10:17 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22771: show text for min weight only when truck is loaded, at least 5000kg." />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="37" />
      <str nm="Date" vl="10/7/2024 4:24:02 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22608: new equation for the min axial weight" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="36" />
      <str nm="Date" vl="9/9/2024 4:59:18 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22499: For KLH show each item in grid" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="35" />
      <str nm="Date" vl="8/5/2024 11:52:46 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="20240711: Fix when assigning the Bottom/Top panel flag from layers" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="34" />
      <str nm="Date" vl="7/11/2024 11:26:49 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22361: cleanup mapx when not top/bottom plate" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="33" />
      <str nm="Date" vl="7/4/2024 8:49:54 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22320: Write in mapx top/bottom plate at layer" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="32" />
      <str nm="Date" vl="7/2/2024 1:47:07 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21968: Consider the min axl load in the calculation" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="31" />
      <str nm="Date" vl="4/29/2024 10:23:03 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20735: Avoid dublicated instances of &quot;hsbPivotSchedule&quot;" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="30" />
      <str nm="Date" vl="11/27/2023 8:41:03 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20616: create hsbPivotSchedule with weight for each package on &quot;Generate Plot viewport&quot;" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="29" />
      <str nm="Date" vl="11/20/2023 6:18:21 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19939: Apply contour thickness on the inside" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="28" />
      <str nm="Date" vl="9/12/2023 1:55:25 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19937: KLH: Show Weight also if no axle definition found" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="27" />
      <str nm="Date" vl="9/5/2023 4:37:17 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19937: Fix &quot;readOnly&quot; properties" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="26" />
      <str nm="Date" vl="9/5/2023 3:23:03 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19487: Only take the relevant properties when changing the &quot;Stacking&quot; extended properties" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="25" />
      <str nm="Date" vl="7/26/2023 10:17:53 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19483: Apply thickness to the outter contour for Truck and Grid" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="24" />
      <str nm="Date" vl="7/10/2023 11:06:24 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19334: Use &quot;PropertyReadOnly&quot; flag from the xml" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="23" />
      <str nm="Date" vl="6/28/2023 9:57:14 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19334: set properties &quot;ReadOnly&quot; for KLH" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="22" />
      <str nm="Date" vl="6/27/2023 10:02:08 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19191: remove display for KLH" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="21" />
      <str nm="Date" vl="6/12/2023 1:07:17 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18964: Set &quot;BeddingRequested&quot; flag for f_Item" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="20" />
      <str nm="Date" vl="5/26/2023 5:34:52 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18847: Change RowOffset for KLH; It is the distance top to top " />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="19" />
      <str nm="Date" vl="5/3/2023 4:32:06 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18847: Add command &quot;Generate Plot ViewPort&quot;" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="18" />
      <str nm="Date" vl="5/3/2023 1:56:16 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18371: Design &quot;Individuell&quot; will contain multiple axle definitions" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="17" />
      <str nm="Date" vl="3/30/2023 1:54:01 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="#DEV: HSB-18371: For KLH get the net weight from the property set" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="16" />
      <str nm="Date" vl="3/23/2023 1:18:56 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18360: fix weight calculation for mass elements" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="15" />
      <str nm="Date" vl="3/17/2023 1:12:24 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18017: fix flag &quot;L&quot; for layer separation in &quot;StackingData&quot;" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="14" />
      <str nm="Date" vl="2/20/2023 1:54:49 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18012: Command add layer separation should be applied to f_Item instances" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="13" />
      <str nm="Date" vl="2/17/2023 11:54:44 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17789: Fix translation for load calculation" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="12" />
      <str nm="Date" vl="2/3/2023 9:12:22 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-7512: for KLH: Distribution of loads for each axle" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="11" />
      <str nm="Date" vl="1/22/2023 4:39:32 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-7512: for KLH: Set Properties readOnly; Workaround when hideDisplay fails; Extend options in property Design" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="10" />
      <str nm="Date" vl="1/19/2023 10:57:29 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15456: after projection, remove segments with zero length " />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="5/11/2022 2:49:30 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15355: fix when writing &quot;StackingData&quot; mapX" />
      <int nm="MajorVersion" vl="6" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="4/28/2022 2:30:12 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End