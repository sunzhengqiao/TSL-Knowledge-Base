#Version 8
#BeginDescription
 v1.2: 12.mar.2014: David Rueda (dr@hsb-cad.com)
System Tool: applies Stud Plate Tie harware to selected walls, according to specified settings in dialog prompted.
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
  COPYRIGHT
  ---------------
  Copyright (C) 2011 by
  hsbSOFT 

  The program may be used and/or copied only with the written
  permission from hsbSOFT, or in accordance with
  the terms and conditions stipulated in the agreement/contract
  under which the program has been supplied.

  All rights reserved.

 REVISION HISTORY
 -------------------------

 v1.2: 12.mar.2014: David Rueda (dr@hsb-cad.com)
	- Added option to erase itself when param. set to
 v1.1: 28.feb.2014: David Rueda (dr@hsb-cad.com)
	- TSL won't do any calculations any more, sill be using .NET code to do so
 v1.0: 28.jun.2013: David Rueda (dr@hsb-cad.com)
	Release
*/

String sDistributions[]={T("|Every stud|"), T("|Every second stud|"), T("|Every third stud|"), T("|Remove hardware|")};
PropString sDistribution(0,sDistributions, T("|Apply to|"),0);
String sAlignments[]={T("|Top|"), T("|Bottom|"), T("|Both|")};
PropString sAlignment(1, sAlignments, T("|Stud end|"),2);
String sSides[]={T("|Same as icon|"), T("|Opposite to icon|")};
PropString sSide(2,sSides, T("|Wall side to apply harwdare|"),0);

if(_bOnInsert){
	
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}

	PrEntity ssE("\n"+T("|Select wall(s)|"),ElementWall());
	
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	if( _Element.length()==0)
		eraseInstance();

	// Open prop. selection form
	Map mapIn;
	mapIn.setString("installationPath", _kPathHsbInstall );
	mapIn.setString("companyPath", _kPathHsbCompany);
	mapIn.setInt("platformIdentifier",0);
	
	String sInstallationPath			= 	_kPathHsbInstall;
	String sAssemblyFolder			=	"\\Utilities\\TslCustomSettings";
	String sAssembly					=	"\\ITWApplyStudTies.dll ";
	String sAssemblyPath 			=	sInstallationPath+sAssemblyFolder+sAssembly;
	String sNameSpace				=	"ITWApplyStudTies";
	String sClass						=	"ApplyStudPlateTies";
	String sClassName				=	sNameSpace+"."+sClass;
	String sFunction					=	"ApplyStudPlates";

	Map mapOut = callDotNetFunction2(sAssemblyPath, sClassName, sFunction, mapIn);

	if( _bOnInsert && mapOut.length()==0)
	{
		eraseInstance();
		return;	
	}

	int nAlignment=mapOut.getInt("ALIGNMENT");
	int nDistribution=mapOut.getInt("DISTRIBUTION");
	int nSide=mapOut.getInt("SIDE");
	
	TslInst tsl;
	String sScriptName= scriptName();
	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
	Beam lstBeams[0];
	Entity lstEnts[1];
	Point3d lstPoints[1];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
		lstPropString.append(sDistributions[nDistribution]);
		lstPropString.append(sAlignments[nAlignment]);
		lstPropString.append(sSides[nSide]);
		
	// Clone this instance to every wall
	for( int e=0; e< _Element.length(); e++)
	{
		Element el= _Element[e];
		if( !el.bIsValid())
			continue;

		//Erase other instances of this TSL
		TslInst tlsAll[]=el.tslInstAttached();
		for (int i=0; i<tlsAll.length(); i++)
		{
			String sName = tlsAll[i].scriptName();
			if ( sName == scriptName() && tlsAll[i].handle()!= _ThisInst.handle() )
			{
				tlsAll[i].dbErase();
			}			
			
		}

		lstEnts[0]=el;
		lstPoints[0]=el.ptOrg();
		tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString,0,mapOut);
		}
	eraseInstance();
}

Map mapOut=_Map;
int nAlignment=mapOut.getInt("ALIGNMENT");
	sAlignment.set(sAlignments[nAlignment]);
	sAlignment.setReadOnly(true);
int nDistribution=mapOut.getInt("DISTRIBUTION");
	sDistribution.set(sDistributions[nDistribution]);
	sDistribution.setReadOnly(true);
int nSide=mapOut.getInt("SIDE");
	sSide.set(sSides[nSide]);
	sSide.setReadOnly(true);
	
if( _Element.length()==0 || nDistribution==0 ){
	eraseInstance();
	return;
}

ElementWall el = (ElementWall) _Element[0];
if (!el.bIsValid())
{
	eraseInstance();
	return;
}

assignToElementGroup(el,true);
setDependencyOnEntity(el);

CoordSys csEl=el.coordSys();
Point3d ptElOrg=csEl.ptOrg();
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();

// Display
Display dp(-1);
dp.draw("SPT",_Pt0,vx, -vz, 0, 0);


#End
#BeginThumbnail


#End
