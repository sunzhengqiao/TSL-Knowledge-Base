#Version 8
#BeginDescription
DE erzeugt Bemassungen im Layout
EN creates dimlines in paperspace


#Versions:
Version 2.4 11/08/2025 HSB-24401: Make sure dimension is outside of viewport , Author Marsel Nakuci
version  value="2.3" date="02.12.2019" author="marsel.nakuci@hsbcad.com" 
HSB-5981: collectDimPoints will only collect the relevant points; use all beams for this method
HSBCAD-568 bugfix reference points 

























#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 2
#MinorVersion 4
#KeyWords elements; dimensioning; layout
#BeginContents
/// History
///#Versions:
// 2.4 11/08/2025 HSB-24401: Make sure dimension is outside of viewport , Author Marsel Nakuci
///<version  value="2.3" date="02.12.2019" author="marsel.nakuci@hsbcad.com"> HSB-5981: collectDimPoints will only collect the relevant points; use all beams for this method </version>
///<version  value="2.2" date="28feb19" author="thorsten.huck@hsbcad.com"> HSBCAD-568 bugfix reference points </version>
///<version  value="2.1" date="26jul18" author="thorsten.huck@hsbcad.com"> beam dimension mode 'all' displays the extreme dimensions in the given direction </version>
///<version  value="2.0" date="09feb18" author="thorsten.huck@hsbcad.com"> bugfix aligned beams with end tools </version>
///<version  value="1.81" date="27oct16" author="thorsten.huck@hsbcad.com"> bugfix in Y-dim when reference and dimension zone were identical </version>
///<version  value="1.80" date="20sep16" author="florian.wuermseer@hsbcad.com"> collect beams by beamtype corrected </version>
///<version  value="1.79" date="24jun16" author="thorsten.huck@hsbcad.com"> dimension mode 'all' on sips and sheets fixed </version>
///<version  value="1.78" date="26nov15" author="thorsten.huck@hsbcad.com"> margin bodies will be extended by its width if start value = 0 </version>
///<version  value="1.77" date="23oct15" author="thorsten.huck@hsbcad.com"> margin bodies completely revised </version>
///<version  value="1.76" date="25mar15" author="th@hsbCAD.de"> properties are now categorized </version>
///<version  value="1.75" date="20mar15" author="th@hsbCAD.de"> supports multiple tsl names </version>
///<version  value="1.74" date="18mar15" author="th@hsbCAD.de"> bugfix beam dimensions introduced 1.72 </version>
///<version  value="1.73" date="23feb15" author="th@hsbCAD.de"> bugfix zone reference </version>
///<version  value="1.72" date="02jan15" author="th@hsbCAD.de"> performance enhanced </version>
///<version  value="1.71" date="02sep13" author="th@hsbCAD.de"> dimpoints outside of viewport can be permanently disabled/enabled on custom context request </version>
///<version  value="1.70" date="25feb13" author="th@hsbCAD.de"> tsl dimensioning supports include/exclude colors, include colors have priority over exclude colors</version>
///<version  value="1.69" date="15feb13" author="th@hsbCAD.de"> bugfix tsl dimensioning of non mapped tsl's </version>
///<version  value="1.68" date="05jul12" author="th@hsbCAD.de"> property 'Show Offsets' will display a negative value if the sheet is cut back in relation to the reference </version>
///<version  value="1.67" date="05jul12" author="th@hsbCAD.de"> bugfix (introduced 1.62) when filtering tsl dimpoints to margin</version>
///<version  value="1.66" date="05jul12" author="th@hsbCAD.de"> all dummies will ignored for dimensioning</version>
///<version  value="1.65" date="15jun12" author="th@hsbCAD.de"> new scale factor property introduced to allow scaling to dwg independent unit when using autoscale property</version>
///<version  value="1.64" date="15jun12" author="th@hsbCAD.de"> beam dimensioning rhomb shaped elements enhanced</version>
///<version  value="1.63" date="29may12" author="th@hsbCAD.de"> dimensioning of tsl based openings of sheetings enhanced</version>
///<version  value="1.62" date="02may12" author="th@hsbCAD.de"> dimpoints outside of viewport are ignored. this enables its usage in detail view ports</version>
///<version  value="1.61" date="16apr12" author="th@hsbCAD.de">bugfix tsl and sheet dim</version>
///<version  value="1.60" date="20mar12" author="th@hsbCAD.de">bugfix element roof zone 0 left/right dim</version>
///<version  value="1.59" date="12mar12" author="th@hsbCAD.de">bugfix ordering points exclude color</version>
///<version  value="1.58" date="16feb12" author="th@hsbCAD.de">new property to include/exclude entities with a given code</version>
///<version  value="1.57" date="28oct11" author="th@hsbCAD.de">new property to include entities with a given label</version>
/// Version 1.56   th@hsbCAD.de   24.03.2011
/// debug message suppressed
/// Version 1.55   th@hsbCAD.de   12.11.2010
/// TSL dimensioning supports exclude color settings
/// Version 1.54   th@hsbCAD.de   29.11.2010
/// BLOCK Element-groups are ignored to detect room dimensions
/// Version 1.53   01.07.2010	th@hsbCAD.de
/// bugfix room dimensions
/// Version 1.52   16.06.2010	th@hsbCAD.de
/// New option to display only the extremes of a dimline. 
///    If the option 'Extremes Dimensioning' is set to one of the exclusive options only the extreme dimension is displayed
/// Improved element reference dimensioning for wall elements
///    The outline of an element is used to display an element reference.
///    If the element outline embraces also zones which have an internal thickness of zero 
///    the outline is modified as if the outline would not contain these zones. This enables to display
///    the correct element length also on mitred elements if it contains zones with a thickness of zero
/// Version 1.51   07.05.2010	th@hsbCAD.de
/// bugfix room dimensions
/// Version 1.50   29.04.2010	th@hsbCAD.de
/// bugfix II TSL dimensioning filters those tsl's which have a public coordinate system (vx,vy,vz) and do not align with the 
/// X-direction of the dimline
/// Version 1.49   16.04.2010	th@hsbCAD.de
/// bugfix TSL dimensioning filters those tsl's which have a public coordinate system (vx,vy,vz) and do not align with the 
/// X-direction of the dimline
/// Version 1.48   07.04.2010	th@hsbCAD.de
/// bugfix display opening size
/// bugfix XY orientation of beam dimensioning
/// Version 1.47   06.04.2010	th@hsbCAD.de
/// TSL dimensioning filters those tsl's which have a public coordinate system (vx,vy,vz) and do not align with the 
/// X-direction of the dimline
/// Version 1.46   29.03.2010	th@hsbCAD.de
/// dimpoints of attached TSL's pLayoutDimX (X=U,O,L,R,M) published
/// Version 1.45   12.02.2010	th@hsbCAD.de
/// bugfix reference points
/// Version 1.44   05.02.2010	th@hsbCAD.de
/// margins enhanced
/// Version 1.43   22.01.2010	th@hsbCAD.de
/// Element reference and zone dimensioning for roof elements enhanced
/// Version 1.42   11.01.2010	th@hsbCAD.de
/// bugfix left/right sheets
/// Version 1.41   02.12.2009	th@hsbCAD.de
/// bugfix sips
/// Version 1.40   02.12.2009	th@hsbCAD.de
/// bugfix TSL dimensioning with margins
/// Version 1.39   01.12.2009	th@hsbCAD.de
/// new property "Show Offsets" will show the offsets on each edge of a given zone to an outer contour. The outer 
/// contour can be derived from the frame (zone 0) or from the element outline
/// Version 1.38   13.11.2009	th@hsbCAD.de
/// bugfix 'bearing points'
/// bugfix an outer contoursheeting dimension
/// VerCAD.de
/// new option object to dim 'bearing points'
/// this option is designed for floor elements. it will display dimpoints of underlaying walls as well as objects which do not 
/// belong to the floor group but are perpendicular to the dimension direction and interscting the designated zone.
/// i.e. a load bearing steel profile bearing the floor element will result in dimpoints at the floor element
/// Version 1.36   05.11.2009	
/// functionality of filter margins extended for filtered tsl's
/// Version 1.35   05.11.2009	th@hsbCAD.de
/// Room dimensioning in conjunction with floor elements collects only wall elements which intersect the floor element contour
/// Version 1.34   14.10.2009	th@hsbCAD.de
/// new property 'Reference by' allows to set the reference points by the outline of the element or by the extreme points of a zone
/// properties reordered
/// ordering of the dimpoints is now dependent from the WCS in paperspace and not from the ECS in Modelspace. This allows to swap X and Y
/// of elements in paperspace
/// Version 1.33   01.10.2009	th@hsbCAD.de
/// ElementRoof Openings appended
/// Version 1.32   10.09.2009	th@hsbCAD.de
/// bugfix
/// Version 1.31   10.09.2009	th@hsbCAD.de
/// Dimension objects can be combined with TSL's to be dimensioned. If a valid TSL name is given the appropriate dimpoints
/// will be added to the dimline
/// Version 1.30   04.08.2009	th@hsbCAD.de
/// format of opening description is now dependent from actual dimstyle
/// offset at openings for all zones fixed
/// Version 1.29   28.07.2009	th@hsbCAD.de
/// requires hsbCAD 2009+ or higher
/// new option to dimension sips
/// Version 1.28   28.07.2009	th@hsbCAD.de
/// bugfix: display of opening offsets in mirrored views corrected
/// Version 1.27   10.07.2009	th@hsbCAD.de
/// new property 'Autoscale Dimline ' to enable/disable the scaling of the dimension. Default = AutoScale Yes
/// Version 1.26   25.05.2009	th@hsbCAD.de
/// Property 'Exclude entities with color' enhanced. Multiple entries can be entered by adding a semikolon as separator
/// NOTE: to avoid an 'X' to be displayed as missing property one has to reinsert the tsl if the tsl was attached to a viewport
/// with any version before 1.25
/// Version 1.25   22.05.2009	th@hsbCAD.de
/// Translation issue fixed
/// Version 1.24   04.07.2008   th@hsbCAD.de
/// DE   Raumbemassung: Extrempunkte des Deckenelementes ergänzt
/// EN   Rooms: Extreme points of floor element appended
/// Version 1.23   03.07.2008   th@hsbCAD.de
/// DE   - neue Option 'Räume'
///    - ist das aktuelle Element ein Wandelement, so werden alle anschließenden
///      Wände vermaßt
///    - ist das Element ein Deckenelement, so werden alle Elemente unterhalb des
///      Deckenelementes vermaßt, welche sich mindestens um 10mm mit der gewählten
///      Zone des Elementes verschneiden
///    - Räume werden nur in der horizontalen Maßkette vermaßt. Jegliche Filterfunktionen
///      dieses TSL's haben bei dieser Option keine Auswirkung
/// EN   - new option 'Rooms'
///    - if the current element is of type wall element all connected elements will be dimensioned
///    - if the current element is of type floor element each wall element below this element
///      will be dimensioned if it has an intersection of at least 10mm with selected zone of the
///      main element
///    - Room dimensions are only shown in the horizontal dimension chain. All filter functionality
///      of this tsl is deactivated for this option
/// Version 1.22   05.06.2008   th@hsbCAD.de
/// DE   - Bemassung auschließlich 'Stab-Paket' verbessert
/// EN   - dimensioning of 'Beampacks' without TSL filtering fixed
/// Version 1.21   17.05.2008   th@hsbCAD.de
/// DE   neues Bemassungsobjekt 'Stab-Paket' ermlicht die Bemassung von Paketen.
///    Diese Option ist begrenzt auf senkrecht zur Elementebene angeordnete Stäbe. Stäbe,
///    welche von der Paketbemassung ausgeschlossen werden sollen können ・er die
///    neue Option 'Paket-Ausschluß durch Stabart' definiert werden
///    Die Paketbemassung unterst・zt nicht die Filtermethoden nach Bauteilfarbe
/// EN   new object to dimension 'Beam Pack'. This option is limited to beams which
///    are perpendicular to the element axis. You can exclude beams from being packed by
///    the new option 'Exclude Beams by Type for Packs'
///    Beam Packs do not support the filter methods by color.
/// 
/// ***************** Version hsbCAD 2009 required*******************
/// 
/// 
/// Version 1.20   17.05.2008   th@hsbCAD.de
/// DE   neue Option um die Ausrichtung von Zwischenmaßen und Kettenmaßen festzulegen
///    neue Option um Stäbe nach Typ zu filtern
///    zentrische Bemassung korrigiert
/// EN   new option to set delta dims on top
///    new option to filter beamtypes
///    center dim fixed
/// Version 1.19   06.05.2008   th@hsbCAD.de
/// DE   neue Option der ﾖffnungsbemassung erlaubt Vorsprungsmaße je ﾖffnungsseite (keine geschweiften Konturen)
/// EN   new option of opening dimensioning allows offset dimensioning of individual opening edges
/// Version 1.18   06.05.2008   th@hsbCAD.de
/// DE   neue Eigenschaft 'Exklusivfarbe' filtert die Bemassungsobjekte nach gewählten Farben.
///      Die zu filternden Farben werden mit einem ';' getrennt
/// EN   new property 'Exclusive Color' enables filtering of entities with certain colors
///      Separate multiple colors with the character ';'
/// Version 1.18   01.10.2007   th@hsbCAD.de
/// DE  Stäbe die nicht in Zone 0 liegen werden nun auch in der Länge vermaßt
/// EN Beams which are not in zone 0 are dimensioned in length
/// Version 1.17   16.07.2007   th@hsbCAD.de
/// DE  Zone 0 als Plattenzone ergänzt
///    Stäbe in Plattenzonen können vermaßt werden
///    HINWEIS: f・ Instanzen, welche mit 舁teren Versionen dieses TSL's eingef・t
///    wurden muß die Eigenschaft 'ZONE' angepaßt werden
/// EN   zone 0 added to sheeting zones
///    beams in sheeting zones can be dimenioned
///    NOTE: the property 'zone' must be adjusted for instances of this tsl
///    which have been inserted with a previous release
/// Version 1.16   09.07.2007   th@hsbCAD.de
/// DE neues Bemassungsobjekt 'ﾖffnung' ergänzt
/// EN new dimension object 'opening' added
/// Version 1.15   05.02.2007   th@hsbCAD.de
/// DE  bugFix Referenzpunkte
/// EN  bugFix reference points
/// Version 1.14   10.01.2007   th@hsbCAD.de
/// DE neuer Objekttyp zur Blockbohlenvermaßung ergänzt
///    - es werden alle Standardblockverkämmungen in der horizontalen Maßkette
///      zentrisch vermaßt
///    - Bohlen werden nun auch horizontal bemaßt
///    - ﾖffnungsgren werden optional angezeigt
///    - automatische Bemassungsskalierung ergänzt
///    - neue Option zur Darstellung der Anschlußwände
/// EN   new object type for log dimensioning
///    - all hsbCAD standard notches will be detected and dimensioned on the
///      center of the tool
///    - logs will now also be dimensioned on the horizontal dimline
///    - optional display of opening sizes
///    - automated dimensioning scaling added
///    - new option for connecting walls
/// Version 1.10   22.02.2006   th@hsbCAD.de
///    - Leserichtung der Bemassungsketten verbessert
/// Version 1.9   10.02.2006   th@hsbCAD.de
///    - neue Option um alle Bemassungspunkte (insbesondere bei Platten) zu bemassen
/// Version 1.8   04.11.2005   th@hsbCAD.de
///    - die Anzeige der Maßketten erfordert mindestens einen Bemassungspunkt in
///      der gewählten Zone
///    - die Maßkette wird immer auf Layer 0 gezeichnet
/// Version 1.7   04.07.2005   th@hsbCAD.de
///    - Berechnung der Referenz- und Maßpunkte erweitert
/// Version 1.6   21.06.2005   th@hsbCAD.de
///    - TSL-Bemassungen werden nur bei vorhandenen TSL's angezeigt
///    - Exrtrempunkte werden korrekt bemaßt
/// Version 1.5   31.05.2005   th@hsbCAD.de
///    - bugFix: Lesbarkeit bei gespiegelten Ansichtsfenstern
///    - neue Option 'Maßketten' ermlicht die Darstellung einer Objekt- und/oder
///      Gesamtmaßkette
///    - die Option 'Ausschlußfarbe' wirkt sich nun auch auf die Referenzzone aus
/// Version 1.4   30.05.2005   th@hsbCAD.de
///    - Filtergrenzen und Ausschlußfarbe ergänzt
///    - Bemassungsalgorhytmus f・ die Bemassungsseiten 'links, rechts und
///      beide' geändert
/// Version 1.3   24.05.2005   th@hsbCAD.de
///    - 'TSL-Filter' bugFix
/// Version 1.2   24.05.2005   th@hsbCAD.de
///    - 'TSL'-Bemassungen erhalten als Beschriftung den Namen des TSL's, wenn kein
///      Alias eingegeben wurde
/// Version 1.1   24.05.2005   th@hsbCAD.de
///    - vertikale und horizontale Maßketten können einzelnd dargestellt werden
///    - Rahmen ist Referenzzone f・ Plattenzonen
///    - Option 'TSL' interpretiert jetzt beliebig viele Punkte des gefilterten TSL's
///      Die Punkte des gefilterten TSLs m・sen im Map des TSL's mit der Syntax
///      'ptExtraDim<n>'
///      gespeichert werden (n ist der fortlaufende Zähler beginnend bei 0)


