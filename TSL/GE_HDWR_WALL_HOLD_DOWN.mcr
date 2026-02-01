#Version 8
#BeginDescription
V3.21__01/07/21__Will set hardware group
V3.20__01/Jul/2020__LSTHD8, STHD10, STHD14 types now aligned to the edge of stud + small fastener text changes + not passing property <Drill Plates> value to GE_HDWR_WALL_ANCHOR anymore, it will read from instance that creates it
V3.19__19/Jun/2020__Added DTT2Z SDS2.5, HD12 and HD19 + different quantities and types for full installed and tacked fasteners + some new fastener types + added <Drill Plates> (no/yes) prop. + Changed default rod to 1" All thread for all HDU types + removed some types by demand or duplicated
V3.18__10/1/2019__Added fasteners and install options
//V3.17__05_Sept_2019__Will display warning if holddown is placed less then 10.5inch stud bay
V3.16__Jan_03_2019__Added Modelmap support
V3.15__05June2018__ Assigns holdowns connectors to subgroups under X-hardware
V3.14__15March2018__Give the user a chance to relink to stud pack if deleted.
V3.13__19Dec2018__Corrected PT0 again
V3.12__13Nov 2017__Changed _Pt0 to the base of the hardware
V3.11__01Nov 2017__Adds DXA dispaly to bogus
V3.10__25 Oct 2017__Adds display for PC
V3.9__26Sept2017__Bugfix offset properties
V3.8__15Sept2017__Sends to display rep called HoldDown
V3.7__14Sept2017__Will not try to set location automatically
V3.6__13Sept2017__Will insert the anchor
V3.5__12Sept2017__Added the exta doubles for new hold downs
V3.4__12Sept2017__Bugfix for update
V3.3__08Sept2017__State stored in dwg
V3.2__28June2017__Added lateral Offset
V3.1__30March 2017__Added vertical offset
V3.0__March 28 ad-ded embeded straps
V2.9__Sept 26 2016__Can now be at the top of the wall
V2.8__August 3 201-6__Only goes to the wall layer if wall is valid
V2.7__August 2 2016__Should be exported
V2.6__June 21 2016__Added hardware comp to be exported
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 3
#MinorVersion 21
#KeyWords 
#BeginContents
int bDebug=_bOnDebug;
// read a potential mapObject defined by hsbDebugController
{ 
	MapObject mo("hsbTSLDev" ,"hsbTSLDebugController");
	if (mo.bIsValid()){Map m = mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug = true;	break;}}
	if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());		
}

U(1,"inch");
int iState = 0;
if (_Map.hasInt("State"))
{
	iState = _Map.getInt("State");
}

String arStrYN[] = {T("|Yes|"),T("|No|")}; // keep Yes as first array argument

String arConnDescript[0];
String arConnectors[0];
double arDx[0];
double arDz[0];
double arDy[0];
double arDRod[0];
double arDDrillCL[0];
int arIShape[0];

//just extra values based on shape
double dExtra1[0];
double dExtra2[0];

double dThick=U(0.125);
String arNewDescription[0], arTranslation[0];
String arFastenerType[] =
{
	"0.148 x 1 1/2\"",
	"0.250 x 2 1/2\" SDS",
	"0.250 x 1 1/2\" SDS",
	"0.162 x 2 1/2\"",
	"0.148 x 3\"",
	"0.148 x 3 1/4\"",
	"0.131 x 3\"",
	"0.250 x 3\" SDS",
	"#10 x 2 1/2\" SD",
	"WS15-EXT",
	"1.0 x X\"Bolt"
};
int iFastenerQtyFull[0], iFastenerQtyTacked[0], iFastenerTypeFull[0], iFastenerTypeTacked[0];

arConnDescript.append("HTT4 SIMPSON"); iFastenerTypeFull.append(0); iFastenerTypeTacked.append(0); iFastenerQtyFull.append(18); iFastenerQtyTacked.append(2);   arNewDescription.append("HTT4 SIMPSON"); arTranslation.append("HTT4 SIMPSON"); arConnectors.append("HTT4"); arDx.append(U(2.625)); arDz.append(U(2.5)); arDy.append(U(12.375)); arDRod.append(U(0.625));arDDrillCL.append(U(1.3125));arIShape.append(1); dExtra1.append(U(0)); dExtra2.append(U(0));
arConnDescript.append("HTT4 NAIL SIMPSON"); iFastenerTypeFull.append(0); iFastenerTypeTacked.append(0); iFastenerQtyFull.append(18); iFastenerQtyTacked.append(2);  arTranslation.append("HTT4 SIMPSON");
arConnDescript.append("HTT4 SDS SIMPSON");iFastenerTypeFull.append(3); iFastenerTypeTacked.append(3); iFastenerQtyFull.append(18); iFastenerQtyTacked.append(2);  arTranslation.append("HTT4 SIMPSON");

arConnDescript.append("HTT5 SIMPSON"); iFastenerTypeFull.append(0); iFastenerTypeTacked.append(0); iFastenerQtyFull.append(26); iFastenerQtyTacked.append(2);  arNewDescription.append("HTT5 SIMPSON"); arTranslation.append("HTT5 SIMPSON"); arConnectors.append("HTT5"); arDx.append(U(2)); arDz.append(U(2.5)); arDy.append(U(16)); arDRod.append(U(0.625));arDDrillCL.append(U(1.3125));arIShape.append(0); dExtra1.append(U(0)); dExtra2.append(U(0));
arConnDescript.append("HTT5 NAIL SIMPSON"); iFastenerTypeFull.append(0); iFastenerTypeTacked.append(0); iFastenerQtyFull.append(26); iFastenerQtyTacked.append(2);  arTranslation.append("HTT5 SIMPSON");
arConnDescript.append("HTT5 SDS SIMPSON"); iFastenerTypeFull.append(3); iFastenerTypeTacked.append(3); iFastenerQtyFull.append(26); iFastenerQtyTacked.append(2);   arTranslation.append("HTT5 SIMPSON");


arConnDescript.append("HTT5KT SIMPSON"); iFastenerTypeFull.append(8); iFastenerTypeTacked.append(8); iFastenerQtyFull.append(26); iFastenerQtyTacked.append(2);  arNewDescription.append("HTT5KT SIMPSON"); arTranslation.append("HTT5KT SIMPSON"); arConnectors.append("HTT5KT"); arDx.append(U(2)); arDz.append(U(2.5)); arDy.append(U(16)); arDRod.append(U(0.625));arDDrillCL.append(U(1.3125));arIShape.append(0); dExtra1.append(U(0)); dExtra2.append(U(0));

arConnDescript.append("LTT19 SIMPSON"); iFastenerTypeFull.append(0); iFastenerTypeTacked.append(0); iFastenerQtyFull.append(8); iFastenerQtyTacked.append(2);  arNewDescription.append("LTT19 SIMPSON"); arTranslation.append("LTT19 SIMPSON"); arConnectors.append("LTT19"); arDx.append(U(3.125)); arDz.append(U(1.75)); arDy.append(U(19.125)); arDRod.append(U(0.625));arDDrillCL.append(U(1.375));arIShape.append(4); dExtra1.append(U(0)); dExtra2.append(U(0));
arConnDescript.append("LTT20B SIMPSON"); iFastenerTypeFull.append(0); iFastenerTypeTacked.append(0); iFastenerQtyFull.append(10); iFastenerQtyTacked.append(2);  arNewDescription.append("LTT20B SIMPSON"); arTranslation.append("LTT20B SIMPSON"); arConnectors.append("LTT20B"); arDx.append(U(3.125)); arDz.append(U(2)); arDy.append(U(19.75)); arDRod.append(U(0.625));arDDrillCL.append(U(1.5));arIShape.append(4); dExtra1.append(U(0)); dExtra2.append(U(0));
//arConnDescript.append("LTT20B NAIL SIMPSON"); iFastenerTypeFull.append(0); iFastenerTypeTacked.append(0); iFastenerQtyFull.append(10); iFastenerQtyTacked.append(-1);  arNewDescription.append("LTT20B SIMPSON"); arTranslation.append("LTT20B SIMPSON"); arConnectors.append("LTT20B NAIL"); arDx.append(U(3)); arDz.append(U(2)); arDy.append(U(19.75)); arDRod.append(U(0.625));arDDrillCL.append(U(1.5));arIShape.append(4);dExtra1.append(U(0)); dExtra2.append(U(0));
arConnDescript.append("LTT20B SDS SIMPSON"); iFastenerTypeFull.append(2); iFastenerTypeTacked.append(2); iFastenerQtyFull.append(10); iFastenerQtyTacked.append(2);  arTranslation.append("LTT20B SIMPSON");
arConnDescript.append("LTTI31 SIMPSON"); iFastenerTypeFull.append(0); iFastenerTypeTacked.append(0); iFastenerQtyFull.append(18); iFastenerQtyTacked.append(2);  arNewDescription.append("LTTI31 SIMPSON"); arTranslation.append("LTTI31 SIMPSON"); arConnectors.append("LTTI31"); arDx.append(U(2.75)); arDz.append(U(3.75)); arDy.append(U(31)); arDRod.append(U(0.625));arDDrillCL.append(U(1.375));arIShape.append(4); dExtra1.append(U(0)); dExtra2.append(U(0));

