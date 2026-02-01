#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
27.09.2016  -  version 2.20







































#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 20
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// Tsl to create saw lines on specific zones
/// </summary>

/// <insert>
/// -
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="2.19" date="27.09.2016"></version>

/// <history>
/// 1.00 - 22.07.2011 - 	Pilot version
/// 1.01 - 04.08.2011 - 	Set normal of planeprofile to sheeting side
/// 1.02 - 04.08.2011 - 	Correct openings
/// 1.03 - 10.08.2011 - 	Add warning for indexes >= 10. Set default indexes to 1
/// 1.04 - 10.08.2011 - 	Set defaults overshoot
/// 1.05 - 15.08.2011 - 	Deshrink individual sheets before joining
/// 1.06 - 06.09.2011 - 	Set props readonly
/// 1.07 - 07.09.2011 - 	Change defaults
/// 1.08 - 12.09.2011 - 	Translate t9o ducth
/// 1.09 - 27.09.2011 - 	Correct point filter on polyline
/// 1.10 - 24.01.2012 - 	Assign to zone and draw visualisation on info layer
/// 1.11 - 23.04.2012 - 	Add zone 1 as possible zone to process.
/// 1.12 - 06.09.2012 - 	Allow multiple instances per element if zone index is different
/// 2.00 - 12.12.2012 - 	Add to localizer
/// 2.01 - 19.12.2012 - 	Correct insert name
/// 2.02 - 20.02.2013 - 	Add option to saw if possible
/// 2.03 - 19.03.2013 - 	Set the zone thickness if its not available on the zone.
/// 2.04 - 20.03.2013 - 	Add allowed move directions
/// 2.05 - 26.03.2013 - 	Add option to mill opening with a single operation.
/// 2.06 - 05.04.2013 - 	Add option to overwrite overshoot
/// 2.07 - 23.04.2013 - 	Add option to process only openings
/// 2.08 - 13.02.2014 - 	Add filter options
/// 2.09 - 27.02.2014 - 	Try to make the lines as continuous as possible. TODO: Find the best starting point.
/// 2.10 - 17.11.2014 - 	Ignore openings with more than 8 vertices.
/// 2.11 - 30.06.2015 - 	Ignore internal corner when its the first linesegment.
/// 2.12 - 01.07.2015 - 	Filter is now case-insensitve. 
/// 2.13 - 02.07.2015 - 	Set ucs of plane profile before joining profiles.
/// 2.14 - 18.08.2015 - 	Add tolerance for merging of sheets
/// 2.15 - 16.11.2015 -  Allow saw lines for internal corners too.
/// 2.16 - 19.07.2016 -  Add 'To' position if it is the before-last segment and it is swicthing from internal to extrenal corner.
/// 2.17 - 01.08.2016 -  Start milling at an external corner.
/// 2.18 - 14.09.2016 -  Only start at an external corner if it is NOT an opening (FogBugzId 3332) :-|
/// 2.19 - 27.09.2016 -  Add option to add the thickness of a specific zone as extra depth.
/// 2.20 - 27.09.2016 -  Update description.
/// </hsitory>

if( _bOnElementDeleted ){
//	eraseInstance();
	return;
}

int executeMode = 0; // 0 = default, 1 = insert/recalc

double dEps = U(.001,"mm");

int nLog = 0;

String arSElementType[] = {T("|Roof|"), T("|Floor|"), T("|Wall|")};
String arSElementTypeCombinations[0];
int jStart = 1;
for( int i=0;i<arSElementType.length();i++ ){
	String sTypeA = arSElementType[i];
	if( arSElementTypeCombinations.find(sTypeA) == -1 )
		arSElementTypeCombinations.append(sTypeA);
	
	int j = jStart;

	while( j<arSElementType.length() ){
		String sTypeB = arSElementType[j];
		
		sTypeA += ";"+sTypeB;
		arSElementTypeCombinations.append(sTypeA);

		j++;
	}
	
	jStart++;
	if( jStart < arSElementType.length() )
		i--;
	else
		jStart = i+2;
}

