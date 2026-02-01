#Version 8
#BeginDescription
v1.2: 11.jun.2014: David Rueda (dr@hsb-cad.com)
ADG Anchor Down Family (Simspon's HDU/HHDQ equivalent). Applies to end of selected stud(s)

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 2
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
* v1.2: 11.jun.2014: David Rueda (dr@hsb-cad.com)
*	- Corrected drawing shape
*	- Thumbnail added
* v1.1: 02.jun.2014: David Rueda (dr@hsb-cad.com)
*	- Added features to make possible reset TXT source file using GE_HDWR_RESET_CATALOG_ENTRY tsl
* v1.0: 08.nov.2012: David Rueda (dr@hsb-cad.com)
*	- Release
*	- Renamed from GE_HDWR_HANGER_WAH to GE_HDWR_WALL_ANCHOR_WAH
*/

String sFamilyName="ADG";
PropString 	sType				(0, "ADG", T("|Type|"), 0); sType.setReadOnly(true);
PropDouble 	dClearWidth		(0, U(70,2.625), T("|Clear width|")); dClearWidth.setReadOnly(true);
PropDouble 	dOverallDepth		(1, U(560,22), T("|Overall depth|")); dOverallDepth.setReadOnly(true);
PropDouble 	dOverallHeight	(2, U(50,2), T("|Overall height|")); dOverallHeight.setReadOnly(true);
double dSideTriangleLength=U(215, 8.5);

String sChangeType= "Change type";
addRecalcTrigger(_kContext, sChangeType);

String sHelp= "Help";
addRecalcTrigger(_kContext, sHelp);
if(_kExecuteKey == sHelp)
{
	reportNotice(
	  "HTT Family: inserts metal part. "
	+"\nCan be attached to one or several studs"
	+"\nwhen grip point moved it can recalculate according to new location to reposition on closer end and face of beam. "
	+"\nCan also change the type of the metal part using the 'Change type' custom definition");		
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
		PrEntity ssE(T("|Select stud(s)|"),Beam());
		if( ssE.go())
		{
			_Beam.append(ssE.beamSet());
		}
	
		if(_Beam.length()==0)
		{
			eraseInstance();
			return;
		}
		
		String sType=sSelectedType;
		double dClearWidth=1.5625;
		double dOverallDepth=1.75;
		double dOverallHeight=3;
		double dFlangeWidth=1;

		_Pt0=getPoint("\n"+T("|Select reference point|")+": "+T("|hangers will be inserted at closest end and closer face of members|"));

		// Define closer beam to point to define all beams direction for reference point
		Beam bmCloserToRef, bmVerticals[0];
		double dCloserDistance=U(25000, 1000);
		for(int b=0; b< _Beam.length(); b++)
		{
			Beam bm= _Beam[b];
			if( _ZW.isParallelTo(bm.vecX()) ) // Get allverticals and define bmCloserToRef
			{
				bmVerticals.append(bm);
				Point3d pt1=bm.ptCen();
				pt1.setZ(_Pt0.Z());
				if( (_Pt0-pt1).length()<dCloserDistance)
				{
					dCloserDistance=(_Pt0-pt1).length();
					bmCloserToRef= bm;
				}
			}
		}

		Vector3d vRef=bmCloserToRef.vecD(_Pt0-bmCloserToRef.ptCen());

		TslInst tsl;
		String sScriptName = scriptName();
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		Entity lstEnts[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];	
		Point3d lstPoints[1];
		Beam lstBeams[1];

		for(int b=0; b<bmVerticals.length();b++)
		{
			Beam bm= bmVerticals[b];
			if( bm.element().bIsValid())
			{
				lstEnts.setLength(1);
				lstEnts[0]=bm.element();
			}
			else
				lstEnts.setLength(0);
							
			lstBeams[0]=bmVerticals[b];	
			
			Vector3d vDir=bm.vecD(vRef);
			if(vDir.dotProduct(vRef)<0)
				vDir=-vDir;
			Point3d pt1=bm.ptCen()+vDir*bm.dD(vDir)*.5;
			lstPoints[0]=pt1;
			tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString, 1, mapOut);		
		}
		eraseInstance();
		return;
	}
} // End _bOnInsert

