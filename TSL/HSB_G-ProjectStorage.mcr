#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@itwindustry.nl)
14.05.2013  -  version 1.00


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// Tsl to store one or more elements
/// </summary>

/// <insert>
/// -
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.00" date="14.05.2013"></version>

/// <history>
/// AS - 1.00 - 14.05.2013 - 	Pilot version
/// </hsitory>

Unit (1,"mm");

String arSInsertType[] = {
	T("|Select entire project|"),
	T("|Select floor level in floor level list|"),
	T("|Select current floor level|"),
	T("|Select elements in drawing|")
};

PropString sSeperator01(0, "", T("|Selection|"));
sSeperator01.setReadOnly(true);
PropString sInsertType(1, arSInsertType, "     "+T("|Entities to export|"),3);

PropString sSeperator02(2, "", T("|Exporter|"));
sSeperator02.setReadOnly(true);
PropString strExportGroup(3, ModelMap().exporterGroups(), "     "+T("|Run exporter group|"));


String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_G-ProjectStorage");
if( _bOnDbCreated && arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

if( _bOnInsert ){
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();
}

int nInsertType = arSInsertType.find(sInsertType, 3);
sInsertType.setReadOnly(true);

String arSNameFloorGroup[] = {""};
Group arFloorGroup[0];
Group arAllGroups[] = Group().allExistingGroups();
for( int i=0;i<arAllGroups.length();i++ ){
	Group grp = arAllGroups[i];
	if( grp.namePart(2) == "" && grp.namePart(1) != ""){
		arSNameFloorGroup.append(grp.name());
		arFloorGroup.append(grp);
	}
}
PropString sNameFloorGroup(2, arSNameFloorGroup, "     "+"|Floorgroup|",0);
if( nInsertType != 1 )
	sNameFloorGroup.setReadOnly(true);

String groupNames[0];

if( _bOnInsert ){
	if( (_kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1) && nInsertType == 1 )
		showDialog(); 
	
	Entity arEntSelected[0];
	if( nInsertType == 0 ){//Select entire project
		// Do nothing. Empty list of floorgroups means export entire drawing.
	}
	else if( nInsertType == 1 ){//Select floor level in floor level list
		Group grpFloor = arFloorGroup[arSNameFloorGroup.find(sNameFloorGroup,1) - 1];
		groupNames.append(grpFloor.name());
	}
	else if( nInsertType == 2 ){//Select current group
		Group grpCurrent = _kCurrentGroup;
		if( grpCurrent.namePart(2) == "" && grpCurrent.namePart(1) != "" )
			groupNames.append(grpCurrent.name());
	}
	else{
		PrEntity ssE(T("|Select one or more elements to export|"), Element());
		if( ssE.go() )
			arEntSelected.append(ssE.set());
	}
	for( int i=0;i<arEntSelected.length();i++ ){
		Entity ent = arEntSelected[i];
		Element el = (Element)ent;
		Group grpElement = el.elementGroup();
		
		if( el.bIsValid() ){	
			Entity arEntEl[] = grpElement.collectEntities(true, Entity(), _kModelSpace);
			_Entity.append(arEntEl);
		}
	}
	
	return;
}

Entity ents[0];
for(int i=0;i<_Entity.length();i++)
{
	Entity entCurr=_Entity[i];
	if(entCurr.bIsValid())
	{
		ents.append(entCurr);
	}
}
reportMessage (T("\n|Number of entities selected:| ") + _Entity.length()+"\n");

// set some export flags
ModelMapComposeSettings mmFlags;
mmFlags.addSolidInfo(TRUE); // default FALSE
mmFlags.addAnalysedToolInfo(TRUE); // default FALSE
mmFlags.addElemToolInfo(TRUE); // default FALSE
mmFlags.addConstructionToolInfo(TRUE); // default FALSE
mmFlags.addHardwareInfo(TRUE); // default FALSE
mmFlags.addRoofplanesAboveWallsAndRoofSectionsForRoofs(TRUE); // default FALSE
mmFlags.addCollectionDefinitions(TRUE); // default FALSE

String strDestinationFolder = _kPathPersonalTemp;

Map mpProjectInfoOverwrite;
int bOk = false;
if( ents.length() > 0 ){
	bOk = ModelMap().callExporter(mmFlags, mpProjectInfoOverwrite, ents, strExportGroup, strDestinationFolder);
}
else if( groupNames.length() > 0 || nInsertType == 0 ){ // export floor groups.
	bOk = ModelMap().callExporter(mmFlags, mpProjectInfoOverwrite, groupNames, strExportGroup, strDestinationFolder);
}

if (!bOk)
	reportMessage("\nTsl::callExporter failed.");

eraseInstance();
return;






#End
#BeginThumbnail



#End
