#Version 8
#BeginDescription
#Versions
V0.19 10/4/2023 Set column format fields to use formatting dialog. Added option to not perform formatting
V0.18 9/28/2023 Improved insertion routine cc
0.16 9/26/2023 Bugfix in string=>double conversion cc
0.14 9/25/2023 Updated labelling trigger again cc
0.12 9/25/2023 Added setting to trigger labeler script cc


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 0
#MinorVersion 19
#KeyWords 
#BeginContents
/*
<>--<>--<>--<>--<>--<>--<>--<>____ Craig Colomb _____<>--<>--<>--<>--<>--<>--<>--<>



//######################################################################################
//############################ Documentation #########################################

V0.1 __7July2023__Rework of generic table to work as linked list. Credit taya.blackrose@hsbcad.com

                                                       cc@hsb-cad.com

<insert>
Manually inserted on Layout 
</insert>

<property name="Map Name">
This is the map entry name to look for in the default MapObject, "TableData".
</ property >

<command name="N/A">
No custom commands
</command>

<version  value=.1 date=17December2014>
</version>

<remark>
Map structure expected

mpData
	|__"stTitle", "Schedule Table Title" : optional
	|_"stSortKeys", "ColumnName1, ColumnName2..." comma seperated list of column names to sort by
	|
	|__"mpJustify", mpJustify : optional, typical flags -1, 0, 1
	|	|_"int", 1
	|	|_"int", 0
	|	|_... :make as many entries as columns, or table defaults to center for remaining columns
	|
	|__"mpRow", mpRow
	|	|_"Column Name", "R1C1 Entry"
	|	|_"Column Name", "R1C2 Entry"
	|	|_"Column Name", "R1C3 Entry"
	|
	|_"mpRow", mpRow
	|	|_"Column Name", "R2C1 Entry"
	|	|_"Column Name", "R2C2 Entry"
	|	|_"Column Name", "R2C3 Entry"
	|
	|_"mpRow", mpRow
	|	|_...
	|....
	|
	|_"stNote", "Some kind of wisdom here" : Notes will be placed at the bottom of the table,
	|_"stNote", "Some kind of wisdom here" :  and be full width with no columns
</remark>

//########################## End Documentation #########################################
//######################################################################################

                              craig.colomb@hsbcad.com
<>--<>--<>--<>--<>--<>--<>--<>_____ hsbcad.us  _____<>--<>--<>--<>--<>--<>--<>--<>

*/



String stUnits[] = {"inch", "mm"};
String stDimFormat[] = { "By Dimstyle", "Decimal", "Fractional Inch", "Ft-Inch", "None"};
int iPrecisions[] = { 0, 1, 2, 3, 4};
Display dp(-1) ;
Display dpHeader(-1);
Display dpText(-1);


//constants
int bIsMetricDwg = U(1, "mm") == 1;//__script units are inches
double dUnitConversion = bIsMetricDwg ? 1 : 1 / 25.4; //__mm to .dwg units
double dAreaConversion = pow(dUnitConversion, 2);
double dVolumeConversion = pow(dUnitConversion, 3);
double dEquivalientTolerance = .01;		
String stYN[] = { "No", "Yes"};
String stSpecial = projectSpecial();
int bInDebug = stSpecial == "db" || stSpecial == scriptName();
if(_bOnDebug) bInDebug = true;

String stPreviousTableKey = "tslTablePrevious";
String stNextTslKey = "tslNext";
String stBottomLeftKey = "ptBottomLeft";
String stElementEntityKey = "entElement";
int iZones[] = { - 5, - 4, - 3, - 2, - 1, 0, 1, 2, 3, 4, 5};
String stLastElementKey = "stLastElement";

int bHasFollower;
if (_Map.hasEntity(stNextTslKey)) bHasFollower = true;

PropString psTitleText(0, "", "Table Title");
PropString psDimstyle(1, _DimStyles, "Dimstyle");
PropString psUnits(2, stUnits, "Table Units");
PropString psDimFormat(12, stDimFormat, "Dimension Format");
PropInt piDimPrecision(3, iPrecisions, "Dimension Precision");
piDimPrecision.setDescription("The number of decimal places to round to");

