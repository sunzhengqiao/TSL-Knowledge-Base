#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@itwindustry.nl)
03.03.2014  -  version 1.00









1.1 22/11/2023 Make sure props are not only declared in if statements Author: Robert Pol
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

/// <version  value="1.00" date="18.06.2013"></version>

/// <history>
/// AS - 1.00 - 18.06.2013 	- Pilot version
// #Versions
//1.1 22/11/2023 Make sure props are not only declared in if statements Author: Robert Pol
/// </history>

if( _bOnInsert ){
	eraseInstance();
	return;
}

String sFileLocation = _kPathHsbCompany+"\\Abbund";
String sFileName = "HSB-ColorBeamsCatalogue.xml";
String sFullPath = sFileLocation + "\\" + sFileName;

PropString sEntryName(0, "", T("|Beam code|"));
PropInt nZoneIndex(0, 0, T("|Zone index|"));
PropInt nColorIndex(1, -1, T("|Color index|"));

int arNZoneIndex[] = {
	0,1,2,3,4,5,6,7,8,9,10
};

int mode = 0;
if( _Map.hasInt("Mode") )
	mode = _Map.getInt("Mode");

if( mode == 1 ){ // add
	sEntryName = PropString(0, "", T("|Beam code|"));
	nZoneIndex = PropInt(0, arNZoneIndex, T("|Zone index|"));
	nColorIndex = PropInt(1, -1, T("|Color index|"));
}
if( mode == 2 ){ // select
	int bMapIsRead = _Map.readFromXmlFile(sFullPath);
	String arSEntryName[0];
	for( int i=0;i<_Map.length();i++ ){
		if( _Map.hasMap(i) )
			arSEntryName.append(_Map.keyAt(i));
	}

	sEntryName = PropString(0, arSEntryName, T("|Beam code|"));
}
if( mode == 3 ){ // edit
	sEntryName = PropString(0, "", T("|Beam code|"));
	sEntryName.setReadOnly(true);
	nZoneIndex = PropInt(0, arNZoneIndex, T("|Zone index|"));
	nColorIndex = PropInt(1, -1, T("|Color index|"));
}







#End
#BeginThumbnail



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
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Make sure props are not only declared in if statements" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="11/22/2023 8:26:26 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End