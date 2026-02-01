#Version 8
#BeginDescription
version  value="1.4" date="20mai14" author="th@hsbCAD.de"
bugfix drill rotation lock

DE   erzeugt EuroTec Ideefix-Verbinder
EN   creates EuroTec Ideefix Connector


#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 4
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// creates EuroTec Ideefix Connector
/// </summary>

/// <summary Lang=de>
/// erzeugt EuroTec Ideefix-Verbinder
/// </summary>

/// History
///<version  value="1.4" date="20mai14" author="th@hsbCAD.de"> bugfix drill rotation lock</version>
/// Version 1.3   th@hsbCAD.de   18.10.2011
///    -Ausrichtung immer parallel zum aufstoﬂenden Bauteil
/// Version 1.1   th@hsbCAD.de   07.03.2008
///    - Namens‰nderung, Bohrtiefe Haupttr‰ger erg‰nzt
///<version  value="1.0" date="06mar08" author="th@hsbCAD.de">initial</version>


// basics and props
	U(1,"mm");
	String sArNY[] = { T("No"), T("Yes")};
	//PropInt nXX(0, 0, T("Int"));
	//PropDouble dXX(0, 0, T("Double"));
	String sArType[] = {T("|Post connector|"),T("|Floor Connector|"),T("|Rotation Lock|")};
	PropString sType(0, sArType, T("Type"));	
	double dArDiam[] = {U(30),U(40),U(50)};
	PropDouble dDiam(0, dArDiam, T("Diameter"));	
	double dArDepthMale0[] = {U(27),U(35),U(45)};	
	double dArDepthMale1[] = {U(20),U(25),U(30)};	
	double dArDepthMale2[] = {U(20),U(25),U(30)};		
	double dArDepthFemale[] = {U(7),U(10),U(15)};	
	double dArEdgeOffset[] = 	{U(50),U(60),U(80)};
	
	double dArScrewL[] = 	{U(40),U(60),U(90)};
	double dArScrewD[] = 	{U(5),U(6),U(8)};
	double dArScrewMainD[] = 	{U(12),U(16),U(20)};
	double dArAxis[]= {U(50),U(60),U(80)};
	PropInt nRow(0,1,T("|Qty Rows|"));
	PropInt nCol(1,1,T("|Qty Columns|"));	

	PropDouble dOffY(1, U(0), T("Center Offset") + " Y");	
	PropDouble dOffZ(2, U(0), T("Center Offset") + " Z");			

	PropString sShowPlan(2, sArNY, T("|Show Plan Info|"));	
	PropString sDimStyle(1, _DimStyles, T("|Dimstyle|"));	
	PropInt nColor(2,94,T("|Color|"));	
		
// required variables
	double dSnap = U(200);// defines the valid range in which a connection can be found


// on insert
	if (_bOnInsert){
		if (insertCycleCount()>1) { eraseInstance(); return; }
	  	PrEntity ssE(T("Select male beam(s)"), Beam());
		Beam ssBeams[0];
  		if (ssE.go()) {
			ssBeams= ssE.beamSet();
  			reportMessage ("\nNumber of beams selected: " + ssBeams.length());
  		}
		Beam bmFemale = getBeam(T("Select female beam"));		

			
		showDialog();

		// set TSL Props
		TslInst tsl;
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		Beam lstBeams[2];
		Element lstElements[0];
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];

		lstPropDouble.append(dDiam);
		lstPropDouble.append(dOffY);
		lstPropDouble.append(dOffZ);				
		
		lstPropString.append(sType);
		lstPropString.append(sDimStyle);
		lstPropString.append(sShowPlan);				
		
		lstPropInt.append(nRow);
		lstPropInt.append(nCol);
		lstBeams[1] = bmFemale;
		int nInvalid;
		for(int i = 0; i < ssBeams.length(); i++)
		{
			/*if (!ssBeams[i].vecX().isPerpendicularTo(bmFemale.vecX()))
			{
				nInvalid++;
				
				continue;	
			}*/
			lstBeams[0] = ssBeams[i];
			tsl.dbCreate(scriptName(), vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, 
				lstPropInt, lstPropDouble, lstPropString ); // create new instance			
		}

		/*if (nInvalid == 1)
			reportMessage("\n" + nInvalid + " " + T("connection is invalid. Selected beams are not perpendicular."));
		else if (nInvalid > 1)	
			reportMessage("\n" + nInvalid + " " + T("connections are invalid. Selected beams are not perpendicular."));
		*/
		
		eraseInstance();			
		return;
	}	


