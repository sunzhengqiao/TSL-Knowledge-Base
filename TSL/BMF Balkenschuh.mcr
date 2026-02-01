#Version 8
#BeginDescription
/// DE
/// erzeugt innen- und außenliegende BMF-Balkenschuhe der Standardgrundformen
/// inkl. einer optionalen Markierung am Hauptträger
/// 
/// EN
/// creates BMF Hangers including an optional marking

version value="1.60" date=29apr20" author="marsel.nakuci@hsbcad.com"

HSB-7435: add beamcut length U(20) for Schwabenhaus
model added to hardware components






























#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 0
#FileState 0
#MajorVersion 1
#MinorVersion 60
#KeyWords balkenschuh, Schwabenhaus
#BeginContents
/// DE
/// erzeugt innen- und außenliegende BMF-Balkenschuhe der Standardgrundformen
/// inkl. einer optionalen Markierung am Hauptträger
/// 
/// EN
/// creates BMF Hangers including an optional marking
/// 
///<version value="1.60" date=29apr20" author="marsel.nakuci@hsbcad.com"> HSB-7435: add beamcut length U(20) for Schwabenhaus</version>
///<version value="1.59" date=14mar20" author="marsel.nakuci@hsbcad.com"> HSB-6996: modify for special=Schwabenhaus, milling at male beam 4 mm </version>
///<version value="1.58" date=04may17" author="thorsten.huck@hsbcad.com"> model added to hardware components </version>
/// Version 1.57  19.12.2014   AL
/// Ausblattmaß von 140 auf 200 mm geä.!
/// Version 1.56  19.09..2013   th@hsbCAD.de
/// bugfix no marking
/// Version 1.55  21.06..2013   th@hsbCAD.de
/// Default: Marking disabled
/// Version 1.54  14.02..2013   th@hsbCAD.de
/// new assignment method: the instance can be assigned to the male or the female dependency. this can be the beam or the element on which the beam is dependent
/// Version 1.53  14.12..2012   th@hsbCAD.de
/// the Info-layer is the default layer on which the entity is drawn
/// Version 1.52  23.11.2012   th@hsbCAD.de
/// new Option: if the beams of the tsl belong to 2 elements one can change the assignment of the tsl and on which element it will be drawn. 
/// this option is avalable through context command menu if applicable
/// Version 1.51  16.07.2012   th@hsbCAD.de
/// bugfix beamcut width when type exceeds max width
/// Version 1.50  30.05.2012   th@hsbCAD.de
/// map based dimRequest for shopdrawings added
/// Version 1.49  12.05.2011   th@hsbCAD.de
/// custom condition added
/// additional hardware output added. requires hsbCAD 16.0.18 or higher
/// Version 1.48  30.11.10   th@hsbCAD.de
/// - special item export included if a valid element is found
/// Version 1.47   04.02.10   th@hsbCAD.de
/// - material published
/// 
/// 
/// Version 1.46   29.04.09   th@hsbCAD.de
/// bugfix
/// Version 1.44   24.07.06   th@hsbCAD.de
/// DE   Versionsabgleich
/// EN   Versioning
/// Version 1.43   10.07.2006   hs@hsbCAD.de
/// DE geringfügige Änderung bei der unteren Ausblattung
/// EN   Minor revision on the bottom milling
/// Version 1.41   15.05.06   th@hsbCAD.de
/// Version 1.40   15.02.06   th@hsbCAD.de
/// DE
///    - Sperrfläche ergänzt, wenn Ausrichtung senkrecht zur Elementebene
///    - Balkenschuh-Abmessungen im Beschreibungsfeld ergänzt
/// EN
///    - nonail area for elements added if alignment perp to element coordsys
///    - dimesnions added to description
/// Version 1.39   02.02.06   th@hsbCAD.de
/// DE
///    - Eigenschaft Farbe ergänzt
///    - hsbLiveSchnitt wird unterstützt
/// EN
///    - property color added
///    - live section supported
/// Version 1.38   02.12.05   th@hsbCAD.de
///    - bugFix Markierung
/// Version 1.37   02.12.05   th@hsbCAD.de
/// DE
///    - neue Option 'Layer' ordnet den Balkenschuh dem gewählten
///    Sublayer der Gruppe zu
/// EN
///    - new option 'Layer' assigns entity to sublayer if male
///    beam belongs to a group
///    
/// Version 1.36   22.08.05   th@hsb-systems.de
///    - Artikelkorrektur 4406 -> 4306
/// Version 1.35   05.08.05   th@hsb-systems.de
///    - TSL 'hsbBOM' wird unterstützt
/// Version 1.34   13.07.05   th@hsb-systems.de
///    - Datenausgabe wird auch bei Elementen unterstützt
/// Version 1.33   14.05.05   th@hsb-systems.de
///    - Datenausgabe um Breite und innen/außenliegend erweitert
/// Version 1.32   24.06.04   th@hsb-systems.de
///    Vorgaberückschnitt auf -2mm geändert
/// Version 1.31   27.05.04   th@hsb-systems.de
///    Genauigkeitskorrektur bei geneigtem Einbau
/// Version 1.3   03.06.03   th@hsb-systems.de


