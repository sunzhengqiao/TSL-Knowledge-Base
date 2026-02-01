#Version 8
#BeginDescription
6.12 07.06.2021 HSB-11342: merge with the change from contentDACH in v6.9 Author: Marsel Nakuci
version value="6.11" date="21July20" author="alberto.jena@hsbcad.com">  
Added TH's earlier 6.4 changes in this version as well --> during commitment found a duplicate version in content DACH TSLs, which was further developed by TH (improved performance due to realBody replaced by envelopeBody(true, false) = FogBugz case 601),
which was further developed by TH, but not in sync with the general version, you're currently looking at.

for sheets, the hsb material can be shown together with the size
Allow for multiple materials to be filter
Bugfix on display of posnums of genbeams on shop drawings.
Added element into shop drawing code so that element filters work in shop drawings.  Also extracted shopdraw TSLs from beams in the shop drawing so they can be tabulated.
posnum offset for sloped beams corrected
tsl validation added
supports catalog based insertion without dialog, posnum right alignment, automatic posnum assignment if genbeams are not numbered

DE  erzeugt St·klisten im Modell- oder Papierbereich, im Papierbereich k



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 6
#MinorVersion 12
#KeyWords 
#BeginContents
/// <summary>
/// This tsl creates a bill of material in different working spaces (modelspace, paperspace and shopdraw space)
/// </summary>

/// <insert>
/// Modelspace
/// To insert this tsl select the entities you like to display and pick an insertion point
/// Paperspace
/// To insert this tsl select an hsbVieport and pick an insertion point in paperspace
/// Shopdraw Space
/// To insert this tsl edit the block of your multipage. select an hsbVieport and pick an insertion point
/// in the block drawing
/// </insert>

/// <property name="Drawing space">
/// Determines the space and the general behaviour of this tsl. Read only after insert.
/// </property name>

/// <command name="add Entity">
/// If in modelspace one can add entities to the BOM after it has been appended to the drawing
/// </command>

/// <remark>
/// Supports Tsl's which publsih data to a map called TSLBOM. Also subpart listings are possible if supplied by
/// referenced tsl
/// </remark>

/// History
// #Versions: 
// Version 6.12 07.06.2021 HSB-11342: merge with the change from contentDACH in v6.9 Author: Marsel Nakuci
///<version value="6.9" date="23jul18" author="aj">  Added a property so the customer can pick the color of the background for the posnum box.
///<version value="6.8" date="19sep16" author="florian.wuermseer@hsbcad.com">  Added TH's earlier 6.4 changes in this version as well --> during commitment found a duplicate version in content DACH TSLs, which was further developed by TH (improved performance due to realBody replaced by envelopeBody(true, false) = FogBugz case 601), but not in sync with the general version, you're currently looking at</version>
///<version value="6.7" date="19sep16" author="florian.wuermseer@hsbcad.com">  for sheets, the hsbmaterial can be shown together with the size</version>
///<version  value="6.6" date="05feb15" author="aj" Allow for multiple materials to be filter
///<version  value="6.5" date="30jan15"  author="cs"> Bugfix on display of posnums of genbeams on shop drawings.
///<version  value="6.4" date="29jan15"  author="cs"> Added element into shop drawing code so that element filters work in shop drawings.  Also extracted shopdraw TSLs from beams in the shop drawing so they can be tabulated. </version>
///<version  value="6.3" date="10may14" author="th"> posnum offset for sloped beams corrected </version>
///<version  value="6.2" date="16may12" author="th"> tsl validation added</version>
///<version  value="6.1" date="26jan12" author="th"> remove blank spaces in the complementary angles when 0 decimals were selected</version>
///<version  value="6.0" date="12dec11" author="th"> supports catalog based insertion without dialog</version>
/// Version 5.9   16.02.2011	th@hsbCAD.de
/// PosNum text display of beams with length enhanced
/// new setup display for shopdraw views
/// Version 5.8   28.01.2011	th@hsbCAD.de
/// display of tsl posnum content fixed
/// options for tsl numbering content modified: one can toggle one of the following options 
/// 'do not show', 'posnum', 'name', 'pos+name','only BOM'
/// Version 5.7   07.01.2011	th@hsbCAD.de
/// location of tsl posnums fixed
/// Version 5.6   21.01.2010	th@hsbCAD.de
/// translation fixed
/// Version 5.5   11.01.2010	th@hsbCAD.de
/// subpart listings issue fixed (2)
/// Version 5.5   11.01.2010	th@hsbCAD.de
/// subpart listings issue fixed
/// Version 5.4   30.07.2009	th@hsbCAD.de
/// Translation issue fixed
/// Version 5.3   25.06.2009	th@hsbCAD.de
/// Tsl's are also sorted by the sort column. NOTE: tsl's cannot be sorted by quantity
/// Version 5.2   22.05.2009	th@hsbCAD.de
/// Translation issue fixed
/// Version 5.1   02.04.2009	aj@hsb-cad.com
/// Add a new option to exclude Multiple Materials from the list
/// Version 5.0   26.01.2009	th@hsbCAD.de
/// subpart listings enhanced
/// Version 4.9   16.01.2009	th@hsbCAD.de
/// bugfix to display extrusionprofiles of beams
/// Version 4.8   08.01.2009	th@hsbCAD.de
/// TSL's supporting Label and Sublabel, bugFix on Beam().dL() converted to Beam().solidLength()
/// Version 4.7   16.10.2008   aj/th@hsbCAD.de
/// EN   new option to show the complementary angles on beam angles
/// DE   neue Option um komplementäre Winkel an Stäben zu zeigen
/// Version 4.6   05.08.2008   th@hsbCAD.de
/// EN   posnums of beams which are not aligned perpendicular to the element XY-plane will now be placed correct
/// DE   Positionsnummern von Stäben, welche nicht senkrecht zur XY-Ebene des Elementes liegen werden nun korrekt plaziert
/// Version 4.5   03.07.2008   th@hsbCAD.de
/// EN   Entities which are filtered not show their posnum anymore (GenBeam)
/// DE   von ausgefilterten Objekten werden die Positionsnummern nicht mehr angezeigt (GenBeam)
/// Version 4.4   26.05.2008   th@hsbCAD.de
///    bugfix   
/// Version 4.3   16.05.2008   th@hsbCAD.de
/// EN  Filter method for TSL's added. One can filter TSL's to be listed by TSL Name. Multiple entries to be separated by ';'
/// DE  Filter für TSL's ergänzt. Mit dieser Option können tSL's nach ihrem Namen gefiltert werden. Mehrfacheintragungen
///    werden durch das Zeichen ';' getrennt
/// Version 4.2  15.05.2008   th@hsbCAD.de
/// EN special tsl listings fixed
/// DE spezielle Auflistungen von Tsl's korrigiert
/// Version 4.1  14.05.2008   th@hsbCAD.de
/// EN new option to show the posnum and the length of the beam
///    - new option to align the posnums with the entity or with world x-axis
///    - new option to show posnum without box
///    - collision check enhanced
/// DE neue Option um die Positionsnummer und die Länge eines Stabes anzuzeigen
///    - neue Option um Positionsnummern parallel zum Objekt oder parallel zur Welt-X-Achse anzuzeigen
///    - neue Option um Positionsnummern ohen Rahmen anzuzeigen
///    - Kollisionsprüfung verbessert
/// Version 4.0  07.04.2008   th@hsbCAD.de
/// EN Element tsl's appended
/// Version 3.9  02.04.2008   th@hsbCAD.de
/// EN tsl listings enhanced
/// DE tsl Einträge verbessert
/// Version 3.8  27.03.2008   th@hsbCAD.de
/// EN   set property values from catalog implemented if global map has the appropriate integer set to 1
/// Version 3.7  25.03.2008   th@hsbCAD.de
/// EN   bugfix viewing direction shopdraw view
/// DE   bugfix Ansichtsrichtung Einzelteilzeichnung
/// Version 3.6  13.03.2008   th@hsbCAD.de
/// EN version history appended
/// Version 3.5  13.03.2008   aj@hsb-cad.com
/// EN bugFix posnum alignment in shopdraw mode
/// Version 3.4  29.01.2008   kr@hsb-cad.com
/// EN bugfix in paperspace insert
/// Version 3.3  28.01.2008   kr@hsb-cad.com
/// EN bugfix in sort
/// Version 3.2  28.01.2008   kr@hsb-cad.com
/// EN The space (model/paper/shopdraw) for an existing entity is set to the space it belongs, 
///   even after reading in the property set from the catalog.
/// Version 3.1  26.01.2008   kr@hsb-cad.com
/// EN added property to allow to choose the sort column for beams and sheet.
/// Version 3.0  25.01.2008   kr@hsb-cad.com
/// EN added shopdraw multipage support
/// 
/// Version 2.8   07.11.2007   th@hsbCAD.de
/// DE   neue Optionen zur Flächenausgabe von Platten
/// EN   new options to export the net area of sheets
/// Version 2.7.   31.01.2007   th@hsbCAD.de
/// DE  bugfix Skalierung [m]
/// EN   bugfix unit scaling [m]
/// Version 2.6.   10.01.2007   th@hsbCAD.de
/// DE  bugfix Bohlennummerierung
/// EN   bugfix log course numbering
/// Version 2.5.   28.11.2006   th@hsbCAD.de
/// DE   Mehrfach-Zonenauswahl möglich
/// EN   multiple zones can be selected
/// Version 2.4.   12.10.2006   th@hsbCAD.de
///    - bugFix Model
/// Version 2.3.   24.08.2006   th@hsbCAD.de 
///    - bugFix
/// Version 2.2.   22.08.2006   th@hsbCAD.de 
/// DE   neue Felder Winkel 1(C), Winkel 2(C) werten die Abschnittswinkel von Stäben aus
/// EN   new fields cutting angles 1 and 2 support the display of cutting angles of beams
/// Version 2.1   24.07.2006   th@hsbCAD.de 
/// DE   neue Option 'nur in Liste zeigen' steuert Sichtbarkeit der Positionen unabhängig 
///    von der Anzeige der Nummern
/// EN   new option 'Show only in BOM' shows entities without displaying a posnum
/// Version 2.0   11.04.2006   th@hsbCAD.de 
/// DE bugFix TSL Anzeige n Liste
///    - wird die Darstellung der Stab, Platten oder TSL-Nummern unterdrückt, 
///      so werden auch die zugehörigen Bauteile in der Liste nicht mehr angezeigt
/// EN bugFix Display of tsl's in BOM
///    - if display of number is turned of the referenced obect will not be shown in BOM
/// Version 1.9   11.04.2006   th@hsbCAD.de 
/// DE Farbe der Stabnummerierung = 38
/// EN Color of beam numbers = 38
/// Version 1.8   04.04.2006   th@hsbCAD.de 
/// DE - neue Option 'Blockbau Nummer zeigen' zeigt die Kombination aus Label, 
///      Sublabel und Sublabel2 im Papierbereich
/// EN - new option 'show Log PosNum' shows combination of Label, 
///      Sublabel and Sublabel2 im in paperspace
///      
/// Version 1.7   13.12.2005   th@hsbCAD.de
/// DE - neue Optionen zur Darstellung der Nummerierung im Papierbereich
/// EN - new options to show numbering in paperspace
///    
/// Version 1.6   01.12.2005   th@hsbCAD.de
/// DE - neue Optionen 'Filter Material' und 'Filter Label' ergänzt.
///      Die Eingabe eines eindeutigen Teiles der Material und/oder
///      Labelbezeichnung filtern die entsprechenden Bauteile aus.
/// EN - new options 'Filter Material' and 'Filter Label'
///      filters non matching materials and/or labels from the list
///      
/// Version 1.5   12.10.2005   th@hsbCAD.de
///    - zur besseren Lesbarkeit verdecken die Rahmen der Positionsnummern nun
///      die Bauteilkanten
/// Version 1.4   11.08.2005   th@hsbCAD.de
///    - Verschiebungsfaktor als Eigenschaft veröffentlicht
/// Version 1.3   05.08.2005   th@hsbCAD.de
///    - bestimmte TSL's werden im PS gelistet und nummeriert
///    - optionale Nummerierung der TSL's im Papierbereich. Die Darstellung dieser Nummern
///      kann mit einer separaten Farbe gesteuert werden
/// Version 1.2   04.08.2005   th@hsbCAD.de
///    - optionale Nummerierung der Stäbe im Papierbereich
/// Version 1.1   03.08.2005   th@hsbCAD.de
///    - erzeugt die Stückliste wahlweise im Modell- oder Papierbereich
///    - im Modellbereich können alle gewünschten Objkete durch den Benutzer gewählt werden,
///      im Papierbereich werden alle Stäbe und Platten des aktuellen Elementansichtsfensters 
///      ausgewertet
/// Version 1.0   27.07.2005   th@hsbCAD.de