// start code here



//ints
	int nType = sArType.find(sType,0);
	int bShowPlan = sArNY.find(sShowPlan,0);
	// control valid type
	if (nRow>2 && nCol>1 && nType ==2)
	{
		reportNotice("\n*****************************************************************\n" + 
			scriptName() + ": " + T("Incorrect user input.") + "\n" + 
			T("|You must change the type or the qunatity of rows and/or columns|") + "\n" + 
			T("|Type is now set to|") + " " + T("|Floor Connector|") + "\n" +
		"*****************************************************************");
		sType.set(sArType[1]);
	}
	
	
	
	int nDiam = dArDiam.find(dDiam,0);
	double dScrewL = dArScrewL[nDiam];
	double dArDepthMale[0];
	if (nType==0)
		dArDepthMale=dArDepthMale0;
	else if (nType==1)
		dArDepthMale=dArDepthMale1;
	else
		dArDepthMale=dArDepthMale2;
		
	double dOffX = dDiam-dArDepthMale[nDiam];
	double dDrillDepthFemale = dArDepthFemale[nDiam];
	double dScrewMain =	dArScrewMainD[nDiam];
// check min
	if (nRow<1) nRow.set(1);
	if (nCol<1) nCol.set(1);

// alert
	
		
// standards
	Vector3d  vx, vy, vz;
	vx = _X0;//_Z1;
	vz = _Beam[1].vecD(_Z0);
	Vector3d vTest = _Beam[1].vecX().crossProduct(vx);
	if (!vTest.isParallelTo(vz))
		vz = _Beam[1].vecD(_Y0);
	
	
	//if () 
	vy = vx.crossProduct(-vz);
	vx.vis(_Pt0,1);
	vy.vis(_Pt0,3);
	
	
// stretch
	_Beam[0].addTool(Cut(_Pt0,_Z1),1);
		
// ref
	Point3d ptRef = _Pt0 + vy * dOffY + vz*dOffZ;	
	ptRef.transformBy(0.5*(-vy*(nCol-1)*dArAxis[nDiam]-vz*(nRow-1)*dArAxis[nDiam]));
	
	ptRef.transformBy(vx*dOffX);
	
	ptRef.vis(3);
	
// Display
	Display dp(nColor);
		
