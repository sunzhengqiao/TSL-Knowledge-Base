#Version 8
#BeginDescription
#Versions:
1.1 05.04.2022 HSB-14908: fix when finding stud for zone 0 Author: Marsel Nakuci
Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 13.08.2010 - version 1.0


Create sheeting boards with 2 batters to support them. They are created between studs and flush to zone 6.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
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
* #Versions:
// 1.1 05.04.2022 HSB-14908: fix when finding stud for zone 0 Author: Marsel Nakuci
* date: 13.08.2010
* version 1.0: Release Version
*
*/

Unit(1,"mm"); // script uses mm

int nBmType[0];
String sBmName[0];

String sArLocation[] = {T("Front"), T("Back")};

PropString sLocation (0, sArLocation, T("Board Location"));

PropDouble dOffset (0, U(300), T("Sheet Offset From Bottom"));
dOffset.setDescription(T("Offset from the bottom of the element to the start of the sheet"));

PropDouble dSheetHeight (1, U(1200), T("Sheet Height"));
dSheetHeight.setDescription(T("Sheet Height"));

PropDouble dSheetThickness (2, U(15), T("Sheet Thickness"));
dSheetThickness.setDescription(T("Sheet Thickness"));

PropString sSheetMaterial(1,"OSB3","Sheet Material");
sSheetMaterial.setDescription("Material of the Sheets");

PropDouble dBattenWidth(3, U(50), T("Battens Width"));
dBattenWidth.setDescription(T("Width of the battens that support the sheeting"));

PropDouble dBattenHeight(4, U(50), T("Battens Height"));
dBattenHeight.setDescription(T("Height of the battens that support the sheeting"));

PropString sName(2, "Battens","Battens Name");
sName.setDescription("");

PropString sMaterial(3, "CLS","Battens Material");
sMaterial.setDescription("");

PropString sGrade(4, "C16","Battens Grade");
sGrade.setDescription("");

PropString sInformation(5, "","Battens Information");
sInformation.setDescription("");

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

int nLocation=sArLocation.find(sLocation);

double dMinLength=U(50);

if(_bOnInsert)
{
	if( insertCycleCount()>1 )
	{
		eraseInstance();
		return;
	}

	if (_kExecuteKey=="")
		showDialogOnce();

	_Element.append(getElement(T("Please select an Element")));
	_Pt0=getPoint(T("Pick Starting Point, must be inside of the element"));
	_PtG.append(getPoint(T("Pick End Point, , must be inside of the element")));

	_Map.setInt("ExecutionMode",0);

	return;
}

