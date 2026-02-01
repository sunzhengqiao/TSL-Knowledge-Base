#Version 8
#BeginDescription
Removes nail lines for stickframe walls

Created by: Alberto Jena (aj@hsb-cad.com)
Date: 02.09.2009 version 1.0





#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
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
* date: 02.09.2009
* version 1.0: Release Version for UK Content
*
*/

if( _bOnInsert ){
	if (insertCycleCount()>1) { eraseInstance(); return; }
	//if (_kExecuteKey=="")
	//	showDialogOnce();
	PrEntity ssE(T("Select one or More Elements"), ElementWallSF());
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	return;
}

if( _Element.length() == 0 ){eraseInstance(); return;}


for (int e=0; e<_Element.length(); e++)
{	
	
	ElementWallSF el = (ElementWallSF) _Element[e];
	if (!el.bIsValid())
		continue;
	NailLine nlOld[] = el.nailLine();
	for (int n=0; n<nlOld.length(); n++)
	{
		NailLine nl = nlOld[n];
		nl.dbErase();
	}
	TslInst arTsl[] = el.tslInstAttached();
	for (int t=0; t<arTsl.length(); t++)
	{
		if (arTsl[t].scriptName()=="hsb_Apply Naillines to Elements")
			arTsl[t].dbErase();
  	}
}

eraseInstance();
return;

#End
#BeginThumbnail


#End
