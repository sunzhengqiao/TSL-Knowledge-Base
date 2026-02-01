#Version 8
#BeginDescription
* Modify by: Alberto Jena (aj@hsb-cad.com)
* date: 13.01.2010
* version 1.3: Add the extreme points of the element to the dim line


KR:10-10-2003: added the perpendicular text possibility

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2008 by
*  hsbSOFT IRELAND
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
* Modify by: Alberto Jena (aj@hsb-cad.com)
* date: 20.10.2008
* version 1.2: Fig Issue with ISM details
*
* Modify by: Alberto Jena (aj@hsb-cad.com)
* date: 13.01.2010
* version 1.3: Add the extreme points of the element to the dim line
*
*/


String arHsbId[] = {};//these timber ids will not appear in the dim lineType
/////

Unit(1,"mm"); // script uses mm

String arDir[]={"Horizontal","Vertical"};
PropString strDir(0,arDir,"Direction");

String arSide[]={T("Left"),T("Center"),T("Right"), T("Left and right")};
int arISide[]={_kLeft, _kCenter, _kRight, _kLeftAndRight};
PropString strSide(1,arSide,"Side of beams/sheets");
int nSide = arISide[arSide.find(strSide,0)];

String arAllZones[]={T("Use zone index"),T("All")};
PropString strAllZones(2,arAllZones,T("Zones to use"));

int arZone[]={-5,-4,-3,-2,-1,0,1,2,3,4,5};
PropInt nZone(0,arZone,T("Zone index"),5); // index 5 is default


String arTextDir[]={T("None"),T("Parallel"),T("Perpendicular")};
int arITextDir[]={_kDimNone,_kDimPar, _kDimPerp};

PropString strTextDirD(3,arTextDir,T("Delta text direction"));
int nTextDirD = arITextDir[arTextDir.find(strTextDirD,0)];

PropString strTextDirC(4,arTextDir,T("Cumm text direction"),1);
int nTextDirC = arITextDir[arTextDir.find(strTextDirC,1)];

String sArNY[] = { T("Left"), T("Right")};
PropString sShowProfile(5, sArNY, T("Numbering Direction"));
int nDir = sArNY.find(sShowProfile);

PropString sDimStyle(6, _DimStyles, T("|Dimension Style|"));

if (_bOnInsert) {
  
  reportMessage(T("\nAfter inserting you can change the OPM value to set the direction, and the zone."));
   _Pt0 = getPoint(); // select point
  Viewport vp = getViewport(T("Select a viewport, you can add others later on with the HSB_LINKTOOLS command.")); // select viewport
  _Viewport.append(vp);

  return;

}

// set the diameter of the 3 circles, shown during dragging
setMarbleDiameter(U(4));

Display dp(1); // use color red
dp.dimStyle(sDimStyle); // dimstyle was adjusted for display in paper space, sets textHeight

if (_bOnDebug) {
// draw the scriptname at insert point
dp.draw(scriptName() ,_Pt0,_XW,_YW,1,1);
}

// do something for the last appended viewport only
if (_Viewport.length()==0) return; // _Viewport array has some elements
Viewport vp = _Viewport[_Viewport.length()-1]; // take last element of array
_Viewport[0] = vp; // make sure the connection to the first one is lost

// check if the viewport has hsb data
if (!vp.element().bIsValid()) return;

CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps
Element el = vp.element();
int nZoneIndex = vp.activeZoneIndex();

CoordSys csEl = el.coordSys();

