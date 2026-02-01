#Version 8
#BeginDescription
Last modified by: Anno Sportel (support.nl@hsbcad.com)
12.09.2018  -  version 1.02
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl creates naillines for the different materials.
/// </summary>

/// <insert>
/// -
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.00" date="03.09.2018"></version>

/// <history>
/// AS - 1.00 - 03.09.2018-	First revision
/// AS - 1.01 - 07.09.2018-	Support different shapes.
/// AS - 1.02 - 12.09.2018-	Show table.
/// </history>

double vectorTolerance = Unit(0.01, "mm");
double pointTolerance = U(0.01);

String deleteCommand = T("|Delete|");

String fileName = _kPathHsbCompany + "\\Tsl\\Settings\\ProductionRateConfigurations.xml";

String doubleClickAction = "TslDoubleClick";
String reloadProductionRateConfigurationsCommand = T("|Reload production rate configurations|");
String recalcTriggers[] = 
{
	reloadProductionRateConfigurationsCommand
};
for (int r=0;r<recalcTriggers.length();r++)
{
	addRecalcTrigger(_kContext, recalcTriggers[r]);
}

//region LoadConfigurations
String productionRateConfigurationsKey = "ProductionRateConfiguration[]";
String productionRateConfigurationKey = "ProductionRateConfiguration";
String shapesKey = "Shape[]";
String shapeKey = "Shape";
String additionsKey = "Addition[]";
String additionKey = "Addition";
String nameKey = "Name";
String rateKey = "Rate"; 
String unitsKey = "Units";

String hoursPerMeterSquared = "h/m2";

String rectangle = "Rectangle";
String triangle = "Triangle";
String internalValley = "Internal valley";
String hip = "Hip";
String valley = "Valley";
String defaultShape = "Default";

String productionDataMapKey = "hsb_ProductionData";
String productionEstimateKey = "ProductionEstimate";

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
	// Default set of production rate configurations.
	// ***********************************************************
	Map productionRateConfigurations;
	productionRateConfigurations.setMapKey(productionRateConfigurationsKey);
	
	{ // Default production rates.
		Map productionRateConfiguration;
		productionRateConfiguration.setString(nameKey, "Default Production Rates");
		Map shapes;
		Map shape;
		// Rectangle
		shape.setString(nameKey, rectangle);
		shape.setDouble(rateKey, 0.25);
		shape.setString(unitsKey, hoursPerMeterSquared);
		shapes.appendMap(shapeKey, shape);
		// Triangle
		shape.setString(nameKey, triangle);
		shape.setDouble(rateKey, 0.70);
		shape.setString(unitsKey, hoursPerMeterSquared);
		shapes.appendMap(shapeKey, shape);
		// Hip
		shape.setString(nameKey, hip);
		shape.setDouble(rateKey, 0.40);
		shape.setString(unitsKey, hoursPerMeterSquared);
		shapes.appendMap(shapeKey, shape);
		// Valley
		shape.setString(nameKey, valley);
		shape.setDouble(rateKey, 0.45);
		shape.setString(unitsKey, hoursPerMeterSquared);
		shapes.appendMap(shapeKey, shape);
		// Internal valley
		shape.setString(nameKey, internalValley);
		shape.setDouble(rateKey, 0.90);
		shape.setString(unitsKey, hoursPerMeterSquared);
		shapes.appendMap(shapeKey, shape);
		// Default
		shape.setString(nameKey, defaultShape);
		shape.setDouble(rateKey, 0.75);
		shape.setString(unitsKey, hoursPerMeterSquared);
		shapes.appendMap(shapeKey, shape);
		productionRateConfiguration.setMap(shapesKey, shapes);
		Map additions;
		Map addition;
		additions.appendMap(additionKey, addition);
		productionRateConfiguration.setMap(additionsKey, additions);
		productionRateConfigurations.appendMap(productionRateConfigurationKey, productionRateConfiguration);
	}
	{ // A&T default production rates.
		Map productionRateConfiguration;
		productionRateConfiguration.setString(nameKey, "A&T Default Production Rates");
		Map shapes;
		Map shape;
		// Rectangle
		shape.setString(nameKey, rectangle);
		shape.setDouble(rateKey, 0.20);
		shape.setString(unitsKey, hoursPerMeterSquared);
		shapes.appendMap(shapeKey, shape);
		// Triangle
		shape.setString(nameKey, triangle);
		shape.setDouble(rateKey, 0.80);
		shape.setString(unitsKey, hoursPerMeterSquared);
		shapes.appendMap(shapeKey, shape);
		// Hip
		shape.setString(nameKey, hip);
		shape.setDouble(rateKey, 0.50);
		shape.setString(unitsKey, hoursPerMeterSquared);
		shapes.appendMap(shapeKey, shape);
		// Valley
		shape.setString(nameKey, valley);
		shape.setDouble(rateKey, 0.50);
		shape.setString(unitsKey, hoursPerMeterSquared);
		shapes.appendMap(shapeKey, shape);
		// Internal valley
		shape.setString(nameKey, internalValley);
		shape.setDouble(rateKey, 0.65);
		shape.setString(unitsKey, hoursPerMeterSquared);
		shapes.appendMap(shapeKey, shape);
		// Default
		shape.setString(nameKey, defaultShape);
		shape.setDouble(rateKey, 0.50);
		shape.setString(unitsKey, hoursPerMeterSquared);
		shapes.appendMap(shapeKey, shape);
		productionRateConfiguration.setMap(shapesKey, shapes);
		Map additions;
		Map addition;
		additions.appendMap(additionKey, addition);
		productionRateConfiguration.setMap(additionsKey, additions);
		productionRateConfigurations.appendMap(productionRateConfigurationKey, productionRateConfiguration);
	}

	int writtenSuccessfully = productionRateConfigurations.writeToXmlFile(fileName);
	
	reportMessage(TN("|Default production rate configurations created|: ") + fileName);
}
// Load configurations
String dictionary = "tslDict";
String entry = "ProductionRateConfigurations";
MapObject productionRateConfigurationsDictionary(dictionary, entry);

