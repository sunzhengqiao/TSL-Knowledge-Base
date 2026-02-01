#Version 8
#BeginDescription
Last modified by: Robert Pol (support.nl@hsbcad.com)
10.01.2020- version 2.01
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 1
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl filters a set of gen beams.
/// </summary>

/// <insert>
/// Select a set of beams
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="2.01" date="10.01.2020"></version>

/// <history>
/// AS - 1.00 - 30.08.2016 - 		First revision.
/// AS - 1.01 - 07.09.2016 - 		Add label and material as filter options.
/// AS - 1.02 - 08.09.2016 - 		Also return map if map is empty.
/// AS - 1.03 - 15.11.2016 - 		Add hsbId as filter option.
/// AS - 1.04 - 08.12.2016 - 		Add zone as filter option.
/// YB - 1.05 - 19.06.2017 - 		Add name as filter option.
/// RP - 1.06 - 18.10.2017 - 		Bugfix matching name instead of matching zone.
/// RP - 1.07 - 09.11.2017 -		Add option for custom filter and use tokenize
/// RP - 1.08 - 11.11.2017 - 		Used Name[] instead of Value[]
/// AS - 1.09 - 05.04.2018 - 		Add ANY/ALL operator.
/// FA - 1.10 - 07.05.2018 - 		Making sure the strings are not case sensitive.
/// DR - 1.11 - 22.05.2018 - 		Also set properties found in _Map if the execute key is default or there're not catalogs created yet.
/// FA - 1.12 - 01.06.2018 - 		Using getListOfCatalogNames static instead of on _ThisInst, removed checking if the execute key is _Default
/// RP - 1.13 - 12.09.2018 - 		For loop was not using index but always the first in the list
/// RVW - 1.14 - 20.03.2019 - 	Add operator to _Map check to set the operator from a CallMapIO
/// RP - 2.00 - 09.01.2020 - 	Add option to get catalog from MapObject
/// RP - 2.01 - 10.01.2020 - 	Store mapobject when executekey is found, dont need seperate tsl anymore
/// </history>

// Filter options
String operations[] = {
	T("|Exclude|"),
	T("|Include|")
};

String categories[] = {
	T("|Operation|"),
	T("|Fixed Properties|"),
	T("|Format Properties|")
};

PropString operationFilter(0, operations, T("|Operation filter|"));
operationFilter.setCategory(categories[0]);
operationFilter.setDescription(T("|Include or exclude entities meeting the filter criteria.|"));

String all = T("|All|");
String any = T("|Any|");
String operators[] = 
{
	all,
	any
};

PropString operator(9, operators, T("|Operator|"), 1);
operator.setCategory(categories[0]);
operator.setDescription(T("|Specify whether all of the specified properties have to match or one of them.|"));

PropString propBeamCodes(1, "", T("|Beam codes|"));
propBeamCodes.setCategory(categories[1]);
PropString propMaterials(2, "", T("|Materials|"));
propMaterials.setCategory(categories[1]);
PropString propLabels(3, "", T("|Labels|"));
propLabels.setCategory(categories[1]);
PropString propHsbIds(4, "", T("|Hsb Id's|"));
propHsbIds.setCategory(categories[1]);
PropString propZones(5, "", T("|Zones|"));
propZones.setCategory(categories[1]);
PropString propNames(6, "", T("|Names|"));
propNames.setCategory(categories[1]);

PropString propCustom(7, "", T("|Custom Property|"));
propCustom.setCategory(categories[2]);
propCustom.setDescription(T("|Specify a custom propertie e.g.| @(") + T("|Material|) or @(") + T("|PropertySet.Property|)"));

PropString propCustomValues(8, "", T("|Custom Values|"));
propCustomValues.setCategory(categories[2]);
propCustomValues.setDescription(T("|Specify the value to check the custom property, * can be used as wildcard and as delimiter| ;"));

// Load configurations
String dictionary = "hsbTSL";
String entry = scriptName() + "Catalog";
MapObject catalogDictionary(dictionary, entry);

