#Version 8
#BeginDescription
Displays length under the wall tag
v0.4: 22.mar.2013: David Rueda (dr@hsb-cad.com)
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 0
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
* v0.4: 22.mar.2013: David Rueda (dr@hsb-cad.com)
	- Name corrected from GE_ WDET_DISPLAY_LENGTH to GE_WDET_DISPLAY_LENGTH (erased space after GE_ )
* v0.3: 15.ago.2012: David Rueda (dr@hsb-cad.com)
	- Thumbnail updated
* v0.2: 12.may.2012: 	David Rueda (dr@hsb-cad.com)
	- Copyright added
	- Thumbnail added
	- Description added
	- Set to store state in DWG (not recalc at dwgin)
* v0.1: 22.jan.2010: 	Randy Laplante
*	Release
*/

Unit (1,"inch");//Script uses inchs

String arYN[]={T("Yes"),T("No")};

PropString strDim(0,_DimStyles,T("DimStyle"),_DimStyles.find("Brockport"));
PropDouble dText(0,U(0),T("Text Height. If 0 uses DimStyle"));
PropDouble dOffset(1,U(14),T("Offset from Wall"));


//Variable for angled walls

int dSwitchAngle=58;

//select and element on insert
// bOnInsert
if (_bOnInsert){
	
	//showDialogOnce("_Default");
	PrEntity ssE("\nSelect a set of elements",Element());
			if (ssE.go())
			{
				Entity ents[0]; 
				ents = ssE.set(); 
				// turn the selected set into an array of elements
				for (int i=0; i<ents.length(); i++)
				{
					if (ents[i].bIsKindOf(Wall()))
					{
						_Element.append((Element) ents[i]);
					}
				}
			}
	
	//PREPARE TO CLONING
	// declare tsl props 
	TslInst tsl;
	String sScriptName = scriptName();

	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
	Beam lstBeams[0];
	Entity lstEnts[1];
	Point3d lstPoints[1];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
		
	for(int i=0; i<_Element.length();i++){
		lstEnts[0] = _Element[i];
		tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString );
	}
	eraseInstance();
	return;	
	
}//END if (_bOnInsert)



ElementWall el=(ElementWall)_Element[0];
_Entity.append(el);

if(!el.bIsValid())eraseInstance();

//Set the stadard Arrow of the Element here.
_Pt0 = el.ptArrow();
setDependencyOnEntity(_Element[0]);
assignToElementGroup(el,TRUE,0,'Z');

TslInst arTSL[]=el.tslInst();
for (int tsl=0; tsl<arTSL.length();tsl++){
	if(arTSL[tsl].scriptName() == scriptName() && arTSL[tsl].handle()!=_ThisInst.handle()){
		eraseInstance();
		return;
	}
}

Point3d ptC;ptC.setToAverage(el.plOutlineWall().vertexPoints(TRUE));

double dx=el.vecX().dotProduct(ptC-_Pt0);
double dzMinMax=el.vecZ().dotProduct(ptC-_Pt0);
double dz=dOffset;

int nZFlag=1;

if(dzMinMax>0){
	dz=dOffset*-1;
	nZFlag=-1;
}

Vector3d vz=el.vecZ()*nZFlag;




String strCode=el.code();
String strNumber=el.number();


CoordSys csNew(_PtW, _XW, _YW,_ZW);


double dAngle=el.vecX().angleTo(_XW);
double dAngle2=el.vecX().angleTo(-_YW);

double dAngleXP=el.vecX().angleTo(_XW);
double dAngleXN=el.vecX().angleTo(-_XW);
double dAngleYP=el.vecX().angleTo(_YW);
double dAngleYN=el.vecX().angleTo(-_YW);

double dd1=dAngleXP+dAngleYP;

if(dAngleXP+dAngleYP-90<2){
	csNew.setToRotation(dAngleXP,_ZW,csNew.ptOrg());//Top Right
}
else if(dAngleXP+dAngleYN-90<2){//Bottom Right
	if(dAngleXP<dSwitchAngle)csNew.setToRotation(dAngleXP*-1,_ZW,csNew.ptOrg());
	else{
		csNew.setToRotation((180-dAngleXP),_ZW,csNew.ptOrg());
	}
}
else if(dAngleXN+dAngleYP-90<2){//Top Left
	if(dAngleXN<dSwitchAngle)csNew.setToRotation(dAngleXN*-1,_ZW,csNew.ptOrg());
	else{
		csNew.setToRotation((180-dAngleXN),_ZW,csNew.ptOrg());
	}
}
else if(dAngleXN+dAngleYN-90<2)csNew.setToRotation(dAngleXN,_ZW,csNew.ptOrg());//Bottom Left

else{
}

int nTextFlag=1;
double dWYMinMax=csNew.vecY().dotProduct(ptC-_Pt0);

if(dWYMinMax>0)nTextFlag=-1;



Display dp(-1);
dp.dimStyle(strDim);
if(dText>0)dp.textHeight(dText);




Beam arBm[]=el.beam();
Point3d arPtExtrem[0];

for(int i=0;i<arBm.length();i++){
	Beam bm=arBm[i];
	if(bm.type()== _kSFBottomPlate)arPtExtrem.append(bm.realBody().extremeVertices(el.vecX()));
}
	
if(arPtExtrem.length()==0)arPtExtrem.append(el.plEnvelope().vertexPoints(TRUE));
arPtExtrem=Line(_Pt0,el.vecX()).orderPoints(arPtExtrem);

double dLength=U(0);
if(arPtExtrem.length()>1)dLength=el.vecX().dotProduct(arPtExtrem[arPtExtrem.length()-1]-arPtExtrem[0]);

String str;
str.formatUnit(dLength,strDim);

Point3d ptDraw=_Pt0+vz*dOffset;
dp.draw(str,ptDraw,csNew.vecX(),csNew.vecY(),0,0);
	
	








#End
#BeginThumbnail
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
MQVA1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`?_9
`


#End