_X0.visualize(_Pt0,1);
_Y0.visualize(_Pt0,3);
_Z0.visualize(_Pt0,150);
U(1,"mm");

PropDouble RS(0,U(-2,"mm"),T("Offset length"));
int nArticles[]={0};
String YesNo[]={T("Yes"),T("No")};
String MarkList[]={T("Marking"),T("Marking + Text"),T("Marking + Number"),T("None")};
String IAList[]={T("Outside"),T("Inside")};
PropString Ausblattung(1,YesNo,T("Bottom milling"),1);
PropString Markierung(2,MarkList,T("Marking"),3);
int nMarkType = MarkList.find(Markierung);
PropString IA(3,IAList,T("Orientation"));

String sArLayer[] = {"'T' " + T("Tool"),"'I' " + T("Information"), "'J' " + T("Autoinfo")};
PropString sLayer(4,sArLayer,T("Layer"),1);
int nLayer = sArLayer.find(sLayer);

int nMyCol = 252;
if (projectSpecial().makeUpper()=="LUXHAUS")nMyCol =10;
PropInt nColor (1,nMyCol,T("Color"));
PropString sStereotype(5,"Assembly",T("|Stereotype|"));
sStereotype.setDescription(T("|Defines the stereotype for Shopdrawings.|") + " " + T("|* = all dimension chains|"));	
double HB,GF,T1,T2,B1,B2,BlechH,EFO,dH1,dH2,dH3,d5H1,d5H2,d5B1,d5B2,SchH;
int BMFNr,KDrill,SDrill5a,SDrill5b,SDrill9,SDrill11,AnzGF,AnzNagel,I_A;
double BlechD=U(2);
double KBlechT;
//Maß der Einfräsung festlegen

if (Ausblattung==T("No"))
	EFO=0;//EFO=Offset der Einfräsung
else if (Ausblattung==T("Yes"))
	EFO=BlechD;