Map catalogMap = catalogDictionary.map();

// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if (_kExecuteKey != "" && catalogNames.find(_kExecuteKey) != -1) 
{
	setPropValuesFromCatalog(_kExecuteKey);
	catalogMap.setMap(_kExecuteKey, mapWithPropValues());
	if (catalogDictionary.bIsValid())
	{
		catalogDictionary.setMap(catalogMap);	
	}
	else
	{
		catalogDictionary.dbCreate(catalogMap);
	}
	
}

if (_bOnInsert) {
	if (insertCycleCount() > 1) {
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || catalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	setCatalogFromPropValues(T("|_LastInserted|"));
	
	PrEntity beamsSelection(T("|Select genbeams to filter|"), GenBeam());
	if (beamsSelection.go()) {
		Entity entities[] = beamsSelection.set();
		
		_Map.setEntityArray(entities, false, "GenBeams", "GenBeams", "GenBeam");
	}
	_Map.setInt("ManualInsert", true);

	return;
}

int manualInsert = false;
if (_Map.hasInt("ManualInsert")) {
	manualInsert = _Map.getInt("ManualInsert");
	_Map.removeAt("ManualInsert", true);
}



if (catalogDictionary.bIsValid() && catalogMap.hasMap(_kExecuteKey) && TslInst().getListOfCatalogNames(scriptName()).find(_kExecuteKey) == -1)
{
	Map entryMap = catalogMap.getMap(_kExecuteKey);
	setPropValuesFromMap(entryMap);
}
else if (_kExecuteKey == "" || TslInst().getListOfCatalogNames(scriptName()).find(_kExecuteKey) == -1) 
{ // Set properties found in _Map if the execute key is empty, default or there's not catalogs created yet.
	if (_Map.hasInt("Exclude")) 
	{
		int exclude = _Map.getInt("Exclude");
		if (exclude)
			operationFilter.set(operations[0]);
		else
			operationFilter.set(operations[1]);
	}
	
	if ( _Map.hasString("BeamCode[]"))
		propBeamCodes.set(_Map.getString("BeamCode[]"));
	if ( _Map.hasString("Material[]"))
		propMaterials.set(_Map.getString("Material[]"));
	if ( _Map.hasString("Label[]"))
		propLabels.set(_Map.getString("Label[]"));
	if ( _Map.hasString("HsbId[]"))
		propHsbIds.set(_Map.getString("HsbId[]"));
	if ( _Map.hasString("Zone[]"))
		propZones.set(_Map.getString("Zone[]"));
	if ( _Map.hasString("Name[]"))
		propNames.set(_Map.getString("Name[]"));
	if ( _Map.hasString("Custom[]"))
		propCustom.set(_Map.getString("Custom[]"));
	if ( _Map.hasString("Value[]"))
		propCustomValues.set(_Map.getString("Value[]"));
	if ( _Map.hasString("Operator[]"))
		operator.set(_Map.getString("Operator[]"));
}

int exclude = (operations.find(operationFilter) == 0);
int include = !exclude;
int caseSensitive = false;

String beamCodes[0];
String nonUpperBeamCodes[] = propBeamCodes.tokenize(";");
if (! caseSensitive)
{
	for (int i=0;i<nonUpperBeamCodes.length();i++) 
	{ 
		String code= nonUpperBeamCodes[i]; 
		code.makeUpper(); 
		beamCodes.append(code);
	}
}

String materials[0];
String nonUpperMaterials[] = propMaterials.tokenize(";");
if ( ! caseSensitive) {
	for (int i = 0; i < nonUpperMaterials.length(); i++)
	{
		String material = nonUpperMaterials[i];
		material.makeUpper();
		materials.append(material);
	}
}

String labels[0];
String nonUpperLabels[]  = propLabels.tokenize(";");
if ( ! caseSensitive) {
	for (int i = 0; i < nonUpperLabels.length(); i++)
	{
		String label = nonUpperLabels[i];
		label.makeUpper();
		labels.append(label);
	}
}

String hsbIds[0];
String nonUpperhsbIds[]  = propHsbIds.tokenize(";");
if ( ! caseSensitive) {
	for (int i = 0; i < nonUpperhsbIds.length(); i++)
	{
		String hsbId = nonUpperhsbIds[i];
		hsbId.makeUpper();
		hsbIds.append(hsbId);
	}
}

String zones[0];
String nonUpperZones[]  = propZones.tokenize(";");
if ( ! caseSensitive) {
	for (int i = 0; i < nonUpperZones.length(); i++)
	{
		String zone = nonUpperZones[i];
		zone.makeUpper();
		zones.append(zone);
	}
}

String names[0];
String nonUpperNames[]  = propNames.tokenize(";");
if ( ! caseSensitive) {
	for (int i = 0; i < nonUpperNames.length(); i++)
	{
		String name = nonUpperNames[i];
		name.makeUpper();
		names.append(name);
	}
}

String customValues[0];
String nonUpperCustomValues[]  = propCustomValues.tokenize(";");
if ( ! caseSensitive) {
	for (int i = 0; i < nonUpperCustomValues.length(); i++)
	{
		String cValues = nonUpperCustomValues[i];
		cValues.makeUpper();
		customValues.append(cValues);
	}
}

if (_bOnMapIO || manualInsert || _bOnDebug) {
//	reportNotice("\nMaterials: " + materials);

	Entity resultingGenBeams[0];
	Entity entities[] = _Map.getEntityArray("GenBeams", "GenBeams", "GenBeam");
	for (int e=0;e<entities.length();e++) {
		GenBeam gBm = (GenBeam)entities[e];
		if (!gBm.bIsValid())
			continue;
		
		String bmCode = gBm.beamCode().token(0);
		if (!caseSensitive)
			bmCode.makeUpper();
		bmCode.trimLeft();
		bmCode.trimRight();

		int matchingBeamCode = false;
		if (bmCode.length() == 0 || beamCodes.length() == 0) {
			matchingBeamCode = false;
		}
		else if (beamCodes.find(bmCode) != -1){
			matchingBeamCode = true;
		}
		else{
			String property = bmCode;
			int matchingProperty = matchingBeamCode;
			
			for( int f=0;f<beamCodes.length();f++ ){
				String filter = beamCodes[f];
				String filterTrimmed = filter;
				filterTrimmed.trimLeft("*");
				filterTrimmed.trimRight("*");
				if( filterTrimmed == "" ){
					if( filter == "*" && property != "" )
						matchingProperty = true;
					else
						continue;
				}
				else{
					if( filter.left(1) == "*" && filter.right(1) == "*" && property.find(filterTrimmed, 0) != -1 )
						matchingProperty = true;
					else if( filter.left(1) == "*" && property.right(filter.length() - 1) == filterTrimmed )
						matchingProperty = true;
					else if( filter.right(1) == "*" && property.left(filter.length() - 1) == filterTrimmed )
						matchingProperty = true;
				}
			}
			matchingBeamCode = matchingProperty;
		}
		
		String material = gBm.material().token(0);
		if (!caseSensitive)
			material.makeUpper();
		material.trimLeft();
		material.trimRight();
//reportNotice("\nMaterial: "+material);
		int matchingMaterial = false;
		if (material.length() == 0 || materials.length() == 0) {
			matchingMaterial = false;
		}
		else if (materials.find(material) != -1){
			matchingMaterial = true;
		}
		else{
			String property = material;
			int matchingProperty = matchingMaterial;

			for( int f=0;f<materials.length();f++ ){
				String filter = materials[f];
				String filterTrimmed = filter;
				filterTrimmed.trimLeft("*");
				filterTrimmed.trimRight("*");
				if( filterTrimmed == "" ){
					if( filter == "*" && property != "" )
						matchingProperty = true;
					else
						continue;
				}
				else{
					if( filter.left(1) == "*" && filter.right(1) == "*" && property.find(filterTrimmed, 0) != -1 )
						matchingProperty = true;
					else if( filter.left(1) == "*" && property.right(filter.length() - 1) == filterTrimmed )
						matchingProperty = true;
					else if( filter.right(1) == "*" && property.left(filter.length() - 1) == filterTrimmed )
						matchingProperty = true;
				}
			}
			
			matchingMaterial = matchingProperty;
		}
		
		String label = gBm.label().token(0);
		if (!caseSensitive)
			label.makeUpper();
		label.trimLeft();
		label.trimRight();

		int matchingLabel = false;
		if (label.length() == 0 || labels.length() == 0) {
			matchingLabel = false;
		}
		else if (labels.find(label) != -1){
			matchingLabel = true;
		}
		else{
			String property = label;
			int matchingProperty = matchingLabel;

			for( int f=0;f<labels.length();f++ ){
				String filter = labels[f];
				String filterTrimmed = filter;
				filterTrimmed.trimLeft("*");
				filterTrimmed.trimRight("*");
				if( filterTrimmed == "" ){
					if( filter == "*" && property != "" )
						matchingProperty = true;
					else
						continue;
				}
				else{
					if( filter.left(1) == "*" && filter.right(1) == "*" && property.find(filterTrimmed, 0) != -1 )
						matchingProperty = true;
					else if( filter.left(1) == "*" && property.right(filter.length() - 1) == filterTrimmed )
						matchingProperty = true;
					else if( filter.right(1) == "*" && property.left(filter.length() - 1) == filterTrimmed )
						matchingProperty = true;
				}
			}
			
			matchingLabel = matchingProperty;
		}
		
		String hsbId = gBm.hsbId().token(0);
		if (!caseSensitive)
			hsbId.makeUpper();
		hsbId.trimLeft();
		hsbId.trimRight();

		int matchingHsbId = false;
		if (hsbId.length() == 0 || hsbIds.length() == 0) {
			matchingHsbId = false;
		}
		else if (hsbIds.find(hsbId) != -1){
			matchingHsbId = true;
		}
		else{
			String property = hsbId;
			int matchingProperty = matchingHsbId;

			for( int f=0;f<hsbIds.length();f++ ){
				String filter = hsbIds[f];
				String filterTrimmed = filter;
				filterTrimmed.trimLeft("*");
				filterTrimmed.trimRight("*");
				if( filterTrimmed == "" ){
					if( filter == "*" && property != "" )
						matchingProperty = true;
					else
						continue;
				}
				else{
					if( filter.left(1) == "*" && filter.right(1) == "*" && property.find(filterTrimmed, 0) != -1 )
						matchingProperty = true;
					else if( filter.left(1) == "*" && property.right(filter.length() - 1) == filterTrimmed )
						matchingProperty = true;
					else if( filter.right(1) == "*" && property.left(filter.length() - 1) == filterTrimmed )
						matchingProperty = true;
				}
			}
			
			matchingHsbId = matchingProperty;
		}
		
		String zone = gBm.myZoneIndex();
		if (!caseSensitive)
			zone.makeUpper();
		zone.trimLeft();
		zone.trimRight();

		int matchingZone = false;
		if (zone.length() == 0 || zones.length() == 0) {
			matchingZone = false;
		}
		else if (zones.find(zone) != -1){
			matchingZone = true;
		}
		else{
			String property = zone;
			int matchingProperty = matchingZone;

			for( int f=0;f<zones.length();f++ ){
				String filter = zones[f];
				String filterTrimmed = filter;
				filterTrimmed.trimLeft("*");
				filterTrimmed.trimRight("*");
				if( filterTrimmed == "" ){
					if( filter == "*" && property != "" )
						matchingProperty = true;
					else
						continue;
				}
				else{
					if( filter.left(1) == "*" && filter.right(1) == "*" && property.find(filterTrimmed, 0) != -1 )
						matchingProperty = true;
					else if( filter.left(1) == "*" && property.right(filter.length() - 1) == filterTrimmed )
						matchingProperty = true;
					else if( filter.right(1) == "*" && property.left(filter.length() - 1) == filterTrimmed )
						matchingProperty = true;
				}
			}
			
			matchingZone = matchingProperty;
		}
		
		String name = gBm.name().token(0);
		if (!caseSensitive)
			name.makeUpper();
		name.trimLeft();
		name.trimRight();

		int matchingName = false;
		if (name.length() == 0 || names.length() == 0) {
			matchingName = false;
		}
		else if (names.find(name) != -1){
			matchingName = true;
		}
		else{
			String property = name;
			int matchingProperty = matchingName;

			for( int f=0;f<names.length();f++ ){
				String filter = names[f];
				String filterTrimmed = filter;
				filterTrimmed.trimLeft("*");
				filterTrimmed.trimRight("*");
				if( filterTrimmed == "" ){
					if( filter == "*" && property != "" )
						matchingProperty = true;
					else
						continue;
				}
				else{
					if( filter.left(1) == "*" && filter.right(1) == "*" && property.find(filterTrimmed, 0) != -1 )
						matchingProperty = true;
					else if( filter.left(1) == "*" && property.right(filter.length() - 1) == filterTrimmed )
						matchingProperty = true;
					else if( filter.right(1) == "*" && property.left(filter.length() - 1) == filterTrimmed )
						matchingProperty = true;
				}
			}
			
			matchingName = matchingProperty;
		}
		
		int matchingCustom = false;
		if (propCustomValues.length() > 0)
		{ 
			Map contentFormatMap;
			Entity ent = (Entity)gBm;
			contentFormatMap.setString("FormatContent", propCustom);
			contentFormatMap.setString("FormatValue", propCustomValues);
			contentFormatMap.setEntity("FormatEntity", ent);
			int succeeded = TslInst().callMapIO("HSB_G-ContentFormat", "", contentFormatMap);
			if (!succeeded)
			{
				reportNotice(T("|Please make sure the tsl HSB_G-ContentFormat is loaded in the drawing|"));
			}
			
			matchingCustom = contentFormatMap.getInt("FormatValueFound");
		}
		
		int propertyMatch = exclude;
		if (operator == any)
		{
			propertyMatch = matchingBeamCode || matchingMaterial || matchingLabel || matchingHsbId || matchingZone || matchingName || matchingCustom;
		}
		else //operator == all
		{
			int criteriaToMatch[0];
			if (beamCodes.length() > 0)
			{
				criteriaToMatch.append(matchingBeamCode);
			}
			if (materials.length() > 0)
			{
				criteriaToMatch.append(matchingMaterial);
			}
			if (labels.length() > 0)
			{
				criteriaToMatch.append(matchingLabel);
			}
			if (hsbIds.length() > 0)
			{
				criteriaToMatch.append(matchingHsbId);
			}
			if (zones.length() > 0)
			{
				criteriaToMatch.append(matchingZone);
			}
			if (names.length() > 0)
			{
				criteriaToMatch.append(matchingName);
			}
			if (customValues.length() > 0)
			{
				criteriaToMatch.append(matchingCustom);
			}
			
			if (criteriaToMatch.length() > 0)
			{
				propertyMatch = criteriaToMatch[0];
			}
			for (int c=1;c<criteriaToMatch.length();c++)
			{
				if ( ! propertyMatch) break;
				propertyMatch = propertyMatch && criteriaToMatch[c];
			}
		}
		if (exclude && propertyMatch)
			continue;
		if (include && !propertyMatch)
			continue;

		resultingGenBeams.append(gBm);
	}
	
	_Map.setEntityArray(resultingGenBeams, true, "GenBeams", "GenBeams", "GenBeam");

	if (manualInsert)
	{
		reportMessage(resultingGenBeams);
		eraseInstance();	
	}
	return;
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
  <lst nm="TslInfo">
    <lst nm="TSLINFO">
      <lst nm="TSLINFO">
        <lst nm="TSLINFO" />
      </lst>
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End