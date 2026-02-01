#Version 8
#BeginDescription
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 23.02.2011
* version 1.10


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 10
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
* REVISION HISTORY
* -------------------------
*
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 04.09.2008
* version 1.0: Release Version

* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 03.03.2008
* version 1.3: Release Version
*
* date: 24.08.2009
* version 1.4: Add the option to specify an extrusion profile for the PointLoad Beams
*
* date: 09.10.2009
* version 1.5: Fix the module code
*
* date: 02.11.2009
* version 1.6: Set the beam type to Stud
*
* date: 03.11.2009
* version 1.6: 	Fix the issue when the poinload is insert in a wall with 2 bottom plates like the SuperFrame
*				Fix the issue of duplicated child TSLs when the drawing is open.
*				Set the beam type to Stud
*				Change the Display a bit
*
* date: 06.04.2010
* version 1.7: Fix the Orientation of the extrusion profile beams
*
* date: 22.09.2010
* version 1.8: Fix issue when the poinload is insert in the edge of the element and can not find intersection with the top and bottom plate
*
* date: 02.02.2011
* version 1.9: Added ability to notch around Beams with Beamcode Token Position 0 = "H"
*
* date: 23.02.2011
* version 1.10: Add the label N to the beams that are notch
*/

_ThisInst.setSequenceNumber(-90);

Unit (1,"mm");
double dEps = U(0.1);

//-------------------------------------------------------------------------------------------------------------------------------------------
//                                                                             Userdefined lists
int arNBmTypeToDelete[] = {
	_kStud,
	_kBlocking,
	_kSFBlocking
};

int arNHsbIdToDelete[] = {
	114 //stud
};

//-------------------------------------------------------------------------------------------------------------------------------------------
//                                                                                  Properties
PropInt nNrOfBms(0,1,"Number of beams");
PropString sExtrusionProfile(1, ExtrProfile().getAllEntryNames(), T("|Extrusion profile name|"));
PropString sDimStyle(0, _DimStyles, "Text style");


if( _bOnInsert ){
	_Element.append(getElement(T("Select an element")));
	
	return;
}

if( _Element.length()==0 ){reportNotice("\nNO ELEMENT\n");eraseInstance();return;}

Element el = _Element[0];

if( _Map.hasMap("MapElement") ){
	Map mapElement = _Map.getMap("MapElement");
	int nBm = 0;
	while( mapElement.hasEntity("bmNew" + nBm) ){
		Entity ent= mapElement.getEntity("bmNew" + nBm);
		ent.dbErase();
		nBm++;
	}
}

Vector3d vx = el.vecX();
Vector3d vy = el.vecY();
Vector3d vz = el.vecZ();

double dBmH = el.dBeamWidth();
double dBmW = el.dBeamHeight();

if (sExtrusionProfile != _kExtrProfRectangular)
{
	ExtrProfile ep(sExtrusionProfile ); 

	PlaneProfile ppExtProf();
	ppExtProf=ep.planeProfile();
	LineSeg ls=ppExtProf.extentInDir(_XW);
	dBmW=abs(_XW.dotProduct(ls.ptStart()-ls.ptEnd()));
}
else
{
	dBmW = el.dBeamHeight();
}



//Project _Pt0 on front of zone 0
_Pt0 = _Pt0.projectPoint(Plane(el.ptOrg(), vz),0);
Point3d ptInsert = _Pt0 + vy * vy.dotProduct(el.ptOrg() - _Pt0);

Map mapThisPointLoad = _Map;

//-------------------------------------------------------------------------------------------------------------------------------------------
//                                                                      Find top and bottom beam

Beam arBm[] = el.beam();

int arNBmTypeTop[] = {
	_kSFTopPlate,
	_kTopPlate,
	_kSFAngledTPLeft,
	_kSFAngledTPRight
};
int arNBmTypeBottom[] = {
	_kSFBottomPlate
};

Beam arBmTop[0];
Beam arBmBottom[0];
for(int i=0;i<arBm.length();i++){
	Beam bm = arBm[i];
	String sBeamCode=bm.beamCode();
	if( arNBmTypeTop.find(bm.type()) != -1 && sBeamCode.token(0)!="H" ){
		arBmTop.append(bm);
	}
	else if( arNBmTypeBottom.find(bm.type()) != -1 ){
		arBmBottom.append(bm);
	}
}
//Check if there are beams to stretch to.
if(arBmTop.length() == 0 || arBmBottom.length() == 0)return;