// // ########################################################################
// Script			:  hsbCAD Layout-Bemassung
// Description	: creates dimlines in paperspace
// Author		: th@hsbCAD.de
// Date			: 24.05.2005
// ------------------------------------------------------------------------------------------------------------------------------------
// Changes:
// ---------------
// Date		Change By		Description
// ------------------------------------------------------------------------------------------------------------------------------------
// 10.01.07	th@hsbCAD.de	log dims added
// 10.01.07	th@hsbCAD.de	opening size added
// 10.01.07	th@hsbCAD.de	automatic scaling added
// 10.01.07	th@hsbCAD.de	connecting walls added
// 05.02.07	th@hsbCAD.de	bugfix reference points
// #########################################################################




//basics and props
	Unit(1,"mm"); // script uses mm
	double dEps=U(.1);
	
	int nDebugTsl=true;
	
	String sArNY[] = { T("|No|"), T("|Yes|")};	
	String sPropDesc = T("|Separate multiple entries by|")+ " ' ;'";


	String sArDimObj[] = {T("|Beams|"), T("|Sheets or Sips|"), T("|TSL|"), T("|Logs|"), T("|Openings|"), T("|Beam Packs|"),T("|Rooms|"),T("|Bearing Points|")};
	PropString sDimObj(5, sArDimObj, T("|Objects to dim|"));
	String sArReferenceBy[] = {T("|Element|"), T("|Zone|")+ " -5", T("|Zone|")+ " -4", T("|Zone|")+ " -3", T("|Zone|")+ " -2", T("|Zone|")+ " -1", T("|Zone|")+ " 0", 
		T("|Zone|")+ " 1", T("|Zone|")+ " 2", T("|Zone|")+ " 3", T("|Zone|")+ " 4", T("|Zone|")+ " 5"};
	PropString sReferenceBy(20, sArReferenceBy, T("|Reference Objects|"),6);
	int nArZn[] = {-5,-4,-3,-2,-1,0,1,2,3,4,5};
	PropInt nZn(1,nArZn, T("|Zone|"),4);	
	
	PropString sTSLName(9, "", T("|TSL Name|"));	
	sTSLName.setDescription(sPropDesc);
	
	String sArShowOpSize[] = {T("|None|"),T("|Size|"),T("|Elevations|"), T("|Offsets|"), T("|Size|") + " & " + T("|Elevations|"),T("|Size|") + " & " + T("|Offsets|"),T("|Elevations|") + " & " +  T("|Offsets|"), T("|All|")};
	PropString sShowOpSize(11, sArShowOpSize, T("|Show size of openings|"));	
	
	PropString sShowConnectingElements(12, sArNY, T("|Show connecting elements|"));


// category dimension
	String sCategoryDimension = T("|Dimension|");	
	String sArShowOffsetsAngles[] = {T("|None|"),T("|Offsets to frame|"),T("|Offsets to Element|")};
		//,T("|Offsets to frame|") + " + "+ T("|Angles|"),T("|Offsets to Element|") + " + " +T("|Angles|")};
	PropString sShowOffsetsAngles(21, sArShowOffsetsAngles, T("|Show Offsets|")); 							sShowOffsetsAngles.setCategory(sCategoryDimension );
		
	String sArDimDir[] = {T("|Horizontal|"), T("|Vertical|"), T("|Horizontal|") + " + "+T("|Vertical|")};
	PropString sDimDir(1,sArDimDir, T("|Alignment|"));															sDimDir.setCategory(sCategoryDimension );

	//String sArChains[] = {T("Object"), T("Extremes"), T("Both")};
	//PropString sChains(10,sArChains, T("Dimlines"));
	//int nChain = sArChains.find(sChains,0);
	
	String sArDisplayMode[] = {T("|Parallel|"),T("|Perpendicular|"),T("|None|")};
	PropString sDisplayModeDelta(2,sArDisplayMode,T("|Delta|") + " " + T("|Dimensioning|"));					sDisplayModeDelta.setCategory(sCategoryDimension );
	PropString sDisplayModeChain(3,sArDisplayMode,T("|Chain|") + " " + T("|Dimensioning|"));					sDisplayModeChain.setCategory(sCategoryDimension );
	String sArDisplayOnTop[] = {T("|No|"),T("|Horizontal|"),T("|Vertical|"),T("|Both|")};	
	PropString sDisplayOnTop(14,sArDisplayOnTop,"   " + T("|Swap Side of Delta and Chain|"));					sDisplayOnTop.setCategory(sCategoryDimension );
	int nDisplayOnTop = sArDisplayOnTop.find(sDisplayOnTop,0);	
	
	String sArDisplayModeExtremes[] = {T("|Parallel|"),T("|Perpendicular|"),T("|None|"),T("|Parallel|") + " " + T("|exclusive|"),T("|Perpendicular|") + " " + T("|exclusive|")};
	PropString sDisplayModeExtremes(10,sArDisplayModeExtremes,T("|Extremes|") + " " + T("|Dimensioning|"));	sDisplayModeExtremes.setCategory(sCategoryDimension );
	int nDisplayModeExtremes = sArDisplayModeExtremes.find(sDisplayModeExtremes,2);

	String sArDisplayOnTopExtremes[] = {T("|No|"),T("|Horizontal|"),T("|Vertical|"),T("|Both|")};	
	PropString sDisplayOnTopExtremes(15,sArDisplayOnTopExtremes,"   " + T("|Swap Side of Extremes|"));		sDisplayOnTopExtremes.setCategory(sCategoryDimension );
	int nDisplayOnTopExtremes = sArDisplayOnTopExtremes.find(sDisplayOnTopExtremes,0);

// category sorting 
	String sCategorySorting = T("|Sorting|");		
	int nArDimType[] = {_kLeft, _kRight, _kLeftAndRight, _kCenter,4};
	String sArDimType[] = {T("|Left|"), T("|Right|"), T("|Left & Right|"), T("|Center|"), T("|All|")};
	PropString sDimType(8,sArDimType, T("|Collect dimpoints|"));			sDimType.setCategory(sCategorySorting );
	String sArDimDirX[] = {T("|left to right|"), T("|right to left|")};
	PropString sDimDirX(6,sArDimDirX, T("|order X-direction|"));			sDimDirX.setCategory(sCategorySorting );
	String sArDimDirY[] = {T("|bottom to top|"), T("|top to bottom|")};
	PropString sDimDirY(7,sArDimDirY, T("|order Y-direction|"));			sDimDirY.setCategory(sCategorySorting );
			
// category range filter
	String sDesc1 = T("|Sets the beginning of a filter range in|");
	String sDesc2X = T("|X-World|");
	String sDesc2Y = T("|Y-World|");
	String sDesc3 = T("|Direction of the viewport|");	
	String sDesc4 = T("|A negative value transforms the range to the opposite side of the element.|");
	String sDesc5 = T("|Sets the end of a filter range in|");
	
		
	String sCategoryRangeFilter = T("|Range Filter|");
	PropDouble dLowerMarginX(2,U(0), T("|X-Start|"));	
	dLowerMarginX.setDescription( sDesc1+" " +sDesc2X + " " +sDesc3 + " " + sDesc4);
	dLowerMarginX.setCategory(sCategoryRangeFilter);
	PropDouble dUpperMarginX(3,U(0), T("|X-End|"));		
	dUpperMarginX.setDescription( sDesc5+" " +sDesc2X);
	dUpperMarginX.setCategory(sCategoryRangeFilter);
	
	
	PropDouble dLowerMarginY(0,U(0),T("|Y-Start|"));
	dLowerMarginY.setDescription( sDesc1+" " +sDesc2Y + " " +sDesc3 + " " + sDesc4);
	dLowerMarginY.setCategory(sCategoryRangeFilter);
	PropDouble dUpperMarginY(1,U(0), T("|Y-End|"));		
	dUpperMarginY.setDescription( sDesc5+" " +sDesc2Y);
	dUpperMarginY.setCategory(sCategoryRangeFilter);

// category property filter	
	String sCategoryExcludePropertyFilter = T("|Exclude Property Filter|");
	PropString sExcludeBeamtype4Pack(17, "",  T("|Beam type|"));	sExcludeBeamtype4Pack.setCategory(sCategoryExcludePropertyFilter );
	sExcludeBeamtype4Pack.setDescription(sPropDesc + " " + T("|See corresponding property to see available Beamtypes|"));	
	PropString sExcludeColor(18,"", +  T("|Color|"));					sExcludeColor.setCategory(sCategoryExcludePropertyFilter );
	PropString sExcludeCode(24, "",   T("|Beamcode|"));				sExcludeCode.setCategory(sCategoryExcludePropertyFilter );
	sExcludeColor.setDescription(sPropDesc );	
	
	String sCategoryIncludePropertyFilter = T("|Include Property Filter|");		
	PropString sBeamtype(16, "",   T("|Beam Type|")+" ");				sBeamtype.setCategory(sCategoryIncludePropertyFilter );
	sBeamtype.setDescription(sPropDesc + " " + T("|See corresponding property to see available Beamtypes|"));
	PropString sIncludeColor(13,"",  T("|Color|")+" ");					sIncludeColor.setCategory(sCategoryIncludePropertyFilter );
	sIncludeColor.setDescription(sPropDesc );	
	PropString sIncludeCode(23, "",   T("|Beamcode|")+" ");				sIncludeCode.setCategory(sCategoryIncludePropertyFilter );
	PropString sIncludeLabel(22, "",   T("|Label|")+" ");					sIncludeLabel.setCategory(sCategoryIncludePropertyFilter );
	
