#Version 8
#BeginDescription
Set a color to all entities that have the selected height and width

02.02.2018
Mihai Bercuci (mihai.bercuci@hsbcad.com)
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
/*
*  COPYRIGHT
*  ---------
*  Copyright (C) 2018 by
*  hsbCAD
*
*  The program may be used and/or copied only with the written
*  permission from hsbCAD , or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*/
  
Unit (1,"mm");

//---------------------------------------------------------------------------------------------------------------------
//                                                                     Properties

String sArYesNo[] = {T("No"), T("Yes")};

String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = TslInst().getListOfCatalogNames(filterDefinitionTslName);
filterDefinitions.insertAt(0,"");

PropString entityHeightFilter(0, filterDefinitions, T("|Filter definition for entity height|"));
entityHeightFilter.setDescription(T("|Filter definition for beams to nail.|") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));


PropString entityWidthFilter(1, filterDefinitions, T("|Filter definition for entity width|"));
entityWidthFilter.setDescription(T("|Filter definition for beams to nail.|") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));


PropInt eColor(0,0, T("Color"),1);

//---------------------------------------------------------------------------------------------------------------------

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
		
		// check for existing tsls
		TslInst elTsls[] = selectedElement.tslInst();
		
		for (int index=0;index<elTsls.length();index++) 
		{ 
			TslInst tsl = elTsls[index]; 
			if (tsl.scriptName() == scriptName() && tsl.handle() != _ThisInst.handle())
				tsl.dbErase();
		}
		
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

GenBeam genBeams[] = el.genBeam();

Entity genBeamEntities[0];

for (int b=0;b<genBeams.length();b++)
{
	genBeamEntities.append(genBeams[b]);
}


Map filterGenBeamsMap;
filterGenBeamsMap.setEntityArray(genBeamEntities, false, "GenBeams", "GenBeams", "GenBeam");
int successfullyFilteredHeight = TslInst().callMapIO(filterDefinitionTslName, entityHeightFilter, filterGenBeamsMap);
int successfullyFilteredWidth = TslInst().callMapIO(filterDefinitionTslName, entityWidthFilter, filterGenBeamsMap);

if (!successfullyFilteredHeight && successfullyFilteredWidth) 
{
	
	reportWarning(T("|Beams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
	eraseInstance();
	return;
} 

Entity filteredGenBeamEntities[] = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");
GenBeam filtredGenBeams[0];

for (int e=0;e<filteredGenBeamEntities.length();e++) 
{
	GenBeam bm = (GenBeam)filteredGenBeamEntities[e];
	if (!bm.bIsValid()) continue;
	
	//add the color
	bm.setColor(eColor);
	
	filtredGenBeams.append(bm);
}

if (_bOnElementConstructed ||  filteredGenBeamEntities.length()>0)
{
	eraseInstance();
	return;
}






#End
#BeginThumbnail



#End