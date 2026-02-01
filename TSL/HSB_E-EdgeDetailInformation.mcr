#Version 8
#BeginDescription
Last modified by: Anno Sportel (support.nl@hsbcad.com)
31.10.2018  -  version 1.02
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
/// This tsl displays edge detail information 
/// </summary>

/// <insert>
/// -
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.01" date="31.10.2018"></version>

/// <history>
/// AS - 1.00 - 07.09.2018-	First revision
/// AS - 1.01 - 31.10.2018-	Improve insert. Automatically insert multiple instances if no edge is selected.
/// </history>

String fileName = _kPathHsbCompany + "\\Tsl\\Settings\\EdgeInformationConfigurations.xml";

String doubleClickAction = "TslDoubleClick";
String reloadEdgeInformationConfigurationsCommand = T("|Reload edge information configurations|");
String recalcTriggers[] = 
{
	reloadEdgeInformationConfigurationsCommand
};
for (int r=0;r<recalcTriggers.length();r++)
{
	addRecalcTrigger(_kContext, recalcTriggers[r]);
}

//region LoadConfigurations

String edgeInformationConfigurationsKey = "EdgeInformationConfiguration[]";
String edgeInformationConfigurationKey = "EdgeInformationConfiguration";
String configurationNameKey = "Name";
String edgeInformationsKey = "EdgeInformation[]";
String edgeInformationKey = "EdgeInformation";
String textKey = "Text";
String textAlignmentKey = "Alignment";
String zoneIndexKey = "ZoneIndex";
String rowIndexKey = "RowIndex";

if (findFile(fileName) == "")
{
	int folderExists = makeFolder(_kPathHsbCompany + "\\Tsl\\Settings");
	if (!folderExists)
	{
		reportError(T("|Folder does not exist.|\n") + _kPathHsbCompany + "\\Tsl\\Settings");
		eraseInstance();
		return;
	}
	
	// ***********************************************************
	// Default set of edge information configurations.
	// ***********************************************************
	Map edgeInformationConfigurations;
	edgeInformationConfigurations.setMapKey(edgeInformationConfigurationsKey);
	
	Map edgeInformationConfiguration;
	edgeInformationConfiguration.setString(configurationNameKey, "Example Config");
	Map edgeInformations;
	Map edgeInformation;
	edgeInformation.setString(textKey, "This left aligned text is displayed at the edge for zone 0.");
	edgeInformation.setInt(textAlignmentKey, -1);
	edgeInformation.setInt(zoneIndexKey, 0);
	edgeInformation.setInt(rowIndexKey, 0);
	edgeInformations.appendMap(edgeInformationKey, edgeInformation);
	edgeInformation.setString(textKey, "This left aligned text is displayed at the edge for zone 0, at row 1.");
	edgeInformation.setInt(textAlignmentKey, -1);
	edgeInformation.setInt(zoneIndexKey, 0);
	edgeInformation.setInt(rowIndexKey, 1);
	edgeInformations.appendMap(edgeInformationKey, edgeInformation);
	edgeInformation.setString(textKey, "This left aligned text is displayed at the edge for zone 1.");
	edgeInformation.setInt(textAlignmentKey, -1);
	edgeInformation.setInt(zoneIndexKey, 1);
	edgeInformation.setInt(rowIndexKey, 0);
	edgeInformations.appendMap(edgeInformationKey, edgeInformation);
	edgeInformation.setString(textKey, "This right aligned text is displayed at the edge for zone 1.");
	edgeInformation.setInt(textAlignmentKey, 1);
	edgeInformation.setInt(zoneIndexKey, 1);
	edgeInformation.setInt(rowIndexKey, 0);
	edgeInformations.appendMap(edgeInformationKey, edgeInformation);
	edgeInformationConfiguration.setMap(edgeInformationsKey, edgeInformations);
	edgeInformationConfigurations.appendMap(edgeInformationConfigurationKey, edgeInformationConfiguration);
	
	int writtenSuccessfully = edgeInformationConfigurations.writeToXmlFile(fileName);
	
	reportMessage(TN("|Default edge information configurations created|: ") + fileName + ".");
}
// Load configurations
String dictionary = "tslDict";
String entry = "EdgeInformationConfigurations";
MapObject edgeInformationConfigurationsDictionary(dictionary, entry);

