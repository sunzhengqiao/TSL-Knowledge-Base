#Version 8
#BeginDescription
Set the material and beam type of the beams that are draw in a floor

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 24.03.2016  -  version 1.5














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
* date: 30.04.2012
* version 1.1: First version
*
* date: 31.05.2012
* version 1.2: Add Name and grade as a property
*
* date: 03.08.2012
* version 1.4: Add beam type _kSupportingCrossBeam
*
* date: 10.10.2012
* version 1.5: Removed check for grade to see if it is empty.  If property is empty it will overwrite the grade to empty
*/

_ThisInst.setSequenceNumber(0);

Unit (1, "mm");

String sPath= _kPathHsbCompany+"\\Abbund\\Materials.xml";

String sFind=findFile(sPath);

if (sFind=="")
{
	reportNotice("\n Materials not been set, please run hsbMaterial Utility or contact SupportDesk");
	//eraseInstance();
	//return;
}

Map mp;
mp.readFromXmlFile(sPath);

String sMaterial[0];

if (mp.hasMap("MATERIAL[]"))
{
	Map mpMaterials=mp.getMap("MATERIAL[]");
	for(int i=0; i<mpMaterials.length(); i++)
	{
		Map mpMaterial=mpMaterials.getMap(i);
		if (mpMaterial.getString("MATERIAL")!="DEFAULT")
			sMaterial.append(mpMaterial.getString("MATERIAL"));
	}
}

if (sMaterial.length()==0)
{
	reportNotice("\n Materials not been set, please run hsbMaterial Utility or contact SupportDesk");
	//eraseInstance();
	//return;
}

PropString sBeamName9(32, "", T("Name")+"        ");					sBeamName9.setCategory("Standard Joist");
PropString sBeamMaterial9(33, sMaterial, T("Material")+"        ");		sBeamMaterial9.setCategory("Standard Joist");
PropString sBeamGrade9(34, "", T("Grade")+"        ");					sBeamGrade9.setCategory("Standard Joist");
PropInt nColor9(0, 32, T("Color")+"        ");								nColor9.setCategory("Standard Joist");

PropString sBeamName10(35, "", T("Name")+"         ");					sBeamName10.setCategory("Transverse Joist");
PropString sBeamMaterial10(36, sMaterial, T("Material")+"         ");		sBeamMaterial10.setCategory("Transverse Joist");
PropString sBeamGrade10(37, "", T("Grade")+"         ");					sBeamGrade10.setCategory("Transverse Joist");
PropInt nColor10(1, 32, T("Color")+"         ");								nColor10.setCategory("Transverse Joist");

PropString sBeamCode1(0, "", T("Beam Code"));				sBeamCode1.setCategory("Code 1");
PropString sBeamName1(1, "", T("Beam Name"));			sBeamName1.setCategory("Code 1");
PropString sBeamMaterial1(2, sMaterial, T("Material"));		sBeamMaterial1.setCategory("Code 1");
PropString sBeamGrade1(3, "", T("Grade"));					sBeamGrade1.setCategory("Code 1");
PropInt nColor1(2, 32, T("Color"));								nColor1.setCategory("Code 1");

PropString sBeamCode2(4, "", T("Beam Code")+" ");				sBeamCode2.setCategory("Code 2");
PropString sBeamName2(5, "", T("Beam Name")+" ");			sBeamName2.setCategory("Code 2");
PropString sBeamMaterial2(6, sMaterial, T("Material")+" ");		sBeamMaterial2.setCategory("Code 2");
PropString sBeamGrade2(7, "", T("Grade")+" ");					sBeamGrade2.setCategory("Code 2");
PropInt nColor2(3, 32, T("Color")+" ");								nColor2.setCategory("Code 2");

PropString sBeamCode3(8, "", T("Beam Code")+"  ");			sBeamCode3.setCategory("Code 3");
PropString sBeamName3(9, "", T("Beam Name")+"  ");			sBeamName3.setCategory("Code 3");
PropString sBeamMaterial3(10, sMaterial, T("Material")+"  ");	sBeamMaterial3.setCategory("Code 3");
PropString sBeamGrade3(11, "", T("Grade")+"  ");				sBeamGrade3.setCategory("Code 3");
PropInt nColor3(4, 32, T("Color")+"  ");								nColor3.setCategory("Code 3");

PropString sBeamCode4(12, "", T("Beam Code")+"   ");			sBeamCode4.setCategory("Code 4");
PropString sBeamName4(13, "", T("Beam Name")+"   ");			sBeamName4.setCategory("Code 4");
PropString sBeamMaterial4(14, sMaterial, T("Material")+"   ");	sBeamMaterial4.setCategory("Code 4");
PropString sBeamGrade4(15, "", T("Grade")+"   ");				sBeamGrade4.setCategory("Code 4");
PropInt nColor4(5, 32, T("Color")+"   ");								nColor4.setCategory("Code 4");

