#Version 8
#BeginDescription
#Versions
1.8 21/06/2021 Fix bug where incorrect opening was used to create the beams and sheets Author: Robert Pol

This tsl modifies an edge detail of sip panels.

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 8
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// </summary>

/// <insert>
/// Select a set of  elements.
/// </insert>

/// <remark Lang=en>
/// </remark>

/// <version  value="1.07" date="01.03.2018"></version>

/// <history>
/// AS - 1.00 - 16.01.2015 -	Pilot version
/// AS - 1.01 - 18.03.2015 - Extend beam properties. Add option to join the edges. (FogBugzId 940).
/// AS - 1.02 - 19.06.2015 - Support 4 beams. Add options to extend beams in length. Add panelstop options. (FogBugzId 940).
/// AS - 1.03 - 19.06.2015 - Add option to erase existing beams at the specified edge.
/// AS - 1.04 - 19.06.2015 - Only remove duplicate if tsl is applied with the same edge code.
/// RP - 1.05 - 29.06.2015 - Only remove beams when beam belongs to edge code.
/// RP - 1.06 - 03.07.2017 - Make Panelstops Static and remove tsl after execution.
/// RP - 1.07 - 01.03.2018 - Add option to stop beams in opening
// #Versions
//1.8 21/06/2021 Fix bug where incorrect opening was used to create the beams and sheets Author: Robert Pol
/// </history>


double dEps = U(0.01);

String arSCategory[] = {
	T("|Edge detail|"),
	T("|Detail text|"),
	T("|Beam| 1"),
	T("|Beam| 2"),
	T("|Beam| 3"),
	T("|Beam| 4"),
	T("|Sheet| 1")
};
String arSYesNo[] = {T("|Yes|"), T("|No|")};
String arSNoYes[] = {T("|No|"), T("|Yes|")};
int arNYesNo[] = {_kYes, _kNo};

PropString sApplyToSipEdge(0, "", T("|Apply to edge detail code|"));
sApplyToSipEdge.setDescription(T("|Specifies the detail code to change.|"));
sApplyToSipEdge.setCategory(arSCategory[0]);
PropString sJoinEdges(2, arSYesNo, T("|Join edges|"));
sJoinEdges.setDescription(T("|Specifies whether the edges have to be joined.|"));
PropString sUseOpeningInLengthCalculation(44, arSNoYes, T("|Override by opening|"));
sUseOpeningInLengthCalculation.setDescription(T("|Specifies whether the edge gets an override from the closest opening edge.|"));
sUseOpeningInLengthCalculation.setCategory(arSCategory[0]);

PropString sDeleteExistingBeams(43, arSYesNo, T("|Remove existing beams for this edge|"), 1);
sDeleteExistingBeams.setDescription(T("|Specifies whether the existing beams have to be removed.|"));
sDeleteExistingBeams.setCategory(arSCategory[0]);


PropInt nDetailCodeColor(0, 7, T("|Color detail code|"));
nDetailCodeColor.setDescription(T("|Sets the color of the detail.|"));
nDetailCodeColor.setCategory(arSCategory[1]);
PropString sDimStyle(1, _DimStyles, T("|Dimension style|"));
sDimStyle.setDescription(T("|Sets the dimension style.|")+TN("|The text style from the dimension style is used.|"));
sDimStyle.setCategory(arSCategory[1]);
PropDouble dTextHeight(4, -U(1), T("|Text height|"));
dTextHeight.setDescription(T("|Sets the text height.|")+TN("|Zero or less means that the text height is taken from the dimension style.|"));
dTextHeight.setCategory(arSCategory[1]);


PropDouble dOffsetFromPanelFace1(0, U(0), T("1 |Offset from panel face|"));
dOffsetFromPanelFace1.setDescription(T("|Sets the offset from the front of the panel|"));
dOffsetFromPanelFace1.setCategory(arSCategory[2]);
PropDouble dOffsetFromEdge1(1, U(0), T("1 |Offset from edge|"));
dOffsetFromEdge1.setDescription(T("|Sets the offset from the edge|"));
dOffsetFromEdge1.setCategory(arSCategory[2]);
PropDouble dOffsetStartOfEdge1(17, U(0), T("1 |Offset at start of edge|"));
dOffsetStartOfEdge1.setDescription(T("|Sets the offset from the end of the edge.|"));
dOffsetStartOfEdge1.setCategory(arSCategory[2]);
PropDouble dOffsetEndOfEdge1(18, U(0), T("1 |Offset at end of edge|"));
dOffsetEndOfEdge1.setDescription(T("|Sets the offset from the end of the edge.|"));
dOffsetEndOfEdge1.setCategory(arSCategory[2]);
PropDouble dBeamOnPanel1(2, U(44), T("1 |Size on panel|"));
dBeamOnPanel1.setDescription(T("|Sets the size of the beam measured in the direction of the thickness of the panel.|"));
dBeamOnPanel1.setCategory(arSCategory[2]);
PropDouble dBeamFromPanel1(3, U(44), T("1 |Size from panel|"));
dBeamFromPanel1.setDescription(T("|Sets the size of the beam measured in the direction away from the panel.|"));
dBeamFromPanel1.setCategory(arSCategory[2]);
PropString sApplyPanelStop1(21, arSYesNo, T("1 |Apply panel stop|"),1);
sApplyPanelStop1.setDescription(T("|Specifies whether there should be a panel stop applied for this beam.|"));
sApplyPanelStop1.setCategory(arSCategory[2]);
PropInt nBeamColor1(1, 32, T("1 |Color beam|"));
nBeamColor1.setDescription(T("|Sets the color.|"));
nBeamColor1.setCategory(arSCategory[2]);
PropString sBeamName1(3, "", T("1 |Name|"));
sBeamName1.setDescription(T("|Sets the name.|"));
sBeamName1.setCategory(arSCategory[2]);
PropString sBeamMaterial1(4, "", T("1 |Material|"));
sBeamMaterial1.setDescription(T("|Sets the material.|"));
sBeamMaterial1.setCategory(arSCategory[2]);
PropString sBeamGrade1(5, "", T("1 |Grade|"));
sBeamGrade1.setDescription(T("|Sets the grade.|"));
sBeamGrade1.setCategory(arSCategory[2]);
PropString sBeamInformation1(6, "", T("1 |Information|"));
sBeamInformation1.setDescription(T("|Sets the information.|"));
sBeamInformation1.setCategory(arSCategory[2]);
PropString sBeamLabel1(7, "", T("1 |Label|"));
sBeamLabel1.setDescription(T("|Sets the label.|"));
sBeamLabel1.setCategory(arSCategory[2]);
PropString sBeamSubLabel1(8, "", T("1 |Sublabel|"));
sBeamSubLabel1.setDescription(T("|Sets the sublabel.|"));
sBeamSubLabel1.setCategory(arSCategory[2]);
PropString sBeamSubLabel21(9, "", T("1 |Sublabel 2|"));
sBeamSubLabel21.setDescription(T("|Sets the sublabel 2.|"));
sBeamSubLabel21.setCategory(arSCategory[2]);
PropString sBeamCode1(10, "", T("1 |Beam code|"));
sBeamCode1.setDescription(T("|Sets the beam code.|"));
sBeamCode1.setCategory(arSCategory[2]);
PropString sBeamType1(11, _BeamTypes, T("1 |Beam type|"));
sBeamType1.setDescription(T("|Sets the beam type.|"));
sBeamType1.setCategory(arSCategory[2]);


