#Version 8
#BeginDescription
# Version 1.03 
# 15-03-04 aj@hsb-cad.com
# Version 1.02 
# 08-03-04 as@hsb-cad.com
#  Make the tsl also work for profiles where ptCen isn't on the axis of the beam.
# Version 1.01
# Date created: 08-01-2004
# Last edited: 23-01-2004
# Author: as@hsb-cad.com

**************
How to use.
**************
This TSL requires a beam and one or more elements

On insert:
1. select the beam.
2. select the wall-elements with a cross select. (Wall elements should be above each other)

The TSL created a pocket in the wall, on the intersection point of the wall with the beam and a point load in the walls underneath the wall with the pocket. The TSL adds a "Special" (POCKETC) to the 'top'-wall element and a "Special" point load to the elements below.
When the beam changes position or size, the pocket and point load also changes position, or size.
Creation and changes in position or size of the pocket and point load are only visible after reconstruction. 
***********



















#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
U(1,"mm");
// ***
// Create properties.
// This part of the scriptcreates the properties which can be changed by the user.
// These properties are visible in the OPM.
// ***


PropDouble dSpace(0,U(0,0.5),T("Space"));

PropInt nToolingIndex(0,0,T("Tooling index"));

String arSMill[] = {T("Apply milling"),T("Do not mill")};
PropString strMill(0,arSMill,T("Milling"),0);

String arSSide[]= {T("Left"),T("Right")};
int arNSide[]={_kLeft, _kRight};
PropString strSide(1,arSSide,T("Side"),0);
int nSide = arNSide[arSSide.find(strSide,0)];

String arSTurn[]= {T("Against course"),T("With course")};
int arNTurn[]={_kTurnAgainstCourse, _kTurnWithCourse};
PropString strTurn(2,arSTurn,T("Turning direction"),0);
int nTurn = arNTurn[arSTurn.find(strTurn,0)];

String arSOShoot[]= {T("No"),T("Yes")};
int arNOShoot[]={_kNo, _kYes};
PropString strOShoot(3,arSOShoot,T("Overshoot"),0);
int nOShoot = arNOShoot[arSOShoot.find(strOShoot,0)];

String arSVacuum[]= {T("No"),T("Yes")};
int arNVacuum[]={_kNo, _kYes};
PropString strVacuum(4,arSVacuum,T("Vacuum"),0);
int nVacuum = arNVacuum[arSVacuum.find(strVacuum,0)];

PropString sDimStyle(5, _DimStyles, "Text Style");
PropString sDispRep(6, "", "Show in Disp Rep");
//  ***
//  End of properties. 
//  ***

// ***
// Start insert
// This code is executed when the TSL is inserted.
// ***
if (_bOnInsert) {

	if (_kExecuteKey=="")
		showDialogOnce();

  _Beam.append(getBeam("Select a beam"));
  //_Element.append(getElement("Select an element"));

  // the constructor of PrEntity requires a type of entity. Here we use Element()
  PrEntity ssE("\nSelect a set of elements",Element());

  // let the prompt class do its job, keep requesting, until escape or nothing selected
  while (ssE.go() && (ssE.set().length()>0)) { 
    Entity ents[0]; // the PrEntity will return a list of entities, and not elements
    // copy the list of selected entities to a local array: for performance and readability
    ents = ssE.set(); 
    // turn the selected set into an array of elements
    for (int i=0; i<ents.length(); i++) {
        // The ents (but also the ssE.set() is an array of type Entity. An Element is always an Entity, but an Entity is not necessarily a Element.
        // So in order to append them to a list of elements, the entity needs to be turned into an element. This is called casting. The entity,
        // if allowed, can be casted into an element. To cast, you need to use the (type) operator.
        Element el = (Element)ents[i]; // cast the entity to a element    
        _Element.append(el);
    }
  }
  return;
}
// ***
// End insert.
// ***

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

if(_bOnDebug){
  for(int i=0;i<_Element.length(); i++){_Beam.append(_Element[i].beam());}
}

// Check if the beam and element(s) are available. If not return and delete TSL.
if (_Beam.length() == 0) { eraseInstance(); return; }
if (_Element.length() == 0) { eraseInstance(); return; }

