#Version 8
#BeginDescription
v: 1.13 Fix issue with pressure plate not been dimension. Date: 27/July/2020  Author: Alberto Jena
v: 1.12 Took sip panels into consideration when determining extremeties for the dimline as CLT panels do not have edge timbers  Date: 30/October/2015  Author: Chirag Sawjani
v: 1.11 Remove the TSL from been link to the element.  Date: 17/July/2013 Author: Alberto Jena (aj@hsb-cad.com)
v: 1.9 Bugfix with panels of triangular shape  Date: 01/March/2013  Author: Alberto Jena (aj@hsb-cad.com)
v: 1.8 Changed envelope body to real body for finding max and min points  Date: 07/June/2012  Author: Alberto Jena (aj@hsb-cad.com)
v: 1.7 Show diagonal as text and remove angle text if it's say to No on show text  Date: 01/Dec/2011  Author: Alberto Jena (aj@hsb-cad.com)
v: 1.6 Added properties splay text height, splay offsets & show diagonal  Date: 22/Jul/2011  Author: Alberto Jena (aj@hsb-cad.com)
v: 1.5 Outside base on beams  Date: 27/Sep/2010  Author: Alberto Jena (aj@hsb-cad.com)
v: 1.4 Only dim the elements that are present  Date: 14/Sep/2006  Author: Alberto Jena (aj@hsb-cad.com)
v: 1.3 Bug Fix  Date: 01/Sep/2006  Author: Alberto Jena (aj@hsb-cad.com)
v: 1.2 Bug Fix  Date: 29/Aug/2006  Author: Alberto Jena (aj@hsb-cad.com)
v: 1.1 Add some properties and diag Dim  Date: 17/Aug/2006  Author: Alberto Jena (aj@hsb-cad.com)
v: 1.0 Initial Version  Date: 4/Aug/2006  Author: Alberto Jena (aj@hsb-cad.com)









#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 13
#KeyWords 
#BeginContents
// basics and props
U(1,"mm");

String strList[] = {T( "Yes"), T("No")}; 
PropString strDimBP (0,strList,T("Dim Pressure Plate"), 0);
int bDimBP = strDimBP == T("Yes");
PropString strShowDiagonal(5,strList,T("Show Diagonal"), 0);
int bDimDiag = strShowDiagonal== T("Yes");

PropString strShowDescription(6,strList,T("Show Dim Description"), 0);
int bDesc = strShowDescription== T("Yes");

PropDouble dOffset (0,U(1000),T("Offset of the DimLines"));
PropDouble dOffsetText (1,U(100),T("Offset of the Text Description"));
PropDouble dOffsetSplay(4,U(0),T("Offset for Splay Angles"));

PropString sDimStyle(1,_DimStyles,T("Dimstyle"));
PropInt nColorSp (0,1,T("Dim Panel Color"));
PropInt nColorOp (1,2,T("Dim Opening Color"));
PropInt nColorEl (2,0,T("Dim Element Color"));

PropInt nColorDp (3,3,T("Text Color"));
PropDouble dTextHeight (2,20,T("Panel Text Height"));
PropDouble dSplayTextHeight (3,20,T("Splay Text Height"));

PropString strDisplay (2,strList,T("Show Text"), 0);
int bDisplay = strDisplay == T("Yes");

String sArDisplayMode[] = {T("Parallel"),T("Perpendicular"),T("None")};
PropString sDisplayModeDelta(3,sArDisplayMode,T("Display mode") + " " + T("Delta"));
PropString sDisplayModeChain(4,sArDisplayMode,T("Display mode") + " " + T("Chain"));

//some ints on dim props
int nDispDelta = _kDimNone, nDispChain = _kDimNone, nDispChainOp = _kDimNone;
if (sDisplayModeDelta == sArDisplayMode[0])	
	nDispDelta = _kDimPar;
else if (sDisplayModeDelta == sArDisplayMode[1])	
	nDispDelta = _kDimPerp;
if (sDisplayModeChain == sArDisplayMode[0])	
	nDispChain = _kDimPar;
else if (sDisplayModeChain == sArDisplayMode[1])	
	nDispChain = _kDimPerp;

if( _bOnInsert ){
	_Pt0=getPoint("Pick a point");
	_Viewport.append(getViewport(T("Select a viewport")));
	
	return;
}

if( _Viewport.length()==0 ){eraseInstance(); return;}

Viewport vp = _Viewport[0];

// check if the viewport has hsb data
if (!vp.element().bIsValid()) return;

CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps

Element el = vp.element();

//_Pt0=el.ptOrg();

//Collect the elements and the Vectors
CoordSys cdEl = el.coordSys();
Vector3d vx = cdEl.vecX();
Vector3d vy = cdEl.vecY();
Vector3d vz = cdEl.vecZ();
Point3d ptEl = cdEl.ptOrg();
//Create a plane at the centre of the element
Plane plnZ(ptEl,vz);
//ptEl.vis(2);

Vector3d vXTxt = vx; vXTxt.transformBy(ms2ps);
Vector3d vYTxt = vy; vYTxt.transformBy(ms2ps);
Vector3d vecRead=-vx;
vecRead.transformBy(ms2ps);
vecRead.normalize();

