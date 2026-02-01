#Version 8
#BeginDescription
V3.9
V3.8__Feb 6 2015__Implemnted sorting before collecting
V3.7__Jan 13 2015__Updated VTP to read V code as well as A
V3.6__Jan 29 2014__Will compare Grade field
V3.5_Aug 27 2013__Fixed the angle cuts
V3.4_April 8 2013__Adds Grade to Size
V3.3_May 11 2012__Shows Extrusion Profile name if none Rectangular
V3.2 Added some hsbIds
Verison 3.1 Revised Label placement
Veriosn 3.0 Tries to catch Unnamed Trusses
Version 2.9 Bugfix for plane projection of points
Version 2.8 Removed a litte circle on group labels
Version 2.7 Removed Blocking filter
Version 2.6 Enhanced to make it a little more compact
Version 2.5 Was missign last compoenents when switching to another table
Version 2.4 Has a flag to filter out blocking of Id 412,413 and 12
Verison 2.3 Added some Ids
Version 2.2 Uses the same cut and bevel if only one cut exists
Verison 2.1 Has a max of 15 rows
Veriosn 2.0  Will read Material field
Verison 1.9 Changes the Id for the LVL and Ledgers
Verison 1.8 Force the color to use OPM color
Version 1.7 Fixed Name Column Contents
Version 1.6 Added LVL & Joist Filler
Version 1.5 Added Furring Strips
Veriosn 1.4 Added some compasisons
Version 1.3 Added Vertical placement for the table
Version 1.2 Added Cantilever Blocks Id for floors/ceilings
Version 1.1 Added floor ID's
Version 1.0 Can set column widths to 0





































































#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 4
#MinorVersion 1
#KeyWords 
#BeginContents

String strAlfabet = "ABCDEFGHJKLMNOPQRSTUVWXYZ";

int bIgnorFlatBlocking=1;


Unit(1,"mm"); // script uses mm
int sIText []={1,2,3,4};

/////General properties
PropString strDimStyle(0,_DimStyles,"Dim style");
PropString propHeader(1,"Timber List","Table header");
PropInt nColorIndex(0,7,"Header color");

PropDouble dTH(0,U(0),"Letter size. If 0 uses Dimstyle");
PropInt intText (1,sIText,"Switch for Letter placement");
intText.set(2);

String arDir[]={"Horizontal","Vertical"};
PropString strDirection(2,arDir,"Table direction");
String arJustify[]={"Top","Bottom"};
PropString strJustify(3,arJustify,"Table Justification");

String arTranslateId[]={"Yes","No"};
PropString strTranslateId(4,arTranslateId,"Translate hsbId");

PropString vtpIgnor(5,arTranslateId,"Ignor VTP",1);
//PropString strForceMat(6,arTranslateId,"Force Material to Name",0);
String strForceMat=arTranslateId[0];



PropDouble dmm(1,1,"Multiply output by");
dmm.setFormat(_kNone);

Vector3d vXTbl=_XW;
Vector3d vYTbl=_YW;
vXTbl.vis(_Pt0,1);
vYTbl.vis(_Pt0,1);
if(strDirection==arDir[1]){
	vXTbl=_YW;
	vYTbl=-_XW;
}
vXTbl.vis(_Pt0,5);
vYTbl.vis(_Pt0,5);	

////////////width properties
PropString strEmpty0(6," "," ");
strEmpty0.setReadOnly(TRUE);

PropDouble d1(2,U(203.2),"Timber Name Col. Width");
PropDouble d2(3,U(152.0),"Size Col. Width");
PropDouble d3(4,U(152.0),"Label Col. Width");
PropDouble d4(5,U(101.6),"Qty. Col. Width");
PropDouble d5(6,U(152.0),"PosNum Col. Width");
PropDouble d6(7,U(101.6),"Width Col. Width");
PropDouble d7(8,U(101.6),"Height Col. Width");
PropDouble d8(9,U(203.2),"Length Col. Width");
PropDouble d9(10,U(152.0),"Matrerial Col. Width");
PropDouble d10(11,U(152.0),"Grade Col. Width");
PropDouble d11(12,U(152.0),"CutN Angle Col. Width");
PropDouble d12(13,U(152.0),"CutN Bevel Col. Width");
PropDouble d13(14,U(152.0),"CutP Angle Col. Width");
PropDouble d14(15,U(152.0),"CutP Bevel Col. Width");

//////naming properties
PropString strEmpty1(7," "," ");
strEmpty1.setReadOnly(TRUE);

PropString All(8,"Unknown","All Other Beams");
PropString BP(9,"Bottom Plate","Bottom Plate");
PropString TP(10,"Top Plate","Top Plate");
PropString DTP(11," VTP","Very Top Plate");
PropString HDR(12,"Header","Header");
PropString Jack(13,"Jack","Supporting Beam");
PropString KING(14,"King","King Stud");
PropString Sill(15,"Sill","Window Rail");
PropString HDRC(16,"Hdr Cripple","Header Cripple");
PropString HDRS(17,"Hdr Sill","Header Sill");
PropString HDRP(18,"Hdr Plate","Header Plate");
PropString SILLC(19,"Sill Cripple","Sill Cripple");
PropString BLOCKING(20,"Blocking","Blocking");
PropString FBLOCKING(21,"Flat Blocking","Flat Blocking");
PropString StudL(22,"Stud","Studs on Left End of Panel");
PropString StudR(23,"Stud","Studs on Right End of Panel");
PropString Stud(24,"Stud","Studs");
PropString Ladder(25,"Ladder","Ladder on T-Junction");
PropString Post(26,"Post","Post");
PropString Strapping(27,"Strapping","Strapping");
PropString BLOCKINGUP(28,"Blocking UP","Blocking Up");
PropString BLOCKINGDN(29,"Blocking DN","Blocking DN");


PropString strEmpty2(30," "," ");
strEmpty2.setReadOnly(TRUE);

