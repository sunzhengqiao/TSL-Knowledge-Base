#Version 8
#BeginDescription
Generates BOM (Bill Of Material) of sheetings)
v1.4: 01.ago.2012: David Rueda (dr@hsb-cad.com)
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 4
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2011 by
*  hsbSOFT 
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
* v1.4: 01.ago.2012: David Rueda (dr@hsb-cad.com)
	- Description added
	- Copyright added
Version 1.3 Can now remove a lines on the table
Version 1.2 Can now set Table Headers in OPM
Version 1.1 Change frame color (ED Demtec)
*
*/


Unit(1,"mm"); // script uses mm

PropString strDimStyle(0,_DimStyles,"Dim style");

PropString strEmpty(1," ", "Headers");
strEmpty.setReadOnly(TRUE);

PropString propHeader(2,"Sheeting List","  Table header");
PropString propMat(3,"Mat.","  Material header");
PropString propQty(4,"Qty","  Qty header");
PropString propW(5,"Width","  Width header");
PropString propH(6,"Height","  Height header");
PropString propNum(7,"Num.","  Number header");
PropString propZone(8,"Zone","  Zone header");



String arChoices []={"Top","Bottom"};
PropString strJustify(9,arChoices,"Justification");


PropInt nColorIndex(0,3,"Header color",7);// Default is white/black

String arAllZones[]={"Use zone index","All"};
PropString strAllZones(10,arAllZones,"Zones to use");

int arZone[]={-5,-4,-3,-2,-1,1,2,3,4,5,10};
PropInt nZone(1,arZone,"Zone index",5); // index 5 is default

String arYN[]={"Yes","No"};
PropString strMultiply(11,arYN,"Multiply output by 25.4",1);
double dmm=1;
if(strMultiply==arYN[0])dmm=25.4;

PropString strFilter(12,"GYP","Filter Material");
strFilter.makeUpper();


PropDouble d1(0,U(101),"Width Material Col.");
PropDouble d2(1,U(101),"Width Qty Col.");
PropDouble d3(2,U(101),"Width Width Col.");
PropDouble d4(3,U(101),"Width Height Col.");
PropDouble d5(4,U(101),"Width Num Col.");
PropDouble d6(5,U(101),"Width Zone Col.");

if (_bOnInsert) {
  if(insertCycleCount()>1)eraseInstance();
  showDialog();
   _Pt0 = getPoint("Select upper left point of rectangle"); // select point
  Viewport vp = getViewport("Select the viewport from which the element is taken"); // select viewport
  _Viewport.append(vp);

  return;

}

// set the diameter of the 3 circles, shown during dragging
setMarbleDiameter(U(4));

Display dp(-1); // use color of entity for frame
dp.dimStyle(strDimStyle); // dimstyle was adjusted for display in paper space, sets textHeight

double dCH = dp.textHeightForStyle("O",strDimStyle); // character height
double dCW =  dp.textLengthForStyle("OK",strDimStyle)/2; // character width

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

// build lists of items to display
int nNum = 0; // number of different items; make sure nNum is always the size of the arrays
int arCount[0]; // counter of equal
String arW[0]; // width
String arL[0]; // length or height
String arPos[0]; // posnum
String arH[0]; // height
String arM[0]; // material
int arZones[0];