if (!edgeInformationConfigurationsDictionary.bIsValid())
{
	if (findFile(fileName).length()<4)
	{
		reportMessage("\n**********" + scriptName() + "**********\n" + 
			T("|The edge information configuration file|") +"\n" + fileName + "\n" + T("|could not be found.|") + "\n" + T("|The tsl| ") + scriptName() + T(" |will be deleted.|"));
			reportMessage("\n*************************************");
		eraseInstance();
		return;
	}
	
	Map map;
	map.readFromXmlFile(fileName);
	edgeInformationConfigurationsDictionary.dbCreate(map);
	
	reportMessage("\n**********" + scriptName() + "**********\n" + 
		T("|The edge information configuration file|") +"\n" + fileName + "\n" + T("|is loaded in the drawing.|"));
}
if (_kExecuteKey == reloadEdgeInformationConfigurationsCommand)
{
	
	if (findFile(fileName).length()<4)
	{
		reportMessage("\n**********" + scriptName() + "**********\n" + 
			T("|The edge information configuration file|") +"\n" + fileName + "\n" + T("|could not be found and is NOT reloaded.|"));
			reportMessage("\n*************************************");
	}
	else
	{
		int folderExists = makeFolder(_kPathAppData + "\\hsbCAD\\tsl\\Settings");
		String timeStamp = String().formatTime("%Y%m%d-%H%M");
		String backupFileName = _kPathAppData + "\\hsbCAD\\tsl\\Settings\\EdgeInformationConfigurations_" + timeStamp + ".xml";
		Map existingConfiguration = edgeInformationConfigurationsDictionary.map();
		existingConfiguration.writeToXmlFile(backupFileName);
		
		Map map;
		map.readFromXmlFile(fileName);
		edgeInformationConfigurationsDictionary.setMap(map);
		
		reportMessage("\n**********" + scriptName() + "**********\n" + 
			T("|The edge information configuration file|") +"\n" + fileName + "\n" + T("|is reloaded in the drawing.|"));
	}
}

Map edgeInformationConfigurations = edgeInformationConfigurationsDictionary.map();

// Currently the tsl only supports one edgeInformation configuration. We will take the first one specified in the dictionary.
Map edgeInformationConfiguration;
for (int t=0;t<edgeInformationConfigurations.length();t++)
{
	if (edgeInformationConfigurations.keyAt(t) != edgeInformationConfigurationKey || !edgeInformationConfigurations.hasMap(t)) continue;
	
	edgeInformationConfiguration = edgeInformationConfigurations.getMap(edgeInformationConfigurationKey);
	
}

if (edgeInformationConfiguration.length() == 0)
{
	reportWarning(TN("|There is no valid edgeInformation configuration available.|"));
	eraseInstance();
	return;
}

String configurationNames[0];
Map edgeInformationSets[0];

for (int c=0;c<edgeInformationConfigurations.length();c++)
{
	if (edgeInformationConfigurations.keyAt(c) != edgeInformationConfigurationKey || !edgeInformationConfigurations.hasMap(c)) continue;
	
	Map edgeInformationConfiguration = edgeInformationConfigurations.getMap(c);
	configurationNames.append(edgeInformationConfiguration.getString(configurationNameKey));
	edgeInformationSets.append(edgeInformationConfiguration.getMap(edgeInformationsKey));
}
//endregion


String sortedDimensionStyles[0];
sortedDimensionStyles.append(_DimStyles);
for(int s1=1;s1<sortedDimensionStyles.length();s1++)
{
	int s11 = s1;
	for(int s2=s1-1;s2>=0;s2--)
	{
		String sA = sortedDimensionStyles[s11];
		sA.makeUpper();
		String sB = sortedDimensionStyles[s2];
		sB.makeUpper();
		if( sA < sB )
		{
			sortedDimensionStyles.swap(s2, s11);
			s11=s2;
		}
	}
}