// distribute
	for (int i = 0; i<nCol;i++)	
	{
		for (int j= 0; j<nRow;j++)	
		{
			Body bd(ptRef, ptRef-vx*dDiam, dDiam/2);
			dp.draw(bd);
			
			// drill male ideefix
			Drill dr(ptRef, ptRef-vx*dDiam, dDiam/2);
			dr.cuttingBody().vis(4);
			_Beam[0].addTool(dr);

		// drill female ideefix
			if (0)//nType == 2)
			{
				dr.transformBy(-vx*(dDiam-dOffX-dDrillDepthFemale));
				dr.cuttingBody().vis(6);
				_Beam[1].addTool(dr);
			}
			
			// drill connector screw
			Point3d ptDrFemale = ptRef-vx*dOffX;
			ptDrFemale.vis(2);
			Drill drFemale(ptDrFemale, ptDrFemale+vx * _Beam[1].dD(vx),dScrewMain /2 +U(1));
			_Beam[1].addTool(drFemale);

			// drill female ideefix
			if (nType != 0)
			{			
				Drill dr(ptDrFemale, ptDrFemale+vx*dDrillDepthFemale , dDiam/2);
				dr.cuttingBody().vis(1);
				_Beam[1].addTool(dr);
			}
			
						
			// draw connector screw
			Point3d ptScrew2 = ptDrFemale+vx * _Beam[1].dD(vx);
			ptScrew2.vis(3);
			
		// repos ptScrew2 for non perp connections
			if (!_X0.isParallelTo(_Z1))
			{
				Body bdCyl(ptRef, ptRef+vx*_Beam[1].dD(vx)*2, dDiam/2);
				//bdCyl.vis(1);
				Body bdCyl2 = bdCyl;
				bdCyl.intersectWith(_Beam[1].envelopeBody());
				bdCyl2.subPart(bdCyl);
				Point3d ptExtr[] = bdCyl2.extremeVertices(vx);
				if (ptExtr.length()>0)
				{
					ptScrew2 = ptRef+vx*vx.dotProduct(ptExtr[0]-ptRef);
					
				// add sinkhole
					Drill drSink(ptScrew2 ,ptScrew2 +vx*_Beam[1].dD(vx)*2, dDiam/2);
					_Beam[1].addTool(drSink);	
				}
			}
			
			
			Body bdScrew(ptDrFemale-vx*dDiam , ptScrew2 ,dScrewMain /2);
			bdScrew.addPart(Body(ptScrew2,ptScrew2 +vx * U(2),  dDiam/2));//dScrewMain*1.5));
			PLine plHex(vx);
			Point3d ptHexHead = ptScrew2 + vy *0.7 * dScrewMain;
			CoordSys csHex;
			csHex.setToRotation(60,vx,ptScrew2);
			for (int k=0; k< 6; k++){
				plHex.addVertex(ptHexHead);
				ptHexHead.transformBy(csHex);
			}
			plHex.close();
			bdScrew.addPart(Body(plHex,vx*U(10), 1));			
			dp.draw(bdScrew);
						
			ptRef.vis(j);
			
			// show screws for post and floor connector
			if (nType !=2)
			{
				Point3d pt1 = ptRef - vx*U(10) - vy *U(10);
				Point3d pt2 = pt1 - (vx+vy)*dScrewL;			
				PLine pl(pt1,pt2);
				CoordSys cs;
				cs.setToRotation(45,vx,ptRef);
				for (int k =0; k<8;k++)
				{
					dp.draw(pl);
					
					pl.transformBy(cs);
				}
			}
			
			ptRef.transformBy(vz*dArAxis[nDiam]);
		}
		// shift back
		ptRef.transformBy(-vz*(nRow)*dArAxis[nDiam]);
		ptRef.transformBy(vy*dArAxis[nDiam]);		
	}
	
// draw information with a box and a guideline in plan view
	// requires declarations of
	//    String sDimStyle; // the dimstyle
	//    String sDesc; 	// the text to be displayed
	//    int nColor; 		// the text color be displayed	
	//    bShowPlan;			// flag if info to be shown
	// if multiple grip points are in use change index of _PtG[...]
	
	String sDesc = (nCol*nRow) + "x IF" + String(dDiam);
	
	if (bShowPlan)
	{
		Display dpPlan(nColor);
		dpPlan.dimStyle(sDimStyle);
		dpPlan.addViewDirection(_ZW);
		if (_PtG.length() < 1)
			_PtG.append(_Pt0 + vx * _Beam[1].dD(vx) + (vx + vy) * _Beam[1].dD(vx));
		dpPlan.draw(sDesc,_PtG[0],  _XW, _YW, 1, 0, _kDevice);
		
		PLine plBox;
		double dBoxLength, dBoxHeight;
		dBoxLength = dpPlan.textLengthForStyle(sDesc,sDimStyle) * 1.2;
		dBoxHeight= dpPlan.textHeightForStyle(sDesc,sDimStyle) * 1.2;		
		plBox.createRectangle(LineSeg (_PtG[0] - (_XW * 0.1 * dBoxLength + _YW * dBoxHeight), _PtG[0] + (_XW  * dBoxLength/1.2*1.1 +_YW * dBoxHeight)), _XW, _YW);
		PLine plGuide(_Pt0+ vx * _Beam[1].dD(vx), plBox.closestPointTo(_Pt0));
		dpPlan.draw(plBox);
		dpPlan.draw(plGuide);		
	}