// basics and props
	U(1,"mm");
	String sModelSpace = T("|model space|");
	String sPaperSpace = T("|paper space|");
	String sShopdrawSpace = T("|shopdraw multipage|");
	String sArSpace[] = {sModelSpace , sPaperSpace , sShopdrawSpace };
	PropString sSpace(2,sArSpace,T("|Drawing space|"));
	
	String sArNY[] = {T("No"), T("Yes")};
	String sArAllZones[] = {T("BOM of complete Element"), T("BOM of current Zone + Frame"), T("BOM of current Zone"), T("BOM of multiple zones (specify 'Multiple Zones')")};
	PropString sAllZones(3,sArAllZones,T("|Zone selection|"));
	PropString sMultipleZone(12,"",T("|Multiple Zones|") + " " + T("|Separate multiple entries by|")+ "' ;'");

	sMultipleZone.setDescription(T("One can set multiple zones to generate a bill of material by entering the zone index (-5...+5).") + " " + T("To use this option you must enable the option:") + " " + T("BOM of multiple zones"));
	int nAllZones = sArAllZones.find(sAllZones);	
	
	String sHeaderNames[] = {T("|Pos|"), T("|Name|"), T("|Pcs|"), T("|Length|"), T("|Width|"), T("|Height|"), T("|Material|"), T("|Grade|"), 
			T("|Info|"), T("|Weight|"), T("|Profile|"), T("|Label|"), T("|Sublabel|"), T("|Type|"),
			T("|Angle1|"), T("|Angle2|") ,T("|Angle1C|"), T("|Angle2C|"), T("|NetArea|"), T("|Volume|")};
	String sKeyNames[] = {"Pos", "Name","Qty", "Length", "Width","Height", "Mat", "Grade", 
			"Info", "Weight", "Profile", "Label", "Sublabel", "Type",
			"Angle1", "Angle2" ,"Angle1C", "Angle2C", "NetArea", "Volume"};
	String sArKeyTypeList[]={"int","double","String"};		
	String sArKeyType[] = {sArKeyTypeList[0], sArKeyTypeList[2],sArKeyTypeList[0], sArKeyTypeList[1], sArKeyTypeList[1],sArKeyTypeList[1], sArKeyTypeList[2], sArKeyTypeList[2], 
			sArKeyTypeList[2], sArKeyTypeList[1], sArKeyTypeList[2], sArKeyTypeList[2], sArKeyTypeList[2], sArKeyTypeList[2],
			sArKeyTypeList[1], sArKeyTypeList[1] ,sArKeyTypeList[1], sArKeyTypeList[1], sArKeyTypeList[1], sArKeyTypeList[1]};		
	int nAlign[] = {-1,1,-1,-1,-1,-1,1,1,1,-1,1,1,1,1,1,1,1,1,-1,-1};
	int nCol[] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20};
	
	PropString sSortKey(14, sHeaderNames, T("Sort column"));
	int nSortCol = nCol[ sHeaderNames.find(sSortKey,0) ];
	
	String arSSortMode[] = {T("Ascending"), T("Descending")};
	PropString sSortMode(15, arSSortMode,"   " + T("Sort mode"));
	int arBTrueFalse[] = {TRUE, FALSE};
	int bAscending = arBTrueFalse[arSSortMode.find(sSortMode,0)];
	
	
		
	PropString sDisplay(4,sArNY,T("Display BOM"));
	
	String sArShowPosNumBm[] = {T("Do not show"), T("Show PosNum"),T("Show Size"), T("Show PosNum and Size"), T("Show Log PosNum"), T("Show only in BOM"), T("|Show PosNum and Length|"), T("|Show Length|")};
	String sArShowPosNumSh[] = {T("Do not show"), T("Show PosNum"),T("Show Size"), T("Show PosNum and Size"), T("Show only in BOM"), T("|Show Material and Size|")};
	String sArShowPosNumTsl[] = {T("Do not show"), T("Show PosNum"),T("Show Name"), T("Show PosNum and Name"), T("Show only in BOM")};

	String sPropName7 = T("|Show PosNum Beams|");
	PropString sShowPosNumBm(7, sArShowPosNumBm, "   " + sPropName7,1);
	int nShowPosNumBm = sArShowPosNumBm.find(sShowPosNumBm);	

	String sPropName9 = T("|Show PosNum Sheets|");
	PropString sShowPosNumSh(9, sArShowPosNumSh,"   " +  sPropName9,1);
	int nShowPosNumSh = sArShowPosNumSh.find(sShowPosNumSh);	

	String sPropName10 = T("|Show PosNum TSL's|");
	PropString sShowPosNumTSL(10, sArShowPosNumTsl, "   " + sPropName10,1);
	int nShowPosNumTSL = sArShowPosNumTsl.find(sShowPosNumTSL);	
	
	String sArHidePosNumBackground[] = {T("|Nothing|"),T("Show Box"), T("Hide Beams"), T("Hide Sheets"), T("Hide TSLs"),T("Hide Beams & Sheets"),T("Hide Beams & TSLs"),T("Hide Sheets & TSLs"), T("Hide All")};
	PropString sHidePosNumBackground(11, sArHidePosNumBackground,"   " +  T("PosNum Background"));
	int nHidePosNumBackground = sArHidePosNumBackground.find(sHidePosNumBackground)-1;
	PropInt nColorBackGround (24,254,"   " +T("Color") + T("Background"));
	
	String sArPosNumAlignment[] = {T("|Parallel X-World|"),T("|Parallel on X-Axis of Object (inside)|"),T("|Parallel on X-Axis of Object (outside)|")};
	PropString sPosNumAlignment(16, sArPosNumAlignment,"   " +  T("PosNum Alignment"));
	int nPosNumAlignment= sArPosNumAlignment.find(sPosNumAlignment,0);
			
	
	

	PropDouble dNum(3, U(100), T("Width") + " " + sHeaderNames[0]);
	PropDouble dName(4, U(150), "   " +T("Width") + " " + sHeaderNames[1]);
	PropDouble dPcs(5, U(100), "   " +T("Width") + " " + sHeaderNames[2]);
	PropDouble dLength(6, U(100), "   " +T("Width") + " " + sHeaderNames[3]);
	PropDouble dWidth(7, U(100), "   " +T("Width") + " " + sHeaderNames[4]);
	PropDouble dHeight(8, U(100), "   " +T("Width") + " " + sHeaderNames[5]);
	PropDouble dMat(9, U(100), "   " +T("Width") + " " + sHeaderNames[6]);
	PropDouble dGrade(10, U(100), "   " +T("Width") + " " + sHeaderNames[7]);
	PropDouble dInfo(11, U(100), "   " +T("Width") + " " + sHeaderNames[8]);
	PropDouble dWeight(12, U(100), "   " +T("Width") + " " + sHeaderNames[9]);
	PropDouble dProfile(13, U(100), "   " +T("Width") + " " + sHeaderNames[10]);
	PropDouble dLabel(14, U(100), "   " +T("Width") + " " + sHeaderNames[11]);
	PropDouble dSublabel(15, U(100),"   " + T("Width") + " " + sHeaderNames[12]);	
	PropDouble dType(16, U(100),"   " + T("Width") + " " + sHeaderNames[13]);	
	PropDouble dCN(17, U(100), "   " +T("Width") + " " + sHeaderNames[14]);	
	PropDouble dCP(18, U(100),"   " + T("Width") + " " + sHeaderNames[15]);	
	PropDouble dCNC(19, U(100), "   " +T("Width") + " " + sHeaderNames[16]);	
	PropDouble dCPC(20, U(100), "   " +T("Width") + " " + sHeaderNames[17]);	
	PropDouble dNetArea(22, U(100), "   " +T("Width") + " " + sHeaderNames[18]);	
	dNetArea.setDescription(T("Sheets only"));
	PropDouble dVolume(23, U(100), "   " +T("Width") + " " + sHeaderNames[19]);	
	dVolume.setDescription(T("Sheets only"));

	String sCPN = T("A string representation of the angle (in degrees) of the straight cut at the end of the beam.") + " " + 
				T("In positive direction Angle 2(C), and in negative direction Angle 1(C).") + " " + 
				T("The C and the end indicates the complementary angle.");
	dCN.setDescription(sCPN);
	dCNC.setDescription(sCPN);
	dCP.setDescription(sCPN);
	dCPC.setDescription(sCPN);			
	


	PropInt nNum(3, nCol, T("Column No.") + " " + sHeaderNames[0],1);
	PropInt nName(4, nCol,"   " +T("Column No.") + " " + sHeaderNames[1],2);	
	PropInt nAmount(5, nCol,"   " +T("Column No.") + " " + sHeaderNames[2],3);
	PropInt nLength(6, nCol,"   " +T("Column No.") + " " + sHeaderNames[3],4);
	PropInt nWidth(7, nCol,"   " +T("Column No.") + " " + sHeaderNames[4],5);
	PropInt nHeight(8, nCol,"   " +T("Column No.") + " " + sHeaderNames[5],6);
	PropInt nMat(9, nCol,"   " +T("Column No.") + " " + sHeaderNames[6],7);
	PropInt nGrade(10, nCol,"   " +T("Column No.") + " " + sHeaderNames[7],8);
	PropInt nInfo(11, nCol,"   " +T("Column No.") + " " + sHeaderNames[8],9);
	PropInt nWeight(12, nCol,"   " +T("Column No.") + " " + sHeaderNames[9],10);
	PropInt nProfile(13, nCol,"   " +T("Column No.") + " " + sHeaderNames[10],11);
	PropInt nLabel(14, nCol,"   " +T("Column No.") + " " + sHeaderNames[11],12);
	PropInt nSublabel(15, nCol,"   " +T("Column No.") + " " + sHeaderNames[12],13);	
	PropInt nType(16, nCol,"   " +T("Column No.") + " " + sHeaderNames[13],14);	
	PropInt nCN(17, nCol,"   " +T("Column No.") + " " + sHeaderNames[14],15);	
	PropInt nCP(18, nCol,"   " +T("Column No.") + " " + sHeaderNames[15],16);		
	PropInt nCNC(19, nCol,"   " +T("Column No.") + " " + sHeaderNames[16],17);	
	PropInt nCPC(21, nCol,"   " +T("Column No.") + " " + sHeaderNames[17],18);	
	PropInt nNetArea(22, nCol,"   " +T("Column No.") + " " + sHeaderNames[18],19);
	nNetArea.setDescription(T("Sheets only"));
	PropInt nVolume(25, nCol,"   " +T("Column No.") + " " + sHeaderNames[19],0);
	nVolume.setDescription(T("Sheets only"));	
	int nAllCols[] = {nNum, nName, nAmount, nLength, nWidth, nHeight, nMat, nGrade, 
		nInfo, nWeight, nProfile, nLabel, nSublabel,nType, nCN, nCP,nCNC, nCPC, nNetArea, nVolume};


	PropString sDimStyle(0,_DimStyles,T("Dimstyle"));
	PropDouble dScale(2, 1, "   " + T("Scale"));	
	PropDouble dPropCharSize(0,U(17),"   " + T("character size"));	
	String sArUnit[] = {"mm", "cm", "m", "inch", "feet"};
	PropString sUnit(1,sArUnit,"   "+T("Unit"));
	int nArDecimals[] = {0,1,2,3,4};
	PropInt nDecimals(1,nArDecimals,"   " +T("Decimals"));	
	
	String sArUnit2[] = {"mm²", "cm²", "m²", "inch²", "feet²"};
	PropString sUnit2(13,sArUnit2,"   " +T("Unit Area"));
	sUnit2.setDescription(T("Sheets only"));
	PropInt nDecimals2(23,nArDecimals,"   " +T("Decimals Area"));		
	nDecimals2.setDescription(T("Sheets only"));	
	
	
	PropInt nColor (0,171,"   " + T("Color"));	
	PropString sDimStylePosNum(8,_DimStyles,T("Dimstyle PosNum"));
	PropInt nColorTsl (20,143,T("Color") + " " + T("TSL PosNum"));

	PropString sFilterTSL(17, "", T("|Filter TSL|"));
	sFilterTSL.setDescription(T("|Separate multiple entries by|") +" ';'");
	PropString sFilterMaterial(5, "", T("|Filter Material|"));
	PropString sFilterLabel(6, "", T("|Filter Label|"));
	
	PropString sExcludeMaterial(19, "", T("|Exclude Material|"));
	sExcludeMaterial.setDescription(T("|Separate multiple entries by|") +  "';'");
		
	PropDouble dOffsetFactor(21, 3, T("Offset Factor"));

	double dAllWidth[] = {dNum * dScale, dName * dScale, dPcs * dScale, dLength * dScale, dWidth * dScale, 
				dHeight * dScale, dMat * dScale, dGrade * dScale, dInfo * dScale, dWeight * dScale, 
				dProfile * dScale, dLabel* dScale, dSublabel* dScale, dType* dScale, dCN* dScale, dCP* dScale, 
				dCNC* dScale, dCPC* dScale, dNetArea * dScale, dVolume * dScale};
				
	PropString sCompAngle(18, sArNY, T("|Switch to Complementary Angle|"), 0);//AJ
	int nCompAngle= sArNY.find(sCompAngle,0);
	
	PropString sSolidSide(20, sArNY, T("|Use solid size|"), 0);//AJ
	int nUseSolid= sArNY.find(sSolidSide,0);
	
