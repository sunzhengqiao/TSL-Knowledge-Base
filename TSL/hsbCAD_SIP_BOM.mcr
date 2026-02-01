#Version 8
#BeginDescription
KR: 29-8-2003: second sample of BOM in PS layout
Dimension style used can be set in Hsb_Settings -> dimension -> TSL
Since currently the textsize cannot be determined from the style, it need to be hardcoded inside the script: see line 2 and 3.

KR: 15-9-2003: modified to use beams
KR: 23-9-2003: modified to use beams and all sheetings + sort on posnum + added color prop + added material
RH: 5-4-2004: Panel elemnt number added to table header + Name and Info added to table
RH: 16-6-2004: Translation for table headings 'name' & 'material' added to tsl
























#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
Unit(1,"mm"); // script uses mm

double dCH = 1.5; // character height
double dCW = 1.5; // character width


PropInt nColorIndex(0,0,"Header color");

if (_bOnInsert) {
  
   _Pt0 = getPoint("Select upper left point of rectangle"); // select point
  Viewport vp = getViewport("Select the viewport from which the element is taken"); // select viewport
  _Viewport.append(vp);

  return;

}

// set the diameter of the 3 circles, shown during dragging
setMarbleDiameter(U(4));

Display dp(-1); // use color of entity for frame
dp.dimStyle("BIG PANEL"); // dimstyle was adjusted for display in paper space, sets textHeight

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

/////////////////////////

CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps
Element el = vp.element();
int nZoneIndex = vp.activeZoneIndex();
String strHeader = T("Elevation Number")+ " :" +el.number();
// build lists of items to display
int nNum = 0; // number of different items; make sure nNum is always the size of the arrays
int arCount[0]; // counter of equal
String arW[0]; // width
String arL[0]; // length or height
int arPos[0]; // posnum
String arH[0]; // height
String arM[0]; // material
String arN[0]; // name
String arIn[0]; // info

// collect the items
{ // beams
  Beam arBeam[0]; 
  arBeam  = el.beam();
  for (int i=0; i<arBeam.length(); i++) {
    // loop over list items
    int bNew = TRUE;
    Beam bm = arBeam[i];
	double dBmL=bm.solidLength();
	String sLen;
	sLen.formatUnit(dBmL, 2, 0);
    for (int l=0; l<nNum; l++) {
      String strTim = String(bm.material());
      if (strTim=="") strTim = "Timber";
      if ( (String(int(bm.dH()))==arH[l])
           && (bm.posnum()==arPos[l])
           && (String(int(bm.dW()))==arW[l])
           && (sLen==arL[l])
           && (T(String(strTim))==arM[l])
	     && (String(bm.information())==arIn[l])
	     && (T(String(bm.name()))==arN[l]) ) {
        bNew = FALSE;
        arCount[l]++;
        break; // out of inner for loop, we have found the equal one
      }
    }
    if (bNew) { // a new item for the list is found
      String strTim = T(String(bm.material()));
      if (strTim=="") strTim = "Timber";
      arCount.append(1);
      arW.append(String(int(bm.dW())));
      arL.append(sLen);
      arPos.append(bm.posnum());
      arH.append(String(int(bm.dH())));
      arM.append(strTim);
      arIn.append(String(bm.information()));
      String strBeamName = T(String(bm.name()));
      arN.append(strBeamName);
      nNum++;
    }
  }
}
{ // sheeting
  Sheet arBeam[0]; 
  arBeam  = el.sheet();
  for (int i=0; i<arBeam.length(); i++) {
    // loop over list items
    int bNew = TRUE;
    Sheet bm = arBeam[i];
    for (int l=0; l<nNum; l++) {
      if ( (String(int(bm.solidLength()))==arH[l])
           && (bm.posnum()==arPos[l])
           && (String(int(bm.solidWidth()))==arW[l])
           && (String(bm.material())==arM[l])
           && (String(bm.information())==arIn[l])
           && (T(String(bm.name()))==arN[l]) ) {
        bNew = FALSE;
        arCount[l]++;
        break; // out of inner for loop, we have found the equal one
      }
    }
    if (bNew) { // a new item for the list is found
      arCount.append(1);
      arW.append(String(int(bm.solidWidth())));
      arPos.append(bm.posnum());
      arH.append(String(int(bm.solidLength())));
      arM.append(String(bm.material()));
      arL.append("");
      arIn.append(String(bm.information()));
      String StrSheetName = T(String(bm.name()));
      arN.append(StrSheetName);
      nNum++;
    }
  }
}

