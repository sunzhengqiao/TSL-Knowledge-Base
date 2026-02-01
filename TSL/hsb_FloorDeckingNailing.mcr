#Version 8
#BeginDescription
Creates nail lines in a zone of the floor.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 11.10.2012 - version 1.0















#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
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
* date: 11.10.2012
* version 1.0: Release Version
*
*/

//Units
Unit(1,"mm");

_ThisInst.setSequenceNumber(50);

//Props and basics
String sArNY[] = {T("No"), T("Yes")};
int arNNY[]={FALSE, TRUE};

int nValidZones[]={1,2,3,4,5,6,7,8,9,10};
int nRealZones[]={1,2,3,4,5,-1,-2,-3,-4,-5};

//Zone1
PropInt nZones (0, nValidZones, T("Zone to be Nail"));

PropInt nToolingIndex(1, 1, "   "+T("Nailing Tool index"));

PropDouble dSpacing(0, U(200),"   "+T("Maximum nailing spacing"));

PropDouble dDistEdge (2, U(9),"   "+T("Distance from beam edge"));
dDistEdge.setDescription("This value is the distance between the end of the nail line to the end of the beam");

PropString strMaterialZone (1,"","   "+T("Zone Material to be Nailed"));
strMaterialZone.setDescription(T("If any Material name is set here then only that material is going to be use to apply the nailing"));

PropString strMaterialBeams (2,"CLS;","   "+T("Material beams to avoid"));
strMaterialBeams.setDescription(T("If any Material name is set here then only that material is going to be use to apply the nailing"));

double dMinValidArea=U(12);
double dDistCloseToEdge=U(25);

if (_bOnDbCreated || _bOnInsert) setPropValuesFromCatalog(_kExecuteKey);

if( _bOnInsert )
{
	if (insertCycleCount()>1) { eraseInstance(); return; }
	if (_kExecuteKey=="")
		showDialog();

	PrEntity ssE(T("Select one or More Elements"), ElementRoof());
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}

	//Insert the TSL again for each Element
	TslInst tsl;
	String sScriptName = scriptName(); // name of the script
	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
	Entity lstEnts[0];
	Beam lstBeams[0];
	Point3d lstPoints[0];
	
	int lstPropInt[0];
	lstPropInt.append(nZones);
	lstPropInt.append(nToolingIndex);
	
	double lstPropDouble[0];
	lstPropDouble.append(dSpacing);
	lstPropDouble.append(dDistEdge);

	String lstPropString[0];
	lstPropString.append(strMaterialZone);
	lstPropString.append(strMaterialBeams);
	
	for (int i=0; i<_Element.length(); i++)
	{
		lstEnts.setLength(0);
		lstEnts.append(_Element[i]);
		tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString);
	}

	eraseInstance();
	return;
}

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

int nZone=nRealZones[nValidZones.find(nZones)];

if( _Element.length() == 0 ){eraseInstance(); return;}

_Pt0=_Element[0].ptOrg();


//Add any type of beam that you dont want to be nail
int nBmTypeToAvoid[0];
nBmTypeToAvoid.append(_kBlocking);
nBmTypeToAvoid.append(_kSFBlocking);
//nBmTypeToAvoid.append(_kSFSupportingBeam);

String sArrMaterials[0];
String sExtType=strMaterialBeams;
sExtType.trimLeft();
sExtType.trimRight();
sExtType=sExtType+";";
for (int i=0; i<sExtType.length(); i++)
{
	String str=sExtType.token(i);
	str.trimLeft();
	str.trimRight();
	str.makeUpper();
	if (str.length()>0)
		sArrMaterials.append(str);
}//End OPM


ElementRoof el = (ElementRoof ) _Element[0];
if (!el.bIsValid())
{
	eraseInstance();
	return;
}

CoordSys cs =el.coordSys();
Vector3d vx = cs.vecX();
Vector3d vy = cs.vecY();
Vector3d vz = cs.vecZ();
_Pt0 = cs.ptOrg();

Plane plnZ(el.ptOrg(), vz);


TslInst tslAll[]=el.tslInstAttached();
for (int i=0; i<tslAll.length(); i++)
{
	if ( tslAll[i].scriptName() == scriptName() && tslAll[i].handle() != _ThisInst.handle() )
	{
		tslAll[i].dbErase();
	}
}

