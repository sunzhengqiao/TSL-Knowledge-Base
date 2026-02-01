#Version 8
#BeginDescription
Redistributes studs to the left or right of the distribution point for stickframe walls

Last modified by: Alberto Jena (aj@hsb-cad.com)
Date: 26.05.2010  -  version 1.0 Release


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
* date: 26.05.2010
* version 1.0: Release Version
*/

Unit(1,"mm"); // script uses mm

PropDouble dOffset(0, U(400), T("|Distance Between Studs|"));

String sArNY[] = {T("Left"), T("Right")};
PropString strStager (0, sArNY,T("Redistribute to"));


if (_bOnInsert)
{
	if( insertCycleCount()>1 )
	{
		eraseInstance();
		return;
	}

	if (_kExecuteKey=="")
		showDialogOnce();

	_Element.append(getElement(T("|Select an element|")));
	_Pt0 = getPoint(T("|Select Distribution Point|"));
}

int nLeftRight=sArNY.find(strStager);
if( _Element.length() == 0 ){
	eraseInstance();
	return;
}

int arValidBeamType[]={
	_kStud
};

Element el  = _Element[0];
CoordSys csEl = el.coordSys();
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();

Beam arBeam[] = el.beam();	

if (arBeam.length()<1)
{
	eraseInstance();
	return;
}

Vector3d vDir=vx;
if (nLeftRight)
{
	vDir=-vDir;
}

//Create beams
Plane plnZ(csEl.ptOrg(), vz);
Line ln (csEl.ptOrg(), vx);

_Pt0=ln.closestPointTo(_Pt0);

Beam bmToRedistribute[0];
Beam bmLastOriginal;
double dMinDist=U(10000);

for (int b=0; b<arBeam.length(); b++)
{
	Beam bm=arBeam[b];
	if (arValidBeamType.find(bm.type()) != -1 )
	{	
		Vector3d vToBeam=bm.ptCen()-_Pt0;
		vToBeam.normalize();
		if (vToBeam.dotProduct(vDir)<0)
			bmToRedistribute.append(bm);
		else
		{
			if (abs(vDir.dotProduct(vToBeam))<dMinDist)
			{
				dMinDist=abs(vDir.dotProduct(vToBeam));
				bmLastOriginal=bm;
			}
		}
	}		
}

for (int b=0; b<bmToRedistribute.length(); b++)
{
	
	bmToRedistribute[b].dbErase();
}

Beam bmAll[]=el.beam();
for (int b=0; b<bmAll.length(); b++)
{
	if (bmAll[b].type() == _kSFBlocking || bmAll[b].type() == _kBlocking)
	{
		bmAll.removeAt(b);
		b--;
	}
}

bmLastOriginal.realBody().vis(1);

Line lnX (bmLastOriginal.ptCen(), vDir);

PlaneProfile ppEl=el.profNetto(0);

LineSeg lsEl=el.segmentMinMax();
double dElLength=abs(vx.dotProduct(lsEl.ptStart()-lsEl.ptEnd()));

int nTimes=dElLength/dOffset;
nTimes++;

Point3d ptToCreate=bmLastOriginal.ptCen();
for (int i=0; i<nTimes; i++)
{
	ptToCreate=lnX.closestPointTo(ptToCreate);
	ptToCreate=ptToCreate-vDir*dOffset;
	if (ppEl.pointInProfile(ptToCreate)==_kPointInProfile)
	{
		Beam bmStud;
		bmStud.dbCreate(ptToCreate, vy, vx, -vz, U(100), bmLastOriginal.dD(vx), bmLastOriginal.dD(vz), 0, 0, 0);
		bmStud.setType(_kStud);
		bmStud.setName("STUD");
		bmStud.setMaterial(bmLastOriginal.material());
		bmStud.setGrade(bmLastOriginal.grade());
		bmStud.setColor(bmLastOriginal.color());
		bmStud.assignToElementGroup(el, TRUE, 0, 'Z');

		
		Beam bmAux1[0];
		bmAux1=Beam().filterBeamsHalfLineIntersectSort(bmAll, ptToCreate, vy);
		if (bmAux1.length()>0)
			bmStud.stretchStaticTo(bmAux1[0], true);

		Beam bmAux2[0];
		bmAux2=Beam().filterBeamsHalfLineIntersectSort(bmAll, ptToCreate, -vy);
		if (bmAux2.length()>0)
			bmStud.stretchStaticTo(bmAux2[0], true);
		
	}
}


Display dp(-1);

LineSeg ls (_Pt0-vz*U(50), _Pt0+vz*U(50));
dp.draw(ls);

eraseInstance();
return;


#End
#BeginThumbnail

#End
