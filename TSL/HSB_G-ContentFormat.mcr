#Version 8
#BeginDescription
This tsl formats a string and checks the value


1.13 23/03/2022 Do formatobject on complete string. Author: Robert Pol
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 13
#KeyWords 
#BeginContents
// constants //region
/// <summary Lang=en>
/// Description
/// </summary>

/// <insert>
/// Specify insert
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.11" date="14-02-2019"></version>

/// <history>
/// RP - 1.00 - 04-11-2017 -  Pilot version.
/// RP - 1.01 - 11-11-2017 -  Get token for beamcode if element is ELEMENTWALLSF
/// RP - 1.02 - 14-11-2017 -  Add zone
/// RP - 1.03 - 07-02-2018 -  Add tsl props and check information and sublabel already set
/// RP - 1.04 - 05-03-2018 -  Trim tsl props with whitespaces
/// TH - 1.05 - 17-04-2018 -  translation issue fixed
/// RP - 1.06 - 13-06-2018 -  Add blockrefs and analysedtools of toolent
/// RP - 1.07 - 21-08-2018 -  Mapx not shown in custom action
/// RP - 1.08 - 22-08-2018 -  Check if property ends with a "." (posnum on panel)
/// RP - 1.09 - 07-09-2018 -  Add Element props
/// RP - 1.10 - 08-10-2018 -  Add Weight for element
/// RP - 1.11 - 14-02-2019 -  If the variable cannot be found, use the formatobject function
// #Versions
//1.13 23/03/2022 Do formatobject on complete string. Author: Robert Pol
/// </history>
//endregion

U(1,"mm");	
double dEps =U(.1);
int nDoubleIndex, nStringIndex, nIntIndex;
String sDoubleClick= "TslDoubleClick";
int bDebug=_bOnDebug;
bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));	
String sDefault =T("|_Default|");
String sLastInserted =T("|_LastInserted|");	
String category = T("|General|");
String sNoYes[] = { T("|No|"), T("|Yes|")};
//endregion

PropString contentFormat(0,"@(Material)",T("|Content|"));
contentFormat.setCategory(category);
contentFormat.setDescription(T("|Each autocad entity has a set of automatic properties defined. One way to see a list of the automatic properties, is to go into the AecStyleManager -> DocumentationObjects -> PropertySetDefinition, and create a dummy PropertySetDefinition. Set it to work with a single object of the type that you want to investigate in the Applies to tab. Then go to the tab Definition, and try to add an automatic property. The full list is shown.With this function, the list of automatic properties is made available in TSL. Only int, double and string entries are recognized currently.|"));

PropString contentValue(2,"CLS",T("|Value|"));
contentFormat.setCategory(category);
contentFormat.setDescription(T("|Check if this value is present in the content string|") + TN("* |can be used as wildcard and| ") + T("; |as seperator|"));

// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if (_kExecuteKey != "" && catalogNames.find(_kExecuteKey) != -1) 
	setPropValuesFromCatalog(_kExecuteKey);
	
String arSTrigger[] = {
	T("|Show Available Properties|")
};
for( int i=0;i<arSTrigger.length();i++ )
{
	addRecalcTrigger(_kContext, arSTrigger[i] );
}

