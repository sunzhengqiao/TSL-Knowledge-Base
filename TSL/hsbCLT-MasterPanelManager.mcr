#Version 8
#BeginDescription
#Versions
Version 14.10 11/09/2025 HSB-24493: Write in mapx the DeliveryMaster as the smallest delivery number of all nested childs , Author Marsel Nakuci
Version 14.9 20/08/2025 HSB-24434: Add child panel calculation based on outter contour , Author Marsel Nakuci
Version 14.8 16.06.2025 HSB-24167 During the manual placement of child panels, it is possible that the user may unintentionally position objects so that they intersect the protected area of the master panel overcuts.
   To help visualize these relatively small overlaps, a new visual indication has been added that highlights such intersections.
   The visualization also simplifies correct placement by providing snap points
   The display of this warning can be toggled on or off via a context command, intended for cases where the overlap is intentional.
   This command is only available when an overlap is actually present.
Version 14.7 08/04/2025 HSB-23793: Fix when checking thickness inconsistencies , Author Marsel Nakuci
Version 14.6 20.02.2025 HSB-22579: Add  command to turn off warning for inconsistent thicknesses , Author: Marsel Nakuci
Version 14.5 07.02.2025 HSB-22579: Add reportNotice when inconsistent childpanel thicknesses , Author: Marsel Nakuci
Version 14.4 17.01.2025 HSB-22958 Plotview Settings Dialog fixed
Version 14.3 16.01.2025 HSB-23333 first line header text fixed
Version 14.2 05.12.2024 Make-762: save graphics in file for render in hsbView and make
Version 14.1 30.09.2024 HSB-22739 new settings to suport isotropic panel style name convention
Version 14.0 10.09.2024 HSB-22644 bugfix tag location (introduced HSB-22351) 

Version 13.9 23.07.2024 HSB-22452 bugfix grid values Y-direction
Version 13.8 15.07.2024 HSB-22094 custom block tag supports generic format resolving of masterpanel. If the master panel resolving does not yield a value, the first panel of the nesting will be utilized for attempting format resolving
Version 13.7 03.07.2024 HSB-22351 supports grain dependent color coding for the grain direction symbol, i.e. @(GrainDirection:CW93:LW:12:D)
Version 13.6 02.07.2024 HSB-22351 new settings to specify childpanel tag transparency. tag location avoids opening intersection, new option to toggle grips to move tag locations
Version 13.5 04.06.2024 HSB-22009 new options to create plot viewports
Version 13.4 16.04.2024 HSB-21898 description order fixed
Version 13.3 16.04.2024 HSB-21898 new warning will be displayed if the flipping of child panels was unsuccessful due to geometric constraints.
Version 13.2 02.04.2024 HSB-21514 bugfix xRef purging
Version 13.1 13.03.2024 HSB-21640 publishing masterpanel oversize for stock panel creation
Version 13.0 29.02.2024 HSB-20825 bugfix writing range values

Version 12.9 28.02.2024 HSB-20825 new properties exposed to 'configure settings' to allow value or range based auto sizing. refer to tooltips of properties to obtain more detailed information
Version 12.8 23.02.2024 HSB-21485 highlighting of 12.7 restricted to panels with beveled edges
Version 12.7 20.02.2024 HSB-21485 invalid feed directions highlighted
Version 12.6 31.01.2024 HSB-21255 color coding of element based and stacked panels enhanced
Version 12.5 21.12.2023 HSB-20997 new mapX property 'BoundingWasteArea' stores area of all bounding box areas of nested panels
Version 12.4 12.12.2023 HSB-20417 block refs conflicting xref resolved
Version 12.3 04.12.2023 HSB-20283 new settings exposed to locate header and override color and size of first line of tag
Version 12.2 29.11.2023 HSB-20753 accepting custom data to be appended to subMapX 'Masterpanel'
Version 12.1 28.11.2023 HSB-20754 new mapX property 'BoundingWaste' calculates waste based on bounding rectangular child shapes. 'DataLink.MasterPanel' added to each panel to access masterpanel properties in relation to the individual panel
Version 12.0 27.11.2023 HSB-20643 new setting to specify master oversize in X and/or Y, requires hsbDesign 26 or higher

Version 11.3 07.06.2023 HSB-19101 feed direction only shown when explictly defined
Version 11.2 23.05.2023 HSB-19024 instance is not shown when looking from positive or negative X-World or Y-World to improve model visibility
Version 11.1 15.03.2023 HSB-17748 preventing duplicate child references
Version 11.0 01.03.2023 HSB-18167 accepting text color override of child texts through linked stacking packages

Version 10.9 22.02.2023 HSB-17732 bugfix xref override
Version 10.8 30.01.2023 HSB-17732 accepting xref override properties and show duplicate warnings
Version 10.7 07.11.2022 HSB-16985 allows creation of empty masterpanels on insert
Version 10.6 26.10.2022 HSB-16897 new properties to override the default masterpanel dimensions, new property to override the auto size mode
Version 10.5 25.10.2022 HSB-16887 accepts preferred nesting face specified on panels with identical qualities on each face, supports formatting helper methods on insert and through OPM
Version 10.4 28.09.2022 HSB-16637 accepts panels nested in elements which are stacked in a truck loading
Version 10.3 06.09.2022 HSB-16247 accepts manual override of master surfacequality style if selected quality is higher
Version 10.2 02.08.2022 HSB-16179 optional remote shape lock added. Requires special tools to deactivate the automatic shape creation
Version 10.1 25.07.2022 HSB-15610 yield constantly updated
Version 10.0 29.06.2022 HSB-15874 additional properties added to submap Masterpanel, i.e. access data using @(Masterpanel.Waste). 
!! Requires hsbDesign 24 or higher !!

Version 9.3 11.04.2022 HSB-15000 child elevation fixed to upper face of masterpanel
Version 9.2    18.10.2021   HSB-13524 a new option 'Add Openings to Masterpanel' is avalable in the configuration dialog to toggle openings of masterpanels on or off
Version 9.1    28.04.2021   HSB-11716 display settings for child and master text display enriched., accessible context command
Version 9.0    03.03.2021   HSB-10750 bugfix exporting global settings, validating company folder structure
Version 8.9   15.02.2021    HSB-10750 global settings can be modified, imported and exported by context custom command

/// This tsl displays properties of associated childpanels of the referenced master panel
/// initially it will execute a nesting, but one can fire this command through context as well


















































#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 14
#MinorVersion 10
#KeyWords Nesting;CLT;Masterpanel;Childpanel,Sip;XRef
#BeginContents
//region Part #1

//region <History>

/// <summary Lang=en>
/// This tsl displays properties of associated childpanels of the referenced master panel
/// initially it will execute a nesting, but one can fire this command through context as well
/// </summary>

/// History
// #Versions
// 14.10 11/09/2025 HSB-24493: Write in mapx the DeliveryMaster as the smallest delivery number of all nested childs , Author Marsel Nakuci
// 14.9 20/08/2025 HSB-24434: Add child panel calculation based on outter contour , Author Marsel Nakuci
// 14.8 16.06.2025 HSB-24167 During the manual placement of child panels, it is possible that the user may unintentionally position objects so that they intersect the protected area of the master panel overcuts.To help visualize these relatively small overlaps, a new visual indication has been added that highlights such intersections. , Author Thorsten Huck
// 14.7 08/04/2025 HSB-23793: Fix when checking thickness inconsistencies , Author Marsel Nakuci
// 14.6 20.02.2025 HSB-22579: Add  command to turn off warning for inconsistent thicknesses , Author: Marsel Nakuci
// 14.5 07.02.2025 HSB-22579: Add reportNotice when inconsistent childpanel thicknesses , Author: Marsel Nakuci
// 14.4 17.01.2025 HSB-22958 Plotview Settings Dialog fixed , Author Thorsten Huck
// 14.3 16.01.2025 HSB-23333 first line header text fixed , Author Thorsten Huck
// 14.2 05.12.2024 Make-762: save graphics in file for render in hsbView and make Author: Marsel Nakuci
// 14.1 30.09.2024 HSB-22739 new settings to suport isotropic panel style name convention , Author Thorsten Huck
// 14.0 10.09.2024 HSB-22644 bugfix tag location (introduced HSB-22351) , Author Thorsten Huck
// 13.9 23.07.2024 HSB-22452 bugfix grid values Y-direction , Author Thorsten Huck
// 13.8 15.07.2024 HSB-22094 custom block tag supports generic format resolving of masterpanel. If the master panel resolving does not yield a value, the first panel of the nesting will be utilized for attempting format resolving  , Author Thorsten Huck
// 13.7 03.07.2024 HSB-22351 supports grain dependent color coding for the grain direction symbol, i.e. @(GrainDirection:CW93:LW:12:D) , Author Thorsten Huck
// 13.6 02.07.2024 HSB-22351 new settings to specify childpanel tag transparency. tag location avoids opening intersection, new option to toggle grips to move tag locations , Author Thorsten Huck
// 13.5 04.06.2024 HSB-22009 new options to create plot viewports , Author Thorsten Huck
// 13.4 16.04.2024 HSB-21898 description order fixed , Author Thorsten Huck
// 13.3 16.04.2024 HSB-21898 new warning will be displayed if the flipping of child panels was unsuccessful due to geometric constraints. , Author Thorsten Huck
// 13.2 02.04.2024 HSB-21514 bugfix xRef purging , Author Thorsten Huck
// 13.1 13.03.2024 HSB-21640 publishing masterpanel oversize for stock panel creation , Author Thorsten Huck
// 13.0 29.02.2024 HSB-20825 bugfix writing range values , Author Thorsten Huck
// 12.9 28.02.2024 HSB-20825 new properties exposed to 'configure settings' to allow value or range based auto sizing. refer to tooltips of properties to obtain more detailed information , Author Thorsten Huck
// 12.8 23.02.2024 HSB-21485 highlighting of 12.7 restricted to panels with beveled edges , Author Thorsten Huck
// 12.7 20.02.2024 HSB-21485 invalid feed directions highlighted , Author Thorsten Huck
// 12.6 31.01.2024 HSB-21255 color coding of element based and stacked panels enhanced , Author Thorsten Huck
// 12.5 21.12.2023 HSB-20997 new mapX property 'BoundingWasteArea' stores area of all bounding box areas of nested panels , Author Thorsten Huck
// 12.4 12.12.2023 HSB-20417 - block refs conflicting xref resolved , Author Thorsten Huck
// 12.3 04.12.2023 HSB-20283 new settings exposed to locate header and override color and size of first line of tag , Author Thorsten Huck
// 12.2 29.11.2023 HSB-20753 accepting custom data to be appended to subMapX 'Masterpanel' , Author Thorsten Huck
// 12.1 28.11.2023 HSB-20754 new mapX property 'BoundingWaste' calculates waste based on bounding rectangular child shapes. 'DataLink.MasterPanel' added to each panel to access masterpanel properties in relation to the individual panel , Author Thorsten Huck
// 12.0 27.11.2023 HSB-20643 new setting to specify master oversize in X and/or Y, requires hsbDesign 26 or higher , Author Thorsten Huck
// 11.3 07.06.2023 HSB-19101 feed direction only shown when explictly defined , Author Thorsten Huck
// 11.2 23.05.2023 HSB-19024 instance is not shown when looking from positive or negative X-World or Y-World to improve model visibility , Author Thorsten Huck
// 11.1 15.03.2023 HSB-17748 preventing duplicate child references , Author Thorsten Huck
// 11.0 01.03.2023 HSB-18167 accepting text color override of child texts through linked stacking packages , Author Thorsten Huck
// 10.9 22.02.2023 HSB-17732 bugfix xref override , Author Thorsten Huck
// 10.8 30.01.2023 HSB-17732 accepting xref override properties and show duplicate warnings , Author Thorsten Huck
// 10.7 07.11.2022 HSB-16985 allows creation of empty masterpanels on insert , Author Thorsten Huck
// 10.6 26.10.2022 HSB-16897 new properties to override the default masterpanel dimensions, new property to override the auto size mode , Author Thorsten Huck
// 10.5 25.10.2022 HSB-16887 accepts preferred nesting face specified on panels with identical qualities on each face, supports formatting helper methods on insert and through OPM , Author Thorsten Huck
// 10.4 28.09.2022 HSB-16637 accepts panels nested in elements which are stacked in a truck loading , Author Thorsten Huck
// 10.3 06.09.2022 HSB-16247 accepts manual override of master surfacequality style if selected quality is higher , Author Thorsten Huck
// 10.2 02.08.2022 HSB-16179 optional remote shape lock added. Requires special tools to deactivate the automatic shape creation , Author Thorsten Huck
// 10.1 25.07.2022 HSB-15610 yield constantly updated , Author Thorsten Huck
// 10.0 29.06.2022 HSB-15874 additional properties added to submap Masterpanel, i.e. access data using @(Masterpanel.Waste). Requires hsbDesign 24 or higher , Author Thorsten Huck
// 9.3 11.04.2022 HSB-15000 child elevation fixed to upper face of masterpanel , Author Thorsten Huck
// 9.2 18.10.2021 HSB-13524 a new option 'Add Openings to Masterpanel' is avalable in the configuration dialog to toggle openings of masterpanels on or off. , Author Thorsten Huck
// 9.1 28.04.2021 HSB-11716 display settings for child and master text display enriched., accessible context command , Author Thorsten Huck
// 9.0 03.03.2021 HSB-10750 bugfix exporting global settings, validating company folder structure , Author Thorsten Huck
// 8.9 15.02.2021 HSB-10750 global settings can be modified, imported and exported by context custom command , Author Thorsten Huck
///<version value="8.8" date="27jan2021" author="nils.gregor@hsbcad.com"> Commit issue</version>
///<version value="8.7" date="27jan2021" author="nils.gregor@hsbcad.com"> Commit issue</version>
///<version value="8.6" date="17jan2021" author="nils.gregor@hsbcad.com"> HSB-10011 Bugfix remove master if childs empty and do not update presorter at insert </version>
///<version value="8.5" date="14jan2021" author="nils.gregor@hsbcad.com"> HSB-10011 Bugfix nesting panels crosswise creates wrong positioning in first masterpanel</version>
///<version value="8.4" date="08dec2020" author="thorsten.huck@hsbcad.com"> HSB-9504 oversize of childpanels will be ignored in width if panel matches full masterpanel width</version>
///<version value="8.3" swidthndate="10sep2020" author="thorsten.huck@hsbcad.com"> HSB-8788 set feed commands extended and disabled if not configured in settings. custom display of feed direction added, HSB-8512 missing dongle not causing multiple nesting attempts with presorted groups </version>
///<version value="8.1" date="09sep2020" author="thorsten.huck@hsbcad.com"> HSB-8512 missing autonester dongle will not cause multiple nesting attempts </version>
///<version value="8.0" date="15jul2020" author="thorsten.huck@hsbcad.com"> HSB-7225 slight overlapping childpanels fixed with Autonester </version>
///<version value="7.9" date="06jul2020" author="thorsten.huck@hsbcad.com"> HSB-8219 childpanel property display supports \P, new optional properties 'MasterStartNumber' and 'KeepFloorReferenceBottom' published to settings, childpanel oversizes only displayed if > 0 </version>
///<version value="7.8" date="26jun2020" author="thorsten.huck@hsbcad.com"> HSB-8114 oversize of childpanel accepts any value </version>
///<version value="7.7" date="20apr2020" author="thorsten.huck@hsbcad.com"> HSB-6924 oversize of childpanel fixed if no routing data given sublabel2 </version>
///<version value="7.6" date="03apr2020" author="thorsten.huck@hsbcad.com"> HSB-7194 Refuse inner childs of being processed on edge alignment </version>
///<version value="7.5" date="03apr2020" author="thorsten.huck@hsbcad.com"> HSB-7192 align with edge: test interference of alignment on real contour and not on bounding box </version>
///<version value="7.4" date="30mar2020" author="thorsten.huck@hsbcad.com"> HSB-7143 bugfix GIT merge  </version>
///<version value="7.3" date="23mar2020" author="thorsten.huck@hsbcad.com"> HSB-7019 bugfix potential ranges and specified rule also used for subsequent instances  </version>
///<version value="7.2" date="17mar2020" author="thorsten.huck@hsbcad.com"> HSB-5581 bugfix 'Auto Edge Alignment on/off' option select all </version>
///<version value="7.1" date="17mar2020" author="thorsten.huck@hsbcad.com"> HSB-6924 Adding childs to master improved, Command 'Add Child Panels' moved to top level of context commands, Command 'Set Fixed Width' triggers nesting </version>
///<version value="7.0" date="16mar2020" author="thorsten.huck@hsbcad.com"> HSB-5648 New settings map to configure child header definitions </version>
///<version value="6.9" date="16mar2020" author="thorsten.huck@hsbcad.com"> HSB-5581 New commands 'Auto Edge Alignment on/off' and 'Nesting (Reset Rotations)' available in context menu. New setting 'Nesting\EdgeAlignment'. EdgeAlignment = 1: child panels will be aligned to the closest edge along X-Axis if transformation does not intersect with other panels   </version>
///<version value="6.8" date="13mar2020" author="thorsten.huck@hsbcad.com"> HSB-5581 New command 'Align Panels with Edge' available in context menu </version>
///<version value="6.7" date="12mar2020" author="thorsten.huck@hsbcad.com"> HSB-5581 Left/Right alignment prepared, new custom command to set a fixed width of the master </version>
///<version value="6.6" date="12mar2020" author="thorsten.huck@hsbcdpad.com"> HSB-6924 Autonester supports 180° rotation </version>
///<version value="6.5" date="05mar2020" author="thorsten.huck@hsbcad.com"> HSB-6641, HSB-6643 child orientation fixed, new option of automatic grain detection , grouped width consumption if specified in presorting </version>
///<version value="6.4" date="05feb2020" author="thorsten.huck@hsbcad.com"> HSB-5647 new context commands have been added to the top level. One or multiple childs can be flipped, rotated or flipped and rotated. The properties of the panels and of masterpanel manager might refuse the action if invalid (i.e. surface quality not mapping)</version>
///<version value="6.3" date="05feb2020" author="thorsten.huck@hsbcad.com"> HSB-6555 master orientation revised, refused child panels bundled with hsbCLT-Presorter, potential resorter Link removed during nesting </version>
///<version value="6.2" date="06dec19" author="thorsten.huck@hsbcad.com"> HSB-6036 rotation property removed, dialog remembers last values </version>
///<version value="6.1" date="29nov19" author="thorsten.huck@hsbcad.com"> HSB-6036 rotation property disabled, child alignment in master fixed, potential left over panel will be transformed outside of master </version>
///<version value="6.0" date="24oct19" author="thorsten.huck@hsbcad.com"> HSB-5661: HSB-5661 if nesting of childs into master fails the master will be purged and the user will be informed, bugfix combined quality (Top/Bot) display </version>
///<version value="5.9" date="24oct19" author="thorsten.huck@hsbcad.com"> HSB-5661 fixed</version
///<version value="5.8" date="24oct19" author="thorsten.huck@hsbcad.com"> HSB-5781 fixed, HSB-5770 reverted due to performance </version>
///<version value="5.7" date="17oct19" author="thorsten.huck@hsbcad.com"> HSB-5770 childs below master and profile coordSys fixed </version>
///<version value="5.6" date="26sep19" author="thorsten.huck@hsbcad.com"> HSB-5579 new parameters in settings supported to specify a spacing override if spacing property = 0 </version>
///<version value="5.5" date="26sep19" author="thorsten.huck@hsbcad.com"> HSB-5650 bugfix option nest in opening </version>
///<version value="5.4" date="06aug19" author="thorsten.huck@hsbcad.com"> MPN-1, MPN-2, MPN-3 first draft of multi project nesting </version>
///<version value="5.3" date="13may19" author="thorsten.huck@hsbcad.com"> String values GrainDirectionText, GrainDirectionTextShort and yield added to mapX of the masterpanel (MAPX: key = Masterpanel) </version>
///<version value="5.2" date="10may19" author="thorsten.huck@hsbcad.com"> HSB-5011 new commands to add or remove masterpanel data to its referenced panels (MAPX: key = Masterpanel) </version>
///<version value="5.1" date="25jan19" author="thorsten.huck@hsbcad.com"> HSBCAD-417 masterpanel format variable resolving enhanced, new display of tsl based drawing requests: any pline in conjunction with a dZ value will display the outline and an extruded body of the shape </version>
///<version value="5.0" date="24jan19" author="thorsten.huck@hsbcad.com"> Inbox-711 format variable resolving enhanced the following additional virtual properties have been added: Yield','GrainDirectionTextShort','GrainDirectionText','surfaceQualityBottom', 'surfaceQualityTop', 'GrainDirection', The parameter 'DimStyle ' can be preset in settings file	  </version>
///<version value="4.9" date="05dec18" author="thorsten.huck@hsbcad.com"> format variable resolving redesigned to @(<FormatKey>) syntax, backslash '\' expresses line feed </version>
///<version value="4.8" date="04dec18" author="thorsten.huck@hsbcad.com"> masterpanel style assignment improved </version>
///<version value="4.7" date="03dec18" author="thorsten.huck@hsbcad.com"> setting feed direction now also supports non orthogonal vectors to distinguish machine reference side </version>
///<version value="4.6" date="30nov18" author="thorsten.huck@hsbcad.com"> reading of settings generalized </version>
///<version value="4.5" date="30nov18" author="thorsten.huck@hsbcad.com"> commands listed in header </version>
///<version value="4.4" date="29nov18" author="thorsten.huck@hsbcad.com"> HSBCAD-282: new parameters to create dimensions instead of ruler dimensions </version>
///<version value="4.3" date="09nov18" author="thorsten.huck@hsbcad.com"> HSBCAD-282: new parameter group 'Header' to specify a block based tag </version>
///<version value="4.2" date="26oct18" author="thorsten.huck@hsbcad.com"> new parameters Autosize\X\Minimum and Autosize\Y\Minimum specify minimal auto size in given direction </version>
///<version value="4.1" date="18jun18" author="thorsten.huck@hsbcad.com"> supports link to hsbAcadamy documenation, bugfix reading autosize values from settings, The import and export is now driven by TslSettingsIO.mcr unless no setting could be found. NOTE: settings are now stored in <company>\tsl\settings\MasterPanelManagerSettings.xml </version>
///<version value="4.0" date="18apr18" author="thorsten.huck@hsbcad.com"> panels associated to a floor and identical surface qualities will be nested with the reference side on the bottom side of the masterpanel, requires hsbGrainDirection 3.6 or higher </version>
///<version value="3.9" date="21feb18" author="thorsten.huck@hsbcad.com"> display of tagged panels supports opposite tool side of through tools </version>
///<version value="3.8" date="06feb18" author="thorsten.huck@hsbcad.com"> new display for tagged panels, see config file 'Tagged' </version>
///<version value="3.7" date="03may17" author="thorsten.huck@hsbcad.com"> introducing panel based override of the oversize format cut in sublabe2 <CncRoute;Offset></version>
///<version value="3.6" date="03may17" author="thorsten.huck@hsbcad.com"> supports max dimensions, transparent interferences and new entries in configuration </version>
///<version value="3.5" date="03apr17" author="thorsten.huck@hsbcad.com"> bugfix child alignment on nesting event </version>
///<version value="3.4" date="27feb17" author="thorsten.huck@hsbcad.com"> nesting honours child shadow profile instead of plEnvelope </version>
///<version value="3.3" date="24feb17" author="thorsten.huck@hsbcad.com"> duplicate creation of child panels avoided </version>
///<version value="3.2" date="24feb17" author="thorsten.huck@hsbcad.com"> master panel orientation always along positive XY-World </version>
///<version value="3.1" date="13feb17" author="thorsten.huck@hsbcad.com"> bugfix negative coordinate system on cross wise orientation, new option to disable nesting functionality </version>
///<version value="3.0" date="10aug16" author="thorsten.huck@hsbcad.com"> bugfix export settings, quality alignment corrected </version>
///<version value="2.9" date="10aug16" author="thorsten.huck@hsbcad.com"> supports custom defined call of any exporter via context command </version>
///<version value="2.8" date="10aug16" author="thorsten.huck@hsbcad.com"> childpanel alignment adjusted, take III </version>
///<version value="2.7" date="09aug16" author="thorsten.huck@hsbcad.com"> childpanel alignment adjusted </version>
///<version value="2.6" date="09aug16" author="thorsten.huck@hsbcad.com"> childpanel alignment adjusted </version>
///<version value="2.5" date="08aug16" author="thorsten.huck@hsbcad.com"> right aligned masterpanels defined with World coordinate system, requires 21.0.49 or higher </version>
///<version value="2.4" date="27july16" author="thorsten.huck@hsbcad.com"> supports presorting, requires 'hsbCLT-Presorter' in the search path </version>
///<version value="2.3" "26jul16" author="thorsten.huck@hsbCAD.de"> new settings for presorting of hard coded keys </version>
///<version value="2.2" "19jul16" author="thorsten.huck@hsbCAD.de"> bugfix read settings </version>
///<version value="2.1" "15jul16" author="thorsten.huck@hsbCAD.de"> 
/// - tagged panels (sublabel2 = HU) will not display oversize outline
/// - before calling the nester the default size of the master will be tested against the current size. 
///   If the master appears to be smaller it will be initially recreated with default size and then optimzed due to the auto size settings
/// - package color detection is no longer dependnet from property set, but is referring to the entity itself
/// - sublabel2 now can also be displayed as property at child panel
/// - automatic size supports standard dimensions via settings
///  </version>
///<version value="2.0" "11jul16" author="thorsten.huck@hsbCAD.de"> masterpanel offset corrected, automatic numbering added, oversize will be excluded for panels with sublabel2 = 'HU'  </version>
///<version value="1.9" "11jul16" author="thorsten.huck@hsbCAD.de"> reads and stores package color overrides from <hsbCompany\sips\Freight-PackageSettings.xml> </version>
///<version value="1.8" "20jun16" author="thorsten.huck@hsbCAD.de"> 
/// - writing of settings file enhanced
/// - auto size functionality added, supports a list of values as well as ceiling steps
/// - automatic masterpanel style import added: styles need to be in <hsbCompany\sips\MasterPanelStyle.dwg> </version>
///<version value="1.7" "16jun16" author="thorsten.huck@hsbCAD.de"> accepts any set of panel or related entities as source objects (child/masterpanels, any freight tsl) </version>
///<version value="1.6" "01jun16" author="thorsten.huck@hsbCAD.de"> new context commands and properties, settings file introduced, child pre-alignment included to nesting, collsion control added, oversize added </version>
///<version value="1.5" "14apr16" author="thorsten.huck@hsbCAD.de"> new context command to specify or remove the feeding direction of special CNC machines </version>
///<version value="1.4" "09nov15" author="thorsten.huck@hsbCAD.de"> nesting profile defined by child shadow to overcome plEnvelopeCNC issue </version>
///<version value="1.3" "08oct15" author="thorsten.huck@hsbCAD.de"> enhanced properties display, grain direction supported as property 'Grain Direction', collects main grain direction from child panels (requires 20.1.6 or higher), applicable to existing masterpanels or creates masterpanel on insert </version>
///<version value="1.2" "28sep15" author="thorsten.huck@hsbCAD.de"> invalid nester result will avoid multiple nester calls </version>
///<version value="1.1" "25sep15" author="thorsten.huck@hsbCAD.de"> silent nester call </version>
///<version value="1.0" date="02sep15" author="thorsten.huck@hsbCAD.de"> initial </version>


/// commands
// command to insert a mastepanel-manager 
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCLT-MasterpanelManager")) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Nesting|") (_TM "|Select Masterpanel-Manager|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "../|Set X-parallel feeding direction|") (_TM "|Select Masterpanel-Manager|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "../|Set Y-parallel feeding direction|") (_TM "|Select Masterpanel-Manager|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Show Relation|") (_TM "|Select Masterpanel-Manager|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Hide Relation|") (_TM "|Select Masterpanel-Manager|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Child Panel(s)|") (_TM "|Select Masterpanel-Manager|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Rotate Child|") (_TM "|Select Masterpanel-Manager|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Flip + Rotate Child|") (_TM "|Select Masterpanel-Manager|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Flip Child|") (_TM "|Select Masterpanel-Manager|"))) TSLCONTENT
//endregion

//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;

	String tDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
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
	

	String sAddOpeningToMasters[] = { T("|No|"), T("|Yes|")};
	
	String kMasterRowOffset = "MasterRowOffset", kMasterXName = "Masterpanel";
	String kQuantityChilds = "QuantityChilds", kWaste = "Waste",kBoxWaste = "BoundingWaste",kOutterContourWaste = "OutterContourWaste",
	kBoxWasteArea = "BoundingWasteArea", kOutterContourWasteArea = "OutterContourWasteArea", kAreaNet = "AreaNet",
	kAreaGros = "AreaGros", kVolume = "Volume";
	String kShapeLock = "ShapeLock", kOriginator = "Originator" , kIsLocked="Locked" ;
	String kDataLink = "DataLink";
	
	String tDisabled = T("<|Disabled|>");
	
	
	
//region Dialog Map
	Map mapDia;
	Map mapDiaConfig, mapDiaColumnDefinitions, mapDiaRowDefinitions;

//region Dialog config
	String kRowDefinitions = "MPROWDEFINITIONS";
	String kControlTypeKey = "ControlType";
	String kHorizontalAlignment = "HorizontalAlignment";
	String kLabelType = "Label";
	String kHeader = "Title";
	String kIntegerBox = "IntegerBox";
	String kTextBox = "TextBox";
	String kDoubleBox = "DoubleBox";
	String kComboBox = "ComboBox";
	String kCheckBox = "CheckBox";
	String kLeft = "Left", kRight = "Right", kCenter = "Center", kStretch = "Stretch";	
	//endregion
//endregion 




//endregion

//End Part #1//endregion 

//region Functions

	//region PLaneProfile Functions
	
//region Function StretchPlaneProfileInDir
	// stretches the segments of a planeprofile in the most aligned given direction, the X-Direction will be prioritized for 45° angels
	// stretchOpening: 0 = do not stretch opening, 1 = stretch, 2 = stretch only openings
	void StretchPlaneProfileInDir(PlaneProfile& pp, Vector3d vecDir, double dist, int stretchOpening)
	{ 
		int bDebugFunction;// = bDebug;
		
		CoordSys cs = pp.coordSys();	//cs.transformBy(pp.ptMid()-cs.ptOrg());cs.vis(4);
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();
		Vector3d vecZ = cs.vecZ();
		
		double dd = vecDir.dotProduct(vecX);
		int bPrioX = abs(vecDir.dotProduct(vecX)) >= abs(vecDir.dotProduct(vecY)) ? true : false;
		
		
		PLine rings[] = pp.allRings();
		int bIsOpenings[] = pp.ringIsOpening();
		
		Point3d pts[] = pp.getGripEdgeMidPoints();
		for (int r=0;r<rings.length();r++) 
		{ 
			PLine ring = rings[r]; 
			int bIsOpening = bIsOpenings[r];
			if (stretchOpening==0 && bIsOpening){ continue;}		//only voids
			else if (stretchOpening==2 && !bIsOpening){ continue;}	//only openings
			
			
		//region // Collect relevant directions
			Vector3d vecDirs[0];
			for (int p=0;p<pts.length();p++) 
			{ 
				Point3d& pt = pts[p];
				if (ring.isOn(pts[p]))
				{ 
					Point3d pt2 = ring.getPointAtDist(ring.getDistAtPoint(pt) + dEps);	
					Vector3d vecXSeg = pt2 - pt; vecXSeg.normalize();
					Vector3d vecYSeg = vecXSeg.crossProduct(-vecZ);
					if (pp.pointInProfile(pt+vecYSeg*dEps)!=_kPointOutsideProfile)	vecYSeg *= -1;	
					if (bIsOpening)vecYSeg *= -1;
					//vecYSeg.vis(pt, 3);

					double a = vecXSeg.angleTo(vecDir)-90;
					int bIs45 = abs(a) <= 45.01 && abs(a) > 44.99;
					
					if (bIs45 && !bPrioX){ continue;}
					
					if (!vecYSeg.isPerpendicularTo(vecDir) && abs(a)<= 45.01 && vecYSeg.dotProduct(vecDir)>0)
					{ 
						if (bDebugFunction)
						{ 
							vecYSeg.vis(pt, bPrioX?1:3);
							
							Display dp(1);
							dp.textHeight(U(30));					
							dp.draw("a:"+a + "°", pt, vecXSeg, vecYSeg, 0, 1,_kDevice);								
						}
						vecDirs.append(vecYSeg);
					}
				}
			}				
		//endregion 	

			
		//region Stretch in collected directions
			for (int i=0;i<vecDirs.length();i++) 
			{ 
				Point3d pts[] = pp.getGripEdgeMidPoints();
				for (int p=0;p<pts.length();p++) 
				{ 
					Point3d& pt = pts[p];
					if (ring.isOn(pts[p]))
					{
						Point3d pt2 = ring.getPointAtDist(ring.getDistAtPoint(pt) + dEps);
						Vector3d vecXSeg = pt2 - pt; vecXSeg.normalize();
						Vector3d vecYSeg = vecXSeg.crossProduct(-vecZ);
						if (pp.pointInProfile(pt + vecYSeg * dEps) != _kPointOutsideProfile)	vecYSeg *= -1;
						if (bIsOpening)vecYSeg *= -1;
						
						if (vecDirs[i].isCodirectionalTo(vecYSeg))
						{
							Vector3d vecStretch = (bIsOpening?-1:1) * vecYSeg * dist;
							if (bDebugFunction) PLine(pt, pt + vecStretch).vis(2);
							pp.moveGripEdgeMidPointAt(p ,vecStretch);
						}
					}
				}
			}				
		//endregion 	


		}//next r
	
		return;
	}//endregion

//endregion 



	
	//endregion 



//region Function GetGripByName
	// returns the grip index if found in array of grips
	// name: the name of the grip
	int GetGripByName(Grip grips[], String name)
	{ 
		int out = - 1;
		for (int i=0;i<grips.length();i++) 
		{ 
			if (grips[i].name()== name)
			{
				out = i;
				break;
			}	 
		}//next i
		return out;
	}//endregion

//region Function GrainArrow
	// returns the graindirection symbol
	PLine GrainArrow(double textHeight, Point3d ptLoc, Vector3d vecGrain)
	{ 
	// create an arrow pline
		Vector3d vecX = vecGrain, vecY=vecGrain.crossProduct(-_ZW);
		double dD = textHeight * (vecX.isParallelTo(_XW) ? 4 : 1.5);
		Vector3d vecA = vecX * .25 * dD+vecY * .1 * dD;
		Vector3d vecB = vecX * .5 * dD;
		
		PLine plArrow(ptLoc-vecA, ptLoc-vecB, ptLoc+vecB, ptLoc+vecA);	
		return plArrow;
	}//endregion

//region Function GetClosestLocation
	// returns
	Vector3d GetClosestLocation(PlaneProfile pp, PlaneProfile ppRange, double dGap, int bIsOpening)
	{ 
		Point3d ptMid = pp.ptMid();
		Point3d ptNext = ppRange.closestPointTo(ptMid);
		Vector3d vecMove= ptNext - ptMid;

		Vector3d vecDir = vecMove; vecDir.normalize();
		Vector3d vecPerp = vecDir.crossProduct(-_ZW);//vecPerp.vis(ptMid,2);
		
		Point3d pts[]=pp.intersectPoints(Plane(ptMid, vecPerp), true, false);
		pts = Line(_Pt0, vecDir).orderPoints(pts);
		
		if (pts.length()>1)
		{ 
			//pts[0].vis(6);			pts[1].vis(6);
			vecMove += .5*(pts.last() - pts.first());
		}
		vecMove += dGap * vecDir;

		return vecMove;
	}//endregion

//region Function TagCoversChild
	// returns true or false if a tag covers a childpanle completely
	// t: the tslInstance to 
	int TagCoversChild(PlaneProfile ppTag, PlaneProfile ppShape)
	{ 
		PlaneProfile ppx = ppShape;
		ppx.subtractProfile(ppTag);
		return ppx.area() < pow(dEps, 2);
	}//endregion

//region Function TagOverlapsChild
	// returns
	// t: the tslInstance to 
	int TagOverlapsChild(PlaneProfile ppTag, PlaneProfile ppShape)
	{ 
		PlaneProfile ppx = ppTag;
		ppx.intersectWith(ppShape);
		double a1 = ppTag.area();
		double a2 = ppx.area();
		return abs(a1-a2)>pow(U(1),2);	
	}//endregion

//region Function GetTextBox
	// returns the number of expected text rows and modifies the bounding box of a text display
	// ppBox: initialised as coordSys and location carrier
	int GetTextBox(Display dp, String text, double textHeight, String dimStyle, PlaneProfile& ppBox)
	{ 
		CoordSys cs = ppBox.coordSys();
		Point3d pt = cs.ptOrg();
		double dX = dp.textLengthForStyle(text, dimStyle, textHeight);
		double dY = dp.textHeightForStyle(text, dimStyle, textHeight);
		Vector3d vec = cs.vecX() * .5*dX + cs.vecY() * .5*dY;
		PLine pl;
		pl.createRectangle(LineSeg(pt-vec, pt+vec), cs.vecX(), cs.vecY());
		
		int numRow = (dY+.5*textHeight) / (textHeight*1.5);
		
		pl.offset(-.2 * textHeight, true);
		ppBox.joinRing(pl, _kAdd);		
		return numRow;
	}//endregion	
	
