#Version 8
#BeginDescription
1.2 23.06.2021 HSB-10308: change the dll path Author: Marsel Nakuci

Open the interface to define the material and density

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 20.04.2012  -  version 1.1





#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 2
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
* date: 24.04.2012
* version 1.0: First version
*
* #Versions
// Version 1.2 23.06.2021 HSB-10308: change the dll path Author: Marsel Nakuci
* date: 11.06.2012
* version 1.1: Add default density
*/

// standards
	U(1,"mm");

// on insert
	if( _bOnInsert )
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		_Pt0=_PtW;
		return;
	}

// preset path
	String sPath=_kPathHsbCompany+"\\Abbund\\Materials.xml";
	String sFind=findFile(sPath);

	if (sFind=="")
	{
		Map mapMaterials,mapMaterial;
		String sNames[0];
		double dDensities[0];
		String sUpperNames[0];
		
	// find previous density structure, provided before 2012-07-13
		// read in the values to create a new default material file
		String sPathOld= _kPathHsbCompany+"\\Abbund\\hsbGenBeamDensityConfig.xml";
		String sFindOld=findFile(sPathOld);
		if (sFindOld!="")
		{
			Map map;
			map.readFromXmlFile(sPathOld);	
			for (int i=0;i<map.length();i++)
				if (map.hasDouble(i))
				{
					String s = map.keyAt(i).trimLeft().trimRight();
					sNames.append(s);	
					sUpperNames.append(s.makeUpper());	
					dDensities.append(map.getDouble(i));
				}
		}
	
	// decalare defaults
		String sDefaultNames[]={"D30","D35","D40","D60","GL24c","GL28c","GL32c","GL36c","GL24h","GL28h",
			"GL32h","GL36h", "KVH", "C24", "C30", "C40", "OSB", "Fermacell", T("|Aluminium|"), T("|Steel|"),
			T("|Stainless Steel|"), "Beton", "Gasbeton", "Kiesbeton", "Leichtbeton", "Schwerbeton", "Schwerstbeton", "Window", "Door", "DEFAULT"};
		double dDefaultDensities[]={900,900,900,900,500,500,500,500,500,500,
			500,500,500,500,500,500,800,2500,2500,7700,
			7800,1200,700,2100,900,2500,5000,2000,600, 500};		

	// append if not already imported from previous structure
		for (int i=0;i<sDefaultNames.length();i++)
		{
			String s = sDefaultNames[i].trimLeft().trimRight();
			String sUpper = s;
			if (sUpperNames.find(sUpper.makeUpper())<0)
			{
				sNames.append(s);	
				sUpperNames.append(sUpper);	
				dDensities.append(dDefaultDensities[i]);					
			}	
		}
		for (int i=0;i<sNames.length();i++)
		{
			mapMaterial.setString("Material",sNames[i]);
			mapMaterial.setDouble("Density",dDensities[i],_kNoUnit);
			mapMaterials.appendMap("Material", mapMaterial);	
		}

	// append to map structure			
		Map mpOut;
		mpOut.setMap("MATERIAL[]", mapMaterials);
		mpOut.writeToXmlFile(sPath);
	}

// declare assembly
	// HSB-10308
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
	
// callDotNet	
	Map mapIn;
	mapIn.setString("Path", sPath);
	Map mapOut = callDotNetFunction2(strAssemblyPath, strType, strFunction, mapIn);

// validate output
	int a=mapOut.length();
	if (!mapOut.hasString("Result") || a==0)
	{
		reportNotice("\n"+"No Valid dll or path not found");
	}
	else if (mapOut.hasString("Result"))
	{
		String sMes=mapOut.getString("Result");
		if (sMes!="")
		{
			reportNotice("\n"+sMes);
		}
	}

// clean up
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
      <str nm="Comment" vl="HSB-10308: change the dll path" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="6/23/2021 10:12:17 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End