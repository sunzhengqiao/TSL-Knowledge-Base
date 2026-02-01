#Version 8
#BeginDescription
Displays hsbPosnum numbers in shop drawings
v1.0: 19.mar.2013: David Rueda (dr@hsb-cad.com)
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
/*
  COPYRIGHT
  ---------------
  Copyright (C) 2011 by
  hsbSOFT 

  The program may be used and/or copied only with the written
  permission from hsbSOFT, or in accordance with
  the terms and conditions stipulated in the agreement/contract
  under which the program has been supplied.

  All rights reserved.

 REVISION HISTORY
 -------------------------

 v0.0: 19.mar.2013: David Rueda (dr@hsb-cad.com)
	- Copied from Numbers on Panels, to keep US content folder naming standards
	- Thumbnail added
	- _DimStyles array added at prop. selection
 v1.0: 19.mar.2013: David Rueda (dr@hsb-cad.com)
	- Version control from 0.0 to 1.0, to keep safe versioning
*/

int nLunit = 2; // architectural (only used for beam length, others depend on hsb_settings)
int nPrec = 0; // precision (only used for beam length, others depend on hsb_settings)

// modify the next 2 arrays, which hsbId should be translated into which code
String arHsbId[]={"18"     , "32"                   ,"4"                ,"3"              ,"5"                ,"71",    "78"      ,"77"     ,"94"                ,"83"              ,"86"              ,"73"            ,"74"           ,"79"          ,"80"         ,"95"                        ,"96"                        ,"99"                       ,"138"            ,"139","140","10002","10003","130"      ,"105"                   ,"214"                  ,"84"                       ,"85"                     ,"88"                     ,"90"                      ,"66"                     ,"67"                      ,"68"                    ,"69" };
String arCode[]={"Stud"   , "Bottom Plate"  , "Top Plate"  ,"Top Rail","Top Rail","Beam","Beam","Beam","Window Rail","Frame Rail","Frame Rail","Cripples", "Cripples","Cripples","Cripples","Jacks Under Ope","Jacks Under Ope","Jacks Under Ope","Point Load","Vent","Vent","Vent"   ,"Vent"   ,"Pocket","Jacks Over Ope","Jacks Over Ope","Jacks Over Ope","Jacks Over Ope","Jacks Over Ope","Jacks Over Ope","Jacks Over Ope","Jacks Over Ope","Jacks Over Ope","Jacks Over Ope"};
String arSortId[]={"8"       , "1"                     ,"2"                ,"2"                ,"5"                ,"3"       ,"3"        ,"3"        ,"5"                   ,"5"               ,"5"                ,"4"           ,"4"           ,"4"             ,"4"            ,"6"                          ,"6"                         ,"6"                          ,"9"              ,"9"      ,"9"    ,"9"       ,"9"        ,"9"         ,"6"                         ,"6"                       ,"6"                        ,"6"                       ,"6"                        ,"6"                       ,"6"                       ,"6"                        ,"6"                        ,"6"};
String strAlfabet = "ABCDEFGHJKLMNOPQRSTUVWXYZ";
//////////////////////////////////////////////////////////////////////////////////////String strAlfabet = "ABCDEFGHJKLMNOPQRSTUVWXYZ";
//////////////////////////////////////////////////////////////////////////////////////

Unit(1,"mm"); // script uses mm

PropString strDimStyle(0,_DimStyles,"Dim style");
PropString propHeader(1,"Text can be changed in the OPM","Table header");
PropInt nColorIndex(0,3,"Header color");

String arTranslateId[]={"Yes","No"};
PropString strTranslateId(3,arTranslateId,"Translate hsbId");

if (_bOnInsert) {
  
   _Pt0 = getPoint("Select upper left point of rectangle"); // select point
  Viewport vp = getViewport("Select the viewport from which the element is taken"); // select viewport
  _Viewport.append(vp);

  return;

}

// set the diameter of the 3 circles, shown during dragging
setMarbleDiameter(U(4));

Display dp(-1); // use color of entity for frame
dp.dimStyle(strDimStyle); // dimstyle was adjusted for display in paper space, sets textHeight

double dCH = dp.textHeightForStyle("OK",strDimStyle); // character height
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
String arSL[0];//shortest length
String arPos[0]; // posnum
String arH[0]; // height
String arM[0]; // hsbId
String arS[0]; // sortId
String arLabelList[0];//
int j;
Point3d test;
Point3d arPtOrg[0];
Point3d arPtOrgA[0];
Point3d arPtOrgB[0];
Point3d arPtDraw[0];
int intPtDraw = 0;
String arLabel[0];
String	arCN[0];
String  arCP[0];