Beam bm[]=el.beam();
//reportNotice ("\n"+bm.length());
Sip sp[]=el.sip();
Opening op[]=el.opening();
//reportNotice ("\n"+sp.length());


//////////////////////////////
PLine plEnve = el.plEnvelope();
Point3d ptExtOut[]= plEnve.vertexPoints(TRUE);
int nLocation;
for (int i=0; i<ptExtOut.length();i++)
	if((ptExtOut[i]-el.ptOrg()).length()<U(1))
		nLocation=i;

///////////////////////////
Point3d ptLeft=ptEl+vx*U(10000);
Point3d ptRight=ptEl;
Point3d ptTop=ptEl;
Point3d ptBottom=ptEl+vy*U(10000);

/*if (nLocation==0)
{
	ptLeft=ptExtOut[nLocation];
	ptRight=ptExtOut[nLocation+1];
	ptTop=ptExtOut[ptExtOut.length()];
	ptBottom=ptExtOut[nLocation];
}
else if ((nLocation-2)<=ptExtOut.length())
{
	ptLeft=ptExtOut[nLocation];
	ptRight=ptExtOut[nLocation+1];
	ptTop=ptExtOut[nLocation-1];
	ptBottom=ptExtOut[nLocation];
}else if ((nLocation-1)<=ptExtOut.length())
	{
		ptLeft=ptExtOut[nLocation];
		ptRight=ptExtOut[nLocation+1];
		ptTop=ptExtOut[nLocation-1];
		ptBottom=ptExtOut[nLocation];
	}
	else if (nLocation=ptExtOut.length())
	{
		ptLeft=ptExtOut[nLocation];
		ptRight=ptExtOut[0];
		ptTop=ptExtOut[nLocation-1];
		ptBottom=ptExtOut[nLocation];
	}
*/

//double minH=10000, maxH=0;
//double minV=10000, maxV=0;

for (int i=0; i<bm.length(); i++)
{
	//bm[i].realBody().vis();
	Point3d ptExt[]=bm[i].realBody().allVertices();
	//Point3d ptExt[]=plEnve.vertexPoints(TRUE);
	//if (ptExt.length()==0) return;
	for (int j=0; j<ptExt.length(); j++)
	{
		if(vx.dotProduct(ptExt[j]-ptLeft)<0)
		{
			//minH=vx.dotProduct(ptExt[j]-ptLeft);
			ptLeft=ptExt[j];
		}
		if(vx.dotProduct(ptExt[j]-ptRight)>0)
		{
			//maxH=vx.dotProduct(ptExt[j]-ptRight);
			ptRight=ptExt[j];
			ptRight.vis();
		}
		if(vy.dotProduct(ptExt[j]-ptBottom)<0)
		{
			//minV=vy.dotProduct(ptExt[j]-ptBottom);
			ptBottom=ptExt[j];
		}
		if(vy.dotProduct(ptExt[j]-ptTop)>0)
		{
			//maxV=vy.dotProduct(ptExt[j]-ptTop);
			ptTop=ptExt[j];
		}
	}
}

double dPanelHeight=vy.dotProduct(ptTop-ptBottom);

Point3d ptLeftSp=ptEl+vx*U(10000);
Point3d ptRightSp=ptEl;
Point3d ptTopSp=ptEl;
Point3d ptBottomSp=ptEl+vy*U(10000);
//double minHSp=10000, maxHSp=0;
//double minVSp=10000, maxVSp=0;

for (int i=0; i<sp.length(); i++)
{
//	sp[i].realBody().vis();
	Point3d ptExt[]=sp[i].realBody().allVertices();
	//if (ptExt.length()==0) return;
	for (int j=0; j<ptExt.length(); j++)
	{
		if(vx.dotProduct(ptExt[j]-ptLeftSp)<0)
		{
			//minHSp=abs(vx.dotProduct(ptExt[j]-ptEl));
			ptLeftSp=ptExt[j];
		}
		if(vx.dotProduct(ptExt[j]-ptRightSp)>0)
		{
			//maxHSp=abs(vx.dotProduct(ptExt[j]-ptEl));
			ptRightSp=ptExt[j];
		}
		if(vy.dotProduct(ptExt[j]-ptBottomSp)<0)
		{
			//minVSp=abs(vy.dotProduct(ptExt[j]-ptEl));
			ptBottomSp=ptExt[j];
		}
		if(vy.dotProduct(ptExt[j]-ptTopSp)>0)
		{
			//maxVSp=abs(vy.dotProduct(ptExt[j]-ptEl));
			ptTopSp=ptExt[j];
		}
	}
}

//Check that the extreme points are based on both sip and beam
if(vx.dotProduct(ptRight-ptEl) < vx.dotProduct(ptRightSp-ptEl))
{
	ptRight=ptRightSp;
}

if(vx.dotProduct(ptLeft-ptEl) > vx.dotProduct(ptLeftSp-ptEl))
{
	ptLeft=ptLeftSp;
}

if(vy.dotProduct(ptBottom-ptEl) > vy.dotProduct(ptBottomSp-ptEl))
{
	ptBottom=ptBottomSp;
}

if(vy.dotProduct(ptTop-ptEl) < vy.dotProduct(ptTopSp-ptEl))
{
	ptTop=ptTopSp;
}

