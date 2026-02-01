#Version 8
#BeginDescription
Rename the selected elements.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 31.08.2011 - version 1.1



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
* --------------------------------
*
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 31.08.2011
* version 1.1: Release Version
*
*/



if(_bOnInsert)
{
	//showDialogOnce();
	if (insertCycleCount()>1) { eraseInstance(); return; }
	/*PrEntity ssE(T("Please select Elements"),Element());
 	if (ssE.go())
	{
 		Element ents[0];
 		ents = ssE.elementSet();
 		for (int i = 0; i < ents.length(); i++ )
		 {
 			Element el = (Element) ents[i];
 			_Element.append(el);
 		 }
 	}*/
	//_Pt0=getPoint("Pick a point");

	return;
}



Group gr; // default constructor, or empty groupname means complete drawing 
int bAlsoInSubGroups = TRUE;
Entity arEnt[] = gr.collectEntities( bAlsoInSubGroups, Element(), _kModelSpace);
Element elAll[0];

for (int i=0; i<arEnt.length(); i++)
{
	Element el=(Element) arEnt[i];
	if (el.bIsValid())
	{
		elAll.append(el);
	}
}


String sGroupName[0];

String sElNumber[0];
int nElGroupIndex[0];
Element elOut[0];

for (int e=0; e<elAll.length(); e++)
{
	Element el= elAll[e];
	if (!el.bIsValid())
		continue;

	String sNumber=el.number();

	Group gp=el.elementGroup();
	String sFloorGroupName=gp.namePart(0)+"\\"+gp.namePart(1);
	
	int nLocation=sGroupName.find(sFloorGroupName, -1);
	
	if (nLocation==-1)
	{
		sGroupName.append(sFloorGroupName);
		sElNumber.append(sNumber);
		elOut.append(el);
		nElGroupIndex.append(sGroupName.length()-1);
	}
	else
	{
		sElNumber.append(sNumber);
		elOut.append(el);
		nElGroupIndex.append(nLocation);
	}
}

Map mpIn;

for (int i=0; i<sGroupName.length(); i++)
{
	Map mpGroup;
	
	for (int j=0; j<sElNumber.length(); j++)
	{
		if (nElGroupIndex[j]==i)
		{
			Map mpEl;
			mpEl.appendString("ElementName", sElNumber[j]);
			mpGroup.appendMap("Element", mpEl);
		}
	}	
	mpGroup.setString("GroupName", sGroupName[i]);

	mpIn.appendMap("Group", mpGroup);
}


//C:\Program Files\hsbSOFT\ITWhsbCAD2012\Content\UK\TSL\DLLs\ElementRenameUtility

String strAssemblyPath=_kPathHsbInstall +"\\Content\\UK\\TSL\\DLLs\\ElementRenameUtility\\hsb_ElementRenameUtility.dll";
String strType = "hsbSoft.ElementRenameUtility.Insertion.MapTransaction";
String strFunction = "LoadElementRenameUtility";
//reportMessage (T("\n|Number of entities selected:| ") + ents.length());
//mapDimDefinition.writeToDxxFile("c:\\test.dxx");
Map mapOut= callDotNetFunction2(strAssemblyPath, strType, strFunction, mpIn);

String sOldName[0];
String sNewName[0];

for (int i=0; i<mapOut.length(); i++)
{
	if (mapOut.hasMap(i))
	{
		Map mpEl=mapOut.getMap(i);
		sOldName.append(mpEl.getString("ElementName"));
		sNewName.append(mpEl.getString("NewElementName"));
	}
}

Element elToRename[0];
String sName[0];

for (int i=0; i<sOldName.length(); i++)
{
	int nLocation=sElNumber.find(sOldName[i]);
	elToRename.append(elOut[nLocation]);
	sName.append(sNewName[i]);
}

for (int i=0; i<elToRename.length(); i++)
{
	Element el=elToRename[i];
	String sNumber=el.number();
	sNumber=sNumber+"TEMP";
	el.setNumber(sNumber);
}

for (int i=0; i<elToRename.length(); i++)
{
	elToRename[i].setNumber(sName[i]);
}

eraseInstance();



#End
#BeginThumbnail



#End