// collect the items
// beams
{
  Beam arBeam[0]; 
  arBeam  = el.beam();
  for (int i=0; i<arBeam.length(); i++) {
    // loop over list items
    int bNew = TRUE;
    Beam bm = arBeam[i];
    for (int l=0; l<nNum; l++) {

      String strPos = String(bm.posnum());
	if (strPos=="-1") strPos = "";

      String strTim = bm.name("hsbId");
      if (strTranslateId==arTranslateId[0]) { // yes translate the id
        strTim = arCode[ arHsbId.find(strTim,0) ];
      }
      String strLength; strLength.formatUnit(bm.solidLength(),nLunit,nPrec);
      String strWidth; strWidth.formatUnit(bm.dW(),strDimStyle);
      String strHeight; strHeight.formatUnit(bm.dH(),strDimStyle);
      if ( (strHeight==arH[l])
           && (strPos==arPos[l])
           && (strWidth==arW[l])
           && (strLength==arL[l])
           && (String(strTim)==arM[l])
           ) {
        bNew = FALSE;
        arCount[l]++;
         j = l;
        break; // out of inner for loop, we have found the equal one
      }
    }
    if (bNew) { // a new item for the list is found

      String strPos = String(bm.posnum());
	if (strPos=="-1") strPos = "";

      String strTim = String(bm.name("hsbId"));
      if (strTranslateId==arTranslateId[0]) { // yes translate the id
        strTim = arCode[ arHsbId.find(strTim,0) ];
      }

      j = nNum;

      String strLength; strLength.formatUnit(bm.solidLength(),nLunit,nPrec);
      String strWidth; strWidth.formatUnit(bm.dW(),strDimStyle);
      String strHeight; strHeight.formatUnit(bm.dH(),strDimStyle);
      arCount.append(1);
      arW.append(strWidth);
      arL.append(strLength);
      arPos.append(strPos);
      arH.append(strHeight);
      arM.append(strTim);

	arCN.append(bm.strCutN());
	arCP.append(bm.strCutP());


 //get the angle of the beam on the positive side of the beam Add a ">" sign to it (this is the token).
  String sCutAngle = bm.strCutP() + ">";
  //filter the angle out of sCutAngle (0.00>30.00>). Get index 1 of the string use ">" as seperation sign.
  String sAngle = sCutAngle.token(1,">");
  //Convert angle to double
  double dAngle = sAngle.atof();

  String sCutAngleN = bm.strCutN() + ">";
  //filter the angle out of sCutAngle (0.00>30.00>). Get index 1 of the string use ">" as seperation sign.
  String sAngleN = sCutAngleN.token(1,">");
  //Convert angle to double
  double dAngleN = sAngleN.atof();

  // Calculate new length of beam
  double dBmLength = bm.solidLength() - abs( bm.dW()*tan(dAngle) )- abs( bm.dW()*tan(dAngleN) );
  // Convert to int.
  dBmLength = dBmLength + 0.5;
  dBmLength = (int)dBmLength;

 	
 // if (1== abs(bm.vecX().dotProduct(el.vecY()))){
    arSL.append(dBmLength);
//	}
//	else{
//     arSL.append("---");

//  }	


  


	



	String strSId = arSortId[ arCode.find(strTim,0) ] ;
	arS.append(arSortId[ arCode.find(strTim,0) ] );
	
	String strLabel =  strAlfabet.getAt(j);
	if (j>24){
		strLabel = "A" + strAlfabet.getAt(j-25);
	}
      arLabelList.append(strLabel);

  //   arLabelList.append(strAlfabet.getAt(j));
      nNum++;
    }
    arPtOrg.append(bm.ptCen());
    arPtOrgA.append(bm.ptCen()+bm.dL()/4 *bm.vecX());
    arPtOrgB.append(bm.ptCen()-bm.dL()/4 *bm.vecX());
	
	String strLabel =  strAlfabet.getAt(j);
	if (j>24){
		strLabel = "A" + strAlfabet.getAt(j-25);
	}
 String strPos = String(bm.posnum());
    arLabel.append(strPos);
  }
}


// here is the time to sort
// bubble sort on posnum
int nD;
String sD;
for (int b1=1; b1<nNum; b1++) {
  int lb1 = b1;
  for (int b2 = b1-1; b2>=0; b2--) {
    if (arS[lb1]<arS[b2]) {
      sD = arPos[b2]; arPos[b2] = arPos[lb1];  arPos[lb1] = sD;
      nD = arCount[b2]; arCount[b2] = arCount[lb1];  arCount[lb1] = nD;
      sD = arW[b2]; arW[b2] = arW[lb1];  arW[lb1] = sD;
      sD = arH[b2]; arH[b2] = arH[lb1];  arH[lb1] = sD;
      sD = arL[b2]; arL[b2] = arL[lb1];  arL[lb1] = sD;
      sD = arSL[b2]; arSL[b2] = arSL[lb1];  arSL[lb1] = sD;
      sD = arM[b2]; arM[b2] = arM[lb1];  arM[lb1] = sD;
	sD = arS[b2]; arS[b2] = arS[lb1];  arS[lb1] = sD;
	sD = arLabelList[b2]; arLabelList[b2] = arLabelList[lb1];  arLabelList[lb1] = sD;
	sD = arCN[b2]; arCN[b2] = arCN[lb1];  arCN[lb1] = sD;
	sD = arCP[b2]; arCP[b2] = arCP[lb1];  arCP[lb1] = sD;
      lb1=b2;
    }
  }
}


