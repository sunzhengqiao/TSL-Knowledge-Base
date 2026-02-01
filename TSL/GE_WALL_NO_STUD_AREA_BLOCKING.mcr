#Version 8
#BeginDescription
Creates left and right beams and a NO STUD location between these new beams

V1.5_18September2018_Added option to not create edge studs
v1.4: 24.jul.2012: David Rueda (dr@hsb-cad.com)
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 5
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
* v1.4: 24.jul.2012: David Rueda (dr@hsb-cad.com)
	- Description added
	- Thumbnail added
	- Copyright added
	V1.3_RL_Sept 22 2011__Revised beam types
	V1.2_RL_June 24 2010_Can be inserted on a wall with no hsbData
	V1.1_RL_April 1 2010_Added bOnCreated
	Version 1.0 Creates a No Stud Space. Will also place a stud left and right of that location.
*
*/

Unit(1,"inch");

double dIconSize=U(.75);
double dBaseLnOff=0.25*dIconSize;
double dWallOffset=U(4);

////////////////////////////////////////////////////
//Blocking choice list
String arName[0];
String arMat[0];
double arDy[0];
double arDz[0];

arName.append("Stud Size");arMat.append("SPF");arDy.append(U(3.5));arDz.append(U(1.5));
arName.append("2x3");arMat.append("SPF");arDy.append(U(2.5));arDz.append(U(1.5));
arName.append("2x4");arMat.append("SPF");arDy.append(U(3.5));arDz.append(U(1.5));
arName.append("2x6");arMat.append("SPF");arDy.append(U(5.5));arDz.append(U(1.5));
arName.append("2x8");arMat.append("SPF");arDy.append(U(7.25));arDz.append(U(1.5));
arName.append("2x10");arMat.append("SPF");arDy.append(U(9.25));arDz.append(U(1.5));
arName.append("2x12");arMat.append("SPF");arDy.append(U(11.25));arDz.append(U(1.5));



///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
//Set some Properties

int strProp=0,nProp=0,dProp=0;
String arYN[]={"Yes","No"};


//Start Properties
PropString strEmpty0(strProp,"- - - - - - - - - - - - - - - -",T("NO STUD RANGE PROPERTIES"));strProp++;
strEmpty0.setReadOnly(true);

//Specify heights
PropDouble dVentW(dProp,U(14.5), T("No Stud Range Width"));dProp++;
PropString strHatch(strProp,_HatchPatterns,T("Hatch pattern"),_HatchPatterns.find("ESCHER"));strProp++;
PropDouble dHScale(dProp,U(2),T("Hatch Scale"));dProp++;
PropInt dHAngle(nProp,U(0),T("Hatch Angle"));nProp++;

PropString strEmpty01(strProp,"- - - - - - - - - - - - - - - -",T("BLOCK PROPERTIES"));strProp++;
strEmpty01.setReadOnly(true);


PropString strType1(strProp,arName,T("  Blocking 1"),1);strProp++;
PropString strType2(strProp,arName,T("  Blocking 2"),1);strProp++;
PropString strType3(strProp,arName,T("  Blocking 3"),1);strProp++;
PropString strType4(strProp,arName,T("  Blocking 4"),1);strProp++;

PropDouble dMinLgt(dProp,U(3),T("  Minimum block length"));dProp++;

PropString strEmpty1(strProp,"- - - - - - - - - - - - - - - -",T("BLOCK ELEVATION (0 will not place block)"));strProp++;
strEmpty1.setReadOnly(true);
String arOrientation[]={T("Upright"),T("Flat")};

PropDouble dElev1(dProp,U(36),T("  Elevation of block 1"));dProp++;
PropString strOrient1(strProp,arOrientation,T("  Orientation 1"),0);strProp++;

PropDouble dElev2(dProp,U(84),T("  Elevation of block 2"));dProp++;
PropString strOrient2(strProp,arOrientation,T("  Orientation 2"),0);strProp++;

PropDouble dElev3(dProp,U(0),T("  Elevation of block 3"));dProp++;
PropString strOrient3(strProp,arOrientation,T("  Orientation 3"),0);strProp++;

PropDouble dElev4(dProp,U(0),T("  Elevation of block 4"));dProp++;
PropString strOrient4(strProp,arOrientation,T("  Orientation 4"),0);strProp++;

PropString psDoEdgeStuds(strProp++, arYN, " Create Edge Stud", 1);
int bCreateEdgeStuds = psDoEdgeStuds == arYN[0];

if(_bOnInsert){
	if (insertCycleCount()>1) { eraseInstance(); return; }
	//Select an element
	_Entity.append(getElement(T("\nSelect a wall to place no framing area")));
	_Pt0 = getPoint(T("\nSelect the Mid-Point for the no framing area"));
	//Return to drawing. _bOnInsert is set to FALSE
	_PtG.append(getPoint(T("\nSelect Point near Blocking Side")));
	
	showDialog();
}

//Check if there are elements selected. If not erase instance and return to drawing.
if(_Entity.length()==0){eraseInstance(); return;}
Entity entWall=_Entity[0];
ElementWall el=(ElementWall)entWall;
Wall w=(Wall)entWall;
if( !w.bIsValid() ){eraseInstance(); return;}

//autoprops
Map mpAutoProps=entWall.getAutoPropertyMap();


//Create Context menu
String strCreateBlocks=T("ReInsert Component");

addRecalcTrigger( _kContext,strCreateBlocks);



CoordSys csEl = w.coordSys();
double dElW=w.instanceWidth();
double dElH=w.baseHeight();

if(el.bIsValid()){
	csEl=el.coordSys();
	dElW=el.dBeamWidth();
}
else if(mpAutoProps.hasDouble("Width"))dElW=mpAutoProps.getDouble("Width");

Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();


Plane plEl(csEl.ptOrg()-dElW/2*vz,vz);

Point3d pt0New=_Pt0.projectPoint(plEl,0);
_Pt0=pt0New.projectPoint(Plane(csEl.ptOrg(),vy),0);







String strNewBlkId="412";
Point3d ptBlockRef = _Pt0-dElW/2*csEl.vecZ();

Point3d ptSide1=_Pt0-(dElW/2+U(1))*csEl.vecZ(),ptSide2=_Pt0+(dElW/2+U(1))*csEl.vecZ();
Plane pn1(ptSide1,csEl.vecZ()),pn2(ptSide2,csEl.vecZ());

