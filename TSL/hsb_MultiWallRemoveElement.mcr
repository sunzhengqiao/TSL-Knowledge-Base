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
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2008 by
*  hsbSOFT IRELAND
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
* date: 22.08.2012
* version 1.0: First version
*
*/


if(_bOnInsert)
{
	if( insertCycleCount()>1 )
	{
		eraseInstance();
		return;
	}

	//if (_kExecuteKey=="")
	//	showDialogOnce();

	PrEntity ssE(T("Select one or More Elements"), ElementWallSF());
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	return;
}

for( int e=0; e<_Element.length(); e++)
{
	Element el=_Element[e];
	if (!el.bIsValid())
		continue;
		
	Map mp=el.subMapX("hsb_Multiwall");
	if (mp.length()>0)
	{
		el.removeSubMapX("hsb_Multiwall");
	}
}

eraseInstance();
return;


#End
#BeginThumbnail


#End