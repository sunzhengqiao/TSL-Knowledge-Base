#Version 8
#BeginDescription
Last modified by: David Rueda (david.rueda@hsbcad.com)
22.05.2018 - version 1.06
Highlights filtered beams on real position for easy location in the model
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 6
#KeyWords 
#BeginContents
//region History and versioning
/// <summary Lang=en>
///
/// </summary>

/// <insert>
/// Select genBeams(s)
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <history>
/// DR - 1.00 - 16.05.2018	- Release
/// FA  - 1.01 - 17.05.2018 	- Added a working secondary filter which makes it filter on beamcodes over filter definitions.
/// FA  - 1.02 - 17.05.2018	- Added custom commands, for adding and removing beams.
/// DR - 1.03 - 18.05.2018	- Added option to show all selected GenBeams
///							- Tokens trimmed
///							- Custom commands (add/remove beams) expanded to work with genBeams
/// DR - 1.04 - 18.05.2018	- Report of filter results added
/// DR - 1.05 - 22.05.2018	- Removed text field for beam code, all selection filtered by HSB_G-FilterGenBeams. Set initial values for proper catalog definitions
/// DR - 1.06 - 22.05.2018	- Adding option for empty value for filter definition
/// </history>
//endregion

//region basic settings
//int bOnDebug = _bOnDebug;
String sNoYes[] = { T("|No|"), T("|Yes|")};
String sTab = "     ";
//int nPropIndexInt, nPropIndexDouble, nPropIndexString;
String sSelectionOptions[] = { T("|Include|"), T("|Exclude|")};
int nColors[0]; String sColors[0];
nColors.append(-1); sColors.append(T("|Default|"));
nColors.append(0); sColors.append(T("|White|"));
nColors.append(1); sColors.append(T("|Red|"));
nColors.append(2); sColors.append(T("|Yellow|"));
nColors.append(3); sColors.append(T("|Green|"));
nColors.append(4); sColors.append(T("|Cyan|"));
nColors.append(5); sColors.append(T("|Blue|"));
nColors.append(6); sColors.append(T("|Magenta|"));
nColors.append(7); sColors.append(T("|Black|"));
nColors.append(8); sColors.append(T("|Gray|"));
nColors.append(32); sColors.append(T("|Dark brown|"));
nColors.append(40); sColors.append(T("|Light brown|"));

String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = TslInst().getListOfCatalogNames(filterDefinitionTslName);
filterDefinitions.insertAt(0,"");

String addGenBeamsCommand = T("|Add genBeams|");
String removeGenBeamsCommand = T("|Remove genBeams by selection|");
String removeAllGenBeamsCommand = T("|Remove all genBeams|");
addRecalcTrigger(_kContext, addGenBeamsCommand);
addRecalcTrigger(_kContext, removeGenBeamsCommand);
addRecalcTrigger(_kContext, removeAllGenBeamsCommand);
//endregion

//region properties
PropString sColor(0, sColors, T("|Color|"), 3);

PropString sShowEnvelope(1, sNoYes, T("|Show Envelope|"), 1);
sShowEnvelope.setDescription(T("|Show filtered GenBeams|"));

PropString sShowPointer(2, sNoYes, T("|Show Pointer|"), 1);
sShowPointer.setDescription(T("|Displays a line from insertion point to filtered GenBeam's center|"));

PropString sShowAllSelected(3, sNoYes, T("|Show All GenBeams Selected|"), 0);
sShowPointer.setDescription(T("|Show all GenBeams selected (no filter applied)|"));

String sCategory_FilterBeams= T("|Filter GenBeams|");
PropString beamFilterDefinition(4, filterDefinitions, T("|Filter definition for GenBeams|"), 0);
beamFilterDefinition.setDescription(T("|Filter definition for GenBeams.|") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));
beamFilterDefinition.setCategory(sCategory_FilterBeams);
//endregion

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
	
	if ( _kExecuteKey == "" || sCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	
	setCatalogFromPropValues(T("_LastInserted"));
	
	//region select genBeams
	PrEntity genBeamsSelection(T("|Select genbeams to filter|"), GenBeam());
	Entity genBeamEntities[0];
	if (genBeamsSelection.go()) 
	{
		genBeamEntities.append(genBeamsSelection.set());
	}
	for (int e=0;e<genBeamEntities.length();e++) 
	{ 
		GenBeam genBeam= (GenBeam)genBeamEntities[e]; 
		if(genBeam.bIsValid())
		{ 
			_GenBeam.append(genBeam);
		}
	}
	
	if(_GenBeam.length() == 0)
	{ 
		eraseInstance();
		return;
	}
	//endregion
	
	_Pt0 = getPoint();
	return;
}
//endregion

