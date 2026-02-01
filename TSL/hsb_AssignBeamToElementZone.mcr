#Version 8
#BeginDescription
Assign beams or sheets to a zone of an element.
If a beam code is specified it could search for that code in multiple elements.
If no code is set it will ask for the entities and the element to assign them.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 03.02.2022 - version 1.6

1.7 27/06/2023 Add option to Remove Module Information AJ
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 7
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2008 by
*  hsbSOFT 
*  IRELAND
*
*  The program may be used and/or copied only with the written
*  permission from hsbSOFT, or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*
* REVISION HISTORY
* -------------------------
*
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 05.09.2011
* version 1.0: Release Version
*
*
* date: 02.02.2012
* version 1.1: Added property to set colour to that of the zone
*
* date: 03.02.2012
* version 1.2: Bugfix on Insert
*
* date: 20.03.2012
* version 1.3: Bugfix when no beam code was set
*
* date: 06.03.2013
* version 1.4: If no beam code is set then the TSL will ask for beams and only one element.
*/

_ThisInst.setSequenceNumber(50);

String sArNY[] = { T("No"), T("Yes")};

PropString sFilterBeams(0, "", T("|Find Beams with Code|"));
sFilterBeams.setDescription(T("|Separate multiple entries by|") + " ';'");

int nValidZones[] ={ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 0};
int nRealZones[] ={ 1, 2, 3, 4, 5 ,- 1 ,- 2 ,- 3 ,- 4 ,- 5, 0};
PropInt nZones (0, nValidZones, T("Zone to Assign the Beams or Sheets"));

PropString sZoneColour(1, sArNY, T("Use Sheeting Zone Colour?"));
sZoneColour.setDescription(T("|Sets the colour of the beams from the selected zone"));

PropString sSetBeamType(2, sArNY, T("Set beam type?"));

PropString pTypes(3, _BeamTypes, "New beam type");

PropString sModule(4, sArNY, "Reset Module Information");
 
// Load the values from the catalog
if (_bOnDbCreated || _bOnInsert) setPropValuesFromCatalog(_kExecuteKey);

int nZone = nRealZones[nValidZones.find(nZones, 0)];
int nZoneColour = sArNY.find(sZoneColour, 0);
int nSetType = sArNY.find(sSetBeamType, 0);
int nSetModule = sArNY.find(sModule, 0);
int type = _BeamTypes.find(pTypes);

// transform filter tsl property into array
String sBeamFilter[0];
String sList = sFilterBeams;
sList=sList+";";
int bBmFilter=false;

while (sList.length() > 0 || sList.find("; ", 0) >- 1)
{
	String sToken = sList.token(0);
	sToken.trimLeft();
	sToken.trimRight();
	sToken.makeUpper();
	if (sToken != "")
		sBeamFilter.append(sToken);
		//double dToken = sToken.atof();
			//int nToken = sToken.atoi();
			int x = sList.find(";", 0);
			sList.delete(0, x + 1);
			sList.trimLeft();
			if (x == -1)
				sList = "";
}

if (sBeamFilter.length() > 0)
	bBmFilter=TRUE;
	
//Insert
if ( _bOnInsert )
{
	if ( insertCycleCount() > 1 ) { eraseInstance(); return; }
	
	if (_kExecuteKey == "")
		showDialogOnce();
	
	if (bBmFilter == true)
	{
		PrEntity ssE("\n" + T("Select elements"), Element());
		
		if ( ssE.go() )
		{
			_Element.append(ssE.elementSet());
		}
	}
	else
	{
		_Element.append(getElement(T("Select an element")));
		
		PrEntity ssEBeams("\n" + T("Select Beams or Sheets"), GenBeam());
		
		if ( ssEBeams.go() )
		{
			Entity entAll[] = ssEBeams.set();
			for (int i = 0; i < entAll.length(); i++)
			{
				GenBeam gbm = (GenBeam) entAll[i];
				if (gbm.bIsValid())
				{
					_GenBeam.append(gbm);
				}
				
			}
			
		}
	}
	
	return;
}

//Check if there is an element selected.
if( _Element.length() == 0 ){eraseInstance(); return; }

int nErase=FALSE;

for (int e = 0; e < _Element.length(); e++)
{
	Element el = _Element[e];
	
	//Check what colour is used in the zone that has been selected so we can set the beams to that colour
	ElemZone elZone = el.zone(nZone);
	int nColour = elZone.color();
	
	GenBeam bmAll[0];
	if (bBmFilter)
	{
		bmAll.append(el.genBeam());
	}
	else
	{
		nErase = TRUE;
		bmAll.append(_GenBeam);
	}
	
	
	for (int i = 0; i < bmAll.length(); i++)
	{
		GenBeam bm = bmAll[i];
		
		if (sBeamFilter.find(bm.beamCode().token(0), - 1) != -1 || bBmFilter == false)
		{
			
			bm.assignToElementGroup(el, true, nZone, 'Z');
			if (nZoneColour) bm.setColor(nColour);
			if (nSetType) bm.setType(type);
			if (nSetModule) bm.setModule("");
		}
		nErase = TRUE;
	}
	
}

if (_bOnElementConstructed || nErase)
{
	eraseInstance();
	return;
}





#End
#BeginThumbnail









#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Add option to Remove Module Information" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="7" />
      <str nm="DATE" vl="6/27/2023 2:30:33 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End