arConnDescript.append("HDQ8-SDS3 SIMPSON"); iFastenerTypeFull.append(7); iFastenerTypeTacked.append(2); iFastenerQtyFull.append(20); iFastenerQtyTacked.append(2);  arNewDescription.append("HDQ8-SDS3 SIMPSON"); arTranslation.append("HDQ8-SDS3 SIMPSON"); arConnectors.append("HDQ8-SDS3"); arDx.append(U(2.5)); arDz.append(U(2.875)); arDy.append(U(14)); arDRod.append(U(0.875));arDDrillCL.append(U(.875));arIShape.append(2); dExtra1.append(U(0)); dExtra2.append(U(0));
arConnDescript.append("HHDQ11-SDS2.5 SIMPSON"); iFastenerTypeFull.append(1); iFastenerTypeTacked.append(2); iFastenerQtyFull.append(24); iFastenerQtyTacked.append(2);  arNewDescription.append("HHDQ11-SDS2.5 SIMPSON"); arTranslation.append("HHDQ11-SDS2.5 SIMPSON"); arConnectors.append("HHDQ11-SDS2.5"); arDx.append(U(3.5)); arDz.append(U(3)); arDy.append(U(15.125)); arDRod.append(U(0.875));arDDrillCL.append(U(1));arIShape.append(2); dExtra1.append(U(0)); dExtra2.append(U(0));
arConnDescript.append("HHDQ14-SDS2.5 SIMPSON"); iFastenerTypeFull.append(1); iFastenerTypeTacked.append(2); iFastenerQtyFull.append(30); iFastenerQtyTacked.append(2);  arNewDescription.append("HHDQ14-SDS2.5 SIMPSON"); arTranslation.append("HHDQ14-SDS2.5 SIMPSON"); arConnectors.append("HHDQ14-SDS2.5"); arDx.append(U(3.5)); arDz.append(U(3)); arDy.append(U(18.75)); arDRod.append(U(0.875));arDDrillCL.append(U(1));arIShape.append(2); dExtra1.append(U(0)); dExtra2.append(U(0));

arConnDescript.append("DTT1Z SIMPSON"); iFastenerTypeFull.append(0); iFastenerTypeTacked.append(0); iFastenerQtyFull.append(6); iFastenerQtyTacked.append(2);  arNewDescription.append("DTT1Z SIMPSON"); arTranslation.append("DTT1Z SIMPSON"); arConnectors.append("DTT1Z"); arDx.append(U(1.4375)); arDz.append(U(1.5)); arDy.append(U(7.125)); arDRod.append(U(0.5));arDDrillCL.append(U(0.75));arIShape.append(4); dExtra1.append(U(0)); dExtra2.append(U(0));
arConnDescript.append("DTT2Z SIMPSON"); iFastenerTypeFull.append(2); iFastenerTypeTacked.append(2); iFastenerQtyFull.append(8); iFastenerQtyTacked.append(2);  arNewDescription.append("DTT2Z SIMPSON"); arTranslation.append("DTT2Z SIMPSON"); arConnectors.append("DTT2Z"); arDx.append(U(1.625)); arDz.append(U(3.25)); arDy.append(U(6.9375)); arDRod.append(U(0.5));arDDrillCL.append(U(0.8125));arIShape.append(3); dExtra1.append(U(0)); dExtra2.append(U(0));
arConnDescript.append("DTT2Z-SDS2.5 SIMPSON"); iFastenerTypeFull.append(1); iFastenerTypeTacked.append(2); iFastenerQtyFull.append(8); iFastenerQtyTacked.append(2);  arNewDescription.append("DTT2Z-SDS2.5 SIMPSON"); arTranslation.append("DTT2Z-SDS2.5 SIMPSON"); arConnectors.append("DTT2Z-SDS2.5"); arDx.append(U(1.625)); arDz.append(U(3.25)); arDy.append(U(6.9375)); arDRod.append(U(0.5));arDDrillCL.append(U(0.8125));arIShape.append(3); dExtra1.append(U(0)); dExtra2.append(U(0));
arConnDescript.append("DTT2Z NAIL SIMPSON"); iFastenerTypeFull.append(0); iFastenerTypeTacked.append(0); iFastenerQtyFull.append(8); iFastenerQtyTacked.append(2);  arTranslation.append("DTT2Z SIMPSON");
arConnDescript.append("DTT2Z SDS SIMPSON");  iFastenerTypeFull.append(1); iFastenerTypeTacked.append(1);  iFastenerQtyFull.append(8); iFastenerQtyTacked.append(2);  arTranslation.append("DTT2Z SIMPSON");

arConnDescript.append("HDU2-SDS2.5 SIMPSON"); iFastenerTypeFull.append(1); iFastenerTypeTacked.append(2);  iFastenerQtyFull.append(6); iFastenerQtyTacked.append(2);   arNewDescription.append("HDU2-SDS2.5 SIMPSON"); arTranslation.append("HDU2-SDS2.5 SIMPSON");  arConnectors.append("HDU2-SDS2.5"); arDx.append(U(3.25)); arDz.append(U(3)); arDy.append(U(8.6875)); arDRod.append(U(1));arDDrillCL.append(U(1.375));arIShape.append(0); dExtra1.append(U(0)); dExtra2.append(U(0));
arConnDescript.append("HDU4-SDS2.5 SIMPSON"); iFastenerTypeFull.append(1); iFastenerTypeTacked.append(2); iFastenerQtyFull.append(10); iFastenerQtyTacked.append(2);  arNewDescription.append("HDU4-SDS2.5 SIMPSON"); arTranslation.append("HDU4-SDS2.5 SIMPSON"); arConnectors.append("HDU4-SDS2.5"); arDx.append(U(3.25)); arDz.append(U(3)); arDy.append(U(10.9375)); arDRod.append(U(1));arDDrillCL.append(U(1.375));arIShape.append(0); dExtra1.append(U(0)); dExtra2.append(U(0));
arConnDescript.append("HDU5-SDS2.5 SIMPSON"); iFastenerTypeFull.append(1); iFastenerTypeTacked.append(2); iFastenerQtyFull.append(14); iFastenerQtyTacked.append(2);  arNewDescription.append("HDU5-SDS2.5 SIMPSON"); arTranslation.append("HDU5-SDS2.5 SIMPSON"); arConnectors.append("HDU5-SDS2.5"); arDx.append(U(3.25)); arDz.append(U(3)); arDy.append(U(13.1875)); arDRod.append(U(1));arDDrillCL.append(U(1.375));arIShape.append(0); dExtra1.append(U(0)); dExtra2.append(U(0));
arConnDescript.append("HDU8-SDS2.5 SIMPSON"); iFastenerTypeFull.append(1); iFastenerTypeTacked.append(2);  iFastenerQtyFull.append(20); iFastenerQtyTacked.append(2);  arNewDescription.append("HDU8-SDS2.5 SIMPSON"); arTranslation.append("HDU8-SDS2.5 SIMPSON"); arConnectors.append("HDU8-SDS2.5"); arDx.append(U(3.5)); arDz.append(U(3)); arDy.append(U(16.625)); arDRod.append(U(1));arDDrillCL.append(U(1.375));arIShape.append(0); dExtra1.append(U(0)); dExtra2.append(U(0));
arConnDescript.append("HDU11-SDS2.5 SIMPSON"); iFastenerTypeFull.append(1); iFastenerTypeTacked.append(2);  iFastenerQtyFull.append(30); iFastenerQtyTacked.append(2);  arNewDescription.append("HDU11-SDS2.5 SIMPSON"); arTranslation.append("HDU11-SDS2.5 SIMPSON"); arConnectors.append("HDU11-SDS2.5"); arDx.append(U(3.5)); arDz.append(U(3)); arDy.append(U(22.25)); arDRod.append(U(1));arDDrillCL.append(U(1.375));arIShape.append(0); dExtra1.append(U(0)); dExtra2.append(U(0));
arConnDescript.append("HDU14-SDS2.5 SIMPSON"); iFastenerTypeFull.append(1); iFastenerTypeTacked.append(2);  iFastenerQtyFull.append(36); iFastenerQtyTacked.append(2);  arNewDescription.append("HDU14-SDS2.5 SIMPSON"); arTranslation.append("HDU14-SDS2.5 SIMPSON"); arConnectors.append("HDU14-SDS2.5"); arDx.append(U(3.5)); arDz.append(U(3)); arDy.append(U(25.6875)); arDRod.append(U(1));arDDrillCL.append(U(1.5625));arIShape.append(0); dExtra1.append(U(0)); dExtra2.append(U(0));

