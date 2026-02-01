#Version 8
#BeginDescription
v1.2: 29-ago-2012: David Rueda (dr@hsb-cad.com)
Changes type on selected beam(s) to selected type (from list)
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
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
* v1.2: 29-ago-2012: David Rueda (dr@hsb-cad.com)
	- Strings added to translation
* v1.1: 15-may-2012: David Rueda (dr@hsb-cad.com)
	- Thumbnail added
* v1.0: 10-mar-2011: David Rueda (dr@hsb-cad.com)
	- Release
*/

String arBmTypes[0];
arBmTypes.append(_BeamTypes);
int nNrOfRows=arBmTypes.length();
int bAscending=TRUE;
  
for(int s1=1; s1<nNrOfRows; s1++)
{
	int s11 = s1;
	for(int s2=s1-1; s2>=0; s2--)
	{
		int bSort = arBmTypes[s11] > arBmTypes[s2];
		if( bAscending )
		{
			bSort = arBmTypes[s11] < arBmTypes[s2];
		}
		if( bSort )
		{
			arBmTypes.swap(s2, s11);
			s11=s2;
		}
	}
}

PropString sNewType(0, arBmTypes, T("|New Beam Type|"),63);
int nNew=_BeamTypes.find(sNewType,-1);

String sKeyType="TYPE";// Key in map

if (_bOnMapIO)
{
	//Define property
	PropString sNewTypeOnMap(0, arBmTypes, T("|New Beam Type|"),63);
	sKeyType="TYPE";// Key in map
	
	//Find value in _Map, if found, change the property values
	if(_Map.hasString(sKeyType))
	{
		int nIndx=_Map.getString(sKeyType).atoi();
		String sSelected=_BeamTypes[nIndx];
		sNewTypeOnMap.set(sSelected);
	}

	showDialog("---"); // use "---" such that the set values are used, and not the last dialog values
	int nSelection=_BeamTypes.find(sNewTypeOnMap,0);
	_Map.setString(sKeyType, nSelection);
	return;
}

if(_bOnInsert){
	
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	
	if (_kExecuteKey=="")
	{
		showDialogOnce();
	}
	
	PrEntity ssE("\n"+T("|Select beam (s)|"),Beam());
	if( ssE.go())
	{
		_Beam.append(ssE.beamSet());
	}
	return;
}

if(_Map.hasString(sKeyType))
{
	nNew=_Map.getString(sKeyType).atoi();
}

if(_Beam.length()<=0)
{
	eraseInstance();
	return
}

for(int b=0;b<_Beam.length();b++)
{
	Beam bm=_Beam[b];
	if(!bm.bIsValid())
	{
		continue;
	}
	
	bm.setType(nNew);
}

eraseInstance();
return
#End
#BeginThumbnail
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
M%O+)#/$X>.2-BK(P.001R"#SFK&I:MJ6LW"W&J:A=WTZH$62ZF:5@N2<`L2<
M9)./<UI2J>S;:6K*4G:QWUYXE\-:9@">?6I&_ALBUM&H]3)+'N+#'W1'C!!W
MY!%<_>?$'7),#3&BT1.K#3"\;L?>5F:3!X^7=M^4';GFN5HHG5G/=BN%%%%9
MB"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHJUIFFW>L:G;:=81>==W
M,@CBCW!=S'H,D@#\30E?1`W;5E6BO0/^%)?$/_H7O_)VW_\`CE'_``I+XA_]
M"]_Y.V__`,<H`\_HKLU^$_C9[N]M4T4/<62J]Q$EW`70,"5.`^3D`XQGICK7
M&$$$@C!':BX6"BMCPYX6UKQ;?O8Z'8M=W"1F1U#J@5<XR68@#KZU:TCP+XCU
M[6KW2-+L%N;ZRS]HC2YB`3!VGYBVT\\<$T>07.=HKT#_`(4E\0_^A>_\G;?_
M`..5@>(_`WB;PD(VUS2)[6.3&V7*R1DG.%WH2N[@\9SWQ1<+'/45T7AGP)XD
M\817$N@Z;]K2W95E/GQQ[2<X^^PST/2M[_A27Q#_`.A>_P#)VW_^.46L%[GG
M]%==KOPP\8^&M)EU35]'^S6414/)]IA?!8X'"N3U/I7(T7`***UM)\,ZQKEC
MJ%[IMDT]MIT7G74N]5$:X)_B(R<`\#)XH`R:***`"BBB@`HHHH`***[+2/A3
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
MQID_[._AS3(M1M)-0AO=TEJDZF5!F;DIG('([=Q7DM%%#UDY=P6D4NQ>T61(
MM=T^21U1$N8V9F.``&&237?_`!VU33]7^($=SIE_:WL`L8T,MM,LB[@SY&5)
M&>17F5%#U278%HV^Y9T]E34[5W8*JS(22<`#(KTGX\ZMIVL>.K6XTS4+6^@6
MP1#);3+*H;>_&5)&>1^=>6T4/5)=@6C;[A72_#ZZM[+XA:#<W4\4%O%>QM)+
M*X54`/4D\`5S5%.+Y6F*2YDT>_>-/`O@_P`7^++W7?\`A9VAVGVHH?)WPR;=
MJA?O><,],]*P?^%0>#_^BLZ'^4/_`,?KQ^BI225D4VV[LOZW86^EZY>V%K?1
M7]O;RM''=18VS`'AA@D8/U-6_".F6&L>*].L-4OH;&PEE_TB>:01JJ`$D;CP
M"0,#W(K%HIQTM?44M;V/ICQMI/AKQ78V>DV'Q+T#1M"M(PJ:?`\3*Q'=CYPS
M[#''7K7FGB#X9>&='T"\U"S^)&D:E<01[H[2$1[Y3GH,3$_H:\RHI-;VZC3V
M"BBBF(****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
*BBB@`HHHH`__V2B@
`



#End