//Determine in which direction the element is shown in the viewport. Act accordingly.
Vector3d vx;
Vector3d vy;
Vector3d vz;
Vector3d vxTemp = csEl.vecX();
vxTemp.transformBy(ms2ps);
vxTemp.normalize();
Vector3d vyTemp = csEl.vecY();
vyTemp.transformBy(ms2ps);
vyTemp.normalize();
Vector3d vzTemp = csEl.vecZ();
vzTemp.transformBy(ms2ps);
vzTemp.normalize();
if( _XW.isParallelTo(vxTemp) ){
  vx = csEl.vecX();
  if( !_XW.isCodirectionalTo(vxTemp) ){
    vx = -csEl.vecX();
  }
  if( _YW.isParallelTo(vyTemp) ){
    vy = csEl.vecY();
    if( !_YW.isCodirectionalTo(vyTemp) ){
      vy = -csEl.vecY();
    }
    vz = csEl.vecZ();
  }
  else{
    vy = csEl.vecZ();
    if( !_YW.isCodirectionalTo(vzTemp) ){
      vy = -csEl.vecZ();
    }
    vz = csEl.vecY();
  }
}
else if( _XW.isParallelTo(vyTemp) ){
  vx = csEl.vecY();
  if( !_XW.isCodirectionalTo(vyTemp) ){
    vx = -csEl.vecY();
  }
  if( _YW.isParallelTo(vxTemp) ){
    vy = csEl.vecX();
    if( !_YW.isCodirectionalTo(vxTemp) ){
      vy = -csEl.vecX();
    }
    vz = csEl.vecZ();
  }
  else{
    vy = csEl.vecZ();
    if( !_YW.isCodirectionalTo(vzTemp) ){
      vy = -csEl.vecZ();
    }
    vz = csEl.vecX();
  }
}
else if( _XW.isParallelTo(vzTemp) ){
  vx = csEl.vecZ();
  if( !_XW.isCodirectionalTo(vzTemp) ){
    vx = -csEl.vecZ();
  }
  if( _YW.isParallelTo(vxTemp) ){
    vy = csEl.vecX();
    if( !_YW.isCodirectionalTo(vxTemp) ){
      vy = -csEl.vecX();
    }
    vz = csEl.vecY();
  }
  else{
    vy = csEl.vecY();
    if( !_YW.isCodirectionalTo(vyTemp) ){
      vy = -csEl.vecY();
    }
    vz = csEl.vecX();
  }
}
else{
  reportNotice("Error!\nVectors not aligned.");
  return;
}
//Vectors are set.


Vector3d vxps = vx; vxps.transformBy(ms2ps);
Vector3d vyps = vy; vyps.transformBy(ms2ps);
Vector3d vzps = vz; vzps.transformBy(ms2ps);



DimLine lnPs; // dimline in PS (Paper Space)
Vector3d vecDimDir; 
if (strDir=="Horizontal") {
  lnPs = DimLine(_Pt0, vxps, vyps );
  vecDimDir = vxps;
}
else {
  lnPs = DimLine(_Pt0, vyps, -vxps );
  vecDimDir = vyps;
}
 
DimLine lnMs = lnPs; lnMs.transformBy(ps2ms); // dimline in MS (Model Space)
Vector3d vecDDMs = vecDimDir; vecDDMs.transformBy(ps2ms);

Point3d pntsMs[0]; // define array of points in MS

// find out the origin point for the dimensioning. 
// For that, take the timber perpendicular to the dimline, in most negative direction
Beam arBeams[] = el.beam(); // collect all beams
Beam arRef[] = vecDDMs.filterBeamsPerpendicularSort(arBeams);
arRef.setLength(1); // reduce the list to the first only
//pntsMs.append(lnMs.collectDimPoints(arRef, nSide));           //_KLeft     -------->nSide 		AJ---comment This---------------------------------------------------------------------
// pntsMs.append(el.ptOrg()); // append origin of element as reference point

Point3d ptExtremeBm[0];
for(int i=0;i<arBeams.length();i++)
{
	Body bdBm=arBeams[i].realBody();
	ptExtremeBm.append(bdBm.extremeVertices(vecDDMs));
}

Line lnDir(el.ptOrg(), vecDDMs);
ptExtremeBm=lnDir.projectPoints(ptExtremeBm);
ptExtremeBm=lnDir.orderPoints(ptExtremeBm);

if (nZone==0 && ptExtremeBm.length()>1)
{
	pntsMs.append(ptExtremeBm[0]);
	pntsMs.append(ptExtremeBm[ptExtremeBm.length()-1]);
}
//element extream points


Beam arBmBottPlate[0];
for(int i=0;i<arBeams.length();i++)
{
	if(arBeams[i].type()==_kSFBottomPlate)
	{
		arBmBottPlate.append(arBeams[i]);
	}
}

