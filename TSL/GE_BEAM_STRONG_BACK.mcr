#Version 8
#BeginDescription
v1.3: 03.nov.2013: David Rueda (dr@hsb-cad.com)
Places 2 lumber items in 'L' formation along selected beams
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 3
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
* v1.3: 03.nov.2013: David Rueda (dr@hsb-cad.com)
	- Stickframe path added to mapIn when calling dll
* v1.2: 15-may-2012: David Rueda (dr@hsb-cad.com)
	- Description added
* v1.1: 16-Apr-2012: David Rueda (dr@hsb-cad.com)
	- Beams to create will now be chosen from inventory lumber items list
	- User has now the option to NOT frame vertical or horizontal beam
	- Thumbnail added
* v1.0: 11-Apr-2011: David Rueda (dr@hsb-cad.com)
	- Release
*/

String sLumberItemKeys[0];
String sLumberItemNames[0];

// Calling dll to fill item lumber prop.
Map mapIn;
Map mapOut;

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

mapOut = callDotNetFunction2(sAssemblyPath, sClassName, sFunction, mapIn);

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

// Add none option to no frame beam
sLumberItemNames.append(T("|None|"));

//Properties
PropString sHSize(0,sLumberItemNames,T("|Horizontal beam|"),0);
PropString sVSize(1,sLumberItemNames,T("|Vertical beam|"),0);
String sNoYes[]={T("|No|"), T("|Yes|")};
PropString sFlip(2,sNoYes,"Flip side",0);
int nFlip=sNoYes.find(sFlip,0);

if(_bOnInsert){
	
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	
	if (_kExecuteKey=="")
	{
		showDialogOnce();
	}
	
	PrEntity ssE("\n"+T("|Select beam|"+"(s)"),Beam());
	if( ssE.go())
	{
		_Beam.append(ssE.beamSet());
	}
	
	_Pt0= getPoint("\n"+T("|Insertion reference point|"));

	return;
}

if(_Beam.length()<=0)
{
	eraseInstance();
	return
}

Beam bmJoists[0];
for(int b=0;b<_Beam.length();b++)
{
	Beam bm=_Beam[b];
	if(!bm.bIsValid())
	{
		continue;
	}
	bmJoists.append(bm);
}

if(bmJoists.length()<1)
{
	reportMessage ( "\n" + T("|Not enough beams selected|"));
	eraseInstance();
	return;
}

// Setting props
//Getting fixed properties
String sNewLabel="Strongback";
int nNewType=87;//JOIST type

// Getting values from selected item lumber for HORIZONTAL BEAM
int nBmH_Index=sLumberItemNames.find(sHSize,-1);

int bFrameH= true;
if( nBmH_Index==sLumberItemNames.length()-1)
{
	bFrameH=false;
}

// Get props from inventory
String sBmH_Material, sBmH_Grade;
double dBmH_W, dBmH_H;
for( int m=0; m<mapOut.length(); m++)
{
	if( !bFrameH)
		break;
		
	String sSelectedKey= sLumberItemKeys[nBmH_Index];
	String sKey= mapOut.keyAt(m);
	if( sKey==sSelectedKey)
	{
		dBmH_W= mapOut.getDouble(sKey+"\WIDTH");
		dBmH_H= mapOut.getDouble(sKey+"\HEIGHT");
		sBmH_Material= mapOut.getString(sKey+"\HSB_MATERIAL"); // Specie
		sBmH_Grade= mapOut.getString(sKey+"\HSB_GRADE");
		break;
	}
}

if( (dBmH_W==0 || dBmH_H==0) && bFrameH)
{
	reportError("\nData incomplete, check values on inventory for selected lumber item"+
		"\nMaterial: "+sBmH_Material+"\nGrade: "+ sBmH_Grade+"\nWidth: "+ dBmH_W+"\nHeight: "+ dBmH_H);
	eraseInstance();
	return;
}

// Getting values from selected item lumber for VERTICAL BEAM
int nBmV_Index=sLumberItemNames.find(sVSize,-1);

int bFrameV= true;
if( nBmV_Index==sLumberItemNames.length()-1)
{
	bFrameV=false;
}

// Get props from inventory
String sBmV_Material, sBmV_Grade;
double dBmV_W, dBmV_H;
for( int m=0; m<mapOut.length(); m++)
{
	if( !bFrameV)
		break;

	String sSelectedKey= sLumberItemKeys[nBmV_Index];
	String sKey= mapOut.keyAt(m);
	if( sKey==sSelectedKey)
	{
		dBmV_W= mapOut.getDouble(sKey+"\WIDTH");
		dBmV_H= mapOut.getDouble(sKey+"\HEIGHT");
		sBmV_Material= mapOut.getString(sKey+"\HSB_MATERIAL"); // Specie
		sBmV_Grade= mapOut.getString(sKey+"\HSB_GRADE");
		break;
	}
}

if( (dBmV_W==0 || dBmV_H==0) && bFrameV)
{
	reportError("\nData incomplete, check values on inventory for selected lumber item"+
		"\nMaterial: "+sBmV_Material+"\nGrade: "+ sBmV_Grade+"\nWidth: "+ dBmV_W+"\nHeight: "+ dBmV_H);
	eraseInstance();
	return;
}

//Getting vector and paralell beams
Beam bmAny=bmJoists[0];// This will be any beam, not necesarilly the first, this is why ALL BEAMS MUST BE PARALELL
Vector3d vBm0Z=bmAny.vecD(_ZW);
Vector3d vBm0X=bmAny.vecX();
Vector3d vBm0Y=vBm0Z.crossProduct(vBm0X); vBm0Y.normalize();


