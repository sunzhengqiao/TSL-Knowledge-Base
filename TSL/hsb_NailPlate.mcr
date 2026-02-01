#Version 8
#BeginDescription
Modified by:  Alberto Jena (aj@hsb-cad.com)
Date: 13.10.2015  -  version 1.16











#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 16
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2008 by
*  hsbSOFT 
*  IRELAND
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
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 25.05.2008
* version 1.0: Release Version
*
* date: 12.06.2008
* version 1.1: Pull Down for the Models
*
* date: 17.07.2008
* version 1.2: Renaming this TSL from hsb_MP to hsb_Nailplate
*
* date: 10.05.2010
* version 1.3:	Change the Table and some small fixes on export
*
* date: 03.09.2010
* version 1.4:	Add Properties for other Nail Plate type so the customer can define it
*
* date: 11.02.2011
* version 1.5:	Add group for the new data base
*
* date: 04.04.2011
* version 1.7:	Add support for the space stud clip and A9 NailPlate and blocks
*
* date: 15.04.2011
* version 1.8:	Added functionality to export nailplate with an element if the element is valid
*
* date: 03.06.2011
* version 1.9:	Fix location of the content blocks
*
* date: 07.06.2011
* version 1.10:	Remove the use of blocks until version 16 is adopted by Customer
*
* date: 29.06.2011
* version 1.11:	Update Nailplate Model from List
*
* date: 03.08.2011
* version 1.12:	Bugfix in IF statement for drawing of blocks/metaparts
*
* date: 24.11.2011
* version 1.13:	Bugfix in IF statement for drawing of blocks/metaparts
*
* date: 02.02.2012
* version 1.14:	Bugfix with the faces
*
* date: 02.02.2012
* version 1.16: Add support for M20 Nailplate
*/

Unit (1, "mm");

PropDouble dTh (0, U(2), T("Thickness"));
PropDouble dWi (1, U(36), T("Width"));
PropDouble dLe (2, U(100), T("Length"));
PropString sDispRep(0, "", T("Show in Disp Rep"));

String strNailPlateModels[]={"Other Model Type", "NP-80-100", "NP-80-200", "NP-80-300", "NP-100-100", "NP-100-200", "NP-100-300", "NP-150-100", "NP-150-200", "NP-150-300"};
PropString sModel(1, strNailPlateModels,T("Model Type"), 1);

PropString strCustomNailPlateModel (2, "**Other Type**", T("Other Nail Plate Type"));
strCustomNailPlateModel.setDescription( T("Please fill this value if you choose 'Other Model Type' above") );
String sFaces[]={"Face 1", "Face 2", "Face 3", "Face 4"};
PropString sFace (3, sFaces, "Select the Face");

//PropInt nColor(0, 5, "Color");

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

String sNailPlateModel;

if (strNailPlateModels.find(sModel, 0)==0)
	sNailPlateModel=strCustomNailPlateModel;
else
	sNailPlateModel=sModel;

int nFace=sFaces.find(sFace, 0);

if (_bOnInsert)
{
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	showDialogOnce();
	_Pt0=getPoint(T("Pick a Point"));
	_Beam.append(getBeam(T("Select a Beam")));
	return;
}

Vector3d vx;
Vector3d vy;
Vector3d vz;

String sGroup="";
if (_Map.hasString("Group"))
{
	sGroup=_Map.getString("Group");
}

if (_Beam.length()<1)
{
	eraseInstance();
	return;
}

int nSetFaces=false;

if (_Map.hasVector3d("vx"))
{
	nSetFaces=false;
	vx=_Map.getVector3d("vx");
}
else
{	
	nSetFaces=true;
	vx=_Beam[0].vecX();
}
if (_Map.hasVector3d("vy"))
{
	vy=_Map.getVector3d("vy");
}
else
{
	vy=_Beam[0].vecZ();
}
if (_Map.hasVector3d("vz"))
{
	vz=_Map.getVector3d("vz");
}
else
{
	vz=_Beam[0].vecY();
}

if (nSetFaces)
{
	if (nFace==0)
	{
		vz=_Beam[0].vecY();
		vy=_Beam[0].vecZ();
	}
	if (nFace==1)
	{
		vz=_Beam[0].vecZ();
		vy=-_Beam[0].vecY();
	}
	if (nFace==2)
	{
		vz=-_Beam[0].vecY();
		vy=-_Beam[0].vecZ();

	}
	if (nFace==3)
	{
		vz=-_Beam[0].vecZ();
		vy=_Beam[0].vecY();

	}

}

vx.vis(_Pt0, 1);
vy.vis(_Pt0, 3);
vz.vis(_Pt0, 150);

setDependencyOnEntity(_Beam[0]);

int nQty = 1;

_ThisInst.assignToGroups(_Beam[0]);

PLine plMP(vz);
plMP.addVertex(_Pt0-vx*(dLe*0.5)+vy*(dWi*0.5));
plMP.addVertex(_Pt0+vx*(dLe*0.5)+vy*(dWi*0.5));
plMP.addVertex(_Pt0+vx*(dLe*0.5)-vy*(dWi*0.5));
plMP.addVertex(_Pt0-vx*(dLe*0.5)-vy*(dWi*0.5));
plMP.close();
Body bdMP(plMP, vz*dTh, 1);

