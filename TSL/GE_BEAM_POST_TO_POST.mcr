#Version 8
#BeginDescription
v1.3: 03.nov.2013: David Rueda (dr@hsb-cad.com)
Places horizontal lumber piece between 2 posts
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
* v1.3: 03.nov.2013: David Rueda (dr@hsb-cad.com)
	- Stickframe path added to mapIn when calling dll
* v1.2: 15.may.2012: David Rueda (dr@hsb-cad.com):
	- Thumbnail added
	- Description added
* v1.1: 25.jan.2012: David Rueda (dr@hsb-cad.com):
	- Updated grade and material info from inventory
	- Added some beam props to manual definition.
* v1.0: 24.jul.2011: David Rueda (dr@hsb-cad.com): 
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
	
	_Beam.append(getBeam(T("|Select first post|")));
	
	_Beam.append(getBeam(T("|Select another post|")));

	// Checking that beams are vertical
	Beam bm0= _Beam[0];
	Beam bm1= _Beam[1];
	
	Vector3d vx0= bm0.vecX();
	if(!vx0.isParallelTo(_ZW))
	{
		reportMessage(T("|First selected post must be vertical, tsl will be erased|"));
		eraseInstance();
		return;
	}
	
	Vector3d vx1= bm1.vecX();
	if(!vx1.isParallelTo(_ZW))
	{
		reportMessage(T("|Second selected post must be vertical, tsl will be erased|"));
		eraseInstance();
		return;
	}

	// Checking that posts are at same height level
	Point3d ptTop0= bm0.ptCen() + vx0*bm0.dL()*.5;
	Point3d ptTop1= bm1.ptCen() + vx1*bm1.dL()*.5;
	
	if( abs(_ZW.dotProduct(ptTop0-ptTop1))>U(0.001, 0.0001))
	{
		reportMessage(T("|Posts are not vertically aligned, tsl will be erased|"));
		eraseInstance();
		return;
	}

	showDialog();
	
	return;
}

if(_Beam.length()!=2)
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

// Getting info from posts and references vectors
Beam bm0= _Beam[0];
Beam bm1= _Beam[1];

Vector3d vDir( bm1.ptCen()- bm0.ptCen());
vDir.setZ(0);
vDir.normalize();
vDir.vis(bm0.ptCen());
Vector3d vNormal= _ZW.crossProduct( vDir);
vNormal.vis(bm0.ptCen());

_Pt0= bm0.ptCen();

// Getting info from post
Beam bmPost= _Beam[0];
Point3d ptPostCen= bmPost.ptCen();
Vector3d vBmPostX= bmPost.vecX();
if(vBmPostX.dotProduct(_ZW)<0)
	vBmPostX= vBmPostX;
Vector3d vBmPostY= bmPost.vecD(vDir);
if( vBmPostY.dotProduct( vDir)<0)
{
	vBmPostY= -vBmPostY;
}
Vector3d vBmPostZ= vBmPostX.crossProduct( vBmPostY);

vBmPostX.vis(bmPost.ptCen(),1);
vBmPostY.vis(bmPost.ptCen(),2);
vBmPostZ.vis(bmPost.ptCen(),3);

