#Version 8
#BeginDescription


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
*  Copyright (C) 2024 by
*  hsbcad 
*  
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
*
*/

Unit (1, "mm");

String sArNY[] = {T("No"), T("Yes")};

PropString sWalls (0, "EA;EB;", T("Wall codes for calculation"));
sWalls.setDescription("Please set the wall codes that should be used for the calculations. To add more than 1 use ';' after each code");

PropDouble dSoleplateHeight(0, 38, T("Soleplate thickness]"));

PropDouble dHeadbinderHeight(1, 38, T("Headbinder height"));

PropDouble dMinimumInsulationDepth (2, 50, T("Minimum insulation depth"));

PropString sFilterByMaterial(1,"",T("Exclude sheets by material"));
sFilterByMaterial.setDescription(T("Set the material os the sheets that will be excluded from the volume calculation. To add more than 1 use ';' after each material"));

PropString sOutputKey(2, "TimberFraction", "Output Key");

PropString sDimStyle(3,_DimStyles,T("|Dimstyle|"));
PropInt nColor (0, 7, T("|Text Color|"));


if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);


if( _bOnInsert ){
	if (insertCycleCount()>1) { eraseInstance(); return; }
	if (_kExecuteKey=="")
		showDialogOnce();	

	_Pt0=getPoint("Pick a Point to show result.");

	PrEntity ssE(T("Please select elements"),Element());
 	if (ssE.go())
	{
 		Entity ents[0];
 		ents = ssE.set();
 		for (int i = 0; i < ents.length(); i++ )
		 {
 			Element el = (ElementWall) ents[i];
 			if (el.bIsValid())
 				_Element.append(el);
 		 }
 	}

 	if (_Element.length()== 0)eraseInstance();
	return;
}

if( _Element.length()==0 ){eraseInstance(); return;}

String arSCodeWalls[0];
String sWallCodes=sWalls;
sWallCodes.trimLeft();
sWallCodes.trimRight();
sWallCodes=sWallCodes+";";
for (int i=0; i<sWallCodes.length(); i++)
{
	String str=sWallCodes.token(i);
	str.trimLeft();
	str.trimRight();
	str.makeUpper();
	if (str.length()>0)
		arSCodeWalls.append(str);
}

// filter sheets by material //////////////////////
String arSheetMaterials[0];
String sExtName=sFilterByMaterial;
sExtName.trimLeft();
sExtName.trimRight();
sExtName=sExtName+";";
for (int i = 0; i < sExtName.length(); i++)
{
	String str = sExtName.token(i);
	str.trimLeft();
	str.trimRight();
	str.makeUpper();
	if (str.length() > 0)
		arSheetMaterials.append(str);
}

///////////////////////////////////
// display
Display dp(nColor);
dp.dimStyle(sDimStyle);

double dVolumeOfTimber = 0;
double dVolumeOfElements = 0;

