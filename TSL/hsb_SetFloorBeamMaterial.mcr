#Version 8
#BeginDescription
Set the material and beam type of the beams that are draw in a floor

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 10.11.2021  -  version 1.8











#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 8
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2008 by
*  hsbSOFT IRELAND
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
* date: 30.04.2012
* version 1.1: First version
*
* date: 31.05.2012
* version 1.2: Add Name and grade as a property
*
* date: 03.08.2012
* version 1.4: Add beam type _kSupportingCrossBeam
*
* date: 10.10.2012
* version 1.5: Removed check for grade to see if it is empty.  If property is empty it will overwrite the grade to empty
*
* date: 10.09.2015
* version 1.6: Fixed tsl to work from tool palettes
*
* date: 10.09.2015
* version 1.7: Added furrings to the list of types
*/

Unit (1, "mm");

String sBmName[0];
int nBeamType[0];

sBmName.append("Rim Board");			nBeamType.append(_kRimBeam);
sBmName.append("Joist");				nBeamType.append(_kJoist);
sBmName.append("Trimmer");			nBeamType.append(_kFloorBeam);
sBmName.append("Rim Joist");			nBeamType.append(_kRimJoist);
sBmName.append("Blocking");			nBeamType.append(_kBlocking);
sBmName.append("Packers");			nBeamType.append(_kExtraBlock);
sBmName.append("Strongbacks");		nBeamType.append(_kSupportingCrossBeam);
sBmName.append("Beam"); 				nBeamType.append(_kBeam);
sBmName.append("Furring"); 			nBeamType.append(_kRisingBeam);

PropString sBeamUse(0, sBmName, T("Beam Use"));

PropString sBeamName(1, "", T("Beam Name"));

String sPath= _kPathHsbCompany+"\\Abbund\\Materials.xml";

String sFind=findFile(sPath);

if (sFind=="")
{
	reportNotice("\n Materials not been set, please run hsbMaterial Utility or contact SupportDesk");
	eraseInstance();
	return;
}

Map mp;
mp.readFromXmlFile(sPath);

String sMaterial[0];

if (mp.hasMap("MATERIAL[]"))
{
	Map mpMaterials=mp.getMap("MATERIAL[]");
	for(int i=0; i<mpMaterials.length(); i++)
	{
		Map mpMaterial=mpMaterials.getMap(i);
		if (mpMaterial.getString("MATERIAL")!="DEFAULT")
			sMaterial.append(mpMaterial.getString("MATERIAL"));
	}
}

if (sMaterial.length()==0)
{
	reportNotice("\n Materials not been set, please run hsbMaterial Utility or contact SupportDesk");
	eraseInstance();
	return;
}

String sYesNo[]={T("Yes"), T("No")};

PropString sBeamMaterial(2, sMaterial, T("Material"));

PropString sBeamGrade(3, "", T("Grade"));

PropString sNailing(4, sYesNo, T("|Allow Nailing|"));

PropInt nColor(0, 32, T("Color"));

_ThisInst.setSequenceNumber(0);

if (_bOnInsert || _bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

if( _bOnInsert )
{
	//if (insertCycleCount()>1) { eraseInstance(); return; }
	
	if (_kExecuteKey=="")
		showDialog();

	PrEntity ssE("\nSelect one or more beams", Beam());
	if(ssE.go())
	{
		_Beam.append(ssE.beamSet());
	}

	return;
}

if (_Beam.length()==0)
{
	eraseInstance();
	return;
}

int nNailing = sYesNo.find(sNailing, 0);

String sName=sBeamName;
String sGrade=sBeamGrade;

sName.trimLeft();
sName.trimRight();

sGrade.trimLeft();
sGrade.trimRight();

for (int i=0; i<_Beam.length(); i++)
{
	Beam bm=_Beam[i];
	
	int nLocation=sBmName.find(sBeamUse, -1);
	
	if (nLocation!=-1)
	{
		bm.setType(nBeamType[nLocation]);
		bm.setMaterial(sBeamMaterial);
		
		
		
		bm.setGrade(sGrade);

		if (sName=="")
		{
			bm.setName(sBmName[nLocation]);
		}
		else
		{
			bm.setName(sName);
		}
		
		bm.setColor(nColor);
		
		//Set the Beam Code
		String sBeamCode=bm.beamCode();
		String sNewBeamCode;
		for (int i=0; i<13; i++)
		{
			String sToken;
			sToken=sBeamCode.token(i);
			sToken.trimLeft();
			sToken.trimRight();
			if (sToken!="" && (i!=5 && i!=8))
			{
				sNewBeamCode+=sToken;
			}
			else
			{
				if (i==1)
				{
					String sValue=bm.material();
					sValue.trimLeft();
					sValue.trimRight();
					sValue.makeUpper();
					sNewBeamCode+=sValue;
				}
				if (i==8) // Allow Nailing
				{
					String sValue="YES";
					if (nNailing==1)
						sValue="NO";
						
					sValue.trimLeft();
					sValue.trimRight();
					sValue.makeUpper();
					sNewBeamCode+=sValue;
				}
				if (i==9) // Grade
				{
					String sValue=bm.grade();
					sValue.trimLeft();
					sValue.trimRight();
					sValue.makeUpper();
					sNewBeamCode+=sValue;
				}
				if (i==10) //Information
				{
					String sValue=bm.information();
					sValue.trimLeft();
					sValue.trimRight();
					sValue.makeUpper();
					sNewBeamCode+=sValue;
				}
				if (i==11)
				{
					String sValue=bm.name();
					sValue.trimLeft();
					sValue.trimRight();
					sValue.makeUpper();
					sNewBeamCode+=sValue;
				}
			}
			sNewBeamCode+=";";
		}
		bm.setBeamCode(sNewBeamCode);
		
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
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Add a property to Allow Nailing" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="8" />
      <str nm="DATE" vl="11/10/2021 12:15:42 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End