//region Function ProfileHasIntersection
	// returns true or false if the given planeprofiles have an intersection
	int ProfileHasIntersection(PlaneProfile pp1, PlaneProfile pp2)
	{ 
		PlaneProfile pp = pp1;
		return pp.intersectWith(pp2);
	}//endregion

//region Function IntersectsWithPlotViewport
	// TODO not working yet
	// returns amount of intersecting plotviewports
	int IntersectsWithPlotViewport(MasterPanel master)
	{ 
		int out;
		
		Entity ents[] = Group().collectEntities(true, PlotViewport(), _kModelSpace);
		
		PlaneProfile pp(CoordSys());
		pp.joinRing(master.plShape(), _kAdd);
		
//		EntPLine epl;
//		PLine plx;
//		plx.createRectangle(pp.extentInDir(_XW), _XW, _YW);
//		epl.dbCreate(plx);
//		epl.setColor(4);	
		
		for (int i=0;i<ents.length();i++) 
		{ 
			PlotViewport pv= (PlotViewport)ents[i]; 
			if (!pv.bIsValid()){ continue;}
			
			CoordSys cs = pv.coordSys();
			Vector3d vecX = cs.vecX();
			Vector3d vecY = cs.vecY();
			Point3d pt = cs.ptOrg();
	
			PLine plPV;
			plPV.createRectangle(LineSeg(pt, pt+vecX*pv.dX() + vecY*pv.dY()), vecX, vecY);
			PlaneProfile ppPV(CoordSys());
			ppPV.joinRing(plPV, _kAdd);

//			epl.dbCreate(plPV);
//			epl.setColor(i + 1);
//			plx=PLine(ppPV.ptMid(), pp.ptMid());
//			epl.dbCreate(plx);
//			epl.setColor(i + 1);

			if (ppPV.intersectWith(pp) && ppPV.area()>.5*pp.area())
				out++;

		}//next i
		
		//reportNotice("\n" + ents.length() + " in model " + out + pp.area());
		return out;
	}//endregion

//region Function HasActivePlotViewport
	// returns true or false if any of the specified plotviewports is active
	int HasActivePlotViewport(Map mapPlotViewports)
	{ 
		int bIsActive;
		for (int i=0;i<mapPlotViewports.length();i++) 
		{ 
			Map m = mapPlotViewports.getMap(i); 
			if (m.getInt("active"))
			{ 
				bIsActive = true;
				break;
			}
		}//next i
		return bIsActive;
	}//endregion

//region Function AddDiaColumn
	// returns
	// t: the tslInstance to 
	void AddDiaColumn(Map& mapDefinition, String controlType, String entry, String horizontalAlignment, double width, String toolTip)
	{ 
		Map m;
		m.setString("Title", entry);
		m.setString("ControlType", controlType);
		m.setString("HorizontalAlignment", horizontalAlignment);
		m.setString("ToolTip", toolTip);
		if (width>0)m.setDouble("Width", width);
		mapDefinition.appendMap(entry, m);
		
		return;
	}//End AddDiaColumn //endregion	

//region AutoSize Functions

	//region Function semicolonToString
	// converts an array of doubles to a semicolon separated string
	String toSemicolonString(double values[])
	{ 
		String out;
		for (int i=0;i<values.length();i++) 
			out += (out.length()>0?";":"")+values[i]; 
		return out;
	}//End toSemicolonString //endregion

	//region Function semicolonToString2
	// converts 3 arrays of doubles to a semicolon separated string
	String semicolonToString2(double minRanges[], double maxRanges[], double rangeValues[])
	{ 
		String out;
		for (int i=0;i<rangeValues.length();i++) 
		{ 
			String value = minRanges[i] + "-" + maxRanges[i] + "="+rangeValues[i];
			out += (out.length()>0?";":"")+value; 
		}		
		return out;
	}//End semicolonToString2 //endregion


	//region Function semicolonToDoubles
	// converts a semicolon separated string into an array of doubles
	// t: the tslInstance to 
	double[] semicolonToDoubles(String val) 
	{ 
		double out[0];
		String tokens[] = val.tokenize(";");
		for (int i=0;i<tokens.length();i++) 
		{ 
			String token= tokens[i].trimLeft().trimRight();
			double d = token.atof();
			if (d>0 && out.find(d)<0)
				out.append(d);		 
		}//next i
		out = out.sorted();
		return out;
	}//End semicolonToDoubles //endregion	

	//region Function semicolonToDoubles
	// converts a semicolon separated string into an array of doubles
	Map semicolonToDoubles2(String val , double& minRanges[], double& maxRanges[], double& rangeValues[]) 
	{ 
		String tokens[] = val.tokenize(";");
		for (int i=0;i<tokens.length();i++) 
		{ 
			String token= tokens[i].trimLeft().trimRight();
			String tokensA[] = token.tokenize("=");
			String tokensB[0];
			if(tokensA.length()>1)
				tokensB= tokensA[0].tokenize("-");
			
			if (tokensB.length()==2)
			{ 
				double min = tokensB[0].trimLeft().trimRight().atof();
				double max = tokensB[1].trimLeft().trimRight().atof();
				double val = tokensA[1].trimLeft().trimRight().atof();
				
				if (min<max && val>min)
				{ 
					minRanges.append(min);
					maxRanges.append(max);
					rangeValues.append(val);
				}
			}		 
		}//next i
		
		Map out;
		for (int i=0;i<minRanges.length();i++) 
		{ 
			Map m;
			m.setDouble("Min", minRanges[i]);
			m.setDouble("Max", maxRanges[i]);
			m.setDouble("Value", rangeValues[i]);
			out.appendMap("Range", m);								 
		}		
		
		
		return out;
	}//End semicolonToDoubles //endregion	




//	//region Function setValueMap
//	// writes values to a submap named Value[]
//	Map setValueMap(double values[])
//	{ 
//		Map out, m;
//		values = values.sorted();
//		for (int i=0;i<values.length();i++) 
//			m.appendDouble(values[i]);
//		if (m.length()>0)
//			out.appendMap("Value[]", m);
//		return out;
//	}//End setValueMap //endregion

	//region Function getDoublesValueMap
	// reads values of a submap named Value[]
	double[] getDoublesValueMap(Map mapValues)
	{ 
		double out[0];
		for(int i=0;i<mapValues.length();i++)
		{
			double d = mapValues.getDouble(i);
			if (d>0 && out.find(d)<0)
				out.append(d);	
		}// next i
		out = out.sorted();
		return out;
	}//End setValueMap //endregion

	//region Function setAutoSizeMap
	// returns
	// t: the tslInstance to 
	void setAutoSizeMap(Map& mapAutoSize, String key, double autoSizeMinimum, double ceiling, double values[], Map mapRanges)
	{ 
		Map map, map2;
		if(autoSizeMinimum>0)
			map.setDouble("Minimum", autoSizeMinimum);
		
		values = values.sorted();
		for (int i=0;i<values.length();i++) 
			map2.appendDouble("Value",values[i]);
			
		if (map2.length()>0)
			map.appendMap("Value[]", map2);
		else if (ceiling>0)
			map.setDouble("Ceiling", ceiling);

		if (mapRanges.length()>0)
			map.appendMap("Range[]", mapRanges);

		if (map.length()>0)
			mapAutoSize.setMap(key, map);

		return;
	}//End setAutoSizeMap //endregion

	//region Function getAutoScaleRange
	// returns true if ranges have been collected, the arguments will return the collected values
	int getAutoScaleRange(Map map, double& dMinRanges[], double& dMaxRanges[], double& dRangeValues[])
	{ 
		dMinRanges.setLength(0);
		dMaxRanges.setLength(0);
		dRangeValues.setLength(0);
		
		for (int i=0;i<map.length();i++) 
		{ 
			Map m = map.getMap(i);
			double min = m.getDouble("Min");
			double max = m.getDouble("Max");
			double val = m.getDouble("Value");
			
			if (min>=0 && max>min && val>0)
			{ 
				dMinRanges.append(min);
				dMaxRanges.append(max);
				dRangeValues.append(val);	
			} 
		}//next i
		
	// order by min range
		for (int i=0;i<dMinRanges.length();i++) 
			for (int j=0;j<dMinRanges.length()-1;j++) 
				if (dMinRanges[j]>dMinRanges[j+1])
				{
					dMinRanges.swap(j, j + 1);
					dMaxRanges.swap(j, j + 1);
					dRangeValues.swap(j, j + 1);
				}

		return dMinRanges.length() > 0;
		
	}//End getAutoScaleRange //endregion
			
	//AutoSize Functions //endregion 

//region Function getValueByRange
	// returns true if range was found and the mapped value to modify dimension if within min...max
	// t: the tslInstance to 
	int getValueByRange(double& size, double minRanges[], double maxRanges[], double values[])
	{ 
		int out;
		if (minRanges.length()!=maxRanges.length() || values.length()!=maxRanges.length())
		{ 
			reportMessage(T("|Unexpected error| getValueByRange"));
			return size;
		}
		for (int i=0;i<minRanges.length();i++) 
		{ 
			if (size>=minRanges[i] && size<=maxRanges[i] && size<=values[i])
			{
				size=values[i];
				out = true;
				break;
			}
		}//next i
		return out;
	}//End getValueByRange //endregion	

//region Function stretchProfile
	// returns the success of stretching operation
	// bevelMode: -1= no beveled edges, 0 = accept any beveled edge, 1 = accept beveled edges upto 45°
	// vecDir the stretch direction
	// bStretchBoth: flag if opposite direction to be stretched as well
	// offset: the offset to be stretched
	int stretchProfile(PlaneProfile& pp, Vector3d vecDir, int bStretchBoth, int bevelMode, double offset)
	{ 
		int out;	
		PLine rings[] = pp.allRings(true, false);
		PlaneProfile ppOut(pp.coordSys());		
		for (int r=0;r<rings.length();r++) 
		{ 
			PLine ring = rings[r];
			PlaneProfile ppx(pp.coordSys());
			ppx.joinRing(ring, _kAdd);
			
			Point3d pts[] = ppx.getGripEdgeMidPoints();
	
			for (int i=0;i<pts.length();i++) 
			{ 
				Point3d pt = pts[i];
				Vector3d vecXS = ring.getTangentAtPoint(pt);
				Vector3d vecYS = vecXS.crossProduct(-_ZW);
				
				if (ppx.pointInProfile(pt + vecYS * dEps) == _kPointInProfile)
				{
					vecXS *= -1;
					vecYS *= -1;
				}
				
				double angle = vecXS.angleTo(vecDir);
				int bIsParallel = vecYS.isParallelTo(vecDir);
				int bIsPerpendicular = vecYS.isPerpendicularTo(vecDir);
				if (bIsPerpendicular)continue;
				int bInDir = vecDir.dotProduct(vecYS) > 0;				
				if ( ! bStretchBoth && !bInDir)
				{
					vecXS.vis(pt, 1);
					continue;
				}
				else if (!bIsParallel && bevelMode==-1)
				{ 	
					continue;
				}
				else if (bIsParallel || (abs(angle)>=44.999 && bevelMode==1) || bevelMode==0)
				{
					vecYS.vis(pt, i);
					ppx.moveGripEdgeMidPointAt(i, vecYS * offset);
				}
			}//next i
			
		// merge muliple rings	
			if (ppx.area()>pow(dEps,2))
			{
				ppx.extentInDir(vecDir).vis(6);
				ppOut.unionWith(ppx);
				
				//Display dp(2); dp.draw(ppx, _kDrawFilled, 80);
				
			}
		}//next r
		
		if (ppOut.area()>pow(dEps,2))
		{
			pp = ppOut;
			out = true;
		}

		return out;
	}//End stretchProfile //endregion

//region Function getLine
	// returns
	// t: the tslInstance to 
	String getFirstLine(String& text)
	{ 
		String out=text;
		int leftP= text.find("\\P",0, false);
		int leftN= text.find("\n",0, false);
		int left = -1;
		if (leftN>-1 && leftP>-1)
			left = leftP<leftN ? leftP : leftN;
		else if (leftN>-1 || leftP>-1)
			left = leftP<leftN ? leftN : leftP;	
		if (left>-1)
		{ 
			out = text.left(left); // HSB-23333, previous //text.left(left-(left==leftN?1:0));
			String s2 = text.right(text.length()-left-(left==leftN?1:2));
			text = s2;
		}
		else
		{ 
			text = "";
		}
		return out;
	}//End getLine //endregion


//region FindFile
// find file including subfolders
// This mapIO call will try to find a file in the given path including all subfolders
// NOTE: this snippet should be placed at the beginning of the script top avoid other code to be executed
// define constant map keys used in mapIO and main code	
	String kPath = "Path";
	String kFileName = "FileName";
	String kExtension = "Extension";
	String kFullFilePath = "FullFilePath";
	
// run mapIO	
	if (_bOnMapIO)
	{ 
		if (bDebug)reportMessage("mapIO called");
		if (!_Map.hasString(kPath) || !_Map.hasString(kFileName)) return;
		String sPath = _Map.getString(kPath);
		String sFileName = _Map.getString(kFileName);
		String sExtension = _Map.getString(kExtension);
		_Map = Map();
		if (sPath.length() < 1)	{ reportMessage("\n" + scriptName() + T(" |invalid path specified.|")); return;};
		if (sFileName.length() < 1)	{ reportMessage("\n" + scriptName() + T(" |invalid file name specified.|")); return;};
		if (sExtension.length() < 1) sExtension="*";
		
		if(bDebug)reportMessage("\n"+ scriptName() + " mapIO searching for " + sFileName);
		String sFile = findFile(sPath + sFileName + sExtension);
		
		if (sFile.length()<1)
		{ 
			String sFolders[] = getFoldersInFolder(sPath);
			for (int f=0;f<sFolders.length();f++) 
			{ 
				String sFileNames[]=getFilesInFolder(sPath+sFolders[f]+"\\", "*"+sExtension);
				if (sFileNames.find(sFileName)>-1)
				{ 
					sFile = findFile(sPath + sFolders[f]+"\\"+sFileName+sExtension);
					if(bDebug)reportMessage("\n"+ scriptName() + " found " + sFile);
					break;
				}
				else
				{ 
					Map mapIO;
					mapIO.setString(kPath,sPath + sFolders[f]+"\\");
					mapIO.setString(kFileName,sFileName);
					mapIO.setString(kExtension,sExtension);
					int bOk = TslInst().callMapIO(scriptName(), mapIO);
					if (bOk)
						sFile = mapIO.getString(kFullFilePath);	
					else
						reportMessage(TN("|IO call failed.|"));
					
					if (findFile(sFile).length()>0)
						break;
				}
			}//next f			
		}
		if (sFile.length()>0)
		{ 
			_Map.setString(kFullFilePath, sFile);
		}
		return;
	}		
//endregion End FindFile


//endregion 


//region Part #2

//region settings PART 1/2

// Defaults variables
	double dMaxLength = U(20000);// default length of master
	double dMaxWidth = U(3200);// default width of master
	String sLineType = "CONTINUOUS"; if (_LineTypes.length()>0)sLineType=_LineTypes[0];// default linetype of offseted outline of childs
	double dLineTypeScaleFactor= 1;	// default scale factor of linetype
	
	double dMasterOversizeX = U(1), dMasterOversizeY=dMasterOversizeX;	// default offset of master outline
	int bAddOpeningToMaster;
	int nStartNumber = 1;
	int bAlignRight = true;// default alignment of nesting result
	int bKeepFloorReferenceBottom=true; // panels with floor association and same quality will flip reference side to bottom
	int nColor = 252;// default color of display
	double dRowOffset = U(1000);// default row offset of new master	
	String sDimStyle = _DimStyles[0];

// Childpanel // HSB-11716
	int nColorChildText = nColor;
	int nTransparencyChild;
	int nColorChildOutline = nColor;
	String sDimStyleChild = sDimStyle;

// interference
	int nColorInterfere=242;
	String sLineTypeInterfere=_LineTypes.length()>0?_LineTypes[0]:"CONTINUOUS";
	double dLineTypeScaleInterfere=U(1);
	int nTransparencyInterfere;

// taggedPanelTool: properties to display tagged panel tools
	int nColorTaggedRef=1;
	int nColorTaggedOpp=4;
	String sLineTypeTagged=_LineTypes.length()>0?_LineTypes[0]:"CONTINUOUS";
	double dLineTypeScaleTagged=U(1);
	int nTransparencyTagged=80;

//presorting
	Map mapSortings;

// feed directions HSB-8788
	Map mapFeedDirections;
	int nFeedColor = 1, bAddFeedDirection;
	String sFeedBlockName, sFeedText;

// default autosize behaviour
	double dCeilingX; // describes the ceiling value of the masterpanel extents in this direction
	double dCeilingY;
	double dAutoSizeMinimumX, dAutoSizeMinimumY; // values > 0 define the minimal length of the masterpanel
	double dGridXValues[0]; // describes fixed values of the masterpanel extents in this direction
	double dGridYValues[0]; // Value[]\\Value
	Map mapGrid, mapRangeX, mapRangeY;// mapRange defines submaps containing min/max and target value of requested dimension

// header variables
	String sHeaderBlockName;
	double dHeaderXOffset, dHeaderYOffset;
	int nHeaderXAlignment=1, nHeaderYAlignment=-1;//-1,0,1
	int nColorHeader;
	double dTextHeightHeader;
	Map mapColorsOversize;
	
// child header
	Map mapChildHeaders; // contains a list of maps which specify child (sip) properties to be displayed as header

// Nesting
	int bEdgeAlignment; // 0 = no edge alignment, 1 = child panels will be aligned to the closest edge along X-Axis if transformation does not intersect with other panels

// Master
	String sMasterStyleDwgName = _kPathHsbCompany + "\\Sips\\MasterPanelStyle.dwg";
	String sLengthWiseKey, sCrossWiseKey,sMasterStyleDelimiter;


// draw grain direction as block
	String sAssociationBlockNames[] ={"hsbGrainDirectionWall", "hsbGrainDirectionFloor"};

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sFileName ="MasterPanelManagerSettings";
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

//Freight-PackageSettings
	String sFileName2 ="Freight-PackageSettings";
	Map mapSetting2;

// find settings file
	String sFullPath2 = sPath+"\\"+sFolder+"\\"+sFileName2+".xml";
	String sFile2=findFile(sFullPath2); 

// read a potential mapObject
	MapObject mo2(sDictionary ,sFileName2);
	if (mo2.bIsValid())
	{
		mapSetting2=mo2.map();
		setDependencyOnDictObject(mo2);
	}
	// create a mapObject to make the settings persistent	
	else if ((_bOnInsert || _bOnDebug) && !mo2.bIsValid() && sFile2.length()>0)
	{
		mapSetting2.readFromXmlFile(sFile2);
		mo2.dbCreate(mapSetting2);
	}		
//End Settings//endregion


// read settings

// PLot Viewport
	Map mapPlotViewports = mapSetting.getMap("PlotViewport[]");
	int bAutoCreationPlotViewport = HasActivePlotViewport(mapPlotViewports);

	int bHasAutoSize;
	{
	// read sorting rules	
		mapSortings = mapSetting.getMap("Sorting[]");

		String k;
		Map g,m;
		
		String sKey;
	// double
		g = mapSetting;
		k="Color";					if (g.hasInt(k))	nColor = g.getInt(k);
		k="Linetype";				if (g.hasString(k))	sLineType = g.getString(k);		
		k="Length";					if (g.hasDouble(k))	dMaxLength = g.getDouble(k);
		k="Width";					if (g.hasDouble(k))	dMaxWidth = g.getDouble(k);
		k="MasterOversize";			if (g.hasDouble(k))	dMasterOversizeX = g.getDouble(k);
		k="MasterOversizeY";		
		if (g.hasDouble(k))	
			dMasterOversizeY = g.getDouble(k);
		else
			dMasterOversizeY = dMasterOversizeX;
			
		k="AddOpeningToMaster";		if (g.hasInt(k))	bAddOpeningToMaster = g.getInt(k);
		k="LineTypeScaleFactor";	if (g.hasDouble(k))	dLineTypeScaleFactor = g.getDouble(k);
		k="AlignRight";				if (g.hasInt(k))	bAlignRight = g.getInt(k);
		k="DimStyle";				if (g.hasString(k))	sDimStyle = g.getString(k);
		k="KeepFloorReferenceBottom";	if (g.hasInt(k))	bKeepFloorReferenceBottom = g.getInt(k);
		k="MasterStartNumber";		if (g.hasInt(k))	nStartNumber = g.getInt(k);
		k=kMasterRowOffset;			if (g.hasDouble(k))	dRowOffset = g.getDouble(k);


		k="AutoCreationPlotViewport";if (g.hasInt(k))	bAutoCreationPlotViewport = g.getInt(k);




	// AutoSize
		k="AutoSize";				if (g.hasMap(k))	mapGrid = g.getMap(k);	
		g = mapSetting.getMap("AutoSize");
		bHasAutoSize = g.length() > 0;
		k="X\\Ceiling";				if (g.hasDouble(k))	dCeilingX = g.getDouble(k)>0?g.getDouble(k):0;
		k="Y\\Ceiling";				if (g.hasDouble(k))	dCeilingY = g.getDouble(k)>0?g.getDouble(k):0;
		k="X\\Minimum";				if (g.hasDouble(k))	dAutoSizeMinimumX = g.getDouble(k)>0?g.getDouble(k):0;
		k="Y\\Minimum";				if (g.hasDouble(k))	dAutoSizeMinimumY = g.getDouble(k)>0?g.getDouble(k):0;
		k="X\\Range[]";				if (g.hasMap(k))	mapRangeX = g.getMap(k);
		k="Y\\Range[]";				if (g.hasMap(k))	mapRangeY = g.getMap(k);
		
	// interference
		g = mapSetting.getMap("LayerInterference");
		k="Color";				if (g.hasInt(k))	nColorInterfere = g.getInt(k);
		k="Linetype";			if (g.hasString(k))	sLineTypeInterfere = g.getString(k);		
		k="LinetypeScale";		if (g.hasDouble(k))	dLineTypeScaleInterfere = g.getDouble(k);	
		k="Transparency";		if (g.hasInt(k))	nTransparencyInterfere = g.getInt(k);		

	// tagged panel
		g = mapSetting.getMap("Tagged");
		k="Color";				if (g.hasInt(k))	nColorTaggedRef = g.getInt(k);
		k="ColorOpp";			if (g.hasInt(k))	nColorTaggedOpp = g.getInt(k);
		k="Linetype";			if (g.hasString(k))	sLineTypeTagged = g.getString(k);		
		k="LinetypeScale";		if (g.hasDouble(k))	dLineTypeScaleTagged = g.getDouble(k);	
		k="Transparency";		if (g.hasInt(k))	nTransparencyTagged = g.getInt(k);	

	// header
		g = mapSetting.getMap("Header");
		k="Blockname";			if (g.hasString(k))	sHeaderBlockName = g.getString(k);
		k="X\\Offset";			if (g.hasDouble(k))	dHeaderXOffset = g.getDouble(k);
		k="Y\\Offset";			if (g.hasDouble(k))	dHeaderYOffset = g.getDouble(k);
//		k="X\\Alignment";		if (g.hasInt(k))	nHeaderXAlignment = g.getInt(k);
//		k="Y\\Alignment";		if (g.hasInt(k))	nHeaderYAlignment = g.getInt(k);
		k="Color";				if (g.hasInt(k))	nColorHeader = g.getInt(k); else nColorHeader = nColor;
		k = "textHeight";		if (g.hasDouble(k))	dTextHeightHeader = g.getDouble(k);
	
	// feeding direction
		g = mapSetting.getMap("FeedingDirection[]");
		bAddFeedDirection = g.length() > 0;
		k="Blockname";			if (g.hasString(k))	sFeedBlockName = g.getString(k);
		k="Text";				if (g.hasString(k))	sFeedText = g.getString(k);
		k="Color";				if (g.hasInt(k))	nFeedColor= g.getInt(k);
		mapFeedDirections = g;
	
	// child header
		g = mapSetting;
		k="ChildHeader[]";		if (g.hasMap(k))	mapChildHeaders = g.getMap(k);


	// child tag display
		g = mapSetting.getMap("ChildDisplay");
		k="DimStyle";			if (g.hasString(k))	sDimStyleChild = g.getString(k);
		k="ColorText";			if (g.hasInt(k))	nColorChildText= g.getInt(k);
		k="Transparency";		if (g.hasInt(k))	nTransparencyChild= g.getInt(k);
		
		k="Linetype";				if (g.hasString(k))	sLineType = g.getString(k);
		k="LineTypeScaleFactor";	if (g.hasDouble(k))	dLineTypeScaleFactor = g.getDouble(k);
		k="Color";					if (g.hasInt(k))	nColorChildOutline= g.getInt(k);

	// Masterpanel Style
		g = mapSetting.getMap("Masterpanel Style");
		k="StyleDwg";			if (g.hasString(k))	sMasterStyleDwgName = g.getString(k);
		k="LengthWiseKey";		if (g.hasString(k))	sLengthWiseKey = g.getString(k);
		k="CrossWiseKey";		if (g.hasString(k))	sCrossWiseKey = g.getString(k);
		k="Delimiter";			if (g.hasString(k))	sMasterStyleDelimiter = g.getString(k);


	//nesting
		g = mapSetting.getMap("Nesting");
		k="EdgeAlignment";		if (g.hasInt(k))	bEdgeAlignment = g.getInt(k);
			
	// oversize colors
		mapColorsOversize = mapSetting.getMap("Header\\OversizeColor[]");
		//bExportDefault = false;
	}
	// publish oversize
	_Map.setDouble("MasterOversizeX", dMasterOversizeX);
	_Map.setDouble("MasterOversizeY", dMasterOversizeY);

	double dMinRangesX[0], dMaxRangesX[0], dRangeValuesX[0], dMinRangesY[0], dMaxRangesY[0], dRangeValuesY[0];
	int bHasAutoRangeX = getAutoScaleRange(mapRangeX, dMinRangesX, dMaxRangesX, dRangeValuesX);
	int bHasAutoRangeY = getAutoScaleRange(mapRangeY, dMinRangesY, dMaxRangesY, dRangeValuesY);
	
	dGridXValues = getDoublesValueMap(mapGrid.getMap("X\\Value[]"));
	dGridYValues = getDoublesValueMap(mapGrid.getMap("Y\\Value[]"));


//End settings PART 1/2//endregion 

//region DialogMode
	int nDialogMode = _Map.getInt("DialogMode");
	if (nDialogMode>0)
	{ 
		if (nDialogMode == 1) // specify index when triggered to get different dialogs
		{
			setOPMKey("Settings");	
			
			
			Map mapBlocks = _Map.getMap("BlockName[]");
			
			String names[0];
			for (int i=0;i<mapBlocks.length();i++) 
			{ 
				String entry = mapBlocks.getString(i);
				if (entry.length()>0 && names.findNoCase(entry,-1)<0)
					names.append(entry);
			}//next i
			names = names.sorted();
			if (names.findNoCase(tDisabled,-1)<0)
				names.insertAt(0, tDisabled);
			

			
		category = T("|Geometry|");
			String sLengthName=T("|Length|");	
			PropDouble dLength(0, U(16000), sLengthName);	
			dLength.setDescription(T("|Defines the Length|"));
			dLength.setCategory(category);
			
			String sWidthName=T("|Width|");	
			PropDouble dWidth(1, U(3000), sWidthName);	
			dWidth.setDescription(T("|Defines the Width|"));
			dWidth.setCategory(category);
			
			String sOversizeName=T("|Oversize| X");	
			PropDouble dOversize(2, U(0), sOversizeName);	
			dOversize.setDescription(T("|Defines the oversize of he masterpanel in X-direction|"));
			dOversize.setCategory(category);

			String sOversizeYName=T("|Oversize| Y");	
			PropDouble dOversizeY(3, U(0), sOversizeYName);	
			dOversizeY.setDescription(T("|Defines the oversize of the masterpanel in Y-direction|"));
			dOversizeY.setCategory(category);

			String sAddOpeningToMasterName=T("|Add Openings to Master|");	
			PropString sAddOpeningToMaster(0, sAddOpeningToMasters, sAddOpeningToMasterName);	
			sAddOpeningToMaster.setDescription(T("|Specifies if openings will be added to the masterpanel contour|"));
			sAddOpeningToMaster.setCategory(category);

		category = T("|Alignment|");
			String sAlignments[] = { T("|Left|"), T("|Right|")};
			String spTextHeightName=T("|Horizontal Alignment|");	
			PropString sAlignment(1, sAlignments, spTextHeightName,0);	
			sAlignment.setDescription(T("|Defines if masterpanel reference will be on left or right side|"));
			sAlignment.setCategory(category);			
			
			String sKeepFloorReferenceBottomName=T("|Keep floor panels reference side|");	
			PropString sKeepFloorReferenceBottom(2, sNoYes, sKeepFloorReferenceBottomName,1);	
			sKeepFloorReferenceBottom.setDescription(T("|Specifies whether panels parallel to world XY can be flipped if surface quality rules do not prevent it.|"));
			sKeepFloorReferenceBottom.setCategory(category);

			String sRowOffsetName=T("|Row Offset|");	
			PropDouble dRowOffset(4, dRowOffset, sRowOffsetName);	
			dRowOffset.setDescription(T("|Defines the offset to the next masterpanel|"));
			dRowOffset.setCategory(category);

		category = T("|Auto Size| X");
			String sDescMinSize = T("|A value greater than zero indicates the minimum size of a masterpanel that supersedes any other specified values or nesting outcomes.|");
			String sDescGridSize = T("|Sets the limit for the dimension to which the masterpanel will be extended.|")+ 
				T(" |Input multiple values by separating them with a semicolon ';'|") + 
				T(" |Values can be given as simple list or by pattern <min>-<max>=<value>|");
			String sDescCeiling = T("|Ceiling rounds the size up to a given multiple.|")+ 
				T(" |The multiple to use for rounding is provided as the significance argument.|")+
				T(" |The ceiling will be ignored if values have been specified.|");
			String sCeilingXName=T("|Ceiling Value| X");				
			PropDouble dCeilingX(11, U(0), sCeilingXName);	
			dCeilingX.setDescription(sDescCeiling);
			dCeilingX.setCategory(category);

			String sMinSizeXName=T("|Min. Size| X");	
			PropDouble dMinSizeX(9, U(0), sMinSizeXName);
			dMinSizeX.setDescription(sDescMinSize);
			dMinSizeX.setCategory(category);

			String sAutoSizeGridXName=T("|Values| X");	
			PropString sAutoSizeGridX(7, "", sAutoSizeGridXName);	
			sAutoSizeGridX.setDescription(sDescGridSize);
			sAutoSizeGridX.setCategory(category);
		
		category = T("|Auto Size| Y");
			String sCeilingYName=T("|Ceiling Value| Y");
			PropDouble dCeilingY(12, U(0), sCeilingYName);	
			dCeilingY.setDescription(sDescCeiling);
			dCeilingY.setCategory(category);

			String sMinSizeYName=T("|Min. Size| Y");	
			PropDouble dMinSizeY(10, U(0), sMinSizeYName);
			dMinSizeY.setDescription(sDescMinSize);
			dMinSizeY.setCategory(category);			

			String sAutoSizeGridYName=T("|Values| Y");	
			PropString sAutoSizeGridY(8, "", sAutoSizeGridYName);	
			sAutoSizeGridY.setDescription(sDescGridSize);
			sAutoSizeGridY.setCategory(category);

		category = T("|Output|");
			String sStartNumberName=T("|Start Number|");	
			PropInt nStartNumber(0, 1, sStartNumberName);	
			nStartNumber.setDescription(T("|Defines the start number of the masterpanel number assignment|"));
			nStartNumber.setCategory(category);
			
			String sAutoPlotViewportName=T("|Create Plot Viewports|");	
			PropString sAutoPlotViewport(9, sNoYes, sAutoPlotViewportName);	
			sAutoPlotViewport.setDescription(T("|If plotviewports have been configured you can create teh plot viewports during creation or upon context request|"));
			sAutoPlotViewport.setCategory(category);


		category = T("|Display|");		
			String sDimStyleName=T("|DimStyle|");	
			PropString sDimStyle(3, _DimStyles.sorted(), sDimStyleName,0);	
			sDimStyle.setDescription(T("|Defines the dimension style|"));
			sDimStyle.setCategory(category);

			String sColorName=T("|Color|");	
			PropInt nColor(1, 40, sColorName);	
			nColor.setDescription(T("|Defines the Color|"));
			nColor.setCategory(category);			

		
		category = T("|Display Childpanel|");
			String sDimStyleChildName=T("|DimStyle|");	
			PropString sDimStyleChild(4, _DimStyles.sorted(), sDimStyleChildName,0);	
			sDimStyleChild.setDescription(T("|Defines the dimension style|"));
			sDimStyleChild.setCategory(category);		
		
			String sColorTextName=T("|Colour Text|");	
			PropInt nColorText(2, 40, sColorTextName);	
			nColorText.setDescription(T("|Defines the color of the tag|"));
			nColorText.setCategory(category);			
			
			String sTransparencyChildName=T("|Transparency|");	
			PropInt nTransparencyChild(5, 50, sTransparencyChildName);	
			nTransparencyChild.setDescription(T("|Defines the transparency of the childpanel text|"));
			nTransparencyChild.setCategory(category);

		category = T("|Childpanel Oversize|");
			String sLineTypeName=T("|LineType|");	
			PropString sLineType(5, _LineTypes.sorted(), sLineTypeName,0);	
			sLineType.setDescription(T("|Defines the Linetype|"));
			sLineType.setCategory(category);

			String sLineTypeScaleFactorName=T("|Linetype Scale Factor|");	
			PropDouble dLineTypeScaleFactor(5, 1, sLineTypeScaleFactorName,_kNoUnit);	
			dLineTypeScaleFactor.setDescription(T("|Linetype Scale Factor|"));
			dLineTypeScaleFactor.setCategory(category);
			
			String sColorChildName=T("|Color|");	
			PropInt nColorChild(3, 40, sColorChildName);	
			nColorChild.setDescription(T("|Defines the color of the childpanel oversize|"));
			nColorChild.setCategory(category);


		category = T("|Display|");
 			String sBlockNameName=T("|Block Name|");	
			PropString sBlockName(6, names, sBlockNameName,0);	
			sBlockName.setDescription(T("|Defines the name of a potential block to be displayed as tag.|") + T("|The block must contain attributes named as if it would be a format argument, i.e. @(ProjectNumber)|"));
			sBlockName.setCategory(category);
			if (names.findNoCase(sBlockName,-1)<0)
				sBlockName.set(tDisabled);

			String sXOffsetName=T("|X-Offset|");	
			PropDouble dXOffset(6, U(0), sXOffsetName);	
			dXOffset.setDescription(T("|Defines the offset in X-direction based on the lower left corner of the masterpanel|") + T(", |0 = default location below master|"));
			dXOffset.setCategory(category);
			
			String sYOffsetName=T("|Y-Offset|");	
			PropDouble dYOffset(7, U(0), sYOffsetName);	
			dYOffset.setDescription(T("|Defines the offset in Y-direction based on the lower left corner of the masterpanel|") + T(", |0 = default location below master|"));
			dYOffset.setCategory(category);

			String sTextHeightHeaderName=T("|Text Height Line 1|");	
			PropDouble dTextHeightHeader(8, U(0), sTextHeightHeaderName);	
			dTextHeightHeader.setDescription(T("|Defines the height of the first line of the tag|"));;
			dTextHeightHeader.setCategory(category);

			String sColorHeaderName=T("|Colour Line 1|");	
			PropInt nColorHeader(4, 40, sColorHeaderName);	
			nColorHeader.setDescription(T("|Defines the color of the first line of the tag|"));
			nColorHeader.setCategory(category);

		category = T("|Masterpanel Style|");
			String sStyleDwgName=T("|Style Drawing|");	
			PropString sStyleDwg(10, "", sStyleDwgName);	
			sStyleDwg.setDescription(T("|Specifies the full path of a dwg which contains the masterpanel styles for the automatic style import.|") + TN("|Use the context command to select from list.|"));
			sStyleDwg.setCategory(category);
		
			String sLengthKeyName=T("|Lengthwise Orientation|");
			String sCrossKeyName=T("|Crosswise Orientation|");
			String sDelimiterName=T("|Delimiter|");
			String sDescInfo = TN("|If delimiter and keys are specified the style name of the masterpanel will be composed in dependency of its grain direction.|");
			PropString sLengthKey(11, "", sLengthKeyName);	
			sLengthKey.setDescription(T("|Defines the key to distinguish the style name of a lengthwise oriented masterpanel|") + T(" |A common abbreviaton is 'L'|")+sDescInfo);
			sLengthKey.setCategory(category);
							
			PropString sCrossKey(12, "", sCrossKeyName);	
			sCrossKey.setDescription(T("|Defines the key to distinguish the style name of a crosswise oriented masterpanel|") + T(" |A common abbreviaton is 'C'|")+sDescInfo);
			sCrossKey.setCategory(category);			
	
			PropString sDelimiter(13, "", sDelimiterName);	
			sDelimiter.setDescription(T("|Defines the delimeter to separate the thickness and the component data within the style name|") + T(" |A common delimiter is '-'|")+sDescInfo);
			sDelimiter.setCategory(category);		


}		
		return;
	}
//End DialogMode//endregion

//region Properties
	double dGrainSize=U(400);
	String sScriptnamePresorter = "hsbCLT-Presorter";
	

