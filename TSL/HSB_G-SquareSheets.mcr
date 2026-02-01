#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
08.12.2016  -  version 1.01
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
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
/// 
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.01" date="08.12.2016"></version>

/// <history>
/// AS - 1.00 - 08.12.2016 -	Pilot version
/// AS - 1.01 - 08.12.2016 -	Add filter support.
/// </history>

String categories[] = 
{
	T("|Filters|"),
	T("|Visualisation|")
};



String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = TslInst().getListOfCatalogNames(filterDefinitionTslName);
filterDefinitions.insertAt(0,"");


PropString sheetFilterDefinition(0, filterDefinitions, T("|Sheet filter|"));
sheetFilterDefinition.setDescription(T("|Filter definition for sheets.|") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));
sheetFilterDefinition.setCategory(categories[0]);



PropString textDimensionStyle(1, _DimStyles, T("|Dimension style|"));
textDimensionStyle.setCategory(categories[1]);
textDimensionStyle.setDescription(T("|Sets the dimension style for the text.|"));

PropInt textColor(0, -1, T("|Text color|"));
textColor.setCategory(categories[1]);
textColor.setDescription(T("|Sets the color for the text.|") + TN("|The font type, font color and font size defined in this dimension style are used by default.|"));

PropDouble fontSize(0, U(-1), T("|Text size|"));
fontSize.setCategory(categories[1]);
fontSize.setDescription(T("|Sets the font size for the text.|") + TN("|The font size defined in the dimension is style is used if the font size is set to zero or less.|")); 


String recalcTriggers[] = {
	T("|Analyse sheets|"),
	T("|Clear data|")
};
for (int r=0;r<recalcTriggers.length();r++)
	addRecalcTrigger(_kContext, recalcTriggers[r]);


if (_bOnInsert) 
{
	if (insertCycleCount()> 1) 
	{
		eraseInstance();
		return;
	}
	
	_Pt0 = getPoint(T("|Select a position|"));
	
	_Map.setInt("Insert", true);
	return;
}

int clear = false;

int execute = false;
if (_Map.hasInt("Insert")) {
	if (_Map.getInt("Insert"))
		execute = true;
	
	_Map.removeAt("Insert", false);
}
if (_kExecuteKey == recalcTriggers[0])
	execute = true;

String doubleClick= "TslDoubleClick";
if (_bOnRecalc && _kExecuteKey==doubleClick)
	execute = true;

if (_bOnDebug)
	execute = true;

if (_kExecuteKey == recalcTriggers[1])
{
	execute = true;
	clear = true;
}

// Always sort y material.
int groupByMaterial = true;

if (execute) {
	Entity sheetEntities[] = Group().collectEntities(true, Sheet(), _kModelSpace);
	
	Map filterGenBeamsMap;
	filterGenBeamsMap.setEntityArray(sheetEntities, false, "GenBeams", "GenBeams", "GenBeam");
	int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, sheetFilterDefinition, filterGenBeamsMap);
	if (!successfullyFiltered) {
		reportWarning(T("|Sheets could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
		eraseInstance();
		return;
	} 
	sheetEntities = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");

	String sortKeys[0];
	
	Sheet sheets[0];
	// Sheet sizes
	double lengths[0];
	double widths[0];
	double heights[0];
	
	for (int e=0;e<sheetEntities.length();e++) 
	{
		Sheet sheet = (Sheet)sheetEntities[e];
		if (!sheet.bIsValid())
			continue;
		
		if (clear) 
		{
			sheet.setSubLabel2("");
			sheet.removeSubMapX("SquareSheets");
			continue;
		}
		
		// TODO: apply filters.
		
		// Round sizes. 1195.345 = 1195, 1195.853 = 1196.
		double roundedWidth = round(sheet.solidWidth());
		double roundedLength = round(sheet.solidLength());
		double roundedHeight = round(sheet.solidHeight());
		
		String paddedWidth; paddedWidth.format("%06.0f", roundedWidth);
		String paddedLength; paddedLength.format("%06.0f", roundedLength);
		String paddedHeight; paddedHeight.format("%06.0f", roundedHeight);
		String color; color.format("%03i", sheet.color());
		
		String sortKey = color + "-" + paddedHeight + "-" + paddedWidth + "-" + paddedLength;
		if (groupByMaterial)
			sortKey += ("-" + sheet.material().makeUpper());
		
		sortKeys.append(sortKey);
			
		sheets.append(sheet);
	
		widths.append(roundedWidth);
		lengths.append(roundedLength);
		heights.append(roundedHeight);
	}
	
	// Sort by height, length and width
	for(int s1=1;s1<sortKeys.length();s1++){
		int s11 = s1;
		for(int s2=s1-1;s2>=0;s2--){
			if( sortKeys[s11] < sortKeys[s2] ){
				sortKeys.swap(s2, s11);
				
				sheets.swap(s2, s11);
				
				widths.swap(s2, s11);
				lengths.swap(s2, s11);
				heights.swap(s2, s11);
				
				s11=s2;
			}
		}
	}
	
	String currentSortKey = "";
	int currentPosnum = -1;
	for (int s=0;s<sheets.length();s++) 
	{
		Sheet sheet = sheets[s];
		String sortKey = sortKeys[s];
		
		if (s==0 || sortKey != currentSortKey) 
		{
			currentSortKey = sortKey;
			currentPosnum = sheet.posnum();
		}
		
		// Attach MapX data to be used in extensions.
		Map sheetOptimisation;
		sheetOptimisation.setInt("Posnum", currentPosnum);
		sheet.setSubMapX("SquareSheets", sheetOptimisation);
	}
	
	_Map.setInt("NumberOfEntities", sheets.length());
	_Map.setString("Executed", String().formatTime("%d-%m-%Y, %H:%M"));
}

String dateTimeLastExecute = _Map.getString("Executed");
Display dp(textColor);
dp.dimStyle(textDimensionStyle);
double textSize = dp.textHeightForStyle("HSB", textDimensionStyle);
if (fontSize > 0) 
{
	dp.textHeight(fontSize );
	textSize = fontSize;
}

dp.draw(_Map.getInt("NumberOfEntities") + T(" |entities are last analysed at|: ") + dateTimeLastExecute, _Pt0, _XW, _YW, 1, 1);
dp.color(1);
dp.textHeight(0.5 * textSize);
dp.draw(T("|Filter|: ") + sheetFilterDefinition, _Pt0, _XW, _YW, 1, -2);


#End
#BeginThumbnail



#End