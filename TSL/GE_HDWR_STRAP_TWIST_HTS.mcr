#Version 8
#BeginDescription
v1.8: 18.mar.2012: David Rueda (dr@hsb-cad.com)
Inserts HTS twist strap (Simson's HST equivalent) to beam or truss entity (option to attach to an element)
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
//////////////////////////////////		COPYRIGHT				//////////////////////////////////  
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
* v1.8: 18.mar.2012: David Rueda (dr@hsb-cad.com) 
	- Renamed from GE_HDWR_HTS_TWIST_STRAPS to GE_HDWR_STRAP_TWIST_HTS
	- Description updated
* v1.7: 31.jul.2012: David Rueda (dr@hsb-cad.com) 
	- Description added
	- Thumbnail added
* v1.6: 31.jul.2012: David Rueda (dr@hsb-cad.com): 
	- Assigned to 'Z' zone (entity set) instead of 'T' (tooling zone - non plotable)
* v1.5: 15-feb-2012: David Rueda (dr@hsb-cad.com)
	- Created copy from TH_HTS_TWIST_STRAPS to keep custom and general versions
* v1.4: 14.dec.2011: David Rueda (dr@hsb-cad.com):  If cloned by GE_TRUSS_POINTLOAD, strap will be placed from its middle point located on top of higher top plate WHEN HST20
* v1.3: 13.dec.2011: David Rueda (dr@hsb-cad.com):  If cloned by GE_TRUSS_POINTLOAD, strap will be placed starting from bottom of lower top plate WHEN H2.5T
* v1.2: 03.oct.2011: David Rueda (dr@hsb-cad.com):  If cloned by GE_TRUSS_POINTLOAD, strap will be placed starting from bottom of lower top plate
* v1.1: 03.oct.2011: David Rueda (dr@hsb-cad.com):  Props. indexes fixed
* v1.0: 27.jun.2011: David Rueda (dr@hsb-cad.com):  Coded, validations added, ready to be used combined with GE_TRUSS_POINTLOAD tsl
* V0.9_RL_June 18 2010_Treat beam as entity
* V0.8_RL_June10 2010_Revised output name of strap
* V0.7_RL_May 6 2010_Revised insert and added hardware
* V0.6_RL_April 26 2010_Can now attach to a truss entity
* Version 0.5 Formatted output for New Report
* Version 0.4 Added some output
* Version 0.3 Exports to Schedule
* Version 0.2 Added to the display and added right click commands
* Version 0.1 Use for Twist Straps
*/

U(1,"inch");

_Pt0.vis();

String arStrapChoices[]={"HTS16","HTS20","HTS24","HTS28","HTS30","H2.5","H2.5A","H2.5T","H8"};
String strStrapPrompt="\nStrap Type\n [HTS16/HTS20/HTS24/HTS28/HTS30/H2.5/H2.5A/H2.5T/H8] <HTS20>";
	

double arDLength[]={U(16),U(20),U(24),U(28),U(30),U(5.4375),U(5.4375),U(5.4375),U(8)};

double dStrapLUp[]={U(8),U(10),U(12),U(14),U(10),U(2.71875),U(2.71875),U(2.71875),U(4)};
double dStrapLDn[]={U(8),U(10),U(12),U(14),U(20),U(2.71875),U(2.71875),U(2.71875),U(4)};
int arBNeedsTwist[]={1,1,1,1,1,0,0,0,0};

PropString strStrap(0,arStrapChoices,T("Strap type"),1);

double dLength=arDLength[arStrapChoices.find(strStrap)];
//PropDouble dLength(1,arDLength,T("HTS Length"),1);
//dLength.setFormat(_kNone);

int arNFace[]={1,-1};
PropInt nDir(0,arNFace,"Direction",1);
PropInt nSide(1,arNFace,"Side",1);

PropDouble dHeal(0,U(0),T("Heel Height"));




if(_bOnInsert){
	
	PrEntity ssERafter(T("Select a Beam or a Truss Entity"), Beam());
	ssERafter.addAllowedClass(TrussEntity());
	if (ssERafter.go()) {
		Entity ssSet[] = ssERafter.set();
		for(int i=0;i<ssSet.length();i++){
			Entity ent=ssSet[i];
			
			if(ent.bIsKindOf(Beam()) || ent.bIsKindOf(TrussEntity()) ){
				_Entity.append(ent);
				//break;
			}
		}
	}
	

	//_Beam.append(getBeam(T("\nSelect Truss\Rafter Beam to twist on")));
	_Pt0=getPoint("\nSelect insertion Point");
	
	String str=getString(strStrapPrompt);
	str.makeUpper();

	PrEntity ssE(T("Select an Entitie or Element to attach Display to (Optional)"), Entity());
	if (ssE.go()) {
		Entity ssSet[] = ssE.set();
		for(int i=0;i<ssSet.length();i++){
			Entity ent=ssSet[i];
			
			if(ent.bIsKindOf(ElementWall()))_Element.append((Element)ent);
			else{
				Element el=ent.element();
				if(el.bIsValid())_Element.append(el);
			}
		}
	}
	

	
	//PREPARE TO CLONING
	// declare tsl props 
	TslInst tsl;
	String sScriptName = scriptName() ;

	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
	Beam lstBeams[0];
	Entity lstEnts[1];
	Point3d lstPoints[1];
	lstPoints[0]=_Pt0;
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	
	if(arStrapChoices.find(str)>-1){
		lstPropString.append(str);
	}
		
	for(int i=0; i<_Entity.length();i++){
		lstEnts.setLength(1);
		lstEnts[0] = _Entity[i];
		
		Point3d ptRef=_Pt0;
		Beam bm=(Beam)_Entity[i];
		TrussEntity te=(TrussEntity)_Entity[i];
		if(bm.bIsValid())ptRef=bm.ptCen();
		if(te.bIsValid())ptRef=te.coordSys().ptOrg();
		
		
		for(int e=0; e<_Element.length();e++){
			ElementWall elW=(ElementWall)_Element[e];
			if(!elW.bIsValid())continue;
			Point3d arPt[]=elW.plOutlineWall().vertexPoints(TRUE) ;
			arPt=Line(elW.ptOrg(),elW.vecX()).orderPoints(arPt);
			if(arPt.length()<2)continue;
			if(elW.vecX().dotProduct(arPt[0]-ptRef)*elW.vecX().dotProduct(arPt[arPt.length()-1]-ptRef)<0)lstEnts.append(elW);
		}

		tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString );
	}
	eraseInstance();
	return;	
	
}//END if (_bOnInsert)