// category display 	
	String sCategoryDisplay = T("|Display|");		
	PropString sDimStyle(0, _DimStyles, T("|Dimstyle|"));				sDimStyle.setCategory(sCategoryDisplay);
	PropString sAutoScaleDimline(19, sArNY,  T("|Autoscale Dimlines|"),1);sAutoScaleDimline.setCategory(sCategoryDisplay);
	PropDouble dScaleFactor(4,1, T("|Autoscale Factor|"),_kNoUnit);	dScaleFactor.setCategory(sCategoryDisplay);
	PropString sDescAlias(4,"",T("|Description Alias|"));					sDescAlias.setCategory(sCategoryDisplay);
	PropInt nColor (0,171,T("|Color|")+"  ");									nColor .setCategory(sCategoryDisplay);

	
	String sNotchTypes[] = {"HSB_EWALLINTERSECTIONSTANDARD", "HSB_EWALLINTERSECTIONSTONEMILLNOTCH","HSB_EWALLINTERSECTIONLOGDOVE", "HSB_EWALLINTERSECTIONDIAGONAL","HSB_EWALLINTERSECTIONSADDLENOTCH"};	
	
	if (_bOnInsert) {
		_Pt0 = getPoint(T("|Insertion point|")); // select point
		Viewport vp = getViewport(T("|Select a viewport|")); // select viewport
  		_Viewport.append(vp);
		nZn.set(vp.activeZoneIndex());
		showDialog(T("|_Default|"));
		return;
	}	


// set the diameter of the 3 circles, shown during dragging
	setMarbleDiameter(U(4));

// ints
	int nShowOpSize = sArShowOpSize.find(sShowOpSize,0);
	int bAutoScale =sArNY.find(sAutoScaleDimline,1);
	int nArReferenceBy[] = {99,-5,-4,-3,-2,-1,0,1,2,3,4,5};
	int n = sArReferenceBy.find(sReferenceBy);
	if(n<0 || n>11) n=0;
	int nReferenceBy =nArReferenceBy[n];
	int nShowOffsetsAngles=sArShowOffsetsAngles.find(sShowOffsetsAngles);
	int nDimDir = sArDimDir.find(sDimDir);
	
// restrict color index
	if (nColor > 255 || nColor < -1) nColor.set(171);
	
// collect a list of upper case beamtypes if requested	
	String sUpperBeamTypes[0];
	if (sBeamtype!= "" || sExcludeBeamtype4Pack!="")
	{
		sUpperBeamTypes = _BeamTypes;
		for (int i = 0; i < sUpperBeamTypes.length(); i++)
			sUpperBeamTypes[i].makeUpper();
	}	

// build arrays for exclusive color
	int nIncludeColors[0]; // collect exclusive colors
	int nBeamtypes[0];
	int nExcludeBeamtype4Pack[0];
	String sList;
	sList = sIncludeColor;
	for (int i = 0; i < 3; i++)
	{
		while (sList.length()>0 || sList.find(";",0)>-1)
		{
			String sToken = sList.token(0);	
			sToken.trimLeft();
			sToken.trimRight();		
			sToken.makeUpper();
			double dToken = sToken.atof();
			int nToken = sToken.atoi();
			if (i==0 && nIncludeColors.find(nToken)<0)					nIncludeColors.append(nToken);
			else if (i==1 && sUpperBeamTypes.find(sToken)>-1)			nBeamtypes.append(sUpperBeamTypes.find(sToken));
			else if (i==2 && sUpperBeamTypes.find(sToken)>-1)			nExcludeBeamtype4Pack.append(sUpperBeamTypes.find(sToken));

			int x = sList.find(";",0);
			sList.delete(0,x+1);
			sList.trimLeft();	
			if (x==-1)
				sList = "";	
		}
		if (i == 0)	sList = sBeamtype;
		else if (i == 1)	sList = sExcludeBeamtype4Pack;		
	}	


	int nExcludeColors[0]; // collect exclusive colors
	sList = sExcludeColor;
	for (int i = 0; i < 3; i++)
	{
		while (sList.length()>0 || sList.find(";",0)>-1)
		{
			String sToken = sList.token(0);	
			sToken.trimLeft();
			sToken.trimRight();		
			sToken.makeUpper();
			int nToken = sToken.atoi();
			nExcludeColors.append(nToken);
			
			int x = sList.find(";",0);
			sList.delete(0,x+1);
			sList.trimLeft();	
			if (x==-1)
				sList = "";	
		}
	}

	String sArExcludeCode[0]; // collect exclusive codes
	sList = sExcludeCode;
	for (int i = 0; i < 3; i++)
	{
		while (sList.length()>0 || sList.find(";",0)>-1)
		{
			String sToken = sList.token(0);	
			sArExcludeCode.append(sToken.trimLeft().trimRight().makeUpper());		
			int x = sList.find(";",0);
			sList.delete(0,x+1);
			sList.trimLeft();	
			if (x==-1)
				sList = "";	
		}
	}
	String sArIncludeCode[0]; // collect exclusive codes
	sList = sIncludeCode;
	for (int i = 0; i < 3; i++)
	{
		while (sList.length()>0 || sList.find(";",0)>-1)
		{
			String sToken = sList.token(0);	
			sArIncludeCode.append(sToken.trimLeft().trimRight().makeUpper());		
			int x = sList.find(";",0);
			sList.delete(0,x+1);
			sList.trimLeft();	
			if (x==-1)
				sList = "";	
		}
	}


	String sTslNames[0]; // collect exclusive codes
	sList = sTSLName;
	for (int i = 0; i < 3; i++)
	{
		while (sList.length()>0 || sList.find(";",0)>-1)
		{
			String sToken = sList.token(0);	
			sTslNames.append(sToken.trimLeft().trimRight().makeUpper());		
			int x = sList.find(";",0);
			sList.delete(0,x+1);
			sList.trimLeft();	
			if (x==-1)
				sList = "";	
		}
	}

// do something for the last appended viewport only
	if (_Viewport.length()==0) return; // _Viewport array has some elements
	Viewport vp = _Viewport[_Viewport.length()-1]; // take last element of array
	_Viewport[0] = vp; // make sure the connection to the first one is lost

// check if the viewport has hsb data
	if (!vp.element().bIsValid()) return;

	CoordSys ms2ps = vp.coordSys();
	CoordSys ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps
	Element el = vp.element();	
	PLine plEnvelope = el.plEnvelope();
	setDependencyOnEntity(el);

	CoordSys cs;
	Point3d ptOrg;
	Vector3d vx,vy,vz;

	cs = el.coordSys();
	ptOrg = cs.ptOrg();
	vx=cs.vecX();
	vy=cs.vecY();
	vz=cs.vecZ();

vx.vis(_Pt0,1);

// modelspace vars
	Point3d pt0ms = _Pt0;
	pt0ms.transformBy(ps2ms);

// order vectors
	Vector3d vecX = _XW;
	vecX.transformBy(ps2ms);vecX.normalize();
	vecX.normalize();	
	Vector3d vecY= _YW;
	vecY.transformBy(ps2ms);	vecY.normalize();
	vecY.normalize();
	Vector3d vecZ = vecX.crossProduct(vecY);

	pt0ms.vis(3);
	
// some ints
	int nDimDirX = 1;
	if (sArDimDirX[1] == sDimDirX)
			nDimDirX = -1;
	int nDimDirY = 1;
	if (sArDimDirY[1] == sDimDirY)
			nDimDirY = -1;

	int nDimObj = sArDimObj.find(sDimObj);
	int nDimType = nArDimType[sArDimType.find(sDimType)];
			
	int nDispDelta = _kDimNone, nDispChain = _kDimNone , nDispExtremes = _kDimNone;
	
	if (sDisplayModeDelta == sArDisplayMode[0])	
		nDispDelta = _kDimPar;
	else if (sDisplayModeDelta == sArDisplayMode[1])	
		nDispDelta = _kDimPerp;
		
	if (sDisplayModeChain == sArDisplayMode[0])	
		nDispChain = _kDimPar;
	else if (sDisplayModeChain == sArDisplayMode[1])	
		nDispChain = _kDimPerp;	

	if (nDisplayModeExtremes==0 || nDisplayModeExtremes==3)	
		nDispExtremes = _kDimPar;
	else if (nDisplayModeExtremes==1 || nDisplayModeExtremes==4)
		nDispExtremes = _kDimPerp;	

		
// Display
	Display dp(nColor);
	double dScale = ps2ms.scale()*dScaleFactor;
	if (bAutoScale)
		dp.dimStyle(sDimStyle,dScale);	
 	else
		dp.dimStyle(sDimStyle);	
		
// collect objects
	Beam bm[0], bmDimX[0], bmDimY[0], bmDimS[0],bmThisZone[0];
	GenBeam gb[0], gbAll[0], gbThisZone[0], gbsRef[0];;
	Opening op[0];
	OpeningRoof opRoof[0];
	PlaneProfile ppElement(plEnvelope), ppFrame;
	EntityCollection ecBeamPacks[0];
	Element elRooms[0];
	
	gbAll = el.genBeam();
	Body bdGbAll[0];
	Body bodiesThis[0];
	Body bodiesRef[0];	

// remove any dummy and any excluded or invalid code 
	for (int i=gbAll.length()-1;i>=0;i--)
	{
		GenBeam gb = gbAll[i];
		int bIsDummy = gb.bIsDummy();
		String sCode = gb.name("beamcode").token(0);
	// do not consider any dummy	// code inclusion/exclusion
		if (bIsDummy  || (sArExcludeCode.length()>0 && sArExcludeCode.find(sCode)>-1) ||
							  (sArIncludeCode.length()>0 && sArIncludeCode.find(sCode)<0))
		{
			gbAll.removeAt(i);
			continue;	
		}
						
	}	
		
// append all beams of zone 0 to a standard array
	Body bdCombine;
	for (int i=0;i<gbAll.length();i++)
	{
		GenBeam& gb = gbAll[i];
		Vector3d vecXGb = gb.vecX();
		int nMyZone = gb.myZoneIndex();
		int bIsBeam = gb.bIsKindOf(Beam());
		Body bd;
		
	// use realBody for aligned genbeams to consider potential end tools liek tenons etc	
		if (vecXGb.isParallelTo(vx) || vecXGb.isPerpendicularTo(vy))
			bd= gb.envelopeBody(false,true);
		else
			bd= gb.realBody();		
			
		bdGbAll.append(bd); // collect bodies of all genbeams
		if (bIsBeam  && nMyZone  == 0)
		{
			bm.append((Beam)gbAll[i]);
			bdCombine.combine(bd);	
		}
		if (nMyZone == nZn)
		{
			
			bodiesThis.append(bd);
			gbThisZone.append(gb);	
			if (bIsBeam)	bmThisZone.append((Beam)gb);	
			
//			bd.transformBy(ms2ps);
//			bd.vis(40);
		}		
		if (nMyZone == nReferenceBy)
		{
			//bd.vis(40);
			bodiesRef.append(bd);
			gbsRef.append(gb);		
		}
	}
	ppFrame= bdCombine.shadowProfile(Plane(ptOrg,vz));
	ppFrame.vis(6);		


// Beams
	if ((nDimObj == 0 || nDimObj == 3) && nBeamtypes.length() < 1) 
	{
		Beam bmTmp[0];
		
	// loop twice for x and y
		Vector3d vecFilter = vecX;
		bmTmp=bmThisZone;	
		for(int xy=0;xy<2;xy++)
		{
			// collect beams for dim, if zone != collect all beams
			if (nZn == 0)
				bmTmp = vecFilter.filterBeamsPerpendicularSort(bmTmp);
			// exclude beams with color
			for (int i = 0; i < bmTmp.length(); i++)
			{
				int n = bmTmp[i].myZoneIndex();
				if (n!=nZn)continue;
				int c = bmTmp[i].color();
				int exclude = nExcludeColors.find(c);
				int exclusive = nIncludeColors.find(c);
				
				// exclude color/exclusive color
				if ((exclude <0 && n == nZn && sIncludeColor == "") || (n == nZn &&  exclusive >-1))
				{
					if (xy==0)
					{
						bmDimY.append(bmTmp[i]);
						//bmTmp[i].envelopeBody().vis(1);
					}
					else
					{
						bmDimX.append(bmTmp[i]);
						//bmTmp[i].envelopeBody().vis(3);
					}
				}				
			}
			bmTmp=bmThisZone;
			vecFilter=vecY;
		}// next xy
	}