Display dp(-1);
if (sDispRep!="")
	dp.showInDispRep(sDispRep);

if (sNailPlateModel=="SpaceStud 80mm")
{
	String sBlockPath=_kPathHsbInstall+"\\Content\\UK\\Blocks\\SPACESTUDCLIP.dwg";
	Block blk (sBlockPath);
	dp.draw(blk, _Pt0, vx, vy, vz);
}
else if (sNailPlateModel=="SpaceStud 55mm")
{
	String sBlockPath=_kPathHsbInstall+"\\Content\\UK\\Blocks\\SPACESTUDCLIP 55mm.dwg";
	Block blk (sBlockPath);
	dp.draw(blk, _Pt0, vx, vy, vz);
}
else if (sNailPlateModel=="A9 Nail Plate")
{
	String sBlockPath=_kPathHsbInstall+"\\Content\\UK\\Blocks\\A9 Nailplate.dwg";
	Block blk (sBlockPath);
	dp.draw(blk, _Pt0, vx, vy, vz);
}
else if (sNailPlateModel=="M20 Nailplate")
{
	String sBlockPath=_kPathHsbInstall+"\\Content\\UK\\Blocks\\M20 Nailplate.dwg";
	Block blk (sBlockPath);
	dp.draw(blk, _Pt0, vx, vy, vz);
}
else
{
	dp.draw(bdMP);
}



String sCompareKey = (String) sNailPlateModel;
setCompareKey(sCompareKey);

String sQty=(String) nQty;
exportToDxi(TRUE);

Element el=_Beam[0].element();
if(el.bIsValid())
{
	exportWithElementDxa(el);
	dxaout(sGroup, "");
	dxaout("U_MODEL", sNailPlateModel);
	dxaout("U_QUANTITY", sQty);
}
else
{
	dxaout(sGroup, "");
	dxaout("U_MODEL", sNailPlateModel);
	dxaout("U_QUANTITY", sQty);
}

Map mp;
mp.setString("Name", sNailPlateModel);
mp.setInt("Qty", 1);

_Map.setMap("TSLBOM", mp);










