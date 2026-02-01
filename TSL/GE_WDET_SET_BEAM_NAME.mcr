#Version 8
#BeginDescription
Sets the timber name, material & grade based on beam types for stickframe walls, and copy the material of all the sheets to the name field.
v1.36: 22.mar.2013: David Rueda (dr@hsb-cad.com)
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 36
#KeyWords 
#BeginContents
/*
  COPYRIGHT
  ---------------
  Copyright (C) 2011 by
  hsbSOFT 

  The program may be used and/or copied only with the written
  permission from hsbSOFT, or in accordance with
  the terms and conditions stipulated in the agreement/contract
  under which the program has been supplied.

  All rights reserved.

 REVISION HISTORY
 -------------------------
 v1.0: 22.mar.2013: David Rueda (dr@hsb-cad.com)
	- Copied from hsb_SetBeamName, to keep US content folder naming standards
 v1.36: 22.mar.2013: David Rueda (dr@hsb-cad.com)
	- Version control from 1.0 to 1.36, to keep updated with hsb_SetBeamName
	- Thumbnail added
*/

_ThisInst.setSequenceNumber(100);

Unit(1,"mm"); // script uses mm

String sArNY[] = {T("No"), T("Yes")};

PropString sColor(0, sArNY, T("Set Default Color"),0);
sColor.setDescription(T("Set All the beam with Default Color"));
int bColor = sArNY.find(sColor,0);

PropString sModule(1, sArNY, T("Set Module Beam with Default Color"),0);
sModule.setDescription(T("Overwrite the Module Beam Color"));
int bModule = sArNY.find(sModule,0);

PropString sSetInfo(23, sArNY, T("Set Information Field"),1);
sSetInfo.setDescription(T("Set the information field if it doesnt have any"));
int bSetInfo = sArNY.find(sSetInfo,0);

PropString sSetLabel(26, sArNY, T("Set subLabel with Group Name"),1);
sSetLabel.setDescription(T("Set the sublabel field with the name of the group that the wall belongs to"));
int bSetLabel = sArNY.find(sSetLabel,0);

PropString sWallType(27, sArNY, T("Append Wall Type to subLabel"),1);
sWallType.setDescription(T("Append the wall type after the group to the sublabel field of every beam"));
int bWallType = sArNY.find(sWallType,0);

PropString sFilterBeams(28, "X;", T("|Exclude Color on Beams with Code|"));
sFilterBeams.setDescription(T("|Separate multiple entries by|") +" ';'");

PropInt nColorDef (0, 7, T("Default Color"));
nColorDef.setDescription("");

int nBmType[0];
String sBmName[0];
int nColor[0];

PropString sbmName00(2, "LINTOL PACKERS", T("Jack Over Opening"));
PropString sbmName01(3, "SILL STUDS", T("Jack Under Opening"));
PropString sbmName02(4, "CRIPPLE", T("Cripple Stud"));
PropString sbmName03(5, "TRANSOM", T("Transom"));
PropString sbmName04(6, "STUD", T("King Stud"));
PropString sbmName05(7, "SILL", T("Sill"));
PropString sbmName06(8, "TOP PLATE", T("Angled TopPlate Left"));
PropString sbmName07(9, "TOP PLATE", T("Angled TopPlate Right"));
PropString sbmName08(10, "TOP PLATE", T("TopPlate"));
PropString sbmName09(11, "BOTTOM PLATE", T("Bottom Plate"));

PropString sbmName10(12, "BLOCKING", T("Blocking"));
PropString sbmName11(13, "CRIPPLE", T("Supporting Beam"));
PropString sbmName12(14, "STUD", T("Stud"));
PropString sbmName13(15, "STUD", T("Stud Left"));
PropString sbmName14(16, "STUD", T("Stud Right"));
PropString sbmName15(17, "LINTOL", T("Header"));
sbmName15.setDescription("Leave Empty to use name set in details");

PropString sbmName16(18, "BRACE", T("Brace"));
PropString sbmName17(19, "LOCATING PLATE", T("Locating Plate"));
PropString sbmName18(20, "PACKER", T("Packer"));
PropString sbmName19(21, "SOLEPLATE", T("SolePlate"));

PropString sbmName20(24, "VERY TOP PLATE", T("HeadBinder/Very Top Plate"));
PropString sbmName21(25, "VENT", T("Vent"));

PropString sMaterialToSet(29, "CLS", T("Material"));
PropString sGradeToSet(22, "C16", T("Grade"));

if(_bOnInsert)
{
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}

	if (_kExecuteKey=="")
		showDialogOnce();
}

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);


