#Version 8
#BeginDescription
v1.4: 03.nov.2013: David Rueda (dr@hsb-cad.com)
Creates hsbBeam taking properties from Defaults Editor
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
* v1.4: 03.nov.2013: David Rueda (dr@hsb-cad.com)
	- Stickframe path added to mapIn when calling dll
* v1.3: 29.ago.2013: David Rueda (dr@hsb-cad.com)
	- Strings added to translation
* v1.2: 15.ago.2012: David Rueda (dr@hsb-cad.com)
	- Thumbnail updated
* v1.1: 25.jul.2012: David Rueda (dr@hsb-cad.com)
	- Description added
* v1.0: 24.jul.2012: David Rueda (dr@hsb-cad.com)
*	- Release
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

sLumberItemKeys.append( T("|NOT VALID KEY|"));
String sManualTxt= T("|Manual Size|");
sLumberItemNames.append(sManualTxt);

// OPM 
String sTab="     ";

PropString sEmpty0(0, " ", T("|Blocking Info|"));
sEmpty0.setReadOnly(true);

	PropString sEmpty1(1, " ", sTab+T("|Auto|"));
	sEmpty1.setReadOnly(true);

	PropString sBmLumberItem(2, sLumberItemNames, sTab+sTab+T("|Lumber Item|"),0);

	String sDescriptionManual= " "+T("|FIELD ABOVE MUST BE SET TO|")+" '"+sManualTxt+"'";
	PropString sEmpty2(3, sDescriptionManual, sTab+T("|Manual|"+" "));
	sEmpty2.setReadOnly(true);
	sEmpty2.setDescription(sDescriptionManual);
	
		PropDouble dBlockWidthOPM( 0, U( 35, 1.5), sTab+sTab+T("|Beam Width|"));	
		PropDouble dBlockHeightOPM( 1, U( 42, 3.5), sTab+sTab+T("|Beam Height|"));	

	String sDescriptionOverwrite= " "+T("|IF NOT EMPTY REPLACES PREVIOUS VALUE|");
	PropString sEmpty3(4, sDescriptionOverwrite, sTab+T("|Overwrite if not empty|"));
	sEmpty3.setDescription(sDescriptionOverwrite);
	sEmpty3.setReadOnly(true);

		String arBmTypes[0]; arBmTypes.append(_BeamTypes);
		PropString sBlockType(5, arBmTypes, sTab+sTab+T("|Beam Type|"),12);	
		int nBlockType= arBmTypes.find( sBlockType, 28);
		PropInt nBlockColorOPM(0, 32, sTab+sTab+T("|Beam Color|"));
		PropString sBlockNameOPM(6, "", sTab+sTab+T("|Name|"));
		PropString sBlockMaterialOPM(7, "", sTab+sTab+T("|Material|"));
		PropString sBlockGradeOPM(8, "", sTab+sTab+T("|Grade|"));
		PropString sBlockInformationOPM(9, "", sTab+sTab+T("|Information|"));
		PropString sBlockLabelOPM(10, "", sTab+sTab+T("|Label|"));
		PropString sBlockSubLabelOPM(11, "", sTab+sTab+T("|Sublabel|"));
		PropString sBlockSubLabel2OPM(12, "", sTab+sTab+T("|Sublabel2|"));
		PropString sBlockBeamCodeOPM(13, "", sTab+sTab+T("|Beam Code|"));

	PropString sEmpty4(1, " ", sTab+T("|Position|"));
	sEmpty4.setReadOnly(true);

	PropDouble dElevation(2, 0, sTab+sTab+T("|Offset|"));
			
if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey); 

if(_bOnInsert){
	
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	
	if (_kExecuteKey=="")
		showDialogOnce();

	Point3d pt1= getPoint("\n"+T("|Select start point|"));
	_Map.setPoint3d("ptStart", pt1);
	while (1) 
	{
		PrPoint ssP2("\nSelect next point", pt1); 
		if (ssP2.go()==_kOk) // do the actual query
		{ 
			Point3d pt2=ssP2.value(); // retrieve the selected point
			_Map.setPoint3d("ptEnd", pt2);
			break;
		}
	}
	
	_Map.setInt("ExecutionMode",0);

      setCatalogFromPropValues(T("|_LastInserted|"));

	return;
}

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
		
String sBlockName, sBlockLabel, sBlockSubLabel, sBlockSubLabel2, sBlockBeamCode;