PropString Joist(31,"Joist","Joist");
PropString Rim(32,"Rim","Rim");
PropString Cantilever(33,"Joist","Cantilever Block");
PropString Furring(34,"Furring","Furring Strips");
PropString Filler(35,"Filler","Joist Filler");
PropString LVL(36,"LVL","Laminated Lumber");
PropString Ledger(37,"Ledger","Ledger");

PropInt nMaxRow(2,16,"Maximum rows");

PropString stAddGradeToSize(38,arTranslateId,"Add Grade to Size");

String arHsbId[0],arCode[0],arSortId[0];

arHsbId.append(""); arCode.append(All);arSortId.append("9"); //any timbers not picked up in the list below.
arHsbId.append("102"); arCode.append(HDRS);arSortId.append("3");//HDR SILL
arHsbId.append("105"); arCode.append(HDRC);arSortId.append("6");//HDR CRIPPLE
arHsbId.append("111"); arCode.append(Strapping);arSortId.append("9");//Strapping
arHsbId.append("114"); arCode.append(Stud);arSortId.append("7");//STUD
arHsbId.append("12"); arCode.append(BLOCKING);arSortId.append("9");//BLOCKING
arHsbId.append("130"); arCode.append(Post);arSortId.append("9");//Post
arHsbId.append("131"); arCode.append(Ladder);arSortId.append("9");//LADDER STUD
arHsbId.append("133"); arCode.append(Ladder);arSortId.append("9");//LADDER STUD
arHsbId.append("138"); arCode.append(Post);arSortId.append("9");//Post
arHsbId.append("18"); arCode.append(Stud);arSortId.append("7");//STUD
arHsbId.append("20000"); arCode.append(DTP);arSortId.append("1"); //VERY TOP PLATE
arHsbId.append("2020"); arCode.append(Furring);arSortId.append("9"); //VERY TOP PLATE

arHsbId.append("2023"); arCode.append(Ladder);arSortId.append("9");//Ladder
arHsbId.append("214"); arCode.append(HDRC);arSortId.append("6");//HDR CRIPPLE
arHsbId.append("24"); arCode.append(Stud);arSortId.append("7");//STUD
arHsbId.append("25"); arCode.append(Stud);arSortId.append("7");//STUDS under gable IN PANEL
arHsbId.append("26"); arCode.append(Stud);arSortId.append("7");//STUDS under gable IN PANEL
arHsbId.append("3"); arCode.append(TP);arSortId.append("1");//TOP PLATE ANGLED WALL SIDE1
arHsbId.append("30"); arCode.append(Stud);arSortId.append("7");//STUDS IN PANEL
arHsbId.append("3025"); arCode.append(KING);arSortId.append("8");//KING STUD
arHsbId.append("3026"); arCode.append(KING);arSortId.append("8");//KING STUD
arHsbId.append("32"); arCode.append(BP);arSortId.append("1"); //BOTTOM PLATE
arHsbId.append("4"); arCode.append(TP);arSortId.append("1"); //TOP PLATE
arHsbId.append("412"); arCode.append(FBLOCKING);arSortId.append("9");//FLAT Blocking
arHsbId.append("413"); arCode.append(FBLOCKING);arSortId.append("9");//FLAT Blocking
arHsbId.append("5"); arCode.append(DTP);arSortId.append("1");//VERY TOP PLATE ANGLED WALL SIDE 2
arHsbId.append("50"); arCode.append(Jack);arSortId.append("4");//JACK
arHsbId.append("55"); arCode.append(HDRC);arSortId.append("6");//HDR CRIPPLE
arHsbId.append("56"); arCode.append(HDRC);arSortId.append("6");//HDR CRIPPLE
arHsbId.append("57"); arCode.append(HDRC);arSortId.append("6");//HDR CRIPPLE
arHsbId.append("59"); arCode.append(HDRC);arSortId.append("6");//HDR CRIPPLE
arHsbId.append("66"); arCode.append(HDRC);arSortId.append("6");//HDR CRIPPLE
arHsbId.append("67"); arCode.append(HDRC);arSortId.append("6");//HDR CRIPPLE
arHsbId.append("68"); arCode.append(HDRC);arSortId.append("6");//HDR CRIPPLE
arHsbId.append("69"); arCode.append(HDRC);arSortId.append("6");//HDR CRIPPLE
arHsbId.append("70"); arCode.append(HDR);arSortId.append("2");//HEADER
arHsbId.append("71"); arCode.append(HDR);arSortId.append("2");//HEADER
arHsbId.append("7101"); arCode.append(HDRS);arSortId.append("3");//HDR SILL
arHsbId.append("7102"); arCode.append(HDRS);arSortId.append("3");//HDR SILL
arHsbId.append("1957"); arCode.append(HDRS);arSortId.append("3");//HDR SILL
arHsbId.append("7103"); arCode.append(HDRP);arSortId.append("3");//HDR PLATE
arHsbId.append("73"); arCode.append(Jack);arSortId.append("4");//JACK
arHsbId.append("74"); arCode.append(Jack);arSortId.append("4");//JACK
arHsbId.append("75"); arCode.append(KING);arSortId.append("8");//KING STUD
arHsbId.append("76"); arCode.append(KING);arSortId.append("8");//KING STUD
arHsbId.append("91"); arCode.append(KING);arSortId.append("8");//KING STUD
arHsbId.append("92"); arCode.append(KING);arSortId.append("8");//KING STUD
arHsbId.append("77"); arCode.append(HDR);arSortId.append("2");//HEADER
arHsbId.append("7801"); arCode.append(HDRP);arSortId.append("3");//HDR PLATE
arHsbId.append("78"); arCode.append(HDR);arSortId.append("2");//HEADER
arHsbId.append("79"); arCode.append(Jack);arSortId.append("4");//JACK
arHsbId.append("80"); arCode.append(Jack);arSortId.append("4");//JACK
arHsbId.append("81"); arCode.append(KING);arSortId.append("8");//KING STUD
arHsbId.append("82"); arCode.append(KING);arSortId.append("8");//KING STUD
arHsbId.append("83"); arCode.append(HDRS);arSortId.append("3");//HDR SILL
arHsbId.append("84"); arCode.append(HDRC);arSortId.append("6");//HDR CRIPPLE
arHsbId.append("85"); arCode.append(HDRC);arSortId.append("6");//HDR CRIPPLE
arHsbId.append("87"); arCode.append(KING);arSortId.append("8");//KING STUD
arHsbId.append("88"); arCode.append(HDRC);arSortId.append("6");//HDR CRIPPLE
arHsbId.append("89"); arCode.append(KING);arSortId.append("8");//KING STUD
arHsbId.append("90"); arCode.append(HDRC);arSortId.append("6");//HDR CRIPPLE
arHsbId.append("93"); arCode.append(Sill);arSortId.append("3");//HEADER
arHsbId.append("94"); arCode.append(Sill);arSortId.append("3");//SILL
arHsbId.append("86"); arCode.append(Sill);arSortId.append("3");//SILL
arHsbId.append("95"); arCode.append(SILLC);arSortId.append("5");//SILL CRIPPLE
arHsbId.append("96"); arCode.append(SILLC);arSortId.append("5");//SILL CRIPPLE
arHsbId.append("99"); arCode.append(SILLC);arSortId.append("5");//SILL CRIPPLE

