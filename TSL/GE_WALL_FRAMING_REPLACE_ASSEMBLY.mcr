#Version 8
#BeginDescription
v1.4: 03.nov.2013: David Rueda (dr@hsb-cad.com)
GE_WALL_FRAMING_REPLACE_ASSEMBLY
Replaces assembly (on female wall) on wall-to-wall connection
Using TSL's properties user can set:
- Assembly type
- Assembly rotation (0, 90, 180, 270 degrees)
- Assembly offset, in case new assembly needs to be relocated along wall length. Takes negative/positive values to move to left/right side of wall.
PLEASE NOTICE: This TSL works with these other, therefore must be also in the drawing:
- GE_WALL_RERUN_BLOCKING_LINES
- GE_WALL_SECTION_BLOCKING
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
 v1.4: 03.nov.2013: David Rueda (dr@hsb-cad.com)
	- Version control
 v1.3: 03.nov.2013: David Rueda (dr@hsb-cad.com)
	- Company path added to mapIn when calling dll
 v1.2: 11.oct.2013: David Rueda (dr@hsb-cad.com)
	- Description updated
 v1.1: 03.oct.2013: David Rueda (dr@hsb-cad.com)
	- .Net function name to display assemblie list updated
 v1.0: 02.oct.2013: David Rueda (dr@hsb-cad.com)
	- Release
*/

U(1, "inch");
String sLn="\n";
double dTolerance=U(0.0001);
_ThisInst.setSequenceNumber(0);