Line lnHor (ptBottom, vx);
Line lnVer (ptLeft, vy);
ptLeft=lnHor.closestPointTo(ptLeft);
ptRight=lnHor.closestPointTo(ptRight);
ptLeft.vis(1);
ptRight.vis(2);

ptTop=lnVer.closestPointTo(ptTop);
ptBottom=lnVer.closestPointTo(ptBottom);
//ptTop.vis(3);
//ptBottom.vis(4);

LineSeg lsHor(ptLeft, ptRight);
//lsHor.ptMid().vis(5);
LineSeg lsVer(ptTop, ptBottom);
//lsVer.ptMid().vis(5);
Point3d ptCenter=Line(lsVer.ptMid(),vx).closestPointTo(Line(lsHor.ptMid(),vy));
//ptCenter.vis();
//Body bdZ1 (ptCenter, vx, vy, vz,  U(20), U(30), U(500), -1, 1, 0);
Body bdZ1 (ptCenter, vx, vy, vz,  (ptLeft-ptRight).length(), (ptTop-ptBottom).length(), U(500), -1, 1, 0);
Body bdZ2 (ptCenter, vx, vy, vz,  (ptLeft-ptRight).length(), (ptTop-ptBottom).length(), U(500), -1, -1, 0);
Body bdZ3 (ptCenter, vx, vy, vz,  (ptLeft-ptRight).length(), (ptTop-ptBottom).length(), U(500), 1, 1, 0);
Body bdZ4 (ptCenter, vx, vy, vz,  (ptLeft-ptRight).length(), (ptTop-ptBottom).length(), U(500), 1, -1, 0);
//bdZ4.vis();

Sip spArrZ1[]=bdZ1.filterGenBeamsIntersect(sp);
Sip spArrZ2[]=bdZ2.filterGenBeamsIntersect(sp);
Sip spArrZ3[]=bdZ3.filterGenBeamsIntersect(sp);
Sip spArrZ4[]=bdZ4.filterGenBeamsIntersect(sp);

Opening opZ1[0];
Opening opZ2[0];
Opening opZ3[0];
Opening opZ4[0];

for (int i=0; i<op.length(); i++)
{
	Body bdOp (op[i].plShape(), vz*U(100));
	bdOp.transformBy(-vz*U(50));
	//bdOp.vis();
	if (bdOp.hasIntersection(bdZ1))
		opZ1.append(op[i]);
	if (bdOp.hasIntersection(bdZ2))
		opZ2.append(op[i]);
	if (bdOp.hasIntersection(bdZ3))
		opZ3.append(op[i]);
	if (bdOp.hasIntersection(bdZ4))
		opZ4.append(op[i]);
}
//Display setings for all zones
// Display
double dScale = ps2ms.scale();

Display dpSp(nColorSp);
dpSp.dimStyle(sDimStyle, dScale);
//dpSp.addViewDirection(vz);

Display dpOp(nColorOp);
dpOp.dimStyle(sDimStyle, dScale);
//dpOp.addViewDirection(vz);

Display dpEl(nColorEl);
dpEl.dimStyle(sDimStyle, dScale);
//dpEl.addViewDirection(vz);

Display dp(nColorDp);
dp.dimStyle(sDimStyle, dScale);
dp.textHeight(dTextHeight);
	
//HORIZONTAL DIMENSIONS
//ZONE 2 & 4
//DIM THE SIPs
//Point that are going to be dimmensioned
Point3d ptDimSip24[0];
//Base Point and line to make the dimlines
Point3d ptVisSip24 = ptEl-vy*(dOffset*1);
Line lnSip24 (ptVisSip24 , vx);
	// make up a dimline
DimLine dlSip24(ptVisSip24, vx, vy);
ptDimSip24.setLength(0);
ptDimSip24.append(dlSip24.collectDimPoints(spArrZ2,_kLeftAndRight));
ptDimSip24.append(dlSip24.collectDimPoints(spArrZ4,_kLeftAndRight));

if (ptDimSip24.length()>0)
{
	//Proyect the point to one line
	ptDimSip24=lnSip24.projectPoints(ptDimSip24);
	Dim dimSip24 (dlSip24, ptDimSip24, "<>",  "<>", nDispDelta, nDispChain);
	dimSip24.transformBy(ms2ps);
	
	//Display the description of the Dim
	Point3d ptTxtSip24 = ptVisSip24-vy*U(dOffsetText);
	ptTxtSip24.transformBy(ms2ps);

	// draw the display of the dim
	if (ptDimSip24.length()>1)
	{
		if (bDesc) dpSp.draw("Panel", ptTxtSip24, vXTxt, vYTxt, 1, 0);
		dpSp.draw(dimSip24);
	}
}
//DIM THE OPENs
//Point that are going to be dimmensioned
Point3d ptDimOp24[0];
//Base Point and line to make the dimlines
Point3d ptVisOp24 = ptEl-vy*(dOffset*2);
Line lnOp24 (ptVisOp24 , vx);

