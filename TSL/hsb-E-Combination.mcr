#Version 8
#BeginDescription
EN This tsl defines an electrical combination
DACH Dieses TSL definiert eine Kombination

#Versions
Version 18.13 13.08.2025 HSB-23569: Add trigger to control "SupressCnCElementTooling" , Author: Marsel Nakuci
Version 18.12 13.08.2025 HSB-23569: Add xml flag "SupressCnCElementTooling" to supress element CNC tools , Author: Marsel Nakuci
Version 18.11 26.11.2024 HSB-23057: Write TSL handle/ID as second position in hardware notes , Author Marsel Nakuci
18.10 27/08/2024 HSB-22549: Check body operation on genbeam 
18.9 16.04.2024 HSB-21887: Fix when calculating pline path vor vertical alignment; For Rubner use catalog "Vorgabe" when creating hsbInstallationPoint 
18.8 22.03.2024 HSB-21736: Create new referece to wall after 2 walls are joined 
18.7 25.01.2024 HSB-21220: Add strategy to mill by destroying all; not only the path 
18.6 24.01.2024 HSB-21220: Add parameter MaxWidthForClosedMill for closed/open mill 
Version 18.5 07.10.2022 HSB-15727 minor reporting issue corrected , Author Thorsten Huck
Version 18.4    22.04.2021
HSB-11557 bugfix text positioning , Author Thorsten Huck
Version 18.3    14.04.2021
HSB-11557 new optional parameter Combination\Text\PlanAnnotationOffset to overwrite plan text location
new context commands to export and import settings , Author Thorsten Huck
18.2 08.02.2021 HSB-10560 included in standard update procedure, no more custom dll maintenance required. V23 or higher required , Author Thorsten Huck

version value="18.0" date="17sep2020" author="thorsten.huck@hsbcad.com"
HSB-8878 bugfix horizontal offset drill
HSB-8392 elevation text color set to 10 if special activated 
HSB-8318 bugfix drill solid














#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 18
#MinorVersion 13
#KeyWords Electrical;Installation;Element
#BeginContents
//region History

/// <summary Lang=de>
/// Dieses TSL definiert eine Kombination
/// </summary>

/// <summary Lang=en>
/// This TSL creates a combination
/// </summary>

/// <remark Lang=de>
/// Bitte beachten Sie die Dokumentation zu dieser Funktion
/// </remark>

/// <remark Lang=de>
/// Dieses TSL ist nur unter bestimmten Konfigurationsvorraussetzungen lauffähig
/// 	- benötigt Blockdefinitionen in Unterverzeichnissen im Verzzeichnis <hsbCompany>\Block\Electrical
///	- hsbInstallationPoint.mcr
///	- <hsbCAD>\custom\hsbElectricalTsl.dll
/// </remark>

//if (_PtG.length() > 1)_PtG.removeAt(1);

/// History
// #Versions
// 18.12 13.08.2025 HSB-23569: Add xml flag "SupressCnCElementTooling" to supress element CNC tools , Author: Marsel Nakuci
// 18.11 26.11.2024 HSB-23057: Write TSL handle/ID as second position in hardware notes , Author Marsel Nakuci
// 18.10 27/08/2024 HSB-22549: Check body operation on genbeam Marsel Nakuci
// 18.9 16.04.2024 HSB-21887: Fix when calculating pline path vor vertical alignment; For Rubner use catalog "Vorgabe" when creating hsbInstallationPoint Author: Marsel Nakuci
// 18.8 22.03.2024 HSB-21736: Create new referece to wall after 2 walls are joined Author: Marsel Nakuci
// 18.7 25.01.2024 HSB-21220: Add strategy to mill by destroying all; not only the path Author: Marsel Nakuci
// 18.6 24.01.2024 HSB-21220: Add parameter MaxWidthForClosedMill for closed/open mill Author: Marsel Nakuci
// 18.5 07.10.2022 HSB-15727 minor reporting issue corrected , Author Thorsten Huck
// 18.4 22.04.2021 HSB-11557 bugfix text positioning , Author Thorsten Huck
// 18.3 14.04.2021 HSB-11557 new optional parameter Combination\Text\PlanAnnotationOffset to overwrite plan text location, new context commands to export and import settings , Author Thorsten Huck
// 18.2 08.02.2021 HSB-10560 included in standard update procedure, no more custom dll maintenance required. V23 or higher required , Author Thorsten Huck
///<version value="18.1" date="16nov2020" author="thorsten.huck@hsbcad.com"> HSB-9758 custom specific removal of exterior installation assignment</version>
///<version value="18.0" date="17sep2020" author="thorsten.huck@hsbcad.com"> HSB-8878 bugfix horizontal offset drill </version>
///<version value="17.9" date="24jul2020" author="thorsten.huck@hsbcad.com"> HSB-8392 elevation text color set to 10 if special activated </version>
///<version value="17.8" date="16jul2020" author="thorsten.huck@hsbcad.com"> HSB-8318 bugfix drill solid </version>
///<version value="17.7" date="16jun2020" author="thorsten.huck@hsbcad.com"> HSB-7924 supports custom floor thickness set against installation point </version>
///<version value="17.6" date="21apr20" author="thorsten.huck@hsbcad.com"> HSB-7350 individual room assignment considers rooms not embraced by walls  </version>
///<version value="17.5" date="22nov19" author="thorsten.huck@hsbcad.com"> HSB-6008 empty spaces supported (stairs etc) </version>
///<version value="17.4" date="22nov19" author="thorsten.huck@hsbcad.com"> HSB-6008 individual room assignment also triggered by flip side </version>
///<version value="17.3" date="22nov19" author="thorsten.huck@hsbcad.com"> HSB-6008 individual room assignment triggered by location </version>
///<version value="17.2" date="21nov19" author="thorsten.huck@hsbcad.com"> HSB-6008 wall output assignment enhanced </version>
///<version value="17.1" date="21nov19" author="thorsten.huck@hsbcad.com"> HSB-6008 room assignment enhanced </version>
///<version value="17.0" date="01aug19" author="thorsten.huck@hsbcad.com"> HSB-5459 new custom command to change elevation relative </version>
///<version value="16.9" date="08jul19" author="thorsten.huck@hsbcad.com"> HSB-5281 bugfix solid subtraction on rectangualr and slotted shapes </version>
///<version value="16.7" date="07may19" author="thorsten.huck@hsbcad.com"> new parameter "Combination\Relief\BeamOnly = 1" not to extend drill depth on clash detection for the sheeting toolings </version>
///<version value="16.6" date="19mar19" author="thorsten.huck@hsbcad.com"> bugfix Textfarbe Combination </version>
///<version value="16.5" date=11mar19" author="thorsten.huck@hsbcad.com"> Der neue Parameter 'InstallationPoint\UseGenbeamReference' = 1 projiziert den Referenzpunkt auf die Umhüllung der betroffenen Bauteile und ermöglicht so die Berücksichrtigung variabler Wandstärken </version>
///<version value="16.4" date="26feb19" author="thorsten.huck@hsbcad.com"> Neue Einstellung 'Combination\Text\HideText' unterdrückt die instanzgebundende Darstellung der Text 1-5 </version>
///<version value="16.3" date="19feb19" author="thorsten.huck@hsbcad.com"> Neue Einstellung 'OnInsertCombination' läßt eine freie Definition der Abfragen zu. Während des Einfügens kann nun auch eine Wand ausgewählt werden und es wird ein Installationspunkt mit 'Vorgabe' Katalogeinstellungen erzeugt </version>
///<version value="16.2" date="31jan19" author="thorsten.huck@hsbcad.com"> Neue Einstellung 'SlottedShape[]' unterstützt auch individuelle Werkzeug-Indizes sofern definiert </version>
///<version value="16.1" date="30jan19" author="thorsten.huck@hsbcad.com"> Neue Einstellung 'SlottedShape[]' definiert variable Radien bei Langlochfräsungen. Vorgabe-Speicherort der Konfigurationsdatei ist nun <company>\tsl\settings </version>
///<version value="16.0" date="30jun17" author="thorsten.huck@hsbcad.com"> Neue Einstellung 'CombinationMaxClosedMilling' definiert die maximale Breite/Höhe einer Langloch- oder Rechteckfräsung bis zu welcher die Kontur geschlossen gefräst wird. Wird der Wert nicht definiert oder überschritten, so bleibt ein kleiner Steg erhalten um Probleme der Absaugung mit größeren gelösten Teilen zu vermeiden</version>
///<version value="15.9" date="24feb17" author="thorsten.huck@hsbcad.com"> Sammlung relevanter Bauteile verbessert </version>
///<version value="15.8" date="09feb17" author="thorsten.huck@hsbcad.com"> benutzerdefinierte Ausgabe (1) tiefer Dosen (Zeitmanagement) </version>
///<version value="15.7" date="14sept16" author="thorsten.huck@hsbcad.com"> die vertikale VDE Ausrichtung wird ausschließlich durch die erweiterten Einstellungen kontrolliert </version>
///<version value="15.6" date="01aug16" author="thorsten.huck@hsbcad.com"> blockbasierte Artikeldefinition akzeptiert beliebig viele Einträge </version>
///<version value="15.5" date="05jul16" author="thorsten.huck@hsbcad.com"> blockbasierte Objektüberschreibung ignoriert Werte < 0, Ausrichtung von Palette korrigiert, Mehrfachaufruf von Palette, Abfrage beim Einfügen von Palette kann übersprungen werden </version>
///<version value="15.4" date="04jul16" author="thorsten.huck@hsbcad.com"> die Freistichtiefe kollidierender Bohrungen kann in den Einstellungen optional für Innen-und Außendwände unterschieden werden (Parameter CombinationReliefDepthExposed)</version>
///<version value="15.3" date="06apr16" author="thorsten.huck@hsbcad.com"> Bohrungsparameter können durch Blockdefinition überschrieben werden </version>
///<version value="15.2" date="31mar16" author="thorsten.huck@hsbcad.com"> bugfix Darstellung Elementbeschriftung </version>
///<version value="15.1" date="17dec15" author="thorsten.huck@hsbcad.com"> neue Eingabeoptionen beim Einfügen mit Katalogeintrag: es kann nun die Ausrichtung und der Positionsindex über die Befehlszeile eingestellt werden </version>
///<version value="15.0" date="16dec15" author="thorsten.huck@hsbcad.com"> neue Einstellungsmöglichkeiten verschiedener Darstellungskomponenten, neue Bearbeitung 'große Bohrung' bei Kollsionen mit Rahmen, vergl. Dokumentation </version>
///<version value="14.9" date="25sep15" author="thorsten.huck@hsbcad.com"> Automatische Bereinigung zur Leistungssteigerung. </version>
///<version value="14.8" date="24sep15" author="thorsten.huck@hsbcad.com"> Leistungssteigerung durch neue Struktur der Abhängigkeiten. </version>
///<version value="14.7" date="03sep15" author="thorsten.huck@hsbcad.com"> bugfix: editieren der kombination aktualisiert Exportdaten </version>
///<version value="14.6" date="07aug15" author="thorsten.huck@hsbcad.com"> neuer Kontextbefehl zur Definition von Exportüberschreibungen. Exportüberschreibungen werden automatisch erkannt und für die Listenausgabe verwendet, vergl. Dokumentation </version>
///<version value="14.5" date="30jul15" author="thorsten.huck@hsbcad.com"> frei ausgerichtete Versätze blatten kollidierende Ständer vollständig aus  </version>
///<version value="14.4" date="30jul15" author="thorsten.huck@hsbcad.com"> Sonderbearbeitung hsbKe4 prüft betroffene Zonen einzelnd </version>
///<version value="14.3" date="24jul15" author="th@hsbCAD.de"> Sonderbearbeitung hsbKey1 angepasst </version>
///<version value="14.2" date="02jul15" author="th@hsbCAD.de"> bugfix Sonderbearbeitungen ...hsbKey... </version>
///<version value="14.1" date="26jun15" author="th@hsbCAD.de"> neuer Kontextbefehl um die Plandarstellung der Symbole zu skalieren </version>
///<version  value="14.0" date="23jun15" author="th@hsbCAD.de"> Textausrichtung Plandarstellung korrigiert, neue Einstellungen 'CombinationReliefHeightExtension' und 'CombinationReliefMode' ergänzt. </version>
///<version  value="13.9" date="11jun15" author="th@hsbCAD.de"> Ausgabedaten überarbeitet, die Daten werden nun indiziert und nur bei Blockänderungen überschrieben </version>
///<version  value="13.8" date="29may15" author="th@hsbCAD.de"> Die Auswertung von 'hsb-E-BlockData' wird nun beim hinzufügen und neu Erzeugen unterstützt </version>
///<version  value="13.7" date="29may15" author="th@hsbCAD.de"> beim Hinzufügen einer weiteren Kombination wurde ein optionaler Griff des Beschriftungstextes u.U. leicht versetzt. Dieses Verhalten ist nun korrigiert. </version>
///<version  value="13.6" date="28may15" author="th@hsbCAD.de"> Freistich berücksichtigt gesamten Kollisionsbereich, 'hsb-E-BlockData' wird zur Übersteurung der Sichtbarkeit der Beschriftungen unterstützt </version>
///<version  value="13.5" date="28may15" author="th@hsbCAD.de"> neue Optionen zur Erzeugung von Freistichbearbeitungen bei Kollisionen mit dem Rahmen </version>
///<version  value="13.4" date="26may15" author="th@hsbCAD.de"> Automatische Griffrelation 'Beschriftung an zusätzlichem Griff' vervollständigt </version>
///<version  value="13.3" date="22feb15" author="th@hsbCAD.de"> bugfix </version>
///<version  value="13.2" date="19feb15" author="th@hsbCAD.de"> Vorbereitung automatische Griffrelation 'Beschriftung an zusätzlichem Griff' </version>
///<version  value="13.1" date="23feb15" author="th@hsbCAD.de"> neue Eigenschaft 'Breite horizontaler Kabelkanal' </version>
///<version  value="13.0" date="11feb15" author="th@hsbCAD.de"> benutzerdefinierte Einstellungen für die Erzeugung der Planbeschriftung erweitert: der Parameter 'CreateAnnotation' unterstützet 3 Varianten für die Positionierung der Planbeschriftung <0>(Vorgabe) feste Lage, <1> freies Beschriftungsobjekt, <2> Beschriftung an zusätzlichem Griff </version>
///<version  value="12.9" date="03dec14" author="th@hsbCAD.de"> neue Eigenschaften Text 1-5 und neue Kontextbefehle Text drehen 45°/90^/180°. Neue Voreinstellungen, vergl. Dokumentation </version>
///<version  value="12.8" date="20nov14" author="th@hsbCAD.de"> Eigenschaften kategorisiert </version>
///<version  value="12.7" date="20nov14" author="th@hsbCAD.de"> neue Optionen um die Beschriftungen in der Plan- und Elementansicht zu verbergen, zu zeigen oder zu erzeugen </version>
///<version  value="12.6" date="12nov14" author="th@hsbCAD.de"> Korrektur Leitungsfräsung bei versetzen Dosen verbessert </version>
///<version  value="12.5" date="23oct14" author="th@hsbCAD.de"> Korrektur Leitungsfräsung bei versetzen Dosen </version>
///<version  value="12.4" date="23oct14" author="th@hsbCAD.de"> automatische Kollisionsprüfung mit potentiellen Stahlprofilen. Die Warnung kann nur durch eine Verschiebung der Bearbeitung deaktiviert werden </version>
///<version  value="12.3" date="18sep14" author="th@hsbCAD.de"> automatische Ausrrichtung Elementbeschriftung korrigiert. </version>
///<version  value="12.2" date="10sep14" author="th@hsbCAD.de"> bei versetzten Kombinationen werden orthogonale Stäbe nur dann bearbeitet, wenn die resultierende Bearbeitung mindestens 50% der Bauteilbreite ausmacht </version>
///<version  value="12.1" date=10sep13" author="th@hsbCAD.de"> Plan- und Elementbeschriftungen werden auf 'I'-Layer gezeichnet </version>
///<version  value="12.0" date=10sep13" author="th@hsbCAD.de"> 'Mauslöcher' für die Kabeleinführung deaktiviert </version>
///<version  value="11.9" date=25jul13" author="th@hsbCAD.de"> Unterstützt hsb-E-Data als Alternative zur Raumzuordnung </version>
///<version  value="11.8" date=24jul13" author="th@hsbCAD.de"> Beschriftungserzeugung für Mehrfacheinfügung korrigiert  </version>
///<version  value="11.7" date=27mar14" author="th@hsbCAD.de" > Optional kann im unberechneten Zustand der Wand die Bohrungsachse als Hilfslinie dargestellt werden. Um diese Option zu aktivieren ergänzen Sie 'DrawDrillGuideLine=1' in den Benutzereinstellungen.</version>
///<version  value="11.6" date=22mai14" author="th@hsbCAD.de"> external setting 'CreateAnnotationElement' introduced: 'int nm="CreateAnnotationElement" vl="1"' vl=0[1]: no individual[indivudual] element annotation object is created on insert. The flag 'CreateAnnotation' now controls only plan view annotation </version>
///<version  value="11.5" date=27mar14" author="th@hsbCAD.de"> Layer assignment fixed. Entity is not drawn on tool layer anymore</version>
///<version  value="11.4" date=14mar14" author="th@hsbCAD.de"> Custom 1: automatic drill extension for intersecting studs enhanced </version>
///<version  value="11.3" date=13mar14" author="th@hsbCAD.de"> external setting 'CreateAnnotation' introduced: 'int nm="CreateAnnotation" vl="1"' vl=0[1]: no individual[indivudual] annotation object is created on insert, Annotation will be erased if parent combination has a diameter/height value <=0, Description 1/2 updates potential annotation entity </version>
///<version  value="11.2" date=21feb14" author="th@hsbCAD.de"> external settings file introduced <StickframeFolder>\<scriptNameInstallationPoint>Settings.xml, Seetings may control the assignment to an additional group and VDE alignment </version>
///<version  value="11.1" date=14feb14" author="th@hsbCAD.de"> VDE Alignment supports context alignment, custom 1 draws a line along drill depth </version>
///<version  value="11.0" date=12feb14" author="th@hsbCAD.de"> if parent switches side the sequence of horizontal combinations will be inverted </version>
///<version  value="10.9" date=11feb14" author="th@hsbCAD.de"> custom 0 supports vertical VDE based distribution on creation and on chaning the position index, requires hsbElectricalTsl.dll 1.0.1.20 or higher </version>
///<version  value="10.8" date=10feb14" author="th@hsbCAD.de"> symbol alignment fixed for opposite installation points, symbol/text interference corrected  </version>
///<version  value="10.7" date=05dec13" author="th@hsbCAD.de"> additional drill holes validate additional drill depth separatly from the source drill location, guideline also shown in [m] plan view (custom 1)  </version>
///<version  value="10.6" date=05dec13" author="th@hsbCAD.de"> bugfix plTool validation  </version>
///<version  value="10.5" date=05dec13" author="th@hsbCAD.de"> custom [m] display added  </version>
///<version  value="10.4" date=05dec13" author="th@hsbCAD.de"> automatic Symbol Alignment mirrored display bugfix  </version>
///<version  value="10.3" date=21nov13" author="th@hsbCAD.de"> automatic Symbol Alignment in dependency of the grip location reactivated. custom 1: tooling limited, new property 'rotation symbol' rotates the symbol around WCS Z-Axis   </version>
///<version  value="10.2" date=20nov13" author="th@hsbCAD.de"> horizontal aligned symbols will be displayed aligned with grip point  </version>
///<version  value="10.1" date="08nov13" author="th@hsbCAD.de"> text and guideline position of boxed combinations corrected for new block scaling </version>
///<version  value="10.0" date="07nov13" author="th@hsbCAD.de"> Annotation alignment and location fixed </version>
///<version  value="9.9" date="25oct13" author="th@hsbCAD.de"> Block scaling and drawing completly revised. Blocks are drawn 1:1 centered on the line of insertion points </version>
///<version  value="9.8" date="24sep13" author="th@hsbCAD.de"> Annotation placement for slotted and rectangular shapes corrected, take III </version>
///<version  value="9.7" date="23sep13" author="th@hsbCAD.de"> symbol relocation for imported blocks corrected  </version>
///<version  value="9.6" date="23sep13" author="th@hsbCAD.de"> supports 'copy installation' with consideration of flipped sides of the source combinations  </version>
///<version  value="9.5" date="18sep13" author="th@hsbCAD.de"> Annotation placement for slotted and rectangular shapes corrected, take II </version>
///<version  value="9.4" date="18sep13" author="th@hsbCAD.de"> Annotation placement for slotted and rectangular shapes corrected </version>
///<version  value="9.3" date="16sep13" author="th@hsbCAD.de"> zone contour enhanced if zone is made of multiple non opening rings </version>
///<version  value="9.2" date="16sep13" author="th@hsbCAD.de"> solid tooling for special key4 enhanced, solid tooling drill toos corrected</version>
///<version  value="9.1" date="05sep13" author="th@hsbCAD.de"> placement on insert fixed when only one combination is selected </version>
///<version  value="9.0" date="12aug13" author="th@hsbCAD.de"> new display 'Electrical' added. This option can be used to display exclusivly electrical symbols in a plan layout </version>
///<version  value="8.9" date="31jul13" author="th@hsbCAD.de"> aligned offsets collect all entities from element </version>
///<version  value="8.8" date="30jul13" author="th@hsbCAD.de"> bugfix tool interscection II</version>
///<version  value="8.7" date="29jul13" author="th@hsbCAD.de"> bugfix tool interscection opposite side</version>
///<version  value="8.6" date="29jul13" author="th@hsbCAD.de"> tool interscection with each sheet or beam enhanced</version>
///<version  value="8.5" date="29jul13" author="th@hsbCAD.de"> custom group assignment introduced with version 3.2 is now depreciated </version>
///<version  value="8.4" date="29jul13" author="th@hsbCAD.de"> symbol sorting after adding a new combination enhanced </version>
///<version  value="8.3" date="29jul13" author="th@hsbCAD.de"> rectangular and slotted combinations display results of tool interscection with each sheet or beam </version>
///<version  value="8.2" date="11jul13" author="th@hsbCAD.de"> custom 1: new symbol scaling, annotations repostioning on certain property changes </version>
///<version  value="8.1" date="25jun13" author="th@hsbCAD.de"> copy to new wall fixed </version>
///<version  value="8.0" date="24jun13" author="th@hsbCAD.de"> assigning to another installtion point  enhanced </version>
///<version  value="7.9" date="24jun13" author="th@hsbCAD.de"> extra tool will only be enabled for custom 1 when setting a horizontal offset </version>
///<version  value="7.8" date="24jun13" author="th@hsbCAD.de"> dummies are excluded from any selection or tooling </version>
///<version  value="7.7" date="20jun13" author="th@hsbCAD.de"> location of solid operations of drills corrected </version>
///<version  value="7.6" date="14jun13" author="th@hsbCAD.de"> Annotations follow its reference, Custom 1: Annotions always created on insert, Custom 1: default color oppoiste changed to magenta (6)</version>
///<version  value="7.5" date="28may13" author="th@hsbCAD.de"> Custom Special Key4 uses always position index 2 </version>
///<version  value="7.4" date="08may13" author="th@hsbCAD.de"> Bugfix Annotation Visibility 6.9 </version>
///<version  value="7.3" date="08may13" author="th@hsbCAD.de"> Bugfix Custom scaling of block symbols introduced 7.0 </version>
///<version  value="7.2" date="06mai13" author="th@hsbCAD.de"> Tooling side and contour of slotted millings corrected</version>
///<version  value="7.1" date="30apr13" author="th@hsbCAD.de"> 'Extra Tool Offset' now also supports the relative offset which can be used by draggin the installation point </version>
///<version  value="7.0" date="26apr13" author="th@hsbCAD.de"> Custom scaling of block symbols, hardware will be cloned from block definition if defined</version>
///<version  value="6.9" date="26apr13" author="th@hsbCAD.de"> Annotation mode: only visible in plan view, new command to create an annotation in element view</version>
///<version  value="6.8" date="22apr13" author="th@hsbCAD.de"> special key 4 drill diameter changed from 68mm to 74mm</version>
///<version  value="6.7" date="22apr13" author="th@hsbCAD.de"> special key 4 is forced to be of rectangular shape. tool shape detected always from icon side zone</version>
///<version  value="6.6" date="22apr13" author="th@hsbCAD.de"> Slotted Hole: on a horizontal combination the strip is located at the bottom, strip length is is variable if remaining segment length is below standard strip lengt</version>
///<version  value="6.5" date="15apr13" author="th@hsbCAD.de"> Tooling side of Special 4 corrected</version>
///<version  value="6.4" date="15apr13" author="th@hsbCAD.de"> Tooling side of rectangular millings corrected</version>
///<version  value="6.3" date="12apr13" author="th@hsbCAD.de"> display of height in elemnet view shows elevation + floor height, position index vertical distributions fixed</version>
///<version  value="6.2" date="10apr13" author="th@hsbCAD.de"> bugfix strip alignment </version>
///<version  value="6.1" date="03apr13" author="th@hsbCAD.de"> slotted and rectangular toolings do not mill completly to avoid hassle with the dust extraction, catalog based insertion without dialog supported</version>
///<version  value="6.0" date="22mar13" author="th@hsbCAD.de"> Block locations published for symbolic wireplan display</version>
///<version  value="5.9" date="07mar13" author="th@hsbCAD.de"> double click action key renamed to 'TslDoubleClick'. double click action is now part of contentDACH </version>
///<version  value="5.8" date="01mar13" author="th@hsbCAD.de"> automatic symbol alignment via installation point</version>
///<version  value="5.7" date="28feb13" author="th@hsbCAD.de"> display of height in elemnet view shows diameter if different from 68mm or dimensions on boxed combinations</version>
///<version  value="5.6" date="15feb13" author="th@hsbCAD.de"> custom display of height in elemnet view supports mask/show annotation</version>
///<version  value="5.5" date="14feb13" author="th@hsbCAD.de"> height abbreviation 'H:' not shown anymore, custom display of height in elemnet view</version>
///<version  value="5.5" date="30jan13" author="th@hsbCAD.de"> special key 4: solid display bugfix</version>
///<version  value="5.4" date="30jan13" author="th@hsbCAD.de"> element construction forces an additional recalc</version>
///<version  value="5.3" date="30jan13" author="th@hsbCAD.de"> special key 4 changed: drill in zone below always set to diamtere 68mm, milling completely without peninsula strip</version>
///<version  value="5.2" date="30jan13" author="th@hsbCAD.de"> new context command to mask/show the annotation. Default Annotation does not show the height abbreviation 'H:'</version>
///<version  value="5.1" date="14dec12" author="th@hsbCAD.de"> new properties 'extra tool offset' and 'extra tool opposite'. NOTE: the _Default entry should be updated manually by calling the property dialog of an existing combination</version>
///<version  value="5.0" date="16nov12" author="th@hsbCAD.de"> special 1 extended, requires usage of property 'exposed' of wall type </version>
///<version  value="4.9" date="15nov12" author="th@hsbCAD.de"> combination displays correct after insert without recalc, solid drill operations are custom specific, custom default heights extended, no tooling when depth <= 0</version>
///<version  value="4.8" date="26oct12" author="th@hsbCAD.de"> new property tooling index</version>
///<version  value="4.7" date="24oct12" author="th@hsbCAD.de"> auto correction of invalid position index. Auto delete if no displaying blocks are defined</version>
///<version  value="4.6" date="12oct12" author="th@hsbCAD.de"> installationpoint is updated when the combination was edited</version>
///<version  value="4.5" date="11oct12" author="th@hsbCAD.de"> bugfix slotted hole when sides are swapped, strips added for specials, range error bugfix</version>
///<version  value="4.4" date="02oct12" author="th@hsbCAD.de"> group assignment after wall split fixed</version>
///<version  value="4.3" date="02oct12" author="th@hsbCAD.de"> bugfix horizontal alignment when installation and combination are on flipped sides</version>
///<version  value="4.2" date="28sep12" author="th@hsbCAD.de"> wall split behaviour enhanced, position index inverted after flipping side of installation point</version>
///<version  value="4.1" date="28sep12" author="th@hsbCAD.de"> annotation follows location if side of combination has been flipped</version>
///<version  value="4.0" date="27sep12" author="th@hsbCAD.de"> new dragging behaviour: automatic repositioning if the origin point of the combination is vertically dragged outside of the element </version>
///<version  value="3.9" date="27sep12" author="th@hsbCAD.de"> horizontal alignment of combination content dependent from viewing side of installation point</version>
///<version  value="3.8" date="27sep12" author="th@hsbCAD.de"> annotation text follows reading conventions, annotation leader can be toggled via context command, strip length on rectangular and slooted holes extended to 45mm</version>
///<version  value="3.7" date="21sep12" author="th@hsbCAD.de"> adding of combination through installation point fixed</version>
///<version  value="3.6" date="19sep12" author="th@hsbCAD.de"> tool is more tolerant when a blockname is missing</version>
///<version  value="3.5" date="19sep12" author="th@hsbCAD.de"> bugfix rectangular and slotted tools (were introduced by new specials)</version>
///<version  value="3.4" date="19sep12" author="th@hsbCAD.de"> no nail areas are only created if the no nail area is greater then .01mm2</version>
///<version  value="3.3" date="19sep12" author="th@hsbCAD.de"> extra depth on drill operations set custom functionality</version>
///<version  value="3.2" date="06aug12" author="th@hsbCAD.de"> custom group assignment if a group containing the string 'Elektro' exists in same level, special keys except key 1 independent from shape type</version>
///<version  value="3.1" date="03aug12" author="th@hsbCAD.de"> custom configuration added with no guide lines</version>
///<version  value="3.0" date="02aug12" author="th@hsbCAD.de"> plan display for rectangular and slotted combinations accepts only left(upper), center and right(lower) alignment. Annotation instances will be assigned to the appropriate group</version>
///<version  value="2.9" date="30jul12" author="th@hsbCAD.de"> new custom tooling mounting beamcuts below and above intersecting beams</version>
///<version  value="2.8" date="30jul12" author="th@hsbCAD.de"> Combination Designer on insert bugfix</version>
///<version  value="2.7" date="27jul12" author="th@hsbCAD.de"> special key 4 introduced: milling 150x150 on icon side with drill in zone below, Annotation mode changed to centered display</version>
///<version  value="2.6" date="19jul12" author="th@hsbCAD.de"> Combination Designer will be shown on insert</version>
///<version  value="2.5" date="12jul12" author="th@hsbCAD.de"> special key 3 with rabbet implemented, automatic tool depth: zone depth is taken if depth = 0, custom property change if country = switzerland</version>
///<version  value="2.4" date="06jul12" author="th@hsbCAD.de"> special key 3 prep work (not finished)</version>
///<version  value="2.3" date="05jul12" author="th@hsbCAD.de"> BOM export supported as hardware items</version>
///<version  value="2.2" date="22jun12" author="th@hsbCAD.de"> new custom display configuration support enables two different displays</version>
///<version  value="2.1" date="20jun12" author="th@hsbCAD.de"> special 2 fixed, take II</version>
///<version  value="2.0" date="01jun12" author="th@hsbCAD.de"> special 2 fixed</version>
///<version  value="1.9" date="25may12" author="th@hsbCAD.de"> special 3 introduced</version>
///<version  value="1.8" date="25may12" author="th@hsbCAD.de"> beam tools are added also for far away horizontally offseted combinations</version>
///<version  value="1.7" date="24may12" author="th@hsbCAD.de"> block alignment dependent from wall side, grip offset on insert</version>
///<version  value="1.6" date="16may12" author="th@hsbCAD.de"> grid independent block scaling introduced</version>
///<version  value="1.5" date="15may12" author="th@hsbCAD.de"> recalc and on element constructed error catched</version>
///<version  value="1.4" date="09may12" author="th@hsbCAD.de"> bugfixes slotted hole and rectangular</version>
///<version  value="1.3" date="04may12" author="th@hsbCAD.de"> block scaling dependent from text height, block alignment dependent from reading directions</version>
///<version  value="1.2" date="03may12" author="th@hsbCAD.de"> bugfix alignment slotted and rectangular</version>
///<version  value="1.1" date="02may12" author="th@hsbCAD.de"> debug messages deactivated</version>
///<version  value="1.0" date="20apr12" author="th@hsbCAD.de"> initial</version>

// #1	Shape 1: SLOTTED HOLE 
// #2	Shape 2: Rectangular 
// #3	subtract solids for rectangular and slotted shapes


/// commands
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Change Elevation|") (_TM "|Select combination|"))) TSLCONTENT
//End History//endregion 


//region constants 
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
	String kDataLink="DataLink", kData="Data",kScript="hsb-E-Combination";
	
	
	String sDialogLibrary = _kPathHsbInstall + "\\Utilities\\DialogService\\TslUtilities.dll";
	String sClass = "TslUtilities.TslDialogService";	
	String listSelectorMethod = "SelectFromList";
	String optionsMethod = "SelectOption";
	String simpleTextMethod = "GetText";
	String askYesNoMethod = "AskYesNo";
	String showNoticeMethod = "ShowNotice";
	String showMultilineNotice = "ShowMultilineNotice";	
	String showDynamic = "ShowDynamicDialog";
	
	String kRowDefinitions = "MPROWDEFINITIONS";
	String kControlTypeKey = "ControlType", kLabelType = "Label", kHeader = "Title", kIntegerBox = "IntegerBox", kTextBox = "TextBox", kDoubleBox = "DoubleBox", kComboBox = "ComboBox", kCheckBox = "CheckBox";
	String kHorizontalAlignment = "HorizontalAlignment", kLeft = "Left", kRight = "Right", kCenter = "Center", kStretch = "Stretch";
//end constants//endregion
	
