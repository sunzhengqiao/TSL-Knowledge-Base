#Version 8
#BeginDescription
Exports ElemItem with information of the stickframe weight to the database

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 01.07.2010  -  version 1.0






#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
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
* date: 01.07.2010
* version 1.0: First version
*
*/

Unit (1, "mm");

////// THIS VALUES CAN BE CHANGE OR EXTEND TO ALLOW MORE NAMES AND WEIGHTS, ALWAYS THE STRING NEEDS TO HAVE
////// THE SAME NUMBER OF ITEMS THAN THE DOUBLE

//Sheets
String sSheetName[]={"OSB3","9MM WBP PLY","9MM PLY","18MM WBP PLY","21MM WBP PLY","18MM OSB","9MM OSB","15MM FERMACELL"};  //Name of the Sheet
double dWeightFactorSheet[]={620,463,463,463,463,463,463,1181};  // This Factor is the weight(kg) per cubic meter
//Beams
String sBeamProfile[]={"JJG 195x45","JJG 200x47","JJG 300x90","JJG 145x45","SJ45 200", "SJ45 220", "SJ45 240", "SJ45 300","SJ45 360","SJ60 200", "SJ60 220", "SJ60 240", "SJ60 300","SJ60 360","SJ60 400","SJ90 200", "SJ90 220", "SJ90 240", "SJ90 300","SJ90 360","SJ90 400"};  //Name of the Extrusion Profiles of the beams
double dWeightFactorBeam[]={4.39, 0, 13.5, 6, 2.9, 3.1, 3.2, 3.7,4.7,3.5, 3.8 ,3.9 ,4.3 ,4.8 ,5.0 ,4.8 ,5.1 ,5.1 ,5.6 ,6.2 ,6.4};  // This Factor is the weight(kg) per linear meter
//////

PropDouble dBmWeight (0, 450, T("Weight for Standard Beams (Kg/m3)"));// This Factor is the weight(kg) per cubic meter

if( _bOnInsert )
{
	if (insertCycleCount()>1) { eraseInstance(); return; }
	showDialogOnce();
	PrEntity ssE("\nSelect a set of elements",Element());
	if(ssE.go()){
		_Element.append(ssE.elementSet());
	}
	// declare tsl props
	TslInst tsl;
	String strScriptName=scriptName();
	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
	Element lstElements[0];
	Beam lstBeams[0];
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	
	lstPropDouble.append(dBmWeight);

	for( int e=0; e<_Element.length(); e++ )
	{
		lstElements.setLength(0);
		lstElements.append(_Element[e]);
	
		TslInst tsl;
		tsl.dbCreate(strScriptName, vecUcsX,vecUcsY, lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString);
	}
	eraseInstance();
	return;

}

if (_Element.length()==0)
{
	eraseInstance();
	return;
}

Element el = _Element[0];

if (!el.bIsValid())
{
	eraseInstance();
	return;
}

CoordSys csEl = el.coordSys();
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();
Point3d ptEl = csEl.ptOrg();
//ptEl.vis(2);

//Erase any other TSL with the same name
TslInst tlsAll[]=el.tslInstAttached();
for (int i=0; i<tlsAll.length(); i++)
{
	String sName = tlsAll[i].scriptName();
	if (sName == scriptName() && tlsAll[i].handle()!= _ThisInst.handle())
	{
		tlsAll[i].dbErase();
	}
}

Vector3d vXTxt = _XW;
Vector3d vYTxt = _YW;

double dWeight;
double dWeightSheets;
double dWeightBeams;
double dWeightBmStd;

Sheet shAll[]=el.sheet();

Beam bmAll[]=el.beam();

//Convert all the codes in capital letters
for (int i=0; i<sSheetName.length(); i++)
{
	sSheetName[i]=sSheetName[i].makeUpper();
}

//Convert all the codes in capital letters
for (int i=0; i<sBeamProfile.length(); i++)
{
	sBeamProfile[i]=sBeamProfile[i].makeUpper();
}

for (int i=0; i<shAll.length(); i++)
{
	String sName=shAll[i].material();
	sName.makeUpper();
	int nLocation=sSheetName.find(sName, -1);
	if (nLocation!=-1)
	{
		Body bdSheet=shAll[i].realBody();
		dWeightSheets=dWeightSheets+(bdSheet.volume()* dWeightFactorSheet[nLocation]);
	}
}
dWeightSheets=dWeightSheets/1000000000;

for (int i=0; i<bmAll.length(); i++)
{
	String sProfile=bmAll[i].extrProfile();
	//sProfile.makeUpper();
	int nLocation=sBeamProfile.find(sProfile, -1);
	if (nLocation!=-1)
	{
		//Body bdBeam=bmAll[i].realBody();
		dWeightBeams=dWeightBeams+(bmAll[i].solidLength()* dWeightFactorBeam[nLocation]);
	}
	else
	{
		dWeightBmStd=dWeightBmStd+(bmAll[i].volume()* dBmWeight);
		//dWeightBeams=dWeightBeams+(bmAll[i].solidLength()* dBmWeight);
	}
}
dWeightBmStd=dWeightBmStd/1000000000;

dWeightBeams=dWeightBeams/1000;
dWeightBeams=dWeightBeams+dWeightBmStd;

String strWeightBm;
strWeightBm.formatUnit(dWeightBeams,2,2);
strWeightBm=strWeightBm+ " Kg";

dWeight=dWeightSheets+dWeightBeams;

String strWeight;
strWeight.formatUnit(dWeight,2,2);
strWeight=strWeight+ " Kg";

Display dp(-1);
dp.draw("", _Pt0, _XW, _YW, 0, 0);

//if (dWeight!=0)
//{
//	dp.draw ("Frame Weight: "+strWeightBm, _Pt0, vXTxt, vYTxt, 1, -1);
//	dp.draw ("Total Weight: "+strWeight, _Pt0-vYTxt*U(dTextOffset) , vXTxt, vYTxt, 1, -1);
//}

String sCompareKey = el.code()+" "+el.number();

setCompareKey(sCompareKey);

//export dxa
Map itemMap= Map();
itemMap.setString("DESCRIPTION", "WEIGHT");
itemMap.setString("QUANTITY", dWeight);
ElemItem item(1, T("PANELWEIGHT"), el.ptOrg(), el.vecZ(), itemMap);
item.setShow(_kNo);
el.addTool(item);

assignToElementGroup(el, TRUE, 0, 'E');

#End
#BeginThumbnail

#End
