#Version 8
#BeginDescription





















#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents

/*
*  COPYRIGHT
*  ---------
*  Copyright (C) 2005 by
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
* Revised: Anno Sportel 050310
* Change:  First revision
*
* Revised: Anno Sportel 050329
* Change: Filter bridging based on hsbId.
*
* Revised: Anno Sportel 050329
* Change: Make the distances the dim looks into the element properties.
*
* Revised: Anno Sportel 050331
* Change: Add opening dimensioning
*
* Revised: Anno Sportel 051021
* Change: Add dimension side vertical beams
*               Add property to dimension first joist
*
* Revised: Alberto Jena 11/11/2010
* Change: Add blocking looking by name too
*               Add automatic viewport scale
*/


Unit(1,"mm"); // script uses mm
double dEps = U(0.05);

//Used to set the distance to the element.
PropDouble dDimOff(0,U(300),T("Distance dimension line to element"));
PropDouble dBetweenDim(1,U(200),T("Distance between dimlines"));
PropDouble dTextOffset(2,U(100),T("Distance text"));
//dTextOff is lateron adjusted.
double dTextOff = dTextOffset;

//Used to set the dimensioning layout.
PropString sDimLayout(0,_DimStyles,"Dimension layout");

PropDouble dDeltaVertical(3,U(500),T("Distance vertical dims look into the element"));
PropDouble dDeltaHorizontal(4,U(500),T("Distance horizontal dims look into the element"));

String arSSideHorDim[] = {T("Left"), T("Center"), T("Right")};
int arNSideHorDim[] = {-1,0,1};
PropString sSideHorDim(1, arSSideHorDim, T("Dimension side vertical beams"),1);
int nSideHorDim = arNSideHorDim[ arSSideHorDim.find(sSideHorDim,1) ];

String arSYesNo[] = {T("Yes"), T("No")};
int arNTrueFalse[] = {TRUE, FALSE};
PropString sDimFirstJoist(2, arSYesNo, T("Dimension first joist"),1);
int nDimFirstJoist = arNTrueFalse[ arSYesNo.find(sDimFirstJoist,1) ];