arHsbId.append("4101"); arCode.append(Joist);arSortId.append("1");//Joist
arHsbId.append("4112"); arCode.append(Cantilever);arSortId.append("1");//Joist//Cantilever blocks
arHsbId.append("41146"); arCode.append(Joist);arSortId.append("1");//Joist
arHsbId.append("41148"); arCode.append(Joist);arSortId.append("1");//Joist
arHsbId.append("80002"); arCode.append(Joist);arSortId.append("1");//Joist
arHsbId.append("4113"); arCode.append(BLOCKING);arSortId.append("9");//Floor BLOCKING
arHsbId.append("80001"); arCode.append(Rim);arSortId.append("3");//Rim
arHsbId.append("41142"); arCode.append(Rim);arSortId.append("3");//Rim
arHsbId.append("41144"); arCode.append(Rim);arSortId.append("3");//Rim
arHsbId.append("41141"); arCode.append(Rim);arSortId.append("3");//Rim
arHsbId.append("41145"); arCode.append(Rim);arSortId.append("3");//Rim
arHsbId.append("41147"); arCode.append(Rim);arSortId.append("3");//Rim
arHsbId.append("41143"); arCode.append(Rim);arSortId.append("3");//Rim
arHsbId.append("10000"); arCode.append(Filler);arSortId.append("5");//Joist Filler
arHsbId.append("10001"); arCode.append(LVL);arSortId.append("5");//LVL
arHsbId.append("10200"); arCode.append(Ledger);arSortId.append("5");//Ledger



if (_bOnInsert) {
showDialog ();  
   _Pt0 = getPoint("Select upper left point of rectangle"); // select point
  Viewport vp = getViewport("Select the viewport from which the element is taken"); // select viewport
  _Viewport.append(vp);

  return;

}

// set the diameter of the 3 circles, shown during dragging
setMarbleDiameter(U(4));

Display dp(nColorIndex); // use color of entity for frame
Display dpLTR(nColorIndex); 
dp.dimStyle(strDimStyle); // dimstyle was adjusted for display in paper space, sets textHeight
dpLTR.dimStyle(strDimStyle);

if(dTH>0)dpLTR.textHeight(dTH);

double dCH = dp.textHeightForStyle("OK",strDimStyle); // character height
double dCW =  dp.textLengthForStyle("OK",strDimStyle)/2; // character width