if(sBlockNameOPM!="")
	sBlockName=sBlockNameOPM;
if(sBlockLabelOPM!="")
	sBlockLabel=sBlockLabelOPM;
if(sBlockSubLabelOPM!="")
	sBlockSubLabel=sBlockSubLabelOPM;
if(sBlockSubLabel2OPM!="")
	sBlockSubLabel2=sBlockSubLabel2OPM;
if(sBlockBeamCodeOPM!="")
	sBlockBeamCode=sBlockBeamCodeOPM;

if( dBlockWidth<=0 || dBlockHeight<=0)
{
	reportNotice("\n"+T("|Data incomplete, check values for selected lumber item|"+"\n")
		+"\n"+T("|Name|")+": "+ sBlockName
		+"\n"+T("|Material|")+": "+ sBlockMaterial
		+"\n"+T("|Grade|")+": "+ sBlockGrade
		+"\n"+T("|Width|")+": "+ dBlockWidth
		+"\n"+T("|Height|")+": "+ dBlockHeight);
	eraseInstance();
}
// Got all lumber item info needed

String sBlockInformation="";
if( sBlockInformationOPM!= "")
	sBlockInformation=sBlockInformationOPM;

String sBlockModule= scriptName()+ "_" + _ThisInst.handle() ;


if(_Map.getInt("ExecutionMode")==0 || _bOnRecalc || _bOnElementConstructed )
{	
	
	Beam bmAllCreated[0];
	
	Point3d pt1= _Map.getPoint3d("ptStart");
	pt1+=_ZE*(dElevation+dBlockHeight*.5);
	Point3d pt2= _Map.getPoint3d("ptEnd");
	pt2+=_ZE*_ZE.dotProduct(pt1-pt2);

	Vector3d vBmX= pt2-pt1; vBmX.normalize();
	Vector3d vBmZ= _ZE;
	Vector3d vBmY= vBmZ.crossProduct( vBmX);

	double dBlockLength= (pt1-pt2).length();
	Beam bm; bm.dbCreate( pt1, vBmX, vBmY, vBmZ, dBlockLength, dBlockWidth, dBlockHeight, 1, 0, 0);
	bmAllCreated.append( bm);

	//set Module name
	// Setting created beams props.
	for( int b=0; b< bmAllCreated.length(); b++)
	{
		Beam bmBlock=bmAllCreated[b];
		// Setting block props
		bmBlock.setColor(nBlockColor);
		bmBlock.setName(sBlockName);
		bmBlock.setGrade(sBlockGrade);
		bmBlock.setMaterial(sBlockMaterial);
		bmBlock.setType(nBlockType);
		bmBlock.setInformation(sBlockInformation);
		bmBlock.setLabel(sBlockLabel);
		bmBlock.setSubLabel(sBlockSubLabel);
		bmBlock.setSubLabel2(sBlockSubLabel2);
		bmBlock.setBeamCode(sBlockBeamCode);	
		bmBlock.setModule(sBlockModule);
	}
	_Map.setInt("ExecutionMode",1);
}

eraseInstance();
#End
#BeginThumbnail
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
M&BBW;3(06Y)/.`/6KE%1.M4FFI/K?YFM/#TJ;4H1LTK?+>QA7OA2SN];75TN
M;NVO!@[X'`!(&,X(/;@CH1VZUNT45,JDII*3O8J%&%-MP5KZOU,;_A&K/_A)
M?[=\V?[5_<W#9]S9TQGI[UIWELE[93VLA81SQM&Q7J`PP<?G4U%$JDY--O;8
M4:-.*DHK?5^;>YF:'H=MH%D]K:O,\;R&0F4@G)`'8#T%0Z]X:L_$7V?[7+.G
MD;MOE,!G=C.<@^@K9HJE6J*?M$]>XGAZ3I>Q<?=['&_\*UT;_GYO_P#OXG_Q
M-7?^$'TS^Q?[*\^[\C[1]IW;UW;MNW&=N,8]JZ6BM'C*[WDS".786-[06IB:
MCX6T_4])L]/G:81V@58Y$*[\!=N"2#UXSCN!1K7A;3]<CM8YVFACM05C6W*J
M`#CC!!Z;1TK;HJ%7J1::EM?\=S66%HR33BM;7^6P4445B=`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
G%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`?__9
`


#End
