#Version 8
#BeginDescription
#Versions
V0.19 10/17/2023 Corrected genbeamOutline function
V0.18 10/16/2023 Added suport of dependant TSLs like NA_DIM_GENBEAMS_DIAGONAL
V0.17 10/10/2023 fixed negative zones selection bug
V0.16 10/3/2023 Added option to pack dimensioned beams/sheets to reduce the amount of points to dimension
V0.15 9/26/2023 Corrected closest edge point detection
V0.14 9/25/2023 Fixed bug with middle point




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 0
#MinorVersion 19
#KeyWords 
#BeginContents
_ThisInst.setAllowGripAtPt0(false);
setMarbleDiameter(4);
String languageKeys[] = { "en-US", "fr-CA"};
String currentLanguage = languageKeys[0];
String defaultLanguage = languageKeys[0];
String dimensionTypeName = "Genbeams at viewport side";
Map mapDimensionProperties = _Map.getMap(dimensionTypeName);
addRecalcTrigger(_kGripPointDrag, "_Grip");
int bGripsReset = false;
if (!_bOnGripPointDrag && _kNameLastChangedProp != "_Grip") {
	bGripsReset	= true;
	_Grip.setLength(0);
}

//region Drawing model data
//--------------- <Drawing model data> --- start
//---------------

String[] getPainterDefinitionNamesOfType(String inTypeName) {
	String painterDefinitionNamesFiltered[0];
	PainterDefinition painterDefinitionsAll[] = PainterDefinition().getAllEntries();
	for (int i=0; i<painterDefinitionsAll.length(); i++) {
		PainterDefinition& thisPainterDefinition = painterDefinitionsAll[i];
		String thisTypeName = thisPainterDefinition.type();
		if (thisTypeName == inTypeName) {
			painterDefinitionNamesFiltered.append(thisPainterDefinition.name());
		}
	}
	return painterDefinitionNamesFiltered.sorted();
}

String genbeamFilters[] = getPainterDefinitionNamesOfType("GenBeam");


//---------------
//--------------- <Drawing model data> --- end
//endregion

//region Insert routine
//--------------- <Insert routine> --- start
//---------------

if (_bOnInsert) {
	if (insertCycleCount()>1) {
		eraseInstance();
		return;
	}
	_Viewport.append(getViewport("\n" + "Select element viewport"));
}

//---------------
//--------------- <Insert routine> --- end
//endregion

//region Validation routine
//--------------- <Validation routine> --- start
//---------------

if (_Viewport.length()<1) {
	reportMessage("\n"+scriptName()+": "+"No valid viewport. Erasing this instance.");
	eraseInstance();
	return;
}

Viewport thisViewPort = _Viewport.first();
Element thisElement = thisViewPort.element();
if (!thisElement.bIsValid() && !_bOnInsert) {
	reportMessage("\n"+"No valid element in viewport");
	return;
}

//---------------
//--------------- <Validation routine> --- end
//endregion

//region Coordinate system data
//--------------- <Coordinate system data> --- start
//---------------

CoordSys modelToPaperTransformation = thisViewPort.coordSys();
CoordSys paperToModelTransformation = modelToPaperTransformation;
paperToModelTransformation.invert();
double viewportScale = paperToModelTransformation.scale();
Vector3d layoutXInModel = _XW;
layoutXInModel.transformBy(paperToModelTransformation);
layoutXInModel.normalize();
Vector3d layoutYInModel = _YW;
layoutYInModel.transformBy(paperToModelTransformation);
layoutYInModel.normalize();
Vector3d layoutZInModel = _ZW;
layoutZInModel.transformBy(paperToModelTransformation);
layoutZInModel.normalize();
 
int drawingIsMetric = U(1, "mm") == 1;
double drawingUnitsToMM(double distance)
{
	double convertionFactor = drawingIsMetric ? 1 : 25.4;
	return distance * convertionFactor;
}
double drawingUnitsToIN(double distance)
{
	double convertionFactor = drawingIsMetric ? 1/25.4 : 1;
	return distance * convertionFactor;
}
double mmToDrawingUnits(double distance)
{
	double convertionFactor = drawingIsMetric ? 1 : 1/25.4;
	return distance * convertionFactor;
}
double inToDrawingUnits(double distance)
{
	double convertionFactor = drawingIsMetric ? 25.4 : 1;
	return distance * convertionFactor;
}

//---------------
//--------------- <Coordinate system data> --- end
//endregion

//region Add triggers to context
//--------------- <Add triggers to context> --- start
//---------------

String callPropertiesTriggers[] = { "Edit dimension properties", "Modifier les propriétés de cote"};
String callPropertiesTrigger = callPropertiesTriggers[languageKeys.find(currentLanguage)];
addRecalcTrigger(_kContextRoot, callPropertiesTrigger);

String overridePropertiesTriggers[] = {"Add properties override for current element", "Ajouter un remplacement de propriétés pour l’élément actuel"};
String overridePropertiesTrigger = overridePropertiesTriggers[languageKeys.find(currentLanguage)];
addRecalcTrigger(_kContextRoot, overridePropertiesTrigger);

String removePropertiesOverrideTriggers[] = {"Remove properties override for current element", "Supprimer le remplacement de propriétés pour l’élément actuel"};
String removePropertiesOverrideTrigger = removePropertiesOverrideTriggers[languageKeys.find(currentLanguage)];
addRecalcTrigger(_kContextRoot, removePropertiesOverrideTrigger);

String resetGripPointsTriggers[] = {"Reset grip points for current element", "Réinitialiser les points de préhension pour l’élément actuel"};
String resetGripPointsTrigger = resetGripPointsTriggers[languageKeys.find(currentLanguage)];
addRecalcTrigger(_kContextRoot, resetGripPointsTrigger);

//---------------
//--------------- <Add triggers to context> --- end
//endregion

//region User selected values map
//--------------- <User selected values map> --- start
//---------------

int bIsOverride = false;
Map mapUserSelectedValues;
if (mapDimensionProperties.hasMap("UserSelectedValues"))
{
	mapUserSelectedValues = mapDimensionProperties.getMap("UserSelectedValues");
	
	if (thisElement.bIsValid() && mapDimensionProperties.hasMap("UserSelectedValues"+"~"+thisElement.handle())) {
		if (_kExecuteKey == removePropertiesOverrideTrigger) {
			mapDimensionProperties.removeAt("UserSelectedValues"+"~"+thisElement.handle(), false);
		}
		else {
			bIsOverride = true;
			mapUserSelectedValues = mapDimensionProperties.getMap("UserSelectedValues"+"~"+thisElement.handle());
		}
	} 
}

if (bIsOverride) {
	String warningMessages[] = {"This is an override for element ", "Ceci est un remplacement pour l’élément "};
	String warningMessage = warningMessages[languageKeys.find(currentLanguage)] + thisElement.number();
	reportMessage("\n"+scriptName()+": "+warningMessage);
}
int recordedTSLversion = mapUserSelectedValues.getInt("Version");
int bForceUpdate = recordedTSLversion != _ThisInst.version();

//---------------
//--------------- <User selected values map> --- end
//endregion

//region Functions to construct OPM properties map
//--------------- <Functions to construct OPM properties map> --- start
//---------------

//function to set default language in map
void setPropertiesDefaultLanguage(Map& inPropertiesMap, String inDefaultLanguage)
{
	inPropertiesMap.setString("Default language", inDefaultLanguage);
}

//function to get default language from map
String getPropertiesDefaultLanguage(Map& inPropertiesMap)
{
	String defaultLanguage;
	if (inPropertiesMap.hasString("Default language")) {
		defaultLanguage = inPropertiesMap.getString("Default language");
	}
	else {
		defaultLanguage = "en-US";
	}
	return defaultLanguage;
}

//function to create  map provided with ID and name in default language
Map createMap(String inID, String inDefaultName, String& inDefaultLanguage)
{
	Map outMap;
	outMap.setString("ID", inID);
	outMap.setString("Name:"+inDefaultLanguage, inDefaultName);
	return outMap;
}
 
//function to set name given language in map
void setMapName(Map& inMap, String inLanguage, String inName)
{
	inMap.setString("Name:"+inLanguage, inName);
}

//function to get name given language from map
String getMapName(Map& inMap, String& inLanguage, String& inDefaultLanguage)
{
	String outName;
	if (inMap.hasString("Name:"+inLanguage)) {
		outName = inMap.getString("Name:"+inLanguage);
	}
	else {
		outName = inMap.getString("Name:"+inDefaultLanguage);
	}
	return outName;
}

//function to set description given language in map
void setMapDescription(Map& inMap, String inLanguage, String inDescription)
{
	inMap.setString("Description:"+inLanguage, inDescription);
}

//function to get description given language from map
String getMapDescription(Map& inMap, String& inLanguage, String& inDefaultLanguage)
{
	String outDescription;
	if (inMap.hasString("Description:"+inLanguage)) {
		outDescription = inMap.getString("Description:"+inLanguage);
	}
	else {
		outDescription = inMap.getString("Description:"+inDefaultLanguage);
	}
	return outDescription;
}

//function to add category map to properties map
void addCategoryToPropertiesMap(Map& inPropertiesMap, Map& inCategoryMap)
{
	inPropertiesMap.appendMap("Category", inCategoryMap);
}

//function to record propint map to category map
void addPropIntToCategoryMap(Map& inCategoryMap, Map& inPropIntMap)
{
	inCategoryMap.appendMap("PropInt", inPropIntMap);
}

//function to record propdouble map to category map
void addPropDoubleToCategoryMap(Map& inCategoryMap, Map& inPropDoubleMap)
{
	inCategoryMap.appendMap("PropDouble", inPropDoubleMap);
}

//function to record propstring map to category map
void addPropStringToCategoryMap(Map& inCategoryMap, Map& inPropStringMap)
{
	inCategoryMap.appendMap("PropString", inPropStringMap);
}

//function to set default ID into property map
void setDefaultID(Map& inPropMap, String inDefaultID)
{
	inPropMap.setString("DefaultID", inDefaultID);
}

//function to create values map given language
Map createValuesMap(String inLanguage)
{
	Map mapValues;
	Map mapIDs;
	Map mapValues_lang;
	mapValues.setMap("IDs", mapIDs);
	mapValues.setMap("Values:"+inLanguage, mapValues_lang);
	return mapValues;
}

//function to add ID to values map
void addIDToValuesMap(Map& inValuesMap, String inID)
{
	Map mapIDs = inValuesMap.getMap("IDs");
	mapIDs.appendString("ID", inID);
	inValuesMap.setMap("IDs", mapIDs);
}

//function to add int value to values map given language
void addIntValueToValuesMap(Map& inValuesMap, String inLanguage, int inValue)
{
	Map mapValues = inValuesMap.getMap("Values:"+inLanguage);
	mapValues.appendInt("Value", inValue);
	inValuesMap.setMap("Values:"+inLanguage, mapValues);
}

//function to add double value to values map given language
void addDoubleValueToValuesMap(Map& inValuesMap, String inLanguage, double inValue)
{
	Map mapValues = inValuesMap.getMap("Values:"+inLanguage);
	mapValues.appendDouble("Value", inValue);
	inValuesMap.setMap("Values:"+inLanguage, mapValues);
}

//function to add string value to values map given language
void addStringValueToValuesMap(Map& inValuesMap, String inLanguage, String inValue)
{
	Map mapValues = inValuesMap.getMap("Values:"+inLanguage);
	mapValues.appendString("Value", inValue);
	inValuesMap.setMap("Values:"+inLanguage, mapValues);
}

//function to add values map to property map
void setValuesMapToProperty(Map& inPropMap, Map& inValuesMap)
{
	inPropMap.setMap("Values", inValuesMap);
}

//function to create string default value map given default value and language
Map createStringDefaultValueMap(String inDefaultID, String inDefaultValue, String inLanguage)
{
	Map mapDefault;
	mapDefault.setString("ID", inDefaultID);
	mapDefault.setString("Value:"+inLanguage, inDefaultValue);
	return mapDefault;
}

//function to create double default value map given default value and language
Map createDoubleDefaultValueMap(String inDefaultID, double inDefaultValue, String inLanguage)
{
	Map mapDefault;
	mapDefault.setString("ID", inDefaultID);
	mapDefault.setDouble("Value:"+inLanguage, inDefaultValue);
	return mapDefault;
}

//function to create int default value map given default value and language
Map createIntDefaultValueMap(String inDefaultID, int inDefaultValue, String inLanguage)
{
	Map mapDefault;
	mapDefault.setString("ID", inDefaultID);
	mapDefault.setInt("Value:"+inLanguage, inDefaultValue);
	return mapDefault;
}

//function to set default string value in difault value map
void setStringDefaultValue(Map& inDefaultValueMap, String inDefaultValue, String inLanguage)
{
	inDefaultValueMap.setString("Value:"+inLanguage, inDefaultValue);
}

//function to set default double value in difault value map
void setDoubleDefaultValue(Map& inDefaultValueMap, double inDefaultValue, String inLanguage)
{
	inDefaultValueMap.setDouble("Value:"+inLanguage, inDefaultValue);
}

//function to set default int value in difault value map
void setIntDefaultValue(Map& inDefaultValueMap, int inDefaultValue, String inLanguage)
{
	inDefaultValueMap.setInt("Value:"+inLanguage, inDefaultValue);
}

//function to set default value map in property map
void setDefaultValueMap(Map& inPropMap, Map& inDefaultValueMap)
{
	inPropMap.setMap("DefaultValue", inDefaultValueMap);
}

//function to set unit type in propdouble map
void setPropDoubleUnitType(Map& inPropDoubleMap, int inUnitType)
{
	inPropDoubleMap.setInt("UnitType", inUnitType);
}

//function to get unit type from propdouble map
int getPropDoubleUnitType(Map& inPropDoubleMap)
{
	int unitType;
	if (inPropDoubleMap.hasInt("UnitType")) {
		unitType = inPropDoubleMap.getInt("UnitType");
	}
	else {
		unitType = _kLength;
	}
	return unitType;
}

//---------------
//--------------- <Functions to construct OPM properties map> --- end
//endregion

//region OPM properties input map
//--------------- <OPM properties input map> --- start
//---------------