Opening opZ2Z4[0];
opZ2Z4.append(opZ2);
opZ2Z4.append(opZ4);
PLine plOpen24[0];
if (opZ2Z4.length()>0)
{
	for (int i=0; i<opZ2Z4.length(); i++)
		plOpen24.append(opZ2Z4[i].plShape());

	// make up a dimline
	DimLine dlOp24(ptVisOp24, vx, vy);
	ptDimOp24.setLength(0);
	ptDimOp24.append(ptLeft);
	ptDimOp24.append(dlOp24.collectDimPoints(plOpen24,_kLeftAndRight));
	ptDimOp24.append(ptRight);

	//Proyect the point to one line
	ptDimOp24=lnOp24.projectPoints(ptDimOp24);
	Dim dimOp24 (dlOp24, ptDimOp24, "<>",  "<>", nDispDelta, nDispChain);
	dimOp24.transformBy(ms2ps);

	//Display the description of the Dim
	Point3d ptTxtOp24 = ptVisOp24-vy*U(dOffsetText);
	ptTxtOp24.transformBy(ms2ps);

	// draw the display of the dim
	if (ptDimOp24.length()>1)
	{
		if (bDesc) dpOp.draw("Opening", ptTxtOp24, vXTxt, vYTxt, 1, 0);
		dpOp.draw(dimOp24);
	}
}
//DIM THE ELEMENTs
//Point that are going to be dimmensioned
Point3d ptDimEl24[0];
//Base Point and line to make the dimlines
Point3d ptVisEl24 = ptEl-vy*(dOffset*3);
Line lnEl24 (ptVisEl24 , vx);

// make up a dimline
DimLine dlEl24(ptVisEl24, vx, vy);
ptDimEl24.setLength(0);
ptDimEl24.append(ptLeft);
ptDimEl24.append(ptRight);

//Proyect the point to one line
ptDimEl24=lnEl24.projectPoints(ptDimEl24);
Dim dimEl24 (dlEl24, ptDimEl24, "<>",  "<>", nDispDelta, nDispChain);
dimEl24.transformBy(ms2ps);

//Display the description of the Dim
Point3d ptTxtEl24 = ptVisEl24-vy*U(dOffsetText);
ptTxtEl24.transformBy(ms2ps);

// draw the display of the dim
if (ptDimEl24.length()>1)
{
	if (bDesc) dpEl.draw("Element", ptTxtEl24, vXTxt, vYTxt, 1, 0);
	dpEl.draw(dimEl24);
}

//ZONE 1 & 3
//DIM THE SIPs
//Point that are going to be dimmensioned
Point3d ptDimSip13[0];
//Base Point and line to make the dimlines
Point3d ptVisSip13 = ptTop+vy*(dOffset*1);
Line lnSip13 (ptVisSip13 , vx);

// make up a dimline
DimLine dlSip13(ptVisSip13, vx, vy);
ptDimSip13.setLength(0);
ptDimSip13.append(dlSip13.collectDimPoints(spArrZ1,_kLeftAndRight));
ptDimSip13.append(dlSip13.collectDimPoints(spArrZ3,_kLeftAndRight));

if (ptDimSip13.length()>0)
{
	//Proyect the point to one line
	ptDimSip13=lnSip13.projectPoints(ptDimSip13);
	Dim dimSip13 (dlSip13, ptDimSip13, "<>",  "<>", nDispDelta, nDispChain);
	dimSip13.transformBy(ms2ps);

	//Display the description of the Dim
	Point3d ptTxtSip13 = ptVisSip13-vy*U(dOffsetText);
	ptTxtSip13.transformBy(ms2ps);

	// draw the display of the dim
	if (ptDimSip13.length()>1)
	{
		if (bDesc) dpSp.draw("Panel", ptTxtSip13, vXTxt, vYTxt, 1, 0);
		dpSp.draw(dimSip13);
	}
}

//DIM THE OPENs
//Point that are going to be dimmensioned
Point3d ptDimOp13[0];
//Base Point and line to make the dimlines
Point3d ptVisOp13 = ptTop+vy*(dOffset*2);
Line lnOp13 (ptVisOp13 , vx);
	
Opening opZ1Z3[0];
opZ1Z3.append(opZ1);
opZ1Z3.append(opZ3);
PLine plOpen13[0];
if (opZ1Z3.length()>0)
{
	for (int i=0; i<opZ1Z3.length(); i++)
		plOpen13.append(opZ1Z3[i].plShape());

	// make up a dimline
	DimLine dlOp13(ptVisOp13, vx, vy);
	ptDimOp13.setLength(0);
	ptDimOp13.append(ptLeft);
	ptDimOp13.append(dlOp13.collectDimPoints(plOpen13,_kLeftAndRight));
	ptDimOp13.append(ptRight);

	//Proyect the point to one line
	ptDimOp13=lnOp13.projectPoints(ptDimOp13);
	Dim dimOp13 (dlOp13, ptDimOp13, "<>",  "<>", nDispDelta, nDispChain);
	dimOp13.transformBy(ms2ps);

	//Display the description of the Dim
	Point3d ptTxtOp13 = ptVisOp13-vy*U(dOffsetText);
	ptTxtOp13.transformBy(ms2ps);


	// draw the display of the dim
	if (ptDimOp13.length()>1)
	{
		if (bDesc) dpOp.draw("Opening", ptTxtOp13, vXTxt, vYTxt, 1, 0);
		dpOp.draw(dimOp13);
	}
}
	
//DIM THE ELEMENTs
//Point that are going to be dimmensioned
Point3d ptDimEl13[0];
//Base Point and line to make the dimlines
Point3d ptVisEl13 = ptTop+vy*(dOffset*3);
Line lnEl13 (ptVisEl13 , vx);

