#Version 8
#BeginDescription
Rotates 90 degrees the blocking pieces that are inside of a wall.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 07.10.2009 - version 1.0

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
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*
* REVISION HISTORY
* -------------------------
*
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 07.10.2009
* version 1.0: Release Version
*
*/

Unit(1,"mm"); // script uses mm

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

if(_bOnInsert)
{
	if( insertCycleCount()>1 )
	{
		eraseInstance();
		return;
	}

	_Element.append(getElement(T("Please select a Element")));

	return;
}

if (_Element.length()==0)
{
	eraseInstance();
	return;
}

	
Element el=_Element[0];

if (!el.bIsValid())
{
	eraseInstance();
	return;
}
	
CoordSys csEl = el.coordSys();
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();
Point3d ptEl=csEl.ptOrg();
Beam bmAll[]=el.beam();
Beam bmBlocking[0];

for (int i = 0; i < bmAll.length(); i++)
{
	if (bmAll[i].type()==_kSFBlocking)
		bmBlocking.append(bmAll[i]);
}

for (int i = 0; i < bmBlocking.length()-1; i++)
{
	for (int j = i+1; j < bmBlocking.length(); j++)
	{
		if (vx.dotProduct(ptEl-bmBlocking[i].ptCen())>vx.dotProduct(ptEl-bmBlocking[j].ptCen()))
			bmBlocking.swap(i,j);
	}
}

for (int i = 0; i < bmBlocking.length(); i++)
{
	Beam bm=bmBlocking[i];
	CoordSys csBm=bm.coordSys();
	csBm.setToRotation(90, csBm.vecX(), csBm.ptOrg());
	bm.transformBy(csBm);
	bm.transformBy((pow(-1,i)*vy)*(bm.dD(vy)*0.5));
}

eraseInstance();
return;







#End
#BeginThumbnail



#End
