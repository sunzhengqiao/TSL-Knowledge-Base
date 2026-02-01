#Version 8
#BeginDescription
#Versions
V0.17 10/17/2023 Corrected genbeamOutline function
V0.16 10/10/2023 fixed negative zones selection bug
V0.15 10/5/2023 Zone filter fix
V0.14 9/25/2023 Draw script name on debug


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 0
#MinorVersion 17
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
	//set default language to en-US
	setPropertiesDefaultLanguage(mapOPMproperties, defaultLanguage);

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

		addCategoryToPropertiesMap(mapOPMproperties, mapCategory);
	}//Genbeams to dimension

	{
		Map mapCategory = createMap("Genbeams to reference", "Beams/Sheets to reference", defaultLanguage);
		setMapName(mapCategory, "fr-CA", "Bois/Revêtement qui sont référencés");

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
				}//IDs, Values : en-US, fr-CA

				setDefaultID(mapPropString, "None");
				setValuesMapToProperty(mapPropString, mapValues);
			}//Values

			addPropStringToCategoryMap(mapCategory, mapPropString);
		}//Exclude filter

		addCategoryToPropertiesMap(mapOPMproperties, mapCategory);
	}//Genbeams to reference

	{
		Map mapCategory = createMap("Dimension styling", "Dimension style and positioning", defaultLanguage);
		setMapName(mapCategory, "fr-CA", "Style et positionnement de cote");

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
			Map mapPropString = createMap("Dimension gaps only", "Dimension the gaps only", defaultLanguage);
			setMapName(mapPropString, "fr-CA", "Mesurer seulement les espaces");
			setMapDescription(mapPropString, "en-US", "If set to Yes will dimension only gaps between beams/sheets");
			setMapDescription(mapPropString, "fr-CA", "Si défini à Oui, mesurera seulement les espaces entre les bois/revêtement");

			{
				Map mapValues = createValuesMap("en-US");
				{
					String ids_enUS[] = { "Yes", "No"};
					String ids_frCA[] = { "Oui", "Non"};
					for (int i = 0; i < ids_enUS.length(); i++) {
						addIDToValuesMap(mapValues, ids_enUS[i]);
						addStringValueToValuesMap(mapValues, "en-US", ids_enUS[i]);
						addStringValueToValuesMap(mapValues, "fr-CA", ids_frCA[i]);
					}
				}//IDs, Values:en-US

				setDefaultID(mapPropString, "No");
				setValuesMapToProperty(mapPropString, mapValues);
			}//Values

			addPropStringToCategoryMap(mapCategory, mapPropString);
		}//Dimension gaps only

		{
			Map mapPropString = createMap("Display horizontal dims", "Display horizontal dims", defaultLanguage);
			setMapName(mapPropString, "fr-CA", "Afficher les cotes horizontales");
			setMapDescription(mapPropString, "en-US", "If set to Yes will display horizontal dimensions");
			setMapDescription(mapPropString, "fr-CA", "Si défini à Oui, affichera les cotes horizontales");

			{
				Map mapValues = createValuesMap("en-US");
				{
					String ids_enUS[] = { "Yes", "No"};
					String ids_frCA[] = { "Oui", "Non"};
					for (int i = 0; i < ids_enUS.length(); i++) {
						addIDToValuesMap(mapValues, ids_enUS[i]);
						addStringValueToValuesMap(mapValues, "en-US", ids_enUS[i]);
						addStringValueToValuesMap(mapValues, "fr-CA", ids_frCA[i]);
					}
				}//IDs, Values:en-US

				setDefaultID(mapPropString, "Yes");
				setValuesMapToProperty(mapPropString, mapValues);
			}//Values

			addPropStringToCategoryMap(mapCategory, mapPropString);
		}//Display horizontal dims

		{
			Map mapPropDouble = createMap("Horizontal dims offset", "Horizontal dims offset", defaultLanguage);
			setMapName(mapPropDouble, "fr-CA", "Décalage de cote horizontale");
			setMapDescription(mapPropDouble, "en-US", "If more then 0, will offset horizontal dimension away from dimensioned points in paper space units");
			setMapDescription(mapPropDouble, "fr-CA", "Si plus que 0, décalera le texte de cote horizontale à partir des points mesurés en unités d’espace papier");

			{
				Map mapDefault = createDoubleDefaultValueMap("Default", 0.15625, defaultLanguage);//5/32"
				setDoubleDefaultValue(mapDefault, 4, "fr-CA");//4mm
				setDefaultValueMap(mapPropDouble, mapDefault);
			}//Default value

			addPropDoubleToCategoryMap(mapCategory, mapPropDouble);
		}//Horizontal dims offset

		{
			Map mapPropString = createMap("Horizontal dims text orientation", "Horizontal dims text orientation", defaultLanguage);
			setMapName(mapPropString, "fr-CA", "Orientation de texte de cote horizontale");
			setMapDescription(mapPropString, "en-US", "Horizontal dimensions text orientation relative to dimension line");
			setMapDescription(mapPropString, "fr-CA", "Orientation de texte  de cote horizontale par rapport à la ligne de cote");

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

				setDefaultID(mapPropString, "Parallel");
				setValuesMapToProperty(mapPropString, mapValues);
			}//Values

			addPropStringToCategoryMap(mapCategory, mapPropString);
		}// Horizontal dims text orientation

		{
			Map mapPropString = createMap("Display vertical dims", "Display vertical dims", defaultLanguage);
			setMapName(mapPropString, "fr-CA", "Afficher les cotes verticales");
			setMapDescription(mapPropString, "en-US", "If set to Yes will display vertical dimensions");
			setMapDescription(mapPropString, "fr-CA", "Si défini à Oui, affichera les cotes verticales");

			{
				Map mapValues = createValuesMap("en-US");
				{
					String ids_enUS[] = { "Yes", "No"};
					String ids_frCA[] = { "Oui", "Non"};
					for (int i = 0; i < ids_enUS.length(); i++) {
						addIDToValuesMap(mapValues, ids_enUS[i]);
						addStringValueToValuesMap(mapValues, "en-US", ids_enUS[i]);
						addStringValueToValuesMap(mapValues, "fr-CA", ids_frCA[i]);
					}
				}//IDs, Values:en-US

				setDefaultID(mapPropString, "Yes");
				setValuesMapToProperty(mapPropString, mapValues);
			}//Values

			addPropStringToCategoryMap(mapCategory, mapPropString);
		}//Display vertical dims

		{
			Map mapPropDouble = createMap("Vertical dims offset", "Vertical dims offset", defaultLanguage);
			setMapName(mapPropDouble, "fr-CA", "Décalage de cote verticale");
			setMapDescription(mapPropDouble, "en-US", "If more then 0, will offset vertical dimension away from dimensioned points in paper space units");
			setMapDescription(mapPropDouble, "fr-CA", "Si plus que 0, décalera la cote verticale à partir des points mesurés en unités d’espace papier");

			{
				Map mapDefault = createDoubleDefaultValueMap("Default", 0.15625, defaultLanguage);//5/32"
				setDoubleDefaultValue(mapDefault, 4, "fr-CA");//4mm
				setDefaultValueMap(mapPropDouble, mapDefault);
			}//Default value

			addPropDoubleToCategoryMap(mapCategory, mapPropDouble);
		}//Vertical offset

		{
			Map mapPropString = createMap("Vertical dims text orientation", "Vertical dims text orientation", defaultLanguage);
			setMapName(mapPropString, "fr-CA", "Orientation de texte de cote verticale");
			setMapDescription(mapPropString, "en-US", "Vertical dimensions text orientation relative to dimension line");
			setMapDescription(mapPropString, "fr-CA", "Orientation de texte  de cote verticale par rapport à la ligne de cote");

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
		}// Vertical dims text orientation

		{
			Map mapPropString = createMap("Display angled dims", "Display angled dims", defaultLanguage);
			setMapName(mapPropString, "fr-CA", "Afficher les cotes angulaires");
			setMapDescription(mapPropString, "en-US", "If set to Yes will display angled dimensions");
			setMapDescription(mapPropString, "fr-CA", "Si défini à Oui, affichera les cotes angulaires");

			{
				Map mapValues = createValuesMap("en-US");
				{
					String ids_enUS[] = { "Yes", "No"};
					String ids_frCA[] = { "Oui", "Non"};
					for (int i = 0; i < ids_enUS.length(); i++) {
						addIDToValuesMap(mapValues, ids_enUS[i]);
						addStringValueToValuesMap(mapValues, "en-US", ids_enUS[i]);
						addStringValueToValuesMap(mapValues, "fr-CA", ids_frCA[i]);
					}
				}//IDs, Values:en-US

				setDefaultID(mapPropString, "Yes");
				setValuesMapToProperty(mapPropString, mapValues);
			}//Values

			addPropStringToCategoryMap(mapCategory, mapPropString);
		}//Display angled dims

		{
			Map mapPropDouble = createMap("Angled dims offset", "Angled dims offset", defaultLanguage);
			setMapName(mapPropDouble, "fr-CA", "Décalage de cote angulaire");
			setMapDescription(mapPropDouble, "en-US", "If more then 0, will offset angled dimension away from dimensioned points in paper space units");
			setMapDescription(mapPropDouble, "fr-CA", "Si plus que 0, décalera la cote angulaire à partir des points mesurés en unités d’espace papier");

			{
				Map mapDefault = createDoubleDefaultValueMap("Default", 0.15625, defaultLanguage);//5/32"
				setDoubleDefaultValue(mapDefault, 4, "fr-CA");//4mm
				setDefaultValueMap(mapPropDouble, mapDefault);
			}//Default value

			addPropDoubleToCategoryMap(mapCategory, mapPropDouble);
		}//Angled offset

		{
			Map mapPropString = createMap("Angled dims text orientation", "Angled dims text orientation", defaultLanguage);
			setMapName(mapPropString, "fr-CA", "Orientation de texte de cote angulaire");
			setMapDescription(mapPropString, "en-US", "Angled dimensions text orientation relative to dimension line");
			setMapDescription(mapPropString, "fr-CA", "Orientation de texte  de cote angulaire par rapport à la ligne de cote");

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
		}// Angled dims text orientation


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
String getPropStringSelectedValueFromOPMmap(Map& inOPMmap, String& inLocalisedCategoryName, String& inLocalisedPropertyName) 
{
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
void recordGripsToDimensionPropertiesmap(Map& inDimensionPropertiesMap, Grip& inGripsUpdated[]) 
{
	Map mapGripPoints = createMapFromGripPoints(inGripsUpdated);
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
int isGripOnGenbeamEdge(Grip& inGrip, LineSeg& inEdgeSegment) {
	Point3d gripPoint = inGrip.ptLoc();
	gripPoint.transformBy(paperToModelTransformation);

	return PLine(inEdgeSegment.ptStart(), inEdgeSegment.ptEnd()).isOn(gripPoint);
}

//function to get genbeam it belongs to
GenBeam getGenbeamFromGrip(Grip& inGrip) {
	String handleFromGrip = inGrip.name().token(1, "~");
	Entity genbeamEntity;
	genbeamEntity.setFromHandle(handleFromGrip);	

	return (GenBeam) genbeamEntity;
}

//function to get grips that belong to genbeam
Grip[] getGripsAtGenbeam(Grip& inGrips, GenBeam& inGenbeam) {
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

//---------------
//--------------- <Functions to control grip points> --- end
//endregion

//region Genbeam functions
//--------------- <Genbeam functions> --- start
//---------------

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

//function to get referenced genbeams given properties map
GenBeam[] getReferencedGenbeamsFromPropertiesMap(Map& inUserSelectedValuesMap)
{
	GenBeam outGenbeams[0];
	int selectedZoneIndex = getLocalisedIntValue(inUserSelectedValuesMap, "Genbeams to reference", "Zone", "Any");
	String includeFilter = getSelectedID(inUserSelectedValuesMap, "Genbeams to reference", "Include filter");
	String excludeFilter = getSelectedID(inUserSelectedValuesMap, "Genbeams to reference", "Exclude filter");
	outGenbeams.append(getGenbeamsFiltered(selectedZoneIndex, includeFilter, excludeFilter));

	return outGenbeams;
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
PlaneProfile getGenbeamOutline(GenBeam& inGenbeam)
{
	int isAlignedToLength = false;
	Vector3d thisNormal = getAlignedVector(inGenbeam, -layoutZInModel, isAlignedToLength);
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
			if (thisNormal.dotProduct(layoutZInModel) > 0) {
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
		PlaneProfile thisOutline = getGenbeamOutline(thisGenbeam);
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

//function to get closest point to given point from given points array in given direction
int getClosestPointIndexFromPointsArray(Point3d& inPoints[], Point3d& inPoint, Vector3d inDirection)
{
	int outIndex = -1;
	double minDistance = -1;
	for (int i=0; i<inPoints.length(); i++) {
		Point3d& thisPoint = inPoints[i];
		Vector3d thisVector = thisPoint - inPoint;
		double thisDistance = (thisPoint - inPoint).dotProduct(inDirection);
		if (thisDistance < mmToDrawingUnits(0.1)) continue;
		if (minDistance < 0 || thisDistance < minDistance) {
			minDistance = thisDistance;
			outIndex = i;
		}
	}
	return outIndex;
}

//function to create outline edge to reference outline linesegment at given point
int createGenbeamEdgeToReferenceLinesegmentAtPoint(Point3d& inPointOnEdge, LineSeg& inEdge, PlaneProfile& inDimensionOutline, PlaneProfile& inOtherDimensionOutlines[], PlaneProfile& inReferenceOutline, int& inDimensionGapsOnly, LineSeg& outLinesegment) {
	int isValidLineseg = false;
	inPointOnEdge = inPointOnEdge.projectPoint(Plane(inReferenceOutline.ptMid(), inReferenceOutline.coordSys().vecZ()), 0);
	Vector3d edgeDirection = inEdge.ptEnd() -inEdge.ptStart();
	edgeDirection.normalize();
	Vector3d edgeNormal = edgeDirection.crossProduct(layoutZInModel);
	edgeNormal.normalize();
	if (inDimensionOutline.pointInProfile(inPointOnEdge + edgeNormal * mmToDrawingUnits(1)) == _kPointInProfile)
		edgeNormal *= -1;
	Plane edgeCrossingPlane(inPointOnEdge, edgeDirection);
	Point3d referenceOutlineIntersectPoints[] = inReferenceOutline.intersectPoints(edgeCrossingPlane, true, true);
	int closestPointIndexInPositiveDirection = getClosestPointIndexFromPointsArray(referenceOutlineIntersectPoints, inPointOnEdge, edgeNormal);
	int closestPointIndexInNegativeDirection = getClosestPointIndexFromPointsArray(referenceOutlineIntersectPoints, inPointOnEdge, - 1 * edgeNormal);
	if (closestPointIndexInPositiveDirection >= 0) {
		Point3d& referenceOutlineIntersectPoint = referenceOutlineIntersectPoints[closestPointIndexInPositiveDirection];
		outLinesegment = LineSeg(inPointOnEdge, referenceOutlineIntersectPoint);
		int isInsideOtherOutline = false;
		for (int m=0; m<inOtherDimensionOutlines.length(); m++) {
			PlaneProfile& otherDimensionOutline = inOtherDimensionOutlines[m];
			if (otherDimensionOutline.pointInProfile(referenceOutlineIntersectPoint) == _kPointInProfile) {
				isInsideOtherOutline = true;
				break;
			}
			LineSeg splits[] = otherDimensionOutline.splitSegments(outLinesegment, true);
			if (splits.length() > 0) {
				isInsideOtherOutline = true;
				break;
			}
		}				
		
		if ( ! isInsideOtherOutline) {									
			LineSeg crossings[] = inReferenceOutline.splitSegments(outLinesegment,false);
			int satisfyQuantity = !inDimensionGapsOnly ? 0 : 1;					
			if (crossings.length() == satisfyQuantity) {						
				isValidLineseg = true;
			}
		}
	}
	if (closestPointIndexInNegativeDirection >= 0 && !isValidLineseg && !inDimensionGapsOnly) {
		Point3d& referenceOutlineIntersectPoint = referenceOutlineIntersectPoints[closestPointIndexInNegativeDirection];				
		if (inDimensionOutline.pointInProfile(referenceOutlineIntersectPoint) == _kPointInProfile) {					
			outLinesegment = LineSeg(inPointOnEdge, referenceOutlineIntersectPoint);
			isValidLineseg = true;
		}
	}
	return isValidLineseg;
}

//function to create outline edge to reference outline edge linesegments, will create or remove grips if needed
LineSeg[] createGenbeamEdgeToReferenceLinesegments(Map& inUserSelectedValuesMap, GenBeam& inDimensionGenbeams, PlaneProfile& inDimensionOutlines[], PlaneProfile& inReferenceOutline)
{
	
	String drawHorizontal = getSelectedID(inUserSelectedValuesMap, "Dimension styling", "Display horizontal dims");
	String drawVertical = getSelectedID(inUserSelectedValuesMap, "Dimension styling", "Display vertical dims");
	String drawAngled = getSelectedID(inUserSelectedValuesMap, "Dimension styling", "Display angled dims");
	int bDimensionGapsOnly = getSelectedID(inUserSelectedValuesMap, "Dimension styling", "Dimension gaps only") == "Yes";
	Plane referencePlane(inReferenceOutline.ptMid(), inReferenceOutline.coordSys().vecZ());
	
	LineSeg outLinesegments[0];
	Grip gripsUpdated[0];
	for (int i=0; i<inDimensionOutlines.length(); i++) {
		PlaneProfile& thisDimensionOutline = inDimensionOutlines[i];
		Point3d dimensionOutlineVertexPoints[] = thisDimensionOutline.getGripVertexPoints();
		dimensionOutlineVertexPoints.append(dimensionOutlineVertexPoints.first());
		dimensionOutlineVertexPoints = referencePlane.projectPoints(dimensionOutlineVertexPoints);
		
		GenBeam& thisGenbeam = inDimensionGenbeams[i];
		Grip genbeamGrips[] = getGripsAtGenbeam(dimensionGrips, thisGenbeam);
		int edgesQty = 0;		
		for (int k=1; k<dimensionOutlineVertexPoints.length(); k++) {			
			Vector3d thisEdgeDirection = dimensionOutlineVertexPoints[k] - dimensionOutlineVertexPoints[k - 1];
			if (thisEdgeDirection.length() <= mmToDrawingUnits(1)) continue;
			edgesQty++;
			Vector3d thisEdgeNormal = thisEdgeDirection.crossProduct(layoutZInModel);
			if (drawHorizontal == "No" && thisEdgeNormal.isParallelTo(layoutXInModel)) continue;
			if (drawVertical == "No" && thisEdgeNormal.isParallelTo(layoutYInModel)) continue;
			if (drawAngled == "No" && !thisEdgeNormal.isParallelTo(layoutXInModel) && !thisEdgeNormal.isParallelTo(layoutYInModel)) continue;

			LineSeg thisEdge(dimensionOutlineVertexPoints[k - 1], dimensionOutlineVertexPoints[k]);
			Point3d thisEdgePoint = thisEdge.ptMid();
			int indexOfGrip = -1;				
			for (int m=0; m<genbeamGrips.length(); m++) {
				Grip& thisGrip = genbeamGrips[m];
				if (isGripOnGenbeamEdge(thisGrip, thisEdge)) {
					indexOfGrip = m;
				}
			}
			if (indexOfGrip >= 0) {
				thisEdgePoint = genbeamGrips[indexOfGrip].ptLoc();
				thisEdgePoint.transformBy(paperToModelTransformation);
			} 
			PlaneProfile otherDimensionOutlines[0];
			for (int m=0; m<inDimensionOutlines.length(); m++) {
				if (m == i) continue;
				PlaneProfile& otherDimensionOutline = inDimensionOutlines[m];
				otherDimensionOutlines.append(otherDimensionOutline);
			}
			LineSeg thisLinesegment;
			int isValidLineseg = createGenbeamEdgeToReferenceLinesegmentAtPoint(thisEdgePoint, thisEdge, thisDimensionOutline, otherDimensionOutlines, inReferenceOutline, bDimensionGapsOnly, thisLinesegment);
			if (isValidLineseg) {
				outLinesegments.append(thisLinesegment);
				if (indexOfGrip < 0) {
					thisEdgePoint.transformBy(modelToPaperTransformation);
					Grip gripNew(thisEdgePoint);
					gripNew.setName(dimensionTypeName+"~"+thisGenbeam.handle());
					gripsUpdated.append(gripNew);
				}
				else {
					gripsUpdated.append(genbeamGrips[indexOfGrip]);
				}
			}
		}
		if (_bOnDebug) reportMessage("\n" + scriptName() + " " + _kExecuteKey + " edgesQty = " + edgesQty);
		
	}
	recordGripsToDimensionPropertiesmap(mapDimensionProperties, gripsUpdated);
	_Map.setMap(dimensionTypeName ,mapDimensionProperties);
	removeGripsFromTSLGrips(dimensionTypeName);
	_Grip.append(gripsUpdated);

	return outLinesegments;
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

//function to construct dimensions given properties map and linesegments
Dim[] createDimensionsFromLinesegments(Map& inUserSelectedValuesMap, LineSeg& inLinesegments[])
{
	String textSide = getSelectedID(inUserSelectedValuesMap, "Dimension styling", "Text side");
	int textSideFlag = textSide == "Away from dimensioned points" ? 1 : -1;

	double textOffsetHorizontal = getDoubleSelectedValue(inUserSelectedValuesMap, "Dimension styling", "Horizontal dims offset");
	String textOrientationHorizontal = getSelectedID(inUserSelectedValuesMap, "Dimension styling", "Horizontal dims text orientation");
	int textOrientationDisplayModusHorizontal = textOrientationHorizontal == "Parallel" ? _kDimPar : _kDimPerp;

	double textOffsetVertical = getDoubleSelectedValue(inUserSelectedValuesMap, "Dimension styling", "Vertical dims offset");
	String textOrientationVertical = getSelectedID(inUserSelectedValuesMap, "Dimension styling", "Vertical dims text orientation");
	int textOrientationDisplayModusVertical = textOrientationVertical == "Parallel" ? _kDimPar : _kDimPerp;

	double textOffsetAngled = getDoubleSelectedValue(inUserSelectedValuesMap, "Dimension styling", "Angled dims offset");
	String textOrientationAngled = getSelectedID(inUserSelectedValuesMap, "Dimension styling", "Angled dims text orientation");
	int textOrientationDisplayModusAngled = textOrientationAngled == "Parallel" ? _kDimPar : _kDimPerp;
	
	String dimensionStyle = getSelectedID(inUserSelectedValuesMap, "Dimension styling", "Dimension style");
	double dimensionTextHeight = getDoubleSelectedValue(inUserSelectedValuesMap, "Dimension styling", "Text height");
	
	Dim outDimensions[0];
	for (int i=0; i<inLinesegments.length(); i++) {
		LineSeg& thisLinesegment = inLinesegments[i];
		Vector3d thisDimX = thisLinesegment.ptEnd() - thisLinesegment.ptStart();
		thisDimX.normalize();
		Vector3d thisDimY = thisDimX.crossProduct(layoutZInModel);
		double thisDimlineOffset = textOffsetAngled;
		int textOrientationDisplayModus = textOrientationDisplayModusAngled;
		if (thisDimX.isParallelTo(layoutXInModel)) {
			if (!thisDimX.isCodirectionalTo(layoutXInModel))
				thisDimX *= -1;
			thisDimY = layoutYInModel;
			thisDimlineOffset = textOffsetHorizontal;
			textOrientationDisplayModus = textOrientationDisplayModusHorizontal;
		}
		else if (thisDimX.isParallelTo(layoutYInModel)) {
			if (!thisDimX.isCodirectionalTo(layoutYInModel))
				thisDimX *= -1;
			thisDimY = -layoutXInModel;
			thisDimlineOffset = textOffsetVertical;
			textOrientationDisplayModus = textOrientationDisplayModusVertical;
		}
		else {
			if (thisDimX.dotProduct(layoutXInModel+layoutYInModel)<0) {
				thisDimX *= -1;
			}
			thisDimY = thisDimX.crossProduct(layoutZInModel);
		}
		thisDimY *= textSideFlag;
		
		double moveDimBy;
		String dimText = String().formatUnit(thisLinesegment.length(), dimensionStyle); 
		double textSize = dimensionTextHeight < mmToDrawingUnits(0.1) ? 
			Display().textHeightForStyle(dimText, dimensionStyle) : 
			Display().textHeightForStyle(dimText, dimensionStyle, dimensionTextHeight);		
			
		for (int m=0; m<inLinesegments.length(); m++) {
			if (m == i) continue;
			LineSeg& otherLinesegment = inLinesegments[m];
			Vector3d otherDimX = otherLinesegment.ptEnd() - otherLinesegment.ptStart();
			if (!thisDimX.isParallelTo(otherDimX)) continue;	
			Vector3d vecOtherToThis = otherLinesegment.ptMid() - thisLinesegment.ptMid();
			
			double dY = abs(vecOtherToThis.dotProduct(thisDimY));			
			if (dY > 2 * textSize * viewportScale) continue;			
			
			double dX = abs(vecOtherToThis.dotProduct(thisDimX));			
			if (dX > 2 * textSize * viewportScale) continue;
			
			moveDimBy = (textSize * viewportScale) / 2;
			if (vecOtherToThis.dotProduct(thisDimY) > 0) 
				thisDimY *= -1;
					
			break;
		}	
		
		DimLine thisDimline(thisLinesegment.ptMid(), thisDimX, thisDimY);
		thisDimline.setUseDisplayTextHeight(true);
		if (thisDimlineOffset > mmToDrawingUnits(0.1))
			thisDimline.transformBy(thisDimY * thisDimlineOffset*viewportScale);
				
		Point3d thisDimPoints[] = {thisLinesegment.ptStart(), thisLinesegment.ptEnd()};		
		Dim thisDim(thisDimline, thisDimPoints, "<>", "", textOrientationDisplayModus, _kDimNone);
		if (moveDimBy > mmToDrawingUnits(0.1))
			thisDim.transformBy(thisDimY * moveDimBy);
		thisDim.transformBy(modelToPaperTransformation);		
		thisDim.correctTextNormalForViewDirection(_ZW);
		thisDim.setReadDirection(_YW - _XW);
		outDimensions.append(thisDim);
	}
	return outDimensions;
}

//---------------
//--------------- <Genbeam functions> --- end
//endregion

GenBeam genbeamsToDimension[] = getDimensionedGenbeamsFromPropertiesMap(mapUserSelectedValues);
GenBeam genbeamsToReference[] = getReferencedGenbeamsFromPropertiesMap(mapUserSelectedValues);
if (genbeamsToDimension.length() == 0 && genbeamsToReference.length() == 0) {
    reportMessage("\n" + scriptName() + " No genbeams to dimension or reference");
    return;
}

//region On grip point moved
//--------------- <On grip point moved> --- start
//---------------

addRecalcTrigger(_kGripPointDrag, "_Grip");

if (_bOnGripPointDrag && _kExecuteKey=="_Grip") {
	int bDimensionGapsOnly = getSelectedID(mapUserSelectedValues, "Dimension styling", "Dimension gaps only") == "Yes";
	Grip gripCandidates[] = getGripPointsOfDimensionType(dimensionTypeName);
	int indexMoved = Grip().indexOfMovedGrip(gripCandidates);
	if (indexMoved < 0) return;
	if (_bOnDebug) reportMessage("\n" + scriptName() + " " + _kExecuteKey + " indexMoved = " + indexMoved);
	Grip& gripMoved = gripCandidates[indexMoved];
	GenBeam genbeamMoved = getGenbeamFromGrip(gripMoved);
	if (!genbeamMoved.bIsValid()) return;
	if (_bOnDebug) reportMessage("\n" + scriptName() + " " + _kExecuteKey + " genbeamMoved = " + genbeamMoved);
	Point3d gripPointMoved = gripMoved.ptLoc();
	gripPointMoved.transformBy(paperToModelTransformation);
	PlaneProfile genbeamOutline = getGenbeamOutline(genbeamMoved);
	gripPointMoved = genbeamOutline.closestPointTo(gripPointMoved);
	
	Point3d dimensionOutlineVertexPoints[] = genbeamOutline.getGripVertexPoints();
	dimensionOutlineVertexPoints.append(dimensionOutlineVertexPoints.first());
	for (int k = 1; k < dimensionOutlineVertexPoints.length(); k++) {
		LineSeg thisEdge(dimensionOutlineVertexPoints[k - 1], dimensionOutlineVertexPoints[k]);
		if (thisEdge.length() <= mmToDrawingUnits(1)) continue;
		if ( ! PLine(thisEdge.ptStart(), thisEdge.ptEnd()).isOn(gripPointMoved)) continue;
		if (_bOnDebug) reportMessage("\n" + scriptName() + " " + _kExecuteKey + " edge found");
		GenBeam genbeamOthers[0];
		for (int m=0; m<genbeamsToDimension.length(); m++) {
			GenBeam& otherGenbeam = genbeamsToDimension[m];
			if (otherGenbeam == genbeamMoved) continue;
			genbeamOthers.append(otherGenbeam);
		}
		PlaneProfile otherDimensionOutlines[] = getGenbeamOutlines(genbeamOthers);
		PlaneProfile referenceOutlines[] = getGenbeamOutlines(genbeamsToReference);
		PlaneProfile referenceOutline = getJoinedOutline(mapUserSelectedValues, referenceOutlines);
		LineSeg thisLinesegment;
		int isValidLineseg = createGenbeamEdgeToReferenceLinesegmentAtPoint(gripPointMoved, thisEdge, genbeamOutline, otherDimensionOutlines,referenceOutline, bDimensionGapsOnly, thisLinesegment);
		if (_bOnDebug) reportMessage("\n" + scriptName() + " " + _kExecuteKey + " isValidLineseg = " + isValidLineseg);
		if (isValidLineseg) {
			Display thisDisplay = createDisplayFromPropertiesMap(mapUserSelectedValues);
			LineSeg segmentsToDimension[] = { thisLinesegment};
			Dim dimensionsToDraw[] = createDimensionsFromLinesegments(mapUserSelectedValues, segmentsToDimension);
			for (int m=0; m<dimensionsToDraw.length(); m++) {
				Dim& thisDimension = dimensionsToDraw[m];
				thisDisplay.draw(thisDimension);
			}
		}	
		
		break;
	}
	return;
}

if (_kNameLastChangedProp == "_Grip") {
	dimensionGrips.setLength(0);
	Grip gripCandidates[] = getGripPointsOfDimensionType(dimensionTypeName);
	for (int i=0; i<genbeamsToDimension.length(); i++) {
		GenBeam& thisGenbeam = genbeamsToDimension[i];
		PlaneProfile genbeamOutline = getGenbeamOutline(thisGenbeam);
		genbeamOutline.transformBy(modelToPaperTransformation);
		Grip genbeamGrips[] = getGripsAtGenbeam(_Grip, thisGenbeam);
		for (int k=0; k<genbeamGrips.length(); k++) {
			Grip& thisGrip = genbeamGrips[k];
			Point3d pointGrip = thisGrip.ptLoc();
			if (genbeamOutline.pointInProfile(pointGrip) != _kPointOnRing) {
				pointGrip = genbeamOutline.closestPointTo(pointGrip);
				thisGrip.setPtLoc(pointGrip);
			}
			dimensionGrips.append(thisGrip);
		}
	}
	recordGripsToDimensionPropertiesmap(mapDimensionProperties, dimensionGrips);
	_Map.setMap(dimensionTypeName ,mapDimensionProperties);
}

//---------------
//--------------- <On grip point moved> --- end
//endregion

PlaneProfile dimensionOutlines[] = getGenbeamOutlines(genbeamsToDimension);
PlaneProfile referenceOutlines[] = getGenbeamOutlines(genbeamsToReference);
PlaneProfile referenceOutline = getJoinedOutline(mapUserSelectedValues, referenceOutlines);

LineSeg dimensionEdgeToReferenceLinesegments[] = createGenbeamEdgeToReferenceLinesegments(mapUserSelectedValues, genbeamsToDimension, dimensionOutlines, referenceOutline);
Display thisDisplay = createDisplayFromPropertiesMap(mapUserSelectedValues);
Dim dimensionsEdgetoReference[] = createDimensionsFromLinesegments(mapUserSelectedValues, dimensionEdgeToReferenceLinesegments);
for (int i=0; i<dimensionsEdgetoReference.length(); i++) {
	Dim& thisDimension = dimensionsEdgetoReference[i];
	thisDisplay.draw(thisDimension);
}

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
    <lst nm="Version">
      <str nm="Comment" vl="Corrected genbeamOutline function" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="17" />
      <str nm="Date" vl="10/17/2023 4:46:04 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End