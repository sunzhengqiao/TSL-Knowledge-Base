#Version 8
#BeginDescription
Displays cummulus and/or delta dimensions of sheeting of wall on paper space
v2.6: 21.jul.2012: David Rueda (dr@hsb-cad.com)
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 2
#MinorVersion 6
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
* v2.6: 21.jul.2012: David Rueda (dr@hsb-cad.com)
	- Description added
	- Copyright added
Verison 2.5 Unlocked offset
Version 2.4 revised for when bottom plate is sloped
Veriosn 2.3 Can add a set of Ids to use
Version 2.2 Revised for angled bottom plates
Version 2.1 Added a special chekc for Normerica (end studs)
Version 2.0 Added 214 to the dimline
Version 1.1 Added the hsbId 26,25 to the dim line
KR:14-02-2006: Version 1.0 To dimmention bottom of wall
*
*/

String arHsbId[] = {"131","133","2550","2500","90","88","","95","96","89","87","82","81","76","75","18","24","130","5000","4113","66","67","68","69","74","88","90","73","82","81","85","84","95","96","80","79"};//these timber ids will not appear in the dim lineType
/////



Unit(1,"mm"); // script uses mm

String arDir[]={"Horizontal","Vertical"};
PropString strDir(0,arDir,"Direction");

String arSide[]={"Left","Center","Right", "Left and right"};
int arISide[]={_kLeft, _kCenter, _kRight, _kLeftAndRight};
PropString strSide(1,arSide,"Side of beams/sheets");
int nSide = arISide[arSide.find(strSide,0)];

String arAllZones[]={"Use zone index","All"};
PropString strAllZones(2,arAllZones,"Zones to use");

int arZone[]={-5,-4,-3,-2,-1,0,1,2,3,4,5};
PropInt nZone(0,arZone,"Zone index",5); // index 5 is default


String arTextDir[]={"None","Parallel","Perpendicular"};
int arITextDir[]={_kDimNone,_kDimPar, _kDimPerp};

PropString strTextDirD(3,arTextDir,"Delta text direction");
int nTextDirD = arITextDir[arTextDir.find(strTextDirD,0)];

PropString strTextDirC(4,arTextDir,"Cumm text direction",1);
int nTextDirC = arITextDir[arTextDir.find(strTextDirC,1)];
PropString sDim (5,_DimStyles,"DimStyle");

PropDouble dOff (0,U(304.8),"Offset from Wall");
//dOff.set(U(304.8));
//dOff.setReadOnly(TRUE);

String arYN[]={"Yes","No"};

//PropString strLR(6,arYN,"Do Normerica check for end studs");

PropString arIdsToShow(7,"","ID's to show 214;120;114...");


String arIdFilter[0];
//Break up the String
String strToBreak=arIdsToShow+";";
int nGo=1,nIncrease=0;
int iSafe = 0 ;

while(nGo)
{
	iSafe++ ;
	if ( iSafe > 1000 ) reportError( "More than 1000 loops" ) ;
	
	String strTok=strToBreak.token(nIncrease,";");
	strTok.makeUpper();strTok.trimLeft();strTok.trimRight();
	
	if(strTok.length()>1)arIdFilter.append(strTok);
	else nGo=0;
	
	nIncrease++;
}