//Body to find intersection with the Top and bottom plate
Body bdLocation(ptInsert, vy, vx, vz, U(12000), nNrOfBms * dBmW, dBmH, 0, 0, 0);
bdLocation.vis(3);

//Beam to stretch to on top.
Beam bmTop;
double dMin;
int bMinSet = FALSE;
for(int i=0;i<arBmTop.length();i++){
	Beam bm = arBmTop[i];
	Body dbBm=bm.realBody();
	
	//Point3d ptBmMin = bm.ptRef() + bm.vecX() * bm.dLMin();
	//Point3d ptBmMax = bm.ptRef() + bm.vecX() * bm.dLMax();
	//double dBmMin = vx.dotProduct(ptBmMin - ptInsert);
	//double dBmMax = vx.dotProduct(ptBmMax - ptInsert);

	if (!bdLocation.hasIntersection(dbBm)) continue;
	//if( (dBmMin * dBmMax) > 0 ) continue;
		
	Line ln(bm.ptCen(), bm.vecX());
	Point3d ptIntersect = ln.intersect(Plane(ptInsert, vx),0);
	double dDist = vy.dotProduct(ptIntersect - ptInsert);
	
	if( !bMinSet ){
		dMin = dDist;
		bmTop = bm;
		bMinSet = TRUE;
	}
	else{
		if( (dMin - dDist) > dEps ){
			dMin = dDist;
			bmTop = bm;
		}
	}
}

//Beam to stretch to on bottom
Beam bmBottom;
double dMax;
int bMaxSet = FALSE;
for(int i=0;i<arBmBottom.length();i++){
	Beam bm = arBmBottom[i];
	Body dbBm=bm.realBody();
	//Point3d ptBmMin = bm.ptRef() + bm.vecX() * bm.dLMin();
	//Point3d ptBmMax = bm.ptRef() + bm.vecX() * bm.dLMax();
	//double dBmMin = vx.dotProduct(ptBmMin - ptInsert);
	//double dBmMax = vx.dotProduct(ptBmMax - ptInsert);
	
	if (!bdLocation.hasIntersection(dbBm)) continue;
	//if( (dBmMin * dBmMax) > 0 ) continue;

	Line ln(bm.ptCen(), bm.vecX());
	Point3d ptIntersect = ln.intersect(Plane(ptInsert, vx),0);
	double dDist = vy.dotProduct(ptIntersect - ptInsert);

	if( !bMaxSet ){
		dMax = dDist;
		bmBottom = bm;
		bMaxSet = TRUE;
	}
	else{
		if( (dDist - dMax) > dEps ){
			dMax = dDist;
			bmBottom = bm;
		}
	}
}

String sGrade;
String sMat;
String sName;

for (int i=0; i<arBm.length(); i++)
{
	if (arBm[i].hsbId()=="114")
	{
		sGrade=arBm[i].grade();
		sMat=arBm[i].material();
		sName=arBm[i].name();
		break;
	}
}



//Check if there is a valid top and bottom beam
if( !bmTop.bIsValid() || !bmBottom.bIsValid() ) return;

String sModuleCode=el.code()+el.number()+_ThisInst.handle();

Map mapElement;
Body bdPL;
Beam bmBeamsInPointLoad[0];
for(int j=0;j<nNrOfBms;j++){
	if( mapThisPointLoad.hasPoint3d("ptBm" + j) ){
		Point3d ptBm = mapThisPointLoad.getPoint3d("ptBm" + j);
		if( j==0 ){
			_Pt0 = ptBm;
		}
		Beam bmNew;
		bmNew.dbCreate(ptBm, vy, -vx, vz, U(100), dBmW, dBmH, 0, -1, -1);
		bmNew.stretchDynamicTo(bmTop);
		bmNew.stretchDynamicTo(bmBottom);
		bmNew.setExtrProfile(sExtrusionProfile);
		bdPL.addPart(bmNew.realBody());
		mapElement.setEntity("bmNew" + j, bmNew);
		bmNew.setModule(sModuleCode);
		bmNew.setHsbId(138);
		bmNew.setType(_kStud);
		
		bmNew.setName(sName);
		bmNew.setGrade(sGrade);
		bmNew.setMaterial(sMat);
		bmNew.setSubLabel2("Manufactured Element");
		bmNew.setColor(53);
		
		bmNew.assignToElementGroup(el, TRUE, 0, 'Z');
		bmBeamsInPointLoad.append(bmNew);
	}
	else{
		return;
	}
}

