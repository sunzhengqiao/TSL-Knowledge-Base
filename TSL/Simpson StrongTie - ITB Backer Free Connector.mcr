#Version 7
#BeginDescription
Version No. 1.2, 2006-03-15, David Rueda (dr@hsb-cad.com), TSL Team, Quito, Ecuador.
  - reportMessage "joist width + model" erased
  - regrouped properties 
Version No. 1.1, 2006-02-21, David Rueda (dr@hsb-cad.com), TSL Team, Quito, Ecuador.
  - Propierty description added (Twice).
  - Automatic determination of hanger (according to female height) added.
Version No. 1.0 (Initial), 2006-02-21, David Rueda (dr@hsb-cad.com), TSL Team, Quito, Ecuador.
#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
//Units
U(1,"mm");

double dHh; //Hanger height
double dHw;//Hanger width
double dHth = 1.2;//Hanger thickness
double dHCh = 50;//Hanger core height
String strarrJoistW [] = {"38mm", "45mm", "58-60mm", "72mm", "2ply 38mm", "2ply 45 or 89mm", "97mm"};
double darrJoistW [] = { 38, 45, 58, 59, 60, 72, 76, 89, 90, 97};
int iIndex=-1;
String strarrModel [0];//Model
int flag =-1;
double dMw;
double dMh;

//Aux Vectors
Vector3d vecMaleY = _Beam0.vecD(_X1);
if ( vecMaleY.dotProduct ( _X1 ) < 0 )
	vecMaleY = -vecMaleY;
Vector3d vecMaleZ = _Beam0.vecD(_Y1);
if ( vecMaleZ.dotProduct ( _Y1 ) < 0 )
	vecMaleZ = -vecMaleZ;

//Create arrays
//Heights
double darrHeights[0];//Selected heights
double darrModel38Heights []=		{		195, 200, 	220, 235, 240, 			302};//
double darrModel45Heights []= 	{145, 	195, 200, 	220, 235, 240, 			302};//
double darrModel60Heights []= 	{		195, 200, 	220, 235, 240,	245,	302};//
double darrModel72Heights []= 	{		195,           	220, 235,         	245,	302};//
double darrModel2x38Heights []= 	{		195, 200,	220, 235, 240, 			302};//
double darrModel2x45Heights []= 	{		195, 200,	220, 235, 240,	245,	302};//
double darrModel97Heights []= 	{		195, 	  	220, 235, 		245, 	302};//

//propierties
PropDouble prdMaleTlorenace ( 0, 0, T("Male Tolerance"));
PropDouble prdFemaleTlorenace ( 1, 0, T("Female Tolerance"));
prdMaleTlorenace.setDescription("If beam is smallest that expected by manufacturer, a measure of tolerance can be added");
prdFemaleTlorenace.setDescription("If beam is smallest that expected by manufacturer, a measure of tolerance can be added");
PropString prstrModel (0, strarrModel, T("Model"),0);

double dRankH;
double dRankL;


	
if (_bOnInsert) 
{	

	_Beam.append(getBeam(T("Select male beam")));	
	_Beam.append(getBeam(T("Select female beam")));	
	showDialogOnce();	
	return;
}

if(abs(_X0.dotProduct(_Z1)) < 0.9999 )//Verify perpendicularity
	{
		reportMessage ("\nBeams must be perpendicular ");
		eraseInstance();	
	}

	
//Get male beam sizes
dMw = _Beam0.dD(_X1);
dMh = _Beam0.dD(_Y1);

//Verify male and female's bottom faces are aligned
Point3d ptMaleBottom = _Beam0.ptCen() - vecMaleZ * dMh * .5;
Point3d ptFemaleBottom = _Beam1.ptCen() - _Y1 * _W1 * .5;

if ( 1 - abs(vecMaleZ.dotProduct( _Y1)) > 0.0001 || abs( _Y1.dotProduct ( ptFemaleBottom - ptMaleBottom )) > 0.0001 )
{
	reportMessage ( "\nBeam´s bottom faces are not coplanaries");
	eraseInstance();
}

//Verify male beam width
//Determinate right hanger depending on male beam width
for ( int i = 0; i < darrJoistW.length(); i++)
{
	dRankH = darrJoistW [i];
	dRankL = darrJoistW [i] - prdMaleTlorenace;
	
	if ( dMw  <= dRankH && dMw  >= dRankL)
	{
		flag = i;
		break;
	}
}	

