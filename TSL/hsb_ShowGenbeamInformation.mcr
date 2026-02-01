#Version 8
#BeginDescription
Displays various properties of a genbeam with a delimiter

Created by: Alberto Jena (aj@itw-industry.com)
date: 02.12.2014  -  version 2.0













#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 0
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2011 by
*  ITW Industry UK
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
* Created by: Chirag Sawjani (cs@itw-industry.com)
* date: 26.08.2011
* version 1.0: Displays various properties of a genbeam with a delimiter
*
* date: 24.04.2012
* version 1.1: Add solid length
*
* date: 11.01.2013
* version 1.2: Add width, height and posnum
*
* date: 11.01.2013
* version 1.3: Fix issue when the TSL was clone*/

Unit (1, "mm");

//String has been kept to maintain comptatibility with older verisions using No, Yes instead of index of property index
String sArNY[] = {T("No"), T("1"), T("2"), T("3"), T("4"), T("5"), T("6"), T("7"), T("8"), T("9"), T("10"), T("11")};

PropString sDimStyle(0,_DimStyles,T("Dimstyle"));

PropInt nColor (0,130,T("Color"));
PropInt nHeight(1, 80, T("Enter Text Height"));

PropDouble nOffset (0,U(250),T("Offset from Beam"));
PropDouble dRotation (1,0,T("Set Rotation"));

PropString sDispRepHead(1,"",T("Disp Rep Header"));
PropString sDelimiter(2,"-",T("Delimiters between properties"));
sDelimiter.setDescription(T("|Separate multiple entries by|") +" ';'");

PropString sShowName(3,sArNY,T("Show Name"),1);
PropString sShowMaterial(4,sArNY,T("Show Material"),1);
PropString sShowGrade(5,sArNY,T("Show Grade"),1);
PropString sShowInformation(6,sArNY,T("Show Information"),1);
PropString sShowLabel(7,sArNY,T("Show Label"),1);
PropString sShowSubLabel(8,sArNY,T("Show SubLabel"),1);
PropString sShowSubLabel2(9,sArNY,T("Show SubLabel2"),1);
PropString sShowWidth(12,sArNY,T("Show Width"),1);
PropString sShowHeight(13,sArNY,T("Show Height"),1);
PropString sShowLength(10,sArNY,T("Show Length"),1);
PropString sShowPosNum(11,sArNY,T("Show Posnum"),1);

int nShowName = sArNY.find(sShowName, 0);
int nShowMaterial= sArNY.find(sShowMaterial, 0);
int nShowGrade= sArNY.find(sShowGrade, 0);
int nShowInformation= sArNY.find(sShowInformation, 0);
int nShowLabel= sArNY.find(sShowLabel, 0);
int nShowSubLabel= sArNY.find(sShowSubLabel, 0);
int nShowSubLabel2= sArNY.find(sShowSubLabel2, 0);
int nShowLength= sArNY.find(sShowLength, 0);
int nShowPosNum= sArNY.find(sShowPosNum, 0);
int nShowWidth= sArNY.find(sShowWidth, 0);
int nShowHeight= sArNY.find(sShowHeight, 0);

if (_bOnInsert || _bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

if(_bOnInsert)
{
	if (insertCycleCount()>1) { eraseInstance(); return; }

	if (_kExecuteKey=="")
		showDialogOnce();

	PrEntity ssE(T("Please select Beams"),GenBeam());
 	if (ssE.go())
	{
 		Entity ents[0];
 		ents = ssE.set();
 		for (int i = 0; i < ents.length(); i++ )
		 {
 			GenBeam bm1 = (GenBeam) ents[i];
 			_GenBeam.append(bm1);
 		 }
 	}

	//Clonning TSL 
	TslInst tsl;
	String sScriptName = scriptName(); // name of the script
	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
	Entity lstEnts[0];
	Beam lstBeams[0];
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
		
	lstPropString.append(sDimStyle);
	lstPropString.append(sDispRepHead);
	lstPropString.append(sDelimiter);
	lstPropString.append(sShowName);
	lstPropString.append(sShowMaterial);
	lstPropString.append(sShowGrade);
	lstPropString.append(sShowInformation);
	lstPropString.append(sShowLabel);
	lstPropString.append(sShowSubLabel);
	lstPropString.append(sShowSubLabel2);
	lstPropString.append(sShowLength);
	lstPropString.append(sShowPosNum);
	lstPropString.append(sShowWidth);
	lstPropString.append(sShowHeight);		
	
	
	lstPropInt.append(nColor);
	lstPropInt.append(nHeight);
	lstPropDouble.append(nOffset);
	//lstPropDouble.append(nOffsetX);
	lstPropDouble.append(dRotation);
		
	for (int e=0; e<_GenBeam.length(); e++)
	{
		TslInst tslIns[]=_GenBeam[e].tslInstAttached();
		for (int i=0; i<tslIns.length(); i++)
		{
			if (tslIns[i].scriptName()==scriptName() && tslIns[i].handle()!=_ThisInst.handle())
				tslIns[i].dbErase();
		}

		lstEnts.setLength(0);
		lstEnts.append(_GenBeam[e]);
		tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,	lstPropInt, lstPropDouble,lstPropString);
	}

	eraseInstance();
	return;
}

