#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
05.11.2014  -  version 1.02










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
/// Select a position
/// </insert>

/// <remark Lang=en>
/// .
/// </remark>

/// <version  value="1.02" date="05.11.2014"></version>

/// <history>
/// AS - 1.00 - 18.06.2013 - Pilot version
/// AS - 1.01 - 28.03.2014 - Add name
/// AS - 1.02 - 05.11.2014 - Add Id. (FogBugzId 467)
/// </history>

String arSChars[] = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"};
String arSAvailableId[0];
arSAvailableId.append(arSChars);
for (int i=0;i<arSChars.length();i++)
	for( int j=0;j<arSChars.length();j++)
		arSAvailableId.append(arSChars[i]+arSChars[j]);

String sFileLocation = _kPathHsbCompany+"\\Abbund";
String sFileName = "HSB-InstallationTypeCatalogue.xml";
String sFullPath = sFileLocation + "\\" + sFileName;

PropDouble dTxtHeight(0, U(50), T("|Text size|"));
PropString sDimStyle(0, _DimStyles, T("|Dimension style|"));

String strScriptName = "HSB_G-InstallationTypeCatalogueProps";
Beam lstBeams[0];
Entity lstEntities[0];
Point3d lstPoints[] = {_PtW};

int lstPropInt[0];
double lstPropDouble[0];
String lstPropString[0];

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
	_Pt0 = getPoint(T("|Select a  position|"));
		
	int bMapIsRead = _Map.readFromXmlFile(sFullPath);

	if( _kExecuteKey == "" )
		showDialog();
		
	return;		
}

