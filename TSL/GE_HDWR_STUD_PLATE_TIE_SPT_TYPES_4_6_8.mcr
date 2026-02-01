#Version 8
#BeginDescription
GE_HDWR_STUD_PLATE_TIE_SPT_TYPES_4_6_8
v1.1: 02.jun.2014: David Rueda (dr@hsb-cad.com)
SPT4,  SPT6, and SPT8 Family hangers (SP4, SP6, SP8 Simspon equivalent). Applies to end(s) of selected beam(s)

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
* v1.1: 02.jun.2014: David Rueda (dr@hsb-cad.com)
*	- Added features to make possible reset TXT source file using GE_HDWR_RESET_CATALOG_ENTRY tsl
* v1.0: 07.mar.2014: David Rueda (dr@hsb-cad.com)
*	- Release
*
PLEASE NOTICE: this TSL has dependency on
- TSL_Read_Metalpart_Family_Props.dll to be located at @instalation folder\Utilities\TslCustomSettings
- TXT file containing SPTR families details (to be located at any folder, TSL will prompt for location if can't find it and store the path)
*/

String sFamilyName="SPT_TYPES_4_6_8";
PropString 	sType						(0, "", T("|Type|"), 0); sType.setReadOnly(true);
PropDouble 	dBeamWidth				(0, 0, T("|Beam Width|")); dBeamWidth.setReadOnly(true);
PropDouble 	dHeightFromBase			(1, 0, T("|Height from base|")); dHeightFromBase.setReadOnly(true);
PropDouble 	dWidth						(2, 0, T("|Width|")); dWidth.setReadOnly(true);

String sChangeType= "Change type";
addRecalcTrigger(_kContext, sChangeType);

String sHelp= "Help";
addRecalcTrigger(_kContext, sHelp);
String sTab="   ";
String sLn="\n";
if(_kExecuteKey == sHelp)
{
	reportNotice(
	"SPTH Stud Tie Hardware Family (Equivalent to SPH Simpson's)"
	+sLn+"Can be attached to one or several beams and plates"
	+sLn+"\If relocated it can recalculate according to new location to reposition on closer face of beam."
	+sLn+"User can also change metal part TYPE using the 'Change type' custom definition");		
}

if(_bOnInsert  ||  _bOnRecalc || _kExecuteKey == sChangeType)
{	
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
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
		_Map.setInt("bOnInsert",1);
	       PrEntity ssE(sLn+T("|Select stud(s) and plate(s)|"), Beam());
	       if (ssE.go()) {
	               _Beam = ssE.beamSet();
	       }
		
		if(_Beam.length()==0)
		{
			eraseInstance();
			return;
		}

		Point3d ptRef=getPoint(sLn+T("|Pick a point to define on what face of studs place hardware|"));
		
		// Define closer beam to point to define all beams direction for reference point
		Beam bmCloserToRef, bmVerticals[0], bmBottomPlates[0], bmTopPlates[0];
		double dCloserDistance=U(25000, 1000);
		for(int b=0; b< _Beam.length(); b++)
		{
			Beam bm= _Beam[b];
			if( _ZW.isParallelTo(bm.vecX()) ) // Get allverticals and define bmCloserToRef
			{
				bmVerticals.append(bm);
				Point3d pt1=bm.ptCen();
				pt1.setZ(ptRef.Z());
				if( (ptRef-pt1).length()<dCloserDistance)
				{
					dCloserDistance=(ptRef-pt1).length();
					bmCloserToRef= bm;
				}
			}
			else 
			{
				if(bm.type()==_kBottom || bm.type()==_kSFBottomPlate || bm.type()==_kSFVeryBottomPlate)
				{
					bmBottomPlates.append(bm);
				}
			
				else if(bm.type()==_kTopPlate || bm.type()==_kSFTopPlate || bm.type()==_kSFVeryTopPlate)
				{		
					bmTopPlates.append(bm);
				}
			}
		}
		
		if( bmBottomPlates.length() == 0 && bmTopPlates.length() == 0)
		{
			reportMessage(sLn+T("|Not valid top or bottom plates provided|"));
			eraseInstance();
			return;
		}		
		
		if( bmVerticals.length() == 0 )
		{
			reportMessage(sLn+T("|Not valid vertical studs provided|"));
			eraseInstance();
			return;
		}		

		if( bmBottomPlates.length() == 0)
			reportMessage(sLn+T("|Bottom plates found:|")+" "+T("No"));
		else
			reportMessage(sLn+T("|Bottom plates found:|")+" "+T("Yes"));
			
		if( bmTopPlates.length() == 0)
			reportMessage(sLn+T("|Top plates found:|")+" "+T("No"));
		else
			reportMessage(sLn+T("|Top plates found:|")+" "+T("Yes"));

		int bTieTop, bTieBottom;
		if(bmBottomPlates.length()>0)
			bTieBottom=true;
		if(bmTopPlates.length()>0)
			bTieTop=true;

		// Clonning for every beam
		TslInst tsl;
		String sScriptName = scriptName();
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		Entity lstEnts[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		Point3d lstPoints[1];lstPoints[0]= ptRef;
		Beam lstBeams[0];
		mapOut.setInt("bOnInsert",1);
		for(int b=0;b<bmVerticals.length();b++)
		{
			Beam bm= bmVerticals[b];
			if( bm.element().bIsValid())
			{
				lstEnts.setLength(1);
				lstEnts[0]=bm.element();
			}
			else
				lstEnts.setLength(0);

			if( bTieBottom)
			{
				lstBeams.setLength(0);
				lstBeams.append(bm);
				lstBeams.append(bmBottomPlates);

				tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString, 1, mapOut);
			}
			if( bTieTop)
			{
				lstBeams.setLength(0);
				lstBeams.append(bm);
				lstBeams.append(bmTopPlates);

				tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString, 1, mapOut);
			}
		}		
		eraseInstance();
		return;
	}
}