// Genbeams: Sheets and Sips
	else if (nDimObj == 1)
	{ 
		String sInclude = sIncludeLabel.makeUpper();
		GenBeam gbAux[0];gbAux =gbThisZone;// el.genBeam(nZn);
		for (int i = 0; i < gbAux.length(); i++)
		{	
			GenBeam g = gbAux[i];
		// only sheets and sips
			if (!g.bIsKindOf(Sheet()) && !g.bIsKindOf(Sip()))
				{continue;}
		// only zone index
			if (g.myZoneIndex()!=nZn)
				{continue;}
		
		// skip other labels if selected		
			if (sInclude !="" && gbAux[i].label().makeUpper()!=sInclude)
				{continue;}
			// exclude color
			if (nExcludeColors.find(gbAux[i].color())<0 && gbAux[i].myZoneIndex() == nZn && sIncludeColor == "")
				gb.append(gbAux[i]);
			// exclusive color
			else if(gbAux[i].myZoneIndex() == nZn &&  nIncludeColors.find(gbAux[i].color())>-1)
				gb.append(gbAux[i]);		
		}	
			
		
	}
	// openings
	else if (nDimObj == 4){ 
		op.append(el.opening());
		
		// get all roof openings of the parent group
		if (el.bIsKindOf(ElementRoof()))
		{
			Group grEl = el.elementGroup();
			Group grFloor(grEl.namePart(0) +"\\" + grEl.namePart(1));
			Entity entOp[] = grFloor.collectEntities(true,OpeningRoof(),_kModelSpace);

			// filter those which intersect with the element: assuming that the average point is inside the element contour
			for(int i=0;i<entOp.length();i++)
			{
				OpeningRoof opr = (OpeningRoof)entOp[i];
				ppElement.subtractProfile(PlaneProfile(opr.plShape()));	
				Point3d pt[]=opr.plShape().vertexPoints(true);
				Point3d ptAverage;
				ptAverage.setToAverage(pt);
				if (PlaneProfile(plEnvelope).pointInProfile(ptAverage)!=_kPointOutsideProfile)
				{
					opRoof.append(opr);
					PLine pl = opr.plShape();
					pl.transformBy(ms2ps);
					Display dpOp(171);
					dpOp.draw(pl);	
				}
			}
			
		}
		//opRoof.append(el.)
	}

	// beam packs
	else if (nDimObj == 5){ 
		Beam bmTmp[0];
		bmTmp = vx.filterBeamsPerpendicularSort(bm);		
		
		Beam arBmToPack[0];
		String arStrDiffer[0];		
	
		for (int b=0; b<bmTmp.length(); b++) 
		{
			
			arBmToPack.append(bmTmp[b]);
			if (nExcludeBeamtype4Pack.find(bmTmp[b].type())>-1)
				arStrDiffer.append(el.number()+"_"+bmTmp[b].type());
			else
				arStrDiffer.append(el.number());
		}		
		ecBeamPacks = Beam().composeBeamPacks(arBmToPack,arStrDiffer);
	}	
	// rooms and load bearing points
	else if (nDimObj == 6 || nDimObj == 7){ 
		// collect stickframe elements below if it is a roof element
		if (el.bIsKindOf(ElementRoof()))
		{
		// the ref point from the zone
			Point3d ptRef = el.zone(nZn).ptOrg();
			ptRef.vis(2);
		
		// find all wall elements interfering
			Group grElements [] = Group().allElementGroups();
			Element elSF[0];
			for (int e=0;e<grElements .length();e++)
			{
			// ignore block groups
				if (grElements[e].name().find("_BLOCK_",0)>-1)
				{
					continue;
				}						

				Element elGr = grElements[e].elementLinked();
				if (!elGr.bIsKindOf(ElementWall())) continue;
				
				//test if the linked wall element intersects the contour of the floor element
				PlaneProfile ppFloor(plEnvelope);
				ppFloor.intersectWith(PlaneProfile(elGr.plOutlineWall()));
				
				if (ppFloor.area()>pow(dEps,2))
				{
					//elGr.plOutlineWall().vis(e);
					ppFloor.vis(4);
					
					LineSeg ls = PlaneProfile(elGr.plEnvelope()).extentInDir(elGr.vecX());
					Point3d pt[0];
					pt.append(ls.ptStart());
					pt.append(ls.ptEnd());
					pt = Line(ptOrg,elGr.vecY()).orderPoints(pt);
					double dDistBottom, dDistTop;
					dDistBottom = elGr.vecY().dotProduct(pt[0]-ptRef);
					dDistTop = elGr.vecY().dotProduct(pt[1]-ptRef);
					if (dDistBottom < 0 && dDistTop>-U(10)) //&& 
						//elGr.vecX().isParallelTo(vy))//+el.dBeamWidth()
						elSF.append(elGr);
				}
			}
			elRooms = elSF;		
		}
		else if (el.bIsKindOf(ElementWall()))
		{
			ElementWall elWall = (ElementWall) el;
			elRooms.append(elWall.getConnectedElements());		
		}
		
	}	
	// collect beam by beamtype
	if (nBeamtypes.length() > 0)
	{
		if (nBeamtypes.find(6) > -1)
			nBeamtypes.append(27);
		
		Beam bmTmp[0], bmTmp2[0];
		// cache all requested beamtypes
		for (int i = 0; i < bm.length(); i++)
		{
			if (nBeamtypes.find(bm[i].type())>-1)
				bmTmp2.append(bm[i]);	
		}
				
		bmTmp = vecX.filterBeamsPerpendicularSort(bmTmp2);
		for (int i = 0; i < bmTmp.length(); i++)
			// exclude color
			if (nExcludeColors.find(bmTmp[i].color())<0 && bmTmp[i].myZoneIndex() == nZn && sIncludeColor == "")
				bmDimY.append(bmTmp[i]);
			// exclusive color
			else if(bmTmp[i].myZoneIndex() == nZn &&  nIncludeColors.find(bmTmp[i].color())>-1)
				bmDimY.append(bmTmp[i]);			
		bmTmp = vecY.filterBeamsPerpendicularSort(bmTmp2);
		for (int i = 0; i < bmTmp.length(); i++)
			// exclude color
			if (nExcludeColors.find(bmTmp[i].color())<0 && bmTmp[i].myZoneIndex() == nZn && sIncludeColor == "")
				bmDimX.append(bmTmp[i]);
			// exclusive color
			else if(bmTmp[i].myZoneIndex() == nZn &&  nIncludeColors.find(bmTmp[i].color())>-1)
				bmDimX.append(bmTmp[i]);			
	}		


// get envelope dimensions
	LineSeg segElement = ppElement.extentInDir(vx);
	double dXElement = abs(vecX.dotProduct(segElement.ptStart()-segElement.ptEnd()));
	double dYElement = abs(vecY.dotProduct(segElement.ptStart()-segElement.ptEnd()));
	Point3d ptSegMid=segElement.ptMid();
	//segElement.vis(63);

// declare margin bodies
	Body bdMarginX, bdMarginY;
	double dXMargin = abs(dUpperMarginX - dLowerMarginX);
	if (dXMargin >0 && abs(dUpperMarginX - dLowerMarginX ))
	{
	// default reference from origin
		int nDir =-1;
	// if lower margin <0 take the reference from opposite side
		if (dLowerMarginX<0)nDir*=-1;	

	// to catch points outside of the element contour extent margin if it starts from 0
		int nXFlag = 1;
		if(dLowerMarginX==0)
		{
			dXMargin *=2;
			nXFlag =0;		
		}
				
		Point3d pt = ptSegMid+vecX*(nDir*.5*dXElement+dLowerMarginX);pt.vis(5);
		bdMarginX = Body(pt,vecX,vecY,vecZ, dXMargin,U(30000), U(2000),nXFlag ,0,0);
		bdMarginX.vis(1);
		
		if (_bOnDebug){Body bd = bdMarginX;bd.transformBy(ms2ps);bd.vis(1);}
	}	

	double dYMargin = abs(dUpperMarginY - dLowerMarginY);
	if (dYMargin>0 && abs(dUpperMarginY - dLowerMarginY)>0)
	{
	// default reference from origin
		int nDir =-1;
	// if lower margin <0 take the reference from opposite side
		if (dLowerMarginY<0)nDir*=-1;		
		
	// to catch points outside of the element contour extent margin if it starts from 0
		int nYFlag = 1;
		if(dLowerMarginY==0)
		{
			dYMargin *=2;
			nYFlag=0;		
		}	
		
		Point3d pt = ptSegMid+vecY*(nDir*.5*dYElement+dLowerMarginY);pt.vis(5);	
		bdMarginY = Body(pt,vecX,vecY,vecZ, U(30000),dYMargin , U(2000),0,nYFlag ,0);
		bdMarginY.vis(2);
		
		if (_bOnDebug){Body bd = bdMarginY ;bd.transformBy(ms2ps);bd.vis(2);}
	}	


// collect reference
	Point3d ptRefX[0], ptRefY[0];	
	
// collect element reference if 'rooms' are selected
	if (nDimObj == 6) 
	{
		Point3d pt[] = plEnvelope.vertexPoints(true);
		pt = Line(el.ptOrg(),el.vecY()).orderPoints(pt);
		if (pt.length()>0)
		{
			ptRefX.append(pt[0]);	
			ptRefX.append(pt[pt.length()-1]);		
		}
		pt = Line(el.ptOrg(),el.vecX()).orderPoints(pt);
		if (pt.length()>0)
		{
			ptRefY.append(pt[0]);	
			ptRefY.append(pt[pt.length()-1]);		
		}
	}
// element roof reference
	else if (el.bIsKindOf(ElementRoof()) && nReferenceBy==99)
	{
		ElementRoof elRoof = (ElementRoof )el;
		Body bdEl(plEnvelope,vz*elRoof.dReferenceHeight(),1);
		//bdEl.vis(5);
		
		Point3d pt1,pt2;
		pt1 = ptOrg;	
		double dX = bdEl.lengthInDirection(vx), dY=bdEl.lengthInDirection(vy), dZ=bdEl.lengthInDirection(vz);	
		pt2 = pt1+vx*dX+vy*dY-vz*dZ;	
		
		bdEl.transformBy(ms2ps);
		bdEl.vis(5);		

		ptRefX.append(pt1);
		ptRefX.append(pt2);		

		ptRefY.append(pt1);
		ptRefY.append(pt2);	


		pt1.transformBy(ms2ps);
		pt2.transformBy(ms2ps);

		pt1.vis(70);	
		pt2.vis(70);
	}
// element wall reference
	else if (el.bIsKindOf(ElementWall()) && nReferenceBy==99)
	{
	// get the grip points of the profile
		PlaneProfile profMod(el.plOutlineWall());
		LineSeg ls = profMod.extentInDir(vx);
		Point3d ptMid = ls.ptMid();
		
	// get the offsets
		int n = 1;
		for (int j=0;j<2;j++)
		{
			double dMove;
			for (int i=1;i<6;i++)
				dMove = dMove+el.zone(i*n).dH();	
				
			if (j==0)
				dMove = el.dPosZOutlineFront()-dMove;
			else
				dMove =el.dPosZOutlineBack()+el.dBeamWidth()+dMove;
		
		
		// modify the contour
			Point3d pnts[0];
			pnts = profMod.getGripEdgeMidPoints(); // get all the mid edge grip points	
			
		// determine which point is closest to the ref
			Point3d ptRef = ptMid+n*vz*.5*abs(vz.dotProduct(ls.ptStart()-ls.ptEnd()));
			ptRef.vis(3);		
		
			int nInd = -1;
			double dDistMin = 0;
			for (int p=0; p<pnts.length(); p++)
			{
				Point3d pt = pnts[p];
				//pt.vis();
				double dDist = Vector3d(ptRef-pt).length();
				if (p==0 || dDist<dDistMin) 
				{
					dDistMin = dDist;
					nInd = p;
				}
			}
			
			// move a grip point with a vector towards _PtG[0]
			if (nInd>=0 && abs(dMove)>dEps)
				profMod.moveGripEdgeMidPointAt(nInd, ptRef-pnts[nInd]-vz*dMove);
			
			n*=-1;
		}// next j	
		//profMod.transformBy(ms2ps);
		profMod.vis(2);
		
	// collect the vertices
		PLine pl[]=profMod.allRings();
		Point3d pt[0];
		for (int i=0;i<pl.length();i++)
			pt.append(pl[i].vertexPoints(true)); 

	// orderX
		pt = Line(_Pt0,vecX).orderPoints(pt);
		if (pt.length()>0)
		{
			ptRefX.append(pt[0]);
			ptRefX.append(pt[pt.length()-1]);	
		}	
	// orderY
		pt = Line(_Pt0,vecY).orderPoints(pt);
		if (pt.length()>0)
		{
			ptRefY.append(pt[0]);
			ptRefY.append(pt[pt.length()-1]);	
		}		


	}	
// zone reference
	else
	{	
		String sInclude = sIncludeLabel.makeUpper();
		for (int i = 0; i < gbsRef.length(); i++)
		{	
			GenBeam gb = gbsRef[i];
			String sLabel = gb.label().makeUpper();
		// skip other labels if selected	
			if (sInclude !="" && sLabel!=sInclude)continue;

		// if no exclude color is defined or the exclude color does not match the genbeam color and the zone index matches the referenz zone add it			
			if ((nExcludeColors.length()<1 || nExcludeColors.find(gb.color())<0))
			{
				//bodiesRef[i].vis(i);
				ptRefX.append(bodiesRef[i].extremeVertices(vecX));
				ptRefY.append(bodiesRef[i].extremeVertices(vecY));			
			}
		}
	}

	ptRefX = Line(pt0ms,nDimDirX * vecX).orderPoints(ptRefX);	
	if (ptRefX.length()>2){ptRefX.swap(1,ptRefX.length()-1); ptRefX.setLength(2);}
	ptRefY = Line(pt0ms,nDimDirY * vecY).orderPoints(ptRefY);
	if (ptRefY.length()>2){ptRefY.swap(1,ptRefY.length()-1); ptRefY.setLength(2);}	

//vis refpoints in debug
	if (_bOnDebug){
		Point3d ptRefDebug[0];
		ptRefDebug = ptRefX;
		for (int i = 0; i < ptRefDebug.length(); i++){
			ptRefDebug[i].transformBy(ms2ps);
			ptRefDebug[i].vis(3);
		}
		//ptRefDebug[0].vis(5);
		//ptRefDebug[ptRefDebug.length()-1].vis(5);
	}
		
		
// declare dimline
	Point3d ptDimX[0], ptDimY[0];	
	DimLine dlX(_Pt0, _XW, _YW);
	DimLine dlY(_Pt0, _YW, -_XW);
		