if(_bOnInsert)
{	
	if( insertCycleCount()>1 )
	{
		eraseInstance();
		return;
	}

	_Pt0=getPoint(sLn+T("|Select any point close to a wall-to-wall connection where to replace assembly|"));

	// Get closer element to selected Point (_Pt0)
	// Get all Elements on group
	Group gpCurrent(_kCurrentGroup);
	Entity arEnt[] = gpCurrent.collectEntities(true, Element(), _kModelSpace);
	// Search for all Walls
	Element elWalls[0];
	for(int e=0; e<arEnt.length(); e++)
	{
		if(arEnt[e].bIsKindOf(Wall()) || arEnt[e].bIsKindOf(ElementWall()) || arEnt[e].bIsKindOf(ElementWallSF()))
		{
			elWalls.append((Element)arEnt[e]);
		}
	}
	
	// Getting closer wall to point
	double dDist=U(1000);
	Element el1;
	for(int e=0; e<elWalls.length(); e++)
	{
		Element el=elWalls[e];
		PLine plEl=el.plOutlineWall();
		Point3d ptClosest=plEl.closestPointTo(_Pt0);
		if((_Pt0-ptClosest).length()<dDist)
		{
			dDist=(_Pt0-ptClosest).length();
			el1=el;
		}		
	}
	
	// Getting next closer element to point 
	Element elWallsConnected[]= ((ElementWall)el1).getConnectedElements();
	if( elWallsConnected.length() == 0)
	{
		reportMessage(sLn+T("|Message from|")+" "+scriptName()+" TSL : "+T("|Wall|")+" "+el1.number()+" "+ T("|has not valid connections with other elements|")+" Inf: 001");	
		eraseInstance();
		return;
	}
	
	dDist=U(1000);
	Element el2;
	for(int e=0; e<elWallsConnected.length(); e++)
	{
		Element el=elWallsConnected[e];
		PLine plEl=el.plOutlineWall();
		Point3d ptClosest=plEl.closestPointTo(_Pt0);
		if((_Pt0-ptClosest).length()<dDist && el!=el1)
		{
			dDist=(_Pt0-ptClosest).length();
			el2=el;
		}		
	}	

	//Checking this is a T or an L connection 
	PLine plEl1=el1.plOutlineWall();
	PLine plEl2=el2.plOutlineWall();
	Point3d ptAllInt[]=plEl1.intersectPLine(plEl2);
	if(ptAllInt.length()!=2)
	{
		reportMessage("\n"+T("|ERROR: This is not a proper T or L connection or the connection is not cleaned up, cannot apply this tsl on this type of connection|")+" Inf: 002");
		eraseInstance();
		return;
	}

	Point3d ptCon1=ptAllInt[0];
	Point3d ptCon2=ptAllInt[1];
	int nEl1HasCon1, nEl1HasCon2, nEl2HasCon1, nEl2HasCon2; 
	nEl1HasCon1=nEl1HasCon2=nEl2HasCon1=nEl2HasCon2=false;
	//Checking cioncident vertex
	//Element 1
	Point3d ptAllEl1[]=plEl1.vertexPoints(1);
	for(int p=0;p<ptAllEl1.length();p++)
	{
		if((ptAllEl1[p]-ptCon1).length()<dTolerance)
		{
				nEl1HasCon1=true;
		}
		if((ptAllEl1[p]-ptCon2).length()<dTolerance)
		{
				nEl1HasCon2=true;
		}
	}
	
	Point3d ptAllEl2[]=plEl2.vertexPoints(1);
	for(int p=0;p<ptAllEl2.length();p++)
	{
		if((ptAllEl2[p]-ptCon1).length()<dTolerance)
		{
				nEl2HasCon1=true;
		}
		if((ptAllEl2[p]-ptCon2).length()<dTolerance)
		{
				nEl2HasCon2=true;
		}
	}
	
	//Check that connection accomplish second condition and define which wall is male and which is female
	int nEl1IsMale,nEl2IsMale;
	nEl1IsMale=nEl2IsMale=false;
	if(nEl1HasCon1&&nEl1HasCon2)//el1 has 2 coincident vertexes 
	{
		nEl1IsMale=true;
	}
	if(nEl2HasCon1&&nEl2HasCon2) //el2 has 2 coincident vertexes 
	{
		nEl2IsMale=true;
	}
	
	Element elMale, elFemale;
	if(nEl1IsMale&&nEl2IsMale)//It's not a skewed connection, but an angled end to end connection
	{
		reportMessage("\n"+T("|WARNING: Male to male connection not implemented yet|")+" Inf: 003");
		eraseInstance();
		return;
	}
	else if(nEl1IsMale)
	{
		elMale=el1 ;
		elFemale=el2;
	}
	else if(nEl2IsMale)
	{
		elMale=el2;
		elFemale=el1;
		
	}
	else //None of elements has 2 coinident points
	{
		reportMessage("\n"+T("|ERROR: This is not a T or L connection, cannot apply this tsl on this type of connection|")+" Inf: 004");
		eraseInstance();
		return;
	}

	assignToElementGroup(elFemale,true);
	setDependencyOnEntity(elFemale);
	Point3d ptFemaleOrg=elFemale.ptOrg();
	Vector3d vx = elFemale.vecX();
	Vector3d vz = elFemale.vecZ();
	Point3d ptFront=ptFemaleOrg;
	Point3d ptBack=ptFemaleOrg-vz*elFemale.dBeamWidth();

	Point3d ptMaleOrg= elMale.ptOrg();
	Vector3d vMaleX=elMale.vecX();
	Vector3d vMaleY=elMale.vecY();
	Vector3d vMaleZ=elMale.vecZ();
	PlaneProfile ppMale(elMale.plOutlineWall());
	LineSeg lsMale=ppMale.extentInDir(vMaleX);
	double dMaleLength=abs(vMaleX.dotProduct(lsMale.ptStart()-lsMale.ptEnd()));
	double dMaleWidth=elMale.dBeamWidth();
	Point3d ptMaleHalfSide= ptMaleOrg-elMale.vecZ()*elMale.dBeamWidth()*.5;
	Point3d ptMaleCenter= ptMaleOrg+vMaleX*dMaleLength*.5-vMaleZ*dMaleWidth*.5+vMaleY*((Wall)elMale).baseHeight()*.5;
	_Map.setPoint3d("ptMaleCenter",ptMaleCenter);
	_Map.setDouble("MaleWidth",abs(vx.dotProduct(ptCon1-ptCon2)));

	// Projecting _Pt0 to connecting face of female wall
	if(vz.dotProduct(ptMaleOrg-ptFemaleOrg)<0)
	{
		_Pt0+=vz*vz.dotProduct(ptBack-_Pt0);
	}
	else
	{
		_Pt0+=vz*vz.dotProduct(ptFront-_Pt0);
	}	
	_Pt0+=vx*vx.dotProduct(ptMaleHalfSide- _Pt0);
	_Pt0.setZ( ptFemaleOrg.Z());
	_Map.setPoint3d("ptContact",_Pt0);
	_Element.append(elFemale);
	_Element.append(elMale);

	// Define module name
	String sNewModule= elFemale.code()+"-"+elFemale.number()+"-CON-"+elMale.code()+"-"+elMale.number(); 
	_Map.setString("NewModule",sNewModule);
	
	// Present assemblies dialog
	Map mapIn;// To be passed to dotNet
	//Setting info
	mapIn.setInt("DetailCategory",6);
	mapIn.setString("StickframePath",_kPathHsbWallDetail);
	mapIn.setString("CompanyPath", _kPathHsbCompany);

	String sInstallationPath			= 	_kPathHsbInstall;
	String sAssemblyFolder			=	"\\Utilities\\hsbFramingDefaultsEditor";
	String sAssembly					=	"\\hsbFramingDefaults.details.dll ";
	String sAssemblyPath 			=	sInstallationPath+sAssemblyFolder+sAssembly;
	String sNameSpace				=	"hsbSoft.FramingDefaults.Details.TSL";
	String sClass						=	"DetailLibraryAccessInTSL";
	String sClassName				=	sNameSpace+"."+sClass;
	String sFunction					=	"InvokeDetailsLibrary2";

	Map mapOut = callDotNetFunction2(sAssemblyPath, sClassName, sFunction, mapIn);
	if(mapOut.getString("SELECTEDDETAILNAME")=="")
	{
		eraseInstance();
		return;
	}
	_Map.setString("SELECTEDDETAILNAME",mapOut.getString("SELECTEDDETAILNAME"));
	
	sFunction="GetDetailNames";
	Map mapDetailNames= callDotNetFunction2(sAssemblyPath, sClassName, sFunction, mapIn);
	_Map.setMap("DetailNames",mapDetailNames);
	
	// Cloning GE_WALL_RERUN_BLOCKING_LINES
	TslInst tsl;
	String sScriptName ="GE_WALL_RERUN_BLOCKING_LINES";
	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
	Beam lstBeams[0];
	Entity lstEnts[1];
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	lstEnts[0]=elFemale;
	tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString );
		
	_Map.setInt("ExecutionMode",0);
	return;
}