// bOnInsert
	if(_bOnInsert){
		if (insertCycleCount()>1) { eraseInstance(); return; }

		// show the dialog if no catalog in use
		if (_kExecuteKey == "")
			showDialog();		
		// set properties from catalog		
		else	
			setPropValuesFromCatalog(_kExecuteKey);	

		int nSpace = sArSpace.find(sSpace);
		_Pt0 = getPoint();
		if (sSpace==sModelSpace){		
			String sExcludeList[] = {"HSBEELEMENTSAW","HSBEELEMENTMILL", "TEXT", "LWPOLYLINE", "CIRCLE", "AEC_DIMENSION_GROUP"};
			PrEntity sset(T("Select Entities"), Entity());
  			if (sset.go()){
				Entity ents[0];
    			ents = sset.set();
				for (int i = 0; i < ents.length(); i++){
					//reportNotice("\n" + sExcludeList.find(ents[i].typeDxfName()));
					if (sExcludeList.find(ents[i].typeDxfName()) < 0){
						_Entity.append(ents[i]);
					// force posnum assignment
						if (ents[i].bIsKindOf(GenBeam()))
						{
							GenBeam gb = (GenBeam)ents[i];
							if (gb.posnum()<0)
								gb.assignPosnum(1);
						}
					}
				}
			}
		}// end space 0
		else if (sSpace==sPaperSpace){
  			Viewport vp = getViewport(T("Select the viewport from which the element is taken")); // select viewport
		  _Viewport.append(vp);
		}
		else if (sSpace==sShopdrawSpace){
			Entity ent = getShopDrawView(T("|Select the view entity from which the module is taken|")); // select ShopDrawView
			_Entity.append(ent);
		}
	}
//_______________________________________________________________________end OnInsert

// set the properties from catalog if inserted by another tsl
	if (_Map.hasString("catalogEntry") && _bOnDbCreated) 
		setPropValuesFromCatalog(_Map.getString("catalogEntry"));

// restrict color index
	if (nColor > 255 || nColor < -1) nColor.set(171);
	if (nColorTsl > 255 || nColorTsl < -1) nColorTsl.set(143);
		
// determine the space type depending on the contents of _Entity[0] and _Viewport[0]
{
	if (_Viewport.length()>0)
  		sSpace.set(sPaperSpace);
	else if (_Entity.length()>0 && _Entity[0].bIsKindOf(ShopDrawView()))
	{
  		sSpace.set(sShopdrawSpace);

		if(!_bOnGenerateShopDrawing)
		{
			// show a bit of setup graphics
			Display dp(12);
			dp.textHeight(U(10));
			dp.draw(scriptName(),_Pt0,_XW,_YW,1,0);
			dp.draw(sPropName7 + ": " + sShowPosNumBm,_Pt0,_XW,_YW,1,-3);
			dp.draw(sPropName9+ ": " + sShowPosNumSh,_Pt0,_XW,_YW,1,-6);
			dp.draw(sPropName10+ ": " + sShowPosNumTSL,_Pt0,_XW,_YW,1,-9);		
		}
	}
 	else
 		sSpace.set(sModelSpace);
 	sSpace.setReadOnly(TRUE);
}


// transform filter tsl property into array
	String sTsl2Filter[0];
	String sList = sFilterTSL;
	int bTslFilter;
	if (sList.length() > 0)
		bTslFilter=TRUE;
	while (sList.length()>0 || sList.find(";",0)>-1)
	{
		String sToken = sList.token(0);	
		sToken.trimLeft();
		sToken.trimRight();		
		sToken.makeUpper();
		sTsl2Filter.append(sToken);
		//double dToken = sToken.atof();
		//int nToken = sToken.atoi();
		int x = sList.find(";",0);
		sList.delete(0,x+1);
		sList.trimLeft();	
		if (x==-1)
			sList = "";	
	}

// transform filter materials property into array
	String sFilterMat[0];
	String sArray = sFilterMaterial;
	while (sArray.length()>0 || sArray.find(";",0)>-1)
	{
		String sToken = sArray.token(0);	
		sToken.trimLeft();
		sToken.trimRight();		
		sToken.makeUpper();
		sFilterMat.append(sToken);
		//double dToken = sToken.atof();
		//int nToken = sToken.atoi();
		int x = sArray.find(";",0);
		sArray.delete(0,x+1);
		sArray.trimLeft();	
		if (x==-1)
			sArray = "";	
	}


// add triggers
	String sTrigger[] = {T("Add Entity")};
	for (int i = 0; i < sTrigger.length(); i++)
		addRecalcTrigger(_kContext, sTrigger[i]);

// trigger0: 
	if (_bOnRecalc && _kExecuteKey==sTrigger[0] && sSpace == sModelSpace) 
	{
		PrEntity ssE(T("|Select entity (Beam, Sheet, TSL)|"), Beam());
		ssE.addAllowedClass(Sheet());
		ssE.addAllowedClass(TslInst());		
  		if (ssE.go()){
			Entity ents[0];
    		ents = ssE.set();
			for (int i = 0; i < ents.length(); i++)
			{
			// force posnum assignment
				if (ents[i].bIsKindOf(GenBeam()))
				{
					GenBeam gb = (GenBeam)ents[i];
					if (gb.posnum()<0)
						gb.assignPosnum(1);
				}
				if(_Entity.find(ents[i]) < 0)
					_Entity.append(ents[i]);
			}
		}	

	}

// area unit type
	int nUnit2 = sArUnit2.find(sUnit2);
	String sAreaUnit = sArUnit[0];
	if (nUnit2 > -1)
		sAreaUnit = sArUnit[nUnit2];
		
// display type
	int nDisplay = sArNY.find(sDisplay);
	if (sSpace == sModelSpace){
		sDisplay.set(sArNY[1]);
		sDisplay.setReadOnly(TRUE);
		sAllZones.setReadOnly(TRUE);
		sMultipleZone.setReadOnly(TRUE);
		nDisplay = 1;
	}
	
//filter criteria
	String sFilterLab = sFilterLabel;
	sFilterLab.makeUpper();
	String sExcludeMat = sExcludeMaterial;
	sExcludeMat.makeUpper();
	
// transform filter exclude material into array
	String sMat2Exclude[0];
	String sMatExcAr = sExcludeMat;
	int bMatExclude;
	if (sList.length() > 0)
		bMatExclude=TRUE;
	while (sMatExcAr.length()>0 || sMatExcAr.find(";",0)>-1)
	{
		String sToken = sMatExcAr.token(0);	
		sToken.trimLeft();
		sToken.trimRight();		
		sToken.makeUpper();
		sMat2Exclude.append(sToken);
		//double dToken = sToken.atof();
		//int nToken = sToken.atoi();
		int x = sMatExcAr.find(";",0);
		sMatExcAr.delete(0,x+1);
		sMatExcAr.trimLeft();	
		if (x==-1)
			sMatExcAr = "";	
	}



// declare some arrays
	Beam bm[0];
	Sheet sh[0];
	TslInst tsl[0];
	int nTslInZone[0];
	PlaneProfile ppAllSections[0];
	
// coordSys
	CoordSys ms2ps, ps2ms;	
	
