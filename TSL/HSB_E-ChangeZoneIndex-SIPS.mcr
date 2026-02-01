#Version 8
#BeginDescription
Last modified by: David Rueda (david.rueda@hsbcad.com)
19.05.2017  -  version 1.00
Changes SIP's zone from selected element(s)
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
//region History and versioning
/// <summary Lang=en>
/// Changes SIP's zone from selected element(s) (Meant to be used on debug)
/// </summary>

/// <insert>
/// Select element(s)
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <history>
/// DR - 1.00 - 19.05.2017	- Pilot version
/// </history>
//endregion

//region basic settings
Unit (1,"mm");
double dTolerance=U(0.001);
int bOnDebug=false;
//endregion

PropInt nZone(0,-5, T("|Zone index|"));

//region bOnInsert
// Set properties if inserted with an execute key
String sCatalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if( sCatalogNames.find(_kExecuteKey) != -1 )
	setPropValuesFromCatalog(_kExecuteKey);

if (_bOnInsert) 
{
	if (insertCycleCount() > 1)
	{
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || sCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();

	setCatalogFromPropValues(T("_LastInserted"));
	
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
	Element  selectedElements[0];
	PrEntity ssE(T("|Select elements|"), Element());
	if (ssE.go())
		selectedElements.append(ssE.elementSet());
	
	for (int e=0;e<selectedElements.length();e++)
	{
		Element selectedElement = selectedElements[e];
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
int zone= nZone;
if(zone>5 && zone<11)
	zone=-zone+5;
else if(zone <-5 || zone >10)
{ 
	reportMessage("\n" + scriptName() + ": " +T("|Invalid zone|"));
	eraseInstance();
	return;
}
//endregion

//region Element validation and basic info
if( _Element.length() != 1 )
{
	reportMessage("\n" + scriptName() + ": " +T("|No element selected, TSL will be erased|"));
 	eraseInstance();
 	return;
}

Element el = _Element[0];
if (!el.bIsValid())
{
	reportMessage("\n" + scriptName() + ": " +T("|Selected element is invalid, TSL will be erased|"));
	eraseInstance();
	return;
}
//endregion

Sip sips[]= el.sip();
for (int s=0;s<sips.length();s++) 
{ 
	Sip sip= sips[s]; 
	sip.assignToElementGroup(el,1,zone,'Z');
}

eraseInstance();
return;
#End
#BeginThumbnail

#End