//Add the extreme points of the element to the dimension
Point3d ptExt[0];

for(int i=0;i<arBmBottPlate.length();i++)
{
	Body bdBott=arBmBottPlate[i].realBody();
	Point3d ptExtrem[]= bdBott.extremeVertices(vx);
	for(int e=0;e<ptExtrem.length();e++)
	{
		ptExt.append(ptExtrem[e]);
	}
}
Line lnX (el.ptOrg(), vx);
ptExt=lnX.projectPoints(ptExt);
ptExt=lnX.orderPoints(ptExt);
if (strDir=="Horizontal")
{
	pntsMs.append(ptExt[0]);
	pntsMs.append(ptExt[ptExt.length()-1]);
}


///

if (strAllZones=="All") {
    GenBeam arGBeams[] = el.genBeam(); // collect all 
    pntsMs.append(lnMs.collectDimPoints(arGBeams,nSide));
}
else {
  if (nZone==0) { // we only take the beams
    Beam arBmFl[0];
    for (int b=0; b<arBeams.length(); b++) {
      String strId = arBeams[b].name("hsbId");
      if (arHsbId.find(strId)==-1) {
        arBmFl.append(arBeams[b]);
      }
    }
    pntsMs.append(lnMs.collectDimPoints(arBmFl,nSide));
  }
  else { // take the sheeting from a zone
    Sheet arSheets[] = el.sheet(nZone); // collect all sheet from the correct zone element 
    pntsMs.append(lnMs.collectDimPoints(arSheets,nSide));
  }
}
Line lnBottBm(arBmBottPlate[0].ptCen(), vx);
pntsMs=lnBottBm.orderPoints(pntsMs);
//s
//s
if(nDir==1)
{
	for(int i=0;i<pntsMs.length()-1;i++)
		for(int j=i+1;j< pntsMs.length(); j++)
		{
			pntsMs.swap(i,j);
		}

}

Dim dim(lnMs,pntsMs,"<>","<>",nTextDirD,nTextDirC); // def in MS
dim.transformBy(ms2ps); // transfrom the dim from MS to PS
dp.draw(dim);



#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0```0`!``#__@`N26YT96PH4BD@2E!%1R!,:6)R87)Y
M+"!V97)S:6]N(%LQ+C4Q+C$R+C0T70#_VP!#`%`W/$8\,E!&049:55!?>,B"
M>&YN>/6ON9'(________________________________________________
M____VP!#`55:6GAI>.N"@NO_____________________________________
M____________________________________Q`&B```!!0$!`0$!`0``````
M`````0(#!`4&!P@)"@L0``(!`P,"!`,%!00$```!?0$"`P`$$042(3%!!A-1
M80<B<10R@9&A""-"L<$54M'P)#-B<H()"A87&!D:)28G*"DJ-#4V-S@Y.D-$
M149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@X2%AH>(B8J2DY25EI>8
MF9JBHZ2EIJ>HJ:JRL[2UMK>XN;K"P\3%QL?(R<K2T]35UM?8V=KAXN/DY>;G
MZ.GJ\?+S]/7V]_CY^@$``P$!`0$!`0$!`0````````$"`P0%!@<("0H+$0`"
M`0($!`,$!P4$!``!`G<``0(#$00%(3$&$D%1!V%Q$R(R@0@40I&AL<$)(S-2
M\!5B<M$*%B0TX27Q%Q@9&B8G*"DJ-38W.#DZ0T1%1D=(24I35%565UA96F-D
M969G:&EJ<W1U=G=X>7J"@X2%AH>(B8J2DY25EI>8F9JBHZ2EIJ>HJ:JRL[2U
MMK>XN;K"P\3%QL?(R<K2T]35UM?8V=KBX^3EYN?HZ>KR\_3U]O?X^?K_P``1
M"`&3`6@#`1$``A$!`Q$!_]H`#`,!``(1`Q$`/P"[0`4`%`!0`4`%`!0`4`%`
M!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4
M`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!
M0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`
M%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0
M`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%
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
IH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H``_]D*
`












#End