arConnDescript.append("DTB-TZ USP"); iFastenerTypeFull.append(9); iFastenerTypeTacked.append(9); iFastenerQtyFull.append(8); iFastenerQtyTacked.append(2); arNewDescription.append("DTB-TZ USP"); arTranslation.append("DTB-TZ USP"); arConnectors.append("USP DTB-TZ"); arDx.append(U(2.25)); arDz.append(U(1.8125)); arDy.append(U(6)); arDRod.append(U(0.5));arDDrillCL.append(U(1.125));arIShape.append(2); dExtra1.append(U(0)); dExtra2.append(U(0));

//arConnDescript.append("HTT4 USP"); iFastenerTypeFull.append(0); iFastenerTypeTacked.append(0); iFastenerQtyFull.append(18); iFastenerQtyTacked.append(-1); arNewDescription.append("HTT4 USP"); arTranslation.append("HTT4 USP"); arConnectors.append("USP HTT4"); arDx.append(U(2.75)); arDz.append(U(3)); arDy.append(U(10.4375)); arDRod.append(U(0.625));arDDrillCL.append(U(1.375));arIShape.append(0); dExtra1.append(U(0)); dExtra2.append(U(0));
//arConnDescript.append("HTT5 USP"); iFastenerTypeFull.append(0); iFastenerTypeTacked.append(0); iFastenerQtyFull.append(26); iFastenerQtyTacked.append(-1); arNewDescription.append("HTT5 USP"); arTranslation.append("HTT5 USP"); arConnectors.append("USP HTT5"); arDx.append(U(2.75)); arDz.append(U(3)); arDy.append(U(13.9375)); arDRod.append(U(0.625));arDDrillCL.append(U(1.375));arIShape.append(0); dExtra1.append(U(0)); dExtra2.append(U(0));
//arConnDescript.append("HTT5KT USP"); iFastenerTypeFull.append(3); iFastenerTypeTacked.append(3); iFastenerQtyFull.append(26); iFastenerQtyTacked.append(-1); arNewDescription.append("HTT5KT USP"); arTranslation.append("HTT5KT USP"); arConnectors.append("USP HTT5KT"); arDx.append(U(2.75)); arDz.append(U(3)); arDy.append(U(13.9375)); arDRod.append(U(0.625));arDDrillCL.append(U(1.375));arIShape.append(0); dExtra1.append(U(0)); dExtra2.append(U(0));
arConnDescript.append("HTT16 USP"); iFastenerTypeFull.append(4); iFastenerTypeTacked.append(4); iFastenerQtyFull.append(18); iFastenerQtyTacked.append(2); arNewDescription.append("HTT16 USP"); arTranslation.append("HTT16 USP"); arConnectors.append("USP HTT16"); arDx.append(U(2)); arDz.append(U(2.5)); arDy.append(U(15.625)); arDRod.append(U(0.625));arDDrillCL.append(U(1.375));arIShape.append(0); dExtra1.append(U(0)); dExtra2.append(U(0));
arConnDescript.append("HTT45 USP");  iFastenerTypeFull.append(4); iFastenerTypeTacked.append(4); iFastenerQtyFull.append(26); iFastenerQtyTacked.append(2); arNewDescription.append("HTT45 USP"); arTranslation.append("HTT45 USP"); arConnectors.append("USP HTT45"); arDx.append(U(2)); arDz.append(U(2.5)); arDy.append(U(16)); arDRod.append(U(0.625));arDDrillCL.append(U(1.375));arIShape.append(0); dExtra1.append(U(0)); dExtra2.append(U(0));
//arConnDescript.append("HTT45 NAIL USP");  iFastenerTypeFull.append(4); iFastenerTypeTacked.append(4); iFastenerQtyFull.append(26); iFastenerQtyTacked.append(-1); arNewDescription.append("HTT45 USP"); arTranslation.append("HTT45 USP"); arConnectors.append("USP HTT45 NAIL"); arDx.append(U(2.75)); arDz.append(U(2.5)); arDy.append(U(16)); arDRod.append(U(0.625));arDDrillCL.append(U(1.375));arIShape.append(0);dExtra1.append(U(0)); dExtra2.append(U(0));
arConnDescript.append("HTT45 SDS USP"); iFastenerTypeFull.append(6); iFastenerTypeTacked.append(6); iFastenerQtyFull.append(26); iFastenerQtyTacked.append(2); arTranslation.append("HTT45 USP");

arConnDescript.append("LSTHD8 SIMPSON"); iFastenerTypeFull.append(5); iFastenerTypeTacked.append(5); iFastenerQtyFull.append(0); iFastenerQtyTacked.append(0); arNewDescription.append("LSTHD8 SIMPSON"); arTranslation.append("LSTHD8 SIMPSON"); arConnectors.append("LSTHD8"); arDx.append(U(.25)); arDz.append(U(2.75)); arDy.append(U(18.625)); arDRod.append(U(0));arDDrillCL.append(U(0));arIShape.append(5); dExtra1.append(U(8)); dExtra2.append(U(0));
arConnDescript.append("STHD10 SIMPSON"); iFastenerTypeFull.append(5); iFastenerTypeTacked.append(5); iFastenerQtyFull.append(0); iFastenerQtyTacked.append(0); arNewDescription.append("STHD10 SIMPSON"); arTranslation.append("STHD10 SIMPSON"); arConnectors.append("STHD10"); arDx.append(U(.25)); arDz.append(U(2.75)); arDy.append(U(24.625)); arDRod.append(U(0));arDDrillCL.append(U(0));arIShape.append(5); dExtra1.append(U(10)); dExtra2.append(U(0));
arConnDescript.append("STHD14 SIMPSON"); iFastenerTypeFull.append(5); iFastenerTypeTacked.append(5); iFastenerQtyFull.append(0); iFastenerQtyTacked.append(0); arNewDescription.append("STHD14 SIMPSON"); arTranslation.append("STHD14 SIMPSON"); arConnectors.append("STHD14"); arDx.append(U(.25)); arDz.append(U(2.75)); arDy.append(U(26.125)); arDRod.append(U(0));arDDrillCL.append(U(0));arIShape.append(5); dExtra1.append(U(14)); dExtra2.append(U(0));

arConnDescript.append("HD12");  iFastenerTypeFull.append(10); iFastenerTypeTacked.append(10); iFastenerQtyFull.append(4); iFastenerQtyTacked.append(2); arNewDescription.append("HD12"); arTranslation.append("HD12"); arConnectors.append("HD12"); arDx.append(U(4.5)); arDz.append(U(3.5)); arDy.append(U(20.3125)); arDRod.append(U(1));arDDrillCL.append(U(2.125));arIShape.append(6);dExtra1.append(U(3.625)); dExtra2.append(4);
arConnDescript.append("HD19");  iFastenerTypeFull.append(10); iFastenerTypeTacked.append(10); iFastenerQtyFull.append(5); iFastenerQtyTacked.append(2); arNewDescription.append("HD19"); arTranslation.append("HD19"); arConnectors.append("HD19"); arDx.append(U(4.5)); arDz.append(U(3.5)); arDy.append(U(24.5)); arDRod.append(U(1));arDDrillCL.append(U(2.125));arIShape.append(6);dExtra1.append(U(3.625)); dExtra2.append(5);

Map mpPropsOld = _ThisInst.mapWithPropValues().getMap("PropString[]").getMap(0);
String oldChoice = mpPropsOld.getString("strValue");
int oldFound = arConnDescript.find(oldChoice);
if (oldFound>-1) oldChoice = arTranslation[oldFound];
else oldChoice = "";
PropString strConnector(5, arNewDescription,"Hold Down Type");

String arSides[]={"Bottom Left","Bottom Right", "Top Left", "Top Right"};
PropString strSide(1,arSides,"Side to place connector");

String sDrillPlates = "Drill Plates"; // if this name is changed then must be updated @ GE_HDWR_WALL_ANCHOR TSL
PropString pDrillPlates(9,arStrYN,sDrillPlates, 0); 