if (_bOnDebug) {
// draw the scriptname at insert point
dp.draw(scriptName() ,_Pt0,vXTbl,vYTbl,1,1);
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
double dVpScale=vp.dScale();
Element el = vp.element();
ElementWallSF elSF=(ElementWallSF)el;
//if(!elSF.bIsValid())return;
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
String arGrade[0]; // sortId
String arLabelList[0];//
int j;


//Label Display
Point3d arPtCenTxt[0];
double arDPos[0];
double arDNeg[0];
String arStrLab[0];
Vector3d arVLab[0];
int arBShouldMove[0];


int intPtDraw = 0;
String arLabel[0];
String arCN[0];
String arCNB[0];
String  arCP[0];
String  arCPB[0];
String  arMat[0];
String  arName[0];
String arCAP[0];
String arCAN[0];
// collect the items
// beams
Beam arBmAll[]=el.beam();
String arSizeUS[0];
int arBIsFill[0];

//__Sort beams prior to collecting
Beam bmS;
for (int b1=1; b1<arBmAll.length(); b1++) {

	int lb1 = b1;
	for (int b2 = b1-1; b2>=0; b2--) 
	{
		String s1 = 9, s2 = 9;
		if(arHsbId.find(arBmAll[lb1].hsbId()) > -1)s1 = arSortId[arHsbId.find(arBmAll[lb1].hsbId())];
		if(arHsbId.find(arBmAll[b2].hsbId()) > -1)s2 = arSortId[arHsbId.find(arBmAll[b2].hsbId())];
		
		if (s1<s2) {
			bmS = arBmAll[b2]; arBmAll[b2] = arBmAll[lb1];  arBmAll[lb1] = bmS;
	      	lb1=b2;
		}
	}
}




for (int i=0; i<arBmAll.length(); i++) {
	Beam bm=arBmAll[i];
	String stCode = bm.beamCode().token(0).makeUpper();
	if(stCode == "A" || stCode == "V"){
		if(bm.hsbId()=="4")bm.setHsbId("20000");
		if(vtpIgnor=="Yes"){
			arBmAll.removeAt(i);
			i--;
			continue;
		}
	}
	//if(bIgnorFlatBlocking && (bm.hsbId()=="412" || bm.hsbId()=="413" || bm.hsbId()=="12")){
		//arBmAll.removeAt(i);
		//i--;
		//continue;
	//}
	String strName=bm.name();strName.makeUpper();
	if(String("FURRING").spanIncluding(strName)=="FURRING")bm.setHsbId("2020");
	
	String strMat=bm.material();strMat.makeUpper();
	String strCheck=bm.name()+bm.material()+bm.grade();
	strCheck.makeUpper();
	String ssLvl=LVL;ssLvl.makeUpper();
	String ssLedg=Ledger;ssLedg.makeUpper();
	
	if(strCheck.find(ssLvl,0)>-1)bm.setHsbId("10001");
	if(strCheck.find(ssLedg,0)>-1)bm.setHsbId("10200");	
	if(strMat=="HANGER")bm.setMaterial("");
	
	
	
	
	//get the right name per piece
	String strNameIt;
	int bIsFill=0;
	double dSizes[]={bm.dW(),bm.dH()};
	
	if(dSizes[0]>dSizes[1])dSizes.swap(0,1);
	String strSize1;strSize1.formatUnit(dSizes[0]*dmm,strDimStyle);
	String strSize2;strSize2.formatUnit(dSizes[1]*dmm,strDimStyle);
	
	if(dSizes[0]<U(37.9)){
		strNameIt=strSize1+"x"+strSize2;
		bIsFill=1;
	}
	else if(bm.extrProfile() != "Rectangular")strNameIt=strSize1+"x"+strSize2;
	else if(strCheck.find("LVL",0)>-1)strNameIt=strSize1+"x"+strSize2+" LVL";
	else if(strCheck.find("LSL",0)>-1)strNameIt=strSize1+"x"+strSize2+" LSL";
	else if(strCheck.find("PSL",0)>-1)strNameIt=strSize1+"x"+strSize2+" PSL";
	else 
	{
		strNameIt=int(dSizes[0]+U(20))+"x"+int(dSizes[1]+U(20));
	
		if(stAddGradeToSize == arTranslateId[0])strNameIt += (" " + bm.grade());
	}

	arSizeUS.append(strNameIt);
	arBIsFill.append(bIsFill);
}


{
Beam arBeam[0]; 
arBeam  = arBmAll;
for (int i=0; i<arBeam.length(); i++) {
    // loop over list items
	int bNew = TRUE;
	Beam bm = arBeam[i];
	String stSizeUS = arSizeUS[i];

    for (int l=0; l<nNum; l++) {

      String strPos = String(bm.posnum());
	if (strPos=="-1") strPos = "";

      String strTim = bm.name("hsbId");
	String strMat=bm.material();
      if (strTranslateId==arTranslateId[0]) { // yes translate the id
        strTim = arCode[ arHsbId.find(strTim,0) ];
      }
	if(bm.extrProfile() != "Rectangular") strTim = bm.extrProfile();
	//if(strForceMat==arTranslateId[0] && strMat.length()>1 && bm.type()!=_kHeader)strTim = strMat;
	//add filler to the name
	//if(arBIsFill[i])strTim+=" Filler";
	
      String strLength; strLength.formatUnit(bm.solidLength()*dmm,strDimStyle);
      String strWidth; strWidth.formatUnit(bm.dW()*dmm,strDimStyle);
      String strHeight; strHeight.formatUnit(bm.dH()*dmm,strDimStyle);

	String sCutAngleP = bm.strCutP();
	String sCutAngleN = bm.strCutN();

      if ( (strHeight==arH[l])
           && (sCutAngleP==arCAP[l])
           && (sCutAngleN==arCAN[l])
           && (strLength==arL[l])
		&& ( strWidth==arW[l])
           && (String(strTim)==arM[l])
		&& stSizeUS == arName[l]
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
	String strMat=bm.material();
      if (strTranslateId==arTranslateId[0]) { // yes translate the id
        strTim = arCode[ arHsbId.find(strTim,0) ];
      }
	if(bm.extrProfile() != "Rectangular") strTim = bm.extrProfile();
	//if(strForceMat==arTranslateId[0] && strMat.length()>1 && bm.type()!=_kHeader)strTim = strMat;
	//add filler to the name
	//if(arBIsFill[i])strTim+=" Filler";

      j = nNum;

      String strLength; strLength.formatUnit(bm.solidLength()*dmm,strDimStyle);
      String strWidth; strWidth.formatUnit(bm.dW()*dmm,strDimStyle);
      String strHeight; strHeight.formatUnit(bm.dH()*dmm,strDimStyle);
      arCount.append(1);
      arW.append(strWidth);
      arL.append(strLength);
      arPos.append(strPos);
      arH.append(strHeight);
      arM.append(strTim);

	arGrade.append(bm.name("grade"));
	
	String strCN1=bm.strCutN().token(0,">");
	String strCN2=bm.strCutN().token(1,">");
	String strCP1=bm.strCutP().token(0,">");
	String strCP2=bm.strCutP().token(1,">");
	
	if(strCP1 == "0.00"){
		//if(strCP2 != "0.00") arCP.append(strCP2);
		//else 
		arCP.append(" ");
	}
	else arCP.append(strCP1);
	if(strCP2 == "0.00"){
		//if(strCP1 != "0.00") arCPB.append(strCP1);
		//else 
		arCPB.append(" ");
	}
	else arCPB.append(strCP2);
	
	if(strCN1 == "0.00"){
		//if(strCN2 != "0.00") arCN.append(strCN2);
		//else 
		arCN.append(" ");
	}
	else arCN.append(strCN1);
	if(strCN2 == "0.00"){
		//if(strCN1 != "0.00") arCNB.append(strCN1);
		//else 
		arCNB.append(" ");
	}
	else arCNB.append(strCN2);
	
	// arCN.append(bm.strCutN().token(1,">"));
	
	//if(bm.strCutN().token(0,">") == "0.00") arCNB.append(" ");
	//else arCNB.append(bm.strCutN().token(0,">"));
	
	//if(bm.strCutP().token(1,">") == "0.00") arCP.append(" ");
	//else arCP.append(bm.strCutP().token(1,">"));
	
	//if(bm.strCutP().token(0,">") == "0.00") arCPB.append(" ");
	//else arCPB.append(bm.strCutP().token(0,">"));
	
	arMat.append(bm.material());
	arName.append(arSizeUS[i]);
	arCAP.append(bm.strCutP());
	arCAN.append(bm.strCutN());
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

    arSL.append(dBmLength);

	String strSId = arSortId[ arCode.find(strTim,0) ] ;
	arS.append(arSortId[ arCode.find(strTim,0) ] );
	
	String strLabel;
	int iFirst = j / 25;
	int iLetter = j - 25 * iFirst;
	if(iFirst > 0)strLabel = strAlfabet.getAt(iFirst-1);
	strLabel += strAlfabet.getAt(iLetter);

      arLabelList.append(strLabel);
//arBeam[j].setLabel(strLabel);
  //   arLabelList.append(strAlfabet.getAt(j));
      nNum++;
    }
//get vectors


	if(bm.vecX().isParallelTo(el.vecZ()))arBShouldMove.append(1);
	else arBShouldMove.append(0);



	String strLabel;
	int iFirst = j / 25;
	int iLetter = j - 25 * iFirst;
	if(iFirst > 0)strLabel = strAlfabet.getAt(iFirst-1);
	strLabel += strAlfabet.getAt(iLetter);
 	arLabel.append(strLabel);
	
	bm.setLabel(strLabel);
	
	//New Label items
	arPtCenTxt.append(bm.ptCen());
	arDPos.append(bm.solidLength()/2); 
	arDNeg.append(bm.solidLength()/2); 
	arStrLab.append(strLabel);
	arVLab.append(bm.vecX());
	
  }
//arBeam[l].setLabel(arLabel);
}


// here is the time to sort
// bubble sort on posnum
int nD;
String sD;
for (int b1=1; b1<nNum; b1++) {
break;
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
	sD = arGrade[b2]; arGrade[b2] = arGrade[lb1];  arGrade[lb1] = sD;
	sD = arLabelList[b2]; arLabelList[b2] = arLabelList[lb1];  arLabelList[lb1] = sD;
	sD = arCN[b2]; arCN[b2] = arCN[lb1];  arCN[lb1] = sD;
	sD = arCNB[b2]; arCNB[b2] = arCNB[lb1];  arCNB[lb1] = sD;
	sD = arCP[b2]; arCP[b2] = arCP[lb1];  arCP[lb1] = sD;
	sD = arCPB[b2]; arCPB[b2] = arCPB[lb1];  arCPB[lb1] = sD;
	sD = arCAP[b2]; arCAP[b2] = arCAP[lb1];  arCAP[lb1] = sD;
	sD = arCAN[b2]; arCAN[b2] = arCAN[lb1];  arCAN[lb1] = sD;
	sD = arName[b2]; arName[b2] = arName[lb1];  arName[lb1] = sD; // Added by Ahilan
      lb1=b2;
    }
  }
}


