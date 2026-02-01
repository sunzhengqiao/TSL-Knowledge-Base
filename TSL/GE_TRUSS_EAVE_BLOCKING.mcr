#Version 8
#BeginDescription
v1.3: 03.nov.2013: David Rueda (dr@hsb-cad.com)
Creates EAVE BLOCKING along truss entities
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
* v1.2: 28.jul.2012: David Rueda (dr@hsb-cad.com)
	- Description added
* v1.1: 11.apr.2012: David Rueda (dr@hsb-cad.com)
	Bugfix: not all trusses were been taken in list. Improper use of '+' operator on bodies. Replaced by Body.combine()
	Thumbnail added
* v1.0: 23.mar.2012: David Rueda (dr@hsb-cad.com)
	Release
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

//Setting system units
int nSystemUnits=U(25,1); 
int nUnitsToPass;//On dll, it has values: 0=mm; 3=inch
if(nSystemUnits==25)
	nUnitsToPass=0;
else
	nUnitsToPass=3;
mapIn.setInt("SystemUnits",nUnitsToPass);

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
	
PropString sLumberItem(0, sLumberItemNames, T("|Lumber item|"),0);

PropInt nColor(0, 32, T("|Blocking color|"));
// Restrict color
if (nColor > 255 || nColor < -1) 
	nColor.set(-1);
PropDouble dMinimumBlockLength(0, U(75,3), T("|Minimum block length|"));

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey); 
	
if(_bOnInsert){
	
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	
	PrEntity ssB("\n"+ T("|Select beams and/or trusses|"), Beam());
	ssB.addAllowedClass(TrussEntity());
	if (ssB.go()) 
	{
		Entity ents[]=ssB.set();
		for(int e=0;e<ents.length();e++)
		{
			if(ents[e].bIsKindOf(Beam()))
			{				
				_Beam.append((Beam)ents[e]);
			}
			if(ents[e].bIsKindOf(TrussEntity()))
			{
				_Entity.append(ents[e]);
			}
		}
	}
	
	PrEntity ssE("\n"+ T("|Select wall|"), ElementWall());
	if( ssE.go())
		_Element.append(ssE.elementSet());
	
	if( (_Beam.length()==0 && _Entity.length()==0) || _Element.length()== 0)
	{
		eraseInstance();
		return;	
	}

	if (_kExecuteKey=="")
	showDialogOnce();

    	setCatalogFromPropValues(T("_LastInserted"));

	return;
}

if( (_Beam.length()==0 && _Entity.length()==0) || _Element.length()== 0)
{
	eraseInstance();
	return;	
}

ElementWall el = (ElementWall) _Element[0];

if (!el.bIsValid())
{
	eraseInstance();
	return;
}

// getting grade and material from selected lumber item
String sBmMaterial, sBmGrade, sBmLabel;
sBmLabel= "Blocking";
int nType= _kBlocking;
double dBmW, dBmH;

for( int m=1; m<mapOut.length(); m++)
{
	String sKey= m;
	String sName= mapOut.getString(sKey+"\NAME");
	if( sName== sLumberItem)
	{
		sBmMaterial= mapOut.getString(sKey+"\HSB_MATERIAL");
		sBmGrade= mapOut.getString(sKey+"\HSB_GRADE");
		dBmW= mapOut.getDouble(sKey+"\WIDTH");
		dBmH= mapOut.getDouble(sKey+"\HEIGHT");
	}
}

if( dBmW==0 || dBmH==0)
{
	reportError("\nData incomplete, check values on inventory for selected lumber item"+
		"\nMaterial: "+sBmMaterial+"\nGrade: "+ sBmGrade+"\nWidth: "+ dBmW+"\nHeight: "+ dBmH);
	eraseInstance();
	return;
}
	
//Element vectors in model space
CoordSys csEl=el.coordSys();
Point3d ptElOrg=csEl.ptOrg();
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();
PlaneProfile ppEl(el.plOutlineWall());
LineSeg ls=ppEl.extentInDir(vx);
double dElLength=abs(vx.dotProduct(ls.ptStart()-ls.ptEnd()));
Point3d ptElEnd= ptElOrg+vx*dElLength;
double dElHeight= ((Wall)el).baseHeight();
double dElWidth= el.dBeamWidth();

_Pt0= ptElOrg;


// Blocking will be created from ptStart (on truss/beam A) to ptEnd (on truss/beam B), then we need to know these points on every rafter/truss
// We will relay on element's vx, therefor ptStart will be left and ptStart will be right

Body bdAll[0];