PropString pStretchBeams(2,arStrYN,"Stretch beams");
pStretchBeams.setDescription("During generate construction stretch my vertical beams to the generated top and bottom plates.");

PropString pDeleteBeams(3,arStrYN,"Erase intersecting beams");
pDeleteBeams.setDescription("During generate construction erase the generated beams that have an intersection with my beams.");

PropString pFastenersType (6,arFastenerType,"Fasteners Type");//kn

PropInt iFastenersQty (7,0,"Fasteners Quantity");//kn

String arInstallOptions[]={"Fully Installed", "Tacked", "Field Installed"};//kn
PropString strInstallation (8,arInstallOptions,"Installation Options",0);//kn

PropInt pColor(0,3,"Color index for my beams");
pColor.setDescription("My beams are colored with the color defined by the index. Color -1 means the color of this TSL instance.");

PropDouble pVerticalOffset (0,U(0), T("|Vertical Offset|") );

PropDouble pLateralOffset (1,U(0), T("|Lateral Offset|") );
if (oldChoice.length()>0)
{	
	strConnector.set(oldChoice);
	Map mpRenew = _ThisInst.mapWithPropValues();	
	Map mpPropStrings = mpRenew.getMap("PropString[]");
	Map mpTemp;
	for (int i=0; i<mpPropStrings.length(); i++)
	{
		Map mpOld = mpPropStrings.getMap(i);
		if (i==0 || i==4) 
		{			
			mpOld.setString("strName", i < 1 ? "Connector to use" : "Shop Installed");
			mpOld.setString("strValue", "");
			mpOld.setInt("nEnumIndex", 666);
		}
		mpTemp.appendMap("PropString", mpOld);
	}
	mpRenew.setMap("PropString[]", mpTemp);
	_ThisInst.setPropValuesFromMap(mpRenew);
}

if (_bOnInsert) {
	
	showDialogOnce();


	while(true)
	{
		Beam arBm[0];
		
		PrEntity ssE("select a vertical stud pack", Beam());
		if (ssE.go()) {
			arBm = ssE.beamSet();
		}
		if (arBm.length()==0) break;
			
		//See if it needs to be switched around
		Element el=arBm[0].element();
		if(!el.bIsValid())break;
		
		_Map.setMap("mpProps", mapWithPropValues());
			
		//PREPARE TO CLONE
		TslInst tsl;
		String sScriptName = scriptName();
	
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		Beam lstBeams[0];
		Entity lstEnts[1];
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		
		lstBeams.append(arBm);	
		lstEnts[0] = el;
			
		tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString,1,_Map );
	}
	eraseInstance();
	return;
}
//__set properties from map
if(_Map.hasMap("mpProps")){
	setPropValuesFromMap(_Map.getMap("mpProps"));
	_Map.removeAt("mpProps",0);
}

if(_bOnElementDeleted)return;

int iFastenerChoice = - 1; String strFastenerChoice = "-1";
if(strInstallation==arInstallOptions[0])// fully installed
{
	iFastenerChoice = iFastenerQtyFull[arNewDescription.find(strConnector)];
	strFastenerChoice = arFastenerType[iFastenerTypeFull[arNewDescription.find(strConnector)]];
}
else if(strInstallation==arInstallOptions[1]) // Tacked
	{
		iFastenerChoice = iFastenerQtyTacked[arNewDescription.find(strConnector)];
		strFastenerChoice = arFastenerType[iFastenerTypeTacked[arNewDescription.find(strConnector)]];
	}
else // Field installed
	iFastenerChoice = 0;
	
if (_bOnInsert || _kNameLastChangedProp=="Hold Down Type" || _kNameLastChangedProp=="Installation Options" || oldChoice.length()>0 || _bOnRecalc || bDebug)
{
	pFastenersType.set(strFastenerChoice);
	iFastenersQty.set(iFastenerChoice);
}		

// interprete flags

int bDrillPlates = (pDrillPlates == arStrYN[0]);
int bStretchBeams = (pStretchBeams == arStrYN[0]);
int bDeleteBeams = (pDeleteBeams == arStrYN[0]);

//Relink command
String relink = T("|Relink to post|");
addRecalcTrigger(_kContext, relink);

if (_kExecuteKey == relink)
{
	_Beam.setLength(0);
	
	PrEntity ssE("select a vertical stud pack", Beam());
	if (ssE.go()) {
		_Beam = ssE.beamSet();
	}
}


for (int i=_Beam.length()-1; i>=0 ; i--) 
{ 
	Beam bm=_Beam[i]; 
	if(!bm.bIsValid())
	{ 
		_Beam.removeAt(i);
		continue;
	}
}

// erase this Tsl instance if the beams are erased
if (_Beam.length()==0) 
{
	Display dpr(1);
	dpr.textHeight(U(1));
	dpr.draw( scriptName() + " must be relinked to stud pack", _Pt0, _XW, _YW, 0, 0, _kDevice);
	
	return;
}

_Pt0 = _Beam[0].ptCen();


// assigns hold-down connectors to groups
String strPart1="X - Hardware",strPart2="X-Hold Down Connectors",strPart3=strConnector;
Group gr(strPart1,strPart2,strPart3);
gr.dbCreate();
gr.setBIsDeliverableContainer(TRUE);
gr.addEntity(_ThisInst,TRUE);


// Find the element from the beams. There should only be one. If 2 different elements are found, report error, and stop execution.
Element el;


if(_bOnElementListModified){
	//wall might have been split
	
	for(int i=_Element.length()-1;i>-1;i--){
		ElementWall elW=(ElementWall)_Element[i];
		if(! elW.bIsValid()){
			_Element.removeAt(i);
			continue;
		}
		Point3d arPt[]={elW.ptStartOutline(),elW.ptEndOutline()};
		
		if(elW.vecX().dotProduct(arPt[0]-_Pt0) * elW.vecX().dotProduct(arPt[1]-_Pt0) <0){
			_Element[0]=elW;
			_Element.setLength(1);
			break;
		}
	}
	if(_Element.length()!=1)eraseInstance();
	
	for (int b=0; b<_Beam.length(); b++) _Beam[b].assignToElementGroup(_Element[0],TRUE,0,'Z');	
}

//Make new sorted array
Beam arBmSort[0],arBmVert[0];
String strComponentName;
Body bdAll;

for (int b=0; b<_Beam.length(); b++) 
{
	Element elTest = _Beam[b].element();
	if (!el.bIsValid()) el = elTest;
	else if (elTest.bIsValid()) {
		if (el!=elTest) {
			reportNotice("\nBeams belong to different elements in "+scriptName() + "\nCheck Panel " + "\n       " + el.number()+ "\n       " + el.number());
			eraseInstance();
		}
	}
	assignToElementGroup(el,TRUE,0,'Z');
	if(arBmSort.length()==0){
		arBmSort.append(_Beam[b]);
	}
	else{
		double dDist=el.vecX().dotProduct(_Beam[b].ptCen()-el.ptOrg());
		int insert=0;
		for (int i=0; i<arBmSort.length(); i++){
			double dDist2=el.vecX().dotProduct(arBmSort[i].ptCen()-el.ptOrg());
			if(dDist2<=dDist)insert=i+1;
		}
		arBmSort.insertAt(insert,_Beam[b]);
	}
	if(_Beam[b].vecX().isParallelTo(el.vecX()))arBmVert.append(_Beam[b]);
	
	bdAll+=_Beam[b].envelopeBody();
}

if (!el.bIsValid()) {
	reportNotice("\nNo element found from the beams in "+scriptName());
	eraseInstance();
	return;
}


if(el.bIsValid())assignToElementGroup(el,FALSE,0,'Z');
else
{
	String strPart1="X - Hardware",strPart2="X-Hold Down";

	Group gr(strPart1,strPart2,"");
	if(!gr.bExists())gr.dbCreate();
	gr.setBIsDeliverableContainer(TRUE);
	gr.addEntity(_ThisInst,TRUE);	
}

	

Vector3d vOff=el.vecX(),vUp=el.vecY(),vZ=el.vecZ();
String stLevel = el.elementGroup().namePart(0);

//change orientation for concrete face anchors
int n=arNewDescription.find(strConnector);
if(n == 5 || n == 21 || n == 22 || n == 23 ) { vOff = el.vecZ();} // LTTI31 SIMPSON // LSTHD8 SIMPSON // STHD10 SIMPSON // STHD14 SIMPSON

if(strSide==arSides[0] || strSide==arSides[2])vOff*=-1;
if(strSide==arSides[2] || strSide==arSides[3])vUp*=-1;	

vZ = vOff.crossProduct(vUp);	