for (int e = 0; e < _Element.length(); e++)
{
	ElementWall el = (ElementWall) _Element[e];
	
	if (!el.bIsValid()) continue;
	
	if (arSCodeWalls.length() > 0)
	{
		String sElementCode = el.code();
		sElementCode.makeUpper();
		if (arSCodeWalls.find(sElementCode, - 1) == -1)
			continue;
	}
	
	CoordSys csEl = el.coordSys();
	Vector3d vx = csEl.vecX();
	Vector3d vy = csEl.vecY();
	Vector3d vz = csEl.vecZ();
	
	double dZone0Thickness = el.zone(0).dH();
	
	Point3d ptCuttingPlane = el.ptOrg()-el.vecZ()*dZone0Thickness+el.vecZ()*dMinimumInsulationDepth;
	ptCuttingPlane.vis();
	
	Plane planeSlice(ptCuttingPlane, vz);
	
	//Calculate the opening with the tolerance
	double dToleranceSide = 50;
	double dToleranceTop = 175;
	double dToleranceBottom = 50;
	
	PlaneProfile ppOpenings(csEl);
	
	Opening allOpenings[] = el.opening();
	for (int i=0; i<allOpenings.length(); i++)
	{ 
		Opening op = allOpenings[i];
		if ( ! op.bIsValid()) continue;
		
		PlaneProfile ppThisOpening(op.plShape());
		ppThisOpening.shrink(-dToleranceSide);
		PlaneProfile auxProfile = ppThisOpening;
		auxProfile.transformBy(vy * (dToleranceTop - dToleranceSide));
		ppThisOpening.unionWith(auxProfile);
	
		ppOpenings.unionWith(ppThisOpening);
	}
	
	ppOpenings.vis(2);
	
	//Calculate the thickness of every zone
	for (int i = - 5; i <= 5; i++)
	{
		ElemZone elZone = el.zone(i);
		String sMaterialThisZone = elZone.material();
		if (elZone.dH() < 0.001) continue;
		sMaterialThisZone.trimLeft();
		sMaterialThisZone.trimRight();
		sMaterialThisZone.makeUpper();
		if (arSheetMaterials.length() > 0)
		{
			if (arSheetMaterials.find(sMaterialThisZone, - 1) != -1)
			{
				continue;
			}
		}
		
		PlaneProfile ppThisZone = el.profNetto(i, true, true);
		double dAreaZone = ppThisZone.area() / U(1) * U(1);
		dVolumeOfElements += dAreaZone * elZone.dH();
	}
	
	double dVolumeSoleplate=0;
	double dVolumeHeadbinder=0;
	GenBeam bmAll[] = el.genBeam(0);
	for (int i=0; i<bmAll.length(); i++)
	{ 
		Beam bm=(Beam) bmAll[i];
		if (!bm.bIsValid()) continue;
		
		if (bm.type()==_kSFBottomPlate)
		{ 
			dVolumeSoleplate += bm.solidLength() * bm.solidWidth() * dSoleplateHeight;
		}
		else if (bm.type()==_kSFTopPlate)
		{ 
			dVolumeHeadbinder += bm.solidLength() * bm.solidWidth() * dHeadbinderHeight;
		}
		
		PlaneProfile ppThisBeam = bm.envelopeBody(false, true).getSlice(planeSlice);
		ppThisBeam.subtractProfile(ppOpenings);
		
		if (ppThisBeam.area()>0.001)
		{ 
			//ppThisBeam.vis();
			dVolumeOfTimber += ppThisBeam.area() * dZone0Thickness;
		}
	}
	
	dVolumeOfElements += dVolumeSoleplate;
	dVolumeOfTimber += dVolumeSoleplate;
	dVolumeOfElements += dVolumeHeadbinder;
	dVolumeOfTimber += dVolumeHeadbinder;
}

if (dVolumeOfElements<0.01 || dVolumeOfTimber<0.01)
{ 
	eraseInstance();
	return;
}

dVolumeOfElements = dVolumeOfElements / 1000000000;
dVolumeOfTimber = dVolumeOfTimber / 1000000000;

double dTimberFraction = (dVolumeOfTimber / dVolumeOfElements) * 100;

String sOutput;
sOutput.formatUnit(dTimberFraction, 2, 2);

dp.draw("Timber fraction: " + sOutput +"%", _Pt0, _XW, _YW, 1 ,1);
//dp.draw("Volume of Timber: " + dVolumeOfTimber, _Pt0, _XW, _YW, 1 ,1);
//dp.draw("Volume of Element: " + dVolumeOfElements, _Pt0, _XW, _YW, 1 ,-1);
Map mp;
mp.setDouble("Percentage", dTimberFraction);
_ThisInst.setSubMapX("TimberFractions", mp);

return;
#End
#BeginThumbnail

#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="Resource[]">
    <lst nm="IMAGE[]" />
  </lst>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Initial Version" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="8/28/2024 9:22:31 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End