nArticles.setLength(0);
if (IA==T("Outside")) {
I_A=1;
if (_Beam0.dD(_Y0)>=U(200)){ // Armin
	HB=U(200);
	nArticles.append(3521);
}


else if  (_Beam0.dD(_Y0)>=U(180)){
	HB=U(180);
	nArticles.append(3518);
}
else if  (_Beam0.dD(_Y0)>=U(160)){
	HB=U(160);
	nArticles.append(3518);
}
else if  (_Beam0.dD(_Y0)>=U(140)){
	HB=U(140);
	nArticles.append(3518);
}


else if  (_Beam0.dD(_Y0)>=U(127)){
	HB=U(127);
	nArticles.append(3518);
}
else if  (_Beam0.dD(_Y0)>=U(120)){
	HB=U(120);
	nArticles.append(3421);	nArticles.append(3515);
}

else if  (_Beam0.dD(_Y0)>=U(115)){
	HB=U(115);
	nArticles.append(3418);	nArticles.append(3512);
}

else if  (_Beam0.dD(_Y0)>=U(100)){
	HB=U(100);
	nArticles.append(3318);	nArticles.append(3415);	nArticles.append(3509);
}

else if  (_Beam0.dD(_Y0)>=U(98)){
	HB=U(98);
	nArticles.append(3317);
}
else if  (_Beam0.dD(_Y0)>=U(90)){
	HB=U(90);
	nArticles.append(3315);
}
else if  (_Beam0.dD(_Y0)>=U(80)){
	HB=U(80);
	nArticles.append(3221);	nArticles.append(3312);
	nArticles.append(3412);	nArticles.append(3506);
}
else if  (_Beam0.dD(_Y0)>=U(76)){
	HB=U(76);
	nArticles.append(3218);	nArticles.append(3309);	nArticles.append(3409);
}
else if  (_Beam0.dD(_Y0)>=U(73)){
	HB=U(73);
	nArticles.append(3216);	nArticles.append(3308);	nArticles.append(3408);
}
else if  (_Beam0.dD(_Y0)>=U(70)){
	HB=U(70);
	nArticles.append(3215);	nArticles.append(3307);
}
else if  (_Beam0.dD(_Y0)>=U(64)){
	HB=U(64);
	nArticles.append(3115);	nArticles.append(3212);
}
else if  (_Beam0.dD(_Y0)>=U(60)){
	HB=U(60);
	nArticles.append(3112);	nArticles.append(3209);	nArticles.append(3306);
	nArticles.append(3406);	nArticles.append(3503);
}
else if  (_Beam0.dD(_Y0)>=U(51)){
	HB=U(51);
	nArticles.append(3009);	nArticles.append(3109);	nArticles.append(3206);
	nArticles.append(3303);	nArticles.append(3403);
}
else if  (_Beam0.dD(_Y0)>=U(48)){
	HB=U(48);
	nArticles.append(3007);	nArticles.append(3205);
	nArticles.append(3302);	nArticles.append(3501);
}
else if  (_Beam0.dD(_Y0)>=U(45)){
	HB=U(45);
	nArticles.append(3006);	nArticles.append(3106);
	nArticles.append(3204);	nArticles.append(3301);
}
else if  (_Beam0.dD(_Y0)>=U(40)){
	HB=U(40);
	nArticles.append(3003);	nArticles.append(3103);	nArticles.append(3203);
}
else if  (_Beam0.dD(_Y0)>=U(36)){
	HB=U(36);
	nArticles.append(3202);
}
}//end if Inside/Outside
else if (IA==T("Inside")) {
I_A=-1;

if (_Beam0.dD(_Y0)>=U(200)){
	HB=U(200);
	nArticles.append(4521);
}

else if  (_Beam0.dD(_Y0)>=U(180)){
	HB=U(180);
	nArticles.append(4421);	nArticles.append(4515);
}
else if  (_Beam0.dD(_Y0)>=U(160)){
	HB=U(160);
	nArticles.append(4421);	nArticles.append(4515);
}
else if  (_Beam0.dD(_Y0)>=U(140)){
	HB=U(140);
	nArticles.append(4421);	nArticles.append(4515);
}


else if  (_Beam0.dD(_Y0)>=U(120)){
	HB=U(120);
	nArticles.append(4421);	nArticles.append(4515);
}

else if  (_Beam0.dD(_Y0)>=U(115)){
	HB=U(115);
	nArticles.append(4418);	nArticles.append(4512);
}
else if  (_Beam0.dD(_Y0)>=U(100)){
	HB=U(100);
	nArticles.append(4318);	nArticles.append(4415);	nArticles.append(4509);
}

else if  (_Beam0.dD(_Y0)>=U(98)){
	HB=U(98);
	nArticles.append(4317);
}
else if  (_Beam0.dD(_Y0)>=U(90)){
	HB=U(90);
	nArticles.append(4315);
}
else if  (_Beam0.dD(_Y0)>=U(80)){
	HB=U(80);
	nArticles.append(4221);	nArticles.append(4312);
	nArticles.append(4412);	nArticles.append(4506);
}
else if  (_Beam0.dD(_Y0)>=U(76)){
	HB=U(76);
	nArticles.append(4218);
}
else if  (_Beam0.dD(_Y0)>=U(73)){
	HB=U(73);
	nArticles.append(4216);	nArticles.append(4308);
}
else if  (_Beam0.dD(_Y0)>=U(70)){
	HB=U(70);
	nArticles.append(4215);
}
else if  (_Beam0.dD(_Y0)>=U(64)){
	HB=U(64);
	nArticles.append(4115);	nArticles.append(4212);
}
else if  (_Beam0.dD(_Y0)>=U(60)){
	HB=U(60);
	nArticles.append(4112);	nArticles.append(4306);
}
else if  (_Beam0.dD(_Y0)>=U(51)){
	HB=U(51);
	nArticles.append(4009);	nArticles.append(4109);
}
else if  (_Beam0.dD(_Y0)>=U(48)){
	HB=U(48);
	nArticles.append(4003);	nArticles.append(4205);
	nArticles.append(4302);
}
else if  (_Beam0.dD(_Y0)>=U(45)){
	HB=U(45);
	nArticles.append(3006);	nArticles.append(3106);
	nArticles.append(3204);	nArticles.append(3301);
}
else if  (_Beam0.dD(_Y0)>=U(40)){
	HB=U(40);
	nArticles.append(4006);
}	
} //end if Inside/Outside

	String sProduct = T("|Type|");
	PropInt nArticle(0,nArticles,sProduct);

	int nArticleIndex = nArticles.find(nArticle);
	if (nArticleIndex <0)
	{
		reportMessage("\n"+ T("|unexpected error.|") + " " + T("|Tool will be deleted.|"));
		eraseInstance();
		return;	
	}
	
	if (nArticles[nArticleIndex]>=4500) GF=500;
	else if (nArticles[nArticleIndex]>=4400) GF=440;
	else if (nArticles[nArticleIndex]>=4300) GF=380;
	else if (nArticles[nArticleIndex]>=4200) GF=320;
	else if (nArticles[nArticleIndex]>=4100) GF=260;
	else if (nArticles[nArticleIndex]>=4000) GF=238;
	else if (nArticles[nArticleIndex]>=3500) GF=500;
	else if (nArticles[nArticleIndex]>=3400) GF=440;
	else if (nArticles[nArticleIndex]>=3300) GF=380;
	else if (nArticles[nArticleIndex]>=3200) GF=320;
	else if (nArticles[nArticleIndex]>=3100) GF=260;
	else if (nArticles[nArticleIndex]>=3000) GF=238;