// make lists to display
String arL0[] = {"HsbId"}; 
if (strTranslateId==arTranslateId[0]) { // yes translate the id
      arL0[0] = "Timber";}
String arL1[] = {"Size"};
String arL2[] = {"Lab."};
String arL3[] = {"Qty"};
String arL4[] = {"No"};
String arL5[] = {"Width"};
String arL6[] = {"Height"};
String arL7[] = {"Length"};
String arL9[] = {"Grade"};
String arL8[] = {"Mat"};

String arL10[] = {"Cut 1"};
String arL11[] = {"Bev. 1"};
String arL12[] = {"Cut 2"};
String arL13[] = {"Bev.2"};

int n1=0,n2=0,n3=0,n4=0,n5=0,n6=0,n7=0,n8=0,n9=0,n10=0,n11=0,n12=0,n13=0,n14=0;
if(d1>0)n1=1;
if(d2>0)n2=1;
if(d3>0)n3=1;
if(d4>0)n4=1;
if(d5>0)n5=1;
if(d6>0)n6=1;
if(d7>0)n7=1;
if(d8>0)n8=1;
if(d9>0)n9=1;
if(d10>0)n10=1;
if(d11>0)n11=1;
if(d12>0)n12=1;
if(d13>0)n13=1;
if(d14>0)n14=1;

for (int l=0; l<nNum; l++) {
	
/*
  int nD = arPos[l];
  if (nD<0)  arL0.append("");
  else if (nD<10) arL0.append("00" + String(nD));
  else if (nD<100) arL0.append("0" + String(nD));
  else arL0.append(String(nD));
*/
  arL0.append(arM[l]);
  arL1.append(arName[l]);
  arL2.append(arLabelList[l]);
  arL3.append(String(arCount[l]));
  arL4.append(arPos[l]);
  arL5.append(arW[l]);
  arL6.append(arH[l]);
  arL7.append(arL[l]);
  arL8.append(arGrade[l]);
  arL9.append(arMat[l]);
  arL11.append(arCN[l]);
  arL10.append(arCNB[l]);
  arL13.append(arCP[l]);
  arL12.append(arCPB[l]);


}
nNum++; // added the labels

// find out colomn widths
int nW0 = 0,nW1 = 0,nW2 = 0,nW3 = 0,nW4 = 0,nW5 = 0,nW6=0,nW7=0,nW8=0,nW9,nW10=0,nW11=0,nW12=0,nW13=0;
/*
for (int l=0; l<nNum; l++) {
  if (nW0<arL0[l].length()) nW0 = d1;//arL0[l].length();
  if (nW1<arL1[l].length()) nW1 = d2;//arL1[l].length();
  if (nW2<arL2[l].length()) nW2 = d3;//arL2[l].length();
  if (nW3<arL3[l].length()) nW3 = d4;//arL3[l].length();
  if (nW4<arL4[l].length()) nW4 = d5;//arL4[l].length();
  if (nW5<arL5[l].length()) nW5 = d6;//arL5[l].length();
  if (nW6<arL6[l].length()) nW6 = d7;// arL6[l].length();
  if (nW7<arL7[l].length()) nW7 = d8;//arL7[l].length();
  if (nW8<arL8[l].length()) nW8 = d9;
  if (nW9<arL9[l].length()) nW9 = d10;
  if (nW10<arL10[l].length()) nW10 = d11;
  if (nW11<arL11[l].length()) nW11 = d12;
  if (nW12<arL12[l].length()) nW12 = d13;
  if (nW13<arL13[l].length()) nW13 = d14;
}
*/
//for (int l=0; l<nNum; l++) {
  nW0 = d1;//arL0[l].length();
  nW1 = d2;//arL1[l].length();
  nW2 = d3;//arL2[l].length();
  nW3 = d4;//arL3[l].length();
  nW4 = d5;//arL4[l].length();
  nW5 = d6;//arL5[l].length();
  nW6 = d7;// arL6[l].length();
  nW7 = d8;//arL7[l].length();
  nW8 = d9;
  nW9 = d10;
  nW10 = d11;
  nW11 = d12;
  nW12 = d13;
  nW13 = d14;