#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`:P!K``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`-_!)<#`2(``A$!`Q$!_\0`
M'P```04!`0$!`0$```````````$"`P0%!@<("0H+_\0`M1```@$#`P($`P4%
M!`0```%]`0(#``01!1(A,4$&$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*
M%A<8&1HE)B<H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&EJ<W1U
M=G=X>7J#A(6&AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&
MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ>KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!
M`0$!`0````````$"`P0%!@<("0H+_\0`M1$``@$"!`0#!`<%!`0``0)W``$"
M`Q$$!2$Q!A)!40=A<1,B,H$(%$*1H;'!"2,S4O`58G+1"A8D-.$E\1<8&1HF
M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@H.$
MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#W^N%\>W+&
M2WM!D(J&4_-P23@<>V#^==U7!^.8)?ML5P4/D&(1[^V[)./R-8U_@9=/XCC-
M.SY<F>N^KM9^GX$DP'8UH5PG2%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`%JTU*\LD=+><K&X(9"`RG/7Y3QVK15]%U@&._M(K2<
MKM66/*QG)].W7J?3J*Q**N,VB7%,WY="DTZ4HV]HB2V0264=,8]/\Y%9RNK%
M@",J<,,]#6EH_B/[/%'9WRF2%3A)0?FC'I[C^7OP*CU_PVY7^U-+F$B'/F-&
MVX8'?W]_I]:WERSCS1,U>+LRG169%?S1,5N4X'\0%:2LKJ&4@@]"*P-!:***
M`"BBB@`HHHH`****`"BBB@`JSI]T;*_@N`2`C`M@9..X_+-5J*:=M0.NN[_0
MM1C#3RA)?E.[RSN4CG&<52CDN[:%KBSNENH4Y)'##G^(=1T_(5SU20326\J3
M1.4D0Y!%;*N^IFZ:Z';Z3KD&HQ#Y@'`Y^M:P((XKSNYU`2/]IM[98+OJS(V%
M;\#G'_ZZV(=:N+*&)YQN@8X\X9VM_D_2MXSC+8S<6MSK:*R[/7+6[^ZV/Z5I
M@A@"#D59(M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1129`.,\T`+1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!6/XDLQ>Z#=1`9<+O3"
M[CN'/'N>GXUL5%<)YENZ#N*35U8$[.YXGIZ$-,YP,G&*OU"]L;'5KRU8@;7R
MH'H>?Y8J:O-:L['8G<****0!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`5IZ1K=SH[MY6)(F(+1-T^H]#CBLRBFFT[H&KZ%_49K"
M\F$L*B#S?^6+#&UL#(!Z$$GCIWX%9,,C:=,R."83S]/I4DD:RQE&Z&J(LKE<
M*)E*#H#DC'TH<W?82B=`K!E#*<@TM8\%V]DH63D=QC^7^>U:L<L<JY1@1[50
MA]%%%`!1110`4444`%%%%`!1110`4444`%:%GJ\]G;-;;(IH#_!*NX#UQS6?
M133:U0FK[G1#^SM5@46NVQOAPJ;L*W/3T.<_6K%KK$]@XM[Y/+;LI:N5J6XN
M)[N/9<3RRKSP[DUO&O9:HS=/L>AP7UO<@>7(,]:M5YSH5B_FO!:W'E2A<Q*W
M0\\\Y_'OWZ5T&GZS<6TAM;^)DD5]N6X!'J/6MX2YE<S:L['344Q)%D4,A!%/
MJA!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
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
MS:OXC)SV_P#KUTJ1K&BHBA448"@8`'I4E=,*$8[ZF+J-D:1K&BHBA448"@8`
M'I4E%%;F84444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4UD5U*L,BG44`<9XE\*-=1"6S?;*A+`X_0^U<,9I;6407L+0R=/F&/\
M]*]LJE=Z;;7<;K)&I#C##'6L:E%3=RXU'$\I5@P!4Y%+71:MX;^Q(QM8<(!N
MPBXQ7/\`E2*FYD(48!(!QG_(-<TZ4H:FT9J0VBBBLBPHHHH`****`"HI9EB7
M)/-,GE9<)&K-(W`"C)-6]/TVV\O[1J!>:4C<L"\(&ST8]^G;UJHJXF[$6G:5
M>ZW+(R2+;6D1'F3R\*,]AZFI=2\/Z>2L5K</(%Y,K`C<3[>WKQ_CHRS23%2[
M9VJ%4````=``.`*CJM$K)$ZC(HD@B6.-=JKVI]%%(84444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%0W%U#:)NE;&>@'4UAW6JSW*E%`CC/!`Y)_&IE)(
M:BV3WNJR.YAMOE`.-PY+?2JQQ``"-]RQR6/.T_XT(!9PB1ES.WW0?X:FM(&)
M\R4`DU"N]65Y(;'9-(V^9R_?GM5U$6,844ZEJA!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`445'+*D*[G;`[>]`#ZIW%[@M'#\SCOV%1.TUX2%)6//3_&M72M`NKL$V
MEJTFWJW`7/U/&>>E-)O8&[&?:VFW]Y(2S>];VDZ+=:M(/)79`&VO*>B_XGV'
MJ.E=1I7A&VME66_Q/,#D(#^['/'U_'CGI72I&L:*B*%11@*!@`>E=$,.WK(R
ME5[%/2])M=)@,5LI^8Y9VY9O3)K0HHKJ225D8-WW"BBBF`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`UT
M612K#(-<GJFDK9L\\2B2-U*R(PX(_P#K?I774UT5U*L,@]J`/+GTR1[HQ6I#
MY/RJSA6'3KG`/7MUQ5.6":W8+-$\;$9`=2#BO1[SP_:W))`VY!R.U9-SX:,5
MFT&YGA/0`\J1T(_SWKFEAU]DU55]3BZ*2^CFTJ15NU_=N<+*HX/U'8XQ6=/J
MB;Q'#F1CP`O-<LDXNS-T[[&M!!+<RB*"-I'/91T[<^E27%A+;HIFF@C)."I?
M)'/MQ^M,LQ=10(J-Y!/S2,/O,?3VQ_G%/BLH8CN(WOG.YN35I16^I%V]A\*"
M)\VX:)002V?F8CW_`,*EZ444-W!*P4444AA1110`4444`%%%%`!1110`4444
M`%%%%`!115:[OX+(?O6^8C(4=:&[;@620JEF(`'))[53:\\PD0?=&07]?I_C
M6)>:M-?8BCC*QD]!W^IIZ?:I(%B4>6`!]WCO4<U]BN4GEFM(V.Y?-<GG/S'\
MS]*J+&\C@QP^6,\$$D_K5V"R2/D\FK04*,`8I60%**RP_F.<L>N:N@8&*6BF
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%(S!023@#O5$WCW!*P`@=-Q%`$US=I!A1
MS(>@JM':R7&UYFR?0UTGA[P6^HHEY<3".W8G&.7?!P?IWY_2NWL/#FFZ<4>*
M#S)5Z22'<>N<XZ`^X%;0HREJ1*HD<KX?\+27;QSW49CM,!@,X:3_``'O^7J.
M_2-8T5$4*BC`4#``]*DHKKA34%H82DY!1115DA1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%137$<"%G8"@"3..O%4KO4K6SC9I94`4<Y.`*Y'6?%,\LQMK)&WC&23@`&
ML.XBEO@INWSAR^U?\:RG54?4N,&RSXAU7^V2UK;VRE'4[I#]T'C!![FL^PTJ
MVL$&Q`T@YWD<U<1%C4*HP!2URSES.[-HJRL@HHHJ1A1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4454N=2M[8$%MS`XVKSS0`Z_O$L;5I6Y;HHQG)KG+
M:"74)VGN"64G//<U9:.74+OSI_N#A4SP!6BJA!@5F]64M$11VL<?1>:F``Z"
MEHI@%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`56FNXXOE&7;T%0W=TS$P0YW'J
MP_I5[2-#N;Z54@B+OG#.1\J9[D]NE-*^B!NQF[;FZ?YSM3^Z.E=]H?@M$1)]
M0P0RY$"Y&,@?>/!!'/'ZUJZ1X8L]-$<TP\ZY7!S_``H?8?U/IGBNBKJIT+:R
M,)U+Z(C2-8T5$4*BC`4#``]*DHHKI,@HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MJ&6YA@7,C@"N9USQ?!9((H8S-*XX4''?%)M)78TKFCJ^MK:1,D0+2'@;1FN>
MOX-0^R)=7TRQB1?EA.=['W]@.:@TK63`?M5S9&2<D[=TN-@]N#4=_J,^HRAY
MV'RC"JO"K]*RG65O=+4'?4IA0N?4\D^M+117(;!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`445)%$\T@CC`+8)Y(`P!D\GV%`$=9]_J\%D`JCS93T13
M5C4K>3YH_M5O'%CA\M\_T&,UF+I\0N#*27Q]W<`,?_7HFG'0(V97^U:C>)N=
MMB,>$48_.GVUB5):3\JOA0HP!BEJ+%"`!1@#%+110`4444`%%%%`!1110`44
M44`%%%%`!1110`444QY%CQN.*`'T5%',LA(7M4M`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%,>1(P"[!1TY-59-1C4?NU+MCCC`H`N$A023
M@"J-Q=^8#%;M\QZM[>U6])T74/$%^(T^2)>78CY4'^/M7HVD^$M,TI8W\D37
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
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@#EO%X)BBVJQ.[DJ<$"NFB_U2?[HK'\36[3:8Y1=Q`/%6]'NUO-+@
ME!)(7:V3R".N:`-"BBB@`HHHH`*8Z+(A1U#*>"#3Z*`.*USP8)T9[%U50/\`
M5ODXQW!S7"F^NM+F>TG4,Z\`'@@]J]OK@?%&F1SZQ*%5C,T8E7`SDC/`_#C\
M:QJT^976Y<)6=CF;&_O$^?9'&^=VX#)_7CT[=JU)_$&J7%N\$ET?+888*BKD
M>F0*S*6N/GE:USHY5N%%%%2,****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M**9)*D2Y=L"H$^UWURMM9QDO)@+@9)]:8%R&/S9XX@RJ78#<W0>Y]JW(]*L;
MLQV]M;R3QDD232$J<X[*.WUSUJWHO@;[/LFO)3+*5PP)X_"NOL[""R3$:`'U
MKKI4>57EN83J7V*.EZ#::;&-D**W4[1@5L445T&04444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`0W40FMG0]Q7.^&F
M%M?7MD7..&5<?G_3BNF;[A^E<OI0\SQ9<R!QA8BH`],_XT`=51110`4444`%
M%%%`!7+ZL0GB6T+%AN4#IQC_`/7745ROB79;:C:7[$A%7#GL`,G\^OY4`<AJ
M2K'JEVB*%19W`4#``W&JU.EG:ZFDN'`#2L7(7IDG--KS'N=:V"BBBD,****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBFLRH,L0![T`.J.23RP`!N=CM5?4]JF2UN[DE+
M9$+CJ&/Y=*ZC0_!GV:=;J\D$LRYQZ#Z?KS6L:,I/5$2FD5-$\&K>_P"D:B6D
M(X\O)51_6NYM+*ULH]EM`D2DY(10.?P^E3QQB*,(O04^NV,(QV1SN3>X4445
M0@HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`*]ZYCM)&'7%8WAN%O-O+IF`\Q@NP=L=_UK8OP392`>G:L;PH
MQ:VN@>0LNT'.>U`'14444`%%%%`!1110`5SWB^T^U>&[LKG?"AD!!QT'/X8K
MH:PO%L4\OAB_6!MK"+).2,J.6''J,BIG\+&MSS*S<O",U8JI8%3!P:MUYIUA
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`45H:;HM[JI)MD`C4X:1SA0<=/?\/45=ATVW
MTV=&N2E[,#\L$.2AQW9B.W/&/3Z5I"G*6R)E-(AM=&"V*WM^SQQO_JHDP'DX
MZ\]!T['^6=+2O#Z73),8_+CZCN3TZG]?3-:-MIUWJ5REU?MOQC"_PK[@5TL:
M+&@50`!Z5V0I1AL<[FV5+/2K:S4;4!;UQ5ZBBM"0HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`ANEWVTB^U<]X8D9+R_MG(&U@P4?J?Y5TQ&1BN1F<:-X@%RX=(9/E;:`<YZ9
M%`'7T4@((!'2EH`****`"BBB@`JO>-&EE.TV/*$;%\C(QCGBK%9?B"?[/H-X
M^W=F/9C./O?+G]:4G97!*[L>16)V,T9^\#@U?K.4D:G)Z<&M&O,.P****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHJ>TL[B]F\FVB,CX+8'&`.Y/:GY(""G0Q-/(43G;RQ_NBM.72X!
M-':V\C7,_!E=.(U!'0<<G/?CZ5TVD^&(+-0SK@@YZ#GW/J:Z(8=O61E*JNA3
ML-)OKVS$3R-';#`2,<#`Z9QW[_6MS3="M[&-01N(.036JB+&H51@"G5U^1@(
M`%``&`*6BB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"LS6K-+JR;*_-Z]ZTZCG&8
M'X[4`9?AV7=I@A+LSPL5)8Y-;%<UX<0PW]Y&S`Y`*^I&3_C72T`%%%%`!111
M0`5S7C?_`)`T/_7P/_06KI:Q_$EFEYHEP&R#"IE4^A4$_J,C\:BHKP:*CNCR
M,DKJC9XSTX[5HU0O$VW<3KU/!J\IRH/M7G'4.HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*0D*"2<`5'-.D"
M%G/T'<TFFZ9?>(;_`,B!&$`QO;LJD]3Z_3VII-NR!NVK&K-)<S>190M-+ZCH
M*['2-$OUA",0B.`6`/4\=?7^G-=#I6@6>E6J0QH#MY)/<^IK7`"C`&!7;2I*
M&KW.:<^;0S['2H+/#;<ODG-:-%%;$!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4>U%%`'+7(>V\46K0JS;GVL%]#Z^PZ_A74US33>9XJB5<8&=W.*Z6
M@`HHHH`****`"JM]`USI]S`A`>6)D!/0$C%6J*35P/#;EO,O4CQG:.*O@8`%
M3^)[-+7Q?=,BE1-B3GW)R1^-05YTERNQUIW5Q:***D84444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%(2`,F@`JI)>%I!#;*9920
M``,Y)["K]A8S:M<"*,$0]<_\].O`]J]'T?0+32X%6.(`XY%;4Z+DKO0SE42T
M.,\/^"+F\D6ZU8M'&#D1'[SCW]/Y]>E>A6=E;V%LEO;1K'&@P`*LT5UPIQ@M
M#&4G+<****LD****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
MYBU:*/Q45VG>T94'MU!/]?RKIZY66-(/%,$LKE1DD`]!VKJJ`"BBB@`HHHH`
M***@N9UMK66X<$I$A<@=<`9H`\J\777VKQC-M<LL2B(<8QCJ/^^LU`.E4;]V
M%ZMQ(2S-]YSR<Y[FKJG*@UYLG=MG8E96'4445(!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!2=*@FNDB;8/F?TJ.WL=0U>X$$,3.3_"@Z
M<XR?;IR:8"37X!VPJ7;UQQ6MH?A74-<"SW#F.TW8+'JV/[O\L_X5TFC>!;>"
M))=1)DD(R85.`O7@D=>W3'3O78I&D:*B*%11@*HP`/2NBG0OK(RE5[%+3])M
M].7]T@!P!P/2M&BBNLP"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`YWQ/;XA6X1MDB'*MCH:U].NEN]/@G4`;D&0#G!QTJO
MKH/]F2$#)`SBH/"Y+:!`S=2S'_QXT`;5%%%`!1110`5!<6ZW-K+;N2$E0H2.
MH!&*GHH`\<UJPFLS/;3*OFQ=<'((Z\?456L9/,@%=IXXL%5H;U$XD!CD/&"<
M?+[DXS^0KA-,;(;ZG^=>=./+)HZHNZN:-%%%04%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1137=8U+,<`4`.JG=7>P^3'S(?3M4<MS).?+A^5>A;O7
M?^$_"<6FQ17UVF;QUSM(QY>>WU]?R^ND(.;LB924497A[P.]PCW.J>;"I'R(
MI&\^YZX^G7^O>V5A;:?;B"UB$2`YP.<GW)ZU;HKLA3C#8YY2<MPHHHK0D***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`S]84-I[@_D>]0>'/^0'!Q@Y.1G.#FKFI)OLI/89K/\`#LK&S>%]OR,2I'<'
MGF@#;HHHH`****`"BBB@#+URQ74-(N(-NY]A:/ID,.1R>GI]":\?TU2K,&&&
M&<BO<B`RD'H>*\5FA%CKU]:*6*1S.JD^@)KEQ*V9M2>Z+5%%%<IL%%%%`!11
M10`4444`%%%%`!1110`4444`%%(2%&2<`5"DLEU.+>SC\R3J3V`]::5]$`EQ
M=+``,%F/0"J@CN+MP9#A.P'2N_TGP3:;5DOXVEDQ\S,Q&>G3':NCL]$TW3W,
MEK:(C]F)+$?0G..O:MUAY=3-U4<[X;\(_9S!?7FY'4[TAQ@@]BQ_I],]Q7:T
M45TP@H*R,)2;=V%%%%6(****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`&NH="I[URU@TVG^(A;!28IL@G/`P/I7
M5US.L-<V6HI>Q0[PAS@]QCG^M`'3455L;Z+4+99H3UZJ>JGT-6J`"BBB@`HH
MHH`*\?\`$,:1>--05!A2P;&>Y`)_4FO8*\U\<6:0:Q'>"-@T@7+`<'KU]_NB
ML:\;Q]#2F[,QJ6D!R`:6N$Z`HHHH`****`"BBB@`HHHH`***3H*`%J*:X2!<
ML3GT'6JL]XSMY5O^+8_E78:!X%$@CO=5W;R0PA/I_M?X?GZ5<(.3LA2DH[G/
MZ=HFI:[=(%@>&U."7<8&#WQW_"O2='T"TTBQC@10[*/F8C&XUJ10QPKMC0*/
M85)793I*&QSRFY!1116I`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`5%/"D\31N,@BI:*`.85
MI='OF81?NF^_@=1]?6MRQO[?4(/-@<$`X89Y4^AJ::".=-KJ#Z>U<U<65YI-
MVMS9EBA.TH,;2/4T`=516;I^K0:@S1A6CE7^%N_N/6M*@`HHHH`*Y'Q[;QR:
M1&[Y#A\*?3@G^E==7-^-DC_X1J>63_ED05X[GY?ZU,_A8UNCSV(_NES4E0VS
M;H5(Z5-7FG6%%%%`!1110`4444`%%%02W4<1"DEG/15&2:`)J:FGWVJW*VMI
M&0I^\S<#H3_G%=%HFBW4\>X@QR9R7`&,<\#(SR"176Z9HL.GG?C+]?I75##]
M9&,JO8@T+P[::+;+M0/<%?GE(^8^OX>U;M%%=*22LC)N^K"BBBF(****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`IK*K##`$>].HH`YS6-!$B_:+4LDR'<I4X(JSH
MNL&]S;7("7<8Y']X>HK9QQBN;UK2I$E6]M'V3(>",`T`=+16?I>I1ZA;@@XE
M4?.OH:T*`"L3Q79-?^&;V!?O;-XYQG;S_2MNJ]W%YUG-$"%+(0"1G'%)JZL"
M=CQNQ/[@#TJU4(5H;ZYB?AMY)&,8/I4U>:U9V.Q.ZN%%%%(`HHIKNL8RQ`H`
M=5>6Y".(HU,DIX"K5>6[DERMNI'N17<>"_#@B1M2O(B)9.(0PYVXY;\<_P"<
MU<(.;L*4N57.9L_#FNZG.I6%X47DF0%%Z>_)_#-=IHW@BSTV83RL9IL=2,`=
M>@[=:ZL*%&`,"EKLA1C'4YY3;&1QI$NU%`%/HHK4@****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`IKHLB%&&0:=10!RNI:+<6A-QISF.3<"-
MO'`]:OZ9KBW$GV:[7RKD';[-]/2MH@$8(K(U;1H[J/S(@%E7IQ0!L45S&EZN
M]@HLM5ER5X2<YP1_M&NF!!`(Y%`'GGBK2UMKR2Z0+&/O!0/O9(!_4YK`KK/'
M`8,"!\NQ/3^_7)CH*XJZM,Z*3]T6BBD2"\O)%BLX=^6"ER<`<XK%)O8T;L,F
MF2",LY_#N:T-'\)WFMRK<79-O;@\*1\W7T[?7]*VM&\#>7MGU"4RS@AAZ+]/
M6NXAA2"(1H,`5TTZ'61C*KT1EZ?X;TO30I@M4:1<'S)/F;([\]#],5L445TI
M):(Q;;W"BBBF`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`&=J&E07R`,N&'/UK"@;4]"8IQ-;]2K'[OTKKJ9)$DJ[74
M$>]`'`>);L:B@FMV8H8\LIR-N#D]?IFN=+*B98@#U-=+XAM_[-U`^3`\[2(2
M(@,*1TY_6JGA[PC>W4@N=3`5<?+%G.#Z^E<U6FY25C:$E%,S;2PN+^9H@K1J
M!SP=Q_P_G7H&BZ'#IUNG[M`V!T']:T+/3X+*,+&@SUS5RMH4U#8SE)RW"BBB
MK)"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`@GM8+DH9HU<H<J2.E2JH10JC`'04ZB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
4H`****`"BBB@`HHHH`****`/_]DH
`


#End