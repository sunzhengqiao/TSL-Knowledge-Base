#Version 8
#BeginDescription
GE_HDWR_ANCHOR_EMBEDDED
v1.3: 15.jun.2014: David Rueda (dr@hsb-cad.com)

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords Wall;TieRod;Hardware;Anchor
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
v1.3: 15.jun.2014: David Rueda (dr@hsb-cad.com)
	- TSL can now be inserted by other hardware systems
v1.2: 05.mar.2013: David Rueda (dr@hsb-cad.com)
	- Avoided printing map to DXX file
v1.1: 27.nov.2012: David Rueda (dr@hsb-cad.com)
	- Version control (several enhancements, coordinated with Manish Patel and Marcelo Quevedo)
*v1.0: 14.nov.2012: David Rueda (dr@hsb-cad.com)
	- Release. Created as dummy only, insertion yet to be coded. Will be useful inserted from outside
*/

String sTypes[0], sSizes[0];

sTypes.append("1/2 Embedded Anchor");									sSizes.append("1/2");
sTypes.append("5/8 Embedded Anchor");									sSizes.append("5/8");
sTypes.append("7/8 Embedded Anchor");									sSizes.append("7/8");

PropString sType(0, sTypes, T("|Anchor type|"),2);

if (_bOnInsert){
	reportMessage("\n"+T("|Message from|")+" GE_HDWR_ANCHOR_EMBEDDED TSL: "+ T("|This TSL has not yet a manual insertion defined. It can be inserted only by other script. Instance will be erased|")+"\n");
	eraseInstance();	
}

Display dp(254);
Vector3d vx=-_ZW;
Vector3d vy=_XW;
Vector3d vz=vx.crossProduct(vy);

// Get info from map if present
if(_Map.hasString("ANCHORTYPE"))
{
	sType.set(sTypes[sSizes.find(_Map.getString("ANCHORTYPE"),0)]);
}
if(_Map.hasVector3d("vx"))
	vx=_Map.getVector3d("vx");
if(_Map.hasVector3d("vy"))
	vy=_Map.getVector3d("vy");
if(_Map.hasVector3d("vz"))
	vz=_Map.getVector3d("vz");
int bInsertedByDirective=_Map.getInt("InsertedByDirective");
if(bInsertedByDirective)
	sType.setReadOnly(true);
int bHideWasherAndNuts=_Map.getInt("HideWasherAndNuts");
	
int nType=sTypes.find(sType,0);

if(_Element.length()==1)
{
	Element el=_Element[0];
	setDependencyOnEntity(el);
	if(_bOnElementDeleted)
		eraseInstance();		
}

// Nuts
double dNutSideLength=U(25, 1.062);
double dNutSideHeight=U(15, 0.625);;
Point3d ptAllNutsBasePoints[0]; // Insertion point for all nuts, aligned center in diameter, BASE or top according to extrusion vector
Point3d ptAllNutsExtrusionPoints[0]; // define the vector to extrude body MAKE SURE ALWAYS HAS SAME LENGHT THAT ptAllRodsBasePoints
Point3d ptAllNutsDirectionPoints[0]; // define the vector to align body MAKE SURE ALWAYS HAS SAME LENGHT THAT ptAllRodsBasePoints

// Square washers
Point3d ptAllSquareWashersBasePoints[0]; // Insertion point for all square washers, aligned center in diameter, BASE in vertical
Point3d ptAllSquareWashersExtrusionPoints[0]; // define the vector to extrude body MAKE SURE ALWAYS HAS SAME LENGHT THAT ptAllSquareBlocksBasePoints
Point3d ptAllSquareWashersDirectionPoints[0]; // define the vector to align body MAKE SURE ALWAYS HAS SAME LENGHT THAT ptAllSquareBlocksBasePoints
double dSquareWasherSideLength=U(75, 3);
double dSquareWasherSideHeight=U(15, 0.625);

// Rod
double dExtraLengthWhenEmbedded=U(12,.5);
double dLength=U(250,10)+dNutSideHeight*2+dSquareWasherSideHeight+dExtraLengthWhenEmbedded;
double dExtension=U(50,2);
double dEmbedment=dLength-dExtension;
double dRadius=U(12,0.375/2);
Point3d ptStart=_Pt0-vx*dExtension;
Point3d ptEnd=_Pt0+vx*dEmbedment;
Body bdRod(ptStart,ptEnd,dRadius);

dp.draw(bdRod);
	
// Embedded part
// Bottom nut
Point3d ptNut=ptEnd-vx*dExtraLengthWhenEmbedded;
ptAllNutsBasePoints.append(ptNut);
ptAllNutsExtrusionPoints.append(ptNut-vx);
ptAllNutsDirectionPoints.append(ptNut+vy);