nOffset.setReadOnly(true);
dRotation.setReadOnly(true);

if(_Entity.length()==0) eraseInstance();
GenBeam bm = (GenBeam) _Entity[0];
if (!bm.bIsValid()) 
{
	eraseInstance();
	return;
}

setDependencyOnEntity(bm);

Vector3d vX=bm.vecX();
Vector3d vZ=bm.vecZ();
Point3d ptDraw=bm.ptCen();

CoordSys cs3;
cs3.setToRotation(dRotation, _ZW, ptDraw);
//setToRotation(dRotation, Vector3d vecAxis, Point3d ptCenter);


Vector3d vecTextX=bm.vecX();
vecTextX.transformBy(cs3);
Vector3d vecTextZ=_ZW.crossProduct(vecTextX);//vecTextX.crossProduct(bm.vecY());
vecTextZ.normalize();

Display dp(nColor);
dp.dimStyle(sDimStyle);
dp.textHeight(nHeight);

String arDescriptions[0];
String arOrder[0];
if(nShowName) { arDescriptions.append(bm.name()); arOrder.append(sArNY[nShowName]); }
if(nShowMaterial) { arDescriptions.append(bm.material()); arOrder.append(sArNY[nShowMaterial]); }
if(nShowGrade) { arDescriptions.append(bm.grade()); arOrder.append(sArNY[nShowGrade]); }
if(nShowInformation) { arDescriptions.append(bm.information()); arOrder.append(sArNY[nShowInformation]); }
if(nShowLabel) { arDescriptions.append(bm.label()); arOrder.append(sArNY[nShowLabel]); }
if(nShowSubLabel) { arDescriptions.append(bm.subLabel()); arOrder.append(sArNY[nShowSubLabel2]); }
if(nShowSubLabel2) { arDescriptions.append(bm.subLabel2()); arOrder.append(sArNY[nShowSubLabel2]); }
if(nShowWidth) { arDescriptions.append(String().formatUnit(bm.solidWidth(),2,0)); arOrder.append(sArNY[nShowWidth]); }
if(nShowHeight) { arDescriptions.append(String().formatUnit(bm.solidHeight(),2,0)); arOrder.append(sArNY[nShowHeight]); }
if(nShowLength) { arDescriptions.append(String().formatUnit(bm.solidLength(),2,0)); arOrder.append(sArNY[nShowLength]); }
if(nShowPosNum) { arDescriptions.append(bm.posnum()); arOrder.append(sArNY[nShowPosNum]); }

//Sort
for(int s1=1; s1<arDescriptions.length(); s1++)
{
	int s11 = s1;
	int nSortIndex=arOrder[s1].atoi();
	for(int s2=s1-1; s2>=0; s2--)
	{
		int nCurrentSortIndex=arOrder[s2].atoi();
		if(nCurrentSortIndex > nSortIndex)
		{
			arDescriptions.swap(s2, s11);
			arOrder.swap(s2, s11);
			s11=s2;
		}
	}
}

String sDelimiters[0];
String sList = sDelimiter;
while (sList .length()>0 || sList .find(";",0)>-1)
{
	String sToken = sList .token(0);	
	sDelimiters.append(sToken);

	int x = sList .find(";",0);
	sList .delete(0,x+1);
	if (x==-1)
		sList = "";
}

//Build string
String strDesc="";
String sCurrentDelimiter="";
for(int s=0; s<arDescriptions.length(); s++)
{
	String sDescription=arDescriptions[s];
	if(sDelimiters.length() - 1 >= s)
	{
		sCurrentDelimiter=sDelimiters[s];
	}
		
	strDesc+=sDescription + sCurrentDelimiter;
}

//Remove delimiter at the end of the string
if(strDesc.right(sCurrentDelimiter.length())==sCurrentDelimiter)
{
	strDesc.trimRight(sCurrentDelimiter);
}

//If no data is in the string then display "nothing selected"
if(strDesc=="")
{
	strDesc="Nothing Selected";
}

if (!_Map.hasInt("nSetOrg"))
{
	//reportNotice(vecTextZ);
	_Pt0=ptDraw+vecTextZ*(nOffset);
	_PtG.append(_Pt0+vecTextX*U(100));
}

_Map.setInt("nSetOrg", TRUE);

Plane pln(bm.ptCen(), bm.vecD(_ZW));
_Pt0=pln.closestPointTo(_Pt0);
_PtG[0]=pln.closestPointTo(_PtG[0]);


vecTextX=_PtG[0]-_Pt0;
vecTextX.normalize();




//String test[]=_ThisInst.dispRepNames();

if (sDispRepHead!="")
	dp.showInDispRep(sDispRepHead);

dp.draw(strDesc, _Pt0, vecTextX, -vecTextZ, 0, 0, _kDevice);

_ThisInst.assignToGroups(bm);









#End
#BeginThumbnail













#End