Map mapOPMproperties;
if (bForceUpdate || _bOnInsert || _kExecuteKey == callPropertiesTrigger || _kExecuteKey == overridePropertiesTrigger) {
	//default language to en-US
	setPropertiesDefaultLanguage(mapOPMproperties, defaultLanguage);
	{
		Map mapCategory = createMap("Dimension options", "Dimension options", defaultLanguage);
		setMapName(mapCategory, "fr-CA", "Options de dimension");
		{
			Map mapPropString = createMap("Dimensioned entities", "Dimensioned entities", defaultLanguage);
			setMapName(mapPropString, "fr-CA", "Entités mesurées");
			String description_enUS = "If set to Dimensioned and referenced will use both dimensioned and reference beams/sheets."
			 + "\nIf set to Dimensioned only will not use reference beams/sheets."
			 + "\nIf set to Referenced only will not use dimensioned beams/sheets."
			 + "\nIf set to Reference to self will use dimensioned beams/sheets for reference";
			String description_frCA = "Si défini à Mesuré et référencé, utilisera les bois/revêtement mesurés et référencés."
			 + "\nSi défini à Mesuré seulement, n’utilisera pas les bois/revêtement référencés."
			 + "\nSi défini à Référencé seulement, n’utilisera pas les bois/revêtement mesurés."
			 + "\nSi défini à Référence à soi-même, utilisera les bois/revêtement mesurés pour référence";
			setMapDescription(mapPropString, "en-US", description_enUS);
			setMapDescription(mapPropString, "fr-CA", description_frCA);
			{
				Map mapValues = createValuesMap("en-US");
				{
					addIDToValuesMap(mapValues, "Dimensioned and referenced");
					addStringValueToValuesMap(mapValues, "en-US", "Dimensioned and referenced");
					addStringValueToValuesMap(mapValues, "fr-CA", "Mesuré et référencé");
					addIDToValuesMap(mapValues, "Dimensioned only");
					addStringValueToValuesMap(mapValues, "en-US", "Dimensioned only");
					addStringValueToValuesMap(mapValues, "fr-CA", "Mesuré seulement");
					addIDToValuesMap(mapValues, "Referenced only");
					addStringValueToValuesMap(mapValues, "en-US", "Referenced only");
					addStringValueToValuesMap(mapValues, "fr-CA", "Référencé seulement");
					addIDToValuesMap(mapValues, "Reference to self");
					addStringValueToValuesMap(mapValues, "en-US", "Reference to self");
					addStringValueToValuesMap(mapValues, "fr-CA", "Référence à soi-même");
				}//IDs, Values : en - US, fr - CA
				setDefaultID(mapPropString, "Dimensioned and referenced");
				setValuesMapToProperty(mapPropString, mapValues);
			}//Values
			addPropStringToCategoryMap(mapCategory, mapPropString);
		}//Dimensioned entities
		{
			Map mapPropString = createMap("Hatch pattern", "Hatch pattern", defaultLanguage);
			setMapName(mapPropString, "fr-CA", "Motif de hachure");
			String description_enUS = "If set to None will not hatch dimensioned and referenced beams/sheets.";
			String description_frCA = "Si défini à Aucun, n’hachurera pas les bois/revêtement mesurés et référencés.";
			setMapDescription(mapPropString, "en-US", description_enUS);
			setMapDescription(mapPropString, "fr-CA", description_frCA);
			{
				Map mapValues = createValuesMap("en-US");
				{
					addIDToValuesMap(mapValues, "None");
					addStringValueToValuesMap(mapValues, "en-US", "None");
					addStringValueToValuesMap(mapValues, "fr-CA", "Aucun");
					for (int i = 0; i < _HatchPatterns.length(); i++) {
						String& thisHatchPattern = _HatchPatterns[i];
						addIDToValuesMap(mapValues, thisHatchPattern);
						addStringValueToValuesMap(mapValues, "en-US", thisHatchPattern);
						addStringValueToValuesMap(mapValues, "fr-CA", thisHatchPattern);
					}
				}//IDs, Values : en - US, fr - CA
				setDefaultID(mapPropString, "None");
				setValuesMapToProperty(mapPropString, mapValues);
			}//Values

			addPropStringToCategoryMap(mapCategory, mapPropString);
		}//Hatch pattern
		{
			Map mapPropDouble = createMap("Hatch scale", "Hatch scale", defaultLanguage);
			setMapName(mapPropDouble, "fr-CA", "Échelle de hachure");
			String description_enUS = "Scale of hatch pattern in paper space";
			String description_frCA = "Échelle du motif de hachure dans l’espace papier";
			setMapDescription(mapPropDouble, "en-US", description_enUS);
			setMapDescription(mapPropDouble, "fr-CA", description_frCA);
			setPropDoubleUnitType(mapPropDouble, _kNoUnit);
			{
				Map mapDefault = createDoubleDefaultValueMap("Default", 1, defaultLanguage);
				setDoubleDefaultValue(mapDefault, 1, "fr-CA");
				setDefaultValueMap(mapPropDouble, mapDefault);
			}//Default value
			addPropDoubleToCategoryMap(mapCategory, mapPropDouble);
		}//Hatch scale
		{
			Map mapPropDouble = createMap("Hatch angle", "Hatch angle", defaultLanguage);
			setMapName(mapPropDouble, "fr-CA", "Angle de hachure");
			String description_enUS = "Angle of hatch pattern in degrees";
			String description_frCA = "Angle du motif de hachure en degrés";
			setMapDescription(mapPropDouble, "en-US", description_enUS);
			setMapDescription(mapPropDouble, "fr-CA", description_frCA);
			setPropDoubleUnitType(mapPropDouble, _kAngle);
			{
				Map mapDefault = createDoubleDefaultValueMap("Default", 0, defaultLanguage);
				setDoubleDefaultValue(mapDefault, 0, "fr-CA");
				setDefaultValueMap(mapPropDouble, mapDefault);
			}//Default value
			addPropDoubleToCategoryMap(mapCategory, mapPropDouble);
		}//Hatch angle
		{
			Map mapPropInt = createMap("Hatch colour", "Hatch colour", defaultLanguage);
			setMapName(mapPropInt, "fr-CA", "Couleur de hachure");
			String description_enUS = "Colour of hatch pattern. \nIf set to -1 will use colour of this TSL instance";
			String description_frCA = "Couleur du motif de hachure. \nSi défini à -1, utilisera la couleur de cette instance TSL";
			setMapDescription(mapPropInt, "en-US", description_enUS);
			setMapDescription(mapPropInt, "fr-CA", description_frCA);
			{
				Map mapDefault = createIntDefaultValueMap("Default", -1, defaultLanguage);
				setIntDefaultValue(mapDefault, -1, "fr-CA");
				setDefaultValueMap(mapPropInt, mapDefault);
			}//Default value

			addPropIntToCategoryMap(mapCategory, mapPropInt);
		}//Hatch colour
		{
			Map mapPropInt = createMap("Hatch transparency", "Hatch transparency", defaultLanguage);
			setMapName(mapPropInt, "fr-CA", "Transparence de hachure");
			String description_enUS = "If hatch is set to SOLID will use this transparency value.";
			String description_frCA = "Si la hachure est définie à SOLID, utilisera cette valeur de transparence.";
			setMapDescription(mapPropInt, "en-US", description_enUS);
			setMapDescription(mapPropInt, "fr-CA", description_frCA);
			{
				Map mapDefault = createIntDefaultValueMap("Default", 60, defaultLanguage);
				setIntDefaultValue(mapDefault, 60, "fr-CA");
				setDefaultValueMap(mapPropInt, mapDefault);
			}//Default value

			addPropIntToCategoryMap(mapCategory, mapPropInt);
		}//Solid transparency

		addCategoryToPropertiesMap(mapOPMproperties, mapCategory);
	}//Dimension options
	{
		Map mapCategory = createMap("Genbeams to dimension", "Beams/Sheets to dimension", defaultLanguage);
		setMapName(mapCategory, "fr-CA", "Bois/Revêtement qui sont mesurées");
		{
			Map mapPropString = createMap("Element side", "Element side", defaultLanguage);
			setMapName(mapPropString, "fr-CA", "Côté d’élément");
			String description_enUS = "If set to Half of element will dimension only beams/sheets at half of element closest to dimension line.\nIncludes beams/sheets which are not fully inside half of elment container";
			setMapDescription(mapPropString, "en-US", description_enUS);
			String description_frCA = "Si défini à Moitié d’élément, mesurera seulement les bois/revêtement à la moitié de l’élément la plus proche de la ligne de cote";
			setMapDescription(mapPropString, "fr-CA", description_frCA);
			{
				Map mapValues = createValuesMap("en-US");
				{
					addIDToValuesMap(mapValues, "Entire element");
					addStringValueToValuesMap(mapValues, "en-US", "Entire element");
					addStringValueToValuesMap(mapValues, "fr-CA", "Élément entier");
					addIDToValuesMap(mapValues, "Half of element");
					addStringValueToValuesMap(mapValues, "en-US", "Half of element");
					addStringValueToValuesMap(mapValues, "fr-CA", "Moitié d’élément");
				}//IDs, Values : en - US, fr - CA
				setDefaultID(mapPropString, "Entire element");
				setValuesMapToProperty(mapPropString, mapValues);
			}//Values
			addPropStringToCategoryMap(mapCategory, mapPropString);
		}//Element side
		{
			Map mapPropInt = createMap("Zone", "Element zone", defaultLanguage);
			setMapName(mapPropInt, "fr-CA", "Zone d’élément");
			String description_enUS = "Zone to which dimensioned beams/sheets belong to:";
			String description_frCA = "Zone à laquelle appartiennent les bois/revêtement mesurés:";
			{
				Map mapValues = createValuesMap("Any");
				{
					addIDToValuesMap(mapValues, "Zone 0");
					addIntValueToValuesMap(mapValues, "Any", 0);
					description_enUS += "\n0 zone inside element container";
					description_frCA += "\n0 zone à l’intérieur du conteneur d’élément";
					for (int i = 1; i <= 2; i++) {
						description_enUS += "\n";
						description_frCA += "\n";
						for (int k = 1; k <= 5; k++) {
							int iValue = (i == 1 ? 1 : - 1) * k;
							addIDToValuesMap(mapValues, "Zone " + iValue);	
							addIntValueToValuesMap(mapValues, "Any", iValue);
							description_enUS += iValue + (k < 5 ? ", " : " ");
							description_frCA += iValue + (k < 5 ? ", " : " ");
						}
						description_enUS += "zones at " + (i == 1 ? "front" : "back") + " of wall container or at " + (i == 1 ? "top" : "back") + " of floor/roof container";
						description_frCA += "zones à " + (i == 1 ? "l’avant" : "l’arrière") + " du mur ou au " + (i == 1 ? "supérieure" : "inférieure") + " du plancher/de toiture ";
					}
				}//IDs, Values : Any
				setDefaultID(mapPropInt, "Zone 1");
				setValuesMapToProperty(mapPropInt, mapValues);
			}//Values
			setMapDescription(mapPropInt, "en-US", description_enUS);
			setMapDescription(mapPropInt, "fr-CA", description_frCA);
			addPropIntToCategoryMap(mapCategory, mapPropInt);
		}//Zone
		{
			Map mapPropString = createMap("Include filter", "Include filter", defaultLanguage);
			setMapName(mapPropString, "fr-CA", "Filtre d’inclusion");
			String description_enUS = "Painter definition of type GenBeam \nAddition filter applied to get a subset of dimensioned genbeams at selected zone "
			 + "\nIf set to None will not apply inclusion(this) filter";
			setMapDescription(mapPropString, "en-US", description_enUS);
			String description_frCA = "Définition de peintre de type GenBeam \nFiltre d’addition appliqué pour obtenir un sous-ensemble de genbeams dimensionnés à la zone sélectionnée "
			 + "\nSi défini à Aucun, n’appliquera pas ce filtre d’inclusion";
			setMapDescription(mapPropString, "fr-CA", description_frCA);
			{
				Map mapValues = createValuesMap("en-US");
				{
					addIDToValuesMap(mapValues, "None");
					addStringValueToValuesMap(mapValues, "en-US", "None");
					addStringValueToValuesMap(mapValues, "fr-CA", "Aucun");
					for (int i = 0; i < genbeamFilters.length(); i++) {
						String& thisFilter = genbeamFilters[i];
						addIDToValuesMap(mapValues, thisFilter);
						addStringValueToValuesMap(mapValues, "en-US", thisFilter);
						addStringValueToValuesMap(mapValues, "fr-CA", thisFilter);
					}
				}//IDs, Values : en - US, fr - CA
				setDefaultID(mapPropString, "None");
				setValuesMapToProperty(mapPropString, mapValues);
			}//Values
			addPropStringToCategoryMap(mapCategory, mapPropString);
		}//Include filter
		{
			Map mapPropString = createMap("Exclude filter", "Exclude filter", defaultLanguage);
			setMapName(mapPropString, "fr-CA", "Filtre d’exclusion");
			String description_enUS = "Painter definition of type GenBeam"
			 + "\nSubtraction filter(painter definition) applied to get a subset of dimensioned genbeams at selected zone"
			 + "\nIf set to None will not apply exclusion(this) filter"
			 + "\nIf both filters are not None it will get genbeams which are at specified zone and sutisfy conditions of include(above) filter,"
			 + "\nthen it will remove genbeams which satisfy exclude(this) fiter";
			setMapDescription(mapPropString, "en-US", description_enUS);
			String description_frCA = "Définition de peintre de type GenBeam"
			 + "\nFiltre de soustraction (définition de peintre) appliqué pour obtenir un sous-ensemble de genbeams dimensionnés à la zone sélectionnée"
			 + "\nSi défini à Aucun, n’appliquera pas ce filtre d’exclusion"
			 + "\nSi les deux filtres ne sont pas Aucun, il obtiendra des genbeams qui sont à la zone spécifiée et qui satisfont les conditions du filtre d’inclusion (ci-dessus),"
			 + "\npuis il supprimera les genbeams qui satisfont le filtre d’exclusion";
			setMapDescription(mapPropString, "fr-CA", description_frCA);
			{
				Map mapValues = createValuesMap("en-US");
				{
					addIDToValuesMap(mapValues, "None");
					addStringValueToValuesMap(mapValues, "en-US", "None");
					addStringValueToValuesMap(mapValues, "fr-CA", "Aucun");
					for (int i = 0; i < genbeamFilters.length(); i++) {
						String& thisFilter = genbeamFilters[i];
						addIDToValuesMap(mapValues, thisFilter);
						addStringValueToValuesMap(mapValues, "en-US", thisFilter);
						addStringValueToValuesMap(mapValues, "fr-CA", thisFilter);
					}
				}//IDs, Values : en - US, fr - CA
				setDefaultID(mapPropString, "None");
				setValuesMapToProperty(mapPropString, mapValues);
			}//Values
			addPropStringToCategoryMap(mapCategory, mapPropString);
		}//Exclude filter
		{
			Map mapPropString = createMap("Points to dimension", "Points to dimension", defaultLanguage);
			setMapName(mapPropString, "fr-CA", "Points à mesurer");
			String description_enUS = "Specifies which points to measure relative to dimension line direction";
			setMapDescription(mapPropString, "en-US", description_enUS);
			String description_frCA = "Spécifie quel points mesurer par rapport à la direction de la ligne de cote";
			setMapDescription(mapPropString, "fr-CA", description_frCA);
			{
				Map mapValues = createValuesMap("en-US");
				{
					addIDToValuesMap(mapValues, "Start point");
					addStringValueToValuesMap(mapValues, "en-US", "Start point");
					addStringValueToValuesMap(mapValues, "fr-CA", "Point de départ");
					addIDToValuesMap(mapValues, "Middle point");
					addStringValueToValuesMap(mapValues, "en-US", "Middle point");
					addStringValueToValuesMap(mapValues, "fr-CA", "Point du milieu");
					addIDToValuesMap(mapValues, "End point");
					addStringValueToValuesMap(mapValues, "en-US", "End point");
					addStringValueToValuesMap(mapValues, "fr-CA", "Point de fin");
					addIDToValuesMap(mapValues, "Start and end points");
					addStringValueToValuesMap(mapValues, "en-US", "Start and end points");
					addStringValueToValuesMap(mapValues, "fr-CA", "Points de départ et de fin");
					addIDToValuesMap(mapValues, "All points");
					addStringValueToValuesMap(mapValues, "en-US", "All points");
					addStringValueToValuesMap(mapValues, "fr-CA", "Tous les points");
				}//IDs, Values : en - US, fr - CA
				setDefaultID(mapPropString, "Start point");
				setValuesMapToProperty(mapPropString, mapValues);
			}//Values
			addPropStringToCategoryMap(mapCategory, mapPropString);
		}//Points to dimension
		{
			Map mapPropString = createMap("Genbeam side", "Beam/Sheet side", defaultLanguage);
			setMapName(mapPropString, "fr-CA", "Côté de bois/revêtement");
			String description_enUS = "If set to Half of beam/sheet will dimension only half of beam/sheet closest to dimension line";
			setMapDescription(mapPropString, "en-US", description_enUS);
			String description_frCA = "Si défini à Moitié de bois/revêtement, mesurera seulement la moitié du bois/revêtement la plus proche de la ligne de cote";
			setMapDescription(mapPropString, "fr-CA", description_frCA);
			{
				Map mapValues = createValuesMap("en-US");
				{
					addIDToValuesMap(mapValues, "Entire genbeam");
					addStringValueToValuesMap(mapValues, "en-US", "Entire beam/sheet");
					addStringValueToValuesMap(mapValues, "fr-CA", "Bois/revêtement entier");
					addIDToValuesMap(mapValues, "Half of genbeam");
					addStringValueToValuesMap(mapValues, "en-US", "Half of beam/sheet");
					addStringValueToValuesMap(mapValues, "fr-CA", "Moitié de bois/revêtement");
					addIDToValuesMap(mapValues, "Closest edge of genbeam");
					addStringValueToValuesMap(mapValues, "en-US", "Closest edge of beam/sheet");
					addStringValueToValuesMap(mapValues, "fr-CA", "Bord le plus proche de bois/revêtement");
				}//IDs, Values : en - US, fr - CA
				setDefaultID(mapPropString, "Entire genbeam");
				setValuesMapToProperty(mapPropString, mapValues);
			}//Values
			addPropStringToCategoryMap(mapCategory, mapPropString);
		}//Genbeam side
		{
			Map mapPropString = createMap("Pack dimensioned genbeams", "Pack dimensioned beams/sheets", defaultLanguage);
			setMapName(mapPropString, "fr-CA", "Paquet de bois/revêtement mesurés");
			String description_enUS = "If set to Yes will pack dimensioned beams/sheets to minimize number of dimensions";
			setMapDescription(mapPropString, "en-US", description_enUS);
			String description_frCA = "Si défini à Oui, emballera les bois/revêtement mesurés pour minimiser le nombre de dimensions";
			setMapDescription(mapPropString, "fr-CA", description_frCA);
			{
				Map mapValues = createValuesMap("en-US");
				{
					addIDToValuesMap(mapValues, "Yes");
					addStringValueToValuesMap(mapValues, "en-US", "Yes");
					addStringValueToValuesMap(mapValues, "fr-CA", "Oui");
					addIDToValuesMap(mapValues, "No");
					addStringValueToValuesMap(mapValues, "en-US", "No");
					addStringValueToValuesMap(mapValues, "fr-CA", "Non");
				}//IDs, Values : en - US, fr - CA
				setDefaultID(mapPropString, "No");
				setValuesMapToProperty(mapPropString, mapValues);
			}//Values

			addPropStringToCategoryMap(mapCategory, mapPropString);
		}//Pack dimensioned genbeams
		addCategoryToPropertiesMap(mapOPMproperties, mapCategory);
	}//Genbeams to dimension
	{
		Map mapCategory = createMap("Genbeams to reference", "Beams/Sheets to reference", defaultLanguage);
		setMapName(mapCategory, "fr-CA", "Bois/Revêtement qui sont référencés");
		{
			Map mapPropString = createMap("Element side", "Element side", defaultLanguage);
			setMapName(mapPropString, "fr-CA", "Côté d’élément");
			String description_enUS = "If set to Half of element will reference only beams/sheets at half of element closest to dimension line.\nIncludes beams/sheets which are not fully inside half of elment container";
			setMapDescription(mapPropString, "en-US", description_enUS);
			String description_frCA = "Si défini à Moitié d’élément, référencera seulement les bois/revêtement à la moitié de l’élément la plus proche de la ligne de cote";
			setMapDescription(mapPropString, "fr-CA", description_frCA);
			{
				Map mapValues = createValuesMap("en-US");
				{
					addIDToValuesMap(mapValues, "Entire element");
					addStringValueToValuesMap(mapValues, "en-US", "Entire element");
					addStringValueToValuesMap(mapValues, "fr-CA", "Élément entier");
					addIDToValuesMap(mapValues, "Half of element");
					addStringValueToValuesMap(mapValues, "en-US", "Half of element");
					addStringValueToValuesMap(mapValues, "fr-CA", "Moitié d’élément");
				}//IDs, Values : en - US, fr - CA
				setDefaultID(mapPropString, "Entire element");
				setValuesMapToProperty(mapPropString, mapValues);
			}//Values
			addPropStringToCategoryMap(mapCategory, mapPropString);
		}//Element side
		{
			Map mapPropInt = createMap("Zone", "Element zone", defaultLanguage);
			setMapName(mapPropInt, "fr-CA", "Zone d’élément");
			String description_enUS = "Zone to which referenced beams/sheets belong to:";
			String description_frCA = "Zone à laquelle appartiennent les bois/revêtement référencés:";
			{
				Map mapValues = createValuesMap("Any");
				{
					addIDToValuesMap(mapValues, "Zone 0");
					addIntValueToValuesMap(mapValues, "Any", 0);
					description_enUS += "\n0 zone inside element container";
					description_frCA += "\n0 zone à l’intérieur du conteneur d’élément";
					for (int i = 1; i <= 2; i++) {
						description_enUS += "\n";
						description_frCA += "\n";
						for (int k = 1; k <= 5; k++) {
							int iValue = (i == 1 ? 1 : - 1) * k;
							addIDToValuesMap(mapValues, "Zone " + iValue);	
							addIntValueToValuesMap(mapValues, "Any", iValue);
							description_enUS += iValue + (k < 5 ? ", " : " ");
							description_frCA += iValue + (k < 5 ? ", " : " ");
						}
						description_enUS += "zones at " + (i == 1 ? "front" : "back") + " of wall container or at " + (i == 1 ? "top" : "back") + " of floor/roof container";
						description_frCA += "zones à " + (i == 1 ? "l’avant" : "l’arrière") + " du mur ou au " + (i == 1 ? "supérieure" : "inférieure") + " du plancher/de toiture ";
					}
				}//IDs, Values : Any
				setDefaultID(mapPropInt, "Zone 0");
				setValuesMapToProperty(mapPropInt, mapValues);
			}//Values
			setMapDescription(mapPropInt, "en-US", description_enUS);
			setMapDescription(mapPropInt, "fr-CA", description_frCA);
			addPropIntToCategoryMap(mapCategory, mapPropInt);
		}//Zone
		{
			Map mapPropString = createMap("Include filter", "Include filter", defaultLanguage);
			setMapName(mapPropString, "fr-CA", "Filtre d’inclusion");
			String description_enUS = "Painter definition of type GenBeam \nAddition filter applied to get a subset of referenced beams/sheets at selected zone "
			 + "\nIf set to None will not apply inclusion(this) filter";
			setMapDescription(mapPropString, "en-US", description_enUS);
			String description_frCA = "Définition de peintre de type GenBeam \nFiltre d’addition appliqué pour obtenir un sous-ensemble de bois/revêtement référencés à la zone sélectionnée "
			 + "\nSi défini à Aucun, n’appliquera pas ce filtre d’inclusion";
			setMapDescription(mapPropString, "fr-CA", description_frCA);
			{
				Map mapValues = createValuesMap("en-US");
				{
					addIDToValuesMap(mapValues, "None");
					addStringValueToValuesMap(mapValues, "en-US", "None");
					addStringValueToValuesMap(mapValues, "fr-CA", "Aucun");
					for (int i = 0; i < genbeamFilters.length(); i++) {
						String& thisFilter = genbeamFilters[i];
						addIDToValuesMap(mapValues, thisFilter);
						addStringValueToValuesMap(mapValues, "en-US", thisFilter);
						addStringValueToValuesMap(mapValues, "fr-CA", thisFilter);
					}
				}//IDs, Values : en - US, fr - CA
				setDefaultID(mapPropString, "None");
				setValuesMapToProperty(mapPropString, mapValues);
			}//Values
			addPropStringToCategoryMap(mapCategory, mapPropString);
		}//Include filter
		{
			Map mapPropString = createMap("Exclude filter", "Exclude filter", defaultLanguage);
			setMapName(mapPropString, "fr-CA", "Filtre d’exclusion");
			String description_enUS = "Painter definition of type GenBeam"
			 + "\nSubtraction filter(painter definition) applied to get a subset of referenced beams/sheets at selected zone"
			 + "\nIf set to None will not apply exclusion(this) filter"
			 + "\nIf both filters are not None it will get beams/sheets which are at specified zone and sutisfy conditions of include(above) filter,"
			 + "\nthen it will remove beams/sheets which satisfy exclude(this) fiter";
			setMapDescription(mapPropString, "en-US", description_enUS);
			String description_frCA = "Définition de peintre de type GenBeam"
			 + "\nFiltre de soustraction (définition de peintre) appliqué pour obtenir un sous-ensemble de bois/revêtement référencés à la zone sélectionnée"
			 + "\nSi défini à Aucun, n’appliquera pas ce filtre d’exclusion"
			 + "\nSi les deux filtres ne sont pas Aucun, il obtiendra des bois/revêtement qui sont à la zone spécifiée et qui satisfont les conditions du filtre d’inclusion (ci-dessus),"
			 + "\npuis il supprimera les bois/revêtement qui satisfont le filtre d’exclusion";
			setMapDescription(mapPropString, "fr-CA", description_frCA);
			{
				Map mapValues = createValuesMap("en-US");
				{
					addIDToValuesMap(mapValues, "None");
					addStringValueToValuesMap(mapValues, "en-US", "None");
					addStringValueToValuesMap(mapValues, "fr-CA", "Aucun");
					for (int i = 0; i < genbeamFilters.length(); i++) {
						String& thisFilter = genbeamFilters[i];
						addIDToValuesMap(mapValues, thisFilter);
						addStringValueToValuesMap(mapValues, "en-US", thisFilter);
						addStringValueToValuesMap(mapValues, "fr-CA", thisFilter);
					}
				}//IDs, Values : en - US, fr - CA
				setDefaultID(mapPropString, "None");
				setValuesMapToProperty(mapPropString, mapValues);
			}//Values
			addPropStringToCategoryMap(mapCategory, mapPropString);
		}//Exclude filter
		{
			Map mapPropString = createMap("Points to reference", "Points to reference", defaultLanguage);
			setMapName(mapPropString, "fr-CA", "Points à référencer");
			String description_enUS = "Specifies which points to take as a reference relative to dimension line direction";
			setMapDescription(mapPropString, "en-US", description_enUS);
			String description_frCA = "Spécifie quel points prendre comme référence par rapport à la direction de la ligne de cote";
			setMapDescription(mapPropString, "fr-CA", description_frCA);
			{
				Map mapValues = createValuesMap("en-US");
				{
					addIDToValuesMap(mapValues, "Start point");
					addStringValueToValuesMap(mapValues, "en-US", "Start point");
					addStringValueToValuesMap(mapValues, "fr-CA", "Point de départ");
					addIDToValuesMap(mapValues, "End point");
					addStringValueToValuesMap(mapValues, "en-US", "End point");
					addStringValueToValuesMap(mapValues, "fr-CA", "Point de fin");
					addIDToValuesMap(mapValues, "Start and end points");
					addStringValueToValuesMap(mapValues, "en-US", "Start and end points");
					addStringValueToValuesMap(mapValues, "fr-CA", "Points de départ et de fin");
				}//IDs, Values : en - US, fr - CA
				setDefaultID(mapPropString, "Start and end points");
				setValuesMapToProperty(mapPropString, mapValues);
			}//Values
			addPropStringToCategoryMap(mapCategory, mapPropString);
		}//Points to reference
		{
			Map mapPropString = createMap("Genbeam side", "Beam/Sheet side", defaultLanguage);
			setMapName(mapPropString, "fr-CA", "Côté de bois/revêtement");
			String description_enUS = "If set to Half of beam/sheet will reference only half of beam/sheet closest to dimension line";
			setMapDescription(mapPropString, "en-US", description_enUS);
			String description_frCA = "Si défini à Moitié de bois/revêtement, référencera seulement la moitié du bois/revêtement la plus proche de la ligne de cote";
			setMapDescription(mapPropString, "fr-CA", description_frCA);
			{
				Map mapValues = createValuesMap("en-US");
				{
					addIDToValuesMap(mapValues, "Entire genbeam");
					addStringValueToValuesMap(mapValues, "en-US", "Entire beam/sheet");
					addStringValueToValuesMap(mapValues, "fr-CA", "Bois/revêtement entier");
					addIDToValuesMap(mapValues, "Half of genbeam");
					addStringValueToValuesMap(mapValues, "en-US", "Half of beam/sheet");
					addStringValueToValuesMap(mapValues, "fr-CA", "Moitié de bois/revêtement");
					addIDToValuesMap(mapValues, "Closest edge of genbeam");
					addStringValueToValuesMap(mapValues, "en-US", "Closest edge of beam/sheet");
					addStringValueToValuesMap(mapValues, "fr-CA", "Bord le plus proche de bois/revêtement");
				}//IDs, Values : en - US, fr - CA
				setDefaultID(mapPropString, "Entire genbeam");
				setValuesMapToProperty(mapPropString, mapValues);
			}//Values
			addPropStringToCategoryMap(mapCategory, mapPropString);
		}//Genbeam side
		addCategoryToPropertiesMap(mapOPMproperties, mapCategory);
	}//Genbeams to reference
	{
		Map mapCategory = createMap("Dimension styling", "Dimension style and positioning", defaultLanguage);
		setMapName(mapCategory, "fr-CA", "Style et positionnement de cote");
		{
			Map mapPropString = createMap("Dimension orientation", "Dimension orientation", defaultLanguage);
			setMapName(mapPropString, "fr-CA", "Orientation de cote");
			String description_enUS = "Specifies where to place dimension line relative to viewport and its direction";
			setMapDescription(mapPropString, "en-US", description_enUS);
			String description_frCA = "Spécifie où placer la ligne de cote par rapport à la vue et sa direction";
			setMapDescription(mapPropString, "fr-CA", description_frCA);
			{
				Map mapValues = createValuesMap("en-US");
				{
					addIDToValuesMap(mapValues, "Vertical left");
					addStringValueToValuesMap(mapValues, "en-US", "Vertical left");
					addStringValueToValuesMap(mapValues, "fr-CA", "Verticale à gauche");
					addIDToValuesMap(mapValues, "Vertical right");
					addStringValueToValuesMap(mapValues, "en-US", "Vertical right");
					addStringValueToValuesMap(mapValues, "fr-CA", "Verticale à droite");
					addIDToValuesMap(mapValues, "Horizontal top");
					addStringValueToValuesMap(mapValues, "en-US", "Horizontal top");
					addStringValueToValuesMap(mapValues, "fr-CA", "Horizontale en haut");
					addIDToValuesMap(mapValues, "Horizontal bottom");
					addStringValueToValuesMap(mapValues, "en-US", "Horizontal bottom");
					addStringValueToValuesMap(mapValues, "fr-CA", "Horizontale en bas");
				}//IDs, Values : en - US, fr - CA
				setDefaultID(mapPropString, "Vertical left");
				setValuesMapToProperty(mapPropString, mapValues);
			}//Values
			addPropStringToCategoryMap(mapCategory, mapPropString);
		}//Dimension orientation
		{
			Map mapPropString = createMap("Dimension direction", "Dimension direction", defaultLanguage);
			setMapName(mapPropString, "fr-CA", "Direction de cote");
			String description_enUS = "If set to Reverse will reverse dimension line direction.\n Normal directions are: Vertical up, Horizontal right";
			setMapDescription(mapPropString, "en-US", description_enUS);
			String description_frCA = "Si défini à Inverser, inversera la direction de la ligne de cote.\n Les directions normales sont : Verticale vers le haut, Horizontale vers la droite";
			setMapDescription(mapPropString, "fr-CA", description_frCA);
			{
				Map mapValues = createValuesMap("en-US");
				{
					addIDToValuesMap(mapValues, "Normal");
					addStringValueToValuesMap(mapValues, "en-US", "Normal");
					addStringValueToValuesMap(mapValues, "fr-CA", "Normale");
					addIDToValuesMap(mapValues, "Reverse");
					addStringValueToValuesMap(mapValues, "en-US", "Reverse");
					addStringValueToValuesMap(mapValues, "fr-CA", "Inverser");
				}//IDs, Values : en - US, fr - CA
				setDefaultID(mapPropString, "Normal");
				setValuesMapToProperty(mapPropString, mapValues);
			}//Values
			addPropStringToCategoryMap(mapCategory, mapPropString);
		}//Dimension direction
		{
			Map mapPropString = createMap("Dimension type", "Dimension type", defaultLanguage);
			setMapName(mapPropString, "fr-CA", "Type de cote");
			String description_enUS = "If set to Delta will dimension in between points.\nIf set to Cummulative will dimension from start point to end point";
			setMapDescription(mapPropString, "en-US", description_enUS);
			String description_frCA = "Si défini à Delta, mesurera entre les points.\nSi défini à Cumulatif, mesurera du point de départ au point de fin";
			setMapDescription(mapPropString, "fr-CA", description_frCA);
			{
				Map mapValues = createValuesMap("en-US");
				{
					addIDToValuesMap(mapValues, "Delta");
					addStringValueToValuesMap(mapValues, "en-US", "Delta");
					addStringValueToValuesMap(mapValues, "fr-CA", "Delta");
					addIDToValuesMap(mapValues, "Cummulative");
					addStringValueToValuesMap(mapValues, "en-US", "Cummulative");
					addStringValueToValuesMap(mapValues, "fr-CA", "Cumulatif");
				}//IDs, Values : en - US, fr - CA
				setDefaultID(mapPropString, "Cummulative");
				setValuesMapToProperty(mapPropString, mapValues);
			}//Values
			addPropStringToCategoryMap(mapCategory, mapPropString);
		}//Dimension type
		{
			Map mapPropDouble = createMap("Dimension line offset", "Dimension line offset", defaultLanguage);
			setMapName(mapPropDouble, "fr-CA", "Décalage de ligne de cote");
			setMapDescription(mapPropDouble, "en-US", "If more then 0, will offset dimension away from viewport edgge/dimensioned points in paper space units");
			setMapDescription(mapPropDouble, "fr-CA", "Si plus que 0, décalera la cote à partir du bord de la vue/points mesurés en unités d’espace papier");
			{
				Map mapDefault = createDoubleDefaultValueMap("Default", 0.15625, defaultLanguage);//5 / 32"
				setDoubleDefaultValue(mapDefault, 4, "fr-CA");//4mm
				setDefaultValueMap(mapPropDouble, mapDefault);
			}//Default value
			addPropDoubleToCategoryMap(mapCategory, mapPropDouble);
		}//Dimension line offset
		{
			Map mapPropString = createMap("Dimension line position", "Dimension line position", defaultLanguage);
			setMapName(mapPropString, "fr-CA", "Position de ligne de cote");
			String description_enUS = "If set to Static will place dimension line at specified offset from viewport edge.\nIf set to Dynamic will place dimension line at specified offset from dimensioned points";
			setMapDescription(mapPropString, "en-US", description_enUS);
			String description_frCA = "Si défini à Statique, placera la ligne de cote au décalage spécifié à partir du bord de la vue.\nSi défini à Dynamique, placera la ligne de cote au décalage spécifié à partir des points mesurés";
			setMapDescription(mapPropString, "fr-CA", description_frCA);
			{
				Map mapValues = createValuesMap("en-US");
				{
					addIDToValuesMap(mapValues, "Static");
					addStringValueToValuesMap(mapValues, "en-US", "Static");
					addStringValueToValuesMap(mapValues, "fr-CA", "Statique");
					addIDToValuesMap(mapValues, "Dynamic");
					addStringValueToValuesMap(mapValues, "en-US", "Dynamic");
					addStringValueToValuesMap(mapValues, "fr-CA", "Dynamique");
				}//IDs, Values : en - US, fr - CA
				setDefaultID(mapPropString, "Dynamic");
				setValuesMapToProperty(mapPropString, mapValues);
			}//Values
			addPropStringToCategoryMap(mapCategory, mapPropString);
		}//Dimension line position
		{
			Map mapPropString = createMap("Project points to dimension line", "Project points to dimension line", defaultLanguage);
			setMapName(mapPropString, "fr-CA", "Projeter les points sur la ligne de cote");
			String description_enUS = "If set to Yes will project dimensioned points to dimension line.\nIf set to No there will be lines from dimensioned points to dimension line";
			setMapDescription(mapPropString, "en-US", description_enUS);
			String description_frCA = "Si défini à Oui, projettera les points mesurés sur la ligne de cote.\nSi défini à Non, il y aura des lignes des points mesurés à la ligne de cote";
			setMapDescription(mapPropString, "fr-CA", description_frCA);
			{
				Map mapValues = createValuesMap("en-US");
				{
					addIDToValuesMap(mapValues, "Yes");
					addStringValueToValuesMap(mapValues, "en-US", "Yes");
					addStringValueToValuesMap(mapValues, "fr-CA", "Oui");
					addIDToValuesMap(mapValues, "No");
					addStringValueToValuesMap(mapValues, "en-US", "No");
					addStringValueToValuesMap(mapValues, "fr-CA", "Non");
				}//IDs, Values : en - US, fr - CA
				setDefaultID(mapPropString, "Yes");
				setValuesMapToProperty(mapPropString, mapValues);
			}//Values
			addPropStringToCategoryMap(mapCategory, mapPropString);
		}//Project points to dimension line
		{
			Map mapPropString = createMap("Dimension style", "Dimension style", defaultLanguage);
			setMapName(mapPropString, "fr-CA", "Style de cote");
			setMapDescription(mapPropString, "en-US", "Dimension style applied");
			setMapDescription(mapPropString, "fr-CA", "Style de cote appliqué");
			{
				Map mapValues = createValuesMap("Any");
				{
					for (int i = 0; i < _DimStyles.length(); i++) {
						String& thisStyle = _DimStyles[i];
						addIDToValuesMap(mapValues, thisStyle);
						addStringValueToValuesMap(mapValues, "Any", thisStyle);
					}
				}//IDs, Values : Any
				setDefaultID(mapPropString, "NA Shopdrawing");
				setValuesMapToProperty(mapPropString, mapValues);
			}//Values
			addPropStringToCategoryMap(mapCategory, mapPropString);
		}//Dimension style
		{
			Map mapPropDouble = createMap("Text height", "Text height", defaultLanguage);
			setMapName(mapPropDouble, "fr-CA", "Hauteur de texte");
			setMapDescription(mapPropDouble, "en-US", "If more then 0, will override dimension text height in paper space units");
			setMapDescription(mapPropDouble, "fr-CA", "Si plus que 0, remplacera la hauteur de texte de cote en unités d’espace papier");
			{
				Map mapDefault = createDoubleDefaultValueMap("Default", 0, defaultLanguage);
				setDoubleDefaultValue(mapDefault, 0, "fr-CA");
				setDefaultValueMap(mapPropDouble, mapDefault);
			}//Default value
			addPropDoubleToCategoryMap(mapCategory, mapPropDouble);
		}//Text height
		{
			Map mapPropString = createMap("Text side", "Text side", defaultLanguage);
			setMapName(mapPropString, "fr-CA", "Côté de texte");
			setMapDescription(mapPropString, "en-US", "Text orientation relative to dimensioned points");
			setMapDescription(mapPropString, "fr-CA", "Orientation de texte de cote par rapport aux points mesurés");
			{
				Map mapValues = createValuesMap("en-US");
				{
					String ids_enUS[] = { "Away from dimensioned points", "Towards dimensioned points"};
					String ids_frCA[] = { "Éloigné des points mesurés", "Vers les points mesurés"};
					for (int i = 0; i < ids_enUS.length(); i++) {
						addIDToValuesMap(mapValues, ids_enUS[i]);
						addStringValueToValuesMap(mapValues, "en-US", ids_enUS[i]);
						addStringValueToValuesMap(mapValues, "fr-CA", ids_frCA[i]);
					}
				}//IDs, Values : en - US
				setDefaultID(mapPropString, "Away from dimensioned points");
				setValuesMapToProperty(mapPropString, mapValues);
			}//Values
			addPropStringToCategoryMap(mapCategory, mapPropString);
		}//Text side
		{
			Map mapPropString = createMap("Text orientation", "Text orientation", defaultLanguage);
			setMapName(mapPropString, "fr-CA", "Orientation de texte");
			setMapDescription(mapPropString, "en-US", "Dimension text orientation relative to dimension line");
			setMapDescription(mapPropString, "fr-CA", "Orientation de texte de cote par rapport à la ligne de cote");
			{
				Map mapValues = createValuesMap("en-US");
				{
					String ids_enUS[] = { "Parallel", "Perpendicular"};
					String ids_frCA[] = { "Parallèle", "Perpendiculaire"};
					for (int i = 0; i < ids_enUS.length(); i++) {
						addIDToValuesMap(mapValues, ids_enUS[i]);
						addStringValueToValuesMap(mapValues, "en-US", ids_enUS[i]);
						addStringValueToValuesMap(mapValues, "fr-CA", ids_frCA[i]);
					}
				}//IDs, Values : en - US
				setDefaultID(mapPropString, "Perpendicular");
				setValuesMapToProperty(mapPropString, mapValues);
			}//Values
			addPropStringToCategoryMap(mapCategory, mapPropString);
		}//Text orientation
		addCategoryToPropertiesMap(mapOPMproperties, mapCategory);
	}//Dimension styling
}