//Find the element for the pocket. This should be the element with the largest _PtOrg.Z();
int indexElPC;
if(_bOnElementConstructed){
  //Set initial values to 0.
  indexElPC = 0;
  double dLargestCoordZ = 0;
  
  // walk through the elements and check wheter the _PtOrg().Z() is larger
  // then the one already stored.
  for(int i = 0; i<_Element.length(); i++){
    double dCoordZ = _Element[i].ptOrg().Z();
    // If the _PtOrg().Z() is larger then the one already stored,
    // store it and also store the index of the element in the element array.
    if (dCoordZ > dLargestCoordZ){
      // Store the largest Z coord.
      dLargestCoordZ = dCoordZ;
      // This index is used to place the pocket in the right element.
      // It is also used to remeber in which element the pocket is placed,
      // so no pointload will be placed in that element.
      indexElPC = i;
    }
  }
}


// Make the TSL dependent on the selected beam.
// When the beam changes the TSL is doing a recalc
Beam bm = _Beam[0];
setDependencyOnEntity(bm);

// Use coordinate system from the element.
Element elPC = _Element[indexElPC];
CoordSys csEl = elPC.coordSys();//csEl.vis();

Vector3d vx=csEl.vecX();
Vector3d vy=csEl.vecY();
Vector3d vz=csEl.vecZ();
Point3d ptOrgEl=csEl.ptOrg();


// Assign this TSL to zone E0 of the element with the pocket.
assignToElementGroup(elPC,TRUE,0,'E');

// Determine _Pt0
Vector3d vecBm = bm.vecX();
vecBm.normalize();
Body bd=bm.realBody();
Point3d pts[]=bd.extremeVertices(bm.vecZ());
Point3d ptCBm = pts[0] +
                            bm.vecY() * bm.vecY().dotProduct(bm.ptCen()-pts[0]) + 
                            0.5*bm.vecZ()*bm.dH();ptCBm.vis(0);
Line line(ptCBm, vecBm);line.vis();
Plane plane(csEl.ptOrg(),csEl.vecZ());//plane.vis();
_Pt0 = line.intersect(plane,0);_Pt0.vis();

// Determine the height of the element in point _Pt0
// first get polyline, then find intersection with vertical line
PLine plEnv=elPC.plEnvelope(_Pt0);
Point3d pntsVer[] = plEnv.intersectPoints(_Pt0,csEl.vecY());
// Default value.
double dElHeight = U(1000);
if (pntsVer.length()>0) {
  dElHeight = csEl.vecY().dotProduct(pntsVer[pntsVer.length()-1]-csEl.ptOrg());
}
//if (_bOnDebug) reportNotice("\nHeight of element is "+dElHeight);
// Height of _Pt0
double dPtHeight = csEl.vecY().dotProduct(_Pt0-csEl.ptOrg());


// Add special to element.
double dWidth = bm.dW();
double dHeight = bm.dH();


// Angle between beam and wall element
double angle = abs(90 - csEl.vecX().angleTo(bm.vecX()));
 
Point3d ptUppFL = _Pt0 - dWidth/2/cos(angle)*csEl.vecX() + (dElHeight-dPtHeight)*csEl.vecY()-dSpace*csEl.vecX(); //ptUppFL.vis();
Point3d ptUppFR = _Pt0 + dWidth/2/cos(angle)*csEl.vecX() + (dElHeight-dPtHeight)*csEl.vecY()+dSpace*csEl.vecX(); //ptUppFR.vis();
Point3d ptLowFL = _Pt0 - dWidth/2/cos(angle)*csEl.vecX() - dHeight/2*csEl.vecY()-dSpace*csEl.vecX(); //ptLowFL.vis();
Point3d ptLowFR = _Pt0 + dWidth/2/cos(angle)*csEl.vecX() - dHeight/2*csEl.vecY()+dSpace*csEl.vecX(); //ptLowFR.vis();

