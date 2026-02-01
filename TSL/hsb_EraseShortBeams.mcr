#Version 8
#BeginDescription
Last modified by: Alberto Jena (alberto.jena@hsbcad.com)
28.08.15 -  version 1.0
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
*  Copyright (C) 2009 by
*  hsbSOFT 
*  IRELAND
*
*  The program may be used and/or copied only with the written
*  permission from hsbSOFT, or in accordance with
*  the terms and conditions stipulated in the agreement/contractd
*  under which the program has been supplied.
*
*  All rights reserved.
*
* REVISION HISTORY
* -------------------------
*
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 07.05.2010
* version 1.0: Release Version
*
*/

Unit(1,"mm"); // script uses mm

int nBmType[0];
String sBmName[0];

String sModes[]={T("Delete"), T("Change Color")};
PropString sMode(0, sModes,T("Action"),0);

PropDouble dMinLength(0, U(50),T("Minimum beam length"));

PropInt nColor (0, 1, T("Color"));

if (_bOnDbCreated)
{
	 setPropValuesFromCatalog(_kExecuteKey);
}

int nMode=sModes.find(sMode);

//double dMinLength=U(50);

if(_bOnInsert)
{
	
	if( insertCycleCount()>1 )
	{
		eraseInstance();
		return;
	}


	if (_kExecuteKey=="")
		showDialogOnce();

	PrEntity ssE(T("Select one or More Elements"), Element());
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	return;
}

if (_Element.length()==0)
{
	eraseInstance();
	return;
}

int nErase=false;

for(int e=0 ; e < _Element.length() ; e++)
{
	Element el=_Element[0];	

	if (!el.bIsValid()) continue;
	
	Beam bmAll[]=el.beam();
	
	for(int i=0 ; i < bmAll.length() ; i++)
	{
		Beam bm=bmAll[i];
		nErase=true;
		if (bmAll[i].solidLength() < dMinLength)
		{
			if (nMode==0)
			{
				bm.dbErase();
			}
			else
			{
				bm.setColor(nColor);
			}
		}
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