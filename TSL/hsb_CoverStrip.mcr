#Version 8
#BeginDescription
Creates a sheeting under the elements

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 01.09.2010 - version 1.1


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
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
* date: 01.02.2010
* version 1.0: Release Version
*
*/

U(1,"mm");	

int nLunit = 2; // architectural (only used for beam length, others depend on hsb_settings)
int nPrec = 0; // precision (only used for beam length, others depend on hsb_settings)

PropDouble dTimberWidth(0, 9, T("Sheet Thickness"));
PropDouble dTimberHeight(1, 140, T("Sheet Height"));

PropString sName (0,"",T("Sheet Name"));
PropString sMaterial (1,"",T("Sheet Material"));

int nValidZones[]={1,2,3,4,5,6,7,8,9,10};
int nRealZones[]={1,2,3,4,5,-1,-2,-3,-4,-5};
PropInt nZones (0, nValidZones, T("Zone to Assign the Sheets"));

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

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
	
	String strScriptName = scriptName(); // name of the script
	Vector3d vecUcsX(1,0,0);
	Vector3d vecUcsY(0,1,0);
	Beam lstBeams[0];
	Element lstElements[0];
	
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	lstPropString.append(sName);
	lstPropString.append(sMaterial);
	lstPropDouble.append(dTimberWidth);
	lstPropDouble.append(dTimberHeight);
	
	lstPropInt.append(nZones);

	
	for( int e=0;e<_Element.length();e++ ){
		Element el = _Element[e];
	
		lstElements.setLength(0);
		lstElements.append(el);
	
		TslInst tsl;
		tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString);
	}

	eraseInstance();
	return;
}



if( _Element.length()<=0 )
{
	eraseInstance();
	return;
}

int nZone=nRealZones[nValidZones.find(nZones, 0)];

ElementWall el = (ElementWall)_Element[0];

if (!el.bIsValid()){
	eraseInstance();
	return;
}

//Element vectors
CoordSys csEl=el.coordSys();
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();
Point3d ptOrgEl=csEl.ptOrg();

_Pt0=ptOrgEl;

TslInst tslAll[]=el.tslInstAttached();
for (int i=0; i<tslAll.length(); i++)
{
	if ( tslAll[i].scriptName() == scriptName() && tslAll[i].handle() != _ThisInst.handle() )
	{
		tslAll[i].dbErase();
	}
}

LineSeg ls=el.segmentMinMax();

Line ln(el.ptOrg(), vx);

Point3d ptLeft=ls.ptStart();

Point3d ptRight=ls.ptEnd();

ptLeft=ln.closestPointTo(ptLeft);
ptRight=ln.closestPointTo(ptRight);
ptRight=ptRight-vy*dTimberHeight;

LineSeg ls1(ptLeft, ptRight);

PLine pl(vz);
pl.createRectangle(ls1, vx, vy);

PlaneProfile pp(pl);

Sheet sh;
sh.dbCreate(pp, dTimberWidth, 1);
sh.setName(sName);
sh.setMaterial(sMaterial);

sh.assignToElementGroup(el, true, nZone, 'Z');

eraseInstance();
return;

#End
#BeginThumbnail

#End
