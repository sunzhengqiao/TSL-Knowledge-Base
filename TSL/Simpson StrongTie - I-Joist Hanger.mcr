#Version 7
#BeginDescription
Version No. 1.1, 2006-03-15, David Rueda (dr@hsb-cad.com), TSL Team, Quito, Ecuador.
  - reportMessage "joist width + model" erased
  - regrouped properties 
Version No. 1.1 , 2006-02-24 , David Rueda (dr@hsb-cad.com), TSL Team, Quito, Ecuador.
  - Description of property prdMaleHeightTlorenace added
Version No. 1.0 (Initial), 2006-02-23 , David Rueda (dr@hsb-cad.com), TSL Team, Quito, Ecuador.
#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
//Units
U(1,"mm");

double dHh; //Hanger height
double dHw;//Hanger width
double dHth = 1.2;//Hanger thickness
double dHch = 51;//Hanger core height ( B dimension in pdf specifications )
String strarrJoistW [] = {"40mm", "45mm" };
double darrJoistW [] = { 40, 45 };
String strarrModel [] = { "IUS1.56/9.5", "IUS1.56/11.88", "IUS1.81/9.5", "IUS1.81/11.88" };//Model
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
double darrHeights[] = { 241, 302 };//Male beam possible heights


//propierties
PropDouble prdMaleWidthTlorenace ( 0, 0, T("Male Tolerance"));
PropDouble prdMaleHeightTlorenace ( 1, 0, T("Female Tolerance"));
prdMaleWidthTlorenace.setDescription("If beam is smallest that expected by manufacturer, a measure of tolerance can be added");
prdMaleHeightTlorenace.setDescription("If beam is smallest that expected by manufacturer, a measure of tolerance can be added");
PropString prstrModel (0, strarrModel, T("Model"), 0 );

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


//Stretch beam
Cut ct (_Pt0,_X0);
_Beam0.addTool(ct,TRUE);

//Get male beam sizes
dMw = _Beam0.dD(_X1);
dMh = _Beam0.dD(_Y1);

//Verify male beam width
//Determinate right hanger depending on male beam width
int flag =-1;
int flag2 = -1;
for ( int i = 0; i < darrJoistW.length(); i++)
{
	dRankH = darrJoistW [i];
	dRankL = darrJoistW [i] - prdMaleWidthTlorenace;
	
	if ( dMw  <= dRankH && dMw  >= dRankL)
	{
		for ( int j = 0; j < darrHeights.length(); j++ )
		{
		if ( dMh <=	darrHeights [ j ] && dMh >= darrHeights [ j ] - prdMaleHeightTlorenace)
			{
			flag2 = j;
			dHh = darrHeights [ j ];//Get hanger's height according to male beam´s height
			break
			}
		}
		if ( flag2 != -1 )
			{
			dHw = darrJoistW [i];
			flag = i;
			break
			}
	dHw = darrJoistW [i];
	flag = i;	
	}
}	

if ( flag == -1 || flag2 == -1)
{
	reportMessage ("\nMale beam doesn´t fit in hanger");
	eraseInstance();

}

//Check female size
if ( _W1 < dHh * .6)
{
	reportMessage ( "\nFemale beam not higher enough" );
	eraseInstance();
}

int iModelIndex = flag + flag2;
if (flag > flag2 || flag == flag2 && flag != 0)
	iModelIndex += 1;

//Verify male and female's bottom faces are aligned
Point3d ptMaleBottom = _Beam0.ptCen() - vecMaleZ * dMh * .5;
Point3d ptHangerBottom = _Beam1.ptCen() + _Y1 * (_W1 * .5 - dHh );

if ( 1 - abs(vecMaleZ.dotProduct( _Y1)) > 0.0001 || abs( _Y1.dotProduct ( ptHangerBottom - ptMaleBottom )) > 0.0001 )
{
	reportMessage ( "\nWrong ubication of male beam");
	eraseInstance ();
}

//Hanger can be used!!!

//Propierty: model
prstrModel.set ( strarrModel [ iModelIndex ] );
prstrModel.setReadOnly ( TRUE );


//Start to drawing
Point3d ptRef = _Pt0 - vecMaleZ * dMh * .5;//Reference point: MOVING POINT
Display dspl (0);

//Bottom plate
PLine pl1 ( -vecMaleZ );
pl1.addVertex ( ptRef + vecMaleY * ( dHw *  .5  + dHth ) - _X0 * dHch * .25 );
pl1.addVertex ( ptRef + vecMaleY * ( dHw *  .5  + dHth ) - _X0 * dHch);
pl1.addVertex ( ptRef - vecMaleY *  ( dHw *  .5  + dHth )- _X0 * dHch);
pl1.addVertex ( ptRef - vecMaleY *  ( dHw *  .5  + dHth ) - _X0 * dHch * .25 );
pl1.close();
Body bd1 ( pl1, -vecMaleZ * dHth, 1 );
dspl.draw ( bd1 );


//Lateral plate
PLine pl2 ( vecMaleY );
ptRef += vecMaleY * dHw * .5;
//pl2.addVertex ( ptRef + vecMaleZ * dHh * .1 - _X0 * dHch * .15 );

