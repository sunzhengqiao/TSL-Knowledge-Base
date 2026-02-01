#Version 8
#BeginDescription
v1.0: 02.jun.2014: David Rueda (dr@hsb-cad.com)
Resets catalog info for selected hardware TSL's. User will be able to select .TXT file with models list after process.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2011 by
*  hsbSOFT 
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
* v1.0: 02.jun.2014: David Rueda (dr@hsb-cad.com)
*	- Release
*/
String sDXXCatalogFileName="TSL_HARDWARE_FAMILY_LIST.dxx";
if(_bOnInsert)
{
	if( insertCycleCount()>1 ){
		eraseInstance();
	}

	// Get beam or points 
	PrEntity ssE(T("|Select hardware TSL to reset or hit ENTER to manually set values|"),TslInst());
	if( ssE.go())
	{
		_Entity.append(ssE.set());
	}

	String sKey, sPath, sFilePath;

	if(_Entity.length()==0)
	{
		reportMessage("\nManual insertion. Hint: if you don't know the catalog path or family name run the hardware TSL (to be reset) and copy the values prompted in command line.\nPlease type:");
		sKey=getString("\nFamily Name");
		sFilePath=getString("\nCatalog File Path");
	}
	else
	{
		TslInst tsl= (TslInst)_Entity[0];
		Map map= tsl.map();
		sKey=map.getString("FAMILYNAME");
		sPath=map.getString("HSBCOMPANY_TSL_CATALOG_PATH");
		sFilePath=sPath+sDXXCatalogFileName;
	}
	
	sKey=sKey.trimLeft().trimRight().makeUpper() ;
	sFilePath=sFilePath.trimLeft().trimRight();

	Map catalog; 
	catalog.readFromDxxFile(sFilePath);
	//catalog.writeToDxxFile("c:\shared\readcatalog.dxx");
	for(int m=0;m<catalog.length();m++)
	{
		if(sKey==catalog.keyAt(m))
		{
			catalog.removeAt(sKey,1);
			catalog.writeToDxxFile(sFilePath);
			reportMessage("\nKey found in catalog. RESET SUCCESS. Please re-insert hardware TSL to be able to set new .TXT source file.\n");
			eraseInstance();
			return;
		}
	}

	reportMessage("\nKey NOT found in catalog.");
	reportMessage("\nFamily Name: "+sKey);	
	reportMessage("\nCatalog File Path: "+sFilePath);
	eraseInstance();
	return;
} // End _bOnInsert

#End
#BeginThumbnail

#End
