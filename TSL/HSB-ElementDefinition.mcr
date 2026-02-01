#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
24.12.2015  -  version 1.04










#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl shows the element definition on layouts. The element definition can be set-up through a catalog.
/// The  key which is used to find the definition in the catalog is a combination of element type and - subtype.
/// The type is different for wall - and roof/floor elements. For walls the code is used. For roof/floor elements the first token ("Sme type information;THE KEY FOR THE DEFINITION") of the type field is used.
/// </summary>

/// <insert>
/// Select a position
/// </insert>

/// <remark Lang=en>
/// The catalog can be managed through HSB-ElementDefinitionCatalog.
/// </remark>

/// <version  value="1.04" date="24.12.2015"></version>

/// <history>
/// AS - 1.00 - 03.02.2011 	- Pilot version
/// AS - 1.01 - 19.06.2013 	- Add extra description and make dispaly of entry name optional.
/// AS - 1.02 - 24.04.2014 	- Use token 1 for roofelements
/// AS - 1.03 - 14.07.2014 	- Make catalog a property
/// AS - 1.04 - 24.12.2015 	- Change location of xml files. Show message for old catalog locations.
/// </history>

int arNYesNo[] = {_kYes, _kNo};
String arSYesNo[] = {T("|Yes|"), T("|No|")};

PropString sSeparatorCatalog(5, "", T("|Catalog|"));
sSeparatorCatalog.setReadOnly(true);
PropString sFileName(4, "HSB-ElementDefinitionCatalog", "     "+T("|Catalog name|"));

PropString sSeparatorDefinition(7, "", T("|Definition|"));
sSeparatorDefinition.setReadOnly(true);
PropString sHeader(1, "TITLE", "     "+T("|Header|"));
PropString sDrawEntryName(2, arSYesNo, "     "+T("|Draw entry name|"));
PropString sExtraDescription(3, "", "     "+T("|Extra description|"));

PropString sSeparatorStyle(6, "", T("|Style|"));
sSeparatorStyle.setReadOnly(true);
PropString sDimStyle(0, _DimStyles, "     "+T("|Dimension style|"));
PropInt nColorHeader(0, 1, "     "+T("|Color header|"));
PropInt nColorContent(1, 7, "     "+T("|Color content|"));

String sFileLocation = _kPathHsbCompany+"\\Abbund";
String sFullPath = sFileLocation + "\\" + sFileName + ".xml";
if (findFile(sFullPath) == "") { // Check old location.
	String sOldFileLocation = _kPathHsbCompany+"\\Content\\Dutch\\Element";
	String sOldFullPath = sOldFileLocation + "\\" + sFileName + ".xml";

	if (findFile(sOldFullPath) != "") {
		reportNotice(
			TN("|The used location for the element definition catalog is no longer supported.|") + 
			TN("|Move your catalog|: ") + sOldFullPath + T(" |to|: ") + sFullPath
		);
		
		sFileLocation = sOldFileLocation;
		sFullPath = sOldFullPath;
	}		
}


if( _bOnDbCreated && _kExecuteKey != "" )
	setPropValuesFromCatalog(_kExecuteKey);

if( _bOnInsert ){
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	_Pt0 = getPoint(T("|Select a position|"));
	_Viewport.append(getViewport(T("|Select a viewport|")));
	
	if( _kExecuteKey == "" )
		showDialog();
		
	return;		
}

int bMapIsRead = _Map.readFromXmlFile(sFullPath);

int bDrawEntryName = arNYesNo[arSYesNo.find(sDrawEntryName,0)];

if( _Viewport.length() == 0 ){
	eraseInstance();
	return;
}
Viewport vp = _Viewport[0];
Element el = vp.element();
if( !el.bIsValid() )
	return;

//Display this tsl
Display dpHeader(nColorHeader);
dpHeader.dimStyle(sDimStyle);
//dpHeader.textHeight(dTxtHeight);

Display dpContent(nColorContent);
dpContent.dimStyle(sDimStyle);
//dpContent.textHeight(dTxtHeight);



Vector3d vx = _XW;
Vector3d vy = _YW;
Vector3d vz = _ZW;

// draw header
double dTxtHeight = dpHeader.textHeightForStyle("ABC", sDimStyle);
double dRowHeight = 2 * dTxtHeight;
Point3d ptRow = _Pt0 - vy * .5 * dRowHeight;
dpHeader.draw(sHeader, ptRow, vx, vy, 1, 0);
ptRow -= vy * dRowHeight;

