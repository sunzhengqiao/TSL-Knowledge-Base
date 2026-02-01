#Version 8
#BeginDescription
v1.5: 03.nov.2013: David Rueda (dr@hsb-cad.com)
Places horizontal lumber piece between a post and a wall
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
//////////////////////////////////		COPYRIGHT				//////////////////////////////////  
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
* v1.5: 03.nov.2013: David Rueda (dr@hsb-cad.com)
	- Stickframe path added to mapIn when calling dll
* v1.4: 15.may.2012: David Rueda (dr@hsb-cad.com)
	- Thumbnail added
	- Description added
* v1.3: 25.jan.2012: David Rueda (dr@hsb-cad.com)
	- Updated grade and material info from inventory
	- Added some beam props to manual definition
* v1.2: 20.jul.2011: David Rueda (dr@hsb-cad.com)
	- Added beam info set by user
* v1.1: 17.jul.2011: David Rueda (dr@hsb-cad.com)
	- Debugged
* v1.0: 15.jul.2011: David Rueda (dr@hsb-cad.com)
	- Release
*/

String sLumberItemKeys[0];
String sLumberItemNames[0];

// Calling dll to fill item lumber prop.
Map mapIn;

//Setting info
String sCompanyPath = _kPathHsbCompany;
mapIn.setString("CompanyPath", sCompanyPath);

String sStickFramePath= _kPathHsbWallDetail;
mapIn.setString("StickFramePath", sStickFramePath);

String sInstallationPath			= 	_kPathHsbInstall;
mapIn.setString("InstallationPath", sInstallationPath);

String sAssemblyFolder			=	"\\Utilities\\hsbFramingDefaultsEditor";
String sAssembly					=	"\\hsbFramingDefaults.Inventory.dll";
String sAssemblyPath 			=	sInstallationPath+sAssemblyFolder+sAssembly;
String sNameSpace				=	"hsbSoft.FramingDefaults.Inventory.Interfaces";
String sClass						=	"InventoryAccessInTSL";
String sClassName				=	sNameSpace+"."+sClass;
String sFunction					=	"GetLumberItems";

Map mapOut = callDotNetFunction2(sAssemblyPath, sClassName, sFunction, mapIn);

// filling lumber items
for( int m=0; m<mapOut.length(); m++)
{
	String sKey= mapOut.keyAt(m);
	String sName= mapOut.getString(sKey+"\NAME");
	if( sKey!="" && sName!="")
	{
		sLumberItemKeys.append( sKey );
		sLumberItemNames.append( sName);
	}
}

String sTab="     ";
// OPM 
PropString sEmpty0(0,"","General");
sEmpty0.setReadOnly(true);

	PropInt nBeams(0, 1, sTab+T("|Number of beams to place|"));
	String sAlign[]={T("|Left to right|"),T("|Centered|"),T("|Right to left|")};
	PropString sDistribution(1, sAlign, sTab+T("|Distribution|"), 1);
	int nDistribution= sAlign.find( sDistribution, 1);

PropString sEmpty1(2,"",T("|Beam info|"));
sEmpty1.setReadOnly(true);

	PropString sEmpty2(3, "  ", sTab+T("|Auto|"));
	sEmpty2.setReadOnly(true);
	
		PropString sLumberItem(4, sLumberItemNames, sTab+sTab+T("|Lumber item|"),0);

	PropString sEmpty3(5, T("|Following values override info from inventory if NOT empty|"), sTab+T("|Manual|"));
	sEmpty3.setReadOnly(true);
	
		double dReal[0];// Real sizes
		String sNominal[0];// Nominal sizes
		dReal.append(U(19.05,0.75));		sNominal.append("1");		//index:	0
		dReal.append(U(38.10,1.50));		sNominal.append("2");		//index:	1
		dReal.append(U(63.50,2.50));		sNominal.append("3");		//index:	2
		dReal.append(U(88.90,3.50));		sNominal.append("4");		//index:	3
		dReal.append(U(139.70,5.50));	sNominal.append("6");		//index:	4
		dReal.append(U(184.15,7.25));	sNominal.append("8");		//index:	5
		dReal.append(U(234.95,9.25));	sNominal.append("10");		//index:	6
		dReal.append(U(285.75,11.25));	sNominal.append("12");		//index:	7
		dReal.append(U(336.55,13.25));	sNominal.append("14");		//index:	8
		dReal.append(U(387.35,15.25));	sNominal.append("16");		//index:	9
		
		//Filling nominal sizes
		String sarBmS[0];//Nominals FOR 2" WIDTH ONLY 
		for(int i=0;i<sNominal.length();i++){
			sarBmS.append("2x"+sNominal[i]);
		}
		sarBmS.append(T("|From inventory|"));

		PropString sSizeOPM(6, sarBmS, sTab+sTab+T("|Beam size|"), sarBmS.length()-1);
		PropInt 	nColorOPM(1, 32, sTab+sTab+T("|Beam color|"));
		String arBmTypes[0]; arBmTypes.append(_BeamTypes);
		PropString sTypeOPM(7, arBmTypes, sTab+sTab+T("|Beam type|"),12);
		int nType= arBmTypes.find( sTypeOPM);
		PropString sNameOPM(8, "", sTab+sTab+T("|Name|"));
		PropString sMaterialOPM(9, "", sTab+sTab+T("|Material|"));
		PropString sGradeOPM(10, "", sTab+sTab+T("|Grade|"));
		PropString sInformationOPM(11, "", sTab+sTab+T("|Information|"));
		PropString sLabelOPM(12, "", sTab+sTab+T("|Label|"));
		PropString sSubLabelOPM(13, "", sTab+sTab+T("|Sublabel|"));
		PropString sSubLabel2OPM(14, "", sTab+sTab+T("|Sublabel2|"));
		PropString sBeamCodeOPM(15, "", sTab+sTab+T("|Beam code|"));

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey); 
	