// categories
	String sCategoryMaster = T("|Masterpanel|");	
	String sCategoryChild = T("|Childpanel|");	
	String sCategoryNester = T("|Nester|");	
	String sCategoryDisplay = T("|Display|");	
	String sAttributeDescription =T("|Defines the format of the composed value.|")+
		TN("|Besides the properties of the entity a graphical display of the grain direction can be specified by using the special format @(GrainDirection)|");
//		TN("|Samples|")+
//		TN("   @(Label)@(SubLabel)")+
//		TN("   @(Label:L2) |the first two characters of Label|")+
//		TN("   @(Label:T1; |the second part of Label if value is separated by blanks, i.e. 'EG AW 2' will return AW'|)")+
//		TN("   @(Width:RL1) |the rounded value of width with one decimal.|")+
//		TN("R |Right: Takes the specified number of characters from the right of the string.|")+
//		TN("L |Left: Takes the specified number of characters from the left of the string.|")+
//		TN("S |SubString: Given one number will take all characters starting at the position (zero based).|")+
//		T(" |Given two numbers will start at the first number and take the second number of characters.|")+
//		TN("T |​Tokeniser: Returns the member of a delimited list using the specified index (zero based). A delimiter can be specified as an optional parameter with the default delimiter being the semcolon character..|")+
//		TN("# |Rounds a number. Specify the number of decimals to round to. Trailing zero's are removed.|")+
//		TN("RL |​Round Local: Rounds a number using the local regional settings..|");
		
// Masterpanel
category = T("|Masterpanel|");
	String sDefaultDescription = T(", |0 = byDefault|") + 
		TN("|By Default the dimensions are specified in global settings and the final shape of the master is adjusted to standard sizes and/or grid sizes.|") + 
		TN("|A value > 0 overrides these settings and assigns a fixed size to the masterpanel|");
	String sLengthName=T("|Length|");	
	PropDouble dLength(5, U(0), sLengthName);	
	dLength.setDescription(T("|Defines the length of the masterpanel|") + sDefaultDescription);
	dLength.setCategory(category);
	
	String sWidthName=T("|Width|");	
	PropDouble dWidth(6, U(0), sWidthName);	
	dWidth.setDescription(T("|Defines the Width|")+ sDefaultDescription);
	dWidth.setCategory(category);

// grain direction master
	String sGrainTypeName=T("|Grain Type|");	
	String sGrainTypes[] = {T("|Automatic|"), T("|Lengthwise|"), T("|Crosswise|")};
	PropString sGrainType(0, sGrainTypes, sGrainTypeName);	
	sGrainType.setDescription(T("|Defines the Grain Type|"));
	sGrainType.setCategory(category);
	
	String tASDisabled = T("|Off|"), tASDefault = T("|On|");
	String sAutoSizeModes[] = { tASDisabled, tASDefault};
	String sAutoSizeModeName=T("|Auto Size Mode|");	
	PropString sAutoSizeMode(7, sAutoSizeModes, sAutoSizeModeName, bHasAutoSize?1:0);	
	sAutoSizeMode.setDescription(T("|Defines if the dimensions of the masterpanel will be adjusted after nesting to a given grid size or minmal values|"));
	sAutoSizeMode.setCategory(category);



// child panel
category = T("|Childpanel|");
	String sFaceAlignmentName=T("|Top Face Alignment|");	
	String sFaceAlignments[] = {T("|Unchanged|"), T("|Higher Quality|"), T("|Lower Quality|")};
	PropString sFaceAlignment(2, sFaceAlignments, sFaceAlignmentName,1);						// 6
	sFaceAlignment.setDescription(T("|Defines the alignment of the child panel|"));
	sFaceAlignment.setCategory(category);

	String sOversizeName=T("|Oversize Format Cut|");	
	PropDouble dOversize(1, U(20), sOversizeName);						// 5
	dOversize.setDescription(T("|Defines the Oversize|") + " " + T("|This value maybe overriden by the Contour offset format of sublabel2| ")+ "<Machine;Offset>");
	dOversize.setCategory(category );



// collect rules from settings
	String sRules[0];	
	for(int i=0;i<mapSortings.length();i++)
		if (mapSortings.hasMap(i))
			sRules.append(mapSortings.getMap(i).getString("Name"));
	
// order rules and append disabled
	sRules = sRules.sorted();
	
	if (sRules.findNoCase(tDisabled,-1)<0)
		sRules.insertAt(0, tDisabled);
	String sRuleName =T("|Sorting Rule|");
	PropString sRule(6,sRules,sRuleName,0);
	sRule.setDescription(T("|Specifies the rule how child panels are sorted prior nesting.|") );
	sRule.setCategory(sCategoryChild);
	int nRule = sRules.find(sRule,0); // 0 = <disabled>	
	


// Nester
category = T("|Nester|");
	String sDurationName = T("|Duration|") + " " + T("|[sec]|");
	PropDouble dDuration(3,1, sDurationName,_kNoUnit);		//2
	dDuration.setDescription(T("|maximum Duration that the nester is allowed to run|"));
	dDuration.setCategory(category);
	
	String sSpacingName = T("|Spacing|");
	PropDouble dSpacing(4,U(8), sSpacingName);					//3
	dSpacing.setDescription(T("|distance between the NesterChilds to keep|"));
	dSpacing.setCategory(category);	


	String sNestInOpeningName = T("|Nest in openings|");
	PropString sNestInOpening(4,sNoYes, sNestInOpeningName,0);
	sNestInOpening.setDescription(T("|to allow openings for placing smaller pieces|") + " " + T("|This option is not availabe for the rectangular nester.|"));
	sNestInOpening.setCategory(category);	

// nester type	
	String sNesterTypeName=T("|Nester Type|");	
	int nNesterTypes[] = {-1,_kNTAutoNesterV5, _kNTRectangularNester};
	String sNesterTypes[] = {T("|Disabled|"),T("|Autonester|"), T("|Rectangular Nester|")};
	PropString sNesterType(5, sNesterTypes, sNesterTypeName,2);	
	sNesterType.setDescription(T("|Defines the Nester Type|"));
	sNesterType.setCategory(category);		


category = T("|Display|");
	String sFormatName =T("|Masterpanel Format|");
	PropString sFormat(1,"@(Style)\P@(SurfaceQuality)",sFormatName );
	sFormat.setDescription(sAttributeDescription);
	sFormat.setCategory(category);		

	String sTxtHName = T("|Masterpanel Text Height|");
	PropDouble dTxtH(0,U(80), sTxtHName );
	dTxtH.setCategory(category);

	String sSipFormatName =T("|Childpanel Format|")+" ";
	PropString sSipFormat(3,"@(Style)\n@(SurfaceQuality)",sSipFormatName );
	sSipFormat.setDescription(sAttributeDescription);
	sSipFormat.setCategory(category );		

	String sChildTxtHName = T("|Childpanel Text Height|")+" ";
	PropDouble dChildTxtH(2,U(80), sChildTxtHName );
	dChildTxtH.setCategory(category);

// the trigger string of the nesting action
	String sNestAction= T("|Nesting|");
	String sNestActionScratch= T("|Nesting|") + T(" |(Reset Rotations)|");
	String sTriggerAddChild = T("|Add Child Panels|");
	
// set variables for freight property set
	String sPropSetName = T("|Freight|");



//End Properties//endregion 

//region OnInsert
// start on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }	


		{ 
			Map mapAdd;
			sFormat.setDefinesFormatting("MasterPanel", mapAdd);
		}
		{ 
			Map mapAddPanel;
			mapAddPanel.setString("GrainDirectionText", T("|Lengthwise|"));// dummy text
			mapAddPanel.setString("GrainDirectionTextShort", T("|Grain LW|"));// dummy text
			
			Map mapAdd;
			sSipFormat.setDefinesFormatting("Panel", mapAddPanel);
		}


	// silent/dialog
		if (_kExecuteKey.length()>0)
			setPropValuesFromCatalog(_kExecuteKey);	
		else
			showDialog();	
			
		nRule = sRules.find(sRule,0); // 0 = <disabled>	
			
	
	// prompt for references
		PrEntity ssE(T("|Select panels(s) or any references to it|") + T(", |<Enter> to create new master panel|"), MasterPanel());
		ssE.addAllowedClass(TslInst());
		ssE.addAllowedClass(Sip());
		ssE.addAllowedClass(ChildPanel());
		
		ssE.allowNested(true);
		
		Entity entsSet[0];
		if (ssE.go())
			entsSet= ssE.set();	
		
	// declare the tsl props
		TslInst tslNew;
		GenBeam gbs[0];
		Entity ents[0];
		Point3d pts[0];
		int nProps[] = {};
		double dProps[] = {dTxtH, dOversize,dChildTxtH, dDuration, dSpacing, dLength, dWidth};
		String sProps[] = {sGrainType, sFormat,sFaceAlignment,sSipFormat,sNestInOpening, sNesterType,sRule, sAutoSizeMode};//sRotation,
		Map mapTsl;
		//mapTsl.setInt("CreatePlotViewport", HasActivePlotViewport(mapPlotViewports));//XX
		

	// collect what we have got from the selection set
		ChildPanel childs[0];
		Sip sips[0];
		TslInst tslPackages[0], tslTrucks[0], tslItems[0], tslSorters[0];
		MasterPanel masters[0];	 
		if(bDebug)reportMessage("\n"+ scriptName() + " " + entsSet.length() + " entities selected...");
		for (int i=0;i <entsSet.length();i++)
		{
			Entity ent = entsSet[i];
			if (ent.bIsKindOf(Sip ()))
				sips.append((Sip)ent);
			else if (ent.bIsKindOf(ChildPanel()))
				childs.append((ChildPanel)ent);
			else if (ent.bIsKindOf(TslInst ()))
			{
				TslInst tsl = (TslInst)entsSet[i];
				if (!tsl.bIsValid())continue;
				Map map = tsl.map();
				if(map.getInt("isTruckContainer"))
					tslTrucks.append(tsl);
				else if(map.getInt("isPackageContainer"))
					tslPackages.append(tsl);
				else if(map.getInt("isFreightItem"))
					tslItems.append(tsl);						
				//else if(tsl.scriptName().makeUpper()==sScriptnamePresorter.makeUpper())
					//tslSorters.append(tsl);	
			}
			else if (ent.bIsKindOf(MasterPanel()))
				masters.append((MasterPanel)ent);								
		}
		if (bDebug)reportMessage("\n	" + sips.length() +" sips\n	" +
			childs.length() +" childs\n	" +
			tslTrucks.length() +" tslTrucks\n	" +
			tslPackages.length() +" tslPackages\n	" +
			tslItems.length() +" tslItems");//\n		" +
			//tslSorters.length() +"tslSorters\n");

		
	// collect packages from trucks
		for (int i=0;i <tslTrucks.length();i++)
		{
			int n = tslPackages.length();
			Entity ents[] = tslTrucks[i].entity();
			for (int e=0;e<ents.length();e++)
			{
				TslInst tsl = (TslInst)ents[e];
				if (!tsl.bIsValid())continue;
				Map map = tsl.map();
				if(map.getInt("isPackageContainer") && tslPackages.find(tsl)<0)
				{
					tslPackages.append(tsl);
					//if (bDebug)reportMessage("\n		Package " + tsl.color() + " of truck " + i + " added.");	
				}	
			}
			if (bDebug)reportMessage("\n		"+ (tslPackages.length()-n)+" + packages added by truck " + i);		
		}	
		//if(bDebug)reportMessage("\n	"+ tslPackages.length() + " packages");
				
	// collect items from packages
		for (int i=0;i <tslPackages.length();i++)
		{
			Entity ents[] = tslPackages[i].entity();
			for (int e=0;e<ents.length();e++)
			{
				TslInst tsl = (TslInst)ents[e];
				if (!tsl.bIsValid())continue;
				Map map = tsl.map();
				if(map.getInt("isFreightItem") && tslItems.find(tsl)<0)
				{
					tslItems.append(tsl);	
					//if (bDebug)reportMessage("\n		Item " + tsl.handle() + " of package " + i + " added.");	
				}						
			}	
		}
		//if(bDebug)reportMessage("\n	"+ tslItems.length() + " items");					

	// collect panels from freight items
		int nNumSips = sips.length();
		for (int i=0;i<tslItems.length();i++)
		{
			TslInst tsl =tslItems[i];
			if (!tsl.bIsValid())continue;
			GenBeam gbs[] = tsl.genBeam();
			Entity ents[] = tsl.entity();
			if (gbs.length()==1 && gbs[0].bIsKindOf(Sip()))
			{
				Sip sip = (Sip)gbs[0];
				if (sips.find(sip)<0)
					sips.append(sip);
			}
		// Collect panels from potential elements // HSB-16637
			for (int j=0;j<ents.length();j++) 
			{ 
				Element el =(Element) ents[j];
				if (el.bIsValid())
				{ 
					gbs = el.genBeam();
					for (int g=0;g<gbs.length();g++) 
					{ 
						Sip sip = (Sip)gbs[g];
						if (sip.bIsValid() && sips.find(sip)<0)
							sips.append(sip);						 
					}//next g	
				}
			}//next j

		}
		//if(bDebug)reportMessage("\n	"+ (sips.length()-nNumSips) + " panels added by items");	

	// erase any existing child panel which has the this panel as parent
		for (int i=childs.length()-1;i>=0;i--)
		{
			ChildPanel child = childs[i];
			Sip sip = child.sipEntity();
			if (sips.length()>0 && sips.find(sip)>-1)
				child.dbErase();
		}		
		if(bDebug)reportMessage("\n	"+ childs.length() + " childs in selection set");
		
	// remove any sip of which there is a child in the dwg
		// collect all child panels of this dwg
		Entity entsChilds[]= Group().collectEntities(true,ChildPanel(),_kModelSpace);
		for (int i=0;i<entsChilds.length();i++) 
		{ 
			Sip sipWithChild = ((ChildPanel)entsChilds[i]).sipEntity(); 
			int n = sips.find(sipWithChild); 
			if (n>-1)
			{
				reportMessage("\n" +scriptName() + ": " +T("|child panel found|")+ " "+ sips[n].handle() + " " + sips[n].name() + "-> " + T("|refused|"));
				sips.removeAt(n);				
			}
		}

	// Vectors
		Vector3d vecX =_XW;
		Vector3d vecY =_YW;
		Vector3d vecZ =_ZW;

	// create childs
		_Pt0 = getPoint(TN("|Pick insertion point|"));
		if (sips.length()>0)
		{
			double dYOffset = U(300);
			Point3d ptInsert = _Pt0;
			
			for(int i=0;i<sips.length();i++)
			{
				Sip sip= sips[i];

			// refuse the creation of childpanels which are already nested
				Map mapMaster = sip.subMapX("Masterpanel");
				if (mapMaster.length()>0)
				{ 
				// TODO compare path and file to accept not nested within this
					reportMessage("\n" + T("|Panel|") + (sip.posnum()>-1?sip.posnum()+" ":"") + sip.name() + T(" |already nested in| ") + mapMaster.getString("FileName") + T(", |Masterpanel| ") + mapMaster.getInt("Number"));
					continue;
				}

				PLine plEnvelope = sip.plEnvelope();
				ChildPanel child;
				child.dbCreate(sips[i], ptInsert, vecY);
	
				CoordSys cs2Me = child.sipToMeTransformation();
				plEnvelope.transformBy(cs2Me);
				plEnvelope.vis(i);

				PlaneProfile pp(plEnvelope);
				LineSeg seg = pp.extentInDir(vecX);seg.vis(i);
				double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
				double dY = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));

				Vector3d vecXGrain = sip.woodGrainDirection();
				vecXGrain.transformBy(cs2Me);
				double dRotation = vecXGrain.angleTo(_XW);
				
				
			// rotate if crosswise
				if (dY>dX && dX<=dMaxWidth && dY>dMaxWidth)
				{ 
					dRotation += 90;
				}

				if (abs(dRotation)>dEps)
				{
					if(bDebug)reportMessage("\n" + sip.posnum() + "/" + child.handle()+" rotating child on insert by " + dRotation + "°");
					
					CoordSys csRot;
					csRot.setToRotation(dRotation, _ZW, child.coordSys().ptOrg());
					child.transformBy(csRot);	
					plEnvelope.transformBy(csRot);
				}
				//vecXGrain.vis(child.coordSys().ptOrg(),4);
				
				pp=PlaneProfile (plEnvelope);
				seg = pp.extentInDir(vecX);seg.vis(i);
				dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
				dY = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
					
				child.transformBy((ptInsert-seg.ptMid())+vecX*.5*dX-vecY*.5*dY);
				childs.append(child);
				ptInsert.transformBy(-vecY*(dY+dYOffset));			
			}// next i
			if(bDebug)reportMessage("\n		"+ childs.length() + " created");	
		}// end create childs
			
	// create masterPanelManager instance with associated childs
		if (childs.length()>0)
		{
		// separate sorted and unsorted childs
			ChildPanel sortedChilds[0], unsortedChilds[0];
			if (nRule == 0)
			{
				sortedChilds = childs;
				if(bDebug)reportMessage("\n"+_ThisInst.handle() +" selected childs (" +childs.length()+")");
			}
			else
			{ 
				for(int i=0;i<childs.length();i++)
				{
					ChildPanel child = childs[i];
					int bSorted;
				// get tsls of child
					TslInst tsls[] = child.tslInstAttached();
					for (int t=0;t<tsls.length();t++)
						if (tsls[t].scriptName().makeUpper() == sScriptnamePresorter.makeUpper())
						{
							sortedChilds.append(child);
							bSorted = true;
						// collect parent sorter	
							if(tslSorters.find(tsls[t])<0)	tslSorters.append(tsls[t]);
						}	
					if (!bSorted)
						unsortedChilds.append(child);
				}// next i			
						
				if(bDebug)reportMessage("\n"+_ThisInst.handle() +" all: " +childs.length()+"\n unsorted: " +unsortedChilds.length() + "\n sorted: " +sortedChilds.length());	
	
			// create presorter		
				if(unsortedChilds.length()>0)
				{
					if(bDebug)reportMessage("\n"+_ThisInst.handle() +" about to create a presorter for " +unsortedChilds.length() + " panels with map " +_Map);	
				// prepare tsl cloning
					TslInst tslSorter;
					GenBeam gbsTsl[] = {};
					Entity entsTsl[] = {};
					Point3d ptsTsl[] = {};
					int nSorterProps[]={};
					double dSorterProps[]={};
					String sSorterProps[]={sRule,sFaceAlignment, sSipFormat};
					Map mapTsl;	
					
					ptsTsl.append(_Pt0);
					for(int i=0;i<unsortedChilds.length();i++)
						entsTsl.append(unsortedChilds[i]);
					tslSorter.dbCreate(sScriptnamePresorter , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, 
							nSorterProps, dSorterProps, sSorterProps,_kModelSpace, mapTsl);	
					
				// append for potential cleanup			
					if (tslSorter.bIsValid())
						tslSorters.append(tslSorter);
				}				
			}
			


		// prompt for point input of masterpanel location
			int bCreateManager=true;
			if(unsortedChilds.length()>0)
			{
				PrPoint ssP(TN("|Pick insertion point to create nesting, <Enter> to exit.|")); 
				if (ssP.go()==_kOk) 
					_Pt0=ssP.value();
				else
					bCreateManager=false;		
			}

			
			
		// create managers based on groupings	
			if (bCreateManager)
			{			
			// create a temp storage for the next insertion point
				MapObject moTemp(sDictionary,"temp");
				Map map;
				map.setPoint3d("ptIns", _Pt0);
				moTemp.dbCreate(map);	
			
			// store childs based on their group tagging into a map and collect potential sorters
				Map mapChilds;
				for(int i=0;i<childs.length();i++)
				{
					ChildPanel child = childs[i];
					String tag = child.subMapX("presorter").getString("tag");
					if (tag=="")tag="not sorted";
					
					Map m;
					if (mapChilds.hasMap(tag))	m=mapChilds.getMap(tag);
					m.appendEntity("child",child);
					mapChilds.setMap(tag,m);
				}// next i	

			// loop sorters against each child to set a removal list within the sorter instance
				Map mapSorterGroup;
				for (int x=0;x<tslSorters.length();x++)
				{
					TslInst tsl = tslSorters[x];
					Map map;
					for(int i=0;i<childs.length();i++)
					{
						ChildPanel child = childs[i];
						TslInst tsls[] = child.tslInstAttached();
						if (tsls.find(tsl)>-1)
						{
							mapSorterGroup.appendMap("SorterGroup", tsl.subMapX("PresorterData"));
							map.appendEntity("RemoveEnt",child);
						}
					}
				// HSB-10011# V8.6 This is already implemented after each nesting. At this position the sugcess of the nesting is not checked. 
//					if (map.length()>0)
//					{
//						Map mapSorter=tsl.map();
//						mapSorter.setMap("RemoveEnt[]", map);
//						tsl.setMap(mapSorter);
//						tsl.transformBy(Vector3d(0,0,0));
//						//if(bDebug)reportMessage("\nXX"+ scriptName() + " sorter tsl "+tsl.handle() + " tranformed with " + tsl.entity().length());	
//					}
				}

			// now loop child groups and create one manager per group
				mapTsl.setInt("callNester", true);
				mapTsl.setMap("SorterGroup[]", mapSorterGroup);
				mapTsl.setInt("CreatePlotViewport", bAutoCreationPlotViewport);
				
				Point3d ptIns = _Pt0;
				if (moTemp.bIsValid())
					ptIns = moTemp.map().getPoint3d("ptIns");
				
				for(int i=0;i<mapChilds.length();i++)
				{
				// break execution if no dongle was found HSB-8512
					if (moTemp.bIsValid() && moTemp.map().getInt("NoDongle"))
					{ 
						moTemp.dbErase();
						eraseInstance();
						return;
					}

					
				// the map of this group
					Map mapChild = mapChilds.getMap(i);
					ents.setLength(0);
					pts.setLength(0);
					
					for(int j=0;j<mapChild.length();j++)
					{
						Entity ent = mapChild.getEntity(j);
						if (!ent.bIsValid() || !ent.bIsKindOf(ChildPanel()))continue;
						ents.append(ent);
					}
					pts.append(ptIns);
					tslNew.dbCreate(scriptName(), _XW, _YW, gbs, ents, pts, nProps, dProps, sProps, _kModelSpace, mapTsl);	
					//if(bDebug)reportMessage("\n" + scriptName() + "group " + i + " created a new instance with "+ ents.length() + " childs " + tslNew.bIsValid());
					
					//if (tslNew.bIsValid())
						//ptIns.transformBy(_XW*(dMaxLength+dRowOffset));
					if (moTemp.bIsValid() && tslNew.bIsValid())
					{
						Map m = moTemp.map();
						ptIns = m.getPoint3d("ptIns");
						ptIns.transformBy(_YW*-(dMaxWidth+2*dRowOffset));
						m.setPoint3d("ptIns", ptIns);
						moTemp.setMap(m);
					}
					
				}// next i
			}
		}
		
	// create masterPanelManager instance per selected masterpanel	
		for(int i=0; i<masters.length();i++)
		{
			pts.setLength(0);
			ents.setLength(0);
			mapTsl = Map();
			MasterPanel master =masters[i];
			pts.append(master.coordSys().ptOrg());			
			ents.append(master);
			tslNew.dbCreate(scriptName(), _XW, _YW, gbs, ents, pts, nProps, dProps, sProps, _kModelSpace, mapTsl);	
			//if(bDebug)reportMessage("\n	"+ "master created");	
		}

	// cleanup the mo of next insertion point
		MapObject moTemp(sDictionary,"temp");
		if (moTemp.bIsValid())
			moTemp.dbErase();
	
	// new master will be created on dbCreated	
		if (childs.length()<1 && masters.length()<1)	
			;//_Pt0 = getPoint(TN("|Select origin of master panel|"));	
		else
			eraseInstance();	
		return;
	}
// END IF on insert

	//if(bDebug)reportMessage("\n"+ scriptName() + " " + _ThisInst.handle() + " starting(" + _kExecutionLoopCount + ")...");// + getTickCount());
			
//endregion 
	
//End Part #2//endregion 

//region Get a potential master, plotviewport and/or bref from _Entity
	BlockRef bref;
	MasterPanel master;
	PlotViewport pv;
	for (int i=0;i<_Entity.length();i++) 
	{ 
		Entity& ent = _Entity[i];
		BlockRef _bref = (BlockRef)ent; 
		PlotViewport _pv = (PlotViewport)ent; 
		MasterPanel _master = (MasterPanel)ent; 
		if (_bref.bIsValid())
		{
			// HSB-21514 do not accept definitions which contain a apnel or childpanel
			int bOk=true;			
			Block bl(_bref.definition());
			Entity _ents[] = bl.entity();
			for (int j=0;j<_ents.length();j++) 
			{ 
				if (_ents[j].bIsKindOf(Sip()) || _ents[j].bIsKindOf(ChildPanel()))
				{
					bOk=false;
					break;
				}	 
			}//next j
			
			if (bOk)
				bref = _bref;
		}
		else if (_master.bIsValid())
			master = _master;
		else if (!pv.bIsValid() && _pv.bIsValid())
			pv = _pv;			
		else 
		{
			String dxgType = ent.typeDxfName();
			continue;
		}
		setDependencyOnEntity(ent);
	}		
//endregion 

//region Properties by index
	int nNesterType;
	{
		int n = sNesterTypes.findNoCase(sNesterType,-1);
		if (n>-1 && n<nNesterTypes.length())
			nNesterType=nNesterTypes[n];
	}
	int bNestInOpening = sNoYes.find(sNestInOpening) && nNesterType==_kNTAutoNesterV5;
	int nFaceAlignment = sFaceAlignments.find(sFaceAlignment);// 0 = unchanged, 1 = higher quality , 2= lower quality
	if (nFaceAlignment <0 && sFaceAlignments.length()>0)sFaceAlignment.set(sFaceAlignments[0]);	
	
	int nGrainType = sGrainTypes.find(sGrainType); 
	if (nGrainType<0 && sGrainTypes.length()>0)sGrainType.set(sGrainTypes.first());	
	
	//int bAutoSizeDisabled = _Map.getInt("ToggleAutoSize");
	
//region AutoSize
	

// HSB-16897 legacy: up to version 10.5 the tool had a trigger to disable the auto sizing
	if (_Map.hasInt("ToggleAutoSize"))
	{ 
		int bAutoSizeDisabled = _Map.getInt("ToggleAutoSize");
		sAutoSizeMode.set(bAutoSizeDisabled ? tASDisabled : tASDefault);
		_Map.removeAt("ToggleAutoSize", true);
	}	
	
	int bAutoSize = sAutoSizeMode == tASDefault;// flag to inidicate if autoSizing is selected
		
// //HSB-16897 legacy: up to version 10.5 the tool had a trigger to specify a fixed width. This has now been replaced by the width  property
	if (_Map.hasDouble("FixedWidth"))
	{
		double d = _Map.getDouble("FixedWidth");
		if (d>0)
			dWidth.set(d);
		_Map.removeAt("FixedWidth", true);
	}

	int bDoAutoSize = _Map.getInt("AutoSize") && bAutoSize;	// flag if autoSizing shall be performed
	int bSetFixedSize = _Map.getInt("AutoSize") && !bAutoSize;
	String sAutoSizeEvents[] = { sAutoSizeModeName, sLengthName, sWidthName}; // if the autoSize property or property of length and width changes
	int nAutoSizeEvent = sAutoSizeEvents.findNoCase(_kNameLastChangedProp ,- 1);
	
	if(nAutoSizeEvent>-1 && sAutoSizeMode==tASDefault)
	{ 
		if((nAutoSizeEvent==1 && dLength>0) || (nAutoSizeEvent==2 && dWidth>0) )
		{ 
			bAutoSize = false;
			bSetFixedSize = true;
			reportMessage("\n" + sAutoSizeModeName + " " + T("|has been turned off.|"));
			sAutoSizeMode.set(tASDisabled);
		}		
		
		
		if (bAutoSize)
		{ 
			bDoAutoSize = true;
			//reportNotice("\ndoAutoSize");
		}
		else if (nAutoSizeEvent==0)
		{ 
			reportNotice(TN("|Could not find auto size definition, please review your settings.|"));
			sAutoSizeMode.set(tASDisabled);
		}
	}
	else if (nAutoSizeEvent>-1 && (dLength>0 ||dWidth>0)) // length or width modfied but no auto sizing
	{ 
		bDoAutoSize = false;
		bSetFixedSize = true;
		//reportNotice("\ndoFixedSize");
	}
	

	//reportNotice("\ndoAutoSize: " + bDoAutoSize + " bSetFixedSize: " + bSetFixedSize);
//endregion 	


	int bTagGrips = _Map.getInt("ToggleTagGrips");
	addRecalcTrigger(_kGripPointDrag, "_Grip");
	
	int bAutoEdgeAlignmentDisabled = _Map.getInt("ToggleAutoEdgeAlignment");
	if (!_Map.hasInt("ToggleAutoEdgeAlignment")) // once the toggle has been used it has priority over the settings value
		bAutoEdgeAlignmentDisabled = !bEdgeAlignment;
	else 
		bEdgeAlignment = !bAutoEdgeAlignmentDisabled;		
//End properties by index//endregion 	

//region Get potential group width from presorter
	double dFixedWidth = dWidth;//HSB-16897   _Map.getDouble("FixedWidth"); // get custom fixed width if set by trigger
	if (dFixedWidth<=0 && _Map.hasMap("SorterGroup[]"))
	{ 
		Map mapSorterGroup = _Map.getMap("SorterGroup[]");
		double dWidths[0];
		for (int i=0;i<mapSorterGroup.length();i++) 
		{ 
			Map m= mapSorterGroup.getMap(i);
			double d = m.getDouble("DefaultWidth");
			if (dWidths.find(d)<0 && d >0)
				dWidths.append(d);			 
		}//next i
	// order ascending
		for (int i=0;i<dWidths.length();i++) 
			for (int j=0;j<dWidths.length()-1;j++) 
				if (dWidths[j]>dWidths[j+1])
					dWidths.swap(j, j + 1);	
		if (dWidths.length() > 0)dFixedWidth = dWidths.last() + 2*dOversize;
	}
//End Get potential group width by presorter//endregion 

//region Defaults
	_ThisInst.setDrawOrderToFront(0);
	Vector3d vecX = _XW;
	Vector3d vecY = _YW;
	Vector3d vecZ = _ZW;
	_Pt0.setZ(0);
	
	int nLeftRight = (bAlignRight)?-1:1;//1 = left, -1 = right
	Vector3d vecXGrainMaster,vecYGrainMaster;
	if (nGrainType!=0)
	{
		vecXGrainMaster= nGrainType==1?vecX:vecY;	
		vecYGrainMaster= nGrainType==1?vecY:-vecX;
	} 
	
	
	// override default width  by property
	if (dWidth > 0) // HSB-16897
		dMaxWidth = dWidth;
	if (dLength > 0) // HSB-16897
		dMaxLength = dLength;

	double dMasterWidth = dFixedWidth > 0 ? dFixedWidth : dMaxWidth;

// set coordSys
	Point3d ptOrg =_Pt0;
	CoordSys cs = CoordSys(ptOrg, vecX,vecY, vecZ);
	Plane pnW(_Pt0, _ZW);
	cs.vis(2);	
	
// get all childs which have been rotated by the user
	Entity entRotatedChilds[] = _Map.getEntityArray("RotatedChild[]","","RotatedChild");	
//End Defaults//endregion 

//region Get and/or validate FeedDirection block
	if (sFeedBlockName.length()>0)
	{ 
		if (_BlockNames.findNoCase(sFeedBlockName,-1)<0)
		{ 
			String fileName = sFeedBlockName;
			if (fileName.right(4).find(".dwg",0,false)<0)
				fileName += ".dwg";
			String path = _kPathHsbCompany + "\\Block\\" + fileName;
							
			fileName = findFile(path);	
			if (fileName.length()>0)
			{ 
				Block block(fileName);
				LineSeg seg = block.getExtents();
			}
			
			if (_BlockNames.findNoCase(sFeedBlockName,-1)<0)
				sFeedBlockName = "";
		}
	}
//End Get and/or validate FeedDirection block//endregion 

//region Create Masterpanel
// flag to recreate master
	String sEventsCreateMaster[] ={sNestAction,sDoubleClick,sNestActionScratch,sTriggerAddChild};
	int nEvent = sEventsCreateMaster.findNoCase(_kExecuteKey ,- 1);
	int bCreateMaster = master.bIsValid() && 
		(_bOnRecalc && (nEvent>-1) ) &&
		(master.dWidth()<dMaxLength || master.dLength()<dMasterWidth);
	
	if (nEvent==0 && nNesterType==-1)// HSB-22739 do not recreate master if nester is disabled
		bCreateMaster=false;	
	else if (_kNameLastChangedProp==sGrainTypeName)
		bCreateMaster=true;



// before nest action erase and recreate master with standard dimensions
	Point3d ptRefLoc=_Pt0;
	if(bCreateMaster)
	{
		//if (bDebug)
		reportNotice("\ncreate new master and delete previous"+nEvent+nNesterType);
		ptRefLoc=master.ptRef();
		master.dbErase();
	}
	else if(nNesterType==-1 && _bOnRecalc &&  _kExecuteKey==sDoubleClick)
	{ 	
	// flag to optimize master panel size
		_Map.setInt("AutoSize", true);
		if (bDebug)reportMessage("\nautosize flag set");
	}

// create the master panel 
	if (!master.bIsValid())//_bOnDbCreated && 
	{	
		ptOrg=_Pt0+vecY*vecY.dotProduct(ptRefLoc-ptOrg);
		PLine pl;
		pl.createRectangle(LineSeg(ptOrg,ptOrg+nLeftRight*vecX*dMaxLength + vecY*dMasterWidth),vecX,vecY);	
		
		if(bAlignRight)pl.transformBy(vecX*dMaxLength);
		//pl.vis(6);
	// create the default masterpanel
		String entryName = "Standard";
		master.dbCreate(entryName, cs, pl);	
		_Entity.append(master);
		
		if (bDebug) 
		{
			reportMessage("\n	master " +master.handle() +" successfully created dX = "+dMaxLength + " dY = " +dMasterWidth);
//			EntPLine epl;
//			epl.dbCreate(pl);
//			epl.setColor(6);
		}
	}	
	
// validate master reference		
	if (!master.bIsValid())
	{
		if (bDebug) reportMessage("\nSorry, no master found");
		eraseInstance();
		return;			
	}
	setDependencyOnEntity(master);		
//End Create Masterpanel//endregion 

//region Get potential remote shape lock
	int bShapeLock;
	if (master.subMapXKeys().findNoCase(kShapeLock,-1)>-1)
	{ 
		Map m = master.subMapX(kShapeLock);
		bShapeLock = m.getEntity(kOriginator).bIsValid() && m.getInt(kIsLocked) == true;
	}
//endregion 

//region Control masters posnum if not set
	if (master.number()<(nStartNumber>0?nStartNumber:1))
	{
		if (bDebug) reportMessage("\n	assign master posnum...");
	// collect all current master panels
		Entity ents[] = Group().collectEntities(true, MasterPanel(), _kModelSpace);
		
	// collect used numbers
		int numbers[0];	
		for(int i=0;i<ents.length();i++)
		{
			MasterPanel m = (MasterPanel)ents[i];
			if (!m.bIsValid())continue;
			int number= m.number();
			if (number>-1) numbers.append(number);
		}// next i
		
	// find first free number starting at 1 or specified number
		int number= nStartNumber>0?nStartNumber:1;	
		for(int i=0;i<numbers.length();i++)
			if (numbers.find(number)>-1)
				number++; 		
	
	// assign number
		master.setNumber(number);	
		if (bDebug) reportMessage("done");
	}		
//End control masters posnum if not set//endregion 

//region Get master dimensions
	Line lnX(_Pt0,vecX);
	PLine plShape = master.plShape();
	PlaneProfile ppMaster(cs);
	ppMaster.joinRing(plShape, _kAdd);

	
	
	PlaneProfile ppMasterNet=ppMaster;
	if (bDebug){PlaneProfile pp = ppMaster; pp.transformBy(vecZ*U(1));pp.vis(6);}
	LineSeg segMaster = ppMaster.extentInDir(vecX);
	double dX = abs(vecX.dotProduct(segMaster.ptStart()-segMaster.ptEnd()));
	double dY = abs(vecY.dotProduct(segMaster.ptStart()-segMaster.ptEnd()));
	
	Point3d ptMidMaster = segMaster.ptMid();
	
	// modify openings only if not locked
	if (!bShapeLock)
	{ 
		// add master openings // HSB-13524
		int openingCount = master.openingCount(); 	
		for (int i=openingCount; i>=0 ; i--) 
		{ 
			if (bAddOpeningToMaster) // add openings to shape...
				ppMaster.joinRing(master.plOpeningAt(i),_kSubtract); 
			master.removeOpeningAt(i); 	// ... and remove immediatly as they will be readded if flagged
		}//next i		
	}

	
// get outline to snap dimpoints to
	PLine plDimSnap;
	plDimSnap.createRectangle(LineSeg(segMaster.ptMid() - .5 * (vecX * (dX + U(2)) + vecY * (dY + U(2))), segMaster.ptMid() + .5 * (vecX * (dX + U(2)) + vecY * (dY + U(2)))), vecX, vecY);
	//plDimSnap.vis(12);
	
// set insertion point
	if (_bOnDbCreated)		_Pt0 = segMaster.ptMid()-vecX*.5*dX-vecY*(.5*dY + 4*dTxtH);	
	