// collect the items
{ // sheeting
  Sheet arBeam[0]; 
int arNZones[0];
  if ((strAllZones==arAllZones[0])&&(nZone!=0)) {
	//arBeam  = el.sheet(nZone);
	Sheet arShAll[] = el.sheet(nZone); 
	for (int i=0; i<arShAll.length(); i++) {
		arBeam.append(arShAll[i]);
		arNZones.append(nZone);
	}
}
	
  else {///Filter here
	for( int z = -5; z<6;z++){
		Sheet arShAll[] = el.sheet(z); 
		if(strFilter.length()>1){
			for (int i=0; i<arShAll.length(); i++) {
				String strMatSheet=arShAll[i].material();strMatSheet.makeUpper();
				if(strFilter.spanIncluding( strMatSheet)!=strFilter){
					arBeam.append(arShAll[i]);
					arNZones.append(z);
				}
			}
		}
		else {
			for (int i=0; i<arShAll.length(); i++) {
				arBeam.append(arShAll[i]);
				arNZones.append(z);
			}
		}		
	}
}
		
		
  for (int i=0; i<arBeam.length(); i++) {
    // loop over list items
    int bNew = TRUE;
    Sheet bm = arBeam[i];
    
    for (int l=0; l<nNum; l++) {
      String strLength; strLength.formatUnit(bm.solidLength()*dmm,strDimStyle);
      String strWidth; strWidth.formatUnit(bm.solidWidth()*dmm,strDimStyle);
	int nZ=arNZones[i];
      if ( (strLength==arH[l])
           && (String(bm.posnum())==arPos[l])
           && (strWidth==arW[l])
           && (String(bm.material())==arM[l])
	   && (arNZones[i]==arZones[l])
           ) {
        bNew = FALSE;
        arCount[l]++;
        break; // out of inner for loop, we have found the equal one
      }
    }
    if (bNew) { // a new item for the list is found
      String strLength; strLength.formatUnit(bm.solidLength()*dmm,strDimStyle);
      String strWidth; strWidth.formatUnit(bm.solidWidth()*dmm,strDimStyle);
      arCount.append(1);
      arW.append(strWidth);
      arPos.append(String(bm.posnum()));
      arH.append(strLength);
      arM.append(String(bm.material()));
      arZones.append(arNZones[i]);
      arL.append("");
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
      sD = arPos[b2]; arPos[b2] = arPos[lb1];  arPos[lb1] = sD;
      nD = arCount[b2]; arCount[b2] = arCount[lb1];  arCount[lb1] = nD;
      sD = arW[b2]; arW[b2] = arW[lb1];  arW[lb1] = sD;
      sD = arH[b2]; arH[b2] = arH[lb1];  arH[lb1] = sD;
      sD = arL[b2]; arL[b2] = arL[lb1];  arL[lb1] = sD;
      sD = arM[b2]; arM[b2] = arM[lb1];  arM[lb1] = sD;
      lb1=b2;
    }
  }
}


// make lists to display
String arL0[] = {propMat};
String arL1[] = {propQty};
String arL2[] = {propW};
String arL3[] = {propH};
//String arL4[] = {"Length"};
String arL4[] = {propNum};
String arL5[] = {propZone};
for (int l=0; l<nNum; l++) {
/*
  int nD = arPos[l];
  if (nD<0)  arL0.append("");
  else if (nD<10) arL0.append("00" + String(nD));
  else if (nD<100) arL0.append("0" + String(nD));
  else arL0.append(String(nD));
*/
  arL0.append(arM[l]);
  arL1.append(String(arCount[l]));
  arL2.append(arW[l]);
  arL3.append(arH[l]);
// arL4.append(arL[l]);
  arL4.append(arPos[l]);
arL5.append(arZones[l]);
}
nNum++; // added the labels

// find out colomn widths
int nW0 = 0,nW1 = 0,nW2 = 0,nW3 = 0,nW4 = 0,nW5 = 0;
for (int l=0; l<nNum; l++) {
  if (nW0<arL0[l].length()) nW0 = d1;//arL0[l].length();
  if (nW1<arL1[l].length()) nW1 = d2;//arL1[l].length();
  if (nW2<arL2[l].length()) nW2 = d3;//arL2[l].length();
  if (nW3<arL3[l].length()) nW3 = d4;//arL3[l].length();
  if (nW4<arL4[l].length()) nW4 = d5;//arL4[l].length();
  if (nW5<arL5[l].length()) nW5 = d6;//arL5[l].length();
}

