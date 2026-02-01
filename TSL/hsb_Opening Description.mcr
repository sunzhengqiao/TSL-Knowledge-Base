#Version 8
#BeginDescription
Last modified by: 
Alberto Jena (aj@hsb-cad.com)
07.10.2008  -  version 1.0



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
* date: 07.10.2008
* version 1.0: First version
*
*/

Unit (1, "mm");

PropString sDimStyle(0,_DimStyles,T("Dimstyle"));
PropInt nColor (0,130,T("Color"));
PropDouble nOffset (0,U(250),T("Offset from Window"));
PropDouble nOffsetX (1,U(0),T("Lateral Offset"));
PropDouble dOffset (2,U(100),T("Distance Between Lines"));
PropDouble dRotation (3,0,T("Set Rotation"));

PropString sDimStyleHead(1,_DimStyles,T("Dimstyle Header"));
PropString sDispRepHead(2,"",T("Disp Rep Header"));

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
	//_Map.setInt("nExecutionMode",  0);
	return;
}

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

if (!_Map.hasInt("nExecutionMode"))
{
	if (_Element.length()== 0)
	{	
		eraseInstance();
		return;
	}
	
	for (int e=0; e<_Element.length(); e++)
	{
	TslInst tslIns[]=_Element[e].tslInstAttached();
	for (int i=0; i<tslIns.length(); i++)
	{
		if (tslIns[i].scriptName()==scriptName() && tslIns[i].handle()!=_ThisInst.handle())
			tslIns[i].dbErase();
	}
		Opening opAll[]=_Element[e].opening();
		//Clonning TSL 
		TslInst tsl;
		String sScriptName = scriptName(); // name of the script
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		Entity lstEnts[1];
		Beam lstBeams[0];
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
			
		lstPropString.append(sDimStyle);
		lstPropString.append(sDimStyleHead);
		lstPropString.append(sDispRepHead);
	
		lstPropInt.append(nColor);
		lstPropDouble.append(nOffset);
		lstPropDouble.append(nOffsetX);
		lstPropDouble.append(dOffset);
		lstPropDouble.append(dRotation);
	
		Map mpToClone;
		mpToClone.setInt("nExecutionMode", 0);
		for (int i=0; i<opAll.length(); i++)
		{
			lstEnts.setLength(0);
			lstEnts.append(opAll[i]);
			tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,	lstPropInt, lstPropDouble,lstPropString, TRUE, mpToClone);
		}

	}
	eraseInstance();
	return;
}

int nExecutionMode=0;
if (_Map.hasInt("nExecutionMode"))
	nExecutionMode=_Map.getInt("nExecutionMode");


for (int k=0; k<_Opening.length(); k++)
{
	Opening op= (Opening) _Opening[k];

	if (!op.bIsValid()) return;

	

	OpeningSF opSF= (OpeningSF) op;
	OpeningLog opLog= (OpeningLog) op;

	String strDesc;
	String strSize;
	String strHeaderInfo;

	if (!opSF.bIsValid())
	{
		if (!opLog.bIsValid())
		{
			continue;
		}
		else
		{
			strDesc=opLog.description();
		}
	}
	else
	{
		strDesc=opSF.descrSF();
		strDesc=strDesc+": ";
		strDesc+=opSF.headHeight();
		strSize=opSF.width() + "x" + opSF.height();
		strHeaderInfo=opSF.constrDetailTop();
	}

	Element el = op.element();
	if (!el.bIsValid()) continue;
	setDependencyOnEntity(el);
	
	if (nExecutionMode==0)
		_Element.append(el);

	ElemText elTexts[] = el.elemTexts();//Colect data from wall
	Vector3d vX=el.vecX();
	//_Pt0 = op.coordSys().ptOrg();
	
	Point3d ptLoc[0];
	String arStrText[0];
	for (int i = 0; i <elTexts.length(); i++)
	{
		Point3d textorig = elTexts[i].ptOrg();
	   
	  	String eltext = elTexts[i].text();
	    	String textCode = elTexts[i].code();
	    	String textSubCode = elTexts[i].subCode();
	
	    	String Text = eltext;//+textCode+textSubCode;
	   	
		if(textCode=="WINDOW" && textSubCode == "HEADER")
		{
			arStrText.append(Text);
			ptLoc.append(textorig);
		}
	}//next i

	double dMinDist=U(1000000);
	int nLoc=-1;
	for(int l =0; l < ptLoc.length(); l++)
	{
		if(abs(vX.dotProduct(op.coordSys().ptOrg()- ptLoc[l])) < dMinDist)
		{
			dMinDist=abs(vX.dotProduct(op.coordSys().ptOrg()- ptLoc[l]));
			nLoc=l;
		}//end if
	}//next l 
	if (nLoc!=-1)
	{
		strHeaderInfo=arStrText[nLoc];
	}//end if
	
	PLine plOut = op.plShape();
	Point3d ptExt[] = plOut.vertexPoints(TRUE);
	Point3d ptCenter;
	ptCenter.setToAverage(ptExt);
	
	Vector3d vZ=el.vecZ();
	Point3d ptDraw=ptCenter-_ZW*op.height()*0.5+vZ*U(nOffset)+vX*U(nOffsetX);
	
	if (!_Map.hasInt("nSetOrg"))
		_Pt0=ptDraw;
	
	_Map.setInt("nSetOrg", TRUE);
	CoordSys cs3;
	cs3.setToRotation(dRotation, _ZW, ptDraw);
	//setToRotation(dRotation, Vector3d vecAxis, Point3d ptCenter);
	
	
	Vector3d vecTextX=el.vecX();
	vecTextX.transformBy(cs3);
	Vector3d vecTextZ=vecTextX.crossProduct(el.vecY());
	vecTextZ.normalize();
	
	Display dp(nColor);
	dp.dimStyle(sDimStyle);
	
	Display dpHead(nColor);
	dpHead.dimStyle(sDimStyleHead);
	if (sDispRepHead!="")
		dpHead.showInDispRep(sDispRepHead);

	dp.draw( strDesc, _Pt0, vecTextX, -vecTextZ, 0, 0, _kDevice);
	dp.draw( strSize, _Pt0+vecTextZ*U(dOffset), vecTextX, -vecTextZ, 0, 0, _kDevice);
	dpHead.draw( strHeaderInfo, _Pt0+vecTextZ*U(dOffset*2), vecTextX, -vecTextZ, 0, 0, _kDevice);

	assignToElementGroup(el, FALSE, 0, 'Z');
}

_Map.setInt("nExecutionMode",  1);




#End
#BeginThumbnail








#End
