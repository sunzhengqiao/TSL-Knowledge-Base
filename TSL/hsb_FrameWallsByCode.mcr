#Version 8
#BeginDescription
Triggers the generation of all selected walls that have a specific code.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 04.04.2011 - version 1.0
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
* date: 04.04.2011
* version 1.0: Release Version
*
*/

PropString psExtType(0, "M;",  T("Code wall to generate"));

if(_bOnInsert){
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	if (_kExecuteKey=="")
		showDialogOnce();
	PrEntity ssE("\n"+T("Select a set of elements"),Element());
	
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	return;
}

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);


if( _Element.length()==0 ){
	eraseInstance();
	return;
}

//Fill and array with the code of the firewalls

String sArrExtCode[0];
String sExtType=psExtType;
sExtType.trimLeft();
sExtType.trimRight();
sExtType=sExtType+";";
for (int i=0; i<sExtType.length(); i++)
{
	String str=sExtType.token(i);
	str.trimLeft();
	str.trimRight();
	if (str.length()>0)
		sArrExtCode.append(str);
}

//-----------------------------------------------------------------------------------------------------------------------------------
//          Loop over all elements.

ElementWallSF elWall[0];

for( int e=0; e<_Element.length(); e++ )
{
	ElementWallSF el = (ElementWallSF) _Element[e];
	if (el.bIsValid())
	{
		String sCode = el.code();
		if( sArrExtCode.find(sCode) != -1 )
		{
			elWall.append(el);
		}
	}
}

String strName = "";
String sAllWalls[0];
for (int i=0; i<elWall.length(); i++)
{
	String sName=elWall[i].number();
	if (sAllWalls.find(sName, -1) == -1)
	{
		sAllWalls.append(sName);
		strName+=sName+";";
	}
}


if (strName!="")
{
		pushCommandOnCommandStack("-Hsb_GenerateConstruction "+strName);
}

eraseInstance();
return;


#End
#BeginThumbnail

#End
