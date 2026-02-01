#Version 8
#BeginDescription
Cuts in an angle the blocking that intersects the angled top plates leaving a clean connection.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 21.05.2010 - version 1.1

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
* date: 07.05.2010
* version 1.0: Release Version
*
* date: 21.05.2010
* version 1.1: Implement sequence number
*/

_ThisInst.setSequenceNumber(40);

Unit(1,"mm"); // script uses mm

int nBmType[0];
String sBmName[0];

if(_bOnInsert)
{
	if( insertCycleCount()>1 )
	{
		eraseInstance();
		return;
	}

	if (_kExecuteKey=="")
		showDialogOnce();

	PrEntity ssE(T("Select one or More Elements"), ElementWallSF());
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	//Insert the TSL again for each Element
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
	
	Map mpToClone;
	mpToClone.setInt("ExecutionMode",0);

	for (int i=0; i<_Element.length(); i++)
	{
		lstEnts.setLength(0);
		lstEnts.append(_Element[i]);
		tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mpToClone);
	}

	_Map.setInt("ExecutionMode",0);
	eraseInstance();
	return;
}

double dHeightAr[0];

if (_Element.length()==0)
{
	eraseInstance();
	return;
}

if (_bOnElementConstructed)
{
	_Map.setInt("ExecutionMode",0);
}

int nExecutionMode = 1;
if (_Map.hasInt("ExecutionMode"))
{
	nExecutionMode = _Map.getInt("ExecutionMode");
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
_Pt0=csEl.ptOrg();

//if (nExecutionMode==0)
{	
	_Map=Map();
	Beam bmAll[]=el.beam();
	Beam bmBlocking[0];
	Beam bmAllAngle[0];
	
	for (int i = 0; i < bmAll.length(); i++)
	{
		int nType=bmAll[i].type();
		if ( nType==_kSFAngledTPLeft || nType==_kSFAngledTPRight )
		{
			bmAllAngle.append(bmAll[i]);
		}else
		if (nType==_kSFBlocking)
		{
			bmBlocking.append(bmAll[i]);
		}
	}
	
	for (int i=0; i<bmAllAngle.length(); i++)
	{
		Beam bmAngle=bmAllAngle[i];
		bmAngle.realBody().vis();
		Plane plnZ (csEl.ptOrg(), vz);
		PlaneProfile ppBmAngle(csEl);
		ppBmAngle = bmAngle.realBody().extractContactFaceInPlane(plnZ, U(90));
		
		for (int b = 0 ; b < bmBlocking.length(); b++)
		{
			Beam bm=	bmBlocking[b];
			//bm.realBody().vis(2);
			PlaneProfile ppBm = bm.envelopeBody(TRUE, TRUE).extractContactFaceInPlane(plnZ, U(90));
			ppBm.intersectWith(ppBmAngle);
			ppBm.vis(1);
			if (ppBm.area()/(U(1)*U(1)) > U(5))
			{
				/*Line lnX (bm.vecX(), bm.vecX());
				Line lnAngle (bmAngle.ptCen(), bmAngle.vecX());
				Point3d ptIntersect=lnX.closestPointTo(lnAngle);
				Vector3d vDirection(ptIntersect-bm.ptCen());
				vDirection.normalize();
				Vector3d vTool=bmAngle.vecD(vDirection);vTool.vis(bm.ptCen(), 2);
				
				Plane plnBottom (bmAngle.ptCen()-vTool*(bmAngle.dD(vTool)*0.5), vTool);
				Point3d ptTool=lnX.intersect(plnBottom, U(0));	
				vTool.vis(ptTool, 1);
				Cut ct (ptIntersect, vTool);
				*/
				
				//bm.addToolStatic(ct, _kStretchOnToolChange);
				bm.stretchStaticTo(bmAngle, true);

			}
		}
	}
}


if (_bOnElementConstructed)
{
	eraseInstance();
	return;
}


#End
#BeginThumbnail


#End
