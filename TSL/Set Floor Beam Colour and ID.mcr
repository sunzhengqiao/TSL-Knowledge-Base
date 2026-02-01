#Version 8
#BeginDescription
Select a beam - changes its colour and also set its hsbID using the Beamcode for BOM
Ver1.1








#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
String JC16 = T("C16Joist");
String JC24 = T("C24Joist");
String BA = T("Battens");
String BR = T("Bridging");
String PP = T("Ply Packer");
String BB = T("Backer Block");
String NO = T("Noggin");
String TJI150 = T("TJI - 150");
String TJI350 = T("TJI - 350");
String TJI550 = T("TJI - 550");
String TS = T("Timberstrand");
String PL = T("Parallam");
String GL = T("Glulam");
String PRI40 = T("PRI - 40");
String PRI60 = T("PRI - 60");
String TJI110 = T("TJI 110");
String TJI360 = T("TJI 360");
String TJI560 = T("TJI 560");
String BCI5000 = T("BCI5000");
String VLAM = T("Versa-Lam");
String BCI90 = T("BCI90");
String HL240 = T("HL240");
String MP240 = T("MP240");
String RIM240 = T("RIM240");
String BB4240 = T("BB4240");
String BB9240 = T("BB9240");
String WS = T("Web Stiffener");









					

