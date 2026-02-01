#Version 8
#BeginDescription
Sets the material, grade and information for beams in a floor, based on beamcodes

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 8.07.2015  -  version 1.11







#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 11
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
* date: 01.07.2010
* version 1.0: Release Version
*
* date: 13.07.2010
* version 1.1: Any beam that doesnt have a code will be set as Joist or with the name of the profile
*
* date: 16.07.2010
* version 1.2: Add Properties for all the beam names
*
* date: 08.10.2010
* version 1.3: Allow the user to select a material for the joist
*
* date: 08.10.2010
* version 1.4: Also include the material to beams with code 'J'
*
* date: 19.10.2010
* version 1.5: Set the subLabel of the beams with the group of the element
*
* date: 27.10.2010
* version 1.6: Add the options for material, grade and information
*
* date: 27.10.2010
* version 1.6: Add the options for other material for Beams with code J
*
* date: 15.03.2010
* version 1.8: Add beam types to the Beams
*
* date: 03.05.2012
* version 1.9: Change Glulam and add some beam types compatible with iPro
*/

_ThisInst.setSequenceNumber(100);

Unit(1,"mm"); // script uses mm

String sArNY[] = {T("No"), T("Yes")};

String sMaterials[]={"Other Material", "Alpine SpaceJoist", "Alpine FloorTrus"};
String sMaterialToSet[]={"Other Material", "SpaceJoist.47", "FloorTrus.47"};
PropString sJoistMaterial (0, sMaterials, T("Joist Material"));
sJoistMaterial.setDescription(T("This option will set the Material of Joist and beams with code J"));

PropString sOtherMaterial (1, "**Other Type**", T("Other Material"));
sOtherMaterial.setDescription( T("Please fill this value if you choose 'Other Material' above"));

PropString sSetLabel(2, sArNY, T("Set subLabel with Group Name"),1);
sSetLabel.setDescription(T("Set the sublabel field with the name of the group that the wall belongs to"));
int bSetLabel = sArNY.find(sSetLabel,0);

PropString sbmName04(3, "Joist", T("Name Joist"));
PropInt nColorDef04 (0, 32, T("    Joist Color"));
nColorDef04.setDescription("");
PropString sbmMaterial04(4, "", T("    Material Joist"));
PropString sbmGrade04(5, "", T("    Grade Joist"));
PropString sbmInformation04(6, "", T("    Information Joist"));

PropString sbmName10(7, "Edge Binder", T("Name Edge Binder"));
PropInt nColorDef10 (1, 1, T("    Edge Binder Color"));
nColorDef10.setDescription("");
PropString sbmMaterial10(8, "", T("    Material Edge Binder"));
PropString sbmGrade10(9, "", T("    Grade Edge Binder"));
PropString sbmInformation10(10, "", T("    Information Edge Binder"));

PropString sbmName00(11, "Rim Board", T("Name Rimboard"));
PropInt nColorDef00 (2, 1, T("  Rimboard Color"));
nColorDef00.setDescription("");
PropString sbmMaterial00(12, "", T("    Material Rimboard"));
PropString sbmGrade00(13, "", T("    Grade Rimboard"));
PropString sbmInformation00(14, "", T("    Information Rimboard"));

PropString sbmName01(15, "Facing Joist", T("Name Facing Joist"));
PropInt nColorDef01 (3, 1, T("    Facing Joist Color"));
nColorDef01.setDescription("");
PropString sbmMaterial01(16, "", T("    Material Facing Joist"));
PropString sbmGrade01(17, "", T("    Grade Facing Joist"));
PropString sbmInformation01(18, "", T("    Information Facing Joist"));

PropString sbmName02(19, "Trimmer", T("Name Trimmer"));
PropInt nColorDef02 (4, 6, T("    Trimmer Color"));
nColorDef02.setDescription("");
PropString sbmMaterial02(20, "", T("    Material Trimmer"));
PropString sbmGrade02(21, "", T("    Grade Trimmer"));
PropString sbmInformation02(22, "", T("    Information Trimmer"));