//---------------
//--------------- <OPM properties input map> --- end
//endregion

//region Functions to construct OPM properties from map
//--------------- <Functions to construct OPM properties from map> --- start
//---------------

//function to find if properties map has category map at given index
int hasCategoryAtIndex(Map& inPropertiesMap, int inIndex)
{
	String mapKey = inPropertiesMap.keyAt(inIndex);
	return mapKey == "Category";
}

//function to find if category map has property map at given index
int hasPropertyAtIndex(Map& inCategoryMap, int inIndex)
{
	String mapKey = inCategoryMap.keyAt(inIndex);
	return mapKey == "PropString" || mapKey == "PropInt" || mapKey == "PropDouble";
}

//function to get localised name from map given language
String getLocalisedName(Map& inMap, String& inLanguage, String& inDefaultLanguage)
{
	String outName;
	if (inMap.hasString("Name:"+inLanguage)) {
		outName = inMap.getString("Name:"+inLanguage);
	}
	else {
		if (inMap.hasString("Name:Any")) {
			outName = inMap.getString("Name:Any");
		}
		else {
			outName = inMap.getString("Name:"+inDefaultLanguage);
		}
	}
	return outName;
}

//function to get localised description from map given language
String getLocalisedDescription(Map& inMap, String& inLanguage, String& inDefaultLanguage)
{
	String outDescription;
	if (inMap.hasString("Description:"+inLanguage)) {
		outDescription = inMap.getString("Description:"+inLanguage);
	}
	else {
		if (inMap.hasString("Description:Any")) {
			outDescription = inMap.getString("Description:Any");
		}
		else {
			outDescription = inMap.getString("Description:"+inDefaultLanguage);
		}
	}
	return outDescription;
}