// paperspace 
	Element el;
	int nZoneIndex;
	Entity entAll[0];	
	if (sSpace == sPaperSpace ){
		Viewport vp;
		if (_Viewport.length()==0) return; // _Viewport array has some elements
		vp = _Viewport[_Viewport.length()-1]; // take last element of array
		_Viewport[0] = vp; // make sure the connection to the first one is lost
		
		// check if the viewport has hsb data
		if (!vp.element().bIsValid()) return;
		
		ms2ps = vp.coordSys();
		ps2ms = ms2ps;
		ps2ms.invert();
		el = vp.element();
		nZoneIndex = vp.activeZoneIndex();

		Vector3d vzModel = _ZW;
		vzModel.transformBy(ps2ms);
		vzModel.normalize();
						
		// adjust properties
		if (_kNameLastChangedProp == T("|Zone selection|") && sAllZones != sArAllZones[3])
		{
			reportNotice("\n*****************************************************************\n" + 
			scriptName() + ": " +T("Information") + "\n" + 
			T("Property") + " '" + T("|Multiple Zones|") + "' " + T("|modified|")+ "\n" +
			"*****************************************************************");		
			sMultipleZone.set("");
		}
		
		if (sMultipleZone!="" && sAllZones != sArAllZones[3])
		{
			reportNotice("\n*****************************************************************\n" + 
				scriptName() + ": " +T("Information") + "\n" + 
				T("Property") + " '" + T("|Zone selection|") + "' " + T("|modified|") + "\n" +
				"*****************************************************************");
			sAllZones.set(sArAllZones[3]);
		}
		nAllZones = sArAllZones.find(sAllZones);
		_GenBeam.setLength(0);
		
		if (nAllZones == 0)// complete element
			_GenBeam = el.genBeam();
		else if (nAllZones == 1){// zone + frame
			if (nZoneIndex != 0)
				_GenBeam = el.genBeam(nZoneIndex);
			_GenBeam.append(el.genBeam(0));			
		}			
		// current zone 
		else if (nAllZones == 2)
			_GenBeam = el.genBeam(nZoneIndex);
		// multiple zones 
		else if (nAllZones == 3)
		{
			// append multi zones
			for (int i = 0; i < 11; i++)
			{
				String sToken = sMultipleZone.token(i, ";")	;
				if (sToken != "")
				{
					sToken.trimLeft();
					sToken.trimRight();					
					int nZn = sToken.atoi();
					if (nZn > -6 && nZn < 6)
						_GenBeam.append(el.genBeam(nZn));
				}
			}
		}		
		
	
		for (int i = 0; i < _GenBeam.length(); i++)
		{
			Entity entET[] = _GenBeam[i].eToolsConnected();
			Entity ent;
			for (int e = 0; e < entET.length(); e++){
				ent=entET[e];
				TslInst tsl0 = (TslInst)ent;
				if (!tsl0.bIsValid())
					continue;
				String sScriptname = tsl0.scriptName();
				sScriptname.makeUpper();
				int bInclude=true;
				if (bTslFilter && sTsl2Filter.find(sScriptname)<0)
					bInclude=false;
				Element elGb = ent.element();
				if (tsl0.map().hasMap("TSLBOM") && 
					tsl.find(tsl0) == -1 && 
					bInclude &&
					(el==elGb || !elGb.bIsValid()))
				{
					Map map0 = tsl0.map().getMap("TSLBOM") ;
					
					tsl.append(tsl0);
					entAll.append(tsl0);
					
					PLine plCirc;
					Point3d ptTsl = tsl0.ptOrg();
					plCirc.createCircle(ptTsl , vzModel, U(20)*dScale);
					plCirc.transformBy(ms2ps);			
					ppAllSections.append(PlaneProfile(plCirc));
					if (map0.hasInt("Iconside"))
						nTslInZone.append(map0.getInt("Iconside"));
					else
						nTslInZone.append(0);
				}
			}
		}


			
		TslInst tslEl[0];
		tslEl.append(el.tslInst());
		for (int e = 0; e < tslEl.length(); e++)
		{
			if (!tslEl[e].bIsValid()){continue;}
			String sScriptname = tslEl[e].scriptName();
			sScriptname.makeUpper();
			int bInclude=true;
			if (bTslFilter && sTsl2Filter.find(sScriptname)<0)
				bInclude=false;

			if (tslEl[e].map().hasMap("TSLBOM") && 
				bInclude && 
				tsl.find(tslEl[e])<0)
			{
				Map map0 = tslEl[e].map().getMap("TSLBOM") ;
				tsl.append(tslEl[e]);
				entAll.append(tslEl[e]);
				PLine plCirc;
				Point3d ptTsl = tslEl[e].ptOrg();
				plCirc.createCircle(ptTsl , vzModel, U(20)*dScale);
				plCirc.transformBy(ms2ps);
				
				ppAllSections.append(PlaneProfile(plCirc));
				plCirc.vis(2);
				if (map0.hasInt("Iconside"))
					nTslInZone.append(map0.getInt("Iconside"));
				else
					nTslInZone.append(0);
			}
		}
	}
	
//shopdrawspace	
	if (sSpace == sShopdrawSpace ) {
		
		if (_Entity.length()==0) return; // _Entity array has some elements
		ShopDrawView sv = (ShopDrawView)_Entity[0];
		if (!sv.bIsValid()) return;
		
		// interprete the list of ViewData in my _Map
		ViewData arViewData[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets,0); // 2 means verbose
		int nIndFound = ViewData().findDataForViewport(arViewData, sv);// find the viewData for my view
		if (nIndFound<0) return; // no viewData found
		
		ViewData vwData = arViewData[nIndFound];
		Entity arEnt[] = vwData.showSetEntities();
		
		ms2ps = vwData.coordSys();
		ps2ms = ms2ps;
		ps2ms.invert();
	
		Vector3d vecView = ps2ms.vecZ(); 
		Point3d ptView = ms2ps.ptOrg();

		// This is assuming that if an element is found then we are working on an element viewport and filters could apply
		Element el;
		int elementFound=false;
		for (int i = 0; i < arEnt.length(); i++)
		{
			if(arEnt[i].bIsKindOf(Element()))
			{
				elementFound=true;
				el=(Element)arEnt[i];
				break;
			}
		}	

		if(elementFound)
		{
			GenBeam genBeams[0];
			nAllZones = sArAllZones.find(sAllZones);
			
			if (nAllZones == 0)// complete element
				genBeams= el.genBeam();
			else if (nAllZones == 1){// zone + frame
				if (nZoneIndex != 0)
					genBeams= el.genBeam(nZoneIndex);
				genBeams.append(el.genBeam(0));			
			}			
			// current zone 
			else if (nAllZones == 2)
				genBeams= el.genBeam(nZoneIndex);
			// multiple zones 
			else if (nAllZones == 3)
			{
				// append multi zones
				for (int i = 0; i < 11; i++)
				{
					String sToken = sMultipleZone.token(i, ";")	;
					if (sToken != "")
					{
						sToken.trimLeft();
						sToken.trimRight();					
						int nZn = sToken.atoi();
						if (nZn > -6 && nZn < 6)
							genBeams.append(el.genBeam(nZn));
					}
				}
			}		

			for(int i=0;i<genBeams.length();i++)
			{
				entAll.append((GenBeam)genBeams[i]);
			}
		}
		else
		{
			for (int i = 0; i < arEnt.length(); i++){
				Entity ent = arEnt[i];
	
				if (arEnt[i].bIsKindOf(GenBeam())){
					GenBeam gbX = (GenBeam)arEnt[i];
					entAll.append(gbX);
				}
			}
		}

		if(entAll.length()==0)
		{
			//No point continuing
			return;
		}
		
		for (int i = 0; i < entAll.length(); i++)
		{
			Entity ent=entAll[i];
			GenBeam gbX = (GenBeam)entAll[i];
			PlaneProfile ppSection = gbX.envelopeBody(false, true).shadowProfile(Plane(ptView , vecView));
			ppSection.transformBy(ms2ps);
			ppAllSections.append(ppSection);
			
			if (ent.bIsKindOf(Beam())){
				bm.append((Beam)ent);
				//reportNotice("\n" + bm[0].posnum());
			}
			else if (ent.bIsKindOf(Sheet()))
				sh.append((Sheet)ent);
			else if (ent.bIsKindOf(TslInst()))
				tsl.append((TslInst)ent);
		}

		
		//Code modified to look into a beam and find the tsl instances in the Beam as shopdrawing currently is not sending TSL objects into Entity - CS
		if(bm.length()>0)
		{
			Beam bmTSL=bm[0];
			TslInst tslAssy[]=bmTSL.subAssemblies();
			if(tslAssy.length()>0)
			{
				Entity entTSL[]=tslAssy[0].entity();
				for(int j=0;j<entTSL.length();j++)
				{
					Entity ent=entTSL[j];
					if(ent.bIsKindOf(TslInst()))
					{
						TslInst tslPlate=(TslInst)ent;
						tsl.append(tslPlate);
					}
				}
			}
		}
		//=======
	}
	

		
// collect and cast entities
	if (sSpace == sModelSpace){
		bm.append(_Beam);		
		for (int i = 0; i < _Entity.length(); i++){
			Entity ent = _Entity[i];
			if (_Entity[i].bIsKindOf(Beam())){
				bm.append((Beam)ent);
				//reportNotice("\n" + bm[0].posnum());
			}
			else if (_Entity[i].bIsKindOf(Sheet()))
				sh.append((Sheet)ent);
			else if (_Entity[i].bIsKindOf(TslInst()))
				tsl.append((TslInst)ent);
		}
	}
	else if (sSpace == sPaperSpace){
		for (int i = 0; i < _GenBeam.length(); i++){
			GenBeam gbX = _GenBeam[i];
			//PlaneProfile ppSection = gbX.realBody().extractContactFaceInPlane(Plane(el.ptOrg(), el.coordSys().vecZ()), U(1000));
			PlaneProfile ppSection = gbX.envelopeBody(false, true).shadowProfile(Plane(el.ptOrg(), el.coordSys().vecZ()));
								
			ppSection.transformBy(ms2ps);
			//ppSection.transformBy(_ZW*U(2));
			//if (gbX.posnum()==6050) 
			ppSection.vis(i);
			//ppSection.transformBy(_ZW*U(2));
				
			ppAllSections.append(ppSection);
			entAll.append(gbX);
			if (_GenBeam[i].bIsKindOf(Beam())){
				bm.append((Beam)gbX);
			}
			else if (_GenBeam[i].bIsKindOf(Sheet()))
				sh.append((Sheet)gbX);
		}			
	}
	
	/*if(_bOnDebug) {
		reportNotice("\nNumber of beams found: "+bm.length());
		reportNotice("\nNumber of sheets found: "+sh.length());
		reportNotice("\nNumber of tsls found: "+tsl.length());
	}*/

	
// some doubles
	double dCharSize = dPropCharSize * dScale;
	double dBO = dCharSize/3;
	
// get total width
	double dTotalWidth;
	int nNumCols;
	for (int i = 0; i < nAllCols.length(); i++)
		if (nAllCols[i] > 0){
			dTotalWidth = dTotalWidth + dAllWidth[i];
			nNumCols++;
		}



// sort to column index
	int nTmp;
	int dTmpWidth;
	String sTmp;
	
	int nOrder[0];
	int nMyCol[0];
	for (int i = 0; i < nAllCols.length(); i++) {
		if (nAllCols[i] != 0){
			nOrder.append(nAllCols[i]);
			nMyCol.append(i);	
		}
	}
	
	for (int i = 0; i < nOrder.length(); i++) {
		for (int j = 0; j < nOrder.length()-1; j++) {
			if (nOrder[j] > nOrder[j+1]){	
				nTmp = nMyCol[j];
				nMyCol[j] = nMyCol[j+1];
				nMyCol[j+1] = nTmp;

				nTmp = nOrder[j];
				nOrder[j] = nOrder[j+1];
				nOrder[j+1] = nTmp;		
			}
		}
	}

	
// Display
	Display dp(nColor);
	dp.dimStyle(sDimStyle);
	dp.textHeight(dCharSize);	
	
// write header
	Point3d ptRef = _Pt0;
	if (nDisplay == 1){
	for (int i = 0; i < nMyCol.length(); i++){
		PLine pl(ptRef, ptRef + _XW * dAllWidth[nMyCol[i]], 
					ptRef + _XW * dAllWidth[nMyCol[i]] - _YW * (dCharSize + 2 * dBO),
					ptRef - _YW * (dCharSize + 2 * dBO));
		pl.close();
		dp.draw(pl);
		dp.draw(sHeaderNames[nMyCol[i]], ptRef + 0.5 * _XW * dAllWidth[nMyCol[i]], _XW, _YW, 0, -1.5);
		ptRef.transformBy(_XW * dAllWidth[nMyCol[i]]);
	}//next i
	}
	ptRef.transformBy(-_XW * dTotalWidth - _YW * (dCharSize + dBO * 2));
	ptRef.vis(20);
	int nOff = -1;
	
	
//...


// declare possible sums (weight, area)
	double dSumWeight, dSumArea;
	
	
//BEAM______________________________________________________________________________________
// sort beams for posnums
	Beam bmTmp;
	for (int i = 0; i < bm.length(); i++){
		for (int j = 0; j < bm.length()-1; j++){
			if ( bm[j].posnum() > bm[j+1].posnum()){
				bmTmp = bm[j+1];
				bm[j+1] = bm[j];
				bm[j] = bmTmp;
			}
		}
	}


