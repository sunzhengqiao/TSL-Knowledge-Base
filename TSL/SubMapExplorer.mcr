#Version 8
#BeginDescription

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 0
#MinorVersion 10
#KeyWords 
#BeginContents


if(_bOnInsert)
{ 
	
	Entity ent = getEntity();
	if(! ent.bIsValid())
	{ 
		eraseInstance();
		return;
	}
	
	String subMaps[] = ent.subMapKeys();
	String subMapXs[] = ent.subMapXKeys();
	String stMapKeys[0];
	
	int iCurrentIndex;
	reportMessage("\n-----------> SubMap Names");
	
	for(int i=0; i<subMaps.length(); i++)
	{
		String mapName = subMaps[i];
		reportMessage("\n(" + iCurrentIndex++ + ") " + mapName) ;	
		stMapKeys.append(mapName);
	}
	
	
	reportMessage("\n\n-----------> SubMapX Names");
	
	for(int i=0; i<subMapXs.length(); i++)
	{
		String mapName = subMapXs[i];
		reportMessage("\n(" + iCurrentIndex++ + ") " + mapName);	
		stMapKeys.append(mapName);
	}
	
	String stMapIndex = getString("Enter Map Number");
	if(stMapIndex == "")
	{ 
		eraseInstance();
		return;
	}
	
	int iMapIndex = stMapIndex.atoi();
	
	int bIsSubMapX = iMapIndex >= subMaps.length();
	
	Map mpView;
	if(iMapIndex < subMaps.length())
	{ 
		mpView = ent.subMap(stMapKeys[iMapIndex]);
	}
	else
	{ 
		mpView = ent.subMapX(stMapKeys[iMapIndex]);
	}
	

	String stMapName = mpView.getMapKey() == "" ? mpView.getMapName() : mpView.getMapKey();
	if (stMapName == "") stMapName = scriptName() + ".mpDebug.dxx";
	String stPath = _kPathDwg + "\\" + stMapName ;
	mpView.writeToDxxFile(stPath);
	String stMapExplorerPath = _kPathHsbInstall + "\\Utilities\\hsbMapExplorer\\hsbMapExplorer.exe";
	spawn_detach("", stMapExplorerPath, "\"" + stPath + "\"", "");				

	
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
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]" />
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End