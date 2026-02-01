#Version 8
#BeginDescription
Assign beamss to a zone of an element.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 26.06.2012 - version 1.0


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 0
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
* date: 26.06.2012
* version 1.4: Add Zone 0 to the list of available zones to assign the beams
*/

_ThisInst.setSequenceNumber(50);

String sArNY[] = {T("No"), T("Yes")};

int nValidZones[]={0,1,2,3,4,5,6,7,8,9,10};
int nRealZones[]={0,1,2,3,4,5,-1,-2,-3,-4,-5};
PropInt nZones (0, nValidZones, T("Zone to Assign the Beams"));

PropString sZoneColour(0, sArNY, T("Use Sheeting Zone Colour?"));
sZoneColour.setDescription(T("|Sets the colour of the beams from the selected zone"));

// Load the values from the catalog
if (_bOnDbCreated || _bOnInsert) setPropValuesFromCatalog(_kExecuteKey);

int nZone=nRealZones[nValidZones.find(nZones, 0)];
int nZoneColour= sArNY.find(sZoneColour,0);

//Insert
if( _bOnInsert )
{
	if( insertCycleCount()>1 ){eraseInstance(); return;}
	
	if (_kExecuteKey=="")
		showDialogOnce();
	
	PrEntity ssE("\n"+T("Select beams"), Beam());
	
	if( ssE.go() )
	{
		_Beam.append(ssE.beamSet());
	}
	
	_Element.append(getElement("Select element to attach the beams"));
	
	return;
}

//Check if there is an element selected.
if( _Element.length() == 0 ){eraseInstance(); return; }

if ( _Beam.length() == 0 ){eraseInstance(); return; }

int nErase=FALSE;

Element el=_Element[0];
ElemZone elZone=el.zone(nZone);
int nColour=elZone.color();

for (int e=0; e<_Beam.length(); e++)
{
	//Check what colour is used in the zone that has been selected so we can set the beams to that colour

	Beam bm=_Beam[e];

	bm.assignToElementGroup(el, true, nZone, 'Z');

	if(nZoneColour) bm.setColor(nColour);

	nErase=TRUE;
	
}

if (_bOnElementConstructed || nErase)
{
	eraseInstance();
	return;
}





#End
#BeginThumbnail

#End