// collect identical beams 
	Beam bmList[0];
	int nPcsList[0];
	int nPcs = 1;
	for (int j = 0; j < bm.length(); j++){
		if (j==bm.length()-1){
			bmList.append(bm[j]);
			nPcsList.append(nPcs);
			nPcs = 1;			
		}
		else{
			if (bm[j].posnum() == bm[j+1].posnum())
				nPcs++;
			else{
				bmList.append(bm[j]);
				nPcsList.append(nPcs);
				nPcs = 1;
			}
		}
	} // next j
	
	if (nSortCol>=0 && nSortCol<nAllCols.length()) { 
	if (nDisplay == 1 && nShowPosNumBm > 0) {

		// sort beams for display
		String sArSortKey[bmList.length()];
		// first collect the correct sortkey
		for (int i = 0; i < bmList.length(); i++){
			String sValue;
			double dValue;
			String sList[nAllCols.length()];
			sValue.format("%0 10i",bmList[i].posnum());
			sList[0] = sValue;
			sList[1] = bmList[i].name("name");
			sValue.format("%0 10i",nPcsList[i]);
			sList[2] = sValue;
			sValue.format("%014.3f", bmList[i].solidLength() / U(1,sUnit,2));
			sList[3] = sValue;
			if (nUseSolid)
				sValue.format("%014.3f", bmList[i].solidWidth() / U(1,sUnit,2));
			else
				sValue.format("%014.3f", bmList[i].dW() / U(1,sUnit,2));
			sList[4] = sValue;
			if (nUseSolid)
				sValue.format("%014.3f", bmList[i].solidHeight() / U(1,sUnit,2));
			else
				sValue.format("%014.3f", bmList[i].dH() / U(1,sUnit,2));
			sList[5] = sValue;	
			sList[6] = bmList[i].name("material");
			sList[7] = bmList[i].name("grade");
			sList[8] = bmList[i].name("information");
			sList[10] = bmList[i].name("profile");
			sList[11] = bmList[i].name("label");
			sList[12] = bmList[i].name("sublabel");
			sList[13] = T(bmList[i].name("type"));				
			
		// AJ 16.10.2008				
			String sCutN=bmList[i].strCutN(); 			
			String sCutP=bmList[i].strCutP(); 			
			String sCutNC=bmList[i].strCutNC(); 			
			String sCutPC=bmList[i].strCutPC(); 			
			String sNewCutN=sCutN; 			
			String sNewCutP=sCutP; 			
			String sNewCutNC=sCutNC; 			
			String sNewCutPC=sCutPC; 			
			if (nCompAngle) 			
			{   				
				//CutN 
				String sNewValue; 
				sValue=sCutN.token(0, ">"); 
				dValue=sValue.atof(); 	
				if (dValue<0) 
					dValue=-90-dValue; 
				else 
					dValue=90-dValue; 
				sNewValue.format("%5.2f", dValue);
				sNewValue.trimLeft();
				sNewValue.trimRight();
				sNewCutN=sNewValue; 
				sNewCutN+=">"; 
				sValue=sCutN.token(1, ">"); 
				dValue=sValue.atof(); 
				if (dValue<0) 
					dValue=-90-dValue; 
				else 
					dValue=90-dValue; 
				sNewValue.format("%5.2f", dValue);
				sNewValue.trimLeft();
				sNewValue.trimRight();

				sNewCutN+=sNewValue; 
				
				//CutP
				sValue=sCutP.token(0, ">"); 
				dValue=sValue.atof(); 	
				if (dValue<0) 
					dValue=-90-dValue; 
				else 
					dValue=90-dValue; 
				sNewValue.format("%5.2f", dValue);
				sNewValue.trimLeft();
				sNewValue.trimRight();
				sNewCutP=sNewValue; 
				sNewCutP+=">"; 
				sValue=sCutP.token(1, ">"); 
				dValue=sValue.atof(); 
				if (dValue<0) 
					dValue=-90-dValue; 
				else 
					dValue=90-dValue; 
				sNewValue.format("%5.2f", dValue);
				sNewValue.trimLeft();
				sNewValue.trimRight();
				sNewCutP+=sNewValue; 

				//CutNC
				sValue=sCutNC.token(0, ">"); 
				dValue=sValue.atof(); 	
				if (dValue<0) 
					dValue=-90-dValue; 
				else 
					dValue=90-dValue; 
				sNewValue.format("%5.2f", dValue);
				sNewValue.trimLeft();
				sNewValue.trimRight();
				sNewCutNC=sNewValue; 
				sNewCutNC+=">"; 
				sValue=sCutNC.token(1, ">"); 
				dValue=sValue.atof(); 
				if (dValue<0) 
					dValue=-90-dValue; 
				else 
					dValue=90-dValue; 
				sNewValue.format("%5.2f", dValue);
				sNewValue.trimLeft();
				sNewValue.trimRight();
				sNewCutNC+=sNewValue; 
				
				//CutPC
				sValue=sCutPC.token(0, ">"); 
				dValue=sValue.atof(); 	
				if (dValue<0) 
					dValue=-90-dValue; 
				else 
					dValue=90-dValue; 
				sNewValue.format("%5.2f", dValue);
				sNewValue.trimLeft();
				sNewValue.trimRight();
				sNewCutPC=sNewValue; 
				sNewCutPC+=">"; 
				sValue=sCutPC.token(1, ">"); 
				dValue=sValue.atof(); 
				if (dValue<0) 
					dValue=-90-dValue; 
				else 
					dValue=90-dValue; 
				sNewValue.format("%5.2f", dValue);
				sNewValue.trimLeft();
				sNewValue.trimRight();
				sNewCutPC+=sNewValue; 

			} 			
				
			sList[14] = sNewCutN; 				
			sList[15] = sNewCutP; 				
			sList[16] = sNewCutNC; 				
			sList[17] = sNewCutPC; 	
		// end // AJ 16.10.2008	
			sArSortKey[i] = sList[nSortCol];
		}

		
		Beam bmTmp;
		String str;
		int nTmp;
		for (int i = 0; i < bmList.length(); i++){
			for (int j = 0; j < bmList.length()-1; j++){
				int nSwap = FALSE;
				if (bAscending && ( sArSortKey[j] > sArSortKey[j+1])) nSwap = TRUE;
				if (!bAscending && ( sArSortKey[j] < sArSortKey[j+1])) nSwap = TRUE;

				if (nSwap) {
					bmTmp = bmList[j+1];
					bmList[j+1] = bmList[j];
					bmList[j] = bmTmp;
					str = sArSortKey[j+1];
					sArSortKey[j+1] = sArSortKey[j];
					sArSortKey[j] = str;
					nTmp = nPcsList[j+1];
					nPcsList[j+1] = nPcsList[j];
					nPcsList[j] = nTmp;
				}
			}
		}
	}}
		
// set vertical transformation
	CoordSys cs;
	cs.setToTranslation(-_YW * (dCharSize  + 2 * dBO));
	
// write beam data
	if (nDisplay == 1 && nShowPosNumBm > 0){
	for (int i = 0; i < bmList.length(); i++){
		
		//filter material and label
		String sMyMat = bmList[i].name("material");
		String sMyLab = bmList[i].name("label");	
		sMyMat.trimLeft();
		sMyMat.trimRight();	
		sMyMat.makeUpper();
		sMyLab.makeUpper();	
		if ((sFilterMat.length()>0 && sFilterMat.find(sMyMat,-1) < 0) || 
			 (sFilterLab != "" && sMyLab.find(sFilterLab,0) < 0))
			continue; 
		
		if ( sExcludeMat != "" && sMat2Exclude.find(sMyMat) != -1 )
			continue;
		
		String sValue;
		double dValue;
		String sList[nAllCols.length()];
		sList[0] = bmList[i].posnum();
		sList[1] = bmList[i].name("name");
		sList[2] = nPcsList[i];		
		sValue.formatUnit(bmList[i].solidLength() / U(1,sUnit,2),2,nDecimals);
		sList[3] = sValue;
		if (nUseSolid)
			sValue.formatUnit(bmList[i].solidWidth() / U(1,sUnit,2),2,nDecimals);	
		else
			sValue.formatUnit(bmList[i].dW() / U(1,sUnit,2),2,nDecimals);		
		sList[4] = sValue;
		if (nUseSolid)
			sValue.formatUnit(bmList[i].solidHeight() / U(1,sUnit,2),2,nDecimals);
		else
			sValue.formatUnit(bmList[i].dH() / U(1,sUnit,2),2,nDecimals);
		sList[5] = sValue;	
		sList[6] = bmList[i].name("material");
		sList[7] = bmList[i].name("grade");
		sList[8] = bmList[i].name("information");
		sList[10] = bmList[i].name("profile");
		sList[11] = bmList[i].name("label");
		sList[12] = bmList[i].name("sublabel");
		sList[13] = T(bmList[i].name("type"));				
		/////////////////////////////////////////AJ 			
		String sCutN=bmList[i].strCutN(); 			
		String sCutP=bmList[i].strCutP(); 			
		String sCutNC=bmList[i].strCutNC(); 			
		String sCutPC=bmList[i].strCutPC(); 			
		String sNewCutN=sCutN; 			
		String sNewCutP=sCutP; 			
		String sNewCutNC=sCutNC; 			
		String sNewCutPC=sCutPC; 			
		if (nCompAngle) 			
		{   				
			//CutN 
			String sNewValue; 
			sValue=sCutN.token(0, ">"); 
			dValue=sValue.atof(); 	
			if (dValue<0) 
				dValue=-90-dValue; 
			else 
				dValue=90-dValue; 
			sNewValue.format("%5." + nDecimals +"f", dValue);
			sNewValue.trimLeft();
			sNewValue.trimRight();
			sNewCutN=sNewValue; 
			sNewCutN+=">"; 
			sValue=sCutN.token(1, ">"); 
			dValue=sValue.atof(); 
			if (dValue<0) 
				dValue=-90-dValue; 
			else 
				dValue=90-dValue; 
			sNewValue.format("%5." + nDecimals +"f", dValue);
			sNewValue.trimLeft();
			sNewValue.trimRight();
			sNewCutN+=sNewValue; 
			
			//CutP
			sValue=sCutP.token(0, ">"); 
			dValue=sValue.atof(); 	
			if (dValue<0) 
				dValue=-90-dValue; 
			else 
				dValue=90-dValue; 
			sNewValue.format("%5." + nDecimals +"f", dValue);
			sNewValue.trimLeft();
			sNewValue.trimRight();			
			sNewCutP=sNewValue; 
			sNewCutP+=">"; 
			sValue=sCutP.token(1, ">"); 
			dValue=sValue.atof(); 
			if (dValue<0) 
				dValue=-90-dValue; 
			else 
				dValue=90-dValue; 
			sNewValue.format("%5." + nDecimals +"f", dValue);
			sNewValue.trimLeft();
			sNewValue.trimRight();
			sNewCutP+=sNewValue; 

			//CutNC
			sValue=sCutNC.token(0, ">"); 
			dValue=sValue.atof(); 	
			if (dValue<0) 
				dValue=-90-dValue; 
			else 
				dValue=90-dValue; 
			sNewValue.format("%5." + nDecimals +"f", dValue);
			sNewValue.trimLeft();
			sNewValue.trimRight();
			sNewCutNC=sNewValue; 
			sNewCutNC+=">"; 
			sValue=sCutNC.token(1, ">"); 
			dValue=sValue.atof(); 
			if (dValue<0) 
				dValue=-90-dValue; 
			else 
				dValue=90-dValue; 
			sNewValue.format("%5." + nDecimals +"f", dValue);
			sNewValue.trimLeft();
			sNewValue.trimRight();
			sNewCutNC+=sNewValue; 
			
			//CutPC
			sValue=sCutPC.token(0, ">"); 
			dValue=sValue.atof(); 	
			if (dValue<0) 
				dValue=-90-dValue; 
			else 
				dValue=90-dValue; 
			sNewValue.format("%5." + nDecimals +"f", dValue);
			sNewValue.trimLeft();
			sNewValue.trimRight();
			sNewCutPC=sNewValue; 
			sNewCutPC+=">"; 
			sValue=sCutPC.token(1, ">"); 
			dValue=sValue.atof(); 
			if (dValue<0) 
				dValue=-90-dValue; 
			else 
				dValue=90-dValue; 
			sNewValue.format("%5." + nDecimals +"f", dValue);
			sNewValue.trimLeft();
			sNewValue.trimRight();
			sNewCutPC+=sNewValue; 

		} 			
			
		sList[14] = sNewCutN; 
		sList[15] = sNewCutP; 
		sList[16] = sNewCutNC; 
		sList[17] = sNewCutPC; 	
						
		for (int j = 0; j < nMyCol.length(); j++){
			Point3d ptRefTxt = ptRef + _XW * dBO;
			if (nAlign[nMyCol[j]] == -1){
				ptRefTxt = ptRef + _XW * (dAllWidth[nMyCol[j]] - 2 * dBO);
				ptRefTxt.vis(3);
			}
			dp.draw(sList[nMyCol[j]], ptRefTxt -_YW * dBO, _XW, _YW, nAlign[nMyCol[j]],-1);
			
			PLine pl(ptRef, ptRef + _XW * dAllWidth[nMyCol[j]], 
					ptRef + _XW * dAllWidth[nMyCol[j]] - _YW * (dCharSize + 2 * dBO),
					ptRef - _YW * (dCharSize + 2 * dBO));
			pl.close();
			dp.draw(pl);
			ptRef.transformBy(_XW * (dAllWidth[nMyCol[j]] )); //+ 2 * dBO
		} // next j
		// bring ptIns back to start
		ptRef.transformBy(-_XW * dTotalWidth);	//dTotalWidth	
		ptRef.transformBy(cs);
		
}}
	
