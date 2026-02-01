#Version 8
#BeginDescription
On Layout show the total weight of an element.

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 8
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2008 by
*  hsbSOFT IRELAND
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
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 09.04.2008
* version 1.0: First version
*
* date: 30.10.2009
* version 1.1: Added materials and material weights.
*
* date: 25.02.2009
* version 1.2: Remove the make Upper from Extrusion Profiles. 
*
* date: 01.03.2011
* version 1.3: Add OSB to the materials. 
*
* date: 05.10.2011
* version 1.4: Add 9MM SHEATHING to the materials. 
*
* date: 07.02.2012
* version 1.5: Add Fermacell, plywood and mineral wool.  
* Also excluded any beams in other zones except 0 for frame weight
*
* date: 26.09.2012
* version 1.6: Add support for materials when they are been set by another TSL.
*
* date: 08.10.2012
* version 1.7: Add support for materials when they are been set by another TSL.
*
* date: 19.11.2012
* version 1.8: Calculate the weight of windows if they have a property set call "OpeningExtraData" and the key "Weight".
*/

Unit (1, "mm");

////// THIS VALUES CAN BE CHANGE OR EXTEND TO ALLOW MORE NAMES AND WEIGHTS, ALWAYS THE STRING NEEDS TO HAVE
////// THE SAME NUMBER OF ITEMS THAN THE DOUBLE
////// IMPORTANT!!! THE SHEET NAME NEEDS TO BE IN CAPITAL LETTER
//Sheets
double dWeightFactorSheet[0];

//Name of the Sheet
String sSheetName[0];									// This Factor is the weight(kg) per cubic meter
sSheetName.append("OSB3");							dWeightFactorSheet.append(620);
sSheetName.append("9MM WBP PLY");					dWeightFactorSheet.append(463);
sSheetName.append("9MM PLY");						dWeightFactorSheet.append(463);
sSheetName.append("18MM WBP PLY");				dWeightFactorSheet.append(463);
sSheetName.append("21MM WBP PLY");				dWeightFactorSheet.append(463);
sSheetName.append("18MM OSB");						dWeightFactorSheet.append(463);
sSheetName.append("9MM OSB");						dWeightFactorSheet.append(463);
sSheetName.append("15MM FERMACELL");				dWeightFactorSheet.append(1181);
sSheetName.append("OSB");								dWeightFactorSheet.append(620);
sSheetName.append("9MM SHEATHING");				dWeightFactorSheet.append(620);
sSheetName.append("FERMACELL");					dWeightFactorSheet.append(1150);
sSheetName.append("PLYWOOD");						dWeightFactorSheet.append(463);
sSheetName.append("MINERAL WOOL");				dWeightFactorSheet.append(45);

sSheetName.append("BATTENS 25X50MM");			dWeightFactorSheet.append(450);
sSheetName.append("BATTENS 38X40MM");			dWeightFactorSheet.append(450);
sSheetName.append("PLASTERBOARD 12.5MM");		dWeightFactorSheet.append(950);
sSheetName.append("PLASTERBOARD 15MM");		dWeightFactorSheet.append(950);

sSheetName.append("INSULATION 80MM");				dWeightFactorSheet.append(35);
sSheetName.append("INSULATION 110MM");			dWeightFactorSheet.append(35);

sSheetName.append("FERMACELL 15MM");				dWeightFactorSheet.append(1181);

sSheetName.append("RENDER BOARD");				dWeightFactorSheet.append(1380);
//sSheetName.append("MINERAL WOOL");				dWeightFactorSheet.append(10);


//Beams
String sBeamProfile[]={"JJG 195x45","JJG 200x47","JJG 300x90","JJG 145x45","SJ45 200", "SJ45 220", "SJ45 240", "SJ45 300","SJ45 360","SJ60 200", "SJ60 220", "SJ60 240", "SJ60 300","SJ60 360","SJ60 400","SJ90 200", "SJ90 220", "SJ90 240", "SJ90 300","SJ90 360","SJ90 400"};  //Name of the Extrusion Profiles of the beams
double dWeightFactorBeam[]={4.39, 0, 13.5, 6, 2.9, 3.1, 3.2, 3.7,4.7,3.5, 3.8 ,3.9 ,4.3 ,4.8 ,5.0 ,4.8 ,5.1 ,5.1 ,5.6 ,6.2 ,6.4};  // This Factor is the weight(kg) per linear meter
//////

//General Properties
PropString sDimStyle(0,_DimStyles,T("Dimstyle"));
//PropDouble dOffset(0,U(5),T("Offset between lines"));
PropInt nColor (0,1,T("Set Color"));

PropDouble dBmWeight (0, 450, T("Weight for Standard Beams (Kg/m3)"));
PropDouble dTextOffset (1, 5, T("Text Offset"));
//PropDouble dBmWeight (0, 4.50, T("Beam Weight"));

