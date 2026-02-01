#Version 8
#BeginDescription
version value="1.0" date="DATE" author="thorsten.huck@hsbcad.com"
initial

Removes the connection of any beamcut to a selected genbeam if its cutting body does not intersect the envelope of the genbeam.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
/// <History>
/// <version value="1.0" date="DATE" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select genbeams and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl removes the connection of any beamcut to a selected genbeam if its cutting body does not intersect the envelope of the genbeam.
/// </summary>


// constants
	U(1,"mm");	
	double dEps =U(.1);
	int bDebug;//=true;
		
// bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		
	// prompt for genbeams
		PrEntity ssE(T("|Select beam(s), sheet(s) or panel(s)"), GenBeam());
	  	if (ssE.go())
			_Entity.append(ssE.set());


		if(bDebug)_Pt0=getPoint();
		return;
	}	
// end on insert	__________________	
	


// loop entities
	reportMessage("\n" + scriptName() + ": " +T("|purging beamcuts of|") + " " + _Entity.length() + " " + T("|item(s)|"));
	int nNumTotalTools, nNumTotalRemoved;
	for(int i=0;i<_Entity.length();i++)
	{
		GenBeam gb = (GenBeam)_Entity[i];
		if (!gb.bIsValid())continue;
		Body bd = gb.envelopeBody();
		
		Entity ents[] = gb.eToolsConnected();
		int nNumTools, nNumRemoved;
		for(int t=ents.length()-1;t>=0;t--)
		{
			ToolEnt tent = (ToolEnt)ents[t];
			if(!tent.bIsValid() || tent.bIsKindOf(TslInst()))continue;
			nNumTools++;
			nNumTotalTools++;
			
		// cuttingBody
			Body bdTool = tent.cuttingBody();
			if (bDebug)bdTool.vis(t);
			if (bdTool.volume()<pow(U(1),3))continue;
			
			
		// remove if not intersecting
			if (!bdTool.hasIntersection(bd))	
			{
				tent.removeGenBeamConnection(gb);	
				nNumRemoved++;
				nNumTotalRemoved++;
				continue;	
			}
		}// next t
		
		reportMessage("\n  " + T("|genBeam|") + " " +
			(gb.posnum()>-1?(T("|Pos|")+ " " + gb.posnum()+" "):(gb.handle()+" ")) + 
			(gb.name().length()>0?(gb.name()):"")+ ": "+
			nNumRemoved + " " + T("|tools of|") + " " + nNumTools + " " + T("|removed|"));
	}// next i
	reportMessage("\n" + scriptName() + ": " +nNumTotalRemoved+ " " + T("|beamcuts of|")+" "+ nNumTotalTools  + " " + T("|removed|")+".");

