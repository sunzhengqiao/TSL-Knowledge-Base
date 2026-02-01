#Version 8
#BeginDescription
Convert the beams with a beam code into sheets and assign it to a specific zone.

Created by: Alberto Jena
Date: 15.11.2020 - version 1.6







#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 6
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
* date: 09.03.2011
* version 1.0: Release Version
*
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 14.04.2011
* version 1.1: Added Property for Zones
*
* date: 22.11.2012
* version 1.2: Add the option to select a zone and will convert all the beams of that zone into sheets
*
* date: 23.01.2014
* version 1.3: Control the color of the new sheet
*
* date: 30.10.2015
* version 1.4: Added other beam properties into sheet e.g. label, sublabel etc.
*/

_ThisInst.setSequenceNumber(-100);

Unit(1,"mm"); // script uses mm

String sOptions[]={T("|By Beam Code|"), T("|By Zone|")};

PropString sOption(1, sOptions, T("|Convert Type|"));

PropString sFilterBeams(0, "", T("|Convert Beams with Code|"));
sFilterBeams.setDescription(T("|Separate multiple entries by|") +" ';'");

PropInt nColor(0, 6, T("Color for the new sheet"));
nColor.setDescription("Set the color of the battens, (-1) will keep the existing color");

int nValidZones[]={0,1,2,3,4,5,6,7,8,9,10};
int nRealZones[]={0,1,2,3,4,5,-1,-2,-3,-4,-5};
PropInt nZones (1, nValidZones, T("Zone to Select or Assign the Sheets"));

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

if(_bOnInsert)
{
	//_Map.setInt("nExecutionMode", 1);
	//showDialogOnce();
	if (insertCycleCount()>1) { eraseInstance(); return; }
	
	if (_kExecuteKey=="")
		showDialogOnce();
	
	PrEntity ssE("\n"+T("Select a set of elements"),Element());
	
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	return;
}

int nOption=sOptions.find(sOption, 0);
int nZone=nRealZones[nValidZones.find(nZones, 0)];


if (_Element.length()==0)
{
	eraseInstance();
	return;
}

// transform filter tsl property into array
String sBeamFilter[0];
String sList = sFilterBeams;

while (sList.length()>0 || sList.find(";",0)>-1)
{
	String sToken = sList.token(0);	
	sToken.trimLeft();
	sToken.trimRight();		
	sToken.makeUpper();
	sBeamFilter.append(sToken);
	//double dToken = sToken.atof();
	//int nToken = sToken.atoi();
	int x = sList.find(";",0);
	sList.delete(0,x+1);
	sList.trimLeft();	
	if (x==-1)
		sList = "";
}

int nErase=FALSE;

for (int e=0; e<_Element.length(); e++)
{
	Element el=_Element[e];
	
	CoordSys csEl = el.coordSys();
	Vector3d vx = csEl.vecX();
	Vector3d vy = csEl.vecY();
	Vector3d vz = csEl.vecZ();
	_Pt0=csEl.ptOrg();

	Beam bmAll[]=el.beam();
	Beam bmToRemove[0];
	Beam bmToConvert[0];
	
	for (int i=0; i<bmAll.length(); i++)
	{
		Beam bm=bmAll[i];
		if ( nOption==0 )
		{
			if (sBeamFilter.find(bm.beamCode().token(0), -1) != -1 )
			{
				bmToConvert.append(bm);
			}
		}
		else if (nOption==1)
		{
			if(bm.myZoneIndex()==nZone)
			{
				bmToConvert.append(bm);
			}
		}
	}
	
	int nCurrentColor=-1;
	
	for (int i=0; i<bmToConvert.length(); i++)
	{
		Beam bm=bmToConvert[i];
		nCurrentColor=bm.color();
		Vector3d vyBm=bm.vecY();
		Vector3d vzBm=bm.vecZ();
		Vector3d vxBm=bm.vecX();
				
		CoordSys csBm(bm.ptCen(), vyBm, vxBm,  vyBm.crossProduct(vxBm));
		
		Vector3d vNormal=vzBm;
		if (bm.dD(vyBm)<bm.dD(vzBm))
		{
			vNormal=vyBm;
			csBm=CoordSys(bm.ptCen(), vzBm, vxBm, vzBm.crossProduct(vxBm));
		}
		
		//vNormal.vis(bm.ptCen());
		//csBm.vis();
		double dThick=bm.dD(vNormal);
		Plane pln(bm.ptCen(), vNormal);
		PlaneProfile ppBm(csBm);
		//ppBm.transformBy(csBm);
		PlaneProfile ppSlice=bm.realBody().getSlice(pln);
		ppBm.unionWith(ppSlice);
		ppBm.vis(i);
		Sheet sh;
		sh.dbCreate(ppBm, dThick, 0);
		sh.setName(bm.name());
		sh.setMaterial(bm.material());
		sh.setGrade(bm.grade());
		sh.setLabel(bm.label());
		sh.setSubLabel(bm.subLabel());
		sh.setSubLabel2(bm.subLabel2());
		sh.setInformation(bm.information());
		sh.setModule(bm.module());
		sh.setBeamCode(bm.beamCode());
		
		if (nColor>-1)
		{
			sh.setColor(nColor);
		}
		else
		{
			if (nCurrentColor>-1)
				sh.setColor(nCurrentColor);
		}
		sh.assignToElementGroup(el, true, nZone ,'Z');
		bmToRemove.append(bm);
	}
	
	for (int i=0; i<bmToRemove.length(); i++)
	{
		nErase=TRUE;
		bmToRemove[i].dbErase();
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