// Get body from trusses
for(int e=0; e<_Entity.length();e++)
{
	TrussEntity teTruss;
	if(_Entity[e].bIsKindOf(TrussEntity()));
		teTruss= (TrussEntity)_Entity[e];

	if (!teTruss.bIsValid())
		continue;

	String strDefinition = teTruss.definition();
	TrussDefinition trussDefinition(strDefinition);
	CoordSys csTruss= teTruss.coordSys();
	
	// Getting all beams representations
	Beam bmAllInTruss[]=trussDefinition.beam();
	Body bdTruss;
	//Vector3d vTrussX;
	for (int b=0; b< bmAllInTruss.length(); b++)
	{
		Beam bm= bmAllInTruss[b];
		Vector3d vBdX=bm.vecX();
		vBdX.transformBy(csTruss);
		Body bdBm= bm.realBody(); 
		bdBm.transformBy( csTruss);														
		bdTruss.combine(bdBm);
	}
	bdAll.append(bdTruss);
}

// Get body from RAFTERS
for( int b=0; b<_Beam.length(); b++)
{
	Beam bm= _Beam[b];
	if( bm.type() == _kRafter || (bm.type() == _kBeam && bm.vecX().isParallelTo(_ZW)))
	{		
		bdAll.append( bm.envelopeBody());
	}
}
if( bdAll.length()<2)
{
	eraseInstance();
	return;
}

int nNrOfRows=bdAll.length();
int bAscending=TRUE;
  
for(int s1=1; s1<nNrOfRows; s1++)
{
	int s11 = s1;
	for(int s2=s1-1; s2>=0; s2--)
	{
		int bSort = vx.dotProduct(bdAll[s11].ptCen()-ptElOrg) > vx.dotProduct(bdAll[s2].ptCen()-ptElOrg);
		if( bAscending )
		{
			bSort = vx.dotProduct(bdAll[s11].ptCen()-ptElOrg) < vx.dotProduct(bdAll[s2].ptCen()-ptElOrg);
		}
		if( bSort )
		{
			bdAll.swap(s2, s11);
			s11=s2;
		}
	}
}

// We have now all bodies of rafters and/or trusses sorted along vx

// Check bodies that are ON wall (between ptElOrg and ptElEnd)
Body bdLeft, bdRight, bdBetween[0];
int bLeftFound=false;
bdLeft= bdAll[0];
for(int b=0; b<bdAll.length()-1; b++)
{
	Body bd= bdAll[b];


	Body bd1= bd;
	bd1.transformBy(vy*24);
	bd1.vis();
	
	Point3d ptCen= bd.ptCen();
	if( vx.dotProduct(ptCen-ptElOrg)>=0 && vx.dotProduct(ptElEnd-ptCen)>=0) // body is on element
	{
		bdBetween.append(bd);
		if( vx.dotProduct(ptCen-ptElOrg)>=dMinimumBlockLength) // checking if this can be left bd
		{
			bLeftFound=true;
		}	
		if( vx.dotProduct(ptElEnd-ptCen)>=dMinimumBlockLength) // checking if this can be left bd
		{
			bdRight= bdAll[b+1];
		}
	}
	if( !bLeftFound)
	{
		bdLeft= bd;
	}
}

Body bdOnElement[0];
bdOnElement.append(bdLeft);
bdOnElement.append(bdBetween);
bdOnElement.append(bdRight);
// we have now all bodies ON  wall (between ptElOrg and ptElEnd) sorted along vx

// CREATE BLOCKING

Vector3d vBmX= vx;
Vector3d vBmY= vz;
Vector3d vBmZ= vBmX.crossProduct( vBmY);

// Positioning
Point3d ptRef= bdLeft.ptCen(); 
Vector3d vFromTrussToWall= vz;
if( (ptElOrg- ptRef).dotProduct( vFromTrussToWall) <0)
	vFromTrussToWall=-vFromTrussToWall;

// Depth alignment
Point3d ptCen= ptElOrg;
if( vz.dotProduct( vFromTrussToWall) < 0)
	ptCen+=vz*(-dElWidth+dBmW*.5);
else
	ptCen+=vz*(-dBmW*.5);

// Vertical alignment
ptCen+=_ZW*(dElHeight+dBmH*.5);
vx.vis(_Pt0);
for( int b=0; b<bdOnElement.length()-1; b++)
{
	Body bdStart=bdOnElement[b];
	Body bd1= bdStart;
	bd1.transformBy(vy*22);	//bd1.vis(2);

	Point3d ptExtremsLeft[]= bdStart.extremeVertices(-vx);
	Body bdEnd=bdOnElement[b+1];//bdEnd.vis(2);
	Point3d ptExtremsRight[]= bdEnd.extremeVertices(vx);
	Point3d ptStart= ptCen;

	if( ptExtremsLeft.length()<=0 || ptExtremsRight.length()<=0 )
		continue;
	
	ptStart+= vx*vx.dotProduct(ptExtremsLeft[0]- ptStart);
	Point3d ptEnd= ptCen;
	ptEnd+= vx*vx.dotProduct(ptExtremsRight[0]-ptEnd);

	if(vx.dotProduct(ptEnd-ptStart)< dMinimumBlockLength)	// checking that blocking has minimal length
		continue;
	
	double dBmL= vx.dotProduct(ptEnd-ptStart);
	Beam bmBlocking;
	bmBlocking.dbCreate( ptStart, vBmX, vBmY, vBmZ, dBmL, dBmW, dBmH, 1, 0, 0);
	bmBlocking.setType(_kPanelEavePerimeter);
	bmBlocking.setColor(nColor);
	bmBlocking.setMaterial(sBmMaterial);
	bmBlocking.setGrade(sBmGrade);
	bmBlocking.setLabel( sBmLabel);
}