// make up a dimline
DimLine dlEl13(ptVisEl13, vx, vy);
ptDimEl13.setLength(0);
ptDimEl13.append(ptLeft);
ptDimEl13.append(ptRight);

//Proyect the point to one line
ptDimEl13=lnEl13.projectPoints(ptDimEl13);
Dim dimEl13 (dlEl13, ptDimEl13, "<>",  "<>", nDispDelta, nDispChain);
dimEl13.transformBy(ms2ps);

//Display the description of the Dim
Point3d ptTxtEl13 = ptVisEl13-vy*U(dOffsetText);
ptTxtEl13.transformBy(ms2ps);

// draw the display of the dim
if (ptDimEl13.length()>1)
{
	if (bDesc) dpEl.draw("Element", ptTxtEl13, vXTxt, vYTxt, 1, 0);
	dpEl.draw(dimEl13);
}

//Change the orientation of the vector for the text
vXTxt = vy; vXTxt.transformBy(ms2ps);
vYTxt = -vx; vYTxt.transformBy(ms2ps);


//VERTICAL DIMENSIONS
//ZONE 1 & 2
//DIM THE OPENs
//Point that are going to be dimmensioned
Point3d ptDimOp12[0];
//Base Point and line to make the dimlines
Point3d ptVisOp12 = ptBottom-vx*(dOffset*2);
Line lnOp12 (ptVisOp12 , vy);

Opening opZ1Z2[0];
opZ1Z2.append(opZ1);
opZ1Z2.append(opZ2);
PLine plOpen12[0];

if (opZ1Z2.length()>0)
{
	for (int i=0; i<opZ1Z2.length(); i++)
		plOpen12.append(opZ1Z2[i].plShape());
	// make up a dimline
	DimLine dlOp12(ptVisOp12, vy, -vx);
	ptDimOp12.setLength(0);
	if (bDimBP)
		ptDimOp12.append(ptBottom);
	
	if (sp.length()!=0)
		ptDimOp12.append(ptBottomSp);

	ptDimOp12.append(dlOp12.collectDimPoints(plOpen12,_kLeftAndRight));
	ptDimOp12.append(ptTopSp);

	//Proyect the point to one line
	ptDimOp12=lnOp12.projectPoints(ptDimOp12);
	Dim dimOp12 (dlOp12, ptDimOp12, "<>",  "<>", nDispDelta, nDispChain);
	dimOp12.transformBy(ms2ps);

	dimOp12.setReadDirection(vecRead);

	//Display the description of the Dim
	Point3d ptTxtOp12 = ptVisOp12+vx*U(dOffsetText);
	ptTxtOp12.transformBy(ms2ps);
	
	// draw the display of the dim
	if (ptDimOp12.length()>1)
	{
		if (bDesc) dpOp.draw("Opening", ptTxtOp12, vXTxt, vYTxt, 1, 0);
		dpOp.draw(dimOp12);
	}
}

//DIM THE SIPs
//Point that are going to be dimmensioned
Point3d ptDimSip12[0];
//Base Point and line to make the dimlines
Point3d ptVisSip12 = ptBottom-vx*(dOffset*1);
Line lnSip12 (ptVisSip12 , vy);

//opZ1Z2
for (int i=0; i<opZ1Z2.length()-1; i++)
	for (int j=i+1; j<opZ1Z2.length(); j++)
		if (opZ1Z2[i]==opZ1Z2[j])
		{
			opZ1Z2.removeAt(j);
			j=i+1;
		}

Sip sipToBeDim12[0];
Sip sipOverOp12[0];
sipToBeDim12.append(spArrZ1);
sipToBeDim12.append(spArrZ2);

for (int i=0; i<sipToBeDim12.length()-1; i++)
	for (int j=i+1; j<sipToBeDim12.length(); j++)
		if (sipToBeDim12[i]==sipToBeDim12[j])
		{
			sipToBeDim12.removeAt(j);
			j=i+1;
		}

