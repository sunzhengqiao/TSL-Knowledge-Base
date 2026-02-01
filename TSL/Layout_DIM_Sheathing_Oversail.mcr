#Version 8
#BeginDescription
KR:1-6-2004: dimension the "oversail" of a particular sheeting zone to the zone 0 frame
Last modified by: Alberto Jena (aj@hsb-cad.com)
01.02.2011  -  version 1.7
AJ: 22-05-2007
AJ: 23-05-2007
AJ: 04-06-2008





#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 7
#KeyWords 
#BeginContents
//String arHsbId[] = {"140","5000","4113","66","67","68","69","74","84","85","88","90","73","105","214"};//these timber ids will not appear in the dim lineType
/////

Unit(1,"mm"); // script uses mm

String arDir[]={"Horizontal","Vertical"};
PropString strDir(0,arDir,"Direction");

int arZone[]={-5,-4,-3,-2,-1,1,2,3,4,5};
PropInt nZone(0,arZone,"Zone index",5); // index 5 is default


//Used to set the dimensioning layout.
PropString sDimStyle(1, _DimStyles, T("Dimension Style"));

//Used to set the side of the text.
String sArDeltaOnTop[]={T("Above"),T("Below")};
int nArDeltaOnTop[]={TRUE,FALSE};
PropString sDeltaOnTop(2,sArDeltaOnTop,T("Side of delta dimensioning"),0);
int nDeltaOnTop = nArDeltaOnTop[sArDeltaOnTop.find(sDeltaOnTop,0)];

PropDouble dOffsetFromEl (0, U(150, 8), T("Offset From Element"));

String arTextDir[]={"None","Parallel","Perpendicular"};
int arITextDir[]={_kDimNone,_kDimPar, _kDimPerp};

PropString strTextDirD(3,arTextDir,"Delta text direction");
int nTextDirD = arITextDir[arTextDir.find(strTextDirD,0)];

PropInt nDimColor(1,1,T("Color"));
if (nDimColor < 0 || nDimColor > 255) nDimColor.set(0);


if (_bOnInsert)
{
  showDialogOnce();  
  reportMessage("\nAfter inserting you can change the OPM value to set the direction, and the zone.");
   _Pt0 = getPoint(); // select point
  Viewport vp = getViewport("Select a viewport, you can add others later on with the HSB_LINKTOOLS command."); // select viewport
  _Viewport.append(vp);

  return;

}

// set the diameter of the 3 circles, shown during dragging
setMarbleDiameter(U(4));

// do something for the last appended viewport only
if (_Viewport.length()==0) return; // _Viewport array has some elements
Viewport vp = _Viewport[_Viewport.length()-1]; // take last element of array
_Viewport[0] = vp; // make sure the connection to the first one is lost

// check if the viewport has hsb data
if (!vp.element().bIsValid()) return;

CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps
Element el = vp.element();

Display dp(nDimColor); // use color red
dp.dimStyle(sDimStyle,ps2ms.scale()); // dimstyle was adjusted for display in paper space, sets textHeight
//int nZoneIndex = vp.activeZoneIndex();

Point3d ptDim=el.ptOrg();
ptDim.transformBy(ms2ps);
	
DimLine lnPs; // dimline in PS (Paper Space)
Vector3d vecDimDir;
Line ln;
if (strDir=="Horizontal") {
	ptDim=ptDim-_YW*dOffsetFromEl;
  lnPs = DimLine(ptDim, _XW, _YW );//ptDim-_YW*dOffsetFromEl
  vecDimDir = _XW;
  ln= Line (el.ptOrg(), el.vecX());
}
else {
	ptDim=ptDim-_XW*dOffsetFromEl;
  lnPs = DimLine(ptDim, _YW, -_XW );
  vecDimDir = _YW;
  ln= Line (el.ptOrg(), el.vecY());
}
 
DimLine lnMs = lnPs; lnMs.transformBy(ps2ms); // dimline in MS (Model Space)
Vector3d vecDDMs = vecDimDir; vecDDMs.transformBy(ps2ms);
vecDDMs.normalize();

// find out the starting and ending point of the beams in zone 0. 
// For that, take the timber perpendicular to the dimline.
// In most negative direction is the starting point
Point3d ptStartB, ptEndB; // in model space

Beam arBeams[] = el.beam(); // collect all beams
Beam arRef[] = vecDDMs.filterBeamsPerpendicularSort(arBeams);
Point3d pnts[0]; // define array of points in MS
pnts.append(lnMs.collectDimPoints(arRef,_kLeftAndRight));
if (pnts.length()==0) return; // no points found
ptStartB = pnts[0];
ptEndB = pnts[pnts.length()-1];

// Start and end points of Sheeting
Point3d ptStartS = ptStartB; // in model space
Point3d ptEndS = ptEndB; // in model space

// take the sheeting from a zone
Sheet arSheets[] = el.sheet(nZone); // collect all sheet from the correct zone element 
Point3d pntsS[0]; // define array of points in MS
pntsS.append(lnMs.collectDimPoints(arSheets,_kLeftAndRight));
if (pntsS.length()==0) return; // no points found
pntsS=ln.orderPoints(pntsS);
pntsS=ln.projectPoints(pntsS);

ptStartS = pntsS[0];
ptEndS = pntsS[pntsS.length()-1];

Point3d ptLeft=ptStartS;
ptLeft.transformBy(ms2ps);ptLeft.vis(1);
Point3d ptRight=ptEndS;
ptRight.transformBy(ms2ps);ptRight.vis(1);

// Define some vectors
Vector3d vecStartBS = vecDDMs.dotProduct(ptStartS-ptStartB)*vecDDMs;
Vector3d vecEndBS = vecDDMs.dotProduct(ptEndS-ptEndB)*vecDDMs;
double dEps = U(1,"mm"); // tolerance

if ((vecStartBS.length()>dEps)) { // oversail on start &&(vecStartBS.dotProduct(vecDDMs)<0)
  Point3d pntsMs[0]; // define array of points in MS
  pntsMs.append(ptStartB);
  pntsMs.append(ptStartS);

  Dim dim(lnMs,pntsMs,"<>","<>",nTextDirD,_kDimNone); // def in MS
  dim.transformBy(ms2ps); // transfrom the dim from MS to PS
  dim.setDeltaOnTop(nDeltaOnTop);
  dp.draw(dim);
}

if ((vecEndBS.length()>dEps)) { // oversail on end &&(vecEndBS.dotProduct(vecDDMs)>0)
  Point3d pntsMs[0]; // define array of points in MS
  pntsMs.append(ptEndB);
  pntsMs.append(ptEndS);

  Dim dim(lnMs,pntsMs, "<>", "<>",nTextDirD,_kDimNone); // def in MS
  dim.transformBy(ms2ps); // transfrom the dim from MS to PS
  dim.setDeltaOnTop(nDeltaOnTop);
  dp.draw(dim);
}

if (_bOnDebug)
{
	// draw the scriptname at insert point
	Sheet shAux[]=el.sheet(nZone);
	for (int i=0; i<shAux.length(); i++)
	{
		Body bdSh=shAux[i].envelopeBody();
		bdSh.transformBy(ms2ps);
		bdSh.vis(2);
	}
	dp.draw(scriptName() ,_Pt0,_XW,_YW,1,1);
}





#End
#BeginThumbnail










#End
