#Version 8
#BeginDescription
Inserts vertical blocking (edge or flat) on selected wall defined on Defaults Editor. Cannot be inserted by user, only on framing process.
v1.4: 23.jun.2013: David Rueda (dr@hsb-cad.com)
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 5
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
* v1.4: 23.jun.2013: David Rueda (dr@hsb-cad.com)
	- Erasing code but bOnInsert, now everything will be handled by construction directive
	- Erasing OPM, change _bOnInsert to warn user cannot use this TSL manually but on Defaults Editor
* v1.3: 30.jul.2012: David Rueda (dr@hsb-cad.com)
	- Description added
	- Thumbnail added
* v1.2: 30.jul.2012: David Rueda (dr@hsb-cad.com)
	- Updated keys for reading values from _Map
* v1.1: 27.jul.2012: David Rueda (dr@hsb-cad.com)
	- Reorder distribution items in OPM dropdown to make them consistent with ladder tsl props.
	- Thumbnail added
	- Change name from GE_WALL_VERTICAL_BLOCKING to GE_WDET_VERTICAL_BLOCK
* v1.0: 27.jul.2012: David Rueda (dr@hsb-cad.com)
*	- Release
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

sLumberItemKeys.append( T("|NOT VALID KEY|"));
String sManualTxt= T("|Manual size|");
sLumberItemNames.append(sManualTxt);

// OPM 
String sTab="     ";

PropString sEmptyGeneral( 0, " ", T("|General|"));
sEmptyGeneral.setReadOnly(1);

	String sOrientations[]={T("|Edge|"), T("|Flat|")};
	PropString sOrientation( 1, sOrientations, sTab+ T("|Orientation|"), 0);
	int nEdgeFlat= sOrientations.find( sOrientation, 0);
	
	String sDistributions[]={T("|Bottom of wall|"), T("|Top of wall|"), T("|Middle of wall|"), T("|Even with top and bottom blocks|")+ " (ANZ code)"};
	PropString sDistribution( 2, sDistributions, sTab+T("|Distribution|"), 0);
	int nDistribution= sDistributions.find( sDistribution, 0);

	PropDouble dSpacing( 0, U(800, 32), sTab+T("|Spacing|")+" ("+T("|max allowed for ANZ code|"+")"));
	dSpacing.setDescription(T("|Max allowed when even with top and bottom blocks|"));
	
	PropDouble dStartOffset( 1, 0, sTab+T("|Start offset|"));

	PropDouble dEndOffset( 2, 0, sTab+T("|End offset|"));
	
	PropDouble dBlockLength( 3, U(300, 12), sTab+T("|Piece length|"));

PropString sEmptyInfo(3, " ", T("|Blocking info|"));
sEmptyInfo.setReadOnly(true);

	PropString sEmptyAuto(4, " ", sTab+T("|Auto|"));
	sEmptyAuto.setReadOnly(true);

	PropString sBmLumberItem(5, sLumberItemNames, sTab+sTab+T("|Lumber item|"),0);

	String sDescriptionManual= " "+T("|FIELD ABOVE MUST BE SET TO|")+" '"+sManualTxt+"'";
	PropString sEmptyManual(6, sDescriptionManual, sTab+T("|Manual| "));
	sEmptyManual.setReadOnly(true);
	sEmptyManual.setDescription(sDescriptionManual);
	
		PropDouble dBlockWidthOPM( 4, U( 35, 1.5), sTab+sTab+T("|Beam width|"));	
		PropDouble dBlockHeightOPM( 5, U( 42, 3.5), sTab+sTab+T("|Beam height|"));	

	String sDescriptionOverwrite= " "+T("|IF NOT EMPTY REPLACES PREVIOUS VALUE|");
	PropString sEmptyOverwrite(7, sDescriptionOverwrite, sTab+T("|Overwrite if not empty|"));
	sEmptyOverwrite.setDescription(sDescriptionOverwrite);
	sEmptyOverwrite.setReadOnly(true);

		String arBmTypes[0]; arBmTypes.append(_BeamTypes);
		PropInt nBlockColorOPM(0, 2, sTab+sTab+T("|Beam color|"));
		PropString sBlockNameOPM(8, "", sTab+sTab+T("|Name|"));
		PropString sBlockMaterialOPM(9, "", sTab+sTab+T("|Material|"));
		PropString sBlockGradeOPM(10, "", sTab+sTab+T("|Grade|"));
		PropString sBlockInformationOPM(11, "", sTab+sTab+T("|Information|"));
		PropString sBlockLabelOPM(12, "", sTab+sTab+T("|Label|"));
		PropString sBlockSubLabelOPM(13, "", sTab+sTab+T("|Sublabel|"));
		PropString sBlockSubLabel2OPM(14, "", sTab+sTab+T("|Sublabel2|"));
		PropString sBlockBeamCodeOPM(15, "", sTab+sTab+T("|Beam code|"));
 
			
