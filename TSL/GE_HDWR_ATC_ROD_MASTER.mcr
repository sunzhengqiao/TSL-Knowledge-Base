#Version 8
#BeginDescription

V1.6_18September2018__bugfix on insertion option #2
v1.5: 15-feb-2012: David Rueda (dr@hsb-cad.com)
- Created copy from TH_ATC_ROD_MASTER to keep custom and general versions
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 6
#KeyWords Wall;TieRod;Hardware
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
v1.5: 15-feb-2012: David Rueda (dr@hsb-cad.com)
	- Created copy from TH_ATC_ROD_MASTER to keep custom and general versions
V1.4_RL_Dec 15 2010_Added a spacing property
V1.3_RL_July 26 2010_Second floor gets no hardware by default
V1.2_RL_July 20_Added a new 3/8"ATC Rule
Version 1.1 CUP rule gets "3/8" x 6" Screw Anchor" instead of "3/8 Bottom Plate Screw Anchor"
Version 1.0 It now has a rule called "None" and will set it to default on second floor walls
Verison 0.9 No need to do opening cleaning, it has been removed
Verison 0.8 Bugfix in map export to slave
Version 0.7 Addapted for the new slave name "GE_HDWR_ATC_ROD_ANCHORS"
Veriosn 0.6 Bugfix for wall split issue
Version 0.5 Removed Internal Warning
Verison 0.4 New distribution and offsets
Version 0.3 Revised for to use 3/8" Bottom Plate Anchor as Default
Version 0.2 Cann pass a Map value from wall hsbData Could use 'type;1' , 'type;2' or 'type;3'
Verison 0.1 Will insert ATC rods and bottom plate anchor
*/ 

Unit (1,"inch");

String arTypes[]={"1/2\" ATC Engineering","1/2\" ATC & Anchor Engineering","CUP Engineering","3/8\" ATC Engineering","None"};	

PropString strType(0,arTypes,"Scenario");

PropDouble dSpacing(0,U(48),"Spacing");

if(_Map.hasString("TYPE")){
	int nMap=_Map.getString("TYPE").atoi();
	if(nMap>0 && nMap<4){
		strType.set(arTypes[nMap-1]);
	//	reportWarning("\nFound map comtaining " + arTypes[nMap-1]);
		_Map.removeAt("TYPE",0);
	}
}




// bOnInsert
if (_bOnInsert){
	
	if(insertCycleCount()>1)eraseInstance();
	
	_Element.append(getElement("\nSelect a Wall"));
	
	int nEngType=getInt("\nSpecify Engineering Type\n1=1/2 ATC 2=1/2 ATC+ANCHOR 3=CUP 4= 3/8 ATC 5=None[1/2/3/4/5] <3>");	
	
	strType.set(arTypes[nEngType-1]);
	//return;	
	
}//END if (_bOnInsert)
//On insert


int nType=arTypes.find(strType)+1;



if(_Element.length()==0)eraseInstance();
Element el=_Element[0];
assignToElementGroup(el,TRUE,0,'Z');


//Make it switch properties if showing up on second floor
if(_bOnInsert || _bOnDbCreated){
	double dTest=_ZW.dotProduct(el.ptOrg()-_PtW);
	if(dTest>U(59)){
		strType.set(arTypes[arTypes.length()-1]);
		reportMessage("\n"+scriptName() + " has been set to not add engineering components to wall " +el.number());
	}
}
		


double dTH=U(.5);
Display dp(12);

dp.textHeight(dTH);

Point3d pt=el.ptOrg()-el.vecZ()*(el.dBeamWidth()-dTH)+el.vecX()*dTH;

_Pt0=pt;

PLine plC;
plC.createCircle(pt,el.vecY(),dTH);
dp.draw(plC);
dp.draw("E",pt,_XW,_YW,0,0);


int nQtyRods=0;

