#Version 8
#BeginDescription
Calls a dll that allows us to import or refresh multiwalls

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 22.08.2012  -  version 1.0









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

Unit (1, "mm");

//String sOptions[]={"Import", "Refresh", "Export"};
//PropString sMode(0, sOptions, T("Insertion Mode"));



//PropDouble dOffset (0, U(3000), T("Offset between panels"));

if( _bOnInsert )
{
	showDialogOnce();
}

//int nMode=sOptions.find(sMode);

if( _bOnInsert )
{
	if (insertCycleCount()>1) { eraseInstance(); return; }
	

	PrEntity ssE(T("Select one or More Elements"), Element());
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}

	return;
}

String elNumber[0];
String mwNumber[0];
int nSequence[0];


for (int e=0; e<_Element.length(); e++)
{
	Element el=_Element[e];
	Map mp=el.subMapX("hsb_Multiwall");
	
	if ( mp.hasString("Number"))
	{
		elNumber.append(el.number());
		mwNumber.append(mp.getString("Number"));
		nSequence.append(mp.getInt("Sequence"));
	}
}


String sMultiwalls[0];
String sSingleElements[0];


for (int i=0; i<mwNumber.length(); i++)
{
	if (sMultiwalls.find(mwNumber[i], -1) != -1)//Already contain a multiwall
	{
		int n=sMultiwalls.find(mwNumber[i], -1);
		if (sSingleElements[n] == "")
		{
			sSingleElements[n]+=elNumber[i];
		}
		else
		{
			sSingleElements[n]+=" - ";
			sSingleElements[n]+=elNumber[i];
		}
	}
	else
	{
		sMultiwalls.append(mwNumber[i]);
		sSingleElements.append(elNumber[i]);
	}
}


Display dp(-1);

for (int i=0; i<sMultiwalls.length(); i++)
{
	dp.draw(sMultiwalls[i], _Pt0+_YW*(U(300)*i), _XW, _YW, 1, 1);
	dp.draw("|", _Pt0+_XW*U(11000)+_YW*(U(300)*i), _XW, _YW, 1, 1);
	
	dp.draw(sSingleElements[i], _Pt0+_XW*U(11500)+_YW*(U(300)*i), _XW, _YW, 1, 1);
}

return;









#End
#BeginThumbnail

#End
