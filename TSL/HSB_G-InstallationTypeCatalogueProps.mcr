#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@itwindustry.nl)
05.11.2014  -  version 1.01








#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// 
/// </summary>

/// <insert>
/// Select a position
/// </insert>

/// <remark Lang=en>
/// .
/// </remark>

/// <version  value="1.01" date="05.11.2014"></version>

/// <history>
/// AS - 1.00 - 17.06.2014 	- Pilot version
/// AS - 1.01 - 05.11.2014 - Add Id. (FogBugzId 467)
/// </history>

if( _bOnInsert ){
	eraseInstance();
	return;
}

String sFileLocation = _kPathHsbCompany+"\\Abbund";
String sFileName = "HSB-InstallationTypeCatalogue.xml";
String sFullPath = sFileLocation + "\\" + sFileName;

int mode = 0;
if( _Map.hasInt("Mode") )
	mode = _Map.getInt("Mode");

if( mode == 1 ){ // add
	PropString sEntryName(0, "", T("|Installation type|"));
	PropInt nColorIndex(0, -1, T("|Color index|"));
}
if( mode == 2 ){ // select
	int bMapIsRead = _Map.readFromXmlFile(sFullPath);
	String arSEntryName[0];
	for( int i=0;i<_Map.length();i++ ){
		if( _Map.hasMap(i) ){
			Map map = _Map.getMap(i);
			arSEntryName.append(map.getMapKey() + "/" + map.getString("Type"));
		}
	}
	
	PropString sEntryName(0, arSEntryName, T("|Installation type|"));
}
if( mode == 3 ){ // edit
	PropString sId(0, "", T("|Id|"));
	sId.setReadOnly(true);
	PropString sEntryName(1, "", T("|Installation type|"));
	PropInt nColorIndex(0, -1, T("|Color index|"));
}






#End
#BeginThumbnail



#End