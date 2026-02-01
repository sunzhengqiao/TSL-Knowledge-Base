#Version 8
#BeginDescription
Last modified by: David Rueda (david.rueda@hsbcad.com)
21.06.2017 - version 1.00
Identifies what element is the owner of selected entity and how many other similar entities also belong to resulting element
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
//region History and versioning
/// <summary Lang=en>
/// Identifies what element is the owner of selected entity and how many other similar entities also belong to resulting element
/// </summary>

/// <insert>
/// Select entities(s)
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <history>
/// DR - 1.00 - 21.06.2017	- Release
/// </history>
//endregion

//region bOnInsert
if (_bOnInsert) 
{
	if (insertCycleCount() > 1)
	{
		eraseInstance();
		return;
	}
	
	String strScriptName = scriptName();
	Vector3d vecUcsX(1,0,0);
	Vector3d vecUcsY(0,1,0);
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	Beam lstBeams[0];
	Entity lstEntities[1];
	Map mapTsl;
	mapTsl.setInt("ManualInserted", true);
	
	//region Select element(s), clone instance per each one
	Entity  selectedEntities[0];
	PrEntity ssE(T("|Select entities|"), Entity());
	if (ssE.go())
		selectedEntities.append(ssE.set());
	
	for (int e=0;e<selectedEntities.length();e++)
	{
		Entity selectedElement = selectedEntities[e];
		if (!selectedElement.bIsValid())
			continue;
		
		lstEntities[0] = selectedElement;
		
		TslInst tslNew;
		tslNew.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
	}
	//endregion

	eraseInstance();
	return;
}
//endregion

if( _Entity.length()==0)
{
	eraseInstance();
	return;
}

Entity ent= _Entity[0];
if(!ent.bIsValid())
{ 
	reportMessage(TN("|Selected entity invalid|"));//aa 
	
}
String typeName= ent.typeName(), handle= ent.handle();
reportMessage(TN("|Entity type| ")+typeName+T(", |handle| ")+handle);

Element el= ent.element();
if(!el.bIsValid())
{
	reportMessage(TN("|Element could not be found|"));
	eraseInstance();
	return;
}
String codeAndNumber= el.code()+"-"+el.number();
if(codeAndNumber!="")
	reportMessage(T(", |owner element|: ")+codeAndNumber);
else
{
	reportMessage(T(", |owner element's code not found|"));
	eraseInstance();
	return;
}

// Collecting all entities at element's group
Group groups[]= el.groups();
Entity entitiesFromElementGroups[0];
for (int g=0;g<groups.length();g++)
{
	Group gr= groups[g];
	entitiesFromElementGroups.append(gr.collectEntities(true, Entity(), _kModelSpace));
}

Entity entitiesAttachedToElement[0];
for (int t=0;t<entitiesFromElementGroups.length();t++)
{
	Entity entEl= entitiesFromElementGroups[t];
	if(entEl.typeName() == typeName && entEl.handle() != handle && entitiesAttachedToElement.find(entEl,-1)<0 )
	{
		Element el1= entEl.element();
		if(el1.handle()== el.handle())
			entitiesAttachedToElement.append(entEl);
	}
}
reportMessage(T(" (|element owns| ")+entitiesAttachedToElement.length()+T(" |similar entities more|)"));


eraseInstance();
return;
#End
#BeginThumbnail

#End