//store in global arrays
	Point3d ptBmX[0], ptBmY[0], ptGbX[0], ptGbY[0],ptElX[0], ptElY[0],ptOpX[0], ptOpY[0], ptLogX[0], ptLogY[0], ptRoomsX[0], ptRoomsY[0];
	if (nDimObj==0)
	{
		if (nDimType == _kCenter)
		{ // center
			dlX.transformBy(ps2ms);
			dlY.transformBy(ps2ms);
			// collectDimPoints will only collect the relevant points
			// use all beams HSB-5981
			Beam bmDimAll[0];
			bmDimAll.append(bmDimX);
			bmDimAll.append(bmDimY);
			
			ptBmX.append(dlX.collectDimPoints(bmDimAll, nDimType));
			ptBmY.append(dlY.collectDimPoints(bmDimAll, nDimType));
			dlX.transformBy(ms2ps);
			dlY.transformBy(ms2ps);
			
			for (int i = 0; i < bm.length(); i++)
			{
				if (nExcludeColors.find(bm[i].color())<0 && nDimObj == 3)
				{		
					// notch dim
					Entity ents[0];
					ents = bm[i].eToolsConnected();
					for (int j = 0; j< ents.length(); j++)
					{
						//find all the entitys that have a tool asigned
						String st = ents[j].typeDxfName();
						if (sNotchTypes.find(ents[j].typeDxfName())>-1)
						{
							//Find the Midle point of the cut
							if (ents[j].bIsKindOf(ToolEnt()))
							{
								ToolEnt tEnt = (ToolEnt) ents[j];
								//Find the Midle point of the cut
								Point3d ptGrip = tEnt.ptOrg();
								if (ptGrip.length()>0)
									ptBmX.append(ptGrip);
							}
						}
					}
				}
			}		
		}
		else if (nDimType !=4 && nDimType !=0){//left, right, both
			// reasign for log element dim
			if (nDimObj == 3)
				bmDimX = bm;
				
			int bHasXMargin = bdMarginX.volume()>pow(dEps,3);
			int bHasYMargin = bdMarginY.volume()>pow(dEps,3);
			
			Beam bmDim[0];
			bmDim = bmDimX;
			
			bdMarginX.vis(6);	
			for (int i = 0; i < bmDim.length(); i++)
			{
			// beam dim
				Body bdDim;
				int n= gbAll.find(bmDim[i]);
				bdDim = bdGbAll[n];
				
				int bAddDim = TRUE;
			// calculate intersecting body of beam and margin
				if (dUpperMarginX != 0 || dLowerMarginX != 0)
					bAddDim = bdDim.hasIntersection(bdMarginX);		
				if (bAddDim )
				{
					bdDim.vis(1);
					vecX.vis(bdDim.ptCen(),1);
					if (_bOnDebug){Body bd = bdDim;bd.transformBy(ms2ps);bd.vis(94);}
					Point3d ptDim[0];
					ptDim = bdDim.extremeVertices(vecY);//
					if (nDimType == _kLeft && ptDim.length() > 0)
						ptBmY.append(ptDim[0]);
					else if (nDimType == _kRight && ptDim.length() > 1)
						ptBmY.append(ptDim[1]);
					else
						ptBmY.append(ptDim);		
				}	
				else
					bdDim.vis(94);
				//bdDim.vis(1);
			}
		// debug
			for (int x=0;x<ptBmY.length();x++)
			{
				Point3d pt = ptBmY[x];pt.vis(40);	pt.transformBy(ps2ms);pt.vis(30);
			}	
				
			bmDim = bmDimY;
			for (int i = 0; i < bmDim.length(); i++)
			{
				Body bdDim;
				int n= gbAll.find(bmDim[i]);
				bdDim = bdGbAll[n];
				int bAddDim = true;
			// calculate intersecting body of beam and margin
				if (dUpperMarginY != 0 || dLowerMarginY!= 0)  
					bAddDim = bdDim.hasIntersection(bdMarginY);
				if (bAddDim)
				{
					bdDim.vis(3);
					Point3d ptDim[0];
					ptDim = bdDim.extremeVertices(vecX);
					vecY.vis(bdDim.ptCen(),i);
					if (nDimType == _kLeft && ptDim.length() > 0)
						ptBmX.append(ptDim[0]);
					else if (nDimType == _kRight && ptDim.length() > 1)
						ptBmX.append(ptDim[1]);
					else
						ptBmX.append(ptDim);
				}
				else
					bdDim.vis(8);
				//bdDim.vis(2);
			}	
			
			for (int x=0;x<ptBmX.length();x++)
			{	
				Point3d pt = ptBmX[x];	
				//pt.transformBy(ps2ms);
				pt.vis(30);
			}
	
		// fall back to hull if no y dimpoints were collected (i.e. for rhomb shaped elements)
			if (ptBmY.length()<1 && ptRefY.length()>0)
			{
				PLine plHull(vz);
				plHull.createConvexHull(Plane(ptOrg,vz),ptRefY);
				
				PlaneProfile pp(plHull);
				pp.shrink(-U(10));
				pp.shrink(U(20));
				pp.shrink(-U(10));
				PLine plRings[] =pp.allRings();
				if(plRings.length()>0)
					ptBmY.append(plRings[0].vertexPoints(true));	
				pp.transformBy(ms2ps);	
				pp.vis(4);	
				
			}
			
		}
		else//All
		{
			if (nDimObj == 3)// logelement
			{			
				for (int i = 0; i < bm.length(); i++)
				{
					if (nExcludeColors.find(bm[i].color())<0)
					{
						// beam dimensions
						Body bdDim;
						int n= gbAll.find(bm[i]);
						bdDim = bdGbAll[n];	
						int nDim = TRUE;
						// calculate intersecting body of beam and margin
						if (dUpperMarginY != 0 || dLowerMarginY != 0)
							nDim = bdDim.intersectWith(bdMarginX);		
						if (nDim){
							Point3d ptDim[0];
							ptDim = bdDim.extremeVertices(vx);
							if (nDimType == _kLeft && ptDim.length() > 0)
								ptBmX.append(ptDim[0]);
							else if (nDimType == _kRight && ptDim.length() > 1)
								ptBmX.append(ptDim[1]);
							else
								ptBmX.append(ptDim);
						}
					}
				}
			}	
			else
			{ 
			// collect extremes in given direction
				for (int i = 0; i < bm.length(); i++)
				{
					Body bdDim;
					int n = gbAll.find(bm[i]);
					bdDim = bdGbAll[n];
					ptBmX.append(bdDim.extremeVertices(vx));
					ptBmY.append(bdDim.extremeVertices(vy));
					
				}//next i				
			}
		}
	}// END IF (nDimObj==0)


//collect genbeams: sheets and sips
	else if(nDimObj == 1)// version 1.74
	{
		if (nDimType == _kCenter){ // center
			dlX.transformBy(ps2ms);
			dlY.transformBy(ps2ms);
			ptGbX.append(dlX.collectDimPoints(gb, nDimType));	
			ptGbY.append(dlY.collectDimPoints(gb, nDimType));
			dlX.transformBy(ms2ps);
			dlY.transformBy(ms2ps);
		}
		else if (nDimType != 4){//left, right, both
		
			Vector3d vDir = _XW;
			vDir.transformBy(ps2ms);	
			for (int i = 0; i < gb.length(); i++)
			{
				if (nDimDir==1)break;
				
				Body bdDim;
				int n= gbAll.find(gb[i]);
				bdDim = bdGbAll[n];		
				bdDim.vis(1);
				int nDim = TRUE;
				// calculate intersecting body of beam and margin
				if (dUpperMarginY != 0 || dLowerMarginY != 0)
					nDim = bdDim.intersectWith(bdMarginX);		
				if (nDim){
					Point3d ptDim[0];
					ptDim = bdDim.extremeVertices(vDir);
					if (nDimType == _kLeft && ptDim.length() > 0)
						ptGbX.append(ptDim[0]);
					else if (nDimType == _kRight && ptDim.length() > 1)
						ptGbX.append(ptDim[1]);
					else
						ptGbX.append(ptDim);
					for (int p= 0; p< ptDim.length(); p++)
						ptDim[p].vis(5);	
				}					
			}
			
			vDir = _YW;
			vDir.transformBy(ps2ms);
			for (int i = 0; i < gb.length(); i++)
			{
				if (nDimDir==0)break;
				Body bdDim;
				int n= gbAll.find(gb[i]);
				bdDim = bdGbAll[n];	
				
				int nDim = TRUE;
				// calculate intersecting body of beam and margin
				if (dUpperMarginX != 0 || dLowerMarginX != 0)
					nDim = bdDim.intersectWith(bdMarginY);		
				if (nDim){
					Point3d ptDim[0];
					ptDim = bdDim.extremeVertices(vDir);
					if (nDimType == _kLeft && ptDim.length() > 0)
						ptGbY.append(ptDim[0]);
					else if (nDimType == _kRight && ptDim.length() > 1)
						ptGbY.append(ptDim[1]);
					else
						ptGbY.append(ptDim);
					for (int p= 0; p< ptDim.length(); p++)
						ptDim[p].vis(4);		
				}

				//bdDim.vis(1);
			}			
		}
		else//All	// version 1.79
		{
			Vector3d vecX =_XW;
			Vector3d vecY =_YW;
			vecX .transformBy(ps2ms);
			vecY .transformBy(ps2ms);
			for (int i = 0; i < gb.length(); i++)
			{
				PLine plines[0];	
				// get contours from type
				if (gb[i].bIsKindOf(Sheet()))
				{
					Sheet g = (Sheet)gb[i];
					plines.append(g.plOpenings());
					plines.append(g.plEnvelope());
				}
				else if (gb[i].bIsKindOf(Sip()))
				{
					Sip g = (Sip)gb[i];
					plines.append(g.plOpenings());
					plines.append(g.plEnvelope());
				}
					
			// collect all points
				Point3d pts[0];
				for (int r = 0; r < plines.length(); r++)
					pts.append(plines[r].vertexPoints(TRUE));	

			// order and project
				ptGbX.append(Line(_Pt0, vecX).orderPoints(pts));
				ptGbY.append(Line(_Pt0, vecY).orderPoints(pts));
			}				
		}	
	}// END if(nDimObj == 1)  // version 1.74


	// collect element data
	if (sShowConnectingElements == sArNY[1] && nDimType != _kCenter)
	{
		Group gr = el.elementGroup();	
		Group grPar = gr.namePart(0) + "\\" + gr.namePart(1);
		Entity ents[0];
		PLine plOl = el.plOutlineWall();
		plOl.vis(3);
		ents = grPar.collectEntities(FALSE,ElementLog(), _kModelSpace);
		// cast to el
		for (int i = 0; i < ents.length(); i++)
		{
			Element elTmp = (Element)ents[i];
			if (el != elTmp)
			{
				PLine plOlTmp = elTmp.plOutlineWall();
				CoordSys cs;
				cs.setToAlignCoordSys(elTmp.ptOrg(), elTmp.vecX(),elTmp.vecY(),elTmp.vecZ(),elTmp.ptOrg(), elTmp.vecX() * (1+U(1)),elTmp.vecY(),elTmp.vecZ());
				plOlTmp.transformBy(cs);
				plOlTmp.transformBy(-elTmp.vecX() * U(1));
				//plOlTmp.vis(i);
				PlaneProfile pp(plOlTmp);
				PLine plPPOlTmp[]= pp.allRings();
				if (plPPOlTmp.length() > 0)
				{ 
					//plPPOlTmp[0].vis(i);
					PlaneProfile ppEl(plOl);
					ppEl.intersectWith(pp);
					//ppEl.vis(i);
					LineSeg ls = ppEl.extentInDir(vx);
					ptElX.append(ls.ptStart());
					ptElX.append(ls.ptEnd());					
				}
			}	
		}
	}
	
	
// collect opening data
	for (int i = 0; i < op.length(); i++)
	{
		Point3d ptOp[] = op[i].plShape().vertexPoints(TRUE);
		
		if (ptOp.length() > 1)
		{
			
			ptOp = Line(ptOrg,nDimDirX * vecX).orderPoints(ptOp);	
			if (nDimType == 0)// center
				ptOpX.append((ptOp[0]+ptOp[ptOp.length()-1])/2);	
			else// l+r
			{
				ptOpX.append(ptOp[0]);
				ptOpX.append(ptOp[ptOp.length()-1]);
			}
			
			ptOp = Line(ptOrg,nDimDirY * vecY).orderPoints(ptOp);	
			if (nDimType == 0)// center
				ptOpY.append((ptOp[0]+ptOp[ptOp.length()-1])/2);	
			else// l+r
			{
				ptOpY.append(ptOp[0]);
				ptOpY.append(ptOp[ptOp.length()-1]);
			}			
		}	
		
	} 	

// collect opening roof data
	for (int i = 0; i < opRoof.length(); i++)
	{
		Point3d ptOp[0] ;					
		PLine plRings[] = ppElement.allRings();
		int bIsOp[] = ppElement.ringIsOpening();
		for (int i = 0; i <plRings.length(); i++)
			if (bIsOp[i])
				ptOp.append(plRings[i].vertexPoints(TRUE));
		
		// the alignment in layout could vary. pts need to be ordered by a vetror which is transformed to MS
		for (int i = 0; i <plRings.length(); i++)
		if (ptOp.length() > 1)
		{
			// order points in view X direction
			ptOp = Line(ptOrg,nDimDirX * vecX).orderPoints(ptOp);	
			if (nDimType == 0)// center
				ptOpX.append((ptOp[0]+ptOp[ptOp.length()-1])/2);	
			else// l+r
			{
				ptOpX.append(ptOp[0]);
				ptOpX.append(ptOp[ptOp.length()-1]);
			}
			
			// order points in view Y direction
			ptOp = Line(ptOrg,nDimDirY * vecY).orderPoints(ptOp);	
			if (nDimType == 0)// center
				ptOpY.append((ptOp[0]+ptOp[ptOp.length()-1])/2);	
			else// l+r
			{
				ptOpY.append(ptOp[0]);
				ptOpY.append(ptOp[ptOp.length()-1]);
			}		
		}	
		
	} 	

// flag dim to be drawn
	int bDrawDim = FALSE;
		
