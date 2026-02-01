#Version 8
#BeginDescription
Hatch sheets of a zone in paper space.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 19.03.2013 - version 1.2


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
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
* date: 10.11.2010
* version 1.0: Add Spline Hatch
*
* date: 12.11.2010
* version 1.1: Filter the sheets by sublabel
*
* date: 03.19.2013
* version 1.2: Allow sheets of zone 0 to be hatch
*/

PropString pHatchPattern(0,_HatchPatterns,"Hatch pattern");

PropDouble dAngle(0, 0, T("Hatch Angle"));
dAngle.setFormat(_kAngle);

PropDouble dHatchScale(1,U(20),T("Hatch Scale"));

PropInt nColorHatch(0, 1, T("Hatch Color"));

int nValidZones[]={0,1,2,3,4,5,6,7,8,9,10};
int nRealZones[]={0,1,2,3,4,5,-1,-2,-3,-4,-5};
PropInt nZones (1, nValidZones, T("Zone to hatch"));

PropString sComment(1, "", "Filter Sheet with SubLabel");
sComment.setDescription("Only the sheetings with this comment value will be hatch on the layout of the zone define above");

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

int nZone=nRealZones[nValidZones.find(nZones, 0)];

//------------------------------------------------------------------------------------------------------------------------
//                                                                    Insert

if( _bOnInsert ){
	_Viewport.append(getViewport(T("Select a viewport")));
	
	showDialog();
}

if( _Viewport.length() == 0 ){
	eraseInstance();
	return;
}

Viewport vp = _Viewport[0];

CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps; ps2ms.invert();

_Pt0 = vp.ptCenPS();

Element el = vp.element();
if( !el.bIsValid() )return;

CoordSys cs=el.coordSys();
Vector3d vx=cs.vecX();
Vector3d vy=cs.vecY();
Vector3d vz=cs.vecZ();
Point3d ptOrgEl=cs.ptOrg();

Beam arBm[] = el.beam();
if (arBm.length()<1)
	return;

Plane pln(ptOrgEl-vz*U(10), vz);

Display dpHatch(nColorHatch);

Hatch hatch(pHatchPattern ,dHatchScale);
hatch.setAngle(dAngle); 

Sheet shAll[]=el.sheet(nZone);
String sCom=sComment;

Sheet shToHatch[0];

if (sCom.length()>0)
{
	sCom.trimLeft();
	sCom.trimRight();
	sCom.makeUpper();
	for( int i=0; i<shAll.length(); i++ )
	{
		String sThisComment=shAll[i].name("Sublabel");
		sThisComment.trimLeft();
		sThisComment.trimRight();
		sThisComment.makeUpper();
		if (sThisComment==sCom)
		{
			shToHatch.append(shAll[i]);
		}
	}
}
else
{
	shToHatch.append(shAll);
}



for( int i=0; i<shToHatch.length(); i++ )
{
	Sheet sh = shToHatch[i];
	Body bd=sh.realBody();
	//bdBm.vis();
	PlaneProfile pp=bd.shadowProfile(pln);
	pp.shrink(U(1));
	pp.transformBy(ms2ps);
	dpHatch.draw(pp, hatch);
}





#End
#BeginThumbnail



#End