// make lists to display
String arL0[] = {"HsbId"};
if (strTranslateId==arTranslateId[0]) { // yes translate the id
      arL0[0] = "Name";}
String arL1[] = {"La."};
String arL2[] = {"Qt"};
String arL3[] = {"W"};
String arL4[] = {"H"};
String arL5[] = {"L"};
String arL6[] = {"CN"};
String arL7[] = {"CP"};
String arL8[] = {"SL"};



for (int l=0; l<nNum; l++) {
/*
  int nD = arPos[l];
  if (nD<0)  arL0.append("");
  else if (nD<10) arL0.append("00" + String(nD));
  else if (nD<100) arL0.append("0" + String(nD));
  else arL0.append(String(nD));
*/
  arL0.append(arM[l]);
  arL2.append(String(arCount[l]));
  arL3.append(arW[l]);
  arL4.append(arH[l]);
  arL5.append(arL[l]);
  arL1.append(arLabelList[l]);
  arL6.append(arCN[l]);
  arL7.append(arCP[l]);
  arL8.append(arSL[l]);
}
nNum++; // added the labels

// find out colomn widths
int nW0 = 0,nW1 = 0,nW2 = 0,nW3 = 0,nW4 = 0,nW5 = 0,nW6=0,nW7=0,nW8=0;
for (int l=0; l<nNum; l++) {
  if (nW0<arL0[l].length()) nW0 = arL0[l].length();
  if (nW1<arL1[l].length()) nW1 = arL1[l].length();
  if (nW2<arL2[l].length()) nW2 = arL2[l].length();
  if (nW3<arL3[l].length()) nW3 = arL3[l].length();
  if (nW4<arL4[l].length()) nW4 = arL4[l].length();
  if (nW5<arL5[l].length()) nW5 = arL5[l].length();
  if (nW6<arL6[l].length()) nW6 = arL6[l].length();
  if (nW7<arL7[l].length()) nW7 = arL7[l].length();
  if (nW8<arL7[l].length()) nW8 = arL7[l].length();
}



// ------- Draw outher border -------------
// calculate the total border width and height
int nWH = propHeader.length() + 2; // header width in number of characters
int nWC = (nW0 );
int nWT = (nWH<nWC)?nWC:nWH; // total table width
double dWT = nWT*dCW;
double dHT = 2*nNum*dCH + 4*dCH; // 4 is the height of the header
Point3d ptLL = _Pt0 - dHT*_YW;
Point3d ptUR = _Pt0 + dWT*_XW;
Point3d ptLR( ptUR.X(), ptLL.Y(), 0 );
Point3d ptUL( ptLL.X(), ptUR.Y(), 0 );

CoordSys csVp = _Viewport[0].coordSys();


for (int i=0; i<arPtOrg.length(); i++) {

   test = arPtOrg[i];
  test.transformBy(csVp);	
    
 int OK = 1;
 for (j=0;j<arPtDraw.length();j++) {
		Vector3d dAfstand(arPtDraw[j]-test);
	if (dAfstand.length() < dCH*3) {
			OK =0;
      }
 }
	
   if (OK==0){
	   test = arPtOrgA[i]; 
 	   test.transformBy(csVp);	
   		int OK = 1;
           for (j=0;j<arPtDraw.length();j++) {
		    Vector3d dAfstand(arPtDraw[j]-test);
	      	if (dAfstand.length() < dCH*3) {
			     OK =0;
               }
            }
		if (OK==0){

			 test = arPtOrgB[i]; 
  			   test.transformBy(csVp);	

		}
 }	

    arPtDraw.append(test);

    dp.draw(arLabel[i],test,_XW,_YW,0,0   );	

    double dHa= dCH ;
    ptLL = test - dHa *_YW - dHa*_XW;
    ptUR =  test + dHa*_YW + dHa*_XW;
    ptLR = test + dHa*_YW - dHa*_XW;
    ptUL = test - dHa*_YW + dHa*_XW;

   PLine plBorder(ptLL,ptLR,ptUR,ptUL);
  plBorder.addVertex(ptLL);
  // dp.draw(plBorder);
}
#End
#BeginThumbnail
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
$0!__V5%`
`

#End
