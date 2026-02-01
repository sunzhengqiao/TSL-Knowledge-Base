#Version 8
#BeginDescription
KR:1-6-2004: dimension the "oversail" of a particular sheeting zone to the zone 0 frame











#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 0
#MinorVersion 0
#KeyWords 
#BeginContents
String arHsbId[] = {"140","5000","4113","66","67","68","69","74","84","85","88","90","73","105","214"};//these timber ids will not appear in the dim lineType
/////

Unit(1,"mm"); // script uses mm

String arDir[]={"Horizontal","Vertical"};
PropString strDir(0,arDir,"Direction");

int arZone[]={-5,-4,-3,-2,-1,1,2,3,4,5};
PropInt nZone(0,arZone,"Zone index",5); // index 5 is default

String arTextDir[]={"None","Parallel","Perpendicular"};
int arITextDir[]={_kDimNone,_kDimPar, _kDimPerp};

PropString strTextDirD(3,arTextDir,"Delta text direction");
int nTextDirD = arITextDir[arTextDir.find(strTextDirD,0)];

PropString strTextDirC(4,arTextDir,"Cumm text direction",1);
int nTextDirC = arITextDir[arTextDir.find(strTextDirC,1)];

PropString sDimStyle(5,_DimStyles,T("|Dimstyle|"));

if (_bOnInsert) {
  
  reportMessage("\nAfter inserting you can change the OPM value to set the direction, and the zone.");
   _Pt0 = getPoint(); // select point
  Viewport vp = getViewport("Select a viewport, you can add others later on with the HSB_LINKTOOLS command."); // select viewport
  _Viewport.append(vp);

  return;

}

// set the diameter of the 3 circles, shown during dragging
setMarbleDiameter(U(4));

Display dp(1); // use color red
//dp.dimStyle("HSB-VP_floor"); // dimstyle was adjusted for display in paper space, sets textHeight
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


DimLine lnPs; // dimline in PS (Paper Space)
Vector3d vecDimDir; 
if (strDir=="Horizontal") {
  lnPs = DimLine(_Pt0, _XW, _YW );
  vecDimDir = _XW;
}
else {
  lnPs = DimLine(_Pt0, _YW, -_XW );
  vecDimDir = _YW;
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
ptStartS = pntsS[0];
ptEndS = pntsS[pntsS.length()-1];

// Define some vectors
Vector3d vecStartBS = vecDDMs.dotProduct(ptStartS-ptStartB)*vecDDMs;
Vector3d vecEndBS = vecDDMs.dotProduct(ptEndS-ptEndB)*vecDDMs;
double dEps = U(1,"mm"); // tolerance

if ((vecStartBS.length()>dEps)&&(vecStartBS.dotProduct(vecDDMs)<0)) { // oversail on start
  Point3d pntsMs[0]; // define array of points in MS
  pntsMs.append(ptStartB);
  pntsMs.append(ptStartS);
  Dim dim(lnMs,pntsMs,"<>","<>",nTextDirD,nTextDirC); // def in MS
  dim.transformBy(ms2ps); // transfrom the dim from MS to PS
  dp.draw(dim);
}
if ((vecEndBS.length()>dEps)&&(vecEndBS.dotProduct(vecDDMs)>0)) { // oversail on end
  Point3d pntsMs[0]; // define array of points in MS
  pntsMs.append(ptEndB);
  pntsMs.append(ptEndS);
  Dim dim(lnMs,pntsMs,"<>","<>",nTextDirD,nTextDirC); // def in MS
  dim.transformBy(ms2ps); // transfrom the dim from MS to PS
  dp.draw(dim); 
}











#End
#BeginThumbnail

#End
