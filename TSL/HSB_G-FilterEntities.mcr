#Version 8
#BeginDescription
Last modified by: Robert Pol (robert.pol@hsbcad.com)

12.09.2018  -  version 1.3
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl filters a set of enities
/// </summary>

/// <insert>
/// Select a set of beams
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.03" date="12.09.2018"></version>

/// <history>
/// RP - 1.00 - 23.11.2017 -Pilot version based on HSB_G-FilterGenbeams
/// RP - 1.01 - 01.05.2018 -Add any/all operator
/// RP - 1.02 - 08.05.2018 -Make upper on values
/// RP - 1.03 - 12.09.2018 - For loop was not using index but always the first in the list
/// </history>

// Filter options
String operations[] = {
	T("|Exclude|"),
	T("|Include|")
};

String all = T("|All|");
String any = T("|Any|");
String operators[] = 
{
	all,
	any
};

String categories[] = {
	T("|Operation|"),
	T("|Format Properties 1|"),
	T("|Format Properties 2|"),
	T("|Format Properties 3|"),
	T("|Format Properties 4|")
};

PropString operationFilter(0, operations, T("|Operation filter|"));
operationFilter.setCategory(categories[0]);
operationFilter.setDescription(T("|Include or exclude entities meeting the filter criteria.|"));

PropString operator(1, operators, T("|Operation comparison|"));
operator.setCategory(categories[0]);
operator.setDescription(T("|Specify if check needs to be done on all or any value.|"));

PropString propCustom1(2, "", T("|Custom Propertie 1|"));
propCustom1.setCategory(categories[1]);
propCustom1.setDescription(T("|Specify a custom propertie e.g. @(Material) or @(PropertySet.Property)|") + TN("|To check which properties are available on an entitie, use the custom action on the tsl HSB_G-ContentFormat|"));

PropString valueCustom1(3, "", T("|Custom Value 1|"));
valueCustom1.setCategory(categories[1]);
valueCustom1.setDescription(T("|Specify the value to check the custom property, * can be used as wildcard and as delimiter| ;"));

PropString propCustom2(4, "", T("|Custom Propertie 2|"));
propCustom2.setCategory(categories[2]);
propCustom2.setDescription(T("|Specify a custom propertie e.g. @(Material) or @(PropertySet.Property)|") + TN("|To check which properties are available on an entitie, use the custom action on the tsl HSB_G-ContentFormat|"));

PropString valueCustom2(5, "", T("|Custom Value 2|"));
valueCustom2.setCategory(categories[2]);
valueCustom2.setDescription(T("|Specify the value to check the custom property, * can be used as wildcard and as delimiter| ;"));

PropString propCustom3(6, "", T("|Custom Propertie 3|"));
propCustom3.setCategory(categories[3]);
propCustom3.setDescription(T("|Specify a custom propertie e.g. @(Material) or @(PropertySet.Property)|") + TN("|To check which properties are available on an entitie, use the custom action on the tsl HSB_G-ContentFormat|"));

PropString valueCustom3(7, "", T("|Custom Value 3|"));
valueCustom3.setCategory(categories[3]);
valueCustom3.setDescription(T("|Specify the value to check the custom property, * can be used as wildcard and as delimiter| ;"));

PropString propCustom4(8, "", T("|Custom Propertie 4|"));
propCustom4.setCategory(categories[4]);
propCustom4.setDescription(T("|Specify a custom propertie e.g. @(Material) or @(PropertySet.Property)|") + TN("|To check which properties are available on an entitie, use the custom action on the tsl HSB_G-ContentFormat|"));

PropString valueCustom4(9, "", T("|Custom Value 4|"));
valueCustom4.setCategory(categories[4]);
valueCustom4.setDescription(T("|Specify the value to check the custom property, * can be used as wildcard and as delimiter| ;"));

// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if (_kExecuteKey != "" && catalogNames.find(_kExecuteKey) != -1) 
	setPropValuesFromCatalog(_kExecuteKey);

