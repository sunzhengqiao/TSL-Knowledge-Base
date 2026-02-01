#Version 8
#BeginDescription
Displays element weight (calculated upon beam, sheathing and sips) in both, MODEL AND PAPER SPACE (shopdrawing). 
Displays value in red when exceeds max. weight set in prop. 
Reports a list of all beams/sheathing with issues on material or weight values definition
Exports ElemItem with information of the stickframe weight to the database
v2.1: 11.may.2013: David Rueda (dr@hsb-cad.com)
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
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

 v1.0: 21.mar.2013: David Rueda (dr@hsb-cad.com)
	- Copied from hsb_ShowElementWeight, to keep US content folder naming standards
	- Thumbnail added
 v1.7: 21.mar.2013: David Rueda (dr@hsb-cad.com)
	- Version control from 1.0 to 1.7, to keep updated with hsb_ShowElementWeight
 v1.8: 19.apr.2013: David Rueda (dr@hsb-cad.com)
	- sMode propstring set to read only after set
	- "Materials list not found" message relocated to bOnInsert
	- TSL will delete itself when materials list not found
	- Messages edited, will be displayed on command line only, and will be a resume of issues, added translator
	- Display (Kg/Lbs) on "Max weight" prop
	- Added functionality for imperial units
	- Added "Using Defaults Editor" PropString, and checks material upon this new flag
	- Description updated
 v1.9: 02.may.2013: David Rueda (dr@hsb-cad.com)
	- Brokendependency on hsb_ShowElementWeight. From now on this TSL is lonely since is not using densities anymore.
	- PropString sUsingDefaults deleted, since all is based on defaults editor in this TSL.
	- Extracted lumber items and sheathing items maps reading from _bOnInsert so user won't ahve to be aware of reinserting when changing weight values in Defaults Editor
 v2.0: 11.may.2013: David Rueda (dr@hsb-cad.com)  --------------------------------------------------------------------------------------------------------------------- NOTICE ------------------------------------------------------------------------------------------------------- 
	- From now on this TSL is independent from hsb_ShowElementWeight since we're using a diferent way to store material weights through Defaults Editor
	- Added control for lumber items based upon sizes
	- Issues report improved
 v2.1: 11.may.2013: David Rueda (dr@hsb-cad.com)
	- All strings to be translated
	- Prop. "Prefix" reeplaced by "Show Prefix" (No/Yes)(Yes default) in order to have template always translated
*/
double dTolerance=U(0.001,0.01);
int bImperial=U(0,1);
int nLunits=U(2,4);
int nPrec=U(2,3);

String sKgLbs, sMeterFoot;
if(bImperial)
{
	sKgLbs="Lbs";
	sMeterFoot="ft";
}
else
{
	sKgLbs="Kg";
	sMeterFoot="m";
}
String sNoYes[]={T("|No|"),T("|Yes|")};
String sModes[]={T("|Model|"), T("|Viewport|")};
PropString sMode (0, sModes,T("|Insert in|"));
PropString sDimStyle(1, _DimStyles, T("|Dim Style|"));
PropDouble dMaxWeight(0, U(230,500), T("|Max Weight|")+" ("+sKgLbs+")");dMaxWeight.setFormat(_kNoUnit);
PropString sShowPrefix(2,sNoYes,T("|Show Prefix|"),1);
PropString sEraseAfterInsertion(3,sNoYes,T("|Erase after insertion|"),0);
int nEraseAfterInsertion=sNoYes.find(sEraseAfterInsertion,0);
PropDouble dOffset(1,U(50,10),T("|Tag offset from element|"));

String strReportIssues=T("|Report issues|");
addRecalcTrigger(_kContext, strReportIssues);

_ThisInst.setSequenceNumber(110);

if (_bOnDbCreated || _bOnInsert) setPropValuesFromCatalog(_kExecuteKey);

if( _bOnInsert )
{
	if (insertCycleCount()>1) { eraseInstance(); return; }
	
	if (_kExecuteKey=="")
		showDialogOnce();
}

int nMode=sModes.find(sMode, -1);

if( _bOnInsert )
{
	if (nMode==0)
	{
		PrEntity ssE("\nSelect a set of elements",Element());
		if(ssE.go()){
			_Element.append(ssE.elementSet());
		}
		// declare tsl props
		TslInst tsl;
		String strScriptName=scriptName();
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		Element lstElements[0];
		Beam lstBeams[0];
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		lstPropString.append(sMode);
		lstPropString.append(sDimStyle);
		lstPropString.append(sShowPrefix);
		lstPropString.append(sEraseAfterInsertion);
		
		lstPropDouble.append(dMaxWeight);
		lstPropDouble.append(dOffset);
		
		for( int e=0; e<_Element.length(); e++ )
		{
			Element el=_Element[e];
			lstElements.setLength(0);
			lstPoints.setLength(0);
			lstElements.append(el);
			lstPoints.append(el.ptOrg()+el.vecZ()*U(100,4));
			
			TslInst tsl;
			tsl.dbCreate(strScriptName, vecUcsX,vecUcsY, lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString);
		}
		eraseInstance();
	}
	else if (nMode==1)
	{
		_Pt0=getPoint(T("|Select insertion point|"));
		_Viewport.append(getViewport(T("Select viewport")));
	}
	return;
}

Element elToWork;

if (nMode==1)
{
	if( _Viewport.length()==0 ){eraseInstance(); return;}

	Viewport vp = _Viewport[0];

	if (!vp.element().bIsValid()) return;

	CoordSys ms2ps = vp.coordSys();
	Element el = vp.element();
	if (el.bIsValid())
	{
		_Element.setLength(0);
		elToWork=el;
	}
}

if (nMode==0)
{
	if (_Element.length()<1)
	{
		eraseInstance();
		return;
	}
	elToWork=_Element[0];
}
else if (nMode==1)
{
	if (!elToWork.bIsValid())
	{
		return;
	}
}

Element el=elToWork;

if (!el.bIsValid())
{
	eraseInstance();
	return;
}

sMode.setReadOnly(true);
setMarbleDiameter(U(4,.15));
setDependencyOnEntity(el);

CoordSys csEl = el.coordSys();
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();
Point3d ptEl = csEl.ptOrg();
if (nMode==0)
	_Pt0=((ElementWall)el).ptArrow()+vz*dOffset;

//Erase any other TSL with the same name
TslInst tlsAll[]=el.tslInstAttached();
for (int i=0; i<tlsAll.length(); i++)
{
	String sName = tlsAll[i].scriptName();
	if (sName == scriptName() && tlsAll[i].handle()!= _ThisInst.handle())
	{
		tlsAll[i].dbErase();
	}
}

Vector3d vXTxt = vx;
Vector3d vYTxt = -vz;

if (nMode==1)
{
	vXTxt=_XW;
	vYTxt=_YW;
}

String sConcatSize="x";
String sConcatGrade="@";

// Calling dll to fill item lumber prop.
Map mapIn, mapLumberItems, mapSheathingItems;

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

mapLumberItems=callDotNetFunction2(sAssemblyPath, sClassName, sFunction, mapIn);

sFunction="GetSheathingItems";
mapSheathingItems=callDotNetFunction2(sAssemblyPath, sClassName, sFunction, mapIn);
	