if(_bOnInsert){
	
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	
	_Beam.append(getBeam(T("|Select post|")));
	
	_Element.append(getElement(T("|Select wall|")));

	showDialog();
	
	return;
}

if(_Beam.length()==0 || _Element.length()==0 )
{
	eraseInstance();
	return;	
}

// Setting props
// Get props from inventory
String sMaterialFromInventory, sGradeFromInventory, sLumberItemName;
double dWFromInventory, dHFromInventory;
int nIndex=sLumberItemNames.find(sLumberItem,-1);
for( int m=0; m<mapOut.length(); m++)
{
	String sSelectedKey= sLumberItemKeys[nIndex];
	String sKey= mapOut.keyAt(m);
	if( sKey==sSelectedKey)
	{
		dWFromInventory= mapOut.getDouble(sKey+"\WIDTH");
		dHFromInventory= mapOut.getDouble(sKey+"\HEIGHT");
		sMaterialFromInventory= mapOut.getString(sKey+"\HSB_MATERIAL");
		sGradeFromInventory= mapOut.getString(sKey+"\HSB_GRADE");
		sLumberItemName= mapOut.getString(sKey+"\NAME");
		break;
	}
}

int nColor=nColorOPM;
if (nColor > 255 || nColor < -1) 
{
	nColor=32;
	nColorOPM.set(32);
}

String sMaterial, sGrade;
double dW, dH;

int nSizeIndex=sarBmS.find(sSizeOPM);
if(nSizeIndex==sarBmS.length()-1) // Last value on sarBmS (From inventory)
{
	sMaterial=sMaterialFromInventory;
	if(sMaterialOPM!="")
		sMaterial=sMaterialOPM;
	sGrade=sGradeFromInventory;
	if(sGradeOPM!="")
		sGrade=sGradeOPM;
	dW=dWFromInventory;
	dH=dHFromInventory;
}
else
{
	sMaterial=sMaterialOPM;
	sGrade=sGradeOPM;
	dW=U(38.1, 1.5);
	dH=dReal[nSizeIndex];
}	

String sName=sNameOPM;
String sInformation=sInformationOPM;
String sLabel=sLabelOPM;
String sSubLabel=sSubLabelOPM;
String sSubLabel2=sSubLabel2OPM;
String sBeamCode=sBeamCodeOPM;

if( dW==0 || dH==0)
{
	reportError("\nData incomplete, check values on inventory for selected lumber item"+
		"\nName: "+sLumberItemName+"\nMaterial: "+sMaterial+"\nGrade: "+ sGrade+"\nWidth: "+ dW+"\nHeight: "+ dH);
	eraseInstance();
	return;
}

// Getting info from element
Element el= _Element[0];
if (!el.bIsValid())
{
	eraseInstance();
	return;
}

CoordSys csEl=el.coordSys();
Point3d ptElOrg=csEl.ptOrg();
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();

// Getting info from post
Beam bmPost= _Beam[0];
Point3d ptPostCen= bmPost.ptCen();
Vector3d vBmPostX= bmPost.vecX();
if(vBmPostX.dotProduct(_ZW)<0)
	vBmPostX= vBmPostX;