Vector3d vDir=vBm0Y;// Vector along X axis of new beams

//Sort beams along vDir
bmJoists=vBm0Y.filterBeamsPerpendicularSort(bmJoists);
if(bmJoists.length()<=0)
{
	reportMessage ( "\n" + T("|Not enough beams are perpendicular|"));
	eraseInstance();
	return;
}
Beam bmStart=bmJoists[0];
Beam bmEnd=bmJoists[bmJoists.length()-1];

Point3d ptStart=bmStart.ptCen()+bmStart.vecD(_ZW)*bmStart.dD(_ZW)*.5-bmStart.vecD(vDir)*bmStart.dD(vDir)*.5;
Point3d ptEnd=bmEnd.ptCen()+bmEnd.vecD(_ZW)*bmEnd.dD(_ZW)*.5+bmEnd.vecD(vDir)*bmEnd.dD(vDir)*.5;

//Realign ptStart and ptEnd to inertion point (_Pt0)
ptStart+=vBm0X*vBm0X.dotProduct(_Pt0-ptStart);
ptEnd+=vBm0X*vBm0X.dotProduct(_Pt0-ptEnd);

//Fipping 
Vector3d vSide=vBm0X; // Vector that defines side of vertical beam related to horizontal beam
if ( nFlip )
{
	vSide=-vSide;
}

// Verifying that insertion point is between allowed limits of beams: horizontal beam will be on direction of vSide, and vertical beam in opposite direction
Point3d ptLimit0=bmAny.ptCen()-vSide*(bmAny.dL()*.5-dBmH_H);
Point3d ptLimit1=bmAny.ptCen()+vSide*(bmAny.dL()*.5-dBmV_W);
if( vSide.dotProduct(ptStart-ptLimit0 ) < 0 || vSide.dotProduct(ptLimit1-ptStart)<0 )
{
	reportMessage ( "\n " + T("|There is no room for these beams at this point|"));
	eraseInstance();
	return;	
}

// Ready to create new beams
double dBmL=abs(vDir.dotProduct(ptEnd-ptStart)); // Length for both beams
// Horizontal beam
// Define vectors
Vector3d vBmH_Z = vSide;
Vector3d vBmH_X = vDir;
Vector3d vBmH_Y = vBmH_Z.crossProduct( vBmH_X ); vBmH_Y.normalize();

int nBmHFlagY= 1;
if( vBmH_Y.dotProduct( _ZW ) < 0 ){
	nBmHFlagY= -1;
}

if( bFrameH)
{
	Beam bmH;
	bmH.dbCreate( ptStart, vBmH_X, vBmH_Y, vBmH_Z, dBmL, dBmH_W, dBmH_H, 1, nBmHFlagY, 1);
	bmH.setColor(32);
	bmH.setLabel(sNewLabel);
	bmH.setGrade(sBmH_Grade);
	bmH.setMaterial(sBmH_Material);
	bmH.setType(nNewType);
}

// Vertical beam
// Define vectors
Vector3d vBmV_X = vDir;
Vector3d vBmV_Y = vSide;
Vector3d vBmV_Z = vBmH_X.crossProduct( vBmV_Y ); vBmV_Z.normalize();

int nBmVFlagZ= 1;
if( vBmV_Z.dotProduct( _ZW ) < 0 ){
	nBmVFlagZ= -1;
}

if( bFrameV)
{
	Beam bmV;
	bmV.dbCreate( ptStart,  vBmV_X,  vBmV_Y,  vBmV_Z, dBmL, dBmV_W, dBmV_H, 1, -1, nBmVFlagZ);
	bmV.setColor(32);
	bmV.setLabel(sNewLabel);
	bmV.setGrade(sBmV_Grade);
	bmV.setMaterial(sBmV_Material);
	bmV.setType(nNewType);
}

eraseInstance();
return






