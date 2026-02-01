#Version 8
#BeginDescription
Sets the timber name, material & grade based on beam types for stickframe walls, and copy the material of all the sheets to the name field.

#Versions
Version 1.48 23.02.2022 HSB-14792 bugfix empty / default material definitions
Version 1.49 21.10.2025 Add property for the name of Very Bottom Plate
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 49
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
* date: 27.05.2008
* version 1.0: Release Version
*
* date: 27.05.2008
* version 1.1: allow to set the color
*
* date: 17.09.2008
* version 1.2: allow to set the color
*
* date: 09.10.2008
* version 1.3: bugfix
*
* date: 17.10.2008
* version 1.4: Set the Grade an the Matarial of the Beams... except Header
*
* date: 29.06.2009
* version 1.5: Set the Grade of All the timbers... except Header
*
* date: 20.07.2009
* version 1.6: Always set the module names and dont set the color if it's not
*
* date: 01.09.2009
* version 1.7: Exclude the locating plate from the list and set it as typenotset
*
* date: 11.09.2009
* version 1.8: Set beams with id 91&92 to be supporting beam type
*
* date: 01.10.2009
* version 1.9: Add beam Type Locating Plate and BugFix when it's insert on model space and one of the walls it's not frame.
*
* date: 12.11.2009
* version 1.10: Packer type added and added the sequence number for automatic execution
*
* date: 11.03.2010
* version 1.11: Add Compatibility for superframe
*
* date: 18.05.2010
* version 1.13: Fix with Sequence and erase Instance
*
* date: 16.07.2010
* version 1.14: Set the Grade only to the beams that doesnt have it assign.
*
* date: 25.07.2010
* version 1.15: Set the Information only to the beams that doesnt have it assign.
*
* date: 27.07.2010
* version 1.16: Bugfix
*
* date: 05.08.2010
* version 1.18: Add beam Type Vent
*
* date: 13.09.2010
* version 1.19: Set Diferent Names base on Codes
*
* date: 19.10.2010
* version 1.20: Set the sublabel of the beam with the group of the element
*
* date: 08.11.2010
* version 1.21: Add Beam type _kSFVeryTopPlate to the beam with code V
*
* date: 15.11.2010
* version 1.22: Match the name properties with the name by code
*
* date: 16.11.2010
* version 1.23: Add the option to add the wall type to the sublabel fild of the beams
*
* date: 17.01.2011
* version 1.25: Add and array that allow us to exclude some beams by code
*
* date: 22.01.2011
* version 1.26: Add the option to exclude beams with code when setting the color
*
* date: 05.01.2011
* version 1.27: Bugfix When a beam have material but not grade or the other way around
*
* date: 06.06.2011
* version 1.29: Bugfix When a beam have material but not grade or the other way around
*
* date: 13.07.2011
* version 1.30: Add support for Soleplates define inside of the Panel with BeamCode S*
*
* date: 13.07.2011
* version 1.32: Fix issue with overwrite of header, now when the property is empty it wont overwrite
*
* date: 13.02.2012
* version 1.33: Add a property for material, so if it can not find it from the details it will set this one.
*
* date: 03.05.2012
* version 1.35: Add a beam id for the packer under the header that is not getting any beam type.
*
* date: 29.05.2012
* version 1.36: Remove id 93 from been set as a sill.
*
* date: 07.06.2013
* version 1.37: Add the map with all the beam names and types to the mapX of the element so it can be read from other TSLs.
*
* date: 23.01.2014
* version 1.38: Add analisys of the left and right studs so only the first one will have a beam type of left/right stud... any other beam in the module will be a stud
*
* date: 22.05.2014
* version 1.40: Undo change version 1.38
*
* date: 22.03.2015
* version 1.41: Beams with code "ST" will be set to be Studs types
*
* date: 26.01.2016
* version 1.44: Added property to allow a user to use  a custom name/material/grade from the details over this TSL
*/
// #Versions
// 1.48 23.02.2022 HSB-14792 bugfix empty / default material definitions , Author Thorsten Huck


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

PropString sUseDetailProperties(31, sArNY, T("|Use detail beam properties (if any)|"),0);
sUseDetailProperties.setDescription(T("Uses the properties of a beam defined in details if any"));
int nUseDetailProperties = sArNY.find(sUseDetailProperties,0);

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
PropString sbmName23(32, "VERY BOTTOM PLATE", T("Very Bottom Plate"));
PropString sbmName21(25, "VENT", T("Vent"));
PropString sbmName22(30, "ANGLE FILLET", T("Angle Fillet"));

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

nBmType.append(_kSFVeryTopPlate);				sBmName.append(sbmName20);				nColor.append(32);
nBmType.append(_kSFVeryBottomPlate);			sBmName.append(sbmName23);				nColor.append(32);
nBmType.append(_kSFVent);							sBmName.append(sbmName21);				nColor.append(32);
nBmType.append(_kTRWedge);						sBmName.append(sbmName22);				nColor.append(32);

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
sBmID.append("7101");				nBmTypeByID.append(_kSFTransom);

String sbmCode[0];
int nBmTypeByCode[0];

