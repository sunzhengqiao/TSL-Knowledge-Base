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

String sFileLocation = _kPathHsbCompany+"\\Abbund";
String sFileName = "HSB-StockBeamCatalogue.dxx";
String sFullPath = sFileLocation + "\\" + sFileName;

PropDouble dTxtHeight(0, U(50), T("|Text size|"));
PropString sDimStyle(0, _DimStyles, T("|Dimension style|"));

String strScriptName = "HSB_G-StockBeamCatalogueProps";
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
		
	int bMapIsRead = _Map.readFromDxxFile(sFullPath);

	if( _kExecuteKey == "" )
		showDialog();
		
	return;		
}

//Add entries to DXX catalogue
String sAddEntry = T("|Add an entry|");
addRecalcTrigger(_kContext, sAddEntry );
if( _kExecuteKey==sAddEntry ){
	int bMapIsRead = _Map.readFromDxxFile(sFullPath);
	
	Map mapTsl;
	mapTsl.setInt("Mode", 1);
	TslInst tsl;
	tsl.dbCreate(strScriptName, _XW, _YW, lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
	tsl.showDialog();
	
	double width = tsl.propDouble(0);
	double height = tsl.propDouble(1);
	
	String sEntryName =  String().formatUnit(width, 2, 0) + " x " + String().formatUnit(height, 2, 0);
		
	String sList = tsl.propString(0) + ";";
	sList.makeUpper();
	double lengths[0];
	Map mapLengths;
	int nTokenIndex = 0; 
	int nListIndex = 0;
	while (nListIndex < (sList.length() - 1)) {
		String sListItem = sList.token(nTokenIndex);
		nTokenIndex++;
		if (sListItem.length() == 0) {
			nListIndex++;
			continue;
		}
		nListIndex = sList.find(sListItem,0);
		sListItem.trimLeft();
		sListItem.trimRight();
		
		double length = sListItem.atof();
		if (lengths.find(length) == -1){
			lengths.append(length);
			mapLengths.appendDouble("Length", length);
		}
	}
	
	tsl.dbErase();
	
	//Add entry
	Map mapEntry;
	mapEntry.setDouble("Width", width);
	mapEntry.setDouble("Height", height);
	mapEntry.setMap("Length[]", mapLengths);
		
	if( _Map.hasMap(sEntryName) ){
		reportWarning(TN("|The calalogue already contains an entry with this key.|")+T("|Use the edit option to adjust this entry.|")); 
	}
	else{
		_Map.setMap(sEntryName, mapEntry);
	
		//Write DXX catalogue
		int bMapIsWritten = _Map.writeToDxxFile(sFullPath);
	}
}

String sEditEntry = T("|Edit an entry|");
addRecalcTrigger(_kContext, sEditEntry );
String sRemoveEntry = T("|Remove an entry|");
addRecalcTrigger(_kContext, sRemoveEntry );
if( _kExecuteKey==sEditEntry || _kExecuteKey==sRemoveEntry ){
	int bMapIsRead = _Map.readFromDxxFile(sFullPath);
	
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
	TslInst tslSelect;
	tslSelect.dbCreate(strScriptName, _XW, _YW, lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTslSelect);
	tslSelect.showDialog();

	String sEntryName =  tslSelect.propString(0);
	
	tslSelect.dbErase();
	
	int entryIndex = arSEntryName.find(sEntryName);
	Map mapEntryToEdit = arEntryMap[entryIndex];
	
	
	if( _kExecuteKey==sRemoveEntry ){//REMOVE
		_Map.removeAt(mapEntryToEdit.getMapKey(), true);
	}
	else{//EDIT	
		Map mapTslEdit;
		mapTslEdit.setInt("Mode", 3);
		
		TslInst tslEdit;
		lstPropString.setLength(0);
		lstPropString.append(sEntryName);
				
		String lengthsToEdit;
		Map mapLengthsToEdit = mapEntryToEdit.getMap("Length[]");
		for (int m=0;m<mapLengthsToEdit.length();m++)
			lengthsToEdit += (String().formatUnit(mapLengthsToEdit.getDouble(m), 2, 0) + ";");
		lstPropString.append(lengthsToEdit);
	
		tslEdit.dbCreate(strScriptName, _XW, _YW, lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTslEdit);
		tslEdit.showDialog();
		
		String sList = tslEdit.propString(1) + ";";
		sList.makeUpper();
		Map mapLengths;
		double lengths[0];
		int nTokenIndex = 0; 
		int nListIndex = 0;
		while (nListIndex < (sList.length() - 1)) {
			String sListItem = sList.token(nTokenIndex);
			nTokenIndex++;
			if (sListItem.length() == 0) {
				nListIndex++;
				continue;
			}
			nListIndex = sList.find(sListItem,0);
			sListItem.trimLeft();
			sListItem.trimRight();
			
			double length = sListItem.atof();
			if (lengths.find(length) == -1)
				mapLengths.appendDouble("Length", length);
		}
		
		tslEdit.dbErase();
		
		//Add entry
		Map mapEntry;
		mapEntry.setDouble("Width", mapEntryToEdit.getDouble("Width"));
		mapEntry.setDouble("Height", mapEntryToEdit.getDouble("Height"));
		mapEntry.setMap("Length[]", mapLengths);
		
		_Map.setMap(sEntryName, mapEntry);
	}

	//Write DXX catalogue
	int bMapIsWritten = _Map.writeToDxxFile(sFullPath);	
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
dpHeader.draw("STOCK BEAMS", ptColumn, vx, vy, 1, 3);
dpHeader.draw("SECTION", ptColumn, vx, vy, 1, 0);
ptColumn += vx * dColumnWidth;
dpHeader.draw("LENGTHS", ptColumn, vx, vy, 1, 0);
ptColumn += vx * dColumnWidth;

ptRow -= vy * dRowHeight;

for( int i=0;i<_Map.length();i++ ){
	if( !_Map.hasMap(i) )
		continue;
	ptColumn = ptRow;
	
	Map mapEntry = _Map.getMap(i);
	String section = mapEntry.getMapKey();
	
	String lengths;
	Map mapLengths = mapEntry.getMap("Length[]");
	for (int m=0;m<mapLengths.length();m++)
		lengths += (String().formatUnit(mapLengths.getDouble(m), 2, 0) + ";");
	
	dpContent.draw(section, ptColumn, vx, vy, 1, 0);
	ptColumn += vx * dColumnWidth;
	dpContent.draw(lengths, ptColumn, vx, vy, 1, 0);
	ptColumn += vx * dColumnWidth;

	ptRow -= vy * dRowHeight;
}








#End
#BeginThumbnail




#End