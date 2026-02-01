#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
01.12.2015  -  version 1.00








#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
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

/// <version  value="1.00" date="01.12.2015"></version>

/// <history>
/// AS - 1.00 - 01.12.2015 	- Pilot version
/// </history>

if( _bOnInsert ){
	eraseInstance();
	return;
}

String sFileLocation = _kPathHsbCompany+"\\Abbund";
String sFileName = "HSB-StockBeamCatalogue.dxx";
String sFullPath = sFileLocation + "\\" + sFileName;

int mode = 0;
if( _Map.hasInt("Mode") )
	mode = _Map.getInt("Mode");

if( mode == 1 ){ // add
	PropDouble width(0, U(38), T("|Width|"));
	PropDouble height(1, U(89), T("|Height|"));
	PropString lengths(0, "5380; 8380", T("|Lengths|"));
}
if( mode == 2 ){ // select
	int bMapIsRead = _Map.readFromDxxFile(sFullPath);
	String arSEntryName[0];
	for( int i=0;i<_Map.length();i++ ){
		if( _Map.hasMap(i) )
			arSEntryName.append(_Map.keyAt(i));
	}
	
	PropString sEntryName(0, arSEntryName, T("|Section|"));
}
if( mode == 3 ){ // edit
	PropString sEntryName(0, "", T("|Section|"));
	sEntryName.setReadOnly(true);
	PropString lengths(1, "", T("|Lengths|"));
}






#End
#BeginThumbnail



#End