String category = T("|Edge configuration|");
PropString selectedEdgeConfiguration(0, configurationNames, T("|Configuration name|"));
selectedEdgeConfiguration.setCategory(category);



category = T("|Position and Style|");
PropDouble offsetFromEdge(0, U(0), T("|Offset from edge|"));
offsetFromEdge.setCategory(category);

PropDouble horizontalOffset(1, U(0), T("|Horizontal text offset|"));
horizontalOffset.setCategory(category);

PropDouble textSize(2, U(-1), T("|Text size|"));
textSize.setCategory(category);

PropInt textColor(0, -1, T("|Text color|"));
textColor.setCategory(category);

String noYes[] = { T("|No|"), T("|Yes|")};
PropString onlyViewInElementElevationViewProp(4, noYes, T("|Only show in elevation view|"), 1);
onlyViewInElementElevationViewProp.setCategory(category);


category = T("|Detail|");
PropString detailName(1, "@(VAR60)", T("|Detail name|"));
detailName.setCategory(category);

PropString dimStyleDetailName(3, sortedDimensionStyles, T("|Dimension style detail name|"));
dimStyleDetailName.setCategory(category);

PropDouble textSizeDetail(3, U(-1), T("|Text size detail|"));
textSizeDetail.setCategory(category);

PropInt detailColor(1, -1, T("|Detail color|"));
detailColor.setCategory(category);

String detailLeaders[] = 
{
	T("|No leader|"),
	T("|Line|"),
	T("|Circle|"),
	T("|Line with circle|")
};
PropString detailLeader(2, detailLeaders, T("|Detail leader|"));
detailLeader.setCategory(category);

PropDouble lineLength(4, U(300), T("|Line length|"));
lineLength.setCategory(category);

// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if (_kExecuteKey != "" && catalogNames.find(_kExecuteKey) != -1) 
{
	setPropValuesFromCatalog(_kExecuteKey);
}
	
