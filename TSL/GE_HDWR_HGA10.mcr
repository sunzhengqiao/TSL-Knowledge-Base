#Version 8
#BeginDescription
V1.0__24 May 2023__HGA10 Strong-Tie TSL
#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
Unit (1, "inch");

exportToDxi(TRUE);

String strConnector = "HGA10";

String arFaces[] = { "Front", "Back" };
String arOrientation[] = { "Back", "Bottom" };

int nStr;

PropString pFace(nStr++, arFaces, "Connector Face", 0);
PropString pNailInfo(nStr++, "", "Nail Info");

// Get the beams to connect
if (_bOnInsert)
{
	if (insertCycleCount() > 1)
	{
		eraseInstance();
		return;
	}

	_Beam.append(getBeam("\n Select beam for back of connector."));
	_Beam.append(getBeam("\n Select beam for bottom of connector."));
	_PtG.append(_Pt0);
}

if (_Beam.length() < 2)
{
	reportError("\n Less than 2 beams selected.");
	eraseInstance();
	return;
}

// Initialize the script
Beam bm0 = _Beam0;
Beam bm1 = _Beam1;

// Parent Element
Element el = bm0.element();
Beam arBeams[] = el.beam();
Sheet arSheathing[] = el.sheet();

Display dpCon(7), dpError(1);

// If you couldn't get the parent element for the first beam, try the second
if (!el.bIsValid()) el = bm1.element();

Vector3d vcX = _Y0;
Vector3d vcY = _Z0;
Vector3d vcZ = -_X0;
Vector3d vcMove = _Y0;

// Check the face property
if (pFace == arFaces[1])
{
	vcX = -vcX;
	vcMove = -vcMove;
}

if (_bOnDbCreated)
{
	_PtG[0] = _Pt0 + vcX * _W0 / 2;
}

// Snap the connector the the beams
Line lnSnap = Line(_Pt0 + vcX * _W0 / 2, vcY);

if (_kNameLastChangedProp == "_PtG0" || _kNameLastChangedProp == "Connector Face")
{
	_PtG[0] = lnSnap.closestPointTo(_PtG[0]);
}

// Initialize the connector Body and Map
Body bdConnector, bdBackPlate, bdBottomPlate, bdAngledExtrusion;
Map mpConstructBody;

// Set the start point and begin drawing the strap
Point3d ptLine = _PtG[0];
Point3d arHoles[0];
PLine plBody;

// ----------------------------------------------
// Back Plate
// ----------------------------------------------

// Get the bottom corners of the connector to keep points consistent
Point3d ptLeftCorner, ptRightCorner, ptTopLeftExtr, ptTopRightExtr, ptBotLeftExtr, ptBotRightExtr, ptFrontLeftExtr, ptFrontRightExtr;
ptLeftCorner = ptLine - (U(1.75) * vcY);
ptRightCorner = ptLine + (U(1.75) * vcY);

// Start with the back of the connector, on the XZ plane
ptLine.transformBy(vcY * U(1.125));
plBody.addVertex(ptLine);
ptLine = ptRightCorner;
plBody.addVertex(ptLine);

// Right Edge
ptLine.transformBy(vcZ * U(2.75));
plBody.addVertex(ptLine);

// Top Edge
ptLine.transformBy((vcZ * U(.25) - (vcY * U(.25))));
plBody.addVertex(ptLine);
ptLine.transformBy(-vcY * U(3));
plBody.addVertex(ptLine);
ptLine.transformBy((-vcZ * U(.25) - (vcY * U(.25))));
plBody.addVertex(ptLine);

// Left Edge
ptLine.transformBy(-vcZ * U(2.75));
plBody.addVertex(ptLine);

// Bottom Edge and Extrusion
ptLine.transformBy(vcY * U(0.625));
ptBotLeftExtr = ptLine;										// Set the Bottom Left corner of the extrusion
plBody.addVertex(ptLine);
ptLine.transformBy(vcZ * U(0.0625));
plBody.addVertex(ptLine);
ptLine.transformBy((vcY * U(0.5625)) + (vcZ * U(1.75)));
ptTopLeftExtr = ptLine;										// Set the Top Left corner of the extrusion
plBody.addVertex(ptLine);
ptLine.transformBy(vcY * U(1.125));
ptTopRightExtr = ptLine;									// Set the Top Right corner of the extrusion
plBody.addVertex(ptLine);
ptLine.transformBy((vcY * U(0.5625)) - (vcZ * U(1.75)));
plBody.addVertex(ptLine);
ptLine.transformBy(-vcZ * U(0.0625));
ptBotRightExtr = ptLine;									// Set the Bottom Right corner of the extrusion
plBody.addVertex(ptLine);