String arSMoveDirections[] = {T("|Horizontal|"), T("|Vertical|"), T("|Angled|")};
String arSAllowedMoveDirections[0];
arSAllowedMoveDirections.append(T("|None|"));
jStart = 1;
for( int i=0;i<arSMoveDirections.length();i++ ){
	String sMoveDirA = arSMoveDirections[i];
	if( arSAllowedMoveDirections.find(sMoveDirA) == -1 )
		arSAllowedMoveDirections.append(sMoveDirA);
	
	int j = jStart;

	while( j<arSMoveDirections.length() ){
		String sMoveDirB = arSMoveDirections[j];
		
		sMoveDirA += ";"+sMoveDirB;
		arSAllowedMoveDirections.append(sMoveDirA);

		j++;
	}
	
	jStart++;
	if( jStart < arSMoveDirections.length() )
		i--;
	else
		jStart = i+2;
}

String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};
String arSSide[]= {T("|Left|"), T("|Right|")};
int arNSide[]={_kLeft, _kRight};
String arSTurn[]= {T("|Against course|"),T("|With course|")};
int arNTurn[]={_kTurnAgainstCourse, _kTurnWithCourse};
String arSZnToProcess[] = {
	"Zone 1",
	"Zone 2",
	"Zone 3",
	"Zone 4",
	"Zone 5",
	"Zone 6",
	"Zone 7",
	"Zone 8",
	"Zone 9",
	"Zone 10",
	"-----"
};
int arNZnToProcess[] = {
	1,
	2,
	3,
	4,
	5,
	-1,
	-2,
	-3,
	-4,
	-5,
	99
};

String arSInExclude[] = {T("|Include|"), T("|Exclude|")};

///
///Selection.
PropString sSeperator01(0, "", T("|Selection|"));
sSeperator01.setReadOnly(true);
PropString sApplyToolingToElementType(1, arSElementTypeCombinations, "     "+T("|Apply tooling to element type|(s)"),6);
PropString sApplyToolingTo(2, arSZnToProcess, "     "+T("|Zone|"),0);
PropString identifierProp(23, "", "     "+T("|Identifier|"));
identifierProp.setDescription(T("|Only one tsl with this identifier is allowed per element. The default value is the zone index.|"));


/// Filter sheets
PropString sSeperator06(19, "", T("|Filters|"));
sSeperator06.setReadOnly(true);
PropString sInExcludeFilters(20, arSInExclude, "     "+T("|Include|")+T("/|exclude|"),1);
PropString sFilterMaterial(21,"","     "+T("|Filter material|"));
PropString sFilterLabel(22,"","     "+T("|Filter label|"));

///
///General Tool Settings.
PropString sSeperator05(15, "", T("|General settings|"));
sSeperator05.setReadOnly(true);
PropString sOnlySawExternalCorners(12, arSYesNo, "     "+T("|Only saw external corners|"));
PropString sOnlyProcessOpenings(18, arSYesNo, "     "+T("|Only process openings|"), 1);
PropString sMoveDirectionSaw(13, arSAllowedMoveDirections, "     "+T("|Allowed move direction saw|"));
PropString sMoveDirectionMill(14, arSAllowedMoveDirections, "     "+T("|Allowed move direction mill|"));
PropDouble dMergeSheetingTolerance(3, U(2), "     "+T("|Merge sheeting tolerance|"));