//__enforce no fractional reporting of mm
if(psUnits == stUnits[1] && stDimFormat.find(psDimFormat) >1 && psDimFormat != "None")
{ 
	psDimFormat.set(stDimFormat[1]);
}
PropDouble pdTitleTextH (0, -1, "Title Text Height");
PropDouble pdTextH (1, -1, "Text Height");
PropInt piTextColor(0, -1, "Text Color");
PropInt piLineColor(1, -1, "Line Color");
PropDouble pdExtraWidth(2, 6, "Width Margin");
PropDouble pdExtraHeight(3, 3, "Height Margin");


String stReportCategory = "Reporting Criteria";
PropInt piZone(2, iZones, "Zone to Report");
piZone.setCategory(stReportCategory);
PropString psColumnHeaders(10, "", "Column Headers");
psColumnHeaders.setCategory(stReportCategory);
psColumnHeaders.setDescription("A comma separated list of Headers");
PropString psFormat1(3, "", "Format Column 1");
psFormat1.setCategory(stReportCategory);
psFormat1.setDefinesFormatting("GenBeam");
PropString psFormat2(4, "", "Format Column 2");
psFormat2.setCategory(stReportCategory);
psFormat2.setDefinesFormatting("GenBeam");
PropString psFormat3(5, "", "Format Column 3");
psFormat3.setCategory(stReportCategory);
psFormat3.setDefinesFormatting("GenBeam");
PropString psFormat4(6, "", "Format Column 4");
psFormat4.setCategory(stReportCategory);
psFormat4.setDefinesFormatting("GenBeam");
PropString psFormat5(7, "", "Format Column 5");
psFormat5.setCategory(stReportCategory);
psFormat5.setDefinesFormatting("GenBeam");
PropString psFormat6(8, "", "Format Column 6");
psFormat6.setCategory(stReportCategory);
psFormat6.setDefinesFormatting("GenBeam");
PropString psFormat7(9, "", "Format Column 7");
psFormat7.setCategory(stReportCategory);
psFormat7.setDefinesFormatting("GenBeam");


PropString psShowQuantity(11, stYN, "Show Quantity");
psShowQuantity.setCategory(stReportCategory);
int bShowQuantity = psShowQuantity == stYN[1];


String stHeaders[] = psColumnHeaders.tokenize(",");
String stFormats[0];
stFormats.append(psFormat1);
stFormats.append(psFormat2);
stFormats.append(psFormat3);
stFormats.append(psFormat4);
stFormats.append(psFormat5);
stFormats.append(psFormat6);
stFormats.append(psFormat7);


dpText.dimStyle(psDimstyle);
dpText.textHeight(pdTextH);
dpText.color(piTextColor);

dpHeader.dimStyle(psDimstyle);
dpHeader.textHeight(pdTitleTextH);
dpHeader.color(piTextColor);

dp.color(piLineColor);

double dConversion = 1;
if (bIsMetricDwg && psUnits == stUnits[0]) dConversion = 1 / 25.4;
if ( ! bIsMetricDwg && psUnits == stUnits[1]) dConversion = 25.4;

String TryConvertToSimpleInt(String stValue)
{ 
	int bIsSimpleInt;
	for(int i=0; i<stValue.length(); i++)
	{
		char c = stValue.getAt(i);
		String st = c;
		//__catch 0. In subsequent calls to atoi() we can be assured 0 means error
		if (c == '0') continue;
		
		int iConvert = st.atoi();
		if(iConvert == 0)//__character was not numeric
		{ 
			bIsSimpleInt = false;
			break;
		}
	}
	
	if (bIsSimpleInt) return stValue.atoi();
	
	//__not a simple integer, return empty string
	return "";
}

String CheckFormat(String stText)
{ 
	//__catch integers, which can be returned as is
	String stIntTry = TryConvertToSimpleInt(stText);
	if(stIntTry != "")//_conversion succeeded
	{ 
		//__integer values can be returned as is
		return stText;
	}
	
	
	//__if this is a double, do rounding and formatting
	double dConverted = stText.atof(_kLength);
	if(bInDebug) reportMessage("\nstText = " + stText + "  stText.atof() = " + dConverted);
	
	if(dConverted != 0.0)
	{ 
		//__convert to table units
		dConverted *= dConversion;
		
		//__do requested rounding
		int iDecimalPlaces = pow(10, piDimPrecision);
		dConverted = round(dConverted * iDecimalPlaces) / iDecimalPlaces;
		
		String stResult;
		//__apply dimension formatting
		if (psDimFormat == stDimFormat[0]) stResult.formatUnit(dConverted, psDimstyle);
		if (psDimFormat == stDimFormat[1]) stResult = dConverted;
		if (psDimFormat == stDimFormat[2]) stResult.formatUnit(dConverted, 5, 4);
		if (psDimFormat == stDimFormat[3]) stResult.formatUnit(dConverted, 4, 4);
		
		return stResult;
	}
	
	//__seems to not be a number, return original text
	return stText;
}