if ( flag == -1 )
{
	reportMessage ("\nMale beam doesn´t fit in hanger");
	eraseInstance();

}

//Stretch beam
Cut ct (_Pt0,_X0);
_Beam0.addTool(ct,TRUE);

//Assign apropiate hanger according to male width
if ( flag == 0) //Joist 38mm
{
	dHw=40;//get widht
	for( int i=0; i < darrModel38Heights.length(); i++)
	{
		strarrModel.append( "ITB" + darrModel38Heights[i] + "/" + dHw );
		darrHeights.append( darrModel38Heights[i]  );
	}
}

if ( flag == 1) //Joist 45mm
{
	dHw=45;//get widht
	for( int i=0; i < darrModel45Heights.length(); i++)
	{
		strarrModel.append( "ITB" + darrModel45Heights[i] + "/" + dHw );
		darrHeights.append( darrModel45Heights[i]  );
	}

}

if( flag == 2 || flag == 3 || flag == 4)//Joist 58-60mm
{
	dHw=60;//get widht
	for( int i=0; i<darrModel60Heights.length(); i++)
	{
		strarrModel.append( "ITB" + darrModel60Heights[i] + "/" + dHw );
		darrHeights.append( darrModel60Heights[i]  );
	}
}

if( flag == 5 )//Joist 72mm
{
	dHw=75;//get widht
	for( int i=0; i<darrModel72Heights.length(); i++)
	{
		strarrModel.append( "ITB" + darrModel72Heights[i] + "/" + dHw );
		darrHeights.append( darrModel72Heights[i]  );
	}
}

if( flag == 6 )//Joist 2x38mm
{
	dHw=78;//get widht
	for( int i=0; i<darrModel2x38Heights.length(); i++)
	{
		strarrModel.append( "ITB" + darrModel2x38Heights[i] + "/" + dHw );
		darrHeights.append( darrModel2x38Heights[i]  );
	}
}

if( flag == 7 || flag == 8)//Joist 2x45mm
{
	dHw=90;//get widht
	for( int i=0; i<darrModel2x45Heights.length(); i++)
	{
		strarrModel.append( "ITB" + darrModel2x45Heights[i] + "/" + dHw );
		darrHeights.append( darrModel2x45Heights[i]  );
	}
}

if( flag == 9 )//Joist 97mm
{
	dHw=100;//get widht
	for( int i=0; i<darrModel97Heights.length(); i++)
	{
		strarrModel.append( "ITB" + darrModel97Heights[i] + "/" + dHw );
		darrHeights.append( darrModel97Heights[i]  );
	}
}


//Check female size
int flag2 = -1;
for ( int i = 0; i < darrHeights.length(); i++ )
{
	if ( _W1 <=	darrHeights [ i ] && _W1 >= darrHeights [ i ] - prdFemaleTlorenace)
	{
		flag2 = i;
		dHh = darrHeights [ i ];//Get hanger's height according to female beam´s height
		break
	}
}

if ( flag2 < 0 )
{
	reportMessage ( "\nFemale beam doesn't fit in hanger" );
	eraseInstance();
}

//Propierty: model
prstrModel.set ( strarrModel [ flag2 ]);
prstrModel.setReadOnly ( TRUE );

//Drawing
Display dspl (9);
//Calc. points to draw
//Bottom plate
Point3d ptRef = _Pt0 - vecMaleZ * dMh * .5;
PLine pl1( -vecMaleZ);
pl1.addVertex(ptRef + vecMaleY * dHw * .5);
pl1.addVertex(ptRef + vecMaleY * dHw * .5 - _X0 * dHCh );
pl1.addVertex(ptRef - vecMaleY * dHw * .5 - _X0 * dHCh );
pl1.addVertex(ptRef - vecMaleY * dHw * .5 );
pl1.close();
Body bd1( pl1, -vecMaleZ * dHth , 1);
dspl.draw(bd1);

