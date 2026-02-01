#Version 8
#BeginDescription
/// Diese TSL fügt einen Merk Stützenfuß ein
/// This tsl creates a Merk Post Shoe

/// Version 2.1  04.02.2010   th@hsbCAD.de
/// bugfix baseplate display
/// new script definition
/// new properties to influence the style
/// location dependent from insertion grip



#End
#Type E
#NumBeamsReq 1
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 2
#MinorVersion 1
#KeyWords 
#BeginContents
/// <summary Lang=de>
/// Diese TSL fügt einen Merk Stützenfuß ein
/// </summary>
/// <summary Lang=de>
/// This tsl creates a Merk Post Shoe
/// </summary>

/// History
/// Version 2.1  04.02.2010   th@hsbCAD.de
/// bugfix baseplate display
/// Version 2.0  02.02.2010   th@hsbCAD.de
/// new definition
/// new properties to influence the style
/// location dependent from insertion grip
/// Version 1.5  18.11.2009   th@hsbCAD.de
/// Content Standardisierung
/// Version 1.4   31.10.2008   th@hsb-systems.de
/// DE   Layer oder Gruppenzuordnung ergänzt
/// EN   Layer or Group assignment added
/// Version 1.3   16.10.2008   th@hsb-systems.de
/// DE   Dialog ergänzt
/// EN   Dialog appended
/// Version 1.2   31.01.2006   th@hsb-systems.de
/// DE
///    Sprachunabhängigkeit
/// EN
///    Language independecy added
/// Version 1.1   07.05.2004   th@hsb-systems.de
///    Visualisierung für einheitenunabhängig verbessert
/// Erzeugt den Merk-Stützenfuß K1/K2, sowie die Bohrung in der Stütze.
/// Die Sockelhöhe und Stützenfußhöhe ist variabel.
/// Die vom Hersteller angegebenen zulässigen Grenzwerte sind zu beachten.
/// 
/// Version: 1.1
/// Datum: 12.10.02
/// Autor: Thorsten Huck



// basics and prop
	U(1,"mm");
	double dEps = U(0.01);
	
	PropDouble dHeight(0,U(200),T("Height"));
	PropDouble dTotalHeight(1,U(300),T("Total Height"));
	PropDouble dDiameter(2,U(40),T("Diameter"));
	PropDouble dExtraDepth(3,U(0),T("Extra Drilling Depth"));
	PropDouble dDepthSink(4,U(20),T("Depth Housing"));
	PropDouble dDiameterPressurePlate(5,U(75),T("|Diameter|") + " " + T("|Pressure Plate|"));
	PropDouble dWidthBase(6,U(100),T("|Width|") + " " + T("|Baseplate|"));
	PropDouble dLengthBase(7,U(180),T("|Length|") + " " + T("|Baseplate|"));
	PropInt nColor(0,253,T("|Color|"));
	PropString sLayerGroup(0, "Z", T("|Group, Layername or Zone Character|"));	

// on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		// show the dialog if no catalog in use
		if (_kExecuteKey == "")
			showDialog();			
		else
			// set properties from catalog
			setPropValuesFromCatalog(_kExecuteKey);	
		
		// selection
		PrEntity ssE(T("|Select post(s)|") , Beam());
		Beam bm[0];
		if (ssE.go())
			bm= ssE.beamSet(); 

	
		_Pt0 = getPoint(T("|Select insertion point|"));
		

		if (bm.length()<1)
			eraseInstance();

		// declare arrays for tsl cloning
		TslInst tslNew;
		Vector3d vUcsX = _XW;
		Vector3d vUcsY = _YW;
		Beam bmAr[1];
		Entity entAr[0];
		Point3d ptAr[1];
		int nArProps[0];
		double dArProps[0];
		String sArProps[0];
		Map mapTsl;
		String sScriptname = scriptName();

		for(int i=0;i<bm.length();i++)
		{
			bmAr[0] = bm[i];
			ptAr[0] = Line(bm[i].ptCen(),bm[i].vecX()).closestPointTo(_Pt0);
		// create tsl
			tslNew.dbCreate(sScriptname, vUcsX,vUcsY,bmAr, entAr, ptAr, 
				nArProps, dArProps, sArProps,_kModelSpace, mapTsl); // create new instance
			
		}
		return;
	}// end on insert_______________________________________________________________________________________________
	
// on creation
	if (_bOnDbCreated)
	{
		// set properties from catalog
		setPropValuesFromCatalog(T("|_LastInserted|"));
	
		if (!(-_X0).isCodirectionalTo(_ZW))
		{
			reportNotice("\n" + scriptName() + ": " + T("|The Tool may only be inserted at the bottom of a beam which is like a post|"))	;
			reportNotice("\n" + T("|Tool will be deleted.|"));
			eraseInstance();		
			return;
		}
	}				
	// totalHeight and Diameter must be given
	if (dTotalHeight<U(200) &&dDiameter<dEps)
	{
		reportNotice("\n" + scriptName() + ": " + T("|The Total Height and the Diameter must be greater than Zero|"))	;
		reportNotice("\n" + T("|Tool will be deleted.|"));
		eraseInstance();
		return;		
	}	

	if (dTotalHeight<dHeight)
	{
		reportNotice("\n" + scriptName() + ": " + T("|The Total Height must be bigger then Height|"))	;
		reportNotice("\n" + T("|Tool will be deleted.|"));
		eraseInstance();
		return;			
		
	}

	
// the beam
	Beam bm = _Beam[0];
	_X0.visualize(_Pt0,1);
	_Y0.visualize(_Pt0,3);
	_Z0.visualize(_Pt0,150);
	
	
