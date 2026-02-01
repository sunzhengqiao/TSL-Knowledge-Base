#Version 8
#BeginDescription
Tag Beams to Exclude/Include from CNC Operations by setting the Beam Code

Modified by: Mihai Bercuci(mihai.bercuci@hsbcad.com)
Date: 25.01.2018 - version 1.11
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
*
* Create by: Alberto Jena (aj@hsb-cad.com)
* date: 16.06.2011
* version 1.0: Release Version
*
*/

Unit(1,"mm"); // script uses mm

String sExclusionTypes[] = {T("Code"), T("Tag"), T("Both")};

String sOperations[] = {T("Exclude"), T("Include")};

PropString sOperationCNC(0, sOperations, T("CNC Operation"));
sOperationCNC.setCategory(T("Beam CNC Operation"));

PropString sExclusionType(3, sExclusionTypes, T("Exclusion Type"));
sExclusionType.setCategory(T("Beam CNC Operation"));

String sYesNo[]={T("No"), T("Yes")};

PropString sNailing(1, sYesNo, T("Allow Nailing"));
sNailing.setCategory(T("Beam CNC Operation"));

PropString sGluing(4, sYesNo, T("Allow Gluing"));
sGluing.setCategory(T("Beam CNC Operation"));

PropString sInformation(5, "", T("Information"));

PropString sOperationMEP(2, sOperations, T("MEP Operation"));
sOperationMEP.setCategory(T("Tag beams for MEP"));

PropInt nColor(0, 1, T("Color"));

// Load the values from the catalog
if (_bOnDbCreated || _bOnInsert) setPropValuesFromCatalog(_kExecuteKey);

int nOperationCNC = sOperations.find(sOperationCNC, 0);
int nExclusionType = sExclusionTypes.find(sExclusionType, 0);

int nNailing = sYesNo.find(sNailing, 0);
int nGluing = sYesNo.find(sGluing, 0);

int nOperationMEP = sOperations.find(sOperationMEP, 0);

if (_bOnInsert) {
	//Getting walls	
	if (insertCycleCount()>1) { eraseInstance(); return; }
	if (_kExecuteKey=="")
		showDialogOnce();

	PrEntity ssE(T("Please select beams/sheets"),Beam());
	ssE.addAllowedClass(Sheet());
 	if (ssE.go())
	{
 		Entity ents[0];
 		ents = ssE.set();
 		for (int i = 0; i < ents.length(); i++ )
		 {
 			GenBeam el = (GenBeam) ents[i];
 			_GenBeam.append(el);
 		 }
 	}

	if(_GenBeam.length()==0){
		eraseInstance();
		return;
	}
	
	return;
}	

if (_GenBeam.length() == 0)
{
	reportMessage(T("No selected beams. TSL will be deleted"));
	eraseInstance(); 
	return; 
}

_Pt0=_GenBeam[0].ptCen();