//region adding/deleting beams
if (_kExecuteKey == removeAllGenBeamsCommand)
{ 
	_GenBeam.setLength(0);
}

if (_kExecuteKey == addGenBeamsCommand || _kExecuteKey == removeGenBeamsCommand)
{
	int addBeams = (_kExecuteKey == addGenBeamsCommand);
	String prompt = addBeams ? T("|Select genBeams to add to this connection|") : T("|Select genBeams to remove from this connection|");
	PrEntity selectionSetGenBeams(prompt, GenBeam());
	Entity genBeamEntities[0];
	if (selectionSetGenBeams.go())
	{
		genBeamEntities.append(selectionSetGenBeams.set());
	}
	//aa
	for (int b = 0; b < genBeamEntities.length(); b++)
	{
		GenBeam selectedGenBeam = (GenBeam)genBeamEntities[b];
		int beamIndex = _GenBeam.find(selectedGenBeam, - 1);
		if (addBeams && beamIndex == -1)
		{
			_GenBeam.append(selectedGenBeam);
		}
		else if ( ! addBeams && beamIndex != -1)
		{
			_GenBeam.removeAt(beamIndex);
		}
	}	
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
int nColor= nColors[sColors.find(sColor, 0)];
int bShowEnvelope= sNoYes.find(sShowEnvelope, 0);
int bShowPointer= sNoYes.find(sShowPointer, 0);
int bShowAllSelected= sNoYes.find(sShowAllSelected, 0);
//endregion

//region display
Display dp(nColor);
double dc=U(150);
Vector3d vxd=_XW;
Vector3d vyd=_YW;
Vector3d vzd=_ZW;
PLine pl;
Point3d ptStart=_Pt0;
Point3d pt=ptStart;
pl.addVertex(pt);
pt=ptStart+vxd*dc*.5;
pl.addVertex(pt);
pt=ptStart-vxd*dc*.5;
pl.addVertex(pt);
pt=ptStart;
pl.addVertex(pt);
pt=ptStart+vyd*dc*.5;
pl.addVertex(pt);
pt=ptStart-vyd*dc*.5;
pl.addVertex(pt);
dp.draw(pl);
pl=PLine();
pt=ptStart-vzd*dc*.5;
pl.addVertex(pt);
pt=ptStart+vzd*dc*.5;
pl.addVertex(pt);
dp.draw(pl);
//endregion

if (_GenBeam.length() == 0)
{
	return;
}

GenBeam genBeams[0]; genBeams = _GenBeam;

//region filter
Entity genBeamEntities[0];
for (int b=0;b<genBeams.length();b++)
{
	GenBeam genBeam = genBeams[b];
	if(!genBeam.bIsValid()){ continue; }
		
	genBeamEntities.append(genBeam);
}

Map filterGenBeamsMap;
filterGenBeamsMap.setEntityArray(genBeamEntities, false, "GenBeams", "GenBeams", "GenBeam");

int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, beamFilterDefinition, filterGenBeamsMap);
if (!successfullyFiltered) {
	reportWarning(T("|Beams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
	eraseInstance();
	return;
}

Entity filteredGenBeamEntities[] = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");
GenBeam filteredGenBeams[0];
for (int e=0;e<filteredGenBeamEntities.length();e++) 
{
	GenBeam bm = (GenBeam)filteredGenBeamEntities[e];
	if (!bm.bIsValid()){ continue; }
	
	filteredGenBeams.append(bm);
}
reportMessage("\n" + scriptName() + ": "+ T("|Beams selected|: ") + _GenBeam.length() + T("; |Beams filtered|: ") + filteredGenBeams.length());
//endregion

//region display
dp.color(1);
if (bShowAllSelected)
{
	for (int gb = 0; gb < _GenBeam.length(); gb++)
	{
		GenBeam genBeam = _GenBeam[gb];
		dp.draw(genBeam.envelopeBody());
	}
}

dp.color(nColor);
for (int b = 0; b < filteredGenBeams.length(); b++)
{
	GenBeam genBeam = filteredGenBeams[b];
	
	if (bShowEnvelope)
	{
		dp.draw(genBeam.envelopeBody());
	}
	
	if(bShowPointer)
	{ 
		LineSeg lsPointer(_Pt0, genBeam.ptCen());
		dp.draw(lsPointer);
	}
}
//endregion
#End
#BeginThumbnail








#End
#BeginMapX

#End