// Filling lumber items
String sLumberItemKeys[0];
String sLumberItemNames[0];
String sLumberItemHsbGrades[0];
double dLumberItemHeights[0];
double dLumberItemWidths[0];
double dLumberItemWeightPerWeightLenghts[0];
double dLumberItemWeightLenghts[0];
for( int m=0; m<mapLumberItems.length(); m++)
{
	String sKey= mapLumberItems.keyAt(m);
	String sName= mapLumberItems.getString(sKey+"\NAME");
	if( sKey!="" && sName!="")
	{
		sLumberItemKeys.append(mapLumberItems.getDouble(sKey+"\WIDTH")+sConcatSize+mapLumberItems.getDouble(sKey+"\HEIGHT")+sConcatGrade+mapLumberItems.getString(sKey+"\HSB_GRADE"));
		sLumberItemNames.append(sName);
		sLumberItemHsbGrades.append(mapLumberItems.getString(sKey+"\HSB_GRADE"));
		dLumberItemHeights.append(mapLumberItems.getDouble(sKey+"\HEIGHT"));
		dLumberItemWidths.append(mapLumberItems.getDouble(sKey+"\WIDTH"));		
		dLumberItemWeightPerWeightLenghts.append(mapLumberItems.getDouble(sKey+"\WEIGHTPERWEIGHTLENGTH"));
		dLumberItemWeightLenghts.append( mapLumberItems.getDouble(sKey+"\WEIGHTLENGTH"));
	}
}

// Filling sheathing items
String sSheathingItemKeys[0];
String sSheathingItemNames[0];
String sSheathingItemMaterials[0];
double dSheathingItemThickness[0];
double dSheathingItemWeightPerWeightAreas[0];
double dSheathingItemWeightAreas[0];
for( int m=0; m<mapSheathingItems.length(); m++)
{
	String sKey= mapSheathingItems.keyAt(m);
	String sName= mapSheathingItems.getString(sKey+"\NAME");
	if( sKey!="" && sName!="")
	{
		sSheathingItemKeys.append(sKey);
		sSheathingItemNames.append(sName);
		sSheathingItemMaterials.append(mapSheathingItems.getString(sKey+"\MATERIAL\NAME"));
		dSheathingItemThickness.append(mapSheathingItems.getDouble(sKey+"\THICKNESS"));
		dSheathingItemWeightPerWeightAreas.append(mapSheathingItems.getDouble(sKey+"\WEIGHTPERWEIGHTAREA"));
		dSheathingItemWeightAreas.append(mapSheathingItems.getDouble(sKey+"\WEIGHTAREA"));
	}
}

double dWeight=0;
double dWeightBeams=0;

Beam bmAll[]=el.beam();
Sheet shAll[]=el.sheet();

int nEmptyGradesOnBeams; String sEmptyGradesOnBeams[0];
String sUndefinedGradesOnBeams[0];
for (int i=0; i<bmAll.length(); i++)
{
	int bReportIssue=true;
	Beam bm=bmAll[i];
	double dBmHeight, dBmWidth;
	if(bm.dH()>bm.dW())
	{
		dBmHeight=bm.dH();
		dBmWidth=bm.dW();
	}
	else
	{
		dBmHeight=bm.dW();
		dBmWidth=bm.dH();
	}
	String sBmGrade= bm.grade().trimLeft().trimRight().makeUpper();
	if(sBmGrade=="")
	{
		nEmptyGradesOnBeams++;
		sEmptyGradesOnBeams.append(bm.name("type").makeUpper()+" "+T("|whith empty GRADE value, not considered for WEIGHT calculations|")+". "+T("|Width|")+": "+ String().formatUnit(dBmWidth,nLunits,nPrec)+", "+T("|height|")+": "+String().formatUnit(dBmHeight,nLunits,nPrec)+", "+ T("|Length|")+": "+String().formatUnit(bm.dL(),nLunits,nPrec));
	}

	else
	{
		for( int m=0; m<sLumberItemKeys.length(); m++)
		{
			String sKey= mapLumberItems.keyAt(m);
			double dLumberItemHeight=dLumberItemHeights[m];
			if(abs(dLumberItemHeight-dBmHeight)<dTolerance) // Searching same height
			{
				double dLumberItemWidth=dLumberItemWidths[m];
				if(abs(dLumberItemWidth-dBmWidth)<dTolerance) // Searching same width
				{
					if(dLumberItemWeightPerWeightLenghts[m]>0) // Has a value defined
					{
						String sLumberItemGrade= mapLumberItems.getString(sKey+"\HSB_GRADE").trimLeft().trimRight().makeUpper();
						if(sLumberItemGrade==sBmGrade) // searching same grade
						{
							dWeightBeams+=((bm.dL()*dLumberItemWeightPerWeightLenghts[m])/dLumberItemWeightLenghts[m]);
							bReportIssue=false;
							break;
						}
					}
				}
			}
		}
	}
	
	if(bReportIssue) 
	{
		if(sBmGrade!="")
			sUndefinedGradesOnBeams.append(bm.name("type").makeUpper()+" "+T("|whith undefined weight value for|")+" <"+sBmGrade+"> "+T("|not considered for WEIGHT calculations|")+". "+T("|Width|")+": "+ String().formatUnit(dBmWidth,nLunits,nPrec)+", "+T("|height|")+": "+String().formatUnit(dBmHeight,nLunits,nPrec)+", "+ T("|Length|")+": "+String().formatUnit(bm.dL(),nLunits,nPrec));
	}
}


double dWeightSheets=0;
int nEmtpyMaterialsOnSheets; String sEmtpyMaterialsOnSheets[0];
String sUndefinedMaterialsOnSheets[0];
for (int i=0; i<shAll.length(); i++)
{
	Sheet sh=shAll[i];
	String sMaterial=sh.material();
	double dThickness=sh.dD(vz);
	
	// Search same material
	int bItemFound=false;
	PlaneProfile ppSh=sh.profShape();
	double dArea=ppSh.area();
	for(int m=0;m<sSheathingItemKeys.length();m++)
	{
		if(sSheathingItemMaterials[m]==sMaterial && abs(dSheathingItemThickness[m]-dThickness)<dTolerance && dSheathingItemWeightPerWeightAreas[m] >0)
		{
			dWeightSheets+=((dArea*dSheathingItemWeightPerWeightAreas[m])/dSheathingItemWeightAreas[m]);
			bItemFound=true;
			break;
		}
	}
	
	if(!bItemFound)
	{
		//String sArea=String().formatUnit(dArea/U(1000000000,1728), _kNoUnit);
		String sArea;
		sArea.format("%.2f",dArea/U(1000000000,1728));
		sArea+=" sq "+sMeterFoot;
		if(sMaterial=="")
		{
			nEmtpyMaterialsOnSheets++;
			sEmtpyMaterialsOnSheets.append(T("|SHEATHING whith empty GRADE value, not considered for WEIGHT calculations|")+". "+T("|Area|")+": "+ sArea+", "+T("|thickness|")+": "+String().formatUnit(dThickness,nLunits,nPrec));
		}
		else
		{			
			sUndefinedMaterialsOnSheets.append(T("|SHEATHING whith undefined weight value for|")+" <"+sMaterial+"> "+T("|not considered for WEIGHT calculations|")+". "+T("|Area|")+": "+ sArea+", "+T("|thickness|")+": "+String().formatUnit(dThickness,nLunits,nPrec));
		}
	}
}