if (_bOnInsert)
{
	if (insertCycleCount()>1) { eraseInstance(); return; }
	showDialog();
	
	String stMyName = scriptName();
	int bNeedViewport = true;
	
	_Pt0 = getPoint("Select upper left corner of table");
	
	PrEntity pre("Select Previous Table", TslInst());
	if(pre.go())
	{ 
		Entity entAll[] = pre.set();
		
		if(entAll.length() > 0)
		{ 
			for(int i=0; i<entAll.length(); i++)
			{
				Entity entSelected =  entAll[i];			
				TslInst tslPrevious = (TslInst) entSelected;	
				if (tslPrevious.scriptName() != stMyName) continue;
				
				_Map.setEntity(stPreviousTableKey, entSelected);
				bNeedViewport = false;
				break;
			}	
					
		}	
	}
	
	if(bNeedViewport)
	{ 
		Viewport vp = getViewport();
		_Viewport.append(vp);
	}
	
	
	return;
}


String stSelectPreviousTableCommand = T("|Select Previous Table|");
addRecalcTrigger(_kContextRoot, stSelectPreviousTableCommand);
if(_kExecuteKey == stSelectPreviousTableCommand)
{ 
	TslInst tsl = getTslInst("Select LinkedScheduleTable");
	if(tsl.scriptName() != scriptName())
	{ 
		reportMessage("Selected Script was not LinkedScheduleTable");
	}
	else
	{ 
		_Map.setEntity(stPreviousTableKey, tsl);
	}
}


String stSelectViewportCommand = T("|Select Viewport|");
addRecalcTrigger(_kContextRoot, stSelectViewportCommand);
if(_kExecuteKey == stSelectViewportCommand)
{ 
	Viewport vp = getViewport();
	if(_Viewport.length() > 0)
	{ 
		_Viewport[0] = vp;
	}
	else
	{ 
		_Viewport.append(vp);
	}
}


String stTitle = psTitleText;

Map mpData;
Element el;
int bHasPrevious = _Map.hasEntity(stPreviousTableKey);

if(_Viewport.length() > 0)
{ 
	Viewport vp = _Viewport[0];
	el = vp.element();
	_Map.setEntity(stElementEntityKey, el);
	
	if(el.handle() != _Map.getString(stLastElementKey))
	{ 
		TslInst tslsAll[] = el.tslInst();
		for(int i=0; i<tslsAll.length(); i++)
		{
			TslInst tsl = tslsAll[i];
			if(tsl.scriptName() == "PartLabeler")
			{ 
				tsl.recalcNow("bAssignPosnums");
				break;
			}
		}
	}
}
else if (bHasPrevious)
{
	Entity entPrevious = _Map.getEntity(stPreviousTableKey);
	TslInst tslTable = (TslInst)entPrevious;
	if (tslTable.bIsValid())
	{
		//__get Element and location from previous table
		Map mpTable = tslTable.map();
		Entity storedEnt = mpTable.getEntity(stElementEntityKey);
		el = (Element)storedEnt;
		_Pt0 = mpTable.getPoint3d(stBottomLeftKey);
		
		//__store a reference to me to allow recalc when previous table changes
		mpTable.setEntity(stNextTslKey, _ThisInst);
		tslTable.setMap(mpTable);		
	}
}

if(! el.bIsValid())//__no data to work from
{ 
	dp.draw("Use Rt-click menu to select ", _Pt0, _XW, _YW, 1, 1);
	dp.draw("either Viewport or another table", _Pt0 - _YW * U(.12, "inch"), _XW, _YW, 1, -1);

	
	return;
}
else
{ 
	//__store the active Element for use by others
	_Map.setEntity(stElementEntityKey, el);
}


GenBeam gbsToReport[] = el.genBeam(piZone);
Map mpQuantity;