//SHEET_____________________________________________________________________________________
// sort sheets
	Sheet shTmp;
	for (int i = 0; i < sh.length(); i++){
		for (int j = 0; j < sh.length()-1; j++){
			if ( sh[j].posnum() > sh[j+1].posnum()){
				shTmp= sh[j+1];
				sh[j+1] = sh[j];
				sh[j] = shTmp;
			}
		}
	}


// collect identical sheets 
	Sheet shList[0];
	nPcsList.setLength(0);
	nPcs = 1;
	for (int j = 0; j < sh.length(); j++){
		if (j==sh.length()-1){
			shList.append(sh[j]);
			nPcsList.append(nPcs);
			nPcs = 1;			
		}
		else{
			if (sh[j].posnum() == sh[j+1].posnum())
				nPcs++;
			else{
				shList.append(sh[j]);
				nPcsList.append(nPcs);
				nPcs = 1;
			}
		}
	} // next j
	
	
	if (nSortCol>=0 && nSortCol<nAllCols.length()) {
	if (nDisplay == 1 && nShowPosNumSh >0){

		// sort sheets for display
		String sArSortKey[shList.length()];
		// first collect the correct sortkey
		for (int i = 0; i < shList.length(); i++){
			String sValue;
			String sList[nAllCols.length()];
			sValue.format("%0 10i",shList[i].posnum());
			sList[0] = sValue;
			sList[1] = shList[i].name("name");
			sValue.format("%0 10i",nPcsList[i]);
			sList[2] = sValue;
			sValue.format("%014.3f", shList[i].solidLength() / U(1,sUnit,2));
			sList[3] = sValue;
			sValue.format("%014.3f", shList[i].solidWidth() / U(1,sUnit,2));
			sList[4] = sValue;
			sValue.format("%014.3f", shList[i].dH() / U(1,sUnit,2));
			sList[5] = sValue;	
			sList[6] = shList[i].name("material");
			sList[7] = shList[i].name("grade");
			sList[8] = shList[i].name("information");
			sList[11] = shList[i].name("label");
			sList[12] = shList[i].name("sublabel");
			sList[13] = T("Sheet") + "/" + T("Lath");
			double dArea = nPcsList[i] * shList[i].profShape().area();
			sValue.format("%014.3f", dArea  / (U(1,sAreaUnit ,2)*U(1,sAreaUnit ,2)));
			sList[18]  = sValue;	
			sArSortKey[i] = sList[nSortCol];
		}

		
		Sheet bmTmp;
		String str;
		int nTmp;
		for (int i = 0; i < shList.length(); i++){
			for (int j = 0; j < shList.length()-1; j++){
				int nSwap = FALSE;
				if (bAscending && ( sArSortKey[j] > sArSortKey[j+1])) nSwap = TRUE;
				if (!bAscending && ( sArSortKey[j] < sArSortKey[j+1])) nSwap = TRUE;

				if (nSwap) {
					bmTmp = shList[j+1];
					shList[j+1] = shList[j];
					shList[j] = bmTmp;
					str = sArSortKey[j+1];
					sArSortKey[j+1] = sArSortKey[j];
					sArSortKey[j] = str;
					nTmp = nPcsList[j+1];
					nPcsList[j+1] = nPcsList[j];
					nPcsList[j] = nTmp;
				}
			}
		}
	}}
		
// write sheet data
	if (nDisplay == 1 && nShowPosNumSh >0){
	for (int i = 0; i < shList.length(); i++){
		//filter material and label
		String sMyMat = shList[i].name("material");
		String sMyLab = shList[i].name("label");		
		sMyMat.makeUpper();
		sMyLab.makeUpper();		
		if ((sFilterMat.length()>0 && sFilterMat.find(sMyMat,-1) < 0) || 
			 (sFilterLab != "" && sMyLab.find(sFilterLab,0) < 0))
			continue; 		
		
		
		
		
		String sValue;
		
		String sList[nAllCols.length()];
		sList[0] = shList[i].posnum();
		sList[1] = shList[i].name("name");
		sList[2] = nPcsList[i];		
		sValue.formatUnit(shList[i].solidLength() / U(1,sUnit,2),2,nDecimals);
		sList[3] = sValue;
		sValue.formatUnit(shList[i].solidWidth() / U(1,sUnit,2),2,nDecimals);		
		sList[4] = sValue;
		sValue.formatUnit(shList[i].dH() / U(1,sUnit,2),2,nDecimals);			
		sList[5] = sValue;	
		sList[6] = shList[i].name("material");
		sList[7] = shList[i].name("grade");
		sList[8] = shList[i].name("information");
		
		sList[11] = shList[i].name("label");
		sList[12] = shList[i].name("sublabel");
		
		//sList[10] = shList[i].name("profile");
		sList[13] = T("Sheet") + "/" + T("Lath");
		double dArea = nPcsList[i] * shList[i].profShape().area();
		dSumArea = dSumArea + dArea;
		sValue.formatUnit(dArea / (U(1,sAreaUnit ,2)*U(1,sAreaUnit ,2)),2,nDecimals2);
		sList[18]  = sValue;	
		//Volume
		double dThisSheetVolume = shList[i].volume();
		sValue.formatUnit(dThisSheetVolume / (U(1,sUnit ,2)*U(1,sUnit ,2)*U(1,sUnit ,2)),2,nDecimals);
		sList[19]  = sValue;
		for (int j = 0; j < nMyCol.length(); j++){
			Point3d ptRefTxt = ptRef + _XW * dBO;
			if (nAlign[nMyCol[j]] == -1){
				ptRefTxt = ptRef + _XW * (dAllWidth[nMyCol[j]] - 2 * dBO);
				ptRefTxt.vis(3);
			}
			dp.draw(sList[nMyCol[j]], ptRefTxt -_YW * dBO, _XW, _YW, nAlign[nMyCol[j]],-1);
			
			PLine pl(ptRef, ptRef + _XW * dAllWidth[nMyCol[j]], 
					ptRef + _XW * dAllWidth[nMyCol[j]] - _YW * (dCharSize + 2 * dBO),
					ptRef - _YW * (dCharSize + 2 * dBO));
			pl.close();
			dp.draw(pl);
			ptRef.transformBy(_XW * (dAllWidth[nMyCol[j]] )); //+ 2 * dBO
		} // next j
		// bring ptIns back to start
		ptRef.transformBy(-_XW * dTotalWidth);	//dTotalWidth	
		ptRef.transformBy(cs);
		
}}


//TSL_______________________________________________________________________________________
// sort tsls
	int nTslSortInd = nSortCol;
	String sTslSortKey = sKeyNames[nSortCol];

	int nKeyType = sArKeyTypeList.find(sArKeyType[nSortCol]);
	
	// #1 sort by posnum: a tsl might not have the map entry TSLBOM
	for (int i = 0; i < tsl.length(); i++)
		for (int j = 0; j < tsl.length()-1; j++)
			if ( tsl[j].posnum() > tsl[j+1].posnum())
				tsl.swap(j,j+1);
	// #2 collect sortable tsls if requested
	TslInst tsl2Sort[0],tslNot2Sort[0];	
	for (int i = 0; i < tsl.length(); i++)
	{
		Map mapBom = tsl[i].map().getMap("TSLBOM");
		if (nKeyType == 0 && mapBom.hasInt(sTslSortKey))
			tsl2Sort.append(tsl[i]);
		else if (nKeyType == 1 && mapBom.hasDouble(sTslSortKey))
			tsl2Sort.append(tsl[i]);
		else if (nKeyType == 2 && mapBom.hasString(sTslSortKey))
			tsl2Sort.append(tsl[i]);
		else
			tslNot2Sort.append(tsl[i]);		
	}
	// #3 sort sublist if requested
	if (nSortCol>0)
	{
		for (int i = 0; i < tsl2Sort.length(); i++)
		{
			for (int j = 0; j < tsl2Sort.length()-1; j++)	
			{					
				Map mapBom0 = tsl2Sort[j].map().getMap("TSLBOM");
				Map mapBom1 = tsl2Sort[j+1].map().getMap("TSLBOM");
				int bDoSwap;
				if (nKeyType == 0)
				{
					if (bAscending && mapBom0.getInt(sTslSortKey)>mapBom1.getInt(sTslSortKey))
						bDoSwap=true;
					else if (!bAscending && mapBom0.getInt(sTslSortKey)<mapBom1.getInt(sTslSortKey))
						bDoSwap=true;								
				}
				else if (nKeyType == 1)
				{
					if (bAscending && mapBom0.getDouble(sTslSortKey)>mapBom1.getDouble(sTslSortKey))
						bDoSwap=true;
					else if (!bAscending && mapBom0.getDouble(sTslSortKey)<mapBom1.getDouble(sTslSortKey))
						bDoSwap=true;									
				}
				else if (nKeyType == 2)
				{
					if (bAscending && mapBom0.getString(sTslSortKey)>mapBom1.getString(sTslSortKey))
						bDoSwap=true;
					else if (!bAscending && mapBom0.getString(sTslSortKey)<mapBom1.getString(sTslSortKey))
						bDoSwap=true;									
				}
				if (bDoSwap)
					tsl2Sort.swap(j,j+1);
			}
		}	
		// recompose the array
		tsl.setLength(0);
		tsl.append(tsl2Sort);		
		tsl.append(tslNot2Sort);		
	}
	
	
// collect identical tsls 
	TslInst tslList[0];
	nPcsList.setLength(0);
	nPcs = 1;
	for (int j = 0; j < tsl.length(); j++){
		if (j==tsl.length()-1){
			tslList.append(tsl[j]);
			nPcsList.append(nPcs);
			nPcs = 1;			
		}
		else{
			if (tsl[j].posnum() == tsl[j+1].posnum())
				nPcs++;
			else{
				tslList.append(tsl[j]);
				nPcsList.append(nPcs);
				nPcs = 1;
			}
		}
	} // next j