if (!productionRateConfigurationsDictionary.bIsValid())
{
	if (findFile(fileName).length()<4)
	{
		reportMessage("\n**********" + scriptName() + "**********\n" + 
			T("|The production rate configuration file|") +"\n" + fileName + "\n" + T("|could not be found.|") + "\n" + T("|The tsl| ") + scriptName() + T(" |will be deleted.|"));
			reportMessage("\n*************************************");
		eraseInstance();
		return;
	}
	
	Map map;
	map.readFromXmlFile(fileName);
	productionRateConfigurationsDictionary.dbCreate(map);
	
	reportMessage("\n**********" + scriptName() + "**********\n" + 
		T("|The production rate configuration file|") +"\n" + fileName + "\n" + T("|is loaded in the drawing.|"));
}
if (_kExecuteKey == reloadProductionRateConfigurationsCommand)
{
	if (findFile(fileName).length()<4)
	{
		reportMessage("\n**********" + scriptName() + "**********\n" + 
			T("|The production rate configuration file|") +"\n" + fileName + "\n" + T("|could not be found and is NOT reloaded.|"));
			reportMessage("\n*************************************");
	}
	else
	{
		Map map;
		map.readFromXmlFile(fileName);
		productionRateConfigurationsDictionary.setMap(map);
		
		reportMessage("\n**********" + scriptName() + "**********\n" + 
			T("|The production rate configuration file|") +"\n" + fileName + "\n" + T("|is reloaded in the drawing.|"));
	}
}

Map productionRateConfigurations = productionRateConfigurationsDictionary.map();

// Currently the tsl only supports one productionRate configuration. We will take the first one specified in the dictionary.
Map productionRateConfigurationMaps[0];
String productionRateConfigurationNames[0];
for (int t=0;t<productionRateConfigurations.length();t++)
{
	if (productionRateConfigurations.keyAt(t) != productionRateConfigurationKey || !productionRateConfigurations.hasMap(t))
	{
		productionRateConfigurations.removeAt(t, true);
		t--;
		continue;
	}
	Map productionRateConfigurationMap = productionRateConfigurations.getMap(t);
	productionRateConfigurationMaps.append(productionRateConfigurationMap);
	productionRateConfigurationNames.append(productionRateConfigurationMap.getString(nameKey));
}

String category = T("|General|");
PropString productionRateConfigurationName(0, productionRateConfigurationNames, T("|Production rate configuration|"), 0);
productionRateConfigurationName.setDescription(T("|Specifies the production rate configuration to use.|"));
productionRateConfigurationName.setCategory(category);

// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if( catalogNames.find(_kExecuteKey) != -1 ) 
{
	setPropValuesFromCatalog(_kExecuteKey);
}

if (_bOnInsert)
{
	if (insertCycleCount() > 1)
	{
		eraseInstance();
		return;
	}
	
	if ( _kExecuteKey == "" || catalogNames.find(_kExecuteKey) == -1 )
	{
		showDialog();
	}

	_Pt0 = getPoint(T("|Select a position|"));
	
	return;
}

int productionRateConfigurationIndex = productionRateConfigurationNames.find(productionRateConfigurationName, 0);
if (productionRateConfigurationIndex == -1)
{
	reportWarning(TN("|The selected production rate configuration could not be found|: '") + productionRateConfigurationName +"'.");
	eraseInstance();
	return;
}

// Get the selected configuration.
Map productionRateConfiguration = productionRateConfigurationMaps[productionRateConfigurationIndex];
if (productionRateConfiguration.length() == 0)
{
	reportWarning(TN("|The selected production rate configuration is invalid|: '") + productionRateConfigurationName +"'.");
	eraseInstance();
	return;
}

// Collect the production rates from the selected configuration.
String shapeNames[0];
double shapeProductionRates[0];
String shapeProductionRateUnits[0];
Map shapeMaps = productionRateConfiguration.getMap(shapesKey);
for (int s = 0; s < shapeMaps.length(); s++)
{
	Map shapeMap = shapeMaps.getMap(s);
	shapeNames.append(shapeMap.getString(nameKey));
	shapeProductionRates.append(shapeMap.getDouble(rateKey));
	shapeProductionRateUnits.append(shapeMap.getString(unitsKey));
}

String additionNames[0];
double additionProductionRates[0];
String additionProductionRateUnits[0];
Map additionMaps = productionRateConfiguration.getMap(additionsKey);
for (int a = 0; a < additionMaps.length(); a++)
{
	Map additionMap = additionMaps.getMap(a);
	additionNames.append(additionMap.getString(nameKey));
	additionProductionRates.append(additionMap.getDouble(rateKey));
	additionProductionRateUnits.append(additionMap.getString(unitsKey));
}
//endregion

// Collect all elements in the drawing and calculate an estimated production time for the element.
// This calculation is a two step calculation. The first part of the estimated time is based on the shape of the element. 
// The second part is a result of additional work required for e.g. a dormer, skylight, electrical installations, etc.

Entity allElements[] = Group().collectEntities(true, Element(), _kModelSpace);

Element elements[0];
String elementShapes[0];
double elementShapeRates[0];
double elementAreas[0];
double elementProductionEstimates[0];

