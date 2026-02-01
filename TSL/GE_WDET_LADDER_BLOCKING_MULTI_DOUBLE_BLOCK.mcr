#Version 8
#BeginDescription
Inserts ladders (edge or flat) between studs on selected wall, defined on Defaults Editor. Cannot be inserted by user, only on framing process.
v2.6: 25.sep.2013: David Rueda (dr@hsb-cad.com)

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 2
#MinorVersion 7
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2011 by
*  hsbSOFT 
*  UNITED STATES OF AMERICA
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
* v2.6: 25.sep.2013: David Rueda (dr@hsb-cad.com)
	- Moving older code where it won't bother but still will be safe
* v2.5: 23.jun.2013: David Rueda (dr@hsb-cad.com)
	- Erasing OPM, change _bOnInsert to warn user cannot use this TSL manually but on Defaults Editor
* v2.4: 13.jun.2013: David Rueda (dr@hsb-cad.com)
	- Erasing code but bOnInsert, now everything will be handled by construction directive
* v2.3: 24.ago.2012: David Rueda (dr@hsb-cad.com)
	- Added very top plates in searching for plates
* v2.2: 23.ago.2012: David Rueda (dr@hsb-cad.com)
	- Default value for distribution measure changed to edge of blocking
* v2.1: 19.jul.2012: David Rueda (dr@hsb-cad.com)
	- Description added
	- Thumbnail added
* v2.0: 12.ago.2012: David Rueda (dr@hsb-cad.com):
	- Beam color also set from _Map if present
	- Distribution can now be set to center or edge of block pieces
	- Default beam color is red
* v1.9: 31.jul.2012: David Rueda (dr@hsb-cad.com):
	- Performance improved: beam() function (expensive performance) used only once (used twice before)
	- Performance improved: Erasing intersecting blocking and collecting top and bottom plates are now in same loop operation
* v1.8: 31.jul.2012: David Rueda (dr@hsb-cad.com):
	- Updated material and grade values from defaults editor for MANUAL insertions (not doing combination of material!grade!treatment anymore, now under Manish control)
* v1.7: 03.apr.2012: David Rueda (dr@hsb-cad.com):
	- Created blocking hsbId set to "412" (SFBlocking)
	- Material and grade assignment taken directly from hsbMaterial / hsbGrade from map (avoided manual combination of old values for name/material/grade)
* v1.6: 08.nov.2011: David Rueda (dr@hsb-cad.com): 	Module prop. set to all beams part of same subassembly
* v1.5: 31.oct.2011: David Rueda (dr@hsb-cad.com): 	Information set to left and right studs, to make them part of same subassembly
* v1.4: 28.sep.2011: David Rueda (dr@hsb-cad.com): 	Width and heigth also brougth from _Map if exist
* v1.3: 27.sep.2011: David Rueda (dr@hsb-cad.com): 	OPM Reorganized according to Manish's dialogs
														   	Added information to OPM
															Set name and material with naming convention
															Set values from _Map if passed
* v1.2: 19.sep.2011: David Rueda (dr@hsb-cad.com): 	Back or front side of wall will now be defined by given point, therefore Arrow side/Non arrow side prop will be erased...
* v1.1: 14.ago.2011: David Rueda (dr@hsb-cad.com): 	Bugfix
* v1.0: 07.ago.2011: David Rueda (dr@hsb-cad.com): 	Release
*/

if(_bOnInsert){
	reportMessage("\n"+scriptName()+" "+T("|cannot be manually inserted. It places ladder blocking on wall T connections, defined on Defaults Editor.|"));
	eraseInstance();
	return;
}
//eraseInstance();

String sLumberItemKeys[0];
String sLumberItemNames[0];

// Calling dll to fill item lumber prop.
Map mapIn;
Map mapOut;

//Setting info
String sCompanyPath = _kPathHsbCompany;
mapIn.setString("CompanyPath", sCompanyPath);

String sInstallationPath			= 	_kPathHsbInstall;
mapIn.setString("InstallationPath", sInstallationPath);

String sAssemblyFolder			=	"\\Utilities\\hsbFramingDefaultsEditor";
String sAssembly					=	"\\hsbFramingDefaults.Inventory.dll";
String sAssemblyPath 			=	sInstallationPath+sAssemblyFolder+sAssembly;
String sNameSpace				=	"hsbSoft.FramingDefaults.Inventory.Interfaces";
String sClass						=	"InventoryAccessInTSL";
String sClassName				=	sNameSpace+"."+sClass;
String sFunction					=	"GetLumberItems";

mapOut = callDotNetFunction2(sAssemblyPath, sClassName, sFunction, mapIn);

// filling lumber items
for( int m=0; m<mapOut.length(); m++)
{
	String sKey= mapOut.keyAt(m);
	String sName= mapOut.getString(sKey+"\NAME");
	if( sKey!="" && sName!="")
	{
		sLumberItemKeys.append( sKey );
		sLumberItemNames.append( sName);
	}
}

String sTab="     ";
// OPM 
PropString sEmpty0(0,"","General");
sEmpty0.setReadOnly(1);

	String sEdgeFlat[]={T("|Edge|"), T("|Flat|")};
	PropString sAlign(1, sEdgeFlat, sTab+T("|Orientation|"), 0);
	int nEdgeFlat= sEdgeFlat.find( sAlign, 0);
	
	String sNoYes[]={T("|No|"), T("|Yes|")};
	PropString sDuplicate(2, sNoYes, sTab+T("|Double framing (both sides of wall)|"), 0);
	int nDuplicate= sNoYes.find( sDuplicate, 0);

	String sCenterEdge[]={T("|Center of block|"), T("|Edge of block|")};
	PropString sMeasureTo(3, sCenterEdge, sTab+T("|Measure to|"), 1);
	int nCenterEdge= sCenterEdge.find( sMeasureTo, 0);
	
PropString sEmpty1(4,"", "Non-fixed blocking");
sEmpty1.setReadOnly(1);

	PropDouble dNonFixedDistance(0, U(610,24), sTab+T("|Spacing|"));

	String sDistributions[]={T("|Bottom of wall|"), T("|Top of wall|"), T("|Middle of wall|"), T("|Bottom fixed blocking location|")};
	PropString sDistribution(5, sDistributions, sTab+T("|Distribution starting point|"), 0);
	int nDistribution=sDistributions.find(sDistribution,0);
	
PropString sEmpty3(6, " ", T("|Fixed blocking|"));
sEmpty3.setReadOnly(true);

	String sNoneSingleMultipleFixed[]={T("|None|"), T("|Single|"), T("|Multiple|")};
	PropString sFixed(7, sNoneSingleMultipleFixed, sTab+T("|Fixed blocking type|"));
	int nNoneSingleMultipleFixed= sNoneSingleMultipleFixed.find( sFixed, 0);
	
	PropDouble dFixedDistance(1, U(1220,48), sTab+T("|Spacing| "));

	PropDouble dFirstFixed(2, U(1220,48), sTab+T("|Height of bottom fixed blocking|"));

	String sSingleDouble[]={T("|Single|"), T("|Double|")};
	PropString sSingleDoubleBlocking(8, sSingleDouble, sTab+T("|Fixed blocking quantity|"));
	int nSingleDouble= sSingleDouble.find( sSingleDoubleBlocking, 0);

PropString sEmpty4(9, " ", T("|Blocking info|"));
sEmpty4.setReadOnly(true);

	PropString sEmpty5(10, " ", sTab+T("|Auto|"));
	sEmpty5.setReadOnly(true);
	
		PropString sBlockLumberItem(11, sLumberItemNames, sTab+sTab+T("|Lumber item|"),0);

	PropString sEmpty6(11, "If no value is set, values are taken from inventory (one or many). ", sTab+T("|Manual| "));
	sEmpty6.setReadOnly(true);

		double dReal[0];// Real sizes
		String sNominal[0];// Nominal sizes
		dReal.append(U(19.05,0.75));		sNominal.append("1");		//index:	0
		dReal.append(U(38.10,1.50));		sNominal.append("2");		//index:	1
		dReal.append(U(63.50,2.50));		sNominal.append("3");		//index:	2
		dReal.append(U(88.90,3.50));		sNominal.append("4");		//index:	3
		dReal.append(U(139.70,5.50));	sNominal.append("6");		//index:	4
		dReal.append(U(184.15,7.25));	sNominal.append("8");		//index:	5
		dReal.append(U(234.95,9.25));	sNominal.append("10");		//index:	6
		dReal.append(U(285.75,11.25));	sNominal.append("12");		//index:	7
		dReal.append(U(336.55,13.25));	sNominal.append("14");		//index:	8
		dReal.append(U(387.35,15.25));	sNominal.append("16");		//index:	9
		
		//Filling nominal sizes
		String sarBmS[0];//Nominals FOR 2" WIDTH ONLY 
		for(int i=0;i<sNominal.length();i++){
			sarBmS.append("2x"+sNominal[i]);
		}
		sarBmS.append(T("|From inventory|"));

		PropString sBlockSizeOPM(12, sarBmS, sTab+sTab+T("|Beam size|"), sarBmS.length()-1);
		PropInt nBlockColorOPM(0, 2, sTab+sTab+T("|Beam color|"));
		PropString sBlockNameOPM(13, "", sTab+sTab+T("|Name|"));
		PropString sBlockMaterialOPM(14, "", sTab+sTab+T("|Material|"));
		PropString sBlockGradeOPM(15, "", sTab+sTab+T("|Grade|"));
		PropString sBlockInformationOPM(16, "", sTab+sTab+T("|Information|"));
		PropString sBlockLabelOPM(17, "", sTab+sTab+T("|Label|"));
		PropString sBlockSubLabelOPM(18, "", sTab+sTab+T("|Sublabel|"));
		PropString sBlockSubLabel2OPM(19, "", sTab+sTab+T("|Sublabel2|"));
		PropString sBlockBeamCodeOPM(20, "", sTab+sTab+T("|Beam code|"));