if(abs(csEl.vecZ().dotProduct(_PtG[0]-ptSide1)) < abs(csEl.vecZ().dotProduct(_PtG[0]-ptSide2))){
	_PtG[0]=_PtG[0].projectPoint(pn1,U(0));
}
else{
	_PtG[0]=_PtG[0].projectPoint(pn2,U(0));
	vz= -csEl.vecZ();
	ptBlockRef =_Pt0+dElW/2*csEl.vecZ();
	strNewBlkId="413";
}	
_PtG[0]=_PtG[0].projectPoint(Plane(_Pt0,vx),U(0));


Point3d ptS1,ptS2,ptE1,ptE2;
ptS1=_Pt0-vx*0.5*(dVentW+U(3));
ptS2=_Pt0-vx*((0.5*dVentW)+U(0.75));
ptE1=_Pt0+vx*0.5*(dVentW+U(3));
ptE2=_Pt0+vx*(0.5*(dVentW)+U(0.75));


if(_bOnDebug){
	ptS1.vis(7);
	ptS2.vis(2);
	ptE1.vis(3);
	ptE2.vis(4);
}





//Display
Display dp(-1);
dp.addViewDirection(_ZW);
PLine pl;pl.createRectangle(LineSeg((ptS1-dElW/2*vz+vx*U(1.5)),(ptE1+dElW/2*vz-vx*U(1.5))),vx,vz);
dp.draw(pl);
PlaneProfile ppH(pl);

Hatch h(strHatch,dHScale);
h.setAngle(dHAngle);

dp.draw(ppH,h);

assignToLayer(w.layerName());



////////////////////////////////////////////////////////////////////////
//If not a valid element STOP HERE
if(!el.bIsValid())return;

assignToElementGroup(el,TRUE,0,'E');
//No stud range
el.setRangeNoDistributionStud(ptS2,ptE2);
//set Proper stud width
arDy[0]=el.dBeamWidth();

//Get the list of blocks
Point3d arPtLine[0];
String arBlkNames[0];
String arBlkMat[0];
String arHsbId[0];
double arBlkY[0];
double arBlkZ[0];

if(dElev1>U(0)){
	int nType=arName.find(strType1);
	arBlkNames.append(arName[nType]);
	arBlkMat.append(arMat[nType]);
	
	if(strOrient1==arOrientation[0]){
		arHsbId.append(strNewBlkId);
		
		arBlkY.append(arDy[nType]);
		arBlkZ.append(arDz[nType]);
		
		Point3d ptAdd=ptBlockRef + vz*arDz[nType]/2 + dElev1*el.vecY();
		
		arPtLine.append(ptAdd);
	}
	else{
		arHsbId.append("12");
		
		arBlkZ.append(arDy[nType]);
		arBlkY.append(arDz[nType]);
		
		Point3d ptAdd=ptBlockRef + vz*arDy[nType]/2 + dElev1*el.vecY();
		
		arPtLine.append(ptAdd);
	}
}
if(dElev2>U(0)){
	int nType=arName.find(strType2);
	arBlkNames.append(arName[nType]);
	arBlkMat.append(arMat[nType]);
	
	if(strOrient2==arOrientation[0]){
		arHsbId.append(strNewBlkId);
		
		arBlkY.append(arDy[nType]);
		arBlkZ.append(arDz[nType]);
		
		Point3d ptAdd=ptBlockRef + vz*arDz[nType]/2 + dElev2*el.vecY();
		
		arPtLine.append(ptAdd);
	}
	else{
		arHsbId.append("12");
		
		arBlkZ.append(arDy[nType]);
		arBlkY.append(arDz[nType]);
		
		Point3d ptAdd=ptBlockRef + vz*arDy[nType]/2 + dElev2*el.vecY();
		
		arPtLine.append(ptAdd);
	}
}
if(dElev3>U(0)){
	int nType=arName.find(strType3);
	arBlkNames.append(arName[nType]);
	arBlkMat.append(arMat[nType]);
	
	if(strOrient3==arOrientation[0]){
		arHsbId.append(strNewBlkId);
		
		arBlkY.append(arDy[nType]);
		arBlkZ.append(arDz[nType]);
		
		Point3d ptAdd=ptBlockRef + vz*arDz[nType]/2 + dElev3*el.vecY();
		
		arPtLine.append(ptAdd);
	}
	else{
		arHsbId.append("12");
		
		arBlkZ.append(arDy[nType]);
		arBlkY.append(arDz[nType]);
		
		Point3d ptAdd=ptBlockRef + vz*arDy[nType]/2 + dElev3*el.vecY();
		
		arPtLine.append(ptAdd);
	}
}	
if(dElev4>U(0)){
	int nType=arName.find(strType4);
	arBlkNames.append(arName[nType]);
	arBlkMat.append(arMat[nType]);
	
	if(strOrient4==arOrientation[0]){
		arHsbId.append(strNewBlkId);
		
		arBlkY.append(arDy[nType]);
		arBlkZ.append(arDz[nType]);
		
		Point3d ptAdd=ptBlockRef + vz*arDz[nType]/2 + dElev4*el.vecY();
		
		arPtLine.append(ptAdd);
	}
	else{
		arHsbId.append("12");
		
		arBlkZ.append(arDy[nType]);
		arBlkY.append(arDz[nType]);
		
		Point3d ptAdd=ptBlockRef + vz*arDy[nType]/2 + dElev4*el.vecY();
		
		arPtLine.append(ptAdd);
	}
}

//Display blocking side if necessary
if(arPtLine.length()>0){
	PLine plSide(_PtG[0]+el.vecX()*dVentW/2+U(1)*vz, _PtG[0],_PtG[0]-el.vecX()*dVentW/2+U(1)*vz);
	dp.draw(plSide);
}





	

