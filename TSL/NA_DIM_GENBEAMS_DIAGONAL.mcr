#Version 8
#BeginDescription
#Versions


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 0
#MinorVersion 1
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

if (_bOnDbCreated && _Entity.length()>0) {
	Entity viewportSideEntity = _Entity[0];
	TslInst viewportSideTSL = (TslInst)viewportSideEntity;
	if (viewportSideTSL.bIsValid()) {
		Map mapViewportSideTSL = viewportSideTSL.map();
		Entity dependants[] = mapViewportSideTSL.getEntityArray("Dependants", "Dependants", "Dependants");
		dependants.append(_ThisInst);
		mapViewportSideTSL.setEntityArray(dependants, false, "Dependants", "Dependants", "Dependants");
		viewportSideTSL.setMap(mapViewportSideTSL);
		reportMessage("\n" + scriptName() + " " + _kExecuteKey + " triggered viewport side tsl");
	}
	return;
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

int bSetToDependant = false; 
if (_bOnInsert) {
	if (insertCycleCount()>1) {
		eraseInstance();
		return;
	}
	int bNeedViewport = true;
	PrEntity entitySelector("\nOptional: " + "Select viewport side TSL to use its starting point and direction for diagonal dimension line", TslInst());
	if (entitySelector.go()) {
		Entity selectedEntities[] = entitySelector.set();
		for (int i=0; i<selectedEntities.length(); i++) {
			Entity& otherEntity = selectedEntities[i];
			TslInst tslOther = (TslInst)otherEntity;
			if (tslOther.bIsValid() && tslOther.scriptName() == "NA_DIM_GENBEAMS_AT_VIEWPORT_SIDE") {
				_Entity.append(tslOther);
				bNeedViewport = false;
				break;	
			}			
		}
	}

	if (bNeedViewport) {
		_Viewport.append(getViewport("\n" + "Select element viewport"));		
	}
	else 
	{
		bSetToDependant = true;
	}
}

//---------------
//--------------- <Insert routine> --- end
//endregion

//region Validation routine
//--------------- <Validation routine> --- start
//---------------

Element thisElement;
CoordSys modelToPaperTransformation;
Point3d pointViewportCenter;
double viewportWidth, viewportHeight;
if (_Entity.length()>0) {
	Entity viewportSideEntity = _Entity[0];
	TslInst viewportSideTSL = (TslInst)viewportSideEntity;
	if (viewportSideTSL.bIsValid()) {
		Entity elementEntity = _Map.getEntity("Element");
		thisElement = (Element)elementEntity;		
		modelToPaperTransformation = CoordSys(_Map.getPoint3d("Viewport\\ptOrg"), _Map.getVector3d("Viewport\\vX"), _Map.getVector3d("Viewport\\vY"), _Map.getVector3d("Viewport\\vZ"));
		pointViewportCenter = _Map.getPoint3d("Viewport\\ptCenPS");
		viewportWidth = _Map.getDouble("Viewport\\widthPS");
		viewportHeight = _Map.getDouble("Viewport\\heightPS");
	}
}
else {
	if (_Viewport.length()<1) {
		reportMessage("\n"+scriptName()+": "+"No valid viewport. Erasing this instance.");
		eraseInstance();
		return;
	}
	Viewport thisViewPort = _Viewport.first();
	thisElement = thisViewPort.element();
	modelToPaperTransformation = thisViewPort.coordSys();
	pointViewportCenter = thisViewPort.ptCenPS();
	viewportWidth = thisViewPort.widthPS();
	viewportHeight = thisViewPort.heightPS();
}

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
            Map mapPropString = createMap("Sort edges in direction", "Sort edges in direction", defaultLanguage);
            setMapName(mapPropString, "fr-CA", "Trier les bords dans la direction");
            String description_enUS = "Extreme edges of dimensioned beams/sheets in selected direction will be used to make diagonal dimension"
            + "\nIf set to From viewport side TSL, will use starting point and direction of dimension line of a linked TSL";
            String description_frCA = "Les bords extrêmes des bois/revêtement mesurés dans la direction sélectionnée seront utilisés pour faire la cote diagonale"
            + "\nSi défini à TSL du côté de la vue, utilisera le point de départ et la direction de la ligne de cote d’un TSL lié";
            setMapDescription(mapPropString, "en-US", description_enUS);
            setMapDescription(mapPropString, "fr-CA", description_frCA);            
            {
                Map mapValues = createValuesMap("en-US");
                {
                    String ids_enUS[] = { "Vertical", "Horizontal", "Longest side of bounding box", "Shortest side of bounding box", "From viewport side TSL"};
                    String ids_frCA[] = { "Verticale", "Horizontale", "Côté le plus long de la boîte englobante", "Côté le plus court de la boîte englobante", "TSL du côté de la vue"};
                    for (int i = 0; i < ids_enUS.length(); i++) {
                        addIDToValuesMap(mapValues, ids_enUS[i]);
                        addStringValueToValuesMap(mapValues, "en-US", ids_enUS[i]);
                        addStringValueToValuesMap(mapValues, "fr-CA", ids_frCA[i]);
                    }
                }//IDs, Values : en - US
                setDefaultID(mapPropString, "Longest side of bounding box");
                setValuesMapToProperty(mapPropString, mapValues);
            }//Values

            addPropStringToCategoryMap(mapCategory, mapPropString);
        }//Sort edges in direction
        {
            Map mapPropString = createMap("Diagonal to dimension", "Diagonal to dimension", defaultLanguage);
            setMapName(mapPropString, "fr-CA", "Cote diagonale");
            String description_enUS = "Will use shortest or longest diagonal of dimensioned beams/sheets to make diagonal dimension";
            String description_frCA = "Utilisera la diagonale la plus courte ou la plus longue des bois/revêtement mesurés pour faire la cote diagonale";
            setMapDescription(mapPropString, "en-US", description_enUS);
            setMapDescription(mapPropString, "fr-CA", description_frCA);
            {
                Map mapValues = createValuesMap("en-US");
                {
                    String ids_enUS[] = { "Shortest diagonal", "Longest diagonal"};
                    String ids_frCA[] = { "Diagonale la plus courte", "Diagonale la plus longue"};
                    for (int i = 0; i < ids_enUS.length(); i++) {
                        addIDToValuesMap(mapValues, ids_enUS[i]);
                        addStringValueToValuesMap(mapValues, "en-US", ids_enUS[i]);
                        addStringValueToValuesMap(mapValues, "fr-CA", ids_frCA[i]);
                    }
                }//IDs, Values : en - US
                setDefaultID(mapPropString, "Longest diagonal");
                setValuesMapToProperty(mapPropString, mapValues);
            }//Values

            addPropStringToCategoryMap(mapCategory, mapPropString);
        }//Diagonal to dimension

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
		
		addCategoryToPropertiesMap(mapOPMproperties, mapCategory);
	}//Genbeams to dimension
	{
		Map mapCategory = createMap("Dimension styling", "Dimension style and positioning", defaultLanguage);
		setMapName(mapCategory, "fr-CA", "Style et positionnement de cote");
		{
			Map mapPropDouble = createMap("Dimension line offset", "Dimension line offset", defaultLanguage);
			setMapName(mapPropDouble, "fr-CA", "Décalage de ligne de cote");
			setMapDescription(mapPropDouble, "en-US", "If more then 0, will offset dimension away from dimensioned points in paper space units");
			setMapDescription(mapPropDouble, "fr-CA", "Si plus que 0, décalera la cote à partir du points mesurés en unités d’espace papier");
			{
				Map mapDefault = createDoubleDefaultValueMap("Default", 0, defaultLanguage);
				setDoubleDefaultValue(mapDefault, 0, "fr-CA");
				setDefaultValueMap(mapPropDouble, mapDefault);
			}//Default value
			addPropDoubleToCategoryMap(mapCategory, mapPropDouble);
		}//Dimension line offset
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
			setMapDescription(mapPropString, "en-US", "Text orientation relative to dimension line");
			setMapDescription(mapPropString, "fr-CA", "Orientation de texte de cote par rapport à la ligne de cote");
			{
				Map mapValues = createValuesMap("en-US");
				{
					String ids_enUS[] = { "Above dimension line", "Below dimension line"};
					String ids_frCA[] = { "Au-dessus de la ligne de cote", "Au-dessous de la ligne de cote"};
					for (int i = 0; i < ids_enUS.length(); i++) {
						addIDToValuesMap(mapValues, ids_enUS[i]);
						addStringValueToValuesMap(mapValues, "en-US", ids_enUS[i]);
						addStringValueToValuesMap(mapValues, "fr-CA", ids_frCA[i]);
					}
				}//IDs, Values : en - US
				setDefaultID(mapPropString, "Above dimension line");
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
				setDefaultID(mapPropString, "Parallel");
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
	if (bSetToDependant) {
		mapUserSelectedValues.setString("Dimension options\\Sort edges in direction\\SelectedID", "From viewport side TSL");	
	}
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

//function to get projection plane for this viewport
Plane getProjectionPlaneForThisViewport()
{
	Point3d pointViewport = pointViewportCenter;
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
PlaneProfile getJoinedOutline(Map& inUserSelectedValuesMap, PlaneProfile& inOutlines[])
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

//function to get diagonal given properties map
LineSeg getDiagonalToDimension(Map& inUserSelectedValuesMap, PlaneProfile& inGenbeamOutlineJoined)
{
	LineSeg outDiagonal;
	String sortEdgesIndirection = getSelectedID(inUserSelectedValuesMap, "Dimension options", "Sort edges in direction");
	String diagonalToDimension = getSelectedID(inUserSelectedValuesMap, "Dimension options", "Diagonal to dimension");	
	Vector3d directionToSortX;
	if (sortEdgesIndirection == "From viewport side TSL") {
		int doFallback = true;
		if (_Entity.length()>0) {
			Vector3d directionFromTSL = _Map.getVector3d("DirectionFromTSL");
			if (!directionFromTSL.bIsZeroLength()) {
				directionToSortX = directionFromTSL;
				doFallback = false;
			}
		}
		if (doFallback) {
			sortEdgesIndirection = "Longest side of bounding box";
			diagonalToDimension = "Longest diagonal";	
		}
	}
	if (sortEdgesIndirection != "From viewport side TSL") {
		Vector3d directionToSort;
		if (sortEdgesIndirection == "Vertical") {
			directionToSortX = layoutYInModel;
		}
		else if (sortEdgesIndirection == "Horizontal") {
			directionToSortX = layoutXInModel;
		}
		else {
			Point3d allVertex[] = inGenbeamOutlineJoined.getGripVertexPoints();
			Point3d pointsX[] = Line(thisElement.ptOrg(), layoutXInModel).orderPoints(allVertex);
			Point3d pointsY[] = Line(thisElement.ptOrg(), layoutYInModel).orderPoints(allVertex);
			Vector3d directionLongest, directionShortest;
			if ((pointsX.last()-pointsX.first()).dotProduct(layoutXInModel) > (pointsY.last()-pointsY.first()).dotProduct(layoutYInModel)) {
				directionLongest = layoutXInModel;
				directionShortest = layoutYInModel;
			}
			else {
				directionLongest = layoutYInModel;
				directionShortest = layoutXInModel;
			}
			if (sortEdgesIndirection == "Longest side of bounding box") {
				directionToSortX = directionLongest;
			}
			else if (sortEdgesIndirection == "Shortest side of bounding box") {
				directionToSortX = directionShortest;
			}
		}
	}
	Vector3d directionToSortY = directionToSortX.crossProduct(layoutZInModel);
	if (directionToSortY.isParallelTo(layoutYInModel) && directionToSortY.dotProduct(layoutYInModel) < 0) {
		directionToSortY *= -1;
	}
	if (directionToSortY.isParallelTo(layoutXInModel) && directionToSortY.dotProduct(layoutXInModel) < 0) {
		directionToSortY *= -1;
	}
	Point3d midPoints[] = Line(thisElement.ptOrg(), directionToSortX).orderPoints(inGenbeamOutlineJoined.getGripEdgeMidPoints());
	PlaneProfile lumps[] = getLumps(inGenbeamOutlineJoined);
	LineSeg edges[0];
	for (int i=0; i<lumps.length(); i++) {
		PlaneProfile& thisOutline = lumps[i];
		if (_bOnDebug) 
		{
			Display dpDebug(2);
			PlaneProfile ppToDraw(thisOutline);
			ppToDraw.transformBy(modelToPaperTransformation);
			dpDebug.draw(ppToDraw, _kDrawFilled, 60);
			dpDebug.color(5);
			dpDebug.draw(ppToDraw);
		}
		Point3d verticies[] = thisOutline.getGripVertexPoints();
		verticies.append(verticies.first());		
		for (int k=1; k<verticies.length(); k++){
			edges.append(LineSeg(verticies[k-1], verticies[k]));
		}
	}
	LineSeg edgeFirst, edgeLast;
	int iUsed[0];
	for (int i=0; i<edges.length(); i++) {
		LineSeg& thisEdge = edges[i];
		if ((thisEdge.ptMid()-midPoints.first()).bIsZeroLength()) {
			edgeFirst = thisEdge;
			iUsed.append(i);
		}
		else if ((thisEdge.ptMid()-midPoints.last()).bIsZeroLength()) {
			edgeLast = thisEdge;
			iUsed.append(i);
		}
	}
	if (lumps.length()>1) {
		Plane workingPlane = getClosestProjectionPlane(inUserSelectedValuesMap);
		for (int i=0; i<edges.length(); i++) {
			if (iUsed.find(i)>=0) continue;
			LineSeg& thisEdge = edges[i];
			Vector3d thisDirection = (thisEdge.ptStart() - thisEdge.ptEnd()).projectVector(workingPlane);
			Vector3d thisNormal = layoutZInModel.crossProduct(thisDirection).normal();
			Vector3d directionFirst = (edgeFirst.ptEnd() - edgeFirst.ptStart()).projectVector(workingPlane);
			Vector3d directionLast = (edgeLast.ptEnd() - edgeLast.ptStart()).projectVector(workingPlane);
			
			if (thisDirection.isParallelTo(directionFirst)) {				
				double sideDiviation = abs((thisEdge.ptMid() - edgeFirst.ptMid()).dotProduct(thisNormal));
				if (sideDiviation < mmToDrawingUnits(0.1)) {
					Point3d extendedPoints[] = {thisEdge.ptStart(), thisEdge.ptEnd(), edgeFirst.ptStart(), edgeFirst.ptEnd()};
					extendedPoints = Line(thisElement.ptOrg(), edgeFirst.ptEnd()-edgeFirst.ptStart()).orderPoints(extendedPoints);
					edgeFirst = LineSeg(extendedPoints[0], extendedPoints[3]);
				}
			}
			if (thisDirection.isParallelTo(directionLast)) {
				double sideDiviation = abs((thisEdge.ptMid() - edgeLast.ptMid()).dotProduct(thisNormal));
				if (sideDiviation < mmToDrawingUnits(0.1)) {
					Point3d extendedPoints[] = {thisEdge.ptStart(), thisEdge.ptEnd(), edgeLast.ptStart(), edgeLast.ptEnd()};
					extendedPoints = Line(thisElement.ptOrg(), edgeLast.ptEnd()-edgeLast.ptStart()).orderPoints(extendedPoints);
					edgeLast = LineSeg(extendedPoints[0], extendedPoints[3]);
				}
			}
		}
	}
	if (directionToSortY.dotProduct(edgeFirst.ptEnd()-edgeFirst.ptStart()) < 0) {
		edgeFirst = LineSeg(edgeFirst.ptEnd(), edgeFirst.ptStart());
	}
	if (directionToSortY.dotProduct(edgeLast.ptEnd()-edgeLast.ptStart()) < 0) {
		edgeLast = LineSeg(edgeLast.ptEnd(), edgeLast.ptStart());
	}
	if (_bOnDebug) 
	{
		Display dpDebug(1);
		LineSeg lsF(edgeFirst);
		LineSeg lsL(edgeLast);
		lsF.transformBy(modelToPaperTransformation);
		lsL.transformBy(modelToPaperTransformation);
		dpDebug.draw(lsF);
		dpDebug.draw(lsL);
	}
	LineSeg diagonals[] = {LineSeg(edgeFirst.ptStart(), edgeLast.ptEnd()), LineSeg(edgeFirst.ptEnd(), edgeLast.ptStart())};
	if (diagonals[0].length() < diagonals[1].length() && abs(diagonals[0].length()-diagonals[1].length()) > mmToDrawingUnits(0.1)) {
		diagonals.swap(0, 1);
	}
	if (diagonalToDimension == "Longest diagonal") {
		outDiagonal = diagonals[0];
	}
	else if (diagonalToDimension == "Shortest diagonal") {
		outDiagonal = diagonals[1];
	}

	return outDiagonal;
}

//function to create dimension from diagonal line
Dim createDimensionFromDiagonal(Map& inUserSelectedValuesMap, LineSeg& inDiagonalToDimension) {
	
	double dimensionLineOffset = getDoubleSelectedValue(inUserSelectedValuesMap, "Dimension styling", "Dimension line offset");
	Vector3d dimensionDirection = inDiagonalToDimension.ptEnd() - inDiagonalToDimension.ptStart();
	dimensionDirection.normalize();
	if (dimensionDirection.dotProduct(layoutXInModel) < 0) {
		dimensionDirection *= -1;	
	}
	Vector3d directionAwayFromDimensionLine = dimensionDirection.crossProduct(layoutZInModel);
	directionAwayFromDimensionLine.normalize();
	if (directionAwayFromDimensionLine.dotProduct(layoutYInModel) > 0) {
		directionAwayFromDimensionLine *= -1;	
	}
	Point3d pointDimensionLinePosition = inDiagonalToDimension.ptMid();
	String textSide = getSelectedID(inUserSelectedValuesMap, "Dimension styling", "Text side");
	int textSideFlag = textSide == "Above dimension line" ? -1 : 1;
	
	String textOrientation = getSelectedID(inUserSelectedValuesMap, "Dimension styling", "Text orientation");
	int textOrientationDisplayModus = textOrientation == "Parallel" ? _kDimPar : _kDimPerp;
	String projectPointsToDimensionLine = getSelectedID(inUserSelectedValuesMap, "Dimension styling", "Project points to dimension line");

	DimLine dimensionLine(pointDimensionLinePosition, dimensionDirection, directionAwayFromDimensionLine * textSideFlag);
	dimensionLine.setUseDisplayTextHeight(true);
	dimensionLine.transformBy(-directionAwayFromDimensionLine*dimensionLineOffset*viewportScale);

	Point3d pointsToDimensionAll[] = {inDiagonalToDimension.ptStart(), inDiagonalToDimension.ptEnd()};
	if (projectPointsToDimensionLine == "Yes") {
		pointsToDimensionAll = Line(dimensionLine.ptOrg(), dimensionDirection).projectPoints(pointsToDimensionAll);
	}
	Dim outDimension(dimensionLine, pointsToDimensionAll,  "<>", "", textOrientationDisplayModus, _kDimNone);
	
	outDimension.transformBy(modelToPaperTransformation);	
	if (textOrientationDisplayModus == _kDimPerp) outDimension.setReadDirection(_XW + _YW);
	else outDimension.setReadDirection(-_XW + _YW);
	outDimension.correctTextNormalForViewDirection(_ZW);
	
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

if ( ! _bOnInsert) {
	GenBeam genbeamsToDimension[] = getDimensionedGenbeamsFromPropertiesMap(mapUserSelectedValues);
	PlaneProfile genbeamsOutlines[] = getGenbeamOutlines(genbeamsToDimension);
	PlaneProfile genbeamsOutlineJoined = getJoinedOutline(mapUserSelectedValues, genbeamsOutlines);
	LineSeg diagonalToDimension = getDiagonalToDimension(mapUserSelectedValues, genbeamsOutlineJoined);
	
	Display thisDisplay = createDisplayFromPropertiesMap(mapUserSelectedValues);
	
	//region On grip point moved
	//--------------- <On grip point moved> --- start
	//---------------
	
	// if (_bOnGripPointDrag && _kExecuteKey=="_Grip") {
	
	// 	Grip gripCandidates[] = getGripPointsOfDimensionType(dimensionTypeName);
	// 	int indexMoved = Grip().indexOfMovedGrip(gripCandidates);
	// 	if (_bOnDebug) reportMessage("\n" + scriptName() + " " + _kExecuteKey + " indexMoved = " + indexMoved);
	// 	if (indexMoved < 0) return;
	// 	Grip& gripMoved = gripCandidates[indexMoved];
	// 	if (_bOnDebug) reportMessage("\n" + scriptName() + " " + _kExecuteKey + " gripMoved.name() = " + gripMoved.name());
	// 	if (gripMoved.name() == dimensionTypeName+"~Dimension line position") {
	// 		Dim dimensionToDraw = createDimensionFromDiagonal(mapUserSelectedValues, pointsToDimension, pointsToReference, directionAwayFromDimensionLine, dimensionDirection);
	// 		thisDisplay.draw(dimensionToDraw);
	// 	}
	// 	return;
	// }
	
	// if (_kNameLastChangedProp == "_Grip") {
	// 	Grip gripCandidates[] = getGripPointsOfDimensionType(dimensionTypeName);
	// 	recordGripsToDimensionPropertiesmap(mapDimensionProperties, gripCandidates);
	// 	_Map.setMap(dimensionTypeName ,mapDimensionProperties);
	// }
	
	//---------------
	//--------------- <On grip point moved> --- end
	//endregion
	
	Dim dimensionToDraw = createDimensionFromDiagonal(mapUserSelectedValues, diagonalToDimension);
	thisDisplay.draw(dimensionToDraw);
	
	if (_bOnDebug) {
		Point3d viewportLeftBottom = pointViewportCenter - _XW * viewportWidth / 2 - _YW * viewportHeight / 2;
		Display	displayTemp(-1);
		displayTemp.textHeight(mmToDrawingUnits(4));
		displayTemp.draw(scriptName(), viewportLeftBottom, _XW, _YW, - 1, - 1);
		
	}
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
      <str nm="COMMENT" vl="Added option to pack dimensioned beams/sheets to reduce the amount of points to dimension" />
      <int nm="MAJORVERSION" vl="0" />
      <int nm="MINORVERSION" vl="16" />
      <str nm="DATE" vl="10/3/2023 8:06:22 PM" />
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