if (sipToBeDim12.length()>0)
{
	for (int i=0; i<opZ1Z2.length(); i++)
	{
		PLine shape=opZ1Z2[i].plShape();
		Body bdOp(shape, vz*U(100), 1);
		Body bdOp2=bdOp;
		bdOp.transformBy(vy*opZ1Z2[i].width());
		bdOp+=bdOp2;
		bdOp2.transformBy(-vy*opZ1Z2[i].width());
		bdOp+=bdOp2;
		for (int j=0; j<sipToBeDim12.length(); j++)
			if (sipToBeDim12[j].envelopeBody().hasIntersection(bdOp))
			{
				sipOverOp12.append(sipToBeDim12[j]);
				sipToBeDim12.removeAt(j);
				j=0;
			}
	}

	//Display the name of the Panels that are being dimensioned
	Point3d ptMess12=ptVisSip12+vy*(dPanelHeight+U(100));
	ptMess12.transformBy(ms2ps);
	String sMess12;
	for (int i=0; i<sipToBeDim12.length(); i++)
	{
		if (i==0)
		{
			sMess12=sipToBeDim12[0].label();
			sMess12+=sipToBeDim12[0].subLabel();
		}
		else
		{
			sMess12+=",";
			sMess12+=sipToBeDim12[i].subLabel();
		}
	}

	dp.draw (sMess12, ptMess12, vXTxt, vYTxt, 1, 0);

	//Display the name of the Panels that are dimensioned over and under the opening
	ptMess12=ptVisOp12+vy*(dPanelHeight+U(100));
	ptMess12.transformBy(ms2ps);
	sMess12="";
	for (int i=0; i<sipOverOp12.length(); i++)
	{
		if (i==0)
		{
			sMess12=sipOverOp12[0].label();
			sMess12+=sipOverOp12[0].subLabel();
		}
		else
		{
			sMess12+=",";
			sMess12+=sipOverOp12[i].subLabel();
		}
	}

	dp.draw (sMess12, ptMess12, vXTxt, vYTxt, 1, 0);

	// make up a dimline
	DimLine dlSip12(ptVisSip12, vy, -vx);
	ptDimSip12.setLength(0);
	ptDimSip12.append(dlSip12.collectDimPoints(sipToBeDim12,_kLeftAndRight));
	
	//Proyect the point to one line
	ptDimSip12=lnSip12.projectPoints(ptDimSip12);
	Dim dimSip12 (dlSip12, ptDimSip12, "<>",  "<>", nDispDelta, nDispChain);
	dimSip12.transformBy(ms2ps);
	dimSip12.setReadDirection(vecRead);
	
	//Display the description of the Dim
	Point3d ptTxtSip12 = ptVisSip12+vx*U(dOffsetText);
	ptTxtSip12.transformBy(ms2ps);
	

	// draw the display of the dim
	if (ptDimSip12.length()>1)
	{
		if (bDesc) dpSp.draw("Panel", ptTxtSip12, vXTxt, vYTxt, 1, 0);
		dpSp.draw(dimSip12);
	}
}
	
//DIM THE ELEMENTs
//Point that are going to be dimmensioned
Point3d ptDimEl12[0];
//Base Point and line to make the dimlines
Point3d ptVisEl12 = ptBottom-vx*(dOffset*3);
Line lnEl12 (ptVisEl12 , vy);

// make up a dimline
DimLine dlEl12(ptVisEl12, vy, -vx);
ptDimEl12.setLength(0);
if (bDimBP)
	ptDimEl12.append(ptBottom);
if (sp.length()!=0)
	ptDimEl12.append(ptBottomSp);
ptDimEl12.append(ptTop);

//Proyect the point to one line
ptDimEl12=lnEl12.projectPoints(ptDimEl12);
Dim dimEl12 (dlEl12, ptDimEl12, "<>",  "<>", nDispDelta, nDispChain);
dimEl12.transformBy(ms2ps);
dimEl12.setReadDirection(vecRead);

//Display the description of the Dim
Point3d ptTxtEl12 = ptVisEl12+vx*U(dOffsetText);
ptTxtEl12.transformBy(ms2ps);


// draw the display of the dim
if (ptDimEl12.length()>1)
{
	if (bDesc) dpEl.draw("Element", ptTxtEl12, vXTxt, vYTxt, 1, 0);
	dpEl.draw(dimEl12);
}


//ZONE 3 & 4
//DIM THE OPENs
//Point that are going to be dimmensioned
Point3d ptDimOp34[0];
//Base Point and line to make the dimlines
Point3d ptVisOp34 = ptRight+vx*(dOffset*2);
Line lnOp34 (ptVisOp34 , vy);
	
Opening opZ3Z4[0];
opZ3Z4.append(opZ3);
opZ3Z4.append(opZ4);
PLine plOpen34[0];
if (opZ3Z4.length()>0)
{
	for (int i=0; i<opZ3Z4.length(); i++)
		plOpen34.append(opZ3Z4[i].plShape());
	// make up a dimline
	DimLine dlOp34(ptVisOp34, vy, -vx);
	ptDimOp34.setLength(0);
	if (bDimBP)
		ptDimOp34.append(ptBottom);
	if (sp.length()!=0)
		ptDimOp34.append(ptBottomSp);
	ptDimOp34.append(dlOp34.collectDimPoints(plOpen34,_kLeftAndRight));
	ptDimOp34.append(ptTopSp);

	//Proyect the point to one line
	ptDimOp34=lnOp34.projectPoints(ptDimOp34);
	Dim dimOp34 (dlOp34, ptDimOp34, "<>",  "<>", nDispDelta, nDispChain);
	dimOp34.transformBy(ms2ps);
	dimOp34.setReadDirection(vecRead);


	//Display the description of the Dim
	Point3d ptTxtOp34 = ptVisOp34+vx*U(dOffsetText);
	ptTxtOp34.transformBy(ms2ps);
	
	// draw the display of the dim
	if (ptDimOp34.length()>1)
	{
		if (bDesc) dpOp.draw("Opening", ptTxtOp34, vXTxt, vYTxt, 1, 0);
		dpOp.draw(dimOp34);
	}
}	

//DIM THE SIPs
//Point that are going to be dimmensioned
Point3d ptDimSip34[0];
//Base Point and line to make the dimlines
Point3d ptVisSip34 = ptRight+vx*(dOffset*1);
Line lnSip34 (ptVisSip34 , vy);

//Dim only the Panels that arenot over an openning
for (int i=0; i<opZ3Z4.length()-1; i++)
	for (int j=i+1; j<opZ3Z4.length(); j++)
		if (opZ3Z4[i]==opZ3Z4[j])
		{
			opZ3Z4.removeAt(j);
			j=i+1;
		}