if(_bOnElementConstructed || _bOnInsert || _kExecuteKey==strCreateBlocks || _bOnDbCreated ){

	Body bd1(ptS2,(ptS2+el.vecY()*3*dElH),U(0.75));
	Body bd2(ptE2,(ptE2+el.vecY()*3*dElH),U(0.75));
	Body bdCen(_Pt0,_Pt0+el.vecY()*3*dElH,dVentW/2+U(0.75));	
	
	Beam arBm[]=el.beam();
	Beam arBmV[]=el.vecY().filterBeamsParallel(arBm);
	if(arBm.length()==0)return;

	//Count the amount of panhands
	int nPanHandCount=0;
	for(int i=0; i<arBm.length(); i++) {
		Entity ent=arBm[i].panhand();
		if(ent.bIsValid())nPanHandCount++;
	}
	if(arBm.length()-nPanHandCount<1)return;

	//Start stud cleanup
	for(int i=0;i<arBmV.length();i++){
		Body bdStud=arBmV[i].envelopeBody();
		Point3d arPtLR[]=bdStud.extremeVertices(el.vecX());
		
		if(bdStud.hasIntersection(bdCen)){
			arBmV[i].dbErase();
			reportMessage("\n"+scriptName() +" deleted a stud on wall " + el.number() );
			continue;
		}
		else if(bdStud.hasIntersection(bd1)){
			double dMove=abs(el.vecX().dotProduct(ptS1-arPtLR[1]));
			arBmV[i].transformBy(-el.vecX()*dMove);
			reportMessage("\n"+scriptName() +" moved a stud left by " + dMove + " on wall " + el.number() );
			continue;
		}
		else if(bdStud.hasIntersection(bd2)){
			double dMove=abs(el.vecX().dotProduct(ptE1-arPtLR[0]));
			arBmV[i].transformBy(el.vecX()*dMove);
			reportMessage("\n"+scriptName() +" moved a stud right by " + dMove + " on wall " + el.number() );
			continue;
		}
	}
			
	
	//Create new beams
	if(bCreateEdgeStuds)
	{ 
		Beam arBmNew[2];
		arBmNew[0].dbCreate(ptS2,el.vecY(),el.vecX(),el.vecZ(),U(16),U(1.5),dElW,1,0,0);
		arBmNew[0].setHsbId("114");
		arBmNew[0].setName("Stud");
		arBmNew[0].setType(_kStud);
		arBmNew[0].setColor(2);
		arBmNew[0].assignToElementGroup(el,TRUE,0,'Z');
		
		arBmNew[1].dbCreate(ptE2,el.vecY(),el.vecX(),el.vecZ(),U(16),U(1.5),dElW,1,0,0);
		arBmNew[1].setHsbId("114");
		arBmNew[1].setName("Stud");
		arBmNew[1].setType(_kStud);
		arBmNew[1].setColor(2);
		arBmNew[1].assignToElementGroup(el,TRUE,0,'Z');
		
		//remove None vertical beams
		for(int r=arBm.length()-1;r>-1;r--)	if(arBm[r].vecX().isParallelTo(el.vecY()))arBm.removeAt(r);
	
		for (int b=0; b<arBmNew.length(); b++) {
			for (int nSide=0; nSide<2; nSide++) { // loop for positive and negative side
				
				Beam bm = arBmNew[b];
				Point3d ptBm = bm.ptCen();
				Vector3d vecBm = bm.vecX();
				if (nSide==1) vecBm = -vecBm;
				Beam arBeamHit[] = bm.filterBeamsHalfLineIntersectSort(arBm, ptBm ,vecBm );
				// loop over the hit beams, and find the first top or bottom plate
				for (int h=0; h<arBeamHit.length(); h++) {
					Beam bmHit=arBeamHit[h];
					int nBeamType=arBeamHit[h].type();
					if (nBeamType==_kSFTopPlate || nBeamType==_kSFBottomPlate || nBeamType== _kSFAngledTPLeft || nBeamType== _kSFAngledTPRight) {
						bm.stretchDynamicTo(bmHit);
						break; // out of inner for loop, only stretch to one
					}
				}
			}
		}
	}
			
	for(int i =0;i<arBlkNames.length();i++){

		Beam bm;
		bm.dbCreate(arPtLine[i],el.vecX(),el.vecY(),el.vecZ(),dVentW,arBlkY[i],arBlkZ[i]);
		bm.setMaterial(arBlkMat[i]);
		bm.setName(arBlkNames[i]);
		bm.assignToElementGroup(el,TRUE,0,'Z');
		bm.setHsbId(arHsbId[i]);
		bm.setType(_kSFBlocking);
		bm.setColor(2);
	}
}















