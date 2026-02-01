#Version 8
#BeginDescription
Displays the element subtype in model. 

Modified by: Chirag Sawjani (csawjani@itw-industry.com)
Date: 20.02.2013 - version 1.2


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
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
* date: 23.10.2008
* version 1.0: First version
*
* Updated by: Chirag Sawjani (csawjani@itw-industry.com)
* date: 20.02.2013
* Version 1.2: Bugfix, check on _Element length before executing code or else erase instance.
*/

Unit (1, "mm");

PropString sDimStyle(0,_DimStyles,T("Dimstyle"));
PropInt nColor (0,130,T("Color"));
PropDouble nOffset (0,U(250),T("Offset from Wall"));
PropDouble nOffsetX (1,U(150),T("Offset btw Lines"));
PropDouble dRotation (2,0,T("Set Rotation"));

PropString sDispRepHead(1,"",T("Disp Rep Header"));

if(_bOnInsert)
{
	if (insertCycleCount()>1) { eraseInstance(); return; }

	if (_kExecuteKey=="")
		showDialogOnce();

	PrEntity ssE(T("Please select Elements"),ElementWallSF());
 	if (ssE.go())
	{
 		Entity ents[0];
 		ents = ssE.set();
 		for (int i = 0; i < ents.length(); i++ )
		 {
 			ElementWallSF op1 = (ElementWallSF) ents[i];
 			_Element.append(op1);
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

	lstPropInt.append(nColor);
	lstPropDouble.append(nOffset);
	lstPropDouble.append(nOffsetX);
	lstPropDouble.append(dRotation);
		
	for (int e=0; e<_Element.length(); e++)
	{
		TslInst tslIns[]=_Element[e].tslInstAttached();
		for (int i=0; i<tslIns.length(); i++)
		{
			if (tslIns[i].scriptName()==scriptName() && tslIns[i].handle()!=_ThisInst.handle())
				tslIns[i].dbErase();
		}

		lstEnts.setLength(0);
		lstEnts.append(_Element[e]);
		tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,	lstPropInt, lstPropDouble,lstPropString);
	}

	eraseInstance();
	return;
}

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

	if(_Element.length()==0)
	{
		eraseInstance();
		return;
	}
	
	Element el = _Element[0];
	if (!el.bIsValid()) return;
	
	setDependencyOnEntity(el);

	Vector3d vX=el.vecX();
	Vector3d vZ=el.vecZ();
	
	Point3d ptDraw=el.ptOrg();
	
	CoordSys cs3;
	cs3.setToRotation(dRotation, _ZW, ptDraw);
	//setToRotation(dRotation, Vector3d vecAxis, Point3d ptCenter);
	
	
	Vector3d vecTextX=el.vecX();
	vecTextX.transformBy(cs3);
	Vector3d vecTextZ=vecTextX.crossProduct(el.vecY());
	vecTextZ.normalize();
	
	
	
	Display dp(nColor);
	dp.dimStyle(sDimStyle);
	
	String strDesc=el.subType();
	String strModel=strDesc.token(0, "(");
	
	String strOpInf=strDesc.token(1, "/");
	
	if (!_Map.hasInt("nSetOrg"))
	{
		_Pt0=ptDraw+vecTextZ*(nOffset);
		if (strOpInf!="")
			_Pt0=ptDraw+vecTextZ*(nOffsetX);
		
		_PtG.append(_Pt0+vecTextX*U(100));
	}
	
	_Map.setInt("nSetOrg", TRUE);
	
	vecTextX=_PtG[0]-_Pt0;
	vecTextX.normalize();
	ptDraw=_Pt0;
	
	if (strOpInf!="")
	{
		strModel=strDesc.token(0, "(");
		String strOpSize=strOpInf.token(0, "(");
		strModel=strModel+"/"+ strOpSize;
		String strLintolDesc=strOpInf.token(1, "(");
		strLintolDesc=strLintolDesc.token(0, ")");
		strModel=strModel+"<"+ strLintolDesc+">";
		
		//ptDraw=ptDraw+vecTextZ*nOffsetX;
		//_Pt0=ptDraw;
	}
	
	if (sDispRepHead!="")
		dp.showInDispRep(sDispRepHead);

	dp.draw(strModel, ptDraw, vecTextX, -vecTextZ, 1, 0, _kDevice);

	assignToElementGroup(el, FALSE, 0, 'I');









#End
#BeginThumbnail




#End