// Create the back plate body
bdBackPlate = Body(plBody, vcX * U(0.0625), 1);

// ----------------------------------------------
// Bottom Plate
// ----------------------------------------------

plBody = PLine();

// Left Edge
ptLine = ptLeftCorner;
plBody.addVertex(ptLine);
ptLine.transformBy(vcX * U(1.75));
plBody.addVertex(ptLine);

// Left Corner
ptLine.transformBy((vcX * U(0.25)) + (vcY * U(0.25)));
plBody.addVertex(ptLine);

// Front Edge
ptLine.transformBy(vcY * U(3));
plBody.addVertex(ptLine);

// Right Corner
ptLine.transformBy((-vcX * U(0.25)) + (vcY * U(0.25)));
plBody.addVertex(ptLine);

// Right Edge
ptLine= ptRightCorner;
plBody.addVertex(ptLine);

// Back Edge and Extrusion
ptLine.transformBy(-vcY * U(0.625));
plBody.addVertex(ptLine);
ptLine.transformBy(vcX * U(0.0625));
plBody.addVertex(ptLine);
ptLine.transformBy((vcX * U(1)) + (-vcY * U(0.375)));
ptFrontRightExtr = ptLine;
plBody.addVertex(ptLine);
ptLine.transformBy(-vcY * U(1.5));
ptFrontLeftExtr = ptLine;
plBody.addVertex(ptLine);
ptLine.transformBy((-vcX * U(1)) + (-vcY * U(0.375)));
plBody.addVertex(ptLine);
ptLine.transformBy(-vcX * U(0.0625));
plBody.addVertex(ptLine);
ptLine = ptLeftCorner;
plBody.addVertex(ptLine);

// Create the bottom plate body
bdBottomPlate = Body(plBody, vcZ * U(0.0625), 1);

// ----------------------------------------------
// Angled Extrusion
// ----------------------------------------------
plBody = PLine();

// Left Extrusion Face
ptLine = ptBotLeftExtr + (vcX * U(0.0625)) + (vcZ * U(0.0625));
plBody.addVertex(ptLine);
ptLine = ptFrontLeftExtr + (vcZ * U(0.0625));
plBody.addVertex(ptLine);
ptLine = ptTopLeftExtr + (vcX * U(0.0625));
plBody.addVertex(ptLine);
ptLine = ptBotLeftExtr + (vcX * U(0.0625)) + (vcZ * U(0.0625));
plBody.addVertex(ptLine);

// Create the left side of the angled extrusion body
bdAngledExtrusion = Body(plBody, (vcY * U(0.0625)), 1);

// Right Extrusion Face
plBody = PLine();
ptLine = ptBotRightExtr + (vcX * U(0.0625)) + (vcZ * U(0.0625));
plBody.addVertex(ptLine);
ptLine = ptFrontRightExtr + (vcZ * U(0.0625));
plBody.addVertex(ptLine);
ptLine = ptTopRightExtr + (vcX * U(0.0625));
plBody.addVertex(ptLine);
ptLine = ptBotRightExtr + (vcX * U(0.0625)) + (vcZ * U(0.0625));

bdAngledExtrusion.addPart(Body(plBody, (-vcY * U(0.0625)), 1));

// Front Extrusion Face
plBody = PLine();
ptLine = ptFrontLeftExtr + (vcZ * U(0.0625));
plBody.addVertex(ptLine);
ptLine = ptFrontRightExtr + (vcZ * U(0.0625));
plBody.addVertex(ptLine);
ptLine = ptTopRightExtr + (vcX * U(0.0625));
plBody.addVertex(ptLine);
ptLine = ptTopLeftExtr + (vcX * U(0.0625));
plBody.addVertex(ptLine);
ptLine = ptFrontLeftExtr + (vcZ * U(0.0625));
plBody.addVertex(ptLine);

bdAngledExtrusion.addPart(Body(plBody, (-vcX * U(0.0625))));

// Create the connector body from the two plate bodies and angled extrusion bodies
bdConnector = bdBackPlate;
bdConnector.addPart(bdBottomPlate);
bdConnector.addPart(bdAngledExtrusion);

// Drill in the holes for the connector
Point3d ptDrill;
PLine plDrill;

// Holes drilled into the back plate
ptDrill = ptLeftCorner + (vcY * U(0.375)) + (vcZ * U(0.875));
plDrill.createCircle(ptDrill, vcX, U(0.125));
bdConnector.subPart(Body(plDrill, vcX * U(0.0625), 1));

