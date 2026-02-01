#Version 8
#BeginDescription

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents

String categories[] = 
{
	T("|Element Zone|")
};

int zoneIndexes[] = { 1,2,3,4,5,6,7,8,9,10};
PropInt zoneToChangeProp(0, zoneIndexes, T("|Zone to change|"));
zoneToChangeProp.setCategory(categories[0]);

PropDouble newThickness(0, U(12), T("|New thickness|"));
newThickness.setCategory(categories[0]);

// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if( catalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

if (_bOnInsert) {
	if (insertCycleCount() > 1) 
	{
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || catalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	setCatalogFromPropValues(T("_LastInserted"));
	
	Element  selectedElements[0];
	PrEntity ssE(T("|Select elements|"), Element());
	if (ssE.go())
		selectedElements.append(ssE.elementSet());
	
	String strScriptName = scriptName();
	Vector3d vecUcsX(1,0,0);
	Vector3d vecUcsY(0,1,0);
	Beam lstBeams[0];
	Entity lstEntities[1];
	
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	Map mapTsl;
	mapTsl.setInt("ManualInserted", true);

	for (int e=0;e<selectedElements.length();e++) 
	{
		Element selectedElement = selectedElements[e];
		if (!selectedElement.bIsValid())
			continue;
		
		lstEntities[0] = selectedElement;
		
		TslInst tslNew;
		tslNew.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
	}
	
	eraseInstance();
	return;
}

if( _Element.length() != 1 )
{
	reportWarning(TN("|No element selected!|"));
	eraseInstance();
	return;
}

int manualInserted = false;
if (_Map.hasInt("ManualInserted")) 
{
	manualInserted = _Map.getInt("ManualInserted");
	_Map.removeAt("ManualInserted", true);
}

// set properties from catalog
if (_bOnDbCreated && manualInserted)
	setPropValuesFromCatalog(T("|_LastInserted|"));

Element el = _Element[0];
if (!el.bIsValid())
{
	reportNotice(TN("|The selected element is invalid|!"));
	eraseInstance();
	return;
}

// Resolve properties
int zoneIndexToChange = zoneToChangeProp;
if (zoneIndexToChange > 5)
	zoneIndexToChange = 5 - zoneIndexToChange;
	
ElemZone zoneToChange = el.zone(zoneIndexToChange);
zoneToChange.setDH(newThickness);
el.setZone(zoneIndexToChange, zoneToChange);
#End
#BeginThumbnail

#End