Point3d ptUppBL;
Point3d ptUppBR;
Point3d ptLowBL;
Point3d ptLowBR;
if ( csEl.vecZ().angleTo(bm.vecX())>90 )
{
  ptUppBL = _Pt0 + elPC.dBeamWidth()/cos(angle)*bm.vecX()-dWidth/2/cos(angle)*csEl.vecX() + (dElHeight-dPtHeight)*csEl.vecY()-dSpace*csEl.vecX(); //ptUppBL.vis();
  ptUppBR = _Pt0 + elPC.dBeamWidth()/cos(angle)*bm.vecX() + dWidth/2/cos(angle)*csEl.vecX() + (dElHeight-dPtHeight)*csEl.vecY()+dSpace*csEl.vecX(); //ptUppBR.vis();
  ptLowBL = _Pt0 + elPC.dBeamWidth()/cos(angle)*bm.vecX() - dWidth/2/cos(angle)*csEl.vecX() - dHeight/2*csEl.vecY()-dSpace*csEl.vecX(); //ptLowBL.vis();
  ptLowBR = _Pt0 + elPC.dBeamWidth()/cos(angle)*bm.vecX() + dWidth/2/cos(angle)*csEl.vecX() - dHeight/2*csEl.vecY()+dSpace*csEl.vecX(); //ptLowBR.vis();
}
else
{
  ptUppBL = _Pt0 - elPC.dBeamWidth()/cos(angle)*bm.vecX()-dWidth/2/cos(angle)*csEl.vecX() + (dElHeight-dPtHeight)*csEl.vecY()-dSpace*csEl.vecX(); //ptUppBL.vis();
  ptUppBR = _Pt0 - elPC.dBeamWidth()/cos(angle)*bm.vecX() + dWidth/2/cos(angle)*csEl.vecX() + (dElHeight-dPtHeight)*csEl.vecY()+dSpace*csEl.vecX(); //ptUppBR.vis();
  ptLowBL = _Pt0 - elPC.dBeamWidth()/cos(angle)*bm.vecX() - dWidth/2/cos(angle)*csEl.vecX() - dHeight/2*csEl.vecY()-dSpace*csEl.vecX(); //ptLowBL.vis();
  ptLowBR = _Pt0 - elPC.dBeamWidth()/cos(angle)*bm.vecX() + dWidth/2/cos(angle)*csEl.vecX() - dHeight/2*csEl.vecY()+dSpace*csEl.vecX(); //ptLowBR.vis();
}

// Used for creation of pocket.
double dPCWidth;

Sheet shElFront[] = elPC.sheet(1);
Sheet shElBack[] = elPC.sheet(-1);
double dShFrontH = 0;
double dShBackH = 0;
if(_bOnElementConstructed){
  if (shElFront.length()>0) dShFrontH = shElFront[0].dH();
  if (shElBack.length()>0) dShBackH = shElBack[0].dH();   
}

PLine plFront(csEl.vecZ());
PLine plBack(csEl.vecZ());
PLine plPocket(csEl.vecZ());
if ( ( csEl.vecX().angleTo(bm.vecX()) < 90 && csEl.vecZ().angleTo(bm.vecX()) < 90 ) || 
     ( csEl.vecX().angleTo(bm.vecX()) > 90 && csEl.vecZ().angleTo(bm.vecX()) > 90 ) ) {
  plFront.addVertex(ptUppFR+dShFrontH*tan(angle)*csEl.vecX());
  plFront.addVertex(ptLowFR+dShFrontH*tan(angle)*csEl.vecX());
  plFront.addVertex(ptLowFL);
  plFront.addVertex(ptUppFL);

  plBack.addVertex(ptUppBR);
  plBack.addVertex(ptLowBR);
  plBack.addVertex(ptLowBL-dShFrontH*tan(angle)*csEl.vecX());
  plBack.addVertex(ptUppBL-dShFrontH*tan(angle)*csEl.vecX());

  plPocket.addVertex(ptUppFR+dShFrontH*tan(angle)*csEl.vecX());
  plPocket.addVertex(ptLowFR+dShFrontH*tan(angle)*csEl.vecX());
  plPocket.addVertex(ptLowBL+elPC.dBeamWidth()*csEl.vecZ()-dShFrontH*tan(angle)*csEl.vecX());
  plPocket.addVertex(ptUppBL+elPC.dBeamWidth()*csEl.vecZ()-dShFrontH*tan(angle)*csEl.vecX());
  plPocket.close();

  // Determine the width of the pocket.  
  dPCWidth = ( ptLowFR - (ptLowBL+elPC.dBeamWidth()*csEl.vecZ())-dShFrontH*tan(angle)*csEl.vecX() ).length();
}
else {
  plFront.addVertex(ptUppFR);
  plFront.addVertex(ptLowFR);
  plFront.addVertex(ptLowFL-dShBackH*tan(angle)*csEl.vecX());
  plFront.addVertex(ptUppFL-dShBackH*tan(angle)*csEl.vecX());  

  plBack.addVertex(ptUppBR+dShBackH*tan(angle)*csEl.vecX());
  plBack.addVertex(ptLowBR+dShBackH*tan(angle)*csEl.vecX());
  plBack.addVertex(ptLowBL);
  plBack.addVertex(ptUppBL);
 
  plPocket.addVertex(ptUppBR+elPC.dBeamWidth()*csEl.vecZ()+dShBackH*tan(angle)*csEl.vecX());
  plPocket.addVertex(ptLowBR+elPC.dBeamWidth()*csEl.vecZ()+dShBackH*tan(angle)*csEl.vecX());
  plPocket.addVertex(ptLowFL-dShBackH*tan(angle)*csEl.vecX());
  plPocket.addVertex(ptUppFL-dShBackH*tan(angle)*csEl.vecX());
  plPocket.close();

  // Determine the width of the pocket.
  dPCWidth = ( (ptLowBR + elPC.dBeamWidth()*csEl.vecZ()+dShBackH*tan(angle)*csEl.vecX()) - ptLowFL ).length();
}
//plFront.vis();
//plBack.vis();
//plPocket.vis();

