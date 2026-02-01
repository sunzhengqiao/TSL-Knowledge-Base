#Version 8
#BeginDescription


























#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 1
#KeyWords BOM, labels in paperspace
#BeginContents

/*
*  COPYRIGHT
*  ---------
*  Copyright (C) 2005 by
*  hsbSOFT N.V.
*  THE NETHERLANDS
*
*  The program may be used and/or copied only with the written
*  permission from hsbSOFT N.V., or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*
*
* REVISION HISTORY
* ----------------
*
* Revised: Allberto Jena 05072013 (v1.13)
* Change: Change the name of the argument for the loosematerial.
*
*/

Unit (1,"mm");//script uses mm

//Collect data
String strAssemblyPathProject=_kPathHsbInstall+"\\Utilities\\hsbLooseMaterials\\hsbLooseMaterialsUI.dll";
String strTypeProject="hsbCad.LooseMaterials.UI.MapTransaction";
String strFunctionProject="ShowInventoryEditorDialog";

if (_bOnDbCreated || _bOnInsert) setPropValuesFromCatalog(_kExecuteKey);

if( _bOnInsert ){
	if( insertCycleCount()>1 )
	{
		eraseInstance();
		return;
	}

	_Pt0 = _PtW;
	Map mpIn;
	Map mpOut;
	mpOut = callDotNetFunction2(strAssemblyPathProject, strTypeProject, strFunctionProject, mpIn);
	
	_Map=Map();
	_Map=mpOut;
	
	return;

}

eraseInstance();
return;














#End
#BeginThumbnail


#End