_Map.setMap("MapElement",mapElement);

Beam arBmThisEl[] = el.beam();
for(int j=0;j<arBmThisEl.length();j++){
	Beam bm = arBmThisEl[j];
	if( arNBmTypeToDelete.find(bm.type()) == -1 )continue;
	if( arNHsbIdToDelete.find(bm.hsbId().atoi()) == -1 )continue;
	
	if( bdPL.hasIntersection(bm.realBody()) ){
		bm.dbErase();
	}
}

//Check if there is any beam required to notch, indicated by Beamcode H in Token Position 0
Beam bmWithTool[0];

for (int i=0; i<arBm.length(); i++)
{
	Beam bm=arBm[i];
	if (bm.beamCode().token(0)=="H")
	{
		bmWithTool.append(bm);
	}
}

for (int i=0; i<bmWithTool.length(); i++)
{
	Beam bm=bmWithTool[i];
	Body bdCut=bm.realBody();

	Point3d ptShiftedCentre=bm.ptCen()+(U(5)*bm.vecY())+(U(5)*bm.vecZ());
	BeamCut bmCut(ptShiftedCentre, bm.vecX(), bm.vecY(), bm.vecZ(), U(10000), (bm.dD(bm.vecY())+U(10)), (bm.dD(bm.vecZ())+U(10))); 
	for(int j=0; j<bmBeamsInPointLoad.length(); j++)
	{
		bmBeamsInPointLoad[j].addToolStatic(bmCut);
		bmBeamsInPointLoad[j].setLabel("N");
	}
}

Display dp(3);
dp.dimStyle(sDimStyle);
PLine plDisplay(vy);
Point3d ptDraw=_Pt0;
ptDraw = ptDraw.projectPoint(Plane(el.ptOrg(), vy),0);
Point3d ptText=ptDraw;

ptDraw =ptDraw - vz*(dBmH*0.5);
Point3d ptDisplay=ptDraw+vx*((dBmW)*nNrOfBms)*0.5;//
plDisplay.addVertex(ptDraw-vz*(dBmH*0.5));
plDisplay.addVertex(ptDraw-vz*(dBmH*0.5)+vx*(dBmW)*nNrOfBms);
plDisplay.addVertex(ptDraw+vz*(dBmH*0.5)+vx*(dBmW)*nNrOfBms);
plDisplay.addVertex(ptDraw+vz*(dBmH*0.5));
plDisplay.close();

PLine plDisplay2(vy);
plDisplay2.addVertex(ptDraw-vz*(dBmH*0.5));
plDisplay2.addVertex(ptDraw+vz*(dBmH*0.5)+vx*(dBmW)*nNrOfBms);

PLine plDisplay3(vy);
plDisplay3.addVertex(ptDraw+vz*(dBmH*0.5));
plDisplay3.addVertex(ptDraw-vz*(dBmH*0.5)+vx*(dBmW)*nNrOfBms);
//plDisplay.addVertex(_Pt0+vx*(dBmW)*nNrOfBms);



ptText=ptText+vx*((dBmW)*nNrOfBms*0.5);
double dHText=dp.textHeightForStyle("PointLoad", sDimStyle);
//ptText=ptText+vz*dHText*1.5;
//ptText.vis(0);
//dp.draw("PL"+nNrOfBms, ptText, vx, -vz, 0, -1.3);

dp.draw(plDisplay);
dp.draw(plDisplay2);
dp.draw(plDisplay3);

Map mpPL;
mpPL.setPLine("plPointLoad", plDisplay);
_Map.setMap("mpPL", mpPL);









#End
#BeginThumbnail



















#End