// Washer
ptNut-=vx*dNutSideHeight;
ptAllSquareWashersBasePoints.append(ptNut);
ptAllSquareWashersExtrusionPoints.append(ptNut-vx);
ptAllSquareWashersDirectionPoints.append(ptNut+vy);

// Top nut
ptNut-=vx*dSquareWasherSideHeight;
ptAllNutsBasePoints.append(ptNut);
ptAllNutsExtrusionPoints.append(ptNut-vx);
ptAllNutsDirectionPoints.append(ptNut+vy);

// Top part
if(!bHideWasherAndNuts)
{
	ptNut=_Pt0-vx*dSquareWasherSideHeight;
	ptAllNutsBasePoints.append(ptNut);
	ptAllNutsExtrusionPoints.append(ptNut-vx);
	ptAllNutsDirectionPoints.append(ptNut+vy);
	
	ptAllSquareWashersBasePoints.append(_Pt0);
	ptAllSquareWashersExtrusionPoints.append(_Pt0-vx);
	ptAllSquareWashersDirectionPoints.append(_Pt0+vy);
}

// Draw nuts
for(int n=0;n<ptAllNutsBasePoints.length();n++)
{
	double dRadius= dNutSideLength*.5;
	double dAngle=60;
	Point3d ptBase=ptAllNutsBasePoints[n];
	Point3d ptExtrude=ptAllNutsExtrusionPoints[n];
	Point3d ptDirection= ptAllNutsDirectionPoints[n];
	Vector3d vExtrude(ptExtrude-ptBase);vExtrude.normalize();
	Vector3d vDirection(ptDirection-ptBase);vDirection.normalize();
	Vector3d vVertex= vExtrude.crossProduct(vDirection);

	PLine plEx;
	for(int s=0;s<6;s++)
	{
		Point3d pt=ptBase+vVertex*dRadius;
		plEx.addVertex(pt);
			vVertex=vVertex.rotateBy(60, _ZW);
		
	}
	plEx.close();
	Body bdNut ( plEx, vExtrude*dNutSideHeight, 1);
	dp.draw(bdNut);
}

//Draw square washers
for(int n=0;n<ptAllSquareWashersBasePoints.length();n++)
{
	Point3d ptBase=ptAllSquareWashersBasePoints[n];
	Point3d ptExtrude=ptAllSquareWashersExtrusionPoints[n];
	Point3d ptDirection= ptAllSquareWashersDirectionPoints[n];
	Vector3d vExtrude(ptExtrude-ptBase);vExtrude.normalize();
	Vector3d vDirection(ptDirection-ptBase);vDirection.normalize();
	Vector3d vVertex= vExtrude.crossProduct(vDirection);

	PLine plEx;
	Point3d pt=ptBase+vVertex*dSquareWasherSideLength*.5+vDirection*dSquareWasherSideLength*.5; pt.vis();
	plEx.addVertex(pt);
	pt-=vDirection*dSquareWasherSideLength; pt.vis();
	plEx.addVertex(pt);
	pt-=vVertex*dSquareWasherSideLength; pt.vis();
	plEx.addVertex(pt);
	pt+=vDirection*dSquareWasherSideLength; pt.vis();
	plEx.addVertex(pt);

	plEx.close();
	Body bdSquareWasher( plEx, vExtrude*dSquareWasherSideHeight, 1);
	dp.draw(bdSquareWasher);
}

#End
#BeginThumbnail
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
M`HHHH`\:^('_`"-]U_NI_P"@"M[X=?\`(6NO^O8?^A5@_$#_`)&^Z_W4_P#0
M!6]\.O\`D+77_7L/_0J`/1Z***`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`/&OB!_P`C?=?[J?\`H`K>^'7_
M`"%KK_KV'_H587Q!_P"1ONO]V/\`]`%;OPZ_Y"UU_P!>P_\`0J`/1Z***`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`/%O'G_`".6H?6/_P!%I71?#K_D+W8_Z=A_Z%7.^//^1SU#ZQ_^BDKH
M?AU_R&+O_KV7_P!"H`](HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`\6\>?\`(YZA]8__`$4E=#\.O^0Q
M=_\`7L/_`$*N>\>?\CEJ'^]'_P"BDKH?AU_R%[O_`*]E_P#0J`/2****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`/%O'G_(Y:A]8_\`T4E=%\.O^0O=?]>P_P#0JYWQY_R.6H?6/_T4E=%\
M.O\`D+W7_7L/_0J`/1Z***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`/%O'G_(Y:A]8__125T7PZ_P"0M=?]
M>R_^A5SOCS_D<]0_WH__`$4E=%\.O^0M=?\`7LO_`*%0!Z/1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
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
2444`%%%%`!1110`4444`?__9
`


#End