//}
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
  }
  reportMessage("\n");
}

int nAdd = n1+n2+n3+n4+n5+n6+n7+n8+n9+n10+n11+n12+n13+n14;

// ------- Draw outher border -------------
// calculate the total border width and height

Point3d ptInsert=_Pt0;

int nWH = propHeader.length() + 2; // header width in number of characters
int nWC = (nW0 + nW1 + nW2 + nW3 + nW4 + nW5 + nW6 + nW7 + nW8 + nW9 + nW10 + nW11 + nW12 + nW13 +nAdd); // coloms width in number of characters
int nWT = (nWH<nWC)?nWC:nWH; // total table width
double dWT = nWT*dCW;

int nMax=nMaxRow;
int nGoDisplay=1;
if(arL0.length()>nMax)nGoDisplay=arL0.length()/nMax+1;
else nMax=arL0.length();

int nIndexItem=0;

double dHT = 2*(nMax)*dCH + 3*dCH; // 4 is the height of the headernNum
if(strJustify==arJustify[1]) ptInsert=_Pt0+dHT*vYTbl;

//reportMessage("\nLength "+ arL0.length());

for(int d=0;d<nGoDisplay;d++){
		
	Point3d ptLL = ptInsert - dHT*vYTbl;
	Point3d ptUR = ptInsert + dWT*vXTbl;
	Point3d ptLR = ptUR - dHT*vYTbl;
	Point3d ptUL = ptInsert;
	PLine plBorder(ptLL,ptLR,ptUR,ptUL);
	plBorder.addVertex(ptLL);
	dp.draw(plBorder);
	
	// ------- Draw header -------------
	Point3d ptL0 = ptUL; // start from upper left
	Point3d pt = ptL0 + dCW*vXTbl - dCH*vYTbl; 	
	pt.vis(); 
	dp.color(nColorIndex);
	dp.draw(propHeader,pt,vXTbl,vYTbl,1,-1);
	dp.color(nColorIndex);
	Point3d ptHL = ptL0 - 3*dCH*vYTbl;
	PLine plHeaderLine(ptHL, ptHL + dWT*vXTbl ); 
	dp.draw(plHeaderLine);
	
	// ------- Draw inner vertical lines -------------
	// calculate the total border width and height
	Point3d ptT = ptHL;
	Point3d ptB = ptLL;
	PLine plLineV(ptT,ptB);
	Vector3d vecMove(0,0,0);
	vecMove = n1*dCW*vXTbl + nW0*dCW*vXTbl; plLineV.transformBy(vecMove); dp.draw(plLineV);
	vecMove = n2*dCW*vXTbl + nW1*dCW*vXTbl; plLineV.transformBy(vecMove); dp.draw(plLineV);
	vecMove = n3*dCW*vXTbl + nW2*dCW*vXTbl; plLineV.transformBy(vecMove); dp.draw(plLineV);
	vecMove = n4*dCW*vXTbl + nW3*dCW*vXTbl; plLineV.transformBy(vecMove); dp.draw(plLineV);
	vecMove = n5*dCW*vXTbl + nW4*dCW*vXTbl; plLineV.transformBy(vecMove); dp.draw(plLineV);
	vecMove = n6*dCW*vXTbl + nW5*dCW*vXTbl; plLineV.transformBy(vecMove); dp.draw(plLineV);
	vecMove = n7*dCW*vXTbl + nW6*dCW*vXTbl; plLineV.transformBy(vecMove); dp.draw(plLineV);
	vecMove = n8*dCW*vXTbl + nW7*dCW*vXTbl; plLineV.transformBy(vecMove); dp.draw(plLineV);
	vecMove = n9*dCW*vXTbl + nW8*dCW*vXTbl; plLineV.transformBy(vecMove); dp.draw(plLineV);
	vecMove = n10*dCW*vXTbl + nW9*dCW*vXTbl; plLineV.transformBy(vecMove); dp.draw(plLineV);
	vecMove = n11*dCW*vXTbl + nW10*dCW*vXTbl; plLineV.transformBy(vecMove); dp.draw(plLineV);
	vecMove = n12*dCW*vXTbl + nW11*dCW*vXTbl; plLineV.transformBy(vecMove); dp.draw(plLineV);
	vecMove = n13*dCW*vXTbl + nW12*dCW*vXTbl; plLineV.transformBy(vecMove); dp.draw(plLineV);
	//vecMove = 1*dCW*vXTbl + nW13*dCW*vXTbl; plLineV.transformBy(vecMove); dp.draw(plLineV);
	
	
	// ------- Draw text -------------
	ptL0 = ptUL - 1.5*dCH*vYTbl; // start from upper left, subtract header
	Point3d ptL = ptL0;//- 2*dCH*nIndexItem*vYTbl;;//ptL = ptL0 - 2*dCH*nIndexItem*vYTbl;
	// pt = ptL;
	for (int l=0; l<nNum && l<nMax; l++) { // loop over each line.
		//if(nIndexItem>nNum)break;
	 	 if (nIndexItem==0) dp.color(nColorIndex);
		  else dp.color(nColorIndex);
		
		  ptL.transformBy(-2*dCH*vYTbl);
		pt=ptL;
		  /* 
		  // right alignment
		  pt = pt + 1*dCW*vXTbl + nW0*dCW*vXTbl; 	pt.vis(); dp.draw(arL0[l],pt,vXTbl,vYTbl,-1,-1);
		  pt = pt + 2*dCW*vXTbl + nW1*dCW*vXTbl; 	pt.vis(); dp.draw(arL1[l],pt,vXTbl,vYTbl,-1,-1);
		  pt = pt + 2*dCW*vXTbl + nW2*dCW*vXTbl; 	pt.vis(); dp.draw(arL2[l],pt,vXTbl,vYTbl,-1,-1);
		  pt = pt + 2*dCW*vXTbl + nW3*dCW*vXTbl; 	pt.vis(); dp.draw(arL3[l],pt,vXTbl,vYTbl,-1,-1);
		  pt = pt + 2*dCW*vXTbl + nW4*dCW*vXTbl; 	pt.vis(); dp.draw(arL4[l],pt,vXTbl,vYTbl,-1,-1); 
		  pt = pt + 2*dCW*vXTbl + nW5*dCW*vXTbl; 	pt.vis(); dp.draw(arL5[l],pt,vXTbl,vYTbl,-1,-1); 
		  */
		
		  // horizontal line.
		  if (l!=0) {
		    Point3d ptLn = ptL + 0.4*dCH*vYTbl;
		    PLine plLineH(ptLn, ptLn + dWT*vXTbl ); 
		    dp.draw(plLineH);
		  }
		
		  // left alignment
		  pt = pt + n1*dCW*vXTbl ;if(n1==1)dp.draw(arL0[nIndexItem],pt,vXTbl,vYTbl,1,-1);
		  pt = pt + n2*dCW*vXTbl + nW0*dCW*vXTbl; if(n2==1)	 dp.draw(arL1[nIndexItem],pt,vXTbl,vYTbl,1,-1); // right
		  pt = pt + n3*dCW*vXTbl + nW1*dCW*vXTbl; if(n3==1)	  	dp.draw(arL2[nIndexItem],pt,vXTbl,vYTbl,1,-1); // left
		  pt = pt + n4*dCW*vXTbl + nW2*dCW*vXTbl; if(n4==1)	 	dp.draw(arL3[nIndexItem],pt,vXTbl,vYTbl,1,-1);
		  pt = pt + n5*dCW*vXTbl + nW3*dCW*vXTbl; if(n5==1)	 	dp.draw(arL4[nIndexItem],pt,vXTbl,vYTbl,1,-1);
		  pt = pt + n6*dCW*vXTbl + nW4*dCW*vXTbl; if(n6==1)	 	dp.draw(arL5[nIndexItem],pt,vXTbl,vYTbl,1,-1);
		  pt = pt + n7*dCW*vXTbl + nW5*dCW*vXTbl; if(n7==1)	 	dp.draw(arL6[nIndexItem],pt,vXTbl,vYTbl,1,-1); 
		  pt = pt + n8*dCW*vXTbl + nW6*dCW*vXTbl; if(n8==1)	 	dp.draw(arL7[nIndexItem],pt,vXTbl,vYTbl,1,-1); 
		  pt = pt + n9*dCW*vXTbl + nW7*dCW*vXTbl; if(n9==1)	 	dp.draw(arL8[nIndexItem],pt,vXTbl,vYTbl,1,-1); 
		  pt = pt + n10*dCW*vXTbl + nW8*dCW*vXTbl; if(n10==1)	 	dp.draw(arL9[nIndexItem],pt,vXTbl,vYTbl,1,-1); 
		  pt = pt + n11*dCW*vXTbl + nW9*dCW*vXTbl; if(n11==1)	 	dp.draw(arL10[nIndexItem],pt,vXTbl,vYTbl,1,-1);
		  pt = pt + n12*dCW*vXTbl + nW10*dCW*vXTbl; if(n12==1)	 	dp.draw(arL11[nIndexItem],pt,vXTbl,vYTbl,1,-1); 
		  pt = pt + n13*dCW*vXTbl + nW11*dCW*vXTbl; if(n13==1)	  	dp.draw(arL12[nIndexItem],pt,vXTbl,vYTbl,1,-1); 
		  pt = pt + n14*dCW*vXTbl + nW12*dCW*vXTbl; if(n14==1)	 	dp.draw(arL13[nIndexItem],pt,vXTbl,vYTbl,1,-1); 
		 // pt = pt + 1*dCW*vXTbl + nW13*dCW*vXTbl; 	//dp.draw(arL13[nIndexItem],pt,vXTbl,vYTbl,1,-1);
		
		nIndexItem++;
	}
	
	ptInsert.transformBy(dWT*vXTbl);
	pt = ptL0 + dCW*vXTbl - dCH*vYTbl; 
	arL0.insertAt(nIndexItem,"Timber");
	arL1.insertAt(nIndexItem,"Size");
	arL2.insertAt(nIndexItem,"Label");
	arL3.insertAt(nIndexItem,"Qty");
	arL4.insertAt(nIndexItem,"No");
	arL5.insertAt(nIndexItem,"Width");
	arL6.insertAt(nIndexItem,"Height");
	arL7.insertAt(nIndexItem,"Length");
	arL9.insertAt(nIndexItem,"Grade");
	arL8.insertAt(nIndexItem,"Mat");
	arL10.insertAt(nIndexItem,"Cut 1");
	arL11.insertAt(nIndexItem,"Bev. 1");
	arL12.insertAt(nIndexItem,"Cut 2");
	arL13.insertAt(nIndexItem,"Bev.2");
	//reportMessage("\nInserted At " + nIndexItem);
	
	int nLeft=arL0.length()-nIndexItem;//reportMessage("\nnLeft ?? "+ nLeft); 
	if(nLeft<nMax)nMax=nLeft;
	dHT = 2*(nMax)*dCH + 3*dCH;

}