Vector3d vBmPostY= bmPost.vecD(vz);
if( vBmPostY.dotProduct( ptElOrg- ptPostCen)<0)
{
	vBmPostY= -vBmPostY;
}
Vector3d vBmPostZ= vBmPostX.crossProduct( vBmPostY);

vBmPostX.vis(bmPost.ptCen(),1);
vBmPostY.vis(bmPost.ptCen(),2);
vBmPostZ.vis(bmPost.ptCen(),3);

// Verify alignment on post. NOTICE: won't check if it's beam type POST
if(!vBmPostX.isParallelTo(_ZW))
{
	reportMessage("\nPost is not vertical, tsl will be erased");
	eraseInstance();
	return;	
}

// Check if selected number will fit on post
double dRequired= nBeams*dW;
double dAvailable= bmPost.dD(vx);
int nMaxDiference;
if( nDistribution==1)
{
	nMaxDiference=2*dW;
}
else
{
	nMaxDiference=1*dW;
}
	
if( dRequired-dAvailable > nMaxDiference )
{
	reportMessage(T("|Selected number of beams are not suitable on post|"));
	eraseInstance();
	return;	
}

// Ready to create beams
Beam bmCreated[0];
int nNewBeams=nBeams;
double dNewBmH=dW;
Point3d ptCen= ptPostCen+vBmPostX*(bmPost.dL()*.5+dH*.5)-vBmPostY*bmPost.dD(vBmPostY)*.5;
Point3d ptNewBmCenter=ptCen;
Vector3d vBmX=vBmPostY;
Vector3d vBmY=vBmPostZ;
Vector3d vBmZ=vBmX.crossProduct(vBmY);
// Define start point
if( nDistribution==0) // Left to right
{
	Vector3d vDir= vBmPostZ;
	ptNewBmCenter-= vDir*(bmPost.dD(vDir)*.5-dNewBmH*.5);
	for( int n=0; n<nNewBeams; n++)
	{
		Beam bmNew;
		bmNew.dbCreate(ptCen, vBmX, vBmY, vBmZ, U(50, 2), dW, dH, 1, 0, 0);
		bmNew.transformBy(vBmPostZ*vBmPostZ.dotProduct(ptNewBmCenter-bmNew.ptCen()));		
		bmCreated.append(bmNew);
		ptNewBmCenter+=vDir*dNewBmH;
	}
}
else if( nDistribution==1) // Centered
{
	ptNewBmCenter+=vx*.5*dNewBmH*(1-(nNewBeams%2));	
	for( int n=0; n<nNewBeams; n++)
	{
		int nSign;
		if(n%2==0)
			nSign=1;
		else
			nSign=-1;
		ptNewBmCenter+=vBmPostZ*dNewBmH*n*nSign;
		Beam bmNew;
		bmNew.dbCreate(ptCen, vBmX, vBmY, vBmZ, U(50, 2), dW, dH, 1, 0, 0);
		bmNew.transformBy(vBmPostZ*vBmPostZ.dotProduct(ptNewBmCenter-bmNew.ptCen()));		
		bmCreated.append(bmNew);
	}
}
else 
{
	Vector3d vDir= -vBmPostZ;
	ptNewBmCenter-= vDir*(bmPost.dD(vDir)*.5-dNewBmH*.5);
	for( int n=0; n<nNewBeams; n++)
	{
		Beam bmNew;
		bmNew.dbCreate(ptCen, vBmX, vBmY, vBmZ, U(50, 2), dW, dH, 1, 0, 0);
		bmNew.transformBy(vBmPostZ*vBmPostZ.dotProduct(ptNewBmCenter-bmNew.ptCen()));		
		bmCreated.append(bmNew);
		ptNewBmCenter+=vDir*dNewBmH;
	}
}

// Cutting beams
// Define cut point
Point3d ptFront= ptElOrg;
Point3d ptBack= ptFront - vz * el.dBeamWidth();
Point3d ptCut= ptFront;
if( vBmPostY.dotProduct( ptFront - ptPostCen) < vBmPostY.dotProduct( ptBack - ptPostCen ))
	ptCut= ptBack;
Vector3d vCut= vz;
if( vCut.dotProduct( vBmPostY) <0 )
	vCut=- vCut;

Cut ct( ptCut, vCut);
	