if (_bOnDebug) {
  reportMessage("\n");
  for (int l=0; l<nNum; l++) {
    reportMessage("\n");
    reportMessage(arL0[l] + " " );
    reportMessage(arL1[l] + " " );
    reportMessage(arL2[l] + " " );
    reportMessage(arL3[l] + " " );
   // reportMessage(arL4[l] + " " );
    reportMessage(arL4[l] + " " );
  }
  reportMessage("\n");
}

// ------- Draw outher border -------------
// calculate the total border width and height
int nWH = propHeader.length(); // header width in number of characters
int nWC = (nW0 + nW1 + nW2 + nW3 + nW4 + nW5 + 4); // coloms width in number of characters
int nWT = (nWH<nWC)?nWC:nWH; // total table width
double dWT = nWT*dCW;
double dHT = 2*nNum*dCH + 4*dCH; // 4 is the height of the header

Point3d pt0New;
if(strJustify==arChoices[0])pt0New=_Pt0;
else pt0New=_Pt0+_YW*dHT;

Point3d ptLL = pt0New - dHT*_YW;ptLL.vis(1);
Point3d ptUR = pt0New + dWT*_XW;ptUR.vis(1);
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
dp.draw(propHeader,pt,_XW,_YW,1,-1);
dp.color(0);
Point3d ptHL = ptL0 - 3*dCH*_YW;
PLine plHeaderLine(ptHL, ptHL + dWT*_XW ); 
dp.draw(plHeaderLine);

// ------- Draw inner vertical lines -------------
// calculate the total border width and height
Point3d ptT = ptHL;
Point3d ptB = ptLL;
PLine plLineV(ptT,ptB);
Vector3d vecMove(0,0,0);
int n1=1,n2=1,n3=1,n4=1,n5=1;
if(d2==0)n1=0;
if(d3==0)n2=0;
if(d4==0)n3=0;
if(d5==0)n4=0;
if(d6==0)n5=0;

if(d2>0){vecMove = n1*dCW*_XW + nW0*dCW*_XW; plLineV.transformBy(vecMove); dp.draw(plLineV);}
if(d3>0){vecMove = n2*dCW*_XW + nW1*dCW*_XW; plLineV.transformBy(vecMove); dp.draw(plLineV);}
if(d4>0){vecMove = n3*dCW*_XW + nW2*dCW*_XW; plLineV.transformBy(vecMove); dp.draw(plLineV);}
if(d5>0){vecMove = n4*dCW*_XW + nW3*dCW*_XW; plLineV.transformBy(vecMove); dp.draw(plLineV);}
if(d6>0){vecMove = n5*dCW*_XW + nW4*dCW*_XW; plLineV.transformBy(vecMove); dp.draw(plLineV);}


// ------- Draw text -------------
ptL0 = ptUL - 4*dCH*_YW; // start from upper left, subtract header
for (int l=0; l<nNum; l++) { // loop over each line.
  if (l==0) dp.color(nColorIndex);
  else dp.color(7);

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
pt = pt + 1*dCW*_XW;pt.vis(); dp.draw(arL0[l],pt,_XW,_YW,1,-1);
if(d2>0){pt = pt + 1*dCW*_XW + nW0*dCW*_XW; dp.draw(arL1[l],pt,_XW,_YW,1,-1);} // left}
if(d3>0){pt = pt + 1*dCW*_XW + nW1*dCW*_XW; 	pt.vis(); dp.draw(arL2[l],pt,_XW,_YW,1,-1);}
if(d4>0){pt = pt + 1*dCW*_XW + nW2*dCW*_XW; 	pt.vis(); dp.draw(arL3[l],pt,_XW,_YW,1,-1);}
if(d5>0){pt = pt + 1*dCW*_XW + nW3*dCW*_XW; 	pt.vis(); dp.draw(arL4[l],pt,_XW,_YW,1,-1); }
if(d6>0){pt = pt + 1*dCW*_XW + nW4*dCW*_XW;pt.vis(); dp.draw(arL5[l],pt,_XW,_YW,1,-1); }
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
M`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!
M0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`
M%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0
M`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`0
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
9H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`#_V0*`
`

















#End
