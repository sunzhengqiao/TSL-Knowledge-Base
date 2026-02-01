#Version 8
#BeginDescription
Modified by: Alberto Jena (aj@hsb-cad.com)
17.06.2021  -  version 1.5
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 5
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
* Create by: Alberto Jena (aj@hsb-cad.com)
* date: 01.12.2011
* version 1.0: Release Version
*
* date: 16.10.2013
* version 1.1: Add the option to split also when intersect beams with a code.
*/

_ThisInst.setSequenceNumber(-70);

Unit(1,"mm"); // script uses mm

int nValidZones[]={1,2,3,4,5,6,7,8,9,10};
int nRealZones[]={1,2,3,4,5,-1,-2,-3,-4,-5};
PropString psZones(0, "", T("Zones to split the Sheets"));
psZones.setDescription(T("Please type the number of the zones separate by ; (1-10)"));

//if (_bOnDbCreated)
//{
//	setPropValuesFromCatalog(_kExecuteKey);
//}

if(_bOnInsert)
{
	if (insertCycleCount()>1) { eraseInstance(); return; }
	if (_kExecuteKey=="")
		showDialogOnce();
		
	PrEntity ssE("\n"+T("Select a set of elements"),Element());
	
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	return;
}

if (_Element.length()==0)
{
	eraseInstance();
	return;
}

int nErase=FALSE;
int nZones[0];

//Fill the values for the externall Walls
String sZones=psZones;
sZones.trimLeft();
sZones.trimRight();
sZones=sZones+";";
for (int i=0; i<sZones.length(); i++)
{
	String str=sZones.token(i);
	str.trimLeft();
	str.trimRight();
	if (str.length()>0)
	{
		int nIndex=nValidZones.find(str.atoi());
		if(nIndex!=-1)
		{
	  		nZones.append(nRealZones[nIndex]);
		}
	}
}

int nZonesToSplit[0];

for (int e = 0; e < _Element.length(); e++)
{
	Element el = _Element[e];
	
	CoordSys csEl = el.coordSys();
	Vector3d vx = csEl.vecX();
	Vector3d vy = csEl.vecY();
	Vector3d vz = csEl.vecZ();
	_Pt0 = csEl.ptOrg();
	
	//Find automatically the batten zone and split any beam that interfere with the openings
	for (int x = 0; x < nRealZones.length(); x++)
	{
		int nZone = nRealZones[x];
		ElemZone elZ = el.zone(nZone);
		
		String sDistribution = elZ.code();
		//Ensure the TSL only works on vertical sheets and no other type of distribution
		//reportNotice("\n"+sDistribution);
		if (sDistribution != "HSB-PL09")
		 { continue;}
		else
		{
			nZonesToSplit.append(nZone);
		}
	}
	
	for (int i=0; i<nZones.length(); i++)
	{ 
		if (nZonesToSplit.find(nZones[i],-1)==-1)
		{ 
			nZonesToSplit.append(nZones[i]);
		}
	}
	
	
	Plane pln (csEl.ptOrg(), vz);
	
	PlaneProfile ppOp(csEl);
	
	Opening opAll[] = el.opening();
	
	for (int o = 0; o < opAll.length(); o++)
	{
		OpeningSF op = (OpeningSF) opAll[o];
		if ( ! op.bIsValid())
			continue;
		
		PlaneProfile ppTemp(csEl);
		ppTemp.joinRing(op.plShape(), FALSE);
		
		PlaneProfile ppAux = ppTemp;
		ppAux.transformBy(-vx * op.dGapSide());
		ppTemp.unionWith(ppAux);
		ppAux.transformBy(vx * op.dGapSide() * 2);
		ppTemp.unionWith(ppAux);
		
		PlaneProfile ppAux2 = ppTemp;
		ppAux2.transformBy(vy * op.dGapTop());
		ppTemp.unionWith(ppAux2);
		
		PlaneProfile ppAux3 = ppTemp;
		ppAux3.transformBy(-vy * op.dGapBottom());
		ppTemp.unionWith(ppAux3);
		
		ppTemp.shrink(-U(5));
		ppOp.unionWith(ppTemp);
	}
	
	ppOp.shrink(U(5));
	
	Sheet shWork[0];
	Sheet shToErase[0];
	for (int n = 0; n < nZonesToSplit.length(); n++)
	{
		int nZone = nZonesToSplit[n];
		Sheet shThis[] = el.sheet(nZone);
		
		ElemZone elZ = el.zone(nZone);
		
		Plane plnThisZOne(elZ.ptOrg(), elZ.vecZ());
		
		for (int i = 0; i < shThis.length(); i++)
		{
			Sheet sh = shThis[i];
			PlaneProfile ppSh = sh.profShape();
			PlaneProfile ppShOriginal = ppSh;
			int nRecreate = false;
			if (ppSh.intersectWith(ppOp))
			{
				if ((ppSh.area() / U(1) * U(1)) > U(5))
				{
					ppShOriginal.subtractProfile(ppOp);
					nRecreate = true;
				}
			}
			
			if (nRecreate)
			{
				shToErase.append(sh);
				PLine plAllRings[] = ppShOriginal.allRings();
				int nIsOpening[] = ppShOriginal.ringIsOpening();
				
				for (int j = 0; j < plAllRings.length(); j++)
				{
					if ( ! nIsOpening[j])
					{
						PlaneProfile pp(plnThisZOne);
						pp.joinRing(plAllRings[j], false);
						Sheet shNew;
						shNew.dbCreate(pp, sh.dH(), 1);
						shNew.setName(sh.name());
						shNew.setMaterial(sh.material());
						shNew.setColor(sh.color());
						shNew.assignToElementGroup(el, true, nZone, 'Z');
					}
				}
				nErase = true;
				ppShOriginal.vis();
			}
			
		}
	}
	for (int j = 0; j < shToErase.length(); j++)
	{
		shToErase[j].dbErase();
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