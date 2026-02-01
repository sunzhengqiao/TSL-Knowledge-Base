#Version 8
#BeginDescription
Last modified by: Alberto Jena (aj@hsb-cad.com)
13.02.2012  -  version 1.0























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
* date: 13.02.2012
* version 1.0: Release Version
*
*/

//-----------------------------------------------------------------------------------------------------------------------------------
//                                                                      Properties

//_ThisInst.setSequenceNumber(120);

//if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey); 

//-----------------------------------------------------------------------------------------------------------------------------------
//                                                                           Insert

if(_bOnInsert){
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	//if (_kExecuteKey=="")
	//	showDialogOnce();
	PrEntity ssE("\n"+T("Select a set of elements"),Element());
	
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	return;
}


if( _Element.length()==0 ){
	eraseInstance();
	return;
}

//-----------------------------------------------------------------------------------------------------------------------------------
//          Loop over all elements.


int nBmTypeToAvoid[0];
nBmTypeToAvoid.append(_kHeader);
nBmTypeToAvoid.append(_kSill);
nBmTypeToAvoid.append(_kSFTransom);
nBmTypeToAvoid.append(_kSFPacker);
nBmTypeToAvoid.append(_kSFJackOverOpening);
nBmTypeToAvoid.append(_kSFJackUnderOpening);
nBmTypeToAvoid.append(_kSFSupportingBeam);
nBmTypeToAvoid.append(_kKingStud);

int nErase=false;

for( int e=0; e<_Element.length(); e++ )
{
	ElementWallSF el=(ElementWallSF) _Element[e];
	
	if (!el.bIsValid()) continue;
	
	CoordSys csEl=el.coordSys();
	Vector3d vx=csEl.vecX();
	Vector3d vy=csEl.vecY();
	Vector3d vz=csEl.vecZ();
	Point3d ptOrgEl=csEl.ptOrg();
	
	Plane pln (ptOrgEl, vz);
	
	PLine plEnvEl=el.plEnvelope();
	Point3d ptVertexEl[]=plEnvEl.vertexPoints(FALSE);
	
	//Some values and point needed after
	Point3d ptFront=el.zone(1).coordSys().ptOrg(); ptFront.vis(1);
	Point3d ptBack=el.zone(-1).coordSys().ptOrg(); ptBack.vis(1);
	
	double dWallThickness=abs(vz.dotProduct(ptFront-ptBack));
	
	Beam bmAll[]=el.beam();
	
	Sheet shAll[]=el.sheet(0);
	
	String sModuleNames[0];
	
	for (int i=0; i<bmAll.length(); i++)
	{
		String sModule=bmAll[i].module();
		if (sModuleNames.find(sModule, -1) == -1)
		{
			sModuleNames.append(sModule);
		}
	}
	
	for (int m=0; m<sModuleNames.length(); m++)
	{
		String sThisModule=sModuleNames[m];
		
		Beam bmThisModule[0];
		for (int b=0; b<bmAll.length(); b++)
		{
			if (bmAll[b].module()==sThisModule)
			{
				bmThisModule.append(bmAll[b]);
			}
		}
		
		if (bmThisModule.length()<1) continue;
		
		Beam bmModule[]=vx.filterBeamsPerpendicularSort(bmThisModule);
		Point3d ptLeft=bmModule[0].ptCen();
		Point3d ptRight=bmModule[bmModule.length()-1].ptCen();
		
		LineSeg ls(ptLeft-vy*U(3000), ptRight+vy*U(3000));
		PLine pl(vz);
		pl.createRectangle(ls, vx, vy);
		
		PlaneProfile ppOp(pl);
		
		for (int i=0; i<shAll.length(); i++)
		{
			Sheet sh=shAll[i];
			PlaneProfile ppSh(csEl);
			ppSh=sh.realBody().shadowProfile(pln);
			if (ppSh.intersectWith(ppOp))
			{
				sh.setModule(sThisModule);
			}
		}
	}

	nErase=true;
}

//-----------------------------------------------------------------------------------------------------------------------------------
//                                                                 Erase instance

if (_bOnElementConstructed || nErase)
{
	eraseInstance();
	return;
}













#End
#BeginThumbnail

#End