sbmCode.append("V");				nBmTypeByCode.append(_kSFVeryTopPlate);
sbmCode.append("D");				nBmTypeByCode.append(_kSFBlocking); 
sbmCode.append("H");				nBmTypeByCode.append(_kHeader);	
sbmCode.append("S");				nBmTypeByCode.append(_kSFSolePlate);
sbmCode.append("CONNECTOR");	nBmTypeByCode.append(_kDakCenterJoist);
sbmCode.append("B");				nBmTypeByCode.append(_kDakFrontEdge);
sbmCode.append("SL");				nBmTypeByCode.append(_kSill);
sbmCode.append("TR");				nBmTypeByCode.append(_kSFTransom);
sbmCode.append("KS");				nBmTypeByCode.append(_kKingStud);
sbmCode.append("ST");				nBmTypeByCode.append(_kStud);
sbmCode.append("VTP");			nBmTypeByCode.append(_kSFVeryTopPlate);
sbmCode.append("VBP");			nBmTypeByCode.append(_kSFVeryBottomPlate);

sbmCode.append("LPT");			nBmTypeByCode.append(_kLocatingPlate);
sbmCode.append("LPB");			nBmTypeByCode.append(_kLocatingPlate);
sbmCode.append("LP");				nBmTypeByCode.append(_kLocatingPlate);

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

int nErase=FALSE;

//Write the mapX with the information for the other TSL to find it.
Map mpProperties;
//mpProperties.setMapName("BEAMPROPERTIES");
for (int i=0; i<nBmType.length(); i++)
{
	Map mpType;
	mpType.setInt("TYPE", nBmType[i]);
	mpType.setString("NAME", sBmName[i]);
	mpProperties.appendMap("BEAMTYPE", mpType);
}
mpProperties.setString("BEAMMATERIAL", sMaterialToSet);
mpProperties.setString("BEAMGRADE", sGradeToSet);

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
		
	el.setSubMapX("BEAMPROPERTIES", mpProperties);
	
	Beam bmAll[]=el.beam();
	_Pt0=el.ptOrg();
	
	CoordSys cs=el.coordSys();
	Vector3d vx=cs.vecX();
	Vector3d vz=cs.vecZ();
	
	double dElBeamWidth=el.dBeamWidth();
	double dElBeamHeight=el.dBeamHeight();
	
	String sGrade="";
	String sMat="";
	
	String sElType=el.code();
	
	Group groupName=el.elementGroup();
	String sGroupName=groupName.namePart(0)+"\\";
	sGroupName+=groupName.namePart(1);

	Beam bmLeft[0];
	Beam bmRight[0];
	
	for (int i=0; i<bmAll.length(); i++)
	{
		Beam bm=bmAll[i];
		int nBeamType=bm.type();
		
		String sID=bm.hsbId();
		int nLocationID=sBmID.find(sID, -1);
		
		if (nLocationID!=-1)
		{
			bm.setType(nBmTypeByID[nLocationID]);
		}
		
		String sCode=bm.beamCode().token(0);
		int nLocationCode=sbmCode.find(sCode, -1);
		
		if (nLocationCode!=-1)
		{
			bm.setType(nBmTypeByCode[nLocationCode]);
		}
		
		if (nBeamType==_kSFStudLeft)
		{
			//bmLeft.append(bm);
		}
		
		if (nBeamType==_kSFStudRight)
		{
			//bmRight.append(bm);
		}
	}	
	
	//if there are multiple left or right studs only the first one will remain as left stud... everything else will be set to be stud
	Beam bmResultLeft[]=vx.filterBeamsPerpendicularSort(bmLeft);
	int nFirstLeft=true;
	for (int i=0; i<bmLeft.length(); i++)
	{
		if ( (abs(bmLeft[i].dD(vx)-dElBeamHeight) < U(0.01) && abs(bmLeft[i].dD(vz)-dElBeamWidth) < U(0.01) )&& nFirstLeft)
		{
			nFirstLeft=false;
			continue;
		}
		else
		{
			bmLeft[i].setType(_kStud);
		}
	}
	Beam bmResultRight[]=(-vx).filterBeamsPerpendicularSort(bmRight);
	int nFirstRight=true;
	for (int i=0; i<bmRight.length(); i++)
	{
		if ( ( abs(bmRight[i].dD(vx)-dElBeamHeight) < U(0.01) && abs(bmRight[i].dD(vz)-dElBeamWidth) < U(0.01) ) && nFirstRight)
		{
			nFirstRight=false;
			continue;
		}
		else
		{
			bmRight[i].setType(_kStud);
		}
	}
	
//region
// HSB-14792 make sure it uses default
	if (sGrade=="")
	{
		sGrade=sGradeToSet;
	}

	if (sMat=="")
	{
		sMat=sMaterialToSet;
	}
	
//	for (int i=0; i<bmAll.length(); i++)
//	{
//		if (bmAll[i].type()==_kStud || bmAll[i].type()==_kSFStudLeft )//|| bmAll[i].type()==_kSFStudLeft || bmAll[i].type()==_kSFStudRight
//		{
//			if (sGrade=="")
//				sGrade=bmAll[i].grade();
//			if (sMat=="")
//				sMat=bmAll[i].material();
//			if (sMat != "" && sGrade!="")
//			{
//				break;
//			}
//		}
//	}
//	if (sGrade=="")
//	{
//		sGrade=sGradeToSet;
//	}
//
//	if (sMat=="")
//	{
//		sMat=sMaterialToSet;
//	}		
//endregion 	
	

	
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
				if(!(nUseDetailProperties && sName!=""))
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

if (_bOnElementConstructed)
{
	eraseInstance();
	return;
}




















#End
#BeginThumbnail































































#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Add property for the name of Very Bottom Plate" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="49" />
      <str nm="DATE" vl="10/21/2025 3:39:18 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-14792 bugfix empty / default material definitions" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="48" />
      <str nm="DATE" vl="2/23/2022 10:51:05 AM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End