#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`'A`FL#`2(``A$!`Q$!_\0`
M'P```04!`0$!`0$```````````$"`P0%!@<("0H+_\0`M1```@$#`P($`P4%
M!`0```%]`0(#``01!1(A,4$&$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*
M%A<8&1HE)B<H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&EJ<W1U
M=G=X>7J#A(6&AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&
MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ>KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!
M`0$!`0````````$"`P0%!@<("0H+_\0`M1$``@$"!`0#!`<%!`0``0)W``$"
M`Q$$!2$Q!A)!40=A<1,B,H$(%$*1H;'!"2,S4O`58G+1"A8D-.$E\1<8&1HF
M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@H.$
MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#A:***^</V
M@****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@#2T[7-1TJ3=:W+J,8*,<J>"!P
M?K76Z9\0T*I'J5L0W1I8NG3KCU)K@>:*WIXFI3V9Y.,R;"8O6<;/NM'_`,$]
MNL=4L=24FSNHYMIP0IY'3M^(JW7A"221-NC=D.,94XKIM,\<ZG9LBW1%U".#
MNX;KG.?7K7=3QL'I-6/EL9PO7I^]0ES+ML_\CU&BN=TSQGI6H*JR2?9IB0-D
MO<DX&#_GK70JRNH96#*1D$'((KLC*,E>+N?.5L/5H2Y*L6GYBT4451B%%%%`
M!1110`4444`%%%%`!1110!X+1117SA^T!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`5J:?K^IZ7M%M=N$!SY;<KTQTK,-`Q51G*+O%V,*V&I
M5X\M2*DO,]"T[XAP2;EU&V,1Y(:+YAVXP?QKKK/4;._0/:W,<H()&UN<`XZ=
M:\/&.]203S6TRRP2-'(IR&4X/K793QLEI-7/FL9PM1G[V'EROL]4>ZT5YAIG
MCK4K-5CN@MW'D?,_#@9YY[]>_I78Z9XOTG4F6,3>1*0#LEXYQD@'IQBNZGB*
M<]GJ?+XO)\7A;N<+I=5JO^`;U%(K*ZAE8,I&00<@BEK<\L****`"BBB@`HHH
MH`\%HHHKYP_:`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH"QIZ?X@U/2]HMKMP@.?+;E>F.E=EI7Q!MYY/+U&#R"3Q)'R
MHZ=>_KS7G>31713Q-2&ST/(QF2X3%7<HVEW6C_R9[C9W]KJ$/FVDZ3)ZJ>GX
M?@:L5X7!<SVT@D@E>-@0P*MCD=*ZG3?'M_:LJ7R+<Q``9'ROP/7OGCK7=3QL
M9:2T/E,9PQB*5Y47S+[G_D>ET5AZ9XLTG4E0"X$,S<>7+P<XR>>F/\*W*[(R
M4E=,^=JT*E*7)4BT_,****9F>"T445\X?M`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`]$#N`3M7DLV,X
M`Y)_*O8/"\GG>&;&4`@.A;!.<9)[]Z\:NY/)M!&/OS\G_<!_J1_X[[U[#X0_
MY%+3/^N(_F:]/`QM<^%XGJ<[C;9-K_,VZ***]`^1/!:***^</V@****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@!:<
MD9=PH(&>I/0#U/M3:2XD\FR+#[TQ,8/H!@M^>0/H350CS.QSXFK[.FWUZ>I2
MO)Q/<,RY$8^5`>RCI^/<^Y->V>$/^12TS_KB/YFO"Z]T\(?\BEIG_7$?S->G
MA?B9\/GJM2BO,VZ***[CY<\%HHHKYP_:`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`'HC2.J*,LQP![U1O9EFN/
MD.8HQL0^H'?\22?QJY,_DVDD@^\_[M?Q'S'WXX_X$*RNU=%-6C?N>/BZG/4Y
M>D?S'1@F50$\PDC"<_-[<<U[UX?LWL-`LK608>.,`C.<=\=!S^%>8>`=#_M3
M7!<S1[K:U^<Y&0S=AR"#ZU[#7HX:%H\W<^-SS$*=14U]G?YA11174>">"T44
M5\X?M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`+UI0"S`*"23@`=Z04XOY,$LP.&4;4/^T?ZXW$'U`JHQYG8QKU/9TW
M+^K]"I?3!YA&C`QQ#:"#PQ[GWY[^@%4SUS172>"M&_MC7XQ(,V]OB63GKCH.
MH/6NN$>9J*/GJ]94:4JD^FOJSTCP5I!TCPY`DBJ)YOWKX49YZ`D=<"NBHHKU
M4DE9'P-2I*I-SEN]0HHHID'@M%%%?.'[0%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`"]!5?49,2I!VAR&_WS][^0'X9[
MU<#F%))^\8RG^\3@?EUQ_LUBUO35E?N>3C*G--06R_/_`(`M>Q^`='?2_#XE
MF#++='S2AXVCMP0,'%>;>%=)76?$-M:N0(@?,D![J.2.AKW-55%"JH50,``8
M`%>AA8;S9\CGF)VHKU?Z"T445V'S84444`>"T445\X?M`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4=**D0A"\K`%8E+X(R"
M>P(]"2!^-.*N[&56HJ<')]"K?R;2EL#]SYI/]X]OP''L2U4:4LS,68EF)R23
MDDUHZ!IAU?6[6RPVR1QO*J3A1U)QVKK2NTD?/U:G)"52?FV>C?#G1?L>E-J,
MH_>W?W>>B#IW[G\:[:FQQK%$D:#"(H51Z`4ZO5A%1BHH^"KUI5ZLIRW84445
M1B%%%%`'@M%%%?.'[0%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`+4-])LB2W'4XD?\1\H_(Y_X%[59B"A]\@_=)\S_0=OJ>@]
MR*R9':61I7.7<EF/J36U)67,>7C:MY*FNFK_`$&]\UZ?\-M#\BTDU:>/$DWR
M0[AR%[D9'?V->=:;9OJ.I6UG&I9II`N`0#COU]J]^M;:*SM8K:!0L42A5``'
M`^E=^&A=\S/E,\Q7+!48]=7Z$U%%%=Q\L%%%%`!1110!X0ZM&Q5U*L.H(P:;
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
M<\_'5;14%U_(J8KI/!6C?VQX@B$@S;VV)9.>N.@Z@]:YOVKV;P%I+:9X<1Y8
M]D]RWFMUSC^'(/0XKNH0YIZ]#YK-<5["@U'>6G^9U%%%%>B?&!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%(S*BEF8*H&2
M2<`"EKFO&VJ-I^B&*)BLMR=@89X'?D=#_P#7J9R48N3Z&^&HRKU8TH[R=C@O
M$6K-K&LSS@GR5.R(9Z*/Q/7VK(_AHZ<45X,YN<G)]3]:PM".'I1I1VBK"444
M5!N%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M7L/+^1#+-W4;5_WB"!],<G\*QZOZB^)%@[19#?[Y^]_(#\,]ZH=JZ8JRL>#4
MJ>TFY]'MZ&[X4T5M<UV&!E)@0^9,<<;1VZ$<^]>XJJHH55"J!@`#``KC?AQI
M!LM$:]E5?,NSN4[1D(.G/H?2NSKTZ$.6'J?$9KB?;UVEM'1?J%%%%;GF!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%><_$
M;_D)V?\`UQ/_`*%117/BOX4CV,@_Y&%/Y_D<71117B'Z>%%%%`PHHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`J:S_X_8/^NB_SHHJH
M[HRK_P`.7H8G:BBBND\+[)]#:=_R#+3_`*XI_P"@BK-%%>NMD?GD_B84444R
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`/
"_]DH
`



















#End