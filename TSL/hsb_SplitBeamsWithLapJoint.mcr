#Version 8
#BeginDescription
Splits any beam that is longer than a property and create a lap joint connection between them.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 10.07.2013  -  version 1.0
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

* REVISION HISTORY
* -------------------------
*
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 10.07.2013
* version 1.0: Release Version
*
*/

PropDouble dMaxLength(0, U(5200), T("|Maximum length|"));

PropDouble dMinLength(1, U(500), T("|Minimum length|"));

double dLapSize=U(150);
int nLapSteps=2;

//---------------------------------------------------------------------------------------------------------------------
//                                                                       Insert

_ThisInst.setSequenceNumber(110);


if( _bOnInsert )
{
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}

	if (_kExecuteKey=="")
		showDialogOnce();
	
	PrEntity ssE(T("Select a set of elements"), Element());
	
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	return;
}

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

if( _Element.length() == 0 ){
	eraseInstance();
	return;
}

int nErase=false;

for( int e=0;e<_Element.length();e++ )
{
	Element el = _Element[e];
	
	Vector3d vx = el.vecX();
	Vector3d vy = el.vecY();
	Vector3d vz = el.vecZ();
	
	_Pt0=el.ptOrg();
	
	Beam bmAll[] = el.beam();
	if( bmAll.length() == 0 ) continue;
	
	Beam bmToSplit[0];
	
	for (int i=0; i<bmAll.length(); i++)
	{
		if (bmAll[i].solidLength()>(dMaxLength+U(2)))
		{
			bmToSplit.append(bmAll[i]);
		}
	}
	
	Beam bmToTool[0];
	
	for (int b=0; b<bmToSplit.length(); b++)
	{
		Beam bm=bmToSplit[b];
		bm.realBody().vis(32);
		
		double dBmLength=bm.solidLength();
		
		int nTimes=dBmLength/dMaxLength;
		Vector3d vxBm=bm.vecX();
		Line lnBm (bm.ptCen(), vxBm);

		Vector3d vyBm=bm.vecY();
		Vector3d vzBm=bm.vecZ();
		if (bm.dD(vyBm)>bm.dD(vzBm))
		{
			vyBm=bm.vecZ();
			vzBm=-bm.vecY();
		}

		double dLapHeight=bm.dD(vyBm)/(nLapSteps+1);
		int nFlip=1;
		while (nTimes>0)
		{
			dBmLength=bm.solidLength();
			
			Point3d arPtBm[] = bm.realBody().allVertices();
			arPtBm=lnBm.projectPoints(arPtBm);
			arPtBm=lnBm.orderPoints(arPtBm);
			Point3d ptBmStart=arPtBm[0];
			Point3d ptBmEnd=arPtBm[arPtBm.length()-1];
			Point3d ptSplit;
			
			if (dBmLength-dMaxLength>dMinLength)
			{
				ptSplit=ptBmStart+vxBm*dMaxLength;
			}
			else
			{
				ptSplit=ptBmStart-vxBm*dMinLength;
			}
				
			Point3d ptFaceBeam=ptSplit-(vyBm*nFlip)*(bm.dD(vyBm)*0.5);
			ptFaceBeam.vis(1);
			
			//Split the beam
			//Beam bmRes;
			Beam bmRes=bm.dbSplit(ptSplit-vxBm*(dLapSize*nLapSteps), ptSplit);				
			
			double dExtraA=U(1);
			//Tools for Original Beam
			for (int i=1; i<=nLapSteps; i++)
			{
				Point3d ptLapLocation=ptFaceBeam+(vyBm*nFlip)*(i*dLapHeight)-vxBm*(i*dLapSize);
				double dLapLength=dLapSize*(nLapSteps+1);
				BeamCut bcA(ptLapLocation, vxBm, vyBm, vzBm, dLapSize+dExtraA, bm.dD(vyBm)*2, bm.dD(vzBm)*2, 1, (1*nFlip), 0);
				bcA.cuttingBody().vis(i);
				bm.addToolStatic(bcA);
				
				if (i==1)
				{
					dExtraA=U(-0.1);
				}
				//Body dbA(ptLapLocation, vxBm, vyBm, vzBm, dLapLength, bm.dD(vyBm)*2, bm.dD(vzBm)*2, 1, (1*nFlip), 0);
				//SolidSubtract sosuA(dbA);
				//bm.addToolStatic(sosuA);
			}
			
			
			double dExtraB=U(-0.1);
			//Tools for Result Beam
			for (int i=1; i<=nLapSteps; i++)
			{
				if (i==nLapSteps)
				{
					dExtraB=U(1);
				}
				Point3d ptLapLocation=ptFaceBeam+(vyBm*nFlip)*(i*dLapHeight)-vxBm*((i-1)*dLapSize);
				double dLapLength=dLapSize*(nLapSteps+1);
				BeamCut bcB(ptLapLocation, vxBm, vyBm, vzBm, dLapSize+dExtraB, bm.dD(vyBm)*2, bm.dD(vzBm)*2, -1, (-1*nFlip), 0);
				bcB.cuttingBody().vis(i);
				bmRes.addToolStatic(bcB);
				
				//Body dbB(ptLapLocation, vxBm, vyBm, vzBm, dLapLength, bm.dD(vyBm)*2, bm.dD(vzBm)*2, -1, (-1*nFlip), 0);
				//SolidSubtract sosuB(dbB);
				//bmRes.addToolStatic(sosuB);
			}
			
			if (nFlip==1)
				nFlip=-1;
			else
				nFlip=1;
				
			bm=bmRes;

			nTimes--;
		}
	}
	nErase=true;
}
	
//---------------------------------------------------------------------------------------------------------------------
//                                                       Erase tsl. Beams are split.

if (_bOnElementConstructed || nErase)
{
	eraseInstance();
	return;
}









#End
#BeginThumbnail






















#End
