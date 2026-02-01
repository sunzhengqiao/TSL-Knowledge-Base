#Version 8
#BeginDescription
Inserts ladder between 2 existing beams in a wall (flat orientation). PLEASE NOTICE: This tsl may be obsolete. Please check if GE_WDET_LADDER_BLOCKING_MULTI_DOUBLE_BLOCK fits better your need
v0.4: 21.jul.2012: David Rueda (dr@hsb-cad.com)
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 0
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
* v0.4: 21.jul.2012: David Rueda (dr@hsb-cad.com)
	- Description added
	- Thumbnail added
	- Copyright added
* V0.3_RL_Jan 5 2011_Adjusted for materials coming from _MAP
*
*/


//TSL DESCRIPTION
//Unit(1,"inch");

//////////////////////////////////////////////////////////////////////////////////////////////////// SET SOME PROPERTIES /////////////////////////////////////////////////////////////////////////////////////////////////////

int strProp=0,nProp=0,dProp=0;
String arYN[]={"Yes","No"};

PropString strEmpty0(strProp,"- - - - - - - - - - - - - - - -",T("PLACEMENT PROPERTIES"));strProp++;
strEmpty0.setReadOnly(true);

PropDouble dStartOffset(dProp,U(600, 24),T("  Start Offset"));dProp++;

PropDouble dEndOffset(dProp,U(0, 0),T("  End Offset"));dProp++;

PropDouble dSpacing(dProp,U(600, 24),T("  Spacing"));dProp++;

//PropDouble dBlockingLength(dProp,U(8),T("  Blocking Length"));dProp++;

PropString strEmpty1(strProp,"- - - - - - - - - - - - - - - -",T("MATERIAL PROPERTIES"));strProp++;
strEmpty1.setReadOnly(true);

PropString strMat(strProp,"SPF",T("  Material"));strProp++;

PropString strGrade(strProp,"#2",T("  Grade"));strProp++;

//OTHER SETTINGS
int nColor=2;

double dBlkSizeInElVecY=U(89, 3.5);

//Insert donde in script.
if(_bOnInsert){
	//Select an element
	_Element.append(getElement(T("Select an element")));
	_Pt0 = getPoint(T("Select an insertion point"));
	showDialogOnce();
	return;
}

if(_Element.length()==0){
	eraseInstance(); 
	return;
}
if(_bOnElementDeleted)eraseInstance();

//set properties from Map
{
	if(_Map.hasString("StartOffset")){
		dStartOffset.set(_Map.getString("StartOffset").atof()/25.4);
	}
	if(_Map.hasString("EndOffset")){
		dEndOffset.set(_Map.getString("EndOffset").atof()/25.4);
	}	
	if(_Map.hasString("Spacing")){
		dSpacing.set(_Map.getString("Spacing").atof()/25.4);
	}			
	if(_Map.hasString("Material")){
		strMat.set(_Map.getString("Material"));
	}	
	if(_Map.hasString("Grade")){
		strGrade.set(_Map.getString("Grade"));
	}		
}
	
//Assign selected element to el.
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

//Load the properties for the arguments
String sStartOffset;
if (_Map.hasString("StartOffset"))
{
	sStartOffset= _Map.getString("StartOffset");
	double dAux=sStartOffset.atof();
	dAux=dAux/25.4;
	dStartOffset.set(dAux);
}

String sEndOffset;
if (_Map.hasString("EndOffset"))
{
	sEndOffset= _Map.getString("EndOffset");
	double dAux=sEndOffset.atof();
	dAux=dAux/25.4;
	dEndOffset.set(dAux);
}

String sSpacing;
if (_Map.hasString("Spacing"))
{
	sSpacing= _Map.getString("Spacing");
	double dAux=sSpacing.atof();
	dAux=dAux/25.4;
	dSpacing.set(dAux);
}


//set Module name
String sModuleName="LAD_FLAT" + int(el.dBeamWidth()+U(25, 1)) + "_" + _ThisInst.handle() ;


assignToElementGroup(el,TRUE,0,'Z');

Beam arBmAll[]=el.beam();
Beam arBmVertical[]=vx.filterBeamsPerpendicularSort(arBmAll);
Beam arBmHorizontal[]=vy.filterBeamsPerpendicularSort(arBmAll);

//Relocate _Pt0
_Pt0=_Pt0.projectPoint(Plane(el.ptOrg(),el.vecY()),0);


if(el.vecZ().dotProduct(_Pt0 - (el.ptOrg()-el.vecZ()*el.dBeamWidth()/2)) >= U(0, 0)) {
	_Pt0=_Pt0.projectPoint(Plane(el.ptOrg(),el.vecZ()),0);
	vz = -vz;
}
else {
	_Pt0 = _Pt0.projectPoint(Plane(el.ptOrg()-el.dBeamWidth()*el.vecZ(),el.vecZ()),0);
}
//vzC is always going in the walls


