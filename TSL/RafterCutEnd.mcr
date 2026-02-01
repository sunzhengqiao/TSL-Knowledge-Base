#Version 8
#BeginDescription
Last modified by: Alberto Jena (aj@hsb-cad.com)
04.11.2008  -  version 1.0





#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2008 by
*  hsbSOFT N.V.
*  THE NETHERLANDS
*
*  The program may be used and/or copied only with the written
*  permission from hsbSOFT N.V., or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*
* REVISION HISTORY
* -------------------------
*
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 04.11.2008
* version 1.0: 	Pilot version
*
*/

//Script uses mm
double dEps = U(.1,"mm");

double dSymbolSize = U(15);

PropDouble dDepthMayor(0, U(50), T("|Main Depth|"));
PropDouble dLengthMayor(1, U(200), T("|Main Lenght|"));

PropDouble dDepthMinor(2, U(10), T("|Second Depth|"));
PropDouble dLengthMinor(3, U(100), T("|Second Length|"));

//Insert
if( _bOnInsert ){
	//Erase after 1 cycle
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	//Showdialog
	showDialog();
	
	
	//Select beam(s) and insertion point
	PrEntity ssE(T("|Select one or more beams|"), Beam());
	if (ssE.go()) {
		Beam arSelectedBeams[] = ssE.beamSet();

		//insertion point
		//_Pt0 = getPoint(T("|Select an insertion point|"));
		
		String strScriptName = "Rafter Cut End"; // name of the script
		Vector3d vecUcsX(1,0,0);
		Vector3d vecUcsY(0,1,0);
		Beam lstBeams[0];
		Element lstElements[0];
		
		Point3d lstPoints[1];
		lstPoints[0] = _Pt0;
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		Map mapTsl;
		mapTsl.setInt("MasterToSatellite", TRUE);
		setCatalogFromPropValues("MasterToSatellite");
		
		for( int i=0;i<arSelectedBeams.length();i++ ){
			Beam selectedBm = arSelectedBeams[i];
			
			lstBeams.setLength(0);
			lstBeams.append(selectedBm);
			
			TslInst tsl;
			tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
		}
	}
	
	return;
}

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

if( _Map.hasInt("MasterToSatellite") ){
	int bMasterToSatellite = _Map.getInt("MasterToSatellite");
	if( bMasterToSatellite ){
		int bPropertiesSet = _ThisInst.setPropValuesFromCatalog("MasterToSatellite");
		_Map.removeAt("MasterToSatellite", TRUE);
	}
}

//Check if there is a valid beam present
if( _Beam.length() == 0 ){
	eraseInstance();
	return;
}

//Get selected beam
Beam bm = _Beam[0];
if( !bm.bIsValid() ){
	eraseInstance();
	return;
}

//CoordSys of beam
Point3d ptOrgBm = bm.ptCen();
Vector3d vxBm = bm.vecX();
if( vxBm.dotProduct(_ZW) < 0 ){
	vxBm = -bm.vecX();
}
Vector3d vzBm = bm.vecD(_ZW);
if( vzBm.dotProduct(_ZW) < 0 ){//Not sure if this test is really needed; just to be sure
	vzBm = -vzBm;
}
Vector3d vyBm = vzBm.crossProduct(vxBm);

//CoordSys world aligned to beam
Vector3d vyW = vyBm;
Vector3d vzW = _ZW;
Vector3d vxW = vyW.crossProduct(vzW);
vxW.vis(_Pt0, 1);
vyW.vis(_Pt0, 3);
vzW.vis(_Pt0, 150);


//Roof angle
double dRoofAngle = _ZW.angleTo(vzBm, -vyBm);

//Project point on beam axis
Line lnBmX(ptOrgBm - vzBm * .5 * bm.dD(vzBm), vxBm);
//_Pt0 = lnBmX.intersect(Plane(_Pt0, vxW),0);

Quader qd=bm.quader();
Plane plnFace=qd.plFaceD(-vxBm);
_Pt0 = lnBmX.intersect(plnFace, 0);
Point3d ptTool=_Pt0;

/*if (!_Map.hasPoint3d("ptTool"))
{
	_Map.setPoint3d("ptTool", _Pt0);
}
else
{
	ptTool=_Map.getPoint3d("ptTool");
}
*/

if (dDepthMayor>0)
{
	BeamCut bc1 (ptTool+vzBm*dDepthMayor+vxBm*dLengthMayor, vxBm, vyBm, vzBm, dLengthMayor*2, U(1000), dDepthMayor*2, -1, 0, -1);
	bc1.cuttingBody().vis();
	bm.addTool(bc1);
}

if (dDepthMinor>0)
{
	BeamCut bc2 (ptTool+vzBm*dDepthMinor+vxBm*(dLengthMayor+dLengthMinor), vxBm, vyBm, vzBm, (dLengthMayor+dLengthMinor)*2, U(1000), dDepthMayor*2, -1, 0, -1);
	bc2.cuttingBody().vis();
	bm.addTool(bc2);
}

Point3d pt1=ptTool+vzBm*dDepthMayor+vxBm*dLengthMayor; pt1.vis();
_Pt0=pt1;
Point3d pt2=ptTool+vzBm*dDepthMinor+vxBm*(dLengthMayor+dLengthMinor); pt2.vis();

Vector3d vxTool (pt1-pt2);
vxTool.normalize();

Vector3d vzTool = vxTool.crossProduct(vyBm);
vzTool.normalize();

if (vzTool.dotProduct(vzBm)>0)
{
	vzTool=-vzTool;
}

Vector3d vyTool = vxTool.crossProduct(vzTool);
vyTool.normalize();

if (dDepthMinor>0 || dDepthMayor>0)
{
	BeamCut bc3 (pt2, vxTool, vyTool, vzTool, (pt1-pt2).length(), U(1000), U(300), 1, 0, 1);
	bc3.cuttingBody().vis();
	bm.addTool(bc3);
}

//Display
Display dp(-1);

//Draw symbol
dp.draw(PLine(pt1 + vxBm * dSymbolSize, pt1 - vxBm * dSymbolSize));
dp.draw(PLine(pt1 + vyBm * dSymbolSize, pt1 - vyBm * dSymbolSize));
dp.draw(PLine(pt1 + vzBm * dSymbolSize, pt1 - vzBm * dSymbolSize));
dp.textHeight(.2*dSymbolSize);
//dp.draw(scriptName(), _Pt0, vxBm, vyBm, 1.2, 2, _kDevice);





#End
#BeginThumbnail


#End
