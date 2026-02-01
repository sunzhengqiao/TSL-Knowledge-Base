#Version 8
#BeginDescription
Shows Width Height and Thickness of SIP Panels in Layout

Last modified by: Alberto Jena (aj@hsb-cad.com)
20.07.2009  -  version 1.0





















#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
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
* date: 20.07.2009
* version 1.0: Release Version
*
*/

Unit(1,"mm"); // script uses mm

String sArNY[] = {T("No"), T("Yes")};

PropString sDimStyle(0,_DimStyles,T("Dimstyle"));
PropInt nColor (0,-1,T("Set Color"));
PropDouble dOffset(0, U(100), T("Offset Between Lines"));

String arYesNo[]={"No", "Yes"};
PropString strShowSipWidth(1, sArNY,"Show Sip Width", 1);
int bShowSipWidth = sArNY.find(strShowSipWidth, 0);

PropString strShowSipComponents(2, sArNY,"Show Sip Components", 0);
int bShowComponents = sArNY.find(strShowSipComponents, 0);

if(_bOnInsert)
{
	if (insertCycleCount()>1) { eraseInstance(); return; }
	if (_kExecuteKey=="")
		showDialogOnce();
	_Pt0=getPoint("Pick a Point");
	_Viewport.append(getViewport(T("Select a viewport")));
	
	return;
}//End On Insert

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

Viewport vp = _Viewport[0];

if (!vp.element().bIsValid()) return;

CoordSys ms2ps = vp.coordSys();

Element elm = vp.element();

ElementWall el= (ElementWall) elm;

if (!el.bIsValid())
{
	eraseInstance();
	return;
}

//Element Coordsys
CoordSys cs=el.coordSys();
Vector3d vx=cs.vecX();
Vector3d vy=cs.vecY();
Vector3d vz=cs.vecZ();
Point3d ptElOrg=cs.ptOrg();

Vector3d vXTxt = vx; vXTxt.transformBy(ms2ps);
Vector3d vYTxt = vy; vYTxt.transformBy(ms2ps);

String strMessage;

Sip spAll[]=el.sip();

String sName[0];
double dThick[0];

if (spAll.length()>0)
{
	SipStyle spStyle(spAll[0].style());
	SipComponent spCom[]=spStyle.sipComponents();
	for (int i=0; i<spCom.length(); i++)
	{
		sName.append(spCom[i].material());
		dThick.append(spCom[i].dThickness());
	}
	strMessage = "SIP "+spAll[0].dH();
}
else
{
	sName.setLength(0);
	dThick.setLength(0);
	strMessage="";
}




Display dp(nColor);
dp.dimStyle(sDimStyle);
if (bShowSipWidth)
{
	dp.draw (strMessage, _Pt0, _XW, _YW, 1, -1);
}

if (bShowComponents)
{
	for (int i=0; i<sName.length(); i++)
	{
		String sMes = sName[i] + " -  " + dThick[i];
		dp.draw (sMes , _Pt0-_YW*(dOffset*(i+1)), _XW, _YW, 1, -1);
	}
}





#End
#BeginThumbnail


#End