ptDrill = ptLeftCorner + (vcY * U(0.5)) + (vcZ * U(2.375));
plDrill.createCircle(ptDrill, vcX, U(0.125));
bdConnector.subPart(Body(plDrill, vcX * U(0.0625), 1));

ptDrill = ptRightCorner + (-vcY * U(0.375)) + (vcZ * U(0.75));
plDrill.createCircle(ptDrill, vcX, U(0.125));
bdConnector.subPart(Body(plDrill, vcX * U(0.0625), 1));

ptDrill = ptRightCorner + (-vcY * U(0.5)) + (vcZ * U(2.625));
plDrill.createCircle(ptDrill, vcX, U(0.125));
bdConnector.subPart(Body(plDrill, vcX * U(0.0625), 1));

// Holes drilled into the front plate
ptDrill = ptLeftCorner + (vcX * U(0.875)) + (vcY * U(0.375));
plDrill.createCircle(ptDrill, vcZ, U(0.125));
bdConnector.subPart(Body(plDrill, vcZ * U(0.0625), 1));

ptDrill = ptLeftCorner + (vcX * U(1.625)) + (vcY * U(0.6875));
plDrill.createCircle(ptDrill, vcZ, U(0.125));
bdConnector.subPart(Body(plDrill, vcZ * U(0.0625), 1));

ptDrill = ptRightCorner + (vcX * U(0.625)) + (-vcY * U(0.375));
plDrill.createCircle(ptDrill, vcZ, U(0.125));
bdConnector.subPart(Body(plDrill, vcZ * U(0.0625), 1));

ptDrill = ptRightCorner + (vcX * U(1.5)) + (-vcY * U(0.3125));
plDrill.createCircle(ptDrill, vcZ, U(0.125));
bdConnector.subPart(Body(plDrill, vcZ * U(0.0625), 1));

// Display for Top View
Display dpTop(7), dpLayout(7);

dpTop.addViewDirection(_ZW);
dpTop.textHeight(U(1));
dpCon.showInDxa(true);

String stDisplayTop = "Engineering Components Top", stDisplayModel = "Engineering Components";
String arListDisplays[] = _ThisInst.dispRepNames();
dpTop.showInDispRep(stDisplayTop);
dpLayout.showInDispRep(stDisplayModel);

// Draw the Connectory Body
dpCon.draw(bdConnector);

// Draw the Top View
dpTop.draw("HGA10", _PtG[0], _XW, _YW, 0, 0, _kDeviceX);
dpLayout.draw(bdConnector);

// Assign this connector to the parent element
_ThisInst.assignToElementGroup(el, TRUE, 0, 'Z');

model("HGA10");
material("Simpson HGA10 Strong-Tie");

// Set the Hardware Comp for BOM Output
HardWrComp comps[0];
HardWrComp hdwr("HGA10", 1);

hdwr.setArticleNumber("K060523-00-0000400");
hdwr.setCategory(T("|Connector|"));
hdwr.setDescription("Simpson HGA10 Connector");
hdwr.setManufacturer("Simpson Strong-Tie");
hdwr.setModel("HGA10");
hdwr.setName("HGA10");
hdwr.setQuantity(1);
hdwr.setName("Hardware Connector");

comps.append(hdwr);

_ThisInst.setHardWrComps(comps);

// Set map values for the shop drawings
_Map.setPoint3d("Pt", _PtG[0]);
_Map.setVector3d("Vec", vcX);
_Map.setString("NailInfo", pNailInfo);