#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`/U!VX#`2(``A$!`Q$!_\0`
M'P```04!`0$!`0$```````````$"`P0%!@<("0H+_\0`M1```@$#`P($`P4%
M!`0```%]`0(#``01!1(A,4$&$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*
M%A<8&1HE)B<H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&EJ<W1U
M=G=X>7J#A(6&AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&
MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ>KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!
M`0$!`0````````$"`P0%!@<("0H+_\0`M1$``@$"!`0#!`<%!`0``0)W``$"
M`Q$$!2$Q!A)!40=A<1,B,H$(%$*1H;'!"2,S4O`58G+1"A8D-.$E\1<8&1HF
M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@H.$
MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#Y_HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"NS\*>';"YMH[^\/G,_W(6&%4AB.>?FZ#
M@\<G@UQE>A^&?^1>M?\`@?\`Z&:X,QG*-'W7:[/,S:I.%#W':[M^9U"(D<:Q
MQJJHH`55&``.P%.JC%</'P?F7T-6XY4D'RGGT/6OF91:/D)0:U8^L+6/"MAJ
MH:1%6VN2<^<B]><G*\`YR>>O3GM6[154ZLZ4N:#LQTJU2C+FINS/(]5T2^T>
M7;<QY0XVS)DHQ/;..O!X]JSJ]K=$DC:.159&!#*PR"#V(KD]7\#PW,CSZ=*L
M$C')B<?N^W3'*]SW_"O;PV:QE[M;1]SZ/"9U"?NU]'WZ?\`X"BI[NSN;&<P7
M4+Q2#LPQD9QD>HXZBH*]=--71[JDI*ZV"BBBF,****`"BBB@`HHHH`****`"
MBBM/2]"N]4;<B^5!WE<'!YQ\OJ>OY=14SG&"YI.R*A"4W:*NS,KH-+\*W-V%
MENB;>+/W2OSGGT/3OR?RKI=+T*TTM=R+YL_>5P,CC'R^@Z_GU-:=>37S%O2E
M]YZ='`):U/N*]I8VMA&4M8%C!ZD=3]3U/6K%%%>8VY.[/1225D%%%%(8444H
M4FA)O83=MQ*<%]:4`"EK6-/N9N?8.E%%%:&84444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`445#
M<W4%G"9KB5(D'=CU[X'J>.E-)O1`W;5DU4M0U:RTQ,W,P#8R(QRS=>WX=3Q7
M-ZKXO=F\K31M4=9G7D\_PCT^OKT%<O++)/(9)I'D<]6=B2?Q-=U'!2EK/1''
M5Q:CI#4V-3\3WNH(T*`6\##!13DL.."W^&.O>L2BBO1A",%:*L>?.<IN\F%%
M%%62%%%%`!1110`4444`%%%%`!1110`44J(TCJB*69C@*!DDUT.E^%+BX*R7
MV8(2,[`?G/''T_'GCI656M"DKS9I3I3J.T485M:SWDPBMXFD<]E'3MD^@]ZZ
MO3/",2HLNH,7<C)A4X"]>"1U[=,?C706EC:V$92U@6,'J1U/U/4]:L5Y%?,)
MSTIZ+\3U:.!A#6>K_`1$6-%1%"JHP%`P`*6BBO/.X****`"BBG!?6FDWL)M+
M<;UIP7UIP&**UC32W,G-O8****L@****`"BBB@"GJO\`R![[_KWD_P#037E]
M>H:K_P`@>^_Z]Y/_`$$UY?7J8#X6>=C?B04445WG$%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!7H?AG_D7K7_@?_H9KSRO0
M_#/_`"+UK_P/_P!#->=F?\)>OZ,\K./X"]?T9K4`X.1UHHKQ#YLLQ71&%?D>
MM6E97&5((K,IRNR-E3@UG*FGL9RII[&E15>*Z#</A3Z]JL`Y&1TK%IK<P<6M
MR"[L[:^@,%U"DL9[,,X.,9'H>>HKA=9\$SVJF;36>YC'WHVQO4`=1_>[\`9Z
M=:]!HKHP^+JT'[CT['5A<=6PS]QZ=NAXHZ/'(T<BLKJ2&5A@@CL13:]:U;0;
M#60#=1L)5&%EC.&`SG'H?Q!ZFN"UCPK?Z46D16N;8#/G(O3C)RO)&,'GITY[
M5[^&S"E6T>C/I\)FM'$>Z_=EV?Z,PJ***[STPHHHH`***?%%)/((XHVD<]%0
M9)_"C8!E6K'3[G49Q%;QEN0&;'RK[D]NAKH=+\(E@LNHL5Y_U*$>O=A^/`_.
MNI@@BM8$AA0)&@PJCM7G5\PA#2GJ_P`#OH8&4M9Z+\3#TOPK;6A66Z(N)<?=
M*_(./0]>_)_*N@HHKR*E6=5WF[GJTZ4*:M%!111698444=:`"E`)I0OK3JTC
M3[F;GV$"@4M%%:I);&;;>X4444""BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BLG5/$%EI9:-
MR9;@#/E)VR.,GH/Y\]*XS4]=O=4=@\A2`GB%3P!QU]>G?]*Z:.%G4UV1SU<3
M"GINSI=4\6V]L&CL<3S`XWD?(.>?<_AQSUKD+R_NK^0274[RD=`>@^@'`Z"J
MU%>I2H0I;+4\ZI6G4W"BBBMC(****`"BBB@`HHHH`****`"BBB@`HHJW8:;=
M:E,8[:/=MQN8G"J#ZG_)XI2DHJ\GH.,7)V14K5TO0+S4PLB@1VY./-?OSS@=
M_P"7'6NETOPO:V:[[L+<S>A'R+QR,=_J?;@5O5Y=?,4O=I?>>C1P#>M3[C.T
M_1+'3<-#%NE'_+63EN_3TZXXQ6C117E3G*;O)W9Z<8QBK15@HHHJ2@HHH`S0
M`4H4FG!0*6M(T^YFY]A``*6BBM4K&;=PHHHH$%%%%`!1110`4444`4]5_P"0
M/??]>\G_`*":\OKU#5?^0/??]>\G_H)KR^O4P'PL\[&_$@HHHKO.(****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"O0_#/_(O6
MO_`__0S7GE>A^&?^1>M?^!_^AFO.S/\`A+U_1GE9Q_`7K^C-:BBBO$/FPHHH
MH`*?',\7W3QZ&F44FK@U?<OQW"2<'Y6]#4M9=3QW+H0&.Y??K64J?8QE2[%V
MBF)*D@^4\^G>GUE:QBU8YO5_!UA?1O):(MK<X^79Q&QXZKVZ=L=<\UPNI:+?
MZ3)B[@94SA95Y1NO0_@3@\^U>O4R:&*XB:*>))8VZHZA@?P->CALRJTM):H]
M7"9M6H>[/WH^>_WGBM%=WJW@6.0B32G$1S\T4K$KC'8X)_//7MBK&G^'++3&
M#-'YMPO_`"TD&<'CH.@Y&1W]Z]9YE1Y.:.K['UN7U:>/_A2VW3W^[^D<UI?A
M>ZO&WW8:VA]"/G;GD8[?4^W!KK[#3;7383';1[=V-S$Y9B/4_P"1S5NBO+KX
MJI6W>G8^BHX:G2VW[A1117.=`4444`%%*`33@`*J,&R7-(0+ZTX#%%%;**1D
MY-A1113)"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BF2RQP1F2:1(T'5G8`#\37*:EXQ^]%I
MT?J/.D'UY"_D<G\JUIT9U'[J,ZE6-->\SI+_`%&VTV`RW,H7@E5S\S^P'?J*
MX[5/%=S>!HK0&VBS]X-\YP?4=.W`_.L&662>0R32/(YZL[$D_B:97IT<)"&L
MM6>?5Q4IZ+1!11176<H4444`%%%%`!1110`4444`%%%%`!1110`4^**2>01Q
M1M(YZ*@R3^%;NE^%;F["RW1-O%G[I7YSSZ'IWY/Y5UUCI]MIT`BMXPO`#-CY
MF]R>_4UPU\?3IZ1U9VT<%.IK+1'.Z=X0^[)J$GH?)C/TX)_,<?G74Q11P1B.
M*-8T'14&`/PI]%>-6KU*KO-GJTJ,*2M%!11161J%%%%`!12A<T\#%7&#>Y#F
MD-"^M.HHK512V,FV]PHHHIB"BBB@`HHHH`****`"BBB@`HHHH`IZK_R![[_K
MWD_]!->7UZAJO_('OO\`KWD_]!->7UZF`^%GG8WXD%%%%=YQ!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`5Z'X9_Y%ZU_P"!
M_P#H9KSRO0_#/_(O6O\`P/\`]#->=F?\)>OZ,\K./X"]?T9K4445XA\V%%%%
M`!1110`4444`*"0<@D'U%6(KH]).?<56HJ7%/<4HI[FFK!E!!R#2UFH[(<J2
M*M1W2MP_RGU[5C*FUL82IM;%BFNBR##*#3J*@F%25.2G!V:ZHI26K+RGS#T[
MU7K5J*6!)>O#>HK6-3N?89;Q5.+5/&*Z_F6_S77Y?B9]%2RP/&>F1ZBF!?6M
MHKFV/LZ.)HUZ:J4I73[#0,T\+BEHK:,$AN;844459`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`445G:CKEAIF5FEW2C_`)91\MVZ^G7/.*J,7)VBA2DHJ[-&N?U7Q5:V:^7:
M%+F;U4_(O'!SW^@]^17,ZIX@O=4#1N1%;DY\I.^#QD]3_+CI637HT<$EK4^X
MX*N,Z0+>H:G=:G,)+J3=MSM4#"J#Z#_)XJI117>DHJR.)MMW84444Q!1110`
M4444`%%%%`!1110`4444`%%6+2QNK^0I:P-(1U(Z#ZGH.E=?IWA.UMMLEVWV
MB48.WH@/';OWZ\'TKGK8JG1^)Z]C>CAZE7X5H<UIFB7FINI2,I`3S,PX`YZ>
MO3M^E=CI>@6>F%9%!DN`,>:_;CG`[?SYZUJT5XU?&U*NFR/6HX2G2UW84445
MR'4%%%%`!10!FGA<4U%LER2&@$TX`"EHK:,$C)R;"BBBJ)"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@"GJO_`"![[_KWD_\`037E]>H:K_R![[_KWD_]
M!->7UZF`^%GG8WXD%%%%=YQ!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`5Z'X9_Y%ZU_X'_Z&:\\KT/PS_R+UK_P/_T,UYV9
M_P`)>OZ,\K./X"]?T9K4445XA\V%%%%`!1110`4444`%%%%`!1110!)',\9&
M#E?0U<BG27IPWH:SZ*B4$R)04C4HJE'<LG#?,/7O5M)%D7*G\/2L91:,)0<1
MU0R6ZMRORG]*FHHC)Q=T;X7&5L+/GHRL_P"MR@R,APPQ3:T"`P((R#5>2V[I
M^1KKA73TEH?:9?Q)1K6AB/<EWZ?\#Y_>5Z*4@@X(P?>DK<^E335T%%%%`PHH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHI'=8T9W8*JC)8G``]:`%J"[O+>P@,]S*(X\@9/.3Z`#DUSFI^,(E1HM.
M4NY&!,PP%Z<@'D]^N/QKD[FZGO)C-<2O*Y[L>G?`]!STKMHX.4M9Z(Y*N+C'
M2.K-[5/%MQ<EH[',$)&-Y'SGCGV'X<\=:YQW:1V=V+,QR6)R2?6DHKTJ=*--
M6BCSYU)3=Y,****T("BBB@`HHHH`****`"BBB@`HHHH`***VM,\,WFH(LKD0
M0,,AF&2PYZ#_`!QU[U%2I"FN:;L7"G*H[15S(BBDGD$<4;2.>BH,D_A73:7X
M2=F\S4CM7M$C<GG^(^GT]>HKH[#2K/34Q;0@-C!D/+-T[_ATZ5<KR*^8REI3
MT7XGJ4<!&.M35_@0VUK!9PB*WB6-!V4=>V3ZGWJ:BBO-;;=V>@DDK(****`"
MBBE"DT)-[";2W$IP7UI0,4M:QII;F;GV"BBBM#,****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`IZK_R![[_`*]Y/_037E]>H:K_`,@>^_Z]
MY/\`T$UY?7J8#X6>=C?B04445WG$%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%:>DZ#?ZR2;6-1$IPTLAPH.,X]3^`/45,YQA'F
MD[(BI4A3CS3=D9E>C^'X)K;0K:.>*2)QNRKJ5(^8]C5O2?"VG:7MD\O[1<#!
M\V49P>/NCH.1D=QZUM,JN,,`17@8W,(5DH06G<^9S'-(5TJ=-:)WN9E%69;4
M]8^?8U7((.""#Z&N)23V/.C)/82BBBJ&%%%%`!1110`4444`%%%%`!1110`4
MH)!R"0?44E%("U'=]I!^(JR"",@@CU%9E.21HSE3]1ZUG*FGL92I)[&E14$5
MRK\-A3^E3UDTUN8M-;C7C608856DMV4Y7YA^M6Z*N%64-CTL!F^)P3M!WCV>
MWR[&=15UX4?G&#ZBJKQ-']X<>HKLA5C,^YR_.L-C?=3Y9=G^G<91116AZX44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%4=2U>ST
MN/=<29<XQ$F"YSWQZ<'FN+U7Q+>:DOE)_H\'=$8Y;C&&/<=>/?O711PTZNJV
M,:M>%/?<ZC5?$MGIK>4G^D3]T1AA><88]CUX]NU<5J&K7NIOFYF)7.1&.%7K
MV_'J>:I45ZE'#PI;;GFU:\ZF^P4445N8A1110`4444`%%%%`!1110`4444`%
M%%2VUK/>3"*WB:1SV4=.V3Z#WI-I*[&DV[(BJ_IVCWFJ$FW0"-3AI'.%!Q^O
MX>HKI-,\)10.LU]()G4Y$:CY._7/7MZ?C72(BQHJ(H55&`H&`!7FU\QC'2EK
MYGH4<`WK4T\C)TOP[9Z<%=E$]P#GS'7ISQ@=NG7K6O117DSJ2J/FD[L]2$(P
M5HJP4445!0444`9H`*4`FE"^M.K2-/N9N?80*!2T45JDEL9MW"BBB@04444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`4]5_Y`]]_P!>
M\G_H)KR^O4-5_P"0/??]>\G_`*":\OKU,!\+/.QOQ(****[SB"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***M66G7>H.R
MVL)D*#+<@`?B:4I**NW9#2<G9%6BI)X);6=X9D*2(<,I[5'0FFKH35M&%%%%
M,`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBG(CR2+'&K,[$!549))[`4`-JS96%U
MJ-R+>TA:64@G`P,`=R3P*Z72/`\US&D^HRM!&PR(D'[SOUSPO8]_PKN+2SMK
M&`06L*11CLHQDXQD^IXZFO+Q.9TZ?NT]7^!XV,SBE2]VE[S_``_X/R^\YK1O
M!,%JPFU)DN9!]V-<[%(/4_WNW!&.O6NJ1$CC6.-55%`"JHP`!V`IU%>%6KU*
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
M***H04444`%%%%`!1110`4444`%%%%`!14MM:SWDPBMXFD<]E'3MD^@]ZZO3
M/",2HLNH,7<C)A4X"]>"1U[=,?C6%;$4Z*]YFU*A.J_=1S=AI5YJ3XMH25S@
MR'A5Z=_QZ=:[+3/#-GI[K*Y,\ZG(9A@*>>@_QST[5LHBQHJ(H55&`H&`!2UX
M]?'5*NBT1ZU'!PIZO5A1117$=84444`%%`&:>%Q346R7)(:%)IP`%+16T8)&
M3DV%%%%42%%%%`!1110`4444`%%%%`!1110`5D>)_P#D7;K_`(!_Z&M:]9'B
M?_D7;K_@'_H:UK1_B1]49U?X<O1GG5%%%>\>*%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`445+;6L]Y,(K>)I'/91T[9/H/>DVDKL:3;LB*K^G:/>:
MH2;=`(U.&D<X4''Z_AZBNETOPG#;MYM\RSOVC&=BG/Z]O;KUKHT18T5$4*JC
M`4#``KS:^8QC[M+7S/0HX!O6IIY&3I?AVSTX*[*)[@'/F.O3GC`[=.O6M>BB
MO)G4E4?-)W9ZD(1@K15@HHHJ"@HHHZT`%*`32A?6G5I&GW,W/L(%`I:**U22
MV,V[A1110(****`"BBB@`HHHH`****`"BBB@`HHHH`****`"D*TM%)I/<YL5
M@Z.*CRU8W_,913Z:164H-;'Q^.R&M0O.C[T?Q^[K\ON$IR2-&<J?J/6FT5FT
M>"UT9=CN4<`,=K>_2IZRZECN'CXSE?0UE*GV,94NQ?HJ..9).AY]#4E9-6,6
MFMPHHHH`****`"BBB@".6!)>O#>HJG+`\77E?45H45<9M%QFXF715R2U5N4^
M4^G:JKHR'#`BMHR3-XS4MAM%%%44%%%%`!1110`4444`%%%%`!1110`4444`
M3Q7+)PV6'ZU:219!E3]1Z5G4H)!R"0?45G*"9G*FGL:=%58[OM(/Q%6001D$
M$>HK%Q:W,)1<=P95<88`BJLEH028^1Z&K=%-2:V._`9IBL#*]&6G9ZI_+_*S
M,HC!P>M%:4D22#YASZ]ZJ26SIR/F7UK:,T]#[S+N(L+B[0G[D^SV?H_T?RN0
M4H4FG!0*6NB-/N>XY]A``*6BBM#,****!!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!4-S=06
M<)FN)4B0=V/7O@>IXZ5A:EXNM;;='9K]HE&1NZ(#SW[]NG!]:X^\O[J_D$EU
M.\I'0'H/H!P.@KLHX.<]9:(Y:N*C#2.K.BU7Q>[-Y6FC:HZS.O)Y_A'I]?7H
M*Y>662>0R32/(YZL[$D_B:917ITZ4*:M%'GU*LJCO)A1116AF%%%%`!1110`
M4444`%%%%`!1110`445JZ7H%YJ8610([<G'FOWYYP._\N.M1.<8+FD[(J$)3
M=HJYEHC2.J(I9F.`H&2370Z7X4N+@K)?9@A(SL!^<\<?3\>>.E=+I^B6.FX:
M&+=*/^6LG+=^GIUQQBM&O)KYBWI2T\SU*.`2UJ:E>TL;6PC*6L"Q@]2.I^IZ
MGK5BBBO-;<G=GH))*R"BBBD,***4+FA)O83:6XE."^M.`Q16T::6YFYM[!11
M15F84444`%%%%`!1110`4444`%%%%`!1110`4444`%9'B?\`Y%VZ_P"`?^AK
M6O61XG_Y%VZ_X!_Z&M:T?XD?5&=7^'+T9YU1117O'BA1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4J(TCJB*69C@*!DDUK:7X=O-1*NRF"W(SYCKUXXP._7K
MTKL].TFTTR/;;QY<YS(^"Y]L^G`XKBKXVG2T6K.NA@YU-7HCFM,\)2SHLU](
M8489$:CY^_7/3MZ_A76VUK!9PB*WB6-!V4=>V3ZGWJ:BO'K8FI6?O/0]:CAX
M4E[J"BBBL#8****`"BE"DTX`"JC!LES2$"^M.Z445LHI&3DV%%%%,D****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@!",TA&*=
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
M3T45YC;;NST$DE9!1110,***4*30DWL)M+<2G!?6E`Q2UK&FEN9N?8****T,
MPHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHJ.XN(K6!YYW"1H,LQ[4TKZ(-B2J6H:M9:8F;F
M8!L9$8Y9NO;\.IXKF]5\7NS>5IHVJ.LSKR>?X1Z?7UZ"N7EEDGD,DTCR.>K.
MQ)/XFNZC@I2UGHCCJXM1TAJ;>I^*;V\=DMF-M!GC;PY''4]NG;UQS6#117HP
MIQ@K11Y\YRF[R844459(4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`5M^%_P#D)R?]<3_-:Q*V_"__`"$Y/^N)
M_FM88G^%(VP_\6)UE%%%>$>R%6+/_7'_`':KU8L_]<?]VF!=HHHH$%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!15:\O[6PC$EU.
MD0/0'J?H!R>HKD-4\6W%R6CL<P0D8WD?.>.?8?ASQUK:E0G5V6AE4K0I[G2Z
MGKMEI:,'D#S@<0J>2>.OIU[_`*UQFJ>(+W5`T;D16Y.?*3O@\9/4_P`N.E93
MNTCL[L69CDL3DD^M)7J4<+"GKNSSJN)G4TV04445TG.%%%%`!1110`4444`%
M%%%`!1110`445)!!+=3I#"A>1SA5'>DVDKL$KZ(CJY8:5>:D^+:$E<X,AX5>
MG?\`'IUKH=+\(A2LNHL&X_U*$^G=A^/`_.NHBBC@C$<4:QH.BH,`?A7G5\PC
M'2GJ_P`#T*&!E+6IHC%TSPO9VB*]RHN)\<[N4!YZ#OU[^F>*W:**\BI5G4=Y
MNYZE.G&FK15@HHHJ"PHHH`S0`4H!-*%]:=6D:?<S<^P@4"EHHK5)+8S;N%%%
M%`@HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HK+U77K/2EVNWFS]HD(R.,_-Z#I^?0UQ6IZ[>
MZH[!Y"D!/$*G@#CKZ]._Z5TT<+.IKLC"KB(4]-V=-J7BZUMMT=FOVB49&[H@
M//?OVZ<'UKC[R_NK^0274[RD=`>@^@'`Z"JU%>I2H0I?#N>;4K3J;A1116QD
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`5M^%_^0G)_P!<3_-:Q*V_"_\`R$Y/^N)_FM88G^%(
MVP_\6)UE%%%>$>R%6+/_`%Q_W:KU8L_]<?\`=I@7:***!!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%8FI^)[+3W:%`;B=3@HIP%/'!;_#/3
MM5PA*;M%7)G.,%>3-IW6-&=V"JHR6)P`/6N5U7Q>BKY6FC<QZS.O`X_A'K]?
M3H:YO4-6O=3?-S,2N<B,<*O7M^/4\U2KTJ."4=9ZG!5Q;EI#0FN;J>\F,UQ*
M\KGNQZ=\#T'/2H:**[4DM$<3=]6%%%%,`HHHH`****`"BBB@`HHHH`****`"
MBM/2]"N]4;<B^5!WE<'!YQ\OJ>OY=179:7H5II:[D7S9^\K@9'&/E]!U_/J:
MY*^,ITM-WV.JCA)U==D<UI?A6YNPLMT3;Q9^Z5^<\^AZ=^3^5=A:6-K81E+6
M!8P>I'4_4]3UJQ17C5\54K/WGIV/6HX>%+X5KW"BBBN<W"BBB@`HI0I-.``J
MHP;)<TA`OK3NE%%;**1DY-A1113)"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BF2RQP1F2:1
M(T'5G8`#\37*ZIXP"EHM-4-Q_KW!].RGTXY/Y5K3HSJ.T49U*L::O)G1W^HV
MVFP&6YE"\$JN?F?V`[]17':IXKN;P-%:`VT6?O!OG.#ZCIVX'YU@RRR3R&2:
M1Y'/5G8DG\33*].CA(0UEJSSZN*E/1:(****ZSE"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`K;\+_\`(3D_ZXG^:UB5M^%_^0G)_P!<3_-:PQ/\*1MA_P"+$ZRB
MBBO"/9"K%G_KC_NU7JQ9_P"N/^[3`NT444""BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBH;FZ@LX3-<2I$@[L>O?`]3QTII-Z(&[:LFJCJ6KV>EQ[KB3+G&
M(DP7.>^/3@\US&I^+Y;A&AL8S"C#!E8_/VZ8X'?U_"N9=VD=G=BS,<EB<DGU
MKNHX)O6IH<57&):0U-G5?$MYJ2^4G^CP=T1CEN,88]QUX]^]8M%%>E"$8*T4
M<$IRF[R844451(4444`%%%%`!1110`4444`%%%%`!13XHI)Y!'%&TCGHJ#)/
MX5U&E^$2P6746*\_ZE"/7NP_'@?G6-:O3I*\V:TJ,ZKM%'.6EC=7\A2U@:0C
MJ1T'U/0=*[#2_"MM:%9;HBXEQ]TK\@X]#U[\G\JW(((K6!(84"1H,*H[5)7C
MU\?.II'1'JT,%"GK+5A1117"=H4444`%%'6G!?6FHM["<DA`":<%`I:*UC!(
MR<VPHHHJR`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHK.U'7+#3,K-+NE'_`"RCY;MU].N>
M<548N3M%"E)15V:-<_JOBJULU\NT*7,WJI^1>.#GO]![\BN9U3Q!>ZH&C<B*
MW)SY2=\'C)ZG^7'2LFO1HX)+6I]QP5<9T@6]0U.ZU.8274F[;G:H&%4'T'^3
MQ52BBN])15D<3;;NPHHHIB"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*V_
M"_\`R$Y/^N)_FM8E;?A?_D)R?]<3_-:PQ/\`"D;8?^+$ZRBBBO"/9"K%G_KC
M_NU7JQ9_ZX_[M,"[1110(****`"BBB@`HHHH`****`"BBB@`I'=8T9W8*JC)
M8G``]:R=2\1V&G;DW^=.,CRXSG!YZGH.1]?:N*U+6;W52!<.!&IRL:#"@XQG
MU/X^IKJHX6=35Z(YZN)A#1:LZ?5?%T-LWE6"I._>1L[%.?\`Q[OTXZ=:X^[O
M+B_G,]S*9),`9/&!Z`#@5!17ITJ$*2]U:GG5*TZFX4445L9!1110`4444`%%
M%%`!1110`4444`%%%7].T>\U0DVZ`1J<-(YPH./U_#U%3*<8+FD[(J,7)VBK
MLH5NZ9X7O+MU>Y4V\&>=W#D<]!VZ=_7/-=+IWAZQT_:^SSIQ@^9(,X/'0=!R
M/K[UK5Y5?,;Z4OO/2HX#K4^XJ6&FVNFPF.VCV[L;F)RS$>I_R.:MT45Y<I.3
MO)ZGI1BHJR"BBBD,***4`FA*^P-V$IP7UI0`*6M8T^YDY]@`Q1116AF%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%([K&C.[!549+$X`'K0`M5KR_M;",274Z1`]`>I^@')
MZBN>U/QA$J-%IREW(P)F&`O3D`\GOUQ^-<G<W4]Y,9KB5Y7/=CT[X'H.>E=M
M'!REK/1?B<E7%QCI'5F]JGBVXN2T=CF"$C&\CYSQS[#\.>.M<X[M([.[%F8Y
M+$Y)/K245Z5.E&FK11Y\ZDIN\F%%%%:$!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`5M^%_^0G)_UQ/\UK$K;\+_`/(3D_ZXG^:UAB?X4C;#
M_P`6)UE%%%>$>R%6+/\`UQ_W:KU8L_\`7'_=I@7:***!!1110`4444`%%%%`
M!14=Q<16L#SSN$C099CVKE-4\8%@T6FJ5Y_U[@>O93Z\<G\JUI49U'[J,ZE6
M%->\SH]0U.UTR$274FW=G:H&68CT'^1S7&ZGXIO;QV2V8VT&>-O#D<=3VZ=O
M7'-8DLLD\ADFD>1SU9V))_$TRO3HX2$-7JSSJN*E/1:(****ZSF"BBB@`HHH
MH`****`"BBB@`HHHH`****`"I[2SN+Z<0VT1DDP3@<8'N3TK0T#2X-1N':XD
M811%24`^_G/&>W3_`/57=VUM!:0B*VB2./T4=>.I]3[UPXK&JB^6*NSLP^#=
M5<S=D8.E^$X;=O-OF6=^T8SL4Y_7M[=>M=&B+&BHBA548"@8`%+17BU:TZKO
M-GKTZ4*:M%!11169H%%%%`!0!FG!?6G5<:;>Y#FN@@7%+116J26QDVWN%%%%
M,04444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`451U+5[/2X]UQ)ESC$28+G/?'IP>:XO5?$MYJ2
M^4G^CP=T1CEN,88]QUX]^]=%'#3JZK8QJUX4]]SI]3\3V6GNT*`W$ZG!13@*
M>."W^&>G:N+U#5KW4WS<S$KG(C'"KU[?CU/-4J*]2EAX4MMSS:M>=3?8****
MW,0HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`K
M;\+_`/(3D_ZXG^:UB5M^%_\`D)R?]<3_`#6L,3_"D;8?^+$ZRBBBO"/9"K%G
M_KC_`+M5ZL6?^N/^[3`NT444""BBB@`HHK+U77K/2EVNWFS]HD(R.,_-Z#I^
M?0U482F[10I245>1J5SVJ>*[:S+16@%S+C[P;Y!D>HZ]N!^=<QJNO7FJMM=O
M*@[1(3@\Y^;U/3\N@K+KT:."2UJ?<<%7&-Z0+-Y?W5_()+J=Y2.@/0?0#@=!
M5:BBN]))61Q-MN["BBBF(****`"BBB@`HHHH`****`"BBB@`HHHH`****`.C
M\*?\O?\`P#_V:NF21D/RG\*YGPI_R]_\`_\`9JZ2O$QG\:7]=#V,+_"7]=2X
MEPC<'Y3[U+6=4B3.G&<CT-<3I]CK4^Y=HIL;K+]WMUS4H`%2H-E.:0T+FG@8
MHHK6,4C)R;"BBBJ)"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BD=UC1G=@JJ,EB<`#UKF]5\
M70VS>58*D[]Y&SL4Y_\`'N_3CIUK2G2G4=HHB=2,%>3-^YNH+.$S7$J1(.['
MKWP/4\=*Y#4_%\MPC0V,9A1A@RL?G[=,<#OZ_A7/W=Y<7\YGN93))@#)XP/0
M`<"H*].C@XPUGJSSZN+E+2.B%=VD=G=BS,<EB<DGUI***[#D"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*V_"_
M_(3D_P"N)_FM8E*K,C!E)5@<@@X(-15ASP<>Y=.?))2/1J*Y:P\220JL=VAE
M4#'F+][\<]>WI^-=+!<0W,0D@D61#W4]/KZ&O$JT)TG[R/7IUH5%[I)5BS_U
MQ_W:KU8L_P#7'_=K(U+M%%,EEC@C,DTB1H.K.P`'XFF(?5:\O[6PC$EU.D0/
M0'J?H!R>HKF]4\8!2T6FJ&X_U[@^G93Z<<G\JY2XN);J=YYW+R.<LQ[UVT<%
M*6L]$<E7%QCI#5F]J7BZZN=T=FOV>(Y&[JY'/?MVZ<CUKG:**]*%.--6BCSY
MU)3=Y,****L@****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
MZ/PI_P`O?_`/_9JZ2N;\*?\`+W_P#_V:NDKQ,7_&E_70]?"_PE_74****YCH
M+5E_'^%6ZJ67\?X5;IB"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBJ6H:M9:8F;F8!L9$8Y
M9NO;\.IXJHQ<G9";25V7:Q]4\1V6FAD1A<7`./*1NG/.3T&,=.M<SJ?BF]O'
M9+9C;09XV\.1QU/;IV]<<U@UWT<%UJ?<<57&=(&AJ6LWNJD"X<"-3E8T&%!Q
MC/J?Q]36?117H1BHJT4<$I.3NPHHHJA!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`5)!<36THD@D
M:-QW4]?KZBHZ*32>C!.VJ.GL/$L;*L=ZI5@,>:HR#]0.G;I^E=/8LKON4AE*
MY!!R".*\QJ6.YN(HFBCGE2-\AE5R`V>N17%5P,9.\-#LIXR45:6IW.I^*;*S
M1DMF%S/CC;R@/'4]^O;TQQ7':AJU[J;YN9B5SD1CA5Z]OQZGFJ5%;TL/"GMN
M8U:\ZF^P4445N8A1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`='X4_Y>_P#@'_LU=)7-^%/^7O\`X!_[-725XF+_`(TOZZ'K
MX7^$OZZA1117,=!:LOX_PJW52R_C_"K=,04444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!4=Q<16L#SSN
M$C099CVK`U+Q=:VVZ.S7[1*,C=T0'GOW[=.#ZUQ]Y?W5_()+J=Y2.@/0?0#@
M=!791P<YZRT1RU<5&&D=6=%JOB]V;RM-&U1UF=>3S_"/3Z^O05R\LLD\ADFD
M>1SU9V))_$TRBO3ITH4U:*//J595'>3"BBBM#,****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`Z/PI_R]_\``/\`V:NDHHKQ,7_&E_70]?"_
MPE_74****YCH+5E_'^%6Z**8@HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`ANY_LMG/<;=WE1L^W.,X&<5Y[J
MNO7FJMM=O*@[1(3@\Y^;U/3\N@HHKT<#"+3DUJ<&,G)6BGH9=%%%>D<`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
8%`!1110`4444`%%%%`!1110`4444`?_9
`




#End
