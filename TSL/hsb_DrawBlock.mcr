#Version 8
#BeginDescription
Draw the name of block that the master TSL set this one with

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 10.02.2012 - version 1.0
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
* date: 10.02.2012
* version 1.0: Release Version
*
*/

Unit (1,"mm");

PropString sBlockName(0,"",T("|Block Name|"));
sBlockName.setReadOnly(true);

if( _bOnInsert )
{
	_Pt0=getPoint("Pick a Point");
	return;
}


Display dp(-1);

Block blk(sBlockName);
dp.draw(blk, _Pt0);
#End
#BeginThumbnail

#End
