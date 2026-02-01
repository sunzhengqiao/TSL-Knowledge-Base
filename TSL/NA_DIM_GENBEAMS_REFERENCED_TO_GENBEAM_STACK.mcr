#Version 8
#BeginDescription
#Versions
V0.19 6/24/2024 Added ability to offset dimension line from element or viewport 
V0.18 10/17/2023 Corrected genbeamOutline function
V0.17 10/10/2023 fixed negative zones selection bug
V0.16 10/5/2023 Zone filter fix
V0.15 9/26/2023 Corrected closest edge point detection
V0.14 9/25/2023 Fixed middle point bug






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
String dimensionTypeName = "Genbeams referenced to genbeam stack";
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
	//set default language to en-US
	setPropertiesDefaultLanguage(mapOPMproperties, defaultLanguage);

	{
		Map mapCategory = createMap("Dimension options", "Dimension options", defaultLanguage);
		setMapName(mapCategory, "fr-CA", "Options de dimension");

		{
			Map mapPropString = createMap("Dimensioned entities", "Dimensioned entities", defaultLanguage);
			setMapName(mapPropString, "fr-CA", "Entités mesurées");
			String description_enUS = "If set to Dimensioned and stack will dimension beams/sheets referenced to stack"
									+ "\nIf set to Stack only will use only overall stack dimensions"
									+ "\nIf set to Dimensioned beams/sheets in stack will dimension beams/sheets that belong to stack"
									+ "\nIf set to Dimensioned beams/sheets in stack only will dimension beams/sheets that belong to stack without overall stack dimensions"
									+ "\nIf set to Dimensioned beams/sheets touching stack will dimension beams/sheets that touch stack";
			String description_frCA = "Si défini à Bois/revêtement mesurés et pile, mesurera les bois/revêtement référencés à la pile"
									+ "\nSi défini à Pile seulement, utilisera seulement les dimensions de la pile globale"
									+ "\nSi défini à Bois/revêtement mesurés dans la pile, mesurera les bois/revêtement qui appartiennent à la pile"
									+ "\nSi défini à Bois/revêtement mesurés dans la pile seulement, mesurera les bois/revêtement qui appartiennent à la pile sans les dimensions de la pile globale"
									+ "\nSi défini à Bois/revêtement mesurés touchant la pile, mesurera les bois/revêtement qui touchent la pile";
			setMapDescription(mapPropString, "en-US", description_enUS);
			setMapDescription(mapPropString, "fr-CA", description_frCA);

			{
				Map mapValues = createValuesMap("en-US");
				{
					addIDToValuesMap(mapValues, "Dimensioned genbeams and stack");
					addStringValueToValuesMap(mapValues, "en-US", "Dimensioned beams/sheets and stack");
					addStringValueToValuesMap(mapValues, "fr-CA", "Bois/revêtement mesurés et pile");
					addIDToValuesMap(mapValues, "Stack only");
					addStringValueToValuesMap(mapValues, "en-US", "Stack only");
					addStringValueToValuesMap(mapValues, "fr-CA", "Pile seulement");
					addIDToValuesMap(mapValues, "Dimensioned genbeams in stack");
					addStringValueToValuesMap(mapValues, "en-US", "Dimensioned beams/sheets in stack");
					addStringValueToValuesMap(mapValues, "fr-CA", "Bois/revêtement mesurés dans la pile");
					addIDToValuesMap(mapValues, "Dimensioned genbeams in stack only");
					addStringValueToValuesMap(mapValues, "en-US", "Dimensioned beams/sheets in stack only");
					addStringValueToValuesMap(mapValues, "fr-CA", "Bois/revêtement mesurés dans la pile seulement");
					addIDToValuesMap(mapValues, "Dimensioned genbeams touching stack");
					addStringValueToValuesMap(mapValues, "en-US", "Dimensioned beams/sheets touching stack");
					addStringValueToValuesMap(mapValues, "fr-CA", "Bois/revêtement mesurés touchant la pile");
				}//IDs, Values : en-US, fr-CA

				setDefaultID(mapPropString, "Dimensioned genbeams in stack");
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
				}//IDs, Values : en-US, fr-CA

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
				}//IDs, Values : en-US, fr-CA

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
				}//IDs, Values : en-US, fr-CA

				setDefaultID(mapPropString, "Start point");
				setValuesMapToProperty(mapPropString, mapValues);
			}//Values

			addPropStringToCategoryMap(mapCategory, mapPropString);
		}//Points to dimension

		{
			Map mapPropString = createMap("Genbeam side", "Beam/Sheet side", defaultLanguage);
			setMapName(mapPropString, "fr-CA", "Côté de bois/revêtement");
			String description_enUS = "If set to Closest/Furthest edge of genbeam will measure only the closest/furthest face of genbeam relative to dimension line";
			setMapDescription(mapPropString, "en-US", description_enUS);
			String description_frCA = "Si défini à Bord le plus proche/éloigné de bois/revêtement, mesurera seulement la face la plus proche/éloignée de bois/revêtement par rapport à la ligne de cote";
			setMapDescription(mapPropString, "fr-CA", description_frCA);

			{
				Map mapValues = createValuesMap("en-US");
				{
					addIDToValuesMap(mapValues, "Entire genbeam");
					addStringValueToValuesMap(mapValues, "en-US", "Entire beam/sheet");
					addStringValueToValuesMap(mapValues, "fr-CA", "Bois/revêtement entier");									
					addIDToValuesMap(mapValues, "Closest edge of genbeam");
					addStringValueToValuesMap(mapValues, "en-US", "Closest edge of beam/sheet");
					addStringValueToValuesMap(mapValues, "fr-CA", "Bord le plus proche de bois/revêtement");
					addIDToValuesMap(mapValues, "Furthest edge of genbeam");
					addStringValueToValuesMap(mapValues, "en-US", "Furthest edge of beam/sheet");
					addStringValueToValuesMap(mapValues, "fr-CA", "Bord le plus éloigné de bois/revêtement");
				}//IDs, Values : en-US, fr-CA

				setDefaultID(mapPropString, "Closest edge of genbeam");
				setValuesMapToProperty(mapPropString, mapValues);
			}//Values

			addPropStringToCategoryMap(mapCategory, mapPropString);
		}//Genbeam side

		addCategoryToPropertiesMap(mapOPMproperties, mapCategory);
	}//Genbeams to dimension

	{
		Map mapCategory = createMap("Stacked genbeams", "Stacked Beams/Sheets", defaultLanguage);
		setMapName(mapCategory, "fr-CA", "Bois/Revêtement empilé"); 
		{
			Map mapPropInt = createMap("Zone", "Element zone", defaultLanguage);
			setMapName(mapPropInt, "fr-CA", "Zone d’élément");
			String description_enUS = "Zone to which stacked beams/sheets belong to:";
			String description_frCA = "Zone à laquelle appartiennent les bois/revêtement empilés:";

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
			String description_enUS = "Painter definition of type GenBeam \nAddition filter applied to get a subset of stacked beams/sheets at selected zone "
									+ "\nIf set to None will not apply inclusion(this) filter";
			setMapDescription(mapPropString, "en-US", description_enUS);
			String description_frCA = "Définition de peintre de type GenBeam \nFiltre d’addition appliqué pour obtenir un sous-ensemble de bois/revêtement empilés à la zone sélectionnée "
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
				}//IDs, Values : en-US, fr-CA

				setDefaultID(mapPropString, "None");
				setValuesMapToProperty(mapPropString, mapValues);
			}//Values

			addPropStringToCategoryMap(mapCategory, mapPropString);
		}//Include filter

		{
			Map mapPropString = createMap("Exclude filter", "Exclude filter", defaultLanguage);
			setMapName(mapPropString, "fr-CA", "Filtre d’exclusion");
			String description_enUS = "Painter definition of type GenBeam"
									+ "\nSubtraction filter(painter definition) applied to get a subset of stacked beams/sheets at selected zone"
									+ "\nIf set to None will not apply exclusion(this) filter"
									+ "\nIf both filters are not None it will get beams/sheets which are at specified zone and sutisfy conditions of include(above) filter,"
									+ "\nthen it will remove beams/sheets which satisfy exclude(this) fiter";
			setMapDescription(mapPropString, "en-US", description_enUS);
			String description_frCA = "Définition de peintre de type GenBeam"
									+ "\nFiltre de soustraction (définition de peintre) appliqué pour obtenir un sous-ensemble de bois/revêtement empilés à la zone sélectionnée"
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
				}//IDs, Values : en-US, fr-CA

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
					addIDToValuesMap(mapValues, "All points");
					addStringValueToValuesMap(mapValues, "en-US", "All points");
					addStringValueToValuesMap(mapValues, "fr-CA", "Tous les points");
				}//IDs, Values : en-US, fr-CA

				setDefaultID(mapPropString, "Start and end points");
				setValuesMapToProperty(mapPropString, mapValues);
			}//Values

			addPropStringToCategoryMap(mapCategory, mapPropString);
		}//Points to reference

		{
			Map mapPropString = createMap("Genbeam side", "Beam/Sheet side", defaultLanguage);
			setMapName(mapPropString, "fr-CA", "Côté de bois/revêtement");
			String description_enUS = "If set to Closest/Furthest edge of genbeam will measure only the closest/furthest face of genbeam relative to dimension line";
			setMapDescription(mapPropString, "en-US", description_enUS);
			String description_frCA = "Si défini à Bord le plus proche/éloigné de bois/revêtement, mesurera seulement la face la plus proche/éloignée de bois/revêtement par rapport à la ligne de cote";
			setMapDescription(mapPropString, "fr-CA", description_frCA);

			{
				Map mapValues = createValuesMap("en-US");
				{
					addIDToValuesMap(mapValues, "Entire genbeam");
					addStringValueToValuesMap(mapValues, "en-US", "Entire beam/sheet");
					addStringValueToValuesMap(mapValues, "fr-CA", "Bois/revêtement entier");									
					addIDToValuesMap(mapValues, "Closest edge of genbeam");
					addStringValueToValuesMap(mapValues, "en-US", "Closest edge of beam/sheet");
					addStringValueToValuesMap(mapValues, "fr-CA", "Bord le plus proche de bois/revêtement");
					addIDToValuesMap(mapValues, "Furthest edge of genbeam");
					addStringValueToValuesMap(mapValues, "en-US", "Furthest edge of beam/sheet");
					addStringValueToValuesMap(mapValues, "fr-CA", "Bord le plus éloigné de bois/revêtement");
				}//IDs, Values : en-US, fr-CA

				setDefaultID(mapPropString, "Closest edge of genbeam");
				setValuesMapToProperty(mapPropString, mapValues);
			}//Values

			addPropStringToCategoryMap(mapCategory, mapPropString);
		}//Genbeam side

		addCategoryToPropertiesMap(mapOPMproperties, mapCategory);
	}//Stacked genbeams

	{
		Map mapCategory = createMap("Dimension styling", "Dimension style and positioning", defaultLanguage);
		setMapName(mapCategory, "fr-CA", "Style et positionnement de cote");

		{
			Map mapPropString = createMap("Dimension orientation", "Dimension orientation", defaultLanguage);
			setMapName(mapPropString, "fr-CA", "Orientation de cote");
			String description_enUS = "Specifies where to place dimension line relative to stack of beams/sheets.\nTop of stack is towards top and left of viewport, bottom and right of stack is towards bottom of viewport";
			setMapDescription(mapPropString, "en-US", description_enUS);
			String description_frCA = "Spécifie où placer la ligne de cote par rapport à la pile de bois/revêtement.\nLe sommet de la pile est vers le haut et la gauche de la vue, le bas et la droite de la pile est vers le bas de la vue";
			setMapDescription(mapPropString, "fr-CA", description_frCA);

			{
				Map mapValues = createValuesMap("en-US");
				{
					addIDToValuesMap(mapValues, "Top of stack");
					addStringValueToValuesMap(mapValues, "en-US", "Top of stack");
					addStringValueToValuesMap(mapValues, "fr-CA", "Sommet de la pile");
					addIDToValuesMap(mapValues, "Bottom of stack");
					addStringValueToValuesMap(mapValues, "en-US", "Bottom of stack");
					addStringValueToValuesMap(mapValues, "fr-CA", "Bas de la pile");				
				}//IDs, Values : en-US, fr-CA
				setDefaultID(mapPropString, "Top of stack");
				setValuesMapToProperty(mapPropString, mapValues);
			}//Values

			addPropStringToCategoryMap(mapCategory, mapPropString);
		}//Dimension orientation

		{
			Map mapPropString = createMap("Dimension direction", "Dimension direction", defaultLanguage);
			setMapName(mapPropString, "fr-CA", "Direction de cote");
			String description_enUS = "If set to Reverse will reverse dimension line direction.\nNormal direction is left to right, bottom to top";
			setMapDescription(mapPropString, "en-US", description_enUS);
			String description_frCA = "Si défini à Inverser, inversera la direction de la ligne de cote.\nLa direction normale est de gauche à droite, du bas vers le haut";
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
				}//IDs, Values : en-US, fr-CA

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
				}//IDs, Values : en-US, fr-CA

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
				Map mapDefault = createDoubleDefaultValueMap("Default", 0.15625, defaultLanguage);//5/32"
				setDoubleDefaultValue(mapDefault, 4, "fr-CA");//4mm
				setDefaultValueMap(mapPropDouble, mapDefault);
			}//Default value

			addPropDoubleToCategoryMap(mapCategory, mapPropDouble);
		}//Dimension line offset

		{
			Map mapPropString = createMap("Offset type", "Offset type", defaultLanguage);
			setMapName(mapPropString, "fr-CA", "Type de décalage");
			String description_enUS = "If set to Beam Stack will offset dimension line from stack of beams/sheets."+
			+"\nIf set to Viewport will offset dimension line from viewport edge"
			+"\nIf set to Element will offset dimension line from framing edge in chosen direction";
			String description_frCA = "Si défini à Pile de bois/revêtement, décalera la ligne de cote de la pile de bois/revêtement."
			+"\nSi défini à Vue, décalera la ligne de cote du bord de la vue"
			+"\nSi défini à Élément, décalera la ligne de cote du bord de charpente dans la direction choisie";
			{
				Map mapValues = createValuesMap("en-US");
				{
					addIDToValuesMap(mapValues, "Beam Stack");
					addStringValueToValuesMap(mapValues, "en-US", "Beam Stack");
					addStringValueToValuesMap(mapValues, "fr-CA", "Pile de bois/revêtement");
					addIDToValuesMap(mapValues, "Viewport");
					addStringValueToValuesMap(mapValues, "en-US", "Viewport");
					addStringValueToValuesMap(mapValues, "fr-CA", "Vue");
					addIDToValuesMap(mapValues, "Element");
					addStringValueToValuesMap(mapValues, "en-US", "Element");
					addStringValueToValuesMap(mapValues, "fr-CA", "Élément");
				}//IDs, Values : en-US, fr-CA

				setDefaultID(mapPropString, "Beam Stack");
				setValuesMapToProperty(mapPropString, mapValues);
			}//Values

			addPropStringToCategoryMap(mapCategory, mapPropString);
		}//Offset type

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
				}//IDs, Values : en-US, fr-CA

				setDefaultID(mapPropString, "No");
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
				}//IDs, Values:Any

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
				}//IDs, Values:en-US

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
				}//IDs, Values:en-US

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
Grip[] getGripPointsFromMap(Map& inMap) {
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
Map createMapFromGripPoints(Grip& inGripPoints[]) {
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
void recordGripsToDimensionPropertiesmap(Map& inDimensionPropertiesMap, Grip& inGrips[]) {
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

//function to get genbeams in stack to which given grip point belongs to and list of grip points
GenBeam[] getGenbeamsInStackFromGrip(Grip& inGrip)
{
	GenBeam outGenbeamsInStack[0];
	String handlesFromGrip = inGrip.name().token(1, "~");
	String handles[] = handlesFromGrip.tokenize(",");
	for (int i=0; i<handles.length(); i++) {
		Entity thisEntity;
		thisEntity.setFromHandle(handles[i]);
		GenBeam thisGenbeam = (GenBeam) thisEntity;
		if (thisGenbeam.bIsValid()) {
			outGenbeamsInStack.append(thisGenbeam);
		}
	}

	return outGenbeamsInStack;
}

//function to get grip point which belongs to given genbeams stack
Grip getGripFromGenbeamsInStack(Grip& inGrips[], GenBeam& inGenbeamsInStack[], int& outIsValidPoint)
{
	Grip outGrip;
	outIsValidPoint = false;
	for (int i=0; i<inGrips.length(); i++) {
		Grip& thisGrip = inGrips[i];
		GenBeam thisGripStack[] = getGenbeamsInStackFromGrip(thisGrip);
		for (int k=0; k<thisGripStack.length(); k++) {
			GenBeam& thisGenbeam = thisGripStack[k];
			int iFindGenbeam = inGenbeamsInStack.find(thisGenbeam);
			if (iFindGenbeam >= 0) {
				outGrip = thisGrip;
				outIsValidPoint = true;
				break;
			}
		}
	}

	return outGrip;
}

//function to set grip point name from genbeams in stack
void setGripPointNameFromGenbeamsInStack(Grip& inGrip, GenBeam& inGenbeamsInStack[], String& inDimensionTypeName)
{
	String gripName = inDimensionTypeName + "~";
	for (int i=0; i<inGenbeamsInStack.length(); i++) {
		GenBeam& thisGenbeam = inGenbeamsInStack[i];
		gripName += thisGenbeam.handle();
		if (i < inGenbeamsInStack.length()-1) {
			gripName += ",";
		}
	}
	inGrip.setName(gripName);
}  

//---------------
//--------------- <Functions to control grip points> --- end
//endregion

//region Genbeam functions
//--------------- <Genbeam functions> --- start
//---------------

//function to get dimension line direction and direction away from dimension line given genbeam in a stack
void getStackDimensionVectors(Map& inUserSelectedValuesMap, Beam& inGenbeamsInStack, Vector3d& outDimensionDirection, Vector3d& outDirectionAwayFromDiemensionLine)
{	
	outDimensionDirection = inGenbeamsInStack.vecX();
	if (outDimensionDirection.dotProduct(layoutXInModel+layoutYInModel) < 0) {
		outDimensionDirection = -outDimensionDirection;
	}	
	outDirectionAwayFromDiemensionLine = outDimensionDirection.crossProduct(layoutZInModel);
	String dimensionOrientation = getSelectedID(inUserSelectedValuesMap, "Dimension styling", "Dimension orientation");
	outDirectionAwayFromDiemensionLine *= dimensionOrientation == "Top of stack" ? 1 : -1;
	String dimensionDirection = getSelectedID(inUserSelectedValuesMap, "Dimension styling", "Dimension direction");
	if (dimensionDirection == "Reverse") {
		outDimensionDirection *= -1;
	}
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

//function to get dimensioned genbeams given properties map
GenBeam[] getDimensionedGenbeamsFromPropertiesMap(Map& inUserSelectedValuesMap)
{
	GenBeam outGenbeams[0];
	int selectedZoneIndex = getLocalisedIntValue(inUserSelectedValuesMap, "Genbeams to dimension", "Zone", "Any");
	String includeFilter = getSelectedID(inUserSelectedValuesMap, "Genbeams to dimension", "Include filter");
	String excludeFilter = getSelectedID(inUserSelectedValuesMap, "Genbeams to dimension", "Exclude filter");
	outGenbeams.append(getGenbeamsFiltered(selectedZoneIndex, includeFilter, excludeFilter));

	return outGenbeams;
}

//function to get stacked genbeams given properties map
GenBeam[] getStackedGenbeamsFromPropertiesMap(Map& inUserSelectedValuesMap)
{
	GenBeam outGenbeams[0];
	int selectedZoneIndex = getLocalisedIntValue(inUserSelectedValuesMap, "Stacked genbeams", "Zone", "Any");
	String includeFilter = getSelectedID(inUserSelectedValuesMap, "Stacked genbeams", "Include filter");
	String excludeFilter = getSelectedID(inUserSelectedValuesMap, "Stacked genbeams", "Exclude filter");
	outGenbeams.append(getGenbeamsFiltered(selectedZoneIndex, includeFilter, excludeFilter));

	return outGenbeams;
}

//function to filter genbeams which are touching given stack of genbeams
GenBeam[] genbeamsTouchingOther(GenBeam& inGenbeamsToFilter[], GenBeam& inGenbeamsToTestAgainst[])
{	
	Vector3d moveVectors[0];
	Body stackBody;
	for (int i=0; i<inGenbeamsToTestAgainst.length(); i++) {
		GenBeam& thisGenbeam = inGenbeamsToTestAgainst[i];
		if (i==0) {
			stackBody = thisGenbeam.realBody();
			moveVectors.append(thisGenbeam.vecX()*mmToDrawingUnits(1));
			moveVectors.append(-thisGenbeam.vecX()*mmToDrawingUnits(1));
			moveVectors.append(thisGenbeam.vecY()*mmToDrawingUnits(1));
			moveVectors.append(-thisGenbeam.vecY()*mmToDrawingUnits(1));
			moveVectors.append(thisGenbeam.vecZ()*mmToDrawingUnits(1));
			moveVectors.append(-thisGenbeam.vecZ()*mmToDrawingUnits(1));
		} 
		else stackBody.addPart(thisGenbeam.realBody());
	}
	Body grownStackBody = stackBody;
	for (int i=0; i<moveVectors.length(); i++) {
		Vector3d& thisMoveVector = moveVectors[i];
		Body movedStackBody = stackBody;
		movedStackBody.transformBy(thisMoveVector);
		grownStackBody.addPart(movedStackBody);
	}
	GenBeam outGenbeamsTouching[] = grownStackBody.filterGenBeamsIntersect(inGenbeamsToFilter);	

	return outGenbeamsTouching;
}

	//region Functions to get genbeam stack
	//--------------- <Functions to get genbeam stack> --- start
	//---------------

	//function to get genbeams which are parallel to given genbeam
	GenBeam[] getGenbeamsParallel(GenBeam& inGenbeam, GenBeam& inGenbeamsToFilter[])
	{
		GenBeam outGenbeamsParallel[0];
		for (int p=0; p<inGenbeamsToFilter.length(); p++) {
			GenBeam& otherGenbeam = inGenbeamsToFilter[p];
			if (!otherGenbeam.vecX().isParallelTo(inGenbeam.vecX())) continue;
			outGenbeamsParallel.append(otherGenbeam);
		}
		
		return outGenbeamsParallel;
	}

	//function to get genbeam outline cut by given analysed cut 
	PlaneProfile getAnalysedCutProfile(AnalysedCut& inAnalysedCut)
	{
		PLine cutOutline(inAnalysedCut.normal());
		Point3d cutPoints[] = inAnalysedCut.bodyPointsInPlane();
		for (int k=0; k<cutPoints.length(); k++) {
			Point3d& thisPoint = cutPoints[k];
			cutOutline.addVertex(thisPoint);
		}
		cutOutline.close();
		
		return PlaneProfile(cutOutline);
	}

	//function to check if given genbeam has end to end connection with other genbeam
	int hasEndToEndConnection(GenBeam& inThisGenbeam, GenBeam& inOtherGenbeam)
	{
		int outHasEndToEndConnection = false;
		AnalysedTool thisAtools[] = inThisGenbeam.analysedTools();
		AnalysedCut thisAcuts[] = AnalysedCut().filterToolsOfToolType(thisAtools);
		int thisIndexClosest = AnalysedCut().findClosest(thisAcuts, inOtherGenbeam.ptCen());
		AnalysedTool otherAtools[] = inOtherGenbeam.analysedTools();
		AnalysedCut otherAcuts[] = AnalysedCut().filterToolsOfToolType(otherAtools);
		int otherIndexClosest = AnalysedCut().findClosest(otherAcuts, inThisGenbeam.ptCen());
		if (thisIndexClosest >= 0 && otherIndexClosest >= 0) {
			AnalysedCut thisAcut = thisAcuts[thisIndexClosest];
			AnalysedCut otherAcut = otherAcuts[otherIndexClosest];
			double distanceCutToCut = abs((thisAcut.ptOrg() - otherAcut.ptOrg()).dotProduct(thisAcut.normal()));
			int bisParallel = thisAcut.normal().isParallelTo(otherAcut.normal());
			int bisCodirectional = thisAcut.normal().isCodirectionalTo(otherAcut.normal());
			if (distanceCutToCut < mmToDrawingUnits(1) && bisParallel && !bisCodirectional) {
				PlaneProfile thisCutProfile = getAnalysedCutProfile(thisAcut);
				PlaneProfile otherCutProfile = getAnalysedCutProfile(otherAcut);
				thisCutProfile.intersectWith(otherCutProfile);
				if (thisCutProfile.area() > mmToDrawingUnits(1)^2) {
					outHasEndToEndConnection = true;
				}
			}
		}
		
		return outHasEndToEndConnection;
	}

	//recursive function to get genbeams which have end to end connection with given genbeam
	void getEndToEndGenbeams(GenBeam& inGenbeam, GenBeam& inGenbeamsToFilter[], GenBeam& outGenbeamsInRow[])
	{
		for (int q=0; q<inGenbeamsToFilter.length(); q++) {
			GenBeam& otherGenbeam = inGenbeamsToFilter[q];
			if (outGenbeamsInRow.find(otherGenbeam) >= 0) continue;
			int bhasConnection = hasEndToEndConnection(inGenbeam, otherGenbeam);
			if (bhasConnection) {
				outGenbeamsInRow.append(otherGenbeam);
				getEndToEndGenbeams(otherGenbeam, inGenbeamsToFilter, outGenbeamsInRow);
			}
		}
	}

	//function to get genbeams wich can have end to end connection with given genbeam
	GenBeam[] getGenbeamsEndToEndCandidates(GenBeam& inGenbeam, GenBeam& inGenbeamsToFilter)
	{
		GenBeam outGenbeamCandidates[0];
		Vector3d vY = inGenbeam.vecY();
		Vector3d vZ = inGenbeam.vecZ();
		Point3d pC = inGenbeam.ptCen();
		Point3d thisPointsY[] = Line(pC, vY).orderPoints(inGenbeam.envelopeBody().extremeVertices(vY));
		Point3d thisPointsZ[] = Line(pC, vY).orderPoints(inGenbeam.envelopeBody().extremeVertices(vZ));
		for (int k=0; k<inGenbeamsToFilter.length(); k++) {
			GenBeam& otherGenbeam = inGenbeamsToFilter[k];
			Point3d otherPointsY[] = Line(pC, vY).orderPoints(otherGenbeam.envelopeBody().extremeVertices(vY));
			Point3d otherPointsZ[] = Line(pC, vY).orderPoints(otherGenbeam.envelopeBody().extremeVertices(vZ));
			Point3d biggerPointsY[0], smallerPointsY[0], biggerPointsZ[0], smallerPointsZ[0];
			if (inGenbeam.dW() >= otherGenbeam.dD(vY)) {
				biggerPointsY = thisPointsY;
				smallerPointsY = otherPointsY;
			}
			else {
				biggerPointsY = otherPointsY;
				smallerPointsY = thisPointsY;
			}
			double distancesY[] =
			{
				(biggerPointsY.first()-smallerPointsY.first()).dotProduct(-vY),
				(biggerPointsY.last()-smallerPointsY.last()).dotProduct(vY)
			};
			if (distancesY.first() < -mmToDrawingUnits(1) || distancesY.last() < -mmToDrawingUnits(1)) continue;
			if (inGenbeam.dH() >= otherGenbeam.dD(vZ)) {
				biggerPointsZ = thisPointsZ;
				smallerPointsZ = otherPointsZ;
			}
			else {
				biggerPointsZ = otherPointsZ;
				smallerPointsZ = thisPointsZ;
			}
			double distancesZ[] =
			{
				(biggerPointsZ.first()-smallerPointsZ.first()).dotProduct(-vZ),
				(biggerPointsZ.last()-smallerPointsZ.last()).dotProduct(vZ)
			};
			if (distancesZ.first() < -mmToDrawingUnits(1) || distancesZ.last() < -mmToDrawingUnits(1)) continue;
			outGenbeamCandidates.append(otherGenbeam);
		}
		
		return outGenbeamCandidates;
	}

	//function to get genbeams in same row as given genbeam
	GenBeam[] getGenbeamsInRow(GenBeam& inGenbeam, GenBeam& inGenbeamsToFilter[])
	{
		GenBeam outGenbeamsInRow[] = { inGenbeam};
		GenBeam genbeamCandidates[] = getGenbeamsEndToEndCandidates(inGenbeam, inGenbeamsToFilter);
		getEndToEndGenbeams(inGenbeam, genbeamCandidates, outGenbeamsInRow);
		
		return outGenbeamsInRow;
	}

	//function to check if given genbeam is next to given genbeam row
	int isNextToGenbeamRow(GenBeam& inGenbeamsInRow[], GenBeam& inGenbeamsToFilter)
	{
		Body thisRowBody;
		for (int k=0; k<inGenbeamsInRow.length(); k++) {
			GenBeam& thisGenbeam = inGenbeamsInRow[k];
			if (k == 0) thisRowBody = thisGenbeam.realBody();
			else thisRowBody += thisGenbeam.realBody();
		}
		int outIsNextToGenbeamRow = false;
		Vector3d directionX = inGenbeamsToFilter.vecX();
		Vector3d directionToCheck = inGenbeamsToFilter.vecD(inGenbeamsToFilter.ptCen() -Line(thisRowBody.ptCen(), directionX).closestPointTo(inGenbeamsToFilter.ptCen()));
		if (directionToCheck.dotProduct(inGenbeamsToFilter.ptCen()-thisRowBody.ptCen()) < 0) {
			directionToCheck *= -1;
		}
		double distToRow = (inGenbeamsToFilter.ptCen() - thisRowBody.ptCen()).dotProduct(directionToCheck);
		double distBetweenFaces = distToRow - (thisRowBody.lengthInDirection(directionToCheck) + inGenbeamsToFilter.envelopeBody().lengthInDirection(directionToCheck)) * 0.5;
		if (abs(distBetweenFaces) < mmToDrawingUnits(1)) {
			thisRowBody.transformBy(directionToCheck * distToRow);
			int bOk = thisRowBody.intersectWith(inGenbeamsToFilter.realBody());
			if (bOk && thisRowBody.volume() > mmToDrawingUnits(1)*3) {
				outIsNextToGenbeamRow = true;
			}
		}
		
		return outIsNextToGenbeamRow;
	}

	//function to get subset of genbeams which is difference between two lists
	GenBeam[] getGenbeamsDiffSubset(GenBeam& inGenbeamsThis[], GenBeam& inGenbeamsOther[])
	{
		GenBeam outGenbeamsSubset[0];
		for (int q=0; q<inGenbeamsThis.length(); q++) {
			GenBeam& thisGenbeam = inGenbeamsThis[q];
			if (inGenbeamsOther.find(thisGenbeam) >= 0) continue;
			outGenbeamsSubset.append(thisGenbeam);
		}
		
		return outGenbeamsSubset;
	}

	//recursive function to get genbeams in same stack as given genbeam row
	void getGenbeamRows(GenBeam& inGenbeamRow[], GenBeam& inGenbeamsToFilter[], GenBeam& outGenbeamsInStack[])
	{
		for (int q=0; q<inGenbeamsToFilter.length(); q++) {
			GenBeam& otherGenbeam = inGenbeamsToFilter[q];
			if (outGenbeamsInStack.find(otherGenbeam) >= 0) continue;
			if (isNextToGenbeamRow(inGenbeamRow, otherGenbeam)) {
				GenBeam genbeamsNotInStack[] = getGenbeamsDiffSubset(inGenbeamsToFilter, outGenbeamsInStack);
				GenBeam otherGenbeamsInRow[] = getGenbeamsInRow(otherGenbeam, genbeamsNotInStack);
				outGenbeamsInStack.append(otherGenbeamsInRow);
				getGenbeamRows(otherGenbeamsInRow, inGenbeamsToFilter, outGenbeamsInStack);
			}
		}
	}

	//function to get genbeams in same stack as given genbeam
	GenBeam[] getGenbeamsInStack(GenBeam& inGenbeam, GenBeam& inGenbeamsToFilter[])
	{
		GenBeam genbeamsParallel[] = getGenbeamsParallel(inGenbeam, inGenbeamsToFilter);
		//get first row of genbeams in a stack
		GenBeam genbeamRow[] = getGenbeamsInRow(inGenbeam, genbeamsParallel);
		GenBeam outGenbeamsInStack[] = genbeamRow;
		//get all rows of genbeams in a stack
		getGenbeamRows(genbeamRow, genbeamsParallel, outGenbeamsInStack);
		
		return outGenbeamsInStack;
	}

	//---------------
	//--------------- <Functions to get genbeam stack> --- end
	//endregion


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

//function to get intersection edges with reference outline
LineSeg[] getIntersectingEdge(PlaneProfile& inGenbeamOutline, PlaneProfile& inReferenceOutline, Vector3d& inDirectionAwayFromDimensionLine) {
	LineSeg outIntersectingEdges[0];
	Point3d referenceOutlineVertexPoints[] = inReferenceOutline.getGripVertexPoints();
	referenceOutlineVertexPoints.append(referenceOutlineVertexPoints.first());
	LineSeg referenceEdgeCandidates[0]; Point3d referenceEdgeCandidatesMidPoints[0];
	for (int i=1; i<referenceOutlineVertexPoints.length(); i++) {
		Point3d& thisVertexPoint = referenceOutlineVertexPoints[i];
		Point3d& thisVertexPointPrevious = referenceOutlineVertexPoints[i-1];
		if (!inDirectionAwayFromDimensionLine.isPerpendicularTo(thisVertexPoint - thisVertexPointPrevious)) continue;
		LineSeg thisEdge(thisVertexPointPrevious, thisVertexPoint);
		referenceEdgeCandidates.append(thisEdge);
		referenceEdgeCandidatesMidPoints.append(thisEdge.ptMid());
	}
	if (referenceEdgeCandidatesMidPoints.length()>0) {
		Point3d referenceEdgeCandidatesMidPointsOrdered[] = Line(inReferenceOutline.ptMid(), inDirectionAwayFromDimensionLine).orderPoints(referenceEdgeCandidatesMidPoints);
		LineSeg referenceEdgeClosest = referenceEdgeCandidates[referenceEdgeCandidatesMidPoints.find(referenceEdgeCandidatesMidPointsOrdered.first())];
		outIntersectingEdges = inGenbeamOutline.splitSegments(referenceEdgeClosest, true);
	}
	
	return outIntersectingEdges;
}

//function to get closest genbeam outline edge to interesction with refrence outline
LineSeg getClosestEdgeToIntersectionSegments(PlaneProfile& inGenbeamOutline, PlaneProfile& inReferenceOutline,LineSeg& inIntersectingEdges[], Vector3d& inDirectionAwayFromDimensionLine)
{
	LineSeg outClosestEdge;
	Point3d genbeamOutlineVertexPoints[] = inGenbeamOutline.getGripVertexPoints();
	genbeamOutlineVertexPoints.append(genbeamOutlineVertexPoints.first());
	double dist = mmToDrawingUnits(1000);
	for (int i=1; i<genbeamOutlineVertexPoints.length(); i++) {
		Point3d& thisVertexPoint = genbeamOutlineVertexPoints[i];
		Point3d& thisVertexPointPrevious = genbeamOutlineVertexPoints[i-1];
		LineSeg thisEdge(thisVertexPointPrevious, thisVertexPoint);
		PLine thisEdgePline(thisVertexPointPrevious, thisVertexPoint);
		int isOnSplit = false;
		for (int k=0; k<inIntersectingEdges.length(); k++) {
			LineSeg& thisSplitSegment = inIntersectingEdges[k];
			if (thisEdgePline.isOn(thisSplitSegment.ptStart()) || thisEdgePline.isOn(thisSplitSegment.ptEnd())) {
				isOnSplit = true;
				break;
			}
		}
		if (isOnSplit) continue;
		Point3d pointMidProjected = inReferenceOutline.closestPointTo(thisEdge.ptMid());
		double distToMid = abs((pointMidProjected - thisEdge.ptMid()).dotProduct(inDirectionAwayFromDimensionLine));
		if (distToMid < dist) {
			dist = distToMid;
			outClosestEdge = thisEdge;
		}
	}	

	return outClosestEdge;
}

//function to get dimension points given properties map
Point3d[] getPointsToDimension(Map& inUserSelectedValuesMap, GenBeam& inGenbeamsToDimension[], GenBeam& inGenbeamsToReference[], Vector3d& inDirectionAwayFromDimensionLine, Vector3d& inDimensionDirection)
{
	String dimensionedEntities = getSelectedID(inUserSelectedValuesMap, "Dimension options", "Dimensioned entities");
	String dimensionedGenbeamSide = getSelectedID(inUserSelectedValuesMap, "Genbeams to dimension", "Genbeam side");
	String typeOfPointsToDimension = getSelectedID(inUserSelectedValuesMap, "Genbeams to dimension", "Points to dimension");
	String hatchPattern = getSelectedID(inUserSelectedValuesMap, "Dimension options", "Hatch pattern");
	double hatchScale = getDoubleSelectedValue(inUserSelectedValuesMap, "Dimension options", "Hatch scale");
	if (hatchScale == 0) hatchScale = 1;
	hatchScale *= viewportScale;
	double hatchAngle = getDoubleSelectedValue(inUserSelectedValuesMap, "Dimension options", "Hatch angle");
	int hatchColour = getIntSelectedValue(inUserSelectedValuesMap, "Dimension options", "Hatch colour");
	int hatchTransparency = getIntSelectedValue(inUserSelectedValuesMap, "Dimension options", "Hatch transparency");


	PlaneProfile referenceOutlines[] = getGenbeamOutlines(inGenbeamsToReference);
	PlaneProfile referenceJoinedOutline = getJoinedOutline(inUserSelectedValuesMap, referenceOutlines);

	Point3d outPointsToDimension[0];
	for (int i=0; i<inGenbeamsToDimension.length(); i++) {		
		GenBeam& thisGenbeam = inGenbeamsToDimension[i];
		PlaneProfile thisGenbeamOutline = getGenbeamOutline(thisGenbeam, layoutZInModel);
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
		if (dimensionedGenbeamSide == "Closest edge of genbeam" || dimensionedGenbeamSide == "Furthest edge of genbeam") {
			Point3d potentialPointsToDimension[0];
			if (dimensionedEntities == "Dimensioned genbeams touching stack") {				
				
				if (PlaneProfile(referenceJoinedOutline).intersectWith(thisGenbeamOutline)) {
					LineSeg intersectingEdges[] = getIntersectingEdge(thisGenbeamOutline, referenceJoinedOutline, inDirectionAwayFromDimensionLine);
					if (intersectingEdges.length() > 0) {
						for (int k=0; k<intersectingEdges.length(); k++) {
							LineSeg& thisIntersectingEdge = intersectingEdges[k];
							potentialPointsToDimension.append(thisIntersectingEdge.ptStart());
							potentialPointsToDimension.append(thisIntersectingEdge.ptEnd());
						}	
					}
					else {
						PlaneProfile referenceJoinedOutlineCopy(referenceJoinedOutline);
						referenceJoinedOutlineCopy.shrink(mmToDrawingUnits(2));
						if (PlaneProfile(referenceJoinedOutlineCopy).intersectWith(thisGenbeamOutline)) {
							LineSeg intersectingEdges[] = getIntersectingEdge(thisGenbeamOutline, referenceJoinedOutlineCopy, inDirectionAwayFromDimensionLine);
							if (intersectingEdges.length() > 0) {
								LineSeg closestEdge = getClosestEdgeToIntersectionSegments(thisGenbeamOutline, referenceJoinedOutline, intersectingEdges, inDirectionAwayFromDimensionLine);
								potentialPointsToDimension.append(closestEdge.ptStart());
								potentialPointsToDimension.append(closestEdge.ptEnd());
							}
						}
					}
				}
				else {
					PlaneProfile referenceJoinedOutlineCopy(referenceJoinedOutline);
					referenceJoinedOutlineCopy.shrink(-1*mmToDrawingUnits(2));
					if (PlaneProfile(referenceJoinedOutlineCopy).intersectWith(thisGenbeamOutline)) {
						LineSeg intersectingEdges[] = getIntersectingEdge(thisGenbeamOutline, referenceJoinedOutlineCopy, inDirectionAwayFromDimensionLine);
						if (intersectingEdges.length() > 0) {
							LineSeg closestEdge = getClosestEdgeToIntersectionSegments(thisGenbeamOutline, referenceJoinedOutline, intersectingEdges, inDirectionAwayFromDimensionLine);
							potentialPointsToDimension.append(closestEdge.ptStart());
							potentialPointsToDimension.append(closestEdge.ptEnd());
						}						
					}
				}				
			}
			
			if (potentialPointsToDimension.length() < 2) {
				Point3d edgePointsClosest[0], edgePointsFurthest[0];
				GenBeam genbeamsEdge[] = { thisGenbeam};
				getEdgePointsInDirectionAway(thisGenbeamOutline, genbeamsEdge, inDirectionAwayFromDimensionLine, edgePointsClosest, edgePointsFurthest);
				if (dimensionedGenbeamSide == "Closest edge of genbeam") {
					potentialPointsToDimension = edgePointsClosest;
				}
				else {
					potentialPointsToDimension = edgePointsFurthest;
				}
			}
			Point3d pointsEdgeOrdered[] = Line(thisGenbeam.ptCen(), inDimensionDirection).orderPoints(potentialPointsToDimension);
			if (typeOfPointsToDimension == "All points") {
				outPointsToDimension.append(pointsEdgeOrdered);
				continue;
			}
			if (typeOfPointsToDimension == "Start point" || typeOfPointsToDimension == "Start and end points") {
				outPointsToDimension.append(pointsEdgeOrdered.first());
			}
			if (typeOfPointsToDimension == "End point" || typeOfPointsToDimension == "Start and end points") {
				outPointsToDimension.append(pointsEdgeOrdered.last());
			}
			if (typeOfPointsToDimension == "Middle point") {
				Point3d thisOutlineMidPoints[] = thisGenbeamOutline.getGripEdgeMidPoints();
				Point3d thisOutlineMidPointsOrdered[] = Line(thisGenbeam.ptCen(), inDirectionAwayFromDimensionLine).orderPoints(thisOutlineMidPoints);
				outPointsToDimension.append(thisOutlineMidPointsOrdered.first());
			}
		}
		else {			
			if (dimensionedGenbeamSide == "Half of genbeam") {
				for (int k=thisOutlineVertexPoints.length()-1; k>=0; k--) {
					Point3d& thisVertexPoint = thisOutlineVertexPoints[k];
					if ((thisGenbeam.ptCen() -thisVertexPoint).dotProduct(inDirectionAwayFromDimensionLine) < 0) {
						thisOutlineVertexPoints.removeAt(k);
					}
				}
			}
			if (typeOfPointsToDimension == "All points") {
				outPointsToDimension.append(thisOutlineVertexPoints);
				continue;
			}			
	
			Point3d thisOutlineVertexPointsOrdered[] = Line(thisGenbeam.ptCen(), inDimensionDirection).orderPoints(thisOutlineVertexPoints);
			if (typeOfPointsToDimension == "Start point" || typeOfPointsToDimension == "Start and end points") {
				outPointsToDimension.append(thisOutlineVertexPointsOrdered.first());
			}
			if (typeOfPointsToDimension == "End point" || typeOfPointsToDimension == "Start and end points") {
				outPointsToDimension.append(thisOutlineVertexPointsOrdered.last());
			}
			if (typeOfPointsToDimension == "Middle point") {
				Point3d thisOutlineMidPoints[] = thisGenbeamOutline.getGripEdgeMidPoints();
				Point3d thisOutlineMidPointsOrdered[] = Line(thisGenbeam.ptCen(), inDirectionAwayFromDimensionLine).orderPoints(thisOutlineMidPoints);
				outPointsToDimension.append(thisOutlineMidPointsOrdered.first());
			}			
		}
	}

	return outPointsToDimension;
}

//function to get reference points given properties map
Point3d[] getPointsToReference(Map& inUserSelectedValuesMap, GenBeam& inGenbeamsToReference[], Vector3d& inDirectionAwayFromDimensionLine, Vector3d& inDimensionDirection)
{
	String referencedGenbeamSide = getSelectedID(inUserSelectedValuesMap, "Stacked genbeams", "Genbeam side");
	String typeOfPointsToReference = getSelectedID(inUserSelectedValuesMap, "Stacked genbeams", "Points to reference");
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
	if (referencedGenbeamSide == "Closest edge of genbeam" || referencedGenbeamSide == "Furthest edge of genbeam") {
		Point3d edgePointsClosest[0], edgePointsFurthest[0];
		getEdgePointsInDirectionAway(referenceJoinedOutline, inGenbeamsToReference, inDirectionAwayFromDimensionLine, edgePointsClosest, edgePointsFurthest);
		if (referencedGenbeamSide == "Closest edge of genbeam") {
			potentialPointsToReference = edgePointsClosest;
		}
		else {
			potentialPointsToReference = edgePointsFurthest;
		}
	}
	else {
		potentialPointsToReference = referenceJoinedOutline.getGripVertexPoints();
	}
	
	Point3d potentialPointsToReferenceOrdered[] = Line(thisElement.ptOrg(), inDimensionDirection).orderPoints(potentialPointsToReference);
	if (typeOfPointsToReference == "All points") {
		outPointsToReference.append(potentialPointsToReferenceOrdered);		
	}	
	if (typeOfPointsToReference == "Start point" || typeOfPointsToReference == "Start and end points") {
		outPointsToReference.append(potentialPointsToReferenceOrdered.first());
	}
	if (typeOfPointsToReference == "End point" || typeOfPointsToReference == "Start and end points") {
		outPointsToReference.append(potentialPointsToReferenceOrdered.last());
	}

	return outPointsToReference;
}

//function to get create dimension for given genbeam stack
Dim createDimensionFromGenbeamStack(Map& inUserSelectedValuesMap, GenBeam& inGenbeamsToDimension[], GenBeam& inStackedGenbeams[], Point3d& inPointDimensionLinePosition,Vector3d& inDirectionAwayFromDimensionLine, Vector3d& inDimensionDirection)
{	
	String dimensionedEntities = getSelectedID(inUserSelectedValuesMap, "Dimension options", "Dimensioned entities");

	Point3d pointsToDimension[0];
	if (dimensionedEntities == "Dimensioned genbeams in stack") {
		pointsToDimension = getPointsToDimension(inUserSelectedValuesMap, inStackedGenbeams, inStackedGenbeams, inDirectionAwayFromDimensionLine, inDimensionDirection);
	}	
	else if (dimensionedEntities != "Stack only") {
		pointsToDimension = getPointsToDimension(inUserSelectedValuesMap, inGenbeamsToDimension, inStackedGenbeams, inDirectionAwayFromDimensionLine, inDimensionDirection);
	}
	Point3d pointsToReference[0];
	if (dimensionedEntities != "Dimensioned genbeams in stack only") {
		pointsToReference = getPointsToReference(inUserSelectedValuesMap, inStackedGenbeams, inDirectionAwayFromDimensionLine, inDimensionDirection);
	} 
	
	String dimensionLinePosition = getSelectedID(inUserSelectedValuesMap, "Dimension styling", "Dimension line position");
	double dimensionLineOffset = getDoubleSelectedValue(inUserSelectedValuesMap, "Dimension styling", "Dimension line offset");
	String offsetType = getSelectedID(inUserSelectedValuesMap, "Dimension styling", "Offset type");
	Point3d dimensionLinePoint(inPointDimensionLinePosition);
	if (offsetType == "Viewport") {
		PlaneProfile viewportOutline;
		viewportOutline.createRectangle(LineSeg(thisViewPort.ptCenPS() +thisViewPort.widthPS()*_XW*0.5 +thisViewPort.heightPS()*_YW*0.5,
												thisViewPort.ptCenPS() -thisViewPort.widthPS()*_XW*0.5 -thisViewPort.heightPS()*_YW*0.5),_XW,_YW);
		viewportOutline.transformBy(paperToModelTransformation);
		Point3d viewportPoints[] = viewportOutline.intersectPoints(Plane(inPointDimensionLinePosition, inDimensionDirection), /*includeNoneOpenings*/ true, /*includeOpenings*/ false);
		if (viewportPoints.length()>0) {
			viewportPoints = Line(inPointDimensionLinePosition, inDirectionAwayFromDimensionLine).orderPoints(viewportPoints);
			dimensionLinePoint = viewportPoints.first();
		}
	}
	else if (offsetType == "Element") {
		int zoneIndexToDimension = getLocalisedIntValue(inUserSelectedValuesMap, "Genbeams to dimension", "Zone", "Any");
		int zoneIndexToReference = getLocalisedIntValue(inUserSelectedValuesMap, "Genbeams to reference", "Zone", "Any");
		GenBeam genbeamsDisplayed[0];
		if (abs(zoneIndexToDimension)<=5) {
			genbeamsDisplayed.append(thisElement.genBeam(zoneIndexToDimension));
		}
		else {
			genbeamsDisplayed.append(thisElement.genBeam());
		}
		if (zoneIndexToDimension != zoneIndexToReference) {
			if (abs(zoneIndexToReference)<=5) {
				genbeamsDisplayed.append(thisElement.genBeam(zoneIndexToReference));
			}
			else {
				genbeamsDisplayed.append(thisElement.genBeam());
			}
		}
		PlaneProfile entityOutlines[0];
		for (int i=0; i<genbeamsDisplayed.length(); i++) {
			GenBeam& thisGenbeam = genbeamsDisplayed[i];
			PlaneProfile thisGenbeamOutline = getGenbeamOutline(thisGenbeam, layoutZInModel);
			entityOutlines.append(thisGenbeamOutline);
		}
		PlaneProfile entityJoinedOutline = getJoinedOutline(inUserSelectedValuesMap, entityOutlines);
		
		Point3d entityPoints[] = entityJoinedOutline.intersectPoints(Plane(inPointDimensionLinePosition, inDimensionDirection), /*includeNoneOpenings*/ true, /*includeOpenings*/ false);
		if (entityPoints.length()>0) {
			entityPoints = Line(inPointDimensionLinePosition, inDirectionAwayFromDimensionLine).orderPoints(entityPoints);
			dimensionLinePoint = entityPoints.first();
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

	DimLine dimensionLine(dimensionLinePoint, inDimensionDirection, inDirectionAwayFromDimensionLine * textSideFlag);
	dimensionLine.setUseDisplayTextHeight(true);
	dimensionLine.transformBy(-inDirectionAwayFromDimensionLine*dimensionLineOffset*viewportScale);

	Dim outDimension;
	if (dimensionType == "Delta") {		
		Point3d pointsToDimensionAll[] = pointsToDimension;
		pointsToDimensionAll.append(pointsToReference);
		Point3d pointsToDimensionAllOrdered[] = Line(inPointDimensionLinePosition, inDimensionDirection).orderPoints(pointsToDimensionAll);	
		if (projectPointsToDimensionLine == "Yes") {
			pointsToDimensionAllOrdered = Line(dimensionLine.ptOrg(), inDimensionDirection).projectPoints(pointsToDimensionAllOrdered);
		}
		outDimension = Dim(dimensionLine, pointsToDimensionAllOrdered,  "<>", "", textOrientationDisplayModus, _kDimNone);
	}
	else if (dimensionType == "Cummulative") {
		String typeOfPointsToReference = getSelectedID(inUserSelectedValuesMap, "Stacked genbeams", "Points to reference");
		Point3d pointsToDimensionAllOrdered[0];
		if ((pointsToReference.length() > 0) && (typeOfPointsToReference == "Start point" || typeOfPointsToReference == "Start and end points")) {
			pointsToDimensionAllOrdered.append(pointsToReference.first());
		}
        if (pointsToDimension.length() > 0) {
            pointsToDimensionAllOrdered.append(Line(inPointDimensionLinePosition, inDimensionDirection).orderPoints(pointsToDimension));
        }
		if ((pointsToReference.length()> 2) && (typeOfPointsToReference == "All points" )) {
			pointsToReference.removeAt(0);
			pointsToReference.removeAt(pointsToReference.length()-1);
			pointsToDimensionAllOrdered.append(Line(inPointDimensionLinePosition, inDimensionDirection).orderPoints(pointsToReference));
		}

		if ((pointsToReference.length() > 0) && (typeOfPointsToReference == "End point" || typeOfPointsToReference == "Start and end points")) {
			pointsToDimensionAllOrdered.append(pointsToReference.last());
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

String dimensionedEntities = getSelectedID(mapUserSelectedValues, "Dimension options", "Dimensioned entities");
GenBeam genbeamsToStack[] = getStackedGenbeamsFromPropertiesMap(mapUserSelectedValues);
GenBeam genbeamsToDimension[0];
if (dimensionedEntities != "Stack only") {
	genbeamsToDimension = getDimensionedGenbeamsFromPropertiesMap(mapUserSelectedValues);
}
if (genbeamsToStack.length() == 0 && genbeamsToDimension.length() == 0) {
    reportMessage("\n" + scriptName() + " No genbeams to dimension or reference");
    return;
}

GenBeam genbeamsInStacks[0];
String stackedIndexes[0];
for (int i=0; i<genbeamsToStack.length(); i++) {	
	GenBeam& thisGenbeam = genbeamsToStack[i];
	if (genbeamsInStacks.find(thisGenbeam) >= 0 ) continue;
	GenBeam genbeamsNotInUse[] = getGenbeamsDiffSubset(genbeamsToStack, genbeamsInStacks);	
	GenBeam genbeamsInStack[] = getGenbeamsInStack(thisGenbeam, genbeamsNotInUse);
	genbeamsInStacks.append(genbeamsInStack);
	String indexesInStack;
	for (int k=0; k<genbeamsInStack.length(); k++) {
		GenBeam& thisGenbeamInStack = genbeamsInStack[k];
		int indexInStack = genbeamsToStack.find(thisGenbeamInStack);
		indexesInStack += indexInStack;
		if (k < genbeamsInStack.length()-1) indexesInStack += ",";
	}
	stackedIndexes.append(indexesInStack);	
}

//filter stacks that overlap in this view
for (int i=stackedIndexes.length()-1; i>=0; i--) {
	String& thisStackedIndex = stackedIndexes[i];
	GenBeam genbeamsInStack[0];
	String stringIndexList[] = thisStackedIndex.tokenize(",");
	for (int i=0; i<stringIndexList.length(); i++) {
		int index = stringIndexList[i].atoi();
		genbeamsInStack.append(genbeamsToStack[index]);
	}
	PlaneProfile genbeamOutlines[] = getGenbeamOutlines(genbeamsInStack);
	PlaneProfile joinedOutline = getJoinedOutline(mapUserSelectedValues, genbeamOutlines);

	for (int k=i-1; k>=0; k--) {
		String& otherStackedIndex = stackedIndexes[k];
		GenBeam otherGenbeamsInStack[0];
		String stringIndexList[] = otherStackedIndex.tokenize(",");
		for (int i=0; i<stringIndexList.length(); i++) {
			int index = stringIndexList[i].atoi();
			otherGenbeamsInStack.append(genbeamsToStack[index]);
		}
		PlaneProfile otherGenbeamOutlines[] = getGenbeamOutlines(otherGenbeamsInStack);
		PlaneProfile joinedOutline = getJoinedOutline(mapUserSelectedValues, genbeamOutlines);
		PlaneProfile otherJoinedOutline = getJoinedOutline(mapUserSelectedValues, otherGenbeamOutlines);
		if (otherJoinedOutline.intersectWith(joinedOutline)) {
			if (otherJoinedOutline.area() < mmToDrawingUnits(1)^2) {
				stackedIndexes.removeAt(i);
				break;
			}
		}
	}
}

Display thisDisplay = createDisplayFromPropertiesMap(mapUserSelectedValues);

//region On grip point moved
//--------------- <On grip point moved> --- start
//---------------

addRecalcTrigger(_kGripPointDrag, "_Grip");

if (_bOnGripPointDrag && _kExecuteKey=="_Grip") {

	Grip gripCandidates[] = getGripPointsOfDimensionType(dimensionTypeName);
	int indexMoved = Grip().indexOfMovedGrip(gripCandidates);	
	if (indexMoved < 0) return;
	Grip& gripMoved = gripCandidates[indexMoved];
	GenBeam genbeamsFromGrip[] = getGenbeamsInStackFromGrip(gripMoved);
	for (int i=0; i<stackedIndexes.length(); i++) {
		String& thisStackedIndex = stackedIndexes[i];
		GenBeam genbeamsInStack[0];
		String stringIndexList[] = thisStackedIndex.tokenize(",");
		for (int i=0; i<stringIndexList.length(); i++) {
			int index = stringIndexList[i].atoi();
			genbeamsInStack.append(genbeamsToStack[index]);
		}
		GenBeam genbeamsToDimensionFiltered[] = genbeamsToDimension;
		if (dimensionedEntities == "Dimensioned genbeams in stack" || dimensionedEntities == "Dimensioned genbeams in stack only") {
		    genbeamsToDimensionFiltered = genbeamsInStack;
	    }
		else if (dimensionedEntities == "Dimensioned genbeams touching stack") {
			genbeamsToDimensionFiltered = genbeamsTouchingOther(genbeamsToDimension, genbeamsInStack);
		}
		int isAmatch = false;
		for (int k=0; k<genbeamsFromGrip.length(); k++) {
			GenBeam& thisGenbeamFromGrip = genbeamsFromGrip[k];
			if (genbeamsInStack.find(thisGenbeamFromGrip) >= 0) {
				isAmatch = true;
				break;
			}
		}
		if (isAmatch) {
			Vector3d dimensionDirection, directionAwayFromDimensionLine;
			getStackDimensionVectors(mapUserSelectedValues, genbeamsInStack.first(), dimensionDirection, directionAwayFromDimensionLine);
			
			Point3d pointDimensionLinePosition = gripMoved.ptLoc();
			pointDimensionLinePosition.transformBy(paperToModelTransformation);
			Dim dimensionToDraw = createDimensionFromGenbeamStack(mapUserSelectedValues, genbeamsToDimensionFiltered, genbeamsInStack, pointDimensionLinePosition, directionAwayFromDimensionLine, dimensionDirection);
			thisDisplay.draw(dimensionToDraw);
			break;
		}			
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

Grip gripsUpdated[0];
for (int i=0; i<stackedIndexes.length(); i++) {
	String& thisStackedIndex = stackedIndexes[i];
	GenBeam genbeamsInStack[0];
	String stringIndexList[] = thisStackedIndex.tokenize(",");
	for (int i=0; i<stringIndexList.length(); i++) {
		int index = stringIndexList[i].atoi();
		genbeamsInStack.append(genbeamsToStack[index]);
	}
	GenBeam genbeamsToDimensionFiltered[] = genbeamsToDimension;
	if (dimensionedEntities == "Dimensioned genbeams in stack" || dimensionedEntities == "Dimensioned genbeams in stack only") {
	    genbeamsToDimensionFiltered = genbeamsInStack;
	}
	else if (dimensionedEntities == "Dimensioned genbeams touching stack") {
		genbeamsToDimensionFiltered = genbeamsTouchingOther(genbeamsToDimension, genbeamsInStack);
	}
	Vector3d dimensionDirection, directionAwayFromDimensionLine;
	getStackDimensionVectors(mapUserSelectedValues, genbeamsInStack.first(), dimensionDirection, directionAwayFromDimensionLine);

	Point3d pointDimensionLinePosition;
	int isValidPoint = false;
	Grip gripCandidates[] = getGripPointsOfDimensionType(dimensionTypeName);
	Grip stackGrip = getGripFromGenbeamsInStack(gripCandidates, genbeamsInStack, isValidPoint);
	if (isValidPoint) {
		pointDimensionLinePosition = stackGrip.ptLoc();
		pointDimensionLinePosition.transformBy(paperToModelTransformation);
	}
	else {
		PlaneProfile genbeamOutlines[] = getGenbeamOutlines(genbeamsInStack);
		PlaneProfile outlineAll = getJoinedOutline(mapUserSelectedValues, genbeamOutlines);
		Point3d outlineVertexPoints[] = outlineAll.getGripVertexPoints();
		Point3d outlineVertexPointsOrdered[] = Line(thisElement.ptOrg(), directionAwayFromDimensionLine).orderPoints(outlineVertexPoints);
		pointDimensionLinePosition = outlineVertexPointsOrdered.first();
		
		Point3d pointGripDimensionLinePosition = pointDimensionLinePosition;
		pointGripDimensionLinePosition.transformBy(modelToPaperTransformation);
		stackGrip = Grip(pointGripDimensionLinePosition);
		setGripPointNameFromGenbeamsInStack(stackGrip, genbeamsInStack, dimensionTypeName);
	}
	gripsUpdated.append(stackGrip);

	Dim dimensionToDraw = createDimensionFromGenbeamStack(mapUserSelectedValues, genbeamsToDimensionFiltered, genbeamsInStack, pointDimensionLinePosition, directionAwayFromDimensionLine, dimensionDirection);
	thisDisplay.draw(dimensionToDraw);
}
recordGripsToDimensionPropertiesmap(mapDimensionProperties, gripsUpdated);
_Map.setMap(dimensionTypeName ,mapDimensionProperties);
removeGripsFromTSLGrips(dimensionTypeName);
_Grip.append(gripsUpdated);

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
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="2733" />
        <int nm="BreakPoint" vl="2976" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Added ability to offset dimension line from element or viewport " />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="19" />
      <str nm="Date" vl="6/24/2024 9:44:03 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Corrected genbeamOutline function" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="18" />
      <str nm="Date" vl="10/17/2023 4:47:36 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Corrected closest edge point detection" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="15" />
      <str nm="Date" vl="9/26/2023 3:41:16 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Fixed middle point bug" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="14" />
      <str nm="Date" vl="9/25/2023 3:48:18 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End