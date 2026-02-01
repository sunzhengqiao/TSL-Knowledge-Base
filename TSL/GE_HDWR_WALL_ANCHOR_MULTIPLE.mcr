#Version 8
#BeginDescription
v1.10: 15.jun.2014: David Rueda (dr@hsb-cad.com)
Inserts several wall anchoring systems on selected wall
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 10
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
v1.10: 15.jun.2014: David Rueda (dr@hsb-cad.com)
	- Added functionality to insert other anchor TSL types
	- Code set to easier addition of children anchor TSLs
	- Enhanced auto deletion and recalc triggers to work with any TSL declared in list of anchors inserted by this instance
v1.9: 18.mar.2012: David Rueda (dr@hsb-cad.com)
	- Renamed from "GE_HDWR_ATC_ROD_MASTER" to "GE_HDWR_WALL_ANCHOR_MULTIPLE"
v1.8: 01.nov.2012: David Rueda (dr@hsb-cad.com)
	- Child TSL name changed from "GE_HDWR_ATC_ROD_ANCHOR" to "GE_HDWR_WALL_ANCHOR"
v1.7: 26.oct.2012: David Rueda (dr@hsb-cad.com)
	- Code changed to use string variable instead of typing text when clonning child TSL
	- Child TSL name changed from "GE_HDWR_ATC_ROD_ANCHORS" to "GE_HDWR_ATC_ROD_ANCHOR"
v1.6: 10.jul.2012: David Rueda (dr@hsb-cad.com)
	- Description added
	- Thumbnail added
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
String arTypes[0], arTSLNames[0], strSelectMessage="\nSpecify Engineering Type: ";
int nC=1;
arTypes.append("1/2\" ATC Engineering");				arTSLNames.append("GE_HDWR_WALL_ANCHOR");		strSelectMessage+=" "+nC+"= 1/2 ATC;";			nC++;
arTypes.append("1/2\" ATC & Anchor Engineering");		arTSLNames.append("GE_HDWR_WALL_ANCHOR");		strSelectMessage+=" "+nC+"= 1/2 ATC+Anchor;";	nC++;
arTypes.append("CUP Engineering");						arTSLNames.append("GE_HDWR_WALL_ANCHOR");		strSelectMessage+=" "+nC+"= CUP; ";			nC++;
arTypes.append("3/8\" ATC Engineering");				arTSLNames.append("GE_HDWR_WALL_ANCHOR");		strSelectMessage+=" "+nC+"= 3/8 ATC;";			nC++;
arTypes.append("Adhesive Anchor");						arTSLNames.append("GE_HDWR_ANCHOR_ADHESIVE");	strSelectMessage+=" "+nC+"= Adhesive;";		nC++;
arTypes.append("Embedded Anchor");					arTSLNames.append("GE_HDWR_ANCHOR_EMBEDDED");	strSelectMessage+=" "+nC+"= Embedded;";		nC++;
arTypes.append("J-Bolt Anchor");							arTSLNames.append("GE_HDWR_ANCHOR_J-BOLT");		strSelectMessage+=" "+nC+"= J-Bolt;";			nC++;
arTypes.append("Screw Anchor");						arTSLNames.append("GE_HDWR_ANCHOR_SCREW");		strSelectMessage+=" "+nC+"= Screw;";			nC++;
arTypes.append("MAS Anchor");							arTSLNames.append("GE_HDWR_ANCHOR_MAS");			strSelectMessage+=" "+nC+"= MAS;";			nC++;
arTypes.append("None");									arTSLNames.append(" ");										strSelectMessage+=" "+nC+"= None";
strSelectMessage+=" -- [";
for(int i=0;i<arTypes.length();i++)
{
	strSelectMessage+=i+1;
	if(i<arTypes.length()-1)
		strSelectMessage+="/ ";
	else
		strSelectMessage+="]";
}

PropString strType(0,arTypes,"Scenario");
PropDouble dSpacing(0,U(48),"Spacing");

if(_Map.hasString("TYPE")){
	int nMap=_Map.getString("TYPE").atoi();
	if(nMap>0 && nMap<arTypes.length()){
		strType.set(arTypes[nMap-1]);
		_Map.removeAt("TYPE",0);
	}
}

