#Version 8
#BeginDescription
Gives a message with the number of groups that the drawing has.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 31.08.2011 - version 1.0


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
* --------------------------------
*
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 31.08.2011
* version 1.0: Release Version
*
*/

Unit (1,"mm");

if( _bOnInsert ){
	if( insertCycleCount()>1 ){eraseInstance(); return;}
	
	_Pt0=_PtW;
	return;
}

//Select the subGroups of the Floors Group
Group gpFloor();
Group gpAllFloors[]=gpFloor.subGroups(true);

reportNotice("\nThe number of groups in the current drawing is: "+gpAllFloors.length());

eraseInstance();
return;


#End
#BeginThumbnail



#End
