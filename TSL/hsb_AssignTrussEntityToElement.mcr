#Version 8
#BeginDescription
Assign truss entity to element.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 05.03.2012 - version 1.0


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
*/

_ThisInst.setSequenceNumber(50);

String sArNY[] = {T("No"), T("Yes")};


int nValidZones[]={0,1,2,3,4,5,6,7,8,9,10};
int nRealZones[]={0,1,2,3,4,5,-1,-2,-3,-4,-5};
PropInt nZones (0, nValidZones, T("Zone to Assign the Trusses"));

// Load the values from the catalog
if (_bOnDbCreated || _bOnInsert) setPropValuesFromCatalog(_kExecuteKey);

int nZone=nRealZones[nValidZones.find(nZones, 0)];

//Insert
if( _bOnInsert )
{
	if( insertCycleCount()>1 ){eraseInstance(); return;}
	
	if (_kExecuteKey=="")
		showDialogOnce();
	
	PrEntity ssE("\n"+T("Select Truss/Joist entities"),TrussEntity());
	if( ssE.go() )
	{
		Entity ent[]=ssE.set();
		
		for (int i=0; i<ent.length(); i++)
		{
			TrussEntity te = (TrussEntity) ent[i];
			if (te.bIsValid())
			{
				_Entity.append(te);
			}
		}
	}

	_Element.append(getElement("\n"+T("Select element to link too")));

	return;
}

//Check if there is an element selected.
if( _Element.length() == 0 ){eraseInstance(); return; }

int nErase=FALSE;

Element el=_Element[0];
if (!el.bIsValid())
{
	eraseInstance();
	return;
}

for (int e=0; e<_Entity.length(); e++)
{
	TrussEntity te = (TrussEntity) _Entity[e];
	if (!te.bIsValid())
	{
		continue;
	}

	te.assignToElementGroup(el, true, nZone, 'Z');
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
