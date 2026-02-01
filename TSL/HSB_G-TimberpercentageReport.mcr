#Version 8
#BeginDescription

This tsl adds a schedule for the timberpercentage on a layout

1.0 03/12/2024 First version Author: Robert Pol
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
/// This tsl distributes insulation sheeting in multiwalls.
/// </summary>

/// <insert>
///  Select Multielement(s).
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <history>
// #Versions
//1.0 03/12/2024 First version Author: Robert Pol
//1.4 19/09/2024 Always start with full width sheet Author: Robert Pol
//1.3 19/09/2024 Redo logic based on new saw Author: Robert Pol
//1.2 18/08/2021 Fix issue where lengthwise and last widthwise sheets had the same letter, make sure for each element the letter is set back to "A" Author: Robert Pol
//1.1 18/08/2021 Split lengthwise sheets and add numbering Author: Robert Pol
//1.0 20/05/2021 Pilot version Author: Robert Pol
/// </history>

double vectorTolerance = Unit(0.01, "mm");
double pointTolerance = Unit(0.1, "mm");

//String alphabeth[] = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "Y", "Z"};
//String extendedAlphabeth[0];
//extendedAlphabeth.append(alphabeth);
//for (int index=0;index<alphabeth.length();index++) 
//{ 
//	String letter = alphabeth[index]; 
//	for (int index2=0;index2<alphabeth.length();index2++) 
//	{ 
//		String otherLetter = alphabeth[index2]; 
//		extendedAlphabeth.append(letter + otherLetter); 
//	} 
//}
//
//// String constants
//String general = T("|General|");
//String distribution = T("|Distribution|");
//String bottomAndLeft = T("|Bottom&Left|");
//String topAndRight = T("|Top&Right|");
//String centre = T("|Centre|");
//String atRafter = T("|At Rafter|");
//String leftFromRafter = T("|Left from Rafter|");
//String rightFromRafter = T("|Right from Rafter|");
//String leftAndRightFromRafter = T ("|Left&Right from Rafter|");
//String onGrid = T ("|On Grid|");
//String yes = T("|Yes|");
//String no = T("|No|");
//String left = T("|Left|");
//String right = T("|Right|");
//String centreNoBeamInCentre = T("|Centre, no beam in centre|");
//String manualExecuteKey = "ManualInsert";
//String sDefault =T("|_Default|");
String sLastInserted =T("|_LastInserted|");	
//String filterDefinitionTslName = "HSB_G-FilterGenBeams";
//String executeKey = "ManualInsert";
//String itemTsl = "hsbItemClone";
//String itemNesterTsl = "hsbItemNester";
//
//String arYesNo[] = { T("|Yes|"), T("|No|")};
//String arSdistribution[] = {
//	left,
//	right,
//	centre,
//	centreNoBeamInCentre,
//	atRafter,
//	leftFromRafter,
//	rightFromRafter,
//	leftAndRightFromRafter,
//	onGrid
//};	
//
//int sides[] = {-1, 1};
//
String category = T("|Style|");
PropString dimensionStyleHeader(0, _DimStyles, T("|Dimension Style Header|"));
dimensionStyleHeader.setCategory(category);

PropString dimensionStyle(1, _DimStyles, T("|Dimension Style|"));
dimensionStyle.setCategory(category);

PropInt color(0, -1, T("|Color|"));
color.setCategory(category);
//
//category = T("|Nesting|");
//String itemCatalogs[] =  TslInst().getListOfCatalogNames(itemTsl);
//PropString itemCloneCatalog(0, itemCatalogs, T("|Item Clone Catalog|"));
//itemCloneCatalog.setCategory(category);
//
//String itemNesterCatalogs[] =  TslInst().getListOfCatalogNames(itemNesterTsl);
//PropString itemNesterCatalog(1, itemNesterCatalogs, T("|Item Nester Catalog|"));
//itemNesterCatalog.setCategory(category);

