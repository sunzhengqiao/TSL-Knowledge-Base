#Version 8
#BeginDescription
Remove the NO Nail code from the Beam Code Field

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 19.09.2013 - version 1.1





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
*  Copyright (C) 2009 by
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
* date: 19.09.2013
* version 1.0: Release Version
*
*/

_ThisInst.setSequenceNumber(-90);

Unit(1,"mm"); // script uses mm

//String sArNY[] = {T("No"), T("Yes")};

//PropString sExtraBeam (0, sArNY, T("Add extra blocking at apex"));

//PropDouble dBmLength (0, U(300), T("|Beam Length|"));
//PropString sName (0, "Blocking", T("|Beam Name|"));
//PropString sMaterial (1, "CLS", T("|Beam Material|"));
//PropString sGrade (2, "C16", T("|Beam Grade|"));


//int nBmType[0];
//String sBmName[0];

if(_bOnInsert)
{
	if( insertCycleCount()>1 )
	{
		eraseInstance();
		return;
	}

	//if (_kExecuteKey=="")
	//	showDialogOnce();

	PrEntity ssE(T("Select one or More Elements"), ElementWallSF());
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	return;
}

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

//int nExtraBeam=sArNY.find(sExtraBeam);

if (_Element.length()==0)
{
	eraseInstance();
	return;
}

int nErase=false;

for (int e=0; e<_Element.length(); e++)
{
	Element el=_Element[e];
	
	if (!el.bIsValid())
	{
		eraseInstance();
		return;
	}
	
	CoordSys csEl = el.coordSys();
	Vector3d vx = csEl.vecX();
	Vector3d vy = csEl.vecY();
	Vector3d vz = csEl.vecZ();
	_Pt0=csEl.ptOrg();
	
	Beam bmAll[]=el.beam();
	if (bmAll.length()==0)
		continue;
	
	Beam bmVertical[0];
	bmVertical=vx.filterBeamsPerpendicularSort(bmAll);
	
	for (int b = 0; b < bmVertical.length(); b++)
	{
		Beam bm=bmVertical[b];
		String sBeamCode=bm.beamCode();
		String sNewBeamCode;
		for (int i=0; i<13; i++)
		{
			String sToken;
			sToken=sBeamCode.token(i);
			sToken.trimLeft();
			sToken.trimRight();
			if (sToken!="")
			{
				if (i==8)
				{
					sNewBeamCode+="YES";
				}
				else
				{
					sNewBeamCode+=sToken;
				}
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
				if (i==8)
				{
					sNewBeamCode+="YES";
				}
				if (i==9)
				{
					String sValue=bm.grade();
					sValue.trimLeft();
					sValue.trimRight();
					sValue.makeUpper();
					sNewBeamCode+=sValue;
				}
				if (i==10)
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