Point3d arPtSides[]=bdAll.extremeVertices(vOff);
Point3d arPtDnUp[]=bdAll.extremeVertices(vUp);
Point3d arPtZ[]=bdAll.extremeVertices(vZ);
Point3d ptCenZ;ptCenZ.setToAverage(arPtZ);

// element coordinate system
CoordSys csEl = el.coordSys();
Vector3d vecXEl = csEl.vecX();
Vector3d vecYEl = csEl.vecY();
Vector3d vecZEl = csEl.vecZ();
Point3d ptOrgEl = csEl.ptOrg();

int bIsHorizontalOnly=FALSE;

// filter out the vertical beams, and check that I have at least one.
Beam bmVertical[] = vecYEl.filterBeamsParallel(_Beam);
Beam bmHorizontal[] = vecXEl.filterBeamsParallel(_Beam);

bmVertical = vecXEl.filterBeamsPerpendicularSort(bmVertical);
if (bmVertical.length()==0) {
	reportMessage("\nNo vertical beams found in "+scriptName());
	eraseInstance();
	bIsHorizontalOnly=TRUE;
}

// add the panhand to all beams in the set
int bIsAlreadyModule=0;
for (int b=0; b<_Beam.length(); b++) {
	_Beam[b].setPanhand(el);
	_Beam[b].setColor(pColor);
	if(_Beam[b].module().length()>1)bIsAlreadyModule++;
}
bIsAlreadyModule = bIsAlreadyModule==_Beam.length()?1:0;



if(!bIsHorizontalOnly)
{
	// find the left point of the no stud distribution range
	Beam bmLeft = bmVertical[0];
	double dSizeLeft = bmLeft.dD(vecXEl);
	Point3d ptLeft = bmLeft.ptCen() - 0.5*dSizeLeft*vecXEl;
	ptLeft.vis();
	
	// find the right point of the no stud distribution range
	Beam bmRight = bmVertical[bmVertical.length()-1];
	double dSizeRight = bmRight.dD(vecXEl);
	Point3d ptRight = bmRight.ptCen() + 0.5*dSizeRight*vecXEl;
	ptRight.vis();
	
	// set the no stud distribution range
	
	el.setRangeNoDistributionStud(ptLeft,ptRight);
	
	// and also adjust the location of the TSL.
	_Pt0 = 0.5*(ptLeft+ptRight) + pVerticalOffset*vUp + pLateralOffset * el.vecZ();
	
	// write my own filter of the beamset that keeps only those that have a face in common with zone 1.
	// Zone 1 starts at the top of zone0, which is also the plane of the origin point of the element.
	Beam bmTouchingZone1[0];
	for (int b=0; b<bmVertical.length(); b++) {
		Beam bm = bmVertical[b];
		double dSizeBeam = bm.dD(vecZEl);
		double dDistToZone1 = vecZEl.dotProduct(ptOrgEl - bm.ptCen()) - 0.5*dSizeBeam;
		if (abs(dDistToZone1)<U(0.1)) {
			bmTouchingZone1.append(bm);
		}
		else if (_bOnDebug) {
			reportNotice("\nSome beams do not touch zone1 in "+scriptName());
		}
	}
	
	// for the beams which touch the zone1, add a construction directive to allow the sheeting to be cut.
	int nZone = 1;
	for (int b=0; b<bmTouchingZone1.length(); b++) {
		bmTouchingZone1[b].ptCen().vis(2);
		el.setSheetCutLocation(nZone, bmTouchingZone1[b].ptCen());
	}
	
	// for the vertical beams of my set, stretch them to the top and bottom of the frame
	if (bStretchBeams && (_bOnElementConstructed || _bOnRecalc) ) {
		
		Beam myVerticalBeams[] = vecXEl.filterBeamsPerpendicularSort(_Beam);
		
		Beam arOtherElementBeams[] = el.beam();
		
		// from the list of beam, remove my own beams vertical beams
		for (int b=0; b<myVerticalBeams.length(); b++) {
			arOtherElementBeams= myVerticalBeams[b].filterGenBeamsNotThis(arOtherElementBeams);
		}
	
		// for the remaining beams, find the beam to strech to
		for (int b=0; b<myVerticalBeams.length(); b++) {
			for (int nSide=0; nSide<2; nSide++) { // loop for positive and negative side
			
				Beam bm = myVerticalBeams[b];
				Point3d ptBm = bm.ptCen();
				Vector3d vecBm = bm.vecX();
				if (nSide==1) vecBm = -vecBm;
				Beam arBeamHit[] = bm.filterBeamsHalfLineIntersectSort(arOtherElementBeams, ptBm ,vecBm );
				// loop over the hit beams, and find the first top or bottom plate
				for (int i=0; i<arBeamHit.length(); i++) {
					
					Beam bmHit = arBeamHit[i]; // take first beam from filtered list because it is closest.
					int nBeamType = bmHit.type();
					if(bm.type()== _kSFSupportingBeam || bm.type()== _kSFJackUnderOpening){
						if (nBeamType==_kSFBottomPlate) {
							bm.stretchDynamicTo(bmHit);
							break; // out of inner for loop, only stretch to one
						}
					}
					else if(bm.type()== _kSFJackOverOpening){
						if (nBeamType==_kSFTopPlate || nBeamType== _kSFAngledTPLeft || nBeamType== _kSFAngledTPRight) {
							bm.stretchDynamicTo(bmHit);
							break; // out of inner for loop, only stretch to one
						}
					}
					else{
						if (nBeamType==_kSFTopPlate || nBeamType==_kSFBottomPlate || nBeamType== _kSFAngledTPLeft || nBeamType== _kSFAngledTPRight) {
							bm.stretchDynamicTo(bmHit);
							break; // out of inner for loop, only stretch to one
						}
					}
				}
			}
		}
	}

	// for the generated beams check if they are intersecting with my own set of beams
	if (bDeleteBeams && (_bOnElementConstructed || _bOnRecalc) ) {
		
		Beam myBeams[0];
		myBeams=_Beam;

			
		Beam arOtherElementBeams[] = el.beam();
		
		// from the list of beam, remove my own beams
		for (int b=0; b<myBeams.length(); b++) {
			arOtherElementBeams= myBeams[b].filterGenBeamsNotThis(arOtherElementBeams);
		}
	
		// for the remaining beams, find if there is an intersection with one of my own beams
		double dShorten = U(0.5); // half an inch on both sides
		for (int b=0; b<myBeams.length(); b++) {
			
			Beam bm = myBeams[b];
			// to find the intersection of my beam, shorten the body of my beam with pShorten distance
			Body bdShort(bm.ptCen(), bm.vecX(), bm.vecY(), bm.vecZ(), bm.dL()-2*dShorten, bm.dW(), bm.dH()); 
			Beam arBeamIntersect[] = bdShort.filterGenBeamsIntersect(arOtherElementBeams);
				
			// the beams that do intersect, remove from the array for the next search, and dbErase
			for (int i=0; i<arBeamIntersect.length(); i++) {
				Beam bmIntersect = arBeamIntersect[i];
				
				int nBeamType = bmIntersect.type();
				if (nBeamType==_kSFTopPlate || nBeamType==_kSFBottomPlate || nBeamType== _kSFAngledTPLeft || nBeamType== _kSFAngledTPRight) {
					reportMessage("\nElement "+el.number()+" of type "+el.code()+" has intersecting beams.");
				}
				else { // this beam is allowed to be erased
					arOtherElementBeams= bmIntersect.filterGenBeamsNotThis(arOtherElementBeams);
					bmIntersect.dbErase();
				}
			}
		}
	}
}
else
{
	for (int b=0; b<bmHorizontal.length(); b++)
	{
		for (int c=0; c<_Beam.length(); c++)
		{
			if(bmHorizontal[b].realBody().hasIntersection(_Beam[c].realBody()) && bmHorizontal[b].handle() != _Beam[c].handle())
				bmHorizontal[b].dbErase();
		}
	}
}
	
//Some display
Display dpTop(252),dpMod(252),dpModLay(252);
dpTop.addViewDirection(_ZW);
dpTop.addViewDirection(-_ZW);
dpMod.addHideDirection(_ZW);
dpModLay.showInDispRep("HoldDown");
dpModLay.textHeight(U(2));

dpMod.showInDxa(true);

Display dpDxa(1);
dpDxa.showInDxa(true);
dpDxa.textHeight(U(4));
dpDxa.showInDispRep("Bogus");


LineSeg lsMark(_Pt0, _Pt0+U(10)*el.vecZ());
dpModLay.draw(lsMark);

Vector3d vxText = el.vecZ();
int iFlagX = 1;
if(vxText.dotProduct(_XW) < U(0))
{
	vxText *=-1;
	iFlagX = -1;
}