// write tsl data
	dp.color(nColorTsl);
	if (nDisplay == 1 && nShowPosNumTSL > 0){
	for (int i = 0; i < tslList.length(); i++){
		String sValue;
		TslInst tsl0 = tslList[i];
		String sList[nAllCols.length()];	
		
		int nQtyParent;
		
		//main part listing
		if (tsl0.map().hasMap("TSLBOM")){
			Map mapSub = tsl0.map().getMap("TSLBOM");
			sList[0] = tsl0.posnum();
			sList[1] = mapSub.getString("Name");
			nQtyParent= mapSub.getInt("Qty") * nPcsList[i];
			sList[2] =nQtyParent;
			if ( mapSub.getDouble("Length")!=0)
			{
				sValue.formatUnit(mapSub.getDouble("Length") / U(1,sUnit,2),2,nDecimals);						
				sList[3] = sValue;
			}
			if ( mapSub.getDouble("Width")!=0)		
			{			
				sValue.formatUnit(mapSub.getDouble("Width") / U(1,sUnit,2),2,nDecimals);					
				sList[4] = sValue;
			}
			if ( mapSub.getDouble("Height")!=0)	
			{	
				sValue.formatUnit(mapSub.getDouble("Height") / U(1,sUnit,2),2,nDecimals);					
				sList[5] = sValue;
			}
			sList[6] = mapSub.getString("Mat");
			sList[7] = mapSub.getString("Grade");
			sList[8] = mapSub.getString("Info");
			sList[10] = mapSub.getString("Profile");
			sList[11] = mapSub.getString("Label");
			sList[12] = mapSub.getString("Sublabel");			
			sList[13] = mapSub.getString("Type");


						
		}
		//draw row
		int bDrawRow = false;
		if (tsl0.map().hasMap("TSLBOM"))
		{
			if (sSpace == sModelSpace || sSpace == sShopdrawSpace)
				bDrawRow =true;
			else if(nZoneIndex == nTslInZone[i] || nAllZones == 0) 
				bDrawRow = true;
		}
		if(bDrawRow){
			for (int j = 0; j < nMyCol.length(); j++){
				Vector3d vxW =  _XW * dAllWidth[nMyCol[j]];
				Point3d ptRefTxt = ptRef + _XW * dBO;
				if (nAlign[nMyCol[j]] == -1)
					ptRefTxt = ptRef + vxW - _XW * 2 * dBO;
				PLine pl(ptRef, ptRef + vxW,	ptRef + vxW - _YW * (dCharSize + 2 * dBO),ptRef - _YW * (dCharSize + 2 * dBO));
				pl.close();
				dp.draw(pl);
				dp.draw(sList[nMyCol[j]], ptRefTxt -_YW * dBO, _XW, _YW, nAlign[nMyCol[j]],-1);
				ptRef.transformBy(vxW);
			} // next j
			// bring ptIns back to start
			ptRef.transformBy(-_XW * dTotalWidth);		
			ptRef.transformBy(cs);
		}

		Map mapParts = tsl0.map().getMap("TslShop").getMap("parts");
		//Subpart listing
		int nSubPosNum;
		for (int t = 0; t < mapParts.length(); t++){
			if (mapParts.hasMap(t)){
				// clear list
				for (int j = 0; j < sList.length(); j++)	
					sList[j]="";
				
				
				// generate a subpart posnum
				nSubPosNum++;
				Map mapPart = mapParts.getMap(t);
				if (mapPart.hasInt("subPosNum"))
					sList[0] = tsl0.posnum() + "." + mapPart.getInt("subPosNum");
				else
					sList[0] = tsl0.posnum() + "." + nSubPosNum;
				sList[1] = mapPart.getString("Name");
				int nQty = mapPart.getInt("Qty");		if (nQty <=0) nQty = 1;
				nQty *= nQtyParent;
				sList[2] = nQty;// * nPcsList[i];
				if ( mapPart.getDouble("Length")!=0)
				{
					sValue.formatUnit(mapPart.getDouble("Length") / U(1,sUnit,2),2,nDecimals);						
					sList[3] = sValue;
				}
				if ( mapPart.getDouble("Width")!=0)		
				{			
					sValue.formatUnit(mapPart.getDouble("Width") / U(1,sUnit,2),2,nDecimals);					
					sList[4] = sValue;
				}
				if ( mapPart.getDouble("Height")!=0)	
				{	
					sValue.formatUnit(mapPart.getDouble("Height") / U(1,sUnit,2),2,nDecimals);					
					sList[5] = sValue;
				}
				sList[6] = mapPart.getString("Mat");
				sList[7] = mapPart.getString("Quality");
				sList[8] = mapPart.getString("Info");
				
				// collect weight data
				double dMyWeight = mapPart.getDouble("Weight");
				dSumWeight = dSumWeight + dMyWeight;
				sValue.formatUnit( dMyWeight ,2,1);
				sList[9] =	sValue;		
				
				//profile								
				sList[10] = mapPart.getString("Profile");
				sList[11] = mapPart.getString("Label");
				sList[12] = mapPart.getString("Sublabel");
				sList[13] = mapPart.getString("Type");
				
				//draw row
				for (int j = 0; j < nMyCol.length(); j++){
					Vector3d vxW =  _XW * dAllWidth[nMyCol[j]];
					Point3d ptRefTxt = ptRef + _XW * dBO;
					if (nAlign[nMyCol[j]] == -1)
						ptRefTxt = ptRef + vxW - _XW * 2 * dBO;
					PLine pl(ptRef, ptRef + vxW,	ptRef + vxW - _YW * (dCharSize + 2 * dBO),ptRef - _YW * (dCharSize + 2 * dBO));
					pl.close();
					dp.draw(pl);
					dp.draw(sList[nMyCol[j]], ptRefTxt -_YW * dBO, _XW, _YW, nAlign[nMyCol[j]],-1);
					ptRef.transformBy(vxW);
				} // next j
				// bring ptIns back to start
				ptRef.transformBy(-_XW * dTotalWidth);		
				ptRef.transformBy(cs);
			}
		}		
}}
	dp.color(nColor);
	
	
// writesum weight
	if ((nWeight>0 && dSumWeight > 0) || dSumArea > 0){
		PLine pl(ptRef, ptRef + _XW * dTotalWidth , 
				ptRef + _XW * dTotalWidth  - _YW * (dCharSize + 2 * dBO),
				ptRef - _YW * (dCharSize + 2 * dBO));
		pl.close();
		dp.draw(pl);			
				
		for (int i = 0; i < nMyCol.length(); i++){
			int nColIndex = nMyCol[i];
			if (sHeaderNames[i] == sHeaderNames[9] && (nWeight>0 && dSumWeight > 0)){
				Point3d ptRefTxt = ptRef;
				if (nAlign[nColIndex] == -1)
					ptRefTxt = ptRef + _XW * (dAllWidth[nColIndex] - 2 * dBO);
				String sValue;
				sValue.formatUnit( dSumWeight,2,1);
				dp.draw(sValue, ptRefTxt, _XW, _YW, nAlign[nColIndex ], -1.5);
			}
			//reportNotice("\n" + "HeaderNames" + sHeaderNames[i] + "  i = "+ i + "  colLength=" + nMyCol.length());
			else if (sHeaderNames[nMyCol[i]] == sHeaderNames[18] && dSumArea > 0){
			
				Point3d ptRefTxt = ptRef;
				if (nAlign[nMyCol[i]] == -1)
					ptRefTxt = ptRef + _XW * (dAllWidth[nColIndex ] - 2 * dBO);
				String sValue;
				sValue.formatUnit( dSumArea/((U(1,sAreaUnit ,2)*U(1,sAreaUnit ,2))),2,1);
				dp.draw(sValue, ptRefTxt, _XW, _YW, nAlign[nColIndex], -1.5);//nMyCol
			}
			ptRef.transformBy(_XW * dAllWidth[i]);
		}//next i
		ptRef.transformBy(-_XW * dTotalWidth - _YW * (dCharSize + dBO * 2));
	}