// get calllNester flag: this flag is set by another instance which has left over child panels
	int bCallNester = _Map.getInt("callNester");	
//End Get master dimensions//endregion 

//region collect nested childs by master
	ChildPanel childs[0];
	if (!bCallNester) 
	{
		if (bDebug) reportMessage("\n	getting childs from master, don't 'call nester, handle: " + master.handle());
		childs= master.nestedChildPanels();
		
	// Remove duplicates: this may happen if copies of the childs exist nearby // HSB-17748
		Sip sipRefs[0];
		for (int i=childs.length()-1; i>=0 ; i--) 
		{ 
			Sip sip =childs[i].sipEntity();
			int bIsValid = sip.bIsValid();
			if (!bIsValid || (bIsValid && sipRefs.find(sip)>-1))
			{
				int n = _Entity.find(childs[i]);
				if (n>-1)
					_Entity.removeAt(n);
				childs.removeAt(i);
			}
			else
				sipRefs.append(sip);
		}//next i

		
	// set dependency to childs of master
		for (int i=0;i<childs.length();i++)
		{
			ChildPanel child = childs[i];
			_Entity.append(child);
		}
		
	// remove any outside child which is in _Entity		
		for (int i=_Entity.length()-1;i>=0;i--)
		{
			ChildPanel child=(ChildPanel)_Entity[i];
			if (child.bIsValid() && childs.find(child)<0)
			{
				if (bDebug) reportMessage("\nremoving outside child");
				_Entity.removeAt(i);
			}
			else
				setDependencyOnEntity(child);		
		}	
	}
	else
	{
		if (bDebug)reportMessage("\ncall nester");
	// collect potential childs to be nested
		for (int i=_Entity.length()-1;i>=0;i--)
		{
			ChildPanel child=(ChildPanel)_Entity[i];
			if (!child.bIsValid()) continue;
			childs.append(child);
		}		
	}	
	int bHasChild = childs.length() > 0;


//region Collect panels and corresponding
	Sip sips[0];
	PLine plEnvelopes[0];
	Body bodies[0];
	CoordSys cs2mes[0];
	// HSB-24493
	int nDeliveryMaster=99999;
	for (int i = 0; i < childs.length(); i++)
	{
		Sip sip = childs[i].sipEntity();
		sips.append(sip);
		plEnvelopes.append(sip.plEnvelope());
		cs2mes.append(childs[i].sipToMeTransformation());
		if(sip.subMapXKeys().findNoCase("StackingData")>-1)
		{ 
			Map mapxI=sip.subMapX("StackingData");
			if(mapxI.hasInt("NUMBER"))
			{
				int nDelivery=mapxI.getInt("NUMBER");
				if(nDelivery>-1 && nDelivery<nDeliveryMaster)
				{ 
					nDeliveryMaster=nDelivery;
				}
			}
			
		}
	}
//endregion 
	
//End collect nested childs by master//endregion 

//region Nester Trigger
	if (bHasChild)
	{
		addRecalcTrigger(_kContextRoot, sNestAction);
		if (entRotatedChilds.length()>0 && nNesterType== _kNTAutoNesterV5)addRecalcTrigger(_kContextRoot, sNestActionScratch);
		
		
	// 	auto grain
		if (nGrainType==0)
		{ 
			double dAreaL, dAreaC;
			for (int i=0;i<sips.length();i++) 
			{ 
				Sip& sip = sips[i];
				PLine& pl = plEnvelopes[i];
				Vector3d vecGrain = sip.woodGrainDirection().bIsZeroLength() ? sip.vecX() : sip.woodGrainDirection();
				vecGrain.transformBy(cs2mes[i]);
				if (vecGrain.isParallelTo(vecX))
					dAreaL += pl.area();
				else
					dAreaC += pl.area(); 
			}//next i
			
			if (dAreaL>=dAreaC)
			{ 
				vecXGrainMaster = vecX;
				vecYGrainMaster = vecY;	
			}
			else 
			{ 
				vecXGrainMaster = vecY;
				vecYGrainMaster = -vecX;	
			}			
		}
	}
	int bNest =  nNesterType > -1  && bHasChild &&
		((_bOnRecalc && (_kExecuteKey==sNestAction || _kExecuteKey==sDoubleClick)) || _kExecuteKey==sNestActionScratch || bCallNester || bCreateMaster);
		
// reset rotation of any child
	if (_bOnRecalc &&  _kExecuteKey==sNestActionScratch)
	{
		_Map.removeAt("RotatedChild[]", true);
		entRotatedChilds.setLength(0);
	}
		
//End Nester Trigger//endregion 

//region Prompt for childs if no childs in master
	addRecalcTrigger(_kContextRoot, sTriggerAddChild);
	int bAddChilds;
	if(_kExecuteKey==sTriggerAddChild)
	{
		if (_Grip.length() > 0) _Grip.setLength(0);
		bAddChilds=true;
		bNest = nNesterType > -1;	
	}	

	if ((bNest && !bHasChild && !bCallNester) || bAddChilds)
	{
	// select child panels
		PrEntity  ssE(T("|Select child panels to be nested|"),ChildPanel());
		ssE.addAllowedClass(Sip());
		
		Entity entsSet[0];
		if (ssE.go())
			entsSet= ssE.set();	
	
	// append existing child panels to master
		for (int i=0;i <entsSet.length();i++)
		{
			ChildPanel child = (ChildPanel)entsSet[i];
			if (childs.find(child)<0)
				childs.append(child);	
		}	
	}		
//End // Prompt for childs if no childs in master//endregion 

// Trigger ToggleTagGrips
	String sTriggerToggleTagGrips =bTagGrips?T("|Tag Grips Off|"):T("|Tag Grips On|");
	addRecalcTrigger(_kContextRoot, sTriggerToggleTagGrips);
	if (_bOnRecalc && _kExecuteKey==sTriggerToggleTagGrips)
	{
		bTagGrips = !bTagGrips;
		_Map.setInt("ToggleTagGrips", bTagGrips);
		
		
		if (!bTagGrips)
		{ 
			for (int i=_Grip.length()-1; i>=0 ; i--) 
			{ 
				String name = _Grip[i].name();
				if (name.find("Tag_",0, false)>-1)
					_Grip.removeAt(i);
				
			}//next i	
		}
		
		
		
		setExecutionLoops(2);
		return;
	}
	




//region Add show / hide relation trigger
	int bShowRelation = _Map.getInt("ShowRelation");
	String sToggleRelationTrigger =bShowRelation?T("|Hide Relation|"):T("|Show Relation|");
	addRecalcTrigger(_kContext, sToggleRelationTrigger );
	if (_bOnRecalc && _kExecuteKey==sToggleRelationTrigger) 
	{
		bShowRelation=bShowRelation?false:true;
		_Map.setInt("ShowRelation",bShowRelation);
		
		if (bShowRelation)
		{ 
		// prompt for entities
			Entity ents[0];
			PrEntity ssE(T("|Select child panels to trace|") + T(", |<Enter> = all|"), ChildPanel());
			if (ssE.go())
				ents.append(ssE.set());
			if (ents.length()<1)
				for (int i=0;i<childs.length();i++) 
					ents.append(childs[i]); 
			_Map.setEntityArray(ents,false,"Trace[]","","Trace");	
		}
		else
			_Map.removeAt("Trace[]", true);

		setExecutionLoops(2);
		return;		
		
		
	}		
//End Add show / hide relathion trigger//endregion 
	
//region Collect data and profiles of childs
	SurfaceQualityStyle surfaceQualityStyleTop, surfaceQualityStyleBottom;// declare default master surface quality styles
	//HSB-16247 allow manual override of a higher quality. will be overwritten on nesting
	if (master.surfaceQualityOverrideBottom()!="")
		surfaceQualityStyleBottom = SurfaceQualityStyle(master.surfaceQualityOverrideBottom());
	if (master.surfaceQualityOverrideTop()!="")
		surfaceQualityStyleTop = SurfaceQualityStyle(master.surfaceQualityOverrideTop());
	
	int bPanelsHaveMasterData;// a flag if any of the referenced sips has masterpanel mapX data attached. if true a trigger to remove this is available
	int bFlipAllowed = childs.length()==1 || nFaceAlignment==0; // flag to add the trigger to flip a panel, facealignment: 0 = unchanged, 1 = higher quality , 2= lower quality
	PlaneProfile ppChilds[childs.length()], ppAllChild(CoordSys()), ppBoxChilds[childs.length()],ppOutterContourChilds[childs.length()]; double dOversizes[childs.length()];
	String sQualityDescriptions[childs.length()];
	String sStyleNames[0];
	double dStyleAreas[0];
	
	
//region Set flipAllowState if nothing prevents it
	if (nFaceAlignment>0 && !bKeepFloorReferenceBottom)	
	{ 
		int bMayFlip = true;
		for (int c = sips.length() - 1; c >= 0; c--)
		{
			Sip& sip = sips[c];
			if (!sip.bIsValid())continue;
			
			int nQualityBot = sip.formatObject("@(SurfaceQualityBottomStyleDefinition.Quality)").atoi();
			int nQualityTop = sip.formatObject("@(SurfaceQualityTopStyleDefinition.Quality)").atoi();
			
			if (nQualityBot!=nQualityTop)
			{ 
				bMayFlip = false;
				break;
			}	
		}
		if (bMayFlip)
			bFlipAllowed = true;
	}
//End Set flipAllowStae if nothing prevents it//endregion 	
	

	// HSB-10011#
	// If sGrainType is set to crosswise the childs get transformed (rotated). This creates an issue transforming the childs into the master panel.
	// To avoid this the Tsl gets restarted.
	int bRestartWhenChildsTransformed;
	
	
	Body bdFlipFailures[0]; Sip cltFlipFailures[0];// arrays of child bodies and panels which could not be flipped due to their bevels and geometry
	// HSB-22579
	int bConsistentThickness=true;
	double dZthicknessPanel;
	for (int c=childs.length()-1; c>=0 ; c--) 
	{ 
		
	//region Sip variables		
		ChildPanel& child = childs[c]; child.coordSys().vis(4);
		int bIsFlipped = child.bIsFlipped();
		
		Sip sip = child.sipEntity();
		if (!sip.bIsValid())continue;		
		
		// HSB-22579
		if(bConsistentThickness)
		{ 
			// check if inconsistent
			double dHc=sip.dH();
			if(dZthicknessPanel<dEps)
			{ 
				// first panel, initialize
				dZthicknessPanel=dHc;
			}
			else
			{ 
				// HSB-23793
				if(abs(dZthicknessPanel-dHc)>dEps)
				{ 
					bConsistentThickness=false;
				}
			}
		}
	// make sure child is always top aligned with master HSB-150000, HSB-21898
		if (child.coordSys().vecZ().isCodirectionalTo(_ZW))
		{
			double dOffsetZ = _ZW.dotProduct(_Pt0-child.coordSys().ptOrg())-sip.dH();
			child.transformBy(_ZW * dOffsetZ);
		}		


	// get association
		Map map = sip.subMap("ExtendedProperties");
		int bIsFloor = map.getInt("isFloor");
				
	// Get additional child offset if specified
		double dChildOversize=dOversize;
		String sSubLabel2 = sip.subLabel2().makeUpper();
		if (sSubLabel2.length()>0)
		{ 
			String sSublabel2Tokens[]=sSubLabel2.tokenize(";");
			if (sSublabel2Tokens.length()>1)
			{ 
				String sRoute = sSublabel2Tokens.first();
				double dOffset = sSublabel2Tokens.last().atof();
				if (sRoute.length()>0)	dChildOversize=dOffset;
			}
		// compatibility to previous approach
			else if (sSubLabel2!="HU")
				dChildOversize=dOversize;			
		}
	
	// set flag if any of the sips has masterpanel data attached	
		if (!bPanelsHaveMasterData && sip.subMapXKeys().find(kMasterXName) >- 1)bPanelsHaveMasterData = true;		
	//End Sip variables//endregion 	

	//region Get surface quality and flip state
		SipStyle style(sip.style());
		String entries[2];
		int qualities[0];
		entries[0]=style.surfaceQualityTop(); // ref side
		if (sip.surfaceQualityOverrideTop()!="")	entries[0] = sip.surfaceQualityOverrideTop();

		entries[1]=style.surfaceQualityBottom(); // opp side
		if (sip.surfaceQualityOverrideBottom()!="")	entries[1] = sip.surfaceQualityOverrideBottom();

	// collect qualities and set flag to add flip triggers
		qualities.append(SurfaceQualityStyle(entries[0]).quality());
		qualities.append(SurfaceQualityStyle(entries[1]).quality());	

	// swap quality if child is flipped
		if(bIsFlipped) 
		{
			entries.swap(0,1);			
			qualities.swap(0,1);
			//if (bDebug) reportNotice("\n"+sip.formatObject("@(Name)")+ " isFlipped with qualities " +qualities);
		}	
		
		Vector3d vecNestFace = map.getVector3d("vecNestFace");
		vecNestFace.transformBy(child.sipToMeTransformation());
		
	// flip child if preferred top face direction does not match on equal surface qualities
	
		if (nFaceAlignment>0 && qualities[0]==qualities[1] && !vecNestFace.bIsZeroLength() && vecNestFace.dotProduct(_ZW)<0)//0 = unchanged, 1 = higher quality , 2= lower quality
		{ 
			if (bDebug)vecNestFace.vis(child.coordSys().ptOrg(), 40);
			
			bIsFlipped =! bIsFlipped;
			child.setBIsFlipped(bIsFlipped);
			
			if (bIsFlipped!=child.bIsFlipped())
			{ 
				bdFlipFailures.append(child.realBody());
				cltFlipFailures.append(sip);		
			}
			else
			{ 
				entries.swap(0,1);			
				qualities.swap(0,1);				
			}
			
			if (bDebug)reportNotice("\nFlip #1 " + sip.formatObject("@(Name) ")+qualities);
		}
	// flip child if face alignment does not match
		else if ((nFaceAlignment==1 && qualities[0]>qualities[1]) || 
			(nFaceAlignment==2 && qualities[0]<qualities[1]))// higher or lower quality on top face
		{

			bIsFlipped =!bIsFlipped;
			child.setBIsFlipped(bIsFlipped);
			
			if (bIsFlipped!=child.bIsFlipped())
			{ 
				bdFlipFailures.append(child.realBody());
				cltFlipFailures.append(sip);		
			}
			else
			{ 
				entries.swap(0,1);			
				qualities.swap(0,1);				
			}

			//reportNotice("\nFlip #2 " + sip.formatObject("@(Name) ")+qualities+ " flip req/cur" +bIsFlipped +"vs"+ child.bIsFlipped());
			if(bDebug)
			{
				reportNotice("\n" + sip.formatObject("@(Name)\nBot-Top: @(SurfaceQualityBottomStyle.Quality) - @(SurfaceQualityTopStyle.Quality)")+
				"\nnow flipped due to face alignment" + " Face Alignment: " +nFaceAlignment + " qualities:"+qualities + " isFlipped:"+bIsFlipped);
			}			
			
			
		}		
	//End Get surface quality//endregion 

	//region Flip reference side to bottom if qualities are identical and association is of type roof	
		else if (bKeepFloorReferenceBottom && bIsFloor && qualities[0]==qualities[1])
		{ 
			bFlipAllowed = false; // HSB-8219
			Vector3d vecZ = sip.vecZ();
			vecZ.transformBy(child.sipToMeTransformation());
			vecZ.normalize();
			if (vecZ.dotProduct(_ZW)<0)
			{ 
				//vecZ.vis(ptCen+_XW*U(100),1);
				bIsFlipped =!bIsFlipped;
				child.setBIsFlipped(bIsFlipped);
				if (bIsFlipped!=child.bIsFlipped())
				{ 
					bdFlipFailures.append(child.realBody());
					cltFlipFailures.append(sip);		
				}
				else
				{ 
					entries.swap(0,1);			
					qualities.swap(0,1);				
				}
				
				if (bDebug)reportNotice("\nFlip #3 " + sip.formatObject("@(Name) ")+qualities);
			
			}
			//else vecZ.vis(ptCen+_XW*U(100),60);	
		}		
		sQualityDescriptions[c]=entries[1] + "(" +entries[0] +")";	
		
	// save highest quality per side
		if (!surfaceQualityStyleBottom.bIsValid() || surfaceQualityStyleBottom.quality()<SurfaceQualityStyle(entries[0]).quality())	
		{
			surfaceQualityStyleBottom= SurfaceQualityStyle(entries[0]);
		}
		if (!surfaceQualityStyleTop.bIsValid() || surfaceQualityStyleTop.quality()<SurfaceQualityStyle(entries[1]).quality())	
		{
			surfaceQualityStyleTop= SurfaceQualityStyle(entries[1]);				
		}
	//End flip reference side to bottom if qualities are identical and association is of type roof	//endregion 

	//region Collect relevant profile of child
		CoordSys sip2child;
		sip2child=child.sipToMeTransformation();
		Point3d ptCen = sip.ptCenSolid();
		ptCen.transformBy(sip2child);
		Vector3d vecXS = sip.vecX(); vecXS.transformBy(sip2child);
		Vector3d vecYS = sip.vecY(); vecYS.transformBy(sip2child);
		

		Body bdSip = bNestInOpening?sip.realBody():sip.envelopeBody(false,true);
		bdSip.transformBy(sip2child);//bdSip.vis(4);
		PlaneProfile ppShadow = bdSip.shadowProfile(pnW);
		if (abs(dChildOversize) > dEps)
			ppShadow.shrink(-dChildOversize);

		LineSeg segChild = ppShadow.extentInDir(vecX);//segChild.vis(3);
		double dXChild = abs(vecX.dotProduct(segChild.ptStart()-segChild.ptEnd()));
		double dYChild = abs(vecY.dotProduct(segChild.ptStart()-segChild.ptEnd()));
		Point3d ptOrgC = segChild.ptMid()-.5*(vecX*dXChild+vecY*dYChild);	
		
	// Get child profile	
		PlaneProfile ppChild(cs);
		PLine rings[] = ppShadow.allRings(true,false);
		PLine openings[] = ppShadow.allRings(false,true);
		
		for (int r=0;r<rings.length();r++)
			ppChild.joinRing(rings[r],_kAdd);
		
		ppBoxChilds[c].createRectangle(ppChild.extentInDir(vecXS), vecXS, vecYS);
		ppOutterContourChilds[c]=ppChild;// HSB-24434:
		//ppBoxChilds[c].transformBy(vecZ * U(600));
		//ppBoxChilds[c].vis(40);
		
		// modify openings only if not locked
		if (!bShapeLock)
		{ 
			// HSB-13525
			for (int r=0;r<openings.length();r++)
			{
				//if (bNestInOpening) 
					ppChild.joinRing(openings[r],_kSubtract);	
				if (bAddOpeningToMaster)
					master.appendOpening(openings[r]);	
			}			
		}


		//ppChild.shrink(-.5 * dOversize);
		//{PlaneProfile pp = ppChild; pp.transformBy(vecZ*U(50));pp.vis(c);}
		ppChilds[c]=ppChild;
		
		ppAllChild.unionWith(ppChild);
		dOversizes[c] = dChildOversize;
	//End Collect relevant profile of child//endregion 

	//region Validate and/or rotate childs alignment if width is not matching
		Vector3d vecXGrainChild = sip.woodGrainDirection().bIsZeroLength()?sip.vecX():sip.woodGrainDirection();
		vecXGrainChild.transformBy(sip2child);
		if (!vecXGrainMaster.bIsZeroLength() && !vecXGrainChild.isParallelTo(vecXGrainMaster))
		{ 
			vecXGrainChild.vis(ptCen, dXChild<dY?3:1);
		 //the child would fit if rotated
			if (dXChild<=dY)
			{ 
				double dAngle = vecXGrainMaster.angleTo(vecXGrainChild);
				CoordSys csRot; csRot.setToRotation(dAngle, vecZ, segChild.ptMid());
				child.transformBy(csRot);
				segChild.transformBy(csRot);
				ppChilds[c].transformBy(csRot);
				ppBoxChilds[c].transformBy(csRot);
				ppOutterContourChilds[c].transformBy(csRot);// HSB-24434:
				// HSB-10011#'
				bRestartWhenChildsTransformed = true;
			}
		// the child does not fit in the master
			else
			{ 
				if (bDebug)reportMessage(TN("|child|"))+ child.handle() +  " not within width range";
				sips.removeAt(c);
				childs.removeAt(c);
				ppChilds.removeAt(c);
				ppBoxChilds.removeAt(c);
				ppOutterContourChilds.removeAt(c);// HSB-24434:
				int n = _Entity.find(child);
				if (n >- 1)_Entity.removeAt(n);
				
			// remove potential data link  // HSB-20754	 
				Map mapX = sip.subMapX(kDataLink);
				mapX.removeAt("Masterpanel", false);
				sip.setSubMapX(kDataLink,mapX);

				//child.transformBy(-vecX * dX);
				continue;
			}
		}
	//End Validate and/or rotate childs alignment if width is not matching//endregion 

	//region Collect the style and the (total) area of this style
		{
			String styleName = sip.style();
			int n = sStyleNames.find(styleName);
			if(n<0)
			{
				sStyleNames.append(styleName);
				dStyleAreas.append(ppChild.area());
			}
			else	
			{
				dStyleAreas[n]+=ppChild.area();
			}
		}			
	//End Collect the style and the (total) area of this style//endregion 

	}
	int bIgnoreThicknessWarning=_Map.getInt("IgnoreThicknessWarning");
	if(!bConsistentThickness)
	{ 
	//region Trigger Ignore thickness warning
		String sTriggerIgnoreThicknessWarning = T("|Ignore thickness warning|");
		if(bIgnoreThicknessWarning)
			sTriggerIgnoreThicknessWarning= T("|Don't ignore thickness warning|");
		addRecalcTrigger(_kContext,sTriggerIgnoreThicknessWarning );
		if (_bOnRecalc && _kExecuteKey==sTriggerIgnoreThicknessWarning)
		{
			_Map.setInt("IgnoreThicknessWarning",!_Map.getInt("IgnoreThicknessWarning"));
			setExecutionLoops(2);
			return;
		}//endregion	
	}
	// HSB-22579
	if(!bConsistentThickness && !bIgnoreThicknessWarning)
	{ 
		reportNotice(TN("***** |Warning Masterpanel|: ") +master.formatObject("@(Number) ***** \n"
		)+TN("|Inconsistent thickness|")+": "+T("|There are childpanels with different thicknesses|"));
		reportNotice("\n");
	}
//region Draw potential flip failures and throw warning message
	if (cltFlipFailures.length()>0)
	{ 
		Display dpErr(1);
		// Make-762 for display in client make and hsbView
		dpErr.showInDxa(true);
		Plane pn(_PtW, _ZW);
		
		reportNotice(TN("***** |Warning Masterpanel|: ") +master.formatObject("@(Number) ***** \n")+cltFlipFailures.length()+ T(" |child panels could not be flipped| ")+
		TN("|Please review the model of the listed panels and endeavor to replace bevel definitions\nthat cannot be projected to the opposite side through static cuts.|"));
		for (int i=0;i<cltFlipFailures.length();i++) 
		{
			reportNotice(TN("|Pos| ") +cltFlipFailures[i].formatObject("@(Posnum), @(Name)")); 
			dpErr.draw(bdFlipFailures[i].shadowProfile(pn), _kDrawFilled, 20);
			dpErr.draw(bdFlipFailures[i]);
		}
		reportNotice("\n");
	}	
//endregion 




//region Draw relation if toggled
	if (bShowRelation)
	{ 
		Entity ents[] = _Map.getEntityArray("Trace[]","","Trace");
		if (ents.length() < 1)
		{ 
			for (int i=0;i<childs.length();i++)
				ents.append(childs[i]);
		}

		for (int i=0;i<ents.length();i++) 
		{ 
			ChildPanel c= (ChildPanel)ents[i]; 
			if ( !c.bIsValid())continue;
			Sip s = c.sipEntity();
			
			Point3d pts[0];
			Point3d ptA=s.ptCen(), ptB=s.ptCen(), ptB2=ptB+s.vecZ()*s.dH()*2, ptC;
			ptA.transformBy(c.sipToMeTransformation());
			pts.append(ptA);
			ptC = (ptA + ptB2) / 2;ptC.vis(2);
			double dX=_XW.dotProduct(ptA - ptC);
			double dY =_XW.dotProduct(ptA - ptC);
			double dZ =_ZW.dotProduct(ptA - ptC);
			pts.append(ptC + _XW*dX+_ZW*dZ);
			
			if (abs(dZ)>0)
			{
				pts.append(pts.last()-_ZW*dZ);
				pts.append(pts.last()-_XW*2*dX);
				pts.append(pts.last()-_ZW*dZ);	
			}
			pts.append(ptB2);
			pts.append(ptB);
			
			Display dpTrace(0);
			// Make-762
			dpTrace.showInDxa(true);
			for (int j=0;j<pts.length()-1;j++) 
			{ 
				dpTrace.color(i % 10);
				dpTrace.draw(PLine(pts[j], pts[j+1]));	
				 
			}//next j
		}//next i
	}		
//End Draw relation if toggled//endregion 		
	

	
// HSB-16247 set surface quality style to max detected
	if (surfaceQualityStyleBottom.bIsValid() && surfaceQualityStyleBottom.quality()>  SurfaceQualityStyle(master.surfaceQualityOverrideBottom()).quality())
	{
		master.setSurfaceQualityOverrideBottom(surfaceQualityStyleBottom.entryName());	
		//reportMessage(TN("|Surface Quality on Bottom Side has been auto corrected to| ") + surfaceQualityStyleBottom.entryName());
	}
	if (surfaceQualityStyleTop.bIsValid() && surfaceQualityStyleTop.quality()> SurfaceQualityStyle(master.surfaceQualityOverrideTop()).quality())
	{
		master.setSurfaceQualityOverrideTop(surfaceQualityStyleTop.entryName());
		//reportMessage(TN("|Surface Quality on Top Side has been auto corrected to| ") + surfaceQualityStyleTop.entryName() );
	}
	
	
	


	// HSB-10011# V8.6 Remove master if no childs exist
	if(childs.length() < 1 && bNest && nNesterType>-1) // HSB-16985 && bNest
	{
		master.dbErase();
		eraseInstance();
		return;
	}
	// Restart Tsl if child has been transformed (rotated)
	if(bRestartWhenChildsTransformed)
	{
		setExecutionLoops(2);
		return;
	}
	
//End Collect data and profiles of childs//endregion 


//region Styles
// set masters surface quality style
	if(bNest || _kNameLastChangedProp==sFaceAlignmentName)
	{
		if(bDebug)reportMessage("\n	setting masters surface qualities during " + (bNest?"nesting":"swapping alignment"));

	// set surface quality style to max detected
		if (surfaceQualityStyleBottom.bIsValid())
			master.setSurfaceQualityOverrideBottom(surfaceQualityStyleBottom.entryName());	
		if (surfaceQualityStyleTop.bIsValid())
			master.setSurfaceQualityOverrideTop(surfaceQualityStyleTop.entryName());	
	}

// get main style name
	String styleName;
	if (sStyleNames.length()==1)
		styleName=sStyleNames.first();
	else
	{
		for(int i=0;i<dStyleAreas.length();i++)
			for(int j=0;j<dStyleAreas.length()-1;j++)
				if(dStyleAreas[j]<dStyleAreas[j+1])
				{
					dStyleAreas.swap(j,j+1);
					sStyleNames.swap(j,j+1);	
				}
		if (sStyleNames.length()>0)
			styleName=sStyleNames[0];
	}
	
	
//region IsotropicPanelStyle
	int bIsotropicPanelStyle;
	if (sMasterStyleDelimiter.length()>0 && (sLengthWiseKey.length()>0 || sCrossWiseKey.length()>0))
	{ 
		int bLengthWise = styleName.find(sMasterStyleDelimiter + sLengthWiseKey, 0, false)>0;
		int bCrossWise = styleName.find(sMasterStyleDelimiter + sCrossWiseKey, 0, false)>0;
		if (!bLengthWise && !bCrossWise)
			bIsotropicPanelStyle = true;
	}

	// if IsotropicPanelStyle is true, the name to be used for the masterpanel style will consider the specified key to distinguish masterpanel styles if the panel styles are uniform
	// the masterpanel style will be derived from the panel style, but will append the commonly agreed abreviation for length and cross wise	
	String styleNameMaster = styleName;
	if (bIsotropicPanelStyle)
	{
		styleNameMaster = "";		
		String tokens[] = styleName.tokenize(sMasterStyleDelimiter);
		String key = vecXGrainMaster.isParallelTo(_XW) ? sMasterStyleDelimiter+sLengthWiseKey : sMasterStyleDelimiter+sCrossWiseKey;
		for (int i=0;i<tokens.length();i++) 
		{ 
			styleNameMaster += (i>1?sMasterStyleDelimiter:"");
			styleNameMaster += (i==1?key:"")+tokens[i]; 			 
		}//next i			
	}	
//endregion 


	
	//region Import and/or set masterpanel style
	// HSB-22739 style assignment supported if nesting ist disabled
	if ((bNest || (nEvent == 0 && nNesterType==-1)) && styleNameMaster.length()>0) // || bDebug
	{
	// get external path to definition dwg
		String path = sMasterStyleDwgName;			
		
	// try to import masterpanel styles with identical naming convention as the sip style
		String err;
		if (path.length()>0)
			err = MasterPanelStyle().importFromDwg(path , styleNameMaster, false); 

	// all available masterpanel styles
		String sMasterStyles[] = MasterPanelStyle().getAllEntryNames();
		int nMasterStyle= sMasterStyles.findNoCase(styleNameMaster,-1);	
		if (nMasterStyle>-1)
			master.setStyle(styleNameMaster);
	// fall back to special naming convention if import failed
		else if (err!=styleNameMaster && styleNameMaster.length()>0 && childs.length()>0)	
		{
			MasterPanelStyle mps(styleNameMaster);
			mps.dbCreate(childs.first().sipEntity().dH());
			master.setStyle(mps.entryName());
		}// end if special import	
		else	
			master.setStyle(styleNameMaster);
	}//End Import and/or set masterpanel style//endregion 
		
//End Styles//endregion  
		
//region Read spacing from settings
	double dThisSpacing = dSpacing;
	if (dSpacing==0)
	{ 
		String k;
		double dThickness = MasterPanelStyle(master.style()).dThickness();
		Map mapSpacings = mapSetting.getMap("ChildPanel\\Spacing[]");
		for (int i=0;i<mapSpacings.length();i++) 
		{ 
			Map m = mapSpacings.getMap(i);
			double dZMin, dZMax, _dSpacing;
			k = "ZMin";	if (m.hasDouble(k)) dZMin = m.getDouble(k);
			k = "ZMax";	if (m.hasDouble(k)) dZMax = m.getDouble(k);
			k = "Spacing";	if (m.hasDouble(k)) _dSpacing = m.getDouble(k);
			
			if (abs(dZMin - dZMax) < dEps || _dSpacing==0)continue;
			
			if (dThickness>=dZMin && dThickness<=dZMax)
			{
				dThisSpacing = _dSpacing;
				break;
			}
		}//next i
	}
//End Read spacing from settings//endregion 