String sType = el.code();
ElementRoof elRf = (ElementRoof)el;
if( elRf.bIsValid() )
	sType = el.code().token(1);
if( sType.length() == 0 )
	sType = el.code();

String sSubType = el.subType();
String sSearchKey = sType;
if( sSubType != "" )
	sSearchKey += (" - " + sSubType);

if( !_Map.hasMap(sSearchKey) ){
	reportMessage(T("|Definition| ") + sSearchKey + T(" |not found|!"));
	return;
}

Map mapElementDefinition = _Map.getMap(sSearchKey);

String sEntryName = mapElementDefinition.getMapKey();
String sZone00  = mapElementDefinition.getString("ZONE00");
String sZone01  = mapElementDefinition.getString("ZONE01");
String sZone02  = mapElementDefinition.getString("ZONE02");
String sZone03  = mapElementDefinition.getString("ZONE03");
String sZone04  = mapElementDefinition.getString("ZONE04");
String sZone05  = mapElementDefinition.getString("ZONE05");
String sZone06  = mapElementDefinition.getString("ZONE06");
String sZone07  = mapElementDefinition.getString("ZONE07");
String sZone08  = mapElementDefinition.getString("ZONE08");
String sZone09  = mapElementDefinition.getString("ZONE09");
String sZone10  = mapElementDefinition.getString("ZONE10");
String sOnTopOfZone00 = mapElementDefinition.getString("ONTOPOFZONE00");
String sAtTheBackOfZone00 = mapElementDefinition.getString("ATTHEBACKOFZONE00");


if (sExtraDescription.length() > 0) {
	dpHeader.draw(sExtraDescription, ptRow, vx, vy, 1, 0);
	ptRow -= vy * dRowHeight;
}
if (bDrawEntryName) {
	dpContent.draw(sEntryName, ptRow, vx, vy, 1, 0);
	ptRow -= vy * dRowHeight;
}
if( sZone05.length() > 0 ){
	dpContent.draw(sZone05, ptRow, vx, vy, 1, 0);
	ptRow -= vy * dRowHeight;
}
if( sZone04.length() > 0 ){
	dpContent.draw(sZone04, ptRow, vx, vy, 1, 0);
	ptRow -= vy * dRowHeight;
}
if( sZone03.length() > 0 ){
	dpContent.draw(sZone03, ptRow, vx, vy, 1, 0);
	ptRow -= vy * dRowHeight;
}
if( sZone02.length() > 0 ){
	dpContent.draw(sZone02, ptRow, vx, vy, 1, 0);
	ptRow -= vy * dRowHeight;
}
if( sZone01.length() > 0 ){
	dpContent.draw(sZone01, ptRow, vx, vy, 1, 0);
	ptRow -= vy * dRowHeight;
}
if( sOnTopOfZone00.length() > 0 ){
	dpContent.draw(sOnTopOfZone00, ptRow, vx, vy, 1, 0);
	ptRow -= vy * dRowHeight;
}
if( sZone00.length() > 0 ){
	dpContent.draw(sZone00, ptRow, vx, vy, 1, 0);
	ptRow -= vy * dRowHeight;
}
if( sAtTheBackOfZone00.length() > 0 ){
	dpContent.draw(sAtTheBackOfZone00, ptRow, vx, vy, 1, 0);
	ptRow -= vy * dRowHeight;
}
if( sZone06.length() > 0 ){
	dpContent.draw(sZone06, ptRow, vx, vy, 1, 0);
	ptRow -= vy * dRowHeight;
}
if( sZone07.length() > 0 ){
	dpContent.draw(sZone07, ptRow, vx, vy, 1, 0);
	ptRow -= vy * dRowHeight;
}
if( sZone08.length() > 0 ){
	dpContent.draw(sZone08, ptRow, vx, vy, 1, 0);
	ptRow -= vy * dRowHeight;
}
if( sZone09.length() > 0 ){
	dpContent.draw(sZone09, ptRow, vx, vy, 1, 0);
	ptRow -= vy * dRowHeight;
}
if( sZone10.length() > 0 ){
	dpContent.draw(sZone10, ptRow, vx, vy, 1, 0);
}









#End
#BeginThumbnail






#End