Map mapDetailNames=_Map.getMap("DetailNames");
String sDetailNames[0];
for(int m=0;m<mapDetailNames.length();m++)
{
	String sKey=mapDetailNames.keyAt(m);
	String sName=mapDetailNames.getString(sKey);
	if(sName!="")
		sDetailNames.append(sName);
}

PropString sAssembly(0, sDetailNames, T("|Assembly|"),2);
String sAngles[]={"0","90","180","270"};
PropString sRotate(1, sAngles, T("|Rotate|"),0);
int nAngle=sAngles.find(sRotate,0);
PropDouble dOffset(0,0,T("|Offset|"));
dOffset.setDescription(T("|Use it to relocate the new assembly to left (negative value) /right (positive value) of wall|"));

if(_Element.length()==0)
{
	eraseEntity();
	return;
}

Element el=_Element[0];
if(!el.bIsValid())
{
	eraseInstance();
	return;
}
assignToElementGroup(el,1);
setDependencyOnEntity(el);

Point3d ptElOrg= el.ptOrg();
Vector3d vx = el.vecX();
Vector3d vy = el.vecY();
Vector3d vz = el.vecZ();

Point3d ptContact=_Map.getPoint3d("ptContact");
_Pt0=ptContact+vx*dOffset;

// Define cleaning area
String sNewModule=_Map.getString("NewModule");
double dAreaToClean=U(7.5);
Point3d ptMostLeftToErase=-vx*dAreaToClean*.5;
Point3d ptMostRightToErase=+vx*dAreaToClean*.5;

if( _bOnElementConstructed || !_Map.getInt("ExecutionMode") )
{
	// Define cleaning area
	double dCleanAreaX=dAreaToClean;
	double dCleanAreaY=((Wall)el).baseHeight();
	double dCleanAreaZ=el.dBeamWidth()*2;
	Point3d ptCleanCenter= ptContact;
	ptCleanCenter+=vz*vz.dotProduct(ptElOrg-ptCleanCenter);
	ptCleanCenter-=vz*el.dBeamWidth()*.5;
	ptCleanCenter+=vy*vy.dotProduct(ptElOrg-ptCleanCenter);
	Body bdClean( ptCleanCenter, vx, vy, vz, dCleanAreaX, dCleanAreaY, dCleanAreaZ, 0, 1, 0);
	Beam bmAll[]=el.beam();
	Point3d ptBottom, ptTop;
	double dDistanceBottom=0, dDistanceTop=U(1000);
	for(int b=0; b<bmAll.length(); b++)
	{
		Beam bm=bmAll[b];
		if(bm.envelopeBody().hasIntersection(bdClean) && bm.type() != _kBottom && bm.type() != _kSFBottomPlate && bm.type() != _kSFVeryBottomPlate 
		&& bm.type() !=_kTopPlate && bm.type() !=_kSFTopPlate && bm.type() !=_kSFVeryTopPlate)
		{
			if( bm.module() != sNewModule)
			bm.dbErase();
		}
		
		// Colecting bottom and top points for new studs length
		// Bottom point
		if(bm.type() == _kBottom || bm.type() == _kSFBottomPlate || bm.type() == _kSFVeryBottomPlate)
		{
			Point3d ptTopOfBottomPlate=bm.ptCen()+bm.vecD(vy)*bm.dD(vy)*.5;
			double dHeight=abs(vy.dotProduct(ptTopOfBottomPlate-ptElOrg));
			if(dDistanceBottom<dHeight)
			{
				dDistanceBottom=dHeight;
				ptBottom=ptTopOfBottomPlate;
			}
		}
		_Map.setPoint3d("ptBottom",ptBottom);

		// Top point
		if(bm.type() ==_kTopPlate || bm.type() ==_kSFTopPlate || bm.type() ==_kSFVeryTopPlate)
		{
			Point3d ptBottomOfTopPlate=bm.ptCen()-bm.vecD(vy)*bm.dD(vy)*.5;
			double dHeight=abs(vy.dotProduct(ptBottomOfTopPlate-ptElOrg));
			if(dDistanceTop>dHeight)
			{
				dDistanceTop=dHeight;
				ptTop=ptBottomOfTopPlate;
			}
		}
		_Map.setPoint3d("ptTop",ptTop);

	}

	if(!_Map.getInt("ExecutionMode"))
	{
		sAssembly.set(_Map.getString("SELECTEDDETAILNAME"));
	}
	_Map.setInt("ExecutionMode",1);	
}