//String arYesNo[]={"No", "Yes"};
//PropString strTranslateId(3,arYesNo,"Weight All Beams");

if( _bOnInsert ){
	if (insertCycleCount()>1) { eraseInstance(); return; }
	showDialogOnce();
	_Pt0=getPoint("Pick a Point");
	_Viewport.append(getViewport(T("Select a viewport")));
	
	return;
}

if( _Viewport.length()==0 ){eraseInstance(); return;}

Viewport vp = _Viewport[0];

if (!vp.element().bIsValid()) return;

CoordSys ms2ps = vp.coordSys();

Element el = vp.element();

CoordSys csEl = el.coordSys();
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();
Point3d ptEl = csEl.ptOrg();
//ptEl.vis(2);

Plane plnZ (ptEl, vz);

Vector3d vXTxt = _XW;
Vector3d vYTxt = _YW;

double dWeight;
double dWeightSheets;
double dWeightBeams;
double dWeightBeamsOtherZones;
double dWeightBmStd;

Sheet shAll[]=el.sheet();

GenBeam gbAll[]=el.genBeam(0);
Beam bmAll[]=el.beam();
Beam bmZone0[0];
Beam bmOtherZones[0];

String sMaterials[0];
double dMatThickness[0];

TslInst tslAll[]=el.tslInstAttached();
for (int i=0; i<tslAll.length(); i++)
{
	TslInst tsl=tslAll[i];
	
	if (tsl.scriptName()=="FrameUK_SetWallMaterials")
	{
		Map mpTLS=tsl.map();
		if (mpTLS.hasMap("MATERIALS"))
		{
			Map mpMaterials=mpTLS.getMap("MATERIALS");
			for (int j=0; j<mpMaterials.length(); j++)
			{
				if (mpMaterials.keyAt(j)=="MATERIAL")
				{
					Map mp=mpMaterials.getMap(j);
					String str=mp.getString("MATERIAL");
					str.trimLeft();
					str.trimRight();
					str.makeUpper();
					double dZoneThickness=mp.getDouble("THICKNESS");
					
					if (sSheetName.find(str, -1)!=-1)
					{
						sMaterials.append(str);
						dMatThickness.append(dZoneThickness);
					}
				}
			}
		}
	}
}

for(int g=0;g<gbAll.length();g++)
{
	Beam bm=(Beam)gbAll[g];
	
	if(bm.bIsValid())
	{
		bmZone0.append(bm);
	}
}

for(int b=0;b<bmAll.length();b++)
{
	Beam bm=bmAll[b];
	if(bmZone0.find(bm)==-1)
	{
		bmOtherZones.append(bm);
	}
}

for (int i=0; i<shAll.length(); i++)
{
	String sName=shAll[i].material();
	sName.makeUpper();
	int nLocation=sSheetName.find(sName, -1);
	if (nLocation!=-1)
	{
		Body bdSheet=shAll[i].realBody();
		dWeightSheets=dWeightSheets+(bdSheet.volume()* dWeightFactorSheet[nLocation]);
	}
}
dWeightSheets=dWeightSheets/1000000000;

PlaneProfile ppBeams (plnZ);

for (int i=0; i<bmZone0.length(); i++)
{
	String sProfile=bmAll[i].extrProfile();
	//sProfile.makeUpper();
	int nLocation=sBeamProfile.find(sProfile, -1);
	if (nLocation!=-1)
	{
		//Body bdBeam=bmAll[i].realBody();
		dWeightBeams=dWeightBeams+(bmAll[i].solidLength()* dWeightFactorBeam[nLocation]);
	}
	else
	{
		dWeightBmStd=dWeightBmStd+(bmAll[i].volume()* dBmWeight);
		//dWeightBeams=dWeightBeams+(bmAll[i].solidLength()* dBmWeight);
	}
	int nBmType=bmAll[i].type();
	if (nBmType==_kSFTopPlate || nBmType== _kSFBottomPlate || nBmType== _kStud || nBmType== _kSFStudLeft || nBmType== _kSFStudRight || nBmType== _kSFSupportingBeam)
	{
		PlaneProfile ppBm=bmAll[i].realBody().shadowProfile(plnZ);
		ppBm.shrink(-U(5));
		ppBeams.unionWith(ppBm);
	} 
}

ppBeams.shrink(U(5));
double dAreaForBattens=ppBeams.area();

ppBeams.vis(1);

for (int i=0; i<bmOtherZones.length(); i++)
{
	String sProfile=bmOtherZones[i].extrProfile();
	//sProfile.makeUpper();
	int nLocation=sBeamProfile.find(sProfile, -1);
	if (nLocation!=-1)
	{
		//Body bdBeam=bmAll[i].realBody();
		dWeightBeamsOtherZones=dWeightBeamsOtherZones+(bmOtherZones[i].solidLength()* dWeightFactorBeam[nLocation]);
	}
	else
	{
		dWeightBeamsOtherZones=dWeightBeamsOtherZones+(bmAll[i].volume()* dBmWeight);
	}
}

