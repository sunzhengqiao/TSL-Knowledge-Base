#Version 8
#BeginDescription
Assign sheets to a zone of an element.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 20.11.2012 - version 1.1


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 1
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
* date: 02.12.2010
* version 1.0: Release Version
*
* date: 20.11.2010
* version 1.1: Add Zone 0 to the dropdown
*/

int nValidZones[]={0,1,2,3,4,5,6,7,8,9,10};
int nRealZones[]={0,1,2,3,4,5,-1,-2,-3,-4,-5};
PropInt nZones (0, nValidZones, T("Zone to Assign the Sheets"));





//Insert
if( _bOnInsert ){
	if( insertCycleCount()>1 ){eraseInstance(); return;}
	
	if (_kExecuteKey=="")
		showDialogOnce();
	
	_Element.append(getElement(T("Select an Element")));
	
	PrEntity ssE("\n"+T("Select a set of sheets"),Sheet());
	
	if( ssE.go() )
	{
		_Sheet.append(ssE.sheetSet());
	}

	return;
};

// Load the values from the catalog
if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

int nZone=nRealZones[nValidZones.find(nZones, 0)];

//Check if there is an element selected.
if( _Element.length() == 0 ){eraseInstance(); return; }

if( _Sheet.length() == 0 ){eraseInstance(); return; }

//Assign selected element to el
Element el = _Element[0];

Beam bmAll[]=el.beam();

for( int i=0;i<_Sheet.length();i++ )
{
	Sheet sh = _Sheet[i];
	sh.assignToElementGroup(el, true, nZone, 'Z');
}

eraseInstance();
return;


#End
#BeginThumbnail




#End