if(_bOnInsert){
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}

	_Element.append(getElement(T("Select an element")));
	_Pt0 = getPoint(T("|Select an insertion point|")+" ("+T("|It defines where to place ladder along wall and icon/non icon side of wall|")+")");
	
	if (_kExecuteKey=="")
		showDialogOnce();
		
	_Map.setInt("ExecutionMode",0);

      setCatalogFromPropValues(T("_LastInserted"));

	// Add values to map, so they can be used by construction plugin 
}

if(_Element.length()==0){
	eraseInstance(); 
	return;
}

if(_bOnElementDeleted)eraseInstance();

Element el = _Element0;
ElementWallSF elW=(ElementWallSF)el;
if(!elW.bIsValid())eraseInstance();
CoordSys csEl = el.coordSys();
Point3d ptOrg=csEl.ptOrg();
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();

Wall w=(Wall)el;
if(!w.bIsValid()){
	eraseInstance();
	return;
}

// Getting values from selected item lumber for blocking
int nBlockIndex=sLumberItemNames.find(sBlockLumberItem,-1);

// Setting props
// Get props from inventory
String sBlockMaterialFromInventory, sBlockGradeFromInventory;
double dBlockWFromInventory, dBlockHFromInventory;
for( int m=0; m<mapOut.length(); m++)
{
	String sSelectedKey= sLumberItemKeys[nBlockIndex];
	String sKey= mapOut.keyAt(m);
	if( sKey==sSelectedKey)
	{
		dBlockWFromInventory= mapOut.getDouble(sKey+"\WIDTH");
		dBlockHFromInventory= mapOut.getDouble(sKey+"\HEIGHT");
		sBlockMaterialFromInventory= mapOut.getString(sKey+"\HSB_MATERIAL"); // Specie
		sBlockGradeFromInventory= mapOut.getString(sKey+"\HSB_GRADE");
		break;
	}
}

int nBlockColor=nBlockColorOPM;
String sBlockMaterial, sBlockGrade;
double dBlockW, dBlockH;
int nSizeIndex=sarBmS.find(sBlockSizeOPM);
if(nSizeIndex==sarBmS.length()-1) // Last value on sarBmS (From inventory)
{
	sBlockMaterial=sBlockMaterialFromInventory;
	sBlockGrade=sBlockGradeFromInventory;
	dBlockW=dBlockWFromInventory;
	dBlockH=dBlockHFromInventory;
}
else
{
	sBlockMaterial=sBlockMaterialOPM;
	sBlockGrade=sBlockGradeOPM;
	dBlockW=U(38.1, 1.5);
	dBlockH=dReal[nSizeIndex];
}	

String sBlockName=sBlockNameOPM;
int BlockType=_kBlocking;
String sBlockInformation=sBlockInformationOPM;
String sBlockLabel=sBlockLabelOPM;
String sBlockSubLabel=sBlockSubLabelOPM;
String sBlockSubLabel2=sBlockSubLabel2OPM;
String sBlockBeamCode=sBlockBeamCodeOPM;

// Override values if _Map is passed with these
if(_Map.hasInt("Orientation"))
{
	nEdgeFlat=_Map.getInt("Orientation");
}
if(_Map.hasInt("DoubleFraming"))
{
	nDuplicate=_Map.getInt("DoubleFraming");
}
if(_Map.hasDouble("Spacing"))
{
	dNonFixedDistance.set(_Map.getDouble("Spacing"));
}
if(_Map.hasInt("DstrbStartPt"))
{
	nDistribution=_Map.getInt("DstrbStartPt");
}
if(_Map.hasInt("FixedBlkType"))
{
	nNoneSingleMultipleFixed=_Map.getInt("FixedBlkType");
}
if(_Map.hasDouble("FixedBlkSpacing"))
{
	dFixedDistance.set(_Map.getDouble("FixedBlkSpacing"));
}
if(_Map.hasDouble("HgtOfBotFixedBlk"))
{
	dFirstFixed.set(_Map.getDouble("HgtOfBotFixedBlk"));
}
if(_Map.hasInt("FixedBlkQty"))
{
	nSingleDouble=_Map.getInt("FixedBlkQty");
}
if(_Map.hasString("Material"))
{
	sBlockMaterial=_Map.getString("Material");
}
if(_Map.hasString("Grade"))
{
	sBlockGrade=_Map.getString("Grade");
}
if(_Map.hasString("Information"))
{
	sBlockInformation=_Map.getString("Information");
}
if(_Map.hasDouble("Width"))
{
	dBlockW=_Map.getDouble("Width");
}
if(_Map.hasDouble("Height"))
{
	dBlockH=_Map.getDouble("Height");
}
if(_Map.hasInt("Color"))
{
	nBlockColor=_Map.getInt("Color");
}
if (nBlockColor > 255 || nBlockColor < -1) 
	nBlockColor=-1;
	
if( dBlockW==0 || dBlockH==0)
{
	reportError("\nData incomplete, check values on inventory for selected lumber item"+
		"\nName: "+sBlockName+"\nMaterial: "+sBlockMaterial+"\nGrade: "+ sBlockGrade+"\nWidth: "+ dBlockW+"\nHeight: "+ dBlockH);
	eraseInstance();
	return;
}

//Relocate _Pt0
int nFrontBack;

_Pt0=_Pt0.projectPoint(Plane(el.ptOrg(),el.vecY()),0);

if(el.vecZ().dotProduct(_Pt0 - (el.ptOrg()-el.vecZ()*el.dBeamWidth()/2)) >= 0) // Front of wall
{
	_Pt0=_Pt0.projectPoint(Plane(el.ptOrg(),el.vecZ()),0);
	nFrontBack=0;
}
else // Back of wall
{
	_Pt0 = _Pt0.projectPoint(Plane(el.ptOrg()-el.dBeamWidth()*el.vecZ(),el.vecZ()),0);
	nFrontBack=1;
}

Beam arBmAll[]=el.beam();
Beam arBmVertical[]=vx.filterBeamsPerpendicularSort(arBmAll);
Beam arBmHorizontal[]=vy.filterBeamsPerpendicularSort(arBmAll);

//Getting closer studs to insertion point
Beam bmLeft, bmRight;
double dDistL, dDistR;
dDistL=dDistR=U(100000);
int nOneOnZero=0;
for(int b=0;b<arBmVertical.length();b++){
	Beam bm=arBmVertical[b];
	double dDistPointToBeam=vx.dotProduct(bm.ptCen()-_Pt0);
	if(abs(dDistPointToBeam)<U(0.1))nOneOnZero=1;
	if(dDistPointToBeam<0){// Beam is at left
		if(dDistL>abs(dDistPointToBeam)){
			bmLeft=bm;
			dDistL=abs(dDistPointToBeam);
		}	
	}
	else{// Beam is at right
		if(dDistR>dDistPointToBeam){
			bmRight=bm;
			dDistR=dDistPointToBeam;
		}
	}
}

if(!bmLeft.bIsValid() || !bmRight.bIsValid()){
	reportMessage("\nTSL" + scriptName() + " cannot find a connecting stud on element " +el.number());
	eraseInstance();
	return;
}

Point3d ptMid=bmLeft.ptCen()+vx*abs(vx.dotProduct(bmRight.ptCen()-bmLeft.ptCen()))*.5;
_Pt0+=vx*vx.dotProduct(ptMid-_Pt0);