// collect beam pack data
	for (int i = 0; i <ecBeamPacks.length(); i++)
	{
		// beam packs will only be collected for vertical beams
		EntityCollection ecBeamPack = ecBeamPacks[i];
		Beam bmTmp[] = ecBeamPack.beam();
		
		int nBmType = bmTmp[0].type();
		
		DimLine dlPack(ptOrg, vx,vy);
		Point3d ptPack[0];
		
		// take only packs which are not in the exclusion list
		int bValid = true;
		for (int b = 0; b <bmTmp.length(); b++)
			if (nExcludeBeamtype4Pack.find(bmTmp[b].type())>-1)
				bValid = false;
		if (bValid)
			ptPack = dlPack.collectDimPoints(bmTmp,_kLeftAndRight);
		ptPack = Line(ptOrg,vecX).orderPoints(ptPack);
		
		if (nDimType == _kCenter && ptPack.length()>0)
			ptBmX.append((ptPack[0]+ptPack[ptPack.length()-1])/2);
		else if (nDimType == _kLeft && ptPack.length()>0)
			ptBmX.append(ptPack[0]);		
		else if (nDimType == _kRight && ptPack.length()>0)
			ptBmX.append(ptPack[ptPack.length()-1]);
		// kLeftAndRight and all	
		else if (ptPack.length()>0)
		{
			ptBmX.append(ptPack[0]);
			ptBmX.append(ptPack[ptPack.length()-1]);
			ptBmX.append((ptPack[0]+ptPack[ptPack.length()-1])/2);
		}
		if (ptBmX.length() > 0)
			bDrawDim  = TRUE;
			
	}		
	
// collect room elements ( mode 6 and 7)
	for (int i=0;i<elRooms.length();i++)
	{
		Vector3d  vxRoom = elRooms[i].vecX();
		//vxRoom.transformBy(ms2ps);
		vxRoom.normalize();
		if (vxRoom.isPerpendicularTo(el.vecY()) && (nDimDir == 0 || nDimDir==2))//vx
		{
			vxRoom.vis(elRooms[i].ptOrg(),1);
			el.vecY().vis(elRooms[i].ptOrg(),1);
			Point3d pt[0];
			pt.append(elRooms[i].ptOrg() + elRooms[i].vecZ() * elRooms[i].dPosZOutlineFront());
			pt.append(elRooms[i].ptOrg() + elRooms[i].vecZ() * elRooms[i].dPosZOutlineBack());
			//Vector3d vxMs = vx;
			//vxMs.transformBy(ps2ms);
			pt = Line(el.ptOrg(),el.vecY()).orderPoints(pt);
			//pt[0].vis(6);
			//pt[1].vis(6);
			
			if (nDimType == _kCenter)
				ptRoomsX.append((pt[0]+pt[1])/2);						
			else if (nDimType == _kLeft)
				ptRoomsX.append(pt[0]);	
			else if (nDimType == _kRight)
				ptRoomsX.append(pt[1]);	
			else
			{
				ptRoomsX.append(pt[0]);	
				ptRoomsX.append(pt[1]);					
			}												
		}		
		else if (vxRoom.isPerpendicularTo(el.vecX()) && nDimDir>0)//vy
		{
			Point3d pt[0];
			pt.append(elRooms[i].ptOrg() + elRooms[i].vecZ() * elRooms[i].dPosZOutlineFront());
			pt.append(elRooms[i].ptOrg() + elRooms[i].vecZ() * elRooms[i].dPosZOutlineBack());
			//Vector3d vxMs = vx;
			//vxMs.transformBy(ps2ms);
			pt = Line(el.ptOrg(),el.vecX()).orderPoints(pt);
			
			if (nDimType == _kCenter)
				ptRoomsY.append((pt[0]+pt[1])/2);						
			else if (nDimType == _kLeft)
				ptRoomsY.append(pt[0]);	
			else if (nDimType == _kRight)
				ptRoomsY.append(pt[1]);	
			else
			{
				ptRoomsY.append(pt[0]);	
				ptRoomsY.append(pt[1]);	
				//pt[0].vis(6);				
			}												
		}	
	}
	
// collect load bearing beams
	if (nDimObj==7 && el.zone(nZn).dH()>0)
	{
		// temporarly create a beam in modelspace which has the shape of the zone to find intersecting beams
		Beam bmTest;
		Body bd(el.plEnvelope(el.zone(nZn).ptOrg()), el.zone(nZn).vecZ()*el.zone(nZn).dH(),1);
		bmTest.dbCreate(bd,vx,vy,vz);
		
		bd.vis(1);
		Vector3d vzView = _ZW;
		vzView.transformBy(ps2ms);
		Group grAll[] = Group().allExistingGroups()	;
		Beam bmGroup[0],bmX[0],bmY[0];
		Point3d ptZn1 = el.zone(nZn).ptOrg();
		Point3d ptZn2 = el.zone(nZn).ptOrg()+el.zone(nZn).vecZ()*el.zone(nZn).dH();
		
		for (int g=0;g<grAll.length();g++)
		{
			// get all entities
			Entity entGr[0];
			entGr=grAll[g].collectEntities(true,Beam(),_kModelSpace);	
			for (int e=0;e<entGr.length();e++)
			{
				Beam bm = (Beam)entGr[e];
				Element elBm = bm.element();
				if (bmGroup.find(bm)<0 && !elBm.bIsValid())
					bmGroup.append(bm);
			}
		}

		// filter and sort horizontals
		bmGroup= vzView.filterBeamsPerpendicularSort(bmGroup);
		bmGroup = bmTest.filterBeamsCapsuleIntersect(bmGroup);
		if (bmTest.bIsValid())
			bmTest.dbErase();
			
		// filter X/Y
		bmX= vx.filterBeamsPerpendicular(bmGroup);
		bmY= vy.filterBeamsPerpendicular(bmGroup);
		//for (int e=0;e<bmX.length();e++)	bmX[e].realBody().vis(1);
		//for (int e=0;e<bmY.length();e++)	bmY[e].realBody().vis(3);	
		
		for (int e=0;e<bmX.length();e++)
		{
			ptDimY.append(bmX[e].quader().pointAt(-1,-1,-1));
			ptDimY.append(bmX[e].quader().pointAt(1,1,1));		
		}
		for (int e=0;e<bmY.length();e++)
		{
			ptDimX.append(bmY[e].quader().pointAt(-1,-1,-1));
			ptDimX.append(bmY[e].quader().pointAt(1,1,1));		
		}
		for (int e=0;e<ptDimY.length();e++)	ptDimY[e].vis(5);
		/*
		Point3d ptModel = _Pt0;
		ptModel.transformBy(ps2ms);
	DimLine dlX(ptModel , vy, vx); 
	ptDimX.append()
	ptDimX.append(dlX.collectDimPoints(bmX,nDimType));
	DimLine dlY(ptModel , vx, vy); 
	ptDimY.append(dlY.collectDimPoints(bmY,nDimType));
		for (int e=0;e<ptDimX.length();e++)	ptDimX[e].vis(5);	*/
	}
		
	

//vis Gbx points in debug
	if (_bOnDebug){
		Point3d ptRefDebug[0];
		ptRefDebug = ptGbX;
		for (int i = 0; i < ptRefDebug.length(); i++){
			ptRefDebug[i].transformBy(ms2ps);
			//ptRefDebug[i].vis(6);
		}
	}
		
// get the size of the viewport
	PLine plVP;
	Vector3d vecVP = _XW*.5*vp.widthPS()+_YW*.5*vp.heightPS();
	plVP.createRectangle(LineSeg(vp.ptCenPS()-vecVP,vp.ptCenPS()+vecVP),_XW,_YW);
	PlaneProfile ppVp(plVP);
					
//tslFilter	
	if (nDimObj == 2 || nDimObj == 5 || sTSLName!="")
	{
		if (_bOnDebug && nDebugTsl)reportNotice("\nStart TSL Dim Collection...");
		
		
		// create a pp to collect valid points
		PlaneProfile ppValid = ppVp;	
		Body bdMargin = bdMarginX;
		bdMargin.addPart(bdMarginY);
		//bdMargin.transformBy(ps2ms);
		if (bdMargin.volume()>pow(dEps,3))
		{
			if (_bOnDebug && nDebugTsl)reportNotice("\n   with margin");
			bdMargin.transformBy(ms2ps);
			PlaneProfile pp = bdMargin.shadowProfile(Plane(_PtW,_ZW));
			ppValid.intersectWith(pp);
			
		}
		ppValid.transformBy(ps2ms);//version  value="1.69"
		ppValid.vis(6);
		
		
		TslInst tslList[] = el.tslInst();
		if (tslList.length()> 0)
			for (int i = 0; i < tslList.length(); i++) 
			{
			// validate include/exclude colors
				// include colors defined, but this color does not match one
				if (nIncludeColors.length()>0 && nIncludeColors.find(tslList[i].color())<0) continue;
				// excluzde colors defined, and this color matches
				if (nExcludeColors.length()>0 && nExcludeColors.find(tslList[i].color())>-1) continue;
				
				
				if (sTslNames.find(tslList[i].scriptName().makeUpper())>-1) 
				{
				// skip if exclude color applies
					int nThisColor=tslList[i].color();
					String s = tslList[i].scriptName();
					if (_bOnDebug && nDebugTsl)reportNotice("\n" + s);
					if (nExcludeColors.find(tslList[i].color())>-1)
						continue;
					
					
					Map map = tslList[i].map();
					if (_bOnDebug && nDebugTsl)reportNotice("\n   " + tslList[i].scriptName() + " at " + tslList[i].ptOrg());
					int bSkipX, bSkipY;
					Vector3d vxTool;
					if (map.hasVector3d("vx"))
					{
						if (_bOnDebug && nDebugTsl)reportNotice("\n      has Tool Vector");
						vxTool = map.getVector3d("vx");

						if(!vxTool.isParallelTo(vecX))
						{
							//vecX.vis(tslList[i].ptOrg(),31);					
							vxTool.vis(tslList[i].ptOrg(),1);											
							bSkipX=true;
						}
						if(!vxTool.isParallelTo(vecY))	
						{
							vxTool.vis(tslList[i].ptOrg(),3);							
							bSkipY=true;
						}
						
					}
					if (_bOnDebug && nDebugTsl)reportNotice("\n      bSkipX" +bSkipX + " bSkipY" +bSkipY );
					
					bDrawDim  = TRUE;
					setDependencyOnEntity(tslList[i]);
					Point3d pt;
					String sArKey[] = {"pLayoutDimU","pLayoutDimO","pLayoutDimM","pLayoutDimL","pLayoutDimR"};
					
					
				// collect any point from map which is inside the element contour	
					for (int m = 0; m < map.length(); m++)
					{
						String key = map.keyAt(m);
						if (_bOnDebug && nDebugTsl)reportNotice("\n      key in map found" + key);
						int n = sArKey.find(key);
						if (n>-1)
						{
							if (_bOnDebug && nDebugTsl)reportNotice("\n      Point found with key " + key);
							pt = map.getPoint3d(key);
							if (ppValid.pointInProfile(pt)!=_kPointOutsideProfile && n<=2)
								ptDimY.append(pt);
							if (ppValid.pointInProfile(pt)!=_kPointOutsideProfile && n>=2)
								ptDimX.append(pt);								
						}					
					}
					
					if (tslList[i].map().hasPoint3d("pLayoutDimU"))
					{
						if (_bOnDebug && nDebugTsl)reportNotice("\n      Point found with key pLayoutDimU");
						ptDimY.append(tslList[i].map().getPoint3d("pLayoutDimU"));
					}
					if (tslList[i].map().hasPoint3d("pLayoutDimO"))
					{
						if (_bOnDebug && nDebugTsl)reportNotice("\n      Point found with key pLayoutDimO");
						ptDimY.append(tslList[i].map().getPoint3d("pLayoutDimO"));		
					}			
					if (tslList[i].map().hasPoint3d("pLayoutDimM"))
					{
						if (_bOnDebug && nDebugTsl)reportNotice("\n      Point found with key pLayoutDimM");
						ptDimX.append(tslList[i].map().getPoint3d("pLayoutDimM"));
						ptDimY.append(tslList[i].map().getPoint3d("pLayoutDimM"));
					}
					if (tslList[i].map().hasPoint3d("pLayoutDimL"))
					{
						if (_bOnDebug && nDebugTsl)reportNotice("\n      Point found with key pLayoutDimL");
						ptDimX.append(tslList[i].map().getPoint3d("pLayoutDimL"));
					}
					if (tslList[i].map().hasPoint3d("pLayoutDimR"))
					{
						if (_bOnDebug && nDebugTsl)reportNotice("\n      Point found with key pLayoutDimR");					
						ptDimX.append(tslList[i].map().getPoint3d("pLayoutDimR"));
					}
						
					int bHasPoint;
					for (int j = 0; j <tslList[i].map().length(); j++)
					{

						// collect extra dim points	
						if (map.hasPoint3d("ptExtraDim" + j)){
							if (_bOnDebug && nDebugTsl)reportNotice("\n      Point found with key ptExtraDim" + j);	
							pt = map.getPoint3d("ptExtraDim" + j);
							Point3d ptTestOutside = pt;
							// set flag if this tsl has special dimpoints
							//if (tslList[i].map().hasPoint3d(j))
							bHasPoint=TRUE;	
							//ptTestOutside .transformBy(ms2ps);		
							if(ppValid.pointInProfile(ptTestOutside)!=_kPointOutsideProfile)
							{
								//pt.vis(6);
								// validate if tsl has published vectors vx, vy and vz and test for parallelism to vOrder
								if (!bSkipX)
								{		
									if (_bOnDebug && nDebugTsl)reportNotice("\n         appending to X");			
									ptDimX.append(pt);
									pt.vis(4);
								}
								if (!bSkipY)
								{
									if (_bOnDebug && nDebugTsl)reportNotice("\n         appending to Y");	
									ptDimY.append(pt);	
									pt.vis(3);							
								}
									
							}
							else
								pt.vis(1);	
							//ptDimX.append(map.getPoint3d("ptExtraDim" + j));	 
							//ptDimY.append(map.getPoint3d("ptExtraDim" + j));	
						}
					}
					if (!bHasPoint && ppValid.pointInProfile(tslList[i].ptOrg())!=_kPointOutsideProfile)
					{
						// validate if tsl has published vectors vx, vy and vz and test for parallelism to vOrder
						if (!bSkipX)
							ptDimX.append(tslList[i].ptOrg());
						if (!bSkipY)
							ptDimY.append(tslList[i].ptOrg());	
					}					
				}					
		}
		if (nBeamtypes.length()>0 || sTSLName!="")
			bDrawDim  = TRUE;	
	}
	else
		bDrawDim  = TRUE;

