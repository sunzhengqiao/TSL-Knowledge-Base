#Version 8
#BeginDescription
Runs on Generation and it takes the Material field and breaks it down into individual properties for sheets.

Name;Material;Grade;Information;Label;Sublable;Sublable2;Code;AllowNailing;

NOTE: AllowNailing must have a value of YES or NO


Modified by: Alberto Jena
Date: 02.02.2021 - version 1.1
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
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
* date: 08.12.2021
* version 1.1: Release Version
*
*/

Unit(1,"mm"); // script uses mm

_ThisInst.setSequenceNumber(-90);

if(_bOnInsert){
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	
	PrEntity ssE("\n"+T("Select a set of elements"),Element());
	
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	return;
}

if( _Element.length()==0 ){
	eraseInstance();
	return;
}

for ( int e = 0; e < _Element.length(); e++)
{
	ElementWall el = (ElementWall) _Element[e];
	if ( ! el.bIsValid()) continue;
	
	CoordSys cs = el.coordSys();
	Vector3d vx = cs.vecX();
	Vector3d vy = cs.vecY();
	Vector3d vz = cs.vecZ();
	Point3d ptOrgEl = cs.ptOrg();
	_Pt0 = ptOrgEl;
	
	Sheet shAll[] = el.sheet();
	
	if (shAll.length()==0)
	{ 
		return;
	}
	
	for (int i = 0; i < shAll.length(); i++)
	{
		Sheet sh = shAll[i];
		String sFullmaterial = sh.material();
		sFullmaterial.trimLeft();
		sFullmaterial.trimRight();
		//Split the Material String into individual properties
		if (sFullmaterial.find("; ", 0))
		{
			//Name
			String sName = sFullmaterial.token(0);
			//Material
			String sMaterial = sFullmaterial.token(1);
			//Grade
			String sGrade = sFullmaterial.token(2);
			//Information
			String sInformation = sFullmaterial.token(3);
			//Label
			String sLabel = sFullmaterial.token(4);
			//Sublabel
			String sSublabel = sFullmaterial.token(5);
			//Sublabel2
			String sSublabel2 = sFullmaterial.token(6);
			//Code
			String sCode = sFullmaterial.token(7);
			//AllowNailing
			String sNailing = sFullmaterial.token(8);
			
			//Build Beam Code
			String sNewBeamCode;
			for (int i = 0; i < 13; i++)
			{
				if (i == 0)
				{
					sNewBeamCode += sCode;
				}
				if (i == 1)
				{
					String sValue = sMaterial;
					sValue.trimLeft();
					sValue.trimRight();
					sNewBeamCode += sValue;
				}
				if (i == 8)
				{
					sNailing.trimLeft();
					sNailing.trimRight();
					sNailing.makeUpper();
					sNewBeamCode += sNailing;
				}
				if (i == 9)
				{
					String sValue = sGrade;
					sValue.trimLeft();
					sValue.trimRight();
					sValue.makeUpper();
					sNewBeamCode += sValue;
				}
				if (i == 10)
				{
					String sValue = sInformation;
					sValue.trimLeft();
					sValue.trimRight();
					sValue.makeUpper();
					sNewBeamCode += sValue;
				}
				if (i == 11)
				{
					String sValue = sName;
					sValue.trimLeft();
					sValue.trimRight();
					sValue.makeUpper();
					sNewBeamCode += sValue;
				}
				
				sNewBeamCode += ";";
			}
			
			sh.setName(sName);
			sh.setMaterial(sMaterial);
			sh.setGrade(sGrade);
			sh.setInformation(sInformation);
			sh.setLabel(sLabel);
			sh.setSubLabel(sSublabel);
			sh.setSubLabel2(sSublabel2);
			
			sh.setBeamCode(sNewBeamCode);
		}
	}
}

eraseInstance();
return;




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