//region Nesting
	if(bNest)// || bDebug) 
	{	
		//if (bDebug)	reportNotice("\n"+_ThisInst.handle()+" start nesting...");
		
		if (_Grip.length() > 0)_Grip.setLength(0);
		
		
		
	// get all presorter instances
		Entity entPresorters[] = Group().collectEntities(true, TslInst(), _kModelSpace);
		TslInst tslPresorters[0];
		for (int i=0;i<entPresorters.length();i++) 
		{ 
			TslInst t= (TslInst)entPresorters[i];
			if (t.scriptName().find(sScriptnamePresorter, 0 ,- 1) >- 1)tslPresorters.append(t); 
		}//next i
		//if (bDebug)reportMessage("\n	"+tslPresorters.length() + " presorters found");

	// set nester data
		NesterData nd;
		nd.setAllowedRunTimeSeconds(dDuration); // seconds
		nd.setMinimumSpacing(dThisSpacing);
		nd.setGenerateDebugOutput(false);
		nd.setNesterToUse(nNesterType);		

	// construct a NesterCaller object adding masters and childs
		NesterCaller nester;
		for (int s=0; s<childs.length(); s++) 
		{
			PlaneProfile ppChild = ppChilds[s];	
			double dOversize = dOversizes.length() > s ? dOversizes[s] : 0;
			
		// ignore child oversize 
			LineSeg segChild = ppChild.extentInDir(_XW);
			double dY = abs(_YW.dotProduct(segChild.ptStart() - segChild.ptEnd()));
			Point3d ptMid = segChild.ptMid();
			CoordSys csChild = ppChild.coordSys();

			if (csChild.vecY().isParallelTo(_YW) && abs(dMaxWidth-dY+2*dOversize)<dEps) // HSB-9504 child panels would not add to master when oversize is used but single with would match
			{ 
				Point3d pt = ptMid+_YW*(.5*dY-dOversize);
				PlaneProfile ppSub; ppSub.createRectangle(LineSeg(pt - _XW * U(10e4), pt + _XW * U(10e4) + _YW * U(10e3)), _XW, _YW);
				ppChild.subtractProfile(ppSub);
	
				pt = ptMid-_YW*(.5*dY-dOversize);
				ppSub.createRectangle(LineSeg(pt - _XW * U(10e4), pt + _XW * U(10e4) - _YW * U(10e3)), _XW, _YW);
				ppChild.subtractProfile(ppSub);

				reportNotice("\n" +T("|Oversize ignored for single full width panel| (") +dOversize+ ")");				
			}
	
			if (bDebug)reportNotice("\n	child "+childs[s].handle()+" area " + ppChild.area());
				
			NesterChild nc(childs[s].handle(),ppChild);
			
//			if (bDebug)
//			{ 
//				PLine rings[] = ppChild.allRings(true,false);
//				for (int ss=0;ss<rings.length();ss++) 
//				{ 
//					EntPLine epl;
//					epl.dbCreate(rings[ss]);
//					epl.setColor(ss+1); 
//					 
//				}//next ss
//				
//			}
						
			nc.setNestInOpenings(bNestInOpening);
			
		// set roptation allowance	
			double dRotationAllowance = nNesterType == _kNTAutoNesterV5 ? 180 : 360;
			if (dRotationAllowance==180 && entRotatedChilds.find(childs[s])>-1)
			{ 
				reportMessage("\n	" + childs[s].handle() + " locked for roation.");
				dRotationAllowance = 360;
			}		
			nc.setRotationAllowance(dRotationAllowance);
			
			nester.addChild(nc);
		}			

	// add the master to the caller
		NesterMaster nm(master.handle(), ppMasterNet);
		nester.addMaster(nm);			

	// reporting 
	// user report
		int bShowLog = true;
		if (mapSetting.hasInt("ShowNestingReport"))// && !bDebug)
			bShowLog =mapSetting.getInt("ShowNestingReport");

		if(bShowLog)
		{
		// NesterCaller object content
			reportNotice("\n" +T("|Nesting master input|"));	
			for (int m=0; m<nester.masterCount(); m++) 
			{
				NesterMaster master = nester.masterAt(m);
				//if (bDebug)reportMessage("\n		Master "+m+" "+nester.masterOriginatorIdAt(m) + " == " + master.originatorId() );
				reportNotice("\n   " +T("|Masterpanel|") + " " + nester.masterOriginatorIdAt(m));				
			}
			reportNotice("\n     "+nester.childCount() +" " + T("|child panels to be nested into masters| (")  + nester.masterCount()+")");
			for (int c=0; c<nester.childCount(); c++) 
			{
				NesterChild nc = nester.childAt(c);
				if (bDebug)reportMessage("\n		Child "+c+" "+nester.childOriginatorIdAt(c) + " == " + nc.originatorId() + " rotationAllowance:"  + nc.rotationAllowance());
			}
		}// end if (report)

	// do the actual nesting
		int nSuccess;
		if (!bDebug)
		{ 
			nSuccess = nester.nest(nd, true);
			if (bDebug)reportMessage("\n	NestResult: "+nSuccess);
			if (nSuccess!=_kNROk) 
			{
				reportNotice("\n" + scriptName() + ": " + T("|Not possible to nest|"));
			// no dongle
				if (nSuccess==_kNRNoDongle)
				{
					reportNotice("\n" + sNesterType + ": " + T("|No dongle found.|"));
					reportNotice("\n" + T("|Make sure dongle is installed or try with another nester.|"));
					_Map.removeAt("callNester",true);
					
					// HSB-8512 store falg in MO to break creation of presorted groups
					MapObject moTemp(sDictionary,"temp");
					if (moTemp.bIsValid())
					{ 
						Map m = moTemp.map();
						m.setInt("NoDongle", true);
						moTemp.setMap(m);
						if (master.bIsValid())master.dbErase();
						eraseInstance();
					}
					
					
					
				}
			// not possible to nest: remove childs from _Entity	
				else
				{ 
					if (bDebug)reportNotice("\n	removig not possible childs");
				// remove any outside child which is in _Entity		
					for (int i=_Entity.length()-1;i>=0;i--)
					{
						ChildPanel child=(ChildPanel)_Entity[i];
						if (child.bIsValid())
						{
							if (bDebug) reportMessage("\nremoving child " + child.handle() + " panel " + child.sipEntity().posnum());
							_Entity.removeAt(i);
						}		
					}				
				}
				
				setExecutionLoops(2);
				return;
			}			
		}

	
	// collect some nesting results
		///master indices
		int nMasterIndices[] = nester.nesterMasterIndexes();	
		int nLeftOverChilds[] = nester.leftOverChildIndexes();
		int bMasterHasChilds;

		if(nMasterIndices.length()>0)
		{
			int nIndexMaster = nMasterIndices[0];
			int nChildIndices[] = nester.childListForMasterAt(nIndexMaster);
			bMasterHasChilds = nChildIndices.length()>0;

			if (bMasterHasChilds)
			{
				if(bShowLog)reportNotice("\n      "+nChildIndices.length() + " " + T("|child panels successfully nested|"));
				
				
			// remove from a potential presorter
			// loop presorters
				for (int d = 0; d < tslPresorters.length(); d++)
				{
					TslInst& t = tslPresorters[d];
					Entity ents[] = t.entity();
					Entity entRemovals[0];
					
					for (int c=nChildIndices.length()-1; c>=0 ; c--) 
					{
						Entity ent; 
						ent.setFromHandle(nester.childOriginatorIdAt(nChildIndices[c]));
						if (bDebug)reportMessage("\n		child " + ent.handle() + " assigned and searching for presorter link to masterpanel");
						if (ents.find(ent)>-1)
						{
							entRemovals.append(ent);
							nChildIndices.removeAt(c);
						}
					}
					
					if (entRemovals.length()>0)
					{ 
						if (bDebug)reportMessage("\n		removals (" + entRemovals.length()+ ") found for presorter " + t.handle());
						Map m= t.map();
						Map mapRemovals;
						for (int c=0; c<entRemovals.length(); c++)
							mapRemovals.appendEntity("RemoveEnt", entRemovals[c]);
						m.setMap("RemoveEnt[]", mapRemovals);
						t.setMap(m);
						t.transformBy(Vector3d(0, 0, 0));
					}
					
					if (nChildIndices.length() < 1)break;
				}//next d
			
	

				
			}
			else if(bShowLog)
				reportNotice("\n      "+ T("|No child panels nested!|"));
		}
		
	// in case of any left over child panels copy the master and assign the left over childs to it. make sure that the send in childs decrease at least by 1, unless we end in an infinte loop	
		if (nLeftOverChilds.length()>0 && bMasterHasChilds && nSuccess==_kNROk)
		{
			if(bShowLog)reportNotice("\n      "+nLeftOverChilds.length() + " " +T("|left over child panels in current nesting attempt|") + T(" |Grain direction set to| ")+sGrainType);
			//if (bDebug) reportMessage("\n\n		"+_ThisInst.handle() + " preparing nesting clone..");
		// prepare tsl cloning
		// declare the tsl props
			TslInst tslNew;
			Vector3d vecUcsX = vecX;
			Vector3d vecUcsY = vecY;
			GenBeam gbs[0];
			Entity ents[0];
			Point3d pts[]= {ptOrg};
			int nProps[] = {};
			double dProps[] = {dTxtH, dOversize,dChildTxtH, dDuration, dSpacing, dLength, dWidth};
			String sProps[] = {sGrainType, sFormat,sFaceAlignment,sSipFormat,sNestInOpening, sNesterType,sRule, sAutoSizeMode};//sRotation,
			Map mapTsl;
			String sScriptname = scriptName();	

		// transform the insert location to next row	
			pts[0].transformBy(-vecY*(dMaxWidth+dRowOffset));
	
			MapObject moTemp(sDictionary,"temp");
			if (moTemp.bIsValid())
			{
				Map map;
				map.setPoint3d("ptIns", pts[0]);
				moTemp.setMap(map);
			}

		// assign left over childs
			for (int c=0; c<nLeftOverChilds.length(); c++) 
			{
				Entity ent; 
				ent.setFromHandle(nester.childOriginatorIdAt(nLeftOverChilds[c]));
				ents.append(ent);
				if (bDebug) reportMessage("\n		child " + ent.handle() + " assigned to new masterpanel");
			}
			if(bShowLog)reportNotice("\n      "+ ents.length() + " " + T("|childpanels send to new nesting attempt|"));
			
			
		// create new instance with nesting flag set to true
			mapTsl.setInt("callNester", true);
			mapTsl.setInt("AutoSize", true);
			mapTsl.setInt("CreatePlotViewport",  HasActivePlotViewport(mapPlotViewports) && bAutoCreationPlotViewport);
			if (_Map.hasMap("SorterGroup[]"))mapTsl.setMap("SorterGroup[]", _Map.getMap("SorterGroup[]"));
			tslNew.dbCreate(scriptName(), vecUcsX ,vecUcsY,gbs, ents, pts, 
					nProps, dProps, sProps,_kModelSpace, mapTsl);
			//if (bDebug && tslNew.bIsValid()) reportMessage("\n" +tslNew.handle() + " was successfully created.");	
		}
	
	// report in debug
		if (bDebug)
		{		
		// examine the nester result
			int leftOverMasterIndexes[] = nester.leftOverMasterIndexes();
			
			
			for (int m=0; m<leftOverMasterIndexes.length() ; m++) 
			{
				if (m==0)reportMessage("\n\n	Left over MasterList");
				reportMessage("\n		Master "+m+" "+nester.masterOriginatorIdAt(m));
			}
			
			for (int c=0; c<nLeftOverChilds.length(); c++) 
			{
				if (c==0) reportMessage("\n\n	Left over ChildList" );
				reportMessage("\n		Child "+c+" "+nester.childOriginatorIdAt(c));
			}		
		}// end if (bDebug)
		
	// loop over the nester masters
		for (int m=0; m<nMasterIndices.length(); m++) 
		{
			int nIndexMaster = nMasterIndices[m];
			//if (bDebug)reportMessage("\nResult "+nIndexMaster +": "+nester.masterOriginatorIdAt(nIndexMaster) );
			
			int nChildIndices[] = nester.childListForMasterAt(nIndexMaster);
			CoordSys csWorldXformIntoMasters[] = nester.childWorldXformIntoMasterAt(nIndexMaster);//
			if (nChildIndices.length()!=csWorldXformIntoMasters.length()) 
			{
				reportNotice("\n" + scriptName()+": " + T("|The nesting result is invalid!|"));
				break;
			}
			
		// locate the childs within the master
			for (int c=0; c<nChildIndices.length(); c++) 
			{
				int nIndexChild = nChildIndices[c];
				String strChild = nester.childOriginatorIdAt(nIndexChild);
				Entity ent; ent.setFromHandle(strChild);
				
				CoordSys cs = csWorldXformIntoMasters[c];
				if (bDebug)reportMessage("\n		Child "+nIndexChild+" "+strChild + " cs-det= " + cs.det());				

				ent.transformBy(cs);	
			}
		}	
	
	// remove a potential flag to call the nester
		_Map.removeAt("callNester", true);		

	// flag to optimize master panel size
		_Map.setInt("AutoSize", bAutoSize); // HSB-16897

	// collect childs for automatic edge alignment
		if (bEdgeAlignment)
		{
			Entity ents[0];
			for (int i=0;i<childs.length();i++) ents.append(childs[i]); 
			_Map.setEntityArray(ents,false,"EdgeAlignment[]","","EdgeAlignment");
		}

	// cleanup empty master
		if (nMasterIndices.length()<1 && master.nestedChildPanels().length()<1 && nLeftOverChilds.length()>0)
		{ 
			String sMsg=T("|Could not nest remaining child panels into master| (") + nLeftOverChilds.length()+")";
			
			if(bShowLog)reportNotice("\n      "+sMsg);
			reportMessage("\n" + sMsg);
			//master.dbErase();
			
		
		// create TSL
			TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
			GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0-_XW*U(1000)+_YW*dMaxWidth};
			int nProps[]={};			double dProps[]={};				
			//dProps[] = {dTxtH, dOversize,dChildTxtH, dDuration, dSpacing, dLength, dWidth};
			String sProps[]={sRule,sFaceAlignment, sSipFormat};
			Map mapTsl;	
			
			for (int i=0;i<nLeftOverChilds.length();i++) 
			{ 
				int nIndexChild = nLeftOverChilds[i]; 
				String strChild = nester.childOriginatorIdAt(nIndexChild);
				Entity ent; ent.setFromHandle(strChild);
				if (ent.bIsValid())
					entsTsl.append(ent);
			}

		}

		if(bDebug)reportMessage("\n	End of nesting...restart execution");
		setExecutionLoops(2);
		return;
	}// END IF nest action_____________________________________________________nest action
		
//End Nesting//endregion 


//region Displays


// order alphabetically
	int bHasXRef,bHasDuplicates[childs.length()]; // a flag which indicates if a child appears to be duplicated (xref without flattening)
	{
		Sip sips[0];
		String uids[0];
		for (int i=0;i<childs.length();i++)
		{
			Sip s = childs[i].sipEntity();
			sips.append(s);
			
			String uid = s.uniqueId();
			Entity entXRef= s.blockRef();
			if (entXRef.bIsValid())
			{ 
				_Entity.append(entXRef);
				setDependencyOnEntity(entXRef);
				
				
				Map mapXRef = entXRef.subMapX("hsb_XRefContent");
				for (int r=0;r<mapXRef.length();r++) 
				{ 
					Map mapContent = mapXRef.getMap(r); 
					if (mapContent.getEntity("XRefEntity")==s)
					{ 
						bHasXRef = true; // flag if XRefContent Data has been found
						Map m = mapContent.getMap("EntityProperties");
						for (int jj=0;jj<m.length();jj++) 
						{ 
							String key = m.keyAt(jj);
							
							if (m.hasString(jj))
								uid += "_"+key + "_" + m.getString(jj);
							else if (m.hasDouble(jj))
								uid += "_"+key + "_" + m.getDouble(jj);
							else if (m.hasInt(jj))
								uid += "_"+key + "_" + m.getInt(jj);							
						}//next jj
						break;
					}			 
				}//next j
				
			}
			uids.append(uid);
		}
		
	// order by extended UID	
		for (int i=0;i<uids.length();i++) 
			for (int j=0;j<uids.length()-1;j++) 
				if (uids[j]>uids[j+1])
				{
					uids.swap(j, j + 1);
					sips.swap(j, j + 1);
					childs.swap(j, j + 1);
					sQualityDescriptions.swap(j, j + 1);//HSB-21898 description order fixed
					ppChilds.swap(j, j + 1);//HSB-21898
					ppBoxChilds.swap(j, j + 1);//HSB-21898
					ppOutterContourChilds.swap(j, j + 1);// HSB-24434
					
				}
		for (int i=0;i<sips.length()-1;i++) 
			if (uids[i] == uids[i + 1])
			{
				bHasDuplicates[i] = true;
				bHasDuplicates[i+1] = true;
			}
	}




// child panels
	Map mapAdditionalChild;
	PlaneProfile ppHatch, ppOversizes[0];
	double dNetArea; // area of all childs

	int nDefaultColor=234;
	Display dpWhite(-1),dp(nDefaultColor), dpChild(nColorChildOutline),dpChildText(nColorChildText), dpWarning(nColorInterfere);
	dp.dimStyle(sDimStyle);
	dp.textHeight(dTxtH);
	dp.addHideDirection(_XW);
	dp.addHideDirection(-_XW);
	dp.addHideDirection(_YW);
	dp.addHideDirection(-_YW);
	dp.showInDxa(true);// Make-762
	
	dpChild.lineType(sLineType);
	dpChild.addHideDirection(_XW);
	dpChild.addHideDirection(-_XW);
	dpChild.addHideDirection(_YW);
	dpChild.addHideDirection(-_YW);
	dpChild.showInDxa(true);// Make-762
	
	dpChildText.dimStyle(sDimStyleChild);
	dpChildText.addHideDirection(_XW);
	dpChildText.addHideDirection(-_XW);
	dpChildText.addHideDirection(_YW);
	dpChildText.addHideDirection(-_YW);
	dpChildText.showInDxa(true);// Make-762
	
	dpWhite.trueColor(rgb(255, 255, 254), nTransparencyChild);
//	dpWhite.addHideDirection(_XW);
//	dpWhite.addHideDirection(-_XW);
//	dpWhite.addHideDirection(_YW);
//	dpWhite.addHideDirection(-_YW);	
	dpWhite.addViewDirection(_ZW);
	dpWhite.showInDxa(true);// Make-762
	
	if (dTxtH>0 && dTextHeightHeader<=0)
		dTextHeightHeader = dTxtH;
	
	
	int nPackageColors[0]; // a collector of package indices in use		
//End Displays//endregion 

//region Loop childs for display
	Map mapAddPanel;
	Sip sipFormatRef;
	for (int i=0;i<childs.length();i++)
	{
		mapAddPanel = Map();
		dpChildText.color(nColorChildText);
		dpChildText.textHeight(dChildTxtH);
		String sQualityDescription = sQualityDescriptions.length() > i ? sQualityDescriptions[i] : ""; // HSB-17748 prevent potential range errors

	// get sip and it's transformation			
		ChildPanel child = childs[i];
		int bIsFlipped = child.bIsFlipped();
		Vector3d vecXGrainMasterChild = child.woodGrainDirection();
		Sip sip = child.sipEntity();
		if (!sip.bIsValid())continue;
		
		if (!sipFormatRef.bIsValid())
			sipFormatRef = sip;
			
		SipStyle style(sip.style());
		Map mapSip = sip.subMap("ExtendedProperties");
		Map mapX = sip.subMapX(kDataLink);// HSB-20754
		Element el = sip.element();

		
	// get a potential freight item and package link // HSB-21255
		TslInst freightItem, freightPackage, tslRequests[0];
		
		// get freight link fom potential parent element
		if (el.bIsValid())	
		{ 
			Map m = el.subMapX(kDataLink);
			Entity e;
			e = m.getEntity("hsbFreight-Item");
			freightItem = (TslInst)e;
			e =  m.getEntity("hsbFreight-Package");	
			freightPackage = (TslInst)e;			
		}
		
		// get from linked tsls
		{
			Entity entTools[]= sip.eToolsConnected();	
			for(int t=0;t<entTools.length();t++)
			{
				TslInst tsl = (TslInst)entTools[t];
				if (!tsl.bIsValid())continue;
				//reportNotice("\nscript " + tsl.scriptName());
				Map m = tsl.map();
				if (!freightItem.bIsValid() && m.getInt("isFreightItem") )	
				{
					freightItem=tsl;
				}
				else if (m.hasMap("DimRequest[]"))
				{ 
					tslRequests.append(tsl);
				}
			}

		// get potential parent package	
			if (freightItem.bIsValid() && !freightPackage.bIsValid())
			{
				Map mapX = freightItem.subMapX("Hsb_PackageChild");
				freightPackage.setFromHandle(mapX.getString("ParentUID"));		
			}
		}
		//if (bDebug)reportMessage("\nPanel" + " " + sip.posnum() + " " + sip.name() + " is assigned to package " + freightPackage.color() );

	// change display color if color mapping exists and a freight package associated
		if (freightPackage.bIsValid() && mapSetting2.hasMap("Color[]"))
		{
			Map	map = mapSetting2.getMap("Color[]");
			String key = freightPackage.color();
			if (map.hasInt(key))
				dpChildText.color(map.getInt(key));//HSB-18167
			else
				reportMessage("\n" + scriptName() + ": " +T("|The color map does not contain the requested color code|") + " " + key+". " + T("|Default color will be used.|"));
			// remove comments to reactivate circles of package display
			//if (nPackageColors.find(c)<0)
				//nPackageColors.append(c);
		}

	// transform to child
		CoordSys sip2child;
		sip2child=child.sipToMeTransformation();
		Point3d ptCen = sip.ptCenSolid();
		ptCen.transformBy(sip2child);

		PLine plEnvelope=sip.plEnvelope();
		plEnvelope.transformBy(sip2child);

		PlaneProfile ppOpening(sip.coordSys());
		PLine plOpenings[] = sip.plOpenings();
		for (int j=0;j<plOpenings.length();j++) 
			ppOpening.joinRing(plOpenings[j], _kAdd); 
		ppOpening.transformBy(sip2child);
		//{ Display dpx(150); dpx.draw(ppOpening,_kDrawFilled, 40);}

	//region draw dimrequests
		for (int j=0;j<tslRequests.length();j++) 
		{ 
			Map mapRequests= tslRequests[j].map().getMap("DimRequest[]");
			for (int k=0;k<mapRequests.length();k++) 
			{ 
				Map m= mapRequests.getMap(k);
				if (m.hasPLine("pline") && m.hasDouble("dZ"))
				{ 
					m.transformBy(sip2child);
					Vector3d vecZView = m.getVector3d("AllowedView");
					int nc = vecZView.isCodirectionalTo(_ZW)?3:1;
					Display dpr(nc);
					PLine pl = m.getPLine("pline");
					PlaneProfile pp(pl);
					pp.intersectWith(PlaneProfile(plEnvelope));
					dpr.draw(pp, _kDrawFilled, 70);
					
					PLine plRings[] = pp.allRings(true, false);
					if (plRings.length()>0)
						dpr.draw(Body(plRings[0], vecZView * m.getDouble("dZ") ,- 1));
				}
			}//next k 
		}//next j
	//End draw dimrequests//endregion 

	//region format resolving
		mapAddPanel.setString("SurfaceQualityTop", sip.formatObject("@(SurfaceQualityTopStyle)")); // legacy
		mapAddPanel.setString("SurfaceQualityBottom", sip.formatObject("@(SurfaceQualityBottomStyle)"));// legacy
		mapAddPanel.setString("GrainDirectionText", vecXGrainMasterChild.isParallelTo(_XW) ? T("|Lengthwise|") : T("|Crosswise|"));
		mapAddPanel.setString("GrainDirectionTextShort", vecXGrainMasterChild.isParallelTo(_XW) ?T("|Grain LW|") : T("|Grain CW|"));	
		mapAddPanel.setString("SurfaceQuality",  sQualityDescription);
		mapAddPanel.setString("Quality",  sQualityDescription);// legacy
		
	// override if XRef property found
		Entity entXRef= sip.blockRef();
		if (entXRef.bIsValid())
		{ 
			Map mapXRef = entXRef.subMapX("hsb_XRefContent");
			for (int j=0;j<mapXRef.length();j++) 
			{ 
				Map mapContent = mapXRef.getMap(j); 
				if (mapContent.getEntity("XRefEntity")==sip)
				{ 
					Map m = mapContent.getMap("EntityProperties");
					for (int jj=0;jj<m.length();jj++) 
					{ 
						String key = m.keyAt(jj);
						
						if (m.hasString(jj))
							mapAddPanel.setString(key, m.getString(jj));
						else if (m.hasDouble(jj))
							mapAddPanel.setDouble(key, m.getDouble(jj));
						else if (m.hasInt(jj))
							mapAddPanel.setInt(key, m.getInt(jj));							
					}//next jj
					
					break;
				}
				 
			}//next j
			
		}

		String kGrainDirection = "@(GrainDirection";
		int nRowGrain, bDrawGrain = sSipFormat.find(kGrainDirection, 0, false)>-1;
		String formatSip = sSipFormat;
		
		int nColorGrain = nColorChildText, nColorCW = nColorGrain, nColorLW = nColorGrain;
		if (bDrawGrain)
		{ 
			int n0 = sSipFormat.find(kGrainDirection, 0, false);
			int n1 = sSipFormat.find(")", n0, false)+1;
			String var = sSipFormat.right(sSipFormat.length()-n0).left(n1-n0);
			formatSip.replace(var, " ");
			
		// find color arguments: if color is given as argument use it for the grain direction, i.e. @(GrainDirection:CW3:LW1)
			String tokens[] = var.tokenize(":");
			for (int i=0;i<tokens.length();i++) 
			{ 
				String L = tokens[i].left(2).makeUpper();
				String R = tokens[i].right(tokens[i].length()-2);
				int color = R.atoi();
				if (L == "CW")nColorCW = color;
				else if (L == "LW")nColorLW = color; 
			}//next i

			//String test = sip.formatObject(sSipFormat, mapAddPanel);			
			int n2 = sSipFormat.find(kGrainDirection, 0, false);
			
			
			for (int i=0;i<n2;i++) 
			{ 
				int nxn=sSipFormat.find("\n", i, false);
				int nxp=sSipFormat.find("\\P", i, false);
				int nx =-1;
				if (nxn >- 1)nx = nxn;
				if (nxp >- 1 && nxp<nxn)nx = nxp;
				
				if (nx>0)
				{ 
					i=nx+1;
					nRowGrain++;
				}
			}//next i	
		}
		String sTextFormatSip = sip.formatObject(formatSip, mapAddPanel);
		
		
		
		Point3d ptTag = ptCen;
		int nGrip = GetGripByName(_Grip, "Tag_" + sip.handle());
		if (nGrip>-1)
			ptTag = _Grip[nGrip].ptLoc();
		ptTag.setZ(0);
		Point3d ptLocGrain = ptTag;
		
		PlaneProfile ppTextSip(CoordSys(ptTag, _XW,_YW,_ZW));
		int numRow = GetTextBox(dpChildText, sTextFormatSip, dChildTxtH, sDimStyleChild, ppTextSip);
		
		if (bDrawGrain)
		{ 
			double dY = (.5 * numRow - nRowGrain)*dChildTxtH*1.5-.75*dChildTxtH;
			ptLocGrain += _YW * dY;
		}
		
		//ppTextSip.vis(6);

		mapX.setEntity("Masterpanel", master);
		sip.setSubMapX(kDataLink, mapX);
	//End format resolving//endregion 	

	//region Collision / Leader Check
		PlaneProfile ppEnv(CoordSys());
		ppEnv.joinRing(plEnvelope,_kAdd);
		ppEnv.subtractProfile(ppOpening);
		
		if (nGrip<0)
		{ 
				
			if (ProfileHasIntersection(ppTextSip, ppOpening))
			{ 
				
			// first attempt: move outside opening	
				Vector3d vecMove;
				vecMove = GetClosestLocation(ppTextSip, ppOpening, dChildTxtH*1, true);
				PlaneProfile ppTest = ppTextSip;
				ppTest.transformBy(vecMove);
				//ppTest.vis(60);
					
			
			// second attempt: try to find a location within void	
				if (ProfileHasIntersection(ppTest, ppOpening))
				{ 
					double dMin = ppTest.dX() > ppTest.dY() ? ppTest.dX() : ppTest.dY();
					PlaneProfile ppShrink=ppEnv;
					ppShrink.subtractProfile(ppOpening);
					ppShrink.shrink(.5 * dMin);//+dChildTxtH);
					ppShrink.shrink(-.5* dMin);
	
					if (ppShrink.area()>pow(U(1),2))
					{
						vecMove = GetClosestLocation(ppTextSip, ppShrink, dChildTxtH, false);
						ppTest = ppTextSip;
						ppTest.transformBy(vecMove);
						
						if (ProfileHasIntersection(ppTest, ppOpening))
						{ 
							vecMove -= GetClosestLocation(ppTest, ppShrink, dChildTxtH, false);
							ppTest = ppTextSip;
							ppTest.transformBy(vecMove);
						}	
	//					{ Display dpx(150); dpx.draw(ppShrink,_kDrawFilled, 40);}	
	//					{ Display dpx(3); dpx.draw(ppTest,_kDrawFilled, 10);}	
					}
	
				}

			// third attempt: iterate through potential solutions HSB-22644
				if (!ProfileHasIntersection(ppTest, ppEnv))
				{ 
					double delta = dChildTxtH > 0 ? dChildTxtH : U(20);
					double dxTag = ppTextSip.dX();
					double dyTag = ppTextSip.dY();
					double dx = (ppEnv.dX()-dxTag)*.5;
					double dy = (ppEnv.dY()-dyTag)*.5;
					int numX = dx / delta+1;
					int numY = dy / delta+1;
					
					int bOk;
					for (int ix=0;ix<numX;ix++) 
					{
						for (int iy=0;iy<numY;iy++) 
						{ 
							ppTest = ppTextSip;
							vecMove = vecX * ix * delta + vecY * iy * delta;
							ppTest.transformBy(vecMove);
							if (!ProfileHasIntersection(ppTest, ppOpening) && ProfileHasIntersection(ppTest, ppEnv))
							{ 
								//ppTest.vis(3);
								bOk = true;
							}
//							else ppTest.vis(12);
							if (bOk)break; 
							
							ppTest = ppTextSip;
							vecMove = -vecX * ix * delta - vecY * iy * delta;
							ppTest.transformBy(vecMove);
							if (!ProfileHasIntersection(ppTest, ppOpening) && ProfileHasIntersection(ppTest, ppEnv))
							{ 
								//ppTest.vis(3);
								bOk = true;
							}
//							else ppTest.vis(12);
							if (bOk)break; 							

						}//next ix	
						if (bOk)break;
					}	
				}
		
			// move to new location
				if (!ProfileHasIntersection(ppTest, ppOpening) && ProfileHasIntersection(ppTest, ppEnv)) // avoid loctaion outside HSB-22644
				{ 					
					ppTextSip.transformBy(vecMove);
					ptLocGrain.transformBy(vecMove);
					ptTag.transformBy(vecMove);
				}
	
			}
			else if (TagCoversChild(ppTextSip, ppEnv))
			{ 
				;//if (bDebug){ Display dpx(12); dpx.draw(ppTextSip,_kDrawFilled, 10);}
			}
			else if (TagOverlapsChild(ppTextSip, ppEnv))
			{ 
				PlaneProfile ppTest = ppTextSip;
				Vector3d vecMove= -1*GetClosestLocation(ppTextSip, ppEnv, dChildTxtH, false);
				ppTest = ppTextSip;
				ppTest.transformBy(vecMove);
				if (ProfileHasIntersection(ppTest, ppEnv))
				{ 
					ppTextSip.transformBy(vecMove);
					ptLocGrain.transformBy(vecMove);
					ptTag.transformBy(vecMove);				
				}
//				else if (bDebug)
//				{
//					Display dpx(6); 
//					dpx.draw(ppEnv,_kDrawFilled, 40);					
//				}
	
			}
		// valid location	
//			else if (bDebug)
//			{ 
//				{ Display dpx(3); dpx.draw(ppTextSip,_kDrawFilled, 40);}
//			}
			
		
		//region Add Grip
			if (bTagGrips)
			{ 
				
				Grip g;
				g.setName("Tag_"+sip.handle());
				g.setPtLoc(ptTag);
				g.setVecX(_XW);
				g.setVecY(_YW);
				g.addViewDirection(_ZW);
				g.setColor(40);
				g.setShapeType(_kGSTCircle);				
				g.setToolTip(T("|Moves the tag of the childpanel|"));	
				
				_Grip.append(g);
				nGrip = _Grip.length() - 1;
				
			}
		//endregion 
			
			
			
			
			
		}
		
		
	// Draw Leader	
		if (nGrip>-1 && ppEnv.pointInProfile(ptTag)==_kPointOutsideProfile )// )&& !TagOverlapsChild(ppTextSip, ppEnv)
		{ 
			Point3d ptm1 = ppEnv.ptMid();
			double dx = ppTextSip.dX();
			double dy = ppTextSip.dY();
	
			Vector3d vec12 = ptm1-ptTag ; vec12.normalize();
	
			double dx1 = _XW.dotProduct(vec12);
			double dy1 = _YW.dotProduct(vec12);			
			Vector3d vecX1 = dx1 > 0 ? _XW :- _XW;
			Vector3d vecY1 = dy1 > 0 ? _YW :- _YW;			

			PLine plLeader(_ZW);
			Point3d pt = ppTextSip.closestPointTo(_Grip[nGrip].ptLoc());
			vecX1.vis(pt, 1);
			if (abs(dx1)>abs(dy1) )//&& abs(dx1)>dChildTxtH)
			{
				pt = ptTag + .5 * vecX1*dx;
				plLeader.addVertex(pt);
				pt += vecX1*dChildTxtH;
				plLeader.addVertex(pt);	
			}
			else
			{
				pt = ptTag + .5 * vecY1*dy;
				plLeader.addVertex(pt);
				pt += vecY1*dChildTxtH;
				plLeader.addVertex(pt);	
			}
			if (plLeader.length()>dEps)
			{
				pt = ppEnv.closestPointTo(pt);
				plLeader.addVertex(pt);
			}
			dpChildText.draw(plLeader);
			PLine circle; circle.createCircle(pt, _ZW, .05 * dChildTxtH);
			dpWhite.draw(PlaneProfile(circle), _kDrawFilled, 70);
			dpChildText.draw(PlaneProfile(circle));
			
			plLeader.vis(2);
			
		}
//		
		
	//endregion 






	//region draw per child
	
		//region draw alert of non matching child panels
		int bStyleMatch = sip.style()==styleName;
		// get child's grain direction and make sure it aligns with the masters grain direction		
		if (!bStyleMatch || vecXGrainMasterChild.bIsZeroLength() || !vecXGrainMasterChild.isParallelTo(vecXGrainMaster))
		{
			dpChildText.color(1);	
			dpChildText.textHeight(dChildTxtH*1.5);
		}
		else
			dpChildText.textHeight(dChildTxtH);
		dpChildText.draw(sTextFormatSip, ptTag, vecX, vecY,0, 0); 
		if (nTransparencyChild>0 && nTransparencyChild<100)
		{
			dpWhite.draw(ppTextSip,_kDrawFilled);
			dpChildText.draw(ppTextSip);
		}
		
		//endregion 
	
		//region draw grain direction
		double dGrainHeight;
		if (bDrawGrain)
		{ 
			int nAssociation = mapSip.getInt("IsFloor")?1:0;// 1 = floor, 0 = wall
			
			// the grain direction is visualized by a pline symbol or by custom defined blocks. blocks have to be named'hsbGrainDirectionFloor' or 'hsbGrainDirectionWall'
			String sAssociationBlockName = sAssociationBlockNames[nAssociation];
			int bDrawBlock;
			double dBlockScaleFactor = 1;
			for (int i=0;i<_BlockNames.length();i++) 
			{ 
				String sBlockName = _BlockNames[i]; 
				bDrawBlock = sAssociationBlockName.makeLower() == sBlockName.makeLower();
				if (bDrawBlock)break;
			}

			double dLL = dTxtH * 4;
			if (bDrawBlock)
			{
				Block block(sAssociationBlockName);
				
			// scale to size
				LineSeg seg = block.getExtents();
				double dX = abs(_XW.dotProduct(seg.ptStart() - seg.ptEnd()));
				dGrainHeight = abs(_YW.dotProduct(seg.ptStart() - seg.ptEnd()));

				if (dX<=dEps)bDrawBlock = false;
				dBlockScaleFactor = dLL / dX;			
				Vector3d vecXB = vecXGrainMasterChild * dBlockScaleFactor;
				Vector3d vecYB = vecXGrainMasterChild.crossProduct(_ZW) * dBlockScaleFactor;
				Vector3d vecZB = vecXB.crossProduct(vecYB);
				dpChildText.draw(Block(sAssociationBlockName), ptCen, vecXB, vecYB, vecZB);	
			}	
			else
			{ 
				ptLocGrain.setZ(0);
				PLine plArrow = GrainArrow(dChildTxtH, ptLocGrain, vecXGrainMasterChild);
				
				int c = nColorGrain;
				if (vecXGrainMaster.isParallelTo(_XW) && nColorLW!=nColorGrain)
				{ 
					dpChildText.color(nColorLW);
					
				}
				if (vecXGrainMaster.isParallelTo(_YW) && nColorCW!=nColorGrain)
				{ 
					dpChildText.color(nColorCW);
					
				}
				
				PLine pla = plArrow, plb = plArrow;
				pla.offset(-U(1), false);
				plb.offset(U(1), false);
				plb.reverse();
				pla.append(plb);
				pla.close();
				//pla.convertToLineApprox(dEps);
				
				dpChildText.draw(PlaneProfile(pla),_kDrawFilled);
				dpChildText.color(nColorChildText);
				//plArrow.vis(3);

			}
		}
		//End draw grain direction//endregion 
			
		//region draw feeding direction
		if (bAddFeedDirection && sip.subMapXKeys().findNoCase("CncData",-1)>-1) // HSB-19101 only accepted if explicitly defined		
		{	
			String k;
			//Point3d ptCen= sip.ptCen();
			Map m = sip.subMapX("CncData");
			Vector3d vecRefFeed= m.getVector3d("vecRefFeed");
			Vector3d vecRefSide= m.getVector3d("vecRefSide");
			vecRefFeed.normalize();
			vecRefFeed.transformBy(sip2child);
			vecRefFeed.normalize();

			vecRefSide.normalize();
			vecRefSide.transformBy(sip2child);
			vecRefSide.normalize();

		// find feed color if specified
			for (int j=0;j<mapFeedDirections.length();j++) 
			{ 	
				Map mapFeed = mapFeedDirections.getMap(j);
				Vector3d x = mapFeed.getVector3d("X");
				Vector3d y = mapFeed.getVector3d("Y");
				if (x.isCodirectionalTo(vecRefFeed) && y.isCodirectionalTo(vecRefSide))
				{ 
					k = "Color"; if (mapFeed.hasInt(k))nFeedColor = mapFeed.getInt(k);
					k = "Text"; if (mapFeed.hasString(k))sFeedText= mapFeed.getString(k);
					break;
				}
				 
			}//next j

		// get boundings
			double dXTxt = dp.textLengthForStyle(sTextFormatSip, sDimStyle, dChildTxtH);
			double dYTxt = dp.textHeightForStyle(sTextFormatSip, sDimStyle, dChildTxtH);
			if (vecRefFeed.isParallelTo(vecY))
			{ 
				double d = dXTxt;
				dXTxt = dYTxt;
				dYTxt = d;
			}
			LineSeg segTxt(ptCen - .5 * (vecX * dXTxt + vecY * dYTxt), ptCen + .5 * (vecX * dXTxt + vecY * dYTxt));
			segTxt.vis(2);


		// draw
			PLine pl(vecZ);
			Point3d pts[0];
			Display dp(nFeedColor);
			Point3d pt = ptCen + vecRefFeed * .5*dXTxt + vecRefSide * .5*dYTxt;
	
		// draw feeding arrow	
			if (!m.hasVector3d("vecRefSide"))
			{ 
				Vector3d vecRefFeedY =vecRefFeed.crossProduct(-vecZ);	
				
				//vecRefFeed.vis(child.realBody().ptCen(),1);vecRefFeedY.vis(child.realBody().ptCen(),3);
				//Point3d pt = ptCen + .5*vecRefFeed*dGrainSize+_YW*U(200);
				pts.append(pt);
				pts.append(pts[pts.length()-1]-.25*(vecRefFeed-vecRefFeedY)*dGrainSize);
				pts.append(pts[pts.length()-1]-vecRefFeedY*.2*dGrainSize);
				pts.append(pts[pts.length()-1]-vecRefFeed*.75*dGrainSize);
				pts.append(pts[pts.length()-1]-vecRefFeedY*.1*dGrainSize);
				pts.append(pts[pts.length()-1]+vecRefFeed*.75*dGrainSize);
				pts.append(pts[pts.length()-1]-vecRefFeedY*.2*dGrainSize);
			
			}
			else if (_BlockNames.findNoCase(sFeedBlockName,-1)>-1)
			{ 
				//Point3d pt = ptCen + .5*vecRefFeed*dGrainSize+_YW*U(200);
				Block block(sFeedBlockName);
				dp.draw(block, pt, vecRefFeed, -vecRefSide, vecRefFeed.crossProduct(-vecRefSide));
				
			}
			else
			{ 
				double d = dGrainSize / 2;
				//Point3d pt = ptCen +vecRefFeed * dGrainSize+vecRefSide*U(400);
				pts.append(pt);
				pts.append(pt - vecRefFeed*d);
				
				pts.append(pt - (vecRefFeed+vecRefSide)*d/5);
				pts.append(pt - vecRefSide*d);
				
				if (bDebug)//HSB-21485
				{ 
					vecRefFeed.vis(pt, 1);
					vecRefSide.vis(pt, 3);
					Vector3d vecRefZ = vecRefFeed.crossProduct(vecRefSide);
					vecRefZ.vis(pt, 150);
					
					
					Vector3d vecXS = sip.vecX();
					Vector3d vecYS = sip.vecY();
					Vector3d vecZS = sip.vecZ();
					vecXS.transformBy(sip2child);
					vecYS.transformBy(sip2child);
					vecZS.transformBy(sip2child);
					
					vecXS.vis(pt, 12);
					vecYS.vis(pt, 82);
					vecZS.vis(pt, 152);					
				}


			}
			for(int i=0;i<pts.length();i++)
				pl.addVertex(pts[i]);
			pl.close();
			if (pl.area()>pow(dEps,2))
			{
				dp.draw(PlaneProfile(pl),_kDrawFilled);
				
				
			// highlight invalid feeding direction  HSB-21485
				Vector3d vecZS = sip.vecZ();
				SipEdge edges[] = sip.sipEdges();
				int bHasBevel;
				for (int i=0;i<edges.length();i++) 
				{ 
					SipEdge& e= edges[i]; 
					if (!e.vecNormal().isPerpendicularTo(vecZS))
					{ 
						bHasBevel = true;
						break;
					}
				}//next i

				Vector3d vecRefZ = vecRefFeed.crossProduct(vecRefSide);				
				vecZS.transformBy(sip2child);
				if (bHasBevel && !vecRefZ.isCodirectionalTo(vecZS))
				{ 
					PlaneProfile pp(pl);
					pp.createRectangle(pp.extentInDir(vecX), vecX, vecY);
					Display dpErr(1);
					dpErr.draw(pp,_kDrawFilled, 50);
				}
				
			}
		}		
		//endregion 
		
		//region draw tagged tool
		if (sip.subMapXKeys().find("CncToolTag") >- 1)
		{
			Map m = sip.subMapX("CncToolTag");
			int bOnRefSide= m.getInt("OnReferenceSide");
			int bOnRefSideThrough= m.getInt("OnReferenceSideThrough");
			Vector3d vecFace = bOnRefSide?- sip.vecZ():sip.vecZ();
			vecFace.transformBy(sip2child);
			//vecFace.vis(ptCen, bOnRefSide);
			
			PlaneProfile pp = sip.realBody().extractContactFaceInPlane(Plane(sip.ptCenSolid() + vecFace * .5 * sip.dH(), vecFace), dEps);
			pp.transformBy(sip2child);

		// if single side and through settings vary
			PLine plThroughs[0];
			if (bOnRefSide!=bOnRefSideThrough)
			{ 
				PLine plCirc;
				AnalysedTool tools[] = sip.analysedTools();
				AnalysedDrill drills[] = AnalysedDrill().filterToolsOfToolType(tools);
				for (int d=0;d<drills.length();d++)
					if (drills[d].bThrough())
					{ 
						Point3d pt = (drills[d].ptStartExtreme() + drills[d].ptEndExtreme()) * .5-vecFace*.5*drills[d].dDepth();
						plCirc.createCircle(pt, vecFace, drills[d].dDiameter()*.5);
						plCirc.transformBy(sip2child);
						plThroughs.append(plCirc);plCirc.vis(1);
					}
				AnalysedBeamCut beamcuts[] = AnalysedBeamCut().filterToolsOfToolType(tools);
				for (int d=0;d<beamcuts.length();d++)
				{
					AnalysedBeamCut& t = beamcuts[d];
					if (t.bIsFreeD(-t.vecSide()))
					{ 
						PlaneProfile ppt = t.cuttingBody().extractContactFaceInPlane(Plane(sip.ptCenSolid() - vecFace * .5 * sip.dH(), vecFace), dEps);
						ppt.transformBy(sip2child);//ppt.vis(4);
						plThroughs.append(ppt.allRings());
					}
				}	
			}

			PLine plRings[] = pp.allRings();
			int bIsOp[] = pp.ringIsOpening();
			pp.removeAllRings();
			for (int r=0;r<plRings.length();r++)
				if (bIsOp[r])
					pp.joinRing(plRings[r],_kAdd);	
			
		// remove any through
			PlaneProfile pp2;
			for (int r=0;r<plThroughs.length();r++)
			{
				pp.joinRing(plThroughs[r],_kSubtract);
				pp2.joinRing(plThroughs[r],_kAdd);
			}
			//pp.vis(6);
			
			Display dp(bOnRefSide?nColorTaggedRef:nColorTaggedOpp);
			dp.draw(pp,_kDrawFilled, nTransparencyTagged);	
			
			
		// display through if varying
			if (plThroughs.length()>0)
			{ 
				pp2.transformBy(vecZ * vecZ.dotProduct(plThroughs[0].coordSys().ptOrg() - pp2.coordSys().ptOrg()));
				Display dp2(bOnRefSideThrough?nColorTaggedRef:nColorTaggedOpp);
				dp2.draw(pp2,_kDrawFilled, nTransparencyTagged);		
			}
			
		}
		//End draw tagged tool//endregion 
	
		//region draw duplication warning
		if (bHasDuplicates[i])
		{ 
			double x = dpChildText.textLengthForStyle(sTextFormatSip, sDimStyleChild, dChildTxtH);
			double y = dpChildText.textHeightForStyle(sTextFormatSip, sDimStyleChild, dChildTxtH);
			Vector3d vec = .5 * (_XW * x + _YW * y);
			PLine pl; pl.createRectangle(LineSeg(ptCen-vec, ptCen+vec), _XW, _YW);
			pl.offset(-dChildTxtH, true);
	
			Display dpAlert(-1);
			dpAlert.trueColor(yellow,50);
			dpAlert.draw(pl);
			dpAlert.draw(PlaneProfile(pl), _kDrawFilled);
			
		}
		//endregion 
		//draw offseted profile of child // HSB-8219 draw only offsets !=0
			PlaneProfile ppChild = ppChilds[i];
			if (abs(dOversizes[i])>dEps)dpChild.draw(ppChild);
			ppOversizes.append(ppChild);						
	//End draw per child//endregion 

	}// next child	
	
