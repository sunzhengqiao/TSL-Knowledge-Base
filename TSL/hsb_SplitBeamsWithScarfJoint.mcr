#Version 8
#BeginDescription
Splits any beam that is longer than a property and create a lap joint connection between them.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 01.02.2016  -  version 1.4


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
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
* date: 09.06.2015
* version 1.0: Release Version
*
*/

PropDouble dMaxLength(0, U(5000), T("|Maximum length|"));
PropDouble dMinLength(1, U(2500), T("|Minimum length|"));

double dLapSize=U(300);
//int nLapSteps=3;

//---------------------------------------------------------------------------------------------------------------------
//                                                                       Insert

_ThisInst.setSequenceNumber(110);


if( _bOnInsert )
{
	if( insertCycleCount()>1 )
	{
		eraseInstance();
		return;
	}

	if (_kExecuteKey=="")
		showDialogOnce();
	
	PrEntity ssE(T("Select a set of elements"), Element());
	
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	_Map.setInt("ExecutionMode",0); //Element with no beams
	
	return;
}


if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

if( _Element.length() == 0 ){
	eraseInstance();
	return;
}

//Modes
// 0=Master...  will split the beam and pass the 2 beams to the slave for tooling
// 1=Slave... Will add the tooling for the scarfjoint

int nExecutionMode = 1;
if (_Map.hasInt("ExecutionMode"))
{
	nExecutionMode = _Map.getInt("ExecutionMode");
}

//reportNotice("\nExecution Mode: "+nExecutionMode );

Display dp(1);


