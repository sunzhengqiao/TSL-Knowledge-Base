#Version 8
#BeginDescription


1.43 13/12/2022 Add Name and grade to coversheets Author: Robert Pol

1.44 06/03/2024 Redo insert so can be used on element generation Author: Robert Pol
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 44
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl creates a brace (knee wall).
/// </summary>

/// <insert>
/// -
/// </insert>

/// <remark Lang=en>
/// This tsl is attached to the DSP details
/// </remark>

/// <version  value="1.40" date="22.02.2018"></version>

/// <history>
/// AS - 1.00 - 12.01.2009 -	Pilot version
/// AS - 1.01 - 11.04.2011 -	Add the cover plates
/// AS - 1.02 - 11.04.2011 -	Add beamcode filter
/// AS - 1.03 - 11.04.2011 -	Add thumb
/// AS - 1.04 - 11.04.2011 -	Correct name of property
/// AS - 1.05 - 11.04.2011 -	Add zone as property
/// AS - 1.06 - 09.09.2011 -	Create studs through body.
/// AS - 1.07 - 01.11.2011 -	Add labels to sheets
/// AS - 1.08 - 02.11.2011 -	Support multiple beamcodes as stud
/// AS - 1.09 - 08.11.2011 -	Correct beam orientation
/// AS - 1.10 - 18.11.2011 -	Split sheet
/// AS - 1.11 - 19.12.2011 -	Only use beamcodes if the are not empty (white-spaces are trimmed)
/// AS - 1.12 - 21.12.2011 -	Remove redundant code
/// AS - 1.13 - 06.01.2012 -	Add hsbId 4101 as rafter. Take biggest ring for brace.
/// AS - 1.14 - 16.02.2012 -	Support multiple braces in 1 element
/// AS - 1.15 - 18.09.2012 -	Calculate start and end point true envelopeBody(false, true).
/// AS - 1.16 - 19.09.2012 -	Set zone of zone 6 if material is set to "Zone 6"
/// AS - 1.17 - 14.12.2012 -	Only use valid rafters for ptStart and ptEnd calculation
/// AS - 1.18 - 13.02.2013 -	Add splitted sheets to list of sheets to split.
/// AS - 1.19 - 02.05.2013 -	Increase rafter margin from 200 to 1000.
/// AS - 1.20 - 02.05.2013 -	Remove cover sheets outside bracebeam.
/// AS - 1.21 - 02.05.2013 -	Order rafters with a margin
/// AS - 1.22 - 23.06.2013 -	?
/// AS - 1.23 - 28.10.2013 -	Optimze cover sheet orientation
/// AS - 1.24 - 04.12.2013 -	Change sheet props into override props. Correct position coversheets
/// AS - 1.25 - 22.01.2014 -	Correct counters
/// AS - 1.26 - 12.01.2015 -	Add color of cover sheet as a property.
/// AS - 1.27 - 13.01.2015 -	Keep zone specified in DSP detail for beams.
/// AS - 1.28 - 16.03.2015 -	Correct sheet UCS. (FogBugzId 953).
/// AS - 1.29 - 11.05.2015 -	Add tolerance to sheet optimization (FogBugzId 1215).
/// AS - 1.30 - 10.09.2015 -	Split on zone now respects gap.
/// AS - 1.31 - 20.01.2016 -	Very small gaps are rounded to zero (FogBugzId 2392).
/// AS - 1.32 - 13.04.2016 -	Negative gap is also set to zero.
/// AS - 1.33 - 19.04.2016 -	Increase tolerance for gap at sheet split
/// AS - 1.34 - 19.04.2016 -	Rafter is valid if _Pt0 is between start and end of rafter (in element y direction)
/// AS - 1.35 - 20.04.2016 -	Remove debug information.
/// AS - 1.36 - 26.05.2016 -	Take sheets from zone to split before local sheets are added.
/// AS - 1.37 - 25.01.2017 -	FogBugzId 3895: Allow 100 mm tolerance to determine if rafter is valid.
/// AS - 1.38 - 11.10.2017 -	HSB-3833: Transform coversheets in elX direction.
/// RP - 1.39 - 14.12.2017 -	Only take the bottom sheets into account for splitting.
/// HM - 1.40 - 22.02.2018 - 	Add Zone 7 for material settings.
/// DR - 1.41 - 30.05.2018	- Apply filters using HSB_G-FilterGenBeams.mcr
/// DR - 1.42 - 28.06.2018	- Small alignment corrected on props.
//#Versions
//1.44 06/03/2024 Redo insert so can be used on element generation Author: Robert Pol
//1.43 13/12/2022 Add Name and grade to coversheets Author: Robert Pol
/// </history>

//region OPM
int nDoubleIndex, nStringIndex, nIntIndex;
String sDoubleClick= "TslDoubleClick";
int bDebug=_bOnDebug;
bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));	
String sDefault =T("|_Default|");
String sLastInserted =T("|_LastInserted|");	
String sYesNo[] = { T("|Yes|"), T("|No|")};
String executeKey = "ManualInsert";
String category = T("|Geometry|");


//Script uses mm
double dEps = U(.001,"mm");
double dEpsArea = U(100);

int arNZnIndex[] = {5,4,3,2,1,6,7,8,9,10};

PropString sSeperator01(0, "", T("|Bracing|"));
sSeperator01.setReadOnly(true);
//Beamcode of beam to replace with studs
PropString sBmCodeBrace(1, "KSTL-01", "     "+T("|Beamcode brace|"));
//Beamcode of beam to replace with studs
PropString sBmCodeSupportingStud(2, "KSTL-02", "     "+T("|Supporting stud|"));

