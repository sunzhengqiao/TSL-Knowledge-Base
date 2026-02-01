#Version 8
#BeginDescription
Last modified by: Robert Pol (robert.pol@hsbcad.com)
26.09.2017  -  version 2.00





#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 0
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// 
/// </summary>

/// <insert>
/// 
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="2.00" date="29.09.2017"></version>

/// <history>
/// AS - 1.00 - 27.12.2012 -	Pilot version
/// AS - 1.01 - 17.01.2013 -	Input mode added.
/// AS - 1.02 - 22.02.2013 -	Add zone 0 to the list of indexes 
/// AS - 1.03 - 01.03.2013 -	Correct zone 0 bug, accept genbeams io sheets.
/// RP - 2.00 - 26.09.2017 -	Add include and exclude and also add categories
/// </history>

int arNZone[] = {0,1,2,3,4,5,6,7,8,9,10};
String arSInputMode[] = {T("|Beams|/")+T("sheets"), T("|Elements|")};
String excludeOrInclude[] = {T("|Exclude|"), T("|Include|")};

String categories[] = 
{
	T("|Selection|"),
	T("|Filters|"),
	T("|Zone|")
};

PropString sInputMode(1, arSInputMode, T("|Input mode|"));
sInputMode.setCategory(categories[0]);
sInputMode.setDescription(T("|Specify wheter you want to select individual beams/sheets or elements|"));
PropString excludeString(2, excludeOrInclude, T("|Filter mode|"));
excludeString.setCategory(categories[1]);
excludeString.setDescription(T("|Specify wheter you want to include or exclude the beams matching the filtercriteria|"));
PropString sFilterBC(3,"",T("|Filter beams with beamcode|"));
sFilterBC.setCategory(categories[1]);
sFilterBC.setDescription(T("|Specify which beams and sheets you want to filter by specifying a beamcode or a list of beamcodes with semicolon as delimeter|"));
PropString sFilterLabel(4,"",T("|Filter beams and sheets with label|"));
sFilterLabel.setCategory(categories[1]);
sFilterLabel.setDescription(T("|Specify which beams and sheets you want to filter by specifying a label or a list of labels with semicolon as delimeter|"));
PropString sFilterMaterial(5,"",T("|Filter beams and sheets with material|"));
sFilterMaterial.setCategory(categories[1]);
sFilterMaterial.setDescription(T("|Specify which beams and sheets you want to filter by specifying a material or a list of materials with semicolon as delimeter|"));
PropInt nZoneIndexFrom(0, arNZone, T("|From zone|"));
nZoneIndexFrom.setCategory(categories[2]);
nZoneIndexFrom.setDescription(T("|Specify the current zone from the beams and sheets you want to change|"));
PropInt nZoneIndexTo(1, arNZone, T("|To zone|"));
nZoneIndexTo.setCategory(categories[2]);
nZoneIndexTo.setDescription(T("|Specify the zone that the beams and sheets need to get|"));


// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_E-ChangeZoneIndex");
if( arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

if( _bOnInsert ){
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	
	int nInputMode = arSInputMode.find(sInputMode,0);
	
	int nNrOfTslsInserted = 0;
	Element arSelectedElements[0];
	GenBeam arSelectedGenBeam[0];
	int arElementIndex[0];
	
	if( nInputMode == 0 ){ //GenBeam
		PrEntity ssE(T("|Select one or more entities|"), GenBeam());
		if (ssE.go()){
			Entity arSelectedEnt[] = ssE.set();
						
			for( int i=0;i<arSelectedEnt.length();i++ ){
				Entity ent = arSelectedEnt[i];
				GenBeam gBm = (GenBeam)ent;
				if( !gBm.bIsValid() )
					continue;
				
				Element el = gBm.element();
				if( !el.bIsValid() )
					continue;
				
				int nElementIndex = arSelectedElements.find(el);
				if( nElementIndex == -1 ){
					arSelectedElements.append(el);
					nElementIndex = (arSelectedElements.length() - 1);
				}
				
				arSelectedGenBeam.append(gBm);
				arElementIndex.append(nElementIndex);
			}
		}
	}
	else{ //Elements
		PrEntity ssE(T("|Select one or more elements|"), Element());
		if (ssE.go())
			arSelectedElements.append(ssE.elementSet());
	}
	
	//insertion point
	String strScriptName = "HSB_E-ChangeZoneIndex"; // name of the script
	Vector3d vecUcsX(1,0,0);
	Vector3d vecUcsY(0,1,0);
	GenBeam lstGenBeams[0];
	Entity lstEntities[1];
	
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	Map mapTsl;
	mapTsl.setInt("MasterToSatellite", true);
	mapTsl.setInt("ManualInsert", true);
	setCatalogFromPropValues("MasterToSatellite");
	for( int i=0;i<arSelectedElements.length();i++ ){
		Element el = arSelectedElements[i];
		if( !el.bIsValid() ){
			continue;
		}
		lstEntities[0] = el;
		
		TslInst arTsl[] = el.tslInst();
		for( int j=0;j<arTsl.length();j++ ){
			TslInst tsl = arTsl[j];
			if( !tsl.bIsValid() ){
				tsl.dbErase();
				continue;
			}
			
			if( tsl.scriptName() == strScriptName )
				tsl.dbErase();
		}
		
		// Add genbeams (Sheets) if input mode == sheets
		lstGenBeams.setLength(0);
		for( int j=0;j<arElementIndex.length();j++ ){
			int nElementIndex = arElementIndex[j];
			if( i != nElementIndex )
				continue;
			lstGenBeams.append(arSelectedGenBeam[j]);
		}
		
		TslInst tsl;
		tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstGenBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
		nNrOfTslsInserted++;
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
	eraseInstance();
	return;
}
Element el = _Element[0];

int nZnIndexFrom = nZoneIndexFrom;
if( nZnIndexFrom > 5 )
	nZnIndexFrom = 5 - nZnIndexFrom;

int nZnIndexTo = nZoneIndexTo;
if( nZnIndexTo > 5 )
	nZnIndexTo = 5 - nZnIndexTo;
	
int exclude = false;
if (excludeString == T("|Exclude|"))
	exclude = true;

Entity arEntAll[0] ;

GenBeam allGenBeams[] = el.genBeam();

if( _GenBeam.length() > 0 )
	allGenBeams =_GenBeam;

for (int i=0;i<allGenBeams.length();i++) 
{ 
	Entity ent = (Entity)allGenBeams[i];
	int nZnIndex = allGenBeams[i].myZoneIndex();
	if( nZnIndexFrom != nZnIndex )
		continue;
	arEntAll.append(ent); 
}
Entity filteredEntities[0];
Entity filteredEntitiesBeamCode[0];
Entity filteredEntitiesBeamLabel[0];

if (sFilterBC != "" && exclude)
{
	Map filterGenBeamsMap;
	filterGenBeamsMap.setEntityArray(arEntAll, false, "GenBeams", "GenBeams", "GenBeam");
	filterGenBeamsMap.setString("BeamCode[]", sFilterBC);
	filterGenBeamsMap.setInt("Exclude", exclude);
	TslInst().callMapIO("HSB_G-FilterGenBeams", "", filterGenBeamsMap);
	filteredEntitiesBeamCode.append(filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam"));
}
else if (sFilterBC != "")
{ 
	Map filterGenBeamsMap;
	filterGenBeamsMap.setEntityArray(arEntAll, false, "GenBeams", "GenBeams", "GenBeam");
	filterGenBeamsMap.setString("BeamCode[]", sFilterBC);
	filterGenBeamsMap.setInt("Exclude", exclude);
	TslInst().callMapIO("HSB_G-FilterGenBeams", "", filterGenBeamsMap);
	filteredEntities.append(filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam"));
}
else if (exclude)
{
	filteredEntitiesBeamCode = arEntAll;
}

if (sFilterLabel != "" && exclude)
{
	Map filterGenBeamsMap;
	filterGenBeamsMap.setEntityArray(filteredEntitiesBeamCode, false, "GenBeams", "GenBeams", "GenBeam");
	filterGenBeamsMap.setString("Label[]", sFilterLabel);
	filterGenBeamsMap.setInt("Exclude", exclude);
	TslInst().callMapIO("HSB_G-FilterGenBeams", "", filterGenBeamsMap);
	filteredEntitiesBeamLabel.append(filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam"));
}
else if (sFilterLabel != "")
{
	Map filterGenBeamsMap;
	filterGenBeamsMap.setEntityArray(arEntAll, false, "GenBeams", "GenBeams", "GenBeam");
	filterGenBeamsMap.setString("Label[]", sFilterLabel);
	filterGenBeamsMap.setInt("Exclude", exclude);
	TslInst().callMapIO("HSB_G-FilterGenBeams", "", filterGenBeamsMap);
	filteredEntities.append(filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam"));
}
else if (exclude)
{
	filteredEntitiesBeamLabel = filteredEntitiesBeamCode;
}

if (sFilterMaterial != "" && exclude)
{
	Map filterGenBeamsMap;
	filterGenBeamsMap.setEntityArray(filteredEntitiesBeamLabel, false, "GenBeams", "GenBeams", "GenBeam");
	filterGenBeamsMap.setString("Material[]", sFilterMaterial);
	filterGenBeamsMap.setInt("Exclude", exclude);
	TslInst().callMapIO("HSB_G-FilterGenBeams", "", filterGenBeamsMap);
	filteredEntities.append(filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam"));
}
else if (sFilterMaterial != "")
{
	Map filterGenBeamsMap;
	filterGenBeamsMap.setEntityArray(arEntAll, false, "GenBeams", "GenBeams", "GenBeam");
	filterGenBeamsMap.setString("Material[]", sFilterMaterial);
	filterGenBeamsMap.setInt("Exclude", exclude);
	TslInst().callMapIO("HSB_G-FilterGenBeams", "", filterGenBeamsMap);
	filteredEntities.append(filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam"));
}
else if (exclude)
{
	filteredEntities = filteredEntitiesBeamLabel;
}

int nNrOfEntitiesChanged = 0;
for(int i=0;i<filteredEntities.length();i++){
	GenBeam gBm = (GenBeam)filteredEntities[i];
	
	gBm.assignToElementGroup(el, true, nZnIndexTo, 'Z');
	nNrOfEntitiesChanged += 1;
	
}

if( _bOnElementConstructed || bManualInsert ){
	reportMessage(TN("|Zone indexes are changed|! ") + nNrOfEntitiesChanged + T(" |entities changed|."));
	eraseInstance();
}






#End
#BeginThumbnail





#End