//region Functions
	//region calcPlineDestroy
	// this function calculates the path to remove by destroying a slotted hole
	//pl -> slotted shape pline; 
	// diameter -> diameter of roundings
	// vx -> vector in length
	// vy -> vector in width
	 
	PLine calcPlineDestroy(PLine pl, double diameter, double diameterMilling,
		Vector3d vx, Vector3d vy)
	{ 
		//pl -> slotted shape pline; 
		// diameter -> diameter of roundings
		// vx -> vector in length
		// vy -> vector in width
		
		double dMin=diameter;
		// nr of rounds
		int nNr=dMin/diameterMilling;
		if(dMin/diameterMilling>nNr)nNr+=1;
//		if(nAlign==1)
//		{ 
//			Vector3d vecX_=vecX;
//			vecX=vecY;
//			vecY=-vecX_;
//		}
		double dWidthStrip=dMin/nNr;
		
		PLine plOutter=pl;
		plOutter.close();
		PlaneProfile ppOutter(plOutter);
		// 
		PLine plToolDestroy(pl.coordSys().vecZ());
		
		PlaneProfile pps[0];
		pps.append(ppOutter);
		PlaneProfile ppI=ppOutter;
		// left,right
		//left-bottom,right-bottom,left-top,right-top
		Point3d ptsL[0],ptsR[0],ptsLB[0],ptsRB[0],ptsLT[0],ptsRT[0];
		{ 
			
		// get extents of profile
			LineSeg seg=ppI.extentInDir(vx);
			double _dX=abs(vx.dotProduct(seg.ptStart()-seg.ptEnd()));
			double _dY=abs(vy.dotProduct(seg.ptStart()-seg.ptEnd()));
			
			ptsL.append(seg.ptMid()-vx*.5*_dX);
			ptsR.append(seg.ptMid()+vx*.5*_dX);
			ptsLB.append(seg.ptMid()-vx*(.5*_dX-.5*_dY)-vy*.5*_dY);
			ptsRB.append(seg.ptMid()+vx*(.5*_dX-.5*_dY)-vy*.5*_dY);
			ptsLT.append(seg.ptMid()-vx*(.5*_dX-.5*_dY)+vy*.5*_dY);
			ptsRT.append(seg.ptMid()+vx*(.5*_dX-.5*_dY)+vy*.5*_dY);
		}
		int _nNr=nNr/2-1;
		if(nNr%2==1)_nNr=nNr/2;
		for (int i=0;i<_nNr;i++) 
		{ 
			ppI.shrink(dWidthStrip);
			pps.append(ppI);
			
			LineSeg seg=ppI.extentInDir(vx);
			double _dX=abs(vx.dotProduct(seg.ptStart()-seg.ptEnd()));
			double _dY=abs(vy.dotProduct(seg.ptStart()-seg.ptEnd()));
			
			ptsL.append(seg.ptMid()-vx*.5*_dX);
			ptsR.append(seg.ptMid()+vx*.5*_dX);
			ptsLB.append(seg.ptMid()-vx*(.5*_dX-.5*_dY)-vy*.5*_dY);
			ptsRB.append(seg.ptMid()+vx*(.5*_dX-.5*_dY)-vy*.5*_dY);
			ptsLT.append(seg.ptMid()-vx*(.5*_dX-.5*_dY)+vy*.5*_dY);
			ptsRT.append(seg.ptMid()+vx*(.5*_dX-.5*_dY)+vy*.5*_dY);
		}//next i
		
		pps.reverse();
		ptsL.reverse();
		ptsR.reverse();
		ptsLB.reverse();
		ptsRB.reverse();
		ptsLT.reverse();
		ptsRT.reverse();
		if(nNr%2==0)
		{ 
			// even
			Point3d ptNext;
			for (int i=0;i<nNr/2;i++) 
			{ 
				PlaneProfile ppI=pps[i];
				if(i==0)
				{ 
					plToolDestroy.addVertex(ptsLT[i]);
					plToolDestroy.addVertex(ptsL[i],tan(22.5));
					plToolDestroy.addVertex(ptsLB[i],tan(22.5));
					plToolDestroy.addVertex(ptsRB[i]);
					plToolDestroy.addVertex(ptsR[i],tan(22.5));
					plToolDestroy.addVertex(ptsRT[i],tan(22.5));
					if(i<nNr/2-1)
					{ 
						PlaneProfile ppNext=pps[i+1];
						Point3d ptsInter[]=ppNext.intersectPoints(Plane(ptsRT[i],vy),true,false);
						ptsInter=Line(ptsRT[i],vx).orderPoints(ptsInter);
						ptsInter[0]=Plane(plToolDestroy.coordSys().ptOrg(),plToolDestroy.coordSys().vecZ()).
							closestPointTo(ptsInter[0]);
						ptNext=ptsInter[0];
						plToolDestroy.addVertex(ptsInter[0]);
					}
				}
				else
				{ 
					plToolDestroy.addVertex(ptsLB[i],ptsL[i]);
					plToolDestroy.addVertex(ptsRB[i]);
					plToolDestroy.addVertex(ptsR[i],tan(22.5));
					plToolDestroy.addVertex(ptsRT[i],tan(22.5));
					if(i<nNr/2-1)
					{ 
						PlaneProfile ppNext=pps[i+1];
						Point3d ptsInter[]=ppNext.intersectPoints(Plane(ptsRT[i],vy),true,false);
						ptsInter=Line(ptsRT[i],vx).orderPoints(ptsInter);
						ptsInter[0]=Plane(plToolDestroy.coordSys().ptOrg(),plToolDestroy.coordSys().vecZ()).
							closestPointTo(ptsInter[0]);
						plToolDestroy.addVertex(ptsInter[0]);
						ptNext=ptsInter[0];
					}
					else
					{ 
						plToolDestroy.addVertex(ptsLT[i]);
						Point3d ptM=.5*(ptNext+ptsLT[i]);
						Point3d ptMarc=ppI.closestPointTo(ptM);
						plToolDestroy.addVertex(ptNext,ptMarc);
					}
				}
			}//next i
		}
		else if(nNr%2==1)
		{ 
			// odd
			Point3d ptNext;
			for (int i=0;i<nNr/2+1;i++)
			{ 
				PlaneProfile ppI=pps[i];
				if (i == 0)
				{
					plToolDestroy.addVertex(ptsL[i]-vy*.5*dWidthStrip);
					if(i<nNr/2)
					{ 
						PlaneProfile ppNext=pps[i+1];
						Point3d ptsInter[]=ppNext.intersectPoints(Plane(ptsL[i]-vy*.5*dWidthStrip,vy),true,false);
						ptsInter=Line(ptsL[i]-vy*.5*dWidthStrip,vx).orderPoints(ptsInter);
//									ptsInter[0]=Plane(plToolDestroy.coordSys().ptOrg(),plToolDestroy.coordSys().vecZ()).
//										closestPointTo(ptsInter[0]);
						plToolDestroy.addVertex(ptsInter.last());
						ptNext=ptsInter.last();
					}
				}
				else
				{ 
					if(i==1)
						plToolDestroy.addVertex(ptsRT[i],tan(22.5));
					else
						plToolDestroy.addVertex(ptsRT[i],ptsR[i]);
					plToolDestroy.addVertex(ptsLT[i]);
					plToolDestroy.addVertex(ptsLB[i],tan(45));
					
					if(i<nNr/2)
					{ 
						PlaneProfile ppNext=pps[i+1];
						Point3d ptsInter[]=ppNext.intersectPoints(Plane(ptsLB[i],vy),true,false);
						ptsInter=Line(ptsLB[i],vx).orderPoints(ptsInter);
//									ptsInter[0]=Plane(plToolDestroy.coordSys().ptOrg(),plToolDestroy.coordSys().vecZ()).
//										closestPointTo(ptsInter[0]);
						plToolDestroy.addVertex(ptsInter.last());
						ptNext=ptsInter.last();
					}
					else
					{ 
						plToolDestroy.addVertex(ptsRB[i]);
						Point3d ptM=.5*(ptNext+ptsRB[i]);
						Point3d ptMarc=ppI.closestPointTo(ptM);
						plToolDestroy.addVertex(ptNext,ptMarc);
					}
				}
			}
		}
		
//		plTool=plToolDestroy;
		plToolDestroy.transformBy(vy*U(300));
		plToolDestroy.vis(6);
		plToolDestroy.transformBy(-vy*U(300));
		
		return plToolDestroy;
	}
	//End calcPlineDestroy//endregion
//End Functions//endregion 

//region Constants 2
	double dUnitFactor =.001; // factor to display the height of the combination
	dUnitFactor =1/U(U(1,"mm"),"mm");//dUnitFactor =1/U(U(1,"m"),"mm");
	String sOverridesPath = _kPathHsbWallDetail+"\\" +"CombinationExportOverrides.xml";  // an optional export override definition

	int nDebugTest =1;
	// 1 = genBeam collection
	String sCategoryGeo = T("|Geometry|");
	String sCategoryGeoOffset = T("|Geometry horizontal Offset|");
	String sCategoryBlock = T("|Block|");

	String sHorizontalAlignments[] = {T("|Left|"), T("|Center|"),T("|Right|")};
	String sVerticalAlignments[] = {T("|Top|"), T("|Center|"),T("|Bottom|")};
	
// collect special mode
	int nProjectSpecial;
	String sProjectSpecial = projectSpecial();
	if (sProjectSpecial.find("Lux",0,false)>-1)
		nProjectSpecial=1;	
	
	String sSpecial=projectSpecial();
	sSpecial.makeUpper();
	int bRubner=sSpecial.find("RUB",-1,false)>-1;
// get the flag if this instance has been defined with vertical VDE Alignment (combinations increment their distribution from the second bottom upwards
	int bHasVDEAlignment = _Map.getInt("hasVDEAlignment");
		
		
	//_GenBeam.setLength(0);
	// side color 
	int sColors[] = {3,4};// 0=this side, 1 = opposite side
	if (nProjectSpecial==1)sColors[1] = 6;
		
	String sParentName = "hsbInstallationPoint".makeUpper();		


//End Constants 2//endregion 

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sFileName ="hsbInstallationPointSettings";
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

//region read some settings for the properties
	Map mapSlottedShapes;
	{
		String k;
		Map m = mapSetting;
	// read potential slotted shape definitions
		k="SlottedShape[]";	if (m.hasMap(k))	mapSlottedShapes = m.getMap(k);
	}		
// End read some settings for the properties//endregion




	
// declare the electrical plan display
	// in order to use this functionality one has to define a display set named 'Electrical'. It will draw the electrical plan symbols on an
	// additional set to differentiate with other o-type tsl's
	Display dpPlanElectrical(_ThisInst.color());
	String sDispRepNames[] =_ThisInst.dispRepNames();
	String sDispRepElectrical = "Electrical";
	int bHasPlanElectricalDisp=sDispRepNames.find(sDispRepElectrical);
	