for(int i=0; i<gbsToReport.length(); i++)
{
	GenBeam gb = gbsToReport[i];
		
	Map mpLabel = gb.subMapX("mpLabel");
	String stLabel = mpLabel.getString("stLabel");
	
	//__if quantity for this label is not present 0 is returned
	int iCount = mpQuantity.getInt(stLabel) + 1;
	mpQuantity.setInt(stLabel, iCount);
	if (iCount > 1) continue;//__table already has this entry
	
	Map mpRow;
	mpRow.setString("ID", stLabel);	
	
	for(int k=0; k<stHeaders.length(); k++)
	{
		String stHeader = stHeaders[k];
		String stValue = gb.formatObject(stFormats[k]);
		if (psDimFormat != "None" )stValue = CheckFormat(stValue);
		mpRow.setString(stHeader, stValue);
	}
	
	mpData.appendMap("mpRow", mpRow);
}

if(bShowQuantity)
{ 
	Map mpDataWithCount;
	for(int i=0;i<mpData.length();i++)
	{
		Map mpRow = mpData.getMap(i);
		int iCount = mpQuantity.getInt(mpRow.getString("ID"));
		mpRow.setString("Qty.", iCount);
		mpDataWithCount.appendMap("mpRow", mpRow);
	}
	
	mpData = mpDataWithCount;
}


double dTitleH = dpHeader.textHeightForStyle(stTitle, psDimstyle) + pdExtraHeight;
double dTitleW =  dpHeader.textLengthForStyle(stTitle, psDimstyle) + pdExtraWidth*2;

if (pdTitleTextH > 0) 
{
	dTitleH = pdTitleTextH + pdExtraHeight;
	dTitleW = stTitle.length() * pdTitleTextH * .6 + pdExtraWidth * 2;
}

Vector3d vX = _XW; //__I hate typing underscores...
Vector3d vY = _YW;