if( _Beam.length()==0)
{
	eraseInstance();
	return;
}
Beam bm= _Beam[0];
if(!bm.bIsValid())
{
	eraseInstance();
	return;
}

if(_Map.hasString("TYPE"))
	sType.set(_Map.getString("TYPE"));
if(_Map.hasDouble("CLEAR WIDTH"))
	dClearWidth.set(_Map.getDouble("CLEAR WIDTH"));
if(_Map.hasDouble("OVERALL DEPTH"))
	dOverallDepth.set(_Map.getDouble("OVERALL DEPTH"));
if(_Map.hasDouble("OVERALL HEIGHT"))
	dOverallHeight.set(_Map.getDouble("OVERALL HEIGHT"));

//Relocate _Pt0 after inserted
Point3d ptCen=bm.ptCen();
Vector3d vx, vy, vz;
vx=bm.vecX();
if(vx.dotProduct(ptCen-_Pt0)<0)
	vx=-vx;
vy=bm.vecD(_Pt0-ptCen);
vz=vx.crossProduct(vy);
_Pt0= bm.ptCen()- vx*bm.dL()*.5+vy*bm.dD(vy)*.5;

if( _Element.length()==1)
{
	Element el= _Element[0];
	setDependencyOnEntity(el);
	if( _bOnElementDeleted)
		eraseInstance();
}

// Draw metalpart
double dThickness= U(2.38125, 0.09375);
Display dp(-1);
Point3d pt;
double dX, dY, dZ;
dX=0;dY=0;dZ=0;

// Drill
Point3d ptDrillStart=_Pt0+vx*U(50,2)+vy*dOverallHeight*.5;
Point3d ptDrillEnd=_Pt0-vx*U(50,2)+vy*dOverallHeight*.5;
Body bdDrill(ptDrillStart, ptDrillEnd, U(10,.4));

// Drilled bottom base
double dEmptySpace=dThickness*.1;
double dE=dEmptySpace;
PLine plDrilledBottomBase;
pt=_Pt0+vy*dThickness;
pt+=vz*dClearWidth*.5;
plDrilledBottomBase.addVertex(pt);
pt+=vy*dOverallHeight;
plDrilledBottomBase.addVertex(pt);
pt-=vz*dClearWidth;
plDrilledBottomBase.addVertex(pt);
pt-=vy*dOverallHeight;
plDrilledBottomBase.addVertex(pt);
plDrilledBottomBase.close();
Body bdDrilledBottomBase(plDrilledBottomBase, vx*dThickness, 1);
bdDrilledBottomBase-=bdDrill;
dp.draw(bdDrilledBottomBase);

// Drilled top base
Body bdDrilledTopBase=bdDrilledBottomBase;
bdDrilledTopBase.transformBy(vx*(dE+dThickness)*2);
dp.draw(bdDrilledTopBase);

// Intermediate base
PLine plDrilledIntermediateBase;
pt=_Pt0+vz*dClearWidth*.5+vx*(dThickness+dE) ;
plDrilledIntermediateBase.addVertex(pt);
pt+=vy*(dOverallHeight+dThickness-dE);
plDrilledIntermediateBase.addVertex(pt);
pt-=vz*dClearWidth;
plDrilledIntermediateBase.addVertex(pt);
pt-=vy*(dOverallHeight+dThickness-dE);
plDrilledIntermediateBase.addVertex(pt);
plDrilledIntermediateBase.close();
Body bdDrilledIntermediateBase(plDrilledIntermediateBase,vx*dThickness,1);
bdDrilledIntermediateBase-=bdDrill;
dp.draw(bdDrilledIntermediateBase);