//Find the beam
Body bm1;
CoordSys csBm;
Element el;
if(_Beam.length() ==0 && _Entity.length()==0 ){
	reportMessage("\nNo Beams found");
	eraseInstance();
	return;
}
else if(_Beam.length()>0){
	bm1=_Beam[0].envelopeBody();
	csBm=_Beam[0].coordSys();
	el=_Beam[0].element();
}
else if(_Entity.length()>0){
	TrussEntity ceTruss=(TrussEntity)_Entity[0];
	Beam bm=(Beam)_Entity[0];
	
	if(ceTruss.bIsValid()){	
		TrussDefinition cdTruss=ceTruss.definition();
		CoordSys csT=ceTruss.coordSys();
				 csT.vis();
		Beam arBmTruss[]=cdTruss.beam();
		
		for(int t=0;t<arBmTruss.length();t++){
			Beam bmNew=arBmTruss[t];
			CoordSys csBmT=bmNew.coordSys();
			if(!bmNew.bIsValid())continue;
			
			Body bdBm=bmNew.envelopeBody();
			csBmT.transformBy(csT);
			bdBm.transformBy(csT);
			Point3d ptEnds[]=bdBm.extremeVertices(csT.vecX());
			double dz=U(0);

			double d1=csT.vecX().dotProduct(_Pt0-ptEnds[0]),d2= csT.vecX().dotProduct(_Pt0-ptEnds[1]) ;
			double dzBm=bdBm.ptCen().Z();
			if(csT.vecX().dotProduct(_Pt0-ptEnds[0]) * csT.vecX().dotProduct(_Pt0-ptEnds[1]) < 0 
				&& bdBm.ptCen().Z() > dz){
					
				dz=bdBm.ptCen().Z();
				bm1=bdBm;
				csBm=csBmT;
			}
		}
	}
	else if(bm.bIsValid()){
		bm1=bm.envelopeBody();
		csBm=bm.coordSys();
		el=bm.element();
	}
}
bm1.vis(2);

Vector3d vx=csBm.vecX(),vy=csBm.vecY(),vz=csBm.vecZ();


String strAddWalls="Add wall(s) to the display";
String strRemoveWalls="Remove all walls from the display";

addRecalcTrigger( _kContext,strAddWalls);
addRecalcTrigger( _kContext,strRemoveWalls);


if(_kExecuteKey == strAddWalls){
	PrEntity ssE(T("Select an Entities or Elements to attach Display to (Optional)"), Entity());
	if (ssE.go()) {
		Entity ssSet[] = ssE.set();
		for(int i=0;i<ssSet.length();i++){
			Entity ent=ssSet[i];
			
			if(ent.bIsKindOf(ElementWall()))_Element.append((Element)ent);
			else{
				Element el=ent.element();
				if(el.bIsValid())_Element.append(el);
			}
			break;
		}
	}
}

