#Version 8
#BeginDescription
V1.4__01/07/21__Will set hardware groupDescription
v1.3: 06.jul.2013: David Rueda (dr@hsb-cad.com)
Adds post base model ABU on selected post or studs
Models: ABU44, ABU46, ABU66, ABU88
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
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
*v1.3: 06.jul.2013: David Rueda (dr@hsb-cad.com): 
	- Renamed from GE_HDWR_ABU_POST_BASE to GE_HDWR_POST_BASE_ABU
*v1.2: 31.jul.2012: David Rueda (dr@hsb-cad.com): 
	- Added description
*v1.1: 31.jul.2012: David Rueda (dr@hsb-cad.com): 
	- Assigned to 'Z' zone (entity set) instead of 'T' (tooling zone - non plotable)
*v1.0: 10.apr.2012: David Rueda (dr@hsb-cad.com): 
	- Release: Copied from TH_ABU_POST_BASE v0.7 (28.feb.2012, David Rueda) 
	
	Previous history (from TH_ABU_POST_BASE v0.7 (28.feb.2012, David Rueda)
	*v0.7: 28.feb.2012: David Rueda (dr@hsb-cad.com): Modyfied to be used with Scott's VRez BOM rules, added indexing to th-items, spelling correction on exporting names.
	*V0.6_RL_June10 2010_rounds up for 2 or 3 pack studs
	*Verison 0.5 Will export proper rods
	*Version 0.4 Added some output. Will export a rod and nut as well
	*Version 0.3 Exports to Schedule
	*Version 0.2 Can associate it with multiple studs. No safety checks are made
	*Version 0.1 Applies post Base and export
*/

Unit(1,"inch");

String arTypes[]={"ABU44","ABU46","ABU66","ABU88"};
String arPostTaken[]={"4x4","4x6","6x6","8x8"};
double arDW[]={U(3.5625),U(3.5625),U(5.5),U(7.5)};
double arDL[]={U(3),U(5),U(5),U(7)};
double arDH[]={U(5.5),U(7),U(6.0625),U(7)};
double arDHoleOffset[]={U(1.75),U(2.625),U(1.75),U(2.625)};
double dThick=U(0.125);
PropString strType(0,arTypes,"Type");

String arFaces[]={"Default","Flipped"};
PropString strFace(1,arFaces,"Post Face");

PropDouble dRotation(0,0,"Free Rotation");

PropDouble dElev(1,U(0),"Elevation");

String arEmbed[]={"Concrete","Masony"};
double dEmbed[]={U(6),U(12)};
PropString strEmbed(2,arEmbed,"Embedment");

int iThItemIndex=1;

if(_bOnInsert){
	if(insertCycleCount()>1)eraseInstance();
	
	//showDialogOnce("_Default");
	PrEntity ssE("\nSelect a Post or a set of Studs",Beam());
	if (ssE.go())
	{
		Entity ents[0]; 
		ents = ssE.set(); 
		// turn the selected set into an array 
		for (int i=0; i<ents.length(); i++)
		{
			if (ents[i].bIsKindOf(Beam()))
			{
				Beam bm=(Beam)ents[i];
				if(bm.vecX().isParallelTo(_ZW)){
					_Beam.append(bm);
					
					Point3d arPts[]={bm.ptRef()+bm.vecX()*abs(bm.dLMax()),bm.ptRef()-bm.vecX()*abs(bm.dLMin())} ;
					arPts=Line(_Pt0,_ZW).orderPoints(arPts);
					dElev.set(_ZW.dotProduct(arPts[0]-_PtW));
					
					//break;
				}
			}
		}
	}
	if(_Beam.length()==0){
		_Pt0=getPoint("\nSelect and insertion point");
		showDialogOnce();
	}
	
}

String strPart1="X - Hardware",strPart2="X-Post-Bases";
String stLevel = "";

Group gr(strPart1,strPart2,"");
gr.dbCreate();
gr.setBIsDeliverableContainer(TRUE);
gr.addEntity(_ThisInst,TRUE);	

//Set some defaults to draw the Connector freely
CoordSys csToUse(_PtW,_XW,_YW,_ZW);
int nType= arTypes.find(strType);
double dRotateValue=dRotation;
if(strFace==arFaces[1])dRotateValue+=90;

Plane pnElev(_PtW+dElev*_ZW,_ZW);	
_Pt0=_Pt0.projectPoint(pnElev,U(0));	
	
//See if a beams exists to position _Pt0 and get proper type
if(_Beam.length()>0){
	Beam bm=_Beam[0];
	setDependencyOnEntity(bm);
	
	Group arG[] = bm.groups();
	for(int g=0;g<arG.length();g++) {stLevel = arG[g].namePart(0); break;}
	
	_Pt0=Line(bm.ptCen(),bm.vecX()).intersect(pnElev,U(0));
	
	csToUse=CoordSys(_Pt0,bm.vecY(),bm.vecZ(),bm.vecX());
	
	double arDs[0];
	if(_Beam.length()==1){
		arDs.append(bm.dW());
		arDs.append(bm.dH());
		Element el=_Beam[0].element();
		if(el.bIsValid()){
			assignToElementGroup(el,FALSE,0,'Z');
			//_Beam[0].setPanhand(el);
			_Beam[0].setColor(3);
		}
	}
	else{
		Point3d arPts[0];
		for(int b=0;b<_Beam.length();b++){
			arPts.append(_Beam[b].realBody().allVertices());
			Element el=_Beam[b].element();
			if(el.bIsValid()){
				assignToElementGroup(el,FALSE,0,'Z');
				//_Beam[b].setPanhand(el);
				_Beam[b].setColor(3);
			}
		}
		
		arPts=pnElev.projectPoints(arPts);
		Point3d ptMidAll;ptMidAll.setToAverage(arPts);
		_Pt0=Line(ptMidAll,csToUse.vecZ()).intersect(pnElev,U(0));	
		
		arPts=Line(csToUse.ptOrg(),csToUse.vecX()).orderPoints(arPts);
		arDs.append(csToUse.vecX().dotProduct(arPts[arPts.length()-1]-arPts[0]));
		
		
		
		arPts=Line(csToUse.ptOrg(),csToUse.vecY()).orderPoints(arPts);
		arDs.append(csToUse.vecY().dotProduct(arPts[arPts.length()-1]-arPts[0]));		
	}
	
	
	if(arDs[0]>arDs[1])arDs.swap(0,1);
	int nFirst=int(arDs[0]+U(0.75));
	if(nFirst==3)nFirst=4;
	if(nFirst==5)nFirst=6;
	
	
	String strMatch=nFirst+"x"+int(arDs[1]+U(0.75));
	
	nType=arPostTaken.find(strMatch);
	if(nType==-1){
		
		for(int t=0;t<arDL.length();t++){
			double arDCompare[]={arDW[t],arDL[t]};
			if(arDCompare[0]>arDCompare[1])arDCompare.swap(0,1);
			
			if(arDCompare[0]>=arDs[0] && arDCompare[1]>=arDs[1]){
				nType=t;
				break;
			}
		}
		
		if(nType==-1)nType= arTypes.find(strType);
	}
	else{
		strType.set(arTypes[nType]);
		strType.setReadOnly(TRUE);
		
		dRotation.set(U(0));
		dRotation.setReadOnly(TRUE);
		
	}
	
	
	
	dRotateValue=strFace==arFaces[1]?90:0;
	
	//Add cut to beam
	Cut ct(_Pt0+_ZW*U(1),-_ZW);
	for(int b=0;b<_Beam.length();b++)_Beam[b].addToolStatic(ct,TRUE);
}

CoordSys csRo;csRo.setToRotation(dRotateValue,_ZW,_Pt0);
csToUse.transformBy(csRo);

Point3d ptRefL=_Pt0+csToUse.vecX()*arDW[nType]/2,ptRefR=_Pt0-csToUse.vecX()*arDW[nType]/2;

Body bdBase(_Pt0,csToUse.vecX(),csToUse.vecY(),csToUse.vecZ(),arDW[nType],arDL[nType],dThick,0,0,1);
Body bdSideL(ptRefL,csToUse.vecX(),csToUse.vecY(),csToUse.vecZ(),dThick,arDL[nType],arDH[nType],1,0,1);
bdBase+=bdSideL;
Body bdSideR(ptRefR,csToUse.vecX(),csToUse.vecY(),csToUse.vecZ(),dThick,arDL[nType],arDH[nType],-1,0,1);
bdBase+=bdSideR;

//add holes
Point3d ptRefHole=_Pt0;
for(int i=0;i<2;i++){
	ptRefHole.transformBy(csToUse.vecZ()*arDHoleOffset[nType]);
	
	Body bdTub(ptRefHole+csToUse.vecX()*arDW[nType],ptRefHole-csToUse.vecX()*arDW[nType],U(0.3125));
	bdBase-=bdTub;
}
	
Body bdRod(_Pt0+U(1.5)*csToUse.vecZ(),_Pt0-(dEmbed[arEmbed.find(strEmbed)]+U(1.5))*csToUse.vecZ(),U(0.3125));
bdBase-=bdRod;

PLine plNut;
Point3d ptNutRef=_Pt0+dThick*csToUse.vecZ();
Vector3d vNut=csToUse.vecY();
CoordSys csWasher;csWasher.setToRotation(60,csToUse.vecZ(),_Pt0);
	
for(int w=0; w<6;w++){
	vNut.transformBy(csWasher);
	vNut.normalize();
	plNut.addVertex(ptNutRef+1.125*U(0.625)*vNut);
}
plNut.close();
	
Body bdNut(plNut,csToUse.vecZ()*U(.5),1);
bdNut-=bdRod;
	
Display dp(-1),dp2(-1);

dp2.showInDispRep("Engineering Components");

PLine plC;plC.createCircle(_Pt0,_ZW,U(2));
//dp.draw(plC);
dp.draw(bdBase);
dp2.draw(bdBase);
dp.draw(bdRod);
dp2.draw(bdRod);
dp.draw(bdNut);
dp2.draw(bdNut);	

Map mapDxaOut;
model(strType);
material("Post Base");
exportToDxi(TRUE);	

dxaout("Post Base",strType);
dxaout("TH-Item_"+iThItemIndex,strType);
iThItemIndex++;
mapDxaOut.appendString(strType,"Post Base");

String strRod="RFB#5x10";
if(strEmbed==arEmbed[1])strRod="RFB#5x16";
dxaout("TH-Item_"+iThItemIndex,strRod);
iThItemIndex++;
mapDxaOut.appendInt(strRod,1);

String strNut="5/8\" Nut";
dxaout("TH-Item_"+iThItemIndex,strNut);
iThItemIndex++;
mapDxaOut.appendInt(strNut,1);

double dEmbedBot=dEmbed[arEmbed.find(strEmbed)];
dxaout("Acrylic Tie Adhesive",dEmbedBot);
mapDxaOut.appendDouble("Acrylic Tie Adhesive",dEmbedBot);

_Map.setMap("MapDxaOut",mapDxaOut);


//Add Hadrware for export
HardWrComp arHwr[0];

HardWrComp hwr;
hwr.setName("Post Base");
hwr.setBVisualize(false);
hwr.setDescription("Post Base");
hwr.setArticleNumber(strType);
hwr.setModel(strType);
hwr.setQuantity(1);
hwr.setCountType("Amount");
hwr.setGroup(stLevel);
arHwr.append(hwr);

hwr.setName("Post Base Rod");
hwr.setBVisualize(false);
hwr.setDescription("Post Base Rod");
hwr.setArticleNumber(strRod);
hwr.setModel(strRod);
hwr.setQuantity(1);
hwr.setCountType("Amount");
hwr.setGroup(stLevel);
arHwr.append(hwr);

hwr.setName("Post Base Nut");
hwr.setBVisualize(false);
hwr.setDescription("Post Base Nut");
hwr.setArticleNumber(strNut);
hwr.setModel(strNut);
hwr.setQuantity(1);
hwr.setCountType("Amount");
hwr.setGroup(stLevel);
arHwr.append(hwr);

hwr.setName("Acrylic Tie Adhesive");
hwr.setBVisualize(false);
hwr.setDescription("Post Base Adhesive");
hwr.setArticleNumber("Acrylic Tie Adhesive");
hwr.setModel("Acrylic Tie Adhesive");
hwr.setQuantity(int(ceil(dEmbedBot)));
hwr.setCountType("Amount");
hwr.setGroup(stLevel);
arHwr.append(hwr);

_ThisInst.setHardWrComps(arHwr);
#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`/F`\H#`2(``A$!`Q$!_\0`
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
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*XKQ?_P`A:+_K@/\`T)J[
M6N*\7_\`(6B_ZX#_`-":N',/X)T8;^(<_1117@GHA1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110!;TO_D+67_7=/\`T(5YK7I6E_\`
M(6LO^NZ?^A"O-:^@R;X)^J.:M\04445[1B%%%%`!1110`4444`%?2E?-=?2E
M85NAE4Z!1116!D%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%<
M5XO_`.0M%_UP'_H35VM<5XO_`.0M%_UP'_H35PYA_!.C#?Q#GZ***\$]$***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`+>E_\`(6LO
M^NZ?^A"O-:]*TO\`Y"UE_P!=T_\`0A7FM?09-\$_5'-6^(****]HQ"BBB@`H
MHHH`****`"OI2OFNOI2L*W0RJ=`HHHK`R"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"N*\7_\A:+_`*X#_P!":NUKBO%__(6B_P"N`_\`0FKA
MS#^"=&&_B'/T445X)Z(4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`6]+_`.0M9?\`7=/_`$(5YK7I6E_\A:R_Z[I_Z$*\UKZ#)O@G
MZHYJWQ!1117M&(4444`%%%%`!1110`5]*5\UU]*5A6Z&53H%%%%8&04444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`5Q7B__`)"T7_7`?^A-7:UQ
M7B__`)"T7_7`?^A-7#F'\$Z,-_$.?HHHKP3T0HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`MZ7_R%K+_KNG_H0KS6O2M+_P"0M9?]
M=T_]"%>:U]!DWP3]4<U;X@HHHKVC$****`"BBB@`HHHH`*^E*^:Z^E*PK=#*
MIT"BBBL#(****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*XKQ?\`
M\A:+_K@/_0FKM:XKQ?\`\A:+_K@/_0FKAS#^"=&&_B'/T445X)Z(4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`6]+_P"0M9?]=T_]
M"%>:UZ5I?_(6LO\`KNG_`*$*\UKZ#)O@GZHYJWQ!1117M&(4444`%%%%`!11
M10`5]%"]42,D@Q@D9%?.M>\27$;74J-B-@Y`)/#<_I_+Z5SXB^EC*IT-P$$`
M@Y!HK)266`C:<`\XZ@U>ANTE.#\K>A/6N=23,BQ1115`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`5Q7B__D+1?]<!_P"A-7:UQ7B__D+1?]<!_P"A
M-7#F'\$Z,-_$.?HHHKP3T0HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`MZ7_R%K+_`*[I_P"A"O-:]*TO_D+67_7=/_0A7FM?09-\
M$_5'-6^(****]HQ"BBB@`HHHH`****`"O:KO_C]G_P"NC?SKQ6O:KO\`X_9_
M^NC?SK"MT,JG0(;EX1@892<E6''_`-:KL4L<_P!P[6_N,>?P/?\`G6917.XI
MF1NPW;Q#!^9?0GI5^*:.4?(W/IWKG8KUP<39D4GEC]X?CW_']*MHP=?,B;<!
MU(X*_6HUB!MT51AO6W!9!NR<9`YJ\#D`U::8!1113`****`"BBB@`HHHH`**
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
M%%`!1110`4444`%>U7?_`!^S_P#71OYUXK7M5W_Q^S_]=&_G6%;H95.A#111
M6)D%%%%`'(^-?^0C9?\`7H/_`$9)7IV@?\BYIG_7I%_Z`*\Q\:_\A&R_Z]!_
MZ,DKT[0/^1<TS_KTB_\`0!797_@0)6[-"BBBN(H****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*YO5?^0E+
M^'\A725S>J_\A*7\/Y"@"G1113`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@">&Z>(;3\\?]TGI]/2JNN^((-(L4E6*1YIMRQ*0-H9<9W'.<?,.
M@YQVZT^N;\:_\>6F_P#72;^4=:T*4:E5*2$W9%F[U&;5K6POIU1998#D)G'$
MCCN2>WK56DMO^0)I?_7!_P#T=)2U\SF"2Q51+NSU:'\-!1117&:A1110`444
M4`6]+_Y"UE_UW3_T(5YK7I6E_P#(6LO^NZ?^A"O-:^@R;X)^J.:M\04445[1
MB%%%%`!1110`4444`%>U7?\`Q^S_`/71OYUXK7M5W_Q^S_\`71OYUA6Z&53H
M0T445B9!1110!R/C7_D(V7_7H/\`T9)7IV@?\BYIG_7I%_Z`*\Q\:_\`(1LO
M^O0?^C)*].T#_D7-,_Z](O\`T`5V5_X$"5NS0HHHKB*"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"N;U7
M_D)2_A_(5TE<WJO_`"$I?P_D*`*=%%%,`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"N;\:_P#'EIO_`%TF_E'725S?C7_CRTW_`*Z3?RCKIPG\
M9?UT)EL-MO\`D":7_P!<'_\`1TE+26W_`"!-+_ZX/_Z.DI:^6S'_`'NIZL]6
MA_#B%%%%<1L%%%%`!1110!;TO_D+67_7=/\`T(5YK7I6E_\`(6LO^NZ?^A"O
M-:^@R;X)^J.:M\04445[1B%%%%`!1110`4444`%>U7?_`!^S_P#71OYUXK7M
M5W_Q^S_]=&_G6%;H95.A#1116)D%%%%`'(^-?^0C9?\`7H/_`$9)7IV@?\BY
MIG_7I%_Z`*\Q\:_\A&R_Z]!_Z,DKT[0/^1<TS_KTB_\`0!797_@0)6[-"BBB
MN(H****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`*YO5?^0E+^'\A725S>J_\A*7\/Y"@"G1113`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`KF_&O_`!Y:;_UTF_E'725S?C7_
M`(\M-_ZZ3?RCKIPG\9?UT)EL-MO^0)I?_7!__1TE+26W_($TO_K@_P#Z.DI:
M^6S'_>ZGJSU:'\.(4445Q&P4444`%%%%`%O2_P#D+67_`%W3_P!"%>:UZ5I?
M_(6LO^NZ?^A"O-:^@R;X)^J.:M\04445[1B%%%%`!1110`4444`%>U7?_'[/
M_P!=&_G7BM>U7?\`Q^S_`/71OYUA6Z&53H0T445B9!1110!R/C7_`)"-E_UZ
M#_T9)7IV@?\`(N:9_P!>D7_H`KS'QK_R$;+_`*]!_P"C)*].T#_D7-,_Z](O
M_0!797_@0)6[-"BBBN(H****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`*YO5?^0E+^'\A725S>J_\A*7\/Y"
M@"G1113`****`"BBB@`HHI&9(XGEEEBBB09>260(JC('))`ZD#\:$K@+14L<
M44T,4D-]9R^:/W82=27YQQV/((Z]J8\;Q-MD1D.,X88I7UL`VBBBF`4444`%
M%%%`!1110`5S?C7_`(\M-_ZZ3?RCKI*YOQK_`,>6F_\`72;^4==.$_C+^NA,
MMAMM_P`@32_^N#_^CI*6DMO^0)I?_7!__1TE+7RV8_[W4]6>K0_AQ"BBBN(V
M"BBB@`HHHH`MZ7_R%K+_`*[I_P"A"O-:]*TO_D+67_7=/_0A7FM?09-\$_5'
M-6^(****]HQ"BBB@`HHHH`****`"O:KO_C]G_P"NC?SKQ6O:KO\`X_9_^NC?
MSK"MT,JG0AHHHK$R"BBB@#D?&O\`R$;+_KT'_HR2O3M`_P"1<TS_`*](O_0!
M7F/C7_D(V7_7H/\`T9)7IV@?\BYIG_7I%_Z`*[*_\"!*W9H4445Q%!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!7-ZK_R$I?P_D*Z2N;U7_D)2_A_(4`4Z***8!1110`4444`%<GXXN9R
MMKIL99898_/F(/\`K/F(53[`H3[DCCY1765S'B>Q!U2*Z`8^?"NX]MR_+@?\
M!"G\?<5U8-I5;LF6Q8N8Q#(D"L'2&*.))!TD54"AQ[,`#^/>M&QUQX8A;7B&
MXMP-J=`\8S_">_T/H.U9TN7M+.8]6A"-CH"GR@?7:%)^ON*AKY2O.I1Q,VGK
M=GJPC&=-)HZRY@6$H\;%X95#QOC&0?ZU!46A7B36SZ7/(%+-NMV;.`W=>O&>
MWU/?%3$%6*L""#@@]J]O#UE6@I(X*D'"5A****V,PHHHH`****`"N;\:_P#'
MEIO_`%TF_E'725S?C7_CRTW_`*Z3?RCKIPG\9?UT)EL-MO\`D":7_P!<'_\`
M1TE+26W_`"!-+_ZX/_Z.DI:^6S'_`'NIZL]6A_#B%%%%<1L%%%%`!1110!;T
MO_D+67_7=/\`T(5YK7I6E_\`(6LO^NZ?^A"O-:^@R;X)^J.:M\04445[1B%%
M%%`!1110`4444`%>U7?_`!^S_P#71OYUXK7M5W_Q^S_]=&_G6%;H95.A#111
M6)D%%%%`'(^-?^0C9?\`7H/_`$9)7IV@?\BYIG_7I%_Z`*\Q\:_\A&R_Z]!_
MZ,DKT[0/^1<TS_KTB_\`0!797_@0)6[-"BBBN(H****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*YO5?^0E+
M^'\A725S>J_\A*7\/Y"@"G1113`****`"BBB@`JMJ5L+JPS_`!6[;QZ$-A3^
M.=OZU9IR-L;.`0000>X(P1^5.,N5W0&5:6AN;5[1642%A)%N/!8`@J/0G(_[
MY`^F;71FV\F4/$6V$YC;/(_^N*CU339+P"\MHPTV,3QHO).?O@=\\9QWY[UY
MN98?VC]K#?J=6&J\ON2,%69'5T8JRG((."#7671,AAN"%#3PI*P48`)'/ZUR
M5=-;HHT+3V"@,WF9(')^:N;+)/G<?(TQ:]U,2BBBO:.$****`"BBB@`KF_&O
M_'EIO_72;^4==)7-^-?^/+3?^NDW\HZZ<)_&7]="9;#;;_D":7_UP?\`]'24
MM);?\@32_P#K@_\`Z.DI:^6S'_>ZGJSU:'\.(4445Q&P4444`%%%%`%O2_\`
MD+67_7=/_0A7FM>E:7_R%K+_`*[I_P"A"O-:^@R;X)^J.:M\04445[1B%%%%
M`!1110`4444`%>U7?_'[/_UT;^=>*U[5=_\`'[/_`-=&_G6%;H95.A#1116)
MD%%%%`'(^-?^0C9?]>@_]&25Z=H'_(N:9_UZ1?\`H`KS'QK_`,A&R_Z]!_Z,
MDKT[0/\`D7-,_P"O2+_T`5V5_P"!`E;LT****XB@HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`KF]5_P"0
ME+^'\A725S>J_P#(2E_#^0H`IT444P"BBB@`HHHH`****`)8950A)`6B)R0.
MH]Q5Z&+?AX27`Y^7J/J.U9E%2U<#0DT6SU*5G>$I(Q#/)$VW/U!R.?I5>[>%
MC#'`7,<,2Q`MU..],:XG;[TTAX(Y8]#U%15$*48-M+5E.<FK-A1116I(4444
M`%%%%`!7-^-?^/+3?^NDW\HZZ2N;\:_\>6F_]=)OY1UTX3^,OZZ$RV&VW_($
MTO\`ZX/_`.CI*6DMO^0)I?\`UP?_`-'24M?+9C_O=3U9ZM#^'$****XC8***
M*`"BBB@"WI?_`"%K+_KNG_H0KS6O2M+_`.0M9?\`7=/_`$(5YK7T&3?!/U1S
M5OB"BBBO:,0HHHH`****`"BBB@`KVJ[_`./V?_KHW\Z\5KVJ[_X_9_\`KHW\
MZPK=#*IT(:***Q,@HHHH`Y'QK_R$;+_KT'_HR2O3M`_Y%S3/^O2+_P!`%>8^
M-?\`D(V7_7H/_1DE>G:!_P`BYIG_`%Z1?^@"NRO_``($K=FA1117$4%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%<WJO_`"$I?P_D*Z2N;U7_`)"4OX?R%`%.BBBF`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!7-^-?^/+3?\`KI-_*.NDKF_&O_'EIO\`
MUTF_E'73A/XR_KH3+8;;?\@32_\`K@__`*.DI:2V_P"0)I?_`%P?_P!'24M?
M+9C_`+W4]6>K0_AQ"BBBN(V"BBB@`HHHH`MZ7_R%K+_KNG_H0KS6O2M+_P"0
MM9?]=T_]"%>:U]!DWP3]4<U;X@HHHKVC$****`"BBB@`HHHH`*]JN_\`C]G_
M`.NC?SKQ6O:KO_C]G_ZZ-_.L*W0RJ="&BBBL3(****`.1\:_\A&R_P"O0?\`
MHR2O3M`_Y%S3/^O2+_T`5YCXU_Y"-E_UZ#_T9)7IV@?\BYIG_7I%_P"@"NRO
M_`@2MV:%%%%<104444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`5S>J_\A*7\/Y"NDKF]5_Y"4OX?R%`%.BBB
MF`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!7-^-?\`CRTW_KI-
M_*.NDKF_&O\`QY:;_P!=)OY1UTX3^,OZZ$RV&VW_`"!-+_ZX/_Z.DI:2V_Y`
MFE_]<'_]'24M?+9C_O=3U9ZM#^'$****XC8****`"BBB@"WI?_(6LO\`KNG_
M`*$*\UKTK2_^0M9?]=T_]"%>:U]!DWP3]4<U;X@HHHKVC$****`"BBB@`HHH
MH`*]JN_^/V?_`*Z-_.O%:]JN_P#C]G_ZZ-_.L*W0RJ="&BBBL3(****`.1\:
M_P#(1LO^O0?^C)*].T#_`)%S3/\`KTB_]`%>8^-?^0C9?]>@_P#1DE>G:!_R
M+FF?]>D7_H`KLK_P($K=FA1117$4%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%<WJO_(2E_#^0KI*YO5?
M^0E+^'\A0!3HHHI@%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`5
MS?C7_CRTW_KI-_*.NDKF_&O_`!Y:;_UTF_E'73A/XR_KH3+8;;?\@32_^N#_
M`/HZ2EI+;_D":7_UP?\`]'24M?+9C_O=3U9ZM#^'$****XC8****`"BBB@"W
MI?\`R%K+_KNG_H0KS6O2M+_Y"UE_UW3_`-"%>:U]!DWP3]4<U;X@HHHKVC$*
M***`"BBB@`HHHH`*]JN_^/V?_KHW\Z\5KVJ[_P"/V?\`ZZ-_.L*W0RJ="&BB
MBL3(****`.1\:_\`(1LO^O0?^C)*].T#_D7-,_Z](O\`T`5YCXU_Y"-E_P!>
M@_\`1DE>G:!_R+FF?]>D7_H`KLK_`,"!*W9H4445Q%!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!7-ZK_
M`,A*7\/Y"NDKF]5_Y"4OX?R%`%.BBBF`4444`%%%%`!115'5]7M]$TY[J=/-
M<D+#`)-AE;(S@X/`!))QZ#N*J$'.2C'=@7J*U]-L[74-&M+KRGC:XA27[^2N
MX`XSC!ZXZ5!>:7);@O'F2(#)/=:EJSLP,^BBB@`HHHH`****`"BBB@`KF_&O
M_'EIO_72;^4==)7-^-?^/+3?^NDW\HZZ<)_&7]="9;#;;_D":7_UP?\`]'24
MM);?\@32_P#K@_\`Z.DI:^6S'_>ZGJSU:'\.(4445Q&P4444`%%%%`%O2_\`
MD+67_7=/_0A7FM>E:7_R%K+_`*[I_P"A"O-:^@R;X)^J.:M\04445[1B%%%%
M`!1110`4444`%>U7?_'[/_UT;^=>*U[5=_\`'[/_`-=&_G6%;H95.A#1116)
MD%%%%`'(^-?^0C9?]>@_]&25Z=H'_(N:9_UZ1?\`H`KS'QK_`,A&R_Z]!_Z,
MDKT[0/\`D7-,_P"O2+_T`5V5_P"!`E;LT****XB@HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`KF]5_P"0
ME+^'\A725S>J_P#(2E_#^0H`IT444P"BBB@`HHHH`*XWQD?M.L06_P`^VW@4
M%2?EW-\^1_P$H"?]GV%=E6+XCM?-:RN,_P`#0[<?W3NS_P"/_I73A)J-2Y,M
MCT#394GTNTECA6%'A1EB7H@*@A1[#I5JN?\`!]PCZ*MJ!A[=B#[AB2#_`#'X
M5T%<\U:312,76+/8WVF,`*3AP!W]?\_UK)KKI(TEC:.10RL,$&N6N(6M[AXF
MZJ>OJ.QI`14444`%%%%`!1110`5S?C7_`(\M-_ZZ3?RCKI*YOQK_`,>6F_\`
M72;^4==.$_C+^NA,MAMM_P`@32_^N#_^CI*6DMO^0)I?_7!__1TE+7RV8_[W
M4]6>K0_AQ"BBBN(V"BBB@`HHHH`MZ7_R%K+_`*[I_P"A"O-:]*TO_D+67_7=
M/_0A7FM?09-\$_5'-6^(****]HQ"BBB@`HHHH`****`"O:KO_C]G_P"NC?SK
MQ6O:KO\`X_9_^NC?SK"MT,JG0AHHHK$R"BBB@#D?&O\`R$;+_KT'_HR2O3M`
M_P"1<TS_`*](O_0!7F/C7_D(V7_7H/\`T9)7IV@?\BYIG_7I%_Z`*[*_\"!*
MW9H4445Q%!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!7-ZK_R$I?P_D*Z2N;U7_D)2_A_(4`4Z***8!11
M10`4444`%))"+JUEM\98@,@_VA_7!8`>I%+133L[@1Z+<'3KL-_RR?"R#)Z>
MOU'^-=>]Q$B!BX((R,<YKFFC$^9A]\DF0?\`LWX_S^H%7;9U\H0R@@#[K@<C
MGD'U%*I*^H(MS7DCDA#L7VZUGZDOS02!<*T8&?4C@_TJT\3Q_>''9AT/XU7U
M,XCMHOX@I;VP3Q_*LH-WU`SZ***U`****`"BBB@`KF_&O_'EIO\`UTF_E'72
M5S?C7_CRTW_KI-_*.NG"?QE_70F6PVV_Y`FE_P#7!_\`T=)2TEM_R!-+_P"N
M#_\`HZ2EKY;,?][J>K/5H?PXA1117$;!1110`4444`6]+_Y"UE_UW3_T(5YK
M7I6E_P#(6LO^NZ?^A"O-:^@R;X)^J.:M\04445[1B%%%%`!1110`4444`%>U
M7?\`Q^S_`/71OYUXK7N]Y;I+<2,/E;<>@X/7_P"M7/7:5KF53H9E%22PO"V&
M'&>&'0_2HZR,@HHHH`Y'QK_R$;+_`*]!_P"C)*].T#_D7-,_Z](O_0!7F/C7
M_D(V7_7H/_1DE>G:!_R+FF?]>D7_`*`*[*_\"!*W9H4445Q%!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
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
M;+L-12"BBBN<84444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`R6*.9"DB!E]#6/<Z-(I+0,&!)PAX('IGO6W10!R!!5BK`@@
MX(/:DKJ;BT@NEQ*@)QPPX(_&L2ZTN>V4NN)(P,DC@CZBF!1HHHH`****`"BB
MB@`HHHH`*YOQK_QY:;_UTF_E'725S?C7_CRTW_KI-_*.NG"?QE_70F6QT7A;
M_D5=._W9/_1CUKUD>%O^15T[_=D_]&/6O7'B/XTO5E+8****Q&%%%%`!115>
M\OK33X?-O+F.!#T+'ENG0#D]1T'&:<8N3L@+%9NJZ]8:/&WGS*]P!E;=#EV/
M&,_W>H.3VZ9Z5RFK^-KB<M#I8-O"1CS74>:>.<<D+U[<\9R,XJ;1O`NHZL_V
MS5)9+6-W)82`F9SGDD'IGGD\^Q!KT*>"4%SUW9=B'+L96H:]JWB"5[.%7\F5
MMR6L*;B0!G!(&YNF3VR,X&!CJ=!^'<:()];.]S@K;Q.0H&/XB.2<GL<<=3FN
MPTK1['1K5;>R@5!@!GP-\F,\L>_4_3/&*O5<\59<E)60*/<C@MX;6%8;>&.&
M)?NI&H51WX`J2BBN,H****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`*5WID%R"P`CD)^\HZ_45B
M75E/:$>8HVDX#*<@UU%(0&4JP!!&"#WH`Y"BMV[T=)3OMR(V[J>A_P`*Q'C>
M)MLB,AQG##%,!M%%%`!1110`5S?C7_CRTW_KI-_*.NDKF_&O_'EIO_72;^4=
M=.$_C+^NA,MCHO"W_(JZ=_NR?^C'K7K(\+?\BKIW^[)_Z,>M>N/$?QI>K*6P
M444`$D`#)-8C"@D*C.Q"HH+,Q.`H'4D]A6+K'B>PT=O*S]JN><Q1.,(0<$.W
M.T]>,$\<XKC1_;7C'440*9-IP-J[8H`<GDCITZG).`.:[*.#G-<T]$2Y6.@U
M;QO;0H\6EJ9I2,"=UPBGCD*1EN_7`R.XK'TW0M;\777VJ>5Q#WN9P=N-QR$'
M?'S<#`'3BNPT+P#8Z<RW&H,M[<8^XRCRER!V/WL<\GUZ`UU]=/MJ=%<M%:]Q
M6;W,+0?"FG:"@>-?/NC@FXE4;@<8.W^Z.3[\\DUNT45R2G*;O)E!1114@%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%,EBCF0I(@9?0T^B@##NM&>-2\#%U`S
MM/WOP]:S""K%6!!!P0>U=?4%S9PW:XD7YNS#J/QH`Y:BKUWIDUL-P_>1^JCD
M?451I@%<WXU_X\M-_P"NDW\HZZ2N;\:_\>6F_P#72;^4==.$_C+^NA,MCHO"
MW_(JZ=_NR?\`HQZUZQ/#UQ!9^#K"XN9DAA"R#>YP"?,<X'J<#H.:PM9\;._F
MVVEIL3E?M3$[STY0?P]^3D]#\IK*6&J5JTN5:7>H[I(ZC4=;T_2HV:ZN!O4@
M>3&0TG(R/ER,#'.3@?I7%ZEXFU/7G%E8P20QOD>3;EGDD&.0Q'4=>``,=<XS
M4`T-QBZU:Y=)),N\&UO/)R?O[@`N<$YY/(.#FB]O6\@V\"K;VVU5,<:A2X7&
M"Y`&\\9R>Y.,9KNHX>E3>FK[DMME&;[#HL^YY8]1N(GRJ1#]QD'C<S#+C(Y4
M``@\-7L/APAO#.ER;(T,EK'(PC0(NYE#$@``#))/%>#WO>O=_#/_`"*FC_\`
M7C#_`.@"GCHVIQ8H[FI1117EF@4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%4KO3(;D[A^[D]5'!^HJ[10!R]W9RVDA#@E,\.!P?
M_KUR?C7_`(\M-_ZZ3?RCKU,@,I5@"",$'O7,ZO96,EY'OME=H&<JL@#1C>%R
M=I'/3OP,_3&U"HJ=128FKH\\L-'O]7B@:9O(LX4V1RR(<%=Y)"8'S');V[$C
MBNAMK:#28%CLU_>`EC<NJ^:20`=K`94<=`3U/)K4N':1BSL68]23DUGS]ZWE
MB)5';9"M8R[CO61==ZU[CO61==ZZ:1+,2]Z5[OX9_P"14T?_`*\8?_0!7A%[
MTKW?PS_R*FC_`/7C#_Z`*,P_AQ]0AN:E%%%>2:!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%<[JG_'_+^'\A715SNJ?\?\
MOX?R%`&7+5"?O5^6J$_>MJ8F9=QWK(NN];%QWK'NN]>A2(9B7O2O=_#/_(J:
M/_UXP_\`H`KPB]Z&O=_#/_(J:/\`]>,/_H`HS#^''U"&YJ4445Y)H%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`5SNJ?\?\
MOX?R%=%7.ZI_Q_R_A_(4`9<O2J$_>K\O2J$YZUM3$S,N.]9%SWK6N#UK)N>]
M>A2(9AWO0U[OX9_Y%31_^O&'_P!`%>$7G0U[OX9_Y%71_P#KQA_]`%&8?PX^
MH0W-2BBBO)-`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"N=U3_`(_Y?P_D*Z*N=U3_`(_Y?P_D*`,N7I6?/WK0EZ50G[UO
M3$S+N:R;GO6M<]ZR;GO7?2(9AWO0U[OX:_Y%71_^O&'_`-`%>$7O0U[OX:_Y
M%71_^O&'_P!`%&8?PX^H0W-2BBBO)-`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"N=U3_C_E_#^0KHJYW5/^/^7\/Y"@#+
MEJA/WJ_+5"?O6],3,NX[UD7)QFM>X[UD77>N^D0S$O.AKW?PU_R*NC_]>,/_
M`*`*\(O.AKW?PU_R*NC_`/7E#_Z`*,P_AQ]0AN:E%%%>2:!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%<[JG_'_+^'\A71
M5SNJ?\?\OX?R%`&7+5"?O5^6J$_>MJ8F9=QWK(NN];%QWK(NN]>A2(9AWG0U
M[OX:_P"15T?_`*\H?_0!7A-YT->[>&O^15T?_KRA_P#0!1F'\./J$-S4HHHK
MR30****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`KG=4_X_P"7\/Y"NBKG=4_X_P"7\/Y"@#+EJA/WK0EZ5G3]ZVIB9FW'>LBY
M[UK7-9-SWKT*1#,.\/!KW?PU_P`BKH__`%Y0_P#H`KP>]KWCPU_R*NC_`/7E
M#_Z`*,P_AQ]0AN:E%%%>2:!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%<[JG_'_+^'\A715SNJ?\?\OX?R%`&9+TK.G[UH
MR]*SI^];TQ,S+FLFY[UK7-9-SWKOI$,P[WO7N_AK_D5='_Z\H?\`T`5X1>]Z
M]W\-?\BKH_\`UY0_^@"C,/X<?4(;FI1117DF@4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!7.ZI_P`?\OX?R%=%7.ZI_P`?
M\OX?R%`&9+TK/G[U?EJA/WK:F)F7<=ZR;GO6M<=ZR+DXS7H4B&8E[WKW?PU_
MR*NC_P#7E#_Z`*\(O>AKW?PU_P`BKH__`%Y0_P#H`HS#^''U"&YJ4445Y)H%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`5S
MNJ?\?\WX?R%=%7.ZI_Q_S?A_(4`9<M4)^]7Y:H3]ZVIB9EW'>LBZ[UL7'>L>
MZ[UZ%(AF)>=#7N_AK_D5=(_Z\H?_`$`5X1>=#7N_AK_D5=(_Z\H?_0!1F'\.
M/J$-S4HHHKR30****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`KG=4_P"/^;\/Y"NBKG=4_P"/^;\/Y"@#+EJA/WJ_+6?/WK:F
M)F;<=ZQ[GO6O<5D7/>O0I$,Q+SH:]W\-?\BKI'_7E#_Z`*\(O.AKW?PU_P`B
MKI'_`%Y0_P#H`HS#^''U"&YJ4445Y)H%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`5SNJ?\?\WX?R%=%7.ZI_Q_S?A_(4`9
M<M9\_>M"7I5"?O6],3,NYK)N>]:USWK)N>]=](AF'>=#7N_AK_D5=(_Z\H?_
M`$`5X1>=#7N_AK_D5M(_Z\H?_0!1F'\./J$-S4HHHKR30****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`KG=4_P"/^;\/Y"NB
MKG=4_P"/^;\/Y"@#+EZ50G[U?EZ50G[UO3$S+N.]9-SWK6N.]9-ST-=](AF)
M>=#7NWAK_D5M(_Z\H?\`T`5X3>=#7NWAK_D5M(_Z\H?_`$`49A_#CZA#<U**
M**\DT"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`*YW5/^/^;\/Y"NBKG=4_X_YOP_D*`,N7O5"?O5^6J$_>MJ8F9EQWK'NN
M];%QWK'NN]>A2(9B7AX->[^&O^16TC_KRA_]`%>#WG>O>/#?_(K:1_UY0_\`
MH`HS#^''U"&YJ4445Y)H%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`5SNJ?\?\`-^'\A715S-ZS/=SECD[R/P'`H`SY:H3]
MZORUGS]ZVIB9F7'>LBZ[UKW%9%SWKT*1#,2\[U[OX;_Y%;2/^O*'_P!`%>$7
MO0U[OX:Y\*Z1_P!>4/\`Z`*,P_AQ]0AN:E%%%>2:!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%<O=_\?4__71OYUU%<O=_
M\?4__71OYT`49:SY^]:$M9\_>MZ8F9EQ63<]ZUKCO63<]Z[Z1#,.]Z'Z5[OX
M9_Y%31_^O&'_`-`%>$7O0_2O=_#/_(J:/_UXP_\`H`HS#^%'U"&YJ4445Y)H
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`5
MR]W_`,?4_P#UT;^==17+W?\`Q]3_`/71OYT`4I>E9\_>M"7I6?/WK:F)F7<=
MZR;GO6M<=ZR;GO7H4B&8=[T->[^&?^14T?\`Z\8?_0!7A%[T->[^&?\`D5-'
M_P"O&'_T`49A_"CZA#<U****\DT"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`*Y>[_X^I_^NC?SKJ*Y>Z_X^I_^NC?SH`HR
MU0G[U?EJA/T-;4Q,S+CO61<]ZU[CO6/==Z]"D0S$O>AKW?PU_P`BKH__`%XP
M_P#H`KPB]^Z:]W\-?\BKH_\`UXP_^@"C,/X<?4(;FI1117DF@4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!7+W7_'U/_P!=
M&_G745R]U_Q]3_\`71OYT`49:H3GK5^6L^?O6U,3,RX/6LBZ[UKW'4UD7/>O
M0I$,Q+WH:]W\-?\`(JZ/_P!>,/\`Z`*\(O/NFO=_#7_(JZ/_`->,/_H`HS#^
M''U"&YJ4445Y)H%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`5R]U_Q]3_\`71OYUU%<O=?\?4__`%T;^=`%&6J$_>K\M4)^
M];4Q,R[CJ:R+GO6O<=ZR+GO7H4B&8EY]TU[OX:_Y%71_^O&'_P!`%>$7OW37
MN_AK_D5='_Z\8?\`T`49A_#CZA#<U****\DT"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*Y>Z_X^I_^NC?SKJ*Y>Z_X^I_
M^NC?SH`HRU0G[UH2]*SY^];TQ,R[CO63<]ZUKCO63<]Z[Z1#,.\^Z:]W\-?\
MBKH__7C#_P"@"O![SO7O'AK_`)%71_\`KQA_]`%&8?PX^H0W-2BBBO)-`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"N7NO
M^/J?_KHW\ZZBN7NO^/J?_KHW\Z`*4O2L^?O5^6J$_>MJ8F9EQWK(N>AK7N.]
M9%R>#7H4B&85YWKWCPU_R*NC_P#7E#_Z`*\(O.]>[^&O^15T?_KRA_\`0!1F
M'\./J$-S4HHHKR30****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`KG-114OI@HP,Y_$@$UT=<[JG_`!_R_A_(4`9<M9\YZUH2
MUGS]ZWIB9F7!ZUD7/>M>X[UD7/>N^D0S$O.AKW?PU_R*NC_]>4/_`*`*\(O.
MAKW?PU_R*NC_`/7E#_Z`*,P_AQ]0AN:E%%%>2:!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%<_JJLM\Y(X8`CZ8Q_2N@JE
M?Z>+P!E;;(!@$]#[4`<M+WK/G[UK7=K/;Y\V)E&<9QQ^?2LJ?O6U,3,NX[UD
M7/>M>X[UF/!-<RB&")Y96SM2-2Q/?@"O0I$,P+SH:]\T.VEL_#^FVLZ;)H;6
M*.1<@X8(`1D<=17`>'_`%W<7MO>ZLBPVJ,)/L[`,\F,$!AT"GN#SP1@9S7IU
M8XVM&:4(]!Q04445YY84444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`C*&4JP!4C!!Z&JDVDV$Z;7M(L9S\HVG\QBKE%
M%[`9B>'M)242"S1F'9V+#\B<5<M[.UM-WV:VAAWXW>6@7..F<5/13<F]V`44
M44@"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
5**`"BBB@`HHHH`****`"BBB@#__9
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
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End