// set the cut
	Point3d ptRef = _Pt0-_X0*dHeight;
	bm.addTool(Cut(ptRef,_X0),1);	

// the drill
	Drill dr(_Pt0,_Pt0-_X0*(dTotalHeight+dExtraDepth),dDiameter/2);
	bm.addTool(dr);

// the sink drill
	if (dDepthSink>0 && dDiameterPressurePlate>0)
	{
		Drill dr(ptRef,ptRef-_X0*(dDepthSink),dDiameterPressurePlate/2);
		bm.addTool(dr);
	}
	
// the display
	Display dp(nColor);


// the bodies
	Body bd, bd1;
	ptRef.transformBy(-_X0*(dExtraDepth-U(8)));
	// main cylinder
	bd = Body (_Pt0,_Pt0-_X0*(dTotalHeight+dExtraDepth),dDiameter/2);
	// basePlate
	if (dWidthBase>0 &&dLengthBase>0)
		bd.addPart(Body(_Pt0,_X0,_Y0,_Z0,U(8), dWidthBase, dLengthBase,-1,0,0));	

// draw the main part
	dp.draw(bd);	
	
	// pressure plate
	if (dDiameterPressurePlate>0)
	{
		bd1 = Body (ptRef,ptRef-_X0*(U(8)),dDiameterPressurePlate/2);
	
		// screwhead
		PLine plHex(_X0);
		Point3d ptHex = ptRef+_Y0*.8*dDiameter-_X0*U(8);
		ptHex.transformBy(_X0*(U(8)));
		CoordSys csHex;
		csHex.setToRotation(60,_X0,ptRef);
		plHex.addVertex(ptHex);
		for (int i=0;i<6;i++)
		{
			ptHex.transformBy(csHex);
			plHex.addVertex(ptHex);
		}
		plHex.close();
		bd1.addPart(Body(plHex,_X0*dDiameter/2,1));
		dp.draw(bd1);
	}

	


// assignment
	if (sLayerGroup != "")
	{
		Entity ent = _Beam[0]; // assign your entity here
		// find group name
		int bFound;
		Group grAll[] = Group().allExistingGroups();
		for (int i=0;i<grAll.length();i++)
			if (grAll[i].name() == sLayerGroup)
			{
				bFound=true;
				grAll[i].addEntity(_ThisInst,TRUE,0,'T');
				break;	
			}
	
		// no valid groupname found, assuming it is a layername
		if (!bFound)
		{
			String sLayer = sLayerGroup;
			sLayer.makeUpper();
	
		// group assignment via entity
			String sGroupChars[] = {	'T', 'I','J','Z','C'};
			int nFindChar = sGroupChars.find(sLayer);
			if (sLayer.length()==1 && nFindChar >-1)// if you want to allow manual layer assignments replace <1> with <_bOnDbCreated>)
			{
				//overwrite the automatic layer assignment 
				assignToLayer(ent.layerName());
				Group grEnt[0];
				grEnt = ent.groups();
				for (int g = 0; g < grEnt.length(); g++)	
					grEnt[g].addEntity(_ThisInst, false, ent.myZoneIndex(),sLayer.getAt(0));
			}
		// create a new layer and/or assign it to it
			else
				assignToLayer(sLayerGroup);
		}
	}

/*
model ("118 " + ArtikelList[i]);
dxaout("HSBDESC2","Merk Stützenfuß K1-A " + ArtikelList[i]);//Bezeichnung
material("Baustahl, verzinkt");
*/