// here is the time to sort
// bubble sort on posnum
int nD;
String sD;
for (int b1=1; b1<nNum; b1++) {
  int lb1 = b1;
  for (int b2 = b1-1; b2>=0; b2--) {
    if (arPos[lb1]<arPos[b2]) {
      nD = arPos[b2]; arPos[b2] = arPos[lb1];  arPos[lb1] = nD;
      nD = arCount[b2]; arCount[b2] = arCount[lb1];  arCount[lb1] = nD;
      sD = arW[b2]; arW[b2] = arW[lb1];  arW[lb1] = sD;
      sD = arH[b2]; arH[b2] = arH[lb1];  arH[lb1] = sD;
      sD = arL[b2]; arL[b2] = arL[lb1];  arL[lb1] = sD;
      sD = arM[b2]; arM[b2] = arM[lb1];  arM[lb1] = sD;
      sD = arIn[b2]; arIn[b2] = arIn[lb1]; arIn[lb1] = sD;
      sD = arN[b2]; arN[b2] = arN[lb1]; arN[lb1] = sD;
      lb1=b2;
    }
  }
}

//translate headings
String strNumberT = T("No.");
String strNameT = T("Name");
String strWidthT = T("Width");
String strHeightT = T("Height");
String strLengthT = T("Length");
String strMaterialT = T("Material");
String strInformationT = T("Information");
String strQtyT = T("Qty") + " ";


// make lists to display
String arL0[] = {strNumberT};
String arL1[] = {strNameT};
String arL2[] = {strWidthT};
String arL3[] = {strHeightT};
String arL4[] = {strLengthT};
String arL5[] = {strMaterialT};
//String arL6[] = {strInformationT};
String arL7[] = {strQtyT};
for (int l=0; l<nNum; l++) {
  int nD = arPos[l];
  if (nD<0)  arL0.append("");
  else if (nD<10) arL0.append("00" + String(nD));
  else if (nD<100) arL0.append("0" + String(nD));
  else arL0.append(String(nD));
  arL7.append(String(arCount[l]));
  arL2.append(arW[l]);
  arL3.append(arH[l]);
  arL4.append(arL[l]);
  arL5.append(arM[l]);
  //arL6.append(arIn[l]);
  arL1.append(arN[l]);
}
nNum++; // added the labels

// find out colomn widths
int nW0 = 0,nW1 = 0,nW2 = 0,nW3 = 0,nW4 = 0,nW5 = 0,nW6 = 0,nW7 = 0;
for (int l=0; l<nNum; l++) {
  if (nW0<arL0[l].length()) nW0 = arL0[l].length();
  if (nW1<arL1[l].length()) nW1 = arL1[l].length();
  if (nW2<arL2[l].length()) nW2 = arL2[l].length();
  if (nW3<arL3[l].length()) nW3 = arL3[l].length();
  if (nW4<arL4[l].length()) nW4 = arL4[l].length();
  if (nW5<arL5[l].length()) nW5 = arL5[l].length();
  //if (nW6<arL6[l].length()) nW6 = arL6[l].length();
  if (nW7<arL7[l].length()) nW7 = arL7[l].length();
}

if (_bOnDebug) {
  reportMessage("\n");
  for (int l=0; l<nNum; l++) {
    reportMessage("\n");
    reportMessage(arL0[l] + " " );
    reportMessage(arL1[l] + " " );
    reportMessage(arL2[l] + " " );
    reportMessage(arL3[l] + " " );
    reportMessage(arL4[l] + " " );
    reportMessage(arL5[l] + " " );
    //reportMessage(arL6[l] + " " );
    reportMessage(arL7[l] + " " );
  }
  reportMessage("\n");
}

// ------- Draw outher border -------------
// calculate the total border width and height
int nWH = strHeader.length() + 2; // header width in number of characters
int nWC = (nW0 + nW1 + nW2 + nW3 + nW4 + nW5 + nW7 + 13); // coloms width in number of characters
int nWT = (nWH<nWC)?nWC:nWH; // total table width
double dWT = nWT*dCW;
double dHT = 2*nNum*dCH + 4*dCH; // 4 is the height of the header
Point3d ptLL = _Pt0 - dHT*_YW;
Point3d ptUR = _Pt0 + dWT*_XW;
Point3d ptLR( ptUR.X(), ptLL.Y(), 0 );
Point3d ptUL( ptLL.X(), ptUR.Y(), 0 );
PLine plBorder(ptLL,ptLR,ptUR,ptUL);
plBorder.addVertex(ptLL);
dp.draw(plBorder);

