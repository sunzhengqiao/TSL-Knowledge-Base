#Version 8
#BeginDescription
Removes framing and sheets under doors for stickframe walls for e.g. floating floor to run through.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 21.03.2012  -  version 1.3








#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
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
* date: 03.03.2010
* version 1.0: Release Version
*
* date: 18.05.2010
* version 1.1: Fix with Sequence and erase Instance
*
* date: 16.03.2012
* version 1.2: Add A bigger door size
*
* date: 21.03.2012
* version 1.3: Added bIsValid before running plEnvelope 
*/

_ThisInst.setSequenceNumber(-110);

Unit(1,"mm"); // script uses mm

int nBmType[0];
nBmType.append(_kBrace);
nBmType.append(_kSFJackUnderOpening);
nBmType.append(_kSill);

if(_bOnInsert)
{
	if (insertCycleCount()>1) { eraseInstance(); return; }
	PrEntity ssE(T("Please select Elements"),Element());
 	if (ssE.go())
	{
 		Entity ents[0];
 		ents = ssE.set();
 		for (int i = 0; i < ents.length(); i++ )
		 {
 			Element el = (Element) ents[i];
 			_Element.append(el);
 		 }
 	}
	return;
}

if (_Element.length()==0)
{
	eraseInstance();
	return;
}

int nErase=false;

for (int e=0; e<_Element.length(); e++)
{
	Element el=_Element[e];
	
	CoordSys csEl = el.coordSys();
	Vector3d vx = csEl.vecX();
	Vector3d vy = csEl.vecY();
	Vector3d vz = csEl.vecZ();
	_Pt0=csEl.ptOrg();
	
	Plane pln (csEl.ptOrg(), vz);
	
	Opening opAll[]=el.opening();
	Opening opDoors[0];
	
	for (int i=0; i<opAll.length(); i++)
	{
		if (opAll[i].openingType()==_kDoor)
			opDoors.append(opAll[i]);
	}
	
	if (opDoors.length()<1)
		continue;
	
	Beam bmAll[]=el.beam();
	Beam bmToCheck[0];
	
	for (int i=0; i<bmAll.length(); i++)
	{
		int nBeamType=bmAll[i].type();
		if (nBmType.find(nBeamType, -1) != -1)
		{
			bmToCheck.append(bmAll[i]);
		}
		nErase=true;
	}

	Sheet shAll[]=el.sheet();

	for (int o=0; o<opDoors.length(); o++)
	{
		Opening op=opDoors[o];
		PLine plOp=op.plShape();
		PlaneProfile ppOp(csEl);
		ppOp.joinRing(plOp, FALSE);
		ppOp.transformBy(vy*U(-500));
		//Remove the Beams that have intersection with the door
		for (int i=0; i<bmToCheck.length(); i++)
		{
			Beam bm=bmToCheck[i];
			PlaneProfile ppBm(csEl);
			ppBm=bm.realBody().shadowProfile(pln);
			double dArea=ppBm.area();
			dArea=dArea/(U(1)*U(1));
			int nResult=ppBm.intersectWith(ppOp);
			
			if (nResult)
			{
				double dAreaResult=ppBm.area();
				dAreaResult=dAreaResult/(U(1)*U(1));
				if (dAreaResult>(dArea*.95))
				{
					bm.dbErase();
				}
			}
		}
		//Remove the sheets that have intersection with the Bottom of the door
		for (int i=0; i<shAll.length(); i++)
		{
			Sheet sh=shAll[i];
			if(!sh.bIsValid()) continue;
			PlaneProfile ppSh(csEl);
			ppSh.joinRing(sh.plEnvelope(), FALSE);
			double dArea=ppSh.area();
			dArea=dArea/(U(1)*U(1));
			int nResult=ppSh.intersectWith(ppOp);

			if (nResult)
			{
				double dAreaResult=ppSh.area();
				dAreaResult=dAreaResult/(U(1)*U(1));
				if (dAreaResult>(dArea*.95))
				{
					sh.dbErase();
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