Cut endcut (_Pt0- (RS+BlechD)*_X0, _X0);
_Beam0.addTool(endcut,1);

if(GF==238){
	T1=U(72);	           T2=U(38);
	B1=U(37); 	           B2=U(23);	
	dH1=U(26.5);
	d5H1=U(6);	d5H2=U(16);        
	KDrill=4;
	SDrill11=1;        SDrill5a=4;        SDrill5b=3;
	SchH=U(51);	
}
else if (GF==260){
	T1=U(72);   	T2=U(38);
	B1=U(37);   	B2=U(23);	
	dH1=U(17.5);	dH2=U(55);
	d5H1=U(17);	d5H2=U(7);
	d5B1=U(12);	d5B2=U(18);
	KDrill=4; 	
            SDrill11=2;         SDrill5a=4;        SDrill5b=4;
	SchH=U(62);
}
else if(GF==320){
	T1=U(80);  	T2=U(43);
	B1=U(40);  	B2=U(20);	
	dH1=U(27.5); 	dH2=U(67.5);
	KDrill=5; 
	d5H1=U(17);	d5H2=U(7);
	d5B1=U(12);	d5B2=U(18);
            SDrill11=2;         SDrill5a=5;         SDrill5b=5;
	SchH=U(82);
}
else if (GF==380){
	T1=U(80);  	T2=U(42);
	B1=U(40);  	B2=U(20);	
	dH1=U(27.5);	dH2=U(87.5);
	KDrill=6;
	d5H1=U(17);	d5H2=U(7);
	d5B1=U(13);	d5B2=U(20);
	SDrill11=2;         SDrill5a=6;         SDrill5b=6;
	SchH=U(102);
}
else if(GF==440){
	T1=U(87);  	T2=U(47);
	B1=U(42);  	B2=U(22);	
	dH1=U(17.5);	dH2=U(57.5);	dH3=U(97.5);
	d5H1=U(7);	d5H2=U(17);
	d5B1=U(15);	d5B2=U(20);
	KDrill=7;
	SDrill11=3;         SDrill5a=7;         SDrill5b=5;
	SchH=U(117);

}
else if(GF==500){
	T1=U(85);  	T2=U(48);
	B1=U(39);  	B2=U(19);
	dH1=U(30);	dH2=U(70);	dH3=U(130);
	d5H1=U(20);	d5H2=U(10);
	d5B1=U(12);	d5B2=U(20);
	KDrill=8;
	SDrill11=3;         SDrill5a=8;         SDrill5b=7;
	SchH=U(140);
	
}