if(_kExecuteKey == strRemoveWalls){
	_Element.setLength(0);
}

Display dp(-1),dp2(-1);
dp2.showInDispRep("Engineering Components");
dp2.addHideDirection(_ZW);
//Some display

vx.vis(_Pt0,1);

// a bit of vector play
Vector3d vUp=_ZW;
if(vx.isParallelTo(vUp)){
	reportMessage("\nWrong Selection***Twist Strap cannot be inserted");
	eraseInstance();
	return;
}

if(vx.dotProduct(vUp)<0)vx=-vx;

Vector3d vSide=vUp.crossProduct(vx)*nSide;
vSide.normalize();
Vector3d vxFlat=vSide.crossProduct(vUp);
Vector3d vUpBm=vSide.crossProduct(vx);
vUpBm.normalize();

if(vxFlat.dotProduct(vx)<0)vxFlat=-vxFlat;
vxFlat=vxFlat*nDir;
if(vUpBm.dotProduct(vUp)<0)vUpBm=-vUpBm;

CoordSys csRotate;csRotate.setToRotation(90*nSide,vx,_Pt0);

Vector3d vTopBend1=vUp;
vTopBend1.transformBy(csRotate);
vTopBend1.normalize();
vTopBend1.vis(_Pt0,2);
Vector3d vTopBend2=vTopBend1;
vTopBend2.transformBy(csRotate);
vTopBend2.normalize();
vTopBend2.vis(_Pt0,1);



// now some point and geometry play
double dBmW=bm1.lengthInDirection(vSide);
double dBmH=bm1.lengthInDirection(vUpBm);

Line lnBm(bm1.ptCen(),vx);
_Pt0=lnBm.intersect(Plane(_Pt0,vxFlat),U(0));//closestPointTo(_Pt0);

Plane pnUpper(_Pt0+vUpBm*dBmH/2,vUpBm);
Plane pnLower(_Pt0-vUpBm*dBmH/2,vUpBm);

Line lnUp(_Pt0,vUp);

Point3d arPts[]={lnUp.intersect(pnLower,U(0)),lnUp.intersect(pnUpper,U(0))};
double dDistBetween=U(0);
if(arPts.length()==2)dDistBetween=vUp.dotProduct(arPts[1]-arPts[0]);

if(dHeal>dDistBetween)pnLower.transformBy(-vUp*(dHeal-dDistBetween));



Point3d ptRef=lnUp.intersect(pnLower,U(0));
ptRef.transformBy(vSide*dBmW/2);

double dStrapWidth=U(1.25);
double dStrapThick=U(.125);
double dDrill=U(.125);

ptRef.vis(1);
//ptRef+=_ZW*2;
//Do lower body
double dLL=dStrapLDn[arDLength.find(dLength)];
if(_Map.hasPoint3d("PT_BOTTOM_ON_LOWEST_TOP_PLATE") && strStrap=="H2.5T")
{
	Point3d ptBottomOnPlate=_Map.getPoint3d("PT_BOTTOM_ON_LOWEST_TOP_PLATE");
	dLL=abs(_ZW.dotProduct(ptRef-ptBottomOnPlate));
}
if(_Map.hasPoint3d("PT_TOP_ON_HIGHEST_TOP_PLATE") && strStrap=="HTS20")
{
	Point3d ptTopOfHighestTopPlate=_Map.getPoint3d("PT_TOP_ON_HIGHEST_TOP_PLATE");
	ptRef+=_ZW*_ZW.dotProduct(ptTopOfHighestTopPlate-ptRef);
}
PLine plBdLower;
plBdLower.addVertex(ptRef);
plBdLower.addVertex(ptRef-vUp*dLL);
plBdLower.addVertex(ptRef-vUp*dLL+vSide*dStrapWidth);
plBdLower.addVertex(ptRef-vUp*dStrapWidth+vSide*dStrapWidth);
plBdLower.close();

Body bdLower(plBdLower,vxFlat*dStrapThick,-1);

//Do Upper body
double dLU=dStrapLUp[arDLength.find(dLength)];
if(_Map.hasPoint3d("PT_BOTTOM_ON_LOWEST_TOP_PLATE") && strStrap=="H2.5T")
{
	dLU=dLength-dLL;
}

Point3d ptRef2=ptRef+vxFlat*dStrapWidth;

Point3d ptUp1=Line(ptRef,vUp).intersect(pnUpper,dStrapThick),ptUp2=Line(ptRef2,vUp).intersect(pnUpper,dStrapThick);
Point3d arPtTest[]={ptUp1,ptUp2};
arPtTest=lnUp.orderPoints(arPtTest);

