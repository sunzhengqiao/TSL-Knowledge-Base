#Version 8
#BeginDescription
Dimension any zone verticaly or horizontaly in relation to the origin of the beams.
 
Last modified by: Chirag Sawjani (csawjani@itw-industry.com)
Date: 26.03.2015 - version 1.9





#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 9
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2012 by
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
* date: 06.08.2012
* version 1.3: Fix filter for horizontal and vertical battens
*
* date: 30.08.2012
* version 1.4: Exclude battens to calculate seze of element
*
* date: 19.11.2012
* version 1.5: Add battens to dimension in plan view
*
* date: 21.11.2012
* version 1.6: Buggfix dimension vertically the sheet and exclude locating plate
*
* date: 04.12.2012
* version 1.7: Bugfix in finding the 4 vertices of the wall
*/


Unit(1,"mm"); // script uses mm

String arDir[]={"Horizontal","Vertical"};
PropString strDir(0,arDir,"Direction");

String arSide[]={"Left","Center","Right", "Left and right"};
int arISide[]={_kLeft, _kCenter, _kRight, _kLeftAndRight};
PropString strSide(1,arSide,"Side of beams/sheets");
int nSide = arISide[arSide.find(strSide,0)];

String arAllZones[]={"Use zone index","All"};
PropString strAllZones(2,arAllZones,"Zones to use");

int nValidZones[]={0,1,2,3,4,5,6,7,8,9,10};
int nRealZones[]={0,1,2,3,4,5,-1,-2,-3,-4,-5};
PropInt nZones (1, nValidZones, T("Zone to dimension"));

int nZone=nRealZones[nValidZones.find(nZones, 0)];

//Used to set the side of the text.
String sArDeltaOnTop[]={T("Above"),T("Below")};
int nArDeltaOnTop[]={TRUE,FALSE};
PropString sDeltaOnTop(3,sArDeltaOnTop,T("Side of delta dimensioning"),0);
int nDeltaOnTop = nArDeltaOnTop[sArDeltaOnTop.find(sDeltaOnTop,0)];

//Used to set the dimension style
String sArDimStyle[] =	{	T("Delta perpendicular"),
							T("Delta parallel"),
							T("Cummulative perpendicular"),
							T("Cummalative parallel"),
							T("Both perpendicular"),
							T("Both parallel"),
							T("Delta parallel, Cummalative perpendicular"),
							T("Delta perpendicular, Cummalative parallel")
						};
PropString sDimStyle(4,sArDimStyle,T("Dimension type"));
int nArDimStyleDelta[] = {_kDimPerp, _kDimPar,_kDimNone,_kDimNone,_kDimPerp,_kDimPar,_kDimPar,_kDimPerp};
int nArDimStyleCum[] = {_kDimNone,_kDimNone,_kDimPerp, _kDimPar,_kDimPerp,_kDimPar,_kDimPerp,_kDimPar};
int nDimStyleDelta = nArDimStyleDelta[sArDimStyle.find(sDimStyle,0)];
int nDimStyleCum = nArDimStyleCum[sArDimStyle.find(sDimStyle,0)];


PropString sDimLayout(5, _DimStyles, T("Dimension Style"));

PropDouble dOffset (0, U(100), T("Offset from Element"));

if (_bOnInsert)
{
	showDialogOnce();
	
	reportMessage("\nAfter inserting you can change the OPM value to set the direction, and the zone.");
	//_Pt0 = getPoint(); // select point
	Viewport vp = getViewport("Select a viewport, you can add others later on with the HSB_LINKTOOLS command."); // select viewport
	_Viewport.append(vp);
	return;
}

// set the diameter of the 3 circles, shown during dragging
setMarbleDiameter(U(4));
//if (_bOnDebug) {
// draw the scriptname at insert point
//dp.draw(scriptName() ,_Pt0,_XW,_YW,1,1);
//}

// do something for the last appended viewport only
if (_Viewport.length()==0) return; // _Viewport array has some elements
Viewport vp = _Viewport[_Viewport.length()-1]; // take last element of array
_Viewport[0] = vp; // make sure the connection to the first one is lost


// check if the viewport has hsb data
if (!vp.element().bIsValid()) return;

CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps
Element el = vp.element();

//Element vectors
CoordSys csEl=el.coordSys();

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

//int nZoneIndex = vp.activeZoneIndex();

Display dp(-1); // use color red
dp.dimStyle(sDimLayout, ps2ms.scale()); // dimstyle was adjusted for display in paper space, sets textHeight

Beam bmAll[] = el.beam(); // collect all beams
/*
// find out the origin point for the dimensioning. 
// For that, take the timber perpendicular to the dimline, in most negative direction
Beam arRef[] = vecDDMs.filterBeamsPerpendicularSort(bmAll);
arRef.setLength(1); // reduce the list to the first only
pntsMs.append(lnMs.collectDimPoints(arRef,_kLeft));
// pntsMs.append(el.ptOrg()); // append origin of element as reference point
*/


//Calculate the extreme point of the element
Point3d ptCenter;
Point3d ptAllVertex[0];
for(int i = 0; i<bmAll.length(); i++)
{
	if (bmAll[i].myZoneIndex()==0 && bmAll[i].type()!= _kLocatingPlate)
	{
		ptAllVertex.append(bmAll[i].envelopeBody(false, true).allVertices());
	}
}

ptAllVertex=Plane(el.ptOrg(), vz).projectPoints(ptAllVertex);

ptCenter.setToAverage(ptAllVertex);

Point3d ptTL=ptCenter;
Point3d ptBL=ptCenter;
Point3d ptTR=ptCenter;
Point3d ptBR=ptCenter;