// append tsls to ppAllSections
	int nShowDpTxt = 250;
	int nSectionColor = 5;
	Display dpPos(5);
	dpPos.dimStyle(sDimStylePosNum);

	
	if (nShowDpTxt > 0){
		PlaneProfile ppAllPosNum;
		Vector3d vMove;
		// beams and sheets
		for (int i = 0; i < ppAllSections.length(); i++){
			Map mapSub = Map();
			int nHideDisplay;
			int nDrawFilled;
			
			
			//filter material and label
			if (entAll[i].bIsKindOf(GenBeam()))	{
				GenBeam gb = (GenBeam)entAll[i];
				String sMyMat = gb.name("material");
				String sMyLab = gb.name("label");		
				sMyMat.makeUpper();
				sMyLab.makeUpper();		
				if ((sFilterMat.length()>0 && sFilterMat.find(sMyMat,-1) < 0) || 
					 (sFilterLab != "" && sMyLab.find(sFilterLab,0) < 0))
					continue; 
			}	
			
					
			// declare display text
			String sDpTxt, sDpTxt2;
			LineSeg lsEnt;
			if (entAll[i].bIsKindOf(Beam()))	{
				Beam bmX = (Beam)entAll[i];
				vMove = bmX.vecX();
				sDpTxt = bmX.posnum() ;
				if (nShowPosNumBm == 4)// log pos num
					sDpTxt = el.number() + "-" + bmX.label()+ "-" + bmX.subLabel2();  
				else if (nShowPosNumBm == 7)// show only length
					sDpTxt.formatUnit(bmX.solidLength(),sDimStylePosNum);  
				nHideDisplay = nZoneIndex;
				if (nShowPosNumBm == 0)
					nHideDisplay = -100;	
				if (nHidePosNumBackground == 1 || nHidePosNumBackground == 4 || nHidePosNumBackground == 5 || nHidePosNumBackground == 7)
					nDrawFilled = _kDrawFilled;	
					
				Vector3d vec = vMove;
				vec.transformBy(ms2ps);		
				vec.normalize();
				lsEnt= ppAllSections[i].extentInDir(vec);	
				//if (!bmX.posnum()==974)
				if(bmX.posnum()==6050)
				{
					lsEnt.vis(5);
					vMove .vis(lsEnt.ptMid(),3);
				}	
			}
		
			if (entAll[i].bIsKindOf(Sheet()))	{
				Sheet shX = (Sheet)entAll[i];
				vMove = shX.vecX();
				sDpTxt = shX.posnum() ;
				nHideDisplay = nZoneIndex;
				if (nShowPosNumSh == 0)
					nHideDisplay = -100;	
				if (nHidePosNumBackground == 2 || nHidePosNumBackground == 4 || nHidePosNumBackground == 6 || nHidePosNumBackground == 7)
					nDrawFilled = _kDrawFilled;
				lsEnt= ppAllSections[i].extentInDir(_YW); 										
			}
			else if (entAll[i].bIsKindOf(TslInst())){
				TslInst tslX;
				tslX= (TslInst)entAll[i];
				
				// test if moving direction is in xy plane of PS
				vMove = tslX.coordSys().vecX();
				vMove.transformBy(ms2ps);
				if (vMove.isParallelTo(_ZW))		
					vMove = _YW;
				vMove.transformBy(ps2ms);

			// get data from tsl BOM map
				Map mapSub = tslX.map().getMap("TSLBOM");
				String myName = scriptName();
				if(mapSub.hasString("Name")) myName = mapSub.getString("Name");								
				
			// set display text
				if (nShowPosNumTSL==1)
					sDpTxt = tslX.posnum();
				else if (nShowPosNumTSL==2)
					sDpTxt = myName ;	
				else if (nShowPosNumTSL==3)
					sDpTxt = tslX.posnum() + " " + myName ;				

				if (mapSub.hasInt("Iconside"))
					nHideDisplay = mapSub.getInt("Iconside");		
				if (nShowPosNumTSL == 0)
					nHideDisplay = -100;		
				if (nHidePosNumBackground == 3 || nHidePosNumBackground == 5 || nHidePosNumBackground == 6 || nHidePosNumBackground == 7)
					nDrawFilled = _kDrawFilled;	
				lsEnt= ppAllSections[i].extentInDir(_YW); 						
			}
			
			// set color for posnum mask
			//
			dpPos.color(nColorBackGround);
			//if (nSectionColor[i] == 254)
			//	dp.color(51);

			
			
			Point3d ptPosNum = lsEnt.ptMid();
			
			ptPosNum.vis(i);
			
			if (sSpace==sShopdrawSpace) //AJ v3.5
			{
				Plane plnZ(ptRef, _ZW);
				ptPosNum=plnZ.closestPointTo(ptPosNum);
			}
			
			double dTxtLengthStyle =  dpPos.textLengthForStyle(sDpTxt ,sDimStylePosNum);
			double dTxtHeightStyle =  dpPos.textHeightForStyle(sDpTxt ,sDimStylePosNum);	
			
			if (nShowPosNumSh >= 2 && entAll[i].bIsKindOf(Sheet())){// show sheets with posnum and size
				dTxtHeightStyle = 1.2 * dTxtHeightStyle;
				Sheet shX;
				shX = (Sheet)entAll[i];
				String sTxt;
				sTxt.formatUnit(shX.solidLength(),sDimStylePosNum);
				sDpTxt2 = sTxt;
				sTxt.formatUnit(shX.solidWidth(),sDimStylePosNum);		
				sDpTxt2 = sDpTxt2 + "x" + sTxt;		
				if (dpPos.textLengthForStyle(sDpTxt2 ,sDimStyle) > dTxtLengthStyle)
					dTxtLengthStyle = dpPos.textLengthForStyle(sDpTxt2 ,sDimStylePosNum);
				
				if (nShowPosNumSh == 2)
				{
					sDpTxt = "";
					dTxtHeightStyle =  dpPos.textHeightForStyle(sDpTxt2 ,sDimStylePosNum);
				}
					
				if (nShowPosNumSh == 5)
				{
					sDpTxt = "";
					sDpTxt2 = shX.material() + round(shX.dH()*10)/10 + " " + sDpTxt2;				
				}								
		
			}

			if (entAll[i].bIsKindOf(Beam())){// show beams with posnum and size

				dTxtHeightStyle = 1.2 * dTxtHeightStyle;
				Beam bmX;
				bmX= (Beam)entAll[i];
				
				String sTxt;
				if (nShowPosNumBm >= 2 && nShowPosNumBm < 4)
				{
					sTxt.formatUnit(bmX.dD(el.coordSys().vecX()),sDimStylePosNum);
					sDpTxt2 = sTxt;
					sTxt.formatUnit(bmX.dD(el.coordSys().vecZ()),sDimStylePosNum);	
					sDpTxt2 = sDpTxt2 + "x" + sTxt;
						
				}
				else if (nShowPosNumBm == 6)// show length
				{
					sTxt.formatUnit(bmX.solidLength(),sDimStylePosNum);
					sDpTxt2 = sTxt;
				}
				if (dpPos.textLengthForStyle(sDpTxt2 ,sDimStyle) > dTxtLengthStyle)
					dTxtLengthStyle = dpPos.textLengthForStyle(sDpTxt2 ,sDimStylePosNum);	
					
				if (nShowPosNumBm == 2){
					sDpTxt = "";
					dTxtHeightStyle =  dpPos.textHeightForStyle(sDpTxt2 ,sDimStylePosNum);
				}	
				
				if (nShowPosNumBm == 6){
					double dTxtL = 1.1*dpPos.textLengthForStyle(sDpTxt + " " + sDpTxt2 ,sDimStylePosNum);
					if (dTxtL > dTxtLengthStyle)
						dTxtLengthStyle = dTxtL;
					dTxtHeightStyle = 0.8*(dTxtHeightStyle+  dpPos.textHeightForStyle(sDpTxt2 ,sDimStylePosNum));
				}										
			}	

			// depreciated since 5.8: it displays only posnum or name
			/*
			if (nShowPosNumTSL >= 2 && entAll[i].bIsKindOf(TslInst())){// show tsls with posnum and size
				dTxtHeightStyle = 2 * dTxtHeightStyle;			
				TslInst tslX;
				tslX= (TslInst)entAll[i];
				
				String sTxt;
				
				Map mapSub = tslX.map().getMap("TSLBOM");
				if ( mapSub.getDouble("Length")!=0){
					sTxt.formatUnit(mapSub.getDouble("Length"),sDimStylePosNum);
					sDpTxt2 = sTxt;
				}
				if ( mapSub.getDouble("Width")!=0){	
					sTxt.formatUnit(mapSub.getDouble("Width"),sDimStylePosNum);
					sDpTxt2 = sDpTxt2 + "x" + sTxt;	
				}													
				if ( mapSub.getDouble("Height")!=0)	{
					sTxt.formatUnit(mapSub.getDouble("Height"),sDimStylePosNum);	
					sDpTxt2 = sDpTxt2 + "x" + sTxt;	
				}
				
				if (dpPos.textLengthForStyle(sDpTxt2 ,sDimStyle) > dTxtLengthStyle)
					dTxtLengthStyle = dpPos.textLengthForStyle(sDpTxt2 ,sDimStylePosNum);	
					
				if (nShowPosNumTSL == 2){
					sDpTxt = "";
					dTxtLengthStyle = dpPos.textLengthForStyle(sDpTxt2 ,sDimStylePosNum);
					dTxtHeightStyle =  dpPos.textHeightForStyle(sDpTxt2 ,sDimStylePosNum);
				}										
			}
			*/				

			// the vMove defines the direction in which the posnum should be moved in case of collission
			vMove.transformBy(ms2ps);
			vMove.normalize();
			vMove.vis(ptPosNum,2);
			// if the posnum should be aligned outside the beam
			if (nPosNumAlignment==2)
			{
				
				Vector3d vyMove = vMove.crossProduct(-_ZW);
				double dYTxtHeight = .5*dTxtHeightStyle;
				double dYEntHeight = abs(vyMove.dotProduct(lsEnt.ptStart()-lsEnt.ptEnd()));
				if (dYTxtHeight > dYEntHeight)	
					dYEntHeight = dYTxtHeight;
				ptPosNum.transformBy(vyMove *dYEntHeight );
				ptPosNum.vis(3);
			}
			
						
			// createposnum mask
			PLine plPosNum(_ZW); //AJ
			plPosNum.addVertex(ptPosNum - 0.5 *(_XW * dTxtLengthStyle +  _YW * dTxtHeightStyle)); 	
			plPosNum.addVertex(ptPosNum - 0.5 *(_XW * dTxtLengthStyle -  _YW * dTxtHeightStyle));
			plPosNum.addVertex(ptPosNum + 0.5 *(_XW * dTxtLengthStyle +  _YW * dTxtHeightStyle));
			plPosNum.addVertex(ptPosNum + 0.5 *(_XW * dTxtLengthStyle -  _YW * dTxtHeightStyle));	
			plPosNum.close();	

			
			// build read direction vectors
			
			Vector3d vxRead = _XW, vyRead = _YW;
			if (nPosNumAlignment>0) // not parallel with _XW
			{
				vxRead = vMove;
				if (vxRead.isParallelTo(_YW) && !vxRead.isCodirectionalTo(_YW))
					vxRead = _YW;
				else if (vxRead.isParallelTo(_XW) && !vxRead.isCodirectionalTo(_XW))
					vxRead = _XW;
				else if (vxRead.dotProduct(_XW)<0)
					vxRead *=-1;
				vxRead.vis(ptPosNum,1);	
				vyRead = vxRead.crossProduct(-_ZW);
			}
			
			double dAngleTo = vxRead.angleTo(_XW);
			CoordSys csRot;
			csRot.setToRotation(dAngleTo,_ZW,ptPosNum);
			if (dAngleTo!=0)
				plPosNum.transformBy(csRot);
			
			
			

			// ensure posnums do not intersect
			int m,d;
			d = 1;
			PlaneProfile pp0 = PlaneProfile(plPosNum);
			
			pp0.intersectWith(ppAllPosNum);

			while (m < 20 && pp0.area() > 0){
				
					
				ptPosNum.transformBy(vMove * d * dTxtHeightStyle * 1);
				plPosNum.transformBy(vMove * d * dTxtHeightStyle * 1);

				
				m++;
				if (d<0)
					d = m+1;
				else
					d = -m-1;
				
				pp0 = PlaneProfile(plPosNum);
				pp0.shrink(-.01 * dTxtHeightStyle);	
				pp0.intersectWith(ppAllPosNum);
			}
			
			// query entity type from allEnts
			int bShowOnlyInBom;
			if (entAll[i].bIsKindOf(Beam()) && nShowPosNumBm == 5)
				bShowOnlyInBom= TRUE;
			else if(entAll[i].bIsKindOf(Sheet())&& nShowPosNumSh == 4)
				bShowOnlyInBom= TRUE;
			else if(entAll[i].bIsKindOf(TslInst())&& nShowPosNumTSL == 4)
				bShowOnlyInBom= TRUE;
				
			// create masking box around posnum and draw it
			if (!bShowOnlyInBom)
			{
			PlaneProfile ppPosNum(plPosNum);
									
			ppAllPosNum.joinRing(plPosNum,_kAdd);
			ppPosNum.shrink(-.1 * dTxtHeightStyle);
	ppAllPosNum.vis(1);	
			if (nHideDisplay == nZoneIndex && nHidePosNumBackground>-1)
				dpPos.draw(ppPosNum, nDrawFilled);
			if (entAll[i].myZoneIndex() < 0)
				dpPos.color(5);
			else if (entAll[i].myZoneIndex() > 0)
				dpPos.color(82);	
			else{
				if (entAll[i].bIsKindOf(TslInst()))
					dpPos.color(nColorTsl);				
				else
					dpPos.color(38);											
			}
		// HSB-11342: merge with the change from contentDACH in v6.9
		// Added in version 6.9 in content DACH for company Rubner Haus
			if(projectSpecial() == "RUB")
				dpPos.color(nColor);
			
			// draw txt
			if (nHideDisplay == nZoneIndex){
			if (sDpTxt != "" && sDpTxt2 != "")
			{
				dpPos.textHeight(0.9 * dpPos.textHeightForStyle(sDpTxt ,sDimStylePosNum));
				// set color of text
				if (nDrawFilled != _kDrawFilled)
					dpPos.color(nColor);//customer color
				else
					dpPos.color(250);// like black
			// HSB-11342: merge with the change from contentDACH in v6.9
			// Added in version 6.9 in content DACH for company Rubner Haus
				if(projectSpecial() == "RUB")
					dpPos.color(nColor);
				String sText = sDpTxt + " " + sDpTxt2;
				dpPos.draw(sText , ptPosNum, vxRead, vyRead, 0,0);
				/*
//rota				dpPos.draw(sDpTxt  , ptPosNum + _YW * 0.25 * dTxtHeightStyle / 0.8, _XW, _YW, 0,0);
				dpPos.draw(sDpTxt  , ptPosNum + vMove * 0.25 * dTxtHeightStyle / 0.8, vxRead, vyRead, 0,0);

				dpPos.textHeight(dpPos.textHeightForStyle(sDpTxt ,sDimStylePosNum));							
// rota				dpPos.draw(sDpTxt2 , ptPosNum - _YW * 0.25 * dTxtHeightStyle, _XW, _YW, 0,0);				
				dpPos.draw(sDpTxt2 , ptPosNum - vMove * 0.25 * dTxtHeightStyle, vxRead, vyRead, 0,0);
				*/
			}
			else if (sDpTxt2 != ""){
				dpPos.textHeight(dpPos.textHeightForStyle(sDpTxt ,sDimStylePosNum));				
// rota				dpPos.draw(sDpTxt2 , ptPosNum, _XW, _YW, 0,0);	
				dpPos.draw(sDpTxt2 , ptPosNum, vxRead, vyRead, 0,0);	
			}		
			else{
				dpPos.textHeight(0.8 * dpPos.textHeightForStyle(sDpTxt ,sDimStylePosNum));				
// rota				dpPos.draw(sDpTxt , ptPosNum, _XW, _YW, 0,0);
				dpPos.draw(sDpTxt , ptPosNum, vxRead, vyRead, 0,0);
			}
			}
			}//showOnlyInBom
		}// next i
	}// end if

















































#End
#BeginThumbnail
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
1`4`%`!0`4`%`!0`4`%`'_]D`
`





































#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-11342: merge with the change from contentDACH in v6.9" />
      <int nm="MAJORVERSION" vl="6" />
      <int nm="MINORVERSION" vl="12" />
      <str nm="DATE" vl="6/7/2021 2:28:52 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End