BlechH=(U(GF)-HB)/2;
Point3d P3,P4,P5,P6,P7,P8;
//Körper linke Seite
P3=_Pt0-_Y0*HB/2-_Z0*0.5*_H0-_X0*BlechD+EFO*_Z0;
PLine Poly1(P3,P3-_X0*(T1-BlechD));
Poly1.addVertex(P3-_X0*(T2-BlechD)+_Z0*B1);
Poly1.addVertex(P3-_X0*(T2-BlechD)+_Z0*BlechH);
Poly1.addVertex(P3+_Z0*BlechH);
Body bd(Poly1,-_Y0*BlechD);
//MetalPart Koerper1(Poly1,-_Y0*BlechD);
P4=_Pt0+_Y0*HB/2-_Z0*0.5*_H0-_X0*BlechD+EFO*_Z0;
//Körper rechte Seite
PLine Poly2(P4,P4-_X0*(T1-BlechD));
Poly2.addVertex(P4-_X0*(T2-BlechD)+_Z0*B1);
Poly2.addVertex(P4-_X0*(T2-BlechD)+_Z0*BlechH);
Poly2.addVertex(P4+_Z0*BlechH);	
//MetalPart Koerper2(Poly2,_Y0*BlechD);
bd.addPart(Body(Poly2,_Y0*BlechD));
for (int i=1;i<=KDrill;i++) {
	Point3d ptt,ptt1;
	ptt=P3-_X0*(T2-U(7))+_Z0*(BlechH-U(20)*i)-_Y0*BlechD;
	ptt1=P3-_X0*(T2-U(7))+_Z0*(BlechH-U(20)*i)+_Y0*U(1000);
	Drill DrK2(ptt,ptt1,U(2.5));
	//Koerper1.addTool(DrK2);
	//Koerper2.addTool(DrK2);
	bd.addTool(DrK2);
} 
//Körper unten
//MetalPart BBlech (_Pt0-((0.5*_H0)-EFO)*_Z0-_X0*BlechD,-_X0,_Y0,-_Z0, T1-BlechD,(HB+2*BlechD),BlechD,1,0,1);
Body bdBBlech(_Pt0-((0.5*_H0)-EFO)*_Z0-_X0*BlechD,-_X0,_Y0,-_Z0, T1-BlechD,(HB+2*BlechD),BlechD,1,0,1);
bd.addPart(bdBBlech);

if (Ausblattung==T("Yes"))
{
	double bcDepth = BlechD;
	Point3d bcPt = _Pt0 - ((0.5 * _H0) - EFO) * _Z0;
	// HSB-7435
	T1 += U(20);
	bcPt -= _X0 * .5 * (U(20));
	if (projectSpecial() == "Schwabenhaus")
	{
		bcDepth = U(4);
		bcPt = _Pt0 - ((0.5 * _H0) - U(4)) * _Z0;
	}
   BeamCut EinFraes(bcPt, _X0, _Y0, _Z0, T1, _W0, bcDepth ,- 1, 0 ,- 1);
   _Beam0.addTool(EinFraes);
}
if (HB!=_Beam0.dD(_Y0)) {
BeamCut BCL(P3-_Z0*EFO+_X0*RS,_X0,_Y0,_Z0,T1*2,0.5*_W0,_H0,0,-1,1);
_Beam0.addTool(BCL);
BeamCut BCR(P4-_Z0*EFO+_X0*RS,_X0,_Y0,_Z0,T1*2,0.5*_W0,_H0,0,1,1);
_Beam0.addTool(BCR);
}
//Schenkel links
PLine Poly3(P3,P3+_Z0*BlechH);
Poly3.addVertex(P3+_Z0*BlechH-_Y0*B1*I_A);
Poly3.addVertex(P3+_Z0*(BlechH-SchH)-_Y0*B1*I_A);
//MetalPart Schenkel1(Poly3,_X0*BlechD);
bd.addPart(Body(Poly3,_X0*BlechD));

//Schenkel rechts
PLine Poly4(P4,P4+_Z0*BlechH);
Poly4.addVertex(P4+_Z0*BlechH+_Y0*B1*I_A);
Poly4.addVertex(P4+_Z0*(BlechH-SchH)+_Y0*B1*I_A);
//MetalPart Schenkel2(Poly4,_X0*BlechD);
bd.addPart(Body(Poly4,_X0*BlechD));