// append refpoints
	if (ptRefX.length() > 0 && (ptBmX.length() > 0 || ptGbX.length() > 0 || ptDimX.length() > 0 || op.length() > 0  || opRoof.length() > 0 || ptRoomsX.length()>0)){
		ptDimX.append(ptRefX[0]);
		ptDimX.append(ptRefX[ptRefX.length()-1]);
		//for (int i = 0; i < ptRefX.length(); i++){
		//	ptRefX[i].transformBy(ms2ps);
		//	ptRefX[i].vis(0);	
		//}
		
	}
	if (ptRefY.length() > 0 && (ptBmY.length() > 0  || ptGbY.length() > 0 || ptDimY.length() > 0 || op.length() > 0 || opRoof.length() > 0 || ptRoomsY.length()>0)){
		ptDimY.append(ptRefY[0]);
		ptDimY.append(ptRefY[ptRefY.length()-1]);
	
	}
	
// store dim points
	if(nDimObj==0)
	{
		ptDimX.append(ptBmX);
		ptDimY.append(ptBmY);
	}
	else if(nDimObj==1)
	{
		ptDimX.append(ptGbX);
		ptDimY.append(ptGbY);
	}
	ptDimX.append(ptLogX);
	ptDimX.append(ptOpX);	
	ptDimX.append(ptElX);
	ptDimX.append(ptRoomsX);
	
	ptDimY.append(ptLogY);
	ptDimY.append(ptOpY);
	ptDimY.append(ptRoomsY);


// add context trigger to enable/disable points outside of the viewport
	int bAddPointsOutside = _Map.getInt("AddPointsOutside");
	String sTriggerAddPointsOutside= T("|Add points outside viewport|");
	if (bAddPointsOutside) sTriggerAddPointsOutside= T("|Ignore points outside viewport|");
	addRecalcTrigger(_kContext, sTriggerAddPointsOutside);
	if (_bOnRecalc && _kExecuteKey==sTriggerAddPointsOutside) 
	{
		String sTxt;
		if (bAddPointsOutside ==true)
		{
			sTxt="\n*** " + T("|Dimension permanently changed not to show dimpoints outside of viewport.|") + " ***";
			bAddPointsOutside = false;
		}
		else
		{
			sTxt="\n*** " + T("|Dimension permanently changed to show dimpoints outside of viewport.|") + " ***";
			bAddPointsOutside =true;
		}
		_Map.setInt("AddPointsOutside",bAddPointsOutside);
		
		
		reportMessage("\n" + sTxt);
		setExecutionLoops(2);
		
	}	

// validate points if in bounds of viewport if disabled (enabled is default)
	if(!bAddPointsOutside)
	{
		PLine plView;
		plView.createRectangle(LineSeg(vp.ptCenPS()-0.5*(_XW*vp.widthPS()+_YW*vp.heightPS()),vp.ptCenPS()+0.5*(_XW*vp.widthPS()+_YW*vp.heightPS())),_XW,_YW);
		plView.transformBy(ps2ms);
		plView.vis(3);
		PlaneProfile ppView(plView);
		Point3d ptsTest[0];
		ptsTest	=ptDimX;
		for (int xy=0;xy<2;xy++)
		{
			String sTxt2="X";
			if (xy==0)	ptsTest=ptDimX;
			else 
			{
				ptsTest=ptDimY;
				sTxt2="Y";
			}
	
			int nNumRemoved;
			for (int i =ptsTest.length()-1; i>=0; i--)
				if (ppView.pointInProfile(ptsTest[i])==_kPointOutsideProfile)
				{
					ptsTest.removeAt(i);
					nNumRemoved++;
				}
			String sTxt;	
			if (nNumRemoved==1) sTxt = T("|1 dimpoint is outside of the viewport.|");
			else if (nNumRemoved>1) sTxt =nNumRemoved + " " + T("|dimpoints are outside of the viewport.|") ;
			if (nNumRemoved>0)
			{
				sTxt += " " + T("|Dimension might be incomplete or with wrong reference in|") + " " + sTxt2;
				reportMessage("\n" + sTxt);
				nNumRemoved=0;	
			}
		// reassign filtered points	
			if (xy==0)ptDimX=ptsTest;
			else ptDimY=ptsTest;
		}
	}


	
	for (int i = 0; i < ptRoomsX.length(); i++)
	{
		ptRoomsX[i].transformBy(ms2ps);
		ptRoomsX[i].vis(1);
	}
		
		
	ptDimX= Line(pt0ms,nDimDirX * vecX).orderPoints(ptDimX);
	ptDimY= Line(pt0ms,nDimDirY * vecY).orderPoints(ptDimY);
	
//region set reference points in correct order
	if (ptRefX.length()>0)
	{ 
		for (int i=0;i<ptDimX.length();i++) 
		{ 
			if (nDimDirX==1 && abs(vecX.dotProduct(ptRefX[0]-ptDimX[i]))<dEps)
			{
				ptDimX.swap(0,i);
				break;
			}
			else if (nDimDirX==-1 && abs(vecX.dotProduct(ptRefX[ptRefX.length()-1]-ptDimX[i]))<dEps)
			{
				ptDimX.swap(ptDimX.length()-1,i);
				break;
			}			
		}
	}			
	if (ptRefY.length()>0)
	{ 
		for (int i=0;i<ptDimY.length();i++) 
		{ 
			if (nDimDirY==1 && abs(vecY.dotProduct(ptRefY[0]-ptDimY[i]))<dEps)
			{
				ptDimY.swap(0,i);
				break;
			}
			else if (nDimDirY==-1 && abs(vecY.dotProduct(ptRefY[ptRefY.length()-1]-ptDimY[i]))<dEps)
			{
				ptDimY.swap(ptDimY.length()-1,i);
				break;
			}			
		}
	}	

//End set reference points in correct order//endregion 

	
	for (int i = 0; i < ptDimX.length(); i++)
	{
		ptDimX[i].transformBy(ms2ps);
		ptDimX[i].vis(3);
	}
	for (int i = 0; i < ptDimY.length(); i++)
	{
		ptDimY[i].transformBy(ms2ps);
		ptDimY[i].vis(30);
	}
	
	

	
	
	
// declare dim
	Dim dimX(dlX,  ptDimX, "<>",  "<>",nDispDelta, nDispChain); 	
	Dim dimY(dlY,  ptDimY, "<>",  "<>",nDispDelta, nDispChain);

	Point3d ptXExtreme[0], ptYExtreme[0];
	if (ptDimX.length() >= 2){
		ptXExtreme.append(ptDimX[0]);
		ptXExtreme.append(ptDimX[ptDimX.length()-1]);			
	}
	if (ptDimY.length() >= 2){
		ptYExtreme.append(ptDimY[0]);
		ptYExtreme.append(ptDimY[ptDimY.length()-1]);			
	}
	Dim dimXExtreme(dlX,  ptXExtreme, "<>",  "<>",nDispExtremes ); 
	Dim dimYExtreme(dlY,  ptYExtreme, "<>",  "<>",nDispExtremes ); 
	dimXExtreme.setReadDirection(-_XW + _YW);
	dimYExtreme.setReadDirection(-_XW + _YW);
	dimX.setReadDirection(-_XW + _YW);
	dimY.setReadDirection(-_XW + _YW);
	
// define if delta needs to be on top	
	if (nDisplayOnTop == 1 || nDisplayOnTop == 3)
		dimX.setDeltaOnTop(false);
	if (nDisplayOnTop == 2 || nDisplayOnTop == 3)
		dimY.setDeltaOnTop(false);	
	if (nDisplayOnTopExtremes== 1 || nDisplayOnTopExtremes== 3)
		dimXExtreme.setDeltaOnTop(false);	
	if (nDisplayOnTopExtremes== 2 || nDisplayOnTopExtremes== 3)
		dimYExtreme.setDeltaOnTop(false);			

			
// draw
	//Grippoints
	if (nDisplayModeExtremes== 2)// do not display extremes 
		_PtG.setLength(0);
	else{
		if (_PtG.length() <= 0){
			_PtG.append(_Pt0 - _YW * U(15));	
			_PtG.append(_Pt0 - _XW * U(15));	
		}
		//relocate
		_PtG[0] = _PtG[0] - _XW * _XW.dotProduct(	_PtG[0] - _Pt0);
		_PtG[1] = _PtG[1] - _YW * _YW.dotProduct(	_PtG[1] - _Pt0);
	}

	if (bDrawDim && (sDimDir == sArDimDir[0] || sDimDir == sArDimDir[2]))	{
		if (ptDimX.length() >= 2){
			// Extremes or Both
			if (nDisplayModeExtremes != 2) { 
				//dimXExtreme.transformBy(ms2ps);
				dimXExtreme.transformBy(_PtG[0] - _Pt0);
				dp.draw(dimXExtreme);
			}
			//delta or chain of object
			if ((nDispDelta != _kDimNone || nDispChain != _kDimNone) && nDisplayModeExtremes<=2){
				//dimX.transformBy(ms2ps);
				dp.draw(dimX);			
			}
		}
	}
	if (bDrawDim && (sDimDir == sArDimDir[1] || sDimDir == sArDimDir[2]))	{	
		if (ptDimY.length() >= 2){
			// Extremes or Both
			if (nDisplayModeExtremes != 2) { 
				//dimYExtreme.transformBy(ms2ps);
				dimYExtreme.transformBy(_PtG[1] - _Pt0);
				dp.draw(dimYExtreme);
			}
			// delta or chain of object
			if ((nDispDelta != _kDimNone || nDispChain != _kDimNone) && nDisplayModeExtremes<=2){			
				//dimY.transformBy(ms2ps);
				dp.draw(dimY);	
			}	
		}
	}

// Description
	String sDesc = sDescAlias;
	int nDescZn = nZn;
	if (nDimObj == 0)
			nDescZn  = 0;
	else if (nDimObj == 2)
		if (sDesc == "")
			sDesc  = sTSLName;	
	if (sDesc == "")
		if (el.zone(nDescZn).material() != "")
			sDesc =  el.zone(nDescZn).material();
		else
		sDesc = sDimObj;	
	if ((bDrawDim || _bOnDebug) && (ptDimX.length() > 0 || ptDimY.length() > 0))
		dp.draw(sDesc, _Pt0, _XW, _YW,0,0);	
	
// show opening size
	if (nShowOpSize > 0)
	{
		// 0 = None
		// 1 = Size
		// 2 = Elevations
		// 3 = Offsets
		// 4 = Size & Elevations
		// 5 = Size & Offsets
		// 6 = Elevations & Offsets
		// 7 = All		
		
		Opening op[0];
		op = el.opening();

		Sheet shOp[0];
		PlaneProfile ppZn;
		if (nShowOpSize == 3 || nShowOpSize == 5 || nShowOpSize == 6 || nShowOpSize == 7 )
		{
			// collect sheets of selected zone
			Sheet shAux[] = el.sheet(nZn);
			
			for (int i = 0; i < shAux.length(); i++)
			{	
				PlaneProfile ppAux = shAux[i].profShape();//shAux[i].realBody().shadowProfile(Plane(shAux[i].ptCen(), shAux[i].vecZ()));
				
				int bAdd;
				// exclude color
				if (nExcludeColors.find(shAux[i].color())<0 && shAux[i].myZoneIndex() == nZn && sIncludeColor == "")
					bAdd = true;
				// exclusive color
				else if(shAux[i].myZoneIndex() == nZn &&  nIncludeColors.find(shAux[i].color())>-1)
					bAdd = true;	
					
				if (bAdd)
				{
					shOp.append(shAux[i]);	
					if (ppZn.area() < U(1)*U(1))
						ppZn = ppAux;//shAux[i].profShape();
					else
						ppZn.unionWith(ppAux);//shAux[i].profShape());
				}	
			}		
		}

		
		for (int i = 0; i < op.length(); i++)
		{
			Point3d ptOpMid;
			ptOpMid.setToAverage(op[i].plShape().vertexPoints(TRUE));
			ptOpMid.transformBy(ms2ps);
			ptOpMid.vis(3);	
			
			dp.draw(op[i].description(),ptOpMid,_XW,_YW,0,1.5);
		// size
			if (nShowOpSize == 1 || nShowOpSize == 4 || nShowOpSize == 5 || nShowOpSize == 7 )
			{
				String sTxt1, sTxt2;
				sTxt1.formatUnit(op[i].width(), sDimStyle);
				sTxt2.formatUnit(op[i].height(), sDimStyle);
				dp.draw(sTxt1 + "x" + sTxt2,ptOpMid,_XW,_YW,0,-1.5);
			}
		// elevations
			if (nShowOpSize == 2 || nShowOpSize == 4 || nShowOpSize == 6 || nShowOpSize == 7 )
			{
				String sTxt;
				sTxt.formatUnit((op[i].sillHeight() - ptOrg.Z()), sDimStyle);
				sTxt = T("|Sill h.|") + ":" + sTxt;
				dp.draw(sTxt ,ptOpMid,_XW,_YW,0,-4.5);
				sTxt.formatUnit((op[i].headHeight() - ptOrg.Z()), sDimStyle);
				sTxt = T("|Head h.|") + ":" + sTxt;
				dp.draw(sTxt ,ptOpMid,_XW,_YW,0,-7.5);				
			}
		// offsets
			ptOpMid.transformBy(ps2ms);
			if (nShowOpSize == 3 || nShowOpSize == 5 || nShowOpSize == 6 || nShowOpSize == 7 )
			{
				// opening shape
				PLine plOp = op[i].plShape();
				PlaneProfile ppOp(plOp);
				//ppOp.shrink(-U(10));
				// get a sheets-pp which intersects with opening
				ppOp.intersectWith(ppZn);
				ppOp.vis(4);			
				// collect segments of opening shape
				Point3d ptOp[] = plOp.vertexPoints(FALSE);
				for (int p = 0; p < ptOp.length()-1; p++)
				{
					Vector3d vxLs, vyLs, vzLs;
					LineSeg ls(ptOp[p],ptOp[p+1]);
					vxLs = ptOp[p+1]-ptOp[p];				vxLs.normalize();
					vzLs = -el.vecZ();//zone(nZn).vecZ();
					vyLs = vxLs.crossProduct(vzLs);
					PLine pl(vz);
					double dX, dY;
					dX = U(100);
					dY = abs(vyLs.dotProduct(ls.ptMid()-ptOpMid));
					pl.createRectangle(LineSeg(ls.ptMid()- (vxLs*dX-vyLs*dY),ls.ptMid()+ (vxLs*dX)), vxLs, vyLs);
					pl.vis(2);
					// get the pp to be dimensioned
					PlaneProfile ppDim(pl);
					ppDim.intersectWith(ppOp);
					if (ppDim.area()>pow(U(1),2))
					{
						LineSeg lsDim = ppDim.extentInDir(vyLs);
						lsDim.vis(93);
						lsDim.transformBy(ms2ps);
						vxLs.transformBy(ms2ps);
						vyLs.transformBy(ms2ps);
	
						Point3d ptDimOp[0];
						ptDimOp.append(lsDim.ptStart());
						ptDimOp.append(lsDim.ptEnd());
										
						DimLine dlOp(lsDim.ptMid(), vyLs, vyLs.crossProduct(-_ZW));
						Dim dimOp(dlOp,  ptDimOp, "<>",  "<>",nDispDelta, _kDimNone);
						dimOp.setReadDirection(-_XW+_YW);
						dp.draw (dimOp);
					}
					
				}
			}
		
		}
	}