#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`$L`9`#`2(``A$!`Q$!_\0`
M'P```04!`0$!`0$```````````$"`P0%!@<("0H+_\0`M1```@$#`P($`P4%
M!`0```%]`0(#``01!1(A,4$&$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*
M%A<8&1HE)B<H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&EJ<W1U
M=G=X>7J#A(6&AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&
MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ>KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!
M`0$!`0````````$"`P0%!@<("0H+_\0`M1$``@$"!`0#!`<%!`0``0)W``$"
M`Q$$!2$Q!A)!40=A<1,B,H$(%$*1H;'!"2,S4O`58G+1"A8D-.$E\1<8&1HF
M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@H.$
MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#W^BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HKR/3[GQ%JT[P6-]>RRJI<C[3M``..
M[>I`K3_LCQK_`,];W&?^?X=/^^O\^_2N98AM746=;PJB[.21Z317FO\`9'C;
M'^LO<XZ?;A_\5_GV[K_9'C;/^MO?_`X?_%4_;2_E8OJ\?YT>DT5Y=>6OB[3[
M1[JZN;V.%,;F^V9QD@#@,3U./\:CTY/%6K6[7%E=WDL08H2+S'/4CEAV(/\`
MA2^L.]N5C^JJU^96/5:*\U_LCQMG_6WO_@</_BJ/[(\;?\];W_P.'_Q7^?>G
M[>7\K%]7C_.CTJBO-O[(\;?\]+WZ?;A_\5_GVK+U&Y\1:3,L-[?WL4C+O&;H
MGCGG@D=C_GFD\0UO%C6%4G921Z[17FW]D>-?^>M[C/\`S_#I_P!]?Y]^E)_9
M'C;'^LO<XZ?;A_\`%?Y]N[]O+^5D_5X_SH]*HKS;^R/&V?\`6WO_`('#_P"*
MI!I'C;_GK>_^!P_^*_S[T>WE_*Q_5X_SH]*HKR""^U^YU8Z9%J%ZUX'=#%]J
M(^9<[ADG'09Z_2M7^R/&V?\`6WO_`('#_P"*I+$-[19$:5.:O&HG\STJBO-?
M[(\;?\];W_P.'_Q7^?>E_LCQM_STO?I]N'_Q7^?:G[>7\K*^KQ_G1Z317FO]
MD>-L?ZV]S_U^K_\`%?Y_6E_LCQK_`,];W&?^?X=/^^O\^_2CV\OY6/ZO'^='
MI-%>:_V1XVQ_K+W..GVX?_%?Y]NZ_P!D>-L_ZV]_\#A_\51[:7\K#ZO'^='I
M-%>:C2/&W_/6]_\``X?_`!7^?>C^R/&W_/2]^GVX?_%?Y]J/;R_E8OJ\?YT>
ME45YK_9'C;/^MO?_``.'_P`51_9'C;_GK>_^!P_^*_S[T>WE_*Q_5X_SH]*H
MKS;^R/&W_/2]^GVX?_%?Y]J3^R/&V/\`6WN?^OU?_BO\_K1[:7\K#ZO'^='I
M5%>0:G?:_HURMO?ZA>PRL@<#[26^4DC/!/H?R[UJ_P!D>-L?ZR]SCI]N'_Q7
M^?;NEB&]HLA4J;;2J)M>9Z517FW]D>-L_P"MO?\`P.'_`,52#2/&W_/6]_\`
M`X?_`!7^?>G[>7\K+^KQ_G1Z517FO]D>-O\`GI>_3[</_BO\^U9LUSXBM]4&
MFRW]XMV65!']J/);&WG..<_A2>(:WBQQPO-M)'KE%>:_V1XV_P">M[_X'#_X
MK_/O2_V1XV_YZ7OT^W#_`.*_S[4_;R_E9/U>/\Z/2:*\U_LCQMC_`%M[G_K]
M7_XK_/ZTR?3O&-M;R3RSWJ11J6=OMH.U1R3][M_G/2CV[_E8_J\?YT>FT5Y-
MIK^)]7$OV&\O93%C>/M97&<^I'H?_K=]#^R/&V?];>_^!P_^*I*NWJHL;PJ3
MLY)'I-%>:_V1XVZ>;>]/^?Y?;_:^O]:K6EYKEGXGL[&^OKM7%U&KQM<%@03G
M'7G(QGZ_7#]NUO%B6&3VDF>IT445T'*%%%%`!1110`4444`>:_#W/]OS;LY^
MR-]/OKW_`,YQ7I5>:?#S']O38Q_QZ,3@_P"VH'Z#K[=J]+KGPW\,ZL7_`!`H
MHHKH.4P?&?\`R*=[G_IGWQ_RT6J/P]_Y`-QSD_:VSS_LK^57O&?'A.]_[9].
MO^L6J'P]S_8-QDY_TD].GW$KG?\`'7H=4?\`=WZG6T445T'*%>:_$+C7X#_T
M[+SC_:?O7I5>:?$+_D/0_P#7JN>>VZ2N?$_PSIPG\5'I=%%%=!S!1110!Y7H
MO_)4Y!Z7MUW]1)_G\/QKU2O*]%_Y*F_3_C\NOKTD_P`_E7JE88?X7ZGFY9\$
M_P#$_P`D%%%%;GI!1110`4444`%%%%`!1110`4444`>6?$O_`)&*W''-FO?G
M[[_Y_"O4Z\K^)?\`R,<(X_X\UR#_`+\G^<?SKU2L*7QR/.PG^\5O5?J%%%%;
MGHA7FFL8_P"%E)SC_2[8$%O9,?RZ?7\?2Z\UU?/_``LI.O%U;?R3U_'\JY\1
M\*]3JPOQ2]#TJBBBN@Y0JAKG'A_4L'!^RR]B?X#V%7ZS]=X\/:D3_P`^LO?'
M\!J9;,J'Q(Y3X<==4XP/W./R;_/^<5W=<)\.?OZIZ_NNW;Y__KUW=9X?^$C7
M$_Q7_70*\TUCCXE(2!_Q]6PSG']S'X\FO2Z\TU?`^)<9Z?Z5;=O9>_Y?I4XC
MX5ZEX7XGZ,]+HHHKH.4****`"BBB@`HHHH`\U^'N?[>G^]_QZ'.>QW+^'Y<?
MG7I5>:?#S_D/S8^8?9&^;_@:]^__`.NO2ZY\-_#.G%_Q`HHHKH.8P?&9QX4O
M#QP8^^/^6BU1^'HQH-P.XNVS_P!\K5_QEG_A%+S!.<Q]/^NBUG_#W`T&X`&!
M]K;M@_=6N=_QUZ'5'_=WZG6T445T'*%>:_$+_D/0'G_CV3'_`'T]>E5YI\0O
M^0_#QS]F3G'3YI.]<^)_AG3A/XJ/2Z***Z#F"BBB@#RO1<_\+2?J?]-NA].)
M./Y_E^->J5Y7HO\`R5.0X`S>W0[_`-UZ]4K##_"_4\W+/@G_`(G^@4445N>D
M%%%%`!1110`4444`%%%%`!1110!Y7\2L_P#"10]P+-3C_@;UZI7E?Q+_`.1C
MM^F?L:_^A/\`X?\`ZZ]4K"E\<CSL)_O%;U7ZA1116YZ(5YKJXS\28^A'VRVS
MSG^%/UZ5Z57FNKC/Q)CX_P"7RVQQ_LI_G_ZU<^(^%>IU87XGZ,]*HHHKH.4*
MH:YSX?U+&?\`CUEZ8S]P^M7ZS]=_Y%[4_P#KTE_]`-3+9E0^)'*?#C[VJ>F8
M?SPW^?\`]5=W7"?#@?/JAQC_`%(Z>S?XUW=9X?\`A(VQ7\5_UT"O-=7R/B4A
M[?:K89QU^YC^OYUZ57FFKX_X69&05)^U6WIP<+Q]<']:G$?"O4K"_%+T9Z71
M1170<H4444`%%%%`!1110!YI\/23X@G)QDVA)XQ_$G3VSGK7I=>:?#S']OSX
M/2U88W9Q\Z_Y_.O2ZY\-_#.K%_Q`HHHKH.4P?&>/^$3O<C/,?;/_`"T6J'P]
M_P"0!<>GVM\8_P!U?Y]?QJ_XS_Y%2\^L?\6/^6BU1^'O_("N<YR;MNHZ_*G]
M/\.U<[_CKT.J/^[OU.LHHHKH.4*\U^(7_(>A_P"O5<\]MTE>E5YK\0_^0]">
M?^/9,>F=SUSXG^&=.$_BH]*HHHKH.8****`/*]$'_%TWX/\`Q^71SCVD_P`_
MYS7JE>5Z*,?%-SC'^F77)/M)_G\*]4K##_"_4\W+/@G_`(G^@4445N>D%%%%
M`!1110`4444`%%%%`!1110!Y7\2\?\)'`.YLUX]MTG^<5ZI7EGQ+S_PD4`[&
MS7^+'\3_`.?P%>IUA2^.1YV#_P!XK>J_4****W/1"O--7&?B5'P,_;+?!V_[
M*?\`UZ]+KS35\'XDIZ"[MLCKV3'T_P`GZ\^(^%>IU87XI>C/2Z***Z#E"L_7
M3CP]J1SC_19>^/X#6A5#7,_V!J6,Y^RR].OW#2ELRH?$CD_AR,/JG'_/'!]O
MGP/YUW=<)\..&U3_`+9'ICLW^%=W66'_`(2-<3_%?]=`KS75\CXE1]?^/NW_
M`"PG^?7\Z]*KS35_^2EICG_2[;/?'RI^7;CZ^M3B/A7J7A?B?HSTNBBBN@Y0
MHHHH`****`"BBB@#S3X>G/B"8%@3]D;';^)/_K?G7I=>:_#S/]O3#YO^/5B<
M^NY?\_G7I5<^&_AG3B_X@4445T',8/C/_D4[WGO'_P"C%JC\/1C0;C`P/M;_
M`/H*U>\9_P#(J7GUC[9_Y:+5#X>C_B0W!`QF[;M_LK7._P".O0Z5_N[]3K:*
M**Z#F"O-/B$/^)_"<<_9DYQT^9^]>EUYI\0O^0]#_P!>JYY[;I.U<^)_AG3A
M/XJ/2Z***Z#F"BBB@#RO1/\`DJ<F/^?VZ!_*3_/X?C7JE>5Z+_R5-^>EY=#K
MTXDX_P`__7KU2L,/\+]3S<L^"?\`B?Z!1116YZ04444`%%%%`!1110`4444`
M%%%%`'E?Q+Y\10CC'V->#_O/7JE>5_$O/_"11=<?8E./^!OS^'/_`-:O5*PI
M?'(\W"?[S6]5^H4445N>D%>:ZQ_R4J/_`*^[<_\`CJ#^O^>*]*KS35_^2E1\
M=;RV.<8_A3_]6?PKGQ'PKU.K"_$_1GI=%%%=!RA5#6P#H&H@@$&UEX(SGY35
M^J&M@-H&H@C(-K*,8SGY34R^%E0^)')?#<'_`(F9.>1#U[_?Z^]=Y7!_#?\`
MYB1QSB')YY^^>_UKO*SP_P##1MBOXK"O--8R?B7%G'%W;A<CV0_GC=^M>EUY
MIJ^/^%EQC)'^EVV03UX3'\OT/XSB/A7J5A?BEZ,]+HHHKH.4****`"BBB@`H
MHHH`\T^'G_(?GZ'_`$1N1_OK^?\`^NO2Z\T^'ISK\Y[FT;@CG[R?CZ]:]+KG
MPW\,ZL7_`!`HHHKH.4P?&?\`R*=[]8^^/^6BU1^'O_("N?7[6V>.OR)_3%7O
M&?\`R*E[UZQ_^C%JA\/>-!N./^7M_P#T%<_KFN=_QUZ'4O\`=WZG6T445T'*
M%>:_$+_D/0]?^/9,>GWGKTJO-/B$/^)_#Q_R[)SC_:?O7/B?X9TX3^*CTNBB
MBN@Y@HHHH`\KT7_DJ;].+RZ'IVD_S_G->J5Y7HO_`"5.0>E[==_42?Y_#\:]
M4K##_"_4\W+/@G_B?Y(****W/2"BBB@`HHHH`****`"BBB@`HHHH`\K^)>/^
M$C@Z9%FO7_??^5>J5Y7\2_\`D8X>G_'FIY_WW[_Y_"O5*PI?'(\W"?[S6]5^
MH4445N>D%>::O_R4E/3[9;9YS_"G]<?SKTNO-=8S_P`+*CXY^UV^,_[J?_7K
MGQ'PKU.K"_$_1GI5%%%=!RA5#7`#X?U($9'V67CU^0U?JAKG_(OZEU_X]9>A
MP?N&IE\+*A\2.3^&^?\`B9\D_P"J^F?GS]/I[5W=<)\..NI].D(R/^!_Y_.N
M[K/#_P`-&V*_BL*\TU@_\7+C^88^UV^<'&.$_7D?@:]+KS75\CXE1]>;NWZ^
MF$_^M[]:G$?"O4K"_$_1GI5%%%=!RA1110`4444`%%%%`'FGP\P=?GP<@6C#
M&[_;7_/YUZ77FGP].?$$^6R?LC>W\2=OR_.O2ZY\-_#.K%_Q`HHHKH.4P?&?
M_(IWO3K'U&?^6BU1^'O_`"`;GC'^EO\`^@K5[QF<>$[P^\??'_+1:H?#T8T&
MY]?M;<^OR)C],5SO^.O0ZE_N[]3K:***Z#E"O-/B%_R'H?\`KU3/TW25Z77F
MOQ"!_MZ`\_\`'LF/3.YZY\3_``SIPG\5'I5%%%=!S!1110!Y7HG_`"5)_:]N
ML_\`?+_X?I^->J5Y7HO_`"5-R<_\?ET!D^TGZ5ZI6&'^%^IYN6?!/_$_T"BB
MBMSTC%\5>'H?$VA36$G$H_>0/N("R`$`GVY(/L3CG!'SS=6LMI=36UQ&$FB=
MDD4$-M8$J0"#SR3T]?I7U!7FGQ1\+-/$/$%E$[RQ`+=)&@Y09Q(3UR/NGK\I
M'0*37)BJ7,N9;H^EX?S+V-3ZO4?NRV\G_P`'\SAO!OB-_#?B"*X:1ELY6VW:
M#[I3/#8`.=NXL,#)Y`(S@_04<D<T22Q.KQNH974Y#`]"#W%?+O*C(.=I`STY
M&.?;C]#Z5V4/CN6'P!+X?`E:[.8(YN"%MR<$$DDD_>4``87&""`3CAZ_(FI;
M'JYUE#Q<X5*7Q-V?IW^7Y#?B#XI/B'6/LMM(W]G6K;$&X%)'!(,HQP01P,D\
M=,$D5R$43SRI%%$SRN=J(BEF)ST`ZD\D8[YZ<D4AQG@8&>@ZCT'UXQ7IGPR\
M(F9UU^_CB:W&?LD9YRZMCS,=!C!`SDYYXP"<DI5JAZ%6I1RO":;+1>;_`.#N
M=IX)\,IX9T-8G4?;;C$MRV!D-CA,CJ%Y[\DL>,XKI***]6,5%61^=5ZTZ]1U
M9O5A1113,CROXE\>(H?>R7OCH[G_`#].U>J5Y7\2_P#D8H>G_'FO7_??_/Y5
MZI6%+XY'FX/_`'FMZK]0HHHK<](*\TU?_DI4?'_+Y;<X_P!E/\__`%^OI=>:
M:Q_R4J/T^UVQ/Y(/YXKGQ'PKU.K"_%+T9Z711170<H5GZ[C_`(1_4LXQ]EEZ
M]/N&M"J&M\:!J/&?]%EX_P"`FIE\+*A\2.3^''75.?\`GEQ_WWS7=UP?PWX.
MI_\`;(=2>F\=?PKO*SP_\-&V*_BO^N@5YIJ__)2TP<_Z7;9[X^5/_K<?7UKT
MNO--7)/Q+BY&1=VX&1[(?SQFIQ'PKU*POQ/T9Z711170<H4444`%%%%`!111
M0!YK\/,_V],/F_X]6SGUW+7I5>:?#S_D/SD8/^B-\P'^VO\`G\Z]+KGPW\,Z
ML7_$"BBBN@Y3!\99_P"$4O,9ZQ]#C_EHM4?A[_R`;GK_`,?;]1_LK5[QI_R*
M=[G'6/J,C_6+5'X>C&@W&!@?:WX]/E6N=_QUZ'4O]W?J=911170<H5YI\0A_
MQ/X>!_Q[)SC_`&I.]>EUYI\0O^0]#_UZIGGMND[5SXG^&=.$_BH]+HHHKH.8
M****`/*]%P/BF_&";RZZ]^)/\_A7JE>5Z+_R5-^@'VVZ'3V?_/X?C7JE88?X
M7ZGFY9\$_P#$_P!`HHHK<](*9+%'/$\4J+)&ZE71QD,#P01W%/IDLL=O"\TT
MB1Q1J7=W8!54<DDGH*!J]]#P'QMX9;PUKLD2#=9SJ9;=L'A<GY,GJ5)`SD\$
M$\FN=S\P)(^\3^H!_#T__7CJ/'7BD^)=;'D-_P`2^U+);[D"DYQN8Y/<KD9Q
MQCC.:Y;'8@]`N#[\_P!._P"/'%>-4Y>=\NQ^HX%UGAH.O\5M?^#Y]S>\(>&I
MO$VLI:XE2TC`:YGC`_=CGCGC+<`=>YY`Q7T'%%'!"D,,:QQ1J%1$&`H'```Z
M"OG?PMX@F\.:]!?IS&Q\NX4@$M&S`N!GH1U[9(';BOH.POK74[&&]LIEFMIE
MW(Z]Q_,'L0>0>#7;@^7E=MSY7B95_:Q<O@MIZ];^?Z?,L4445V'RX4444`>5
M_$O/_"11=<?8E./^!OS^'/\`]:O5*\K^)>/^$C@Z9%FO7_??^5>J5A2^.1YN
M#_WFMZK]0HHHK<](*\TUC_DI<?'_`"]6Q'/;"?Y_"O2Z\TU?_DI:`DX^UVW`
MY[)C/^>V:Y\1\*]3JPOQ/T/2Z***Z#E"J&N#=H&I#&<VLHZ9_@-7ZH:YC_A'
M]2R0!]EER2<?P&E+9E0^)')?#=MQU(Y'(A.`>V'-=Y7"?#@DMJ>3_P`\N,8_
MO\X[?Y]Z[NLL/_#1MBOXK"O--7(_X67&,D?Z7;9!/7A,?Y^OX^EUYIK!_P"+
ME1_,,?:[?IQCA/UY_(U.(^%>I6%^)^C/2Z***Z#E"BBB@`HHHH`****`/-/A
MZ<Z_.<\FU;J,'[R?_7Z__K]+KS3X>$?V_/@\"T88W9Q\Z]O\]Z]+KGPW\,ZL
M7_$"BBBN@Y3!\9\>%+SG',??_IHM4/AZ/^)#<\<F[;G'7Y$Q^F!^%7_&?_(J
M7N,]8^F,_P"L7UJC\/?^0%<_]?;=L?PI7._XZ]#J7^[OU.LHHHKH.4*\U^(6
M?[>@Z_\`'LF/3.YZ]*KS3XA#_B?P\?\`+LG./]J3O7/B?X9TX3^*CTNBBBN@
MY@HHHH`\KT7_`)*F_3/VVZ_D_P#A_P#6[UZI7E>B'_BZ<G(S]LNAT]I*]4K#
M#_"_4\W+/@G_`(G^@4445N>D%>:?%'Q4;>,:!9R,LD@#W;HXP$(/[L]\G@GI
MP1U#$5UGB_Q-#X8T9[C=$UY)\MM#(3\[9`)('.U<Y/3L,C(KY\>22:1I)7=Y
M)&W,SG<Q8GDD]<D]^ISGFN3$UK+D1]-P_EGM9_6:B]U;>;[_`"_/T&=B.IQV
M[<;OYXZ8[>U=G:?#Z]N_!<NMH9&NF_>06D<1R\8X8\X.3@,,9R`,9+#%7P+X
M8_X2;6?WZ;M/M\/<_/@G<#M4=_F([=@WS9QGWRL</04TY2/2SK.)86I&E1^)
M:O\`R^?7_@GRV>O''/'(^B]O\^_2O1/ACXJ:SOET*\D<V]RW^C%W`6)^21SS
MAST&3R!@'<2*'Q&\*#0M4^W64:K87I;")&<0R;>5],-U'3H1T`KBB,Y4]QC!
MZ'(QCU[CKU([5BG*C4]#TY1H9IA--I+[G_FG_5F?4E%<;\/?%8U_2%M;J1?[
M1M5"L&8EY8P`!(<]\\'D\\G&X"NRKU824E='YWB<//#U72J+5!1115&!Y7\2
M_P#D8X>G_'FIY_WW[_Y_"O5*\K^)?'B*'WLE[XZ.Y_S].U>J5A2^.1YN#_WF
MMZK]0HHHK<](*\UUC/\`PLN/J?\`2K;IQQA/SZ&O2J\TU@#_`(65'Q_R]6W!
M'!.$Y_3\ZY\1LO4ZL+\3]&>ET445T'*%4-<S_P`(_J6,Y^RRXQU^X:OU0US'
M_"/ZEDX'V67/./X#4R^%E0^)')_#CKJ8QQ^ZP3_P/C_/K7=UP?PWZZGTS^ZY
M"X!^^/Z5WE9X?^&C;%?Q7_70*\UU?(^)4?7_`(^[?\L)_P#6Z\UZ57FFK_\`
M)2X\<_Z7;_A\J?\`UOU]:G$?"O4K"_$_1GI=%%%=!RA1110`4444`%%%%`'F
MGP].?$$P+9/V1L<X_C3MW[?G7I=>:_#S/]O3#YL?9#G/KN7_`#^=>E5SX;^&
M=.+_`(@4445T',8/C/'_``B=YD`C,?49_P"6BU0^'O\`R`;CC'^EOQ_P%:O^
M,_\`D4[W)'6/K_UT6J/P]_Y`5SD<_:VY]?E3_P#5^%<[_CKT.J/^[OU.LHHH
MKH.4*\T^(?\`R'H?3[*N?IND[5Z77FOQ"S_;T)Y_X]DQQQG<]<^)_AG3A/XJ
M/2J***Z#F"BBB@#RO1"?^%I2>GVVZZ?23K7JE>5Z+_R5-CS_`,?MV/T?_/\`
MG->J5AA_A?J>;EGP3_Q/]`HHHK<](Q]8\+Z/K\T<NIVKW#1KM0&>154=\*K`
M9/<XR<#T&,[_`(5SX4R#_96<>MQ+_P#%5U-%0Z<&[M'3#&8FG%1A4DDNS92T
MO2;#1;,6FG6RP0[BQ4$DECU))Y)]SZ"KM%%4DEHC"<Y3DY2=VRO?65MJ5E-9
MWD*S6\R[71NX_H?<<BN>_P"%<>$QTTK'?BXE],?WO>NIHI.$9;HUI8JO15J4
MW%>3:,+2_!VA:+?+>:=9O!.%*;EN)""OH06P1]?0'L*W:**:BHJR1%6K4JRY
MJDFWYNX4444S,\K^)?\`R,4/3_CS7K_OO_G\J]4KROXEY_X2*+KC[$IQ_P`#
M?G\.?_K5ZI6%+XY'FX3_`'FMZK]0HHHK<](*\TU?CXEH1D?Z5;9(]<)^?45Z
M77FFK_\`)2X^.?M5L1SCLG^?PKGQ&R]3JPOQ/T/2Z***Z#E"J&N?\B_J7_7K
M+_Z`:OU0UL9T#40.OV67_P!!-3+X65#XD<G\.,9U,C_ICR3ST:N[K@_AOUU(
MX(XA')/^V?ZUWE9X?^&C;%?Q6%>::P<_$N+.,_:[<#(]D_,]?UKTNO--7(_X
M67&,D?Z7;9!/7A,?U_7\9Q'PKU*POQ2]&>ET445T'*%%%%`!1110`4444`>:
M?#S_`)#\YX/^B-\P'^VOY_\`ZZ]+KS3X>\Z_.>_V5N".<;D_^OU__7Z77/AO
MX9U8O^(%%%%=!RF#XSR/"EZ1G.8^G_71:H?#T8T&X]/M;8/K\JU?\9\^%+P>
M\?\`Z,6J/P]'_$AN3SS=OQC_`&5__7^-<[_CKT.I?[N_4ZRBBBN@Y0KS3XA#
M_B?PG'/V9.<?[4G?_.*]+KS3XA_\AZ'I_P`>JYY[;I*Y\3_#.G"?Q4>ET445
MT',%%%%`'E>B#_BZ;\'_`(_+HYQ[2?Y_SFO5*\KT48^*;G&/],NN2?:3_/X5
MZI6&'^%^IYN6?!/_`!/]`HHHK<](****`"BBB@`HHHH`****`"BBB@#ROXE_
M\C%#P.+)3W_OO7JE>5_$H?\`%1P\$YLT'`_VW_S_`(5ZI6%+XY'FX/\`WBMZ
MK]0HHHK<](*\TU?_`)*6@.<?:K;ISV3^O\LUZ77FNL9_X67'U/\`I5M_)/\`
M`USXCX5ZG5A?B?H>E4445T'*%9^N_P#(O:GD@#[)+U./X#WK0JAK>?[`U''7
M[++C_ODTI;,J'Q(Y/X<<-J@Z']T<=.N\]*[NN#^&^,ZF`,?ZHXXX!W_Y_.N\
MK+#_`,-&V*_BO^N@5YIK!_XN5&-PQ]KM\X.,<)^O(_`UZ77FNKY'Q*CZ_P#'
MW;]>F,)_];KSUJ<1\*]2L+\3]&>E4445T'*%%%%`!1110`4444`>:?#S!U^?
M!R!:,!\V?XUKTNO-/AZ<^()P6R?LC8[?QIV_+\Z]+KGPW\,ZL7_$"BBBN@Y3
M!\:?\BG>Y(',?4X'^L6J/P]&-"N>,?Z6W_H*?G5_QEG_`(12\P2.8^G_`%T6
ML_X>#_B0W&!P;MNV/X5KG?\`'7H=*_W=^IUM%%%=!S!7FOQ"_P"0]`>?^/9,
M?]]/7I5>:?$(?\3^'CG[,G..GS2=ZY\3_#.G"?Q4>ET445T',%%%%`'E>B\?
M%-^G_'Y=?RD_+_/7K7JE>5Z+_P`E2?\`Z_;O_P!!?_/^<UZI6&'^%^IYN6?!
M/_$_T"BBBMST@HHHH`****`"BBB@`HHHH`****`/*_B6/^*BA./^7-><\#YW
M_P`_A7JE>5_$O_D8X<=?L2G_`,??_P#7^':O5*PI?'(\W"?[S6]5^H4445N>
MD%>::P!_PLI./^7JV[<9PG/Z?F*]+KS35^/B6A&1_I5MDCUPGY]OP]*Y\1LO
M4ZL+\4O1GI=%%%=!RA6?KO\`R+VI?]>LO?'\![UH50UO_D`:CQG_`$67C&?X
M34R^%E0^)')_#@8.IC/_`#R.`N!_'S7=UP?PW&!J7.>(<GU.&[]_\^U=Y6>'
M_AHVQ7\5A7FFK_\`)2X\<_Z7;>^/E3_./<^M>EUYIK&3\2XLXXN[<#CV3\SU
MJ<1\*]2L+\3]&>ET445T'*%%%%`!1110`4444`>:_#S/]O3#YL?9&SGUW)_]
M;I[UZ57FGP\_Y#\^,'-HW(_WU_/_`/77I=<^&_AG3B_X@4445T',8/C,9\)W
MHQGF/MG_`):+5'X>_P#("N3TS=MVQ_"G_P"NKWC/`\)WF<8S'U./^6BU0^'O
M_(!N<CG[6V?^^5KG?\=>AU+_`'=^IUM%%%=!RA7FGQ"_Y#T/_7JF>>VZ3M7I
M=>:_$//]O0'G_CV3''&=SUSXG^&=.$_BH]*HHHKH.8****`/*]$Q_P`+4D&0
M/],NOKTD_P`_YS7JE>5Z+G_A:3]<?;;K]0_^'Z=^M>J5AA_A?J>;EGP3_P`3
M_0****W/2"BBB@`HHHH`****`"BBB@`HHHH`\K^)?_(Q1=<"R0_^1'_S_A7J
ME>5_$O'_``D<'('^AIR?]]_\_P"%>J5A2^.1YN#_`-XK>J_4****W/2"O--8
M_P"2EQ\?\O5L1SCC"?Y]\8[UZ77FFK_\E+0$G'VJVZ<]D_'K_CZUSXCX5ZG5
MA?B?H>ET445T'*%4-<_Y%_4O^O67MG^`U?JAKG_(OZE_UZR]\?P&IE\+*A\2
M.2^&^,ZH1C_EEG_Q_P#SZUWE<)\.#DZH=V1^Z[_[Q_#K7=UGA_X:-L5_%85Y
MIJ^/^%EQC)'^EV^03UX3_#]#^/I=>::P1_PLJ/YAC[7;YYQCA/UY'X&IQ'PK
MU*POQ/T9Z711170<H4444`%%%%`!1110!Y3X-U.STO6);B]G\J-[<H"4)).Y
M2.!D]FZ^GY]Q_P`)GH'_`#_'_OQ)_P#$U1_X5[I/:YOA_P`#3_XFD_X5YI&,
M?:+T=C\Z?_$UR4XUH+E21VU)4*DN9ME__A,]`_Y_CW_Y82?_`!-'_"9Z!G'V
MX]<?ZB3_`.)JC_PKW2-V?/O,>F]/_B:3_A7FD8YN+T]OOIT]/N].:N]?LB.7
M#]V5_$WB?2-0\/7-K:W9>:39M4PN,X<$]0!T!_*JO@[Q!IFDZ3/!>W!BD:=I
M%41NQ*[5]%Z\'W.*T_\`A7NDY_X^+WU/[Q>3ZGY:3_A7NE9S]IO>N?OIU]?N
MU'+6YN>RN6I4%#DN[;E__A,]`SC[<>N/]1)_\31_PF>@'_E^;_OQ)_\`$U0_
MX5YI```GO`.F-R=.<#[OO0?AYI!S_I%[SZNG'K_#5WK]D1RX?NR__P`)GH'_
M`#_-T)X@D[?\!KB/&6I6>JZQ'/92B1%@5"VPK@@N>X'8C':NH/P\T@DGS[SG
M_:3W_P!GWH_X5YI'_/>\'&.&3Z_W:B<:TU9I%TY4*<N9-E__`(3/0,9^W-V_
MY82=_P#@-!\9Z`,_Z<W&?^6$G_Q-4/\`A7FD\DW%YGKG<G7D9^YZ&C_A7FD9
M'[^\P!C&Y/\`XFKO7[(CEP_=FA_PF6@@D?;CP<?ZB3_XFD_X3/0/^?XCZP2?
M_$U0_P"%=Z1@`W%X>"#EDYSUS\GO1_PKW2,Y^T7OK]]/7_=]J+U^R#EP_=G'
MZ9>VUKX^;4YI-EH;JXD\S!^ZX8+QUY)'&._Y=_\`\)IX?_Y_\@C(Q#(<_3Y:
MH#X>Z2.ES>YQC.Y/_B/>E_X5[I/_`#\WW?\`Y:+_`/$U,(UH*R2,*&&PE%-1
M;U=^G^1>/C3P^.M^?^_,G_Q/M0?&GA\=;\_]^)/_`(FJ/_"O=)SQ<WP^DB^W
M^S[4?\*]TG/_`!\7O_?:?_$U5Z_9&W+A^[+Q\:>'QUOS_P!^)/\`XF@^--`'
M6^/_`'XDY_\`':HCX>Z5G/VJ^/.3\Z<_^._A2#X>Z3_S\WWO\Z#//^[1>OV0
M<N'[LOGQIX?'6_/_`'XDY^GR\T'QIX?'6_/_`'XD_P#B:H_\*]TK.3<WISR?
MG3G_`,=]J!\/=*SG[5?'G)^=.?\`QW\*+U^R#EP_=EX^--`'6^/_`'XDY_\`
M':#XT\/CK?G_`+\2<_3Y>:H#X>Z3_P`_-][_`#H,\_[M+_PKW2LY-S>G/)^=
M.?\`QWVHO7[(.7#]V7CXT\/CK?G_`+\2?_$T'QIH`ZWQ_P"_$G/_`([5$?#W
M2LY^U7QYR?G3G_QW\*0?#W2?^?F^]_G09Y_W:+U^R#EP_=E\^-/#XZWY_P"_
M,G/T^7F@^,]`'6_/K_J)/_B:H?\`"O=*Y_TF^YSGYTY_\=I3\/=)))^TWW)Y
M^=/3'7;1>OV0^7#]V<?XWOK?6=:CN-/D\Z(6JQEL%?F#L<<X]?\`]5=\/&?A
M\]-0!'J(9#VS_=]*HGX>Z2?^7B\_[Z3GC_=H_P"%?:3G/VF^_P"_B^N?[M1&
M-:+;26IA3PV%ISE--WEZ?Y%[_A,]`_Y_C_WXD_\`B:/^$ST#_G^/?_EA)_\`
M$U0_X5YI`P!<7H````=./_'?84O_``KW2<@_:+WC@#>O'3_9]A5\U?LC?EP_
M=E[_`(3+0,X^W'.<?ZB3_P")KB-1U.TN/&\>I13%K03P2>9L*X4!<\$`_P`+
M>_I74?\`"O-(X_TB]P`!C>O_`,3["C_A7FD=/M%YCTW)T]/NU$XUIJS2+IRH
M0=TV7_\`A,]`_P"?YO\`OQ)_\31_PF6@$_\`'\?^_$G_`,35#_A7FDX/^DWN
M<==Z=?7[O6@_#S2.<7%Z..,.G'I_#5WK]D1RX?NR_P#\)GH&,_;F_P"_$G_Q
M-5-5\6Z+<:/>P0WI,LEO(B`P2#+%<#^'W%1GX>:0<_O[P`C&-R<?^.T?\*\T
MC)_TB]Y]'4?C]W_.*&Z[5K($L.G>[,+P5K-AI#7WVZ8Q"7RQ'E6;."^1\H..
MH_/VKK/^$ST#_G^/_?B3_P")JA_PKW2,_P#'Q>],#YTX_P#':7_A7ND<8GO!
MCT=.GI]VI@JT(\J2*J.A.7,VR]_PF>@?\_S=_P#EA)_\37&75[!J'Q`@NK61
MI(9+N#:VTC.`H/7&.1WYZ]C72?\`"O-)[W%Z>N?F3G/_``&IK3P+IEG>07,<
M]VSPNKJ&9,$J01G"^V*)1JSLFD.$J%.[BV=/11174<04444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
8`!1110`4444`%%%%`!1110`4444`?__9
`


#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="mpIDESettings">
    <dbl nm="PREVIEWTEXTHEIGHT" ut="N" vl="1" />
  </lst>
  <lst nm="mpTslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End