//Getting closer studs to insertion point
Beam bmLeft, bmRight;
double dDistL, dDistR;
dDistL=dDistR=U(10000, 100000);
int nOneOnZero=0;
for(int b=0;b<arBmVertical.length();b++){
	Beam bm=arBmVertical[b];
	double dDistPointToBeam=vx.dotProduct(bm.ptCen()-_Pt0);
	if(abs(dDistPointToBeam)<U(2, 0.1))nOneOnZero=1;
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

//Check blocking pieces in the way
//bHasBlocking will be true is blocking belongs to a module
Body bdBlk(_Pt0,el.vecX(),el.vecY(),el.vecZ(),(dDistL+dDistR)/2,U(12000, 600),U(1200, 50),0,1,0);
for(int b=0;b<arBmHorizontal.length();b++){
	Beam bm=arBmHorizontal[b];
	if((bm.type()== _kBlocking || bm.type()==_kSFBlocking) && bm.realBody().hasIntersection(bdBlk) )bm.dbErase();
}


Point3d ptRightOnLeftBm=bmLeft.ptCen()+vx*bmLeft.dD(vx)*.5;
Point3d ptLeftOnRightBm=bmRight.ptCen()-vx*bmRight.dD(vx)*.5;


//Get shape points to calculate offset values
Point3d arPtBmSide[0];

arPtBmSide.append(bmLeft.realBody().allVertices());
arPtBmSide.append(bmRight.realBody().allVertices());

arPtBmSide=Line(ptOrg,vy).orderPoints(arPtBmSide);

double dMaxHeight=vy.dotProduct(arPtBmSide[arPtBmSide.length()-1]-ptOrg);
double dBottomPlateThick=vy.dotProduct(arPtBmSide[0]-ptOrg);

Point3d arPtBlock[0];

//do something special for end offset
double dOffsetDown=U(0, 0);//if >0, it needs blocking at tope forced in
if(dEndOffset == U(0, 0))dMaxHeight -= dBlkSizeInElVecY/2;
else if(dEndOffset <= (dBlkSizeInElVecY/2 + U(76, 3))){
	dMaxHeight -= dBlkSizeInElVecY*1.5;
	dOffsetDown=dBlkSizeInElVecY/2;
}
else {
	dMaxHeight -= (dEndOffset+dBlkSizeInElVecY*1);
	dOffsetDown=dEndOffset;
}
//define some points for blocks

	
double dGrow=dStartOffset;

//see if we force one at the bottom
if(dGrow == U(0, 0)){
	dGrow = dBlkSizeInElVecY/2+dBottomPlateThick;
}
Point3d ptBlock=_Pt0+dGrow*vy;
	
while(dGrow < dMaxHeight){//get all points possible
	arPtBlock.append(ptBlock);
	
	ptBlock.transformBy(dSpacing*vy);					
	dGrow+=dSpacing;
}
if(dOffsetDown>U(0, 0)){//force at the top
	dMaxHeight=vy.dotProduct(arPtBmSide[arPtBmSide.length()-1]-ptOrg);
	arPtBlock.append(_Pt0+(dMaxHeight-dOffsetDown)*vy);
}
		
		
arPtBlock=Line(el.ptOrg(),el.vecY()).orderPoints(arPtBlock);
		
for(int i=0;i<arPtBlock.length();i++){
			
	Beam bm1;		
		
	bm1.dbCreate(arPtBlock[i], vx, vy, vz, U(25, 1), U(89, 3.5), U(38, 1.5), 0, 0, 1);
	bm1.setType(_kBlocking);
	bm1.setColor(nColor);
	bm1.stretchDynamicTo(bmLeft);
	bm1.stretchDynamicTo(bmRight);
	bm1.setModule(sModuleName);
	bm1.setHsbId("12");
	bm1.setMaterial(strMat);
	bm1.setGrade(strGrade);
	bm1.assignToElementGroup(el,TRUE,0,'Z');
}

bmLeft.setColor(nColor);
bmRight.setColor(nColor);
bmLeft.setModule(sModuleName);
bmRight.setModule(sModuleName);

eraseInstance();
return;


























#End
#BeginThumbnail
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
MXO?^^T_^)H_X5[I/_/Q>_P#?:?\`Q-7>OV1G;#]V7_\`A,M`_P"?_P#\@R?_
M`!-4]4\6:)<Z1>P17NZ22!T1?*<9)4@#I3/^%>Z3_P`_%[_WVG_Q-'_"O=)_
MY^+W_OM/_B:&Z[5K(:6'3O=F#X*UG3](^W?;KCRO-\O9\C-G&[/0'U%=;_PF
M6@?\_P#_`.09/_B:H?\`"O=)_P"?B]_[[3_XFC_A7ND_\_%[_P!]I_\`$U,%
M6A'E21525"<N9ME__A,M`_Y__P#R#)_\37%W=[;ZA\0(+JUD\R%[J#:V",XV
M`\'GJ*Z7_A7ND_\`/Q>_]]I_\34MKX%TRTO(+F.>[+PR+(H9UP2#D9^6B4:L
M[)I!"="G=Q;.GHHHKJ.,****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
&****`/_9
`

#End