if (_bOnInsert) {
  
  reportMessage("\nAfter inserting you can change the OPM value to set the direction, and the zone.");
  // _Pt0 = getPoint(); // select point
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
int nZoneIndex = vp.activeZoneIndex();
double dSc=dOff*vp.dScale();
double dScale = ps2ms.scale();

Display dp(-1); // use color
dp.dimStyle(sDim,dScale); // dimstyle was adjusted for display in paper space, sets textHeight

if (_bOnDebug) {
// draw the scriptname at insert point
dp.draw(scriptName() ,_Pt0,_XW,_YW,1,1);
}


DimLine lnPs; // dimline in PS (Paper Space)
Vector3d vecDimDir; 
Point3d ptRef=el.ptOrg();
Vector3d vxRef=_XW,vyRef=_YW;
ptRef.transformBy(ms2ps);
//vxRef.transformBy(ms2ps);
//vyRef.transformBy(ms2ps);

if (strDir=="Horizontal") {
	_Pt0=ptRef-dOff*vyRef;
  lnPs = DimLine(_Pt0, _XW, _YW );
  vecDimDir = _XW;
}
else {
	_Pt0=ptRef-dOff*vxRef;
  lnPs = DimLine(_Pt0, _YW, -_XW );
  vecDimDir = _YW;
}
 
DimLine lnMs = lnPs; lnMs.transformBy(ps2ms); // dimline in MS (Model Space)
Vector3d vecDDMs = vecDimDir; vecDDMs.transformBy(ps2ms);
vecDDMs.normalize();
Point3d pntsMs[0]; // define array of points in MS
Point3d arPtAddAfter[0];//to be added to pntsMs latter

Point3d arPtNoDim[0];

Beam arBeams[] = el.beam(); // collect all beams

TslInst arTsl[]=el.tslInst();
for (int i=0; i<arTsl.length(); i++) {
	Map mp=arTsl[i].map();
	if(mp.hasDouble("PocketWidth")){
		Point3d pt=mp.getPoint3d("PocketLocation");
		double dPkW=mp.getDouble("PocketWidth");
		arPtAddAfter.append(pt-0.5*dPkW*el.vecX());
		arPtAddAfter.append(pt+0.5*dPkW*el.vecX());
		dPkW+=U(76.2);
		arPtNoDim.append(pt-0.5*dPkW*el.vecX());
		arPtNoDim.append(pt+0.5*dPkW*el.vecX());
		
	}
}

/*
// find out the origin point for the dimensioning. 
// For that, take the timber perpendicular to the dimline, in most negative direction
Beam arRef[] = vecDDMs.filterBeamsPerpendicularSort(arBeams);
arRef.setLength(1); // reduce the list to the first only
pntsMs.append(lnMs.collectDimPoints(arRef,_kLeft));
// pntsMs.append(el.ptOrg()); // append origin of element as reference point
*/
Point3d arPtCheckEndStuds[0];
Point3d arPtBottom[0];
Point3d arPtAll[0];

Point3d arPtBd[0];
Beam arBmOnlyById[0];
int bIsSloped=0;

for (int i=0; i<arBeams.length(); i++) {
	arPtAll.append(arBeams[i].realBody().allVertices());
	if (arBeams[i].type()==_kSFBottomPlate){
		arPtBottom.append(arBeams[i].realBody().allVertices());
		if(!arBeams[i].vecX().isParallelTo(el.vecX()))bIsSloped=1;
		//pntsMs.append(arBeams[i].ptCen()- 0.5*arBeams[i].dL()*arBeams[i].vecX());
		//pntsMs.append(arBeams[i].ptCen()+ 0.5*arBeams[i].dL()*arBeams[i].vecX());
		arPtCheckEndStuds.append(arBeams[i].ptCen()- 0.5*arBeams[i].dL()*arBeams[i].vecX());
		arPtCheckEndStuds.append(arBeams[i].ptCen()+ 0.5*arBeams[i].dL()*arBeams[i].vecX());
	}
	String strCode=arBeams[i].beamCode().token(0);
	strCode.makeUpper();
	if(strCode!="A")arPtBd.append(arBeams[i].realBody().extremeVertices(vecDDMs));
	
	if(arIdFilter.length()>0){
		if(arIdFilter.find(arBeams[i].hsbId())>-1)arBmOnlyById.append(arBeams[i]);
	}
}

arPtAll=Line(el.ptOrg(),el.vecX()).orderPoints(arPtAll);
Point3d arPtBottomSort[]=Line(el.ptOrg(),el.vecX()).orderPoints(arPtBottom);
if(arPtAll.length()>0){//if(bIsSloped && arPtAll.length()>0){
	//pntsMs.append(arPtAll[0]);
	//pntsMs.append(arPtAll[arPtAll.length()-1]);
}
if(arPtBottomSort.length()>0){
	//pntsMs.append(arPtBottomSort[0]);
	//pntsMs.append(arPtBottomSort[arPtBottomSort.length()-1]);
}

if (strAllZones=="All") {
    GenBeam arGBeams[] = el.genBeam(); // collect all 
    pntsMs.append(lnMs.collectDimPoints(arGBeams,nSide));
}
else {
  if (nZone==0) { // we only take the beams
    Beam arBmFl[0];
    for (int b=0; b<arBeams.length(); b++) {
     	 String strId = arBeams[b].name("hsbId");
      	if (arHsbId.find(strId)==-1) {
        		arBmFl.append(arBeams[b]);
      	}
	    }
    pntsMs.append(lnMs.collectDimPoints(arBmFl,nSide));
	if(strDir=="Horizontal"){
	Opening opAll[]=el.opening();
	for (int i=0; i<opAll.length(); i++) {
		OpeningSF opSF=(OpeningSF)opAll[i];
		if(!opSF.bIsValid())continue;
		CoordSys csOp=opSF.coordSys();
		
		double dW=opSF.width()+opSF.dGapSide();
		double dGS=+opSF.dGapSide();
		
		Point3d ptLeft = csOp.ptOrg()-csOp.vecX()*dGS;
		arPtAddAfter.append(ptLeft);
		Point3d ptRight = csOp.ptOrg()+csOp.vecX()*dW;
		arPtAddAfter.append(ptRight);
		
		arPtNoDim.append(ptLeft-U(38.3)*vecDDMs);
		arPtNoDim.append(ptLeft+U(38.3)*vecDDMs);
		arPtNoDim.append(ptRight-U(38.3)*vecDDMs);
		arPtNoDim.append(ptRight+U(38.3)*vecDDMs);
		
		
	}		
	}
	
  }
  else { // take the sheeting from a zone
    Sheet arSheets[] = el.sheet(nZone); // collect all sheet from the correct zone element 
    pntsMs.append(lnMs.collectDimPoints(arSheets,nSide));
  }
}

//order points

Line ln(lnMs.ptOrg(), vecDDMs);



if(arIdFilter.length()>0){
	pntsMs.setLength(0);
	pntsMs.append(lnMs.collectDimPoints(arBmOnlyById,nSide));
	
	arPtBd=ln.orderPoints(arPtBd);
	if(arPtBd.length()>0){
		pntsMs.append(arPtBd[0]);
		pntsMs.append(arPtBd[arPtBd.length()-1]);
	}
}
	
	
pntsMs = ln.orderPoints(pntsMs);
//add no dim areas
if(pntsMs.length()>2){
	//start
	arPtNoDim.append(pntsMs[0]);
	arPtNoDim.append(pntsMs[0]+U(38.3)*vecDDMs);
	//end
	arPtNoDim.append(pntsMs[pntsMs.length()-1]);
	arPtNoDim.append(pntsMs[pntsMs.length()-1]-U(38.3)*vecDDMs);
}
	

//remove points from no dim area
for (int i=0; i<arPtNoDim.length()-1; i+=2) {
	Point3d pt1=arPtNoDim[i],pt2=arPtNoDim[i+1];
	for (int j=pntsMs.length()-2; j>0; j--) {
	double d1=el.vecX().dotProduct(pt1-pntsMs[j]),d2=el.vecX().dotProduct(pt2-pntsMs[j]);
		if( d1*d2 <0)pntsMs.removeAt(j);
	}
}
	
pntsMs.append(arPtAddAfter);
pntsMs = ln.orderPoints(pntsMs);






Dim dim(lnMs,pntsMs,"<>","<>", nTextDirD,nTextDirC); // def in MS
dim.setDeltaOnTop(1);
dim.transformBy(ms2ps); // transfrom the dim from MS to PS
dp.draw(dim); 


























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
M`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%
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
IH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H``_]D*
`





















#End
