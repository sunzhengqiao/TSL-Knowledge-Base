#Version 8
#BeginDescription
#Versions
Version 13.8 07.02.2025 HSB-22947: Fix "ProjectSpecial" , Author: Marsel Nakuci
Version 13.7 04.02.2025 HSB-22947: Chek when beamcuts share same face , Author: Marsel Nakuci
Version 13.6 15.11.2024 #DEV: 20241115: Optimise code avoid if possible envelopeBody and shadowProfile , Author Marsel Nakuci
13.5 27.03.2024 HSB-21736: Make sure the quader of element is not 0 Author: Marsel Nakuci
13.4 22.03.2024 HSB-21736: Create new referece to wall after 2 walls are joined 
13.3 11.07.2023 HSB-19502: Extend xml file to support skewed milling at bottom plate 
13.2 13.06.2023 HSB-19168: cleanup pline from Raum TSL
Version 13.1    26.01.2023    HSB-17706 special tool width override for headers exceeding specified dimensions
Version 13.0    07.10.2022    HSB-15727 bugfix on subsequent creation of multiple instances by cloning tsls
Version 12.9    18.05.2021    HSB-11911 translation issue fixed for bottom and top mill
Version 12.8    09.02.2021    HSB-10673 Offset value controlls the offset of the tooling
Version 12.7    08.02.2021    HSB-10560 included in standard update procedure, no more custom dll maintenance required. Requires V23 or higher

HSB-7350 individual room assignment considers rooms not embraced by walls 
HSB-6008 Room / Exterior Assignment enhanced
HSB-6006 Alignment bottom/top also with no combinations supported


Dieses TSL definiert einen Installationspunkt und die zugehörigen Kombinationen




















#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 13
#MinorVersion 8
#KeyWords Installation,Point,Electro
#BeginContents
//region Part 1
		
//region History
/// History
/// <summary Lang=de>
/// Dieses TSL definiert einen Installationspunkt und die zugehörigen Kombinationen
/// </summary>

/// <summary Lang=en>
/// This TSL creates an installation point with its combinations
/// </summary>

/// <remark Lang=de>
/// Bitte beachten Sie die Dokumentation zu dieser Funktion.
/// </remark>

/// <remark Lang=de>
/// Dieses TSL ist nur unter bestimmten Konfigurationsvorraussetzungen lauffähig
/// 	- benötigt Blockdefinitionen in Unterverzeichnissen im Verzzeichnis <hsbCompany>\Block\Electrical
///	- hsb-E-Combination.mcr
///	- <hsbCAD>\utilities\ElectraTsl\hsbElectricalTsl.dll
/// </remark>
// #Versions
// 13.8 07.02.2025 HSB-22947: Fix "ProjectSpecial" , Author: Marsel Nakuci
// 13.7 04.02.2025 HSB-22947: Chek when beamcuts share same face , Author: Marsel Nakuci
// 13.6 15.11.2024 #DEV: 20241115: Optimise code avoid if possible envelopeBody and shadowProfile , Author Marsel Nakuci
// 13.5 27.03.2024 HSB-21736: Make sure the quader of element is not 0 Author: Marsel Nakuci
// 13.4 22.03.2024 HSB-21736: Create new referece to wall after 2 walls are joined Author: Marsel Nakuci
// 13.3 11.07.2023 HSB-19502: Extend xml file to support skewed milling at bottom plate  Author: Marsel Nakuci
// 13.2 13.06.2023 HSB-19168: cleanup pline from Raum TSL Author: Marsel Nakuci
// 13.1 26.01.2023 HSB-17706 special tool width override for headers exceeding specified dimensions , Author Thorsten Huck
// 13.0 07.10.2022 HSB-15727 bugfix on subsequent creation of multiple instances by cloning tsls , Author Thorsten Huck
// 12.9 18.05.2021 HSB-11911 translation issue fixed for bottom and top mill , Author Thorsten Huck
// 12.8 09.02.2021 HSB-10673 Offset value controlls the offset of the tooling , Author Thorsten Huck
// 12.7 08.02.2021 HSB-10560 included in standard update procedure, no more custom dll maintenance required. Requires V23 or higher , Author Thorsten Huck
///<version value="12.8" date="09feb21" author="marsel.nakuci@hsbcad.com" HSB-10673: Offset value controlls the offset of the tooling </version>
///<version value="12.6" date="16jun20" author="thorsten.huck@hsbcad.com" HSB-7924 new context menu command 'Set floor thickness' if no room is associated. </version>
///<version value="12.5" date="21apr20" author="thorsten.huck@hsbcad.com" HSB-7350 individual room assignment considers rooms not embraced by walls </version>
///<version value="12.4" date="21apr20" author="thorsten.huck@hsbcad.com" HSB-7350 individual room assignment considers rooms not embraced by walls </version>
///<version value="12.3" date=21nov19" author="thorsten.huck@hsbcad.com"> HSB-6008 Room / Exterior Assignment enhanced </version>
///<version value="12.2" date=21nov19" author="thorsten.huck@hsbcad.com"> HSB-6006 Alignment bottom/top also with no combinations supported </version>
///<version value="12.1" date=11mar19" author="thorsten.huck@hsbcad.com"> Der neue Parameter 'InstallationPoint\UseGenbeamReference' = 1 projiziert den Referenzpunkt auf die Umhüllung der betroffenen Bauteile und ermöglicht so die Berücksichrtigung variabler Wandstärken </version>
///<version value="12.0" date=26feb19" author="thorsten.huck@hsbcad.com"> Die Ausrichtung der Kombinationen ist nun abhängig von der Seite des Symbolgriffes </version>
///<version value="11.9" date=19feb19" author="thorsten.huck@hsbcad.com"> Vorgabe-Speicherort der Konfigurationsdatei ist nun <company>\tsl\settings  </version>
///<version value="11.8" date=20dec18" author="thorsten.huck@hsbcad.com"> benutzerdefinierter Versatz von Wänden zur Etagenhöhe wird berücksichtigt </version>
///<version value="11.7" date=07dec18" author="thorsten.huck@hsbcad.com"> bugfix Ausfräsungen unten/oben bei Kabelkanalversatz </version>
///<version value="11.6" date=08feb18" author="thorsten.huck@hsbcad.com"> Bearbeitungsseite Ausfräsungen unten/oben korrigiert  </version>
///<version value="11.5" date="31aug17" author="thorsten.huck@hsbcad.com"> neue Parameter der Einstellungen unterstützen die Platzierung von Zugdosen am unteren bzw. oberen Auslass des Kabelkanals </version>
///<version value="11.4" date="10aug17" author="thorsten.huck@hsbcad.com"> Hardware Export Conduits added </version>
///<version value="11.3" date="24feb17" author="thorsten.huck@hsbcad.com"> bugfix 'WirechaseNoNail' = 2 </version>
///<version value="11.2" date="24feb17" author="thorsten.huck@hsbcad.com"> Sammlung relevanter Bauteile verbessert </version>
///<version value="11.1" date="09feb17" author="thorsten.huck@hsbcad.com"> benutzerdefinierte Ausgabe Zeitmanagement Leitungslängen, Parameter zur Sperrflächenberechnung 'WirechaseNoNail' erweitert: 2 = Iconseite nur horizontale Balken, Gegenseite alle Balken </version>
///<version value="11.0" date="10nov16" author="thorsten.huck@hsbcad.com"> neuer Parameter 'ConduitExtraWidth' erhöht die Breite der Fräsungen </version>
///<version value="10.9" date="01aug16" author="thorsten.huck@hsbcad.com"> Ausfräsungen bei horizontal versetzen Kombinationen werden nun ausgeführt </version>
///<version value="10.8" date="05jul16" author="thorsten.huck@hsbcad.com"> neue Einstellung um Elementbeschriftung in Zone 0 zu zeichnen </version>
///<version value="10.7" date="04jul16" author="thorsten.huck@hsbcad.com"> die Länge horizontaler Sperrflächen bei versetzen Kombinationen wird genauer berechnet, Installationspunkte am Rand eines Elementes verursachen keinen Fehler </version>
///<version value="10.6" date="31mar16" author="thorsten.huck@hsbcad.com"> Raumzuordnung wird validiert </version>
///<version value="10.5" date="16dec15" author="thorsten.huck@hsbcad.com"> neue Einstellungsmöglichkeiten verschiedener Darstellungskomponenten, Vorgabeeinstellungen können über neuen Kontextbefehl exportiert werden </version>
///<version value="10.4" date="14oct15" author="thorsten.huck@hsbcad.com"> exterene Konfigurationsdatei: neuer Parameter 'ExtentWirechaseOffset' ergänzt: ist die Option 'ExtentWirechase' aktiviert, so wird der Leitungskanal um diesen Wert verlängert. </version>
///<version value="10.3" date="14oct15" author="thorsten.huck@hsbcad.com"> exterene Konfigurationsdatei: neuer Parameter 'ExtentWirechase' eingefügt. Ist diese Option aktiviert, so wird der Leitungskanal vollständig durch die letzte Kombination gefräst. </version>
///<version value="10.2" date="25sep15" author="th@hsbCAD.de"> bugfix Kontakterkennung ohne Kabelschacht, automatisches Update der Objektreferenzen </version>
///<version value="10.1" date="24sep15" author="th@hsbCAD.de"> die Abhängigkeiten zu den Platten des Elementes wurden zur Leistungssteigerung deutlich reduziert </version>
///<version value="10.0" date="17sep15" author="th@hsbCAD.de"> es ist nun möglich die 3.Gruppenebene bei einer optionalen Zusatzgruppe zu definieren, vergl. Dokumentation </version>
///<version value="9.9" date="26jun15" author="th@hsbCAD.de"> Installationspunkte ohne Kombinationen platieren beim EInfügen die Leitungssymbole mittig </version>
///<version value="9.8" date="29may15" author="th@hsbCAD.de"> das Installationspunkt basierte Einfügen von Kombinationen mit erweiterten Blockdaten wurde unter bestimmten Voraussetzungen nicht ausgeführt. Dies ist nun behoben. </version>
///<version value="9.7" date="29may15" author="th@hsbCAD.de"> kleine Änderung des Kontextbefehl-Layouts </version>
///<version value="9.6" date="28may15" author="th@hsbCAD.de"> neuer Kontextbefehl zur Überschreibung des Symbolabstandes in der Planansicht </version>
///<version value="9.5" date="28may15" author="th@hsbCAD.de"> Extrempunkte des Kabelkanals werden für die Kollisionskontrolle tiefer Dosen veröffentlicht </version>
///<version value="9.4" date="28may15" author="th@hsbCAD.de"> die Einstellungen werden nun als Kopie der externen Datei <StickframeFolder>\<scriptName>Settings.xml in der Zeichnung gespeichert. Bei Bedarf können diese Einstellungen, bzw. eine lokale Überschreibung im Zeichnungspfad durch den Kontextbefehl 'Vorgabe laden' erneut geladen werden. </version>
///<version value="9.3" date="17apr15" author="th@hsbCAD.de"> deckungsgleiche Griffe für Leitungen in der Elementansicht werden vermieden </version>
///<version value="9.2" date="23feb15" author="th@hsbCAD.de"> unterstützt variable Breiten der horizontalen Kabelkanäle </version>
///<version value="9.1" date="20nov14" author="th@hsbCAD.de"> Eigenschaften kategorisiert </version>
///<version value="9.0" date="14sep14" author="th@hsbCAD.de"> Einfügeverhalten von Installationspunkten ohne Kombinationen verbessert </version>
///<version value="8.9" date="24sep14" author="th@hsbCAD.de"> Versionskontrolle hinzugefügt um unterschiedliche Griffanzahl vornagegangener Versionen zu unterstützen </version>
///<version value="8.8" date="10sep14" author="th@hsbCAD.de"> bei horizontal versetzen Installationspunkten werden zusätzlich nur vertikale Stäbe bearbeitet, bei welchen die Bearbeitung mindestens 50% der Bauteilbreite ausmacht </version>
///<version value="8.7" date="26mai14" author="th@hsbCAD.de"> bugfix neuer Einfügemechanismus: es werden die Installationspunkte nicht doppelt eingefügt</version>
///<version value="8.6" date="23mai14" author="th@hsbCAD.de"> neuer Einfügemechanismus: Mit der gleichen Dialog- bzw. Katalogauswahl können mehrere Installationen platziert werden. Es können für die gewählte Wand mehrere Einfügepunkte gewählt werden. Anschließend können weitere Wände und deren Einfügepunkte gewählt werden bis der Benutzer die Eingabe abschließt.</version>
///<version value="8.5" date="22mai14" author="th@hsbCAD.de"> beamcuts in bottom and top plate are more tolerant to inaccuracy of beam alignment, if the length of the conduits is below 500mm the display of the amount of tubes will be suppressed</version>
///<version value="8.4" date="16mar14" author="th@hsbCAD.de"> external settings file: new parameter ConduitExtraDepth introduced. This value extends the depth of any conduit milling by the given value </version>
///<version value="8.3" date="14mar14" author="th@hsbCAD.de"> bugfix conduit grip location on inserct (custom 1) </version>
///<version value="8.2" date="13mar14" author="th@hsbCAD.de"> new custom (1) command to override the nominal diameter of conduits, elevation of 'add combination' fixed, requires hsbElectricalTsl.dll Version 1.0.1.21  </version>
///<version value="8.1" date="21feb14" author="th@hsbCAD.de"> external settings file introduced <StickframeFolder>\<scriptName>Settings.xml, Seetings may control the assignment to an additional group </version>
///<version value="8.0" date="14feb14" author="th@hsbCAD.de"> assigning the installation point to another wall releases a potential room link </version>
///<version value="7.9" date="12feb14" author="th@hsbCAD.de"> symbol realignment is triggered on flp side and flip side with combinations </version>
///<version value="7.8" date="11feb14" author="th@hsbCAD.de"> custom 0 supports vertical VDE based distribution on creation and on chaning the position index, requires hsbElectricalTsl.dll 1.0.1.20 or higher </version>
///<version value="7.7" date="11feb14" author="th@hsbCAD.de"> custom set of grips bugfixed, group assignment combinations on 'assign to wall' fixed </version>
///<version value="7.6" date="10feb14" author="th@hsbCAD.de"> custom set of grips. custom 0 supports 1 grip, custom 1 supports 3 grips and conduit display, symbol alignment enhanced, assignment on 'assign to wall' fixed</version>
///<version value="7.5" date="10oct13" author="th@hsbCAD.de"> conduit tooling corrected for wirechases without childs, room links are not copied when copying the installation </version>
///<version value="7.4" date="10oct13" author="th@hsbCAD.de"> conduit grip location set to middle of conduit length, linetypes custom specific, default = HIDDEN </version>
///<version value="7.3" date="24sep13" author="th@hsbCAD.de"> 'flip side and combinations' bugfix </version>
///<version value="7.2" date="24sep13" author="th@hsbCAD.de"> 'copy installation' bugfix </version>
///<version value="7.1" date="24sep13" author="th@hsbCAD.de"> remote combination relocation corretcted </version>
///<version value="7.0" date="23sep13" author="th@hsbCAD.de"> 'copy installation' considers flipped combinations</version>
///<version value="6.9" date="18sep13" author="th@hsbCAD.de"> default display line in plan view extended, if no wirechases are selected a short line will be displayed in elementview</version>
///<version value="6.8" date="31jul13" author="th@hsbCAD.de"> multiple rooms report number, name and group assignment </version>
///<version value="6.7" date="31jul13" author="th@hsbCAD.de"> automatic room assignment enhanced: room height derived from extremes of floor and ceiling display (requires components to be displayed) </version>
///<version value="6.6" date="30jul13" author="th@hsbCAD.de"> no automatic room assignment if multiple rooms are detected. user will be informed to append manually </version>
///<version value="6.5" date="30jul13" author="th@hsbCAD.de"> bugfix release room, introduced with 4.3 </version>
///<version value="6.4" date="29jul13" author="th@hsbCAD.de"> automatic room detection (type AecSpace) if the room is assigned to a 3rd level group containing the name 'Räume' or 'Room' </version>
///<version value="6.3" date="29jul13" author="th@hsbCAD.de"> custom group assignment introduced with version 2.7 is now depreciated </version>
///<version value="6.2" date="25jul13" author="th@hsbCAD.de"> conduit grips follow the relocation of the installation when moving via reference grip </version>
///<version value="6.1" date="12jun13" author="th@hsbCAD.de"> bugfix conduits with no combinations start/end point</version>
///<version value="6.0" date="12jun13" author="th@hsbCAD.de"> automatic Window detection for installations without combinations. the conduits will end below or above an opening repecting the selected direction. bugfix for additional top tooling</version>
///<version value="5.9" date="26jun13" author="th@hsbCAD.de"> the grid line of the installation is drawn with a default length, when a wall type does not have sheeting zones </version>
///<version value="5.8" date="25jun13" author="th@hsbCAD.de"> Custom 0: conduit pline will be also displayed if milling depth <=0 </version>
///<version value="5.7" date="25jun13" author="th@hsbCAD.de"> copy to new wall fixed, add new combination fixed </version>
///<version value="5.6" date="24jun13" author="th@hsbCAD.de"> instance color is only controlled for custom 1,  dummies are no longer used to receive toolings </version>
///<version value="5.5" date="20jun13" author="th@hsbCAD.de"> bugfix new properties to control additional sheeting cutouts on bottom and/or top </version>
///<version value="5.4" date="20jun13" author="th@hsbCAD.de"> new properties to control additional sheeting cutouts on bottom and/or top </version>
///<version value="5.3" date="14jun13" author="th@hsbCAD.de"> Custom 1: default color oppoiste changed to magenta (6)</version>
///<version value="5.2" date="28may13" author="th@hsbCAD.de"> bugFix context entries </version>
///<version  value="5.1" date="16may13" author="th@hsbCAD.de"> bugFix streaming the realbody of intersecting entities </version>
///<version  value="5.0" date="30apr13" author="th@hsbCAD.de"> Extra Tool Offset supported when installation is dragged and associated combination has corresponding property enabled</version>
///<version  value="4.9" date="26apr13" author="th@hsbCAD.de"> Custom (Lux) default height 1300 added, Grip of wirechase description text will not be relocated on recalc</version>
///<version  value="4.8" date="22apr13" author="th@hsbCAD.de"> instance color is controlled by wirechase millings, on icon side =3, opposite = 4, both sides = byBlock </version>
///<version  value="4.7" date="22apr13" author="th@hsbCAD.de"> new custom display of noNail areas: no nail areas are only generated in zone 1 and -1. Zone 1 is considering only intersections with horizontal beams </version>
///<version  value="4.6" date="12apr13" author="th@hsbCAD.de"> bugfix sorting combinations during insert </version>
///<version  value="4.5" date="03apr13" author="th@hsbCAD.de"> if the instance is inserted with a catalog entry it does not overwrite this entry anymore</version>
///<version  value="4.4" date="07mar13" author="th@hsbCAD.de"> double click action key renamed to 'TslDoubleClick'. double click action is now part of contentDACH</version>
///<version  value="4.3" date="28feb13" author="th@hsbCAD.de"> new context command to sort wirechase symbols, symbols will be sorted during insert</version>
///<version  value="4.2" date="28feb13" author="th@hsbCAD.de"> wirechases can be inserted without any combinations if alignment is set to 'both'</version>
///<version  value="4.1" date="26feb13" author="th@hsbCAD.de"> custom display: the conduit plan view and the conduit guide lines are deactivated by default. if the wirechase is moved horizontal wirechases are also added when no conduits are selected</version>
///<version  value="4.0" date="14feb13" author="th@hsbCAD.de"> custom command move installation renamed to move wirechase. it will not move the installation itself but only the toolings and the display of the wirechase. horizontal wirechases to the combination are automatically added. This functionality can also be acced by a grip</version>
///<version  value="3.9" date="14feb13" author="th@hsbCAD.de"> bugfix for custom inverted sorting of combinations, wirechases reference the correct combination</version>
///<version  value="3.8" date="31jan13" author="th@hsbCAD.de"> bugfix</version>
///<version  value="3.7" date="28jan13" author="th@hsbCAD.de"> contour detection of zone 0 enhanced for walls with sloped beams and birdsmouth connection</version>
///<version  value="3.6" date="14dec12" author="th@hsbCAD.de"> if no catalog entries exist the first call will now write the _Default and the _LastInserted entry</version>
///<version  value="3.5" date="16nov12" author="th@hsbCAD.de"> new custom command: move installation installation. This command moves the installation by a given value and leaves the attached combinations at their locations, new custom plan placement: highest combination will placed closest to the wall</version>
///<version  value="3.4" date="15nov12" author="th@hsbCAD.de"> installation displays correct after insert without recalc</version>
///<version  value="3.3" date="13nov12" author="th@hsbCAD.de"> bugfix wirechase at gable walls with straight studs</version>
///<version  value="3.2" date="02oct12" author="th@hsbCAD.de"> group assignment after wall split fixed</version>
///<version  value="3.1" date="02oct12" author="th@hsbCAD.de"> bugfix wirechase milling ind default mode</version>
///<version  value="3.0" date="28sep12" author="th@hsbCAD.de"> flip side enhanced, new option to flip with combinations, combinations keep alignment when flipping by inverting the position index</version>
///<version  value="2.9" date="21sep12" author="th@hsbCAD.de"> when adding an combination one can override the default height from the dialogby optional point selection, bugfix milling depth when insertion side is opposite icon</version>
///<version  value="2.8" date="20sep12" author="th@hsbCAD.de"> custom project data import enhanced</version>
///<version  value="2.7" date="06aug12" author="th@hsbCAD.de"> custom group assignment if a group containing the string 'Elektro' exists in same level</version>
///<version  value="2.6" date="02aug12" author="th@hsbCAD.de"> behaviour on the event of wall split enhanced</version>
///<version  value="2.5" date="30jul12" author="th@hsbCAD.de"> bugfix double click action</version>
///<version  value="2.4" date="19jul12" author="th@hsbCAD.de"> custom wirechase milling location</version>
///<version  value="2.3" date="19jul12" author="th@hsbCAD.de"> dialog extended, double click action added</version>
///<version  value="2.2" date="18jul12" author="th@hsbCAD.de"> dialog extended</version>
///<version  value="2.1" date="12jul12" author="th@hsbCAD.de"> custom default installation heights extended, custom display of tube diameter, command to add combinations prepared</version>
///<version  value="2.0" date="05jul12" author="th@hsbCAD.de"> room data transfer to combination tsl enhanced and redesigned</version>
///<version  value="1.9" date="22jun12" author="th@hsbCAD.de"> new custom display configuration support enables two different displays</version>
///<version  value="1.8" date="25may12" author="th@hsbCAD.de"> beam tools are added also for far away horizontally offseted combinations, AEC Space relation corrected</version>
///<version  value="1.7" date="24may12" author="th@hsbCAD.de"> preview pline unconstructed element deactivated, catalog based insertion without dialog</version>
///<version  value="1.6" date="15may12" author="th@hsbCAD.de"> debug fixes II</version>
///<version  value="1.5" date="09may12" author="th@hsbCAD.de"> debug fixes</version>
///<version  value="1.4" date="04may12" author="th@hsbCAD.de"> floor height will be collected from external xml file if no room (AEC or TSL) could be found</version>
///<version  value="1.3" date="03may12" author="th@hsbCAD.de"> display enhanced, cancel bugfix</version>
///<version  value="1.2" date="02may12" author="th@hsbCAD.de"> debug messages deactivated</version>
///<version  value="1.1" date="02may12" author="th@hsbCAD.de"> bugfix assembly path</version>
///<version  value="1.0" date="20apr12" author="th@hsbCAD.de"> initial</version>		