dWeight=dWeightBeams+dWeightSheets; 
String sUndefinedItems[0];


String strWeight;
strWeight.format("%.2f",dWeight);
strWeight=strWeight+" "+sKgLbs;

int nColor=-1;

if (dWeight>dMaxWeight)
	nColor=1;
	
Display dp(nColor);
dp.dimStyle(sDimStyle);

String sPrefix=T("|Weight|:");

String sText=sPrefix+" "+strWeight;

Point3d ptDraw=_Pt0;
int nYTxt=1;
if(nMode==0)
{
	nYTxt=-1;	
	ptDraw+=-vx*dp.textLengthForStyle(sText,sDimStyle)*.5;
	if(!vx.isParallelTo(_YW)&&_XW.dotProduct(vx)<0)
	{
		//ptDraw+=vz*dp.textHeightForStyle(sText,sDimStyle);
		nYTxt=1;
	}	
}
dp.draw(sText, ptDraw, vXTxt, vYTxt, 1, nYTxt, _kDevice);

if (nMode==0)
{
	String sCompareKey = el.code()+" "+el.number();
	
	setCompareKey(sCompareKey);
	
	//export dxa
	Map itemMap= Map();
	itemMap.setString("DESCRIPTION", "WEIGHT");
	itemMap.setString("QUANTITY", dWeight);
	ElemItem item(1, T("PANELWEIGHT"), el.ptOrg(), el.vecZ(), itemMap);
	item.setShow(_kNo);
	el.addTool(item);
}

if (nMode==0)
{
	assignToElementGroup(el, TRUE, 0, 'E');
}

// messages
if( _bOnRecalc || nMode==1 ||_kExecuteKey==strReportIssues)
	_Map.setInt("Reported",0);

if((nEmptyGradesOnBeams>0 || nEmtpyMaterialsOnSheets>0 || sUndefinedItems.length()>0) && !_Map.getInt("Reported"))
{
	String sTab="  - ";
	String sMsg=	"\n"+T("|Message from|")+" "+ _ThisInst.scriptName()  +" TSL: "+
					"\n"+sTab+T("|Wall|")+" "+el.code()+"-"+ el.number()+"\n"+sTab+"Weight: "+strWeight+"\n";

	if(nEmptyGradesOnBeams>0)
	{
		for(int i=0;i<nEmptyGradesOnBeams;i++)
			sMsg+=sTab+T("|Found| ")+sEmptyGradesOnBeams[i]+"\n";
	}

	if(sUndefinedGradesOnBeams.length()>0)
	{
		for(int i=0;i<sUndefinedGradesOnBeams.length();i++)
			sMsg+=+sTab+T("|Found|")+" "+sUndefinedGradesOnBeams[i]+"\n";
	}
	
	if(nEmtpyMaterialsOnSheets>0)
		for(int i=0;i<nEmtpyMaterialsOnSheets;i++)
			sMsg+=sTab+T("|Found| ")+sEmtpyMaterialsOnSheets[i]+"\n";

	if(sUndefinedMaterialsOnSheets.length()>0)
	{
		for(int i=0;i<sUndefinedMaterialsOnSheets.length();i++)
			sMsg+=+sTab+T("|Found|")+" "+sUndefinedMaterialsOnSheets[i]+"\n";
	}
	
	reportMessage(sMsg);
	_Map.setInt("Reported",1);
}

nMode=sModes.find(sMode, -1);
if(nEraseAfterInsertion && nMode ==0)
	eraseInstance();