P5=_Pt0-_X0*BlechD-_Y0*B2*I_A-_Y0*0.5*HB+_Z0*BlechH-_Z0*_H0*0.5+_Z0*BlechD;//+_Z0*EFO;
P6=_Pt0-_X0*BlechD+_Y0*B2*I_A+_Y0*0.5*HB+_Z0*BlechH-_Z0*_H0*0.5+_Z0*BlechD;//+_Z0*EFO;
for (int i=1;i<=SDrill11;i++) {
	if (i==1){
		Drill dH1dr(P5-_Z0*dH1,P5-_Z0*dH1+_X0*U(100),U(6.5));	
		//Schenkel1.addTool(dH1dr);
		bd.addTool(dH1dr);
		Drill dH2dr(P6-_Z0*dH1,P6-_Z0*dH1+_X0*U(100),U(6.5));	
		//Schenkel2.addTool(dH2dr);
		bd.addTool(dH2dr);
	}
	else if(i==2){
		Drill dH1dr(P5-_Z0*dH2,P5-_Z0*dH2+_X0*U(100),U(6.5));
		//Schenkel1.addTool(dH1dr);
		bd.addTool(dH1dr);
		Drill dH2dr(P6-_Z0*dH2,P6-_Z0*dH2+_X0*U(100),U(6.5));
		//Schenkel2.addTool(dH2dr);
		bd.addTool(dH2dr);
	}
	else if(i==3){
		Drill dH1dr(P5-_Z0*dH3,P5-_Z0*dH3+_X0*U(100),U(6.5));		
		//Schenkel1.addTool(dH1dr);
		bd.addTool(dH1dr);
		Drill dH2dr(P6-_Z0*dH3,P6-_Z0*dH3+_X0*U(100),U(6.5));		
		//Schenkel2.addTool(dH2dr);
		bd.addTool(dH2dr);
	}
}
P7=P3+(BlechH-d5H1)*_Z0-d5B1*_Y0*I_A;
P8=P4+(BlechH-d5H1)*_Z0+d5B1*_Y0*I_A;
double SOffset;
SOffset=0;
//erzeuge innere Bohrreihe
for (int i=1;i<=SDrill5a;i++) {
	Drill d5dr1(P7-_Z0*SOffset,P7-_Z0*SOffset+_X0*U(100),U(2.5));
	Drill d5dr2(P8-_Z0*SOffset,P8-_Z0*SOffset+_X0*U(100),U(2.5));	
	//Schenkel1.addTool(d5dr1);
	//Schenkel2.addTool(d5dr2);
	bd.addTool(d5dr1);	
	bd.addTool(d5dr2);	
	SOffset=SOffset+U(20);
}
SOffset=0;
P7=P3+(BlechH-d5H2)*_Z0-(d5B2+d5B1)*_Y0*I_A;
P8=P4+(BlechH-d5H2)*_Z0+(d5B2+d5B1)*_Y0*I_A;
//erzeuge äußere Bohrreihe
for (int i=1;i<=SDrill5b;i++) {
	if (i==SDrill5b) {
		if (GF<440)
	     	SOffset=SOffset-U(5);   		
	}
	Drill d5dr1(P7-_Z0*SOffset,P7-_Z0*SOffset+_X0*U(100),U(2.5));
	Drill d5dr2(P8-_Z0*SOffset,P8-_Z0*SOffset+_X0*U(100),U(2.5));	
	//Schenkel1.addTool(d5dr1);
	//Schenkel2.addTool(d5dr2);
	bd.addTool(d5dr1);	
	bd.addTool(d5dr2);	
	
	SOffset=SOffset+U(20);
}

String sHeightDesc, sWidthDesc;
sHeightDesc.formatUnit(BlechH, 2,0);
sWidthDesc.formatUnit(HB, 2,0);

String ModelBez ="BMF " + nArticles[nArticleIndex] ;
model("BMF " + nArticles[nArticleIndex]+ "    " + sWidthDesc + "x" + sHeightDesc);
String sWidth;
sWidth.formatUnit(HB,2,0);
dxaout("INFO",T("Width") +": " + sWidth + "mm, " + IA);//Bezeichnung
material(T("Stahl, verzinkt"));
AnzNagel=SDrill5a+SDrill5b+KDrill;
if (GF==440) AnzNagel=AnzNagel+1;



// on creation and changing the type set the hardWrComps
	HardWrComp hwList[0];
	
	{
		String category=T("|Connectors|"), articleNumber=scriptName();
		HardWrComp hwc(articleNumber, 1);
		hwc.setDScaleX(1); // write quantity to scale X as countType fails in excel (22.0.19.1055)
//		hwc.setDScaleX(dArD[nModel]);
//		hwc.setDScaleY(dArA[nModel]);
//		hwc.setDScaleZ(dArB[nModel]);
		if (_Beam1.element().bIsValid())
			hwc.setDescription(_Beam1.element().number());
		hwc.setCategory(category);	
		hwc.setMaterial(articleNumber);
		hwc.setCountType(_kCTAmount);
		hwList.append(hwc);	
	}	

	//if (_bOnDbCreated || _kNameLastChangedProp==sProduct)	
	{
	// nails
		String s = "4 x 40mm";				
		HardWrComp hwc("",1);
		hwc.setBVisualize(false);
		hwc.setName("BMF"  + T("|Kammnägel|"));
		hwc.setDescription("");
		hwc.setManufacturer("BMF");
		hwc.setModel(s);
		hwc.setMaterial(T("|Steel zincated|"));
		hwc.setCountType(_kCTAmount);
		hwc.setDScaleX(U(40));
		hwc.setDScaleY(U(4));		
		hwc.setDScaleZ(0);	
		hwc.setQuantity(AnzNagel);
		hwList.append(hwc);			
		
		_ThisInst.setHardWrComps(hwList);
						
	}
