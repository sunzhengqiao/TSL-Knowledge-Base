#Version 8
#BeginDescription
Displays the Position Number of Beams With the name "Headbinder" or "Soleplate"

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 15.09.2009  -  version 1.0

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
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
* date: 15.09.2009
* version 1.0: Release Version
*
*/

Unit (1, "mm");

PropDouble dXOffset (0, U(2), T("X Offset"));
PropDouble dYOffset (1, U(2), T("Y Offset"));

PropString sDispRep(0, "", T("Show in Disp Rep"));
PropString sDimStyle(1,_DimStyles,T("Dim Style"));

PropInt nColor(0, -1, T("Color"));

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

if (_bOnInsert)
{
	if (insertCycleCount()>1) { eraseInstance(); return; }
	if (_kExecuteKey=="")
		showDialogOnce();

	PrEntity ssE(T("\n|Select a set of beams|"),Beam());
	if (ssE.go())
	{ 
			_Beam.append(ssE.beamSet());
	}

	return;
}

Vector3d vx;
Vector3d vy;
Vector3d vz;

if (_Beam.length()<1)
{
	eraseInstance();
	return;
}

Display dp(nColor);
dp.dimStyle(sDimStyle);
if (sDispRep!="")
	dp.showInDispRep(sDispRep);

for (int i=0; i<_Beam.length(); i++)
{
	Beam bm=_Beam[i];
	String strName=bm.name();
	strName.trimLeft();
	strName.trimRight();
	strName.makeUpper();
	int nPOS=bm.posnum();
	if (nPOS==-1)
		continue;
	
	String sPOS=nPOS;
	double dHeight=dp.textHeightForStyle(sPOS, sDimStyle);
	double dLenght=dp.textLengthForStyle(sPOS, sDimStyle);
		
	if (strName=="SOLEPLATE")
	{

		double dSize=dHeight;
		if (dLenght>dHeight)
			dSize=dLenght;
		
		dSize=dSize*1.2;
		
		Point3d ptToDisplay=bm.ptCen()+bm.vecX()*dXOffset+bm.vecZ()*dYOffset;
		
		PLine plCircle(_ZW);
		plCircle.createCircle(ptToDisplay, _ZW, dSize*0.5);
		dp.draw(sPOS, ptToDisplay, _XW, _YW, 0, 0);
		dp.draw(plCircle);
	}
	
	if (strName=="HEADBINDER")
	{
		dLenght=dLenght*1.2;
		dHeight=dHeight*1.2;
		
		Point3d ptToDisplay=bm.ptCen()+bm.vecX()*dXOffset-bm.vecZ()*dYOffset;
		LineSeg ls(ptToDisplay-(_XW*dLenght*0.5)-(_YW*dHeight*0.5), ptToDisplay+(_XW*dLenght*0.5)+(_YW*dHeight*0.5));
		
		PLine plRectangle(_ZW);
		plRectangle.createRectangle(ls, _XW, _YW);
		dp.draw(sPOS, ptToDisplay, _XW, _YW, 0, 0);
		dp.draw(plRectangle);
	}
}













#End
#BeginThumbnail


#End