//Area of the panel
PlaneProfile ppElement=el.profNetto(0);
double dElArea=ppElement.area();'

double dExtraWeight=0;
for (int i=0; i<sMaterials.length(); i++)
{
	int nLocation=sSheetName.find(sMaterials[i], -1);
	if (nLocation!=-1)
	{
		String sToken=sMaterials[i].token(0, " ");
		if (sToken=="BATTENS")
		{
			dExtraWeight=dExtraWeight+(dAreaForBattens*dMatThickness[i]* dWeightFactorSheet[nLocation]);
		}
		else
		{
			dExtraWeight=dExtraWeight+(dElArea*dMatThickness[i]* dWeightFactorSheet[nLocation]);
		}
	}
}

//Calculate opening weight
double dOpeningWeight=0;
Opening opAll[]=el.opening();
int nOpenings=false;
for (int i=0; i<opAll.length(); i++)
{
	Opening op=opAll[i];
	Map mpThisOp=op.getAttachedPropSetMap("OpeningExtraData");
	if (mpThisOp.length()>0)
	{
		if (mpThisOp.hasDouble("Weight"))
		{
			double dOpWeight=mpThisOp.getDouble("Weight");
			if (dOpWeight>0)
			{
				nOpenings=true;
				dOpeningWeight+=dOpWeight;
			}
		}
	}
}

dWeightBmStd=dWeightBmStd/1000000000;
dWeightBeamsOtherZones=dWeightBeamsOtherZones/1000000000;
dWeightBeams=dWeightBeams/1000;
dWeightBeams=dWeightBeams+dWeightBmStd;

String strWeightBm;
strWeightBm.formatUnit(dWeightBeams,2,2);
strWeightBm=strWeightBm+ " Kg";

dWeight=dWeightSheets+dWeightBeams+dWeightBeamsOtherZones+dOpeningWeight;

String strWeight;
strWeight.formatUnit(dWeight,2,2);
strWeight=strWeight+ " Kg";




Display dp(nColor);
dp.dimStyle(sDimStyle);

if (dWeight!=0)
{
	String sTotalWeight="Total Weight: ";
	if (nOpenings)
	{
		sTotalWeight="Total weight includes openings: ";
	}
	dp.draw ("Frame Weight: "+strWeightBm, _Pt0, vXTxt, vYTxt, 1, -1);
	dp.draw (sTotalWeight+strWeight, _Pt0-vYTxt*U(dTextOffset) , vXTxt, vYTxt, 1, -1);
	
	double dTestLength=dp.textLengthForStyle("Frame Weight: "+strWeightBm, sDimStyle);
	
	if (sMaterials.length()>0)
	{
		String sOutput;
		dp.draw ("Weight includes: ", _Pt0+vXTxt*(U(dTestLength)+U(4)) , vXTxt, vYTxt, 1, -1);
		for (int i=0; i<sMaterials.length(); i++)
		{
			sOutput=sMaterials[i];
			dp.draw (sOutput, _Pt0+vXTxt*(U(dTestLength)+U(4))-vYTxt*U(dTextOffset)*(i+1), vXTxt, vYTxt, 1, -1);
		}
		
	}
}



#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`&3`6@#`2(``A$!`Q$!_\0`
M'P```04!`0$!`0$```````````$"`P0%!@<("0H+_\0`M1```@$#`P($`P4%
M!`0```%]`0(#``01!1(A,4$&$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*
M%A<8&1HE)B<H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&EJ<W1U
M=G=X>7J#A(6&AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&
MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ>KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!
M`0$!`0````````$"`P0%!@<("0H+_\0`M1$``@$"!`0#!`<%!`0``0)W``$"
M`Q$$!2$Q!A)!40=A<1,B,H$(%$*1H;'!"2,S4O`58G+1"A8D-.$E\1<8&1HF
M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@H.$
MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#Y_HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`+EGI.I:A;W5Q9:?=W,%HF^YDAA9UA7!.7
M(&%&%)R?0^E1V-A>:G>1V=A:3W=U)G9#!&9';`).%')P`3^%=QX!_P"18\1?
M\#_]-NI5S_@W_D.7/_8*U+_TBFH`Q[ZPO-,O)+._M)[2ZCQOAGC,;KD`C*GD
M9!!_&J]>D7?ANSU*[.J:G).EI;Z?I<>Q&$2NIL8C(YE(;:L?[O.U)&9I8T`W
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
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
4@`HHHH`****`"BBB@`HHHH`__]FB
`









#End