Sip sipToBeDim34[0];
sipToBeDim34.append(spArrZ3);
sipToBeDim34.append(spArrZ4);
Sip sipOverOp34[0];
for (int i=0; i<sipToBeDim34.length()-1; i++)
	for (int j=i+1; j<sipToBeDim34.length(); j++)
		if (sipToBeDim34[i]==sipToBeDim34[j])
		{
			sipToBeDim34.removeAt(j);
			j=i+1;
		}

if (sipToBeDim34.length()>0)
{
	for (int i=0; i<opZ3Z4.length(); i++)
	{
		PLine shape=opZ3Z4[i].plShape();
		Body bdOp(shape, vz*U(100), 1);
		Body bdOp2=bdOp;
		bdOp.transformBy(vy*opZ3Z4[i].width());
		bdOp+=bdOp2;
		bdOp2.transformBy(-vy*opZ3Z4[i].width());
		bdOp+=bdOp2;
		for (int j=0; j<sipToBeDim34.length(); j++)
			if (sipToBeDim34[j].envelopeBody().hasIntersection(bdOp))
			{
				sipOverOp34.append(sipToBeDim34[j]);
				sipToBeDim34.removeAt(j);
				j=0;
			}
	}

	//Display the name of the Panels that are being dimensioned
	Point3d ptMess34=ptVisSip34+vy*(dPanelHeight+U(100));
	ptMess34.transformBy(ms2ps);
	String sMess34;
	for (int i=0; i<sipToBeDim34.length(); i++)
	{
		if (i==0)
		{
			sMess34=sipToBeDim34[0].label();
			sMess34+=sipToBeDim34[0].subLabel();
		}
		else
		{
			sMess34+=",";
			sMess34+=sipToBeDim34[i].subLabel();
		}
	}

	dp.draw (sMess34, ptMess34, vXTxt, vYTxt, 1, 0);
	
	//Display the name of the Panels that are dimensioned over and under the opening
	ptMess34=ptVisOp34+vy*(dPanelHeight+U(100));
	ptMess34.transformBy(ms2ps);
	sMess34="";
	for (int i=0; i<sipOverOp34.length(); i++)
	{
		if (i==0)
		{
			sMess34=sipOverOp34[0].label();
			sMess34+=sipOverOp34[0].subLabel();
		}
		else
		{
			sMess34+=",";
			sMess34+=sipOverOp34[i].subLabel();
		}
	}

	dp.draw (sMess34, ptMess34, vXTxt, vYTxt, 1, 0);


	// make up a dimline
	DimLine dlSip34(ptVisSip34, vy, -vx);
	ptDimSip34.setLength(0);
	ptDimSip34.append(dlSip34.collectDimPoints(sipToBeDim34,_kLeftAndRight));

	//Proyect the point to one line
	ptDimSip34=lnSip34.projectPoints(ptDimSip34);
	Dim dimSip34 (dlSip34, ptDimSip34, "<>",  "<>", nDispDelta, nDispChain);
	dimSip34.transformBy(ms2ps);
	dimSip34.setReadDirection(vecRead);

	//Display the description of the Dim
	Point3d ptTxtSip34 = ptVisSip34+vx*U(dOffsetText);
	ptTxtSip34.transformBy(ms2ps);
	
	// draw the display of the dim
	if (ptDimSip34.length()>1)
	{
		if (bDesc) dpSp.draw("Panel", ptTxtSip34, vXTxt, vYTxt, 1, 0);
		dpSp.draw(dimSip34);
	}
}
		
//DIM THE ELEMENTs
//Point that are going to be dimmensioned
Point3d ptDimEl34[0];
//Base Point and line to make the dimlines
Point3d ptVisEl34 = ptRight+vx*(dOffset*3);
Line lnEl34 (ptVisEl34 , vy);

// make up a dimline
DimLine dlEl34(ptVisEl34, vy, -vx);
ptDimEl34.setLength(0);
if (bDimBP)
	ptDimEl34.append(ptBottom);
if (sp.length()!=0)
	ptDimEl34.append(ptBottomSp);
ptDimEl34.append(ptTop);

//Proyect the point to one line
ptDimEl34=lnEl34.projectPoints(ptDimEl34);
Dim dimEl34 (dlEl34, ptDimEl34, "<>",  "<>", nDispDelta, nDispChain);
dimEl34.transformBy(ms2ps);
dimEl34.setReadDirection(vecRead);

Point3d ptTxtEl34 = ptVisEl34+vx*U(dOffsetText);
ptTxtEl34.transformBy(ms2ps);


// draw the display of the dim
if (ptDimEl34.length()>1)
{
	if (bDesc) dpEl.draw("Element", ptTxtEl34, vXTxt, vYTxt, 1, 0);
	dpEl.draw(dimEl34);
}

//DIAGONAL
//Dim the diagonal
Point3d ptDiag[0];
ptDiag.append(Line (ptBottom, vx).closestPointTo(Line (ptLeft, vy)));
ptDiag.append(Line (ptTop, vx).closestPointTo(Line (ptRight, vy)));

//Vector in diagonal fro the elemet
Vector3d vecDiag=ptDiag[1]-ptDiag[0];
vecDiag.normalize();

