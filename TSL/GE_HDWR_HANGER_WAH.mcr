#Version 8
#BeginDescription
v1.4: 02.jun.2014: David Rueda (dr@hsb-cad.com)
WAH Family hanger (Simspon's HTTP equivalent). Applies to end of selected stud(s)
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
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
* v1.3: 05.nov.2013: David Rueda (dr@hsb-cad.com)
*	- Version control
* v1.2: 05.nov.2013: David Rueda (dr@hsb-cad.com)
*	- Removed floating feature, applied only when beams selected. Relocation upon _Pt0 to beam side/end
* v1.1: 29.nov.2012: David Rueda (dr@hsb-cad.com)
*	- Added reading for anchors from construction directive
*	- Drawing vectors taken from instance coordsys 
* v1.0: 08.nov.2012: David Rueda (dr@hsb-cad.com)
*	Release
*
*/
String sFamilyName="WAH";

PropString 	sType				(0, "WAH16", T("|Type|"), 0); sType.setReadOnly(true);
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
pt=_Pt0+vx*dClearWidth*dX+vy*dOverallHeight*dY+vz*dOverallDepth*dZ;
pt+=vx*dClearWidth*dX+vy*dOverallHeight*dY+vz*dOverallDepth*dZ;

// Base plate
PLine plBase;
pt=_Pt0;
pt+=vz*dClearWidth*.5;
plBase.addVertex(pt);
pt+=vx*dOverallDepth;
plBase.addVertex(pt);
pt-=vz*dClearWidth;
plBase.addVertex(pt);
pt-=vx*dOverallDepth;
plBase.addVertex(pt);
plBase.close();
Body bdPlate(plBase, -vy*dThickness, 1);
dp.draw(bdPlate);

// Left lateral
PLine plSide;
pt=_Pt0-vy*dThickness-vx*dThickness;
pt+=vz*dClearWidth*.5;
plSide.addVertex(pt);
pt+=vy*(dOverallHeight+dThickness);
plSide.addVertex(pt);
dX=0;dY=0;dZ=0;
pt+=vx*(dOverallDepth*dX+dThickness*2);
plSide.addVertex(pt);
dX=1;dY=-1;dZ=0;
pt+=vx*(dSideTriangleLength*dX-dThickness)+vy*dOverallHeight*dY+vz*dClearWidth*dZ;pt.vis(1);
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

// Drilled plate
PLine plDrilled;
pt=_Pt0;
pt+=vz*dClearWidth*.5;
plDrilled.addVertex(pt);
pt+=vy*dOverallHeight;
plDrilled.addVertex(pt);
pt-=vz*dClearWidth;
plDrilled.addVertex(pt);
pt-=vy*dOverallHeight;
plDrilled.addVertex(pt);
plDrilled.close();
Body bdDrilled(plDrilled, -vx*dThickness, 1);

// Drilling plate
Point3d ptDrillStart=_Pt0+vx*U(50,2)+vy*dOverallHeight*.5;
Point3d ptDrillEnd=_Pt0-vx*U(50,2)+vy*dOverallHeight*.5;
Body dbDrill(ptDrillStart, ptDrillEnd, U(10,.4));
bdDrilled-=dbDrill;
dp.draw(bdDrilled);

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
L@84444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`?_]FB
`



#End
