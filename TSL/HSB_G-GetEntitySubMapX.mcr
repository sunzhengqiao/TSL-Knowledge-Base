#Version 8
#BeginDescription
Last modified by: David Rueda (david.rueda@hsbcad.com)
21.06.2018 - version 1.00
Prints out the .DXX version of the SubMapX of name selected. Print will be done at drawing location.
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
///
/// </summary>

/// <insert>
/// Select entities(s)
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <history>
/// DR - 1.00 - 21.06.2018	- Release
/// </history>
//endregion

int nPropIndexInt, nPropIndexDouble, nPropIndexString;
PropString sSubMapXName(nPropIndexString, T("SubMapX"), T("|SubMapX name|"));nPropIndexString++;

//region bOnInsert
// Set properties if inserted with an execute key
String sCatalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if(_kExecuteKey != "" && sCatalogNames.find(_kExecuteKey) != -1 )
	setPropValuesFromCatalog(_kExecuteKey);

if (_bOnInsert)
{
	if (insertCycleCount() > 1)
	{
		eraseInstance();
		return;
	}
	
	if ( _kExecuteKey == "" || sCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	
	setCatalogFromPropValues(T("_LastInserted"));
	
	//region clonning TSL settings	
	String strScriptName = scriptName();
	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
	Entity lstEntities[1];
	GenBeam lstGenBeams[0];
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	Map mapTsl;
	mapTsl.setInt("ManualInserted", true);
	//endregion
	
	//region Sentect entities(s), clone instance per each one
	Entity sentectedEntities[0];
	PrEntity ssE(T("|Sentect entities|"), Entity());
	if (ssE.go())
		sentectedEntities.append(ssE.set());
	
	for (int e = 0; e < sentectedEntities.length(); e++)
	{
		Entity sentectedEntity = sentectedEntities[e];
		if ( ! sentectedEntity.bIsValid())
			continue;
		
		lstEntities[0] = sentectedEntity;
		
		TslInst tslNew;
		tslNew.dbCreate(strScriptName, vecUcsX, vecUcsY, lstGenBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
	}
	//endregion
	
	eraseInstance();
	return;
}
//endregion

//region set properties from master, set manualInserted=true if case
int manualInserted = false;
if (_Map.hasInt("ManualInserted")) 
{
	manualInserted = _Map.getInt("ManualInserted");
	_Map.removeAt("ManualInserted", true);
}

// set properties from catalog
if (_bOnDbCreated && manualInserted)
	setPropValuesFromCatalog(T("|_LastInserted|"));
//endregion

//region Resolve properties
//endregion

//region entement validation and basic info
if( _Entity.length() != 1 )
{
 	eraseInstance();
 	return;
}

Entity ent = _Entity[0];
if (!ent.bIsValid())
{
	eraseInstance();
	return;
}

reportMessage(TN("|Searching subMapX for entity|: ")+ent.handle());

Map subMapX = ent.subMapX(sSubMapXName);
if (subMapX.length() != 0)
{
	String sPath = _kPathDwg + "\\" + "subMapX-" + ent.handle() + ".dxx";
	Map mapOut=subMapX; mapOut.writeToDxxFile(sPath);
	reportMessage(TN("|Map written to path|: ")+sPath);
}
else
{ 
	reportMessage(TN("|No valid SubMapX found|"));
}


eraseInstance();
return;
#End
#BeginThumbnail

#End
#BeginMapX

#End