if (_bOnInsert) {
	if (insertCycleCount() > 1) {
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || catalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	setCatalogFromPropValues(T("|_LastInserted|"));
	
	PrEntity entitySelection(T("|Select entities to filter|"), Entity());
	if (entitySelection.go()) {
		Entity entities[] = entitySelection.set();
		
		_Map.setEntityArray(entities, false, "Entity", "Entity", "Entity");
	}
	_Map.setInt("ManualInsert", true);

	return;
}

int manualInsert = false;
if (_Map.hasInt("ManualInsert")) {
	manualInsert = _Map.getInt("ManualInsert");
	_Map.removeAt("ManualInsert", true);
}

// Set properties found in _Map if the execute key is empty.
if (_kExecuteKey == "") {
	if (_Map.hasInt("Exclude")) {
		int exclude = _Map.getInt("Exclude");
		if (exclude)
			operationFilter.set(operations[0]);
		else
			operationFilter.set(operations[1]);
	}
	if (_Map.hasInt("Any")) {
	int any = _Map.getInt("Any");
		if (any)
			operator.set(operators[1]);
		else
			operator.set(operators[0]);
	}
	
	if ( _Map.hasString("Custom1[]"))
		propCustom1.set(_Map.getString("Custom1[]"));
	if ( _Map.hasString("Value1[]"))
		valueCustom1.set(_Map.getString("Value1[]"));
	if ( _Map.hasString("Custom2[]"))
		propCustom2.set(_Map.getString("Custom2[]"));
	if ( _Map.hasString("Value2[]"))
		valueCustom2.set(_Map.getString("Value2[]"));
	if ( _Map.hasString("Custom3[]"))
		propCustom3.set(_Map.getString("Custom3[]"));
	if ( _Map.hasString("Value3[]"))
		valueCustom3.set(_Map.getString("Value3[]"));
	if ( _Map.hasString("Custom4[]"))
		propCustom4.set(_Map.getString("Custom4[]"));
	if ( _Map.hasString("Value4[]"))
		valueCustom4.set(_Map.getString("Value4[]"));
}

int exclude = (operations.find(operationFilter) == 0);
int include = !exclude;
int caseSensitive = false;

String nonUpperCustomValues1[] = propCustom1.tokenize(";");
String nonUpperCustomValues2[] = propCustom2.tokenize(";");
String nonUpperCustomValues3[] = propCustom3.tokenize(";");
String nonUpperCustomValues4[] = propCustom4.tokenize(";");

String customValues1[0];
String customValues2[0];
String customValues3[0];
String customValues4[0];

if (! caseSensitive)
{
	for (int a=0;a<nonUpperCustomValues1.length();a++) 
	{ 
		String nonUpperCustomValue1= nonUpperCustomValues1[a]; 
		nonUpperCustomValue1.makeUpper(); 
		customValues1.append(nonUpperCustomValue1);
	}
	
	for (int b=0;b<nonUpperCustomValues2.length();b++) 
	{ 
		String nonUpperCustomValue2= nonUpperCustomValues2[b]; 
		nonUpperCustomValue2.makeUpper(); 
		customValues2.append(nonUpperCustomValue2);
	}
	
	for (int c;c<nonUpperCustomValues3.length();c++) 
	{ 
		String nonUpperCustomValue3= nonUpperCustomValues3[c]; 
		nonUpperCustomValue3.makeUpper(); 
		customValues3.append(nonUpperCustomValue3);
	}
	
	for (int d=0;d<nonUpperCustomValues4.length();d++) 
	{ 
		String nonUpperCustomValue4= nonUpperCustomValues4[d]; 
		nonUpperCustomValue4.makeUpper(); 
		customValues4.append(nonUpperCustomValue4);
	}
}


if (_bOnMapIO || manualInsert || _bOnDebug) {
//	reportNotice("\nMaterials: " + materials);

	Entity resultingEntities[0];
	Entity entities[] = _Map.getEntityArray("Entity", "Entity", "Entity");
	for (int e=0;e<entities.length();e++) {
		Entity ent = entities[e];
		if (!ent.bIsValid())
			continue;
		
		int matchingCustom1 = false;
		if (propCustom1.length() > 0)
		{ 
			Map contentFormatMap;
			contentFormatMap.setString("FormatContent", propCustom1);
			contentFormatMap.setString("FormatValue", valueCustom1);
			contentFormatMap.setEntity("FormatEntity", ent);
			int succeeded = TslInst().callMapIO("HSB_G-ContentFormat", "", contentFormatMap);
			if (!succeeded)
			{
				reportNotice(T("|Please make sure the tsl HSB_G-ContentFormat is loaded in the drawing|"));
			}
			
			matchingCustom1 = contentFormatMap.getInt("FormatValueFound");
		}
		
		int matchingCustom2 = false;
		if (propCustom2.length() > 0)
		{ 
			Map contentFormatMap;
			contentFormatMap.setString("FormatContent", propCustom2);
			contentFormatMap.setString("FormatValue", valueCustom2);
			contentFormatMap.setEntity("FormatEntity", ent);
			int succeeded = TslInst().callMapIO("HSB_G-ContentFormat", "", contentFormatMap);
			if (!succeeded)
			{
				reportNotice(T("|Please make sure the tsl HSB_G-ContentFormat is loaded in the drawing|"));
			}
			
			matchingCustom2 = contentFormatMap.getInt("FormatValueFound");
		}
		
		int matchingCustom3 = false;
		if (propCustom1.length() > 0)
		{ 
			Map contentFormatMap;
			contentFormatMap.setString("FormatContent", propCustom3);
			contentFormatMap.setString("FormatValue", valueCustom3);
			contentFormatMap.setEntity("FormatEntity", ent);
			int succeeded = TslInst().callMapIO("HSB_G-ContentFormat", "", contentFormatMap);
			if (!succeeded)
			{
				reportNotice(T("|Please make sure the tsl HSB_G-ContentFormat is loaded in the drawing|"));
			}
			
			matchingCustom3 = contentFormatMap.getInt("FormatValueFound");
		}
		
		int matchingCustom4 = false;
		if (propCustom1.length() > 0)
		{ 
			Map contentFormatMap;
			contentFormatMap.setString("FormatContent", propCustom4);
			contentFormatMap.setString("FormatValue", valueCustom4);
			contentFormatMap.setEntity("FormatEntity", ent);
			int succeeded = TslInst().callMapIO("HSB_G-ContentFormat", "", contentFormatMap);
			if (!succeeded)
			{
				reportNotice(T("|Please make sure the tsl HSB_G-ContentFormat is loaded in the drawing|"));
			}
			
			matchingCustom4 = contentFormatMap.getInt("FormatValueFound");
		}
		
		int propertyMatch = exclude;
		if (operator == any)
		{
			propertyMatch = matchingCustom1 || matchingCustom2 || matchingCustom3 || matchingCustom4;
		}
		else //operator == all
		{
			int criteriaToMatch[0];
			if (customValues1.length() > 0)
			{
				criteriaToMatch.append(matchingCustom1);
			}
			if (customValues2.length() > 0)
			{
				criteriaToMatch.append(matchingCustom2);
			}
			if (customValues3.length() > 0)
			{
				criteriaToMatch.append(matchingCustom3);
			}
			if (customValues4.length() > 0)
			{
				criteriaToMatch.append(matchingCustom4);
			}
		
			if (criteriaToMatch.length() > 0)
			{
				propertyMatch = criteriaToMatch[0];
			}
			else
			{
				resultingEntities.append(ent);
				continue;
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

		resultingEntities.append(ent);
	}
	
	_Map.setEntityArray(resultingEntities, true, "Entity", "Entity", "Entity");

	if (manualInsert)
	{
		reportMessage(resultingEntities);
		eraseInstance();
	}
	return;
}
#End
#BeginThumbnail




#End
#BeginMapX

#End