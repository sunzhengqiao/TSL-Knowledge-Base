#Version 8
#BeginDescription
Tsl changes sheeting in room.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------
*  Copyright (C) 2007 by
*  hsbSOFT N.V.
*
*  The program may be used and/or copied only with the written
*  permission from hsbSOFT N.V., or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*
*
* REVISION HISTORY
* ----------------
*
* Modified by: Anno Sportel (as@hsb-cad.com)
* date: 19.10.2007
* version 1.0: First revision
*
*/

if( _bOnInsert ){
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	_Pt0 = getPoint(T("|Select a position in the room|"));
	PrEntity ssE(T("|Select walls to apply sheeting|"), ElementWallSF());
	
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	return;
}

if( _Element.length() == 0 ){
	eraseInstance();
	return;
}
_Pt0 += _ZW * _ZW.dotProduct(_Element[0].ptOrg() - _Pt0);
Body bdArea(_Pt0, _XW, _YW, _ZW, U(10000), U(10000), U(3000), 0, 0, 1);

Sheet arShToChange[0];

for( int e=0;e<_Element.length();e++ ){
	Element el = _Element[e];
	
	CoordSys csEl = el.coordSys();
	Vector3d vx = csEl.vecX();
	Vector3d vy = csEl.vecY();
	Vector3d vz = csEl.vecZ();
	
	LineSeg lnSeg = el.segmentMinMax();
	Point3d ptStartEl = lnSeg.ptStart();
	Point3d ptEndEl = lnSeg.ptEnd();
	double dWallLength = abs(vx.dotProduct(ptEndEl - ptStartEl));
	
//	bdArea.vis(e);
	
	Vector3d vPt0(el.ptOrg() - _Pt0);
	if( vPt0.dotProduct(vz) > 0 ){
		//back
		Body bdEl(el.ptOrg() - vz * el.zone(0).dH() + vx * (vx.dotProduct(ptStartEl - el.ptOrg()) - U(100)), vx, vy, vz, dWallLength + U(200), U(6000), U(7000), 1, 0, 1);
//		bdEl.vis(e);
		bdArea.subPart(bdEl);
		
		arShToChange.append(el.sheet(-2));
	}
	else{
		//front
		Body bdEl(el.ptOrg() + vx * (vx.dotProduct(ptStartEl - el.ptOrg()) - U(100)), vx, vy, vz, dWallLength + U(200), U(6000), U(7000), 1, 0, -1);
//		bdEl.vis(e);
		bdArea.subPart(bdEl);
				
		arShToChange.append(el.sheet(2));
	}
}

for( int i=0;i<arShToChange.length();i++ ){
	Sheet sh = arShToChange[i];
	
	if( sh.realBody().hasIntersection(bdArea) ){
		sh.setColor(3);
		sh.setMaterial("Green Gypsum");
	}
}

if( _bOnDebug ){
	Display dpDB(-1);
	for( int e=0;e<_Element.length();e++ ){
		Element el = _Element[e];
		GenBeam arGBm[] = el.genBeam();
	
		for( int i=0;i<arGBm.length();i++ ){
			GenBeam gBm = arGBm[i];
			dpDB.color(gBm.color());
			dpDB.draw(gBm.realBody());
		}
	}
}

