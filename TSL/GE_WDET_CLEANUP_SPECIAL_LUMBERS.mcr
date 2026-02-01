#Version 8
#BeginDescription
Searches through all lumbers on selected wall(s) and erases/color them according to certain features:
- ERASE those which contain value ‘VOID’ on token (0), in beam code
- COLOR lumbers ‘BORATE’ on green 
v1.0: 28.dic.2013: David Rueda (dr@hsb-cad.com)
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
  COPYRIGHT
  ---------------
  Copyright (C) 2011 by
  hsbSOFT 

  The program may be used and/or copied only with the written
  permission from hsbSOFT, or in accordance with
  the terms and conditions stipulated in the agreement/contract
  under which the program has been supplied.

  All rights reserved.

 REVISION HISTORY
 -------------------------

 v1.0: 28.dic.2013: David Rueda (dr@hsb-cad.com)
	- Release
*/

Unit(1,"mm"); // script uses mm

int nBmType[0];
String sBmName[0];

if(_bOnInsert)
{
	if( insertCycleCount()>1 )
	{
		eraseInstance();
		return;
	}

	PrEntity ssE(T("Select Element (s)"), ElementWallSF());
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


for( int e=0; e<_Element.length(); e++)
{
	Element el=_Element[e];
	if (!el.bIsValid())
		continue;

	Beam bmAll[]=el.beam();
	for(int b=0;b<bmAll.length();b++)
	{
		Beam bm=bmAll[b];
		if(bm.beamCode().token(0).makeUpper().find("VOID",-1) >= 0 )
		{
			bm.dbErase();
			continue;
		}
		
		if(bm.grade().makeUpper()=="BORATE")
		{
			bm.setColor(3);
		}
	}
}

eraseInstance();
return;
#End
#BeginThumbnail

#End
