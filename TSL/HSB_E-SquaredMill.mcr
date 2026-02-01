#Version 8
#BeginDescription
Last modified by: Robert Pol (support.nl@hsbcad.com)
07.01.2022  -  version 1.11

























#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 11
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl makes mills created by a specified beam squared.
/// </summary>

/// <insert>
/// Select a set of elements. The tsl is reinserted for each element.
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.10" date="14.05.2018"></version>

/// <history>
/// AS - 1.00 - 01.07.2013 -	Pilot version
/// AS - 1.01 - 02.07.2013 -	Supports a list of beamcodes now.
/// AS - 1.02 - 02.07.2013 -	Add filter
/// AS - 1.03 - 10.09.2013 -	Add logging.
/// AS - 1.04 - 27.09.2013 -	Add gap in squared direction
/// AS - 1.05 - 30.09.2013 -	Add option to square off beams at shortest point.
/// AS - 1.06 - 23.03.2015 -	Improve usage of catalogs from toolpalette (FogBugzId 1017)
/// AS - 1.07 - 22.12.2016 -	Update summary.
/// RP - 1.08 - 10.01.2016 -	Check if angle between beams greater then zero, otherwise possible /0...
/// AS - 1.09 - 09.11.2017 -	Milling beam can now also be a sheet.
/// AS - 1.10 - 14.05.2018 -	Milling needs to be applied with gap to all beams
//#Versions
//1.11 07/01/2022 Restore previous version, there was a bug that the milling was only moving, not applying the gap. Author: Robert Pol

/// </history>

//Script uses mm
double dEps = U(.001,"mm");

int arNAtBeamEnd[] = {10,1};
int arNYesNo[] = {_kYes, _kNo};
String arSYesNo[] = {T("|Yes|"), T("|No|")};


PropString sSeperator02(3, "", T("|Filter|"));
sSeperator02.setReadOnly(true);
PropString sFilterBC(4,"","     "+T("|Filter beams with beamcode|"));


PropString sSeperator01(0, "", T("|Squared mill|"));
sSeperator01.setReadOnly(true);
PropString sBmCodeMill(1, "KK-05", "     "+T("|Beamcode|"));
PropDouble dMillingGap(0, U(1), "     "+T("|Gap|"));
PropString sAtBeamEnd(2, arSYesNo, "     "+T("|Mill at the end of the beam|"));
PropString sCutBeamAtShortestPoint(5, arSYesNo, "     "+T("|Square off beam at shortest point|"));

if( _Map.hasString("DspToTsl") ){
	String sCatalogName = _Map.getString("DspToTsl");
	setPropValuesFromCatalog(sCatalogName);
	
	_Map.removeAt("DspToTsl", true);
}


// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_E-SquaredMill");
if( arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

//Insert
if (_bOnInsert) {
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	
	//Select beam(s) and insertion point
	PrEntity ssE(T("|Select one or more elements|"), Element());
	if (ssE.go()) {
		Element arSelectedElements[] = ssE.elementSet();
		
		//insertion point
		String strScriptName = "HSB_E-SquaredMill"; // name of the script
		Vector3d vecUcsX(1,0,0);
		Vector3d vecUcsY(0,1,0);
		Beam lstBeams[0];
		Entity lstEntities[1];
		
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		Map mapTsl;
		mapTsl.setInt("MasterToSatellite", true);
		setCatalogFromPropValues("MasterToSatellite");
		
		for( int i=0;i<arSelectedElements.length();i++ ){
			Element el = arSelectedElements[i];
			if( !el.bIsValid() ){
				continue;
			}
			lstEntities[0] = el;
			
			TslInst tsl;
			tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
		}
	}
	
	eraseInstance();
	return;
}
// set properties from master
int bManualInsert = false;
if( _Map.hasInt("MasterToSatellite") ){
	int bMasterToSatellite = _Map.getInt("MasterToSatellite");
	if( bMasterToSatellite ){
		int bPropertiesSet = _ThisInst.setPropValuesFromCatalog("MasterToSatellite");
		_Map.removeAt("MasterToSatellite", true);
	}
	
	bManualInsert = true;
}

// check if there is a valid element present
if( _Entity.length() == 0 ){
	eraseInstance();
	return;
}

// get selected element
Element el = (Element)_Entity[0];
if( !el.bIsValid() ){
	eraseInstance();
	return;
}

String sFBC = sFilterBC + ";";
sFBC.makeUpper();
String arSExcludeBC[0];
int nIndexBC = 0; 
int sIndexBC = 0;
while(sIndexBC < sFBC.length()-1){
	String sTokenBC = sFBC.token(nIndexBC);
	nIndexBC++;
	if(sTokenBC.length()==0){
		sIndexBC++;
		continue;
	}
	sIndexBC = sFBC.find(sTokenBC,0);
	sTokenBC.trimLeft();
	sTokenBC.trimRight();
	arSExcludeBC.append(sTokenBC);
}

String sBCMill = sBmCodeMill + ";";
sBCMill.makeUpper();
String arSBCMill[0];
nIndexBC = 0; 
sIndexBC = 0;
while(sIndexBC < sBCMill.length()-1){
	String sTokenBC = sBCMill.token(nIndexBC);
	nIndexBC++;
	if(sTokenBC.length()==0){
		sIndexBC++;
		continue;
	}
	sIndexBC = sBCMill.find(sTokenBC,0);

	arSBCMill.append(sTokenBC);
}

int nAtBeamEnd = arNAtBeamEnd[arSYesNo.find(sAtBeamEnd,0)];
int bCutBeamAtShortestPoint = arNYesNo[arSYesNo.find(sCutBeamAtShortestPoint,0)];

// coordinate system of this element
CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();
_Pt0 = ptEl;

GenBeam arGBm[] = el.genBeam();
GenBeam arBmMill[0];
Beam arBmOther[0];
for( int i=0;i<arGBm.length();i++ ){
	GenBeam gBm = arGBm[i];
	String sBmCode = gBm.beamCode().token(0).makeUpper();
	
	if( arSExcludeBC.find(sBmCode) != -1 )
		continue;
	
	if( arSBCMill.find(sBmCode) != -1 )
	{ 
		arBmMill.append(gBm);
	}
	else// if( bm.type() == _kDakCenterJoist || bm.type() == _kCantileverBlock )
	{
		Beam bm = (Beam)gBm;
		if (bm.bIsValid())
		{
			arBmOther.append(bm);
		}
	}
}

Beam arBmToCut[0];
int nNrOfModifiedBmCuts = 0;
for( int i=0;i<arBmMill.length();i++ )
{
	GenBeam bmMill = arBmMill[i];
	Body bdBmMill = bmMill.realBody();//envelopeBody(false, true);
	bdBmMill.vis(6);
	Point3d ptBdBmCut = bmMill.ptCenSolid();
	Vector3d vxBdBmCut = bmMill.vecX();
	Vector3d vzBdBmCut = vzEl;
	if( vzBdBmCut.dotProduct(ptEl - vzEl * 0.5 * el.zone(0).dH() - ptBdBmCut) > 0 )
		vzBdBmCut *= -1;
	Vector3d vyBdBmCut = vzBdBmCut.crossProduct(vxBdBmCut);
	double dLBdBmCut = bmMill.solidLength();
	double dWBdBmCut = bmMill.dD(vyBdBmCut);
	double dHBdBmCut = bmMill.dD(vzBdBmCut);

	Body bdBmCut(ptBdBmCut - .5 * vzBdBmCut * dHBdBmCut, vxBdBmCut, vyBdBmCut, vzBdBmCut, dLBdBmCut, dWBdBmCut, 2 * dHBdBmCut, 0, 0, 1);
	bdBmCut.vis(4);
	for( int j=0;j<arBmOther.length();j++ ){
		Beam bmOther = arBmOther[j];
		Body bdOther = bmOther.envelopeBody(false, true);
		bdOther.vis(3);
		if( bdBmMill.hasIntersection(bdOther) && bdOther.hasIntersection(bdBmCut) ){
			bdOther.intersectWith(bdBmCut);
			if( bdOther.volume() == 0 ){
				Body bdTmp = bdBmCut;
				bdTmp.intersectWith(bmOther.envelopeBody(false, true));
				bdOther = bdTmp;
			}
			if( bdOther.volume() == 0 )
				continue;
			
			bdOther.vis(1);
			Vector3d vzBmCut = vzEl;
			Vector3d vyBmCut = bmOther.vecX();
			Vector3d vxBmCut = vyBmCut.crossProduct(vzBmCut);
			
			Line lnX(bmOther.ptCen(), vxBmCut);
			Line lnY(bmOther.ptCen(), vyBmCut);
			Line lnZ(bmOther.ptCen(), vzBmCut);
			
			Point3d arPtBdOther[] = bdOther.allVertices();
			Point3d arPtBdOtherX[] = lnX.orderPoints(arPtBdOther);
			Point3d arPtBdOtherY[] = lnY.orderPoints(arPtBdOther);
			Point3d arPtBdOtherZ[] = lnZ.orderPoints(arPtBdOther);
			if( arPtBdOtherX.length() < 1 || arPtBdOtherY.length() < 1 || arPtBdOtherZ.length() < 1 ){
				reportNotice(TN("|Invalid body|"));
				continue;
			}
			
			double dAngleBetweenBeams = vyBmCut.angleTo(vxBdBmCut);
			if (dAngleBetweenBeams < dEps)
				continue;
			
			double dLBmCut = bdOther.lengthInDirection(vxBmCut);
			double dWBmCut = bdOther.lengthInDirection(vyBmCut) + dMillingGap/sin(dAngleBetweenBeams);
			double dHBmCut = bdOther.lengthInDirection(vzBmCut);//bmBlocking.dD(vzBmCut);
			
			Point3d ptBmCut = arPtBdOtherY[0] + vyBmCut * .5 * dWBmCut;
			ptBmCut += vxBmCut * vxBmCut.dotProduct(arPtBdOtherX[0] + vxBmCut * .5 * dLBmCut - ptBmCut);
			ptBmCut += vzBmCut * vzBmCut.dotProduct(arPtBdOtherZ[0] + vzBmCut * .5 * dHBmCut - ptBmCut);
			
			vyBmCut.vis(ptBmCut, 3);
			
			double dFlagZ = 1;
			if( vzBmCut.dotProduct(bmOther.ptCen() - ptBmCut) > 0 )
				dFlagZ *= -1;
			
			double dFlagY = 1;
			if( vyBmCut.dotProduct(bmOther.ptCen() - ptBmCut) > 0 )
				dFlagY *= -1;
			
			ptBmCut -= vzBmCut * dFlagZ * .5 * dHBmCut;
			ptBmCut.vis(1);
			ptBmCut -= vyBmCut * dFlagY * .5 * dWBmCut;
			ptBmCut.vis(3);

			if( dLBmCut < dEps || dWBmCut < dEps || dHBmCut < dEps )
				continue;
			
			BeamCut bmCut(ptBmCut - vzBmCut * dFlagZ * U(0.0001), vxBmCut, vyBmCut, vzBmCut, 2 * dLBmCut, nAtBeamEnd * dWBmCut, 2 * dHBmCut + U(0.001), 0, dFlagY, dFlagZ);
			bmCut.cuttingBody().vis();
			bmOther.addToolStatic(bmCut);
			
			if (bCutBeamAtShortestPoint) {
				if (arBmToCut.find(bmOther) == -1)
					arBmToCut.append(bmOther);
			}
			
			nNrOfModifiedBmCuts++;
		}
	}
}

for( int i=0;i<arBmToCut.length();i++ ){
	Beam bmToCut = arBmToCut[i];
	Vector3d vxBm = bmToCut.vecX();
	if( vxBm.dotProduct(vxEl + vyEl) < 0 )
		vxBm *= -1;
	Line lnX(bmToCut.ptCen(), vxBm);

	Point3d arPtBm[] = bmToCut.envelopeBody(false, true).allVertices();
	Point3d arPtBmX[] = lnX.orderPoints(arPtBm);
	if( arPtBmX.length() < 2 )
		continue;
	Point3d ptMin = arPtBmX[0];
	Point3d ptMax = arPtBmX[arPtBmX.length() - 1];
	
	double dDistMin = 0;
	double dDistMax = 0;

	AnalysedTool tools[] = bmToCut.analysedTools();
	AnalysedCut cuts[] = AnalysedCut().filterToolsOfToolType(tools);
	for( int j=0;j<cuts.length();j++ ){
		AnalysedCut aCut = cuts[j];
		Point3d arPtCut[] = aCut.bodyPointsInPlane();
		PLine plCut;
		aCut.ptOrg().vis(j);
		double dy = bmToCut.vecY().dotProduct(bmToCut.ptCen() - aCut.ptOrg());
		double dz = bmToCut.vecZ().dotProduct(bmToCut.ptCen() - aCut.ptOrg());
		
		plCut.createConvexHull(Plane(aCut.ptOrg(), aCut.normal()), arPtCut);
		double dArea = plCut.area();
		if( dArea < U(50) )//|| abs(dy) > U(200) || abs(dz) > U(200) )
			cuts.removeAt(j);
	}
		 
	// bottom/left side
	int nIndCutClosest = AnalysedCut().findClosest(cuts, ptMin);
	if( nIndCutClosest >= 0  && abs(dDistMin < U(400)) ){
		AnalysedCut cut = cuts[nIndCutClosest];
		Point3d ptOrgClosest = cut.ptOrg();
		
		ptOrgClosest.vis(1);
		cut.normal().vis(ptOrgClosest, 1);
		
		Point3d arPtCut[] = cut.bodyPointsInPlane();			
		Point3d arPtCutX[] = lnX.orderPoints(arPtCut);
		if( arPtCutX.length() > 1 ){
			Point3d ptShortest = arPtCutX[arPtCutX.length() - 1];ptShortest.vis();
			Point3d ptLongest = arPtCutX[0];ptLongest.vis();
			
			ptShortest.vis(1);
			
			// Cut at shortest point
			Cut cut(ptShortest, -vxBm);
			bmToCut.addToolStatic(cut, _kStretchOnInsert);
		}
		
		cuts.removeAt(nIndCutClosest);
	}
}

if( _bOnElementConstructed || bManualInsert ){
	reportMessage(TN("|Mills are corrected|! ") + nNrOfModifiedBmCuts + T(" |mills changed for element| ") + el.number()+".");
	eraseInstance();
}






















#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`+^`[T#`2(``A$!`Q$!_\0`
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
M@`HHHH`2BBO'_B!XFF\3ZT/!>A7LJ6<>X:[=0*/D7M`'SC)(8,`#Z<@.M3*2
MC%RELAQBY.R(?%GBNY\>W=QX<\.7+0^'X6\O4M4B/-R>\,)[KZMT(_V<"2U8
MV-KIUG#:6<*PV\*[4C7H!_4]R3R3S18V-KIUG#:6<*PV\*[4C7H!_4]R3R3S
M5BO`Q6*E7E9;'JT:*IKS"BBBN0V"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`*9++'!"\TTBQQ(I9W<X"@<DD]A1++'!"\TTBQQ(I9W<X"@<DD]A7G^
MN:Y)K4P1`T>GHP*1L,&4CH[CL.X4].IYP%[<'@YXJ?+';J^QG5JJFKL-<UIM
M;N(]BE+*%]\*LN&=L%=[=QP2`OH<GG`7,HHK[/#T(4*:A!:'FRDY.[/JNBBB
MO+,0HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@!***\N\>^,=2NM6F\'>&&DM[Q44ZEJ>T@6<;C(5/61E.01TSP<Y*3
M*2BKO8:3D[(C\;>-KW4=1G\(>$+C;=I\NIZJO*V2]"B$=93R./N\@8()2CHV
MC6.@Z;'8V$6R).2QY9V[LQ[D_P#UA@`"C1M&L=!TV.QL(MD2<ECRSMW9CW)_
M^L,``5?KPL7BW5?+'X3U*%!4U=[A1117$;A1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%<+XB\0?VIOLK)_\`0.DDH/\`K_8?],_?^+_=^_TX7"U,
M34Y(?-]B*E105V0:_K9UBZ:&&0'3H7'E[#Q<,,'>?50>%'3C=SE<95%%?;8;
M#PP]-4X?\.>9.3D[L*J7>I6=BZI<S*K,,@$$G'X"K]C8ZAK.JP:1I$`N-0G&
MX!CA(D'!DD/\*#\R<`9)KZ`\&^#+#P?I)M[9FGO)B'O+QU`>X<=\?PJ.0JC@
M#U)),UJ_)HMR&['3T445YQ`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!245YYX\\>W&FW7_",^&A'<>(YTRSGF.PC/_+23
MJ-V""%/J"0<JKIM15V-)MV0>//'MQIMU_P`(SX:$=QXCG3<SMS'81G_EI)U&
M[!!"GU!(.55^8T'0K?0K215DDN;N=_-NKN8YDN)#R68G)ZDX&>YZDDDT'0;?
M0K215DDN;N=_-NKN8YDN)#R68G)ZDX&>YZDDG6KP\7BW5?+'X?S/3H4%!7>X
M4445P'0%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`445R/B/Q&Q>33M
M.E*[24N+E#@J>Z(?[W8M_#T'S9*]&'P]3$5%""U)G-05V4_$7B#^U-]E9/\`
MZ!TDE!_U_L/^F?O_`!?[OW\.D551%1%"JHP`!@`4M?:X7"T\-3Y(_P##GF3F
MYN["I+&QU#6=5@TC2(/M&H3C<`QPD*#@R2'^%!^9.`,DU$JW%Q=V]C96TEU?
M7+^7!;1_>D;K]`H')8\`#)KWSP#X,_X0_1I([B6&XU.[D$UY/&@5=P`"HIQD
MHH'&[G)8\;L`KUN166YFW8L^#/!MAX.TDV]LQGO)R'O+R1</<.._^RHY"J.`
M/4DD]/117G$!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%)17%^._'<?A6&"PL81?>(;T8L[('Z_O)/[J#![C.",@!F5-I*
M[#<B^(/CA?#5BNEZ:'N?$>H1LEC;Q;2T9((\Y\@@*O)Y&"5(Z!BO$^&=!_L+
M3B)Y!<:E<.9KR[)+--(23DLW)QG&>_)P"31H6A2V4]SJFJ71O]=O3NNKQ^_^
MPG]U!@```=!P``!MUXF,Q?M'R1^'\STL/0Y/>EN%%%%>>=04444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!117*^*]<>)1IFGW&RY)'VB11S%'C.T$'AV
MX]P"3P2N=J%"=>HH0W9,YJ"NR/Q'XC8O)IVG2E=I*7%RAP5/=$/][L6_AZ#Y
MLE>6551%1%"JHP`!@`4*JHBHBA548``P`*6OM<'@Z>&I\L=^K[GFU*CF[L*1
M5N+B[M[&RMY+J^NG\NWMH_O2-U^@4#DL>`!DTR641!`$DDDD<1Q11*6>5R<*
MJJ.2Q/05[I\.O`T7A;3A?WL9DUZ\B4W<KX/D@X/DI@D!5/4@G<1DGH!=>M[-
M66YDW8E\`^`K?PA:/=73I=:W<J!<W2CY47KY46>0@/XL1D]@.VHHKS6VW=D!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%<OXS\9V'@O2ENKG=/>7#>796,7^LN9/[H'.!R,MCC(ZD@$`I_$/QLO@G08Y
MH+<7FJ7DOV>QM<\LY'WBH.XJ.,[>264<;LC@]"T*6QFN-4U2Z-_KMZ=UU>/W
M_P!A/[J#````Z#@``"/2]+O[W5I/$WB65;C7+A=J(O\`JK*/G$48YQU.3[GD
MY9FWZ\;&XOG?)#;\ST</0Y?>EN%%%%>8=84444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!117.^)=??3S]ALSB]DC#F0C(A0D@,`>"Q*G`Z#!)[!M:-&=
M::IP6K)E)15V-\1^(S9%K"P8&](_>28!%N"/R+D<@=NIXP&XQ5"C`R<DDEB2
M22<DDGDDGDD]:%4*,#)R226))))R22>22>23UI:^TP6"AA866K>[/-J5'4=V
M%1RRB((`DDDDCB.**)2SRN3A551R6)Z"ED<HHVQ2RNS!$BB0N\C,0%50.222
M`![U[+\._AX=!VZ[KB))KDB$1Q`ADL4(Y13T+D?>?_@(XR6VK5E37F9-V#X=
M_#LZ"5UW7$237)$(CB!#)8H1RBGH7(^\_P#P$<9+>DT45YK;;NR`HHHI`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!116)XF\2Z
M7X1T2;5M5N!%;Q_*JKR\KGHB#NQP?R))`!(`*/C/QEI_@S25NKG=/>7#>796
M,7^LN9/[H'.!R,MCC(ZD@'S32]+O[S5I/$OB65;C7+A=J(O^JLH^<11CG'4Y
M/N>3EF9+"+4_$/B23Q?X@ACM[N2'R+*Q"@_9(,DC<Q&2YR<GC[S#C.U>@KQ\
M;B[OV<'IU/0PU"WORW"BBBO,.P****0!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`445BZ]KR:3$(80LM](N4C/W47IO?';K@=6(P,`$C2E2G5FH05VQ2DHJ
M[#7M>328A#"%EOI%RD9^ZB]-[X[=<#JQ&!@`D<(SR2RO+-(TLTC9DD?[SMZG
M]!@<```8``H9Y)97EFD:6:1LR2/]YV]3^@P.```,``4E?98#`0PT.\GN_P!$
M>;5JNH_(*CFFCMX7EE<*BC+,>U$TT=O"\LKA4499CVKU+X<_#F3SH/$GB2W*
M3H1)I^GR#_CW])91_P`]?1?X/][[O55JJFO,Q;L'PY^',GG0>)/$=N4G0B33
M]/D'_'OZ2RC_`)Z^B_P?[WW?7:**\R4G)W9`4444@"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHK/U75++0]+N-2U.Y2VL[=-\
MDK]%'\R2<``<DD`9)H`I^)O$NE^$M$FU;5;@16\?RJJ\O*YZ(@[L<'\B20`2
M/)((-3\6:VGB?Q.GE.F?[-TO.4LT/.YO60X!)([#IA51EI)=>-]>;Q9K*S"W
MBD8:+9R(%6&'(*RE<G+MP<GN,C(V;>EKR<;C+7IP^9WX;#_;D%%%%>2=H444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1169K6LPZ-:"1QYL\F1#`#@N
M1U)/91D9/;(ZD@&X0E.2C%7;$VDKL-:UF'1K02./-GDR(8`<%R.I)[*,C)[9
M'4D`^>.\DTTL\S[YII#)(WJ3V&<G`&`!DX``[5)<7%Q>7+W-U)YL[XW-C``'
M15'91DX'N2<DDF.OL,NR]8:/-+63W_R/.K574?D%(S*B,[L%51DDG``H9E1&
M=V"JHR23@`5V_P`/OAZWB1X-=UZW*Z,I$EG92+@WAZB60'_EEW53]_J?EP&[
MJM54U=F+=BU\+O!4NI7UOXJU:T46,2[],@F4[I')&+@KG```.S().[=QA2?:
MZ**\R4G)W9F%%%%2`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%5-0OK?3=.N;^[D\NVMHGFE?:3M102QP.3@`]*`(=5U2RT32
M[C4=2N4MK.W3?)*_11_,DG``'))`&2:\9NKN^^).JPZMJL#V_ARW??INF2=9
MCVGF'0Y'1>F#CD$ERZN[[XDZK#JVJP/;^'+=]^FZ9)UF/:>8=#D=%Z8..027
MZ*O,QF,Y?W=/YL[</A[^_,****\<[PHHHI`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!11534M2M]*LVN;AC@<(B\M(W95'<\'V`!)P`350@YOECN#:2NR+
M6=5CT;3FNG3S'+!(H@V#(YZ#Z=2<`X`)P<5Y[<7%Q>7+W-U)YL[XW-C``'15
M'91DX'N2<DDE]]?7.IWAN[LC?@K'&IRL2_W5]>@R>I([``""OK\LR]8>///X
MG^'D>=6J\[LM@HHKI/`_@>;QK/\`:[OS(O#D3$.ZDJU^P.#&A'(C!X9QUY5>
MY'HU*BIJ[,&[%[X<>!XO%LQUO5%$NBVTVRWMBIVWDBXR[DC#1*>`!D,RG/`P
M?>:KV]O#:V\5O!%'#!$H2.-%"JB@8``'``'&*L5Y<YN;NS,****D`HHHH`**
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
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBL77M>328A#"%EOI%RD9^ZB]-[
MX[=<#JQ&!@`D:4J4ZLU""NV*4E%79#XEUV335CL[0@7<Z%O,X/DIG&[']XG(
M7/'#'G;@\0JA1@9.222Q))).223R23R2>M.9I)97EFD:6:1LR2/]YV]3^@P.
M```,``4E?9X#!1PM.WVGNSS:M1U'<*1F"C)R<D`!0222<``#DDG@`=:&8*,G
M)R0`%!)))P``.22>`!UKL_#GAPV16_OU!O2/W<>01;@C\BY'!/;H.,EJQN-A
MA87>K>R%3INH[(D\-:%)IJR7EV,7<Z!?+X/DIG.W/]XG!;''"CG;D]!117Q=
M:M.M-U)[L].,5%605SD$/]F77]F'B$(7L^_[E0H*D^JE@.>JE>6.XCHZI:MI
MW]IV+0+,UO,K!X)T4,T3CH0#U'4$=U)'>JH5.25GLQ35UH5:P-7O+S3=22.P
MN/L_VV)GF8*&(,94!E!^4,0X!)!R$4#&,UL6MP;B-M\?E2QR-')'G.U@?P."
M,,"0,JRG`S6#XC_Y#&G?]>]Q_P"A15ZF&@I55&2NCGJ.T;HS4B5&=_F:23&^
M61B[OCIN8Y)QT&3Q4E%%?0**2LCE"BBBF`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`'I5%%%?!GJ!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1169K6LPZ-:"1QYL\F1#`#@N1U)/91D9/;(ZD@&X0E.2C%7;$
MVDKL@U[7DTF(0PA9;Z1<I&?NHO3>^.W7`ZL1@8`)'",\DLKRS2-+-(V9)&^\
M[>I_08'```&``*6666YN9KJX96N)WWR,J[03@`8'8```?3DDY);7V67X".&A
M=_$]W^AYU6JZC\@I&941G=@JJ,DDX`%#,J(SNP55&22<`"NI\.>'&+QZCJ,1
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
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHI@%>>:UKS:ZZK"2NG*0\:]#,>H=O;NJ]NIYP%L^(O$']J;[*R?_0.DDH/
M^O\`8?\`3/W_`(O]W[^'7TN5Y;R_OJRUZ+]3BKUK^[$***JW-RZR);6R"6[D
M&40]%']]O11^O05[[:2NSD"YN761+:V02W<@RB'HH_OMZ*/UZ"KUC9I8VJ1)
M\S=9'[R.>K'W--L;%+*-OG,L\AW33,.7/]`.P[5:KG;<G=EI!1112&%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110!Z51117P9Z@4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%<+XB\0?
MVIOLK)_]`Z22@_Z_V'_3/W_B_P!W[]CQ5KB72RZ3:/N3=MNI@>#@\Q+Z],-V
MQE>23MYNOHLKRU.U:LO1?J<>(K?9B%%%5[JZ%LJ*J&6>4[8H5ZN?Z`=SVKZ-
MM)79QB7ERT*)'"%:XE8)$C9Y/<G'.`.3]*MV-BEE&WSF6>0[IIF'+G^@'8=J
MCL+`P,UQ<.)+N48=P.%']Q?11^O4U>KGE)R=V4D%%%%(H****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`]*HHHKX,]0****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*Y'Q'XC8O)IVG2E=I
M*7%RAP5/=$/][L6_AZ#YLE7>*?$$T-PVDV19'\L-<7",,Q@](UP<AR.2>H!&
M.6!'**JHBHBA548``P`*^@RO+.>U:JM.B[G)7KV]V(*JHBHBA548``P`*6BH
M;FYCM8?,DR<D*JJ,L['HH'<FOI6U%'&-NKH6RHJH99I3MBA7JY_H!W/:IK"P
M,#-<7#B2[E&'<#A1_<7T4?KU--L+.82F\NSB=UVK&K96%.#M]SP,GVXXK0KG
ME+F=QI!1112*"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@#TJBBBO@SU`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"N;\1^(S9%K"P8&](_>28!%N"/R+D<@=NIXP&/$?B,V6ZPL&!O
M2/WDF`1;@C\BY'(';J>,!N,50HP,G)))8DDDG)))Y))Y)/6O;RS+?:VJU5[O
M1=_^`<M>O;W8[@JA1@9.222Q))).223R23R2>M+14<TT=O"TLK!4499CVKZK
M2*.(;<W,=K#YDF3DA551EG8]%`[DTMC8R&47MZ`;@@A(P<K`I[#U8]S^`XIN
MGVK22?VA=JXF;(AC<8\E#TX_O$8)/7MQ6G7/*7-Z#2ZA1112*"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BK.FZ7JFN-(NCZ;<:@8B1(T.U8T(QE3(Y5-PR/ESNP<XQS
M7H6A_"13B;Q'>^:?^?.RD9(^X^:7AV_A(VA,'(.X5G*I&)+DD>;6T,]]?+8V
M-M-=WC@%8($W-@G&X]E7)`W-A1GDBNQT[X5^(-1@\V]N+;2O[D+QBZDZD'=M
M=57H",,^0>=I&*]:TG1=.T.R%GIEE%:P9W,L:X+M@#<QZLQ`&6))..2:TJPE
M6D]B'-GE5%%%?''LA1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`5BZ]KR:3&(80LM](N4C/W47IO?';K@
M=6(P,`$@U[7DTF(0PA9;Z1<I&?NHO3>^.W7`ZL1@8`)'",\DLKRS2-+-(V9)
M'^\[>I_08'```&``*]C+<M==^TJ?#^?_``#GKU^7W8[C1G+,[EW=VD=CC+,Q
M+,>..22>.*6BF2R)#$\LAPB*68XZ`=:^M24%9;'`)--';PM+*P5%&68]JCM+
M66[F2\O(RBH=T%NW\'^V_P#M>@_A^M%I:RW<R7EY&45#N@MV_@_VW_VO0?P_
M6M2L)2YO0:04445)04444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%-9E5D0Y+NXC1%!+2.>BJHY9CV`Y
M-`#J1W6-&=V"HHRS,<`#U-=1H_P\\2ZRRM-;+I-JRAA/>`.Y!!(VPJV<\`$.
M4(ST)!%>CZ+\./#FB30W/V>2^O8CN6XO7\PA@V58)PBL,`!E4'CKR<Y2K16Q
M#FD>4:/X4\0Z^D<NFZ8XM9/NW=V_DPD8W`C.792",,J,IR.>I'HVC_"C1K0*
MVL32:K<!@V&S#`,$\>4K?,",9$A<'!P`"17H5)7/*I*1#DV06]O#:V\5O!%'
M#!$H2.-%"JB@8``'``'&*L445!(4444`>54445\F>X%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%96OZRFCV#
M,A5KR56%M$PSN;'4C(^49&3^`Y(!=K6LPZ-:"1QYL\F1#`#@N1U)/91D9/;(
MZD@'@+BXN+RY>YNI/-G?&YL8``Z*H[*,G`]R3DDD^KEV72Q$N>6D5^/D85JW
M(K+<8S222O+-(TLTC9DD?[SMZG]!@<```8``I**1F5$9W8*JC)).`!7UZ2@K
M+8\\&941G=@JJ,DDX`%5((#K#++*I6P4YCC88,Q[,P_N^@[]3V%$$)UAEEE4
MK8*<QQL,&8]F8?W?0=^I["MBL9SYM%L-*X4445)04444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4459TW2]4UQI
M%T?3KB_,1(D:':L:$8RID<JFX9'RYW8.<8YI-I;@W8K4ZVAGOKY;&QMIKN\<
M`K!`FYL$XW'LJY(&YL*,\D5Z3H?PD4XF\1WOFG_GSLI&2/N/FEX=OX2-H3!R
M#N%>A:3HNG:'9"STRRBM8,[F6-<%VP!N8]68@#+$DG')-8RKK[)FY]CRO0_A
M9J^H;9=:G_LN#_GA"4DN3U'+<QIR`>/,R#_":](T/PCH7AQVETO3DBG<%6G=
MVEEVG'R^8Y+;<J#MSC/.,UO4E82DY;D-MBT445(@HHHH`****`"BBB@#RJBB
MBODSW`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"LS6M9AT:T$CCS9Y,B&`'!<CJ2>RC(R>V1U)`-C4M2M]*LVN;AC@
M<(B\M(W95'<\'V`!)P`37G=]?7.IWAN[LC?@K'&IRL2_W5]>@R>I([``#T\N
MP$L3.\OA6_\`D8UJO(K+<9<7%Q>7+W-U)YL[XW-C``'15'91DX'N2<DDF.BB
MOL80C"*C%62/.;OJPJBBC5[A"$#:?$^69LXG8=@.Z@\DG@D8I%5M8<HK%=/4
MXD=3@S'NJG^[ZGOT'<UM(BQHJ(H5%&%51@`>@K*<^;1;`E<6BBBH+"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**:S
M*K(AR7=Q'&B@EI'/154<LQ[`<FNIT?X>>)=996FMUTFU90PGO`'<@@D;85;.
M>`"'*$9Z$@BIE-1W$VD<N[K&C.[!4499F.`!ZFMC1_"GB'7TCETW3'%K)]V[
MNW\F$C&X$9R[*01AE1E.1SU(]7T7X<>'-%FAN?L\E]>1'<MQ>OYA#!LJP3A%
M88`#*H/'7DY[&L)5WT(<^QY[H_PHT:T"OK$TNJW`8-ALPP#!/'E*WS`C&1(7
M!P<``D5W5O;PVMO%;P11PP1*$CC10JHH&``!P`!QBK%%8MM[F=PHHHI`%%%%
M`!1110`4444`%%%%`!1110!Y51117R9[@4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%5-2U*WTJS:YN&.!PB+RTC=E4=SP?8
M`$G`!-2W=W!96LES<RB.*,99CS[``#DDG``'))`%>;ZC?S:KJ,EY,&5?NP1,
M0?)3CCCC)(R?P&2%!KT,OP,L54L](K=_H95JJIKS$OKZYU.\-W=D;\%8XU.5
MB7^ZOKT&3U)'8``0445]G3IQIQ4(*R1YK;;NPJD4_M2YDM0W^B18$[+G+M_S
MS![#^]CGD#CFE=I;^X>UM7,<:';/<+_#_L)_M>I_A^M:D$$=M`L,*!(U&%4=
MJSG.^B!*X]$6-%1%"HHPJJ,`#T%+114%A1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`459TW2]4UQI%T?3;C4#$2)&AVK&A&,
MJ9'*IN&1\N=V#G&.:]"T/X2*<3>([WS3_P`^=E(R1]Q\TO#M_"1M"8.0=PK.
M52,27)(\VMH9[Z^6QL;::[O'`*P0)N;!.-Q[*N2!N;"C/)%=OH?PLU?4,2ZU
M/_9<'_/"$I)<'J.6YC3D`\>9D'^$UZII.BZ=H=D+/3+**U@SN98UP7;`&YCU
M9B`,L22<<DUHUA*M)[$.;9A:'X1T+PX[2Z7IR13N"K3N[2R[3CY?,<EMN5!V
MYQGG&:WJ**R("BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`\JHHH
MKY,]P****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*AN
M[N"RM9+FYE$<48RS'GV``')).``.22`*6ZN8;*TFNKA]D,,;22-@G"@9)P.>
M@KSK5=5GUF[$TJF.",GR+<G.SMN;'!<C\`#@=RW=@<#/%3LM$MV95:JIKS#5
MM5GUFZ$TJF.",GR+<G.SMN;'!<C\`#@=RU.BBOLZ-&%&"A!62/.E)R=V%4W:
M6_N'M;5S'&AVSW"_P_["?[7J?X?K2SSRRS_8K,CSL`O(1E85/<^K'L/Q/%:-
MK;I:6Z0H7*KGYG;+,2<DD^I))I3G?W4)*XZ"".V@6&%`D:C"J.U2445F6%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444UF561#DN[B-$4
M$M(YZ*JCEF/8#DT`.I'=8T9W8*BC+,QP`/4UU&C_``\\2ZRRM-;+I-JRAA/>
M`.Y!!(VPJV<\`$.4(ST)!%>CZ+\./#FB30W/V>2^O8CN6XO7\PA@V58)PBL,
M`!E4'CKR<Y2K16Q#FD>4:/X4\0Z^D<NFZ8XM9/NW=V_DPD8W`C.792",,J,I
MR.>I'HVC_"C1K0*VL32:K<!@V&S#`,$\>4K?,",9$A<'!P`"17H5)7/*I*1#
MDV06]O#:V\5O!%'#!$H2.-%"JB@8``'``'&*L445!(4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`>54445\F>X%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4R66."%YII%CB12SNYP%`Y))["B6
M6."%YII%CB12SNYP%`Y))["O/]<UR36I@B!H]/1@4C88,I'1W'8=PIZ=3S@+
MVX/!SQ,^6.W5]C.K55-78:YKDFMS!$#1Z>C`I&PP92.CN.P[A3TZGG`7,HHK
M[+#X>%""A!:'FRDY.["JD\\LT_V*R(\[`+R$96%3W/JQ[#\3Q1=W#AA:VH+W
MDBG:.T8_OMZ`?J>*T+2TBLH!%$#C.YF8Y9V/5F/<FG.?V4)*X6EI%9P"*('&
M=S,QRSL>K,>Y-3T45F6%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
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
MA*27)ZCEN8TY`/'F9!_A->D:'X1T+PX[2Z7IR13N"K3N[2R[3CY?,<EMN5!V
MYQGG&:WJ2L)2<MR&VQ:***D04444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110!Y51117R9[@4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`445BZ]KR:3$(80
MLM](N4C/W47IO?';K@=6(P,`$C2E2G5FH05VQ2DHJ[#7M>328A#"%EOI%RD9
M^ZB]-[X[=<#JQ&!@`D<(SR2RO+-(TLTC9DD?[SMZG]!@<```8``H9Y)97EFD
M:6:1LR2/]YV]3^@P.```,``4E?98#`0PT.\GN_T1YM6JZC\@J.::.WA:65@J
M*,LQ[4]F5$9W8*JC)).`!56VCDU.6.Y??'91L'B3HTI'(=O1>X'?J>U=LY\J
M\S,=:6LMY.EY>1E%0[H+=OX/]M_]KT'\/UK5HHK`I*P4444#"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BFLRJR(
M<EW<1QHH):1ST55'+,>P')KJ='^'GB7665IK==)M64,)[P!W(()&V%6SG@`A
MRA&>A((J934=Q-I'+NZQHSNP5%&69C@`>IK8T?PIXAU](Y=-TQQ:R?=N[M_)
MA(QN!&<NRD$89493D<]2/5]%^''AS19H;G[/)?7D1W+<7K^80P;*L$X16&``
MRJ#QUY.>QK"5=]"'/L>>Z/\`"C1K0*^L32ZK<!@V&S#`,$\>4K?,",9$A<'!
MP`"17=6]O#:V\5O!%'#!$H2.-%"JB@8``'``'&*L45BVWN9W"BBBD`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`'E5%
M%%?)GN!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%9FM:S#HUH)''FSR9$,`."Y'4D]E&1D]LCJ2`
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
2****`"BBB@`HHHH`****`/_9
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
    <lst nm="Version">
      <str nm="Comment" vl="Restore previous version, there was a bug that the milling was only moving, not applying the gap." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="11" />
      <str nm="Date" vl="1/7/2022 9:36:06 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End