pl2.addVertex ( ptRef - _X0 * dHch * .2 );
pl2.addVertex ( ptRef + vecMaleZ * dHh * .1 - _X0 * dHch * .2 );
pl2.addVertex ( ptRef + vecMaleZ * dHh * .15 );
pl2.addVertex ( ptRef + vecMaleZ * dHh * .93);
pl2.addVertex ( ptRef + vecMaleZ * dHh * .93 - _X0 * dHch * .35 );
pl2.addVertex ( ptRef + vecMaleZ * dHh * .5 - _X0 * dHch * .35 );
pl2.addVertex ( ptRef + vecMaleZ * dHh * .4 - _X0 * dHch * .6 );
pl2.addVertex ( ptRef + vecMaleZ * dHh * .2 - _X0 * dHch * .6 );
pl2.addVertex ( ptRef + vecMaleZ * dHh * .1 - _X0 * dHch );
pl2.addVertex ( ptRef - _X0 * dHch );
pl2.close ();
Body bd2 ( pl2, vecMaleY * dHth, 1);
dspl.draw ( bd2 );
bd2.transformBy ( -vecMaleY * ( dHw + dHth ) );
dspl.draw ( bd2 );

//Bend in lateral plate
ptRef += vecMaleZ * dHh * .93;
double dAngle = 45;
Vector3d vecAxis1 = vecMaleZ.rotateBy ( dAngle, _X0 );
Vector3d vecNormal = vecAxis1.rotateBy ( 90, _X0 );
Vector3d vecAxis2 = vecAxis1.rotateBy ( 90, vecNormal );
PLine pl3 ( vecNormal );
pl3.addVertex ( ptRef );
pl3.addVertex ( ptRef + vecAxis1 * dHh * .07 );
pl3.addVertex ( ptRef + vecAxis1 * dHh * .07 + vecAxis2 * dHch * .35 );
pl3.addVertex ( ptRef + vecAxis2 * dHch * .35 );
pl3.close();
Body bd3 ( pl3, vecMaleY * dHth, 1);
dspl.draw ( bd3 );
CoordSys crdsys ( _Pt0, _X0, _Y0, _Z0 );
crdsys.setToRotation ( 180, vecMaleZ, _Pt0 -_X0 * dHch * .35 * .5 );
bd3.transformBy ( crdsys );
dspl.draw ( bd3 );

//Legs
ptRef -= vecMaleZ * dHh * .93 - vecMaleY * dHth;
PLine pl4 ( -_X0 );
pl4.addVertex ( ptRef + vecMaleZ * dHh * .15 );
pl4.addVertex ( ptRef + vecMaleZ * dHh * .25 + vecMaleY * dHw * .5 );
pl4.addVertex ( ptRef + vecMaleZ * dHh * .4 + vecMaleY * dHw * .5 );
pl4.addVertex ( ptRef + vecMaleZ * dHh * .45 + vecMaleY * dHw * .7 );
pl4.addVertex ( ptRef + vecMaleZ * dHh * .95 + vecMaleY * dHw * .7 );
pl4.addVertex ( ptRef + vecMaleZ * dHh * .98 + vecMaleY * dHw * .55 );
pl4.addVertex ( ptRef + vecMaleZ * dHh * .98 + vecMaleY * dHw * .4 );
pl4.addVertex ( ptRef + vecMaleZ * ( dHh + dHth ) + vecMaleY * dHw * .4 );
pl4.addVertex ( ptRef + vecMaleZ * ( dHh + dHth ) + vecMaleY * dHw * .15 );
pl4.addVertex ( ptRef + vecMaleZ * dHh * .98 + vecMaleY * dHw * .15 );
pl4.addVertex ( ptRef + vecMaleZ * dHh * .98 );
pl4.close();
Body bd4 ( pl4, -_X0 * dHth, 1); 
dspl.draw ( bd4 );
crdsys.setToRotation ( 180, vecMaleZ, _Pt0 - _X0 * dHth  * .5 );
bd4.transformBy ( crdsys );
dspl.draw ( bd4 );

//Bended legs
ptRef += vecMaleZ * dHh + vecMaleY * dHw * .15  ;
PLine pl5 ( vecMaleZ );
pl5.addVertex ( ptRef );
pl5.addVertex ( ptRef + _X0 * dHw * .35 + vecMaleY * dHw * .12);
pl5.addVertex ( ptRef + _X0 * dHw * .35 + vecMaleY * dHw * .14  );
pl5.addVertex ( ptRef + vecMaleY * dHw * .125 * 2);
pl5.close();
Body bd5 ( pl5, vecMaleZ * dHth, 1 );
dspl.draw ( bd5 );
crdsys.setToRotation ( 180, _X0, _Pt0 + vecMaleZ * ( dHh * .5 + dHth * .5 ));
bd5.transformBy ( crdsys );
dspl.draw ( bd5 );


//Material
setCompareKey(prstrModel); // hanger TypeprstrModel 
model(prstrModel);//Article number
dxaout(T("HANGER"), prstrModel );//Designation
material(T("1.2mm pre-galvanised mild steel"));


//Hardware
Hardware nail ( T("Nails"), T("3.75 x 75mm galvanized round wire Nails"), T("3.75 x 75mm galvanized round wire Nails"), U(75), U(3.75), 8, T("Simpson galvanized round wire nails"));


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
M!0`4`%`!0!)#_K5J9;#6Y;#>M96-!U(84`%`!0`N#C..*=@$I`%`!0`4`->-
M7'S#\::;0FKE62!D&1\PK523(<;$542%`!0`4`%`!0`4`%`!0`4`%`!0`4`%
M`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`$D/\`K14RV&MRS69H
M*#B@!RG<<=Z5@N2B+U/Y5:AW)<AX11T%6HI$MMD3MO;V'2LYRZ%Q74;4%!0`
M4`%`!0`4`120*_(^4^U4I-$N-RM)&T9^8<>O:M4TR&K#*8@H`*`"@`H`*`"@
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
/!0`4`%`!0`4`%`!0`/_9
`

#End
