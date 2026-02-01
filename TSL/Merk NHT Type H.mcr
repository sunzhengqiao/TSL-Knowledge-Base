#Version 7
#BeginDescription
DE: erzeugt den MERK NHT-Träger Typ H
EN: creates MERK Connector Type H

Version: 1.2   30.05.2006   th@hsbCAD.de
   - minor bugfix
Version: 1.1   04.04.2006   th@hsbCAD.de
DE - neue Eigenschaft Z-Verschiebung
   - neue Darstellung
   - unterstützt hsbBOM und hsbExcel
EN - new option 'Z-Offset'
   - supports hsbBOM and hsbExcel

Version: 1.0   04.04.2002   th@hsbCAD.de

#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 0
#MajorVersion 0
#MinorVersion 0
#KeyWords 
#BeginContents
// basics and props
	U(1,"mm");

	_X1.visualize(_Pt0,1);
	_Y1.visualize(_Pt0,3);
	_Z1.visualize(_Pt0,150);

	double soffset;
	double GF;
	int SStk;
	String sArNY[] = { T("No"), T("Yes")};
	PropString sAutoSelect(1,sArNY,T("Auto Select"),1);
	PropString sDrillNail(0,sArNY,T("Drill Nailhole"));
	PropDouble dSPN(0,U(6,"mm"),T("Diameter Nailhole"));
	PropDouble dZOff(1,0,T("Z-Offset"));
	PropInt nColor (1,9,T("Color"));	
	PropString sDimStyle(2,_DimStyles,T("Dimstyle"));
	
	int dList[]={0};
	dList.setLength(0);
	if (sAutoSelect==sArNY[0]) 
	{
		dList.append(240);
		dList.append(220);
		dList.append(200);
		dList.append(180);
		dList.append(160);
		dList.append(140);
		dList.append(120);
	}
	else if ((_H0>=258) && (_H0<=280)){
		dList.append(240);
		if (_H0<=260)	dList.append(220);
	}
	else if ((_H0>=238) && (_H0<=260)){
		dList.append(220);
		if (_H0<=240)	dList.append(200);
	}
	else if ((_H0>=218) && (_H0<=240)){
		dList.append(200);
		if (_H0<=220)	dList.append(180);
	}
	else if ((_H0>=198) && (_H0<=220)){
		dList.append(180);
		if (_H0<=200)	dList.append(160);
	}
	else if ((_H0>=178) && (_H0<=200)){
		dList.append(160);
		if (_H0<=180)	dList.append(140);
	}
	else if ((_H0>=158) && (_H0<=180)){
		dList.append(140);
		if (_H0<=160)	dList.append(120);
	}
	else if ((_H0>=138) && (_H0<=160)){
		dList.append(120);
	}
	PropInt ListNr(0,dList,"NHT Nr.");

int found=0;
for (int i=0;i<dList.length();i++)
   if(dList[i]==ListNr) found=i;
if (dList[found]==280) {
	GF=280;
	SStk=22;
}
else if (dList[found]==260) {
	GF=260;
	SStk=20;
}
else if (dList[found]==240) {
	GF=240;
	SStk=18;
}
else if (dList[found]==220){
	 GF=220;
	SStk=20;
}
else if (dList[found]==200) {
	GF=200;
	SStk=18;
}
else if (dList[found]==180){
	GF=180;
	SStk=16;
}
else if (dList[found]==160){
	GF=160;
	SStk=14;
}
else if (dList[found]==140){
	GF=140;
	SStk=12;
}
else if (dList[found]==120) {
	GF=120;
	SStk=10;
}
soffset = GF - U(67,"mm");
// Schnitt aufstoßender Stab
Point3d Pt00 = _L0.intersect(_Plf, 0);
Pt00.visualize(130);
Cut firstcut(Pt00,_Z1);
_Beam0.addTool(firstcut,1);

