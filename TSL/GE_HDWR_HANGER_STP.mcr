#Version 8
#BeginDescription
v1.4: 02.jun.2014: David Rueda (dr@hsb-cad.com)
STP Family hanger (Simpson's LUS equivalent). Applies to end of selected beam(s) or as a independent floating part.
PLEASE NOTICE: this TSL has dependency on
- TSL_Read_Metalpart_Family_Props.dll to be located at @instalation folder\Utilities\TslCustomSettings
- TXT file containing STP families details (to be located at any folder, TSL will prompt for location if can't find it and store the path)
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2011 by
*  hsbSOFT 
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
* v1.4: 02.jun.2014: David Rueda (dr@hsb-cad.com)
*	- Added features to make possible reset TXT source file using GE_HDWR_RESET_CATALOG_ENTRY tsl
* v1.3: 07.jul.2013: David Rueda (dr@hsb-cad.com)
	- Description updated
* v1.2: 05.mar.2013: David Rueda (dr@hsb-cad.com)
	- Avoided printing map to DXX file
* v1.1: 08.nov.2012: David Rueda (dr@hsb-cad.com)
*	Bugix solved: dimensions were swaped on sides of hanger
* v1.0: 01.oct.2012: David Rueda (dr@hsb-cad.com)
*	Release
*
*/

String sFamilyName="STP";
PropString 	sType				(0, "", T("|Type|"), 0); sType.setReadOnly(true);
PropDouble 	dOverallDepth		(0, 0, T("|Overall depth|")); dOverallDepth.setReadOnly(true);
PropDouble 	dClearWidth		(1, 0, T("|Clear width|")); dClearWidth.setReadOnly(true);
PropDouble 	dOverallHeight	(2, 0, T("|Overall height|")); dOverallHeight.setReadOnly(true);
PropDouble 	dFlangeWidth		(3, 0, T("|Flange width|")); dFlangeWidth.setReadOnly(true);

String sChangeType= "Change type";
addRecalcTrigger(_kContext, sChangeType);

String sHelp= "Help";
addRecalcTrigger(_kContext, sHelp);
if(_kExecuteKey == sHelp)
{
	reportNotice(
	  "STP Family: inserts metal part. "
	+"\nCan be attached to one or several beams (one instance per beam) or as an independent, floating metalpart at initial insertion."
	+"\nWhen attached to a beam, has only one grip point, if moved it can recalculate according to new location to reposition on closer end of beam. "
	+"\nWhen drawn floating in DWG, it has 2 grip points, one to relocate it, and other to freely rotate it. "
	+"\nThe TSL can also change the type of the metal part using the 'Change type' custom definition");		
}

if(_bOnInsert  ||  _bOnRecalc || _kExecuteKey == sChangeType)
{
	
	if( insertCycleCount()>1 ){
		eraseInstance();
	}

	// Get family type 
	Map mapIn;// To be passed to dotNet
	String sCompanyPath = _kPathHsbCompany;
	String sHsbCompany_Tsl_Catalog_Path=sCompanyPath+"\\TSL\\Catalog\\";
	mapIn.setString("HSBCOMPANY_TSL_CATALOG_PATH", sHsbCompany_Tsl_Catalog_Path);
	mapIn.setString("FAMILYNAME", sFamilyName);
	reportMessage("\nCatalog: "+ sHsbCompany_Tsl_Catalog_Path+"TSL_HARDWARE_FAMILY_LIST.dxx\n");
	reportMessage("\nFamily Name: "+ sFamilyName);
		
	String sInstallationPath			= 	_kPathHsbInstall;
	String sAssemblyFolder			=	"\\Utilities\\TslCustomSettings";
	String sAssembly					=	"\\TSL_Read_Metalpart_Family_Props.dll ";
	String sAssemblyPath 			=	sInstallationPath+sAssemblyFolder+sAssembly;
	String sNameSpace				=	"TSL_Read_Metalpart_Family_Props";
	String sClass						=	"FamilyPropsReader";
	String sClassName				=	sNameSpace+"."+sClass;
	String sFunction					=	"fnReadFamilyPropsFromTXT";

	Map mapOut;
	if( _bOnRecalc)
		mapOut= _Map;
	else
		mapOut = callDotNetFunction2(sAssemblyPath, sClassName, sFunction, mapIn);
	
	mapOut.setString("HSBCOMPANY_TSL_CATALOG_PATH", sHsbCompany_Tsl_Catalog_Path);
	mapOut.setString("FAMILYNAME", sFamilyName);
	
	String sSelectedType= mapOut.getString("SELECTEDTYPE");
	if( _bOnInsert && mapOut.length()==0)
	{
		eraseInstance();
		return;	
	}
	
	if( (_kExecuteKey == sChangeType || _bOnRecalc ) && mapOut.length()>0)
	{
		_Map=mapOut;
	}

	if( _bOnInsert)
	{
		// Get beam or points 
		PrEntity ssE(T("|Select members or hit enter to insert at specific location|"),Beam());
		if( ssE.go())
		{
			_Beam.append(ssE.beamSet());
		}
	
		int nBeams=_Beam.length();
		int nInstances;
		Point3d ptRef;
		if(nBeams==0)
		{
			_Pt0=getPoint("\n"+T("|Select insertion point|"));
	
			PrPoint ssE("\n"+T("|Select reference point|")+": "+T("|direction of hanger|"),_Pt0);
			if (ssE.go()== _kOk)
			{
				ptRef= ssE.value();
			}
			nInstances=1;
		}
		else
		{
			_Pt0=getPoint("\n"+T("|Select reference point|")+": "+T("|hangers will be inserted at closest end of members|"));
			nInstances=nBeams;
		}
		
		for(int i=0; i<nInstances;i++)
		{
			TslInst tsl;
			String sScriptName = scriptName();
			Vector3d vecUcsX = _XW;
			Vector3d vecUcsY = _YW;
			Entity lstEnts[0];
			int lstPropInt[0];
			double lstPropDouble[0];
			String lstPropString[0];
	
			Point3d lstPoints[0];
				lstPoints.append(_Pt0);
			if(nBeams==0)
				lstPoints.append(ptRef);
	
			Beam lstBeams[0];
			if(nBeams>0)
				lstBeams.append(_Beam[i]);
	
			tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString, 1, mapOut);
		
		}
		eraseInstance();
		return;

	}

}

if( _Map.length()==0)
{
	eraseInstance();
	return;	
}

Map subMap= _Map;

String sKey= subMap.keyAt(0);
sType.set(sKey);
dClearWidth.set(subMap.getDouble(sKey+"\CLEAR WIDTH"));
dOverallDepth.set(subMap.getDouble(sKey+"\OVERALL DEPTH"));
dOverallHeight.set(subMap.getDouble(sKey+"\OVERALL HEIGHT"));
dFlangeWidth.set(1); // Fixed value

// Get insertion point, reference point when is the case and vectors
Vector3d vx, vy, vz;
// vx - depth
// vy - height
// vz - width

if(_Beam.length()==0 && _PtG.length() ==  1)// Floating
{	
	vx= _PtG[0]-_Pt0; vx.normalize();	
	vy=_ZW;
	vz=vx.crossProduct(vy);
	vy=vx.rotateBy(90,vz);
	if(vy.dotProduct(_ZW)<0)
		vy=-vy;
	_PtG[0]=_Pt0+vx*dOverallDepth;
}

else if(_Beam.length()==1 && _PtG.length() == 0 ) // At end of beam that is closest to ptRef along bm.vecX()
{
	Beam bm;
	bm= _Beam[0];
	if(!bm.bIsValid())
	{
		eraseInstance();
		return;
	}
	
	vx=bm.vecX();
	 if(vx.dotProduct(bm.ptCen()-_Pt0)<0)
		vx=-vx;
	vy=bm.vecD(_ZW);
	vz=vx.crossProduct(vy);
	_Pt0= bm.ptCen()- vx*bm.dL()*.5-vy*bm.dD(_ZW)*.5;
	if(bm.dD(vz)>dClearWidth)
	{
		reportMessage("\n"+T("|This type can't hold this size of beam|"));
		eraseInstance();
		return;
	}
}

else
{
	eraseInstance();
	return;
}
// Got all geometric parameters needed

// Draw metalpart

double dThickness= U(2.38125, 0.09375);
Display dp(-1);
Point3d pt;
double dX, dY, dZ;
dX=0;dY=0;dZ=0;
pt=_Pt0+vx*dOverallDepth*dX+vy*dOverallHeight*dY+vz*dClearWidth*dZ;
pt+=vx*dOverallDepth*dX+vy*dOverallHeight*dY+vz*dClearWidth*dZ;

// Base plate
PLine plBase;
dX=0;dY=0;dZ=0;
pt=_Pt0;
plBase.addVertex(pt);
dX=0;dY=0;dZ=0.5;
pt+=vx*dOverallDepth*dX+vy*dOverallHeight*dY+vz*dClearWidth*dZ;
plBase.addVertex(pt);
dX=1;dY=0;dZ=0;
pt+=vx*dOverallDepth*dX+vy*dOverallHeight*dY+vz*dClearWidth*dZ;
plBase.addVertex(pt);
dX=0;dY=0;dZ=-1;
pt+=vx*dOverallDepth*dX+vy*dOverallHeight*dY+vz*dClearWidth*dZ;
plBase.addVertex(pt);
dX=-1;dY=0;dZ=0;
pt+=vx*dOverallDepth*dX+vy*dOverallHeight*dY+vz*dClearWidth*dZ;
plBase.addVertex(pt);
plBase.close();
Body bdPlate(plBase, -vy*dThickness, 1);
dp.draw(bdPlate);

// vx - depth
// vy - height
// vz - width


// Left lateral
PLine plSide;
pt=_Pt0-vy*dThickness;
dX=0;dY=0;dZ=0.5;
pt+=vx*dOverallDepth*dX+vy*dOverallHeight*dY+vz*dClearWidth*dZ;
plSide.addVertex(pt);
dX=0;dY=1;dZ=0;
pt+=vx*dOverallDepth*dX+vy*dOverallHeight*dY+vz*dClearWidth*dZ;
plSide.addVertex(pt);
dX=0;dY=0;dZ=0;
pt+=vx*(dOverallDepth*dX+dThickness)+vy*dOverallHeight*dY+vz*dClearWidth*dZ;
plSide.addVertex(pt);
dX=1;dY=-1;dZ=0;
pt+=vx*(dOverallDepth*dX-dThickness)+vy*dOverallHeight*dY+vz*dClearWidth*dZ;
pt+=vy*dThickness;
plSide.addVertex(pt);
pt-=vy*dThickness;
plSide.addVertex(pt);
plSide.close();
Body bdSideL(plSide, vz*dThickness, 1);
dp.draw(bdSideL);

// Right lateral
Body bdSideR;
bdSideR= bdSideL;
bdSideR.transformBy(-vz*(dClearWidth+ dThickness));
dp.draw(bdSideR);

// Left frontal
PLine plFrL;
pt=_Pt0-vy*dThickness;
pt+=vz*(dClearWidth*.5+ dThickness);
plFrL.addVertex(pt);
pt+=vz*dFlangeWidth;
pt+=vy*dFlangeWidth*tan(45);
plFrL.addVertex(pt);
pt-=vy*dFlangeWidth*tan(45);
pt+=vy*dOverallHeight;
plFrL.addVertex(pt);
pt-=vz*(dFlangeWidth);
plFrL.addVertex(pt);
Body bdFrL(plFrL, vx*dThickness, 1);
dp.draw(bdFrL);

PLine plFrR;
pt=_Pt0-vy*dThickness;
pt-=vz*(dOverallDepth*.5+ dThickness);
plFrR.addVertex(pt);
pt+=-vz*dFlangeWidth;
pt+=vy*dFlangeWidth*tan(45);
plFrR.addVertex(pt);
pt-=vy*dFlangeWidth*tan(45);
pt+=vy*dOverallHeight;
plFrR.addVertex(pt);
pt+=vz*(dFlangeWidth);
plFrR.addVertex(pt);
Body bdFrR(plFrR, vx*dThickness, 1);
dp.draw(bdFrR);

if(_bOnDebug)
{
	_Pt0.vis();
	vx.vis(_Pt0);
	vy.vis(_Pt0);
	vz.vis(_Pt0);
}

#End
#BeginThumbnail
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
LH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`/_]DH
`



#End