// Only allow insert to create and edit the catalog entries. Show a warning and erase tsl after the dialog has closed.
if (_bOnInsert)
{
	if (insertCycleCount() > 1) 
	{
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || catalogNames.find(_kExecuteKey) == -1 )
	{
		showDialog();
	}
	setCatalogFromPropValues(T("|_LastInserted|"));
	
	PrEntity elementSelectionSet(T("|Select one or more elements|"), ElementWallSF());
	elementSelectionSet.addAllowedClass(ElementRoof());
	Element selectedElements[0];
	if (elementSelectionSet.go())
	{
		selectedElements = elementSelectionSet.elementSet();
	}
			
	String strScriptName = scriptName();
	Vector3d vecUcsX(1,0,0);
	Vector3d vecUcsY(0,1,0);
	Beam lstBeams[0];
	Entity lstEntities[1];
	
	Point3d lstPoints[3];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	Map mapTsl;
	mapTsl.setInt("ManualInserted", true);
	
	for (int e = 0; e < selectedElements.length(); e++)
	{
		Element selectedElement = selectedElements[e];
		
		LineSeg edges[0];
		String constructionDetails[0];
		if (selectedElement.bIsKindOf(ElementWallSF()))
		{
			PLine elementOutline = selectedElement.plEnvelope();
			// TODO: Check direction of outline.
			
			Point3d outlineVertices[] = elementOutline.vertexPoints(false);
			
			for (int v = 0; v < (outlineVertices.length() - 1); v++)
			{
				Point3d from = outlineVertices[v];
				Point3d to = outlineVertices[v + 1];
				
				edges.append(LineSeg(from, to));
				constructionDetails.append("");
			}
		}
		if (selectedElement.bIsKindOf(ElementRoof()))
		{
			ElementRoof roofElement = (ElementRoof)selectedElement;
			ElemRoofEdge roofEdges[] = roofElement.elemRoofEdges();
			for (int e = 0; e < roofEdges.length(); e++)
			{
				ElemRoofEdge roofEdge = roofEdges[e];
				
				Point3d from = roofEdge.ptNode();
				Point3d to = roofEdge.ptNodeOther();
				if (roofEdge.vecDir().dotProduct(to - from) < 0)
				{
					from = roofEdge.ptNodeOther();
					to = roofEdge.ptNode();
				}
				
				edges.append(LineSeg(from, to));
				constructionDetails.append(roofEdge.constrDetail());
			}
		}
		
		Point3d edgePositions[0];
		if (selectedElements.length() == 1)
		{
			PrPoint ssPoint(T("|Select edge|") + T("<|optional|>"));
			if (ssPoint.go() == _kOk)
			{
				Point3d pointAtEdge = ssPoint.value();
				pointAtEdge = Plane(selectedElement.ptOrg(), selectedElement.vecZ()).closestPointTo(pointAtEdge);
				edgePositions.append(pointAtEdge);
			}
			else
			{
				reportMessage(TN("|No edge selected.|") + T("|Automatically pick all edges.|"));
			}
		}
		if (edgePositions.length() == 0)
		{
			for (int i = 0; i < edges.length(); i++)
			{
				edgePositions.append(edges[i].ptMid());
			}
		}
		
		lstEntities[0] = selectedElement;
		for (int p = 0; p < edgePositions.length(); p++)
		{
			Point3d edgePosition = edgePositions[p];
			Point3d startDetail, endDetail;
			String detail;
			double distanceToEdge = U(50000);
			
			for (int e = 0; e < edges.length(); e++)
			{
				LineSeg edge = edges[e];
				String constructionDetail = constructionDetails[e];
				Point3d from = edge.ptStart();
				Point3d to = edge.ptEnd();
				
				PLine pl(from, to);
				Point3d projectedPoint = pl.closestPointTo(edgePosition);
				
				double offsetFromEdge = Vector3d(edgePosition - projectedPoint).length();
				if (offsetFromEdge < distanceToEdge)
				{
					distanceToEdge = offsetFromEdge;
					startDetail = from;
					endDetail = to;
					detail = constructionDetail;
				}
			}
			
			Vector3d edgeDirection(endDetail - startDetail);
			edgeDirection.normalize();
			
			edgePosition += edgeDirection * edgeDirection.dotProduct((startDetail + endDetail) / 2 - edgePosition);
			
			Line lineAtEdge(startDetail, edgeDirection);
			Line lineOffsettedFromEdge(edgePosition, edgeDirection);
			
			lstPoints.setLength(0);
			lstPoints.append(lineOffsettedFromEdge.closestPointTo(startDetail));
			lstPoints.append(lineOffsettedFromEdge.closestPointTo(endDetail));
			lstPoints.append(lineAtEdge.closestPointTo(edgePosition));
			
			TslInst tslNew;
			tslNew.dbCreate(strScriptName, vecUcsX, vecUcsY, lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
			
			Map detailMap;
			int success = detailMap.setDxContent(detail, true);
			if ( ! success)
			{
				reportWarning(scriptName() + T(" - |Element| ") + selectedElement.number() +
				TN("|Could not convert detail string to map.|") + "\n" + detail);
				eraseInstance();
				return;
			}
			
			if (detailName.left(5) == "@(VAR")
			{
				int variableIndex = detailName.mid(5, detailName.length() - 6).atoi() - 1;
				
				String resolvedName = detailName;
				if (detailMap.hasDouble("DVAR" + variableIndex))
				{
					resolvedName = detailMap.getDouble("DVAR" + variableIndex);
				}
				else if (detailMap.hasString("STRVAR" + variableIndex))
				{
					resolvedName = detailMap.getString("STRVAR" + variableIndex);
				}
				
				// Set the resolved name. It remains unresolved if it couldn't find it in the detailMap.
				tslNew.setPropString(1, resolvedName);
			}
		}
	}
	
	eraseInstance();
	return;
}

if (_Element.length() == 0) 
{	
	reportWarning(T("|invalid or no element selected.|"));
	eraseInstance();
	return;
}

int manualInserted = false;
if (_Map.hasInt("ManualInserted")) 
{
	manualInserted = _Map.getInt("ManualInserted");
	_Map.removeAt("ManualInserted", true);
}

if (_PtG.length() == 0) 
{
	reportMessage("\n" + scriptName() + ": " +T("|No grippoints found. TSL will be erased|"));
	eraseInstance();
	return;
}

Vector3d edgeNormal = -_Element[0].vecY();
if (_kNameLastChangedProp == T("|Offset from edge|"))
{
	_Pt0 += edgeNormal * edgeNormal.dotProduct((_PtG[0] + edgeNormal * offsetFromEdge) - _Pt0);
}

_Pt0.vis(1);
for (int i=0;i<_PtG.length();i++)
{
	_PtG[i].vis(2+i);
}

if (_PtG.length() < 2)
{
	_PtG.append((_Pt0 + _PtG[0])/2);
}

if (_Map.hasPoint3d("PtG0") && _Map.hasPoint3d("PtG1")) 
{
	// Reset the grippoints to the detail line.
	_PtG[0] = _Map.getPoint3d("PtG0");
	_PtG[1] = _Map.getPoint3d("PtG1");
}
else 
{
	// Reorganize the points passed in through the generator. 
	// _Pt0 muts become the anchor for the text. The grippoints will be the 2 points on the detail line.
	Point3d ptOrg = _PtG[1];
	Point3d ptGrip0 = _Pt0;
	Point3d ptGrip1 = _PtG[0];

	Vector3d vLn(ptGrip0 - ptGrip1);
	vLn.normalize();
	Line lnDetail(ptOrg, vLn);
	Line lnText(ptGrip0, vLn);
	
	ptGrip0 = lnDetail.closestPointTo(ptGrip0);
	ptGrip1 = lnDetail.closestPointTo(ptGrip1);
	ptOrg = lnText.closestPointTo(ptOrg);
	
	// Store the points on the detail line.
	_Map.setPoint3d("PtG0", ptGrip0, _kAbsolute);
	_Map.setPoint3d("PtG1", ptGrip1, _kAbsolute);
	
	// Set _Pt0 to the text position and the grippoints to the start and end of the detail.
	_Pt0 = ptOrg;
	_PtG[0] = ptGrip0;
	_PtG[1] = ptGrip1;
}

// Set properties from dsp
int setPropsFromDspVariableIndex = -1;
if( _Map.hasString("DspToTsl") )
{
	String catalogName;
	String argumentFromDsp = _Map.getString("DspToTsl");
	if( argumentFromDsp.left(3).makeUpper() == "VAR" )
	{
		setPropsFromDspVariableIndex = argumentFromDsp.right(argumentFromDsp.length() - 3).atoi();
	}
	else
	{
		catalogName = argumentFromDsp;
		if (catalogName == "" ) 
		{
			reportMessage("\n" + scriptName() + ": " +T("|No catalogname specified|"));
			eraseInstance();
			return;
		}
		
		setPropValuesFromCatalog(catalogName);
	}

	_Map.removeAt("DspToTsl", true);
}

// If manually inserted we set the properties as they were entered during insert.
if (_bOnDbCreated && manualInserted)
{
	setPropValuesFromCatalog(T("|_LastInserted|"));
}

Element el = _Element[0];
assignToElementGroup(el, true, 0, 'E');

CoordSys elementCoordSys = el.coordSys();
Point3d elOrg = elementCoordSys.ptOrg();
Vector3d elX = elementCoordSys.vecX();
Vector3d elY = elementCoordSys.vecY();
Vector3d elZ = elementCoordSys.vecZ();

Vector3d edgeX(_PtG[1] - _PtG[0]);
edgeX.normalize();
Vector3d edgeZ = elZ;
Vector3d edgeY = edgeZ.crossProduct(edgeX);

edgeX.vis(_Pt0, 1);
edgeY.vis(_Pt0, 3);
edgeZ.vis(_Pt0, 150);

int configurationIndex = configurationNames.find(selectedEdgeConfiguration);
if (configurationIndex == -1)
{
	reportWarning(T("|Please select a valid configuration!|"));
	return;
}

Map edgeInformationSet = edgeInformationSets[configurationIndex];
String texts[0];
int alignments[0];
int zoneIndexes[0];
int rowIndexes[0];
for (int m=0;m<edgeInformationSet.length();m++)
{
	if (edgeInformationSet.keyAt(m) != edgeInformationKey || !edgeInformationSet.hasMap(m)) continue;
	
	Map edgeInformation = edgeInformationSet.getMap(m);
	texts.append(edgeInformation.getString(textKey));
	alignments.append(edgeInformation.getInt(textAlignmentKey));
	zoneIndexes.append(edgeInformation.getInt(zoneIndexKey));
	rowIndexes.append(edgeInformation.getInt(rowIndexKey));
}

Vector3d textX = edgeX;
Vector3d textY = edgeY;
if (textY.dotProduct(-elX + elY) < 0)
{
	textX *= -1;
	textY *= -1;
}

int onlyViewInElementElevationView = noYes.find(onlyViewInElementElevationViewProp, 1);

int leaderIndex = detailLeaders.find(detailLeader, 0);

int drawDetailLine = (leaderIndex == 1) || (leaderIndex == 3);
int drawDetailCircle = (leaderIndex == 2) || (leaderIndex == 3);

Display detailDisplay(detailColor);
detailDisplay.dimStyle(dimStyleDetailName);
double sizeFactor = 1;
if (textSizeDetail > 0)
{
	detailDisplay.textHeight(textSizeDetail);
	
	sizeFactor = textSizeDetail / detailDisplay.textHeightForStyle("HSB", dimStyleDetailName);
}
detailDisplay.elemZone(el, 0, 'I');
detailDisplay.showInDxa(true);
if (onlyViewInElementElevationView)
{
	detailDisplay.addViewDirection(elZ);
	detailDisplay.addViewDirection(-elZ);
}

double yFlag = edgeY.dotProduct(textY) < 0 ? -1 : 1;

detailDisplay.draw(detailName, _Pt0, textX, textY, 0, yFlag, _kDevice);
double heightDetailNumber = detailDisplay.textHeightForStyle(detailName, dimStyleDetailName) * sizeFactor;
double lengthDetailNumber = detailDisplay.textLengthForStyle(detailName, dimStyleDetailName) * sizeFactor;
double detailSize = (lengthDetailNumber > heightDetailNumber) ? lengthDetailNumber : heightDetailNumber;

double startOffsetLine = 0.5 * heightDetailNumber;
if (drawDetailCircle)
{
	Point3d center = _Pt0  + edgeY * 0.5 * heightDetailNumber;
	double radius = 0.65 * detailSize;
	startOffsetLine = radius - 0.5 * heightDetailNumber;
	PLine circle(edgeZ);
	circle.createCircle(center, edgeZ, radius);
	detailDisplay.draw(circle);
}
if (drawDetailLine)
{
	Point3d start = _Pt0 - edgeY * startOffsetLine;
	PLine line(edgeZ);
	line.addVertex(start);
	line.addVertex(start - edgeY * lineLength);
	detailDisplay.draw(line);
}

double defaultTextOffsetX = U(250);

for (int t=0;t<texts.length();t++)
{
	String text = texts[t];
	int alignment = alignments[t];
	int zoneIndex = zoneIndexes[t];
	int rowIndex = rowIndexes[t];
	
	Display textDisplay(textColor);
	if (textSize > 0)
	{
		textDisplay.textHeight(textSize);
	}
	textDisplay.elemZone(el, zoneIndex, 'I');
	textDisplay.showInDxa(true);
	textDisplay.addViewDirection(elZ);
	textDisplay.addViewDirection(-elZ);
	
	textDisplay.draw(text, _Pt0 + textX * alignment * 0.5 * defaultTextOffsetX, textX, textY, alignment, (-1 - rowIndex * 3), _kDevice);
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
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End