dpModLay.draw(arConnectors[n], _Pt0+U(14)*el.vecZ(), vxText, _ZW.crossProduct(vxText), iFlagX,0);




if(arPtSides.length() * arPtDnUp.length()==0)return;
Plane pnBase(arPtDnUp[0] + vUp * pVerticalOffset,vUp);
Plane pnCenWall(ptCenZ,vZ);

if(arIShape[n]==5)pnBase = Plane(el.ptOrg(), vUp);
else if(arIShape[n]==6)pnBase = Plane(arPtDnUp[0] + vUp * (pVerticalOffset+dExtra1[n]),vUp);

arPtSides=pnBase.projectPoints(arPtSides);
arPtSides=pnCenWall.projectPoints(arPtSides);


//Top View
PLine plRecTop,plCTop;
plRecTop.createRectangle(LineSeg(arPtSides[1]-vZ*arDz[n]/2,arPtSides[1]+vZ*arDz[n]/2+vOff*arDx[n]),vZ,vOff);
plCTop.createCircle(arPtSides[1]+vOff*arDDrillCL[n],vUp,arDRod[n]/2);
dpTop.draw(plRecTop);
dpTop.draw(plCTop);

//Creat a mess of points for the DTT2Z
Point3d l1=arPtSides[1]-vZ*arDz[n]/2,l2=arPtSides[1]-vZ*U(0.125)+vUp*U(4.25),l3=arPtSides[1]-vZ*U(0.125)+vUp*U(6.5),l4=arPtSides[1]-vZ*U(0.5)+vUp*U(7),l5=arPtSides[1]-vZ*U(1.375)+vUp*U(6.6875),l6=arPtSides[1]-vZ*U(1.675)+vUp*U(6.5),l7=arPtSides[1]-vZ*U(1.675)+vUp*U(3.5),l8=arPtSides[1]+vOff*arDx[n]-vZ*arDz[n]/2;
Point3d arPth[]={arPtSides[1]-vZ*U(0.4375)+vUp*U(4.4375),arPtSides[1]-vZ*U(1.3125)+vUp*U(3.4375),arPtSides[1]-vZ*U(0.625)+vUp*U(6.625),arPtSides[1]-vZ*U(1.25)+vUp*U(5.75)};
PLine plDtt2(l1,l2,l3);
plDtt2.addVertex(l4);
plDtt2.addVertex(l5);
plDtt2.addVertex(l6);
plDtt2.addVertex(l7);
plDtt2.close();
PLine plDtt2S(l1,l7,l8);


Body bdConnector;

// DH12 & DH19 specs
double dDHSideLFactor = 0.85;	
double dDHHeadLFactor = 0.2;	
double dDHupL = arDy[n] - dExtra1[n];

//adding base
Body bdBase(arPtSides[1],vOff, vZ,vUp,arDx[n],arDz[n],dThick*2,1,0,1);
if(arIShape[n]==5){//concrete embeded
	Vector3d vBase = -vOff - (2 *vUp);
	vBase.normalize();
	
	vBase.vis(_Pt0, 1);
	bdBase = Body(arPtSides[1]+vOff * arDx[n],vBase, vZ,vBase.crossProduct(vZ), dExtra1[n],arDz[n],dThick*2,1,0,1);
	Vector3d vLip = vBase.crossProduct(vZ);
	vLip.normalize();
	vLip.vis(_Pt0, 2);
	bdBase += Body(arPtSides[1]+vOff * arDx[n]+ vBase*dExtra1[n], vLip , vZ, vLip.crossProduct(vZ), U(1.5),arDz[n],dThick*2,1,0,-1  );
	Body bd (arPtSides[1]+vOff * arDx[n]+ vBase*dExtra1[n], vLip , vZ, vLip.crossProduct(vZ), U(1.5),arDz[n],dThick*2,1,0,-1  );
}
bdConnector+=bdBase;

//adding upper body
Body bdUp(arPtSides[1],vOff, vZ,vUp,dThick,arDz[n],arDy[n],1,0,1);
if(arIShape[n]==3){//dtt2z
	bdUp=Body(plDtt2,vOff*dThick);
	for(int h =0;h<arPth.length();h++){
		Body bdD1(arPth[h]-vOff*dThick,arPth[h]+vOff*2*dThick,U(.125));
		bdUp-=bdD1;
	}
	
	Body bdUp2=bdUp;
	
	CoordSys csRo;csRo.setToRotation(180,vUp,Point3d(arPtSides[1]+vOff*dThick/2));
	bdUp2.transformBy(csRo);
	bdUp+=bdUp2;
}
if(arIShape[n]==6) // HD12/HD19
{ 
	PLine plUp;
	Point3d pt = arPtSides[1] - vZ * arDz[n]*.5;
	plUp.addVertex(pt);
	pt += vZ * arDz[n];
	plUp.addVertex(pt);
	pt += vUp * dDHupL * dDHSideLFactor;
	plUp.addVertex(pt);
	pt += vUp * dDHupL * (1-dDHSideLFactor) - vZ *arDz[n] * dDHHeadLFactor;
	plUp.addVertex(pt);
	pt += - vZ * (arDz[n] - arDz[n] * dDHHeadLFactor * 2);
	plUp.addVertex(pt);
	pt += -vUp * dDHupL * (1-dDHSideLFactor) - vZ *arDz[n] * dDHHeadLFactor;
	plUp.addVertex(pt);
	plUp.close();
	bdUp=Body(plUp,vOff*dThick);
	
	PLine plExtra;
	pt = arPtSides[1] + vOff*arDx[n] - vZ * arDz[n] *.5;
	plExtra.addVertex(pt);
	pt += vZ * arDz[n];
	plExtra.addVertex(pt);
	pt = arPtSides[1] + vOff * arDx[n] + vUp * vUp.dotProduct(arPtDnUp[0] - arPtSides[1]);
	plExtra.addVertex(pt);
	plExtra.close();
	Body bdExtra (plExtra, vOff * dThick, -1);
	bdConnector += bdExtra;
}
_Pt0=arPtSides[1];

bdConnector+=bdUp;
	
PLine plSide(arPtSides[1],arPtSides[1]+vOff*arDx[n]);
double dExtrudeMore=U(0);
if(arIShape[n]==2){
	plSide.addVertex(arPtSides[1]+vOff*arDx[n]+vUp*arDy[n]);
	plSide.addVertex(arPtSides[1]+vUp*arDy[n]);
	plSide.close();
	plSide.transformBy(vZ*(arDz[n]/2));
}
else if(arIShape[n]==3){
	plSide=plDtt2S;
}
else if(arIShape[n]==4){
	plSide=PLine(arPtSides[1]+vOff*arDx[n],arPtSides[1]+vOff*(arDx[n]-U(0.25)),arPtSides[1]+vOff*(arDx[n]-U(0.25))+vUp*U(0.5),arPtSides[1]+vOff*arDx[n]+vUp*U(0.5));
	plSide.close();
	dExtrudeMore=arDz[n]-dThick;
}
else
{
	double dSideL = U(6);
	 if (arIShape[n] == 6) dSideL = dDHupL * dDHSideLFactor;
	plSide.addVertex(arPtSides[1]+dSideL*vUp);
	plSide.close();
	plSide.transformBy(vZ*(arDz[n]/2));
}

CoordSys mir;mir.setToMirroring(Plane(arPtSides[1],vZ));	
	
Body bdSide(plSide,vZ*(dThick+dExtrudeMore),0);
bdConnector+=bdSide;
bdSide.transformBy(mir);
bdConnector+=bdSide;
bdConnector.vis(2);

//subtracting
Body bdAnchor(arPtSides[1]+vOff*arDDrillCL[n]-vUp*dThick,arPtSides[1]+vOff*arDDrillCL[n]+vUp*dThick*4,arDRod[n]/2);
bdConnector-=bdAnchor;

Point3d ptFastener=arPtSides[1]+vUp*U(2) + vZ*arDz[n]*0.375;
if (arIShape[n] != 6)
{
	Body bdDrill;
	Body bdD1(ptFastener - vOff * dThick, ptFastener + vOff * 2 * dThick, U(.125));
	bdDrill += bdD1;
	bdD1.transformBy(-vZ * arDz[n] * 0.5);
	bdDrill += bdD1;
	bdD1.transformBy(vUp * arDz[n] * 0.5);
	bdD1.transformBy(-vZ * arDz[n] * 0.125);
	bdDrill += bdD1;
	bdD1.transformBy(vZ * arDz[n] * 0.5);
	bdDrill += bdD1;
	double dGo = U(2);
	while (dGo < arDy[n]) {
		if (n == 3)break;
		bdConnector -= bdDrill;
		
		dGo += U(arDz[n]);
		bdDrill.transformBy(arDz[n] * vUp);
	}
}
else // DH12 / DH19
{
	int nHoles = dExtra2[n];
	double dDist = dDHupL / (nHoles + 1);
	Point3d ptDrill = arPtSides[1];
	for (int i = 0; i < nHoles; i++)
	{
		ptDrill += vUp * dDist;
		Body drill (ptDrill - vOff, ptDrill + vOff, U(0.5));
		bdConnector -= drill;
	}//next i	
}

