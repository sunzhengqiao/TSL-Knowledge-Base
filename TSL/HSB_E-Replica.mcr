#Version 8
#BeginDescription
Last modified by: Robert Pol (support.nl@hsbcad.com)
28.08.2020  -  version 4.00

4.1 29/11/2024 Only execute when a execute key is set Author: Robert Pol
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 4
#MinorVersion 1
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// Replicate elements
/// </summary>

/// <insert>
/// Automatic with replicator tsl
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="4.00" date="28.08.2020"></version>

/// <history>
/// RP - 2.00 - 28.01.2017 -  Redo the copy with the new function dbCopyEntitiesFrom
/// RP - 2.01 - 13.02.2017 -  Add option to add replica's and do check on element outline
/// RP - 2.02 - 20.02.2017 -  Add mirror option
/// RP - 2.03 - 24.02.2017 -  Change mirror option
/// RP - 2.04 - 10.03.2017 -  Get all entities from group
/// RP - 2.05 - 17.03.2017 -  Do not recalc at dwgin
/// RP - 2.06 - 27.03.2017 -  Change display when the element is a wall
/// RP - 2.07 - 13.04.2017 -  Add replica's to a map instead of getting them from the element (with help from Anno ;))
/// RP - 2.08 - 09.05.2017 -  Use MapX to store the elements instead of subType
/// RP - 2.09 - 10.05.2017 -  Expose delete construction execute key
/// RP - 2.10 - 31.10.2017 -  Do display last
/// RP - 2.11 - 01.11.2017 -  Set map for element first because the mirroring was not set
/// RP - 2.12 - 03.11.2017 -  On recalc all the tsl had no visualisation
/// RP - 3.00 - 10.01.2018 -  Completly rework tsl because of performance issues
/// RP - 3.01 - 17.01.2018 -  Check if there are at least 2 elements
/// RP - 3.02 - 03.03.2018 -  Add support for using acad delete
/// RP - 3.03 - 16.04.2018 -  Re-add check for element outline
/// RP - 3.04 - 30.05.2018 -  Add dimstyle and text height
/// RP - 3.05 - 06.06.2019 -  Mirror not working
/// RP - 4.00 - 28.08.2020 -  Remove dependency on entity and remove mapx on mainelement

/// </history>

double areaTolerance = U(1, "mm");
String arSTrigger[] = {
	T("|Recalculate All|"),
	T("|Delete Construction|"),
	T("|Make element unique and delete tsl|"),
	T("|Select new main element|"),
	T("|Mirror|"),
	T("|Recalc|")
};

String dimStyles[0];
dimStyles.append("");
dimStyles.append(_DimStyles);

PropString dimStyle(0, dimStyles, T("|Dimension style|"));

PropDouble textHeight(0, U(100), T("|Text height|"));

for( int i=0;i<arSTrigger.length();i++ )
{
	addRecalcTrigger(_kContext, arSTrigger[i] );
}

if (_bOnInsert)
{
	reportWarning(T("|This tsl can not be inserted manually|"));
	eraseInstance();
	return;
}

Map productionMap = _Map.getMap("Hsb_production");
Map replicatorMap = productionMap.getMap("Hsb_replicator");
int isReplicator = replicatorMap.getInt("IsReplicator");
int isMirrored = replicatorMap.getInt("IsMirrored");
int sequenceNumber = replicatorMap.getInt("SequenceNumber");
Entity mainElementEntity = replicatorMap.getEntity("ReplicatorElement");
TslInst replicatorTsl;
Element mainElement = _Element[0];
TslInst allTsls[] = mainElement.tslInst();
for (int index=0;index<allTsls.length();index++) 
{ 
	TslInst tsl = allTsls[index]; 
	if (tsl. bIsValid() && tsl.scriptName() == "HSB_E-Replicator")
	{
		replicatorTsl = tsl;
		break;
	}
}
Entity replicatedElementEntity = replicatorMap.getEntity("ReplicatedElement");
Element replicatedElement = (Element)replicatedElementEntity;
Entity elementEntities[] = replicatorMap.getEntityArray("Entities", "Entities", "Entities");
if (_Element.length() < 2)
{
	reportNotice(TN("|At least 2 elements are required!|"));
	eraseInstance();
	return;
}

replicatedElement = _Element[1];

assignToElementGroup(replicatedElement, true, 0, 'T');

if (!replicatedElement.bIsValid())
{
	reportMessage(TN("|Replicated element  not valid!|"));
	eraseInstance();
	return;
}

if (!replicatorTsl.bIsValid() && !_bOnDbCreated)
{	
	Map productionMap = replicatedElement.subMapX("Hsb_Production");
	productionMap.removeAt("Hsb_replicator", true);
	if (productionMap.length() > 0)
		replicatedElement.setSubMapX("Hsb_Production", productionMap);
	else
		replicatedElement.removeSubMapX("Hsb_Production");
		
	productionMap = mainElement.subMapX("Hsb_Production");
	productionMap.removeAt("Hsb_replicator", true);
	if (productionMap.length() > 0)
		mainElement.setSubMapX("Hsb_Production", productionMap);
	else
		mainElement.removeSubMapX("Hsb_Production");
		
	replicatedElement.setLock(false);
	
	reportMessage(TN("|Replicator not valid!|"));
	eraseInstance();
	return;
}

_Pt0 = replicatedElement.ptOrg();

int indexRepllicatorForColor = sequenceNumber;

// Draw first part of display
Vector3d vxText = replicatedElement.vecX();
Vector3d vyText = replicatedElement.vecY();

if (mainElement.bIsKindOf(ElementWall()))
	vyText = -replicatedElement.vecZ();
if (_kExecuteKey.length() > 0)
{
	String trigger = _kExecuteKey == arSTrigger[0] ? _kExecuteKey : _kExecuteKey == "" ? arSTrigger[5] : _kExecuteKey + ";" + replicatedElement.handle();
	replicatorTsl.recalcNow(trigger);
}

if (_kExecuteKey == arSTrigger[4])
{
	if (isMirrored)
	{
		isMirrored = false;
	}
	else
	{
		isMirrored = true;
	}
}
else if (_kExecuteKey == arSTrigger[3] || _kExecuteKey == arSTrigger[2])
{
	eraseInstance();
	return;	
}


PlaneProfile ppMain(mainElement.plEnvelope());
PlaneProfile ppReplica(replicatedElement.plEnvelope());

if (abs(ppMain.area() - ppReplica.area()) > areaTolerance)
{
	reportMessage(TN("|Outline of Replica |" + replicatedElement.number() + T(" |does not match outline of main element|")));
}