if (_Element.length()==0)
{
	eraseInstance();
	return;
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

Element el=_Element[0];

if (!el.bIsValid())
{
	eraseInstance();
	return;
}

CoordSys csEl = el.coordSys();
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();
//_Pt0=csEl.ptOrg();

if (nExecutionMode==0)
{	
	_Map=Map();
	Beam bmAll[]=el.beam();
	Beam bmVer[]=vx.filterBeamsPerpendicularSort(bmAll);
	Beam bmHor[]=vy.filterBeamsPerpendicularSort(bmAll);
	if (bmVer.length()<1)	
	{
		return;
	}
	
	Beam bmZone0;
	int iFound;
	for (int ib=0;ib<bmVer.length();ib++) 
	{ 
		if(abs(bmVer[ib].dD(vz)-el.zone(0).dH())<U(.1))
		{ 
			bmZone0 = bmVer[ib];
			iFound = true;
			break;
		}
		 
	}//next ib
	
	if(!iFound)
	{ 
		reportMessage("\n"+scriptName()+" "+T("|unexpected, no beam for zone 0 found|"));
		eraseInstance();
		return;
	}
//	double dBeamWidth=bmVer[0].dD(vx);
//	double dBeamHeight=bmVer[0].dD(vz);
	
	double dBeamWidth=bmZone0.dD(vx);
	double dBeamHeight=bmZone0.dD(vz);

// collect opening pp's
	PlaneProfile ppOp(csEl);
	//PlaneProfile ppTemp(cs);
	Opening op[0];
	op = el.opening();
	for (int i = 0; i < op.length(); i++)
	{
		PlaneProfile ppTemp(csEl);
		ppTemp.joinRing(op[i].plShape(), FALSE);
		ppTemp.shrink(- U(5));
		ppOp.unionWith(ppTemp);
	}

	//Set the default for the location to Front
	int nFlag=-1;
	Vector3d vDirection=-vz;
	Point3d ptSide=csEl.ptOrg();

	if (nLocation)//Back
	{
		nFlag=1;
		vDirection=vz;
		ptSide=csEl.ptOrg()-vz*(dBeamHeight);
	}

	PlaneProfile ppShapeBeams(csEl);
	Plane plnZ (ptSide, vz);
	for (int i=0; i<bmVer.length(); i++)
	{
		Beam bm=bmVer[i];

		PlaneProfile ppBm(csEl);
		ppBm = bm.realBody().extractContactFaceInPlane(plnZ, dBeamHeight);
		
		ppBm .transformBy(U(0.01)*vy.rotateBy(i*123.456,vz));
		ppBm.shrink(-U(2));
		ppShapeBeams.unionWith(ppBm);

	}
	ppShapeBeams.shrink(U(2));
	ppShapeBeams.unionWith(ppOp);
	
	Point3d ptStart=_Pt0;
	Point3d ptEnd=_PtG[0];
	
	ptStart=plnZ.closestPointTo(ptStart);
	ptEnd=plnZ.closestPointTo(ptEnd);
	
	_Pt0=ptStart;
	_PtG[0]=ptEnd;
	
	Vector3d vAux=ptEnd-ptStart;
	vAux.normalize();
	
	if (vx.dotProduct(vAux)<0)
	{
		Point3d ptA=ptStart;
		ptStart=ptEnd;
		ptEnd=ptA;
	}

	Line lnBase (csEl.ptOrg()+vy*dOffset-vz*U(10), vx);

	ptStart=lnBase.closestPointTo(ptStart);
	ptEnd=lnBase.closestPointTo(ptEnd);
	
	Beam bmLeft;
	Beam bmRight;
	
	Beam bmAux[0];
	bmAux=Beam().filterBeamsHalfLineIntersectSort(bmVer, ptStart, -vx);
	if (bmAux.length()>0)
		bmLeft=bmAux[0];

	bmAux.setLength(0);
	bmAux=Beam().filterBeamsHalfLineIntersectSort(bmVer, ptEnd, vx);
	if (bmAux.length()>0)
		bmRight=bmAux[0];
	
	if (!bmLeft.bIsValid() || !bmRight.bIsValid())
	{
		eraseInstance();
		return;
	}
	
	Point3d ptBL=Line(csEl.ptOrg()+vy*dOffset, vx).closestPointTo(Line(bmLeft.ptCen(), bmLeft.vecX()));
	Point3d ptTR=Line(csEl.ptOrg()+vy*(dOffset+dSheetHeight), vx).closestPointTo(Line(bmRight.ptCen(), bmRight.vecX()));
	
	PLine plAllOver;
	plAllOver.createRectangle(LineSeg(ptBL, ptTR), vx, vy);

	PlaneProfile ppFullSheet(plAllOver);
	ppFullSheet.subtractProfile(ppShapeBeams);

	PLine plAllRings[]=ppFullSheet.allRings();
	int bIsOpening[]=ppFullSheet.ringIsOpening();
	
	for (int i=0; i<plAllRings.length(); i++)
	{
		if (bIsOpening[i]) continue;

		Point3d ptDisplay[0];
		
		PlaneProfile ppSheet(plnZ);
		ppSheet.joinRing(plAllRings[i], false);
		LineSeg ls=ppSheet.extentInDir(vx);
		Point3d ptCenter=ls.ptMid();
		Line lnMidSheet(ptCenter, vx);
		Point3d ptBmLeft=lnMidSheet.closestPointTo(ls.ptStart());
		Point3d ptBmRight=lnMidSheet.closestPointTo(ls.ptEnd());

		ptBmLeft=plnZ.closestPointTo(ptBmLeft);
		ptBmRight=plnZ.closestPointTo(ptBmRight);
		
		Sheet sh;
		sh.dbCreate(ppSheet, dSheetThickness, nFlag);
		sh.setName(sSheetMaterial);
		sh.setMaterial(sSheetMaterial);
		sh.setColor(2);
		sh.assignToElementGroup(el, TRUE, -5, 'Z');
		
		Beam bmLeft;
		bmLeft.dbCreate(ptBmLeft+vDirection*dSheetThickness, vy, vx,- vz, dSheetHeight, dBattenWidth, dBattenHeight, 0, 1, -nFlag);
		bmLeft.setType(_kBeam);
		bmLeft.setName(sName);
		bmLeft.setMaterial(sMaterial);
		bmLeft.setGrade(sGrade);
		bmLeft.setColor(32);
		bmLeft.assignToElementGroup(el, TRUE, 0, 'Z');
		ptDisplay.append(bmLeft.ptCen());
		
		Beam bmRight;
		bmRight.dbCreate(ptBmRight+vDirection*dSheetThickness, vy, vx, -vz, dSheetHeight, dBattenWidth, dBattenHeight, 0, -1, -nFlag);
		bmRight.setType(_kBeam);
		bmRight.setName(sName);
		bmRight.setMaterial(sMaterial);
		bmRight.setGrade(sGrade);
		bmRight.setColor(32);
		bmRight.assignToElementGroup(el, TRUE, 0, 'Z');
		ptDisplay.append(bmRight.ptCen());
		//_Map.appendPoint3dArray("Points", ptDisplay);
	}
	_Map.setInt("ExecutionMode",1);
}

/*
Point3d ptToDisplay[0];
if (_Map.hasPoint3dArray("Points"));
	for (int i=0; i<_Map.length(); i++)
	{
		if (_Map.keyAt(i)=="Points")
			ptToDisplay.append(_Map.getPoint3dArray(i));
	}
	
Display dp(-1);

for (int i=0; i<ptToDisplay.length(); i++)
{
	LineSeg ls (ptToDisplay[i]-vy*U(15), ptToDisplay[i]+vy*U(15));
	LineSeg ls2 (ptToDisplay[i]-vx*U(15), ptToDisplay[i]+vx*U(15));
	LineSeg ls3 (ptToDisplay[i]-vz*U(15), ptToDisplay[i]+vz*U(15));
	dp.draw(ls);
	dp.draw(ls2);
	dp.draw(ls3);
}
*/

//assignToElementGroup(el, TRUE, 0, 'Z');
eraseInstance();
return;








#End
#BeginThumbnail
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
H4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`?_V110
`


#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-14908: fix when finding stud for zone 0" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="4/5/2022 3:42:04 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End