//if (mpData.length() == 0 || ! mpData.hasMap("mpRow")) 
//{
//	LineSeg lsTitle (_Pt0, _Pt0 + vX *dTitleW - vY * dTitleH);
//	PLine plHeader; plHeader.createRectangle(lsTitle, vX, vY);
//	Point3d ptTitle = lsTitle.ptMid();
//	dp.draw(plHeader);
//	dpHeader.draw(stTitle, ptTitle, vX, vY, 0, 0);
//	return;
//}
//__Sort data when keys are present
if (mpData.hasString("stSortKeys"))
{
	String stSortKeysStored = mpData.getString("stSortKeys");
	String stSortKeys[0];
	String stSeparators = ",";
	int iterator = 0;
	while(true)//Yikes!!
	{
		String key = stSortKeysStored.token(iterator++, stSeparators);
		//__if this entry is blank we have reached the end of the list
		if (key == "") break;
		stSortKeys.append(key);			
	}
	
	//__filter out only data rows
	Map mpToSort[0];
	for (int i=0; i<mpData.length(); i++) 
	{
		if (mpData.keyAt(i) == "mpRow") mpToSort.append(mpData.getMap(i));
	}
	String stSortKey = stSortKeys[0];
	String stUniqueKeys[0];
	for (int i=0; i<mpToSort.length(); i++)
	{
		int iDoSwap = true;
		
		for (int j = i; j>0 && iDoSwap; j--)
		{					
			Map mpThis = mpToSort[j];
			Map mpPrevious = mpToSort[j-1];
			if (mpThis.getString(stSortKey) > mpPrevious.getString(stSortKey)) iDoSwap = false;
			
			if (iDoSwap) mpToSort.swap(j, j-1);
		}
	}
	mpToSort[0].writeToDxxFile(_kPathDwg + "mpToSort.dxx");			
	for (int k=1; k<stSortKeys.length(); k++)
	{
		
		stSortKey = stSortKeys[k];
		
		//__create a list of unique composite keys
		for(int i=0; i<mpToSort.length(); i++)
		{
			String stKey;
			Map mp = mpToSort[i];
			for(int j=0; j<k; j++) 
			{
				String stDB = stSortKeys[j];
				String stDB2 = mp.getString(stDB);
				String stDB3 = mp.getString("Wall_Panel");
				stKey += mp.getString(stDB);
			}
			if (stUniqueKeys.find(stKey) < 0) stUniqueKeys.append(stKey);
		}
		
		//___isolate the set with each unique key, then
		//_sort the set with the current sort key
		for(int i=0; i<stUniqueKeys.length(); i++)
		{
			String stGroupKey = stUniqueKeys[i];
			int iStartIndex = -1, iEndIndex = -1;
			for (int j=0; j<mpToSort.length(); j++)
			{
				String stThisKey;					
				Map mpToTest = mpToSort[j];
				//__Build a composite key
				for (int m=0; m<k; m++) stThisKey += mpToTest.getString(stSortKeys[m]);
				int iMatch = stThisKey == stGroupKey;
				
				//___if we have a match and start index is not set, then this is start of group
				if (iMatch && iStartIndex <0) iStartIndex = j;
				
				//__if there is a match then record this as possible end index
				if (iMatch) iEndIndex = j;
				
				//__if there is no match but start index is already set, we have reached the end
				if (! iMatch && iEndIndex > 0) break;
			}
			//__if start and end are equal there is only one entry and nothing to sort
			if (iStartIndex == iEndIndex) continue;
			
			//__use insertion sort on this group
			for (int m = iStartIndex; m <= iEndIndex; m++)
			{
				int iDoSwap = true;
				
				for (int j = m; j>iStartIndex && iDoSwap; j--)
				{					
					Map mpThis = mpToSort[j];
					Map mpPrevious = mpToSort[j-1];
					String stThisEntry = mpThis.getString(stSortKey);
					String stPreviousEntry = mpPrevious.getString(stSortKey);
					double dThisEntry = stThisEntry.atof();
					double dPreviousEntry = stPreviousEntry.atof();
					
					//__check to see if double conversion was successful
					int iIsNumber = false;
					if (dThisEntry != 0 || stThisEntry == "0" || stThisEntry == "0.0") iIsNumber = true;
					
					if (iIsNumber)
					{
						if (dThisEntry > dPreviousEntry) iDoSwap = false;
					}
					else//__entry is not a number, do string comparison
					{
						if (stThisEntry > stPreviousEntry) iDoSwap = false;
					}
					
					if (iDoSwap) mpToSort.swap(j, j-1);
				}
			}
				
		}
	}
	
	Map mpNewData;
	mpNewData.setString("stTitle", mpData.getString("stTitle"));
	for (int i=0; i<mpToSort.length(); i++) mpNewData.appendMap("mpRow", mpToSort[i]);
	mpData = mpNewData;
}

//__populate some table properties
Map mpRowSample = mpData.getMap("mpRow");
String stColumnNames[0];
for(int i=0; i<mpRowSample.length(); i++) stColumnNames.append(mpRowSample.keyAt(i));

int iNumColumns = mpRowSample.length();
double dColumnWs[iNumColumns];
double dRowH;
//__do initial set of dimensions from column names
for (int i=0; i<iNumColumns; i++)
{
	dColumnWs[i] = dpText.textLengthForStyle(stColumnNames[i], psDimstyle) + pdExtraWidth;
	double dColH = dpText.textHeightForStyle(stColumnNames[i], psDimstyle) + pdExtraHeight;
	if (dRowH < dColH) dRowH = dColH;
	
	if (pdTextH >0)
	{
		dRowH = pdTextH + pdExtraHeight;
		dColumnWs[i] = stColumnNames[i].length() * pdTextH + pdExtraWidth;
	}
}
	
Map mpRows[0], mpJustify;
String stNotes[0];

//__loop through all table data to check dimensions
for(int i=0; i<mpData.length(); i++)
{
	String stKey = mpData.keyAt(i) ;
	if (stKey == "stNote")
	{
		stNotes.append(mpData.getString(i));
		 continue;
	}
	
	if (stKey != "mpRow") continue;
	Map mpRow = mpData.getMap(i);
	mpRows.append(mpRow);
	for (int k=0; k<mpRow.length(); k++)
	{
		String stEntry = mpRow.getString(k);
		double dEntryW = dpText.textLengthForStyle(stEntry, psDimstyle) + pdExtraWidth;			
		double dEntryH = dpText.textHeightForStyle(stEntry, psDimstyle) + pdExtraHeight;
		if (pdTextH > 0) 
		{
			dEntryW = stEntry.length()*pdTextH + pdExtraWidth;
			dEntryH = pdTextH + pdExtraHeight;
		}
		if (dColumnWs[k] < dEntryW) dColumnWs[k] = dEntryW;
		if (dRowH < dEntryH) dRowH = dEntryH;			
	}
}



