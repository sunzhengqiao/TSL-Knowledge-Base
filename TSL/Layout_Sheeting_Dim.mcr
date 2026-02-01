#Version 8
#BeginDescription
Modify By: Alberto Jena
Date: 13/12/2019
Version: 1.6




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 6
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------
*  Copyright (C) 2004 by
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
*
* REVISION HISTORY
* ----------------
*
* Revised: Anno Sportel 040605
* Change:  First revision
*
* Revised: Anno Sportel 040506
* Change:  Place text on the correct side of the dimline
*
* Revised: Anno Sportel 040510
* Change:  Update translatable strings
* 
* Revised: Anno Sportel 040701
* Change:  Update conversions of zones
*
* Revised: Anno Sportel 040831
* Change:  Change check on alignment. codirectional with vx instead of vxps.
*
* Revised: Alberto Jena 040831
* Change:  Add auto scale
*
* Revised: Chirag Sawjani 120921
* Change:  Added a property for ignoring openings
*
* Revised: Alberto Jena 130712
* Change:  Fix issue with the orientation to display material of the zone
*/

Unit(1,"mm"); // script uses mm

//Used to set the distance to the element.
PropDouble dDimOff(0,U(300),T("Distance dimension line to element"));
PropDouble dTextOff(1,U(100),T("Distance text"));


//Used to set the side of the text.
String sArDeltaOnTop[]={T("Above"),T("Below")};
int nArDeltaOnTop[]={TRUE,FALSE};
PropString sDeltaOnTop(0,sArDeltaOnTop,T("Side of delta dimensioning"),0);
int nDeltaOnTop = nArDeltaOnTop[sArDeltaOnTop.find(sDeltaOnTop,0)];
 
String sArTextSide[]={T("Left"),T("Right")};
int nArTextSide[]={1,-1};
PropString sTextSide(1,sArTextSide,T("Side of dimensioning text"),0);
int nTextSide = nArTextSide[sArTextSide.find(sTextSide,0)];

String sArStartDim[]={T("Left"),T("Right")};
int nArStartDim[]={1,-1};
PropString sStartDim(2,sArStartDim,T("Start dimensionsing"));
int nStartDim = nArStartDim[sArStartDim.find(sStartDim,0)];

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
PropString sDimStyle(3,sArDimStyle,T("Dimension style"));
int nArDimStyleDelta[] = {_kDimPerp, _kDimPar,_kDimNone,_kDimNone,_kDimPerp,_kDimPar,_kDimPar,_kDimPerp};
int nArDimStyleCum[] = {_kDimNone,_kDimNone,_kDimPerp, _kDimPar,_kDimPerp,_kDimPar,_kDimPerp,_kDimPar};
int nDimStyleDelta = nArDimStyleDelta[sArDimStyle.find(sDimStyle,0)];
int nDimStyleCum = nArDimStyleCum[sArDimStyle.find(sDimStyle,0)];

//Used to set the dimensioning layout.
//String sArDimLayout[] = {"hsb-vp_floor","hsb_Panlat37","bema layout","hsbLayout","layout","Assembly2","hsbcad"};
PropString sDimLayout(4,_DimStyles,"Dimension layout",0);

int arZone[]={1,2,3,4,5,6,7,8,9,10};
PropInt nZn(1,arZone,T("Zone Dimensioning object"));
// Convert zones from -5 - 5 to 0 - 10.
int nZone = nZn;
if (nZn>5)nZone = -nZn+5;

PropInt nDimColor(2,1,T("Color"));
if (nDimColor < 0 || nDimColor > 255) nDimColor.set(0);

String sArNY[] = {T("No"), T("Yes")};
int arNNY[]={FALSE, TRUE};
PropString sIgnoreOpenings(5,sArNY, T("Ignore Openings"));
int nIgnoreOpenings=sArNY.find(sIgnoreOpenings,0);

PropString sFilterByLabel (6, "", T("Filter by label"));