//Draw Labels in the VP

double dMoveOption=intText*U(150);

int safety=0;
double dSizeClear=dCH/dVpScale*.75;//U(200);
double dMoveIncrements=dMoveOption;
int bDonePosNeg=0;//1=pos and 2= neg


arPtCenTxt=Plane(el.ptOrg(),el.vecZ()).projectPoints(arPtCenTxt);
Body bdAll;

//Add hanger dime point to this
Map mpPointsHanger=el.subMap("HangerDimPointsMap");
if(mpPointsHanger.hasPoint3dArray("HangerDimPoints")){
	Point3d arPtHg[]=mpPointsHanger.getPoint3dArray("HangerDimPoints");
	for (int i=0; i<arPtCenTxt.length(); i++) {
		Body bd(arPtCenTxt[i]+el.vecZ()*U(400),arPtCenTxt[i],dSizeClear);
		bdAll+=bd;
	}
}

Point3d arPtNew[0];
String arStrNew[0];	
LineSeg arLnSegNew[0];

for (int i=0; i<arPtCenTxt.length(); i++) {
	Point3d pt1=arPtCenTxt[i],ptOrigine=arPtCenTxt[i];
	
	double dP1=arDPos[i];
	double dN1=arDNeg[i];
	String txt1=arStrLab[i];
	Vector3d vMove=arVLab[i];
	Vector3d vOff=el.vecZ().crossProduct(vMove);
	vOff.normalize();
	Line ln(pt1,vMove);
	Body bd1(pt1+el.vecZ()*U(400),pt1,dSizeClear);
	int bHasLn=0;
	
	int nFixed=1;
	if(bd1.hasIntersection(bdAll) || arBShouldMove[i]){
		nFixed=0;
		
		//first see if one close to this one is the same
		if(arStrNew.find(txt1)>-1){
			for (int s=arStrNew.find(txt1); s<arStrNew.length(); s++) {
				Vector3d vTest(arPtNew[s]-pt1);
				if(txt1==arStrNew[s] && vTest.length() <= U(300)){
					pt1=arPtNew[s];
					bHasLn=1;
					nFixed=1;
					LineSeg ls=arLnSegNew[s];
					ls.transformBy(ms2ps);
					dp.draw(ls);
					break;
				}
			}
		}
		
		
		int nGo=(dP1/dMoveIncrements)+0;
		for (int p=1; p<nGo+1; p++) {
			if(nFixed==1)break;
			Point3d pt2=pt1+vMove*dMoveIncrements*p;
			Body bd2(pt2+el.vecZ()*U(400),pt2,dSizeClear);
			
			if(!bd2.hasIntersection(bdAll)){
				bd1=bd2;
				pt1=pt2;
				nFixed=1;
				break;
			}
			Point3d pt3=pt1-vMove*dMoveIncrements*p;
			Body bd3(pt3+el.vecZ()*U(400),pt3,dSizeClear);
			
			if(!bd3.hasIntersection(bdAll)){
				bd1=bd3;
				pt1=pt3;
				nFixed=1;
				break;
			}
		}
		if(!nFixed){
			for(int f=1; f<3; f++) {
				for (int p=1; p<nGo+1; p++) {
					Point3d pt2=pt1+vMove*dMoveIncrements*p+vOff*dMoveIncrements*f;
					Body bd2(pt2+el.vecZ()*U(400),pt2,dSizeClear);
					
					if(!bd2.hasIntersection(bdAll)){
						bd1=bd2;
						pt1=pt2;
						nFixed=1;
						bHasLn=1;
						break;
					}
					Point3d pt3=pt1-vMove*dMoveIncrements*p+vOff*dMoveIncrements*f;
					Body bd3(pt3+el.vecZ()*U(400),pt3,dSizeClear);
					
					if(!bd3.hasIntersection(bdAll)){
						bd1=bd3;
						pt1=pt3;
						nFixed=1;
						bHasLn=1;
						break;
					}
					Point3d pt4=pt1+vMove*dMoveIncrements*p-vOff*dMoveIncrements*f;
					Body bd4(pt4+el.vecZ()*U(400),pt4,dSizeClear);
					
					if(!bd4.hasIntersection(bdAll)){
						bd1=bd4;
						pt1=pt4;
						nFixed=1;
						bHasLn=1;
						break;
					}
					Point3d pt5=pt1-vMove*dMoveIncrements*p-vOff*dMoveIncrements*f;
					Body bd5(pt5+el.vecZ()*U(400),pt5,dSizeClear);
					
					if(!bd5.hasIntersection(bdAll)){
						bd1=bd5;
						pt1=pt5;
						nFixed=1;
						bHasLn=1;
						break;
					}
				}
				if(nFixed==1)break;
			}
		}
		if(arBShouldMove[i])bHasLn=1;
	}
	
	//if(nFixed==0)reportMessage("\nLabel " + txt1 + " was not fixed");
	
	bdAll+=bd1;
	
	arPtNew.append(pt1);
	arStrNew.append(txt1);
	
	arPtCenTxt[i]=pt1;
	pt1.transformBy(ms2ps);
	dpLTR.draw(txt1,pt1,_XW,_YW,0,0   );	
	
	Point3d ptBm[]={ln.closestPointTo(arPtCenTxt[i])-vMove*U(150),ln.closestPointTo(arPtCenTxt[i])+vMove*U(150)};
	if(Vector3d(ptBm[0]-ptOrigine).length() > Vector3d(ptBm[1]-ptOrigine).length() )ptBm.swap(0,1);
		
	Vector3d vLn(ptBm[0]-arPtCenTxt[i]);vLn.normalize();
	LineSeg ls(ptBm[0],arPtCenTxt[i]+vLn*1*dSizeClear);
	arLnSegNew.append(ls);
	ls.transformBy(ms2ps);
	
	if(bHasLn)dp.draw(ls);
}














// Automatic recorded v1.1











































#End
#BeginThumbnail














































#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="0.03937008" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Will infinit amount of labels" />
      <int nm="MAJORVERSION" vl="4" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="12/14/2022 1:37:19 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End