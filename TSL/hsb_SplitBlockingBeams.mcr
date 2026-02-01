#Version 8
#BeginDescription
Splits beams with a code between all the studs and sets the name to Blocking & Type to _kSFBlocking

Last modified by: Chirag Sawjani
08.04.2021  -  version 1.11
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 11
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
* date: 10.09.2009
* version 1.0: Release Version
*
* date: 16.09.2009
* version 1.1: Bugfix
*
* date: 18.05.2010
* version 1.2: Fix with Sequence and erase Instance
*
* date: 10.06.2010
* version 1.3: Remove a report notice
*
* date: 13.08.2010
* version 1.4: Copy the beam code of the parent beam to all the Dwangs Created
*
* date: 13.08.2010
* version 1.5: Change the way the valid areas are calculated so it's more robust.
*/

_ThisInst.setSequenceNumber(-10);

Unit(1,"mm"); // script uses mm

PropString sBeamCodesToSplit(0, "D", T("|Beam code to split|"));
PropString sBeamName(1, "BLOCKING", T("|Name of blockings|"));

double dMinLength=U(50);

if (_bOnDbCreated)
{
	setPropValuesFromCatalog(_kExecuteKey);
}

if(_bOnInsert)
{
	if (insertCycleCount()>1) { eraseInstance(); return; }
	if (_kExecuteKey=="")
		showDialogOnce();
	//_Map.setInt("nExecutionMode", 1);
	//showDialogOnce();
	//if (insertCycleCount()>1) { eraseInstance(); return; }
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

String sBeamCodes[0];
String sBeamCodeProperty=sBeamCodesToSplit;
sBeamCodeProperty.trimLeft();
sBeamCodeProperty.trimRight();
sBeamCodeProperty.makeUpper();
sBeamCodeProperty=sBeamCodeProperty+";";
for (int i=0; i<sBeamCodeProperty.length(); i++)
{
	String str=sBeamCodeProperty.token(i);
	str.trimLeft();
	str.trimRight();
	if (str.length()>0)
		sBeamCodes.append(str);
}

int nErase = false;

for (int e=0; e<_Element.length(); e++)
{
	Element el=_Element[e];
	
	CoordSys csEl = el.coordSys();
	Vector3d vx = csEl.vecX();
	Vector3d vy = csEl.vecY();
	Vector3d vz = csEl.vecZ();
	_Pt0=csEl.ptOrg();
	
	Plane plnZ (csEl.ptOrg(), vz);
	
	Beam bmAll[]=el.beam();
	Beam bmVer[]=vx.filterBeamsPerpendicularSort(bmAll);
	Beam bmHor[]=vy.filterBeamsPerpendicularSort(bmAll);
	if (bmVer.length()<1)	
	{
		return;
	}
	
	nErase = true;
	
	double dBeamWidth=bmVer[0].dD(vx);
	double dBeamHeight=bmVer[0].dD(vz);
	
	Beam bmToSplit[0];
	Beam bmNoBlocking[0];

	for (int i=0; i<bmAll.length(); i++)
	{
		Beam bm=bmAll[i];
		if (sBeamCodes.find(bm.beamCode().token(0).makeUpper(), -1) != -1)
		{
			bm.setType(_kSFBlocking);
			if(sBeamName!="") bm.setName(sBeamName);
			bmToSplit.append(bm);
		}
		else if (bm.beamCode().token(0)!="B") //Exclude beams with code B, this is because in CCG some battens were stoping the split and in some times deleting the beam that was in zone 0. because the extra beam with code B was a batten outside of zone 0.
		{
			bmNoBlocking.append(bm);
		}
	}


	PlaneProfile ppShapeBeams(csEl);
	
	for (int i = 0; i < bmNoBlocking.length(); i++)
	{
		Beam bm = bmNoBlocking[i];
		
		PlaneProfile ppBm(csEl);
		ppBm = bm.realBody().extractContactFaceInPlane(plnZ, U(dBeamHeight));
		
		ppBm .transformBy(U(0.01) * vy.rotateBy(i * 123.456, vz));
		ppBm.shrink(-U(2));
		ppShapeBeams.unionWith(ppBm);
		
	}
	
	ppShapeBeams.shrink(U(2));
	
	PlaneProfile ppShapeOpenings(csEl);
	Opening opAll[] = el.opening();
	
	for (int i=0; i<opAll.length(); i++)
	{ 
		ppShapeOpenings.joinRing(opAll[i].plShape(), false);
	}
	
	//ppShapeBeams.vis(1);
	ppShapeOpenings.vis(3);
	
	Point3d ptCentPointBeams[0];
	for (int i=0; i<bmToSplit.length(); i++)
	{
		Beam bm=bmToSplit[i];
		
		
		Plane plnBm (bm.ptCen(), vz);
		PlaneProfile ppFrontBeams(csEl);

		for (int b=0; b<bmAll.length(); b++)
		{
			Beam bmB=bmAll[b];
			String bmCode = bmB.beamCode();
			String firstToken = bmCode.token(0).trimLeft().trimRight().makeUpper(); 
			if (firstToken !=sBeamCodesToSplit.makeUpper())
			{
				PlaneProfile ppBm(csEl);
				ppBm = bmB.realBody().getSlice(plnBm);
				
				ppBm .transformBy(U(0.01)*vy.rotateBy(i*123.456,vz));
				ppBm.shrink(-U(2));
				ppFrontBeams.unionWith(ppBm);
			}
		}
		//ppFrontBeams.vis(2);
		
		PlaneProfile ppBm(csEl);
		//PlaneProfile ppBmOutline(csEl);
		ppBm = bm.realBody().shadowProfile(plnZ);
		ppBm.vis(5);
		
		//ppBmOutline=ppBm;
		
		ppBm.subtractProfile(ppFrontBeams);
		ppBm.shrink(-U(2));
		
		//ppBm.vis(3);
		
		Point3d ptToSplit[0];
		double dLengthBm[0];
		//central line in the split beam
		Vector3d vxBm=bm.vecX();

		Line lnSplitBm(bm.ptCen(),vxBm); 
		
		double dBmH=bm.dD(bm.vecY());
		double dBmW=bm.dD(bm.vecZ());
		
		PLine plAllRings[]=ppBm.allRings();
		int nIsOpening[]=ppBm.ringIsOpening();

		for (int j=0; j<plAllRings.length(); j++)
		{
			if (!nIsOpening[j])
			{
				PlaneProfile ppThisRing(plAllRings[j]);
				LineSeg ls=ppThisRing.extentInDir(vxBm);
				Point3d ptToCreate=lnSplitBm.closestPointTo(ls.ptMid());
				double dLBm=abs(vxBm.dotProduct(ls.ptStart()-ls.ptEnd()));
				
				if (dLBm>dMinLength)
				{
					ptToSplit.append(ptToCreate);
					dLengthBm.append(dLBm);
				}
			}
		}

		Beam bmAllBlocking[0];
		for(int j=0; j<ptToSplit.length(); j++)
		{
			//take the points where the nwe beam will be located
			ptToSplit[j].vis(2);
			
			Point3d ptToCreate=ptToSplit[j];
			double dNewLength=dLengthBm[j];
			
			if (ppShapeOpenings.pointInProfile(ptToCreate)== _kPointInProfile)
				continue;
			
			Beam bmBlock;
			bmBlock.dbCreate(ptToCreate, bm.vecX(), bm.vecY(), bm.vecZ(), dNewLength, dBmH, dBmW , 0, 0, 0);
			bmBlock.setType(_kSFBlocking);
			bmBlock.setName(bm.name());
			bmBlock.setMaterial(bm.material());
			bmBlock.setGrade(bm.grade());
			bmBlock.setColor(bm.color());
			bmBlock.setBeamCode(bm.beamCode());
			bmBlock.assignToElementGroup(el, TRUE, 0, 'Z');
			bmAllBlocking.append(bmBlock);
		}
		
		for (int b = 0 ; b < bmAllBlocking.length(); b++)
		{
			Beam bmA=bmAllBlocking[b];
			PlaneProfile ppBmOutline = bmA.envelopeBody(TRUE, TRUE).extractContactFaceInPlane(plnZ, dBeamHeight);
			ppBmOutline.shrink(U(2));
			ppBmOutline.intersectWith(ppShapeBeams);
			if (ppBmOutline.area()/(U(1)*U(1)) > U(10))
			{ 
				bmA.dbErase();
			}
		}
	}
	for (int i=0; i<bmToSplit.length(); i++)
	{
		bmToSplit[i].dbErase();
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
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End