PropString sBeamCode5(16, "", T("Beam Code")+"    ");				sBeamCode5.setCategory("Code 5");
PropString sBeamName5(17, "", T("Beam Name")+"    ");				sBeamName5.setCategory("Code 5");
PropString sBeamMaterial5(18, sMaterial, T("Material")+"    ");		sBeamMaterial5.setCategory("Code 5");
PropString sBeamGrade5(19, "", T("Grade")+"    ");					sBeamGrade5.setCategory("Code 5");
PropInt nColor5(6, 32, T("Color")+"    ");								nColor5.setCategory("Code 5");

PropString sBeamCode6(20, "", T("Beam Code")+"     ");				sBeamCode6.setCategory("Code 6");
PropString sBeamName6(21, "", T("Beam Name")+"     ");				sBeamName6.setCategory("Code 6");
PropString sBeamMaterial6(22, sMaterial, T("Material")+"     ");		sBeamMaterial6.setCategory("Code 6");
PropString sBeamGrade6(23, "", T("Grade")+"     ");					sBeamGrade6.setCategory("Code 6");
PropInt nColor6(7, 32, T("Color")+"     ");								nColor6.setCategory("Code 6");

PropString sBeamCode7(24, "", T("Beam Code")+"      ");				sBeamCode7.setCategory("Code 7");
PropString sBeamName7(25, "", T("Beam Name")+"      ");				sBeamName7.setCategory("Code 7");
PropString sBeamMaterial7(26, sMaterial, T("Material")+"      ");		sBeamMaterial7.setCategory("Code 7");
PropString sBeamGrade7(27, "", T("Grade")+"      ");					sBeamGrade7.setCategory("Code 7");
PropInt nColor7(8, 32, T("Color")+"     ");								nColor7.setCategory("Code 7");

PropString sBeamCode8(28, "", T("Beam Code")+"       ");				sBeamCode8.setCategory("Code 8");
PropString sBeamName8(29, "", T("Beam Name")+"       ");				sBeamName8.setCategory("Code 8");
PropString sBeamMaterial8(30, sMaterial, T("Material")+"       ");		sBeamMaterial8.setCategory("Code 8");
PropString sBeamGrade8(31, "", T("Grade")+"       ");					sBeamGrade8.setCategory("Code 8");
PropInt nColor8(9, 32, T("Color")+"      ");									nColor8.setCategory("Code 8");




//This beam types will be used to set the codes.
String sbmCode[0];
int nBmTypeByCode[0];
nBmTypeByCode.append(_kExtraBlock);			sbmCode.append("ST");

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

if(_bOnInsert){
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	if (_kExecuteKey=="")
		showDialogOnce();
	PrEntity ssE("\n"+T("Select a set of elements"),Element());
	
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	return;
}

if (_Element.length()==0)
{
	eraseInstance();
	return;
}


int nErase=false;

sBeamCode1.trimLeft();	sBeamCode1.trimRight();
sBeamCode2.trimLeft();	sBeamCode2.trimRight();
sBeamCode3.trimLeft();	sBeamCode3.trimRight();
sBeamCode4.trimLeft();	sBeamCode4.trimRight();
sBeamCode5.trimLeft();	sBeamCode5.trimRight();
sBeamCode6.trimLeft();	sBeamCode6.trimRight();
sBeamCode7.trimLeft();	sBeamCode7.trimRight();
sBeamCode8.trimLeft();	sBeamCode8.trimRight();

String sCodes[0];
String sNames[0];
String sMaterials[0];
String sGrades[0];
int nColor[0];