// We have left and right studs
Point3d ptBdCen= LineSeg(bmLeft.ptCen(), bmRight.ptCen()).ptMid();
Body bdEraseBlk(ptBdCen,el.vecX(),el.vecY(),el.vecZ(),abs(vx.dotProduct(bmRight.ptCen()-bmLeft.ptCen())) ,U(600),U(50),0,0,0);
Beam bmBottomPlates[0], bmTopPlates[0];
for(int b=0;b<arBmHorizontal.length();b++){

	Beam bm=arBmHorizontal[b];

	//Erase blocking pieces in the way
	if((bm.type()== _kBlocking || bm.type()==_kSFBlocking) && bm.realBody().hasIntersection(bdEraseBlk) )
	{
		bm.dbErase();
	}
	
	// Collecting top and bottom plates
	else if(bm.type()==_kSFTopPlate || bm.type()==_kTopPlate || bm.type()== _kSFVeryTopPlate)
	{		
		bmTopPlates.append(bm);
	}
	else if(bm.type()==_kSFBottomPlate)
	{
		bmBottomPlates.append(bm);
	}
}

Point3d ptBlockingOrgs[0];

// FIXED BLOCKING
// Define limits for available space
bmBottomPlates=vy.filterBeamsPerpendicularSort(bmBottomPlates);
Beam bmHighestBottom=bmBottomPlates[bmBottomPlates.length()-1];
Point3d ptMinHeight=bmHighestBottom.ptCen()+vy*bmHighestBottom.dD(vy)*.5;
ptMinHeight+=vx*vx.dotProduct(_Pt0-ptMinHeight);

bmTopPlates=vy.filterBeamsPerpendicularSort(bmTopPlates);
Beam bmLowestTop=bmTopPlates[0];
Point3d ptMaxHeight=bmLowestTop.ptCen()-vy*bmLowestTop.dD(vy)*.5;
ptMaxHeight+=vx*vx.dotProduct(_Pt0-ptMaxHeight);

// Fixed blocking
// Define vertical area needed to place
double dFixedBlockingHeightOnWall;
if( nEdgeFlat==0) // Edge
{
	dFixedBlockingHeightOnWall=dBlockW;
}
else // Flat
{
	dFixedBlockingHeightOnWall=dBlockH;
}

double dNonFixedBlockingHeightOnWall=dFixedBlockingHeightOnWall;

if( nSingleDouble==1) // Double
	dFixedBlockingHeightOnWall=dFixedBlockingHeightOnWall*2;

// Getting fixed vertical points (based on left stud)
double dHeight=0;
Point3d ptAllFixed[0];
Point3d ptFixed;
for( int i=0; dHeight<ptMaxHeight.Z(); i++)
{
	if(i==0)
	{
		ptFixed=ptMinHeight+vy*dFirstFixed;
		if( nCenterEdge==1)
			ptFixed+=vy*dFixedBlockingHeightOnWall*.5;
	}
	else
		ptFixed= ptFixed+vy*dFixedDistance;
	
		
	dHeight= ptFixed.Z();
	ptAllFixed.append( ptFixed);
}

LineSeg lsAllFixed[0];
Point3d ptLastBottomLineSeg;
Point3d ptMainFixed;
for( int p=0; p<ptAllFixed.length(); p++)
{
	Point3d ptFixed= ptAllFixed[p];
	Point3d ptTopFixed= ptFixed+vy*dFixedBlockingHeightOnWall*.5;
	Point3d ptBottomFixed= ptFixed-vy*dFixedBlockingHeightOnWall*.5;
	if( 	vy.dotProduct( ptMaxHeight- ptTopFixed) > 0 
		&& vy.dotProduct( ptBottomFixed- ptMinHeight) > 0)
	{ 		
		if( nSingleDouble==0) // Single
		{
			if(nNoneSingleMultipleFixed!=0) // Single or multiple fixed blockings
			{			
				ptBlockingOrgs.append(ptFixed);
				if( nEdgeFlat==0) // Edge
				{
					lsAllFixed.append( LineSeg(ptFixed+vy*dBlockW, ptFixed-vy*dBlockW));
				}
				else // Flat
				{
					lsAllFixed.append( LineSeg(ptFixed+vy*dBlockH, ptFixed-vy*dBlockH));
				}
			}
		}
		else // Double
		{
			if(nNoneSingleMultipleFixed!=0) // Single or multiple fixed blockings
			{			
				if( nEdgeFlat==0) // Edge
				{
					ptBlockingOrgs.append( ptFixed+vy*dBlockW*.5);
					ptBlockingOrgs.append( ptFixed-vy*dBlockW*.5);
					lsAllFixed.append( LineSeg( ptFixed+vy*dBlockW, ptFixed-vy*dBlockW));
				}
				else // Flat
				{
					ptBlockingOrgs.append( ptFixed+vy*dBlockH*.5);
					ptBlockingOrgs.append( ptFixed-vy*dBlockH*.5);
					lsAllFixed.append( LineSeg(ptFixed+vy*dBlockH, ptFixed-vy*dBlockH));
				}
			}
		}
		
		if( p==0)
			ptMainFixed=ptFixed;

		if( nNoneSingleMultipleFixed == 1) // single
			break;
	}
}

// Defining non fixed blocking
Point3d ptAllNonFixed[0];
Point3d ptStartDownToUp, ptEndDownToUp, ptStartUpToDown, ptEndUpToDown;
if(nDistribution==0) // Bottom of wall
{
	ptStartDownToUp=ptMinHeight;
	ptEndDownToUp= ptMaxHeight;
	ptStartUpToDown= ptMinHeight;
	ptEndUpToDown= ptMinHeight;
}
if(nDistribution==1) // Top of wall
{
	ptStartDownToUp=ptMinHeight;
	ptEndDownToUp= ptMinHeight;
	ptStartUpToDown= ptMaxHeight;
	ptEndUpToDown= ptMinHeight;
}
if(nDistribution==2) // Middle of wall
{
	Point3d ptStart= ptMinHeight+vy*vy.dotProduct(ptMaxHeight- ptMinHeight)*.5;
	ptStartDownToUp=ptStart;
	ptEndDownToUp= ptMaxHeight;
	ptStartUpToDown= ptStart;
	ptEndUpToDown= ptMinHeight;
}
if(nDistribution==3) // Bottom fixed blocking location
{
	Point3d ptStart= ptMainFixed;
	ptStartDownToUp=ptStart;
	ptEndDownToUp= ptMaxHeight;
	ptStartUpToDown= ptStart;
	ptEndUpToDown= ptMinHeight;
}

ptStartDownToUp+=vx*vx.dotProduct(_Pt0-ptStartDownToUp);
ptEndDownToUp+=vx*vx.dotProduct(_Pt0-ptEndDownToUp);
ptStartUpToDown+=vx*vx.dotProduct(_Pt0-ptStartUpToDown);
ptEndUpToDown+=vx*vx.dotProduct(_Pt0-ptEndUpToDown);

// From bottom to top
double dNonFixedHeight=0;
for( int i=0; dNonFixedHeight<ptEndDownToUp.Z(); i++)
{
	if( nDistribution == 1) // From top of wall
		break;
	
	Point3d ptNonFixed=ptStartDownToUp+vy*dNonFixedDistance*i;
	if( nCenterEdge==1 && nDistribution == 0) // From bottom of wall only
		ptNonFixed+=vy*dNonFixedBlockingHeightOnWall*.5;	

	if( i==0 )
	{
		if( nNoneSingleMultipleFixed == 0)  // No fixed blocking
		{
			if( nDistribution==2 || nDistribution==3  ) // Middle of wall - Bottom fixed blocking location
				ptBlockingOrgs.append( ptNonFixed); // Add always initial blocking at middle of wall or fixed blocking location
		}
	}
	else
	{  
		ptAllNonFixed.append( ptNonFixed);
		dNonFixedHeight= ptNonFixed.Z();
	}
}

// Check if will be interference with fixed blocking
for( int p=0; p<ptAllNonFixed.length(); p++)
{
	Point3d ptNonFixed= ptAllNonFixed[p];
	Point3d ptNonFixedTop= ptNonFixed+vy*dNonFixedBlockingHeightOnWall*.5;
	Point3d ptNonFixedBottom= ptNonFixed-vy*dNonFixedBlockingHeightOnWall*.5;
	if( 	vy.dotProduct( ptEndDownToUp- ptNonFixedTop) > 0 
		&& vy.dotProduct( ptNonFixedBottom- ptStartDownToUp) > 0) // There is room between 2 extrem points
	{
		int bInterference=false;
		for(int l=0; l<lsAllFixed.length(); l++)
		{
			LineSeg lsFixed= lsAllFixed[l];
			Point3d ptFixedTop= lsFixed.ptStart();
			Point3d ptFixedBottom= lsFixed.ptEnd();
			if( 	vy.dotProduct( ptFixedTop-ptNonFixedTop)>=0 && vy.dotProduct( ptNonFixedTop-ptFixedBottom)>=0 
				||
				vy.dotProduct( ptFixedTop-ptNonFixedBottom)>=0 && vy.dotProduct( ptNonFixedBottom-ptFixedBottom)>=0)
				{
					bInterference=true;
				}
		}
		if( bInterference==false)
		{
			ptBlockingOrgs.append(ptNonFixed);
		}
	}
}