if(_bOnInsert){
	reportMessage("\n"+scriptName()+" "+T("|cannot be manually inserted. It places vertical blocking on wall T connections, defined on Defaults Editor.|"));
	eraseInstance();
	return;
/*	
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
*/ 
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

Point3d ptWallInside= ptOrg-vz*el.dBeamWidth()*.5;

// Define final values
int nBlockColor;
String sBlockMaterial, sBlockGrade;
double dBlockWidth, dBlockHeight;

// Getting values from selected item lumber for SIDE POST
int nLumberItemIndex=sLumberItemNames.find(sBmLumberItem,-1);
if( nLumberItemIndex!=sLumberItemNames.length()-1) //Any lumber item was defined from inventory
{
	for( int m=0; m<mapOut.length(); m++)
	{
		String sSelectedKey= sLumberItemKeys[nLumberItemIndex];
		String sKey= mapOut.keyAt(m);
		if( sKey==sSelectedKey)
		{
			dBlockWidth= mapOut.getDouble(sKey+"\WIDTH");
			dBlockHeight= mapOut.getDouble(sKey+"\HEIGHT");
			sBlockMaterial= mapOut.getString(sKey+"\HSB_MATERIAL");
			sBlockGrade= mapOut.getString(sKey+"\HSB_GRADE");
			break;
		}
	}
}
else // None lumber item was provided, user wants to set values manually
{
	dBlockWidth= dBlockWidthOPM;
	dBlockHeight= dBlockHeightOPM;
}

// Overwrite values if set
if( sBlockMaterialOPM!="")
	sBlockMaterial=sBlockMaterialOPM;
if( sBlockGradeOPM!="")
	sBlockGrade=sBlockGradeOPM;

nBlockColor=nBlockColorOPM;
if (nBlockColor > 255 || nBlockColor < -1) 
	nBlockColor=32;
		
String sBlockName, sBlockInformation, sBlockLabel, sBlockSubLabel, sBlockSubLabel2, sBlockBeamCode, sBlockModule;

if(sBlockNameOPM!="")
	sBlockName=sBlockNameOPM;
if(sBlockInformationOPM!="")
	sBlockInformation=sBlockInformationOPM;
if(sBlockLabelOPM!="")
	sBlockLabel=sBlockLabelOPM;
if(sBlockSubLabelOPM!="")
	sBlockSubLabel=sBlockSubLabelOPM;
if(sBlockSubLabel2OPM!="")
	sBlockSubLabel2=sBlockSubLabel2OPM;
if(sBlockBeamCodeOPM!="")
	sBlockBeamCode=sBlockBeamCodeOPM;
sBlockModule= scriptName()+ "_" + _ThisInst.handle() ;

// Override values if _Map is passed with these
if(_Map.hasInt("Orientation"))
{
	nEdgeFlat=_Map.getInt("Orientation");
}

if(_Map.hasInt("DSTRBSTARTPT"))
{
	nDistribution=_Map.getInt("DSTRBSTARTPT");
}
if(_Map.hasDouble("Spacing"))
{
	dSpacing.set(_Map.getDouble("Spacing"));
}
if(_Map.hasDouble("StartOffset"))
{
	dStartOffset.set(_Map.getDouble("StartOffset"));
}
if(_Map.hasDouble("EndOffset"))
{
	dEndOffset.set(_Map.getDouble("EndOffset"));
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
	dBlockWidth=_Map.getDouble("Width");
}
if(_Map.hasDouble("Height"))
{
	dBlockHeight=_Map.getDouble("Height");
}
if(_Map.hasDouble("Length"))
{
	dBlockLength.set(_Map.getDouble("Length"));
}

if( dBlockWidth<=0 || dBlockHeight<=0)
{
	reportNotice("\n"+T("|Data incomplete, check values for selected lumber item|")
		+"\n"+T("|Name|")+": "+ sBlockName
		+"\n"+T("|Material|")+": "+ sBlockMaterial
		+"\n"+T("|Grade|")+": "+ sBlockGrade
		+"\n"+T("|Width|")+": "+ dBlockWidth
		+"\n"+T("|Height|")+": "+ dBlockHeight);
	eraseInstance();
}
// Got all lumber item info needed

//Relocate _Pt0
_Pt0=_Pt0.projectPoint(Plane(el.ptOrg(),vy),0);

if(vz.dotProduct(_Pt0 - (ptOrg-vz*el.dBeamWidth()/2)) >= 0) // Front of wall
{
	_Pt0=_Pt0.projectPoint(Plane(el.ptOrg(),vz),0);
}
else // Back of wall
{
	_Pt0 = _Pt0.projectPoint(Plane(ptOrg-el.dBeamWidth()*vz,vz),0);
}

// Define limits for available space
Beam bmAll[]=el.beam();
if( bmAll.length()==0)
{
	reportMessage("\n"+T("|Wall must be framed to insert this tsl|"));
	eraseInstance();
	return;
}

Beam bmHorizontals[]=vx.filterBeamsParallel(bmAll);
Beam bmVerticals[]=vy.filterBeamsParallel(bmAll);
Beam bmHorizontalNonPlates[0];
Beam bmBottomPlates[0], bmTopPlates[0];
for( int b=0; b<bmHorizontals.length(); b++)
{
	Beam bm=	bmHorizontals[b];
	if(bm.type()==_kSFTopPlate || bm.type()==_kTopPlate|| bm.type()==_kSFVeryTopPlate)	
	{		
		bmTopPlates.append(bm);
	}
	else if(bm.type()==_kSFBottomPlate || bm.type()==_kBottom)
	{
		bmBottomPlates.append(bm);
	}
	else
	{
		bmHorizontalNonPlates.append(bm);
	}
}

bmBottomPlates=vy.filterBeamsPerpendicularSort(bmBottomPlates);
Beam bmHighestBottom=bmBottomPlates[bmBottomPlates.length()-1];
Point3d ptMinHeight=bmHighestBottom.ptCen()+vy*bmHighestBottom.dD(vy)*.5;
ptMinHeight+=vx*vx.dotProduct(_Pt0-ptMinHeight);

bmTopPlates=vy.filterBeamsPerpendicularSort(bmTopPlates);
Beam bmLowestTop=bmTopPlates[0];
Point3d ptMaxHeight=bmLowestTop.ptCen()-vy*bmLowestTop.dD(vy)*.5;
ptMaxHeight+=vx*vx.dotProduct(_Pt0-ptMaxHeight);

Point3d ptMid= ptMinHeight+ vy*(ptMaxHeight-ptMinHeight).length()*.5;

// Values to create body to erase intersecting beams
double dBdEraseWidth, dBdEraseHeight, dBdEraseLength;
dBdEraseLength= vy.dotProduct( ptMaxHeight- ptMinHeight);
Point3d ptBottomOfBody= ptMinHeight;
ptBottomOfBody+=vz*vz.dotProduct( ptWallInside- ptBottomOfBody);
//Define body to erase intersecting beams
if( nEdgeFlat==0) // Edge
{
	dBdEraseWidth= dBlockWidth;
	dBdEraseHeight= U(1000, 40);
}
else // Flat
{
	dBdEraseWidth= dBlockHeight;
	dBdEraseHeight= U(1000, 40);
}
Body bdErase( ptBottomOfBody, vy, vx, vz, dBdEraseLength, dBdEraseWidth, dBdEraseHeight, 1,0,0);

// Assigning top and bottom offsets
ptMinHeight+=vy*dStartOffset;
ptMaxHeight-=vy*dEndOffset;

// Start distributions
Point3d ptCenters[0]; // Holds centers of beams to create
Point3d ptCen;

if( nDistribution==0) // Bottom of wall top
{
	// From bottom to top
	ptCen= ptMinHeight+vy*dBlockLength*.5;
	ptCenters.append( ptCen);
	for( int i=0; ptCen.Z()<ptMaxHeight.Z(); i++)
	{
		ptCen+=vy*(dBlockLength+dSpacing);
		ptCenters.append( ptCen);
	}
}

else if( nDistribution==1) // Top of bottom
{
	// From center to bottom
	ptCen= ptMaxHeight-vy*dBlockLength*.5;
	ptCenters.append( ptCen);
	for( int i=0; ptCen.Z()>ptMinHeight.Z(); i++)
	{
		ptCen-=vy*(dBlockLength+dSpacing);
		ptCenters.append( ptCen);
	}
}

else if( nDistribution==2) // middle wall
{
	// Center beam
	ptCenters.append( ptMid);
	
	// From center to top
	ptCen= ptMid;
	for( int i=0; ptCen.Z()<ptMaxHeight.Z(); i++)
	{
		ptCen+=vy*(dBlockLength+dSpacing);
		ptCenters.append( ptCen);
	}
	// From center to bottom
	ptCen= ptMid;
	for( int i=0; ptCen.Z()>ptMinHeight.Z(); i++)
	{
		ptCen-=vy*(dBlockLength+dSpacing);
		ptCenters.append( ptCen);
	}
}
else if( nDistribution==3) // Even between top and bottom
{
	// Create bottom blocking
	ptCen=ptMinHeight+vy*dBlockLength*.5;
	ptCenters.append( ptCen);
	Point3d ptBottomBlockCenter= ptCen;
	
	// Create top blocking
	ptCen=ptMaxHeight-vy*dBlockLength*.5;
	ptCenters.append( ptCen);
	Point3d ptTopBlockCenter= ptCen;
	
	// Relocate max points
	ptMinHeight+= vy*dBlockLength;
	ptMaxHeight-= vy*dBlockLength;
	
	// Define how many pieces fit evenly not separated more than dSpacing
	int nBlocksNeeded=0;
	double dDistanceBetweenTopAndBottomCenters= (ptBottomBlockCenter-ptTopBlockCenter).length();
	double dMinimal=dDistanceBetweenTopAndBottomCenters-dBlockLength; // From top of bottom block and bottom of top block
	double dEvenDistance= 0;
	
	for(int i=0; dMinimal>dSpacing; i++)
	{
		nBlocksNeeded++;
		dEvenDistance= dDistanceBetweenTopAndBottomCenters/(nBlocksNeeded+1);
		ptCen= ptBottomBlockCenter+vy*(dEvenDistance);									
		
		//Check that block won't intersect
		double dMinimalBetweenBlocks=U(100, 4);
		double dDistanceBetweenBlocks=(ptBottomBlockCenter-ptCen).length();
		if( dDistanceBetweenBlocks<dBlockLength) 
			break;
		Point3d ptBlockBottom= ptCen-vy*dBlockLength*.5;	
		dMinimal= (ptBlockBottom-ptMinHeight).length();
	}
	for( int b=0; b<nBlocksNeeded; b++)
	{
		ptCen= ptBottomBlockCenter+vy*(dEvenDistance)*(b+1);
		ptCenters.append( ptCen);
	}
}

// Erase all possible blocks that are outside limits
Point3d ptValidCenters[0];
if( nDistribution ==3) // Even with top and bottom blocks
{
	ptValidCenters.append( ptCenters);
}
else
{
	for (int p=0; p< ptCenters.length(); p++)
	{
		Point3d pt= ptCenters[p];
		Point3d ptTop= pt+vy*dBlockLength*.5;
		Point3d ptBottom= pt-vy*dBlockLength*.5;
		if( 
		  ptTop.Z()<=ptMaxHeight.Z()+dTolerance // Top is lower than ptMaxHeight
		&&
		  ptBottom.Z()>=ptMinHeight.Z()-dTolerance) // Top is lower than ptMaxHeight
		{
			ptValidCenters.append( pt);
		}
	}
}

// Relocate points according to side of wall and orientation
Vector3d vInside=vz;
if( vInside.dotProduct( ptWallInside-_Pt0)<0)
	vInside=-vInside; // Points to inner wall

for (int p=0; p< ptValidCenters.length(); p++)
{
	Point3d pt= ptValidCenters[p];
	// Relocate center points
	// Align to _Pt0 (face of wall)
	pt+= vz*vz.dotProduct( _Pt0-pt);
	
	Vector3d vBmX=vy;
	Vector3d vBmY;
	// Relocate by side
	if( nEdgeFlat==0) // Edge
	{
		pt+= vInside*dBlockHeight*.5;
		vBmY= vx;
		dBdEraseWidth= dBlockWidth;
		dBdEraseHeight= dBlockHeight;
	}
	else // Flat
	{
		pt+= vInside*dBlockWidth*.5;
		vBmY= vz;
		dBdEraseWidth= dBlockHeight;
		dBdEraseHeight= dBlockWidth;
	}
	Vector3d vBmZ;
	vBmZ=vBmX.crossProduct(vBmY);
	
	// Create blocking
	Beam bmBlock;
	bmBlock.dbCreate( pt, vBmX, vBmY, vBmZ, dBlockLength, dBlockWidth, dBlockHeight, 0, 0, 0);
	bmBlock.assignToElementGroup( el, true, 0, 'Z');

	// Setting block props
	bmBlock.setColor(nBlockColor);
	bmBlock.setName(sBlockName);
	bmBlock.setGrade(sBlockGrade);
	bmBlock.setMaterial(sBlockMaterial);
	bmBlock.setType( _kBlocking);
	bmBlock.setInformation(sBlockInformation);
	bmBlock.setLabel(sBlockLabel);
	bmBlock.setSubLabel(sBlockSubLabel);
	bmBlock.setSubLabel2(sBlockSubLabel2);
	bmBlock.setBeamCode(sBlockBeamCode);	
	bmBlock.setModule(sBlockModule);

	// Erase any intersecting beam (all but plates)
	for( int b=0; b< bmHorizontalNonPlates.length(); b++)
	{
		Beam bm= bmHorizontalNonPlates[b];
		Body bdBm= bm.realBody();
		if( bdBm.hasIntersection( bdErase))
			bm.dbErase();
	}
	for( int b=0; b< bmVerticals.length(); b++)
	{
		Beam bm= bmVerticals[b];
		Body bdBm= bm.realBody();
		if( bdBm.hasIntersection( bdErase))
			bm.dbErase();
	}
}

eraseInstance();




#End
#BeginThumbnail
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
DB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`/_9
`



#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="0.03937008" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Re-activated" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="6/28/2022 11:24:49 AM" />
    </lst>
  </lst>
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End