int bOnInsert=_Map.getInt("bOnInsert");

if(_Beam.length()==0)
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

if( _Map.length()==0)
{
	eraseInstance();
	return;
}

Vector3d vx, vy, vz;
// vx - length
// vy - width
// vz - thickness

double dPlateWidth, dVeryPlateWidth;
Map subMap;

if(bOnInsert) // Manually inserted
{
	Beam bmPlates[0];
	bmPlates.append(_Beam);
	bmPlates.removeAt(0);
	Beam bmBottomPlates[0], bmVeryBottomPlates[0], bmTopPlates[0], bmVeryTopPlates[0];
	
	for(int b=0; b< bmPlates.length(); b++)
	{
		Beam bm= bmPlates[b];
		if(bm.type()== _kBottom || bm.type()== _kSFBottomPlate)
		{
			bmBottomPlates.append(bm);
		}
		else if(bm.type()== _kSFVeryBottomPlate)
		{
			bmVeryBottomPlates.append(bm);
		}
		else if(bm.type()==_kTopPlate || bm.type()==_kSFTopPlate)
		{		
			bmTopPlates.append(bm);
		}
		else if(bm.type()==_kSFVeryTopPlate)
		{		
			bmVeryTopPlates.append(bm);
		}
	}

	Point3d ptBmCen= bm.ptCen();
	Beam bmFirstPlate, bmExtraPlate;
	if( bmBottomPlates.length()>0)
	{
		Vector3d vX= bm.vecX();
		if( vX.dotProduct( bmBottomPlates[0].ptCen()- ptBmCen) <0)
			vX=- vX;
		Beam bmIntersect[]= Beam().filterBeamsHalfLineIntersectSort( bmBottomPlates, ptBmCen, vX);
		if( bmIntersect.length()>0)
		{
			bmFirstPlate= bmIntersect[0];
			bmIntersect= Beam().filterBeamsHalfLineIntersectSort( bmVeryBottomPlates, ptBmCen, vX);
			if( bmIntersect.length()>0)
			{
				bmExtraPlate= bmIntersect[0];
			}
		}
	}
	else if( bmTopPlates.length()>0)
	{
		Vector3d vX= bm.vecX();
		if( vX.dotProduct( bmTopPlates[0].ptCen()- ptBmCen) <0)
			vX=- vX;
		Beam bmIntersect[]= Beam().filterBeamsHalfLineIntersectSort( bmTopPlates, ptBmCen, vX);
		if( bmIntersect.length()>0)
		{
			bmFirstPlate= bmIntersect[0];
			bmIntersect= Beam().filterBeamsHalfLineIntersectSort( bmVeryTopPlates, ptBmCen, vX);
			if( bmIntersect.length()>0)
			{
				bmExtraPlate= bmIntersect[0];
			}
		}
	}
	// We have plate and very top/bottom plate in bmFirstPlate and bmExtraPlate
	if( !bmFirstPlate.bIsValid())
	{
		eraseInstance();
		return;
	}

	setDependencyOnEntity(bm);
	setDependencyOnEntity(bmFirstPlate);
	setDependencyOnEntity(bmExtraPlate);
	
	if(_Entity.length()==1 && _Entity[0].bIsValid() )
		assignToElementGroup((Element)_Entity[0], true);
	
	// Define vectors and Relocating _Pt0 to closest face of stud
	// vx - length
	// vy - width
	// vz - thickness
	
	vx=bm.vecX();
	if(vx.dotProduct(bm.ptCen()-bmFirstPlate.ptCen())<0)
		vx=-vx;
	
	Vector3d vPlateY= bmFirstPlate.vecY();
	Vector3d vPlateZ= bmFirstPlate.vecZ();
	Vector3d vPlateToSky= bmFirstPlate.vecD( bm.vecX());
	if( vPlateToSky.isParallelTo(vPlateY))
		vz=vPlateZ;
	else
		vz=vPlateY;
	
	vz=bm.vecD(vz);
	if( vz.dotProduct(_Pt0-bm.ptCen()) < 0 )
		vz= -vz;
					
	vy=vz.crossProduct(vx);
	_Pt0= bm.ptCen()-vx*bm.dL()*.5+vz*bm.dD(vz)*.5;
		
	dPlateWidth=bmFirstPlate.dD(vx);
	dVeryPlateWidth=bmExtraPlate.dD(vx);

	sType.set(subMap.keyAt(0));
	subMap= _Map.getMap(_Map.keyAt(0));
} // end of code if manually inserted

