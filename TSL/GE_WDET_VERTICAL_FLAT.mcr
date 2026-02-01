#Version 8
#BeginDescription
Inserts ladder and side studs in a wall (edge orientation)
v1.2: 21.jul.2012: David Rueda (dr@hsb-cad.com)

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2011 by
*  hsbSOFT 
*  UNITED STATES OF AMERICA
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
* v1.2: 21.jul.2012: David Rueda (dr@hsb-cad.com)
	- Description added
	- Thumbnail added
* v1.1: 08.nov.2011: David Rueda (dr@hsb-cad.com)
	- Added info from _Map to side beams
	- Added grade and material to blocking from _Map
	- Module name changed
* v1.0: 11.oct.2011: David Rueda (dr@hsb-cad.com)
	- Added info from _Map to beam
* v0.2: Release (No author/date found)
*
*/

int strProp=0,nProp=0,dProp=0;
String arYN[]={"Yes","No"};

PropString strEmpty0(strProp,"- - - - - - - - - - - - - - - -",T("PLACEMENT PROPERTIES"));strProp++;
strEmpty0.setReadOnly(true);

PropDouble dStartOffset(dProp,U(600, 24),T("  Start Offset"));dProp++;

PropDouble dEndOffset(dProp,U(0, 0),T("  End Offset"));dProp++;

PropDouble dSpacing(dProp,U(600, 24),T("  Spacing"));dProp++;

PropDouble dBlockingLength(dProp,U(200, 8),T("  Blocking Length"));dProp++;

PropString strEmpty1(strProp,"- - - - - - - - - - - - - - - -",T("MATERIAL PROPERTIES"));strProp++;
strEmpty1.setReadOnly(true);

PropString strMat(strProp,"SPF",T("  Material"));strProp++;

PropString strGrade(strProp,"#2",T("  Grade"));strProp++;

//OTHER SETTINGS
int nColor=2;

double dBlkSizeInElVecY=dBlockingLength;
double dBlkSizeInElVecX=U(90, 3.5);

//Insert donde in script.
if(_bOnInsert){
	//Select an element
	_Element.append(getElement(T("Select an element")));
	_Pt0 = getPoint(T("Select an insertion point"));
	showDialogOnce();
	return;
}

if(_Element.length()==0){
	eraseInstance(); 
	return;
}
if(_bOnElementDeleted)eraseInstance();
	
//Assign selected element to el.
Element el = _Element0;
ElementWallSF elW=(ElementWallSF)el;
if(!elW.bIsValid())eraseInstance();
CoordSys csEl = el.coordSys();
Point3d ptOrg=csEl.ptOrg();
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();


Wall w=(Wall)el;
if(!w.bIsValid()){
	eraseInstance();
	return;
}

//Load the properties for the arguments
String sStartOffset;
if (_Map.hasString("StartOffset"))
{
	sStartOffset= _Map.getString("StartOffset");
	double dAux=sStartOffset.atof();
	dAux=dAux/25.4;
	dStartOffset.set(dAux);
}

String sEndOffset;
if (_Map.hasString("EndOffset"))
{
	sEndOffset= _Map.getString("EndOffset");
	double dAux=sEndOffset.atof();
	dAux=dAux/25.4;
	dEndOffset.set(dAux);
}

String sSpacing;
if (_Map.hasString("Spacing"))
{
	sSpacing= _Map.getString("Spacing");
	double dAux=sSpacing.atof();
	dAux=dAux/25.4;
	dSpacing.set(dAux);
}

String sLength;
if (_Map.hasString("Length"))
{
	sLength= _Map.getString("Length");
	double dAux=sLength.atof();
	dAux=dAux/25.4;
	dBlockingLength.set(dAux);
}

String sInformation;
if(_Map.hasString("Information"))
{
	sInformation=_Map.getString("Information");
}

if(_Map.hasString("Material"))
{
	strMat.set(_Map.getString("Material"));
}

if(_Map.hasString("Grade"))
{
	strGrade.set(_Map.getString("Grade"));
}

//set Module name
String sModuleName="VERTICAL_FLAT_ID_" + _ThisInst.handle() ;

assignToElementGroup(el,TRUE,0,'Z');

Beam arBmAll[]=el.beam();
Beam arBmVertical[]=vx.filterBeamsPerpendicularSort(arBmAll);
Beam arBmHorizontal[]=vy.filterBeamsPerpendicularSort(arBmAll);

//Relocate _Pt0
_Pt0=_Pt0.projectPoint(Plane(el.ptOrg(),el.vecY()),0);


if(el.vecZ().dotProduct(_Pt0 - (el.ptOrg()-el.vecZ()*el.dBeamWidth()/2)) >= U(0, 0)) {
	_Pt0=_Pt0.projectPoint(Plane(el.ptOrg(),el.vecZ()),0);
	vz = -vz;
}
else {
	_Pt0 = _Pt0.projectPoint(Plane(el.ptOrg()-el.dBeamWidth()*el.vecZ(),el.vecZ()),0);
}
//vzC is always going in the walls


//Getting closer studs to insertion point
Beam bmLeft, bmRight;
double dDistL, dDistR;
dDistL=dDistR=U(10000, 100000);
int nOneOnZero=0;
for(int b=0;b<arBmVertical.length();b++){
	Beam bm=arBmVertical[b];
	double dDistPointToBeam=vx.dotProduct(bm.ptCen()-_Pt0);
	if(abs(dDistPointToBeam)<U(2, 0.1))nOneOnZero=1;
	if(dDistPointToBeam<0){// Beam is at left
		if(dDistL>abs(dDistPointToBeam)){
			bmLeft=bm;
			dDistL=abs(dDistPointToBeam);
		}	
	}
	else{// Beam is at right
		if(dDistR>dDistPointToBeam){
			bmRight=bm;
			dDistR=dDistPointToBeam;
		}
	}
}

if(!bmLeft.bIsValid() || !bmRight.bIsValid()){
	reportMessage("\nTSL" + scriptName() + " cannot find a connecting stud on element " +el.number());
	eraseInstance();
	return;
} 