for( int e=0;e<_Element.length();e++ )
{
	Element el = _Element[e];
	
	Vector3d vx = el.vecX();
	Vector3d vy = el.vecY();
	Vector3d vz = el.vecZ();
	
	//_Pt0=el.ptOrg();
	
	if (nExecutionMode==0) //Master will find the beams that need the Split
	{
		//Prepare the TSL to clone
		TslInst tsl;
		String sScriptName = scriptName(); // name of the script
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		Entity lstEnts[0];
		Beam lstBeams[0];
		Point3d lstPoints[0];
		int lstPropInt[0];
		String lstPropString[0];
		double lstPropDouble[0];
		lstPropDouble.append(dMaxLength);
		lstPropDouble.append(dMinLength);
		
		Map mpToClone;
		mpToClone.setInt("ExecutionMode",1);

		//Do the analisys of which beams need to be split

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

		for (int b=0; b<bmToSplit.length(); b++)
		{
			Beam bm=bmToSplit[b];
			
			if (bm.extrProfile()!=_kExtrProfRectangular) continue;
			
			double dBmLength=bm.solidLength();
			
			int nTimes=dBmLength/dMaxLength;
			Vector3d vxBm=bm.vecX();
			Line lnBm (bm.ptCen(), vxBm);
			
			//reportNotice("\nRun this time: "+nTimes);
			
			Vector3d vyBm=bm.vecY();
			Vector3d vzBm=bm.vecZ();
			if (bm.dD(vyBm)>bm.dD(vzBm))
			{
				vyBm=bm.vecZ();
				vzBm=-bm.vecY();
			}
	
			int nFlip=1;
			int nCount=0;
			while (nTimes>0)
			{
				nCount++;
				dBmLength=bm.solidLength();
				Point3d arPtBm[] = bm.realBody().allVertices();
				arPtBm=lnBm.projectPoints(arPtBm);
				arPtBm=lnBm.orderPoints(arPtBm);
				Point3d ptBmStart=arPtBm[0];
				Point3d ptBmEnd=arPtBm[arPtBm.length()-1];
				Point3d ptSplit;
				
				if (dBmLength-dMaxLength>dMinLength-dLapSize)
				{
					ptSplit=ptBmStart+vxBm*dMaxLength;
				}
				else
				{
					ptSplit=ptBmEnd-vxBm*(dMinLength-dLapSize);
				}
				
				Point3d ptMiddle=LineSeg(ptSplit-vxBm*(dLapSize), ptSplit).ptMid();
				
				//Split the beam
				Beam bmRes=bm.dbSplit(ptSplit-vxBm*(dLapSize), ptSplit);
				
				lstEnts.setLength(0);
				lstBeams.setLength(0);
				lstPoints.setLength(0);
				lstEnts.append(el);
				lstBeams.append(bm);
				lstBeams.append(bmRes);
				lstPoints.append(ptMiddle);
				tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mpToClone);
				tsl.setPtOrg(ptMiddle);
				
				if (bmRes.solidLength()<dMaxLength) break;
				
				bm=bmRes;
				
				if (nCount>20) break;
			}

		}
		_Map.setInt("ExecutionMode",1);
		eraseInstance();
		return;
	}
	else if (nExecutionMode==1) //Slave will split the beam in _Beam in the specified point
	{


		if (_Beam.length()<2)
		{
			eraseInstance();
			return;
		}
		Beam bm=_Beam0;
		Beam bmRes=_Beam1;
		
		Line lnX(bm.ptCen(), bm.vecX());
		Point3d ptMiddle=lnX.closestPointTo(_Pt0);
		_Pt0=ptMiddle;
		
		Vector3d vxBm=bm.vecX();
		Line lnBm (bm.ptCen(), vxBm);

		Vector3d vyBm=bm.vecY();
		Vector3d vzBm=bm.vecZ();
		if (bm.dD(vyBm)>bm.dD(vzBm))
		{
			vyBm=bm.vecZ();
			vzBm=-bm.vecY();
		}
		
		double dLapHeight=bm.dD(vyBm)/3;
		
		Vector3d vNormalBmTool=vyBm; // set an arbitrary posible orientation
		Vector3d vNormalBmResTool=-vyBm; // set an arbitrary posible orientation
		
		TslInst AllTSLBm1[]=el.tslInstAttached();
		
		for (int i=0; i<AllTSLBm1.length(); i++)
		{
			if (AllTSLBm1[i].scriptName()==_ThisInst.scriptName())
			{
				Map mpTSL=AllTSLBm1[i].map();
				for (int i=0; i<mpTSL.length(); i++)
				{
					if (mpTSL.hasVector3d(bm.handle()))
					{
						vNormalBmTool=mpTSL.getVector3d(bm.handle());
						vNormalBmResTool=-vNormalBmTool;
						break;
					}
					else if (mpTSL.hasVector3d(bmRes.handle()))
					{
						vNormalBmResTool=mpTSL.getVector3d(bmRes.handle());
						vNormalBmTool=-vNormalBmResTool;
						break;
					
					}
				}
			}
		}
		

		SimpleScarf ss(ptMiddle, vxBm, vNormalBmTool, dLapSize, dLapHeight);
		bm.addTool(ss, _kStretchOnInsert); 
		
		SimpleScarf ss2(ptMiddle, -vxBm, vNormalBmResTool, dLapSize, dLapHeight);
		bmRes.addTool(ss2, _kStretchOnInsert);
		
		//Display
		PLine pl1(ptMiddle-bm.vecX()*U(4), ptMiddle+bm.vecX()*U(4) );
		PLine pl2(ptMiddle-bm.vecY()*U(4), ptMiddle+bm.vecY()*U(4) );
		dp.draw(pl1);
		dp.draw(pl2);
		
		//Map mp1();
		//mp1.setString("Handle", bmRes.handle());
		//mp1.setVector3d("Normal", -vyBm);
		
		//_Map.setMap("Beam0", mp0);
		//_Map.setMap("Beam1", mp1);
		_Map.setVector3d(bm.handle(), vNormalBmTool);
		_Map.setVector3d(bmRes.handle(), vNormalBmResTool);
	}
	assignToElementGroup(el, true, 0, 'E');
}



Map mp;
mp.setDouble ("ScarfLength", dLapSize);
_Map.setMap("ScarfInformation", mp);
#End
#BeginThumbnail








#End