// From up to down
dNonFixedHeight=U(25000,1000);
for( int i=1; dNonFixedHeight>ptEndUpToDown.Z(); i++)
{
	if( nDistribution == 0) // From bottom of wall
	break;
		
	Point3d ptNonFixed=ptStartUpToDown-vy*dNonFixedDistance*i;
	if( nCenterEdge==1 && nDistribution == 1) // From top of wall only
		ptNonFixed-=vy*dNonFixedBlockingHeightOnWall*.5;	
	
	ptAllNonFixed.append( ptNonFixed);
	dNonFixedHeight= ptNonFixed.Z();
}

for( int p=0; p<ptAllNonFixed.length(); p++)
{
	Point3d ptNonFixed= ptAllNonFixed[p];
	Point3d ptNonFixedTop= ptNonFixed+vy*dNonFixedBlockingHeightOnWall*.5;
	Point3d ptNonFixedBottom= ptNonFixed-vy*dNonFixedBlockingHeightOnWall*.5;
	if( 	vy.dotProduct( ptStartUpToDown- ptNonFixedTop) > 0 
		&& vy.dotProduct( ptNonFixedBottom- ptEndUpToDown) > 0) // There is room between 2 extrem points
	{
		int bInterference=false;
		for(int l=0; l<lsAllFixed.length(); l++)
		{
			LineSeg lsFixed= lsAllFixed[l];
			Point3d ptFixedTop= lsFixed.ptStart();
			Point3d ptFixedBottom= lsFixed.ptEnd();
			if( 	vy.dotProduct( ptFixedTop-ptNonFixedTop)>=0 && vy.dotProduct( ptNonFixedTop-ptFixedBottom)>=0 
				||
				vy.dotProduct( ptFixedTop-ptNonFixedBottom)>=0 && vy.dotProduct( ptNonFixedBottom-ptFixedBottom)>=0)
				{
					bInterference=true;
				}
			lsFixed.vis();ptFixedTop.vis();ptFixedBottom.vis();
			LineSeg(ptNonFixedBottom,ptNonFixedTop).vis();
		}
		if( bInterference==false)
		{
			ptBlockingOrgs.append(ptNonFixed);
		}
	}
}

// Create blocking
Beam bmAllCreatedBlocking[0];
for( int p=0; p<ptBlockingOrgs.length(); p++)
{
	Point3d ptBlockOrg= ptBlockingOrgs[p];
	// Relocate points

	// Align to selected face of wall
	Point3d ptFront= ptOrg;
	Point3d ptBack= ptOrg-vz*el.dBeamWidth();
	if( nFrontBack == 0)
		ptBlockOrg+=vz*vz.dotProduct(ptFront-ptBlockOrg);
	else
		ptBlockOrg+=vz*vz.dotProduct(ptBack-ptBlockOrg);

	// Align to blocking center line 
	double dDisplace;
	if( nEdgeFlat ==0) // Edge
	{
		dDisplace=dBlockH*.5;
	}	
	else // Flat
	{
		dDisplace=dBlockW*.5;
	}
	if( nFrontBack == 0)
		ptBlockOrg-=vz*dDisplace;
	else
		ptBlockOrg+=vz*dDisplace;
	
	// Ready to create beams
	double dBlockL=U(25, 1);
	Vector3d vBlockX=vx;
	Vector3d vBlockY, vBlockZ;

	if( nEdgeFlat ==0) // Edge
	{
		vBlockZ=vz;
		vBlockY=vBlockZ.crossProduct( vBlockX);
	}	
	else // Flat
	{
		vBlockY=vz;
		vBlockZ=vBlockX.crossProduct( vBlockY);
	}
	
	Beam bmBlock;
	bmBlock.dbCreate( ptBlockOrg, vBlockX, vBlockY, vBlockZ, dBlockL, dBlockW, dBlockH, 0, 0, 0);
	bmBlock.stretchDynamicTo(bmLeft);
	bmBlock.stretchDynamicTo(bmRight);
	bmAllCreatedBlocking.append(bmBlock);

}

// Duplicate blocking
if( nDuplicate && nEdgeFlat==1) // Duplicate and flat
{
	for( int p=0; p<ptBlockingOrgs.length(); p++)
	{
		Point3d ptBlockOrg= ptBlockingOrgs[p];
		// Relocate points
	
		// Align to selected face of wall
		Point3d ptFront= ptOrg;
		Point3d ptBack= ptOrg-vz*el.dBeamWidth();
		if( nFrontBack == 1)
			ptBlockOrg+=vz*vz.dotProduct(ptFront-ptBlockOrg);
		else
			ptBlockOrg+=vz*vz.dotProduct(ptBack-ptBlockOrg);
	
		// Align to blocking center line 
		double dDisplace;
		if( nEdgeFlat ==0) // Edge
		{
			dDisplace=dBlockH*.5;
		}	
		else // Flat
		{
			dDisplace=dBlockW*.5;
		}
		if( nFrontBack == 1)
			ptBlockOrg-=vz*dDisplace;
		else
			ptBlockOrg+=vz*dDisplace;
		
		// Ready to create beams
		double dBlockL=U(25, 1);
		Vector3d vBlockX=vx;
		Vector3d vBlockY, vBlockZ;
	
		if( nEdgeFlat ==0) // Edge
		{
			vBlockZ=vz;
			vBlockY=vBlockZ.crossProduct( vBlockX);
		}	
		else // Flat
		{
			vBlockY=vz;
			vBlockZ=vBlockX.crossProduct( vBlockY);
		}
		
		Beam bmBlock;
		bmBlock.dbCreate( ptBlockOrg, vBlockX, vBlockY, vBlockZ, dBlockL, dBlockW, dBlockH, 0, 0, 0);
		bmBlock.stretchDynamicTo(bmLeft);
		bmBlock.stretchDynamicTo(bmRight);
		bmAllCreatedBlocking.append(bmBlock);
	}
}

//set Module name
String sModuleName="LAD_BLOCKING_ID_" + "_" + _ThisInst.handle() ;

// Setting right props. for new beams and side studs
// Side studs
bmLeft.setColor(nBlockColor);
bmLeft.setInformation(sBlockInformation);
bmLeft.setModule(sModuleName);
bmRight.setColor(nBlockColor);
bmRight.setInformation(sBlockInformation);
bmRight.setModule(sModuleName);