// Cage closer
PLine plBaseCloser;
pt=_Pt0+vz*dClearWidth*.5+vy*(dOverallHeight+dThickness);
plBaseCloser.addVertex(pt);
pt+=-vz*dClearWidth;
plBaseCloser.addVertex(pt);
pt+=vx*(dThickness*3+dE*2);
plBaseCloser.addVertex(pt);
pt+=vz*dClearWidth;
plBaseCloser.addVertex(pt);
plBaseCloser.close();
Body bdBaseCloser(plBaseCloser,vy*dThickness,1);
dp.draw(bdBaseCloser);

// Plate against stud - back
double dLength=dOverallDepth-dThickness*2-dE;
PLine plPlateAgainst;
pt=_Pt0+vx*(dThickness*2+dE);
pt+=vz*dClearWidth*.5;
plPlateAgainst.addVertex(pt);
pt+=vx*dLength;
plPlateAgainst.addVertex(pt);
pt-=vz*dClearWidth;
plPlateAgainst.addVertex(pt);
pt-=vx*dLength;
plPlateAgainst.addVertex(pt);
plPlateAgainst.close();
Body bdPlateAgainst(plPlateAgainst, vy*dThickness, 1);
dp.draw(bdPlateAgainst);

// Plate against stud - lateral left
dLength+=dThickness;
PLine plPlateSideLeft;
pt=_Pt0-vz*dClearWidth*.5+vx*(dThickness+dE);
plPlateSideLeft.addVertex(pt);
pt+=vx*dLength;
plPlateSideLeft.addVertex(pt);
pt+=vy*(dThickness*2+dOverallHeight);
plPlateSideLeft.addVertex(pt);
pt+=-vx*dLength;
plPlateSideLeft.addVertex(pt);
plPlateSideLeft.close();
Body bdPlateSideLeft(plPlateSideLeft, vz*dThickness, -1);
dp.draw(bdPlateSideLeft);

// Plate against stud - lateral right
Body bdPlateSideRight;
bdPlateSideRight= bdPlateSideLeft;
bdPlateSideRight.transformBy(vz*(dClearWidth+ dThickness));
dp.draw(bdPlateSideRight);

// Add anchor
if(!_Map.getInt("InsertedAnchor"))
{
	String sAnchorModel=_Map.getString("ANCHORMODEL");
	String sAnchorType=_Map.getString("ANCHORTYPE");
	String sScriptName;
	
	if(sAnchorModel=="J-Bolt")
		sScriptName="GE_HDWR_ANCHOR_J-BOLT";
	if(sAnchorModel=="Adhesive Anchor")
		sScriptName="GE_HDWR_ANCHOR_ADHESIVE";
	if(sAnchorModel=="Screw Anchor")
		sScriptName="GE_HDWR_ANCHOR_SCREW";
	if(sAnchorModel=="Embedded Anchor")
		sScriptName="GE_HDWR_ANCHOR_EMBEDDED";


	if(sScriptName!="")
	{
		Map map;
		map.setVector3d("vx",-vx);
		map.setVector3d("vy",vy);
		map.setVector3d("vz",-vx.crossProduct(vy));
		map.setString("Type", sAnchorType);
		map.setInt("InsertedByDirective",1);
		map.setInt("HideWasherAndNuts",1);		
		map.setString("ANCHORTYPE",sAnchorType);
		
		TslInst tsl;
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		Beam lstBeams[0];
		Entity lstEnts[0];
		if(_Element.length()==1)
			lstEnts.append(_Element[0]);
	
		Point3d lstPoints[0];lstPoints.append(_Pt0+vx*U(50,2)+vy*dOverallHeight*.5);
		
		int lstPropInt[0];
	
		double lstPropDouble[0];
		String lstPropString[0];lstPropString.append(sAnchorType);
		tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString,1,map ); 
		
		//_Map.setInt("InsertedAnchor",1);
	}
}

if(_bOnDebug)
{
	_Pt0.vis();
	vx.vis(_Pt0,1);
	vy.vis(_Pt0,2);
	vz.vis(_Pt0,3);
}

#End
#BeginThumbnail
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
#`__9
`

#End
