#Version 8
#BeginDescription
v1.4: 02.jun.2014: David Rueda (dr@hsb-cad.com)
SPTR Family hanger (RSP4 Simspon equivalent). Applies to end(s) of selected beam(s)


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
* v1.3: 06.mar.2013: David Rueda (dr@hsb-cad.com)
*	- Bugfix: DImensions properly taken from map accordingly to insertion method (manual/auto)
* v1.2: 28.feb.2013: David Rueda (dr@hsb-cad.com)
*	- TSL can act as dummy also now, to be pulled bye "Apply Stud Ties" utility
* v1.1: 29.oct.2013: David Rueda (dr@hsb-cad.com)
*	- Bugfix: Type set from map now, it was empty before
* v1.0: 30.jun.2013: David Rueda (dr@hsb-cad.com)
*	- Release
*
PLEASE NOTICE: this TSL has dependency on
- TSL_Read_Metalpart_Family_Props.dll to be located at @instalation folder\Utilities\TslCustomSettings
- TXT file containing SPTR families details (to be located at any folder, TSL will prompt for location if can't find it and store the path)
*/

String sFamilyName="SPTR";
PropString 	sType					(0, "", T("|Type|"), 0); sType.setReadOnly(true);
PropDouble 	dLength				(0, 0, T("|Lenght|")); dLength.setReadOnly(true);
PropDouble 	dMajorWidth			(1, 0, T("|Major Width|")); dMajorWidth.setReadOnly(true);
PropDouble 	dMinorWidth			(2, 0, T("|Minor Width|")); dMinorWidth.setReadOnly(true);

String sChangeType= "Change type";
addRecalcTrigger(_kContext, sChangeType);

String sHelp= "Help";
addRecalcTrigger(_kContext, sHelp);
String sTab="   ";
String sLn="\n";
if(_kExecuteKey == sHelp)
{
	reportNotice(
	"SPTR Stud Tie Hardware Family (Equivalent to RDP4 Simpson's)"
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
double dOff;

int bExistsExtraPlate=false;
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
		
	if( bmExtraPlate.bIsValid())
		bExistsExtraPlate=true;
	
	sType.set(_Map.keyAt(0));
	subMap=_Map.getMap(_Map.keyAt(0));

} // end of code if manually inserted

else if(!bOnInsert) // Inserted by tool
{
	_Pt0=_Map.getPoint3d("PtOrg");
	vx=_Map.getVector3d("vx");
	vy=_Map.getVector3d("vy");
	vz=_Map.getVector3d("vz");
	sType.set(_Map.getString("Type"));
	
	if(_Map.getInt("HasExtraPlate"))
		bExistsExtraPlate=true;
		
	setDependencyOnEntity(bm);
	if(bm.element().bIsValid())
	{
		Element elContainer=bm.element();	
		assignToElementGroup(elContainer, true);
	}
	
	subMap=_Map;
}

Display dp(-1);
// Set props from map (defaults if not value given)
if(	subMap.hasDouble("LENGTH") && subMap.getDouble("LENGTH") > 0 
	&& subMap.hasDouble("MAJOR WIDTH") && subMap.getDouble("MAJOR WIDTH") > 0 
	&& subMap.hasDouble("MINOR WIDTH") && subMap.getDouble("MINOR WIDTH") > 0)
{
	dLength.set(subMap.getDouble("LENGTH"));
	dMajorWidth.set(subMap.getDouble("MAJOR WIDTH"));
	dMinorWidth.set(subMap.getDouble("MINOR WIDTH"));
}
else
{
	dp.color(1);
	dLength.set(U(115,4.5));
	dMajorWidth.set(U(29,2.125));
	dMinorWidth.set(U(35,1.375));
}

double dVariableStudEndLength=U(21.5,0.85);
if(bExistsExtraPlate==true)
	dOff=dVariableStudEndLength;

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

double dSideCut=(dMajorWidth-dMinorWidth)/2;

// Draw metalpart
double dThickness= U(2.38125, 0.09375);
double dPlateLength=U(35.5, 1.4);
double dStrapLength=U(12.5, 0.5);
double dStrapDepth=U(5, .2);
double dStudLenght=U(44.5, 1.75);
double dCornerLength=U(3, 0.125);

PLine pl;
Point3d pt0=_Pt0;

pt0+=-vx*dPlateLength;
pt0+=-vx*dOff;
pl.addVertex(pt0);pt0.vis();
pt0+=-vy*(dMajorWidth*.5-dCornerLength);
pl.addVertex(pt0);pt0.vis();
pt0+=vx*dCornerLength-vy*dCornerLength;
//pt0+=vx*dOff;
pl.addVertex(pt0);pt0.vis();
pt0+=-vx*dCornerLength;
pt0+=vx*dPlateLength;
//pt0+=vx*dOff;
pl.addVertex(pt0);
pt0+=vy*dSideCut;
pl.addVertex(pt0);
pt0+=vx*dVariableStudEndLength;
//pt0+=vx*dOff;
pl.addVertex(pt0);
pt0+=-vy*dStrapDepth;
pl.addVertex(pt0);
pt0+=vx*dStrapLength;
//pt0+=vx*dOff;
pl.addVertex(pt0);
pt0+=vy*dStrapDepth;
pl.addVertex(pt0);
pt0+=vx*dStudLenght;
//pt0+=vx*dOff;
pl.addVertex(pt0);
pt0+=vy*dMinorWidth*.5;
pl.addVertex(pt0);

CoordSys csMirror;
csMirror.setToMirroring(Plane(_Pt0,vy));
PLine pl2=pl;
pl2.transformBy(csMirror);
Point3d pt2[]=pl2.vertexPoints(1);
for(int p=pt2.length()-1;p>0;p--)
	pl.addVertex(pt2[p]);
	
pl.close();

Body bd(pl, vz*dThickness,1);
dp.draw(bd);

#End
#BeginThumbnail
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
04`%%%%`!1110`4444`?_V<88
`




#End
