#Version 8
#BeginDescription
Modified by: Alberto Jena (aj@hsb-cad.com)
23.02.2012  -  version 1.4







#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
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
* date: 25.05.2008
* version 1.0: Release Version

* date: 00.06.2009
* version 1.1: 	Assign the TSL to the group that now is taking from the Material Table
*
* date: 10.05.2010
* version 1.2:	Change the Table and some small fixes on export
*
* date: 11.02.2011
* version 1.3:	Add group for the new data base
*
* date: 23.02.2012
* version 1.4:	Made TSL go into Z type layer instead of T
*

*/

//Script uses mm
//double dEps = Unit(.01,"mm");

//Name of other tsl's Used
String sCatalogTableScriptName = "hsb_SolePlate Material Table";

//Recalc triggers
String sEditTableObject = T("Edit Profile");
String sEraseTableObject = T("Erase Profile");

//UInique key of this object
String sUniqueKey = T("sMaterial");


//Row height
PropDouble dRowHeight(0, U(100), T("Row height"));
dRowHeight.setReadOnly(TRUE);
//Column width
PropDouble dColumnWidth(1, U(1000), T("Column width"));
dColumnWidth.setReadOnly(TRUE);

//Dimension style
PropString sDimStyle(0, _DimStyles, T("Dimension style"));
sDimStyle.setReadOnly(TRUE);

//Color
PropInt nContentColor(0, -1, T("Content color"));
nContentColor.setReadOnly(TRUE);

//control the color if the designer places a stupid value
if (nContentColor > 255 || nContentColor < -1) nContentColor.set(171);

//Map must have an origin point
if( _Map.hasPoint3d("ptOrg") ){
	_Pt0=_Map.getPoint3d("ptOrg");
}
else{
	eraseInstance();
	return;
}

if (_Entity.length()<1)
{
	eraseInstance();
	return;
}


Group grp[]=_Entity[0].groups();
if (grp.length()>0)
{
	grp[0].addEntity(_ThisInst, TRUE);
}

setDependencyOnEntity(_Entity[0]);
_ThisInst.assignToGroups(_Entity[0]);
//setExecutionLoops(3);


//Get map of this table object
Map mapTableObject;
if( _Map.hasMap("mapTableObject") ){
	mapTableObject=_Map.getMap("mapTableObject");
}
else{
	eraseInstance();
	return;
}

//Map should contain some information
if( mapTableObject.length()==0 ){
	eraseInstance();
	return;
}

String sGroup="";
if (_Map.hasString("Group"))
{
	sGroup=_Map.getString("Group");
}

double dColumnWidthAr[0];
Map mapColumnWidth;
if( _Map.hasMap("mapColumnWidth") ){
	mapColumnWidth=_Map.getMap("mapColumnWidth");
}

int nNumberOfColumns=0;
for(int i=0; i<mapColumnWidth.length(); i++)
{
	dColumnWidthAr.append(mapColumnWidth.getDouble(i));
	nNumberOfColumns++;
}	


//setting the display colour
Display dp(nContentColor);
dp.dimStyle(sDimStyle);

//Identifier
String sUniqueValue = mapTableObject.getString(sUniqueKey);
//Text to display..
String sDescription = mapTableObject.getString("sDescription");
String sWidth = mapTableObject.getString("sWidth");
String sHeight = mapTableObject.getString("sHeight");
int nQty = mapTableObject.getInt("nQty");
String sUnit = mapTableObject.getString("sUnit");

//Start point for text
Point3d ptTxt = _Pt0 - _YW * .5 * dRowHeight;

//PLine of the object

double dCW=0;
//Draw the table object information
dp.draw(sDescription, ptTxt + _XW * (dCW+dColumnWidthAr[0]*0.5), _XW, _YW, 0, 0); dCW+=dColumnWidthAr[0];
dp.draw(sWidth, ptTxt + _XW * (dCW+dColumnWidthAr[1]*0.5), _XW, _YW, 0, 0); dCW+=dColumnWidthAr[1];
dp.draw(sHeight, ptTxt + _XW * (dCW+dColumnWidthAr[2]*0.5), _XW, _YW, 0, 0); dCW+=dColumnWidthAr[2];
dp.draw(nQty, ptTxt + _XW * (dCW+dColumnWidthAr[3]*0.5), _XW, _YW, 0, 0); dCW+=dColumnWidthAr[3];
dp.draw(sUnit, ptTxt + _XW * (dCW+dColumnWidthAr[4]*0.5), _XW, _YW, 0, 0); dCW+=dColumnWidthAr[4];


//Set comparison key; used for numbering
setCompareKey(sDescription + sWidth);

String sQty=(String) nQty;
exportToDxi(TRUE);
dxaout(sGroup, "");
dxaout("MODEL", sDescription);
dxaout("QUANTITY", sQty);


Map mp;
mp.setString("Name", sDescription);
mp.setInt("Qty", nQty);

_Map.setMap("TSLBOM", mp);







#End
#BeginThumbnail











#End