PropDouble dOffsetFromPanelFace2(5, U(0), T("|2 Offset from panel face|"));
dOffsetFromPanelFace2.setDescription(T("|Sets the offset from the front of the panel|"));
dOffsetFromPanelFace2.setCategory(arSCategory[3]);
PropDouble dOffsetFromEdge2(6, U(0), T("2 |Offset from edge|"));
dOffsetFromEdge2.setDescription(T("|Sets the offset from the edge|"));
dOffsetFromEdge2.setCategory(arSCategory[3]);
PropDouble dOffsetStartOfEdge2(19, U(0), T("2 |Offset at start of edge|"));
dOffsetStartOfEdge2.setDescription(T("|Sets the offset from the end of the edge.|"));
dOffsetStartOfEdge2.setCategory(arSCategory[3]);
PropDouble dOffsetEndOfEdge2(20, U(0), T("2 |Offset at end of edge|"));
dOffsetEndOfEdge2.setDescription(T("|Sets the offset from the end of the edge.|"));
dOffsetEndOfEdge2.setCategory(arSCategory[3]);
PropDouble dBeamOnPanel2(7, U(0), T("2 |Size on panel|"));
dBeamOnPanel2.setDescription(T("|Sets the size of the beam measured in the direction of the thickness of the panel.|"));
dBeamOnPanel2.setCategory(arSCategory[3]);
PropDouble dBeamFromPanel2(8, U(0), T("2 |Size from panel|"));
dBeamFromPanel2.setDescription(T("|Sets the size of the beam measured in the direction away from the panel.|"));
dBeamFromPanel2.setCategory(arSCategory[3]);
PropString sApplyPanelStop2(22, arSYesNo, T("2 |Apply panel stop|"),1);
sApplyPanelStop2.setDescription(T("|Specifies whether there should be a panel stop applied for this beam.|"));
sApplyPanelStop2.setCategory(arSCategory[3]);
PropInt nBeamColor2(2, 32, T("2 |Color beam|"));
nBeamColor2.setDescription(T("|Sets the color.|"));
nBeamColor2.setCategory(arSCategory[3]);
PropString sBeamName2(12, "", T("2 |Name|"));
sBeamName2.setDescription(T("|Sets the name.|"));
sBeamName2.setCategory(arSCategory[3]);
PropString sBeamMaterial2(13, "", T("2 |Material|"));
sBeamMaterial2.setDescription(T("|Sets the material.|"));
sBeamMaterial2.setCategory(arSCategory[3]);
PropString sBeamGrade2(14, "", T("2 |Grade|"));
sBeamGrade2.setDescription(T("|Sets the grade.|"));
sBeamGrade2.setCategory(arSCategory[3]);
PropString sBeamInformation2(15, "", T("2 |Information|"));
sBeamInformation2.setDescription(T("|Sets the information.|"));
sBeamInformation2.setCategory(arSCategory[3]);
PropString sBeamLabel2(16, "", T("2 |Label|"));
sBeamLabel2.setDescription(T("|Sets the label.|"));
sBeamLabel2.setCategory(arSCategory[3]);
PropString sBeamSubLabel2(17, "", T("2 |Sublabel|"));
sBeamSubLabel2.setDescription(T("|Sets the sublabel.|"));
sBeamSubLabel2.setCategory(arSCategory[3]);
PropString sBeamSubLabel22(18, "", T("2 |Sublabel 2|"));
sBeamSubLabel22.setDescription(T("|Sets the sublabel 2.|"));
sBeamSubLabel22.setCategory(arSCategory[3]);
PropString sBeamCode2(19, "", T("2 |Beam code|"));
sBeamCode2.setDescription(T("|Sets the beam code.|"));
sBeamCode2.setCategory(arSCategory[3]);
PropString sBeamType2(20, _BeamTypes, T("2 |Beam type|"));
sBeamType2.setDescription(T("|Sets the beam type.|"));
sBeamType2.setCategory(arSCategory[3]);


