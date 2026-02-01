#Version 8
#BeginDescription
Set the wall information to Square, Shaped or Special base on some rules.

Modified by: Anno Sportel (support.uk@hsbcad.com)
Date: 23.10.2019  -  version 1.8




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 8
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2010 by
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
* --------------------------------
*

* Modified by: Alberto Jena (aj@hsb-cad.com)
* date: 09.06.2010
* version 1.1: Bugfix
*
* date: 20.10.2010
* version 1.2: Add sequence number
*
* date: 24.02.2011
* version 1.3: Add special set of rules
*
* date: 10.08.2011
* version 1.5: Dormel elements get shaped information too
*
* date: 23.03.2012
* version 1.6: Add nErase option
*
* date: 28.05.2012
* version 1.7: Moved special options into properties
*
* date: 23.10.2019
* version 1.8: Small performance improvement. No need to check for Squared or Special if its Shaped.
*/

_ThisInst.setSequenceNumber(50);

String sArYesNo[] = {T("No"), T("Yes")};

PropString sUseSpecialRules (0, sArYesNo, T("Set Special Rules"), 0);

PropDouble dMaxHeight(0,U(3200, 125),T("Special if wall is higher than:"));
dMaxHeight.setDescription("Deactivated if set to 0");

PropDouble dMinHeight(1,U(1500, 60),T("Special if wall is lower than:"));
dMinHeight.setDescription("Deactivated if set to 0");

PropDouble dMinLength(2,U(1500, 60),T("Special if wall is shorter than:"));
dMinLength.setDescription("Deactivated if set to 0");

// Load the values from the catalog
if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

int nUseSpecialRules = sArYesNo.find(sUseSpecialRules);

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
	
	return;
}

if (_Element.length()==0)
{
	eraseInstance();
	return;
}

int nBmType[0];

nBmType.append(_kSFAngledTPLeft);
nBmType.append(_kSFAngledTPRight);

int nErase=false;

for( int e=0; e<_Element.length(); e++)
{
	Element el=_Element[e];
	if (!el.bIsValid())
		continue;

	CoordSys csEl = el.coordSys();
	Vector3d vx = csEl.vecX();
	Vector3d vy = csEl.vecY();
	Vector3d vz = csEl.vecZ();
	_Pt0=csEl.ptOrg();
	
	Beam bmAll[] = el.beam();
	
	int nShape=FALSE;
	for (int b=0; b<bmAll.length(); b++)
	{
		Beam bm=bmAll[b];
		int nBeamType=bm.type();
		if (nBmType.find(nBeamType, -1) != -1)
		{
			nShape=TRUE;
			break;
		}
		
		if (nBeamType==_kSFBottomPlate)
		{
			double dA=abs(bm.vecX().dotProduct(vx));
			if (abs(bm.vecX().dotProduct(vx))<0.9999)
			{
				nShape=TRUE;
				break;
			}
		}
		nErase=true;
	}
	if (nShape==TRUE)
	{
		el.setInformation("Shaped");
	}
	else
	{
		PlaneProfile ppEl = el.profBrutto(0);
		LineSeg lsX = ppEl.extentInDir(vx);
		LineSeg lsY = ppEl.extentInDir(vy);
		
		double dElHeight = abs(vy.dotProduct(lsY.ptStart() - lsY.ptEnd()));
		double dElLength = abs(vx.dotProduct(lsX.ptStart() - lsX.ptEnd()));
		
		int nSpecial = FALSE;
		
		if (dMinHeight != 0)
		{
			if (dElHeight < dMinHeight)
				nSpecial = TRUE;
		}
		if (dMaxHeight != 0)
		{
			if (dElHeight > dMaxHeight)
				nSpecial = TRUE;
		}
		if (dMinLength != 0)
		{
			if (dElLength < dMinLength)
				nSpecial = TRUE;
		}
		
		if (nUseSpecialRules == TRUE && nSpecial == TRUE)
			el.setInformation("Special");
		else
			el.setInformation("Square");
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