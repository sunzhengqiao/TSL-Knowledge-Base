#Version 8
#BeginDescription
v1.3: 10.jun.2014: David Rueda (dr@hsb-cad.com)
WA Family hanger (Simspon's LTT equivalent). Applies to end of selected stud(s)

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 3
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
* v1.3: 10.jun.2014: David Rueda (dr@hsb-cad.com)
*	- Bug fix: Metalpart was overlapping with beam
* v1.2: 02.jun.2014: David Rueda (dr@hsb-cad.com)
*	- Added features to make possible reset TXT source file using GE_HDWR_RESET_CATALOG_ENTRY tsl
* v1.1: 29.may.2014: David Rueda (dr@hsb-cad.com)
*	- Base plate body location corrected
* v1.0: 14.apr.2012: David Rueda (dr@hsb-cad.com)
*	- Release
*/

String sFamilyName="WA";
PropString 	sType				(0, "WA", T("|Type|"), 0); sType.setReadOnly(true);
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
_Pt0+=vy*dThickness;

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
Body bdDrilled(plDrilled, vx*dThickness, 1);

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
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`*XSQK_R$-.'!XZ<?\]8OK_+\^W9UQOC
M3G4=.'/W3_Z.B_\`K=N_?L`3'G`QG/YYXQ2'&#NP`023T]JJ:G)=)IMP]A&)
M+I5^1!C(.1G&XXSCU]:@T-+^/3]VI22-.9&($H&]%)X#$`<\"F(OZ'_R.]U_
MV#8__1C5V%<?H?\`R.]U_P!@V/\`]&-784AA1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`5QGC7G4=-&>,=,9_P"6L7^>G;OV
M[.N,\:D?VEIHSG*D;2?^FT/;_P"MZ=<4T!.3VW8..N,^E')YSGM[#_Z]!Z8R
M1QG('7I2'D]PQ![=/Z4"&:)_R.]UUYTZ,\_]=&KL*X_0_P#D=[KC'_$MC_\`
M1C5V%(84444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%<;XT)_M'3EY^Z3_`.1H<_7MV[]^W95QGC7G4=-!88QSG''[V+UZ?EV[
M]@!\T\5M#))-(J1HNYF/85#97T&H1%X/,(1RC+(A1E*^H(!I]Y:17UI+:7&2
MC@AMI*D8/KZ@_P`J;9VD&GVZVUN"L:\X9B<DYZD]33$2Z'_R.]UP?^0;'_Z,
M:NPKC]#_`.1WN^",:=&.?^NC5V%(84444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%<9XTQ_:6FC/..G_;:'W_E^O;LZXSQK_R$
M=-&>W3/_`$UB[?\`UJ`)R?Y8XI,\=01R,Y_I2G/?/N0>_P#6D)[D]<XSQSW^
MM,0S0_\`D=KK_L&Q_P#HQJ["N.T1@OCBZ!/+6$8'I_K'KL:3&%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
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
+`4444`%%%%`'_]D=
`

#End