PropString sbmName03(23, "Blocking", T("Name Blocking"));
PropInt nColorDef03 (5, 40, T("    Blocking Color"));
nColorDef03.setDescription("");
PropString sbmMaterial03(24, "", T("    Material Blocking"));
PropString sbmGrade03(25, "", T("    Grade Blocking"));
PropString sbmInformation03(26, "", T("    Information Blocking"));


PropString sbmName06(27, "RimJoist", T("Name RimJoist"));
PropInt nColorDef06 (6, 40, T("    RimJoistColor"));
nColorDef06.setDescription("");
PropString sbmMaterial06(28, "", T("    Material RimJoist"));
PropString sbmGrade06(29, "", T("    Grade RimJoist"));
PropString sbmInformation06(30, "", T("    Information RimJoist"));

PropString sbmName07(31, "Kerto", T("Name Kerto"));
PropInt nColorDef07 (7, 1, T("    Kerto Color"));
nColorDef07.setDescription("");
PropString sbmMaterial07(32, "", T("    Material Kerto"));
PropString sbmGrade07(33, "", T("    Grade Kerto"));
PropString sbmInformation07(34, "", T("    Information Kerto"));

PropString sbmName08(35, "Parellam", T("Name Parellam"));
PropInt nColorDef08 (8, 1, T("    Parellam Color"));
nColorDef08.setDescription("");
PropString sbmMaterial08(36, "", T("    Material Parellam"));
PropString sbmGrade08(37, "", T("    Grade Parellam"));
PropString sbmInformation08(38, "", T("    Information Parellam"));

PropString sbmName05(39, "Backer Blocks", T("Name Backer Block"));
PropInt nColorDef05 (9, 1, T("    Backer Blocks Color"));
nColorDef05.setDescription("");
PropString sbmMaterial05(40, "", T("    Material Backer Block"));
PropString sbmGrade05(41, "", T("    Grade Backer Block"));
PropString sbmInformation05(42, "", T("    Information Backer Block"));

PropString sbmName11(43, "Web Packer", T("Name Web Packer"));
PropInt nColorDef11 (10, 40, T("    Web Packer Color"));
nColorDef11.setDescription("");
PropString sbmMaterial11(44, "", T("    Material Web Packer"));
PropString sbmGrade11(45, "", T("    Grade Web Packer"));
PropString sbmInformation11(46, "", T("    Information Web Packer"));

PropString sbmName09(47, "Cantilever Closer", T("Name Catilever Closer"));
PropInt nColorDef09 (11, 1, T("    Cantilever Closer Color"));
nColorDef09.setDescription("");
PropString sbmMaterial09(48, "", T("    Material Catilever Closer"));
PropString sbmGrade09(49, "", T("    Grade Catilever Closer"));
PropString sbmInformation09(50, "", T("    Information Catilever Closer"));

PropString sbmName12(51, "Batten", T("Name Batten"));
PropInt nColorDef12 (12, 40, T("    Batten Color"));
nColorDef12.setDescription("");
PropString sbmMaterial12(52, "", T("    Material Batten"));
PropString sbmGrade12(53, "", T("    Grade Batten"));
PropString sbmInformation12(54, "", T("    Information Batten"));

String sBmCode[0];
String sBmName[0];
String sBmMaterial[0];
String sBmGrade[0];
String sbmInfo[0];
int nBmType[0];
int nColor[0];