//Vector for made the presentation of the Dimension
Vector3d vecPres=vz.crossProduct(vecDiag);
if (vecPres.dotProduct(vy)<0)
	vecPres=-vecPres;

DimLine dlDiag(ptDiag[0], vecDiag, vecPres);
Dim dimDiag (dlDiag, ptDiag, "<>",  "<>", nDispDelta);
dimDiag.transformBy(ms2ps);
if(bDimDiag)
{
 //dpEl.draw(dimDiag);
	LineSeg ls(ptDiag[1], ptDiag[0]);
	ls.transformBy(ms2ps);
	Point3d ptDiagTextDisp= _Pt0;
	//ptDiagTextDisp.transformBy(ms2ps);
	double dDiagonalLength=(ptDiag[1]-ptDiag[0]).length();
	String sDiagonalLength;
	sDiagonalLength.format("Diagonal: %4.0f", dDiagonalLength);
	//dp.draw (ls);
	dpEl.draw(sDiagonalLength, ptDiagTextDisp, _XW, _YW, 1, 1);
}
/*
else
{
	LineSeg ls(ptDiag[1], ptDiag[0]);
	ls.transformBy(ms2ps);
	Point3d ptDiagTextDisp= _Pt0;
	ptDiagTextDisp.transformBy(ms2ps);
	double dDiagonalLength=(ptDiag[1]-ptDiag[0]).length();
	String sDiagonalLength;
	sDiagonalLength.format("Diagonal: %4.0f", dDiagonalLength);
	dp.draw (ls);
	dp.draw(sDiagonalLength, ptDiagTextDisp, _XW, _YW, 1, 1);

}
*/

//EDGE MEASURE
/*for (int i=0; i<sp.length(); i++)
{
	SipEdge spEdge[]=sp[i].sipEdges();
	for (int j=0; j<spEdge.length(); j++)
	{
		Vector3d vecNor=spEdge[j].vecNormal();
		Point3d ptMess=spEdge[j].ptMid()-vecNor*U(50);
		vecNor.transformBy(ms2ps);
		ptMess.transformBy(ms2ps);
		double dDepth=spEdge[j].dRecessDepth();
		String str2=dDepth;
		dp.draw(str2, ptMess, vXTxt, vYTxt, 0, 0);
	}
}*/

//Display the detailCode and Bevel Angle
for (int i=0; i<sp.length(); i++)
{
	SipEdge spEdge[]=sp[i].sipEdges();
	Vector3d vecNSip = sp[i].vecZ();
	Point3d ptSipCen=sp[i].ptCen();
	vecNSip.transformBy(ms2ps);
	vecNSip.normalize();
	for (int j=0; j<spEdge.length(); j++)
	{
		Vector3d vecNor=spEdge[j].vecNormal();
		
		vecNor.normalize();
		Point3d ptMessOriginal=spEdge[j].ptMid();
		// Create a vector from the edge to the centre of the sip
		Point3d ptMessAngle;
		Vector3d vecEdgeToCentre=ptSipCen-ptMessOriginal;
		vecEdgeToCentre.normalize();
		double dResult=vecEdgeToCentre.dotProduct(vecNor);
		if(dResult>0)
		{
			Vector3d vecNorProjected=vecNor;
			vecNorProjected.projectVector(plnZ);
			plnZ.vis();
			vecNorProjected.normalize();
			ptMessAngle=ptMessOriginal+ vecNorProjected*U(dOffsetSplay);
		}
		else
		{
			Vector3d vecNorProjected=vecNor;
			vecNorProjected.projectVector(plnZ);
			vecNorProjected.normalize();
			ptMessAngle=ptMessOriginal- vecNorProjected*U(dOffsetSplay);
		}
		ptMessOriginal.transformBy(ms2ps);
		ptMessAngle.transformBy(ms2ps);
		vecNor.transformBy(ms2ps);
		vecNor.normalize();
		String str2=spEdge[j].detailCode();

		Vector3d vecRef = vecNSip.crossProduct(vecNor);
		vecRef.normalize();
		
		//double dBevel = abs(vecNSip.dotProduct(vecNor));
		double dBevel = vecNSip.dotProduct(vecNor);

		double dAngle = asin(dBevel);
		
		if (!(abs(dAngle -90)<0.1 || abs(dAngle -180)<0.1 || abs(dAngle -0)<0.1))
		{
			str2=str2+" "+dAngle;
			if (bDisplay)
			{
				dp.textHeight(dSplayTextHeight);
				dp.draw(str2, ptMessAngle, -vecRef, vecNor, 0, 0);
			}
		}
		else
		{
			if (bDisplay)
			{
				dp.textHeight(dSplayTextHeight);
				dp.draw(str2, ptMessOriginal, -vecRef, vecNor, 0, 0);
			}
		}
	}	
}

//Display dp1(1);
//plEnve.transformBy(ms2ps);
//dp1.draw(plEnve);

ptLeft.transformBy(ms2ps);
ptRight.transformBy(ms2ps);
ptTop.transformBy(ms2ps);
ptBottom.transformBy(ms2ps);

ptTop.vis(2);
ptBottom.vis(2);
ptLeft.vis(2);
ptRight.vis(2);



//Assign the TSL to the elementgroup
//assignToElementGroup(el, TRUE, 0, 'E');









#End
#BeginThumbnail











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