// Get catalog names
String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if (_kExecuteKey != "" && catalogNames.find(_kExecuteKey) != -1) 
 {
 	setPropValuesFromCatalog(_kExecuteKey);
 }

//region _bOnInsert
if(_bOnInsert)
{
	if (insertCycleCount()>1) { eraseInstance(); return; }
				
// silent/dialog
	String sKey = _kExecuteKey;
	sKey.makeUpper();

	if (sKey.length()>0)
	{
		String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
		for(int i=0;i<sEntries.length();i++)
		{
			sEntries[i] = sEntries[i].makeUpper();	
		}
		
		if (sEntries.find(sKey)>-1)
		{
			setPropValuesFromCatalog(sKey);
			setCatalogFromPropValues(sLastInserted); // use because lastinserted was not set (should not be needed)
		}
		else
		{
			setPropValuesFromCatalog(sKey);
			setCatalogFromPropValues(sLastInserted); // use because lastinserted was not set (should not be needed)
		}
	}	
	else	
	{
		showDialog();
		setCatalogFromPropValues(sLastInserted); // use because lastinserted was not set (should not be needed)
	}
	
	// Prompt for multi elements
	_Viewport.append(getViewport());
 	_Pt0 = getPoint();
	return;
}
//endregion

// Check if element is selected.
if( _Viewport.length() < 1 )
{
 	reportMessage(TN("|No viewport selected!|"));
	eraseInstance();
 	return;
}

Viewport viewPort = _Viewport[0];
Element element = viewPort.element();

if (! element.bIsValid())
{
	reportMessage("|Not a valid element|");
	return;
}

Display dpHeader(color);
dpHeader.dimStyle(dimensionStyleHeader);

double textHeightHeader = dpHeader.textHeightForStyle("hsbcad", dimensionStyleHeader);
double heightOffsetHeader = 1.5 * textHeightHeader;
double textLengthHeader = dpHeader.textLengthForStyle("hsbcad", dimensionStyleHeader);
Point3d insertionPoint = _Pt0;
dpHeader.draw(T("|Timberpercentage Calculation|"), insertionPoint, _XW, _YW, 1, 0);

PLine startRow(insertionPoint - _YW * 0.5 * heightOffsetHeader, insertionPoint - _YW * 0.5 * heightOffsetHeader + _XW * dpHeader.textLengthForStyle(T("|Timberpercentage Calculation|"), dimensionStyleHeader));
dpHeader.draw(startRow);
insertionPoint -= _YW * heightOffsetHeader;

