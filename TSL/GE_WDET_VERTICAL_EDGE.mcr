#Version 8
#BeginDescription
Inserts ladder and side studs in a wall (edge orientation)
v1.2: 21.jul.2012: David Rueda (dr@hsb-cad.com)


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 2
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
* v1.2: 21.jul.2012: David Rueda (dr@hsb-cad.com)
	- Description added
	- Thumbnail added
* v1.1: 08.nov.2011: David Rueda (dr@hsb-cad.com): 	Added info from _Map to side beams
															Added grade and material to blocking from _Map
															Module name changed
* v1.0: 11.oct.2011: David Rueda (dr@hsb-cad.com): 	Added info from _Map to blocking
* v0.2: Release (No author/date found)
*
*/


// SET SOME PROPERTIES

int strProp=0,nProp=0,dProp=0;
String arYN[]={"Yes","No"};

PropString strEmpty0(strProp,"- - - - - - - - - - - - - - - -",T("PLACEMENT PROPERTIES"));strProp++;
strEmpty0.setReadOnly(true);

PropDouble dStartOffset(dProp,U(600, 24),T("  Start Offset"));dProp++;

PropDouble dEndOffset(dProp,U(0, 0),T("  End Offset"));dProp++;

PropDouble dSpacing(dProp,U(600, 24),T("  Spacing"));dProp++;

PropDouble dBlockingLength(dProp,U(200, 8),T("  Blocking Length"));dProp++;

PropString strEmpty1(strProp,"- - - - - - - - - - - - - - - -",T("MATERIAL PROPERTIES"));strProp++;
strEmpty1.setReadOnly(true);

PropString strMat(strProp,"SPF",T("  Material"));strProp++;

PropString strGrade(strProp,"#2",T("  Grade"));strProp++;

//OTHER SETTINGS
int nColor=2;

double dBlkSizeInElVecY=dBlockingLength;
double dBlkSizeInElVecX=U(38, 1.5);

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

String sLength;
if (_Map.hasString("Length"))
{
	sLength= _Map.getString("Length");
	double dAux=sLength.atof();
	dAux=dAux/25.4;
	dBlockingLength.set(dAux);
}

String sInformation;
if(_Map.hasString("Information"))
{
	sInformation=_Map.getString("Information");
}

if(_Map.hasString("Material"))
{
	strMat.set(_Map.getString("Material"));
}

if(_Map.hasString("Grade"))
{
	strGrade.set(_Map.getString("Grade"));
}


//set Module name
String sModuleName="VERTICAL_EDGE_ID_" + _ThisInst.handle() ;

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
dDistL=dDistR=U(10000, 10000);
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
Body bdBlk(_Pt0,el.vecX(),el.vecY(),el.vecZ(),(dDistL+dDistR)/2,U(10000, 600),U(1200, 50),0,1,0);
for(int b=0;b<arBmHorizontal.length();b++){
	Beam bm=arBmHorizontal[b];
	if((bm.type()== _kBlocking || bm.type()==_kSFBlocking) && bm.realBody().hasIntersection(bdBlk) )bm.dbErase();
}


Point3d ptRightOnLeftBm=bmLeft.ptCen()+vx*bmLeft.dD(vx)*.5;
Point3d ptLeftOnRightBm=bmRight.ptCen()-vx*bmRight.dD(vx)*.5;

if(dDistL<dDistR)_Pt0 = _Pt0.projectPoint(Plane(ptRightOnLeftBm+vx*dBlkSizeInElVecX/2,vx),0);
else _Pt0 = _Pt0.projectPoint(Plane(ptLeftOnRightBm-vx*dBlkSizeInElVecX/2,vx),0);


//Check spacing between
double dDistSpace=vx.dotProduct(ptLeftOnRightBm-ptRightOnLeftBm);
if(abs(dBlkSizeInElVecX-dDistSpace)>U(3, 0.125)){
	if(dDistSpace<dBlkSizeInElVecX){
		reportMessage("\nCannot position " + scriptName() + " on element " + el.number() + " because the space is too small");
		eraseInstance();
		return;
	}
	else if(dDistSpace>dBlkSizeInElVecX && dDistSpace<(dBlkSizeInElVecX+el.dBeamHeight())){
		reportMessage("\nCannot position " + scriptName() + " on element " + el.number() + " because the space is too large");
		eraseInstance();
		return;
	}
	else if(dDistSpace>dBlkSizeInElVecX && dDistSpace>(dBlkSizeInElVecX+el.dBeamHeight())){
		if(dDistR>abs(dDistL)){
			Beam bmNew=bmLeft.dbCopy();
			bmNew.transformBy(vx*(dBlkSizeInElVecX+el.dBeamHeight()));
			bmRight=bmNew;
		}
		else{
			Beam bmNew=bmRight.dbCopy();
			bmNew.transformBy(-vx*(dBlkSizeInElVecX+el.dBeamHeight()));
			bmLeft=bmNew;
		}
	}
}

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
	dMaxHeight -= (dEndOffset+dBlkSizeInElVecY*0.5);
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
	
	ptBlock.transformBy((dSpacing+dBlockingLength)*vy);					
	dGrow+=dSpacing+dBlockingLength;
}
if(dOffsetDown>U(0, 0)){//force at the top
	dMaxHeight=vy.dotProduct(arPtBmSide[arPtBmSide.length()-1]-ptOrg);
	arPtBlock.append(_Pt0+(dMaxHeight-dOffsetDown)*vy);
}
		
		
arPtBlock=Line(el.ptOrg(),el.vecY()).orderPoints(arPtBlock);
	
for(int i=0;i<arPtBlock.length();i++){
			
	Beam bm1;		
		
	bm1.dbCreate(arPtBlock[i], vy, vx, vz, dBlockingLength, U(10, 1.5), el.dBeamWidth(), 0, 0, 1);
	bm1.setType(_kBlocking);
	bm1.setColor(nColor);
	bm1.setModule(sModuleName);
	bm1.setHsbId("12");
	bm1.setMaterial(strMat);
	bm1.setGrade(strGrade);
	bm1.setInformation(sInformation);
	bm1.assignToElementGroup(el,TRUE,0,'Z');
}

bmLeft.setColor(nColor);
bmLeft.setModule(sModuleName);
bmLeft.setInformation(sInformation);
bmRight.setColor(nColor);
bmRight.setModule(sModuleName);
bmRight.setInformation(sInformation);

eraseInstance();
return;



























#End
#BeginThumbnail
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
,B@`HHHH`****`/_9
`

#End
