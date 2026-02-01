#Version 8
#BeginDescription
Assign the weight to the windows and doors base on the type of glass and also the timber and their area.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 05.03.2014 - version 1.3
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2009 by
*  hsbSOFT
*  IRELAND
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
* date: 22.01.2013
* version 1.0: Release Version
*
* date: 14.02.2013
* version 1.1: Fix issue when the TSL was part of the wall TSLs
*/

_ThisInst.setSequenceNumber(-60);

Unit(1,"mm"); // script uses mm

String sArNY[] = {T("No"), T("Yes")};

String sGlassTypes[] = {T("|SG 4mm|"), T("|SG 6.4mm|"), T("|DG 2 x 4mm|"), T("|DG 4mm + 6.4mm|"), T("|DG 2 x 6.4mm|")};
double dGlassFactor[]={10, 15, 20, 25, 30};
PropString sGlassType(0, sGlassTypes, T("|Glass Type|"));

String sWindowFrameTypes[] = {T("|Redwood|"), T("|Sapele|"), T("|Meranti|")};
double dTimberFactor[]={510, 640, 710};
PropString sWindowFrameType(1, sWindowFrameTypes, T("|Window frame type|"));

PropString sFitted(2, sArNY, T("|Factory Fitted|"));

PropDouble dNewScale(0, 1, T("|Symbol Scale|"));

if (_bOnDbCreated || _bOnInsert) setPropValuesFromCatalog(_kExecuteKey);

int nGlass=sGlassTypes.find(sGlassType, 0);
int nTimber=sWindowFrameTypes.find(sWindowFrameType, 0);
int nFitted=sArNY.find(sFitted, 0);


if(_bOnInsert)
{
	if (insertCycleCount()>1) { eraseInstance(); return; }
	if (_kExecuteKey=="")
		showDialog();

	PrEntity ssE(T("Select one or More Openings"), Opening());
	if( ssE.go() ){
		_Entity.append(ssE.set());
	}


	TslInst tsl;
	String sScriptName = scriptName(); // name of the script
	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
	Entity lstEnts[0];
	Beam lstBeams[0];
	Point3d lstPoints[0];

	int lstPropInt[0];
	String lstPropString[0];
	double lstPropDouble[0];

	lstPropString.append(sGlassType);
	lstPropString.append(sWindowFrameType);
	lstPropString.append(sFitted);	
	lstPropDouble.append(dNewScale);
	
	Map mpToClone;
	mpToClone.setInt("ExecutionMode",0);
	
	for (int i=0; i<_Entity.length(); i++)
	{
		Opening op=(Opening) _Entity[i];
		
		if (op.bIsValid())
		{
			Element elNew=op.element();

			ElementWall el=(ElementWall) elNew;

			if (!el.bIsValid()) {eraseInstance(); return;}
			
			
			lstEnts.setLength(0);
			lstEnts.append(op);
			lstEnts.append(el);
			tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mpToClone);
		}
	}
	
	_Map.setInt("ExecutionMode",0);
	eraseInstance();
	return;
}

if( _Opening.length() == 0 ) {eraseInstance(); return;}

Opening op = _Opening[0];

if (!op.bIsValid()){eraseInstance(); return;}

Element elNew=op.element();

ElementWall el=(ElementWall) elNew;

if (!el.bIsValid()) {eraseInstance(); return;}

CoordSys csEl = el.coordSys();
Vector3d vx=csEl.vecX();
Vector3d vy=csEl.vecY();
Vector3d vz=csEl.vecZ();

int nExternal=el.exposed();

if (nExternal==false) {eraseInstance(); return;}

//_Pt0=el.ptOrg();


String strChangeEntity = T("Recalculate weight");
addRecalcTrigger(_kContext, strChangeEntity );
if (_bOnRecalc && _kExecuteKey==strChangeEntity) {
	_Map.setInt("ExecutionMode",0);
}

if (_kNameLastChangedProp==T("|Factory Fitted|"))
{
	_Map.setInt("ExecutionMode",0);
}

if (_bOnElementConstructed)
{
	_Map.setInt("ExecutionMode",0);
}

int nExecutionMode = 1;

if (_Map.hasInt("ExecutionMode"))
{
	nExecutionMode = _Map.getInt("ExecutionMode");
}


