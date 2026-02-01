#Version 8
#BeginDescription
Modified by: Alberto Jena (alberto.jena@hsbcad.com)
Date: 26.06.2018 - version 1.1
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
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
* date: 08.09.2015
* version 1.0: Release Version
*
*/

String sPath= _kPathHsbInstall+"\\Utilities\\hsbLooseMaterials\\hsbLooseMaterialsUI.dll";

String sFind=findFile(sPath);

if (sFind=="")
{
	reportNotice("\n dll not found, please contact you local support team");
	eraseInstance();
	return;
}

String strType = "hsbCad.LooseMaterials.UI.MapTransaction";
String strFunction = "GetItems";

Map mapIn;
mapIn.setString("MinorGroupName", "Sheet");
//mapIn.setInt("int",3);
//mapIn.setDouble("dbl",4,_kNoUnit);
//mapIn.setDouble("len",U(5));
//mapIn.setDouble("Area",U(5)*U(6),_kArea);
//mapIn.setDouble("Vol",U(5)*U(6)*U(1), _kVolume);
//mapIn.setString("key","value");
//mapIn.setPoint3d("pt0",_Pt0);
//mapIn.setVector3d("vecXY",_XU+_YU);

Map mp = callDotNetFunction2(sPath, strType, strFunction, mapIn);

//mp.writeToDxxFile("C:\\temp\loosemat.dxx");

/*
GetMajorWithMinorGroups
GetItems
GetMinorGroups
            
		var majorGroup = mapIn.Get("MajorGroupName", string.Empty);
            var minorGroup = mapIn.Get("MinorGroupName", string.Empty);
            var description = mapIn.Get("Description", string.Empty);
            var material = mapIn.Get("Material", string.Empty);
            var grade = mapIn.Get("Grade", string.Empty);
            var length = mapIn.Get("Length", string.Empty);
            var width = mapIn.Get("Width", string.Empty);
            var inventoryNumber = mapIn.Get("InventoryNumber", string.Empty);
            var supplierNumber = mapIn.Get("SupplierNumber", string.Empty);
*/


String sItems[0];
String sIDs[0];

if (mp.hasMap("ITEM[]"))
{
	Map mpItems=mp.getMap("ITEM[]");
	for(int i=0; i<mpItems.length(); i++)
	{
		Map mpItem=mpItems.getMap(i);
		if (mpItem.getString("Description")!="")
		{
			sItems.append(mpItem.getString("Description"));
			sIDs.append(mpItem.getString("ID"));
		}
	}
}

if (sItems.length()==0)
{
	reportNotice("\n No Sheet items available in database, please check your Inventory");
	eraseInstance();
	return;
}

PropString sItem(0, sItems, T("Choose Sheet for this area"));

PropString sDimStyle(1, _DimStyles,"Dimension style");

PropInt nColor(0, -1, "Text Color");

PropDouble dArea(0, U(0), T("Area:"));
dArea.setReadOnly(true);
dArea.setFormat(_kArea);

PropDouble dNetArea(1, U(0), T("Net Area:"));
dNetArea.setReadOnly(true);
dNetArea.setFormat(_kArea);

PropDouble dPerimeter(2, U(0), T("Perimeter:"));
dPerimeter.setReadOnly(true);
dPerimeter.setFormat(_kLength);

if(_bOnInsert)
{
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	if (_kExecuteKey=="")
		showDialogOnce();
	
	EntPLine pl = getEntPLine(T("Select main poliline"));
	_Entity.append(pl);
	
	PrEntity ssE2(T("Select opening polilines or ENTER to ignore"), EntPLine());
 	if (ssE2.go())
	{
 		Entity ents[0];
 		ents = ssE2.set();
 		for (int i = 0; i < ents.length(); i++ )
		 {
 			EntPLine pl = (EntPLine) ents[i];
 			_Entity.append(pl);
 		 }
 	}

	return;
}

if (_Entity.length()<=0)
{
	eraseInstance();
	return;
}

setDependencyOnEntity(_Entity[0]);

EntPLine epl = (EntPLine)_Entity[0];
PLine pl = epl.getPLine();

PlaneProfile ppFullArea(pl);

for (int i=1; i<_Entity.length(); i++)
{ 
	EntPLine epl = (EntPLine)_Entity[i];
	PLine pl = epl.getPLine();
	setDependencyOnEntity(_Entity[i]);
	ppFullArea.joinRing(pl, true);
}

Point3d ptAll[]=pl.vertexPoints(true);
Point3d ptMiddle;
ptMiddle.setToAverage(ptAll);

_Pt0=ptMiddle;

dArea.set(pl.area());
dPerimeter.set(pl.length());
dNetArea.set(ppFullArea.area());

int nItem=sItems.find(sItem, -1);
String sID=sIDs[nItem];

Map mpSelectedItem;
Map mpItems=mp.getMap("ITEM[]");
for(int i=0; i<mpItems.length(); i++)
{
	Map mpItem=mpItems.getMap(i);
	if (mpItem.getString("ID")==sID)
	{
		mpSelectedItem=mpItem;
		break;
	}
}

_Map=Map();
Map mpOut;
mpOut.setMap("ITEM", mpSelectedItem);
_Map.setMap("ITEM[]", mpOut);
_Map.setDouble("Area", dArea);
_Map.setDouble("Net Area", dNetArea);
_Map.setDouble("Perimeter", dPerimeter);

Display dpText(nColor);
dpText.dimStyle(sDimStyle);
dpText.draw(sItem, _Pt0, _XW, _YW, 0,0,_kDevice);


//eraseInstance();
return;

#End
#BeginThumbnail


#End