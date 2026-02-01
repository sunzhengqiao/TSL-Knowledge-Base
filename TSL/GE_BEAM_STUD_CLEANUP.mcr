#Version 8
#BeginDescription
v1.1: 15-may-2011: David Rueda (dr@hsb-cad.com)
Erase studs interfering other beams, depending on their types (priorities set by user)
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
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
* v1.1: 15-may-2011: David Rueda (dr@hsb-cad.com)
	- Thumbnail added
* v1.0: 11-Jul-2011: David Rueda (dr@hsb-cad.com)
	- Release
*/

String arBmTypes[0];
arBmTypes.append(_BeamTypes);

PropString sPr1(0, arBmTypes, T("|Priority 1|"),30);
int nType1=arBmTypes.find(sPr1,56);
PropString sPr2(1, arBmTypes, T("|Priority 2|"),56);
int nType2=arBmTypes.find(sPr2,56);
PropString sPr3(2, arBmTypes, T("|Priority 3|"),58);
int nType3=arBmTypes.find(sPr3,56);
PropString sPr4(3, arBmTypes, T("|Priority 4|"),59);
int nType4=arBmTypes.find(sPr4,56);

if(_bOnInsert){
	
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	
	if (_kExecuteKey=="")
	{
		showDialogOnce();
	}
	
	PrEntity ssE("\n"+T("|Select beams|"),Beam());
	if( ssE.go())
	{
		_Beam.append(ssE.beamSet());
	}
	return;
}

if(_Beam.length()<2)
{
	eraseInstance();
	return
}

int nPriorities[0];
nPriorities.append(nType1);
nPriorities.append(nType2);
nPriorities.append(nType3);
nPriorities.append(nType4);

Beam bmAllVerticals[]= _ZW.filterBeamsParallel(_Beam);
for(int b=0;b<bmAllVerticals.length();b++)
{
	Beam bm=bmAllVerticals[b];
	_Pt0= bm.ptCen();
	Body bdBm= bm.envelopeBody();
	for( int t=b+1; t<bmAllVerticals.length(); t++)
	{
		Beam bmTmp=bmAllVerticals[t];
		Body bdTmp= bmTmp.envelopeBody();
		if( bdBm.hasIntersection( bdTmp))
		{
			// Define priorities for both beams
			int nPrBm= 100;
			int nPrTmp= 100;
			for( int p= 0; p<nPriorities.length(); p++)
			{
				int nType= nPriorities[p];
				int tmp=bm.type();
				tmp=bmTmp.type();
				if( bm.type() == nType)
				{
					nPrBm= p;	
				}
				if( bmTmp.type() == nType)
				{
					nPrTmp= p;	
				}
			}
			
			if( nPrBm != nPrTmp) // Priorities are diferent, just erase the lesser one
			{
				if( nPrBm < nPrTmp) // Erase bmTmp
				{
					bmTmp.dbErase();
					t--;
				}
				else // Erase bm
				{
					bm.dbErase();
					if( b>1)
						b--;
				}
			}
			else // Both have same type/priority
			{
				// Get element of both beams, define which is load bearing and which is not
				Element elBm= bm.element();
				ElementWallSF elWBm= (ElementWallSF) elBm;
				int nLoadBearingBm= elWBm.loadBearing();
				Element elTmp= bmTmp.element();
				ElementWallSF elWTmp= (ElementWallSF) elTmp;
				int nLoadBearingTmp= elWTmp.loadBearing();
				if( nLoadBearingBm == nLoadBearingTmp) // Both are in same type, we don't know what to do, must just color them
				{
					bm.setColor(1);
					bmTmp.setColor(1);
				}
				else if( nLoadBearingBm == 1 && nLoadBearingTmp == 0 ) // Must erase bmTmp
				{
					bmTmp.dbErase();
					t--;
				}
				else if( nLoadBearingBm == 0 && nLoadBearingTmp == 1 ) // // Must erase bm
				{
					bm.dbErase();
					if( b>1)
						b--;
				}
			}
		}
	}
}

eraseInstance();
return








#End
#BeginThumbnail
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
M+Z$H#U;;'+NQZXWKGTW#U%6:S_%;`:)I,9(#^?<2;3UVD1`-CT)5AGU4^AKL
MP$;XB)E6^`Y.BBBOHSD"M6]>U\$6*:EKMH)=4E!.GZ/.""Q!QYTZ]5B!!PO!
M<C'"@FHM6U:'X?6ZNZ1S>*Y4#V]NZAETU2,B64'@RD<JA^[PS=A7DT\\UU<2
MW%Q+)-/*Y>221BS.Q.223R23SFN#$8G[,/O);+&JZK?:YJEQJ>IW,ES>7#[Y
M97ZL?Y``8``X```P!5.BBN`04444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!4D$\UK<17%O+)#/$X>.2-BK(P.001R"#SFHZ*`/>?"OCV
MP\?7-EIVM7*Z?XC>,PB<Q*+>]<8V9((*2-DC&"#@;<$A*UKJUGLKF2VN8VCF
MC.&5NW^?6OG"O8O!GQ)L-:EL](\8R/!<[3#'K8D&&/`C%PI'..09,@XV[N[C
M&I2OJMS>E6Y=);'3UD>,?OZ/_P!>!_\`1\U=!J%A/IE_+9W`42Q'!VG(/&01
M]00:P/$5A=:GXQ2RLH&GN9K>U5(UZD_9X_R'<D\`<UMEJ_?-OHC6L_=1SD44
MD\R0PQM)+(P5$099B>``!U-2^(O$4?@>&;2M*F63Q-(ICO+V)LKIP/#11,.L
MW9G'W.57G)%3Q+XSC\/0OH?A._)N20+_`%JV<JTI!SY4##E8@1RXP7(_N@9\
MUKLQ&)Y_=CL<C9)//-=7$MQ<2R33RN7DDD8LSL3DDD\DD\YJ.BBN,04444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M'IO@+XG"P>#1?%@^V:(8EMXKGRP9[$`DJ58#<R#/*G.`!MX&UH?'_P`1EU*_
MU#3_``K)/9Z1<3RRW-P&*2Z@SEL[^A$0#$+'Z$EADX'G%%"TV'=[!1110(**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
4H`****`"BBB@`HHHH`****`/_]DH
`



#End