//	else
//		hwList = _ThisInst.hardWrComps();
//	


//Markierung
Point3d pt1 = Line(P3,_X0).intersect(_Plf,0);
Point3d pt2 = Line(P4,_X0).intersect(_Plf,0);
Mark mrk; // default constructor
if (nMarkType == 0)//Markierung=="Riß")
    mrk = Mark(pt1,pt2,-_Z1);
else if (nMarkType == 1)//"Riß mit Bezeichnung"))
    mrk = Mark(pt1,pt2,-_Z1, ModelBez);
else if (nMarkType == 2)//"Riß mit Stabnummer"))
    mrk = Mark(pt1,pt2,-_Z1,0); // 0 is index of _Beam0

if (nMarkType !=3)
	_Beam1.addTool(mrk);

// publish dim request
	Point3d points[] = {pt1,pt2};
 	Map mapRequest,mapRequests;
	mapRequest.setPoint3dArray("points", points);
	mapRequest.setVector3d("vecX", _Y0);
	mapRequest.setVector3d("vecY", _Z0);
	mapRequest.setVector3d("vecZ", -_X0);
	mapRequest.setString("Stereotype", sStereotype);
	mapRequest.setVector3d("AllowedView", -_X0);
	mapRequests.appendMap("DimRequest",mapRequest);
	_Map.setMap("Dimrequest[]", mapRequests);




setCompareKey(ModelBez + SDrill5a + SDrill5b + KDrill);

// assign to layer
	String sBmLayer = _Beam[0].layerName();
	int nFound = sBmLayer.find("hsb~",0);	
	int nCount = sBmLayer.find("+Z",0);

	if (nFound > -1){
		String sLeft = sBmLayer.left(nCount);
		String sRight = sBmLayer.right(sBmLayer.length()-nCount-2);		
		String sTslLayer;
		if (nLayer == 1){
			sTslLayer = sLeft + "+I" + sRight;}
		else if (nLayer == 2){
			sTslLayer = sLeft + "+J" + sRight;}
		else{
			sTslLayer = sLeft + "+T" + sRight;	}					
		assignToLayer(	sTslLayer );	
	}


// Display
	Display dp(nColor);
	
	
//export to dxa if linked to element
	Element el1;
	el1 = _Beam1.element();
	if (el1.bIsValid())
		exportWithElementDxa(el1);
		
	Map mapSub;
	mapSub.setString("Name", T("BMF Balkenschuh"));
	mapSub.setInt("Qty", 1);
	mapSub.setDouble("Width", HB);
	mapSub.setDouble("Length", 0);
	mapSub.setDouble("Height", 0);				
	mapSub.setString("Mat", T("|Steel, zincated|"));
	mapSub.setString("Grade", "");
	mapSub.setString("Info", "");
	mapSub.setString("Volume", "");						
	mapSub.setString("Profile", "");	
	mapSub.setString("Label", "");					
	mapSub.setString("Sublabel", "");	
	mapSub.setString("Type", "BMF" + nArticles[nArticleIndex] );						
	_Map.setMap("TSLBOM", mapSub);


// element 0
	Element el0;
	el0 = _Beam0.element();	

// assignment	
	int nAssignTo=_Map.getInt("assignTo");// 0= male, 1 = female
	
	String sAssignToTxt;
	Element elThis;	
	Beam bmThis;
	if(nAssignTo==0)// the current assignment is female, the trigger shows the command to assign to male
	{
		if (el0.bIsValid())	elThis=el0;
		else bmThis=_Beam0;
		
		if (el1.bIsValid())sAssignToTxt=T("|Element|") + " " +el1.number();
		else	sAssignToTxt=T("|female Beam|") + " " +_Beam1.posnum();	
	} 	
	else if(nAssignTo==1)// the current assignment is male, the trigger shows the command to assign to female
	{
		if (el1.bIsValid())	elThis=el1;
		else bmThis=_Beam1;
		
		if (el0.bIsValid())sAssignToTxt=T("|Element|") + " " +el0.number();
		else	sAssignToTxt=T("|male Beam|") + " " +_Beam0.posnum();	
	} 
		
// add assignment trigger	
	String sTriggerAssign =T("|Assign to|")+" " + sAssignToTxt;
	addRecalcTrigger(_kContext,sTriggerAssign);			
	if (_bOnRecalc && _kExecuteKey==sTriggerAssign) 
	{	
		if (nAssignTo==1)
			nAssignTo =0;
		else	
			nAssignTo =1;			
		_Map.setInt("assignTo",nAssignTo);
		setExecutionLoops(2);
	}

