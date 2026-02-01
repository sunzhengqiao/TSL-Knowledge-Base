#Version 8
#BeginDescription
Inserts ladder between 2 existing beams in a wall (edge orientation). PLEASE NOTICE: This tsl may be obsolete. Please check if GE_WDET_LADDER_BLOCKING_MULTI_DOUBLE_BLOCK fits better your need
v0.4: 10.ago.2012: David Rueda (dr@hsb-cad.com)
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
* v0.4: 10.ago.2012: David Rueda (dr@hsb-cad.com)
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

double dBlkSizeInElVecY=U(38, 1.5);

String sCalatog;
if (_Map.hasString("Catalog")) sCalatog= _Map.getString("Catalog");
if (sCalatog!="");
	_kExecuteKey=sCalatog;

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

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


//set Module name
String sModuleName="LAD_EDGE" + int(el.dBeamWidth()+U(25, 1)) + "_" + _ThisInst.handle() ;

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
Body bdBlk(_Pt0,el.vecX(),el.vecY(),el.vecZ(),(dDistL+dDistR)/2,U(10000, 600), U(1200, 50),0,1,0);
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
else if(dEndOffset <= (dBlkSizeInElVecY/2 + U(75, 3))){
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
		
	bm1.dbCreate(arPtBlock[i], vx, vy, vz, U(25, 1), U(38, 1.5), el.dBeamWidth(), 0, 0, 1);
	bm1.setType(_kSFBlocking);
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
MDD@=$7RG&25(`Z4S_A7ND_\`/Q>_]]I_\31_PKW2?^?B]_[[3_XFANNU:R&E
MAT[W9@^"M9T_2/MWVZX\KS?+V?(S9QNST!]176_\)EH'_/\`_P#D&3_XFJ'_
M``KW2?\`GXO?^^T_^)H_X5[I/_/Q>_\`?:?_`!-3!5H1Y4D54E0G+F;9?_X3
M+0/^?_\`\@R?_$UQ=W>V^H?$""ZM9/,A>Z@VM@C.-@/!YZBNE_X5[I/_`#\7
MO_?:?_$U+:^!=,M+R"YCGNR\,BR*&=<$@Y&?EHE&K.R:00G0IW<6SIZ***ZC
MC"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
EHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@#_V:**
`

#End