//fuction to find if property map is propstring
int isPropString(Map& inPropMap)
{
	return inPropMap.getMapKey() == "PropString";
}

//fuction to find if property map is propint
int isPropInt(Map& inPropMap)
{
	return inPropMap.getMapKey() == "PropInt";
}

//fuction to find if property map is propdouble
int isPropDouble(Map& inPropMap)
{
	return inPropMap.getMapKey() == "PropDouble";
}

//fuction to find if property map has multiple values
int hasMultipleValues(Map& inPropMap)
{
	return inPropMap.hasMap("Values");
}

//function to get a list of string values from values map given language and default language
String[] getStringValuesFromValuesMap(Map& inValuesMap, String& inLanguage, String& inDefaultLanguage)
{
	String outValues[0];
	Map mapValues;
	if (inValuesMap.hasMap("Values:"+inLanguage)) {
		mapValues = inValuesMap.getMap("Values:"+inLanguage);
	}
	else {
		if (inValuesMap.hasMap("Values:Any")) {
			mapValues = inValuesMap.getMap("Values:Any");
		}
		else {
			mapValues = inValuesMap.getMap("Values:"+inDefaultLanguage);
		}
	}
	for (int i=0; i<mapValues.length(); i++) {
		outValues.append(mapValues.getString(i));
	}
	return outValues;
}

//function to get a list of int values from values map given language and default language
int[] getIntValuesFromValuesMap(Map& inValuesMap, String& inLanguage, String& inDefaultLanguage)
{
	int outValues[0];
	Map mapValues;
	if (inValuesMap.hasMap("Values:"+inLanguage)) {
		mapValues = inValuesMap.getMap("Values:"+inLanguage);
	}
	else {
		if (inValuesMap.hasMap("Values:Any")) {
			mapValues = inValuesMap.getMap("Values:Any");
		}
		else {
			mapValues = inValuesMap.getMap("Values:"+inDefaultLanguage);
		}
	}
	for (int i=0; i<mapValues.length(); i++) {
		outValues.append(mapValues.getInt(i));
	}
	return outValues;
}

//function to get a list of double values from values map given language and default language
double[] getDoubleValuesFromValuesMap(Map& inValuesMap, String& inLanguage, String& inDefaultLanguage)
{
	double outValues[0];
	Map mapValues;
	if (inValuesMap.hasMap("Values:"+inLanguage)) {
		mapValues = inValuesMap.getMap("Values:"+inLanguage);
	}
	else {
		if (inValuesMap.hasMap("Values:Any")) {
			mapValues = inValuesMap.getMap("Values:Any");
		}
		else {
			mapValues = inValuesMap.getMap("Values:"+inDefaultLanguage);
		}
	}
	for (int i=0; i<mapValues.length(); i++) {
		outValues.append(mapValues.getDouble(i));
	}
	return outValues;
}

//function to get default ID from property map
String getDefaultID(Map& inPropMap) 
{
	return inPropMap.getString("DefaultID");
}

//function to get a list of IDs from values map
String[] getIDsFromValuesMap(Map& inValuesMap)
{
	String outIDs[0];
	Map mapIDs = inValuesMap.getMap("IDs");
	for (int i=0; i<mapIDs.length(); i++) {
		outIDs.append(mapIDs.getString(i));
	}
	return outIDs;
}

//function to get default value from propstring map given language and default language
String getPropStringDefaultValue(Map& inPropMap, String& inLanguage, String& inDefaultLanguage)
{
	String outSelectedValue;
	Map mapDefault = inPropMap.getMap("DefaultValue");
	if (mapDefault.hasString("Value:"+inLanguage)) {
		outSelectedValue = mapDefault.getString("Value:"+inLanguage);
	}
	else {
		if (mapDefault.hasString("Value:Any")) {
			outSelectedValue = mapDefault.getString("Value:Any");
		}
		else {
			outSelectedValue = mapDefault.getString("Value:"+inDefaultLanguage);
		}
	}

	return outSelectedValue;
}

//function to get default value from propdouble map given language and default language
double getPropDoubleDefaultValue(Map& inPropMap, double& inLanguage, double& inDefaultLanguage)
{
	double outSelectedValue;
	Map mapDefault = inPropMap.getMap("DefaultValue");
	if (mapDefault.hasDouble("Value:"+inLanguage)) {
		outSelectedValue = mapDefault.getDouble("Value:"+inLanguage);
	}
	else {
		if (mapDefault.hasDouble("Value:Any")) {
			outSelectedValue = mapDefault.getDouble("Value:Any");
		}
		else {
			outSelectedValue = mapDefault.getDouble("Value:"+inDefaultLanguage);
		}
	}

	return outSelectedValue;
}

//function to get default value from propint map given language and default language
int getPropIntDefaultValue(Map& inPropMap, int& inLanguage, int& inDefaultLanguage)
{
	int outSelectedValue;
	Map mapDefault = inPropMap.getMap("DefaultValue");
	if (mapDefault.hasInt("Value:"+inLanguage)) {
		outSelectedValue = mapDefault.getInt("Value:"+inLanguage);
	}
	else {
		if (mapDefault.hasInt("Value:Any")) {
			outSelectedValue = mapDefault.getInt("Value:Any");
		}
		else {
			outSelectedValue = mapDefault.getInt("Value:"+inDefaultLanguage);
		}
	}

	return outSelectedValue;
}

//---------------
//--------------- <Functions to construct OPM properties from map> --- end
//endregion

//region Functions to record user selected values map
//--------------- <Functions to record user selected values map> --- start
//---------------

//function to compare two strings after trimming
int compareTrimmed(String& toCompare, String& compareWith)
{
	return toCompare.trimLeft().trimRight() == compareWith.trimLeft().trimRight();
}

//function to get selected id from OPM map given values map
String getSelectedIDFromOPMmap(Map& inOPMmap, Map& inPropMap, String& inLocalisedCategoryName, String& inLocalisedPropertyName)
{
	String outID;
	Map mapValues = inPropMap.getMap("Values");
	String listIDs[] = getIDsFromValuesMap(mapValues);

	for (int q=0; q<inOPMmap.length(); q++) {
		Map thisPropMap = inOPMmap.getMap(q);
		String thisCategory = thisPropMap.getString("strCategory");
		if (thisCategory != "" && !compareTrimmed(thisCategory, inLocalisedCategoryName)) continue;
		String thisName = thisPropMap.getString("strName");
		if (compareTrimmed(thisName, inLocalisedPropertyName)) {
			int thisIndex = thisPropMap.getInt("nEnumIndex");
			outID = listIDs[thisIndex];
			break;
		}
	}
	return outID;
}

//function to get selected value from propstring OPM map
String getPropStringSelectedValueFromOPMmap(Map& inOPMmap, String& inLocalisedCategoryName, String& inLocalisedPropertyName) {
	String outSelectedValue;
	for (int q=0; q<inOPMmap.length(); q++) {
		Map thisPropMap = inOPMmap.getMap(q);
		String thisCategory = thisPropMap.getString("strCategory");
		if (thisCategory != "" && !compareTrimmed(thisCategory, inLocalisedCategoryName)) continue;
		String thisName = thisPropMap.getString("strName");
		if (compareTrimmed(thisName, inLocalisedPropertyName)) {
			outSelectedValue = thisPropMap.getString("strValue");
			break;
		}
	}
	return outSelectedValue;
}  

//function to get selected value from propint OPM map
int getPropIntSelectedValueFromOPMmap(Map& inOPMmap, String& inLocalisedCategoryName, String& inLocalisedPropertyName) {
	int outSelectedValue;
	for (int q=0; q<inOPMmap.length(); q++) {
		Map thisPropMap = inOPMmap.getMap(q);
		String thisCategory = thisPropMap.getString("strCategory");
		if (thisCategory != "" && !compareTrimmed(thisCategory, inLocalisedCategoryName)) continue;
		String thisName = thisPropMap.getString("strName");
		if (compareTrimmed(thisName, inLocalisedPropertyName)) {
			outSelectedValue = thisPropMap.getInt("lValue");
			break;
		}
	}
	return outSelectedValue;
}

//function to get selected value from propdouble OPM map
double getPropDoubleSelectedValueFromOPMmap(Map& inOPMmap, String& inLocalisedCategoryName, String& inLocalisedPropertyName) {
	double outSelectedValue;
	for (int q=0; q<inOPMmap.length(); q++) {
		Map thisPropMap = inOPMmap.getMap(q);
		String thisCategory = thisPropMap.getString("strCategory");
		if (thisCategory != "" && !compareTrimmed(thisCategory, inLocalisedCategoryName)) continue;
		String thisName = thisPropMap.getString("strName");
		if (compareTrimmed(thisName, inLocalisedPropertyName)) {
			outSelectedValue = thisPropMap.getDouble("dValue");
			break;
		}
	}
	return outSelectedValue;
}

//function to check if selected ID is set
int hasSelectedID(Map& inUserSelectedValuesMap, String& inCategoryID, String& inPropertyID) 
{
	return inUserSelectedValuesMap.hasString(inCategoryID + "\\" + inPropertyID + "\\SelectedID");
}

