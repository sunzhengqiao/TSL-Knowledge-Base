#Version 8
#BeginDescription
Last modified by: Robert Pol (robert.pol@hsbcad.com)
25.05.2018 -  version 1.02

This tsl attaches additional information to entities. The information is attached through a property set and will be available in the IFC export.
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
/// This tsl attaches additional information to entities. The information is attached through a property set and will be available in the IFC export.
/// </summary>

/// <insert>
/// 
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.01" date="02.06.2015"></version>

/// <history>
/// AS - 1.00 - 22.05.2015 -	First revision
/// AS - 1.01 - 02.06.2015 -	Add description and revision history.
/// RP - 1.02 - 25.05.2018 -	Change default propertyset to the set added through the IFCEXPORT command
/// </history>

if (_bOnInsert) {
	if (insertCycleCount() >1) {
		eraseInstance();
		return;
	}
	
	PrEntity ssE(T("|Select one or more entity|"), Entity());
	if (ssE.go())
		_Entity.append(ssE.set());
	
	return;
}

if (_Entity.length() == 0) {
	reportNotice(T("|No entity selected.|"));
	eraseInstance();
	return;
}

String propSetName = T("|hsbIFCGroupStructure|");
int propSetExists = (Entity().availablePropSetNames().find(propSetName) != -1);

for (int e=0;e<_Entity.length();e++) {
	Entity ent = _Entity[e];
	
	Map propSetDefinitionMap;
	
	Group groups[] = ent.groups();
	Group group;
	if (groups.length() > 0)
	{
		group = groups[0];
	}
	
	String elementNumber = T("|-|");
	if (ent.element().bIsValid())
	{
		elementNumber = ent.element().number();
	}
	propSetDefinitionMap.setString(T("Element"), elementNumber);
	
	String floorGroup = T("|-|");
	if (group.bExists())
	{
		floorGroup = group.namePart(1);
	}
	propSetDefinitionMap.setString(T("FloorGroup"), floorGroup);
	
	String houseGroup = T("|-|");
	if (group.bExists())
	{
		houseGroup = group.namePart(0);
	}
	propSetDefinitionMap.setString(T("HouseGroup"), houseGroup);
	
	int zoneIndex;
	if (ent.element().bIsValid())
	{
		zoneIndex = ent.myZoneIndex();
	}
	propSetDefinitionMap.setInt(T("ZoneIndex"), zoneIndex);
	
	if (!propSetExists)
	{
		propSetExists = Entity().createPropSetDefinition(propSetName, propSetDefinitionMap, true);
	}
	
	if (propSetExists)
	{
		int propertySetIsAttached = ent.attachPropSet(propSetName);
	}
	
	int propertiesAreSet = ent.setAttachedPropSetFromMap(propSetName, propSetDefinitionMap);
}

eraseInstance();
return;
	
#End
#BeginThumbnail
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
D<ME-;QR,_P!HDGF1TVM/YI$.UB1G[IRJ9PK<%=I[2BBD4?_9
`





#End
#BeginMapX

#End