bdConnector.vis(2);
dpMod.draw(bdConnector);
dpModLay.draw(bdConnector);	
//make sure no stud touches the connector
if(_bOnInsert || (_bOnDbCreated && iState==0)){
	Beam arBm[]=el.vecX().filterBeamsPerpendicular(el.beam());
	
	for(int h =arBm.length()-1;h>-1;h--)	if(arBm[h].realBody().hasIntersection(bdConnector) && _Beam.find(arBm[h])==-1 && arBm[h].module().length()<2)arBm[h].dbErase();
}
	
Point3d ptq = _Pt0 + (_Pt0 - Line(_Pt0, el.vecX()).closestPointTo(_Beam.first().ptCen())) * U(2, "mm");
ptq.vis(5);

exportToDxi(TRUE);
model(strConnector);
material("Hold Down");
dxaout("Element",el.number());
dxaout("TH-Item",strConnector);





HardWrComp arHwr[0];

HardWrComp hwr;
hwr.setName("Holddown");
hwr.setBVisualize(false);
hwr.setDescription("Wall Holdown");
hwr.setManufacturer( String(strConnector).makeUpper().find("USP", 0) > -1?"USP":"SIMPSON");
hwr.setArticleNumber(String(strConnector));
hwr.setModel(String(strConnector));
hwr.setQuantity(1);
hwr.setCountType("Amount");
hwr.setNotes("-" + String(strInstallation) + " ");
hwr.setGroup(stLevel);


int iAddFasteners = true;
if(strInstallation==arInstallOptions[0] && pFastenersType==strFastenerChoice && iFastenersQty==iFastenerChoice) iAddFasteners=false;

if(iAddFasteners)
{
	HardWrComp hwr1;
	hwr1.setName("Nail");
	hwr1.setDescription("Nail");
	hwr1.setArticleNumber(String(pFastenersType));
	hwr1.setModel(String(pFastenersType));
	hwr1.setQuantity(int(iFastenersQty));
	hwr1.setGroup(stLevel);
	
	hwr.setNotes(hwr.notes()+", Fasteners: (" + iFastenersQty + ") " + pFastenersType );
	
    _Map.setString("HOLDDOWN_FASTENERS", "(" + iFastenersQty + ")" + pFastenersType );
	arHwr.append(hwr1);
}
arHwr.append(hwr);
_ThisInst.setHardWrComps(arHwr);



Map mapDxaOut;
mapDxaOut.appendInt(strConnector,1);

_Map.setMap("MapDxaOut",mapDxaOut);	

Map mpHDOut;
mpHDOut.setString("stTypeDescription", String(strConnector));
mpHDOut.setString("stConnector", String(strConnector));
mpHDOut.setDouble("dSizeXEl", arDx[n]);
mpHDOut.setDouble("dSizeYEl", arDy[n]);
mpHDOut.setDouble("dSizeZEl", arDz[n]);
_Map.setMap("mpHoldDownData", mpHDOut);

if(arIShape[n]!=5)
{
	//add an atc rod
	String strAddRod="Add Anchor";
	
	String strRemoveRod="Release Anchor";
	
	addRecalcTrigger(_kContext,strAddRod);
	addRecalcTrigger(_kContext,strRemoveRod);
	
	if( _kExecuteKey ==  strAddRod || (_bOnDbCreated && iState==0) )
	{
		TslInst tsl;
		String sScriptName = "GE_HDWR_WALL_ANCHOR";
		
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		Beam lstBeams[0];
		Entity lstEnts[2];
		lstEnts[0] = el;
		lstEnts[1] = _ThisInst;
		Point3d lstPoints[1];
		lstPoints[0]=arPtSides[1]+vOff*arDx[n]/2;
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		
		Map mpHD;
		mpHD.setEntity("HoldDown", _ThisInst);
		mpHD.setDouble("dRodInsert", arDRod[n]);
		
		tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString,0,mpHD);
		
		_Map.setEntity("ANCHOR",tsl);
	}
	
	if( _kExecuteKey ==  strRemoveRod)
	{
		if(_Map.hasEntity("ANCHOR"))
		{
			Entity ent=_Map.getEntity("ANCHOR");
			TslInst tslRod=(TslInst)ent;
			
			Map mpRod=tslRod.map();
			mpRod.removeAt("HoldDown",0);
			
			tslRod.setMap(mpRod);
			
			_Map.removeAt("ANCHOR",0);
		}
	}
	
	if(_Map.hasEntity("ANCHOR"))
	{
		Entity ent=_Map.getEntity("ANCHOR");
		TslInst tslRod=(TslInst)ent;
	}	
}
else
{
	Entity ent = _Map.getEntity("ANCHOR");
	if(ent.bIsValid())ent.dbErase();
	_Map.removeAt("ANCHOR",0);
}


		
_Map.setPoint3d("ANCHOR_POINT",arPtSides[1]+vOff*arDDrillCL[n]);