PropDouble dOffsetFromPanelFace3(9, U(0), T("|3 Offset from panel face|"));
dOffsetFromPanelFace3.setDescription(T("|Sets the offset from the front of the panel|"));
dOffsetFromPanelFace3.setCategory(arSCategory[4]);
PropDouble dOffsetFromEdge3(10, U(0), T("3 |Offset from edge|"));
dOffsetFromEdge3.setDescription(T("|Sets the offset from the edge|"));
dOffsetFromEdge3.setCategory(arSCategory[4]);
PropDouble dOffsetStartOfEdge3(21, U(0), T("3 |Offset at start of edge|"));
dOffsetStartOfEdge3.setDescription(T("|Sets the offset from the end of the edge.|"));
dOffsetStartOfEdge3.setCategory(arSCategory[4]);
PropDouble dOffsetEndOfEdge3(22, U(0), T("3 |Offset at end of edge|"));
dOffsetEndOfEdge3.setDescription(T("|Sets the offset from the end of the edge.|"));
dOffsetEndOfEdge3.setCategory(arSCategory[4]);
PropDouble dBeamOnPanel3(11, U(0), T("3 |Size on panel|"));
dBeamOnPanel3.setDescription(T("|Sets the size of the beam measured in the direction of the thickness of the panel.|"));
dBeamOnPanel3.setCategory(arSCategory[4]);
PropDouble dBeamFromPanel3(12, U(0), T("3 |Size from panel|"));
dBeamFromPanel3.setDescription(T("|Sets the size of the beam measured in the direction away from the panel.|"));
dBeamFromPanel3.setCategory(arSCategory[4]);
PropString sApplyPanelStop3(23, arSYesNo, T("3 |Apply panel stop|"),1);
sApplyPanelStop3.setDescription(T("|Specifies whether there should be a panel stop applied for this beam.|"));
sApplyPanelStop3.setCategory(arSCategory[4]);
PropInt nBeamColor3(3, 32, T("3 |Color beam|"));
nBeamColor3.setDescription(T("|Sets the color.|"));
nBeamColor3.setCategory(arSCategory[4]);
PropString sBeamName3(24, "", T("3 |Name|"));
sBeamName3.setDescription(T("|Sets the name.|"));
sBeamName3.setCategory(arSCategory[4]);
PropString sBeamMaterial3(25, "", T("3 |Material|"));
sBeamMaterial3.setDescription(T("|Sets the material.|"));
sBeamMaterial3.setCategory(arSCategory[4]);
PropString sBeamGrade3(26, "", T("3 |Grade|"));
sBeamGrade3.setDescription(T("|Sets the grade.|"));
sBeamGrade3.setCategory(arSCategory[4]);
PropString sBeamInformation3(27, "", T("3 |Information|"));
sBeamInformation3.setDescription(T("|Sets the information.|"));
sBeamInformation3.setCategory(arSCategory[4]);
PropString sBeamLabel3(28, "", T("3 |Label|"));
sBeamLabel3.setDescription(T("|Sets the label.|"));
sBeamLabel3.setCategory(arSCategory[4]);
PropString sBeamSubLabel3(29, "", T("3 |Sublabel|"));
sBeamSubLabel3.setDescription(T("|Sets the sublabel.|"));
sBeamSubLabel3.setCategory(arSCategory[4]);
PropString sBeamSubLabel23(30, "", T("3 |Sublabel 2|"));
sBeamSubLabel23.setDescription(T("|Sets the sublabel 2.|"));
sBeamSubLabel23.setCategory(arSCategory[4]);
PropString sBeamCode3(31, "", T("3 |Beam code|"));
sBeamCode3.setDescription(T("|Sets the beam code.|"));
sBeamCode3.setCategory(arSCategory[4]);
PropString sBeamType3(32, _BeamTypes, T("3 |Beam type|"));
sBeamType3.setDescription(T("|Sets the beam type.|"));
sBeamType3.setCategory(arSCategory[4]);


PropDouble dOffsetFromPanelFace4(13, U(0), T("|4 Offset from panel face|"));
dOffsetFromPanelFace4.setDescription(T("|Sets the offset from the front of the panel|"));
dOffsetFromPanelFace4.setCategory(arSCategory[5]);
PropDouble dOffsetFromEdge4(14, U(0), T("4 |Offset from edge|"));
dOffsetFromEdge4.setDescription(T("|Sets the offset from the edge|"));
dOffsetFromEdge4.setCategory(arSCategory[5]);
PropDouble dOffsetStartOfEdge4(23, U(0), T("4 |Offset at start of edge|"));
dOffsetStartOfEdge4.setDescription(T("|Sets the offset from the end of the edge.|"));
dOffsetStartOfEdge4.setCategory(arSCategory[5]);
PropDouble dOffsetEndOfEdge4(24, U(0), T("4 |Offset at end of edge|"));
dOffsetEndOfEdge4.setDescription(T("|Sets the offset from the end of the edge.|"));
dOffsetEndOfEdge4.setCategory(arSCategory[5]);
PropDouble dBeamOnPanel4(15, U(0), T("4 |Size on panel|"));
dBeamOnPanel4.setDescription(T("|Sets the size of the beam measured in the direction of the thickness of the panel.|"));
dBeamOnPanel4.setCategory(arSCategory[5]);
PropDouble dBeamFromPanel4(16, U(0), T("4 |Size from panel|"));
dBeamFromPanel4.setDescription(T("|Sets the size of the beam measured in the direction away from the panel.|"));
dBeamFromPanel4.setCategory(arSCategory[5]);
PropString sApplyPanelStop4(33, arSYesNo, T("4 |Apply panel stop|"),1);
sApplyPanelStop4.setDescription(T("|Specifies whether there should be a panel stop applied for this beam.|"));
sApplyPanelStop4.setCategory(arSCategory[5]);
PropInt nBeamColor4(4, 32, T("4 |Color beam|"));
nBeamColor4.setDescription(T("|Sets the color.|"));
nBeamColor4.setCategory(arSCategory[5]);
PropString sBeamName4(34, "", T("4 |Name|"));
sBeamName4.setDescription(T("|Sets the name.|"));
sBeamName4.setCategory(arSCategory[5]);
PropString sBeamMaterial4(35, "", T("4 |Material|"));
sBeamMaterial4.setDescription(T("|Sets the material.|"));
sBeamMaterial4.setCategory(arSCategory[5]);
PropString sBeamGrade4(36, "", T("4 |Grade|"));
sBeamGrade4.setDescription(T("|Sets the grade.|"));
sBeamGrade4.setCategory(arSCategory[5]);
PropString sBeamInformation4(37, "", T("4 |Information|"));
sBeamInformation4.setDescription(T("|Sets the information.|"));
sBeamInformation4.setCategory(arSCategory[5]);
PropString sBeamLabel4(38, "", T("4 |Label|"));
sBeamLabel4.setDescription(T("|Sets the label.|"));
sBeamLabel4.setCategory(arSCategory[5]);
PropString sBeamSubLabel4(39, "", T("4 |Sublabel|"));
sBeamSubLabel4.setDescription(T("|Sets the sublabel.|"));
sBeamSubLabel4.setCategory(arSCategory[5]);
PropString sBeamSubLabel24(40, "", T("4 |Sublabel 2|"));
sBeamSubLabel24.setDescription(T("|Sets the sublabel 2.|"));
sBeamSubLabel24.setCategory(arSCategory[5]);
PropString sBeamCode4(41, "", T("4 |Beam code|"));
sBeamCode4.setDescription(T("|Sets the beam code.|"));
sBeamCode4.setCategory(arSCategory[5]);
PropString sBeamType4(42, _BeamTypes, T("4 |Beam type|"));
sBeamType4.setDescription(T("|Sets the beam type.|"));
sBeamType4.setCategory(arSCategory[5]);

// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_S-EdgeBeams");
if( arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

if (_bOnInsert) {
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	
	int nNrOfTslsInserted = 0;
	//Select beam(s) and insertion point
	PrEntity ssE(T("|Select one or more elements|"), Element());
	if (ssE.go()) {
		Element arSelectedElements[] = ssE.elementSet();
		
		//insertion point
		String strScriptName = "HSB_S-EdgeBeams"; // name of the script
		Vector3d vecUcsX(1,0,0);
		Vector3d vecUcsY(0,1,0);
		Beam lstBeams[0];
		Entity lstEntities[1];
		
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		Map mapTsl;
		mapTsl.setInt("MasterToSatellite", TRUE);
		setCatalogFromPropValues("MasterToSatellite");
		mapTsl.setInt("ExecuteMode", 1);
		mapTsl.setInt("ManualInsert", true);
		for( int i=0;i<arSelectedElements.length();i++ ){
			Element el = arSelectedElements[i];
			lstEntities[0] = el;
			
			TslInst arTsl[] = el.tslInst();
			for( int j=0;j<arTsl.length();j++ ){
				TslInst tsl = arTsl[j];
				if( !tsl.bIsValid() || tsl.scriptName() == strScriptName && tsl.propString(0) == sApplyToSipEdge)
					tsl.dbErase();
			}
			
			TslInst tsl;
			tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
			nNrOfTslsInserted++;
		}
	}
	
	reportMessage(nNrOfTslsInserted + T(" |tsl(s) inserted|"));
	
	eraseInstance();
	return;
}
// set properties from master
if( _Map.hasInt("MasterToSatellite") ){
	int bMasterToSatellite = _Map.getInt("MasterToSatellite");
	if( bMasterToSatellite ){
		int bPropertiesSet = _ThisInst.setPropValuesFromCatalog("MasterToSatellite");
		_Map.removeAt("MasterToSatellite", true);
	}
}
int bManualInsert = false;
if( _Map.hasInt("ManualInsert") ){
	bManualInsert = _Map.getInt("ManualInsert");
	_Map.removeAt("ManualInsert", true);
}

if( _Element.length() == 0 ){
	reportMessage(TN("|Invalid selection|!"));
	eraseInstance();
	return;
}

for (int i=0;i<_Map.length();i++) {
	if (!_Map.hasEntity(i) || _Map.keyAt(i) != "Beam")
		continue;
	
	Entity ent = _Map.getEntity(i);
	ent.dbErase();
	
	_Map.removeAt(i, true);
	i--;
}

String sEdge = sApplyToSipEdge;
sEdge = sEdge.trimLeft();
sEdge = sEdge.trimRight();
if (sEdge == "") {
	eraseInstance();
	return;
}

int bJoinEdges = arNYesNo[arSYesNo.find(sJoinEdges,0)];
int useOpeningInLengthCalculation = arNYesNo[arSYesNo.find(sUseOpeningInLengthCalculation,0)];
int bDeleteExistingBeams = arNYesNo[arSYesNo.find(sDeleteExistingBeams, 1)];

double arDOffsetFromPanelFace[] = { 	dOffsetFromPanelFace1, dOffsetFromPanelFace2, dOffsetFromPanelFace3, dOffsetFromPanelFace4};
double arDOffsetFromPanelEdge[] = {	dOffsetFromEdge1, dOffsetFromEdge2, dOffsetFromEdge3, dOffsetFromEdge4};
double arDBeamOnPanel[] = {				dBeamOnPanel1, dBeamOnPanel2, dBeamOnPanel3, dBeamOnPanel4};
double arDBeamFromPanel[] = {			dBeamFromPanel1, dBeamFromPanel2, dBeamFromPanel3, dBeamFromPanel4};
int arNBeamColor[] = {						nBeamColor1, nBeamColor2, nBeamColor3, nBeamColor4};
String arSBeamName[] = {					sBeamName1, sBeamName2, sBeamName3, sBeamName4};
String arSBeamMaterial[] = {				sBeamMaterial1, sBeamMaterial2, sBeamMaterial3, sBeamMaterial4};
String arSBeamGrade[] = {					sBeamGrade1, sBeamGrade2, sBeamGrade3, sBeamGrade4};
String arSBeamInformation[] = {			sBeamInformation1, sBeamInformation2, sBeamInformation3, sBeamInformation4};
String arSBeamLabel[] = {					sBeamLabel1, sBeamLabel2, sBeamLabel3, sBeamLabel4};
String arSBeamSubLabel[] = {				sBeamSubLabel1, sBeamSubLabel2, sBeamSubLabel3, sBeamSubLabel4};
String arSBeamSubLabel2[] = {			sBeamSubLabel21, sBeamSubLabel22, sBeamSubLabel23, sBeamSubLabel24};
String arSBeamCode[] = {					sBeamCode1, sBeamCode2, sBeamCode3, sBeamCode4};
int nBeamType1 = _BeamTypes.find(sBeamType1);
int nBeamType2 = _BeamTypes.find(sBeamType2);
int nBeamType3 = _BeamTypes.find(sBeamType3);
int nBeamType4 = _BeamTypes.find(sBeamType4);
int arNBeamType[] = {						nBeamType1, nBeamType2, nBeamType3, nBeamType4};
int bApplyPanelStop1 = arNYesNo[arSYesNo.find(sApplyPanelStop1, 1)];
int bApplyPanelStop2 = arNYesNo[arSYesNo.find(sApplyPanelStop2, 1)];
int bApplyPanelStop3 = arNYesNo[arSYesNo.find(sApplyPanelStop3, 1)];
int bApplyPanelStop4 = arNYesNo[arSYesNo.find(sApplyPanelStop4, 1)];
int arBApplyPanelStop[] = {				bApplyPanelStop1, bApplyPanelStop2, bApplyPanelStop3, bApplyPanelStop4};
double arDOffsetStartOfEdge[] = {				dOffsetStartOfEdge1, dOffsetStartOfEdge2, dOffsetStartOfEdge3, dOffsetStartOfEdge4};
double arDOffsetEndOfEdge[] = {					dOffsetEndOfEdge1, dOffsetEndOfEdge2, dOffsetEndOfEdge3, dOffsetEndOfEdge4};

Element el = _Element[0];
_ThisInst.assignToElementGroup(el, true, 0, 'E');

CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();
_Pt0 = ptEl;

Display dpDetail(nDetailCodeColor);
dpDetail.elemZone(el, 0, 'C');
dpDetail.dimStyle(sDimStyle);
double dTxtHeight = dpDetail.textHeightForStyle("hsbCAD", sDimStyle);
if (dTextHeight>U(0)) {
	dTxtHeight = dTextHeight;
	dpDetail.textHeight(dTextHeight);
}

if (bManualInsert || _bOnElementConstructed || _bOnDebug){
	Point3d arPtBm[0];
	Vector3d arVecXBm[0];
	Vector3d arVecYBm[0];
	Vector3d arVecZBm[0];
	double arDLBm[0];
	double arDWBm[0];
	double arDHBm[0];
	double arDFlagX[0];
	double arDFlagY[0];
	double arDFlagZ[0];
	int arNBeamIndex[0];
	String arSSipEdgeCode[0];
	Point3d arPtSipEdge[0];
	Vector3d arVNormalSipEdge[0];

	// Used to join the edges
	int arBSipEdgeJoined[0];
	Sip arSipToJoin[0];
	SipEdge arSipEdgeToJoin[0];

	Sip arSip[] = el.sip();
	Beam arBm[] = el.beam();
	for( int i=0;i<arSip.length();i++) {
		Sip sip = arSip[i];
		if (_bOnDebug)
			sip.realBody().vis(i);
		
		SipEdge arSipEdge[] = sip.sipEdges();
		for (int j=0;j<arSipEdge.length();j++) {
			SipEdge sipEdge = arSipEdge[j];
			String sEdgeDetailCode = sipEdge.detailCode();
			
			if (sEdgeDetailCode != sApplyToSipEdge)
				continue;
			
			Vector3d vxEdge = sipEdge.ptEnd() - sipEdge.ptStart();
			double dEdgeLength = vxEdge.length();
			vxEdge.normalize();
			
			
			if (bDeleteExistingBeams) {
				sip.stretchEdgeTo(sipEdge.ptMid(), Plane(sipEdge.ptMid(), sipEdge.vecNormal()));
				for (int k=0;k<arBm.length();k++) {
					Beam bm = arBm[k];
					if (abs(abs(bm.vecX().dotProduct(vxEdge)) - 1) > dEps)
						continue;
					
					if (abs(bm.vecX().dotProduct(vxEl)) < dEps){
					
						if (abs(sipEdge.vecNormal().dotProduct(bm.ptCen() - sipEdge.ptMid())) < U(100) && abs(vxEdge.dotProduct(bm.ptCen() - sipEdge.ptMid())) < U(100))
							bm.dbErase();
						
						}
					else {
					

						if (abs(sipEdge.vecNormal().dotProduct(bm.ptCen() - sipEdge.ptMid())) < U(100))
							bm.dbErase();
					
					}
				}
			}
			
			if (bJoinEdges && !useOpeningInLengthCalculation) 
			{
				arBSipEdgeJoined.append(false);
				arSipToJoin.append(sip);
				arSipEdgeToJoin.append(sipEdge);
			}
			else if (useOpeningInLengthCalculation)
			{
				Point3d ptEdge = sipEdge.ptMid(); 
				ptEdge += vzEl * vzEl.dotProduct(ptEl - ptEdge);
				Vector3d vFromEdge = sipEdge.vecNormal();
				Vector3d vOnEdge = vFromEdge.crossProduct(vxEdge);
				if (vOnEdge.dotProduct(vzEl) < 0) {
					vOnEdge *= -1;
					vxEdge *= -1;
				}
				Opening openings[] = el.opening();
				for (int index=0;index<openings.length();index++) 
				{ 
					Opening opening = openings[index];
					CoordSys openingCoordSys = opening.coordSys();
					Vector3d openingVecX = openingCoordSys.vecX();
					Vector3d openingVecY = openingCoordSys.vecY();
					Vector3d openingVecZ = openingCoordSys.vecZ();
					PLine openingPLine = opening.plShape();
					Point3d vertexPoints[] = openingPLine.vertexPoints(true);
					Point3d ptOrgOpening;
					ptOrgOpening.setToAverage(vertexPoints);
					
					if (abs(vxEdge.dotProduct(openingVecX)) > 1 -dEps)
					{
						Line midLine(ptOrgOpening, vxEdge); 
						Point3d sortedPoints[] = midLine.orderPoints(vertexPoints);
						Line midLineNormal(ptOrgOpening, vFromEdge); 
						Point3d sortedPointsNormal[] = midLineNormal.orderPoints(vertexPoints);
						if (abs(vFromEdge.dotProduct(sortedPointsNormal[0] - ptEdge)) > U(50) || abs(vFromEdge.dotProduct(sortedPointsNormal[sortedPoints.length() - 1] - ptEdge)) > U(50)) continue;
						double check1 = vxEdge.dotProduct(sortedPoints[0] - ptOrgOpening);
						double check2 = vxEdge.dotProduct(sortedPoints[sortedPoints.length()-1] - ptOrgOpening);
						if (check1 * check2 < 0)
						{
							ptEdge += vxEdge * vxEdge.dotProduct(ptOrgOpening - ptEdge);
							dEdgeLength = abs(vxEdge.dotProduct(sortedPoints[sortedPoints.length()-1] - sortedPoints[0]));
						}
					}
					else if (abs(vxEdge.dotProduct(openingVecY)) > 1 -dEps)
					{
						Line midLine(ptOrgOpening, vxEdge); 
						Point3d sortedPoints[] = midLine.orderPoints(vertexPoints);
						Line midLineNormal(ptOrgOpening, vFromEdge); 
						Point3d sortedPointsNormal[] = midLineNormal.orderPoints(vertexPoints);
						if (abs(vFromEdge.dotProduct(sortedPointsNormal[0] - ptEdge)) > U(50) && abs(vFromEdge.dotProduct(sortedPointsNormal[sortedPoints.length() - 1] - ptEdge)) > U(50)) continue;
						double check1 = vxEdge.dotProduct(sortedPoints[0] - ptOrgOpening);
						double check2 = vxEdge.dotProduct(sortedPoints[sortedPoints.length()-1] - ptOrgOpening);
						if (check1 * check2 < 0)
						{
							ptEdge += vxEdge * vxEdge.dotProduct(ptOrgOpening - ptEdge);
							dEdgeLength = abs(vxEdge.dotProduct(sortedPoints[sortedPoints.length()-1] - sortedPoints[0]));
						}
					}
					else	if (abs(vxEdge.dotProduct(openingVecZ)) > 1 -dEps)
					{
						Line midLine(ptOrgOpening, vxEdge); 
						Point3d sortedPoints[] = midLine.orderPoints(vertexPoints);
						Line midLineNormal(ptOrgOpening, vFromEdge); 
						Point3d sortedPointsNormal[] = midLineNormal.orderPoints(vertexPoints);
						if (abs(vFromEdge.dotProduct(sortedPointsNormal[0] - ptEdge)) > U(50) && abs(vFromEdge.dotProduct(sortedPointsNormal[sortedPoints.length() - 1] - ptEdge)) > U(50)) continue;
						double check1 = vxEdge.dotProduct(sortedPoints[0] - ptOrgOpening);
						double check2 = vxEdge.dotProduct(sortedPoints[sortedPoints.length()-1] - ptOrgOpening);
						if (check1 * check2 < 0)
						{
							ptEdge += vxEdge * vxEdge.dotProduct(ptOrgOpening - ptEdge);
							dEdgeLength = abs(vxEdge.dotProduct(sortedPoints[sortedPoints.length()-1] - sortedPoints[0]));
						}
					}
				}
								Point3d ptTxt = ptEdge - vFromEdge * 2 * dTxtHeight;
				Vector3d vxTxt = vxEdge;
				if (vxTxt.dotProduct(vxEl + vyEl) < 0)
					vxTxt *= -1;
				Vector3d vyTxt = vzEl.crossProduct(vxTxt);
				dpDetail.draw(sEdgeDetailCode, ptTxt, vxTxt, vyTxt, 0, 0);
				
				for (int k=0;k<arDOffsetFromPanelFace.length();k++) {
					double dOffsetFromPanelFace = arDOffsetFromPanelFace[k];
					double dOffsetFromPanelEdge = arDOffsetFromPanelEdge[k];
					double dBeamOnPanel = arDBeamOnPanel[k];
					double dBeamFromPanel = arDBeamFromPanel[k];
					
					arPtBm.append(ptEdge - vOnEdge * dOffsetFromPanelFace + vFromEdge * dOffsetFromPanelEdge);
					arVecXBm.append(vxEdge);
					arVecYBm.append(vOnEdge);
					arVecZBm.append(vFromEdge);
					arDLBm.append(dEdgeLength);
					arDWBm.append(dBeamOnPanel);
					arDHBm.append(dBeamFromPanel);
					arDFlagX.append(0);
					arDFlagY.append(-1);
					arDFlagZ.append(1);
					arNBeamIndex.append(k);
					arSSipEdgeCode.append(sipEdge.detailCode());
					arPtSipEdge.append(ptEdge);
					arVNormalSipEdge.append(vFromEdge);
				}
			}
			else {
				Point3d ptEdge = sipEdge.ptMid();
				ptEdge += vzEl * vzEl.dotProduct(ptEl - ptEdge);
				
				Vector3d vFromEdge = sipEdge.vecNormal();
				Vector3d vOnEdge = vFromEdge.crossProduct(vxEdge);
				if (vOnEdge.dotProduct(vzEl) < 0) {
					vOnEdge *= -1;
					vxEdge *= -1;
				}
				
				Point3d ptTxt = ptEdge - vFromEdge * 2 * dTxtHeight;
				Vector3d vxTxt = vxEdge;
				if (vxTxt.dotProduct(vxEl + vyEl) < 0)
					vxTxt *= -1;
				Vector3d vyTxt = vzEl.crossProduct(vxTxt);
				dpDetail.draw(sEdgeDetailCode, ptTxt, vxTxt, vyTxt, 0, 0);
				
				for (int k=0;k<arDOffsetFromPanelFace.length();k++) {
					double dOffsetFromPanelFace = arDOffsetFromPanelFace[k];
					double dOffsetFromPanelEdge = arDOffsetFromPanelEdge[k];
					double dBeamOnPanel = arDBeamOnPanel[k];
					double dBeamFromPanel = arDBeamFromPanel[k];
					
					arPtBm.append(ptEdge - vOnEdge * dOffsetFromPanelFace + vFromEdge * dOffsetFromPanelEdge);
					arVecXBm.append(vxEdge);
					arVecYBm.append(vOnEdge);
					arVecZBm.append(vFromEdge);
					arDLBm.append(dEdgeLength);
					arDWBm.append(dBeamOnPanel);
					arDHBm.append(dBeamFromPanel);
					arDFlagX.append(0);
					arDFlagY.append(-1);
					arDFlagZ.append(1);
					arNBeamIndex.append(k);
					arSSipEdgeCode.append(sipEdge.detailCode());
					arPtSipEdge.append(ptEdge);
					arVNormalSipEdge.append(vFromEdge);
				}
			}
		}
	}

	if ( bJoinEdges) {
		for (int i=0;i<arSipEdgeToJoin.length();i++) {
			if (arBSipEdgeJoined[i])
				continue;
			
			Sip sip = arSipToJoin[i];
			SipEdge sipEdge = arSipEdgeToJoin[i];
			// Flag it as being analyzed.
			arBSipEdgeJoined[i] = true;
			
			Sip arSipAligned[] = {
				sip
			};
			
			SipEdge arSipEdgeAligned[] = {
				sipEdge
			};
			
			Point3d ptStartSE = sipEdge.ptStart();
			Point3d ptEndSE = sipEdge.ptEnd();
			Point3d ptMidSE = sipEdge.ptMid();
			Vector3d vNormalSE = sipEdge.vecNormal();
				
			Vector3d vxSipEdge = ptEndSE - ptStartSE;
			vxSipEdge.normalize();
			
			for (int j=0;j<arSipEdgeToJoin.length();j++) {
				if (arBSipEdgeJoined[j])
					continue;
				Sip sipOther = arSipToJoin[j];
				SipEdge sipEdgeOther = arSipEdgeToJoin[j];
				
				Vector3d vNormalSEOther = sipEdgeOther.vecNormal();
				if (abs(vNormalSE.dotProduct(vNormalSEOther) - 1) > dEps)
					continue;
				
				Point3d ptMidSEOther = sipEdgeOther.ptMid();
				if (abs(vNormalSE.dotProduct(ptMidSEOther - ptMidSE)) > dEps)
					continue;
				
				// Flag it as being analyzed.
				arBSipEdgeJoined[j] = true;
				arSipEdgeAligned.append(sipEdgeOther);
				arSipAligned.append(sipOther);
			}
			
			for(int s1=1;s1<arSipEdgeAligned.length();s1++){
				int s11 = s1;
				for(int s2=s1-1;s2>=0;s2--){
					if( vxSipEdge.dotProduct(ptMidSE - arSipEdgeAligned[s11].ptMid()) < vxSipEdge.dotProduct(ptMidSE - arSipEdgeAligned[s2].ptMid()) ){
						arSipAligned.swap(s2,s11);
						arSipEdgeAligned.swap(s2, s11);
										
						s11=s2;
					}
				}
			}
			
			if (arSipEdgeAligned.length() > 0) {
				Point3d arPtSipEdgeAligned[0];
				for (int j=0;j<arSipEdgeAligned.length();j++) {
					SipEdge sipEdge = arSipEdgeAligned[j];
					arPtSipEdgeAligned.append(sipEdge.ptStart());
					arPtSipEdgeAligned.append(sipEdge.ptEnd());
				}
				arPtSipEdgeAligned = Line(ptStartSE, vxSipEdge).orderPoints(arPtSipEdgeAligned);
				if (arPtSipEdgeAligned.length() < 2)
					continue;
				
				Point3d ptStartEdge = arPtSipEdgeAligned[0];
				Point3d ptEndEdge = arPtSipEdgeAligned[arPtSipEdgeAligned.length() - 1];
				
				Point3d ptEdge = (ptStartEdge + ptEndEdge)/2;
				ptEdge += vzEl * vzEl.dotProduct(ptEl - ptEdge);
				
				vxSipEdge = Vector3d(ptEndEdge - ptStartEdge);
				double dEdgeLength = vxSipEdge.length();
				vxSipEdge.normalize();

				Vector3d vOnEdge = vNormalSE.crossProduct(vxSipEdge);
				if (vOnEdge.dotProduct(vzEl) < 0) {
					vOnEdge *= -1;
					vxSipEdge *= -1;
				}
				
				Point3d ptTxt = ptEdge - vNormalSE * 2 * dTxtHeight;
				Vector3d vxTxt = vxSipEdge;
				if (vxTxt.dotProduct(vxEl + vyEl) < 0)
					vxTxt *= -1;
				Vector3d vyTxt = vzEl.crossProduct(vxTxt);
				dpDetail.draw(sipEdge.detailCode(), ptTxt, vxTxt, vyTxt, 0, 0);
				
				for (int k=0;k<arDOffsetFromPanelFace.length();k++) {
					double dOffsetFromPanelFace = arDOffsetFromPanelFace[k];
					double dOffsetFromPanelEdge = arDOffsetFromPanelEdge[k];
					double dBeamOnPanel = arDBeamOnPanel[k];
					double dBeamFromPanel = arDBeamFromPanel[k];
					
					arPtBm.append(ptEdge - vOnEdge * dOffsetFromPanelFace + vNormalSE * dOffsetFromPanelEdge);
					arVecXBm.append(vxSipEdge);
					arVecYBm.append(vOnEdge);
					arVecZBm.append(vNormalSE);
					arDLBm.append(dEdgeLength);
					arDWBm.append(dBeamOnPanel);
					arDHBm.append(dBeamFromPanel);
					arDFlagX.append(0);
					arDFlagY.append(-1);
					arDFlagZ.append(1);
					arNBeamIndex.append(k);
					arSSipEdgeCode.append(sipEdge.detailCode());
					arPtSipEdge.append(ptEdge);
					arVNormalSipEdge.append(vNormalSE);
				}
			}
		}
	}

	for (int i=0;i<arPtBm.length();i++) {
		Point3d ptBm = arPtBm[i];
		Vector3d vxBm = arVecXBm[i];
		Vector3d vyBm = arVecYBm[i];
		Vector3d vzBm = arVecZBm[i];
		double dlBm = arDLBm[i];
		double dwBm = arDWBm[i];
		double dhBm = arDHBm[i];
		if (dlBm * dwBm * dhBm <= 0)
			continue;
		
		double dxFlag = arDFlagX[i];
		double dyFlag = arDFlagY[i];
		double dzFlag = arDFlagZ[i];
		int nBeamIndex = arNBeamIndex[i];
		
		String sSipEdgeCode = arSSipEdgeCode[i];
		Point3d ptSipEdge = arPtSipEdge[i];
		Vector3d vNormalSipEdge = arVNormalSipEdge[i];
		
		int nBeamColor = arNBeamColor[nBeamIndex];
		String sBeamName = arSBeamName[nBeamIndex];
		String sBeamMaterial = arSBeamMaterial[nBeamIndex];
		String sBeamGrade = arSBeamGrade[nBeamIndex];
		String sBeamInformation = arSBeamInformation[nBeamIndex];
		String sBeamLabel = arSBeamLabel[nBeamIndex];
		String sBeamSubLabel = arSBeamSubLabel[nBeamIndex];
		String sBeamSubLabel2 = arSBeamSubLabel2[nBeamIndex];
		String sBeamCode = arSBeamCode[nBeamIndex];
		int nBeamType = arNBeamType[nBeamIndex];
		double dOffsetStartOfEdge = arDOffsetStartOfEdge[nBeamIndex];
		double dOffsetEndOfEdge = arDOffsetEndOfEdge[nBeamIndex];

		int bApplyPanelStop = arBApplyPanelStop[nBeamIndex];

		// Swap if width is greater than height.
		if (dwBm > dhBm) {
			double dTmp = dhBm;
			dhBm = dwBm;
			dwBm = dTmp;
			
			Vector3d vTmp = vzBm;
			vzBm = vyBm;
			vyBm = vTmp;
			
			dTmp = dzFlag;
			dzFlag = dyFlag;
			dyFlag = dTmp;
		}

		// ptBm is always in the center of the beam;
		ptBm += (vxBm * 0.5 * dxFlag * dlBm);
		
		// Add start and end offsets
		dlBm += (dOffsetStartOfEdge + dOffsetEndOfEdge );
		Vector3d vxOffset = vxBm;
		if (vxOffset.dotProduct(vxEl + vyEl) < 0)
			vxOffset *= -1;
		ptBm += vxOffset * (dOffsetEndOfEdge  - dOffsetStartOfEdge)/2;
		
		if (nBeamType == _kSheeting) {
			Sheet sh;
			sh.dbCreate(ptBm, vxBm, vzBm, vyBm, dlBm, dhBm, dwBm, 0, dzFlag, dyFlag);
			sh.assignToElementGroup(el, true, 0, 'Z');
			_Map.appendEntity("Beam", sh);
			sh.setColor(nBeamColor);
			sh.setName(sBeamName);
			sh.setMaterial(sBeamMaterial);
			sh.setGrade(sBeamGrade);
			sh.setInformation(sBeamInformation);
			sh.setLabel(sBeamLabel);
			sh.setSubLabel(sBeamSubLabel);
			sh.setSubLabel2(sBeamSubLabel2);
			sh.setBeamCode(sBeamCode);
			sh.setType(nBeamType);
		}
		else{
			Beam bm;
			bm.dbCreate(ptBm, vxBm, vyBm, vzBm, dlBm, dwBm, dhBm, 0, dyFlag, dzFlag);
			bm.assignToElementGroup(el, true, 0, 'Z');
			_Map.appendEntity("Beam", bm);
			bm.setColor(nBeamColor);
			bm.setName(sBeamName);
			bm.setMaterial(sBeamMaterial);
			bm.setGrade(sBeamGrade);
			bm.setInformation(sBeamInformation);
			bm.setLabel(sBeamLabel);
			bm.setSubLabel(sBeamSubLabel);
			bm.setSubLabel2(sBeamSubLabel2);
			bm.setBeamCode(sBeamCode);
			bm.setType(nBeamType);
			
			if (bApplyPanelStop) {
				String sSipEdgeCode = arSSipEdgeCode[i];
				Point3d ptSipEdge = arPtSipEdge[i];
				Vector3d vNormalSipEdge = arVNormalSipEdge[i];
				PanelStop panelStop(bm, sSipEdgeCode, ptSipEdge, vNormalSipEdge);
				panelStop.setEdgeRecessType(_kNoEdgeRecess);
				
				Body panelStopBody = bm.envelopeBody();
				for (int s=0;s<arSip.length();s++){
					Sip sip = arSip[s];
					if (panelStopBody.hasIntersection(sip.envelopeBody()))
						sip.addToolStatic(panelStop);
				}
	//			panelStop.addMeToGenBeams(arSip);
			}
		}
	}
	
	eraseInstance();
	return;
}
	
//if (!_Map.hasEntity("Beam")) {
//	reportMessage(TN("|Edge detail code|: ") + sApplyToSipEdge + T("|could not be found on element| ") + el.number());
//	eraseInstance();
//	return;
//}


// Automatic recorded v1.1

#End
#BeginThumbnail











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
      <str nm="COMMENT" vl="Fix bug where incorrect opening was used to create the beams and sheets" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="8" />
      <str nm="DATE" vl="6/21/2021 1:55:29 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End