if (sBeamCode1!="")
{
	sBeamCode1.makeUpper();
	sCodes.append(sBeamCode1);
	sBeamName1.trimLeft(); sBeamName1.trimRight();
	sNames.append(sBeamName1);
	sBeamMaterial1.trimLeft(); sBeamMaterial1.trimRight();
	sMaterials.append(sBeamMaterial1);
	sBeamGrade1.trimLeft(); sBeamGrade1.trimRight();
	sGrades.append(sBeamGrade1);
	nColor.append(nColor1);
	
}
if (sBeamCode2!="")
{
	sBeamCode2.makeUpper();
	sCodes.append(sBeamCode2);
	sBeamName2.trimLeft(); sBeamName2.trimRight();
	sNames.append(sBeamName2);
	sBeamMaterial2.trimLeft(); sBeamMaterial2.trimRight();
	sMaterials.append(sBeamMaterial2);
	sBeamGrade2.trimLeft(); sBeamGrade2.trimRight();
	sGrades.append(sBeamGrade2);
	nColor.append(nColor2);
}
if (sBeamCode3!="")
{
	sBeamCode3.makeUpper();
	sCodes.append(sBeamCode3);
	sBeamName3.trimLeft(); sBeamName3.trimRight();
	sNames.append(sBeamName3);
	sBeamMaterial3.trimLeft(); sBeamMaterial3.trimRight();
	sMaterials.append(sBeamMaterial3);
	sBeamGrade3.trimLeft(); sBeamGrade3.trimRight();
	sGrades.append(sBeamGrade3);
	nColor.append(nColor3);
}
if (sBeamCode4!="")
{
	sBeamCode4.makeUpper();
	sCodes.append(sBeamCode4);
	sBeamName4.trimLeft(); sBeamName4.trimRight();
	sNames.append(sBeamName4);
	sBeamMaterial4.trimLeft(); sBeamMaterial4.trimRight();
	sMaterials.append(sBeamMaterial4);
	sBeamGrade4.trimLeft(); sBeamGrade4.trimRight();
	sGrades.append(sBeamGrade4);
	nColor.append(nColor4);
}
if (sBeamCode5!="")
{
	sBeamCode5.makeUpper();
	sCodes.append(sBeamCode5);
	sBeamName5.trimLeft(); sBeamName5.trimRight();
	sNames.append(sBeamName5);
	sBeamMaterial5.trimLeft(); sBeamMaterial5.trimRight();
	sMaterials.append(sBeamMaterial5);
	sBeamGrade5.trimLeft(); sBeamGrade5.trimRight();
	sGrades.append(sBeamGrade5);
	nColor.append(nColor5);
}
if (sBeamCode6!="")
{
	sBeamCode6.makeUpper();
	sCodes.append(sBeamCode6);
	sBeamName6.trimLeft(); sBeamName6.trimRight();
	sNames.append(sBeamName6);
	sBeamMaterial6.trimLeft(); sBeamMaterial6.trimRight();
	sMaterials.append(sBeamMaterial6);
	sBeamGrade6.trimLeft(); sBeamGrade6.trimRight();
	sGrades.append(sBeamGrade6);
	nColor.append(nColor6);
}
if (sBeamCode7!="")
{
	sBeamCode7.makeUpper();
	sCodes.append(sBeamCode7);
	sBeamName7.trimLeft(); sBeamName7.trimRight();
	sNames.append(sBeamName7);
	sBeamMaterial7.trimLeft(); sBeamMaterial7.trimRight();
	sMaterials.append(sBeamMaterial7);
	sBeamGrade7.trimLeft(); sBeamGrade7.trimRight();
	sGrades.append(sBeamGrade7);
	nColor.append(nColor7);
}

if (sBeamCode8!="")
{
	sBeamCode8.makeUpper();
	sCodes.append(sBeamCode8);
	sBeamName8.trimLeft(); sBeamName8.trimRight();
	sNames.append(sBeamName8);
	sBeamMaterial8.trimLeft(); sBeamMaterial8.trimRight();
	sMaterials.append(sBeamMaterial8);
	sBeamGrade8.trimLeft(); sBeamGrade8.trimRight();
	sGrades.append(sBeamGrade8);
	nColor.append(nColor8);
}

for (int e=0; e<_Element.length(); e++)
{
	int nIsTransvese=false;
	ElementRoof elR=(ElementRoof) _Element[e];
	
	if (elR.bIsValid())
	{
	nIsTransvese=elR.bPurlin();
	}
	
	Beam bmAll[]=_Element[e].beam();
	
	for (int i=0; i<bmAll.length(); i++)
	{
		Beam bm=bmAll[i];
		
		int nThisBeamType=bm.type();
		
		int nLocationByCode=nBmTypeByCode.find(nThisBeamType, -1);
		if (nLocationByCode!=-1)
		{
			bm.setBeamCode(sbmCode[nLocationByCode]);
		}
		
		String sCode=bm.beamCode().token(0);
		sCode.trimLeft(); sCode.trimRight(); sCode.makeUpper();
		
		int nLocation=sCodes.find(sCode, -1);
		
		if (nLocation!=-1)
		{
			bm.setName(sNames[nLocation]);
			bm.setMaterial(sMaterials[nLocation]);
			bm.setGrade(sGrades[nLocation]);
			bm.setColor(nColor[nLocation]);
		}
		
		
		if (sCode=="")
		{
			if (bm.myZoneIndex()!=0) continue;
			
			String sProfile=bmAll[i].extrProfile();
			sProfile.makeUpper();
			if (sProfile!="RECTANGULAR")
			{
				bm.setName(bm.extrProfile());
			}
			else
			{
				if (nIsTransvese)
				{
					bm.setName(sBeamName10);
					bm.setMaterial(sBeamMaterial10);
					bm.setGrade(sBeamGrade10);
					bm.setColor(nColor10);
				}
				else
				{
					bm.setName(sBeamName9);
					bm.setMaterial(sBeamMaterial9);
					bm.setGrade(sBeamGrade9);
					bm.setColor(nColor9);
				}
			}
		}
		nErase=true;
	}
}

if (_bOnElementConstructed || nErase)
{
	eraseInstance();
	return;
}




#End
#BeginThumbnail






#End