// Define params. for insert Directive
PlaneProfile ppEl(el.plOutlineWall());
LineSeg ls=ppEl.extentInDir(vx);
double dElLength=abs(vx.dotProduct(ls.ptStart()-ls.ptEnd()));
double dElWidth=el.dBeamWidth();


Point3d ptMaleCenter=_Map.getPoint3d("ptMaleCenter");
Point3d ptElCenter= ptElOrg+vx*dElLength*.5-vz*dElWidth*.5+vy*((Wall)el).baseHeight()*.5;

double dElMaleWidth=_Map.getDouble("MaleWidth");

Vector3d vTmp (ptMostRightToErase-ptMostLeftToErase); vTmp.normalize();
Vector3d vDx, vDy, vDz;
Vector3d vFemaleToMale=vz;
if(vFemaleToMale.dotProduct(ptMaleCenter-ptElCenter)<0)
	vFemaleToMale=-vFemaleToMale;
Vector3d vxToRightOfConnection=vy.crossProduct(vFemaleToMale);

int nAlignY, nAlignZ;
vDx= vy;
if( nAngle==0)//0
{
	vDy=vxToRightOfConnection;
	nAlignY=0;
	nAlignZ=1;
}
else if( nAngle==1)//90
{
	vDy=-vFemaleToMale;
	nAlignY=1;
	nAlignZ=0;
}
else if( nAngle==2)//180
{
	vDy=-vxToRightOfConnection;
	nAlignY=0;
	nAlignZ=-1;
}
else if( nAngle==3)//270
{
	vDy=+vFemaleToMale;
	nAlignY=-1;
	nAlignZ=0;
}
vDz= vDx.crossProduct( vDy);

Point3d ptBottom=_Map.getPoint3d("ptBottom");ptBottom+=vx*vx.dotProduct(_Pt0-ptBottom);
Point3d ptTop=_Map.getPoint3d("ptTop");ptTop+=vx*vx.dotProduct(_Pt0-ptTop);
_Pt0+=vy*vy.dotProduct(ptBottom-_Pt0);
Map mapDetIns;
mapDetIns.setPoint3d("PTORG", _Pt0);
mapDetIns.setString("DetailName", sAssembly);
mapDetIns.setString("ModuleName",sNewModule);

mapDetIns.setVector3d("VECX", vDx);
mapDetIns.setVector3d("VECY", vDy);
mapDetIns.setVector3d("VECZ", vDz);

mapDetIns.setDouble("xFlag", 1, _kNoUnit); //Alignment along X
mapDetIns.setDouble("yFlag", nAlignY, _kNoUnit); //Alignment along Y
mapDetIns.setDouble("zFlag", nAlignZ, _kNoUnit); //Alignment along Z

double dNewBeamsLength=vy.dotProduct(ptTop-ptBottom);
mapDetIns.setDouble("Length", dNewBeamsLength); //Length to extrude

ElemConstructionMap cdDetIns1("ElementDetailInsert", mapDetIns);
el.addTool(cdDetIns1);

Display dp(3);
_Pt0+=vy*vy.dotProduct(ptElOrg-_Pt0);
PLine plCircle; plCircle.createCircle(_Pt0,vy,U(.5));
dp.draw(plCircle);
#End
#BeginThumbnail

#End