//function to get selected or default id 
String getSelectedID(Map& inUserSelectedValuesMap, String inCategoryID, String inPropertyID) 
{
	return inUserSelectedValuesMap.getString(inCategoryID + "\\" + inPropertyID + "\\SelectedID");
}

//function to record selected ID from user selected values map given category ID and property ID
void setSelectedID(String inSelectedID, Map& inUserSelectedValuesMap, String& inCategoryID, String& inPropertyID)
{ 
	inUserSelectedValuesMap.setString(inCategoryID + "\\" + inPropertyID + "\\SelectedID", inSelectedID);
}

//function to record values map to user selected values map given category ID and property ID
void setValuesMapToUserSelectedValuesMap(Map inValuesMap, Map& inUserSelectedValuesMap, String& inCategoryID, String& inPropertyID)
{
	inUserSelectedValuesMap.setMap(inCategoryID + "\\" + inPropertyID + "\\Values", inValuesMap);
}

//function to get values map from user selected values map given category ID and property ID
Map getValuesMapFromUserSelectedValuesMap(Map& inUserSelectedValuesMap, String& inCategoryID, String& inPropertyID)
{
	return inUserSelectedValuesMap.getMap(inCategoryID + "\\" + inPropertyID + "\\Values");
}

//function to get localised string value from properties map given categoryID, propertyID, language and default language
String getLocalisedStringValue(Map& inUserSelectedValuesMap, String inCategoryID, String inPropertyID, String inLanguage)
{	
	String selectedID = getSelectedID(inUserSelectedValuesMap, inCategoryID, inPropertyID);
	Map mapValues = getValuesMapFromUserSelectedValuesMap(inUserSelectedValuesMap, inCategoryID, inPropertyID);
	String listIDs[] = getIDsFromValuesMap(mapValues);
	int selectedIndex = listIDs.find(selectedID);
	Map mapValuesLocalised = mapValues.getMap("Values:"+inLanguage);
	String outSelectedValue = mapValuesLocalised.getString(selectedIndex);
	
	return outSelectedValue;
}

//function to get localised double value from properties map given categoryID, propertyID, language and default language
double getLocalisedDoubleValue(Map& inUserSelectedValuesMap, String inCategoryID, String inPropertyID, String inLanguage)
{	
	String selectedID = getSelectedID(inUserSelectedValuesMap, inCategoryID, inPropertyID);
	Map mapValues = getValuesMapFromUserSelectedValuesMap(inUserSelectedValuesMap, inCategoryID, inPropertyID);
	String listIDs[] = getIDsFromValuesMap(mapValues);
	int selectedIndex = listIDs.find(selectedID);			
	Map mapValuesLocalised = mapValues.getMap("Values:"+inLanguage);
	double outSelectedValue = mapValuesLocalised.getDouble(selectedIndex);	
	
	return outSelectedValue;
}

//function to get localised int value from properties map given categoryID, propertyID, language and default language
int getLocalisedIntValue(Map& inUserSelectedValuesMap, String inCategoryID, String inPropertyID, String inLanguage)
{	
	String selectedID = getSelectedID(inUserSelectedValuesMap, inCategoryID, inPropertyID);
	Map mapValues = getValuesMapFromUserSelectedValuesMap(inUserSelectedValuesMap, inCategoryID, inPropertyID);
	String listIDs[] = getIDsFromValuesMap(mapValues);
	int selectedIndex = listIDs.find(selectedID);			
	Map mapValuesLocalised = mapValues.getMap("Values:"+inLanguage);
	int outSelectedValue = mapValuesLocalised.getInt(selectedIndex);
	
	return outSelectedValue;
}

//function to check if selected string value is set
int hasSelectedStringValue(Map& inUserSelectedValuesMap, String& inCategoryID, String& inPropertyID) 
{
	return inUserSelectedValuesMap.hasString(inCategoryID + "\\" + inPropertyID + "\\SelectedValue");
}

//function to get selected string value
String getStringSelectedValue(Map& inUserSelectedValuesMap, String inCategoryID, String inPropertyID) 
{
	return inUserSelectedValuesMap.getString(inCategoryID + "\\" + inPropertyID + "\\SelectedValue");
}

//function to record selected string value from user selected values map given category ID and property ID
void setSelectedStringValue(String inSelectedValue, Map& inUserSelectedValuesMap, String& inCategoryID, String& inPropertyID)
{ 
	inUserSelectedValuesMap.setString(inCategoryID + "\\" + inPropertyID + "\\SelectedValue", inSelectedValue);
}

//function to check if selected double value is set
int hasSelectedDoubleValue(Map& inUserSelectedValuesMap, String& inCategoryID, String& inPropertyID) 
{
	return inUserSelectedValuesMap.hasDouble(inCategoryID + "\\" + inPropertyID + "\\SelectedValue");
}

//function to get selected double value
double getDoubleSelectedValue(Map& inUserSelectedValuesMap, String inCategoryID, String inPropertyID) 
{
	return inUserSelectedValuesMap.getDouble(inCategoryID + "\\" + inPropertyID + "\\SelectedValue");
}

//function to record selected double value from user selected values map given category ID and property ID
void setSelectedDoubleValue(double inSelectedValue, Map& inUserSelectedValuesMap, String& inCategoryID, String& inPropertyID)
{ 
	inUserSelectedValuesMap.setDouble(inCategoryID + "\\" + inPropertyID + "\\SelectedValue", inSelectedValue);
}

//function to check if selected int value is set
int hasSelectedIntValue(Map& inUserSelectedValuesMap, String& inCategoryID, String& inPropertyID) 
{
	return inUserSelectedValuesMap.hasInt(inCategoryID + "\\" + inPropertyID + "\\SelectedValue");
}

//function to get selected int value
int getIntSelectedValue(Map& inUserSelectedValuesMap, String inCategoryID, String inPropertyID) 
{
	return inUserSelectedValuesMap.getInt(inCategoryID + "\\" + inPropertyID + "\\SelectedValue");
}

//function to record selected int value from user selected values map given category ID and property ID
void setSelectedIntValue(int inSelectedValue, Map& inUserSelectedValuesMap, String& inCategoryID, String& inPropertyID)
{ 
	inUserSelectedValuesMap.setInt(inCategoryID + "\\" + inPropertyID + "\\SelectedValue", inSelectedValue);
}

//---------------
//--------------- <Functions to record user selected values map> --- end
//endregion

//region Force update selected values 
//--------------- <Force update selected values> --- start
//---------------

if (bForceUpdate || _bOnInsert || _kExecuteKey == callPropertiesTrigger || _kExecuteKey == overridePropertiesTrigger) {
	for (int i = 0; i < mapOPMproperties.length(); i++) {
		if ( ! hasCategoryAtIndex(mapOPMproperties, i)) continue;
		Map mapCategory = mapOPMproperties.getMap(i);
		String categoryID = mapCategory.getString("ID");
		String localisedCategoryName = getLocalisedName(mapCategory, currentLanguage, defaultLanguage);
		for (int k = 0; k < mapCategory.length(); k++) {
			if ( ! hasPropertyAtIndex(mapCategory, k)) continue;
			Map mapProperty = mapCategory.getMap(k);
			String propertyID = mapProperty.getString("ID");
			String localisedPropertyName = getLocalisedName(mapProperty, currentLanguage, defaultLanguage);
			String localisedPropertyDescription = getLocalisedDescription(mapProperty, currentLanguage, defaultLanguage);
			
			if (hasMultipleValues(mapProperty)) {
				if (!hasSelectedID(mapUserSelectedValues, categoryID, propertyID)) {
					setSelectedID(getDefaultID(mapProperty), mapUserSelectedValues, categoryID, propertyID);
					setValuesMapToUserSelectedValuesMap(mapProperty.getMap("Values"), mapUserSelectedValues, categoryID, propertyID);
				}
			}
			else {
				if (isPropString(mapProperty)) {
					if (!hasSelectedStringValue(mapUserSelectedValues, categoryID, propertyID)) {
						setSelectedStringValue(getPropStringDefaultValue(mapProperty, currentLanguage, defaultLanguage), mapUserSelectedValues, categoryID, propertyID);	
					}	
				}
				else if (isPropDouble(mapProperty)) {
					if (!hasSelectedDoubleValue(mapUserSelectedValues, categoryID, propertyID)) {
						setSelectedDoubleValue(getPropDoubleDefaultValue(mapProperty, currentLanguage, defaultLanguage), mapUserSelectedValues, categoryID, propertyID);	
					}	
				}
				else if (isPropInt(mapProperty)) {
					if (!hasSelectedIntValue(mapUserSelectedValues, categoryID, propertyID)) {
						setSelectedIntValue(getPropIntDefaultValue(mapProperty, currentLanguage, defaultLanguage), mapUserSelectedValues, categoryID, propertyID);	
					}	
				}
			}
		}
	}	
	mapUserSelectedValues.setInt("Version", _ThisInst.version());
}

//---------------
//--------------- <Force update selected values> --- end
//endregion

//region OPM properties build from map
//--------------- <OPM properties build from map> --- start
//---------------

if (_bOnInsert || _kExecuteKey == callPropertiesTrigger || _kExecuteKey == overridePropertiesTrigger) {
	int stringPropertyCounter = 0;
	int doublePropertyCounter = 0;
	int intPropertyCounter = 0;
	for (int i = 0; i < mapOPMproperties.length(); i++) {
		if ( ! hasCategoryAtIndex(mapOPMproperties, i)) continue;
		Map mapCategory = mapOPMproperties.getMap(i);
		String categoryID = mapCategory.getString("ID");
		String localisedCategoryName = getLocalisedName(mapCategory, currentLanguage, defaultLanguage);
		for (int k = 0; k < mapCategory.length(); k++) {
			if ( ! hasPropertyAtIndex(mapCategory, k)) continue;
			Map mapProperty = mapCategory.getMap(k);
			String propertyID = mapProperty.getString("ID");
			String localisedPropertyName = getLocalisedName(mapProperty, currentLanguage, defaultLanguage);
			String localisedPropertyDescription = getLocalisedDescription(mapProperty, currentLanguage, defaultLanguage);
			if (isPropString(mapProperty)) {
				if (hasMultipleValues(mapProperty)) {
					Map mapValues = mapProperty.getMap("Values");
					String listValues[] = getStringValuesFromValuesMap(mapValues, currentLanguage, defaultLanguage);
					String selectedID = getSelectedID(mapUserSelectedValues, categoryID, propertyID);
					String listIDs[] = getIDsFromValuesMap(mapValues);
					int selectedIndex = listIDs.find(selectedID);
					PropString thisProperty(stringPropertyCounter++, listValues, localisedPropertyName, selectedIndex);
					thisProperty.setCategory(localisedCategoryName);
					thisProperty.setDescription(localisedPropertyDescription);
				}
				else {
					int isValidValue = false;
					String selectedValue = getStringSelectedValue(mapUserSelectedValues, categoryID, propertyID);
					PropString thisProperty(stringPropertyCounter++, selectedValue, localisedPropertyName);
					thisProperty.setCategory(localisedCategoryName);
					thisProperty.setDescription(localisedPropertyDescription);
				}
			}
			else if (isPropDouble(mapProperty)) {
				if (hasMultipleValues(mapProperty)) {
					Map mapValues = mapProperty.getMap("Values");
					double listValues[] = getDoubleValuesFromValuesMap(mapValues, currentLanguage, defaultLanguage);
					String selectedID = getSelectedID(mapUserSelectedValues, categoryID, propertyID);
					String listIDs[] = getIDsFromValuesMap(mapValues);
					int selectedIndex = listIDs.find(selectedID);
					PropDouble thisProperty(doublePropertyCounter++, listValues, localisedPropertyName, selectedIndex);
					thisProperty.setCategory(localisedCategoryName);
					thisProperty.setDescription(localisedPropertyDescription);
				}
				else {
					int isValidValue = false;
					double selectedValue = getDoubleSelectedValue(mapUserSelectedValues, categoryID, propertyID);
					PropDouble thisProperty(doublePropertyCounter++, selectedValue, localisedPropertyName);
					thisProperty.setFormat(getPropDoubleUnitType(mapProperty));
					thisProperty.setCategory(localisedCategoryName);
					thisProperty.setDescription(localisedPropertyDescription);
				}
			}
			else if (isPropInt(mapProperty)) {
				if (hasMultipleValues(mapProperty)) {
					Map mapValues = mapProperty.getMap("Values");
					int listValues[] = getIntValuesFromValuesMap(mapValues, currentLanguage, defaultLanguage);
					String selectedID = getSelectedID(mapUserSelectedValues, categoryID, propertyID);
					String listIDs[] = getIDsFromValuesMap(mapValues);
					int selectedIndex = listIDs.find(selectedID);
					PropInt thisProperty(intPropertyCounter++, listValues, localisedPropertyName, selectedIndex);
					thisProperty.setCategory(localisedCategoryName);
					thisProperty.setDescription(localisedPropertyDescription);
				}
				else {
					int isValidValue = false;
					int selectedValue = getIntSelectedValue(mapUserSelectedValues, categoryID, propertyID);
					PropInt thisProperty(intPropertyCounter++, selectedValue, localisedPropertyName);
					thisProperty.setCategory(localisedCategoryName);
					thisProperty.setDescription(localisedPropertyDescription);
				}
			}
		}
	}
	
}
//---------------
//--------------- <OPM properties build from map> --- end
//endregion

//region Show OPM dialog
//--------------- <Show OPM dialog> --- start
//---------------

if (_bOnInsert || _kExecuteKey == callPropertiesTrigger || _kExecuteKey == overridePropertiesTrigger) {

	showDialog("|_Default|");
	//showDialog();
	
	Map mapFromOPM = mapWithPropValues();
	Map mapPropStrings = mapFromOPM.getMap("PropString[]");
	Map mapPropDoubles = mapFromOPM.getMap("PropDouble[]");
	Map mapPropInts = mapFromOPM.getMap("PropInt[]");
	
	for (int i=0; i<mapOPMproperties.length(); i++) {
		if (!hasCategoryAtIndex(mapOPMproperties, i)) continue;
		Map mapCategory = mapOPMproperties.getMap(i);
		String categoryID = mapCategory.getString("ID");
		String localisedCategoryName = getLocalisedName(mapCategory, currentLanguage, defaultLanguage);

		for (int k=0; k<mapCategory.length(); k++) {
			if (!hasPropertyAtIndex(mapCategory, k)) continue;
			Map mapProperty = mapCategory.getMap(k);
			String propertyID = mapProperty.getString("ID");
			String localisedPropertyName = getLocalisedName(mapProperty, currentLanguage, defaultLanguage);

			if (isPropString(mapProperty)) {
				if (hasMultipleValues(mapProperty)) {
					String selectedID = getSelectedIDFromOPMmap(mapPropStrings, mapProperty, localisedCategoryName, localisedPropertyName);
					setSelectedID(selectedID, mapUserSelectedValues, categoryID, propertyID);
				}
				else {
					String selectedValue = getPropStringSelectedValueFromOPMmap(mapPropStrings, localisedCategoryName, localisedPropertyName);
					setSelectedStringValue(selectedValue, mapUserSelectedValues, categoryID, propertyID);
				}
			}
			else if (isPropDouble(mapProperty)) {
				if (hasMultipleValues(mapProperty)) {
					String selectedID = getSelectedIDFromOPMmap(mapPropDoubles, mapProperty, localisedCategoryName, localisedPropertyName);
					setSelectedID(selectedID, mapUserSelectedValues, categoryID, propertyID);
				}
				else {
					double selectedValue = getPropDoubleSelectedValueFromOPMmap(mapPropDoubles, localisedCategoryName, localisedPropertyName);
					setSelectedDoubleValue(selectedValue, mapUserSelectedValues, categoryID, propertyID);
				}
			}
			else if (isPropInt(mapProperty)) {
				if (hasMultipleValues(mapProperty)) {
					String selectedID = getSelectedIDFromOPMmap(mapPropInts, mapProperty, localisedCategoryName, localisedPropertyName);
					setSelectedID(selectedID, mapUserSelectedValues, categoryID, propertyID);
				}
				else {
					int selectedValue = getPropIntSelectedValueFromOPMmap(mapPropInts, localisedCategoryName, localisedPropertyName);
					setSelectedIntValue(selectedValue, mapUserSelectedValues, categoryID, propertyID);
				}
			}

		}
	}	
	
	mapUserSelectedValues.setInt("Version", _ThisInst.version());
	if (mapDimensionProperties.hasMap("UserSelectedValues"+"~"+thisElement.handle())) {
		mapDimensionProperties.setMap("UserSelectedValues" + "~" + thisElement.handle(), mapUserSelectedValues);
	}
	else {
		if (_kExecuteKey == overridePropertiesTrigger) {
			mapDimensionProperties.appendMap("UserSelectedValues"+"~"+thisElement.handle(), mapUserSelectedValues);	
		}
		else {
			mapDimensionProperties.setMap("UserSelectedValues", mapUserSelectedValues);	
		}
	}
	_Map.setMap(dimensionTypeName, mapDimensionProperties);
}