eraseInstance();
return;





#End
#BeginThumbnail
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
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@!\<LD,@DB=D<=&4X(_&NQT;Q#%>(D
M%TP2ZSM!Q@2?X'V_+TKBZ*PKX>%96EN;4:\J3NCU&BN6T;Q+_J[6_/L)R?RW
M?X_GW-=37AU:,Z4K2/9I58U5>(4445D:A1110`I.0/:DI5YR/6DH`****`"K
M2G<H/K56IH3P1Z5,EH.)+1114%A1110!YGK5@-.U:>W0$1YW1Y!'RGGC/7'3
M/M6?77^-;0;+:]`&03$QR<GN/;^]^=<A7TN%J^TI*3W/GL33]G5<4%%%%=!@
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%=KX
M7O#<::87;+P-M'7.T].?S'T`KBJV/#=Z+3551R=DX\OJ<;NQQW]/QKEQE/GI
M.VZU.C"U.2JO,[FBBBO!/<"BBB@"TIW*#ZTM10MD%?2I:R:LRT%%%%`PKS#5
M[06.K7-NH`57RH!)PIY`Y]B*]/KDO&MH-EM>@#()B8Y.3W'M_>_.N_+JO)5Y
M7U.+'T^:ES=CD****]X\0****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`^FJ***^./@0HHHH`*Q/%/\`R#(_^NP_
M]!:MNL3Q3_R#(_\`KL/_`$%JJ.YZ63_[]2]3D:***W/U`****`"BBB@`HHHH
M`****`"BBB@`HHHH`53M8'TJU52K$393Z<5,D5$?1114%!3)8DGA>&0;D=2K
M#.,@\&GT4)V`\GN(6MKF6!R"T3E"1TR#BHZZ3QE:"'4HKE0`)TP>3DLO&?R*
M_E7-U]10J>TIJ?<^;K4_9S<>P4445J9A1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!6YHNOR64@@NG9[8X`)Y,?T]O;\O?#HJ*E.-2/+(NG4E3ES1/
M3HY8YHQ)$ZNAZ,IR#^-/K@-)UF;2I&VCS(6^]&3CGU![&NWL[R&_MEG@;*'J
M#U4^A]Z\/$8:5%^7<]FAB(U5YEBBBBN8Z`I6'.>QYI*7JOTH`2BBB@`IT;;7
M'Y4VB@"W134.Y`:=61H%%%%`%74K07^FW%L0,R(0N20`W4'CWQ7EM>N5YUXE
MLOL6MS8;*S?OASR,DY_4'\,5ZN65;-TWZGF9C3NE->AD4445[!Y04444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4JLR.'1BK*<@
M@X(-)10!Z7:7"W=G#<+C$B!L`YP>XS[=*FKG?"=Z9+62T<C,1W)R,[3UX]CW
M]ZZ*OG*]/V=1Q/?HU/:04@HHHK(U'QG#CWXJQ52K*'<@-1)%1'4445)053U2
MR_M#3)[7=M+K\ISCY@<C/MD"KE%.,G%J2Z"E%233/(Z*UO$EH;37+@8.V4^:
MI)!SNZ_KD?A637U-.:G%274^:G!PDXOH%%%%62%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110![G_`,+"\+?]!3_R7E_^
M)K/D^*>@QRNBP7\BJQ`=8EPP]1E@<?4"O'**\Y9906]V>3')L.MVW\_^`>I7
M'Q;@6=A;:/))#QM>2<(QXYR`IQS[UG7?Q9U)Y0;/3K2&/;RLQ:0Y]<@KQTXQ
M7GU%:QP&'7V?S-XY9A8_8_%G87GQ,\1W.SRI;:TVYSY,(.[Z[]W3VQUJE)XY
MUZY:-;V[%Q"K;C&8D7/;JJ@]ZYRBM5A:*5N5?<=-+#T:4E*$4FNMCT;3]2M]
M3A,D#'Y3AD;AE^M6Z\TM;N>RF$UO(8WQC(YR/<=Z[C1]8BU2'!PEP@^=/ZCV
M_E_/R\3A'2]Z.Q[V'Q2J>[+<TZ***XCL"BBB@`HHHH`****`"BBE)R:`$HHH
MH`*DA.'QZU'0#@Y%)Z@BW12`Y`/K2UF:!1110!D>);+[;HDV&PT/[X<\'`.?
MT)_'%>=5ZY7ENI6AL-2N+8@XC<A<D$E>H/'MBO8RRK=.F_4\K,:=FIKT*M%%
M%>J>8%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!5JQU&YTZ4
MR6\FW.-RD9##W'^356BE**DK,:DXNZ/1--U*'4[;S8N''#QD\J?\/>KM>903
MRVTR30N4D0Y5AVKMM(UZ'4ML+CR[G;DKV;UV_P`\?SQ7C8G!NG[T-5^1ZV'Q
M:J>[+?\`,UZ5<9P>AXI**X3M"BI9XVC=<J1N17'OD9S45`!1110!+">J_C4U
M55;:P-6JB2U*B%%%%24%<WXRM#-IL5RH),#X/(P%;C/YA?SKI*ANK:.\M9;>
M89212IZ<>XSW'6M:%3V=13[&5:G[2FX]SRFBGRQ/!,\,@VNC%6&<X(X-,KZA
M.Y\X%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`&EH5X++5HG=ML;_`+MSQT/KGH,X/X5W]>75Z-I=T;W3+><DEF3#$@#+
M#@GCW!KRLQIZJ:]#TL!4T</F6Z***\P](*EA;JOXU%3D.UP:35T"W+-%%%9F
M@4444`<UXQL1+81WBI\\+;6(P/D/KW/./S-<17JM[:K>V4UL^,2(5R5S@]CC
MV/->6RQ/!,\,@VNC%6&<X(X->WEM7FIN#Z'C9A3Y9J:ZC****](X`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"E5F1PZ,593D$'!!I**`.ST;Q%'=^7;77R7)X#]%<]OH3^7YX
MK>KRZNGT;Q(V]+:_8;<;5F/7/^U_C^?K7E8K!6]^G]QZ>&QE_=J?>=51117F
M'HA1110`4444`%%%*#@T`)1110`4444`3PME<>E257B.''OQ5BLY+4M;!111
M2&%<=XSL0DD%\B8W_NY",=1ROOG&?R%=C6?K5@=1TF>W0`R8W1Y`/S#GC/3/
M3/O71A:OLJJET,,33]I2<>IYG1117TI\\%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4JLR.'1BK*<@@X(-)10!V&B^(OM<@MKS:LQP
M$<<!SZ'T/Z?UZ&O+JZ+0_$(M4%K>L?)`^23!)7V/J/3T^G3R\5@OMT_N/2PV
M,^S4^\]"U"-9-.LKE,'""-CSV'^(-9E=!8Q+>^'41'!$BDJP/!^8D<^E<_7E
MGHA1110,*L1G*#VXJO4D)PQ'K4R6@UN3T445!84444`<#XLL#:ZL;A0!'<C<
M,`###`;^AS[U@UW_`(LL_M.C-*JY>!@XPN3MZ$>PYR?]VN`KZ'`U?:45?=:'
M@XRGR57;KJ%%%%=ARA1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!73^$+H[[BT)."/-48&!V/_`++^5<Q5O2[H66IV\Y("J^&)
M!.%/!/'L36.(I^TI.)M0GR5%(]&HHHKYT]X****`+$9R@]N*?4,+8)7UJ:LV
MM2UL%%%%(85P'BRS^S:RTJKA)U#C"X&[H1[GC)_WJ[^L+Q99_:=&:55R\#!Q
MA<G;T(]ASD_[M=>!J^SK+L]#EQE/GI/RU.`HHHKZ(\$****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`-O0]<;3W%O<$M:L?J8SZCV]1_D]E!/%<PI-"X>-QE6'>O,JT
M-+UBXTMR(\/$Q!:-NGU'H:X,5@U4]^&YVX;%N'NSV/0:*KV=Y#?VRSP-E#U!
MZJ?0^]6*\=IIV9ZR::N@HHHI#"BBB@!3T!I*4>E)0`4444`%6E.Y0:JU-"W!
M7\:F2T'$EHHHJ"PHHHH`\TUVS^PZS<1!<(6WIA=HVGG`]AT_"LZNT\9V>^U@
MO%7F-MCD+_">A)]`1_X]7%U])A*OM*2EU/GL33]G5:"BBBNDP"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"N^T"Z%UH\!R-T0
M\I@`>,=/TQ7`UT'A.Z$5_);L0!,F1P<EEYQ^1/Y5QXVGSTF^VIU8.IR5;=SL
M:***\,]H*53M8'TI**`+8.1D44R(Y3'I3ZR9H@HHHH`1T61&1U#*PP5(R"/2
MO*[VU:RO9K9\YC<KDKC([''N.:]5KB/&-B8K^.\5/DF7:Q&3\X]>PXQ^1KT<
MMJ\M1P?4X,PI\U-270YJBBBO</&"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@#OM`NA=:/`<C=$/*8`'C'3],5IUQ_A2\
M,=Z]HS?)*NY0<_>'IZ<9_(5V%?/XJG[.JU\SW,-4YZ284445SG0*IVL#Z5:J
MI5B(Y3'I4R141]%%%04%,EB2>%X9!N1U*L,XR#P:?10G8#RFZMI+.ZEMYAAX
MV*GKS[C/8]:AKI/&5H(=2BN5``G3!Y.2R\9_(K^5<W7U%"I[2FI]SYRM3]G4
M<>P4445J9!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110!9LK^XL)A+;R%>067/RM[$
M=^M=SINKVVIQ_NFVS!<O$>J_XC_ZW2O/:D@GEMIDFA<I(ARK#M7+B,+&LK[,
MZ:&)E2=NAZ;16/H^O1:D?)D417`'"YX?CDC_``_GS6Q7B5*<J<N62U/8A.,U
MS184445!84'K12]J`$HHHH`*<AVN#3:*`+=%-0[D!IU9&@4444`5=2M!?Z;<
M6Q`S(A"Y)`#=0>/?%>7.C1NR.I5E."I&"#Z5ZW7G?B>T%IKDI4`+,!*`"3UZ
MY_$$UZF65;2=-^IYN8T[I3^1CT445[)Y(4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`5+;7$EI<QSQ'#QMN'O['VJ*BDTFK,:=
MG='IT4B31)+&<HZAE..H/2GUC>&;O[1I(C9LO`Q0Y;)QU'T';\*V:^;JPY)N
M/8^@ISYX*7<****@L?$</CUJQ50'!R*M`@@$5$D5$6BBBI*"LGQ):"[T.X&!
MNB'FJ22,;>OZ9'XUK455.;A)270F<%.+B^IY'15W5[06.K7-NH`57RH!)PIY
M`Y]B*I5]3&2E%274^:E%Q;B^@44450@HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@":TN&M+R&X7.8W#8!QD=QGWZ5Z4K*Z!T8,
MK#((.017E]=QX9N_M&DB-FR\#%#ELG'4?0=OPKSLQIWBIKH>A@*EI.#ZFS11
M17D'J!4D38;'K4=`.#D4GJ"+=%(#D`^M+69H%%%%`&3XDM!=Z'<#`W1#S5))
M&-O7],C\:\YKURO+M4LO[/U.>UW;@C?*<Y^4C(S[X(KV,LJZ.F_4\K,:>JFO
M0J4445ZIY@4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`"JS(X=&*LIR"#@@U
MU>A^(5D06U_(%=1\DSG`8>C'U]^_UZ\G16-:C&K&TC6E6E2E>)ZC17'Z+XB^
MR1BVO-S0C`1QR4'H?4?K_3KU970.C!E89!!R"*\.M0E1E:1[-&M&JKH6BBBL
M38****`"BBB@"6%N2OY5-553M8&K51):E1"BBBI*"N>\86@FTE;@`;K=P<DG
M[K<$#\=OY5T-1W$*W-M+`Y(65"A(ZX(Q6E&I[.HI]C.K#VD''N>3T4^6)X)G
MAD&UT8JPSG!'!IE?4IW/FPHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`V?#-W]GU81LV$G4H<M@9ZCZGM^-=Q7F,4CPRI
M+&<.C!E..A'2O2+2X6[LX;A<8D0-@'.#W&?;I7D9C3M)374]3`5+Q<.Q-111
M7G'H!4\)RI'I4%/C.''OQ2:NAK<L4445F6%%%%`'(>-;0[[:]`."#$QR,#N/
M?^]^5<E7I^KVAOM)N;=02S)E0"!EAR!S[@5YA7O9=5YZ7*^AXF/I\M7F[A11
M17><04444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`5M^&+TVVI^02!'<#:<D###D?U&/>L2GQ2/#*DL9PZ,&4XZ$=*SJP52#B^I=
M.;A-270].HJ*VN([NVCGB.4D7</;V/O4M?.--.S/H$[JZ"BBBD,GA.5(]*DJ
MO$<./?BK%9R6I:V"BBBD,*Y#QK:'?;7H!P08F.1@=Q[_`-[\JZ^J.L6(U#2I
MX-FY]NZ/IG>.G)Z>GT)K?"U?955(PQ-/VE)Q/,:***^F/G@HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`K6TG7)]-=(W)DM<G,?<9[C_#IU^M9-%1.
M$9QY9+0J$Y0?-%GIL$\5S"DT+AXW&58=ZDKSO3=2FTRY\V+E#P\9/##_`!]Z
M[G3]2M]3A,D#'Y3AD;AE^M>)B,+*B[K5'L4,3&JK/1E\PD6RS<D%RAXZ8`/7
M\?TJ.M6V@$^@W'3*2%QD],`9_3-95<IU!1110`58B.4'MQ5>I(6PV/6E):#6
MY/1116984444`<)XPM##JRW`!VW"`Y)'WEX('X;?SKGJ]"\46(O-&DD"9E@_
M>*1CI_%U[8Y_`5Y[7T.!J\]%+JM#PL;3Y*K??4****[#D"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"NP\*7@DLGM&;YXFW*#
MC[I]/7G/YBN/K3T"Z-KK$!R=LI\I@`.<]/UQ7/BJ?M*37S-\-4Y*J9WU%%%?
M/GNA1110!:5MR@TM10GJOXU+635F6@HHHH&%>;^(;$6&LS1HFV)\21CCH>N,
M=!G(_"O2*YCQE8&6SBO4`S"=K\#)4].?8]O]JNW+ZO)6L]GH<>.I\]*ZW1Q5
M%%%?0'AA1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110!V/A.Z,MA);L23"^1P,!6YQ^8/YUT%<%X>N_LFKQ9&5F_='CD9(Q
M^N/PS7>UX6-I\E5OOJ>S@ZG-22[!1117(=85:4[E!JK4T+<%?RJ9+0<26BBB
MH+"BBB@#S;7[`Z?K$T8`$;GS(\``;2>F.V#D?A697:>,[/?:P7BKS&VQR%_A
M/0D^@(_\>KBZ^DPE7VE%2>Y\_BJ?LZK2V"BBBNDYPHHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`JQ9WDUA<K/`V''4'HP]#[57HI-)JS&FT[H]$T7X
M@Z?9V`CO+:Y\\MN;R54KT`XRP/:K%O>0:A#]JMD=()&;8K]0`2.>3Z5YG74>
M$;O_`%]D1_TU4@?0'/Z?K7F8K"0A3<X'HX;%3E-1F=31117EGI!2@X(/I244
M`6P<C(HJ.)LKCTJ2LGH:(****`$=%D1D=0RL,%2,@CTKRV_LWL+^:UD.3&V,
M^HZ@_B,&O4ZXOQG9[+J"\5>)%V.0O\0Z$GU(/_CM>AEM7EJ<CZG!F%/FI\_8
MY>BBBO=/&"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@#T?3;O[=IT-SC!=?F&.XX./;(-6JYCPA=#9<6A(R#YJC!R>Q_]
ME_.NGKYW$4_9U'$]ZA4]I34@HHHK$V'(VU@?SJS52K,;;D'Y5$D5$=1114E!
M4%[:K>V4UL^,2(5R5S@]CCV/-3T4TVG=":35F>2.C1NR.I5E."I&"#Z4E;?B
MFP%GK#2(#Y=P/,Z'&[/S#/?GG\:Q*^HI5%4@IKJ?-U(.$W%]`HHHK0@****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*](T^Z%[8
M07`(RZ`M@$`-T(Y]\UYO75>$+H;+BT)&0?-48.3V/_LOYUPX^GS4^;L=N"J<
MM3E[G3T445XIZX4Y&VN#VIM%`%NBFH=R`TZLC0****`*U_9I?V$UK(<"1<9]
M#U!_`X->6NC1NR.I5E."I&"#Z5ZW7GOBBQ-GK,D@3$4_[Q2,]?XNO?//XBO4
MRRK:3IOKJ>;F-.\5-=#%HHHKV3R0HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`*MZ7="RU.WG)`57PQ()PIX)X]B:J44I14DXOJ.+<6FCU&BL
MS0+H76CP'(W1#RF`!XQT_3%:=?-3@X2<7T/H(24HJ2ZA1114ECXFP_UXJQ52
MK2G<H/K42141:***DH*S-?L!J&CS1@$R(/,CP"3N`Z8[Y&1^-:=%5";A)270
MF<5.+B^IY'15[6+$Z?JL\&S:F[='UQL/3D]?3Z@U1KZF,E**DNI\W*+BW%]`
MHHHJB0HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@"WI=T++4[><D!5?#$@G"G@GCV)KT:O+J]!T2]%]I4+DDN@\M\DD[AWS[\'\
M:\S,:>TUZ'HX"IO#YFA1117E'IA4L)Y(]:BI5.U@:35T"+5%%%9F@4444`<_
MXNL3=:4)T3<]NVX]<[#UX_(_0&N#KUF6))X7AD&Y'4JPSC(/!KRJXA:VN98'
M(+1.4)'3(.*]K+*MX.#Z'D9A3M-374CHHHKTSS@HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`J]I%Z+#4X9V)$>=KX)^Z>.?7'
M7'M5&BIE%2BXOJ5&3BU)=#U&BJ&BW?VS28)"V7"['RVXY''/N>OXU?KYN<7&
M3B^A]!&2E%274****DHEA;DK^-3554[6!JU426I40HHHJ2@KGO&%H)M)6X`&
MZW<'))^ZW!`_';^5=#3)8DGA>&0;D=2K#.,@\&M*-3V=13[&=6G[2#CW/)J*
MDN(6MKF6!R"T3E"1TR#BHZ^H3NKH^;:MH%%%%,`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`Z+PG>B.ZDM')Q*-R<G&X=>/<=_:NOKS2TN&M
M+R&X7.8W#8!QD=QGWZ5Z4K*Z!T8,K#((.017C9A3Y:BFNIZV!J<T.5]!:***
MX#N"IH6R"OI4-.C;:X]*35T"W+-%%%9F@4444`<EXUM!LMKT`9!,3')R>X]O
M[WYUR%>H:I9?VAID]KNVEU^4YQ\P.1GVR!7E]>[EU7FI<O8\7'T^6IS=PHHH
MKT#A"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"NC\)7>RYFM&;B1=ZY;N.N!ZD'_QVN<J:TN&M+R&X7.8W#8!QD=QGWZ5E7I^
MTIN)K1J>SFI'I=%(K*Z!T8,K#((.012U\X>\%%%%`RQ$V4]Q3Z@A.'QZU/6<
MEJ6M@HHHI#"N'\96@AU**Y4`"=,'DY++QG\BOY5W%8_B>T-WH<I4$M"1*`"!
MTZY_`DUU8.I[.LGWT.;%T^>DUVU/.Z***^C/`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@#H_"5WLN9K1FXD7>N6[CK@
M>I!_\=KKJ\VLKI[&]BN4&3&V<>H[C\1FO2%970.C!E89!!R"*\;,*?+4Y^YZ
MV!J<T.7L+1117`=P58B.4'MQ5>I(6PV/6E):#6Y/1116984444`<)XPM##JR
MW`!VW"`Y)'WEX('X;?SKGJ]$\3VAN]#E*@EH2)0`0.G7/X$FO.Z^AP%7GHI=
MM#PL;3Y*K??4****[#D"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`KN/#-W]HTD1LV7@8H<MDXZCZ#M^%</6WX8O3;:GY!($=P-IR0,,.1_4
M8]ZY<93YZ3MTU.G"5.2JO/0[:BBBO!/;"BBB@"RAW(#3JAA/5?QJ:LVK,M;!
M1112&%><^)+0VFN7`P=LI\U22#G=U_7(_"O1JYOQE:&;38KE028'P>1@*W&?
MS"_G7;@*O)62[Z''C:?/2;[:G#T445]`>&%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`'<^&[TW>E*CD;X#Y?49V]CCMZ
M?A6Q7%^%;HPZFT!)VSH1@`?>'()_#/YUVE>!BZ?)5=NNI[>%J<])>6@4445S
M'2*#@@^E60<@'UJK4\)RF/2IDAQ)****@L****`/+=2M#8:E<6Q!Q&Y"Y()*
M]0>/;%5:ZOQG8A)(+Y$QO_=R$8ZCE??.,_D*Y2OIL/5]K24CYVO3]G4<0HHH
MK<Q"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MN[\.71NM'B#$EHB8B2`.G3'X$5PE;OA6Z,.IM`2=LZ$8`'WAR"?PS^=<F-I\
M])OMJ=6$J<E5>>AVE%%%>$>T%*#@@^E)10!;!R,BBHX3E,>E25D]#1!1110`
MCHLB,CJ&5A@J1D$>E>7:E:&PU*XMB#B-R%R025Z@\>V*]2KB_&=GLNH+Q5XD
M78Y"_P`0Z$GU(/\`X[7H9;5Y:O(^IP9A3YJ?-V.7HHHKW3Q@HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`*?%(\,J2QG#HP93CH1TIE%`'IL$
MRW%O',@(61`X!ZX(S4E<_P"$[HRV$ENQ),+Y'`P%;G'Y@_G705\W6I^SFX]C
MZ"E/VD%(****S-!R':X-6:J58C.4'MQ42141]%%%24%0W5M'>6LMO,,I(I4]
M./<9[CK4U%";3NA-)JS/)I8G@F>&0;71BK#.<$<&F5N^++/[-K+2JN$G4.,+
M@;NA'N>,G_>K"KZFE4]I!3[GS=6')-Q[!1116A`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`^*1X94EC.'1@RG'0CI7I4$RW%
MO',@(61`X!ZX(S7F5=GX4N_.TY[8C!@;@XZALG\\Y_2O/S"G>"FNAW8&I:;A
MW-ZBBBO'/6"GQ'#CWXIE%#`MT4BG<H-+61H%%%%`&=KMG]NT:XB"Y<+O3"[C
MN'.![GI^->:5ZY7FFNV?V'6;B(+A"V],+M&T\X'L.GX5ZV65=Z;]3R\QI[5%
MZ&=1117KGEA1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!4D$S6]Q',@!:-PX!Z9!S4=%#5]`3MJ>FP3+<6\<R`A9$#@'K@C-25
MA>%;H3:8T!(W0.1@`_=/()_'/Y5NU\W5A[.;CV/H*4^>"D%%%%9F@^)L/[&K
M%5*M*=R@^M1)%1%HHHJ2@K.UVS^W:-<1!<N%WIA=QW#G`]ST_&M&BJA)PDI+
MH3.*E%Q?4\CHK0UJP&G:M/;H"(\[H\@CY3SQGKCIGVK/KZF$E.*DMF?-RBXR
M<7T"BBBJ)"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@#4\/7?
MV35XLC*S?NCQR,D8_7'X9KO:\NKTC3[H7MA!<`C+H"V`0`W0CGWS7E9C3LU-
M>AZ>`J73@6:***\P]$*DA;#8]:CI5.U@?2DU<$6J***S-`HHHH`PO%EG]IT9
MI57+P,'&%R=O0CV'.3_NUP%>LRQ)/"\,@W(ZE6&<9!X->6WMJUE>S6SYS&Y7
M)7&1V./<<U[.65;Q=-]#R,QIVDIKJ04445ZAYP4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`5K>'+H6NL1!B`LH,1)!/7IC\0*
MR:569'#HQ5E.00<$&HJ04XN+ZEPER24ET/4**K:?="]L(+@$9=`6P"`&Z$<^
M^:LU\W).+LSZ!--704444ADT)X(]*EJLAVN#5FLY+4N.P4444AA7*^,[`/!#
M?H#N0^6^`3\IR03Z8/'_``*NJJKJ5H+_`$VXMB!F1"%R2`&Z@\>^*VP]7V55
M2,:]/VE-Q/+:*5T:-V1U*LIP5(P0?2DKZ<^="BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@#6\.70M=8B#$!908B2">O3'
MX@5W=>7JS(X=&*LIR"#@@UZ19727UE%<H,"1<X]#W'X'->3F-.TE-'IX"I=.
M!8HHHKS3T0J:$\$>E0TZ-MKC\J35T"W+-%%%9F@4444`<IXSL2\<%\B9V?NY
M",]#ROMC.?S%<=7J6I6@O]-N+8@9D0A<D@!NH/'OBO+:]W+JO-2Y7T/%Q]/E
MJ<RZA1117H'"%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!75
M^$KPM'-9NV=G[R,<]._MC./S-<I5[2+T6&IPSL2(\[7P3]T\<^N.N/:L,33]
MI2<>IMAZGLZB9Z'1117SQ[P4444`6(CE,>E/J")L/CL:GK.2U+6P4444AA7$
M>,;$Q7\=XJ?),NUB,GYQZ]AQC\C7;UD^)+07>AW`P-T0\U221C;U_3(_&NG!
MU?9UD^^ASXJG[2DU\SSFBBBOI#Y\****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`.L\)7H:&6R8G<A\Q,DGY3P0/3!_G72U
MY[HMW]CU:"0MA"VQ\MM&#QS[#K^%>A5XF.I\E6ZZGL8*IS4[/H%%%%<1V!5E
M&W(#WJM4L)ZK^-3):#CN34445!84444`>=^)[06FN2E0`LP$H`)/7KG\036/
M7<^,++S],2Z#8-NW()ZJQ`_/./UKAJ^CP=7VE%/MH>!BZ?)5:[ZA11174<P4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`5UWA*
M[WVTUHS<QMO7+=CUP/0$?^/5R-7]%N_L>K02%L(6V/EMHP>.?8=?PK#$T_:4
MFC?#U.2HF>A4445\\>Z%%%%`%E#N0&G5#">J_C4U9M69:V"BBBD,*\Z\2V7V
M+6YL-E9OWPYY&2<_J#^&*]%KF_&5H9M-BN5!)@?!Y&`K<9_,+^==N`J\E9+H
M]#DQM/GI-]M3AZ***^@/""BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`]#T>X:ZTBVE?.XIM))R20<9S[XS5ZBBOFZR2J22[L^@I-NG%
MOL@HHHK,T`'!R*MT45$BHA1114E!1110!Y5>PK;7]Q`A)6*5D!/7`)%0445]
M7!WBFSYF:M)H****HD****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`*]#T>X:ZTBVE?.XIM))R20<9S[XS117GYBE[-/S.[`-^T:
M\B]1117CGK!3D.'7ZT44,$6:***R-`HHHH`CN(5N;:6!R0LJ%"1UP1BO)Z**
M]?*WI->GZGEYDOA?K^@4445ZQY84444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`>DV,CS:?;2R'+O$K,<=20,U8HHKYF?Q,
M^BA\*"BBBI*'(<./K5FBBHD5$****DH*CN(5N;:6!R0LJ%"1UP1BBBA.SN@:
MOH>3T445]:?+A1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
K!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110!__V5%`
`




#End