// Blocking
for(int b=0; b<bmAllCreatedBlocking.length(); b++)
{
	Beam bmBlock=bmAllCreatedBlocking[b];
	bmBlock.assignToElementGroup( el, true, 0, 'Z');
	// Setting block props
	bmBlock.setColor(nBlockColor);
	bmBlock.setName(sBlockName);
	bmBlock.setGrade(sBlockGrade);
	bmBlock.setMaterial(sBlockMaterial);
	bmBlock.setType(BlockType);
	bmBlock.setInformation(sBlockInformation);
	bmBlock.setLabel(sBlockLabel);
	bmBlock.setSubLabel(sBlockSubLabel);
	bmBlock.setSubLabel2(sBlockSubLabel2);
	bmBlock.setBeamCode(sBlockBeamCode);	
	bmBlock.setModule(sModuleName);
}
eraseInstance();
return;
#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`$L`9`#`2(``A$!`Q$!_\0`
M'P```04!`0$!`0$```````````$"`P0%!@<("0H+_\0`M1```@$#`P($`P4%
M!`0```%]`0(#``01!1(A,4$&$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*
M%A<8&1HE)B<H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&EJ<W1U
M=G=X>7J#A(6&AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&
MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ>KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!
M`0$!`0````````$"`P0%!@<("0H+_\0`M1$``@$"!`0#!`<%!`0``0)W``$"
M`Q$$!2$Q!A)!40=A<1,B,H$(%$*1H;'!"2,S4O`58G+1"A8D-.$E\1<8&1HF
M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@H.$
MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#W^BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HKR/3[CQ%JMPT%E?7LLBKO*_:BO&0,
M\L/45I?V1XU_YZWO_@</_BZYEB&]5%G6\*HNSDCTJBO-?[(\:_\`/6]_\#A_
M\71_9'C7_GK>_P#@</\`XNG[>7\K)^KQ_G1Z517EU[:>+=/M'NKJXO8X4QN;
M[9G&3@<!L]34>GQ^*=5MVGLKJ]EC5MA;[7MYP#CEAZBE]8=[<K*^JJU^96/5
M:*\U_LCQK_SUO?\`P.'_`,71_9'C7_GK>_\`@</_`(NG[>7\K)^KQ_G1Z517
MFO\`9'C7_GK>_P#@</\`XNLW4+CQ%I5PL%[?7L4C+O"_:BW&2,\,?0TGB&M7
M%E+"J3LI(]<HKS7^R/&O_/6]_P#`X?\`Q=']D>-?^>M[_P"!P_\`BZ?MY?RL
MGZO'^='I5%>:_P!D>-?^>M[_`.!P_P#BZ/[(\:_\];W_`,#A_P#%T>WE_*P^
MKQ_G1Z517D<-QXBGU,Z=%?7K789D,?VHCE<Y&=V.QK2_LCQK_P`];W_P.'_Q
M=)8AO:+*>%2WDCTJBO-?[(\:_P#/6]_\#A_\71_9'C7_`)ZWO_@</_BZ?MY?
MRLGZO'^='I5%>:_V1XU_YZWO_@</_BZRX;S7[C53ID5_>M>!V0Q_:B/F7.1G
M..Q[TGB&MXLF5*G&RE42OYGKU%>:_P!D>-?^>M[_`.!P_P#BZ/[(\:_\];W_
M`,#A_P#%T_;R_E97U>/\Z/2J*\U_LCQK_P`];W_P.'_Q=5[ZV\6:;9R7=W<W
ML<$>-S_;,XR0!P&SU(H==K[+!T()7<T>I45Y3IJ^*-8MFN+"[O9HE<H6^U[?
MFP#CEAZBKG]D>-?^>M[_`.!P_P#BZ%7;U46*-&$E>,TUZGI5%>:_V1XU_P">
MM[_X'#_XNC^R/&O_`#UO?_`X?_%T>WE_*Q_5X_SH]*HKR/4+CQ%I5PL%[?7L
M4C+O"_:BW&2,\,?0UI?V1XU_YZWO_@</_BZ2Q#>BBRGA4E=R1Z517FO]D>-?
M^>M[_P"!P_\`BZ/[(\:_\];W_P`#A_\`%T_;R_E9/U>/\Z/2J*\U_LCQK_SU
MO?\`P.'_`,76;-<>(H-3&G2WUZMV65!']J)Y;&!G=CN*3Q#6\64L*GM)'KE%
M>:_V1XU_YZWO_@</_BZ/[(\:_P#/6]_\#A_\73]O+^5D_5X_SH]*HKS7^R/&
MO_/6]_\``X?_`!=,GT[QC;6\D\L]ZL<:EW;[:#@`9)^]1[=_RL?U>/\`.CTV
MBO)]-;Q-J_F_8;R]E\K&_P#TLKC.<=6'H:O?V1XU_P">M[_X'#_XNDL0VKJ+
M!X9)V<D>E45YK_9'C7_GK>_^!P_^+JM:7>MVGB:SL;Z^NPXN8EDC:X+`@D'!
MP2#P:?M[;Q8?5D]I)GJ=%%%=!RA1110`4444`%%%%`'FOP]_Y#\__7JW_H25
MZ57FOP]_Y#\__7JW_H25Z57/AOX9TXO^(%%%%=!S&%XR_P"13O?^V?\`Z&M4
M/A[_`,@"?_KZ;_T%*O\`C+_D4[W_`+9_^AK5#X>_\@"?_KZ;_P!!2N=_QUZ'
M2O\`=WZG64445T',%>:_$+_D/P?]>J_^A/7I5>:_$+_D/P?]>J_^A/7/B?X9
MTX3^(>E4445T',%%%%`'FND?\E*D_P"OJX_D]>E5YKI'_)2I/^OJX_D]>E5S
MX?X7ZG3BOBCZ!11170<P5Y;HO_)4Y?\`K[N?Y/7J5>6Z+_R5.7_K[N?Y/6%;
M>/J>;C_CI?XD>I4445N>D%<]XX_Y$Z__`.V?_HQ:Z&N>\<?\B=?_`/;/_P!&
M+45/@?H88K^!/T?Y&?\`#7_D7+C_`*^V_P#0$KL:X[X:_P#(N7'_`%]M_P"@
M)78TJ/P(C`_[O#T"BBBM#J/-?B%_R'X/^O5?_0GKTJO-?B%_R'X/^O5?_0GK
MTJN>E_$F=-;^'#YA11170<P5YKJ__)2H_P#KZM_Y)7I5>:ZO_P`E*C_Z^K?^
M25SXCX5ZG3A?BEZ'I5%%%=!S!5#6_P#D`:C_`->LO_H)J_5#6_\`D`:C_P!>
MLO\`Z":F7PLJ'Q(Y/X<?\Q/_`+9?^SUW=<)\./\`F)_]LO\`V>N[K/#_`,-&
MV*_BO^N@5YKJ_P#R4J/_`*^K?^25Z57FNK_\E*C_`.OJW_DE3B/A7J/"_%+T
M/2J***Z#F"BBB@`HHHH`****`/-?A[_R'Y_^O5O_`$)*]*KS7X>_\A^?_KU;
M_P!"2O2JY\-_#.G%_P`0****Z#F,+QE_R*=[_P!L_P#T-:H?#W_D`3_]?3?^
M@I5_QE_R*=[_`-L__0UJA\/?^0!/_P!?3?\`H*5SO^.O0Z5_N[]3K****Z#F
M"O-?B%_R'X/^O5?_`$)Z]*KS7XA?\A^#_KU7_P!">N?$_P`,Z<)_$/2J***Z
M#F"BBB@#S72/^2E2?]?5Q_)Z]*KS72/^2E2?]?5Q_)Z]*KGP_P`+]3IQ7Q1]
M`HHHKH.8*\DL[ZVTWXCW%W=R>7!'=W&YMI.,[P.!SU(KUNO((M-AUCX@W5A<
M-(L4MW<;C&0&XWGC(/I7/7O>-NYY>9<UZ?+O?0[[_A./#G_01_\`($G_`,31
M_P`)QX<_Z"/_`)`D_P#B:S_^%:Z-_P`_-_\`]_$_^)H_X5KHW_/S?_\`?Q/_
M`(FG>MV17/C_`.6/X_YFA_PG'AS_`*"/_D"3_P")K&\5>*M%U+PU=VEI>^9/
M)LVIY3C.'4GDC'0&K/\`PK71O^?F_P#^_B?_`!-97B/P1INCZ!<W]O/=M+%M
MVB1U*\L!SA1ZU,W5Y7=(SKRQOLI<T8VL[_U<U?AK_P`BY<?]?;?^@)78UQWP
MU_Y%RX_Z^V_]`2NQK6C\".S`_P"[P]`HHHK0ZCS7XA?\A^#_`*]5_P#0GKTJ
MO-?B%_R'X/\`KU7_`-">O2JYZ7\29TUOX</F%%%%=!S!7FNK_P#)2H_^OJW_
M`))7I5>:ZO\`\E*C_P"OJW_DE<^(^%>ITX7XI>AZ511170<P50UO_D`:C_UZ
MR_\`H)J_5#6_^0!J/_7K+_Z":F7PLJ'Q(Y/X<?\`,3_[9?\`L]=W7"?#C_F)
M_P#;+_V>N[K/#_PT;8K^*_ZZ!7FNK_\`)2H_^OJW_DE>E5YKJ_\`R4J/_KZM
M_P"25.(^%>H\+\4O0]*HHHKH.8****`"BBB@`HHHH`\U^'O_`"'Y_P#KU;_T
M)*]*KS7X>_\`(?G_`.O5O_0DKTJN?#?PSIQ?\0****Z#F,+QE_R*=[_VS_\`
M0UJA\/?^0!/_`-?3?^@I5_QE_P`BG>_]L_\`T-:H?#W_`)`$_P#U]-_Z"E<[
M_CKT.E?[N_4ZRBBBN@Y@KS7XA?\`(?@_Z]5_]">O2J\U^(7_`"'X/^O5?_0G
MKGQ/\,Z<)_$/2J***Z#F"BBB@#S72/\`DI4G_7U<?R>O2J\UTC_DI4G_`%]7
M'\GKTJN?#_"_4Z<5\4?0****Z#F"O+=%_P"2IR_]?=S_`">O4J\MT7_DJ<O_
M`%]W/\GK"MO'U/-Q_P`=+_$CU*BBBMST@KGO''_(G7__`&S_`/1BUT-<]XX_
MY$Z__P"V?_HQ:BI\#]##%?P)^C_(S_AK_P`BY<?]?;?^@)78UQWPU_Y%RX_Z
M^V_]`2NQI4?@1&!_W>'H%%%%:'4>:_$+_D/P?]>J_P#H3UZ57FOQ"_Y#\'_7
MJO\`Z$]>E5STOXDSIK?PX?,****Z#F"O-=7_`.2E1_\`7U;_`,DKTJO-=7_Y
M*5'_`-?5O_)*Y\1\*]3IPOQ2]#TJBBBN@Y@JAK?_`"`-1_Z]9?\`T$U?JAK?
M_(`U'_KUE_\`034R^%E0^)')_#C_`)B?_;+_`-GKNZX3X<?\Q/\`[9?^SUW=
M9X?^&C;%?Q7_`%T"O-=7_P"2E1_]?5O_`"2O2J\UU?\`Y*5'_P!?5O\`R2IQ
M'PKU'A?BEZ'I5%%%=!S!1110`4444`%%%%`'FOP]_P"0_/\`]>K?^A)7I5>:
M_#W_`)#\_P#UZM_Z$E>E5SX;^&=.+_B!11170<QA>,O^13O?^V?_`*&M4/A[
M_P`@"?\`Z^F_]!2K_C+_`)%.]_[9_P#H:U0^'O\`R`)_^OIO_04KG?\`'7H=
M*_W=^IUE%%%=!S!7FOQ"_P"0_!_UZK_Z$]>E5YK\0O\`D/P?]>J_^A/7/B?X
M9TX3^(>E4445T',%%%%`'FND?\E*D_Z^KC^3UZ57FND?\E*D_P"OJX_D]>E5
MSX?X7ZG3BOBCZ!11170<P5Y;HO\`R5.7_K[N?Y/7J5>,7.FS:QXUOK"W:-99
M;N?:9"0O!8\X!]*YZ[LXM=SR\R;BZ;2N[GL]%>6_\*UUG_GYL/\`OX__`,31
M_P`*UUG_`)^;#_OX_P#\33]K/^0KZYB/^?+^_P#X!ZE7/>./^1.O_P#MG_Z,
M6N._X5KK/_/S8?\`?Q__`(FJ6J^"-2T?39K^XGM&BBQN$;L6Y('&5'K4SJ3<
M6G$SKXJO*E).DTK/K_P#KOAK_P`BY<?]?;?^@)78UQWPU_Y%RX_Z^V_]`2NQ
MK6C\".S`_P"[P]`HHHK0ZCS7XA?\A^#_`*]5_P#0GKTJO-?B%_R'X/\`KU7_
M`-">O2JYZ7\29TUOX</F%%%%=!S!7FNK_P#)2H_^OJW_`))7I5>:ZO\`\E*C
M_P"OJW_DE<^(^%>ITX7XI>AZ511170<P50UO_D`:C_UZR_\`H)J_5#6_^0!J
M/_7K+_Z":F7PLJ'Q(Y/X<?\`,3_[9?\`L]=W7"?#C_F)_P#;+_V>N[K/#_PT
M;8K^*_ZZ!7FNK_\`)2H_^OJW_DE>E5YKJ_\`R4J/_KZM_P"25.(^%>H\+\4O
M0]*HHHKH.8****`"BBB@`HHHH`\U^'O_`"'Y_P#KU;_T)*]*KS7X>_\`(?G_
M`.O5O_0DKTJN?#?PSIQ?\0****Z#F,+QE_R*=[_VS_\`0UJA\/?^0!/_`-?3
M?^@I5_QE_P`BG>_]L_\`T-:H?#W_`)`$_P#U]-_Z"E<[_CKT.E?[N_4ZRBBB
MN@Y@KS7XA?\`(?@_Z]5_]">O2J\U^(7_`"'X/^O5?_0GKGQ/\,Z<)_$/2J**
M*Z#F"BBB@#S72/\`DI4G_7U<?R>O2J\UTC_DI4G_`%]7'\GKTJN?#_"_4Z<5
M\4?0****Z#F"O+=%_P"2IR_]?=S_`">O4J\MT7_DJ<O_`%]W/\GK"MO'U/-Q
M_P`=+_$CU*BBBMST@KGO''_(G7__`&S_`/1BUT-<]XX_Y$Z__P"V?_HQ:BI\
M#]##%?P)^C_(S_AK_P`BY<?]?;?^@)78UQWPU_Y%RX_Z^V_]`2NQI4?@1&!_
MW>'H%%%%:'4>:_$+_D/P?]>J_P#H3UZ57FOQ"_Y#\'_7JO\`Z$]>E5STOXDS
MIK?PX?,****Z#F"O-=7_`.2E1_\`7U;_`,DKTJO-=7_Y*5'_`-?5O_)*Y\1\
M*]3IPOQ2]#TJBBBN@Y@JAK?_`"`-1_Z]9?\`T$U?JAK?_(`U'_KUE_\`034R
M^%E0^)')_#C_`)B?_;+_`-GKNZX3X<?\Q/\`[9?^SUW=9X?^&C;%?Q7_`%T"
MO-=7_P"2E1_]?5O_`"2O2J\UU?\`Y*5'_P!?5O\`R2IQ'PKU'A?BEZ'I5%%%
M=!S!1110`4444`%%%%`'FOP]_P"0_/\`]>K?^A)7I5>:_#W_`)#\_P#UZM_Z
M$E>E5SX;^&=.+_B!11170<QA>,O^13O?^V?_`*&M4/A[_P`@"?\`Z^F_]!2K
M_C+_`)%.]_[9_P#H:U0^'O\`R`)_^OIO_04KG?\`'7H=*_W=^IUE%%%=!S!7
MFOQ"_P"0_!_UZK_Z$]>E5YK\0O\`D/P?]>J_^A/7/B?X9TX3^(>E4445T',%
M%%%`'FND?\E*D_Z^KC^3UZ57FND?\E*D_P"OJX_D]>E5SX?X7ZG3BOBCZ!11
M170<P5Y;HO\`R5.7_K[N?Y/7J5>,7,U_;^-;Z73!(;Q;N?RQ''O;JV<+@YXS
MVKGKNSB_,\O,I<CIR?1GL]%>6_VUX[_YY7__`(`#_P"(H_MKQW_SRO\`_P``
M!_\`$4_K"[,K^TX?R2^[_@GJ5<]XX_Y$Z_\`^V?_`*,6N._MKQW_`,\K_P#\
M`!_\15+5=3\6W&FS1:G'=BS;'F&2T"+U&,MM&.<=ZF==.+5F9U\PA.E**C+5
M/I_P3KOAK_R+EQ_U]M_Z`E=C7'?#7_D7+C_K[;_T!*[&M:/P([,#_N\/0***
M*T.H\U^(7_(?@_Z]5_\`0GKTJO-?B%_R'X/^O5?_`$)Z]*KGI?Q)G36_AP^8
M4445T',%>:ZO_P`E*C_Z^K?^25Z57FNK_P#)2H_^OJW_`))7/B/A7J=.%^*7
MH>E4445T',%4-;_Y`&H_]>LO_H)J_5#6_P#D`:C_`->LO_H)J9?"RH?$CD_A
MQ_S$_P#ME_[/7=UPGPX_YB?_`&R_]GKNZSP_\-&V*_BO^N@5YKJ__)2H_P#K
MZM_Y)7I5>:ZO_P`E*C_Z^K?^25.(^%>H\+\4O0]*HHHKH.8****`"BBB@`HH
MHH`\U^'O_(?G_P"O5O\`T)*]*KS7X>_\A^?_`*]6_P#0DKTJN?#?PSIQ?\0*
M***Z#F,+QE_R*=[_`-L__0UJA\/?^0!/_P!?3?\`H*5?\9?\BG>_]L__`$-:
MH?#W_D`3_P#7TW_H*5SO^.O0Z5_N[]3K****Z#F"O-?B%_R'X/\`KU7_`-">
MO2J\U^(7_(?@_P"O5?\`T)ZY\3_#.G"?Q#TJBBBN@Y@HHHH`\UTC_DI4G_7U
M<?R>O2J\UTC_`)*5)_U]7'\GKTJN?#_"_4Z<5\4?0****Z#F"O+=%_Y*G+_U
M]W/\GKU*O+=%_P"2IR_]?=S_`">L*V\?4\W'_'2_Q(]2HHHK<](*Y[QQ_P`B
M=?\`_;/_`-&+70USWCC_`)$Z_P#^V?\`Z,6HJ?`_0PQ7\"?H_P`C/^&O_(N7
M'_7VW_H"5V-<=\-?^1<N/^OMO_0$KL:5'X$1@?\`=X>@4445H=1YK\0O^0_!
M_P!>J_\`H3UZ57FOQ"_Y#\'_`%ZK_P"A/7I5<]+^),Z:W\.'S"BBBN@Y@KS7
M5_\`DI4?_7U;_P`DKTJO-=7_`.2E1_\`7U;_`,DKGQ'PKU.G"_%+T/2J***Z
M#F"J&M_\@#4?^O67_P!!-7ZH:W_R`-1_Z]9?_034R^%E0^)')_#C_F)_]LO_
M`&>N[KA/AQ_S$_\`ME_[/7=UGA_X:-L5_%?]=`KS75_^2E1_]?5O_)*]*KS7
M5_\`DI4?_7U;_P`DJ<1\*]1X7XI>AZ511170<P4444`%%%%`!1110!YK\/?^
M0_/_`->K?^A)7I5>:_#W_D/S_P#7JW_H25Z57/AOX9TXO^(%%%%=!S&%XR_Y
M%.]_[9_^AK5#X>_\@"?_`*^F_P#04J_XR_Y%.]_[9_\`H:U0^'O_`"`)_P#K
MZ;_T%*YW_'7H=*_W=^IUE%%%=!S!7FOQ"_Y#\'_7JO\`Z$]>E5YK\0O^0_!_
MUZK_`.A/7/B?X9TX3^(>E4445T',%%%%`'FND?\`)2I/^OJX_D]>E5YKI'_)
M2I/^OJX_D]>E5SX?X7ZG3BOBCZ!11170<P5Y;HO_`"5.7_K[N?Y/7J5>)ZE;
MZE=>+=0AT=I5OVNYO*,4OEMPS$X;(QQGO7/B';E?F<.*@IUZ$&[7FE=[+5:G
MME%>,_\`"/\`Q*_Y[:E_X,Q_\<H_X1_XE?\`/;4O_!F/_CE+V\OY&?5_V/1_
MZ"8?>O\`,]FKGO''_(G7_P#VS_\`1BUYU_PC_P`2O^>VI?\`@S'_`,<JO>Z/
MXWM;1YM8EOFL%QYHEOA(O)P,KO.><=J4ZS<6N5G)C\JI0PM6:Q$':,G9/5Z/
M3<[WX:_\BY<?]?;?^@)78UQWPU_Y%RX_Z^V_]`2NQK:C\"/#P/\`N\/0****
MT.H\U^(7_(?@_P"O5?\`T)Z]*KS7XA?\A^#_`*]5_P#0GKTJN>E_$F=-;^'#
MYA11170<P5YKJ_\`R4J/_KZM_P"25Z57FNK_`/)2H_\`KZM_Y)7/B/A7J=.%
M^*7H>E4445T',%4-;_Y`&H_]>LO_`*":OU0UO_D`:C_UZR_^@FIE\+*A\2.3
M^''_`#$_^V7_`+/7=UPGPX_YB?\`VR_]GKNZSP_\-&V*_BO^N@5YKJ__`"4J
M/_KZM_Y)7I5>:ZO_`,E*C_Z^K?\`DE3B/A7J/"_%+T/2J***Z#F"BBB@`HHH
MH`****`/-?A[_P`A^?\`Z]6_]"2O2J\U^'O_`"'Y_P#KU;_T)*]*KGPW\,Z<
M7_$"BBBN@YC"\9?\BG>_]L__`$-:H?#W_D`3_P#7TW_H*5?\9?\`(IWO_;/_
M`-#6J'P]_P"0!/\`]?3?^@I7._XZ]#I7^[OU.LHHHKH.8*\U^(7_`"'X/^O5
M?_0GKTJO-?B%_P`A^#_KU7_T)ZY\3_#.G"?Q#TJBBBN@Y@HHHH`\UTC_`)*5
M)_U]7'\GKTJO-=(_Y*5)_P!?5Q_)Z]*KGP_POU.G%?%'T"BBBN@Y@KRW1?\`
MDJ<O_7W<_P`GKU*O+=%_Y*G+_P!?=S_)ZPK;Q]3S<?\`'2_Q(]2HHHK<](*Y
M[QQ_R)U__P!L_P#T8M=#7/>./^1.O_\`MG_Z,6HJ?`_0PQ7\"?H_R,_X:_\`
M(N7'_7VW_H"5V-<=\-?^1<N/^OMO_0$KL:5'X$1@?]WAZ!1116AU'FOQ"_Y#
M\'_7JO\`Z$]>E5YK\0O^0_!_UZK_`.A/7I5<]+^),Z:W\.'S"BBBN@Y@KS75
M_P#DI4?_`%]6_P#)*]*KS75_^2E1_P#7U;_R2N?$?"O4Z<+\4O0]*HHHKH.8
M*H:W_P`@#4?^O67_`-!-7ZH:W_R`-1_Z]9?_`$$U,OA94/B1R?PX_P"8G_VR
M_P#9Z[NN$^''_,3_`.V7_L]=W6>'_AHVQ7\5_P!=`KS75_\`DI4?_7U;_P`D
MKTJO-=7_`.2E1_\`7U;_`,DJ<1\*]1X7XI>AZ511170<P4444`%%%%`!1110
M!YK\/?\`D/S_`/7JW_H25Z57FOP]_P"0_/\`]>K?^A)7I5<^&_AG3B_X@444
M5T',87C+_D4[W_MG_P"AK5#X>_\`(`G_`.OIO_04J_XR_P"13O?^V?\`Z&M4
M/A[_`,@"?_KZ;_T%*YW_`!UZ'2O]W?J=911170<P5YK\0O\`D/P?]>J_^A/7
MI5>:_$+_`)#\'_7JO_H3USXG^&=.$_B'I5%%%=!S!1110!YKI'_)2I/^OJX_
MD]>E5YKI'_)2I/\`KZN/Y/7I5<^'^%^ITXKXH^@4445T',%>6Z+_`,E3E_Z^
M[G^3UZE7D$6I0Z/\0;J_N%D:**[N-PC`+<[QQDCUKGKNSBWW/,S&2C*E)[*1
MZ_17'?\`"RM&_P"?:_\`^_:?_%4?\+*T;_GVO_\`OVG_`,56GMH=SH^O8?\`
MG1V-<]XX_P"1.O\`_MG_`.C%K/\`^%E:-_S[7_\`W[3_`.*K*\1^-]-UC0+F
MPMX+M99=NTR(H7A@><,?2HG5@XM)F6(QE"5&<5)7:?Y&K\-?^1<N/^OMO_0$
MKL:X[X:_\BY<?]?;?^@)78U='X$;8'_=X>@4445H=1YK\0O^0_!_UZK_`.A/
M7I5>:_$+_D/P?]>J_P#H3UZ57/2_B3.FM_#A\PHHHKH.8*\UU?\`Y*5'_P!?
M5O\`R2O2J\UU?_DI4?\`U]6_\DKGQ'PKU.G"_%+T/2J***Z#F"J&M_\`(`U'
M_KUE_P#035^J&M_\@#4?^O67_P!!-3+X65#XD<G\./\`F)_]LO\`V>N[KA/A
MQ_S$_P#ME_[/7=UGA_X:-L5_%?\`70*\UU?_`)*5'_U]6_\`)*]*KS75_P#D
MI4?_`%]6_P#)*G$?"O4>%^*7H>E4445T',%%%%`!1110`4444`>:_#W_`)#\
M_P#UZM_Z$E>E5YK\/?\`D/S_`/7JW_H25Z57/AOX9TXO^(%%%%=!S&%XR_Y%
M.]_[9_\`H:U0^'O_`"`)_P#KZ;_T%*O^,O\`D4[W_MG_`.AK5#X>_P#(`G_Z
M^F_]!2N=_P`=>ATK_=WZG64445T',%>:_$+_`)#\'_7JO_H3UZ57FOQ"_P"0
M_!_UZK_Z$]<^)_AG3A/XAZ511170<P4444`>:Z1_R4J3_KZN/Y/7I5>:Z1_R
M4J3_`*^KC^3UZ57/A_A?J=.*^*/H%%%%=!S!7DEG8VVI?$>XM+N/S()+NXW+
MN(SC>1R.>H%>MUY;HO\`R5.7_K[N?Y/7/75W'U/-S!)SI)_S(['_`(0?PY_T
M#O\`R/)_\51_P@_AS_H'?^1Y/_BJZ&BM?9P[(Z_JM#^1?<CGO^$'\.?]`[_R
M/)_\56-XJ\*Z+IOAJ[N[2R\N>/9M?S7.,NH/!..A-=U7/>./^1.O_P#MG_Z,
M6IJ4XJ+T,<3AJ*HS:@MGT78S_AK_`,BY<?\`7VW_`*`E=C7'?#7_`)%RX_Z^
MV_\`0$KL:='X$7@?]WAZ!1116AU'FOQ"_P"0_!_UZK_Z$]>E5YK\0O\`D/P?
M]>J_^A/7I5<]+^),Z:W\.'S"BBBN@Y@KS75_^2E1_P#7U;_R2O2J\UU?_DI4
M?_7U;_R2N?$?"O4Z<+\4O0]*HHHKH.8*H:W_`,@#4?\`KUE_]!-7ZH:W_P`@
M#4?^O67_`-!-3+X65#XD<G\./^8G_P!LO_9Z[NN$^''_`#$_^V7_`+/7=UGA
M_P"&C;%?Q7_70*\UU?\`Y*5'_P!?5O\`R2O2J\UU?_DI4?\`U]6_\DJ<1\*]
M1X7XI>AZ511170<P4444`%%%%`!1110!YK\/?^0_/_UZM_Z$E>E5YK\/?^0_
M/_UZM_Z$E>E5SX;^&=.+_B!11170<QA>,O\`D4[W_MG_`.AK5#X>_P#(`G_Z
M^F_]!2K_`(R_Y%.]_P"V?_H:U0^'O_(`G_Z^F_\`04KG?\=>ATK_`'=^IUE%
M%%=!S!7FOQ"_Y#\'_7JO_H3UZ57FOQ"_Y#\'_7JO_H3USXG^&=.$_B'I5%%%
M=!S!1110!YKI'_)2I/\`KZN/Y/7I5>:Z1_R4J3_KZN/Y/7I5<^'^%^ITXKXH
M^@4445T',%>6Z+_R5.7_`*^[G^3UZE7ENB_\E3E_Z^[G^3UA6WCZGFX_XZ7^
M)'J5%%%;GI!7/>./^1.O_P#MG_Z,6NAKGO''_(G7_P#VS_\`1BU%3X'Z&&*_
M@3]'^1G_``U_Y%RX_P"OMO\`T!*[&N.^&O\`R+EQ_P!?;?\`H"5V-*C\"(P/
M^[P]`HHHK0ZCS7XA?\A^#_KU7_T)Z]*KS7XA?\A^#_KU7_T)Z]*KGI?Q)G36
M_AP^84445T',%>:ZO_R4J/\`Z^K?^25Z57FNK_\`)2H_^OJW_DE<^(^%>ITX
M7XI>AZ511170<P50UO\`Y`&H_P#7K+_Z":OU0UO_`)`&H_\`7K+_`.@FIE\+
M*A\2.3^''_,3_P"V7_L]=W7"?#C_`)B?_;+_`-GKNZSP_P##1MBOXK_KH%>:
MZO\`\E*C_P"OJW_DE>E5YKJ__)2H_P#KZM_Y)4XCX5ZCPOQ2]#TJBBBN@Y@H
MHHH`****`"BBB@#RKP=J=GI6KRSWLWE1M`4#;2W.Y3C@'T-=Q_PF6@?\_P#_
M`.09/_B:H?\`"O=)_P"?B]_[[3_XFC_A7ND_\_%[_P!]I_\`$UR0C6@K)([:
MDJ%27,VR_P#\)EH'_/\`_P#D&3_XFC_A,M`_Y_\`_P`@R?\`Q-4/^%>Z3_S\
M7O\`WVG_`,31_P`*]TG_`)^+W_OM/_B:N]?LC.V'[LK^)O$VD:AX>NK6UN_,
MF?9M7RW&<.">2,=!53P=X@TS2M(E@O;GRI&G+A?+9N-JC/`/H:T_^%>Z3_S\
M7O\`WVG_`,31_P`*]TG_`)^+W_OM/_B:CEK<_/9&BE04.2[L7_\`A,M`_P"?
M_P#\@R?_`!-'_"9:!_S_`/\`Y!D_^)JA_P`*]TG_`)^+W_OM/_B:/^%>Z3_S
M\7O_`'VG_P`35WK]D9VP_=E__A,M`_Y__P#R#)_\37#^,=3L]5U>*>RF\V-8
M`A;:5YW,<<@>HKJ?^%>Z3_S\7O\`WVG_`,31_P`*]TG_`)^+W_OM/_B:B<:T
MU9I&E.5"G+F39?\`^$RT#_G_`/\`R#)_\31_PF6@?\__`/Y!D_\`B:H?\*]T
MG_GXO?\`OM/_`(FC_A7ND_\`/Q>_]]I_\35WK]D9VP_=E_\`X3+0/^?_`/\`
M(,G_`,31_P`)EH'_`#__`/D&3_XFJ'_"O=)_Y^+W_OM/_B:/^%>Z3_S\7O\`
MWVG_`,31>OV06P_=G+:=J=G!XX?499MMH9YG$FTGA@V#C&>XKN/^$RT#_G__
M`/(,G_Q-4/\`A7ND_P#/Q>_]]I_\31_PKW2?^?B]_P"^T_\`B:B$:T%9)&E2
M5";3;9?_`.$RT#_G_P#_`"#)_P#$T?\`"9:!_P`__P#Y!D_^)JA_PKW2?^?B
M]_[[3_XFC_A7ND_\_%[_`-]I_P#$U=Z_9&=L/W9?_P"$RT#_`)__`/R#)_\`
M$UP>BW=O_P`+%:^:54M7N)W$LAVKA@^#D],Y%=;_`,*]TG_GXO?^^T_^)H_X
M5[I/_/Q>_P#?:?\`Q-3*-:33:6ASU\-AZKB^9KE=S=_MO2?^@I9?^!"?XT?V
MWI/_`$%++_P(3_&L+_A7ND_\_%[_`-]I_P#$T?\`"O=)_P"?B]_[[3_XFM.:
MKV1ORT?YF;O]MZ3_`-!2R_\``A/\:PO&.J:?=>%+V&WOK::5MFU(YE9C\ZG@
M`T?\*]TG_GXO?^^T_P#B:/\`A7ND_P#/Q>_]]I_\32E[5IJR(J4J$X.#D]5;
M8R/`^O:;I.BS6]]<F&5KAG"F-CD;5&>`?0UTW_"9:!_S_P#_`)!D_P#B:H?\
M*]TG_GXO?^^T_P#B:/\`A7ND_P#/Q>_]]I_\34Q5:*LD@HT</2IJ',W8O_\`
M"9:!_P`__P#Y!D_^)H_X3+0/^?\`_P#(,G_Q-4/^%>Z3_P`_%[_WVG_Q-'_"
MO=)_Y^+W_OM/_B:=Z_9&EL/W9RWC'4[/5=7BGLIO-C6`(6VE>=S''('J*[C_
M`(3+0/\`G_\`_(,G_P`35#_A7ND_\_%[_P!]I_\`$T?\*]TG_GXO?^^T_P#B
M:B,:T6VDM324J$HJ+;T+_P#PF6@?\_\`_P"09/\`XFC_`(3+0/\`G_\`_(,G
M_P`35#_A7ND_\_%[_P!]I_\`$T?\*]TG_GXO?^^T_P#B:N]?LC.V'[LO_P#"
M9:!_S_\`_D&3_P")KA]1U.SG\<)J,4VZT$\+F3:1PH7)QC/8UU/_``KW2?\`
MGXO?^^T_^)H_X5[I/_/Q>_\`?:?_`!-1.-::LTC2G*A!MILO_P#"9:!_S_\`
M_D&3_P")H_X3+0/^?_\`\@R?_$U0_P"%>Z3_`,_%[_WVG_Q-'_"O=)_Y^+W_
M`+[3_P")J[U^R,[8?NR__P`)EH'_`#__`/D&3_XFJ>J>+-$N=(O8(KW=))`Z
M(OE.,DJ0!TIG_"O=)_Y^+W_OM/\`XFC_`(5[I/\`S\7O_?:?_$T-UVK60TL.
MG>[,'P5K.GZ1]N^W7'E>;Y>SY&;.-V>@/J*ZW_A,M`_Y_P#_`,@R?_$U0_X5
M[I/_`#\7O_?:?_$T?\*]TG_GXO?^^T_^)J8*M"/*DBJDJ$Y<S;+_`/PF6@?\
M_P#_`.09/_B:XN[O;?4/B!!=6LGF0O=0;6P1G&P'@\]172_\*]TG_GXO?^^T
M_P#B:EM?`NF6EY!<QSW9>&19%#.N"0<C/RT2C5G9-((3H4[N+9T]%%%=1QA1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
C`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110!_]E%
`






#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="0.03937008" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Enabled the TSM to work again." />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="6/21/2022 2:39:37 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End