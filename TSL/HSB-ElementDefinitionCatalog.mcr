#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
24.12.2015  -  version 1.05










#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 5
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl shows manages the element definition catalog. There are context menu option available to add, edit or remove entries. 
/// The name of the catalog can be specified, e.g. to have project specific catalogs.
/// </summary>

/// <insert>
/// 
/// </insert>

/// <remark Lang=en>
/// .
/// </remark>

/// <version  value="1.05" date="24.12.2015"></version>

/// <history>
/// AS - 1.00 - 03.02.2011 	- Pilot version
/// AS - 1.01 - 19.06.2013 	- Corrected text for "Zone 4"
/// AS - 1.02 - 14.07.2014 	- Make catalog a property
/// AS - 1.03 - 22.09.2014 	- Send catalog name as an argument to property tsl
/// AS - 1.04 - 22.09.2014 	- Check if file exists and show catalog title. Add rename option
/// AS - 1.05 - 24.12.2015 	- Catalog is outputted to new location. Read from old location, if available.
/// </history>

String arSRecalcProperties[0];

PropString sSeparatorCatalog(1, "", T("|Catalog|"));
sSeparatorCatalog.setReadOnly(true);
PropString sFileName(2, "HSB-ElementDefinitionCatalog", "     "+T("|Catalog name|"));
arSRecalcProperties.append("     "+T("|Catalog name|"));

PropString sSeparatorStyle(3, "", T("|Style|"));
sSeparatorStyle.setReadOnly(true);
PropString sDimStyle(0, _DimStyles, "     "+T("|Dimension style|"));

//Properties
int nColorContent = 1;
int nColorHeader = 7;

if( _bOnDbCreated && _kExecuteKey != "" )
	setPropValuesFromCatalog(_kExecuteKey);

if( _bOnInsert ){
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	

	if( _kExecuteKey == "" )
		showDialog();
	
	_Pt0 = getPoint(T("|Select a position|"));
	
	return;		
}

String sFileLocation = _kPathHsbCompany+"\\Abbund";
String sFullPath = sFileLocation + "\\" + sFileName + ".xml";

int bMapIsRead;
if (findFile(sFullPath) == "") { // Check old location.
	String sOldFileLocation = _kPathHsbCompany+"\\Content\\Dutch\\Element";
	String sOldFullPath = sOldFileLocation + "\\" + sFileName + ".xml";

	if (findFile(sOldFullPath) != "") {
		reportNotice(
			TN("|The used location for the element definition catalog is no longer supported.|") + 
			TN("|Your catalog will be moved from|: ") + sOldFullPath + T(" |to|: ") + sFullPath
		);
		
		bMapIsRead = _Map.readFromXmlFile(sOldFullPath);
		if (bMapIsRead) {
			int written = _Map.writeToXmlFile(sFullPath);
			if (!written)
				reportNotice(TN("|Cannot write the catalog to|: ") + sFullPath);
		}
	}		
}
else{
	bMapIsRead = _Map.readFromXmlFile(sFullPath);
}
if (!bMapIsRead)
	_Map = Map();



String strScriptName = "HSB-ElementDefinitionCatalogProps";
Beam lstBeams[0];
Entity lstEntities[0];
Point3d lstPoints[] = {_PtW};

int lstPropInt[0];
double lstPropDouble[0];
String lstPropString[0];