if (_bOnInsert) {
	if (insertCycleCount() > 1) {
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || catalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	setCatalogFromPropValues(sLastInserted);
	Entity entity = getEntity();	

	_Map.setInt("ManualInsert", true);
	_Map.setString("FormatContent", contentFormat);
	_Map.setString("FormatValue", contentValue);
	_Map.setEntity("FormatEntity",entity);
	_Map.setInt("FormatValueFound",false);
	Point3d gripPoints[] = entity.gripPoints();
	_Pt0 = gripPoints[0];
	return;
}

int manualInsert = false;
if (_Map.hasInt("ManualInsert")) {
	manualInsert = _Map.getInt("ManualInsert");
	_Map.removeAt("ManualInsert", true);
}

if (manualInsert || _bOnMapIO || _bOnDebug) {

	Entity ent;
	String contentString = contentFormat;
	String values = contentValue;

 	if (_Map.hasEntity("FormatEntity"))
 	{
 		ent = _Map.getEntity("FormatEntity");
 	}
 	if (_Map.hasString("FormatContent") && _Map.getString("FormatContent").length() > 0)
 	{
 		contentString = _Map.getString("FormatContent");
 	}
 	if (_Map.hasString("FormatValue"))
 	{
 		values = _Map.getString("FormatValue");
 	}
	
	if (!ent.bIsValid())
	{
		reportNotice(T("|Entity not valid|"));
		eraseInstance();
		return;
	}
		
	String attachedPropSetNames[] = ent.attachedPropSetNames();

	String resultingString;
	String token = "@(";
	String tokenizedString[] = contentString.tokenize(token);
	 
	for (int s = 0; s < tokenizedString.length(); s++)
	{
		String string = tokenizedString[s];
		Map allPropsMap;		
		if (string.find(")", 0) != -1)
		{
			String propSetAndProp = string.token(0, ")");
			String leftOver = string;
			leftOver.delete(leftOver.find("@", 0), leftOver.token(0, ")").length() +1);
			int nIndex =0;
			int found =1;

			String property;
			if (propSetAndProp.find(".", 0) != -1 && propSetAndProp.trimRight().right(1) != ".")
			{
				String propSet = propSetAndProp.token(0, ".");
				property = propSetAndProp.token(1, ".");
				Map propSetMap = ent.getAttachedPropSetMap(propSet);
				if (propSetMap.length() > 0)
					allPropsMap.appendMap("PropSet", propSetMap);
					
				Map mapX = ent.subMapX(propSet); 
				if (mapX.length() > 0)
					allPropsMap.appendMap("MapX", mapX);
					
				Map subMap = ent.subMap(propSet); 
				if (subMap.length() > 0)
					allPropsMap.appendMap("SubMap", subMap);				
					
				Map mapProject =  subMapXProject(propSetMap);
				mapProject.setString(T("|dwgName|"), dwgName()); // returns the name of the dwg file, without the file path, and without the extension
				mapProject.setString(T("|dwgFullName|"), dwgFullName()); // returns the full file path
				mapProject.setInt(T("|arxVersion|"), arxVersion()); // returns the autocad arx version as an int: 2004, 2005,...
				mapProject.setInt(T("|bits|"), bits()); // returns 32 or 64 depending on how the acad exe is running (added hsbCAD15.0.12)
				mapProject.setString(T("|hsbOEVersion|"), hsbOEVersion()); // returns the hsb version string that appears at the bottom of hsb_Settings, reporting the version.
				mapProject.setString(T("|projectName|"), projectName()); // returns the value set in the hsb_settings
				mapProject.setString(T("|projectNumber|"), projectNumber()); // returns the value set in the hsb_settings
				mapProject.setString(T("|projectStreet|"), projectStreet()); // returns the value set in the hsb_settings
				mapProject.setString(T("|projectCity|"), projectCity()); // returns the value set in the hsb_settings
				mapProject.setString(T("|projectComment|"), projectComment()); // returns the value set in the hsb_settings
				mapProject.setString(T("|projectUser|"), projectUser()); // returns the value set in the hsb_settings
				mapProject.setString(T("|projectRevision|"), projectRevision()); // returns the value set in the hsb_settings
				mapProject.setString(T("|projectSpecial|"), projectSpecial()); // returns the value set in the hsb_settings
				mapProject.setInt(T("|getTickCount|"), getTickCount()); // returns the number of milliseconds that have elapsed since the system was started, up to 49.7 days.

				if (mapProject.length() > 0)
					allPropsMap.appendMap("ProjectProps", mapProject);
			}
			else
			{
				property = propSetAndProp;
				Map autoPropertieMap = ent.getAutoPropertyMap();
				if (autoPropertieMap.length() > 0)
					allPropsMap.appendMap("AutoProps", autoPropertieMap);
				
				Map otherProperties;
				// get group data if selected
				String sGroupPropertyNames[] = {T("|GroupLevel1|"),T("|GroupLevel2|"), T("|GroupLevel3|"), T("|Zone|")};	
				Group groups[] = ent.groups();
				for (int g = 0; g < groups.length(); g++)
				{
					Group group = groups[g];
					String sNamePart1 = group.namePart(sGroupPropertyNames.find(sGroupPropertyNames[0]));
					otherProperties.setString(sGroupPropertyNames[0], sNamePart1);
					String sNamePart2 = group.namePart(sGroupPropertyNames.find(sGroupPropertyNames[1]));
					otherProperties.setString(sGroupPropertyNames[1], sNamePart2);
					String sNamePart3 = group.namePart(sGroupPropertyNames.find(sGroupPropertyNames[2]));
					otherProperties.setString(sGroupPropertyNames[2], sNamePart3);
				}
				int zone = ent.myZoneIndex();
				otherProperties.setInt(sGroupPropertyNames[3], zone);
			
				if (ent.bIsKindOf(MasterPanel()))
				{
					MasterPanel master = (MasterPanel)ent;
					String props[] = {T("|Position Number|"), T("|Information|"), T("|Thickness|"), T("|Name|")};
					otherProperties.setString(props[0], master.number());
					otherProperties.setString(props[1], master.information());
					otherProperties.setString(props[2], master.dThickness());
					otherProperties.setString(props[3], master.name());
				}
				else if (ent.bIsKindOf(GenBeam()))
				{
					GenBeam genBeam = (GenBeam)ent;
					String props[] = {T("|Beamcode|"), T("|Information|"), T("|SubLabel2|"), T("|SolidLength|"), T("|Isotropic|"), T("|SolidHeight|"), T("|SolidWidth|")};
					if (genBeam.element().bIsKindOf(ElementWallSF()))
						otherProperties.setString(props[0], genBeam.beamCode().token(0, ";"));
					else
						otherProperties.setString(props[0], genBeam.beamCode());
					if (! autoPropertieMap.hasString(props[1])) otherProperties.setString(props[1], genBeam.information());
					if (! autoPropertieMap.hasString(props[2])) otherProperties.setString(props[2], genBeam.subLabel2());
					otherProperties.setString(props[3], genBeam.solidLength());
					otherProperties.setString(props[4], genBeam.isotropic());
					otherProperties.setString(props[5], genBeam.solidHeight());
					otherProperties.setString(props[6], genBeam.solidWidth());
				}
				else if (ent.bIsKindOf(ToolEnt()))
				{
					ToolEnt toolEnt = (ToolEnt)ent;
					GenBeam genBeams[] = toolEnt.genBeam();
					AnalysedTool analysedTools[0];
					for (int index=0;index<genBeams.length();index++) 
					{ 
						GenBeam genBeam = genBeams[index]; 
						AnalysedTool genBeamAnalysedTools[] = genBeam.analysedTools();
						analysedTools.append(genBeamAnalysedTools);
					}
					
					for (int index=0;index<analysedTools.length();index++) 
					{ 
						AnalysedTool analysedTool = analysedTools[index]; 
						if (analysedTool.toolEnt() != toolEnt) continue;
						
						Map internalMap = analysedTool.mapInternal();
						allPropsMap.appendMap("ToolProps", internalMap);
					}
						
				}
				else if (ent.bIsKindOf(BlockRef()))
				{
					BlockRef blockRef = (BlockRef)ent;
					
					String props[] = {T("|Scale X|"), T("|Scale Y|"), T("|Scale Z|"), T("|Name|")};
					otherProperties.setDouble(props[0], blockRef.dScaleX());
					otherProperties.setDouble(props[1], blockRef.dScaleY());
					otherProperties.setDouble(props[2], blockRef.dScaleZ());
					otherProperties.setString(props[3], blockRef.definition());
					
					Map attributeMap = blockRef.getAttributeMap();
					allPropsMap.appendMap("AttributeProps", attributeMap);
					
					if (blockRef.bIsDynamic())
					{
						Map dynamicAttributesMap = blockRef.getDynBlockPropertyMap(true, false);
						allPropsMap.appendMap("DynamicProps", dynamicAttributesMap);
					}
				}
				else if (ent.bIsKindOf(Element()))
				{
					Element el = (Element)ent;
					String props[] = { T("|Beam Width|"), T("|Beam Height|"), T("|Beam Extrusion Profile|"), T("|Number|"), T("|Code|"), T("|Defenition|"), T("|Information|"), T("|Subtype|"), T("|Quantity|"), T("|Lock|"), T("|Floorgroup Height|"), T("|Element Group|"), T("|Weight|")};
					otherProperties.setDouble(props[0], el.dBeamWidth());
					otherProperties.setDouble(props[1], el.dBeamHeight());
					otherProperties.setString(props[2], el.beamExtrProfile());
					otherProperties.setString(props[3], el.number());	
					otherProperties.setString(props[4], el.code());
					otherProperties.setString(props[5], el.definition());
					otherProperties.setString(props[6], el.information());
					otherProperties.setString(props[7], el.subType());	
					otherProperties.setInt(props[8], el.quantity());
					otherProperties.setInt(props[9], el.lock());
					otherProperties.setDouble(props[10], el.dFloorGroupHeight());
					otherProperties.setString(props[11], el.elementGroup());
					Map mapIO;
					Map mapEntities;
					Entity elementEntities[] = el.elementGroup().collectEntities(false, Entity(), _kModelSpace);
					for (int ee=0;ee<elementEntities.length();ee++) 
					{ 
						Entity elementEntity = elementEntities[ee]; 
						mapEntities.appendEntity("Entity", elementEntity); 
					}
					
					mapIO.setMap("Entity[]",mapEntities);
					TslInst().callMapIO("hsbCenterOfGravity", mapIO);
					otherProperties.setDouble(props[12], mapIO.getDouble("Weight"));
					
					if (ent.bIsKindOf(ElementRoof()))
					{
						ElementRoof elRoof = (ElementRoof)ent;
						String propsRoof[] = {T("|Beam Distribution|"), T("|Beam Spacing|"), T("|Beam Direction|"), T("|Reference Height|"), T("|Is Purlin|"), T("|Insulation|"), T("|Is A Floor|")};
						otherProperties.setString(propsRoof[0], elRoof.beamDistribution());
						otherProperties.setDouble(propsRoof[1], elRoof.dBeamSpacing());
						otherProperties.setDouble(propsRoof[2], elRoof.dBeamDirection());
						otherProperties.setDouble(propsRoof[3], elRoof.dReferenceHeight());	
						otherProperties.setInt(propsRoof[4], elRoof.bPurlin());
						otherProperties.setString(propsRoof[5], elRoof.insulation());
						otherProperties.setInt(propsRoof[6], elRoof.bIsAFloor());					
					}
					else if (ent.bIsKindOf(ElementWall()))
					{
						ElementWall elWall = (ElementWall)ent;
						String props[] = {T("|Exposed|")};
						otherProperties.setString(props[0], elWall.exposed());	
						
						if (ent.bIsKindOf(ElementWallSF()))
						{
							ElementWallSF elWallSF = (ElementWallSF)ent;
							String propsWallSF[] = {T("|Spacing Beam|"), T("|Delta Distribution|"), T("|ForceLevel Detail|"), T("|Distribution Type|"), T("|Distribution Zone|"), T("|Loadbearing|")};
							otherProperties.setDouble(propsWallSF[0], elWallSF.spacingBeam());
							otherProperties.setDouble(propsWallSF[1], elWallSF.deltaDistribution());
							otherProperties.setInt(propsWallSF[2], elWallSF.forceLevelDetail());
							otherProperties.setInt(propsWallSF[3], elWallSF.distributionType());	
							otherProperties.setInt(propsWallSF[4], elWallSF.distributionZone());
							otherProperties.setInt(propsWallSF[5], elWallSF.loadBearing());
						}
					}
				}
				else if (ent.bIsKindOf(TslInst()))
				{
					TslInst tsl = (TslInst)ent;
					String tslProperties[] = tsl.getListOfPropNames();
					Map tslProps; 
					
					for (int i=0;i<tslProperties.length();i++) 
					{ 
						String tslProp = tslProperties[i];
						String trimmedProp = tslProp;
						trimmedProp.trimLeft();
						trimmedProp.trimRight();
						
						if (tsl.hasPropInt(tslProp))
						{
							tslProps.setInt(trimmedProp, tsl.propInt(tslProp));
						}
						else if (tsl.hasPropDouble(tslProp))
						{
							tslProps.setDouble(trimmedProp, tsl.propDouble(tslProp));
						}
						else if (tsl.hasPropString(tslProp))
						{
							tslProps.setString(trimmedProp, tsl.propString(tslProp));
						}
					}
					
					String props[] = {T("|Posnum|"), T("|Version|"), T("|ScriptName|"), T("|OpmName|"), T("|SequenceNumber|"), T("|Originator|"), T("|ModelDescription|"), T("|MaterialDescription|"), T("|AdditionalNotes|"), T("|AllowGripAtPt0|")};
					tslProps.setString(props[0], tsl.posnum());
					tslProps.setString(props[1], tsl.version());
					tslProps.setString(props[2], tsl.scriptName());
					tslProps.setString(props[3], tsl.opmName());
					tslProps.setString(props[4], tsl.sequenceNumber());
					tslProps.setString(props[5], tsl.originator());
					tslProps.setString(props[6], tsl.modelDescription());
					tslProps.setString(props[7], tsl.materialDescription());
					tslProps.setString(props[8], tsl.additionalNotes());
					tslProps.setString(props[9], tsl.allowGripAtPt0());
					
					allPropsMap.appendMap("tslProps", tslProps);
				}
				
				
				if (otherProperties.length() > 0)
					allPropsMap.appendMap("OtherProps", otherProperties);
					
	
				
				Map mapProject;
				mapProject.setString(T("|dwgName|"), dwgName()); // returns the name of the dwg file, without the file path, and without the extension
				mapProject.setString(T("|dwgFullName|"), dwgFullName()); // returns the full file path
				mapProject.setInt(T("|arxVersion|"), arxVersion()); // returns the autocad arx version as an int: 2004, 2005,...
				mapProject.setInt(T("|bits|"), bits()); // returns 32 or 64 depending on how the acad exe is running (added hsbCAD15.0.12)
				mapProject.setString(T("|hsbOEVersion|"), hsbOEVersion()); // returns the hsb version string that appears at the bottom of hsb_Settings, reporting the version.
				mapProject.setString(T("|projectName|"), projectName()); // returns the value set in the hsb_settings
				mapProject.setString(T("|projectNumber|"), projectNumber()); // returns the value set in the hsb_settings
				mapProject.setString(T("|projectStreet|"), projectStreet()); // returns the value set in the hsb_settings
				mapProject.setString(T("|projectCity|"), projectCity()); // returns the value set in the hsb_settings
				mapProject.setString(T("|projectComment|"), projectComment()); // returns the value set in the hsb_settings
				mapProject.setString(T("|projectUser|"), projectUser()); // returns the value set in the hsb_settings
				mapProject.setString(T("|projectRevision|"), projectRevision()); // returns the value set in the hsb_settings
				mapProject.setString(T("|projectSpecial|"), projectSpecial()); // returns the value set in the hsb_settings
				mapProject.setInt(T("|getTickCount|"), getTickCount()); // returns the number of milliseconds that have elapsed since the system was started, up to 49.7 days.

				if (mapProject.length() > 0)
					allPropsMap.appendMap("ProjectProps", mapProject);
			}
			
			int propertyFound = false;
			for (int m = 0; m < allPropsMap.length(); m++)
			{
				Map mapProp = allPropsMap.getMap(m);
					
				int index = mapProp.indexAt(property);
				
				if (mapProp.hasInt(index))
				{
					resultingString += mapProp.getInt(index);
					propertyFound = true;
				}
				
				else if (mapProp.hasDouble(index))
				{
					resultingString += String().formatUnit(mapProp.getDouble(index), 2, 0);
					propertyFound = true;
				}
				
				else if (mapProp.hasString(index))
				{
					resultingString += mapProp.getString(index);
					propertyFound = true;
				}
			}
			if (!propertyFound)
			{
				resultingString += ent.formatObject("@("+propSetAndProp+")"); 	
			}
				 
			resultingString += leftOver;
		}
		else
		{
			resultingString += string;
		}
	
	}

	//check if value is found
	int matchingProperty = false;
	String tokenizedValues[] = values.tokenize(";");

	for ( int f = 0; f < tokenizedValues.length(); f++)
	{
		String filter = tokenizedValues[f];
		String filterTrimmed = filter;
		filterTrimmed.trimLeft("*");
		filterTrimmed.trimRight("*");
		if (filterTrimmed == resultingString)
		{
			matchingProperty = true;
			continue;
		}
		if ( filterTrimmed == "" )
		{
			if ( filter == "*" && resultingString != "" )
				matchingProperty = true;
			else
				continue;
		}
		else
		{
			if ( filter.left(1) == "*" && filter.right(1) == "*" && resultingString.find(filterTrimmed, 0) != -1 )
				matchingProperty = true;
			else if ( filter.left(1) == "*" && resultingString.right(filter.length() - 1) == filterTrimmed )
				matchingProperty = true;
			else if ( filter.right(1) == "*" && resultingString.left(filter.length() - 1) == filterTrimmed )
				matchingProperty = true;
		}
		
	}
	
	_Map.setString("FormatContent", resultingString);
	_Map.setInt("FormatValueFound", matchingProperty);

	 if (manualInsert)
	 {
		reportMessage(TN(resultingString) + TN(matchingProperty));
//	 	eraseInstance();
	 }
	 
}

if (_kExecuteKey == arSTrigger[0] || _bOnDebug)
 {	
 	Entity ent;
	String contentString = contentFormat;


 	ent = _Map.getEntity("FormatEntity");
 	contentString = _Map.getString("FormatString");

	Point3d gripPoints[] = ent.gripPoints();
	_Pt0 = gripPoints[0];
	
	if (!ent.bIsValid())
	{
		reportNotice(T("|Entity not valid|"));
		eraseInstance();
		return;
	}
	
 	Map allAvailablePropsMap;
	Map autoPropertieMap = ent.getAutoPropertyMap();
	if (autoPropertieMap.length() > 0)
	{
		allAvailablePropsMap.appendMap("AutoProps", autoPropertieMap);
		reportNotice("\n" + TN("|AutoProps|") + ":" + TN(autoPropertieMap) + TN("|e.g. :| ") + "@(" + autoPropertieMap.keyAt(0) + ")");
	}
	
	Map otherProperties;
	// get group data if selected
	String sGroupPropertyNames[] = {T("|GroupLevel1|"),T("|GroupLevel2|"), T("|GroupLevel3|"), T("|Zone|")};	
	Group groups[] = ent.groups();
	for (int g = 0; g < groups.length(); g++)
	{
		Group group = groups[g];
		String sNamePart1 = group.namePart(sGroupPropertyNames.find(sGroupPropertyNames[0]));
		otherProperties.setString(sGroupPropertyNames[0], sNamePart1);
		String sNamePart2 = group.namePart(sGroupPropertyNames.find(sGroupPropertyNames[1]));
		otherProperties.setString(sGroupPropertyNames[1], sNamePart2);
		String sNamePart3 = group.namePart(sGroupPropertyNames.find(sGroupPropertyNames[2]));
		otherProperties.setString(sGroupPropertyNames[2], sNamePart3);
	}
	int zone = ent.myZoneIndex();
	otherProperties.setInt(sGroupPropertyNames[3], zone);

	if (ent.bIsKindOf(MasterPanel()))
	{
		MasterPanel master = (MasterPanel)ent;
		String props[] = {T("|Position Number|"), T("|Information|"), T("|Thickness|"), T("|Name|")};
		otherProperties.setString(props[0], master.number());
		otherProperties.setString(props[1], master.information());
		otherProperties.setString(props[2], master.dThickness());
		otherProperties.setString(props[3], master.name());
	}
	else if (ent.bIsKindOf(GenBeam()))
	{
		GenBeam genBeam = (GenBeam)ent;
		String props[] = {T("|Beamcode|"), T("|Information|"), T("|SubLabel2|"), T("|SolidLength|"), T("|Isotropic|"), T("|SolidHeight|"), T("|SolidWidth|")};
		otherProperties.setString(props[0], genBeam.beamCode());
		otherProperties.setString(props[1], genBeam.information());
		otherProperties.setString(props[2], genBeam.subLabel2());
		otherProperties.setString(props[3], genBeam.solidLength());
		otherProperties.setString(props[4], genBeam.isotropic());
		otherProperties.setString(props[5], genBeam.solidHeight());
		otherProperties.setString(props[6], genBeam.solidWidth());
	}
	else if (ent.bIsKindOf(ToolEnt()))
	{
		ToolEnt toolEnt = (ToolEnt)ent;
		GenBeam genBeams[] = toolEnt.genBeam();
		AnalysedTool analysedTools[0];
		for (int index=0;index<genBeams.length();index++) 
		{ 
			GenBeam genBeam = genBeams[index]; 
			AnalysedTool genBeamAnalysedTools[] = genBeam.analysedTools();
			analysedTools.append(genBeamAnalysedTools);
		}
		
		for (int index=0;index<analysedTools.length();index++) 
		{ 
			AnalysedTool analysedTool = analysedTools[index]; 
			if (analysedTool.toolEnt() != toolEnt) continue;
			
			Map internalMap = analysedTool.mapInternal();
			allAvailablePropsMap.appendMap("ToolProps", internalMap);
			 reportNotice("\n" + TN("|ToolProps|") + ":" + TN(internalMap) + TN("|e.g. :| ") + "@(" + internalMap.keyAt(0) + ")");
		}
			
	}
	else if (ent.bIsKindOf(BlockRef()))
	{
		BlockRef blockRef = (BlockRef)ent;
		
		String props[] = {T("|Scale X|"), T("|Scale Y|"), T("|Scale Z|"), T("|Name|")};
		otherProperties.setDouble(props[0], blockRef.dScaleX());
		otherProperties.setDouble(props[1], blockRef.dScaleY());
		otherProperties.setDouble(props[2], blockRef.dScaleZ());
		otherProperties.setString(props[3], blockRef.definition());
		
		Map attributeMap = blockRef.getAttributeMap();
		allAvailablePropsMap.appendMap("AttributeProps", attributeMap);
		reportNotice("\n" + TN("|AttributeProps|") + ":" + TN(attributeMap) + TN("|e.g. :| ") + "@(" + attributeMap.keyAt(0) + ")");
		
		if (blockRef.bIsDynamic())
		{
			Map dynamicAttributesMap = blockRef.getDynBlockPropertyMap(true, false);
			allAvailablePropsMap.appendMap("DynamicProps", dynamicAttributesMap);
			reportNotice("\n" + TN("|DynamicProps|") + ":" + TN(dynamicAttributesMap) + TN("|e.g. :| ") + "@(" + dynamicAttributesMap.keyAt(0) + ")");
		}
	}	
	else if (ent.bIsKindOf(Element()))
	{
		Element el = (Element)ent;
		String props[] = { T("|Beam Width|"), T("|Beam Height|"), T("|Beam Extrusion Profile|"), T("|Number|"), T("|Code|"), T("|Defenition|"), T("|Information|"), T("|Subtype|"), T("|Quantity|"), T("|Lock|"), T("|Floorgroup Height|"), T("|Element Group|"), T("|Weight|")};
		otherProperties.setDouble(props[0], el.dBeamWidth());
		otherProperties.setDouble(props[1], el.dBeamHeight());
		otherProperties.setString(props[2], el.beamExtrProfile());
		otherProperties.setString(props[3], el.number());	
		otherProperties.setString(props[4], el.code());
		otherProperties.setString(props[5], el.definition());
		otherProperties.setString(props[6], el.information());
		otherProperties.setString(props[7], el.subType());	
		otherProperties.setInt(props[8], el.quantity());
		otherProperties.setInt(props[9], el.lock());
		otherProperties.setDouble(props[10], el.dFloorGroupHeight());
		otherProperties.setString(props[11], el.elementGroup());
		Map mapIO;
		Map mapEntities;
		Entity elementEntities[] = el.elementGroup().collectEntities(false, Entity(), _kModelSpace);
		for (int ee=0;ee<elementEntities.length();ee++) 
		{ 
			Entity elementEntity = elementEntities[ee]; 
			mapEntities.appendEntity("Entity", elementEntity); 
		}
		
		mapIO.setMap("Entity[]",mapEntities);
		TslInst().callMapIO("hsbCenterOfGravity", mapIO);
		otherProperties.setDouble(props[12], mapIO.getDouble("Weight"));
		
		if (ent.bIsKindOf(ElementRoof()))
		{
			ElementRoof elRoof = (ElementRoof)ent;
			String propsRoof[] = {T("|Beam Distribution|"), T("|Beam Spacing|"), T("|Beam Direction|"), T("|Reference Height|"), T("|Is Purlin|"), T("|Insulation|"), T("|Is A Floor|")};
			otherProperties.setString(propsRoof[0], elRoof.beamDistribution());
			otherProperties.setDouble(propsRoof[1], elRoof.dBeamSpacing());
			otherProperties.setDouble(propsRoof[2], elRoof.dBeamDirection());
			otherProperties.setDouble(propsRoof[3], elRoof.dReferenceHeight());	
			otherProperties.setInt(propsRoof[4], elRoof.bPurlin());
			otherProperties.setString(propsRoof[5], elRoof.insulation());
			otherProperties.setInt(propsRoof[6], elRoof.bIsAFloor());					
		}
		else if (ent.bIsKindOf(ElementWall()))
		{
			ElementWall elWall = (ElementWall)ent;
			String props[] = {T("|Exposed|")};
			otherProperties.setString(props[0], elWall.exposed());	
			
			if (ent.bIsKindOf(ElementWallSF()))
			{
				ElementWallSF elWallSF = (ElementWallSF)ent;
				String propsWallSF[] = {T("|Spacing Beam|"), T("|Delta Distribution|"), T("|ForceLevel Detail|"), T("|Distribution Type|"), T("|Distribution Zone|"), T("|Loadbearing|")};
				otherProperties.setDouble(propsWallSF[0], elWallSF.spacingBeam());
				otherProperties.setDouble(propsWallSF[1], elWallSF.deltaDistribution());
				otherProperties.setInt(propsWallSF[2], elWallSF.forceLevelDetail());
				otherProperties.setInt(propsWallSF[3], elWallSF.distributionType());	
				otherProperties.setInt(propsWallSF[4], elWallSF.distributionZone());
				otherProperties.setInt(propsWallSF[5], elWallSF.loadBearing());
			}
		}
	}
	else if (ent.bIsKindOf(TslInst()))
	{
		TslInst tsl = (TslInst)ent;
		String tslProperties[] = tsl.getListOfPropNames();
		Map tslProps; 
		
		for (int i=0;i<tslProperties.length();i++) 
		{ 
			String tslProp = tslProperties[i];
			String trimmedProp = tslProp;
			trimmedProp.trimLeft();
			trimmedProp.trimRight();
			
			if (tsl.hasPropInt(tslProp))
			{
				tslProps.setInt(trimmedProp, tsl.propInt(tslProp));
			}
			else if (tsl.hasPropDouble(tslProp))
			{
				tslProps.setDouble(trimmedProp, tsl.propDouble(tslProp));
			}
			else if (tsl.hasPropString(tslProp))
			{
				tslProps.setString(trimmedProp, tsl.propString(tslProp));
			}
			
		}
		
		String props[] = {T("|Posnum|"), T("|Version|"), T("|ScriptName|"), T("|OpmName|"), T("|SequenceNumber|"), T("|Originator|"), T("|ModelDescription|"), T("|MaterialDescription|"), T("|AdditionalNotes|"), T("|AllowGripAtPt0|")};
		tslProps.setString(props[0], tsl.posnum());
		tslProps.setString(props[1], tsl.version());
		tslProps.setString(props[2], tsl.scriptName());
		tslProps.setString(props[3], tsl.opmName());
		tslProps.setString(props[4], tsl.sequenceNumber());
		tslProps.setString(props[5], tsl.originator());
		tslProps.setString(props[6], tsl.modelDescription());
		tslProps.setString(props[7], tsl.materialDescription());
		tslProps.setString(props[8], tsl.additionalNotes());
		tslProps.setString(props[9], tsl.allowGripAtPt0());
		
		allAvailablePropsMap.appendMap("tslProps", tslProps);
		reportNotice("\n" + TN("|tslProps|") + ":" + TN(tslProps) + TN("|e.g. :|") + "@(" + tslProps.keyAt(0) + ")");
	}	
	
	if (otherProperties.length() > 0)
	{
		allAvailablePropsMap.appendMap("OtherProps", otherProperties);
		 reportNotice("\n" + TN("|OtherProps|") + ":" + TN(otherProperties) + TN("|e.g. :| ") + "@(" + otherProperties.keyAt(0) + ")");
	}
				
	Map mapProject;
	String subMapXKeysProject[] = subMapXKeysProject();
	for (int i =0;i<subMapXKeysProject.length();i++)
	{
		Map subMapXProject = subMapXProject(subMapXKeysProject[i]);
		if (subMapXProject.length() >0)
			{
				mapProject.appendMap("MapXProject", subMapXProject);
				 reportNotice("\n" + TN(subMapXKeysProject[i]) + ":" + TN(subMapXProject) + TN("|e.g. :| ") + "@(" + subMapXKeysProject[i] + "." + subMapXProject.keyAt(0) + ")");
			}
	}
	mapProject.setString(T("|dwgName|"), dwgName()); // returns the name of the dwg file, without the file path, and without the extension
	mapProject.setString(T("|dwgFullName|"), dwgFullName()); // returns the full file path
	mapProject.setInt(T("|arxVersion|"), arxVersion()); // returns the autocad arx version as an int: 2004, 2005,...
	mapProject.setInt(T("|bits|"), bits()); // returns 32 or 64 depending on how the acad exe is running (added hsbCAD15.0.12)
	mapProject.setString(T("|hsbOEVersion|"), hsbOEVersion()); // returns the hsb version string that appears at the bottom of hsb_Settings, reporting the version.
	mapProject.setString(T("|projectName|"), projectName()); // returns the value set in the hsb_settings
	mapProject.setString(T("|projectNumber|"), projectNumber()); // returns the value set in the hsb_settings
	mapProject.setString(T("|projectStreet|"), projectStreet()); // returns the value set in the hsb_settings
	mapProject.setString(T("|projectCity|"), projectCity()); // returns the value set in the hsb_settings
	mapProject.setString(T("|projectComment|"), projectComment()); // returns the value set in the hsb_settings
	mapProject.setString(T("|projectUser|"), projectUser()); // returns the value set in the hsb_settings
	mapProject.setString(T("|projectRevision|"), projectRevision()); // returns the value set in the hsb_settings
	mapProject.setString(T("|projectSpecial|"), projectSpecial()); // returns the value set in the hsb_settings
	mapProject.setInt(T("|getTickCount|"), getTickCount()); // returns the number of milliseconds that have elapsed since the system was started, up to 49.7 days.

	if (mapProject.length() > 0)
		{
			allAvailablePropsMap.appendMap("ProjectProp[]", mapProject);
			reportNotice("\n" + TN("ProjectProp[]") + ":" + TN(mapProject) + TN("|e.g. :| ") + "@(" + mapProject.keyAt(0) + ")");
		}
		
	String attachedPropSets[] = ent.attachedPropSetNames();
	Map propSets;
	for (int i =0;i<attachedPropSets.length();i++)
	{
		Map attachedPropSet = ent.getAttachedPropSetMap(attachedPropSets[i]);
		if (attachedPropSet.length() >0)
		{
			propSets.appendMap("PropSet", attachedPropSet);
			reportNotice("\n" + TN(attachedPropSets[i]) + ":" + TN(attachedPropSet) + TN("|e.g. :| ") + "@(" + attachedPropSets[i] + "." + attachedPropSet.keyAt(0) + ")");
		}
	}
	if (propSets.length() >0)
		allAvailablePropsMap.appendMap("PropSet[]", propSets);
	
	Map subMapX;
	String subMapXKeys[] = ent.subMapXKeys();
	for (int i =0;i<subMapXKeys.length();i++)
	{
		Map subMapXKey = ent.subMapX(subMapXKeys[i]);
		if (subMapXKey.length() >0)
		{
			subMapX.appendMap("MapX", subMapXKey);
			reportNotice("\n" + TN(subMapXKeys[i]) + ":" + TN(subMapXKey) + TN("|e.g. :| ") + "@(" + subMapXKeys[i] + "." + subMapXKey.keyAt(0) + ")");
		}
	}
	if (subMapX.length() >0)
		allAvailablePropsMap.appendMap("MapX[]", subMapX);	
		
	Map subMap;
	String subMapKeys[] = ent.subMapKeys();
	for (int i =0;i<subMapKeys.length();i++)
	{
		Map subMapKey = ent.subMap(subMapKeys[i]);
		if (subMapKey.length() >0)
		{
			subMap.appendMap("SubMap", subMapKey);
			reportNotice("\n" + TN(subMapKeys[i]) + ":" + TN(subMapKey) + TN("|e.g. :| ") + "@(" + subMapKeys[i] + "." + subMapKey.keyAt(0) + ")");
		}
	}
	if (subMap.length() >0)
		allAvailablePropsMap.appendMap("SubMap[]", subMap);
	
	Map formatObjectMap;
	String formatObjectKeys[] = ent.formatObjectVariables();
	reportNotice("\n" + TN("formatObjectProps[]") + ":" + "\n");
	
	for (int i =0;i<formatObjectKeys.length();i++)
	{
		reportNotice(T(formatObjectKeys[i]) + "," );
		
	}
	reportNotice(TN("|e.g. :| ") + "@(" + formatObjectKeys[0] + ")");
	if (subMap.length() >0)
		allAvailablePropsMap.appendMap("SubMap[]", subMap);
 	
 }
 return;


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
        <int nm="BreakPoint" vl="415" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Do formatobject on complete string." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="13" />
      <str nm="Date" vl="3/23/2022 9:45:15 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="If formatobject fails to translate, return empty." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="12" />
      <str nm="Date" vl="3/20/2022 7:33:02 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End