#Version 8
#BeginDescription
Last modified by: Ronald van Wijngaarden (ronald.van.wijngaarden@hsbcad.com)
12.10.2023  -  version 1.02







Version 1.3 12-10-2023 Create the propstring sEntryName by default instead of only in the if modes. This prevents the proces which checks for the propstring to stop when calling this tsl from the tsl HSB_G-BeamToSheet with an excutionmode. Ronald van Wijngaarden
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
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

/// <version  value="1.01" date="10.09.2015"></version>

/// <history>
/// AS - 1.00 - 18.06.2013 	- Pilot version
/// AS - 1.01 - 10.09.2015 	- Add material as property to set the converted sheets.
/// RW - 1.02 - 12-10-2023    - Improved Insert CatalogProps
/// </history>

//#Versions
// 1.3 12-10-2023 Create the propstring sEntryName by default instead of only in the if modes. This prevents the proces which checks for the propstring to stop when calling this tsl from the tsl HSB_G-BeamToSheet with an excutionmode. Ronald van Wijngaarden


if( _bOnInsert ){
	eraseInstance();
	return;
}
int arNZoneIndex[] = {
	0,1,2,3,4,5,6,7,8,9,10
};
PropString sEntryName(0, "", T("|Beam code|"));
	
String sFileLocation = _kPathHsbCompany+"\\Abbund";
String sFileName = "HSB-BeamToSheetCatalogue.xml";
String sFullPath = sFileLocation + "\\" + sFileName;



int mode = 0;
if( _Map.hasInt("Mode") )
	mode = _Map.getInt("Mode");

if( mode == 1 ){ // add	
	sEntryName = PropString(0, "", T("|Beam code|"));

	PropInt nZoneIndex(0, arNZoneIndex, T("|Zone index|"));
	PropInt nColorIndex(1, -1, T("|Color index|"));
	PropString sMaterial(1, "", T("|Material|"));
	
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
	
	PropInt nZoneIndex(0, arNZoneIndex, T("|Zone index|"));
	PropInt nColorIndex(1, -1, T("|Color index|"));
	PropString sMaterial(1, "", T("|Material|"));
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
    <lst nm="Version">
      <str nm="Comment" vl="Create the propstring sEntryName by default instead of only in the if modes. This prevents the proces which checks for the propstring to stop when calling this tsl from the tsl HSB_G-BeamToSheet with an excutionmode." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="10/12/2023 11:55:47 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End