eraseInstance();
#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0```0`!``#__@`N26YT96PH4BD@2E!%1R!,:6)R87)Y
M+"!V97)S:6]N(%LQ+C4Q+C$R+C0T70#_VP!#`%`W/$8\,E!&049:55!?>,B"
M>&YN>/6ON9'(________________________________________________
M____VP!#`55:6GAI>.N"@NO_____________________________________
M____________________________________Q`&B```!!0$!`0$!`0``````
M`````0(#!`4&!P@)"@L0``(!`P,"!`,%!00$```!?0$"`P`$$042(3%!!A-1
M80<B<10R@9&A""-"L<$54M'P)#-B<H()"A87&!D:)28G*"DJ-#4V-S@Y.D-$
M149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@X2%AH>(B8J2DY25EI>8
MF9JBHZ2EIJ>HJ:JRL[2UMK>XN;K"P\3%QL?(R<K2T]35UM?8V=KAXN/DY>;G
MZ.GJ\?+S]/7V]_CY^@$``P$!`0$!`0$!`0````````$"`P0%!@<("0H+$0`"
M`0($!`,$!P4$!``!`G<``0(#$00%(3$&$D%1!V%Q$R(R@0@40I&AL<$)(S-2
M\!5B<M$*%B0TX27Q%Q@9&B8G*"DJ-38W.#DZ0T1%1D=(24I35%565UA96F-D
M969G:&EJ<W1U=G=X>7J"@X2%AH>(B8J2DY25EI>8F9JBHZ2EIJ>HJ:JRL[2U
MMK>XN;K"P\3%QL?(R<K2T]35UM?8V=KBX^3EYN?HZ>KR\_3U]O?X^?K_P``1
M"`&3`6@#`1$``A$!`Q$!_]H`#`,!``(1`Q$`/P"E0`4`%`!0`4`%`!0`4`%`
M!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4
M`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!
M0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`
M%`!0`4`%`%AHU/8?AQ2N7RI_U?\`X*&-#Z'\Z+D\KZ#&1EZBF(;0`4`%`!0`
M4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`
M!0`4`%`!0`4`%`!0`4`%`!0`4`%`%C/)J#J2TU%#47$X)_U^O_#CJHQU_KY?
M/J-**W;^E`FE_7]7&-#Z'\Z8K=B,HR]10(;0`4`%`!0`4`%`!0`4`%`!0`4`
M%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0
M`4`%`%C!J+'5S(!UI#;LKCCT_P`_Y[U1FEK;^OZT$7O]*2'/HO,<3BJ9C%7_
M`*\P.*"E?^M?^"-**>H'\J+BY?ZW_#<8T([''UHN3RM[$;1LO4<>HIB&T`%`
M!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4
M`%`!0`4`%`!0`4`%`!0!.)5/48_6E8KF_I:#P0>0<_K0._3_`('_```([4BD
MWN_ZW^77R!1C-"'-IV^8N.WM39"?7S_S&DY'UJ6:P_K[W_D(#BD6TGN.4U29
MG./]?-?YB^M,SL]/Z[",BGJ!02E<C:'^Z?SHN%B-HV7J./:F(;0`4`%`!0`4
M`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!
M0`4`%`!0`4`/$K#W^M`TVMB:-MZYQCF@+]QQZTF5';^NS&GI4LVCO_7=B4BQ
M5JD93_K\?\D*.E-$R>OWO\?^`(QY'TJ67!*S7F*#Q33(DE?^O+_,,C-%P47;
M^OU$*JW49IDM?U_PXPP_W3^=!-B,QL.W'J*8MAM`!0`4`%`!0`4`%`!0`4`%
M`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`3P?<_
M&@:'MUI,N.W]>0C=:EFL-ON_)"4BQ5Z52,I[_P!>8X=*:(D[/[_U$8<\4F73
M>FO<.V*!/OZ_K_D-J34*`'9Q^M68I7_#\0W4KC<'T_KY/_,0HK=@:9#5M_Z_
MKR&-!Z'\Z9-AAC8=L_2@&FMQE`@H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`+$(_=@^^:!ICSR:EEK1?UW_P"`
M--)FL59?UZ"4BQ1T_P`^]5_7YF3W_K^Z.'0TS-ZM7\AC2`.5.:+"4K#@P;I@
MT!\_Z_KR$Q2L:J3_`*U_%?J`'(I6*<M`/3\*;)CO?S_1B5)J.3O31SUNB_K<
M<6`XZGVIZF5F'OBG8=VM!&0-U`H'=$9@'8X/O1<+7U1&T3CMGZ4[A:PR@04`
M%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`%F
M+[B_C0/I_7F.SS4]2[:?UYC#29M';[_S"D4.'2J,F]?Z\O\`)B]<'WIHSDM;
M>17E.9#BF0,H`>)&'?/UH#8>LWJ,?2E8KF[D@.1QT_*@+K<,>V:5BN=]`(]3
M^%,BXW?V4?2@FX\&@8M#$^X[%9-LQ<FA,4^9%JH_Z_K]!I13]X9J_0U4N8C,
M(]Q^M.X63V9&8F';/TI@U890(*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`"@"U&`$7'I0/H%2:):?<OP_X(T]:3-8[!2*'#_/Z57]?
MD8O_`#_]N%[`4^A#^)_,K/\`?;ZTR!`"3@<T`/$1XW$#V[T`2J@7H/Q-(!W&
M['4T`,WY(`HN3<,]3VQ_.@!B_>'UI`B9?NCZ510O>DT#V:'#I6+W.>6XM(D;
MU-:+1?UZFRTC_7J+BIN9\S$(I\Q:J6_K^OU&E`>O/UK0VYD]T1F$'H<4!IT(
MVB<=L_2G<5AI!!P>*`$H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@
M`H`*`+2?='T%(KI]_P"@>M(T73Y?I_F-/4TF:1V04BAW^?\`/Y51CO\`UW_X
M<7N/I3,WJV0HH=BQX&>*9)+MVXQP/04@%SZ4`-W?O!0+J(,[G/I0`P=1BD2.
M_A;Z"F,:OWA2`FP1C'2J*!F"@D]J0[:`LB-T.#2L_P"OZL0T_P"OZL/!/:I<
M5_7]6(Y?ZV_X`@/--K3^NQ5K+^NUAV<]ZSM8Q=^HAZ4+<%N`ZU3V+>W]=?\`
MAA*M;FB>OI84K@?_`%ZA2ON)2>_^0W;NXX_&K;L7?4C:`?2FG<-'L1F%ATP:
M=QV8P@CJ,4"$H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`+@H&QHZ?E
M4FKT=_7\/^&0VI-4K*P4#''_`#^M5_7YF*_R_P#;1>],S6W]>0U%Y`[+_.D^
MP("<R`>E,AZL5>@SW/\`2@!HYD'TH%U`?QT#&+UI"'GHWUQ3&-'7\#2$3510
MR;[A_"@?3[_T*U`ARNR]#0!(L_\`>'Y4K"L2+(K=Z5F'*K:?U_7H/I67]?U8
MA))Z_P!?H`]Z)()KL`ZBF]G_`%T*>S_KH*36<4907,_D`Q1(<M_Z_KH*<=N*
M5V+F_K<:16D7<TA)B%0?I[T[E\ZV?_!_K[R-HE]/RIW&N5[/[R,PG^$@_I3N
M#30PJ5ZC%`A*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@"YZTBM[?UU&BD:/7\
M?QO_`)#:DV`=:!-V5QW6J,MOZ[7_`,D*<\D=:9EY`2$3CFEY@WH1I]\4(A#U
MZ#Z_TIC$3[_X4($-'^K8TN@N@U>OX&@!S?=/^]3`1/O4D")L511%/]S\:!O9
M?UU9!0(*`"@`H`<KLO0T`2I.20&'6E9"LB=1E@*F3T8;@U1'^OO,H.ST_K4?
M&FX9-*;L_P"N[+Y.;?\`K4;U/^-(QW8,"&Q5K:_J:\K2^\`/2IEN9N[8$8ZC
M%%PU0W%:)_U]W^9LF_Z_K^K"%?U[4)_U_6HU4ONK^G]?YC&B'=<?2FG<I<KV
M?WD9A_NG\#3N-Q:&,K+U&*9(V@`H`*`"@`H`*`"@`H`*`"@!R??7ZT`6?X32
MZ%KXE\A#W^M(I;KT7YC:DW`=131,MF.';_/I3_K\C-_Y_P#MP[K0WK8R7<CD
M.1CWILEC4[_2DA(>>GY_SIC!/OL:`0T']T?K2Z"Z"(?F^M`(#P@]Z`Z"IU_S
MZT($2U11%.?E_&@;Z$%`@H`*`"@`H`<GWU^M`%Q#AP:SE\/]=R4[*_J!I1,X
M;DD9PI.*SEN7%V0P=:9BMQ3PQXQR*M;?)G2A8\^@-1+<RC?F>G463MUI(=08
M,\\8XZBM7_7X_P"1I+84>@`/UK,YUV$88]133NRNMG^(W%:<VG]>1?,TK_UT
M`#';\Z+_`-?\`:J7W_X/]?>1M&#U4?4529:<7L_Z_KR&FW/53^=%T(B9&7J*
M8#:`"@`H`*`"@`H`*`'1C+KCUH`L]J1:W_KHA#Q2+6OX?I_P1M2;`.M-$RV^
M[\QQX'\JHP;_`*^2%^Z`*2[DOL1G[B_C00"#.?<8H0(?U'U!_6F,:.=Q!I`(
M?]4/K3Z"Z"*.<^E)`#?<7\:`%C^]30(EQBF40S_P_C0ARW^[\B&@04`%`!0`
M4`/B&9!0!;7EC63TBOZ\S.UH_P!=088HB_Z^\45;^O4</N<=ZA[B>P8^GYT$
MV_JZ$S[^O\JT2_3\S=6L*,`\Y_"LS!63U_`63DY!!XI(JIJ[C!C'O_\`JK5_
MY_J7I9_,7H>:S,;6W`\TT-;B"JE_7XE2V_KS%J"!#5P>I<'J(.O%4WIJ4Y6L
M(5_"A-%JK??7\_Z^\:\:G^'GUS35RE9D?D$G"'\#3NEN#74C9&7J,4Q#:`"@
M`H`*`'P_ZP4`6/X12Z%_:?S_`%&_PTNAI]K[OR8E2:@.M-$RV'CEOI3?8YUW
M&%LL3Z=*9%QK=%'M2$*G]10@0X=OH*8QJ\(Q_"@2V!O]6HI!T$7H?\]C0`-T
M`H!CH^M-`B0'(IE$$Y^Z/QH0Y;D5`@H`*`"@`H`?#_K10#T+8/)K.7PHSD_<
M^X#UI1V^_P#047[K7J.)RJCT%0]V*H[Z"`XS00G8;6J_R_S-5_E_F.K(Q$/2
MFMRH[H.]5T_KR*>W]>0M00)30T`JI?U^)4OZ_'_,6H($/45<=F7#9@O2B>X5
M-Q:@@0UI'^OP+B_Z^X,4N:P^:S&[?3BJ4BU5OO9_U_748T2GM^7%47H_Z_K]
M2-H2.A_.BX^5]-2*F2%`$D(_>9]*`W)SP!2+6K;_`*UT_4:>E+H:+67S_*_^
M:$J34<H_7BJ7<QJ/H(?D4^IH\S*3Z#%Z'_/8T$`_\/TH8,5.`?\`/2F@0\\9
M]A_*@8P?ZH_6CH+H#_=7Z4,&(O0T@!^WTH8,=%W]Z:&B2F,KS?>'TH0Y;LCH
M$%`!0`4`%`$L`_>?04GL*6S+(J)Z6,YZ6`TH["CM_76R%J7N0W=BH,M@BI94
M%=V$[9]OZUJ]/Z\C5I6'HH(Y%8MDPBFM4-<`'`JHDN-I)(,#GV/^?YU3V^2_
MK\"Y127]>0J+N-0W8SA'F8UN"15Q_K[QI6E_7=!@8]Z'_7W())<J`#)J2$KB
M'K5QV+CLP'2B>X5-Q1UZ9J"$)WJUM_7F6MOZ\Q1TJ7N2]V%(D;CFM$_Z_KT9
MN[I+^OZZBD>M)-]"(M]"C6IL%`$D/WC]*&..Z)VZ4F5#?[OS0UNE)FD=_O\`
MT$')J31NRN/7VJ[75CEN[W&2'.*&0QH^X?>D`/\`>QZ4,&*OW/S_`)4P'-W_
M`,]J!C<XCQ@\]Z0N@/QCZ4,&(.A^E``_WJ&#'1_=)%-#0_G!IE)7=B"8_/CT
M&*`;N[D=`@H`*`"@`H`EM_\`6?A4RV)GL7(0#G(K.KT*LF-?[YJH[?=^9'_`
M_,E0*5'%8L<$FAKX##@`4+8F=E)#,<#Z?_7K9O\`K\"Y;#X\`^]9,SIV3&OR
M<D$9JHB;?-?^MA!S@#)_R*J7]?B5/560?6H,O40@XJHE174!1+^OR_0)=OZ[
M?H+4DC3UK2.WS-(_#\_\A1TJ9;DS^(6I($-6OZ_KYFJ6G]?UU%%2S/=@Q4=#
M0HMEN%]AF3VK4UY;B$\<\TQZ(J4P"@"6`<D_A0..Y,U)E07YK_/]!K4F:4_Z
M_KY`M)=Q5'T0K<+CN>,TUL8R[#)#D@^U#)8@^X?\^E`!)]\T,&.7[M-#%/0_
MY]J&,0_ZL?6ET$))][Z"AB8`?*/?_/\`2@!'Y;/K0#0^/@8IH:'GH:;*CNBM
M-_K#0(90`4`%`!0`4`36_5J3%+;[OS+*,0.*SFM2)R:>@T\FFM%_7J'V?Z]1
MX=@,`UG8A3:$))Y[TTN@D[O40$U<MOO_`#-)-V^_\Q02#D5F9)M;`S$XS32L
M5S-[@K$=*J:_K^O4J4G';^OZN%09@S$XS517]?)EJ3:_KLQ%..:)?U]XI.S_
M`*[L6I)&GK6L=C6*T_K^N@HZ5$MS.6XM(0TFM$OZ^[_(V47_`%\O\AI)/L*:
M20U%(0D#FF4(QI,8A^Z/>CH(KU0!0!-!_%^%#''?[_R)&I,NGO\`UV8-R:3+
M@[*_E^K%6AJ^AE?J-9L[?K3(&/U`]!28F*!E0/4_XT`(WWC]:`8Y?NK_`)[T
MQ@WW3^/\Z`8-]U!ZT"&R??-)@Q1T7ZC^M,!&^]]*0$B?<'K30T*>E!4=_P"N
MQ6D.7;/K3$-H`*`"@`H`*`)[;^*IET]29=/4L*OR%JSF];$SC?43O5=/Z["Z
M?UV)#&>QK+F!TGT&8)!]A5+=$P5V)C!_'%4WI_74N:LOZ]1XC)%9W)5-L8?:
MKC_7WA!7=A<8-#=_Z\D$TUO_`%L*%)&>U3<2BVKC35Q_K^OF./\`7Y?J+C%2
MQ2W"D2-/4UK'9?UW-H[+^NX%N!@4N7JPY+O43-4B[);"#M3`;DY:E<!,9P*`
M%*]SP*+`+D#@"F!5I@%`$\`^7/J:!KJ2=ZEE+;[_`-`[X]:-M0>NGI^7_#B.
M0JX'>A;$R8S^%?QID"2??-)@Q1_#^']:8#6^\?K2$2+T'U_I3*$;[GX_TH![
M`?X*`&N<L:0F.]/;_"@8UOO'ZT"9(GW<4T-#C394=_O_`"*K_?;ZT"&T`%`!
M0`4`%`%BW^X?K28GT_KH6?\`ED/K6,OB9-388.M6]OZ]"7_7X(G;[I^E8+<U
ME\+(<G:>:TCNC&GN*>I^IIO;Y+]2ZFWS'J<*3G)],UFPB[*]]2(UI'_(B#L_
MP%ZT2%/<,G&,FI)N]A#5Q_K\"X_U^`9]:5KARN6O];"%^/052BC14TM&-SFJ
ML7HM$*/>FV`T]..G_P!:@0O?Z4P$`X.>?6D`9HN`W=2N`F:0QK0D=#^=5<+$
M;*R]13$30?<_&@:Z_P!=20]:3+CHOD_T%'&3ZT-7(O8A<Y:DR&.Z[1[4QC6^
M\?K2$.'WE_SV%,9'2))5Z@>PIE#6^Z/H*!,7:!(`*.H^HUOO'ZTA#L9VCU_P
MIC&,<FD)DP&5`]J90I[4%+KZ?JBG3)"@`H`*`"@`H`LP<1GW-2]T2]U\R?HJ
MC\:R>K9G4&J,G`JY;??^94D]O7\T2,X*X&:R2%*::LAG'>J1,-&&<CW_`/UT
MY*W]>2+J/2PY2HZYS4-,F$HK<:Y!;CI5QV_KS&VF]/ZT8Y64*>.?>E)-O3^M
M64VNB&;A]:?**--]1I;)JTNQJDD`4GVI-I$RJ)"A0/>I<F8N;8<9Y]:TOI<W
MCK:XUCBC8;&]C]:!#NYJ@&`G::D!*0PH`!R10`OF8.&!4^C#_/\`*KL2I/U_
MK^NH[<,9Z#U[?GTJ>5E*2?\`P11@#C`%,=K[!CG'K0W8-[(&/./6@ELA)R<T
MB"0C#`>P_G3*(V^\?K2)'CAE]A3*(Z1)+TR?8TRAK]!]30Q,<?\`6CZ4=1]2
M.D2/_C_SZTRNHSO2%<F'3Z<510I'0^]*XUL_3]44Z8@H`*`"@`H`*`+4/^J%
M+J+K_7D2GI^%9?:^?ZF4OC^X%."??BG):?=^HV[+Y+]0J#(0U4?T*CU]`%.9
M4_Z_`"0*E*XHP<MAI-6E8UC"PG)Z<T_4MN,1WEG&3Q4\RZ&<INV@8`/`IWNO
MZ\R;MK^O,</>H>Y#M<0].*(J['&-V)T%4]78ZU[J(S]XU?4S%_Q_K3`4]&H`
M9_!^-+H`E(84``ZBA"(@S*,`\>G:K$TF*'&<XVGU4X_S^&*8K?T_Z_S)$<D\
M,".^1@_7_)-`(D4]3T'^?\_G4;LTV0W.6_SZTR"*D22]9#3ZE=2*D22=V^A_
MG3*&=:1))@8./3C\:90C??7ZYH`7_EJ2>PHZAU(Z1(_^(^PS^N:90RD23XJB
MQ'/R,.V#2ZCZ?UYE2F(*`"@`H`*`"@"U$,1**74FWO?(D[5DMS%:R^8Z/.[B
MB6WW&JOT\A9/O&H1%360TO@8]*TC'J7!2ZC"Q-5;L:<JW8;&],?6E="E)1%V
M\TU(E2NKBBLV8O<<6)ZTK`Y-[C<UHO\`+]#1.WX?H+69B(26//:K7NHZJ:;6
MHQSSBJBK(J3NQH^_FGU)`=!0@''HU,!G\-+H`E(84`*OWA0A%>K`*`)X4XY[
M_P`O_KTF[#2'N1PH[TEH*3N-[D^W_P!>@0S&3@4@L2=&)/K_`$J@(P,X]Z0K
M#\_>/M_.F,8OWA]:0B0=!]!3&(1\RX]*0!_$_P!*8AJ_>'UI`.]?I_2F,8!D
M@4A$^>W>J*&R'"M]*74K[/S_`*_,JTR0H`*`"@`H`*`+:?ZM?I2ZBZ_UYE@@
M;1P.U<Z>OW_D"BK="-.H[>M7/^ON1#W[?TA')+'FJBDD:I=1H7U-/02E?8DV
MA0"/SJ&[F=1VM8<`#]YL_C6?H"2?Q/\`$8>3@<#-:K;Y!OHMK?J.^4(,=:AW
MNQ2Y5MN(!QDD4$)=6-]JT_K\O\C1?U^'^3`\5,5<B,;L3H*MJ[.I.R(LY84^
MI`H^\?:@!1U'^?6F`-]PT/8!I^Z*70!*0PH`5/O"FMQ%>J`<B[FQV[T`65X'
MIG]!4[LJ]D1YW2`^]!'44=_I_2@!J]1]:!(=_>_&F,:OWA]:0AW\+?04#&+]
MX>W-`B0#:ISV_P#UTQB?\M11U#J&<;Z!#5^\/SI`._O>W_ZJ!C5^\*!(FJBA
MDP_=$Y_"EU'T*U,04`%`!0`4`%`%Q1A5'I4]_P"NA'=_UL.-9(RB[.X"JD5/
M?^O3]!M/K8Z(JT1QZ41W^?\`F81U?S_S%^E0_P#(B6_]=@[=:0N@E6MOZZFB
M3M\OSN%2]S-ZL4@CK2!JVXE:/^OQ-'_7XB'DTUHC2G&R&D_XTT4R,=:0AW=J
M8"CJ/:F`-]SZT/8!I[4F,2D`4`*O4GVIH17J@)X4P,]SS^%)NPTA\A^4B@ED
M2]:0AQZ-]:8"1_?%)`AQZ-^/]*8#%ZT@''[K?7%,!HZ\4A$C=_K_`$IE`!^]
M/M1U#J-'*,?6@0U>OX&D`X]&^I_I3`1!EA20(F&>]441RG"-[G%(I[+^OZV*
M],D*`"@`H`*`"@"Z!R!4MZ,C>X]TVC.:R@[O^NZ#DY=?ZW!%W<?K1-V_KS)Y
M>9_UW9'6GVCH^R/QDXY&:F+LK_UL8P6@Y6&,!>M1):D\R6B7D)P#T_6@C1,1
MFSCC&,UHE^AN_A3%4@=LFLV8Q:70&.3FA+H)OF8W.!C'^?\`(K5*[_KS_P`S
M9.XAX6DM97-7HB/.<FJ(&KUI(!1T)I@/'WO\^U/J`UON"D]@$;M0P$I#"@!5
M[_2FA$,:[FQVZFJ`LXV@DU*=W<IZ(C;H3_M4S-B+R:0(4\@_C_2F`B`EN*2!
M"C_5FF'0:O7\#2`<WW3_`+U,!$^]20(DZ8^O_P!:F,8"%<Y^E`NH?\L_QI=`
MZ")UH0(7!*_7_/\`2F`H7:030,D!X_QIC$8!LJ?RI-V&K,B:$=CBE<+##&P[
M9^E.]PL,IB"@`H`51E@#ZT`75SN&.M1+X7_74BVFG?\`4DF/`%94UK_7]="Y
M=!JE@#MINS:N9Q<KZ?UU(ZOK<VD[1)#N)&3W%2K6^_\`0RBY-:@,KC;W'I4O
M5LEWB]!WEX&2<4KA[.RNV1@;B!6NW]=E_P``I*_RT^X4\$BLS%Z,5EPO/>G%
MZE\MK7&#DU;T5C>G$:QRV.U.*L.3NQ@Z$TR07K0@`?=/O0@'CJ33`:W``I/8
M!&ZT,!*0PH`<G0_A30A(DPHSWYIMV&D.8Y<#\30M-!-W9'_RS_&D3T%3K_GU
MH0(/X/\`/O0,(^I^E"!`?N#_`#ZT"Z`GWJ$'40\(/>@`0_-0"'^G^>],8@^\
M_KS0(`I*`>]`[:"@!3_0<T`*S`#DA:8R/<<95<#^\U%B;I`91MVL`_OC'^?\
M]:8K-N^PT,/X7(QV89`_S]*`MY?=I_7WCP[`9*\>H.1_G\:5D-2?1_)_U^@X
M.K="/\_Y[9I<I7/WT_K^NP\=QGZ@U+0-)Z_U_7H-:-&[8/M0KD\K3_K^OS(I
M(L<K^76FF-7ZC$^^OUJAEP<-4/X3-NT08D]34P_K\10;>_\`6C%R<$9I=5\A
M)NZ7H-'6J[_,Z)_"*22>M"V_KJS&+;7]=QV<=":SW,W)WN@)..30#;&Y.1SV
MK3H_5_D:7=GZO\A:S,A&)(ZU4%J7&\GJ)]U:K=G3LB)3DYJD0`^[_GVHZ``X
MS]*2`4=`?>FAB]F_SZTQ`_5:&`P]>:EC"@`H`<@X--"'=`6-'4;=D1IU)_&@
MA`?N+^-`")U)H!`?N#_/K0`J?=;Z4($#'Y`*`8B=30@0-]Q?QH`6,<T($2`'
MCV%4,08'W1GWI`-9UZ9R?1:8#68]_D'H.O\`G\J+"OV&;@.@R?5N?_K?SICL
MWN-)).2<GWI#V$H`*`%!(.0<'VH#<7?G[P!]^A_S]<TQ6[#U?'W7*^QY'^?P
MH):[K[OZ_4=YC`99<CU!S_GZ<4FD-.VS^3_K_,>)$;N/QXI<O],KF[K[A=H)
M&1S[BEJAW35T.!P3FDU=:&;UC9"\9&:E+3[R8I+4#RN0*%\0+68T=:%LV;5'
M:(XBG';[OS,HK3[OS)%91T!K%IA&45M<9ZYJUN9JS>HA()X&!5=/O-:FG]>B
M'*5'4$UF[F<7%;C"<FMEHK&T%9#).E-[%#5Z&A"#^&CH`+T-"`5>@^N:$`H^
M[3`&^\*3W`8>II,`H&%`#EZ?C30A&_U8I]!2&IT/TQ2$@;[JB@!5Z'_/8T`#
M=!_GL*`$&=C4!T%;H/\`/I0#!5/(IH+#BHR,GM0.P9">WN:`&^9G.T;O<]*=
M@;2&,<_?8M[#I^?_`-8TPNV-+G&!A1[?YS2"PV@84`%`!0`4`%`!0`4`*"0<
M@X/M0&XN_/W@#[]#_GZYIBMV'*X'W69?8\C_`#^%`FGU_P`G_7S)!(P'*AAZ
MK_G_``HL%_Z?]?YCEF1CSQ^G_P!:IMV&29^7AC]*FUG_`%_PX(13@YI)73+G
ML+]X]>/>G:R_KL0]=OZT'$8XS]:R,6K:??V!EP,Y!^E.+U&HV:?F-'6JZ?UW
M&W=:^?Y@3V[T1745.-V(W`IQUNSIEI8B;H*ID`.AI`!^[_GWI]``?=:CH`X<
M;:$,!T_*F(1_O?A2>X#3U-)@`!/2@8H7\?I3L(>!QZ4T`R3[JTN@I"#[C?A0
M+H#_`,/TH8,1>%/^?\]:`%;L.]`#E7Y"#Q3'T%/7@9^E`#6<#.6_!:`$R[=,
M(#W)I["<DAC#'.TM_M'I_G\31=!>XTEFP/R`H'9(0@@X(P:!B4`%`!0`4`%`
M!0`4`%`!0`4`%`!0`H.#D4`+O)^\`WU_QZT[BY>Q)"5W';D<=#_G^E)[#5[Z
MDK,4&X`G'I415T.;U$69#WP??C_ZU58B[7]7_P""2*<<@X_K4N/?^OU^X%?O
M^H%BW6DHKH)^]_7Z"ANN32E'3[OU!WM8:.230]%8UIQL,<YJDK(3=V-;H/QI
ML0#[IHZ`!Z"@`'W:708[],"FM@8O^-,0F#OS1U`0+^-*P`??B@`SQQZXHOH,
M=W%,!DO1:70F0T<(?<XH%T%923]!BF`[:%7YC0.P,0!GC\:`&%\G`!<T[!ZC
M6)/WVX_NK_G_`#Z4"O?8;OQ]T8]^I_S],4QV[B9.<YYI!8EBE"GYA@>W]:B4
M;D2C?84S(N?+'Z4N5O<7(WN0LQ;J:M*QHDD)3&%`!0`4`%`!0`4`%`!0`4`%
M`!0`4`%`$L`^8GVI/8:W'SG"`CUI0V'(AWD_>`;Z_P"/6KN1R]A05[%E/US_
M`(?UH%J2*[]L/_N]?\_A2M<+KK^(]'#]`:3T&D/8X6LUJ[FLM%8C!^4$^M69
MB-V^E)@`^[1T&#<<4P#^#\:.@A?_`(FC_(!WI]:8"9^8T=0$[``=:3>@T(W4
M4,`[#/\`GK2Z`/QV-4(:ZDD46$]10`%^GI0`UI`.^/8<FF`S<3RHP/[Q_P`_
MI18+I#25[DN?T_Q_E3#5_P!?U^HA<D8Z#T'2D%D-H&%`!0`4`%`!0`4`%`!0
M`4`%`!0`4`%`!0`4`%`!0`4`%`$UO_%^%3+8<=PN.WO1'8);D-4(*`%`R<"@
M"VO``)S[FIEJ.-D,D/-*UM`;N(/NCZYIB!NWTI,`/W?\^]/H`-UI,8'[HI]!
M#OZ8I@*.WTH`;W:D`A^ZM)[#!_O&F]Q`?NBET&/_`(JH1&TJD@*-QSQ3`:Q8
M_?8*/3O_`)^M%B;]AFX#[J_B>?\`ZW\Z8[-[B%BQR23]:0));"4#"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`)X!\I-3+8J.XEQ_#3CL
M)[D-,04`2PKDEC]!0!.3M%0M=2GIH1MUH9(O8?C3`1_O&A[@!Z`4`#=:&`N"
M0N*3V&A>Y_"J$+CI]*`&>II`!_A%`",<G-)C'>@I@.'4TQ%8N<8`"CVIBMW&
MT#"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`+$
M'W#]:F6Q4=QD_P!\?3--;">Y%3$*`2<#K0!:C7`]A43?0J*ZB,<L/K3$,/6D
M(=CH/:F`C?>-)@+W7_/I3&-/;Z4F`[^Z,TP%/0_7^E,0O<TP&#[O^?:IZ`+_
M`!+]*!C3U-)@._B7Z4Q#N],"I3`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`+,(Q&/>HD5$BG.7'TJD)D=,1-`F<M^`I-V&
ME<F8[5Q4+N4]%88?O#VJB!IZFDP'=Q]!3`:>II,!W0BF,:>M)@./5?PIB%&>
MV<YS0`O<FF`S^&ET`#U_`T=1B'J:3$._C`]*?4!XJ@*=`!0`4`%`!0`4`%`!
M0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0!9B_U8J)EQ(9O]8:L
M@:`6(`[T`6T`51CH*B6NA<=-2-SDT>1(IZ_@:8AIZFDP'_QT^H#*0QQZ_@?Z
MTQ#3U-)@/_CI]1@IZ'IUH_K\1"GHU,!G4#\/ZTAB]6]J!!MYR:+#'CU/'O5$
MW$9U7C'/I0*SW*E!04`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4
M`%`!0`4`%`!0`4`6HQA%^E1+>Q<=B"0Y<GZ59`^%<#<>IX%)@3$X%(;(_P"/
M\:740H^]^`I@-I#'_P`?XU740P=14C%[\^E/J`E(!^?WE/J`#L*8A<9!]Z``
M+T[T6"]A>`,D@4Q7&&09^09QU.?Z]*!/S&-)ZL3_`+O'ZG_"@->FA&7.,#"C
MV_SF@=AM`PH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`MI]Q?I4/<M;%<KNE('<U9!84?D.!4-ZV*2ZB$Y:F2,'44D`X?>_*
MF`T=120#_7\:8#!U%)`.!YQ]*?4=QJ]120AX7DDU5@'`<=.E,5Q&95ZF@-1K
M2'OA?K_AU_&F)-=-?Z_K0B+C_>]S_A_^ND.S>XPL6ZG-`))"4#"@`H`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`+;<*?I4
M=2^@Q!AF;N3@53=B"0_*`*F/<J6F@P?>/M3)&CK2`=W/U_QI@-7[PI(!P/!]
M\FF`B@YH2`>%Y/O3L`N,=3BG85^PW>`<*"30)^9&TGJ?P7G]>GY9H"[Z?U_7
MR&;S_#Q[]_SICMW&4AA0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`
M!0`4`%`!0`4`%`!0`4`%`!0`4`%`%RH^T7]D`H&#CITHEJ[`M-61DY8FF2+W
M/U_QH$(O6D@`<Y-,!5&#DT(!P''%-(+@=JCDBF+4:9...!ZG_.33$[$3..^6
M_0?XG\Z0]6-+,PP3QZ=J`22&T#"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@!R??7ZT`6JE(;8CG@TEL-C
M%ZT(D4`D&F@`#'6BP#PO'I56%<:64'`RS>G>@/48TA[G;[#D_P#UJ8O0C+^@
MY]2<F@=NXTDDY)R?>D/82@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@!T8)<8^M`%H=:0QI!-`@4
M>G-"0#C@=3TIBN,\P8^0?CT_7UH$[=?Z^1&T@/4Y^G`_Q_E0/5^7]?UW&%R1
MCH/0?Y_G0%AM`PH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@"6`@,<]>U`$X'I20/08TB#`
M^\?04Q:^G]?UW&M(_<A!Z=3_`)^N*8E;IKY_U^A&7'89/J?\.G\Z0[-[_P!?
MU\AI8L<DD_6@$DMA*!A0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`
M!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`.1@IY4'ZT":N.
M+@]2_P!"?Z__`%J8K-::?UY?\$:7.,`!1[4AV[C:!A0`4`%`!0`4`%`!0`4`
M%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0
M`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%
M`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`
M4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`
M!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4
M`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!
M0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`
1%`!0`4`%`!0`4`%`!0``_]D4
`


#End