else if(!bOnInsert) // Inserted by tool
{
	_Pt0=_Map.getPoint3d("PtOrg");
	vx=_Map.getVector3d("vx");
	vy=_Map.getVector3d("vy");
	vz=_Map.getVector3d("vz");
	sType.set(_Map.getString("Type"));
		
	setDependencyOnEntity(bm);
	
	if(bm.element().bIsValid())
	{
		Element elContainer=bm.element();	
		assignToElementGroup(elContainer, true);
	}
	
	subMap= _Map;

	dPlateWidth=subMap.getDouble("PlateWidth");
	dVeryPlateWidth=subMap.getDouble("VeryPlateWidth");
}

Display dp(-1);
// Set props from map (defaults if not value given)
if(	subMap.hasDouble("Beam Width") && subMap.getDouble("Beam Width") > 0 
	&& subMap.hasDouble("Height from base") && subMap.getDouble("Height from base") > 0
	&& subMap.hasDouble("WIDTH") && subMap.getDouble("WIDTH") > 0)
	{
		dBeamWidth.set(subMap.getDouble("Beam Width"));
		dHeightFromBase.set(subMap.getDouble("Height from base"));
		dWidth.set(subMap.getDouble("WIDTH"));
	}
else
	{
		dp.color(1);
		dBeamWidth.set(U(115,4.5));
		dHeightFromBase.set(U(29,2.125));
		dWidth.set(U(35,1.375));
	}
		
// We have location, must erase other instance of this TSL at same location
Map mapBm= bm.subMap(scriptName());
for( int e=mapBm.length()-1; e>=0;e-- )
{
	String sKey= mapBm.keyAt(e);
	Entity ent= mapBm.getEntity(sKey);
	TslInst tsl=(TslInst)ent;
	if(!tsl.bIsValid())
		continue;
	Point3d ptInsert= tsl.ptOrg();
	if( (ptInsert-_Pt0).length()<U(1, 0.04) && sKey != _ThisInst.handle() )
		tsl.dbErase();
}
mapBm.setEntity(_ThisInst.handle(), _ThisInst);
bm.setSubMap(scriptName(), mapBm);

// Draw metalpart
double dThickness= U(2.38125, 0.09375);
PLine pl;

// Front vertical plate
Point3d pt0=_Pt0;
pt0+=-vx*(dPlateWidth+dVeryPlateWidth);
pl.addVertex(pt0);
pt0+=vy*dWidth*.5;
pl.addVertex(pt0);
pt0+=vx*dHeightFromBase;
pl.addVertex(pt0);
pt0-=vy*dWidth;
pl.addVertex(pt0);
pt0-=vx*dHeightFromBase;
pl.addVertex(pt0);
pl.close();
Body bdFront(pl,vz*dThickness,1);
dp.draw(bdFront);

Body bdBack=bdFront;
bdBack.transformBy(-vz*(dBeamWidth+dThickness));
dp.draw(bdBack);

PLine pl1;
pt0=_Pt0;
pt0+=-vx*(dPlateWidth+dVeryPlateWidth);
pt0+=vz*dThickness;
pl1.addVertex(pt0);
pt0+=vy*dWidth*.5;
pl1.addVertex(pt0);
pt0-=vz*(dBeamWidth+dThickness*2);
pl1.addVertex(pt0);
pt0-=vy*dWidth;
pl1.addVertex(pt0);
pt0+=vz*(dBeamWidth+dThickness*2);
pl1.addVertex(pt0);
pl1.close();
Body bdBase(pl1,-vx*dThickness,1);
dp.draw(bdBase);

return;

#End
#BeginThumbnail


#End