// ***
// Place Special Pocket C (POCKETC)
//
// 
// ***
double dPCHeight = dPtHeight -dHeight/2;
//double dPCBraceheight = elPC.dBeamHeight();
double dPCBraceheight = 0;

String arSPocketCParam[] = {T("Set width & height based on beam"),T("Set width & height manually")};
PropString pStrPocketCParam(7,arSPocketCParam,T("Pocket-C parameters"),0);
PropDouble pDPCHeight(6,U(dPCHeight),T("Pocket-C; Height"));
PropDouble pDPCWidth(7,U(dPCWidth),T("Pocket-C; Width"));
PropDouble pDPCBraceheight(8,U(dPCBraceheight),T("Pocket-C; Braceheight"));
if(pStrPocketCParam == T("Set width & height based on beam")){
  pDPCHeight.set(dPCHeight);
  pDPCWidth.set(dPCWidth);
//  pDPCBraceheight.set(dPCBraceheight);
}
String strA = pDPCHeight;
String strB = pDPCWidth;
String strC = pDPCBraceheight;
elPC.setSpecial("POCKETC",pntsVer[0]-elPC.dBeamWidth()/2*bm.vecX()*cos(angle),strA,strB,strC);

// ***
// Place Special Pocket C (POCKETC)
// ***

// ***
// Subtract from solid
//
// 
// ***
Body bdPocket(plPocket, U(1000)*csEl.vecZ(),0);
//bdPocket.vis();
SolidSubtract soSuPocket(bdPocket,_kSubtract);
elPC.addTool(soSuPocket);

if(strMill == T("Apply milling")){
  Body bdFront(plFront,U(1000)*csEl.vecZ(),0);
 // bdFront.vis();
  SolidSubtract soSuFront(bdFront,_kSubtract);
  for(int i=0;i<shElFront.length();i++) {
    shElFront[i].addTool(soSuFront);
  }
 
  Body bdBack(plBack,U(1000)*csEl.vecZ(),0);
 // bdBack.vis();
  SolidSubtract soSuBack(bdBack,_kSubtract);
  for(int i=0;i<shElBack.length();i++) {
    shElBack[i].addTool(soSuBack);
  }

  if (_Beam.length()>0) {
    ElemMill elMill1(1,plFront,0,nToolingIndex,nSide,nTurn,nOShoot);
    elMill1.setVacuum(nVacuum);
    elPC.addTool(elMill1);

    ElemMill elMill2(-1,plBack,0,nToolingIndex,nSide,nTurn,nOShoot);
    elMill2.setVacuum(nVacuum);
    elPC.addTool(elMill2);
  }
  else { // This is used to make the TSL visible in the drawing when the milling is not applied.
    Display dp(-1);
    // In viewports polyline is only visible in zone 1, or -1
    dp.elemZone(elPC,1,'E');
    dp.draw(plFront);
    dp.elemZone(elPC,-1,'E');
    dp.draw(plBack);
  }
}
else { // This is used to make the TSL visible in the drawing when the milling is not applied.
    Display dp(-1);
    // In viewports polyline is only visible in zone 1, or -1
    dp.elemZone(elPC,1,'E');
    dp.draw(plFront);
    dp.elemZone(elPC,-1,'E');
    dp.draw(plBack);
  }
// ***
// Subtract from solid
// ***