if (_bOnInsert) {
  Viewport vp = getViewport(T("Select a viewport.")); // select viewport
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

Display dp(-1);
dp.dimStyle(sDimLayout, ps2ms.scale()); // dimstyle was adjusted for display in paper space, sets textHeight

//set vectors model space
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();
//set vectors paper space
Vector3d vxps = vx; vxps.transformBy(ms2ps);
Vector3d vyps = vy; vyps.transformBy(ms2ps);
Vector3d vzps = vz; vzps.transformBy(ms2ps);

//Beams of element
Beam arBm[] = el.beam();

//Calculate the extremepoints of the element on each side.
Body arBd[0];
for(int i=0;i<arBm.length();i++){
  arBd.append(arBm[i].realBody());
}

Point3d ptsMinX[0];
Point3d ptsMaxX[0];
Point3d ptsMinY[0];
Point3d ptsMaxY[0];
   
double dMinimumX;
double dMaximumX;
double dMinimumY;
double dMaximumY;

int boundXSet = FALSE;  
int boundYSet = FALSE;
for (int i=0; i<arBd.length();i++){
  Point3d pts[] = arBd[i].allVertices();
  for (int j=0;j<pts.length();j++){
    //Place all points in the same plane
    double dCorr = vz.dotProduct(pts[j]-el.ptOrg());
    pts[j] = pts[j]-dCorr*vz;
    
    double dDist = vx.dotProduct(pts[j]-el.ptOrg());
    if(!boundXSet){
      boundXSet = TRUE;
      dMinimumX = dDist;
      dMaximumX = dDist;
      ptsMinX.append(pts[j]);
      ptsMaxX.append(pts[j]);
    }
    else{
      if( (dDist - dMinimumX)<=0.05 && (dDist - dMinimumX)>=-0.05 ){ //is dDist between -0.05 and 0.05?
        ptsMinX.append(pts[j]);
      }
      else if( (dDist - dMaximumX)<=0.05 && (dDist -dMaximumX)>=-0.05 ){
        ptsMaxX.append(pts[j]);
      }
      else if( (dDist - dMinimumX)<-0.05 ){
        dMinimumX = dDist;
        ptsMinX.setLength(0);
        ptsMinX.append(pts[j]);
      }
      else if( (dDist - dMaximumX)>0.05 ){
        dMaximumX = dDist;
        ptsMaxX.setLength(0);
        ptsMaxX.append(pts[j]);
      }
      else{
      }
    }
  
    dDist = vy.dotProduct(pts[j]-el.ptOrg());
    if(!boundYSet){
      boundYSet = TRUE;
      dMinimumY = dDist;
      dMaximumY = dDist;
      ptsMinY.append(pts[j]);
      ptsMaxY.append(pts[j]);
    }
    else{
      if( (dDist - dMinimumY)<=0.05 && (dDist - dMinimumY)>=-0.05 ){
        ptsMinY.append(pts[j]);
      }
      else if( (dDist - dMaximumY)<=0.05 && (dDist - dMaximumY)>=-0.05 ){
        ptsMaxY.append(pts[j]);
      }
      else if( (dDist - dMinimumY)<-0.05 ){
        dMinimumY = dDist;
        ptsMinY.setLength(0);
        ptsMinY.append(pts[j]);
      }
      else if( (dDist - dMaximumY)>0.05 ){
        dMaximumY = dDist;
        ptsMaxY.setLength(0);
        ptsMaxY.append(pts[j]);
      }
      else{
      }
    }
  }
}
Point3d ptMinXMinY;
Point3d ptMinXMaxY;

double dMin;
double dMax;
 
int boundSet = FALSE;
for(int i=0;i<ptsMinX.length();i++){
  double dDist = ptsMinX[i].dotProduct(vy);
  if(!boundSet){
    boundSet = TRUE;
    dMin = dDist;
    dMax = dDist;
    ptMinXMinY = ptsMinX[i];
    ptMinXMaxY = ptsMinX[i];
  }
  else{
    if(dDist<dMin){
      dMin = dDist;
      ptMinXMinY = ptsMinX[i];
    }
    else if(dDist>dMax){
      dMax = dDist;
      ptMinXMaxY = ptsMinX[i];
    }
    else{
    }
  }
}

Point3d ptMaxXMinY;
Point3d ptMaxXMaxY; 
boundSet = FALSE;
for(int i=0;i<ptsMaxX.length();i++){
  double dDist = ptsMaxX[i].dotProduct(vy);
  if(!boundSet){
    boundSet = TRUE;
    dMin = dDist;
    dMax = dDist;
    ptMaxXMinY = ptsMaxX[i];
    ptMaxXMaxY = ptsMaxX[i];
  }
  else{
    if(dDist<dMin){
      dMin = dDist;
      ptMaxXMinY = ptsMaxX[i];
    }
    else if(dDist>dMax){
      dMax = dDist;
      ptMaxXMaxY = ptsMaxX[i];
    }
    else{
    }
  }
}

Point3d ptMinYMinX;
Point3d ptMinYMaxX;
boundSet = FALSE;
for(int i=0;i<ptsMinY.length();i++){
  double dDist = ptsMinY[i].dotProduct(vx);
  if(!boundSet){
    boundSet = TRUE;
    dMin = dDist;
    dMax = dDist;
    ptMinYMinX = ptsMinY[i];
    ptMinYMaxX = ptsMinY[i];
  }
  else{
    if(dDist<dMin){
      dMin = dDist;
      ptMinYMinX = ptsMinY[i];
    }
    else if(dDist>dMax){
      dMax = dDist;
      ptMinYMaxX = ptsMinY[i];
    }
    else{
    }
  }
}

Point3d ptMaxYMinX;
Point3d ptMaxYMaxX;
boundSet = FALSE;
for(int i=0;i<ptsMaxY.length();i++){
  double dDist = ptsMaxY[i].dotProduct(vx);
  if(!boundSet){
    boundSet = TRUE;
    dMin = dDist;
    dMax = dDist;
    ptMaxYMinX = ptsMaxY[i];
    ptMaxYMaxX = ptsMaxY[i];
  }
  else{
    if(dDist<dMin){
      dMin = dDist;
      ptMaxYMinX = ptsMaxY[i];
    }
    else if(dDist>dMax){
      dMax = dDist;
      ptMaxYMaxX = ptsMaxY[i];
    }
    else{
    }
  }
}

//Extreme points
//Bottom-Left
Point3d ptBL = ptMinYMinX + vx * vx.dotProduct(ptMinXMinY - ptMinYMinX);
//Bottom-Right
Point3d ptBR = ptMinYMaxX + vx * vx.dotProduct(ptMaxXMinY - ptMinYMaxX);
//Top-Left
Point3d ptTL = ptMaxYMinX + vx * vx.dotProduct(ptMinXMaxY - ptMaxYMinX);
//Top-Right
Point3d ptTR = ptMaxYMaxX + vx * vx.dotProduct(ptMaxXMaxY - ptMaxYMaxX);

// --------------------------------------------------------------------------------------------------------------------------------------------------
//                                                                    array's with dimpoints/objects.
//Used for dimensioning of splits and
//bottom & top dimensioning of vertical beams
Beam arBmVertical[0];

// ***
// Opening
// ***
// min and max points of vertical beams
Point3d arPtBmVertical[0];
// Left
Point3d arPtOpeningLeft[0];
// Right
Point3d arPtOpeningRight[0];

// ***
// Bridging
// ***
//Bridges
Beam arBmBridge[0];
//Left
Point3d arPtBridgingLeft[0];
//Right
Point3d arPtBridgingRight[0];

// ***
// Splits
// ***
//Left
Point3d arPtSplitsLeft[0];
//Right
Point3d arPtSplitsRight[0];

// ***
// Vertical beams ... Horizontal dims
// ***
//Top
Beam arBmVertTop[0];
Point3d arPtBmVertTop[0];
//Bottom
Beam arBmVertBottom[0];
Point3d arPtBmVertBottom[0];

// ***
//Overall Length
// ***
//Left
Point3d arPtOverallLeft[0];
//Right
Point3d arPtOverallRight[0];
//Top
Point3d arPtOverallTop[0];
//Bottom
Point3d arPtOverallBottom[0];
// --------------------------------------------------------------------------------------------------------------------------------------------------




// --------------------------------------------------------------------------------------------------------------------------------------------------
//                                                                       fill array's with dimpoints

// ***
// Bridging
// ***
//Filter bridges from all beams.
int arNFilterHsbId[] = {
	53334,
	53335,
	4113,
	9000004
};
for(int i=0;i<arBm.length();i++){
	Beam bm = arBm[i];
	String sSubLabel=bm.subLabel();
	String sName=bm.name();
	sName.makeUpper();
	sSubLabel.makeUpper();
	if( bm.vecX().isParallelTo(vx) ){
		if( arNFilterHsbId.find(bm.hsbId().atoi()) != -1 || sSubLabel=="BLOCKING" || sName== "BLOCKING"){
			arBmBridge.append(bm);
		}	
	}
	else if( bm.vecX().isParallelTo(vy) ){
		arBmVertical.append(bm);
		arPtBmVertical.append(bm.ptRef() + bm.vecX() * bm.dLMin());
		arPtBmVertical.append(bm.ptRef() + bm.vecX() * bm.dLMax());
	}
}

for(int i=0;i<arBmBridge.length();i++){
	Beam bm = arBmBridge[i];
	Point3d ptBmMin = bm.ptRef() + bm.vecX() * bm.dLMin();
	Point3d ptBmMax = bm.ptRef() + bm.vecX() * bm.dLMax();
	
	//Left
	if( abs(vx.dotProduct(ptBL - ptBmMin)) < dDeltaVertical || abs(vx.dotProduct(ptBL - ptBmMax)) < dDeltaVertical ){
		arPtBridgingLeft.append(bm.ptCen());
	}
	//Right
	if( abs(vx.dotProduct(ptBR - ptBmMin)) < dDeltaVertical || abs(vx.dotProduct(ptBR - ptBmMax)) < dDeltaVertical ){
		arPtBridgingRight.append(bm.ptCen());
	}
}

// ***
// Opening
// ***
PlaneProfile pProfEl = el.profNetto(0);
PLine arPLine[] = pProfEl.allRings();
for(int i=0;i<arPLine.length();i++){
	PLine pl = arPLine[i];
	Point3d arPt[] = pl.vertexPoints(TRUE);
	
	for(int j=0;j<arPt.length();j++){
		Point3d pt = arPt[j];
		//Skip extreme points. They are added when the dim is drawn.
		if( abs(vy.dotProduct(ptBL - pt)) < dEps || abs(vy.dotProduct(ptTL - pt)) < dEps || abs(vy.dotProduct(ptBR - pt)) < dEps || abs(vy.dotProduct(ptTR - pt)) < dEps ){
			continue;
		}
				
		double dMin;
		int nMinSet = FALSE;
		Point3d ptMin = pt;//pt as default.
		for(int k=0;k<arPtBmVertical.length();k++){
			Point3d ptBm =arPtBmVertical[k];
			double dDist = (Vector3d(ptBm - pt)).length();
			if( !nMinSet ){
				nMinSet = TRUE;
				ptMin = ptBm;
				dMin = dDist;
			}
			else{
				if( (dMin - dDist) > dEps ){
					ptMin = ptBm;
					dMin = dDist;
				}
			}
		}
		pt = ptMin;
		
		//Left
		if( abs(vx.dotProduct(ptBL - pt)) < dDeltaVertical ){
			arPtOpeningLeft.append(pt);
		}
		//Right
		if( abs(vx.dotProduct(ptBR - pt)) < dDeltaVertical ){
			arPtOpeningRight.append(pt);
		}
	}
}

// ***
// Splits
// ***
for(int i=0;i<arBmVertical.length();i++){
	Beam bm = arBmVertical[i];
	Point3d ptBmMin = bm.ptRef() + bm.vecX() * bm.dLMin();
	Point3d ptBmMax = bm.ptRef() + bm.vecX() * bm.dLMax();
	
	//Left
	if( abs(vx.dotProduct(ptBL - bm.ptCen())) < dDeltaVertical ){
		arPtSplitsLeft.append(ptBmMin);
		arPtSplitsLeft.append(ptBmMax);
	}
	//Right
	if( abs(vx.dotProduct(ptBR - bm.ptCen())) < dDeltaVertical ){
		arPtSplitsRight.append(ptBmMin);
		arPtSplitsRight.append(ptBmMax);
	}
}

// ***
// Vertical beams .... horizontal dims
// ***
for(int i=0;i<arBmVertical.length();i++){
	Beam bm = arBmVertical[i];
	Point3d ptBmMin = bm.ptRef() + bm.vecX() * bm.dLMin();
	Point3d ptBmMax = bm.ptRef() + bm.vecX() * bm.dLMax();
	
	//Top
	if( abs(vy.dotProduct(ptTL - ptBmMin)) < dDeltaHorizontal || abs(vy.dotProduct(ptTL - ptBmMax)) < dDeltaHorizontal ){
		arBmVertTop.append(bm);
	}
	//Bottom
	if( abs(vy.dotProduct(ptBL - ptBmMin)) < dDeltaHorizontal || abs(vy.dotProduct(ptBL - ptBmMax)) < dDeltaHorizontal ){
		arBmVertBottom.append(bm);
	}
}

arBmVertTop = el.vecX().filterBeamsPerpendicularSort(arBmVertTop);
arBmVertBottom = el.vecX().filterBeamsPerpendicularSort(arBmVertBottom);

int i=1;
if( nDimFirstJoist ) i=0;
for(i;i<arBmVertTop.length()-1;i++){
	arPtBmVertTop.append(arBmVertTop[i].ptCen() + vx * 0.5 * arBmVertTop[i].dD(vx) * nSideHorDim);
}
i=1;
if( nDimFirstJoist ) i=0;
for(i;i<arBmVertBottom.length()-1;i++){
	arPtBmVertBottom.append(arBmVertBottom[i].ptCen() + vx * 0.5 * arBmVertBottom[i].dD(vx) * nSideHorDim);
}

// ***
// Overall length
// ***
//Left
arPtOverallLeft.append(ptMinXMinY);
arPtOverallLeft.append(ptMinXMaxY);
//Right
arPtOverallRight.append(ptMaxXMinY);
arPtOverallRight.append(ptMaxXMaxY);
//Top
arPtOverallTop.append(ptMaxYMinX);
arPtOverallTop.append(ptMaxYMaxX);
//Bottom
arPtOverallBottom.append(ptMinYMinX);
arPtOverallBottom.append(ptMinYMaxX);
// --------------------------------------------------------------------------------------------------------------------------------------------------


//Lines to order points
Line lnMsYL(ptBL, vy);
Line lnMsYR(ptBR, vy);
Line lnMsXT(ptTL, vx);
Line lnMsXB(ptBL, vx);

//Left. 
double dDimLeft = dDimOff;
//Right. 
double dDimRight = dDimOff;
//Top
double dDimTop = dDimOff;
//Bottom 
double dDimBottom = dDimOff;

//Dim opening
if( arPtOpeningLeft.length() > 0 || arPtOpeningRight.length() > 0 ){
// ----------------------------------------------------------------------------------------
//Dim Left
	Point3d arPtDimLeft[0];
	//Add extreme points
	arPtDimLeft.append(arPtOpeningLeft);
	arPtDimLeft.append(ptBL);
	arPtDimLeft.append(ptTL);

	//Order points
	arPtDimLeft = lnMsYL.projectPoints(arPtDimLeft);
	arPtDimLeft = lnMsYL.orderPoints(arPtDimLeft);
	Point3d arPtDimL[0];
	for(int i=0; i<(arPtDimLeft.length() - 1);i++){
		if(i==0){
			arPtDimL.append(arPtDimLeft[i]);
		}
		double dBetweenPoints = (arPtDimLeft[i+1] - arPtDimLeft[i]).length();
		if( dBetweenPoints > dEps ){
			arPtDimL.append(arPtDimLeft[i+1]);
		}
	}
	arPtDimLeft= arPtDimL;

	//Define dimline
	DimLine dimLnLeft(ptBL - vx * dDimLeft, vy, -vx);
	Dim dimLeft(dimLnLeft, arPtDimLeft, "<>", "(<>)", _kDimPar, _kDimNone);
	dimLeft.transformBy(ms2ps);
	//Draw dimline
	dp.draw(dimLeft);
	//Draw name of dimline
	Point3d ptNameL = ptBL - vy * dTextOff - vx * dDimLeft;
	ptNameL.transformBy(ms2ps);
	dp.draw(T("Opening"), ptNameL, vyps, -vxps, -1, 0);

	//Increase distance for next dimline.
	dDimLeft = dDimLeft + dBetweenDim;

//  ----------------------------------------------------------------------------------------
//Dim Right
	Point3d arPtDimRight[0];
	//Add extreme points
	arPtDimRight.append(arPtOpeningRight);
	arPtDimRight.append(ptBR);
	arPtDimRight.append(ptTR);

	//Order points
	arPtDimRight = lnMsYR.projectPoints(arPtDimRight);
	arPtDimRight = lnMsYR.orderPoints(arPtDimRight);
	Point3d arPtDimR[0];
	for(int i=0; i<(arPtDimRight.length() - 1);i++){
		if(i==0){
			arPtDimR.append(arPtDimRight[i]);
		}
		double dBetweenPoints = (arPtDimRight[i+1] - arPtDimRight[i]).length();
		if( dBetweenPoints > dEps ){
			arPtDimR.append(arPtDimRight[i+1]);
		}
	}
	arPtDimRight= arPtDimR;

	//Define dimline
	DimLine dimLnRight(ptBR + vx * dDimRight, vy, -vx);
	Dim dimRight(dimLnRight, arPtDimRight, "<>", "(<>)", _kDimPar, _kDimNone);
	dimRight.transformBy(ms2ps);
	//Draw dimline
	dp.draw(dimRight);
	//Draw name of dimline
	Point3d ptNameR = ptTR + vy * dTextOff + vx * dDimRight;
	ptNameR.transformBy(ms2ps);
	dp.draw(T("Opening"), ptNameR, vyps, -vxps, 1, 0);

	//Increase distance for next dimline.
	dDimRight = dDimRight + dBetweenDim;
}

//Dim bridging
if( arPtBridgingLeft.length() > 0 || arPtBridgingRight.length() > 0 ){
// ----------------------------------------------------------------------------------------
//Dim Left
	Point3d arPtDimLeft[0];
	//Add extreme points
	arPtDimLeft.append(arPtBridgingLeft);
	arPtDimLeft.append(ptBL);
	arPtDimLeft.append(ptTL);

	//Order points
	arPtDimLeft = lnMsYL.projectPoints(arPtDimLeft);
	arPtDimLeft = lnMsYL.orderPoints(arPtDimLeft);
	Point3d arPtDimL[0];
	for(int i=0; i<(arPtDimLeft.length() - 1);i++){
		if(i==0){
			arPtDimL.append(arPtDimLeft[i]);
		}
		double dBetweenPoints = (arPtDimLeft[i+1] - arPtDimLeft[i]).length();
		if( dBetweenPoints > dEps ){
			arPtDimL.append(arPtDimLeft[i+1]);
		}
	}
	arPtDimLeft= arPtDimL;

	//Define dimline
	DimLine dimLnLeft(ptBL - vx * dDimLeft, vy, -vx);
	Dim dimLeft(dimLnLeft, arPtDimLeft, "<>", "(<>)", _kDimPar, _kDimNone);
	dimLeft.transformBy(ms2ps);
	//Draw dimline
	dp.draw(dimLeft);
	//Draw name of dimline
	Point3d ptNameL = ptBL - vy * dTextOff - vx * dDimLeft;
	ptNameL.transformBy(ms2ps);
	dp.draw(T("Bridging"), ptNameL, vyps, -vxps, -1, 0);

	//Increase distance for next dimline.
	dDimLeft = dDimLeft + dBetweenDim;

//  ----------------------------------------------------------------------------------------
//Dim Right
	Point3d arPtDimRight[0];
	//Add extreme points
	arPtDimRight.append(arPtBridgingRight);
	arPtDimRight.append(ptBR);
	arPtDimRight.append(ptTR);

	//Order points
	arPtDimRight = lnMsYR.projectPoints(arPtDimRight);
	arPtDimRight = lnMsYR.orderPoints(arPtDimRight);
	Point3d arPtDimR[0];
	for(int i=0; i<(arPtDimRight.length() - 1);i++){
		if(i==0){
			arPtDimR.append(arPtDimRight[i]);
		}
		double dBetweenPoints = (arPtDimRight[i+1] - arPtDimRight[i]).length();
		if( dBetweenPoints > dEps ){
			arPtDimR.append(arPtDimRight[i+1]);
		}
	}
	arPtDimRight= arPtDimR;

	//Define dimline
	DimLine dimLnRight(ptBR + vx * dDimRight, vy, -vx);
	Dim dimRight(dimLnRight, arPtDimRight, "<>", "(<>)", _kDimPar, _kDimNone);
	dimRight.transformBy(ms2ps);
	//Draw dimline
	dp.draw(dimRight);
	//Draw name of dimline
	Point3d ptNameR = ptTR + vy * dTextOff + vx * dDimRight;
	ptNameR.transformBy(ms2ps);
	dp.draw(T("Bridging"), ptNameR, vyps, -vxps, 1, 0);

	//Increase distance for next dimline.
	dDimRight = dDimRight + dBetweenDim;
}

//Dim splits
if( arPtSplitsLeft.length() > 0 || arPtSplitsRight.length() > 0 ){
// ----------------------------------------------------------------------------------------
//Dim Left
	Point3d arPtDimLeft[0];
	//Add extreme points
	arPtDimLeft.append(arPtSplitsLeft);
	arPtDimLeft.append(ptBL);
	arPtDimLeft.append(ptTL);

	//Order points
	arPtDimLeft = lnMsYL.projectPoints(arPtDimLeft);
	arPtDimLeft = lnMsYL.orderPoints(arPtDimLeft);
	Point3d arPtDimL[0];
	for(int i=0; i<(arPtDimLeft.length() - 1);i++){
		if(i==0){
			arPtDimL.append(arPtDimLeft[i]);
		}
		double dBetweenPoints = (arPtDimLeft[i+1] - arPtDimLeft[i]).length();
		if( dBetweenPoints > dEps ){
			arPtDimL.append(arPtDimLeft[i+1]);
		}
	}
	arPtDimLeft= arPtDimL;

	//Define dimline
	DimLine dimLnLeft(ptBL - vx * dDimLeft, vy, -vx);
	Dim dimLeft(dimLnLeft, arPtDimLeft, "<>", "(<>)", _kDimPar, _kDimNone);
	dimLeft.transformBy(ms2ps);
	//Draw dimline
	dp.draw(dimLeft);
	//Draw name of dimline
	Point3d ptNameL = ptBL - vy * dTextOff - vx * dDimLeft;
	ptNameL.transformBy(ms2ps);
	dp.draw(T("Splits"), ptNameL, vyps, -vxps, -1, 0);

	//Increase distance for next dimline.
	dDimLeft = dDimLeft + dBetweenDim;

//  ----------------------------------------------------------------------------------------
//Dim Right
	Point3d arPtDimRight[0];
	//Add extreme points
	arPtDimRight.append(arPtSplitsRight);
	arPtDimRight.append(ptBR);
	arPtDimRight.append(ptTR);

	//Order points
	arPtDimRight = lnMsYR.projectPoints(arPtDimRight);
	arPtDimRight = lnMsYR.orderPoints(arPtDimRight);
	Point3d arPtDimR[0];
	for(int i=0; i<(arPtDimRight.length() - 1);i++){
		if(i==0){
			arPtDimR.append(arPtDimRight[i]);
		}
		double dBetweenPoints = (arPtDimRight[i+1] - arPtDimRight[i]).length();
		if( dBetweenPoints > dEps ){
			arPtDimR.append(arPtDimRight[i+1]);
		}
	}
	arPtDimRight= arPtDimR;

	//Define dimline
	DimLine dimLnRight(ptBR + vx * dDimRight, vy, -vx);
	Dim dimRight(dimLnRight, arPtDimRight, "<>", "(<>)", _kDimPar, _kDimNone);
	dimRight.transformBy(ms2ps);
	//Draw dimline
	dp.draw(dimRight);
	//Draw name of dimline
	Point3d ptNameR = ptTR + vy * dTextOff + vx * dDimRight;
	ptNameR.transformBy(ms2ps);
	dp.draw(T("Splits"), ptNameR, vyps, -vxps, 1, 0);

	//Increase distance for next dimline.
	dDimRight = dDimRight + dBetweenDim;
}

//Dim Vertical beams
if( arPtBmVertTop.length() > 0 || arPtBmVertBottom.length() > 0 ){
//  ----------------------------------------------------------------------------------------
//Dim Top
	Point3d arPtDimTop[0];
	//Add extreme points
	arPtDimTop.append(arPtBmVertTop);
	arPtDimTop.append(ptTL);
	arPtDimTop.append(ptTR);

	//Order points
	arPtDimTop = lnMsXT.projectPoints(arPtDimTop);
	arPtDimTop = lnMsXT.orderPoints(arPtDimTop);
	Point3d arPtDimT[0];
	for(int i=0; i<(arPtDimTop.length() - 1);i++){
		if(i==0){
			arPtDimT.append(arPtDimTop[i]);
		}
		double dBetweenPoints = (arPtDimTop[i+1] - arPtDimTop[i]).length();
		if( dBetweenPoints > dEps ){
			arPtDimT.append(arPtDimTop[i+1]);
		}
	}
	arPtDimTop = arPtDimT;

	//Define dimline
	DimLine dimLnTop(ptTL + vy * dDimTop, vx, vy);
	Dim dimTop(dimLnTop, arPtDimTop, "<>", "(<>)", _kDimPar, _kDimNone);
	dimTop.transformBy(ms2ps);
	//Draw dimline
	dp.draw(dimTop);
	//Draw name of dimline
	Point3d ptNameT = ptTL - vx * dTextOff + vy * dDimTop;
	ptNameT.transformBy(ms2ps);
	dp.draw(T("Beams"), ptNameT, vxps, vyps, -1, 0);

	//Increase distance for next dimline.
	dDimTop = dDimTop + dBetweenDim;

//  ----------------------------------------------------------------------------------------
//Dim Bottom
	Point3d arPtDimBottom[0];
	//Add extreme points
	arPtDimBottom.append(arPtBmVertBottom);
	arPtDimBottom.append(ptBL);
	arPtDimBottom.append(ptBR);

	//Order points
	arPtDimBottom = lnMsXB.projectPoints(arPtDimBottom);
	arPtDimBottom = lnMsXB.orderPoints(arPtDimBottom);
	Point3d arPtDimB[0];
	for(int i=0; i<(arPtDimBottom.length() - 1);i++){
		if(i==0){
			arPtDimB.append(arPtDimBottom[i]);
		}
		double dBetweenPoints = (arPtDimBottom[i+1] - arPtDimBottom[i]).length();
		if( dBetweenPoints > dEps ){
			arPtDimB.append(arPtDimBottom[i+1]);
		}
	}
	arPtDimBottom = arPtDimB;

	//Define dimline
	DimLine dimLnBottom(ptBL - vy * dDimBottom, vx, vy);
	Dim dimBottom(dimLnBottom, arPtDimBottom, "<>", "(<>)", _kDimPar, _kDimNone);
	dimBottom.transformBy(ms2ps);
	//Draw dimline
	dp.draw(dimBottom);
	//Draw name of dimline
	Point3d ptNameB = ptBR + vx * dTextOff - vy * dDimBottom;
	ptNameB.transformBy(ms2ps);
	dp.draw(T("Beams"), ptNameB, vxps, vyps, 1, 0);

	//Increase distance for next dimline.
	dDimBottom = dDimBottom + dBetweenDim;
}

//Dim overall Lengths
if( TRUE ){//Always drawn
// ----------------------------------------------------------------------------------------
//Dim Left
	Point3d arPtDimLeft[0];
	//Add extreme points
	arPtDimLeft.append(arPtOverallLeft);
	arPtDimLeft.append(ptBL);
	arPtDimLeft.append(ptTL);

	//Order points
	arPtDimLeft = lnMsYL.projectPoints(arPtDimLeft);
	arPtDimLeft = lnMsYL.orderPoints(arPtDimLeft);
	Point3d arPtDimL[0];
	for(int i=0; i<(arPtDimLeft.length() - 1);i++){
		if(i==0){
			arPtDimL.append(arPtDimLeft[i]);
		}
		double dBetweenPoints = (arPtDimLeft[i+1] - arPtDimLeft[i]).length();
		if( dBetweenPoints > dEps ){
			arPtDimL.append(arPtDimLeft[i+1]);
		}
	}
	arPtDimLeft= arPtDimL;

	//Define dimline
	DimLine dimLnLeft(ptBL - vx * dDimLeft, vy, -vx);
	Dim dimLeft(dimLnLeft, arPtDimLeft, "<>", "(<>)", _kDimPar, _kDimNone);
	dimLeft.transformBy(ms2ps);
	//Draw dimline
	dp.draw(dimLeft);
	//Draw name of dimline
	Point3d ptNameL = ptBL - vy * dTextOff - vx * dDimLeft;
	ptNameL.transformBy(ms2ps);
	dp.draw(T("Total length"), ptNameL, vyps, -vxps, -1, 0);

	//Increase distance for next dimline.
	dDimLeft = dDimLeft + dBetweenDim;

//  ----------------------------------------------------------------------------------------
//Dim Right
	Point3d arPtDimRight[0];
	//Add extreme points
	arPtDimRight.append(arPtOverallRight);
	arPtDimRight.append(ptBR);
	arPtDimRight.append(ptTR);

	//Order points
	arPtDimRight = lnMsYR.projectPoints(arPtDimRight);
	arPtDimRight = lnMsYR.orderPoints(arPtDimRight);
	Point3d arPtDimR[0];
	for(int i=0; i<(arPtDimRight.length() - 1);i++){
		if(i==0){
			arPtDimR.append(arPtDimRight[i]);
		}
		double dBetweenPoints = (arPtDimRight[i+1] - arPtDimRight[i]).length();
		if( dBetweenPoints > dEps ){
			arPtDimR.append(arPtDimRight[i+1]);
		}
	}
	arPtDimRight= arPtDimR;

	//Define dimline
	DimLine dimLnRight(ptBR + vx * dDimRight, vy, -vx);
	Dim dimRight(dimLnRight, arPtDimRight, "<>", "(<>)", _kDimPar, _kDimNone);
	dimRight.transformBy(ms2ps);
	//Draw dimline
	dp.draw(dimRight);
	//Draw name of dimline
	Point3d ptNameR = ptTR + vy * dTextOff + vx * dDimRight;
	ptNameR.transformBy(ms2ps);
	dp.draw(T("Total length"), ptNameR, vyps, -vxps, 1, 0);

	//Increase distance for next dimline.
	dDimRight = dDimRight + dBetweenDim;

//  ----------------------------------------------------------------------------------------
//Dim Top
	Point3d arPtDimTop[0];
	//Add extreme points
	arPtDimTop.append(arPtOverallTop);
	arPtDimTop.append(ptTL);
	arPtDimTop.append(ptTR);

	//Order points
	arPtDimTop = lnMsXT.projectPoints(arPtDimTop);
	arPtDimTop = lnMsXT.orderPoints(arPtDimTop);
	Point3d arPtDimT[0];
	for(int i=0; i<(arPtDimTop.length() - 1);i++){
		if(i==0){
			arPtDimT.append(arPtDimTop[i]);
		}
		double dBetweenPoints = (arPtDimTop[i+1] - arPtDimTop[i]).length();
		if( dBetweenPoints > dEps ){
			arPtDimT.append(arPtDimTop[i+1]);
		}
	}
	arPtDimTop = arPtDimT;

	//Define dimline
	DimLine dimLnTop(ptTL + vy * dDimTop, vx, vy);
	Dim dimTop(dimLnTop, arPtDimTop, "<>", "(<>)", _kDimPar, _kDimNone);
	dimTop.transformBy(ms2ps);
	//Draw dimline
	dp.draw(dimTop);
	//Draw name of dimline
	Point3d ptNameT = ptTL - vx * dTextOff + vy * dDimTop;
	ptNameT.transformBy(ms2ps);
	dp.draw(T("Total length"), ptNameT, vxps, vyps, -1, 0);

	//Increase distance for next dimline.
	dDimTop = dDimTop + dBetweenDim;

//  ----------------------------------------------------------------------------------------
//Dim Bottom
	Point3d arPtDimBottom[0];
	//Add extreme points
	arPtDimBottom.append(arPtOverallBottom);
	arPtDimBottom.append(ptBL);
	arPtDimBottom.append(ptBR);

	//Order points
	arPtDimBottom = lnMsXB.projectPoints(arPtDimBottom);
	arPtDimBottom = lnMsXB.orderPoints(arPtDimBottom);
	Point3d arPtDimB[0];
	for(int i=0; i<(arPtDimBottom.length() - 1);i++){
		if(i==0){
			arPtDimB.append(arPtDimBottom[i]);
		}
		double dBetweenPoints = (arPtDimBottom[i+1] - arPtDimBottom[i]).length();
		if( dBetweenPoints > dEps ){
			arPtDimB.append(arPtDimBottom[i+1]);
		}
	}
	arPtDimBottom = arPtDimB;

	//Define dimline
	DimLine dimLnBottom(ptBL - vy * dDimBottom, vx, vy);
	Dim dimBottom(dimLnBottom, arPtDimBottom, "<>", "(<>)", _kDimPar, _kDimNone);
	dimBottom.transformBy(ms2ps);
	//Draw dimline
	dp.draw(dimBottom);
	//Draw name of dimline
	Point3d ptNameB = ptBR + vx * dTextOff - vy * dDimBottom;
	ptNameB.transformBy(ms2ps);
	dp.draw(T("Total length"), ptNameB, vxps, vyps, 1, 0);

	//Increase distance for next dimline.
	dDimBottom = dDimBottom + dBetweenDim;
}


// Debug only
if(_bOnDebug){
  Beam arBm[] = el.beam(); // collect all beams
  Sheet arShs1[] = el.sheet(1);
  Sheet arShs6[] = el.sheet(-1);
  for(int i=0;i<arBm.length();i++){
    Body bd = arBm[i].realBody();
    bd.transformBy(ms2ps);
    dp.color(32);
    dp.draw(bd);
  }
  for(int i=0;i<arShs1.length();i++){
    Body bdSh1 = arShs1[i].realBody();
    bdSh1.transformBy(ms2ps);
    dp.color(2);
    dp.draw(bdSh1);
  }
  for(int i=0;i<arShs6.length();i++){
    Body bdSh6 = arShs6[i].realBody();
    bdSh6.transformBy(ms2ps);
    dp.color(5);
//    dp.draw(bdSh6);
  }
  dp.color(1);
}   












#End
#BeginThumbnail
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
K]ZL^@QU%%%(`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`/_V0``
`




#End