//---------------
//--------------- <Show OPM dialog> --- end
//endregion

//region Grip points map
//--------------- <Grip points map> --- start
//---------------

//function to get grip points map from dimension properties map
Map getGripPointsMap(Map& inDimensionPropertiesMap)
{
	Map mapVisualControls = inDimensionPropertiesMap.getMap("VisualControls"+"~"+thisElement.handle());
	Map outGripPointsMap = mapVisualControls.getMap("GripPoint[]");
	return outGripPointsMap;
}

//function to remove grip points map from dimension properties map
void removeGripPointsMap(Map& inDimensionPropertiesMap)
{
	Map mapVisualControls = inDimensionPropertiesMap.getMap("VisualControls"+"~"+thisElement.handle());
	mapVisualControls.removeAt("GripPoint[]", false);
	inDimensionPropertiesMap.setMap("VisualControls"+"~"+thisElement.handle(), mapVisualControls);
}

//function to get grip points from map
Grip[] getGripPointsFromMap(Map& inMap) 
{
	Grip outGripPoints[0];
	for (int i=0; i<inMap.length(); i++) {
		Point3d thisGripPoint = inMap.getPoint3d(i);
		thisGripPoint.transformBy(modelToPaperTransformation);
		Grip thisGrip(thisGripPoint);
		thisGrip.setName(inMap.keyAt(i));
		outGripPoints.append(thisGrip);
	}
	return outGripPoints;
}

//fuction to set grip points map in dimension properties map
void setGripPointsMap(Map& inDimensionPropertiesMap, Map& inGripPointsMap)
{
	Map mapVisualControls = inDimensionPropertiesMap.getMap("VisualControls"+"~"+thisElement.handle());
	mapVisualControls.setMap("GripPoint[]", inGripPointsMap);
	inDimensionPropertiesMap.setMap("VisualControls"+"~"+thisElement.handle(), mapVisualControls);
}

if (_kExecuteKey == resetGripPointsTrigger) {
	removeGripPointsMap(mapDimensionProperties);
}
Map mapGrips = getGripPointsMap(mapDimensionProperties);
Grip dimensionGrips[] = getGripPointsFromMap(mapGrips);
if (bGripsReset){
	_Grip.append(dimensionGrips);
}

//function to create map from grip points
Map createMapFromGripPoints(Grip& inGripPoints[]) 
{
	Map mapGripPoints;
	for (int i=0; i<inGripPoints.length(); i++) {
		Point3d	thisGripPoint = inGripPoints[i].ptLoc();
		thisGripPoint.transformBy(paperToModelTransformation);
		mapGripPoints.appendPoint3d(inGripPoints[i].name(), thisGripPoint);
	}
	return mapGripPoints;
}

//function to remove grips from tsl grips given dimension type name
void removeGripsFromTSLGrips(String& inDimensionTypeName)
{
	for (int i=_Grip.length()-1; i>=0; i--) {
		Grip& thisGrip = _Grip[i];
		String dimensionTypeFromGrip = thisGrip.name().token(0, "~");
		if (dimensionTypeFromGrip == inDimensionTypeName) {
			_Grip.removeAt(i);
		}
	}
}

//function to record grips into dimension properties map and reset tsl grips
void recordGripsToDimensionPropertiesmap(Map& inDimensionPropertiesMap, Grip& inGrips[]) 
{
	Map mapGripPoints = createMapFromGripPoints(inGrips);
	setGripPointsMap(inDimensionPropertiesMap, mapGripPoints);
}

//function to get grip points given dimesion type name
Grip[] getGripPointsOfDimensionType(String& inDimensionTypeName)
{
	Grip outGripPoints[0];
	for (int i=0; i<_Grip.length(); i++) {
		Grip& thisGrip = _Grip[i];
		String dimensionTypeFromGrip = thisGrip.name().token(0, "~");
		if (dimensionTypeFromGrip == inDimensionTypeName) {
			outGripPoints.append(thisGrip);
		}
	}

	return outGripPoints;
}

//---------------
//--------------- <Grip points map> --- end
//endregion

//region Functions to control grip points
//--------------- <Functions to control grip points> --- start
//---------------

//function check if grip point is on genbeam edge
int isGripOnGenbeamEdge(Grip& inGrip, LineSeg& inEdgeSegment) 
{
	Point3d gripPoint = inGrip.ptLoc();
	gripPoint.transformBy(paperToModelTransformation);

	return PLine(inEdgeSegment.ptStart(), inEdgeSegment.ptEnd()).isOn(gripPoint);
}

//function to get genbeam it belongs to
GenBeam getGenbeamFromGrip(Grip& inGrip) {
	String gripName = inGrip.name();
	Entity genbeamEntity;
	genbeamEntity.setFromHandle(gripName);	

	return (GenBeam) genbeamEntity;
}

//function to get grips that belong to genbeam
Grip[] getGripsAtGenbeam(Grip& inGrips, GenBeam& inGenbeam) 
{
	Grip outGripPoints[0];
	String genbeamHandle = inGenbeam.handle();
	for (int i=0; i<inGrips.length(); i++) {
		Grip& thisGrip = inGrips[i];
		String handleFromGrip = thisGrip.name().token(1, "~");
		if (handleFromGrip == inGenbeam.handle()) {
			outGripPoints.append(thisGrip);
		}
	}

	return outGripPoints;
}

//function to get grip point that is dimension line position
Grip getGripPointDimensionLinePosition(Grip& inGrips[], int& outIsValidPoint) 
{
	Grip outGripPoint;
	for (int i=0; i<inGrips.length(); i++) {
		Grip& thisGrip = inGrips[i];
		String gripName = thisGrip.name().token(1, "~");
		if (gripName == "Dimension line position") {
			outGripPoint = thisGrip;
			outIsValidPoint = true;
			break;
		}
	}
	return outGripPoint;
}

//function to set grip point that is dimension line position
void setGripPointDimensionLinePosition(Grip& inGrips[], Point3d& inGripPoint, Map& inMapDimensionProperties, String& inDimensionTypeName) 
{
	int isValidPoint = false;
	for (int i=0; i<inGrips.length(); i++) {
		Grip& thisGrip = inGrips[i];
		String gripName = thisGrip.name().token(1, "~");
		if (gripName == "Dimension line position") {
			thisGrip.setPtLoc(inGripPoint);
			isValidPoint = true;
			break;
		}
	}
	if (!isValidPoint) {
		Grip newGripPoint(inGripPoint);
		newGripPoint.setName(inDimensionTypeName+"~Dimension line position");
		inGrips.append(newGripPoint);
	}
	recordGripsToDimensionPropertiesmap(inMapDimensionProperties, inGrips);
	_Map.setMap(dimensionTypeName, inMapDimensionProperties);
}

//---------------
//--------------- <Functions to control grip points> --- end
//endregion

//region Genbeam functions
//--------------- <Genbeam functions> --- start
//---------------

//function to get dimension line direction given properties map
Vector3d getDimensionLineDirectionFromPropertiesMap(Map& inUserSelectedValuesMap)
{
	String dimensionOrientation = getSelectedID(inUserSelectedValuesMap, "Dimension styling", "Dimension orientation");
	String dimensionDirection = getSelectedID(inUserSelectedValuesMap, "Dimension styling", "Dimension direction");
	Vector3d outDimensionDirection;
	if (dimensionOrientation == "Vertical left" || dimensionOrientation == "Vertical right") {
		outDimensionDirection = layoutYInModel;
	}
	else if (dimensionOrientation == "Horizontal top" || dimensionOrientation == "Horizontal bottom") {
		outDimensionDirection = layoutXInModel;
	}
	if (dimensionDirection == "Reverse") {
		outDimensionDirection *= -1;
	}

	return outDimensionDirection;
}

//function to get projection plane for this viewport
Plane getProjectionPlaneForThisViewport()
{
	Point3d pointViewport = thisViewPort.ptCenPS();
	pointViewport.transformBy(paperToModelTransformation);
  	
	return Plane(pointViewport, layoutZInModel);
}

//function get projection plane closest to viewport plane
Plane getClosestProjectionPlane(Map& inUserSelectedValuesMap)
{
	Plane viewportPlane = getProjectionPlaneForThisViewport();
	Point3d zonePoints[0];
	int zoneIndexToDimension = getLocalisedIntValue(inUserSelectedValuesMap, "Genbeams to dimension", "Zone", "Any");
	ElemZone zoneToDimension = thisElement.zone(zoneIndexToDimension);
	zonePoints.append(zoneToDimension.ptOrg());
	zonePoints.append(zoneToDimension.ptOrg() +zoneToDimension.vecZ()*zoneToDimension.dH());
	int zoneIndexToReference = getLocalisedIntValue(inUserSelectedValuesMap, "Genbeams to reference", "Zone", "Any");
	ElemZone zoneToReference = thisElement.zone(zoneIndexToReference);
	zonePoints.append(zoneToReference.ptOrg());
	zonePoints.append(zoneToReference.ptOrg() +zoneToReference.vecZ()*zoneToReference.dH());
	Point3d zonePointsOrdered[] = Line(viewportPlane.ptOrg(), viewportPlane.normal()).orderPoints(zonePoints);
	
	return Plane(zonePointsOrdered.last(), viewportPlane.normal());
}

//function to get most aligning vector including length vector from genbeam
Vector3d getAlignedVector(GenBeam& inGenbeam, Vector3d inReferenceVector, int& outIsAlignedWithLength) {
	Vector3d outVector;
	Vector3d genbeamVectors[] = { inGenbeam.vecX(), inGenbeam.vecY(), inGenbeam.vecZ()};
	double minAngle = 180;
	for (int i=0; i<genbeamVectors.length(); i++) {
		Vector3d& thisVector = genbeamVectors[i];
		double thisAngle = thisVector.angleTo(inReferenceVector);
		if (thisAngle > 90) thisAngle = 180 - thisAngle;
		if (thisAngle < minAngle) {
			outVector = thisVector;
			minAngle = thisAngle;
		}
	}
	if (outVector == genbeamVectors[0]) {
		outIsAlignedWithLength = true;	
	}
	if (outVector.dotProduct(inReferenceVector) < 0) {
		outVector *= -1;	
	}
	
	return outVector;
}

//function to get genbeam outline for this viewport
PlaneProfile getGenbeamOutline(GenBeam& inGenbeam, Vector3d inDirection)
{
	int isAlignedToLength = false;
	Vector3d thisNormal = getAlignedVector(inGenbeam, -inDirection, isAlignedToLength);
	Point3d extremes[] = inGenbeam.realBody().extremeVertices(thisNormal);
	Plane contactPlane(extremes.last(), thisNormal);
	double distToCen = (contactPlane.ptOrg()-inGenbeam.ptCen()).dotProduct(thisNormal);
	PlaneProfile outOutline = inGenbeam.realBody().extractContactFaceInPlane(contactPlane, distToCen);
	if (!outOutline.bIsValid() || outOutline.area() < mmToDrawingUnits(1)*mmToDrawingUnits(1)) {
		AnalysedTool thisAtools[] = inGenbeam.analysedTools();
		AnalysedCut thisAcuts[] = AnalysedCut().filterToolsOfToolType(thisAtools);
		int useHip = ! isAlignedToLength;
		for (int i=thisAcuts.length()-1; i>=0; i--) {
			AnalysedCut& thisAcut = thisAcuts[i];
			int isHip = thisAcut.toolSubType() == _kACHip;
			if ((useHip && !isHip) || (!useHip && isHip)) {
				thisAcuts.removeAt(i);
			}
		}
		int thisIndexClosest = AnalysedCut().findClosest(thisAcuts, extremes.last());
		if (thisIndexClosest >= 0) {
			AnalysedCut closestAcut = thisAcuts[thisIndexClosest];
			Vector3d thisNormal = closestAcut.normal();
			if (thisNormal.dotProduct(inDirection) > 0) {
				thisNormal *= -1;	
			}
			contactPlane = Plane(extremes.last(), thisNormal);
			distToCen = LineSeg(inGenbeam.ptCen(), contactPlane.closestPointTo(inGenbeam.ptCen())).length();
			outOutline = inGenbeam.realBody().extractContactFaceInPlane(contactPlane, distToCen);
		}
	}
	outOutline.removeAllOpeningRings();
	
	return outOutline;
}

//function to get genbeam outlines for this viewport
PlaneProfile[] getGenbeamOutlines(GenBeam& inGenbeams[])
{
	PlaneProfile outOutlines[0];
	for (int i=0; i<inGenbeams.length(); i++) {
		GenBeam& thisGenbeam = inGenbeams[i];
		PlaneProfile thisOutline = getGenbeamOutline(thisGenbeam, layoutZInModel);
		outOutlines.append(thisOutline);
	}
	
	return outOutlines;
}

//function to get joined outline
PlaneProfile getJoinedOutline(Map& inUserSelectedValuesMap, PlaneProfile& inOutlines)
{
	Plane workingPlane = getClosestProjectionPlane(inUserSelectedValuesMap);
	PlaneProfile outJoinedOutline(workingPlane);
	for (int i=0; i<inOutlines.length(); i++) {
		PlaneProfile& thisOutline = inOutlines[i];
		if (i == 0) outJoinedOutline = thisOutline;
		else outJoinedOutline.unionWith(thisOutline);
	}
	if (inOutlines.length() > 1) {
		double smoothingDistance = mmToDrawingUnits(1);
		outJoinedOutline.shrink(-1*smoothingDistance);
		outJoinedOutline.shrink(smoothingDistance);
		outJoinedOutline.simplify();
	}
	
	return outJoinedOutline;
}

//function to get outline for selected zones
PlaneProfile getGenbeamOverallOutline(Map& inUserSelectedValuesMap) 
{
	int zoneIndexToDimension = getLocalisedIntValue(inUserSelectedValuesMap, "Genbeams to dimension", "Zone", "Any");
	int zoneIndexToReference = getLocalisedIntValue(inUserSelectedValuesMap, "Genbeams to reference", "Zone", "Any");
	GenBeam genbeamAll[] = thisElement.genBeam(zoneIndexToDimension);
	if (zoneIndexToReference != zoneIndexToDimension) {
		genbeamAll.append(thisElement.genBeam(zoneIndexToReference));	
	}
	PlaneProfile outlinesAll[] = getGenbeamOutlines(genbeamAll);
	
	return getJoinedOutline(inUserSelectedValuesMap, outlinesAll);
}

//function to get bounding box outline for this element
PlaneProfile getElementBoundingBoxOutline(Map& inUserSelectedValuesMap, int keepEntireElement, Vector3d& inDirectionAwayFromDimensionLine)
{
	PlaneProfile elementOutline = getGenbeamOverallOutline(inUserSelectedValuesMap);
	Point3d elementVertexPoints[] = elementOutline.getGripVertexPoints();
	Point3d pointsInAwayDirection[] = Line(thisElement.ptOrg(), inDirectionAwayFromDimensionLine).orderPoints(elementVertexPoints);
	Vector3d dimlineDirection = inDirectionAwayFromDimensionLine.crossProduct(layoutZInModel);
	Point3d pointsInDimlineDirection[] = Line(thisElement.ptOrg(), dimlineDirection).orderPoints(elementVertexPoints);
	LineSeg minmaxSegment(Line(pointsInAwayDirection.first(), dimlineDirection).closestPointTo(pointsInDimlineDirection.first()),
						  Line(pointsInAwayDirection.last(), dimlineDirection).closestPointTo(pointsInDimlineDirection.last()));
	if (!keepEntireElement) {
		minmaxSegment = LineSeg(minmaxSegment.ptStart(), Line(minmaxSegment.ptMid(), dimlineDirection).closestPointTo(minmaxSegment.ptEnd()));	
	}
	PlaneProfile outElementBoundingBox;
	outElementBoundingBox.createRectangle(minmaxSegment, inDirectionAwayFromDimensionLine, dimlineDirection);
	
	return outElementBoundingBox;
}

//function to get genbeams filtered by zone and filters
GenBeam[] getGenbeamsFiltered(int& inSelectedZoneIndex, String& inIncludeFilter, String& inExcludeFilter)
{
	GenBeam outGenbeamFiltered[0];
	if (abs(inSelectedZoneIndex)<=5) {
		outGenbeamFiltered.append(thisElement.genBeam(inSelectedZoneIndex));
	}
	else {
		outGenbeamFiltered.append(thisElement.genBeam());
	}

	if (inIncludeFilter != "None" && outGenbeamFiltered.length() >= 1) {
		PainterDefinition includePainterDefinition(inIncludeFilter);
		GenBeam genbeamsIncluded[] = includePainterDefinition.filterAcceptedEntities(outGenbeamFiltered);
		outGenbeamFiltered = genbeamsIncluded;
	}
	if (inExcludeFilter != "None" && outGenbeamFiltered.length() >= 1) {
		PainterDefinition excludePainterDefinition(inExcludeFilter);
		GenBeam genbeamsExclude[] = excludePainterDefinition.filterAcceptedEntities(outGenbeamFiltered);
		if (genbeamsExclude.length() >= 1) {
			for (int i=0; i<genbeamsExclude.length(); i++) {
				GenBeam& thisGenbeam = genbeamsExclude[i];
				int iFindGenbeam = outGenbeamFiltered.find(thisGenbeam);
				if (iFindGenbeam >= 0 && outGenbeamFiltered.length() >= 1) {
					outGenbeamFiltered.removeAt(iFindGenbeam);
				}
			}
		}
	}
	return outGenbeamFiltered;
}