PropString sSeperator02(3, "", T("|Inside sheeting|"));
sSeperator02.setReadOnly(true);
//Beamcode of beam to transform to a sheet
PropString sBmCodeSheet(4, "KSPL-01", "     "+T("|Beamcode sheet|"));
PropString sLabelSheet(10, "", "     "+T("|Set label of sheet|"));
PropString sMaterialSheet(12, "", "     "+T("|Set material of sheet|"));
sMaterialSheet.setDescription(T("|Name of material or copy text from zone. Example: 'Zone 6'|"));
PropInt nZnSheet(0, arNZnIndex, "     "+T("|Zone sheet|"), 6);
String arSZnIndexSplit[] = {
	T("|No split|"),
	"5","4","3","2","1","6","7","8","9","10"
};
int arNShZnIndexSplit[] = {
	0,
	5,4,3,2,1,6,7,8,9,10
};
PropString sZnSheetSplit(9, arSZnIndexSplit, "     "+T("|Zone sheet-split|"),7);

PropString sSeperator03(5, "", T("|Cover sheeting| ("+T("|next to rafters|)")));
sSeperator03.setReadOnly(true);
//Beamcode of beam to transform to a sheeting at side
PropString sBmCodeCoverSheet(6, "KSPL-02", "     "+T("|Beamcode cover sheet|"));
PropDouble dThicknessCoverSheet(0, U(11), "     "+T("|Thickness cover sheet|"));
PropString sLblCoverSheet(11, "", "     "+T("|Overrule label of cover sheet|"));
PropString sMatCoverSheet(13, "", "     "+T("|Overrule material of cover sheet|"));
PropString sInfoCoverSheet(14, "", "     "+T("|Overrule information of cover sheet|"));
PropInt nZnCoverSheet(1, arNZnIndex, "     "+T("|Zone cover sheet|"),8);
PropInt nColorCoverSheet(2, 1, "     "+T("|Color cover sheet|"));

PropString sSeperator04(7, "", T("|Filter beams|"));
sSeperator04.setReadOnly(true);

// filter beams with beamcode
String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = TslInst().getListOfCatalogNames(filterDefinitionTslName);
filterDefinitions.insertAt(0,"");
PropString beamFilterDefinition(15, filterDefinitions, "     "+T("|Filter definition for beams|"));
beamFilterDefinition.setDescription(T("|Filter definition for beams.|") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));

PropString sFilterBC(8,"ZKRB-03;ZKRB-04;ZKRH-03;ZKRH-04","     "+T("Filter beams with beamcode"));
sFilterBC.setDescription(T("|Filter beams with these beam codes.|") + TN("|NOTE|: ") + T("|These beam codes are only filtered if the filter definition for female beams is left blank!|"));

if( _Map.hasString("DspToTsl") )
{
	String sCatalogName = _Map.getString("DspToTsl");
	setPropValuesFromCatalog(sCatalogName);
	
	_Map.removeAt("DspToTsl", true);
	_kExecuteKey == executeKey;
}

// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if(catalogNames.find(_kExecuteKey) == -1 && _kExecuteKey != "")
{
	setPropValuesFromCatalog(_kExecuteKey);
}

// bOnInsert
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
		{
			sEntries[i] = sEntries[i].makeUpper();	
		}
		
		if (sEntries.find(sKey)>-1)
		{
			setPropValuesFromCatalog(sKey);
			setCatalogFromPropValues(sLastInserted); // use because lastinserted was not set (should not be needed)
		}
		else
		{
			setPropValuesFromCatalog(sKey);
			setCatalogFromPropValues(sLastInserted); // use because lastinserted was not set (should not be needed)
		}
	}	
	else	
	{
		showDialog();
		setCatalogFromPropValues(sLastInserted); // use because lastinserted was not set (should not be needed)
	}
	
	// prompt for elements
	PrEntity ssE(T("|Select element(s)|"), Element());
  	if (ssE.go())
  	{
		_Element.append(ssE.elementSet());
  	}

	
	for (int e=0;e<_Element.length();e++) 
	{
		// prepare tsl cloning
		TslInst tslNew;
		Vector3d vecXTsl= _XE;
		Vector3d vecYTsl= _YE;
		GenBeam gbsTsl[] = {};
		Entity entsTsl[0];
		entsTsl.append(_Element[e]);
		Point3d ptsTsl[] = {};
		int nProps[]={};
		double dProps[]={};
		String sProps[]={};
		Map mapTsl;	
		String sScriptname = scriptName();
		
		ptsTsl.append(_Element[e].coordSys().ptOrg());
		
		tslNew.dbCreate(scriptName(),vecXTsl, vecYTsl, gbsTsl, entsTsl, ptsTsl, sLastInserted, true, mapTsl, executeKey, "");
	}
				
	eraseInstance();		
	return;
}	

if( _Map.hasInt("MasterToSatellite") ){
	int bMasterToSatellite = _Map.getInt("MasterToSatellite");
	if( bMasterToSatellite ){
		int bPropertiesSet = _ThisInst.setPropValuesFromCatalog("MasterToSatellite");
		_Map.removeAt("MasterToSatellite", TRUE);
	}
}

//Check if there is a valid element present
if( _Element.length() == 0 ){
	reportMessage(TN("|No element selected|"));
	eraseInstance();
	return;
}

//Get selected element
Element el = _Element[0];
if( !el.bIsValid() ){
	reportMessage(TN("|Invalid element|"));
	eraseInstance();
	return;
}