///
///Saw Settings.
PropString sSeperator02(3, "", T("|Saw lines|"));
sSeperator02.setReadOnly(true);
PropInt nToolingIndexSaw(0, 1,"     "+T("|Toolindex saw|"));
PropString sSideSaw(4,arSSide,"     "+T("|Side saw|"),1);
PropString sTurnSaw(5,arSTurn,"     "+T("|Turning direction saw|"),0);
PropString sOShootSawInternalCorners(6,arSYesNo,"     "+T("|Overshoot saw internal corners|"),0);
PropString sOShootSawExternalCorners(17, arSYesNo, "     "+T("|Overshoot saw external corners|"));
PropDouble dAdditionalDepthSaw(0, U(1), "     "+T("|Extra depth saw|"));
PropString addZoneThicknessToAdditionalDepthSaw(24, arSZnToProcess, "     "+T("|Add thickness of this zone as extra saw depth|"), 10);

///
///Mill Settings.
PropString sSeperator03(7, "", T("|Milling lines|"));
sSeperator03.setReadOnly(true);
PropInt nToolingIndexMill(1, 1, "     "+T("|Toolindex mill|"));
PropString sSideMill(8,arSSide,"     "+T("|Side mill|"),1);
PropString sTurnMill(9,arSTurn,"     "+T("|Turning direction mill|"),0);
PropString sOShootMillInternalCorners(10,arSYesNo,"     "+T("|Overshoot mill internal corners|"),1);
PropString sOShootMillExternalCorners(16, arSYesNo, "     "+T("|Overshoot mill external corners|"));
PropDouble dAdditionalDepthMill(1, U(1), "     "+T("|Extra depth mill|"));
PropString addZoneThicknessToAdditionalDepthMill(25, arSZnToProcess, "     "+T("|Add thickness of this zone as extra mill depth|"), 10);

///
///Visualisation.
PropString sSeperator04(11, "", T("|Visualisation|"));
sSeperator04.setReadOnly(true);
PropInt nColor(2, 4, "     "+T("|Color|"));
PropDouble dSymbolSize(2, U(40), "     "+T("|Symbol size|"));


// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_E-Saw and Milllines");
if( arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

if( _bOnInsert ){
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	
	String identifier = identifierProp;
	if (identifier == "")
		identifier = sApplyToolingTo;
	
	int nNrOfTslsInserted = 0;	
	PrEntity ssE(T("|Select one or more elements|"), Element());
	
	if( ssE.go() ){
		Element arSelectedElement[] = ssE.elementSet();
		
		String strScriptName = "HSB_E-Saw and Milllines"; // name of the script
		Vector3d vecUcsX(1,0,0);
		Vector3d vecUcsY(0,1,0);
		Beam lstBeams[0];
		Element lstElements[1];
		
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		Map mapTsl;
		mapTsl.setInt("MasterToSatellite", TRUE);
		setCatalogFromPropValues("MasterToSatellite");
		mapTsl.setInt("ExecuteMode", 1);// 1 == recalc
		mapTsl.setString("Zone", sApplyToolingTo);
		for( int e=0;e<arSelectedElement.length();e++ ){
			Element el = arSelectedElement[e];
			lstElements[0] = el;
			
			TslInst arTsl[] = el.tslInst();
			for( int i=0;i<arTsl.length();i++ ){
				TslInst tsl = arTsl[i];
				if( tsl.scriptName() == strScriptName && tsl.propString("     "+T("|Identifier|")) == identifier ){
					tsl.dbErase();
				}
			}
			
			TslInst tsl;
			tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
			nNrOfTslsInserted++;
		}
	}
	
	reportMessage(nNrOfTslsInserted + T(" |tsls inserted|"));
	
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

// resolve properties
int bExclude = arSInExclude.find(sInExcludeFilters,1);

String sFMaterial = sFilterMaterial + ";";
String arSFMaterial[0];
int nIndexMaterial = 0; 
int sIndexMaterial = 0;
while(sIndexMaterial < sFMaterial.length()-1){
	String sTokenMaterial = sFMaterial.token(nIndexMaterial);
	nIndexMaterial++;
	if(sTokenMaterial.length()==0){
		sIndexMaterial++;
		continue;
	}
	sIndexMaterial = sFilterMaterial.find(sTokenMaterial,0);

	arSFMaterial.append(sTokenMaterial.makeUpper());
}
String sFLabel = sFilterLabel + ";";
String arSFLabel[0];
int nIndexLabel = 0; 
int sIndexLabel = 0;
while(sIndexLabel < sFLabel.length()-1){
	String sTokenLabel = sFLabel.token(nIndexLabel);
	nIndexLabel++;
	if(sTokenLabel.length()==0){
		sIndexLabel++;
		continue;
	}
	sIndexLabel = sFilterLabel.find(sTokenLabel,0);

	arSFLabel.append(sTokenLabel.makeUpper());
}

// saw these zones
int arNZone[0];
int nZnToProcess = arNZnToProcess[arSZnToProcess.find(sApplyToolingTo,5)];
arNZone.append(nZnToProcess);
int bOnlySawExternalCorners = arNYesNo[arSYesNo.find(sOnlySawExternalCorners,0)];
int bOnlyProcessOpenings = arNYesNo[arSYesNo.find(sOnlyProcessOpenings,1)];

int bHorizontalSawAllowed = sMoveDirectionSaw.find(arSMoveDirections[0],0) != -1;
int bVerticalSawAllowed = sMoveDirectionSaw.find(arSMoveDirections[1],0) != -1;
int bAngledSawAllowed = sMoveDirectionSaw.find(arSMoveDirections[2],0) != -1;

int bHorizontalMillAllowed = sMoveDirectionMill.find(arSMoveDirections[0],0) != -1;
int bVerticalMillAllowed = sMoveDirectionMill.find(arSMoveDirections[1],0) != -1;
int bAngledMillAllowed = sMoveDirectionMill.find(arSMoveDirections[2],0) != -1;;

int nSideRightSaw = arNSide[arSSide.find(sSideSaw,0)];
int nTurnSaw = arNTurn[arSTurn.find(sTurnSaw,0)];
int nOShootSawInternalCorners = arNYesNo[arSYesNo.find(sOShootSawInternalCorners,0)];
int nOShootSawExternalCorners = arNYesNo[arSYesNo.find(sOShootSawExternalCorners,0)];

int nSideRightMill = arNSide[arSSide.find(sSideMill,0)];
int nTurnMill = arNTurn[arSTurn.find(sTurnMill,0)];
int nOShootMillInternalCorners = arNYesNo[arSYesNo.find(sOShootMillInternalCorners,0)];
int nOShootMillExternalCorners = arNYesNo[arSYesNo.find(sOShootMillExternalCorners,0)];

// check if there is a valid element selected.
if( _Element.length()==0 ){
	eraseInstance();
	return;
}

// get element
Element el = _Element[0];
//ElementWallSF elSF = (ElementWallSF)el

assignToElementGroup(el, TRUE, 0, 'E');

if( !_Map.hasString("Zone") )
	_Map.setString("Zone", sApplyToolingTo);
	
String sStoredZone = _Map.getString("Zone");
if( _kNameLastChangedProp == "     "+"Zone" || sStoredZone != sApplyToolingTo ){
	TslInst arTsl[] = el.tslInst();
	for( int i=0;i<arTsl.length();i++ ){
		TslInst tsl = arTsl[i];
		if( tsl.handle() != _ThisInst.handle() && tsl.scriptName() == _ThisInst.scriptName() && tsl.propString("     "+"Zone") == sApplyToolingTo ){
			tsl.dbErase();
		}
	}
	
	_Map.setString("Zone", sApplyToolingTo);
}


// create coordsys
CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

Point3d ptBack = el.zone(-1).coordSys().ptOrg();

int zoneIndexExtraDepthMill = arNZnToProcess[arSZnToProcess.find(addZoneThicknessToAdditionalDepthMill,10)];
int zoneIndexExtraDepthSaw = arNZnToProcess[arSZnToProcess.find(addZoneThicknessToAdditionalDepthSaw,10)];
double extraDepthFromZoneMill = U(0);
double extraDepthFromZoneSaw = U(0);
if (zoneIndexExtraDepthMill != 0)
	extraDepthFromZoneMill = el.zone(zoneIndexExtraDepthMill).dH();
if (zoneIndexExtraDepthSaw != 0)
	extraDepthFromZoneSaw = el.zone(zoneIndexExtraDepthSaw).dH();

double dz = vzEl.dotProduct(_ZW);
String sElemType;
if( abs(dz - 1) < dEps ){
	sElemType = T("|Floor|");
}
else if( abs(dz) < dEps ){
	sElemType = T("|Wall|");
}
else{
	sElemType = T("|Roof|");
}

if( sApplyToolingToElementType.find(sElemType,0) == -1 ){
	reportMessage(TN("|Element type filtered out|"+": "+sElemType));
	eraseInstance();
	return;
}

// set origin point
_Pt0 = ptEl;

// lines for sorting points
Line lnX(ptEl, vxEl);
Line lnY(ptEl, vyEl);

if( _Map.hasInt("ExecuteMode") ){
	executeMode = _Map.getInt("ExecuteMode");
	_Map.removeAt("ExecuteMode", true);
}

if( _bOnRecalc )
	executeMode = 1;

if( _bOnDebug )
	executeMode = 1;
	
if( executeMode == 1 || true ){
// collect beams and sheets used for nailing
	GenBeam arGBmAll[] = el.genBeam();
	Beam arBm[0];
	Sheet arSh[0];
	for( int i=0;i<arGBmAll.length();i++ ){
		GenBeam gBm = arGBmAll[i];
		Beam bm = (Beam)gBm;
		Sheet sh = (Sheet)gBm;
		
		if( _bOnDebug ){
			Body bdGBm = gBm.realBody();
			//bdGBm.vis(gBm.color());
		}
		
		// used the zones for including the rights sheets
		int nZnIndex = gBm.myZoneIndex();
		// use the zones for including the sheets
		if( sh.bIsValid() && arNZone.find(nZnIndex) == -1 )
			continue;
		
		// apply filters
		String sMaterial = gBm.material().makeUpper();
		String sLabel = gBm.label().makeUpper();
		
		int bFilterGenBeam = false;
		if( arSFMaterial.find(sMaterial) != -1 )
			bFilterGenBeam = true;
		if( arSFLabel.find(sLabel) != -1 )
			bFilterGenBeam = true;
			
		if( (bFilterGenBeam && !bExclude) || (!bFilterGenBeam && bExclude) ){
			if( sh.bIsValid() )
				arSh.append(sh);
			else if( bm.bIsValid() )
				arBm.append(bm);
		}
	}
	
	for( int i=0;i<arNZone.length();i++ ){
		// zone
		int nZone = arNZone[i];
		
		double dTZone = el.zone(nZone).dH();
			
		//Side of zone
		int nSide = 1;
		if (nZone<0) nSide = -1;
		
		// get coordSys of the back of zone 1 or -1, the surface of the beams
		CoordSys csBeam = el.zone(nSide).coordSys();
		// get the coordSys of the back of the zone to nail
		CoordSys csSheet = el.zone(nZone).coordSys();
		
		// sheets
		Sheet arShToProcess[0];
		for( int i=0;i<arSh.length();i++ ){
			Sheet sh = arSh[i];
			if( sh.myZoneIndex() == nZone )
				arShToProcess.append(sh);
		}
		
		//Pick the thickness of the first sheet when the zone doesn't have a thickness
		if( dTZone == 0 && arShToProcess.length() > 0 ){
			dTZone = arShToProcess[0].dD(vzEl);
			el.zone(nZone).setDH(dTZone);
			reportMessage(TN("|Zone thickness was not set for element| ")+el.number()+
				TN(". |Thickness of one of the sheets in this zone is used|."));
		}
		
		// profile of zone	
		PlaneProfile ppZone(csSheet);
		Point3d arPtZone[0];
		for( int j=0;j<arShToProcess.length();j++ ){
			PlaneProfile ppSh(csSheet);
			ppSh.unionWith(arShToProcess[j].profShape());
			ppSh.shrink(-dMergeSheetingTolerance);
			//ppSh.vis(5);
			ppZone.unionWith(ppSh);
			arPtZone.append(ppSh.getGripVertexPoints());
		}
		ppZone.shrink(dMergeSheetingTolerance);
		//ppZone.vis(1);
		
		PLine arPlZoneOpening[0];
		PLine arPlZone[] = ppZone.allRings();
		int arBRingIsOpening[] = ppZone.ringIsOpening();
		for( int j=0;j<arPlZone.length();j++ ){
			PLine plZone = arPlZone[j];
			plZone.vis(j+2);
			
			int bRingIsOpening = arBRingIsOpening[j];		
			if( !bRingIsOpening && bOnlyProcessOpenings )
				continue;
			
			plZone.setNormal(csSheet.vecZ());
			
			plZone.convertToLineApprox(U(1));
			Point3d arPtPl[] = plZone.vertexPoints(false);
			
			if( arPtPl.length() < 3)
				continue;

			Point3d arPtCleanResult[0];
			Point3d ptPrev = arPtPl[0];
			arPtCleanResult.append(ptPrev);
			ptPrev.vis(0);
			for( int k=1;k<(arPtPl.length() - 1);k++ ){
				Point3d ptThis = arPtPl[k];
				Point3d ptNext = arPtPl[k+1];
				//ptPrev.vis(k);
				//ptThis.vis(k);
				//ptNext.vis(k);
				Vector3d vToThis(ptThis - ptPrev);
			
				if( nLog == 1 )
					reportNotice("\n"+j+": "+vToThis.length());
			
				if( vToThis.length() < U(0.5) )
					continue;
				vToThis.normalize();
				
				Vector3d vFromThis(ptNext - ptThis);
				
				if( nLog == 1 )
					reportNotice("\n"+k+": "+vFromThis.length());
				
				if( vFromThis.length() < U(0.5) )
					continue;
				vFromThis.normalize();
			
				if( nLog == 1 )
					reportNotice("\n"+k+": "+abs(vToThis.dotProduct(vFromThis) - 1));
			
				if( abs(vToThis.dotProduct(vFromThis) - 1) < dEps )
					continue;
				
				ptPrev = ptThis;
				ptPrev.vis(k);
				arPtCleanResult.append(ptThis);	
			}
			if (bRingIsOpening && arPtCleanResult.length() > 8) 
				continue;
			
			if( arPtCleanResult.length() > 2 ){
				arPtCleanResult.append(arPtCleanResult[0]);
				arPtCleanResult.append(arPtCleanResult[1]);
				arPtCleanResult.append(arPtCleanResult[2]);
			}
			
			//for (int c=0;c<arPtCleanResult.length();c++) {
				//Point3d x = arPtCleanResult[c];
				//x += csSheet.vecZ() * U(100);
				//x.vis(c);
			//}
			
			PLine plToolLine;
			
			int bHasHorizontalSegments = false;
			int bHasVerticalSegments = false;
			int bHasAngledSegments = false;


			int firstPointFound = false;
			Point3d ptBeforeFrom = arPtCleanResult[0];
			for( int k=1;k<(arPtCleanResult.length() - 2);k++ ){
				Point3d ptFrom = arPtCleanResult[k];
				Point3d ptTo = arPtCleanResult[k+1];
				Point3d ptAfterTo = arPtCleanResult[k+2];
				
				Point3d x = arPtCleanResult[k];
				x += csSheet.vecZ() * U(200);
				x.vis(k);

				ptTo.vis(k);
				ptFrom.vis(k);
				
				Vector3d vToFrom(ptFrom - ptBeforeFrom);
				vToFrom.normalize();
				vToFrom.vis(ptBeforeFrom, 1);
				Vector3d vToTo(ptTo - ptFrom);
				vToTo.normalize();
				vToTo.vis(ptFrom, 3);
				Vector3d vFromTo(ptAfterTo - ptTo);
				vFromTo.normalize();
				vFromTo.vis(ptTo, 150);
				
				Vector3d vResultFrom = vToFrom.crossProduct(vToTo);
				double dResultFrom = vResultFrom.dotProduct(csSheet.vecZ());
				
				if (!bRingIsOpening) {
					if (!firstPointFound && dResultFrom < 0) {
						arPtCleanResult.append(ptAfterTo);
						ptBeforeFrom = ptFrom;
						continue;
					}
					else if (!firstPointFound && dResultFrom > 0) {
						firstPointFound = true;
					}
				}
				
				Vector3d vResultTo = vToTo.crossProduct(vFromTo);
				double dResultTo = vResultTo.dotProduct(csSheet.vecZ());
				
				// Get the direction for this segment.	
				double dxPlTool = vxEl.dotProduct(vToTo);
				double dyPlTool = vyEl.dotProduct(vToTo);
				int bSegmentIsHorizontal = false;
				int bSegmentIsVertical = false;
				int bSegmentIsAngled = false;
				if( abs(dxPlTool) > dEps ){
					if( abs(dyPlTool) > dEps )
						bSegmentIsAngled = true;
					else
						bSegmentIsHorizontal = true;
				}
				else{
					bSegmentIsVertical = true;
				}
				
				if( (dResultFrom * dResultTo < 0 && plToolLine.vertexPoints(true).length() > 0) || k == (arPtCleanResult.length() - 3) ){
					// Add the current point too if the current line is for internal corners.
					if( dResultFrom < 0 || k == (arPtCleanResult.length() - 3)){
						plToolLine.addVertex(ptTo);
						if( bSegmentIsHorizontal )
							bHasHorizontalSegments = true;
						else if( bSegmentIsVertical )
							bHasVerticalSegments = true;
						else
							bHasAngledSegments = true;
					}
					
					// Add tooling for current tool line.
					if( plToolLine.vertexPoints(true).length() > 1 ){
						int bIsExternalCorner = dResultFrom > 0;
						
						plToolLine.vis(bIsExternalCorner + 3);
						
						int bMillAllowed = 
							!(!bHorizontalMillAllowed && bHasHorizontalSegments) &&
							!(!bVerticalMillAllowed && bHasVerticalSegments) &&
							!(!bAngledMillAllowed && bHasAngledSegments);
						int bSawAllowed = 
							!(!bHorizontalSawAllowed && bHasHorizontalSegments) &&
							!(!bVerticalSawAllowed && bHasVerticalSegments) &&
							!(!bAngledSawAllowed && bHasAngledSegments);
													
						if( bOnlySawExternalCorners && !bIsExternalCorner )
							bSawAllowed = false;
						
						int nOShtSaw = nOShootSawInternalCorners;
						int nOShtMill = nOShootMillInternalCorners;
						if( bIsExternalCorner ){
							nOShtSaw = nOShootSawExternalCorners;
							nOShtMill = nOShootMillExternalCorners;
						}
						
						if( bSawAllowed ){
							ElemSaw elSaw(nZone, plToolLine, dTZone + dAdditionalDepthSaw + extraDepthFromZoneSaw, nToolingIndexSaw, nSideRightSaw, nTurnSaw, nOShtSaw);
							el.addTool(elSaw);
						}
						else if( bMillAllowed ){
							ElemMill elMill(nZone, plToolLine, dTZone + dAdditionalDepthMill + extraDepthFromZoneMill, nToolingIndexMill, nSideRightMill, nTurnMill, nOShtMill);
							el.addTool(elMill);
						}
					}
					
					// Create a new tool line.
					plToolLine = PLine(csSheet.vecZ());
								
					// Reset the flags.
					bHasAngledSegments = false;
					bHasHorizontalSegments = false;
					bHasVerticalSegments = false;
					
					if( dResultFrom > 0 ){
						plToolLine.addVertex(ptFrom);
						plToolLine.addVertex(ptTo);
						
						if( bSegmentIsHorizontal )
							bHasHorizontalSegments = true;
						else if( bSegmentIsVertical )
							bHasVerticalSegments = true;
						else
							bHasAngledSegments = true;
					}
					else if (k == (arPtCleanResult.length() - 4)) {
						plToolLine.addVertex(ptTo);
					}
				}
				else{
					if( plToolLine.vertexPoints(true).length() < 1 ){// Create a new tool line.
						plToolLine = PLine(csSheet.vecZ());
						plToolLine.addVertex(ptFrom);
						plToolLine.addVertex(ptTo);
					}	
					else{// Extend current tool line.
						plToolLine.addVertex(ptTo);
					}
					
					if( bSegmentIsHorizontal )
						bHasHorizontalSegments = true;
					else if( bSegmentIsVertical )
						bHasVerticalSegments = true;
					else
						bHasAngledSegments = true;
				}
				
				ptBeforeFrom = ptFrom;
			}
		}
	}		
}

// visualisation
String identifier = identifierProp;
	if (identifier == "")
		identifier = sApplyToolingTo;

Display dpVisualisation(nColor);
dpVisualisation.addHideDirection(_ZW);
dpVisualisation.addHideDirection(-_ZW);
dpVisualisation.elemZone(el, -5, 'I');

Point3d ptSymbol01 = _Pt0 - vyEl * 2 * dSymbolSize;
Point3d ptSymbol02 = ptSymbol01 - (vxEl + vyEl) * dSymbolSize;
Point3d ptSymbol03 = ptSymbol01 + (vxEl - vyEl) * dSymbolSize;

PLine plSymbol01(vzEl);
plSymbol01.addVertex(_Pt0);
plSymbol01.addVertex(ptSymbol01);
PLine plSymbol02(vzEl);
plSymbol02.addVertex(ptSymbol02);
plSymbol02.addVertex(ptSymbol01);
plSymbol02.addVertex(ptSymbol03);

dpVisualisation.draw(plSymbol01);
dpVisualisation.draw(plSymbol02);

dpVisualisation.textHeight(0.1 * dSymbolSize);
dpVisualisation.draw(identifier, ptSymbol02, vxEl + vyEl, vyEl - vxEl, 1, -1.5);

{
	Display dpVisualisationPlan(nColor);
	dpVisualisationPlan.addViewDirection(_ZW);
	dpVisualisationPlan.addViewDirection(-_ZW);	
	dpVisualisationPlan.elemZone(el, -5, 'I');
	
	Point3d ptSymbol01 = _Pt0 + vzEl * 2 * dSymbolSize;
	Point3d ptSymbol02 = ptSymbol01 - (vxEl - vzEl) * dSymbolSize;
	Point3d ptSymbol03 = ptSymbol01 + (vxEl + vzEl) * dSymbolSize;
	
	PLine plSymbol01(vyEl);
	plSymbol01.addVertex(_Pt0);
	plSymbol01.addVertex(ptSymbol01);
	PLine plSymbol02(vyEl);
	plSymbol02.addVertex(ptSymbol02);
	plSymbol02.addVertex(ptSymbol01);
	plSymbol02.addVertex(ptSymbol03);
	
	dpVisualisationPlan.draw(plSymbol01);
	dpVisualisationPlan.draw(plSymbol02);
	
	dpVisualisationPlan.textHeight(0.1 * dSymbolSize);
	dpVisualisationPlan.draw(identifier, ptSymbol02, vxEl + vyEl, vyEl - vxEl, 1, -1.5);
}

executeMode = 0; // 0 = default, 1 = insert/recalc, 2 = find closest lifting beam




















#End
#BeginThumbnail
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
(5BJT5K9G_]EG
`

















#End