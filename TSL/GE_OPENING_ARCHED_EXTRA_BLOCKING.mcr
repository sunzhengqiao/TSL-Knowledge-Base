#Version 8
#BeginDescription
v1.4: 03.nov.2013: David Rueda (dr@hsb-cad.com)
Applies diagonal blocks tangent to round opening arcs
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
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
*
* v1.4: 03.nov.2013: David Rueda (dr@hsb-cad.com)
	- Stickframe path added to mapIn when calling dll
* v1.3: 15.ago.2012: David Rueda (dr@hsb-cad.com)
	- Thumbnail updated
* v1.2: 14.aug.2012: David Rueda (dr@hsb-cad.com)
	- Description added
	- Thumbnail added
* v1.1: 13.aug.2012: David Rueda (dr@hsb-cad.com)
	- Set type kSupportingCrossBeam to created beams
	- Module property of blocks set from opening module
	- Collecting beams of module does not depend anymore on header, any horizontal beam but plates will be taken in consideration
	- Information property of blocks will be filled only if user specifically defines it (manually)
* v1.0: 12.mar.2012: David Rueda (dr@hsb-cad.com)
	- Release
*
*/

double dTolerance= U(0.01, 0.001);
String sLumberItemKeys[0];
String sLumberItemNames[0];

// Calling dll to fill item lumber prop.
Map mapIn;
Map mapOut;

//Setting info
String sCompanyPath = _kPathHsbCompany;
mapIn.setString("CompanyPath", sCompanyPath);

String sStickFramePath= _kPathHsbWallDetail;
mapIn.setString("StickFramePath", sStickFramePath);

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

// OPM 
String sTab="     ";
PropString sEmpty0(0, " ", T("|Blocking info|"));
sEmpty0.setReadOnly(true);

	PropString sEmpty1(1, " ", sTab+T("|Auto|"));
	sEmpty1.setReadOnly(true);

	PropString sBmLumberItem(2, sLumberItemNames, sTab+sTab+T("|Lumber item|"),0);

	PropString sEmpty2(3, "|If no value is set, values are taken from inventory|", sTab+T("|Manual| "));
	sEmpty2.setReadOnly(true);
	
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
		
		PropString sBlockSizeOPM(4, sarBmS, sTab+sTab+T("|Beam size|"), sarBmS.length()-1);
		int nSizeIndex=sarBmS.find(sBlockSizeOPM);
		PropInt nBlockColorOPM(0, 2, sTab+sTab+T("|Beam color|"));
		PropString sBlockNameOPM(5, "", sTab+sTab+T("|Name|"));
		PropString sBlockMaterialOPM(6, "", sTab+sTab+T("|Material|"));
		PropString sBlockGradeOPM(7, "", sTab+sTab+T("|Grade|"));
		PropString sBlockInformationOPM(8, "", sTab+sTab+T("|Information|"));
		PropString sBlockLabelOPM(9, "", sTab+sTab+T("|Label|"));
		PropString sBlockSubLabelOPM(10, "", sTab+sTab+T("|Sublabel|"));
		PropString sBlockSubLabel2OPM(11, "", sTab+sTab+T("|Sublabel2|"));
		PropString sBlockBeamCodeOPM(12, "", sTab+sTab+T("|Beam code|"));

String sNoYes[]={T("|No|"), T("|Yes|")};
PropString sRout(14,sNoYes,"Rout opening", 1);
int bRout=sNoYes.find(sRout,0);
PropString sSquareCut(15,sNoYes,"Square cut sheathing only ", 0);
int bSquareCut=sNoYes.find(sSquareCut,0);
			
if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey); 

if(_bOnInsert){
	
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	
	_Opening.append(getOpening(T("Select opening")));
	
		// make sure 0 is a valid index in the _Opening array
	if (_Opening.length()==0) { // if no openings attached
		reportMessage("\n"+T("|Not valid opening provided|"));
		eraseInstance(); // just erase from DB
		return;
	}
	
	if (_kExecuteKey=="")
		showDialogOnce();
	
	_Map.setInt("ExecutionMode",0);
	_Map.setInt("Reframe",1);

      setCatalogFromPropValues(T("_LastInserted"));

	return;
}

