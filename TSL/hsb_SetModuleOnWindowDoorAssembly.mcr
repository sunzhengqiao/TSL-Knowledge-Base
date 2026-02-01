#Version 8
#BeginDescription
Created by: Alberto Jena (aj@hsb-cad.com)
date: 28.08.2012 - version: 1.0

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
*  Copyright (C) 2012 by
*  ITW Industry 
*  UK
*
*  The program may be used and/or copied only with the written
*  permission from hsbSOFT, or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.

* REVISION HISTORY
* -------------------------
*
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 28.08.2012
* version 1.0: Release Version
*
*/

_ThisInst.setSequenceNumber(-120);

Unit(1,"mm"); // script uses mm

if(_bOnInsert)
{
	if( insertCycleCount()>1 )
	{
		eraseInstance();
		return;
	}

	//if (_kExecuteKey=="")
	//	showDialogOnce();

	PrEntity ssE(T("Select one or More Elements"), ElementWallSF());
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	return;
}

if (_bOnDbCreated || _bOnInsert){	setPropValuesFromCatalog(_kExecuteKey);}

int nErase=false;

for (int e=0; e<_Element.length(); e++)
{
	Element el=_Element[e];
	
	if (!el.bIsValid()) continue;
	
	CoordSys csEl = el.coordSys();
	Vector3d vx = csEl.vecX();
	Vector3d vy = csEl.vecY();
	Vector3d vz = csEl.vecZ();
	Point3d ptEl = csEl.ptOrg();
	
	Opening opAll[]=el.opening();
	
	Beam bmAll[]=el.beam();
	
	if (bmAll.length()==0)
		continue;
		
	nErase=true;
	
	Plane plnZ(ptEl, vz);
	
	//Sort the openings from left to right
	
	for (int o=0; o<opAll.length(); o++)
	{
		CoordSys csOp1=opAll[o].coordSys();
		Point3d ptOrgOp1=csOp1.ptOrg();
		for (int p=0; p<opAll.length(); p++)
		{
			CoordSys csOp2=opAll[p].coordSys();
			Point3d ptOrgOp2=csOp2.ptOrg();
			if (vx.dotProduct(ptOrgOp1-ptEl)<vx.dotProduct(ptOrgOp2-ptEl))
			opAll.swap(o, p);
		}
	}
	
	//loop all the openings
	String sUsedOpening[0];
	
	for (int o=0; o<opAll.length()-1; o++)
	{
		Opening op=opAll[o];
		
		Opening opInAssembly[0];
		PlaneProfile ppAssemblyOp[0];
		String sThisHandle=op.handle();
		
		if (sUsedOpening.find(sThisHandle, -1) != -1)
			continue;
		
		
		PLine plOpShape=op.plShape();
		PlaneProfile ppOp(plnZ);
		ppOp.joinRing(plOpShape, false);
		
		ppOp.shrink(-U(40));
		
		int nIntersect=false;
		int nFlag=0;
		int nNextOp=o+1;
		
		opInAssembly.append(op);
		ppAssemblyOp.append(ppOp);
		sUsedOpening.append(sThisHandle);
		
		
		
		//find all the openings that are intersecting with the one in o location
		do
		{
			Opening opNext=opAll[nNextOp];
		
			PLine plOpShapeNext=opNext.plShape();
			PlaneProfile ppOpNext(plnZ);
			ppOpNext.joinRing(plOpShapeNext, false);
		
			ppOpNext.shrink(-U(40));
			
			ppOpNext.vis();
			
			PlaneProfile ppAux=ppOp;
			
			ppAux.intersectWith(ppOpNext);
			
			if ((ppAux.area()/(U(1)*U(1))) > (U(5)*U(5)))
			{
				ppOp.unionWith(ppOpNext);
				opInAssembly.append(opNext);
				sUsedOpening.append(opNext.handle());
				ppAssemblyOp.append(ppOpNext);
				
				nNextOp++;
				nIntersect=true;
			}
			else
			{
				nIntersect=false;
			}
			
			nFlag++;
			
		}while ((nIntersect && nNextOp<opAll.length()) && nFlag<20);
		
		ppOp.vis(2);
		//get all the module names of the beams that are around the opening assembly
		String sAssemblyModules[0];
		if (opInAssembly.length()>1)
		{
			for (int j=0; j<opInAssembly.length(); j++)
			{
				for (int i=0; i<bmAll.length(); i++)
				{
					Beam bm=bmAll[i];
					PlaneProfile ppBm=bm.envelopeBody().shadowProfile(plnZ);
					ppBm.intersectWith(ppAssemblyOp[j]);
					if (ppBm.area()/U(1)*U(1)>U(5)*U(5))
					{
						String sModule=bm.module();
						if (sAssemblyModules.find(sModule, -1)==-1)
						{
							if (sModule!="")
							{
								sAssemblyModules.append(sModule);
							}
						}
					}
				}
			}
		}
		
		//Reset the module information of the beams around the assembly
		//reportNotice("\n"+sAssemblyModules);
		if (sAssemblyModules.length()>0)
		{
			for (int j=0; j<bmAll.length(); j++)
			{
				Beam bm=bmAll[j];
				String sThisBmModule=bm.module();
				
				if (sAssemblyModules.find(sThisBmModule, -1) != -1)
				{
					bm.setModule(sAssemblyModules[0]);
					//bm.setColor(o+1);
				}
			}
		}
	}
}

if (_bOnElementConstructed || nErase)
{
	eraseInstance();
	return;
}



#End
#BeginThumbnail

#End