if (_bOnInsert) {
	Viewport vp = getViewport(T("Select a viewport.")); //select viewport
	_Viewport.append(vp);
	
	showDialogOnce();
	return;
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
CoordSys csEl = el.coordSys();

// set the diameter of the 3 circles, shown during dragging
setMarbleDiameter(U(4));
Display dp(nDimColor);
dp.dimStyle(sDimLayout, ps2ms.scale()); // dimstyle was adjusted for display in paper space, sets textHeight


String sFilterLabel = sFilterByLabel + ";";
String sFilterLabels[0];
int nIndexBC = 0; 
int sIndexBC = 0;
while(sIndexBC < sFilterLabel.length()-1)
{
	String sTokenBC = sFilterLabel.token(nIndexBC);
	nIndexBC++;
	if(sTokenBC.length()==0)
	{
		sIndexBC++;
		continue;
	}
	sIndexBC = sFilterLabel.find(sTokenBC,0);
	
	sFilterLabels.append(sTokenBC);
}


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
if ( _XW.isParallelTo(vxTemp) ) {
	vx = csEl.vecX();
	if ( ! _XW.isCodirectionalTo(vxTemp) ) {
		vx = - csEl.vecX();
	}
	if ( _YW.isParallelTo(vyTemp) ) {
		vy = csEl.vecY();
		if ( ! _YW.isCodirectionalTo(vyTemp) ) {
			vy = - csEl.vecY();
		}
		vz = csEl.vecZ();
	}
	else {
		vy = csEl.vecZ();
		if ( ! _YW.isCodirectionalTo(vzTemp) ) {
			vy = - csEl.vecZ();
		}
		vz = csEl.vecY();
	}
}
else if ( _XW.isParallelTo(vyTemp) ) {
	vx = csEl.vecY();
	if ( ! _XW.isCodirectionalTo(vyTemp) ) {
		vx = - csEl.vecY();
	}
	if ( _YW.isParallelTo(vxTemp) ) {
		vy = csEl.vecX();
		if ( ! _YW.isCodirectionalTo(vxTemp) ) {
			vy = - csEl.vecX();
		}
		vz = csEl.vecZ();
	}
	else {
		vy = csEl.vecZ();
		if ( ! _YW.isCodirectionalTo(vzTemp) ) {
			vy = - csEl.vecZ();
		}
		vz = csEl.vecX();
	}
}
else if ( _XW.isParallelTo(vzTemp) ) {
	vx = csEl.vecZ();
	if ( ! _XW.isCodirectionalTo(vzTemp) ) {
		vx = - csEl.vecZ();
	}
	if ( _YW.isParallelTo(vxTemp) ) {
		vy = csEl.vecX();
		if ( ! _YW.isCodirectionalTo(vxTemp) ) {
			vy = - csEl.vecX();
		}
		vz = csEl.vecY();
	}
	else {
		vy = csEl.vecY();
		if ( ! _YW.isCodirectionalTo(vyTemp) ) {
			vy = - csEl.vecY();
		}
		vz = csEl.vecX();
	}
}
else {
	reportNotice("Error!\nVectors not aligned.");
	return;
}

//Vectors are set.

Vector3d vxps = vx; vxps.transformBy(ms2ps);
Vector3d vyps = vy; vyps.transformBy(ms2ps);
Vector3d vzps = vz; vzps.transformBy(ms2ps);

int nZoneIndex = vp.activeZoneIndex();

Sheet arShs[] = el.sheet(nZone);
if (_bOnDebug) {
	for (int i = 0; i < arShs.length(); i++) {
		Body bdSh = arShs[i].realBody();
		bdSh.transformBy(ms2ps);
		dp.color(arShs[i].color());
		dp.draw(bdSh);
	}
	dp.color(1);
}

Body arBd[0];
for (int i = 0; i < arShs.length(); i++)
{
	arBd.append(arShs[i].realBody());//create body's and put them in an array
}

Point3d ptsMinX[0];
Point3d ptsMaxX[0];
Point3d ptsMinY[0];
Point3d ptsMaxY[0];
   
double dMinX;
double dMaxX;
double dMinY;
double dMaxY;

int boundXSet = FALSE;  
int boundYSet = FALSE;
for (int i = 0; i < arBd.length(); i++) {
	/*
	if (_bOnDebug) {
	Body drBd = arBd[i];
	drBd.transformBy(ms2ps);
	dp.color(3);
	dp.draw(drBd);
	}
	*/
	Point3d pts[] = arBd[i].allVertices();
	for (int j = 0; j < pts.length(); j++) {
		//Place all points in the same plane
		double dCorr = vz.dotProduct(pts[j] - el.ptOrg());
		pts[j] = pts[j] - dCorr * vz;
		
		double dDist = vx.dotProduct(pts[j] - el.ptOrg());
		if ( ! boundXSet) {
			boundXSet = TRUE;
			dMinX = dDist;
			dMaxX = dDist;
			ptsMinX.append(pts[j]);
			ptsMaxX.append(pts[j]);
		}
		else {
			if ( (dDist - dMinX) <= 0.05 && (dDist - dMinX) >= -0.05 ) { //is dDist between - 0.05 and 0.05 ?
				ptsMinX.append(pts[j]);
			}
			else if ( (dDist - dMaxX) <= 0.05 && (dDist - dMaxX) >= -0.05 ) {
				ptsMaxX.append(pts[j]);
			}
			else if ( (dDist - dMinX) <- 0.05 ) {
				dMinX = dDist;
				ptsMinX.setLength(0);
				ptsMinX.append(pts[j]);
			}
			else if ( (dDist - dMaxX) > 0.05 ) {
				dMaxX = dDist;
				ptsMaxX.setLength(0);
				ptsMaxX.append(pts[j]);
			}
			else {
			}
		}
		
		dDist = vy.dotProduct(pts[j] - el.ptOrg());
		if ( ! boundYSet) {
			boundYSet = TRUE;
			dMinY = dDist;
			dMaxY = dDist;
			ptsMinY.append(pts[j]);
			ptsMaxY.append(pts[j]);
		}
		else {
			if ( (dDist - dMinY) <= 0.05 && (dDist - dMinY) >= -0.05 ) {
				ptsMinY.append(pts[j]);
			}
			else if ( (dDist - dMaxY) <= 0.05 && (dDist - dMaxY) >= -0.05 ) {
				ptsMaxY.append(pts[j]);
			}
			else if ( (dDist - dMinY) <- 0.05 ) {
				dMinY = dDist;
				ptsMinY.setLength(0);
				ptsMinY.append(pts[j]);
			}
			else if ( (dDist - dMaxY) > 0.05 ) {
				dMaxY = dDist;
				ptsMaxY.setLength(0);
				ptsMaxY.append(pts[j]);
			}
			else {
			}
		}
	}
}

Point3d ptMinXMinY;
Point3d ptMinXMaxY;

double dMin;
double dMax;
 
int boundSet = FALSE;
for (int i = 0; i < ptsMinX.length(); i++) {
	double dDist = ptsMinX[i].dotProduct(vy);
	if ( ! boundSet) {
		boundSet = TRUE;
		dMin = dDist;
		dMax = dDist;
		ptMinXMinY = ptsMinX[i];
		ptMinXMaxY = ptsMinX[i];
	}
	else {
		if (dDist < dMin) {
			dMin = dDist;
			ptMinXMinY = ptsMinX[i];
		}
		else if (dDist > dMax) {
			dMax = dDist;
			ptMinXMaxY = ptsMinX[i];
		}
		else {
		}
	}
}

Point3d ptMaxXMinY;
Point3d ptMaxXMaxY; 
boundSet = FALSE;
for (int i = 0; i < ptsMaxX.length(); i++) {
	double dDist = ptsMaxX[i].dotProduct(vy);
	if ( ! boundSet) {
		boundSet = TRUE;
		dMin = dDist;
		dMax = dDist;
		ptMaxXMinY = ptsMaxX[i];
		ptMaxXMaxY = ptsMaxX[i];
	}
	else {
		if (dDist < dMin) {
			dMin = dDist;
			ptMaxXMinY = ptsMaxX[i];
		}
		else if (dDist > dMax) {
			dMax = dDist;
			ptMaxXMaxY = ptsMaxX[i];
		}
		else {
		}
	}
}

Point3d ptMinYMinX;
Point3d ptMinYMaxX;
boundSet = FALSE;
for (int i = 0; i < ptsMinY.length(); i++) {
	double dDist = ptsMinY[i].dotProduct(vx);
	if ( ! boundSet) {
		boundSet = TRUE;
		dMin = dDist;
		dMax = dDist;
		ptMinYMinX = ptsMinY[i];
		ptMinYMaxX = ptsMinY[i];
	}
	else {
		if (dDist < dMin) {
			dMin = dDist;
			ptMinYMinX = ptsMinY[i];
		}
		else if (dDist > dMax) {
			dMax = dDist;
			ptMinYMaxX = ptsMinY[i];
		}
		else {
		}
	}
}

Point3d ptMaxYMinX;
Point3d ptMaxYMaxX;
boundSet = FALSE;
for (int i = 0; i < ptsMaxY.length(); i++) {
	double dDist = ptsMaxY[i].dotProduct(vx);
	if ( ! boundSet) {
		boundSet = TRUE;
		dMin = dDist;
		dMax = dDist;
		ptMaxYMinX = ptsMaxY[i];
		ptMaxYMaxX = ptsMaxY[i];
	}
	else {
		if (dDist < dMin) {
			dMin = dDist;
			ptMaxYMinX = ptsMaxY[i];
		}
		else if (dDist > dMax) {
			dMax = dDist;
			ptMaxYMaxX = ptsMaxY[i];
		}
		else {
		}
	}
}

Point3d ptOrgZn = ElemZone(el.zone(nZone)).ptOrg();

Point3d pntsL[0];
Point3d pntsB[0];
Point3d pntsR[0];
Point3d pntsT[0];

arBd.setLength(0);
for (int i = 0; i < arShs.length(); i++)
{
	String sThisLabel = arShs[i].label();
	sThisLabel.trimLeft();
	sThisLabel.trimRight();
	sThisLabel.makeUpper();
	if (sFilterLabels.find(sThisLabel,-1) == -1)
		arBd.append(arShs[i].realBody());//create body's and put them in an array
}

for (int i = 0; i < arBd.length(); i++) {
	// Create a planeProfile of body (representing sheet)
	PlaneProfile pProf = arBd[i].extractContactFaceInPlane(Plane(el.ptOrg(), vz), U(1000));
	PLine plPProf[] = pProf.allRings();
	int nOpenings[] = pProf.ringIsOpening();
	Point3d pts[0];
	for (int j = 0; j < plPProf.length(); j++) {
		if (nOpenings[j] && nIgnoreOpenings) continue;
		//Place points of polyline in a new array of points.
		Point3d pts[0];
		// Array of points contains the first point twice.
		pts.append(plPProf[j].vertexPoints(FALSE));
		
		for (int k = 0; k < (pts.length() - 1); k++) {
			//Length of array of points must be at least 4
			if (pts.length() < 4) continue;
			
			Vector3d vLine = pts[k] - pts[k + 1];
			vLine.normalize();
			Vector3d vPerp = vz.crossProduct(vLine);
			vPerp.normalize();
			
			double dVpX = vx.dotProduct(vPerp);
			double dLineX = vx.dotProduct(vLine);
			
			if (dVpX > 0.95 && dVpX < 1.05) {
				//Right
				pntsR.append(pts[k]);
				pntsR.append(pts[k + 1]);
			}
			else if (dVpX < - 0.95 && dVpX > - 1.05) {
				//Left
				pntsL.append(pts[k]);
				pntsL.append(pts[k + 1]);
			}
			else if (dVpX > - 0.05 && dVpX < 0.05) {
				if ( vLine.isCodirectionalTo(vx) ) {
					//Top
					pntsT.append(pts[k]);
					pntsT.append(pts[k + 1]);
				}
				else {
					//Bottom
					pntsB.append(pts[k]);
					pntsB.append(pts[k + 1]);
				}
			}
			else if (dVpX > 0 && dVpX < 1) {
				if (dLineX > 0) {
					//Richt - Top
					pntsR.append(pts[k]);
					//pntsR.append(pts[k + 1]);
					
					pntsT.append(pts[k]);
					//pntsT.append(pts[k + 1]);
				}
				else {
					//Right - Bottom
					pntsR.append(pts[k]);
					//pntsR.append(pts[k + 1]);
					
					pntsB.append(pts[k]);
					//pntsB.append(pts[k + 1]);
				}
			}
			else if (dVpX < 0 && dVpX > - 1) {
				if (dLineX > 0) {
					//Left - Top
					pntsL.append(pts[k]);
					//pntsL.append(pts[k + 1]);
					
					pntsT.append(pts[k]);
					//pntsT.append(pts[k + 1]);
				}
				else {
					//Left - Bottom
					pntsR.append(pts[k]);
					//pntsR.append(pts[k + 1]);
					
					pntsB.append(pts[k]);
					//pntsB.append(pts[k + 1]);
				}
			}
		}
	}
}


Point3d ptTemp1 = ptMaxXMinY - vy*vy.dotProduct(ptMaxXMinY-ptMinYMaxX);
Point3d ptTemp2 = ptMinXMinY - vy*vy.dotProduct(ptMinXMinY-ptMinYMinX);
double dElemLength = (ptTemp1-ptTemp2).length();
Point3d ptTemp3 = ptMaxYMinX - vx*vx.dotProduct(ptMaxYMinX - ptMinXMaxY);
Point3d ptTemp4 = ptMinYMinX - vx*vx.dotProduct(ptMinYMinX - ptMinXMinY);
double dElemHeight = (ptTemp3-ptTemp4).length();

for (int nAlignment = 0; nAlignment < 4; nAlignment++) {
	// direction of dim
	Vector3d vDimX, vDimY;
	if (nAlignment == 0) {
		vDimX = _YW;
		vDimY = - _XW;
		nTextSide = - 1 * nTextSide;
	}
	else if (nAlignment == 1) {
		vDimX = _YW;
		vDimY = - _XW;
	}
	else if (nAlignment == 2) {
		vDimX = _XW;
		vDimY = _YW;
	}
	else if (nAlignment == 3) {
		vDimX = _XW;
		vDimY = _YW;
		nTextSide = - 1 * nTextSide;
	}
	else { vDimX = _XW; vDimY = _YW;}
	//draw description
	
	double dxOff[] = { - dDimOff, (dDimOff + dElemLength), 0, 0};
	double dyOff[] = { 0, 0, - dDimOff, dElemHeight + dDimOff};
	double dxTextOff[0];
	double dyTextOff[0];
	if (nTextSide == 1) {
		dxTextOff.append(0);
		dxTextOff.append(0);
		dxTextOff.append( - (dElemLength + dTextOff) );
		dxTextOff.append( - (dElemLength + dTextOff) );
		
		dyTextOff.append( - (dElemHeight + dTextOff) );
		dyTextOff.append( - (dElemHeight + dTextOff) );
		dyTextOff.append(0);
		dyTextOff.append(0);
	}
	else if (nTextSide == -1) {
		dxTextOff.append(0);
		dxTextOff.append(0);
		dxTextOff.append( dTextOff );
		dxTextOff.append( dTextOff );
		
		dyTextOff.append( dTextOff );
		dyTextOff.append( dTextOff );
		dyTextOff.append(0);
		dyTextOff.append(0);
	}
	
	
	
	Point3d pElZero =	ptMinXMinY -
	vy * vy.dotProduct(ptMinXMinY - ptMinYMinX) +
	vx * ( dxOff[nAlignment] + dxTextOff[nAlignment] ) +
	vy * ( dyOff[nAlignment] + dyTextOff[nAlignment] );
	
	Point3d pel0 = pElZero;
	pel0.transformBy(ms2ps);
	
	//Start description of dimline
	String sDescText = el.zone(nZone).material();
	
	if (vxps.isCodirectionalTo(_XW)) {
		if (nAlignment == 0) {
			dp.draw(sDescText, pel0 + dElemHeight * vyps, _YW ,- _XW ,- 1 * nTextSide, 0);//vertical left
		}
		else if (nAlignment == 1) {
			dp.draw(sDescText, pel0 + dElemHeight * vyps, _YW ,- _XW ,- 1 * nTextSide, 0);//vertical right
		}
		else if (nAlignment == 2) {
			dp.draw(sDescText, pel0 + dElemLength * vxps, _XW, _YW ,- 1 * nTextSide, 0);//horizontal bottom
		}
		else if (nAlignment == 3) {
			dp.draw(sDescText, pel0 + dElemLength * vxps, _XW, _YW ,- 1 * nTextSide, 0);//horizontal top
		}
	}
	
	DimLine lnPs; //dimline in PS (Paper Space)
	lnPs = DimLine(pel0, vDimX, vDimY );
	DimLine lnMs = lnPs; lnMs.transformBy(ps2ms); //dimline in MS (Model Space)
	
	// End description dimline
	Point3d pntsMs[0]; //define array of points in MS
	if (nAlignment == 0) pntsMs.append(pntsL);
	if (nAlignment == 1) pntsMs.append(pntsR);
	if (nAlignment == 2) pntsMs.append(pntsB);
	if (nAlignment == 3) pntsMs.append(pntsT);
	
	//Offset to element. Different for each alignment
	double dxProj[] = { - dDimOff, dDimOff, 0, 0};
	double dyProj[] = { 0, 0, - dDimOff, dDimOff};
	//Define line for projection of points.
	Point3d ptProjectMs = pElZero - vx * dxProj[nAlignment] - vy * dyProj[nAlignment];
	Point3d ptProjectPs = ptProjectMs;
	ptProjectPs.transformBy(ms2ps);
	Line lnPSProject (ptProjectPs, vDimX * nStartDim);
	Line lnMSProject = lnPSProject;
	lnMSProject.transformBy(ps2ms);
	
	//Define line for sorting
	Line lnPSSort (pel0, vDimX * nStartDim);
	Line lnMSSort = lnPSSort;
	lnMSSort.transformBy(ps2ms);
	
	//Project points on one line.
	//Order points. First point in array is start of cummulative dimensioning.
	pntsMs = lnMSProject.projectPoints(pntsMs);
	pntsMs = lnMSSort.orderPoints(pntsMs);
	Dim dim(lnMs, pntsMs, "<>", "{<>}", nDimStyleDelta, nDimStyleCum); //def in MS
	dim.transformBy(ms2ps); //transfrom the dim from MS to PS
	dim.setReadDirection(-_XW + _YW);
	dim.setDeltaOnTop(nDeltaOnTop);
	dp.draw(dim);
	
	//Restore textSide.
	if (nAlignment == 0 || nAlignment == 3) nTextSide = - 1 * nTextSide;
}
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
M`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`"'@4`-$@)P`W7'W32N5RO^
MF/IDA0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`
M!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0!"3^\(S@Y&/F^G;/
M]*1HMO\`@$U,S"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
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
8^J?Z&DRH[KU'TR0H`*`"@`H`*`"@`/_9
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
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End