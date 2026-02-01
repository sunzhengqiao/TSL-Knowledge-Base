#Version 8
#BeginDescription

0.12 6/26/2023 Added file check for FastenerManager cc

0.14 1/24/2025 Revised path to FastenerManager.dll cc
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 0
#MinorVersion 14
#KeyWords 
#BeginContents



if(_bOnInsert)
{ 
	String stDllPath = _kPathHsbInstall + "\\Utilities\\FastenerManager\\FastenerManager.dll";
	String fileCheck = findFile(stDllPath);
	if(fileCheck.length() == 0)
	{ 
		reportError("Could not find file: " + stDllPath);
		return;
	}
	
	String stClass = "FastenerManager.TslConnector";
	callDotNetFunction2(stDllPath, stClass, "ShowFastenerManager");
	
//	mpFasteners = callDotNetFunction2(stDllPath, stClass, "ShowFastenerSelectorDialog");
//		_Map.setMap("mpFasteners", mpFasteners);

	eraseInstance();
	return;
}


#End
#BeginThumbnail


#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="0.03937008" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Revised path to FastenerManager.dll" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="14" />
      <str nm="Date" vl="1/24/2025 7:22:25 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Added file check for FastenerManager" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="12" />
      <str nm="Date" vl="6/26/2023 8:40:52 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End