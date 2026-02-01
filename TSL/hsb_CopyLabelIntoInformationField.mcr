#Version 8
#BeginDescription
Displays various properties of a genbeam with a delimiter

Created by: Alberto Jena (alberto.jena@hsbcad.com)
date: 02.12.2014  -  version 2.0













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
*  Copyright (C) 2011 by
*  ITW Industry UK
*
*  The program may be used and/or copied only with the written
*  permission from hsbSOFT, or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*
* REVISION HISTORY
* --------------------------------
*
* Created by: Alberto Jena (alberto.jena@hsbcad.com)
* date: 19.10.2015
* version 1.0: 
*/

if (_bOnInsert || _bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

if(_bOnInsert)
{
	if (insertCycleCount()>1) { eraseInstance(); return; }

	//if (_kExecuteKey=="")
	//	showDialogOnce();

	PrEntity ssE(T("Please select Beams"),GenBeam());
 	if (ssE.go())
	{
 		Entity ents[0];
 		ents = ssE.set();
 		for (int i = 0; i < ents.length(); i++ )
		 {
 			GenBeam bm1 = (GenBeam) ents[i];
 			_GenBeam.append(bm1);
 		 }
 	}

	return;
}

if(_GenBeam.length()==0) eraseInstance();

for (int i=0; i<_GenBeam.length(); i++)
{
	GenBeam bm = (GenBeam) _GenBeam[i];
	if (!bm.bIsValid()) continue;
	bm.setInformation(bm.label());
}

eraseInstance();
return;
#End
#BeginThumbnail

#End