//function to get direction away from dimension line given properties map
Vector3d getDirectionAwayFromDimensionLineFromPropertiesMap(Map& inUserSelectedValuesMap)
{
	String dimensionOrientation = getSelectedID(inUserSelectedValuesMap, "Dimension styling", "Dimension orientation");
	Vector3d outDirectionAwayFromDimensionLine;
	if (dimensionOrientation == "Vertical left") {
		outDirectionAwayFromDimensionLine = layoutXInModel;
	}
	else if (dimensionOrientation == "Vertical right") {
		outDirectionAwayFromDimensionLine = layoutXInModel * -1;
	}
	else if (dimensionOrientation == "Horizontal top") {
		outDirectionAwayFromDimensionLine = layoutYInModel * -1;
	}
	else if (dimensionOrientation == "Horizontal bottom") {
		outDirectionAwayFromDimensionLine = layoutYInModel;
	}
	return outDirectionAwayFromDimensionLine;
}

//function to get dimensioned genbeams given properties map
GenBeam[] getDimensionedGenbeamsFromPropertiesMap(Map& inUserSelectedValuesMap, Vector3d& inDirectionAwayFromDimensionLine)
{
	GenBeam outGenbeams[0];	
	int selectedZoneIndex = getLocalisedIntValue(inUserSelectedValuesMap, "Genbeams to dimension", "Zone", "Any");	
	String includeFilter = getSelectedID(inUserSelectedValuesMap, "Genbeams to dimension", "Include filter");
	String excludeFilter = getSelectedID(inUserSelectedValuesMap, "Genbeams to dimension", "Exclude filter");
	outGenbeams.append(getGenbeamsFiltered(selectedZoneIndex, includeFilter, excludeFilter));
	
	String elementSide = getSelectedID(inUserSelectedValuesMap, "Genbeams to dimension", "Element side");
	if (elementSide == "Half of element") {
		PlaneProfile elementBoundingBoxOutline = getElementBoundingBoxOutline(inUserSelectedValuesMap, false, inDirectionAwayFromDimensionLine);
		PlaneProfile genbeamOutlines[] = getGenbeamOutlines(outGenbeams);
		for (int i=genbeamOutlines.length()-1; i>=0; i--) {
			PlaneProfile& thisGenbeamOutline = genbeamOutlines[i];
			if (!thisGenbeamOutline.intersectWith(elementBoundingBoxOutline)) {
				outGenbeams.removeAt(i);
			}
		}
	}

	return outGenbeams;
}

//function to get referenced genbeams given properties map
GenBeam[] getReferencedGenbeamsFromPropertiesMap(Map& inUserSelectedValuesMap, Vector3d& inDirectionAwayFromDimensionLine)
{
	GenBeam outGenbeams[0];
	int selectedZoneIndex = getLocalisedIntValue(inUserSelectedValuesMap, "Genbeams to reference", "Zone", "Any");
	String includeFilter = getSelectedID(inUserSelectedValuesMap, "Genbeams to reference", "Include filter");
	String excludeFilter = getSelectedID(inUserSelectedValuesMap, "Genbeams to reference", "Exclude filter");
	outGenbeams.append(getGenbeamsFiltered(selectedZoneIndex, includeFilter, excludeFilter));

	String elementSide = getSelectedID(inUserSelectedValuesMap, "Genbeams to reference", "Element side");
	if (elementSide == "Half of element") {
		PlaneProfile elementBoundingBoxOutline = getElementBoundingBoxOutline(inUserSelectedValuesMap, false, inDirectionAwayFromDimensionLine);
		PlaneProfile genbeamOutlines[] = getGenbeamOutlines(outGenbeams);
		for (int i=genbeamOutlines.length()-1; i>=0; i--) {
			PlaneProfile& thisGenbeamOutline = genbeamOutlines[i];
			if (!thisGenbeamOutline.intersectWith(elementBoundingBoxOutline)) {
				outGenbeams.removeAt(i);
			}
		}
	}

	return outGenbeams;
}

//function to get edge points from outline given direction away
void getEdgePointsInDirectionAway(PlaneProfile& inOutline, GenBeam& inGenbeams[], Vector3d& inDirectionAwayFromDimensionLine, Point3d& outEdgePointsClosest[], Point3d& outEdgePointsFurthest[])
{
	Point3d outlineVertices[] = inOutline.getGripVertexPoints();
	outlineVertices.append(outlineVertices.first());
	for (int i=0; i<inGenbeams.length(); i++) {
		GenBeam& thisGenbeam = inGenbeams[i];
		PlaneProfile outlineClosest = getGenbeamOutline(thisGenbeam, inDirectionAwayFromDimensionLine);
		Point3d outlineVerticesClosest[] = outlineClosest.getGripVertexPoints();
		outlineVerticesClosest.append(outlineVerticesClosest.first());
		PlaneProfile outlineFurthest = getGenbeamOutline(thisGenbeam, -inDirectionAwayFromDimensionLine);
		Point3d outlineVerticesFurthest[] = outlineFurthest.getGripVertexPoints();
		outlineVerticesFurthest.append(outlineVerticesFurthest.first());		
		for (int k=1; k<outlineVertices.length(); k++) {
			Point3d& point = outlineVertices[k-1];
			Point3d& pointNext = outlineVertices[k];
			if (outlineClosest.coordSys().vecZ().isPerpendicularTo(pointNext - point)) {
				for (int m = 0; m < outlineVerticesClosest.length(); m++) {
					Point3d& thisPoint = outlineVerticesClosest[m];
					if (LineSeg(thisPoint, point).length() < mmToDrawingUnits(0.1) || LineSeg(thisPoint, pointNext).length() < mmToDrawingUnits(0.1)) {
						outEdgePointsClosest.append(point);
						outEdgePointsClosest.append(pointNext);
						break;
					}
				}
			}
			if (outlineFurthest.coordSys().vecZ().isPerpendicularTo(pointNext - point)) {
				for (int m = 0; m < outlineVerticesFurthest.length(); m++) {
					Point3d& thisPoint = outlineVerticesFurthest[m];
					if (LineSeg(thisPoint, point).length() < mmToDrawingUnits(0.1) || LineSeg(thisPoint, pointNext).length() < mmToDrawingUnits(0.1)) {
						outEdgePointsFurthest.append(point);
						outEdgePointsFurthest.append(pointNext);
						break;
					}
				}
			}
		}
	}
}

//function to get lumps from plane profile
PlaneProfile[] getLumps(PlaneProfile& inPlaneProfile) 
{ 
	PlaneProfile outLumps[0];
	PLine profileRings[] = inPlaneProfile.allRings(true, false);
	for (int i=0; i<profileRings.length(); i++) {
		outLumps.append(PlaneProfile(profileRings[i]));
	}
	
	return outLumps;
}

//function to get genbeams in genbeam pack outline
GenBeam[] getGenbeamsFromPackOutline(PlaneProfile& inPackOutline, GenBeam& inGenbeamCandidates[]) 
{ 
	GenBeam outGenbeamsInPack[0];
	for (int i=0; i<inGenbeamCandidates.length(); i++) {
		GenBeam& thisGenbeam = inGenbeamCandidates[i];
		if (inPackOutline.pointInProfile(thisGenbeam.ptCen()) == _kPointInProfile) {
			outGenbeamsInPack.append(thisGenbeam);	
		}
	}
	
	return outGenbeamsInPack;
}

//function to get dimension points given properties map
Point3d[] getPointsToDimension(Map& inUserSelectedValuesMap, GenBeam& inGenbeamsToDimension[], Vector3d& inDirectionAwayFromDimensionLine, Vector3d& inDimensionDirection)
{
	
	String genbeamSide = getSelectedID(inUserSelectedValuesMap, "Genbeams to dimension", "Genbeam side");
	String pointsToDimension = getSelectedID(inUserSelectedValuesMap, "Genbeams to dimension", "Points to dimension");
	String dimPacks = getSelectedID(inUserSelectedValuesMap, "Genbeams to dimension", "Pack dimensioned genbeams");
	String hatchPattern = getSelectedID(inUserSelectedValuesMap, "Dimension options", "Hatch pattern");
	double hatchScale = getDoubleSelectedValue(inUserSelectedValuesMap, "Dimension options", "Hatch scale");
	if (hatchScale == 0) hatchScale = 1;
	hatchScale *= viewportScale;
	double hatchAngle = getDoubleSelectedValue(inUserSelectedValuesMap, "Dimension options", "Hatch angle");
	int hatchColour = getIntSelectedValue(inUserSelectedValuesMap, "Dimension options", "Hatch colour");
	int hatchTransparency = getIntSelectedValue(inUserSelectedValuesMap, "Dimension options", "Hatch transparency");

	Point3d outPointsToDimension[0];
	PlaneProfile dimensionedOutlines[] = getGenbeamOutlines(inGenbeamsToDimension);	
	if (dimPacks == "Yes") {
		PlaneProfile dimensionedJoinedOutline = getJoinedOutline(inUserSelectedValuesMap, dimensionedOutlines);
		PlaneProfile packOutlines[] = getLumps(dimensionedJoinedOutline);
		for (int i=0; i<packOutlines.length(); i++) {
			PlaneProfile& thisPackOutline = packOutlines[i];
			GenBeam genbeamsInPack[] = getGenbeamsFromPackOutline(thisPackOutline, inGenbeamsToDimension);
			if (hatchPattern != "None") {
				PlaneProfile outlineToDraw(thisPackOutline);
				outlineToDraw.transformBy(modelToPaperTransformation);
				Display dpHatch(hatchColour);
				dpHatch.draw(outlineToDraw);
				if (hatchPattern == "SOLID") {
					dpHatch.draw(outlineToDraw, _kDrawFilled, hatchTransparency);
				}
				else {
					Hatch thisHatch(hatchPattern, hatchScale);
					thisHatch.setAngle(hatchAngle);			
					dpHatch.draw(outlineToDraw, thisHatch);
				}
			}
			Point3d potentialPointsToDimension[0];
			if (genbeamSide == "Closest edge of genbeam" || genbeamSide == "Furthest edge of genbeam") {
				Point3d edgePointsClosest[0], edgePointsFurthest[0];
				getEdgePointsInDirectionAway(thisPackOutline, genbeamsInPack, inDirectionAwayFromDimensionLine, edgePointsClosest, edgePointsFurthest);				
				if (genbeamSide == "Closest edge of genbeam") {
					potentialPointsToDimension = edgePointsClosest;
				}
				else {
					potentialPointsToDimension = edgePointsFurthest;
				}
			}
			else {
				potentialPointsToDimension = thisPackOutline.getGripVertexPoints();
			}
			if (potentialPointsToDimension.length()<2) {
				reportMessage("\n" + scriptName() + " " + _kExecuteKey + " issue finding dimensioned pack points at "+ genbeamSide);	
			}
			else { 
				Point3d potentialPointsToDimensionOrdered[] = Line(thisElement.ptOrg(), inDimensionDirection).orderPoints(potentialPointsToDimension);
				if (pointsToDimension == "Start point" || pointsToDimension == "Start and end points") {
					outPointsToDimension.append(potentialPointsToDimensionOrdered.first());
				}
				if (pointsToDimension == "End point" || pointsToDimension == "Start and end points") {
					outPointsToDimension.append(potentialPointsToDimensionOrdered.last());
				}
				if (pointsToDimension == "Middle point") {
					Point3d thisOutlineMidPoints[] = thisPackOutline.getGripEdgeMidPoints();
					Point3d thisOutlineMidPointsOrdered[] = Line(thisPackOutline.ptMid(), inDirectionAwayFromDimensionLine).orderPoints(thisOutlineMidPoints);
					outPointsToDimension.append(thisOutlineMidPointsOrdered.first());
				}
			}			
		}		
	}
	else {
		for (int i=0; i<inGenbeamsToDimension.length(); i++) {		
			GenBeam& thisGenbeam = inGenbeamsToDimension[i];
			PlaneProfile thisGenbeamOutline = dimensionedOutlines[i];
			if (hatchPattern != "None") {
				PlaneProfile outlineToDraw(thisGenbeamOutline);
				outlineToDraw.transformBy(modelToPaperTransformation);
				Display dpHatch(hatchColour);
				dpHatch.draw(outlineToDraw);
				if (hatchPattern == "SOLID") {
					dpHatch.draw(outlineToDraw, _kDrawFilled, hatchTransparency);
				}
				else {
					Hatch thisHatch(hatchPattern, hatchScale);
					thisHatch.setAngle(hatchAngle);			
					dpHatch.draw(outlineToDraw, thisHatch);
				}
			}
	
			Point3d thisOutlineVertexPoints[] = thisGenbeamOutline.getGripVertexPoints();
			thisOutlineVertexPoints.append(thisOutlineVertexPoints.first());
			if (genbeamSide == "Closest edge of genbeam" || genbeamSide == "Furthest edge of genbeam") {
				Point3d potentialPointsToDimension[0];
				Point3d edgePointsClosest[0], edgePointsFurthest[0];
				GenBeam genbeamsEdge[] = { thisGenbeam};
				getEdgePointsInDirectionAway(thisGenbeamOutline, genbeamsEdge, inDirectionAwayFromDimensionLine, edgePointsClosest, edgePointsFurthest);
				if (genbeamSide == "Closest edge of genbeam") {
					potentialPointsToDimension = edgePointsClosest;
				}
				else {
					potentialPointsToDimension = edgePointsFurthest;
				}
				if (potentialPointsToDimension.length()<2) {
					reportMessage("\n" + scriptName() + " " + _kExecuteKey + " issue finding dimension points at "+ genbeamSide+ " for "+thisGenbeam);	
					continue;
				}
				Point3d pointsEdgeOrdered[] = Line(thisGenbeam.ptCen(), inDimensionDirection).orderPoints(potentialPointsToDimension);
				if (pointsToDimension == "All points") {
					outPointsToDimension.append(pointsEdgeOrdered);
					continue;
				}
				if (pointsToDimension == "Start point" || pointsToDimension == "Start and end points") {
					outPointsToDimension.append(pointsEdgeOrdered.first());
				}
				if (pointsToDimension == "End point" || pointsToDimension == "Start and end points") {
					outPointsToDimension.append(pointsEdgeOrdered.last());
				}
				if (pointsToDimension == "Middle point") {
					Point3d thisOutlineMidPoints[] = thisGenbeamOutline.getGripEdgeMidPoints();
					Point3d thisOutlineMidPointsOrdered[] = Line(thisGenbeam.ptCen(), inDirectionAwayFromDimensionLine).orderPoints(thisOutlineMidPoints);
					outPointsToDimension.append(thisOutlineMidPointsOrdered.first());
				}
			}
			else {			
				if (genbeamSide == "Half of genbeam") {
					for (int k=thisOutlineVertexPoints.length()-1; k>=0; k--) {
						Point3d& thisVertexPoint = thisOutlineVertexPoints[k];
						if ((thisGenbeam.ptCen() -thisVertexPoint).dotProduct(inDirectionAwayFromDimensionLine) < 0) {
							thisOutlineVertexPoints.removeAt(k);
						}
					}
				}
				if (pointsToDimension == "All points") {
					outPointsToDimension.append(thisOutlineVertexPoints);
					continue;
				}
				
				if (pointsToDimension == "All points") {
					outPointsToDimension.append(thisOutlineVertexPoints);
					continue;
				}
				if (thisOutlineVertexPoints.length()<2) {
					reportMessage("\n" + scriptName() + " " + _kExecuteKey + " issue finding dimension points at "+ genbeamSide+ " for "+thisGenbeam);	
					continue;
				}
				Point3d thisOutlineVertexPointsOrdered[] = Line(thisGenbeam.ptCen(), inDimensionDirection).orderPoints(thisOutlineVertexPoints);
				if (pointsToDimension == "Start point" || pointsToDimension == "Start and end points") {
					outPointsToDimension.append(thisOutlineVertexPointsOrdered.first());
				}
				if (pointsToDimension == "End point" || pointsToDimension == "Start and end points") {
					outPointsToDimension.append(thisOutlineVertexPointsOrdered.last());
				}
				if (pointsToDimension == "Middle point") {
					Point3d thisOutlineMidPoints[] = thisGenbeamOutline.getGripEdgeMidPoints();
					Point3d thisOutlineMidPointsOrdered[] = Line(thisGenbeam.ptCen(), inDirectionAwayFromDimensionLine).orderPoints(thisOutlineMidPoints);
					outPointsToDimension.append(thisOutlineMidPointsOrdered.first());
				}			
			}
		}		
	}

	return outPointsToDimension;
}