// ***
// Place Special Pointload (BALK)
//
// Calculate number of beams that shall be used in the pointload,
// based on the width of the pocket.
// Point load uses the number of studs used directly under the beam
// and not the supporting studs at the sides of the pocket.
// The width of the beams used in the pointload is equal to the width of the
// beams used in the element ( elPL.dBeamHeight() )
// ***
double dPLNrOfB;
if( (pDPCWidth/elPC.dBeamHeight())>int(pDPCWidth/elPC.dBeamHeight()) ){
  // Calculate number of studs
  dPLNrOfB = int(pDPCWidth/elPC.dBeamHeight())+ 1;
}
else{
  // Calculate number of studs
  dPLNrOfB = pDPCWidth/elPC.dBeamHeight();
}

Display dp2(3);
dp2.dimStyle(sDimStyle);
dp2.showInDispRep(sDispRep);
	
for(int i =0; i<_Element.length(); i++){
  // element already contains a pocket, pick next one.
 
  Element elPL = _Element[i];
  // Set the width of the beams used in the pointload.
  double dPLBmWidth = elPL.dBeamHeight();
  String sA = dPLNrOfB;
  String sB = dPLBmWidth;
  // add pointload to the element.
  
	

	PLine plDisplay(vy);
	double dPLBmHeight = elPL.dBeamWidth();
	Point3d ptDraw=_Pt0;
	ptDraw = ptDraw.projectPoint(Plane(elPL.ptOrg(), vy),0);
	//Point3d ptDisplay=ptDraw-vz*(dPLBmHeight*0.5)+vx*((dPLBmWidth)*dPLNrOfB)*0.5;
	Point3d ptDisplay=ptDraw-vz*(dPLBmHeight);
	ptDraw=ptDraw-vz*(dPLBmHeight*0.5)-vx*(dPLBmWidth*dPLNrOfB)*0.5;
	plDisplay.addVertex(ptDraw-vz*(dPLBmHeight*0.5));
	plDisplay.addVertex(ptDraw-vz*(dPLBmHeight*0.5)+vx*(dPLBmWidth)*dPLNrOfB);
	plDisplay.addVertex(ptDraw+vz*(dPLBmHeight*0.5)+vx*(dPLBmWidth)*dPLNrOfB);
	plDisplay.addVertex(ptDraw+vz*(dPLBmHeight*0.5));
	plDisplay.close();
	
	PLine plDisplay2(vy);
	plDisplay2.addVertex(ptDraw-vz*(dPLBmHeight*0.5));
	plDisplay2.addVertex(ptDraw+vz*(dPLBmHeight*0.5)+vx*(dPLBmWidth)*dPLNrOfB);
	
	PLine plDisplay3(vy);
	plDisplay3.addVertex(ptDraw+vz*(dPLBmHeight*0.5));
	plDisplay3.addVertex(ptDraw-vz*(dPLBmHeight*0.5)+vx*(dPLBmWidth)*dPLNrOfB);
	//plDisplay.addVertex(_Pt0+vx*(dBmW)*nNrOfBms);
	
	dp2.draw("PL "+dPLNrOfB, ptDisplay, elPL.vecX(), elPL.vecY(), 0, 1.2, _kDevice);
	
	dp2.draw(plDisplay);
	dp2.draw(plDisplay2);
	dp2.draw(plDisplay3);
	
// ***
// Place Special Pointload (BALK)
// ***


	if (i==indexElPC) continue;
		elPL.setSpecial("BALK",elPL.ptOrg()+csEl.vecX().dotProduct(pntsVer[0]-elPL.ptOrg())*csEl.vecX()-elPL.dBeamWidth()/2*bm.vecX()*cos(angle),sA,sB);
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
M"`&3`6@#`1$``A$!`Q$!_]H`#`,!``(1`Q$`/P"E0`4`%`!0`4`%`!0`4`%`
M!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`#MC?
MW3^5*Z'9@R,O44)I@U8;3$%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!
M0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`*`3T&:`%",?X3^-*Z'9CA
M$Y]!2YD/E8HA;N1BCF0<HHA&>6I<P^440KGN:7,PY4+Y:>GZT78[(=M']T?E
M_P#6I7"P;AZC\Z+!<;YB_P![_/Y4^5A=!(<QGGJ*%N#V*]:&84`%`!0`4`%`
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
8Y$=42%`!0`4`%`!0`4`%`!0`4`%``/_9
`









#End
