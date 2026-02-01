#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@itwindustry.nl)
03.03.2014  -  version 1.02









#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This changes the properties of beams/sheets based on a ruleset
/// </summary>

/// <insert>
/// Select a set of elements
/// </insert>

/// <remark Lang=en>
/// .
/// </remark>

/// <version  value="1.02" date="03.03.2014"></version>

/// <history>
/// AS - 1.00 - 25.09.2013 	- Pilot version
/// AS - 1.01 - 09.10.2013 	- TSL can now be attached to element definition.
/// AS - 1.02 - 03.03.2014 	- TSL now works with a catalogue.
/// </history>

double dEps = U(0.01, "mm");

String sFileLocation = _kPathHsbCompany+"\\Abbund";
String sFileName = "HSB-ColorBeamsCatalogue.xml";
String sFullPath = sFileLocation + "\\" + sFileName;

Map mapBeamCodes;
int bMapIsRead = mapBeamCodes.readFromXmlFile(sFullPath);
if( !bMapIsRead ){
	reportNotice(
		TN("|No catalog found!|") + 
		TN("|Please make sure the hsbCompany is set.|") +
		TN("\n|NOTE: The catalogue can be created, edited and visualized with the tsl| HSB_G-ColorBeamsCatalogue")
	);
	eraseInstance();
	return;
}
String arSBmCode[0];
int arNZoneIndexBmCode[0];
int arNColorBmCode[0];

for( int i=0;i<mapBeamCodes.length();i++ ){
	if( mapBeamCodes.hasMap(i) ){
		Map mapEntry = mapBeamCodes.getMap(i);
		
		arSBmCode.append(mapEntry.getMapKey());
		arNZoneIndexBmCode.append(mapEntry.getInt("Zone"));
		arNColorBmCode.append(mapEntry.getInt("Color"));
	}
}

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

//Insert
if( _bOnInsert ){
	//Erase after 1 cycle
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}

	//Select beam(s) and insertion point
	PrEntity ssE(T("|Select a set of elements|"), Element());
	if (ssE.go()) {
		Element arSelectedElements[] = ssE.elementSet();
		
		//insertion point
		String strScriptName = "HSB_E-ColorBeams"; // name of the script
		Vector3d vecUcsX(1,0,0);
		Vector3d vecUcsY(0,1,0);
		Beam lstBeams[0];
		Entity lstEntities[1];
		
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		Map mapTsl;
		mapTsl.setInt("MasterToSatellite", true);
		setCatalogFromPropValues("MasterToSatellite");
		mapTsl.setInt("ManualInsert", true);
		
		for( int i=0;i<arSelectedElements.length();i++ ){
			Element el = arSelectedElements[i];
			if( !el.bIsValid() ){
				continue;
			}
			lstEntities[0] = el;
			
			TslInst tsl;
			tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
		}
	}
	
	eraseInstance();
	return;
}

// set properties from master
if( _Map.hasInt("MasterToSatellite") ){
	int bMasterToSatellite = _Map.getInt("MasterToSatellite");
	if( bMasterToSatellite ){
		int bPropertiesSet = _ThisInst.setPropValuesFromCatalog("MasterToSatellite");
		_Map.removeAt("MasterToSatellite", TRUE);
	}
}
int bManualInsert = false;
if( _Map.hasInt("ManualInsert") ){
	bManualInsert = _Map.getInt("ManualInsert");
	_Map.removeAt("ManualInsert", true);
}

// check if there is a valid element present
if( _Entity.length() == 0 ){
	eraseInstance();
	return;
}

// get selected element
Element el = _Element[0];
if( !el.bIsValid() ){
	eraseInstance();
	return;
}

Beam arBm[] = el.beam();
for( int i=0;i<arBm.length();i++ ){
	Beam bm = arBm[i];
	
	String sBmCode = bm.beamCode().token(0);
	sBmCode = sBmCode.trimLeft();
	sBmCode = sBmCode.trimRight();
		
	// change the color and zone-index if the beamcode is found in the list.
	int nBmCodeIndex = arSBmCode.find(sBmCode);
	if( nBmCodeIndex == -1 )
		continue;
	
	int nColor = arNColorBmCode[nBmCodeIndex];
	bm.setColor(nColor);
	int nZoneIndex = arNZoneIndexBmCode[nBmCodeIndex];
	bm.assignToElementGroup(el, true, nZoneIndex, 'Z');
}

if (_bOnElementConstructed || bManualInsert)
	eraseInstance();





#End
#BeginThumbnail




#End
