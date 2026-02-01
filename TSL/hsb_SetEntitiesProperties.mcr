#Version 8
#BeginDescription
Set entities .
1.1 15/02/2022 Add more props Author: Robert Pol


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 1
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
*
* REVISION HISTORY
* -------------------------
*
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 28.02.2019
* version 1.0: Release Version
*
//#Versions
//1.1 15/02/2022 Add more props Author: Robert Pol
*/

String sLastInserted =T("|_LastInserted|");	

PropString sName (0, "", T("|Name for the entity|"));
sName.setDescription(T("|If the name is set, it will overwrite the current name of the entity|"));

PropString sMaterial (1, "", T("|Material for the entity|"));
sName.setDescription(T("|If the material is set, it will overwrite the current material of the entity|"));

PropInt nColor(0, -1, T("Color to set on the entities"));
nColor.setDescription(T("Set the color of the entities, (-1) will keep the existing color"));

PropString sGrade (2, "", T("|Grade for the entity|"));
sGrade.setDescription(T("|If the grade is set, it will overwrite the current grade of the entity|"));

PropString sInformation (3, "", T("|Information for the entity|"));
sInformation.setDescription(T("|If the information is set, it will overwrite the current information of the entity|"));

PropString sLabel (4, "", T("|Label for the entity|"));
sLabel.setDescription(T("|If the label is set, it will overwrite the current label of the entity|"));

PropString sSublabel (5, "", T("|Sublabel for the entity|"));
sSublabel.setDescription(T("|If the sublabel is set, it will overwrite the current sublabel of the entity|"));

PropString sSublabel2 (6, "", T("|Sublabel2 for the entity|"));
sSublabel2.setDescription(T("|If the sublabel2 is set, it will overwrite the current sublabel2 of the entity|"));

PropString sBeamcode (7, "", T("|Beamcode for the entity|"));
sBeamcode.setDescription(T("|If the beamcode is set, it will overwrite the current beamcode of the entity|"));

//Insert
if( _bOnInsert )
{
	if( insertCycleCount()>1 ){eraseInstance(); return;}
	
	PrEntity ssE(T("\nSelect beams/sheets to set the properties"), GenBeam());
	
// silent/dialog
	String sKey = _kExecuteKey;
	sKey.makeUpper();

	if (sKey.length()>0)
	{
		String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
		for(int i=0;i<sEntries.length();i++)
		{
			sEntries[i] = sEntries[i].makeUpper();	
		}
		
		if (sEntries.find(sKey)>-1)
		{
			setPropValuesFromCatalog(sKey);
			setCatalogFromPropValues(sLastInserted); // use because lastinserted was not set (should not be needed)
		}
		else
		{
			setPropValuesFromCatalog(sKey);
			setCatalogFromPropValues(sLastInserted); // use because lastinserted was not set (should not be needed)
		}
	}	
	else	
	{
		showDialog();
		setCatalogFromPropValues(sLastInserted); // use because lastinserted was not set (should not be needed)
	}
	
	if( ssE.go() )
	{
		Entity ent[]=ssE.set();
		for (int i=0; i<ent.length(); i++)
		{
			GenBeam gb=(GenBeam) ent[i];
			
			if (gb.bIsValid())
			{
				_Entity.append(gb);
			}
		}
	}
	
	return;
}

//Check if there is an element selected.
if( _Entity.length() == 0 ){eraseInstance(); return; }

for (int g = 0; g < _Entity.length(); g++)
{
	GenBeam gb = (GenBeam) _Entity[g];
	
	if ( ! gb.bIsValid()) continue;
		
	if (sName != "")
	{
		gb.setName(sName);
	}
	
	if (sMaterial != "")
	{
		gb.setMaterial(sMaterial);
	}
	
	if (nColor != -1)
	{
		gb.setColor(nColor);
	}
	
	if (sGrade != "")
	{
		gb.setGrade(sGrade);
	}
	
	if (sInformation != "")
	{
		gb.setInformation(sInformation);
	}
	
	if (sLabel != "")
	{
		gb.setLabel(sLabel);
	}
	
	if (sSublabel != "")
	{
		gb.setSubLabel(sSublabel);
	}
	
	if (sSublabel2 != "")
	{
		gb.setSubLabel2(sSublabel2);
	}
	
	if (sBeamcode != "")
	{
		gb.setBeamCode(sBeamcode);
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
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Add more props" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="2/15/2022 4:20:52 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End