nBmType.append(_kSFJackOverOpening);			sBmName.append(sbmName00);				nColor.append(32);
nBmType.append(_kSFJackUnderOpening);			sBmName.append(sbmName01);				nColor.append(32);
nBmType.append(_kCrippleStud);					sBmName.append(sbmName02);				nColor.append(32);
nBmType.append(_kSFTransom);						sBmName.append(sbmName03);				nColor.append(32);
nBmType.append(_kKingStud);						sBmName.append(sbmName04);				nColor.append(32);
nBmType.append(_kSill);								sBmName.append(sbmName05);				nColor.append(32);
nBmType.append(_kSFAngledTPLeft);				sBmName.append(sbmName06);				nColor.append(32);
nBmType.append(_kSFAngledTPRight);				sBmName.append(sbmName07);				nColor.append(32);
nBmType.append(_kSFTopPlate);						sBmName.append(sbmName08);				nColor.append(32);
nBmType.append(_kSFBottomPlate);					sBmName.append(sbmName09);				nColor.append(32);

nBmType.append(_kSFBlocking);						sBmName.append(sbmName10);				nColor.append(32);
nBmType.append(_kSFSupportingBeam);			sBmName.append(sbmName11);				nColor.append(32);
nBmType.append(_kStud);							sBmName.append(sbmName12);				nColor.append(32);
nBmType.append(_kSFStudLeft);						sBmName.append(sbmName13);				nColor.append(32);
nBmType.append(_kSFStudRight);					sBmName.append(sbmName14);				nColor.append(32);
nBmType.append(_kHeader);							sBmName.append(sbmName15);				nColor.append(32);
nBmType.append(_kBrace);							sBmName.append(sbmName16);				nColor.append(32);
nBmType.append(_kLocatingPlate);					sBmName.append(sbmName17);				nColor.append(32);
nBmType.append(_kSFPacker);						sBmName.append(sbmName18);				nColor.append(32);
nBmType.append(_kSFSolePlate);					sBmName.append(sbmName19);				nColor.append(32);

//nBmType.append(_kTopPlate);						sBmName.append(sbmName20);				nColor.append(32);
nBmType.append(_kSFVeryTopPlate);				sBmName.append(sbmName20);				nColor.append(32);
nBmType.append(_kSFVent);							sBmName.append(sbmName21);				nColor.append(32);
nBmType.append(_kBlocking);						sBmName.append("DWANGS");				nColor.append(32);
nBmType.append(_kLog);								sBmName.append("BOX BLOCK");			nColor.append(6);
nBmType.append(_kDakCenterJoist);					sBmName.append("Connector");				nColor.append(32);
nBmType.append(_kDakFrontEdge);					sBmName.append("Batten");				      nColor.append(32);



String sBmID[0];
int nBmTypeByID[0];
sBmID.append("91");					nBmTypeByID.append(_kSFSupportingBeam);
sBmID.append("92");					nBmTypeByID.append(_kSFSupportingBeam);
//sBmID.append("93");				nBmTypeByID.append(_kSill);
sBmID.append("142");				nBmTypeByID.append(_kSFPacker);
sBmID.append("781");				nBmTypeByID.append(_kSFPacker);
sBmID.append("7102");				nBmTypeByID.append(_kSFTransom);
sBmID.append("102");				nBmTypeByID.append(_kSFTransom);
sBmID.append("7103");				nBmTypeByID.append(_kSFTransom);

String sbmCode[0];
int nBmTypeByCode[0];

sbmCode.append("V");				nBmTypeByCode.append(_kSFVeryTopPlate);
sbmCode.append("D");				nBmTypeByCode.append(_kBlocking); 
sbmCode.append("H");				nBmTypeByCode.append(_kHeader);	
sbmCode.append("S");				nBmTypeByCode.append(_kSFSolePlate);
sbmCode.append("CONNECTOR");	nBmTypeByCode.append(_kDakCenterJoist);
sbmCode.append("B");				nBmTypeByCode.append(_kDakFrontEdge);


String sBmCodeExclude[0];
//sBmCodeExclude.append("H");

if(_bOnInsert)
{
	//_Map.setInt("nExecutionMode", 1);
	//showDialogOnce();
	//if (insertCycleCount()>1) { eraseInstance(); return; }
	PrEntity ssE(T("Please select Elements"),ElementWall());
 	if (ssE.go())
	{
 		Element ents[0];
 		ents = ssE.elementSet();
 		for (int i = 0; i < ents.length(); i++ )
		 {
 			ElementWall el = (ElementWall) ents[i];
 			_Element.append(el);
 		 }
 	}
	return;
}

if (_Element.length()==0)
{
	eraseInstance();
	return;
}

setDependencyOnEntity(_Element[0]);

int nErase=TRUE;

// transform filter tsl property into array
String sBeamFilter[0];
String sList = sFilterBeams;
int bBmFilter;

while (sList.length()>0 || sList.find(";",0)>-1)
{
	String sToken = sList.token(0);	
	sToken.trimLeft();
	sToken.trimRight();		
	sToken.makeUpper();
	sBeamFilter.append(sToken);
	//double dToken = sToken.atof();
	//int nToken = sToken.atoi();
	int x = sList.find(";",0);
	sList.delete(0,x+1);
	sList.trimLeft();	
	if (x==-1)
		sList = "";	
}