if(!bDebug)	eraseInstance();
	
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
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BFL
MZH,NP4>I.*1)HI&*I(C,.H#`D4`/HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBLSQ%K$6@>'=0U:8@):P-)SW('`_
M$X%`'@/QB\2S:WXTDTB"YE6PTU!&Z(Y"O*>23CK@8%<#:/<Z7*MQIEY<V<\9
MW(\,I&#2+++=2S7EPQ:>YD::0D]68Y-,NF86[!`6=OE50,DD\`5TQ@E"[.25
M23J6B?5OP^U^X\3^!],U:Z4"XF0B0@8#,K%2?Q(KIJP_!NC_`-@>#]*TPXWP
M6Z!\?WL9/ZUN5S'6%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!7C7Q[U\QZ?IWAN!_GNY//N`.T:]`?J?Y5[(2%!)(``R2>U
M?)OC373XF\<ZKJ:G-NLGV>W_`-Q.,_B<G\:J$>:5B*DN6+9B@8&!73?#C03X
MD^(.GP.FZULC]JN.../NC\3BN89@B%CT`S7OGP.\-G2_"LNLW*8NM5?S%SU6
M(<*/QY/Y5O6E96.;#QO+F/4J***YCL"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@#C?BCXB/AOP'?W$3[;JX7[/;GN'?C(^@R
M:^8+>(0P)&.PYKTSXXZ]_:7BRST*)\PZ;'YTP!X\UQQGW"X_.O-SP,UT45U.
M7$2VB7-$T67Q-XDT_0H<YNI/WI'\,8Y8_D*^N[6VBLK2&U@0)#"@C10.``,`
M5X[\!_#1%M>>*;B/#W)-O:D]?+!^8_B1^E>T5C.7-*YO3CRQL%%%%26%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%5=2OH=+TRZO[
MA@L-O$TKD]@!FK5>5?'7Q`;#PK!HL#XN-3E"OCJ(EY8_B<#\Z`/"KF_FUC4[
MW5[C/G7LS3'/8$\#\J6RTVYUS5K+1K/_`(^+V41`_P!U?XF/L!40`10!P`*]
M;^!/AHW%S>^*;E#M4FVLP1_WVW]/SKIF^2'*<E-<]3F/9M(TNVT72+73;1=L
M%M&(T'L!UJ[117,=84444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%?+7Q+U[_A(OB'?2H^ZUL!]DAYXR/O'\3_`"KZ#\=>(5\+
M^#=2U3($L<16'/>1N%_4U\GVZ,D(+L6D8[G8]23R<UI2C>1C6E:-NY/;V5QJ
MVH6NE68)N;R41)CMGJ?P%?76@Z/;^']!LM)M5"PVL0C&.Y[GZDY/XUXS\"O"
M_P!KO[KQ7<QY2+-M99'?^-A_+\Z]WI5)<TBJ4.6-@HHHJ#0****`"BBB@`HH
MHH`***YKQ_X@N?"_@C4M8LU1KB",>6'Y&20,X[XSF@#I,@DC(R.M+7R=\+O%
M/B&_^*E@9-4NI!>SDW2%\JXP2<KTQ_*OK&@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`***CGFCMX))Y6"1QJ7=CT``R30!X;\>M>^T:CIGAN)\K&/MEP!Z\A`??J:\
MJ@LKG5M1M-*LE+75Y*(D`[9ZD^P'-6=:UA_$7B34];ES_I,Y,8/\,8X4?D*]
M-^!7AG[5>7?BFYC_`':9M[/(Z_WV_I^=;7Y8>I@USU/)'L7A_1;;P[H-GI-H
M,16T80''WCW/XFM.BBL3<**0D*"3T%9\VKP17"0+EW?ICI0!<EDV#"C+'I20
M"1(_W\@+$\#TK.GU6"SX+!YF]#P*A@E?5;I9=[(D9^Z.AH`W:RO$'B'3?#&D
MR:EJDQBMTX^5"Q8]@`!6K3)(HYEVRQJZ^C#(H`\?A_:,\,O?"&33=1BMRV/.
M(4X]RH.:]6TG5[#7=,AU'3;E+BUF&4D0]?\`Z]>=?&'PYX;M?A]JFHMI%G'>
M(JB&:.)5<.6`ZBO.?@1X\L/#UQ>Z1K-^MM:W!5K=I?N*_<9[9H`^F*\9_:#\
M4K9>'+?PY`P-SJ#AY5`R1&I!'YMC\J]@^UVWV0W0GC-N%WF4,"NWKG-?-OA^
M*7XL?&R;5)T$FEV3^;M/W1&APB_B>?SH`]1^$WP[LO"7A^VU"X@5M9NX@\LK
M=8P>0@],#K7H]'08HH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***0D`9/`%`'FGQ!^)UWX
M:UN#0]$LK>[U!D$DK7#E4C!Z#@CDUQWBSXJZ[?\`A&]TBY\-SV-Y<KY)NHY-
MT2@GYNV>1G'/>N8OKL:]XT\0ZI(2R37;11^R)\H`_(5<G*:M%_9^IW*IM;=;
MW1P/F_NMVZ<_6N*6+4:WLSTJ>7N>']KU>QQ=AIEQJM]8Z-8K_I%W((E_V1W/
MX#-?7>A:/;>']#L]*LTVPVT0C'N>Y/N3DU\X1:7>^"Y+3Q7I]TD]U9.?-4`,
MCQ-P<?@?UKZ4TG48M7T>RU*`_NKN!)D^C`'^M=BK1JZQV//>'G0]V>[U+E%%
M%,DKWK%;1]OWB,"L*?R8HE#(7F(Z5MRXE+9;"KD?6LY+0Q2RSM'N0+A<GDT`
M9`A(FDN)-J@=$&#CBM&%9?L41#^4!\S'O6;-<K-J/V>WB"JYP[DG\Z2[N`7^
MR0&1X4X9AS0!TL.JVDCK$LRM(2%P#W-<K\1?"FNZ[:0WOAG6)]/U2U#8192J
M3@X.T]LC''UK3L+"UB>.:*-SGD#TKIJ`/F+5O#_QC\46R:%J\-Q+:"0,6E,8
M4D="6')'^>M<YXH^#WBSPQ"+A[07MMMW-+:9?9]1U_I7V!7/^+-;O-)L8H=+
MM8[O4[MBD$4D@10`,L['^Z!_2@#X[L/%NOZ7I=UI=KJ=PEE=(8Y8"V5(/7`/
M3\*]7^!_CKPGX:T^XTW4G:SU"YEWM=2C]VXZ*N>V/?UK@=6DG\3^-[.Y\36J
MZ+!?8#26UOA2H)&\`GG+=ZTO%WP8\3>&0US;Q#4[`<B:V&64?[2]10!]:P7$
M-U"DT$J2Q.,JZ-D$?6I*^(_#WCGQ+X39DTK4YH$((:%_F3_OD]#]*[7PUX7^
M)'CK3F\1V6O2#]ZRIYEVT98CJ0`-H':@#ZGHKA/AQ/XUAM9M,\8V9,D`'D7R
MNK>:.<AL=QQS^==W0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%-DD2&-I)'5$499F.`![F@!U<5\2O'"
M>"M"1HXO.OKTM%;1YQSCEC[#(_2L;Q-\:-'TV5[+0H)-9OAQF$CR4/N_^`KR
M3Q!>^(/&5['>ZW>)N@!%O;1(`D6>OXG`_*LYU80^)FU/#U:OP1N5]"B:#2(N
M<NVYFP>Y)S_6M#.Y0FT,@_AQP:YO_2]-E*D-&W<'HWO4[ZE=WDD%C:HD=Q=S
M)`C9.!N.,UY]3!SG+G@TT^IZU',J=*"IU$XR2M;N:]EIU_XKUE/#>B-*%D.Z
M\D4_NHD[D]L^E?3.C:7!HFBV>EVV?)M85B3/7`&*R/!7@VP\%Z(ME:_O+B3Y
M[FX8?-*_K]/:NEKT*5-4X\J/)KUG6FYO0*C,\8)7>NX=LU)5"2VMVN6`7+-U
MYZ5H8F?JEY+%M\EQD^U5+_4;EK>)E.P`?/M[FM.]MHA)&`NX9^8#DU"ZQ7/[
ME2J`<D=*`,"%E>*:Y7Y2W`^OU-3Z(KE2EWP,X+*.OH:FO+&41K;B-/*#9W)U
M.*@D4[(XK4/&[-\Q(SG'_P"N@#H_MD%FOEHF0HZ@5H12"6)9`"`PS@UEV]DP
MA6(=^78]ZUD7:@4=AB@!:\UU6Z;6M4N)8F:-[V1M,L9`>4@7FXF]NA7/L/I7
M7>*M0EL])^SVA(OKUQ;6^WJK-U;Z*,G\*X<0B8_9]/D`BF_XE-B2?N6\?-Q-
MGU."/P'3-`#%TRV\07-O"EO$T6HR*L&5YM["W/!'H7;_`-"KU8`!0```!@`5
MRO@ZTCG-SK@@$27`%O9+C[EK'PF/3<<M^(KJZ`/`?V@_!J+;VGB/3K&-`K,E
MX\28)SC#-CW&,^]:?PH^)7@[1_`VG:/>ZD+.\AW^:LJ'!8L3D,!Z?X5[-<6\
M-W;26]Q$DL,BE7C<9#`]B*X&X^"/@6XOC='2Y(\G)BCG8)GZ4`=MINK:=K-M
M]ITV]@NX<X\R%PP_2KM4]+TFPT6PCL=-M(K6VC'RQQ*%'U^M7*`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***CGGAMH6
MFGE2*)!EGD8*H'N30!)3)IHK>)I9I$CC499G.`/QKS'Q+\:M*L'>S\.VQUJ\
M'&^-\0H?4O@Y_#\Z\NUC4_$/BV4R:_J<OD9R+*W<K"/J!U_&LJE>%/XF;T<-
M5K/W$>I>)?C3I%A*]CX>A;6+\<90$0H?=CC/X5Y?K.H^(?%\I?Q'J&8,Y%C;
M'9$GL?7\2:2VLX;2,1Q(%!'"J,9^M3?EQZ#@?_7KRJV83GI3T1[V'RBG37-5
MU?X$-K;0VL7EP(D48'0"G<E@%^]3B<?7W-)@KZY/7V_^O7%=[OJ>G9:16R&7
M;116KF4JPQEF;GBNT^#?@6UO4_X2_4[7]XTI.G1'[L:#C?CN2>GTKB(M)F\3
M^([#PW:L1]H8/<NO\$0ZU].V5I!I]C!9VT8C@@C6.-!T"@8%>OE]+EI\[ZGS
MV;UU.K[-?9)Z**:[[%]3V'K7H'D$5S<^1&=H+/V4=ZJV$=PR&:=0C-V/858)
M\E1+*,N>..U4]3O6CM]J/B1SA0*`"^E9$*6PWS-U:F6EDR(QE4%VZMZ5/:V^
MR$2./F/K1--*X6*!00>IS0!2>,V\3R[E\M>?FZUC-?WEYJ4?V50-B[LE<"MN
M5H2C?:2OR?P$UG16PM9WNI)O+MY<@%CV[8H`TK(WD[1RM+M"MAQV-;*NKYVL
M#CKBN<N;F.)HXX5,T9`(5#^=:FF6\B&29U*^8!\I[4`>=_%K4/$VAWMGK&D6
M#7=I%:RPNRJ6-N[X!DP.<[1C/;\:P/#/B33_`!A(VFZ7%-!</&FF01X^>VM0
M`TTI/0%CQ]<>]>YD`C!&0:JVNE:=8SRSVEC;032_ZR2*)59_J0.:`)[>".UM
MH[>%`D42A$4=@!@5)110`4450U37-*T2$2ZIJ%M9HWW?.D"EO91U)]A0!?HK
MS;5?C#IT64T;3;F_;M+-_H\7_CP+G_OG\:SK+XQWB$+J.@(Z]Y+.YY_[X<`?
M^/5B\123LY(Z%A:[7,HL]:HKA['XL>%KH`7,UWI[DXVW5LV!]63<@_[ZKJ=-
MUS2=80OIFIV=XHZ_9YUDQ]<'BM8R4E=,QE"47:2L7Z***9(4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`5\\_'/Q-::U?6>D:-JCS36CNM
MW;(I$6>,9;@$CGUZU]#5Y)\2/A7X?D\/ZYKMC;-;ZGY9N"_FMLR""QV]L@'I
M0!XQI&DW)55FO``/^65L0,?4BNEBC$*XQN(]3G'XFN4\+WT4,0C=HXPW\"9:
M1_K76L0N,KD]D']:\'&NI[3E>Q]7EL:7LE.._P#7]?H*SG:,G`/IU-,8X'Z<
M<`?2DQSN;EC_`)XH[Y[]JY%%([W)O<5!STRW88Z>]17-PEM;R3,WRQJ23_,U
M.1L&W@L>O^%1:1HDGC'Q?9:!%G[*A$]](.@C';ZGICWK;#TO;5+'/BZ_U>DY
M=?U/3/@MX7:RTB?Q-?1XOM5YCW#E(!]T?CU_*O5*9##';P1PPH$CC4*J@<`#
MH*<2!U-?1))*R/CFW)W8V5_+3(!)[`5'D1J7D(W=>>U+)<(B%FQM'<U4>Y\U
M2L:9ST+#%,1")+JZD+$;8<X7U/O3EM85F5^99!WSP*;!%<LS&3[H/R@>E7(@
MZX^Z3SG%`"_9VD8-,W'H#32XC'DP+N?U]*?)&2"TTA"^W%1+)E3]E"CU+4`8
MW]ER_:9I+F/>">#GC%--E]H7[,^QH`V0J\X]JU)(I9IAOD=U[J.!5ZVMTMX@
MJJ!WH`P[/R[1I(\+$5^Z2.U:VGRS2HYEY&?E.,<5.]K#),)63+CH:BOM2T_1
M[7S[^\MK.W'&^>0(N?J:`+=%>>:K\7M&MMR:3:76IR#H^WR8<^[.,_BJD5Q&
MJ_$7Q3JNY%O(M-@/_+.R3YR/0R-D_BH6L*F)I4]V=5+!UJNT3VW4M8TW1K?S
M]3O[:SB/`:>4)D^@SU/L*X;5?B_I4&Y-'L;K47[2./(B_-AN_)2*\B9/,N&N
M9FDFN&^]/,YDD;ZLQ)/YTZN&IF+^POO/1I92EK4E]QTFJ_$'Q3JX9#J"Z?`V
M1Y5@FQL>\C9;/NNVN8\M3.\[[I)WY>:1B[M]6.2?Q-/HKBJ5ZE3XF>C2PU*E
M\$0HHHK(W"H9+6WF8-)#&S#D,5&1]#3Y9HH$+S2)&@ZL[`"L]]9B;BUAEN#_
M`'@-J?F>OX9JX1F]8F<Y06DCHK+7M>TS'V'7M2A`&`C3^<@^BR;@/P%;]O\`
M%OQ'IB*VH-I=W".K3(8'/_`@2O\`X[7FSSW\_P!^=(%_NPC)_P"^C_0"HDM8
M4D\S:7D_YZ2$LWYFNN%6K#>7ZG#4H4)[0_3\CZ`\#_%6T\9ZL=+_`+*N;2Y$
M+3!]^^%@I`.&(4D\C^&O0:^??A#_`,E"C_Z\9OYI7T%7J49N<%)GB8BFJ=1Q
M04445J8A1110`4444`%%%%`!1110`4444`%%%%`!1110`4R2-98GC<`JZE6!
M&00:?10!\E^._!\WPX\0011:@6@NPTHF6#!1=WW<]":NZ=<K=VBRIYI4C`=Q
MAGKW+XF>"?\`A-O#R0)=-!-:.9X\)N#G'W<5\\:7K$T;0Z9>P3?;0Q5E=-N,
M=OH*\_'TG*/-%'K95B(PFXS>CV]3?]__`-6/\*BN+E;5%.-TTAQ&G<FH[_4+
M?3K5KB=^!]U1U<^U4='BFNI6U&\_UTH^1>T:?XUY4*=XN<ME^/\`74]Z=:TU
M2A\3_#S_`,OOV+MU=?8K![BX8%E7)(&,G_/%>P?![PL^C>&3JU]'C4M5/G29
M'*1_PK^7/XUY?X8T(^,_'5KIK(3IUB1<7GH<?=3\?\:^DGW(%2)`%`QQV%>O
M@:/)#G>[/GLTQ'M*OLX[1_,=(^Q<BHTFBD&0P;GM3S&?**J?F(ZFJL%M<1($
M#(H'H*[CS"5T!/SK\IX^M."H3\J8P.*%MS@[Y"U/$*KT)P/>@!0%`R<4SSE'
M"*6^E/$2?W0?K4=U=6FGVSW-W<0VT"<O+,X15^I/`H`25#.H!7H<C-*EO@_,
MW'I7$ZK\6O#UGNCTY;C59AD9MTVQ`^\C8!'NNZN)U7XG>)]3RML]OI,)[6Z^
M;+^+N,?D@/O6%3$4J?Q,Z:6$K5?AB>TWE[8Z7:M<WUU;VMNG66>0(H_$UQ.J
M_%S0K4,FEPW.J2CH8U\N+/N[XR/=0U>/3[[NY^U7DTUW<_\`/:YD,CCZ%LX'
ML.**XJF8_P`B^\]&EE*WJ2^XZO5?B5XHU0E89X-+@/\`!:)ODQZ&1Q^H537)
M2*9[DW-S)+<W)&#/<2-)(?\`@3$FG45Q5,14J?$ST:6%HTOAB%%%%8G0%%->
M1(D+R.J*.K,<`5GOK-OTMDDN3ZQCY?\`OHX'Y9JHPE+9$2G&.[-*F22QPH7E
MD5$'5F.`*R'NM0G_`.6D=LOI&-[?F>/TJ`6D6\22!II!_'*Q<CZ9Z?A6BH_S
M,R==_91??6H3Q:Q2W)]5&U/^^CQ^6:K/<W\_WI4MU_NQ#<W_`'T?\*6BM%&*
MV1FY2EN_T(5M8@XD8&20?\M)26;\ST_"IJ**;;>Y*26P4444#.Y^$/\`R4*/
M_KQF_FE?05?/OPA_Y*%'_P!>,W\TKZ"KU,-_"1X>-_C/^N@4445T'*%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`5Y[\0/A9:^-;L:DFH7-IJ$5
MLT4>PC8QY*YXX&>N.U>A44`?&>M:5J6A>(OLGB>*0"S4!50;E;T.>F*W[O4[
M>TTQI8V5GV@A0><GH*^F=>\/Z=XDTBYTS4H=\%P@1RO#``@C![8(!KRC3/@4
M-/\`'<5Y]J670('$ZQ2L6E=QT5N,8SS7+6PL:C71([L/CYT5*RNWU.Q^%/A,
M^&/"22W28U+4&^TW3$<@G[J_@/YFNZHIDLT5O"TTTB1QH,L[L`%'J2:ZCAW'
MT5Q.J_%3PSIY:.UGEU28?PV*;T_[^$A/R8GVKB-4^*OB._W)80VNE1'HP'GS
M?FP"CZ;3]:QJ8BG3^)G12PM:K\,3VBXN8+2!Y[F:.&%!EI)&"JH]R:XO5?BO
MX;L24L7FU64<?Z&H,?\`W\8A2/\`=)^E>,WLUQJ<XGU*ZN+Z4'*M=2&3;_N@
M\+^`%-KBJ9C_`"+[ST:64]:DON.QU3XH^)=1W)9BUTF$]/*7SI1_P-AM_P#'
M/QKC[IYK^X%Q?W$][.,XDNI3(5^F?NCV&*2BN*IB:M3XF>C2PE&E\,0HHHK`
MZ0HI&8*I9B`!U)-4)-9M02L&^Y;TA&1_WUT_6JC&4MD1*<8[LT*:SJBEG8*H
MZDG`%8[WNH3_`'?*M5/I^\?_``'Y&H#:1NP>=GN''0S-NQ]!T'X"M%1_F9DZ
M_P#*C0DUFVSBW#W+=/W0^7_OH\?K59[S4)^ACM5]$&]_S/`_(T45HHQ6R,W*
M<MW]W]7(/LD3.'FW3R#^*4[L?3/`_"IZ**;;9*26P4444#"BBB@`HHHH`***
MLZ9INH:U-Y.DV%S?.#@_9XRRJ?\`:;[J_B13C%R=DB93C%7D['8?"'_DH4?_
M`%XS?S2OH*O*/AM\/=<T'7QK.K?9K=1;/$MLDGF298J?F(&T8V]B:]7KU:$7
M&FDSP\5.,ZKE'8****V.<****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBD)"J68@`#))[4`+17(:M\3/"^EEHTOCJ%PO_+&P7SCGT+?<!]BPKB-5^+6M
MWFY-+L;;3HSP)9CY\OU`X53_`-]5E4KTZ?Q,WI8:K5^")[([I&C/(RHBC+,Q
MP`*X_5OBAX8TTM'!=OJ4Z_\`+.P7S!_WWP@_[ZS7BVHWM]K4GF:O?W-^V<A;
MA\H#ZA!A!^`%0@```#`'0"N*IF*^POO/1I94]ZDON.WU7XKZ_?!DTVUM=+B.
M0)&_?R^Q&0%4^Q#5QFH7-WJ\PFU6\N+^0'*_:9"RJ?\`97[J_@!4=%<-3$U:
MF[/1I8.C2^&(=****P.H**,X&35"76+.-BD;M/(.JP#?CZGH/Q-.,7+9$RG&
M/Q,OTA(`))``ZDUCO?W\W$<<5LOJYWO^0X'YFJ[6PF.ZYDDN#G/[ULK_`-\C
MC]*U5'^9F+K_`,J_0T9-8M%8K$S7#C^&$;OUZ#\359[Z_G^XL5LOJ?WC_P!`
M/UIH`4````=`*6K48K9&;E.6[^X@:U25MUPSW#>LS9`_#H/RJ<``8`P!115-
MMDI);!1110,****`"BBB@`HHJ6QM+K5+G[-IUI<7LXZI;1F0K]<?='N<4U%R
M=D*4HQ5Y.Q%17?Z/\'_$FH[7U"2VTJ(]G/GR_P#?*G;_`./?A7?Z/\(O"^F[
M9+R&;59ASF\;*?\`?M<*1]0?K71#"3>^AQU,=3C\.IX1I]C>ZO.8-,LKF^D!
MP1;Q%PO^\1POXD5W>C_!SQ%?[7U.XM=*B/5/]?*/P4A1]=Q^E>Z6]M!:0)!;
M0QPPH,+'&@55'L!4M=4,+".^IQ5,=5EMH<-H_P`)?"NE[7N+:34YASOOGWK_
M`-^QA,?4$^]=M%#%;PK##&D<:#"HB@!1Z`"GT5T))*R.24G)W;"BBBF(****
M`"BBB@`HHHH`****`"BBB@`HHHH`****``D`9)P!7*:O\1_#&D%XSJ`O+A<@
MP6(\YLCL2/E4_P"\14'Q6`;X8ZX#R#$@/_?Q:^8X1+;!1;7,\2KT4/E1^#9%
M8UJK@M-SIP]!5'=['M>J_%S5[HLFD:=!8Q]!+=-YLA'^ZI"J?Q:N)U/4=2UQ
MMVL:E=7X)!\N9\1`^T:X0?E7*1ZKJ46`7@F'?<A4_F./TJTFOX_U]E*OO&P<
M?T/Z5YE6>(GU^X]>C3PM/IKYZ_\``-@`*`%``'0"EJA'K6GR'!N5C;TE!3_T
M+%7E974,K!E/0@YKCE&4=T>A&<9?"[BT452GU:S@8IYOF2#_`)9Q#>WZ=/QI
M*+ELARE&*O)EVBL=]2O)N(8$@7^]*=S?]\CC]:KO`T_-U/+<?[+'"?\`?(X_
M/-:JB^K,G77V5?\``TIM6LXF*+(9I!U2$;R/KC@?C55]0OIN(HH[=?[TAWM^
M0X'YFF*JHH5%"J.@`P!2U:A%=#)SG+=_<0/;^><W4LEP?20_+_WR,#]*F555
M0J@!1T`'2EHJFV2DD%%%%`PHHHH`****`"BBG6\4U[<BULX)KJY(R(;>,R/_
M`-\J"::3;LA2DHJ[8VBNXT?X3>*-4*O=QP:5"?XKAO,DQZA$/\V!KO\`1_@Y
MX<L-LFHO<:K,.<3/LB!]D7&1[,6KHAA9RWT.2ICJ4=M3PRT@N-0N?LUA;3WE
MQWBMHFD8?4*.![FNWT?X1>)]2VO>_9M*A/7SF\V7Z[$./S8'VKWBRL+/3;5;
M:PM(+6W7[L4$811^`XJQ73#"06^IQ5,=4E\.AY_H_P`'O#.G[9+X7&JS#!_T
MI\1Y_P"N:X!'LVZNZM;2VL;9+:SMX;>!!A8H4"*OT`X%345TJ*BK(Y)2E)WD
M[A1113)"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M#COBK_R3+6_^N2?^C%KYDKZ;^*O_`"3+6_\`KDG_`*,6OF2N/$[H]#!;,***
M*YCM$(!&",@U&+>-&W1@Q-ZQ,4/Z5+11=@TGN+;J]WYR7,\TR1N%57D.,8!Y
M'?KWJ\B)&@2-%11T"C`JII_WKK_KJ/\`T!:NUG-ZV-:25KA1114&@4444`%%
M%%`!111&&FN%MX4>:X?[D,2%W;Z*,DT)-Z(3:2NPHKL='^%WBO5]KR6<>FP'
MGS+U\,1[(N3GV;;7?Z/\%M#M-KZO=W.IR#JF3!%_WRIW?FQ%=$,+4EOH<M3&
MTH[:GB$*27-RMM;12W%PWW88(S(Y^BJ":[/1_A5XJU7:\]O#ID!P=]V^7QZB
M-<_DQ6O>]-TG3M'MOL^F6-M9P]2D$00$^IQU/N:N5U0PD%OJ<53'U)?#H><:
M/\&?#]EMDU2>ZU24=5=O*BS[(G/X,QKO;#3;#2K86VG65O:0#I'!$$7\A5JB
MNB,5%62..4Y2=Y.X44451(4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`<=\5?^29:W_UR3_T8M?,E?3OQ0BDF
M^&NMI%&\C^4IVHI)P'4G@>U?,"R(_P!QU;Z&N3$K5'?@FK,=1117*=P4444`
M2:?]ZZ_ZZC_T!:NU2T_[UU_UU'_H"U=K*?Q&U+X0HHI-P,BQ#+2.<(BC+,?0
M`<FI2;T13:2NQ:*ZK1_AOXLUK:R:;]AA/_+74&\K_P`<P7S]5'UKT#1_@GI<
M&V36M1N;]^\4/[B+Z<$N?KN'TKHAAJDO(Y:F-I0V=SQ53OF2",-),YPD2*6=
MC[*.377:/\,O%FL!7^P+I\#<^9?OL./:,9;/LP6O?-)T#2-!A,6E:=;6:G[Q
MAC`9_P#>/5C[FM&NF&$@OBU.*ICZDOAT/,='^"FCVVU]8O[K49.\:'R(OR4[
MO_'OPKO]+T72]$@,&EZ?;6<9^\((@FX^IQU/N:OT5TQC&.B1QRG*;O)W"BBB
MJ)"BBB@`J"[O;:PMVN+N9(8EZNYP!4DTL<$+RRL%C099CV%>,^+O$TFO:@4B
M)6RB.(U_O?[1KEQ>*CAX7>_1'?@,#/%U.5:);L])F\;>'X1DWZ/_`+@)K2TG
M5K/6[!;VQE\R%F*YQ@@CK7S?K%Q+;8M]K(SKN)(QQ7H_P7UC?:WVD2-S&PFC
M'L>#_2N?"XNI5E[ZM<]#'933H4'4IMNQW?BWQ-;>$M`FU6YC>54(543JS'@5
MB_#3Q7>^,-(O=1O51,7)2.-.BKCI[UG_`!M_Y)Y-_P!=X_\`T*N0^$_C;0/"
M_A.ZCU6^6*5KDLL8!9B,=<5ZZC>%T?-2G:I9O0]UHKB=+^+'A'5KU;2'4&CE
M<X7SXR@)^IKK[J\M[*U>ZN9DB@C&YI'.`!6;36YJI)ZID]%>>7?QH\(6LQC2
MYGGP<%HXB1^!K3T'XF^&/$5]'965XXNI#A(Y8RNX^U/DEO8E5(MVN<[\0/BC
M+H&L)H.EP9O"R>;/(/E0$]AW->H1DM&I/4@&OF;XJ,%^*DK,0%!B))[5Z]<?
M%[P=8RBW?4'E90`6AB++^=7*'NJR,X5/>ES,[VBLK0O$FD^)+4W&E7D=P@^\
M`?F7ZCM6A/<0VT?F32*B^IK*QLFGL2T5CMXETX-@,Y]PM7K34;>^A>6%B53[
MV1C%`RU16._B6P4X4R/]%J:UUVQNI!&LA5ST#C%`&E12,RHI9B`HZDUF2>(=
M.C<J9BV.ZJ2*`&ZQJ<ME);PQ*,RGECV&:UJY/6;ZWOKRR:WDW`'GVY%=90`4
M444`%%%%`!1110`4444`%9>I^&]#UHYU/2+&[;L\T"LP^C$9'X5J44`>>:C\
M%O"-YS:QWNG-G.;:X)'Y2;@!],5R6I?`>_C#-I6NV\W/RQW<!CQ]74G_`-!K
MW"BH=.#W1I&K..S/F+4OA=XRTW<6T<W4:_\`+2SE60'Z+D-_X[7*WMK<Z;((
M]0M;BRD/1+J%HB?P8"OL>F2Q1S1M'+&LD;##*XR#]163P\'L;QQDUOJ?'%A(
M@DN%W`L\H"J.2QVKT'>NVT?X=^*];"M!I36D+=)K]O)'_?."_P#X[CWKZ#L-
M`T;2IY)].TBPLYI/OR6]LD;-]2H&:T:E86%[RU*>.J6M'0\JT?X)6$1636]4
MN+Q@<F&V'D1_0G)<_4%:]!T?PWHN@1[-*TRVM,C#/'&-[?[S=6_$UJ45T1A&
M/PHY9U)3=Y.X44451`4444`%%%%`!1110`4444`>4?$?QI&MW+H44C*L>/M&
M`?F/7'TZ5F_#W1[?Q-J$T\P?[):$$CIYC'H/I4/Q1\.77_"5/J*PL;6:-2TB
MKT8<'/Z5R]GJ%WI$3&RN98`/F(1B,FO"KN"Q'-55[=#[+"TN;`J&'=FUOY]3
MT+XO^'4DL+/5;:-5>$B!U''R=OR/\ZXCX?7%WI?C.QD2)V65O*D5>ZM0_C36
MM<T_^R[^43IN#*Q&&X/3W_\`K5ZKX!\(?V-:_;[U`;V8?*/^>:_XUNFZU?\`
M=JRZF$Y?4L$Z==W;NEYE#XV_\D\F_P"N\?\`Z%7G_P`*/ASI/BG3[C4]5:61
M(I?+2!#M!XSDFO0/C;_R3R;_`*[Q_P#H54/@-_R)]Y_U]'^0KW$VJ>A\7**=
M:S.`^+G@O3/"5]I\NDAXXKE6W1LV<$$<C\ZWO'6IWU]\$O#LY=R)F59SGJ%#
M`9_$"IOV@OOZ)])/Z5U/A[^P_P#A2^EKXA,8TYX0DC2=`2Y`/MS57]V+9/+[
M\HK30\]\#Q?#3_A'HV\0.IU$D^8)F8`>F,=J[OPSX;^'M[KUMJ7AN\47=JV\
M11RY!^JFL=?AK\.+I6EM]=(C/(Q<KQ^=>;6:1:%\3X8=!O&N(8;Q4AE4_?'&
M1[]Q1\5[-A=PM=(TOBQ&)OBA/$V=K^4IQ[UZI'\%/"9T[R_+N3,R?ZTR\@XZ
MXKRWXJLJ?%.5V.%4Q$D]A7NLGCWPO;:;]I;6;1D1,X5\D\=`*4G)15AP47.7
M,>%^`Y[GPE\6(]+65C&]R;20=G!.`2/R->XW:G5?$GV61CY,78'TY->&^"DE
M\4_%^+488V\H7;7;9_A4'(S^E>Y3.--\5>=+Q%+W^HQ2J[ET/A=NYT,=A:1(
M$2WBP/50:>EO#"K!(U16^\`,`U(K*ZAE((/0BL_6Y732)S$?FQ@D=A6)N0O?
MZ-:GR_W/'7:F:QM<N-.N(XY;,J)@W.T8XK0T&PL9=.65XTDE).[=VJKXCAL8
M8(Q;I&LQ;D*><4P)-:N99+*PM0Q!G4%CZUL6VD6=M"L8@1CCEF&2:P]81H[7
M3+H#Y8U`/Z&NE@GCN85EB8,K#/%`'-:[:06VH69AB5-Q^;;WYKJJYOQ(1]OL
M1[_U%=)2`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@!LD:31E)$5T/56&0:XC7/A?I&JL6MI)+%F/S"
M(94_@>E=S143I0J?$KFU'$5:#O3E8X'P[\+-.T'54OY+N2[9!\B2(``?6N^H
MHHA3C!6B@KXBI7ES5'=G/^,?"T7C#06TJ:Y>W1G5]Z*&/!SWJ'P3X.A\%:3+
M807<ERLDOF%G4*1Q[5TU%:<SM8Y^57YNIQGCOX>V_CEK,SW\MK]F#8\M`V[.
M/7Z58?P'8S^`H/"=S<2R6T2@"4#:Q(;<#^==713YG:P<D;M]SQJ;]GZQ+YAU
MRX5<]&A!_K73>$OA-HOA:_6_\V6]NT^X\H`"'U`'>N_HINI)JS9*I03ND>?^
M*_A-I/BK5Y-3GO+F"XD4!MF"./8USR_L_P"F!\MK=V5]/*7_`!KV&BA5)+2X
M.E!N[1SWA;P9H_A"U:'3(3OD_P!9,YR[_CZ5KWMA;W\6R=,XZ,.HJU14MM[E
MI)*R,#_A&BO$5_,J^E:%EI:6MM+"\C3K)][?5^BD,PF\,PAR8;J:)3_"*>?#
M-F8&0LYD;_EH3DBMJB@"N;.)[(6LHWQA0O-9/_"-B-CY%[-&I/W16]10!AQ>
1&H5F62:YEE93D9K<HHH`_]F)
`

#End