for (int e=0;e<allElements.length();e++)
{
	Element el = (Element)allElements[e];
	
	if (!el.bIsValid()) continue;
	
	CoordSys csEl = el.coordSys();
	Vector3d elX = csEl.vecX();
	Vector3d elY = csEl.vecY();
	Vector3d elZ = csEl.vecZ();
	
	PLine elementOutline = el.plEnvelope();
	elementOutline.vis(e);
	
	Point3d elementOutlineVertices[] = elementOutline.vertexPoints(false);
	int numberOfVertices = elementOutlineVertices.length();
//	reportNotice("\n" + el.number() + " - " + numberOfVertices);// + "\n");

	if (numberOfVertices < 3) continue;
	
	// Check if the direction of the pline is anticlockwise.
	PlaneProfile outlineProfile(csEl);
	outlineProfile.joinRing(elementOutline, _kAdd);
	Point3d first = elementOutlineVertices[0];
	Point3d second = elementOutlineVertices[1];
	Point3d midFirstEdge = (first + second) / 2;
	Vector3d direction(second - first);
	direction.normalize();
	Vector3d normal = elZ.crossProduct(direction);
	if (outlineProfile.pointInProfile(midFirstEdge + normal) != _kPointInProfile)
	{
		elementOutline.reverse();
		elementOutlineVertices = elementOutline.vertexPoints(false);
//		reportNotice("R");
	}
	
	// Add the second vertice. We need this to check the last corner.
	elementOutlineVertices.append(elementOutlineVertices[1]);
	
	String shape = defaultShape;
	if (numberOfVertices == 4)
	{
		shape = triangle;
	}
	else if (numberOfVertices > 4)
	{
		int allAnglesAre90 = true;
		int hasInternalAngledCorner = false;
		int hasHip = false;
		int hasValley = false;
		
		for (int v = 1; v < (elementOutlineVertices.length() - 1); v++)
		{
			Point3d prev = elementOutlineVertices[v - 1];
			Point3d this = elementOutlineVertices[v];
			Point3d next = elementOutlineVertices[v + 1];
			
			Vector3d toThis(this - prev);
			toThis.normalize();
			Vector3d fromThis(next - this);
			fromThis.normalize();
			
			// Has hip or valley?
			double edgeX = elX.dotProduct(toThis);
			double edgeY = elY.dotProduct(toThis);
			if (abs(edgeX) > vectorTolerance && abs(edgeY) > vectorTolerance)
			{
				if (edgeX > 0)
				{
					hasValley = true;
				}
				else
				{
					hasHip = true;
				}
			}
			
			double angle = round(toThis.angleTo(fromThis, elZ));
//			reportNotice("\t" + angle);
			
			if (angle == 90 || angle == 270) continue;
			
			allAnglesAre90 = false;
			
			// Internal angle?
			if (angle > 180)
			{
				hasInternalAngledCorner = true;
				continue;
			}
			
			// Hip or valley?
			if (hasHip)
			{
				shape = hip;
			}
			else if (hasValley)
			{
				shape = valley;
			}
		}
		
		if (allAnglesAre90)
		{
			shape = rectangle;
		}
		if (hasInternalAngledCorner)
		{
			shape = internalValley;
		}
	}
	
//	reportNotice("\t" + shape);
	elementShapes.append(shape);
	elements.append(el);
	
	int shapeIndex = shapeNames.find(shape);
	if (shapeIndex == -1)
	{
		reportNotice(TN("|Element| ") + el.number() + T(" |has an unknown shape|: ")+ shape);
	}
	double shapeRate = shapeProductionRates[shapeIndex];
	elementShapeRates.append(shapeRate);

	double elementArea = round(elementOutline.area() / 10000) / 100; // area in square meters, rounded by 2 decimals.
	elementAreas.append(elementArea);

//	reportNotice("\nRate: " + shapeRate + "\tArea: " + elementArea);
	
	double estimatedHours;
	String shapeProductionRateUnit = shapeProductionRateUnits[shapeIndex];
	if (shapeProductionRateUnit == hoursPerMeterSquared)
	{
		estimatedHours = shapeRate * elementArea;
	}
	elementProductionEstimates.append(estimatedHours);
	
	double estimatedMinutes = round(estimatedHours * 60);
//	reportNotice("\nEstimated minutes: " + estimatedMinutes);

	Map productionDataMap = el.subMapX(productionDataMapKey);
	productionDataMap.setDouble(productionEstimateKey, estimatedMinutes);
	el.setSubMapX(productionDataMapKey, productionDataMap);
}


Display dp(1);
dp.textHeight(U(100));
Point3d celPosition = _Pt0;
Point3d tableStart = _Pt0;
double columnWidth = U(1000);
double columnHeight = U(125);

String headers[] = 
{
	T("|Element|"),
	T("|Shape|"),
	T("|Rate|"),
	T("|Area|"),
	T("|Estimate|")
};

for (int h=0;h<headers.length();h++)
{
	String header = headers[h];
	dp.draw(header, celPosition, _XW, _YW, 1, - 1);
	celPosition += _XW * columnWidth;	
}
celPosition = tableStart - _YW * columnHeight;

dp.color(-1);
for (int e=0;e<elements.length();e++)
{
	String elementNumber = elements[e].number();
	String elementShape = elementShapes[e];
	double elementShapeRate = elementShapeRates[e];
	double elementArea = elementAreas[e];
	double elementProductionEstimate = round(elementProductionEstimates[e] * 60);
	
	String contents[] = 
	{
		elementNumber,
		elementShape,
		(String)elementShapeRate,
		(String)elementArea,
		(String)elementProductionEstimate
	};
	for (int c = 0; c < contents.length(); c++)
	{
		String content = contents[c];
		dp.draw(content, celPosition, _XW, _YW, 1, - 1);
		celPosition += _XW * columnWidth;
	}
	celPosition = tableStart - _YW * (e+2) * columnHeight;
}
#End
#BeginThumbnail

#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="mpIDESettings">
    <dbl nm="PREVIEWTEXTHEIGHT" ut="N" vl="1" />
  </lst>
  <lst nm="mpTslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End