Display dp(indexRepllicatorForColor);
if (dimStyle != "")
{
	dp.dimStyle(dimStyle);	
}
if (textHeight > 0)
{
	dp.textHeight(textHeight);
}
dp.draw(_ThisInst.scriptName(), _Pt0,  vxText, vyText, 1, 1);
dp.draw(replicatedElement.plEnvelope());
//replicatedElement.setSubType(subTypes);
dp.draw(T("MainElement: ") + mainElement.number() + T(" Element mirrored: ") + isMirrored, _Pt0 + vyText * U(130),  vxText, vyText, 1, 1);

return;
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
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***BFN8+<9FFCC`[NP%`$
MM%<OJWQ!\.:0#YVH1NX_AC^;^5<?J'QGB9C'H^F2W#'@,5)&?PJ'.*W8TF]D
M>L4@((R"#]*\"O\`QKXTU+RXI6&GI<2!(V('.>G3FNJ^&,VJC7]2L[[4Y;A8
M4!:-L%2Q[@]>WZUG]8AS<I7LY)79ZI1116Y`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!112,ZHI9V"J!DDG`%`"T5CZCXIT72DW76H0*>FT."?R%<9J'QGT2!
MY([*&6Y=>@`ZU,IQCNP5Y;:GI=,DECB7=(ZH/5CBO$Y_B/XOUM%.F:<+>)^C
M8QQ_P*LZ;2/$^KEGU76W12/NQMC^7%1[5/X5<KD?70]AU/QIH&DJWVC482R_
MPHV[/Y5Q>H?&G3D&W3+*:ZDSCA2?Y5P&EZ;H<-C)<ZLQF9+AHUD9B=V,]A]*
MT8]=TV"39I>DM*<?>6/'\Q6*Q',KW2_,T]B[]7^"+LOCOQIKES)#90):J%W<
M[05'K@\\U0D\.:SJ"[]7UV4<Y(1^,?C26AU2_P!0U&6+;:7;Q)M7T4$>OM5I
M?"US<.&O]2FE'=0V!^E9PG*HWHW9_(MPC#LOQ9DII6CZ=XAME5UN8A!(TQ9M
M_(4]O6K\?B&)%*:3H[''1O+V@_UJ1-,M]-\3V5M`O[N6%RX89SP:ZA(8HP`D
M:J!TP*5*,W4FEIL$YQ5KZG%WLNJW-[ILNHJD$7VE=D:CJ<_X5VOPTB\GQ5K2
M,[/)A2S'OUK!\3?Z_2/^OQ:Z+X>?\CIKO^ZG]:RG&V(6M]OS&Y7I[6_X<]0H
MHHKU3E"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`***XWQ#\2]"\.W,EM.[R7$9PT:C&#]:3:6K`[*@
MG'6O';WXNZKJ#>7H>C/M;I(ZD_3GI6!<ZMXRUW44L;W4/L1E1G"J,C;SZ5E.
MO"*N6J<CV^]U_2M.1GNKZ!`O4;QG\JX_4OB]H%I+Y-J9+J4G`"#J?;UKSEO"
MMC;GS-8U>24MRRO(`"?YTP+HJZSI5OI,:DI<*9&"Y!'&.:SJUY0BY:%0I*3W
M.DNOBEXCU0NND:0T*@X#NIZ?4\5S^L3>,+NRDO-4U-HHE&7BC(S^G%73J^L7
M)9+#3%B7<0&D';\*H:OINKMI\MSJ5Z6B09,4>`*B51RC=7?X&D::3UM^8\^&
M=$M'+ZEJ4EP>H2:49'Y8-))JN@VUN\6FZ>9&P1N6,\?B:W3X<L)KI[J9&D>0
MY.X\"K,]C:VVGS"&!$PAZ"E2C-TT]%H)SA?6[.>L)-<_LZUM;&.)8Q$/WQY.
M<?7%96H6/B&?7;?3&U!#)-;O<$R$A<*0,?+]:Z_PU_R+UG_US%9&NZ%%K7B^
MR%W;SO:+82@R1LZ!7W+@;E(YQG@T\-23I1<F*=5J3211\,W&G2^'+B;5T@MX
M[.[:)\N2A<<<'OG-=#;:UH*Z9<7T$\0M;;B9A&<Q_5<;A^5</ING7PT.*"%+
ML+I6K'>UM$#(T85@'12"&(W#(`/>KVJVUN/#/B>^BEU::6>VC62:_@$(?;D#
M:-BDD=SCN*TP\(I.RZLBI*3>K-O1]9TV_P#&>I1VEY%*WD+@*?O8QG'J/I1H
MFN7=SIVAFYNH#->23+)YD1W2;"V`NT!0>!G/8'%8NFO/K'Q$M[F+3;NPCL8V
M\U+B,)@&/8%&"00201CL*L:787D<'A$/:3J8+FY:8-&1Y8(DP6],Y'7UJZ44
MN:W<F;O8O7>M::_CVQM5O(FFC1HG4'.UR#A2>F?:MF'Q'I%Q>K9Q7J-,[%$X
M(5V'4*V,$\=C7&Z-YNF:_INEW5A<FXBEGW.(LI(&D9A(&Z$`$'U&*<TNL:E<
M:2]Y'J?VB'4XWGM5LMMO`@8@$/MRW!'.X\$D@5-)?O)_(<]D=)XF_P!?I'_7
MXM=%\//^1TUW_=3^M<[XF_U^D?\`7XM=%\//^1TUW_=3^M<M7_>/N-5_"_KN
M>H4445Z1SA1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%>"ZW+:0?$;Q!/>0^;'''&0NW/)(`KWJO$KA
M%D^*6OJZAAY2'!^HKFQ5^56[HTINU[]B@-<OY_DTS2-BCNXX_*H+>#4+CQ`J
M:C,J7$UK(L80?<!!%=@%5>@`^@K$G_Y'6S_Z]'_K6&*IOV3<G?;\S2$U>T58
MAM_"%FA#7,DEPP[LU1ZG96]CJFB"VB6/==`,1WZ5TU8.O?\`(6T/_K[']*O$
MTX1HRLN@J=24IJ[-[`'0`5D>)_\`D7KO_<K7[UD>)@6T"Z4#+%>`.]=$OX;]
M#*#M)-FLOW%^@J"^_P"/&?\`W#52XU[3;)!YUU&"!T!YK"N_&]G<H]O8P2W,
MC`C:@YJ*<HQI13?023;NE<VO#7_(O6?_`%S%:CNJ@Y8#BN$LSXH>UCMK*S^S
MVZC:K2G#"J<>F7MY8W-Q>ZC*7MYC&5CX]#_6LH551IQBT:.FY2;.M\,?\>][
M_P!?3_S-:6HV%OJFGSV-TI:"9=K@'!(^M4/#T"VT=_`A9E2Z=06.2>3UK9JL
M'+FIW7<5;XS$L_\`D;]2_P"N"?TK;K$L_P#D;]2_ZX)_2MNJP^\_7_(53IZ(
MP;W_`)'+3?\`KC)_(UO5@WO_`".6F_\`7&3^1K>I4OXL_D$]H^AS_B;_`%^D
M?]?BUT7P\_Y'37?]U/ZUSOB;_7Z1_P!?BUT7P\_Y'37?]U/ZUSU?]X^XU7\+
M^NYZA1117I'.%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!112$@=2!0`M>*2_P#)5-?_`.N*?S%>K7_B31]-
M5FNK^%-O4;N:\.U'Q3IMOXXU35(IO.ANE5(PO4]*Y\1M'U1=-WO8[2L*X('C
M2S).`+1^?SK%/B?6=1E\K3[`QE@2C2?Q#VH'A_Q!J4J3ZA?I;G&"$Y./3-16
M:K1<(CC&4=7H=5=:M8V2YGN8T^IKD]8\5:;<WEF\#.\EI+Y@4#[_`/A4%_X>
MTS39K4-.US*TP#I(V1MP3T_"M(:WI-GF+2],,C*2,*F`/7FIJ55)NG+0N%)J
MS5W^!1N_$7B*:W:>+3S;P#&6E!&*G'AC5M2_>:CJW[IU#!$'MGUINK7FLWMB
M_GVR6UEQO)&3UK4G\/2:DXDFO91`R)LC4\`!1_7-1SRE4Y5=JWH5R1BKZ+\3
M)ETGPQID#?:+@7%P`<;WW'...*LV.K-8Z58)#IK7$TD1?>.,#>P]/:M/_A&]
M-M+:1TAW.J$AF.><59\._/X?LV;DX;D_[[42A/VL%MO^0.<.6^YD;_$VH@A1
M'9QGIQR!]:RX;$/I<\CNQDMKLE\G[[$+7?UQD'_(*U;_`*_#_(5.+IV4;N^_
MY,=.I>]E8W]&_P!;J?\`U^/_`#-:E9>C?ZW4_P#K\?\`F:U*TP'\!&-;XS$L
M_P#D;]2_ZX)_2MNL2S_Y&_4O^N"?TK;K7#[S]?\`(53IZ(P;W_D<M-_ZXR?R
M-;U8-[_R.6F_]<9/Y&MZE2_BS^03VCZ'/^)O]?I'_7XM=%\//^1TUW_=3^M<
M[XF_U^D?]?BUT7P\_P"1TUW_`'4_K7/5_P!X^XU7\+^NYZA1117I'.%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!116/XD\16OAG
M2S?W:NT>X+A!DYH!LV*0D`9)Q7C]Y\8-1O<IHNCN[9P&;FL2]U?QYJD,KW-V
M+2V"EV56.0!ST[FLO:QZ:E<DO0]LO=<TS3O^/N]ABXSAFKD=6^+?AW3PX@D>
MY=3C"#@\^M>8V_ARRN[&'4-4U29_,7>=S;>_UJQ%/X6THC[);">7/WD3<2?4
MFLU7YES*R1:I=-7Z&[=_%?7M4XT322L;9'FM\W_ZJRIF\;ZZ&&H:G]EB)/RJ
MQ/!ZC%5=+N=5BTPBPM59I;B1B7_@^[BK@TO7[X9N]1,*MP4BXXK*G5E4C=W9
M;IQB^GSU,:RT/3?MNH+JMS)(ML5!D9\!B<]JT$U'P]IQ,>FV(FD`X,:<'\:D
MT32[8W^JV$RF5(V3+,>6/-=);Z?:6H_<P(OOCFIH1G)RM9:E5)13UNSEX;W4
M-1UB.9;9;9U@<0JQSG)6J7B73M:B\.W]]<ZI(&AA+A8R0`?:NEN?^1KL/^N$
MG\UJ;Q%ITVK^';[3[=D6:XB*(9"0H/O@&KI4[U)<SOL1.I9+E1YM9+I\6O:<
M='U&6_MR/],:496-C]W#$=3\W'M786OB:W62TG323%IMY.((;KS$R2QPI*#D
M*3W_`#%0>)]'_P")MHU_'L#AOLUP.GF(1D?B"#^9I=*\)RZ6;6V_LC09TMY%
M(OWC_?,@;.=NS[^.^[KS[5I",56E;LOU(E)N*N5_$GB6YFTS5H8='E>"QN/)
MFN!,H4`!6R`<$GGD=LCGFK/VI9-?2[AW%'\.B5=K;21N!'/.#SU[5@ZE%K4E
MOXF2R>Q_L^34G282AO-5MD?*D<$<C@^GO74V_AZ6.6"2&2/R%T5;!-Q.[=Q@
MGCIC_P#53=O;KO9_FA:\GS(%\0E="TRVL;*YO;J[L1.(Y)QN2+`!=W;J<D=L
MFI=&U#48_#6G_9=(:9BCM)ON$C5/WC#&><GOTQTYJM_PC^IZ99:9=6C6LEU:
M::;&YCD=E1UP#E6"DY!7N.<]JJ66A:AJ%CI5W)!IU]"MO)&UK=LPCC<RL?,`
MVD,<8'('3J**G\6'S_(%\#.OTC4HM8TJWOX4=$F7.Q^JD'!!^A!KF8/^05JW
M_7X?Y"MWPSI<VB^'K73KAHFDAW@F+.T@N2,9]B/_`*]84'_(*U;_`*_#_(5C
MC=H_/\F71Z_(W]&_UNI_]?C_`,S6I67HW^MU/_K\?^9K4HP'\!$UOC,2S_Y&
M_4O^N"?TK;K$L_\`D;]2_P"N"?TK;K7#[S]?\A5.GHC!O?\`D<M-_P"N,G\C
M6]6#>_\`(Y:;_P!<9/Y&MZE2_BS^03VCZ'/^)O\`7Z1_U^+71?#S_D=-=_W4
M_K7.>)B/M&D#//VQ:Z+X<NK^,M=*D$;4&1^-<]7_`'A?(U7\+^NYZC1117I'
M.%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!7GOQC
M_P"1(;_KJ/Y&O0J\]^,?_(D-_P!=1_(TI?"_1DRZ>J_-'"G5]1AAMK6PT[S"
M(8QYK'`^Z*CN;7Q#>VLTEW=+;PJC$QQ\$C&<5TNG?\@NS_ZX)_Z"*-1_Y!EW
M_P!<7_D:Y*5-NDFWT.CVB3LD8-AX>L-2T^QN9@S`0[0I^IK:MM)L;0`0VZ#'
M0XJ+P_\`\B_8_P#7/^IK2IX6G'V2=A5*DN9JY@^%/^0=<_\`7U)_2MZL'PG_
M`,@ZY_Z^I/Z5NLZJ,LP'U-/"?POF_P`V36^-F!HO_(R:W_O)_(UT%<K::A:Z
M9K>KW%U,J12LFQLYW8!I)_'-F&V6L$L[D9&%XI49*'-S::CJ>\URZZ&E=?\`
M(UV'_7"3^:UK/+'&,NZJ/<UPK7'B75;R.Z@T\6[HI5'D.``<9_D*;>:%J9>W
M?5-1+^?.D9B0G`!(_P`:7/R.=2V@W!RLMC=UZY@N/L'DRJ^V[4':>G!KHCUK
MS6&RM[+4?*MV9UCOT4.6R2-K5Z4>M+#U/:59/T_4*D>5)&+XG14T"ZVJ!N*D
MX'4[AS6K;?\`'I!_UR7^0K+\4?\`(OW'_`?_`$(5J6W_`!Z0?]<E_D*M_P"\
MKT?YH7_+OYB77_'G/_US;^54/#?_`"+MG]'_`/0VJ_=?\><__7-OY50\-_\`
M(NV?T?\`]#:G4_C0^?Y"7\-FK7&0?\@K5O\`K\/\A79UQD'_`""M6_Z_#_(5
MEC-H_/\`)ET>OR-_1O\`6ZG_`-?C_P`S6I7,?VJ=)%\XMWE:2^<`#ZFL^7Q)
MK%TW[E(K=?0`N?Y5G@JT8T4NI52DW+FV1MVK*OB[4BQ`'D)R3]*MW6NZ;:<2
MW2;NRCDFL.P\+Z_K$=PQLKB9KM5_?2_(@`((]\<>E=!I7PCO&9'OKBWM0,$B
M%?,)_$@8K:E&LG*T;7=]3*52CWOZ?Y['-2:RE]X@@O;6%REO!(/WGRAC@XJ"
M37-;O6"1LD.\X"Q*6;\\5ZS8_#30;0[IEFNV(Y$SDJ?^`]*Z>STNPTZ-8[.T
MA@51@"-`,"KCAY<SE*6_83K2^S#[_P#@?YGA]AX,\2ZE>0W3VT[M$X=6NWV+
MU[8S7HG@OP9>^'KZ:]N;B`&=</!$F1GL=W!_2NWHK2-"G%\UM27*I+XI?):(
M****U`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***0D*
M,D@#U-`"UY[\8_\`D2&_ZZC^1KK[[Q#I&G#_`$O4((_;=G^5>7?$?QQH6NZ.
M=*M)WD82Y+HN1@`]*F;2B[LEZVMKJOS+.G?\@NS_`.N"?^@BC4?^0;=?]<7_
M`)&N,7Q/JTEI'%I^G2"&*,*97&,`#&3GZ5)!IFOZY:QW$^II#;R#</+)!Q^5
M<U.HE",.MC;DE>[T1MZ/J5G:>'[,37"(RQ\J3SU-5;KQOIT1(MP\Y_V%SFJ!
M\+Z#8D2ZC?M,XZ[I#S^`HTZ_LM.M[F6WL//$ERRP^7&/N\X_"H]HZ,8P+]GS
MMR_X!3T^_P!=^SR0Z9ITBQR2&3S'P,YJ2#3-7U34)[34M4:"2!0["(Y4@XX[
M=C6FNI>(KY<6]G';`GJW)Q4%GI<UYJNH6MY=2&X\M"[IQD<8Z5$Y<J2A??T1
M?(E=RM^;&C0/#.F-OO+H3/Z.Y8?D,T6=W:-X@B?2;;;##;2?(J[0[8)%;5KX
M6TRV'^I$C?WFYJ%XT@\96$<2A$^S/\JC`[T8B$E2>B01E%O=LJ_:/$VH-^[B
MBM8^YZFH)M(N;*ZL;B]O)+ES=1@*7.!\PKL:Q]>ZZ?\`]?D7_H0K2O2M2DVV
M]"(5;R22L<M-&D&K/!&H5(]0C`P/]EZ]!/6N!N_^0]/_`-A*/_T%Z[X]:QP6
ME285^AC>*/\`D7[C_@/_`*$*U+;_`(](/^N2_P`A67XH_P"1?N/^`_\`H0K4
MMO\`CT@_ZY+_`"%=+_WE>C_-$?\`+OYB77_'G/\`]<V_E5#PW_R+MG]'_P#0
MVJ_=?\><_P#US;^54/#?_(NV?T?_`-#:G4_C0^?Y"7\-FK7&0?\`(*U;_K\/
M\A79UQD'_(*U;_K\/\A66,VC\_R9='K\CTZQ\`:3>!+Z[>>8RGS?*\PA`2/3
MH>M=/8Z%I>F#%G86\/.<I&`2?6I-*_Y!5K_US7^57*Z</I2C;LCF=.+=VK^N
MH4445J6%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!17E?B#XK7EGK=UI.FZ69IX&*[CST-<W/J_CW71F2Y6R1CR,@''_``&LW4BG
M9:C46U=;'M=WJ^G6"%KJ\AC`]7&?RKDM7^*WAW3&,<4S74@'W8A_C7E0\/%]
M=^S:OJ,URAMVE<F0@#KW]*LH_A72U98+<7,B_P"R7)/U-8_6+MK:W<T5+Y^A
MT%W\8-6OF6'1])*R.VQ&D&,GMC/%94TWCC7)";O4?LL+=55L$#\*K'49=2U3
M2ECT\VUNERK`L`N>>PJT^EZ]J+-]JO\`R(R>%BX./J*R564IN.K]-"W2C%:V
M7KJ8FL>&K>QTZ2XNM1DNKH'@-)C^M:?VOP_I.(8+`3W"':0L6X@CW-1:QX>A
MTW29+MI9)[A2/FD8M_.NJM[*V4"40IO<99B.II*,_;66FGKV*E**BKN_X',W
M6L:M>6LR1::(+8H<L_85+;:+<:CH^GB._DB@6(#$;$;JW]5`&DW0`Q^[-0>&
M_P#D7+'_`*Y"G.G>M%2=]Q>TM"\58Y?Q'H=OHNE17$,V)I+J&%II@'VJS`$_
M-QTI?"6I21:IK-G<7$-U86@,WVP(%"89@0<<=!NXK>\5Z9-JVF6]M#;K.!>0
M/(C$8,8<%LYX(QGBN;L-"N9)O$FFV,20Z9?+-&"I`2"8$A?E_ND'L/X:WE"$
M7%)&7/*2=V=/8^)K.]OH+007D#7*L]L]Q`46<`9.W/MS@XXKG+#QCIQ\2WUV
MT-XMM)MA:8P$I$P8+\Y&0`3W]ZNZ/I!2_P!/>YT&^CGM@<W$^I&6*,[",HOF
M-G/3E1@'VKCM$M=3U>WU/1[>P1H+IF5KII1B)1.225/)/!QCOBG65^7U1,.O
MH=C?:I/9W?BN1KRXBBMH[=HV11(8<KR55CCW(_K2ZIK$-IXUT]5AN;N46C,T
M=M'O90<X)';H:;K6AZC=1>*Q!;[_`+=!`EM\ZC>54@]3Q^.*K74-[I?Q$CO+
M>RDO?M5F!Y<;JK*R@K_$0,=_SI8E)TV.GN=#>>)+>SC\XV6H2P+$)I)H[<[8
MU(SDYQT')`SBFZS*D\6ES1,&CDNH65AW!8$&L76K#7=1N+Z.:SNY8I[55M5M
MKX110N4^?S,,I;YN^"".PK0FAEMM$\/P3H4FB>V1T)!VL-H(R..OI1B?X,O0
M*7QHQKO_`)#T_P#V$H__`$%Z[X]:X&[_`.0]/_V$H_\`T%Z[X]:Y<%_$F76Z
M&-XH_P"1?N/^`_\`H0K4MO\`CT@_ZY+_`"%9?BC_`)%^X_X#_P"A"M2V_P"/
M2#_KDO\`(5T/_>5Z/\T3_P`N_F)=?\><_P#US;^54/#?_(NV?T?_`-#:K]U_
MQYS_`/7-OY50\-_\B[9_1_\`T-J=3^-#Y_D)?PV:M<9!_P`@K5O^OP_R%=B[
MI&NYV55'<G%<1%=P)IVH1F0;IKTB,#G=@+6.-:M'Y_DRZ*>OR/?]*_Y!5K_U
MS7^57*IZ5_R"K7_KFO\`*KE=5#^%'T1D]PHHHK404444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`?/5S<75M\0?$4MG`LTP/"-T^_S5
MHVWB/40/-N$M(FZJ@&1_6G6O_)3_`!!^/_H5=/7)"GS3G=]?\BX3Y81TZ+\C
MD;'21:^(6LYYGG\ZU;<SL3P<C%=!;:/86@Q%;(/<C-4C_P`CI'_UZ'^9K;J,
M/"*JU--FOR+J3DTM3$UM0M]HP``'VQ.@]Q6W6+KG_'_HW_7XO\Q6R6"C+$`>
MYK6'\>?HOU(E\"^9B>+?^1>G^HK9A_U"?[HK`\47=M/I$ULEQ%YI(^7>*IR>
M.;&.+9;127#(HX52:3:C7YGM;]07O02CKJ=%JW_()NO^N9JKX>=$\-V)9@O[
MH=3[5S[ZKXBUF`&RT]5MY1D,S`9'0]321^$]5G11?ZJ(8UZ)#Q^%*3YJBG'6
MPTFH.+T.FFUS3;=@LEW&"3CK57PXZR?VDZ,&5KQR"#D$9-<BNFV%KI$ERZ+)
M=BZ,2,6)R..W2NPT!5235$10JK>R``#`')KG^L^UJQC;J4H<L&S9KG=(M8+/
MQ3J<%M$L40B0A%&!DX)_,DFNBK"L?^1PU3_KC'_(5U8C:/JB*>S]#=K"N?\`
MD=M/_P"O:3^M;M85S_R.VG_]>TG]:6+_`(3'2W?HS=K'U[KI_P#U^1?^A"MB
ML?7NNG_]?D7_`*$*K$_P9>@J7QHYF[_Y#T__`&$H_P#T%Z[X]:X"]W?VW=,J
MYVZ@C8_X"]7+GQ)JEQ*T-M%%$<G&WYW/X#-<.%J*%2=S:I!R29M>*?\`D7[C
M_@/_`*$*F?6+"PM8A<7**RQIE>IZ#L*YZV\.^)/$#[O)O+A01D2`0J?^^L9K
MK4^%NHW]R9[VXMK<.J[O+7<XPH'?(SQ75RU955.,;:6U,O:45'EYK^FISEYX
MOAEC>*TM)I=ZD;R,#D>]4([_`%*'2[*UL)0"L9,@C3S&#%V.,`'MBO5=/^&.
MB6A1KHS7CKT,C;0/P7%=3::1IU@H%K9018[J@S^=6\/*4E*<MNQ/MG:T(6]?
M\E_F>&V?@[Q+KA1WANGCDY+S/Y:CZKD']*ZK3?A3=&%([V^B@C5MZK;KELGK
MDL/8=*]5HK14*2UM?U)<ZLOBE]VG_!_$J:99?V=IT%GYSS>2@02/C)QZXJW1
M16HDK*P4444#"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BL^]US3-.4FZO8(\=5+C/Y5R&K_`!<\.Z<Q2&1KJ3L$X!_&DY*.[!:['"VO
M_)3_`!!^/_H5=.3@9->>#5[V[\07VJ:3IUPTUX3S(I"`$Y&#4A@\17VIQVEU
M>BU:52^Q1G@8SC\ZY8U%!R;ZO_(J-.3BD]+)&[<W=O:^*TN)ID2(6Q7<3WR>
M*9=>-M,AD\J$M-)T`09S5#_A%='LE+:IJ+3,.2))`/P`J"231GO]/ATJ#F*;
M+$(<8P>YJ)2=+FFMV:JGSV3$NM7UC6Y8C::1(GD/O5I05P?7GK4>HZ7XA;3Y
MKO4;[RXT`/EQD;N2!U''>MF;4=?N;B2.SL4AB#$*[CGZU0U/2-2&FRW6I7[R
MB/!\M<`'D"DY<T7)7>GH7&"35[?F(F@>';&..74+LSR;`Q623YN1GD"I9=;T
MB.VEATW3FDW(5WK'MQD=22*V8-`T^0I=R0[Y)(T)W'_9%6[FUMX-.N%CB1`8
MFZ#VITXS]FI:+0B52">MV<]9_P!MG1[*WL#$D?EY,I.3G<>/2K$/AN\G;S+[
M499&/7!Q_*M'PXH&@68!R`I_]"-:U3AJ*G33D]#.=23DU:R_,X151/#-PR(J
MM#>E5/7TYYKH]"_U^K?]?LG\S7.#_D5[_P#Z_P`_TKH]"_U^K?\`7[)_,UR4
M5:O'YG35^!_UV-BL*Q_Y'#5/^N,?\A6[6%8_\CAJG_7&/^0KTL1]GU1S4]GZ
M&[6%<_\`([:?_P!>TG]:W:PKG_D=M/\`^O:3^M+%_P`)CI;OT9NUCZ]UT_\`
MZ_(O_0A6Q6/KW73_`/K\B_\`0A58G^#+T%2^-$/AO2+36_&.H6E\A>#[0'*A
MB,X![CGO7KUEH&DZ<JBUL($(&`VW)Z8ZGFO,/`O_`"/NH_\`77^AKV&IP;]Q
M^K%6A%SNT(`%&``!Z"EHHKJ)"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HKGO&NOS>&O#4^IP(KM$1\K=\G%>4W&O>.]<.3/':0
M2*"NT]CR./QK.=6,'9[A^'J>V7FI65@A:[NHH0.N]P*Y/5?BIX;TQ3BY\]P?
MNI_C7EEYX7N/L$UUJVL32R1QLP"M@9QP.<]\46;>'=+L[.2XLP;R6(.<*6SD
MD9_2L9XAQDHM6OW-(TKJ][^AU%U\8-1O9&CT?2'<'[KLI;'UQ6"-2\:>)[;S
MFU);>/S"A53TQ]/K3QKM[.I32=(V@'AW''Y?2HM*L+Z]T.)+>\,`^T2&;9WS
MCC^=8U*TN>*3O?Y=#14HI7:MZZC3X4M8F$^L:K+*Q&6#R;5/K4.GR:/ISZG)
M!;K/;1M$J!1NRQW=ZU8/"%H&WW,LL['GYFJ;2+:&'5M2M4C40QB(JN.A^:BK
M&5E96U12E&SUN4/[9UBZ`&G:6(4/&9!_^JJHL;^ZUU8=1N#YLT#[-G&P96NU
M``Z`#Z5A7/\`R.5G_P!>[_S6JQ%-\GO.^J_,F%17]U6$MO"5A%M:<O.X.<NV
M:AUBSM[2\TO[/$L>;C!V]^#72U@^(?\`C]TK_KY_H:NO3C&E*R)IU)2FKLWS
MU/UK(\2_\B]=_1?_`$(5KG[Q^M9/B,I_8-T')QA<X_WA6DVE2U[&2DHR3?<O
MVQQ9V_KY2_R%,OA_Q+[HGKY3?R-26P'V6$@=8UZ_04R__P"0=<_]<F_D:FBF
MZ46^R_(CE;G>11\,_P#(N6?^Z?\`T(UK5D^&?^1<L_\`=/\`Z$:UJ,+_``8F
ME3XV<(/^17O_`/K_`#_2NCT+_7ZM_P!?LG\S7.#_`)%>_P#^O\_TKH]"_P!?
MJW_7[)_,UYM+^/'Y_F=57X'_`%V-BL*Q_P"1PU3_`*XQ_P`A6[6%8_\`(X:I
M_P!<8_Y"O2Q'V?5'-3V?H;M85S_R.VG_`/7M)_6MVL*Y_P"1VT__`*]I/ZTL
M7_"8Z6[]&;M8^O==/_Z_(O\`T(5KD@#).!7/:SJ-G/<:?!%<QO*+N,[58$_>
M%5B6E1EZ"I)N:-/P+_R/NH_]=?Z&O8:\:^'LHN/&E[.JL$DDRNX8SUKV6HP>
ML'ZL=7204445UF84444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`<-\6_P#DGM__`,!_]"%>>FVUZ\CB6WN4M[411A"H^8C:*]"^+?\`
MR3V__P"`_P#H0KGK#_D&VO\`UQ3_`-!%<M6"G62?9_F5"5HO2^OZ(P+KPXHL
MYKB^N'NGCC+DL<9P.E7])M;6?2;*=K9"?*P">2!D\5=U/_D$WG_7!_\`T$U!
MX?\`^1?L?^N7]36,J$(UX*.FX6?(W%V_KL7TV*,*`,=L5C>$_P#D#2?]?,G]
M*VR`>HK$\+LSZ0YX!^TR=OI55N95:=]=7^1,7-0E?78W*Q]-_P"1@U;_`'8O
M_9JULL.H_*LK3E8:]JCD$*RQ8/K]ZKKS3Y5YH*=2+NNMC7K!N?\`D<K/_KW?
M^:UO5@W/_(Y6?_7N_P#-:K%?P_FOS+I[OT-ZL'Q#_P`?NE?]?/\`0UO5A:\R
M?;-,R"?](X_(T8IVI,5.5IHW&)+$+US63XD&/#MW]%_]"%:Y&"<>M9/B7_D7
MKOZ+_P"A"FX_N[OL13C^\3>YHVO_`!YV_P#UR7^0IE__`,@ZY_ZY-_(T^U_X
M\[?_`*Y+_(4R_P#^0=<_]<F_D:='^#'T7Y%/XBCX9_Y%RS_W3_Z$:UJR?#/_
M`"+EG_NG_P!"-:U3A?X,1U/C9P@_Y%>__P"O\_TKH]"_U^K?]?LG\S7.#_D5
M[_\`Z_S_`$JQ=:A>:8]\EL\4;S7LAS(,G!)Z5YD'RUHOU_,ZYJ\6OZZ'9US4
M=];67BC59[B54C$,8W$^PJE;Z%XGUI@GEWTJ-SDKLC_/FNBTOX6:LR.MQ+;6
M:O@'(\XMW]1BO1J*K4MRQM9IZG*ITHW]Z_IJ9<WC&VQ_H=K-<'.,@;167%JE
MQ?Z^EPX2&5;:1(D4[FR5../K7J=C\+M#MT`NGN+HYRRNXVGVQCI746&B:9ID
M82SLH8E`Q\J^V*N5"516J2T\A>U:_APMYM_HO\SPVU\*>)M<)9H+R5>,-,?*
M4_CCD5TVE_":]CFBEN+Z&``AB(HR7!]FSU]\5ZT``,`8I:M4*:Z7]1.=62LY
M6]-/^#^)S>A>"M-T"Y^U027$MP1@O*X./7&`*Z2BBM;);$J*04444#"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@#AOBW_P`D]O\`
M_@/_`*$*YZP_Y!MK_P!<4_\`0170_%O_`))[?_\``?\`T(5SUA_R#;7_`*XI
M_P"@BL)?QUZ/\P7POU_1#-3_`.03>?\`7!__`$$U!X?_`.1?L?\`KE_4U/J?
M_()O/^N#_P#H)J#P_P#\B_8_]<OZFLZG^\0]&6OX;]32KSJPU*\COK?3HM63
M3;>1;B9Y&1&RP90!\WU->BUY_H^@KJFJ07%Y80W.GQQW$;&558!RZ$<'G.,\
MBG5M[6G?S_((_!+Y&SH_B5CX>^VZH1(_VI[:%[:(G[7AB%9%YSNP?;@GI56S
M\1VD4_B'4)[>ZB2T6(S021@2+][MG'ZU7F\.:HVE6]FT,DZ:7J!>V47/EO/;
MD$`!P0590V.2/N^]95[:I#HOC"06%U:%K:(8NKCS9&Y;J=S?SJL0DTK]U^9*
M5TTSLK'Q):7NHK8I%>P22*7@:YMV1)U`!)0GKP17*:+?SOJ/AE[B[F:2=;A"
M6^<R89L!B>0,#K[5N01:SJWB'3KS4]*CTZ/33,=XN5E\XN@4;<8('4G/H*P]
M/TF^MM:\+03VVV2U-Q),-ZG:I+8Z'_:'3UI5HQ4;7,XKE;4-SJXO$UG=7[6T
M%O>RQ++Y)ND@)AWYQC=]>"1Q65K.M13:KI,1M+R%#=A4FFA*(YP<8SSS[@58
MT*'5-&B32&TIIH8[B0K>B9`AC9RV2,[MPW8QC\:YF\T_6#?:,=3MKQ[Q-15Y
M9WO`T+*&)_=QAL`8_P!D'CO16C[DN8=+FC.]KG3:1XNDU#4K^&YTV[MX89<"
M1X-HA41ASYIW'!Z]/453UGQ=87NER6ZVVH1)<A1;W$]JR13'(8;6/J`2*GET
MW46O_$>GM9E;350S1WHD7;'F'9@KG=G(';H:S-;CU>]\-V=E<Z4;5+)HGFN#
M.C*VS@!`I)Y..H&!FJ<HNG\BJ<TYI+<W](\4VM_>KID%G?F6%C!++Y&8D*KG
M+.#@`XX[^PK:O_\`D'7/_7)OY&LGPK8W-C9WWVB/9Y]X\\?S`[D95P>.G3O6
MM?\`_(.N?^N3?R-.G;V2MV&_B*/AG_D7+/\`W3_Z$:UJR?#/_(N6?^Z?_0C6
MM487^#$=3XV<(/\`D5[_`/Z_S_2O<M&T+2[:VCN8K*%9IE$DC[>68]37AH_Y
M%>__`.O\_P!*^@]-_P"09:_]<E_E7-@W^\?S_,UQ$5)*ZZ_Y%D*%&``/I2T4
M5Z1@%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110!PWQ;_`.2>W_\`P'_T(5SUA_R#;7_KBG_H(KH?BW_R
M3V__`.`_^A"N>L/^0;:_]<4_]!%82_CKT?Y@OA?K^B&:G_R";S_K@_\`Z":@
M\/\`_(OV/_7+^IJ?4_\`D$WG_7!__034'A__`)%^Q_ZY?U-9U/\`>(>C+7\-
M^II5A^$_^0-)_P!?,G]*W*P_"?\`R!I/^OF3^E%?^+3]7^01^"7R-RL&"V@O
M-6UJWNHEE@D2)71AD,/FXK=)Q[FLG3F)UW55..!%T'^]1B7?E2[HB,K\R78U
M0">3^58=S_R.5G_U[O\`S6MZL&Y_Y'*S_P"O=_YK3Q"M3^:_,=&*39O5@^(?
M^/W2O^OG^AK>K!\0_P#'[I7_`%\_T-5B?X4BZ/QHWS]X_6LGQ%A-"NGVJ2`O
MWAD?>%:Q^\?K61XE_P"1>N_HO_H0IS2=+7M^AFHQE))KJ7[?=]EA(QS&O'X"
MFWK9L+D$$$Q-_(U):_\`'G;_`/7)?Y"F7_\`R#KG_KDW\C44HM4HV?1$.#4_
M=?ZE+PT"OAZS!&"%/'_`C6K61X=(/AVS9VP=IY)]S4EUK=A9-MFNX]WIWJ,/
M/EHQYBJCGSN\;^ARX_Y%>_\`^O\`/]*^@]-_Y!EK_P!<E_E7SU\[>')DA42B
M>]+@@\`<=<U]":60VE6I4@@Q+@CZ5A@I)U';S_,Z*LDUH6Z***]0P"BBB@`I
M*6DH`***,T`%%%%`"T4F:6@`HHHH`*2EI*`"BEHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`X;XM_\`)/;_`/X#_P"A"N>L/^0;:_\`7%/_`$$5T/Q;_P"2
M>W__``'_`-"%<]8?\@VU_P"N*?\`H(K"7\=>C_,%\+]?T0S4_P#D$WG_`%P?
M_P!!-0>'_P#D7['_`*Y?U-3ZG_R";S_K@_\`Z":@\/\`_(OV/_7+^IK.I_O$
M/1EK^&_4TJPO"N1HSX'6YD_I6V22<#\ZQO"SL^D2%O\`GXD'\JBN^:M32[O\
MB(MRA)1^\V@,?7UK(TW_`)&#5O\`=B_]FK8K'TW_`)&#5O\`=B_]FK2NDE%+
MNBJ:2BTNQL5@W/\`R.5G_P!>[_S6MZN<OKJ"#Q9;S22JL<=N^\YSCE:>*?[O
MYK\QTMSHZP?$/_'[I7_7S_0TVZ\7:?%Q`)+ECT\M>/UK'GUFXU74;7S+98(H
M)/,!W;F(QCH/K4XBK%P<4[LTITY1?,]$=PQ`)R<5A>)[VU&B7$)G3S'VA5!R
M2=PK(:P\0:Y/*UJM_<)O("PCRQC\2.U;^G_";5)'5[E[6!3U))D<?@1C]::=
M2<.51MZF:G1@[N5_34H3>*(;-$M8[:::9(E!P/E^Z#UK*N?$6JWT31QQ10(P
MVL`"Y((QZ5ZE:?##2E?S;^YN+N7&.&,8QC'0'%=-I_AW2-+`^QZ?;Q,/XA&-
MQ_&G"A-0492V["]MK>,/O?Z(\1MO#&NZE!:VUK;7ODQQ[6);9'G).>N>_I70
M:7\(KUN;V>VMN>/*7S&_4"O8>E%7##4H*R5_43J59;RMZ:?\$XVR^&NB6R()
MS<7.T[BLDAV$^Z]*ZVVMH;2VCM[>-8X8U"HBC``%2T5JDEL9J$4^;J%%%%,L
M****`$HH-%`"56NK^UL@#/,L8/3)IM_?1:=:23S,`JC\Z\EU34;O7M2=D#L.
M=B#T%<N(Q'LE9;G=@\$\0VV[11Z='XFTF6XC@2]B:1VVJH/)-:LCK'$TC?=4
M%C]!7S=)J$]IK"2X*M;OD*>HKW^WNUO?#GGJV[=;$D^^VKH574W0\;@U0LXN
MZ,#1/'L&O^++K2+2(^5;IEI#W.<<5VHKYP\&^)M/\+^-=5O-1:01L"HV+N).
M:])L/C'X>N[Y+=S-&'.U6,9[^M=+1YD9WW/1J*QM:\3Z9H.EKJ%[/B!QE-O)
M;Z#O7#GXU:27)2UG,6?O^6:5F6Y)'H.MZO;Z'I,^H7/^JB&3BL;P5XK_`.$M
ML+F\6+RXTEV(.^,=ZYSQ;XGL/%/PLU"^L#)Y>0I#KM.0PS7'?#SX@Z1X4\.3
M6]YYK3O*&"JF1C%-+0ERLSWP4"N0\,_$70_$T_V:UE=+CKLD7;GZ9KI+W4K;
M3TW3/UZ`<DU+T*3N7**P?^$D4G(M9]OKL-7KG5$MK2.<QR-YGW5"DF@9H45@
M?\)(%.9;29$_O%#6M;WL%S;>?&X\OU-`%BLV[U/R-0BM0N2_4U!+XCM5=EB2
M63;U*H2*RY;^*^UZV>-7&!R&7%`'6THI*6@`HHHH`****`.&^+?_`"3V_P#^
M`_\`H0KGK#_D&VO_`%Q3_P!!%=#\6_\`DGM__P`!_P#0A7$3^(+72+&R2979
MGMU*A>Y"CC\:PE_'7^%_F"^%^OZ(U-3YTJ\_ZX/_`.@FJV@AAH%BO3]US^9K
M.U7Q1I0TZY078,C1%0J@DY(P.1Q6,_C'^R--L+:&))F-NKEBWJS#^E<U2:=>
M+Z:E1A*<&ME_7X'>@8KGO#-Q#;Z)(TTJ1C[3)RQQZ5R]MK7B7Q!/Y4=M=10L
MQ&8H3Z\`-CZ<]*ZS3OAYKFHV-O;2V:6T<3L^^Z?);=CLI/IWJZD:DYP<([?+
MH-2I0BXN7W:BW/BO2X,B.1IW'\,:G/ZUC0ZU<!M2OX(5C>9HD196&<?-DXKO
M=.^$L"'=?WQ8'@QP+M'Y\&NKL/!>@Z>J"/3XY"@P&F'F'_Q[//O6DJ-2I;GE
M;T%[6*TA&_KH>)B+Q%K4GEHUU(W]RWC*#'U.!6_I/PQURXW33+#;M(NUOM4A
M9\<>F17M21I&NU$55'91@4ZK^KTW\6OJ)U*KZV]%_F>::1\+;59&74Y9I!&V
M4V8C5N?]DUV6G^%=$TP[K;3H-_\`ST=`S?F>:V:*TIQY%9&*I+[;<GYZB``#
M``'TI:**HU"BBB@`HHHH`****`"BBB@`HHHH`0T'I1WHH`\?^(?B2Z75VT_R
MR(HSQZ-[UH^`KO2HK,W%[,BW;L1M;L.U:_B_P1_;=P+VW?$ZC&T]#7F.JZ%J
MUDQA:SFSGJ!P:\ZI&4*O-:Y]!0=*MAE34K,O^.=+@_X2.66UD4B8[SMYYKT?
MPA:WEEX*:*\^]Y;E0>N"#BN4\">%+B[E2\U&-A%&?D5QR:]2ND`TZ=$7I$P`
M'TK>A"7,YLX\?6CR*BG>QX%\/]&L=9^(.H)?PB5(OG5#TSGO6S\9M"TW3K.S
MGL;2*WD'&8U"YYH^&.G7EMX_U26:WD2-D^5F'!^:M?XTV5S>:7:BW@>4@\A!
MD]:[K^\>+]DYSQK8:A?_``_\.W<4;S1P*ID4<X&T<TEA\0]"LM/AM[GP<S[%
MP[[%`/OTKL3JNK^'?`&CR6.EF\DV!98F4_*-H]*Y+6/&U[JVESV"^%E6:=2F
M0C97/<<]:!-6-O6=5T35OA1J4^C0+;H6!>$`?*=P]*A^#WA[2M1\/7-Q>6,-
MQ()0`94#8&*R]'\'ZQ9?#+5A):R_:+G:$@"_-PV<XJCX/\4>(O!FG2V`T!Y`
M[[LNK`],4=-!];L9XRL(/#?Q-M&TL"%7DC&Q.,9(S7KI07OBC;,-R1CY5/3K
M7F6B>'=>\:^-%UO6;-[6W0AAN!YQTQGZ5ZIJEG<VNIQZA:1F3'WD'>ID7!&\
M(HPNW8,>F*H:GJ5OIRH'C\QR?E056'B--H#VDX?N`M5=6BG>ZM=1C@9U`!*8
MY'%26+<ZM/-:N'TU_+9>I(XK-M9G3P_<!"5!?@>G-:TNLRW,!BM[&4NPP<KP
M*JZ=ITUQI%U!(A1V8D9]<T@-K2;."'3H=L:EBO)QUK+U"-$\16VU0,CG`HL-
M8ET^W6UO+67,8P&5>M1&>34M;@FCMY5C4<EEH`ZKO2TGXTM,`HHHH`****`.
M;\=Z%<>(_"5YIUHRB=U!3=T)!SC]*\>3X=^*=9U;SOLWDP*54&X<;=H50<`'
M(Y!KZ%HK.5*$Y<TD1*,GL[(\BLO@E;N@&H7Y"DY:.`8!R<XSC-=AI7PV\+Z0
MP>+34ED"@;IB7Z9QP<@=376T5HDH_"K`Z:EK/7U_JQ%!;06T8C@ACB0#`5%"
M@?E4M%%!226B"BBB@84444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M"=Z*6B@!*C>"*0_/&K'U*YJ6BE8=VMAB1K&NU%"CT`Q39G$4$DA&0JEB/H*E
MIDT8EB>-NCJ5/XTQ/4Y^TUZU$*W4UHL*2\(T:[F;\!4C>)-'GM7G?<\<;A#N
MA).3[4^V\-6MJ8-DTQ$#;D!;C-5KKPG"]JT-O/)%OE#LV>>#VIDZEPZ]I89(
M,G#*&QY?`'OZ5'_:VA>7),%A_=-AB(QD4T>%K02AQ+/@KM9=W#_6HH_!FF1N
M[+YGSQM&PSP<]_K0&I:3Q'ILD,;1NSB3(0!#SBH(==T>>-7EB16/4F+(!],U
M-:>&K*T2%8]_[K<%.>N1BHO^$4LEL&M59RID\SYCWH#4N6VLV$J2>3N58B`P
M\LC&>E,?Q#IR.RF5CM.&VKD#_P"M5.QT"ZM8KWS+I97N%"*6S\H'`IMOX1MH
M[18Y)I/,,>R5D.!)]:-!ZFG%J%A.(S&%8R*SK\O4#K54>)-/$6Z02*-YCP(R
M>E/M/#UM9W*3)+*1&C(J,WR@'K44GA>VD'_'S<+ERWRM^GTH#4MW.K6%DZ+*
M=K.AD!5,_*.]5QXETI;<3B4A&;:/EZFK$^BVUPP+[L"!H,`\;3UK.D\&:=)!
M##OF"Q-N&#U^M`:DG_"0VGVRYBN(55(1G?C=FK46N::UXMK')B9E#`;<<57/
MA6R::>4O*3,,,,\`>U%MX7L;6_\`MH,CRX"_,<C`Z4`KF[0*2E'2D,6BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`3%&*6DH`,&C%%%`!BC!HI:`$Q1BEHH`3!HP
7:6B@!,48-+10`F#1BBEH`3%+110!_]DH
`






















#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Only execute when a execute key is set" />
      <int nm="MAJORVERSION" vl="4" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="11/29/2024 2:03:57 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End