#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`:P!K``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`.C!(`#`2(``A$!`Q$!_\0`
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
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HI"0HR2`*HW.K6=KD/*-P[#KB@"_160/$5BR,RR9VC/2JL_B0`!;>W:61O
MNA03GUH`Z&BL&/4-4FW$6$R<=#@8_.HXUUN_DQ)&MO#GJYY(^G_ZJ`-YI8T.
M&=0>N":A>^MHAEY`HZ9/2L@>&W?=]JU"9TSE0H`Q^)JTGAZR$7ER&649_C?_
M``Q0`2>(+*-R@<%QV_\`KU7/BB!9O+,+`^N>*T8-*L;:-4BM(0%Q@[`3QW^M
M66AB=2K1H5(P05&"*`*EIK%E>?ZJ4>O/&:O!E8`@@@],5D77AVPG9GC4P2,1
MDQ]#CMCI51M)U:W.ZWO$D.._RD\_0T`=)17.1:Y<6:I'J-NR2'U_QK2@UNPG
MB#K.H!]>*`-&BJR7]M(VU)034RNK`%6!'L:`'T444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%4=4U%-+LS<R
MJ3&I^;'4#UH`O45Q[?$/15"YF`)['C'USTJ3_A-K.=&-F1(0`<=?UH`ZRFEE
M`R2`!7-`:QJ3J"5MXB.K-S@CT]?RJ4>'[T(%.J/P,<)_]>@#3N=6M+7AY1GK
MCV]:I-XELRI:-MR@>X[XIUMX:L(&5Y?,N67IYS9`_#I6E'96L3%H[>)&(P2J
M`'%`&+_PD3W#.EG9R2.@^90.G'&#TH:]UJ)B[V3M$,<#!/7VKH%55^ZH'T%.
MH`YU-=OI&9%TV5B,<A3CFGI?:K*K%;&4`$@9PO\`/M6_10!S2VNN:AN$[K:)
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
M.I7A&^9`@.1&"0HJI]AO?^>L8'H14.LNA7LV=KJ'BR:/?$J1VAQD-*=QP>AP
M._YUR]]XCGO"T<3RRE^/G8GMSP./6H5TU&"^<Q?'8<"K<4,<*!8T"@>@J)5N
MQ2I]S%33]2)>3SMI?).7.<U-`/$%ODQ7[1YZA7*Y_*M>BLO:/<KE12DDUFZP
M+JY\P+C&9#C/TJ`Z3+*X::YX[JHP!ZX]*U**;JR8**11CTJ%`,O(V.V>#5M(
M8XQA4`_"GT5%V.P``#`XHHHI#"BBB@`J&X?R6AF[1R`D8SD=#BIJKWR![&8'
M.-N>*J+LQ/8]/T^1);&*2,@HPR".XJW6+X89V\/VF_C$:@#VP*VJ[T<P4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!7.>,Y6BT+RP`1-*J-GL.6
MX_%171UP/C^X874$6!MCA+CUR3@_^@BLZKM!E07O'&V.3+.3Z]*O53TY"+<N
M>KL3^':KE<,MSI6P4445(PHHHH`****`"BBB@`HHHH`****`,RY@%SJL4)4D
M.!G'8#DFN@A_U*8;<,?>QC/O7/W<_P!EU*.8,`47N,Y'0UMV#;[&(XQQC\N*
MV^RB.I8HHHJ!A1110`4444`%%%%`!1110`4444`%%%%`!1110`56U%2UA*!Z
M9_6K-170#6DH)`^4\FFMQ,[;P?="Y\/PC.6A_=,<`9QT_0@?A70US?@I7B\.
MP1/@,!N(],DUTE=\=M3G>X4444Q!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`5P/Q"@VR07&_P#UD+)C'3:<Y_\`'OTKOJXCXA1NUI9L%.P;U)QP"=N!
M^A_*LJWP%P^(XNP_X\H_\]ZLU5T__CU`'9C^'-6JX7NSH6P4444AA1110`44
M44`%%%%`!1110`4444`8^N(!&DFWVS6[IC!M/BQCOT^M8FM2;#:AN(]^2?\`
M/XUNZ?&([*-1GUYK5?"1U+-%%%2,****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"H;O_CSFQ_=-35#=_\`'G-_NFA".\\*2&7P_;R,,,R@D>E;E<]X-?S/
M#5J=N,+@_4<'^5=#7H+8Y@HHHI@%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!7,>-I8$T'RY1F5Y!Y0]".I^F,C\173UYQXOU'[;J+P(<Q6P*#W;^(]/
M48_#WK*M*T2X*[.7TTYMV_WC5VJ.E_ZA^,?.:O5Q2W9T1V"BBBI&%%%%`!11
M10`4444`%%%%`!1110!D>(.+)>.C?E6UH[;])M_9=OY<5B>(.;-!_MUK:$K+
MIBYSM+';SV__`%YJ^B)ZFE1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%5[UL0"(,%>5A&I/0$FK%4]0)7[.R\$2`CZU4=]1,].T:T%EID40&T`=
M/2M"JMC(LUA;RKD*\:L,]>15JN\Y@HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"O&KD-"LBNI5ER&4C!![BO9:\K\71)%K%^BKA20Q[\E03^I-<
M^(5[,UI/<Q--39`YR""Y(Q5VJM@`+10!CDYJU7++<VCL%%%%2,****`"BBB@
M`HHHH`****`"BBB@#'\08^RQCG.[-;NE,&TRWP`,(`0!W[UCZT56UC++G]X.
MU:&B`QV[Q$DA6X_S_GK6D=8DO<TZ***0!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`50OV9KFVA52Q8]!W.1BK]5KH^3-;70*@PR`Y89P,\U4=Q/8]4M
M;=;>TA@0DK&@0$]<`8J>JMA-]HL8I<$97OUJU7><P4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!7!^/("+RWG)&UX2@'?*G/_LPKO*XSQ[C;89Z
M?O/_`&6LJWP%T_B.#TX_N7&>`Q_"KM4;`GS;@'^\/ZU>KBEN="V"BBBI&%%%
M%`!1110`4444`%%%%`!1110!BZVV9H$!Z`L1_G\:V-)`?SIE(*L<`"N?UA67
M42W9D&*Z'0XRFE1%EPS9)_D/T`K1;$/<T:***0PHHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`*K:B,V$N/;O[U9J>.U$MG<7#+N$)3"[L98MQ^'!_2J@K
MR2$W9';Z$K)I4*,Y<HJKN/?@5J51T@*--AV_W15ZN\Y@HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"N)\<V\GFVMQN<Q%2FW!VJ>N?J?_9:[:L+
MQ6BMX>N"5!*E"I(Z'<!D?@36=6-X,J#M)'EMGA;B9<\G!`_.KM9['RM20C`5
MN"2:T*X9'3$****D84444`%%%%`!1110`4444`%%%%`&+K:[=KD\,,8^E;VD
M[O[+MPYR0N/\*Q=<CWI".."3@]^E;&CL'TR(CW'ZUHM8W(ZEZBBBD,****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"K%N]PL<PAVE`H9PW3`(QQGKGC\35
M>JM^\D=L'B.&##G/;^M5!VDF*6QZ=I6!ID``(^4<&KU8GAO4$O\`2(RO$D?R
MN,Y^A^A_QK;KN3NKG,U8****8!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`5A>*W5/#UPK,`6*!03U.X'`_`'\JW:YWQC"TNAAU8`12J[9[CE>/Q85%3
MX&5'XD>7W2E[R$#J&K0K.C8S:GD#Y$'7]*T:X)=$=,0HHHJ1A1110`4444`%
M%%%`!1110`4444`4]1B$EMSC*Y.<>U7])39IL8'?)_6L_4IFMX8Y4"DJ^,-[
MC']:OZ/C^S8]N0N3C/UK5?`0_B+U%%%2,****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"JU^I:RDQU'-6:KW^X64FTX/'/XTUN(Z+P*LIDE(SY2Q`-SQNS
MQQ],UW%<UX/T\V.EF1R?,F"DK_=&.!]>:Z6NVFK1LS"3NPHHHJR0HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`*J7\#7.G7,"$!Y(F0$]`2,5;HI-7`\/
ML2/-G'?-7JE\06\=GXQNE7`$G.T9^4D9_P#K_C45>?-6D=<7=!1114#"BBB@
M`HHHH`****`"BBB@`HHHH`S=;"FR7<<?O%_&M;24\O3(!G/&?UK(UP,=.)4X
MPP-;6G?\>$([A:T7PD]2S1112`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"HKF010[SP%92<#/&X5+5>^4/92@]AGCVYIQW$]CTC1?^0=&0000""#G/
M`K2KGO!LK2>&[8OG=S@-UQGC]*Z&N]:HY@HHHI@%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110!Y%XND1O%4TT3?*)%5FQCD``CGW!J*K7CB)$UF]
M*J%`VG`&.2H)/\ZHPMOA1L8R*\^IN=,-B2BBBLRPHHHH`****`"BBB@`HHHH
M`****`*U\%^Q2[S@8X.,\]OUJSHO_(/4>A(JM>KNM'`Z\'IZ&IM!39IP.<AF
M)Z8K6/P$/<TZ***D84444`%%%%`!1110`4444`%%%%`!1110`4444`%2V]M)
M>7"6\0R\AVCV]_I456M.NX[&_CN96VH@;+8SC*D9_6G%7=A/;0Z3PJJK9NJ(
M47/`]!CC\<5TE<]X64FR>4C'F$/@]?\`/%=#7H',%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`>2>,HVCU:^621GRV[<>P(!`_`''X53M\
M"WC`SC:.M=!\0TWZC$,X_<+S_P`":N>ML?9HP#T&*X*BLWZG3!W)J***R+"B
MBB@`HHHH`****`"BBB@`HHHH`@NP#:R9[*:=H,JM;RQH241R5SV!Y`J&]N3"
M@10-S`\YZ55\-2,MS+#@X`Y/OG_Z]:0=TT3):IG2T444@"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`J&[P+27(R-IJ:JNHR!+-P?XL+CUIK<3/0?"ZA
M=#A42>9@<MZFMNLO0+8VFBVL+##*@##WQS6I7H',%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`<%\0H51K:X&=[QLA';"D$?\`H1KD+#/V
M-.?7'YUU/CU=^J1C_IV'_H35RFG.6MMI_@.*X:N[.B&R+E%%%8F@4444`%%%
M%`!1110`4444`%%%%`&9J:D2H_8KC\O_`-=,\.Q$7TLG8@_AS5R]A22(%L@J
M>Q[=Z/#L:BWDD7!#-@8]!5TU;F9,GLC:HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"JNH%4@28KN\IU?\C5JH+T`V4P(S\IXIIV8GL>G:=(9;"%
MVZE<\5;K&\,222Z'`\I)D(YR,5LUZ!S!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`'"^/(-MS;W&[[\3)MQTVG.?\`Q[]*XO3_`)4D4D9#
M=*ZSQM<"35!"LA(AA`*\X5CD_P`MM<GI[%XY">3OK@J?%(Z(;(N4445D:!11
M10`4444`%%%%`!1110`4444`073^7;/(#@J,Y':D\.OYFG[L8YR<4E^0MA/G
MIL(IOAM\VS*/NX!''X'^5:1^%DO<VZ***0!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`5+!"DSE)/N[&;\E)_I451W#%+>1E.&49!JH[B>QZ!X>!&EJ"
M,'<<UK5@^$9S<Z!%*P`9F;('8YK>KO.8****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`X#QMIKQ7HO5W&.X`!/HP&,?B`/R-<=IO"RJ2-P;G
M`KT'QS,RV]G``-CNSD]\J`!_Z$:\]M<_;9-A^3;R#ZYKAJI*32.B&R+]%%%8
MF@4444`%%%%`!1110`4444`%%%%`%/47"VQC/5^*K^'6:.81EN&3@`?C3]3S
MF+CCG^E1:8-MY:C/`X_2KIO5HF?0Z:BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`*@O6"6<I(R,8J>J.JR%+9%V[@[@'Z4X[B9W/@4G_`(1T1\;8
MY"%([C@_UKIZS](L8=/TV&"%<*!G)ZL?4^]:%=\5969SO<****8@HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`.#\=K*+VW8D^482$YXW`\\?BM<
M9IQ#)(X&"6P:]$\=6HDT'[4H7=;,#DD_=/!'Y[?RKSZPQ]E!`QR?YUQ5E9LW
MIO1%JBBBL#4****`"BBB@`HHHH`****`"BBB@"CJ2$Q(X_A.#QZU7T=T:]A.
M?F7*GZX_^M6A=!3:R;NFW]>U9-E$T=Q$"NT^;DYJZ6[)ELCK****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`J"98GN+59B0ADQP,Y..!^>*GJAJS,
MD4)0X;S!BJA\2%+8]<MQBVC'^R*EJ"U97M(64@J4!!!X(Q4]=YS!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`'+>.KGRO#K0!DW3N%P>N!
MSD?B!^=>>:>I2R0'KSG\Z[GXCH@T*"?'[Q)MJGT!!S_(5Q5K_P`>L1_V17'7
MW-Z6Q-1117.:A1110`4444`%%%%`!1110`4444`1L%DF6-R-B@R.#Z#M^=4$
M.^>&0Y),@.0.M32R%;YU!!WP%2#VX)_I3<^7IT4@/(/!QTK2EU(D;]%`Y&:*
M0PHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*SM8&;>(#KY@K1K-U$G[7
M;#MST^HJH[B>QZ+X4OC=:.D+G][;X0^Z_P`/Z<?A6_7*^#SF.Z7``78>@SW[
M_A755V4W>*9A-6844459(4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`')?$*%I?#!92!Y<JL?IR./SKA+7_CUB_W17HOC62./PQ=&1`XP/ESC'(`
M/X$@UYU:@BVC!.>*Y,1N;4B:BBBN8V"BBB@`HHHH`****`"BBB@`HHHH`R[T
M-!>+-U!YQZXZC_/K3PW^@8.2`0!^5&J=(OQ_I3+8/)9Q)NR3M`SVXJZ.[%/H
M=&GW%[<4M%%`@HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*SM15A=6S@
M97)4^W>M&L[6"1;Q8Z[QWJH[B>QZ9X<MQ!HD!V[6ES(><YST/Y8K7JGIJNNF
M6JRY\P1*&R<\XYJY7=%65CG>X4444Q!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`<YXS@2;PW=;W*A4)S[C!'\J\[MR3;1YZ[17JVL0K-IT@;HO
MS?C7DUF2;1,]1Q^M<N)6QM2ZEBBBBN4V"BBB@`HHHH`****`"BBB@`HHHH`J
M:BFZQE('*C</:FP)Y6G0OD'9CG'I3[\D6,J@@,PVC/O2LP73%0$#)XQZ]JTI
MD2-A'#HK#H1FEID"&.WC0]54`XI]`PHHHI`%%%%`!1110`4444`%%%%`!111
M0`4444`%4-3*GR(B/O-_G^=7ZS]17=/;9'`8_A51W$SU'19_M&C6DGS$^6%)
M;J2.#^HK1K)\.?\`(`M?^!?^A&M:NV+O%'.]PHHHJA!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`<EX\U-['15MXN&NB4)QGY>_X\C]:X.T7;:Q
M@>F:[;XA6^[2[:XW?ZMRFW'7<,Y_\=_6N)LSFTC^F*XZ][F]+8GHHHKG-0HH
MHH`****`"BBB@`HHHH`****`*E^C-`'7JAW>OZ5`O%Q#`QZ2`%?I6C6=IXWZ
MA$=V['))[G'/ZUI2TN3/H=%1112`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"J6IAA`CIP58<^E7:HZK)Y=H!C[S@4X[B9W?@Z[,^F/`V<PMQQP`?\`
MZX/YUTM96A68L-(AMP.0"6/J2>OO_ABM6NZ":BDSG;NPHHHJA!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`8?BR`W'AVZC"LWR%L+WQR/U`KS*S
M`%I&%Z8KUO50#IDP(XV\UY!IX(M0#V8X_.N7$+1,UI/H6Z***Y3<****`"BB
MB@`HHHH`****`"BBB@!DI(A?:P5MIP3V-4-`^9X^!N`8DGKUK1/0BJ>BQ!+M
MLD[Q'R,^Y_P_6M(;,F6Z-VBBBD`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%9U\S27D$"]!\QST-:-9UQ(%U2-3QE<_@*J.XF>N6\0@MXX0S.(U"[F.
M2<>OO4]0P3K/;Q3*"%D4,,]<$9J:N]',%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`9^LR"'1[J0IO"1EBN<9QVKR'36W6I&,;6(Z_C7KF
MN+NT&_'I`Y_0UY%IH`@?']XUS8AFU(NT445R&P4444`%%%%`!1110`4444`%
M%%%`"54T^9'UF4(@0!%7`.<D#!/\ZMDX!)[5G>'AYM[<W(^ZQX]OK6L-F3+H
M=%1114@%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!6??G_28`.O_`->M
M"J.I(WE),@YC;)^E5'<3/1/"]Q)/HX$G/E.44]\8!_KBMRN?\(QR1Z(&E`#.
MY?&>@P/\*Z"NV%^57.>6X44450@HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`,_6_P#D`ZA_U[2?^@FO(--&V%QG^*O:IHEFA>)P"CJ5((SD&O%T
MC>RU.XL7`W1$JQ!XR#BN;$+2YK29;HHHKD-PHHHH`****`"BBB@`HHHH`***
M*`(;HXM92#CY3TINAV_V-#&2/WBAQSGZ_P!*F90RE2,@C!!I=+/[A.I(`'..
MF..GUK6FKQ9$M&C1HHHJ1A1110`4444`%%%%`!1110`4444`%%%%`!1110`5
MJ:5HO]I1RRS,5MT!!`QECC./\_\`ZLNM[P[J*VRSVLK;8V0R*1V('/;T'Z>]
M:4TG)7)E>VAI^$Y2VE^6.43`'.>W-=#7/>%(O+T\GCYL-QWSZ_E70UVG.%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%>2>(1M\:7I+?>Q
MC_OD5ZW7C7B+>OB>XE!)/VEEY)Z;B*QK_#8TI[W'T445PG0%%%%`!1110`44
M44`%%%%`!1110`AZ&JND2.L[1L,*J[0,<#DX/U-6JMVFG&182&4#RP=V2%5B
M21V]"<UO17-=&=1VLR:BG,C1NR.,,IP1[BFUF4%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!4EO<BUN8VVEB^4"@XR2I%1U'&LLFMV"1D@!]S=<8R,Y_
ME^-7#XD3+8]&T:(1:=&H&%[#&,5H4R-0D:J.@%/KN.<****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`*\9\1ECXDG51_R]OV_P!HU[-7DWBB
MR^R>+WP24E_?#GIG.?US^&*PKK2YI3W*U%%%<1T!1110`4444`%%%%`!1110
M`4444`(>E;%F-MKY1;:2L#8Z]C_];\ZQZLZW=,U]`D2+%YULA98^`HQT`STK
MIP[M=F57H7[NZ^VW+W&,!L8&,<`8'Z"H*1!M0#T%+63=W<L****0!1110`44
M44`%%%%`!1110`4444`%%%%`!2P,8M2M9AR%)!'U_P#KXI*GMIEB+JRLWF@(
M`H_V@?Z5=/XD3+8]&@??`C<<CM4M4M)`&F0!3E0O%7:[CG"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"O-O'<0C\0V<^['F*4_+G_`-FK
MTFN)^(%OYEI%-R3"RD*.Y)Q45%>+*B[,Y.BBBO..H****`"BBB@`HHHH`***
M*`"BBB@!*9/>1ZKXI:>.$0I'$%"`_=QV&.,5)5>&U2Q\3W,,3%XF&^)SU9#@
M@_EBMJ;=F1/=&Q1114#"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`JCJ
MAD$40C+;C(/NGFKU6;"R:;5+60M@+EE!![8Y]/45=.-Y6)D[([ZP1TL+=9&#
M2!!N([GO^M6Z8BA$51T`XI]=QSA1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!7#>/Y_+CMHR3B1@H`]<YY_(UW-<7XYA:X6UCC4/(7&T8R
M<CGCW_QJ9?"QQW.1HHHKS3K"BBB@`HHHH`****`"BBB@`HHHH`*9<SD7UI-+
M$@\R(1JR@@G:<#Z\#_.*?5?5I%$VCA'!9592,YVDNW;Z8K:CU]")]#8HHHJ!
MA1110`4444`%%%%`!1110`4444`%%%%`!1110`5KV,@5["9!N,>Z)P<<$MD=
M^A!/Y5D4]9@B>4T@02.N">Y'&/;@FM:+M(B:NCTQ&#HK#H1D4^JUB[/91%EV
MG&,>E6:[#`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*Y
MG7#Y>L:>6Z-.I!ZX/%=-7,>);5;RZMH2P7<-N<9QGC/ZT`<5=^1]MG^S?ZCS
M&\OK]W/'7GI4-*Z-&[(ZE74X*D8(/I25Y9V(****`"BBB@`HHHH`****`"BB
MB@`JA-!(]VMUM/E02!2P[=/\:OU&\D::1>(X^=Y\(<].%S_*M:2NR*CT-2BH
M[<,MM&K_`'@HS4E2,****`"BBB@`HHHH`****`"BBB@`HHHH`****`"J.J;U
MABD09*2`_2KU4]3P;4)R69U``[\U4=Q/8]1TRX%WI=M<!=H>-6QG..*NUGZ-
M`]KH]K!(06CC"DCH<"M"NY',%%%%,`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"L'Q)F*WCG7@JV2<XP!6]6%XG1FTQRO4*<'&<'_.:`.$U1MV
MKWK>MPY_\>-5::DK3HLK$EG&XDG))-.KS'N=:V"BBBD,****`"BBB@`HHHH`
M****`"JFKJL-O:*DJLUP2[*.JD';@_7K_3UMUFZFZO?6048P<'\Q_P#KK6E\
M1$]CH5&%`]J6@=!14C"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`JI>J
M'>U0L5S.!D=15NH96V7-FV#CSP"1VSD?UJH?$A2V/4K;_CVC_P!T5-4-L<VZ
M8&,#%35WG,%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%<
MSXTO&L]!F=022,#IU)`!KIJY7QS$)M%9,'."1CU`R/Y4GMH".$B79$BYS@4^
MFI]Q?I3J\P[$%%%%`!1110`4444`%%%%`!1110`4S5K98]&L[MUV2"Z8H2N"
MZ@+G!]`?Z^]/J/Q#<&2QTBU+9C2)WVXZ$R-R?P%:TOB(J;&E&VZ-6]1FG4R%
M/+@1,YPH&:?2&%%%%(`HHHH`****`"BBB@`HHHH`****`"BBB@`JM?R>5`KC
M!975@#WP15FL_5""UO$<;6;\:J.XGL>K::ACTZ!&.2JX)^E7*I:2"NCV0/40
M)_Z"*NUW)W1S!1113`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`KD_',WEZ*Y!8;>Z\=>!765QGQ#BD.BK)&3A9%+C/4<C^9%3)V0UN<>.!BEI
M`<@&EKS3K"BBB@`HHHH`****`"BBB@`HHHH`*I:TLZQ61<ML()3YOX=Q!^G(
M-7:E\1.%\/Z&FWEC)SGG[YX_E^5:TE[Q$V68SF-3C'%.IL?^J7Z4ZD,****0
M!1110`4444`%%%%`!1110`4444`%%%%`!6=J:A9;:4X`5L$UHU6OXA+:/V*_
M,#CIBG'<3/3M,W#2;,,I5A"@(/4<"KM9VCR>9IZ'<&'8@YS[UHUWI6.8****
M8!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%8GBBR%_H5Q"<`E>
M">,$<C]0*VZSM:N$MM&NIG`.R,E0P)!;^$''OBD[6U!'E%L<VZ>PP:FJEIV5
MCD1CDALX],U=KS7N=:V"BBBD,****`"BBB@`HHHH`****`"M7QW:I:0Z-:*`
MWDX4D#&>F3CW/-95;'Q"\VVU6VG`_=.@`[Y(SQ^HKHH+1F53=%9!A%!]*6@=
M**R+"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`J*Y5FMI5498J<"I:CN
M)!#;NY[#I0A'8^")"_ANW#$D\G)]-Q']*Z6L#PG:/9Z)#$Z;"J`$$YYY)_G6
M_7H+8YWN%%%%,04444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!7,^
M-+@QZ.D*R`&:4!EXRR@$_P`]M=-7#^.)]U[:V^W'EQE]V>NXXQ_X[^M95G:#
M+@KR.&MCLU"5,<%<]:OU0A(.IN,<A:OUQ2W.B(4445(PHHHH`****`"BBB@`
MHHHH`*TO'4ZW&B:2?-W31P!Y03D_,JXR?7J?_P!=0Z5IDVJWJV\3!>-SL?X5
M[G'?K2^,+<Q&YC:((JJ%B4<@H``I]^`*VI72OW,YV;&6;B2TB8#`*C%351T@
MYTZ+Z5>J7HQK8****0PHHHH`****`"BBB@`HHHH`****`"BBB@`JM?RM#;AT
M;:ZNI4^AS5FL_4\M);1YX9CD>M5'<3/4]'E\_2+:79LWH&V^F><5?K-T6:*;
M1[7RG#!(U1L=B``0:TJ[D[HYFK,****8!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%<9XWL&V1ZDF2%'E2#T&25/YDC\179UA>+)S#X<O,#[T+
M#VZ5$XJ4;,J+L[GENG_/YLGJ<5=J"T4+:Q@=QD_6IZ\][G2M@HHHI#"BBB@`
MHHHH`****`"BBB@#K?`T2&:\F*_.JJH.>@.2?Y"G>/X(VTQ)SL5TSECW7KC\
M_P#/-9GA&8Q^((44#$J,C9[#&[C\5%;?CF1$TE=X!!8+R<8SQ7;0LX6.>II*
MYQ.D\VH8#"D`BK]1P11Q*RQ?ZL,=N#GC/'-25SRW9JM@HHHJ1A1110`4444`
M%%%%`!1110`4444`%%%%`!6?JN5CB=1\P;`K0JAJR%K9"!]UP?I3CN)GHGA.
M'RM"C?=GS6+XQT[?TK=K)\.H(]`LP&W`INSC'4Y_K6M7=!6BD<\MPHHHJA!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%9/B.`3^'KX=UA=A^1K
M6JM>1)/93Q.,H\;*P]012>P'C>GR%K;:W5"5Z8^E6Z@@MVM9KB!RI*28RIR"
M,<8-3UYTMSKCL%%%%2,****`"BBB@`HHHH`****`-CPM_P`C):?\#_\`0#6G
M\09S%:0+U!=3R.`<\'^=8.CNT>M611BI\]!D''!(!'Y5M?$F,#3K:4##^:%#
M#MW_`*?I77AW[C,*B]Y&';)Y=NBYSQ4M,A(,2D>E/K!FH4444@"BBB@`HHHH
M`****`"BBB@`HHHH`****`"J]\BO92ALX`SQUXJQ4-W_`,><O^Z::W$>@>&Y
M5ET.V://E!`$SZ8K8K'\.8&CQ!5"J.@'3%;%>@<P4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`5%.I:!U'4J0*EI#]TT`>17HV:S>Q;MVQ
ME&?^`@?TJ.EU9I+3Q%>BZB,(D8%-W0@#`/Z?TZTQ65AE6!'L:\^I\;.J&PZB
MBBLR@HHHH`****`"BBB@`HHHH`N:3_R&;+_KXC_]"%;WQ*M&FT:"8$`1L5]^
M<'_V6N5KN?&T1O?"[/"!(@99,JW!&#@CUZBNBC\+,JBU1Q6E-NTV$=U7!_"K
ME96@2F2Q*G`*L>E:M1+=E+8****D84444`%%%%`!1110`4444`%%%%`!1110
M`5'<)YENZ!E4L,98X'YU)52^E$7D`KN!E4D8R<`YXJHJ[$]CT?P\A32(@1CC
MCZ=JUJJV"HMC"(V#)M!4CT[5:KO.8****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`,W4=%T_5H]MW;)(<8WD88#.<9ZBN=NO`UG%F6S
M0JX'3<Q_#K7:44G%/<=V>+ZB\NDWPMKN,A3TD'0^O%+'<0R`%)%/XUVNK7=H
M/%UK;74?[LMC<>F=O_UQ2W_@#2[L,]L[VSMR-O*CGGC_``(%<\\.OLFD:G<X
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
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`>;_`!(A3RXI>`R2`#"\
M\CG^8_*O/Z[?XH782\L;,8+$F9A@Y`QM'/\`WU^5<1732^$Y:WQ!24M%:F)`
MMK&LA<`\]JE"@=!3J*$DMAMMA1110(****`"M/PC>OI_C*R=02LD@B90V,AO
MEY]<$@X]JS*GTBTFOO$MA;0,R.\B_,C;64`Y)![$`$U,]M2X;GT#1117&=H4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`'E'Q3M]NM6%R6_U
MD9C"XZ;3G/\`X]^E<=7H7Q0;-M:#:.)@N2>G!->>UTT7[IR5E[P4445J9!11
M10`4444`%%%%`!71?#]X3XP"2-AVB81\'EA@X_(&N=J&WDDAN]Z.R2HP964X
M*D="#VJ9JZL7!V=SZ.HJK9N\UC`\CQ.[QJS-"<H21R5/IZ5:KC.T****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@#S'XKC]]I3GIB3'_CM<)7<
M_%>';)ITWF.=Z.NPM\HP5Y`]3NY^@]*X2/\`U2_2NFEL<M7<?1116IB%%%%`
M!1110`4444`%0PQO+?"*-&>1B%55&22>@`J:M#PQ??V?XGBN0B.ZJ0@<D#)'
M./?&>O%3-V5RX*[L>R:';W%IHEE;76T3Q0(C!1]W`QCJ<XZ9[]:U*J6.H6]_
M"'A89Q\R$\K]:MUQL[$K!1110,****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBJEW?VM
MBFZXF2/@D`GDX&>!0!;HK"N/$<(B5K.WEN68C``VCWZ^U,<:O?RAXY_)MV&"
MJC!'OGK0!T%5I[ZUM5#3W$48/3<P&:YZYTJ:T0SSZHT2YSN:1N>.G7GZ5S-R
MT1G;[*"L38)WJ"2?Z8IJ+8I24=R+XFZA:WUOITEO+N\LN""""<[3D?\`?/ZB
MN*4;5`'85O:]9Q2Z?).[@2QX8%FY?D#'OP<_A6!%_JE^E=--6T.6J[ZCZ***
MT,@HHHH`****`"BBB@`J?1&1M6=70L'4J.<8[Y]^E04S3[D6E^)F("A\'/.`
M>#^F:F2OH7%VU.WCO-0LYQ/;3`.%*@L`21Z$]<5N6/C*X&R*[MU=L@9'RD\<
MGT^G2L*D*@C!&:Q<$S93:/2[*_@OHM\+?53U!JW7!I>6,T$>99+2Y1,%U7C/
M3C;_`"QBG6_C<VDNR^BDDB+'$@`!4?GS67*S523.ZHJ"VNX+R(2V\JR*>X/2
MIZ104444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%1R2QPH7E=40=V.!61<^);*%3Y.^X8,%PBXS^)XH`VZS[_
M`%:UL,K(Q>7:6$:#).*R'O=9U-0EM#]D0C#$\M^?;CO5:2YT_29B6W75XO#!
M3@`]\G\??T--)O83:6Y>DU?4+U`MC:F'=_',,D#'4`4^V\/J\S7-XQ>9CDDG
M.#63-XKN,;;:VB@7&.?F(/J.@_2LBZO[N])-S</(,YVDX4'&.G052@V0ZBZ'
MH*6EI9QL5CCCC`RW8#WKCM0\1WEU*ZV\C00'A57`;ZD]0?I6-15J"1$IMCY9
M9)I#)+(SN>K,<DTRBBK(,3Q*SK9PXV^7YGS>N<''X=?TK"M_]4/J:O>*78WD
M4>?E6/<![DG/\A6?:N'A&.QP:M&;>Y/1115$A1110`4444`%%%%`!5"8A9F4
M=SFK]4%B:;4?*!PSN%&?<\4GT8UU1W=BS/I]LS$EC$I))Y)Q4]1V\7D6T4.[
M=Y:!<XQG`Q4E9FJ"FNBR+M89%.HH`NV+JODB*[DM+A/E$F?E(SP#Z#Z\<5TL
M>I:M9HPN[=9B.$*C:6^M<;5^+6M0AMU@2X_=*,`,BM@?B*SE#L:QJ=SLK'6[
M._E,*2;+A?O1/P1_CT[5J5YF;Z:2X$LYW\@DJH##W&,<_P"`Z5T5GKTT"%9\
M74*\B1""P';/O]<&H<6BU)/8ZJBLVSUNPO6VQS!7P#L?Y3S6B#D9'2I*%HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
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
MRT1Y!_#_`#T[T`07W@33YY#+:2S6KDD[5(*\^W8?2N5@L+IM9ETY;A7:.0H,
M?Q=^":]"TW6XKX^5*GD7`SF-CV'O7.:4$_X3:1@0&)<XQ]1FGS,EQ3)[?PU=
MI*LB)!'ZF1BQ'3D#L<@G_"M[3M%M[!=S?OY^\C@9'L/05/=ZI9V1VSS*&QG:
M.3CZ57/B#3@F[S'VYQ_JFX_2ANY25C5I"<#)XK!;Q+%),8K6UFD(_B88&/Y^
MGYU!-;ZQJC[9)1!!C!5,@'W_`*8S2`DU'4FOY%LM/D.UB-]Q&>%YZ5;T_0K>
MTC7S!YC@YRW:K5CIT%B@$:C=W.,9J[0`U55!A0`/04ZBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`R]2T:&^C^4;)!T(X
MKD8]%U*TUYC&S[W0_O,^H_3D_P`J]"INT9S@9]:`,BPT&"V7,Q\V0DDECG)/
M6KO]F6>SRS"NS^[VJY10!!%:P0A1'&HV\#CI4V,=*6B@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
DH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@#__9
`



#End