sBmCode.append("Rimboard");			sBmName.append(sbmName00);		nColor.append(nColorDef00);	sBmMaterial.append(sbmMaterial00);	sBmGrade.append(sbmGrade00);	sbmInfo.append(sbmInformation00);	nBmType.append(_kRimBeam);
sBmCode.append("FacingJoist");			sBmName.append(sbmName01);		nColor.append(nColorDef01);	sBmMaterial.append(sbmMaterial01);	sBmGrade.append(sbmGrade01);	sbmInfo.append(sbmInformation01);	nBmType.append(_kRimBeam);
sBmCode.append("Trimmer");			sBmName.append(sbmName02);		nColor.append(nColorDef02);	sBmMaterial.append(sbmMaterial02);	sBmGrade.append(sbmGrade02);	sbmInfo.append(sbmInformation02);	nBmType.append(_kFloorBeam);
sBmCode.append("Blocking");			sBmName.append(sbmName03);		nColor.append(nColorDef03);	sBmMaterial.append(sbmMaterial03);	sBmGrade.append(sbmGrade03);	sbmInfo.append(sbmInformation03);	nBmType.append(_kBlocking);
sBmCode.append("B");					sBmName.append(sbmName03);		nColor.append(nColorDef03);	sBmMaterial.append(sbmMaterial03);	sBmGrade.append(sbmGrade03);	sbmInfo.append(sbmInformation03);	nBmType.append(_kBlocking);
sBmCode.append("D");					sBmName.append(sbmName03);		nColor.append(nColorDef03);	sBmMaterial.append(sbmMaterial03);	sBmGrade.append(sbmGrade03);	sbmInfo.append(sbmInformation03);	nBmType.append(_kBlocking);
sBmCode.append("Joist");				sBmName.append(sbmName04);		nColor.append(nColorDef04);	sBmMaterial.append(sbmMaterial04);	sBmGrade.append(sbmGrade04);	sbmInfo.append(sbmInformation04);	nBmType.append(_kJoist);
//sBmCode.append("J");					sBmName.append(sbmName04);		nColor.append(12);			sBmMaterial.append(sbmMaterial04);	sBmGrade.append(sbmGrade04);	sbmInfo.append(sbmInformation04);	nBmType.append(_kJoist);
sBmCode.append("Backerblocks");		sBmName.append(sbmName05);		nColor.append(nColorDef05);	sBmMaterial.append(sbmMaterial05);	sBmGrade.append(sbmGrade05);	sbmInfo.append(sbmInformation05);	nBmType.append(_kSFPacker);
sBmCode.append("RimJoist");				sBmName.append(sbmName06);		nColor.append(nColorDef06);	sBmMaterial.append(sbmMaterial06);	sBmGrade.append(sbmGrade06);	sbmInfo.append(sbmInformation06);	nBmType.append(_kRimJoist);
sBmCode.append("Kerto");				sBmName.append(sbmName07);		nColor.append(nColorDef07);	sBmMaterial.append(sbmMaterial07);	sBmGrade.append(sbmGrade07);	sbmInfo.append(sbmInformation07);	nBmType.append(_kSupportingCrossBeam);
sBmCode.append("Parellam");			sBmName.append(sbmName08);		nColor.append(nColorDef08);	sBmMaterial.append(sbmMaterial08);	sBmGrade.append(sbmGrade08);	sbmInfo.append(sbmInformation08);	nBmType.append(_kSupportingCrossBeam);
sBmCode.append("CantileverCloser");	sBmName.append(sbmName09);		nColor.append(nColorDef09);	sBmMaterial.append(sbmMaterial09);	sBmGrade.append(sbmGrade09);	sbmInfo.append(sbmInformation09);	nBmType.append(_kCantileverBlock);

sBmCode.append("EDGEBINDER");		sBmName.append(sbmName10);		nColor.append(nColorDef10);	sBmMaterial.append(sbmMaterial10);	sBmGrade.append(sbmGrade10);	sbmInfo.append(sbmInformation10);	nBmType.append(_kRimBeam);
sBmCode.append("WebPacker");			sBmName.append(sbmName11);		nColor.append(nColorDef11);	sBmMaterial.append(sbmMaterial11);	sBmGrade.append(sbmGrade11);	sbmInfo.append(sbmInformation11);	nBmType.append(_kExtraBlock);
sBmCode.append("Batten");				sBmName.append(sbmName12);		nColor.append(nColorDef12);	sBmMaterial.append(sbmMaterial12);	sBmGrade.append(sbmGrade12);	sbmInfo.append(sbmInformation12);	nBmType.append(_kLath);
//sBmCode.append("");					sBmName.append("Joist");				nColor.append(32);

if(_bOnInsert)
{
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}

	if (_kExecuteKey=="")
		showDialogOnce();
}