if( _Opening.length()==0)
{
	reportMessage("\n"+T("|Not valid opening provided|"));
	eraseInstance();
	return;
}

OpeningSF opSf= (OpeningSF) _Opening[0];
//Opening opSf= _Opening[0];
if (!opSf.bIsValid()) { // want to keep only the OpeningSF types
	reportMessage("\n"+T("|Not valid SF opening provided|"));
	eraseInstance(); // just erase from DB
	return;
}

// Getting values from selected item lumber for SIDE POST
int nLumberItemIndex=sLumberItemNames.find(sBmLumberItem,-1);
String sBlockNameFromInventory, sBlockMaterialFromInventory, sBlockGradeFromInventory, sBlockTreatmentFromInventory;
double dBlockWFromInventory, dBlockHFromInventory;
if( nLumberItemIndex!=-1) //Any lumber item was defined from inventory
{
	for( int m=0; m<mapOut.length(); m++)
	{
		String sSelectedKey= sLumberItemKeys[nLumberItemIndex];
		String sKey= mapOut.keyAt(m);
		if( sKey==sSelectedKey)
		{
			dBlockWFromInventory= mapOut.getDouble(sKey+"\WIDTH");
			dBlockHFromInventory= mapOut.getDouble(sKey+"\HEIGHT");
			sBlockGradeFromInventory= mapOut.getString(sKey+"\HSB_GRADE");
			sBlockMaterialFromInventory= mapOut.getString(sKey+"\HSB_MATERIAL");
			break;
		}
	}
}
else // None lumber item was provided (when no use of inventory)
{
	// Check that one size is selected from list of values for manual selection instead of last one: "From inventory"
	// Code in props lines:
		// String sarBmS[0];//Nominals FOR 2" WIDTH ONLY 
		// for(int i=0;i<sNominal.length();i++)
		//	sarBmS.append("2x"+sNominal[i]);
		//
		// sarBmS.append(T("|From inventory|"));
		// PropString sBlockSizeOPM(4, sarBmS, sTab+sTab+T("|Beam size|"), sarBmS.length()-1);
		// int nSizeIndex=sarBmS.find(sBlockSizeOPM);
	
	if ( nSizeIndex == sarBmS.length()-1)
	{
		reportMessage("\n"+"\nData incomplete: There is no size set for blocking. Tsl will be erased");
		eraseInstance();
		return;
	}
}

int nBlockColor=nBlockColorOPM;
if (nBlockColor > 255 || nBlockColor < -1) 
	nBlockColor=-1;

String sBlockMaterial, sBlockGrade;
double dBlockW, dBlockH;