String Types[] = {JC16,JC24,BA,BR,PP,BB,NO,TJI150,TJI350,TJI550,TS,PL,GL,PRI40,PRI60,TJI110,TJI360,TJI560,BCI5000,VLAM,BCI90,HL240,MP240,RIM240,BB4240,BB9240,WS};
PropString beamtypes(1,Types,"Select Beam Type");
PropString sName(4,T(" "),T("Enter Beam Name"));
PropString Grade(2,T(" "),T("Enter Timber Grade"));
PropString Infor(3,T(" "),T("Enter Information"));
if (_bOnInsert) {
showDialog();
PrEntity ssE("select a set of beams",Beam());
if (!ssE.go()) { // the user did cancel
eraseInstance();
return;
}


Beam arBeams[] = ssE.beamSet();
for (int b=0; b<arBeams.length(); b++) { // loop over all beams selected
Beam bmSource = arBeams[b]; // do this for each beam of the array
//Beam bmSource = getBeam("Select a beam to assign Values");

if (beamtypes==JC16){
  bmSource.setColor(32); 
bmSource.setHsbId(10001);
bmSource.setName(sName);
bmSource.setGrade(Grade);}
else  
if (beamtypes==JC24){
  bmSource.setColor(32); 
bmSource.setHsbId(10009);
bmSource.setName(sName);
bmSource.setGrade(Grade);}
else  
if (beamtypes==BA){
  bmSource.setColor(6); 
bmSource.setHsbId(10010);
bmSource.setName(sName);
bmSource.setGrade(Grade);}

else  
if (beamtypes==BR){
  bmSource.setColor(32); 
bmSource.setHsbId(10005);
bmSource.setName(sName);
bmSource.setGrade(Grade);}

else  
if (beamtypes==PP){
  bmSource.setColor(1); 
bmSource.setHsbId(10007);
bmSource.setName(sName);
bmSource.setGrade(Grade);}


else  
if (beamtypes==BB){
  bmSource.setColor(1); 
bmSource.setHsbId(10008);
bmSource.setName(sName);
bmSource.setGrade(Grade);}

else  
if (beamtypes==NO){
  bmSource.setColor(32); 
bmSource.setHsbId(10004);
bmSource.setName(sName);
bmSource.setGrade(Grade);}

else  
if (beamtypes==TJI150){
  bmSource.setColor(32); 
bmSource.setHsbId(10020);
bmSource.setName(sName);
bmSource.setGrade(Grade);}

else  
if (beamtypes==TJI350){
  bmSource.setColor(32); 
bmSource.setHsbId(10021);
bmSource.setName(sName);
bmSource.setGrade(Grade);}

else  
if (beamtypes==TJI550){
  bmSource.setColor(32); 
bmSource.setHsbId(10022);
bmSource.setName(sName);
bmSource.setGrade(Grade);}

else  
if (beamtypes==TS){
  bmSource.setColor(32); 
bmSource.setHsbId(10040);
bmSource.setName(sName);
bmSource.setGrade(Grade);}

else  
if (beamtypes==PL){
  bmSource.setColor(32); 
bmSource.setHsbId(10060);
bmSource.setName(sName);
bmSource.setGrade(Grade);}

else  
if (beamtypes==GL){
  bmSource.setColor(32); 
bmSource.setHsbId(10080);
bmSource.setName(sName);
bmSource.setGrade(Grade);}

else  
if (beamtypes==PRI40){
  bmSource.setColor(32); 
bmSource.setHsbId(10100);
bmSource.setName(sName);
bmSource.setGrade(Grade);}

else  
if (beamtypes==PRI60){
  bmSource.setColor(32); 
bmSource.setHsbId(10101);
bmSource.setName(sName);
bmSource.setGrade(Grade);}

else  
if (beamtypes==TJI110){
  bmSource.setColor(32); 
bmSource.setHsbId(10026);
bmSource.setName(sName);
bmSource.setGrade(Grade);}

else  
if (beamtypes==TJI360){
  bmSource.setColor(32); 
bmSource.setHsbId(10027);
bmSource.setName(sName);
bmSource.setGrade(Grade);}

else  
if (beamtypes==TJI560){
  bmSource.setColor(32); 
bmSource.setHsbId(10028);
bmSource.setName(sName);
bmSource.setGrade(Grade);}

else  
if (beamtypes==BCI5000){
  bmSource.setColor(32); 
bmSource.setHsbId(10029);
bmSource.setName(sName);
bmSource.setGrade(Grade);}

else  
if (beamtypes==VLAM){
  bmSource.setColor(32); 
bmSource.setHsbId(10030);
bmSource.setName(sName);
bmSource.setGrade(Grade);}

else  
if (beamtypes==BCI90){
  bmSource.setColor(32); 
bmSource.setHsbId(10031);
bmSource.setName(sName);
bmSource.setGrade(Grade);}

else  
if (beamtypes==HL240){
  bmSource.setColor(1); 
bmSource.setHsbId(10222);
bmSource.setName(sName);
bmSource.setGrade(Grade);}

else  
if (beamtypes==MP240){
  bmSource.setColor(1); 
bmSource.setHsbId(10225);
bmSource.setName(sName);
bmSource.setGrade(Grade);}

else  
if (beamtypes==RIM240){
  bmSource.setColor(32); 
bmSource.setHsbId(10250);
bmSource.setName(sName);
bmSource.setGrade(Grade);}

else  
if (beamtypes==BB4240){
  bmSource.setColor(32); 
bmSource.setHsbId(10280);
bmSource.setName(sName);
bmSource.setGrade(Grade);}

else  
if (beamtypes==BB9240){
  bmSource.setColor(32); 
bmSource.setHsbId(10290);
bmSource.setName(sName);
bmSource.setGrade(Grade);}

else  
if (beamtypes==WS){
  bmSource.setColor(8); 
bmSource.setHsbId(10300);
bmSource.setName(sName);
bmSource.setGrade(Grade);}

}


  return;
}
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
M%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0
M`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%
M`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`
M4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`
M!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4
M`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!
M0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`
M%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0
M`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%
M`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`
M4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`
M!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4
M`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!
M0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`
M%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0
M`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%
M`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`
M4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`
M!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4
M`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!
M0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`
M%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0
M`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%
M`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`
M4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`
M!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4
M`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!
M0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`
M%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0
M`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%
M`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`
M4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`
M!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4
M`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!
M0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`
M%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0
M`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%
M`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`
M4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`
M!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4
M`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!
M0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`
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
@`*`"@`H`*`"@"2(G..V*F1,B6I,PH`*`"@`H`*``_]F@
`






#End