if (nExecutionMode==0)
{
	TslInst tslAll[]=el.tslInstAttached();
	for (int i=0; i<tslAll.length(); i++)
	{
		if ( tslAll[i].scriptName() == scriptName() && tslAll[i].handle() != _ThisInst.handle() )
		{
			Entity ent[]=tslAll[i].entity();
			String sOpHandle=ent[0].handle();
			if (sOpHandle==op.handle())
			{
				tslAll[i].dbErase();
			}
		}
	}
	
	int opType=op.openingType();
	
	PLine pl=op.plShape();
	Point3d ptVertex[]=pl.vertexPoints(true);
	Point3d ptCenter;
	ptCenter.setToAverage(ptVertex);
	
	_Pt0=ptCenter+vz*abs(vz.dotProduct(ptCenter-el.zone(10).ptOrg()))+vz*U(300)*dNewScale;
	
	double dWeight=0;
	
	if (opType==_kDoor)
	{
		//Calculation for a door
		
		dWeight=65;
		
	}
	else if(opType==_kWindow || opType==_kOpening || opType==_kAssembly)
	{
		//Calculation for a window
		//All the values bellow ae been provider by CCG window Provider in an excel sheet

		double dOpWidth=op.width();
		double dOpHeight=op.height();
		
		double dSides=0.003411*dOpHeight/1000*2;
		double dTop=0.003411*dOpWidth/1000;
		double dBottom=0.003171*dOpWidth/1000;
		
		double dHorBorder=(0.003231*(dOpWidth-88)/1000*2)-0.0006;
		double dVerBorder=(0.003231*(dOpHeight-86)/1000*2)-0.0006;

		double dTotalTimber=dSides+dTop+dBottom+dHorBorder+dVerBorder;
		
		double dGlassWidth=dOpWidth-U(86)-U(101);
		double dGlassHeight=dOpHeight-U(88)-U(101);
		
		double dGlassArea=dGlassWidth/1000*dGlassHeight/1000;
		
		double dTimberWeight=dTotalTimber*dTimberFactor[nTimber];
		
		double dGlassWeight=dGlassArea*dGlassFactor[nGlass];
		
		dWeight=dTimberWeight+dGlassWeight+4; //4 because of the fixings
	
	}
	
	if (dWeight>0)
	{
		Map mpWeight;
		
		String sWeight;
		sWeight.formatUnit(dWeight, 2, 2);
		mpWeight.setDouble("TotalWeight", dWeight);
		mpWeight.setInt("FactoryFitted", nFitted);
		
		op.setSubMapX("HSB_OpeningInfo", mpWeight);
	}
	
}

_Map.setInt("ExecutionMode",1);

//double dNewScale=1;

PLine plYes(vy);
Point3d ptA=_Pt0+vx*U(230)*dNewScale-vz*U(180)*dNewScale;
ptA.vis(1);
plYes.addVertex(_Pt0-vx*U(70)*dNewScale+vz*U(130)*dNewScale);
plYes.addVertex(_Pt0-vx*U(230)*dNewScale-vz*U(30)*dNewScale);
plYes.addVertex(_Pt0-vx*U(70)*dNewScale+vz*U(25)*dNewScale);
plYes.addVertex(_Pt0+vx*U(150)*dNewScale-vz*U(160)*dNewScale);
plYes.close();
plYes.vis();


PLine plNo(vy);
plNo.addVertex(_Pt0);
plNo.addVertex(_Pt0-vx*U(130)*dNewScale-vz*U(180)*dNewScale);
plNo.addVertex(_Pt0-vx*U(230)*dNewScale-vz*U(180)*dNewScale);
plNo.addVertex(_Pt0-vx*U(64)*dNewScale+vz*U(50)*dNewScale);
plNo.addVertex(_Pt0-vx*U(230)*dNewScale+vz*U(280)*dNewScale);
plNo.addVertex(_Pt0-vx*U(130)*dNewScale+vz*U(280)*dNewScale);
plNo.addVertex(_Pt0-vx*U(0)*dNewScale+vz*U(100)*dNewScale);

plNo.addVertex(_Pt0+vx*U(130)*dNewScale+vz*U(280)*dNewScale);
plNo.addVertex(_Pt0+vx*U(230)*dNewScale+vz*U(280)*dNewScale);
plNo.addVertex(_Pt0+vx*U(64)*dNewScale+vz*U(50)*dNewScale);
plNo.addVertex(_Pt0+vx*U(230)*dNewScale-vz*U(180)*dNewScale);
plNo.addVertex(_Pt0+vx*U(130)*dNewScale-vz*U(180)*dNewScale);
plNo.close();

PLine plToDraw;

int nColor=-1;
if (nFitted)
{
	nColor=3;
	plToDraw=plYes;
}
else
{
	plToDraw=plNo;
	nColor=1;
}


Display dp(nColor);
dp.draw(plToDraw);


_ThisInst.assignToElementGroup(el, true, 0, 'E');
#End
#BeginThumbnail

#End