// show margins in debug mode
	if (_bOnDebug){
		bdMarginX.transformBy(ms2ps);
		bdMarginX.vis(2);
		bdMarginY.transformBy(ms2ps);
		bdMarginY.vis(1);
	}

// offsets and angles
	if (nShowOffsetsAngles>0)
	{
		// nShowOffsetsAngles
		// 0 = none
		// 1 = to frame
		// 2 = to frame with angles
		// 3 = to contour
		// 4 = to contour with angles	

		// filter genbeams to use and build a planeprofile of it
		GenBeam gbThis[0];
		PlaneProfile ppThis;		
		for (int i = 0; i < gbThisZone.length(); i++)
		{	
			int bAdd;
			// exclude color
			if (nExcludeColors.find(gbThisZone[i].color())<0 && sIncludeColor == "")
				bAdd = true;
			// exclusive color
			else if(nIncludeColors.find(gbThisZone[i].color())>-1)
				bAdd = true;	
				
			if (bAdd)
			{
				gbThis.append(gbThisZone[i]);	
				if (gbThisZone[i].bIsKindOf(Beam()))
				{
					int n = gbAll.find(gbThisZone[i]);
					Body bd;
					if (n>-1) bd=bdGbAll[n];
					if (ppThis.area() < pow(U(1),2))
						ppThis= bd.shadowProfile(Plane(ptOrg,vz));
					else
						ppThis.unionWith(bd.shadowProfile(Plane(ptOrg,vz)));
				}
				else if (gbThisZone[i].bIsKindOf(Sheet()))
				{
					Sheet shThis = (Sheet)gbThisZone[i];
					if (ppThis.area() < pow(U(1),2))
						ppThis= shThis .profShape();
					else
						ppThis.unionWith(shThis.profShape());
				}				
				else if (gbThisZone[i].bIsKindOf(Sip()))
				{
					Sip sip= (Sip)gbThisZone[i];
					PlaneProfile ppSip(sip.plEnvelope());
					PLine pl[] = sip.plOpenings();
					for (int o=0;o<pl.length();o++)
						ppSip.joinRing(pl[o],_kSubtract);
					if (ppThis.area() < pow(U(1),2))
						ppThis= ppSip;
					else
						ppThis.unionWith(ppSip);
				}	
			}	
		}
		
	// get outer contour of frame
		PlaneProfile ppFrameOuter=ppFrame;
		ppFrameOuter.shrink(-U(10));// close minor gaps
		ppFrameOuter.shrink(U(10));
		PLine plRings[]=ppFrameOuter.allRings();
		int bIsOp[] = ppFrameOuter.ringIsOpening();
		ppFrameOuter.removeAllRings();
		for (int r=0;r<plRings.length();r++)
			if (!bIsOp[r])
			{
				ppFrameOuter.joinRing(plRings[r],_kAdd);

			}
	// assign ref contour
		PlaneProfile ppRef = ppFrameOuter;
		if (nShowOffsetsAngles==2)// || nShowOffsetsAngles==4)
			ppRef = ppElement;
		//ppThis.shrink(-U(10));// close minor gaps
		//ppThis.shrink(U(10));			
		ppThis.vis(3);
		//ppRef .vis(5);		

	// get all midVertices of zone pp
		Point3d pt[] = ppThis.getGripEdgeMidPoints();
		Point3d ptGrips[0];
		Vector3d vxSeg[0],vySeg[0];
		plRings=ppThis.allRings();
		bIsOp = ppThis.ringIsOpening();
		// ignore grips on openings
		for (int p=0;p<pt.length();p++)
		{
			int bAdd=true;
			for (int r=0;r<plRings.length();r++)
			{
				Point3d ptClose = plRings[r].closestPointTo(pt[p]);
				double d = Vector3d(ptClose-pt[p]).length();
				if (d<dEps && bIsOp[r])
				{
					bAdd=false;
					break;
				}	
				else if (d<dEps && !bIsOp[r])
					break;
			}
			if (bAdd) 
			{
				Point3d ptClose = ppThis.closestPointTo(pt[p]+(vx+vy)*U(1));
				//ptClose.vis(6);
				Vector3d vxTemp = ptClose-pt[p]; vxTemp.normalize();
				Vector3d vyTemp = vxTemp.crossProduct(vz); vyTemp.normalize();
				
				if (ppThis.pointInProfile(pt[p]+vyTemp*U(1))==_kPointOutsideProfile)
				{
					vxTemp*=-1;
					vyTemp*=-1;	
				}
				//vyTemp.vis(pt[p],1);
			// ignore those which are already appended and on same edge (tolerance issue, only one dime per edge)
				for (int r=0;r<ptGrips.length();r++)
				{
					if (abs(vyTemp.dotProduct(pt[p]-ptGrips[r]))<dEps && vyTemp.isParallelTo(vySeg[r]))	
					{
						//ptGrips[r] = (ptGrips[r]+pt[p])/2;// move to mid
						//ptGrips[r].vis(4);
						bAdd=false;
						break;	
					}
				}
				if (bAdd)
				{
					vyTemp.vis(pt[p],20);
					ptGrips.append(pt[p]);	
					vxSeg.append(vxTemp);
					vySeg.append(vyTemp);
					pt[p].vis(94);				
				}
			}
		}// end grip and vector collector
		
	// finally append dimlines
		for (int p=0;p<ptGrips.length();p++)
		{
			ptGrips[p].vis(5);
			Point3d ptClose = ppRef.closestPointTo(ptGrips[p]);
			Vector3d vyClose = ptClose-ptGrips[p];
			vyClose.normalize();
			vyClose = vyClose.crossProduct(vz).crossProduct(-vz);
			//ptClose.vis(6);
			
		// test if the dimension would reference the opposite side of a ring (could happen if sheeting zone has big gaps between sheets)	
			int bIntersectWithRing;
			for (int r=0;r<plRings.length();r++)
			{
				
				if (plRings[r].isOn(ptGrips[p]))
				{
					Plane pnTest(ptGrips[p],vxSeg[p]);
					Point3d ptInt[0];
					ptInt = plRings[r].intersectPoints(pnTest);
					ptInt = Line(ptGrips[p], vySeg[p]).orderPoints(ptInt);//vySeg[p]
					
					double dTest1 = Vector3d(ptInt[0]-ptGrips[p]).length();
					double dTest2 = abs(vySeg[p].dotProduct(ptInt[0]-ptClose));
					double dTest3 = abs(vySeg[p].dotProduct(ptInt[1]-ptClose));
					ptInt[1].vis(4);
					if (ptInt.length()>1 && dTest1>dEps || dTest3<dTest2 || bIsOp[r])
						bIntersectWithRing=true;
					
				}
			}
			if (!vyClose.isParallelTo(vySeg[p]) || bIntersectWithRing) continue;			
			Point3d ptDim[0];
			ptDim.append(ptGrips[p]);ptGrips[p].vis(255);
			ptDim.append(ptGrips[p]+vySeg[p]*vySeg[p].dotProduct(ptClose-ptGrips[p]));
			
		// ignore 0-length dimensions and those where the edges are not parallel	
			Point3d ptNext = ppRef.closestPointTo(ptClose+vxSeg[p]*U(1));
			Vector3d vxRef = ptNext-ptClose; vxRef.normalize();			
			if (Vector3d(ptDim[0]-ptDim[1]).length()<dEps || !vxRef.isParallelTo(vxSeg[p]))continue;
			
		// set the sign of the dimline to visualize positive and negative offsets	
			String sSign;
			if (vyClose.dotProduct(vySeg[p])<0)sSign="-";
			//vyClose.vis(ptGrips[p]+vxSeg[p]*U(10),bIntersectWithRing);			
			//vySeg[p].vis(ptGrips[p],3);
			
			// HSB-24401
			Point3d pt0=ptDim[0];
			Point3d pt1=ptDim[1];
			// HSB-24401: in paperspace
			Point3d pt0ps=ptDim[0];pt0ps.transformBy(ms2ps);
			Point3d pt1ps=ptDim[1];pt1ps.transformBy(ms2ps);
			
			ptDim[0].transformBy(ms2ps);
			ptDim[1].transformBy(ms2ps);
		
			Vector3d vxDim = ptDim[1]-ptDim[0];
			Vector3d vyDim = vxDim.crossProduct(-_ZW);
			// HSB-24401
			PlaneProfile ppVpMs = ppVp;ppVpMs.transformBy(ps2ms);
			PlaneProfile ppVpMsExtend=ppVpMs;ppVpMsExtend.shrink(-U(5));
			PlaneProfile ppVpExtend=ppVpMsExtend;ppVpExtend.transformBy(ms2ps);
			// HSB-24401: Make sure dimension is outside of the viewport
			if(ppVpMs.pointInProfile(pt0)!=_kPointOutsideProfile
			|| ppVpMs.pointInProfile(pt1)!=_kPointOutsideProfile)
			{ 
				Plane pn0(pt0ps,vxDim);
				Point3d pts0[]=ppVpExtend.intersectPoints(pn0,true,true);
				pts0=Line(pt0ps,_YW).orderPoints(pts0);
				ptDim[0]=pts0.last();
				
				Plane pn1(pt1ps,vxDim);
				Point3d pts1[]=ppVpExtend.intersectPoints(pn1,true,true);
				pts1=Line(pt1ps,_YW).orderPoints(pts1);
				ptDim[1]=pts1.last();
			}
			
			
			ptDim[0].vis(3);
			ptDim[1].vis(4);
			
			DimLine dl(ptDim[0], vxDim , vyDim);
			Dim dim(dl,  ptDim, sSign+"<>",  "<>",nDispDelta, _kDimNone);
			dim.setReadDirection(-_XW+_YW);
			dp.draw(dim);		
		}				
	}


// assigning
   assignToLayer("0");






#End
#BeginThumbnail
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
%HH`__]GR
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
        <int nm="BreakPoint" vl="2435" />
        <int nm="BreakPoint" vl="2438" />
        <int nm="BreakPoint" vl="2326" />
        <int nm="BreakPoint" vl="2321" />
        <int nm="BreakPoint" vl="2453" />
        <int nm="BreakPoint" vl="2436" />
        <int nm="BreakPoint" vl="2439" />
        <int nm="BreakPoint" vl="2465" />
        <int nm="BreakPoint" vl="2326" />
        <int nm="BreakPoint" vl="2445" />
        <int nm="BreakPoint" vl="2445" />
        <int nm="BreakPoint" vl="2438" />
        <int nm="BreakPoint" vl="2435" />
        <int nm="BreakPoint" vl="2449" />
        <int nm="BreakPoint" vl="2439" />
        <int nm="BreakPoint" vl="2452" />
        <int nm="BreakPoint" vl="2440" />
        <int nm="BreakPoint" vl="2443" />
        <int nm="BreakPoint" vl="2326" />
        <int nm="BreakPoint" vl="2321" />
        <int nm="BreakPoint" vl="2318" />
        <int nm="BreakPoint" vl="2430" />
        <int nm="BreakPoint" vl="2458" />
        <int nm="BreakPoint" vl="2441" />
        <int nm="BreakPoint" vl="2444" />
        <int nm="BreakPoint" vl="2430" />
        <int nm="BreakPoint" vl="2470" />
        <int nm="BreakPoint" vl="2412" />
        <int nm="BreakPoint" vl="2326" />
        <int nm="BreakPoint" vl="2450" />
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
      <str nm="Comment" vl="HSB-24401: Make sure dimension is outside of viewport" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="8/11/2025 11:28:46 AM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End