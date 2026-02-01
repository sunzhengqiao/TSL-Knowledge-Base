#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
08.06.2017  -  version 1.03

Sets selected genbeam(s) panhand to selected element with option to set zone number/character and exclusivity
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// Sets selected genbeam(s) panhand to selected element with option to set zone number/character and exclusivity
/// </summary>

/// <insert>
/// Select a set of elements
/// </insert>

/// <remark Lang=en>
/// .
/// </remark>

/// <version  value="1.03" date="08.06.2017"></version>

/// <history>
/// AS - 1.00 - 01.12.2016 	- Pilot version
/// AS - 1.01 - 18.04.2017 	- Rename tsl from HSB_G-SetPanHand into HSB_G-SetToElement. 
/// DR - 1.02 - 07.06.2017	- Added option to assign genBeams to element with zone number, exclusive and character option
/// AS - 1.03 - 08.06.2017	- Create a boolean for the assignToElement
/// </history>

String sNoYes[] = {T("|No|"),T("|Yes|")};
String sZoneOptions[]= {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", T("|Don't assign|")};
String arSZoneCharacter[] = {
	"'E' for element tools",
	"'Z' for general items",
	"'T' for beam tools",
	"'I' for information",
	"'C' for construction",
	"'D' for dimension"
};
char arCZoneCharacter[] = {
	'E', 
	'Z', 
	'T', 
	'I', 
	'C',
	'D'
};

PropString sSelectedZone( 0, sZoneOptions, T("|Assign to element zone|"), sZoneOptions.length()-1);
PropString sZoneCharacter(1,arSZoneCharacter, T("Zone character"), 1);
PropString sExclusive(2, sNoYes, T("Add exclusive"), 1);

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
	
	PrEntity ssE(T("|Select a set of beams, sheets or sips|"), GenBeam());

	if (ssE.go()) 
	{
		Entity entities[] = ssE.set();
		for (int e=0;e<entities.length();e++)
		{
			GenBeam gBm = (GenBeam)entities[e];
			if (gBm.bIsValid())
				_GenBeam.append(gBm);
		}
	}
	
	_Element.append(getElement(T("|Select element to set the panhand for the selected entities to.")));

	return;
}
// set properties from catalog
setPropValuesFromCatalog(T("|_LastInserted|"));

int nSelectedZone= sZoneOptions.find(sSelectedZone);
int nZoneIndex = nSelectedZone;
if( nZoneIndex > 5 )
	nZoneIndex = 5 - nZoneIndex;

char cZoneCharacter = arCZoneCharacter[arSZoneCharacter.find(sZoneCharacter,1)];
int bExclusive = sNoYes.find(sExclusive, 1);
int assignToElement = (nSelectedZone =! sZoneOptions.length()-1);

if (_Element.length() == 0) 
{
	eraseInstance();
	return;
}

Element el  = _Element[0];
for (int g=0;g<_GenBeam.length();g++)
{
	GenBeam gBm = _GenBeam[g];
	gBm.setPanhand(el);
	if (assignToElement)
		gBm.assignToElementGroup(el, bExclusive, nZoneIndex, cZoneCharacter);
}

eraseInstance();
return;
#End
#BeginThumbnail















#End