double dL1=vUp.dotProduct(arPtTest[arPtTest.length()-1] - ptRef);
if(dL1>dLU){
	ptUp1=ptRef+vUp*dLU;
	ptUp2=ptRef2+vUp*dLU;
	dLU=0;
	
	PLine plUp1;
	plUp1.addVertex(ptRef-dStrapWidth*vUp);
	plUp1.addVertex(ptUp1);
	plUp1.addVertex(ptUp2);
	plUp1.addVertex(ptRef2);
	plUp1.close();
	
	Body bdUp1(plUp1,vSide*dStrapThick,1);
	bdLower+=(bdUp1);
}
else{
	PLine plUp2;
	plUp2.addVertex(ptRef-dStrapWidth*vUp);
	plUp2.addVertex(ptUp1);
	plUp2.addVertex(ptUp2);
	plUp2.addVertex(ptRef2);
	plUp2.close();
	
	Body bdUp2(plUp2,vSide*dStrapThick,1);
	bdLower+=(bdUp2);
	
	dLU-=dL1;	
}

if(dLU>0){
	
	Plane pnSide(_Pt0-vSide*dBmW/2,-vSide);
	
	Point3d ptUpS1=Line(ptUp1,vTopBend1).intersect(pnSide,dStrapThick),ptUpS2=Line(ptUp2,vTopBend1).intersect(pnSide,dStrapThick);
	Point3d arPtTest[]={ptUp1,ptUp2,ptUpS1,ptUpS2};
	arPtTest=Line(ptUp1,vTopBend1).orderPoints(arPtTest);
	
	double dL2=vTopBend1.dotProduct(arPtTest[arPtTest.length()-1] - arPtTest[0]);
	
	if(dL2>dLU){
		ptUpS1=ptUp1+vTopBend1*dLU;
		ptUpS2=ptUp2+vTopBend1*dLU;
		dLU=0;
		
		PLine plUp1;
		plUp1.addVertex(ptUp1-dStrapThick*vTopBend1);
		plUp1.addVertex(ptUpS1);
		plUp1.addVertex(ptUpS2);
		plUp1.addVertex(ptUp2-dStrapThick*vTopBend1);
		plUp1.close();
	
		Body bdUp1(plUp1,vUpBm*dStrapThick,-1);
		bdLower+=(bdUp1);
	}
	else{
		PLine plUp2;
		plUp2.addVertex(ptUp1-dStrapThick*vTopBend1);
		plUp2.addVertex(ptUpS1);
		plUp2.addVertex(ptUpS2);
		plUp2.addVertex(ptUp2-dStrapThick*vTopBend1);
		plUp2.close();
	
		Body bdUp2(plUp2,vUpBm*dStrapThick,-1);
		bdLower+=(bdUp2);
		dLU-=dL2;
	}
	if(dLU>0){
		Plane pnEnd(ptUpS1+dLU*vTopBend2,vTopBend2);
		
		Point3d ptEnd1=ptUpS1.projectPoint(pnEnd,U(0)),ptEnd2=ptUpS2.projectPoint(pnEnd,U(0));
		
		PLine plUp3;
		plUp3.addVertex(ptUpS1);
		plUp3.addVertex(ptEnd1);
		plUp3.addVertex(ptEnd2);
		plUp3.addVertex(ptUpS2);
		plUp3.close();
	
		Body bdUp3(plUp3,vSide*dStrapThick,1);
		bdLower+=(bdUp3);
	}
	
	
	
}
	
	
	




dp2.draw(bdLower);
dp.draw(bdLower);


///Export

String strPart1="X - Hardware",strPart2="X-Twist Straps";

Group gr(strPart1,strPart2,"");
gr.dbCreate();
gr.setBIsDeliverableContainer(TRUE);
gr.addEntity(_ThisInst,TRUE);	



for(int e=0;e<_Element.length();e++){
	ElementWall elW=(ElementWall)_Element[e];
	
	if(elW.bIsValid())assignToElementGroup(elW,FALSE,0,'Z');
}

if(el.bIsValid())assignToElementGroup(el,FALSE,0,'Z');

model(strStrap);
material("Twist Strap");

dxaout("Twist Strap",strStrap);
dxaout("TH-Item",strStrap);

exportToDxi(TRUE);


Map mapDxaOut;
mapDxaOut.appendInt(strStrap,1);

_Map.setMap("MapDxaOut",mapDxaOut);	


if(_bOnDebug){
	PLine pl;pl.createCircle(ptRef,vx,dStrapWidth);
	dp.draw(pl);

	LineSeg lnSeg(ptRef+vxFlat*U(12),ptRef-vxFlat*U(12));
	dp.draw(lnSeg);
}






















#End
#BeginThumbnail
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
FBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`/_]DH
`


#End