for (int e=0; e<_Element.length(); e++)
{
	ElementWall el=(ElementWall) _Element[e];
	if (!el.bIsValid())
		continue;
	Beam bmAll[]=el.beam();
	_Pt0=el.ptOrg();
	
	if (bmAll.length()<1)	
	{
		nErase=FALSE;
		continue;
	}
	
	String sGrade="";
	String sMat="";
	
	String sElType=el.code();
	
	Group groupName=el.elementGroup();
	String sGroupName=groupName.namePart(0)+"\\";
	sGroupName+=groupName.namePart(1);
	
	for (int i=0; i<bmAll.length(); i++)
	{
		String sID=bmAll[i].hsbId();
		int nLocationID=sBmID.find(sID, -1);
		
		if (nLocationID!=-1)
		{
			bmAll[i].setType(nBmTypeByID[nLocationID]);
		}
		
		String sCode=bmAll[i].beamCode().token(0);
		int nLocationCode=sbmCode.find(sCode, -1);
		
		if (nLocationCode!=-1)
		{
			bmAll[i].setType(nBmTypeByCode[nLocationCode]);
		}
	}	
	
	for (int i=0; i<bmAll.length(); i++)
	{
		if (bmAll[i].type()==_kStud || bmAll[i].type()==_kSFStudLeft )//|| bmAll[i].type()==_kSFStudLeft || bmAll[i].type()==_kSFStudRight
		{
			if (sGrade=="")
				sGrade=bmAll[i].grade();
			if (sMat=="")
				sMat=bmAll[i].material();
			if (sMat != "" && sGrade!="")
			{
				break;
			}
		}
	}
	
	if (sGrade=="")
	{
		sGrade=sGradeToSet;
	}

	if (sMat=="")
	{
		sMat=sMaterialToSet;
	}

	for (int i=0; i<bmAll.length(); i++)
	{
		Beam bm=bmAll[i];
		int nBeamType=bm.type();
		
		String sThisMaterial=bm.material();
		sThisMaterial.trimLeft();
		sThisMaterial.trimRight();
		sThisMaterial.makeUpper();
		
		String sCode=bmAll[i].beamCode().token(0);
		//int nLocationCode=sbmCode.find(sCode, -1);
		
		int nExclude=sBmCodeExclude.find(sCode, -1);
		
		int nExcludeColor=sBeamFilter.find(sCode, -1);
		
		String sName;
		
		int nLocation=nBmType.find(nBeamType, -1);
		if (nLocation!=-1)
		{
			sName=bm.name();
			sName.makeUpper();
			sName.trimLeft();
			sName.trimRight();
			if (sName=="LOCATING PLATE")
			{
				bm.setType(_kLocatingPlate);
			}
			else
			{
				if (nExclude==-1)
				{
					//Set the beam Name
					sName=sBmName[nLocation];
					if (sName=="")
					{
						sName=bm.beamCode().token(11);
					}
					
					bm.setName(sName);
				}
			}
			if (bm.type()!=_kHeader)
			{
				if (sThisMaterial=="" || sThisMaterial=="PACKER")
					bm.setMaterial(sMat);
			}

			String sModuleName=bm.module();
			sModuleName.trimLeft();
			sModuleName.trimRight();
			if (sModuleName=="" || bModule)
			{
				if (nExcludeColor == -1)
				{
					if (bColor)
					{
						bm.setColor(nColorDef);
					}
					else
					{
						bm.setColor(nColor[nLocation]);
					}
				}
			}
		}
		else
		{
			
			sName=bm.beamCode().token(11);
			sName.makeUpper();
			//reportNotice("YES"+sName);
			//if (bm.beamCode().token(0))
			if (sName!="")
				bm.setName(sName);
			if (bm.type()!=_kHeader)
			{
				if (sThisMaterial=="")
					bm.setMaterial(sMat);
			}
			
			String sModuleName=bm.module();
			sModuleName.trimLeft();
			sModuleName.trimRight();
			if (sModuleName=="" || bModule)
			{
				if (nExcludeColor == -1)
				{
					if (bColor)
					{
						bm.setColor(nColorDef);
					}
				}
			}
		}
		
		//Set the Grade
		String sBmGrade=bm.grade();
		sBmGrade.trimLeft();
		sBmGrade.trimRight();
		if (sBmGrade=="")
			bm.setGrade(sGrade);
		
		//Set the information
		if (bSetInfo)
		{
			String sBmInfo=bm.information();
			sBmInfo.trimLeft();
			sBmInfo.trimRight();
			if (sBmInfo=="")
			{
				bm.setInformation(sName);
				//reportNotice("\n"+sName);
				//reportNotice("\n"+sName);
			}
		}
		
		if (bSetLabel)
		{
			bm.setSubLabel(sGroupName);
		}
		
		if (bWallType)
		{
			String sSubLabel=bm.subLabel();
			if (bSetLabel)
				bm.setSubLabel(sSubLabel+" "+sElType);
			else
				bm.setSubLabel(sElType);
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
	
	Sheet sh8[]=el.sheet(-3);
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

if (_bOnElementConstructed || nErase)
{
	eraseInstance();
	return;
}















#End
#BeginThumbnail
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
'+"BBB@#_V65/
`

#End