for(int i = 0; i<ptAllVertex.length(); i++)
{
	Point3d pt=ptAllVertex[i];
	pt.vis();
	if ( (vx.dotProduct(pt-ptCenter)<=0 && vy.dotProduct(pt-ptCenter)>=0) && ((ptTL-ptCenter).length()<(pt-ptCenter).length()))
	{
		ptTL=pt;
	}

	if ( (vx.dotProduct(pt-ptCenter)<=0 && vy.dotProduct(pt-ptCenter)<=0) && ((ptBL-ptCenter).length()<(pt-ptCenter).length()))
	{
		ptBL=pt;
	}

	if ( (vx.dotProduct(pt-ptCenter)>=0 && vy.dotProduct(pt-ptCenter)>=0) && ((ptTR-ptCenter).length()<(pt-ptCenter).length()))
	{
		ptTR=pt;
	}

	if ( (vx.dotProduct(pt-ptCenter)>=0 && vy.dotProduct(pt-ptCenter)<=0) && ((ptBR-ptCenter).length()<(pt-ptCenter).length()))
	{
		ptBR=pt;
	}
}

ptTL.vis(1);
ptBL.vis(1);
ptTR.vis(1);
ptBR.vis(1);

Point3d ptBLPS=ptBL;
//ptBLPS
ptBLPS.transformBy(ms2ps);

ptBLPS.transformBy(-_XW*U(dOffset));
ptBLPS.transformBy(-_YW*U(dOffset));

DimLine lnPs; // dimline in PS (Paper Space)
//Vector3d vecDimDir;
Line lnSort;

Vector3d vFilter=vy;

if (strDir=="Horizontal")
{
	lnPs = DimLine(ptBLPS, _XW, _YW );
	//vecDimDir = _XW;
	lnSort=Line(ptBLPS, _XW);
	vFilter=vy;//vy
}
else
{
	lnPs = DimLine(ptBLPS, _YW, -_XW );
	lnSort=Line(ptBLPS, _YW);
	//vecDimDir = _YW;
	vFilter=vx;
}

DimLine lnMs = lnPs; lnMs.transformBy(ps2ms); // dimline in MS (Model Space)
//Vector3d vecDDMs = vecDimDir; vecDDMs.transformBy(ps2ms);
lnSort.transformBy(ps2ms);

Point3d pntsMs[0]; // define array of points in MS

if (strAllZones=="All")
{
	GenBeam arGBeams[] = el.genBeam(); // collect all
	
	GenBeam gbmToDim[0];
	for (int i=0; i<arGBeams.length(); i++)
	{
		if (abs(arGBeams[i].vecX().dotProduct(vFilter))>0.99)
		{
			gbmToDim.append(arGBeams[i]);
		}
	}
	
	pntsMs.append(lnMs.collectDimPoints(gbmToDim,nSide));
	
}
else
{
	if (nZone==0)  // we only take the beams
	{
		GenBeam gbmAll[]=el.genBeam(0);
		Beam bmValid[0];
		for (int b=0; b<gbmAll.length(); b++)
		{
			Beam bm=(Beam) gbmAll[b];
			if (bm.bIsValid())
			{
				bmValid.append(bmAll[b]);
			}
		}
		pntsMs.append(lnMs.collectDimPoints(bmValid,nSide));
	}
	else // take the sheeting from a zone
	{
		GenBeam arGenBm[] = el.genBeam(nZone); // collect all sheet from the correct zone element
		
		GenBeam gbmToDim[0];
		
		for (int i=0; i<arGenBm.length(); i++)
		{
			Vector3d vTempFilter=vFilter;
			if ( arGenBm[i].bIsKindOf(Beam()) )
			{
				vTempFilter=el.vecY();
				if (abs(arGenBm[i].vecX().dotProduct(vTempFilter))>0.99)
				{
					gbmToDim.append(arGenBm[i]);
				}
			}
			else
			{
				gbmToDim.append(arGenBm[i]);
			}
			//double dA=abs(arGenBm[i].vecX().dotProduct(vTempFilter));
			//if (abs(arGenBm[i].vecX().dotProduct(vTempFilter))>0.99)
			//{
			//	gbmToDim.append(arGenBm[i]);
			//}
		}
		
		Point3d ptAllForExtremes[0];
		for (int i=0; i<gbmToDim.length(); i++)
		{
			Point3d ptExtr[]=gbmToDim[i].realBody().extremeVertices(vFilter);
			if (ptExtr.length()>1)
			{
				ptAllForExtremes.append(ptExtr[0]);
				ptAllForExtremes.append(ptExtr[ptExtr.length()-1]);
			}
		}

		pntsMs.append(lnMs.collectDimPoints(gbmToDim,nSide));
		
		if (ptAllForExtremes.length()>1)
		{
			ptAllForExtremes=lnSort.orderPoints(ptAllForExtremes);
			
			pntsMs.append(ptAllForExtremes[0]);
			pntsMs.append(ptAllForExtremes[ptAllForExtremes.length()-1]);
		}
	}
}

if (strDir=="Horizontal")
{
	pntsMs.append(ptBL);
	pntsMs.append(ptBR);
}
else
{
	pntsMs.append(ptTL);
	pntsMs.append(ptBL);
}

pntsMs=lnSort.orderPoints(pntsMs);
pntsMs=lnSort.projectPoints(pntsMs);

Dim dim(lnMs, pntsMs,"<>","<>", nDimStyleDelta, nDimStyleCum); // def in MS
dim.transformBy(ms2ps); // transfrom the dim from MS to PS
dim.setReadDirection(-_XW + _YW);
dim.setDeltaOnTop(nDeltaOnTop);
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