//Lateral plates
ptRef += vecMaleY * dHw * .5 - vecMaleZ * dHth;
PLine pl2 ( vecMaleY );
pl2.addVertex ( ptRef );
pl2.addVertex ( ptRef + vecMaleZ * ( dHh + dHth) );
pl2.addVertex ( ptRef + vecMaleZ * ( dHh + dHth) - _X0 * dHCh * .5 );
pl2.addVertex ( ptRef + vecMaleZ * dHh * .4 - _X0 * dHCh * .5 );
pl2.addVertex ( ptRef + vecMaleZ * dHh * .1 - _X0 * dHCh );
pl2.addVertex ( ptRef - _X0 * dHCh );
pl2.close();
Body bd2(pl2, vecMaleY * dHth, 1 );
dspl.draw(bd2);
bd2.transformBy ( -vecMaleY * ( dHw + dHth ));
dspl.draw(bd2);

//Legs
ptRef += vecMaleY * dHth;
PLine pl3 ( -_X0 );
pl3.addVertex( ptRef );
pl3.addVertex( ptRef + vecMaleY * dHw * .4 );
pl3.addVertex( ptRef + vecMaleY * dHw * .4 + vecMaleZ * dHh * .25);
pl3.addVertex( ptRef + vecMaleY * dHw * .6 + vecMaleZ * dHh * .6 );
pl3.addVertex( ptRef + vecMaleY * dHw * .6 + vecMaleZ * dHh * .95 );
pl3.addVertex( ptRef + vecMaleY * dHw * .7 + vecMaleZ * dHh * .97 );
pl3.addVertex( ptRef + vecMaleY * dHw * .7 + vecMaleZ * ( dHh + dHth ));
pl3.addVertex( ptRef + vecMaleZ * (dHh+ dHth ));
pl3.close();
Body bd3 ( pl3, -_X0 * dHth, 1);
dspl.draw ( bd3 );
CoordSys crdsys ( _Pt0  , _X0, _Y0, _Z0);
crdsys.setToRotation ( 180, vecMaleZ, _Pt0 - _X0 * dHth * .5 ); 
bd3.transformBy ( crdsys);
dspl.draw( bd3 );

//Flanges
//Bottom flanges
ptRef += vecMaleZ * dHth;
PLine pl4 ( -vecMaleZ );
pl4.addVertex ( ptRef );
pl4.addVertex ( ptRef + _X0 * dHw * .2 );
pl4.addVertex ( ptRef + _X0 * dHw * .2 + vecMaleY * dHw * .4);
pl4.addVertex ( ptRef + vecMaleY * dHw * .4);
pl4.close();
Body bd4 ( pl4, -vecMaleZ *dHth, 1 );
dspl.draw ( bd4 );
crdsys.setToRotation ( 180, _X0 , _Pt0 - vecMaleZ * ( dMh * .5 + dHth * .5 )); 
bd4.transformBy ( crdsys);
dspl.draw( bd4 );
//Top flange
ptRef += vecMaleY * dHw * .7 + vecMaleZ * dHh - _X0 * dHth;
PLine pl5 ( vecMaleZ );
pl5.addVertex ( ptRef );
pl5.addVertex ( ptRef + _X0 * dHw * .5 );
pl5.addVertex ( ptRef + _X0 * dHw * .5 - vecMaleY * dHw * .7 );
pl5.addVertex ( ptRef - vecMaleY * dHw * .7 );
pl5.close();
Body bd5 ( pl5, vecMaleZ * dHth, 1 );
dspl.draw( bd5 );
crdsys.setToRotation ( 180, _X0 , _Pt0 - vecMaleZ * ( dMh * .5 - dHth * .5 - dHh)); 
bd5.transformBy ( crdsys);
dspl.draw( bd5 );


//Material
setCompareKey(prstrModel); // hanger TypeprstrModel 
model(prstrModel);//Article number
dxaout(T("HANGER"), prstrModel );//Designation
material(T("1.2mm pre-galvanised mild steel"));