TslInst tslElAll[] = el.tslInstAttached();
for ( int i = 0; i < tslElAll.length(); i++){
	if ( tslElAll[i].scriptName() == _ThisInst.scriptName() && tslElAll[i].handle() != _ThisInst.handle())
	{	
		Element elTsl=tslElAll[i].element();
		String strEl;
		
		if(elTsl.bIsValid())strEl=elTsl.number();
		
		if(strEl==el.number()){
			eraseInstance();
			return;
		}
	}
	if ( tslElAll[i].scriptName()=="GE_HDWR_ATC_ROD_ANCHORS"){
		Element elTsl=tslElAll[i].element();
		String strEl;
		
		if(elTsl.bIsValid())strEl=elTsl.number();
		
		if(strEl==el.number())nQtyRods++;
	}
}

String strRecalc=" Re-distribute";
String strRemove=" Remove Existing";
addRecalcTrigger(_kContext,strRecalc);
addRecalcTrigger(_kContext,strRemove);

if (_kExecuteKey==strRemove){
	for ( int i = 0; i < tslElAll.length(); i++){
		if ( tslElAll[i].scriptName() == "GE_HDWR_ATC_ROD_ANCHORS"){
			Entity arEnts[]=tslElAll[i].entity();
			if(arEnts.length()==0)tslElAll[i].dbErase();
			int nGo=0;
			while(nGo<arEnts.length()){
				Element elT=(Element)arEnts[nGo];
				if(elT.bIsValid()){
					if(elT.handle() == el.handle())tslElAll[i].dbErase();
					//stop on first Element to leave TSL on first floor
					break;
				}
				nGo++;
			}
		}
	}
}


