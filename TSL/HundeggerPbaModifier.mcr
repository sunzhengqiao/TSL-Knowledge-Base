#Version 8
#BeginDescription

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 0
#FileState 1
#MajorVersion 0
#MinorVersion 0
#KeyWords 
#BeginContents
if (_bOnMapIO) {
	String strNameTrigger = "special";
	
	reportNotice("\nTsl execution: " +scriptName() + ": " + _kExecuteKey + " " + _bOnMapIO);
	reportNotice("\nMaster panels with name set to: '" + strNameTrigger + "' are modified");
	
	//String strMapLocation = _kShopDrawChildPageCreate + "\\" + "Handle[]";
	//Entity arEnts[] = _Map.getEntityArray(strMapLocation, "defineSetEntities", "han");
	
	// for debugging export map
	_Map.writeToDxxFile(_kPathDwg+"\\"+scriptName()+"_MapI.dxx");
	
	// read from _Map
	Map mpMasterPanels = _Map.getMap("MasterPanel[]");
	Map mpChildPanels = _Map.getMap("ChildPanel[]");
	
	Map mpMasterPanelsNew;
	Map mpChildPanelsNew;
	
	// modify the individual master panels
	for (int i=0; i<mpMasterPanels.length(); i++) 
	{
		if (mpMasterPanels.keyAt(i)!="MasterPanel") {
			reportNotice("\nKey not recognized in MasterPanel[] at index: "+i);
			continue;
		}
		
		Map mpI = mpMasterPanels.getMap(i);
		Entity ent =mpI.getEntity("Handle");
		MasterPanel entMP =  (MasterPanel)ent;
		if (!entMP.bIsValid()) {
			reportNotice("\nCould not read masterpanel in MasterPanel[] at index: "+i);
			continue;
		}
		
		if (entMP.name()==strNameTrigger) {
			mpI.setString("BvxStrategyKey","QualityHsbTest");
		}
		
		mpMasterPanelsNew.appendMap("MasterPanel",mpI);
	}
	
	// do nothing with child panels now
	mpChildPanelsNew = mpChildPanels ;
	
	// write back into _Map
	_Map.setMap("MasterPanel[]", mpMasterPanelsNew);
	_Map.setMap("ChildPanel[]", mpChildPanelsNew);

	
	// for debugging export map
	_Map.writeToDxxFile(_kPathDwg+"\\"+scriptName()+"_MapO.dxx");
	
	reportNotice("\nTsl execution: " +scriptName() + " done\n");
}
#End
#BeginThumbnail

#End
