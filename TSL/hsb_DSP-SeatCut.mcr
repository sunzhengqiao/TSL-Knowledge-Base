#Version 8
#BeginDescription
Creates a seat cut completely through the beam and is to be inserted via DSP
Date: 18.05.2015  -  version 1.0
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
*  Copyright (C) 2015 by
*  hsbCAD UK
*
*  The program may be used and/or copied only with the written
*  permission from hsbCAD, or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*
* REVISION HISTORY
* -------------------------
*
* Created by: Chirag Sawjani (csawjani@itw-industry.com)
* 18.05.2015
* version 1.0: Release Version
*/

Unit(1,"mm");

if (_bOnInsert)
{
	return;
}

if(_Element.length() < 0 )
{
	eraseInstance();
	return;
}

Point3d ptOrigin = _Pt0;
Element el = _Element[0];
Map mp = _Map;
String sBeamCodeKey = "BEAMCODE";
if(!mp.hasString(sBeamCodeKey))
{
	eraseInstance();
	return;
}

String sBeamCode = mp.getString(sBeamCodeKey).makeUpper();

Beam beams[] = el.beam();
Beam beamsWithCode[0];
for(int i=0;i<beams.length();i++)
{
	Beam bm = beams[i];
	String sBeamCodeCurr=bm.beamCode().token(0);
	sBeamCodeCurr.makeUpper();

	if(sBeamCodeCurr==sBeamCode)
	{
		beamsWithCode.append(bm);
	}			
}

for(int i =0; i<beamsWithCode.length();i++)
{
	Beam bm = beamsWithCode[i];
	Cut ct(ptOrigin, -_ZW);
	bm.addToolStatic(ct, _kStretchOnInsert);
}

eraseInstance();
return;





#End
#BeginThumbnail



#End