#End
#BeginThumbnail
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
M-OWJGW'%6Q27NT_O'S3R3R%Y79W/=CT]AZ"F445Z22BK(X&VW=A1110(****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`.@HHHKY<^C"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***559V"J,D]!0
M`E."#;N8[5_,GZ"E+*G3#/[]!_C_`"^M1LS.VXDL3W)JXQ;$Y)"N^X;0-J^G
MK]:;116B26B,V[[A1113$%%%%`!1110`4444`%%%%`!1110`4444`%*JL[;0
M"Q/8"@*H4O(ZQQ@X+,?;.!ZGV%4;C5&*^7:@QIQE^CMZ\CH/;VJZ=*55VBO\
MB)U(TU>3+5Q=16>%.V6;^Z&^5?\`>]3GM[5D3SR7$F^5]S8`'&``.P`Z5'17
MK4<-&DK[ON>95KRJ:;+L%%%%;F`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110!T%%%%?+GT84444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%`!)``R3T`IYV(.?F?L!@J/\`'_/TIAL($^7<
MQVJ>A(Z_2D9\KM4;5_,GZFFLQ9B2<DTE:1C;5F;G?8****LD****`"BBB@`H
MHHH`****`"BBB@`HHHH`***4+\C.Q"HHRS-T'^?2@!`"2`!DGH!27,T5D&$A
M#SXXB'09Z%B/Y=>E5;C4]FZ.S)4'@RG[S#';^Z/UZ5F5VT<'*7O5-%VZG)5Q
M48^[#5]^A-<74MU)OE?('W5'W5'H!VJ&BBO2C%15HJR//E)R=Y/4****9(44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`=!1117RY]&%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444`$D`#)/0"
MF`4Y4R-Q.U1W_P`/6E(5/O<M_=!Z?7_#^5,=V=LL<D#`]A346R7)(5I,`JGR
MCH3W;Z_X4RBBM$DMB&V]PHHHJA!1110`4444`%%%%`!1110`4444`%%%%`!1
M3TC9]Q&`JC+,QP%'J35&XU)4!2TSD@@S,,'_`(".W'?KSVJZ=.525HK_`(!%
M2I&"O)ER:6"S7,YW2'I$I^8=_F]!T]^:R+J\DNW#2;0JC"JHPJ_05`S,S%F)
M9B<DDY)-)7J4,-&GJ]7W_P`CSJV)E4T6B"BBBNDY@HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M#H****^7/HPHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***>55/O\MV4?U]/\]*8"(I;
M/(4#JS=*&<`%4&`>I/4_X4UG9\9Z#HHZ"FU<8]61*?1!1115D!1113`****`
M"BBB@`HHHH`****`"BBB@`HHIR(SYQPHY9CP%'J32;L&XVB9X[10]P?F()6(
M?>;_``'O[&H+G44M\I:G=*#\TI`*C']WU^OMQUK)9F9BS$LQ.22<DFNRAA)3
M]Z6B_%G+6Q48>['5_@6+N^ENR%/RQ*<K&O1?\3[^YJM117IPA&"M%61Y\YRD
M[R=V%%%%40%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`'04445\N?1A1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!3E4MDC@#JQZ"E*A/\`69S_`'1P?_K4QV+8S@`=`!P*I1;$Y)#S(%&(
M^&[OGD_3TJ*BBM%%+8S;;W"BBBJ$%%%%`!1110`4444`%%%%`!1110`4444`
M%%.1'=MJ*6/M5>XU"&V!2W(EE_YZ?PJ?8?Q?7ITJH0E-VBKLF<XQ5Y.R)Y&B
MMT#SMM!P55<%F!]!Z<'DUE75_+<#8!Y<79%)P>>_J>GY57EE>>5I)'+.QR2:
M;7J4,+&GK+5_D>=6Q,I^['1?F%%%%=1RA1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`'04445\N?1A1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`444\*%7=(2HQE5QRW^?6F`U5+'`_4X`I
M2ZI]SEO[Q'3Z?X_RIKN6&/NK_='2FU<8]R'+L!))))R3U)HHHJR`HHHI@%%%
M%`!1110`4444`%%%%`!1110`444J(SL%498]!0`E.8)#'YL[[$Z@?Q-_NCOV
M_.H)[Z&UXCV32X'NB_B#R?TYK)FGDGD+RNSN>['I[#T%=-'"RJ:RT7XLYZN)
MC#2.K_`L76H27"^6B^5#QE1R6([D]_Y54HHKU(4XP5HJR/-G4E-WD[A1115D
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110!T%%%%?+GT84444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4JHS
M'`&>Y]J4(-NYCM7\R?H*1WW`*%"J.P[^Y]:I)O83:6XI94^[AF_O$<?D?\_S
MJ,DDDDY)ZDT45HHI&;DV%%%%4(****`"BBB@`HHHH`****`"BBB@`HHHH`**
M559VV@%B>P%;NF^'9)4%Q<_+'P57KN_S_G-.,92=HJ[%*2BKR=D8>U4B\V:0
M119QN(SD^@'4_P#ZZSKO46E7RK=6BB_B^;YG[<^V.W2NC\:1)#I.EI&H5!<7
M.`/]V&N-KTJ&$4?>GJ_P1Y];$RE[L=%^(4445VG(%%%%`@HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`.@HHHKY<^C"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHIP3Y=S':IZ$CK]*8"*I8X'
M6G%E3IAG]^@_Q_E]::SY7:HVK^9/U-,JXQ[D.785F9VW$EB>Y-)115D!1113
M`****`"BBB@`HHHH`****`"BBB@`HHH`)(`&2>@%`!4]O:R7+X13C/+>E7M-
MTG[6TK2,-D)42*#RI8,5'U.UOR]QG:6*.%=D:@`#%;TJ$JFNR[F-6M&GIN^Q
M7L=.A@*DJ&8YR3S71G_CU%9$?WEK7/\`QZBO1ITXTU:*//G4E-W;.+\<?\@W
M3/\`KXN?_08:XNNT\<?\@W3/^OBY_P#08:XNMX[&3W"BBBF2%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`=!1117RY]&%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%`!)``R3T`IRID;B=JCO\`
MX>M(TF`53Y1T)[M]?\*I)L3:6XXE8^N&?V.0/\:C9BS$DY)I**TC%(S<FPHH
MHJA!1110`4444`%%%%`!1110`4444`%%%%`!112S2P6:YG.Z0](E/S#O\WH.
MGOS0DY.T5=B;25V[(`OR,[$*BC+,W0?Y]*IW&I[=T=F2H/!E/WF&.W]T?KTJ
MI=7DEVX:3:%4855&%7Z"J]>E1P:7O5-7VZ'!5Q3?NPT7?J=MX&_Y!6K?]=K;
M_P!!FK9?J:QO`W_(*U;_`*[6W_H,U;,G4UULY5L.C^\M:_\`RZBLB/[RUK?\
MNHI#.,\<?\@W3/\`KXN?_08:XNNT\<?\@W3/^OBY_P#08:XNKCL2]PHHHIDA
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`'04445\N?
M1A1110`4444`%%%%`!1110`4444`%%%%`!1110`444Y5)&XG:O3<>E,!H!)`
M`R3T`IY"I][EO[H/3Z_X?RI&<`%8Q@'J3U/^%1U<8WW)<K;"L[.<DY]/:DHH
MJ]C,****8!1110`4444`%%%%`!1110`4444`%%%%`!3TC9]Q&`JC+,QP%'J3
M3)GCM%#W!^8@E8A]YO\``>_L:RKN^ENR%/RQ*<K&O1?\3[^YK:E0G5U6B[F-
M6M&EIN^Q:N-25`4M,Y((,S#!_P"`CMQWZ\]JS69F8LQ+,3DDG))I**]6E1C2
M5DCS:E651W84445J9';>!O\`D%:M_P!=K;_T&:MF3J:QO`W_`""M6_Z[6W_H
M,U;,G4U$MRUL.CZK]:UO^745DQ_>6M;_`)=5I#.,\<?\@W3/^OBY_P#08:XN
MNU\;_P#(-TS_`*[W/_H,-<55QV)>X4444R0HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@#H****^7/HPHHHH`****`"BBB@`HHHH`**
M**`"BBB@`HIRJ6R1P!U8]!2LX0D1GI_'T)^GI5)-Z";2W`JJ??Y;L@_KZ?YZ
M4QG9\9Z#HHZ"FT5I&*1FY-A1115""BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB1HK=!).^T'!55P78'T'IP>30DV[+<&TE=CD1GSCA1RS'@*/4FJUSJ*09
M2U.Z4'YI2`5&/[OK]?;CK5*ZOY;@;`/+B[(I.#SW]3T_*JM>A1P?VJGW'#5Q
M?V:?WBLS,Q9B68G)).232445WG$%%%%,D****`.V\#?\@K5O^NUM_P"@S5LR
M=36-X&_Y!>K?]=K?_P!!FK9DZFHEN6MAT8^916L1BU`K*C^^M:K?\>HI#.-\
M;_\`(-TS_KO<_P#H,-<57:^-_P#D&Z9_UWN?_08:XJKCL2]PHHHIDA1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`'04445\N?1A1110
M`4444`%%%%`!1110`444JJ7.!^IP!3`2GE0G^LSG^Z.#_P#6HWJF0GS,?XB.
MGT_Q_E454HMDN5MASN7QG``Z`#@4VBBM$K;&;=PHHHI@%%%%`!1110`4444`
M%%%%`!1110`4444`%.1'=MJ*6/M0P2&/S9WV)U`_B;_='?M^=95UJ#W"^6B^
M5#QE1R6([D]_Y5K2H2JO3;N95*T::UW[%VXU"&V!2W(EE_YZ?PJ?8?Q?7ITK
M)EE>>5I)'+.QR2:;17JT</"FM-^_4\VK7E5>NW8****V,0HHHH`****`"BBB
M@#MO`W_(+U;_`*[V_P#Z#-6S)U-8W@;_`)!>K?\`7:W_`/09JV9.IJ);EK8?
M']Y:U6_X]165']Y:U3_QZCZTAG&^-_\`D&Z9_P!=[G_T&&N*KM/'!SIFEG_I
MXN?_`$&&N+JX[$O<****9(4444`%%%%`!1110`4444`%%%%`!1110`4444`%
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
MBBB@`HHHH`****`"BBB@`HHIR(SYQPHY9CP%'J32;#<;1*\5HFZX)WD92(?>
M;Z^@_P#KU7N=16W8QVV&<8S,<$`]]H_+FLIF9F+,2S$Y))R2:[*.$<_>EHOQ
M9RU<4H>['5_@6+N^ENR%/RQ*<K&O1?\`$^_N:K445Z<(1@K15D>?.<I.\G=A
M1115$!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110!Z
M'X0D<>#O+!^1K^5B,=2(XP/YFKDGWJH^$?\`D5%_Z_9O_0(JO2?>J'N6MAZ?
M?7ZUJ.,VOXUEQ_ZQ?K6L_%J/I2&<5XV_Y!FF_P#7Q<?^@PUQE=GXV_Y!FF_]
M?%S_`.@PUQE7'8E[A1113)"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`-ZBBBOGSW0HHHH`****`"BBB@`HHHH`****`"BBB@!T8#2
M*IZ$C-9^IW4K7$MN"$BC)4*O`//4^IX%%%;8;^*O0RQ'\)^IGT445[1Y`444
M4""BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`]!\(_\`(J+_`-?LW_H$57I/O445#W+6P^/_`%B_6M:3_CU'THHI#.*\;?\`
M(,TW_KXN?_08:XRBBKCL2]PHHHIDA1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
2%%%`!1110`4444`%%%%`'__9
`
































#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="0.03937008" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="741" />
      </lst>
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End