String arSFilterBmCode[0];
arSFilterBmCode = sFilterBC.tokenize(";");

//OBSOLETE: using tokenize()
//String sFBC = sFilterBC + ";";
//sFBC.makeUpper();
//int nIndexBC = 0; 
//int sIndexBC = 0;
//while(sIndexBC < sFBC.length()-1){
//	String sTokenBC = sFBC.token(nIndexBC);
//	nIndexBC++;
//	if(sTokenBC.length()==0){
//		sIndexBC++;
//		continue;
//	}
//	sIndexBC = sFBC.find(sTokenBC,0);
//	sTokenBC.trimLeft();
//	sTokenBC.trimRight();
//	arSFilterBmCode.append(sTokenBC);
//}

int nZoneSheet = nZnSheet;
if( nZoneSheet > 5 )
	nZoneSheet = 5 - nZoneSheet;
int nZoneCoverSheet = nZnCoverSheet;
if( nZoneCoverSheet > 5 )
	nZoneCoverSheet = 5 - nZoneCoverSheet;
int nZnIndexSheetSplit = arNShZnIndexSplit[arSZnIndexSplit.find(sZnSheetSplit,7)];
if( nZnIndexSheetSplit > 5 )
	nZnIndexSheetSplit = 5 - nZnIndexSheetSplit;

String sBCSupportingStud = sBmCodeSupportingStud;
sBCSupportingStud.trimLeft();
sBCSupportingStud.trimRight();

String sBCBrace = sBmCodeBrace;
sBCBrace.trimLeft();
sBCBrace.trimRight();

String sBCSheet = sBmCodeSheet;
sBCSheet.trimLeft();
sBCSheet.trimRight();

String sBCCoverSheet = sBmCodeCoverSheet;
sBCCoverSheet.trimLeft();
sBCCoverSheet.trimRight();

String sInformationCoverSheet = sInfoCoverSheet;
String sMaterialCoverSheet = sMatCoverSheet;
String sLabelCoverSheet = sLblCoverSheet;
String sGradeCoverSheet;
String sNameCoverSheet;

//CoordSys
CoordSys csEl = el.coordSys();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

if( _PtG.length() == 0 ){
	_Pt0 = csEl.ptOrg();
	_PtG.append(_Pt0 + vxEl * U(5000));
}
Point3d ptStartDetail = _Pt0;
Point3d ptEndDetail = _PtG[0];
	
//_Pt0 = csEl.ptOrg();
Line lnX(csEl.ptOrg(), vxEl);


// Take sheets from this zone before sheets created in this are added.
Sheet arShZnSplit[] = el.sheet(nZnIndexSheetSplit);

//apply filters to beams from element
Beam beams[] = el.beam();
Entity beamEntities[0];
for (int b=0;b<beams.length();b++)
{
	Beam bm = beams[b];
	if(!bm.bIsValid())
		continue;
		
	beamEntities.append(bm);
}