//function to get reference points given properties map
Point3d[] getPointsToReference(Map& inUserSelectedValuesMap, GenBeam& inGenbeamsToReference[], Vector3d& inDirectionAwayFromDimensionLine, Vector3d& inDimensionDirection)
{
	String genbeamSide = getSelectedID(inUserSelectedValuesMap, "Genbeams to reference", "Genbeam side");
	String referencePointsToUse = getSelectedID(inUserSelectedValuesMap, "Genbeams to reference", "Points to reference");
	String hatchPattern = getSelectedID(inUserSelectedValuesMap, "Dimension options", "Hatch pattern");
	double hatchScale = getDoubleSelectedValue(inUserSelectedValuesMap, "Dimension options", "Hatch scale");
	if (hatchScale == 0) hatchScale = 1;
	hatchScale *= viewportScale;
	double hatchAngle = getDoubleSelectedValue(inUserSelectedValuesMap, "Dimension options", "Hatch angle");
	int hatchColour = getIntSelectedValue(inUserSelectedValuesMap, "Dimension options", "Hatch colour");
	int hatchTransparency = getIntSelectedValue(inUserSelectedValuesMap, "Dimension options", "Hatch transparency");

	PlaneProfile referenceOutlines[] = getGenbeamOutlines(inGenbeamsToReference);
	PlaneProfile referenceJoinedOutline = getJoinedOutline(inUserSelectedValuesMap, referenceOutlines);
	if (hatchPattern != "None") {
		for (int i=0; i<referenceOutlines.length(); i++) {
			PlaneProfile outlineToDraw(referenceOutlines[i]);
			outlineToDraw.transformBy(modelToPaperTransformation);
			Display dpHatch(hatchColour);
			dpHatch.draw(outlineToDraw);
			if (hatchPattern == "SOLID") {
				dpHatch.draw(outlineToDraw, _kDrawFilled, hatchTransparency);
			}
			else {
				Hatch thisHatch(hatchPattern, hatchScale);
				thisHatch.setAngle(hatchAngle);			
				dpHatch.draw(outlineToDraw, thisHatch);
			}
		}
	}
	
	Point3d outPointsToReference[0], potentialPointsToReference[0];
	if (genbeamSide == "Closest edge of genbeam" || genbeamSide == "Furthest edge of genbeam") {
		Point3d edgePointsClosest[0], edgePointsFurthest[0];
		getEdgePointsInDirectionAway(referenceJoinedOutline, inGenbeamsToReference, inDirectionAwayFromDimensionLine, edgePointsClosest, edgePointsFurthest);
		if (genbeamSide == "Closest edge of genbeam") {
			potentialPointsToReference = edgePointsClosest;
		}
		else {
			potentialPointsToReference = edgePointsFurthest;
		}
	}
	else {
		potentialPointsToReference = referenceJoinedOutline.getGripVertexPoints();
	}
	if (potentialPointsToReference.length()<2) {
		reportMessage("\n" + scriptName() + " " + _kExecuteKey + " issue finding reference points at "+ genbeamSide);	
	}
	else { 
		Point3d potentialPointsToReferenceOrdered[] = Line(thisElement.ptOrg(), inDimensionDirection).orderPoints(potentialPointsToReference);
		if (referencePointsToUse == "Start point" || referencePointsToUse == "Start and end points") {
			outPointsToReference.append(potentialPointsToReferenceOrdered.first());
		}
		if (referencePointsToUse == "End point" || referencePointsToUse == "Start and end points") {
			outPointsToReference.append(potentialPointsToReferenceOrdered.last());
		}
	}
	return outPointsToReference;
}

//function to create dimension from dimension and reference points
Dim createDimensionFromPoints(Map& inUserSelectedValuesMap, Point3d& inDimensionPoints[], Point3d& inReferencePoints[], Vector3d& inDirectionAwayFromDimensionLine, Vector3d& inDimensionDirection) {

	String dimensionLinePosition = getSelectedID(inUserSelectedValuesMap, "Dimension styling", "Dimension line position");
	double dimensionLineOffset = getDoubleSelectedValue(inUserSelectedValuesMap, "Dimension styling", "Dimension line offset");
	Point3d pointDimensionLinePosition;
	if (dimensionLinePosition == "Static") {
		pointDimensionLinePosition = thisViewPort.ptCenPS();
		double distanceToViewportEdge;
		if (inDirectionAwayFromDimensionLine.isParallelTo(layoutXInModel)) {
			distanceToViewportEdge = thisViewPort.widthPS()/2;
		}
		else if (inDirectionAwayFromDimensionLine.isParallelTo(layoutYInModel)) {
			distanceToViewportEdge = thisViewPort.heightPS()/2;
		}
		Vector3d directionTowardsDimensionLinePaper = inDirectionAwayFromDimensionLine * -1;
		directionTowardsDimensionLinePaper.transformBy(modelToPaperTransformation);
		directionTowardsDimensionLinePaper.normalize();
		pointDimensionLinePosition += directionTowardsDimensionLinePaper * distanceToViewportEdge;
		pointDimensionLinePosition.transformBy(paperToModelTransformation);

	}
	else {
		int isValidPoint = false;
		Grip gripPointDimensionLinePosition = getGripPointDimensionLinePosition(_Grip, isValidPoint);
		if (isValidPoint) {
			pointDimensionLinePosition = gripPointDimensionLinePosition.ptLoc();
			pointDimensionLinePosition.transformBy(paperToModelTransformation);
		}
		else {
			int dimensionedZoneIndex = getLocalisedIntValue(inUserSelectedValuesMap, "Genbeams to dimension", "Zone", "Any");
			int referencedZoneIndex = getLocalisedIntValue(inUserSelectedValuesMap, "Genbeams to reference", "Zone", "Any");
			GenBeam genbeamsAll[] = thisElement.genBeam(dimensionedZoneIndex);
			if (dimensionedZoneIndex != referencedZoneIndex) {
				genbeamsAll.append(thisElement.genBeam(referencedZoneIndex));
			}
			PlaneProfile genbeamOutlines[] = getGenbeamOutlines(genbeamsAll);
			PlaneProfile outlineAll = getJoinedOutline(inUserSelectedValuesMap, genbeamOutlines);
			Point3d outlineVertexPoints[] = outlineAll.getGripVertexPoints();
			Point3d outlineVertexPointsOrdered[] = Line(thisElement.ptOrg(), inDirectionAwayFromDimensionLine).orderPoints(outlineVertexPoints);
			pointDimensionLinePosition = outlineVertexPointsOrdered.first();
			
			Point3d pointGripDimensionLinePosition = pointDimensionLinePosition;
			pointGripDimensionLinePosition.transformBy(modelToPaperTransformation);
			setGripPointDimensionLinePosition(_Grip, pointGripDimensionLinePosition, mapDimensionProperties, dimensionTypeName);
		}
	}	

	String dimensionType = getSelectedID(inUserSelectedValuesMap, "Dimension styling", "Dimension type");
	String textSide = getSelectedID(inUserSelectedValuesMap, "Dimension styling", "Text side");
	int textSideFlag = textSide == "Away from dimensioned points" ? 1 : -1;
	if (dimensionType == "Delta") {
		textSideFlag *= -1;
	}
	String textOrientation = getSelectedID(inUserSelectedValuesMap, "Dimension styling", "Text orientation");
	int textOrientationDisplayModus = textOrientation == "Parallel" ? _kDimPar : _kDimPerp;
	String projectPointsToDimensionLine = getSelectedID(inUserSelectedValuesMap, "Dimension styling", "Project points to dimension line");

	DimLine dimensionLine(pointDimensionLinePosition, inDimensionDirection, inDirectionAwayFromDimensionLine * textSideFlag);
	dimensionLine.setUseDisplayTextHeight(true);
	dimensionLine.transformBy(-inDirectionAwayFromDimensionLine*dimensionLineOffset*viewportScale);

	Dim outDimension;
	if (dimensionType == "Delta") {		
		Point3d pointsToDimensionAll[] = inDimensionPoints;
		pointsToDimensionAll.append(inReferencePoints);
		Point3d pointsToDimensionAllOrdered[] = Line(pointDimensionLinePosition, inDimensionDirection).orderPoints(pointsToDimensionAll);	
		if (projectPointsToDimensionLine == "Yes") {
			pointsToDimensionAllOrdered = Line(dimensionLine.ptOrg(), inDimensionDirection).projectPoints(pointsToDimensionAllOrdered);
		}
		outDimension = Dim(dimensionLine, pointsToDimensionAllOrdered,  "<>", "", textOrientationDisplayModus, _kDimNone);
	}
	else if (dimensionType == "Cummulative") {
		String referencePointsToUse = getSelectedID(inUserSelectedValuesMap, "Genbeams to reference", "Points to reference");
		Point3d pointsToDimensionAllOrdered[0];
		if ((inReferencePoints.length() > 0) && (referencePointsToUse == "Start point" || referencePointsToUse == "Start and end points")) {
			pointsToDimensionAllOrdered.append(inReferencePoints.first());
		}
		if (inDimensionPoints.length() > 0) {
			pointsToDimensionAllOrdered.append(Line(pointDimensionLinePosition, inDimensionDirection).orderPoints(inDimensionPoints));
		}		
		if ((inReferencePoints.length() > 0) && (referencePointsToUse == "End point" || referencePointsToUse == "Start and end points")) {
			pointsToDimensionAllOrdered.append(inReferencePoints.last());
		}
		if (projectPointsToDimensionLine == "Yes") {
			pointsToDimensionAllOrdered = Line(dimensionLine.ptOrg(), inDimensionDirection).projectPoints(pointsToDimensionAllOrdered);
		}
		outDimension = Dim(dimensionLine, pointsToDimensionAllOrdered,  "", "<>", _kDimNone, textOrientationDisplayModus);
		
	}
	outDimension.transformBy(modelToPaperTransformation);
	outDimension.correctTextNormalForViewDirection(_ZW);
	outDimension.setReadDirection(_YW - _XW);

	return outDimension;
} 

//function to create display given properties map
Display createDisplayFromPropertiesMap(Map& inUserSelectedValuesMap)
{
	Display outDisplay(-1);
	String dimensionStyle = getSelectedID(inUserSelectedValuesMap, "Dimension styling", "Dimension style");
	double dimensionTextHeight = getDoubleSelectedValue(inUserSelectedValuesMap, "Dimension styling", "Text height");
	outDisplay.dimStyle(dimensionStyle, viewportScale);
	if (dimensionTextHeight > mmToDrawingUnits(0.1))
		outDisplay.textHeight(dimensionTextHeight);
	return outDisplay;
}


//---------------
//--------------- <Genbeam functions> --- end
//endregion

Vector3d directionAwayFromDimensionLine = getDirectionAwayFromDimensionLineFromPropertiesMap(mapUserSelectedValues);
Vector3d dimensionDirection = getDimensionLineDirectionFromPropertiesMap(mapUserSelectedValues);
Entity dependants[] = _Map.getEntityArray("Dependants", "Dependants", "Dependants");
for (int i=0; i<dependants.length(); i++) {
	Entity& thisEntity = dependants[i];
	TslInst dependant = (TslInst)thisEntity;
	if (dependant.bIsValid()) {
		Map mapDependant = dependant.map();
		mapDependant.setEntity("Element", thisElement);
		mapDependant.setVector3d("DirectionFromTSL", dimensionDirection);
		mapDependant.setPoint3d("Viewport\\ptOrg", thisViewPort.coordSys().ptOrg());
		mapDependant.setVector3d("Viewport\\vX", thisViewPort.coordSys().vecX());
		mapDependant.setVector3d("Viewport\\vY", thisViewPort.coordSys().vecY());
		mapDependant.setVector3d("Viewport\\vZ", thisViewPort.coordSys().vecZ());
		mapDependant.setPoint3d("Viewport\\ptCenPS", thisViewPort.ptCenPS());
		mapDependant.setDouble("Viewport\\widthPS", thisViewPort.widthPS());
		mapDependant.setDouble("Viewport\\heightPS", thisViewPort.heightPS());
		dependant.setMap(mapDependant);
	}
}

String dimensionedEntities = getSelectedID(mapUserSelectedValues, "Dimension options", "Dimensioned entities");
GenBeam genbeamsToDimension[0];	Point3d pointsToDimension[0];
if (dimensionedEntities != "Referenced only") {
	genbeamsToDimension = getDimensionedGenbeamsFromPropertiesMap(mapUserSelectedValues, directionAwayFromDimensionLine);
	pointsToDimension = getPointsToDimension(mapUserSelectedValues, genbeamsToDimension, directionAwayFromDimensionLine, dimensionDirection);
}
GenBeam genbeamsToReference[0];	Point3d pointsToReference[0];
if (dimensionedEntities == "Reference to self") {
	genbeamsToReference = genbeamsToDimension;
	pointsToReference = getPointsToReference(mapUserSelectedValues, genbeamsToReference, directionAwayFromDimensionLine, dimensionDirection);
}
else if (dimensionedEntities != "Dimensioned only") {
	genbeamsToReference = getReferencedGenbeamsFromPropertiesMap(mapUserSelectedValues, directionAwayFromDimensionLine);
	pointsToReference = getPointsToReference(mapUserSelectedValues, genbeamsToReference, directionAwayFromDimensionLine, dimensionDirection);
}
if (genbeamsToDimension.length() == 0 && genbeamsToReference.length() == 0) {
    reportMessage("\n" + scriptName() + " No genbeams to dimension or reference");
    return;
}

Display thisDisplay = createDisplayFromPropertiesMap(mapUserSelectedValues);

//region On grip point moved
//--------------- <On grip point moved> --- start
//---------------

if (_bOnGripPointDrag && _kExecuteKey=="_Grip") {

	Grip gripCandidates[] = getGripPointsOfDimensionType(dimensionTypeName);
	int indexMoved = Grip().indexOfMovedGrip(gripCandidates);	
	if (_bOnDebug) reportMessage("\n" + scriptName() + " " + _kExecuteKey + " indexMoved = " + indexMoved);
	if (indexMoved < 0) return;
	Grip& gripMoved = gripCandidates[indexMoved];
	if (_bOnDebug) reportMessage("\n" + scriptName() + " " + _kExecuteKey + " gripMoved.name() = " + gripMoved.name());
	if (gripMoved.name() == dimensionTypeName+"~Dimension line position") {
		Dim dimensionToDraw = createDimensionFromPoints(mapUserSelectedValues, pointsToDimension, pointsToReference, directionAwayFromDimensionLine, dimensionDirection);
		thisDisplay.draw(dimensionToDraw); 
	}
	return;
}

if (_kNameLastChangedProp == "_Grip") {	
	Grip gripCandidates[] = getGripPointsOfDimensionType(dimensionTypeName);	
	recordGripsToDimensionPropertiesmap(mapDimensionProperties, gripCandidates);
	_Map.setMap(dimensionTypeName ,mapDimensionProperties);
}

//---------------
//--------------- <On grip point moved> --- end
//endregion

Dim dimensionToDraw = createDimensionFromPoints(mapUserSelectedValues, pointsToDimension, pointsToReference, directionAwayFromDimensionLine, dimensionDirection);
thisDisplay.draw(dimensionToDraw);

if (_bOnDebug) {
	Point3d viewportLeftBottom = thisViewPort.ptCenPS() -_XW*thisViewPort.widthPS()/2 -_YW*thisViewPort.heightPS()/2;
	Display	displayTemp(-1);
	displayTemp.textHeight(mmToDrawingUnits(4));
	displayTemp.draw(scriptName(), viewportLeftBottom, _XW, _YW, -1, -1);

}
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
      <str nm="COMMENT" vl="Corrected genbeamOutline function" />
      <int nm="MAJORVERSION" vl="0" />
      <int nm="MINORVERSION" vl="19" />
      <str nm="DATE" vl="10/17/2023 4:43:19 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Added suport of dependant TSLs like NA_DIM_GENBEAMS_DIAGONAL" />
      <int nm="MAJORVERSION" vl="0" />
      <int nm="MINORVERSION" vl="18" />
      <str nm="DATE" vl="10/16/2023 10:43:25 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Corrected closest edge point detection" />
      <int nm="MAJORVERSION" vl="0" />
      <int nm="MINORVERSION" vl="15" />
      <str nm="DATE" vl="9/26/2023 3:36:50 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Fixed bug with middle point" />
      <int nm="MAJORVERSION" vl="0" />
      <int nm="MINORVERSION" vl="14" />
      <str nm="DATE" vl="9/25/2023 3:49:52 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End