//Check blocking pieces in the way
//bHasBlocking will be true is blocking belongs to a module
Body bdBlk(_Pt0,el.vecX(),el.vecY(),el.vecZ(),(dDistL+dDistR)/2,U(10000, 600),U(1200, 50),0,1,0);
for(int b=0;b<arBmHorizontal.length();b++){
	Beam bm=arBmHorizontal[b];
	if((bm.type()== _kBlocking || bm.type()==_kSFBlocking) && bm.realBody().hasIntersection(bdBlk) )bm.dbErase();
}


Point3d ptRightOnLeftBm=bmLeft.ptCen()+vx*bmLeft.dD(vx)*.5;
Point3d ptLeftOnRightBm=bmRight.ptCen()-vx*bmRight.dD(vx)*.5;



//Check spacing between
double dDistSpace=vx.dotProduct(ptLeftOnRightBm-ptRightOnLeftBm);
if(abs(dDistSpace-U(63, 2.5))<U(3, 0.125))dBlkSizeInElVecX=U(63, 2.5);
else if(abs(dDistSpace-U(89, 3.5))<U(3, 0.125))dBlkSizeInElVecX=U(89, 3.5);
else if(abs(dDistSpace-U(140, 5.5))<U(3, 0.125))dBlkSizeInElVecX=U(140, 5.5);
else if(abs(dDistSpace-U(184, 7.25))<U(3, 0.125))dBlkSizeInElVecX=U(184, 7.25);
else if(abs(dDistSpace-U(235, 9.25))<U(3, 0.125))dBlkSizeInElVecX=U(235, 9.25);
else if(abs(dDistSpace-U(286, 11.25))<U(3, 0.125))dBlkSizeInElVecX=U(286, 11.25);
else{
	reportMessage("\nCannot position " + scriptName() + " on element " + el.number() + " because " + dDistSpace +" is not a standard size");
	eraseInstance();
	return;
}

_Pt0 = _Pt0.projectPoint(Plane(ptRightOnLeftBm+vx*dBlkSizeInElVecX/2,vx),0);


//Get shape points to calculate offset values
Point3d arPtBmSide[0];

arPtBmSide.append(bmLeft.realBody().allVertices());
arPtBmSide.append(bmRight.realBody().allVertices());

arPtBmSide=Line(ptOrg,vy).orderPoints(arPtBmSide);

double dMaxHeight=vy.dotProduct(arPtBmSide[arPtBmSide.length()-1]-ptOrg);
double dBottomPlateThick=vy.dotProduct(arPtBmSide[0]-ptOrg);

Point3d arPtBlock[0];

//do something special for end offset
double dOffsetDown=U(0, 0);//if >0, it needs blocking at tope forced in
if(dEndOffset == U(0, 0))dMaxHeight -= dBlkSizeInElVecY/2;
else if(dEndOffset <= (dBlkSizeInElVecY/2 + U(76, 3))){
	dMaxHeight -= dBlkSizeInElVecY*1.5;
	dOffsetDown=dBlkSizeInElVecY/2;
}
else {
	dMaxHeight -= (dEndOffset+dBlkSizeInElVecY*0.5);
	dOffsetDown=dEndOffset;
}
//define some points for blocks

	
double dGrow=dStartOffset;

//see if we force one at the bottom
if(dGrow == U(0, 0)){
	dGrow = dBlkSizeInElVecY/2+dBottomPlateThick;
}
Point3d ptBlock=_Pt0+dGrow*vy;
	
while(dGrow < dMaxHeight){//get all points possible
	arPtBlock.append(ptBlock);
	
	ptBlock.transformBy((dSpacing+dBlockingLength)*vy);					
	dGrow+=(dSpacing+dBlockingLength);
}
if(dOffsetDown>U(0,0)){//force at the top
	dMaxHeight=vy.dotProduct(arPtBmSide[arPtBmSide.length()-1]-ptOrg);
	arPtBlock.append(_Pt0+(dMaxHeight-dOffsetDown)*vy);
}
		
		
arPtBlock=Line(el.ptOrg(),el.vecY()).orderPoints(arPtBlock);
		
for(int i=0;i<arPtBlock.length();i++){
			
	Beam bm1;		
		
	bm1.dbCreate(arPtBlock[i], vy, vz, vx, dBlockingLength, U(38, 1.5), dBlkSizeInElVecX, 0, 1, 0);
	bm1.setType(_kBlocking);
	bm1.setColor(nColor);
	bm1.setModule(sModuleName);
	bm1.setHsbId("12");
	bm1.setMaterial(strMat);
	bm1.setGrade(strGrade);
	bm1.setInformation(sInformation);
	bm1.assignToElementGroup(el,TRUE,0,'Z');
}

bmLeft.setColor(nColor);
bmLeft.setModule(sModuleName);
bmLeft.setInformation(sInformation);
bmRight.setColor(nColor);
bmRight.setModule(sModuleName);
bmRight.setInformation(sInformation);