if (_bOnDebug)
{
	vcX.vis(_PtG[0], 3);
	vcY.vis(_PtG[0], 3);
	vcZ.vis(_PtG[0], 3);
}
#End
#BeginThumbnail
MB5!.1PT*&@H````-24A$4@``!.P```-["`8```#V@07P`````7-21T(`KLX<
MZ0````1G04U!``"QCPO\804````)<$A9<P``(3<``"$W`3-8GWH````A=$58
M=$-R96%T:6]N(%1I;64`,C`R,3HP,CHP,2`Q,#HS-CHR-C'=AT0``$_P241!
M5'A>[=U+E&17>>#[DU4E4-F,8<CR8N+EB6&Y)W?10BHA$$^W;4"H[^UN'D82
M>MJX+;D-,C:^@%<W#?2E5'HVPL98G1:-P<8@2T)OT]T#KX5'S!AX"&.&594W
M=V2<JLBLB(QS(L[CV_O\?G`J(K,>660*G3C__/;9.[?\6K57T<AUKS]X?.8G
M!X]3\O8W5-6/?O[:^5L````0RYM>\[/9X_T_?N/L$7)V8OX(``````0@V`$`
M``!`(((=``````0BV`$```!`(((=``````0BV`$```!`(((=``````0BV`$`
M``!`(((=``````0BV`$```!`(((=``````0BV`$```!`(((=``````0BV`$`
M``!`(((=``````0BV`$```!`(((=``````0BV`$```!`(((=``````0BV`$`
M``!`(((=``````0BV`$```!`(((=``````0BV`$```!`(((=``````0BV`$`
M``!`(((=``````0BV`$```!`(((=``````0BV`$```!`(((=``````0BV`$`
M``!`(((=``````0BV`$```!`(((=``````0BV`$```!`(((=``````0BV`$`
M``!`(((=``````0BV`$```!`(((=``````0BV`$```!`(((=``````0BV`$`
M``!`(((=``````0BV`$```!`(((=``````0BV`$```!`(((=``````0BV`$`
M``!`(((=``````0BV`$```!`(((=``````0BV`$```!`(((=``````0BV`$`
M``!`(((=``````0BV`$```!`(((=``````0BV`$```!`(((=``````0BV`$`
M``!`(((=``````0BV`$```!`(((=``````0BV`$```!`(((=``````0BV`$`
M``!`(((=``````0BV`$```!`(((=``````0BV`$```!`(((=``````0BV`$`
M``!`(((=``````0BV`$```!`(((=``````0BV`$```!`(((=``````0BV`$`
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
ML"-'@ATE$>Q:$.P$.^(0[)JK7W!_XO=^[^#>0"G2K;CHN7):H3[2^T[,'P_>
MEV+=V]YJ>1$`_:K/8TTY+W5#L"-'@ATE$>Q:$.P$.^(0[-JK7WA_\E.?/)BL
MNR+4S=_>?[YL65%]_/I[WCO[<Q*?=P`HDV!'C@0[2G)B_@A`X5)<2\?G/_?Y
MZC-_\IGJXH4+U85T7+RX_SP=EY_O[3_6QP<_<%/U_M]Z7_6;_^8W9K&N_G/$
M.@``@'Z8L&O!A)T).^(P8;>]IDN,?&X!8'I,V)$C$W:41+!K0;`3[(A#L`,`
MZ(]@1XX$.TIB22P`````!"+8`0```$`@@AT`````!"+8`0```$`@@AT`````
M!"+8`0```$`@@AT`````!"+8`0```$`@@AT`````!"+8`0```$`@@AT`````
M!"+8`0```$`@@AT`````!"+8`0```$`@@AT`````!"+8`0```$`@@AT`````
M!"+8`0```$`@@AT`````!"+8`0```$`@@AT`````!"+8`0```$`@@AT`````
M!"+8`0```$`@@AT`````!"+8`0```$`@@AT`````!"+8`0```$`@@AT`````
M!"+8`0```$`@@AT`````!"+8`0```$`@@AT`````!"+8`0```$`@@AT`````
M!"+8`0```$`@@AT`````!"+8`0```$`@@AT`````!"+8`0```$`@@AT`````
M!"+8`0```$`@@AT`````!"+8`0```$`@@AT`````!"+8`0```$`@@AT`````
M!"+8`0```$`@@AT`````!"+8`0```$`@@AT`````!"+8`0```$`@@AT`````
M!"+8`0```$`@@AT`````!"+8`0```$`@@AT`````!"+8`0```$`@@AT`````
M!"+8`0```$`@@AT`````!"+8`0```$`@@AT`````!"+8`0```$`@@AT`````
M!"+8`0```$`@@AT`````!"+8`0```$`@@AT`````!"+8`0```$`@@AT`````
M!"+8`0```$`@@AT`````!"+8`0```$`@@AT`````!"+8`0```$`@@AT`````
M!"+8`0!0K)MONGGI`0`0V<XMOU;MS9^SQG6O/WA\YB<'CU/R]C=4U8]^_MKY
M6S"^+SS]T^KLN;.SYW??>7>U^^3N[#D`T]`TNKWPT@OS9P?.7'MF]NB\`<>K
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
M=BN8LJ,)T0Z&<33@"7$``#!==;!+2HUV)^:/K)""#`#C2H%N\0```*9K"H,S
M@MT*4]AQA.VE"<S%L@\```#TKXYVB[<U*XE@=XPZVIFR`P```&`H@AULR90=
M````#*_D*3O!;@U3=@`````,2;!K0;1C%5-V````,+Q2I^P$NP9L0$$3HAT`
M``",IZ1H)]BU9,H.````((YZRJXD@EU#INQHPI0=````#*^TI;&"70LVH```
M``"@;X(==,R4'0````ROI"D[P:XE4W8`````]$FPVX)HQRJF[````&!XI4S9
M"78;L`$%38AV````,)Z<HYU@MR53=@````!QU%-V.1/L-F3*CB9,V0$``,#P
M<E\:*]AMP084`````'1-L(.>F;(#``"`X>4\92?8;<F4'0````!=$NPZ)-JQ
MBBD[````&%ZN4W:"70=L0$$3HAT```",)Z=H)]AUS)0=````0!SUE%U.!+N.
MF+*C"5-V````,+S<EL8*=AVR`04`````VQ+L8&"F[````&!X.4W9"78=,V4'
M````P#8$NQZ)=JQBR@X```"&E\N4G6#7`QM0T(1H!P```..)'.T$NYZ9L@,`
M``"(HYZRBTRPZXDI.YHP90<```#CB3IE)]CUR`84`````/%$G[(3[&!DINP`
M``!@>)$WH!#L>F;*#@```(`V!#L(P)0=````#"_JE)U@-P!3=C0AV@$``,!X
M(D4[P6Y@HAT```!`'!$WH!#L!E)/V<%Q3-D!``#`>*),V0EV`[(T%@```"">
M:%-V@AT$8\H.````AA=I`PK!;F"F[``````XCF`'`9FR`P``@.%%F;(3[$9@
MRHXF1#L````8SYC13K`;F6@'````$$>$#2@$NY'44W9P'%-V````,)ZQINP$
MNQ%9&@L````0S]A3=H(=!&?*#@```(8WY@84@MW(3-D!````L$BP@PR8L@,`
M`(#AC35E)]@%8,J.)D0[````&,^0T4ZP"T:T`P```(ACC`TH!+L@ZBD[.(XI
M.P```!C/4%-V@ET@EL8"````Q#/TE)U@!YDQ90<```##&W(#"L$N&%-V````
M`-,FV$&&3-D!``#`\(::LA/L`C)E1Q.B'0```(RGSV@GV`4GV@$```#$,<0&
M%()=4/64'1S'E!T```",IZ\I.\$N,$MC`0```.+I>\I.L(/,F;(#``"`X?6Y
M`85@%YPI.P```(!I$>R@`*;L````8'A]3=D)=ADP94<3HAT```",I\MH)]AE
M1K0#````B*./#2@$NTS44W9P'%-V````,)ZNINP$NPR9L@,```"(H^LI.\$N
M(Z;L:,*4'0````RORPTH!+O,V(`"````H&R"'13(E!T````,KZLI.\$N0Z;L
M:$*T`P``@/%L$^T$N\R)=@````!Q=+$!A6"7*1M0T(0I.P```!C/IE-V@ET!
M3-D!````Q+'ME)U@ES%3=C1AR@X```"&M\T&%()=YFQ``0```%`6P0XFP)0=
M````#&_3*3O!K@"F[`````#*(=@51K1C%5-V````,+Q-INP$NT+8@((F1#L`
M```83]-H)]@5R)0=````0!SUE%U3@EU!3-G1A"D[````&%Z;I;&"76%L0`$`
M``"0-\$.)LB4'0````ROZ92=8%<@4W8`````^1+L"B?:L8HI.P```!A>DRD[
MP:Y0-J"@"=$.````QK,JV@EV$V#*#@```"".>LIN%<&N8*;L:,*4'0````SO
MN*6Q@EWA;$`!````D!?!#C!E!P```"-8-64GV$V`*3L```"`?`AV$R/:L8HI
M.P```!C>LBD[P6XB;$!!$Z(=````C*>.=H+=!)FR`P```(BCGK*K"7838LJ.
M)DS9`0``P/`6E\8*=A-C`PH```"`V`0[X`JF[````&!X]92=8#=!INP`````
MXA+L)DZT8Q53=@```#"\-&4GV$V4#2AH0K0#``"`X0EVF+(#````"$2PFS!3
M=C1AR@X```"&)=A-G`TH`````&(1[("U3-D!``#`<`0[3-D!````!"+8<8AH
MQRJF[````&`8@ATS-J"@"=$.````^B?8<053=@````#C$>RXQ)0=39BR`P``
M@'X)=AQB`PH```"`<0EV0&NF[````*`_@AU7,&4'````,![!#MB(*3L```#H
MAV#'4J;L:$*T`P``@.X)=JPEV@$````,1[!CI7K*#HYCR@X```"Z)=AQ+$MC
M`0```(8EV`%;,V4'````W1'L6,N4'0```,!0JNK_!Q-68PX[8(IL`````$E%
&3D2N0F""



#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="0.03937008" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]" />
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End