//__for now, cells are center justified. Look for entry in Map to update this
//__legal flags are -1, 0, 1
int iJustify[iNumColumns];
if (mpData.hasMap("mpJustify"))
{
	Map mpJustify = mpData.getMap("mpJustify");
	for (int i=0; i<mpJustify.length(); i++) iJustify[i] = mpJustify.getInt(i);
}

double dTableW;
for (int i=0; i<dColumnWs.length(); i++) dTableW += dColumnWs[i];
if (dTableW < dTitleW) dTableW = dTitleW;

Point3d ptRowTop = _Pt0;
Point3d ptTitleFar = ptRowTop + vX * dTableW - vY * dTitleH;
LineSeg lsTitle(_Pt0, ptTitleFar);
PLine plTitle; plTitle.createRectangle(lsTitle, vX, vY);
dp.draw(plTitle);
Point3d ptTitle = lsTitle.ptMid();
dpHeader.draw(stTitle, ptTitle, vX, vY, 0, 0);

ptRowTop -= vY * dTitleH;
Vector3d vRow = -vY * dRowH;
Point3d ptRowBottom = ptRowTop + vRow;
PLine plRow (ptRowTop, ptRowBottom);
for(int i=0; i<iNumColumns; i++)
{
	Vector3d vCellX = vX * dColumnWs[i];
	ptRowTop += vCellX;
	ptRowBottom += vCellX;
	plRow.addVertex(ptRowBottom);
	plRow.addVertex(ptRowTop);
	plRow.addVertex(ptRowBottom);
}

//__lines are now done for one row with base and dividing borders
//__draw column headers
Point3d  ptTextStart = _Pt0 - vY * (dTitleH + dRowH/2);
for (int i=0; i<iNumColumns; i++)
{		
	Point3d ptText = ptTextStart + vX * dColumnWs[i]/2;
	dpText.draw(stColumnNames[i], ptText, vX, vY, 0, 0);
	ptTextStart += vX * dColumnWs[i];
}
dp.draw(plRow);
	
Point3d ptEntries[0];
Point3d ptText = _Pt0 - vY * (dTitleH + dRowH*1.5);
for (int i=0; i<iNumColumns; i++)
{		
	double dColW = dColumnWs[i];
	Point3d ptTextMid = ptText + vX * dColW/2;
	Point3d ptTextJustified = ptTextMid + vX * iJustify[i] * (dColW - pdExtraWidth)/2;
	ptEntries.append(ptTextJustified);
	ptText += vX * dColW;
}		
		
//__draw entries
for(int k=0; k<mpRows.length(); k++)
{	
	//__get the data & draw borders
	Map mpRow = mpRows[k];
	plRow.transformBy(vRow);
	dp.draw(plRow);
	
	//__draw entries
	for (int i=0; i<iNumColumns; i++)
	{			
		Point3d ptEntry = ptEntries[i] + vRow * k;
		dpText.draw(mpRow.getString(i), ptEntry, vX, vY,  -iJustify[i], 0);
	}
}		

Point3d ptNoteTL = _Pt0 - vY * dTitleH + vRow * (mpRows.length() +1);
ptNoteTL.vis(3);
double dNoteSpace = dTableW - pdExtraWidth;
String stSeperators[] = {" "};//, ",", "-"}; the other characters might prove useful, but would destroy info
for (int i=0; i<stNotes.length(); i++)
{
	String stNote = stNotes[i];
	double dNoteL = dpText.textLengthForStyle(stNote, psDimstyle);
	String stNoteLines[0];
	Point3d ptNote = ptNoteTL + vRow/2 + vX * pdExtraWidth/2;
	if (dNoteSpace < dNoteL) //__need to split into multiple lines
	{
		String stLine;
		for(int k=0; k<400; k++)
		{
			String st = stNote.token(k, stSeperators);
			if (st == "") 
			{
				stNoteLines.append(stLine);
				break;
			}
			String stTemp = stLine + " " + st;
			double dLCheck = dpText.textLengthForStyle(stTemp, psDimstyle);
			if (dLCheck > dNoteSpace)
			{
				stNoteLines.append(stLine);
				stLine = st;
				continue;
			}
			stLine += " " + st;
		}
	}
	else
	{
		stNoteLines.append(stNote);
	}
	int iNumLines = stNoteLines.length();
	for (int k=0; k<iNumLines; k++)
	{
		dpText.draw(stNoteLines[k], ptNote, vX, vY, 1, 0);
		ptNote += vRow;
	}	
	
	//__draw box and then update TL location
	PLine plNote (ptNoteTL, ptNoteTL + vRow * iNumLines);
	plNote.addVertex(ptNoteTL + vRow * iNumLines + vX * dTableW);
	plNote.addVertex(ptNoteTL + vX * dTableW);
	dp.draw(plNote);
	ptNoteTL += vRow * iNumLines;
}	