Map filterGenBeamsMap;
filterGenBeamsMap.setEntityArray(beamEntities, false, "GenBeams", "GenBeams", "GenBeam");
filterGenBeamsMap.setString("BeamCode[]", arSFilterBmCode); filterGenBeamsMap.setInt("Exclude", true);//manual input
int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, beamFilterDefinition, filterGenBeamsMap);
if (!successfullyFiltered) {
	reportWarning(T("|Beams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
	eraseInstance();
	return;
}
Entity filteredBeamEntities[] = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");
Beam arBm[0];
for (int e=0;e<filteredBeamEntities.length();e++) 
{
	Beam bm = (Beam)filteredBeamEntities[e];
	if (!bm.bIsValid()) continue;
	
	arBm.append(bm);
}

Point3d arPtBm[0];
//Rafters
Beam arBmRafter[0];
int arNBmTypeRafter[] = {
	_kDakCenterJoist,
	_kDakLeftEdge,
	_kDakRightEdge,
	_kExtraRafter
};
Beam arBmBrace[0];
Beam arBmSupportingStud[0];
Beam arBmSheet[0];

for( int i=0;i<arBm.length();i++ ){

	Beam bm = arBm[i];	
	String sBmCode = bm.beamCode().token(0);
	
//	OBSOLETE: filter applied by filterGenBeams
//	if( arSFilterBmCode.find(sBmCode) != -1 )
//		continue;
		
	arPtBm.append(bm.envelopeBody(false, true).allVertices());
	
	if( arNBmTypeRafter.find(bm.type()) != -1 || bm.hsbId() == "4101" ){
		// check if it is a valid rafter
		
		Point3d start = bm.ptCenSolid() - vyEl * (0.5 * bm.solidLength() + U(100));
		Point3d end = bm.ptCenSolid() + vyEl * (0.5 * bm.solidLength() + U(100));
		if ((vyEl.dotProduct(_Pt0 - start) * vyEl.dotProduct(_Pt0 - end)) > 0)
			continue;
		
		//Point3d ptBottom = bm.ptCenSolid() - vyEl * 0.5 * bm.solidLength();
		//if( vyEl.dotProduct(ptBottom - csEl.ptOrg()) > U(1000) )
			//continue;
		
		arBmRafter.append(bm);
	}
	
	if( (vxEl.dotProduct(ptStartDetail - bm.ptCen()) * vxEl.dotProduct(ptEndDetail - bm.ptCen())) > 0 )
		continue;
	
	if( sBCBrace != "" && sBmCode == sBCBrace && bm.type() != _kStud )
		arBmBrace.append(bm);
	
	if( sBCSupportingStud != "" && sBmCode == sBCSupportingStud )
		arBmSupportingStud.append(bm);	
		
	if( sBCSheet != "" && sBmCode == sBCSheet )
		arBmSheet.append(bm);
}
arPtBm = lnX.orderPoints(arPtBm);

if (arPtBm.length() > 0)
{
	
	Point3d ptElStart = arPtBm[0];
	Point3d ptElEnd = arPtBm[arPtBm.length() - 1];
	
	ptElStart.vis();
	ptElEnd.vis();
	//return;
	
	Beam arBmRafterTmp[0];
	for (int i = 0; i < arBmRafter.length(); i++) {
		Beam bm = arBmRafter[i];
		if (abs(bm.vecX().dotProduct(vxEl)) < dEps)
			arBmRafterTmp.append(bm);
	}
	arBmRafter = arBmRafterTmp;
	for (int s1 = 1; s1 < arBmRafter.length(); s1++) {
		int s11 = s1;
		for (int s2 = s1 - 1; s2 >= 0; s2--) {
			if ( vxEl.dotProduct(arBmRafter[s11].ptCen() - arBmRafter[s2].ptCen()) < 0 ) {
				arBmRafter.swap(s2, s11);
				s11 = s2;
			}
		}
	}
	//arBmRafter = vxEl.filterBeamsPerpendicularSort(arBmRafter);
	
	Vector3d vxBrace = _ZW;
	Vector3d vyBrace = - vxEl;
	Vector3d vzBrace = vxBrace.crossProduct(vyBrace);
	for ( int i = 0; i < arBmBrace.length(); i++) {
		Beam bm = arBmBrace[i];
		Body bdBm = bm.realBody();
		
		//CoordSys beam
		Point3d ptBm = bm.ptCen();
		Vector3d vxBm = bm.vecX();
		if ( vxBm.dotProduct(vxEl) < 0 ) {
			vxBm = - vxBm;
		}
		Vector3d vzBm = bm.vecD(vzEl);
		Vector3d vyBm = vzBm.crossProduct(vxBm);
		
		Plane pnBmX(ptBm, vxEl);
		
		Point3d ptBraceStart = bm.ptCenSolid() - vxBm * 0.5 * bm.solidLength();
		Point3d ptBraceEnd = bm.ptCenSolid() + vxBm * 0.5 * bm.solidLength();
		
		PlaneProfile ppBrace = bdBm.getSlice(pnBmX);
		PLine arPlBrace[] = ppBrace.allRings();
		if ( arPlBrace.length() == 0 )
			return;
			//take biggest ring
			PLine plBrace = arPlBrace[0];
			for ( int j = 1; j < arPlBrace.length(); j++) {
				PLine pl = arPlBrace[j];
				if ( pl.area() > plBrace.area() )
					plBrace = pl;
			}
		plBrace.vis(1);
		Point3d arPtPlBrace[] = plBrace.vertexPoints(false);
		
		double dMaxLnSeg = - 1;
		for ( int j = 0; j < (arPtPlBrace.length() - 1); j++) {
			Point3d ptFrom = arPtPlBrace[j];
			Point3d ptTo = arPtPlBrace[j + 1];
			
			Vector3d vLnSeg(ptTo - ptFrom);
			if ( vLnSeg.dotProduct(_ZW) < 0 )
				vLnSeg *= -1;
			
			double dLnSeg = vLnSeg.length();
			vLnSeg.normalize();
			if ( abs(abs(vLnSeg.dotProduct(vyEl)) - 1) < dEps )
				continue;
			
			if ( dLnSeg > dMaxLnSeg ) {
				dMaxLnSeg = dLnSeg;
				vxBrace = vLnSeg;
			}
		}
		vyBrace = - vxEl;
		vzBrace = vxBrace.crossProduct(vyBrace);
		
		int bCoverSheetFound = false;
		CoordSys csCoverSheet(ptBm, vzEl, - vyEl, vxEl);
		PlaneProfile ppCoverSheet(csCoverSheet);
		for ( int j = 0; j < arBm.length(); j++) {
			Beam bmCoverSh = arBm[j];
			//Beamcode
			String sBmCode = bmCoverSh.name("beamCode").token(0);
			
			if ( sBCCoverSheet != "" && sBmCode == sBCCoverSheet ) {
				Body bdBmCoverSheet = bmCoverSh.realBody();//envelopeBody(true, true);
				bdBmCoverSheet.vis(4);
				
				PlaneProfile pp = bdBmCoverSheet.shadowProfile(pnBmX);//extrusionProfile.planeProfile();
				PLine arPlPp[] = pp.allRings();
				int arPlIsRing[] = pp.ringIsOpening();
				for ( int k = 0; k < arPlPp.length(); k++) {
					PLine pl = arPlPp[k];
					int isOpening = arPlIsRing[k];
					if ( ! isOpening)
						ppCoverSheet.joinRing(pl, _kAdd);
					else
						ppCoverSheet.joinRing(pl, _kSubtract);
				}
				bCoverSheetFound = true;
				
				if ( sInfoCoverSheet == "" )
					sInformationCoverSheet = bmCoverSh.information();
				if ( sMatCoverSheet == "" )
					sMaterialCoverSheet = bmCoverSh.material();
				if ( sLblCoverSheet == "" )
					sLabelCoverSheet = bmCoverSh.label();
				
				sNameCoverSheet = bmCoverSh.name();
				sGradeCoverSheet = bmCoverSh.grade();
				bmCoverSh.dbErase();
				break;
			}
		}
		ppCoverSheet.vis();
		
		//Extreme points of this beam
		//Beam X
		Line lnX(bm.ptCen(), vxBm);
		Point3d arPtBm[] = bdBm.allVertices();
		Point3d arPtBmX[] = lnX.orderPoints(arPtBm);
		if ( arPtBmX.length() < 2 )continue;
		Point3d ptBmMin = arPtBmX[0];
		Point3d ptBmMax = arPtBmX[arPtBmX.length() - 1];
		//World Z
		Line lnZWorld(bm.ptCen(), _ZW);
		Point3d arPtBmZ[] = lnZWorld.orderPoints(arPtBm);
		if ( arPtBmZ.length() < 2 )continue;
		Point3d ptBmBottom = arPtBmZ[0];
		Point3d ptBmTop = arPtBmZ[arPtBmZ.length() - 1];
		
		//Create Braces
		Sheet arShCoverPlate[0];
		for ( int j = 0; j < arBmRafter.length(); j++) {
			Beam bmRafter = arBmRafter[j];
			if ( vyBrace.dotProduct(bmRafter.ptCen() - ptBmMin) * vyBrace.dotProduct(bmRafter.ptCen() - ptBmMax) > 0 )
				continue;
			
			//Create beam
			Beam bmBrace;
			Point3d ptBottom = ptBmBottom + vyBrace * vyBrace.dotProduct(bmRafter.ptCen() - ptBmBottom);
			Point3d ptTop = ptBmTop + vyBrace * vyBrace.dotProduct(bmRafter.ptCen() - ptBmTop);
			double dBmLength = _ZW.dotProduct(ptTop - ptBottom);
			
			Point3d ptBrace = bm.ptCen() + vyBrace * vyBrace.dotProduct(bmRafter.ptCen() - bm.ptCen()) - _ZW * .5 * bm.dD(_ZW);
			Body bdBrace(plBrace, vyBrace * bmRafter.dD(vxEl), 0);
			bdBrace.transformBy(vyBrace * vyBrace.dotProduct(ptBrace - bdBrace.ptCen()));
			bdBrace.vis(1);
			
			bmBrace.dbCreate(bdBrace, vxBrace, vyBrace, vzBrace);
			bmBrace.setColor(32);
			bmBrace.setType(_kStud);
			bmBrace.setBeamCode(sBCBrace);
			bmBrace.assignToElementGroup(el, true, bm.myZoneIndex(), 'Z');
			
			if ( bCoverSheetFound ) {
				
				PLine arPlSh[] = ppCoverSheet.allRings();
				int arBRingIsOpening[] = ppCoverSheet.ringIsOpening();
				PLine plShEnvelope(vxEl);
				PLine plShOpenings[0];
				for ( int k = 0; k < arPlSh.length(); k++) {
					PLine plSh = arPlSh[k];
					int bIsOpening = arBRingIsOpening[k];
					if ( bIsOpening ) {
						plShOpenings.append(plSh);
						continue;
					}
					
					plShEnvelope = plSh;
				}
				
				Point3d ptVertex[] = plShEnvelope.vertexPoints(FALSE);
				double dArea = plShEnvelope.area();
				dArea = dArea / U(1) * U(1);
				
				Point3d ptVertexToSort[0];
				ptVertexToSort.append(ptVertex);
				
				//Store all the posible areas and vectors to define the new orientation of the sheet
				double dValidAreas[0];
				double dSegmentLength[0];
				Vector3d vxNew[0];
				
				//Loop of the vertex Points to analize each segment
				for (int k = 0; k < ptVertex.length() - 1; k++)
				{
					//Declare of the new X and Y Direction using a pair of Vertex Points
					Vector3d vxSeg = ptVertex[k + 1] - ptVertex[k];
					vxSeg.normalize();
					Vector3d vySeg = vxSeg.crossProduct(vxEl);
					
					//Lines to Sort the Point in the New X and Y Direction
					Line lnX (ptVertex[k], vxSeg);
					Line lnY (ptVertex[k], vySeg);
					
					//Sort the vertext Point in the new X direction and fine the bigest distance
					ptVertexToSort = lnX.orderPoints(ptVertexToSort);
					double dDistA = abs(vxSeg.dotProduct(ptVertexToSort[0] - ptVertexToSort[ptVertexToSort.length() - 1]));
					
					//Sort the vertext Point in the new Y direction and fine the bigest distance
					ptVertexToSort = lnY.orderPoints(ptVertexToSort);
					double dDistB = abs(vySeg.dotProduct(ptVertexToSort[0] - ptVertexToSort[ptVertexToSort.length() - 1]));
					
					double dNewArea = dDistA * dDistB;
					double segLength = abs(vxSeg.dotProduct(ptVertex[k + 1] - ptVertex[k]));
					if ( segLength < dEps )
						continue;
					
					dValidAreas.append(dNewArea);
					dSegmentLength.append(segLength);
					vxNew.append(vxSeg);
				}
				
				for (int s1 = 1; s1 < dSegmentLength.length(); s1++) {
					int s11 = s1;
					for (int s2 = s1 - 1; s2 >= 0; s2--) {
						if ( dSegmentLength[s11] < dSegmentLength[s2] ) {
							dValidAreas.swap(s2, s11);
							dSegmentLength.swap(s2, s11);
							vxNew.swap(s2, s11);
							
							s11 = s2;
						}
					}
				}
				
				for (int s1 = 1; s1 < dValidAreas.length(); s1++) {
					int s11 = s1;
					for (int s2 = s1 - 1; s2 >= 0; s2--) {
						if ( (dValidAreas[s2] - dValidAreas[s11]) > dEpsArea ) {
							dValidAreas.swap(s2, s11);
							dSegmentLength.swap(s2, s11);
							vxNew.swap(s2, s11);
							
							s11 = s2;
						}
					}
				}
				
				//for(int s1=1;s1<dSegmentLength.length();s1++){
				//int s11 = s1;
				//for(int s2=s1-1;s2>=0;s2--){
				//if( dSegmentLength[s11] < dSegmentLength[s2] ){
				//dValidAreas.swap(s2, s11);
				//dSegmentLength.swap(s2, s11);
				//vxNew.swap(s2, s11);
				
				//s11=s2;
				//}
				//}
				//}
				
				//for(int s1=1;s1<dValidAreas.length();s1++){
				//int s11 = s1;
				//for(int s2=s1-1;s2>=0;s2--){
				//if( (dValidAreas[s11] - dValidAreas[s2]) > dEpsArea ){
				//dValidAreas.swap(s2, s11);
				//dSegmentLength.swap(s2, s11);
				//vxNew.swap(s2, s11);
				
				//s11=s2;
				//}
				//}
				//}
				
				//			for( int k=0;k<dValidAreas.length();k++ ){
				//				reportNotice("\n\nArea: "+dValidAreas[k]);
				//				reportNotice("\nSegmentLength: "+dSegmentLength[k]);
				//				reportNotice("\nVector: "+vxNew[k]);
				//			}
				
				//Create the New Sheet with the coordinate system of the vector found before
				//Declare the CoordSys for the new sheet
				Vector3d vyNew = vxNew[0].crossProduct(vxEl);
				CoordSys csNew (ptBm, vyNew, vxNew[0], vxEl);
				
				PlaneProfile ppOptimizedCoverSheet(csNew);
				ppOptimizedCoverSheet.unionWith(ppCoverSheet);
				
				ppOptimizedCoverSheet.transformBy(vxEl * vxEl.dotProduct(bmBrace.ptCen() - .5 * vxEl * bmBrace.dW() - ppOptimizedCoverSheet.coordSys().ptOrg()));
				Sheet shLeft;
				shLeft.dbCreate(ppOptimizedCoverSheet, dThicknessCoverSheet, - 1);
				shLeft.setColor(nColorCoverSheet);
				shLeft.setLabel(sLabelCoverSheet);
				shLeft.setMaterial(sMaterialCoverSheet);
				shLeft.setInformation(sInformationCoverSheet);
				shLeft.setGrade(sGradeCoverSheet);
				shLeft.setName(sNameCoverSheet);
				shLeft.setBeamCode(sBCCoverSheet);
				shLeft.assignToElementGroup(el, true, nZoneCoverSheet, 'Z');
				arShCoverPlate.append(shLeft);
				
				//			Point3d p = bmBrace.ptCen() + .5 * vxBm * bmBrace.dW();
				//			Beam b;
				//			b.dbCreate(p, vxBm, vyBm, vzBm, U(10), U(20), U(30), 0, 0, 0);
				ppOptimizedCoverSheet.transformBy(vxEl * vxEl.dotProduct(bmBrace.ptCen() + .5 * vxEl * bmBrace.dW() - ppOptimizedCoverSheet.coordSys().ptOrg()));
				Sheet shRight;
				shRight.dbCreate(ppOptimizedCoverSheet, dThicknessCoverSheet, 1);
				shRight.setColor(nColorCoverSheet);
				shRight.setLabel(sLabelCoverSheet);
				shRight.setMaterial(sMaterialCoverSheet);
				shRight.setInformation(sInformationCoverSheet);
				shRight.setGrade(sGradeCoverSheet);
				shRight.setName(sNameCoverSheet);
				shRight.setBeamCode(sBCCoverSheet);
				shRight.assignToElementGroup(el, true, nZoneCoverSheet, 'Z');
				arShCoverPlate.append(shRight);
			}
		}
		
		if ( arShCoverPlate.length() > 0 ) {
			if ( (abs(vxEl.dotProduct(arShCoverPlate[0].ptCen() - ptElStart)) < U(100) ||
				abs(vxEl.dotProduct(arShCoverPlate[0].ptCen() - ptElEnd)) < U(100)) ||
			(abs(vxEl.dotProduct(arShCoverPlate[0].ptCen() - ptBraceStart)) < dThicknessCoverSheet ||
			abs(vxEl.dotProduct(arShCoverPlate[0].ptCen() - ptBraceEnd)) < dThicknessCoverSheet) )
			{
				Sheet shRemove = arShCoverPlate[0];
				shRemove.dbErase();
			}
			if ( 	(abs(vxEl.dotProduct(arShCoverPlate[arShCoverPlate.length() - 1].ptCen() - ptElStart)) < U(100) ||
				abs(vxEl.dotProduct(arShCoverPlate[arShCoverPlate.length() - 1].ptCen() - ptElEnd)) < U(100)) ||
			(abs(vxEl.dotProduct(arShCoverPlate[arShCoverPlate.length() - 1].ptCen() - ptBraceStart)) < dThicknessCoverSheet ||
			abs(vxEl.dotProduct(arShCoverPlate[arShCoverPlate.length() - 1].ptCen() - ptBraceEnd)) < dThicknessCoverSheet) )
			{
				Sheet shRemove = arShCoverPlate[arShCoverPlate.length() - 1];
				shRemove.dbErase();
			}
		}
		for ( int j = 0; j < arShCoverPlate.length(); j++) {
			Sheet sh = arShCoverPlate[j];
			for ( int k = 0; k < arBmRafter.length(); k++) {
				Beam bm = arBmRafter[k];
				if ( abs(vxEl.dotProduct(sh.ptCen() - bm.ptCen())) < (0.5 * (sh.dD(vxEl) + bm.dD(vxEl)) - dEps) )
					sh.dbErase();
			}
		}
		
		//Delete this beam
		bm.dbErase();
	}
	
	
	for ( int i = 0; i < arBmSupportingStud.length(); i++) {
		Beam bm = arBmSupportingStud[i];
		Body bdBm = bm.realBody();
		
		//CoordSys beam
		Point3d ptBm = bm.ptCen();
		Vector3d vxBm = bm.vecX();
		if ( vxBm.dotProduct(vxEl) < 0 ) {
			vxBm = - vxBm;
		}
		Vector3d vzBm = bm.vecD(vzEl);
		Vector3d vyBm = vzBm.crossProduct(vxBm);
		
		Plane pnBmX(ptBm, vxEl);
		
		PlaneProfile ppSupportingStud = bdBm.getSlice(pnBmX);
		PLine arPlSupportingStud[] = ppSupportingStud.allRings();
		if ( arPlSupportingStud.length() == 0 )
			return;
		PLine plSupportingStud = arPlSupportingStud[0];
		plSupportingStud.vis(1);
		Point3d arPtPlSupportingStud[] = plSupportingStud.vertexPoints(false);
		
		Vector3d vxSupportingStud = _ZW;
		Vector3d vySupportingStud = - vxEl;
		Vector3d vzSupportingStud = vxSupportingStud.crossProduct(vySupportingStud);
		double dMaxLnSeg = - 1;
		for ( int j = 0; j < (arPtPlSupportingStud.length() - 1); j++) {
			Point3d ptFrom = arPtPlSupportingStud[j];
			Point3d ptTo = arPtPlSupportingStud[j + 1];
			
			Vector3d vLnSeg(ptTo - ptFrom);
			if ( vLnSeg.dotProduct(_ZW) < 0 )
				vLnSeg *= -1;
			
			double dLnSeg = vLnSeg.length();
			vLnSeg.normalize();
			if ( abs(abs(vLnSeg.dotProduct(vyEl)) - 1) < dEps )
				continue;
			
			if ( abs(abs(vLnSeg.dotProduct(vxBrace)) - 1) < dEps )
				continue;
			
			if ( dLnSeg > dMaxLnSeg ) {
				dMaxLnSeg = dLnSeg;
				vxSupportingStud = vLnSeg;
			}
		}
		vySupportingStud = - vxEl;
		vzSupportingStud = vxSupportingStud.crossProduct(vySupportingStud);
		
		//Extreme points of this beam
		//Beam X
		Line lnX(bm.ptCen(), vxBm);
		Point3d arPtBm[] = bdBm.allVertices();
		Point3d arPtBmX[] = lnX.orderPoints(arPtBm);
		if ( arPtBmX.length() < 2 )continue;
		Point3d ptBmMin = arPtBmX[0];
		Point3d ptBmMax = arPtBmX[arPtBmX.length() - 1];
		//World Z
		Line lnZWorld(bm.ptCen(), _ZW);
		Point3d arPtBmZ[] = lnZWorld.orderPoints(arPtBm);
		if ( arPtBmZ.length() < 2 )continue;
		Point3d ptBmBottom = arPtBmZ[0];
		Point3d ptBmTop = arPtBmZ[arPtBmZ.length() - 1];
		
		//Create SupportingStuds
		Sheet arShCoverPlate[0];
		for ( int j = 0; j < arBmRafter.length(); j++) {
			Beam bmRafter = arBmRafter[j];
			if ( vySupportingStud.dotProduct(bmRafter.ptCen() - ptBmMin) * vySupportingStud.dotProduct(bmRafter.ptCen() - ptBmMax) > 0 )
				continue;
			
			//Create beam
			Beam bmSupportingStud;
			Point3d ptBottom = ptBmBottom + vySupportingStud * vySupportingStud.dotProduct(bmRafter.ptCen() - ptBmBottom);
			Point3d ptTop = ptBmTop + vySupportingStud * vySupportingStud.dotProduct(bmRafter.ptCen() - ptBmTop);
			double dBmLength = _ZW.dotProduct(ptTop - ptBottom);
			
			Point3d ptSupportingStud = bm.ptCen() + vySupportingStud * vySupportingStud.dotProduct(bmRafter.ptCen() - bm.ptCen()) - _ZW * .5 * bm.dD(_ZW);
			Body bdSupportingStud(plSupportingStud, vySupportingStud * bmRafter.dD(vxEl), 0);
			bdSupportingStud.transformBy(vySupportingStud * vySupportingStud.dotProduct(ptSupportingStud - bdSupportingStud.ptCen()));
			bdSupportingStud.vis(32);
			
			bmSupportingStud.dbCreate(bdSupportingStud, vxSupportingStud, vySupportingStud, vzSupportingStud);
			bmSupportingStud.setColor(1);
			bmSupportingStud.setType(_kStud);
			bmSupportingStud.setBeamCode(sBCSupportingStud);
			bmSupportingStud.assignToElementGroup(el, true, bm.myZoneIndex(), 'Z');
		}
		
		//Delete this beam
		bm.dbErase();
	}
	
	Point3d arPtShEnd[0];
	Point3d arPtShStart[0];
	Sheet sheetsFilteredWithCheckOnHeight[0];
	if (nZnIndexSheetSplit != 0 && arShZnSplit.length() > 0)
	{
		//only get bottom sheets
		for ( int i = 0; i < arShZnSplit.length(); i++) {
			Sheet sh = arShZnSplit[i];
			Body shBody = sh.realBody();
			shBody.vis(i);
			Point3d ptCenterThisSheet = sh.ptCen();
			ptCenterThisSheet.vis(i);
			int appendSheet = true;
			for (int index = 0; index < arShZnSplit.length(); index++)
			{
				Sheet sheet = arShZnSplit[index];
				if (sheet == sh)
					continue;
				PlaneProfile prof = sheet.profShape();
				prof.shrink(dEps);
				PLine allPlines[] = prof.allRings();
				Body sheetBody(allPlines[0], sheet.vecZ() * sheet.solidHeight(), 0);
				Point3d ptCenter = sheet.ptCen();
				ptCenter.vis(i);
				double test1 = vyEl.dotProduct(ptCenter - ptCenterThisSheet);
				sheetBody.transformBy(vyEl * - test1);
				sheetBody.vis(i);
				int test2 = shBody.hasIntersection(sheetBody);
				if (test1 < dEps && test2)
				{
					appendSheet = false;
					break;
				}
			}
			
			if (appendSheet)
				sheetsFilteredWithCheckOnHeight.append(sh);
		}
		
		// order sheets
		for (int s1 = 1; s1 < sheetsFilteredWithCheckOnHeight.length(); s1++) {
			int s11 = s1;
			for (int s2 = s1 - 1; s2 >= 0; s2--) {
				if ( vxEl.dotProduct(sheetsFilteredWithCheckOnHeight[s11].ptCen() - sheetsFilteredWithCheckOnHeight[s2].ptCen()) < 0 ) {
					sheetsFilteredWithCheckOnHeight.swap(s2, s11);
					
					s11 = s2;
				}
			}
		}
		
		for ( int i = 0; i < sheetsFilteredWithCheckOnHeight.length(); i++) {
			Sheet sh = sheetsFilteredWithCheckOnHeight[i];
			Point3d arPtSh[] = sh.profShape().getGripVertexPoints();
			arPtSh = lnX.orderPoints(arPtSh);
			if ( arPtSh.length() > 0 ) {
				arPtShStart.append(arPtSh[0]);
				arPtShEnd.append(arPtSh[arPtSh.length() - 1]);
			}
		}
	}
	
	arPtShStart = lnX.projectPoints(arPtShStart);
	arPtShStart = lnX.orderPoints(arPtShStart, U(0.1));
	arPtShEnd = lnX.projectPoints(arPtShEnd);
	arPtShEnd = lnX.orderPoints(arPtShEnd, U(0.1));
	
	for ( int i = 0; i < arBmSheet.length(); i++) {
		Beam bm = arBmSheet[i];
		Body bdBm = bm.realBody();
		
		CoordSys csSh(bm.ptCen(), vxBrace, vyBrace, vzBrace);
		double dShThickness = bm.dD(vzBrace);
		PlaneProfile ppSh(csSh);
		ppSh = bdBm.shadowProfile(Plane(bm.ptCen(), vzBrace));
		Sheet sh;
		sh.dbCreate(ppSh, dShThickness);
		sh.setColor(5);
		sh.setLabel(sLabelSheet);
		String sMat = sMaterialSheet;
		
		if ( sMaterialSheet == "Zone 6" ) {
			Sheet arShZn06[] = el.sheet(-1);
			for ( int j = 0; j < arShZn06.length(); j++) {
				Sheet shZn06 = arShZn06[j];
				sMat = shZn06.material();
			}
		}
		else if ( sMaterialSheet == "Zone 7" )
		{
			Sheet arShZn07[] = el.sheet(-2);
			for ( int j = 0; j < arShZn07.length(); j++) {
				Sheet shZn07 = arShZn07[j];
				sMat = shZn07.material();
			}
		}
		sh.setMaterial(sMat);
		sh.setBeamCode(sBCSheet);
		sh.assignToElementGroup(el, true, nZoneSheet, 'Z');
		
		Sheet arShToSplit[] = { sh};
		for ( int j = 1; j < arPtShEnd.length(); j++) {
			Point3d ptShEnd = arPtShEnd[j - 1];
			Point3d ptNextShStart = arPtShStart[j];
			double gap = vxEl.dotProduct(ptNextShStart - ptShEnd);
			if (abs(gap) < U(0.1))
				gap = U(0);
			
			for ( int k = 0; k < arShToSplit.length(); k++) {
				Sheet shSplit = arShToSplit[k];
				
				Sheet arShSplitted[] = shSplit.dbSplit(Plane(ptShEnd + vxEl * 0.5 * gap, vxEl), gap);
				for ( int l = 0; l < arShSplitted.length(); l++) {
					Sheet shSplitted = arShSplitted[l];
					if ( arShToSplit.find(shSplitted) == -1 )
						arShToSplit.append(shSplitted);
				}
			}
		}
		
		//Delete this beam
		bm.dbErase();
	}
}
//Erase this tsl.
if (_bOnElementConstructed || _kExecuteKey == executeKey || _bOnRecalc)
{
	eraseInstance();
	return;
}





























#End
#BeginThumbnail
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
=**`"BBB@`HHHH`****`"BBB@`HHHH`****`/_]DH
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
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Redo insert so can be used on element generation" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="44" />
      <str nm="Date" vl="3/6/2024 12:28:59 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add name and grade to cover sheets" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="43" />
      <str nm="Date" vl="12/13/2022 10:00:50 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End