#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
24.12.2015  -  version 1.02







#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// 
/// </summary>

/// <insert>
/// 
/// </insert>

/// <remark Lang=en>
/// .
/// </remark>

/// <version  value="1.02" date="24.12.2015"></version>

/// <history>
/// AS - 1.00 - 03.02.2011 	- Pilot version
/// AS - 1.01 - 22.09.2014 	- Use custom catalogs if sent through map. Add rename option.
/// AS - 1.02 - 24.12.2015 	- Read catalog from new path, if available.
/// </history>

if( _bOnInsert ){
	eraseInstance();
	return;
}

String sFileLocation = _kPathHsbCompany+"\\Abbund";
String sFileName = "HSB-ElementDefinitionCatalog.xml";
if (_Map.hasString("CatalogName")) 
	sFileName = _Map.getString("CatalogName") + ".xml";
String sFullPath = sFileLocation + "\\" + sFileName;
if (findFile(sFullPath) == "") { // Check old location.
	String sOldFileLocation = _kPathHsbCompany+"\\Content\\Dutch\\Element";
	String sOldFullPath = sOldFileLocation + "\\" + sFileName + ".xml";
	if (findFile(sOldFullPath) != "") {
		sFileLocation = sOldFileLocation;
		sFullPath = sOldFullPath;
	}
}

int mode = 0;
if( _Map.hasInt("Mode") )
	mode = _Map.getInt("Mode");

if( mode == 1 ){ // add
	PropString sType(0, "", T("|Type|"));
	PropString sSubType(1, "" , T("|SubType|"));
	PropString sZone05(2, "", T("|Zone 5|"));
	PropString sZone04(3, "", T("|Zone 4|"));
	PropString sZone03(4, "", T("|Zone 3|"));
	PropString sZone02(5, "", T("|Zone 2|"));
	PropString sZone01(6, "", T("|Zone 1|"));
	PropString sOnTopOfZone00(7, "", T("|On top of Zone 00|"));
	PropString sZone00(8, "", T("|Zone 0|"));
	PropString sAtTheBackOfZone00(9, "", T("|At the back of Zone 00|"));
	PropString sZone06(10, "", T("|Zone 6|"));
	PropString sZone07(11, "", T("|Zone 7|"));
	PropString sZone08(12, "", T("|Zone 8|"));
	PropString sZone09(13, "", T("|Zone 9|"));
	PropString sZone10(14, "", T("|Zone 10|"));
}
if( mode == 2 ){ // select
	int bMapIsRead = _Map.readFromXmlFile(sFullPath);
	String arSEntryName[0];
	for( int i=0;i<_Map.length();i++ ){
		if( _Map.hasMap(i) )
			arSEntryName.append(_Map.keyAt(i));
	}
	
	PropString sEntryName(0, arSEntryName, T("|Type-SubType|"));
}
if( mode == 3 ){ // edit
	PropString sEntryName(0, "", T("|Type-SubType|"));
	sEntryName.setReadOnly(true);
	PropString sZone05(1, "", T("|Zone 5|"));
	PropString sZone04(2, "", T("|Zone 4|"));
	PropString sZone03(3, "", T("|Zone 3|"));
	PropString sZone02(4, "", T("|Zone 2|"));
	PropString sZone01(5, "", T("|Zone 1|"));
	PropString sOnTopOfZone00(6, "", T("|On top of Zone 00|"));
	PropString sZone00(7, "", T("|Zone 0|"));
	PropString sAtTheBackOfZone00(8, "", T("|At the back of Zone 00|"));
	PropString sZone06(9, "", T("|Zone 6|"));
	PropString sZone07(10, "", T("|Zone 7|"));
	PropString sZone08(11, "", T("|Zone 8|"));
	PropString sZone09(12, "", T("|Zone 9|"));
	PropString sZone10(13, "", T("|Zone 10|"));
}
if( mode == 4 ){ // rename
	PropString sEntryName(0, "", T("|Type-SubType|"));
	sEntryName.setReadOnly(true);
	
	PropString sType(1, "", T("|Type|"));
	PropString sSubType(2, "" , T("|SubType|"));
}



#End
#BeginThumbnail



#End