NailLine nlOld[] = el.nailLine();

for (int n=0; n<nlOld.length(); n++)
{
	NailLine nl = nlOld[n];
	if (nl.toolIndex()==nToolingIndex)
	{
		nl.dbErase();
	}
}

Beam bmAllTemp[]=NailLine().removeGenBeamsWithNoNailingBeamCode(el.beam());

Beam bmAll[0];

for (int i=0; i<bmAllTemp.length(); i++)
{
	if (bmAllTemp[i].myZoneIndex()==0)
		bmAll.append(bmAllTemp[i]);
}

Beam bmValid[0];

for (int i=0; i<bmAll.length(); i++)
{
	Beam bm=bmAll[i];
	
	int nBmType=bm.type();
	String sThisMaterial=bm.material();
	sThisMaterial.trimLeft();
	sThisMaterial.trimRight();
	sThisMaterial.makeUpper();
	
	
	if (nBmTypeToAvoid.find(nBmType, -1) != -1)
		continue;
		
	if (sArrMaterials.find(sThisMaterial, -1) != -1)
		continue;
	
	//No nail beams that are thinner than 20mm
	if (bm.dW()<U(20))
		continue;
		
	bmValid.append(bm);
}

Sheet sheets[] = el.sheet(nZone);

int nSide = 1;

if (nZone<0) nSide = -1;

// get coordSys of the back of zone 1 or -1, the surface of the beams

CoordSys csBeam = el.zone(nSide).coordSys();

// get the coordSys of the back of the zone to nail

CoordSys csSheet = el.zone(nZone).coordSys();


Plane planeBeam(csBeam.ptOrg(),csBeam.vecZ());

double dTolDistPlaneBeam = U(3);

double dShrinkDistBeam = U(dDistEdge);

 

Plane planeSheet(csSheet.ptOrg(),csSheet.vecZ());

double dTolDistPlaneSheet = U(3);

double dShrinkDistSheet = U(dDistEdge);

 

int bAllowSheetsToMerge = FALSE;

double dShrinkDistNailLine = U(dDistEdge);

 

// calculate the nailing lines

LineSeg arSeg[] = NailLine().calculateAllowedNailLineSegments(

     bmValid, planeBeam, dTolDistPlaneBeam, dShrinkDistBeam,

     sheets, planeSheet, dTolDistPlaneSheet, dShrinkDistSheet,

     bAllowSheetsToMerge, dShrinkDistNailLine);

 

// now add nailing lines

for (int n=0; n<arSeg.length(); n++) {

   Point3d ptStart = arSeg[n].ptStart();

   Point3d ptEnd = arSeg[n].ptEnd();

 

   // make ElemNail tool to be used in the construction of a nailing line

   int nToolIndex = nToolingIndex;

   ElemNail enl(nZone, ptStart, ptEnd, dSpacing, nToolingIndex);

 

   // add the nailing line to the database

   NailLine nl; nl.dbCreate(el, enl);

   nl.setColor(nToolingIndex); // set color of Nailing line

}

//assignToElementGroup(_Element[0], TRUE, 0, 'E');
	
eraseInstance(); // this TSL will not be added to the Acad database
return;



/*

Point3d ptDraw = _Pt0;
Display dspl (-1);
dspl.dimStyle(sDimLayout);

if (sDispRep!="")
	dspl.showInDispRep(sDispRep);

PLine pl1(_XW);
PLine pl2(_YW);
PLine pl3(_ZW);
pl1.addVertex(ptDraw+_ZW*U(1));
pl1.addVertex(ptDraw-_ZW*U(1));
pl2.addVertex(ptDraw-_XW*U(1));
pl2.addVertex(ptDraw+_XW*U(1));
pl3.addVertex(ptDraw-_YW*U(1));
pl3.addVertex(ptDraw+_YW*U(1));

dspl.draw(pl1);
dspl.draw(pl2);
dspl.draw(pl3);

if (arNNY[sArNY.find(sNailYNCNC,0)]==FALSE)
{
	dspl.draw("Nailing", ptDraw, vx, -vz, 1, -2);
}

_Map.setInt("ExecutionMode",1);



//eraseInstance();
//return;

*/















#End
#BeginThumbnail

#End
