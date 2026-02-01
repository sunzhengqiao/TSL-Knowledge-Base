#Version 8
#BeginDescription
On Layout show the total weight of a Sip Panel

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 15.01.2010  -  version 1.0


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
*  Copyright (C) 2010 by
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
* date: 15.01.2010
* version 1.0: Release version
*
*/

Unit (1, "mm");

PropString sNameMat1(0,"OSB",T("Name Material 1"));
PropDouble dWeightMat1 (0, 450, T("Weight Material 1(Kg/m3)"));

PropString sNameMat2(1,"Urethane",T("Name Material 2"));
PropDouble dWeightMat2 (1, 450, T("Weight Material 2(Kg/m3)"));

PropString sNameMat3(2,"",T("Name Material 3"));
PropDouble dWeightMat3 (2, 0, T("Weight Material 3(Kg/m3)"));

PropString sNameMat4(3,"",T("Name Material 4"));
PropDouble dWeightMat4 (3, 0, T("Weight Material 4(Kg/m3)"));

PropString sNameMat5(4,"",T("Name Material 5"));
PropDouble dWeightMat5 (4, 0, T("Weight Material 5(Kg/m3)"));

PropDouble dBmWeight (6, 450, T("Weight for Standard Beams (Kg/m3)"));

PropString sDimStyle(7,_DimStyles,T("Dimstyle"));
PropDouble dTextOffset (8, 0, T("Text Offset"));

PropInt nColor (0,1,T("Set Color"));

//String arYesNo[]={"No", "Yes"};
//PropString strTranslateId(3,arYesNo,"Weight All Beams");

if( _bOnInsert ){
	if (insertCycleCount()>1) { eraseInstance(); return; }
	showDialogOnce();
	_Pt0=getPoint("Pick a Point");
	_Viewport.append(getViewport(T("Select a viewport")));
	
	return;
}

if( _Viewport.length()==0 ){eraseInstance(); return;}

String sMaterials[0];
double dIndWeight[0];
if ( sNameMat1!="" && dWeightMat1>0 )
{
	sMaterials.append(sNameMat1.makeUpper());
	dIndWeight.append(dWeightMat1);
}
if ( sNameMat2!="" && dWeightMat2>0 )
{
	sMaterials.append(sNameMat2.makeUpper());
	dIndWeight.append(dWeightMat2);
}
if ( sNameMat3!="" && dWeightMat3>0 )
{
	sMaterials.append(sNameMat3.makeUpper());
	dIndWeight.append(dWeightMat3);
}
if ( sNameMat4!="" && dWeightMat4>0 )
{
	sMaterials.append(sNameMat4.makeUpper());
	dIndWeight.append(dWeightMat4);
}
if ( sNameMat5!="" && dWeightMat5>0 )
{
	sMaterials.append(sNameMat5.makeUpper());
	dIndWeight.append(dWeightMat5);
}

Viewport vp = _Viewport[0];

if (!vp.element().bIsValid()) return;

CoordSys ms2ps = vp.coordSys();

Element el = vp.element();


CoordSys csEl = el.coordSys();
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();
Point3d ptEl = csEl.ptOrg();
//ptEl.vis(2);

Vector3d vXTxt = vx; 
Vector3d vYTxt = vy; 
vXTxt.transformBy(ms2ps);
vYTxt.transformBy(ms2ps);

if (abs(vXTxt.dotProduct(_XW))<0.5)
{
	vXTxt=_XW;
	vYTxt=_YW;
}

Beam bmAll[]=el.beam();

Sip spAll[]=el.sip();

String sMaterial[0];
double dThick[0];

double dTotalWeight;
double dWeightBmStd;
//Loop for each sip

for (int i=0; i<spAll.length(); i++)
{
	PlaneProfile ppShapeSip(csEl);
	Sip sp=spAll[i];
	PLine plEnvelopCnc = sp.plEnvelopeCnc();
	ppShapeSip.joinRing(plEnvelopCnc, FALSE);
	PLine arOpenings[] = sp.plOpenings();
	for (int o=0; o<arOpenings.length(); o++)
	{
		PLine plOpening = arOpenings[o];
		ppShapeSip.joinRing(plEnvelopCnc, TRUE);
	}

	SipStyle spStyle(spAll[0].style());
	SipComponent spCom[]=spStyle.sipComponents();
	for (int i=0; i<spCom.length(); i++)
	{
		String sMaterial=spCom[i].material();
		sMaterial.makeUpper();
		double dThick =spCom[i].dThickness();
		
		int nLoc=sMaterials.find(sMaterial, -1);
		if (nLoc!=-1)
		{
			double dArea=ppShapeSip.area()/U(1)*U(1);
			double dVolume=dArea*dThick;
			dVolume=dVolume/1000000000;
			dTotalWeight+=dVolume*dIndWeight[nLoc];
		}
	}
	
}


for (int i=0; i<bmAll.length(); i++)
{
	/*String sProfile=bmAll[i].extrProfile();
	sProfile.makeUpper();
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
	*/
	double dBmVolume=bmAll[i].volume();
	dBmVolume=dBmVolume/1000000000;
	dWeightBmStd=dWeightBmStd+(dBmVolume * dBmWeight);
}

dTotalWeight+=dWeightBmStd;

String strWeightSip;
strWeightSip.formatUnit(dTotalWeight,2,2);
strWeightSip=strWeightSip+ " Kg";

Display dp(nColor);
dp.dimStyle(sDimStyle);

if (dTotalWeight!=0)
{
	//dp.draw ("Frame Weight: "+strWeightBm, _Pt0, vXTxt, vYTxt, 1, -1);
	dp.draw ("SIP Weight: "+strWeightSip, _Pt0-vYTxt*U(dTextOffset) , vXTxt, vYTxt, 1, -1);
}





#End
#BeginThumbnail
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
#`__9
`

#End