// remove legacy keys from mapAdd	
	mapAddPanel.removeAt("surfaceQualityTop", true);
	mapAddPanel.removeAt("surfaceQualityBottom", true);
	mapAddPanel.removeAt("Quality", true);
	
	if (sipFormatRef.bIsValid())
		sSipFormat.setDefinesFormatting(sipFormatRef, mapAddPanel);
	else
		sSipFormat.setDefinesFormatting("Panel", mapAddPanel);
	
	
//End loop childs//endregion 

//region Optimze Master Size if any childs in master
	double dMinLength,dMinWidth;
	if (ppAllChild.area()>pow(dEps,2))
	{ 
		PlaneProfile ppMinRange = ppAllChild;
		// HSB-20643
		if (dMasterOversizeX == dMasterOversizeY && abs(dMasterOversizeX)>dEps)
			ppMinRange.shrink(-dMasterOversizeX);
		else
		{ 
			if (abs(dMasterOversizeX)>dEps)	
			{
				int bOk = stretchProfile(ppMinRange, _XW, true, 1, dMasterOversizeX);
			}
			if (abs(dMasterOversizeY)>dEps)	
			{
				int bOk = stretchProfile(ppMinRange, _YW, true, -1, dMasterOversizeY);
			}			
		}

		Point3d pts[0];
		LineSeg seg1 = ppMaster.extentInDir(_XW);
		Point3d pt1 = seg1.ptStart();
		pts.append(pt1);
		pts.append(seg1.ptEnd());
		
		LineSeg seg2 = ppMinRange.extentInDir(_XW);
		double dX2 = abs(_XW.dotProduct(seg2.ptEnd() - seg2.ptStart()));
		double dY2 = abs(_YW.dotProduct(seg2.ptEnd() - seg2.ptStart()));
		Point3d pt2 = seg2.ptMid() + .5 * (_XW * dX2 + _YW * dY2);
		pts.append(seg2.ptStart());
		pts.append(seg2.ptEnd());			
	
		pts = Line(_Pt0, _XW).orderPoints(pts);
		if (pts.length()>1)
			pt1 = pts.first();		

		pts = Line(_Pt0, _YW).orderPoints(pts);
		if (pts.length()>1)
			pt1 += _YW * _YW.dotProduct(pts.first() - pt1);			

		pt1.vis(1);
		pt2.vis(2);		
		
	
	// get min profile
		PlaneProfile ppMin;	
		for(int i=0;i<ppOversizes.length();i++)
		{
			PlaneProfile pp = ppOversizes[i];
			if (ppMin.area() <pow(dEps,2))
				ppMin = pp;
			else	
				ppMin.unionWith(pp);
		}
		
		//// HSB-20643
		if (dMasterOversizeX == dMasterOversizeY && abs(dMasterOversizeX)>dEps)
			ppMin.shrink(-dMasterOversizeX);
		else
		{ 
			if (abs(dMasterOversizeX)>dEps)	
			{
				int bOk = stretchProfile(ppMin, _XW, true, 1, dMasterOversizeX);
			}
			if (abs(dMasterOversizeY)>dEps)	
			{
				int bOk = stretchProfile(ppMin, _YW, true, -1, dMasterOversizeY);
			}			
		}		
		//ppMin.shrink(-dMasterOversizeX);
		
		
		LineSeg segMin = ppMinRange.extentInDir(vecX);
		segMin.vis(3);	
	
		plShape.createRectangle(LineSeg(pt1,pt2), vecX, vecY);
		//master.setPlShape(plShape);
		
		
	// keep reference point left aligned
		if (bAlignRight)
		{
		
//			PLine (ptMid,_Pt0).vis(3);
			plShape.vis(1);
//			double d = vecX.dotProduct(_Pt0-(ptMid-vecX*.5*dXNew));
//			Vector3d vec = vecX*vecX.dotProduct(_Pt0-(ptMid-vecX*.5*dXNew));
//			vec.vis(ptMid,4);
			//master.transformBy(vec);
//				for (int i=0;i<childs.length();i++)
//					childs[i].transformBy(vec);
		}		
	
	}
	else // HSB-16985 use fixed values if no childs present
	{ 
		dMinLength = dLength;
		dMinWidth = dWidth;
		
	}


 
	{ 
		Point3d pt1, pt2;
		
		
		Point3d pts[0];
		LineSeg seg1 = ppMaster.extentInDir(_XW);
		pt1 = seg1.ptStart();
		pts.append(pt1);
		pts.append(seg1.ptEnd());		

		if (childs.length()>0)
		{ 
		
		//region Get miniaml required length and width based on the placement of the childs within the master
			PlaneProfile ppRange = ppAllChild;
			// ppRange.shrink(-dMasterOversizeX); // HSB-20643
			if (dMasterOversizeX == dMasterOversizeY && abs(dMasterOversizeX)>dEps)
				ppRange.shrink(-dMasterOversizeX);
			else
			{ 
				if (abs(dMasterOversizeX)>dEps)	
				{
					int bOk = stretchProfile(ppRange, _XW, true, 1, dMasterOversizeX);
				}
				if (abs(dMasterOversizeY)>dEps)	
				{
					int bOk = stretchProfile(ppRange, _YW, true, -1, dMasterOversizeY);
				}			
			}	
			
			
			
			
			
			
			LineSeg seg2 = ppRange.extentInDir(_XW);
			double dX2 = abs(_XW.dotProduct(seg2.ptEnd() - seg2.ptStart()));
			double dY2 = abs(_YW.dotProduct(seg2.ptEnd() - seg2.ptStart()));
			pt2 = seg2.ptMid() + .5 * (_XW * dX2 + _YW * dY2);
			pts.append(seg2.ptStart());
			pts.append(seg2.ptEnd());			
		
			pts = Line(_Pt0, _XW).orderPoints(pts);
			if (pts.length()>1)
				pt1 = pts.first();		
	
			pts = Line(_Pt0, _YW).orderPoints(pts);
			if (pts.length()>1)
				pt1 += _YW * _YW.dotProduct(pts.first() - pt1);			
	
			pt1.vis(1);
			pt2.vis(2);	
			
		// disable autosize if it exceeds minimal values	
			dMinLength= _XW.dotProduct(pt2-pt1);
			if (dLength>0 && dLength<dMinLength)
			{ 
				if (nAutoSizeEvent>-1)
					reportNotice("\n"+_kExecutionLoopCount + scriptName() + T("|Masterpanel| ")+master.number() + TN("|Not possible to adjust| '") + sLengthName + T("' |requires min length of| ") + dMinLength);
				bDoAutoSize = false;
			}		
			dMinWidth = _YW.dotProduct(pt2-pt1);		
			if ( dWidth>0 && dWidth<dMinWidth)
			{ 
				if (nAutoSizeEvent>-1)
					reportNotice("\n"+scriptName()+ T("|Masterpanel| ")+master.number() + TN("|Not possible to adjust| '")+ sWidthName + T("' |requires min width of| ") + dMinWidth);
				bDoAutoSize = false;
			}			
		//endregion 
	
			
		}
		else if (nAutoSizeEvent>-1 && (dLength>0 ||dWidth>0)) // HSB-16985 length or width modfied but no childs present to support auto sizing
		{ 
			pts = Line(_Pt0, _XW).orderPoints(pts);
			if (pts.length()>1)
				pt1 = pts.first();	

			pts = Line(_Pt0, _YW).orderPoints(pts);
			if (pts.length()>1)
				pt1 += _YW * _YW.dotProduct(pts.first() - pt1);				
			
			bDoAutoSize = false;
			bSetFixedSize = true;
			//reportNotice("\ndoFixedSize no childs at pt1 " + pt1);
		}

	
		if (bSetFixedSize)
		{ 
		// default new dimensions to the changed property (length or width)	
			double dXNew = nAutoSizeEvent==1?dLength:dMinLength;
			double dYNew = nAutoSizeEvent==2?dWidth:dMinWidth;
			
		// if the event changed autoSize to disabled	
			if (nAutoSizeEvent==0 && dLength>0)
				dXNew = dLength;
			if (nAutoSizeEvent==0 && dWidth>0)
				dYNew = dWidth;

//reportNotice("\n" + scriptName() + T("|creating Masterpanel| ") + dXNew + " " + dYNew + " dMinLength " + dMinLength + " dMinWidth " + dMinWidth);

			pt2 = pt1 + _XW * dXNew + _YW * dYNew;		
			plShape.createRectangle(LineSeg(pt1,pt2), _XW, _YW);
			plShape.vis(1);		
			
			int bOk = !bDebug;
			
			if (dAutoSizeMinimumX > 0 && dXNew <= dAutoSizeMinimumX || dAutoSizeMinimumY > 0 && dYNew <= dAutoSizeMinimumY)
			{
				bOk = false;
				reportNotice("\n" + scriptName() + T("|Masterpanel| ") + master.number() +"\n"+ 
					_kNameLastChangedProp + T(" |is smaller than specified minimal value.|"));				
			}


			if (bOk)
			{
				//reportNotice("\nsetting master by fixed size");
				master.setPlShape(plShape);	
				setExecutionLoops(2);
				return;
			}						
		}
	
		else if ((bDoAutoSize || bDebug) && childs.length()>0)// 
		{
			if (bDebug) 
				reportMessage("\n	master " + master.handle() + " will be optimized by " + _ThisInst.handle());
			else
				_Map.removeAt("AutoSize", true);
			int bDebug2=bDebug;
			if (bDebug2) reportMessage(TN("|AutoSize Map:|") + mapGrid);
		
		// get min profile
			PlaneProfile ppMinRange = ppAllChild;	
			LineSeg segMin = ppMinRange.extentInDir(vecX);
			segMin.vis(3);
			
		// get dimensions
			dX = dMinLength;//abs(vecX.dotProduct(segMin.ptStart()-segMin.ptEnd()));
			dY = dMinWidth;//abs(vecY.dotProduct(segMin.ptStart()-segMin.ptEnd()));
	
		// ceiling
			double dXNew=dX;
			double dYNew=dY;

		//region X AutoSize
			// Range
			int bIsInRangeX;
			if (bHasAutoRangeX)
				bIsInRangeX = getValueByRange(dXNew, dMinRangesX, dMaxRangesX, dRangeValuesX);
						
			if (!bIsInRangeX)
			{ 
				// Ceiling	
				if (dGridXValues.length()<1 && dCeilingX>0)
				{
					int n = (dX + 2 * dMasterOversizeX)/ dCeilingX +.999;
					dXNew = n*dCeilingX;
				}	
				// Fixed values
				else
				{
					for(int i=0;i<dGridXValues.length();i++)
						if (dX<=dGridXValues[i])
						{
							dXNew =dGridXValues[i];
							break;
						}
				}				
			}
	
			// if a minimal size is specified make sure the new value is not below, Version 4.2
			if (dAutoSizeMinimumX>0 && dAutoSizeMinimumX>dXNew)
			{
				dXNew = dAutoSizeMinimumX;	
				if (dLength>dXNew)
				{ 
					reportMessage("\n" + scriptName() + ": " +T("|The minimal length defined prevents the usage of the given length|"));
				}
			}				
		//endregion 

		//region Y AutoSize
			int bIsInRangeY;
			// Range
			if (bHasAutoRangeY)
				bIsInRangeY =getValueByRange(dYNew, dMinRangesY, dMaxRangesY, dRangeValuesY);
			
			if (!bIsInRangeY)
			{ 
				//Ceiling	
				if (dGridYValues.length()<1 && dCeilingY>0)
				{
					int n = (dY+2*dMasterOversizeY) / dCeilingY +.999;
					dYNew = n*dCeilingY;
				
				}
				// Fixed values
				else
				{
					for(int i=0;i<dGridYValues.length();i++)
						if (dY<=dGridYValues[i])
						{
							dYNew =dGridYValues[i];
							break;
						}
				}					
			}
		
			// if a minimal size is specified make sure the new value is not below, Version 4.2
			if (dAutoSizeMinimumY>0 && dAutoSizeMinimumY>dYNew)
			{
				dYNew = dAutoSizeMinimumY;
				if (dWidth>dYNew)
				{ 
					reportMessage("\n" + scriptName() + ": " +T("|The minimal width defined prevents the usage of the given width|"));
				}
			}
		//endregion 

		//if (bDebug)reportMessage("\n	Requesting new dimensions for master dXNew = " + dXNew + " dYNew = " + dYNew);
			
		// scale segment and relocate
			if (dXNew>dEps && dYNew>dEps)
			{
				
			// get lower left of current master
				segMaster= ppMaster.extentInDir(_XW);
				
			// get dimensions
				double dX = abs(_XW.dotProduct(segMaster.ptStart()-segMaster.ptEnd()));
				double dY = abs(_YW.dotProduct(segMaster.ptStart()-segMaster.ptEnd()));			
					
				//Point3d pt1 = seg.ptMid()-.5*(_XW*dX+_YW*dY);
				pt2 = pt1 + _XW * dXNew + _YW * dYNew;
				
				plShape.createRectangle(LineSeg(pt1,pt2), _XW, _YW);
				plShape.vis(1);
				
				if (!bDebug)
				{
					//reportNotice("\nsetting master do auto size");
					master.setPlShape(plShape);
					setExecutionLoops(2);
					return;
				}	
			}
	
		}// END IF autoSize
		else
		{
			// set location
			ptRefLoc = 	segMaster.ptMid()-nLeftRight*vecX*.5*dX-vecY*.5*dY;
			master.setPtRef(ptRefLoc);
		}		
	}
	
		
//End optimze master size//endregion 


//region LeftRight Alignment HSB-5581
	Entity entEdgeAlignments[] = _Map.getEntityArray("EdgeAlignment[]","","EdgeAlignment");
	if (entEdgeAlignments.length()>0 || bDebug)
	{ 
		//region Collect childs and profiles of selection set
		PlaneProfile pps[0], ppsNet[0];
		LineSeg segs[0];
		for (int i=0;i<childs.length();i++) 
		{ 
			PlaneProfile pp = ppChilds[i];//childs[i].realBody().shadowProfile(pnW);
			LineSeg s = pp.extentInDir(vecX);
			segs.append(s);
			pp.shrink(-dEps);
			ppsNet.append(pp);
			pp.shrink(-dSpacing); // blow up the profile to encounter the minimal spacing between the childs
			
		// intersect with bounding box 	
			{ 
				PlaneProfile _pp;
				_pp.createRectangle(s, vecX, vecY);
				_pp.shrink((dSpacing>0?dEps:0)-dSpacing);
				pp.intersectWith(_pp);	
			}
			
			
			pps.append(pp);			
		}//next i				
		//End Collect childs and profiles of selection set//endregion 
		
		//region Order in vecXDir
		for (int i=0;i<childs.length();i++) 
			for (int j=0;j<childs.length()-1;j++) 
			{
				Point3d ptJ = segs[j].ptStart();
				Point3d ptJJ = segs[j+1].ptStart();
				
				if (((bAlignRight?-1:1)*vecX).dotProduct(ptJJ-ptJ)<0)
				{ 
					childs.swap(j, j + 1);
					pps.swap(j, j + 1);	
					ppsNet.swap(j, j + 1);	
					segs.swap(j, j + 1);						
				}
			}			
		//End Order in vecXDir//endregion 

		//region Count intersections in left/right direction (seen along X)
		for (int i=0;i<childs.length();i++) 
		{
			int nNumIntersection;
			LineSeg segC = segs[i]; //segC.vis(i);
			double dXC = abs(vecX.dotProduct(segC.ptEnd() - segC.ptStart()));
			double dYC = abs(vecY.dotProduct(segC.ptEnd() - segC.ptStart()));
			
			Vector3d vecYDir = (vecY.dotProduct(segC.ptMid() - ptMidMaster) < 0 ?- 1 : 1) * vecY;
			
		// get child offset to edge of master
			double dEdgeOffset = .5 * (dY - dYC) -dMasterOversizeX- vecYDir.dotProduct(segC.ptMid() - ptMidMaster);
			
		// no transformation if the offset is too small or the entity is not in the list of selected items	
			if (dEdgeOffset<dEps || (!bDebug && entEdgeAlignments.find(childs[i]) < 0))
			{ 
				continue;
			}
			
		// HSB-7194 The color of the diagonal segments indicates the number of detected intersections with other child panels (white = none) 
		// White diagonal segments and green arrows show the potential child panels to be aligned with the designated offset direction.	

			for (int j=0;j<childs.length();j++) 
			{ 
				if (i == j)continue;
							
				Point3d ptX = segs[i].ptMid() - vecX * .5 * dXC-vecYDir*.5*dYC;
				LineSeg segY(ptX, ptX + vecYDir * dEdgeOffset); //segY.vis(3);
				for (int x=0;x<29;x++) 
				{ 	
				// HSB-7192 align with edge: test interference of alignment on real contour and not on bounding box	
				// transform segY in offset direction to the closest intersection with the i-child	
					{
						LineSeg segsX[] = ppsNet[i].splitSegments(LineSeg(segY.ptMid()-vecYDir*U(10e4),segY.ptMid()+vecYDir*U(10e4)), true);// HSB-7194 consider offset direction to get last segment
						if (segsX.length()>0)
							segY.transformBy(segsX.last().ptEnd() - segY.ptStart());
					}

					LineSeg segsX[] = pps[j].splitSegments(segY, true);
					if (segsX.length() > 0)
					{
//						segY.vis(i);
						//pps[j].vis(4);
						for (int xx=0;xx<segsX.length();xx++) segsX[xx].vis(1); 
						nNumIntersection++;
						break;
					}
					//segY.vis(i%8); // viualizes any failed attempt
					segY.transformBy(vecX * dXC / ((x<10 || x>17)?100:10));
				}//next x
			}//next j	
			segs[i].vis(nNumIntersection);  // visualizes the segement intersections by the color index
			
			if (nNumIntersection>0)
			{ 
				//vecYDir.vis(segC.ptMid(), 1);
				Sip sip = childs[i].sipEntity();
				Point3d ptCen = sip.ptCen();
				ptCen.transformBy(childs[i].sipToMeTransformation());
				String sMsg;
				sMsg += sip.name();
				sMsg += (sMsg.length()>0 && sip.posnum()>-1)?" "+sip.posnum():"";
				sMsg += (sMsg.length()>0 && sip.label().length()>-1)?" "+sip.label():"";
				sMsg += (sMsg.length()>0 && sip.name().length()>-1)?" "+sip.name():"";
				if (sMsg.length() < 1)sMsg = T("|at location| ")+ptCen;
				
				sMsg = T("|The panel| ")+sMsg + T(" |cannot be aligned with edge because it intersects with other panels.| (" + nNumIntersection + ")" + T(", |Offset| = ") + dEdgeOffset);
				reportMessage("\n" + sMsg);
			}
			else if (!bDebug)
			{ 
				vecYDir *= dEdgeOffset;
				childs[i].transformBy(vecYDir);
				pps[i].transformBy(vecYDir);
				segs[i].transformBy(vecYDir);
			}
			else
			{ 
				vecYDir.vis(segC.ptMid(), 3);
			}
		}				
		//End count intersections in left/right direction (seen along X)//endregion 

		_Map.removeAt("EdgeAlignment[]", true); // remove the set from map
	}
//End LeftRight Alignment//endregion 

//region DRAW GRAPHICS

	//region Draw areas which are outside the master
	int bRecalc;
	for(int i=0;i<ppOversizes.length();i++)
	{
		PlaneProfile pp = ppOversizes[i];
		pp.subtractProfile(ppMaster);
		if (pp.area()>pow(dEps,2))
		{
			dpWarning.draw(pp,_kDrawFilled, nTransparencyInterfere);
			dpWarning.showInDxa(true);// Make-762
			bRecalc = true;
		}
			
		for(int j=i+1;j<ppOversizes.length();j++)
		{
			pp = ppOversizes[i];
			pp.intersectWith(ppOversizes[j]);
			if (pp.area()>pow(dEps,2))
			{
				//PlaneProfile ppSub =ppOversizes[j];
				//ppSub.shrink(dOversize);
				//pp.subtractProfile(ppSub); 
				dpWarning.draw(pp,_kDrawFilled,nTransparencyInterfere);	
				bRecalc = true;
			}
		}	
	}
	if (bRecalc)setExecutionLoops(2);// HSB-13525
	//End // draw areas which are outside the master//endregion 

	//region Draw Child Warning if intersecting with master oversize

	{ 
		
		
		PlaneProfile ppRing = ppMaster;
		PlaneProfile sub = ppRing; 
		dpWarning.color(1);
		StretchPlaneProfileInDir(sub, _XW, -(dMasterOversizeX-dEps),1);
		StretchPlaneProfileInDir(sub, -_XW, -(dMasterOversizeX-dEps),1);
		StretchPlaneProfileInDir(sub, _YW, -(dMasterOversizeY-dEps),1);
		StretchPlaneProfileInDir(sub, -_YW, -(dMasterOversizeY-dEps),1);

		ppRing.subtractProfile(sub);
		//{Display dpx(4); dpx.draw(ppRing, _kDrawFilled,20);} 
		
		int bShowOversizeWarning;
		PlaneProfile ppWarnings[ppChilds.length()];
		for (int i=0;i<ppChilds.length();i++) 
		{ 
			PlaneProfile ppc= ppChilds[i]; 
			Point3d ptm = ppc.ptMid();
			PlaneProfile pp1= ppc; 

			if (pp1.intersectWith(ppRing))
			{
				ppWarnings[i] = pp1;
				bShowOversizeWarning = true;
			}

		}//next i

	
	// Oversize warning toggle
		int bDisableOversizeWarning = bShowOversizeWarning?_Map.getInt("disableOversizeWarning"):false;
		String sTriggerDisableWarning = bDisableOversizeWarning ? T("|Show Oversize Warning|") : T("|Hide Oversize Warning|");
		if (bShowOversizeWarning)addRecalcTrigger(_kContextRoot, sTriggerDisableWarning );
		if (_bOnRecalc && _kExecuteKey==sTriggerDisableWarning)
		{
			_Map.setInt("disableOversizeWarning",!bDisableOversizeWarning);		
			setExecutionLoops(2);
			return;
		}
		if (bShowOversizeWarning && !bDisableOversizeWarning)
		{ 

			double dXA =U(100);

			for (int i=0;i<ppChilds.length();i++) 	
			{				
				PlaneProfile ppc= ppChilds[i]; 
				Point3d ptm = ppc.ptMid();
				PlaneProfile pp1= ppWarnings[i];
				PlaneProfile pp2= ppc; 			
				if (pp1.area()<pow(dEps,2)){ continue;}
				pp2.subtractProfile(pp1);
				dpWarning.draw(pp1, _kDrawFilled,nTransparencyInterfere);
				dpWarning.draw(pp2, _kDrawFilled,80);
					
			// Collect potential tip points of warning arrows
				Point3d ptsA[0], pts[0];
				pts= Line(_Pt0, _YW).orderPoints(pp1.intersectPoints(Plane(ptm, _XW), true, false), dEps);
				if(pts.length()>0)		ptsA.append(pts.first());
				else if(pts.length()>=2)ptsA.append(pts.last());

				pts= Line(_Pt0, _XW).orderPoints(pp1.intersectPoints(Plane(ptm, _YW), true, false), dEps);
				if(pts.length()>0)		ptsA.append(pts.first());
				else if(pts.length()>=2)ptsA.append(pts.last());
				
			// draw arrows to highlight location
				for (int p=0;p<ptsA.length();p++) 
				{ 
					Point3d pt1= ptsA[p]; 
					Point3d pt2 = ptm;
					Vector3d vecXA = pt1 - pt2; vecXA.normalize();
					Vector3d vecYA = vecXA.crossProduct(_ZW);
					
					PLine pl(pt1-vecXA*dXA, pt1, pt1 - vecXA * .5 * dXA + vecYA * .25 * dXA);
					PLine pl2 = pl;
					pl2.offset(.1 * dXA, true);				pl2.reverse();			pl.append(pl2);				pl.close();
					PlaneProfile ppA(pl);
					CoordSys csMirr; csMirr.setToMirroring(Plane(pt1, vecYA));
					pl.transformBy(csMirr);
					ppA.unionWith(PlaneProfile(pl));
					dpWarning.draw(ppA,_kDrawFilled, nTransparencyInterfere);
				}//next p	
			}
		}
	//endregion		
	
	}		
	
	//endregion 




	//region Header
	int bHasBlockHeader;
	if (sHeaderBlockName.length()>0)// && !bDebug)
	{
	// check if present in dwg
		int bBlockLoaded;
		for (int i=0;i<_BlockNames.length();i++) 
		{ 
			String s= _BlockNames[i]; 
			if (s.left(1)=="*"){ continue;}
			s.makeUpper();
			if (sHeaderBlockName.makeUpper()==s)
			{ 
				bBlockLoaded = true;
				break;
			}		 
		}//next i
		
	// if not present load from any company path
		if (!bBlockLoaded)
		{ 
		//sample code to call this method
			String sFileName = sHeaderBlockName;
			Map mapIO;
			mapIO.setString(kPath,_kPathHsbCompany+"\\");
			mapIO.setString(kFileName,sFileName);	
			mapIO.setString(kExtension,".dwg");
			String sFile;
			int bOk = TslInst().callMapIO(scriptName(), mapIO);
			if (bOk)
				sFile = findFile(mapIO.getString("FullFilePath"));	
			else
				reportMessage("\n" + scriptName() + ": " +T("|unexpected error while searching file| ") +sFileName);	
			
		// load the block into the dwg
			if (sFile.length()>0)
			{ 
				Block bl(sFile);
				bl.getExtents();
				for (int i=0;i<_BlockNames.length();i++) 
				{ 
					String s= _BlockNames[i]; 
					s.makeUpper();
					if (sHeaderBlockName.makeUpper()==s && s.left(1)!="*")
					{ 
						bBlockLoaded = true;
						break;
					}		 
				}//next i				
			}
		}
		
	// set bref location
		LineSeg seg = ppMaster.extentInDir(vecX);
		double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
		double dY = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
		//Point3d ptBref = seg.ptMid() + vecX*(dHeaderXOffset+nHeaderXAlignment*.5*dX)+vecY*(dHeaderYOffset+nHeaderYAlignment*.5*dY);	
		Point3d ptBref = seg.ptMid() + vecX*(dHeaderXOffset-.5*dX)+vecY*(dHeaderYOffset-.5*dY);	
		ptBref.vis(3);
		
	// create bref if not valid
		if (bBlockLoaded && !bref.bIsValid())
		{ 
		// create tag block
			CoordSys cs(ptBref, _XW, _YW, _ZW);
	  		bref.dbCreate(cs, sHeaderBlockName);
	
			if (bref.bIsValid())
			{
				bref.createMissingAttributes();
				_Entity.append(bref);
				setExecutionLoops(2);
			}			
		}
	// fill attributes and transform bref to location	
		else if (bref.bIsValid() && bref.definition().find(sHeaderBlockName, 0, false)==0) // HSB-20417
		{
			bHasBlockHeader = true;
			Entity entDef = master;
			MasterPanelStyle style(master.style());
		
		//region Attributes
		// get attributes	
			String sAttributes[] = bref.getAttributeList();	
						
			Map mx;
			mx.setString("GrainDirectionText",vecXGrainMaster.isParallelTo(_XW) ? T("|Lengthwise|") : T("|Crosswise|"));
			mx.setString("GrainDirectionTextShort",vecXGrainMaster.isParallelTo(_XW) ? T("|Grain LW|") : T("|Grain CW|"));
			mx.setString("STYLE",master.style());
			mx.setString("surfaceQualityTop",master.surfaceQualityOverrideTop().length()>0?master.surfaceQualityOverrideTop():style.surfaceQualityTop());
			mx.setString("surfaceQualityBottom",master.surfaceQualityOverrideBottom().length()>0?master.surfaceQualityOverrideBottom():style.surfaceQualityBottom());

		// loop attributes and try to find value of variable from entity
			Map map = bref.getAttributeMap();
			int bWrite;				
			for (int i=0;i<sAttributes.length();i++) 
			{ 
			
			// Get attribute and append default argument
				String& sAttribute = sAttributes[i];
				String attribute= sAttribute;
				if (attribute.find(")",0,false)>-1 && attribute.find(":D)",0,false)<0)
					attribute.replace(")", ":D)");
				
				
			// Try get value from master	
				String value= entDef.formatObject(attribute, mx);
				
			// Try get value from first child	
				if (value.length()<1 && sipFormatRef.bIsValid())
					value= sipFormatRef.formatObject(attribute, mx);
	
				if (value.length()>0)	
					;	
				else if (sAttribute=="@(LENGTH)")
					value = dX;	
				else if (sAttribute=="@(WIDTH)")
					value = dY;	
				else if (sAttribute=="@(THICKNESS)".makeUpper())
					value = master.dThickness();
				else if (sAttribute=="@(YIELD)".makeUpper())
					value = String().formatUnit(master.dYield(),2,2);					
				else if (sAttribute == "@(surfaceQuality)".makeUpper())
				{
					String sqTop = master.surfaceQualityOverrideTop();
					if (sqTop.length()<1)sqTop = style.surfaceQualityTop();					
					int nQualityTop = SurfaceQualityStyle(sqTop).quality();
					
					String sqBottom = master.surfaceQualityOverrideBottom();
					if (sqBottom.length()<1)sqBottom = style.surfaceQualityBottom();					
					int nQualityBottom = SurfaceQualityStyle(sqBottom).quality();
				
				// find lowest quality
					SurfaceQualityStyle sqStyles[]=SurfaceQualityStyle().getAllEntries();
					int nQualities[0];
					for (int j=0;j<sqStyles.length();j++) 
						nQualities.append(sqStyles[j].quality()); 
				// order alphabetically
					for (int k=0;k<nQualities.length();k++) 
						for (int j=0;j<nQualities.length()-1;j++) 
							if (nQualities[j]>nQualities[j+1])
							{
								sqStyles.swap(j, j + 1);
								nQualities.swap(j, j + 1);
							}
				
				// distiguish higher / equal surface qualities// -1 = bottom hight, 0 = equal, 1 = top higher
					int nEqual=nQualityTop < nQualityBottom ?- 1 : (nQualityTop > nQualityBottom ? 1 : 0);
					if (nEqual==-1)
						value = sqBottom + T(" |bottom|");
					else if (nEqual==1)
						value = sqTop+ T(" |top|");
					else if (nQualities.length()>0 && nQualityTop>nQualities[0]) // do not display lowest quality with appendix 'both sides'
					{ 
						value = sqTop+ T(" |both sides|");	
					}
				}
				
			// check if the value varies from attribute value
				String _value = map.getString(sAttribute);
				if (_value!=value)
				{ 
					map.setString(sAttribute, value);
					bWrite = true;
				} 
			}//next i				
		
		// update values
			if (bWrite)bref.setAttributesFromMap(map);		
		//endregion End Attributes
			
		//region ColorBlock
		// requires color by block
			int c = nColorHeader;
			// loop oversize definitions
			for (int i=0;i<mapColorsOversize.length();i++) 
			{ 
				Map m= mapColorsOversize.getMap(i);
			// check width	
				if (m.hasDouble("MinY") && m.getDouble("MinY")<=dY)
				{ 
					if (m.hasDouble("MaxY") && m.getDouble("MaxY") < dY)continue;
					c = m.getInt("Color");
					break;
				}
			// check length	
				if (m.hasDouble("MinX") && m.getDouble("MinX")<=dX)
				{ 
					if (m.hasDouble("MaxX") && m.getDouble("MaxX") < dX)continue;
					c = m.getInt("Color");
					break;
				}							 
			}//next i
			if (bref.color() != c)bref.setColor(c);
		//endregion End ColorBlock

			
		// get bref coordSys
			CoordSys cs = bref.coordSys();
			Point3d ptOrg = cs.ptOrg();	
			bref.transformBy(ptBref - cs.ptOrg());
		}
	}
	
	// purge potential blocks
	else if (bref.bIsValid() && sHeaderBlockName.length()<1)
	{ 
		reportMessage("\n" + T("|Purging block reference|"));
		bref.dbErase();
	}
	
	//End Header//endregion 	
	
	//region Package Display
	// default package display	
	PLine plCirc;
	double dSize = U(100);
	plCirc.createCircle(´_Pt0-vecY*1.5*dSize, vecZ, dSize);
	//if (nPackageColors.length()<1)nPackageColors.append(234);
	for (int i=0;i<nPackageColors.length();i++)
	{
		dp.color(nPackageColors[i]);
		dp.draw(PlaneProfile(plCirc), _kDrawFilled);
		plCirc.transformBy(vecX*2.5*dSize);
	}		
	//End Package Display//endregion 	

	//region Draw master header data if not in BRef mode

	//region Collect list of available object variables and append properties which are unsupported by formatObject (yet)
	
	
	// HSB-20754 calculate boxedShape Waste
	double dAreaBoxNet,dAreaOutterContourNet;//HSB-20754,HSB-24434:
	PlaneProfile ppAllBox(CoordSys());
	for (int i=0;i<ppBoxChilds.length();i++) 
		dAreaBoxNet += ppBoxChilds[i].area();
	// HSB-24434:
	for (int i=0;i<ppOutterContourChilds.length();i++) 
		dAreaOutterContourNet += ppOutterContourChilds[i].area();

	Map mapAdditionalMaster;
	double dAreaGros = ppMaster.area();
	double dAreaNet = ppAllChild.area();
	
	
	//{Display dpx(2);dpx.draw(ppAllChild,_kDrawFilled);}
	
	double dThickness = MasterPanelStyle(master.style()).dThickness();
	master.updateYield();
	double dYield = master.dYield();
	double dWaste = dAreaGros>0?(1 - dAreaNet / dAreaGros) * 100:0;
	double dBoxWaste = dAreaGros>0?(1 - dAreaBoxNet / dAreaGros) * 100:0;//HSB-20754
	double dOutterContourWaste = dAreaGros>0?(1 - dAreaOutterContourNet / dAreaGros) * 100:0;//HSB-24434:

	mapAdditionalMaster.copyMembersFrom(master.subMapX(kMasterXName));
	mapAdditionalMaster.setInt(kQuantityChilds, childs.length());
	mapAdditionalMaster.setDouble(kWaste, dWaste,_kNoUnit);
	mapAdditionalMaster.setDouble(kBoxWaste, dBoxWaste,_kNoUnit);
	mapAdditionalMaster.setDouble(kOutterContourWaste, dOutterContourWaste,_kNoUnit);// HSB-24434:
	mapAdditionalMaster.setDouble(kBoxWasteArea, dAreaBoxNet,_kArea);
	mapAdditionalMaster.setDouble(kOutterContourWasteArea, dAreaOutterContourNet,_kArea);// HSB-24434:
	mapAdditionalMaster.setDouble(kAreaNet,dAreaNet ,_kArea);
	mapAdditionalMaster.setDouble(kAreaGros, dAreaGros,_kArea);
	mapAdditionalMaster.setDouble(kVolume, dAreaGros*dThickness,_kVolume);	