// bOnInsert
if (_bOnInsert){
	
	if(insertCycleCount()>1)eraseInstance();
	
	_Element.append(getElement("\nSelect a Wall"));
	
	int nEngType=getInt(strSelectMessage);	
	strType.set(arTypes[nEngType-1]);
	reportMessage(nEngType);
	//return;	
	
}//END if (_bOnInsert)
//On insert

int nType=arTypes.find(strType)+1;
String sTSLToClone=arTSLNames[arTypes.find(strType)];

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
for ( int i = 0; i < tslElAll.length(); i++)
{
//	if ( tslElAll[i].scriptName() == _ThisInst.scriptName() && tslElAll[i].handle() != _ThisInst.handle())
	if ( arTSLNames.find(tslElAll[i].scriptName(),-1) > -1 && tslElAll[i].handle() != _ThisInst.handle())
	{	
		Element elTsl=tslElAll[i].element();
		String strEl;
		
		if(elTsl.bIsValid())strEl=elTsl.number();
		
		if(strEl==el.number()){
			eraseInstance();
			return;
		}
	}
//	if ( tslElAll[i].scriptName()==sTSLToClone){
	if ( arTSLNames.find(tslElAll[i].scriptName(),-1) >-1){
		
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
	for ( int i = 0; i < tslElAll.length(); i++)
	{
//		if ( tslElAll[i].scriptName() == sTSLToClone)
		if ( arTSLNames.find(tslElAll[i].scriptName(),-1) > -1)
		{
			Entity arEnts[]=tslElAll[i].entity();
			if(arEnts.length()==0)
				tslElAll[i].dbErase();
			int nGo=0;
			while(nGo<arEnts.length()){
				Element elT=(Element)arEnts[nGo];
				if(elT.bIsValid()){
					if(elT.handle() == el.handle())
						tslElAll[i].dbErase();
					//stop on first Element to leave TSL on first floor
					break;
				}
				nGo++;
			}
		}
	}
}

if (_bOnInsert || _kExecuteKey==strRecalc || (_bOnElementConstructed && nQtyRods==0) || _kNameLastChangedProp == "Spacing" ){

	ElementWallSF elSF=(ElementWallSF)el;
		
	if(!elSF.bIsValid())eraseInstance();
		
	for ( int i = 0; i < tslElAll.length(); i++)
//		if ( tslElAll[i].scriptName() == sTSLToClone)
		if( arTSLNames.find(tslElAll[i].scriptName(),-1) >-1)
			tslElAll[i].dbErase();

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
		
	if(strType==arTypes[arTypes.length()-1])
	{
		return;
	}
		
	Map mpPropRod1_2,mpPropRod3_8,mpPropAnchor;
	mpPropRod1_2.appendString("  Hardware Type","1/2\" ATC Rod");
	mpPropRod3_8.appendString("  Hardware Type","3/8\" ATC Rod");
	mpPropAnchor.appendString("  Hardware Type","3/8\" x 6\" Screw Anchor");
		
	reportMessage("\nChild TSL: "+sTSLToClone);
	if(nType==1){
		TslInst tsl;
		String sScriptName = sTSLToClone;
	
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
		String sScriptName = sTSLToClone;
	
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
		for(int j=0; j<arPtStartPlate.length();j++){
			lstPoints[0]=arPtStartPlate[j];
			tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString,TRUE, mpPropAnchor);
		}
	}
	else if(nType==3){
		TslInst tsl;
		String sScriptName = sTSLToClone;
	
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
	else // All children TSL's other than this script
	{
		TslInst tsl;
		String sScriptName = sTSLToClone;
	
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		Beam lstBeams[0];
		Entity lstEnts[1];
		Point3d lstPoints[1];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
	
		lstEnts[0] = el;
	
		for(int j=0; j<arPtStartRod.length();j++)
		{
			Point3d pt=arPtStartRod[j];
			Vector3d vz=el.vecZ();
			pt+=vz*(vz.dotProduct(el.ptOrg()-pt)-el.dBeamWidth()*.5 );
			lstPoints[0]=pt;
			tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString,TRUE, mpPropRod3_8);
		}
	}
}
#End
#BeginThumbnail
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
0*`"BBB@`HHHH`****`/_V8HH
`



#End