for (int i=0; i<_GenBeam.length(); i++)
{
	GenBeam bm=_GenBeam[i];
	String sBeamCode=bm.beamCode();
	String sToken=sBeamCode.token(0);
	String sMid=sBeamCode.mid(sToken.length(), (sBeamCode.length()-sToken.length()));

	if (nExclusionType==0 || nExclusionType==2) //Code or Both
	{
		if (nOperationCNC==0)
		{
			String sNew ="EXC"+sMid;
			bm.setBeamCode(sNew);
		}
		else
		{
			String sNew =""+sMid;
			bm.setBeamCode(sNew);
		}
	}
	if (nExclusionType==1 || nExclusionType==2) //Tag
	{
		if (nOperationCNC==0)
		{
			String sAllKeys=bm.subMapXKeys();
			if (sAllKeys.find("Hsb_Tag", -1) != -1)
			{
				//Already have some tags
				Map mpTags = bm.subMapX("Hsb_Tag");
				int nFound=false;
				for (int i=0; i<mpTags.length(); i++)
				{
					if (mpTags.getString(i)=="NoMount")
					{
						nFound=true;
					}
				}
				
				if (!nFound)
				{
					mpTags.appendString("Tag", "NoMount");
				}
				
				bm.setSubMapX("Hsb_Tag", mpTags);
			}
			else //doesnt have tags before
			{
				Map mpTags;
				mpTags.setString("Tag", "NoMount");
				bm.setSubMapX("Hsb_Tag", mpTags);
			}
		}
		else
		{
			Map mpTags = bm.subMapX("Hsb_Tag");
		
			for (int i=0; i<mpTags.length(); i++)
			{
				if (mpTags.keyAt(i)=="TAG")
				{
					String sThisKey=mpTags.getString(i);
					
					if (sThisKey == "NoMount")
					{
						int status=mpTags.removeAt(i, true);
				
						bm.removeSubMapX("Hsb_Tag");
						
						if (mpTags.length()>0)
						{
							bm.setSubMapX("Hsb_Tag", mpTags);
						}
						
						break;
					}
				}
			}
		}
	}
	
	if (nOperationMEP==0)
	{
		String sAllKeys=bm.subMapXKeys();
		if (sAllKeys.find("Hsb_Tag", -1) != -1)
		{
			//Already have some tags
			Map mpTags = bm.subMapX("Hsb_Tag");
			int nFound=false;
			for (int i=0; i<mpTags.length(); i++)
			{
				if (mpTags.getString(i)=="MEPExclude")
				{
					nFound=true;
				}
			}
			
			if (!nFound)
			{
				mpTags.appendString("Tag", "MEPExclude");
			}
			
			bm.setSubMapX("Hsb_Tag", mpTags);

		}
		else //doesnt have tags before
		{
			Map mpTags;
			mpTags.setString("Tag", "MEPExclude");
			bm.setSubMapX("Hsb_Tag", mpTags);
		}

	}
	if (nOperationMEP==1)
	{
		Map mpTags = bm.subMapX("Hsb_Tag");
		
		for (int i=0; i<mpTags.length(); i++)
		{
			if (mpTags.keyAt(i)=="TAG")
			{
				String sThisKey=mpTags.getString(i);
				
				if (sThisKey == "MEPExclude")
				{
					int status=mpTags.removeAt(i, true);
			
					bm.removeSubMapX("Hsb_Tag");
					
					if (mpTags.length()>0)
					{
						bm.setSubMapX("Hsb_Tag", mpTags);
					}
					
					break;
				}
			}
		}
	}
	
	if (nGluing==0)
	{
		String sAllKeys=bm.subMapXKeys();
		if (sAllKeys.find("Hsb_Tag", -1) != -1)
		{
			//Already have some tags
			Map mpTags = bm.subMapX("Hsb_Tag");
			int nFound=false;
			for (int i=0; i<mpTags.length(); i++)
			{
				if (mpTags.getString(i)=="NoGluing")
				{
					nFound=true;
				}
			}
			
			if (!nFound)
			{
				mpTags.appendString("Tag", "NoGluing");
			}
			
			bm.setSubMapX("Hsb_Tag", mpTags);

		}
		else //doesnt have tags before
		{
			Map mpTags;
			mpTags.setString("Tag", "NoGluing");
			bm.setSubMapX("Hsb_Tag", mpTags);
		}

	}
	
	if (nGluing==1)
	{
		Map mpTags = bm.subMapX("Hsb_Tag");
		
		for (int i=0; i<mpTags.length(); i++)
		{
			if (mpTags.keyAt(i)=="TAG")
			{
				String sThisKey=mpTags.getString(i);
				
				if (sThisKey == "NoGluing")
				{
					int status=mpTags.removeAt(i, true);
			
					bm.removeSubMapX("Hsb_Tag");
					
					if (mpTags.length()>0)
					{
						bm.setSubMapX("Hsb_Tag", mpTags);
					}
					
					break;
				}
			}
		}
	}
	
	bm.setColor(nColor);
	bm.setInformation(sInformation);
	
	//A;CLS;;;;NO;;;;C16;;K-TRÆ;;
	
	sBeamCode=bm.beamCode();
	String sNewBeamCode;
	for (int i=0; i<13; i++)
	{
		String sToken;
		sToken=sBeamCode.token(i);
		sToken.trimLeft();
		sToken.trimRight();
		if (sToken!="" && (i!=5 && i!=8))
		{
			sNewBeamCode+=sToken;
		}
		else
		{
			if (i==1)
			{
				String sValue=bm.material();
				sValue.trimLeft();
				sValue.trimRight();
				sValue.makeUpper();
				sNewBeamCode+=sValue;
			}
			if (i==5) // Use on Table
			{
				String sValue="YES";
				if (nOperationCNC==0 && nExclusionType!=1)
					sValue="NO";
				sValue.trimLeft();
				sValue.trimRight();
				sValue.makeUpper();
				sNewBeamCode+=sValue;
			}
			if (i==8) // Allow Nailing
			{
				String sValue="YES";
				if (nNailing==0)
					sValue="NO";
					
				sValue.trimLeft();
				sValue.trimRight();
				sValue.makeUpper();
				sNewBeamCode+=sValue;
			}
			if (i==9) // Grade
			{
				String sValue=bm.grade();
				sValue.trimLeft();
				sValue.trimRight();
				sValue.makeUpper();
				sNewBeamCode+=sValue;
			}
			if (i==10) //Information
			{
				String sValue=bm.information();
				sValue.trimLeft();
				sValue.trimRight();
				sValue.makeUpper();
				sNewBeamCode+=sValue;
			}
			if (i==11)
			{
				String sValue=bm.name();
				sValue.trimLeft();
				sValue.trimRight();
				sValue.makeUpper();
				sNewBeamCode+=sValue;
			}
		}
		sNewBeamCode+=";";
	}
	bm.setBeamCode(sNewBeamCode);
}

eraseInstance();
return;
#End
#BeginThumbnail








#End