//End History//endregion  

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbInstallationPoint")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Flip Side|") (_TM "|Select installation|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Flip Side Combinations|") (_TM "|Select installation|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Assign to Wall|") (_TM "|Select installation|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Copy Installation|") (_TM "|Select installation|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Move Wirechase|") (_TM "|Select installation|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Combination|") (_TM "|Select installation|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Align Combination Symbols|") (_TM "|Select installation|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Edit plan view symbol offset|") (_TM "|Select installation|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Override Conduit Diameter|") (_TM "|Select installation|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Assign to Room|") (_TM "|Select installation|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "../|Set floor thickness|") (_TM "|Select installation|"))) TSLCONTENT



// #1 combination symbol sorting
// #2 auto collect aec spaces




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
	int bIsRub=projectSpecial().find("rub",-1,false)==0;
//end constants//endregion


//region Functions

	

//region calcPpFromQuader
	PlaneProfile calcPpFromQuader(GenBeam _gb, Plane _pn)
	{ 
		// calculates the planeprofile from the
		// genbeam quader
		// we will get the rectangle pp of quader that lies 
		// in the plane
		Vector3d _vx=_pn.vecX();
		Vector3d _vy=_pn.vecY();
		Quader _qd=_gb.quader();
		
		Point3d _ptCgb=_qd.ptOrg();
		Vector3d _vxgb=_qd.vecD(_vx);
		Vector3d _vygb=_qd.vecD(_vy);
		double dXgb=_qd.dD(_vx);
		double dYgb=_qd.dD(_vy);
		
		PlaneProfile _pp(_pn);
		_pp.createRectangle(LineSeg(_ptCgb-_vxgb*.5*dXgb-_vygb*.5*dYgb,
				_ptCgb+_vxgb*.5*dXgb+_vygb*.5*dYgb),_vxgb,_vygb);
		return _pp;
	}
//End calcPpFromQuader//endregion

//region calcPpOptimised
	
	PlaneProfile calcPpOptimised(GenBeam _gb,Plane _pn)
	{ 
		PlaneProfile _pp(_pn);
		Vector3d _vx=_pn.vecX();
		Vector3d _vy=_pn.vecY();
		Vector3d _vz=_pn.vecZ();
		Beam _bm=(Beam)_gb;
		Sheet _sh=(Sheet)_gb;
		Sip _sip=(Sip)_gb;
		
		Vector3d _vxGb=_gb.vecX();
		Vector3d _vyGb=_gb.vecY();
		Vector3d _vzGb=_gb.vecZ();
		
		if(_bm.bIsValid())
		{ 
			// beam
			if(abs(abs(_vyGb.dotProduct(_vz))-1.0)<dEps || abs(abs(_vzGb.dotProduct(_vz))-1.0)<dEps)
			{ 
				// can be taken from quader
				_pp=calcPpFromQuader(_gb,_pn);
			}
			else
			{ 
				_pp=_gb.envelopeBody(true,false).shadowProfile(_pn);
			}
		}
		else if(_sh.bIsValid())
		{ 
			// sheet
			if(abs(abs(_vzGb.dotProduct(_vz))-1.0)<dEps)
			{ 
				// 
				_pp.joinRing(_sh.plEnvelope(),_kAdd);
				PLine _plOps[]=_sh.plOpenings();
				for (int o=0;o<_plOps.length();o++) 
				{ 
					_pp.joinRing(_plOps[o],_kSubtract);
				}//next o
			}
			else if(abs(abs(_vxGb.dotProduct(_vz))-1.0)<dEps || abs(abs(_vyGb.dotProduct(_vz))-1.0)<dEps)
			{ 
				_pp=calcPpFromQuader(_gb,_pn);
			}
			else
			{ 
				_pp=_gb.envelopeBody(true,false).shadowProfile(_pn);
			}
		}
		else if(_sip.bIsValid())
		{ 
			// SIP
			_pp=_gb.envelopeBody(true,false).shadowProfile(_pn);
		}
		return _pp;
	}
	
//End calcPpOptimised//endregion

//End Functions//endregion 



	int bDebugLocation=false;
	
	int nDebugTest;// = 1;
	// 1 = report appending of genBeams

	String sIntSettings[] = {"CombinationDrawFilledSymbol","CombinationTextColor","CombinationReliefMode","CreateAnnotation","CreateAnnotationElement",
		"DrawRoomAlert","DrawPlanConduits","DrawDrillGuideLine","DrawWirechaseOutline","ExtentWirechase",
		"IconSideColor","OppositeSideColor","VDEAlignment", "WirechaseNoNail", "CombinationDrawElevationElementView"};
	String sStringSettings[] = {"Group","GroupElement"};
	String sDoubleSettings[] = {"CombinationExtraDiameterBeamInterference","CombinationReliefDepth","CombinationReliefHeight","CombinationReliefHeightExtension","CombinationTextAngle",
		"CombinationTextDimStyle","CombinationTextHeight","CombinationSymbolOffsetScale","CombinationStandardDiameter","ConduitExtraDepth",
		"ConduitExtraWidth","ExtentWirechaseOffset","CombinationReliefDepthExposed"};

	String sCategoryGeo = T("|Geometry|");
	String sCategoryBlock = T("|Block|");
	String sCategoryMachining = T("|Machining|");
	String sCategoryMachiningOpp =sCategoryMachining + " " + T("|Opposite Side|");
	String sCategoryDisplay = T("|Display|");
	String sCategoryMachiningSheet = T("|Machining|") + " " + T("|Sheeting|");

	
// collect special mode
	int nProjectSpecial;
	if (projectSpecial().makeUpper().find("LUX",0)>-1)
		nProjectSpecial=1;
	_Map.setInt("modeSpecial",nProjectSpecial);

	int nArTubes[] = {0,1,2,3,4,5,6,7,8,9,10};
	double dMinMillWidth = U(50);

	String strAssemblyPath = _kPathHsbInstall +"\\utilities\\electraTsl\\hsbElectraTsl.dll";
	String strType = "hsbSoft.Tsl.Electra.ElectraTsl";
	String strFunction = "ShowElectraDialog";
	String strFunctionCombination= "ShowCombinationDialog";

	String sScriptnameCombi= "hsb-E-Combination";


	String sArMill[] = {T("|None|"),T("|Bottom|"),T("|Top|"),T("|Both|")};
	String sMillThisSideName = "   " + T("|Alignment|");
	PropString sMillThisSide(0,sArMill,sMillThisSideName,3);
	sMillThisSide.setDescription(T("|Specifies the orientation of a potential frame tooling.|"));
	sMillThisSide.setCategory(sCategoryMachining);
	if (sArMill.findNoCase(sMillThisSide,-1)<0 && sArMill.findNoCase(T(sMillThisSide),-1)>-1)//HSB-11911 make sure property gets translated (english value set through dll)
	{ 
		sMillThisSide.set(T(sMillThisSide));
	}
	
	String sMillWidthThisName ="   " + T("|Width|");
	PropDouble dMillWidthThis(0,U(60),sMillWidthThisName);
	dMillWidthThis.setCategory(sCategoryMachining);
	
	String sMillDepthThisName ="   " + T("|Depth|");
	PropDouble dMillDepthThis(1,U(27),sMillDepthThisName);
	dMillDepthThis.setCategory(sCategoryMachining);
	
	String sConduitsThisName ="   " + T("|Conduits|");
	PropInt nConduitsThis(1,nArTubes,sConduitsThisName);
	nConduitsThis.setCategory(sCategoryMachining);
	
	String sMillOppositeSideName = "   " + T("|Alignment|")+ " ";
	PropString sMillOppositeSide(1,sArMill,sMillOppositeSideName ,0);
	sMillOppositeSide.setDescription(T("|Specifies the orientation of a potential frame tooling.|"));
	sMillOppositeSide.setCategory(sCategoryMachiningOpp);
	if (sArMill.findNoCase(sMillOppositeSide,-1)<0 && sArMill.findNoCase(T(sMillOppositeSide),-1)>-1)//HSB-11911 make sure property gets translated (english value set through dll)
	{ 
		sMillOppositeSide.set(T(sMillOppositeSide));
	}

	String sMillWidthOppositeName = "   " + T("|Width|")+ " ";
	PropDouble dMillWidthOpposite(2,U(60),sMillWidthOppositeName);
	dMillWidthOpposite.setCategory(sCategoryMachiningOpp);
	
	String sMillDepthOppositeName = "   " + T("|Depth|")+ " ";
	PropDouble dMillDepthOpposite(3,U(27),sMillDepthOppositeName);	
	dMillDepthOpposite.setCategory(sCategoryMachiningOpp);
	
	String sConduitsOppositeName = "   " + T("|Conduits|")+ " ";
	PropInt nConduitsOpposite(2,nArTubes,sConduitsOppositeName);
	nConduitsOpposite.setCategory(sCategoryMachiningOpp);
	
	String sDimStyleName = "   " + T("|Dimstyle|");
	PropString sDimStyle(2,_DimStyles,sDimStyleName ,0);
	sDimStyle.setCategory(sCategoryDisplay);
	sDimStyle.setCategory(sCategoryDisplay);	
	
	String sTxtHName = "   " + T("|Text Height|");
	PropDouble dTxtH(4,U(40),sTxtHName);	
	dTxtH.setDescription(T("|Overrides the text size of the selected dimstyle.|"));	
	dTxtH.setCategory(sCategoryDisplay);
	
	String sColorName = "   " + T("|Color|");
	PropInt nColor (0,1,sColorName);
	nColor.setCategory(sCategoryDisplay);


	//this property will only be used as storage for individual properties of the inserted combinations
	PropString sCombinationProps(3,"", "   "+T("|Properties|"));
	sCombinationProps.setReadOnly(!_bOnDebug);

	String sAddToolDescr = T("|Adds an extra tool at the specified location|");
	PropString sAddToolBottomIcon(4,sNoYes, "   "+ T("|bottom|"));
	sAddToolBottomIcon.setDescription(sAddToolDescr);
	sAddToolBottomIcon.setCategory(sCategoryMachiningSheet);
	
	PropString sAddToolTopIcon(5,sNoYes, "   " + T("|top|"));
	sAddToolTopIcon.setDescription(sAddToolDescr);
	sAddToolTopIcon.setCategory(sCategoryMachiningSheet);
	
	PropString sAddToolBottomOpposite(6,sNoYes, "   "+T("|Opposite Side|") + " " + T("|bottom|"));
	sAddToolBottomOpposite.setDescription(sAddToolDescr);
	sAddToolBottomOpposite.setCategory(sCategoryMachiningSheet);
		
	PropString sAddToolTopOpposite(7,sNoYes,  "   " + T("|Opposite Side|") + " " + T("|top|"));		
	sAddToolTopOpposite.setDescription(sAddToolDescr);
	sAddToolTopOpposite.setCategory(sCategoryMachiningSheet);
		
// declare default heights	
	double dDefaultHeights[] = {U(300),U(400),U(500),U(1000),U(1100),U(1200), U(1900), U(2000), U(2200), U(2550),U(2650)};
	// heights custom1
	if (nProjectSpecial==1)
	{
		double d[] = {U(0),U(300),U(1100),U(1300), U(1800),U(2230), U(3000)};
		dDefaultHeights=d;
	}
	Map mapHeights;	
	for (int i=0;i<dDefaultHeights.length();i++)
		mapHeights.appendDouble("Height",dDefaultHeights[i]);	


// declare standard linetypes
	String sLineTypeHidden = "HIDDEN";
	if (nProjectSpecial==1)sLineTypeHidden = "Gestrichelt".makeUpper();
	if (_LineTypes.find(sLineTypeHidden)<0 && _LineTypes.length()>0)
	{
		if (bDebug)reportMessage("\n" + T("|Linetype not found|") + ": " +sLineTypeHidden + " " + T("|replaced by|") + " " + _LineTypes[0]);
		sLineTypeHidden = _LineTypes[0];
	}


// declare arrays for tsl cloning
	TslInst tslNew;
	Vector3d vUcsX = _X0;
	Vector3d vUcsY = _Y0;
	GenBeam gbAr[0];
	Entity entAr[0];
	Point3d ptAr[0];
	int nArProps[0];
	double dArProps[0];
	String sArProps[0];
	Map mapTsl;	


//End Part 1//endregion

//region Part 2
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

//region on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }

	//// read settings
		Map mapIn=mapSetting; 
		//mapIn.readFromXmlFile(sSettingsPath);
		//if (mapIn.length()>0) mapSettings = mapIn;

	// make sure that catalogs do exist for the installation point and the combination 
		String sEntryNames[] = TslInst().getListOfCatalogNames(scriptName());
		if (sEntryNames.length()<1) 
		{
			setCatalogFromPropValues(T("|_LastInserted|"));
			setCatalogFromPropValues(T("|_Default|"));			
		}
		if (TslInst().getListOfCatalogNames(sScriptnameCombi).length()<1)
		{
			mapTsl.setInt("mode",-1);
			tslNew.dbCreate(sScriptnameCombi, vUcsX,vUcsY,gbAr, entAr, ptAr, 
				nArProps, dArProps, sArProps,_kModelSpace, mapTsl); // create new instance	
				if (bDebug) reportMessage("\ncreating....");
			if (tslNew.bIsValid())
			{			
				tslNew.setCatalogFromPropValues(T("|_LastInserted|"));
				tslNew.setCatalogFromPropValues(T("|_Default|"));
				tslNew.dbErase();
				if (bDebug) reportNotice("\n...erasing");
			}
		}

	// compose an empty ModelMap
		Map mapOut;	
		ModelMapComposeSettings mmComposeFlags;
		ModelMap mm;
		mm.dbComposeMap(mmComposeFlags);			
		mapIn=mm.map();
		
	// add available dimstyles
		Map mapDimStyles;
		for (int i=0;i<_DimStyles.length();i++)
			mapDimStyles.appendString("DimStyle",_DimStyles[i]);
		mapIn.setMap("DimStyle[]", mapDimStyles);		
		mapIn.setMap("Height[]", mapHeights);	
		mapIn.setMap("settings", mapSetting);
		//if (nProjectSpecial==0 || mapSettings.getInt("VDEAlignment"))mapIn.setInt("hasVDEAlignment", true);	
			
	// add catalog name for quiet insert
		String sEntryName = _kExecuteKey;
		if (sEntryName !="" && sEntryNames.find(sEntryName)>-1)
		{
		// clone the desired entry and send it to the dialog
			setPropValuesFromCatalog(sEntryName);
			setCatalogFromPropValues("_DummyEntry");
			mapIn.setString("EntryName", "_DummyEntry");
		// the dummy entry will be renamed to lastInserted, else this would delete the entry which was used as executeKey
		}
	// the model insert is only supported if the dialog is shown	
		else
			mapIn.setInt("ModelViewInsert", !_ZU.isParallelTo(_ZW));
	
	
	// call the dialog				
		mapOut = callDotNetFunction2(strAssemblyPath, strType, strFunction, mapIn);
		if (mapOut.length()<1)
		{
			eraseInstance();
			return;	
		}
		
		

	// sequential multiple element and location selection
		TslInst tslsX[0];
	
	
		PrEntity ssE(TN("|Select a wall|"), ElementWall());
		while (ssE.go() &&  ssE.elementSet().length()>0) // keep ob prompting until user has pressed <Enter>
		{
			Element elements[] = ssE.elementSet();
			
			if (elements.length()<1) 
			{
				break;
			}
			
			entAr.setLength(0);
			entAr.append(elements[0]);

			PrPoint ssP("\n"+ T("|Select insertion point|") +" ("+ elements[0].number() + ") " +", " + T("|<Enter> to continue|")); 
			while (1)
			{
				if (ssP.go()==_kOk)
				{
					Point3d pt = ssP.value();

				// send back the element link and the insertion point to form a proper modelmap	
					Map mapArg;// previously mapIn
					mapIn= mapOut;
					mapIn.setEntity("element",elements[0]);
					mapIn.setPoint3d("_Pt0",pt);		
								
				// send a flag if the insert is done in plan or modelview
				// this will display an additional toggle button and return a map entry if icon or opposite side is selected
					if (_kExecuteKey=="")
						mapIn.setInt("ModelViewInsert", _ZU.isParallelTo(_ZW));		
					mapOut = callDotNetFunction2(strAssemblyPath, strType, "AddElementToModel", mapIn);
					if (bDebug)
					{
						String strFileName = _kPathDwg + "\\" + elements[0] + "Out.dxx";		
						mapOut.writeToDxxFile(strFileName);	
					}	

			
				// interprete modelmap and resolve by handle	
					//ModelMap mm;
					mm.map() = mapOut;//_Map.getMap("Model");
					ModelMapInterpretSettings mmFlags; 
					mmFlags.resolveEntitiesByHandle(true);
					mm.dbInterpretMap(mmFlags);					
					//reportMessage("\nmodelmap is interpreted: tsls=" + mm.tslInst().length());	
					
				// collect entities
					Entity ents[] = mm.entity();
					int nNumCombinations;
					TslInst tslInstPoint;
					TslInst combinations[0];
					for (int e = 0;e<ents.length();e++)
					{
						TslInst tsl = (TslInst)ents[e];
						if (!tsl.bIsValid()){continue;}

						if (tsl.scriptName()!=scriptName())
						{
						// set flag to do actions which would be typically done on dbCreated, i.e. query block contents of the combination	
							Map map=tsl.map();
							map.setInt("bQueryBlockTsls", true);
							tsl.setMap(map);
							tsl.recalcNow();
							nNumCombinations++;
							combinations.append(tsl);
						}
						else if (tsl.scriptName()==scriptName())
						{
							tslInstPoint=tsl;
							tsl.map().setMap("Settings", mapSetting);
						}
					}
				// force installation point to be racalculated if no combinations are attached
					if (tslInstPoint.bIsValid() && nNumCombinations<1)
						tslInstPoint.recalcNow();
					
					
				//region Clone Instances
					// Most likely a change in cadmodel broke the functionality to create subsequently multiple
					// installation/combination collections during insert
					// the root cause had been investigated by DT and TH: the entities created and send to modelmap
					// are having the same handles and as such the previous inserted will automatically be purged
					
					// To solve this issue the tsl's will be cloned on insert and the modelmap created ones will be purged
					TslInst tslInstClone;
					if (tslInstPoint.bIsValid())
					{ 
						tslInstPoint.setCatalogFromPropValues(sLastInserted);
						
						
					// create TSL
						TslInst tslNew;				Map mapTsl;
						int bForceModelSpace = true;	
						String sExecuteKey,sCatalogName = sLastInserted;
						String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
						GenBeam gbsTsl[] = {};		Entity entsTsl[] = {elements[0]};			Point3d ptsTsl[] = {pt};
					
						
						tslNew.dbCreate(scriptName() , elements[0].vecX() ,elements[0].vecY(),gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 
				
						if (tslNew.bIsValid())
							tslInstClone = tslNew;
					}
					
					if (tslInstClone.bIsValid())
					{ 
						reportMessage(TN("|the installation clone is valid|"));
						
						int numClone;
						for (int i=0;i<combinations.length();i++) 
						{  
							combinations[i].setCatalogFromPropValues(sLastInserted);
					
						// create TSL
							TslInst tslNew;				Map mapTsl;
							int bForceModelSpace = true;	
							String sExecuteKey,sCatalogName = sLastInserted;
							String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
							GenBeam gbsTsl[] = {};		Entity entsTsl[] = {tslInstClone,elements[0]};			Point3d ptsTsl[] = {combinations[i].ptOrg()};
							gbsTsl.append(combinations[i].genBeam());
							
							tslNew.dbCreate("hsb-E-Combination", elements[0].vecX() ,elements[0].vecY(),gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 				 
							if (tslNew.bIsValid())
								numClone++;
						}//next i
						
						//reportMessage("\n clones created " + numClone);
						tslInstPoint.dbErase();
					}					
					
				//endregion 	

				}// END if (ssP.go()==_kOk)
				else
					break;
			}// do while point
			ssE = PrEntity(TN("|Select a wall|") + ", " + T("|<Enter> to continue|"), ElementWall());			
		}// do while element
		eraseInstance();


		return;	
	}	
// end on insert		


//End on insert//endregion________________________________________________________________________________________________________ 

//region Prerequisites
	//if (bDebug)	reportMessage("\n" + scriptName() + " start execution." + _ThisInst.handle());
	if (_bOnDbCreated || (_bOnRecalc))
	{
		setExecutionLoops(2);
	}
		
	// HSB-21736
	Element el;
	if(_Element.length()>0)
		el = _Element[0];
	if(el.bIsValid())
	{ 
		// save in a map
		Quader qd=el.bodyExtents();
		Body bd;
		// HSB-21736: Make sure the quader of element is not 0
		if(qd.dX()>dEps && qd.dY()>dEps && qd.dZ()>dEps)
		{ 
			bd = Body(qd);
		}
		if(bd.volume()>pow(U(10),3))
		{
			_Map.setBody("ElementBody",bd);
		}
		else
		{ 
			bd=el.realBody();
			if(bd.volume()>pow(U(10),3))
			{
				_Map.setBody("ElementBody",bd);
			}
			else
			{ 
				Point3d ptOrg=el.ptOrg();
				Vector3d vecX=el.vecX();
				Vector3d vecY=el.vecY();
				Vector3d vecZ=el.vecZ();
				LineSeg seg=el.segmentMinMax();
				// get extents of profile
				double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
				double dY = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
				double dZ = abs(vecZ.dotProduct(seg.ptStart()-seg.ptEnd()));
				
				bd=Body(seg.ptMid(),vecX,vecY,vecZ,dX,dY,dZ,0,0,0);
				
				_Map.setBody("ElementBody",bd);
				_Map.setPoint3d("ptElement",ptOrg,_kAbsolute);
			}
		}
	}
	else
	{ 
		// HSB-21736
		// element might have been joined
		// use the joined element 
		if(_Map.hasBody("ElementBody"))
		{ 
			Body bd=_Map.getBody("ElementBody");
			Point3d ptOrgEl=_Map.getPoint3d("ptElement");
			
			Entity entsEl[]=Group().collectEntities(true,Element(),_kModelSpace);
			Element elFound;
			for (int e=0;e<entsEl.length();e++) 
			{ 
				Element elI=(Element)entsEl[e];
				ElementWall eWall=(ElementWall)entsEl[e];
				if(!eWall.bIsValid())continue;
				
				if(abs(eWall.vecY().dotProduct(eWall.ptOrg()-ptOrgEl))<U(5))
				{ 
					if(bd.hasIntersection(Body(eWall.bodyExtents())))
					{ 
						_Element.append(elI);
						setExecutionLoops(2);
						return;
						break;
					}
				}
			}//next e
		}
	}
	
	if (_Element.length() < 1 || !_Element[0].bIsKindOf(ElementWall()))
	{
		eraseInstance();
		return;
	}
	Group grElement = el.elementGroup();
	String sFloorName = grElement.namePart(1);		


//End Prerequisites//endregion 	

//region Read Settings
	double dCombinationSymbolOffsetScale = 1,dConduitExtraWidth,dExtentWirechaseOffset,dConduitExtraDepth;
	int bExtentWirechase, nNoNailMode, bCombinationDrawElevationElementView;
	int bDrawWirechaseOutline = (nProjectSpecial == 1) ? false : true;
	int bDrawPlanConduits = (nProjectSpecial == 1 ? true : false);
	int bDrawRoomAlert = (nProjectSpecial == 1 ? false: true);
	int nSideColors[] = {3,4};
	if (nProjectSpecial==1)nSideColors[1] = 6;
	int bUseGenbeamReference; // flag to define the reference location: 0 = byOutline, 1 = byGenBeam at installation
	Map mapVerticalTools,mapSkewedMilling;
{
	String k;
	Map m= mapSetting;//.getMap("SubNode[]");

	
// if the name of an optional additional group object is defined in the settings file all electra items will be assigned additionally to this group
// the group will be created and will create floor groups based on the group of the linked element
// if this flag is set all installation points and combintaions will be linked to it
	if (m.getString("Group").length()>0)
	{
		String sElectraGroupName = m.getString("Group");
		String sElectraGroupElementName = m.getString("GroupElement");
		if (sElectraGroupName.length()>0)
		{
			Group grElectra;
			if (sElectraGroupElementName .length()<1)
				grElectra = Group(sElectraGroupName+"\\" +sFloorName );
			else
				grElectra = Group(sElectraGroupName+"\\" +sFloorName+"\\" +sElectraGroupElementName );
			if (!grElectra.bExists())grElectra.dbCreate();
			grElectra.addEntity(_ThisInst,false,0,'I');
		}
	}

	k="CombinationSymbolOffsetScale";		if (m.hasDouble(k))		dCombinationSymbolOffsetScale = m.getDouble(k);
	k="CombinationSymbolOffsetScale";		if (_Map.hasDouble(k))	dCombinationSymbolOffsetScale = _Map.getDouble(k);
	k="ExtentWirechase";					if (m.hasInt(k))		bExtentWirechase = m.getInt(k);
	k="WirechaseNoNail";					if (m.hasInt(k))		nNoNailMode = m.getInt(k);// flags how vertical noNail areas are created
	k="CombinationDrawElevationElementView";if (m.hasInt(k))		bCombinationDrawElevationElementView = m.getInt(k);
	
	k="ConduitExtraWidth";				if (m.hasDouble(k))		dConduitExtraWidth = m.getDouble(k);
	k="ConduitExtraDepth";				if (m.hasDouble(k))		dConduitExtraDepth = m.getDouble(k);
	k="DrawWirechaseOutline";			if (m.hasInt(k))		bDrawWirechaseOutline = m.getInt(k);//flag if the outline of the wirechase needs to be drawn, default=off for custom 1	
	k="DrawPlanConduits";				if (m.hasInt(k))		bDrawPlanConduits = m.getInt(k);// flag if conduits are drawn in plan view
	k="DrawRoomAlert";					if (m.hasInt(k))		bDrawRoomAlert = m.getInt(k);// flag if a missing room link shall be displayed	
	
	k="ExtentWirechaseOffset";			if (m.hasDouble(k))		dExtentWirechaseOffset = m.getDouble(k);
	k="IconSideColor";					if (m.hasInt(k) && m.getInt("IconSideColor")!=-99)		nSideColors[0] = m.getInt(k);// collect and set colors: side colors
	k="OppositeSideColor";				if (m.hasInt(k) && m.getInt("OppositeSideColor")!=-99)	nSideColors[1] = m.getInt(k);

	m = mapSetting.getMap("InstallationPoint");
	k="UseGenbeamReference";					if (m.hasInt(k))		bUseGenbeamReference = m.getInt(k);	
	mapVerticalTools = m.getMap("VerticalTool[]");// get settings of bottom and top tools
	mapSkewedMilling = m.getMap("SkewedMilling");// get settings of bottom and top tools
	
//k="StringEntry";		if (m.hasString(k))	sStringEntry = m.getString(k);
	
}
//End Read Settings//endregion 

//region during wall split multiple elements may be linked: take the closest one
	if (_Element.length()>1)
	{
		double dMax=U(10000000);
		for (int i=0;i<_Element.length();i++)
		{
			Point3d ptNext = _Element[i].plOutlineWall().closestPointTo(_Pt0);
			double d = (ptNext-_Pt0).length();
			if (d<dMax)
			{
				el = _Element[i];
				dMax = d;	
			}	
		}	
		_Element.setLength(1);
		_Element[0]=el;
		assignToElementGroup(el, true,0, 'E');// remove all other links
	}	
	
	Point3d ptOrg;
	Vector3d vecX,vecY,vecZ;
	ptOrg = el.ptOrg();	
	vecX=el.vecX();					vecX.vis(ptOrg, 1);
	vecY=el.vecY();					vecY.vis(ptOrg, 3);
	vecZ=el.vecZ();					vecZ.vis(ptOrg, 150);
	assignToElementFloorGroup(el, false, 0,'C');
	assignToElementGroup(el, false,0, 'C');
	double dZ = el.dPosZOutlineFront()-el.dPosZOutlineBack();
	
// get previous version
	int nPreviousVersion= _Map.getInt("version");// stored from version 8.9 on
	int nCurrentVersion= _ThisInst.version();	
	
// instances inserted before 10.2 could carry an overloaded amount of items in _GenBeam -> reset old genBeam structure
//	if (nPreviousVersion<100002)
//	{
//		_Map.setInt("version",nCurrentVersion);	
//		reportMessage("\n" + scriptName() + " " + _ThisInst.handle() + " " + T("|will purge obsolete references.|") + " (" + _GenBeam.length() + ")");	
//		_GenBeam.setLength(0);
//		setExecutionLoops(2);
//	}

// identify min and max height of all linked childs
	Map mapChilds = _Map.getMap("Child[]");
	Point3d ptChilds[0];
	Point3d ptChildBeforeSplit[0];
	if (_Map.hasPoint3dArray("ChildLocationsBeforeSplit"))
	{
		ptChildBeforeSplit=_Map.getPoint3dArray("ChildLocationsBeforeSplit");
	}	
	
//End during wall split multiple elements may be linked: take the closest one//endregion 	

//region Get Floor
// get floor plan
	Group grFloor = el.elementGroup();
	PlaneProfile ppFloor(CoordSys(el.ptOrg(), _XW, _YW, _ZW));
	{ 
		grFloor=Group(grFloor.namePart(0)+ "\\" + grFloor.namePart(1));
		Entity ents[] = grFloor.collectEntities(true, ElementWall(), _kModel);
		for (int i=0;i<ents.length();i++) 
		{ 
			ElementWall wall = (ElementWall)ents[i];
			if (!wall.bIsValid())continue;
			ppFloor.joinRing(wall.plOutlineWall(), _kAdd);  
		}//next i	
		ppFloor.vis(4);
		_Map.setPlaneProfile("floorPlan", ppFloor);
	}
//End Get Floor//endregion 

//region collect childs
	TslInst tslChilds[0];
	Map mapChildMaps[0];
	double dChildElevations[0], dAverageChildElevation;
	for (int i = 0; i < mapChilds.length(); i++)
	{
		
		Entity entChild = mapChilds.getEntity(i);
		if (entChild.bIsValid() && entChild.bIsKindOf(TslInst()))
		{		
			TslInst tslChild = (TslInst)entChild;

		// collect the elevation of each child and the average of all of them
			double d = tslChild.propDouble(0);
			dAverageChildElevation+=d;
			dChildElevations.append(d);
			
		
			if (ptChildBeforeSplit.length()>i)
			{
				reportMessage("\nsetting pt org due to child before split");
				tslChild.setPtOrg(ptChildBeforeSplit[i]);
			}
		//avoid duplicates
			if (tslChilds.find(tslChild)<0)
			{
				ptChilds.append(tslChild.ptOrg());
				if (bDebug)reportMessage("\n	" + _ThisInst.handle() + ": collecting child " + tslChild.handle() + " at " + tslChild.ptOrg());
				tslChilds.append(tslChild);
				mapChildMaps.append(tslChild.map());
			}
		}
		else
		{
			TslInst tslChild = (TslInst)entChild;
			if (bDebug)reportMessage("\n	" + _ThisInst.handle() + ": what the heck is this " + entChild.bIsValid() + " " + entChild);	
			//mapChilds.writeToXmlFile("c:\\temp\\etest.xml");
		}
	}
	if (tslChilds.length()>0)dAverageChildElevation/=tslChilds.length();

// order childs by elevation
	for (int i=0; i<tslChilds.length(); i++)
	{
		for (int j=0; j<tslChilds.length()-1; j++)
		{
			double d1 = dChildElevations[j];
			double d2 = dChildElevations[j+1];
			if (d1>d2)
			{
				dChildElevations.swap(j,j+1);
				tslChilds.swap(j,j+1);
				mapChildMaps.swap(j,j+1);
				ptChilds.swap(j,j+1);
			}		
		}
	}		
//End collect childs//endregion 

//region reassign on wall split
// Find among all the _Element entries the element which is closest to _Pt0.
// The _bOnElementListModified will be TRUE after wall-splitting-in-length, or integrate tsl as tooling to element.
	if (_bOnElementListModified && (_Element.length()>1)) // at least 2 items in _Element array
	{
		//reportMessage("\n"+scriptName()+" bOnElementListModified value: "+_bOnElementListModified);
		// now find closest among these elements, for that project the point into the XY plane of each element
		int nIndexWinner = -1;
		double dDistWinner;
		for (int e=0; e<_Element.length(); e++) 
		{
			Element elE = _Element[e];
			Point3d ptNext = elE.plOutlineWall().closestPointTo(_Pt0) ; // project point into XY plane of elE
			double dDistE = Vector3d(ptNext-_Pt0).length();
			if (nIndexWinner==-1 || dDistE<=dDistWinner)
			{
				nIndexWinner = e;
				dDistWinner = dDistE;
			}
		}
		if (nIndexWinner>0) { // the new winner is has not index 0 (or -1)
			Element elNew = _Element[nIndexWinner];
			Element elOld = _Element[0];//reportMessage("\n"+scriptName()+" moved from "+elOld.number()+ " to "+elNew.number());
			_Element[0] = elNew; // overwrite 0 entry will replace the existing reference to elem0
		}
		
	// restore map contents
		_Map.setEntity("Element", _Element[0]);		
		_ThisInst.recalc();
		return;
	}
// else remove any other element reference
	else
		_Element.setLength(1);		


//End reassign on wall split//endregion 

//region Room mapping and custom data
// get room map
	Map mapRoom=_Map.getMap("Room");

// read custom data: stammdat
	if (nProjectSpecial==1 && (_bOnDbCreated || _bOnRecalc || _bOnDebug))
	{
	// read stammdat
		Map mapCustom;		
		TslInst().callMapIO("LUX-Stammdaten IO", mapCustom);
		_Map.setMap("Custom",mapCustom);
	}		
//End Room mapping and custom data//endregion 

// project selected point to contour
	PLine plOutlineWall= el.plOutlineWall();
	
// get a modified plOutlineWall based on the genbeams
	if (bUseGenbeamReference)
	{ 
		PlaneProfile pp(CoordSys(ptOrg, vecX, - vecZ, vecY));
		Plane pnY(ptOrg, vecY);
	// get zone 0 first	
		for (int i=0;i<_GenBeam.length();i++) 
			if (_GenBeam[i].myZoneIndex()==0)
			{ 
				PLine plines[0];
//				plines=_GenBeam[i].envelopeBody(true, false).shadowProfile(pnY).allRings(true, false);
				plines=calcPpOptimised(_GenBeam[i],pnY).allRings(true, false);
				if (plines.length()>0) pp.joinRing(plines[0], _kAdd);
			}
		
	// get extents of profile
		LineSeg seg = pp.extentInDir(vecX);
		double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
		double dZ = abs(vecZ.dotProduct(seg.ptStart()-seg.ptEnd()));
		pp.createRectangle(LineSeg(seg.ptMid() - .5 * (vecX * dX + vecZ * dZ), seg.ptMid() + .5 * (vecX * dX + vecZ* dZ)), vecX, vecZ);		
		//pp.vis(211);
	// append other zones
		for (int i=0;i<_GenBeam.length();i++) 
			if (_GenBeam[i].myZoneIndex()!=0)
			{ 
//				PLine plines[] = _GenBeam[i].envelopeBody(true, false).shadowProfile(pnY).allRings(true, false);
				PLine plines[]=calcPpOptimised(_GenBeam[i],pnY).allRings(true, false);
				if (plines.length()>0)  pp.joinRing(plines[0], _kAdd);
			}
		pp.shrink(-dEps);
		pp.shrink(dEps);
		//pp.transformBy(-vecY * U(100));		pp.vis(1);
		
		Point3d pts[] = pp.getGripVertexPoints();
		if (pts.length()>3)
		{ 
			plOutlineWall = PLine();
			for (int i=0;i<pts.length();i++) 
				plOutlineWall.addVertex(pts[i]); 
			plOutlineWall.close();
			_Map.setPLine("plOutlineWall", plOutlineWall);
		}
	}
// erase potential outline override	
	else if (_Map.hasPLine("plOutlineWall"))
		_Map.removeAt("plOutlineWall", true);
	
	Point3d pt = plOutlineWall.closestPointTo(_Pt0);
	Point3d ptOutlineWall[] = plOutlineWall.vertexPoints(true);
	if (Vector3d(_Pt0-pt).length()>dEps)
		_Pt0 = pt;		

// add grippoints if not available
	// custom 0 = grip 0 is the grip to move the toolings of installation point from the insertion point
	// custom 1 = index 0+1 are the grips of the conduits, grip 2 is the grip to move the toolings of installation point from the insertion point
	{
		int nMax = 1;
		if (nProjectSpecial == 1)
			nMax =3;
		for (int i=0;i<nMax;i++)
			if (_PtG.length()<(i+1))
				_PtG.append(_Pt0);
		if (nProjectSpecial == 0) // reduce qty of grips also for older dwg's
		{
			if (nPreviousVersion<80009 && _PtG.length()>1)
				_PtG.swap(0,1); // 
			_PtG.setLength(1);		
		}
	}		


//End Part 2//endregion 

//region Part 3

//region flags, events and triggers
	int nIndexToolLocationGrip = _PtG.length()-1;
		
// the installation side
	Point3d ptMid;
	ptMid.setToAverage(ptOutlineWall);
	//ptMid.vis(5);
	int nSide=1;
	if(vecZ.dotProduct(_Pt0-ptMid)<0) nSide*=-1;	
	_Map.setInt("Side",nSide);
	
// the ref point for symbol sorting
	Point3d ptRefSymbolAlignment =_Pt0;
	if (nSide==-1)ptRefSymbolAlignment.transformBy(nSide*-vecZ*dZ);	
	ptRefSymbolAlignment.vis(2);
	
// ints
	int nMillThisSide = sArMill.find(sMillThisSide);
	int nMillOppositeSide = sArMill.find(sMillOppositeSide);	
	int bAddToolBottomIcon= sNoYes.find(sAddToolBottomIcon);	
	int bAddToolTopIcon= sNoYes.find(sAddToolTopIcon);
	int bAddToolBottomOpposite= sNoYes.find(sAddToolBottomOpposite);
	int bAddToolTopOpposite= sNoYes.find(sAddToolTopOpposite);		
	
// validate additional tools bottom top. the additional tools are only valid if the corresponding milling operation is enabled
	if ((nMillThisSide<1 || nMillThisSide==2) && bAddToolBottomIcon)
	{
		bAddToolBottomIcon=false;
		sAddToolBottomIcon.set(sNoYes[bAddToolBottomIcon]);
	}
	if ((nMillThisSide<1 || nMillThisSide==1) && bAddToolTopIcon)
	{
		bAddToolTopIcon=false;
		sAddToolTopIcon.set(sNoYes[bAddToolTopIcon]);
	}	
	if ((nMillOppositeSide <1 || nMillOppositeSide ==2) && bAddToolBottomOpposite)
	{
		bAddToolBottomOpposite=false;
		sAddToolBottomOpposite.set(sNoYes[bAddToolBottomOpposite]);
	}
	if ((nMillOppositeSide <1 || nMillOppositeSide ==1) && bAddToolTopOpposite)
	{
		bAddToolTopOpposite=false;
		sAddToolTopOpposite.set(sNoYes[bAddToolTopOpposite]);
	}	
	
// set instance color
	int nInstColor=0;
	if (nProjectSpecial==1)
	{
		if (nMillThisSide>0 && nMillOppositeSide>0)nInstColor=0;
		else if (nSide==1)		nInstColor=nSideColors[0];
		else if (nSide==-1)	nInstColor=nSideColors[1];
	}
	if (_ThisInst.color()!=nInstColor)_ThisInst.setColor(nInstColor);
		//if (bDebug)reportMessage("\n" + scriptName() + " on side " + nSide);


// property change events
	// conduits this side
	if (_kNameLastChangedProp == sConduitsThisName && dMillDepthThis>0 && nConduitsThis>0)	
	{
		double d = nConduitsThis*(dMillDepthThis+dConduitExtraWidth);
		if (d<dMinMillWidth) d=dMinMillWidth;
		dMillWidthThis.set(d);
	}
	// conduits opposite side
	if (_kNameLastChangedProp == sConduitsOppositeName && dMillDepthOpposite>0 && nConduitsOpposite>0)	
	{
		double d = nConduitsOpposite*(dMillDepthOpposite+dConduitExtraWidth);
		if (d<dMinMillWidth) d=dMinMillWidth;
		dMillWidthOpposite.set(d);
	}

// add triggers	
// trigger flip side
	String sTriggerFlipSide = T("|Flip Side|");
	addRecalcTrigger(_kContext, sTriggerFlipSide);
	int bFlipSideTriggered;
	if (_bOnRecalc && _kExecuteKey==sTriggerFlipSide)
	{
		nSide*=-1;		
		_Pt0.transformBy(vecZ*nSide*dZ);		
		_Map.setInt("remoteStaticLocation",true);
		_Map.setInt("recalcChilds",true);
		_ThisInst.recalc();
		bFlipSideTriggered=true;	
		_GenBeam.setLength(0);
	}
	
// trigger flip side with combinations
	String sTriggerFlipSideCombinations = T("|Flip Side Combinations|");
	addRecalcTrigger(_kContext, sTriggerFlipSideCombinations );
	int bFlipSideAndCombiTriggered;	
	if (_bOnRecalc && _kExecuteKey==sTriggerFlipSideCombinations )
	{
		nSide*=-1;		
		_Pt0.transformBy(vecZ*nSide*dZ);
		_Map.setInt("recalcChilds",true);
		_Map.setInt("remoteFlip",true);
		_ThisInst.recalc();
		bFlipSideAndCombiTriggered=true;	
	}


// assign to wall: assigns the installation to another wall
	String sTriggerAssignToWall =T("|Assign to Wall|") ;
	addRecalcTrigger(_kContext, sTriggerAssignToWall );
	if (_bOnRecalc && _kExecuteKey==sTriggerAssignToWall)
	{
		Element elNew = getElement();
		if (elNew!=el)
		{
			PrPoint ssP("\n" + T("|Select point|"),_Pt0); 
			if (ssP.go()==_kOk)
			{
				Point3d ptNew =ssP.value();
				for(int i=0;i<_PtG.length();i++)
				{
					if (bDebug) reportMessage("\ntransforming grip " +i);
					_PtG[i].transformBy(vecX*vecX.dotProduct(ptNew-_Pt0));
				}
				_Pt0=ptNew ;	 
			}
			_Element[0] = elNew;	
		
		// assign installation point to new group structure	
			assignToElementGroup(elNew, true,0, 'C');// remove all other links
			assignToElementFloorGroup(elNew, false, 0,'C');
			assignToElementGroup(elNew, false,0, 'C');
			
		// assign combinations to new group structure and replace parent tsl ink in _Entity of child
			for (int t=0;t<tslChilds.length();t++)
			{	
				tslChilds[t].assignToElementGroup(elNew, true,0, 'C');// remove all other links
				tslChilds[t].assignToElementFloorGroup(elNew, false, 0,'C');
				tslChilds[t].assignToElementGroup(elNew, false,0, 'C');
			}			
			el = _Element[0];	
	
		// release potential room link		
			mapRoom.removeAt("Room", true);
							
		}	
		
		setExecutionLoops(2);
		return;
	}
	_Map.setEntity("Element",el);			


//End flags, events and triggers//endregion 
		
//region copy installation and combinations
	String sTriggerCopyInstallation = T("|Copy Installation|");
	addRecalcTrigger(_kContext, sTriggerCopyInstallation );
	if (_bOnRecalc && _kExecuteKey==sTriggerCopyInstallation)
	{
	// new element and target point
		Element elNew = getElement();
		Point3d ptNew;
		PrPoint ssP("\n" + T("|Select point|"),_Pt0); 
		if (ssP.go()==_kOk)
			ptNew =ssP.value();	
		Vector3d vecNew = ptNew-_Pt0;

		Point3d ptNewClosest = elNew.plOutlineWall().closestPointTo(ptNew);


	// declare arrays for tsl cloning
		TslInst tslNew, tslNewCombi;
		Vector3d vUcsX = _X0;
		Vector3d vUcsY = _Y0;
		GenBeam gbAr[0];
		Entity entAr[0];
		Point3d ptAr[0];
		int nArProps[0];
		double dArProps[0];
		String sArProps[0];
		Map mapTsl;		
		String sScriptname = scriptName();		
		
	// take all entity references along	except wall
		entAr.append(elNew);
		ptAr.append(ptNew);
		mapTsl.setEntity("Element",elNew);	
		mapTsl.setInt("Side", _Map.getInt("Side"));
		// 7.5 do not copy room
		//if (mapRoom.hasEntity("Room"))
		//{
		//	mapTsl.setMap("Room",mapRoom);
		//}
				
	// copy me by dbCreate
		tslNew.dbCreate(sScriptname, vUcsX,vUcsY,gbAr, entAr, ptAr, 
			nArProps, dArProps, sArProps,_kModelSpace, mapTsl); // create new instance	
			
		if (tslNew.bIsValid())
		{
			tslNew.setPropValuesFromMap(_ThisInst.mapWithPropValues());
			
		// now copy all combinations
			
			Map mapChilds = _Map.getMap("Child[]");
			Point3d ptChilds[0];
			for (int i = 0; i < mapChilds.length(); i++)
			{
				Entity entChild = mapChilds.getEntity(i);
				if (entChild.bIsValid() && entChild.bIsKindOf(TslInst()))
				{
					TslInst tslChild = (TslInst)entChild;
					mapTsl=Map();
					
				// write an catalog entry of the source tsl
					String sEntry = T("|_LastInserted|");
					tslChild.setCatalogFromPropValues(sEntry);	
					mapTsl.setString("CatalogEntry", sEntry);
					
					ptChilds.append(tslChild.ptOrg());
					sScriptname = tslChild.scriptName();
					
					entAr.setLength(0);
					entAr.append(tslNew);
					ptAr.setLength(0);
					
					if (bDebugLocation) reportMessage("\n" + scriptName() + " " + tslChild.handle() + " to be copied");
					
					Point3d ptInsCombi = ptNew;
					//#601
					if (tslChild.map().getInt("Flip"))
					{
						
						
						//ptInsCombi = ptNewClosest +vecZ*vecZ.dotProduct(tslChild.ptOrg()-_Pt0);
						mapTsl.setInt("RemoteFlip",true);
						mapTsl.setInt("flipOnCopy",true);
						if (bDebugLocation) reportMessage("\n#600 " + scriptName() + " " + tslChild.handle() + "\n	RemoteFlip + flipOnCopy: 1");
						//mapTsl.setInt("Flip",true);
						//mapTsl.setInt("recalcChilds",true);
						
						
						//EntPLine epl;
						//epl.dbCreate(PLine(ptInsCombi ,ptNew));
						//epl.setColor(1);
						
					}
					ptAr.append(ptInsCombi );//tslChild.ptOrg() + vecNew);
					
				// get the vector of the grip-org of the source tsl
					Vector3d vecGrip=tslChild.gripPoint(0)-tslChild.ptOrg();
					CoordSys csSource2New;
					csSource2New.setToAlignCoordSys(el.ptOrg(), vecX,vecY,vecZ, elNew.ptOrg(), elNew.vecX(), elNew.vecY(), elNew.vecZ());
					vecGrip.transformBy(csSource2New);
					//ptAr.append(ptNew+vecGrip);	
					
					tslNewCombi.dbCreate(sScriptname, vUcsX,vUcsY,gbAr, entAr, ptAr, 
						nArProps, dArProps, sArProps,_kModelSpace, mapTsl); // create new instance	
				}	
			}					
		}
		tslNew.recalc();	

	}			

//End copy installation and combinations//endregion 

//region trigger  move wirechase  and combinations
	String sTriggerMoveWirechase= T("|Move Wirechase|");
	addRecalcTrigger(_kContext, sTriggerMoveWirechase);
	if (_bOnRecalc && _kExecuteKey==sTriggerMoveWirechase)
	{
		PrPoint ssP("\n" + T("|Select point|"),_PtG[nIndexToolLocationGrip]); 
		if (ssP.go()==_kOk)
		{
			_PtG[nIndexToolLocationGrip]= ssP.value(); 
		}
		setExecutionLoops(2);
	}
	addRecalcTrigger(_kContext,"____________________________________________   "); // dummy trigger		
//End trigger  move wirechase  and combinations//endregion 

//region trigger add combination symbols // align combination symbols // override symbol offset scale
	String sTriggerAddCombi = T("|Add Combination|");
	addRecalcTrigger(_kContext, sTriggerAddCombi );
	
// trigger  align combination symbols
	String sTriggerAlignCombinationSymbols = T("|Align Combination Symbols|");
	addRecalcTrigger(_kContext, sTriggerAlignCombinationSymbols );	
	if (_bOnRecalc && _kExecuteKey==sTriggerAlignCombinationSymbols  || _bOnDbCreated)
		_Map.setInt("AlignCombinationSymbols",true);

// trigger override symbol offset scale
	String sTriggerOverrideSymbolOffset = T("|Edit plan view symbol offset|");
	addRecalcTrigger(_kContext, sTriggerOverrideSymbolOffset );
	if (_bOnRecalc && _kExecuteKey==sTriggerOverrideSymbolOffset )
	{	
		double dCurrent = dCombinationSymbolOffsetScale;
		dCurrent  = getDouble(T("|Enter Scale Factor to adjust symbol offset in plan view|") + ", " + "["+dCurrent+"]");	
		if (dCurrent>0)
		{
			dCombinationSymbolOffsetScale=dCurrent;
			_Map.setDouble("CombinationSymbolOffsetScale",dCombinationSymbolOffsetScale);
			_Map.setInt("AlignCombinationSymbols",true);
			setExecutionLoops(2);
			return;
		}
	}


	if(_Map.getInt("requestGripLocation"))
	{
		_Map.setInt("AlignCombinationSymbols",true);
		_Map.removeAt("requestGripLocation",false);
	}		

// the flag to align combination symbols needs to be map based to support multiple execution loops of the involved tsl's
	int bAlignCombinationSymbols=_Map.getInt("AlignCombinationSymbols");
//End trigger add combination symbols//endregion 

//region add nominal diameter
// add nominal diameter override trigger for custom 1
	String sNominalDiameterTrigger = T("|Override Conduit Diameter|");
	double dNominalDiameters[2];
	dNominalDiameters[0]= _Map.getDouble("NominalDiameterThisSide");
	dNominalDiameters[1]= _Map.getDouble("NominalDiameterOpppositeSide");
	
	addRecalcTrigger(_kContext,"____________________________________________ "); // dummy trigger
	addRecalcTrigger(_kContext,sNominalDiameterTrigger );
	if (_bOnRecalc && _kExecuteKey==sNominalDiameterTrigger )
	{
		double dCurrent = dNominalDiameters[0];
		dNominalDiameters[0] = getDouble(T("|Enter Override Icon Side (0=no override)|" + ", " + "["+dNominalDiameters[0])+"]");
		dNominalDiameters[1] = getDouble(T("|Enter Override opposite Side (0=no override)|"+ ", " + "["+ dNominalDiameters[1])+"]");
		_Map.setDouble("NominalDiameterThisSide",dNominalDiameters[0]);
		_Map.setDouble("NominalDiameterOpppositeSide",dNominalDiameters[1]);	
	}		
//End add nominal diameter//endregion 

//region ROOM
	Entity entRoom = mapRoom.getEntity("Room");
	int bHasRoom = entRoom.bIsValid();
	double dFloorThickness;
	double dCustomFloorThickness;
	{String k = "CustomFloorThickness"; if (_Map.hasDouble(k))dCustomFloorThickness = _Map.getDouble(k);}


//region assign/release room
	String sAssignReleaseRoomTrigger = T("|Assign to Room|");
	if (bHasRoom)sAssignReleaseRoomTrigger = T("|Release from Room|");
	addRecalcTrigger(_kContext,"____________________________________________"); // dummy trigger
	addRecalcTrigger(_kContext,sAssignReleaseRoomTrigger);
	if (_bOnRecalc && _kExecuteKey==sAssignReleaseRoomTrigger)
	{
	// clear all room data
		if (mapRoom.hasEntity("Room"))
		{
			mapRoom = Map();
			_Map.removeAt("Room",true);
		}
		else
		{	
		// selection of linked room		
			PrEntity ssE(T("|Select room|"), Entity());
			Entity ents[0];  		
			if (ssE.go())
		    	ents = ssE.set();	
	
		// search for aec_spaces or tsl based rooms
			for(int i=0;i<ents.length();i++)
			{
				String s = ents[i].typeDxfName();
				TslInst tsl = (TslInst)ents[i];
				if (s=="AEC_SPACE")
				{
					mapRoom.setEntity("Room", ents[i]);
					break;
				}	
				else if (tsl.bIsValid() && tsl.scriptName().makeUpper() == "HSBRAUM")
				{
					mapRoom.setEntity("Room", ents[i]);
					break;
				}	
			}// next i	
			_Map.setMap("Room",mapRoom);
		}

		setExecutionLoops(2);
		return;
	}
	
	if (!bHasRoom)
	{ 
	// Trigger SetCustomFloorThickness//region
		String sTriggerSetCustomFloorThickness = T("../|Set floor thickness|");
		addRecalcTrigger(_kContext, sTriggerSetCustomFloorThickness );
		if (_bOnRecalc && _kExecuteKey==sTriggerSetCustomFloorThickness)
		{
			String k = "CustomFloorThickness";
			PrEntity ssE(T("|Select room to derive thickness from|")+ T(", |<Enter> to specify thickness|"), Entity());
			Entity ents[0];  
			Entity space;
			if (ssE.go())
		    	ents = ssE.set();
			for (int i = 0; i < ents.length(); i++)
			{
				if (ents[i].typeDxfName() == "AEC_SPACE")
				{ 
					space = ents[i];
					break;
				}
			}
		
		// derive from aec space
			double dNewCustomFloorThickness = dCustomFloorThickness;
			if (space.bIsValid())
			{ 
				String sPropSetNames[] = space.attachedPropSetNames();
				String sPropertyNames[] = {"Höhe_Fußboden"};
			
			// loop all property sets
				for (int i=0; i<sPropSetNames.length();i++)
				{
					Map map = space.getAttachedPropSetMap(sPropSetNames[i],sPropertyNames);
					if (map.length()>0)
					{
						dNewCustomFloorThickness = map.getDouble(sPropertyNames[0]);
						break;// first appearance taken	
					}
				}// next i		
			}
		// promnpt for user input
			else
				dNewCustomFloorThickness = getDouble(T("|Enter floor thickness|") + (abs(dCustomFloorThickness) > 0 ? T(" |0 = reset|") : ""));

		// store in map	
			if (dNewCustomFloorThickness==0)
				_Map.removeAt(k, true);
		// reset and remove from map
			else
				_Map.setDouble(k, dNewCustomFloorThickness);
			setExecutionLoops(2);
			return;
		}//endregion	
		
	}


//End assign/release room//endregion  

//region auto collect tsl based room(default) or aec romm
	// this will search for a room body which intersects a dummy body of the installation on dbCreated or on recalc
	// if no room entity has been assigned yet
	//Groups
	

// test if the location is on the outside
	int bInstallationIsExposed;
//	if (!_bOnDbCreated)
	{ 
		PlaneProfile pp = ppFloor;
		pp.removeAllOpeningRings();
		pp.shrink(dEps);
		
		PlaneProfile ppRoom;
		if (bHasRoom)
		{ 
			ppRoom = entRoom.realBody().shadowProfile(Plane(_Pt0, _ZW));
			ppRoom.shrink(-dEps);
			pp.unionWith(ppRoom);
		}
		//pp.vis(6);		
		bInstallationIsExposed=pp.pointInProfile(_Pt0)==_kPointOutsideProfile;
	}	
	
	
	int bUpdateRoomRef = _kNameLastChangedProp=="_Pt0";
	// !bInstallationIsExposed && 
	if (
		((_bOnDbCreated || _bOnRecalc || _bOnDebug) 
		&& _kExecuteKey != sAssignReleaseRoomTrigger))
		bUpdateRoomRef = true;
	// !mapRoom.hasEntity("Room")
	
	if (bUpdateRoomRef)
	{	
		int bDebugThis =false;
		int bOk;
		Group grAll[] = Group().allExistingGroups();
		
	// set test body, get wall height from envelope
		double dY = U(3200);
		Point3d pts[] = el.plEnvelope().intersectPoints(Plane(_Pt0,vecX));
		if (pts.length()>1)
		{
			double d = abs(vecY.dotProduct(pts[1]-pts[0]));
			if(d>dEps) dY=d;
		}
		Body bdTest(_Pt0,vecX,vecY,vecZ,U(50),dY,U(100),0,1,0);
		bdTest.vis(2);
	// search all floor groups with the same name		
		for(int g=0;g<grAll.length();g++)
		{
			if (grAll[g].namePart(1) == sFloorName && grAll[g].namePart(2)=="" )
			{	
				Group gr = grAll[g];
				Entity ents[] = gr.collectEntities(false,TslInst(),_kModelSpace);
				for(int e=0;e<ents.length();e++)
				{
					TslInst tsl = (TslInst) ents[e];
					if (tsl.bIsValid() && tsl.scriptName().makeUpper() == "HSBRAUM")
					{
						Body bdRoom = tsl.realBody(_YW,"hsbFlächenSatz" );	//bdRoom.vis(4);
						bdRoom.intersectWith(bdTest);
						if (bdRoom.volume()>pow(dEps,3))
						{
							mapRoom.setEntity("Room",tsl);
							reportMessage("\n" + T("|Automatic room detection succesfull.|"));
							bOk=true;
							break;
						}
					}// end if valid room tsl
				}// next e ents
			}// valid floor name group
			if (bOk) break;	
		}// next g group
		
	// if the tsl room search did not return a valid entity try searching an aec room
		// auto collect aec spaces #2
		if (!bOk)
		{
		// search all room groups
			Entity entsRoom[0];
			if (bDebugThis) reportMessage("\nloop groups...");
			for(int g=0;g<grAll.length();g++)
			{
				String sGroupName = grAll[g].namePart(2).makeUpper();
				if (sGroupName.length()>0 && (sGroupName.find("RÄUME",0)>-1 || sGroupName.find("ROOM",0)>-1))
				{
					Entity ents[] = grAll[g].collectEntities(true, Entity(), _kModelSpace);	
				// search for aec_spaces or tsl based rooms
					for(int i=ents.length()-1;i>=0;i--)
					{
						String s = ents[i].typeDxfName();
						if (s!="AEC_SPACE")ents.removeAt(i);
					}// next i		
					if (bDebugThis) reportMessage("\n   Group " + +sGroupName + " reports room entities (" + ents.length() + ")" );
					
				// set test body, get wall height from envelope
					double dY = U(3200);
					Point3d pts[] = el.plEnvelope().intersectPoints(Plane(_Pt0,vecX));
					if (pts.length()>1)
					{
						double d = abs(vecY.dotProduct(pts[1]-pts[0]));
						if(d>dEps) dY=d;
					}
					Body bdTest(_Pt0,vecX,vecY,vecZ,U(50),dY,U(100),0,1,0);

				// run volume test against body		
					for(int i=0; i<ents.length();i++)
					{
					// get room height from exctreme vertices of floor and ceiling display if possible
						Point3d pts[] = ents[i].realBody().extremeVertices(vecY);
						if (pts.length()>0)
						{
							dY=abs(vecY.dotProduct(pts[0]-pts[1]));	
						}
					// the room contour	
						PLine pl = ents[i].getPLine();//pl.vis(3);
						// HSB-19168: cleanup pline
						PlaneProfile pp(pl);
						pp.shrink(-U(1));
						pp.shrink(U(1));
						pp.shrink(U(1));
						pp.shrink(-U(1));
						PLine pls[]=pp.allRings(true,false);
						if(pls.length()==0)continue;
						pl=pls[0];
						if (pl.area()<pow(dEps,2))continue;
					// create a quader test room	
						Body bdRoom(pl,vecY*dY,1);
						Body bdDebug = bdRoom;
						bdRoom.intersectWith(bdTest);
						if (bdRoom.volume()>pow(dEps,3))	
						{
							if(_bOnDebug) bdDebug.vis(2);
							entsRoom.append(ents[i]);	
						}
					}		
				}
			}// next room group g		
	
		// if multiple rooms are detected leave decision to the user
			if (entsRoom.length()==1)
			{
				mapRoom.setEntity("Room",entsRoom[0]);
				//reportMessage("\n" + T("|Automatic room detection succesfull.|"));
			}
			else if (entsRoom.length()>1)
			{
				reportMessage("\n" + T("|Multiple rooms detected.|") + "(" + entsRoom.length()+") " + T("|Please select a room manually|"));	
				for (int i=0;i<entsRoom.length();i++)
				{
				// get group name
					Group groups[] = entsRoom[i].groups();
					String sGroupName;
					if (groups.length()>0)sGroupName = groups[0];
				// get room name
					String sRoomName;
					String sAttachedPropSetNames[] = entsRoom[i].attachedPropSetNames();
					String sPropNames[] = {"Nummer", "Name"};
					int bOk;
					for (int s=0;s<sAttachedPropSetNames.length();s++)
					{
						for (int n=0;n<sPropNames.length();n++)
						{
							Map map = entsRoom[i].getAttachedPropSetMap(sAttachedPropSetNames[s]);
							for (int m=0;m<map.length();m++)
								if (map.keyAt(m).find(sPropNames[n],0)>-1)
								{
									sRoomName+=" " + map.getString(m);
									bOk=true;
									break;
								}
						}
						if (bOk)break;
					}
					reportMessage("\n[" + (i+1) + "]" + sRoomName + " " + sGroupName);	
					
				}	
				reportMessage("\n");	
			}
		}// END IF auto collect aec spaces	
		
	}// END IF auto collect tsl based room(default) or aec romm
//End auto collect tsl based room(default) or aec romm//endregion 

//region collect potential links to a room and set dependency to it
	
	//mapRoom.setDouble("Elevation", 0);
	int bRoomIsValid; // version 10.6
	if (mapRoom.hasEntity("Room") && !bInstallationIsExposed)
	{
		bDrawRoomAlert=false;// turn off room alert display
		Entity entRoom =mapRoom.getEntity("Room");
		if (entRoom.bIsValid())
		{
			int n = _Entity.find(entRoom);
			if (n<0)
			{
				_Entity.append(entRoom);
				n = _Entity.length()-1;
			}
			setDependencyOnEntity(_Entity[n]);

		// get all prop sets of it
			String sPropSetNames[] = entRoom.attachedPropSetNames();
			
		// get floor thickness from property set if of type AEC_Space
			if(entRoom.typeDxfName()=="AEC_SPACE")	
			{
			// properties to be scanned
				String sPropertyNames[] = {"Höhe_Fußboden", "Raum-Nummer", "Etage"};
			
			// loop all property sets
				for (int i=0; i<sPropSetNames.length();i++)
				{
					Map map = entRoom.getAttachedPropSetMap(sPropSetNames[i],sPropertyNames);
					if (map.length()>0)
					{
						dFloorThickness = map.getDouble(sPropertyNames[0]);
						mapRoom.setString("RoomNumber", map.getString(sPropertyNames[1]));
						mapRoom.setString("RoomLevel", map.getString(sPropertyNames[2]));
						break;// first appearance taken	
					}
				}// next i		
				
			//try to achieve bottom height by entity grips
				Point3d ptGrips[0];
				ptGrips = entRoom.gripPoints();
			// fall back to solid	
				if (ptGrips.length()<1)
				{
					ptGrips = entRoom.realBody().extremeVertices(_ZW);
				}
				ptGrips = Line(_Pt0,_ZW).orderPoints(ptGrips);
				if (ptGrips.length()>0)
					mapRoom.setDouble("RoomElevation", vecY.dotProduct(ptGrips[0]-ptOrg));//ptGrips[0].Z());
				bRoomIsValid=true;		
			}// end if: AEC_Space	
		// tsl based room	
			else if (entRoom.bIsKindOf(TslInst()))
			{
				TslInst tsl =(TslInst)entRoom;
				dFloorThickness = tsl.propDouble(4);
			
			// properties to be scanned
				String sPropertyNames[] = {"POS"};
			
			// loop all property sets
				for (int i=0; i<sPropSetNames.length();i++)
				{
					Map map = entRoom.getAttachedPropSetMap(sPropSetNames[i],sPropertyNames);
					if (map.length()>0)
					{
						mapRoom.setString("RoomNumber", map.getInt(sPropertyNames[0]));
						mapRoom.setString("RoomLevel", el.elementGroup().namePart(1));
						break;// first appearance taken	
					}
				}// next i		
				bRoomIsValid=true;
					
			}
		}//end if: valid entRoom
	}// end if: has room in _Map
// if no room can be found fall back to xml based external data (CustID 256)
	if (!bRoomIsValid && _Map.hasMap("Custom"))// version 10.6
	{
		Map mapCustom = _Map.getMap("Custom");
	
	// identify floor
		Group group = el.elementGroup();
		Group grFloor(group.namePart(0) + "\\" + group.namePart(1));
		String sArFloors[] = {"EG","OG","DG"};
		String sFloor = group.namePart(1);
		int nFloor = sArFloors.find(sFloor);
		double dArFloorThickness[]={mapCustom .getDouble("FUSSBODENAB"),mapCustom .getDouble("FUSSBODENAB_OG"),mapCustom .getDouble("FUSSBODENAB_DG")};
		if (nFloor>-1) 
		{
			bDrawRoomAlert=false;// turn off room alert display
			dFloorThickness=dArFloorThickness[nFloor];	
		}	
		
	// get current floor height and calculate offset to base height of wall
	// version value="11.8" date=20dec18" author="thorsten.huck@hsbcad.com"> benutzerdefinierter Versatz von Wänden zur Etagenhöhe wird berücksichtigt
		double dFloorElevation = grFloor.dFloorHeight();
		double dElementElevation = vecY.dotProduct(ptOrg - _PtW);
		mapRoom.setDouble("RoomElevation", dFloorElevation - dElementElevation);	
	}	
	if (mapRoom.length()>0)
	{ 
		mapRoom.setDouble("RoomFloorThickness", dFloorThickness);
		_Map.setMap("Room",mapRoom);		
	}
	else
		_Map.removeAt("Room", true);
		
		
// set floor thickness if custom value is specified
	if (abs(dCustomFloorThickness) > 0) dFloorThickness = dCustomFloorThickness;
		
//End  collect potential links to a room and set dependency to it//endregion 
//End ROOM//endregion 

//region collect zone thickness of relevant side
	double dFrameOffsets[2];
	double dZThisSide,dZOppositeSide;
	// collect thickness from outline to allow disabled zones
	if (nProjectSpecial==1)	
	{
		dZThisSide= el.dPosZOutlineFront();
		dZOppositeSide= -el.dBeamWidth()-el.dPosZOutlineBack();	
		dFrameOffsets[0]= dZThisSide;
		dFrameOffsets[1]= dZOppositeSide;
		if (nSide<1) dFrameOffsets.swap(0,1);		
		bDrawRoomAlert=false;		
	}
	// relay on zone thickness
	else
	{
		for (int i=0; i<5;i++)	
		{
			dZThisSide+=el.zone(nSide*(i+1)).dH();
			dZOppositeSide+=el.zone(-nSide*(i+1)).dH();		
		}
		dFrameOffsets[0]= dZThisSide;
		dFrameOffsets[1]= dZOppositeSide;	
	}		
//End collect zone thickness of relevant side//endregion 

//region Tool requisites
// tool vec
	Vector3d vzT = nSide*vecZ;
	vzT.vis(_Pt0,5);	
	_Map.setVector3d("vzT", vzT);	// publish data
	Vector3d vyT = vecX.crossProduct(-vzT);

// reposition conduit grips in z: 20mm offset to _Pt0
	if (nProjectSpecial==1)
	{
		for (int i=0;i<2;i++)
		{
			if (bDebug) reportMessage("\ntransforming grip xxB " +i);
			_PtG[i].transformBy(vzT*(vzT.dotProduct(_Pt0-_PtG[i])+U(20)));
		}
	}
			
// the tooling location point, relative to _PtG2
	double dYGrip2 = -U(50);// the tool grip is 50mm below _Pt0 in element view
	double dZGrip2 = -(dFrameOffsets[0]+.5*dMillDepthThis);
	if (abs(dZGrip2)<dEps) dZGrip2=-U(50);// the grip should always have an z-offset to the origin
	
	// the grip has an offset, while the ref point does not
	if (bDebug) reportMessage("\ntransforming grip xxC " +nIndexToolLocationGrip);
	_PtG[nIndexToolLocationGrip].transformBy(vecY*(vecY.dotProduct(_Pt0-_PtG[nIndexToolLocationGrip])+dYGrip2)+vzT*(vzT.dotProduct(_Pt0-_PtG[nIndexToolLocationGrip])+dZGrip2 ));
	Point3d ptToolRef= _PtG[nIndexToolLocationGrip]-vecY*dYGrip2-vzT*dZGrip2; // the ptToolRef expresses the dX offset of the tooling to _Pt0 
	//_PtG[2].vis(4); 	ptToolRef.vis(2); 	
	double dXToolRef = vecX.dotProduct(ptToolRef-_Pt0); // the offset from _Pt0 to the location of the wirechase
	
	
// control location of conduit guidelines in dependency of toolRef grip[2]
	if (_Map.hasVector3d("vecPtG2") && _kNameLastChangedProp=="_PtG"+nIndexToolLocationGrip && nProjectSpecial==1)
	{
	// get stored offset
		Point3d ptG2=_PtW+_Map.getVector3d("vecPtG2");
		double dGripMove = vecX.dotProduct(_PtG[nIndexToolLocationGrip]-ptG2);
		if (abs(dGripMove)>dEps)
		{
			if (nMillThisSide>0)_PtG[0].transformBy(vecX*dGripMove);
			if (nMillOppositeSide>0)_PtG[1].transformBy(vecX*dGripMove);		
		}		
	}
	_Map.setVector3d("vecPtG2", _PtG[nIndexToolLocationGrip]-_PtW);
	
	//_PtG[0].vis(1);
	//_PtG[1].vis(2);
		
			


//End Tool requisites//endregion 
	
//region add combinations - Standard Doubleclick Action
	if (_bOnRecalc && (_kExecuteKey==sTriggerAddCombi  || _kExecuteKey==sDoubleClick))
	{
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
		String sSelectedEntry = mapOut.getString("SelectedEntry");
		double dElevationCombination= mapOut.getDouble("Elevation");
		
	// if the selected entry is empty consider this as cancel
		if (sSelectedEntry.length()>0)	
		{
			ptAr.setLength(0);
			Point3d ptIns = _Pt0;
			
		// allow optional point selection to override elevation
			PrPoint ssP(TN("|<Enter> or pick point to overwrite elevation|")+" [" + dElevationCombination +"]",_Pt0+vecY*(dElevationCombination+dFloorThickness)); 
			if (ssP.go()==_kOk) 
			{ // do the actual query
				ptIns = ssP.value(); // retrieve the selected point
				ptIns.transformBy(vzT*vzT.dotProduct(_Pt0-ptIns));// snap to installation XY
				dElevationCombination=vecY.dotProduct(ptIns-ptOrg)-dFloorThickness;
				reportMessage(TN("|Selected Elevation|") + ": " + dElevationCombination);
			}

		// collect combination arguments
			ptAr.append(ptIns);
			ptAr.append(ptIns+vzT*dTxtH);				
	
			entAr.setLength(0);
			entAr.append(_ThisInst);
			mapTsl.setInt("mode",0);

		// send the catalog entry on creation
			mapTsl.setString("CatalogEntry", sSelectedEntry);
	
		// query existing childs
			Map mapChilds = _Map.getMap("Child[]");
			mapTsl.setInt("myIndex", mapChilds.length());
			mapTsl.setInt("wait", true); // send in a flag that the combination will not be deleted when its _Entity does not return the parent tsl during first run
			tslNew.dbCreate(sScriptnameCombi, vUcsX,vUcsY,gbAr, entAr, ptAr, 
				nArProps, dArProps, sArProps,_kModelSpace, mapTsl); // create new instance			
			if (tslNew.bIsValid())
			{	
			// update the child map of the parent
				mapChilds.setEntity(tslNew.handle(),tslNew);
				_Map.setMap("Child[]", mapChilds);
				tslNew.setPropValuesFromCatalog(sSelectedEntry);
				tslNew.setPropDouble(0,dElevationCombination);
				tslNew.recalc();		
			}		
		}
		else
		{
			reportMessage("\nThis should not happen. Please inform hsbCAD Team." + scriptName() + ": Selected entry name not valid.");	
		}	
	}
// END add combinations - Standard Doubleclick Action
		


//End add combinations - Standard Doubleclick Action//endregion 

//region Displays
	Display dp(nColor), dpIcon(nSideColors[0]),dpOpposite(nSideColors[1]),dpPlan(nColor),dpPlanTech(nColor), dpToolInfo(nColor);
	dp.elemZone(el,0,'I');
	dp.textHeight(dTxtH);

	dpToolInfo.elemZone(el,0,'T');
	dpToolInfo.textHeight(dTxtH);

	dpPlan.elemZone(el,0,'I');
	dpPlan.addViewDirection(_ZW);
	dpPlan.textHeight(dTxtH);
	
	dpPlanTech.elemZone(el,0,'I');
	dpPlanTech.addViewDirection(_ZW);
	if (nProjectSpecial==1)dpPlanTech.showInDispRep("LUX AV");
	dpPlanTech.textHeight(dTxtH);
		
	dpIcon.addHideDirection(-vecZ);
	dpIcon.addHideDirection(vecY);
	dpIcon.elemZone(el,0,'I');
	dpIcon.textHeight(dTxtH);
	
	dpOpposite.addViewDirection(-vecZ);
	dpOpposite.addHideDirection(vecY);	
	dpOpposite.elemZone(el,0,'I');
	dpOpposite.textHeight(dTxtH);		


//End Displays//endregion 

//region Draw 1
// draw a line from the insertion point to the closest point on the frame. when the offset is <=0
	{
		double d = dFrameOffsets[0];
		if (d<=0) d= U(30);
		if (nProjectSpecial==0) // requested by FW version 6.9
		{
			d=(el.dPosZOutlineFront()-el.dPosZOutlineBack())/2;
			if (nMillThisSide==0 && nMillOppositeSide==0)
			{
				dpIcon.color(nColor);
				dpIcon.draw(PLine(_Pt0,_Pt0-vecY*U(50)));
				dpIcon.color(nSideColors[0]);	
			}	
		}
		dp.draw(PLine(_Pt0, _Pt0-vzT*d));
	}

// draw missing room link
	if (bDrawRoomAlert && dCustomFloorThickness==0) dpToolInfo.draw(T("|Room ?|"), _Pt0, vecY.crossProduct(-vzT),vzT,0,2,_kDeviceX);		
	dpToolInfo.color(253);
	dpToolInfo.textHeight(dTxtH*.5);

// draw custom floor height
	{ 
		String k;
		k = "CustomFloorThickness"; if (_Map.hasDouble(k))dCustomFloorThickness = _Map.getDouble(k);
		if (abs(dCustomFloorThickness)>0)
			dpToolInfo.draw(dCustomFloorThickness, _Pt0, vzT.crossProduct(vecY), vzT, 0, 1.2);
	}



//End Draw 1//endregion 

		


//End Part 3//endregion 

//{ 
//	// remote grip repositioninng per side
//		int nThisDir=1;
//		for (int s = 0; s < 2; s++)
//		{
//			Vector3d vecSide = (s == 0)?vecZ :- vecZ;
//			int bDebugThis = true;
//			if (bDebugThis)reportMessage("\n" + " Starting Side "+ s + " (" + tslChilds.length() + ") childs to sort");
//			Point3d ptRefSide = el.ptOrg();
//			if (s == 1)ptRefSide .transformBy(vecSide * el.dBeamWidth());
//			
//			ptRefSide.vis(s);
//			
//			TslInst tsls[0];
//			tsls = 	tslChilds;
//			for (int i = tsls.length() - 1; i >= 0; i--)
//			{
//				TslInst tsl = tsls[i];
//				
//			// get childs grips and check if _PtG0 is on same side
//				Point3d pt0 = tsl.gripPoint(0);
//				double dFaceOffset = vecSide.dotProduct(pt0 - ptRefSide);
//				pt0.vis(dFaceOffset<0?1:3);
//			}
//			nThisDir*=-1;
//			if (bDebugThis)reportMessage("\n" + "   Side "+ s + " sorted\n");
//		}// next s side	
//}

//region combination symbol sorting
	if((bAlignCombinationSymbols && (_Map.getInt("numChilds")==tslChilds.length() && tslChilds.length()>1))|| _bOnDebug)//|| _bOnDebug || (_Map.getInt("numChilds")==tslChilds.length() && tslChilds.length()>1 && !_bOnRecalc))
	{
	// #1
		int bDebugThis = true;
		if (bDebugThis)reportMessage("\n" + "Combination symbol sorting childs ("+ tslChilds.length()+")");	

	// order childs by elevation
		int nChildOrder = 1;
		if (nProjectSpecial==1) nChildOrder=-1;
		
	// remote grip repositioninng per side
		int nThisDir=1;
		for (int s=0;s<2;s++)
		{	
			if (bDebugThis)reportMessage("\n" + "   Starting Side "+ s + " (" + tslChilds.length() + ") childs to sort");
			Vector3d vecSide = vecZ;
			Point3d ptRefSide = el.ptOrg();
			if (s==1)
			{ 
				vecSide *= -1;
				ptRefSide .transformBy(vecSide*el.dBeamWidth());
			}
			//vecSide.vis(ptRefSide,s);

		// get copy and filter
			TslInst tsls[0];
			tsls = 	tslChilds;
			for (int i=tsls.length()-1;i>=0; i--)
			{
				TslInst tsl = tsls[i];
				
//			// remove from set if this child is not on the test side s, 0=icon side, 1 = opposite
//				Map mapChild = tsl.map();
//				int bChildFlip = mapChild.getInt("flip");
//				int bRemoveByBase = (s==0 && bChildFlip) || (s==1 && !bChildFlip);
				
			// get childs grips and check if _PtG0 is on same side
				Point3d pt0 = tsl.gripPoint(0);
				double dFaceOffset = vecSide.dotProduct(pt0 - ptRefSide);
				if (dFaceOffset < 0)// || (!bRemoveByGrip && bRemoveByBase))
				{
					if (bDebugThis)reportMessage("\n" + "   removing i "+ i + " (" + tsls[i].handle()+") of side s:"+ s +" elevation: " + tsl.propDouble(0));	
					tsls.removeAt(i);	
				}
			}			
			
			for (int i = 0; i < tsls.length(); i++)	
				for (int j = 0; j < tsls.length()-1; j++)	
				{
					double d1 = tsls[j].propDouble	(0);
					double d2 = tsls[j+1].propDouble(0);
					if ((d1<d2 && nChildOrder==-1) || (d1>d2 && nChildOrder==1) )
						tsls.swap(j,j+1);
				}
				
			if (bDebugThis)reportMessage("\n" + "   Side "+ s + " " + tsls.length() + " to sort");	

		// set a flag which would stop the sorting
			int bStopSorting;		
	
			Point3d ptChildGrips[0];
			{
				PLine plFrames[0];
				Vector3d vecZGripOffset = vecSide*dTxtH;// nThisDir*vzT
				for (int i = 0; i < tsls.length(); i++)
				{				
					Point3d ptGrip = tsls[i].gripPoint(0);
					
				// validate frame, the positioning of the grips is based on the frame around the previous combination symbols
					PLine plFrame;
					if (!tsls[i].map().hasPLine("plFrame"))
					{
						bStopSorting=true;
						break;	
					}
					else
						plFrame= tsls[i].map().getPLine("plFrame");
					
					
				//// scale frame if scale factor is set in settings: this will adjust the offset between symbols in plan view
					if(dCombinationSymbolOffsetScale>0)
					{
						if (bDebugThis)reportMessage("\n" + "     scaling with factor "+ dCombinationSymbolOffsetScale);
						LineSeg segFrame = PlaneProfile(plFrame).extentInDir(vecZ);
						double dZFrame = abs(vecZ.dotProduct(segFrame.ptStart()-segFrame.ptEnd()));
						double dScale = dCombinationSymbolOffsetScale ;
						Point3d ptMidFrame; ptMidFrame.setToAverage(plFrame.vertexPoints(true));
						CoordSys csScale;
						csScale.setToAlignCoordSys(ptMidFrame, vecX,vecY,vecZ,ptMidFrame-vecZ*nThisDir*.5*(dScale -1)*dZFrame , vecX*dScale ,vecY*dScale ,vecZ*dScale);
						plFrame.transformBy(csScale);
					}
					plFrames.append(plFrame);
					ptChildGrips.append(ptGrip);
				}
				if (bDebugThis)reportMessage("\n" + "      grips collected: "+ ptChildGrips.length() + " bStopSorting: " + bStopSorting);
				
			// init the reference with _Pt0 of the installation point
				if(!bStopSorting)
				{
					//Point3d pt =ptRefSymbolAlignment-vecZ*vecZ.dotProduct(ptRefSide-ptRefSymbolAlignment) ;// _Pt0;
					Point3d pt =ptRefSide+vecSide * (s==0?el.dPosZOutlineFront():abs(el.dPosZOutlineBack())-el.dBeamWidth()) ;
					pt.vis(s + 6);
					
					for (int i = 0; i < ptChildGrips.length(); i++)
					{
						Point3d ptGrip =tsls[i].gripPoint(0);;// get the current grip location
						PLine plFrame= plFrames[i];	
	
						if (i==0)// the first combination receives the standard offset
							pt = tsls[i].ptOrg()+vecSide*(vecSide.dotProduct(pt-tsls[i].ptOrg())+dTxtH);
						else
						{	
							PLine plPreviousFrame = plFrames[i-1];
							plPreviousFrame.projectPointsToPlane(Plane(tsls[i].ptOrg(),vecY),vecY);
							pt = plPreviousFrame.closestPointTo(pt+vecSide*U(10000));
							
							if (0)
							{
								EntPLine epl;
								epl.dbCreate(plPreviousFrame);
								epl.setColor(i);
								epl.assignToElementGroup(el,true,0,'Z');
							}
						}	

						Vector3d vecGrid = pt-ptGrip;
						//vecGrid*=2;
						
						pt.transformBy(vecZGripOffset);
						plFrame.transformBy(vecGrid);
						ptChildGrips[i].transformBy(vecGrid);
						plFrames[i]=plFrame;
						if (bDebugThis){plFrame.vis(i);		ptChildGrips[i].vis(i);}
					}

					if (!_bOnDebug || bAlignCombinationSymbols)
					{
						for (int i = 0; i < tsls.length(); i++)
						{
							//reportMessage("\n forcing i: "+i);
							Map map = tsls[i].map();
							map.setPoint3d("remoteGrip", ptChildGrips[i]);
							map.setInt("remoteGripIndex", 0);
							tsls[i].setMap(map);
							tsls[i].transformBy(Vector3d(0,0,0));
							
						// update potential annotations
							Entity entAnno = map.getEntity("Annotation");
							TslInst tslAnno =(TslInst)entAnno;
							if (map.hasPoint3d("ptPlanAnnotationRef"))
								 tslAnno.setPtOrg(map.getPoint3d("ptPlanAnnotationRef"));

							entAnno = map.getEntity("AnnotationElement");
							tslAnno =(TslInst)entAnno;
							if (tslAnno .bIsValid())tslAnno.recalc();	
						}
					}
				}// END IF(!bStopSorting)				
			}
			nThisDir*=-1;
			if (bDebugThis)reportMessage("\n" + "   Side "+ s + " sorted\n");
		}// next s side	
		
	// prior 6.3 this statement was also checkiing against the stopSorting!=true	
		if (!_bOnDebug)
		{
			if (bDebugThis)reportMessage("\n" + "      disable alignCombi "+ _Map.getInt("AlignCombinationSymbols"));
			_Map.setInt("AlignCombinationSymbols",false)	;
		}
		
	}// END IF combination symbil alignment
		
			


//End combination symbol sorting//endregion 

	
	_Map.removeAt("ChildLocationsBeforeSplit", true);
	ptChilds = nProjectSpecial==1?Line(_Pt0,-vecY).orderPoints(ptChilds):Line(_Pt0,vecY).orderPoints(ptChilds);;
	int bHasChild = ptChilds.length() > 0;
	//for (int i = 0; i < ptChilds .length(); i++)	ptChilds[i].vis(i); 
	//if (bDebug && ptChilds.length()<1)reportMessage("\n**** no ptChilds from map " + mapChilds);

// ring declaration
	PLine plRings[0];
	int bIsOp[0];	


// declare relevant zone indices. these zones are used to collect relevant genbeams to keep _GenBeam as small as possible
	int nZones[0];
	
// collect by installation point properties
	for (int i = -5;i<6;i++)
	{
		ElemZone ez = el.zone(i);
		if (ez.dH()<dEps)continue;
		
		if ((nMillThisSide>0 || bAddToolTopIcon || bAddToolBottomIcon) && i*nSide>0)
			nZones.append(i);
		else if ((nMillOppositeSide >0 || bAddToolBottomOpposite|| bAddToolBottomOpposite)&& i*nSide<0)
			nZones.append(i);		
	}
	
/// collect by associated childs
	for (int t=0;t<tslChilds.length();t++)
	{
	// get relative zone
		int nRelativeZone = tslChilds[t].propInt(2);
	//check side of child
		Map map = mapChildMaps[t];
		Vector3d vecZChild = map.getVector3d("vzE");	
		int nChildSide = nSide;
		if (!vecZChild.bIsZeroLength() && !vecZChild.isCodirectionalTo(vzT))
			nChildSide*=-1;
	
		int nThisZone = nChildSide*nRelativeZone;
		if (nRelativeZone<99 && nZones.find(nThisZone)<0)
			nZones.append(nThisZone);
		else
		{
			for (int i = 1;i<6;i++)
			{
				int n = i*nChildSide;
				ElemZone ez = el.zone(n);
				if (ez.dH()<dEps || nZones.find(n)>-1)continue;
				nZones.append(n);	
			}			
		}				
	}
	
// collect GenBeams and contour of zone 0
	GenBeam gbAll[0],gbsZone0[0];
	PlaneProfile ppZ0;
	PLine plContour0;
	Plane pnZ(_Pt0,vecZ);
	gbAll = el.genBeam();
	
	// test for any sloped beam in zone 0 and collect indices of it
	// (the zone 0 detection could fail for some birdsmouth alike connections in gable walls)
	int nSlopedBeamIndex[0];
	Beam beamsZone0[0];
	Body bodiesZone0[0];		
	PlaneProfile ppSlopedEnvelopes[0];
	for (int i=gbAll.length()-1; i>=0;i--)	
	{
		GenBeam gb = gbAll[i];
		int bIsBeam = gb.bIsKindOf(Beam());
		int nZoneIndex = gb.myZoneIndex();
		
	// skip dummies and items of irrelavant zones
		if (gb.bIsDummy() || (!bIsBeam  && nZones.find(nZoneIndex)<0))
		{
			if (nDebugTest==1)reportNotice("\nSkip " + gb.material() + " Dummy(" + gb.bIsDummy() + ") in zone " + nZoneIndex);
			gbAll.removeAt(i);
			continue;	
		}
		
	// collect zone 0
		if (nZoneIndex ==0 && bIsBeam)
		{
			beamsZone0.append((Beam)gb);
			Vector3d vxThis = gb.vecX();
		// sloped beam
			if (!vxThis.isParallelTo(vecY) && !vxThis.isPerpendicularTo(vecY))
			{
				nSlopedBeamIndex.append(beamsZone0.length()-1);	
//				ppSlopedEnvelopes.append(gb.envelopeBody().shadowProfile(pnZ));
				ppSlopedEnvelopes.append(calcPpOptimised(gb,pnZ));

			}
		}
//		else if (nZoneIndex==-1 && i==18)
//		{ 
//			PLine(ptOrg, gb.ptCen()).vis(i-15);
//		}
	}
	if (nDebugTest==1) reportNotice("\ngbAll.length = "+ gbAll.length());

//// append filtered set correspoinding to the current toolsides
	//if (_GenBeam.length()<1 && gbAll.length()>0)
	//{
		//_GenBeam.append(gbAll);
	//}
	
	PlaneProfile ppsZ_Zone0[0];
	for (int i=0; i<beamsZone0.length();i++)
	{
		GenBeam gb=beamsZone0[i];
		Vector3d vxThis = gb.vecX();
		gbsZone0.append(gb);
		PlaneProfile pp;
		Body bd;
		if (nSlopedBeamIndex.length()>0)
		{
			bd=gb.envelopeBody();
			pp=bd.shadowProfile(pnZ);
		}
		else
		{
			bd=gb.envelopeBody(false,true);//realBody();// version 10.1
			pp=calcPpOptimised(gb,pnZ);
		}
		
		bodiesZone0.append(bd);	
//		pp=bd.shadowProfile(pnZ);
		ppsZ_Zone0.append(pp);
		pp.shrink(-dEps);// Version 3.3	
			
	// if there is a sloped connection make sure that the resulting pp of the male is stretched to the center plane of the female	
		for (int e=0;e<ppSlopedEnvelopes.length();e++)
		{
			if (nSlopedBeamIndex.find(i)>-1)continue;
			PlaneProfile ppSloped =ppSlopedEnvelopes[e];
			ppSloped.intersectWith(pp);
			if (ppSloped.area()>pow(dEps,2))
			{
				Vector3d vecStretch = vecY;
				LineSeg seg = ppSloped.extentInDir(vecX);
				if (vecStretch.dotProduct(seg.ptMid()-gb.ptCen())<0)vecStretch*=-1;				
				vecStretch.normalize();
				seg.vis(3);
				double dExtensionX = abs(vxThis.dotProduct(seg.ptStart()-seg.ptEnd()));
				double dExtensionY = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
				PlaneProfile ppCopy = pp;
				ppCopy.transformBy(vecStretch *dExtensionX *2);
				//ppCopy.vis(2);
				pp.unionWith(ppCopy);				
				//pp.vis(3);
				break;
			}
		}
		if (ppZ0.area()<pow(dEps,2))
			ppZ0 = pp;
		else
			ppZ0.unionWith(pp);	
	}
	ppZ0.shrink(dEps);// Version 3.3
	//ppZ0.transformBy(vecZ*U(1300));
	//ppZ0.vis(4);
	//dp.draw(ppZ0,_kDrawFilled);

// collect all horizontal beams
	Beam bmHorizontals[] = vecY.filterBeamsPerpendicularSort(beamsZone0);



// get envelope
	if (ppZ0.area()>pow(dEps,2))
	{	
	// merge 
		PlaneProfile pp = ppZ0;
		pp.shrink(-U(100));
		pp.shrink(U(100));
		plRings=pp.allRings();
		bIsOp=pp.ringIsOpening();
	// get envelope
		for (int r=0; r<plRings.length(); r++)
		{
			if (!bIsOp[r] && plContour0.area()<plRings[r].area())
				plContour0=plRings[r];
		}
	}		
// fall back to element envelope if no beams found
	if (plContour0.area()<pow(dEps,2))
	{
		if (bDebug)reportMessage("\n   falling back to element contour");
		ppZ0 = PlaneProfile(el.plEnvelope());
		plContour0 = el.plEnvelope();
	}
	plContour0.vis(3);
	//dp.draw(plContour0);

// declare a collection range to limit the entities which need to be processed
	PlaneProfile ppCollect;
	double dCollectWidth =U(700);

// Frame toolings
	double dMillWidth = dMillWidthThis;
	double dMillDepth= dMillDepthThis;
	if(bIsRub && dMillDepth==U(32))
	{ 
		// HSB-22947
		dMillDepth=U(32.01);
	}
	int nMillSide = nMillThisSide;
	int nConduits = nConduitsThis;
	int nFlip=1;
	Point3d ptMillRef = ptToolRef - vzT*dFrameOffsets[0];
	int nMaxNNZone = 5;
	if (nProjectSpecial==0)nMaxNNZone=1;
	
	Point3d ptsConduitExtremes[0];
	int bConduitGripThisSideAdjusted=_Map.getInt("ConduitGripThisSideAdjusted"); // the relocation of the conduit grips does not work on dbCreated, force repositionining at least once
	int bConduitGripOtherSideAdjusted=_Map.getInt("ConduitGripOtherSideAdjusted"); 
	PLine plConduitThis, plConduitOpp;
	

//region Special milling width for headers exceeding defined dimensions (Lux)
	Beam bm60Headers[0];
	if (nProjectSpecial==1)
	{ 
		for (int i=0;i<gbsZone0.length();i++) 
		{ 
			Beam b = (Beam)gbsZone0[i];
			if (b.vecX().isParallelTo(vecX) && b.dH()>=U(200) && b.dW()>=U(200))
				bm60Headers.append(b);
		}//next i		
	}
//endregion 

// hardware collection
	HardWrComp hwcs[0];
	
// Add beamcuts and display, loop both sides
	for (int x=0; x<2;x++)
	{
		Point3d ptsMill[0];
		
	//region order child elevations due to wirechase orientation
		for (int i=0;i<dChildElevations.length();i++)
			for (int j=0;j<dChildElevations.length()-1;j++)
			{
				double d1 = dChildElevations[j];
				double d2 = dChildElevations[j+1];
			// bottom
				if (d1>d2 && nMillSide==1)dChildElevations.swap(j,j+1);
			// top
				if (d2>d1 && nMillSide==2)dChildElevations.swap(j,j+1);
			}			
	//End order child elevations due to wirechase orientation//endregion 	
		
		//if (bDebug)reportMessage("\n\nptChilds: "  + ptChilds.length() + " at x=" + x + " exeCount= " + insertCycleCount());		
		if (dMillWidth>0)// Version 5.8, requested FW && dMillDepth>0)
		{
			//ptMillRef.vis(3);
			double dGripZ;
			
		// the beams to be tooled, might be modified depending on attached childs/ tube conditions
			GenBeam gbsWirechase[0];
			gbsWirechase = gbsZone0;			
			
		//region get min max at insertion point
			Point3d ptMinMax[0];
			ptMinMax.append(plContour0.intersectPoints(Plane(ptToolRef-vecX*.5*dMillWidth,vecX)));
			ptMinMax.append(plContour0.intersectPoints(Plane(ptToolRef+vecX*.5*dMillWidth,vecX)));
			ptMinMax = Line(ptToolRef,vecY).orderPoints(Line(ptToolRef,vecY).projectPoints(ptMinMax));
			
		// project to plane
			for (int p=0; p<ptMinMax.length();p++)
			{
				ptMinMax[p].transformBy(vzT*vzT.dotProduct(ptMillRef-ptMinMax[p]));
			}
			if(ptMinMax.length()<1)continue;
			Point3d ptMidX; ptMidX.setToAverage(ptMinMax);				
		//End get min max at insertion point//endregion 
		
		// bottom
			if(nMillSide ==1)
			{	
				if (bHasChild)//only valid if childs are present
				{
					dGripZ = (ptOrg.Z()+dChildElevations[0] +ptChilds[0].Z())/2; 
				// inverse order of childs for project special 1: version  value="3.9"
					if (nProjectSpecial==1)
						pt= ptChilds[0];
					else
						pt = ptChilds[ptChilds.length()-1];
				}
				else
				{
					dGripZ = ptMidX.Z();
					pt = ptMidX;
				}
					
				ptsMill.append(ptMinMax[0]);
				pt.transformBy(vecX*vecX.dotProduct(ptMillRef-pt)+vecZ*vecZ.dotProduct(ptMillRef-pt));

			// extent wirechase to the highest point of linked combination	
				if (bHasChild && bExtentWirechase)
				{	
					PLine pl =mapChildMaps[mapChildMaps.length()-1].getPLine("plNN");pl.vis(4);
					Point3d pts[] = Line(_Pt0, vecY).orderPoints(pl.vertexPoints(true));
					if (pts.length()>0)pt.transformBy(vecY*(vecY.dotProduct(pts[pts.length()-1]-pt)+dExtentWirechaseOffset));
				}
				ptsMill.append(pt);
				dpPlanTech.color(90);
			} 
		// top	
			else if(nMillSide ==2)
			{
				if (bHasChild)//only valid if childs are present
				{ 
					dGripZ = (ptOrg.Z()+dChildElevations[0] +ptMinMax[ptMinMax.length()-1].Z())/2; 
				// inverse order of childs for project special 1: version  value="3.9"
					if (nProjectSpecial==1)
						pt= ptChilds[ptChilds.length()-1];
					else
						pt = ptChilds[0];					
				}
				else
				{
					dGripZ = ptMidX.Z();
					pt = ptMidX;
				}
				pt.transformBy(vecX*vecX.dotProduct(ptMillRef-pt)+vecZ*vecZ.dotProduct(ptMillRef-pt));
		
			// extent wirechase to the highest point of linked combination	
				if (bHasChild && bExtentWirechase)
				{	
					PLine pl =mapChildMaps[mapChildMaps.length()-1].getPLine("plNN");pl.vis(4);
					Point3d pts[] = Line(_Pt0, vecY).orderPoints(pl.vertexPoints(true));
					if (pts.length()>0)pt.transformBy(vecY*(vecY.dotProduct(pts[0]-pt)-dExtentWirechaseOffset));
				}
				ptsMill.append(pt);
				ptsMill.append(ptMinMax[ptMinMax.length()-1]);
				dpPlanTech.color(10);
			}
		// both
			else if(nMillSide ==3)
			{
				dGripZ = ptOrg.Z()+dAverageChildElevation;
				ptsMill.append(ptMinMax[0]);
				ptsMill.append(ptMinMax[ptMinMax.length()-1]);
				dpPlanTech.color(252);
			}
		// bottom or top, no childs
			else if((nMillSide ==2 || nMillSide ==1) && ptChilds.length()==0 && ptMinMax.length()>1)
			{
				dGripZ = ptOrg.Z()+dAverageChildElevation;
				Vector3d vecLine;
				Point3d ptX;
			// bottom
				if(nMillSide ==1)
				{
					ptX=ptMinMax[ptMinMax.length()-1];					
					vecLine = -vecY;
				}
			//top
				else
				{
					ptX=ptMinMax[0];
					vecLine = vecY;
				}
							
			// check if this wirechase would intersect a window
				Opening ops[] = el.opening();	
				Point3d ptsOp[0];
				for (int o=0;o<ops.length();o++)
				{
					PLine pl = ops[o].plShape();
					ptsOp.append(pl.intersectPoints(Plane(ptMillRef,vecX)));	
				}
				ptsOp = Line(ptMillRef,-vecLine).orderPoints(ptsOp);
				if (ptsOp.length()>0)
				{
					ptX = ptsOp[0];
					
				}

				{
					Beam beams[] = Beam().filterBeamsHalfLineIntersectSort(beamsZone0,ptX-nFlip*vecZ*.5*el.dBeamWidth(),vecLine);
					if (beams.length()>0)	ptX.transformBy(vecLine*beams[0].dD(vecLine));
				}
				
				ptX.transformBy(vecZ*vecZ.dotProduct(ptMillRef-ptX));
				ptsMill.append(ptX);
			
			// get the mid point between the extremes	
				Point3d ptMillMid;
				ptMillMid.setToAverage(ptMinMax);//			ptMillMid.vis(94);
			
			// find outer intersecting beam
				{
					double d = .5*dMillDepth;
					if (d<dEps)d=U(10); // assume that it would find an intersection in this plane
					vecLine.vis(ptMillRef,2);
					Beam beams[] = Beam().filterBeamsHalfLineIntersectSort(beamsZone0,ptMillMid-vzT*d,vecLine);//ptMillRef -> Version 7.5 no tooling for bottom or top beams
				
				 //remove verticals, verticals could be collected if the reference point is far outside or at the edge of the element	// version 10.7 // 10.8 complete removal avoided
					Beam beams2[0]; beams2=beams;
					for (int b=beams2.length()-1;b>=0;b--)
						if (beams2[b].vecX().isParallelTo(vecY))
							beams2.removeAt(b);
							
					if (beams2.length()>0)
					{
						gbsWirechase.setLength(0);
						for (int b=0;b<beams.length();b++)
							gbsWirechase.append(beams[b]);
						Beam bm = beams2[beams2.length()-1];
						bm.realBody().vis(5);
						Plane pn(bm.ptCen(),bm.vecD(vecLine));
						Point3d ptLR[0];
						ptLR.append(Line(ptMillRef-vecX*.5*dMillWidth, vecLine).intersect(pn, .5*bm.dD(vecLine)));
						ptLR.append(Line(ptMillRef+vecX*.5*dMillWidth, vecLine).intersect(pn, .5*bm.dD(vecLine)));
						ptLR = Line(ptMillRef,vecLine).orderPoints(ptLR);
						if (ptLR.length()>0)
						{
							pt = ptsMill[0];
							pt.transformBy(vecY*vecY.dotProduct(ptLR[0]-pt));
						}
						pt.vis(3);	
						ptsMill.append(pt);
					}
				}
			}	

		// get repos flag
			int bRepos;
			if(x==0 && !bConduitGripThisSideAdjusted && ptsMill.length()>1 && _PtG.length()>x && ptChilds.length()>0 && !_bOnDbCreated)
			{
				bRepos=true;
				bConduitGripThisSideAdjusted=true;
				_Map.setInt("ConduitGripThisSideAdjusted",bConduitGripThisSideAdjusted); 	
			}
			if (x==1 && !bConduitGripOtherSideAdjusted && ptsMill.length()>1 && _PtG.length()>x && ptChilds.length()>0&& !_bOnDbCreated)
			{
				bRepos=true;
				bConduitGripOtherSideAdjusted=true;
				_Map.setInt("ConduitGripOtherSideAdjusted",bConduitGripOtherSideAdjusted); 	
			}
			
		// on creation adjust vertical conduit grip location
			if((_bOnDebug || bRepos) && _PtG.length()>x) 
			{
				_PtG[x].setZ(dGripZ);
			}
	
			
		// validate tool points	
			//if (bDebug)reportMessage("\nptsMill: "  + ptsMill.length());		
			if (ptsMill.length()>1 && Vector3d(ptsMill[1]-ptsMill[0]).length()>dEps)
			{
			// Beamcut
				double dZBc = dMillDepth+dConduitExtraDepth;
			// custom depth extension: the DN (20,25 or 32) remains but the depth of the milling needs to be extended
				//if (mapSettings.hasString("Group"))
				if (nProjectSpecial==1 && (dMillDepth==U(20) || dMillDepth==U(25) || dMillDepth==U(32))) dZBc +=U(1);					
				Point3d ptBc =(ptsMill[0]+ptsMill[1])/2; ptBc .vis(3);
				double dL = abs(vecY.dotProduct(ptsMill[0]-ptsMill[1]));

				if (dMillWidth>dEps && dL>dEps && dZBc>dEps)
				{
				// Differentiate tooling dimension for special header sizes
					if (bm60Headers.length()>0 && dMillWidth<U(61))
					{
						for (int jj=gbsWirechase.length()-1; jj>=0 ; jj--)
							if (bm60Headers.find(gbsWirechase[jj])>-1)
								gbsWirechase.removeAt(jj);
										
						BeamCut bc(ptBc,vecX,nFlip*vyT,nFlip*vzT,U(61),dL, dZBc *2,0,0,0 );
						bc.addMeToGenBeamsIntersect(bm60Headers);
						bc.cuttingBody().vis(3);
					}
					
				// Default
					if (gbsWirechase.length()>0)
					{ 
						BeamCut bc(ptBc,vecX,nFlip*vyT,nFlip*vzT,dMillWidth,dL, dZBc *2,0,0,0 );
//						bc.addMeToGenBeamsIntersect(gbsWirechase);
						//bc.cuttingBody().vis(x);	
						// HSB-19502
						int nSkewBc;
						if(mapSkewedMilling.length()>0)
						{ 
							if(mapSkewedMilling.getInt("isActive"))
							{ 
								// active flag
								String sWallCode=mapSkewedMilling.getString("WallCode");
								// HSB-19502 walls where it applies
								if (sWallCode.length()>0)
								{ 
									String sWallCodes[]=sWallCode.tokenize(";");
									if(sWallCodes.findNoCase(el.code(),-1)>-1)
									{ 
										nSkewBc=true;
									}
								}
								else
								{
									// no wall code given. applies to all walls
									nSkewBc=true;
								}
							}
						}
						if(!nSkewBc)
						{
							bc.addMeToGenBeamsIntersect(gbsWirechase);
						}
						else
						{ 
							// remove bottom plate
							Beam bmBottom;
							{ 
								Point3d ptMillMid;
								ptMillMid.setToAverage(ptMinMax);
								double d = .5*dMillDepth;
								if (d<dEps)d=U(10);
								Beam beams[] = Beam().filterBeamsHalfLineIntersectSort(beamsZone0,ptMillMid-vzT*nFlip*d,-vecY);
								
								if(beams.length()>0)
								{ 
									bmBottom=beams[beams.length()-1];
									bmBottom.envelopeBody().vis(5);
								}
								GenBeam _gbsWirechase[0];
								_gbsWirechase.append(gbsWirechase);
								if(_gbsWirechase.find(bmBottom)>-1)
									_gbsWirechase.removeAt(_gbsWirechase.find(bmBottom));
								// dont apply to bottom plate
								bc.addMeToGenBeamsIntersect(_gbsWirechase);
							}
							// add skew beamcut
							{ 
								Point3d _ptBc=ptBc;
								_ptBc+=vecY*vecY.dotProduct(bmBottom.ptCen()+bmBottom.vecD(vecY)*.5*bmBottom.dD(vecY)-_ptBc);
								Vector3d vecYt=(_ptBc-nFlip*vzT*dZBc)-(_ptBc-vecY*bmBottom.dD(vecY));
								vecYt.normalize();
								
								Vector3d vecZt=vecX.crossProduct(vecYt);
								vecZt.normalize();
								if(vecZt.dotProduct(vzT*nFlip)<0)vecZt*=-1;
								Vector3d vecXt=vecYt.crossProduct(vecZt);
								
								BeamCut bcSkew(_ptBc-nFlip*vzT*dZBc,vecXt,vecYt,vecZt,
									dMillWidth,U(1000),U(300),0,0,1);
//								bcSkew.cuttingBody().vis(4);
								bmBottom.addTool(bcSkew);
							}
						}
					}

				}	
			
			// no nail and collection range
				PLine pl;
				pl.createRectangle(LineSeg(ptBc-.5*(vecX*dMillWidth+nFlip*vyT*dL), ptBc+.5*(vecX*dMillWidth+nFlip*vyT*dL)),vecX,nFlip*vyT);
				if (ppCollect.area()<pow(dEps,2))
					ppCollect = PlaneProfile(pl);
				else
					ppCollect.joinRing(pl,_kAdd);	
				
				
				if (_bOnDebug){pl.transformBy(vecZ*U(500));pl.vis(x);pl.transformBy(vecZ*-U(500));}
			
			// display net noNail if flagged in settings
				if (bDrawWirechaseOutline)
				{
					int c = nSideColors[0];
					if (nSide*nFlip<0)c=nSideColors[1];
					dp.color(c);
					dp.draw(pl);
					dp.color(nColor);	
				}	

				
			// run intersection test with all horizontal beams for zone 1, projectSpecial ==0	
				// custom requirement: no nail areas only in zone 1 and -1. for zone 1 consider only intersections with any horizontal beam as no nail area
				PLine plNNs[0];
				int bRunIntersection;
				if(nNoNailMode==1 && beamsZone0.length()>0 && bmHorizontals.length()>0)
					bRunIntersection=true;
				else if (nNoNailMode==2 && nSide*nFlip>0 && beamsZone0.length()>0 && bmHorizontals.length()>0)
					bRunIntersection=true;				
				//if (nProjectSpecial==0 && nSide*nFlip>0 && beamsZone0.length()>0 && bmHorizontals.length()>0)
				if (bRunIntersection)
				{
					for (int b=0;b<bmHorizontals.length();b++)
					{
						int n = beamsZone0.find(bmHorizontals[b]);
						PlaneProfile pp;
						if (n>-1)
						{
							pp=ppsZ_Zone0[n];
						}
						else
						{
//							pp = bmHorizontals[b].envelopeBody().shadowProfile(pnZ); // just a fall back
							pp=calcPpOptimised(bmHorizontals[b],pnZ);
						}
						pp.intersectWith(PlaneProfile(pl));
						if (pp.area()>pow(dEps,2))
						{
							PLine plInt;
							LineSeg seg = pp.extentInDir(vecX);
							plInt.createRectangle(seg,vecX,vecY);
							plNNs.append(plInt);	
						}	
					}						
				}
				else
				{
					plNNs.append(pl);	
				}
				
			//if (bDebug)reportMessage("\ngbAll: "  + gbAll.length());
				if (gbAll.length()>0 && dMillDepth>dEps)
				{
					for (int i=0; i<nMaxNNZone;i++)
					{
						int nZoneNN = nSide*nFlip*(i+1);
						if (el.zone(nZoneNN).dH()>dEps)
						{
							for (int r=0; r<plNNs.length();r++)
							{
								ElemNoNail elNN(nZoneNN,plNNs[r]);
								el.addTool(elNN);	
							}
						}	
					}
				}
				//else
				//	dp.draw(pl);

			// display vertical conduits line
				if (nConduits>0 || nProjectSpecial==0)
				{
					
					if ((nSide==1 && x==0)|| (nSide==-1 && x==1))
					{
						dp.lineType("Continuos");	
					}
					else if ((nSide==-1 && x==0) || (nSide==1 && x==1))
					{
						dp.lineType(sLineTypeHidden);	
					}
					double dX=U(5), dY=U(5);
				// adjust the delta offset of the conduit pline if the grip location is not near the conduit pline	
					if (_PtG.length()>x)
					{
						ptToolRef.vis(1);
						_PtG[x].vis(x);
						double dX2 = vecX.dotProduct(_PtG[x]-ptToolRef);	
						int nSgn = 1;
						if (dX2!=0)nSgn=(abs(dX2)/dX2);	
						dX*=nSgn;		
						if(abs(dX2) >1.5*dMillWidth) 
							dX = dX2;
						else if (dL<=2*dX || dMillWidthThis<=0 || dMillWidthOpposite<=0)
							dX=0;	
						if (abs(dX)<U(100))dY=abs(dX);
						else dY=U(100);
					}
					
					PLine plConduit(vecZ), plConduitGuide(vecZ);
					plConduit.addVertex(ptsMill[0]);
					plConduitGuide.addVertex(ptsMill[0]);

					if(abs(dX)>dEps) plConduit.addVertex(ptsMill[0]+vecX*dX+vecY*dY);
					if(abs(dX)>dEps) plConduit.addVertex(ptsMill[1]+vecX*dX-vecY*dY);
					plConduit.addVertex(ptsMill[1]);
					plConduitGuide.addVertex(ptsMill[1]);
					
					// version ="4.0" date="14feb13", required by FW
					if(nProjectSpecial==1)dp.draw(plConduit);	
					if (x==0) plConduitThis = plConduit;
					else if (x==1) plConduitOpp = plConduit;
					
				// in case of a tool ref offset defined by the user add horizontal conduits and its toolings
					if (abs(dXToolRef)>U(10))
					{
						for (int p=0;p<ptChilds.length();p++)
						{
							Point3d pt1 = plConduitGuide.closestPointTo(ptChilds[p]);
							pt1.transformBy(-vzT*vzT.dotProduct(pt1-ptBc));
							Point3d pt2 = ptChilds[p]+vzT*vzT.dotProduct(pt1-ptChilds[p]);pt2.vis(2);
							
						// get width: either from combination override or from wirechase width
							double dYThis = dMillWidth;
							double dXThis = abs(vecX.dotProduct(pt1-pt2));
														
						// find the associated combination
							TslInst tslChild;
							int nChildIndex=-1;
							double dDist = U(20000);
							for (int t=0;t<tslChilds.length();t++)
							{
								Point3d ptX = tslChilds[t].ptOrg();
								ptX.transformBy(vecZ*vecZ.dotProduct(pt2-ptX));
								double d =(ptX-pt2).length();
								if (d<dDist && abs(vecY.dotProduct(ptX-pt2))<dEps)
								{
									dDist = d;
									tslChild = tslChilds[t];
									nChildIndex=t;	
								}	
							}
							
						// if the found instance is valid and has the property extra drill enabled	set a map entry which will be consumed by the combination
							if (tslChild.bIsValid())
							{
							// get potentially defined width of horizontal wirechases
								double dProp7 = tslChild.propDouble(7);
								if (dProp7>0)dYThis=dProp7;
							
							// add combinations diameter property to length of wirechase
								dXThis+= .5*(tslChild.propDouble(3)+dYThis);
							
							// get map, preferably by map array	
								Map map;
								if (nChildIndex>-1)
									map = mapChildMaps[nChildIndex];
								else
									map = tslChild.map();
								if (tslChild.propString(5)== sNoYes[1])
								{
									map.setPoint3d("additionalDrill",pt1);pt1.vis(3);
								}
								else
								{
									map.removeAt("additionalDrill",false);pt1.vis(1);
								}
								tslChild.setMap(map);
							}						

							if (dXThis<dEps)continue;							
							
							
							PLine plConduitX(vecZ);
							plConduitX.addVertex(pt1);
							plConduitX.addVertex(pt2);//plConduitX.vis(2);
							if(nProjectSpecial==1) dp.draw(plConduitX);		
							
							if (dXThis<dEps || dYThis <dEps || dZBc<dEps) continue;

						// create test body
							Vector3d vecDir = vecX; if(vecDir.dotProduct(pt1-pt2)<0)vecDir*=-1;
							pt1.transformBy(vecDir *.5*dYThis);
							pt2.transformBy(-vecDir * .5*tslChild.propDouble(2));
							Point3d ptBd = (pt1+pt2)*.5;//ptBd.vis(6);
							Body bdTest(ptBd,vecX,vecY,vzT,dXThis,dYThis , dZBc *2,0,0,0 );//bdTest.vis(4);	
							
						// add beamcut to intersecting beams, only vertical beams are allowed  version 8.8 10sep14
							for (int g=0;g<gbsZone0.length();g++)
							{
							// only verticals	
								if (!gbsZone0[g].vecX().isParallelTo(vecY))continue;
							
							// test if intersecting beam would be manipulated at least half of it's width. ignore any tool smaller .5 * _W0	
								Body bdInt = bodiesZone0[g];//gbsZone0[g].envelopeBody();	Version 10.1
								bdInt.intersectWith(bdTest);	
								if (bdInt.volume()>dYThis *dZBc*.5*gbsZone0[g].dD(vecX))
								{
									//bdInt.vis(g);
									Point3d pt = (pt1+pt2)/2;
									pt.transformBy(vecX*vecX.dotProduct(gbsZone0[g].ptCen()-pt));
									
									BeamCut bc(pt,vecX,vecY,vzT,gbsZone0[g].dD(vecX)+dEps,dYThis , dZBc *2,0,0,0 );
									gbsZone0[g].addTool(bc);//bc.cuttingBody().vis(x);
								}
							}		

							if (gbAll.length()>0)
							{
								PLine plNN(vzT);
								plNN.createRectangle(LineSeg(ptBd-.5*(vecX*dXThis-vecY*dYThis),ptBd+.5*(vecX*dXThis-vecY*dYThis)),vecX,vecY);
								for (int i=0; i<5;i++)
								{
									int nZoneNN = nSide*nFlip*(i+1);
									if (el.zone(nZoneNN).dH()>dEps)
									{
										ElemNoNail elNN(nZoneNN,plNN);
										el.addTool(elNN);	
									}	
								}// next i zone
							}
						}// next p of ptChilds							
	
					}// end if toolRef Offset X >0
					
				// draw conduits in plan view
					if(bDrawPlanConduits)
					{
						double dRadius = .5*dMillDepth;
						if (dNominalDiameters[x]>0) dRadius=.5*dNominalDiameters[x];
						Point3d ptConduit = ptMillRef- vecX*(nConduits-1)/2*dMillDepth-vzT*nFlip*dRadius;
						PLine plCirc;
						plCirc.createCircle(ptConduit,vecY,dRadius );
						PlaneProfile ppSub(plCirc);
						ppSub.shrink(U(2));
						PlaneProfile ppConduit(plCirc);
						ppConduit.subtractProfile(ppSub);	
						for (int p=0;p<nConduits;p++)
						{
							dpPlanTech.draw(ppConduit,_kDrawFilled);
							ppConduit.transformBy(vecX*dMillDepth);
						}	
					}
				}// END IF (nConduits>0 || nProjectSpecial==0)
				
				// grip repos only on creation //version 4.9 Grip of wirechase description text will not be relocated on recalc
				if (_bOnDbCreated && _PtG.length()>x && nProjectSpecial==1)
					_PtG[x] = ptBc+vecX*nFlip*dMillWidth;
				//else if(_PtG.length()>x)
				//	_PtG[x].transformBy(vecZ*vecZ.dotProduct(ptBc-_PtG[x]));
				
			}// END IF validate tool points	
		}// END if (dMillWidth>0  && ptChilds.length()>0)
		
	// store the points in a global variable
		double dLength;
		for (int i=0;i<ptsMill.length();i++)
		{
			ptsConduitExtremes.append(ptsMill[i]);
			if (i>0)
				dLength += (ptsMill[i] - ptsMill[i - 1]).length();			
		}
	
	// add hardware
		double dNominalDiameter = dNominalDiameters[x] > 0 ? dNominalDiameters[x] : dMillDepth;
		if (dLength>0 && dNominalDiameter>0)		
		{
			HardWrComp hwc(T("|Conduit|") + " DN" +dNominalDiameter ,1);
			hwc.setDScaleX(dLength*nConduits);
			hwc.setDScaleY(dNominalDiameter);
			hwc.setCountType(_kCTLength);
			//hwc.setNotes(_kCTLength); // workaround until CountType is supported
		
		// HSB-6008
		// set room name (or count type for customer lux)
			if (nProjectSpecial==1)
				hwc.setNotes(_kCTLength); // workaround until CountType is supported
			else if (bInstallationIsExposed)
				hwc.setNotes(T("|Exterior Installation|"));
			else if (mapRoom.length()>0)
				hwc.setNotes(mapRoom.getString("roomNumber"));			
			hwc.setCategory("Electrical");
			hwc.setDescription(el.number());
			hwcs.append(hwc);
		}	
		_ThisInst.setHardWrComps(hwcs);
	
	// set in varias to other side	
		dMillWidth = dMillWidthOpposite;
		dMillDepth= dMillDepthOpposite;
		nMillSide = nMillOppositeSide;
		nFlip*=-1;
		ptMillRef.transformBy(-vzT*el.dBeamWidth());		
		nConduits = nConduitsOpposite;		
	}//next x

// recalc childs #2030
	if (_Map.getInt("recalcChilds"))
	{
		int bRemoteFlip = _Map.getInt("remoteFlip");
		int bRemoteStaticLocation = _Map.getInt("remoteStaticLocation");		
		if (bDebugLocation) reportMessage("\n" + scriptName() + " recalcChilds " +
			"\n	bRemoteFlip: " + bRemoteFlip +
			"\n	bRemoteStaticLocation: " + bRemoteStaticLocation);
		for (int i=0;i<tslChilds.length();i++)
		{
			if (bDebugLocation) reportMessage("\n" + scriptName() + " recalc " +tslChilds[i].handle());
		// set the flag of the request to remotely flip the side of the combination	
			if (bRemoteFlip || bRemoteStaticLocation)
			{
			// get alignment
				int bIsVertical=tslChilds[i].propString(1)==T("|Vertical|");
				
				Map map = tslChilds[i].map();
			// for horizontal combinations force the combination to invert its positionindex	
				map.setInt("invertIndex",!bIsVertical && (bRemoteStaticLocation || bRemoteFlip));
				map.setInt("remoteFlip",bRemoteFlip);
				if ((bRemoteStaticLocation && bFlipSideTriggered) || (bRemoteFlip && bFlipSideAndCombiTriggered))
				{
					int bCombiFlip=map.getInt("Flip");					
					if (bDebugLocation) reportMessage("\n 	current flip/invert state: " + bCombiFlip + "/" + map.getInt("invertIndex"));
					if (bCombiFlip==true)bCombiFlip=false;
					else bCombiFlip=true;
					map.setInt("Flip",bCombiFlip);
					if (bDebugLocation) reportMessage("\n 	new flip state: " + bCombiFlip + "/" + map.getInt("invertIndex"));
				}
				tslChilds[i].setMap(map);	
				if (bDebugLocation) reportMessage("\n" + scriptName() + " remote flip set to " +tslChilds[i].handle());
			}
			if (bDebugLocation) reportMessage("\n	(A)" + scriptName() + " remote flip set to " +tslChilds[i].handle() + " invInd" + tslChilds[i].map().getInt("invertIndex"));
			tslChilds[i].recalcNow();// to be used from version 18 on
			if (bDebugLocation) reportMessage("\n	(B)" + scriptName() + " remote flip set to " +tslChilds[i].handle() + " invInd" + tslChilds[i].map().getInt("invertIndex"));
			//tslChilds[i].transformBy(Vector3d(0,0,0)); // to be used up to version 17
		}
		_Map.removeAt("remoteStaticLocation",true);	
		_Map.removeAt("recalcChilds",true);	
		_Map.removeAt("remoteFlip",true);
		
	// trigger that cthe symbols will be realligned	
		if (bFlipSideTriggered || bFlipSideAndCombiTriggered)_Map.setInt("AlignCombinationSymbols",true);
		
			
	}	




// collect the genbeams in range on certain events
	int bSameLength = (gbAll.length()>0 && gbAll.length()==_GenBeam.length());
	if (_bOnDebug || _bOnDbCreated || _kNameLastChangedProp == "_Pt0" || _bOnRecalc || bSameLength || _bOnElementConstructed)
	{	
	// reset array if _Pt0 was dragged
		if (_kNameLastChangedProp == "_Pt0")
		{
			if (bDebug ||nDebugTest==1) reportMessage("\ngenbeam reset requested by\n   on created: "+_bOnDbCreated+"\n   last name: " + _kNameLastChangedProp + "\n   on recalc: " +_bOnRecalc +"\n   on special: " + (gbAll.length()>0 && _GenBeam.length()==0));
			_GenBeam.setLength(0);
			_Map.setInt("recalcChilds",true);

		}
	// reset array if collected gbAll and _GenBeam are of same length. initially all _GenBeams contains gbAll, but at a later stage we only want to look at the genbeams in range
		if (gbAll.length()==_GenBeam.length())
		{
			if (bDebug ||nDebugTest==1) reportMessage("\ngenbeam reset requested by\n   on created: "+_bOnDbCreated+"\n   last name: " + _kNameLastChangedProp + "\n   on recalc: " +_bOnRecalc + "\n   on all genBeams in list: " + (gbAll.length()== _GenBeam.length()));
			_GenBeam.setLength(0);
		}
		//ppCollect.vis(2);
	// set the collection range to the designated width
		LineSeg lsCollect = ppCollect.extentInDir(vecX);
		Point3d ptMidCollect = lsCollect.ptMid();

		double dCollectHeight = abs(vecY.dotProduct(lsCollect.ptStart()-lsCollect.ptEnd()));
		if (dCollectHeight<dEps)
		{
			dCollectHeight =U(10000);// Version 3.3
			ptMidCollect =_Pt0;
		}
		
	// in case of an horizontal offset the collection range need to be extended	
		if (abs(dXToolRef)>dEps)dCollectWidth+=abs(dXToolRef);
		
		lsCollect = LineSeg(ptMidCollect +.5*(vecX*dCollectWidth+vecY*dCollectHeight),ptMidCollect -.5*(vecX*dCollectWidth+vecY*dCollectHeight));	
		lsCollect.transformBy(vecX*.5*-dXToolRef);
		PLine plCollect;
		plCollect.createRectangle(lsCollect,vecX,vecY);
		ppCollect = PlaneProfile(plCollect);
		//ppCollect.vis(3);
		
	// collect genbeams which intersect the collection range	
		GenBeam gbRange[0];
		for (int i=0; i<gbAll.length();i++)
		{
			GenBeam gb=gbAll[i];
			
			PlaneProfile pp;
		// for sheets use the profshape as sometimes the streaming of the realBody might fail // version 5.1
			if (gb.bIsKindOf(Sheet()))
			{
				Sheet sh = (Sheet)gb;
				pp =sh.profShape();	

			}
			else
			{
				int n=gbsZone0.find(gb);
				if (n>-1)
					pp=ppsZ_Zone0[n];
				else
				{
					if (bDebug ||nDebugTest==1) reportMessage("\ncould not find " + gb.material() + " in zone " + gb.myZoneIndex() + " in precollected pp[]!");
//					pp= gb.envelopeBody().shadowProfile(pnZ);
					pp=calcPpOptimised(gb,pnZ);
				}
			}
			
//			if (gb.myZoneIndex()==1)
//			{ 
//				pp.transformBy(-vecZ * U(300));
//				pp.vis(i);
//				pp.transformBy(vecZ * U(300));
//			}
			//pp.vis(i);
			pp.intersectWith(ppCollect);
			if (pp.area()>pow(dEps,2) && _GenBeam.find(gb)<0)
			{
				
				if (bDebug ||nDebugTest==1)reportMessage("\n intersect the collection range" + gb.material() + " in zone " + gb.myZoneIndex());
				_GenBeam.append(gb);
			}
		}
		
	// fall back to all if nothing in range
		if (_GenBeam.length()<1)
		{
			if (nDebugTest==1)reportNotice("\n fall back Ln2456: " + gbAll.length());
			_GenBeam.append(gbAll);	
		}


		if (bDebug || nDebugTest==1) reportMessage("\n" + _GenBeam.length() + " genBeams in global array collected.");	
		//setExecutionLoops(2);	
		
//		if (_bOnDebug || _bOnDbCreated || _kNameLastChangedProp == "_Pt0" || _bOnRecalc || _bOnElementConstructed)
//		{
//			setExecutionLoops(2);	
//			reportMessage("\n" + _GenBeam.length() + " reloop...");
//			return;
//		}
	// trigger recalc for affected childs
		for (int i=0;i<tslChilds.length();i++)
			if (_GenBeam.length()!=tslChilds[i].genBeam().length())
				tslChilds[i].recalcNow();


	}

	
//	if (_bOnRecalc)
//		for(int i=0;i<_GenBeam.length();i++)
//			reportMessage("\n" + _GenBeam[i].typeDxfName() + "/"+_GenBeam.length() + " genBeams collected: " + _GenBeam[i].material() + " zone " + _GenBeam[i].myZoneIndex() + " " + _GenBeam[i].material() + " zone " + _GenBeam[i].name());	
//	//ppZ0.vis(3);	
//	if (_bOnDebug)
//		for(int p=0;p<_GenBeam.length();p++)				
//		{
//			Body bdx = _GenBeam[p].realBody();
//			bdx.transformBy(vecZ*(p+1)*U(200));
//			bdx.vis(_GenBeam[p].color());
//			
//		}

	for(int p=0;p<ptsConduitExtremes.length();p++)
		ptsConduitExtremes[p].vis(p);


// draw conduits info and export as ductwork	
	// version ="4.0" date="14feb13", required by FW
	if (nProjectSpecial==1)
	{
	
		double dNominalDiam;
		if (nMillThisSide>0 && nConduitsThis>0 && plConduitThis.length()>U(500))// conduits min length requested MS 22.05.2014
		{	
		// reposition _PtG for childless instances on insert
			if (tslChilds.length()<1 && !_Map.getInt("ConduitInfoLocationIconSet")) // version  value="9.9"
			{
				_PtG[0].transformBy(vecY*vecY.dotProduct(plConduitThis.ptMid()-_PtG[0]));	
				_Map.setInt("ConduitInfoLocationIconSet", true);// tried to solve this with _bOnDbCreated, but could get it to work	
			}
			
		// check if the grip is coaligned with _Pt0 in element view
			if (abs(vecY.dotProduct(_PtG[0]-_Pt0))<U(5))
				_PtG[0].transformBy(vecY*U(10));	
			else if (_PtG.length()>nIndexToolLocationGrip && nIndexToolLocationGrip!=0 && abs(vecY.dotProduct(_PtG[0]-_PtG[nIndexToolLocationGrip]))<U(5))
				_PtG[0].transformBy(vecY*U(10));				

						
			String s = nConduitsThis + "L";
		// show nominal diamteres
			dNominalDiam = dMillDepthThis;
			if (dNominalDiameters[0]>0)	dNominalDiam=dNominalDiameters[0];		
			if (dNominalDiam>=U(25)) s+=" DN" + dNominalDiam; 
			
		// color
			int n=nSideColors[0];
			if(nSide<0)	n=nSideColors[1];
			dpIcon.color(n);			
			dpOpposite.color(n);	
			dpIcon.draw(s, _PtG[0],vecX,vecY,.9,0);	
			dpOpposite.draw(s, _PtG[0],-vecX,vecY,-.9,0);
		}
		
		if (nMillOppositeSide>0 && nConduitsOpposite>0 && plConduitOpp.length()>U(500))
		{
		// reposition _PtG for childless instances on insert
			if (tslChilds.length()<1  && !_Map.getInt("ConduitInfoLocationOppSet"))//version  value="9.9"
			{
				_PtG[1].transformBy(vecY*vecY.dotProduct(plConduitOpp.ptMid()-_PtG[1]));				
				_Map.setInt("ConduitInfoLocationOppSet", true);// tried to solve this with _bOnDbCreated, but could get it to work	
			}
		// check if the grip is coaligned with _Pt0 in element view
			if (abs(vecY.dotProduct(_PtG[1]-_Pt0))<U(5))
				_PtG[1].transformBy(vecY*U(10));	
			else if (_PtG.length()>nIndexToolLocationGrip && nIndexToolLocationGrip!=1 && abs(vecY.dotProduct(_PtG[1]-_PtG[nIndexToolLocationGrip]))<U(5))
				_PtG[1].transformBy(vecY*U(10));

			String s = nConduitsOpposite + "L";
			dNominalDiam = dMillDepthOpposite;
			if (dNominalDiameters[1]>0)	dNominalDiam=dNominalDiameters[1]; 		
			if (dNominalDiam>=U(25)) s+=" DN" + dNominalDiam; 
			
		// color
			int n=nSideColors[1];
			if(nSide<0)	n=nSideColors[0];
			dpIcon.color(n);			
			dpOpposite.color(n);				
			dpOpposite.draw(s, _PtG[1],-vecX,vecY,.9,0);	
			dpIcon.draw(s, _PtG[1],vecX,vecY,-.9,0);	
		}
		
	// time management: conduits output
		Map mapItem;
		double dL;
		dL+=plConduitThis.length()*nConduitsThis;
		dL+=plConduitOpp.length()*nConduitsOpposite;
		if (dL>dEps)
		{
			mapItem.setInt("Quantity",nConduitsThis+nConduitsOpposite);
			mapItem.setDouble("Length",dL,_kLength);
			ElemItem item(0,"Ductwork",_Pt0,vecX,mapItem );
			item.setShow(_kNo);	
			el.addTool(item);
			exportWithElementDxa(el);			
		}

		
	}

	
	if (bDebug)reportMessage("\n" + scriptName() + " loop(" + _kExecutionLoopCount+ ") end of execution. " + _ThisInst.handle() + " qty of _GenBeams " + _GenBeam.length());
	
//if (am.length()<1)
//	setExecutionLoops(2);



// store the amount of linked childs
	_Map.setInt("numChilds", tslChilds.length());	


// get outer zones
	int nOuterZones[0];
	int nSgn = nSide/abs(nSide);
	int nOuterZone=1*nSgn;
	for(int i=1;i<6;i++)
		if (el.zone(i).dH()>dEps)
			nOuterZone=i*nSgn;
	nOuterZones.append(nOuterZone)	;	
	nOuterZone=-1*nSgn;
	for(int i=1;i<6;i++)
		if (el.zone(-i).dH()>dEps)
			nOuterZone=-i*nSgn;
	nOuterZones.append(nOuterZone)	;	
	

// collect sheets of outer zones within range
	PlaneProfile ppOuterThis, ppOuterOpposite;
	Sheet sheetsThis[0], sheetsOpposite[0];
	for (int x=0;x<2;x++)	
	{
		PLine plCollect;
		Sheet sheets[0];
		PlaneProfile ppRange;
		double d;
		if(x==0) d= dMillWidthThis;
		else d= dMillWidthOpposite;
		
		plCollect.createRectangle(LineSeg(_Pt0-vecX*.5*d-vecY*U(10000),_Pt0+vecX*.5*d+vecY*U(10000)),vecX,vecY);
		plCollect.transformBy(vecX * vecX.dotProduct(ptMillRef - _Pt0));  // version 11.7 wirechase offset was missing top/bottom tool
		//plCollect.vis(40);	
		
		PlaneProfile ppCollect (plCollect);
		for (int i=0; i<gbAll.length();i++)
		{
			GenBeam gb=gbAll[i];
			Sheet sheet;
			PlaneProfile ppSh, pp;
		// for sheets use the profshape as sometimes the streaming of the realBody might fail // version 5.1
			if (gb.bIsKindOf(Sheet()) && gb.myZoneIndex()==nOuterZones[x])
			{
				sheet = (Sheet)gb;
				ppSh =sheet.profShape();	
				pp=ppSh;
				ppSh.shrink(-dEps);
			}

			pp.intersectWith(ppCollect);
			if (pp.area()>pow(dEps,2) && sheets.find(gb)<0)
			{
				sheets.append(sheet);
				if (ppRange.area()<pow(dEps,2))
					ppRange = ppSh;
				else
					ppRange.unionWith(ppSh);	
			}	
		}
		ppRange.shrink(dEps);
		if (x==0)
		{
			ppOuterThis=ppRange;
			sheetsThis = sheets;
		}
		else 
		{
			ppOuterOpposite=ppRange;
			sheetsOpposite= sheets;
		}			
	}



// declare model graphics
	PLine plModelGraphics[0];
	int nModelGraphicsZone[0];
	
// additional frame toolings
	int bAddTools[] = {bAddToolBottomIcon,bAddToolBottomOpposite};
	for (int bt=0;bt<2;bt++)
	{
	// set values if first oloop is skipped	
		if (!bAddTools[0] && !bAddTools[1])
		{
			int bAddToolsTop[]={bAddToolTopIcon,bAddToolTopOpposite};
			bAddTools=bAddToolsTop;			
			continue;
		}
		Vector3d vecLine = -vecY;
		if (bt==1)vecLine*=-1;			

		Point3d pts[] = Line(_Pt0,-vecLine).orderPoints(ptsConduitExtremes);
		Point3d ptRef;	
		if (pts.length()>0)ptRef = pts[0].projectPoint(Plane(el.ptOrg(), vecZ), -el.dBeamWidth()*.5);	
		ptRef.vis(2);
		
		Beam beams[] = Beam().filterBeamsHalfLineIntersectSort(beamsZone0,ptRef,vecLine);
	
	// check custom settings of vertical tool
		Map mapVerticalTool;
		for (int i = 0; i < mapVerticalTools.length(); i++)
		{
			Map m = mapVerticalTools.getMap(i);
			int nAlignment = m.getInt("Alignment");
			if ((nAlignment == -1 && bt == 0) ||  // bottom
				(nAlignment == 1 && bt == 1)) // top
			{ 
				mapVerticalTool = m;
				break;
			}
		}
		
	// drill tool
		if (mapVerticalTool.hasDouble("Diameter"))
		{
		// Location
			Point3d ptLoc = ptRef;
			// HSB-10673
			if (mapVerticalTool.getDouble("Offset") >0 )
				ptLoc.transformBy(vecY * mapVerticalTool.getDouble("Offset"));
			else if (beams.length()>0)
			{ 
				Beam bm = beams[beams.length()-1];
				Plane pn(bm.ptCenSolid(),bm.vecD(vecLine));
				ptLoc = Line(ptRef , vecLine).intersect(pn, - .5 * bm.dD(vecLine));
			}
			ptLoc.vis(3);
		
		// diameter
			double dDiameter = mapVerticalTool.getDouble("Diameter");
			int nToolIndex = mapVerticalTool.hasInt("ToolIndex") ? mapVerticalTool.getInt("ToolIndex") : 1;
			
		// loop icon and opposite side
			for (int x=0;x<bAddTools.length();x++)
			{ 
				if (!bAddTools[x] || dDiameter <=dEps)continue;	
			
			// the zone
				ElemZone ez = el.zone(nOuterZones[x]);
				
			// depth
				double dDepth = mapVerticalTool.getDouble("depth");
				if (dDepth<=dEps)dDepth = ez.dH();
				dDepth += mapVerticalTool.getDouble("ExtraDepth");
				
			// the tool
				ElemDrill elemDrill(nOuterZones[x], ptLoc, ez.vecZ(), dDepth, dDiameter, nToolIndex);
				ptLoc.vis(5);
				el.addTool(elemDrill);
			}
		}
		
	// standard vertical tooling	
		else if (beams.length()>0)
		{
			Beam bm = beams[beams.length()-1];
			Plane pn(bm.ptCen(),bm.vecD(vecLine));
			Sheet sheets[0];
			sheets = sheetsThis ;
		// loop this/opposite side
			double dWidth = dMillWidthThis;	
			for (int x=0;x<bAddTools.length();x++)
			{
				if (!bAddTools[x] || dWidth <=dEps)continue;
			// get a closed pline intersecting the relevant edge	
				Point3d ptLR[0];
				//ptRef.vis(6);
				ptLR.append(Line(ptRef-vecX*.5*dWidth , vecLine).intersect(pn, -.5*bm.dD(vecLine)));
				ptLR.append(Line(ptRef+vecX*.5*dWidth , vecLine).intersect(pn, -.5*bm.dD(vecLine)));
				ptLR.append(Line(ptRef-vecX*.5*dWidth , vecLine).intersect(pn, 5*bm.dD(vecLine)));
				ptLR.append(Line(ptRef+vecX*.5*dWidth , vecLine).intersect(pn, 5*bm.dD(vecLine)));
				PLine plHull;
				plHull.createConvexHull(Plane(ptOrg,vecZ),ptLR);
				//plHull.vis(6);
							
			// the zone
				ElemZone ez = el.zone(nOuterZones[x]);

			// square it
				PlaneProfile pp(plHull);
				LineSeg seg = pp.extentInDir(vecX);
				plHull.createRectangle(seg,vecX,vecY);
				pp=PlaneProfile (plHull);
				pp.vis(1);
				ppOuterThis	.vis(2);			
			// intersect with zone pp
				PlaneProfile ppOuter=ppOuterThis;
				if (x==1)ppOuter = ppOuterOpposite;
				pp.intersectWith(ppOuter);
				pp.vis(x+1);

			// derive zone pline from outer pp			
				PLine plZone;
				plRings=ppOuter.allRings();
				bIsOp=ppOuter.ringIsOpening();	
				for (int r=0;r<plRings.length();r++)
				{
					if (bIsOp[r]) continue;
				// find intersecting ring, the biggest ring might not be intersecting (sheets above and below openings)
					PlaneProfile ppR(plRings[r]);
					PLine plR;
					plR.createRectangle(ppR.extentInDir(vecX), vecX,vecY);
					ppR = PlaneProfile(ppR);
					ppR.intersectWith(pp);
					if (ppR.area()>pow(dEps,2) && plZone.area()<plRings[r].area())
						plZone= plRings[r];
				}
				//plZone.transformBy(vecZ*U(500)); plZone.vis(6);plZone.transformBy(-vecZ*U(500));
				
			// derive tool pline from it
				PLine plTool;
				plRings=pp.allRings();
				bIsOp=pp.ringIsOpening();	
				for (int r=0;r<plRings.length();r++)
					if (!bIsOp[r] && plTool.area()<plRings[r].area())
						plTool = plRings[r];
					
				seg=pp.extentInDir(vecX);
				seg.vis(2);
							
				Map mapIO;
				mapIO.setInt("function",1);			
				mapIO.setInt("zone",nOuterZones[x]);	
				mapIO.setEntity("Element",el);
				mapIO.setPLine("plTool",plTool);
				mapIO.setPLine("plZone",plZone);
				mapIO.setDouble("shrink", 0);
				mapIO.setDouble("stripLength",0);//dStripLength
				TslInst().callMapIO(sScriptnameCombi, mapIO);
				plTool = mapIO.getPLine("plTool");
				plTool.vis(0);
				plTool.setNormal(vecZ);
			// collect model graphics	
				PLine plRec = mapIO.getPLine("plToolRectangle");
				plModelGraphics.append(plRec);
				nModelGraphicsZone.append(nOuterZones[x]);
				plRec.projectPointsToPlane(Plane(ez.ptOrg(), ez.vecZ()),ez.vecZ());
				
			// add mill
				ElemMill mill(nOuterZones[x], plTool, ez.dH()+dEps, 1, _kLeft ,_kTurnAgainstCourse,_kOverShoot);
				el.addTool(mill);	
			
			// add solid subtract
				if (plRec.area()<pow(dEps,2))
				{
					if (_bOnDebug)reportMessage("\n" + scriptName() + ": " + T("|Solid subtraction could not be created|") + " " + T("|Element|") + " " + el.number() + " " + "bt/x " + bt + "/" + x);	
				}
				else
				{
					SolidSubtract sosu(Body(plRec, ez.vecZ()*2*(ez.dH()+dEps),0),_kSubtract);
					sosu.addMeToGenBeams(sheets);
				}
			// opposite zone	
				dWidth = dMillWidthOpposite;
				sheets = sheetsOpposite;
			}
		}	
	
	// set flags for next loop
		int bAddToolsTop[]={bAddToolTopIcon,bAddToolTopOpposite};
		bAddTools=bAddToolsTop;
	}// next bt	

// draw model graphics
	for(int i=0;i<plModelGraphics.length();i++)
	{
	// the graphics zone
		int z = 1;
		if (nModelGraphicsZone.length()>i)z=nModelGraphicsZone[i];
		PLine plGraphics = plModelGraphics[i];
		plGraphics.projectPointsToPlane(Plane(el.zone(z).ptOrg(),el.zone(z).vecZ()),el.zone(z).vecZ());
		
		if (z<0)dp.color(nSideColors[1]);
		else dp.color(nSideColors[0]);

		dp.draw(plGraphics);
		PlaneProfile ppModelGraphics(plGraphics);
		LineSeg ls = ppModelGraphics.extentInDir(vecX);
		double dY = abs(vecY.dotProduct(ls.ptStart()-ls.ptEnd()));
		PLine plRec;
		plRec.createRectangle(ppModelGraphics.extentInDir(vecX),vecX,vecY);
		if (z!=0)plRec.transformBy(-z/abs(z)*vecY*.5*dY);
		ppModelGraphics.joinRing(plRec,_kSubtract);
		dp.draw(ppModelGraphics,_kDrawFilled);
	}



//// load defaults trigger
//	String sLoadDefaultsTrigger = T("|Load Settings|");
//	addRecalcTrigger(_kContext,sLoadDefaultsTrigger );
//	if ((_bOnRecalc && _kExecuteKey==sLoadDefaultsTrigger))
//	{
//	// try to read local settings, fall back to global settings if nothing found
//		String sLocalSettingsPath = findFile((_kPathDwg+"\\" + sScriptName + "Settings.xml").makeUpper());
//		if (sLocalSettingsPath.length()<3)
//			sLocalSettingsPath =sSettingsPath;
//		mapSettings=Map();
//		mapSettings.readFromXmlFile(sLocalSettingsPath);
//
//	// write to map object
//		if (mapSettings.length()>0)
//		{
//		// update existing
//			if (mo.bIsValid())
//				mo.setMap(mapSettings);			
//		// create new
//			else
//				mo.dbCreate(mapSettings);
//		}
//	// erase existing map object
//		else if (mo.bIsValid())
//		{
//			String sRet = getString("\n" + sSettingsPath + " " + T("|could not be found.|") + " " + T("|Do you want to erase the existing custom settings?|") + " " + T("|NOTE: This can change the existing model!|") + 
//			" [" + T("|No|")+"/" +T("|Yes|")+"]");
//			if (sRet.length()>0 && sRet.left(1).makeUpper() == T("|Yes|").left(1).makeUpper())
//			{
//				mo.dbErase();
//				reportMessage(T("|Custom settings permanently erased from this drawing.|"));	
//			}
//		}
//			
//		Map map = mo.map();	
//		if (map.length()>0)
//		{
//			reportMessage("\n" + scriptName() + ": " + T("|reading settings from file|") + " " + sLocalSettingsPath);
//			for (int i=0;i<map.length();i++)
//			{
//				if (map.hasDouble(i))	reportMessage("\n	" + map.keyAt(i) +"	" + map.getDouble(i));
//				if (map.hasString(i))	reportMessage("\n	" + map.keyAt(i) +"	" + map.getString(i));
//				if (map.hasInt(i))		reportMessage("\n	" + map.keyAt(i) +"	" + map.getInt(i));
//			}
//			reportMessage("\n" + T("|Done|"));
//		}	
//
//		setExecutionLoops(2);
//		return;
//	}

//// update settings if applicable
//	int bAllowUpdate;
//	for (int i=0;i<sIntSettings.length();i++)if (!mapSettings.hasInt(sIntSettings[i])){bAllowUpdate=true;break;}
//	for (int i=0;i<sStringSettings.length();i++)if (!mapSettings.hasString(sStringSettings[i])){bAllowUpdate=true;break;}
//	for (int i=0;i<sDoubleSettings.length();i++)if (!mapSettings.hasDouble(sDoubleSettings[i])){bAllowUpdate=true;break;}
//	String sUpdateSettingsTrigger = T("|export Settings|");
//	if(bAllowUpdate)
//	{
//		addRecalcTrigger(_kContext,sUpdateSettingsTrigger);
//		
//		if (_bOnRecalc && _kExecuteKey ==sUpdateSettingsTrigger)
//		{
//		// add default values		
//			for (int i=0;i<sIntSettings.length();i++)		
//				if (!mapSettings.hasInt(sIntSettings[i]))		
//			{
//				int nValue = -99;
//				if (sIntSettings[i]=="IconSideColor")nValue =nSideColors[0];
//				else if (sIntSettings[i]=="OppositeSideColor")nValue =nSideColors[1];
//				else if (sIntSettings[i]=="DrawWirechaseOutline")nValue =bDrawWirechaseOutline;	// default draw wirechase outline
//				else if (sIntSettings[i]=="CombinationDrawFilledSymbol")nValue =true;			// default draw filled symbols
//				else if (sIntSettings[i]=="DrawPlanConduits")nValue =bDrawPlanConduits;			// default draw conduits in plan view
//				else if (sIntSettings[i]=="DrawRoomAlert")nValue =bDrawRoomAlert;				// default draw missing room alerts
//				else if (sIntSettings[i]=="WirechaseNoNail")nValue =nNoNailMode;					// default noNail mode
//				else if (sIntSettings[i]=="ExtentWirechase")nValue =bExtentWirechase;			// default extent wirechase
//				else if (sIntSettings[i]=="CombinationDrawElevationElementView")nValue =bCombinationDrawElevationElementView;// default noNail mode
//								
//				mapSettings.setInt(sIntSettings[i],nValue);	
//				reportMessage("\n" + sIntSettings[i] + " = " + mapSettings.getInt(sIntSettings[i]));
//			}	
//			for (int i=0;i<sStringSettings.length();i++)	
//				if (!mapSettings.hasString(sStringSettings[i]))	{mapSettings.setString(sStringSettings[i],"");reportMessage("\n" + sStringSettings[i] + " = " + mapSettings.getInt(sStringSettings[i]));}
//			for (int i=0;i<sDoubleSettings.length();i++)
//				if (!mapSettings.hasDouble(sDoubleSettings[i]))	
//				{
//					double dValue = 0;
//					if (sDoubleSettings[i]=="CombinationStandardDiameter")dValue =U(68);
//					mapSettings.setDouble(sDoubleSettings[i],dValue);
//					reportMessage("\n" + sDoubleSettings[i] + " = " + mapSettings.getDouble(sDoubleSettings[i]));
//				}
//			
//			mapSettings.writeToXmlFile(sSettingsPath);
//			setExecutionLoops(2);
//			return;
//		}
//	}

	



// store version for version dependent modifications, i.e. _PtG.length()
	_Map.setInt("Version", nCurrentVersion);
	_Map.setPoint3dArray("ptsConduitExtremes", ptsConduitExtremes);

































































#End
#BeginThumbnail
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
,1QA21TX%6**`/__9
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
        <int nm="BreakPoint" vl="2834" />
        <int nm="BreakPoint" vl="2812" />
        <int nm="BreakPoint" vl="2819" />
        <int nm="BreakPoint" vl="704" />
        <int nm="BreakPoint" vl="710" />
        <int nm="BreakPoint" vl="776" />
        <int nm="BreakPoint" vl="711" />
        <int nm="BreakPoint" vl="717" />
        <int nm="BreakPoint" vl="720" />
        <int nm="BreakPoint" vl="196" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22947: Fix &quot;ProjectSpecial&quot;" />
      <int nm="MajorVersion" vl="13" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="2/7/2025 10:15:21 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22947: Chek when beamcuts share same face" />
      <int nm="MajorVersion" vl="13" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="2/4/2025 4:19:38 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="#DEV: 20241115: Optimise code avoid if possible envelopeBody and shadowProfile" />
      <int nm="MajorVersion" vl="13" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="11/15/2024 1:06:58 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21736: Make sure the quader of element is not 0" />
      <int nm="MajorVersion" vl="13" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="3/27/2024 2:56:05 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21736: Create new referece to wall after 2 walls are joined" />
      <int nm="MajorVersion" vl="13" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="3/22/2024 5:14:21 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19502: Extend xml file to support skewed milling at bottom plate " />
      <int nm="MajorVersion" vl="13" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="7/11/2023 4:43:34 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19168: cleanup pline from Raum TSL" />
      <int nm="MajorVersion" vl="13" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="6/13/2023 7:49:47 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17706 special tool width override for headers exceeding specified dimensions" />
      <int nm="MajorVersion" vl="13" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="1/26/2023 3:57:31 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15727 bugfix on subsequent creation of multiple instances by cloning tsls" />
      <int nm="MajorVersion" vl="13" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="10/7/2022 2:16:50 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11911 translation issue fixed for bottom and top mill" />
      <int nm="MajorVersion" vl="12" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="5/18/2021 9:47:11 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-10673 Offset value controlls the offset of the tooling" />
      <int nm="MajorVersion" vl="12" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="2/9/2021 12:00:00 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-10560 included in standard update procedure, no more custom dll maintenance required" />
      <int nm="MajorVersion" vl="12" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="2/8/2021 10:00:32 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End