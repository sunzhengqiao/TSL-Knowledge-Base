#Version 8
#BeginDescription
Assign a TSL none exclusively to the group of all the element selected.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 02.12.2010 - version 1.0

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
* date: 02.12.2010
* version 1.0: Release Version
*
*/


//Insert
if( _bOnInsert ){
	if( insertCycleCount()>1 ){eraseInstance(); return;}
	
	//if (_kExecuteKey=="")
	//	showDialogOnce();
	
	_Entity.append(getTslInst(T("Select a TSL")));
	
	PrEntity ssE("\n"+T("Select a set of elements"), Element());
	
	if( ssE.go() )
	{
		_Element.append(ssE.elementSet());
	}

	return;
};

//Check if there is an element selected.
if( _Entity.length() == 0 ){eraseInstance(); return; }

TslInst tsl = (TslInst)_Entity[_Entity.length()-1];

if (!tsl.bIsValid())
{
	reportNotice("TSL Selected Not Valid");
	//eraseInstance(); return;
}

for( int i=0; i<_Element.length(); i++ )
{
	Element el = _Element[i];
	Group gp=el.elementGroup();
	tsl.assignToElementGroup(el, false);
	gp.addEntity(tsl, false);
	_Pt0=el.ptOrg();
}

//eraseInstance();

#End
#BeginThumbnail

#End