//Add entries to XML catalogue
String sAddEntry = T("|Add an entry|");
addRecalcTrigger(_kContext, sAddEntry );
if( _kExecuteKey==sAddEntry ){
	int bMapIsRead = _Map.readFromXmlFile(sFullPath);
	
	Map mapTsl;
	mapTsl.setInt("Mode", 1);
	TslInst tsl;
	tsl.dbCreate(strScriptName, _XW, _YW, lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
	tsl.showDialog();
	String sEntryName =  tsl.propString(0);
	int nColorIndex = tsl.propInt(0);
	tsl.dbErase();
	
	//Add entry
	Map mapEntry;
	mapEntry.setString("Type", sEntryName);
	mapEntry.setInt("Color", nColorIndex);
	
	String sNewId = "A";
	for (int i=0;i<arSAvailableId.length();i++) {
		String sAvailableId = arSAvailableId[i];
		if (!_Map.hasMap(sAvailableId)) {
			sNewId = sAvailableId;
			break;
		}
	}
	
	if( _Map.hasMap(sNewId) ){
		reportWarning(TN("|The calalogue already contains an entry with this key.|")+T("|Use the edit option to adjust this entry.|")); 
	}
	else{
		
		Entity arEntPLine[0];
		PrEntity ssE(T("|Select a set of polylines to create a symbol|"), EntPLine());
		if (ssE.go())
			arEntPLine = ssE.set();
			
		Point3d ptReference = getPoint(T("|Select a reference point for the symbol|"));
		CoordSys csToWorldOrg;
		csToWorldOrg.setToAlignCoordSys(ptReference, _XU, _YU, _ZU, _PtW, _XW, _YW, _ZW);
	
		for (int i=0;i<arEntPLine.length();i++) {
			EntPLine entPLine = (EntPLine)arEntPLine[i];
			if (!entPLine.bIsValid())
				continue;
			PLine pl = entPLine.getPLine();
			pl.transformBy(csToWorldOrg);

			mapEntry.appendPLine("PLine", pl, _kAbsolute);
		}
		
		_Map.setMap(sNewId, mapEntry);
		_Map.moveLastTo(arSAvailableId.find(sNewId,0));
	
		//Write XML catalogue
		int bMapIsWritten = _Map.writeToXmlFile(sFullPath);
	}
}

String sEditEntry = T("|Edit an entry|");
addRecalcTrigger(_kContext, sEditEntry );
String sRemoveEntry = T("|Remove an entry|");
addRecalcTrigger(_kContext, sRemoveEntry );
if( _kExecuteKey==sEditEntry || _kExecuteKey==sRemoveEntry ){
	int bMapIsRead = _Map.readFromXmlFile(sFullPath);
	
	Map arEntryMap[0];
	String arSId[0];
//	String arSEntryName[0];
	for( int i=0;i<_Map.length();i++ ){
		if( _Map.hasMap(i) ){
			Map map = _Map.getMap(i);
			arEntryMap.append(map);
			arSId.append(map.getMapKey());
//			arSEntryName.append(map.getString("Type"));
		}
	}
	
	Map mapTslSelect;
	mapTslSelect.setInt("Mode", 2);
	TslInst tslSelect;
	tslSelect.dbCreate(strScriptName, _XW, _YW, lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTslSelect);
	tslSelect.showDialog();

	String sIdAndEntryName =  tslSelect.propString(0);	
	tslSelect.dbErase();
	
	String sId = sIdAndEntryName.token(0, "/");
	String sEntryName = sIdAndEntryName.token(1, "/");
	
	int entryIndex = arSId.find(sId);
	if (entryIndex == -1) {
		eraseInstance();
		return;
	}
		
	Map mapEntryToEdit = arEntryMap[entryIndex];
	
	if( _kExecuteKey==sRemoveEntry ){//REMOVE
		_Map.removeAt(mapEntryToEdit.getMapKey(), true);
	}
	else{//EDIT	
		Map mapTslEdit;
		mapTslEdit.setInt("Mode", 3);
		
		TslInst tslEdit;
		lstPropString.setLength(0);
		lstPropString.append(sId);
		lstPropString.append(sEntryName);
				
		lstPropInt.setLength(0);
		lstPropInt.append(mapEntryToEdit.getInt("Color"));
	
		tslEdit.dbCreate(strScriptName, _XW, _YW, lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTslEdit);
		tslEdit.showDialog();
		
		int nColorIndex = tslEdit.propInt(0);
	
		tslEdit.dbErase();
	
		//Add edited entry
		Map mapEntry;
		
		mapEntry.setString("Type", sEntryName);
		mapEntry.setInt("Color", nColorIndex);
		Entity arEntPLine[0];
		PrEntity ssE(T("|Select a set of polylines to create a symbol|"), EntPLine());
		if (ssE.go())
			arEntPLine = ssE.set();
		Point3d ptReference = getPoint(T("|Select a reference point for the symbol|"));
		CoordSys csToWorldOrg;
		csToWorldOrg.setToAlignCoordSys(ptReference, _XU, _YU, _ZU, _PtW, _XW, _YW, _ZW);
		
		for (int i=0;i<arEntPLine.length();i++) {
			EntPLine entPLine = (EntPLine)arEntPLine[i];
			if (!entPLine.bIsValid())
				continue;
			PLine pl = entPLine.getPLine();
			pl.transformBy(csToWorldOrg);
			
			mapEntry.appendPLine("PLine", pl, _kAbsolute);
		}

		
		_Map.setMap(sId, mapEntry);
	}

	//Write XML catalogue
	int bMapIsWritten = _Map.writeToXmlFile(sFullPath);	
}

//Display this tsl
Display dpHeader(nColorHeader);
dpHeader.dimStyle(sDimStyle);
dpHeader.textHeight(dTxtHeight);

Display dpContent(nColorContent);
dpContent.dimStyle(sDimStyle);
dpContent.textHeight(dTxtHeight);


Vector3d vx = _XW;
Vector3d vy = _YW;
Vector3d vz = _ZW;

double dColumnWidth = 10 * dTxtHeight;
double dRowHeight = 2 * dTxtHeight;
Point3d ptRow = _Pt0 - vy * .5 * dRowHeight;
Point3d ptColumn = ptRow;
dpHeader.draw("INSTALLATION TYPE", ptColumn, vx, vy, 1, 3);
dpHeader.draw("ID", ptColumn, vx, vy, 1, 0);
ptColumn += vx * dColumnWidth;
dpHeader.draw("TYPE", ptColumn, vx, vy, 1, 0);
ptColumn += vx * dColumnWidth;
dpHeader.draw("SYMBOL", ptColumn, vx, vy, 1, 0);
ptColumn += vx * dColumnWidth;
dpHeader.draw("COLOR", ptColumn, vx, vy, 1, 0);
ptColumn += vx * dColumnWidth;

ptRow -= vy * dRowHeight;

for( int i=0;i<_Map.length();i++ ){
	if( !_Map.hasMap(i) )
		continue;
	ptColumn = ptRow;
	
	Map mapEntry = _Map.getMap(i);
	String sId = mapEntry.getMapKey();
	String sInstallationType = mapEntry.getString("Type");
	PLine arPlSymbol[0];
	for (int j=0;j<mapEntry.length();j++) {
		if (!mapEntry.hasPLine(j) || mapEntry.keyAt(j) != "PLine")
			continue;
		arPlSymbol.append(mapEntry.getPLine(j));
	}
	int nColorIndex = mapEntry.getInt("Color");
	
	dpContent.draw(sId, ptColumn, vx, vy, 1, 0);
	ptColumn += vx * dColumnWidth;
	dpContent.draw(sInstallationType, ptColumn, vx, vy, 1, 0);
	ptColumn += vx * dColumnWidth;
	for (int j=0;j<arPlSymbol.length();j++) {
		PLine plSymbol = arPlSymbol[j];
		plSymbol.transformBy(ptColumn - _PtW);
		dpContent.draw(plSymbol);
	}
	ptColumn += vx * dColumnWidth;
	dpContent.draw(nColorIndex, ptColumn, vx, vy, 1, 0);
	ptColumn += vx * dColumnWidth;

	ptRow -= vy * dRowHeight;
}








#End
#BeginThumbnail




#End