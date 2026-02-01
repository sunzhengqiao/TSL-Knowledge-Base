#Version 8
#BeginDescription
Call the exporter for a specific group with all the entities or only the selected ones.
1.2 10/08/2021 Add element selection Author: Robert Pol

#versions





1.3 03/08/2022 Add option to select the current delivery Author: Robert Pol
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
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 01.08.2011
* version 1.0: Release Version
*
* date: 01.08.2011
* version 1.1: Implement export of selected entities 17.1.15
// #Versions
//1.3 03/08/2022 Add option to select the current delivery Author: Robert Pol
*/

U(1,"mm");	
double dEps =U(.1);
int nDoubleIndex, nStringIndex, nIntIndex;
String sDoubleClick= "TslDoubleClick";
int bDebug=_bOnDebug;
bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));	
String sDefault =T("|_Default|");
String sLastInserted =T("|_LastInserted|");	
String category = T("|General|");
String sNoYes[] = { T("|No|"), T("|Yes|")};

String arExportOptions[] = {T("Select all entities in drawing"), T("Select entities in drawing"), T("Select all elements in drawing"), T("Select elements in drawing"), T("Select current delivery")};

String arGroups[] = ModelMap().exporterGroups();

String categories[] = 
{
	T("|Delivery|"),
	T("|Export|")
};

PropString strExportOp(0, arExportOptions, "Elements to export", 0);
strExportOp.setCategory(categories[1]);

for (int s1 = 1; s1 < arGroups.length(); s1++) {
	int s11 = s1;
	for (int s2 = s1 - 1; s2 >= 0; s2--) {
		if ( arGroups[s11] < arGroups[s2] ) {
			arGroups.swap(s2, s11);
			s11 = s2;
		}
	}
}
arGroups.insertAt(0, ""); // add empty string
PropString pGroup(1,arGroups,T("|Exporter group|"));
pGroup.setCategory(categories[1]);
pGroup.setDescription(T("|Select the group that needs to be exported. If empty the single export is used|"));

String arShortcuts[] = ModelMap().exporterShortcuts();
for (int s1 = 1; s1 < arShortcuts.length(); s1++) {
	int s11 = s1;
	for (int s2 = s1 - 1; s2 >= 0; s2--) {
		if ( arShortcuts[s11] < arShortcuts[s2] ) {
			arShortcuts.swap(s2, s11);
			s11 = s2;
		}
	}
}
arShortcuts.insertAt(0, ""); // add empty string
PropString pShortcut(2,arShortcuts,T("|Single export|"));
pShortcut.setCategory(categories[1]);
pShortcut.setDescription(T("|Select the single export that needs to be exported. If empty the group export is used|"));
			  
// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("hsb_CNCGroupExport");
if( arSCatalogNames.find(_kExecuteKey) != -1 ) 
{
	setPropValuesFromCatalog(_kExecuteKey);
}
else
{
	setPropValuesFromCatalog(sLastInserted);
}


// bOnInsert
if (_bOnInsert)
{
	if (insertCycleCount() > 1) { eraseInstance(); return; }
	
	// silent/dialog
	String sKey = _kExecuteKey;
	sKey.makeUpper();
	
	if (sKey.length() > 0)
	{
		String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
		for (int i = 0; i < sEntries.length(); i++)
			sEntries[i] = sEntries[i].makeUpper();
		if (sEntries.find(sKey) >- 1)
			setPropValuesFromCatalog(sKey);
		else
			setPropValuesFromCatalog(T("|_LastInserted|"));
	}
	else
		showDialog();
	
	int nExportMode = arExportOptions.find(strExportOp);
	
	if (nExportMode == 0) //al entities
	{
		_Entity.append(Group().collectEntities(true, Entity(), _kModelSpace));
	}
	else if (nExportMode == 1) //select entities
	{
		PrEntity ssE(T("|Select a set of entities|"), Element());
		if (ssE.go())
		{
			_Entity.append(ssE.set());
		}
	}
	else if (nExportMode == 2) //all elements
	{
		Entity elements[] = Group().collectEntities(true, Element(), _kModelSpace);
		for (int index = 0; index < elements.length(); index++)
		{
			Element element = (Element)elements[index];
			if ( ! element.bIsValid()) continue;
			_Entity.append(element);
			_Entity.append(element.elementGroup().collectEntities(false, Entity(), _kModelSpace, false));
		}
		
	}
	else if (nExportMode == 3)
	{
		PrEntity ssE(T("|Select a set of elements|"), Element());
		if (ssE.go())
		{
			Element elements[] = ssE.elementSet();
			for (int index = 0; index < elements.length(); index++)
			{
				Element element = (Element)elements[index];
				if ( ! element.bIsValid()) continue;
				_Entity.append(element);
				_Entity.append(element.elementGroup().collectEntities(false, Entity(), _kModelSpace, false));
			}
		}
	}
	else if (nExportMode == 4)
	{
		Map projectMapX = subMapXProject("Delivery[]");
		Map projectMapXDelivery = subMapXProject("Hsb_Delivery");
		String currentDelivery = projectMapXDelivery.getString("DELIVERY").makeUpper();
		
		for (int i = 0; i < projectMapX.length(); i++)
		{
			Map thisMap = projectMapX.getMap(i);
			String mapDeliveryName = thisMap.getString("DeliveryName").makeUpper();
			String mapDeliveryDescription = thisMap.getString("DeliveryDescription");
			
			if (currentDelivery != mapDeliveryName) continue;
			for (int e = 0; e < thisMap.length(); e++)
			{
				if (thisMap.keyAt(e) != "ELEMENT") continue;
				Map elementMap = thisMap.getMap(e);
				int quantity = elementMap.getMap("Quantity").getInt("Quantity");
				
				Map entityMap = elementMap.getMap("Entity[]");
				//				reportMessage(entityMap);
				
				for (int en = 0; en < entityMap.length(); en++)
				{
					Entity entity = entityMap.getEntity(en);
					_Entity.append(entity);
					Element element = (Element)entity;
					if ( ! element.bIsValid()) continue;
					element.setQuantity(quantity);
				}
			}
			
		}
	}
	return;
}
// end on insert	__________________


String strDestinationFolder = _kPathDwg;

String strExportGroup = pGroup;
 if (strExportGroup == "")
	  strExportGroup = pShortcut;
	
 // set some export flags
ModelMapComposeSettings mmFlags;		
 mmFlags.addSolidInfo(true); // default FALSE		
 mmFlags.addAnalysedToolInfo(true); // default FALSE		
 mmFlags.addElemToolInfo(true); // default FALSE		
 mmFlags.addConstructionToolInfo(true); // default FALSE		
 mmFlags.addHardwareInfo(true); // default FALSE		
 mmFlags.addRoofplanesAboveWallsAndRoofSectionsForRoofs(true); // default FALSE		
 mmFlags.addCollectionAndBlockDefinitions(true); // default FALSE		 
 mmFlags.addAllGroups(false);

 // Map that contains the keys that need to be overwritten in the ProjectInfo 		
 Map mpProjectInfoOverwrite;

 // call the exporter	
 int bOk = ModelMap().callExporter(mmFlags, mpProjectInfoOverwrite, _Entity, strExportGroup, strDestinationFolder);

 if (!bOk)
         reportMessage("\nTsl::callExporter failed.");

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
      <dbl nm="PreviewTextHeight" ut="L" vl="0.03937008" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Add option to select the current delivery" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="8/3/2022 2:29:52 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add element selection" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="8/10/2021 10:27:49 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End