//	mapAdditionalMaster.setDouble("Width", master.dWidth(),_kLength);
//	mapAdditionalMaster.setDouble("Thickness", dThickness,_kLength);
//	mapAdditionalMaster.setDouble("Length", master.dLength(),_kLength);
//	mapAdditionalMaster.setDouble("Yield", dYield*100,_kNoUnit);
//
//	mapAdditionalMaster.setString("Style", master.style());
//	mapAdditionalMaster.setString("Information", master.information());
//	mapAdditionalMaster.setString("Name", master.name());
	mapAdditionalMaster.setString("SurfaceQuality", surfaceQualityStyleTop.entryName()+"("+surfaceQualityStyleBottom.entryName()+")");
	mapAdditionalMaster.setString("Quality", surfaceQualityStyleTop.entryName()+"("+surfaceQualityStyleBottom.entryName()+")");
	mapAdditionalMaster.setString("SurfaceQualityTop", surfaceQualityStyleTop.entryName());
	mapAdditionalMaster.setString("SurfaceQualityBottom", surfaceQualityStyleBottom.entryName());
	
//	mapAdditionalMaster.setInt("Number", master.number());

	mapAdditionalMaster.setString("GrainDirectionText", vecXGrainMaster.isParallelTo(_XW) ? T("|Lengthwise|") : T("|Crosswise|"));
	mapAdditionalMaster.setString("GrainDirectionTextShort", vecXGrainMaster.isParallelTo(_XW) ? T("|Grain LW|") : T("|Grain CW|"));

	mapAdditionalMaster.setDouble("OversizeX", dMasterOversizeX,_kLength);
	mapAdditionalMaster.setDouble("OversizeY", dMasterOversizeY,_kLength);
	// HSB-24493
	if(nDeliveryMaster<99999 && nDeliveryMaster>-1)
	{ 
		mapAdditionalMaster.setInt("DeliveryMaster", nDeliveryMaster);
	}
	
//	
//	mapAdditionalMaster.setString("ArticleNumber", master.subMapX(kMasterXName).getString("ArticleNumber"));
//	mapAdditionalMaster.setString("Components", master.subMapX(kMasterXName).getString("Components"));

	sFormat.setDefinesFormatting(MasterPanel(), mapAdditionalMaster);

//	String sObjectVariables[] = master.formatObjectVariables();
//
//	// adding custom variables or variables which are currently not supported by core
//	String sCustomVariables[] ={ "GrainDirection", "Style", "Information", "Number", "Name", 
//		"Thickness", "Length", "Width", "Yield","SurfaceQuality",
//		"SurfaceQualityTop", "SurfaceQualityBottom" };
//	for (int i=0;i<sCustomVariables.length();i++)
//		if (sObjectVariables.find(sCustomVariables[i]) < 0)
//			sObjectVariables.append(sCustomVariables[i]);
//	
//// get translated list of variables
//	String sTranslatedVariables[0];
//	for (int i=0;i<sObjectVariables.length();i++) 
//		sTranslatedVariables.append(T("|"+sObjectVariables[i]+"|")); 
//	
//// order both arrays alphabetically
//	for (int i=0;i<sTranslatedVariables.length();i++) 
//		for (int j=0;j<sTranslatedVariables.length()-1;j++) 
//			if (sTranslatedVariables[j]>sTranslatedVariables[j+1])
//			{
//				sObjectVariables.swap(j, j + 1);
//				sTranslatedVariables.swap(j, j + 1);
//			}			

	//End get list of available object variables//endregion 

	//region Resolve format by entity
	String text;// = "R" + dDiameter * .5;
	if (sFormat.length()>0)
	{ 
		String sLines[0];// store the resolved variables by line (if \P was found)	
		String sValues[0];	
		String sValue=  master.formatObject(sFormat, mapAdditionalMaster);
		int nRowGrain = - 1;
		double dLengthBeforeGrain;

		int cnt, numMax = sValue.length();
		while (cnt<numMax && sValue.length()>0)
		{ 

			String line = getFirstLine(sValue);
			if (line.length()>0)
				sValues.append(line);
			cnt++;
		}

	
	// resolve unknown variables
		for (int v= 0; v < sValues.length(); v++)
		{
			String& value = sValues[v];
			int left = value.find("@(", 0);
			
		// get formatVariables and prefixes
			if (left>-1)
			{ 
				// tokenize does not work for strings like '(@(KEY))'
				String sTokens[0];
				while (value.length() > 0)
				{
					int right = value.find(")", left);
					
				// key found at first location	
					if (left == 0 && right > 0)
					{
						String sVariable = value.left(right + 1);
						
						//"Radius", "Diameter", "Length", "Area"
						String s;
//						String sCustomVariables[] ={ "GrainDirection", "Style", "Information", "Number", "Name", 
//								"Thickness", "Length", "Width", "Yield","SurfaceQuality",
//								"SurfaceQualityTop", "SurfaceQualityBottom" };

						if (sVariable.find("@(GrainDirection)",0,false)>-1)
						//if (sVariable.find("@("+sCustomVariables[0]+")",0,false)>-1)
						{
							nRowGrain = sLines.length();
							String sBefore;
							for (int j=0;j<sTokens.length();j++) 
								sBefore += sTokens[j]; // the potential characters before the grain direction symbol
							dLengthBeforeGrain = dp.textLengthForStyle(sBefore, sDimStyle, dTxtH);
							sTokens.append("    ");//  4 blanks, symbol size max 2 characters length
			
						}
//						else if (sVariable.find("@("+sCustomVariables[1]+")",0,false)>-1)	sTokens.append(master.style());	
//						else if (sVariable.find("@("+sCustomVariables[2]+")",0,false)>-1)	sTokens.append(master.information());		
//						else if (sVariable.find("@("+sCustomVariables[3]+")",0,false)>-1)	sTokens.append(master.number());	
//						else if (sVariable.find("@("+sCustomVariables[4]+")",0,false)>-1)	sTokens.append(master.name());
//						else if (sVariable.find("@("+sCustomVariables[5]+")",0,false)>-1)	sTokens.append(String().formatUnit(master.dThickness(),_kLength));
//						else if (sVariable.find("@("+sCustomVariables[6]+")",0,false)>-1)	sTokens.append(String().formatUnit(master.dLength(),_kLength));
//						else if (sVariable.find("@("+sCustomVariables[7]+")",0,false)>-1)	sTokens.append(String().formatUnit(master.dWidth(),_kLength));
//						else if (sVariable.find("@("+sCustomVariables[8]+")",0,false)>-1)	sTokens.append(dYield*100+"%");
//						else if (sVariable.find("@("+sCustomVariables[9]+")",0,false)>-1)	sTokens.append(surfaceQualityStyleTop.entryName()+"("+surfaceQualityStyleBottom.entryName()+")");
//						else if (sVariable.find("@("+sCustomVariables[10]+")",0,false)>-1)	sTokens.append(surfaceQualityStyleTop.entryName());
//						else if (sVariable.find("@("+sCustomVariables[11]+")",0,false)>-1)	sTokens.append(surfaceQualityStyleBottom.entryName());

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
					left = value.find("@(", 0);
				}
//	
				for (int j=0;j<sTokens.length();j++) 
					value+= sTokens[j]; 
			}
//			//sAppendix += value;
			sLines.append(value);
		}	
//		
	// text out
		for (int j=0;j<sLines.length();j++) 
		{ 
			text += sLines[j];
			if (j < sLines.length() - 1)text += "\n";		 
		}//next j
		
	// find outside location and draw text
	// draw the grain direction symbol
		Point3d ptHeader = _Pt0 - vecY * 1.5 * dSize;
		dp.color(nColor);
		dp.textHeight(dTxtH);
		if (nRowGrain>-1 && sLines.length()>0)
		{ 
			double dYBox = dp.textHeightForStyle(text, sDimStyle, dTxtH);
			double dRowHeight = dYBox / sLines.length();
			double dX = vecX.isParallelTo(vecXGrainMaster) ? 2*dp.textLengthForStyle("O", sDimStyle, dTxtH) : .8*dTxtH;
			Point3d pt = ptHeader;
			if (dLengthBeforeGrain > 0)pt += vecX * .5 * (dLengthBeforeGrain + dX);
			else pt += vecY * .5 * dTxtH;
			PLine pl;	
			pl.addVertex(pt - vecXGrainMaster * .5 * dX - vecYGrainMaster * .5 * dTxtH);
			pl.addVertex(pt - vecXGrainMaster  * dX);
			pl.addVertex(pt + vecXGrainMaster  * dX);
			pl.addVertex(pt + vecXGrainMaster * .5 * dX + vecYGrainMaster * .5 * dTxtH);
			pl.transformBy(vecX * dX-vecY*(nRowGrain+.25) * dTxtH*2);
			dp.draw(pl);
		}
		if (text.length()>0 && !bHasBlockHeader) // HSB-20283
		{ 
			
			
			Point3d pt = ptHeader;
			
			if (abs(dHeaderXOffset) > dEps || abs(dHeaderYOffset) > dEps)
			{
				// set bref location
				LineSeg seg = ppMaster.extentInDir(vecX);
				double dX = abs(vecX.dotProduct(seg.ptStart() - seg.ptEnd()));
				double dY = abs(vecY.dotProduct(seg.ptStart() - seg.ptEnd()));
				pt = seg.ptMid() + vecX * (dHeaderXOffset - .5 * dX) + vecY * (dHeaderYOffset - .5 * dY);
				
			}
			
		// override first line with special height and color	// HSB-20283
			if (dTextHeightHeader!=dTxtH || nColor!=nColorHeader)
			{ 
				Display dp2(nColorHeader);
				dp2.dimStyle(sDimStyle);
				dp2.showInDxa(true);// Make-762
				if (dTextHeightHeader>0)
					dp2.textHeight(dTextHeightHeader);
				else
					dTextHeightHeader = dp2.textHeightForStyle("O", sDimStyle);
				String text01 = getFirstLine(text);
				dp2.draw(text01, pt, _XW, _YW, nHeaderXAlignment, nHeaderYAlignment);
				
				pt -= _YW * (dp2.textHeightForStyle(text01, sDimStyle, dTextHeightHeader)+dTxtH);				
			}

		// draw default tag
			dp.draw(text, pt, vecX, vecY, nHeaderXAlignment, nHeaderYAlignment);
		}
	}
	

//		
//End Resolve format by entity//endregion 

	//End draw master data//endregion 

	//region Draw ChildHeader
	if (mapChildHeaders.length()>0)
	{ 
		int nc= nColor;
		double dTxtHC = dTxtH;
		String k,sDimStyleC = sDimStyle;
		Map m = mapChildHeaders;
		k="Color";			if (m.hasInt(k))		nc = m.getInt(k);
		k="TextHeight";		if (m.hasDouble(k))	dTxtHC = m.getDouble(k);
		k="DimStyle";		if (m.hasString(k))	sDimStyleC = m.getString(k);	
		for (int i=0;i<mapChildHeaders.length();i++) 
		{ 
			m = mapChildHeaders.getMap(i);
			if (m.length()<1){ continue;}
		// get format or blockName	
			String format, blockName;
			double dScale = 1;
			k="format";			if (m.hasString(k))	format = m.getString(k);
			int bFormatIsValid = format.length() > 0;
			k="BlockName";		if (m.hasString(k))	blockName = m.getString(k);
			int bBlockIsValid = blockName.length() > 0 && _BlockNames.findNoCase(blockName ,- 1) >- 1;
			if (!bFormatIsValid && !bBlockIsValid) {continue;}

		// get color textHeight overrides
			k="Color";			if (m.hasInt(k))	nc = m.getInt(k);
			k="TextHeight";		if (m.hasDouble(k))	dTxtHC = m.getDouble(k);
			k="DimStyle";		if (m.hasString(k))	sDimStyleC = m.getString(k);
			k="Scale";			if (m.hasDouble(k) && m.getDouble(k)>0)	dScale = m.getDouble(k);
			
		// get XY Offsets and Alignments
			double dOffsetX, dOffsetY;
			int nAlignmentX=1, nAlignmentY=-1;
			k="X\\Offset";		if (m.hasDouble(k))	dOffsetX = m.getDouble(k);
			k="Y\\Offset";		if (m.hasDouble(k))	dOffsetY = m.getDouble(k);
			k="X\\Alignment";	if (m.hasInt(k))	nAlignmentX = m.getInt(k);
			k="Y\\Alignment";	if (m.hasInt(k))	nAlignmentY = m.getInt(k);

		// Display
			Point3d pt = _Pt0 + vecX * dOffsetX + vecY * dOffsetY;
			Display dpc(nc);
			dpc.showInDxa(true);// Make-762
			if (_DimStyles.findNoCase(sDimStyleC,-1)>0)dpc.dimStyle(sDimStyleC);
			if (dTxtHC>0)dpc.textHeight(dTxtHC);

		// Collect (concatenated) values to display 
			if (bFormatIsValid)
			{ 
				String text;
				for (int c=0;c<childs.length();c++) 
				{ 
					Sip sip = childs[c].sipEntity();
					String _text = sip.formatObject(format);
					if (text.find(_text,0,false)<0)
						text=text+((text.length()>0?", ":"")+_text); 
				}//next index
				dpc.draw(text, pt, vecX, vecY, nAlignmentX, nAlignmentY);
			}
			else if (bBlockIsValid)
			{ 
				Block block(blockName);
				dpc.draw(block, pt, vecX*dScale, vecY*dScale, vecZ*dScale);
			}
			
		}//next i
	}
	//End Draw ChildHeader//endregion 

	//region Draw ruler dimensions
	Map mapDim = mapSetting.getMap("Dimension");	
	if (mapDim.length()>0)
	{
		double dScale = 1,dDimTxtH = U(100);
		int nDimColor = 100;
		String sDimAppendix;
		
		Map m = mapDim;
		String k;
		k = "Color"; 		if (m.hasInt(k)) nDimColor = m.getInt(k);
		k = "Appendix"; 	if (m.hasString(k)) sDimAppendix = m.getString(k);
		k = "Scale"; 		if (m.hasDouble(k)) dScale = m.getDouble(k);
		k = "Text Height"; 	if (m.hasDouble(k)) dDimTxtH = m.getDouble(k);	

	// if a max value is given and greater than the detected size	
		double _dX=mapDim.hasDouble("X\\Max")?mapDim.getDouble("X\\Max"):dX;
		double _dY=mapDim.hasDouble("Y\\Max")?mapDim.getDouble("Y\\Max"):dY;
		_dX=_dX<dX?dX:_dX;
		_dY=_dY<dY?dY:_dY;

		Point3d ptsX[] = {segMaster.ptMid()-vecX*(_dX-.5*dX)-vecY*.5*dY,segMaster.ptMid()+vecX*.5*dX+vecY*(_dY-.5*dY)};
		ptsX[0].vis(0);
		ptsX[1].vis(1);


		Display dpDim(nDimColor);
		dpDim.textHeight(dDimTxtH);
		dpDim.addHideDirection(_XW);
		dpDim.addHideDirection(-_XW);
		dpDim.addHideDirection(_YW);
		dpDim.addHideDirection(-_YW);
		dpDim.showInDxa(true);// Make-762
	
	// ruler properties
		double dInterdistances[2];
		int nCells[2];

	//region loop X and Y submaps
		for (int xy=0;xy<2;xy++) 
		{ 		
			Map m = mapDim.getMap(xy==0?"X":"Y");
			
		// ruler properties	
			String k1 ="Cells" , k2="Interdistance";
			if (m.hasInt(k1) && m.hasDouble(k2))
			{ 
				dInterdistances[xy]=m.getDouble(k2);
				nCells[xy]=m.getInt(k1);	
			}
		// dimline properties and display	
			else
			{ 
				Vector3d vecXDim = xy == 0 ? vecX:vecY;
				Vector3d vecYDim = xy == 0 ? vecY:-vecX;

				int nAlignment=-1, nChainMode, bDeltaOnTop;
				String sDimStyle = _DimStyles.length()>0?_DimStyles[0]:"";
				double dBaseLineOffset = dDimTxtH > 0 ? dDimTxtH * 4 : U(500);
				k = "Alignment"; if (m.hasInt(k)) nAlignment = m.getInt(k);
				k = "ChainModus"; if (m.hasInt(k)) nChainMode = m.getInt(k);
				k = "DeltaOnTop"; if (m.hasInt(k)) bDeltaOnTop = m.getInt(k);
				k = "DimStyle"; if (m.hasString(k)) sDimStyle = m.getString(k);
				k = "BaseLineOffset"; 	if (m.hasDouble(k)) dBaseLineOffset = m.getDouble(k);
				
			// set dimstyle
				if (sDimStyle.length()>0)
				{
					dpDim.dimStyle(sDimStyle);
					dpDim.textHeight(dDimTxtH);
				}
									
			// snap dimpoints
				Point3d ptDims[0]; ptDims = ptsX;
				int nDimSide = 1;
				if (xy == 0 && nAlignment == -1)nDimSide *= -1;
				if (xy == 1 && nAlignment == 1)nDimSide *= -1;
				
				for (int p=0;p<ptDims.length();p++) 
				{ 
					Point3d& pt= ptDims[p]; 
					Point3d pts[] = Line(pt,-vecYDim*nDimSide).orderPoints(plDimSnap.intersectPoints(Plane(pt, vecXDim)));
					if (pts.length()>0)
						pt = pts[0];
					//(nDir*vecYDim).vis(pt,2);	
				}//next p
			
			// dim ref point
				Point3d ptRefDim = segMaster.ptMid();
				if (xy==0)
					ptRefDim += .5*(-vecX*.5*dX+nAlignment*vecY*dY)+nAlignment*vecYDim * dBaseLineOffset;
				else
					ptRefDim += .5*(nAlignment*vecX*dX-vecY*dY)-nAlignment*vecYDim * dBaseLineOffset;
				ptRefDim.vis(3);
				DimLine dl(ptRefDim, vecXDim, vecYDim);
				Dim dim(dl, ptDims, "<>","<>", nChainMode);
				if (bDeltaOnTop)dim.setDeltaOnTop(true);
				dpDim.draw(dim);

			}
		}//next xy				
	
	
	//End loop X and Y submaps//endregion 
	 	
	//region DrawRuler Dimensions
	// loop x and y
		Vector3d vecXViews[]={(bAlignRight?-vecX:vecX), vecY};
		Vector3d vecYViews[]={vecY, -vecX};
		double dXs[] = {_dX, _dY};
		double dYs[] = {_dY, _dX};	
		for(int i=0;i<2;i++)
		{
			double& dInterdistance = dInterdistances[i];
			Vector3d vecXView = vecXViews[i];
			Vector3d vecYView = vecYViews[i];
			
		// order extremes and project to dimline
			Line ln(segMaster.ptMid()-vecYView*.5*((i==0?dY:dX)+dDimTxtH), vecXView);
			//ln.vis(6);
			Point3d ptsRef[] = ln.projectPoints(ln.orderPoints(ptsX));	
			if (ptsRef.length()<1)continue;
			
		// do not draw if not specified or < 0	
			if (dInterdistance <= 0)continue;
			int n = dXs[i]/dInterdistance+1;
			for(int p=0;p<n;p++)
			{
				double dDist = p*dInterdistances[i];
				Point3d pt = ptsRef[0]+vecXView *dDist;
				PLine pl(pt,pt-vecYView *dDimTxtH);
				dpDim.draw(pl);
				String sTxt;
				sTxt.formatUnit(dDist*dScale,2,0);
				sTxt+=sDimAppendix;
				dpDim.draw(sTxt,pt-vecYView *1.5*dDimTxtH, vecXView, vecYView,0,-1, _kDevice);
				
				for(int j=0;j<nCells[0];j++)
				{
					pt.transformBy(vecXView *dInterdistances[i]/nCells[i]);
					if (abs(vecXView.dotProduct(pt-ptsRef[0]))>dXs[i])break;
					dpDim.draw(PLine(pt,pt-vecYView *.5*dDimTxtH));
				}
			}// next p	
			
		}// next i			
	//End DrawRuler Dimensions//endregion 	

	}	
		
//End Draw ruler dimensions//endregion 
	
//End Draw Graphics//endregion 

//region Plot Viewport Creation
	int bCreatePV = bDebug;
	
	if (_Map.getInt("CreatePlotViewport"))
	{
		_Map.removeAt("CreatePlotViewport", true);
		
		if(IntersectsWithPlotViewport(master)<1)
			bCreatePV = true;
	}


	if (bCreatePV && mapPlotViewports.length() > 0)
	{ 
		String sExistingLayouts[] = Layout().getAllEntryNames();
		
	// Collect specified layouts	
		double dMaxLengths[0];
		double dXOffsets[0];
		double dYOffsets[0];
		String sLayoutNames[0];
		
		for (int i=0;i<mapPlotViewports.length();i++) 
		{ 
			Map m = mapPlotViewports.getMap(i); 
			String sLayoutName = m.getString("Layout");
			int bIsActive= m.getInt("active");
			if (bIsActive && sLayoutName.length()>0 && sLayoutNames.findNoCase(sLayoutName,-1)<0 && sExistingLayouts.findNoCase(sLayoutName,-1)>-1)
			{ 
				sLayoutNames.append(sLayoutName);
				dXOffsets.append(m.getDouble("XOffset"));
				dYOffsets.append(m.getDouble("YOffset"));
				dMaxLengths.append(m.getDouble("MaxLength"));	
			}
		}//next i
		
	// order by max length
		for (int i=0;i<sLayoutNames.length();i++) 
			for (int j=0;j<sLayoutNames.length()-1;j++) 
				if (dMaxLengths[j]>dMaxLengths[j+1])
				{
					sLayoutNames.swap(j, j + 1);
					dXOffsets.swap(j, j + 1);
					dYOffsets.swap(j, j + 1);
					dMaxLengths.swap(j, j + 1);
				}
		
	// take first matching, else fall back to first maxLength=0
		String layoutName;
		for (int i=0;i<sLayoutNames.length();i++) 
		{ 
			if (dMaxLengths[i]>0 && dX<=dMaxLengths[i])
			{ 
				layoutName = sLayoutNames[i];
				break;
			}
		}
		
		if (layoutName.length()==0)
		{ 
			for (int i=0;i<sLayoutNames.length();i++) 
				if (dMaxLengths[i]<=0)
				{ 
					layoutName = sLayoutNames[i];
					break;
				}
		}

	// Create PlotViewport
		if (sExistingLayouts.findNoCase(layoutName,-1)>-1)
		{ 
			int n = sLayoutNames.findNoCase(layoutName ,- 1);
			
			Point3d ptLowerLeft = segMaster.ptMid()-.5*(_XW*dX+_YW*dY)-_XW*dXOffsets[n];
//			Point3d ptLowerLeft = segMaster.ptMid()-_XW*(.5*dX+dXOffsets[n])-_YW*(dYOffsets[n]+.5*dY);
			//ptLowerLeft.vis(3);
			pv.dbCreate(layoutName, ptLowerLeft); 
			if (pv.bIsValid())
			{
				pv.transformBy(_YW * (dYOffsets[n] + dY - pv.dY()));
				pv.setColor(252);
				_Entity.append(pv);
			}
		}	
	}	
//END Plot Viewport Creation //endregion 

//region PlotViewport Formatting
	if (pv.bIsValid())
	{ 
		CoordSys cs = pv.coordSys();
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();
		Point3d pt = cs.ptOrg();
		PLine plPV;
		plPV.createRectangle(LineSeg(pt, pt+vecX*pv.dX() + vecY*pv.dY()), vecX, vecY);
		plPV.vis(2);
		
		PlaneProfile ppPV(CoordSys());
		ppPV.joinRing(plPV, _kAdd);
		String formatPV = T("|Masterpanel|")+" @(Number:PL3;0)";
		
		Entity entMasters[] = Group().collectEntities(true, MasterPanel(), _kModelSpace);
		String names[0];
		for (int i=0;i<entMasters.length();i++) 
		{ 
			MasterPanel mp= (MasterPanel)entMasters[i]; 
			PLine plShape = mp.plShape();
			PlaneProfile ppm(CoordSys());
			ppm.joinRing(plShape, _kAdd);
			
			if (ppm.intersectWith(ppPV) && ppm.area()>.5*plShape.area() && mp.number()>-1)
				names.append(mp.formatObject(formatPV));
		}//next i
		
		String name = master.formatObject(formatPV);
		if (names.length()>1)
		{ 
			name = "";
			names = names.sorted();
			for (int i=0;i<names.length();i++) 
				name+=(i>0?"_":"")+names[i]; 

		}
					
		if (pv.name()!=name)	
			pv.setName(name);
	
	}
//endregion 




//region Trigger

	//region Trigger Set feeeding direction
	if(bAddFeedDirection)
	{ 
		String sXFeedTrigger= T("../|Set X-parallel feeding direction|");
		addRecalcTrigger(_kContext, sXFeedTrigger);
		String sYFeedTrigger= T("../|Set Y-parallel feeding direction|");
		addRecalcTrigger(_kContext, sYFeedTrigger);
		if (_bOnRecalc && (_kExecuteKey==sXFeedTrigger || _kExecuteKey==sYFeedTrigger) )
		{		
			int bIsYFeed = _kExecuteKey == sYFeedTrigger;
	
		// selection of elements
			PrEntity ssE(T("|Select ChildPanel(s)|") + " " + T(", |<Enter> to select all|") , ChildPanel());
			Entity ents[0]; 		
			if (ssE.go())
		    	ents = ssE.set();
	
		// collect childs
			ChildPanel childsFeed[0];
			if (ents.length()<1)
				childsFeed=childs;
			else
			{
				for(int i=0;i<ents.length();i++)
				{
					ChildPanel child = (ChildPanel)ents[i];
					if (child.bIsValid() && childsFeed.find(child)<0)
						childsFeed.append(child);
		
				}
			}
			
		// at least one child required
			if (childsFeed.length()<1)
			{
				reportMessage(TN("|No child panels found.|"));
				return;	
			}
		
		/// get direction vector
			Sip sip =childsFeed[0].sipEntity();
			CoordSys cs = childsFeed[0].sipToMeTransformation();		
			Vector3d vecX = sip.vecX();		
			Vector3d vecY = sip.vecY();
			Vector3d vecZ = sip.vecZ();	
			vecX.transformBy(cs);
			vecY.transformBy(cs);
			vecZ.transformBy(cs);
			
			Point3d pt1 =sip.ptCen(); pt1.transformBy(cs);// childsFeed[0].realBody().ptCen();
			Point3d pt2=pt1+vecX*U(200);
			
			PrPoint ssP("\n" + T("|Select direction|") + " " + T(", |<Enter> to remove feeding direction|"), pt1); 	
			if (ssP.go()==_kOk) 
			{
				if (bDebug) reportMessage("\n" + scriptName() + ": " +"adding feeding direction");
	
				pt2= ssP.value();	
				pt1.setZ(0);
				pt2.setZ(0);
				
			//	get feed vector, default is vecX
				Vector3d vecRefFeed = pt2-pt1;
				Vector3d vecRefSide;
				if (vecRefFeed.bIsZeroLength())
					vecRefFeed=bIsYFeed?vecY:vecX;
		
			// special display for parallel feeds deprecated HSB-8788	
	//			else if (vecRefFeed.isParallelTo(vecX) || vecRefFeed.isParallelTo(vecY)) //only feeding directions including reference side supported	
	//				vecRefFeed.normalize();
				else
				{ 
					Vector3d _vecX = (bIsYFeed ? vecY : vecX);
					Vector3d _vecY = (bIsYFeed ? vecX : vecY);
					
					int nXDir = vecRefFeed.dotProduct(_vecX) < 0 ?- 1 : 1;
					int nYDir = vecRefFeed.dotProduct(_vecY) < 0 ?- 1 : 1;
					vecRefFeed=nXDir*_vecX;
					vecRefSide = nYDir * _vecY;
				}
			
			// write vecRefFeed to each panel
				for(int i=0;i<childsFeed.length();i++)
				{
					ChildPanel child = childsFeed[i];
					Sip sip= child.sipEntity();
					CoordSys cs = child.sipToMeTransformation();
					cs.invert();
					Vector3d vecRefFeedSip = vecRefFeed;
					vecRefFeedSip.transformBy(cs);
					vecRefFeedSip.normalize();
		
				// set map
					Map map;
					map.setVector3d("vecRefFeed", vecRefFeedSip );

				// add side if set
					if (!vecRefSide.bIsZeroLength())
					{ 
						Vector3d vecRefSideSip = vecRefSide;
						vecRefSideSip.transformBy(cs);
						vecRefSideSip.normalize();	
						map.setVector3d("vecRefSide", vecRefSideSip);	
					}
					// set output feed text
					if (sFeedText.length() > 0)map.setString("Text", sFeedText);
					
				// XRef
					String xrefName = sip.xrefName();
					int nLockErr;
					if (xrefName!="")
					{ 
						XrefLocker locker;
						nLockErr = locker.lockDatabaseOf(sip);
						sip.setSubMapX("CncData", map);
		
					}
				// not xRef	
					else
					{
						sip.setSubMapX("CncData", map);	
					}
					child.transformBy(Vector3d(0,0,0));
					if (bDebug) reportMessage("\n	"  + ": " +sip.handle());
				}	
			}
		// remove feed directions	
			else
			{
				if(bDebug)reportMessage("\n"+ scriptName() + " removing feeds of " + childsFeed.length());
				
				for(int i=0;i<childsFeed.length();i++)
				{
					ChildPanel child = childsFeed[i];
					Sip sip= child.sipEntity();	
	
				// XRef
					String xrefName = sip.xrefName();
					int nLockErr;
					if (xrefName != "")
					{
						XrefLocker locker;
						nLockErr = locker.lockDatabaseOf(sip);
						sip.removeSubMapX("CncData");
					}
				// no xRef
					else
					{
						sip.removeSubMapX("CncData");	
					}
					child.transformBy(Vector3d(0,0,0));
					if (bDebug) reportMessage("\n	"  + " removing: " +sip.handle());
				}		
			}
		}			
	}			
//End set feeeding direction trigger//endregion 

	//region Trigger RotateChild
	String sTriggerRotateChild = T("|Rotate Child|");
	addRecalcTrigger(_kContextRoot, sTriggerRotateChild );
	String sTriggerFlipRotateChild = T("|Flip + Rotate Child|");
	if(bFlipAllowed)addRecalcTrigger(_kContextRoot, sTriggerFlipRotateChild );
	String sTriggerFlipChild = T("|Flip Child|");
	if(bFlipAllowed)addRecalcTrigger(_kContextRoot, sTriggerFlipChild );

	String sFlipTriggers[] ={sTriggerRotateChild,sTriggerFlipRotateChild,sTriggerFlipChild};
	int nFlipRotateTrigger = sFlipTriggers.find(_kExecuteKey);
	if (_bOnRecalc && nFlipRotateTrigger>-1)
	{
	// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select child panels|"), ChildPanel());
		if (ssE.go())
			ents.append(ssE.set());
					
	// rotate
		for (int i=0;i<ents.length();i++) 
		{ 
			ChildPanel child = (ChildPanel)ents[i];
			PlaneProfile pp = child.realBody().shadowProfile(Plane(_Pt0, vecZ));
			CoordSys csRot;
			csRot.setToRotation(180, vecZ, pp.extentInDir(vecX).ptMid());
			if (nFlipRotateTrigger!=2)
			{
				if (entRotatedChilds.find(child) < 0)entRotatedChilds.append(child);
				child.transformBy(csRot);
			}
			if (nFlipRotateTrigger!=0 && bFlipAllowed)
			{
				child.setBIsFlipped(child.bIsFlipped() ? false : true);
				reportNotice("\n" + scriptName() + ": " +"flipping child...");
				
			}
		}//next i
		
	// store all rotated childs to prevent 180° rotation with AutoNester5	
		_Map.setEntityArray(entRotatedChilds,false,"RotatedChild[]","","RotatedChild");
//		if (ents.length()>0)
//			_Map.setInt("callNester", true);	
		setExecutionLoops(2);
		return;
	}//endregion	

	//region Trigger WriteMasterData
	String sTriggerWriteMasterData = T("|Add Masterpanel Data to Panels|");
	addRecalcTrigger(_kContextRoot, sTriggerWriteMasterData );
	if (_bOnRecalc && (_kExecuteKey==sTriggerWriteMasterData || _kExecuteKey==sDoubleClick))
	{	
		Map m;
		m.setString("Information", master.information());
		m.setString("Name", master.name());
		m.setString("Number", master.number());
		m.setString("FullPathName", _kPathDwg);
		m.setString("FileName", dwgName());
		
		
	//loop childs
		for (int i=0;i<childs.length();i++)	
		{ 
			Sip sip = childs[i].sipEntity();
			
		// XRef
			if (sip.xrefName() != "")
			{
				XrefLocker locker;
				int nLockErr = locker.lockDatabaseOf(sip);
				sip.setSubMapX(kMasterXName, m);
			}
		// no xRef
			else			
				sip.setSubMapX(kMasterXName, m);	
		}
		setExecutionLoops(2);
		return;
	}//endregion
	
	//region Trigger RemoveMasterData
	if (bPanelsHaveMasterData)
	{ 
		String sTriggerRemoveMasterData = T("|Remove Masterpanel Data from Panels|");
		addRecalcTrigger(_kContextRoot, sTriggerRemoveMasterData );
		if (_bOnRecalc && (_kExecuteKey==sTriggerRemoveMasterData || _kExecuteKey==sDoubleClick))
		{
			
		//loop childs
			for (int i=0;i<childs.length();i++)	
			{ 
				Sip sip = childs[i].sipEntity();
				sip.removeSubMap(kMasterXName);	
			}				
			setExecutionLoops(2);
			return;
		}		
	}//endregion

	//region Exporter
// register potentially defined exporter groups
	Map mapExporterGroups = mapSetting.getMap("ExporterGroup[]");	
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
				addRecalcTrigger(_kContext,s);
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
			TN("|Please review your exporter configurations and/or adjust settings of|") +"\n	" +  scriptName() + "\n\n************************************************************************************" );
		}
		else
		{
		// get selection set
			PrEntity ssE(T("|Select masterpanel(s)|") + " " + T("|<Enter> to proceed with current|"), MasterPanel());
			Entity ents[0];
			if (ssE.go())
				ents = ssE.set();		
			if (ents.length()<1)ents.append(master);

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
	}
	
		
//End Exporter//endregion 

//region Trigger ToggleAutoSize
//	int bAutoSizeDisabled = _Map.getInt("ToggleAutoSize");
//	if (mapGrid.length()>0)
//	{ 
//		String sTriggerToggleAutoSize =bAutoSizeDisabled?T("|Auto Size on|"):T("|Auto Size off|");
//		addRecalcTrigger(_kContext, sTriggerToggleAutoSize);
//		if (_bOnRecalc && _kExecuteKey==sTriggerToggleAutoSize)
//		{
//			bAutoSizeDisabled = bAutoSizeDisabled ? false : true;
//			_Map.setInt("ToggleAutoSize", bAutoSizeDisabled);		
//			setExecutionLoops(2);
//			return;
//		}		
//	}