if(nMode==1) // Shop drawing
{
	sEraseAfterInsertion.set(sNoYes[0]);
	sEraseAfterInsertion.setReadOnly(true);
	dOffset.set(-1);
	dOffset.setReadOnly(true);
}

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
M"BBB@`HHHH`*:[I%&TDC*B*"S,QP`!U)-.JAK?\`R`-1_P"O67_T$TF[*XTK
MNP?VWI/_`$%++_P(3_&C^V])_P"@I9?^!"?XUYKX;\-_\)!]I_TO[/Y&W_EG
MNW;L^X]*WO\`A7'_`%%?_)?_`.RKGC5JR5U$ZI4:,'RREJ=9_;>D_P#04LO_
M``(3_&C^V])_Z"EE_P"!"?XUR?\`PKC_`*BO_DO_`/94?\*X_P"HK_Y+_P#V
M5/GK?RD\E#^?\#K/[;TG_H*67_@0G^-']MZ3_P!!2R_\"$_QKSWQ#X3_`+!L
M([K[;Y^^41[?*VXR"<YR?2I]&\%?VOI,%]_:'E>;N^3R=V,,1UW#TJ?:U>;E
MY=2_84N7FYM#N_[;TG_H*67_`($)_C1_;>D_]!2R_P#`A/\`&N3_`.%<?]17
M_P`E_P#[*C_A7'_45_\`)?\`^RJN>M_*1R4/Y_P.L_MO2?\`H*67_@0G^-']
MMZ3_`-!2R_\``A/\:Y/_`(5Q_P!17_R7_P#LJYJ[T3[+XE71_M&[=+''YNS'
MW\<XSVSZU,JM6.\2X4*4W:,CU'^V])_Z"EE_X$)_C1_;>D_]!2R_\"$_QKD_
M^%<?]17_`,E__LJ/^%<?]17_`,E__LJKGK?RD<E#^?\``ZS^V])_Z"EE_P"!
M"?XT?VWI/_04LO\`P(3_`!KD_P#A7'_45_\`)?\`^RH_X5Q_U%?_`"7_`/LJ
M.>M_*')0_G_`ZS^V])_Z"EE_X$)_C1_;>D_]!2R_\"$_QKR[P]HG]O7\EK]H
M\C9$9-VS=G!`QC(]:Z7_`(5Q_P!17_R7_P#LJF-6K)742YT*4':4CK/[;TG_
M`*"EE_X$)_C1_;>D_P#04LO_``(3_&N3_P"%<?\`45_\E_\`[*C_`(5Q_P!1
M7_R7_P#LJKGK?RD<E#^?\#K/[;TG_H*67_@0G^-']MZ3_P!!2R_\"$_QKSWQ
M#X3_`+!L([K[;Y^^41[?*VXR"<YR?2I]&\%?VOI,%]_:'E>;N^3R=V,,1UW#
MTJ?:U>;EY=2_84N7FYM#N_[;TG_H*67_`($)_C1_;>D_]!2R_P#`A/\`&N3_
M`.%<?]17_P`E_P#[*C_A7'_45_\`)?\`^RJN>M_*1R4/Y_P.L_MO2?\`H*67
M_@0G^-']MZ3_`-!2R_\``A/\:Y/_`(5Q_P!17_R7_P#LJR?$/A/^P;".Z^V^
M?OE$>WRMN,@G.<GTI2J58J[B5&E1D[*7X'H7]MZ3_P!!2R_\"$_QH_MO2?\`
MH*67_@0G^-<)HW@K^U])@OO[0\KS=WR>3NQAB.NX>E7_`/A7'_45_P#)?_[*
MA5*K5U$3I44[.7X'6?VWI/\`T%++_P`"$_QH_MO2?^@I9?\`@0G^-<G_`,*X
M_P"HK_Y+_P#V5'_"N/\`J*_^2_\`]E3YZW\HN2A_/^!UG]MZ3_T%++_P(3_&
MC^V])_Z"EE_X$)_C7EUWHGV7Q*NC_:-VZ6./S=F/OXYQGMGUKI?^%<?]17_R
M7_\`LJF-6K*]H[%RH4HI-RW.L_MO2?\`H*67_@0G^-']MZ3_`-!2R_\``A/\
M:Y/_`(5Q_P!17_R7_P#LJ/\`A7'_`%%?_)?_`.RJN>M_*1R4/Y_P.L_MO2?^
M@I9?^!"?XT?VWI/_`$%++_P(3_&N3_X5Q_U%?_)?_P"RKFK31/M7B5M'^T;=
MLLD?F[,_<SSC/?'K4RJU8VO'<N-"E)-J6QZC_;>D_P#04LO_``(3_&C^V])_
MZ"EE_P"!"?XUR?\`PKC_`*BO_DO_`/94?\*X_P"HK_Y+_P#V55SUOY2.2A_/
M^!UG]MZ3_P!!2R_\"$_QH_MO2?\`H*67_@0G^-<G_P`*X_ZBO_DO_P#950UG
MP5_9&DSWW]H>;Y6WY/)VYRP'7<?6DZE5*[B-4J+=E+\#N_[;TG_H*67_`($)
M_C1_;>D_]!2R_P#`A/\`&O/?#WA/^WK"2Z^V^1LE,>WRMV<`'.<CUK6_X5Q_
MU%?_`"7_`/LJ(U*LE=1'*E1B[.7X'6?VWI/_`$%++_P(3_&I(=4T^YE6*"_M
M99&Z(DRL3WZ`UQ__``KC_J*_^2__`-E63X:MOL?CN*UW[_)EFCW8QG"L,X_"
MCVM1-*2W#V-*46XRO8]1HHHKI.0****`"BBB@`JAK?\`R`-1_P"O67_T$U?J
MAK?_`"`-1_Z]9?\`T$U,OA94/B1R?PX_YB?_`&R_]GKNZX3X<?\`,3_[9?\`
ML]=W6>'_`(:-L5_%?]=`HHHK8YSD_B%_R`(/^OI?_07J_P"#?^13LO\`MI_Z
M&U4/B%_R`(/^OI?_`$%ZO^#?^13LO^VG_H;5SK^._0Z7_NZ]3=HHHKH.8*\U
MU?\`Y*5'_P!?5O\`R2O2J\UU?_DI4?\`U]6_\DKGQ'PKU.G"_%+T/2J***Z#
MF"BBB@#S7X>_\A^?_KU;_P!"2O2J\U^'O_(?G_Z]6_\`0DKTJN?#?PSIQ?\`
M%"BBBN@YCD_B%_R`(/\`KZ7_`-!>K_@W_D4[+_MI_P"AM5#XA?\`(`@_Z^E_
M]!>K_@W_`)%.R_[:?^AM7.OX[]#I?^[KU-VBBBN@Y@KD_B%_R`(/^OI?_07K
MK*Y/XA?\@"#_`*^E_P#07K*M_#9M0_BHO^#?^13LO^VG_H;5NUA>#?\`D4[+
M_MI_Z&U;M53^!>A-7^)+U844459F>:ZO_P`E*C_Z^K?^25Z57FNK_P#)2H_^
MOJW_`))7I5<]#XI>ITXCX8>@4445T',%>:Z1_P`E*D_Z^KC^3UZ57FND?\E*
MD_Z^KC^3USU_BCZG3A_AGZ'I5%%%=!S!6%XR_P"13O?^V?\`Z&M;M87C+_D4
M[W_MG_Z&M14^!^AI2_B1]44/A[_R`)_^OIO_`$%*ZRN3^'O_`"`)_P#KZ;_T
M%*ZRIH_PT57_`(K"O-=(_P"2E2?]?5Q_)Z]*KS72/^2E2?\`7U<?R>HK_%'U
M+P_PS]#TJBBBN@Y@HHHH`****`"J&M_\@#4?^O67_P!!-7ZH:W_R`-1_Z]9?
M_034R^%E0^)')_#C_F)_]LO_`&>N[KA/AQ_S$_\`ME_[/7=UGA_X:-L5_%?]
M=`HHHK8YSD_B%_R`(/\`KZ7_`-!>K_@W_D4[+_MI_P"AM5#XA?\`(`@_Z^E_
M]!>K_@W_`)%.R_[:?^AM7.OX[]#I?^[KU-VBBBN@Y@KS75_^2E1_]?5O_)*]
M*KS75_\`DI4?_7U;_P`DKGQ'PKU.G"_%+T/2J***Z#F"BBB@#S7X>_\`(?G_
M`.O5O_0DKTJO-?A[_P`A^?\`Z]6_]"2O2JY\-_#.G%_Q0HHHKH.8Y/XA?\@"
M#_KZ7_T%ZO\`@W_D4[+_`+:?^AM5#XA?\@"#_KZ7_P!!>K_@W_D4[+_MI_Z&
MU<Z_COT.E_[NO4W:***Z#F"N3^(7_(`@_P"OI?\`T%ZZRN3^(7_(`@_Z^E_]
M!>LJW\-FU#^*B_X-_P"13LO^VG_H;5NUA>#?^13LO^VG_H;5NU5/X%Z$U?XD
MO5A1115F9YKJ_P#R4J/_`*^K?^25Z57FNK_\E*C_`.OJW_DE>E5ST/BEZG3B
M/AAZ!11170<P5YKI'_)2I/\`KZN/Y/7I5>:Z1_R4J3_KZN/Y/7/7^*/J=.'^
M&?H>E4445T',%87C+_D4[W_MG_Z&M;M87C+_`)%.]_[9_P#H:U%3X'Z&E+^)
M'U10^'O_`"`)_P#KZ;_T%*ZRN3^'O_(`G_Z^F_\`04KK*FC_``T57_BL*\UT
MC_DI4G_7U<?R>O2J\UTC_DI4G_7U<?R>HK_%'U+P_P`,_0]*HHHKH.8****`
M"BBB@`JAK?\`R`-1_P"O67_T$U?JAK?_`"`-1_Z]9?\`T$U,OA94/B1R?PX_
MYB?_`&R_]GKNZX3X<?\`,3_[9?\`L]=W6>'_`(:-L5_%?]=`HHHK8YSD_B%_
MR`(/^OI?_07J_P"#?^13LO\`MI_Z&U4/B%_R`(/^OI?_`$%ZO^#?^13LO^VG
M_H;5SK^._0Z7_NZ]3=HHHKH.8*\UU?\`Y*5'_P!?5O\`R2O2J\UU?_DI4?\`
MU]6_\DKGQ'PKU.G"_%+T/2J***Z#F"BBB@#S7X>_\A^?_KU;_P!"2O2J\U^'
MO_(?G_Z]6_\`0DKTJN?#?PSIQ?\`%"BBBN@YCD_B%_R`(/\`KZ7_`-!>K_@W
M_D4[+_MI_P"AM5#XA?\`(`@_Z^E_]!>K_@W_`)%.R_[:?^AM7.OX[]#I?^[K
MU-VBBBN@Y@KD_B%_R`(/^OI?_07KK*Y/XA?\@"#_`*^E_P#07K*M_#9M0_BH
MO^#?^13LO^VG_H;5NUA>#?\`D4[+_MI_Z&U;M53^!>A-7^)+U844459F>:ZO
M_P`E*C_Z^K?^25Z57FNK_P#)2H_^OJW_`))7I5<]#XI>ITXCX8>@4445T',%
M>:Z1_P`E*D_Z^KC^3UZ57FND?\E*D_Z^KC^3USU_BCZG3A_AGZ'I5%%%=!S!
M6%XR_P"13O?^V?\`Z&M;M87C+_D4[W_MG_Z&M14^!^AI2_B1]44/A[_R`)_^
MOIO_`$%*ZRN3^'O_`"`)_P#KZ;_T%*ZRIH_PT57_`(K"O-=(_P"2E2?]?5Q_
M)Z]*KS72/^2E2?\`7U<?R>HK_%'U+P_PS]#TJBBBN@Y@HHHH`****`"J&M_\
M@#4?^O67_P!!-7ZH:W_R`-1_Z]9?_034R^%E0^)')_#C_F)_]LO_`&>N[KA/
MAQ_S$_\`ME_[/7=UGA_X:-L5_%?]=`HHHK8YSD_B%_R`(/\`KZ7_`-!>K_@W
M_D4[+_MI_P"AM5#XA?\`(`@_Z^E_]!>K_@W_`)%.R_[:?^AM7.OX[]#I?^[K
MU-VBBBN@Y@KS75_^2E1_]?5O_)*]*KS75_\`DI4?_7U;_P`DKGQ'PKU.G"_%
M+T/2J***Z#F"BBB@#S7X>_\`(?G_`.O5O_0DKTJO-?A[_P`A^?\`Z]6_]"2O
M2JY\-_#.G%_Q0HHHKH.8Y/XA?\@"#_KZ7_T%ZO\`@W_D4[+_`+:?^AM5#XA?
M\@"#_KZ7_P!!>K_@W_D4[+_MI_Z&U<Z_COT.E_[NO4W:***Z#F"N3^(7_(`@
M_P"OI?\`T%ZZRN3^(7_(`@_Z^E_]!>LJW\-FU#^*B_X-_P"13LO^VG_H;5NU
MA>#?^13LO^VG_H;5NU5/X%Z$U?XDO5A1115F9YKJ_P#R4J/_`*^K?^25Z57F
MNK_\E*C_`.OJW_DE>E5ST/BEZG3B/AAZ!11170<P5YKI'_)2I/\`KZN/Y/7I
M5>:Z1_R4J3_KZN/Y/7/7^*/J=.'^&?H>E4445T',%87C+_D4[W_MG_Z&M;M8
M7C+_`)%.]_[9_P#H:U%3X'Z&E+^)'U10^'O_`"`)_P#KZ;_T%*ZRN3^'O_(`
MG_Z^F_\`04KK*FC_``T57_BL*\UTC_DI4G_7U<?R>O2J\UTC_DI4G_7U<?R>
MHK_%'U+P_P`,_0]*HHHKH.8****`"BBB@`JAK?\`R`-1_P"O67_T$U?JAK?_
M`"`-1_Z]9?\`T$U,OA94/B1R?PX_YB?_`&R_]GKNZX3X<?\`,3_[9?\`L]=W
M6>'_`(:-L5_%?]=`HHHK8YSD_B%_R`(/^OI?_07J_P"#?^13LO\`MI_Z&U4/
MB%_R`(/^OI?_`$%ZO^#?^13LO^VG_H;5SK^._0Z7_NZ]3=HHHKH.8*\UU?\`
MY*5'_P!?5O\`R2O2J\UU?_DI4?\`U]6_\DKGQ'PKU.G"_%+T/2J***Z#F"BB
MB@#S7X>_\A^?_KU;_P!"2O2J\U^'O_(?G_Z]6_\`0DKTJN?#?PSIQ?\`%"BB
MBN@YCD_B%_R`(/\`KZ7_`-!>K_@W_D4[+_MI_P"AM5#XA?\`(`@_Z^E_]!>K
M_@W_`)%.R_[:?^AM7.OX[]#I?^[KU-VBBBN@Y@KD_B%_R`(/^OI?_07KK*Y/
MXA?\@"#_`*^E_P#07K*M_#9M0_BHO^#?^13LO^VG_H;5NUA>#?\`D4[+_MI_
MZ&U;M53^!>A-7^)+U844459F>:ZO_P`E*C_Z^K?^25Z57FNK_P#)2H_^OJW_
M`))7I5<]#XI>ITXCX8>@4445T',%>:Z1_P`E*D_Z^KC^3UZ57FND?\E*D_Z^
MKC^3USU_BCZG3A_AGZ'I5%%%=!S!6%XR_P"13O?^V?\`Z&M;M87C+_D4[W_M
MG_Z&M14^!^AI2_B1]44/A[_R`)_^OIO_`$%*ZRN3^'O_`"`)_P#KZ;_T%*ZR
MIH_PT57_`(K"O-=(_P"2E2?]?5Q_)Z]*KS72/^2E2?\`7U<?R>HK_%'U+P_P
MS]#TJBBBN@Y@HHHH`****`"J&M_\@#4?^O67_P!!-7ZH:W_R`-1_Z]9?_034
MR^%E0^)')_#C_F)_]LO_`&>N[KA/AQ_S$_\`ME_[/7=UGA_X:-L5_%?]=`HH
MHK8YSD_B%_R`(/\`KZ7_`-!>K_@W_D4[+_MI_P"AM5#XA?\`(`@_Z^E_]!>K
M_@W_`)%.R_[:?^AM7.OX[]#I?^[KU-VBBBN@Y@KS75_^2E1_]?5O_)*]*KS7
M5_\`DI4?_7U;_P`DKGQ'PKU.G"_%+T/2J***Z#F"BBB@#S7X>_\`(?G_`.O5
MO_0DKTJO-?A[_P`A^?\`Z]6_]"2O2JY\-_#.G%_Q0HHHKH.8Y/XA?\@"#_KZ
M7_T%ZO\`@W_D4[+_`+:?^AM5#XA?\@"#_KZ7_P!!>K_@W_D4[+_MI_Z&U<Z_
MCOT.E_[NO4W:***Z#F"N3^(7_(`@_P"OI?\`T%ZZRN3^(7_(`@_Z^E_]!>LJ
MW\-FU#^*B_X-_P"13LO^VG_H;5NUA>#?^13LO^VG_H;5NU5/X%Z$U?XDO5A1
M115F9YKJ_P#R4J/_`*^K?^25Z57FNK_\E*C_`.OJW_DE>E5ST/BEZG3B/AAZ
M!11170<P5YKI'_)2I/\`KZN/Y/7I5>:Z1_R4J3_KZN/Y/7/7^*/J=.'^&?H>
ME4445T',%87C+_D4[W_MG_Z&M;M87C+_`)%.]_[9_P#H:U%3X'Z&E+^)'U10
M^'O_`"`)_P#KZ;_T%*ZRN3^'O_(`G_Z^F_\`04KK*FC_``T57_BL*\UTC_DI
M4G_7U<?R>O2J\UTC_DI4G_7U<?R>HK_%'U+P_P`,_0]*HHHKH.8****`"BBB
M@`JAK?\`R`-1_P"O67_T$U?JAK?_`"`-1_Z]9?\`T$U,OA94/B1R?PX_YB?_
M`&R_]GKNZX3X<?\`,3_[9?\`L]=W6>'_`(:-L5_%?]=`HHHK8YSD_B%_R`(/
M^OI?_07J_P"#?^13LO\`MI_Z&U4/B%_R`(/^OI?_`$%ZO^#?^13LO^VG_H;5
MSK^._0Z7_NZ]3=HHHKH.8*\UU?\`Y*5'_P!?5O\`R2O2J\UU?_DI4?\`U]6_
M\DKGQ'PKU.G"_%+T/2J***Z#F"BBB@#S7X>_\A^?_KU;_P!"2O2J\U^'O_(?
MG_Z]6_\`0DKTJN?#?PSIQ?\`%"BBBN@YCD_B%_R`(/\`KZ7_`-!>K_@W_D4[
M+_MI_P"AM5#XA?\`(`@_Z^E_]!>K_@W_`)%.R_[:?^AM7.OX[]#I?^[KU-VB
MBBN@Y@KD_B%_R`(/^OI?_07KK*Y/XA?\@"#_`*^E_P#07K*M_#9M0_BHO^#?
M^13LO^VG_H;5NUA>#?\`D4[+_MI_Z&U;M53^!>A-7^)+U844459F>:ZO_P`E
M*C_Z^K?^25Z57FNK_P#)2H_^OJW_`))7I5<]#XI>ITXCX8>@4445T',%>:Z1
M_P`E*D_Z^KC^3UZ57FND?\E*D_Z^KC^3USU_BCZG3A_AGZ'I5%%%=!S!6%XR
M_P"13O?^V?\`Z&M;M87C+_D4[W_MG_Z&M14^!^AI2_B1]44/A[_R`)_^OIO_
M`$%*ZRN3^'O_`"`)_P#KZ;_T%*ZRIH_PT57_`(K"O-=(_P"2E2?]?5Q_)Z]*
MKS72/^2E2?\`7U<?R>HK_%'U+P_PS]#TJBBBN@Y@HHHH`****`"J&M_\@#4?
M^O67_P!!-7ZH:W_R`-1_Z]9?_034R^%E0^)')_#C_F)_]LO_`&>N[KA/AQ_S
M$_\`ME_[/7=UGA_X:-L5_%?]=`HHHK8YSD_B%_R`(/\`KZ7_`-!>K_@W_D4[
M+_MI_P"AM5#XA?\`(`@_Z^E_]!>K_@W_`)%.R_[:?^AM7.OX[]#I?^[KU-VB
MBBN@Y@KS75_^2E1_]?5O_)*]*KS75_\`DI4?_7U;_P`DKGQ'PKU.G"_%+T/2
MJ***Z#F"BBB@#S7X>_\`(?G_`.O5O_0DKTJO-?A[_P`A^?\`Z]6_]"2O2JY\
M-_#.G%_Q0HHHKH.8Y/XA?\@"#_KZ7_T%ZO\`@W_D4[+_`+:?^AM5#XA?\@"#
M_KZ7_P!!>K_@W_D4[+_MI_Z&U<Z_COT.E_[NO4W:***Z#F"N3^(7_(`@_P"O
MI?\`T%ZZRN3^(7_(`@_Z^E_]!>LJW\-FU#^*B_X-_P"13LO^VG_H;5NUA>#?
M^13LO^VG_H;5NU5/X%Z$U?XDO5A1115F9YKJ_P#R4J/_`*^K?^25Z57FNK_\
ME*C_`.OJW_DE>E5ST/BEZG3B/AAZ!11170<P5YKI'_)2I/\`KZN/Y/7I5>:Z
M1_R4J3_KZN/Y/7/7^*/J=.'^&?H>E4445T',%87C+_D4[W_MG_Z&M;M87C+_
M`)%.]_[9_P#H:U%3X'Z&E+^)'U10^'O_`"`)_P#KZ;_T%*ZRN3^'O_(`G_Z^
MF_\`04KK*FC_``T57_BL*\UTC_DI4G_7U<?R>O2J\UTC_DI4G_7U<?R>HK_%
M'U+P_P`,_0]*HHHKH.8****`"BBB@`JAK?\`R`-1_P"O67_T$U?JAK?_`"`-
M1_Z]9?\`T$U,OA94/B1R?PX_YB?_`&R_]GKNZX3X<?\`,3_[9?\`L]=W6>'_
M`(:-L5_%?]=`HHHK8YSD_B%_R`(/^OI?_07J_P"#?^13LO\`MI_Z&U4/B%_R
M`(/^OI?_`$%ZO^#?^13LO^VG_H;5SK^._0Z7_NZ]3=HHHKH.8*\UU?\`Y*5'
M_P!?5O\`R2O2J\UU?_DI4?\`U]6_\DKGQ'PKU.G"_%+T/2J***Z#F"BBB@#S
M7X>_\A^?_KU;_P!"2O2J\U^'O_(?G_Z]6_\`0DKTJN?#?PSIQ?\`%"BBBN@Y
MCD_B%_R`(/\`KZ7_`-!>K_@W_D4[+_MI_P"AM5#XA?\`(`@_Z^E_]!>K_@W_
M`)%.R_[:?^AM7.OX[]#I?^[KU-VBBBN@Y@KD_B%_R`(/^OI?_07KK*Y/XA?\
M@"#_`*^E_P#07K*M_#9M0_BHO^#?^13LO^VG_H;5NUA>#?\`D4[+_MI_Z&U;
MM53^!>A-7^)+U844459F>:ZO_P`E*C_Z^K?^25Z57FNK_P#)2H_^OJW_`))7
MI5<]#XI>ITXCX8>@4445T',%>:Z1_P`E*D_Z^KC^3UZ57FND?\E*D_Z^KC^3
MUSU_BCZG3A_AGZ'I5%%%=!S!6%XR_P"13O?^V?\`Z&M;M87C+_D4[W_MG_Z&
MM14^!^AI2_B1]44/A[_R`)_^OIO_`$%*ZRN3^'O_`"`)_P#KZ;_T%*ZRIH_P
MT57_`(K"O-=(_P"2E2?]?5Q_)Z]*KS72/^2E2?\`7U<?R>HK_%'U+P_PS]#T
MJBBBN@Y@HHHH`****`"J&M_\@#4?^O67_P!!-7ZH:W_R`-1_Z]9?_034R^%E
M0^)')_#C_F)_]LO_`&>N[KA/AQ_S$_\`ME_[/7=UGA_X:-L5_%?]=`HHHK8Y
MSD_B%_R`(/\`KZ7_`-!>K_@W_D4[+_MI_P"AM5#XA?\`(`@_Z^E_]!>K_@W_
M`)%.R_[:?^AM7.OX[]#I?^[KU-VBBBN@Y@KS75_^2E1_]?5O_)*]*KS75_\`
MDI4?_7U;_P`DKGQ'PKU.G"_%+T/2J***Z#F"BBB@#S7X>_\`(?G_`.O5O_0D
MKTJO-?A[_P`A^?\`Z]6_]"2O2JY\-_#.G%_Q0HHHKH.8Y/XA?\@"#_KZ7_T%
MZO\`@W_D4[+_`+:?^AM5#XA?\@"#_KZ7_P!!>K_@W_D4[+_MI_Z&U<Z_COT.
ME_[NO4W:***Z#F"N3^(7_(`@_P"OI?\`T%ZZRN3^(7_(`@_Z^E_]!>LJW\-F
MU#^*B_X-_P"13LO^VG_H;5NUA>#?^13LO^VG_H;5NU5/X%Z$U?XDO5A1115F
M9YKJ_P#R4J/_`*^K?^25Z57FNK_\E*C_`.OJW_DE>E5ST/BEZG3B/AAZ!111
M70<P5YKI'_)2I/\`KZN/Y/7I5>:Z1_R4J3_KZN/Y/7/7^*/J=.'^&?H>E444
M5T',%87C+_D4[W_MG_Z&M;M87C+_`)%.]_[9_P#H:U%3X'Z&E+^)'U10^'O_
M`"`)_P#KZ;_T%*ZRN3^'O_(`G_Z^F_\`04KK*FC_``T57_BL*\UTC_DI4G_7
MU<?R>O2J\UTC_DI4G_7U<?R>HK_%'U+P_P`,_0]*HHHKH.8****`"BBB@`JA
MK?\`R`-1_P"O67_T$U?JAK?_`"`-1_Z]9?\`T$U,OA94/B1R?PX_YB?_`&R_
M]GKNZX3X<?\`,3_[9?\`L]=W6>'_`(:-L5_%?]=`HHHK8YSD_B%_R`(/^OI?
M_07J_P"#?^13LO\`MI_Z&U4/B%_R`(/^OI?_`$%ZO^#?^13LO^VG_H;5SK^.
M_0Z7_NZ]3=HHHKH.8*\UU?\`Y*5'_P!?5O\`R2O2J\UU?_DI4?\`U]6_\DKG
MQ'PKU.G"_%+T/2J***Z#F"BBB@#S7X>_\A^?_KU;_P!"2O2J\U^'O_(?G_Z]
M6_\`0DKTJN?#?PSIQ?\`%"BBBN@YCD_B%_R`(/\`KZ7_`-!>K_@W_D4[+_MI
M_P"AM5#XA?\`(`@_Z^E_]!>K_@W_`)%.R_[:?^AM7.OX[]#I?^[KU-VBBBN@
MY@KD_B%_R`(/^OI?_07KK*Y/XA?\@"#_`*^E_P#07K*M_#9M0_BHO^#?^13L
MO^VG_H;5NUA>#?\`D4[+_MI_Z&U;M53^!>A-7^)+U844459F>:ZO_P`E*C_Z
M^K?^25Z57FNK_P#)2H_^OJW_`))7I5<]#XI>ITXCX8>@4445T',%>:Z1_P`E
M*D_Z^KC^3UZ57FND?\E*D_Z^KC^3USU_BCZG3A_AGZ'I5%%%=!S!6%XR_P"1
M3O?^V?\`Z&M;M87C+_D4[W_MG_Z&M14^!^AI2_B1]44/A[_R`)_^OIO_`$%*
MZRN3^'O_`"`)_P#KZ;_T%*ZRIH_PT57_`(K"O-=(_P"2E2?]?5Q_)Z]*KS72
M/^2E2?\`7U<?R>HK_%'U+P_PS]#TJBBBN@Y@HHHH`****`"J&M_\@#4?^O67
M_P!!-7ZH:W_R`-1_Z]9?_034R^%E0^)')_#C_F)_]LO_`&>N[KA/AQ_S$_\`
MME_[/7=UGA_X:-L5_%?]=`HHHK8YSD_B%_R`(/\`KZ7_`-!>K_@W_D4[+_MI
M_P"AM5#XA?\`(`@_Z^E_]!>K_@W_`)%.R_[:?^AM7.OX[]#I?^[KU-VBBBN@
MY@KS75_^2E1_]?5O_)*]*KS75_\`DI4?_7U;_P`DKGQ'PKU.G"_%+T/2J***
MZ#F"BBB@#S7X>_\`(?G_`.O5O_0DKTJO-?A[_P`A^?\`Z]6_]"2O2JY\-_#.
MG%_Q0HHHKH.8Y/XA?\@"#_KZ7_T%ZO\`@W_D4[+_`+:?^AM5#XA?\@"#_KZ7
M_P!!>K_@W_D4[+_MI_Z&U<Z_COT.E_[NO4W:***Z#F"N3^(7_(`@_P"OI?\`
MT%ZZRN3^(7_(`@_Z^E_]!>LJW\-FU#^*B_X-_P"13LO^VG_H;5NUA>#?^13L
MO^VG_H;5NU5/X%Z$U?XDO5A1115F9YKJ_P#R4J/_`*^K?^25Z57FNK_\E*C_
M`.OJW_DE>E5ST/BEZG3B/AAZ!11170<P5YKI'_)2I/\`KZN/Y/7I5>:Z1_R4
MJ3_KZN/Y/7/7^*/J=.'^&?H>E4445T',%87C+_D4[W_MG_Z&M;M87C+_`)%.
M]_[9_P#H:U%3X'Z&E+^)'U10^'O_`"`)_P#KZ;_T%*ZRN3^'O_(`G_Z^F_\`
M04KK*FC_``T57_BL*\UTC_DI4G_7U<?R>O2J\UTC_DI4G_7U<?R>HK_%'U+P
M_P`,_0]*HHHKH.8****`"BBB@`JAK?\`R`-1_P"O67_T$U?IKHDL;1R*KHP*
MLK#((/4$4FKJPT[.YY1X;\2?\(_]I_T3[1Y^W_EIMV[<^Q]:WO\`A8__`%"O
M_)C_`.QKK/[$TG_H%V7_`(#I_A1_8FD_]`NR_P#`=/\`"N>-*K%64CJE6HS?
M-*.IR?\`PL?_`*A7_DQ_]C1_PL?_`*A7_DQ_]C76?V)I/_0+LO\`P'3_``H_
ML32?^@79?^`Z?X4^2M_,3ST/Y/Q//?$/BS^WK".U^Q>1LE$F[S=V<`C&,#UJ
M?1O&O]D:3!8_V?YOE;OG\[;G+$]-I]:[O^Q-)_Z!=E_X#I_A1_8FD_\`0+LO
M_`=/\*GV57FYN;4OV]+EY>70Y/\`X6/_`-0K_P`F/_L:/^%C_P#4*_\`)C_[
M&NL_L32?^@79?^`Z?X4?V)I/_0+LO_`=/\*KDK?S$<]#^3\3D_\`A8__`%"O
M_)C_`.QKFKO6_M7B5=8^S[=LL<GE;\_<QQG'?'I7J/\`8FD_]`NR_P#`=/\`
M"C^Q-)_Z!=E_X#I_A4RI59;R+A7I0=XQ.3_X6/\`]0K_`,F/_L:/^%C_`/4*
M_P#)C_[&NL_L32?^@79?^`Z?X4?V)I/_`$"[+_P'3_"JY*W\Q'/0_D_$Y/\`
MX6/_`-0K_P`F/_L:/^%C_P#4*_\`)C_[&NL_L32?^@79?^`Z?X4?V)I/_0+L
MO_`=/\*.2M_,'/0_D_$\N\/:W_8-_)=?9_/WQ&/;OVXR0<YP?2NE_P"%C_\`
M4*_\F/\`[&NL_L32?^@79?\`@.G^%']B:3_T"[+_`,!T_P`*F-*K%64BYUZ4
MW>43D_\`A8__`%"O_)C_`.QH_P"%C_\`4*_\F/\`[&NL_L32?^@79?\`@.G^
M%']B:3_T"[+_`,!T_P`*KDK?S$<]#^3\3SWQ#XL_MZPCM?L7D;)1)N\W=G`(
MQC`]:GT;QK_9&DP6/]G^;Y6[Y_.VYRQ/3:?6N[_L32?^@79?^`Z?X4?V)I/_
M`$"[+_P'3_"I]E5YN;FU+]O2Y>7ET.3_`.%C_P#4*_\`)C_[&C_A8_\`U"O_
M`"8_^QKK/[$TG_H%V7_@.G^%']B:3_T"[+_P'3_"JY*W\Q'/0_D_$Y/_`(6/
M_P!0K_R8_P#L:R?$/BS^WK".U^Q>1LE$F[S=V<`C&,#UKT+^Q-)_Z!=E_P"`
MZ?X4?V)I/_0+LO\`P'3_``I2IU9*SD5&K1B[J/XG":-XU_LC28+'^S_-\K=\
M_G;<Y8GIM/K5_P#X6/\`]0K_`,F/_L:ZS^Q-)_Z!=E_X#I_A1_8FD_\`0+LO
M_`=/\*%3JI64A.K1;NX_B<G_`,+'_P"H5_Y,?_8T?\+'_P"H5_Y,?_8UUG]B
M:3_T"[+_`,!T_P`*/[$TG_H%V7_@.G^%/DK?S"YZ'\GXGEUWK?VKQ*NL?9]N
MV6.3RM^?N8XSCOCTKI?^%C_]0K_R8_\`L:ZS^Q-)_P"@79?^`Z?X4?V)I/\`
MT"[+_P`!T_PJ8TJL;VEN7*O2DDG'8Y/_`(6/_P!0K_R8_P#L:/\`A8__`%"O
M_)C_`.QKK/[$TG_H%V7_`(#I_A1_8FD_]`NR_P#`=/\`"JY*W\Q'/0_D_$Y/
M_A8__4*_\F/_`+&N:M-;^R^)6UC[/NW2R2>5OQ]_/&<=L^E>H_V)I/\`T"[+
M_P`!T_PH_L32?^@79?\`@.G^%3*E5E:\MBXUZ44TH[G)_P#"Q_\`J%?^3'_V
M-'_"Q_\`J%?^3'_V-=9_8FD_]`NR_P#`=/\`"C^Q-)_Z!=E_X#I_A5<E;^8C
MGH?R?B<G_P`+'_ZA7_DQ_P#8U0UGQK_:^DSV/]G^5YNWY_.W8PP/3:/2N[_L
M32?^@79?^`Z?X4?V)I/_`$"[+_P'3_"DZ=5JSD-5:*=U'\3SWP]XL_L&PDM?
ML7G[Y3)N\W;C(`QC!]*UO^%C_P#4*_\`)C_[&NL_L32?^@79?^`Z?X4?V)I/
M_0+LO_`=/\*(TZL592'*K1D[N/XG)_\`"Q_^H5_Y,?\`V-9/AJY^V>.XKK9L
M\Z6:3;G.,JQQG\:]"_L32?\`H%V7_@.G^%20Z7I]M*LL%A:Q2+T=(54CMU`H
M]E4;3D]@]M2C%J,;7+=%%%=)R!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4457O[R/3].N;V96:.WB:9P@R2%!)Q[\4TFW9`6**
MY\>,M)'A1/$4K2PV<FX1I(!YCL&*[0`2"25/?IR<`'&AHNK+K>F1W\=I=6T4
MO,:W*JK.O9@`3P>V>O7H03<J,XIN2V=OF*Z-"BBBLQA11534]1M])TRYU"Z;
M;#;QEVY`)QT`R0,D\`=R132;=D!;HJ*UG^U6D-QY4L7FQJ_ERKM=,C.&'8CN
M*S-'\26>MZCJEE;1SI)ILODS&10`QRP^7!.1\AZX[52A)IM+;<5S8HK'\2>)
M+/POIT=[>QSR1R2B$"!03D@GN1Q\IK8I.$E%2:T8[A1114@%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%97B?_D4M9_Z\9_\`T6U:M5-4LO[2TF]L?,\O
M[3`\._;G;N4C.._6KIM*:;[B>QX?82ZLOA_2-0U&R\_PSIMV%,!0D2[F8LY&
M0&P3M!)"Y(7G+5Z=X]\23Z)X3COM+E4R7,J1PW"%6"@@MN&00P(7'_`LUI:)
MX<ATOPHF@7$OVN$1R1R-M,>]79B1@$D<-CK7+ZMX>AT'X<2Z1J4MYJ4"REX9
MK2R4O:C!?<06^Z"&RV0</C(KU)5Z->LFUM+;NGU]>_>YGRN*,WQOINK>%?#M
MK<VWBC6)GDG2.82SGYFV,05(Y4<-\N3G(S]T5:\8ZCJ=MXFF;4FUVUT""!3#
M-I!V;G8KDR,3CKN&#C^'`Y)/+Z]<2:_;:?I%CXDO/$-V90L,(M/(5`%()<MR
M[=,,3P`Y)YKU/5M!U.ZU,7VE>(;K3G:/9+$R>?$W3!5&.%/')'7VYSI.2I<G
MM;7][HUV\K_.PEK>Q7\$WL%U974=KXA;68(I?W;3Q,LT0.2%<L<N/0X'0^F!
M%X[1M2ATKP_'(P;4[U1,B``M`GS2$$C`(^4^I]^16AX:\,Q^'UO)GN6N[^^E
M,UU<LNP.<DC"#A1\Q_$GM@"Q/HOVKQ-9ZO-<;H[.!T@M]F-DCG#2;@><K\NT
MC'>N!U*<<0ZD7HMO6VG1=?3[R[/EL:M>?_#_`/Y&WQI_U_#_`-&2UZ!7G\_P
MXU#^UM0OK'Q5=6/VV=IG2")EZL2`2)!G&XTL-*GR3A.5KV[][]`E>Z:#XO\`
M_(I6O_7\G_HN2J_B<:KX)AL=;CU_4;YI+E8KNWN'!CE!RYV+@B,?(1P"0&X/
M'.A>>`+S4/#`TB]\13W,@O?M0N9XBY`V;=F"_3DGKWZ58?P1<WUW:_VSX@NM
M1T^SD$D%I)"@R01CS6Y\S@$$D9.3R,G/53K480C!R32;OH]4_D2TV[F)XQU'
M4[;Q-,VI-KMKH$$"F&;2#LW.Q7)D8G'7<,''\.!R2>C\$WL%U974=KXA;68(
MI?W;3Q,LT0.2%<L<N/0X'0^F!8U;0=3NM3%]I7B&ZTYVCV2Q,GGQ-TP51CA3
MQR1U]N<O\->&8_#ZWDSW+7=_?2F:ZN678'.21A!PH^8_B3VP!E4JTI8=1OKI
MHOUT_%/7L4D^8W:***\\L****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
9BB@`HHHH`****`"BBB@`HHHH`****`/_V8HH
`



#End