//einige Punkte
Point3d ptm1,ptm2,ptm3,ptm4,ptdr1,ptdr2;
double Var1,Var2,Var3,Var4,Var5,Var6,Var7;
Var1=U(12,"mm");
Var2=U(3.5,"mm");
Var3=U(31.5,"mm");
Var4=U(40,"mm");
Var5=U(25,"mm");
Var6=U(50,"mm");
Var7=U(70,"mm");
ptm1 = _Pt0 + _Z0*(_H0*0.5 + dZOff);
ptm2 = ptm1 - _Z0 * GF;
ptm3 = ptm1 - _Z1 * Var3 - _Y1 * soffset + _Z1 * U(10,"mm") - _Y1 *U(10,"mm");
ptm4 = ptm1 - _X0 * Var3 - _X0 * U(20,"mm") - _X0 * soffset + _Z0 * U(20,"mm");
ptdr1 = ptm1 + _Z1 *Var4 - _X1 * Var5;
ptdr2 = ptm1 + _Z1 * Var4 + _X1 *Var5;

House hs(ptm1,_X1,_Z1,-_Y1,Var7,Var6*2,Var1,0,0,1);
hs.setRoundType(_kRelief);
//hs.cuttingBody().vis(5);
_Beam1.addTool(hs);

// Define metalpart
Body bd;

bd.addPart(Body(ptm1- _Z0 * Var1,ptm2,Var3));
bd.addTool(Drill(ptm1,ptm2,U(26.5,"mm")));
bd.addPart(Body(ptm1,ptm1 - _Z0 * Var1,Var3));
bd.addTool(firstcut);
bd.addPart(Body(ptm1-_Z0*U(6,"mm"),_Z1,_X1,_Z0,Var6,Var7,Var1,1,0,0));

//Drill tube2();
Drill dr1(ptdr1, ptdr1 - _Z0 *Var1,Var2);
Drill dr2(ptdr2, ptdr2 - _Z0 * Var1,Var2);

bd.addTool(dr1);
bd.addTool(dr2);

if (sDrillNail==sArNY[1]) {

Drill bdr2(ptm4,ptm3,dSPN);
_Beam0.addTool(bdr2);
}
Drill bdr1(ptm1,ptm2,Var3);
_Beam0.addTool(bdr1);

model("610 " + GF);//Artikelnummer
dxaout("Name","NHT-Type H " + GF + "/50/70");//Bezeichnung
material(T("Steel, zincated"));
Hardware( T("Screw"), T("Screw"), T("NHT Special Screw"), U(70), U(50), SStk, T("Steel, zincated"), "");
setCompareKey(GF + String(bd.volume()));

//export to dxa if linked to element
	Element el;
	el = _Beam1.element();
	if (el.bIsValid()){
	
		exportWithElementDxa(el);
		Map mapSub;
		mapSub.setString("Name", "NHT-Type H " + GF + "/50/70");
		mapSub.setInt("Qty", 1);
		mapSub.setDouble("Width", Var3);
		mapSub.setDouble("Length", GF);
		mapSub.setDouble("Height", 0);				
		mapSub.setString("Mat", T("Steel, zincated"));
		mapSub.setString("Grade", "");
		mapSub.setString("Info", "");
		mapSub.setString("Volume", "");						
		mapSub.setString("Profile", "");	
		mapSub.setString("Label", "");					
		mapSub.setString("Sublabel", "");	
		mapSub.setString("Type", "NHT-Type H " + GF + "/50/70");						
		_Map.setMap("TSLBOM", mapSub);
	}

// Display
	Display dp(nColor),dpTxt(nColor);
	dp.draw(bd);
	dpTxt.dimStyle(sDimStyle);
	dpTxt.addViewDirection(_Y1);
	dpTxt.textHeight(U(10));
	dpTxt.draw("NHT " + GF, _Pt0, _XW,_YW,0,2);
//(c) 04.04.2002 Thorsten Huck hsb-Systems GmbH



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
M"`#(`/H#`1$``A$!`Q$!_]H`#`,!``(1`Q$`/P!E`!0`4`%`!0`4`%`"T`%`
M!0`4`%`!0`4`)0`4`+0`4`%`"4`%`!0`4`%`!0`4`%`!0`4`)0`4`%`"T`%`
M!0`4`%`"T`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`E`!
M0`4`%`!0`E`"T`%`!0`4`+0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4
M`%`!0`4`%`!0`4`%`!0`4`)0`4`%`!0`4`+0`4`%`!0`4`%`!0`4`%`!0`4`
M+0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`"4`%`!0`4`%`!0`4`%`!0`M`!
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
,$H`*`"@`H`2@`/_9
`

#End