// assigning
	if (elThis.bIsValid())	
	{
		assignToElementGroup(elThis,TRUE,0, 'E');
		if (nLayer == 0)
			dp.elemZone(elThis, 0, 'T');
		else if (nLayer == 1)
			dp.elemZone(elThis, 0, 'I');			
		else if (nLayer == 2)
			dp.elemZone(elThis, 0, 'J');
		else
			dp.elemZone(elThis, 0, 'E');	
	}
	else if (bmThis.bIsValid())
	{
		assignToGroups(bmThis);//	remember to update this in the futrure: assignToGroups(Entity ent, char cZoneCharacter); // (added since 18.1.45) 

	}	

// add no nailareas in element
	if (el0.bIsValid())
	{
		Vector3d vz0 = el0.vecZ();
		int nSide;
		if (vz0.isCodirectionalTo(_Z0))	
			nSide = -1;
		else if (vz0.isCodirectionalTo(-_Z0))			
			nSide = 1;
		
		
		// add no nailareas in element if shoe is parallel to z-axis
		if (abs(nSide) == 1)
		{
			PLine plNN(nSide * _Z0);
			plNN.addVertex(_Pt0 - _Y0 * (0.5 * HB + BlechD + U(10)) - _X0 * (T1 + U(10)));
			plNN.addVertex(_Pt0 + _Y0 * (0.5 * HB + BlechD + U(10)) - _X0 * (T1 + U(10)));
			plNN.addVertex(_Pt0 + _Y0 * (0.5 * HB + BlechD + U(10)) + _X0 * U(10));		
			plNN.addVertex(_Pt0 - _Y0 * (0.5 * HB + BlechD + U(10)) + _X0 * U(10));		
			plNN.close();

			plNN.vis(3);
			//loop zones
			for (int i = 0; i < 5; i++)
			{
				int nZn = (i+1) * nSide;
				if (el0.zone(nZn).dH() > 0)
				{
					ElemNoNail elNN(nZn, plNN);
					el0.addTool(elNN);
				}
			}	
		}
		
		// specialized item export
		{
			Map mapItem;
			mapItem.setInt("Quantity",1);
			mapItem.setString("Category",T("|Connectors|"));
			mapItem.setString("Article",scriptName());			
			ElemItem item(0,scriptName(),_Pt0,el0.vecX(),mapItem );
			item.setShow(_kNo);
			el0.addTool(item);
			exportWithElementDxa(el0);
		}
					
	}
		
		
// draw body
	dp.draw(bd);






























#End
#BeginThumbnail
M_]C_X``02D9)1@`!``$`8`!@``#__@`?3$5!1"!496-H;F]L;V=I97,@26YC
M+B!6,2XP,0#_VP"$`#LH+#0L)3LT,#1"/SM&691@65%16;:"B6N4U[WBW]2]
MT,SN____[OS__\S0____________YO____________\!/T)"64Y9KF!@KO_U
MT/7_________________________________________________________
M___________$`:(```$%`0$!`0$!```````````!`@,$!08'"`D*"P$``P$!
M`0$!`0$!`0````````$"`P0%!@<("0H+$``"`0,#`@0#!04$!````7T!`@,`
M!!$%$B$Q008346$'(G$4,H&1H0@C0K'!%5+1\"0S8G*""0H6%Q@9&B4F)R@I
M*C0U-C<X.3I#1$5&1TA)2E-455976%E:8V1E9F=H:6IS='5V=WAY>H.$A8:'
MB(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4U=;7
MV-G:X>+CY.7FY^CIZO'R\_3U]O?X^?H1``(!`@0$`P0'!00$``$"=P`!`@,1
M!`4A,08205$'87$3(C*!"!1"D:&QP0DC,U+P%6)RT0H6)#3A)?$7&!D:)B<H
M*2HU-C<X.3I#1$5&1TA)2E-455976%E:8V1E9F=H:6IS='5V=WAY>H*#A(6&
MAXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&Q\C)RM+3U-76
MU]C9VN+CY.7FY^CIZO+S]/7V]_CY^O_``!$(`AH!XP,!$0`"$0$#$0'_V@`,
M`P$``A$#$0`_`-&@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@!-W-`"T`%`
M!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4
M`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!
M0`4`%`!0`4`%`"$XH`90`Y3VH`=0`4`%`!0`4`%`%:5V#\$_A0`JW!Z,M`$J
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
ML%.YN3Z>E`%B@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@
M`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@
M`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*
1`"@`H`*`"@`H`*`"@`H`_]D`
`


























#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="0.001" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <unit ut="L" uv="meter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End