if (_bOnInsert || _kExecuteKey==strRecalc || (_bOnElementConstructed && nQtyRods==0) || _kNameLastChangedProp == "Spacing" ){

	if(strType==arTypes[4])return;

	ElementWallSF elSF=(ElementWallSF)el;
		
	if(!elSF.bIsValid())eraseInstance();
		
	for ( int i = 0; i < tslElAll.length(); i++)if ( tslElAll[i].scriptName() == "GE_HDWR_ATC_ROD_ANCHORS")tslElAll[i].dbErase();
		
	double dWLegt=abs(el.vecX().dotProduct(elSF.ptEndOutline()-elSF.ptStartOutline()))-U(3);
		elSF.ptEndOutline().vis(2);
		elSF.ptStartOutline().vis(6);
	Opening arOp[]=el.opening();
		
	Point3d arPtStartRod[0];
	arPtStartRod.append(el.ptOrg()+U(3)*el.vecX());
	Point3d arPtStartPlate[0];
	//arPtStartPlate.append(arPtStartRod[arPtStartRod.length()-1]+U(24)*el.vecX());

	for(int i=0; i<arOp.length();i++){
		Opening op=arOp[i];
		CoordSys csOp=op.coordSys();
		Point3d ptEnds[]={csOp.ptOrg()-U(5)*csOp.vecX() , csOp.ptOrg()+(U(5)+op.width())*csOp.vecX()};
		
		arPtStartRod.append(ptEnds);
			
			
			
	}

		//add end points
	
	arPtStartRod.append(el.ptOrg()+dWLegt*el.vecX());
		
	arPtStartRod=Line(el.ptOrg(),el.vecX()).orderPoints(arPtStartRod);
		
	Point3d arPtTempRod[0];
		
	for(int r=0;r<arPtStartRod.length()-1; r++){
		Point3d pt1=arPtStartRod[r],pt2=arPtStartRod[r+1];
		double dAddRod=dSpacing;
		double dAddPlate=dSpacing/2;
			
		Point3d ptNextRod=pt1+dAddRod*el.vecX();
		while(TRUE){			
			if(el.vecX().dotProduct(ptNextRod-pt1) * el.vecX().dotProduct(ptNextRod-pt2) <0){
				arPtTempRod.append(ptNextRod);
				ptNextRod	.transformBy(dAddRod*el.vecX());
			}
			else{
				break;
			}
		}
		Point3d ptNextPlate=pt1+dAddPlate*el.vecX();
		while(TRUE){			
			if(el.vecX().dotProduct(ptNextPlate-pt1) * el.vecX().dotProduct(ptNextPlate-pt2) <0){
				arPtStartPlate.append(ptNextPlate);
				dAddPlate=dSpacing;
				ptNextPlate.transformBy(dAddPlate*el.vecX());
			}
			else{
				break;
			}
		}
	}
		
	arPtStartRod.append(arPtTempRod);
	
	//clean up at openings
	for(int i=0; i<arOp.length();i++){
		break;//no opening cleanup
		Opening op=arOp[i];
		CoordSys csOp=op.coordSys();
		Point3d ptEnds[]={csOp.ptOrg() , csOp.ptOrg()+op.width()*csOp.vecX()};

		for(int r=arPtStartRod.length()-1; r>-1;r--){
			double d1=el.vecX().dotProduct(arPtStartRod[r]-ptEnds[0]);
			double d2=el.vecX().dotProduct(arPtStartRod[r]-ptEnds[1]);
			
			if(d1*d2<0)arPtStartRod.removeAt(r);
		}

		if(op.sillHeight()<U(16)){
			for(int p=arPtStartPlate.length()-1; p>-1;p--){
				double d1=el.vecX().dotProduct(arPtStartPlate[p]-ptEnds[0]);
				double d2=el.vecX().dotProduct(arPtStartPlate[p]-ptEnds[1]);
			
				if(d1*d2<0)arPtStartPlate.removeAt(p);
			}
		}	
	}
		
		
	if(_bOnDebug){	
		for(int r=0;r<arPtStartRod.length(); r++){
			Point3d ptR=arPtStartRod[r];
			ptR.vis(3);
		}
		for(int r=0;r<arPtStartPlate.length(); r++){
			Point3d ptP=arPtStartPlate[r];
			ptP.vis(1);
		}
	}
		
		
	Map mpPropRod1_2,mpPropRod3_8,mpPropAnchor;
	mpPropRod1_2.appendString("  Hardware Type","1/2\" ATC Rod");
	mpPropRod3_8.appendString("  Hardware Type","3/8\" ATC Rod");
	mpPropAnchor.appendString("  Hardware Type","3/8\" x 6\" Screw Anchor");
		
		
	if(nType==1){
		TslInst tsl;
		String sScriptName = "GE_HDWR_ATC_ROD_ANCHORS";
	
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		Beam lstBeams[0];
		Entity lstEnts[1];
		Point3d lstPoints[1];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
	
		lstEnts[0] = el;
	
		for(int j=0; j<arPtStartRod.length();j++){
			lstPoints[0]=arPtStartRod[j];
				
			tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString,TRUE, mpPropRod1_2);
		}
	}
	else if(nType==2){
		TslInst tsl;
		String sScriptName = "GE_HDWR_ATC_ROD_ANCHORS";
	
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		Beam lstBeams[0];
		Entity lstEnts[1];
		Point3d lstPoints[1];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
	
		lstEnts[0] = el;
	
		for(int j=0; j<arPtStartRod.length();j++){
			lstPoints[0]=arPtStartRod[j];
			tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString,TRUE, mpPropRod1_2);
		}
		for(int j=0; j<arPtStartPlate.length();j++){
			lstPoints[0]=arPtStartPlate[j];
			tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString,TRUE, mpPropAnchor);
		}
	}
	else if(nType==3){
		TslInst tsl;
		String sScriptName = "GE_HDWR_ATC_ROD_ANCHORS";
	
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		Beam lstBeams[0];
		Entity lstEnts[1];
		Point3d lstPoints[1];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];

		lstEnts[0] = el;

		for(int j=0; j<arPtStartRod.length();j++){
			lstPoints[0]=arPtStartRod[j];
					
			tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString,TRUE, mpPropAnchor);
		}
		for(int j=0; j<arPtStartPlate.length();j++){
			lstPoints[0]=arPtStartPlate[j];
					
			tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString,TRUE, mpPropAnchor);
		}
	}
	else{
		TslInst tsl;
		String sScriptName = "GE_HDWR_ATC_ROD_ANCHORS";
	
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		Beam lstBeams[0];
		Entity lstEnts[1];
		Point3d lstPoints[1];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
	
		lstEnts[0] = el;
	
		for(int j=0; j<arPtStartRod.length();j++){
			lstPoints[0]=arPtStartRod[j];
				
			tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString,TRUE, mpPropRod3_8);
		}

	}
}

#End
#BeginThumbnail



#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="mpIDESettings">
    <dbl nm="PREVIEWTEXTHEIGHT" ut="N" vl="1" />
  </lst>
  <lst nm="mpTslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End