//Hardware
Hardware nail ( T("Nails"), T("3.75 x 30mm Nails"), T("3.75 x 30mm Nails"), U(30), U(3.75), 20, T("Simpson nails"));
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
M!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`]HG5=Q7`I*28[,93$%`!0`
M4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`
M!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0!)'$TG3@>IJ7)(:5RU'$L8X&3ZUFY-
MFB5A]2,ADMU;E?E/Z5:FUN2XE9T:,X85HFF0U8;3$%`!0`4`%`!0`4`%`!0`
M4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`
M!0`4`%`#E1G.%&:3:0TKEF.W5>6^8_I6;FWL6HDU04%`!0`4`(0",$9%`$$E
MMWC_`"-:*?<AQ[%=@5)!&"*TW($H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`4`DX`R:`)X[;O)
M^0K-S[%J/<L*`H``P!6>Y8M`!0`4`%`!0`4`%`#756'S@8]Z:;6PFEU*3@*V
M%)(]ZV1FQM,04`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0
M`4`%`!0`4`%`!0`4`%`!0`4`2QP,^">%J7)(I1N6DC5!\H_&LFVRTK#J0PH`
M,9JE%L3:0N*KD)YA*AIHI.X4AA0`4`1O,%X7DU2B2V0,Q8Y)JTK$W(WZU2$Q
MM,04`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4
M`%`!0`4`%`#XXVD/RCCU[4FTAI7+4<*ISU/J:R<FRU&Q)4E!0`4TK@*!6BAW
M,W+L+5DA0`4;@(<`9S@5FX=BU+N1O(J>Y]*A*Y3=B%Y&?V'I5I6);N,JA!0`
MQ^M-"8VF(*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`55+'"C)H;L!9CMP,%^3Z5FY]BU'N3C@8%9EA0`4`%->8#@16
MRM;0R=^H4Q!0`4`1R3*N0.30!`[L_4_A0`RI*"@`H`*`&/UIH3&TQ!0`4`%`
M!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`HY.!0!-'
M;EN7X'IWJ'/L4H]RRJA!A1@5FW<M*PM(84`%`!0`4`%-.P"@U:GW(<>PCR*@
MY/X5H00/,S\=!0!'0`4F`E(H*`"@`H`8_6FA,;3$%`!0`4`%`!0`4`%`!0`4
M`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`21PM)ST'J:ER2&E<M)$B=!SZ
MFLW)LT22'U(PH`*`"@`H`*`"@`H`C>8+PO)JE$EL<0'&&&:V,R)X2.5^8?K0
M!'0`E)C04AA0`4`%`#'ZTT)C:8@H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`<B,YPHI-I#2N68[=5Y;YC^E9N;>Q:B35!04`%-*X"X
MIN+1*DF)4E!0`4`%`#'D5/<^E-*XF[$+R,_L/2K2L2W<95"+0Z>M42%`",BO
MUX/J*`('78V,@TF-#:0PH`*`"@!C]::$QM,04`%`!0`4`%`!0`4`%`!0`4`%
M`!0`4`%`!0`4`%`!0`4`%`"@$G`&30!/';=Y/R%9N?8M1[E@``8`P*S+%H`*
M`%`JU#N2Y=A:U2L9A0`$5+BF4I6&D8K)Q:+3N(S!1R<4)7&0O,3PO`JU$ALB
MJA!0`4`6AT'.?>J)"@`H`@E_UAI,:&4AA0`4`%`#'ZTT)C:8@H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`FCMV;EOE'ZU#FEL4HEE$6,845FV
MV6E8=2&%`!32N)NPX"ME%(S;;"F(*`"@!KNJ#D_A0!"9F9UQP,T`.>(.<@X)
M[&E8=R!E*G!&#2&)0`4`%`%JJ)"@`H`@E_UAI,:&4AA0`4`%`#'ZTT)C:8@H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`'QQ-)]T<>II.20TKEJ.%$Y
MQD^IK)R;+44B2I*"@`H`*`"@`SBJ4FB7&XX&M4TR&K`6"C).!3$0//V3\Z`(
M>M`"K]X?6@"Q0`IP1AAD4`0M#QE#GV[TK#N1=.M(84`6AP!5$A0`4`02_P"L
M-)C0RD,*`"@`H`8_6FA,;3$%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`
M%B")2`S<YZ"LY2>R+BD61P,"LRPH`*`"@`H`*`"@`H`:\BKUY/I32;$V0RDE
MSDUN9#*`"@!5^\/K0!8H`*`$;[I^E`%:I&%`RT.@JB0H`*`()?\`6&DQH92&
M%`!0`4`,?K30F-IB"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@"U#_JA6
M4MS1;$@.*D8X$&D,6@`H`*`"@!&8*.3BFE<"%YB>%X%6HD-D54(<26)--,0E
M,04`*OWA]:`+%`!0`C?=/TH`K5(PH&6AT&:HD*`"@""7_6&DQH92&%`!0`4`
M,?K30F-IB"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@"U#_JA64MS1;#Z
M0PH`<&]:5@'`YI#`D`9/%`$+S=D_.K4>Y+D1$DG)ZU1(E,`H`5>C?3^M-"84
MQ!0`J_>'UH`L4`%`"-]T_2@"M4C"@9:'(%42%`!0!!+_`*PTF-#*0PH`*`"@
M!C]::$QM,04`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`6H?\`5"LI;FBV
M'TAA0`4`+0!`[%F.3TJTB&-I@%`!0`4`*O1OI_6FA,*8@H`5?O#ZT`6*`"@!
M&^Z?I0!6J1A0,M#H*HD*`"@""7_6&DQH92&%`!0`4`,?K30F-IB"@`H`*`"@
M`H`*`"@`H`*`"@`H`*`"@`H`*`"@"U#_`*H5E+<T6P^D,*`"@`H`@;[Q^M6B
M!*8!0`4`%`"KT;Z?UIH3"F(*`%7[P^M`%B@`H`1ONGZ4`5JD84#+0Z51(4`%
M`$$O^L-)C0RD,*`"@`H`8_6FA,;3$%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!
M0`4`%`%J'_5"LI;FBV'TAA0`4`%`$#?>/UJT0)3`*`"@`H`5>C?3^M-"84Q!
M0`J_>'UH`L4`%`"-]T_2@"M4C"@9:`P`*HD*`"@""7_6&DQH92&%`!0`4`,?
MK30F-IB"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@"U#_`*H5E+<T6P^D
M,*`"@`H`@;[Q^M6B!*8!0`4`%`"KT;Z?UIH3"F(*`%7[P^M`%B@`H`1ONGZ4
M`5JD84#+542%`!0!!+_K#28T,I#"@`H`*`&/UIH3&TQ!0`4`%`!0`4`%`!0`
M4`%`!0`4`%`!0`4`%`!0!:A_U0K*6YHMA](84`%`!0!`WWC]:M$"4P"@`H`*
M`%7HWT_K30F%,04`*OWA]:`+%`!0`C?=/TH`K5(PH&6@,`#TJB0H`*`()?\`
M6&DQH92&%`!0`4`,?K30F-IB"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@"U#_JA64MS1;#Z0PH`*`"@"!OO'ZU:($I@%`!0`4`*O1OI_6FA,*8@H`5?O
M#ZT`6*`"@!&^Z?I0!6J1A0,M51(4`%`$$O\`K#28T,I#"@`H`*`&/UIH3&TQ
M!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0!:A_P!4*REN:+8?2&%`!0`4
M`0-]X_6K1`E,`H`*`"@!5Z-]/ZTT)A3$%`"K]X?6@"Q0`4`(WW3]*`*U2,D2
M%FZ\"I<BDB8#``ZU2DF2U8*H04`02_ZPTF-#*0PH`*`"@!C]::$QM,04`%`!
M0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`6H?]4*REN:+8?2&%`!0`4`0-]X_6
MK1`E,`H`*`"@!5Z-]/ZTT)A3$%`"K]X?6@"Q0`4`(WW3]*`$CC4`'J3SS6,G
MJ:)$E24%`"8JU-]27$2M$TR&K$$O^L-#!#*0PH`*`"@!C]::$QM,04`%`!0`
M4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`6H?]4*REN:+8?2&%`!0`4`0-]X_6K1
M`E,`H`*`"@!5Z-]*:$PIB"@!5^\/K0!8H`*`$;[I^E`#D^XOTK![FJV%I#"@
M`H`*-@(I(B3N7KZ5:GW(Y>Q`00<'BJ$%,`H`*`&/UIH3&TQ!0`4`%`!0`4`%
M`!0`4`%`!0`4`%`!0`4`%`!0!:A_U0K*6YHMA](84`%`!0!`WWC]:M$"4P"@
M`H`*`%7N/:A"850@H`5?O#ZT`6*`"@!&^Z?I0`Y/N+]*P>YJMA:0PH`*`"@`
MH`:RAQ@BFG835R%XBOW>15J1+1'5""@!C]::$QM,04`%`!0`4`%`!0`4`%`!
M0`4`%`!0`4`%`!0`4`6H?]4*REN:+8?2&%`!0`4`0-]X_6K1`E,`H`*`"@!5
MZT(050@H`5?O#ZT`6*`"@!&^Z?I0`Y/N+]*P>YJMA:0PH`*`"@`H`*`"@!CQ
MJ_/0^M-.PFKD#QLG;CUK1.Y+5B)^M4B6-IB"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@"U#_`*H5E+<T6P^D,*`"@`H`@;[Q^M6B!*8!0`4`%`"K]X?6
M@`JB0H`5?O#ZT`6*`"@!&^Z?I0`B'"CZ5B]S1;#P<U)0M`!0`4`%`!0`4`%`
M!0!#+;AN5X/Z5:G;<EQ*S(R'##%:)ID-6&TQ!0`4`%`!0`4`%`!0`4`%`!0`
M4`%`!0`4`%`%J'_5"LI;FBV'TAA0`4`%`$#?>/UJT0)3`*`"@`H`*`'-]X_6
MJ)$H`5?O#ZT`6*`"@!&^Z?I0`U?NCZ5D]S1;"TAC@U*P#@<TAA0`4`%`!0`4
M`%`!0`C*&&&&133L!7DMCUC_`"-6I]R''L0$$'!&#6A`E`!0`4`%`!0`4`%`
M!0`4`%`!0`4`%`!0!:A_U0K*6YHMA](84`%`!0!`WWC]:M$"4P"@`H`*`"@!
M3U_"J)"@!5^\/K0!8H`*`$;[I^E`#5^Z/I63W-%L+2&%`"T`*&]:5@'4AA0`
M4`%`!0`4`%`!0`UXU<?,/QIIM":N5I+=E.5^8?K6BFF0XD-62%`!0`4`%`!0
M`4`%`!0`4`%`!0`4`6H?]4*REN:+8?2&%`!0`4`0-]X_6K1`E,`H`*`"@`H`
M4]!]*:)"F`J_>'UH`L4`%`"-]T_2@!%^Z*R>YHM@I#"@`H`*`%!Q2`<&HL,6
MD`4`%`!0`4`%`!0`4`1R0H_.,'U%4I-$N*95>)TZCCU%:J29#30RF(*`"@`H
M`*`"@`H`*`"@`H`*`+4/^J%92W-%L/I#"@`H`*`(&^\?K5H@2F`4`%`!0`4`
M+_"/RIH3"F(5?O#ZT`6*`"@`H`;6<MRXA4E!0`4`%`!0`4`*#BD`X'-(8M`!
M0`4`%`!0`4`%``>1@T`5YH4QD$*?2M(R9#BBM6A`4`%`!0`4`%`!0`4`%`!0
M!:A_U0K*6YHMA](84`%`!0!`WWC]:M$"4P"@`H`*`"@!?X?QIH3"F(5?O#ZT
M`6*`"@`H`0]:F2T''<2LS0*`"@`H`*`"@`H`*`'!O6E8!W6D,*`"@`H`*``D
M`9/%`$+S=E'XFK4>Y+D1$ECDG-420U9(4`%`!0`4`%`!0`4`%`!0!:A_U0K*
M6YHMA](84`%`!0!`WWC]:M$"4P"@`H`*`"@!1T--"84Q"K]X?6@"Q0`4`%`"
M-TH`2L34*`"@`H`*`"@`H`*`"@!:`%#>M*P#J0PH`C>8#A>35*)+9`S%CR<U
M:5B1*8!0!%5$A0`4`%`!0`4`%`!0`4`%`%J'_5"LI;FBV'TAA0`4`%`$#?>/
MUJT0)3`*`"@`H`*`%7HWTIH3"F(5?O#ZT`6*`"@`H`*`&BLI;EQV"D4%`!0`
M4`%`!0`4`%`!0`4`*#BD!`[L_7IZ5HE8ANXVF`4`%`!0!%5$A0`4`%`!0`4`
M%`!0`4`%`%J'_5"LI;FBV'TAA0`4`%`$#?>/UJT0)3`*`"@`H`*`%7HWT_K3
M0F%,0J_>'UH`L4`%`!0`4`-/6IDM"HA6984`%`!0`4`%`!0`4`%`!0`4`5ZT
M("@`H`*`"@"*J)"@`H`*`"@`H`*`"@`H`*`+4/\`JA64MS1;#Z0PH`*`"@"!
MOO'ZU:($I@%`!0`4`%`"KT;Z?UIH3"F(5?O#ZT`6*`"@`H`*`$;UI-70T)61
MH%`!0`4`%`!0`4`%`!0`4`%`%>M"`H`*`"@`H`BJB0H`*`"@`H`*`"@`H`*`
M"@"U#_JA64MS1;#Z0PH`*`"@"!OO'ZU:($I@%`!0`4`%`"KT;Z?UIH3"F(5?
MO#ZT`6*`"@`H`*``\B@!HZ5E+<T6P4AA0`4`%`!0`4`%`!0`4`%`%>M"`H`*
M`"@`H`BJB0H`*`"@`H`*`"@`H`*`"@"U#_JA64MS1;#Z0PH`*`"@"!OO'ZU:
M($I@%`!0`4`%`"KT;Z?UIH3"F(5?O#ZT`6*`"@`H`*`"@!O>HFBHA4%A0`4`
M%`!0`4`%`!0`4`%`%>M"`H`*`"@`H`BJB0H`*`"@`H`*`"@`H`*`"@"U#_JA
M64MS1;#Z0PH`*`"@"!OO'ZU:($I@%`!0`4`%`"KT;Z?UIH3"F(5?O#ZT`6*`
M"@`H`*`"@!&[&DU=#6XE9&@4`%`!0`4`%`!0`4`%`!0!7K0@*`"@`H`*`(JH
MD*`"@`H`*`"@`H`*`"@`H`M0_P"J%92W-%L/I#"@`H`*`(&^\?K5H@2F`4`%
M`!0`4`*O1OI_6FA,*8@#!6!)[T`6001D'(H`*`"@`H`*``]*`&UD]&:(*0PH
M`*`"@`H`*`"@`H`*`*]:$!0`4`%`!0!%5$A0`4`%`!0`4`%`!0`4`%`%J'_5
M"LI;FBV'TAA0`4`%`$#?>/UJT0)3`*`"@`H`*``,N&Y[4T)C2_I3$,H`<CLA
MRIH`L1SJW#?*?TH`EH`*`"@`H`8ISGV-9RW+CL+4E!0`4`%`!0`4`%`!0`4`
M5ZT("@`H`*`"@"*J)"@`H`*`"@`H`*`"@`H`*`)X90%"GCWJ)1ZE)DW6H+"@
M`H`*`(&^\?K5H@2F`4`%`"$@46$,+$T["$I@%`!0`4`%`$D<K)[CT-`%A)5?
MH<'TH`?0`4`,7^+ZUG+<N.PM24%`!0`4`%`!0`4`%`!0!7K0@*`"@`H`*`(J
MHD*`"@`H`*`"@`H`*`"@`H`*`'I(R=#QZ&DTF-.Q.DJOQT/I6;BT6G<?2&%`
M$#?>/UJT0)3`"0.M`#"Q[4["N-IB"@`H`*`"@`H`*`"@`H`F2=EX;D?K0!85
ME<94YH`:O\7UK.6Y<=A:DH*`"@`H`*`"@`H`*`"@"O6A`4`%`!0`4`151(4`
M%`!0`4`%`!0`4`%`!0`4`%`!0!*DQ7AN1^M2XE*1.K!QD&LVK%)W(6^\?K5H
MEC"WI56%<9UIB"@`H`*`"@`H`*`"@`H`*`"@`H`4$J<@X(H`7>V<Y.:-P)DG
M!X;CWK-Q[%J1+UJ2@H`*`"@`H`*`"@`H`KUH0%`!0`4`%`$542%`!0`4`%`!
M0`4`%`!0`4`%`!0`4`%`"@D'(X-``26.30`E`!0`4`%`!0`4`%`!0`4`%`!0
M`4`%`!0`4`%`#TD9.G3TI-)C3L3I*K>Q]#6;BT6G<?2&%`!0`4`%`!0!7K0@
M*`"@`H`*`(JHD*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`E28KPW(J7&Y2D3JP<9!K-JQ2=Q:!A0
M`4`%`%>M"`H`*`"@`)QUH`BJB0H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@
M`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`4$@Y!Q0!,D_9_SJ
M''L4I=R8$$9!S4%A0`4`5ZT("@`H`:6]*=A7&DYIB$H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`<CE#D&DU<:=B=)@V`>#4.-BDR2I**]:$"%@*+"N,))ZU0A*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@"1)63W'I4N*8T[#2Q-.PAM,`H`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
#`/_9
`

#End