//__Excel section will need to be reworked 
////___Enable export to Excel
//addRecalcTrigger(_kContext, "Export to Excel");
//if (_kExecuteKey == "Export to Excel");
//{			
//	String stExcelDllPath = _kPathHsbInstall + "\\Content\\NorthAmerica\\Dll\\MapToExcel\\TslMapToExcel.dll";
//	String stFileCheck = findFile(stExcelDllPath);
//	String stClassName = "TslMapToExcel.Export";
//	String stMethod = "WriteToExcel";
//	Map mpOut, mpSheet;
//	
//	
//	for (int i=0; i<mpData.length(); i++)
//	{
//		if (mpData.keyAt(i) != "mpRow") continue; 
//		mpSheet.appendMap("mpRow", mpData.getMap(i));
//	}
//	mpSheet.setInt("iStartRow", piStartRow);
//	if (psExcelSheet != "") mpSheet.setString("stSheetName", psExcelSheet);
//	mpOut.setMap("mpSheet",mpSheet);
//	if (psExportOption ==  "Drawing Folder") mpOut.setString("stExcelSavePath", _kPathDwg + "\\" +psTitleText + ".xls");
//	if (psExcelTemplatePath != "") mpOut.setString("stExcelTemplatePath", psExcelTemplatePath);
//	
//	Map mpReturned = callDotNetFunction2(stExcelDllPath, stClassName, stMethod, mpOut);	
//			
//	if (psTemplateOption == "Store Location") 
//	{
//		String stTemplatePath = mpReturned.getString("stExcelTemplatePath");
//		psExcelTemplatePath.set(stTemplatePath);
//	}
//}
		
		
		
double dTotalH = dTitleH + (mpRows.length() + 1) * dRowH;
Point3d ptBottomLeft = _Pt0 - vY * (dTotalH + U(.1, "inch"));

_Map.setPoint3d(stBottomLeftKey, ptBottomLeft);

ptBottomLeft.vis(1);

if(bHasFollower)
{ 	
	Entity entNext = _Map.getEntity(stNextTslKey);
	TslInst tsl = (TslInst)entNext;
	if(tsl.bIsValid())
	{ 		
		tsl.recalc();
	}
	else//__script might have been erased
	{ 
		_Map.removeAt(stNextTslKey, 1);
	}
}
		
_Map.setString(stLastElementKey, el.handle());
		
		
	
	


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
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Set column format fields to use formatting dialog. Added option to not perform formatting" />
      <int nm="MAJORVERSION" vl="0" />
      <int nm="MINORVERSION" vl="19" />
      <str nm="DATE" vl="10/4/2023 8:47:12 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Improved insertion routine" />
      <int nm="MAJORVERSION" vl="0" />
      <int nm="MINORVERSION" vl="18" />
      <str nm="DATE" vl="9/28/2023 1:37:17 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Bugfix in string=&gt;double conversion" />
      <int nm="MAJORVERSION" vl="0" />
      <int nm="MINORVERSION" vl="16" />
      <str nm="DATE" vl="9/26/2023 9:06:27 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Updated labelling trigger again" />
      <int nm="MAJORVERSION" vl="0" />
      <int nm="MINORVERSION" vl="14" />
      <str nm="DATE" vl="9/25/2023 8:04:45 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Added setting to trigger labeler script" />
      <int nm="MAJORVERSION" vl="0" />
      <int nm="MINORVERSION" vl="12" />
      <str nm="DATE" vl="9/25/2023 6:11:19 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End