//Add entries to XML catalogue
String sAddEntry = T("|Add entry|");
addRecalcTrigger(_kContext, sAddEntry );
if( _kExecuteKey==sAddEntry ){
	int bMapIsRead = _Map.readFromXmlFile(sFullPath);
	Map mapTsl;
	mapTsl.setInt("Mode", 1);
	mapTsl.setString("CatalogName", sFileName);
	TslInst tsl;
	tsl.dbCreate(strScriptName, _XW, _YW, lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
	tsl.showDialog();
	String sEntryName =  tsl.propString(0);
	if( tsl.propString(1).length() > 0 )
		sEntryName += (" - " + tsl.propString(1));
	String sZone05 = tsl.propString(2);
	String sZone04 = tsl.propString(3);
	String sZone03 = tsl.propString(4);
	String sZone02 = tsl.propString(5);	
	String sZone01 = tsl.propString(6);
	String sOnTopOfZone00 = tsl.propString(7);
	String sZone00 = tsl.propString(8);
	String sAtTheBackOfZone00 = tsl.propString(9);	
	String sZone06 = tsl.propString(10);
	String sZone07 = tsl.propString(11);
	String sZone08 = tsl.propString(12);
	String sZone09 = tsl.propString(13);
	String sZone10 = tsl.propString(14);
	
	tsl.dbErase();
	
	//Add entry
	Map mapEntry;
	mapEntry.setString("ZONE05", sZone05);
	mapEntry.setString("ZONE04", sZone04);
	mapEntry.setString("ZONE03", sZone03);
	mapEntry.setString("ZONE02", sZone02);
	mapEntry.setString("ZONE01", sZone01);
	mapEntry.setString("ONTOPOFZONE00", sOnTopOfZone00);
	mapEntry.setString("ZONE00", sZone00);
	mapEntry.setString("ATTHEBACKOFZONE00", sAtTheBackOfZone00);
	mapEntry.setString("ZONE06", sZone06);
	mapEntry.setString("ZONE07", sZone07);
	mapEntry.setString("ZONE08", sZone08);
	mapEntry.setString("ZONE09", sZone09);
	mapEntry.setString("ZONE10", sZone10);
	
	if( _Map.hasMap(sEntryName) ){
		reportWarning(
			TN("|The catalog already contains a definition with this type-subtype|.") + 
			TN("|Please use another type-subtype combination, or edit the existing definition|")
		);
	}
	else{
		_Map.setMap(sEntryName, mapEntry);
	
		//Write DXX file
		int bMapIsWritten = _Map.writeToXmlFile(sFullPath);
	}
}

String sEditEntry = T("|Edit entry|");
addRecalcTrigger(_kContext, sEditEntry );
String sRemoveEntry = T("|Remove entry|");
addRecalcTrigger(_kContext, sRemoveEntry );
String sRenameEntry = T("|Rename entry|");
addRecalcTrigger(_kContext, sRenameEntry );
if( _kExecuteKey==sEditEntry || _kExecuteKey==sRemoveEntry || _kExecuteKey==sRenameEntry){
	int bMapIsRead = _Map.readFromXmlFile(sFullPath);
	Map arEntryMap[0];
	String arSEntryName[0];
	for( int i=0;i<_Map.length();i++ ){
		if( _Map.hasMap(i) ){
			arEntryMap.append(_Map.getMap(i));
			arSEntryName.append(_Map.keyAt(i));
		}
	}
	
	Map mapTslSelect;
	mapTslSelect.setInt("Mode", 2);
	mapTslSelect.setString("CatalogName", sFileName);
	TslInst tslSelect;
	tslSelect.dbCreate(strScriptName, _XW, _YW, lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTslSelect);
	tslSelect.showDialog();

	String sEntryName = tslSelect.propString(0);//mapSelectOut.getString(T("|ArticleNumber|"));
	
	tslSelect.dbErase();
	
	int entryIndex = arSEntryName.find(sEntryName);
	if (entryIndex >= 0 &&  arEntryMap.length() > entryIndex) {
		Map mapEntryToEdit = arEntryMap[entryIndex];
		
		if( _kExecuteKey==sRemoveEntry ){//REMOVE
			_Map.removeAt(mapEntryToEdit.getMapKey(), true);
		}
		else if( _kExecuteKey==sRenameEntry ){//RENAME
			Map mapTslRename;
			mapTslRename.setInt("Mode", 4);
			mapTslRename.setString("CatalogName", sFileName);
			
			TslInst tslRename;
			lstPropString.setLength(0);
			lstPropString.append(sEntryName);
						
			tslRename.dbCreate(strScriptName, _XW, _YW, lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTslRename);
			tslRename.showDialog();
			
			String sType = tslRename.propString(1);
			String sSubType = tslRename.propString(2);
			String sNewEntryName = sType;
			if( sSubType.length() > 0 )
				sNewEntryName += (" - " + sSubType);	
			// Add the map with the new name at the end of the map.
			_Map.setMap(sNewEntryName, mapEntryToEdit);
			// Remove the selected one and put the last entry at its place
			_Map.removeAt(mapEntryToEdit.getMapKey(), false);
		}
		else{//EDIT	
			Map mapTslEdit;
			mapTslEdit.setInt("Mode", 3);
			mapTslEdit.setString("CatalogName", sFileName);
			
			TslInst tslEdit;
			lstPropString.setLength(0);
			lstPropString.append(sEntryName);
			lstPropString.append(mapEntryToEdit.getString("ZONE05"));
			lstPropString.append(mapEntryToEdit.getString("ZONE04"));
			lstPropString.append(mapEntryToEdit.getString("ZONE03"));
			lstPropString.append(mapEntryToEdit.getString("ZONE02"));
			lstPropString.append(mapEntryToEdit.getString("ZONE01"));
			lstPropString.append(mapEntryToEdit.getString("ONTOPOFZONE00"));
			lstPropString.append(mapEntryToEdit.getString("ZONE00"));
			lstPropString.append(mapEntryToEdit.getString("ATTHEBACKOFZONE00"));				
			lstPropString.append(mapEntryToEdit.getString("ZONE06"));
			lstPropString.append(mapEntryToEdit.getString("ZONE07"));
			lstPropString.append(mapEntryToEdit.getString("ZONE08"));
			lstPropString.append(mapEntryToEdit.getString("ZONE09"));
			lstPropString.append(mapEntryToEdit.getString("ZONE10"));
			
			tslEdit.dbCreate(strScriptName, _XW, _YW, lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTslEdit);
			tslEdit.showDialog();
			
			String sZone05 = tslEdit.propString(1);
			String sZone04 = tslEdit.propString(2);
			String sZone03 = tslEdit.propString(3);
			String sZone02 = tslEdit.propString(4);	
			String sZone01 = tslEdit.propString(5);
			String sOnTopOfZone00 = tslEdit.propString(6);
			String sZone00 = tslEdit.propString(7);
			String sAtTheBackOfZone00 = tslEdit.propString(8);	
			String sZone06 = tslEdit.propString(9);
			String sZone07 = tslEdit.propString(10);
			String sZone08 = tslEdit.propString(11);
			String sZone09 = tslEdit.propString(12);
			String sZone10 = tslEdit.propString(13);
	
			tslEdit.dbErase();
		
			//Add edited entry
			Map mapEntry;
			mapEntry.setString("ZONE05", sZone05);
			mapEntry.setString("ZONE04", sZone04);
			mapEntry.setString("ZONE03", sZone03);
			mapEntry.setString("ZONE02", sZone02);
			mapEntry.setString("ZONE01", sZone01);
			mapEntry.setString("ONTOPOFZONE00", sOnTopOfZone00);
			mapEntry.setString("ZONE00", sZone00);
			mapEntry.setString("ATTHEBACKOFZONE00", sAtTheBackOfZone00);
			mapEntry.setString("ZONE06", sZone06);
			mapEntry.setString("ZONE07", sZone07);
			mapEntry.setString("ZONE08", sZone08);
			mapEntry.setString("ZONE09", sZone09);
			mapEntry.setString("ZONE10", sZone10);
			_Map.setMap(sEntryName, mapEntry);
		}
	
		
		//Write XML file
		int bMapIsWritten = _Map.writeToXmlFile(sFullPath);
	}
}

String sClearCatalogEntry = T("|Clear catalog|");
addRecalcTrigger(_kContext, sClearCatalogEntry );
if( _kExecuteKey==sClearCatalogEntry ){
	//Write XML file from empty map
	_Map = Map();
	int bMapIsWritten = _Map.writeToXmlFile(sFullPath);	
}
//Display this tsl
Display dpTitle(nColorHeader);
dpTitle.dimStyle(sDimStyle);
dpTitle.textHeight(2 * dpTitle.textHeightForStyle("hsbCAD", sDimStyle));

Display dpHeader(nColorHeader);
dpHeader.dimStyle(sDimStyle);
//dpHeader.textHeight(dTxtHeight);

Display dpContent(nColorContent);
dpContent.dimStyle(sDimStyle);
//dpContent.textHeight(dTxtHeight);


Vector3d vx = _XW;
Vector3d vy = _YW;
Vector3d vz = _ZW;

double dTxtHeight = dpHeader.textHeightForStyle("hsbCAD", sDimStyle);
double dRowHeight = 2 * dTxtHeight;
Point3d ptRow = _Pt0 - vy * .5 * dRowHeight;
// Draw title
dpTitle.draw(sFileName, ptRow, vx, vy, 1, 0);
ptRow -= vy * 2 * dRowHeight;

Point3d ptColumn = ptRow;
dpHeader.draw("TYPE-SUBTYPE", ptRow, vx, vy, 1, 0);
ptRow -= vy * dRowHeight;
dpHeader.draw("ZONE 05", ptRow, vx, vy, 1, 0);
ptRow -= vy * dRowHeight;
dpHeader.draw("ZONE 04", ptRow, vx, vy, 1, 0);
ptRow -= vy * dRowHeight;
dpHeader.draw("ZONE 03", ptRow, vx, vy, 1, 0);
ptRow -= vy * dRowHeight;
dpHeader.draw("ZONE 02", ptRow, vx, vy, 1, 0);
ptRow -= vy * dRowHeight;
dpHeader.draw("ZONE 01", ptRow, vx, vy, 1, 0);
ptRow -= vy * dRowHeight;
dpHeader.draw("ON TOP OF ZONE 00", ptRow, vx, vy, 1, 0);
ptRow -= vy * dRowHeight;
dpHeader.draw("ZONE 00", ptRow, vx, vy, 1, 0);
ptRow -= vy * dRowHeight;
dpHeader.draw("AT THE BACK OF ZONE 00", ptRow, vx, vy, 1, 0);
ptRow -= vy * dRowHeight;
dpHeader.draw("ZONE 06", ptRow, vx, vy, 1, 0);
ptRow -= vy * dRowHeight;
dpHeader.draw("ZONE 07", ptRow, vx, vy, 1, 0);
ptRow -= vy * dRowHeight;
dpHeader.draw("ZONE 08", ptRow, vx, vy, 1, 0);
ptRow -= vy * dRowHeight;
dpHeader.draw("ZONE 09", ptRow, vx, vy, 1, 0);
ptRow -= vy * dRowHeight;
dpHeader.draw("ZONE 10", ptRow, vx, vy, 1, 0);

double dTxtLength = dpHeader.textLengthForStyle("AT THE BACK OF ZONE 00", sDimStyle);
double dColumnWidth = 1.2 * dTxtLength;

ptColumn += vx * dColumnWidth;

for( int i=0;i<_Map.length();i++ ){
	if( !_Map.hasMap(i) )
		continue;
	ptRow = ptColumn;
	
	Map mapEntry = _Map.getMap(i);
	String sLongestTxt;
	String sEntryName = mapEntry.getMapKey();
	sLongestTxt = sEntryName;
	String sZone05  = mapEntry.getString("ZONE05");
	if( sZone05.length() > sLongestTxt.length() )
		sLongestTxt = sZone05;
	String sZone04  = mapEntry.getString("ZONE04");
	if( sZone04.length() > sLongestTxt.length() )
		sLongestTxt = sZone04;
	String sZone03  = mapEntry.getString("ZONE03");
	if( sZone03.length() > sLongestTxt.length() )
		sLongestTxt = sZone03;
	String sZone02  = mapEntry.getString("ZONE02");
	if( sZone02.length() > sLongestTxt.length() )
		sLongestTxt = sZone02;
	String sZone01  = mapEntry.getString("ZONE01");
	if( sZone01.length() > sLongestTxt.length() )
		sLongestTxt = sZone01;
	String sOnTopOfZone00  = mapEntry.getString("ONTOPOFZONE00");
	if( sOnTopOfZone00.length() > sLongestTxt.length() )
		sLongestTxt = sOnTopOfZone00;
	String sZone00  = mapEntry.getString("ZONE00");
	if( sZone00.length() > sLongestTxt.length() )
		sLongestTxt = sZone00;
	String sAtTheBackOfZone00  = mapEntry.getString("ATTHEBACKOFZONE00");
	if( sAtTheBackOfZone00.length() > sLongestTxt.length() )
		sLongestTxt = sAtTheBackOfZone00;
	String sZone06  = mapEntry.getString("ZONE06");
	if( sZone06.length() > sLongestTxt.length() )
		sLongestTxt = sZone06;
	String sZone07  = mapEntry.getString("ZONE07");
	if( sZone07.length() > sLongestTxt.length() )
		sLongestTxt = sZone07;
	String sZone08  = mapEntry.getString("ZONE08");
	if( sZone08.length() > sLongestTxt.length() )
		sLongestTxt = sZone08;
	String sZone09  = mapEntry.getString("ZONE09");
	if( sZone09.length() > sLongestTxt.length() )
		sLongestTxt = sZone09;
	String sZone10  = mapEntry.getString("ZONE10");
	if( sZone10.length() > sLongestTxt.length() )
		sLongestTxt = sZone10;
	
	dTxtLength = dpContent.textLengthForStyle(sLongestTxt, sDimStyle);
	dColumnWidth = 1.2 * dTxtLength;
	
	dpContent.draw(sEntryName, ptRow, vx, vy, 1, 0);
	ptRow -= vy * dRowHeight;
	dpContent.draw(sZone05, ptRow, vx, vy, 1, 0);
	ptRow -= vy * dRowHeight;
	dpContent.draw(sZone04, ptRow, vx, vy, 1, 0);
	ptRow -= vy * dRowHeight;
	dpContent.draw(sZone03, ptRow, vx, vy, 1, 0);
	ptRow -= vy * dRowHeight;
	dpContent.draw(sZone02, ptRow, vx, vy, 1, 0);
	ptRow -= vy * dRowHeight;
	dpContent.draw(sZone01, ptRow, vx, vy, 1, 0);
	ptRow -= vy * dRowHeight;
	dpContent.draw(sOnTopOfZone00, ptRow, vx, vy, 1, 0);
	ptRow -= vy * dRowHeight;
	dpContent.draw(sZone00, ptRow, vx, vy, 1, 0);
	ptRow -= vy * dRowHeight;
	dpContent.draw(sAtTheBackOfZone00, ptRow, vx, vy, 1, 0);
	ptRow -= vy * dRowHeight;
	dpContent.draw(sZone06, ptRow, vx, vy, 1, 0);
	ptRow -= vy * dRowHeight;
	dpContent.draw(sZone07, ptRow, vx, vy, 1, 0);
	ptRow -= vy * dRowHeight;
	dpContent.draw(sZone08, ptRow, vx, vy, 1, 0);
	ptRow -= vy * dRowHeight;
	dpContent.draw(sZone09, ptRow, vx, vy, 1, 0);
	ptRow -= vy * dRowHeight;
	dpContent.draw(sZone10, ptRow, vx, vy, 1, 0);

	ptColumn += vx * dColumnWidth;
}








#End
#BeginThumbnail





#End