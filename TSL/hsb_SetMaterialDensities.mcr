#Version 8
#BeginDescription
Open the interface to define the material and density

1.3 23.06.2021 HSB-10308: change dll path Author: Marsel Nakuci

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 16.01.2015  -  version 1.2



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
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
* #Versions:
// Version 1.3 23.06.2021 HSB-10308: change dll path Author: Marsel Nakuci
* date: 24.04.2012
* version 1.0: First version
*
* date: 11.06.2012
* version 1.1: Add default density
*
* date: 16.01.2015
* version 1.2: Moved to general folder
*/

Unit (1, "mm");

if( _bOnInsert )
{
	if (insertCycleCount()>1) { eraseInstance(); return; }

	_Pt0=_PtW;
	return;
}

String sPath= _kPathHsbCompany+"\\Abbund\\Materials.xml";

String sFind=findFile(sPath);

if (sFind=="")
{
	Map mpMaterials;

	Map mpMaterial;
	Map mpMaterial1;
	Map mpMaterial2;
	Map mpMaterial3;
	Map mpMaterial4;
	Map mpMaterial5;
	Map mpMaterial6;
	Map mpMaterial7;
	Map mpMaterial8;

	mpMaterial.setString("MATERIAL", "STEEL");
	mpMaterial.setDouble("DENSITY", 1000, _kNoUnit);
	
	mpMaterial1.setString("MATERIAL", "CLS");
	mpMaterial1.setDouble("DENSITY", 550, _kNoUnit);
	
	mpMaterial2.setString("MATERIAL", "LVL");
	mpMaterial2.setDouble("DENSITY", 600, _kNoUnit);
	
	mpMaterial3.setString("MATERIAL", "MDF");
	mpMaterial3.setDouble("DENSITY", 900, _kNoUnit);
	
	mpMaterial4.setString("MATERIAL", "OSB");
	mpMaterial4.setDouble("DENSITY", 720, _kNoUnit);
	
	mpMaterial5.setString("MATERIAL", "PLASTERBOARD");
	mpMaterial5.setDouble("DENSITY", 950, _kNoUnit);
	
	mpMaterial6.setString("MATERIAL", "WEYROC");
	mpMaterial6.setDouble("DENSITY", 750, _kNoUnit);
	
	mpMaterial7.setString("MATERIAL", "CABERDEK");
	mpMaterial7.setDouble("DENSITY", 750, _kNoUnit);

	mpMaterial8.setString("MATERIAL", "DEFAULT");
	mpMaterial8.setDouble("DENSITY", 1000, _kNoUnit);
	
	mpMaterials.appendMap("MATERIAL", mpMaterial);
	mpMaterials.appendMap("MATERIAL", mpMaterial1);
	mpMaterials.appendMap("MATERIAL", mpMaterial2);
	mpMaterials.appendMap("MATERIAL", mpMaterial3);
	mpMaterials.appendMap("MATERIAL", mpMaterial4);
	mpMaterials.appendMap("MATERIAL", mpMaterial5);
	mpMaterials.appendMap("MATERIAL", mpMaterial6);
	mpMaterials.appendMap("MATERIAL", mpMaterial7);
	mpMaterials.appendMap("MATERIAL", mpMaterial8);
	
	Map mpOut;
	mpOut.setMap("MATERIAL[]", mpMaterials);
	
	mpOut.writeToXmlFile(sPath);
}


String strAssemblyPath = _kPathHsbInstall + "\\Utilities\\hsbMaterialDensityTable\\hsbMaterialDensityTable.dll";
String strType = "hsbCad.Tsl.Insertion.MapTransaction";
String strFunction = "LoadMaterialTable";

String sFindDll=findFile(strAssemblyPath);
if (sFindDll=="") 
{ 
	// old location
	strAssemblyPath = _kPathHsbInstall + "\\Content\\General\\MaterialTable\\hsbMaterialTable.dll";
	strType = "hsbSoft.Tsl.Insertion.MapTransaction";
	strFunction = "LoadMaterialTable";
}

Map mapIn;
mapIn.setString("Path", sPath);

Map mapOut = callDotNetFunction2(strAssemblyPath, strType, strFunction, mapIn);


int a=mapOut.length();

if (!mapOut.hasString("Result") || a==0)
{
	reportNotice("No Valid dll or path not found");
}
else if (mapOut.hasString("Result"))
{
	String sMes=mapOut.getString("Result");
	if (sMes!="")
	{
		reportNotice("\n"+sMes);
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
    <lst nm="Version">
      <str nm="Comment" vl="HSB-10308: change dll path" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="6/23/2021 10:17:27 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End