// Check if selected number will fit on post
double dRequired= nBeams*dW;
double dAvailable= bmPost.dD(vNormal);
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
Vector3d vBmX=vDir;
Vector3d vBmY=vNormal;
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
	ptNewBmCenter+=vNormal*.5*dNewBmH*(1-(nNewBeams%2));	
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
Point3d ptExtremes[]= bm1.envelopeBody().extremeVertices(-vDir);
Point3d ptCut= bm1.ptCen()+bm1.vecD(vDir)*bm1.dD(vDir)*.5;
Vector3d vCut= bm1.vecD(vDir);
if( vCut.dotProduct( vDir)<0)
	vCut=-vCut;
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
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`-N!#P#`2(``A$!`Q$!_\0`
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
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`J>SL[K
M4+I+6RMIKFX?.R*&,N[8&3@#D\`G\*[?P[\,;R[(NO$;RZ19`!EB9`;F?YB"
MH0\IPK?,PQDKP0>/1]/BM=(L?[*T&S6VMW`C=P@,]SZ&1QRQR3P.!N('%<U?
M%TZ6CU?8WI8>=3R1YP?A'KRA8S?:3]L:/<+07#%]^/\`5EMNP/D8^]C/?O7$
M7EG=:?=/:WMM-;7"8WQ31E'7(R,@\C@@_C7M=]K-CIRPLS+>/)\WE6\R_*N.
MI<!@#G'RX)ZYQQGS_P"(=[+J%WHMU-C>^G'@9PH%Q.`HSDX```SZ4\/.M-<U
M2-ET'6I0A\+N<;11170<X4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`45H
MZ)H6I^(M1%AI-H]U<E2^Q2``HZDDD`#H,D]2!U(KU'0OAYH_A]A<:S+;ZU?#
M&RWB+?9H2#D,6X\W/R_+@#[P.>#6=6K"DKS=BX4Y3=HHX'P_X%UWQ'`;NVMA
M;Z>H):]NB8X>XX."7Y4K\H."1G%>J:'H.A>$6672(I+G4U&TZE<@9&0`WEQ]
M%!QP3E@&89J]=W;O;^=,1#96^U`$C/DVRG"J`J@[1P!@#M7-7WBE46$:6K+(
M/FDEN(E;G&-H4[E(YSD\GC`&#GA53$8IVHJT>YVQH4Z6L]6;U[?P0.LVIWA1
MI5+J6!=Y`O'`_0$D`D$9X..3O?$M[<+-#!MMK>52A50&<KD]7(SG!VG;M!`Y
M')K+N+F>\G:>YGDGF;&Z25RS'`P,D\]!45=^&P%*CJ]9=V.=24M.@5G>-?NZ
M!_V#3_Z4SUHUG>-?NZ!_V#3_`.E,]=-38YJOPG+4445B<X4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%=?X?\`ASK>M01WUR@TS2V*_P"EW2D;P=I_=H/F?*MD'A3@
M_,*3:BKL:3;LCDX89;F>."")Y9I&")&BEF9B<``#J2>U>B>'OA?NC^U>*;F;
M3T."EC`%:XD!7.6SD18W+PPR<,,#@GN-(T_1_"T3IX>MI8II%V2WUPX>>1<Y
MV\#"#)_A`SM4GD5!J6J6^GHTMU*)K@R%3;I*#(2&^??UV8YZC)..",D<$\9*
MI+DPZN^_0[(85)<U5V-*%@MHNE:1816EGD$6MK'RY`^\QZNV`,D]=H-8>H:_
M::9<M`L:WLBK]Z.8>4"54CYESN')!`V].#7/:GKEUJD,4,BQQ0I@F.($!VZ;
MFR22<?@,G`&3G,K:CER;Y\0^9_@:NI9<L%9%J\U&\OR/M5S)*JLS(A/RH6.3
MM7HH/H`*JT45ZB22LC(****`"L[QK]W0/^P:?_2F>M&L[QK]W0/^P:?_`$IG
MK.IL95?A.6HHHK$YPHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBI[.SNM0NDM;*VFN;A\[(H8R[M@
M9.`.3P"?PH`@K:\.>%=6\57<D&EVX980&GGD8)'"I.-S,?Q.!DD`X!P:[O2/
MA;9Z<$N/$MX)[@%3_9MF_3D$B27''1E*KST(:NTFNI)+(PPVT5O86JM*+>TA
MV1Q+U9MJCW)S[GUKCKXV%-\L=9'32PTIZO1'/Z!X*T+PV"]Y#!KFI`CYYD/V
M:+Y<%53/[SDM\S8Z*0!WV+W5(WG\W4M01&8XW2DL1G)&%4$XX/08'MFL/4/$
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
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!7T0G_`"+OAK_L#6O_`*!7SO7T0G_(N^&O^P-:_P#H%<&9?P/F=6$_B$5%
M%%?/'IA1110!2U__`)%B7_K\A_\`0):XVNRU_P#Y%B7_`*_(?_0):XVOJ\L_
MW6/S_,XZGQL*Y[QU_P`C2_\`UYV?_I-%70USWCK_`)&E_P#KSL__`$FBKKJ'
M-6V1SE%%%8G.%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`5ZO\`"'_D`>+/^W/_
M`-#DKRBO5_A#_P`@#Q9_VY_^AR5CB?X,_1FE+^)'U.LHHHKY4]D****`+>E_
M\A:R_P"NZ?\`H0KS6O2M+_Y"UE_UW3_T(5YK7T&3?!/U1S5OB"H-?_Y$>Z_[
M"5K_`.BKBIZ@U_\`Y$>Z_P"PE:_^BKBO7J?"<U3X6<%1116!R!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!7T0G_(N^&O^P-:_P#H%?.]?1"?\B[X:_[`UK_Z!7!F
M7\#YG5A/XA%1117SQZ84444`4M?_`.18E_Z_(?\`T"6N-KLM?_Y%B7_K\A_]
M`EKC:^KRS_=8_/\`,XZGQL*Y[QU_R-+_`/7G9_\`I-%70USWCK_D:7_Z\[/_
M`-)HJZZAS5MD<Y1116)SA1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%>K_"'_D`
M>+/^W/\`]#DKRBO5_A#_`,@#Q9_VY_\`H<E8XG^#/T9I2_B1]3K****^5/9"
MBBB@"WI?_(6LO^NZ?^A"O-:]*TO_`)"UE_UW3_T(5YK7T&3?!/U1S5OB"H-?
M_P"1'NO^PE:_^BKBIZ@U_P#Y$>Z_["5K_P"BKBO7J?"<U3X6<%1116!R!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!7T0G_(N^&O^P-:_^@5\[U]$)_R+OAK_`+`U
MK_Z!7!F7\#YG5A/XA%1117SQZ84444`4M?\`^18E_P"OR'_T"6N-KLM?_P"1
M8E_Z_(?_`$"6N-KZO+/]UC\_S..I\;"N>\=?\C2__7G9_P#I-%70USWCK_D:
M7_Z\[/\`])HJZZAS5MD<Y1116)SA1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%>
MK_"'_D`>+/\`MS_]#DKRBO5_A#_R`/%G_;G_`.AR5CB?X,_1FE+^)'U.LHHH
MKY4]D****`+>E_\`(6LO^NZ?^A"O-:]*TO\`Y"UE_P!=T_\`0A7FM?09-\$_
M5'-6^(*@U_\`Y$>Z_P"PE:_^BKBIZ@U__D1[K_L)6O\`Z*N*]>I\)S5/A9P5
M%%%8'(%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%?1"?\B[X:_P"P-:_^@5\[U]$)
M_P`B[X:_[`UK_P"@5P9E_`^9U83^(14445\\>F%%%%`%+7_^18E_Z_(?_0):
MXVNRU_\`Y%B7_K\A_P#0):XVOJ\L_P!UC\_S..I\;"N>\=?\C2__`%YV?_I-
M%70USWCK_D:7_P"O.S_])HJZZAS5MD<Y1116)SA1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%>K_"'_`)`'BS_MS_\`0Y*\HKU?X0_\@#Q9_P!N?_H<E8XG^#/T
M9I2_B1]3K****^5/9"BBB@"WI?\`R%K+_KNG_H0KS6O2M+_Y"UE_UW3_`-"%
M>:U]!DWP3]4<U;X@J#7_`/D1[K_L)6O_`**N*GJ#7_\`D1[K_L)6O_HJXKUZ
MGPG-4^%G!4445@<@4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`5]$)_P`B[X:_[`UK
M_P"@5\[U]$)_R+OAK_L#6O\`Z!7!F7\#YG5A/XA%1117SQZ84444`4M?_P"1
M8E_Z_(?_`$"6N-KLM?\`^18E_P"OR'_T"6N-KZO+/]UC\_S..I\;"N>\=?\`
M(TO_`->=G_Z315T-<]XZ_P"1I?\`Z\[/_P!)HJZZAS5MD<Y1116)SA1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%>K_``A_Y`'BS_MS_P#0Y*\HKU?X0_\`(`\6
M?]N?_H<E8XG^#/T9I2_B1]3K****^5/9"BBB@"WI?_(6LO\`KNG_`*$*\UKT
MK2_^0M9?]=T_]"%>:U]!DWP3]4<U;X@J#7_^1'NO^PE:_P#HJXJ>H-?_`.1'
MNO\`L)6O_HJXKUZGPG-4^%G!4445@<@4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`5
M]$)_R+OAK_L#6O\`Z!7SO7T0G_(N^&O^P-:_^@5P9E_`^9U83^(14445\\>F
M%%%%`%+7_P#D6)?^OR'_`-`EKC:[+7_^18E_Z_(?_0):XVOJ\L_W6/S_`#..
MI\;"N>\=?\C2_P#UYV?_`*315T-<]XZ_Y&E_^O.S_P#2:*NNH<U;9'.4445B
M<X4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!7J_PA_Y`'BS_MS_`/0Y*\HKU?X0
M_P#(`\6?]N?_`*')6.)_@S]&:4OXD?4ZRBBBOE3V0HHHH`MZ7_R%K+_KNG_H
M0KS6O2M+_P"0M9?]=T_]"%>:U]!DWP3]4<U;X@J#7_\`D1[K_L)6O_HJXJ>H
M-?\`^1'NO^PE:_\`HJXKUZGPG-4^%G!4445@<@4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`5]$)_R+OAK_L#6O_H%?.]?1"?\B[X:_P"P-:_^@5P9E_`^9U83^(14
M445\\>F%%%%`%+7_`/D6)?\`K\A_]`EKC:[+7_\`D6)?^OR'_P!`EKC:^KRS
M_=8_/\SCJ?&PKGO'7_(TO_UYV?\`Z315T-<]XZ_Y&E_^O.S_`/2:*NNH<U;9
M'.4445B<X4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!7J_PA_Y`'BS_`+<__0Y*
M\HKU?X0_\@#Q9_VY_P#H<E8XG^#/T9I2_B1]3K****^5/9"BBB@"WI?_`"%K
M+_KNG_H0KS6O2M+_`.0M9?\`7=/_`$(5YK7T&3?!/U1S5OB"H-?_`.1'NO\`
ML)6O_HJXJ>H-?_Y$>Z_["5K_`.BKBO7J?"<U3X6<%1116!R!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!7T0G_(N^&O\`L#6O_H%?.]?1"?\`(N^&O^P-:_\`H%<&
M9?P/F=6$_B$5%%%?/'IA1110!2U__D6)?^OR'_T"6N-KLM?_`.18E_Z_(?\`
MT"6N-KZO+/\`=8_/\SCJ?&PKGO'7_(TO_P!>=G_Z315T-<]XZ_Y&E_\`KSL_
M_2:*NNH<U;9'.4445B<X4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!7J_PA_P"0
M!XL_[<__`$.2O**]7^$/_(`\6?\`;G_Z')6.)_@S]&:4OXD?4ZRBBBOE3V0H
MHHH`MZ7_`,A:R_Z[I_Z$*\UKTK2_^0M9?]=T_P#0A7FM?09-\$_5'-6^(*@U
M_P#Y$>Z_["5K_P"BKBIZ@U__`)$>Z_["5K_Z*N*]>I\)S5/A9P5%%%8'(%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%?1"?\`(N^&O^P-:_\`H%?.]?1"?\B[X:_[
M`UK_`.@5P9E_`^9U83^(14445\\>F%%%%`%+7_\`D6)?^OR'_P!`EKC:[+7_
M`/D6)?\`K\A_]`EKC:^KRS_=8_/\SCJ?&PKGO'7_`"-+_P#7G9_^DT5=#7/>
M.O\`D:7_`.O.S_\`2:*NNH<U;9'.4445B<X4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!7J_P`(?^0!XL_[<_\`T.2O**]7^$/_`"`/%G_;G_Z')6.)_@S]&:4O
MXD?4ZRBBBOE3V0HHHH`MZ7_R%K+_`*[I_P"A"O-:]*TO_D+67_7=/_0A7FM?
M09-\$_5'-6^(*@U__D1[K_L)6O\`Z*N*GJ#7_P#D1[K_`+"5K_Z*N*]>I\)S
M5/A9P5%%%8'(%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%?1"?\B[X:_[`UK_`.@5
M\[U]$)_R+OAK_L#6O_H%<&9?P/F=6$_B$5%%%?/'IA1110!2U_\`Y%B7_K\A
M_P#0):XVNRU__D6)?^OR'_T"6N-KZO+/]UC\_P`SCJ?&PKGO'7_(TO\`]>=G
M_P"DT5=#7/>.O^1I?_KSL_\`TFBKKJ'-6V1SE%%%8G.%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`5ZO\(?^0!XL_[<_P#T.2O**]7^$/\`R`/%G_;G_P"AR5CB
M?X,_1FE+^)'U.LHHHKY4]D****`+>E_\A:R_Z[I_Z$*\UKTK2_\`D+67_7=/
M_0A7FM?09-\$_5'-6^(*@U__`)$>Z_["5K_Z*N*GJ#7_`/D1[K_L)6O_`**N
M*]>I\)S5/A9P5%%%8'(%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%?1"?\B[X:_[`
MUK_Z!7SO7T0G_(N^&O\`L#6O_H%<&9?P/F=6$_B$5%%%?/'IA1110!2U_P#Y
M%B7_`*_(?_0):XVNRU__`)%B7_K\A_\`0):XVOJ\L_W6/S_,XZGQL*Y[QU_R
M-+_]>=G_`.DT5=#7/>.O^1I?_KSL_P#TFBKKJ'-6V1SE%%%8G.%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`5ZO\(?^0!XL_P"W/_T.2O**]7^$/_(`\6?]N?\`
MZ')6.)_@S]&:4OXD?4ZRBBBOE3V0HHHH`MZ7_P`A:R_Z[I_Z$*\UKTK2_P#D
M+67_`%W3_P!"%>:U]!DWP3]4<U;X@J#7_P#D1[K_`+"5K_Z*N*GJ#7_^1'NO
M^PE:_P#HJXKUZGPG-4^%G!4445@<@4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`5]$
M)_R+OAK_`+`UK_Z!7SO7T0G_`"+OAK_L#6O_`*!7!F7\#YG5A/XA%1117SQZ
M84444`4M?_Y%B7_K\A_]`EKC:[+7_P#D6)?^OR'_`-`EKC:^KRS_`'6/S_,X
MZGQL*Y[QU_R-+_\`7G9_^DT5=#7/>.O^1I?_`*\[/_TFBKKJ'-6V1SE%%%8G
M.%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`5ZO\(?\`D`>+/^W/_P!#DKRBO5_A
M#_R`/%G_`&Y_^AR5CB?X,_1FE+^)'U.LHHHKY4]D****`+>E_P#(6LO^NZ?^
MA"O-:]*TO_D+67_7=/\`T(5YK7T&3?!/U1S5OB"H-?\`^1'NO^PE:_\`HJXJ
M>H-?_P"1'NO^PE:_^BKBO7J?"<U3X6<%1116!R!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!7T0G_`"+OAK_L#6O_`*!7SO7T0G_(N^&O^P-:_P#H%<&9?P/F=6$_
MB$5%%%?/'IA1110!2U__`)%B7_K\A_\`0):XVNRU_P#Y%B7_`*_(?_0):XVO
MJ\L_W6/S_,XZGQL*Y[QU_P`C2_\`UYV?_I-%70USWCK_`)&E_P#KSL__`$FB
MKKJ'-6V1SE%%%8G.%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`5ZO\`"'_D`>+/
M^W/_`-#DKRBO5_A#_P`@#Q9_VY_^AR5CB?X,_1FE+^)'U.LHHHKY4]D****`
M+>E_\A:R_P"NZ?\`H0KS6O2M+_Y"UE_UW3_T(5YK7T&3?!/U1S5OB"H-?_Y$
M>Z_["5K_`.BKBIZ@U_\`Y$>Z_P"PE:_^BKBO7J?"<U3X6<%1116!R!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!7T0G_(N^&O^P-:_P#H%?.]?1"?\B[X:_[`UK_Z
M!7!F7\#YG5A/XA%1117SQZ84444`4M?_`.18E_Z_(?\`T"6N-KLM?_Y%B7_K
M\A_]`EKC:^KRS_=8_/\`,XZGQL*Y[QU_R-+_`/7G9_\`I-%70USWCK_D:7_Z
M\[/_`-)HJZZAS5MD<Y1116)SA1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%>K_"
M'_D`>+/^W/\`]#DKRBO5_A#_`,@#Q9_VY_\`H<E8XG^#/T9I2_B1]3K****^
M5/9"BBB@"WI?_(6LO^NZ?^A"O-:]*TO_`)"UE_UW3_T(5YK7T&3?!/U1S5OB
M"H-?_P"1'NO^PE:_^BKBIZ@U_P#Y$>Z_["5K_P"BKBO7J?"<U3X6<%1116!R
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!7T0G_(N^&O^P-:_^@5\[U]$)_R+OAK_
M`+`UK_Z!7!F7\#YG5A/XA%1117SQZ84444`4M?\`^18E_P"OR'_T"6N-KLM?
M_P"18E_Z_(?_`$"6N-KZO+/]UC\_S..I\;"N>\=?\C2__7G9_P#I-%70USWC
MK_D:7_Z\[/\`])HJZZAS5MD<Y1116)SA1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%>K_"'_D`>+/\`MS_]#DKRBO5_A#_R`/%G_;G_`.AR5CB?X,_1FE+^)'U.
MLHHHKY4]D****`+>E_\`(6LO^NZ?^A"O-:]*TO\`Y"UE_P!=T_\`0A7FM?09
M-\$_5'-6^(*@U_\`Y$>Z_P"PE:_^BKBIZ@U__D1[K_L)6O\`Z*N*]>I\)S5/
MA9P5%%%8'(%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%?1"?\B[X:_P"P-:_^@5\[
MU]$)_P`B[X:_[`UK_P"@5P9E_`^9U83^(14445\\>F%%%%`%+7_^18E_Z_(?
M_0):XVNRU_\`Y%B7_K\A_P#0):XVOJ\L_P!UC\_S..I\;"N>\=?\C2__`%YV
M?_I-%70USWCK_D:7_P"O.S_])HJZZAS5MD<Y1116)SA1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%>K_"'_`)`'BS_MS_\`0Y*\HKU?X0_\@#Q9_P!N?_H<E8XG
M^#/T9I2_B1]3K****^5/9"BBB@"WI?\`R%K+_KNG_H0KS6O2M+_Y"UE_UW3_
M`-"%>:U]!DWP3]4<U;X@J#7_`/D1[K_L)6O_`**N*GJ#7_\`D1[K_L)6O_HJ
MXKUZGPG-4^%G!4445@<@4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`5]$)_P`B[X:_
M[`UK_P"@5\[U]$)_R+OAK_L#6O\`Z!7!F7\#YG5A/XA%1117SQZ84444`4M?
M_P"18E_Z_(?_`$"6N-KLM?\`^18E_P"OR'_T"6N-KZO+/]UC\_S..I\;"N>\
M=?\`(TO_`->=G_Z315T-<]XZ_P"1I?\`Z\[/_P!)HJZZAS5MD<Y1116)SA11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%>K_``A_Y`'BS_MS_P#0Y*\HKU?X0_\`
M(`\6?]N?_H<E8XG^#/T9I2_B1]3K****^5/9"BBB@"WI?_(6LO\`KNG_`*$*
M\UKTK2_^0M9?]=T_]"%>:U]!DWP3]4<U;X@J#7_^1'NO^PE:_P#HJXJ>H-?_
M`.1'NO\`L)6O_HJXKUZGPG-4^%G!4445@<@4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`5]$)_R+OAK_L#6O\`Z!7SO7T0G_(N^&O^P-:_^@5P9E_`^9U83^(14445
M\\>F%%%%`%+7_P#D6)?^OR'_`-`EKC:[+7_^18E_Z_(?_0):XVOJ\L_W6/S_
M`#..I\;"N>\=?\C2_P#UYV?_`*315T-<]XZ_Y&E_^O.S_P#2:*NNH<U;9'.4
M445B<X4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!7J_PA_Y`'BS_MS_`/0Y*\HK
MU?X0_P#(`\6?]N?_`*')6.)_@S]&:4OXD?4ZRBBBOE3V0HHHH`MZ7_R%K+_K
MNG_H0KS6O2M+_P"0M9?]=T_]"%>:U]!DWP3]4<U;X@J#7_\`D1[K_L)6O_HJ
MXJ>H-?\`^1'NO^PE:_\`HJXKUZGPG-4^%G!4445@<@4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`5]$)_R+OAK_L#6O_H%?.]?1"?\B[X:_P"P-:_^@5P9E_`^9U83
M^(14445\\>F%%%%`%+7_`/D6)?\`K\A_]`EKC:[+7_\`D6)?^OR'_P!`EKC:
M^KRS_=8_/\SCJ?&PKGO'7_(TO_UYV?\`Z315T-<]XZ_Y&E_^O.S_`/2:*NNH
M<U;9'.4445B<X4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!7J_PA_Y`'BS_`+<_
M_0Y*\HKU?X0_\@#Q9_VY_P#H<E8XG^#/T9I2_B1]3K****^5/9"BBB@"WI?_
M`"%K+_KNG_H0KS6O2M+_`.0M9?\`7=/_`$(5YK7T&3?!/U1S5OB"H-?_`.1'
MNO\`L)6O_HJXJ>H-?_Y$>Z_["5K_`.BKBO7J?"<U3X6<%1116!R!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!7T0G_(N^&O\`L#6O_H%?.]?1"?\`(N^&O^P-:_\`
MH%<&9?P/F=6$_B$5%%%?/'IA1110!2U__D6)?^OR'_T"6N-KLM?_`.18E_Z_
M(?\`T"6N-KZO+/\`=8_/\SCJ?&PKGO'7_(TO_P!>=G_Z315T-<]XZ_Y&E_\`
MKSL__2:*NNH<U;9'.4445B<X4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!7J_PA
M_P"0!XL_[<__`$.2O**]7^$/_(`\6?\`;G_Z')6.)_@S]&:4OXD?4ZRBBBOE
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
MP-<G14PIQA?E5KENI)JS844451`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%?1"?\B[X:_[`UK_`.@5\[U]$)_R+OAK_L#6O_H%<&9?P/F=6$_B$5%%%?/'
MIA1110!2U_\`Y%B7_K\A_P#0):XVNRU__D6)?^OR'_T"6N-KZO+/]UC\_P`S
MCJ?&PKGO'7_(TO\`]>=G_P"DT5=#7/>.O^1I?_KSL_\`TFBKKJ'-6V1SE%%%
M8G.%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`5]$)_R+OAK_L#6O_H%?.]?1"?\
MB[X:_P"P-:_^@5P9E_`^9U83^(14445\\>F%%%%`%+7_`/D6)?\`K\A_]`EK
MC:[+7_\`D6)?^OR'_P!`EKC:^KRS_=8_/\SCJ?&PKGO'7_(TO_UYV?\`Z315
MT-<]XZ_Y&E_^O.S_`/2:*NNH<U;9'.4445B<X4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!7T0G_(N^&O\`L#6O_H%?.]?1"?\`(N^&O^P-:_\`H%<&9?P/F=6$
M_B$5%%%?/'IA1110!2U__D6)?^OR'_T"6N-KLM?_`.18E_Z_(?\`T"6N-KZO
M+/\`=8_/\SCJ?&PKGO'7_(TO_P!>=G_Z315T-<]XZ_Y&E_\`KSL__2:*NNH<
MU;9'.4445B<X4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!7T0G_`"+OAK_L#6O_
M`*!7SO7T0G_(N^&O^P-:_P#H%<&9?P/F=6$_B$5%%%?/'IA1110!2U__`)%B
M7_K\A_\`0):XVNRU_P#Y%B7_`*_(?_0):XVOJ\L_W6/S_,XZGQL*Y[QU_P`C
M2_\`UYV?_I-%70USWCK_`)&E_P#KSL__`$FBKKJ'-6V1SE%%%8G.%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`5]$)_R+OAK_L#6O\`Z!7SO7T0G_(N^&O^P-:_
M^@5P9E_`^9U83^(14445\\>F%%%%`%+7_P#D6)?^OR'_`-`EKC:[+7_^18E_
MZ_(?_0):XVOJ\L_W6/S_`#..I\;"N>\=?\C2_P#UYV?_`*315T-<]XZ_Y&E_
M^O.S_P#2:*NNH<U;9'.4445B<X4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!7T0
MG_(N^&O^P-:_^@5\[U]$)_R+OAK_`+`UK_Z!7!F7\#YG5A/XA%1117SQZ844
M44`4M?\`^18E_P"OR'_T"6N-KLM?_P"18E_Z_(?_`$"6N-KZO+/]UC\_S..I
M\;"N>\=?\C2__7G9_P#I-%70USWCK_D:7_Z\[/\`])HJZZAS5MD<Y1116)SA
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%?1"?\B[X:_P"P-:_^@5\[U]$)_P`B
M[X:_[`UK_P"@5P9E_`^9U83^(14445\\>F%%%%`%+7_^18E_Z_(?_0):XVNR
MU_\`Y%B7_K\A_P#0):XVOJ\L_P!UC\_S..I\;"N>\=?\C2__`%YV?_I-%70U
MSWCK_D:7_P"O.S_])HJZZAS5MD<Y1116)SA1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%?1"?\`(N^&O^P-:_\`H%?.]?1"?\B[X:_[`UK_`.@5P9E_`^9U83^(
M14445\\>F%%%%`%+7_\`D6)?^OR'_P!`EKC:[+7_`/D6)?\`K\A_]`EKC:^K
MRS_=8_/\SCJ?&PKGO'7_`"-+_P#7G9_^DT5=#7/>.O\`D:7_`.O.S_\`2:*N
MNH<U;9'.4445B<X4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!7T0G_(N^&O^P-:
M_P#H%?.]?1"?\B[X:_[`UK_Z!7!F7\#YG5A/XA%1117SQZ84444`4M?_`.18
ME_Z_(?\`T"6N-KLM?_Y%B7_K\A_]`EKC:^KRS_=8_/\`,XZGQL*Y[QU_R-+_
M`/7G9_\`I-%70USWCK_D:7_Z\[/_`-)HJZZAS5MD<Y1116)SA1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%?1"?\B[X:_[`UK_Z!7SO7T0G_(N^&O\`L#6O_H%<
M&9?P/F=6$_B$5%%%?/'IA1110!2U_P#Y%B7_`*_(?_0):XVNRU__`)%B7_K\
MA_\`0):XVOJ\L_W6/S_,XZGQL*Y[QU_R-+_]>=G_`.DT5=#7/>.O^1I?_KSL
M_P#TFBKKJ'-6V1SE%%%8G.%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`5]$)_R+
MOAK_`+`UK_Z!7SO7T0G_`"+OAK_L#6O_`*!7!F7\#YG5A/XA%1117SQZ8444
M4`4M?_Y%B7_K\A_]`EKC:[+7_P#D6)?^OR'_`-`EKC:^KRS_`'6/S_,XZGQL
M*Y[QU_R-+_\`7G9_^DT5=#7/>.O^1I?_`*\[/_TFBKKJ'-6V1SE%%%8G.%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`5[WHFL:7K^CZ-9Z9J$$U]9Z;!;RVARDI
M=8R6V!@-^-ISMS7@E/AFEMIXYX)7BFC8.DB,596!R"".A![UE7HQK0Y)&E.H
MZ<N9'T!17GVA_$^Z4+:^(T-["%PMY'&#<I@*!GE1(,+CYOF^8G<<8/?V]Q8:
MA:F[TO4;>^M0VTO$V'0DL`'1L,I.TGD8/8FO`Q&"J4==UW/2I8B%339CJ***
MXS<I:_\`\BQ+_P!?D/\`Z!+7&UV6O_\`(L2_]?D/_H$M<;7U>6?[K'Y_F<=3
MXV%<]XZ_Y&E_^O.S_P#2:*NAKGO'7_(TO_UYV?\`Z315UU#FK;(YRBBBL3G"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"KNE:QJ.AWRWNEWLUI<+CYXFQ
MN&0=K#HRY`R#D''(JE10!ZIH7Q(L-018/$*QV-PHP+RV@)CDPO\`RT13E3E>
MJ*0=_P!T8Y[)T4*CQ3P7$,@)CFMY5D1P"5R&!QU!'X5\\UN>'_%VL^&G(T^[
M/V9F#2VDP\R"3E2<H>,G:!N&&QT(K@Q&7TZFL=&=5+%2AI+5'K6O_P#(L2_]
M?D/_`*!+7)V]K/=NRP1EMBEW;HL:CJS,>%4=R<`=ZFO?B3HFI:%LNM.O$O7E
MCFDM[;:D)90RG;(2Q4'?NQL.,;?]JN&UKQ-J>NLRW,J16OF>8MG;1B*!&YP0
MB\$@'&XY;&`2:ZL'&5&BJ;W5_P`QU*R;NCH;[Q+I6FJRZ>3J-X!\L[)MMXSV
M(5QNDZ]&"`%>0ZG!X^^OKG4;R2[NY3+/(?F8@`<#```X`````X```P!5>BMF
MV]SFE)RW"BBBD2%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`?_
!V110
`



#End