// 3 modes are supported
	// -1 = dummy mode
	// 0 = default combination mode
	// 1 = annotation mode	
	int nMode = _Map.getInt("mode");
	if (nMode<=0){
	
	String strAssemblyPath = _kPathHsbInstall +"\\utilities\\electraTsl\\hsbElectraTsl.dll";
	String strType = "hsbSoft.Tsl.Electra.ElectraTsl";
	String strFunctionCombination= "ShowCombinationDialog";	

	String strTypeOverride = "hsbSoft.Tsl.Electra.ExportOverride";
	String strFunctionDefineOverride= "DefineOverride";	
	String strFunctionFindOverride= "FindOverride";
	
	String sElevationName = T("|Elevation|");
	PropDouble dElevation(0, U(350),sElevationName);
	dElevation.setDescription(T("|Sets the elevation.|"));	
	dElevation.setCategory(T("|General|"));
	
	String sToolIndexName = T("|Toolindex|");	
	PropInt nToolIndex(3, 1, sToolIndexName);		
	nToolIndex.setDescription(T("|The tooling index to be used on a CNC machine|"));		
	nToolIndex.setCategory(sCategoryGeo);


	//region shape property
	String sShapeName = T("|Tooling Shape|");
	String kShapeByInstallation = T("|by Installation|"), kShapeSlottedHole = T("|Slotted Hole|"), kShapeRectangular = T("|Rectangular|");
	String sShapes[] = {kShapeByInstallation,kShapeSlottedHole,kShapeRectangular};
	String sCustomSlottedShapes[0];
	double dShapeRadii[] ={ 0, 0, 0};
	int nToolIndices[] ={nToolIndex,nToolIndex,nToolIndex };
	for (int i=0;i<mapSlottedShapes.length();i++) 
	{ 
		String k;
		Map m = mapSlottedShapes.getMap(i);
		String name;
		double radius;
		int _nToolIndex=nToolIndex;
		k="Name";	if (m.hasString(k))	name = m.getString(k);
		k="Radius";	if (m.hasDouble(k))	radius = m.getDouble(k);
		k="ToolIndex";	if (m.hasInt(k))	_nToolIndex = m.getInt(k);
		if (name.length() < 1 || sShapes.find(name) >- 1 || radius<dEps) continue; // already attached or invalid
		
		sCustomSlottedShapes.append(name);
		sShapes.append(name);
		dShapeRadii.append(radius);	
		nToolIndices.append(_nToolIndex);
	}//next i
	
	
//	// order alphabetically, but keep byINstalltion at first
	for (int i=1;i<sShapes.length();i++) 
		for (int j=1;j<sShapes.length()-1;j++) 
			if (sShapes[j]>sShapes[j+1])
			{
				sShapes.swap(j, j + 1);
				dShapeRadii.swap(j, j + 1);
				nToolIndices.swap(j, j + 1);
			}
	PropString sShape(2, sShapes,sShapeName );
	sShape.setDescription(T("|Sets the shape of the tooling|"));
	sShape.setCategory(T("|General|"));
	//endregion

	String sAlignments[] = { T("|Horizontal|"),T("|Vertical|")};
	String sAlignmentName = T("|Alignment|");
	PropString sAlignment(1, sAlignments, sAlignmentName ,0);
	sAlignment.setDescription(T("|Sets the alignment.|"));
	sAlignment.setCategory(T("|General|"));
	int nArPos[] = {1,2,3,4,5,6,7,8,9};
	if(sShapes.find(sShape)>0)
	{
		nArPos.setLength(3);
	}
	String sPosName = T("|Position Index|");
	PropInt nPos(1, nArPos, sPosName);		
	nPos.setDescription(T("|The Position Index sets the location of the installations in relation to the insertion point.|"));	

	int nArZn[] = {1,2,3,4,5,99};
	String sZoneName = T("|Zone|");	
	PropInt nRelativeZn(2, nArZn, sZoneName);		
	nRelativeZn.setDescription(T("|The relative Zoneindex on the side of this combination|") + " " + T("|(99 = outmost zone on this Side)|"));	
	
	String sDepthName = T("|Depth|");
	PropDouble dDepth(1, U(70),sDepthName);
	dDepth.setDescription(T("|Sets the depth of installations.|"));		
	dDepth.setCategory(sCategoryGeo);

	String sDiameterName = T("|Diameter|");
	String sDiameterHName = T("|Diameter (Height)|");
	PropDouble dDiameter(3, U(68),sDiameterHName);
	dDiameter.setDescription(T("|Sets the diameter of installations.|"));
	dDiameter.setCategory(sCategoryGeo);

	String sWidthName = T("|Width|");
	PropDouble dWidth(4, 0,sWidthName);
	dWidth.setDescription(T("|Sets the width of installation if rectangular|"));
	dWidth.setCategory(sCategoryGeo);

	String sPropNameD2 = T("|Offset Installations|");
	PropDouble dOffsetInstallations(2, U(70),sPropNameD2);
	dOffsetInstallations.setDescription(T("|Sets the Offset between the indiviual installations.|"));	
	dOffsetInstallations.setCategory(sCategoryGeo);

	String dHorizontalOffsetName = T("|Horizontal Offset Installation|");
	PropDouble dHorizontalOffset(5, U(70),dHorizontalOffsetName);
	dHorizontalOffset.setDescription(T("|Sets an horizontal offset to the installation point.|"));	
	dHorizontalOffset.setCategory(sCategoryGeoOffset);
		
	String sOppositeToolName= T("|Extra Tool Opposite|");
	PropString sOppositeTool(6, sNoYes,sOppositeToolName,0);
	sOppositeTool.setDescription(T("|Toggles an additional tool on the opposite side|"));	
	sOppositeTool.setCategory(sCategoryGeo);

	String dRotationName = T("|Rotation|") + " " + T("|Symbol|");
	PropDouble dRotation(6, 0,dRotationName);
	dRotation.setDescription(T("|Sets an roation angle of the symbol in relation to the default alignment.|"));	
	dRotation.setCategory(sCategoryGeo);
	
	String sOffsetToolName = T("|Extra Tool Offset|");
	PropString sOffsetTool(5, sNoYes,sOffsetToolName,0);
	sOffsetTool.setDescription(T("|Toggles an additional tool at offset location|"));	
	sOffsetTool.setCategory(sCategoryGeoOffset);

	String sWidthHorWirechaseName = T("|Width|") + " " ;
	PropDouble dWidthHorWirechase(7, 0,sWidthHorWirechaseName );
	dWidthHorWirechase.setDescription(T("|Overrides the width of the horizontal wirechase.|"));	
	dWidthHorWirechase.setCategory(sCategoryGeoOffset);

	String sCategoryText = T("|Text|");	
	String sDesc1Name = T("|Description|") + " 1";
	PropString sDesc1(3, "",sDesc1Name);
	sDesc1.setDescription(T("|Free Textbox|"));	
	sDesc1.setCategory(sCategoryText );
	
	String sDesc2Name = T("|Description|") + " 2";
	PropString sDesc2(4, "",sDesc2Name);
	sDesc2.setDescription(T("|Free Textbox|"));	
	sDesc2.setCategory(sCategoryText );	

// individual item texts
	String sTextName = T("|Text|");
	int nTxtIndex=1;
	PropString sTxt1(nTxtIndex+6, "",sTextName +" " + nTxtIndex);
	sTxt1.setDescription(T("|Additional text of item|") + " " +nTxtIndex++);	
	sTxt1.setCategory(sCategoryText );	

	PropString sTxt2(nTxtIndex+6, "",sTextName +" " + nTxtIndex);
	sTxt2.setDescription(T("|Additional text of item|") + " " +nTxtIndex++);	
	sTxt2.setCategory(sCategoryText );

	PropString sTxt3(nTxtIndex+6, "",sTextName +" " + nTxtIndex);
	sTxt3.setDescription(T("|Additional text of item|") + " " +nTxtIndex++);	
	sTxt3.setCategory(sCategoryText );

	PropString sTxt4(nTxtIndex+6, "",sTextName +" " + nTxtIndex);
	sTxt4.setDescription(T("|Additional text of item|") + " " +nTxtIndex++);	
	sTxt4.setCategory(sCategoryText );

	PropString sTxt5(nTxtIndex+6, "",sTextName +" " + nTxtIndex);
	sTxt5.setDescription(T("|Additional text of item|") + " " +nTxtIndex++);	
	sTxt5.setCategory(sCategoryText );
	
	String sDimStyle;
	double dTxtH=U(100);
	int nColor = 1;
	
	PropString sBlockPath1(90,"",T("|Block|") + " 1");	sBlockPath1.setCategory(sCategoryBlock);
	PropString sBlockPath2(91,"",T("|Block|") + " 2");	sBlockPath2.setCategory(sCategoryBlock);
	PropString sBlockPath3(92,"",T("|Block|") + " 3");	sBlockPath3.setCategory(sCategoryBlock);
	PropString sBlockPath4(93,"",T("|Block|") + " 4");	sBlockPath4.setCategory(sCategoryBlock);
	PropString sBlockPath5(94,"",T("|Block|") + " 5");	sBlockPath5.setCategory(sCategoryBlock);
	
	String sTempEntryName = T("|ZZ_temporary|");

// declare default heights	
	double dDefaultHeights[] = {U(300),U(400),U(500),U(1000),U(1100),U(1200), U(1900), U(2000), U(2200), U(2550),U(2650)};
	// heights custom1
	if (nProjectSpecial==1)
	{
		double d[] = {U(0),U(300),U(1100),U(1800),U(2230), U(3000)};
		dDefaultHeights=d;
	}
	Map mapHeights;	
	for (int i=0;i<dDefaultHeights.length();i++)
		mapHeights.appendDouble("Height",dDefaultHeights[i]);		
	
	
	
	// stop execution for catalog mode. this is only requierd when initially called as the
	// dll rquires a catalog to be present or when adding a combination to an installation point
	if (nMode<0)
	{
		return;	
	}

// on insert
	if (_bOnInsert)
	{
		// get prompt toggles from settings if any
		int bHasPrompt, bPromptElevation, bPromptOrientation, bPromptAlignment;
		{
			String k;
			Map m;
			k="OnInsertCombination";	if (mapSetting.hasMap(k))	m = mapSetting.getMap(k);
			bHasPrompt = m.length() > 0;
		// read potential slotted shape definitions
			k="PromptElevation";	if (m.hasInt(k))	bPromptElevation = m.getInt(k);
			k="PromptOrientation";	if (m.hasInt(k))	bPromptOrientation = m.getInt(k);
			k="PromptAlignment";	if (m.hasInt(k))	bPromptAlignment = m.getInt(k);

		}		

	// selection of parent entity: the E-Point		
		PrEntity ssE(T("|Select wirechase or element|"), TslInst());
		ssE.addAllowedClass(ElementWall());
		Entity ents[0];  		
		if (ssE.go()) 	
			ents = ssE.set();
		
		TslInst tslParent;
		Element el;
		for(int i=0;i<ents.length();i++)
		{
			TslInst tsl = (TslInst)ents[i];
			Element _el = (Element)ents[i];
			if (tsl.bIsValid() && !tslParent.bIsValid() && tsl.scriptName().makeUpper() == sParentName)
			{
				tslParent= tsl;
			}
			else if (_el.bIsValid())
				el=_el;				
		}// next i


	// no wirechase selected, try to create a default instance at the given location
		if (!tslParent.bIsValid() && el.bIsValid())
		{ 
		// get wall data
			Vector3d vecX = el.vecX();
			Vector3d vecY = el.vecY();
			Vector3d vecZ = el.vecZ();
			
		// get location
			Point3d pt = getPoint();
			
		// insert done in plan view
			if (_ZU.isParallelTo(vecY))
			{ 
				pt = el.plOutlineWall().closestPointTo(pt);
			}
		// element view, always on icon side
			else
			{ 
				pt = el.plOutlineWall().closestPointTo(pt);
				pt += vecZ * (vecZ.dotProduct(el.ptOrg()-pt)+el.dPosZOutlineFront());
			}
			
		// create installation point
			TslInst tslNew;
			GenBeam gbsTsl[]={}; Entity entsTsl[]={el}; Point3d ptsTsl[]={pt};
			int nProps[]={}; double dProps[]={}; String sProps[]={};
			Map mapTsl;	
			
//			if(!bRubner)
			{
				tslNew.dbCreate("hsbInstallationPoint" , vecX ,vecY,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			
			}
//			else if(bRubner)
//			{ 
//				// HSB-21887 create TSL
//				int bForceModelSpace=true;	
//				String sExecuteKey,sCatalogName="Vorgabe";
//				String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
//				
//				tslNew.dbCreate("hsbInstallationPoint",vecX ,vecY,gbsTsl,entsTsl,
//					ptsTsl,sCatalogName,bForceModelSpace,mapTsl,sExecuteKey,sEvent);				
//			}
			if (tslNew.bIsValid())
			{
				if(bDebug)reportMessage("\n"+ scriptName() + " setting catalog of installartion to "+ sDefault);
				if(!bRubner)
				{
					tslNew.setPropValuesFromCatalog(sDefault);
				}
				else if(bRubner)
				{ 
					tslNew.setPropValuesFromCatalog("Vorgabe");
				}
				tslParent = tslNew;
			}
		}


		if (!tslParent.bIsValid())
		{
			if (bDebug)reportMessage("\n"+T("No valid instance of") + " " + sParentName + " " + T("|could be found|") +". " + T("Tool will be deleted."));
			eraseInstance();	
			return;
		}
		else
			_Entity.append(tslParent);

	
	// set properties from catalog
		String sSelectedEntry =_kExecuteKey;
		
	/// validate selected entry
		String sCatalogEntries[] = TslInst().getListOfCatalogNames("hsb-E-Combination");
		sSelectedEntry.makeUpper();
		int nEntry =-1;
		for(int i=0;i<sCatalogEntries.length();i++)
		{
			String s = 	sCatalogEntries[i];s.makeUpper();
			if (s==sSelectedEntry){nEntry=i;break;}
		}		
		
		double dNewElevation;
		String sNewAlignment;
		int nNewPosIndex = -1;
		
		if (nEntry>-1)
		{
			if(bDebug)reportMessage("\n" + scriptName() + "inserting with catalog entry " +sSelectedEntry);
			setPropValuesFromCatalog(_kExecuteKey);	
			int nAlignment = sAlignments.find(sAlignment);
			
		// legacy flag to skip input
			int bSkipPrompt;
			
		// Elevation prompt active or not set
			if (!bHasPrompt || bPromptElevation)
			{ 
			// get elevation as string to allow enter as confirmation of existing value	
				String sInput=getString(T("|Enter '-' to insert at elevation|")+ " " +dElevation + " " + sAlignment + "/" + T("|Index|")+ " " +  nPos + 
					TN("|Elevation|") +" [" + dElevation+"]");
				dNewElevation = sInput.atof();
			
				String sCheckInput = dNewElevation;
				if(sInput!=sCheckInput) 
				{
					//reportMessage("\n" + T("|Invalid input, will use default height|"));
					dNewElevation =dElevation;
				}	
				
			// set skip condition
				bSkipPrompt = (sInput.trimLeft().trimRight()=="-")?true:false;	
			}
			else 
			{ 
				dNewElevation = dElevation;
			}

		// Horizontal/Vertical alignment prompt active or not set
			//reportMessage(TN("|flags|") +bSkipPrompt+bHasPrompt+bPromptOrientation);
			
			if((!bSkipPrompt && !bHasPrompt) || bPromptOrientation)
			{
				String sInput=getString(T("|Enter '-' to insert with alignment| ") +  sAlignment + "/" + T("|Index|")+ " " +  nPos +
					TN("|Select Alignment|") + ": [" + sAlignments[0]+"/" + sAlignments[1]+ "]" + " <"+ sAlignment + ">");
				if (sInput.length()>0)
				{
					String sFirstChar = sInput.left(1).makeUpper();
					if (sFirstChar==sAlignments[0].left(1).makeUpper())
						sNewAlignment=sAlignments[0];
					else if (sFirstChar==sAlignments[1].left(1).makeUpper())
						sNewAlignment=sAlignments[1];				
				}
				bSkipPrompt = (sInput.trimLeft().trimRight()=="-")?true:false;
			}
			
		// Left/Cenetr/Right or bot/center/top alignment prompt active or not set
		// prompt for position index		
			if((!bSkipPrompt && !bHasPrompt) || bPromptAlignment)		
			{
				if (sAlignments.find(sNewAlignment)>-1)nAlignment =sAlignments.find(sNewAlignment);
				String sDirAlignments[0];
				sDirAlignments=sHorizontalAlignments;
				if (nAlignment==1)sDirAlignments=sVerticalAlignments;
				String sInput=getString(T("|Select position|") + 
					": [" + sDirAlignments[0]+"/" + sDirAlignments[1]+"/" + sDirAlignments[2]+ "]" + " " + 
					T("|or new position index|")+ " <" +nPos+ ">");
				if (sInput.length()>0)
				{
					int n = sInput.atoi();
				// get new position index by number
					if (n >0 && n<10)	nNewPosIndex = n;	
				// get new position index by alignment direction
					else
					{
						int nDir=-1;
						String sFirstChar = sInput.left(1).makeUpper();
						if (sFirstChar==sDirAlignments[0].left(1).makeUpper())		nDir=0;
						else if (sFirstChar==sDirAlignments[1].left(1).makeUpper())	nDir=1;					
						else if (sFirstChar==sDirAlignments[2].left(1).makeUpper())	nDir=2;
						if (bDebug)reportMessage("\nnDir = " + nDir  );
						
					// get childs
						int nQtyChilds;
						String sBlockPaths[] = {sBlockPath1,sBlockPath2,sBlockPath3,sBlockPath4,sBlockPath5};
						for (int i=0;i<sBlockPaths.length();i++)
						{
							if (sBlockPaths[i].length()>3) nQtyChilds++;
							else break;
						}
						if (bDebug)reportMessage("\n" + nQtyChilds + " detected");
						
					// get VDA
						int bHasVDEAlignment = tslParent.map().getInt("VDEAlignment");
						int bByInstallation = sShape==kShapeByInstallation;
						if (bDebug)reportMessage("\nbHasVDEAlignment " + bHasVDEAlignment + " Shape"+sShape+ " Alignment " + sAlignment+" detected");
						
					// set new pos index 	
						// alignment left or top
						if (nDir==0)
						{
							if (bHasVDEAlignment && nAlignment==1)	nNewPosIndex =(nQtyChilds *2)-1;		
							else	nNewPosIndex =1;
						}
					// alignment center
						else if (nDir==1 &&  nQtyChilds>0)
						{
							if (bByInstallation)	nNewPosIndex =nQtyChilds;
							else nNewPosIndex =2;
						}
					// alignment right or bottom
						else if (nDir==2 &&  nQtyChilds>0)		
						{
							if (bByInstallation && bHasVDEAlignment && nAlignment==1)nNewPosIndex =1;
							else if (bByInstallation && bHasVDEAlignment)nNewPosIndex =(nQtyChilds *2)-1;
							else nNewPosIndex =(nQtyChilds*2)-1;
						}
						else
							reportMessage("\n" + T("|This should not happen.|"));
					}
				}// END IF prompt for position index
			}// END IF SKIP			
		}// catalog entry found
		else
		{
			if (insertCycleCount()>1) { eraseInstance(); return; }
		
			if(bDebug)reportMessage("\ninserting with catalog entry " +sSelectedEntry);
		// show the dialog				
			//showDialog();
		// compose an empty ModelMap
			Map mapIn, mapOut;
			ModelMapComposeSettings mmComposeFlags;
			ModelMap mm;
			mm.dbComposeMap(mmComposeFlags);			
			mapIn=mm.map();
			mapIn.setMap("Height[]", mapHeights);	
			mapIn.setInt("ShowAllProperties", true);
	
		// call the dialog which returns a catalog entry	
			mapOut = callDotNetFunction2(strAssemblyPath, strType, strFunctionCombination , mapIn);	
			sSelectedEntry = mapOut.getString("SelectedEntry");		
		}
	// if the selected entry is empty consider this as cancel
		if (sSelectedEntry.length()<1)
		{
			eraseInstance();
			return;	
		}
		else
			setPropValuesFromCatalog(sSelectedEntry);
	
	// override elevation for catalog based insertion	
		if (dNewElevation>dEps)dElevation.set(dNewElevation);
		if (sAlignments.find(sNewAlignment)>-1)sAlignment.set(sNewAlignment);
		if (nNewPosIndex >-1)nPos.set(nNewPosIndex);
			
	// resolve blocks and dummy display
		int nQtyChilds;
		String sBlockPaths[]={sBlockPath1,sBlockPath2,sBlockPath3,sBlockPath4,sBlockPath5};
		String sBlockNames[sBlockPaths.length()];
		LineSeg segBlocks[0];
		// get the drawing name
		for (int i=0;i<sBlockPaths.length();i++)
		{
			String s=sBlockPaths[i];
			int n=-1;
			int nStart=n;
			//Get the last backslash
			do
			{
				n= s.find("\\",n+1);
				if (n>-1)nStart=n;
			}
			while(n>-1);
			if (nStart>-1)
			{
				nQtyChilds++;
				sBlockNames[i]=s.right(s.length()-nStart-1);
			}
			else
			{
			// check for extension
				nStart = s.find(".dwg",0);
				if (nStart<0)
					sBlockNames[i]=s;
				else
					sBlockNames[i]=s.left(s.length()-nStart);
				if (sBlockNames[i].length()>0)
					nQtyChilds++;	
			}		
			
			if (s.length()>0)
			{
				Block bl(sBlockPaths[i]);
				segBlocks.append(bl.getExtents());
				Display dpDummy(5);
				dpDummy.draw(segBlocks);
			}
		}		

		return;	
	}	
// end on insert________________________________________________________________________________________________________________________________

	//if (bDebug)	reportMessage("\nexecuting " + scriptName()+ "Handle " + _ThisInst.handle() + " repos 1st: " + _Map.getInt("reposFirstChild"));

	PLine plRings[0];
	int bIsOp[0];
	
	// on mapIO
	if (_bOnMapIO)
	{
		
		int bDebugIO=false;
		if (bDebugIO)reportMessage("\n" + scriptName() + " mapIO call...");
		Map mapIn=_Map;	
		Map mapOut;
		_Map = mapOut; // clear _Map and initialize as invalidation map
		
		int nFunction = mapIn.getInt("function");
		if (nFunction<=0)return;
		
	// function 1: calculate intersection
		if (nFunction==1)
		{
		// get args
			Entity ent = mapIn.getEntity("Element");
			Element el = (Element)ent;
			int nZone = mapIn.getInt("zone");
			ElemZone elzo = el.zone(nZone);
			double dShrink = mapIn.getDouble("shrink");
			double dStripLength= mapIn.getDouble("stripLength");
			
			if (bDebugIO)reportMessage("\nshrink: " + dShrink + "\nstrip: " + dStripLength);


			PLine plTool = mapIn.getPLine("plTool");
			PLine plZone = mapIn.getPLine("plZone");
			Point3d pts[0];
				
		// rebuidl zone and tool pp and intersect		
			PlaneProfile ppZone(plZone);	
			PlaneProfile ppTool(plTool);
			/*ppTool.intersectWith(ppZone);	
			plTool = PLine();
			plRings=ppTool.allRings();
			bIsOp=ppTool.ringIsOpening();
			for (int r=0;r<plRings.length();r++)
				if (!bIsOp[r] && plTool.area()<plRings[r].area())
					plTool=plRings[r];
					*/
	
			PLine plToolRebuild(elzo.vecZ());

		// shrink the tool contour if required
			if (abs(dShrink)>dEps && ppTool.area()>pow(dEps,2))
			{
			// get midgrips
				Point3d ptMoveGrips[] = ppTool.getGripEdgeMidPoints();
				// find start index and collect outer segments
				int nInd, nOuterInd[0];;
				Point3d pts[0];pts =ptMoveGrips;
				pts.append(ptMoveGrips[0]);
				for (int p=0;p<pts.length()-1;p++)
				{
					double d0 = (plZone.closestPointTo(pts[p])-pts[p]).length();
					double d1 = (plZone.closestPointTo(pts[p+1])-pts[p+1]).length();
					if (d1>dEps && d0<dEps)
					{
						nInd=p+1;
						if (nInd==pts.length())nInd=0;
						//ptMoveGrips[p+1].vis(p);
					}
					if (d0<dEps)
					{
						nOuterInd.append(p);
						pts[p].vis(8);
					}
				}
		
			// collect segment veectors
				pts= plTool.vertexPoints(false);
				Vector3d vySegs[0];
				for (int g=0;g<ptMoveGrips.length();g++)
				{
					for (int p=0;p<pts.length()-1;p++)//
					{
						Vector3d vec = pts[p+1]-pts[p];	
						LineSeg ls(pts[p],pts[p+1]);
						if (ls.distanceTo(ptMoveGrips[g])<dEps)
						{
							Vector3d vySeg= vec.crossProduct(-elzo.vecZ());
							vySeg.normalize();//vySeg.vis(ls.ptMid(),g);
							vySegs.append(vySeg);
							break;	
						}
					}
				}
		
			// modify the tool contour
				for (int p=0;p<ptMoveGrips.length();p++)
					if (nOuterInd.find(p)<0 && vySegs.length()>p)
						ppTool.moveGripEdgeMidPointAt(p,vySegs[p]*dShrink);
			}// END if shrink

		// get outer ring of tool
			PLine pl(elzo.vecZ());
			plRings=ppTool.allRings();
			bIsOp=ppTool.ringIsOpening();
			for (int r=0;r<plRings.length();r++)
				if (!bIsOp[r] && pl.area()<plRings[r].area())
					pl=plRings[r];
			pts= pl.vertexPoints(false);		
			
			int nStartSeg;// will be 0 if milling area is not intersecting
			for(int p = 0; p < pts.length()-1; p++)
			{
				if (ppZone.pointInProfile(pts[p]) == _kPointOnRing &&
					 ppZone.pointInProfile((pts[p]+pts[p+1])/2) == _kPointInProfile)
				nStartSeg = p;	
			}		
			if (pts.length()>nStartSeg)pts[nStartSeg].vis(6);

		// loop points and rebuild the tool pline
			for(int p = 0; p < pts.length()-1; p++)
			{
				int n,m;
				n = (p + nStartSeg) % (pts.length()-1);
				m = (p + nStartSeg + 1) % (pts.length()-1);
				pts[n].vis(n);
				int nOnRing0, nOnRing1;
				nOnRing0 = ppZone.pointInProfile(pts[n]);
				nOnRing1 = ppZone.pointInProfile(pts[m]);	
				
				if ((nOnRing0 == _kPointOnRing || nOnRing0 == _kPointInProfile) && nOnRing1 == _kPointInProfile)
				{
					Vector3d vecSeg= pts[m]-pts[n];
					if (dStripLength>0 && vecSeg.length()>dStripLength && p == 0)
					{
						vecSeg.normalize();
						plToolRebuild.addVertex(pts[n]+vecSeg*dStripLength);
					}
					else
						plToolRebuild.addVertex(pts[n]);
	
	
					if (dStripLength>0 && vecSeg.length()>dStripLength && p == pts.length()-2)
					{
						vecSeg.normalize();
						plToolRebuild.addVertex(pts[m]-vecSeg*dStripLength);
					}					
					else
					{
						plToolRebuild.addVertex(	pts[m]);	
					}
				}				
				else if(nOnRing0 == _kPointInProfile&& nOnRing1 == _kPointInProfile)
					plToolRebuild.addVertex(	pts[m]);	
	
	
				else if(nOnRing0 == _kPointInProfile&& nOnRing1 == _kPointOnRing )
					plToolRebuild.addVertex(	pts[m]);
			}
			
		// return an open pline if stripLength >0
			//pts = plToolRebuild.vertexPoints(true);
			//plToolRebuild=PLine();
			//for(int p = 0; p < pts.length(); p++)		
			//	plToolRebuild.addVertex(pts[p]);
			mapOut.setPLine("plTool", plToolRebuild);	
			PLine plToolRectangle(elzo.vecZ());
			plToolRectangle.createRectangle((PlaneProfile(plToolRebuild)).extentInDir(el.vecX()), el.vecX(), el.vecY());
			mapOut.setPLine("plToolRectangle", plToolRectangle);			
			
		}
	// END function 1: calculate intersection
		else if (nFunction ==2)
		{
		// this function checks a potential intersection of an extruded shape with any beam being send in with an extrusion profile
		// if a collision was found it returns a reduced depth and an alert point which will be used to display alerts
		
		// get args
			Entity ent = mapIn.getEntity("Element");
			Element el = (Element)ent;
			Vector3d vecDir = mapIn.getVector3d("vecDir");
			PLine plShape=mapIn.getPLine("Shape");
			plShape.setNormal(vecDir);
			double dDepthIn=mapIn.getDouble("Depth");
			double dDepth=dDepthIn;

			Body bdTest(plShape,vecDir*dDepth, 1);
			
			Point3d ptAlert=(PlaneProfile(plShape)).extentInDir(el.vecX()).ptMid();
			
			int bAddAlert;
		// loop mapIn and search for beams with an extrusion profile
			for (int m=0;m<mapIn.length();m++)
			{
				ent = mapIn.getEntity(m);
				Beam bm = (Beam)ent;
				if (bm.bIsValid() && bm.extrProfile()!=T("|Rectangular|") && bm.extrProfile()!=T("|Round|"))
				{
					//reportMessage("\n" + scriptName() + " mapIO " + bm.handle());
					Body bdR= bm.envelopeBody(true,true);
					bdR.intersectWith(bdTest);		//bdR.vis(5);
				// if an intersection with the realBody was found correct depth and flag alert
					if (bdR.volume()>pow(dEps,3))
					{
						Point3d pts[] = bdR.extremeVertices(vecDir);
						if (pts.length()>0)
						{
							double d=vecDir.dotProduct(pts[0]-ptAlert)-U(2);
							//reportMessage("\n" + scriptName() + " depth now = " + d);
							if (d<dDepth) 
							{
								//EntPLine epl;
								//epl.dbCreate(PLine(ptAlert,pts[0]));
								//epl.setColor(222);
								dDepth = d;
								bAddAlert=true;
							}
						}															
					}// end if collision found						
				}// END IF valid extrusion profile beam		
			}// next m
			
		// report if alert is flagged
			if (bAddAlert)
			{					
				reportMessage("\n********** " + T("|Warning|")+ 
					" **********\n"+ T("|Drill depth corrected due to collision with profiled beam in element|") + 
					" " +el.number() + TN("|Please validate construction!|") + "\n**********************");
				
				mapOut.setPoint3d("ptAlert", ptAlert);
				mapOut.setDouble("depth", dDepth);
			}		
		}// END IF function 2: test intersection with extrusion profile

		_Map=mapOut;
		return;		
	}
// end mapIO	____________________________________________________________________________________________________   end mapIO


// on creation
	if (_bOnDbCreated || _bOnElementConstructed)setExecutionLoops(2);
	if (_bOnDbCreated && _Map.hasString("CatalogEntry"))
	{
		String sCatalogEntry = _Map.getString("CatalogEntry");
		if(_ThisInst.setPropValuesFromCatalog(sCatalogEntry))
			_Map.removeAt("CatalogEntry", true);
	}

// version control
	int nCurrentVersion= _ThisInst.version();
	if (_bOnDbCreated)
		_Map.setInt("version", nCurrentVersion);
	int nPreviousVersion= _Map.getInt("version");

// purge obsolete references
	if (nPreviousVersion<140008)
	{
		if(bDebug)reportMessage("\n" + scriptName() + " " + T("|Element|") + " " + _ThisInst.element().number() + " " +  _ThisInst.handle() + " " + T("|will purge obsolete references.|") + " (" + _GenBeam.length() + ")");	
		_GenBeam.setLength(0);
		setExecutionLoops(2);	
	}
	_Map.setInt("version", nCurrentVersion);




// declare the parent and its map
	TslInst tslParent;
	Map mapParent;

// set me to the parent on time of creation		
	if (_bOnDbCreated && _Entity.length()>0)
	{
	// assign VDE Alignment for custom 0: vertical combinations distribute from bottom upwards
	// deprectated Version 15.7: VDE Alignment should be controlled via settings
		//if (nProjectSpecial==0)
		//{
			//bHasVDEAlignment = true;
			//_Map.setInt("hasVDEAlignment",bHasVDEAlignment);
		//}	
				
		// #4
		tslParent = (TslInst)_Entity[0];
		if (tslParent.bIsValid())
		{
			_Pt0 = tslParent.ptOrg();
			Map mapParent = tslParent.map();
			Vector3d vzT_Parent= mapParent.getVector3d("vzT");
			/*
			if (_Map.getInt("RemoteFlip"))
			{
				
				double dZ = el.dPosZOutlineFront()-el.dPosZOutlineBack();
				vzT_Parent*=-1;
				vzT_Parent=vzT_Parent*(dTxtH+dZ);
			}
			else
				vzT_Parent=vzT_Parent*(dTxtH);
				
				*/
			_PtG.append(_Pt0+ vzT_Parent * dTxtH);
			

			if(0)
			{
				EntPLine epl;
				epl.dbCreate(PLine(PLine(_PtW,_Pt0,_PtG[_PtG.length()-1])));
				epl.setColor(2);	
			}
			
		
			// the updating after adding a new combination still needs to be reviewed (Version 5.8)		
			Map mapChilds = mapParent.getMap("Child[]");
			
			// store a relocation flag if no childs are in the parent map yet (Version 9.1)
			// the seqeunce of execution is not known on dbCreation of the parent and the child. 
			// this can cause that _Pt0 of the parent is not relocated which will then use the click point to be the grip _PtG[0] of this instance instead of _Pt0+vzT+dTxtH
			// this flag will tweak it and be removed after repos
			if ( mapChilds.length()<1)	_Map.setInt("reposFirstChild",1);	
			
			//reportMessage("\n" + scriptName() + " Handle: " + _ThisInst.handle() + " mapChilds.length:" + mapChilds.length() + ":" + mapChilds);
			mapChilds.setEntity(_ThisInst.handle(),_ThisInst);
			mapParent.setMap("Child[]",mapChilds);
	
			tslParent.transformBy(Vector3d(0,0,0));		
			mapParent.setInt("requestGripLocation",true);	
			tslParent.setMap(mapParent);
			_Entity.append(tslParent);	
			tslParent.recalc();
			_ThisInst.recalc();
			//reportMessage("\nHandle " + _ThisInst.handle() + " insert on creation ended map " + _Map);	
		}
		else
		{
			reportWarning("\nParent assignment failed.");	
		}	
	}

	//if (bDebug)	reportMessage("\n" + scriptName() + " start execution." + _ThisInst.handle());

	//setExecutionLoops(2);

// ints
	int bOppositeTool = sNoYes.find(sOppositeTool);if (bOppositeTool<0)bOppositeTool=0;
	if (abs(dHorizontalOffset)>dEps && nProjectSpecial==1)sOffsetTool.set(sNoYes[1]);
	int bOffsetTool= sNoYes.find(sOffsetTool);if (bOffsetTool<0)bOffsetTool=0;

// assign parent tsl
	//TslInst tslChilds[0];
	for(int i=0;i<_Entity.length();i++)
	{
		TslInst tsl = (TslInst)_Entity[i];
		if (tsl.bIsValid() && tsl.scriptName().makeUpper() == sParentName)
		{
			setDependencyOnEntity(_Entity[i]);
			tslParent= tsl;
		
		// get the map of the parent and append me to the list of childs
			mapParent = tslParent.map();
			Map mapChilds = mapParent.getMap("Child[]");
			if (!mapChilds.hasEntity(_ThisInst.handle()))
			{
			// store an index in relation to the other childs
				_Map.setInt("myIndex", mapChilds.length());
				if (bDebug)reportMessage("\nappending child " + _ThisInst.handle());
				mapChilds.setEntity(_ThisInst.handle(),_ThisInst);
				mapParent.setMap("Child[]", mapChilds);
				tslParent.setMap(mapParent);	
			}
		}
	}// next i	

	
// validate parent	
	if (!tslParent.bIsValid())
	{
	// if a combination is added to an existing installation by the context command the Entity array does not return;
	// the send in parent tsl. In the mystery of reexecution the tsl this reference shows up. the map entry wait tweaks this.
		if (_Map.getInt("wait"))
		{
			if (bDebug)reportMessage("\nThis tsl is in wait state and has Entities: " + _Entity);
			_Map.removeAt("wait",true);	
		}
		else
		{
			reportMessage("\n"+T("No valid instance of") + " " + sParentName + " " + T("|could be found|") +". " + T("Tool will be deleted."));
			eraseInstance();	
		}
		return;
	}
	

//region Read Settings
double dCombinationStandardDiameter,dCombinationMaxClosedMilling,dCombinationExtraDiameterBeamInterference,dReliefHeight,dReliefDepth,dReliefHeightExtension;
int nReliefMode,nCreateAnnotation,bCreateAnnotationElement,bDrawDrillGuideLine,bCombinationDrawFilledSymbol=true,bCombinationDrawElevationElementView,bHasPeninsulaMilling=true,nPlanAnnotationIndex = -1;
String sPlanAnnotationGripIndex = "PlanAnnotationGripIndex";
int bUseGenbeamReference;
// HSB-23569
int bSupressCnCElementTooling;

{
	String k;
	Map m= mapSetting;//.getMap("SubNode[]");
	k="VDEAlignment";					if (m.hasInt(k))	bHasVDEAlignment = m.getInt(k);// overrule VDE alignment settings
	k="CreateAnnotation";				if (m.hasInt(k))	nCreateAnnotation = m.getInt(k);// create annotation entities (1) or additional grip point (2) on insert
	if (nCreateAnnotation ==-99)nCreateAnnotation =false;
	k="CreateAnnotationElement";		if (m.hasInt(k))	bCreateAnnotationElement = m.getInt(k);
	if (bCreateAnnotationElement==-99)bCreateAnnotationElement=false;
	k="DrawDrillGuideLine";				if (m.hasInt(k))	bDrawDrillGuideLine = m.getInt(k);
	if (bDrawDrillGuideLine==-99)bDrawDrillGuideLine=false;
	k="CombinationDrawFilledSymbol";	if (m.hasInt(k))	bCombinationDrawFilledSymbol = m.getInt(k);
	k="CombinationDrawElevationElementView";	if (m.hasInt(k))	bCombinationDrawElevationElementView = m.getInt(k);
	if (bCombinationDrawElevationElementView==-99)bDrawDrillGuideLine=false;

	k="CombinationStandardDiameter";		if (m.hasDouble(k))	dCombinationStandardDiameter = m.getDouble(k);// collect values for a potential relief beamcut when a clash is detected
	k="CombinationMaxClosedMilling";		if (m.hasDouble(k))	dCombinationMaxClosedMilling = m.getDouble(k);// specify max value width or height of slotted or rectangular millings contours to be closed
	if (dCombinationMaxClosedMilling>0 && (dWidth<dCombinationMaxClosedMilling || dDiameter<dCombinationMaxClosedMilling))
		bHasPeninsulaMilling=false;
	// HSB-23569
	k="SupressCnCElementTooling";	if (m.hasInt(k))	bSupressCnCElementTooling = m.getInt(k);

// collect the grip index of a potential additional grip of the annnotation. this grip can be created if the key 'CreateAnnotation' is set to 2
	/// this index will be used to make the grip relative to _PtG0
	
	k=sPlanAnnotationGripIndex;	if (_Map.hasInt(k))	nPlanAnnotationIndex = _Map.getInt(k);

	m = mapSetting.getMap("InstallationPoint");
	k="UseGenbeamReference";					if (m.hasInt(k))		bUseGenbeamReference = m.getInt(k);
}

//region Global Settings
	String sTriggerSupressCnCElementTooling = T("|Supress CnC Element Tooling|");
	
	//region HSB-23569 Trigger GlobalSettings
		String sTriggerSupressCnCElementToolings = sTriggerSupressCnCElementTooling;
		addRecalcTrigger(_kContextRoot, sTriggerSupressCnCElementToolings );
		if (_bOnRecalc && _kExecuteKey==sTriggerSupressCnCElementToolings)
		{
			Map mpAskIn;
			mpAskIn.setString("Prompt", "Supress CnC Element Tooling?");
			mpAskIn.setString("Title", T("|Supress CnC Element Tooling|"));
			Map mapItems;
			Map m;
		    m.setInt("IsSelected",!bSupressCnCElementTooling);
		    m.setString("Text",sNoYes[0]);
		    mapItems.appendMap("Item",m);
		    m.setInt("IsSelected",bSupressCnCElementTooling);
		    m.setString("Text",sNoYes[1]);
		    mapItems.appendMap("Item",m);
		    
		    mpAskIn.setMap("Items[]", mapItems);
			
			Map mpAskOut = callDotNetFunction2(sDialogLibrary, sClass, optionsMethod, mpAskIn);
			if(mpAskOut.length()>0)
			{ 
				// update settings
				String sCatalogSelected=mpAskOut.getString("Selection");
				int bSelected=sNoYes.find(sCatalogSelected);
				if(bSelected>-1)
				{ 
					if(bSelected!=bSupressCnCElementTooling)
					{ 
						mapSetting.setInt("SupressCnCElementTooling",bSelected);
						if (mo.bIsValid())mo.setMap(mapSetting);
						else mo.dbCreate(mapSetting);
					}
				}
			}
			
			setExecutionLoops(2);
			return;
		}//endregion	
	
//endregion Global Settings


// set constants from parent
	nColor = tslParent.propInt(0);
	sDimStyle = tslParent.propString(2);
	dTxtH  = tslParent.propDouble(4);
	int nParentSide = mapParent.getInt("Side");
	Map mapRoom = mapParent.getMap("Room");
	PlaneProfile ppFloor = mapParent.getPlaneProfile("floorPlan");ppFloor.vis(4);
	double dFloorThickness = mapRoom.getDouble("RoomFloorThickness");
	double dFloorElevation = mapRoom.getDouble("RoomElevation");
	String sRoomNumber = mapRoom.getString("RoomNumber");
	String sRoomLevel= mapRoom.getString("RoomLevel");
	Entity entRoom=mapRoom.getEntity("Room");

	double dPlanAnnotationOffset=dTxtH;// default = textheight
	{ 
		String k;
		Map m= mapSetting.getMap("Combination\\Text");
		k="PlanAnnotationOffset";		if (m.hasDouble(k))	dPlanAnnotationOffset = m.getDouble(k);
	}


// test if the location is on the outside
	int bCombinationIsExposed;
	if (nProjectSpecial!=1) // do not use exterior assignment for Lux HSB-9758
	{ 
		PlaneProfile pp = ppFloor;
		pp.removeAllOpeningRings();
		pp.shrink(dEps);
		
		PlaneProfile ppRoom;
		if (entRoom.bIsValid())
		{ 
			ppRoom = entRoom.realBody().shadowProfile(Plane(_Pt0, _ZW));
			ppRoom.shrink(-dEps);
			pp.unionWith(ppRoom);
		}
		Point3d ptX = _PtG.length() > 0 ? _PtG[0] : _Pt0;
		pp.vis(3);//ptX.vis(4);
		bCombinationIsExposed=pp.pointInProfile(ptX)==_kPointOutsideProfile;
	}
// reset parent room link if location has been dragged but no room found (i.e. stair area where there is no room)	
	if (_Map.getInt("hasNoRoom") && !bCombinationIsExposed && entRoom.bIsValid())
	{ 
		entRoom = Entity();
		dFloorThickness = 0;
		dFloorElevation = 0;
		sRoomNumber = "";
		sRoomLevel = "";
	}

// get custom floor thickness if specified
	if (dFloorThickness==0)
	{ 
		String k;
		k = "CustomFloorThickness"; if (mapParent.hasDouble(k))dFloorThickness=mapParent.getDouble(k);
	}



// get default properties for additional text display
	int nColorTxt = nColor;
	int bHideText;
	double dTxtHTxt = dTxtH;
	double dAngleTxt = _Map.getDouble("AngleTxt"); // default is set to 0	
	String sDimStyleTxt = sDimStyle;
	
	int bReliefBeamOnly; // flag to set relief cut only to beams and leave sheeting operations in standard
	double dReliefDepthExposed;
	
	{ 
		String k;
		Map m= mapSetting;
	// legacy	
		k="CombinationTextColor";	if (m.hasInt(k))	nColorTxt = m.getInt(k);
		k="CombinationTextHeight";		if (m.hasDouble(k) && m.getDouble(k)>0)	dTxtHTxt = m.getDouble(k);
		k="CombinationTextAngle";		if (m.hasDouble(k) && !_Map.hasDouble("AngleTxt"))	{dAngleTxt = m.getDouble(k);_Map.setDouble("AngleTxt",dAngleTxt);}
		k="CombinationTextDimStyle";	if (m.hasString(k) &&  _DimStyles.find(m.getString(k))>-1)	sDimStyleTxt = m.getString(k);	
		
	// new structure
		k="Combination";	
		if (m.hasMap(k))
		{
			m = m.getMap(k);	
			k="Text";	if (m.hasMap(k))
			{
				m = m.getMap(k);
				k="Hide";			if (m.hasInt(k))	bHideText = m.getInt(k);
				k="Color";			if (m.hasInt(k))	nColorTxt = m.getInt(k);
				k="TextHeight";		if (m.hasDouble(k) && m.getDouble(k)>0)	dTxtHTxt = m.getDouble(k);
				k="Angle";			if (m.hasDouble(k) && !_Map.hasDouble("AngleTxt"))	{dAngleTxt = m.getDouble(k);_Map.setDouble("AngleTxt",dAngleTxt);}
				k="DimStyle";		if (m.hasString(k) &&  _DimStyles.find(m.getString(k))>-1)	sDimStyleTxt = m.getString(k);			
			}
		}
	// legacy
		k="CombinationExtraDiameterBeamInterference";		if (m.hasDouble(k))	dCombinationExtraDiameterBeamInterference = m.getDouble(k);
		k="CombinationReliefDepth";			if (m.hasDouble(k))	dReliefDepth = m.getDouble(k);
		k="CombinationReliefDepthExposed";	if (m.hasDouble(k))	dReliefDepthExposed = m.getDouble(k);
		k="CombinationReliefHeight";		if (m.hasDouble(k))	dReliefHeight = m.getDouble(k);
		k="CombinationReliefHeightExtension";	if (m.hasDouble(k))	dReliefHeightExtension = m.getDouble(k);
		k="CombinationReliefMode";			if (m.hasInt(k))	nReliefMode = m.getInt(k);
		
	
	// new structure
		m = mapSetting;	
		k="Combination";	
		if (m.hasMap(k))
		{
			m = m.getMap(k);
			k="Relief";		if (m.hasMap(k))
			{
				m = m.getMap(k);
				k="ExtraDiameterBeamInterference";		if (m.hasDouble(k) && m.getDouble(k)>0)	dCombinationExtraDiameterBeamInterference = m.getDouble(k);
				k="Height";				if (m.hasDouble(k))	dReliefHeight = m.getDouble(k);
				k="HeightExtension";	if (m.hasDouble(k) && m.getDouble(k)>0)	dReliefHeightExtension = m.getDouble(k);
				k="Depth";				if (m.hasDouble(k))	dReliefDepth = m.getDouble(k);
				k="DepthExposed";		if (m.hasDouble(k) && m.getDouble(k)>0)	dReliefDepthExposed = m.getDouble(k);
				k="BeamOnly";			if (m.hasInt(k))	bReliefBeamOnly = m.getInt(k);	
				k="Mode";				if (m.hasInt(k))	nReliefMode = m.getInt(k);			
			}
		}	
		
	// instance values
		if(nProjectSpecial==1 && dReliefDepth<=0)dReliefDepth=U(70);
		k="CombinationReliefDepth";			if (_Map.hasDouble(k))	dReliefDepth = _Map.getDouble(k);// overwrite by instance values
		k="CombinationReliefHeight";		if (_Map.hasDouble(k))	dReliefHeight = _Map.getDouble(k);// overwrite by instance values
		
		if (nReliefMode==-99)nReliefMode=0;
	}

//End Read Settings//endregion 



// edit combination - Standard Doubleclick Action
	String sTriggerEdit = T("|Edit|");
	if (_bOnRecalc && ( _kExecuteKey==sTriggerEdit ||  _kExecuteKey==sDoubleClick))
	{
	// store current properties in in temp entry
		setCatalogFromPropValues(sTempEntryName);	

		
	// compose an empty ModelMap
		Map mapIn, mapOut;
		ModelMapComposeSettings mmComposeFlags;
		ModelMap mm;
		mm.dbComposeMap(mmComposeFlags);				
		mapIn=mm.map();
		mapIn.setMap("Height[]", mapHeights);	
		mapIn.setString("CatalogEntryName", sTempEntryName );
		mapIn.setInt("ShowAllProperties", true);		

		
	// call the dialog which returns a catalog entry	
		mapOut = callDotNetFunction2(strAssemblyPath, strType, strFunctionCombination , mapIn);
		//mapOut.writeToXmlFile("c:\\temp\\editOut.xml");	
		String sSelectedEntry = mapOut.getString("SelectedEntry");
	// if the selected entry is empty consider this as cancel
		if (sSelectedEntry.length()>0)	
		{
			setPropValuesFromCatalog(sSelectedEntry);
		}
		
		tslParent.recalc();
	}

// calculate scale factor from text height
	// assuming that a standard block has size 200mm x 200mm
	double dCellXY=dTxtH*2;
	double dScaleFactor = dTxtH/U(200);

// on creation time get the element of the parent
	if (_bOnDbCreated)
	{
		Entity ents[]=tslParent.entity(); 
		for(int i=0;i<ents.length();i++)
		if (ents[i].bIsKindOf(ElementWall()))
		{
			_Element.append((Element)ents[i]);
			break;
		}				
	}	
	// HSB-21736: try to get the element from paren
	if (_Element.length() < 1 || !_Element[0].bIsKindOf(ElementWall()))
	{ 
		tslParent.recalcNow();
		Entity ents[]=tslParent.entity(); 
		for(int i=0;i<ents.length();i++)
		if (ents[i].bIsKindOf(ElementWall()))
		{
			_Element.append((Element)ents[i]);
			setExecutionLoops(2);
			return;
			break;
		}	
	}
// declare standards
	if (_Element.length() < 1 || !_Element[0].bIsKindOf(ElementWall()))
	{
		reportMessage("\nmissing element");
		eraseInstance();
		return;
	}

// reassign element if the one which is mapped in parent is different (moved or copied)		
	if (mapParent.hasEntity("Element") && mapParent.getEntity("Element").handle()!=_Element[0].handle())
	{
		if (bDebug)reportMessage("\n"+scriptName() + ": reassigning element reference" );
		Entity ent = mapParent.getEntity("Element");
		Element elNew=(Element)ent;
		_Element[0]=elNew;
		
	}

	ElementWall el = (ElementWall)_Element[0];
	
// during wall split multiple elements may be linked: take the closest one
	if (_Element.length()>1)
	{
		double dMax=U(10000000);
		for (int i=0;i<_Element.length();i++)
		{
			if (!_Element[i].bIsKindOf(ElementWall()))continue;
			Point3d ptNext = _Element[i].plOutlineWall().closestPointTo(_Pt0);
			double d = (ptNext-_Pt0).length();
			if (d<dMax)
			{
				el =(ElementWall) _Element[i];
				dMax = d;
			}	
		}	
		_Element.setLength(1);
		_Element[0]=el;	
		assignToElementGroup(el, true,0, 'C');	
	}	

	
// element coord sys
	Point3d ptOrg;
	Vector3d vecX,vecY,vecZ;
	ptOrg = el.ptOrg();	
	vecX=el.vecX();					
	vecY=el.vecY();					
	vecZ=el.vecZ();					
	//vecX.vis(ptOrg, 1);vecY.vis(ptOrg, 3);vecZ.vis(ptOrg, 150);
	int bExposed=el.exposed();


//region override parent room by combination room if any
	if (_Map.hasEntity("Room"))
	{ 
		Entity _entRoom = _Map.getEntity("Room");
		if (_entRoom.bIsValid())
		{ 
			entRoom = _entRoom;
			setDependencyOnEntity(entRoom);
			String sPropSetNames[] = entRoom.attachedPropSetNames();
			String sPropertyNames[] = {"Höhe_Fußboden", "Raum-Nummer", "Etage"};
			String k;
			for (int i=0; i<sPropSetNames.length();i++)
			{ 
				Map map = entRoom.getAttachedPropSetMap(sPropSetNames[i],sPropertyNames);
				k = sPropertyNames[0]; if(map.hasDouble(k)) dFloorThickness = map.getDouble(k);
				k = sPropertyNames[1]; if(map.hasString(k)) sRoomNumber = map.getString(k);
				k = sPropertyNames[2]; if(map.hasString(k)) sRoomLevel = map.getString(k);					
			}
			
		//try to achieve bottom height by entity grips
			Point3d ptGrips[0];
			ptGrips = entRoom.gripPoints();
		// fall back to solid	
			if (ptGrips.length()<1)
				ptGrips = entRoom.realBody().extremeVertices(_ZW);
			ptGrips = Line(_Pt0,_ZW).orderPoints(ptGrips);
			if (ptGrips.length()>0)
				dFloorElevation=_ZW.dotProduct(ptGrips[0]-ptOrg);	
				
			if(bDebug)reportNotice("\nRoom "+ entRoom.handle() + " found \n	dFloorElevation:" + dFloorElevation + "\n	dFloorThickness:" + dFloorThickness+ "\n	sRoomLevel:" + sRoomLevel+ "\n	sRoomNumber:" + sRoomNumber );	
		}		
	}		
//End override parent room by combination room if any//endregion 


// override ReliefDepth in case a specific value has been defined for exposed types
	if (bExposed && dReliefDepthExposed)		dReliefDepth = dReliefDepthExposed;

// assignment
	assignToGroups(tslParent);
	assignToElementFloorGroup(el, false, 0,'C');
	assignToElementGroup(el, false,0, 'C');

// get wall outline
	PLine plOl=el.plOutlineWall();
	if (mapParent.hasPLine("plOutlineWall")) 
	{
		PLine pl = mapParent.getPLine("plOutlineWall");
		if (pl.area()>pow(dEps,2))
			plOl = pl;
	}
	Point3d ptMid;
	ptMid.setToAverage(plOl.vertexPoints(true));
	
	
// Display
	Display dpPlanMeter(nColor),dpPlanMillimeter(nColor), dpModel(sColors[0]),dpElement(nColor),dpElementZone0(nColor);
	Display dpPlanTxt(nColorTxt);
	dpPlanTxt.dimStyle(sDimStyleTxt);
	dpPlanTxt.textHeight(dTxtHTxt);
	dpPlanTxt.addViewDirection(vecY);
	
// set electrical plan display
	if (bHasPlanElectricalDisp)
	{
		dpPlanElectrical.dimStyle(sDimStyle);
		dpPlanElectrical.textHeight(dTxtH);	
		dpPlanElectrical.elemZone(el,0,'I');
		dpPlanElectrical.addViewDirection(vecY);
		dpPlanElectrical.showInDispRep(sDispRepElectrical);
	}	
	
	dpPlanMeter.dimStyle(sDimStyle);
	dpPlanMeter.textHeight(dTxtH);	
	dpPlanMeter.elemZone(el,0,'I');
	dpPlanMeter.addViewDirection(vecY);	
	
	
	if (nProjectSpecial==1)
	{
		dpPlanMeter.showInDispRep("LUX AP");
		dpPlanMillimeter.showInDispRep("LUX AV");		
	}

	dpPlanMillimeter.dimStyle(sDimStyle);
	dpPlanMillimeter.textHeight(dTxtH);	
	dpPlanMillimeter.elemZone(el,0,'I');
	dpPlanMillimeter.addViewDirection(vecY);


	dpModel.elemZone(el,0,'I');
	dpModel.addHideDirection(vecY);

	dpElement.textHeight(dTxtH);		

		
	dpElementZone0.textHeight(dTxtH);	
	dpElementZone0.addViewDirection(vecZ);		
	dpElementZone0.elemZone(el,0,'I');	

// get stored type of horizontal offset
	int nTypeOffset = _Map.getInt("typeOffset");
	
// validate annotation entity	
	int bHasAnnotation = _Map.getEntity("Annotation").bIsValid();
	int bHasAnnotationElement= _Map.getEntity("AnnotationElement").bIsValid();

// for custom 0 assign VDE Alignment as default. assignment only done on dbCreate or changing the posindex to support previous versions
	if (_kNameLastChangedProp == sPosName && nProjectSpecial==0)
	{
		bHasVDEAlignment = true;
		_Map.setInt("hasVDEAlignment",bHasVDEAlignment);
	}
	
// on the event of dragging _Pt0
	if(_kNameLastChangedProp == "_Pt0")
	{
		dElevation.set(vecY.dotProduct(_Pt0-ptOrg)-dFloorThickness-dFloorElevation);	
		
	// horizontal dragging only allowed when offset has been set once	
		if (abs(dHorizontalOffset)>dEps)
			dHorizontalOffset.set(vecX.dotProduct(_Pt0-tslParent.ptOrg()));
			
	// update parent
		if (bDebug)reportMessage("\n   update parent because _Pt0 has changed");
		tslParent.recalc();
	}


// on the event of dragging _PtG0 make the annotation to follow, on changing the description update annotation
	if((_kNameLastChangedProp == "_PtG0" || (_kNameLastChangedProp == sDesc1Name || _kNameLastChangedProp == sDesc2Name)) && bHasAnnotation)
	{
		//reportMessage("\n"+_kNameLastChangedProp + " has been dragged");
		Entity ent =_Map.getEntity("Annotation");
		TslInst tsl=(TslInst)ent;
		Vector3d vec = _Map.getVector3d("vecAnnotation");
		if (tsl.bIsValid())tsl.setPtOrg(_PtG[0]+vec);	
	}
	
// on the event of dragging _PtG0 and an additional annotation grip 
	int bUpdatePlanAnnoGrip;
	int bDebugPlanAnnoGrip=false;
	if(_kNameLastChangedProp == "_PtG0" && nPlanAnnotationIndex>-1)
	{
		if (bDebugPlanAnnoGrip)reportMessage("\nPlanAnnotationGrip ("+_ThisInst.handle()+ ") 1141: bUpdatePlanAnnoGrip = " + bUpdatePlanAnnoGrip);
		bUpdatePlanAnnoGrip=true;
	}

// on the event of changing the elevation or pt0
// a potetial elementView Annotation has to follow pt0
	if(((_kNameLastChangedProp == sElevationName || _kNameLastChangedProp == "_Pt0") || 
		(_kNameLastChangedProp == sDesc1Name || _kNameLastChangedProp == sDesc2Name)) && 
		bHasAnnotationElement)
	{
		Entity ent =_Map.getEntity("AnnotationElement");
		TslInst tsl=(TslInst)ent;
		Vector3d vec = _Map.getVector3d("vecAnnotationElement");
		if (tsl.bIsValid())	tsl.setPtOrg(_Pt0+vec);	
	}

// on the event of changing the elevation
	if(_kNameLastChangedProp == sElevationName)
	{
	// update parent	
		tslParent.recalc();
		if (bDebug)reportMessage("\n   update parent because " + sElevationName + "has changed");
	}

// on the event of changing the horizontal offset
	if(_kNameLastChangedProp == dHorizontalOffsetName )
	{
		if (abs(dHorizontalOffset)<dEps)
		{
			nTypeOffset=0;	
			_Map.setInt("typeOffset",nTypeOffset);			
		}
	// update parent	
		tslParent.recalc();
		if (bDebug)reportMessage("\n   update parent because " + dHorizontalOffsetName + "has changed");
	}

// on the event of changing the width of a horizontal wirechase
	if(_kNameLastChangedProp == sWidthHorWirechaseName)
	{
		tslParent.recalc();
		if (bDebug)reportMessage("\n   update parent because " + sWidthHorWirechaseName+ "has changed");
	}

// the offset between the installations may never be smaller than 0
	if (dOffsetInstallations<=dEps)
	{
		dOffsetInstallations.set(dDiameter);
	}

// if the invert flag is set also invert the block path properties
	if (_Map.getInt("invertIndex"))	
	{
		int nMax;
		String sBlockpaths[0];
		if (sBlockPath1.length()>0)sBlockpaths.append(sBlockPath1);
		if (sBlockPath2.length()>0)sBlockpaths.append(sBlockPath2);
		if (sBlockPath3.length()>0)sBlockpaths.append(sBlockPath3);
		if (sBlockPath4.length()>0)sBlockpaths.append(sBlockPath4);
		if (sBlockPath5.length()>0)sBlockpaths.append(sBlockPath5);
		
		String sBlockpathsReverse[0];
		for (int i=sBlockpaths.length()-1;i>=0;i--)	
			sBlockpathsReverse.append(sBlockpaths[i]);
		for (int i=0;i<sBlockpathsReverse.length();i++)
		{
			if (i==0)sBlockPath1.set(sBlockpathsReverse[i]);
			else if (i==1)sBlockPath2.set(sBlockpathsReverse[i]);
			else if (i==2)sBlockPath3.set(sBlockpathsReverse[i]);
			else if (i==3)sBlockPath4.set(sBlockpathsReverse[i]);
			else if (i==4)sBlockPath5.set(sBlockpathsReverse[i]);	
		}
		
	}

	
// collect optional texts in array
	String sAllTexts[] = {sTxt1, sTxt2, sTxt3, sTxt4, sTxt5};	
	

// collect the blocks from the given path's
	int nQtyChilds;
	String sBlockPaths[]={sBlockPath1,sBlockPath2,sBlockPath3,sBlockPath4,sBlockPath5};
	String sBlockNames[sBlockPaths.length()];
	LineSeg segBlocks[0];
	Block	blocks[0];
	String sTexts[0]; //a collector of all texts corresponding to one block
	// get the drawing name
	for (int i=0;i<sBlockPaths.length();i++)
	{
		String s=sBlockPaths[i];
		int n=-1;
		int nStart=n;
		//Get the last backslash
		do
		{
			n= s.find("\\",n+1);
			if (n>-1)nStart=n;
		}
		while(n>-1);
		if (nStart>-1)
		{
			nQtyChilds++;
			sBlockNames[i]=s.right(s.length()-nStart-1);
		}
		else
		{
		// check for extension
			nStart = s.find(".dwg",0);
			if (nStart<0)
				sBlockNames[i]=s;
			else
				sBlockNames[i]=s.left(s.length()-nStart);
			if (sBlockNames[i].length()>0)
				nQtyChilds++;	
		}		
		
		if (s.length()>0)
		{
			Block block(sBlockPaths[i]);
			blocks.append(block);
			sTexts.append(sAllTexts[i]);
			segBlocks.append(block.getExtents());
		}
	}

// detect special overrides
	int bHasSpecial4;
	// special 4
	for (int i=0;i<sBlockNames.length();i++)
	{
		String s = 	sBlockNames[i];
		s.makeUpper();
		s=s.right(12);
		if (s.right(12)=="_HSBKEY4.DWG")
		{
			bHasSpecial4=true;
			nPos.set(2);
			break;
		}
	}

// ints
	int nAlign=sAlignments.find(sAlignment);
	int nShape = sShapes.find(sShape);
	int bShapeByInstallation = sShape==kShapeByInstallation;
	
// invert the position index if requested from IP (occurs when IP flips its side)
	//reportMessage("\n"+scriptName()+" " + _ThisInst.handle() + " invertstate " + _Map.getInt("invertIndex"));
	if (_Map.getInt("invertIndex"))
	{
		int nMax = nQtyChilds*2-1;
		if (!bShapeByInstallation)nMax=3;
		int nToMin = nPos-1;
		int nToMax = nMax-nPos;
		int nPosInvert = nPos-nToMin+nToMax;
		nPos.set(nPosInvert);
		_Map.removeAt("invertIndex",true);		
	}	

// collect relevant genbeams from parent or from wall if offset exceeds 350mm
	Point3d ptParentOrg = tslParent.ptOrg();
	Point3d ptPrevParentOrg = ptParentOrg ;
	if (_Map.hasPoint3d("parentOrg"))ptPrevParentOrg = _Map.getPoint3d("parentOrg");
	double dParentMove = Vector3d(ptPrevParentOrg -ptParentOrg).length();
	
// validate the qty of childs
	if (nQtyChilds<1)
	{
		reportMessage(TN("|No displaying blocks could be found for a combination in element|") + " " + el.number() + ". " + T("|Tool will be deleted.|"));
		eraseInstance();
		return;	
	}

// query block tsls to set default masking during creation
	if (_bOnDbCreated || _Map.getInt("bQueryBlockTsls"))// || _bOnDebug)
	{
		//reportMessage("\n" + scriptName() + " start searching blocks....bOnDbCreated =" + _bOnDbCreated ); // HSB-15727
		_Map.removeAt("bQueryBlockTsls", true);
		for (int i=0;i<sBlockNames.length();i++)
		{
			String sBlockName = sBlockNames[i];
			if (sBlockName.right(4).makeUpper() == ".DWG")
				sBlockName=sBlockName.left(sBlockName.length()-4);
			//reportMessage("\n    Blockname: " +sBlockName);	
			if (_BlockNames.find(sBlockName)>-1)
			{
				Block block(sBlockName);
				TslInst tsls[] = block.tslInst();
				
				for (int t=0;t<tsls.length();t++)
				{
					TslInst tsl =tsls[t];
					String sPropNames[]=tsl.getListOfPropNames();
					int bBreak;
				// has plan view property
					if (tsl.hasPropString(T("|Plan view|")))
					{
						int bShow = sNoYes.find(tsl.propString(T("|Plan view|")));
						if (!bShow)_Map.setInt("maskAnnotation", true);
						reportMessage("\n" + scriptName() + " " + T("|Plan view|") + "=" + _Map.getInt("maskAnnotation"));
						bBreak=true;
					}
				//// has element view property
					if (tsl.hasPropString(T("|Element View|")))
					{
						int bShow = sNoYes.find(tsl.propString(T("|Element View|")));
						if (!bShow )_Map.setInt("maskAnnotationElement", true);
						bBreak=true;
					}
					if (bBreak)break;	
				}// next t of tsls	
			}// END IF (_BlockNames.find(sBlockName)	
		}// next i sBlockNames
	}// END IF _bOnDbCreated

// shape and type dependencies
	if (!bShapeByInstallation)
	{
		dOffsetInstallations.setReadOnly(true);
		if (nQtyChilds>1)
			dOffsetInstallations.set((dWidth-dDiameter)/(nQtyChilds-1));	
	}	
	else
		dOffsetInstallations.setReadOnly(false);
	
	// if an offset is given but the type not selected default to horizontal
	if (nTypeOffset ==0 && abs(dHorizontalOffset)>dEps)
	{
		nTypeOffset=1;	
		_Map.setInt("typeOffset",nTypeOffset);
	}



// if shape is toggled 
	if(_kNameLastChangedProp == sShapeName)
	{
		//and width is not set, default it to the diameter
		if(!bShapeByInstallation && dWidth<dEps)
		{
			dWidth.set(nQtyChilds*dDiameter);
		}
		
		int nShape = sShapes.find(sShape);
		if (nShape>-1 && nToolIndex!=nToolIndices[nShape])
		{
			nToolIndex.set(nToolIndices[nShape]);
			reportMessage(TN("|Toolindex set to| " + nToolIndex));
		}
		setExecutionLoops(2);
		return;
	}


// limit the position index to the max valid
	String sMsg;
	if (nArPos.find(nPos)<0)
	{
		sMsg = nPos;
		nPos.set(2);
	}
	if (bShapeByInstallation && (nQtyChilds *2)-1<nPos)
	{			
		sMsg = nPos;
		nPos.set((nQtyChilds *2)-1);
	}	
	if (sMsg!="")
	{
		reportMessage(TN("|Position Index|") +  " " + T("is out of range") + ". ");
		reportMessage("\n   " +T("Element") + " " + el.number()); 
		for (int i=0;i<sBlockNames.length();i++)
			if (sBlockNames[i].length()>0)
				reportMessage("\n   " +sBlockNames[i]); 	
		reportMessage(TN("|Value corrected from|") +" " + sMsg + " -> " + nPos);
	}


// alignment triggers
	String sAlignmentsTrigger[] = {T("|Alignment|") + " " +T("|Left|"), T("|Alignment|") + " "+ T("|Center|"), T("|Alignment|") + " " +T("|Right|")};
	if (nAlign ==1)
	{
		sAlignmentsTrigger[0]=T("|Alignment|") + " "+ T("|Top|");
		sAlignmentsTrigger[2]=T("|Alignment|") + " "+ T("|Bottom|");
	}
// add triggers
	String sTrigger[] = {T("|Flip Side|")};		// 0
	sTrigger.append(sAlignmentsTrigger);				// 1-3
	sTrigger.append("----------");					// 4
	sTrigger.append(T("|Link to Installation Point|"));	// 5	
		
// the offset triggers can be set if an offset of the combination is defined
	String sArSelected[] = {"", "    ", "    ", "    ", "    "};
	//if(nTypeOffset>0)
	sArSelected[nTypeOffset] = "[x] ";
	String sArOffsetTrigger[] = {T("|Set horizontal Offset|"), sArSelected[1]+ T("|horizontal|"), sArSelected[2] + T("|vertical bottom|"), sArSelected[3] + T("|vertical top|"), sArSelected[4] + T("|aligned|")};
	if(nTypeOffset>0)
	{
		sArOffsetTrigger[0]=T("|Reset Offset|");		// alter 6: reset offset
		sTrigger.append(sArOffsetTrigger);				// 7-10
	}
	else
		sTrigger.append(sArOffsetTrigger[0]);			// 6: select offset
		
	for (int i = 0; i < sTrigger.length(); i++)
		addRecalcTrigger(_kContext, sTrigger[i]);	


// set a duplicate entry which will fire one standard recalc with key
	addRecalcTrigger(_kContext, sTriggerEdit);	


// event trigger index
	int nTriggerIndex=-1;
	if (_bOnRecalc && _kExecuteKey!="")
		nTriggerIndex=sTrigger.find(_kExecuteKey);

// event trigger: set/reset offset
	if (_bOnRecalc && _kExecuteKey==sTrigger[6])
	{
		if (nTypeOffset >0)
		{
			nTypeOffset =0;
			dHorizontalOffset.set(0);
			_Pt0 = _Pt0-vecX*vecX.dotProduct(_Pt0-tslParent.ptOrg());
		// update parent
			tslParent.recalc();
		}
		else
		{
			nTypeOffset =1;
			PrPoint ssP("\n" + T("|Select point|"),_Pt0); 
			if (ssP.go()==_kOk)
			{
				Point3d pt= ssP.value(); 
				double d = vecX.dotProduct(pt-ptParentOrg);	
				dHorizontalOffset.set(d);
				_Map.setDouble("horizontalOffset", d);
			}
			
			sTrigger.setLength(6);
			sTrigger.append(sArOffsetTrigger);
						
		}
		_Map.setInt("typeOffset",nTypeOffset );
		setExecutionLoops(2);
	}	

// event trigger:  horizontal offset
	int nOffsetTrigger = sTrigger.find(_kExecuteKey);
	if (_bOnRecalc && nOffsetTrigger>6)
	{
		
		nTypeOffset =nOffsetTrigger-6;
		_Map.setInt("typeOffset",nTypeOffset );
		
		
	// for aligned offset get a grip and store the index			
		if (nTypeOffset==4)
		{
			_GenBeam.append(el.genBeam()); // make sure all genbeams are collected for this
			PrPoint ssP("\n" + T("|Select point|"),_Pt0); 
			if (ssP.go()==_kOk)
			{
				Point3d pt= ssP.value(); 
				_PtG.append(pt);
				_Map.setInt("alignedOffsetGripIndex", _PtG.length()-1);
			}			
		}
		else if (_Map.hasInt("alignedOffsetGripIndex"))
		{
			int n = _Map.getInt("alignedOffsetGripIndex");
			if (bDebugPlanAnnoGrip)reportMessage("\nPlanAnnotationGrip ("+_ThisInst.handle()+ ") 1569: alignedOffsetGripIndex= " + n);
			if (_PtG.length()>n)
				_PtG.removeAt(n);
			_Map.removeAt("alignedOffsetGripIndex",true);	
			_GenBeam.setLength(0);
			
		}
		setExecutionLoops(2);
	}	
	
//region Vertical offset / change elevation
	// Trigger VerticalOffset//region
		String sTriggerChangeElevation = T("|Change Elevation|");
		addRecalcTrigger(_kContext, sTriggerChangeElevation );
		if (_bOnRecalc && _kExecuteKey==sTriggerChangeElevation)
		{
			Entity ents[] ={ _ThisInst};
			double dDelta = getDouble(T("|Enter vertical offset|"));
			
			if (abs(dDelta)>0)
			{ 
			// prompt for tsls
				
				PrEntity ssE(T("|Select additional combinations (optional)|"), TslInst());
			  	if (ssE.go())
					ents.append(ssE.set());
				
			// change elevation
				for (int i=ents.length()-1; i>=0 ; i--) 
				{ 
					TslInst tsl=(TslInst)ents[i];
					if (!tsl.bIsValid()) continue;
					if(tsl.scriptName()==scriptName())
						tsl.setPropDouble(sElevationName, tsl.propDouble(sElevationName)+dDelta);
				}				
			}

			setExecutionLoops(2);
			return;
		}//endregion	
		
//End Vertical offset / change elevation//endregion 	
	
	
	
	

// get flag if annotation is masked
	int bMaskedAnnotation = _Map.getInt("maskAnnotation");
	int bMaskedAnnotationElement = _Map.getInt("maskAnnotationElement");	
	
// add blind trigger if at least one of the 1s is not appended
	if (!bHasAnnotation || !bHasAnnotationElement)
	{
		addRecalcTrigger(_kContext, "---------- ");// a blind trigger			
	}

// declare arrays for tsl cloning
	TslInst tslNew;
	Vector3d vUcsX = _XW;
	Vector3d vUcsY = _YW;
	GenBeam gbAr[0];
	Entity entAr[0];
	Point3d ptAr[0];
	int nArProps[0];
	double dArProps[0];
	String sArProps[3];
	Map mapTsl;
	String sScriptname = scriptName();	
	
	
	entAr.append(_ThisInst);	
	entAr.append(el);
	
	
	nArProps.append(nColor);
	dArProps.append(dTxtH);
	sArProps[2] = sDimStyle;


	
// append annotation entry to the list of triggers
	if (!bHasAnnotation)
	{
		String sAnnoTrigger = T("|create plan annotation|");
		mapTsl.setInt("mode",1);
		addRecalcTrigger(_kContext, sAnnoTrigger );// a annotation trigger	
		if (_bOnRecalc && _kExecuteKey==sAnnoTrigger)
		{
			Point3d pt = getPoint();
			mapTsl.setPoint3d("ptBase", pt);//Version 12.3: make sure the selected point is kept
			ptAr.append(pt);
			//reportNotice("\ncalling the annotation");			
			tslNew.dbCreate(sScriptname, vUcsX,vUcsY,gbAr, entAr, ptAr, 
				nArProps, dArProps, sArProps,_kModelSpace, mapTsl); // create new instance	
			if (tslNew.bIsValid())
			{
				_Map.setEntity("Annotation", tslNew);	
				_Map.setVector3d("vecAnnotation", pt-_PtG[0]);
				_Map.setInt("maskAnnotation",true);// mask the annotation if the annotation entity has been deleted by the user
				setExecutionLoops(2);
				tslNew.recalc();
			}	
		}
	}
	if (!bHasAnnotationElement)
	{
		String sAnnoElementTrigger = T("|create element annotation|");
		mapTsl.setInt("mode",2);
		addRecalcTrigger(_kContext, sAnnoElementTrigger );// a annotation trigger	
		if (_bOnRecalc && _kExecuteKey==sAnnoElementTrigger )
		{
			Point3d pt = getPoint();
			ptAr.append(pt);
			//reportNotice("\ncalling the annotation");			
			tslNew.dbCreate(sScriptname, vUcsX,vUcsY,gbAr, entAr, ptAr, 
				nArProps, dArProps, sArProps,_kModelSpace, mapTsl); // create new instance	
			if (tslNew.bIsValid())
			{
				_Map.setEntity("AnnotationElement", tslNew);	
				_Map.setVector3d("vecAnnotationElement", pt-_Pt0);
				_Map.setInt("maskAnnotationElement",true);// mask the annotation if the annotation entity has been deleted by the user
				setExecutionLoops(2);
				tslNew.recalc();				
			}	
		}
	}

// show triggers to mask annotations if flagged
	if (!bHasAnnotation && (nCreateAnnotation!=1 || bMaskedAnnotation))
	{		
		String sTriggerToggleAnno = T("|hide Plan Annotation|");
		if (bMaskedAnnotation)  sTriggerToggleAnno = T("|show Plan Annotation|");
		addRecalcTrigger(_kContext, sTriggerToggleAnno );// a trigger to toggle visibility of the annotation 	
		if (_bOnRecalc && _kExecuteKey==sTriggerToggleAnno )
		{
			if (bMaskedAnnotation)
				bMaskedAnnotation=false;
			else
				bMaskedAnnotation =true;
			_Map.setInt("maskAnnotation",bMaskedAnnotation);
			setExecutionLoops(2);
		}
	}
	if (!bHasAnnotationElement && (!bCreateAnnotationElement || bMaskedAnnotationElement))
	{		
		String sTriggerToggleAnnoElement = T("|hide Element Annotation|");
		if (bMaskedAnnotationElement)  sTriggerToggleAnnoElement = T("|show Element Annotation|");
		addRecalcTrigger(_kContext, sTriggerToggleAnnoElement );// a trigger to toggle visibility of the annotation 	
		if (_bOnRecalc && _kExecuteKey==sTriggerToggleAnnoElement )
		{
			if (bMaskedAnnotationElement)
				bMaskedAnnotationElement=false;
			else
				bMaskedAnnotationElement =true;
			_Map.setInt("maskAnnotationElement",bMaskedAnnotationElement);
			setExecutionLoops(2);
		}
	}

// event trigger:  Link to Installation Point
	if (_bOnRecalc && _kExecuteKey==sTrigger[5])
	{	
		// selection of parent entity: the E-Point		
		PrEntity ssE(T("|Select parent|"), TslInst());
		Entity ents[0];  		
		if (ssE.go())
	    	ents = ssE.set();
		
		TslInst tslNewParent;
		for(int i=0;i<ents.length();i++)
		{
			TslInst tsl = (TslInst)ents[i];
			if (tsl.bIsValid() && tsl.scriptName().makeUpper() == sParentName)
			{
				tslNewParent= tsl;
				break;
			}	
		}// next i

		if (!tslNewParent.bIsValid())
		{
			reportMessage("\n"+T("No valid instance of") + " " + sParentName + " " + T("|could be found|"));	
		}
		else if (_Entity.find(tslNewParent)>-1)
		{
			reportMessage("\n"+T("Already attached to") + " " + sParentName);	
		}
		else
		{
		// release a previous set parent
			if (tslParent.bIsValid())
			{
				int n = _Entity.find(tslParent);
				if (n>-1) _Entity.removeAt(n);		
			}	

		// assign to new parent
			if (bDebugPlanAnnoGrip)reportMessage("\nPlanAnnotationGrip ("+_ThisInst.handle()+ ") 1729: assign to new parent");			
			_Pt0 = tslNewParent.ptOrg();
			_PtG.setLength(0);
			_PtG.append(_Pt0+tslNewParent.map().getVector3d("vzT")*dTxtH);
			_Entity.append(tslNewParent);
			tslParent = tslNewParent;
			
		// get element of parent
			Element elNew = tslParent.element();
			if (elNew.bIsValid())assignToElementGroup(elNew, true,0, 'C');		
			
		// update parent
			setExecutionLoops(2);
		}
	}
// END event trigger:  Link to Installation Point
	
	
// add text rotation trigger	
	if (!bHideText && sTexts.length()>0)
	{
		addRecalcTrigger(_kContext, "----------  ");// a blind trigger		
		String sTriggerRotationTxt45 = T("|Rotate Text 45°|") ;
		addRecalcTrigger(_kContext, sTriggerRotationTxt45);	
		String sTriggerRotationTxt90 = T("|Rotate Text 90°|") ;
		addRecalcTrigger(_kContext, sTriggerRotationTxt90);	
		String sTriggerRotationTxt180 = T("|Rotate Text 180°|");
		addRecalcTrigger(_kContext, sTriggerRotationTxt180);				
		if (_bOnRecalc && _kExecuteKey==sTriggerRotationTxt45)
		{
			dAngleTxt += 45;
			if (dAngleTxt >=360)dAngleTxt =360-dAngleTxt ;
			_Map.setDouble("AngleTxt",dAngleTxt, _kNoUnit);
			setExecutionLoops(2);
			return;		
		}
		if (_bOnRecalc && _kExecuteKey==sTriggerRotationTxt90)
		{
			dAngleTxt += 90;
			if (dAngleTxt >=360)dAngleTxt =360-dAngleTxt ;
			_Map.setDouble("AngleTxt",dAngleTxt, _kNoUnit);
			setExecutionLoops(2);
			return;		
		}
		else if (_bOnRecalc && _kExecuteKey==sTriggerRotationTxt180)
		{
			dAngleTxt += 180;
			if (dAngleTxt >=360)dAngleTxt =360-dAngleTxt ;
			_Map.setDouble("AngleTxt",dAngleTxt, _kNoUnit);
			setExecutionLoops(2);	
			return;				
		}
	}	
	
	
	
	
// set _Pt0 to height
	if (!_Map.getInt("OnWallSplit"))
	{
		Point3d pt0 = _Pt0;
		_Pt0 = plOl.closestPointTo(_Pt0)+vecY*(dElevation+dFloorThickness+dFloorElevation);	
		if (abs(vecY.dotProduct(pt0-_Pt0))>dEps && tslParent.bIsValid())
			tslParent.transformBy(Vector3d(0, 0, 0));
			
	}

	
// set to horizontal offset
	if(_kNameLastChangedProp == dHorizontalOffsetName || abs(dHorizontalOffset)>dEps)
	{
		double d = vecX.dotProduct(_Pt0-ptParentOrg);	
		_Pt0.transformBy(vecX*(dHorizontalOffset-d));	
	}
	Line lnY(_Pt0,vecY);

	
// side of installation is dependent from its location(_Pt0)
	int nSide=1;
	if(vecZ.dotProduct(_Pt0-ptMid)<0) nSide*=-1;

// get vecZ of parent entity
	Vector3d vzT = vecZ;
	if (mapParent.hasVector3d("vzT"))
	vzT = mapParent.getVector3d("vzT");
	//if (nParentSide != 0 && nParentSide!=nSide)vzT*=-1;
	vzT.vis(_Pt0,6);


// set a flag to swap horizontal pos index direction for opposite side
	int nSwapHorizontalDirection=1;
	//if (nAlign==0 && nSide==1) nSwapHorizontalDirection=-1;


// force annotation to follow if flag has been set in previous run of this instance
	if(bHasAnnotation &&_Map.getInt("FollowMe"))
	{
		Entity ent = _Map.getEntity("Annotation");
		TslInst tslAnno=(TslInst)ent;
		if (tslAnno.bIsValid())
		{
			Map mapAnno = tslAnno.map();
			mapAnno.setInt("flipSide", true);
			tslAnno.setMap(mapAnno);
		}
		_Map.setInt("FollowMe",false);
	}



// define triggers and events
	int bSearchRoom = _kNameLastChangedProp=="_PtG0";

	// flip side
	int bFlip = _Map.getInt("Flip");
	int bRemoteFlip = _Map.getInt("RemoteFlip");// the installation point has requested a flip
	int bRepositionGrips,bRepositionCombinations;
	if (_bOnRecalc && _kExecuteKey==sTrigger[0] || bRemoteFlip)
	{
		//if (bRemoteFlip)reportMessage("\n"+ scriptName() + " remote Flip requested, current flip="+bFlip);
		//else reportMessage("\n"+ scriptName() + " Flip requested, current flip="+bFlip);
		double dZ = el.dPosZOutlineFront()-el.dPosZOutlineBack();
		nSide*=-1;	
		_Pt0.transformBy(vecZ*nSide*dZ);
		if (bFlip)bFlip = false;
		else bFlip = true;
		_Map.setInt("Flip",bFlip);
		_Map.setInt("FollowMe",true);
		
	// reset flag of remote flip
		if (bRemoteFlip)
		{
			bRemoteFlip=false;
			_Map.setInt("RemoteFlip", bRemoteFlip);
			bRepositionGrips=true;	
			bUpdatePlanAnnoGrip=true;
		}
		_ThisInst.transformBy(Vector3d(0,0,0));
		bSearchRoom = true;
	}
	
// alignment left or top
	if (_bOnRecalc && _kExecuteKey==sTrigger[1])
	{
		if (bHasVDEAlignment && nAlign==1)
			nPos.set((nQtyChilds *2)-1);		
		else
			nPos.set(1);
	}
// alignment center
	if (_bOnRecalc && _kExecuteKey==sTrigger[2] &&  nQtyChilds>0)
	{
		if (bShapeByInstallation)
			nPos.set(nQtyChilds);
		else nPos.set(2);
	}
// alignment right or bottom
	if (_bOnRecalc && _kExecuteKey==sTrigger[3] &&  nQtyChilds>0)		
	{
		if (bShapeByInstallation)
		{
			if (bHasVDEAlignment && nAlign==1)
				nPos.set(1);
			else
				nPos.set((nQtyChilds *2)-1);
		}
		else nPos.set(3);
	}

// reset _GenBeam if color is set to red (1)- this is a hidden method to upgrade the genbeam reference method from version 14.8 on
	//if (_ThisInst.color()==1)_GenBeam.setLength(0);
	
// control entity color to differntiate between icon and opposite icon on dimensioning
	if(nSide==1)_ThisInst.setColor(sColors[0]);
	else 
	{
		_ThisInst.setColor(sColors[1]);	
		dpModel.color(sColors[1]);
	}
	
// get the bounds of all plan view frames	
	Point3d ptFrameBounds[] = mapParent.getPoint3dArray("frameBounds");	
		
// add grip if not existant
	if (_PtG.length()<1)
	{
		if (bDebugPlanAnnoGrip)reportMessage("\nPlanAnnotationGrip ("+_ThisInst.handle()+ ") 1906: add grip");
		//reportMessage("\n index = " + _Map.getInt("myIndex"));
		double d = dTxtH + _Map.getInt("myIndex")*dTxtH*3.2;
		ptFrameBounds=Line(_Pt0,-vzT).orderPoints(ptFrameBounds)	;
		if (ptFrameBounds.length()>0)
		{
			d = vzT.dotProduct(ptFrameBounds[0]-_Pt0)+dTxtH;
		}
		_PtG.append(_Pt0+nSide*vecZ*d );	
	}	
	
	
// repos grip if flag set (Version 9.1)
	if (_PtG.length()>0 && _Map.getInt("reposFirstChild"))
	{
		if (bDebugPlanAnnoGrip)reportMessage("\nPlanAnnotationGrip ("+_ThisInst.handle()+ ") 1921: reposFirstChild");
		_PtG[0] = _Pt0+vzT*dTxtH;
		_Map.removeAt("reposFirstChild",false);
	}	
	
	
	Point3d ptRef=_PtG[0];
	if (abs(vecY.dotProduct(ptRef-_Pt0))>dEps)// allign to same _ZW
		ptRef.transformBy(vecY*vecY.dotProduct(_Pt0-ptRef));
	//ptRef.vis(3);	


// plan and element coordSys of the combination
	Vector3d vxP,vyP,vzP,vxE,vyE,vzE;
	// E: coordSys seen in element
	// P coordSys seen in plan view
	// C coordSys seen in element (hor/ver)
	vzP = vecY;
	vzE = nSide*vecZ;		
	if (nAlign==0)
	{
		vxP=vzP.crossProduct(vzT);			
	}
	else
	{
		vxP=vzT;	
		if (nParentSide!=0 && nParentSide!=nSide)
		{
			vxP*=-1;	
		}
		//vxE=-vecY;		
	}
	vxE =vecY.crossProduct(vzE);	
	vyE =vxE.crossProduct(-vzE);	
	vyP=vxP.crossProduct(-vzP);	

// zones
	int nZone=nRelativeZn*nSide;
	int nZones[0];
	if (nRelativeZn==99)
	{
		for(int i=1;i<6;i++)
			if (el.zone(i*nSide).dH()>dEps)
			{
				nZone=i*nSide;	
				nZones.append(nZone);
			}
	}
	ElemZone elzo = el.zone(nZone);
	Point3d ptOrgZone = elzo.ptOrg();
	Vector3d vecZZone = elzo.vecZ();
	double dHZone = elzo.dH();
	
// set zone view direction
	dpElement.addViewDirection(vzE);
	dpElement.elemZone(el,nZone,'I');

// on creation write grip map
	if (_bOnDbCreated)
	{
		Map mapGrips;
		if (bDebugPlanAnnoGrip)reportMessage("\nPlanAnnotationGrip ("+_ThisInst.handle()+ ") 1972: write grip map, length = " + _PtG.length());
		for (int i=0;i<_PtG.length();i++)
		{
			double dX = vxE.dotProduct(_PtG[i]-_Pt0);
			double dY = vyE.dotProduct(_PtG[i]-_Pt0);
			double dZ = vzE.dotProduct(_PtG[i]-_Pt0);
			Map mapGrip;
			mapGrip.setDouble("dXGrip", dX);
			mapGrip.setDouble("dYGrip", dY);
			mapGrip.setDouble("dZGrip", dZ);
			
		// store absolute grip location as well
			mapGrip.setVector3d("GripAbsolute", _PtG[i]-_PtW);

			mapGrips.setMap(i, mapGrip);
			_Map.setPoint3d("PtG"+i,_PtG[i]);
			//reportMessage("\n   storing grip on creation "+ i + " xyz " + dX +"/" + dY+"/" + dZ + " on loop " + _kExecutionLoopCount);

		}	
		_Map.setMap("Grip[]",mapGrips);
	}

// the opposite side zone and it's depth. to be used if opposite tooling is activated
	int nOppZone;
	for(int i=1;i<6;i++)
		if (el.zone(i*-nSide).dH()>dEps)
		{
			nOppZone=i*-nSide;	
			nZones.append(nOppZone);
		}
	double dOppositeDepth = el.zone(nOppZone).dH()+dEps;

// declare override of zone to be collected, version 6.7
	int nSheetZone= nZone;
	if (bHasSpecial4)nSheetZone=abs(nSheetZone);

// collect sheets
	Sheet sheets[0];
	GenBeam gbsAll[0],gbsZone0[0];

// COLLECT relevant genBeams	
	// collect all directly from element	
	int bCollectFromElement;
	if (dHorizontalOffset>U(350))// || bHasSpecial4)
		bCollectFromElement=true;
	// collect subset of parent
	else if (_bOnDbCreated || _bOnRecalc || _bOnElementConstructed ||	dParentMove >dEps)// ||_bOnDebug)	
	{
		gbsAll = tslParent.genBeam();
		for (int i=0;i<gbsAll.length();i++)
			if (_GenBeam.find(gbsAll[i])<0)	
				_GenBeam.append(gbsAll[i]);
	// if the parent does not provide any genBeams yet fall back to the collection of all genBeams	
		if (gbsAll.length()<1)bCollectFromElement=true;
		_Map.setPoint3d("parentOrg", ptParentOrg);
		//reportMessage("\ngbsAll=" +gbsAll.length() + " bCollectFromElement:" + bCollectFromElement);	
	}
	else if (gbsAll.length()<1 && _GenBeam.length()<1)
		bCollectFromElement=true;

// collect from element
	if (bCollectFromElement)	
		gbsAll = el.genBeam();
// append collection from genBeam array (used if set to horizontal offset)
	for (int i=0;i<_GenBeam.length();i++)
		if (gbsAll.find(_GenBeam[i])<0)
			gbsAll.append(_GenBeam[i]);
	
// purge gbsAll
	for(int i=gbsAll.length()-1;i>=0;i--)
	{
		GenBeam gb = gbsAll[i];
	// remove dummies and sheets which are not in one of the zones
		if (gb.bIsDummy() || (!gb.bIsKindOf(Beam()) && nZones.find(gb.myZoneIndex())<0))	
			gbsAll.removeAt(i);
	}		

// collect the sheets of the current zone
	for(int i=0; i<gbsAll.length();i++)
	{
		GenBeam gb = gbsAll[i];
		int n = gb.myZoneIndex();
		
		if (nZones.find(n)>-1 && gb.bIsKindOf(Sheet()))	
		{
			sheets.append((Sheet)gb);
//			if (1)
//			{
//				Body bd= gb.realBody();
//				bd.transformBy(vecZ*U(400));
//				bd.vis(51);
//			}
		}

		else if (n==0 && gb.bIsKindOf(Beam()))	
			gbsZone0.append(gb);
	}
	//reportMessage("\ngbsZone0=" +gbsZone0.length());
	//reportMessage("\nsheets=" +sheets.length());

// transform zome origin if flaggerd
	if (bUseGenbeamReference)
	{ 
		//elzo.ptOrg().vis(4);
		for (int i=0;i<sheets.length();i++) 
		{ 
			Sheet& sh=sheets[i];
			if (sh.myZoneIndex() == nZone)
			{ 
				dHZone = sh.dD(vecZ);
				Point3d pt = sh.ptCenSolid() + vecZZone * .5 * dHZone;//pt.vis(4);
				ptOrgZone += vecZ * vecZ.dotProduct(pt- ptOrgZone);	
			}
		}//next i	
	}

//// get zone
//	ElemZone ez =el.zone(nZone); 
//	
//
// override zone by genbeam location if varies from zone and specified in settings with UseGenbeamReference
	Plane pnZone(ptOrgZone, vecZZone);


// zone contour
// build pp of zone
	PlaneProfile ppZone(CoordSys(ptOrgZone, vecY.crossProduct(-vecZZone),vecY,vecZZone));
	PLine plZone=el.plEnvelope(ptOrgZone);
	for (int g=0;g<sheets.length();g++)
	{	
		Sheet sh = sheets[g];
		if (ppZone.area()<pow(10*dEps,2))
			ppZone=PlaneProfile(sh.plEnvelope());
		else
			ppZone.joinRing(sh.plEnvelope(),_kAdd);	
	// subtract openings	
		PLine plOpenings[] = sh.plOpenings();
		for (int r=0;r<plOpenings.length();r++)				
			ppZone.joinRing(plOpenings[r],_kSubtract);					
	}
	// cleanup
	ppZone.shrink(-dEps);
	ppZone.shrink(dEps);


	// fall back to profShape if nothing found
	if (ppZone.area()<pow(dEps,2))
	{
		ppZone = PlaneProfile(el.profNetto(nSheetZone));	
	}

	plRings=ppZone.allRings();
	bIsOp=ppZone.ringIsOpening();
	
// get outer ring of zone // version 9.3 with multiple rings: merging is done by a convexe Hull which might result a wrong shape within the merging area
	{
	// test if zone is made of multiple non opening rings	
		Point3d pts[0];
		int nNumShapeRings;
		for (int r=0;r<plRings.length();r++)
			if (!bIsOp[r] && plRings[r].area()>pow(dEps,2))
			{
				pts.append(plRings[r].vertexPoints(true));
				nNumShapeRings++;
			}
		
		PLine pl;
		
	// get ring if not multiple
		if (nNumShapeRings<2)
		{
			for (int r=0;r<plRings.length();r++)
				if (!bIsOp[r] && pl.area()<plRings[r].area())
					pl=plRings[r];
		}
	// get ring if multiple
		else
		{
			pl.createConvexHull(pnZone,pts);
		}
		if (pl.area()>pow(dEps,2))plZone = pl;	
		else plZone = el.plEnvelope(ptOrgZone);		
	}	
	ppZone=PlaneProfile(plZone);


// repos to edge of zone contour if _Pt0 was dragged outside of zone contour
	if((_bOnDebug || _kNameLastChangedProp=="_Pt0") && ppZone.pointInProfile(_Pt0)==_kPointOutsideProfile)
	{
		
		Point3d ptInt[] = lnY.orderPoints(plZone.intersectPoints(Plane(_Pt0,vecX)));
		if (ptInt.length()>1)
		{
			if (bDebug)reportMessage("\n...entering repositioning");
			Point3d ptEdge = ptInt[1];
			double d1 = vecY.dotProduct(_Pt0-ptInt[0])+dFloorThickness;
			double d2 = vecY.dotProduct(_Pt0-ptInt[1])+dFloorThickness;
			int nDirOutside=1;
			if (d1>d2 && d1<0)
			{
				ptEdge = ptInt[0];
				nDirOutside*=-1;
			}
			//vecY.vis(ptEdge ,2);
			
		// alignment vertical, auto adjust to bottom or top	
			if (nAlign==1)
			{
			//dragged point above zone
				if(nDirOutside==1)		nPos.set(3);
			//dragged point below zone	drilled shapes	
				else if(nDirOutside==-1 && bShapeByInstallation && nQtyChilds >0)nPos.set((nQtyChilds *2)-1);
			// dragged point below zone rectangular or slotted shapes	
				else if (nDirOutside==-1 && !bShapeByInstallation)nPos.set(1);
				setExecutionLoops(2);
			}
			dElevation.set(vecY.dotProduct(ptEdge-ptOrg)-dFloorThickness);
			if (bDebug)reportMessage("\n...leaving repositioning with elevation " +dElevation);
		}		
	}

	
	//ppZone.vis(6);
	
// auto depth of tool: incremented by 1mm to accept tolerances on the production table	
	double dToolDepth = dDepth;
	if (dToolDepth<=0)dToolDepth = dHZone+U(1);

// get the flag if remotely set to static location (flip side without combinations from IP)
	int bRemoteStaticLocation = _Map.getInt("remoteStaticLocation");
	
// grip point repositioning after dragging the parent
	int nFlip = 1;
	if ((dParentMove>dEps && !bRemoteStaticLocation) || (_bOnRecalc && _kExecuteKey==sTrigger[0]))
	{
	// set a flip condition if the _pt0 is dragged to the opposite side
	// some obscure reactor behaviour prevents otherwise the grip location to bve mirrored to opposite side
		if (mapParent.getInt("Side")==-nSide) nFlip*=-1;		
		//setExecutionLoops(2);
	// control position in element x
		if (_kExecuteKey==sTrigger[0] || bFlip)
		{
			nFlip=1;
			_Pt0 = _Pt0 - vxE*vxE.dotProduct(_Pt0-ptParentOrg);
			if (bDebug)	reportMessage("\n   moving grip element x ");
			//bDrawBlock=false;
		}			
	// control position in element xz 			
		else
		{
			_Pt0 = _Pt0 - vxE*vxE.dotProduct(_Pt0-ptParentOrg)- vzE*vzE.dotProduct(_Pt0-ptParentOrg);
			if (bDebug)	reportMessage("\n   moving grip element xz ");
			//bDrawBlock=false;
		}			

	// if it was flipped to other side, make sure the dZ gets restored		
		bRepositionGrips=true;
			
	}
	else if (bRemoteStaticLocation)_Map.removeAt("remoteStaticLocation",true);


// set the flip flag for combinations which have been copied by the installation with the combination on the opposite side
	if (_bOnDbCreated && _Map.hasInt("flipOnCopy"))
	{
		int bFlipOnCopy = _Map.getInt("flipOnCopy");
		nFlip=-1;	
		_Map.removeAt("flipOnCopy", true);
	}

// reposition grips upon request
	if (bRepositionGrips)
	{
		Map mapGrips = _Map.getMap("Grip[]");
		bUpdatePlanAnnoGrip=true;
	// repos grips, get the offset values in relation to _Pt0
		//reportMessage("\n	" + _ThisInst.opmName() + " reposition grips upon request: " bRepositionGrips);
		if (bDebugPlanAnnoGrip)reportMessage("\nPlanAnnotationGrip ("+_ThisInst.handle()+ ") 2190: bRepositionGrips = " + bRepositionGrips);
		if (_kExecutionLoopCount==0 && !_Map.hasInt("alignedOffsetGripIndex"))
		{
			for(int i=0;i<_PtG.length();i++)
			{
				if (mapGrips.hasMap(i))
				{
					Map mapGrip = mapGrips.getMap(i);
					double dX = mapGrip.getDouble("dXGrip");
					double dY = mapGrip.getDouble("dYGrip");
					double dZ = mapGrip.getDouble("dZGrip");
					//if (bDebug)	reportMessage("\n   moving grip "+ i + " xyz " + dX +"/" + dY+"/" + dZ + " on parent side " + mapParent.getInt("side") + " Exloop " + _kExecutionLoopCount);
					
					_PtG[i] = _Pt0 + vxE*dX + nFlip*vzE*dZ;//+vyE*dY 
					if (nFlip==-1)
					{
					// store absolute grip location as well
						mapGrip.setVector3d("GripAbsolute", _PtG[i]-_PtW);
						
						mapGrip.setDouble("dZGrip",dZ);
						mapGrips.setMap(i,mapGrip);
					}
				}		
			}		
		}
		_Map.setMap("Grip[]",mapGrips);	
	}	


//region Search room assignment
	if (bSearchRoom || _bOnDebug)
	{ 
		Group grAll[] = Group().allExistingGroups();
		
	// set test body, get wall height from envelope
		Body bdTest;
		{ 
			double dY = U(3200);
			Point3d pts[] = el.plEnvelope().intersectPoints(Plane(_Pt0,vecX));	
			if (pts.length()>1)
			{
				double d = abs(vecY.dotProduct(pts[1]-pts[0]));
				if(d>dEps) dY=d;
			}
			Point3d pt =_PtG.length()>0?_PtG[0]:_Pt0;
			pt.setZ(ptOrg.Z());
			
			bdTest=Body(pt,vecX,vecY,vecZ,U(50),dY,U(100),0,1,0);
			//bdTest.vis(2);
		}		
		
		int bRoomFound;
		for (int g=0;g<grAll.length();g++) 
		{ 
			String name = grAll[g].namePart(2);
			if (name.find("Räume",0,false)>-1 || name.find("Room",0,false)>-1)
			{ 
			// get first of AEC SAPCES which has an intersection with the test body
				Entity ents[] = grAll[g].collectEntities(true, Entity(), _kModelSpace);
				for(int i=ents.length()-1;i>=0;i--)
				{
					if (ents[i].typeDxfName() == "AEC_SPACE" && bdTest.hasIntersection(ents[i].realBody()))
					{
						_Map.setEntity("Room", ents[i]);
						_Entity.append(ents[i]);
						if(bDebug)reportNotice("\nRoom "+ ents[i].handle() + " found in group " + grAll[g].name());
						_ThisInst.transformBy(Vector3d(0, 0, 0));
						//ents[i].realBody().vis(33);
						bRoomFound = true;
						_Map.removeAt("hasNoRoom", true);
						break;
					}
				}
			}			 
		}//next g
		
	// flag if no room could be found	
		if (!bRoomFound)
		{ 
			_Map.setInt("hasNoRoom", true);
			_Map.removeAt("Room", true);
			_ThisInst.transformBy(Vector3d(0, 0, 0));
		}
	}
//End Search room assignment//endregion 	
	


// on certain events reposition the the potential additional grip for the plan annotation
	if (nPlanAnnotationIndex>-1 && bUpdatePlanAnnoGrip)
	{
		Map mapGrips =_Map.getMap("Grip[]");
		if (bDebugPlanAnnoGrip)reportMessage("\nPlanAnnotationGrip ("+_ThisInst.handle()+ ") 2222: mapGrips = " + mapGrips.length());
	// get relative location of annotation grip to previous _PtG0
		Point3d ptGripAnnoPlan = _PtW+mapGrips.getMap(nPlanAnnotationIndex).getVector3d("GripAbsolute");
		Point3d ptPreviousPtG0 = _PtW+mapGrips.getMap(0).getVector3d("GripAbsolute");
		Vector3d vecPrev = ptGripAnnoPlan -ptPreviousPtG0 ;
	
	// the z offsets previous and current
		{
			int nSidePrevious = 1;
			if(vecZ.dotProduct(ptPreviousPtG0-ptMid)<0) nSidePrevious *=-1;		
			int nSideCurrent = 1;
			if(vecZ.dotProduct(_PtG[0]-ptMid)<0) nSideCurrent *=-1;
			
			double dZOffset = vecZ.dotProduct(vecPrev);
			if (nSidePrevious!=nSideCurrent )
				vecPrev-=2*dZOffset*vecZ;
	
			//EntPLine epl;
			//epl.dbCreate(PLine(ptGripAnnoPlan,ptPreviousPtG0));
			//epl.setColor(2);

			//EntPLine epl2;
			//epl2.dbCreate(PLine(_PtG[1],_PtG[0]));
			//epl2.setColor(3);
		}	
	
		
	// transform the annotation grip
		Point3d pt = _PtG[nPlanAnnotationIndex];
		if (!vecPrev.bIsZeroLength())		
			pt=_PtG[0]+vecPrev;
		_PtG[nPlanAnnotationIndex]=pt;	
			
	// keep the dDGrip values for consistency - they are not required for this behaviour
		double dX =vxE.dotProduct(pt-_Pt0);
		double dY =vyE.dotProduct(pt-_Pt0);
		double dZ =vzE.dotProduct(pt-_Pt0);
		Map mapGrip;
		mapGrip.setDouble("dXGrip", dX);
		mapGrip.setDouble("dYGrip", dY);
		mapGrip.setDouble("dZGrip", dZ);
		mapGrip.setVector3d("GripAbsolute", pt-_PtW);
		mapGrips.setMap(nPlanAnnotationIndex, mapGrip);
		_Map.setPoint3d("PtG"+nPlanAnnotationIndex,pt);
	}	

	
// debug display vectors
	vxE.normalize();
	vyE.normalize();
	vzE.normalize();
	
	//vxP.vis(ptRef,2);
	//vyP.vis(ptRef,2);	
//	vxE.vis(ptRef,nZone);
//	vyE.vis(ptRef,nZone);	
//	vzE.vis(ptRef,nZone);			
	_Map.setVector3d("vxE",vxE);
	_Map.setVector3d("vyE",vyE);
	_Map.setVector3d("vzE",vzE);


// CoordSys
	CoordSys csZone();
	if (nAlign==0)
		csZone.setToAlignCoordSys(ptRef,vxP,vyP,vzP,_Pt0,vxE,vyE, vzE);
	else if (nAlign==1)
		csZone.setToAlignCoordSys(ptRef,vxP,vyP,vzP,_Pt0,-vyE,vxE, vzE);
	Vector3d vxC=vxP, vyC=vyP;
	
	int nFlipFlag=1;// installation point and combination could flip their sides. the horizontal alignment of the combination shall remain to its base definition.
	if (nAlign==0 && (nSide*nParentSide)==1)nFlipFlag*=-1;
	vxC*=nFlipFlag;
	vxC.transformBy(csZone);
	vyC.transformBy(csZone);
	//vxC.vis(_Pt0,1);		
	//vyC.vis(_Pt0,3);		

// the reading vectors
	Vector3d vxRead=vxE, vyRead=vzE;	
	int nFlipTxt=1;
	if (vxRead.isParallelTo(_YW) && _YW.dotProduct(vxRead)<0)
	{
		vxRead*=-1;	
		nFlipTxt*=-1;
	}
	else if (vxRead.isParallelTo(_XW) && _XW.dotProduct(vxRead)<0)
	{
		vxRead*=-1;
		nFlipTxt*=-1;
	}
	else if (vxRead.dotProduct(_XW)<0)
		vxRead*=-1;
	vyRead = vxRead.crossProduct(-_ZW);
	//if (_YW.dotProduct(vyRead)<0)vyRead*=-1;
	vxRead.normalize();
	vyRead.normalize();
	//vxRead.vis(ptRef+_XW*U(100),1);
	//vyRead.vis(ptRef+_XW*U(100),3);	


		
	
			
	
// if the location is not offseted show the guideline centered and the installations with the corresponding offset 
	int bIsAligned;
	if (abs(vecX.dotProduct(ptRef-_Pt0))<dEps)	{bIsAligned=true;}
	double dTxtOffset = dCellXY;	

// the plan reference
	Point3d ptRefGrid,ptRefTxt;
	Point3d ptGrid[0]; // grid points which represent the ref index location
	Point3d ptGuide; // the location where a potential guideline ends


// flag if symbols are to be mirrored and set mirror plane
	int bMirrorSymbols;
	CoordSys csMirr;	
	if (vzE.dotProduct(_PtG[0]-_Pt0)<0)
	{
		bMirrorSymbols=true;
		PLine pl = el.plOutlineWall();
		Point3d pts[] = pl.vertexPoints(true);
		Point3d ptNext = pl.closestPointTo(_PtG[0]);

		Point3d ptGrip = _PtG[0];	ptGrip.setZ(ptNext.Z());
		Vector3d vzMirr = ptGrip-ptNext;
	
	// mirror to opposite side if the next point snaps to one of the vertices
		for (int i=0;i<pts.length();i++)	
			if ((pts[i]-ptNext).length()<=dEps)
			{
				vzMirr=vzE;
				break;	
			}
		
		vzMirr.normalize();
		if (!vzMirr.isParallelTo(vzE))
		{
			vzMirr=vecY.crossProduct(vzMirr+vzE);
			vzMirr.normalize();
		}
		//vzMirr .vis(ptNext,6);
		csMirr.setToMirroring(Plane(_PtG[0],vzMirr));
	}
	


// since the remote set of a grip point is not implemented do it via map
	if (_Map.hasInt("remoteGripIndex") && _Map.hasPoint3d("remoteGrip"))//_Map.hasPoint3d("remoteGrip") && (_bOnRecalc || _bOnDbCreated) && _PtG.length()>0)
	{
		Point3d pt = _Map.getPoint3d("remoteGrip");
		int n = _Map.getInt("remoteGripIndex");
		if (bDebugPlanAnnoGrip)reportMessage("\nPlanAnnotationGrip ("+_ThisInst.handle()+ ") 2376: entering remote grip " + n + " assignment " + _ThisInst.handle());		

		if (_PtG.length()>n)
			_PtG[n].transformBy(vzT*vzT.dotProduct(pt-_PtG[n]));
			
	// if the instance has an additional grip for the plan annotation set the location of this grip as well
		if (nPlanAnnotationIndex>-1)
		{
			Map mapGrips =_Map.getMap("Grip[]");
		// get relative location of annotation grip to previous _PtG0
			Point3d ptGripAnnoPlan = _PtW+mapGrips.getMap(nPlanAnnotationIndex).getVector3d("GripAbsolute");
			Point3d ptPreviousPtG0 = _PtW+mapGrips.getMap(0).getVector3d("GripAbsolute");
			Vector3d vecPrev = ptGripAnnoPlan -ptPreviousPtG0 ;
		
		//// get offset in vecZ of element
			double dZOffset ;
			//double dZOffset = vecZ.dotProduct(vecPrev);
			//if (nSide<0)
				//vecPrev-=vecZ*dZOffset;
			
			if (bDebugPlanAnnoGrip)reportMessage("\nPlanAnnotationGrip ("+_ThisInst.handle()+ ") 2395: dZOffset = " + dZOffset + " during bOnCreated:" + _bOnDbCreated);	
			
		// transform the annotation grip
			Point3d pt = _PtG[nPlanAnnotationIndex];
			if (!vecPrev.bIsZeroLength())		
				pt=_PtG[0]+vecPrev;
			_PtG[nPlanAnnotationIndex]=pt;	
				
		// keep the dDGrip values for consistency - they are not required for this behaviour
			double dX =vxE.dotProduct(pt-_Pt0);
			double dY =vyE.dotProduct(pt-_Pt0);
			double dZ =vzE.dotProduct(pt-_Pt0);
			Map mapGrip;
			mapGrip.setDouble("dXGrip", dX);
			mapGrip.setDouble("dYGrip", dY);
			mapGrip.setDouble("dZGrip", dZ);
			mapGrip.setVector3d("GripAbsolute", pt-_PtW);
			mapGrips.setMap(nPlanAnnotationIndex, mapGrip);
			_Map.setPoint3d("PtG"+nPlanAnnotationIndex,pt);
			_Map.setMap("Grip[]",mapGrips);		

		}	
		_Map.removeAt("remoteGripIndex",false);
		_Map.removeAt("remoteGrip",false);
	}



// collect block extents
	//bDrawBlock=true;
	//if (bDrawBlock)

	dpPlanMeter.color(_ThisInst.color());
	dpPlanMillimeter.color(_ThisInst.color());
	
	Point3d ptStart=ptRef, ptEnd, pt=ptStart,ptBlocks[0];
	double dBounds[2],dFactors[0];
	double dMove;

// the scale factor
	double dFactor=1;

// place block segments next to each other and get bounding pline
	Point3d ptRefBlock=_PtW;
	Point3d ptsBlockHull[0];
	Vector3d vecBlockDirX = _XW;
	if (nAlign==1)vecBlockDirX = -_YW;
	else if (bFlip)
		vecBlockDirX *=-1;	
	Vector3d vecBlockDirY = vecBlockDirX.crossProduct(_ZW);
	double dCellWidths[0], dTotalWidth, dMaxCellHeight;
	double dPosIndexOffset;
	// loop block segments and collect cell extents. 
	for (int i=0;i<segBlocks.length();i++)
	{
		//ptRefBlock.vis(i);
		LineSeg seg = segBlocks[i];
		double dBasePointOffsetX = vecBlockDirX.dotProduct(segBlocks[i].ptMid()-_PtW);
		double dBasePointOffsetY = vecBlockDirY.dotProduct(segBlocks[i].ptMid()-_PtW);				
	
		seg.transformBy(ptRefBlock-seg.ptMid());

		double dCellWidth= abs(vecBlockDirX.dotProduct(seg.ptStart()-seg.ptEnd()));
		double dCellWidthScaled = dCellWidth*dFactor;
		dTotalWidth+=dCellWidthScaled ;
		double dCellHeightScaled= abs(vecBlockDirY.dotProduct(seg.ptStart()-seg.ptEnd()))*dFactor;
		if (dCellHeightScaled>dMaxCellHeight)dMaxCellHeight=dCellHeightScaled;
		
		
	// increment the horizontal block displacement offset if the posindex requires it
		if(i*2+1<=nPos)dPosIndexOffset+=.5*dCellWidthScaled;
		if(i*2+2<=nPos)dPosIndexOffset+=.5*dCellWidthScaled;
		
	// store the width of each cell
		dCellWidths.append(dCellWidthScaled);	
		seg.transformBy(vecBlockDirX*(.5*dCellWidth-dBasePointOffsetX));
		//seg.vis(i);

		//Block bl(sBlockNames[i]);
		//Display dp(1);
		//dp.draw(bl, seg.ptMid() , _XW,_YW,_ZW);

		PLine pl(_ZW);
		pl.createRectangle(seg,_XW,_YW);
		pl.transformBy(vecBlockDirX*dBasePointOffsetX+vecBlockDirY*dBasePointOffsetY );
		//
		//pl.vis(i);
		ptsBlockHull.append(pl.vertexPoints(true));
		segBlocks[i]=seg;
		ptRefBlock.transformBy(vecBlockDirX*dCellWidth);
				
	}// next i segment
// use boundings of each block to create a hull pline
	PLine plBlockHull(_ZW);
	plBlockHull.createConvexHull(Plane(_PtW,_ZW),ptsBlockHull);
	//plBlockHull.vis(3);

// evaluate the offset of the boundings if block def is offseted
	Vector3d vecSegOffset;
	{
		Point3d pts[0];
		for (int i=0;i<segBlocks.length();i++)
			pts.append(segBlocks[i].ptMid());
		Point3d ptMid;
		ptMid.setToAverage(pts);//ptMid.vis(6);
		
		Point3d ptMidHull;
		ptMidHull.setToAverage(ptsBlockHull);//ptMidHull.vis(62);
		vecSegOffset=ptMidHull-ptMid;		
	}
	
// offset points for horizontal distribution
	if (nAlign==0)
	{
		Vector3d vec = -vxE;
		if(bFlip) vec*=-1;
		if (bShapeByInstallation)
			ptStart.transformBy(vec*dPosIndexOffset);
		else if (nPos==2)
			ptStart.transformBy(vec*.5*dTotalWidth);
		else if (nPos==3)
			ptStart.transformBy(vec*dTotalWidth);
		
	// offset the start point of plan distribution by half of cell height
		Vector3d vecZPlan = vzE;
	// consider potential opposite side of plan display
		if (_PtG.length()>0)
		{
			int nGripSide =1;
			if (vecZ.dotProduct(_PtG[0]-ptMid)<0)
				nGripSide*=-1;		
			if (nSide!=nGripSide)
				vecZPlan *=-1;			
		}			
		ptStart.transformBy(vecZPlan*.5*dMaxCellHeight);	// 10.2		// 10.8 vzT -> vzE
	}

//	
//	vxP.vis(ptStart,1);
//	vyP.vis(ptStart,3);		
	
/// the world to plan transformation
	CoordSys csW2P;
	Vector3d vxBlock=vzE.crossProduct(-vecY)*dFactor, vyBlock= -vzE*dFactor, vzBlock=vecY*dFactor;

// mirror symbols	
	if (bMirrorSymbols)
	{
		vxBlock.transformBy(csMirr);	
		vyBlock.transformBy(csMirr);
		vzBlock.transformBy(csMirr);		
	}
	
// custom symbol rotation
	if (dRotation !=0)
	{
		CoordSys csRot;
		csRot.setToRotation(dRotation, vecY, ptStart);
		vxBlock.transformBy(csRot);	
		vyBlock.transformBy(csRot);
		vzBlock.transformBy(csRot);			
	}	

// get block scale factor of the instance, default = 1
	double dBlockScale =1;
	if (_Map.hasDouble("PlanScaleFactor"))
		dBlockScale =_Map.getDouble("PlanScaleFactor");

// add scale factor trigger
		String sPlanScaleFactorTrigger = T("|Scale blocks|");
		if (dBlockScale!=1) sPlanScaleFactorTrigger += " (" + dBlockScale + ")";
		addRecalcTrigger(_kContext, "----------    ");// a blind trigger	
		addRecalcTrigger(_kContext, sPlanScaleFactorTrigger );// a annotation trigger	
		if (_bOnRecalc && _kExecuteKey==sPlanScaleFactorTrigger )
		{
			double dValue = getDouble(TN("|Enter scale factor|") + " [" + dBlockScale +"]");
			if (dValue<dEps || dValue>2)
				reportMessage(TN("|Invalid input, value must be >0 and <2|"));
			else
			{
				_Map.setDouble("PlanScaleFactor", dValue);	
				setExecutionLoops(2);
				return;
			}	
		}

// transform to plan			
	csW2P.setToAlignCoordSys(_PtW,_XW,_YW,_ZW,ptStart, vxBlock*dBlockScale ,vyBlock*dBlockScale , vzBlock*dBlockScale );

	PLine plFrame = plBlockHull;
	plFrame.transformBy(csW2P);
	//plFrame.vis(2);
	_Map.setPLine("plFrame", plFrame);
	LineSeg segFrame = PlaneProfile(plFrame).extentInDir(vxBlock);

	ptRefTxt=ptStart;


// loop and draw blocks at transformed model location
	Point3d ptsBlocks[0];
	vxBlock=vyBlock.crossProduct(vzBlock); // 10.4
	for (int i=0;i<segBlocks.length();i++)
	{
		LineSeg seg = segBlocks[i];
		seg.transformBy(csW2P);
		Point3d ptBlock = seg.ptMid();
		ptsBlocks.append(ptBlock);
		if (sBlockNames.length()>i && sBlockNames[i]!="")
		{
			Block bl(sBlockNames[i]);
		// add additional display for custom 1	
			if (nProjectSpecial==1)
				dpPlanMillimeter.draw(bl, ptBlock , vxBlock*dBlockScale  ,vyBlock*dBlockScale  , vzBlock*dBlockScale  );
			
			dpPlanMeter.draw(bl, ptBlock , vxBlock*dBlockScale  ,vyBlock*dBlockScale  , vzBlock*dBlockScale  );	
			if (bHasPlanElectricalDisp)
				dpPlanElectrical.draw(bl, ptBlock  , vxBlock*dBlockScale  ,vyBlock*dBlockScale  , vzBlock*dBlockScale  );	
		}
		//seg.vis(2);	
		double dX = abs(vxP.dotProduct(seg.ptStart()-seg.ptEnd()));

	// for vertical alignemnts transform the ptRefTxt to the corresponding location of the posindex
		Vector3d vec;
		if (nAlign==1)
		{
			int nMax = (i*2)+1;
			if (bShapeByInstallation)
			{
				if (i==0) 							vec=vxP*.5*dX;	
				else if (i>0 && nPos>=nMax-1)	vec=vxP*.5*dX;	
				if (i>0 && nPos>=nMax) 			vec =vxP*.5*dX;
			}
			else
			{
				if (nPos==2)			vec = vxP*vxP.dotProduct(segFrame.ptMid()-ptRefTxt);
				else if (nPos==3)		vec= vxP*2*vxP.dotProduct(segFrame.ptMid()-ptRefTxt);
			}
			ptRefTxt.transformBy(vec);
		}

	// draw additional text in plan view #0312
		String sThisText = sTexts[i];
		if (!bHideText && sThisText.length()>0)
		{
			Point3d ptTxt = seg.ptMid();
			Vector3d vecXTxt = vxBlock;
		
		// declare a transformation matrix for the additional text display
			CoordSys csRotTxt;
			csRotTxt.setToRotation(dAngleTxt , vzBlock,ptTxt );
			vecXTxt.transformBy(csRotTxt);
			Vector3d vecYTxt = vecXTxt.crossProduct(-vzBlock);
						
			PLine pl;
			//pl.createRectangle(seg, vxBlock, vyBlock);
			pl.createCircle(ptTxt , vzBlock, .6*dX);
			
		// relocate ptTxt to intersection with bounding rectangle
			Point3d pts[] = Line(ptTxt,-vecXTxt).orderPoints(pl.intersectPoints(Plane(ptTxt,vecYTxt)));
			if (pts.length()>0)	ptTxt=pts[0];
			//vecXTxt.vis(ptTxt,2);
		// for any non orthogonal alignment transform text such that it would not intersect the bounding box
			if (abs(dAngleTxt )!=0 && abs(dAngleTxt )!=90 && abs(dAngleTxt )!=180 && abs(dAngleTxt )!=270)
			{
				double c = ((dTxtHTxt*.5) *sin(90-dAngleTxt ))/sin(dAngleTxt );
				ptTxt.transformBy(vecXTxt*c);
				//ptTxt.vis(6);
			}	
			ptTxt.transformBy(vecSegOffset);

		// alignment flag 
			int dFlagX = 1;
			if (vecXTxt.dotProduct(_XW)<0)
			{
				dFlagX*=-1;
				//vecXTxt*=-1; 
			}
			
		// draw additional text
			if (vecYTxt.dotProduct(_YW)<0) // make sure it is always readable
			{
				vecXTxt*=-1;
				vecYTxt*=-1;
			}	
			dpPlanTxt.draw(sThisText, ptTxt, vecXTxt, vecYTxt, dFlagX , 0);
			//ptTxt.vis(2);				
		}
	
	}


// horizontal
	if (nAlign==0)
	{
		ptRefTxt.transformBy(vxP*vxP.dotProduct(segFrame.ptMid()-ptRefTxt));
		dTxtOffset =abs(vxP.dotProduct(segFrame.ptStart()-segFrame.ptEnd()));//dTxtOffset =dBounds[0];	
	}		
				
// vertical		
	else	
		dTxtOffset =abs(vyP.dotProduct(segFrame.ptStart()-segFrame.ptEnd()));//;dBounds[1];



	if (bDebug) dpPlanMeter.draw(plFrame);

	dpPlanMeter.color(nColor);
	dpPlanMillimeter.color(nColor);
	dpPlanElectrical.color(nColor);
	//ptStart.vis(6);ptEnd.vis(6);
	
	
	// publish block locations as snap points
	_Map.setPoint3dArray("snapPoints", ptsBlocks);
	
	//}// END IF collect block extents


// mirror ref points
	if (bMirrorSymbols)
	{
		ptRefTxt.transformBy(csMirr);
	}


// define and draw the plan view guide line	
	if (vzT.dotProduct(_PtG[0]-_Pt0)>dTxtH && nProjectSpecial==1)
	{	
		PLine plGuide(vecY);
		if (!bIsAligned)plGuide.addVertex(_Pt0);

	// get intersection points of bounding pline
		Point3d ptsInt[] = Line(_Pt0,vzE).orderPoints(plFrame.intersectPoints(Plane(_PtG[0],vecX)));
		Point3d pt2 = plFrame.closestPointTo(_PtG[0]);
		if (ptsInt.length()>0)
			pt2=ptsInt[0]-vzE*.5*dTxtH;
		plGuide.addVertex(pt2);	
		if (ptsInt.length()>0)
			plGuide.addVertex(ptsInt[0]);	
		//plGuide.vis(2);
		if (nProjectSpecial==1)	// 10.7   draw guideline [mm] and [m] sets
		{
			dpPlanMillimeter.draw(plGuide);
			dpPlanMeter.draw(plGuide);	
		}
		if (bHasPlanElectricalDisp)dpPlanElectrical.draw(plGuide);	
	}


// elevation texts	

	dpPlanMeter.color(nProjectSpecial==1?10:nColorTxt);
	dpPlanMillimeter.color(nProjectSpecial==1?10:nColorTxt);
	dpPlanElectrical.color(nColorTxt);



	String sTxtM, sTxtMM, sTxtMMElement, sTmp;
	sTxtMM.formatUnit(dElevation*dUnitFactor ,sDimStyle);
	sTxtMMElement.formatUnit((dElevation+dFloorThickness)*dUnitFactor ,sDimStyle);
	
	//if (nProjectSpecial==1)sTxtMM = "H:"+sTxtMM;

	sTxtM.formatUnit(dElevation*dUnitFactor/1000 ,2,3);
	sTmp =sTxtM.token(1,".");
	if (sTmp.length()<1)sTxtM= sTxtM+".00";
	else if (sTmp.length()==1)sTxtM= sTxtM+"0";			
	//if (nProjectSpecial==1)sTxtM = "H:"+sTxtM;

// format element view text
	String sTxtElementView1,sTxtElementView2;
	{
		double dStandardDrillDiam = dCombinationStandardDiameter;
		String s1,s2;		
		if (bShapeByInstallation && abs(dDiameter-dStandardDrillDiam)>dEps && dCombinationStandardDiameter>0 && dDiameter!=0)
		{			
			s2.formatUnit(dDiameter*dUnitFactor ,sDimStyle);
			sTxtElementView2  ="Ø"+s2; 
		}
		else if (!bShapeByInstallation)
		{
			s1.formatUnit(dWidth*dUnitFactor ,sDimStyle);
			s2.formatUnit(dDiameter*dUnitFactor ,sDimStyle);
			sTxtElementView2  = s1+"x"+s2;
		}
		
		sTxtElementView1 =sTxtMMElement;	
	}
	
	

// draw elevation in element view if not masked
	Vector3d vecAnnotationElementOffset=_Map.getVector3d("vecAnnotationElement");
	Point3d ptAnnoElement;
	if (!bHasAnnotationElement && !bMaskedAnnotationElement  && !bCreateAnnotationElement)
	{
		Vector3d vXOffset= vecX*dOffsetInstallations;
		
		if (nAlign==0)// horizontal
		{
			vXOffset = vxC*nPos*0.5*dOffsetInstallations;	
			if (sTxtElementView2!="")sTxtElementView1 += "/" + sTxtElementView2  ;
		}
		else if (nAlign==1 && sTxtElementView2 !="")
		{
			if (!bShapeByInstallation)// vertical + boxed)
				vXOffset = vecX*dWidth;
			else
				vXOffset = vecX*dOffsetInstallations;	
		// draw line 2
			ptAnnoElement = _Pt0+ vXOffset+vecY*dDiameter;
			if (!(nProjectSpecial==1 && _bOnDbCreated))	
			{
				dpElement.draw(sTxtElementView2 ,ptAnnoElement  ,vecX,vecY,1,-1.5);	
			}			
		}
			
		// draw line 1
		ptAnnoElement = _Pt0+ vXOffset+vecY*dDiameter;
		if (!(nProjectSpecial==1 && _bOnDbCreated)) 
		{
			double dXFlag=-1;
			if (!vzE.isCodirectionalTo(vecZ) && bCombinationDrawElevationElementView)
			{		
				dpElementZone0.draw(sTxtElementView1,ptAnnoElement ,vecX,vecY,dXFlag,1);
				dXFlag*=-1;
			}	
			
			dpElement.draw(sTxtElementView1,ptAnnoElement ,vecY.crossProduct(vzE),vecY,dXFlag,1);

		}
		vecAnnotationElementOffset =ptAnnoElement-_Pt0;
	}

// create annotation entities on creation if selected in settings
	Point3d ptPlanAnnotationRef = ptRefTxt-vxRead*dPlanAnnotationOffset;//HSB-11557
	//ptPlanAnnotationRef .vis(3);

	
	//ptPlanAnnotationRef .transformBy(-vecX*.75*dpPlanMeter.textLengthForStyle(sTxtM, sDimStyle));
	_Map.setPoint3d("ptPlanAnnotationRef",ptPlanAnnotationRef);
	//if (_bOnDbCreated)
	{
		//EntPLine epl;
		//epl.dbCreate(PLine(ptOrg,ptPlanAnnotationRef ));
		//epl.setColor(2);		
		
		
	// plan annotation
		Point3d pt = ptPlanAnnotationRef ;
		
		if(nCreateAnnotation==1 && !bHasAnnotation && !bMaskedAnnotation)
		{
			mapTsl.setInt("mode",1);
			ptAr.setLength(0);
			ptAr.append(pt);
			entAr.append(_ThisInst);
					
			tslNew.dbCreate(sScriptname, vUcsX,vUcsY,gbAr, entAr, ptAr, 
				nArProps, dArProps, sArProps,_kModelSpace, mapTsl); // create new instance	
			if (tslNew.bIsValid())
			{
				_Map.setEntity("Annotation", tslNew);
				_Map.setVector3d("vecAnnotation", pt-_PtG[0]);	
				_Map.setInt("maskAnnotation",true);// mask the annotation if the annotation entity has been deleted by the user
				bHasAnnotation = true;
				//tslNew.setPtOrg(ptPlanAnnotationRef);
				//tslNew.recalc();
			}		
			if (bDebug) reportMessage("\nplan annotation added");
			setExecutionLoops(2);			
		}	

	// element annotation
		if(bCreateAnnotationElement && !bHasAnnotationElement && !bMaskedAnnotationElement)
		{	
			pt = _Pt0+vecAnnotationElementOffset;
			pt.transformBy(-vecX*.75*dpPlanMeter.textLengthForStyle(sTxtM, sDimStyle));
			mapTsl.setInt("mode",2);
			ptAr.setLength(0);
			ptAr.append(pt);		
			tslNew.dbCreate(sScriptname, vUcsX,vUcsY,gbAr, entAr, ptAr, 
				nArProps, dArProps, sArProps,_kModelSpace, mapTsl); // create new instance	
			if (tslNew.bIsValid())
			{
				_Map.setEntity("AnnotationElement", tslNew);
				_Map.setVector3d("vecAnnotationElement", pt-_Pt0);
				_Map.setInt("maskAnnotationElement",true);// mask the annotation if the annotation entity has been deleted by the user
				bHasAnnotationElement = true;			
				tslNew.recalc();
			}
			if (bDebug) reportMessage("\nelement annotation added");
			setExecutionLoops(2);
		}
		
	}	
	
	
// reset annotation location for vertical alignment if position index changes
	if (_kNameLastChangedProp == sPosName && bHasAnnotation && nAlign==1)
	{
		Entity ent =_Map.getEntity("Annotation");
		TslInst tsl=(TslInst)ent;
		if (tsl.bIsValid())
		{		
			Point3d pt = ptRefTxt-vxRead*dPlanAnnotationOffset;//##
			pt.transformBy(-vecX*.75*dpPlanMeter.textLengthForStyle(sTxtM, sDimStyle));	
			tsl.setPtOrg(pt);	
		}				
	}	
	if (_kNameLastChangedProp == sPosName)
	{ 
		setExecutionLoops(2);
		return;
	}

// reset annotation element location for horizontal alignment if elevation changes
	if (_kNameLastChangedProp == sElevationName && bHasAnnotationElement && nAlign==0)
	{
		Entity ent =_Map.getEntity("AnnotationElement");
		TslInst tsl=(TslInst)ent;
		if (tsl.bIsValid())
		{	
			Point3d pt = _Pt0+vecAnnotationElementOffset;
			pt.transformBy(-vecX*.75*dpPlanMeter.textLengthForStyle(sTxtM, sDimStyle));		
			tsl.setPtOrg(pt);	
		}				
	}

// publish text
	_Map.setString("ElevationTextMM", sTxtMM);
	_Map.setString("ElevationTextM", sTxtM);
	_Map.setString("ElevationTextElement1", sTxtElementView1);
	_Map.setString("ElevationTextElement2", sTxtElementView2);

	
// define and draw the plan view text guide line if no annotation entity was found
	if (!bHasAnnotation && !bMaskedAnnotation && nCreateAnnotation!=1)
	{
		double dd = dTxtH - dPlanAnnotationOffset;//HSB-11557
		ptRefTxt.transformBy(-vxRead*(.5*dTxtOffset));
		
		
		ptRefTxt.vis(40);
		Point3d ptTxt = ptRefTxt-vxRead*dPlanAnnotationOffset;//HSB-11557
		ptTxt .vis(4);
		
	// if hsbInstallationPointSettings.CreateAnnotation = 2 create an additional grip, store its index and use this further more for the location
		int nGripIndex = _Map.getInt(sPlanAnnotationGripIndex);
		if (nCreateAnnotation==2)
		{	
			if (bDebugPlanAnnoGrip)reportMessage("\nPlanAnnotationGrip ("+_ThisInst.handle()+ ") 2966: nCreateAnnotation= " + nCreateAnnotation);
		// set grip
			if(_Map.getInt(sPlanAnnotationGripIndex)<=0)
			{
				_PtG.append(ptTxt);
				_Map.setInt(sPlanAnnotationGripIndex , _PtG.length()-1);
				if (bDebugPlanAnnoGrip)reportMessage("\nPlanAnnotationGrip ("+_ThisInst.handle()+ ") 2972: at= " + _PtG.length());
				setExecutionLoops(2);
				return;
			}
			else
			{
			// get grip index
				int n=_Map.getInt(sPlanAnnotationGripIndex);
				if (n<_PtG.length())
				{
					Point3d pt = ptTxt;
					ptTxt = _PtG[n];
//					ptRefTxt.transformBy(ptTxt-pt);	ptRefTxt.vis(252);
				}
			// remove if failed		
				else
					_Map.removeAt(sPlanAnnotationGripIndex ,true);		
			}
		}
	// remove grip if settings have changed
		else if(nGripIndex>0 && _PtG.length()>nGripIndex)
		{
			_PtG.removeAt(nGripIndex);
			_Map.removeAt(sPlanAnnotationGripIndex ,true);
		}
		vxRead.vis(ptTxt,1);

		if (nProjectSpecial==1)
		{
			PLine pl(ptRefTxt,ptTxt);	//			pl.vis(4);
			dpPlanMillimeter.draw(pl);
			dpPlanMillimeter.draw(sTxtMM,ptTxt-vxRead*dPlanAnnotationOffset *.5,vxRead,vyRead,-1.3,0);
			
			dpPlanMeter.draw(sTxtM,ptTxt-vxRead*dPlanAnnotationOffset *.5,vxRead,vyRead,-1.3,0);
			if (bHasPlanElectricalDisp)
				dpPlanElectrical.draw(sTxtMM,ptTxt-vxRead*dPlanAnnotationOffset ,vxRead,vyRead,-1.3,0);
		}
		else
		{
			int nFlipTxt =1;
			//if (vxE.dotProduct(ptRefTxt-_PtG[0])<dEps)nFlipTxt*=-1;
			if (vxRead.dotProduct(ptTxt-ptRef)<dEps)
			{
				nFlipTxt*=-1;
			}
			dpPlanMillimeter.color(nColorTxt);
//			dpPlanMillimeter.draw(sTxtMM,ptTxt-vxRead*dPlanAnnotationOffset,vxRead,vyRead,nFlipTxt*1.1,0);//nFlipTxt*	// version 14.0: -1.1
//			if (bHasPlanElectricalDisp)dpPlanElectrical.draw(sTxtMM,ptTxt-vxRead*dPlanAnnotationOffset,vxRead,vyRead,nFlipTxt*1.1,0);//nFlipTxt*  // version 14.0: -1.1
		
			dpPlanMillimeter.draw(sTxtMM,ptTxt,vxRead,vyRead,nFlipTxt,0);//nFlipTxt*	// version 14.0: -1.1
			if (bHasPlanElectricalDisp)dpPlanElectrical.draw(sTxtMM,ptTxt,vxRead,vyRead,nFlipTxt,0);//nFlipTxt*  // version 14.0: -1.1
				
		
		}
				
	// desc texts	
		dpPlanMeter.draw(sDesc1,ptTxt,vxRead,vyRead,1.2,1.6);//nFlipTxt*
		dpPlanMeter.draw(sDesc2,ptTxt,vxRead,vyRead,1.2,-1.6);	//nFlipTxt*	
		
		if (bHasPlanElectricalDisp)
		{
			dpPlanElectrical.draw(sDesc1,ptTxt,vxRead,vyRead,1.2,1.6);
			dpPlanElectrical.draw(sDesc2,ptTxt,vxRead,vyRead,1.2,-1.6);			
		}
	}

	
	
// no nail
	PLine plNN(vzP),plCirc, plRec;
	int bErrOutside; // a flag wich shows an error display if the tooling is not within the zone profile or other failures happen	

// find a potential export override 
	Map mapExportOverride;
	{
	// set override name
		String sOverrideName;
		String sSep;
		for (int i=0;i<sBlockNames.length();i++)
		{	
			String sBlockName =sBlockNames[i];
			if (sBlockName.length()<1)continue;
			sBlockName.makeUpper();
			if (sBlockName.find(".DWG",0)>0)
				sBlockName =sBlockNames[i].left(sBlockNames[i].length()-4);
			sOverrideName += 	sSep+sBlockName;	
			sSep = ",";	
		}
	// find override
		Map mapIn;
		mapIn.setString("overrideName", sOverrideName );
		mapExportOverride = callDotNetFunction2(strAssemblyPath, strTypeOverride, strFunctionFindOverride, mapIn);	
	}
	int bHasExportOverride = mapExportOverride.getMap("Override").length()>0;


// get property map of potentially added e-data (if hsb-e-data and its corresponding property sets have been applied
	Map mapEData =_ThisInst.getAttachedPropSetMap("hsb-E-Data");

// get attached hardware
	HardWrComp hwcsInst[] = _ThisInst.hardWrComps();
	// remove hardware from any removed block item
	for (int i=0;i<sBlockNames.length();i++)
	{
		if (sBlockNames[i].length()>0) continue;

		for (int h=hwcsInst.length()-1;h>=0;h--)	
		{
			HardWrComp hwc = hwcsInst[h];
			int n = 	hwc.dOffsetX()-1;	
			if (n==i)
				hwcsInst.removeAt(h);
		}
	}
// collect potential specials and export data
	// 0 = no special
	// 1 = forces diameter 35mm + 68mm
	// 2 = forces a rectangular milling 120x120 in given zone, drilling will be applied in zone below
	// 3 = forces rectangular milling with a small strip to ensure that waste is not blocking the vacuum 
	// 4 = forces rectangular milling  150x150 in the outmost outer zone, drilling will be applied in zone below
	int nArSpecial[nQtyChilds];
	String sCompareKey;
	int bDebugHardware = false;
	
	if (!bHasExportOverride)
	{
		for (int i=0;i<nArSpecial.length();i++)
		{
		// collect all hardware componnets with this index and remove from instance array
			HardWrComp hwcs[0];
			for (int h=hwcsInst.length()-1;h>=0;h--)
			{
				HardWrComp hwc = hwcsInst[h];
				int n = 	hwc.dOffsetX()-1; // index not zero based!
				if (n==i)
				{
					hwcs.append(hwc);	
					hwcsInst.removeAt(h);
				}
				else if (n==-1)
				{
					if (bDebugHardware)reportMessage("\nremoving deprecated Hardware " + hwcsInst[h].name());
					hwcsInst.removeAt(h);	
				}			
			}	
	
		// the blockname in use
			String sBlockName = sBlockNames[i];
			sBlockName.makeUpper();			
			String sCompName = sBlockNames[i].left(sBlockNames[i].length()-4);
			if (bDebugHardware)reportMessage("\nComponnet name of index i=" + i + " " +sCompName);
			
		// query special settings in blockname
			String sKey = "_hsbKey".makeUpper();
			int nFound=	sBlockName.find(sKey,0);
			if (nFound >-1)
			{
				String s = 	sBlockName.right(sBlockName.length()-nFound-sKey.length());
				if (s.length()>4)
				{
					s = s.left(s.length()-4);
					nArSpecial[i]= s.atoi();
				}
			// truncate the hsbKey...	
				sCompName = sBlockName.left(nFound);
			}	
	
		// declare category. the default category is called 'Electrical', but it could carry additional tokens to specify installation groups
			String sCategory = "Electrical";	
			
		// set hardware on certain events, collect attached block tsl hardware
			String sBlockPropertyName = T("|Block|") + " " +i;
			if (_bOnDebug ||_bOnDbCreated || _kNameLastChangedProp==sBlockPropertyName || hwcs.length()<1 || 
				(_bOnRecalc && ( _kExecuteKey==sTriggerEdit ||  _kExecuteKey==sDoubleClick)))
			{
				if (bDebugHardware)reportMessage("\n"+sBlockName+" Hardware of " + sBlockPropertyName + " searched in block tsls...");
				Block block(sBlockName);
				TslInst tslsBlock[] = block.tslInst();
				HardWrComp hwcsBlockTsl[0];
				for (int t=0;t<tslsBlock.length();t++)	
				{
					TslInst tsl = tslsBlock[t];
					HardWrComp hwComps[]=tsl.hardWrComps();
				
				// append each component
					for (int x=0;x<hwComps.length();x++)	
					{
						HardWrComp hw = hwComps[x];
						hw.setDOffsetX(i+1); // set pseudo index
						hwcsBlockTsl.append(hw);
					}
				}
				if (bDebugHardware)reportMessage(hwcsBlockTsl.length() + " found.");
				
			// add default hardware if nothing could be collected	
				if (hwcsBlockTsl.length()<1)
				{
					HardWrComp hw(sCompName , 1);	
					hw.setName(sCompName);
					hw.setCategory("Electrical");
					hw.setDescription(el.number());
					hw.setDScaleX(dWidth);
					hw.setDScaleY(dDiameter);
					hw.setDScaleZ(dDepth);	
					hw.setDOffsetX(i+1);// misuse the x offset as index. index not zero based to avoid errors with default value!
					// HSB-23057
					String sNotes=";"+_ThisInst.handle();
					hw.setNotes(sNotes);
					hwcsBlockTsl.append(hw);	
					if (bDebugHardware)reportMessage("\nDefault Hardware added " + sCompName + " on index " + i);
				}	
				
			// replace components
				if (hwcsBlockTsl.length()>0)
				{
					hwcs=hwcsBlockTsl;
					if (bDebugHardware)reportMessage("\n" + hwcsBlockTsl.length() + " components replaced on index " + i);	
				}
						
			}// END IF (_bOnDbCreated || _kNameLastChangedProp==sBlockPropertyName)
			
		// always set the room number/name if available
			for (int t=0;t<hwcs.length();t++)	
			{
				HardWrComp hw = hwcs[t];
				if (bDebugHardware)reportMessage("\nSetting room and group data for " + hw.name() + " on index " + i);	
			
			// attach  data from a potential room
				// HSB-23057
				String sNotes;
				if (bCombinationIsExposed || bHasSpecial4)
					sNotes=T("|Exterior Installation|");
				else if(entRoom.bIsValid())
					sNotes=sRoomNumber;
				else if (mapEData.hasString("Name"))
					sNotes=mapEData.getString("Name");
				else
					sNotes="";
				
				sNotes+=";"+_ThisInst.handle();
				hw.setNotes(sNotes);
				hw.setDescription(el.number());
				hw.setGroup(el.elementGroup().name());
				sCompareKey += hw.name()+hw.category()+hw.notes()+hw.group();				
				hwcsInst.append(hw);	
			}		
		}
	}// END IF not bHasExportOverride
	else
	{
	// loop oevrride map and apppend components
		hwcsInst.setLength(0); // reset existing hardware
		Map mapComponents = mapExportOverride.getMap("Override").getMap("Components");
		for (int c=0;c<mapComponents .length();c++)
		{
			Map mapComponent = mapComponents .getMap(c);
			HardWrComp hw;
			String s;
			s = mapComponent.getString("ArticleNumber");	if (s.length()>0) hw.setArticleNumber(s);
			s = mapComponent.getString("Category");	if (s.length()>0) hw.setCategory(s);
			s = mapComponent.getString("Description");	if (s.length()>0) hw.setDescription(s);
			s = mapComponent.getString("Manufacturer");	if (s.length()>0) hw.setManufacturer(s);
			s = mapComponent.getString("Material");	if (s.length()>0) hw.setMaterial(s);
			s = mapComponent.getString("Model");	if (s.length()>0) hw.setModel(s);
			s = mapComponent.getString("Name");	if (s.length()>0) hw.setName(s);
	
			if (mapComponent.hasDouble("AngleA")) hw.setDAngleA(mapComponent.getDouble("AngleA"));
			if (mapComponent.hasDouble("AngleA")) hw.setDAngleA(mapComponent.getDouble("AngleB"));			
			if (mapComponent.hasDouble("AngleG")) hw.setDAngleA(mapComponent.getDouble("AngleG"));
			if (mapComponent.hasDouble("OffsetX")) hw.setDAngleA(mapComponent.getDouble("OffsetX"));
			if (mapComponent.hasDouble("OffsetY")) hw.setDAngleA(mapComponent.getDouble("OffsetY"));			
			if (mapComponent.hasDouble("OffsetZ")) hw.setDAngleA(mapComponent.getDouble("OffsetZ"));

			int nQty = mapComponent.getInt("Quantity");
			if (nQty<1) nQty = 1;
			hw.setQuantity(nQty);
	
		// attach  data from a potential room
			// HSB-23057
			String sNotes;
			if(entRoom.bIsValid() && mapRoom.hasString("RoomNumber"))
				sNotes=mapRoom.getString("RoomNumber");
			else if (mapEData.hasString("Name"))
				sNotes=mapEData.getString("Name");
			hw.setGroup(el.elementGroup().name());
			//
			sNotes+=";"+_ThisInst.handle();
			hw.setNotes(sNotes);
			sCompareKey += hw.name()+hw.category()+hw.notes()+hw.group();
			hwcsInst.append(hw);
		}		
	}
	
	
	_ThisInst.setHardWrComps(hwcsInst);
	setCompareKey(sCompareKey);

// add define override trigger
	String sExportOverrideTrigger = T("|Define Export Override|");
	addRecalcTrigger(_kContext, "----------    ");// a blind trigger	
	addRecalcTrigger(_kContext, sExportOverrideTrigger );
	if (_bOnRecalc && _kExecuteKey==sExportOverrideTrigger )
	{
		ModelMap mm;
		ModelMapComposeSettings mmFlags;
		mmFlags.addHardwareInfo(TRUE); // default FALSE
		Entity ents[] = {_ThisInst};
		mm.setEntities(ents);
		mm.dbComposeMap(mmFlags);
		Map mapIn=mm.map();
		mapIn.setString("companyPath", _kPathHsbCompany);
		
		Map mapOut = callDotNetFunction2(strAssemblyPath, strTypeOverride, strFunctionDefineOverride, mapIn);

		reportNotice("\n**********************************   " + scriptName() + "   **********************************");
		reportNotice("\n  " + T("|The following entry has been added to the override definitions|") + ": ");
		reportNotice("\n\n  	" +mapOut.getString("Name"));
		reportNotice("\n\n  " + T("|Please edit the override definitions which can be found in this file|") + ":");
		reportNotice("\n\n  	" + _kPathHsbCompany + "\\Block\\Electrical\\CombinationExportOverrides.xml");
		reportNotice("\n**********************************************************************************************");


	}

// control shape type when certain specials are found
	// Special 4: force rectangular behaviour
	if (nArSpecial.find(4)>-1)
	{
		if (sShape!=kShapeRectangular)	sShape.set(kShapeRectangular);
		sShape.setReadOnly(true);	
		setExecutionLoops(2);	
	}

// collect center points
	Point3d ptArIns[0];
	double dXIns;
	double dX;
	double dY=dDiameter;
	Point3d ptIns;

	Vector3d vecDistr =-nSwapHorizontalDirection*vxC;
	if(nAlign==1 && !bHasVDEAlignment) vecDistr=-vecY;	
	else if(nAlign==1 && bHasVDEAlignment) vecDistr=vecY;
	
	if (!bShapeByInstallation)
	{
		ptIns=_Pt0;
		dX = dWidth;
		//double dX2 = dX/(nQtyChilds*2-1);

		plNN.createRectangle(LineSeg(ptIns-.5*(vecDistr*dX+vyC*dY),
			ptIns+.5*(vecDistr*dX+vyC*dY)),vxC,vyC);
				
		if (nPos==1)plNN.transformBy(vecDistr*dX*.5);
		else if (nPos>2)plNN.transformBy(-vecDistr*dX*.5);			
		//plNN.vis(6);		
	}
	else
	{
		dX=(nQtyChilds-1)*dOffsetInstallations+dDiameter;
		dXIns = (nPos-1)*.5*(dOffsetInstallations);
		ptIns = _Pt0-vecDistr*dXIns;
		//ptIns.vis(2);
		plNN.createRectangle(LineSeg(ptIns-.5*(vecDistr*dDiameter+vyC*dY),
			ptIns+vecDistr*(dX-.5*dDiameter)+.5*vyC*dY),vxC,vyC);
		//plNN.vis(4);
	}

// collect insertion points	
	for (int i=0;i<nQtyChilds;i++)
	{
		ptArIns.append(ptIns);
		ptIns.transformBy(vecDistr*dOffsetInstallations);
	}


	
// combination toolings  ______________________________________combination toolings____________________________________________combination toolings

// constants
	double dStripLength = U(45);
	if (nProjectSpecial==0)dStripLength = U(20);
// HSB-21220:
	double dMaxWidthForClosedMill=0;
	double dMillingDiameter=0;
	int bOnlyContourMilling=TRUE;
	if (mapSlottedShapes.hasDouble("MaxWidthForClosedMill"))
	{ 
		dMaxWidthForClosedMill=mapSlottedShapes.getDouble("MaxWidthForClosedMill");
	}
	if (mapSlottedShapes.hasDouble("MillingDiameter"))
	{ 
		dMillingDiameter=mapSlottedShapes.getDouble("MillingDiameter");
	}
	// mill only contour or all 
	if (mapSlottedShapes.hasInt("OnlyContourMilling"))
	{ 
		bOnlyContourMilling=mapSlottedShapes.getInt("OnlyContourMilling");
	}
	// HSB-21887
	if((dDiameter<dMaxWidthForClosedMill || dWidth<dMaxWidthForClosedMill) && !bOnlyContourMilling)
	{ 
		// closed mill mill
		dStripLength=0;
	}

// model display
	PLine plModelGraphics[0];
	int nModelGraphicsZone[0];// should have same length as plModelGraphics
	Point3d ptsAlert[0];// a collection of points where an aggressive alert graphic should be displayed to inform the user
	double dThisDiameter=dDiameter;
	
// do shape dependent operations	
	PLine plTool(vzT);
	
// declare array for optional tools	
	GenBeam gbDr[0];		
	double dExtraDepths[0];	// if intersecting one framing beam to increase drill depth

// check if external wall and symbol located on icon side
	int bExposedIcon;
	if (bExposed && vecZ.dotProduct(_PtG[0]-ptOrg)>0)bExposedIcon=true;

	double dSubtractDepth=dToolDepth;
	
// declare a profile which holds a potential clash with underlaying beams
	PlaneProfile ppClash(CoordSys(ptOrg,vecX, vecY, vecZ));	


// get tool type
	int nCustomToolType = sCustomSlottedShapes.find(sShape);
	int nToolType;
	if (sShape == kShapeSlottedHole || nCustomToolType>-1)nToolType=1;
	else if (sShape == kShapeRectangular)nToolType=2;

//Shape 0: Drills #0
	if (nToolType==0)
	{
	// custom modification: diameter and installation offset if switzerland 
		if(nProjectSpecial && (_bOnRecalc || _bOnDbCreated) && mapParent.getMap("Custom").getString("Country")=="CH" && dDiameter>dEps)
		{
			dDiameter.set(U(83));
			dWidth.set(U(83));
			dOffsetInstallations.set(U(60));	
		}			

	// the initial insertion point
		Point3d ptIns = _Pt0-vxC*(nQtyChilds-1)/2*dOffsetInstallations;
	
	// count clash detections
		int nNumClash;
	
	// loop insertion points	
		for (int i=0;i<ptArIns.length();i++)
		{
		// continue if special other than special 1 applies
			if (nArSpecial[i]>1)continue;	

		// this parameters
			// the depth of one drill will be adjusted if intersecting with an underlaying stud
			double dThisDepth=dToolDepth;
			dThisDiameter=dDiameter;
			Point3d ptThis = ptArIns[i].projectPoint(pnZone,0);//ptThis.vis(i+1);
			
			
			
			int nThisToolIndex = nToolIndex;
			
		// set specials
			// Special 1: if it is not an installation on the outer side of an exterior wall override diameter to 35mm and add another 68 drill (code further down at other specials)
			double dThisDiameterBuffer = dThisDiameter;
			if (nArSpecial.length()>i-1 && nArSpecial[i]==1 && !bExposedIcon)
			{
				dThisDiameter=U(35);	
				plNN=PLine();			
			}
		
		//region catch first block def mode tsl and overwrite tool data
			int nThisZone = nZone;
			TslInst tslsBlock[0];
			if (blocks.length()>i)
			{
				tslsBlock = blocks[i].tslInst();
				for(int j=0;j<tslsBlock.length();j++)
				{
					if (tslsBlock[j].map().getInt("isBlockDef"))
					{
						TslInst t = tslsBlock[j];
						String sPropNames[] = t.getListOfPropNames();
					
					// overwrite toolindex
						if (sPropNames.find(sToolIndexName)>-1)
						{
							int n =t.propInt(sToolIndexName);
							if (n>-1)nThisToolIndex=n;
						}
					// overwrite depth
						if (sPropNames.find(sDepthName)>-1)
							dThisDepth=t.propDouble(sDepthName);					
					// overwrite diameter
						if (sPropNames.find(sDiameterName)>-1)
							dThisDiameter=t.propDouble(sDiameterName);
					// overwrite zone
						if (sPropNames.find(sZoneName)>-1)
						{
							int n = t.propInt(sZoneName);
							if (n<0)continue;
							nThisZone =n;
							if (abs(nThisZone) ==99)
								for(int i=1;i<6;i++)
									if (el.zone(i*nSide).dH()>dEps)
										nThisZone =i*nSide;	
						}						
						break;
					}
				}
			}	
			
		// HSB-8318 set loaction to outside of zone	
			ptThis += vzE * el.zone(nThisZone).dH();
			
			
		// do not apply any tools if diameter is set to 0
			if (dThisDiameter<dEps)continue;
			if(dThisDepth<=0)continue;// continue when no depth is set
		//End catch first block def mode tsl and overwrite tool data//endregion  

		// create model graphics
			PLine plCirc;
			plCirc.createCircle(ptThis ,vzE,dThisDiameter/2);		
			plModelGraphics.append(plCirc);
			nModelGraphicsZone.append(nZone);

		// validate if extra drill depth is required due to underlaying stud
			double dExtraDepth;
			int bHasClash;
			if (dReliefDepth>dThisDepth|| dReliefDepth==0)///nProjectSpecial==1)
			{
				dpModel.draw(PLine(ptThis-vzE*dThisDepth,ptThis));
				gbDr=gbsAll;	
				for (int g=0;g<gbsAll.length();g++)// _GenBeam	Version 14.8
				{
					GenBeam gb=gbsAll[g];
					if (gb.bIsKindOf(Beam()) && gb.myZoneIndex()==0 && !gb.bIsDummy())
					{
						// HSB-22549
//						PlaneProfile pp = gb.realBody().shadowProfile(Plane(_Pt0,vecZ));
						Body bdReal=gb.realBodyTry();
						if(bdReal.isNull())
						{ 
							bdReal=gb.envelopeBody();
						}
//						PlaneProfile pp = gb.envelopeBody().shadowProfile(Plane(_Pt0,vecZ));
						PlaneProfile pp =bdReal.shadowProfile(Plane(_Pt0,vecZ));
						pp.intersectWith(PlaneProfile(plCirc));
						if (pp.area()>pow(dEps,2))
						{
							double d = dReliefDepth-dToolDepth;
							if (d>0 && dReliefHeight<dEps)dExtraDepth=d;  // if the relief height is not set drills will obtain an extra depth, else the relief cut performs the tool exclusivly for the beam zone
							//pp.vis(2);
							
							PLine pl;
							pl.createRectangle(pp.extentInDir(vecX), vecX,vecY);
							ppClash.joinRing(pl, _kAdd);
							bHasClash=true;
							break;
						}	
					}	
				}
			}	
		// collect only sheets for solid drill operation	
			else
			{
				for (int g=0;g<sheets.length();g++)// _GenBeam	Version 14.8
					//if (_GenBeam[g].bIsKindOf(Sheet()))
						gbDr.append(sheets[g]);
			}
			dExtraDepths.append(dExtraDepth);
			if (bHasClash)
				nNumClash++;
		
		// test a slightly increased test drill solid against steel beams (extrusion profiles)
			double dDrillDepth = dThisDepth+dExtraDepth;		
			Map mapIO;
			mapIO.setEntity(el.handle(),el);
			for (int g=0;g<gbDr.length();g++)
				mapIO.setEntity(gbDr[g].handle(), gbDr[g]);
			mapIO.setPLine("Shape",plCirc);
			mapIO.setDouble("Depth",dDrillDepth);
			mapIO.setVector3d("vecDir",-vzE);
			mapIO.setInt("function",2);
			TslInst().callMapIO(scriptName(), mapIO);
			if (mapIO.hasDouble("depth") && mapIO.hasPoint3d("ptAlert"))
			{
				dDrillDepth=mapIO.getDouble("Depth");
				ptsAlert.append(mapIO.getPoint3d("ptAlert")); 
			}
		
		// cnc tool	
			if(!bSupressCnCElementTooling)
			{
				// HSB-23569
				ElemDrill elDrill(nThisZone, ptThis, vzT, (bReliefBeamOnly?dThisDepth:dDrillDepth) , dThisDiameter, nThisToolIndex); // version 16.8
				el.addTool(elDrill);
			}
		
		// solid tool
			//Drill dr(ptThis+vzT*dEps ,ptThis -vzT*(dThisDepth+dExtraDepth),dThisDiameter/2); // version 9.1
			Drill dr(ptThis+vzE*dEps ,ptThis -vzE*dDrillDepth ,dThisDiameter/2); // version 9.2
			dr.excludeMachineForCNC(_kAnyMachine);
			//dr.cuttingBody().vis(2);
			dr.addMeToGenBeamsIntersect(gbDr);
			
		// enlarged drill in beamzone if additional diameter is defined in settings
			if (dCombinationExtraDiameterBeamInterference>0)//bHasClash &&   // clash has been detected and // 15.5
			{
				Drill drBeam(ptThis+vzE*dEps ,ptThis -vzE*dDrillDepth ,(dThisDiameter+dCombinationExtraDiameterBeamInterference)/2);
				//drBeam.cuttingBody().vis(3);
				drBeam.addMeToGenBeamsIntersect(gbsZone0);				
			}	
							
			
		// add guideline if flagged and no sheets found
			if(bDrawDrillGuideLine && sheets.length()<1)
			{
				Display dpGuide(40);
				PLine pl(ptThis ,ptThis-vzE*(dThisDepth+dExtraDepth)); 
				//pl.vis(6);
				dpGuide.draw(pl);			
			}	

			
		// loop the extra tools (offset, opposite and remote offset by installation)
			dThisDiameter = dThisDiameterBuffer;
			int bAddTool[]={bOppositeTool,bOffsetTool, _Map.hasPoint3d("additionalDrill")};
			for (int o=0;o<bAddTool.length();o++)
			{
				if (!bAddTool[o])continue;
				if (o==1 && (nTypeOffset!=1 || i>0))continue;//only supported for horitontal offset and  only for first drill
				
				int nAdd2Zone = nThisZone;
				double dMyDepth = dThisDepth;
				Point3d pt = _Pt0;//ptThis;
				if (o==0)
				{
					nAdd2Zone = nOppZone;
					dMyDepth =dOppositeDepth;
					ElemZone ezOpp = el.zone(nAdd2Zone);
					Plane pnOpp(ezOpp.ptOrg(), ezOpp.vecZ());
					pt = ptThis.projectPoint(pnOpp,ezOpp.dH());				
					//pt.transformBy(-vzT*(vzT.dotProduct(ptThis-el.zone(nOppZone).ptOrg())+dOppositeDepth));

				}
				else if (o==1)
				{
					pt.transformBy(-vecX*vecX.dotProduct(_Pt0-tslParent.ptOrg()));
					
				}
				else if (o==2 && bOffsetTool)
				{
					pt = _Map.getPoint3d("additionalDrill");
				}
				
			// offset if special 1 is found
				if (nArSpecial.find(1)>-1)
					pt.transformBy(vecY*U(100));

			// model grafics
				plCirc.createCircle(pt ,vzE,dThisDiameter/2);		
				plModelGraphics.append(plCirc);
				nModelGraphicsZone.append(nAdd2Zone);	
				
			// validate if extra drill depth is required due to underlaying stud
				if (nProjectSpecial==1)
				{
					for (int g=0;g<gbsZone0.length();g++)	// _GenBeam	Version 14.8
					{
						GenBeam gb=gbsZone0[g];
						if (gb.bIsKindOf(Beam()) && gb.myZoneIndex()==0)
						{
							PlaneProfile pp = gb.realBody().shadowProfile(Plane(_Pt0,vecZ));
							pp.intersectWith(PlaneProfile(plCirc));
							if (pp.area()>pow(dEps,2))
							{
								double d = U(70)-	dMyDepth;
								if (d>0)dExtraDepth=d;
								//pp.vis(2);
								break;
							}	
						}	
					}
				}	
				
			// test a slightly increased test drill solid against steel beams (extrusion profiles)
				Map mapIO;
				mapIO.setEntity(el.handle(),el);
				for (int g=0;g<gbDr.length();g++)
					mapIO.setEntity(gbDr[g].handle(), gbDr[g]);
				mapIO.setPLine("Shape",plCirc);
				mapIO.setDouble("Depth",dMyDepth);
				mapIO.setVector3d("vecDir",-vzE);
				mapIO.setInt("function",2);
				TslInst().callMapIO(scriptName(), mapIO);
				if (mapIO.hasDouble("depth") && mapIO.hasPoint3d("ptAlert"))
				{
					dMyDepth=mapIO.getDouble("Depth");
					ptsAlert.append(mapIO.getPoint3d("ptAlert")); 
				}	
							
				
				//pt.vis(4);
				if(!bSupressCnCElementTooling)
				{ 
					// HSB-23569
					ElemDrill drill(nAdd2Zone, pt , -vzT, (bReliefBeamOnly?dThisDepth:dMyDepth) , dThisDiameter, nToolIndex); // version 16.8
					el.addTool(drill);	//HSB-8878
				}
				Drill dr(pt,pt+vzT*(dMyDepth ),dThisDiameter/2);
				//dr.cuttingBody().vis(2);
				dr.excludeMachineForCNC(_kAnyMachine);
				dr.addMeToGenBeamsIntersect(gbDr);	
				if(!bSupressCnCElementTooling)
				{ 
					// HSB-23569
					PLine plNN(-vzT);
					plNN.createRectangle(LineSeg(pt-(vecX+vecY)*.5*dThisDiameter,pt+(vecX+vecY)*.5*dThisDiameter), vecX,vecY);
					ElemNoNail nn(nAdd2Zone,plNN);
					el.addTool(nn);						
				}
			}
			
		// special condition: if a combination symbol has been dragged to the 
		// opposite side or to end of a wall only one drilling will be processed
			if(nProjectSpecial==1 & bMirrorSymbols)
			{
				break;	
			}		
		}	// next insertion point/drill	
		
	// custom output timemanagement
		if(nProjectSpecial==1 && nNumClash>0)
		{
			if(!bSupressCnCElementTooling)
			{ 
				// HSB-23569
				Map mapItem;
				mapItem.setInt("Quantity",nNumClash);
				ElemItem item(0,"Deep Socket",_Pt0,el.vecX(),mapItem );
				item.setShow(_kNo);	
				el.addTool(item);
			}
		}
	}
//Shape 1: SLOTTED HOLE #1
	else if ((nToolType==1) && dY>dEps)
	{
		double dBulge = 1;
		int nLeftRight =_kLeft;
		Vector3d vxSlot = vecX;
		if (nAlign ==1) vxSlot=-vecY;
		Vector3d vySlot = vxSlot.crossProduct(-vecZ);	
		Vector3d vzZone = vecZ;//el.zone(nZone).vecZ();
		
		
	// custom shape
		double dRadius = dDiameter * .5;
		if(nCustomToolType>-1)
		{ 
			int n = sShapes.find(sShape);
			if (n >- 1)dRadius = dShapeRadii[n];
			if (2*dRadius>dDiameter)
			{
				dRadius = dDiameter * .5;// reset if too big	
				nCustomToolType = -1;
			}
			else dBulge = tan(22.5);
		}
		
		Point3d ptM;
		ptM.setToAverage(plNN.vertexPoints(true));	//ptM.vis(2);		
		
		
		plTool =PLine(vzZone);
		double dXShape = dWidth-(2*dRadius);
		if (dXShape<=0)
		{
			if(nCustomToolType>-1)
				dXShape = dDiameter;
			else
			{ 
				dWidth.set(dDiameter);
				setExecutionLoops(2);// force recalc				
			}
		}
		Point3d pt = ptM + vxSlot * .5 * (dXShape)-vySlot *.5*dY;	//pt.vis();

	//region CustomShape
		if(nCustomToolType>-1)
		{ 
			plTool.addVertex(pt); 
			pt.transformBy((vxSlot+vySlot) * dRadius); 
			plTool.addVertex(pt,dBulge);
			pt.transformBy(vySlot * (dY-2*dRadius)); 
			plTool.addVertex(pt);
			pt.transformBy(-vxSlot * dRadius+vySlot*dRadius); 
			plTool.addVertex(pt,dBulge);
			pt.transformBy(-vxSlot*dXShape);	//pt.vis();					
			plTool.addVertex(pt);
			
			pt.transformBy(-vxSlot * dRadius-vySlot*dRadius); 
			plTool.addVertex(pt,dBulge);
			pt.transformBy(-vySlot * (dY-2*dRadius)); 
			plTool.addVertex(pt);
			pt.transformBy((vxSlot-vySlot) * dRadius); 
			plTool.addVertex(pt,dBulge);	
			plTool.close();
			
		}
	//End CustomShape//endregion 
		else
		{ 
			Point3d ptA=pt;
			pt.vis(1);
			plTool.addVertex(pt); 
			pt.transformBy(vySlot*dY); 
			pt.vis(2);
			plTool.addVertex(pt,dBulge);
			pt.transformBy(-vxSlot*dXShape);
			pt.vis(3);
			plTool.addVertex(pt);	
			pt.transformBy(-vySlot*dY);	
			pt.vis(4);
			plTool.addVertex(pt,dBulge);
			
		// adjust strip length to max available
			double dThisStripLength=dStripLength;
			double dMaxStripLength=vxSlot.dotProduct(ptA-pt);
			if (dMaxStripLength<dThisStripLength )
				dThisStripLength=dMaxStripLength;
	
		// close poly if strip length becomes negative		
			//if (abs(dMaxStripLength-dThisStripLength)>dEps)
			
			if(dThisStripLength>0)
			{		
				pt.transformBy(vxSlot*(dMaxStripLength-dThisStripLength));
				plTool.addVertex(pt);
			}
			else
			{ 
				if(bOnlyContourMilling)
				{
					// only contour
					plTool.close();
				}
				else 
				{ 
					// create pline to destroy all, starting from the inside
//					double dMin=dWidth>dDiameter?dDiameter:dWidth;
					Vector3d vx=vecX;
					Vector3d vy=vecY;
					// HSB-21887
					if(nAlign==1)
					{ 
						vx=vecY;
						vy=-vecX;
					}
					// HSB-21887
					plTool=calcPlineDestroy(plTool,dDiameter,dMillingDiameter,
						vx,vy);

//					plToolDestroy.transformBy(vecY*U(300));
//					plToolDestroy.vis(6);
//					plToolDestroy.transformBy(-vecY*U(300));
				}
			}
		}

		plTool.projectPointsToPlane(pnZone,vecZZone);
		//vecDistr.vis(pt,2); plTool.vis(4);		_Pt0.vis(3);
		
	// test a slightly increased test drill solid against steel beams (extrusion profiles)
		//PLine plThisShape = plTool;
		//plThisShape .projectPointsToPlane(Plane(ptM,ez.vecZ()),ez.vecZ());
		Map mapIO;
		mapIO.setEntity(el.handle(),el);
		for (int g=0;g<gbsAll.length();g++)
			mapIO.setEntity(gbsAll[g].handle(), gbsAll[g]);
		mapIO.setPLine("Shape",plTool);
		mapIO.setDouble("Depth",dSubtractDepth);
		mapIO.setVector3d("vecDir",-vzE);
		mapIO.setInt("function",2);
		TslInst().callMapIO(scriptName(), mapIO);
		if (mapIO.hasDouble("depth") && mapIO.hasPoint3d("ptAlert"))
		{
			dSubtractDepth=mapIO.getDouble("Depth");
			ptsAlert.append(mapIO.getPoint3d("ptAlert")); 
		}

	// add if no special
		if (nArSpecial.length()<1 || nArSpecial[0]==0)
		{
		// add as mill 		
			if (dXShape>0)
			{
				if(!bSupressCnCElementTooling)
				{ 
					// HSB-23569
					ElemMill elMill(nZone, plTool, dSubtractDepth,nToolIndex,nLeftRight ,_kTurnAgainstCourse, _kNoOverShoot);
					el.addTool(elMill);
				}
			// model graphics
				//plTool.close();
				plModelGraphics.append(plTool);
			}
			else
			{
				Point3d ptDrill=_Pt0-vecDistr*(nPos-2)*.5*dWidth;
				if(!bSupressCnCElementTooling)
				{ 
					// HSB-23569
					ElemDrill elDrill(nZone, ptDrill , vzT, dSubtractDepth, dDiameter, nToolIndex);
					el.addTool(elDrill);
				}
			// model graphics
				PLine plCirc;
				plCirc.createCircle(ptDrill  ,vzE,dThisDiameter/2);		
				plModelGraphics.append(plCirc);
			}	
			nModelGraphicsZone.append(nZone);	
		}
		else
			plNN=PLine();	
	
	// clash detection for relief tools
		if (dReliefDepth>dEps)
		{
			for (int g=0;g<gbsZone0.length();g++)
			{
				GenBeam gb=gbsZone0[g];
				if (gb.bIsKindOf(Beam()) && gb.myZoneIndex()==0 && !gb.bIsDummy())
				{
					PlaneProfile pp = gb.realBody().shadowProfile(Plane(_Pt0,vecZ));
					pp.intersectWith(PlaneProfile(plTool));
					if (pp.area()>pow(dEps,2))
					{
						PLine pl;
						pl.createRectangle(pp.extentInDir(vecX), vecX,vecY);
						ppClash.joinRing(pl, _kAdd);
						break;
					}	
				}	
			}
		}	
	}	
	
//Shape 2: Rectangular #2
	else if (sShape==kShapeRectangular && dY>dEps)
	{	
		int nLeftRight = _kLeft;
			
	// collect the vertices from the no nail area
		// do not mill completly to avoid hassle with the dust extraction
		Point3d pts[] = plNN.vertexPoints(false);
		plTool=PLine (vzE);
		if (bHasPeninsulaMilling)
		{
			for(int i=0;i<pts.length();i++)
			{
				Point3d pt=pts[i];
				if (i==0 && pts.length()>1)
				{
					Vector3d vec = pts[i+1]-pts[i];
					if (vec.length()>2*dStripLength )
					{
						vec.normalize();
						pt.transformBy(vec*dStripLength);
					}
				}
				plTool.addVertex(pt);		
			}
		}
		else
			plTool=plNN;

		
	// test tooling side as direction of vertices might be swapped
		if (pts.length()>1)
		{
			Vector3d vxTest = pts[1]-pts[0];
			Vector3d vyTest = vxTest.crossProduct(vzE);
			vyTest.normalize();
			//vyTest.vis((pts[1]+pts[0])/2,4);	
			if (PlaneProfile(plTool).pointInProfile((pts[1]+pts[0])/2+vyTest*dEps)==_kPointInProfile)
				nLeftRight = _kRight;
		}	
		

		//plTool.close();
		plTool.setNormal(vzE);// nFlipFlag*  Version 6.4
		plTool.projectPointsToPlane(pnZone,vecZZone);

	// test a slightly increased test drill solid against steel beams (extrusion profiles)
		Map mapIO;
		mapIO.setEntity(el.handle(),el);
		for (int g=0;g<gbsZone0.length();g++)
			mapIO.setEntity(gbsZone0[g].handle(), gbsZone0[g]);
		mapIO.setPLine("Shape",plTool);
		mapIO.setDouble("Depth",dSubtractDepth);
		mapIO.setVector3d("vecDir",-vecZZone);
		mapIO.setInt("function",2);
		TslInst().callMapIO(scriptName(), mapIO);
		if (mapIO.hasDouble("depth") && mapIO.hasPoint3d("ptAlert"))
		{
			dSubtractDepth=mapIO.getDouble("Depth");
			ptsAlert.append(mapIO.getPoint3d("ptAlert")); 
		}

		
	// add if no special
		if (nArSpecial.length()<1 || nArSpecial[0]==0)
		{
		// model graphics		
			plModelGraphics.append(plTool);
			nModelGraphicsZone.append(nZone);
	
		// add second or default milling contour: through
			if(!bSupressCnCElementTooling)
			{ 
				// HSB-23569
				ElemMill elMill(nZone, plTool, dSubtractDepth,nToolIndex,nLeftRight,_kTurnAgainstCourse, _kNoOverShoot);
				el.addTool(elMill);
			}
			
		// add a subtract tool
			if (plTool.area()>pow(dEps,2) && dToolDepth>dEps)
			{
				SolidSubtract sosu(Body(plTool , vecZZone*dSubtractDepth*2,0),_kSubtract);//sosu.cuttingBody().vis(3);
				for (int g=0;g<sheets.length();g++)
					sheets[g].addTool(sosu);
			}	
		}		
	// SPECIAL 4: modify tooling contour if it applies
		else if (nArSpecial.find(4)>-1)
		{	
			ptIns.setToAverage(plNN.vertexPoints(true));
			//ptIns.vis(2);					
							
		// overwrite entity color
			_ThisInst.setColor(sColors[0]);
			dpModel.color(sColors[0]);
					
		// outer zone
			int nThisZone=1;
			for(int i=1;i<6;i++)
				if (el.zone(i).dH()>dEps)
					nThisZone=i;	
			ElemZone ez= el.zone(nThisZone);
			plTool=PLine (ez.vecZ());//PLine plTool(ez.vecZ());   // version 9.2
			ptIns.transformBy(ez.vecZ()*ez.vecZ().dotProduct(ez.ptOrg()-ptIns));

		// special parameters
			double dMillDepth = ez.dH()+dEps;
			double dXY = U(150);

		// adjust ptIns if rectangular or slotted behaviour selected
			if (nShape>0)	
			{
				ptIns.transformBy((nPos-2)*.5*vecDistr*dXY);	
			}

					
		// resize tooling
			LineSeg seg(ptIns-(vecDistr+vyC)*.5*dXY,ptIns+(vecDistr+vyC)*.5*dXY);
			
			
		// the special 4 contains tooling in two zones. loop twice to ensure sheetings in each zone as it might happen, that the oouter zone is cut back at t-connections	
			int nSpecialZone = nThisZone;
			for (int i=0;i<2;i++)
			{
				ElemZone zo = el.zone(nSpecialZone);
				plTool.createRectangle(seg,vecDistr,vyC);
				
//				if (_bOnDebug)
//				{
//					ppZone.transformBy(vecZ*U(2000)*nSpecialZone);
//					//ppZone.vis(nSpecialZone);
//				}	
				
			// merge zone and tool
				plTool.projectPointsToPlane(Plane(zo.ptOrg(),zo.vecZ()), zo.vecZ());
				PlaneProfile ppTool(plTool);		
				ppTool.intersectWith(ppZone);
				plTool = PLine(ez.vecZ());
				plRings=ppTool.allRings();
				bIsOp=ppTool.ringIsOpening();
				for (int r=0;r<plRings.length();r++)
					if (!bIsOp[r] && plTool.area()<plRings[r].area())
						plTool=plRings[r];			

			// validate tooling area
				if (plTool.area()>pow(dEps,2) && i==0)
				{
					double dShrink = U(10); // the offset of the first milling contour
	
					Map mapIO,mapIO2, mapSheets;
					mapIO.setInt("function",1);			
					mapIO.setInt("zone",nSpecialZone);	
					mapIO.setEntity("Element",el);
					mapIO.setPLine("plTool",plTool);
					mapIO.setPLine("plZone",plZone);
					mapIO.setDouble("shrink", 0);
					mapIO.setDouble("stripLength",0);//dStripLength
					TslInst().callMapIO(scriptName(), mapIO);
					plTool = mapIO.getPLine("plTool");
					plTool.projectPointsToPlane(Plane(ptOrgZone+vecZZone*dHZone,vecZZone),vecZZone);
					plTool.setNormal(ez.vecZ());
						
				// milling special
					if(!bSupressCnCElementTooling)
					{ 
						// HSB-23569
						ElemMill elMill(nSpecialZone,plTool,dMillDepth,nToolIndex,_kLeft,_kTurnAgainstCourse,_kNoOverShoot);
						el.addTool(elMill);
					}
					
				// set model graphics and NN
					plNN = mapIO.getPLine("plToolRectangle");
					plModelGraphics.append(plNN);
					nModelGraphicsZone.append(nThisZone);

				// subtract rectangular part of special tool	// version 9.2
					Body bdSubtract(plTool,-vzE*(dMillDepth*2),0);
					bdSubtract.transformBy(vecZ*vecZ.dotProduct(ez.ptOrg()-plTool.ptStart()));
					if (bdSubtract.volume()>(0.7854*pow(dDiameter,2)*dEps))
					{
						//bdSubtract.vis(4);	
						SolidSubtract sosu(bdSubtract,_kSubtract);
						GenBeam gbSubtracts[] = bdSubtract.filterGenBeamsIntersect(gbsAll);//_GenBeam);	Version 14.8
						for (int i = 0;i<gbSubtracts.length();i++)
						{
							
							if (gbSubtracts[i].myZoneIndex()==nThisZone)
								gbSubtracts[i].addTool(sosu);
						}
					}
					
				//// no nail  // duplicate detected version 14.4
					//if (plNN.area()>pow(dEps,2))
					//{	
						//ElemNoNail nn(nSpecialZone,plNN);
						//el.addTool(nn);	
					//}
				}// END IF if (plTool.area()>pow(dEps,2) && i==0)
				
				
			// drill zones below
				else if (i==1  && nSpecialZone>0)//&& plTool.area()>pow(dEps,2)
				{ 
					double dThisDiam = U(74);
					if(!bSupressCnCElementTooling)
					{ 
						// HSB-23569
						ElemDrill elDrill(nSpecialZone, ptIns , -ez.vecZ(), ez.vecZ().dotProduct(ez.ptOrg()-el.ptOrg()), dThisDiam , nToolIndex);//dDiameter
						el.addTool(elDrill);
					}
					double dZ = zo.vecZ().dotProduct(zo.ptOrg()-el.ptOrg())+zo.dH()+dEps;
					SolidSubtract sosu(Body(ptIns+zo.vecZ()*dEps,ptIns-zo.vecZ()*dZ,dThisDiam /2),_kSubtract);		//sosu.cuttingBody().vis(1);
					for (int i=0;i<gbsAll.length();i++)//_GenBeam	Version 14.8
						if (gbsAll[i].myZoneIndex()==nSpecialZone)
							gbsAll[i].addTool(sosu);
				}
				else
					bErrOutside=true;
					
				if (nSpecialZone<0) nSpecialZone+=1;
				else nSpecialZone-=1;
			}// next i

		}// END special 4
		else
			plNN=PLine();
			
			
	// clash detection for relief tools
		if (dReliefDepth>dEps)
		{
			for (int g=0;g<gbsZone0.length();g++)//_GenBeam);	Version 14.8
			{
				GenBeam gb=gbsZone0[g];
				if (gb.bIsKindOf(Beam()))// && gb.myZoneIndex()==0 && !gb.bIsDummy()
				{
					PlaneProfile pp = gb.realBody().shadowProfile(Plane(_Pt0,vecZ));
					pp.intersectWith(PlaneProfile(plTool));
					if (pp.area()>pow(dEps,2))
					{
						PLine pl;
						pl.createRectangle(pp.extentInDir(vecX), vecX,vecY);
						ppClash.joinRing(pl, _kAdd);
						break;
					}	
				}	
			}
		}
	}// END else if  Rectangular
	
// subtract solids for rectangular and slotted shapes 
	if (!bShapeByInstallation && !bHasSpecial4 && plTool.area()>pow(dEps,2) && dSubtractDepth>dEps)  // version  value="10.6 plTool validation
	{
		plTool.projectPointsToPlane(pnZone, vecZZone);
		Body bdX(plTool, vzE * dSubtractDepth*.5, 1);	// version 16.8 projection fixed, alignment corrected, test body enhanced	
		Body bdSubtract(plTool,vzE*(dSubtractDepth+2*dEps),1);
		bdSubtract.transformBy(-vzE*dEps);// catch sheet tolerances
		if (bdSubtract.volume()>(0.7854*pow(dDiameter,2)*dEps))
		{
			//bdSubtract.vis(7);	
			SolidSubtract sosu(bdSubtract,_kSubtract);
			GenBeam gbSubtracts[] = bdX.filterGenBeamsIntersect(gbsAll);//_GenBeam);	Version 14.8
			for (int i = 0;i<gbSubtracts.length();i++)
				gbSubtracts[i].addTool(sosu);
		}
	}

// add relief beamcuts as additional clash tool if specified. values of dReliefHeight and CombinationReliefDepth must be set in setttings
	// #3700
	if (ppClash.area()>pow(dEps,2) && (dReliefHeight>0 || mapSetting.getDouble("CombinationReliefHeight")>0))
	{
	// get conduit extremes from parent and filter tpo zone
		Point3d ptsConduitExtremes[] = mapParent.getPoint3dArray("ptsConduitExtremes");		
		for (int i=ptsConduitExtremes.length()-1;i>=0;i--)
		{
			if (abs(vzE.dotProduct(ptsConduitExtremes[i]-ptIns))>dReliefDepth)
				ptsConduitExtremes.removeAt(i);
			else
				;//ptsConduitExtremes[i].vis(222);
		}
		ptsConduitExtremes=lnY.orderPoints(ptsConduitExtremes);
		
	// get clash dimensions
		LineSeg segClash = ppClash.extentInDir(vecX);
		segClash.transformBy(vecZ*vecZ.dotProduct(ptIns-segClash.ptMid()));//segClash.vis(2);
		Point3d ptsClash[] = {segClash.ptEnd(),segClash.ptStart()};
		ptsClash=lnY.orderPoints(ptsClash);
		double dXClash, dYClash;
		if(ptsClash.length()>1)
		{
			dXClash = abs(vecX.dotProduct(segClash.ptEnd()-segClash.ptStart()));
			dYClash = abs(vecY.dotProduct(segClash.ptEnd()-segClash.ptStart()));
		}

	// get conduit extremes to toggle bottom and/or top clash tooling
		double dBottom, dTop;
		if(ptsConduitExtremes.length()>1)
		{
			dBottom  = vecY.dotProduct(ptsClash[0]-ptsConduitExtremes[0]);
			dTop= vecY.dotProduct(ptsConduitExtremes[ptsConduitExtremes.length()-1]-ptsClash[ptsClash.length()-1]);	
		}		

	// flags if a bottom or top relief is added
		int bAddBottomRelief = dBottom>dYClash;
		int bAddTopRelief=dTop>dYClash;	

	// set initial values of reliefs to false if mode is set to <none>
		if (nReliefMode==0)
		{
			if(!_Map.hasInt("ClashReliefBottom")) bAddBottomRelief =false;
			if(!_Map.hasInt("ClashReliefTop")) bAddTopRelief =false;
		}

	// get user defined states of bottom and top reliefs
		if (_Map.hasInt("ClashReliefBottom"))bAddBottomRelief =_Map.getInt("ClashReliefBottom");
		if (_Map.hasInt("ClashReliefTop"))bAddTopRelief =_Map.getInt("ClashReliefTop");		

	// add  trigger to toggle and override clash toolings on bottom and top side
		addRecalcTrigger(_kContext, "----------   ");// a blind trigger		
		
		String sTriggerBottomRelief = T("|Relief|" + " " + T("|bottom|"));
		if (bAddBottomRelief)sTriggerBottomRelief = T("|No Relief|")+ " " + T("|bottom|");
		addRecalcTrigger(_kContext, sTriggerBottomRelief);	
		if (_bOnRecalc && _kExecuteKey==sTriggerBottomRelief)
		{
			if (bAddBottomRelief)bAddBottomRelief =false;
			else bAddBottomRelief =true;
			_Map.setInt("ClashReliefBottom",bAddBottomRelief);
			setExecutionLoops(2);
			return;
		}	
			
		String sTriggerTopRelief = T("|Relief|" + " " + T("|top|"));
		if (bAddTopRelief)sTriggerTopRelief = T("|No Relief|")+ " " + T("|top|");
		addRecalcTrigger(_kContext, sTriggerTopRelief );		
		if (_bOnRecalc && _kExecuteKey==sTriggerTopRelief)
		{
			if (bAddTopRelief)bAddTopRelief=false;
			else bAddTopRelief=true;
			_Map.setInt("ClashReliefTop",bAddTopRelief);
			setExecutionLoops(2);
			return;			
		}

	// show commands to adjust relief height and depth only if mode is set to <Automatic> or if any relief is set
		if (nReliefMode==1 || bAddBottomRelief || bAddTopRelief)
		{
			String sTriggerHeightRelief = T("|Edit Relief Height|") + " (" +dReliefHeight+ ")";
			addRecalcTrigger(_kContext, sTriggerHeightRelief );		
			if (_bOnRecalc && _kExecuteKey==sTriggerHeightRelief )
			{
				double d= getDouble(T("|Enter Relief Height|") + " (" +dReliefHeight+ ")");
				if (d>0)
				{
					dReliefHeight=d;
					_Map.setDouble("CombinationReliefHeight",dReliefHeight);
				}
				setExecutionLoops(2);
				return;			
			}
	
			String sTriggerHeightDepth= T("|Edit Relief Depth|") + " (" +dReliefDepth+ ")";
			addRecalcTrigger(_kContext, sTriggerHeightDepth);		
			if (_bOnRecalc && _kExecuteKey==sTriggerHeightDepth)
			{
				double d= getDouble(T("|Enter Relief Depth|") + " (" +dReliefDepth+ ")");
				if (d>0)
				{
					dReliefDepth=d;
					_Map.setDouble("CombinationReliefDepth",dReliefDepth);
				}
				setExecutionLoops(2);
				return;			
			}
		}
		else
		{
			String sTriggerBothRelief = T("|Relief|" + " " + T("|on both sides|"));
			addRecalcTrigger(_kContext, sTriggerBothRelief );		
			if (_bOnRecalc && _kExecuteKey==sTriggerBothRelief)
			{
				_Map.setInt("ClashReliefBottom",true);
				_Map.setInt("ClashReliefTop",true);
				setExecutionLoops(2);
				return;			
			}		
		}
		
	// set minimal beamcut dimensions
		double dXBc = dXClash;
		double dYBc=dReliefHeight+dYClash+dReliefHeightExtension;
		double dZBc=dReliefDepth;
		if (dXBc >dEps && dYBc>dEps && dZBc>dEps && 
			dXClash>dEps && dYClash > dEps && (bAddBottomRelief || bAddTopRelief) &&
			dReliefHeight>0)
		{
		// set body/beamcut orientation and size
			double dYFlag;
			if (bAddBottomRelief && !bAddTopRelief)
				dYFlag=-1;
			else if (!bAddBottomRelief && bAddTopRelief)
				dYFlag=1;
			else 
			{
				dYBc=2*dReliefHeight+dYClash;
			}
		
		// set test body
			Point3d ptRelief = segClash.ptMid()-vecY *dYFlag*.5*dYClash;
			if (bAddBottomRelief !=bAddTopRelief)ptRelief.transformBy(-vecY*dYFlag*.5*dReliefHeightExtension);	
			Body bdClash(ptRelief , vecX,vecY,vecZ,dXBc,dYBc, dZBc, 0,dYFlag,-nSide );
			//bdClash.vis(2);
			
		// filter interscting beams
			GenBeam gbs[0];
			gbs= bdClash.filterGenBeamsIntersect(gbsZone0);	
			Beam beamsClash[0];
			double dXMax; // the width extension of the beamcut to ensure that it is always a through tool
			for (int i=0;i<gbs.length();i++)
			{
				//if(gbs[i].bIsDummy()) continue;
				if (gbs[i].bIsKindOf(Beam()))
				{
					Beam bm = (Beam)gbs[i];
					beamsClash.append(bm);	
					if (bm.vecX().isParallelTo(vecY) && dXMax<bm.dD(vecX))
						dXMax=bm.dD(vecX);
				}
			}	
			dXBc+=2*dXMax;

			BeamCut bcClash(ptRelief , vecX,vecY,vecZ,dXBc,dYBc, dZBc, 0,dYFlag,-nSide );
			//bcClash.cuttingBody().vis(40);
			bcClash.addMeToGenBeamsIntersect(beamsClash);
		}	
	}
	// remove potential user flags if the clash has been resolved
	else if (ppClash.area()<pow(dEps,2) && dReliefHeight>0)
	{
		_Map.removeAt("ClashReliefBottom",true);
		_Map.removeAt("ClashReliefTop",true);
	}
// END IF // add relief beamcuts as additional clash tool



// add no nails to every zone if construction is build
	if (gbsAll.length()>0 && plNN.area()>pow(dEps,2))
		for(int i=1;i<6;i++)
			if (el.zone(i*nSide).dH()>dEps)
			{
				if(!bSupressCnCElementTooling)
				{ 
					// HSB-23569
					ElemNoNail nn(i*nSide,plNN);
					el.addTool(nn);
				}
			}	
	
//_____________________________________________________standard shapes	

// SPECIALS
	for(int i=0;i<nArSpecial.length();i++)	
	{
		int nSpecial = nArSpecial[i];
		ptIns = ptArIns[i];

	// SPECIAL 1: add additional drill 10cm above
		if (nSpecial==1 && !bExposedIcon)
		{
		// this parameters
			// the depth of one drill will be adjusted if intersecting with an underlaying stud
			double dThisDepth=dToolDepth;
			Point3d ptThis = ptIns+vecY*U(100);
			dThisDiameter = U(68);
			
		// create model graphics
			PLine plCirc;
			plCirc.createCircle(ptThis ,vzE,dThisDiameter/2);		
			plModelGraphics.append(plCirc);
			nModelGraphicsZone.append(nZone);			

		// cnc tool	
			double dExtraDepth;
			if (dExtraDepths.length()>i)dExtraDepth=dExtraDepths[i];
			if(!bSupressCnCElementTooling)
			{ 
				// HSB-23569
				ElemDrill elDrill(nZone, ptThis, vzT, dThisDepth+dExtraDepth , dThisDiameter, nToolIndex);
				el.addTool(elDrill);	
			}
			
		// solid tool
			Drill dr(ptThis+vzT*dEps ,ptThis -vzT*(dThisDepth+dExtraDepth),dThisDiameter/2);
			dr.excludeMachineForCNC(_kAnyMachine);
			dr.addMeToGenBeamsIntersect(gbDr);		
			
		// no nail
			dX=dOffsetInstallations; if (dThisDiameter>dOffsetInstallations)dX=dThisDiameter;
			plNN.createRectangle(LineSeg(ptThis-.5*((vecX-vecY)*dX), ptIns+.5*(vecX-vecY)*dX),vecX,vecY);
		// add no nails to every zone if construction is build
			if (gbsAll.length()>0 && plNN.area()>pow(dEps,2))
			{ 
				if(!bSupressCnCElementTooling)
				{ 
					// HSB-23569
					for(int i=1;i<6;i++)
						if (el.zone(i*nSide).dH()>dEps)
						{
							ElemNoNail nn(i*nSide,plNN);
							el.addTool(nn);	
						}
				}
			}
		}
	// SPECIAL 2: modify tooling contour if it applies
		else if (nSpecial==2)
		{		
		// this zone
			int nThisZone=nZone;
			ElemZone ez= el.zone(nThisZone);
			PLine plTool(ez.vecZ());
			ptIns.transformBy(ez.vecZ()*(ez.vecZ().dotProduct(ez.ptOrg()-ptIns)+dEps));

		// special parameters
			double dMillDepth = ez.dH()+dEps;
			double dXY = dWidth;	
			
		// adjust ptIns if rectangualr or slotted behaviour selected
			if (nShape>0)	ptIns.transformBy((nPos-2)*.5*vecDistr*dXY);	

		// resize tooling
			LineSeg seg(ptIns-(vecDistr+vyC)*.5*dXY,ptIns+(vecDistr+vyC)*.5*dXY);
			plTool.createRectangle(seg,vecDistr,vyC);
			
		// merge zone and tool
			plTool.projectPointsToPlane(pnZone, vecZZone);
			PlaneProfile ppTool(plTool);		
			ppTool.intersectWith(ppZone);
			plTool = PLine();
			plRings=ppTool.allRings();
			bIsOp=ppTool.ringIsOpening();
			for (int r=0;r<plRings.length();r++)
				if (!bIsOp[r] && plTool.area()<plRings[r].area())
					plTool=plRings[r];			

		// validate tooling area
			if (plTool.area()>pow(dEps,2))
			{
				Map mapIO,mapIO2, mapSheets;
				mapIO.setInt("function",1);			
				mapIO.setInt("zone",nZone);	
				mapIO.setEntity("Element",el);
				mapIO.setPLine("plTool",plTool);
				mapIO.setPLine("plZone",plZone);
				mapIO.setDouble("shrink", 0);
				mapIO.setDouble("stripLength",dStripLength);
				TslInst().callMapIO(scriptName(), mapIO);
				plTool = mapIO.getPLine("plTool");
				plTool.projectPointsToPlane(Plane(ptOrgZone+vecZZone*dHZone,vecZZone),vecZZone);
				plTool.setNormal(nFlipFlag*vzE);
					
			// milling special
				if(!bSupressCnCElementTooling)
				{ 
					// HSB-23569
					ElemMill elMill(nThisZone, plTool, dMillDepth ,nToolIndex,_kLeft,_kTurnAgainstCourse, _kNoOverShoot);
					el.addTool(elMill);
				}
				{
					SolidSubtract sosu(Body(plTool,ez.vecZ()*ez.dH()*2,0),_kSubtract);		//sosu.cuttingBody().vis(1);
					sosu.addMeToGenBeamsIntersect(gbsAll);// _GenBeam);	Version 14.8
				}
				
			// set model graphics and NN
		
				plModelGraphics.append(plTool);
				nModelGraphicsZone.append(nThisZone);
				plNN = mapIO.getPLine("plToolRectangle");
				
			// drill zones below
				if (abs(nThisZone)>1)
				{ 
					int nZoneBelow = nThisZone-(nThisZone/abs(nThisZone));
					double dZ = el.zone(nThisZone).dH()+dEps;
					if(!bSupressCnCElementTooling)
					{ 
						// HSB-23569
						ElemDrill elDrill(nThisZone, ptIns , -ez.vecZ(), dZ, dDiameter, nToolIndex);
						el.addTool(elDrill);
					}	
					SolidSubtract sosu(Body(ptIns,ptIns-ez.vecZ()*dZ,dDiameter/2),_kSubtract);		//sosu.cuttingBody().vis(1);
					sosu.addMeToGenBeamsIntersect(gbsAll);// _GenBeam);	Version 14.8
				}
				
			// no nail
				if (plNN.area()>pow(dEps,2))	
				{
					if(!bSupressCnCElementTooling)
					{ 
						// HSB-23569
						ElemNoNail nn(nThisZone,plNN);
						el.addTool(nn);
					}
				}		
			}// end if valid tool area
			else
				bErrOutside=true;
		}// END special 2

	// SPECIAL 3: modify tooling contour if it applies
		else if (nSpecial==3)
		{
		// create a default boxed shape for an individual installation in a drill-shaped combination
			if (nShape==0)
			{
				plTool.createRectangle(LineSeg(ptIns-(vecX+vecY)*.5*dDiameter,ptIns+(vecX+vecY)*.5*dDiameter),vecX,vecY);
			}
			
		// merge zone and tool
			plTool.projectPointsToPlane(pnZone, vecZZone);
			PlaneProfile ppTool(plTool);
			ppTool.intersectWith(ppZone);
			plTool = PLine(nFlipFlag*vzE);
			plRings=ppTool.allRings();
			bIsOp=ppTool.ringIsOpening();
			for (int r=0;r<plRings.length();r++)
				if (!bIsOp[r] && plTool.area()<plRings[r].area())
					plTool=plRings[r];			
			
		// validate tooling area
			if (plTool.area()>pow(dEps,2))
			{
				
				double dShrink = -nFlipFlag*U(10); // the offset of the first milling contour
				if (nShape==1)plTool.createRectangle((PlaneProfile(plTool)).extentInDir(vecX),vecX,vecY);
				plTool.setNormal(nFlipFlag*vzE);	

				Map mapIO,mapIO2, mapSheets;
				mapIO.setInt("function",1);			
				mapIO.setInt("zone",nZone);	
				mapIO.setEntity("Element",el);
				mapIO.setPLine("plTool",plTool);
				mapIO.setPLine("plZone",plZone);
				mapIO.setDouble("shrink", -dShrink);
				mapIO.setDouble("stripLength",dStripLength);		
				mapIO2=mapIO;
				TslInst().callMapIO(scriptName(), mapIO);
		
			// add first milling contour: rabbet
				PLine plMill = mapIO.getPLine("plTool");	//plMill.vis(3);	
				plMill.setNormal(nFlipFlag*vzE);
				if(!bSupressCnCElementTooling)
				{ 
					// HSB-23569
					ElemMill elMill(nZone, plMill , dToolDepth ,nToolIndex,_kLeft,_kTurnAgainstCourse, _kNoOverShoot);
					el.addTool(elMill);
				}
				
			// add a squared subtract
				plMill.createRectangle((PlaneProfile(plMill)).extentInDir(vecX),vecX,vecY);
				if (plMill.area()>pow(dEps,2) && dToolDepth>dEps)
				{
					SolidSubtract sosu(Body(plMill, vecZZone*dToolDepth*3,0),_kSubtract);//sosu.cuttingBody().vis(3);
					for (int g=0;g<sheets.length();g++)
						sheets[g].addTool(sosu);
				}

				mapIO2.setDouble("shrink", 0);
				mapIO2.setDouble("stripLength",0);
				TslInst().callMapIO(scriptName(), mapIO2);
				plTool = mapIO2.getPLine("plTool");
				plTool.projectPointsToPlane(Plane(ptOrgZone+vecZZone*dHZone,vecZZone),vecZZone);
				dToolDepth= U(8);	
				plTool.setNormal(nFlipFlag*vzE);
				if(!bSupressCnCElementTooling)
				{ 
					// HSB-23569
					ElemMill elMill2(nZone, plTool, dToolDepth ,nToolIndex,_kLeft,_kTurnAgainstCourse, _kNoOverShoot);
					el.addTool(elMill2);
				}
				if (plMill.area()>pow(dEps,2) && dToolDepth>dEps)
				{
					SolidSubtract sosu(Body(plTool, vecZZone*dToolDepth*2,-1),_kSubtract);//sosu.cuttingBody().vis(6);
					for (int g=0;g<sheets.length();g++)
						sheets[g].addTool(sosu);
				}

			// set model graphics and NN	
				plModelGraphics.append(plTool);
				nModelGraphicsZone.append(nZone);
				plNN = plTool;// mapIO.getPLine("plToolRectangle");
				
			// no nail	
				if (plNN.area()>pow(dEps,2))	
				{	
					if(!bSupressCnCElementTooling)
					{ 
						// HSB-23569
						ElemNoNail nn(nZone,plNN);
						el.addTool(nn);
					}
				}		
				
			}// end if valid tool area
			else
				bErrOutside=true;
		}// END special 3
		
		else if (nSpecial==5)
		{
			
			
		}
	}// next i special


	
// draw model graphics
	for(int i=0;i<plModelGraphics.length();i++)
	{
	// the graphics zone
		int z = nZone;
		if (nModelGraphicsZone.length()>i)z=nModelGraphicsZone[i];
		PLine plGraphics = plModelGraphics[i];
		plGraphics.projectPointsToPlane(Plane(ptOrgZone,el.zone(z).vecZ()),el.zone(z).vecZ());
		
		if (z<0)dpModel.color(sColors[1]);
		else dpModel.color(sColors[0]);

		
		dpModel.draw(plGraphics);
		
	// draw symbols half filled
		if (bCombinationDrawFilledSymbol)
		{
			PlaneProfile ppModelGraphics(plGraphics);
			LineSeg ls = ppModelGraphics.extentInDir(vecX);
			double dY = abs(vecY.dotProduct(ls.ptStart()-ls.ptEnd()));
			plRec.createRectangle(ppModelGraphics.extentInDir(vecX),vecX,vecY);
			if (z!=0)plRec.transformBy(-z/abs(z)*vecY*.5*dY);
			ppModelGraphics.joinRing(plRec,_kSubtract);
			dpModel.draw(ppModelGraphics,_kDrawFilled);
		}
	}

// draw alerts
	double dAlertSize = U(120);	
	for (int i=0;i<ptsAlert.length();i++)
	{
		Point3d pt = ptsAlert[i];		
		CoordSys csRot, csMirr;
		csRot.setToRotation(45,vzE,pt);
		csMirr.setToMirroring(Plane(pt,vecY));		

		Display dpAlert(1);
		PLine plAlert(vzE);
		plAlert.addVertex(pt+vecX*3.5*dAlertSize);
		plAlert.addVertex(pt-vecX*3.5*dAlertSize+vecY*.5*dAlertSize);
		plAlert.addVertex(pt-vecX*3.2*dAlertSize-vecY*.5*dAlertSize);
		PlaneProfile ppAlert(plAlert);
		ppAlert.transformBy(csRot);
		dpAlert.draw(ppAlert, _kDrawFilled);						
		ppAlert.transformBy(csMirr);
		dpAlert.draw(ppAlert, _kDrawFilled);
	}


	
// horizontal/aligned or vertical conduit if offset is set
	if (nTypeOffset>0)
	{
	// if any ooffset is used for 2 executionloops to make sure that tools are always applied, added Version 12.6
		setExecutionLoops(2);
	// collect beams of zone 0
		GenBeam gbBc[0];
		Beam beams[]=el.beam();
		for (int i=0;i<beams.length();i++)
			if (beams[i].myZoneIndex()==0)
			{
				//beams[i].realBody().vis(3);
				gbBc.append(beams[i]);
			}	
		
		
	// the width of the offseted wirechase is derived from the installation point unless a value > 0 is defined
		double dThisWidth = tslParent.propDouble(0);
		double dThisDepth = tslParent.propDouble(1);		
		if (dWidthHorWirechase>0)	dThisWidth =dWidthHorWirechase;
		else if (dWidthHorWirechase<0)	dThisWidth =0;
		
		Point3d ptStart = _Pt0+vecZ*vecZ.dotProduct(ptOrg-_Pt0);
		if (nSide==-1)ptStart.transformBy(-vecZ*el.dBeamWidth());
		Point3d ptEnd=ptStart;
		Vector3d vxThis;
	// horizontal
		if (nTypeOffset==1)
		{
			vxThis = vecX;
			if (vecX.dotProduct(ptStart -ptParentOrg)<0)vxThis *=-1;
			
		// for special 1 offset the horizontal wirechase vertically 100mm
			if (nArSpecial.find(1)>-1)
				ptStart.transformBy(vecY*U(100));	
			
			
			ptEnd= ptStart  - vxThis *(vxThis .dotProduct(ptStart -ptParentOrg)+.5*dThisWidth);
		}
	// vertical bottom or top
		else if (nTypeOffset==2 || nTypeOffset==3)
		{
			vxThis = -vecY;
			if (nTypeOffset==3)vxThis *=-1;
			
			for (int i=0;i<gbBc.length();i++)
			{
				Vector3d vxGb = gbBc[i].vecX();
				if (vxGb.isParallelTo(vxThis))continue;
				Point3d pt = Line(ptStart,vxThis).intersect(Plane(gbBc[i].ptCen(),vxThis),0.5*gbBc[i].dD(vxThis)+dEps);
				if (vxThis.dotProduct(pt-ptStart)>vxThis.dotProduct(ptEnd-ptStart)) 
					ptEnd = pt;	
			}
		}
	// aligned
		else if(nTypeOffset==4 && _Map.hasInt("alignedOffsetGripIndex"))
		{
			int n = _Map.getInt("alignedOffsetGripIndex");
			if (_PtG.length()>n)
			{
				ptEnd = _PtG[n]-vecZ*vecZ.dotProduct(_PtG[n]-ptStart);	
				vxThis = ptEnd-ptStart;
				vxThis.normalize();	
//				ptEnd.vis(1);
//				ptStart.vis(1);
				
			}			
		}	
	
	// get dimensions and vecs of beamcut			
		double dThisLength = (ptEnd-ptStart).length();	
		if (!vxThis.bIsZeroLength() && dThisLength>dEps && dThisWidth>dEps && dThisDepth>dEps)
		{
	
			Vector3d vyThis=vxThis.crossProduct(vecZ);
			vyThis.normalize();
			//ptEnd.vis(4);ptStart.vis(7);
		
		// create and apply no nail zones
			plRec.createRectangle(LineSeg(ptStart+vyThis*dThisWidth*.5,ptEnd-vyThis*dThisWidth*.5),vxThis ,vyThis);	
			for(int i=1;i<6;i++)
				if (el.zone(i*nSide).dH()>dEps && plRec.area()>pow(dEps,2))
				{
					if(!bSupressCnCElementTooling)
					{ 
						// HSB-23569
						ElemNoNail nn(i*nSide,plRec);
						el.addTool(nn);	
					}
				}
		
		// collect parallel and non parallel beams: non parallel beams will be tested against beam width / tooling length
			GenBeam gbsPar[0], gbsRest[0];
			for (int g=0;g<gbBc.length();g++)
			{
				if (gbBc[g].vecX().isParallelTo(vxThis))
					gbsPar.append(gbBc[g]);
				else
					gbsRest.append(gbBc[g]);			
			}
			
		// create and assign standard beamcut						
			BeamCut bc((ptStart+ptEnd)/2, vxThis,vyThis,vecZ, dThisLength, dThisWidth, dThisDepth*2,0,0,0);
			//bc.cuttingBody().vis(2);			
			bc.addMeToGenBeamsIntersect(gbsPar);	
			Body bdTest = bc.cuttingBody();
			
		// loop non parallel beams
			for (int g=0;g<gbsRest.length();g++)
			{
			// test if intersecting beam would be manipulated at least half of it's width. ignore any tool smaller .5 * _W0	
				Body bdInt = gbsRest[g].envelopeBody(false,true);
				bdInt.intersectWith(bdTest);
				double d1 = bdInt.volume();
				double d2 = dThisWidth*dThisDepth*.5*gbsRest[g].dD(vxThis);		
				if (d1>d2)
				{
					//bdInt.vis(g);
					Point3d pt = (ptStart+ptEnd)/2;
					pt = Line(ptStart,vxThis).intersect(Plane(gbsRest[g].ptCenSolid(), gbsRest[g].vecD(vxThis)),0);
					
					Vector3d vecXBc = vxThis;
					Vector3d vecYBc = vecXBc.crossProduct(-vzT);
					Vector3d vecZBc = vzT;

					//pt.transformBy(vxThis*vxThis.dotProduct(gbsRest[g].ptCen()-pt));
					BeamCut bc2(pt,vecXBc ,vecYBc ,vecZBc ,U(10e3),dThisWidth, dThisDepth*2,0,0,0 );// version value="14.5" date="30jul15"
					gbsRest[g].addTool(bc2);
					//bc2.cuttingBody().vis(6);
				}
			}
		}
	}
	
		
// store x and y offstes of grip points for relocation
	if (abs(dParentMove)<dEps)
	{
		Map mapGrips;
		for (int i=0;i<_PtG.length();i++)
		{
			double dX = vxE.dotProduct(_PtG[i]-_Pt0);
			double dY = vyE.dotProduct(_PtG[i]-_Pt0);
			double dZ = vzE.dotProduct(_PtG[i]-_Pt0);
			Map mapGrip;
			mapGrip.setDouble("dXGrip", dX);
			mapGrip.setDouble("dYGrip", dY);
			mapGrip.setDouble("dZGrip", dZ);
			
			mapGrip.setVector3d("GripAbsolute", _PtG[i]-_PtW);
			
			mapGrips.setMap(i, mapGrip);
			_Map.setPoint3d("PtG"+i,_PtG[i]);
			//reportMessage("\n   debug 13.4: dParentMove = " + dParentMove + ", storing grip "+ i + " xyz " + dX +"/" + dY+"/" + dZ + " on loop " + _kExecutionLoopCount);
		}
		_Map.setMap("Grip[]",mapGrips);
		//_Map.setInt("Side", nSide);
	}


// update parent after appending this combination to it
	if (_bOnRecalc && _kExecuteKey==sTrigger[5])
	{	
	// update parent
		tslParent.recalc();	
	}

// publish noNail pline to others ( reused for annotation alignment)
	_Map.setPLine("plNN", plNN);
	_Map.setInt("Zone", nZone);	


	if(bDebug)reportNotice("\n" + scriptName() + " end execution." + _ThisInst.handle() + " qty of _GenBeams: " + _GenBeam.length());

}
// END DEFAULT MODE___________________________________________________________________________________________________________________________________

//region Annotation mode
	else if (nMode==1 || nMode==2)
	{
		//reportMessage("\nAnnotation mode " + nMode + " " + _ThisInst.handle());
	if (nMode==1)
		setOPMKey("Annotation");	
	else if (nMode==2)
		setOPMKey("AnnotationElement");
			
	String sPropNameS0 = T("|Description|") + " 1";
	PropString sDesc1(0, "",sPropNameS0);
	sDesc1.setDescription(T("|Free Textbox|"));	

	String sDesc2Name = T("|Description|") + " 2";
	PropString sDesc2(1, "",sDesc2Name);
	sDesc2.setDescription(T("|Free Textbox|"));	


	PropString sDimStyle(2,_DimStyles,T("|Dimstyle|"),0);
	
	PropDouble dTxtH(0,U(40),T("|Text Height|"));	
	dTxtH.setDescription(T("|Overrides the text size of the selected dimstyle.|"));	
	PropInt nColor (0,1,T("|Color|"));

	
// validate parent
	TslInst tslParent;
	for(int i=0;i<_Entity.length();i++)
	{
		TslInst tsl = (TslInst)_Entity[i];
		if (!tsl.bIsValid())continue;
		if (_bOnDebug ||  tsl.scriptName() == scriptName())
		{
			setDependencyOnEntity(_Entity[i]);
			tslParent= tsl;
		}	
		else if(tsl.scriptName().makeUpper()==sParentName)
			setDependencyOnEntity(_Entity[i]);
	}// next i	
	
	if (!tslParent.bIsValid())
	{
		reportMessage("\n"+T("|No valid instance of|") + " " + scriptName() + " " + T("|could be found|") +". " + T("Tool will be deleted."));
		eraseInstance();	
	}
	Map mapParent =tslParent.map() ;	
	int nZone = mapParent.getInt("Zone");

// erase me if diameter is <=0
	if (tslParent.propDouble(3)<=0)
	{
		reportMessage("\n"+T("|Diameter invalid.|") +". " + T("Tool will be deleted."));
		eraseInstance();
		return;	
	}

	

// relocate to default on creation
	if (nMode==1 && (_bOnDbCreated || _bOnRecalc))
	{
		//reportMessage("\nplan anno repos added for " + tslParent.propDouble(3) + " handle " + _ThisInst.handle());
		Point3d pt = mapParent.getPoint3d("ptPlanAnnotationRef");
		if (_Map.hasPoint3d("ptBase"))
		{
			pt = _Map.getPoint3d("ptBase");//Version 12.3: make sure the selected point is kept
			_Map.removeAt("ptBase",true);
		}
		_Pt0 = pt;//pt.vis(2);	
	}	

// assignment
	if (_Element.length()<1) _Element.append(tslParent.element());	
	if (_Element.length()>0)	assignToElementGroup(_Element[0], true,0, 'E');
	else	assignToGroups(tslParent,'E');	
	if (_Element.length()<1)
	{
		eraseInstance();
		return;	
	}
	
	Element el = _Element[0];
	Vector3d vecX = el.vecX();
	Vector3d vecY = el.vecY();
	Vector3d vecZ = el.vecZ();	
	
// set electrical plan display
	if (bHasPlanElectricalDisp)
	{
		dpPlanElectrical.dimStyle(sDimStyle);
		dpPlanElectrical.textHeight(dTxtH);	
		dpPlanElectrical.elemZone(el,0,'I');
		dpPlanElectrical.addViewDirection(vecY);
		dpPlanElectrical.showInDispRep(sDispRepElectrical);
	}

	if (_kNameLastChangedProp=="_Pt0")
	{
		setExecutionLoops(2);
	
	// moving the plan annotation needs to update the stored offset in order that the annotation would follow the grip of the combination
		if (mapParent.hasPoint3d("PtG0") && nMode==1)
		{
			mapParent.setVector3d("vecAnnotation",_Pt0-mapParent.getPoint3d("PtG0"));
			tslParent.setMap(mapParent);
			tslParent.recalc();		
		}	
	
	// moving the element annotation needs to update the stored offset in order that the annotation would follow origin of the combination
		if (nMode==2)
		{
			mapParent.setVector3d("vecAnnotationElement",_Pt0-tslParent.ptOrg() );
			tslParent.setMap(mapParent);
			tslParent.recalc();		
		}	
	}		

// vecs

	
// the reading vectors
	Vector3d vzE = mapParent.getVector3d("vzE");
	Vector3d vxRead = mapParent.getVector3d("vxE");
	Vector3d vyRead = vzE;
	if (nMode==1)
	{
		if (vxRead.isParallelTo(_YW) && _YW.dotProduct(vxRead)<0)		vxRead*=-1;	
		else if (vxRead.isParallelTo(_XW) && _XW.dotProduct(vxRead)<0)			vxRead*=-1;
		vyRead = vxRead.crossProduct(-_ZW);
	}
	else if (nMode==2)
	{
		vxRead = vecX;		
		vyRead = vecY;
	}
	vxRead.normalize();
	vyRead.normalize();
	
	Vector3d vzRead = vxRead.crossProduct(vyRead);

// the displays		
	Display dpPlanMillimeter(nColor),dpPlanMeter(nColor),dpPlanAP(nColor),dpElement(nColor);
	dpPlanMillimeter.dimStyle(sDimStyle);dpPlanMillimeter.textHeight(dTxtH);	dpPlanMillimeter.elemZone(el,0,'I');	
	dpPlanMeter.dimStyle(sDimStyle);		dpPlanMeter.textHeight(dTxtH);
	dpPlanAP.dimStyle(sDimStyle);			dpPlanAP.textHeight(dTxtH);				dpPlanAP.elemZone(el,0,'I');
	dpElement.dimStyle(sDimStyle);		dpElement.textHeight(dTxtH);				dpElement.elemZone(el,nZone,'I');
	
	if (nMode==1)
	{
		dpPlanMillimeter.addViewDirection(vecY);	
		dpPlanMeter.addViewDirection(vecY);
		if (nProjectSpecial==1)
		{
			dpPlanMillimeter.showInDispRep("LUX AV");
			dpPlanMeter.showInDispRep("LUX AP");
		}
	}		
	else if (nMode==2)
	{
		dpPlanMeter.addHideDirection(vecY);
		dpPlanMillimeter.addHideDirection(vecY);
	}

	PLine plFrame = mapParent.getPLine("plFrame");
	if (nMode==2)	
		plFrame= mapParent.getPLine("plNN");
	//plFrame.vis(2);

	
// get start and end point of leader
	LineSeg seg = PlaneProfile(plFrame).extentInDir(_XW);

// reposition _Pt0 if forced by parent
	if (nMode==1 && _Map.getInt("flipSide"))
	{
		Point3d pts[] = el.plOutlineWall().vertexPoints(true);
		Point3d ptMid;
		ptMid.setToAverage(pts);
	// mirror to opposite side		
		_Pt0.transformBy(vzE*_Map.getDouble("dZLeader")*2);
		//reportMessage("\nreposition _Pt0 if forced by parent " + tslParent.propDouble(0) + " handle " + _ThisInst.handle());
		_Map.removeAt("flipSide",true);
	}

	Vector3d vxLeader = _Pt0-seg.ptMid();
	if (nMode==2)
	{
		_Pt0.transformBy(vecZ*vecZ.dotProduct(tslParent.ptOrg()-_Pt0));
		vxLeader = _Pt0-tslParent.ptOrg();
	}
	
// store relative base point location
	if (_Element.length()>0)
	{
		Point3d pts[] = _Element[0].plOutlineWall().vertexPoints(true);
		Point3d ptMid;
		ptMid.setToAverage(pts);
		_Map.setDouble("dZLeader",vzE.dotProduct(_Pt0-ptMid));
		dpElement.addViewDirection(vzE); // 15.2
	}
		
		
	vxLeader.normalize();
	Vector3d vyLeader = vxLeader.crossProduct(-vzRead);
	vyLeader.normalize();
	Point3d ptInt[] = Line(_Pt0,-vxLeader).orderPoints(plFrame.intersectPoints(Plane(seg.ptMid(),vyLeader)));
//	vxLeader.vis(_Pt0,1);
//	vyLeader.vis(_Pt0,4);
//
//	vxRead.vis(_Pt0,1);
//	vyRead.vis(_Pt0,3);
	

	Point3d ptStart;
	if (ptInt.length()>0)
	{
		ptStart = ptInt[0];	
	}	
	else
	{
		ptStart = plFrame.closestPointTo(_Pt0);
	}
	
// the ref point
	Point3d ptRefAnno = _Pt0;
	ptRefAnno.transformBy(vzRead *vzRead.dotProduct(ptStart-ptRefAnno));
	Point3d ptEnd=ptRefAnno;
//	ptEnd.vis(4);ptStart.vis(4);
	
// get offset flags
	Vector3d vecOffset = ptEnd-ptStart;
	double dOffset = vecOffset.length();
	vecOffset.normalize();
	//vecOffset.vis(_Pt0 ,1);
	
	double dXFlag=1.2;
	double dYFlag=1.2;
	if (vxRead.dotProduct(_Pt0-seg.ptMid())<0)dXFlag*=-1;
	if (vyRead.dotProduct(_Pt0-seg.ptMid())<0)dYFlag*=-1;

// collect strings to be displayed
	String sArTxtMM[0],sArTxtM[0];
	if (nMode==1)
	{
		sArTxtMM.append(mapParent .getString("ElevationTextMM"));	
		sArTxtM.append(mapParent.getString("ElevationTextM"));	
	}
	else
	{
		sArTxtMM.append(mapParent.getString("ElevationTextElement1"));	
		sArTxtM.append(mapParent.getString("ElevationTextElement1"));	
		String s = mapParent.getString("ElevationTextElement2");
		if (s.length()>0)
		{
			sArTxtMM.append(s);	
			sArTxtM.append(s);				
		}
	}
	
		
	
// parent desc
	String s;
	s = tslParent.propString(3);
	if (s.length()>0)	
	{
		sArTxtMM.append(s);
		sArTxtM.append(s);		
	}
	s = tslParent.propString(4);
	if (s.length()>0)
	{
		sArTxtMM.append(s);
		sArTxtM.append(s);		
	}

// extra desc
	s = sDesc1;
	if (s.length()>0)
	{
		sArTxtMM.append(s);
		sArTxtM.append(s);		
	}
	s = sDesc2;
	if (s.length()>0)
	{
		sArTxtMM.append(s);
		sArTxtM.append(s);		
	}
	
	Point3d ptTxt =ptRefAnno ;
	//if (nSgnY>0)ptTxt=_Pt0+_YW*sArTxtMM.length()*dTxtH;
	PlaneProfile ppDp;
	for (int i=0;i<sArTxtMM.length();i++)
	{	
		double dX = dpPlanMillimeter.textLengthForStyle(sArTxtMM[i],sDimStyle)*.7;
		
		LineSeg seg(ptTxt-vxRead*dX-vyRead*.7*dTxtH,ptTxt+vxRead*dX+vyRead*.7*dTxtH);
		//seg.vis(3);
		PLine pl;
		pl.createRectangle(seg,vxRead,vyRead);
		if (ppDp.area()<pow(dEps,2))
			ppDp=PlaneProfile(pl);
		else
			ppDp.joinRing(pl,_kAdd);

		if (bHasPlanElectricalDisp)
			dpPlanElectrical.draw(sArTxtMM[i],ptTxt,vxRead, vyRead,dXFlag  ,0);
		
		dpPlanMillimeter.draw(sArTxtMM[i],ptTxt,vxRead, vyRead,dXFlag  ,0);	
		if(nProjectSpecial==1)
		{			
			dpPlanMeter.draw(sArTxtM[i],ptTxt,vxRead, vyRead,dXFlag  ,0);
		}
		
		//if (!vzE.isCodirectionalTo(vecZ))
			dpElement.draw(sArTxtMM[i],ptTxt,vxRead, vyRead,dXFlag ,0, _kDevice);

		
		
		ptTxt.transformBy(-vyRead*dTxtH*1.2);
	}	

// preset leader trigger
	//if (nProjectSpecial==1 && !_Map.hasInt("showLeader"))	
	//	_Map.setInt("showLeader",true);
	int bShowLeader =_Map.getInt("showLeader");
	
// leader trigger	
	String sLeaderTrigger = T("|Hide Leader|");
	if (!bShowLeader)sLeaderTrigger = T("|Show Leader|");
	addRecalcTrigger(_kContext, sLeaderTrigger );// a annotation trigger	
	if (_bOnRecalc && _kExecuteKey==sLeaderTrigger)
	{
		if(bShowLeader)bShowLeader=false;
		else bShowLeader=true;
		_Map.setInt("showLeader",bShowLeader);
		setExecutionLoops(2);
	}

// draw the leader line if not pretty short
// snap end point of leader	
	if (bShowLeader)
	{
		PLine plRings[]=ppDp.allRings();
		int bIsOp[]=ppDp.ringIsOpening();
		PLine pl;
		for (int r=0;r<plRings.length();r++)
			if (!bIsOp[r] && pl.area()<plRings[r].area())
				pl = plRings[r];
		//pl.vis();
		
		if (nMode==1)
		{
			ptInt = Line(_Pt0,vxLeader).orderPoints(pl.intersectPoints(Plane(seg.ptMid(),vyLeader)));
			if (ptInt.length()>0)
				ptEnd = ptInt[0];
		}
		else
		{
			ptStart = tslParent.ptOrg();
			ptEnd = ptRefAnno -vxLeader*.5*dTxtH;
		}
		
		PLine plLeader(ptStart,ptEnd);
		if (plLeader.length()>dTxtH*2)
		{
			dpPlanMillimeter.draw(plLeader);
			dpPlanElectrical.draw(plLeader);	
		}
	}
	
	}	
// END ANNOTATION MODE___________________________________________________________________________________________________________________________________

		
//End Annotation mode//endregion 


//
// write InternalMapx
Map mapXtsl;
mapXtsl.setString("ID", _ThisInst.handle());
_ThisInst.setSubMapX("InternalMapX",mapXtsl);


{ 

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
reportMessage("\n" + + " length = "+ mapSetting.length());				
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


}


















#End
#BeginThumbnail
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
M,,$`@]0:/K$P>'@?*4%O<7,BQ002R2'HJ*237H?A/X6ZK+?VU_JQ%G#$XD$6
M<R-@Y`]!7M"0Q1G*1HI]54"GT2KMJR%'#I.["BBBL#H"BBB@`HHHH`****`"
MBBB@`J&XM;>[B,5S!'-&>JR*"/UJ:B@"O96-KIULMO:0)#"I)"(,#FK%%%&P
M'+>-O#-SXEL;6&UEACDAEWDR9Y&,<8KCX?A)?.<SZI;ID?P(6Y_'%>LT5E*C
M";NS:%><%RQ."TWX5:1:LKWL\UVPZK]Q?TY_6NPL-)T_2X_+L;.&W7H=BX)^
MIZFKM%5&G&/PHB52<_B844459`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%)VH`6BJ<VI65M?VMA+<QK=W6[R82?F?:"2
M0/0`=:N4`%%%%`!1110`44E5;'4K+4TF>QN8[A(93"[1G(#@#(S[9%`%NBBB
M@`HHHH`****`"BBB@`HHHH`**:S+&A9V"J!DDG@4D<B2Q+)&=R,,J?44`/HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HH[5QGCCQ5_95L=/LI/]-E7YV'_+)3_4]OS]*RK5HT8.<C?#X>>(J*G#=D
M.O?$*/3=1DL[&V2Y\OAY"^!N[@8ZXKGKWXIZI#"T@MK.-1T^5B?YURMI:SWM
MU';6T;232-A5'4FN:UG[3'J<]I<(8WMY&C*'L0<&O"ABL36DW>R_K0^NIY9@
MZ:4'%.7G^9]#>"/$#^)?#$%_,4^T[WCF"#`#`\?^.E3^-:>MW4MEH&HW<!"S
M06LLB$C.&521_*O*?@OJ_E:A?:.[?+,@GB!_O+PWY@C_`+YKU'Q-_P`BIK'_
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
DYL-=U3:MRJ*BG(!*@#\N:Z2SA:WLH(&(+1QA21TX%6**`/_9
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
        <int nm="BreakPoint" vl="4584" />
        <int nm="BreakPoint" vl="4538" />
        <int nm="BreakPoint" vl="4687" />
        <int nm="BreakPoint" vl="4626" />
        <int nm="BreakPoint" vl="4191" />
        <int nm="BreakPoint" vl="4172" />
        <int nm="BreakPoint" vl="445" />
        <int nm="BreakPoint" vl="4340" />
        <int nm="BreakPoint" vl="3896" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23569: Add trigger to control &quot;SupressCnCElementTooling&quot;" />
      <int nm="MajorVersion" vl="18" />
      <int nm="MinorVersion" vl="13" />
      <str nm="Date" vl="8/13/2025 4:34:07 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23569: Add xml flag &quot;SupressCnCElementTooling&quot; to supress element CNC tools" />
      <int nm="MajorVersion" vl="18" />
      <int nm="MinorVersion" vl="12" />
      <str nm="Date" vl="8/13/2025 11:32:02 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23057: Write TSL handle/ID as second position in hardware notes" />
      <int nm="MajorVersion" vl="18" />
      <int nm="MinorVersion" vl="11" />
      <str nm="Date" vl="11/26/2024 4:31:41 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22549: Check body operation on genbeam" />
      <int nm="MajorVersion" vl="18" />
      <int nm="MinorVersion" vl="10" />
      <str nm="Date" vl="8/27/2024 3:10:46 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21887: Fix when calculating pline path vor vertical alignment; For Rubner use catalog &quot;Vorgabe&quot; when creating hsbInstallationPoint" />
      <int nm="MajorVersion" vl="18" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="4/16/2024 1:20:03 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21736: Create new referece to wall after 2 walls are joined" />
      <int nm="MajorVersion" vl="18" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="3/22/2024 5:15:45 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21220: Add strategy to mill by destroying all; not only the path" />
      <int nm="MajorVersion" vl="18" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="1/25/2024 5:54:06 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21220: Add parameter MaxWidthForClosedMill for closed/open mill" />
      <int nm="MajorVersion" vl="18" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="1/24/2024 12:11:03 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15727 minor reporting issue corrected" />
      <int nm="MajorVersion" vl="18" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="10/7/2022 2:20:41 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11557 bugfix text positioning" />
      <int nm="MajorVersion" vl="18" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="4/22/2021 3:51:29 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11557 new optional parameter Combination\Text\PlanAnnotationOffset to overwrite plan text location, new context commands to export and import settings" />
      <int nm="MajorVersion" vl="18" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="4/14/2021 4:00:29 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-10560 included in standard update procedure, no more custom dll maintenance required. V23 or higher required" />
      <int nm="MajorVersion" vl="18" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="2/8/2021 10:07:35 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End