if (_bOnDbCreated || _bOnInsert) setPropValuesFromCatalog(_kExecuteKey);

int nMaterial = sMaterials.find(sJoistMaterial ,0);
sMaterialToSet[0]=sOtherMaterial;
String sMaterial=sMaterialToSet[nMaterial];

if(_bOnInsert)
{
	PrEntity ssE(T("Please select Elements"),ElementRoof());
 	if (ssE.go())
	{
 		Element ents[0];
 		ents = ssE.elementSet();
 		for (int i = 0; i < ents.length(); i++ )
		 {
 			ElementRoof el = (ElementRoof) ents[i];
			if (el.bIsValid())
				_Element.append(el);
 		 }
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
	lstPropString.append(sJoistMaterial);
	
	lstPropString.append(sOtherMaterial);	
	lstPropString.append(sSetLabel);

	lstPropString.append(sbmName04);
	lstPropInt.append(nColorDef04);
	lstPropString.append(sbmMaterial04);
	lstPropString.append(sbmGrade04);
	lstPropString.append(sbmInformation04);
	
	lstPropString.append(sbmName10);
	lstPropInt.append(nColorDef10);
	lstPropString.append(sbmMaterial10);
	lstPropString.append(sbmGrade10);
	lstPropString.append(sbmInformation10);
	
	lstPropString.append(sbmName00);
	lstPropInt.append(nColorDef00);
	lstPropString.append(sbmMaterial00);
	lstPropString.append(sbmGrade00);
	lstPropString.append(sbmInformation00);

	lstPropString.append(sbmName01);
	lstPropInt.append(nColorDef01);
	lstPropString.append(sbmMaterial01);
	lstPropString.append(sbmGrade01);
	lstPropString.append(sbmInformation01);
	
	lstPropString.append(sbmName02);
	lstPropInt.append(nColorDef02);
	lstPropString.append(sbmMaterial02);
	lstPropString.append(sbmGrade02);
	lstPropString.append(sbmInformation02);

	lstPropString.append(sbmName03);
	lstPropInt.append(nColorDef03);
	lstPropString.append(sbmMaterial03);
	lstPropString.append(sbmGrade03);
	lstPropString.append(sbmInformation03);
	
	lstPropString.append(sbmName06);
	lstPropInt.append(nColorDef06);	
	lstPropString.append(sbmMaterial06);
	lstPropString.append(sbmGrade06);
	lstPropString.append(sbmInformation06);

	lstPropString.append(sbmName07);
	lstPropInt.append(nColorDef07);	
	lstPropString.append(sbmMaterial07);
	lstPropString.append(sbmGrade07);
	lstPropString.append(sbmInformation07);

	lstPropString.append(sbmName08);
	lstPropInt.append(nColorDef08);	
	lstPropString.append(sbmMaterial08);
	lstPropString.append(sbmGrade08);
	lstPropString.append(sbmInformation08);
	
	lstPropString.append(sbmName05);
	lstPropInt.append(nColorDef05);	
	lstPropString.append(sbmMaterial05);
	lstPropString.append(sbmGrade05);
	lstPropString.append(sbmInformation05);

	lstPropString.append(sbmName11);
	lstPropInt.append(nColorDef11);	
	lstPropString.append(sbmMaterial11);
	lstPropString.append(sbmGrade11);
	lstPropString.append(sbmInformation11);
	
	lstPropString.append(sbmName09);
	lstPropInt.append(nColorDef09);	
	lstPropString.append(sbmMaterial09);
	lstPropString.append(sbmGrade09);
	lstPropString.append(sbmInformation09);

	lstPropString.append(sbmName12);
	lstPropInt.append(nColorDef12);	
	lstPropString.append(sbmMaterial12);
	lstPropString.append(sbmGrade12);
	lstPropString.append(sbmInformation12);
	

	
	Map mpToClone;
	mpToClone.setInt("nExecutionMode", 1);
	
	for( int e=0; e<_Element.length(); e++ )
	{
		Element el = _Element[e];
	
		lstElements.setLength(0);
		lstElements.append(el);
	
		TslInst tsl;
		tsl.dbCreate(strScriptName, vecUcsX,vecUcsY, lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModel, mpToClone);
	}
	eraseInstance();
	return;
}

if (_bOnElementConstructed)
{
	_Map.setInt("nExecutionMode", 1);
}

if (_Element.length()==0)
{
	eraseInstance();
	return;
}

//On
int nExecutionMode=0;
if (_Map.hasInt("nExecutionMode"))
{
	nExecutionMode=_Map.getInt("nExecutionMode");
}

ElementRoof el=(ElementRoof) _Element[0];
if (!el.bIsValid())
{
	eraseInstance();
	return;
}

_Pt0=el.ptOrg();

if (nExecutionMode)
{

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

	Beam bmAll[]=el.beam();
	if (bmAll.length()<1)	
	{
		return;
	}

	Group groupName=el.elementGroup();
	String sGroupName=groupName.namePart(0)+"\\";
	sGroupName+=groupName.namePart(1);

	//Convert all the codes in capital letters
	for (int i=0; i<sBmCode.length(); i++)
	{
		sBmCode[i]=sBmCode[i].makeUpper();
	}
	
	//Set the name off al the beams base on the code
	for (int i=0; i<bmAll.length(); i++)
	{
		Beam bm=bmAll[i];
		
		if (bm.myZoneIndex()!=0) continue;
		
		String sBeamCode=bmAll[i].beamCode().token(0);
		sBeamCode.makeUpper();
		if (sBeamCode=="")
		{
			String sProfile=bmAll[i].extrProfile();
			sProfile.makeUpper();
			if (sProfile!="RECTANGULAR")
			{
				bm.setName(bm.extrProfile());
			}
			else
			{
				bm.setName(sbmName04);
				bm.setMaterial(sbmMaterial04);
				bm.setGrade(sbmGrade04);
			}
		}
		else
		{
			
			int nLocation=sBmCode.find(sBeamCode, -1);
			if (nLocation!=-1)
			{
				bm.setName(sBmName[nLocation]);
				bm.setColor(nColor[nLocation]);
				bm.setMaterial(sBmMaterial[nLocation]);
				bm.setGrade(sBmGrade[nLocation]);
				bm.setInformation(sbmInfo[nLocation]);
				bm.setType(nBmType[nLocation]);
			}
			
			if (sBeamCode=="J")
				bm.setMaterial(sMaterial);

		}
		
		if (bSetLabel)
		{
			bm.setSubLabel(sGroupName);
		}
	}
	
	Sheet sh1[]=el.sheet(1);
	for (int i=0; i<sh1.length(); i++)
	{
		sh1[i].setName(sh1[i].material());
	}
	Sheet sh6[]=el.sheet(-1);
	for (int i=0; i<sh6.length(); i++)
	{
		sh6[i].setName(sh6[i].material());
	}
	Sheet sh2[]=el.sheet(2);
	for (int i=0; i<sh2.length(); i++)
	{
		sh2[i].setName(sh2[i].material());
	}

	Sheet sh7[]=el.sheet(-2);
	for (int i=0; i<sh7.length(); i++)
	{
		sh7[i].setName(sh7[i].material());
	}
	
	Sheet sh3[]=el.sheet(3);
	for (int i=0; i<sh3.length(); i++)
	{
		sh3[i].setName(sh3[i].material());
	}
	
	Sheet sh8[]=el.sheet(-5);
	for (int i=0; i<sh8.length(); i++)
	{
		sh8[i].setName(sh8[i].material());
	}
	
	Sheet sh4[]=el.sheet(4);
	for (int i=0; i<sh4.length(); i++)
	{
		sh4[i].setName(sh4[i].material());
	}
	
	Sheet sh9[]=el.sheet(-4);
	for (int i=0; i<sh9.length(); i++)
	{
		sh9[i].setName(sh9[i].material());
	}
	
}

Display dp(-1);
dp.draw("", _Pt0, _XW, _YW, 0, 0);

// assigning
assignToElementGroup(el, TRUE, 0, 'I');

_Map.setInt("nExecutionMode", 0);
































#End
#BeginThumbnail














#End