if(nSizeIndex==sarBmS.length()-1) // Last value on sarBmS (From inventory)
{
	sBlockMaterial=sBlockMaterialFromInventory;
	sBlockGrade=sBlockGradeFromInventory;
	if(sBlockMaterialOPM!="")
		sBlockMaterial=sBlockMaterialOPM;
	if(sBlockGradeOPM!="")
		sBlockGrade=sBlockGradeOPM;
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
String sBlockLabel=sBlockLabelOPM;
String sBlockSubLabel=sBlockSubLabelOPM;
String sBlockSubLabel2=sBlockSubLabel2OPM;
String sBlockBeamCode=sBlockBeamCodeOPM;
//set  information
String sBlockInformation;
if( sBlockInformationOPM!= "")
	sBlockInformation=sBlockInformationOPM;

if( dBlockW==0 || dBlockH==0)
{
	reportError("\n"+T("|Data incomplete, check values on inventory for selected lumber item|")
		+"\n"+T("|Name|")+": "+ sBlockName
		+"\n"+T("|Material|")+": "+ sBlockMaterial
		+"\n"+T("|Grade|")+": "+ sBlockGrade
		+"\n"+T("|Width|")+": "+ dBlockW
		+"\n"+T("|nHeight|")+": "+ dBlockH);
	eraseInstance();
	return;
}

if( _kNameLastChangedProp != "" || _Map.getInt("Reframe") || _bOnRecalc )
{
	reportMessage("\n"+ scriptName() + ": "+ T("This tsl need some info to build after insertion. Please re-frame wall to correct results"));
	_Map.setInt( "Reframe", 0);
}

// Get wall from opening
Element el= opSf.element();
CoordSys csEl= el.coordSys();
Point3d ptOrg= csEl.ptOrg();
Vector3d vx= csEl.vecX();
Vector3d vy= csEl.vecY();
Vector3d vz= csEl.vecZ();

Wall wl=(Wall)el;
if(!wl.bIsValid())
{
	eraseInstance();
	return;	
}

setDependencyOnEntity(el);
assignToElementGroup( el);
_Element.append(el);

// Keep sheeting on wall generation
for (int i= -5; i<6; i++)
{
	if( i !=0)
		el.setOpeningOverwrite((Opening)opSf, i);
}

if(_Map.getInt("ExecutionMode")==0 || _bOnRecalc || _bOnElementConstructed )
	_Beam= el.beam();

Beam bmAll[0]; bmAll.append(_Beam);
Beam bmAllVertical[]= vx.filterBeamsPerpendicular(bmAll);
Beam bmAllHorizontal[] = vy.filterBeamsPerpendicular( bmAll);

_Element.append(el); //Must be here to avoid duplications

// Get top, bottom, left and right vertex of opening (including gaps)
double dOpW= opSf.width();
double dOpH= opSf.height();
CoordSys csOp = opSf.coordSys();

Line lnX( csOp.ptOrg(), vx);
PLine plOp= opSf.plShape();

// Define cut PLine
PLine plCut= plOp;
Point3d ptVertex[]= plCut.vertexPoints(1);
int bFoundVertex= ptVertex.length();
if( bSquareCut )
{
	if( bFoundVertex==4) // Cut must be done
	{
		PLine plTmp;
		for( int p=0; p< ptVertex.length(); p++)
			{
				Point3d pt1= ptVertex[ p];
				plTmp.addVertex(pt1);
				pt1.vis();
			}
		plCut= plTmp;
		plCut.close();
	}
	else
	{
		bRout= false;
	}
}

Body bdErase;
PlaneProfile ppErase( plCut);
ppErase.shrink(U(3, 1));
PLine plRings[]= ppErase.allRings();
if( plRings.length() == 1)
{
	PLine plErase= plRings[0];
	Body bdTmp( plErase, vz*U(2500, 100), 0);
	bdErase= bdTmp;
}
else // Something wrong, rings are more than 1 or none
{
	reportError("\n"+ T("|We're sorry, something went wrong, please inform to any hsb TSL agent. Thanks|"));
	eraseInstance();
	return;
}

Point3d ptAllOp[]= plOp.vertexPoints(1);
ptAllOp= lnX.projectPoints( ptAllOp);
ptAllOp= lnX.orderPoints( ptAllOp);
Point3d pt1= ptAllOp[0];
Point3d pt2= ptAllOp[ptAllOp.length()-1];
Point3d ptMid= pt1+ vx*(abs(vx.dotProduct(pt2-pt1))*.5);

_Pt0= ptMid- vx* dOpW*.5;
Point3d ptOpOrg= _Pt0;

// Find corner points of opening
Point3d ptLeftOp=_Pt0 - vx*(opSf.dGapSide()+dTolerance);
Point3d ptRightOp= _Pt0 + vx* (dOpW+ opSf.dGapSide()+dTolerance);
Point3d ptBottomOp= _Pt0 - vy* (opSf.dGapBottom()+dTolerance);
Point3d ptTopOp= _Pt0 + vy* (dOpH+ opSf.dGapTop()+dTolerance);
Point3d ptCenOp= ptLeftOp+vx*abs(vx.dotProduct(ptRightOp-ptLeftOp))*.5+vy*abs(vy.dotProduct(ptTopOp-ptRightOp))*.5;

// Collect all beams on this opening's module
// Get any horizontal to bring module prop
String sModule;
Body bdFindAny( ptCenOp, vx, vy, vz, U(50,2), U(10000,400), U(2500,100), 0, 0, 0); 
for( int b=0; b< bmAllHorizontal.length(); b++)
{
	Beam bm= bmAllHorizontal[b];
	if( bdFindAny.hasIntersection( bm.realBody()) 
	&& bm.type() != _kBottom && bm.type() != _kSFBottomPlate  && bm.type() != _kTopPlate && bm.type() != _kSFTopPlate && bm.type() != _kSFVeryTopPlate && bm.type())
	{
		sModule= bm.module();
		break;
	}
}

// Collect all beams on this opening's module
Beam bmAllInModule[0];
for( int b=0; b< bmAll.length(); b++)
{
	Beam bm= bmAll[b];
	if( sModule == bm.module())
	{
		bmAllInModule.append(bm);
	}
}

Beam bmAllVerticalInModule[]= vx.filterBeamsPerpendicularSort( bmAllInModule);
Beam bmAllHorizontalInModule[]= vy.filterBeamsPerpendicularSort( bmAllInModule);

// Collect beams according side
//Rigth and left sides
Beam bmLeft, bmRight;
int bRightFound=0;
for( int b=0; b< bmAllVerticalInModule.length(); b++)
{
	Beam bm= bmAllVerticalInModule[b];
	if( bm.type() == _kSFSupportingBeam || bm.type() == _kKingStud)
	{
		if( vx.dotProduct( ptMid- bm.ptCen()) >0)
		{
			bmLeft= bm;
		}
		else
		{
			if( !bRightFound)
			{
				bmRight=bm;
				bRightFound= true;
			}
		}
	}
}

Beam bmTop, bmBottom;
int bTopFound= false;
for( int b=0; b< bmAllHorizontalInModule.length(); b++)
{
	Beam bm= bmAllHorizontalInModule[b];
	if( vy.dotProduct( ptMid- bm.ptCen()) > 0)
	{
		bmBottom= bm;
	}
	else
	{
		if( !bTopFound)
		{
			bmTop= bm;
			bTopFound= true;	
		}
	}
}

// Define corners
Point3d ptTopLeftOp= bmLeft.ptCen()+vx*bmLeft.dD(vx)*.5+vy*bmLeft.dL()*.5;
Point3d ptTopRightOp= bmRight.ptCen()-vx*bmRight.dD(vx)*.5+vy*bmRight.dL()*.5;
Point3d ptBottomLeftOp= bmLeft.ptCen()+vx*bmLeft.dD(vx)*.5-vy*bmLeft.dL()*.5;
Point3d ptBottomRightOp= bmRight.ptCen()-vx*bmRight.dD(vx)*.5-vy*bmRight.dL()*.5;

//Realign bottom points if there is a bottom beam
if( bmBottom.bIsValid())
{
	Point3d ptHighOnBottomBm= bmBottom.ptCen()+ vy* bmBottom.dD(vy)* .5;
	ptBottomLeftOp+= vy* vy.dotProduct( ptHighOnBottomBm- ptBottomLeftOp);
	ptBottomRightOp+= vy* vy.dotProduct( ptHighOnBottomBm- ptBottomRightOp);
}

// Top left corner
int bFrameTopLeftCorner= FALSE;
Point3d ptTopLeftTangent= plOp.closestPointTo( ptTopLeftOp);
ptTopLeftTangent+= vz* vz.dotProduct( ptTopLeftOp- ptTopLeftTangent);
// Check if there is room for framing
if( (ptTopLeftOp- ptTopLeftTangent).length() > dBlockH+ dTolerance)
{
	bFrameTopLeftCorner= TRUE;
}
	
// Top right corner
int bFrameTopRightCorner= FALSE;
Point3d ptTopRightTangent= plOp.closestPointTo( ptTopRightOp);
ptTopRightTangent+= vz* vz.dotProduct( ptTopRightOp- ptTopRightTangent);
// Check if there is room for framing
if( (ptTopRightOp- ptTopRightTangent).length() > dBlockH+ dTolerance)
{
	bFrameTopRightCorner= TRUE;
}

// Bottom left corner
int bFrameBottomLeftCorner= FALSE;
Point3d ptBottomLeftTangent= plOp.closestPointTo( ptBottomLeftOp);
ptBottomLeftTangent+= vz* vz.dotProduct( ptBottomLeftOp- ptBottomLeftTangent);
// Check if there is room for framing
if( (ptBottomLeftOp- ptBottomLeftTangent).length() > dBlockH+ dTolerance)
{
	bFrameBottomLeftCorner= TRUE;
}

// Bottom right corner
int bFrameBottomRightCorner= FALSE;
Point3d ptBottomRightTangent= plOp.closestPointTo( ptBottomRightOp);
ptBottomRightTangent+= vz* vz.dotProduct( ptBottomRightOp- ptBottomRightTangent);
// Check if there is room for framing
if( (ptBottomRightOp- ptBottomRightTangent).length() > dBlockH+ dTolerance)
{
	bFrameBottomRightCorner= TRUE;
}

Display dp(-1);
if( bRout)
	dp.color(3);
else
	dp.color(1);

if(_Map.getInt("ExecutionMode")==0 || _bOnRecalc || _bOnElementConstructed )
{	
	if(bmAll.length()==0) // Wall is not framed
	{
		dp.draw( plOp);
		return;
	}

	// Erase all angled beams in module 
	for( int b=0; b< bmAllInModule.length(); b++)
	{
		Beam bm= bmAllInModule[b];
		if( !bm.vecX().isParallelTo(vx) && !bm.vecX().isParallelTo(vy))
		{
			bm.dbErase();	
		}
	}
	
	Beam bmAllCreated[0];
	
	if (bFrameTopLeftCorner)
	{
		Vector3d vBmY( ptTopLeftOp- ptTopLeftTangent);vBmY.normalize();
		Vector3d vBmX= vBmY.rotateBy( 90, vz);vBmX.normalize();
		Vector3d vBmZ= vBmX.crossProduct( vBmY);
		Point3d ptBmCen= ptTopLeftTangent+ vBmY*dBlockW*.5;
		Beam bmTopLeft; bmTopLeft.dbCreate( ptBmCen, vBmX, vBmY, vBmZ, U(25, 1), dBlockW, dBlockH, 0, 0, 0);
		bmTopLeft.stretchStaticTo( bmTop, 1);		
		bmTopLeft.stretchStaticTo( bmLeft, 1);
		bmAllCreated.append( bmTopLeft);
	}

	if (bFrameTopRightCorner)
	{
		Vector3d vBmY( ptTopRightOp- ptTopRightTangent);vBmY.normalize();
		Vector3d vBmX= vBmY.rotateBy( 90, vz);vBmX.normalize();
		Vector3d vBmZ= vBmX.crossProduct( vBmY);
		Point3d ptBmCen= ptTopRightTangent+ vBmY*dBlockW*.5;
		Beam bmTopRight; bmTopRight.dbCreate( ptBmCen, vBmX, vBmY, vBmZ, U(25, 1), dBlockW, dBlockH, 0, 0, 0);
		bmTopRight.stretchStaticTo( bmTop, 1);		
		bmTopRight.stretchStaticTo( bmRight, 1);
		bmAllCreated.append( bmTopRight);
	}

	if (bFrameBottomLeftCorner)
	{
		Vector3d vBmY( ptBottomLeftOp- ptBottomLeftTangent);vBmY.normalize();
		Vector3d vBmX= vBmY.rotateBy( 90, vz);vBmX.normalize();
		Vector3d vBmZ= vBmX.crossProduct( vBmY);
		Point3d ptBmCen= ptBottomLeftTangent+ vBmY*dBlockW*.5;
		Beam bmBottomLeft; bmBottomLeft.dbCreate( ptBmCen, vBmX, vBmY, vBmZ, U(25, 1), dBlockW, dBlockH, 0, 0, 0);
		bmBottomLeft.stretchStaticTo( bmBottom, 1);		
		bmBottomLeft.stretchStaticTo( bmLeft, 1);
		bmAllCreated.append( bmBottomLeft);
	}

	if (bFrameBottomRightCorner)
	{
		Vector3d vBmY( ptBottomRightOp- ptBottomRightTangent);vBmY.normalize();
		Vector3d vBmX= vBmY.rotateBy( 90, vz);vBmX.normalize();
		Vector3d vBmZ= vBmX.crossProduct( vBmY);
		Point3d ptBmCen= ptBottomRightTangent+ vBmY*dBlockW*.5;
		Beam bmBottomRight; bmBottomRight.dbCreate( ptBmCen, vBmX, vBmY, vBmZ, U(25, 1), dBlockW, dBlockH, 0, 0, 0);
		bmBottomRight.stretchStaticTo( bmBottom, 1);		
		bmBottomRight.stretchStaticTo( bmRight, 1);
		bmAllCreated.append( bmBottomRight);
	}
	
	// Setting created beams props.
	for( int b=0; b< bmAllCreated.length(); b++)
	{
		Beam bmBlock=bmAllCreated[b];
		bmBlock.assignToElementGroup( el, true, 0, 'Z');
		// Setting block props
		bmBlock.setColor(nBlockColor);
		bmBlock.setName(sBlockName);
		bmBlock.setGrade(sBlockGrade);
		bmBlock.setMaterial(sBlockMaterial);
		bmBlock.setType(_kSupportingCrossBeam);
		bmBlock.setInformation(sBlockInformation);
		bmBlock.setLabel(sBlockLabel);
		bmBlock.setSubLabel(sBlockSubLabel);
		bmBlock.setSubLabel2(sBlockSubLabel2);
		bmBlock.setBeamCode(sBlockBeamCode);	
		bmBlock.setModule(sModule);
	}
	
	// Work with sheeting
	if( bRout) // Cutting
	{
		Sheet shAll[]= el.sheet();
		Sheet shObtained[0];
		for( int s=0; s< shAll.length(); s++)
		{
			Sheet sh= shAll[s];
			shObtained.append( sh.dbSplit( plCut, 0));
			shObtained.append( sh);
		}
	
		// Delete all sheets inside opening
		if( bdErase.area()>0 )
		{
			Sheet shEraseAll[0];
			for( int s=0; s< shObtained.length(); s++)
			{
				Sheet sh= shObtained[s];
				Body bdSh= sh.realBody();
				if( bdSh.hasIntersection( bdErase))
					shEraseAll.append(sh);
			}
			for( int s=0; s< shEraseAll.length(); s++)
			{
				shEraseAll[s].dbErase();
			}
		}
	}
		
	_Map.setInt("ExecutionMode",1);
}

dp.draw( plOp);
dp.draw( plCut);


#End
#BeginThumbnail
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
M?V_YXR?_`!-98B<71DD^C_(SJTING))/9FMH/_(O:9_UZ1?^@"M"N3TGQAH-
MMHUC;S7VV6*WC1U\ES@A0".%JY_PF_AW_H(?^09/_B:_+JV"Q+J2:IRW?1GV
ML*U/E7O+[SR_7O\`D8=3_P"ON7_T,UJ>'_\`CP?_`*ZG^0K'U:>.YUF^N(6W
M12W$CHV,9!8D'FK^CW]M:VCI-+M8R$@;2>,#T%?88B$GA8Q2UT/-PTHJNVWI
MJ0^(/^/]/^N0_F:RJT-8N8;J[1X7W*(P"<$<Y/K6?73ADU1BF8XAIU9-!111
M6YB%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
(0`4444`?_]E1
`


#End
