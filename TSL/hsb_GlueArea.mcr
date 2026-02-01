#Version 8
#BeginDescription
Create a glue area that can be display as an area or as a line.

Modified by: Alberto Jena (alberto.jena@hsbcad.com)
Date: 01.11.2017 - version 1.4
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2008 by
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
*/

//Units
Unit(1,"mm");

_ThisInst.setSequenceNumber(50);

int nValidZones[]={1,2,3,4,5,6,7,8,9,10};
int nRealZones[]={1,2,3,4,5,-1,-2,-3,-4,-5};
//Next int nInt available=50;
//Next int nString available=56;
//Next int nDouble=50;

PropInt nZones (0, nValidZones, T("Zone to be glued"));

PropInt nToolingIndex(1, 51, T("Tool index"));

PropDouble dToolSize(0, U(50), T("Tool size"));

PropString sLineType (0, _LineTypes, T("Line Type"));

String sType[]={"Line", "Area"};

PropString sDisplayTypes (1, sType, T("Display type"));

int nDisplayType=sType.find(sDisplayTypes, 0);

//double dMinValidArea=U(12);
//double dDistCloseToEdge=U(25);

if (_bOnDbCreated || _bOnInsert) setPropValuesFromCatalog(_kExecuteKey);

if( _bOnInsert )
{
	if (insertCycleCount()>1) { eraseInstance(); return; }
	if (_kExecuteKey=="")
		showDialog();

	PrEntity ssE(T("Select one element"), Element());
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	_Pt0=getPoint("Pick star point");
	_PtG.append(getPoint("Pick end point"));
	
	return;
}

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

if( _Element.length() == 0 ){eraseInstance(); return;}

if (_bOnElementConstructed)
{
	_Map.setInt("ExecutionMode",0);
}

int nExecutionMode = 1;
if (_Map.hasInt("ExecutionMode"))
{
	nExecutionMode = _Map.getInt("ExecutionMode");
}

Element el = (Element) _Element[0];
if (!el.bIsValid())
{
	eraseInstance();
	return;
}

int nZone=nRealZones[nValidZones.find(nZones, 0)];

CoordSys cs =el.coordSys();
Vector3d vx = cs.vecX();
Vector3d vy = cs.vecY();
Vector3d vz = cs.vecZ();

ElemZone elz=el.zone(nZone);

Plane plnZ(elz.ptOrg(), vz);
plnZ.vis(1);

_Pt0=plnZ.closestPointTo(_Pt0);
_PtG[0]=plnZ.closestPointTo(_PtG[0]);

Point3d ptDraw = _Pt0-vz*U(100);
Display dspl (-1);
dspl.lineType(sLineType);


//dspl.dimStyle(sDimLayout);
PlaneProfile pp(cs);
PLine plExport(vz);

if (nDisplayType==0)//Line
{
	PLine pl1(vz);
	pl1.addVertex(_Pt0);
	pl1.addVertex(_PtG[0]);
	dspl.draw(pl1);
	
	Vector3d vxDisplay=_Pt0-_PtG[0];
	vxDisplay.normalize();
	Vector3d vyDisplay=vxDisplay.crossProduct(vz);
	
	plExport.addVertex(_Pt0-vyDisplay*2);
	plExport.addVertex(_Pt0+vyDisplay*2);
	plExport.addVertex(_PtG[0]+vyDisplay*2);
	plExport.addVertex(_PtG[0]-vyDisplay*2);
	plExport.close();
	
	pp.joinRing(plExport, false);
}
else //Area
{
	Vector3d vxDisplay=_Pt0-_PtG[0];
	vxDisplay.normalize();
	Vector3d vyDisplay=vxDisplay.crossProduct(vz);
	
	plExport.addVertex(_Pt0-vyDisplay*dToolSize*0.5);
	plExport.addVertex(_Pt0+vyDisplay*dToolSize*0.5);
	plExport.addVertex(_PtG[0]+vyDisplay*dToolSize*0.5);
	plExport.addVertex(_PtG[0]-vyDisplay*dToolSize*0.5);
	plExport.close();
	dspl.draw(plExport);
	
	pp.joinRing(plExport, false);
}


_Map.setInt("ToolIndex", nToolingIndex);
_Map.setInt("Zone", nZone);
_Map.setPoint3d("StartPoint", _Pt0);
_Map.setPoint3d("EndPoint", _PtG[0]);
_Map.appendPLine("Shape", plExport);

assignToElementGroup(_Element[0], TRUE, nZone, 'E');
return;
#End
#BeginThumbnail




#End