for( int b=0; b< bmCreated.length(); b++)
{
	Beam bm= bmCreated[b];
	bm.addToolStatic( ct, 1);
	bm.setColor(nColor);
	bm.setName(sName);
	bm.setGrade(sGrade);
	bm.setMaterial(sMaterial);
	bm.setType(nType);
	bm.setInformation(sInformation);
	bm.setLabel(sLabel);
	bm.setSubLabel(sSubLabel);
	bm.setSubLabel2(sSubLabel2);
	bm.setBeamCode(sBeamCode);
}

eraseInstance();



#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`,L`U`#`2(``A$!`Q$!_\0`
M'P```04!`0$!`0$```````````$"`P0%!@<("0H+_\0`M1```@$#`P($`P4%
M!`0```%]`0(#``01!1(A,4$&$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*
M%A<8&1HE)B<H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&EJ<W1U
M=G=X>7J#A(6&AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&
MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ>KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!
M`0$!`0````````$"`P0%!@<("0H+_\0`M1$``@$"!`0#!`<%!`0``0)W``$"
M`Q$$!2$Q!A)!40=A<1,B,H$(%$*1H;'!"2,S4O`58G+1"A8D-.$E\1<8&1HF
M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@H.$
MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#R:BBBM#,*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHK;T#PEK/B1F;3[-C;(V);N3Y88^1G+'J1N!VC+8Z`T-VU8&)
M78>&_AYJFN&.XO=VF:<Z%UN)H\O)\H*[(\@L#D8;A>O.1@^B:#X'T+PU-%<Q
M>9J.I1.'2[N%"I&P+8*1<C."O+%L$9&TUT,DCRN7D=G<]68Y)KBJXQ+2&IE*
MJEL5O"N@Z3X:OXTT>!T:618Y+F9MTTB;\X)Z*/90,X&<XS7SG7TYI_\`R$K7
M_KLG\Q7S'582<IIN3'3DVFV%%%%=9H%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%7=*T?4=<OELM+
MLIKNX;'R1+G:,@;F/15R1DG`&>37<>'_`(67<K)<^)&>RMF4D6L3K]I8E05)
M!!$8YYW?-P1M[CTFSLM/TJV:UTFPAL;9OO)%DM)R2-[DEG(R<9/';%<]7$PI
MZ;LB4U$XKPW\,K"TC^T>(C]LN#C99P2E8D!4Y\QQ@LP)'"$#Y?O,#@=T@6.!
M((HXX8(\[(8D"(F3D[54`#)Y.!UHIMQ(MK9R7<YV0)QN/\3=E'JQ]/Q.`":\
M^=2I6=OP,)3<AU5K[4;73'C6],R,X#A$BRQ4YPPS@$9&.O>L35/$PD3R=,6:
M$9!-PY"R'&"-H'W.>^23@<C)!YZ21YI7EE=GD<EF9CDL3U)/<UWT,NO[U7[B
M=CI--U^]N_%.GB*1[:W:[C411MC*EE!#$8+9QSGC).`,XKPVO7O#_P#R,NE?
M]?D/_H8KR&NV<(PLHJQO1V84445F:A1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`45JZ#X<U/Q)?+;:=;EEW*LL[Y
M$4`.<&1^BC@^YQ@`GBO5/#WP]TC0I$N+PQZM>;,8EB_T="RC.$89<@YPS8'/
MW`0#6=2K"FO>8I24=S@?#7@#5O$5NE\3'9Z86(^U3'F3!`81IU<\GT7((+#%
M>JZ#X=TGPU;Q#3[53>JHWZA*,S,WS9*\XC!#$87M@$MUK6FFDGE:65R[L<DF
MFJK.P5068G``&237G5<5.>D=$82JM["4Y(V?=M'"C<S'@*!U)/0#W-9M]K=E
MIXB.Y;MWY,<$R\+CJ6`(!SCC&>N<<9Y;4]6N-5F5Y@D<:#"11Y")GJ1DDY/<
MDD]!T``UH8"=366B,S>O?$T5L\T-K!YLRY59692BL"1D`9#C&"#D#/4$=>6E
MFEN)#)-(\CD`%G8DX`P.3[`"F45[%&A"DK00KA1116PC2\/_`/(RZ5_U^0_^
MABO(:]>\/_\`(RZ5_P!?D/\`Z&*\AKGK;G11V84445B;!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%=[X:^&5[?R"?7S-I=H
M,$1%`;B7YL%0A/[OC)W..X(##HI245>3!NVYQ-G9W6H726ME;37-P^=D4,9=
MVP,G`')X!/X5Z;HGPJM[81W&OW:SR\-]AM'^5>%.))._\2E4^H<5VNCZ;9>'
MK%[/28/LT4N/.;<6DF(&,NQZ]3P,+DG"C-6JX*N,;T@8RJ_RCMRK%'!###;V
M\6?+@@C$<<>22<*.!R:;3)IX;6,2W,R0QDX#.>O(!P!R<;AD`$XK"OO%+0SR
M1Z:D3(``+B5-Q)SR54\8/3Y@3WX)P,J6&JUW=?>S'?5FS>7=O902O-<0I(@^
M6)G^=CMW`;1D@$8Y(QSUKEM2\07&H0-;)&D%N6)(0DLXSE0Q[X]@`3@D<#&5
M)(\TKRRNSR.2S,QR6)ZDGN:;7L4,'3HZ[L5^P4445UB"BBB@`HHHH`TO#_\`
MR,NE?]?D/_H8KR&O7O#_`/R,NE?]?D/_`*&*\AKGK;G11V84445B;!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!116GHOAW5_$-P\.E6$MRR#
M,C+A4C&"?F<X5<[3C)&<4`9E=-X:\"ZOXC:*X$+6FELX#W\RX0#)!V#K(?E(
MPN<'J0.:[[P]\.=(TF)9]5"ZGJ`8D*"1;1\@J=I`:0\'.["\XVG&3V!/R(@`
M"1J$1%&%11T50.`!V`X%<E7%QCI#5F<JJ6QC>'O"ND>%I$GTY))KX)M-[<??
M&5`;8H^5!UQU8`D;B#BMEF9V+,2S$Y))R2:2J5[K-AITSPW#223)D-%$!D,`
M.&)X'4CC)!!R*XDJM>6FI@Y.6Y>52QP,#`)))P`!R22>@`YS6)J7B&UAMU%A
M,)YV'),3!$!![D@[@<'H1[GI6)>Z[J%]$T$DVRW8DF&(;5/.0#W8#MN)Q6;7
MJ4,NC'6IJ_P)N6;Z_N=1N//NI=[X"C"A0H]`!@`=3QW)/>JU%%>BDDK(0444
M4P"BBB@`HHHH`****`-+P_\`\C+I7_7Y#_Z&*\AKU[P__P`C+I7_`%^0_P#H
M8KR&N>MN=%'9A1116)L%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4^
M&&6YGC@@B>6:1@B1HI9F8G```ZDGM79>'_AIJNKVL-_?2IIMA,H>-W&^653N
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
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%>\^%?^27^&?\`MZ_]'-7@U>\^
M%?\`DE_AG_MZ_P#1S5CB/X;)J?`S<LIS<S0VDXW!V6-)!@,F3@9./F'L?08(
MKD+[Q-=W4,EO"D=M"^Y6V#+LI/0L?;@[0N03D5U.F?\`(6L_^NZ?^A"O/*,#
M3C)N36J.5O0****]0D****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"KMCJUW8*8XW#VY.YH)!NC8\9..QP,;AAL="*I44G%25F
M--IW1VUI';ZW8_:K.!K22)#YZRD^2[`#Y8FP>3UVL<\C&0":IRQM#*T;@!E.
M#@Y_4=:Z?4;^-KR6UDA\N*WD,47DD@(H./N'CH!P-M57ME>))GC6:$D?-SC/
M4J3P0>.G'Y8-?'8K$1]J^2/NGTM",E!*;NSG^E7Q?QSJ!=1'S<C,\9^8\\EE
M/#''H5]233)K"1,F,[U].]4Z4)QFM-31HMR:Q`+F^\/"W,^R.Y\UYU4JDL<4
MG,:\G.5&'R.#C:.#7&UT%DB2?$[44D0.C3WP922`PV2Y''-+K_AZ'3(/M-O.
MVT2+%);3,IEB+*2N<=B%)Y5>V,]:^GHNE1:H1[7ZGB8N$I?O#GJ***[#@"BB
MB@#2\/\`_(RZ5_U^0_\`H8KR&O7O#_\`R,NE?]?D/_H8KR&N>MN=%'9A1116
M)L%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`5[SX5_Y)?X9
M_P"WK_T<U>#5[SX5_P"27^&?^WK_`-'-6.(_ALFI\#-;3/\`D+6?_7=/_0A7
MGE>AZ9_R%K/_`*[I_P"A"O/*O+]I'*]@HHHKT20HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`/2->A6#7+M%)(+[^?5@
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
MY`NU=QX1<DA5'15&3A0`!V%5***HD****!!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
%110!_]E%
`



#End