Map extendedPropertiesMap = element.subMapX("ExtendedProperties");
for (int e = 0; e < extendedPropertiesMap.length(); e++)
{
	if (extendedPropertiesMap.keyAt(e) != "TIMBERPERCENTAGE") continue;
	
	Map timberPercentageMap = extendedPropertiesMap.getMap(e);
	double timberPercentage = timberPercentageMap.getDouble("TimberPercentage");
	String stringTimberPercentage;
	stringTimberPercentage.formatUnit(timberPercentage, 2, 3);
	double timberPercentageArea = timberPercentageMap.getDouble("TimberPercentageArea");
	String stringTimberPercentageArea;
	stringTimberPercentageArea.formatUnit(timberPercentageArea, 2, 3);
	double timberPercentageAreaWood = timberPercentageMap.getDouble("TimberPercentageAreaWood");
	String stringTimberPercentageAreaWood;
	stringTimberPercentageAreaWood.formatUnit(timberPercentageAreaWood, 2, 3);
	
	String areaName = timberPercentageMap.getString("Name");
	
	Display dp(color > -1 ? color : e);
	dp.dimStyle(dimensionStyle);
	
	double textHeight = dp.textHeightForStyle("hsbcad", dimensionStyle);
	double heightOffset = 1.5 * textHeight;
	double textLength = dp.textLengthForStyle("hsbcad", dimensionStyle);
	
	dp.draw(areaName +T("| area : |") + stringTimberPercentageArea + " m2", insertionPoint, _XW, _YW, 1, 0);
	insertionPoint -= _YW * heightOffset;
	
	
	//region Collect header names
	String headerNames[0];
	double textLengthsHeaders[0];
	headerNames.append(T("|Posnum|")); textLengthsHeaders.append(dp.textLengthForStyle(T("|Posnum|"), dimensionStyle));
	headerNames.append(T("|TimberPercentage Area|")); textLengthsHeaders.append(dp.textLengthForStyle(T("|TimberPercentage Area|"), dimensionStyle));
	headerNames.append(T("|Total Area|")); textLengthsHeaders.append(dp.textLengthForStyle(T("|Total Area|"), dimensionStyle));
	headerNames.append(T("|Quantity|")); textLengthsHeaders.append(dp.textLengthForStyle(T("|Quantity|"), dimensionStyle));
	
	//endregion
	
	Point3d headerInsertionPoint = insertionPoint;
	for (int h = 0; h < headerNames.length(); h++)
	{
		if (h > 0)
		{
			headerInsertionPoint += _XW * textLengthsHeaders[h - 1] * 1.1;
		}
		dp.draw(headerNames[h], headerInsertionPoint, _XW, _YW, 1, 0);
	}
	
	Map mapWithTimperpercentageBeams;
	int posnums[0];
	String timberPercentageAreas[0];
	String totalAreas[0];
	int quantities[0];
	
	Beam elementBeams[] = element.beam();
	for (int b = 0; b < elementBeams.length(); b++)
	{
		Beam beam = elementBeams[b];
		int posnumBeam = beam.posnum();
		Map extendedPropertiesMapBeam = beam.subMapX("ExtendedProperties");
		double timberPercentageAreaBeam = extendedPropertiesMapBeam.getDouble("TimberPercentageArea" + areaName);
		String stringTimberPercentageAreaBeam;
		stringTimberPercentageAreaBeam.formatUnit(timberPercentageAreaBeam, 2, 3);
		double totalAreaBeam = extendedPropertiesMapBeam.getDouble("TotalArea");
		String stringTotalAreaBeam;
		stringTotalAreaBeam.formatUnit(totalAreaBeam, 2, 3);
		
		Map newMapWithTimberpercentageBeam;
		newMapWithTimberpercentageBeam.setInt("Posnum", posnumBeam);
		newMapWithTimberpercentageBeam.setString("TimberPercentageArea", stringTimberPercentageAreaBeam);
		newMapWithTimberpercentageBeam.setString("TotalArea", stringTotalAreaBeam);
		newMapWithTimberpercentageBeam.setInt("Quantity", 1);
		
		int mapFound;
		int indexFound;
		for (int m = 0; m < mapWithTimperpercentageBeams.length(); m++)
		{
			Map mapWithTimperpercentageBeam = mapWithTimperpercentageBeams.getMap(m);
			int posnum = mapWithTimperpercentageBeam.getInt("Posnum");
			String timberPercentageArea = mapWithTimperpercentageBeam.getString("TimberPercentageArea");
			String totalArea = mapWithTimperpercentageBeam.getString("TotalArea");
			int quantity = mapWithTimperpercentageBeam.getInt("Quantity");
			
			if (posnum != posnumBeam || stringTimberPercentageAreaBeam != timberPercentageArea) continue;
			
			mapFound = true;
			quantity++;
			
			indexFound = m;
			mapWithTimperpercentageBeam.setInt("Quantity", quantity);
			
			newMapWithTimberpercentageBeam = mapWithTimperpercentageBeam;
		}
		
		mapWithTimperpercentageBeams.appendMap("TimberpercentageBeams", newMapWithTimberpercentageBeam);
		
		if (mapFound) 
		{
			mapWithTimperpercentageBeams.removeAt(indexFound, false);
		}
		
	}
	
	for (int s1 = 1; s1 < mapWithTimperpercentageBeams.length(); s1++) 
	{	
		int s11 = s1;
		for (int s2 = s1 - 1; s2 >= 0; s2--) 
		{
			Map mapWithTimperpercentageBeam11 = mapWithTimperpercentageBeams.getMap(s11);	
			int posnum11 = mapWithTimperpercentageBeam11.getInt("Posnum");
			String timberPercentageArea11 = mapWithTimperpercentageBeam11.getString("TimberPercentageArea");
			String totalArea11 = mapWithTimperpercentageBeam11.getString("TotalArea");
			int quantity11 = mapWithTimperpercentageBeam11.getInt("Quantity");
		
			Map mapWithTimperpercentageBeam02 = mapWithTimperpercentageBeams.getMap(s2);	
			int posnum02 = mapWithTimperpercentageBeam02.getInt("Posnum");
			String timberPercentageArea02 = mapWithTimperpercentageBeam02.getString("TimberPercentageArea");
			String totalArea02 = mapWithTimperpercentageBeam02.getString("TotalArea");
			int quantity02 = mapWithTimperpercentageBeam02.getInt("Quantity");
			if ( posnum11 < posnum02) 
			{
				mapWithTimperpercentageBeams.swapLastWith(s2);
				mapWithTimperpercentageBeams.swapLastWith(s11);
				
				//mapWithTimperpercentageBeams.swap(s2, s11);

				s11 = s2;
			}
		}
	}
	
	for (int i = 0; i < mapWithTimperpercentageBeams.length(); i++)
	{
		Map mapWithTimperpercentageBeam = mapWithTimperpercentageBeams.getMap(i);
		int posnum = mapWithTimperpercentageBeam.getInt("Posnum");
		String timberPercentageArea = mapWithTimperpercentageBeam.getString("TimberPercentageArea");
		String totalArea = mapWithTimperpercentageBeam.getString("TotalArea");
		int quantity = mapWithTimperpercentageBeam.getInt("Quantity");
		insertionPoint -= _YW * heightOffset;
		dp.draw(posnum, insertionPoint, _XW, _YW, 1, 0);
		
		Point3d nextInsertionPoint = insertionPoint + _XW * textLengthsHeaders[0] * 1.1;
		dp.draw(timberPercentageArea, nextInsertionPoint, _XW, _YW, 1, 0);
		
		nextInsertionPoint += _XW * textLengthsHeaders[1] * 1.1;
		dp.draw(totalArea, nextInsertionPoint, _XW, _YW, 1, 0);
		
		nextInsertionPoint += _XW * textLengthsHeaders[2] * 1.1;
		dp.draw(quantity, nextInsertionPoint, _XW, _YW, 1, 0);
		
	}
	insertionPoint -= _YW * heightOffset;
	Point3d nextinsertionPoint = insertionPoint + _XW * textLengthsHeaders[0] * 1.1 + _XW * textLengthsHeaders[1] * 1.1;
	dp.draw(T("|Total Area Wood = |") , insertionPoint, _XW, _YW, 1, 0);
	dp.draw(stringTimberPercentageAreaWood + " m2", nextinsertionPoint, _XW, _YW, 1, 0);
	
	insertionPoint -= _YW * heightOffset;
	dp.draw(T("|Timberpercentage = Total Area Wood| / ") + areaName + " Area x 100 = " + stringTimberPercentage + " %", insertionPoint, _XW, _YW, 1, 0);
	PLine endRow(insertionPoint - _YW * 0.5 * heightOffsetHeader, insertionPoint - _YW * 0.5 * heightOffsetHeader + _XW * dp.textLengthForStyle(T("|Timberpercentage = Total Area Wood| / ") + areaName + " Area x 100 = " + stringTimberPercentage + " %", dimensionStyle));
	dp.draw(endRow);
	insertionPoint -= _YW * heightOffsetHeader;
	
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
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="236" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="First version" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="12/3/2024 11:42:47 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End