eraseInstance();
return;



























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
MHH`****`"BBB@`HHHH`****`"BBB@`HKR/3[CQ%JMPT%E?7LLBKO*_:BO&0,
M\L/45I?V1XU_YZWO_@</_BZYEB&]5%G6\*HNSDCTJBO-?[(\:_\`/6]_\#A_
M\71_9'C7_GK>_P#@</\`XNG[>7\K)^KQ_G1Z517EU[:>+=/M'NKJXO8X4QN;
M[9G&3@<!L]34>GQ^*=5MVGLKJ]EC5MA;[7MYP#CEAZBE]8=[<K*^JJU^96/5
M:*\U_LCQK_SUO?\`P.'_`,71_9'C7_GK>_\`@</_`(NG[>7\K)^KQ_G1Z517
MFO\`9'C7_GK>_P#@</\`XNLW4+CQ%I5PL%[?7L4C+O"_:BW&2,\,?0TGB&M7
M%E+"J3LI(]<HKS7^R/&O_/6]_P#`X?\`Q=']D>-?^>M[_P"!P_\`BZ?MY?RL
MGZO'^='I5%>:_P!D>-?^>M[_`.!P_P#BZ/[(\:_\];W_`,#A_P#%T>WE_*P^
MKQ_G1Z517D<-QXBGU,Z=%?7K789D,?VHCE<Y&=V.QK2_LCQK_P`];W_P.'_Q
M=)8AO:+*>%2WDCTJBO-?[(\:_P#/6]_\#A_\71_9'C7_`)ZWO_@</_BZ?MY?
MRLGZO'^='I5%>77MIXMT^T>ZNKB]CA3&YOMF<9.!P&SU-1Z?'XIU6W:>RNKV
M6-6V%OM>WG`..6'J*7UAWMRLKZJK7YE8]5HKRG4E\4:/;+<7]W>PQ,X0-]KW
M?-@G'#'T-26-MXLU*SCN[2YO9(),[7^V8S@D'@MGJ#1]8=[<K,_94^;E]HK]
MKGJ5%>4ZDOBC1[9;B_N[V&)G"!OM>[YL$XX8^AJ2QMO%FI6<=W:7-[)!)G:_
MVS&<$@\%L]0:/K#O;E8>RI\W+[17[7/4J*\CU"X\1:5<+!>WU[%(R[POVHMQ
MDC/#'T-:7]D>-?\`GK>_^!P_^+H6(;T46:/"I*[DCTJBO-?[(\:_\];W_P`#
MA_\`%T?V1XU_YZWO_@</_BZ?MY?RLGZO'^='I5%>1ZA<>(M*N%@O;Z]BD9=X
M7[46XR1GACZ&M+^R/&O_`#UO?_`X?_%TEB&]%%E/"I*[DCTJBO-?[(\:_P#/
M6]_\#A_\71_9'C7_`)ZWO_@</_BZ?MY?RLGZO'^='I5%>:_V1XU_YZWO_@</
M_BZS9KCQ%!J8TZ6^O5NRRH(_M1/+8P,[L=Q2>(:WBREA4]I(]<HKS7^R/&O_
M`#UO?_`X?_%T?V1XU_YZWO\`X'#_`.+I^WE_*R?J\?YT>E45YK_9'C7_`)ZW
MO_@</_BZ9/IWC&VMY)Y9[U8XU+NWVT'``R3]ZCV[_E8_J\?YT>FT5Y/IK>)M
M7\W[#>7LOE8W_P"EE<9SCJP]#5[^R/&O_/6]_P#`X?\`Q=)8AM746#PR3LY(
M]*HKS7^R/&O_`#UO?_`X?_%U6M+O6[3Q-9V-]?78<7,2R1M<%@02#@X)!X-/
MV]MXL/JR>TDSU.BBBN@Y0HHHH`****`"BBB@#S7X>_\`(?G_`.O5O_0DKTJO
M-?A[_P`A^?\`Z]6_]"2O2JY\-_#.G%_Q`HHHKH.8PO&7_(IWO_;/_P!#6J'P
M]_Y`$_\`U]-_Z"E7_&7_`"*=[_VS_P#0UJA\/?\`D`3_`/7TW_H*5SO^.O0Z
M5_N[]3K****Z#F"O-?B%_P`A^#_KU7_T)Z]*KS7XA?\`(?@_Z]5_]">N?$_P
MSIPG\0]*HHHKH.8****`/-=(_P"2E2?]?5Q_)Z]*KS72/^2E2?\`7U<?R>O2
MJY\/\+]3IQ7Q1]`HHHKH.8PO&7_(IWO_`&S_`/0UJA\/?^0!/_U]-_Z"E7_&
M7_(IWO\`VS_]#6J'P]_Y`$__`%]-_P"@I7._XZ]#I7^[OU(OB5_R+EO_`-?:
M_P#H#UH>!_\`D3K#_MI_Z,:L_P")7_(N6_\`U]K_`.@/6AX'_P"1.L/^VG_H
MQJ:_C/T/$A_O\O\`#^J,_P")7_(N6_\`U]K_`.@/6AX'_P"1.L/^VG_HQJS_
M`(E?\BY;_P#7VO\`Z`]:'@?_`)$ZP_[:?^C&H7\9^@0_W^7^']4<M\0O^0_!
M_P!>J_\`H3UZ57FOQ"_Y#\'_`%ZK_P"A/7I5*E_$F>W6_AP^84445T',>:_$
M+_D/P?\`7JO_`*$]>E5YK\0O^0_!_P!>J_\`H3UZ57/2_B3.FM_#A\PHHHKH
M.8*\UU?_`)*5'_U]6_\`)*]*KS75_P#DI4?_`%]6_P#)*Y\1\*]3IPOQ2]#T
MJBBBN@Y@JAK?_(`U'_KUE_\`035^J&M_\@#4?^O67_T$U,OA94/B1R?PX_YB
M?_;+_P!GKNZX3X<?\Q/_`+9?^SUW=9X?^&C;%?Q7_70*\UU?_DI4?_7U;_R2
MO2J\UU?_`)*5'_U]6_\`)*G$?"O4>%^*7H>E4445T',%%%%`!1110`4444`>
M:_#W_D/S_P#7JW_H25Z57FOP]_Y#\_\`UZM_Z$E>E5SX;^&=.+_B!11170<Q
MA>,O^13O?^V?_H:U0^'O_(`G_P"OIO\`T%*O^,O^13O?^V?_`*&M4/A[_P`@
M"?\`Z^F_]!2N=_QUZ'2O]W?J=911170<P5YK\0O^0_!_UZK_`.A/7I5>:_$+
M_D/P?]>J_P#H3USXG^&=.$_B'I5%%%=!S!1110!YKI'_`"4J3_KZN/Y/7I5>
M:Z1_R4J3_KZN/Y/7I5<^'^%^ITXKXH^@4445T',87C+_`)%.]_[9_P#H:U0^
M'O\`R`)_^OIO_04J_P",O^13O?\`MG_Z&M4/A[_R`)_^OIO_`$%*YW_'7H=*
M_P!W?J1?$K_D7+?_`*^U_P#0'KD=*\;ZEH^FPV%O!:-%%G:9$8MR2><,/6NN
M^)7_`"+EO_U]K_Z`]>65C7DXU+H^3S"K.EBG*#L[(W]<\77^OV26MU#;)&D@
MD!B5@<@$=V/J:]$\#_\`(G6'_;3_`-&-7CE>Q^!_^1.L/^VG_HQJ>'DY3;?8
MO*ZDZF(<IN[M^J.6^(7_`"'X/^O5?_0GKTJO-?B%_P`A^#_KU7_T)Z]*K6E_
M$F?4UOX</F%%%%=!S'FOQ"_Y#\'_`%ZK_P"A/7I5>:_$+_D/P?\`7JO_`*$]
M>E5STOXDSIK?PX?,****Z#F"O-=7_P"2E1_]?5O_`"2O2J\UU?\`Y*5'_P!?
M5O\`R2N?$?"O4Z<+\4O0]*HHHKH.8*H:W_R`-1_Z]9?_`$$U?JAK?_(`U'_K
MUE_]!-3+X65#XD<G\./^8G_VR_\`9Z[NN$^''_,3_P"V7_L]=W6>'_AHVQ7\
M5_UT"O-=7_Y*5'_U]6_\DKTJO-=7_P"2E1_]?5O_`"2IQ'PKU'A?BEZ'I5%%
M%=!S!1110`4444`%%%%`'FOP]_Y#\_\`UZM_Z$E>E5YK\/?^0_/_`->K?^A)
M7I5<^&_AG3B_X@4445T',87C+_D4[W_MG_Z&M4/A[_R`)_\`KZ;_`-!2K_C+
M_D4[W_MG_P"AK5#X>_\`(`G_`.OIO_04KG?\=>ATK_=WZG64445T',%>:_$+
M_D/P?]>J_P#H3UZ57FOQ"_Y#\'_7JO\`Z$]<^)_AG3A/XAZ511170<P4444`
M>:Z1_P`E*D_Z^KC^3UZ57FND?\E*D_Z^KC^3UZ57/A_A?J=.*^*/H%%%%=!S
M&%XR_P"13O?^V?\`Z&M4/A[_`,@"?_KZ;_T%*O\`C+_D4[W_`+9_^AK5#X>_
M\@"?_KZ;_P!!2N=_QUZ'2O\`=WZD7Q*_Y%RW_P"OM?\`T!Z\LKU/XE?\BY;_
M`/7VO_H#UY97/B?C/C\U_P!X?H@KV/P/_P`B=8?]M/\`T8U>.5['X'_Y$ZP_
M[:?^C&JL+\;]#3*/X[]/U1RWQ"_Y#\'_`%ZK_P"A/7I5>:_$+_D/P?\`7JO_
M`*$]>E5M2_B3/K*W\.'S"BBBN@YCS7XA?\A^#_KU7_T)Z]*KS7XA?\A^#_KU
M7_T)Z]*KGI?Q)G36_AP^84445T',%>:ZO_R4J/\`Z^K?^25Z57FNK_\`)2H_
M^OJW_DE<^(^%>ITX7XI>AZ511170<P50UO\`Y`&H_P#7K+_Z":OU0UO_`)`&
MH_\`7K+_`.@FIE\+*A\2.3^''_,3_P"V7_L]=W7"?#C_`)B?_;+_`-GKNZSP
M_P##1MBOXK_KH%>:ZO\`\E*C_P"OJW_DE>E5YKJ__)2H_P#KZM_Y)4XCX5ZC
MPOQ2]#TJBBBN@Y@HHHH`****`"BBB@#S7X>_\A^?_KU;_P!"2O2J\U^'O_(?
MG_Z]6_\`0DKTJN?#?PSIQ?\`$"BBBN@YC"\9?\BG>_\`;/\`]#6J'P]_Y`$_
M_7TW_H*5?\9?\BG>_P#;/_T-:H?#W_D`3_\`7TW_`*"E<[_CKT.E?[N_4ZRB
MBBN@Y@KS7XA?\A^#_KU7_P!">O2J\U^(7_(?@_Z]5_\`0GKGQ/\`#.G"?Q#T
MJBBBN@Y@HHHH`\UTC_DI4G_7U<?R>O2J\UTC_DI4G_7U<?R>O2JY\/\`"_4Z
M<5\4?0****Z#F,+QE_R*=[_VS_\`0UJA\/?^0!/_`-?3?^@I5_QE_P`BG>_]
ML_\`T-:H?#W_`)`$_P#U]-_Z"E<[_CKT.E?[N_4B^)7_`"+EO_U]K_Z`]2>#
MM(TVZ\*64UQIUI-*V_<\D*LQ^=AR2*C^)7_(N6__`%]K_P"@/6AX'_Y$ZP_[
M:?\`HQJ$DZSOV/#45+'R37V?\C$^(&F6%EH,$EK8VT$ANE4M%$JDC:W&0/85
MM^!_^1.L/^VG_HQJS_B5_P`BY;_]?:_^@/6AX'_Y$ZP_[:?^C&HBK5GZ!3BE
MCY)?R_JCEOB%_P`A^#_KU7_T)Z]*KS7XA?\`(?@_Z]5_]">O2J*7\29[E;^'
M#YA11170<QYK\0O^0_!_UZK_`.A/7I5>:_$+_D/P?]>J_P#H3UZ57/2_B3.F
MM_#A\PHHHKH.8*\UU?\`Y*5'_P!?5O\`R2O2J\UU?_DI4?\`U]6_\DKGQ'PK
MU.G"_%+T/2J***Z#F"J&M_\`(`U'_KUE_P#035^J&M_\@#4?^O67_P!!-3+X
M65#XD<G\./\`F)_]LO\`V>N[KA/AQ_S$_P#ME_[/7=UGA_X:-L5_%?\`70*\
MUU?_`)*5'_U]6_\`)*]*KS75_P#DI4?_`%]6_P#)*G$?"O4>%^*7H>E4445T
M',%%%%`!1110`4444`>:_#W_`)#\_P#UZM_Z$E>E5YK\/?\`D/S_`/7JW_H2
M5Z57/AOX9TXO^(%%%%=!S&%XR_Y%.]_[9_\`H:U0^'O_`"`)_P#KZ;_T%*O^
M,O\`D4[W_MG_`.AK5#X>_P#(`G_Z^F_]!2N=_P`=>ATK_=WZG64445T',%>:
M_$+_`)#\'_7JO_H3UZ57FOQ"_P"0_!_UZK_Z$]<^)_AG3A/XAZ511170<P44
M44`>:Z1_R4J3_KZN/Y/7I5>:Z1_R4J3_`*^KC^3UZ57/A_A?J=.*^*/H%%%%
M=!S&%XR_Y%.]_P"V?_H:U0^'O_(`G_Z^F_\`04J_XR_Y%.]_[9_^AK5#X>_\
M@"?_`*^F_P#04KG?\=>ATK_=WZD7Q*_Y%RW_`.OM?_0'K0\#_P#(G6'_`&T_
M]&-6?\2O^1<M_P#K[7_T!ZX6Q\5:UIMG':6E[Y<$>=J>4AQDDGDC/4FIE44*
MK;['SM;$PP^-<Y]K:'=?$K_D7+?_`*^U_P#0'K0\#_\`(G6'_;3_`-&-7F.I
M>(]6UBV6WO[OSHE<.%\M%^;!&>`/4UZ=X'_Y$ZP_[:?^C&HIS4ZK:[#PE>-?
M&2G';E_5'+?$+_D/P?\`7JO_`*$]>E5YK\0O^0_!_P!>J_\`H3UZ554OXDSZ
M&M_#A\PHHHKH.8\U^(7_`"'X/^O5?_0GKTJO-?B%_P`A^#_KU7_T)Z]*KGI?
MQ)G36_AP^84445T',%>:ZO\`\E*C_P"OJW_DE>E5YKJ__)2H_P#KZM_Y)7/B
M/A7J=.%^*7H>E4445T',%4-;_P"0!J/_`%ZR_P#H)J_5#6_^0!J/_7K+_P"@
MFIE\+*A\2.3^''_,3_[9?^SUW=<)\./^8G_VR_\`9Z[NL\/_``T;8K^*_P"N
M@5YKJ_\`R4J/_KZM_P"25Z57FNK_`/)2H_\`KZM_Y)4XCX5ZCPOQ2]#TJBBB
MN@Y@HHHH`****`"BBB@#S7X>_P#(?G_Z]6_]"2O2J\U^'O\`R'Y_^O5O_0DK
MTJN?#?PSIQ?\0****Z#F,+QE_P`BG>_]L_\`T-:H?#W_`)`$_P#U]-_Z"E7_
M`!E_R*=[_P!L_P#T-:H?#W_D`3_]?3?^@I7._P".O0Z5_N[]3K****Z#F"O-
M?B%_R'X/^O5?_0GKTJO-?B%_R'X/^O5?_0GKGQ/\,Z<)_$/2J***Z#F"BBB@
M#S72/^2E2?\`7U<?R>O2J\UTC_DI4G_7U<?R>O2JY\/\+]3IQ7Q1]`HHHKH.
M8PO&7_(IWO\`VS_]#6J'P]_Y`$__`%]-_P"@I5_QE_R*=[_VS_\`0UJA\/?^
M0!/_`-?3?^@I7._XZ]#I7^[OU(OB5_R+EO\`]?:_^@/7EE>I_$K_`)%RW_Z^
MU_\`0'KRRN?$_&?'YK_O#]$%>Q^!_P#D3K#_`+:?^C&KQRO8_`__`")UA_VT
M_P#1C56%^-^AIE'\=^GZHY;XA?\`(?@_Z]5_]">O2J\U^(7_`"'X/^O5?_0G
MKTJMJ7\29]96_AP^84445T',>:_$+_D/P?\`7JO_`*$]>E5YK\0O^0_!_P!>
MJ_\`H3UZ57/2_B3.FM_#A\PHHHKH.8*\UU?_`)*5'_U]6_\`)*]*KS75_P#D
MI4?_`%]6_P#)*Y\1\*]3IPOQ2]#TJBBBN@Y@JAK?_(`U'_KUE_\`035^J&M_
M\@#4?^O67_T$U,OA94/B1R?PX_YB?_;+_P!GKNZX3X<?\Q/_`+9?^SUW=9X?
M^&C;%?Q7_70*\UU?_DI4?_7U;_R2O2J\UU?_`)*5'_U]6_\`)*G$?"O4>%^*
M7H>E4445T',%%%%`!1110`4444`>:_#W_D/S_P#7JW_H25Z57FOP]_Y#\_\`
MUZM_Z$E>E5SX;^&=.+_B!11170<QA>,O^13O?^V?_H:U0^'O_(`G_P"OIO\`
MT%*O^,O^13O?^V?_`*&M4/A[_P`@"?\`Z^F_]!2N=_QUZ'2O]W?J=911170<
MP5YK\0O^0_!_UZK_`.A/7I5>:_$+_D/P?]>J_P#H3USXG^&=.$_B'I5%%%=!
MS!1110!YKI'_`"4J3_KZN/Y/7I5>:Z1_R4J3_KZN/Y/7I5<^'^%^ITXKXH^@
M4445T',87C+_`)%.]_[9_P#H:U0^'O\`R`)_^OIO_04J_P",O^13O?\`MG_Z
M&M4/A[_R`)_^OIO_`$%*YW_'7H=*_P!W?J1?$K_D7+?_`*^U_P#0'KRRO4_B
M5_R+EO\`]?:_^@/6AX'_`.1.L/\`MI_Z,:LZE/VE6U^A\UB<+]9QCA>VESQR
MO8_`_P#R)UA_VT_]&-6?\2O^1<M_^OM?_0'K0\#_`/(G6'_;3_T8U.E#DJM>
M16"P_P!7Q<H7O[OZHY;XA?\`(?@_Z]5_]">O2J\U^(7_`"'X/^O5?_0GKTJK
MI?Q)GT=;^'#YA11170<QYK\0O^0_!_UZK_Z$]>E5YK\0O^0_!_UZK_Z$]>E5
MSTOXDSIK?PX?,****Z#F"O-=7_Y*5'_U]6_\DKTJO-=7_P"2E1_]?5O_`"2N
M?$?"O4Z<+\4O0]*HHHKH.8*H:W_R`-1_Z]9?_035^J&M_P#(`U'_`*]9?_03
M4R^%E0^)')_#C_F)_P#;+_V>N[KA/AQ_S$_^V7_L]=W6>'_AHVQ7\5_UT"O-
M=7_Y*5'_`-?5O_)*]*KS75_^2E1_]?5O_)*G$?"O4>%^*7H>E4445T',%%%%
M`!1110`4444`>:_#W_D/S_\`7JW_`*$E>E5YK\/?^0_/_P!>K?\`H25Z57/A
MOX9TXO\`B!11170<QA>,O^13O?\`MG_Z&M4/A[_R`)_^OIO_`$%*O^,O^13O
M?^V?_H:U0^'O_(`G_P"OIO\`T%*YW_'7H=*_W=^IUE%%%=!S!7FOQ"_Y#\'_
M`%ZK_P"A/7I5>:_$+_D/P?\`7JO_`*$]<^)_AG3A/XAZ511170<P4444`>:Z
M1_R4J3_KZN/Y/7I5>:Z1_P`E*D_Z^KC^3UZ57/A_A?J=.*^*/H%%%%=!S&%X
MR_Y%.]_[9_\`H:U0^'O_`"`)_P#KZ;_T%*O^,O\`D4[W_MG_`.AK5#X>_P#(
M`G_Z^F_]!2N=_P`=>ATK_=WZD7Q*_P"1<M_^OM?_`$!ZT/`__(G6'_;3_P!&
M-6?\2O\`D7+?_K[7_P!`>M#P/_R)UA_VT_\`1C4U_&?H>)#_`'^7^']49_Q*
M_P"1<M_^OM?_`$!ZT/`__(G6'_;3_P!&-6?\2O\`D7+?_K[7_P!`>M#P/_R)
MUA_VT_\`1C4+^,_0(?[_`"_P_JCEOB%_R'X/^O5?_0GKTJO-?B%_R'X/^O5?
M_0GKTJE2_B3/;K?PX?,****Z#F/-?B%_R'X/^O5?_0GKTJO-?B%_R'X/^O5?
M_0GKTJN>E_$F=-;^'#YA11170<P5YKJ__)2H_P#KZM_Y)7I5>:ZO_P`E*C_Z
M^K?^25SXCX5ZG3A?BEZ'I5%%%=!S!5#6_P#D`:C_`->LO_H)J_5#6_\`D`:C
M_P!>LO\`Z":F7PLJ'Q(Y/X<?\Q/_`+9?^SUW=<)\./\`F)_]LO\`V>N[K/#_
M`,-&V*_BO^N@5YKJ_P#R4J/_`*^K?^25Z57FNK_\E*C_`.OJW_DE3B/A7J/"
M_%+T/2J***Z#F"BBB@`HHHH`****`/-?A[_R'Y_^O5O_`$)*]*KS7X>_\A^?
M_KU;_P!"2O2JY\-_#.G%_P`0****Z#F,+QE_R*=[_P!L_P#T-:H?#W_D`3_]
M?3?^@I5_QE_R*=[_`-L__0UJA\/?^0!/_P!?3?\`H*5SO^.O0Z5_N[]3K***
M*Z#F"O-?B%_R'X/^O5?_`$)Z]*KS7XA?\A^#_KU7_P!">N?$_P`,Z<)_$/2J
M***Z#F"BBB@#S72/^2E2?]?5Q_)Z]*KS72/^2E2?]?5Q_)Z]*KGP_P`+]3IQ
M7Q1]`HHHKH.8PO&7_(IWO_;/_P!#6J'P]_Y`$_\`U]-_Z"E7_&7_`"*=[_VS
M_P#0UJA\/?\`D`3_`/7TW_H*5SO^.O0Z5_N[]2+XE?\`(N6__7VO_H#UH>!_
M^1.L/^VG_HQJS_B5_P`BY;_]?:_^@/7G$&KZE:PK#;ZC=PQ+]U(YF51WX`-1
M.HH56WV/FZ^)6'QCFU?2QZ/\2O\`D7+?_K[7_P!`>M#P/_R)UA_VT_\`1C5Y
M-<ZG?WL8CNKZYGC!W!9968`^N"?<UZSX'_Y$ZP_[:?\`HQJ=*?/5;\BL'B%7
MQDII6]W]4<M\0O\`D/P?]>J_^A/7I5>:_$+_`)#\'_7JO_H3UZ554OXDSZ*M
M_#A\PHHHKH.8\U^(7_(?@_Z]5_\`0GKTJO-?B%_R'X/^O5?_`$)Z]*KGI?Q)
MG36_AP^84445T',%>:ZO_P`E*C_Z^K?^25Z57FNK_P#)2H_^OJW_`))7/B/A
M7J=.%^*7H>E4445T',%4-;_Y`&H_]>LO_H)J_5#6_P#D`:C_`->LO_H)J9?"
MRH?$CD_AQ_S$_P#ME_[/7=UPGPX_YB?_`&R_]GKNZSP_\-&V*_BO^N@5YKJ_
M_)2H_P#KZM_Y)7I5>:ZO_P`E*C_Z^K?^25.(^%>H\+\4O0]*HHHKH.8****`
M"BBB@`HHHH`\U^'O_(?G_P"O5O\`T)*]*KS7X>_\A^?_`*]6_P#0DKTJN?#?
MPSIQ?\0****Z#F,+QE_R*=[_`-L__0UJA\/?^0!/_P!?3?\`H*5?\9?\BG>_
M]L__`$-:H?#W_D`3_P#7TW_H*5SO^.O0Z5_N[]3K****Z#F"O-?B%_R'X/\`
MKU7_`-">O2J\U^(7_(?@_P"O5?\`T)ZY\3_#.G"?Q#TJBBBN@Y@HHHH`\UTC
M_DI4G_7U<?R>O2J\UTC_`)*5)_U]7'\GKTJN?#_"_4Z<5\4?0****Z#F,+QE
M_P`BG>_]L_\`T-:H?#W_`)`$_P#U]-_Z"E7_`!E_R*=[_P!L_P#T-:H?#W_D
M`3_]?3?^@I7._P".O0Z5_N[]2+XE?\BY;_\`7VO_`*`]>65ZG\2O^1<M_P#K
M[7_T!Z\LKGQ/QGQ^:_[P_1!7L?@?_D3K#_MI_P"C&KQRO8_`_P#R)UA_VT_]
M&-587XWZ&F4?QWZ?JCEOB%_R'X/^O5?_`$)Z]*KS7XA?\A^#_KU7_P!">O2J
MVI?Q)GUE;^'#YA11170<QYK\0O\`D/P?]>J_^A/7I5>:_$+_`)#\'_7JO_H3
MUZ57/2_B3.FM_#A\PHHHKH.8*\UU?_DI4?\`U]6_\DKTJO-=7_Y*5'_U]6_\
MDKGQ'PKU.G"_%+T/2J***Z#F"J&M_P#(`U'_`*]9?_035^J&M_\`(`U'_KUE
M_P#034R^%E0^)')_#C_F)_\`;+_V>N[KA/AQ_P`Q/_ME_P"SUW=9X?\`AHVQ
M7\5_UT"O-=7_`.2E1_\`7U;_`,DKTJO-=7_Y*5'_`-?5O_)*G$?"O4>%^*7H
M>E4445T',%%%%`!1110`4444`>:_#W_D/S_]>K?^A)7I5>:_#W_D/S_]>K?^
MA)7I5<^&_AG3B_X@4445T',87C+_`)%.]_[9_P#H:U0^'O\`R`)_^OIO_04J
M_P",O^13O?\`MG_Z&M4/A[_R`)_^OIO_`$%*YW_'7H=*_P!W?J=911170<P5
MYK\0O^0_!_UZK_Z$]>E5YK\0O^0_!_UZK_Z$]<^)_AG3A/XAZ511170<P444
M4`>:Z1_R4J3_`*^KC^3UZ57FND?\E*D_Z^KC^3UZ57/A_A?J=.*^*/H%%%%=
M!S&%XR_Y%.]_[9_^AK5#X>_\@"?_`*^F_P#04J_XR_Y%.]_[9_\`H:U0^'O_
M`"`)_P#KZ;_T%*YW_'7H=*_W=^I%\2O^1<M_^OM?_0'KSB#2-2NH5FM].NYH
MF^Z\<+,I[<$"O1_B5_R+EO\`]?:_^@/6AX'_`.1.L/\`MI_Z,:HG34ZK3['S
M=?#+$8QP;MI<\FN=,O[*,275C<P1D[0TL3*"?3)'L:]9\#_\B=8?]M/_`$8U
M9_Q*_P"1<M_^OM?_`$!ZT/`__(G6'_;3_P!&-3I0Y*K7D5@\.J&,E!._N_JC
MEOB%_P`A^#_KU7_T)Z]*KS7XA?\`(?@_Z]5_]">O2JJE_$F?15OX</F%%%%=
M!S'FOQ"_Y#\'_7JO_H3UZ57FOQ"_Y#\'_7JO_H3UZ57/2_B3.FM_#A\PHHHK
MH.8*\UU?_DI4?_7U;_R2O2J\UU?_`)*5'_U]6_\`)*Y\1\*]3IPOQ2]#TJBB
MBN@Y@JAK?_(`U'_KUE_]!-7ZH:W_`,@#4?\`KUE_]!-3+X65#XD<G\./^8G_
M`-LO_9Z[NN$^''_,3_[9?^SUW=9X?^&C;%?Q7_70*\UU?_DI4?\`U]6_\DKT
MJO-=7_Y*5'_U]6_\DJ<1\*]1X7XI>AZ511170<P4444`%%%%`!1110!YK\/?
M^0_/_P!>K?\`H25Z57FOP]_Y#\__`%ZM_P"A)7I5<^&_AG3B_P"(%%%%=!S&
M%XR_Y%.]_P"V?_H:U0^'O_(`G_Z^F_\`04J_XR_Y%.]_[9_^AK5#X>_\@"?_
M`*^F_P#04KG?\=>ATK_=WZG64445T',%>:_$+_D/P?\`7JO_`*$]>E5YK\0O
M^0_!_P!>J_\`H3USXG^&=.$_B'I5%%%=!S!1110!YKI'_)2I/^OJX_D]>E5Y
MKI'_`"4J3_KZN/Y/7I5<^'^%^ITXKXH^@4445T',87C+_D4[W_MG_P"AK5#X
M>_\`(`G_`.OIO_04J_XR_P"13O?^V?\`Z&M4/A[_`,@"?_KZ;_T%*YW_`!UZ
M'2O]W?J1?$K_`)%RW_Z^U_\`0'K0\#_\B=8?]M/_`$8U9_Q*_P"1<M_^OM?_
M`$!ZT/`__(G6'_;3_P!&-37\9^AXD/\`?Y?X?U1G_$K_`)%RW_Z^U_\`0'K0
M\#_\B=8?]M/_`$8U9_Q*_P"1<M_^OM?_`$!ZT/`__(G6'_;3_P!&-0OXS]`A
M_O\`+_#^J.6^(7_(?@_Z]5_]">O2J\U^(7_(?@_Z]5_]">O2J5+^),]NM_#A
M\PHHHKH.8\U^(7_(?@_Z]5_]">O2J\U^(7_(?@_Z]5_]">O2JYZ7\29TUOX<
M/F%%%%=!S!7FNK_\E*C_`.OJW_DE>E5YKJ__`"4J/_KZM_Y)7/B/A7J=.%^*
M7H>E4445T',%4-;_`.0!J/\`UZR_^@FK]4-;_P"0!J/_`%ZR_P#H)J9?"RH?
M$CD_AQ_S$_\`ME_[/7=UPGPX_P"8G_VR_P#9Z[NL\/\`PT;8K^*_ZZ!7FNK_
M`/)2H_\`KZM_Y)7I5>:ZO_R4J/\`Z^K?^25.(^%>H\+\4O0]*HHHKH.8****
M`"BBB@`HHHH`\J\':G9Z5J\L][-Y4;0%`VTMSN4XX!]#7<?\)EH'_/\`_P#D
M&3_XFJ'_``KW2?\`GXO?^^T_^)H_X5[I/_/Q>_\`?:?_`!-<D(UH*R2.VI*A
M4ES-LO\`_"9:!_S_`/\`Y!D_^)H_X3+0/^?_`/\`(,G_`,35#_A7ND_\_%[_
M`-]I_P#$T?\`"O=)_P"?B]_[[3_XFKO7[(SMA^[*_B;Q-I&H>'KJUM;OS)GV
M;5\MQG#@GDC'054\'>(-,TK2)8+VY\J1IRX7RV;C:HSP#Z&M/_A7ND_\_%[_
M`-]I_P#$T?\`"O=)_P"?B]_[[3_XFHY:W/SV1HI4%#DN[%__`(3+0/\`G_\`
M_(,G_P`31_PF6@?\_P#_`.09/_B:H?\`"O=)_P"?B]_[[3_XFC_A7ND_\_%[
M_P!]I_\`$U=Z_9&=L/W9?_X3+0/^?_\`\@R?_$UP_C'4[/5=7BGLIO-C6`(6
MVE>=S''('J*ZG_A7ND_\_%[_`-]I_P#$T?\`"O=)_P"?B]_[[3_XFHG&M-6:
M1I3E0IRYDV7_`/A,M`_Y_P#_`,@R?_$T?\)EH'_/_P#^09/_`(FJ'_"O=)_Y
M^+W_`+[3_P")H_X5[I/_`#\7O_?:?_$U=Z_9&=L/W9?_`.$RT#_G_P#_`"#)
M_P#$T?\`"9:!_P`__P#Y!D_^)JA_PKW2?^?B]_[[3_XFC_A7ND_\_%[_`-]I
M_P#$T7K]D%L/W9RVG:G9P>.'U&6;;:&>9Q)M)X8-@XQGN*[C_A,M`_Y__P#R
M#)_\35#_`(5[I/\`S\7O_?:?_$T?\*]TG_GXO?\`OM/_`(FHA&M!621I4E0F
MTVV7_P#A,M`_Y_\`_P`@R?\`Q-'_``F6@?\`/_\`^09/_B:H?\*]TG_GXO?^
M^T_^)H_X5[I/_/Q>_P#?:?\`Q-7>OV1G;#]V5_$WB;2-0\/75K:W?F3/LVKY
M;C.'!/)&.@JIX.\0:9I6D2P7MSY4C3EPOELW&U1G@'T-:?\`PKW2?^?B]_[[
M3_XFC_A7ND_\_%[_`-]I_P#$U'+6Y^>R-%*@H<EW8R/&^NZ;K&BPV]A<^=*M
MPKE=C+\NUAGD#U%7?"OB32=-\-6EI=W?ESQ[]R>6YQEV(Y`QT(JU_P`*]TG_
M`)^+W_OM/_B:/^%>Z3_S\7O_`'VG_P`33Y:W-S61RK#855G6N[M6Z?Y&1XWU
MW3=8T6&WL+GSI5N%<KL9?EVL,\@>HJ[X5\2:3IOAJTM+N[\N>/?N3RW.,NQ'
M(&.A%6O^%>Z3_P`_%[_WVG_Q-'_"O=)_Y^+W_OM/_B:.6MS<UD"PV%59UKN[
M5NG^1RWC'4[/5=7BGLIO-C6`(6VE>=S''('J*[C_`(3+0/\`G_\`_(,G_P`3
M5#_A7ND_\_%[_P!]I_\`$T?\*]TG_GXO?^^T_P#B:48UHMM):G5*5"45%MZ%
M_P#X3+0/^?\`_P#(,G_Q-'_"9:!_S_\`_D&3_P")JA_PKW2?^?B]_P"^T_\`
MB:/^%>Z3_P`_%[_WVG_Q-7>OV1G;#]V<MXQU.SU75XI[*;S8U@"%MI7G<QQR
M!ZBNX_X3+0/^?_\`\@R?_$U0_P"%>Z3_`,_%[_WVG_Q-'_"O=)_Y^+W_`+[3
M_P")J(QK1;:2U-)2H2BHMO0O_P#"9:!_S_\`_D&3_P")H_X3+0/^?_\`\@R?
M_$U0_P"%>Z3_`,_%[_WVG_Q-'_"O=)_Y^+W_`+[3_P")J[U^R,[8?NR__P`)
MEH'_`#__`/D&3_XFN'U'4[.?QPFHQ3;K03PN9-I'"A<G&,]C74_\*]TG_GXO
M?^^T_P#B:/\`A7ND_P#/Q>_]]I_\343C6FK-(TIRH0;:;+__``F6@?\`/_\`
M^09/_B:/^$RT#_G_`/\`R#)_\35#_A7ND_\`/Q>_]]I_\31_PKW2?^?B]_[[
M3_XFKO7[(SMA^[+_`/PF6@?\_P#_`.09/_B:IZIXLT2YTB]@BO=TDD#HB^4X
MR2I`'2F?\*]TG_GXO?\`OM/_`(FC_A7ND_\`/Q>_]]I_\30W7:M9#2PZ=[LP
M?!6LZ?I'V[[=<>5YOE[/D9LXW9Z`^HKK?^$RT#_G_P#_`"#)_P#$U0_X5[I/
M_/Q>_P#?:?\`Q-'_``KW2?\`GXO?^^T_^)J8*M"/*DBJDJ$Y<S;+_P#PF6@?
M\_\`_P"09/\`XFN+N[VWU#X@075K)YD+W4&UL$9QL!X//45TO_"O=)_Y^+W_
M`+[3_P")J6U\"Z9:7D%S'/=EX9%D4,ZX)!R,_+1*-6=DT@A.A3NXMG3T445U
M'&%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
F1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`'_]D4
`

#End