// ------- Draw header -------------
Point3d ptL0 = ptUL; // start from upper left
Point3d pt = ptL0 + dCW*_XW - dCH*_YW; 	
pt.vis(); 
dp.color(nColorIndex);
dp.draw(strHeader,pt,_XW,_YW,1,-1);
dp.color(-1);
Point3d ptHL = ptL0 - 3*dCH*_YW;
PLine plHeaderLine(ptHL, ptHL + dWT*_XW ); 
dp.draw(plHeaderLine);

// ------- Draw inner vertical lines -------------
// calculate the total border width and height
Point3d ptT = ptHL;
Point3d ptB = ptLL;
PLine plLineV(ptT,ptB);
Vector3d vecMove(0,0,0);
vecMove = 2*dCW*_XW + nW0*dCW*_XW; plLineV.transformBy(vecMove); dp.draw(plLineV);
vecMove = 2*dCW*_XW + nW1*dCW*_XW; plLineV.transformBy(vecMove); dp.draw(plLineV);
vecMove = 2*dCW*_XW + nW2*dCW*_XW; plLineV.transformBy(vecMove); dp.draw(plLineV);
vecMove = 2*dCW*_XW + nW3*dCW*_XW; plLineV.transformBy(vecMove); dp.draw(plLineV);
vecMove = 2*dCW*_XW + nW4*dCW*_XW; plLineV.transformBy(vecMove); dp.draw(plLineV);
vecMove = 2*dCW*_XW + nW5*dCW*_XW; plLineV.transformBy(vecMove); dp.draw(plLineV);
//vecMove = 2*dCW*_XW + nW6*dCW*_XW; plLineV.transformBy(vecMove); dp.draw(plLineV);


// ------- Draw text -------------
ptL0 = ptUL - 4*dCH*_YW; // start from upper left, subtract header
for (int l=0; l<nNum; l++) { // loop over each line.
  if (l==0) dp.color(nColorIndex);
  else dp.color(-1);

  Point3d ptL = ptL0 - 2*dCH*l*_YW;
  Point3d pt = ptL;

  /* 
  // right alignment
  pt = pt + 1*dCW*_XW + nW0*dCW*_XW; 	pt.vis(); dp.draw(arL0[l],pt,_XW,_YW,-1,-1);
  pt = pt + 2*dCW*_XW + nW1*dCW*_XW; 	pt.vis(); dp.draw(arL1[l],pt,_XW,_YW,-1,-1);
  pt = pt + 2*dCW*_XW + nW2*dCW*_XW; 	pt.vis(); dp.draw(arL2[l],pt,_XW,_YW,-1,-1);
  pt = pt + 2*dCW*_XW + nW3*dCW*_XW; 	pt.vis(); dp.draw(arL3[l],pt,_XW,_YW,-1,-1);
  pt = pt + 2*dCW*_XW + nW4*dCW*_XW; 	pt.vis(); dp.draw(arL4[l],pt,_XW,_YW,-1,-1); 
  pt = pt + 2*dCW*_XW + nW5*dCW*_XW; 	pt.vis(); dp.draw(arL5[l],pt,_XW,_YW,-1,-1); 
  */

  // horizontal line.
  if (l!=0) {
    Point3d ptLn = ptL + 0.4*dCH*_YW;
    PLine plLineH(ptLn, ptLn + dWT*_XW ); 
    dp.draw(plLineH);
  }

  // left alignment
  pt = pt + 1*dCW*_XW + nW0*dCW*_XW; 	pt.vis(); dp.draw(arL0[l],pt,_XW,_YW,-1,-1); // right
  pt = pt + 2*dCW*_XW ; 	pt.vis(); dp.draw(arL1[l],pt,_XW,_YW,1,-1); // left
  pt = pt + 2*dCW*_XW + nW1*dCW*_XW; 	pt.vis(); dp.draw(arL2[l],pt,_XW,_YW,1,-1);
  pt = pt + 2*dCW*_XW + nW2*dCW*_XW; 	pt.vis(); dp.draw(arL3[l],pt,_XW,_YW,1,-1);
  pt = pt + 2*dCW*_XW + nW3*dCW*_XW; 	pt.vis(); dp.draw(arL4[l],pt,_XW,_YW,1,-1); 
  pt = pt + 2*dCW*_XW + nW4*dCW*_XW; 	pt.vis(); dp.draw(arL5[l],pt,_XW,_YW,1,-1); 
  pt = pt + 2*dCW*_XW + nW5*dCW*_XW;  pt.vis(); //dp.draw(arL6[l],pt,_XW,_YW,1,-1);
  //pt = pt + 2*dCW*_XW + nW6*dCW*_XW;   
pt.vis(); dp.draw(arL7[l],pt,_XW,_YW,1,-1);

}
























#End
#BeginThumbnail

#End