// toggle the auto edge alignment 
	{ 
		String sTriggerToggleAutoEdge =bAutoEdgeAlignmentDisabled?T("|Auto Edge Alignment on|"):T("|Auto Edge Alignment off|");
		addRecalcTrigger(_kContext, sTriggerToggleAutoEdge);
		if (_bOnRecalc && _kExecuteKey==sTriggerToggleAutoEdge)
		{
			bAutoEdgeAlignmentDisabled = bAutoEdgeAlignmentDisabled ? false : true;
			_Map.setInt("ToggleAutoEdgeAlignment", bAutoEdgeAlignmentDisabled);	
			
				// collect childs for automatic edge alignment
			if (!bAutoEdgeAlignmentDisabled)
			{
				Entity ents[0];
				for (int i=0;i<childs.length();i++) ents.append(childs[i]); 
				_Map.setEntityArray(ents,false,"EdgeAlignment[]","","EdgeAlignment");
			}
			
			
			setExecutionLoops(2);
			return;
		}		
	}


	// Trigger EdgeAlignment
	String sTriggerEdgeAlignment = T("|Align panels with edge|");
	addRecalcTrigger(_kContextRoot, sTriggerEdgeAlignment );
	if (_bOnRecalc && _kExecuteKey==sTriggerEdgeAlignment)
	{
	// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select child panels to align|") + T(", |<Enter> = all|"), ChildPanel());
		if (ssE.go())
			ents.append(ssE.set());
		if (ents.length()<1)
		{ 
			for (int i=0;i<childs.length();i++) 
				ents.append(childs[i]); 	
		}
		_Map.setEntityArray((ents.length()<1?childs:ents),false,"EdgeAlignment[]","","EdgeAlignment");						
		setExecutionLoops(2);
		return;
	}	
//endregion

//region Trigger Create / LinkPlotViewPort
	String sTriggerCreatePlotViewPort = T("|Create Plot Viewport|");
	String sTriggerLinkPlotViewPort = T("|Link Plot Viewport|");	
	if (!pv.bIsValid() && HasActivePlotViewport(mapPlotViewports))
	{
		addRecalcTrigger(_kContextRoot, sTriggerCreatePlotViewPort );
		//addRecalcTrigger(_kContextRoot, sTriggerLinkPlotViewPort );
	}
	if (_bOnRecalc && _kExecuteKey==sTriggerCreatePlotViewPort)
	{
		_Map.setInt("CreatePlotViewport", true);
		setExecutionLoops(2);
		return;		
	}
//	if (_bOnRecalc && _kExecuteKey==sTriggerLinkPlotViewPort)
//	{
//	// prompt for entities
//		Entity ents[0];
//		PrEntity ssE(T("|Select plot viewport|"),  PlotViewport());
//		if (ssE.go())
//			ents.append(ssE.set());	
//		for (int i=0;i<ents.length();i++) 
//		{ 
//			PlotViewport pvNew = (PlotViewport)ents[i];
//			if (pvNew.bIsValid())
//			{ 
//				_Entity.append(pvNew);
//				break;
//			}
//		}//next i
//			
//		setExecutionLoops(2);
//		return;
//	}
//endregion	


//End TRIGGER//endregion 


//region Append mapX data to enrich the data of masterpanel and help
	master.setSubMapX(kMasterXName, mapAdditionalMaster);	
// set help link
	_ThisInst.setHyperlink("https://hsbcad.uservoice.com/knowledgebase/articles/948457-tsl-nesting");		
//End append mapX data to enrich the data of masterpanel and help//endregion 


//region Trigger
{
	// create TSL
	TslInst tslDialog;			Map mapTsl;
	GenBeam gbsTsl[] = { };		Entity entsTsl[] = { };			Point3d ptsTsl[] = { _Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };
	
	//region Trigger ConfigureSettings
	String sTriggerConfigureDisplay = T("|Configure Settings|");
	addRecalcTrigger(_kContext, "___________________________");
	addRecalcTrigger(_kContext, sTriggerConfigureDisplay );
	if (_bOnRecalc && _kExecuteKey == sTriggerConfigureDisplay)
	{
		// prepare dialog instance
		mapTsl.setInt("DialogMode", 1);
		
		
		Map mapBlocks;
		String names[0];names = _BlockNames;		
		for (int i=0;i<names.length();i++) 
		{
			if (names[i].left(1)!="*")
				mapBlocks.appendString("entry", names[i]); 
		}
		mapTsl.setMap("BlockName[]", mapBlocks);
		
		
		// geo
		dProps.append(dMaxLength);				// 0
		dProps.append(dMaxWidth);				// 1
		dProps.append(dMasterOversizeX);		// 2
		dProps.append(dMasterOversizeY);		// 3
		sProps.append(bAddOpeningToMaster?sAddOpeningToMasters[1]:sAddOpeningToMasters[0]);		// 0
		
		// align
		sProps.append(bAlignRight? T("|Right|"):T("|Left|"));			// 1
		sProps.append(bKeepFloorReferenceBottom?T("|Yes|"):T("|No|") );	// 2
		dProps.append(dRowOffset);			// 4
		
		// out
		nProps.append(nStartNumber);		// 0

		// display
		sProps.append(sDimStyle);			// 3
		nProps.append(nColor);				// 1
	
		sProps.append(sDimStyleChild);		// 4
		nProps.append(nColorChildText);		// 2
	
		sProps.append(sLineType);			// 5
		dProps.append(dLineTypeScaleFactor<=0?1	:dLineTypeScaleFactor);	// 5
		nProps.append(nColorChildOutline);	// 3
		
		// display tag	
		sProps.append(sHeaderBlockName);// blockname			// 6
		dProps.append(dHeaderXOffset);// x-offset				// 6
		dProps.append(dHeaderYOffset);// y-offset				// 7
		dProps.append(dTextHeightHeader);// textHeightHeader	// 8
		nProps.append(nColorHeader);	// 4
		
		nProps.append(nTransparencyChild);		// 5
		
		//autosize
		dGridXValues = getDoublesValueMap(mapGrid.getMap("X\\Value[]"));
		dGridYValues = getDoublesValueMap(mapGrid.getMap("Y\\Value[]"));
		dProps.append(dAutoSizeMinimumX);				// 9
		dProps.append(dAutoSizeMinimumY);				// 10
		
		if (bHasAutoRangeX)
			sProps.append(semicolonToString2(dMinRangesX, dMaxRangesX, dRangeValuesX));	// 7			
		else
			sProps.append(toSemicolonString(dGridXValues));	// 7	
		sProps.append(toSemicolonString(dGridYValues));	// 8		

		dProps.append(dCeilingX);				// 11
		dProps.append(dCeilingY);				// 12

		sProps.append(bAutoCreationPlotViewport?T("|Yes|"):T("|No|") );	// 9


		sProps.append(sMasterStyleDwgName);//10
		sProps.append(sLengthWiseKey);//11
		sProps.append(sCrossWiseKey);//12
		sProps.append(sMasterStyleDelimiter);//13
		


		tslDialog.dbCreate(scriptName() , _XW, _YW, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);

		if (tslDialog.bIsValid())
		{
			//tslDialog.setPropString(6,sHeaderBlockName);
			int bOk = tslDialog.showDialog();
			if (bOk)
			{	
				// geo
				mapSetting.setDouble("Length", tslDialog.propDouble(0));
				mapSetting.setDouble("Width", tslDialog.propDouble(1));
				mapSetting.setDouble("MasterOversize", tslDialog.propDouble(2));
				mapSetting.setDouble("MasterOversizeY", tslDialog.propDouble(3));
				mapSetting.setInt("AddOpeningToMaster", sAddOpeningToMasters.find(tslDialog.propString(0)));

				// align
				//mapSetting.setString("MasterOversize", tslDialog.propString(1)==T("|Right|")?true:false);
				mapSetting.setInt("KeepFloorReferenceBottom", tslDialog.propString(2)==T("|Yes|")?true:false);
				mapSetting.setDouble(kMasterRowOffset, tslDialog.propDouble(4));
				
				// out
				mapSetting.setInt("MasterStartNumber", tslDialog.propInt(0));
				
				// plot viewport
				mapSetting.setInt("AutoCreationPlotViewport", tslDialog.propString(9)==T("|Yes|")?true:false);
				
				//Autosize
				{
					Map mapAutoSize;
					dAutoSizeMinimumX = tslDialog.propDouble(9);
					dAutoSizeMinimumY = tslDialog.propDouble(10);
					
					dCeilingX = tslDialog.propDouble(11);
					dCeilingY = tslDialog.propDouble(12);
	
					String s7 = tslDialog.propString(7);
					if (s7.find("-",0,false)>-1 && s7.find("=",0,false)>-1)
					{
						mapRangeX = semicolonToDoubles2(s7, dMinRangesX, dMaxRangesX, dRangeValuesX);
						dGridXValues.setLength(0);
					}
					else
					{
						dGridXValues = semicolonToDoubles(s7);
						mapRangeX=Map();
					}
					
					String s8 = tslDialog.propString(8);
					if (s8.find("-",0,false)>-1 && s8.find("=",0,false)>-1)
					{
						mapRangeY = semicolonToDoubles2(s8, dMinRangesY, dMaxRangesY, dRangeValuesY);
						dGridYValues.setLength(0);
					}
					else
					{
						dGridYValues = semicolonToDoubles(s8);
						mapRangeY=Map();
					}					

					setAutoSizeMap(mapAutoSize, "X", dAutoSizeMinimumX, dCeilingX, dGridXValues, mapRangeX);
					setAutoSizeMap(mapAutoSize, "Y", dAutoSizeMinimumY, dCeilingY, dGridYValues, mapRangeY);
					
					if (mapAutoSize.length()>0)
						mapSetting.setMap("AutoSize", mapAutoSize);
				}

				// Display
				mapSetting.setString("DimStyle", tslDialog.propString(3));
				mapSetting.setInt("Color", tslDialog.propInt(1));
				
				dTextHeightHeader = tslDialog.propDouble(8);
				nColorHeader = tslDialog.propInt(4);
				sHeaderBlockName = tslDialog.propString(6);
				// header tag
				{
					Map m, mx, my;
					m = mapSetting.getMap("Header");
					m.setInt("Color", nColorHeader);
					m.setDouble("TextHeight", dTextHeightHeader);
					
					if (_BlockNames.findNoCase(sHeaderBlockName,-1)<0)
						m.removeAt("BlockName", false);
					else
						m.setString("BlockName", sHeaderBlockName);
					

					mx.setDouble("Offset", tslDialog.propDouble(6));
					m.setMap("X",mx);
					
					my.setDouble("Offset", tslDialog.propDouble(7));
					m.setMap("Y",my);
					
					mapSetting.setMap("Header",m);

				}
				
				// Child Display
				{ 
					Map m;
					m.setString("DimStyle", tslDialog.propString(4));
					m.setInt("ColorText", tslDialog.propInt(2));
					m.setInt("Transparency", tslDialog.propInt(5));
					
					m.setString("Linetype", tslDialog.propString(5));
					m.setDouble("LineTypeScaleFactor", tslDialog.propDouble(5));
					m.setInt("Color", tslDialog.propInt(3));
					
					mapSetting.setMap("ChildDisplay",m);					
				}
				
				// Masterpanel Style
				{ 
					Map m;
					String fileName = tslDialog.propString(10);
					if (findFile(fileName).length()>0)
						m.setString("StyleDwg", fileName);
					m.setString("LengthWiseKey", tslDialog.propString(11));
					m.setString("CrossWiseKey", tslDialog.propString(12));
					m.setString("Delimiter", tslDialog.propString(13));
					mapSetting.setMap("Masterpanel Style",m);
				}
				
				

				
			// purge legacy entries
				if (mapSetting.hasDouble("LineTypeScaleFactor"))mapSetting.removeAt("LineTypeScaleFactor", true);
				if (mapSetting.hasString("Linetype"))mapSetting.removeAt("Linetype", true);

				
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);
			}
			tslDialog.dbErase();
		}
		setExecutionLoops(2);
		return;

	}

//region Trigger Configure Plot Viewports // HSB-22958
	String sTriggerConfigurePlotViewports = T("|Configure Plot Viewports|");
	addRecalcTrigger(_kContext, sTriggerConfigurePlotViewports );
	if (_bOnRecalc && _kExecuteKey==sTriggerConfigurePlotViewports)
	{

		String entries[] = Layout().getAllEntryNames();	

	//region Dialog config
		Map rowDefinitions;// = mapIn.getMap(kRowDefinitions);
		int numRows = rowDefinitions.length();
		double dHeight = entries.length() < 5 ? 500 : entries.length()  * 35+120;

		Map mapDialog ;
	    Map mapDialogConfig ;
	    mapDialogConfig.setString("Title",T("|Layout Selection|"));
	    
	    mapDialogConfig.setDouble("Height", dHeight);
	    mapDialogConfig.setDouble("Width", 1200);
	    mapDialogConfig.setDouble("MaxHeight",800);
	    //mapDialogConfig.setDouble("MaxWidth", 3000);
	    mapDialogConfig.setDouble("MinHeight", 300);
	    mapDialogConfig.setDouble("MinWidth", 800);
	   // mapDialogConfig.setInt("AllowRowAdd", 1);
	    
	    mapDialogConfig.setString("Description",T("|Select the layouts which should be used to create a plotviewport|"));

	    mapDialog.setMap("mpDialogConfig", mapDialogConfig);				
	//endregion 

	//region Columns	
		
		Map columnDefinitions;
		{ 
			Map column;
		    column.setString(kControlTypeKey, kLabelType);
		    column.setString(kHorizontalAlignment, kLeft);
		    column.setString(kHeader,T("|Layout|"));
	    	//column.setString("ToolTip", tToolTipCriteria);   
		    columnDefinitions.setMap("Layout", column);			
		}
		{ 
			Map column;
		    column.setString(kControlTypeKey, kCheckBox);
		    column.setString(kHorizontalAlignment, kCenter);
		    column.setString(kHeader,T("|Active|"));
	    	//column.setString("ToolTip", tToolTipCriteria);   
		    columnDefinitions.setMap("Active", column);			
		}		
		{ 
			Map column;
		    column.setString(kControlTypeKey, kDoubleBox);
		    column.setString(kHorizontalAlignment, kStretch);
		    column.setString(kHeader,T("|Max Length|"));
	    	//column.setString("ToolTip", tToolTipCriteria);   
		    columnDefinitions.setMap("MaxLength", column);			
		}
		{ 
			Map column;
		    column.setString(kControlTypeKey, kDoubleBox);
		    column.setString(kHorizontalAlignment, kStretch);
		    column.setString(kHeader,T("|Offset X|"));
	    	//column.setString("ToolTip", tToolTipCriteria);   
		    columnDefinitions.setMap("XOffset", column);			
		}		
		{ 
			Map column;
		    column.setString(kControlTypeKey, kDoubleBox);
		    column.setString(kHorizontalAlignment, kStretch);
		    column.setString(kHeader,T("|Offset Y|"));
	    	//column.setString("ToolTip", tToolTipCriteria);   
		    columnDefinitions.setMap("YOffset", column);			
		}		
		mapDialog.setMap("mpColumnDefinitions", columnDefinitions);			
	//endregion 

	//region Rows
	
		// get potential settings	
		Map mapSelections = mapSetting.getMap("PlotViewport[]");
			
		for (int i=0;i<entries.length();i++) 
		{ 
			String label = entries[i];
			Map row;

			double dXOffset, dYOffset, dMaxLength;
			int bIsActive;
			
			for (int x=0;x<mapSelections.length();x++) 
			{ 
				Map mx = mapSelections.getMap(x); 
				String layout = mx.getString("Layout");
				if (label.find(layout, 0,false)==0 && label.length()==layout.length())
				{ 
					bIsActive = mx.getInt("active");
					dMaxLength = mx.getDouble("MaxLength");
					dXOffset = mx.getDouble("XOffset");
					dYOffset = mx.getDouble("YOffset");
					break;
				}			 
			}//next x
			row.setString("Layout", label);	// label
			row.setInt("Active", bIsActive);//bShowTools[i]);
			row.setDouble("MaxLength", dMaxLength);	// max length
			row.setDouble("XOffset", dXOffset);	// x-offset
			row.setDouble("YOffset", dYOffset);	// y-offset
			rowDefinitions.appendMap("row"+i, row);	
			
			//dDiaHeight += U(50);
		}//next i	
	
	
	
	    mapDialog.setMap(kRowDefinitions, rowDefinitions);			
	//endregion 
	
		//mapDialog.writeToXmlFile("c:\\temp\\mapDialogMPM.xml");
		Map mapRet = callDotNetFunction2(sDialogLibrary, sClass, showDynamic, mapDialog);
		//mapRet.writeToXmlFile("c:\\temp\\mapDialogReturnMPM.xml");
	
	
		mapSelections = Map();
		for (int i=0;i<mapRet.length();i++) 
		{ 
			Map m = mapRet.getMap(i);
			String label = m.getString("Layout");

		// entry found: store in selection map	
			if (entries.findNoCase(label,-1)>-1)
			{ 
				Map mx;
				mx.setString("Layout", label);
				mx.setInt("Active", m.getInt("Active"));
				mx.setDouble("maxLength",  m.getDouble("maxLength"));
				mx.setDouble("XOffset", m.getDouble("XOffset"));
				mx.setDouble("YOffset", m.getDouble("YOffset"));
				mapSelections.appendMap("Entry", mx);				
			}
		}//next i
	

		if (mapSelections.length()>0)
		{ 	
			mapSelections.writeToXmlFile("c:\\temp\\mapSelections.xml");
			if (!HasActivePlotViewport(mapSelections))
				mapSetting.removeAt("PlotViewport[]", true);			
			else
				mapSetting.setMap("PlotViewport[]", mapSelections);
			if (mo.bIsValid())mo.setMap(mapSetting);
			else mo.dbCreate(mapSetting);			
		}
	
	
		setExecutionLoops(2);
		return;
	}//endregion	
//
////region Trigger ConfigurePlotViewports
//	String sTriggerConfigurePlotViewports = T("|Configure Plot Viewports|");
//	addRecalcTrigger(_kContext, sTriggerConfigurePlotViewports );
//	if (_bOnRecalc && _kExecuteKey==sTriggerConfigurePlotViewports)
//	{
//	// get potential settings	
//		Map mapSelections = mapSetting.getMap("PlotViewport[]");
//	
//	// Add column definitions
//		String sHeaders[] = { T("|Layout|"), T("|Active|"),T("|Max Length|"),  T("|Offset X|"),T("|Offset Y|") };
//		double dColumnWidths[] = { U(50), U(20), U(40), U(40), U(40)};// 1.5, .1, .2, .2, .2};;
//		double dDiaWidth= U(450); 
//	//	for (int i=0;i<dColumnWidths.length();i++) 
//	//		dDiaWidth+= dColumnWidths[i]*100; 
//		{ 
//	
//			int n;
//			AddDiaColumn(mapDiaColumnDefinitions, "Label", sHeaders[n], "Left", dColumnWidths[n], T("|The layout name for a plot viewport|"));	n++;
//			AddDiaColumn(mapDiaColumnDefinitions, "CheckBox", sHeaders[n], "Center", dColumnWidths[n], T("|Toggle to include the tool into the analysis|")); n++;
//			AddDiaColumn(mapDiaColumnDefinitions, "DoubleBox", sHeaders[n], "Right", dColumnWidths[n], T("|The max length of the masterpanel to use this layout (0 = any)|"));n++;
//			AddDiaColumn(mapDiaColumnDefinitions, "DoubleBox", sHeaders[n], "Right", dColumnWidths[n], T("|The base offset in x-direction|"));n++;
//			AddDiaColumn(mapDiaColumnDefinitions, "DoubleBox", sHeaders[n], "Right", dColumnWidths[n], T("|The base offset in y-direction|"));
//		
//		}
//		mapDia.setMap("mpColumnDefinitions", mapDiaColumnDefinitions);
//	
//	// The dialog shows the available layouts
//		double dDiaHeight = U(75);
//		String entries[] = Layout().getAllEntryNames();
//		
//		
//		for (int i=0;i<entries.length();i++) 
//		{ 
//			String label = entries[i];
//			Map m;
//
//			double dXOffset, dYOffset, dMaxLength;
//			int bIsActive;
//			
//			for (int x=0;x<mapSelections.length();x++) 
//			{ 
//				Map mx = mapSelections.getMap(x); 
//				String layout = mx.getString("Layout");
//				if (label.find(layout, 0,false)==0 && label.length()==layout.length())
//				{ 
//					bIsActive = mx.getInt("active");
//					dMaxLength = mx.getDouble("MaxLength");
//					dXOffset = mx.getDouble("XOffset");
//					dYOffset = mx.getDouble("YOffset");
//					break;
//				}			 
//			}//next x
//	
//			m.setString(sHeaders[1], bIsActive);//bShowTools[i]);
//			m.setInt(sHeaders[1], bIsActive);//bShowTools[i]);
//			m.setDouble(sHeaders[2], dMaxLength);	// max length
//			m.setDouble(sHeaders[3], dXOffset);	// x-offset
//			m.setDouble(sHeaders[4], dYOffset);	// y-offset
//			mapDiaRowDefinitions.appendMap(entries[i], m);	
//			
//			dDiaHeight += U(50);
//		}//next i	
//	
//	
//		mapDia.setMap("mpRowDefinitions", mapDiaRowDefinitions);
//	
//	//region Dialog Size and Content
//		double dDiaMaxHeight = U(800);
//		mapDiaConfig.setString("Title", T("|Layout Selection|"));
//		mapDiaConfig.setString("Description",T("|Select the layouts which should be used to create a plotviewport|"));
//		mapDiaConfig.setDouble("Width", dDiaWidth);
//		mapDiaConfig.setDouble("Height",dDiaHeight > dDiaMaxHeight ? dDiaMaxHeight : dDiaHeight);
//	//
//	//	mapDiaConfig.setDouble("MaxWidth",1200);//dViewHeight*0.1);
//	//	mapDiaConfig.setDouble("MaxHeight",1200);//dViewHeight*.01);
//		
//	//	mapDiaConfig.setDouble("MinWidth", U(600));
//	//	mapDiaConfig.setDouble("MinHeight",U(300));
//		
//		mapDia.setMap("mpDialogConfig", mapDiaConfig);		
//	//endregion 	
//	
//	//region Function ShowMultiDialog
//	// shows the map based multi dialog
//	Map ShowMultiDialog(Map mapDia)
//	{ 
//		Map mapSelections;
//		
//		Map out = callDotNetFunction2(sDialogLibrary, sClass, "ShowDynamicDialog", mapDia);	
//		for (int i=0;i<out.length();i++) 
//		{ 
//			Map m = out.getMap(i);
//			
//			String subType, label = out.keyAt(i);
//			
//		// the dialog shows the translated with a translated key	
//			int bActive = m.hasInt(sHeaders[1])?m.getInt(sHeaders[1]):true;
//			double dMaxLength = m.hasDouble(sHeaders[2])?m.getDouble(sHeaders[2]):0; 			
//			double dXOffset = m.hasDouble(sHeaders[3])?m.getDouble(sHeaders[3]):0; 
//			double dYOffset = m.hasDouble(sHeaders[4])?m.getDouble(sHeaders[4]):0; 
//			
//			//reportNotice("\ni"+ i + " label: "+ label + " " + bShowTool + " " + color)	;	
////
////		// find corresponding untranslated
////			for (int j=0;j<subTypesT.length();j++) 
////			{ 
////				int n = label.find(subTypesT[j],0,false); 
////				if (n>-1)
////				{ 
////					subType = sSubTypes[j];
////					break;
////				}
////			}//next j
//			
//		// subType found: store in selection map	
//			if (entries.findNoCase(label,-1)>-1)
//			{ 
//				Map mx;
//				mx.setString("Layout", label);
//				mx.setInt("active", bActive);
//				mx.setDouble("maxLength", dMaxLength);
//				mx.setDouble("XOffset", dXOffset);
//				mx.setDouble("YOffset", dYOffset);
//				mapSelections.appendMap("Entry", mx);				
//			}
//
//		}//next i
//
//		return mapSelections;
//	}//End  //endregion	
//	
//
//		mapSelections = ShowMultiDialog(mapDia);
//		if (mapSelections.length()>0)
//		{ 	
//			//mapSelections.writeToXmlFile("c:\\temp\\mapSelections.xml");
//			if (!HasActivePlotViewport(mapSelections))
//				mapSetting.removeAt("PlotViewport[]", true);			
//			else
//				mapSetting.setMap("PlotViewport[]", mapSelections);
//			if (mo.bIsValid())mo.setMap(mapSetting);
//			else mo.dbCreate(mapSetting);			
//		}
//
//
//		setExecutionLoops(2);
//		return;
//	}//endregion	
//	
//region Trigger SelectMasterstyleDwg
	String sTriggerSelectMasterstyleDwg = T("|Select Masterstyle Dwg|");
	addRecalcTrigger(_kContext, sTriggerSelectMasterstyleDwg );
	if ((_bOnRecalc && _kExecuteKey==sTriggerSelectMasterstyleDwg))// ||bDebug)
	{
	
	// Collect folders
		String folders[] = getFoldersInFolder(_kPathHsbCompany);
		String filePaths[0];
		reportNotice(TN("|Scanning| ")+_kPathHsbCompany+ TN("|Please wait|"));
		
		for (int i=0;i<folders.length();i++) 
		{ 
			reportNotice(".");
			String fileNames[]= getFilesInFolder(_kPathHsbCompany+"\\"+folders[i], "*.dwg");
			for (int j=0;j<fileNames.length();j++) 
			{ 
				String filePath = _kPathHsbCompany+"\\"+folders[i]+"\\"+fileNames[j]; 
				String sMasterStyles[] = MasterPanelStyle().getAllEntryNamesFromDwg(filePath);
				
				if (sMasterStyles.length()==1 && sMasterStyles[0].find("Standard",0,false)>-1)
					sMasterStyles.removeAt(0);
				
				if (sMasterStyles.length()>0)
				{ 
					filePaths.append(filePath); 					
				}
			}//next j 
		}//next i
		
		if (filePaths.length()==0)
		{ 
			Map mapIn;
			mapIn.setString("Notice", T("|No drawings with masterpanel styles could be found in the subfolders of| ")+ _kPathHsbCompany +".");
			Map mapOut = callDotNetFunction2(sDialogLibrary, sClass, showNoticeMethod, mapIn);			
		}
		else
		{ 		
			Map mapIn;
			mapIn.setString("Prompt", T("|Select file of default masterpanel styles.|") + TN("|Remember to export your settings to publish the changes.|"));//__prompt is displayed above list
			mapIn.setString("Title", T("|Selection Masterpanel-Style DWG|"));//__appears in dialog title bar
			mapIn.setString("Alignment", "Left");//__"Left", "Center", "Right" supported. Controls alignment of items and Prompt

			Map mapItems;
			//__for String entries, the Value is the text displayed in the list. The Key is irelevant
			for (int i=0;i<filePaths.length();i++) 
			{ 
				String filePath = filePaths[i]; 
				int bSelected = filePath.find(sMasterStyleDwgName,0,false)>-1;
				String fileSub = filePath;
				fileSub.replace(_kPathHsbCompany + "\\", "");
				mapItems.setString("st"+i, fileSub, bSelected); 
			}//next i
			 
			mapIn.setMap("Items[]", mapItems);//__add items for list
			Map mapOut = callDotNetFunction2(sDialogLibrary, sClass, listSelectorMethod, mapIn);
			int bCancel = mapOut.getInt("WasCancelled");
			int nSelectedIndex = mapOut.getInt("SelectedIndex"); 
			
			if(!bCancel && nSelectedIndex>-1)
			{ 
				Map m = mapSetting.getMap("Masterpanel Style");
				m.setString("StyleDwg", filePaths[nSelectedIndex]);
				mapSetting.setMap("Masterpanel Style", m);
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);					
			}
		}
		
		if (!bDebug)
		{ 
			setExecutionLoops(2);
			return;			
		}

	}//endregion	




//region Trigger ImportSettings
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
			else
				bWrite = true;
				
			if (bWrite && mapSetting.length() > 0)
			{ 
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);
				
			// make sure the path exists	//HSB-10750
				int bPathFound= sFolders.find(sFolder)>-1?true:makeFolder(sPath+"\\"+sFolder);	
				
			// write file	
				mapSetting.writeToXmlFile(sFullPath);
				
			// report rsult of writing	
				if (findFile(sFullPath).length()>0)
					reportMessage(TN("|Settings successfully exported to| ") + sFullPath);
				else
					reportMessage(TN("|Failed to write to| ") + sFullPath);
				
			}
			
			setExecutionLoops(2);
			return;
		}
	}	
	
}//endregion




#End
#BeginThumbnail
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
'H`*`"@#_V0``








































































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
        <int nm="BreakPoint" vl="6376" />
        <int nm="BreakPoint" vl="6389" />
        <int nm="BreakPoint" vl="5516" />
        <int nm="BreakPoint" vl="5613" />
        <int nm="BreakPoint" vl="4754" />
        <int nm="BreakPoint" vl="6977" />
        <int nm="BreakPoint" vl="2882" />
        <int nm="BreakPoint" vl="5897" />
        <int nm="BreakPoint" vl="5847" />
        <int nm="BreakPoint" vl="5841" />
        <int nm="BreakPoint" vl="4048" />
        <int nm="BreakPoint" vl="4077" />
        <int nm="BreakPoint" vl="4082" />
        <int nm="BreakPoint" vl="5173" />
        <int nm="BreakPoint" vl="5223" />
        <int nm="BreakPoint" vl="3994" />
        <int nm="BreakPoint" vl="6955" />
        <int nm="BreakPoint" vl="3172" />
        <int nm="BreakPoint" vl="3101" />
        <int nm="BreakPoint" vl="3086" />
        <int nm="BreakPoint" vl="5540" />
        <int nm="BreakPoint" vl="2947" />
        <int nm="BreakPoint" vl="2647" />
        <int nm="BreakPoint" vl="5563" />
        <int nm="BreakPoint" vl="2847" />
        <int nm="BreakPoint" vl="2848" />
        <int nm="BreakPoint" vl="6352" />
        <int nm="BreakPoint" vl="2427" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24493: Write in mapx the DeliveryMaster as the smallest delivery number of all nested childs" />
      <int nm="MajorVersion" vl="14" />
      <int nm="MinorVersion" vl="10" />
      <str nm="Date" vl="9/11/2025 9:22:29 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24434: Add child panel calculation based on outter contour" />
      <int nm="MajorVersion" vl="14" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="8/20/2025 1:08:50 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24167 During the manual placement of child panels, it is possible that the user may unintentionally position objects so that they intersect the protected area of the master panel overcuts.To help visualize these relatively small overlaps, a new visual indication has been added that highlights such intersections." />
      <int nm="MajorVersion" vl="14" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="6/16/2025 2:00:49 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23793: Fix when checking thickness inconsistencies" />
      <int nm="MajorVersion" vl="14" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="4/8/2025 3:54:52 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22579: Add  command to turn off warning for inconsistent thicknesses" />
      <int nm="MajorVersion" vl="14" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="2/20/2025 4:19:49 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22579: Add reportNotice when inconsistent childpanel thicknesses" />
      <int nm="MajorVersion" vl="14" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="2/7/2025 10:58:17 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22958 Plotview Settings Dialog fixed" />
      <int nm="MajorVersion" vl="14" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="1/17/2025 12:00:18 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23333 first line header text fixed" />
      <int nm="MajorVersion" vl="14" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="1/16/2025 5:01:28 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Make-762: save graphics in file for render in hsbView and make" />
      <int nm="MajorVersion" vl="14" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="12/5/2024 8:43:47 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22739 new settings to suport isotropic panel style name convention" />
      <int nm="MajorVersion" vl="14" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="9/30/2024 3:53:46 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22644 bugfix tag location (introduced HSB-22351)" />
      <int nm="MajorVersion" vl="14" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="9/10/2024 9:13:05 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22452 bugfix grid values Y-direction" />
      <int nm="MajorVersion" vl="13" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="7/23/2024 4:48:53 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22094 custom block tag supports generic format resolving of masterpanel. If the master panel resolving does not yield a value, the first panel of the nesting will be utilized for attempting format resolving " />
      <int nm="MajorVersion" vl="13" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="7/15/2024 9:26:09 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22351 supports grain dependent color coding for the grain direction symbol, i.e. @(GrainDirection:CW93:LW:12:D)" />
      <int nm="MajorVersion" vl="13" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="7/3/2024 5:04:26 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22351 - new settings to specify childpanel tag transparency. tag location avoids opening intersection, new option to toggle grips to move tag locations" />
      <int nm="MajorVersion" vl="13" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="7/2/2024 4:37:25 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22009 new options to create plot viewports" />
      <int nm="MajorVersion" vl="13" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="6/4/2024 2:23:24 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21898 description order fixed" />
      <int nm="MajorVersion" vl="13" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="4/16/2024 1:32:16 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21898 new warning will be displayed if the flipping of child panels was unsuccessful due to geometric constraints." />
      <int nm="MajorVersion" vl="13" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="4/16/2024 11:43:34 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21514 bugfix xRef purging" />
      <int nm="MajorVersion" vl="13" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="4/2/2024 9:16:16 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21640 publishing masterpanel oversize for stock panel creation" />
      <int nm="MajorVersion" vl="13" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="3/13/2024 4:58:05 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20825 bugfix writing range values" />
      <int nm="MajorVersion" vl="13" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="2/29/2024 9:19:52 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20825 new properties exposed to 'configure settings' to allow value or range based auto sizing. refer to tooltips of properties to obtain more detailed information" />
      <int nm="MajorVersion" vl="12" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="2/28/2024 5:01:34 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21485 highlighting of 12.7 restricted to panels with beveled edges" />
      <int nm="MajorVersion" vl="12" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="2/23/2024 10:01:04 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21485 invalid feed directions highlighted" />
      <int nm="MajorVersion" vl="12" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="2/20/2024 2:17:31 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21255 color coding of element based and stacked panels enhanced" />
      <int nm="MajorVersion" vl="12" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="1/31/2024 11:05:58 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20997 new mapX property 'BoundingWasteArea' stores area of all bounding box areas of nested panels" />
      <int nm="MajorVersion" vl="12" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="12/21/2023 10:29:07 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20417 - block refs conflicting xref resolved" />
      <int nm="MajorVersion" vl="12" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="12/12/2023 3:55:50 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20283 new settings exposed to locate header and override color and size of first line of tag" />
      <int nm="MajorVersion" vl="12" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="12/4/2023 1:53:28 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20753 accepting custom data to be appended to subMapX 'Masterpanel'" />
      <int nm="MajorVersion" vl="12" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="11/29/2023 8:59:10 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20754 new mapX property 'BoundingWaste' calculates waste based on bounding rectangular child shapes. 'DataLink.MasterPanel' added to each panel to access masterpanel properties in relation to the individual panel" />
      <int nm="MajorVersion" vl="12" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="11/28/2023 12:20:31 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20643 new setting to specify master oversize in X and/or Y, requires hsbDesign 26 or higher" />
      <int nm="MajorVersion" vl="12" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="11/27/2023 3:22:03 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19101 feed direction only shown when explictly defined" />
      <int nm="MajorVersion" vl="11" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="6/7/2023 12:10:55 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19024 instance is not shown when looking from positive or negative X-World or Y-World to improve model visibility" />
      <int nm="MajorVersion" vl="11" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="5/23/2023 11:40:38 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17748 preventing duplicate child references" />
      <int nm="MajorVersion" vl="11" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="3/15/2023 9:32:53 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18167 accepting text color override of child texts through linked stacking packages" />
      <int nm="MajorVersion" vl="11" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="3/1/2023 11:03:11 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17732 bugfix xref override" />
      <int nm="MajorVersion" vl="10" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="2/22/2023 11:35:09 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17732 accepting xref override properties and show duplicate warnings" />
      <int nm="MajorVersion" vl="10" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="1/30/2023 5:13:51 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16985 allows creation of empty masterpanels on insert" />
      <int nm="MajorVersion" vl="10" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="11/7/2022 11:44:28 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16897 new properties to override the default masterpanel dimensions, new property to override the auto size mode" />
      <int nm="MajorVersion" vl="10" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="10/26/2022 12:16:36 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16887 accepts preferred nesting face specified on panels with identical qualities on each face, supports formatting helper methods on insert and through OPM" />
      <int nm="MajorVersion" vl="10" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="10/25/2022 10:15:20 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16637 accepts panels nested in elements which are stacked in a truck loading" />
      <int nm="MajorVersion" vl="10" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="9/28/2022 9:11:29 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16247 accepts manual override of master surfacequality style if selected quality is higher" />
      <int nm="MajorVersion" vl="10" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="9/6/2022 4:45:05 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16179 optional remote shape lock added. Requires special tools to deactivate the automatic shape creation" />
      <int nm="MajorVersion" vl="10" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="8/2/2022 4:09:56 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15610 yield constantly updated" />
      <int nm="MajorVersion" vl="10" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="7/25/2022 3:07:13 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15874 additional properties added to submap Masterpanel, i.e. access data using @(Masterpanel.Waste). Requires hsbDesign 24 or higher" />
      <int nm="MajorVersion" vl="10" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="6/29/2022 1:22:58 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15000 child elevation fixed to upper face of masterpanel" />
      <int nm="MajorVersion" vl="9" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="4/11/2022 9:08:58 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13524 a new option 'Add Openings to Masterpanel' is avalable in the configuration dialog to toggle openings of masterpanels on or off." />
      <int nm="MajorVersion" vl="9" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="10/18/2021 4:28:04 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11716 display settings for child and master text display enriched., accessible context command" />
      <int nm="MajorVersion" vl="9" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="4/28/2021 11:45:08 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-10750 bugfix exporting global settings, validating company folder structure" />
      <int nm="MajorVersion" vl="9" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="3/3/2021 3:27:58 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-10750 global settings can be modified, imported and exported by context custom command" />
      <int nm="MajorVersion" vl="8" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="2/15/2021 11:07:02 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Commit issue" />
      <int nm="MajorVersion" vl="8" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="1/27/2021 4:13:00 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End