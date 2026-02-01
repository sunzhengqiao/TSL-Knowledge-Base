#Version 8
#BeginDescription
v1.0: 06.jun.2014: David Rueda (dr@hsb-cad.com)
Used to import hardware TSL instances from model map through .NET
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 0
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

 v1.0: 06.jun.2014: David Rueda (dr@hsb-cad.com)
	-Release
*/

TslInst tsl;
String sScriptName = _Map.getString("Scriptname");;
Vector3d vecUcsX = _XW;
Vector3d vecUcsY = _YW;
Beam lstBeams[0];lstBeams.append(_Beam);
Entity lstEnts[0];
Point3d lstPoints[0];
int lstPropInt[0];
double lstPropDouble[0];
String lstPropString[0];
tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString,1,_Map);
eraseInstance();
return;

#End
#BeginThumbnail


#End
